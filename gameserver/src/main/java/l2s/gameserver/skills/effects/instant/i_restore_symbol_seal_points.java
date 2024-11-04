package l2s.gameserver.skills.effects.instant;

import l2s.gameserver.Config;
import l2s.gameserver.model.Creature;
import l2s.gameserver.templates.skill.EffectTemplate;

/**
 * @author nexvill
 **/
public class i_restore_symbol_seal_points extends i_abstract_effect
{
	public i_restore_symbol_seal_points(EffectTemplate template)
	{
		super(template);
	}
	
	@Override
	protected boolean checkCondition(Creature effector, Creature effected)
	{
		return effected.isPlayer();
	}

	@Override
	public void instantUse(Creature effector, Creature effected, boolean reflected)
	{
		final int amount = (int) (Config.MAX_SYMBOL_SEAL_POINTS / 100 * getValue());
		
		effected.getPlayer().setSymbolSealPoints(Math.min(effected.getPlayer().getSymbolSealPoints() + amount, Config.MAX_SYMBOL_SEAL_POINTS));
		//effected.getPlayer().updateSymbolSealSkills();
		effected.getPlayer().sendSkillList();
		effected.getPlayer().broadcastUserInfo(true);
		
	}
}