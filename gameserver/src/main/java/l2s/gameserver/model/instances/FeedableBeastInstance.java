package l2s.gameserver.model.instances;

import gnu.trove.map.TIntObjectMap;
import gnu.trove.map.hash.TIntObjectHashMap;
import gnu.trove.set.TIntSet;
import gnu.trove.set.hash.TIntHashSet;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.CtrlEvent;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.idfactory.IdFactory;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.s2c.SocialActionPacket;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.NpcUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FeedableBeastInstance extends MonsterInstance
{
	private static final Logger _log = LoggerFactory.getLogger(NpcInstance.class);

	private static class growthInfo
	{
		public final int growth_level;
		public final int growth_chance;
		public final int[] tameinfo;
		public final int[] spice;
		public final int[] adultId;

		public growthInfo(int level, int[] tame, int[] sp, int chance, int[] adult)
		{
			growth_level = level;
			tameinfo = tame;
			spice = sp;
			growth_chance = chance;
			adultId = adult;
		}
	}

	public static final TIntObjectMap<growthInfo> growthCapableMobs = new TIntObjectHashMap<growthInfo>();
	public static final TIntSet tamedBeasts = new TIntHashSet();
	public static final TIntSet feedableBeasts = new TIntHashSet();

	static
	{
		// Alpine Kookabura

		// Baby
		growthCapableMobs.put(18873, new growthInfo(0, new int[] { 18869, 5 }, new int[] { 18874, 18875 }, 100, new int[] { 18878, 18879 }));

		// Young
		growthCapableMobs.put(18874, new growthInfo(1, new int[] { 18869, 5 }, new int[] { 18876, 0 }, 40, new int[] { 18878, 0 }));
		growthCapableMobs.put(18875, new growthInfo(1, new int[] { 18869, 5 }, new int[] { 0, 18877 }, 40, new int[] { 0, 18879 }));

		// Adult
		growthCapableMobs.put(18876, new growthInfo(2, new int[] { 18869, 15 }, new int[] { 18878, 0 }, 25, new int[] { 18878, 0 }));
		growthCapableMobs.put(18877, new growthInfo(2, new int[] { 18869, 15 }, new int[] { 0, 18879 }, 25, new int[] { 0, 18879 }));

		// Alpine Cougar

		// Baby
		growthCapableMobs.put(18880, new growthInfo(0, new int[] { 18870, 5 }, new int[] { 18881, 18882 }, 100, new int[] { 18885, 18886 }));

		// Young
		growthCapableMobs.put(18881, new growthInfo(1, new int[] { 18870, 5 }, new int[] { 18883, 0 }, 40, new int[] { 18885, 0 }));
		growthCapableMobs.put(18882, new growthInfo(1, new int[] { 18870, 5 }, new int[] { 0, 18884 }, 40, new int[] { 0, 18886 }));

		// Adult
		growthCapableMobs.put(18883, new growthInfo(2, new int[] { 18870, 15 }, new int[] { 18885, 0 }, 25, new int[] { 18885, 0 }));
		growthCapableMobs.put(18884, new growthInfo(2, new int[] { 18870, 15 }, new int[] { 0, 18886 }, 25, new int[] { 0, 18886 }));

		// Alpine Buffalo

		// Baby
		growthCapableMobs.put(18887, new growthInfo(0, new int[] { 18871, 5 }, new int[] { 18888, 18889 }, 100, new int[] { 18892, 18893 }));

		// Young
		growthCapableMobs.put(18888, new growthInfo(1, new int[] { 18871, 5 }, new int[] { 18890, 0 }, 40, new int[] { 18892, 0 }));
		growthCapableMobs.put(18889, new growthInfo(1, new int[] { 18871, 5 }, new int[] { 0, 18891 }, 40, new int[] { 0, 18893 }));

		// Adult
		growthCapableMobs.put(18890, new growthInfo(2, new int[] { 18871, 15 }, new int[] { 18892, 0 }, 25, new int[] { 18892, 0 }));
		growthCapableMobs.put(18891, new growthInfo(2, new int[] { 18871, 15 }, new int[] { 0, 18893 }, 25, new int[] { 0, 18893 }));

		// Alpine Grendel

		// Baby
		growthCapableMobs.put(18894, new growthInfo(0, new int[] { 18872, 5 }, new int[] { 18895, 18896 }, 100, new int[] { 18899, 18900 }));

		// Young
		growthCapableMobs.put(18895, new growthInfo(1, new int[] { 18872, 5 }, new int[] { 18897, 0 }, 40, new int[] { 18899, 0 }));
		growthCapableMobs.put(18896, new growthInfo(1, new int[] { 18872, 5 }, new int[] { 0, 18898 }, 40, new int[] { 0, 18900 }));

		// Adult
		growthCapableMobs.put(18897, new growthInfo(2, new int[] { 18872, 15 }, new int[] { 18899, 0 }, 25, new int[] { 18899, 0 }));
		growthCapableMobs.put(18898, new growthInfo(2, new int[] { 18872, 15 }, new int[] { 0, 18900 }, 25, new int[] { 0, 18900 }));

		for(int i = 18869; i <= 18872; i++)
			tamedBeasts.add(i);
		for(int i = 18869; i <= 18900; i++)
			feedableBeasts.add(i);
	}

	public static Map<Integer, Integer> feedInfo = new ConcurrentHashMap<Integer, Integer>();

	private boolean isGoldenSpice(int skillId)
	{
		return skillId == 9049 || skillId == 9051 || skillId == 9053;
	}

	private boolean isCrystalSpice(int skillId)
	{
		return skillId == 9050 || skillId == 9052 || skillId == 9054;
	}

	public boolean isBlessed(int skillId)
	{
		return skillId == 9051 || skillId == 9052;
	}

	public boolean isSGrade(int skillId)
	{
		return skillId == 9053 || skillId == 9054;
	}

	private int getFoodSpice(int skillId)
	{
		if(isGoldenSpice(skillId))
			return 9049;
		else
			return 9050;
	}

	public int getItemIdBySkillId(int skillId)
	{
		int itemId = 0;
		switch(skillId)
		{
			case 9049:
				itemId = 15474;
				break;
			case 9050:
				itemId = 15475;
				break;
			case 9051:
				itemId = 15476;
				break;
			case 9052:
				itemId = 15477;
				break;
			case 9053:
				itemId = 15478;
				break;
			case 9054:
				itemId = 15479;
				break;
			default:
				itemId = 0;
		}
		return itemId;
	}

	public FeedableBeastInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	private void spawnNext(Player player, int growthLevel, int food, int skill_id)
	{
		int npcId = getNpcId();
		int nextNpcId = 0;

		int tameChance = growthCapableMobs.get(npcId).tameinfo[1];
		if(isBlessed(skill_id))
			tameChance = 90;

		if(Rnd.chance(tameChance))
			nextNpcId = growthCapableMobs.get(npcId).tameinfo[0];
		else
			nextNpcId = growthCapableMobs.get(npcId).spice[food];

		if(isSGrade(skill_id) && Rnd.chance(90))
			nextNpcId = growthCapableMobs.get(npcId).adultId[food];

		if(nextNpcId == 0)
			return;

		// remove the feedinfo of the mob that got despawned, if any
		feedInfo.remove(getObjectId());

		// despawn the old mob
		if(growthCapableMobs.get(npcId).growth_level == 0)
			onDecay();
		else
			deleteMe();

		// if this is finally a trained mob, then despawn any other trained mobs that the player might have and initialize the Tamed Beast.
		if(tamedBeasts.contains(nextNpcId))
		{
			if(player.getTrainedBeasts().size() >= 7)
				return;

			NpcInstance nextNpc = NpcUtils.spawnSingle(nextNpcId, Location.findPointToStay(player, 50), player.getReflection());
			if(nextNpc != null && (nextNpc instanceof TamedBeastInstance))
			{
				((TamedBeastInstance) nextNpc).setTameType();
				((TamedBeastInstance) nextNpc).setFoodType(getFoodSpice(skill_id));
				((TamedBeastInstance) nextNpc).setRunning();
				((TamedBeastInstance) nextNpc).setOwner(player);
			}

			QuestState st = player.getQuestState(20);
			if(st != null && !st.isCompleted() && Rnd.chance(5) && st.getQuestItemsCount(7185) == 0)
			{
				st.giveItems(7185, 1);
				st.setCond(2);
			}

			st = player.getQuestState(655);
			if(st != null && !st.isCompleted() && st.getCond() == 1)
				if(st.getQuestItemsCount(8084) < 10)
					st.giveItems(8084, 1);
		}
		// if not trained, the newly spawned mob will automatically be agro against its feeder (what happened to "never bite the hand that feeds you" anyway?!)
		else
		{
			// spawn the new mob
			NpcInstance nextNpc = spawn(nextNpcId, getX(), getY(), getZ());
			feedInfo.put(nextNpc.getObjectId(), player.getObjectId()); // register the player in the feedinfo for the mob that just spawned
			player.setTarget(nextNpc);
			ThreadPoolManager.getInstance().schedule(new AggrPlayer(nextNpc, player), 3000);
		}
	}

	public static class AggrPlayer implements Runnable
	{
		private NpcInstance _actor;
		private Player _killer;

		public AggrPlayer(NpcInstance actor, Player killer)
		{
			_actor = actor;
			_killer = killer;
		}

		public void run()
		{
			_actor.getAI().notifyEvent(CtrlEvent.EVT_AGGRESSION, _killer, 1000);
		}
	}

	@Override
	protected void onDeath(Creature killer)
	{
		feedInfo.remove(getObjectId());
		super.onDeath(killer);
	}

	public NpcInstance spawn(int npcId, int x, int y, int z)
	{
		try
		{
			return NpcUtils.spawnSingle(npcId, x, y, z);
		}
		catch(Exception e)
		{
			_log.error("Could not spawn Npc " + npcId, e);
		}
		return null;
	}

	public void onSkillUse(Player player, int skillId)
	{
		// gather some values on local variables
		int npcId = getNpcId();
		// check if the npc and skills used are valid
		if(!feedableBeasts.contains(npcId))
			return;
		if(isGoldenSpice(skillId) && isCrystalSpice(skillId))
			return;

		int food = isGoldenSpice(skillId) ? 0 : 1;

		int objectId = getObjectId();
		// display the social action of the beast eating the food.
		broadcastPacket(new SocialActionPacket(objectId, 2));

		// if this pet can't grow, it's all done.
		if(growthCapableMobs.containsKey(npcId))
		{
			// do nothing if this mob doesn't eat the specified food (food gets consumed but has no effect).
			if(growthCapableMobs.get(npcId).spice[food] == 0)
				return;

			// more value gathering on local variables
			int growthLevel = growthCapableMobs.get(npcId).growth_level;

			if(growthLevel > 0)
				// check if this is the same player as the one who raised it from growth 0.
				// if no, then do not allow a chance to raise the pet (food gets consumed but has no effect).
				if(feedInfo.get(objectId) != null && feedInfo.get(objectId) != player.getObjectId())
					return;

			// Polymorph the mob, with a certain chance, given its current growth level
			if(Rnd.chance(growthCapableMobs.get(npcId).growth_chance))
				spawnNext(player, growthLevel, food, skillId);
		}
		else if(Rnd.chance(60))
			dropItem(player, getItemIdBySkillId(skillId), 1);
	}
}