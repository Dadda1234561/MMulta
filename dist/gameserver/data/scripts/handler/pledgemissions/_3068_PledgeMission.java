package handler.pledgemissions;

/**
 * @author Bonux
 * Оружие Фантазмы +20
 * Усильте Оружие Фантазмы до +20 хотя бы 1 раз.
 **/
public class _3068_PledgeMission extends _3067_PledgeMission {
	@Override
	protected int getEnchantLevel() {
		return 20;
	}
}
