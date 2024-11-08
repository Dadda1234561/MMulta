package npc.model;

import java.util.StringTokenizer;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage.ScreenMessageAlign;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ReflectionUtils;
import l2s.gameserver.utils.NpcUtils;

import instances.BergamoChambers;

/**
 * @author Bonux
**/
public class DimensionalTreasureNpcInstance extends NpcInstance
{
	private class DeleteMeTask implements Runnable
	{
		@Override
		public void run()
		{
			deleteMe();
		}
	}

	private static final int DIMENSIONAL_DOOR_ID = 33691;
	private static final int DIMENSIONAL_DOOR_LIFE_TIME = 3 * 60 * 1000; // 3 минуты.

	private int _instanceZoneId = 0;

	public DimensionalTreasureNpcInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
		_instanceZoneId = getParameter("instance_zone_id", 0);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		StringTokenizer st = new StringTokenizer(command, "_");
		String cmd = st.nextToken();
		if(cmd.equalsIgnoreCase("open"))
		{
			NpcInstance npc = NpcUtils.spawnSingle(DIMENSIONAL_DOOR_ID, getLoc().setH(getHeading()));
			if(_instanceZoneId > 0 && (npc instanceof DimensionalTreasureNpcInstance))
				((DimensionalTreasureNpcInstance) npc).setInstanceZoneId(_instanceZoneId);
			npc.broadcastPacket(new ExShowScreenMessage(NpcString.THE_DIMENSIONAL_DOOR_OPENED_NEAR_YOU, 3000, ScreenMessageAlign.TOP_CENTER, true, true, player.getName()));
			doDie(null);
			endDecayTask();
		}
		else if(cmd.equalsIgnoreCase("enter"))
		{
			if(_instanceZoneId <= 0)
				return;

			Location returnLoc = player.getLoc();
			Reflection reflection = player.getActiveReflection();
			if(reflection != null)
			{
				if(player.canReenterInstance(_instanceZoneId))
					player.teleToLocation(reflection.getTeleportLoc(), reflection);
			}
			else if(player.canEnterInstance(_instanceZoneId))
			{
				reflection = ReflectionUtils.enterReflection(player, new BergamoChambers(), _instanceZoneId);
				reflection.setReturnLoc(returnLoc);
				doDie(null);
				endDecayTask();
			}
		}
		else
			super.onBypassFeedback(player, command);
	}

	public void setInstanceZoneId(int value)
	{
		_instanceZoneId = value;
	}

	@Override
	protected void onSpawn()
	{
		if(getNpcId() == DIMENSIONAL_DOOR_ID)
			ThreadPoolManager.getInstance().schedule(new DeleteMeTask(), (long) DIMENSIONAL_DOOR_LIFE_TIME);
	}
}