package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author Bonux
 */
public final class HoldenInstance extends NpcInstance
{
	public HoldenInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.equalsIgnoreCase("enter_to_underground"))
		{
			QuestState qs = player.getQuestState(10323);
			if(qs == null || qs.getCond() != 1)
			{
				showChatWindow(player, "default/" + getNpcId() + "-no.htm", false);
				return;
			}

			Quest quest = qs.getQuest();
			if(quest == null)
			{
				showChatWindow(player, "default/" + getNpcId() + "-no.htm", false);
				return;
			}

			quest.onTalk(this, qs);
			return;
		}
		else
			super.onBypassFeedback(player, command);
	}
}
