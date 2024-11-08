package l2s.gameserver.model;

import gnu.trove.map.hash.TIntObjectHashMap;
import gnu.trove.set.hash.TIntHashSet;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;
import l2s.gameserver.model.items.Inventory;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

public final class ArmorSet
{
	private final TIntHashSet _chests = new TIntHashSet();
	private final TIntHashSet _legs = new TIntHashSet();
	private final TIntHashSet _head = new TIntHashSet();
	private final TIntHashSet _gloves = new TIntHashSet();
	private final TIntHashSet _feet = new TIntHashSet();
	private final TIntHashSet _shield = new TIntHashSet();
	private final TIntHashSet _l_ring = new TIntHashSet();
	private final TIntHashSet _r_ring = new TIntHashSet();
	private final TIntHashSet _l_earning = new TIntHashSet();
	private final TIntHashSet _r_earning = new TIntHashSet();
	private final TIntHashSet _neckl = new TIntHashSet();
	private final TIntObjectHashMap<List<SkillEntry>> _skills = new TIntObjectHashMap<List<SkillEntry>>();
	private final List<SkillEntry> _shieldSkills = new ArrayList<SkillEntry>();
	private final List<SkillEntry> _enchant6skills = new ArrayList<SkillEntry>();
	private final List<SkillEntry> _enchant7skills = new ArrayList<SkillEntry>();
	private final List<SkillEntry> _enchant8skills = new ArrayList<SkillEntry>();
	private final List<SkillEntry> _enchant9skills = new ArrayList<SkillEntry>();
	private final List<SkillEntry> _enchant10skills = new ArrayList<SkillEntry>();
	private final List<SkillEntry> _enchant12skills = new ArrayList<SkillEntry>();
	private final List<SkillEntry> _enchant16skills = new ArrayList<SkillEntry>();
	private final List<SkillEntry> _enchant20skills = new ArrayList<SkillEntry>();

	public ArmorSet(String[] chests, String[] legs, String[] head, String[] gloves, String[] feet, String[] shield, String[] l_ring, String[] r_ring, String[] l_earning, String[] r_earning, String[] neckl, String[] shield_skills, String[] enchant6skills, String[] enchant7skills, String[] enchant8skills, String[] enchant9skills, String[] enchant10skills, String[] enchant12skills, String[] enchant16skills, String[] enchant20skills)
	{
		_chests.addAll(parseItemIDs(chests));
		_legs.addAll(parseItemIDs(legs));
		_head.addAll(parseItemIDs(head));
		_gloves.addAll(parseItemIDs(gloves));
		_feet.addAll(parseItemIDs(feet));
		_shield.addAll(parseItemIDs(shield));
		_l_ring.addAll(parseItemIDs(l_ring));
		_r_ring.addAll(parseItemIDs(r_ring));
		_l_earning.addAll(parseItemIDs(l_earning));
		_r_earning.addAll(parseItemIDs(r_earning));
		_neckl.addAll(parseItemIDs(neckl));

		if(shield_skills != null)
		{
			for(String skill : shield_skills)
			{
				StringTokenizer st = new StringTokenizer(skill, "-");
				if(st.hasMoreTokens())
				{
					int skillId = Integer.parseInt(st.nextToken());
					int skillLvl = Integer.parseInt(st.nextToken());
					_shieldSkills.add(SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLvl));
				}
			}
		}

		if(enchant6skills != null)
		{
			for(String skill : enchant6skills)
			{
				StringTokenizer st = new StringTokenizer(skill, "-");
				if(st.hasMoreTokens())
				{
					int skillId = Integer.parseInt(st.nextToken());
					int skillLvl = Integer.parseInt(st.nextToken());
					_enchant6skills.add(SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLvl));
				}
			}
		}

		if(enchant7skills != null)
		{
			for(String skill : enchant7skills)
			{
				StringTokenizer st = new StringTokenizer(skill, "-");
				if(st.hasMoreTokens())
				{
					int skillId = Integer.parseInt(st.nextToken());
					int skillLvl = Integer.parseInt(st.nextToken());
					_enchant7skills.add(SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLvl));
				}
			}
		}

		if(enchant8skills != null)
		{
			for(String skill : enchant8skills)
			{
				StringTokenizer st = new StringTokenizer(skill, "-");
				if(st.hasMoreTokens())
				{
					int skillId = Integer.parseInt(st.nextToken());
					int skillLvl = Integer.parseInt(st.nextToken());
					_enchant8skills.add(SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLvl));
				}
			}
		}

		if(enchant9skills != null)
		{
			for(String skill : enchant9skills)
			{
				StringTokenizer st = new StringTokenizer(skill, "-");
				if(st.hasMoreTokens())
				{
					int skillId = Integer.parseInt(st.nextToken());
					int skillLvl = Integer.parseInt(st.nextToken());
					_enchant9skills.add(SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLvl));
				}
			}
		}

		if(enchant10skills != null)
		{
			for(String skill : enchant10skills)
			{
				StringTokenizer st = new StringTokenizer(skill, "-");
				if(st.hasMoreTokens())
				{
					int skillId = Integer.parseInt(st.nextToken());
					int skillLvl = Integer.parseInt(st.nextToken());
					_enchant10skills.add(SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLvl));
				}
			}
		}

		if(enchant12skills != null)
		{
			for(String skill : enchant12skills)
			{
				StringTokenizer st = new StringTokenizer(skill, "-");
				if(st.hasMoreTokens())
				{
					int skillId = Integer.parseInt(st.nextToken());
					int skillLvl = Integer.parseInt(st.nextToken());
					_enchant12skills.add(SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLvl));
				}
			}
		}

		if(enchant16skills != null)
		{
			for(String skill : enchant16skills)
			{
				StringTokenizer st = new StringTokenizer(skill, "-");
				if(st.hasMoreTokens())
				{
					int skillId = Integer.parseInt(st.nextToken());
					int skillLvl = Integer.parseInt(st.nextToken());
					_enchant16skills.add(SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLvl));
				}
			}
		}

		if(enchant20skills != null)
		{
			for(String skill : enchant20skills)
			{
				StringTokenizer st = new StringTokenizer(skill, "-");
				if(st.hasMoreTokens())
				{
					int skillId = Integer.parseInt(st.nextToken());
					int skillLvl = Integer.parseInt(st.nextToken());
					_enchant20skills.add(SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLvl));
				}
			}
		}
	}

	private static int[] parseItemIDs(String[] items)
	{
		TIntHashSet result = new TIntHashSet();
		if(items != null)
		{
			for(String s_id : items)
			{
				int id = Integer.parseInt(s_id);
				if(id > 0)
				{
					result.add(id);
				}
			}
		}
		return result.toArray();
	}

	public void addSkills(int partsCount, String[] skills)
	{
		List<SkillEntry> skillList = new ArrayList<SkillEntry>();
		if(skills != null)
		{
			for(String skill : skills)
			{
				StringTokenizer st = new StringTokenizer(skill, "-");
				if(st.hasMoreTokens())
				{
					int skillId = Integer.parseInt(st.nextToken());
					int skillLvl = Integer.parseInt(st.nextToken());
					skillList.add(SkillEntry.makeSkillEntry(SkillEntryType.NONE, skillId, skillLvl));
				}
			}
		}
		_skills.put(partsCount, skillList);
	}

	/**
	 * Checks if player have equipped all items from set (not checking shield)
	 * @param player whose inventory is being checked
	 * @return True if player equips whole set
	 */
	public boolean containAll(Player player)
	{
		Inventory inv = player.getInventory();

		ItemInstance chestItem = inv.getPaperdollItem(Inventory.PAPERDOLL_CHEST);
		ItemInstance legsItem = inv.getPaperdollItem(Inventory.PAPERDOLL_LEGS);
		ItemInstance headItem = inv.getPaperdollItem(Inventory.PAPERDOLL_HEAD);
		ItemInstance glovesItem = inv.getPaperdollItem(Inventory.PAPERDOLL_GLOVES);
		ItemInstance feetItem = inv.getPaperdollItem(Inventory.PAPERDOLL_FEET);

		ItemInstance l_ringItem = inv.getPaperdollItem(Inventory.PAPERDOLL_LFINGER);
		ItemInstance r_ringItem = inv.getPaperdollItem(Inventory.PAPERDOLL_RFINGER);
		ItemInstance l_earningItem = inv.getPaperdollItem(Inventory.PAPERDOLL_LEAR);
		ItemInstance r_earningItem = inv.getPaperdollItem(Inventory.PAPERDOLL_REAR);
		ItemInstance necklItem = inv.getPaperdollItem(Inventory.PAPERDOLL_NECK);

		int chest = 0;
		int legs = 0;
		int head = 0;
		int gloves = 0;
		int feet = 0;
		int l_ring = 0;
		int r_ring = 0;
		int l_earning = 0;
		int r_earning = 0;
		int neckl = 0;

		if(chestItem != null)
			chest = chestItem.getItemId();
		if(legsItem != null)
			legs = legsItem.getItemId();
		if(headItem != null)
			head = headItem.getItemId();
		if(glovesItem != null)
			gloves = glovesItem.getItemId();
		if(feetItem != null)
			feet = feetItem.getItemId();
		if(l_ringItem != null)
			l_ring = l_ringItem.getItemId();
		if(r_ringItem != null)
			r_ring = r_ringItem.getItemId();
		if(l_earningItem != null)
			l_earning = l_earningItem.getItemId();
		if(r_earningItem != null)
			r_earning = r_earningItem.getItemId();
		if(necklItem != null)
			neckl = necklItem.getItemId();

		return containAll(chest, legs, head, gloves, feet, l_ring, r_ring, l_earning, r_earning, neckl);

	}

	public boolean containAll(int chest, int legs, int head, int gloves, int feet, int l_ring, int r_ring, int l_earning, int r_earning, int neckl)
	{
		if(!_chests.isEmpty() && !_chests.contains(chest))
			return false;
		if(!_legs.isEmpty() && !_legs.contains(legs))
			return false;
		if(!_head.isEmpty() && !_head.contains(head))
			return false;
		if(!_gloves.isEmpty() && !_gloves.contains(gloves))
			return false;
		if(!_feet.isEmpty() && !_feet.contains(feet))
			return false;
		if(!_l_ring.isEmpty() && !_l_ring.contains(l_ring))
			return false;
		if(!_r_ring.isEmpty() && !_r_ring.contains(r_ring))
			return false;
		if(!_l_earning.isEmpty() && !_l_earning.contains(l_earning))
			return false;
		if(!_r_earning.isEmpty() && !_r_earning.contains(r_earning))
			return false;
		if(!_neckl.isEmpty() && !_neckl.contains(neckl))
			return false;

		return true;
	}

	public boolean containItem(int slot, int itemId)
	{
		switch(slot)
		{
			case Inventory.PAPERDOLL_CHEST:
				return _chests.contains(itemId);
			case Inventory.PAPERDOLL_LEGS:
				return _legs.contains(itemId);
			case Inventory.PAPERDOLL_HEAD:
				return _head.contains(itemId);
			case Inventory.PAPERDOLL_GLOVES:
				return _gloves.contains(itemId);
			case Inventory.PAPERDOLL_FEET:
				return _feet.contains(itemId);
			case Inventory.PAPERDOLL_LFINGER:
				return _l_ring.contains(itemId);
			case Inventory.PAPERDOLL_RFINGER:
				return _r_ring.contains(itemId);
			case Inventory.PAPERDOLL_LEAR:
				return _l_earning.contains(itemId);
			case Inventory.PAPERDOLL_REAR:
				return _r_earning.contains(itemId);
			case Inventory.PAPERDOLL_NECK:
				return _neckl.contains(itemId);
			default:
				return false;
		}
	}

	public int getEquipedSetPartsCount(Player player)
	{
		Inventory inv = player.getInventory();

		ItemInstance chestItem = inv.getPaperdollItem(Inventory.PAPERDOLL_CHEST);
		ItemInstance legsItem = inv.getPaperdollItem(Inventory.PAPERDOLL_LEGS);
		ItemInstance headItem = inv.getPaperdollItem(Inventory.PAPERDOLL_HEAD);
		ItemInstance glovesItem = inv.getPaperdollItem(Inventory.PAPERDOLL_GLOVES);
		ItemInstance feetItem = inv.getPaperdollItem(Inventory.PAPERDOLL_FEET);

		ItemInstance l_ringItem = inv.getPaperdollItem(Inventory.PAPERDOLL_LFINGER);
		ItemInstance r_ringItem = inv.getPaperdollItem(Inventory.PAPERDOLL_RFINGER);
		ItemInstance l_earningItem = inv.getPaperdollItem(Inventory.PAPERDOLL_LEAR);
		ItemInstance r_earningItem = inv.getPaperdollItem(Inventory.PAPERDOLL_REAR);
		ItemInstance necklItem = inv.getPaperdollItem(Inventory.PAPERDOLL_NECK);

		int chest = 0;
		int legs = 0;
		int head = 0;
		int gloves = 0;
		int feet = 0;
		int l_ring = 0;
		int r_ring = 0;
		int l_earning = 0;
		int r_earning = 0;
		int neckl = 0;

		if(chestItem != null)
			chest = chestItem.getItemId();
		if(legsItem != null)
			legs = legsItem.getItemId();
		if(headItem != null)
			head = headItem.getItemId();
		if(glovesItem != null)
			gloves = glovesItem.getItemId();
		if(feetItem != null)
			feet = feetItem.getItemId();
		if(l_ringItem != null)
			l_ring = l_ringItem.getItemId();
		if(r_ringItem != null)
			r_ring = r_ringItem.getItemId();
		if(l_earningItem != null)
			l_earning = l_earningItem.getItemId();
		if(r_earningItem != null)
			r_earning = r_earningItem.getItemId();
		if(necklItem != null)
			neckl = necklItem.getItemId();

		int result = 0;
		if(!_chests.isEmpty() && _chests.contains(chest))
			result++;
		if(!_legs.isEmpty() && _legs.contains(legs))
			result++;
		if(!_head.isEmpty() && _head.contains(head))
			result++;
		if(!_gloves.isEmpty() && _gloves.contains(gloves))
			result++;
		if(!_feet.isEmpty() && _feet.contains(feet))
			result++;
		if(!_l_ring.isEmpty() && _l_ring.contains(l_ring))
			result++;
		if(!_r_ring.isEmpty() && _r_ring.contains(r_ring))
			result++;
		if(!_l_earning.isEmpty() && _l_earning.contains(l_earning))
			result++;
		if(!_r_earning.isEmpty() && _r_earning.contains(r_earning))
			result++;
		if(!_neckl.isEmpty() && _neckl.contains(neckl))
			result++;

		return result;
	}

	public List<SkillEntry> getSkills(int partsCount)
	{
		if(_skills.get(partsCount) == null)
			return new ArrayList<SkillEntry>();

		return _skills.get(partsCount);
	}

	public List<SkillEntry> getSkillsToRemove()
	{
		List<SkillEntry> result = new ArrayList<SkillEntry>();
		for(int i : _skills.keys())
		{
			List<SkillEntry> skills = _skills.get(i);
			if(skills != null)
			{
				for(SkillEntry skill : skills)
					result.add(skill);
			}
		}
		return result;
	}

	public List<SkillEntry> getShieldSkills()
	{
		return _shieldSkills;
	}

	public List<SkillEntry> getEnchant6skills()
	{
		return _enchant6skills;
	}

	public List<SkillEntry> getEnchant7skills()
	{
		return _enchant7skills;
	}

	public List<SkillEntry> getEnchant8skills()
	{
		return _enchant8skills;
	}

	public List<SkillEntry> getEnchant9skills()
	{
		return _enchant9skills;
	}

	public List<SkillEntry> getEnchant10skills()
	{
		return _enchant10skills;
	}
	public List<SkillEntry> getEnchant12skills()
	{
		return _enchant12skills;
	}
	public List<SkillEntry> getEnchant16skills()
	{
		return _enchant16skills;
	}
	public List<SkillEntry> getEnchant20skills()
	{
		return _enchant20skills;
	}

	public boolean containShield(Player player)
	{
		Inventory inv = player.getInventory();

		ItemInstance shieldItem = inv.getPaperdollItem(Inventory.PAPERDOLL_LHAND);
		if(shieldItem != null && _shield.contains(shieldItem.getItemId()))
			return true;

		return false;
	}

	public boolean containShield(int shield_id)
	{
		if(_shield.isEmpty())
			return false;

		return _shield.contains(shield_id);
	}

	/**
	 * Checks if all parts of set are enchanted to +6 or more
	 * @param player
	 * @return
	 */
	public int getEnchantLevel(Player player)
	{
		// Player don't have full set
		if(!containAll(player))
			return 0;

		Inventory inv = player.getInventory();

		ItemInstance chestItem = inv.getPaperdollItem(Inventory.PAPERDOLL_CHEST);
		ItemInstance legsItem = inv.getPaperdollItem(Inventory.PAPERDOLL_LEGS);
		ItemInstance headItem = inv.getPaperdollItem(Inventory.PAPERDOLL_HEAD);
		ItemInstance glovesItem = inv.getPaperdollItem(Inventory.PAPERDOLL_GLOVES);
		ItemInstance feetItem = inv.getPaperdollItem(Inventory.PAPERDOLL_FEET);

		int value = -1;
		if(!_chests.isEmpty())
			value = value > -1 ? Math.min(value, chestItem.getFixedEnchantLevel(player)) : chestItem.getFixedEnchantLevel(player);

		if(!_legs.isEmpty())
			value = value > -1 ? Math.min(value, legsItem.getFixedEnchantLevel(player)) : legsItem.getFixedEnchantLevel(player);

		if(!_gloves.isEmpty())
			value = value > -1 ? Math.min(value, glovesItem.getFixedEnchantLevel(player)) : glovesItem.getFixedEnchantLevel(player);

		if(!_head.isEmpty())
			value = value > -1 ? Math.min(value, headItem.getFixedEnchantLevel(player)) : headItem.getFixedEnchantLevel(player);

		if(!_feet.isEmpty())
			value = value > -1 ? Math.min(value, feetItem.getFixedEnchantLevel(player)) : feetItem.getFixedEnchantLevel(player);

		return value;
	}

	public int[] getChestIds()
	{
		return _chests.toArray();
	}

	public int[] getLegIds()
	{
		return _legs.toArray();
	}

	public int[] getHeadIds()
	{
		return _head.toArray();
	}

	public int[] getGlovesIds()
	{
		return _gloves.toArray();
	}

	public int[] getFeetIds()
	{
		return _feet.toArray();
	}

	public int[] getShieldIds()
	{
		return _shield.toArray();
	}

	public int[] getLRingIds()
	{
		return _l_ring.toArray();
	}
	public int[] getRRingIds()
	{
		return _r_ring.toArray();
	}
	public int[] getLEarningIds()
	{
		return _l_earning.toArray();
	}
	public int[] getREarningIds()
	{
		return _r_earning.toArray();
	}
	public int[] getNecklIds()
	{
		return _neckl.toArray();
	}
}