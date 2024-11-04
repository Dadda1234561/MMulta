package handler.pledgemissions;

/**
 * @author Bonux
 * Талисман Бенира 15 ур.
 * Успешно синтезируйте Талисман Бенира 15 ур. 1 раз.
 **/
public class _3053_PledgeMission extends SynthesisItems {
	private static final int[] ITEM_IDS = {
			39648 //Талисман Бенира Ур. 15
	};

	@Override
	protected int[] getResultItemIds() {
		return ITEM_IDS;
	}
}
