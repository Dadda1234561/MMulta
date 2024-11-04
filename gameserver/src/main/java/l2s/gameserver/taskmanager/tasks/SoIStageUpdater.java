package l2s.gameserver.taskmanager.tasks;

import l2s.commons.time.cron.SchedulingPattern;
import l2s.gameserver.instancemanager.SoIManager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author VISTALL
 * @date 5:53/12.08.2011
 */
public class SoIStageUpdater extends AutomaticTask
{
	private static final Logger _log = LoggerFactory.getLogger(SoIStageUpdater.class);

	private static final SchedulingPattern PATTERN = new SchedulingPattern("0 12 * * mon");

	@Override
	public void doTask() throws Exception
	{
		SoIManager.setCurrentStage(1);

		_log.info("Seed of Infinity update Task: Seed updated successfuly.");
	}

	@Override
	public long reCalcTime(boolean start)
	{
		return PATTERN.next(System.currentTimeMillis());
	}
}
