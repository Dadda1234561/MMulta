package l2s.gameserver.model.instances;

import java.util.*;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.math.SafeMath;
import l2s.commons.util.Rnd;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.ChampionTemplateHolder;
import l2s.gameserver.instancemanager.CursedWeaponsManager;
import l2s.gameserver.model.AggroList.HateInfo;
import l2s.gameserver.model.ChampionTemplate;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Manor;
import l2s.gameserver.model.Party;
import l2s.gameserver.model.Playable;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.PlayerGroup;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.actor.basestats.CreatureBaseStats;
import l2s.gameserver.model.actor.basestats.MonsterBaseStat;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestEventType;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.model.reward.*;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExMagicAttackInfo;
import l2s.gameserver.network.l2.s2c.SocialActionPacket;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.skills.AbnormalEffect;
import l2s.gameserver.stats.Formulas;
import l2s.gameserver.stats.Stats;
import l2s.gameserver.stats.funcs.Func;
import l2s.gameserver.stats.funcs.FuncAdd;
import l2s.gameserver.stats.funcs.FuncTemplate;
import l2s.gameserver.templates.StatsSet;
import l2s.gameserver.templates.item.data.RewardItemData;
import l2s.gameserver.templates.npc.Faction;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.NpcUtils;

/**
 * This class manages all Monsters.
**/
public class MonsterInstance extends NpcInstance
{
	public static final String UNSOWING = "unsowing";

	protected class GroupInfo
	{
		public HashSet<Player> players;
		public double damage;

		public GroupInfo()
		{
			this.players = new HashSet<Player>();
			this.damage = 0.;
		}
	}

	/** crops */
	private boolean _isSeeded;
	private int _seederId;
	private boolean _altSeed;
	private RewardItem _harvestItem;

	private final Lock harvestLock = new ReentrantLock();

	private int overhitAttackerId;
	/** Stores the extra (over-hit) damage done to the L2NpcInstance when the attacker uses an over-hit enabled skill */
	private double _overhitDamage;

	/** True if a Dwarf has used Spoil on this L2NpcInstance */
	private boolean _isSpoiled;
	private int _isRobbed = 0; // 0 - not robbed, 1 - fail robbed, 2 - success robbed
	private int spoilerId;
	/** Table containing all Items that a Dwarf can Sweep on this L2NpcInstance */
	private List<RewardItem> _sweepItems;
	private boolean _sweeped;
	private final Lock sweepLock = new ReentrantLock();
	private int _isChampion;
	private int _isUpMonster;
	private final boolean _canMove;
	private final boolean _isUnsowing;

	public MonsterInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);

		_isUnsowing = getParameter(UNSOWING, true);
		_canMove = getParameter("canMove", true);
	}

	@Override
	public boolean isMovementDisabled()
	{
		return !_canMove || super.isMovementDisabled();
	}

	@Override
	public boolean isLethalImmune()
	{
		return _isChampion > 0 || super.isLethalImmune() || _isUpMonster > 0;
	}

	@Override
	public boolean isFearImmune()
	{
		return _isChampion > 0 || super.isFearImmune() || _isUpMonster > 0;
	}

	@Override
	public boolean isParalyzeImmune()
	{
		return _isChampion > 0 || super.isParalyzeImmune() || _isUpMonster > 0;
	}

	@Override
	public boolean isAutoAttackable(Creature attacker)
	{
		return attacker.getPlayer() != null || attacker.isDefender();
	}

	@Override
	public double getRewardRate(Player player)
	{
		return super.getRewardRate(player); // ПА не увеличивает дроп с рейдов
	}

	@Override
	public double getDropChanceMod(Player player)
	{
		return super.getDropChanceMod(player);  // ПА не увеличивает дроп с боссов
	}

	@Override
	public double getDropCountMod(Player player)
	{
		return super.getDropCountMod(player);  // ПА не увеличивает дроп с боссов
	}

	@Override
	public boolean isChampion() {
		return getAbnormalEffects().contains(AbnormalEffect.CHAMPIONS_AURAS_NEW_1) ||
				getAbnormalEffects().contains(AbnormalEffect.CHAMPIONS_AURAS_NEW_2) ||
				getAbnormalEffects().contains(AbnormalEffect.CHAMPIONS_AURAS_NEW_3) ||
				getAbnormalEffects().contains(AbnormalEffect.CHAMPIONS_AURAS_NEW_4) ||
				getAbnormalEffects().contains(AbnormalEffect.CHAMPIONS_AURAS_NEW_5);
	}

	public int getChampion()
	{
		return _isChampion;
	}

	public void setChampion(Player player)
	{
		// if player got disconnected or left
		if (player == null) {
			return;
		}

		if(getReflection().canChampions() && canChampion())
		{
			double random = Rnd.nextDouble();
			if(Config.ALT_CHAMPION_CHANCE / 100. >= random)
				setChampion(player.getChampionLvlChange());
			else
				setChampion(0);
		}
		else
			setChampion(0);
	}

	@Override
	public CreatureBaseStats getBaseStats()
	{
		if(_baseStats == null)
			_baseStats = new MonsterBaseStat(this);
		return _baseStats;
	}

	public int getUpMonster()
	{
		return _isUpMonster;
	}

	public void setUpMonster(Player player)
	{
		if(getReflection().canUpMonsters() && canUpMonster() && !isRaid())
		{
			double random = Rnd.nextDouble();
			if(Config.ALT_UP_MONSTER_CHANCE / 100. >= random)
				setUpMonster(player.getUpMonsterChange());
			else
				setUpMonster(0);
		}
		else
			setUpMonster(0);
	}

	public void setChampion(int level)
	{
		if(level == 0)
		{
			//removeSkillById(4407);
			_isChampion = 0;
		}
		else
		{
			//addSkill(SkillEntry.makeSkillEntry(SkillEntryType.NONE, 4407, level));
			_isChampion = level;
			setAggroRange(0);
		}
	}

	public boolean canChampion()
	{
		return !isMinion() && getTemplate().rewardExp > 0 && getTemplate().level >= Config.ALT_CHAMPION_MIN_LEVEL && getTemplate().level <= Config.ALT_CHAMPION_TOP_LEVEL;
	}

	public void setUpMonster(int level)
	{
		if (level == 0)
		{
			_isUpMonster = 0;
		}
		else
		{
			_isUpMonster = level;
		}
	}

	public boolean canUpMonster()
	{
		return !isChampion() && !isMinion() && getTemplate().rewardExp > 0 && getTemplate().level >= Config.ALT_UP_MONSTER_MIN_LEVEL && getTemplate().level <= Config.ALT_UP_MONSTER_TOP_LEVEL;
	}

	/*@Override
	public TeamType getTeam()
	{
		return getChampion() == 2 ? TeamType.RED : getChampion() == 1 ? TeamType.BLUE : TeamType.NONE;
	}*/

	@Override
	protected void onDespawn()
	{
		setOverhitDamage(0);
		setOverhitAttacker(null);
		clearSweep();
		clearHarvest();

		super.onDespawn();
	}

	@Override
	public void onSpawnMinion(NpcInstance minion)
	{
		if(minion.isMonster())
		{
			if(getChampion() == 2)
				((MonsterInstance) minion).setChampion(1);
			else
				((MonsterInstance) minion).setChampion(0);
		}
		super.onSpawnMinion(minion);
	}

	@Override
	protected void onDeath(Creature killer)
	{
		if (killer != null && killer.getPlayer() != null) {
			calculateRewards(killer);
			setChampion(killer.getPlayer());
			if(isMonster() && _isChampion > 0)
				spawnNewChampion(killer.getPlayer());

			if (!isChampion() && !isRaid() && isMonster())
				setUpMonster(killer.getPlayer());

			if(getLevel() >= 85) {
				calculateAether(killer);
				if(isOrbisMonster())
					calculateMarkEndurity(killer);
			}
		}
		super.onDeath(killer);
	}

	protected void spawnNewChampion(Player player)
	{
		//DM New Champion System 1-5 lvl
		if(isMonster() && player.getPlayer().getChampionLvlChange() != 0)
		{
			if(getReflection().canChampions() && canChampion())
			{
				if (getLevel() >= 90 && _isChampion > 0){
					_isChampion = _isChampion + 10;
				}
				NpcInstance npc = NpcUtils.spawnSingle(this.getNpcId(), this.getLoc(), this.getReflection(), Config.ALT_CHAMPION_DESPAWN * 60 * 1000); // В минутах
				ChampionTemplate championTemplate = ChampionTemplateHolder.getInstance().getTemplate(_isChampion);
				if (championTemplate == null) {
					return;
				}
                for (FuncTemplate funcTpl : championTemplate.getAttachedFuncs()) {
                    Func func = funcTpl.getFunc(npc);
                    if (func != null) {
                        npc.getStat().addFuncs(func);
                    }
                }

                applyChampionAbnormalEffect(npc);
				// restore hp
				npc.setCurrentHpMp(npc.getMaxHp(), npc.getMaxMp(), true);

				// add improved drop
				final RewardList rewardList = new RewardList(RewardType.EVENT_GROUPED, true);
				final RewardGroup rewardGroup = new RewardGroup(RewardList.MAX_CHANCE, null);

				if (Config.DROP_IMPROVED_ITEMS) {
					for(RewardData drop : getImprovedDrop()) {
						rewardGroup.addData(drop);
					}
				}

				// Additional Drop
				if (Config.ALT_ENABLE_ADDITIONAL_DROP && !championTemplate.getAdditionalDrop().isEmpty()) {
					for(RewardData drop : championTemplate.filterAdditionalDrop(this)) {
						rewardGroup.addData(drop);
					}
				}

				if (!rewardGroup.getItems().isEmpty()) {
					rewardList.add(rewardGroup);
					npc.addRewardList(rewardList);
				}

			}
			if(_isChampion > 0 && getAggroRange() > 0) {
				setAggroRange(0);
			}
		}
	}

	private List<RewardData> getImprovedDrop() {
		List<RewardData> improvedDrop = Collections.emptyList();
		switch (_isChampion) {
			case 1:
				improvedDrop = Config.IMPROVED_DROP_CHAMPION_1.getOrDefault("MONSTER", Collections.emptyList());
				break;
			case 2:
				improvedDrop = Config.IMPROVED_DROP_CHAMPION_2.getOrDefault("MONSTER", Collections.emptyList());
				break;
			case 3:
				improvedDrop = Config.IMPROVED_DROP_CHAMPION_3.getOrDefault("MONSTER", Collections.emptyList());
				break;
			case 4:
				improvedDrop = Config.IMPROVED_DROP_CHAMPION_4.getOrDefault("MONSTER", Collections.emptyList());
				break;
			case 5:
				improvedDrop = Config.IMPROVED_DROP_CHAMPION_5.getOrDefault("MONSTER", Collections.emptyList());
				break;
		}
		return improvedDrop;
	}

	private void applyUpMonsterAbnormalEffect(NpcInstance npc) {
		AbnormalEffect abnormal = AbnormalEffect.valueOf("GOLD_STAR" + _isUpMonster + "_AVE");
		if (abnormal != null) {
			npc.startAbnormalEffect(abnormal);
		}
	}

	private void applyChampionAbnormalEffect(NpcInstance npc) {
		switch(_isChampion) {
			case 0:
				break;
			case 1:
				npc.startAbnormalEffect(AbnormalEffect.CHAMPIONS_AURAS_NEW_1);
				break;
			case 2:
				npc.startAbnormalEffect(AbnormalEffect.CHAMPIONS_AURAS_NEW_2);
				break;
			case 3:
				npc.startAbnormalEffect(AbnormalEffect.CHAMPIONS_AURAS_NEW_3);
				break;
			case 4:
				npc.startAbnormalEffect(AbnormalEffect.CHAMPIONS_AURAS_NEW_4);
				break;
			case 5:
				npc.startAbnormalEffect(AbnormalEffect.CHAMPIONS_AURAS_NEW_5);
				break;
			case 11:
				npc.startAbnormalEffect(AbnormalEffect.CHAMPIONS_AURAS_NEW_1);
				break;
			case 12:
				npc.startAbnormalEffect(AbnormalEffect.CHAMPIONS_AURAS_NEW_2);
				break;
			case 13:
				npc.startAbnormalEffect(AbnormalEffect.CHAMPIONS_AURAS_NEW_3);
				break;
			case 14:
				npc.startAbnormalEffect(AbnormalEffect.CHAMPIONS_AURAS_NEW_4);
				break;
			case 15:
				npc.startAbnormalEffect(AbnormalEffect.CHAMPIONS_AURAS_NEW_5);
				break;
			default:
		}
	}

	protected int spawnUpMonster(Player player)
	{
		if(isMonster() && player.getPlayer().getUpMonsterChange() != 0)
		{
			if(getReflection().canUpMonsters() && canUpMonster())
			{
				NpcInstance npc = NpcUtils.spawnSingle(this.getNpcId(), this.getLoc(), this.getReflection(), Config.ALT_UP_MONSTER_DESPAWN * 60 * 1000); // В минутах
				ChampionTemplate upMonsterTemplate = ChampionTemplateHolder.getInstance().getTemplate(_isUpMonster);
				if (upMonsterTemplate == null) {
					return 0;
				}

                for (FuncTemplate funcTpl : upMonsterTemplate.getAttachedFuncs()) {
                    Func func = funcTpl.getFunc(npc);
                    if (func != null) {
                        npc.getStat().addFuncs(func);
                    }
                }
				
				applyUpMonsterAbnormalEffect(npc);
				
				// restore hp
				npc.setCurrentHpMp(npc.getMaxHp(), npc.getMaxMp(), true);

				// Additional Drop
				RewardList rewardList = new RewardList(RewardType.EVENT_GROUPED, true);
				RewardGroup rewardGroup = new RewardGroup(RewardList.MAX_CHANCE, null);

				if (!upMonsterTemplate.getAdditionalDrop().isEmpty()) {
					for(RewardData drop : upMonsterTemplate.filterAdditionalDrop(this)) {
						rewardGroup.addData(drop);
					}
				}

				if (!rewardGroup.getItems().isEmpty()) {
					rewardList.add(rewardGroup);
					npc.addRewardList(rewardList);
				}

				return npc.getObjectId();
			}
		}

		return 0;
	}

	@Override
	protected void onReduceCurrentHp(double damage, Creature attacker, Skill skill, boolean awake, boolean standUp, boolean directHp, boolean isDot, boolean isStatic)
	{
		if(skill != null && skill.isOverhit())
		{
			// Calculate the over-hit damage
			// Ex: mob had 10 HP left, over-hit skill did 50 damage total, over-hit damage is 40
			double overhitDmg = (getCurrentHp() - damage) * -1;
			if(overhitDmg <= 0)
			{
				setOverhitDamage(0);
				setOverhitAttacker(null);
			}
			else
			{
				setOverhitDamage(overhitDmg);
				setOverhitAttacker(attacker);
			}
		}

		super.onReduceCurrentHp(damage, attacker, skill, awake, standUp, directHp, isDot, isStatic);
	}

	public void calculateRewards(Creature lastAttacker)
	{
		Creature topDamager = getAggroList().getTopDamager(lastAttacker);
		if(lastAttacker == null || !lastAttacker.isPlayable())
			lastAttacker = topDamager;

		if(lastAttacker == null || !lastAttacker.isPlayable())
			return;

		Player killer = lastAttacker.getPlayer();
		if(killer == null)
			return;

		Map<Playable, HateInfo> aggroMap = getAggroList().getPlayableMap();

		Set<Quest> quests = getTemplate().getEventQuests(QuestEventType.MOB_KILLED_WITH_QUEST);
		if(quests != null && !quests.isEmpty())
		{
			List<Player> players = null; // массив с игроками, которые могут быть заинтересованы в квестах
			if(isRaid() && Config.ALT_NO_LASTHIT) // Для альта на ластхит берем всех игроков вокруг
			{
				players = new ArrayList<Player>();
				for(Playable pl : aggroMap.keySet())
					if(!pl.isDead() && (isInRangeZ(pl, Config.ALT_PARTY_DISTRIBUTION_RANGE) || killer.isInRangeZ(pl, Config.ALT_PARTY_DISTRIBUTION_RANGE)))
						if(!players.contains(pl.getPlayer())) // не добавляем дважды если есть пет
							players.add(pl.getPlayer());
			}
			else if(killer.getParty() != null) // если пати то собираем всех кто подходит
			{
				players = new ArrayList<Player>(killer.getParty().getMemberCount());
				for(Player pl : killer.getParty().getPartyMembers())
					if(!pl.isDead() && (isInRangeZ(pl, Config.ALT_PARTY_DISTRIBUTION_RANGE) || killer.isInRangeZ(pl, Config.ALT_PARTY_DISTRIBUTION_RANGE)))
						players.add(pl);
			}

			for(Quest quest : quests)
			{
				Player toReward = killer;
				if(quest.getPartyType() != Quest.PARTY_NONE && players != null)
					if(isRaid() || quest.getPartyType() == Quest.PARTY_ALL) // если цель рейд или квест для всей пати награждаем всех участников
					{
						for(Player pl : players)
						{
							QuestState qs = pl.getQuestState(quest);
							if(qs != null && !qs.isCompleted())
								quest.notifyKill(this, qs);
						}
						toReward = null;
					}
					else
					{ // иначе выбираем одного
						List<Player> interested = new ArrayList<Player>(players.size());
						for(Player pl : players)
						{
							QuestState qs = pl.getQuestState(quest);
							if(qs != null && !qs.isCompleted()) // из тех, у кого взят квест
								interested.add(pl);
						}

						if(interested.isEmpty())
							continue;

						toReward = interested.get(Rnd.get(interested.size()));
						if(toReward == null)
							toReward = killer;
					}

				if(toReward != null)
				{
					QuestState qs = toReward.getQuestState(quest);
					if(qs != null && !qs.isCompleted())
						quest.notifyKill(this, qs);
				}
			}
		}

		Map<PlayerGroup, GroupInfo> groupsInfo = new HashMap<PlayerGroup, GroupInfo>();
		double totalDamage = 0;

		// Разбиваем игроков по группам. По возможности используем наибольшую из доступных групп: Command Channel → Party → StandAlone (сам плюс пет :)
		for(HateInfo ai : aggroMap.values())
		{
			Player player = ai.attacker.getPlayer();
			if(player == null)
				continue;

			PlayerGroup group = player.getParty() != null ? player.getParty() : player;
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

			if(group instanceof Party)
			{
				Party party = (Party) group;
				int partylevel = 1;
				for(Player p : info.players)
				{
					if(p.getLevel() > partylevel)
						partylevel = p.getLevel();
				}
				double[] xpsp = calculateExpAndSp(partylevel, damage, totalDamage, lastAttacker);
				xpsp[0] = applyOverhit(killer, xpsp[0]);
				party.distributeXpAndSp(xpsp[0], xpsp[1], info.players, lastAttacker, this);
			}
			else if(group instanceof Player)
			{
				Player player = (Player) group;
				double[] xpsp = calculateExpAndSp(player.getLevel(), damage, totalDamage, lastAttacker);
				xpsp[0] = applyOverhit(killer, xpsp[0]);
				player.addExpAndCheckBonus(this, (long) xpsp[0], (long) xpsp[1]);
			}
		}

		if(topDamager != null && topDamager.isPlayable())
		{
			for(RewardList rewardList : getRewardLists())
				rollRewards(rewardList, lastAttacker, topDamager);

			Player player = topDamager.getPlayer();
			if(player != null && Math.abs(getLevel() - player.getLevel()) < 9)
			{
				for(RewardItemData reward : player.getPremiumAccount().getRewards())
				{
					if(Rnd.chance(reward.getChance()))
						ItemFunctions.addItem(player, reward.getId(), Rnd.get(reward.getMinCount(), reward.getMaxCount()));
				}
				/*if(getChampion() > 0 && Config.SPECIAL_ITEM_ID > 0 && Config.SPECIAL_ITEM_COUNT > 0 && Math.abs(getLevel() - player.getLevel()) < 9 && Rnd.chance(Config.SPECIAL_ITEM_DROP_CHANCE))
					ItemFunctions.addItem(player, Config.SPECIAL_ITEM_ID, Config.SPECIAL_ITEM_COUNT);*/
			}
		}

		// Check the drop of a cursed weapon
		CursedWeaponsManager.getInstance().dropAttackable(this, killer);
	}

	// DM auto-spoil
	protected void sweepPassive(Creature activeChar, Creature target)
	{
		if(!activeChar.isPlayer())
			return;

		if(target == null || !target.isMonster() || !target.isDead())
			return;

		final MonsterInstance monter = (MonsterInstance) target;
		if(monter.isSweeped() || !monter.isSpoiled())
			return;

		final Player player = activeChar.getPlayer();
		if(!monter.isSpoiled(player))
		{
			activeChar.sendPacket(SystemMsg.THERE_ARE_NO_PRIORITY_RIGHTS_ON_A_SWEEPER);
			return;
		}

		monter.takeSweep(player);
		//monter.endDecayTask();
	}

	@Override
	public void onRandomAnimation()
	{
		if(System.currentTimeMillis() - _lastSocialAction > 10000L)
		{
			broadcastPacket(new SocialActionPacket(getObjectId(), 1));
			_lastSocialAction = System.currentTimeMillis();
		}
	}

	@Override
	public void startRandomAnimation()
	{
		//У мобов анимация обрабатывается в AI
	}

	@Override
	public int getKarma()
	{
		return 0;
	}

	public RewardItem takeHarvest()
	{
		harvestLock.lock();
		try
		{
			RewardItem harvest;
			harvest = _harvestItem;
			clearHarvest();
			return harvest;
		}
		finally
		{
			harvestLock.unlock();
		}
	}

	public void clearHarvest()
	{
		harvestLock.lock();
		try
		{
			_harvestItem = null;
			_altSeed = false;
			_seederId = 0;
			_isSeeded = false;
		}
		finally
		{
			harvestLock.unlock();
		}
	}

	@Override
	protected void onSpawn() {

		if (Config.ADDITIONAL_MONSTER_BOW_DEFENCE_TRAIT_MOD_ENABLED) {
			getStat().addFuncs(new FuncAdd(Stats.DEFENCE_TRAIT_BOW, 0x40, null, Config.ADDITIONAL_MONSTER_BOW_DEFENCE_TRAIT_ADD, StatsSet.EMPTY));
			getStat().addFuncs(new FuncAdd(Stats.DEFENCE_TRAIT_CROSSBOW, 0x40, null, Config.ADDITIONAL_MONSTER_BOW_DEFENCE_TRAIT_ADD, StatsSet.EMPTY));
			getStat().addFuncs(new FuncAdd(Stats.DEFENCE_TRAIT_TWOHANDCROSSBOW, 0x40, null, Config.ADDITIONAL_MONSTER_BOW_DEFENCE_TRAIT_ADD, StatsSet.EMPTY));
		}

		// add addination drop
		final RewardList rewardList = new RewardList(RewardType.EVENT_GROUPED, true);
		final RewardGroup rewardGroup = new RewardGroup(RewardList.MAX_CHANCE, null);
		int level = getLevel();

		List<RewardData> improvedDrop = new ArrayList<>(Collections.emptyList());

		for(RewardData data : Config.ADDITIONAL_DROP_1) {
			if (level >= data.getMinLevel() && level <= data.getMaxLevel()) {
				improvedDrop.add(data);
			}
		}

//		if(level >= 10 && level <= 19) {
//			improvedDrop = Config.ADDITIONAL_DROP_1.getOrDefault("MONSTER", Collections.emptyList());
//		} else if (level >= 20 && level <= 29) {
//			improvedDrop = Config.ADDITIONAL_DROP_2.getOrDefault("MONSTER", Collections.emptyList());
//		} else if (level >= 30 && level <= 45) {
//			improvedDrop = Config.ADDITIONAL_DROP_3.getOrDefault("MONSTER", Collections.emptyList());
//		}
//
//		if(level >= 46 && level <= 54) {
//			improvedDrop = Config.ADDITIONAL_DROP_4.getOrDefault("MONSTER", Collections.emptyList());
//		}
//		if(level >= 55 && level <= 70) {
//			improvedDrop = Config.ADDITIONAL_DROP_5.getOrDefault("MONSTER", Collections.emptyList());
//		}
//		if(level >= 10 && level <= 85) {
//			improvedDrop = Config.ADDITIONAL_DROP_6.getOrDefault("MONSTER", Collections.emptyList());
//		}

		for(RewardData drop : improvedDrop) {
			rewardGroup.addData(drop);
		}
		if (!rewardGroup.getItems().isEmpty()) {
			rewardList.add(rewardGroup);
			addRewardList(rewardList);
		}
		super.onSpawn();
	}

	public boolean setSeeded(Player player, int seedId, boolean altSeed)
	{
		harvestLock.lock();
		try
		{
			if(isSeeded())
				return false;
			_isSeeded = true;
			_altSeed = altSeed;
			_seederId = player.getObjectId();
			_harvestItem = new RewardItem(Manor.getInstance().getCropType(seedId));
			// Количество всходов от xHP до (xHP + xHP/2)
			if(getTemplate().rateHp > 1)
				_harvestItem.count = Rnd.get(Math.round(getTemplate().rateHp), Math.round(1.5 * getTemplate().rateHp));
		}
		finally
		{
			harvestLock.unlock();
		}

		return true;
	}

	public boolean isSeeded(Player player)
	{
		//засиден этим игроком, и смерть наступила не более 20 секунд назад
		return isSeeded() && _seederId == player.getObjectId() && (System.currentTimeMillis() - getDeathTime()) < 20000L;
	}

	public boolean isSeeded()
	{
		return _isSeeded;
	}

	/**
	 * Return True if this L2NpcInstance has drops that can be sweeped.<BR><BR>
	 */
	public boolean isSpoiled()
	{
		return _isSpoiled;
	}

	public boolean isSpoiled(Player player)
	{
		if(!isSpoiled()) // если не заспойлен то false
			return false;

		// заспойлен этим игроком, и смерть наступила не более 20 секунд назад
		if (player.getObjectId() == spoilerId && (System.currentTimeMillis() - getDeathTime()) < 20000L)
			return true;

		if (player.getObjectId() == spoilerId && getDeathTime() < 20000L)
			return true;

		if (player.isInParty())
			for (Player pm : player.getParty().getPartyMembers())
				if (pm.getObjectId() == spoilerId && getDistance(pm) < Config.ALT_PARTY_DISTRIBUTION_RANGE)
					return true;
		return false;
	}

	/**
	 * Set the spoil state of this L2NpcInstance.<BR><BR>
	 * @param player
	 */
	public boolean setSpoiled(Player player)
	{
		sweepLock.lock();
		try
		{
			if(isSpoiled())
				return false;
			_isSpoiled = true;
			spoilerId = player.getObjectId();
		}
		finally
		{
			sweepLock.unlock();
		}
		return true;
	}

	/**
	 * Return True if a Dwarf use Sweep on the L2NpcInstance and if item can be spoiled.<BR><BR>
	 */
	public boolean isSweepActive()
	{
		sweepLock.lock();
		try
		{
			return _sweepItems != null && _sweepItems.size() > 0;
		}
		finally
		{
			sweepLock.unlock();
		}
	}

	public boolean takeSweep(final Player player)
	{
		sweepLock.lock();
		try
		{
			_sweeped = true;

			if(_sweepItems == null || _sweepItems.isEmpty())
			{
				clearSweep();
				return false;
			}

			boolean lucky = Formulas.tryLuck(player);
			for(RewardItem item : _sweepItems)
			{
				//if(lucky)
				//	item.count *= 2;

				final ItemInstance sweep = ItemFunctions.createItem(item.itemId);
				sweep.setCount(item.count);

				if(player.isInParty() && player.getParty().isDistributeSpoilLoot())
				{
					player.getParty().distributeItem(player, sweep, null);
					continue;
				}

				if(!player.getInventory().validateCapacity(sweep) || !player.getInventory().validateWeight(sweep))
				{
					sweep.dropToTheGround(player, this);
					continue;
				}

				player.getInventory().addItem(sweep);

				SystemMessagePacket smsg;
				if(item.count == 1)
				{
					smsg = new SystemMessagePacket(SystemMsg.YOU_HAVE_OBTAINED_S1);
					smsg.addItemName(item.itemId);
					player.sendPacket(smsg);
				}
				else
				{
					smsg = new SystemMessagePacket(SystemMsg.YOU_HAVE_OBTAINED_S2_S1);
					smsg.addItemName(item.itemId);
					smsg.addLong(item.count);
					player.sendPacket(smsg);
				}

				if(player.isInParty())
				{
					if(item.count == 1)
					{
						smsg = new SystemMessagePacket(SystemMsg.C1_HAS_OBTAINED_S2_BY_USING_SWEEPER);
						smsg.addName(player);
						smsg.addItemName(item.itemId);
						player.getParty().broadcastToPartyMembers(player, smsg);
					}
					else
					{
						smsg = new SystemMessagePacket(SystemMsg.C1_HAS_OBTAINED_S3_S2_BY_USING_SWEEPER);
						smsg.addName(player);
						smsg.addItemName(item.itemId);
						smsg.addLong(item.count);
						player.getParty().broadcastToPartyMembers(player, smsg);
					}
				}

				// TODO: Должно ли быть здесь?
				if(lucky)
					player.onSuccessLucky();
			}
			clearSweep();
			return true;
		}
		finally
		{
			sweepLock.unlock();
		}
	}

	public boolean isSweeped()
	{
		return _sweeped;
	}

	public void clearSweep()
	{
		sweepLock.lock();
		try
		{
			_isSpoiled = false;
			spoilerId = 0;
			_sweepItems = null;
			_isRobbed = 0;
		}
		finally
		{
			sweepLock.unlock();
		}
	}

	public void rollRewards(RewardList list, final Creature lastAttacker, Creature topDamager)
	{
		RewardType type = list.getType();
		if(type == RewardType.SWEEP && !isSpoiled())
			return;

		final Creature activeChar = type == RewardType.SWEEP ? lastAttacker : topDamager;
		final Player activePlayer = activeChar.getPlayer();

		if(activePlayer == null)
			return;

		//final double penaltyMod = Experience.penaltyModifier(calculateLevelDiffForDrop(topDamager.getLevel()), 9);
		List<RewardItem> rewardItems = list.roll(activePlayer, 1., this);
		switch(type)
		{
			case SWEEP:
				_sweepItems = rewardItems;
				// DM auto-spoil
				if (isSpoiled(activePlayer) && activePlayer.getKnownSkill(70099) != null)
					sweepPassive(activePlayer, this);
				break;
			default:
				for(RewardItem drop : rewardItems)
				{
					// Если в моба посеяно семя, причем не альтернативное - не давать никакого дропа, кроме адены.
					if(isSeeded() && !_altSeed && !drop.isAdena() && !drop.isHerb())
						continue;

					if(!Config.DROP_ONLY_THIS.isEmpty() && !Config.DROP_ONLY_THIS.contains(drop.itemId))
					{
						if(!(Config.INCLUDE_RAID_DROP && isRaid()))
							return;
					}
					dropItem(activePlayer, drop.itemId, drop.count);
				}
				break;
		}
	}

	private double[] calculateExpAndSp(int level, double damage, double totalDamage, Creature player) {
		/* TODO:
			if ( getInstanceUIData().getIsClassicServer() || getInstanceUIData().getIsArenaServer() )
			{
				if (myLevel < 78 )
				{
					if (TargetLevelDiff <= -11)
					{
						OutColor.R=255;
						OutColor.G=0;
						OutColor.B=0;
					}
					else if (TargetLevelDiff > -11 &&TargetLevelDiff <= -6)
					{
						OutColor.R=255;
						OutColor.G=145;
						OutColor.B=145;
					}
					else if (TargetLevelDiff > -6 &&TargetLevelDiff <= -3)
					{
						OutColor.R=250;
						OutColor.G=254;
						OutColor.B=145;
					}
					else if (TargetLevelDiff > -3 &&TargetLevelDiff <= 2)
					{
						OutColor.R=255;
						OutColor.G=255;
						OutColor.B=255;
					}
					else if (TargetLevelDiff > 2 &&TargetLevelDiff <= 5)
					{
						OutColor.R=162;
						OutColor.G=255;
						OutColor.B=171;
					}
					else if (TargetLevelDiff > 5 &&TargetLevelDiff <= 10)
					{
						OutColor.R=162;
						OutColor.G=168;
						OutColor.B=252;
					}
					else if (TargetLevelDiff > 10)
					{
						OutColor.R=0;
						OutColor.G=0;
						OutColor.B=255;
					}
				}
				// АЇАъ·№є§ 78 ~ 84 АП °жїм ·№є§ ВчАМ »ц»у ЗҐЅГё¦ БЩї© єёї©БШґЩ. 
				else if( myLevel >= 78 && myLevel < 85 )
				{		
					if (TargetLevelDiff <= -11)
					{
						OutColor.R=255;
						OutColor.G=0;
						OutColor.B=0;
					}
					else if (TargetLevelDiff > -11 &&TargetLevelDiff <= -4)
					{
						OutColor.R=255;
						OutColor.G=145;
						OutColor.B=145;
					}
					else if (TargetLevelDiff > -4 &&TargetLevelDiff <= -2)
					{
						OutColor.R=250;
						OutColor.G=254;
						OutColor.B=145;
					}
					else if (TargetLevelDiff > -2 &&TargetLevelDiff <= 1)
					{
						OutColor.R=255;
						OutColor.G=255;
						OutColor.B=255;
					}
					else if (TargetLevelDiff > 1 &&TargetLevelDiff <= 3)
					{
						OutColor.R=162;
						OutColor.G=255;
						OutColor.B=171;
					}
					else if (TargetLevelDiff > 3 &&TargetLevelDiff <= 10)
					{
						OutColor.R=162;
						OutColor.G=168;
						OutColor.B=252;
					}
					else if (TargetLevelDiff > 10)
					{
						OutColor.R=0;
						OutColor.G=0;
						OutColor.B=255;
					}
				}
				// АЇАъ·№є§ 85АМ»у АП °жїм ·№є§ ВчАМ »ц»у ЗҐЅГё¦ БЩї© єёї©БШґЩ. 
				else
				{
					if (TargetLevelDiff <= -11)
					{
						OutColor.R=255;
						OutColor.G=0;
						OutColor.B=0;
					}
					else if (TargetLevelDiff > -11 &&TargetLevelDiff <= -3)
					{
						OutColor.R=255;
						OutColor.G=145;
						OutColor.B=145;
					}
					else if (TargetLevelDiff > -3 &&TargetLevelDiff <= -2)
					{
						OutColor.R=250;
						OutColor.G=254;
						OutColor.B=145;
					}
					else if (TargetLevelDiff > -2 &&TargetLevelDiff <= 1)
					{
						OutColor.R=255;
						OutColor.G=255;
						OutColor.B=255;
					}
					else if (TargetLevelDiff > 1 &&TargetLevelDiff <= 2)
					{
						OutColor.R=162;
						OutColor.G=255;
						OutColor.B=171;
					}
					else if (TargetLevelDiff > 2 &&TargetLevelDiff <= 10)
					{
						OutColor.R=162;
						OutColor.G=168;
						OutColor.B=252;
					}
					else if (TargetLevelDiff > 10)
					{
						OutColor.R=0;
						OutColor.G=0;
						OutColor.B=255;
					}
				}
			}
			//¶уАМєкґВ 77·№є§ АМЗП ±ФДўАё·О Аь ·№є§ µїАПЗП°Ф єЇ°ж
			else
			{
				if (TargetLevelDiff <= -11)
				{
					OutColor.R=255;
					OutColor.G=0;
					OutColor.B=0;
				}
				else if (TargetLevelDiff > -11 &&TargetLevelDiff <= -6)
				{
					OutColor.R=255;
					OutColor.G=145;
					OutColor.B=145;
				}
				else if (TargetLevelDiff > -6 &&TargetLevelDiff <= -3)
				{
					OutColor.R=250;
					OutColor.G=254;
					OutColor.B=145;
				}
				else if (TargetLevelDiff > -3 &&TargetLevelDiff <= 2)
				{
					OutColor.R=255;
					OutColor.G=255;
					OutColor.B=255;
				}
				else if (TargetLevelDiff > 2 &&TargetLevelDiff <= 5)
				{
					OutColor.R=162;
					OutColor.G=255;
					OutColor.B=171;
				}
				else if (TargetLevelDiff > 5 &&TargetLevelDiff <= 10)
				{
					OutColor.R=162;
					OutColor.G=168;
					OutColor.B=252;
				}
				else if (TargetLevelDiff > 10)
				{
					OutColor.R=0;
					OutColor.G=0;
					OutColor.B=255;
				}
			}
		*/
//		int diffLevePenalty = 0;

//		if(level > getLevel()){
			int diffLevePenalty =  Config.MIN_DIFF_LEVELS_FOR_EXP_SP_PENALTY;
//		}


		int diff = level - (getLevel() - (int) player.getStat().calc(Stats.DIF_LEVEL_FOR_PENALTY));

		if(level < getLevel() && Math.abs(diff) > diffLevePenalty){
			return new double[]{0, 0};
	}

		if(level > 77 && diff > 3 && diff <= 5) // kamael exp penalty
			diff += 3;

		double xp = SafeMath.mulAndLimit((double) getExpReward(), damage / totalDamage);
		double sp = SafeMath.mulAndLimit((double) getSpReward(), damage / totalDamage);

		if(diff > 5)
		{
			double mod = Math.pow(.83, diff - 5);
			xp = SafeMath.mulAndLimit(xp, mod);
			sp = SafeMath.mulAndLimit(sp, mod);
		}

//		if((level > 84) && (diff < -2))
//		{
//			double mod = Math.pow(.83, Math.abs(diff + 3));
//			xp = SafeMath.mulAndLimit(xp, mod);
//			sp = SafeMath.mulAndLimit(sp, mod);
//		}

		xp = Math.max(0., xp);
		sp = Math.max(0., sp);

		return new double[] { xp, sp };
	}

	private double applyOverhit(Player killer, double xp)
	{
		if(xp > 0 && killer.getObjectId() == overhitAttackerId)
		{
			int overHitExp = calculateOverhitExp(xp);
			killer.sendPacket(SystemMsg.OVERHIT);
			killer.sendPacket(new ExMagicAttackInfo(killer.getObjectId(), getObjectId(), ExMagicAttackInfo.OVERHIT));
			/*НА ОФФЕ НЕТУ: killer.sendPacket(new SystemMessage(SystemMessage.ACQUIRED_S1_BONUS_EXPERIENCE_THROUGH_OVER_HIT).addNumber(overHitExp));*/
			xp += overHitExp;
		}
		return xp;
	}

	@Override
	public void setOverhitAttacker(Creature attacker)
	{
		overhitAttackerId = attacker == null ? 0 : attacker.getObjectId();
	}

	public double getOverhitDamage()
	{
		return _overhitDamage;
	}

	@Override
	public void setOverhitDamage(double damage)
	{
		_overhitDamage = damage;
	}

	public int calculateOverhitExp(final double normalExp)
	{
		double overhitPercentage = getOverhitDamage() * 100 / getMaxHp();
		if(overhitPercentage > 25)
			overhitPercentage = 25;
		double overhitExp = overhitPercentage / 100 * normalExp;
		setOverhitAttacker(null);
		setOverhitDamage(0);
		return (int) Math.round(overhitExp);
	}

	@Override
	public boolean isAggressive()
	{
		return (Config.ALT_CHAMPION_CAN_BE_AGGRO || getChampion() == 0) && super.isAggressive();
	}

	@Override
	public Faction getFaction()
	{
		if(getTemplate().isNoClan())
			return Faction.NONE;

		return Config.ALT_CHAMPION_CAN_BE_SOCIAL || getChampion() == 0 ? super.getFaction() : Faction.NONE;
	}

	@Override
	public boolean isMonster()
	{
		return true;
	}

	@Override
	public Clan getClan()
	{
		return null;
	}

	@Override
	public boolean isPeaceNpc()
	{
		return false;
	}

	public void setRobbed(int val)
	{
		_isRobbed = val;
	}

	public int isRobbed()
	{
		return _isRobbed;
	}
	
	private void calculateAether(Creature killer)
	{
		if(killer == null || killer.getPlayer() == null)
			return;

		if(!Rnd.chance(Config.AETHER_CHANCE))
			return;

		Player player = killer.getPlayer();

		if(player.getAetherCount() >= 120)
			return;

		int count = 1;
		if(player.getAetherCount() == 0 && Rnd.chance(Config.AETHER_DOUBLE_CHANCE))
			count = 2;

		player.setAetherCount(player.getAetherCount() + count);
		
		if(player.getAetherCount() >= 1)
			player.sendPacket(new SystemMessagePacket(SystemMsg.YOU_RECEIVED_ITEM_S1_THIS_ITEM_IS_AVAILABLE_IN_THE_AMOUNT_S2_OF_PCS_IN_A_DAY_THE_RECEIPT_ACCOUNT_IS_RESET_AT_0630_EVERY_DAY).addItemName(81215).addInteger(120));

		ItemFunctions.addItem(player, 81215, count); // Aether
	}
	
	public void calculateMarkEndurity(Creature killer)
	{
		if(killer == null || killer.getPlayer() == null)
			return;

		if(!Rnd.chance(Config.AETHER_CHANCE)) //the same for now
			return;

		Player player = killer.getPlayer();

		if(player.getMarkEndureCount() > 0)
			return;

		player.setMarkEndureCount(1);

		ItemFunctions.addItem(player, 17742, 1); // Adventurer's Mark - Spirit
	}

	public boolean isOrbisMonster()
	{
		return false;
	}

	public final boolean isUnsowing()
	{
		return _isUnsowing;
	}
}