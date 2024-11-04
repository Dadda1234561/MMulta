package l2s.gameserver.model.instances;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.util.Rnd;
import l2s.gameserver.Config;
import l2s.gameserver.data.QuestHolder;
import l2s.gameserver.data.xml.holder.NpcHolder;
import l2s.gameserver.idfactory.IdFactory;
import l2s.gameserver.instancemanager.RaidBossSpawnManager;
import l2s.gameserver.model.*;
import l2s.gameserver.model.AggroList.HateInfo;
import l2s.gameserver.model.Zone.ZoneType;
import l2s.gameserver.model.actor.basestats.CreatureBaseStats;
import l2s.gameserver.model.actor.basestats.RaidBossBaseStat;
import l2s.gameserver.model.base.Experience;
import l2s.gameserver.model.entity.Hero;
import l2s.gameserver.model.entity.HeroDiary;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.StatsSet;
import l2s.gameserver.templates.npc.NpcTemplate;
import org.apache.commons.lang3.ArrayUtils;

import java.util.*;

public class RaidBossInstance extends MonsterInstance
{
	final int[] EMPTY_MONSTER_IDS =
			{		12312, 12314, 25372, 25378, 25375, 25357, 25373, 25146, 25362, 25366, 25001, 25127, 25060, 25369, 25149, 25166, 25426, 25429, 25019, 25076, 25360,
					25365, 25272, 25038, 25095, 25352, 25112, 25169, 25501, 25004, 25079, 25188, 25392, 25401, 25128, 25391, 25404, 25020, 25023, 25189, 25383, 25098,
					25354, 25118, 25388, 25398, 25152, 25185, 25223, 25041, 25063, 25385, 25211, 25506, 25394, 25170, 25504, 25082, 25115, 25410, 25155, 25415, 25208,
					25214, 25007, 25088, 25192, 25099, 25418, 25431, 25438, 25085, 25102, 25395, 25437, 25441, 25498, 25260, 25057, 25044, 25158, 25420, 25456, 25026,
					25047, 25119, 25131, 25484, 25013, 25277, 25273, 25460, 25050, 25473, 25496, 25067, 25481, 25029, 25159, 25103, 25137, 25434, 25475, 25493, 25241,
					25259, 25010, 25280, 25070, 25122, 25463, 25230, 25032, 25089, 25182, 29060, 25238, 25106, 25256, 25016, 25226, 25125, 25444, 25478, 25255, 25051,
					25322, 25263, 25233, 25092, 25163, 25453, 25198, 25252, 25269, 25281, 25035, 25325, 25447, 25199, 25235, 25248, 25220, 25523, 25202, 25229, 25244,
					25249, 25266, 25276, 25282, 25054, 25205, 25524, 25143, 25293, 25126, 25450, 29095, 25527, 25299, 25302, 25305, 25309, 25312, 25315, 25319, 25680,
					25681, 25674, 25684, 25671, 25677, 25725, 25726, 25732, 25930, 25928, 25929, 25931, 25932, 25933, 3477, 25696, 25697, 25698, 3473, 3470, 25886, 25880,
					25875, 25876, 25877, 25922, 26312, 26132, 26133, 26142, 26148, 26131, 29374, 26431, 26433, 26435, 26442, 26443, 26444
			};

	public RaidBossInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public CreatureBaseStats getBaseStats()
	{
		if(_baseStats == null)
			_baseStats = new RaidBossBaseStat(this);
		return _baseStats;
	}

	@Override
	public boolean isRaid()
	{
		return true;
	}

//	@Override
//	public double getRewardRate(Player player)
//	{
//		return Config.RATE_DROP_ITEMS_RAIDBOSS; // ПА не увеличивает дроп с рейдов
//	}
//
//	@Override
//	public double getDropChanceMod(Player player)
//	{
//		return Config.DROP_CHANCE_MODIFIER_RAIDBOSS; // ПА не увеличивает дроп с боссов
//	}
//
//	@Override
//	public double getDropCountMod(Player player)
//	{
//		return Config.DROP_COUNT_MODIFIER_RAIDBOSS; // ПА не увеличивает дроп с боссов
//	}

	@Override
	protected void onDeath(Creature killer)
	{
		final int points = getTemplate().rewardRp;
		if(points > 0)
			calcRaidPointsReward(points);

		if(isReflectionBoss())
		{
			super.onDeath(killer);
			return;
		}

		if(killer != null && killer.isPlayable())
		{
			Player player = killer.getPlayer();
			if(player.isInParty())
			{
				for(Player member : player.getParty().getPartyMembers())
					if(member.isNoble())
						Hero.getInstance().addHeroDiary(member.getObjectId(), HeroDiary.ACTION_RAID_KILLED, getNpcId());
				player.getParty().broadCast(SystemMsg.CONGRATULATIONS_YOUR_RAID_WAS_SUCCESSFUL);
			}
			else
			{
				if(player.isNoble())
					Hero.getInstance().addHeroDiary(player.getObjectId(), HeroDiary.ACTION_RAID_KILLED, getNpcId());
				player.sendPacket(SystemMsg.CONGRATULATIONS_YOUR_RAID_WAS_SUCCESSFUL);
			}

			Quest q = QuestHolder.getInstance().getQuest(508);
			if(q != null)
			{
				if(player.getClan() != null && player.getClan().getLeader().isOnline())
				{
					QuestState st = player.getClan().getLeader().getPlayer().getQuestState(q);
					if(st != null)
						st.getQuest().onKill(this, st);
				}
			}
		}

		int boxId = 0;
		switch(getNpcId())
		{
			case 25035: // Shilens Messenger Cabrio
				boxId = 31027;
				break;
			case 25054: // Demon Kernon
				boxId = 31028;
				break;
			case 25126: // Golkonda, the Longhorn General
				boxId = 31029;
				break;
			case 25220: // Death Lord Hallate
				boxId = 31030;
				break;
		}

		if(boxId != 0)
		{
			NpcTemplate boxTemplate = NpcHolder.getInstance().getTemplate(boxId);
			if(boxTemplate != null)
			{
				final NpcInstance box = new NpcInstance(IdFactory.getInstance().getNextId(), boxTemplate, StatsSet.EMPTY);
				box.spawnMe(getLoc());
				box.setSpawnedLoc(getLoc());
				box.startDeleteTask(60000L);
			}
		}

		resForSkillRaid(killer);

		super.onDeath(killer);

		RaidBossSpawnManager.getInstance().onBossDeath(this);
	}

	private void resForSkillRaid(Creature killer) {
		if (RaidBossManager.getKilledBossCount(getRaidBossId()) == 0 && killer != null && (getRaidBossIds().length == 0 || ArrayUtils.contains(getRaidBossIds(), getNpcId()))) {
			Player player = killer.getPlayer();
			int skillLevel = player.getSkillLevel(120190, 0);
			double chance = 0;

			switch (skillLevel) {
				case 1: chance = 1.5; break;
				case 2: chance = 3.0; break;
				case 3: chance = 4.5; break;
				case 4: chance = 6.0; break;
				case 5: chance = 7.5; break;
				case 6: chance = 10.0; break;
				case 7: chance = 12.5; break;
				case 8: chance = 15.0; break;
				case 9: chance = 17.5; break;
				case 10: chance = 20.0; break;
				default: chance = 0; break;
			}

			if (player.getSkillLevel(120270, 0) > 0) {
				chance += 1.5; // Увеличение шанса на 1.5% при наличии умения 120270
			}

			double roll = Rnd.get(1, 100);
			if (roll <= chance) {
				resRb();
			}
			RaidBossManager.increaseKilledBossCount(getRaidBossId());
		}
	}


	private void resRb() {
		NpcTemplate boxTemplate = NpcHolder.getInstance().getTemplate(getRaidBossId());
		final RaidBossInstance box = new RaidBossInstance(IdFactory.getInstance().getNextId(), boxTemplate, StatsSet.EMPTY);
		box.spawnMe(getLoc());
		box.setSpawnedLoc(getLoc());
	}

	protected int getRaidBossId() {
		int[] raidBossIds = EMPTY_MONSTER_IDS;
		int npcId = getNpcId();
		int index = ArrayUtils.indexOf(raidBossIds, npcId);
		if (index != 0 && index != -1) {
			return raidBossIds[index];
		} else {
			return npcId;
		}
	}

	protected int[] getRaidBossIds()
	{
		return EMPTY_MONSTER_IDS;
	}

	@Override
	public void reduceCurrentHp(double damage, Creature attacker, Skill skill, boolean awake, boolean standUp, boolean directHp, boolean canReflectAndAbsorb, boolean transferDamage, boolean isDot, boolean sendReceiveMessage, boolean sendGiveMessage, boolean crit, boolean miss, boolean shld, boolean isStatic)
	{
		if (attacker != null)
		{
			if (attacker instanceof Player || attacker instanceof Servitor)
			{
				if (Config.REBIRTHS_TO_TAKE_DAMAGE_ENABLE)
				{
					if (attacker.getPlayer() != null && attacker.getPlayer().getRebirthCount() < getTemplate().getRebirthsToTakeDamage())
					{
						return;
					}
				}

				if (Config.BOSS_STATIC_DAMAGE_RECEIVED.containsKey(getNpcId())) {
					final double staticDamage = Config.BOSS_STATIC_DAMAGE_RECEIVED.getOrDefault(getNpcId(), damage);
					if (damage != staticDamage) {
						damage = staticDamage;
					}
				}
			}
		}

		super.reduceCurrentHp(damage, attacker, skill, awake, standUp, directHp, canReflectAndAbsorb, transferDamage, isDot, sendReceiveMessage, sendGiveMessage, crit, miss, shld, isStatic);
	}

	private void calcRaidPointsReward(int totalPoints)
	{
		Map<PlayerGroup, GroupInfo> groupsInfo = new HashMap<PlayerGroup, GroupInfo>();
		double totalDamage = 0;

		// Разбиваем игроков по группам. По возможности используем наибольшую из доступных групп: Command Channel → Party → StandAlone (сам плюс пет :)
		for(HateInfo ai : getAggroList().getPlayableMap().values())
		{
			Player player = ai.attacker.getPlayer();
			if(player == null)
				continue;

			PlayerGroup group = player.getParty() != null ? (player.getParty().getCommandChannel() != null ? player.getParty().getCommandChannel() : player.getParty()) : player;
			GroupInfo info = groupsInfo.get(group);
			boolean addDamage = true;
			if(info == null)
			{
				info = new GroupInfo();
				groupsInfo.put(group, info);
				addDamage = false;
			}

			for(Player p : group)
			{
				if(!p.isDead() && p.isInRangeZ(this, Config.ALT_PARTY_DISTRIBUTION_RANGE))
				{
					info.players.add(p);
					addDamage = true;
				}
			}

			if(addDamage)
			{
				info.damage += ai.damage;
				totalDamage += Math.max(0, ai.damage);
			}
		}

		totalDamage = Math.max(totalDamage, getMaxHp());

		for(Map.Entry<PlayerGroup, GroupInfo> groupInfo : groupsInfo.entrySet())
		{
			PlayerGroup group = groupInfo.getKey();
			GroupInfo info = groupInfo.getValue();

			double damage = info.damage;
			if(damage <= 1) // TODO: Чего 1 а не 0?
				continue;

			HashSet<Player> players = info.players;
			if(!players.isEmpty())
			{
				// это та часть, которую игрок заслужил дамагом группы, но на нее может быть наложен штраф от уровня игрока
				int points = (int) (totalPoints * (totalDamage / damage / players.size() / 100.));
				for(Player player : players)
				{
					int playerReward = (int) Math.round(points * Experience.penaltyModifier(calculateLevelDiffForDrop(player.getLevel()), 9));
					if(playerReward > 0)
						player.addRaidPoints(playerReward, true);
				}
			}
		}
	}

	@Override
	protected void onSpawn()
	{
		super.onSpawn();
		addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 4045, 1)); // Resist Full Magic Attack
		//this.getAI().addTaskBuff(this, SkillEntry.makeSkillEntry(SkillEntryType.NONE, 77777, 1));
		RaidBossSpawnManager.getInstance().onBossSpawned(this);
	}

	@Override
	public boolean isFearImmune()
	{
		return true;
	}

	@Override
	public boolean isParalyzeImmune()
	{
		return true;
	}

	@Override
	public boolean isLethalImmune()
	{
		return true;
	}

	@Override
	public boolean isThrowAndKnockImmune()
	{
		return true;
	}

	@Override
	public boolean isTransformImmune()
	{
		return true;
	}

	@Override
	public boolean hasRandomWalk()
	{
		return false;
	}

	@Override
	public boolean canChampion()
	{
		return false;
	}

	@Override
	public void onZoneEnter(Zone zone)
	{
		if (getNpcId() == 29169)
		{
			super.onZoneEnter(zone);
			return;
		}

		if(!zone.checkIfInZone(getSpawnedLoc().getX(), getSpawnedLoc().getY(), getSpawnedLoc().getZ()))
		{
			if(zone.getType() == ZoneType.peace_zone || zone.getType() == ZoneType.battle_zone || zone.getType() == ZoneType.SIEGE)
				getAI().returnHomeAndRestore(isRunning());
		}
	}
}