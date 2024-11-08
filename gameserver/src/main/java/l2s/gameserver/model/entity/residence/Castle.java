package l2s.gameserver.model.entity.residence;

import gnu.trove.set.TIntSet;
import gnu.trove.set.hash.TIntHashSet;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

import l2s.commons.dao.JdbcEntityState;
import l2s.commons.dbutils.DbUtils;
import l2s.commons.math.SafeMath;
import l2s.gameserver.Announcements;
import l2s.gameserver.Config;
import l2s.gameserver.dao.CastleDAO;
import l2s.gameserver.dao.CastleHiredGuardDAO;
import l2s.gameserver.data.xml.holder.ResidenceHolder;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.instancemanager.CastleManorManager;
import l2s.gameserver.instancemanager.SpawnManager;
import l2s.gameserver.model.Manor;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.entity.events.impl.CastleSiegeEvent;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.model.items.Warehouse;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExCastleState;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.StatsSet;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.templates.item.support.MerchantGuard;
import l2s.gameserver.templates.manor.CropProcure;
import l2s.gameserver.templates.manor.SeedProduction;
import l2s.gameserver.utils.Log;

import org.napile.primitive.pair.IntObjectPair;
import org.napile.primitive.maps.IntObjectMap;
import org.napile.primitive.maps.impl.CTreeIntObjectMap;
import org.napile.primitive.maps.impl.HashIntObjectMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Castle extends Residence
{
	private static final Logger _log = LoggerFactory.getLogger(Castle.class);

	private static final String CASTLE_MANOR_DELETE_PRODUCTION = "DELETE FROM castle_manor_production WHERE castle_id=?;";
	private static final String CASTLE_MANOR_DELETE_PRODUCTION_PERIOD = "DELETE FROM castle_manor_production WHERE castle_id=? AND period=?;";
	private static final String CASTLE_MANOR_DELETE_PROCURE = "DELETE FROM castle_manor_procure WHERE castle_id=?;";
	private static final String CASTLE_MANOR_DELETE_PROCURE_PERIOD = "DELETE FROM castle_manor_procure WHERE castle_id=? AND period=?;";
	private static final String CASTLE_UPDATE_CROP = "UPDATE castle_manor_procure SET can_buy=? WHERE crop_id=? AND castle_id=? AND period=?";
	private static final String CASTLE_UPDATE_SEED = "UPDATE castle_manor_production SET can_produce=? WHERE seed_id=? AND castle_id=? AND period=?";

	private final IntObjectMap<MerchantGuard> _merchantGuards = new HashIntObjectMap<MerchantGuard>();
	private final IntObjectMap<List<Fortress>> _relatedFortresses = new CTreeIntObjectMap<List<Fortress>>();
	private final IntObjectMap<TIntSet> _relatedFortressesIDs = new CTreeIntObjectMap<TIntSet>();

	private List<CropProcure> _procure;
	private List<SeedProduction> _production;
	private List<CropProcure> _procureNext;
	private List<SeedProduction> _productionNext;
	private boolean _isNextPeriodApproved;

	private long _treasury;
	private long _collectedShops;
	private long _collectedSeed;

	private final NpcString _npcStringName;

	private ResidenceSide _residenceSide = ResidenceSide.LIGHT;

	private static final SkillEntry LIGHT_SIDE_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 19032, 1); // Способности Света
	private static final SkillEntry DARK_SIDE_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 19033, 1); // Способности Тьмы

	private Set<ItemInstance> _spawnMerchantTickets = new CopyOnWriteArraySet<ItemInstance>();

	public Castle(StatsSet set)
	{
		super(set);
		_npcStringName = NpcString.valueOf(1001000 + getId());
	}

	@Override
	public void init()
	{
		super.init();

		for(IntObjectPair<TIntSet> entry : _relatedFortressesIDs.entrySet())
		{
			TIntSet list = entry.getValue();
			List<Fortress> list2 = new ArrayList<Fortress>(list.size());
			for(int i : list.toArray())
			{
				Fortress fortress = ResidenceHolder.getInstance().getResidence(Fortress.class, i);
				if(fortress == null)
					continue;

				list2.add(fortress);

				fortress.addRelatedCastle(this);
			}
			_relatedFortresses.put(entry.getKey(), list2);
		}
	}

	@Override
	public ResidenceType getType()
	{
		return ResidenceType.CASTLE;
	}

	// This method sets the castle owner; null here means give it back to NPC
	@Override
	public void changeOwner(Clan newOwner)
	{
		// Если клан уже владел каким-либо замком/крепостью, отбираем его.
		if(newOwner != null)
		{
			if(newOwner.getHasFortress() != 0)
			{
				Fortress oldFortress = ResidenceHolder.getInstance().getResidence(Fortress.class, newOwner.getHasFortress());
				if(oldFortress != null)
					oldFortress.changeOwner(null);
			}
			if(newOwner.getCastle() != 0)
			{
				Castle oldCastle = ResidenceHolder.getInstance().getResidence(Castle.class, newOwner.getCastle());
				if(oldCastle != null)
					oldCastle.changeOwner(null);
			}
		}

		Clan oldOwner = null;
		// Если этим замком уже кто-то владел, отбираем у него замок
		if(getOwnerId() > 0 && (newOwner == null || newOwner.getClanId() != getOwnerId()))
		{
			// Удаляем замковые скилы у старого владельца
			removeSkills();

			cancelCycleTask();

			oldOwner = getOwner();
			if(oldOwner != null)
			{
				// Переносим сокровищницу в вархауз старого владельца
				long amount = getTreasury();
				if(amount > 0)
				{
					Warehouse warehouse = oldOwner.getWarehouse();
					if(warehouse != null)
					{
						warehouse.addItem(ItemTemplate.ITEM_ID_ADENA, amount);
						addToTreasuryNoTax(-amount, false, false);
						Log.add(getName() + "|" + -amount + "|Castle:changeOwner", "treasury");
					}
				}

				// Проверяем членов старого клана владельца, снимаем короны замков и корону лорда с лидера
				for(Player clanMember : oldOwner.getOnlineMembers())
					if(clanMember != null && clanMember.getInventory() != null)
						clanMember.getInventory().validateItems();

				// Отнимаем замок у старого владельца
				oldOwner.setHasCastle(0);
			}
		}

		setOwner(newOwner);

		removeFunctions();

		// Выдаем замок новому владельцу
		if(newOwner != null)
		{
			newOwner.setHasCastle(getId());
			newOwner.broadcastClanStatus(true, false, false);
		}

		// Выдаем замковые скилы новому владельцу
		rewardSkills();

		setJdbcState(JdbcEntityState.UPDATED);
		update();
	}

	// This method loads castle
	@Override
	protected void loadData()
	{
		_treasury = 0;
		_procure = new ArrayList<CropProcure>();
		_production = new ArrayList<SeedProduction>();
		_procureNext = new ArrayList<CropProcure>();
		_productionNext = new ArrayList<SeedProduction>();
		_isNextPeriodApproved = false;

		CastleDAO.getInstance().select(this);
		CastleHiredGuardDAO.getInstance().load(this);
	}

	public void setTreasury(long t)
	{
		_treasury = t;
	}

	public long getCollectedShops()
	{
		return _collectedShops;
	}

	public long getCollectedSeed()
	{
		return _collectedSeed;
	}

	public void setCollectedShops(long value)
	{
		_collectedShops = value;
	}

	public void setCollectedSeed(long value)
	{
		_collectedSeed = value;
	}

	// This method add to the treasury
	/** Add amount to castle instance's treasury (warehouse). */
	public void addToTreasury(long amount, boolean shop, boolean seed)
	{
		if(getOwnerId() <= 0)
			return;

		if(amount == 0)
			return;

		// TODO [Bonux]: Вынести в датапак.
		double deleteAmount = 0.4;
		if(getId() == 3) // Giran
			deleteAmount = 0.75;
		else if(getId() == 6) // Innadril
			deleteAmount = 0.;

		amount = (long) Math.max(0, amount - (amount * deleteAmount));

		if(amount > 1 && getId() != 5 && getId() != 8) // If current castle instance is not Aden or Rune
		{
			Castle royal = ResidenceHolder.getInstance().getResidence(Castle.class, getId() >= 7 ? 8 : 5);
			if(royal != null)
			{
				// TODO [Bonux]: Вынести в датапак.
				double royalTaxRate = 0.25;
				if(getId() == 3) // Giran
					royalTaxRate = 0.50;

				long royalTax = (long) (amount * royalTaxRate);

				if(royal.getOwnerId() > 0)
				{
					royal.addToTreasury(royalTax, shop, seed); // Only bother to really add the tax to the treasury if not npc owned
					if(getId() == 5)
						Log.add("Aden|" + royalTax + "|Castle:adenTax", "treasury");
					else if(getId() == 8)
						Log.add("Rune|" + royalTax + "|Castle:runeTax", "treasury");
				}

				amount -= royalTax; // Subtract royal castle income from current castle instance's income
			}
		}

		addToTreasuryNoTax(amount, shop, seed);
	}

	/** Add amount to castle instance's treasury (warehouse), no tax paying. */
	public void addToTreasuryNoTax(long amount, boolean shop, boolean seed)
	{
		if(getOwnerId() <= 0)
			return;

		if(amount == 0)
			return;

		// Add to the current treasury total.  Use "-" to substract from treasury
		_treasury = SafeMath.addAndLimit(_treasury, amount);

		if(shop)
			_collectedShops += amount;

		if(seed)
			_collectedSeed += amount;

		setJdbcState(JdbcEntityState.UPDATED);
		update();
	}

	public int getCropRewardType(int crop)
	{
		int rw = 0;
		for(CropProcure cp : _procure)
			if(cp.getId() == crop)
				rw = cp.getReward();
		return rw;
	}

	public int getSellTaxPercent()
	{
		if(getResidenceSide() == ResidenceSide.LIGHT)
			return Config.LIGHT_CASTLE_SELL_TAX_PERCENT;
		if(getResidenceSide() == ResidenceSide.DARK)
			return Config.DARK_CASTLE_SELL_TAX_PERCENT;
		return 0;
	}

	public double getSellTaxRate()
	{
		return getSellTaxPercent() / 100.;
	}

	public int getBuyTaxPercent()
	{
		if(getResidenceSide() == ResidenceSide.LIGHT)
			return Config.LIGHT_CASTLE_BUY_TAX_PERCENT;
		if(getResidenceSide() == ResidenceSide.DARK)
			return Config.DARK_CASTLE_BUY_TAX_PERCENT;
		return 0;
	}

	public double getBuyTaxRate()
	{
		return getBuyTaxPercent() / 100.;
	}

	public long getTreasury()
	{
		return _treasury;
	}

	public List<SeedProduction> getSeedProduction(int period)
	{
		return period == CastleManorManager.PERIOD_CURRENT ? _production : _productionNext;
	}

	public List<CropProcure> getCropProcure(int period)
	{
		return period == CastleManorManager.PERIOD_CURRENT ? _procure : _procureNext;
	}

	public void setSeedProduction(List<SeedProduction> seed, int period)
	{
		if(period == CastleManorManager.PERIOD_CURRENT)
			_production = seed;
		else
			_productionNext = seed;
	}

	public void setCropProcure(List<CropProcure> crop, int period)
	{
		if(period == CastleManorManager.PERIOD_CURRENT)
			_procure = crop;
		else
			_procureNext = crop;
	}

	public synchronized SeedProduction getSeed(int seedId, int period)
	{
		for(SeedProduction seed : getSeedProduction(period))
			if(seed.getId() == seedId)
				return seed;
		return null;
	}

	public synchronized CropProcure getCrop(int cropId, int period)
	{
		for(CropProcure crop : getCropProcure(period))
			if(crop.getId() == cropId)
				return crop;
		return null;
	}

	public long getManorCost(int period)
	{
		List<CropProcure> procure;
		List<SeedProduction> production;

		if(period == CastleManorManager.PERIOD_CURRENT)
		{
			procure = _procure;
			production = _production;
		}
		else
		{
			procure = _procureNext;
			production = _productionNext;
		}

		long total = 0;
		if(production != null)
			for(SeedProduction seed : production)
				total += Manor.getInstance().getSeedBuyPrice(seed.getId()) * seed.getStartProduce();
		if(procure != null)
			for(CropProcure crop : procure)
				total += crop.getPrice() * crop.getStartAmount();
		return total;
	}

	// Save manor production data
	public void saveSeedData()
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(CASTLE_MANOR_DELETE_PRODUCTION);
			statement.setInt(1, getId());
			statement.execute();
			DbUtils.close(statement);

			if(_production != null)
			{
				int count = 0;
				String query = "INSERT INTO castle_manor_production VALUES ";
				String values[] = new String[_production.size()];
				for(SeedProduction s : _production)
				{
					values[count] = "(" + getId() + "," + s.getId() + "," + s.getCanProduce() + "," + s.getStartProduce() + "," + s.getPrice() + "," + CastleManorManager.PERIOD_CURRENT + ")";
					count++;
				}
				if(values.length > 0)
				{
					query += values[0];
					for(int i = 1; i < values.length; i++)
						query += "," + values[i];
					statement = con.prepareStatement(query);
					statement.execute();
					DbUtils.close(statement);
				}
			}

			if(_productionNext != null)
			{
				int count = 0;
				String query = "INSERT INTO castle_manor_production VALUES ";
				String values[] = new String[_productionNext.size()];
				for(SeedProduction s : _productionNext)
				{
					values[count] = "(" + getId() + "," + s.getId() + "," + s.getCanProduce() + "," + s.getStartProduce() + "," + s.getPrice() + "," + CastleManorManager.PERIOD_NEXT + ")";
					count++;
				}
				if(values.length > 0)
				{
					query += values[0];
					for(int i = 1; i < values.length; i++)
						query += "," + values[i];
					statement = con.prepareStatement(query);
					statement.execute();
					DbUtils.close(statement);
				}
			}
		}
		catch(Exception e)
		{
			_log.error("Error adding seed production data for castle " + getName() + "!", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
	}

	// Save manor production data for specified period
	public void saveSeedData(int period)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(CASTLE_MANOR_DELETE_PRODUCTION_PERIOD);
			statement.setInt(1, getId());
			statement.setInt(2, period);
			statement.execute();
			DbUtils.close(statement);

			List<SeedProduction> prod = null;
			prod = getSeedProduction(period);

			if(prod != null)
			{
				int count = 0;
				String query = "INSERT INTO castle_manor_production VALUES ";
				String values[] = new String[prod.size()];
				for(SeedProduction s : prod)
				{
					values[count] = "(" + getId() + "," + s.getId() + "," + s.getCanProduce() + "," + s.getStartProduce() + "," + s.getPrice() + "," + period + ")";
					count++;
				}
				if(values.length > 0)
				{
					query += values[0];
					for(int i = 1; i < values.length; i++)
						query += "," + values[i];
					statement = con.prepareStatement(query);
					statement.execute();
					DbUtils.close(statement);
				}
			}
		}
		catch(Exception e)
		{
			_log.error("Error adding seed production data for castle " + getName() + "!", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
	}

	// Save crop procure data
	public void saveCropData()
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(CASTLE_MANOR_DELETE_PROCURE);
			statement.setInt(1, getId());
			statement.execute();
			DbUtils.close(statement);
			if(_procure != null)
			{
				int count = 0;
				String query = "REPLACE INTO castle_manor_procure VALUES ";
				String values[] = new String[_procure.size()];
				for(CropProcure cp : _procure)
				{
					values[count] = "(" + getId() + "," + cp.getId() + "," + cp.getAmount() + "," + cp.getStartAmount() + "," + cp.getPrice() + "," + cp.getReward() + "," + CastleManorManager.PERIOD_CURRENT + ")";
					count++;
				}
				if(values.length > 0)
				{
					query += values[0];
					for(int i = 1; i < values.length; i++)
						query += "," + values[i];
					statement = con.prepareStatement(query);
					statement.execute();
					DbUtils.close(statement);
				}
			}
			if(_procureNext != null)
			{
				int count = 0;
				String query = "REPLACE INTO castle_manor_procure VALUES ";
				String values[] = new String[_procureNext.size()];
				for(CropProcure cp : _procureNext)
				{
					values[count] = "(" + getId() + "," + cp.getId() + "," + cp.getAmount() + "," + cp.getStartAmount() + "," + cp.getPrice() + "," + cp.getReward() + "," + CastleManorManager.PERIOD_NEXT + ")";
					count++;
				}
				if(values.length > 0)
				{
					query += values[0];
					for(int i = 1; i < values.length; i++)
						query += "," + values[i];
					statement = con.prepareStatement(query);
					statement.execute();
					DbUtils.close(statement);
				}
			}
		}
		catch(Exception e)
		{
			_log.error("Error adding crop data for castle " + getName() + "!", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
	}

	// Save crop procure data for specified period
	public void saveCropData(int period)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(CASTLE_MANOR_DELETE_PROCURE_PERIOD);
			statement.setInt(1, getId());
			statement.setInt(2, period);
			statement.execute();
			DbUtils.close(statement);

			List<CropProcure> proc = null;
			proc = getCropProcure(period);

			if(proc != null)
			{
				int count = 0;
				String query = "INSERT INTO castle_manor_procure VALUES ";
				String values[] = new String[proc.size()];

				for(CropProcure cp : proc)
				{
					values[count] = "(" + getId() + "," + cp.getId() + "," + cp.getAmount() + "," + cp.getStartAmount() + "," + cp.getPrice() + "," + cp.getReward() + "," + period + ")";
					count++;
				}
				if(values.length > 0)
				{
					query += values[0];
					for(int i = 1; i < values.length; i++)
						query += "," + values[i];
					statement = con.prepareStatement(query);
					statement.execute();
					DbUtils.close(statement);
				}
			}
		}
		catch(Exception e)
		{
			_log.error("Error adding crop data for castle " + getName() + "!", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
	}

	public void updateCrop(int cropId, long amount, int period)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(CASTLE_UPDATE_CROP);
			statement.setLong(1, amount);
			statement.setInt(2, cropId);
			statement.setInt(3, getId());
			statement.setInt(4, period);
			statement.execute();
		}
		catch(Exception e)
		{
			_log.error("Error adding crop data for castle " + getName() + "!", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
	}

	public void updateSeed(int seedId, long amount, int period)
	{
		Connection con = null;
		PreparedStatement statement = null;
		try
		{
			con = DatabaseFactory.getInstance().getConnection();
			statement = con.prepareStatement(CASTLE_UPDATE_SEED);
			statement.setLong(1, amount);
			statement.setInt(2, seedId);
			statement.setInt(3, getId());
			statement.setInt(4, period);
			statement.execute();
		}
		catch(Exception e)
		{
			_log.error("Error adding seed production data for castle " + getName() + "!", e);
		}
		finally
		{
			DbUtils.closeQuietly(con, statement);
		}
	}

	public boolean isNextPeriodApproved()
	{
		return _isNextPeriodApproved;
	}

	public void setNextPeriodApproved(boolean val)
	{
		_isNextPeriodApproved = val;
	}

	public void addRelatedFortress(int type, int fortress)
	{
		TIntSet fortresses = _relatedFortressesIDs.get(type);
		if(fortresses == null)
			_relatedFortressesIDs.put(type, fortresses = new TIntHashSet());

		fortresses.add(fortress);
	}

	public int getDomainFortressContract()
	{
		List<Fortress> list = _relatedFortresses.get(Fortress.DOMAIN);
		if(list == null)
			return 0;
		for(Fortress f : list)
			if(f.getContractState() == Fortress.CONTRACT_WITH_CASTLE && f.getCastleId() == getId())
				return f.getId();
		return 0;
	}

	@Override
	public void update()
	{
		CastleDAO.getInstance().update(this);
	}

	public NpcString getNpcStringName()
	{
		return _npcStringName;
	}

	public IntObjectMap<List<Fortress>> getRelatedFortresses()
	{
		return _relatedFortresses;
	}

	public IntObjectMap<TIntSet> getRelatedFortressesIDs()
	{
		return _relatedFortressesIDs;
	}

	public void addMerchantGuard(MerchantGuard merchantGuard)
	{
		_merchantGuards.put(merchantGuard.getItemId(), merchantGuard);
	}

	public MerchantGuard getMerchantGuard(int itemId)
	{
		return _merchantGuards.get(itemId);
	}

	public IntObjectMap<MerchantGuard> getMerchantGuards()
	{
		return _merchantGuards;
	}

	public Set<ItemInstance> getSpawnMerchantTickets()
	{
		return _spawnMerchantTickets;
	}

	@Override
	public void startCycleTask()
	{}

	@Override
	public void setResidenceSide(ResidenceSide side, boolean onRestore)
	{
		if(!onRestore && _residenceSide == side)
			return;

		_residenceSide = side;

		removeSkills();
		switch(_residenceSide)
		{
			case LIGHT:
				removeSkill(DARK_SIDE_SKILL);
				addSkill(LIGHT_SIDE_SKILL);
				break;
			case DARK:
				removeSkill(LIGHT_SIDE_SKILL);
				addSkill(DARK_SIDE_SKILL);
				break;
			default:
				removeSkill(LIGHT_SIDE_SKILL);
				removeSkill(DARK_SIDE_SKILL);
				break;
		}
		rewardSkills();

		if(!onRestore)
		{
			setJdbcState(JdbcEntityState.UPDATED);
			update();

			CastleSiegeEvent siege = getSiegeEvent();
			if(siege != null)
				siege.actActions("change_castle_side");
		}
	}

	@Override
	public ResidenceSide getResidenceSide()
	{
		return _residenceSide;
	}

	@Override
	public void broadcastResidenceState()
	{
		Announcements.announceToAll(new ExCastleState(this));
	}
}