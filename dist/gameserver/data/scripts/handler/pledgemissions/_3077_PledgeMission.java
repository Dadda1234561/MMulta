package handler.pledgemissions;

/**
 * @author Bonux
 * Оружие Темного Хелиоса +20
 * Усильте Оружие Темного Хелиоса до +20 хотя бы 1 раз.
 **/
public class _3077_PledgeMission extends _3076_PledgeMission {
	@Override
	protected int getEnchantLevel() {
		return 20;
	}
}
