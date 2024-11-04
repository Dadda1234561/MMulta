package ai.lindvior;

import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.model.World;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage.ScreenMessageAlign;
import l2s.gameserver.network.l2.s2c.ExSendUIEventPacket;
import l2s.gameserver.model.entity.Reflection;

import instances.LindviorBoss;
import npc.model.GeneratorLindviorInstance;

import java.util.concurrent.atomic.AtomicBoolean;

/**
generator by iqman
 */
public class Generator extends DefaultAI
{
	private final int MAX_CHARGES = 120;

	private final AtomicBoolean charged = new AtomicBoolean(false);

	private int currentCharges = 0;

	public Generator(NpcInstance actor)
	{
		super(actor);
		currentCharges = 0;
	}

	@Override
	protected void onEvtSeeSpell(Skill skill, Creature caster, Creature target)
	{
		NpcInstance actor = getActor();
		if(actor == null || caster == null || caster.getPlayer() == null || skill.getId() != 15606)
		{
			super.onEvtSeeSpell(skill, caster, target);
			return;
		}

		currentCharges++;

		Reflection reflection = actor.getReflection();
		if(reflection.isDefault()) {
			for (Player player : World.getAroundPlayers(actor, 1500, 500)) {
				player.sendPacket(new ExShowScreenMessage(NpcString.S1_HAS_CHARGED_THE_CANNON, 5000, ScreenMessageAlign.TOP_CENTER, true, true, caster.getPlayer().getName()));
				player.sendPacket(new ExSendUIEventPacket(player, 5, -1, currentCharges, MAX_CHARGES, 0, 0, NpcString.CHARGING)); // TODO: Разобраться почему отображает 10%/100% вместо 10/100
			}
		} else {
			reflection.broadcastPacket(new ExShowScreenMessage(NpcString.S1_HAS_CHARGED_THE_CANNON, 5000, ScreenMessageAlign.TOP_CENTER, true, true, caster.getPlayer().getName()));
			for(Player player : reflection.getPlayers())
				player.sendPacket(new ExSendUIEventPacket(player, 5, -1, currentCharges, MAX_CHARGES, 0, 0, NpcString.CHARGING)); // TODO: Разобраться почему отображает 10%/100% вместо 10/100
		}

		if(currentCharges >= MAX_CHARGES)
		{
			if(charged.compareAndSet(false, true)) {
				Reflection r = actor.getReflection();
				if (r != null) {
					if (r instanceof LindviorBoss) {
						LindviorBoss lInst = (LindviorBoss) r;
						lInst.increaseCharges();
						actor.setNpcState(0x02);
						actor.block();
					}
				}
			}
		}
		super.onEvtSeeSpell(skill, caster, target);
	}
}