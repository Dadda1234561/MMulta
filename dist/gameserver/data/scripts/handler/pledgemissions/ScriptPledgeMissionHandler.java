package handler.pledgemissions;

import l2s.gameserver.handler.pledgemissions.PledgeMissionHandlerHolder;
import l2s.gameserver.handler.pledgemissions.impl.DefaultPledgeMissionHandler;
import l2s.gameserver.listener.script.OnLoadScriptListener;

/**
 * @author Bonux
 */
public abstract class ScriptPledgeMissionHandler extends DefaultPledgeMissionHandler implements OnLoadScriptListener {
	@Override
	public void onLoad() {
		PledgeMissionHandlerHolder.getInstance().registerHandler(this);
	}
}
