package npc.model;

import java.util.concurrent.Future;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;

/**
 * @author VISTALL
 * @date 17:41/30.08.2011
 */
public class RignosInstance extends NpcInstance
{
	private class EndRaceTask implements Runnable
	{
		@Override
		public void run()
		{
			_raceTask = null;
		}
	}

	private static final SkillEntry SKILL_EVENT_TIMER = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 5239, 5);
	private static final int RACE_STAMP = 10013;
	private static final int SECRET_KEY = 9694;

	private Future<?> _raceTask;

	public RignosInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.equalsIgnoreCase("startRace"))
		{
			if(_raceTask != null)
				return;

			altUseSkill(SKILL_EVENT_TIMER, player);
			ItemFunctions.deleteItem(player, RACE_STAMP, ItemFunctions.getItemCount(player, RACE_STAMP));
			_raceTask = ThreadPoolManager.getInstance().schedule(new EndRaceTask(), 30 * 60 * 1000L);
		}
		else if(command.equalsIgnoreCase("endRace"))
		{
			if(_raceTask == null)
				return;

			long count = ItemFunctions.getItemCount(player, RACE_STAMP);
			if(count >= 4)
			{
				ItemFunctions.deleteItem(player, RACE_STAMP, count);
				ItemFunctions.addItem(player, SECRET_KEY, 3);
				player.getAbnormalList().stop(SKILL_EVENT_TIMER, false);
				_raceTask.cancel(false);
				_raceTask = null;
			}
		}
		else
			super.onBypassFeedback(player, command);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... arg)
	{
		if(ItemFunctions.getItemCount(player, RACE_STAMP) >= 4)
			showChatWindow(player, "default/race_start001a.htm", firstTalk);
		else if(player.getLevel() >= 78 && _raceTask == null)
			showChatWindow(player, "default/race_start001.htm", firstTalk);
		else
			showChatWindow(player, "default/race_start002.htm", firstTalk);
	}
}
