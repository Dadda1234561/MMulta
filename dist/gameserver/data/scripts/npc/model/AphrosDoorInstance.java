package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage.ScreenMessageAlign;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.NpcUtils;
import l2s.gameserver.utils.ReflectionUtils;

import services.AphrosManager;

/**
 * Для работы с Aphros Doors
 */
public final class AphrosDoorInstance extends NpcInstance
{
	public AphrosDoorInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.equalsIgnoreCase("AphrosUseKey"))
		{
			if(player.getInventory().getCountOf(17373) > 0)
			{
				if(getNpcId() != 33133)
				{
					if(player.getVar(""+getNpcId()+"") != null)
						showChatWindow(player, "default/aphros_door_checked.htm", false);
					else
					{
						player.setVar(""+getNpcId()+"", "1", -1); 
						for (int i = 0; i < 3; i++)
						{
							NpcInstance guard = NpcUtils.spawnSingle(25776, Location.findPointToStay(getSpawnedLoc(), 40, 100, getGeoIndex()), getReflection()); // spawn guards
							guard.getAggroList().addDamageHate(player, 10000, 0);	
						}						
						showChatWindow(player, "default/aphros_door_wrongkey.htm", false);
					}	
				}
				else
				{
					player.unsetVar("33134");
					player.unsetVar("33135");
					player.unsetVar("33136");
					player.getInventory().destroyItemByItemId(17373, 1);
					AphrosManager.startRaid();
					showChatWindow(player, "default/aphros_door_ok.htm", false);
				}
			}
			else
				showChatWindow(player, "default/aphros_door_nokey.htm", false);
		}
		else
			super.onBypassFeedback(player, command);
	}
}
