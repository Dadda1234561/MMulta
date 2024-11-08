package l2s.gameserver.network.l2.s2c;

import java.util.Collection;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.DualClass;

/**
 * Author: Bonux
 */
public class ExSubjobInfo extends L2GameServerPacket
{
	private Collection<DualClass> _subClasses;
	private int _raceId, _classId;
	private boolean _openStatus;

	public ExSubjobInfo(Player player, boolean openStatus)
	{
		_openStatus = openStatus;
		_raceId = player.getRace().ordinal();
		_classId = player.getClassId().ordinal();
		_subClasses = player.getDualClassList().values();
	}

	@Override
	protected void writeImpl()
	{
		writeC(_openStatus);
		writeD(_classId);
		writeD(_raceId);

		writeD(_subClasses.size());
		for(DualClass subClass : _subClasses)
		{
			writeD(subClass.getIndex());
			writeD(subClass.getClassId());
			writeD(subClass.getLevel());
			writeC(subClass.getType().ordinal());
		}
	}
}