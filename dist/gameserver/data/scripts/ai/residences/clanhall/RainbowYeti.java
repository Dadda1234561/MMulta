package ai.residences.clanhall;

import java.util.List;

import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.NpcAI;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.entity.events.impl.ClanHallMiniGameEvent;
import l2s.gameserver.model.entity.events.objects.CMGSiegeClanObject;
import l2s.gameserver.model.entity.events.objects.SpawnExObject;
import l2s.gameserver.model.entity.events.objects.ZoneObject;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.NpcUtils;
import npc.model.residences.clanhall.RainbowGourdInstance;
import npc.model.residences.clanhall.RainbowYetiInstance;

/**
 * @author VISTALL
 * @date 12:50/14.05.2011
 */
public class RainbowYeti extends NpcAI
{
	private static class ZoneDeactive implements Runnable
	{
		private final ZoneObject _zone;

		public ZoneDeactive(ZoneObject zone)
		{
			_zone = zone;
		}

		@Override
		public void run()
		{
			_zone.setActive(false);
		}
	}

	public RainbowYeti(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected void onEvtSeeSpell(Skill skill , Creature character, Creature target)
	{
		super.onEvtSeeSpell(skill, character, target);

		RainbowYetiInstance actor = (RainbowYetiInstance)getActor();
		ClanHallMiniGameEvent miniGameEvent = actor.getEvent(ClanHallMiniGameEvent.class);
		if(miniGameEvent == null)
			return;
		if(!character.isPlayer())
			return;

		Player player = character.getPlayer();

		CMGSiegeClanObject siegeClan = null;
		List<CMGSiegeClanObject> attackers = miniGameEvent.getObjects(ClanHallMiniGameEvent.ATTACKERS);
		for(CMGSiegeClanObject $ : attackers)
			if($.isParticle(player))
				siegeClan = $;

		if(siegeClan == null)
			return;

		int index = attackers.indexOf(siegeClan);
		int warIndex = Integer.MIN_VALUE;

		RainbowGourdInstance gourdInstance = null;
		RainbowGourdInstance gourdInstance2 = null;
		switch(skill.getId())
		{
			case 2240: //nectar
				// убить хп у своего Фрукта :D
				if(Rnd.chance(90))
				{
					gourdInstance = getGourd(index);
					if(gourdInstance == null)
						return;

					gourdInstance.doDecrease(player);
				}
				else
					actor.addMob(NpcUtils.spawnSingle(35592, actor.getX() + 10, actor.getY() + 10, actor.getZ(), 0));
				break;
			case 2241: //mineral water
				// увеличить ХП у чужого фрукта
				warIndex = rndEx(attackers.size(), index);
				if(warIndex == Integer.MIN_VALUE)
					return;

				gourdInstance2 = getGourd(warIndex);
				if(gourdInstance2 == null)
					return;
				gourdInstance2.doHeal();
				break;
			case 2242: //water
				// обменять ХП с чужим фруктом
				warIndex = rndEx(attackers.size(), index);
				if(warIndex == Integer.MIN_VALUE)
					return;

				gourdInstance = getGourd(index);
				gourdInstance2 = getGourd(warIndex);
				if(gourdInstance2 == null || gourdInstance == null)
					return;

				gourdInstance.doSwitch(gourdInstance2);
				break;
			case 2243: //sulfur
				// наложить дебафф в чужогой арене
				warIndex = rndEx(attackers.size(), index);
				if(warIndex == Integer.MIN_VALUE)
					return;

				ZoneObject zone = miniGameEvent.getFirstObject("zone_" + warIndex);
				if(zone == null)
					return;
				zone.setActive(true);
				ThreadPoolManager.getInstance().schedule(new ZoneDeactive(zone), 60000L);
				break;
		}
	}

	private RainbowGourdInstance getGourd(int index)
	{
		ClanHallMiniGameEvent miniGameEvent = getActor().getEvent(ClanHallMiniGameEvent.class);

		SpawnExObject spawnEx = miniGameEvent.getFirstObject("arena_" + index);

		return (RainbowGourdInstance)spawnEx.getSpawns().get(1).getFirstSpawned();
	}

	private int rndEx(int size, int ex)
	{
		int rnd = Integer.MIN_VALUE;
		for(int i = 0; i < Byte.MAX_VALUE; i++)
		{
			rnd = Rnd.get(size);
			if(rnd != ex)
				break;
		}

		return rnd;
	}
}
