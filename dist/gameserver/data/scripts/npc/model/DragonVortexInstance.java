package npc.model;

import l2s.commons.collections.MultiValueSet;
import l2s.commons.util.Rnd;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.NpcUtils;

/**
 * @author pchayka
 */

public final class DragonVortexInstance extends NpcInstance
{
	private final int[] bosses = { 25718, 25719, 25720, 25721, 25722, 25723, 25724 };
	private NpcInstance boss;

	public DragonVortexInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.startsWith("request_boss"))
		{
			if(boss != null && !boss.isDead())
			{
				showChatWindow(player, "default/32871-3.htm", false);
				return;
			}

			if(ItemFunctions.getItemCount(player, 17248) > 0)
			{
				ItemFunctions.deleteItem(player, 17248, 1, true);
				boss = NpcUtils.spawnSingle(bosses[Rnd.get(bosses.length)], Location.coordsRandomize(getLoc(), 300, 600), getReflection());
				showChatWindow(player, "default/32871-1.htm", false);
			}
			else
				showChatWindow(player, "default/32871-2.htm", false);
		}
		else
			super.onBypassFeedback(player, command);
	}
}