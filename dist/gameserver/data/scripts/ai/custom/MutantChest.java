package ai.custom;

import l2s.commons.util.Rnd;
import l2s.gameserver.ai.Fighter;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.Functions;

public class MutantChest extends Fighter
{

	public MutantChest(NpcInstance actor)
	{
		super(actor);
		actor.getFlags().getImmobilized().start();
	}

	@Override
	protected void onEvtDead(Creature killer)
	{
		NpcInstance actor = getActor();
		if(Rnd.chance(30))
			Functions.npcSay(actor, "Враги! Всюду враги! Все сюда, враги здесь!");

		actor.deleteMe();
	}
}