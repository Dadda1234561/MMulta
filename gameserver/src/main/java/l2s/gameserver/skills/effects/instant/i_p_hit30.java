package l2s.gameserver.skills.effects.instant;

import l2s.gameserver.model.Creature;
import l2s.gameserver.stats.Formulas;
import l2s.gameserver.stats.Formulas.AttackInfo;
import l2s.gameserver.templates.skill.EffectTemplate;

/**
 * @author SanyaDC
**/
public class i_p_hit30 extends i_abstract_effect
{

	public i_p_hit30(EffectTemplate template)
	{
		super(template);
	}

	@Override
	protected boolean checkCondition(Creature effector, Creature effected)
	{
		if(effected.isRaid())
			return false;
		return !effected.isDead();
	}

	@Override
	public void instantUse(Creature effector, Creature effected, boolean reflected)
	{


		int damage = (int) (effected.getCurrentHp()/100*30);
		effected.reduceCurrentHp(damage, effector, null, true, true, false, true, false, false, true,true,false,false,false,false);

	}
}