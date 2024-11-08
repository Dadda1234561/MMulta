package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.instancemanager.clansearch.ClanSearchManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.model.clansearch.ClanSearchClan;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeRecruitBoardDetail;
import l2s.gameserver.tables.ClanTable;

/**
 * @author Bonux
**/
public class RequestPledgeSignInForOpenJoiningMethod extends L2GameClientPacket
{
	private int _clanId;
	@SuppressWarnings("unused")
	private int _unk;

	@Override
	protected boolean readImpl()
	{
		_clanId = readD();
		_unk = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		if(activeChar.isOutOfControl() || activeChar.getClan() != null)
		{
			activeChar.sendActionFailed();
			return;
		}

		Clan clan = ClanTable.getInstance().getClan(_clanId);
		if(clan == null)
		{
			activeChar.sendActionFailed();
			return;
		}

		ClanSearchClan clanSearch = ClanSearchManager.getInstance().getClan(clan.getClanId());
		if(clanSearch == null || clanSearch.getApplication() == 0)
		{
			activeChar.sendActionFailed();
			return;
		}

		if(activeChar.isInTrainingCamp())
		{
			activeChar.sendPacket(SystemMsg.YOU_CANNOT_JOIN_A_CLAN_WHILE_YOU_ARE_IN_THE_TRAINING_CAMP);
			return;
		}

		if(!activeChar.canJoinClan())
		{
			activeChar.sendPacket(SystemMsg.AFTER_LEAVING_OR_HAVING_BEEN_DISMISSED_FROM_A_CLAN_YOU_MUST_WAIT_AT_LEAST_A_DAY_BEFORE_JOINING_ANOTHER_CLAN);
			return;
		}

		int pledgeType = clanSearch.getSubUnit();

		if(clan.getUnitMembersSize(pledgeType) >= clan.getSubPledgeLimit(pledgeType))
		{
			if(pledgeType == 0)
				activeChar.sendPacket(new SystemMessagePacket(SystemMsg.S1_IS_FULL_AND_CANNOT_ACCEPT_ADDITIONAL_CLAN_MEMBERS_AT_THIS_TIME).addString(clan.getName()));
			else
				activeChar.sendPacket(SystemMsg.THE_ACADEMYROYAL_GUARDORDER_OF_KNIGHTS_IS_FULL_AND_CANNOT_ACCEPT_NEW_MEMBERS_AT_THIS_TIME);
			return;
		}

		if(!clan.checkJoinPledgeCondition(activeChar, pledgeType))
		{
			activeChar.sendActionFailed();
			return;
		}

		clan.joinInPledge(activeChar, pledgeType);

		activeChar.sendPacket(new ExPledgeRecruitBoardDetail(clanSearch));
	}
}