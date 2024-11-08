package spawns;

import java.util.concurrent.ScheduledFuture;

import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.instancemanager.SpawnManager;
import l2s.gameserver.listener.script.OnInitScriptListener;

public class ArcaneManager implements OnInitScriptListener
{
	private static ScheduledFuture<?> _spawnDeSpawnTask;

	@Override
	public void onInit()
	{
		//_spawnDeSpawnTask = ThreadPoolManager.getInstance().schedule(new SpawnTask(), 60000);
	}

	public class SpawnTask implements Runnable
	{
		@Override
		public void run()
		{
			_spawnDeSpawnTask = null;
			SpawnManager.getInstance().spawn("arcan");
			_spawnDeSpawnTask = ThreadPoolManager.getInstance().schedule(new DeSpawnTask(), 600000);
		}
	}

	public class DeSpawnTask implements Runnable
	{
		@Override
		public void run()
		{
			_spawnDeSpawnTask = null;
			SpawnManager.getInstance().despawn("arcan");
			_spawnDeSpawnTask = ThreadPoolManager.getInstance().schedule(new SpawnTask(), 1800000);
		}
	}
}