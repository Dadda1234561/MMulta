package l2s.gameserver.data.xml.holder;

import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.templates.TeleportInfo;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Bonux
 **/
public final class TeleportListHolder extends AbstractHolder {
	private static final TeleportListHolder _instance = new TeleportListHolder();

	private final Map<Integer, TeleportInfo> teleporInfos = new HashMap<>();

	public static TeleportListHolder getInstance() {
		return _instance;
	}

	public void addTeleportInfo(TeleportInfo info) {
		teleporInfos.put(info.getId(), info);
	}

	public TeleportInfo getTeleportInfo(int id) {
		return teleporInfos.get(id);
	}

	@Override
	public int size() {
		return teleporInfos.size();
	}

	@Override
	public void clear() {
		teleporInfos.clear();
	}
}
