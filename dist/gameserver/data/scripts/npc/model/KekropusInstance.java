package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.util.Rnd;
import l2s.gameserver.model.CommandChannel;
import l2s.gameserver.model.Party;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.Race;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.templates.npc.NpcTemplate;

import bosses.HeliosManager;
import bosses.BossesConfig;

/**
 * @author Bonux
**/
public final class KekropusInstance extends NpcInstance
{
	public KekropusInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onMenuSelect(Player player, int ask, long reply, int state)
	{
		if(ask == -2147)
		{
			if(reply == 1)
			{
				if(player.getLevel() > 101)
				{
					QuestState qs = player.getQuestState(10857);
					if(qs != null && qs.isCompleted())
						player.teleToLocation(78040, 181112, -10126, player.getReflection());  //TODO: Check coords.
					else
						player.teleToLocation(79895, 152614, 2304, player.getReflection());
				}
			}
		}
		else
			super.onMenuSelect(player, ask, reply, state);
	}

	@Override
	public void onTeleportRequest(Player talker)
	{
		String htmltext = null;
		if(HeliosManager.isReborned())
		{
			if(!HeliosManager.isStarted())
			{
				final Party party = talker.getParty();
				final CommandChannel commandChannel = party != null ? party.getCommandChannel() : null;
				if(commandChannel != null)
				{
					if(!commandChannel.isLeaderCommandChannel(talker))
					{
						htmltext = "leader_kekrops_not_leader.htm";
					}
					else if(commandChannel.getMemberCount() > BossesConfig.HELIOS_MAX_MEMBERS_COUNT)
					{
						htmltext = "leader_kekrops_over_people.htm";
					}
					else if(commandChannel.getMemberCount() < BossesConfig.HELIOS_MIN_MEMBERS_COUNT)
					{
						htmltext = "leader_kekrops_not_mpcc.htm";
					}
					else
					{
						if(HeliosManager.checkRequiredItems(talker))
						{
							for(Player member : commandChannel)
							{
								if(member.isCursedWeaponEquipped()) // TODO: Check.
									continue;

								if(!member.isInRange(this, 1000))
								{
									showChatWindow(talker, "default/leader_kekrops_too_far.htm", false);
									return;
								}

								if(!HeliosManager.checkRequiredItems(member))
								{
									talker.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_REQUIRED_ITEMS);
									return;
								}

								if(member.getLevel() < BossesConfig.HELIOS_MEMBER_MIN_LEVEL)
								{
									showChatWindow(talker, "default/leader_kekrops_low_level.htm", false);
									return;
								}
							}

							for(Player member : commandChannel)
							{
								if(member.isCursedWeaponEquipped()) // TODO: Check.
									continue;

								if(HeliosManager.consumeRequiredItems(member))
									member.teleToLocation(HeliosManager.TELEPORT_POSITION.getX() + Rnd.get(100), HeliosManager.TELEPORT_POSITION.getY() + Rnd.get(100), HeliosManager.TELEPORT_POSITION.getZ());
							}
							HeliosManager.startEpic();
						}
						else
						{
							talker.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_REQUIRED_ITEMS);
						}
					}
				}
				else
				{
					/*FOR SOLO DEBUG:
					if(HeliosManager.checkRequiredItems(talker))
					{
						if(HeliosManager.consumeRequiredItems(talker))
							talker.teleToLocation(HeliosManager.TELEPORT_POSITION.getX() + Rnd.get(100), HeliosManager.TELEPORT_POSITION.getY() + Rnd.get(100), HeliosManager.TELEPORT_POSITION.getZ());
						HeliosManager.startEpic();
					}
					else
					{
						talker.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_REQUIRED_ITEMS);
					}*/
					htmltext = "leader_kekrops_not_mpcc.htm";
				}
			}
			else
				htmltext = "leader_kekrops_on_battle.htm";
		}
		else
			htmltext = "leader_kekrops_helios_die.htm";

		if(htmltext != null)
			showChatWindow(talker, "default/" + htmltext, false);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... arg)
	{
		if(val == 0)
		{
			if(player.getLevel() > 101)
			{
				if(player.getRace() == Race.ERTHEIA)
					showChatWindow(player, "default/leader_kekrops001b.htm", firstTalk);
				else
					showChatWindow(player, "default/leader_kekrops001a.htm", firstTalk);
			}
			else
				showChatWindow(player, "default/leader_kekrops001.htm", firstTalk);
		}
		else
			super.showChatWindow(player, val, firstTalk, arg);
	}
}