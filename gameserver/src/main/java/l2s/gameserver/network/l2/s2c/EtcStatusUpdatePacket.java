package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.model.Player;

public class EtcStatusUpdatePacket extends L2GameServerPacket
{
	private static final int NO_CHAT_FLAG = 1 << 0;
	private static final int DANGER_AREA_FLAG = 1 << 1;
	private static final int CHARM_OF_COURAGE_FLAG = 1 << 2;

	/**
	 *
	 * Packet for lvl 3 client buff line
	 *
	 * Example:(C4)
	 * F9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 - empty statusbar
	 * F9 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 - increased force lvl 1
	 * F9 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 - weight penalty lvl 1
	 * F9 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 - chat banned
	 * F9 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 - Danger Area lvl 1
	 * F9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 - lvl 1 grade penalty
	 *
	 * packet format: cdd //and last three are ddd???
	 *
	 * Some test results:
	 * F9 07 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 - lvl 7 increased force lvl 4 weight penalty
	 *
	 * Example:(C5 709)
	 * F9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 0F 00 00 00 - lvl 1 charm of courage lvl 15 Death Penalty
	 *
	 *
	 * NOTE:
	 * End of buff:
	 * You must send empty packet
	 * F9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	 * to remove the statusbar or just empty value to remove some icon.
	 */

	private int _increasedForce, _weightPenalty, _deathPenalty, _consumedSouls;
	private int _flags;

	public EtcStatusUpdatePacket(Player player)
	{
		_increasedForce = player.getIncreasedForce();
		_weightPenalty = player.getWeightPenalty();
		_deathPenalty = player.getDeathPenalty().getLevel();
		_consumedSouls = player.getConsumedSouls();

		if(player.getMessageRefusal() || player.getNoChannel() != 0 || player.isBlockAll())
			_flags |= NO_CHAT_FLAG; //skill id 4269, 1 lvl
		if(player.isInDangerArea())
			_flags |= DANGER_AREA_FLAG; // skill id 4268, 1 lvl
		if(player.isCharmOfCourage())
			_flags |= CHARM_OF_COURAGE_FLAG; //Charm of Courage, "Prevents experience value decreasing if killed during a siege war".
	}

	@Override
	protected final void writeImpl()
	{
		// cdccccc
		writeC(_increasedForce); // skill id 4271, 7 lvl
		writeD(_weightPenalty); // skill id 4270, 4 lvl
		writeC(0); // weapon grade penalty, skill 6209 in epilogue
		writeC(0); // armor grade penalty, skill 6213 in epilogue
		writeC(_deathPenalty); //Death Penalty max lvl 15, "Combat ability is decreased due to death."
		writeC(_consumedSouls);
		writeC(_flags);
		writeC(0x00); // Shadow souls
		writeC(0x00); // Light souls
	}
}