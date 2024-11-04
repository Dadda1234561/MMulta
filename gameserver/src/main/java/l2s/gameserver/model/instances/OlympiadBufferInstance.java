package l2s.gameserver.model.instances;

import gnu.trove.set.hash.TIntHashSet;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.entity.olympiad.Olympiad;
import l2s.gameserver.network.l2.s2c.MagicSkillUse;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.Config;

/**
 * @author Bonux
**/
public class OlympiadBufferInstance extends NpcInstance
{
	private boolean _buffed = false;

	public OlympiadBufferInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onMenuSelect(Player player, int ask, long reply, int state)
	{
		if(ask == -301)
		{
			if(reply == 1)
			{
				giveBuffsSet(player, Olympiad.BUFFS_LIST_GUARDIAN);
			}
			else if(reply == 2)
			{
				giveBuffsSet(player, Olympiad.BUFFS_LIST_BERSERKER);
			}
			else if(reply == 3)
			{
				giveBuffsSet(player, Olympiad.BUFFS_LIST_MAGICIAN);
			}
			showChatWindow(player, 0, false);
		}
		else
			super.onMenuSelect(player, ask, reply, state);
	}

	private void giveBuffsSet(Player player, int[][] buffs)
	{
		_buffed = true;

		for(int[] buff : buffs)
		{
			Skill skill = SkillHolder.getInstance().getSkill(buff[0], buff[1]);
			if(skill == null)
				continue;

			Set<Creature> targets = new HashSet<Creature>();
			targets.add(player);

			if(!skill.isNotBroadcastable())
				broadcastPacket(new MagicSkillUse(this, player, skill.getDisplayId(), skill.getDisplayLevel(), 0, 0));
			callSkill(player, SkillEntry.makeSkillEntry(SkillEntryType.NONE, skill), targets, true, false);
		}
	}

	@Override
	public String getHtmlDir(String filename, Player player)
	{
		return Olympiad.OLYMPIAD_HTML_PATH;
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... replace)
	{
		if(val == 0)
		{
			if(_buffed)
				showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "olympiad_master003.htm", firstTalk, replace);
			else
				showChatWindow(player, Olympiad.OLYMPIAD_HTML_PATH + "olympiad_master001.htm", firstTalk, replace);
		}
		else
			super.showChatWindow(player, val, firstTalk, replace);
	}
	
	@Override
	public boolean isAttackable(Creature attacker)
	{
		if (Config.OLYMPIAD_CANATTACK_BUFFER)
			return true;

		return false;
	}
}