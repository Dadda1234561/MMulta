package l2s.gameserver.network.l2.s2c.timerestrictfield;

import java.util.HashMap;
import java.util.Map;

import l2s.gameserver.data.xml.holder.TimeRestrictFieldHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.templates.TimeRestrictFieldInfo;

/**
 * @author nexvill
 * @reworked by sharp
 */
public class ExTimeRestrictFieldList extends L2GameServerPacket
{
	private final Player _player;
	private Map<Integer, TimeRestrictFieldInfo> _fields = new HashMap<>();

	public ExTimeRestrictFieldList(Player player)
	{
		_player = player;
		_fields = TimeRestrictFieldHolder.getInstance().getFields();
	}

	@Override
	protected final void writeImpl()
	{
		writeD(_fields.size());

		if (_fields.size() > 0)
		{
			for (int id : _fields.keySet())
			{
				final TimeRestrictFieldInfo field = _fields.get(id);

				writeD(1); // nItemSize (max 3) // FIXME: Если надо будет несколько предметов..
				// start loop
				writeD(field.getItemId());
				writeQ(field.getItemCount());
				// end loop
				writeD(field.getResetCycle()); // nResetCycle
				writeD(id); // nFieldID
				writeD(field.getMinLevel()); // nMinLevel
				writeD(field.getMaxLevel()); // nMaxLevel


				int remainTime = 0;
				if ((_player.getReflection().getId() <= -1000) && (_player.getReflection().getId() == id)) {
					remainTime = _player.getTimeRestrictFieldRemainTime();
				}
				else {
					remainTime = _player.getVarInt(PlayerVariables.RESTRICT_FIELD_TIMELEFT + "_" + field.getReflectionId(), field.getRemainTimeBase());
				}
				int remainTimeRefill = _player.getVarInt(PlayerVariables.RESTRICT_FIELD_TIMELEFT + "_" + field.getReflectionId() + "_refill", field.getRemainTimeMax() - field.getRemainTimeBase());

				writeD(field.getRemainTimeBase()); // nRemainTimeBase
				writeD(remainTime); // nRemainTime
				writeD(field.getRemainTimeMax()); // nRemainTimeMax
				writeD(remainTimeRefill); // nRemainRefillTime
				writeD(field.getRemainTimeMax() - field.getRemainTimeBase()); // nRefillTimeMax
				writeC(remainTime > 0); // is field active
				writeC(0); // bUserBound
				writeC(0); // bCanReEnter
				writeC(0); // bIsInZonePCCafeUserOnly
				writeC(0); // bIsPCCafeUser
				writeC(0); // is cross-server field
				writeC(0); // bCanUseEntranceTicket
				writeD(1); // nEntranceCount
			}
		}
	}
}