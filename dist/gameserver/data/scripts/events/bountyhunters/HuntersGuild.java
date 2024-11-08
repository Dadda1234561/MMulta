package events.bountyhunters;

import java.util.ArrayList;
import java.util.List;

import l2s.commons.util.Rnd;
import l2s.gameserver.Config;
import l2s.gameserver.data.string.ItemNameHolder;
import l2s.gameserver.data.xml.holder.ItemHolder;
import l2s.gameserver.data.xml.holder.NpcHolder;
import l2s.gameserver.handler.voicecommands.IVoicedCommandHandler;
import l2s.gameserver.handler.voicecommands.VoicedCommandHandler;
import l2s.gameserver.listener.actor.OnDeathListener;
import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.listener.CharListenerList;
import l2s.gameserver.model.instances.ChestInstance;
import l2s.gameserver.model.instances.DeadManInstance;
import l2s.gameserver.model.instances.MonsterInstance;
import l2s.gameserver.model.instances.RaidBossInstance;
import l2s.gameserver.model.instances.TamedBeastInstance;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.Functions;
import l2s.gameserver.utils.ItemFunctions;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import npc.model.QueenAntLarvaInstance;

public class HuntersGuild implements IVoicedCommandHandler, OnInitScriptListener
{
	private static class EventListeners implements OnDeathListener
	{
		@Override
		public void onDeath(Creature cha, Creature killer)
		{
			if(!Config.EVENT_BOUNTY_HUNTERS_ENABLED)
				return;

			if(cha.isMonster() && !cha.isRaid() && killer != null && killer.getPlayer() != null && killer.getPlayer().getVar("bhMonstersId") != null && Integer.parseInt(killer.getPlayer().getVar("bhMonstersId")) == cha.getNpcId())
			{
				int count = Integer.parseInt(killer.getPlayer().getVar("bhMonstersKilled")) + 1;
				killer.getPlayer().setVar("bhMonstersKilled", String.valueOf(count), -1);
				int needed = Integer.parseInt(killer.getPlayer().getVar("bhMonstersNeeded"));
				if(count >= needed)
					doReward(killer.getPlayer());
				else
					killer.getPlayer().sendMessage(new CustomMessage("scripts.events.bountyhunters.NotifyKill").addNumber(needed - count));
			}
		}
	}

	private static final String[] _commandList = new String[] { "gettask", "declinetask" };
	private static final Logger _log = LoggerFactory.getLogger(HuntersGuild.class);

	private static final EventListeners EVENT_LISTENERS = new EventListeners();

	@Override
	public void onInit()
	{
		if(!Config.EVENT_BOUNTY_HUNTERS_ENABLED)
			return;

		CharListenerList.addGlobal(EVENT_LISTENERS);
		VoicedCommandHandler.getInstance().registerVoicedCommandHandler(this);
		_log.info("Loaded Event: Bounty Hunters Guild");
	}

	private static boolean checkTarget(NpcTemplate npc)
	{
		if(!npc.isInstanceOf(MonsterInstance.class))
			return false;
		if(npc.rewardExp == 0)
			return false;
		if(npc.isInstanceOf(RaidBossInstance.class))
			return false;
		if(npc.isInstanceOf(QueenAntLarvaInstance.class))
			return false;
		if(npc.isInstanceOf(npc.model.events.SquashInstance.class))
			return false;
		if(npc.isInstanceOf(TamedBeastInstance.class))
			return false;
		if(npc.isInstanceOf(DeadManInstance.class))
			return false;
		if(npc.isInstanceOf(ChestInstance.class))
			return false;
		if(npc.title.contains("Quest Monster"))
			return false;
		if(GameObjectsStorage.getNpcs(true, npc.getId()).isEmpty())
			return false;
		return true;
	}

	public void getTask(Player player, int id)
	{
		if(!Config.EVENT_BOUNTY_HUNTERS_ENABLED)
			return;
		NpcTemplate target;
		double mod = 1.;
		if(id == 0)
		{
			List<NpcTemplate> monsters = NpcHolder.getInstance().getAllOfLevel(player.getLevel());
			if(monsters == null || monsters.isEmpty())
			{
				Functions.show(new CustomMessage("scripts.events.bountyhunters.NoTargets"), player);
				return;
			}
			List<NpcTemplate> targets = new ArrayList<NpcTemplate>();
			for(NpcTemplate npc : monsters)
				if(checkTarget(npc))
					targets.add(npc);
			if(targets.isEmpty())
			{
				Functions.show(new CustomMessage("scripts.events.bountyhunters.NoTargets"), player);
				return;
			}
			target = targets.get(Rnd.get(targets.size()));
		}
		else
		{
			target = NpcHolder.getInstance().getTemplate(id);
			if(target == null || !checkTarget(target))
			{
				Functions.show(new CustomMessage("scripts.events.bountyhunters.WrongTarget"), player);
				return;
			}
			if(player.getLevel() - target.level > 5)
			{
				Functions.show(new CustomMessage("scripts.events.bountyhunters.TooEasy"), player);
				return;
			}
			mod = 0.5 * (10 + target.level - player.getLevel()) / 10.;
		}

		int mobcount = target.level + Rnd.get(25, 50);
		player.setVar("bhMonstersId", String.valueOf(target.getId()), -1);
		player.setVar("bhMonstersNeeded", String.valueOf(mobcount), -1);
		player.setVar("bhMonstersKilled", "0", -1);

		int fails = player.getVar("bhfails") == null ? 0 : Integer.parseInt(player.getVar("bhfails")) * 5;
		int success = player.getVar("bhsuccess") == null ? 0 : Integer.parseInt(player.getVar("bhsuccess")) * 5;

		double reputation = Math.min(Math.max((100 + success - fails) / 100., .25), 2.) * mod;

		long adenarewardvalue = Math.round((target.level * Math.max(Math.log(target.level), 1) * 10 + Math.max((target.level - 60) * 33, 0) + Math.max((target.level - 65) * 50, 0)) * target.rateHp * mobcount * player.getRateAdena() * reputation * .15);
		if(Rnd.chance(30)) // Адена, 30% случаев
		{
			player.setVar("bhRewardId", "57", -1);
			player.setVar("bhRewardCount", String.valueOf(adenarewardvalue), -1);
		}
		else
		{ // Кристаллы, 70% случаев
			int crystal = 0;
			if(target.level <= 39)
				crystal = 1458; // D
			else if(target.level <= 51)
				crystal = 1459; // C
			else if(target.level <= 60)
				crystal = 1460; // B
			else if(target.level <= 75)
				crystal = 1461; // A
			else
				crystal = 1462; // S
			player.setVar("bhRewardId", String.valueOf(crystal), -1);
			player.setVar("bhRewardCount", String.valueOf(adenarewardvalue / ItemHolder.getInstance().getTemplate(crystal).getReferencePrice()), -1);
		}
		Functions.show(new CustomMessage("scripts.events.bountyhunters.TaskGiven").addNumber(mobcount).addString(target.name), player);
	}

	private static void doReward(Player player)
	{
		if(!Config.EVENT_BOUNTY_HUNTERS_ENABLED)
			return;
		int rewardid = Integer.parseInt(player.getVar("bhRewardId"));
		long rewardcount = Long.parseLong(player.getVar("bhRewardCount"));
		player.unsetVar("bhMonstersId");
		player.unsetVar("bhMonstersNeeded");
		player.unsetVar("bhMonstersKilled");
		player.unsetVar("bhRewardId");
		player.unsetVar("bhRewardCount");
		if(player.getVar("bhsuccess") != null)
			player.setVar("bhsuccess", String.valueOf(Integer.parseInt(player.getVar("bhsuccess")) + 1), -1);
		else
			player.setVar("bhsuccess", "1", -1);
		ItemFunctions.addItem(player, rewardid, rewardcount);
		Functions.show(new CustomMessage("scripts.events.bountyhunters.TaskCompleted").addNumber(rewardcount).addString(ItemNameHolder.getInstance().getItemName(player, rewardid)), player);
	}

	@Override
	public String[] getVoicedCommandList()
	{
		return _commandList;
	}

	@Override
	public boolean useVoicedCommand(String command, Player activeChar, String target)
	{
		if(activeChar == null || !Config.EVENT_BOUNTY_HUNTERS_ENABLED)
			return false;
		if(activeChar.getLevel() < 20)
		{
			activeChar.sendMessage(new CustomMessage("scripts.events.bountyhunters.TooLowLevel"));
			return true;
		}
		if(command.equalsIgnoreCase("gettask"))
		{
			if(activeChar.getVar("bhMonstersId") != null)
			{
				int mobid = Integer.parseInt(activeChar.getVar("bhMonstersId"));
				int mobcount = Integer.parseInt(activeChar.getVar("bhMonstersNeeded")) - Integer.parseInt(activeChar.getVar("bhMonstersKilled"));
				Functions.show(new CustomMessage("scripts.events.bountyhunters.TaskGiven").addNumber(mobcount).addString(NpcHolder.getInstance().getTemplate(mobid).name), activeChar);
				return true;
			}
			int id = 0;
			if(target != null && target.trim().matches("[\\d]{1,9}"))
				id = Integer.parseInt(target);
			getTask(activeChar, id);
			return true;
		}
		if(command.equalsIgnoreCase("declinetask"))
		{
			if(activeChar.getVar("bhMonstersId") == null)
			{
				activeChar.sendMessage(new CustomMessage("scripts.events.bountyhunters.NoTask"));
				return true;
			}
			activeChar.unsetVar("bhMonstersId");
			activeChar.unsetVar("bhMonstersNeeded");
			activeChar.unsetVar("bhMonstersKilled");
			activeChar.unsetVar("bhRewardId");
			activeChar.unsetVar("bhRewardCount");
			if(activeChar.getVar("bhfails") != null)
				activeChar.setVar("bhfails", String.valueOf(Integer.parseInt(activeChar.getVar("bhfails")) + 1), -1);
			else
				activeChar.setVar("bhfails", "1", -1);
			Functions.show(new CustomMessage("scripts.events.bountyhunters.TaskCanceled"), activeChar);
			return true;
		}
		return false;
	}
}