package l2s.gameserver.handler.pledgemissions;

import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.handler.pledgemissions.impl.DefaultPledgeMissionHandler;
import l2s.gameserver.listener.CharListener;
import l2s.gameserver.model.actor.listener.CharListenerList;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 **/
public class PledgeMissionHandlerHolder extends AbstractHolder {
	private static final IPledgeMissionHandler DEFAULT_PLEDGE_MISSION_HANDLER = new DefaultPledgeMissionHandler();

	private static final PledgeMissionHandlerHolder INSTANCE = new PledgeMissionHandlerHolder();

	public static PledgeMissionHandlerHolder getInstance() {
		return INSTANCE;
	}

	private final Map<String, IPledgeMissionHandler> handlers = new HashMap<>();

	private PledgeMissionHandlerHolder() {
		registerHandler(DEFAULT_PLEDGE_MISSION_HANDLER);
	}

	public void registerHandler(IPledgeMissionHandler handler) {
		CharListener listener = handler.getListener();
		if (listener != null)
			CharListenerList.addGlobal(listener);

		handlers.put(handler.getClass().getSimpleName().replace("PledgeMissionHandler", ""), handler);
	}

	public IPledgeMissionHandler getHandler(String handler) {
		if (handler.contains("PledgeMissionHandler"))
			handler = handler.replace("PledgeMissionHandler", "");

		if (handlers.isEmpty() || !handlers.containsKey(handler)) {
			warn(getClass().getSimpleName() + ": Cannot find handler [" + handler + "]!");
			return DEFAULT_PLEDGE_MISSION_HANDLER;
		}

		return handlers.get(handler);
	}

	@Override
	public int size() {
		return handlers.size();
	}

	@Override
	public void clear() {
		handlers.clear();
	}
}
