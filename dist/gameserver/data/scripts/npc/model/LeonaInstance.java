package npc.model;

import instances.MysticTavernFreya;
import instances.MysticTavernKelbim;
import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.SceneMovie;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ReflectionUtils;

/**
 * @author Bonux
 */
public class LeonaInstance extends NpcInstance
{
	public LeonaInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		if(command.startsWith("listen")) {
			ReflectionUtils.enterReflection(player, new MysticTavernKelbim(), 262);
		}
		else
			super.onBypassFeedback(player, command);
	}
}