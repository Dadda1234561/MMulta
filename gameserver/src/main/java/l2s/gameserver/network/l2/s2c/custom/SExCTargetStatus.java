package l2s.gameserver.network.l2.s2c.custom;

import l2s.gameserver.model.GameObject;
import l2s.gameserver.model.Player;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 15.07.2022
 **/
public class SExCTargetStatus extends ACustomServerPacket {
	public static final int FLAG_SHOW_DROP = 1 << 0;
	public static final int FLAG_SHOW_CP = 1 << 1;
	public static final int FLAG_CAN_LOCK = 1 << 2;
	public static final int FLAG_LOCKED = 1 << 3;

	private final int nTargetId;
	private int nFlags = 0;
	private int nTargetCP = 0;

	public SExCTargetStatus(Player player, GameObject target) {
		nTargetId = target.getObjectId();
		if ((target instanceof Player)) {
			nTargetCP = ((Player) target).getGearScore().getPoints();
		}
	}

	@Override
	protected void writeCustomImpl() {
		writeC(SExCustomOpcode.S_EX_C_TARGET_STATUS.ordinal());
		writeD(nTargetId);
		writeD(nTargetCP);
	}
}
