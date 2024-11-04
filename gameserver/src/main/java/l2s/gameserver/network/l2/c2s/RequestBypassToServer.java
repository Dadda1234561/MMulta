package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.EventHolder;
import l2s.gameserver.data.xml.holder.LimitedShopHolder;
import l2s.gameserver.data.xml.holder.MultiSellHolder;
import l2s.gameserver.handler.admincommands.AdminCommandHandler;
import l2s.gameserver.handler.bbs.BbsHandlerHolder;
import l2s.gameserver.handler.bbs.IBbsHandler;
import l2s.gameserver.handler.bypass.BypassHolder;
import l2s.gameserver.handler.interfacecommands.IInterfaceCommandHandler;
import l2s.gameserver.handler.interfacecommands.InterfaceCommandHandler;
import l2s.gameserver.handler.items.IItemHandler;
import l2s.gameserver.handler.voicecommands.IVoicedCommandHandler;
import l2s.gameserver.handler.voicecommands.VoicedCommandHandler;
import l2s.gameserver.instancemanager.OfflineBufferManager;
import l2s.gameserver.instancemanager.OlympiadHistoryManager;
import l2s.gameserver.model.GameObject;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.Hero;
import l2s.gameserver.model.entity.events.EventType;
import l2s.gameserver.model.entity.events.fightclubmanager.FightClubEventManager;
import l2s.gameserver.model.entity.events.impl.AbstractFightClub;
import l2s.gameserver.model.entity.events.impl.ChaosFestivalEvent;
import l2s.gameserver.model.entity.events.impl.PvPEvent;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.dynamic.DynamicQuestController;
import l2s.gameserver.network.l2.components.ChatType;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.PackageToListPacket;
import l2s.gameserver.network.l2.s2c.SayPacket2;
import l2s.gameserver.utils.BypassStorage.BypassType;
import l2s.gameserver.utils.BypassStorage.ValidBypass;
import l2s.gameserver.utils.MulticlassUtils;
import l2s.gameserver.utils.NpcUtils;
import l2s.gameserver.utils.WarehouseFunctions;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Method;
import java.util.StringTokenizer;

public class RequestBypassToServer extends L2GameClientPacket
{
	private static final Logger _log = LoggerFactory.getLogger(RequestBypassToServer.class);

	private String _bypass = null;

	@Override
	protected boolean readImpl()
	{
		_bypass = readS();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player player = getClient().getActiveChar();
		if(player == null || _bypass.isEmpty())
			return;

		ValidBypass bp = player.getBypassStorage().validate(_bypass);
		if(bp == null)
		{
			_log.debug("RequestBypassToServer: Unexpected bypass : " + _bypass + " client : " + getClient() + "!");
			return;
		}
		if (player.isGM()) {
			player.sendPacket(new SayPacket2(0, ChatType.ALL, "SYS","Bypass: " + bp.bypass));
		}
		NpcInstance npc = player.getLastNpc();
		try
		{
			if(bp.bypass.startsWith("admin_"))
				AdminCommandHandler.getInstance().useAdminCommandHandler(player, bp.bypass);
			else if (bp.bypass.startsWith("pvpevent_")) {
				StringTokenizer st = new StringTokenizer(bp.bypass, " ");
				st.nextToken(); // skip the starting "_fightclub"
				if(st.hasMoreTokens())
				{
					String cmd = st.nextToken();
					switch(cmd)
					{
						case "register":
						{
							int eventId = -1;
							if(st.hasMoreTokens())
							{
								String event = st.nextToken();
								try
								{
									eventId = Integer.parseInt(event);
								}
								catch(NumberFormatException ignored)
								{
									_log.warn("FightClubEngine: invalid event id: " + event);
								}
							}
							if(eventId > 0)
							{
								PvPEvent event = EventHolder.getInstance().getEvent(EventType.CUSTOM_PVP_EVENT, 2);

								if(event != null && event.isRegActive())
									event.reg(player);

							}
							break;
						}
						case "unregister":
						{
							//TODO
						}
					}
				}
			} else if(bp.bypass.startsWith("pcbang?"))
			{
				String command = bp.bypass.substring(7).trim();
				StringTokenizer st = new StringTokenizer(command, "_");

				String cmd = st.nextToken();
				if(cmd.equalsIgnoreCase("multisell"))
				{
					int multisellId = Integer.parseInt(st.nextToken());
					if(!Config.ALT_ALLOWED_MULTISELLS_IN_PCBANG.contains(multisellId))
					{
						_log.warn("Unknown multisell list use in PC-Bang shop! List ID: " + multisellId + ", player ID: " + player.getObjectId() + ", player name: " + player.getName());
						return;
					}
					MultiSellHolder.getInstance().SeparateAndSend(multisellId, player, 0);
				}
			}
			else if(bp.bypass.startsWith("scripts_"))
			{
				_log.error("Trying to call script bypass: " + bp.bypass + " " + player);
			}
			else if(bp.bypass.startsWith("htmbypass_"))
			{
				String command = bp.bypass.substring(10).trim();
				String word = command.split("\\s+")[0];
				String args = command.substring(word.length()).trim();

				Pair<Object, Method> b = BypassHolder.getInstance().getBypass(word);
				if(b != null)
				{
					try
					{
						b.getValue().invoke(b.getKey(), player, npc, StringUtils.isEmpty(args) ? new String[0] : args.split("\\s+"));
					}
					catch(Exception e)
					{
						_log.error("Exception: " + e, e);
					}
				}
				else
					_log.warn("Cannot find html bypass: " + command);
			}
			else if(bp.bypass.startsWith("user_"))
			{
				String command = bp.bypass.substring(5).trim();
				String word = command.split("\\s+")[0];
				String args = command.substring(word.length()).trim();
				IVoicedCommandHandler vch = VoicedCommandHandler.getInstance().getVoicedCommandHandler(word);

				if(vch != null)
					vch.useVoicedCommand(word, player, args);
				else
					_log.warn("Unknow voiced command '" + word + "'");
			}
			else if(bp.bypass.startsWith("npc_"))
			{
				int endOfId = bp.bypass.indexOf('_', 5);
				String id;
				if(endOfId > 0)
					id = bp.bypass.substring(4, endOfId);
				else
					id = bp.bypass.substring(4);
				if(npc != null && npc.canBypassCheck(player))
				{
					String command = bp.bypass.substring(endOfId + 1);
					npc.onBypassFeedback(player, command);
				}
			}
			else if(bp.bypass.startsWith("npc?"))
			{
				if(npc != null && npc.canBypassCheck(player))
				{
					String command = bp.bypass.substring(4).trim();
					npc.onBypassFeedback(player, command);
				}
			}
			else if (bp.bypass.startsWith("_item_")) {
				int endOfId = bp.bypass.indexOf('_', 7);
				String id;
				if(endOfId > 0)
					id = bp.bypass.substring(6, endOfId);
				else
					id = bp.bypass.substring(6);
				int itemObjectId = 0;
				try {
					itemObjectId = Integer.parseInt(id);
				} catch (NumberFormatException e) {
					e.printStackTrace();
				}

				ItemInstance item = player.getInventory().getItemByObjectId(itemObjectId);
				if (item == null) {
					_log.warn(player.getName() + " tried itemBypass but no item with objId=" + itemObjectId + " is found.");
					// close any open wnds
					// player.sendPacket(new NpcHtmlMessagePacket(0, itemObjectId, false, "skip_window=1 \t"));
				} else {
					String command = bp.bypass.substring(endOfId + 1);
					IItemHandler handler = item.getTemplate().getHandler();
					if (handler != null) {
						handler.onBypass(player, item, command);
					}
				}
			}
			else if(bp.bypass.startsWith("item?"))
			{
			}
			else if(bp.bypass.startsWith("class_change?"))
			{
				String command = bp.bypass.substring(13).trim();
				if(command.startsWith("class_name="))
				{
					if(npc != null && npc.canBypassCheck(player))
					{
						int classId = Integer.parseInt(command.substring(11).trim());
						npc.onChangeClassBypass(player, classId);
					}
				}
			}
			else if(bp.bypass.startsWith("quest_accept?"))
			{
				String command = bp.bypass.substring(13).trim();
				if(command.startsWith("quest_id="))
				{
					if(npc != null && npc.canBypassCheck(player))
					{
						int questId = Integer.parseInt(command.substring(9).trim());
						player.processQuestEvent(questId, Quest.ACCEPT_QUEST_EVENT, npc);
					}
				}
			}
			else if(bp.bypass.startsWith("_olympiad?")) // _olympiad?command=move_op_field&field=1
			{
				// Переход в просмотр олимпа разрешен только от менеджера или с арены.
				final NpcInstance manager = NpcUtils.canPassPacket(player, this, bp.bypass.split("&")[0]);
				if(manager != null)
					manager.onBypassFeedback(player, bp.bypass);
			}
			else if(bp.bypass.startsWith("pledgegame?")) // pledgegame?command=op_field_list
			{
				// Переход в просмотр фестиваля хаоса разрешен только от менеджера или с арены.
				final NpcInstance manager = NpcUtils.canPassPacket(player, this, bp.bypass);
				if(manager != null)
					manager.onBypassFeedback(player, bp.bypass);
			}
			else if(bp.bypass.equalsIgnoreCase("_heroes"))
			{
				// Просмотр героев олимпиады.
				final NpcInstance manager = NpcUtils.canPassPacket(player, this, bp.bypass);
				if(manager != null)
					manager.onBypassFeedback(player, bp.bypass);
			}
			else if(bp.bypass.startsWith("_diary"))
			{
				String params = bp.bypass.substring(bp.bypass.indexOf("?") + 1);
				StringTokenizer st = new StringTokenizer(params, "&");
				int heroclass = Integer.parseInt(st.nextToken().split("=")[1]);
				int heropage = Integer.parseInt(st.nextToken().split("=")[1]);
				int heroid = Hero.getInstance().getHeroByClass(heroclass);
				if(heroid > 0)
					Hero.getInstance().showHeroDiary(player, heroclass, heroid, heropage);
			}
			else if(bp.bypass.startsWith("_match"))
			{
				String params = bp.bypass.substring(bp.bypass.indexOf("?") + 1);
				StringTokenizer st = new StringTokenizer(params, "&");
				int heroclass = Integer.parseInt(st.nextToken().split("=")[1]);
				int heropage = Integer.parseInt(st.nextToken().split("=")[1]);

				OlympiadHistoryManager.getInstance().showHistory(player, heroclass, heropage);
			}
			else if(bp.bypass.startsWith("manor_menu_select?")) // Navigate throught Manor windows
			{
				GameObject object = player.getTarget();
				if(object != null && object.isNpc())
					((NpcInstance) object).onBypassFeedback(player, bp.bypass);
			}
			else if(bp.bypass.startsWith("menu_select?"))
			{
				if(npc != null && npc.canBypassCheck(player))
				{
					String params = bp.bypass.substring(bp.bypass.indexOf("?") + 1);
					StringTokenizer st = new StringTokenizer(params, "&");
					int ask = Integer.parseInt(st.nextToken().split("=")[1].trim());
					long reply = st.hasMoreTokens() ? Long.parseLong(st.nextToken().split("=")[1].trim()) : 0L;
					int state = st.hasMoreTokens() ? Integer.parseInt(st.nextToken().split("=")[1].trim()) : 0;
					npc.onMenuSelect(player, ask, reply, state);
				}
			}
			else if(bp.bypass.startsWith("multimperia?"))
			{
				String command = bp.bypass.substring(12);
				IInterfaceCommandHandler handler = InterfaceCommandHandler.getInstance().getInterfaceCommandHandler(command);
				if (handler != null) {
					handler.useInterfaceCommand(command, player);
				}
			}
			else if(bp.bypass.equals("talk_select"))
			{
				if(npc != null && npc.canBypassCheck(player))
					npc.showQuestWindow(player);
			}
			else if(bp.bypass.equals("teleport_request"))
			{
				if(npc != null && npc.canBypassCheck(player))
					npc.onTeleportRequest(player);
			}
			else if(bp.bypass.equals("learn_skill"))
			{
				if(npc != null && npc.canBypassCheck(player))
					npc.onSkillLearnBypass(player);
			}
			else if(bp.bypass.equals("deposit"))
			{
				if(npc != null && npc.canBypassCheck(player))
					WarehouseFunctions.showDepositWindow(player);
			}
			else if(bp.bypass.equals("withdraw"))
			{
				if(npc != null && npc.canBypassCheck(player))
					WarehouseFunctions.showRetrieveWindow(player);
			}
			else if(bp.bypass.equals("deposit_pledge"))
			{
				if(npc != null && npc.canBypassCheck(player))
					WarehouseFunctions.showDepositWindowClan(player);
			}
			else if(bp.bypass.equals("withdraw_pledge"))
			{
				if(npc != null && npc.canBypassCheck(player))
					WarehouseFunctions.showWithdrawWindowClan(player);
			}
			else if(bp.bypass.equals("package_deposit"))
			{
				if(npc != null && npc.canBypassCheck(player))
					player.sendPacket(new PackageToListPacket(player));
			}
			else if(bp.bypass.equals("package_withdraw"))
			{
				if(npc != null && npc.canBypassCheck(player))
					WarehouseFunctions.showFreightWindow(player);
			}
			else if(bp.bypass.startsWith("Quest "))
			{
				_log.warn("Trying to call Quest bypass: " + bp.bypass + ", player: " + player);
			}
			else if(bp.bypass.startsWith("buffstore?"))
			{
				OfflineBufferManager.getInstance().processBypass(player, bp.bypass.substring(10).trim());
			}
			else if(bp.bypass.startsWith("Campaign "))
			{
				String p = bp.bypass.substring(9).trim();

				int idx = p.indexOf(' ');
				if(idx > 0)
				{
					String campaignName = p.substring(0, idx);
					DynamicQuestController.getInstance().processDialogEvent(campaignName, p.substring(idx).trim(), player);
				}
			}
			else if(bp.bypass.startsWith("chaosfestival_"))
			{
				String p = bp.bypass.substring(14).trim();

				ChaosFestivalEvent event = EventHolder.getInstance().getEvent(EventType.PVP_EVENT, 6);
				if(event != null)
					event.onBypassCommand(player, p);
			}
			else if(bp.bypass.startsWith("_fightclub")) // TODO: Нафиг данный хардкод в данном месте? о.0
			{
				StringTokenizer st = new StringTokenizer(bp.bypass, " ");
				st.nextToken(); // skip the starting "_fightclub"
				if(st.hasMoreTokens())
				{
					String cmd = st.nextToken();
					switch(cmd)
					{
						case "register":
						{
							int eventId = -1;
							if(st.hasMoreTokens())
							{
								String event = st.nextToken();
								try
								{
									eventId = Integer.parseInt(event);
								}
								catch(NumberFormatException ignored)
								{
									_log.warn("FightClubEngine: invalid event id: " + event);
								}
							}
							if(eventId > 0)
							{
								AbstractFightClub event = EventHolder.getInstance().getEvent(EventType.FIGHT_CLUB_EVENT, eventId);
								if(event != null)
								{
									if(!FightClubEventManager.getInstance().isRegistrationOpened(event))
									{
										player.sendMessage(new CustomMessage("scripts.events.Late").toString(player));
										return;
									}

									FightClubEventManager.getInstance().trySignForEvent(player, event, false);
								}
							}
							break;
						}
						case "unregister":
						{
							if(!FightClubEventManager.getInstance().isPlayerRegistered(player))
								return;

							// unregister from all events
							FightClubEventManager.getInstance().unsignFromEvent(player);
							break;
						}
					}
				}
			}
			else if(bp.bypass.startsWith("pvpevent_")) // TODO: Нафиг данный хардкод в данном месте? о.0
			{
				String[] temp = bp.bypass.split(";");

				for(String bypass : temp)
				{
					if(bypass.startsWith("pvpevent"))
					{
						StringTokenizer st = new StringTokenizer(bypass, "_");
						st.nextToken();
						String cmd = st.nextToken();
						int val = Integer.parseInt(st.nextToken());

						if(cmd.equalsIgnoreCase("showReg"))
						{
							PvPEvent event = EventHolder.getInstance().getEvent(EventType.CUSTOM_PVP_EVENT, val);
							if(event != null && event.isRegActive())
							{
								event.showReg();
							}
						}
						else if(cmd.startsWith("reg"))
						{
							PvPEvent event = EventHolder.getInstance().getEvent(EventType.CUSTOM_PVP_EVENT, val);
							if(event != null && event.isRegActive())
								if(cmd.contains(":"))
									event.regCustom(player, cmd);
								else
									event.reg(player);
						}
					}
					else
					{
						IBbsHandler handler = BbsHandlerHolder.getInstance().getCommunityHandler(bypass);
						if(handler != null)
						{
							handler.onBypassCommand(player, bypass);
						}
					}
				}
			}
			else if(bp.bypass.startsWith("multiclass?"))
			{
				MulticlassUtils.onBypass(player, bp.bypass.substring(11).trim());
			}
			else if(bp.type == BypassType.BBS)
			{
				if(!Config.BBS_ENABLED)
					player.sendPacket(SystemMsg.THE_COMMUNITY_SERVER_IS_CURRENTLY_OFFLINE);
				else
				{
					IBbsHandler handler = BbsHandlerHolder.getInstance().getCommunityHandler(bp.bypass);
					if(handler != null)
						handler.onBypassCommand(player, bp.bypass);
				}
			}
			else if(bp.bypass.startsWith("limitshop"))
			{
				final int limitedShopId = Integer.parseInt(bp.bypass.substring(9).trim());
				LimitedShopHolder.getInstance().SeparateAndSend(limitedShopId, player);
			}
		}
		catch(Exception e)
		{
			String st = "Error while handling bypass: " + bp.bypass;
			if(npc != null)
				st = st + " via NPC " + npc;

			_log.error(st, e);
		}
	}
}