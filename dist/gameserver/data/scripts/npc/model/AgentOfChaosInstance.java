package npc.model;

import java.util.StringTokenizer;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.model.base.Race;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.s2c.ExChangeToAwakenedClass;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;

/**
 * @author Bonux
 */
public class AgentOfChaosInstance extends NpcInstance
{
	private static final String AWEKENING_REQUEST_VAR = "@awakening_request";
	
	public AgentOfChaosInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... arg)
	{
		if(val == 0)
		{
			if(player == null)
				return;

			if(!checkCond(player))
				return;
		}
		super.showChatWindow(player, val, firstTalk, arg);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		StringTokenizer st = new StringTokenizer(command, "_");
		String cmd = st.nextToken();
		if(cmd.equals("reawake"))
		{
			if(!checkCond(player))
				return;

			if(!st.hasMoreTokens())
			{
				showChatWindow(player, "default/" + getNpcId() + "-reawake.htm", false);
				return;
			}

			ClassId classId = player.getClassId();
			String cmd2 = st.nextToken();
			if(cmd2.equals("list"))
			{
				StringBuilder classes = new StringBuilder();
				for(ClassId c : ClassId.VALUES)
				{
					if(!c.isOfLevel(ClassLevel.AWAKED))
						continue;

					if(c.isOutdated())
						continue;

					if(!c.isOfType2(classId.getType2()))
						continue;

					if(c == classId)
						continue;

					classes.append("<button value=\"");
					classes.append(c.getName(player));
					classes.append("\" action=\"bypass -h npc_%objectId%_reawake_try_");
					classes.append(String.valueOf(c.getId()));
					classes.append("\" width=\"200\" height=\"31\" back=\"L2UI_CT1.HtmlWnd_DF_Awake_Down\" fore=\"L2UI_CT1.HtmlWnd_DF_Awake\"><br>");
				}

				if(classId.isOutdated())
					showChatWindow(player, "default/" + getNpcId() + "-reawake_list.htm", false, "<?CLASS_LIST?>", classes.toString());
				else
					showChatWindow(player, "default/" + getNpcId() + "-reawake_list_essense.htm", false, "<?CLASS_LIST?>", classes.toString());
			}
			else if(cmd2.equals("try"))
			{
				if(!st.hasMoreTokens())
					return;

				ClassId awakedClassId = ClassId.VALUES[Integer.parseInt(st.nextToken())];
				if(awakedClassId == classId)
					return;

				if(!awakedClassId.isOfType2(classId.getType2()))
					return;

				player.setVar(getAwakeningRequestVar(classId), String.valueOf(awakedClassId.getId()), -1);
				player.sendPacket(new ExChangeToAwakenedClass(player, this, awakedClassId.getId()));
				return;
			}
		}
		else
			super.onBypassFeedback(player, command);
	}

	private boolean checkCond(Player player)
	{
		if(player.getClassId().isOfRace(Race.ERTHEIA))
		{
			showChatWindow(player, "default/" + getNpcId() + "-no_ertheia.htm", false);
			return false;
		}

		ClassId classId = player.getClassId();
		if(!classId.isOfLevel(ClassLevel.AWAKED))
		{
			showChatWindow(player, "default/" + getNpcId() + "-no.htm", false);
			return false;
		}

		if(player.isHero())
		{
			showChatWindow(player, "default/" + getNpcId() + "-no_hero.htm", false);
			return false;
		}

		if(!classId.isOutdated())
		{
			if(player.isBaseClassActive())
			{
				if(ItemFunctions.getItemCount(player, ItemTemplate.ITEM_ID_CHAOS_ESSENCE) == 0)
				{
					showChatWindow(player, "default/" + getNpcId() + "-no_already_reawakened.htm", false);
					return false;
				}
			}
			else if(player.isDualClassActive())
			{
				if(ItemFunctions.getItemCount(player, ItemTemplate.ITEM_ID_CHAOS_ESSENCE) > 0 || ItemFunctions.getItemCount(player, ItemTemplate.ITEM_ID_CHAOS_ESSENCE_DUAL_CLASS) == 0)
				{
					showChatWindow(player, "default/" + getNpcId() + "-no_already_reawakened.htm", false);
					return false;
				}
			}
			else
			{
				showChatWindow(player, "default/" + getNpcId() + "-no_already_reawakened.htm", false);
				return false;
			}
		}

		if(player.hasServitor())
		{
			showChatWindow(player, "default/" + getNpcId() + "-no_summon.htm", false);
			return false;
		}

		return true;
	}
	
	public static String getAwakeningRequestVar(ClassId classId)
	{
		return AWEKENING_REQUEST_VAR + "_" + classId.getId();
	}
}
