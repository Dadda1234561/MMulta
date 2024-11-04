package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 28.10.2019
 * Зачарование: Аксессуары
 * Зачаруйте аксессуары 100 раз с помощью следующих Камней Духа:
 * "Камень Духа для Аксессуаров Высокого Ранга"
 * "Камень Духа для Аксессуаров Высшего Ранга"
 **/
public class _3056_PledgeMission extends AugmentItems {
	private static final int[] STONE_ITEM_IDS = {
			45935, // Камень Духа для Аксессуаров Высокого Ранга
			45936 // Камень Духа для Аксессуаров Высшего Ранга
	};

	@Override
	protected int[] getStoneItemIds() {
		return STONE_ITEM_IDS;
	}
}
