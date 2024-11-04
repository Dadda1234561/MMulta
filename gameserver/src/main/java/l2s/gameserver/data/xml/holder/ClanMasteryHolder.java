package l2s.gameserver.data.xml.holder;

import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.templates.ClanMastery;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 23.09.2019
 **/
public class ClanMasteryHolder extends AbstractHolder {
	private static final ClanMasteryHolder INSTANCE = new ClanMasteryHolder();

	public static ClanMasteryHolder getInstance() {
		return INSTANCE;
	}

	private final Map<Integer, ClanMastery> clanMasteryMap = new HashMap<>();

	public void addClanMastery(ClanMastery clanMastery) {
		clanMasteryMap.put(clanMastery.getId(), clanMastery);
	}

	public ClanMastery getClanMastery(int id) {
		return clanMasteryMap.get(id);
	}

	public Collection<ClanMastery> getClanMasteries() {
		return clanMasteryMap.values();
	}

	@Override
	public int size() {
		return clanMasteryMap.size();
	}

	@Override
	public void clear() {
		clanMasteryMap.clear();
	}
}
