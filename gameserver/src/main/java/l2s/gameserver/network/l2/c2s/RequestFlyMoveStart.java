package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.data.xml.holder.JumpTracksHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Zone;
import l2s.gameserver.model.Zone.ZoneType;
import l2s.gameserver.model.actor.instances.player.FlyMove;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.templates.jump.JumpTrack;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author UnAfraid
 * @reworked by Bonux
 */
public final class RequestFlyMoveStart extends L2GameClientPacket
{
	private static final Logger _log = LoggerFactory.getLogger(RequestFlyMoveStart.class);

	@Override
	protected boolean readImpl()
	{
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player activeChar = getClient().getActiveChar();
		if(activeChar == null)
			return;

		if(!activeChar.getClassId().isAwaked() && !activeChar.isGM())
			return;

		if(activeChar.isInFlyMove() || activeChar.isTransformed() || activeChar.isMounted())
			return;

		Zone zone = activeChar.getZone(ZoneType.JUMPING);
		if(zone == null)
			return;

		//TODO: [Bonux] Добавить условия.
		if(activeChar.hasServitor())
		{
			activeChar.sendPacket(SystemMsg.YOU_MAY_NOT_USE_SAYUNE_WHILE_PET_OR_SUMMONED_PET_IS_OUT);
			return;
		}

		if(activeChar.isPK())
		{
			activeChar.sendPacket(SystemMsg.YOU_CANNOT_USE_SAYUNE_WHILE_IN_A_CHAOTIC_STATE);
			return;
		}

		if(activeChar.isProcessingRequest())
		{
			activeChar.sendPacket(SystemMsg.SAYUNE_CANNOT_BE_USED_WHILE_TAKING_OTHER_ACTIONS);
			return;
		}

		int trackId = zone.getTemplate().getJumpTrackId();
		JumpTrack track = JumpTracksHolder.getInstance().getTrack(trackId);
		if(track == null || track.getWays().isEmpty())
		{
			_log.warn("RequestFlyMoveStart: Track ID[" + trackId + "] was not found or empty!");
			return;
		}

		new FlyMove(activeChar, track).move(0);
	}
}