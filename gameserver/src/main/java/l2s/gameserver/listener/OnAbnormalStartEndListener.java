package l2s.gameserver.listener;

import l2s.gameserver.listener.CharListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.actor.instances.creature.Abnormal;

public interface OnAbnormalStartEndListener extends CharListener
{
	public void onAbnormalStart(Creature actor, Abnormal a);

	public void onAbnormalEnd(Creature actor, Abnormal a);
}