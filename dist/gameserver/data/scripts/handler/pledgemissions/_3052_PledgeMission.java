package handler.pledgemissions;

/**
 * @author Bonux
 * Талисман Золотого Древа
 * Успешно синтезируйте Талисман Золотого Древа 1 раз.
 **/
public class _3052_PledgeMission extends SynthesisItems {
	private static final int[] ITEM_IDS = {
			39572 //Талисман Золотого Древа
	};

	@Override
	protected int[] getResultItemIds() {
		return ITEM_IDS;
	}
}
