package l2s.gameserver.model.instances;

import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.ResidenceHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.events.impl.CastleSiegeEvent;
import l2s.gameserver.model.entity.events.impl.SiegeEvent;
import l2s.gameserver.model.entity.residence.Residence;
import l2s.gameserver.model.pledge.*;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.tables.ClanTable;
import l2s.gameserver.utils.Util;

/**
 * @author VISTALL
 * @date 18:25/12.04.2012
 */
public class VillageMasterPledgeBypasses
{
	public static boolean checkPlayerForClanLeader(NpcInstance npc, Player player)
	{
		if(player.getClan() == null)
		{
			npc.showChatWindow(player, "pledge/pl_no_pledgeman.htm", false);
			return false;
		}

		if(!player.isClanLeader())
		{
			npc.showChatWindow(player, "pledge/pl_err_master.htm", false);
			return false;
		}
		return true;
	}

	protected static void dissolveClan(NpcInstance npc, Player player)
	{
		if(player == null || player.getClan() == null)
			return;

		Clan clan = player.getClan();

		if(!player.isClanLeader())
		{
			player.sendPacket(SystemMsg.ONLY_THE_CLAN_LEADER_IS_ENABLED);
			return;
		}

		if(clan.isPlacedForDisband())
		{
			player.sendPacket(SystemMsg.YOU_HAVE_ALREADY_REQUESTED_THE_DISSOLUTION_OF_YOUR_CLAN);
			return;
		}

		if(!clan.canDisband())
		{
			player.sendPacket(SystemMsg.YOU_CANNOT_APPLY_FOR_DISSOLUTION_AGAIN_WITHIN_SEVEN_DAYS_AFTER_A_PREVIOUS_APPLICATION_FOR_DISSOLUTION);
			return;
		}

		if(clan.getAllyId() != 0)
		{
			player.sendPacket(SystemMsg.YOU_CANNOT_DISPERSE_THE_CLANS_IN_YOUR_ALLIANCE);
			return;
		}
		if(clan.isAtWar())
		{
			player.sendPacket(SystemMsg.YOU_CANNOT_DISSOLVE_A_CLAN_WHILE_ENGAGED_IN_A_WAR);
			return;
		}
		if(clan.getCastle() != 0 || clan.getHasHideout() != 0 || clan.getHasFortress() != 0)
		{
			player.sendPacket(SystemMsg.UNABLE_TO_DISSOLVE_YOUR_CLAN_OWNS_ONE_OR_MORE_CASTLES_OR_HIDEOUTS);
			return;
		}

		for(Residence r : ResidenceHolder.getInstance().getResidences())
		{
			SiegeEvent<?,?> siegeEvent = r.getSiegeEvent();
			if(siegeEvent == null)
				continue;

			if(siegeEvent.getSiegeClan(SiegeEvent.ATTACKERS, clan) != null || siegeEvent.getSiegeClan(SiegeEvent.DEFENDERS, clan) != null || siegeEvent.getSiegeClan(CastleSiegeEvent.DEFENDERS_WAITING, clan) != null)
			{
				player.sendPacket(SystemMsg.UNABLE_TO_DISSOLVE_YOUR_CLAN_HAS_REQUESTED_TO_PARTICIPATE_IN_A_CASTLE_SIEGE);
				return;
			}
		}

		clan.placeForDisband();
		clan.broadcastClanStatus(true, true, false);
		npc.showChatWindow(player, "pledge/pl009.htm", false);
	}

	public static void restoreClan(VillageMasterInstance npc, Player player)
	{
		if(!checkPlayerForClanLeader(npc, player))
			return;

		Clan clan = player.getClan();
		if(!clan.isPlacedForDisband())
		{
			player.sendPacket(SystemMsg.THERE_ARE_NO_REQUESTS_TO_DISPERSE);
			return;
		}

		clan.unPlaceDisband();
		clan.broadcastClanStatus(true, true, false);
		npc.showChatWindow(player, "pledge/pl012.htm", false);
	}

	protected static boolean createAlly(Player player, String allyName)
	{
		if(!player.isClanLeader())
		{
			player.sendPacket(SystemMsg.ONLY_CLAN_LEADERS_MAY_CREATE_ALLIANCES);
			return false;
		}
		if(player.getClan().getAllyId() != 0)
		{
			player.sendPacket(SystemMsg.YOU_ALREADY_BELONG_TO_ANOTHER_ALLIANCE);
			return false;
		}
		if(player.getClan().isPlacedForDisband())
		{
			player.sendPacket(SystemMsg.AS_YOU_ARE_CURRENTLY_SCHEDULE_FOR_CLAN_DISSOLUTION_NO_ALLIANCE_CAN_BE_CREATED);
			return false;
		}
		if(allyName.length() > 16)
		{
			player.sendPacket(SystemMsg.INCORRECT_LENGTH_FOR_AN_ALLIANCE_NAME);
			return false;
		}
		if(!Util.isMatchingRegexp(allyName, Config.ALLY_NAME_TEMPLATE))
		{
			player.sendPacket(SystemMsg.INCORRECT_ALLIANCE_NAME__PLEASE_TRY_AGAIN);
			return false;
		}
		if(player.getClan().getLevel() < 5)
		{
			player.sendPacket(SystemMsg.TO_CREATE_AN_ALLIANCE_YOUR_CLAN_MUST_BE_LEVEL_5_OR_HIGHER);
			return false;
		}
		if(ClanTable.getInstance().getAllyByName(allyName) != null)
		{
			player.sendPacket(SystemMsg.THAT_ALLIANCE_NAME_ALREADY_EXISTS);
			return false;
		}
		if(!player.getClan().canCreateAlly())
		{
			player.sendPacket(SystemMsg.YOU_CANNOT_CREATE_A_NEW_ALLIANCE_WITHIN_1_DAY_OF_DISSOLUTION);
			return false;
		}

		Alliance alliance = ClanTable.getInstance().createAlliance(player, allyName);
		if(alliance == null)
			return false;

		player.broadcastCharInfo();

		return true;
	}

	public static boolean changeLeader(NpcInstance npc, Player player, int pledgeId, String leaderName)
	{
		if(!checkPlayerForClanLeader(npc, player))
			return false;

		Clan clan = player.getClan();

		UnitMember subLeader = clan.getAnyMember(leaderName);
		if(subLeader == null || subLeader.isClanLeader())
		{
			npc.showChatWindow(player, "pledge/pl_err_man.htm", false);
			return false;
		}

		if(pledgeId == Clan.SUBUNIT_MAIN_CLAN)
		{
			ClanChangeLeaderRequest request = ClanTable.getInstance().getRequest(clan.getClanId());
			if(request != null)
			{
				npc.showChatWindow(player, "pledge/pl_transfer_already.htm", false);
				return false;
			}

			request = new ClanChangeLeaderRequest(clan.getClanId(), subLeader.getObjectId(), Clan.CHANGE_LEADER_TIME_PATTERN.next(System.currentTimeMillis()));

			ClanTable.getInstance().addRequest(request);

			npc.showChatWindow(player, "pledge/pl_transfer_success.htm", false);
			return true;
		}
		return false;
	}

	public static void cancelLeaderChange(VillageMasterInstance npc, Player player)
	{
		if(!checkPlayerForClanLeader(npc, player))
			return;

		Clan clan = player.getClan();

		ClanChangeLeaderRequest request = ClanTable.getInstance().getRequest(clan.getClanId());
		if(request == null)
		{
			npc.showChatWindow(player, "pledge/pl_not_transfer.htm", false);
			return;
		}

		ClanTable.getInstance().cancelRequest(request, false);

		npc.showChatWindow(player, "pledge/pl_cancel_success.htm", false);
	}
}
