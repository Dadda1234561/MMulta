package l2s.gameserver.skills.effects.instant;

import l2s.gameserver.model.Creature;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.templates.skill.EffectTemplate;

/**
 * @Author SmiDmi following the example of Bonux
 */
public class i_blessed_spirit_shot extends i_abstract_effect
{
	private final double _power;
	private final int _unk;
	private final double _healBonus;

	public i_blessed_spirit_shot(EffectTemplate template)
	{
		super(template);
		_power = getParams().getDouble("power", 300);
		_unk = getParams().getInteger("unk_spiritshot_parameter", 40);
		_healBonus = getParams().getDouble("heal_bonus", 2.4);
	}

	@Override
	public void instantUse(Creature effector, Creature effected, boolean reflected)
	{
		effected.sendPacket(SystemMsg.YOUR_SPIRITSHOT_HAS_BEEN_ENABLED);
		effected.setChargedSpiritshotPower(_power, _unk, _healBonus);
	}
}