package l2s.gameserver.listener.actor.player;

import l2s.gameserver.listener.PlayerListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.templates.item.data.ItemData;

import java.util.List;

/**
 * @author Bonux
**/
public interface OnFishingListener extends PlayerListener
{
	public void onFishing(Player player, List<ItemData> fishRewards, boolean success);
}