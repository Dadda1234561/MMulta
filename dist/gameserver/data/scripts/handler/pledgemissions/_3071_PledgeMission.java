package handler.pledgemissions;

/**
 * @author Bonux
 * Оружие Хелиоса +20
 * Усильте Оружие Хелиоса до +20 хотя бы 1 раз.
 **/
public class _3071_PledgeMission extends _3070_PledgeMission {
	@Override
	protected int getEnchantLevel() {
		return 20;
	}
}
