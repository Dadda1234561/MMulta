package l2s.gameserver.listener.actor.playable;

import l2s.gameserver.listener.PlayerListener;
import l2s.gameserver.model.Playable;
import l2s.gameserver.model.items.ItemInstance;

/**
 * @author Bonux
 */
public interface OnUseItemListener extends PlayerListener {
	void onUseItem(Playable playable, ItemInstance item);
}