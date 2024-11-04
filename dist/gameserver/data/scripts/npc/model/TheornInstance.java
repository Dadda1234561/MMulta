package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.util.Rnd;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.actor.instances.creature.AbnormalList;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage;
import l2s.gameserver.network.l2.s2c.ExShowScreenMessage.ScreenMessageAlign;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.skills.AbnormalType;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author Bonux
 */
public class TheornInstance extends NpcInstance
{
	// Skill's
	private static final SkillEntry BEGIN_RESEARCH_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 16135, 1);	// Начало Исследований
	private static final SkillEntry REWARD_X_2_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 16136, 1);	// Награда - больше в 2 раза
	private static final SkillEntry REWARD_X_4_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 16137, 1);	// Награда - больше в 4 раза
	private static final SkillEntry REWARD_X_8_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 16138, 1);	// Награда - больше в 8 раз
	private static final SkillEntry REWARD_X_16_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 16139, 1);	// Награда - больше в 16 раз
	private static final SkillEntry REWARD_X_32_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 16140, 1);	// Награда - больше в 32 раза
	private static final SkillEntry RESEARCH_SUCCESS_1_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 16141, 1);	// Успех Исследования
	private static final SkillEntry RESEARCH_SUCCESS_2_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 16142, 1);	// Успех Исследования
	private static final SkillEntry RESEARCH_SUCCESS_3_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 16143, 1);	// Успех Исследования
	private static final SkillEntry RESEARCH_SUCCESS_4_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 16144, 1);	// Успех Исследования
	private static final SkillEntry RESEARCH_SUCCESS_5_SKILL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 16145, 1);	// Успех Исследования
	private static final SkillEntry RESEARCH_FAIL = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 16146, 1);	// Провал Исследования

	// Cost's
	private static final long ADENA_COST = 100000L;
	private static final int SP_COST = 500000;

	public TheornInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... replace)
	{
		if(val == 0)
		{
			final AbnormalList effectList = player.getAbnormalList();
			if(effectList.contains(AbnormalType.RESEARCH_FAIL) || effectList.contains(AbnormalType.RESEARCH_SUCCESS))
			{
				player.sendActionFailed();
				return;
			}

			if(effectList.contains(AbnormalType.RESEARCH_REWARD))
			{
				if(effectList.contains(REWARD_X_32_SKILL))
				{
					showChatWindow(player, "default/" + getNpcId() + "-research_end.htm", firstTalk);
					return;
				}

				showChatWindow(player, "default/" + getNpcId() + "-research_continue.htm", firstTalk);
				return;
			}
		}
		super.showChatWindow(player, val, firstTalk, replace);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.startsWith("roll"))
		{
			final AbnormalList effectList = player.getAbnormalList();
			if(effectList.contains(AbnormalType.RESEARCH_FAIL) || effectList.contains(AbnormalType.RESEARCH_SUCCESS))
			{
				player.sendActionFailed();
				return;
			}

			if(effectList.contains(AbnormalType.RESEARCH_REWARD))
			{
				if(effectList.contains(REWARD_X_32_SKILL))
				{
					player.sendActionFailed();
					return;
				}
			}
			else
			{
				if(player.getSp() < SP_COST || !player.reduceAdena(ADENA_COST, true))
				{
					showChatWindow(player, "default/" + getNpcId() + "-research_no_cost.htm", false);
					return;
				}

				player.sendPacket(new SystemMessagePacket(SystemMsg.YOUR_SP_HAS_DECREASED_BY_S1).addInteger(SP_COST));
				player.setSp(player.getSp() - SP_COST);
				player.forceUseSkill(BEGIN_RESEARCH_SKILL, player);
			}

			SkillEntry skillEntry;
			if(Rnd.chance(50))
			{
				if(effectList.contains(REWARD_X_16_SKILL))
					skillEntry = RESEARCH_SUCCESS_5_SKILL;
				else if(effectList.contains(REWARD_X_8_SKILL))
					skillEntry = RESEARCH_SUCCESS_4_SKILL;
				else if(effectList.contains(REWARD_X_4_SKILL))
					skillEntry = RESEARCH_SUCCESS_3_SKILL;
				else if(effectList.contains(REWARD_X_2_SKILL))
					skillEntry = RESEARCH_SUCCESS_2_SKILL;
				else
					skillEntry = RESEARCH_SUCCESS_1_SKILL;
			}
			else
				skillEntry = RESEARCH_FAIL;

			forceUseSkill(skillEntry, player);
		}
		else if(command.startsWith("reward"))
		{
			final AbnormalList effectList = player.getAbnormalList();
			if(!effectList.contains(AbnormalType.RESEARCH_REWARD))
			{
				showChatWindow(player, "default/" + getNpcId() + "-research_busy.htm", false);
				return;
			}

			int modifier = 1;
			if(effectList.stop(REWARD_X_32_SKILL, false) > 0)
			{
				broadcastPacket(new ExShowScreenMessage(NpcString.S1_ACQUIRED_32_TIMES_THE_SKILL_POINTS_AS_A_REWARD, 3000, ScreenMessageAlign.TOP_CENTER, false, true, player.getName()));
				modifier = 32;
			}
			else if(effectList.stop(REWARD_X_16_SKILL, false) > 0)
			{
				player.sendPacket(new ExShowScreenMessage(NpcString.YOU_HAVE_ACQUIRED_SP_X_16, 3000, ScreenMessageAlign.TOP_CENTER));
				modifier = 16;
			}
			else if(effectList.stop(REWARD_X_8_SKILL, false) > 0)
			{
				player.sendPacket(new ExShowScreenMessage(NpcString.YOU_HAVE_ACQUIRED_SP_X_8, 3000, ScreenMessageAlign.TOP_CENTER));
				modifier = 8;
			}
			else if(effectList.stop(REWARD_X_4_SKILL, false) > 0)
			{
				player.sendPacket(new ExShowScreenMessage(NpcString.YOU_HAVE_ACQUIRED_SP_X_4, 3000, ScreenMessageAlign.TOP_CENTER));
				modifier = 4;
			}
			else if(effectList.stop(REWARD_X_2_SKILL, false) > 0)
			{
				player.sendPacket(new ExShowScreenMessage(NpcString.YOU_HAVE_ACQUIRED_SP_X_2, 3000, ScreenMessageAlign.TOP_CENTER));
				modifier = 2;
			}
			else
			{
				player.sendActionFailed();
				return;
			}

			player.setSp(player.getSp() + (SP_COST * modifier));
		}
		else
			super.onBypassFeedback(player, command);
	}
}