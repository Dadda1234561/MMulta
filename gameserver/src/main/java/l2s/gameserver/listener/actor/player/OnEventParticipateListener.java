package l2s.gameserver.listener.actor.player;

import l2s.gameserver.listener.PlayerListener;
import l2s.gameserver.model.Player;

/**
 * @author sharp
 * https://t.me/sharp1que
 */
public interface OnEventParticipateListener extends PlayerListener
{
    public void onEventParticipate(Player player, String eventName, boolean isWin);
}
