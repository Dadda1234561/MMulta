package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.MonsterInstance;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

public final class StarStoneInstance extends MonsterInstance
{
	public StarStoneInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	protected void onReduceCurrentHp(double damage, Creature attacker, Skill skill, boolean awake, boolean standUp, boolean directHp, boolean isDot, boolean isStatic) {
		double newDamage;
		if(skill == null && attacker.getActiveWeaponInstance().getItemId() == 167){
			newDamage = 100;
		}
		else {
			newDamage = 0;
		}
		super.onReduceCurrentHp(newDamage, attacker, skill, awake, standUp, directHp, isDot, isStatic);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... arg)
	{}

	@Override
	public void showChatWindow(Player player, String filename, boolean firstTalk, Object... replace)
	{}

	@Override
	public void onBypassFeedback(Player player, String command)
	{}
}