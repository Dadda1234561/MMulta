package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 28.10.2019
 * Зачарование: Головные уборы
 * Зачаруйте головные уборы 100 раз с помощью следующих Камней Духа:
 * "Камень Духа для Головных Уборов"
 * "Камень Духа для Диадемы"
 **/
public class _3057_PledgeMission extends AugmentItems {
	private static final int[] STONE_ITEM_IDS = {
			45937, // Камень Духа для Головных Уборов
			48215, // Камень Духа для Диадемы
	};

	@Override
	protected int[] getStoneItemIds() {
		return STONE_ITEM_IDS;
	}
}
