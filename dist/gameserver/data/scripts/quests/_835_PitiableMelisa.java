package quests;

import l2s.commons.util.Rnd;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.model.Party;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.components.SceneMovie;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.NpcUtils;

public class _835_PitiableMelisa extends Quest
{
	private static final int CYAN = 34172;	// Сиан
	private static final int SETLEN = 34180;	// Сетлен
	private static final int SIRRA = 34174;	// Сирра

	public _835_PitiableMelisa()
	{
		super(PARTY_NONE, REPEATABLE);

		addStartNpc(CYAN);
		addTalkId(SETLEN);

		addKillId(23686, 23687, 23726);
		addKillId(23689);
		addQuestItem(46594);

		addLevelCheck("1.htm", 99);
	}

	@Override
	public String onTalk(NpcInstance npc, QuestState st)
	{
		String htmltext = NO_QUEST_DIALOG;
		int npcId = npc.getNpcId();
		int cond = st.getCond();
		switch(npcId)
		{
			case CYAN:
			{
				if(cond == 1)
				{
					htmltext = "34172.htm";
				}
				else if(cond == 3)
				{
					htmltext = "34172-03.htm";
				}
				break;
			}
			case SETLEN:
			{
				if(cond == 5)
				{
					st.addExpAndSp(2067574604, 15270101);
					st.takeItems(46594, -1);
					st.giveItems(57, 1186000);
					st.finishQuest();
					htmltext = "34180.htm";
				}
				break;
			}
		}
		return htmltext;
	}

	@Override
	public String onEvent(String event, QuestState qs, NpcInstance npc)
	{
		int cond = qs.getCond();
		Player player = qs.getPlayer();
		if(event.equalsIgnoreCase("enter"))
		{
			if(cond == 1)
			{
				Party party = player.getParty();
				if(party != null) {
					for(Player member : party)
						member.teleToLocation(211496, -42840, -914);
				} else
					player.teleToLocation(211496, -42840, -914);

				setCondFromAll(npc, 2);

				Reflection reflection = player.getReflection();
				if (Rnd.get(10) < 5) {
					reflection.spawnByGroup("mystic_tavern_freya_knight");
					reflection.broadcastPacket(new ExShowScreenMessage(NpcString.ICE_KNIGHTS_GOT_IN_DEFEAT_THE_ICE_KNIGHTS, 20000, ExShowScreenMessage.ScreenMessageAlign.TOP_CENTER, true, true));
				} else {
					reflection.spawnByGroup("mystic_tavern_freya_knight_solo");
				}
				return null;
			}
		}
		else if(event.equalsIgnoreCase("start"))
		{
			if(cond == 3)
			{
				setCondFromAll(npc, 4);

				Reflection reflection = player.getReflection();
				reflection.despawnByGroup("mystic_tavern_freya_npc");
				player.startScenePlayer(SceneMovie.EPIC_FREYA_SCENE);
				ThreadPoolManager.getInstance().schedule(() -> reflection.spawnByGroup("mystic_tavern_freya_boss"), SceneMovie.EPIC_FREYA_SCENE.getDuration());
				return null;
			}
		}
		return event;
	}

	@Override
	public String onKill(NpcInstance npc, QuestState qs)
	{
		int cond = qs.getCond();
		if(cond == 2)
		{
			for(Player member : npc.getReflection().getPlayers())
			{
				QuestState memberQS = member.getQuestState(835);
				if(memberQS != null && memberQS.getCond() == qs.getCond() && !ItemFunctions.haveItem(member, 46594, 10))
					ItemFunctions.addItem(member, 46594, 1);
			}

			if(qs.getPlayer().getInventory().getCountOf(46594) >= 10)
			{
				setCondFromAll(npc, 3);
				NpcUtils.spawnSingle(SIRRA, npc.getLoc(), npc.getReflection());
			}
		}
		else if(cond == 4)
		{
			setCondFromAll(npc, 5);
			npc.getReflection().setReenterTime(System.currentTimeMillis(), true);
			npc.getReflection().startCollapseTimer(5, true);
		}
		return null;
	}

	@Override
	public String onCompleted(NpcInstance npc, QuestState st)
	{
		String htmltext = COMPLETED_DIALOG;
		if(npc.getNpcId() == SETLEN)
		{
			htmltext = "1.htm";
		}
		return htmltext;
	}

	private void setCondFromAll(NpcInstance npc, int cond)
	{
		for(Player player : npc.getReflection().getPlayers())
		{
			QuestState qs = player.getQuestState(835);
			if(qs != null)
				qs.setCond(cond);
		}
	}
}