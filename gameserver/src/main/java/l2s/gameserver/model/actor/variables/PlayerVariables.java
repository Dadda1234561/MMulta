package l2s.gameserver.model.actor.variables;

import l2s.gameserver.dao.CharacterVariablesDAO;
import l2s.gameserver.dao.IVariablesDAO;
import l2s.gameserver.model.Player;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 23.09.2019
 **/
public class PlayerVariables extends Variables {
	
	public static final String FIRST_ENTER_WORLD = "first_enter_world";
	public static final String PREVIOUS_REPUTATION = "previous_reputation";
	public static final String CURRENT_REPUTATION = "current_reputation";
	public static final String TOTAL_REPUTATION = "total_reputation";
	public static final String CONTRIBUTION_CLAIMED = "contribution_claimed";
	public static final String RESTRICT_FIELD_TIMESTART = "restrict_field_timestart";
	public static final String RESTRICT_FIELD_TIMELEFT = "restrict_field_timeleft";
	public static final String HOMUNCULUS_HP_POINTS = "homunculus_hp_points";
	public static final String HOMUNCULUS_SP_POINTS = "homunculus_sp_points";
	public static final String HOMUNCULUS_VP_POINTS = "homunculus_vp_points";
	public static final String HOMUNCULUS_CREATION_TIME = "homunculus_creation_time";
	public static final String HOMUNCULUS_UPGRADE_POINTS = "homunculus_upgrade_points";
	public static final String HOMUNCULUS_KILLED_MOBS = "homunculus_killed_mobs";
	public static final String BALTHUS_RECEIVED_AMOUNT = "balthus_received_amount";
	public static final String HOMUNCULUS_USED_KILL_CONVERT = "homunculus_used_kill_convert";
	public static final String HOMUNCULUS_USED_RESET_KILLS = "homunculus_used_reset_kills";
	public static final String HOMUNCULUS_USED_VP_POINTS = "homunculus_used_vp_points";
	public static final String HOMUNCULUS_USED_VP_CONVERT = "homunculus_used_vp_convert";
	public static final String HOMUNCULUS_USED_RESET_VP = "homunculus_used_reset_vp";
	public static final String HERO_BOOK_PROGRESS = "HERO_BOOK_PROGRESS";
	public static final String LIMIT_ITEM_REMAIN = "limit_item_remain";
	public static final String RANKING_HISTORY_DAY = "ranking_history_day";
	public static final String CHAMPION_LVL_CHANGE = "championLvlChange";
	public static final String CHANGE_UP_MONSTER_LVL = "changeUpMonsterLvl";
	
	private final Player owner;

	public PlayerVariables(Player owner) {
		this.owner = owner;
	}

	@Override
	protected IVariablesDAO getDAO() {
		return CharacterVariablesDAO.getInstance();
	}

	@Override
	protected int getOwnerId() {
		return owner.getObjectId();
	}
}
