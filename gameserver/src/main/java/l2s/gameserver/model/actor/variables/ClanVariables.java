package l2s.gameserver.model.actor.variables;

import l2s.gameserver.dao.ClanVariablesDAO;
import l2s.gameserver.dao.IVariablesDAO;
import l2s.gameserver.model.pledge.Clan;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 23.09.2019
 **/
public class ClanVariables extends Variables {
	// Public variables.
	public static final String DEVELOPMENT_POINTS = "development_point";
	public static final String MASTERY = "mastery";
	public static final String MASTERY_SKILL_TIME = "mastery_skill_time";

	private final Clan owner;

	public ClanVariables(Clan owner) {
		this.owner = owner;
	}

	@Override
	protected IVariablesDAO getDAO() {
		return ClanVariablesDAO.getInstance();
	}

	@Override
	protected int getOwnerId() {
		return owner.getClanId();
	}
}