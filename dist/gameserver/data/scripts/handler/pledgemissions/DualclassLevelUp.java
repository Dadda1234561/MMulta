package handler.pledgemissions;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.PledgeMission;

/**
 * @author Bonux
 **/
public class DualclassLevelUp extends LevelUp {
	@Override
	public int getProgress(Player player, PledgeMission mission) {
		return player.getDualClass() != null ? player.getDualClass().getLevel() : 0;
	}
}
