package services;

import l2s.gameserver.geometry.Location;
import l2s.gameserver.handler.bypass.Bypass;
import l2s.gameserver.model.Party;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.utils.Functions;

public class TeleToStakatoNest
{
	private final static Location[] teleports = {
			new Location(80456, -52322, -5640),
			new Location(88718, -46214, -4640),
			new Location(87464, -54221, -5120),
			new Location(80848, -49426, -5128),
			new Location(87682, -43291, -4128) };

	@Bypass("services.TeleToStakatoNest:list")
	public void list(Player player, NpcInstance npc, String[] param)
	{
		QuestState qs = player.getQuestState(240);
		if(qs == null || !qs.isCompleted())
		{
			Functions.show("scripts/services/TeleToStakatoNest-no.htm", player);
			return;
		}

		Functions.show("scripts/services/TeleToStakatoNest.htm", player);
	}

	@Bypass("services.TeleToStakatoNest:teleTo")
	public void teleTo(Player player, NpcInstance npc, String[] param)
	{
		if(param.length != 1)
			return;

		Location loc = teleports[Integer.parseInt(param[0]) - 1];
		Party party = player.getParty();
		if(party == null)
			player.teleToLocation(loc);
		else
		{
			for(Player member : party.getPartyMembers())
			{
				if(member != null && member.isInRange(player, 1000))
					member.teleToLocation(loc);
			}
		}
	}
}