package l2s.gameserver.handler.pledgemissions.impl;

import l2s.commons.time.cron.SchedulingPattern;
import l2s.gameserver.handler.pledgemissions.IPledgeMissionHandler;
import l2s.gameserver.listener.CharListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.PledgeMission;
import l2s.gameserver.templates.pledgemissions.PledgeMissionStatus;
import l2s.gameserver.utils.TimeUtils;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 **/
public class DefaultPledgeMissionHandler implements IPledgeMissionHandler {
	private static final SchedulingPattern REUSE_PATTERN = TimeUtils.DAILY_DATE_PATTERN;

	@Override
	public CharListener getListener() {
		return null;
	}

	@Override
	public PledgeMissionStatus getStatus(Player player, PledgeMission mission) {
		return PledgeMissionStatus.IN_PROGRESS;
	}

	@Override
	public int getProgress(Player player, PledgeMission mission) {
		return mission.getValue();
	}

	@Override
	public SchedulingPattern getReusePattern() {
		return REUSE_PATTERN;
	}
}
