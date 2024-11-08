package npc.model.residences.clanhall;

import java.util.List;
import java.util.StringTokenizer;

import org.apache.commons.lang3.StringUtils;
import l2s.commons.collections.CollectionUtils;
import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.dao.SiegeClanDAO;
import l2s.gameserver.dao.SiegePlayerDAO;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.events.impl.ClanHallTeamBattleEvent;
import l2s.gameserver.model.entity.events.objects.CTBSiegeClanObject;
import l2s.gameserver.model.entity.events.objects.SiegeClanObject;
import l2s.gameserver.model.entity.residence.ClanHall;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.utils.TimeUtils;
import quests._504_CompetitionForTheBanditStronghold;

/**
 * @author VISTALL
 * @date 11:15:08/11.07.2010
 */
public class BanditMessagerInstance extends NpcInstance
{
	public BanditMessagerInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(final Player player, final String command)
	{
		ClanHall clanHall = getClanHall();
		ClanHallTeamBattleEvent siegeEvent = clanHall.getSiegeEvent();
		Clan clan = player.getClan();

		if(command.equalsIgnoreCase("registrationMenu"))
		{
			if(!checkCond(player, true))
				return;

			showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_1.htm", false);
		}
		else if(command.equalsIgnoreCase("registerAsClan"))
		{
			if(!checkCond(player, false))
				return;

			List<CTBSiegeClanObject> siegeClans = siegeEvent.getObjects(ClanHallTeamBattleEvent.ATTACKERS);

			CTBSiegeClanObject siegeClan = siegeEvent.getSiegeClan(ClanHallTeamBattleEvent.ATTACKERS, clan);
			if(siegeClan != null)
			{
				showFlagInfo(player, siegeClans.indexOf(siegeClan));
				return;
			}

			QuestState questState = player.getQuestState(504);
			if(questState == null || questState.getQuestItemsCount(5009) != 1)
			{
				showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_24.htm", false);
				return;
			}

			questState.abortQuest();
			register(player);
		}
		else if(command.equalsIgnoreCase("registerByOffer"))
		{
			if(!checkCond(player, false))
				return;

			List<CTBSiegeClanObject> siegeClans = siegeEvent.getObjects(ClanHallTeamBattleEvent.ATTACKERS);

			CTBSiegeClanObject siegeClan = siegeEvent.getSiegeClan(ClanHallTeamBattleEvent.ATTACKERS, clan);
			if(siegeClan != null)
			{
				showFlagInfo(player, siegeClans.indexOf(siegeClan));
				return;
			}

			if(!player.consumeItem(ItemTemplate.ITEM_ID_ADENA, 200000, true))
			{
				showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_26.htm", false);
				return;
			}
			register(player);
		}
		else if(command.equalsIgnoreCase("viewNpc"))
		{
			CTBSiegeClanObject siegeClan = siegeEvent.getSiegeClan(ClanHallTeamBattleEvent.ATTACKERS, player.getClan());
			if(siegeClan == null)
			{
				showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_7.htm", false);
				return;
			}

			String file;
			switch((int)siegeClan.getParam())
			{
				case 0:
					file = "residence2/clanhall/agit_oel_mahum_messeger_10.htm";
					break;
				case 35428: // berserker
					file = "residence2/clanhall/agit_oel_mahum_messeger_11.htm";
					break;
				case 35429: // scout
					file = "residence2/clanhall/agit_oel_mahum_messeger_12.htm";
					break;
				case 35430:
					file = "residence2/clanhall/agit_oel_mahum_messeger_13.htm";
					break;
				case 35431:
					file = "residence2/clanhall/agit_oel_mahum_messeger_14.htm";
					break;
				case 35432:
					file = "residence2/clanhall/agit_oel_mahum_messeger_15.htm";
					break;
				default:
					return;
			}
			showChatWindow(player, file, false);
		}
		else if(command.startsWith("formAlliance"))
		{
			CTBSiegeClanObject siegeClan = siegeEvent.getSiegeClan(ClanHallTeamBattleEvent.ATTACKERS, player.getClan());
			if(siegeClan == null)
			{
				showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_7.htm", false);
				return;
			}
			if(siegeClan.getClan().getLeaderId() != player.getObjectId())
			{
				showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_10.htm", false);
				return;
			}
			StringTokenizer t = new StringTokenizer(command);
			t.nextToken();
			int npcId = Integer.parseInt(t.nextToken());
			siegeClan.setParam(npcId);

			SiegeClanDAO.getInstance().update(clanHall, siegeClan);
			showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_9.htm", false);
		}
		else if(command.equalsIgnoreCase("registerAsMember"))
		{
			CTBSiegeClanObject siegeClan = siegeEvent.getSiegeClan(ClanHallTeamBattleEvent.ATTACKERS, player.getClan());
			if(siegeClan == null)
			{
				showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_7.htm", false);
				return;
			}
			if(siegeClan.getClan().getLeaderId() == player.getObjectId())
			{
				showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_5.htm", false);
				return;
			}

			if(siegeClan.getPlayers().contains(player.getObjectId()))
				showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_9.htm", false);
			else
			{
				if(siegeClan.getPlayers().size() >= 18)
				{
					showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_8.htm", false);
					return;
				}

				siegeClan.getPlayers().add(player.getObjectId());
				SiegePlayerDAO.getInstance().insert(clanHall, clan.getClanId(), player.getObjectId());
				showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_9.htm", false);
			}
		}
		else if(command.equalsIgnoreCase("listClans"))
		{
			HtmlMessage msg = new HtmlMessage(this);
			msg.setFile("residence2/clanhall/azit_messenger003.htm");

			List<CTBSiegeClanObject> siegeClans = siegeEvent.getObjects(ClanHallTeamBattleEvent.ATTACKERS);
			for(int i = 0; i < 5; i++)
			{
				CTBSiegeClanObject siegeClan = CollectionUtils.safeGet(siegeClans, i);
				if(siegeClan != null)
					msg.replace("%clan_" + i + "%", siegeClan.getClan().getName());
				else
					msg.replace("%clan_" + i + "%", NpcString.__UNREGISTERED__);
				msg.replace("%clan_count_" + i + "%", siegeClan == null ? StringUtils.EMPTY : String.valueOf(siegeClan.getPlayers().size()));
			}
			player.sendPacket(msg);
		}
		else
			super.onBypassFeedback(player, command);
	}

	private boolean checkCond(Player player, boolean regMenu)
	{
		Clan clan = player.getClan();
		ClanHall clanHall = getClanHall();
		ClanHallTeamBattleEvent siegeEvent = clanHall.getSiegeEvent();

		List<CTBSiegeClanObject> siegeClans = siegeEvent.getObjects(ClanHallTeamBattleEvent.ATTACKERS);

		SiegeClanObject siegeClan = siegeEvent.getSiegeClan(ClanHallTeamBattleEvent.ATTACKERS, clan);
		if(siegeEvent.isRegistrationOver())
		{
			showChatWindow(player, "quests/_504_CompetitionForTheBanditStronghold/azit_messenger_q0504_03.htm", false, "%siege_time%",  TimeUtils.toSimpleFormat(clanHall.getSiegeDate()));
			return false;
		}

		if(regMenu && siegeClan != null)
			return true;

		if(clan == null || player.getObjectId() != clan.getLeaderId())
		{
			showChatWindow(player, "quests/_504_CompetitionForTheBanditStronghold/azit_messenger_q0504_05.htm", false);
			return false;
		}

		if(clan.isPlacedForDisband())
		{
			player.sendPacket(SystemMsg.YOU_HAVE_ALREADY_REQUESTED_THE_DISSOLUTION_OF_YOUR_CLAN);
			return false;
		}

		if(player.getObjectId() == clan.getLeaderId() && clan.getLevel() < 4)
		{
			showChatWindow(player, "quests/_504_CompetitionForTheBanditStronghold/azit_messenger_q0504_04.htm", false);
			return false;
		}

		if(clan.getHasHideout() == clanHall.getId())
		{
			showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_22.htm", false);
			return false;
		}

		if(clan.getHasHideout() != 0)
		{
			showChatWindow(player, "quests/_504_CompetitionForTheBanditStronghold/azit_messenger_q0504_10.htm", false);
			return false;
		}

		if(siegeClans.size() >= 5)
		{
			showChatWindow(player, "residence2/clanhall/agit_oel_mahum_messeger_21.htm", false);
			return false;
		}

		return true;
	}

	private void register(Player player)
	{
		Clan clan = player.getClan();
		ClanHall clanHall = getClanHall();
		ClanHallTeamBattleEvent siegeEvent = clanHall.getSiegeEvent();

		CTBSiegeClanObject siegeClan = new CTBSiegeClanObject(ClanHallTeamBattleEvent.ATTACKERS, clan, 0);
		siegeClan.getPlayers().add(player.getObjectId());

		siegeEvent.addObject(ClanHallTeamBattleEvent.ATTACKERS, siegeClan);

		SiegeClanDAO.getInstance().insert(clanHall, siegeClan);
		SiegePlayerDAO.getInstance().insert(clanHall, clan.getClanId(), player.getObjectId());

		List<CTBSiegeClanObject> siegeClans = siegeEvent.getObjects(ClanHallTeamBattleEvent.ATTACKERS);

		showFlagInfo(player, siegeClans.indexOf(siegeClan));
	}

	private void showFlagInfo(Player player, int index)
	{
		String file = null;
		switch(index)
		{
			case 0:
				file = "residence2/clanhall/agit_oel_mahum_messeger_4a.htm";
				break;
			case 1:
				file = "residence2/clanhall/agit_oel_mahum_messeger_4b.htm";
				break;
			case 2:
				file = "residence2/clanhall/agit_oel_mahum_messeger_4c.htm";
				break;
			case 3:
				file = "residence2/clanhall/agit_oel_mahum_messeger_4d.htm";
				break;
			case 4:
				file = "residence2/clanhall/agit_oel_mahum_messeger_4e.htm";
				break;
			default:
				return;
		}
		showChatWindow(player, file, false);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... arg)
	{
		Clan clan = getClanHall().getOwner();
		if(clan != null)
			showChatWindow(player, "residence2/clanhall/azit_messenger001.htm", firstTalk, "%owner_name%", clan.getName());
		else
			showChatWindow(player, "residence2/clanhall/azit_messenger002.htm", firstTalk);
	}
}
