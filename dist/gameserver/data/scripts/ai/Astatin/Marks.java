package ai.Astatin;

import bosses.KelbimManager;
import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;

import java.util.concurrent.ScheduledFuture;

 //By Evil_dnk
public class Marks extends DefaultAI
{
	private final SkillEntry FIRERING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 23692, 1);
	private final SkillEntry WATERRING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 23693, 1);
	private final SkillEntry DARKRING = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 23694, 1);
	private static ScheduledFuture<?> _despawntask;

	private long _waitTime;
	private static final int TICK_IN_MILISECONDS = 2000;

	public Marks(NpcInstance actor)
	{
		super(actor);
	}

	@Override
	protected boolean thinkActive()
	{
		if(System.currentTimeMillis() > _waitTime && _waitTime != 0)
		{
			NpcInstance actor = getActor();
				if(KelbimManager.getKelbimStage() == 0 || KelbimManager.getKelbimStage() == 1)
				{
					actor.doCast(FIRERING, actor, false);
				}
				else if(KelbimManager.getKelbimStage() == 2)
				{
					actor.doCast(WATERRING, actor, false);
				}
				else if(KelbimManager.getKelbimStage() == 3)
				{
						actor.doCast(WATERRING, actor, false);
				}
				else if(KelbimManager.getKelbimStage() == 4)
				{
					actor.doCast(DARKRING, actor, false);
				}
				 _waitTime = 0;
				_despawntask = ThreadPoolManager.getInstance().schedule(new Despawntask(), 10000);
				return true;
		}
		return false;
	}

	private class Despawntask implements Runnable
	{

		@Override
		public void run()
		{
			getActor().deleteMe();
		}
	}

	protected void onEvtSpawn()
	{
		super.onEvtSpawn();
		_waitTime = System.currentTimeMillis() + TICK_IN_MILISECONDS;
	}
}
