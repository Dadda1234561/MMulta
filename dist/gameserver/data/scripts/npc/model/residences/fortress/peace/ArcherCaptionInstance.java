package npc.model.residences.fortress.peace;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author VISTALL
 * @date 16:14/17.04.2011
 */
public class ArcherCaptionInstance extends NpcInstance
{
	public ArcherCaptionInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... arg)
	{
		showChatWindow(player, "residence2/fortress/fortress_archer.htm", firstTalk);
	}
}
