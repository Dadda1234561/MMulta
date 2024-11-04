package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.Homunculus;
import l2s.gameserver.model.actor.instances.player.HomunculusList;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

/**
 * @author nexvill
 */
public class ExShowHomunculusList extends L2GameServerPacket
{
	private final HomunculusList homunculusList;

	public ExShowHomunculusList(HomunculusList list)
	{
		homunculusList = list;
	}

	@Override
	protected final void writeImpl()
	{
		if (homunculusList.size() > 0)
		{
			writeD(homunculusList.size());
			for (int i = 0; i < homunculusList.size(); i++)
			{
				writeD(i); // slot
				
				Homunculus homunculus = homunculusList.get(i);
				
				writeD(homunculus.getId()); // homunculus id
				writeD(homunculus.getType());
				writeC(homunculus.isActive() ? 1 : 0);
				writeD(homunculus.getTemplate().getBasicSkillId());
				writeD(homunculus.getSkill1Level() > 0 ? homunculus.getTemplate().getSkill1Id() : 0);
				writeD(homunculus.getSkill2Level() > 0 ? homunculus.getTemplate().getSkill2Id() : 0);
				writeD(homunculus.getSkill3Level() > 0 ? homunculus.getTemplate().getSkill3Id() : 0);
				writeD(homunculus.getSkill4Level() > 0 ? homunculus.getTemplate().getSkill4Id() : 0);
				writeD(homunculus.getSkill5Level() > 0 ? homunculus.getTemplate().getSkill5Id() : 0);
				writeD(homunculus.getTemplate().getBasicSkillLevel());
				writeD(homunculus.getSkill1Level());
				writeD(homunculus.getSkill2Level());
				writeD(homunculus.getSkill3Level());
				writeD(homunculus.getSkill4Level());
				writeD(homunculus.getSkill5Level());
				writeD(homunculus.getLevel());
				writeD(homunculus.getExp());
				writeD(homunculus.getHp());
				writeD(homunculus.getAtk());
				writeD(homunculus.getDef());
				writeD(homunculus.getCritRate());
			}
		}
		else
		{
			writeD(0);
		}
	}
}