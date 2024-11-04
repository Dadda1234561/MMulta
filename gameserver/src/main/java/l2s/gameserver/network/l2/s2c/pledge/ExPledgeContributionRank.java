package l2s.gameserver.network.l2.s2c.pledge;

import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import l2s.commons.dbutils.DbUtils;
import l2s.gameserver.database.DatabaseFactory;
import l2s.gameserver.instancemanager.ServerVariables;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.model.pledge.UnitMember;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.templates.StatsSet;

/**
 * @author nexvill
 */
public class ExPledgeContributionRank extends L2GameServerPacket
{
	private static final Logger _log = LoggerFactory.getLogger(ExPledgeContributionRank.class);
	private static final String GET_CONTRIBUTION = "SELECT obj_id,value FROM character_variables WHERE obj_id IN (SELECT obj_Id FROM characters WHERE clanid=?) AND name=? ORDER BY value DESC";
	
	private final Player _player;
	private final boolean _cycle;
	private final Map<Integer, StatsSet> _contributorsList;

	public ExPledgeContributionRank(Player player, boolean cycle)
	{
		_player = player;
		_cycle = cycle;
		
		_contributorsList = getContributionRank(_player.getClan(), _cycle);
	}

	@Override
	protected final void writeImpl()
	{
		if (_player.getClan() == null)
		{
			return;
		}
		
		updateOldMembers();
		
		writeC(_cycle);
		writeD(_contributorsList.keySet().size());

		for (int id : _contributorsList.keySet())
		{
			int rank = 1;
			int nRank = 0;
			int nPledgeType = 0;
			int nPeriod = 0;
			int nTotal = 0;
			String szName = "";

			final StatsSet player = _contributorsList.get(id);
			for (UnitMember member : _player.getClan().getAllMembers())
			{
				if (player.getInteger("charId") == member.getObjectId())
				{
					nTotal = player.getInteger("totalRep", 0);
					nPledgeType = member.getPledgeType();
					nPeriod = _cycle ? player.getInteger("currentRep", 0) : player.getInteger("previousRep", 0);
					nRank = rank;
					szName = member.getName();
					rank++;
				}
			}

			writeD(nRank);
			writeS(StringUtils.rightPad(szName, 24, ' ')); // 50 bytes ((24 + null terminator) *2)
			writeD(nPledgeType); // nPledgeType
			writeD(nPeriod); // current period rep
			writeD(nTotal); // total rep
		}
	}
	
	private void updateOldMembers()
	{
		if (!ServerVariables.getBool("ClanUpdated", false))
		{
			Connection con = null;
			PreparedStatement statement = null;
			PreparedStatement statement2 = null;
			ResultSet rset = null;
			
			try
			{
				con = DatabaseFactory.getInstance().getConnection();
				statement = con.prepareStatement("SELECT obj_Id FROM characters WHERE clanid > 0");
				rset = statement.executeQuery();
				while (rset.next())
				{
					int charId = rset.getInt("obj_Id");
					statement2 = con.prepareStatement("INSERT IGNORE INTO character_variables (obj_id,name,value,expire_time) VALUES (?,?,?,?)");
					statement2.setInt(1, charId);
					statement2.setString(2, PlayerVariables.PREVIOUS_REPUTATION);
					statement2.setInt(3, 0);
					statement2.setInt(4, -1);
					statement2.executeUpdate();
					statement2.close();
					//-------------------------------------------------------------------------
					statement2 = con.prepareStatement("INSERT IGNORE INTO character_variables (obj_id,name,value,expire_time) VALUES (?,?,?,?)");
					statement2.setInt(1, charId);
					statement2.setString(2, PlayerVariables.CURRENT_REPUTATION);
					statement2.setInt(3, 0);
					statement2.setInt(4, -1);
					statement2.executeUpdate();
					statement2.close();
					//-------------------------------------------------------------------------
					statement2 = con.prepareStatement("INSERT IGNORE INTO character_variables (obj_id,name,value,expire_time) VALUES (?,?,?,?)");
					statement2.setInt(1, charId);
					statement2.setString(2, PlayerVariables.TOTAL_REPUTATION);
					statement2.setInt(3, 0);
					statement2.setInt(4, -1);
					statement2.executeUpdate();
					statement2.close();
					//-------------------------------------------------------------------------
					statement2 = con.prepareStatement("INSERT IGNORE INTO character_variables (obj_id,name,value,expire_time) VALUES (?,?,?,?)");
					statement2.setInt(1, charId);
					statement2.setString(2, PlayerVariables.CONTRIBUTION_CLAIMED);
					statement2.setInt(3, 0);
					statement2.setInt(4, -1);
					statement2.executeUpdate();
					statement2.close();
				}
			}
			catch (Exception e)
			{
				_log.warn("Could not update old characters clan contribution variables: ", e);
			}
			finally
			{
				DbUtils.closeQuietly(con, statement, rset);
				ServerVariables.set("ClanUpdated", true);
			}
		}
	}

	private Map<Integer, StatsSet> getContributionRank(Clan clan, boolean cycle)
	{
		final Map<Integer, StatsSet> _contributorsList = new ConcurrentHashMap<>();
		String query1;
		String query2;
		String query3 = PlayerVariables.PREVIOUS_REPUTATION;
		if (_cycle)
		{
			query1 = PlayerVariables.CURRENT_REPUTATION;
			query2 = PlayerVariables.TOTAL_REPUTATION;
		}
		else
		{
			query1 = PlayerVariables.TOTAL_REPUTATION;
			query2 = PlayerVariables.CURRENT_REPUTATION;
		}
		try (Connection con = DatabaseFactory.getInstance().getConnection();
			PreparedStatement statement = con.prepareStatement(GET_CONTRIBUTION))
		{
			statement.setInt(1, clan.getClanId());
			statement.setString(2, query1);
			try (ResultSet rset = statement.executeQuery())
			{
				int rank = 1;
				while (rset.next())
				{
					final StatsSet player = new StatsSet();
					int objectId = rset.getInt("obj_id");
					player.set("charId", objectId);
					if (cycle)
					{
						player.set("currentRep", rset.getInt("value"));
					}
					else
					{
						player.set("totalRep", rset.getInt("value"));
					}
					try (PreparedStatement statement2 = con.prepareStatement(GET_CONTRIBUTION))
					{
						statement2.setInt(1, clan.getClanId());
						statement2.setString(2, query2);
						try (ResultSet rset2 = statement2.executeQuery())
						{
							while (rset2.next())
							{
								int objectId2 = rset2.getInt("obj_id");
								if (objectId == objectId2)
								{
									if (cycle)
									{
										player.set("totalRep", rset2.getInt("value"));
									}
									else
									{
										player.set("currentRep", rset2.getInt("value"));
									}
								}
							}
						}
					}
					try (PreparedStatement statement3 = con.prepareStatement(GET_CONTRIBUTION))
					{
						statement3.setInt(1, clan.getClanId());
						statement3.setString(2, query3);
						try (ResultSet rset3 = statement3.executeQuery())
						{
							while (rset3.next())
							{
								int objectId2 = rset3.getInt("obj_id");
								if (objectId == objectId2)
								{
									player.set("previousRep", rset3.getInt("value"));
								}
							}
						}
					}
					_contributorsList.put(rank, player);
					rank++;
				}
			}
		}
		catch (Exception e)
		{
			_log.warn("Could not restore contribution of clan members: " + e.getMessage(), e);
		}
		return _contributorsList;
	}
}