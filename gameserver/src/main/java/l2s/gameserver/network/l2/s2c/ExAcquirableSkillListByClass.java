package l2s.gameserver.network.l2.s2c;

import java.util.ArrayList;
import java.util.List;

import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.model.Mods.Multiproff;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.AcquireType;

/**
 * Reworked: VISTALL
 */
public class ExAcquirableSkillListByClass extends L2GameServerPacket
{
	private AcquireType _type;
	private final List<Skill> _skills;
	private static Player _player;

	class Skill
	{
		public int id;
		public int nextLevel;
		public int maxLevel;
		public long cost;
		public int requirements;
		public int subUnit;

		Skill(int id, int nextLevel, int maxLevel, long cost, int requirements, int subUnit)
		{
			this.id = id;
			this.nextLevel = nextLevel;
			this.maxLevel = maxLevel;
			this.cost = cost;
			this.requirements = requirements;
			this.subUnit = subUnit;
		}
	}

	public ExAcquirableSkillListByClass(AcquireType type, int size)
	{
		_skills = new ArrayList<Skill>(size);
		_type = type;
	}

	public ExAcquirableSkillListByClass(AcquireType type, int size, Player player)
	{
		_skills = new ArrayList<Skill>(size);
		_type = type;
		_player = player;
	}

	public void addSkill(int id, int nextLevel, int maxLevel, int Cost, int requirements, int subUnit)
	{
		_skills.add(new Skill(id, nextLevel, maxLevel, Cost, requirements, subUnit));
	}

	public void addSkill(int id, int nextLevel, int maxLevel, long Cost, int requirements)
	{
		_skills.add(new Skill(id, nextLevel, maxLevel, Cost, requirements, 0));
	}

	/*@Override
	protected final void writeImpl()
	{
		writeH(_type.getId());
		writeH(_skills.size());

		for(Skill temp : _skills)
		{
			l2s.gameserver.model.Skill sk = SkillHolder.getInstance().getSkill(temp.id, (Config.ENABLE_MULTICLASS_SKILL_LEARN && Config.MULTICLASS_SKILL_LEVEL_MAX) ?  temp.maxLevel : temp.nextLevel);
			if (sk == null)
				return;
			writeD(temp.id);
			writeH(temp.nextLevel);
			writeH(temp.maxLevel);
			writeC(temp.requirements);
			//writeQ(temp.cost); DM
			writeQ(Integer.parseInt(Config.ENABLE_MULTICLASS_SKILL_LEARN_ITEM.split(":")[1]) > 0 ? Integer.parseInt(Config.ENABLE_MULTICLASS_SKILL_LEARN_ITEM.split(":")[1]) : Multiproff.getCost(_player, sk, Config.SKILL_LEARN_COST_SP, _type));
			writeC(0x01); // UNK
			if(_type == AcquireType.SUB_UNIT)
				writeH(temp.subUnit);
		}
	}*/
	@Override
	protected final void writeImpl()
	{
		writeH(_type.getId());
		writeH(_skills.size());

		for(Skill temp : _skills)
		{
			writeD(temp.id);
			writeH(temp.nextLevel);
			writeH(temp.maxLevel);
			writeC(temp.requirements);
			writeQ(temp.cost);
			writeC(0x01); // UNK
			if(_type == AcquireType.SUB_UNIT)
				writeH(temp.subUnit);
		}
	}
}