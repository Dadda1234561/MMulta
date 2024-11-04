package l2s.gameserver.data.xml.holder;

import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.templates.pledgemissions.PledgeMissionCategory;
import l2s.gameserver.templates.pledgemissions.PledgeMissionTemplate;

import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * @author Bonux
 **/
public final class PledgeMissionsHolder extends AbstractHolder {
	private static final PledgeMissionsHolder INSTANCE = new PledgeMissionsHolder();

	public static PledgeMissionsHolder getInstance() {
		return INSTANCE;
	}

	private final Map<Integer, PledgeMissionTemplate> missionsById = new HashMap<>();
	private final Map<PledgeMissionCategory, Map<Integer, PledgeMissionTemplate>> missionsByCategory = new HashMap<>();

	public void addMission(PledgeMissionTemplate mission) {
		missionsById.put(mission.getId(), mission);
		missionsByCategory.computeIfAbsent(mission.getCategory(), (m) -> new HashMap<>()).put(mission.getId(), mission);
	}

	public PledgeMissionTemplate getMission(int id) {
		return missionsById.get(id);
	}

	public Collection<PledgeMissionTemplate> getMissions(PledgeMissionCategory category) {
		return missionsByCategory.getOrDefault(category, Collections.emptyMap()).values();
	}

	@Override
	public int size() {
		return missionsById.size();
	}

	@Override
	public void clear() {
		missionsById.clear();
		missionsByCategory.clear();
	}
}
