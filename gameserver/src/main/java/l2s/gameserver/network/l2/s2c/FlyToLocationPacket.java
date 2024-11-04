package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.geometry.ILocation;
import l2s.gameserver.model.Creature;

public class FlyToLocationPacket extends L2GameServerPacket
{
	private final int _chaObjId;
	private final FlyType _type;
	private final ILocation _loc;
	private final ILocation _destLoc;
	private final int _flySpeed;
	private final int _flyDelay;
	private final int _animationSpeed;

	/*
	 enum FLY_TO_LOCATION_TYPE : __int32
	 {                                       // XREF: CSkillEffect_i_knockback/r
	     FTLT_BASE          = 0x0,
	     FTLT_PARABOLA      = 0x0,
	     FTLT_STRAIGHT      = 0x1,
	     FTLT_BLINK         = 0x2,
	     FTLT_CHARGE        = 0x3,
	     FTLT_KNOCKBACK     = 0x4,
	     FTLT_HALLUCINATION = 0x5,
	     FTLT_FLYMOVE       = 0x6,
	     FTLT_KNOCKDOWN     = 0x7,
	     FTLT_BACKSTEP      = 0x8,
	     FTLT_PULL          = 0x9,
	     FTLT_FLOAT_STAND   = 0xA,
	     FTLT_FLOAT_LAYDOWN = 0xB,
	     FTLT_MAX           = 0xC,
	 };
	 */
	public enum FlyType
	{
		THROW_UP,
		THROW_HORIZONTAL,
		DUMMY,
		CHARGE,
		PUSH_HORIZONTAL,
		JUMP_EFFECTED,
		NONE,
		PUSH_DOWN_HORIZONTAL,
		WARP_BACK,
		WARP_FORWARD;
	}

	public FlyToLocationPacket(Creature cha, ILocation destLoc, FlyType type, int flySpeed, int flyDelay, int animationSpeed)
	{
		_destLoc = destLoc;
		_type = type;
		_chaObjId = cha.getObjectId();
		_loc = cha;
		_flySpeed = flySpeed;
		_flyDelay = flyDelay;
		_animationSpeed = animationSpeed;
	}

	@Override
	protected void writeImpl()
	{
		writeD(_chaObjId);
		writeD(_destLoc.getX());
		writeD(_destLoc.getY());
		writeD(_destLoc.getZ());
		writeD(_loc.getX());
		writeD(_loc.getY());
		writeD(_loc.getZ());
		writeD(_type.ordinal());
		writeD(_flySpeed);
		writeD(_flyDelay);
		writeD(_animationSpeed);
	}
}