package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 28.10.2019
 * Зачарование: Оружие
 * Зачаруйте оружие 100 раз с помощью следующих Камней Духа:
 * "Камень Духа Высокого Ранга"
 * "Камень Духа Высшего Ранга"
 * "Камень Жизни с Силой Гигантов"
 * "Камень Духа Праны - Высший Ранг"
 **/
public class _3055_PledgeMission extends AugmentItems {
	private static final int[] STONE_ITEM_IDS = {
			45931, // Камень Духа Высокого Ранга
			45932, // Камень Духа Высшего Ранга
			36731, // Камень Жизни с Силой Гигантов
			27584 // Камень Духа Праны - Высший Ранг
	};

	@Override
	protected int[] getStoneItemIds() {
		return STONE_ITEM_IDS;
	}
}
