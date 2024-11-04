package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.model.Player;

/**
const EDGE_GRAY = 15;// TODO CHEK IT
const EDGE_BLUE = 12; // TODO CHEK IT
const EDGE_ORANGE = 11;	// TODO CHEK IT
const EDGE_BUFFRED = 9; // TODO CHEK IT
const EDGE_RED = 8; // TODO CHEK IT
const EDGE_SSQGRAY = 13; // TODO CHEK IT
const EDGE_PVPGREEN = 14; // TODO CHEK IT
 */
public class ExSetCompassZoneCode extends L2GameServerPacket
{
	public static final int ZONE_ALTERED = 8; // TODO CHEK IT
	public static final int ZONE_ALTERED2 = 9; // TODO CHEK IT
	public static final int ZONE_REMINDER = 10; // TODO CHEK IT
	public static final int ZONE_SIEGE = 12; // TODO CHEK IT
	public static final int ZONE_PEACE = 11;
	public static final int ZONE_SSQ = 13; // TODO CHEK IT
	public static final int ZONE_PVP = 14; // TODO CHEK IT
	public static final int ZONE_GENERAL_FIELD = 15; // TODO CHEK IT

	public static final int ZONE_PVP_FLAG = 1 << ExSetCompassZoneCode.ZONE_PVP;
	public static final int ZONE_ALTERED_FLAG = 1 << ExSetCompassZoneCode.ZONE_ALTERED;
	public static final int ZONE_SIEGE_FLAG = 1 << ExSetCompassZoneCode.ZONE_SIEGE;
	public static final int ZONE_PEACE_FLAG = 1 << ExSetCompassZoneCode.ZONE_PEACE;
	public static final int ZONE_SSQ_FLAG = 1 << ExSetCompassZoneCode.ZONE_SSQ;

	private final int _zone;

	public ExSetCompassZoneCode(Player player)
	{
		this(player.getZoneMask());
	}

	public ExSetCompassZoneCode(int zoneMask)
	{
		if((zoneMask & ZONE_ALTERED_FLAG) == ZONE_ALTERED_FLAG)
			_zone = ZONE_ALTERED;
		else if((zoneMask & ZONE_SIEGE_FLAG) == ZONE_SIEGE_FLAG)
			_zone = ZONE_SIEGE;
		else if((zoneMask & ZONE_PVP_FLAG) == ZONE_PVP_FLAG)
			_zone = ZONE_PVP;
		else if((zoneMask & ZONE_PEACE_FLAG) == ZONE_PEACE_FLAG)
			_zone = ZONE_PEACE;
		else if((zoneMask & ZONE_SSQ_FLAG) == ZONE_SSQ_FLAG)
			_zone = ZONE_SSQ;
		else
			_zone = ZONE_GENERAL_FIELD;
	}

	@Override
	protected final void writeImpl()
	{
		writeD(_zone);
	}
}