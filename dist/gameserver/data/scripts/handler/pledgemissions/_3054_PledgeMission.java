package handler.pledgemissions;

/**
 * @author Bonux
 * Талисман Бенира 24 ур.
 * Успешно синтезируйте Талисман Бенира 24 ур. 1 раз.
 **/
public class _3054_PledgeMission extends SynthesisItems {
	private static final int[] ITEM_IDS = {
			39657 //Талисман Бенира Ур. 24
	};

	@Override
	protected int[] getResultItemIds() {
		return ITEM_IDS;
	}
}
