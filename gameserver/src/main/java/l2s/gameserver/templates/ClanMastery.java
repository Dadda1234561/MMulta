package l2s.gameserver.templates;

import l2s.gameserver.skills.SkillEntry;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 23.09.2019
 **/
public class ClanMastery {
	private final int id;
	private final int clanLevel;
	private final int clanReputation;
	private final int previousMastery;
	private final int previousMasteryAlt;
	private final List<SkillEntry> skills = new ArrayList<>();

	public ClanMastery(int id, int clanLevel, int clanReputation, int previousMastery, int previousMasteryAlt) {
		this.id = id;
		this.clanLevel = clanLevel;
		this.clanReputation = clanReputation;
		this.previousMastery = previousMastery;
		this.previousMasteryAlt = previousMasteryAlt;
	}

	public int getId() {
		return id;
	}

	public int getClanLevel() {
		return clanLevel;
	}

	public int getClanReputation() {
		return clanReputation;
	}

	public int getPreviousMastery() {
		return previousMastery;
	}

	public int getPreviousMasteryAlt() {
		return previousMasteryAlt;
	}

	public List<SkillEntry> getSkills() {
		return skills;
	}
}
