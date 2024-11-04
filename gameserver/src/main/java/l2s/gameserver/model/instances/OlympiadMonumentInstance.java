package l2s.gameserver.model.instances;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.Hero;
import l2s.gameserver.model.entity.olympiad.Olympiad;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.c2s.RequestBypassToServer;
import l2s.gameserver.network.l2.s2c.ExHeroListPacket;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;

/**
 * @author Bonux
**/
public class OlympiadMonumentInstance extends NpcInstance
{
	public OlympiadMonumentInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onMenuSelect(Player player, int ask, long reply, int state)
	{
		if(ask == -50)
		{
			if(player.isNoble())
				showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk001.htm", false);
			else
				showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk001a.htm", false);
		}
		if(ask == -51)
		{
			if(reply == 1)
			{
				if(Hero.getInstance().isInactiveHero(player.getObjectId()))
				{
					if(Olympiad.isValidationPeriod())
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk010c.htm", false);
					else
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk010.htm", false);
				}
				else if(player.isHero())
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk010b.htm", false);
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk010a.htm", false);
			}
			else if(reply == 2)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					if(ItemFunctions.getItemCount(player, 30392) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else if(ItemFunctions.getItemCount(player, 30393) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else if(ItemFunctions.getItemCount(player, 30394) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else if(ItemFunctions.getItemCount(player, 30395) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else if(ItemFunctions.getItemCount(player, 30396) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else if(ItemFunctions.getItemCount(player, 30397) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else if(ItemFunctions.getItemCount(player, 30398) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else if(ItemFunctions.getItemCount(player, 30399) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else if(ItemFunctions.getItemCount(player, 30400) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else if(ItemFunctions.getItemCount(player, 30401) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else if(ItemFunctions.getItemCount(player, 30402) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else if(ItemFunctions.getItemCount(player, 30403) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else if(ItemFunctions.getItemCount(player, 30404) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else if(ItemFunctions.getItemCount(player, 30405) >= 1)
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
					else
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020.htm", false);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			else if(reply == 3)
			{
				//
			}
			else if(reply == 4)
			{
				if(player.isHero())
				{
					if(ItemFunctions.getItemCount(player, ItemTemplate.ITEM_ID_HERO_WING) >= 1)
					{
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020c.htm", false);
					}
					else if(player.isHero())
					{
						if(!player.isQuestContinuationPossible(true))
							return;

						ItemFunctions.addItem(player, ItemTemplate.ITEM_ID_HERO_WING, 1);
					}
					else
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020c.htm", false);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020d.htm", false);
			}
		}
		else if(ask == -52)
		{
			if(reply == 1)
			{
				if(Hero.getInstance().isInactiveHero(player.getObjectId()))
				{
					if(player.isBaseClassActive())
					{
						if(player.getLevel() >= 85)
							Hero.getInstance().activateHero(player);
						else
							showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk010d.htm", false);
					}
					else
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk010e.htm", false);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk010a.htm", false);
			}
		}
		else if(ask == -53)
		{
			//
		}
		else if(ask == -54)
		{
			if(reply == 1)
			{
				int rank = Olympiad.getRank(player);
				if(rank == 1)
				{
					if(ItemFunctions.getItemCount(player, ItemTemplate.ITEM_ID_HERO_CLOAK) < 1 && ItemFunctions.getItemCount(player, ItemTemplate.ITEM_ID_FAME_CLOAK) < 1)
					{
						if(!player.isQuestContinuationPossible(true))
							return;

						ItemFunctions.addItem(player, ItemTemplate.ITEM_ID_HERO_CLOAK, 1);
					}
					else
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk040c.htm", false);
				}
				else if(rank == 2 || rank == 3)
				{
					if(ItemFunctions.getItemCount(player, ItemTemplate.ITEM_ID_HERO_CLOAK) < 1 && ItemFunctions.getItemCount(player, ItemTemplate.ITEM_ID_FAME_CLOAK) < 1)
					{
						if(!player.isQuestContinuationPossible(true))
							return;

						ItemFunctions.addItem(player, ItemTemplate.ITEM_ID_FAME_CLOAK, 1);
					}
					else
						showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk040c.htm", false);
				}
				else if(rank == 0 || rank > 3)
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk040d.htm", false);
			}
		}
		else if(ask == -60)
		{
			if(ItemFunctions.getItemCount(player, 30392) >= 1 || ItemFunctions.getItemCount(player, 30393) >= 1 || ItemFunctions.getItemCount(player, 30394) >= 1 || ItemFunctions.getItemCount(player, 30395) >= 1 || ItemFunctions.getItemCount(player, 30396) >= 1)
			{
				showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
				return;
			}
			if(ItemFunctions.getItemCount(player, 30397) >= 1 || ItemFunctions.getItemCount(player, 30398) >= 1 || ItemFunctions.getItemCount(player, 30399) >= 1 || ItemFunctions.getItemCount(player, 30400) >= 1 || ItemFunctions.getItemCount(player, 30401) >= 1 || ItemFunctions.getItemCount(player, 30402) >= 1)
			{
				showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
				return;
			}
			if(ItemFunctions.getItemCount(player, 30403) >= 1 || ItemFunctions.getItemCount(player, 30404) >= 1 || ItemFunctions.getItemCount(player, 30405) >= 1)
			{
				showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020b.htm", false);
				return;
			}
			if(reply == 1)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30392, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 2)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30393, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 3)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30394, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 4)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30395, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 5)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30396, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 6)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30397, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 7)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30398, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 8)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30399, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 9)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30400, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 10)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30401, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 11)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30402, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 12)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30403, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 13)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30404, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 14)
			{
				if(player.isHero())
				{
					if(!player.isQuestContinuationPossible(true))
						return;

					ItemFunctions.addItem(player, 30405, 1);
				}
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk020a.htm", false);
			}
			if(reply == 0)
			{
				if(player.isNoble())
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk001.htm", false);
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk001a.htm", false);
			}
		}
		else if(ask == -61)
		{
			if(reply == 0)
			{
				if(player.isNoble())
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk001.htm", false);
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk001a.htm", false);
			}
		}
		else if(ask == -62)
		{
			if(reply == 0)
			{
				if(player.isNoble())
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk001.htm", false);
				else
					showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "obelisk001a.htm", false);
			}
		}
		else if(ask == -70)
		{
			//
		}
		else
			super.onMenuSelect(player, ask, reply, state);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.equalsIgnoreCase("_heroes"))
		{
			player.sendPacket(new ExHeroListPacket());
			return;
		}

		super.onBypassFeedback(player, command);
	}

	@Override
	public String getHtmlDir(String filename, Player player)
	{
		return Olympiad.OLYMPIAD_HTML_PATH;
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... arg)
	{
		if(val == 0) // Grand Olympiad Manager
		{
			String fileName = Olympiad.OLYMPIAD_HTML_PATH;
			if(player.isNoble())
				fileName += "obelisk001.htm";
			else
				fileName += "obelisk001a.htm";

			showChatWindow(player, fileName, firstTalk);
		}
		else
			super.showChatWindow(player, val, firstTalk, arg);
	}

	@Override
	public boolean canPassPacket(Player player, Class<? extends L2GameClientPacket> packet, Object... arg)
	{
		return packet == RequestBypassToServer.class && arg.length == 1 && (arg[0].equals("_heroes"));
	}
}