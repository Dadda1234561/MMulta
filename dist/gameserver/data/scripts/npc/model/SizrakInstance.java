package npc.model;

import instances.Tauti;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.Config;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.instancemanager.SoHManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.network.l2.s2c.SystemMessage;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ReflectionUtils;

/**
 * @author KilRoy
 */
public class SizrakInstance extends NpcInstance
{
	private static final int TAUTI_NORMAL_INSTANCE_ID = 218;
	private static final Location TAUTI_ROOM_TELEPORT = new Location(-147262, 211318, -10040);

	public SizrakInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.startsWith("request_tauti_normal_battle"))
		{
			if(SoHManager.getCurrentStage() == 2 && !Config.ENABLE_TAUTI_FREE_ENTRANCE)
			{
				showChatWindow(player, "tauti_keeper/sofa_sizraku002h.htm", false);
				return;
			}

			Reflection reflection = player.getActiveReflection();
			if(reflection != null)
			{
				if(player.canReenterInstance(TAUTI_NORMAL_INSTANCE_ID))
					showChatWindow(player, "tauti_keeper/sofa_sizraku002g.htm", false);
			}
			else if(player.canEnterInstance(TAUTI_NORMAL_INSTANCE_ID))
			{
				ReflectionUtils.enterReflection(player, new Tauti(), TAUTI_NORMAL_INSTANCE_ID);
				showChatWindow(player, "tauti_keeper/sofa_sizraku002a.htm", false);
			}
		}
		else if(command.startsWith("reenter_tauti_normal_battle"))
		{
			Reflection reflection = player.getActiveReflection();
			if(reflection != null)
			{
				if(player.canReenterInstance(TAUTI_NORMAL_INSTANCE_ID))
				{
					if(reflection instanceof Tauti)
					{
						Tauti instance = (Tauti) reflection;
						if(instance.getInstanceStage() == 2)
							player.teleToLocation(TAUTI_ROOM_TELEPORT, reflection);
						else
							player.teleToLocation(reflection.getTeleportLoc(), reflection);
						showChatWindow(player, "tauti_keeper/sofa_sizraku002f.htm", false);
					}	
				}
			}
		}
		else
			super.onBypassFeedback(player, command);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... arg)
	{
		player.sendPacket(new HtmlMessage(this, "tauti_keeper/sofa_sizraku001.htm").setPlayVoice(firstTalk));
		return;
	}
}