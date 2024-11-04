package ai;

import l2s.gameserver.GameTimeController;
import l2s.gameserver.ai.Mystic;
import l2s.gameserver.listener.game.OnDayNightChangeListener;
import l2s.gameserver.model.instances.NpcInstance;

/**
 * АИ для мобов, меняющих агресивность в ночное время.<BR>
 * Наследуется на прямую от Mystic.
 *
 * @Author: Death
 * @Date: 23/11/2007
 * @Time: 8:40:10
 */
public class NightAgressionMystic extends Mystic
{
	public NightAgressionMystic(NpcInstance actor)
	{
		super(actor);
		GameTimeController.getInstance().addListener(new NightAgressionDayNightListener());
	}

	private class NightAgressionDayNightListener implements OnDayNightChangeListener
	{
		/**
		 * Вызывается, когда на сервере наступает день
		 */
		@Override
		public void onDay(boolean onStart)
		{
			getActor().setAggroRange(0);
		}

		/**
		 * Вызывается, когда на сервере наступает ночь
		 */
		@Override
		public void onNight(boolean onStart)
		{
			getActor().setAggroRange(-1);
		}
	}
}