package l2s.gameserver.network.l2.s2c.ranking;

import l2s.gameserver.Config;
import l2s.gameserver.instancemanager.RankManager;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.entity.Hero;
import l2s.gameserver.model.pledge.Clan;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.tables.ClanTable;
import l2s.gameserver.templates.StatsSet;
import org.napile.primitive.maps.IntObjectMap;
import org.napile.primitive.pair.IntObjectPair;

/**
 * @author nexvill
 */
public class ExOlympiadHeroAndLegendInfo extends L2GameServerPacket
{
	private final IntObjectMap<StatsSet> heroes;

	public ExOlympiadHeroAndLegendInfo()
	{
		heroes = Hero.getInstance().getHeroes();
	}

	@Override
	protected void writeImpl()
	{
		int legendObjId = 0;
		for (IntObjectPair<StatsSet> pair : heroes.entrySet())
		{
			StatsSet player = RankManager.getInstance().getPreviousOlyList().get(1);
			if (pair.getKey() == player.getInteger("objId"))
			{
				StatsSet legend = pair.getValue();
				int sex = player.getInteger("sex");
				int rebirths = player.getInteger("rebirths");
				int wins = player.getInteger("competitions_win");
				int loses = player.getInteger("competitions_lost");
				int points = player.getInteger("olympiad_points");
				
				legendObjId = pair.getKey();
				
				writeC(78); // unk, 78 on JP
				writeC(0); // unk 0
				writeString(legend.getString(Hero.CHAR_NAME)); // legend name
				writeString(legend.getString(Hero.CLAN_NAME)); // clan name
				writeD(Config.REQUEST_ID); // server id
				ClassId classId = ClassId.valueOf(legend.getInteger(Hero.CLASS_ID));
				writeD(classId.getRace().ordinal());
				writeD(sex); // sex
				writeD(classId.getId()); // class id
				writeD(rebirths); // rebirths
				writeD(legend.getInteger(Hero.LEGEND_COUNT)); // legend times
				writeD(wins); // wins
				writeD(loses); // loses
				writeD(points); // points

				Clan clan = ClanTable.getInstance().getClanByCharId(pair.getKey());
				if (clan != null)
				{
					writeD(clan.getLevel());
				} else
				{
					writeD(0);
				}
				break;
			}
		}
		
		writeD(Hero.getInstance().getHeroes().size() - 1);
		for (IntObjectPair<StatsSet> pair : heroes.entrySet())
		{
			if (pair.getKey() == legendObjId)
				continue;
			
			StatsSet hero = pair.getValue();
			
			int sex = 0;
			int rebirths = 0;
			int wins = 0;
			int loses = 0;
			int points = 0;
			for (int id : RankManager.getInstance().getPreviousOlyList().keySet())
			{
				StatsSet player = new StatsSet();
				player = RankManager.getInstance().getPreviousOlyList().get(id);
				if (pair.getKey() == player.getInteger("objId"))
				{
					sex = player.getInteger("sex");
					rebirths = player.getInteger("rebirths");
					wins = player.getInteger("competitions_win");
					loses = player.getInteger("competitions_lost");
					points = player.getInteger("olympiad_points");
					break;
				}
			}
			
			
			writeString(hero.getString(Hero.CHAR_NAME));
			writeString(hero.getString(Hero.CLAN_NAME));
			writeD(Config.REQUEST_ID);
			ClassId classId = ClassId.valueOf(hero.getInteger(Hero.CLASS_ID));
			writeD(classId.getRace().ordinal());
			writeD(sex); // sex
			writeD(classId.getId());
			writeD(rebirths); // rebirths
			writeD(hero.getInteger(Hero.COUNT));
			writeD(wins);
			writeD(loses);
			writeD(points);
			
			Clan clan = ClanTable.getInstance().getClanByCharId(pair.getKey());
			if (clan != null)
			{
				writeD(clan.getLevel());
			} else
			{
				writeD(0);
			}
		}
	}
}
