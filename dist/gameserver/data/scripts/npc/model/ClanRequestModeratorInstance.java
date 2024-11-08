package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;

/**
 * @author Bonux
 */
public final class ClanRequestModeratorInstance extends NpcInstance
{
	public ClanRequestModeratorInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void showChatWindow(Player player, int val, boolean firstTalk, Object... replace)
	{
		if(val == 0)
		{
			if(player.isLangRus())
				player.sendMessage("Система клановых заказов в стадии реализации.");
			else
				player.sendMessage("Clan request system in progress.");
			return;
		}
		super.showChatWindow(player, val, firstTalk, replace);
	}
}