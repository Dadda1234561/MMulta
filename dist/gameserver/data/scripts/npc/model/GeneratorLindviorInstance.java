package npc.model;

import instances.LindviorBoss;
import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.MonsterInstance;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.npc.NpcTemplate;

import java.util.concurrent.ScheduledFuture;

public class GeneratorLindviorInstance extends MonsterInstance {
	private class CheckState implements Runnable {
		NpcInstance _npc;

		public CheckState(NpcInstance npc) {
			_npc = npc;
		}

		@Override
		public void run() {
			/*for(NpcInstance mob : World.getAroundNpc(_npc, 700, 700))
			{
				if(mob != null && mob.isMonster() && !mob.isDead())
				{
					blockedChargeBlocked = true;
					setNpcState(2);
					return;
				}
			}//if not found we presume that no need to continue
			*/

			//blockedChargeBlocked = false;
			if (!getAbnormalList().contains(RECHARGE_BUFF_SKILL.getTemplate()) && !isCastingNow() && getNpcState() != 0x02) //to avoid flood
			{
				setNpcState(1);
				doCast(RECHARGE_BUFF_SKILL, _npc, false);
			}
		}
	}

	public GeneratorLindviorInstance(int objectId, NpcTemplate template, MultiValueSet<String> set) {
		super(objectId, template, set);
	}

	public static final SkillEntry RECHARGE_BUFF_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 15605, 1);

	//private static boolean blockedChargeBlocked = true;
	private ScheduledFuture<?> _checkState;

	@Override
	protected void onSpawn() {
		_checkState = ThreadPoolManager.getInstance().scheduleAtFixedRate(new CheckState(this), 0, 1000);
	}

	@Override
	protected void onDelete() {
		super.onDelete();
		if (_checkState != null) {
			_checkState.cancel(false);
			_checkState = null;
		}
	}

	@Override
	protected void onDeath(Creature killer) {
		super.onDeath(killer);
		Reflection r = getReflection();
		if (r != null) {
			if (r instanceof LindviorBoss) {
				LindviorBoss lInst = (LindviorBoss) r;
				lInst.endInstance();
			}
		}
	}

	@Override
	public boolean isChargeBlocked() {
		if (getNpcState() == 0x02)
			return true;
		return !getAbnormalList().contains(RECHARGE_BUFF_SKILL);
	}

	@Override
	protected void onReduceCurrentHp(double damage, Creature attacker, Skill skill, boolean awake, boolean standUp, boolean directHp, boolean isDot, boolean isStatic) {
		if (attacker.getPlayer() != null)
			return;
		super.onReduceCurrentHp(damage, attacker, skill, awake, standUp, directHp, isDot, isStatic);
	}
}