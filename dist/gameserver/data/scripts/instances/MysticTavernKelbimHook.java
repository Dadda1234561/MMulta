package instances;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.listener.actor.OnCurrentHpDamageListener;
import l2s.gameserver.listener.hooks.ListenerHook;
import l2s.gameserver.listener.hooks.ListenerHookType;
import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.components.SceneMovie;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.utils.NpcUtils;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 Obi-Wan
 03.07.2016
 */
public class MysticTavernKelbimHook extends ListenerHook implements OnInitScriptListener
{
	@Override
	public void onInit()
	{
		addHookNpc(ListenerHookType.NPC_KILL, 23693);
		addHookNpc(ListenerHookType.NPC_KILL, 23706, 23707);
	}

	public static class CurrentHpListener implements OnCurrentHpDamageListener
	{
		private final AtomicBoolean locked = new AtomicBoolean(false);

		@Override
		public void onCurrentHpDamage(Creature actor, double damage, Creature attacker, Skill skill)
		{
			if(actor == null || actor.isDead())
			{
				return;
			}

			switch(actor.getNpcId())
			{
				case 23693:
					if(actor.getCurrentHp() + damage < actor.getMaxHp() * 0.5)
					{
						if(locked.compareAndSet(false, true))
							actor.getReflection().spawnByGroup("mystic_tavern_kelbim_4");
					}
					break;
				case 23690:
					if(actor.getCurrentHp() + damage < actor.getMaxHp() * 0.15)
					{
						if(locked.compareAndSet(false, true)) {
							actor.getReflection().despawnAll();

							for (Player player : actor.getReflection().getPlayers())
								player.startScenePlayer(SceneMovie.EPIC_KELBIM_SCENE);

							ThreadPoolManager.getInstance().schedule(() -> {
								actor.getReflection().startCollapseTimer(0, true);

								for(Player player : actor.getReflection().getPlayers()) {
									QuestState qs = player.getQuestState(834);
									if(qs != null)
										qs.setCond(3);
								}
							}, SceneMovie.EPIC_KELBIM_SCENE.getDuration());
						}
					}
					break;
			}
		}
	}

	@Override
	public void onNpcKill(NpcInstance npc, Player killer)
	{
		switch(npc.getNpcId())
		{
			case 23693:
				NpcInstance old = killer.getReflection().getNpcs(true, 34176).get(0);
				NpcUtils.spawnSingle(34177, old.getSpawnedLoc(), old.getReflection());
				old.deleteMe();
				killer.getReflection().broadcastPacket(new ExShowScreenMessage(NpcString.THE_DOOR_TO_KELBIMS_THRONE_HAS_OPENED, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER));
				killer.getReflection().openDoor(26150106);
				killer.getReflection().openDoor(26150108);

				NpcInstance kelbim = killer.getReflection().getNpcs(true, 23690).get(0);
				kelbim.addListener(new CurrentHpListener());

				for(Player player : killer.getReflection().getPlayers()) {
					QuestState qs = player.getQuestState(834);
					if(qs != null)
						qs.setCond(2);
				}
				break;
		}
	}
}