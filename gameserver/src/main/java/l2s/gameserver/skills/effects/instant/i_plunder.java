package l2s.gameserver.skills.effects.instant;

import l2s.gameserver.model.Creature;
import l2s.gameserver.model.instances.MonsterInstance;
import l2s.gameserver.model.reward.RewardList;
import l2s.gameserver.model.reward.RewardType;
import l2s.gameserver.templates.skill.EffectTemplate;

/**
 * @author Bonux
 */
public class i_plunder extends i_spoil
{
	public i_plunder(EffectTemplate template)
	{
		super(template);
	}

	@Override
	protected void doSpoil(Creature effector, Creature effected, boolean success)
	{
		final MonsterInstance monster = (MonsterInstance) effected;
		if(success)
		{
			if(monster.isRobbed() > 0)
				return;

			monster.setSpoiled(effector.getPlayer());

			for(RewardList rewardList : monster.getRewardLists())
			{
				if(rewardList.getType() == RewardType.SWEEP)
					monster.rollRewards(rewardList, effector, effector);
			}

			if(monster.takeSweep(effector.getPlayer()))
			{
				monster.setRobbed(2);
				return;
			}
		}
		monster.clearSweep();
		monster.setRobbed(1);
	}
}