package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 23.09.2019
 **/
public class ExPledgeSkillInfo extends L2GameServerPacket {
	private final int skillId;
	private final int skillLevel;
	private final int timeLeft;
	private final int availability;

	public ExPledgeSkillInfo(int skillId, int skillLevel, int timeLeft, int availability) {
		this.skillId = skillId;
		this.skillLevel = skillLevel;
		this.timeLeft = timeLeft;
		this.availability = availability;
	}

	@Override
	protected void writeImpl() {
		writeD(skillId);
		writeD(skillLevel);
		writeD(timeLeft);
		writeC(availability);
	}
}
