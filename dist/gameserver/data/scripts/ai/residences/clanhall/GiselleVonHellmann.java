package ai.residences.clanhall;

import l2s.commons.util.Rnd;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.Zone;
import l2s.gameserver.model.entity.events.impl.ClanHallSiegeEvent;
import l2s.gameserver.model.entity.events.objects.SpawnExObject;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.utils.Functions;
import l2s.gameserver.utils.PositionUtils;
import l2s.gameserver.utils.ReflectionUtils;

import ai.residences.SiegeGuardMystic;

/**
 * @author VISTALL
 * @date 18:25/10.05.2011
 * 35631
 * lidia_zone1
 * lidia_zone2
 */
public class GiselleVonHellmann extends SiegeGuardMystic
{
	private static final SkillEntry DAMAGE_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 5003, 1);

	private static final Zone ZONE_1 = ReflectionUtils.getZone("lidia_zone1");
	private static final Zone ZONE_2 = ReflectionUtils.getZone("lidia_zone2");

	public GiselleVonHellmann(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtSpawn()
	{
		super.onEvtSpawn();

		ZONE_1.setActive(true);
		ZONE_2.setActive(true);

		Functions.npcShout(getActor(), NpcString.ARISE_MY_FAITHFUL_SERVANTS_YOU_MY_PEOPLE_WHO_HAVE_INHERITED_THE_BLOOD);
	}

	@Override
	protected void onEvtDead(Creature killer)
	{
		NpcInstance actor = getActor();

		super.onEvtDead(killer);

		ZONE_1.setActive(false);
		ZONE_2.setActive(false);

		Functions.npcShout(actor, NpcString.AARGH_IF_I_DIE_THEN_THE_MAGIC_FORCE_FIELD_OF_BLOOD_WILL);

		ClanHallSiegeEvent siegeEvent = actor.getEvent(ClanHallSiegeEvent.class);
		if(siegeEvent == null)
			return;
		SpawnExObject spawnExObject = siegeEvent.getFirstObject(ClanHallSiegeEvent.BOSS);
		NpcInstance lidiaNpc = spawnExObject.getFirstSpawned();

		if(lidiaNpc.getCurrentHpRatio() == 1.)
			lidiaNpc.setCurrentHp(lidiaNpc.getMaxHp() / 2, true);
	}

	@Override
	protected void onEvtAttacked(Creature attacker, Skill skill, int damage)
	{
		NpcInstance actor = getActor();

		super.onEvtAttacked(attacker, skill, damage);

		if(PositionUtils.calculateDistance(attacker, actor, false) > 300. && Rnd.chance(0.13))
			addTaskCast(attacker, DAMAGE_SKILL);
	}
}
