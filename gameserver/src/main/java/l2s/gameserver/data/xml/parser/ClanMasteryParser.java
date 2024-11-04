package l2s.gameserver.data.xml.parser;

import l2s.commons.data.xml.AbstractParser;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.ClanMasteryHolder;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.ClanMastery;
import org.dom4j.Element;

import java.io.File;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 23.09.2019
 **/
public class ClanMasteryParser extends AbstractParser<ClanMasteryHolder> {
	private static final ClanMasteryParser INSTANCE = new ClanMasteryParser();

	public static ClanMasteryParser getInstance() {
		return INSTANCE;
	}

	protected ClanMasteryParser() {
		super(ClanMasteryHolder.getInstance());
	}

	@Override
	public File getXMLPath() {
		return new File(Config.DATAPACK_ROOT, "data/clan_mastery.xml");
	}

	@Override
	public String getDTDFileName() {
		return "clan_mastery.dtd";
	}

	@Override
	protected void readData(Element rootElement) throws Exception {
		for (Element masteryElement : rootElement.elements("mastery")) {
			int id = parseInt(masteryElement, "id");
			int clanLevel = parseInt(masteryElement, "clan_level");
			int clanReputation = parseInt(masteryElement, "clan_reputation");
			int previousMastery = parseInt(masteryElement, "previous_mastery", 0);
			int previousMasteryAlt = parseInt(masteryElement, "previous_mastery_alt", 0);
			ClanMastery clanMastery = new ClanMastery(id, clanLevel, clanReputation, previousMastery, previousMasteryAlt);
			for (Element skillElement : masteryElement.elements("skill")) {
				int skillId = parseInt(skillElement, "id");
				int skillLevel = parseInt(skillElement, "level");
				SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.PLEDGE, skillId, skillLevel);
				if(skillEntry == null) {
					warn(String.format("Not found skill ID[%d] LEVEL[%d] for clan master ID[%d]!", skillId, skillLevel, id));
				}
				clanMastery.getSkills().add(skillEntry);
			}
			getHolder().addClanMastery(clanMastery);
		}
	}
}
