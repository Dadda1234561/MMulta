package handler.pledgemissions;

/**
 * @author Bonux
 * Оружие Хелиоса +15
 * Усильте Оружие Хелиоса до +15 хотя бы 1 раз.
 **/
public class _3070_PledgeMission extends _3069_PledgeMission {
	@Override
	protected int getEnchantLevel() {
		return 15;
	}
}
