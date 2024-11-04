package l2s.gameserver.model.actor.listener;

import l2s.commons.listener.Listener;
import l2s.gameserver.listener.actor.playable.OnUseItemListener;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.Playable;
import l2s.gameserver.model.items.ItemInstance;

/**
 * @author Bonux
 */
public class PlayableListenerList extends CharListenerList {
	public PlayableListenerList(Playable actor) {
		super(actor);
	}

	@Override
	public Playable getActor() {
		return (Playable) actor;
	}

	public void onUseItem(ItemInstance item) {
		if (!global.getListeners().isEmpty()) {
			for (Listener<Creature> listener : global.getListeners())
				if (OnUseItemListener.class.isInstance(listener))
					((OnUseItemListener) listener).onUseItem(getActor(), item);
		}

		if (!getListeners().isEmpty()) {
			for (Listener<Creature> listener : getListeners())
				if (OnUseItemListener.class.isInstance(listener))
					((OnUseItemListener) listener).onUseItem(getActor(), item);
		}
	}
}
