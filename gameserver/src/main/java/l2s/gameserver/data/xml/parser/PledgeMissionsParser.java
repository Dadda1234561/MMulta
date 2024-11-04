package l2s.gameserver.data.xml.parser;

import l2s.commons.data.xml.AbstractParser;
import l2s.commons.string.StringArrayUtils;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.PledgeMissionsHolder;
import l2s.gameserver.templates.item.data.ItemData;
import l2s.gameserver.templates.pledgemissions.PledgeMissionCategory;
import l2s.gameserver.templates.pledgemissions.PledgeMissionTemplate;
import org.dom4j.Element;

import java.io.File;

/**
 * @author Bonux
 **/
public final class PledgeMissionsParser extends AbstractParser<PledgeMissionsHolder> {
	private static final PledgeMissionsParser _instance = new PledgeMissionsParser();

	public static PledgeMissionsParser getInstance() {
		return _instance;
	}

	private PledgeMissionsParser() {
		super(PledgeMissionsHolder.getInstance());
	}

	@Override
	public File getXMLPath() {
		return new File(Config.DATAPACK_ROOT, "data/pledge_missions.xml");
	}

	@Override
	public String getDTDFileName() {
		return "pledge_missions.dtd";
	}

	@Override
	protected void readData(Element rootElement) throws Exception {
		for (Element missionElement : rootElement.elements("mission")) {
			int id = parseInt(missionElement, "id");
			String handler = parseString(missionElement, "handler");
			PledgeMissionCategory category = PledgeMissionCategory.valueOfXml(parseString(missionElement, "category"));
			boolean repeatable = parseBoolean(missionElement, "repeatable", false);
			int minPledgeLevel = parseInt(missionElement, "min_pledge_level", 0);
			int pledgeMastery = parseInt(missionElement, "pledge_mastery", 0);
			int minPlayerLevel = parseInt(missionElement, "min_player_level", 0);
			int maxPlayerLevel = parseInt(missionElement, "max_player_level", 0);
			boolean mainClass = parseBoolean(missionElement, "main_class", true);
			boolean dualClass = parseBoolean(missionElement, "dual_class", true);
			boolean subClass = parseBoolean(missionElement, "sub_class", false);
			boolean isAllLvl = parseBoolean(missionElement, "is_all_lvl", false);
			int previousMissionId = parseInt(missionElement, "previous_mission_id", 0);
			int startDate = parseInt(missionElement, "start_date", 0);
			int startTime = parseInt(missionElement, "start_time", 0);
			int endDate = parseInt(missionElement, "end_date", 0);
			int endTime = parseInt(missionElement, "end_time", 0);
			int activateTime = parseInt(missionElement, "activate_time", 0);
			int deactivateTime = parseInt(missionElement, "deactivate_time", 0);
			int unk = parseInt(missionElement, "unk", 0);
			int[] availableDay = StringArrayUtils.stringToIntArray(parseString(missionElement, "available_day", ""), ";");
			int goalCount = parseInt(missionElement, "goal_count", 0);
			int clanReputationReward = parseInt(missionElement, "clan_reputation_reward", 0);
			int fameReward = parseInt(missionElement, "fame_reward", 0);
			PledgeMissionTemplate mission = new PledgeMissionTemplate(id, handler, category, repeatable, minPledgeLevel, pledgeMastery, minPlayerLevel, maxPlayerLevel, mainClass, dualClass, subClass, isAllLvl, previousMissionId, startDate, startTime, endDate, endTime, activateTime, deactivateTime, unk, availableDay, goalCount, clanReputationReward, fameReward);
			for (Element itemRewardsElement : missionElement.elements("reward_items")) {
				for (Element itemElement : itemRewardsElement.elements("item")) {
					int itemId = parseInt(itemElement, "id");
					long itemCount = parseLong(itemElement, "count");
					mission.getRewardItems().add(new ItemData(itemId, itemCount));
				}
			}
			getHolder().addMission(mission);
		}
	}
}