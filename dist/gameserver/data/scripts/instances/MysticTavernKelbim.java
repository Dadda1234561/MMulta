package instances;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.CtrlEvent;
import l2s.gameserver.data.QuestHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.listener.actor.OnDeathListener;
import l2s.gameserver.listener.actor.ai.OnAiEventListener;
import l2s.gameserver.model.*;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.components.SceneMovie;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.NpcUtils;

import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

/**
 Obi-Wan
 20.06.2016
 */
/*TODO:
1. Сделать освобождение Молли
2. Пределать спавн, разбить на группы и правильно его удалять после каста алтарей
3. Добавить сообщения всем говорящим NPC
4. Пересмотреть видосы и сделать косметику https://www.youtube.com/watch?v=zxdDSwrPUhI
 */
public class MysticTavernKelbim extends Reflection
{
	private class NpcAiEventListener implements OnAiEventListener {
		@Override
		public void onAiEvent(Creature actor, CtrlEvent evt, Object[] args) {
			if(actor.isNpc()) {
				NpcInstance npcActor = (NpcInstance) actor;
				if(evt == CtrlEvent.EVT_SEE_SPELL) {
					Player caster = ((Creature) args[1]).getPlayer();
					if(caster == null)
						return;

					Creature target = (Creature) args[2];
					if(target != actor)
						return;

					Skill skill = (Skill) args[0];

					if(npcActor.getNpcId() == 19624) { // Altar of Earth
						if(skill.getId() != 18514)  // Seal Altar of Earth
							return;

						ItemFunctions.deleteItem(caster, 46555, 1);

						broadcastPacket(new ExShowScreenMessage(NpcString.YOUVE_SUCCESSFULLY_SEALED_THE_ALTAR_OF_EARTH, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, true));

						for(Creature creature : npcActor.getAroundCharacters(750, 500)) {
							if(creature.isMonster()) {
								creature.deleteMe();
							}
						}

						NpcUtils.spawnSingle(19611, new Location(207064, -88328, 101), MysticTavernKelbim.this);
						NpcUtils.spawnSingle(23701, new Location(207128, -88712, 101), MysticTavernKelbim.this);

						NpcUtils.spawnSingle(19611, new Location(207112, -88280, 101), MysticTavernKelbim.this);
						NpcUtils.spawnSingle(23701, new Location(207128, -88712, 101), MysticTavernKelbim.this);

						NpcUtils.spawnSingle(19611, new Location(207080, -88280, 101), MysticTavernKelbim.this);
						NpcUtils.spawnSingle(23701, new Location(207128, -88712, 101), MysticTavernKelbim.this);

						NpcUtils.spawnSingle(19611, new Location(207128, -88296, 101), MysticTavernKelbim.this);
						NpcUtils.spawnSingle(23701, new Location(207128, -88712, 101), MysticTavernKelbim.this);

						ThreadPoolManager.getInstance().schedule(() -> {
							int newStage = stage.incrementAndGet();
							if(newStage == 1) {
								broadcastPacket(new ExShowScreenMessage(NpcString.THE_ALTAR_OF_EARTH_HAS_BEEN_SEALED_NOW_GO_ON_TO_THE_ALTAR_OF_WIND, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, true));
							} else if(newStage == 2) {
								startStage2(caster);
							}
						}, TimeUnit.SECONDS.toMillis(5));

					} else if(npcActor.getNpcId() == 19625) { // Altar of Wind
						if(skill.getId() != 18516)  // Seal Altar of Wind
							return;

						ItemFunctions.deleteItem(caster, 46556, 1);

						broadcastPacket(new ExShowScreenMessage(NpcString.YOUVE_SUCCESSFULLY_SEALED_THE_ALTAR_OF_WIND, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, true));

						for(Creature creature : npcActor.getAroundCharacters(750, 500)) {
							if(creature.isMonster()) {
								creature.deleteMe();
							}
						}

						NpcUtils.spawnSingle(19611, new Location(210056, -87672, 101), MysticTavernKelbim.this);
						NpcUtils.spawnSingle(23701, new Location(210072, -88872, 101), MysticTavernKelbim.this);

						NpcUtils.spawnSingle(19611, new Location(210136, -87672, 101), MysticTavernKelbim.this);
						NpcUtils.spawnSingle(23701, new Location(210072, -88872, 101), MysticTavernKelbim.this);

						NpcUtils.spawnSingle(19611, new Location(210120, -87544, 101), MysticTavernKelbim.this);
						NpcUtils.spawnSingle(23701, new Location(210072, -88872, 101), MysticTavernKelbim.this);

						NpcUtils.spawnSingle(19611, new Location(210056, -87576, 101), MysticTavernKelbim.this);
						NpcUtils.spawnSingle(23701, new Location(210072, -88872, 101), MysticTavernKelbim.this);

						NpcUtils.spawnSingle(19611, new Location(210088, -87640, 101), MysticTavernKelbim.this);
						NpcUtils.spawnSingle(23701, new Location(210072, -88872, 101), MysticTavernKelbim.this);

						ThreadPoolManager.getInstance().schedule(() -> {
							int newStage = stage.incrementAndGet();
							if(newStage == 2) {
								startStage2(caster);
							}
						}, TimeUnit.SECONDS.toMillis(5));
					}
				}
			}
		}
	}

	private class DeathListener implements OnDeathListener
	{
		private final int npcId;
		private final String group;

		public DeathListener(int npcId, String group)
		{
			this.npcId = npcId;
			this.group = group;
		}

		@Override
		public void onDeath(Creature victim, Creature killer)
		{
			if(victim.getNpcId() == npcId && !group.isEmpty()) {
				spawnByGroup(group);
			}

			if(victim.getNpcId() == 23691)
			{
				Player player = killer.getPlayer();
				if(player != null)
				{
					Party party = player.getParty();
					Player receiver = party != null ? party.getPartyLeader() : player;
					if(!ItemFunctions.haveItem(receiver, 46555, 1)) {    // Altar of Earth Sealing Stone
						victim.getReflection().broadcastPacket(new ExShowScreenMessage(NpcString.S1_YOUVE_RECEIVED_THE_ALTAR_OF_EARTH_SEALING_STONE, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, true, receiver.getName()));
						ItemFunctions.addItem(receiver, 46555, 1);    // Altar of Earth Sealing Stone
					}

					ThreadPoolManager.getInstance().schedule(() -> {
						broadcastPacket(new ExShowScreenMessage(NpcString.USE_THE_ALTAR_OF_EARTH_SEALING_STONE_TO_SEAL_THE_ALTAR_OF_EARTH, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, true));
					}, TimeUnit.SECONDS.toMillis(7));
				}
			}
			else if(victim.getNpcId() == 23692)
			{
				Player player = killer.getPlayer();
				if(player != null)
				{
					Party party = player.getParty();
					Player receiver = party != null ? party.getPartyLeader() : player;
					if(!ItemFunctions.haveItem(receiver, 46556, 1)) {    // Altar of Wind Sealing Stone
						victim.getReflection().broadcastPacket(new ExShowScreenMessage(NpcString.S1_YOUVE_RECEIVED_THE_ALTAR_OF_WIND_SEALING_STONE, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, true, receiver.getName()));
						ItemFunctions.addItem(receiver, 46556, 1);    // Altar of Wind Sealing Stone
					}

					ThreadPoolManager.getInstance().schedule(() -> {
						broadcastPacket(new ExShowScreenMessage(NpcString.USE_THE_ALTAR_OF_WIND_SEALING_STONE_TO_SEAL_THE_ALTAR_OF_WIND, 10000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, true));
					}, TimeUnit.SECONDS.toMillis(7));
				}

				ThreadPoolManager.getInstance().execute(() ->
				{
					List<Spawner> spawners2 = spawnByGroup("mystic_tavern_kelbim_2_1");
					for(Spawner spawner : spawners2)
					{
						spawner.getAllSpawned().stream().filter(npcInstance -> npcInstance.getNpcId() == 23713).forEach(npcInstance -> npcInstance.addListener(new DeathListener(23713, "mystic_tavern_kelbim_2_1_1")));
					}
				});

				ThreadPoolManager.getInstance().schedule(() ->
				{
					List<Spawner> spawners2 = spawnByGroup("mystic_tavern_kelbim_2_2");
					for(Spawner spawner : spawners2)
					{
						spawner.getAllSpawned().stream().filter(npcInstance -> npcInstance.getNpcId() == 23713).forEach(npcInstance -> npcInstance.addListener(new DeathListener(23713, "mystic_tavern_kelbim_2_1_1")));
					}
				}, 60000);
				ThreadPoolManager.getInstance().schedule(() ->
				{
					List<Spawner> spawners2 = spawnByGroup("mystic_tavern_kelbim_2_3");
					for(Spawner spawner : spawners2)
					{
						spawner.getAllSpawned().stream().filter(npcInstance -> npcInstance.getNpcId() == 23713).forEach(npcInstance -> npcInstance.addListener(new DeathListener(23713, "mystic_tavern_kelbim_2_1_1")));
					}
				}, 120000);
			}
		}
	}

	private final NpcAiEventListener npcAiEventListener = new NpcAiEventListener();
	private final AtomicInteger stage = new AtomicInteger(0);

	@Override
	protected void onCreate()
	{
		List<Spawner> spawners = spawnByGroup("mystic_tavern_kelbim_0");
		for(Spawner spawner : spawners)
		{
			spawner.getAllSpawned().forEach(npcInstance -> npcInstance.addListener(new DeathListener(23691, "mystic_tavern_kelbim_0_1")));
		}

		ThreadPoolManager.getInstance().schedule(() -> spawnByGroup("mystic_tavern_kelbim_1_1"), 60000);

		ThreadPoolManager.getInstance().schedule(() ->
		{
			List<Spawner> spawners2 = spawnByGroup("mystic_tavern_kelbim_1_2");
			for(Spawner spawner : spawners2)
			{
				spawner.getAllSpawned().stream().filter(npcInstance -> npcInstance.getNpcId() == 23713).forEach(npcInstance -> npcInstance.addListener(new DeathListener(23713, "mystic_tavern_kelbim_1_2_1")));
			}
		}, 60000);

		ThreadPoolManager.getInstance().schedule(() -> spawnByGroup("mystic_tavern_kelbim_1_3"), 60000);

		spawners = spawnByGroup("mystic_tavern_kelbim_2");
		for(Spawner spawner : spawners)
		{
			spawner.getAllSpawned().forEach(npcInstance -> npcInstance.addListener(new DeathListener(23692, "")));
		}

		ThreadPoolManager.getInstance().schedule(() -> {
			for(Player player : getPlayers()) {
				player.startScenePlayer(SceneMovie.EPIC_KELBIM_SLIDE);
			}
		}, TimeUnit.SECONDS.toMillis(3));

		ThreadPoolManager.getInstance().schedule(() -> {
			for(Player p : getPlayers()) {
				Quest quest = QuestHolder.getInstance().getQuest(834);
				QuestState qs = p.getQuestState(quest.getId());
				if(qs != null)
					qs.abortQuest();
				qs = quest.newQuestState(p);
				qs.setCond(1);
			}
		}, TimeUnit.SECONDS.toMillis(15));
	}

	@Override
	public void onAddObject(GameObject object) {
		super.onAddObject(object);

		if(object.isNpc()) {
			NpcInstance npc = (NpcInstance) object;
			if(npc.getNpcId() == 19624 || npc.getNpcId() == 19625)
				npc.addListener(npcAiEventListener);
		} else if(object.isPlayable()) {
			ItemFunctions.deleteItemsEverywhere((Playable) object, 46555);  // Altar of Earth Sealing Stone
			ItemFunctions.deleteItemsEverywhere((Playable) object, 46556);  // Altar of Wind Sealing Stone
		}
	}

	@Override
	public void onRemoveObject(GameObject object) {
		super.onRemoveObject(object);

		if(object.isNpc()) {
			NpcInstance npc = (NpcInstance) object;
			if(npc.getNpcId() == 19624 || npc.getNpcId() == 19625)
				npc.removeListener(npcAiEventListener);
		} else if(object.isPlayable()) {
			ItemFunctions.deleteItemsEverywhere((Playable) object, 46555);  // Altar of Earth Sealing Stone
			ItemFunctions.deleteItemsEverywhere((Playable) object, 46556);  // Altar of Wind Sealing Stone
		}
	}

	private void startStage2(Player player) {
		if(stage.get() != 2)
			return;

		ThreadPoolManager.getInstance().schedule(() -> {
			broadcastPacket(new ExShowScreenMessage(NpcString.THE_DOOR_TO_THE_DUNGEON_HAS_BEEN_OPENED, 7000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER));
			openDoor(26150104);
			spawnByGroup("mystic_tavern_kelbim_3");

			NpcInstance npcSpawn = NpcUtils.spawnSingle(23693, new Location(208600, -87208, -933), player.getReflection());
			npcSpawn.addListener(new MysticTavernKelbimHook.CurrentHpListener());
		}, TimeUnit.SECONDS.toMillis(15));
	}
}