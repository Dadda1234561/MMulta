package npc.model;


import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

public class SSQNpcTeleporterInstance extends NpcInstance
{
	public SSQNpcTeleporterInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	public void onBypassFeedback(Player player, String command) {
		if(command.startsWith("dungeon_apostle_inside")) {
			player.teleToLocation(172840, -17592, -4896, ReflectionManager.MAIN);

		} else if(command.startsWith("dungeon_apostle_outside")) {
			player.teleToLocation(171848, -17608, -4896, ReflectionManager.MAIN);
		}
		else if(command.startsWith("dark_omen_inside")) {
			player.teleToLocation(171848, -17608, -4896, ReflectionManager.MAIN);
		}
		else if(command.startsWith("dark_omen_outside")) {
			player.teleToLocation(171848, -17608, -4896, ReflectionManager.MAIN);
		}
		else
			super.onBypassFeedback(player, command);
	}
}
