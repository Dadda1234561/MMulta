package instances;

import java.util.concurrent.ScheduledFuture;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExSendUIEventPacket;
import l2s.gameserver.templates.InstantZone;

/**
 * Класс контролирует инстанс Sansililion
 *
 * @author coldy
 */
public class Sansililion extends Reflection
{
	private static final int DUNGEON_DURATION = 25 * 60 * 1000; // 25 минут.
	public long _startedTime = 0;
	public long _endTime = 0;
	public static int _points = 0;
	public int _lastBuff = 0;
	private static int _status = 0;
	private ScheduledFuture<?> _updateUITask;
	private ScheduledFuture<?> _stopInstance;

	public void startWorld()
	{
		_status = 1;
		_startedTime = System.currentTimeMillis();

		InstantZone instantZone = getInstancedZone();
		if(instantZone != null)
			_endTime = _startedTime + ((Math.max(6, instantZone.getTimelimit()) - 5) * 60 * 1000); // Заканчиваем за 5 минут, до закрытия самого инстанса.
		else
			_endTime = _startedTime + DUNGEON_DURATION;

		_stopInstance = ThreadPoolManager.getInstance().schedule(new StopInstance(), _endTime - _startedTime);
		_updateUITask = ThreadPoolManager.getInstance().scheduleAtFixedRate(new updateUITask(), 100L, 1000L);
		_points = 0;
	}

	public void updateTimer()
	{
		int timerStatus = 3;
		if(_status == 2)
			timerStatus = 1;

		int timeLeft = (int)((_endTime - System.currentTimeMillis()) / 1000L);
		timeLeft = Math.max(0, timeLeft);
		for(Player player : getPlayers())
			player.sendPacket(new ExSendUIEventPacket(player, timerStatus, timeLeft, _points, 60, NpcString.ELAPSED_TIME__)); //[TODO] not updating _points for some reason =/
			
	}

	protected class updateUITask implements Runnable
	{
		@Override
		public void run()
		{
			if(this == null)
				return;
			updateTimer();
		}
	}

	protected class StopInstance implements Runnable
	{
		@Override
		public void run()
		{
			if(this == null)
				return;

			if(_status == 1)
			{
				_status = 2;
				for(NpcInstance npc : getNpcs())
				{
					if(npc.getNpcId() != 33152)
						npc.deleteMe();
				}

				if(_updateUITask != null)
				{
					_updateUITask.cancel(false);
					_updateUITask = null;
				}
			}
		}
	}

	public int getStatus()
	{
		return _status;
	}
}