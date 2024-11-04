package l2s.gameserver.handler.pledgemissions;

import l2s.commons.time.cron.SchedulingPattern;
import l2s.gameserver.listener.CharListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.PledgeMission;
import l2s.gameserver.templates.pledgemissions.PledgeMissionStatus;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 **/
public interface IPledgeMissionHandler {
	CharListener getListener();

	PledgeMissionStatus getStatus(Player player, PledgeMission mission);

	int getProgress(Player player, PledgeMission mission);

	SchedulingPattern getReusePattern();
}
