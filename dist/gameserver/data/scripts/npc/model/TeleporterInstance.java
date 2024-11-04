package npc.model;


import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

public class TeleporterInstance extends NpcInstance
{
	public TeleporterInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	public void onBypassFeedback(Player player, String command) {
		if(command.startsWith("rune_2_stage")) {
			if(player.getInventory().getItemByItemId(57).getCount() > 150)
				player.teleToLocation(38296, -47988, 896, ReflectionManager.MAIN);
			else {
				if (player.isLangRus()) {
					player.sendMessage("Неверное колличество адены!");
				} else {
					player.sendMessage("Wrong amount of adena!");
				}
			}
		} else if(command.startsWith("rune_1_stage")) {
			if(player.getInventory().getItemByItemId(57).getCount() > 150)
				player.teleToLocation(38235, -48121, -1152, ReflectionManager.MAIN);
			else {
				if (player.isLangRus()) {
					player.sendMessage("Неверное колличество адены!");
				} else {
					player.sendMessage("Wrong amount of adena!");
				}
			}
		}
		else
			super.onBypassFeedback(player, command);
	}
}
