package l2s.gameserver.model;

import java.util.Collections;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.TimeUnit;

import l2s.commons.util.Rnd;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.ChampionTemplateHolder;
import l2s.gameserver.data.xml.holder.UpMonsterTemplateHolder;
import l2s.gameserver.model.instances.MonsterInstance;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.reward.RewardData;
import l2s.gameserver.model.reward.RewardGroup;
import l2s.gameserver.model.reward.RewardList;
import l2s.gameserver.model.reward.RewardType;
import l2s.gameserver.skills.AbnormalEffect;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.stats.funcs.Func;
import l2s.gameserver.stats.funcs.FuncTemplate;
import l2s.gameserver.templates.npc.MinionData;
import l2s.gameserver.templates.spawn.SpawnNpcInfo;
import l2s.gameserver.templates.spawn.SpawnPoint;
import l2s.gameserver.templates.spawn.SpawnRange;
import l2s.gameserver.templates.spawn.SpawnTemplate;
import l2s.gameserver.utils.NpcUtils;

/**
 * @author VISTALL
 * @date 4:58/19.05.2011
 */
public class HardSpawner extends Spawner
{
	private final SpawnTemplate _template;

	private final List<NpcInstance> _reSpawned = new CopyOnWriteArrayList<NpcInstance>();

	public HardSpawner(SpawnTemplate template)
	{
		_template = template;
		_spawned = new CopyOnWriteArrayList<NpcInstance>();
	}

	@Override
	public String getName()
	{
		return _template.getName();
	}

	@Override
	public void decreaseCount(NpcInstance oldNpc)
	{
		final int upMonster = oldNpc.isMonster() ? oldNpc.getUpMonster() : 0;
		oldNpc.setSpawn(null); // [VISTALL] нужно убирать спавн что бы не вызвать зацикливания, и остановки спавна
		oldNpc.deleteMe();

		if(!_spawned.remove(oldNpc))
			return;

		if(!hasRespawn())
		{
			decreaseCount0(null, null, oldNpc.getDeathTime());
			return;
		}

		SpawnNpcInfo npcInfo = getRandomNpcInfo();

		NpcInstance npc = npcInfo.getTemplate().getNewInstance(npcInfo.getParameters());
		npc.setUpMonster(upMonster);
		npc.setSpawn(this);

		List<MinionData> minionsData = npcInfo.getMinionData();
		if(!minionsData.isEmpty())
		{
			for(MinionData minionData : minionsData)
				npc.getMinionList().addMinion(minionData);
		}

		_reSpawned.add(npc);

		decreaseCount0(npcInfo.getTemplate(), npc, oldNpc.getDeathTime());
	}

	@Override
	public NpcInstance doSpawn(boolean spawn)
	{
		SpawnNpcInfo npcInfo = getRandomNpcInfo();

		return doSpawn0(npcInfo.getTemplate(), spawn, npcInfo.getParameters(), npcInfo.getMinionData());
	}

	@Override
	protected NpcInstance initNpc(NpcInstance mob, boolean spawn)
	{
		_reSpawned.remove(mob);

		SpawnRange range = getRandomSpawnRange();
		mob.setSpawnRange(range);
		return initNpc0(mob, range.getRandomLoc(getReflection().getGeoIndex(), mob.isFlying()), spawn);
	}

	@Override
	public int getMainNpcId()
	{
		return _template.getNpcId(0).getTemplate().getId();
	}

	@Override
	public void respawnNpc(NpcInstance oldNpc)
	{
		final NpcInstance newNpc = initNpc(oldNpc, true);

		final int upMonster = oldNpc.isMonster() ? oldNpc.getUpMonster() : 0;
		if (upMonster > 0) {

			ChampionTemplate upMonsterTemplate = UpMonsterTemplateHolder.getInstance().getTemplate(upMonster);
			if (upMonsterTemplate != null) {

				// Additional Drop
				RewardList rewardList = new RewardList(RewardType.EVENT_GROUPED, true);
				RewardGroup rewardGroup = new RewardGroup(RewardList.MAX_CHANCE, null);

				// Additional Stat Funcs
				for (FuncTemplate funcTpl : upMonsterTemplate.getAttachedFuncs()) {
					Func func = funcTpl.getFunc(upMonsterTemplate);
					if (func != null) {
						newNpc.getStat().addFuncs(func);
					}
				}

				if (!upMonsterTemplate.getAdditionalDrop().isEmpty()) {
					for (RewardData drop : upMonsterTemplate.filterAdditionalDrop((MonsterInstance) newNpc)) {
						rewardGroup.addData(drop);
					}
				}

				if (!rewardGroup.getItems().isEmpty()) {
					rewardList.add(rewardGroup);
					newNpc.addRewardList(rewardList);
				}
			}

			// Abnormal Effect
			AbnormalEffect ave = AbnormalEffect.valueOf("AVE_STAR_X0" + upMonster + "_EV");
			if (ave != null)
				newNpc.startAbnormalEffect(ave);

			// Restore HP/MP
			newNpc.setCurrentHpMp(newNpc.getMaxHp(), newNpc.getMaxMp(), true);

			// Schedule Despawn
			newNpc.startRestoreTask(upMonster, TimeUnit.MINUTES.toMillis(Config.ALT_UP_MONSTER_DESPAWN)); // 5 min
		}
	}

	@Override
	public void deleteAll()
	{
		super.deleteAll();

		for(NpcInstance npc : _reSpawned)
		{
			npc.setSpawn(null);
			npc.deleteMe();
		}

		_reSpawned.clear();
	}

	private SpawnNpcInfo getRandomNpcInfo()
	{
		return Rnd.get(_template.getNpcList());
	}

	@Override
	public SpawnRange getRandomSpawnRange()
	{
		List<SpawnPoint> spawnPoints = _template.getSpawnPointList();
		if(!spawnPoints.isEmpty())	// Если имеем точки спавна, территорию игнорируем (оффлайк)
			return Rnd.get(spawnPoints);
		return Rnd.get(_template.getTerritoryList());
	}

	@Override
	public SpawnTemplate getTemplate()
	{
		return _template;
	}

	@Override
	public HardSpawner clone()
	{
		HardSpawner spawnDat = new HardSpawner(_template);
		spawnDat.setAmount(_maximumCount);
		spawnDat.setRespawnDelay(getRespawnDelay(), getRespawnDelayRandom());
		spawnDat.setRespawnPattern(getRespawnPattern());
		spawnDat.setRespawnTime(0);
		return spawnDat;
	}
}
