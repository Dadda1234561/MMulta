/*package l2s.gameserver.network.l2.s2c;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.model.Mods.Multiproff;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.SkillLearn;
import l2s.gameserver.model.base.AcquireType;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.templates.item.data.ItemData;

*//**
 * Reworked: VISTALL
 *//*
public class AcquireSkillInfoPacket extends L2GameServerPacket
{
	private SkillLearn _learn;
	private AcquireType _type;
	private List<Require> _reqs = Collections.emptyList();
	private boolean _isMultiClassSkill;
	private Player _player;

	public AcquireSkillInfoPacket(AcquireType type, SkillLearn learn)
	{
		_type = type;
		_learn = learn;
		_reqs = new ArrayList<Require>();
		for(ItemData item : _learn.getRequiredItemsForLearn(type))
			_reqs.add(new Require(99, item.getId(), item.getCount(), 50));
		_isMultiClassSkill = false;
	}

	public AcquireSkillInfoPacket(AcquireType type, SkillLearn learn, boolean isMain, Player player) {
		_type = type;
		_learn = learn;
		if (_learn.getItemId() != 0) {
			_reqs = new ArrayList<>(1);
			_reqs.add(new Require(99, _learn.getItemId(), _learn.getItemCount(), 50));
		}
		_isMultiClassSkill = isMain;
		if (_isMultiClassSkill && type != AcquireType.NORMAL) {
			_isMultiClassSkill = false;
		}
		_player = player;
	}

	@Override
	public void writeImpl()
	{
		SkillEntry skillEntry = _player.getKnownSkill(_learn.getId());
		Skill sk = SkillHolder.getInstance().getSkill(_learn.getId(), (Config.ENABLE_MULTICLASS_SKILL_LEARN && Config.MULTICLASS_SKILL_LEVEL_MAX) ?  skillEntry.getTemplate().getMaxLevel() : _learn.getLevel());
		if (sk == null)
			return;
		writeD(_learn.getId());
		writeD(_learn.getLevel());
		//writeQ(_learn.getCost()); // sp/rep
		writeQ(Config.ENABLE_MULTICLASS_SKILL_LEARN ? (int) Multiproff.getCost(_player, sk, Config.SKILL_LEARN_COST_SP, _type) : _learn.getCost() * Config.SKILL_LEARN_COST_SP*//* _learn.getCost() * Config.SKILL_LEARN_COST_SP countadd*//*); // sp/rep
		writeD(_type.getId());

		//writeD(_reqs.size()); //requires size
		if (_isMultiClassSkill && !Config.ENABLE_MULTICLASS_SKILL_LEARN_ITEM.isEmpty()) {
			writeD(_reqs.size() + 1); // requires size + custom item +1
		} else {
			writeD(_reqs.size()); // requires size
		}

		for(Require temp : _reqs)
		{
			writeD(temp.type);
			writeD(temp.itemId);
			writeQ(temp.count);
			writeD(temp.unk);
		}

		if (_isMultiClassSkill && !Config.ENABLE_MULTICLASS_SKILL_LEARN_ITEM.isEmpty()) {
			writeD(99);
			writeD(Integer.parseInt(Config.ENABLE_MULTICLASS_SKILL_LEARN_ITEM.split(":")[0]));
			writeQ(Integer.parseInt(Config.ENABLE_MULTICLASS_SKILL_LEARN_ITEM.split(":")[1]) > 0 ? Integer.parseInt(Config.ENABLE_MULTICLASS_SKILL_LEARN_ITEM.split(":")[1]) : Multiproff.getCost(_player, sk, Config.SKILL_LEARN_COST_SP, _type));
			writeD(50);
		}
	}

	private static class Require
	{
		public int itemId;
		public long count;
		public int type;
		public int unk;

		public Require(int pType, int pItemId, long pCount, int pUnk)
		{
			itemId = pItemId;
			type = pType;
			count = pCount;
			unk = pUnk;
		}
	}
}*/
package l2s.gameserver.network.l2.s2c;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import l2s.gameserver.model.SkillLearn;
import l2s.gameserver.model.base.AcquireType;
import l2s.gameserver.templates.item.data.ItemData;

public class AcquireSkillInfoPacket extends L2GameServerPacket
{
	private SkillLearn _learn;
	private AcquireType _type;
	private List<Require> _reqs = Collections.emptyList();

	public AcquireSkillInfoPacket(AcquireType type, SkillLearn learn)
	{
		_type = type;
		_learn = learn;
		_reqs = new ArrayList<Require>();
		for(ItemData item : _learn.getRequiredItemsForLearn(type))
			_reqs.add(new Require(99, item.getId(), item.getCount(), 50));
	}

	@Override
	public void writeImpl()
	{
		writeD(_learn.getId());
		writeD(_learn.getLevel());
		writeQ(_learn.getCost()); // sp/rep
		writeD(_type.getId());

		writeD(_reqs.size()); //requires size

		for(Require temp : _reqs)
		{
			writeD(temp.type);
			writeD(temp.itemId);
			writeQ(temp.count);
			writeD(temp.unk);
		}
	}

	private static class Require
	{
		public int itemId;
		public long count;
		public int type;
		public int unk;

		public Require(int pType, int pItemId, long pCount, int pUnk)
		{
			itemId = pItemId;
			type = pType;
			count = pCount;
			unk = pUnk;
		}
	}
}
