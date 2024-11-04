package l2s.gameserver.network.l2.s2c.events;

import l2s.gameserver.Config;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.events.objects.RewardHolder;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

public class ExFestivalBMGame extends L2GameServerPacket
{
	private final Player _player;
	private final RewardHolder _result;

	public ExFestivalBMGame(Player player, RewardHolder result)
	{
		_player = player;
		_result = result;
	}

	@Override
	protected final void writeImpl()
	{
		writeC(_result.getGrade() == 0 ? 0 : 1); // cFestivalBmGameResult
		writeD(Config.BM_FESTIVAL_ITEM_TO_PLAY); // nTicketItemClassId
		writeQ(_player.getVarInt("FESTIVAL_BM_EXIST_GAMES", Config.BM_FESTIVAL_PLAY_LIMIT)); // nTicketItemAmount
		writeD(Config.BM_FESTIVAL_ITEM_TO_PLAY_COUNT); // nTicketItemAmountPerGame
		if (_result.getGrade() != 0)
		{
			writeC(_result.getGrade()); // cRewardItemGrade
			writeD(_result.getItemId()); // nRewardItemClassId
			writeD(_result.getItemCnt()); // nRewardItemCount
		}

	}
}