package npc.model.events;

import java.util.List;
import java.util.StringTokenizer;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.data.xml.holder.EventHolder;
import l2s.gameserver.instancemanager.games.HandysBlockCheckerManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.events.EventType;
import l2s.gameserver.model.entity.events.impl.KrateisCubeEvent;
import l2s.gameserver.model.entity.events.impl.KrateisCubeRunnerEvent;
import l2s.gameserver.model.entity.events.objects.KrateisCubePlayerObject;
import l2s.gameserver.model.entity.olympiad.Olympiad;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author VISTALL
 * @date  15:52/19.11.2010
 */
public class KrateisCubeManagerInstance extends NpcInstance
{
	public KrateisCubeManagerInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.startsWith("Kratei_UnRegister"))
		{
			KrateisCubeRunnerEvent runnerEvent = EventHolder.getInstance().getEvent(EventType.MAIN_EVENT, 1);
			for(KrateisCubeEvent cubeEvent : runnerEvent.getCubes())
			{
				List<KrateisCubePlayerObject> list = cubeEvent.getObjects(KrateisCubeEvent.REGISTERED_PLAYERS);
				KrateisCubePlayerObject krateisCubePlayer = cubeEvent.getRegisteredPlayer(player);

				if(krateisCubePlayer != null)
					list.remove(krateisCubePlayer);
			}

			showChatWindow(player, 4, false);
		}
		else if(command.startsWith("Kratei_TryRegister"))
		{
			KrateisCubeRunnerEvent runnerEvent = EventHolder.getInstance().getEvent(EventType.MAIN_EVENT, 1);
			if(runnerEvent.isRegistrationOver())
			{
				if(runnerEvent.isInProgress())
					showChatWindow(player, 3, false);
				else
					showChatWindow(player, 7, false);
			}
			else
			{
				if(player.getLevel() < 70)
					showChatWindow(player, 2, false);
				else
					showChatWindow(player, 5, false);
			}
		}
		else if(command.startsWith("Kratei_SeeList"))
		{
			if(player.getLevel() < 70)
				showChatWindow(player, 2, false);
			else
				showChatWindow(player, 5, false);
		}
		else if(command.startsWith("Kratei_Register"))
		{
			if(Olympiad.isRegistered(player) || HandysBlockCheckerManager.isRegistered(player))
			{
				player.sendPacket(SystemMsg.YOU_CANNOT_BE_SIMULTANEOUSLY_REGISTERED_FOR_PVP_MATCHES_SUCH_AS_THE_OLYMPIAD_UNDERGROUND_COLISEUM_AERIAL_CLEFT_KRATEIS_CUBE_AND_HANDYS_BLOCK_CHECKERS);
				return;
			}

			if(player.isCursedWeaponEquipped())
			{
				player.sendPacket(SystemMsg.YOU_CANNOT_REGISTER_WHILE_IN_POSSESSION_OF_A_CURSED_WEAPON);
				return;
			}

			//TODO [VISTALL] Добавить проверки?

			StringTokenizer t = new StringTokenizer(command);
			if(t.countTokens() < 2)
				return;
			t.nextToken();
			KrateisCubeEvent cubeEvent = EventHolder.getInstance().getEvent(EventType.PVP_EVENT, Integer.parseInt(t.nextToken()));
			if(cubeEvent == null)
				return;

			if(player.getLevel() < cubeEvent.getMinLevel() || player.getLevel() > cubeEvent.getMaxLevel())
			{
				showChatWindow(player, 2, false);
				return;
			}

			List<KrateisCubePlayerObject> list = cubeEvent.getObjects(KrateisCubeEvent.REGISTERED_PLAYERS);
			KrateisCubePlayerObject krateisCubePlayer = cubeEvent.getRegisteredPlayer(player);

			if(krateisCubePlayer != null)
			{
				showChatWindow(player, 6, false);
				return;
			}

			if(list.size() >= 25)
				showChatWindow(player, 9, false);
			else
			{
				cubeEvent.addObject(KrateisCubeEvent.REGISTERED_PLAYERS, new KrateisCubePlayerObject(player));
				showChatWindow(player, 8, false);
			}
		}
		else
			super.onBypassFeedback(player, command);
	}
}
