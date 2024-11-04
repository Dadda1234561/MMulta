package l2s.gameserver.listener.actor.player;

import l2s.gameserver.listener.PlayerListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.olympiad.OlympiadGame;

public interface OnOlympiadFinishBattleListener extends PlayerListener {
	void onOlympiadFinishBattle(Player player, OlympiadGame olympiadGame, boolean winner);
}
