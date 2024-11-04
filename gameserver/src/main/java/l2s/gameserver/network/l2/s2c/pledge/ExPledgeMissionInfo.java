package l2s.gameserver.network.l2.s2c.pledge;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.PledgeMission;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.templates.pledgemissions.PledgeMissionTemplate;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 **/
public class ExPledgeMissionInfo extends L2GameServerPacket {
	private final List<PledgeMission> missions = new ArrayList<>();

	public ExPledgeMissionInfo(Player player) {
		for (PledgeMissionTemplate missionTemplate : player.getPledgeMissionList().getAvailableMissions()) {
			PledgeMission mission = player.getPledgeMissionList().get(missionTemplate);
			if (!mission.isFinallyCompleted())
				missions.add(mission);
		}
		Collections.sort(missions);
	}

	protected void writeImpl() {
		writeD(missions.size());
		for (PledgeMission mission : missions) {
			writeD(mission.getId());
			writeD(mission.getCurrentProgress()); // Current progress
			writeC(mission.getStatus().ordinal()); // 1 - Unavalable, 2 - Available
		}
	}
}