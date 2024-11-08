package npc.model;

import java.util.StringTokenizer;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.data.xml.holder.LuckyGameHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.s2c.ExStartLuckyGame;
import l2s.gameserver.templates.luckygame.LuckyGameData;
import l2s.gameserver.templates.luckygame.LuckyGameType;
import l2s.gameserver.templates.npc.NpcTemplate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Bonux
 */
public class LuckyGameInstance extends NpcInstance
{
	private static final Logger _log = LoggerFactory.getLogger(LuckyGameInstance.class);

	public LuckyGameInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		StringTokenizer st = new StringTokenizer(command, "_");
		String cmd = st.nextToken();
		if(cmd.equals("luckygame"))
		{
			if(!st.hasMoreTokens())
				return;

			int typeId = Integer.parseInt(st.nextToken());
			if(typeId < 0 || typeId >= LuckyGameType.VALUES.length)
				return;

			LuckyGameType type = LuckyGameType.VALUES[typeId];
			LuckyGameData gameData = LuckyGameHolder.getInstance().getData(type);
			if(gameData == null)
			{
				_log.warn("Cannot find data for lucky game TYPE[" + type + "]!");
				return;
			}

			player.sendPacket(new ExStartLuckyGame(player, gameData));
		}
		else
			super.onBypassFeedback(player, command);
	}
}
