package handler.pledgemissions;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 20.10.2019
 * Пылающая душа
 * Вставьте любой из следующих Кристаллов Души 3 раза.
 * "Кристалл Души Каина - Ур. 8"
 * "Кристалл Души Мермедена - Ур. 8"
 * "Кристалл Души Леоны - Ур. 8"
 * "Кристалл Души Пантеона - Ур. 8"
 * "Кристалл Души Леонела - Ур. 8"
 **/
public class _3058_PledgeMission extends EnsoulItems {
	protected static final int[] ENSOUL_ITEM_IDS = {
			46451, // Кристалл Души Каина - Ур. 8
			46466, // Кристалл Души Мермедена - Ур. 8
			46481, // Кристалл Души Леоны - Ур. 8
			46496, // Кристалл Души Пантеона - Ур. 8
			46511 // Кристалл Души Леонела - Ур. 8
	};

	@Override
	protected int[] getEnsoulItemIds() {
		return ENSOUL_ITEM_IDS;
	}
}
