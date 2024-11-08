package l2s.gameserver.network.l2.c2s.pledge;

import l2s.gameserver.instancemanager.clansearch.ClanSearchManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.World;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.c2s.L2GameClientPacket;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;

/**
 * @author GodWorld
 * @reworked by Bonux
**/
public class RequestPledgeWaitingUserAccept extends L2GameClientPacket
{
	private boolean _invite;
	private int _objectId;
	private int _pledgeType;

	@Override
	protected boolean readImpl()
	{
		_invite = readD() == 1;
		_objectId = readD();
		_pledgeType = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		if(activeChar.isOutOfControl())
		{
			activeChar.sendActionFailed();
			return;
		}

		if(_invite)
		{
			//TODO[Bonux]: Пересмотреть правильность условий.

			Clan clan = activeChar.getClan();
			if(!clan.canInvite())
			{
				activeChar.sendPacket(SystemMsg.AFTER_A_CLAN_MEMBER_IS_DISMISSED_FROM_A_CLAN_THE_CLAN_MUST_WAIT_AT_LEAST_A_DAY_BEFORE_ACCEPTING_A_NEW_MEMBER);
				return;
			}

			if(_objectId == activeChar.getObjectId())
			{
				activeChar.sendActionFailed();
				return;
			}

			if((activeChar.getClanPrivileges() & Clan.CP_CL_INVITE_CLAN) != Clan.CP_CL_INVITE_CLAN)
			{
				activeChar.sendPacket(SystemMsg.ONLY_THE_LEADER_CAN_GIVE_OUT_INVITATIONS);
				return;
			}

			if(clan.getUnitMembersSize(_pledgeType) >= clan.getSubPledgeLimit(_pledgeType))
			{
				if(_pledgeType == 0)
					activeChar.sendPacket(new SystemMessagePacket(SystemMsg.S1_IS_FULL_AND_CANNOT_ACCEPT_ADDITIONAL_CLAN_MEMBERS_AT_THIS_TIME).addString(clan.getName()));
				else
					activeChar.sendPacket(SystemMsg.THE_ACADEMYROYAL_GUARDORDER_OF_KNIGHTS_IS_FULL_AND_CANNOT_ACCEPT_NEW_MEMBERS_AT_THIS_TIME);
				return;
			}

			Player member = World.getPlayer(_objectId);
			if(member == null)
			{
				activeChar.sendActionFailed();
				return;
			}

			if(member.getClan() == activeChar.getClan())
			{
				activeChar.sendPacket(SystemMsg.THAT_IS_AN_INCORRECT_TARGET);
				return;
			}

			if(member.getClan() != null)
			{
				activeChar.sendPacket(new SystemMessagePacket(SystemMsg.S1_IS_ALREADY_A_MEMBER_OF_ANOTHER_CLAN).addName(member));
				return;
			}

			if(!clan.checkJoinPledgeCondition(member, _pledgeType))
			{
				activeChar.sendActionFailed();
				return;
			}

			if(!member.getPlayerAccess().CanJoinClan || !member.canJoinClan())
			{
				activeChar.sendPacket(new SystemMessagePacket(SystemMsg.C1_CANNOT_JOIN_THE_CLAN_BECAUSE_ONE_DAY_HAS_NOT_YET_PASSED_SINCE_THEY_LEFT_ANOTHER_CLAN).addName(member));
				return;
			}

			clan.joinInPledge(member, _pledgeType);
		}
		else
			ClanSearchManager.getInstance().removeApplicant(activeChar.getClanId(), _objectId);
	}
}