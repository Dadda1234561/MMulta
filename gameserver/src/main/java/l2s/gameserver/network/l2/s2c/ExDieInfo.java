package l2s.gameserver.network.l2.s2c;

import java.util.Map;

import l2s.gameserver.data.xml.holder.DamageHolder;
import l2s.gameserver.model.Creature;

/**
 * @author nexvill
 */
public class ExDieInfo extends L2GameServerPacket
{
	private final Map<Integer, DamageHolder> _damageInfo;
	private final Creature _player;

	public ExDieInfo(Creature player)
	{
		player.getObjectId();
		_damageInfo = player.getDamageInfo();
		_player = player;
	}

	@Override
	protected final void writeImpl()
	{
		writeH(0); // items section. not actual in homunculus
		// writeD();
		// writeD();
		// writeD();
		//-------------------------------------------------------------
		writeH(_damageInfo.size());
		
		for (DamageHolder dmg : _damageInfo.values())
		{
			if (dmg.getCreatureId() != 0)
			{
				
				writeH(1);
				writeD(dmg.getCreatureId());
			}
			else
			{
				writeH(0);
				writeS(dmg.getName());
			}
			writeS("");
			
			if (dmg.getSkill() != null)
			{
				writeD(dmg.getSkill().getId());
			}
			else
			{
				writeD(0);
			}
			writeF(dmg.getDamage());
			writeH(dmg.getType());
		}
		_player.resetDamageInfo();
	}
}