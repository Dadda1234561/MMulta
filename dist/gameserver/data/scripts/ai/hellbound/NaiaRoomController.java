package ai.hellbound;

import java.util.List;

import l2s.commons.threading.RunnableImpl;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.ai.DefaultAI;
import l2s.gameserver.instancemanager.naia.NaiaTowerManager;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.utils.ReflectionUtils;

/**
 * @author pchayka
 */
public class NaiaRoomController extends DefaultAI
{
	private static final int[][] OPEN_DOORS = {
			// Room 1
			{
					18250002,
					18250003
			},
			// Room 2
			{
					18250004,
					18250005
			},
			// Room 3
			{
					18250006,
					18250007
			},
			// Room 4
			{
					18250008,
					18250009
			},
			// Room 5
			{
					18250010,
					18250011
			},
			// Room 6
			{
					18250101,
					18250013
			},
			// Room 7
			{
					18250014,
					18250015
			},
			// Room 8
			{
					18250102,
					18250017
			},
			// Room 9
			{
					18250018,
					18250019
			},
			// Room 10
			{
					18250103,
					18250021
			},
			// Room 11
			{
					18250022,
					18250023
			},
			// Room 12
			{
					18250024
			}
	};

	public NaiaRoomController(NpcInstance actor)
	{
		super(actor);
		actor.getFlags().getImmobilized().start();
		_activeAITaskDelay = 1000;
	}

	@Override
	public boolean thinkActive()
	{
		NpcInstance actor = getActor();

		final int roomId = getRoomId(actor.getNpcId());
		if(NaiaTowerManager.isLockedRoom(roomId))
		{
			final List<NpcInstance> mobs = NaiaTowerManager.getRoomMobs(roomId);
			if(mobs.isEmpty())
				return false;

			for(NpcInstance npc : mobs)
				if(npc == null || !npc.isDead())
					return false;

			final int[] doors = OPEN_DOORS[roomId];
			for(final int doorId : doors)
			{
				ReflectionUtils.getDoor(doorId).openMe();
			}

			NaiaTowerManager.unlockRoom(roomId);
			NaiaTowerManager.removeRoomMobs(roomId);

			if(roomId == 11) // последняя комната
				ThreadPoolManager.getInstance().schedule(new LastDoorClose(), 300 * 1000L);
		}

		return true;
	}

	private int getRoomId(final int npcId)
	{
		return npcId - 18494;
	}

	private class LastDoorClose extends RunnableImpl
	{
		@Override
		public void runImpl()
		{
			ReflectionUtils.getDoor(18250024).closeMe();
		}
	}
}