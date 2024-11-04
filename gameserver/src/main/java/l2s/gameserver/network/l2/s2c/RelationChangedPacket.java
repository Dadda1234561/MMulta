package l2s.gameserver.network.l2.s2c;

import java.util.ArrayList;
import java.util.List;

import l2s.gameserver.model.Playable;
import l2s.gameserver.model.Player;


public class RelationChangedPacket extends L2GameServerPacket
{
	private static class RelationChangedData
	{
		public int objectId;
		public boolean isAutoAttackable;
		public int karma, pvpFlag;
		public long relation;
	}

	public enum RelationChangedType
	{
		IN_BATTLE_FIELD,
		GUILTY,
		CHAOTIC,
		PARTY_MEMBER,
		PARTY_MASTER,
		PARTY_COMRADE,
		PLEDGE_MEMBER,
		PLEDGE_MASTER,
		PLEDGE_COMRADE,
		PLEDGE_IN_CASTLE_SIEGE,
		ATTACKER_IN_CASTLE_SIEGE,
		COMRADE_IN_CASTLE_SIEGE,
		ENEMY_IN_CASTLE_SIEGE,
		DECLARE_WAR_TO_YOUR_PLEDGE, // mutual war
		DECLARE_WAR_TO_MY_PLEDGE, // mutual war
		ALLIANCE_MEMBER,
		ALLIANCE_LEADER,
		DUEL_ENEMY,
		COMRADE_IN_DOMINION_SIEGE,
		ENEMY_IN_DOMINION_SIEGE,
		COMRADE_IN_PVP_MATCH,
		ENEMY_IN_PVP_MATCH,
		BLUE_IN_PVP_MATCH,
		RED_IN_PVP_MATCH,
		MASTER_IN_PVP_MATCH,
		IN_WORLD_COLLISION_AREA,
		COMRADE_IN_ARENA_MATCH,
		ENEMY_IN_ARENA_MATCH,
		MPCC_COMRADE,
		PLEDGE_ENEMY,
		USER_WATCHER;

		public long getRelationState()
		{
			return (long) Math.pow(2, ordinal());
		}
	}
	
	// Masks
	private static final byte SEND_DEFAULT = (byte) 0x01;
	private static final byte SEND_ONE = (byte) 0x02;
	private static final byte SEND_MULTI = (byte) 0x04;

	private byte _mask = (byte) 0x00;

	private final List<RelationChangedData> _datas = new ArrayList<RelationChangedData>(1);

	public RelationChangedPacket()
	{
		//
	}

	public RelationChangedPacket(Playable about, Player target)
	{
		add(about, target);
	}

	public void add(Playable about, Player target)
	{
		RelationChangedData data = new RelationChangedData();
		data.objectId = about.getObjectId();
		data.karma = about.getKarma();
		data.pvpFlag = about.getPvpFlag();
		data.isAutoAttackable = about.isAutoAttackable(target);
		data.relation = about.getRelation(target);

		_datas.add(data);

		if(_datas.size() > 1)
			_mask |= SEND_MULTI;
		else if(_datas.size() == 1)
			_mask |= SEND_ONE;
	}

	@Override
	protected void writeImpl()
	{
		writeC(_mask);
		if((_mask & SEND_MULTI) == SEND_MULTI)
		{
			writeH(_datas.size());
			for(RelationChangedData data : _datas)
				writeRelation(data);
		}
		else if((_mask & SEND_ONE) == SEND_ONE)
			writeRelation(_datas.get(0));
		else if((_mask & SEND_DEFAULT) == SEND_DEFAULT)
			writeD(_datas.get(0).objectId);
	}
	
	private void writeRelation(RelationChangedData data)
	{
		writeD(data.objectId);
		writeQ(data.relation);
		writeC(data.isAutoAttackable);
		writeD(data.karma);
		writeC(data.pvpFlag);
	}
}