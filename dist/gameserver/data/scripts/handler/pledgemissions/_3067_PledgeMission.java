package handler.pledgemissions;

/**
 * @author Bonux
 * Оружие Фантазмы +15
 * Усильте Оружие Фантазмы до +15 хотя бы 1 раз.
 **/
public class _3067_PledgeMission extends _3066_PledgeMission {
	@Override
	protected int getEnchantLevel() {
		return 15;
	}
}
