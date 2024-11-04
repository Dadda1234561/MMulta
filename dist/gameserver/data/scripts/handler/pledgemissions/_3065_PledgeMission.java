package handler.pledgemissions;

/**
 * @author Bonux
 * Оружие Апокалипсиса +20
 * Усильте Оружие Апокалипсиса до +20 хотя бы 1 раз.
 **/
public class _3065_PledgeMission extends _3064_PledgeMission {
	@Override
	protected int getEnchantLevel() {
		return 20;
	}
}
