package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.AutoFarm;

public class ExAutoplaySetting extends L2GameServerPacket
{
	private final AutoFarm _autoFarm;

	public ExAutoplaySetting(Player player)
	{
		_autoFarm = player.getAutoFarm();
	}

	@Override
	protected void writeImpl() {
		writeH(_autoFarm.getOptions());
		writeC(_autoFarm.isFarmActivate());
		writeC(_autoFarm.isTargetRaid());
		writeH(_autoFarm.getNextTargetMode());
		writeC(_autoFarm.isMeleeAttackMode());
		writeD(_autoFarm.getHealPercent()); // Auto Heal Percent
		writeD(_autoFarm.getPetHealPercent()); // new 272
		writeC(_autoFarm.isPoliteFarm());
		writeC(_autoFarm.getMacroIndex());
	}
}
