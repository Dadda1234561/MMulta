package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.commons.util.Rnd;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.Homunculus;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author nexvill
 */
public class ExEnchantHomunculusSkillResult extends L2GameServerPacket
{
	private final Player _player;
	private final int _slot, _skillNumber;

	public ExEnchantHomunculusSkillResult(Player player, int slot, int skillNumber)
	{
		_player = player;
		_slot = slot;
		_skillNumber = skillNumber;
	}

	@Override
	protected final void writeImpl()
	{
		int playerNumber = Rnd.get(6) + 1;
		int homunculusNumber = Rnd.get(6) + 1;
		int systemNumber = Rnd.get(6) + 1;
		
		Homunculus homunculus = _player.getHomunculusList().get(_slot);
		int boundLevel = 1;
		if ((playerNumber == homunculusNumber) && (playerNumber == systemNumber))
		{
			boundLevel = 3;
		}
		else if ((playerNumber == homunculusNumber) || (playerNumber == systemNumber)//
				|| (homunculusNumber == systemNumber))
		{
			boundLevel = 2;
		}
		
		switch (_skillNumber)
		{
			case 1:
			{
				homunculus.setSkill1Level(boundLevel);
				break;
			}
			case 2:
			{
				homunculus.setSkill2Level(boundLevel);
				break;
			}
			case 3:
			{
				homunculus.setSkill3Level(boundLevel);
				break;
			}
			case 4:
			{
				homunculus.setSkill4Level(boundLevel);
				break;
			}
			case 5:
			{
				homunculus.setSkill5Level(boundLevel);
				break;
			}
		}
		_player.getHomunculusList().update(homunculus);
		_player.getHomunculusList().refreshStats(true);
		
		writeD(boundLevel); // skill bound level result
		writeD(homunculus.getId()); // homunculus id? random value on JP
		writeD(_slot); // slot
		writeD(_skillNumber); // skill number
		writeD(playerNumber); // player number
		writeD(homunculusNumber); // homunculus number
		writeD(systemNumber); // system number
	}
}