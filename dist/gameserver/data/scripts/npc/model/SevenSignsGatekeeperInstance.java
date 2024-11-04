package npc.model;


import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

public class SevenSignsGatekeeperInstance extends NpcInstance
{
	public SevenSignsGatekeeperInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	public void onBypassFeedback(Player player, String command) {
		if(command.startsWith("necropolis_1")) {
			player.teleToLocation(-41569, 210082, -5085, ReflectionManager.MAIN);
		} else if (command.startsWith("necropolis_2")) {
			player.teleToLocation(45249, 123548, -5411, ReflectionManager.MAIN);
		} else if (command.startsWith("necropolis_3")) {
			player.teleToLocation(111552, 174014, -5440, ReflectionManager.MAIN);
		} else if (command.startsWith("necropolis_4")) {
			player.teleToLocation(-21423, 77375, -5171, ReflectionManager.MAIN);
		} else if (command.startsWith("necropolis_5")) {
			player.teleToLocation(118576, 132800, -4832, ReflectionManager.MAIN);
		} else if (command.startsWith("necropolis_6")) {
			player.teleToLocation(83357, 209207, -5437, ReflectionManager.MAIN);
		} else if (command.startsWith("necropolis_7")) {
			player.teleToLocation(172600, -17599, -4899, ReflectionManager.MAIN);
		} else if (command.startsWith("catacomb_1")) {
			player.teleToLocation(-53174, -250275, -7911, ReflectionManager.MAIN);
		} else if (command.startsWith("catacomb_2")) {
			player.teleToLocation(46542, 170305, -4979, ReflectionManager.MAIN);
		} else if (command.startsWith("catacomb_3")) {
			player.teleToLocation(-20195, -250764, -8163, ReflectionManager.MAIN);
		} else if (command.startsWith("catacomb_4")) {
			player.teleToLocation(140690, 79679, -5429, ReflectionManager.MAIN);
		} else if (command.startsWith("catacomb_5")) {
			player.teleToLocation(-19176, 13504, -4899, ReflectionManager.MAIN);
		} else if (command.startsWith("catacomb_6")) {
			player.teleToLocation(12521, -248481, -9585, ReflectionManager.MAIN);
		}
		else
			super.onBypassFeedback(player, command);
	}
}
