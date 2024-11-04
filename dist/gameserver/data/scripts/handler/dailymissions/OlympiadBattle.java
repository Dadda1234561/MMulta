package handler.dailymissions;

import l2s.commons.time.cron.SchedulingPattern;
import l2s.gameserver.listener.CharListener;
import l2s.gameserver.listener.actor.player.OnOlympiadFinishBattleListener;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.olympiad.OlympiadGame;

public class OlympiadBattle extends ProgressDailyMissionHandler
{
	private static final SchedulingPattern REUSE_PATTERN = new SchedulingPattern("30 6 * * 1");

	private class HandlerListeners implements OnOlympiadFinishBattleListener
	{
		@Override
		public void onOlympiadFinishBattle(Player player, OlympiadGame olympiadGame, boolean winner)
		{
			progressMission(player, 1, true, player.getLevel(), player.getRebirthCount());
		}
	}

	private final HandlerListeners _handlerListeners = new HandlerListeners();

	@Override
	public SchedulingPattern getReusePattern()
	{
		return REUSE_PATTERN;
	}

	@Override
	public CharListener getListener()
	{
		return _handlerListeners;
	}
}
