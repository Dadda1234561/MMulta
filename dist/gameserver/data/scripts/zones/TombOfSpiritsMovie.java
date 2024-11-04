package zones;

import l2s.gameserver.listener.script.OnInitScriptListener;
import l2s.gameserver.listener.zone.OnZoneEnterLeaveListener;
import l2s.gameserver.listener.zone.impl.PresentSceneMovieZoneListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Zone;
import l2s.gameserver.network.l2.components.SceneMovie;
import l2s.gameserver.utils.ReflectionUtils;

/**
 * @author Bonux
 */
public class TombOfSpiritsMovie implements OnInitScriptListener
{
	public class ZoneListener implements OnZoneEnterLeaveListener
	{
		@Override
		public void onZoneEnter(Zone zone, Creature cha)
		{
			if(!cha.isPlayer())
				return;

			Player player = cha.getPlayer();
			if(player == null)
				return;

			if(!player.getClassId().isAwaked())
				return;

			if(!player.getVarBoolean("@scene_awekening_view"))
			{
				PresentSceneMovieZoneListener.scheduleShowMovie(SceneMovie.SCENE_AWEKENING_VIEW, player);
				player.setVar("@scene_awekening_view", "true", -1);
			}
		}

		@Override
		public void onZoneLeave(Zone zone, Creature cha)
		{
			//
		}
	}

	private static final String ZONE_NAME = "[aweke_presentation_video]";

	private static ZoneListener _zoneListener;

	@Override
	public void onInit()
	{
		_zoneListener = new ZoneListener();

		Zone zone = ReflectionUtils.getZone(ZONE_NAME);
		if(zone != null)
			zone.addListener(_zoneListener);
	}
}