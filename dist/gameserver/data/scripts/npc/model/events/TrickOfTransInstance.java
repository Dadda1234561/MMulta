package npc.model.events;

import java.util.StringTokenizer;

import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.Functions;
import l2s.commons.util.Rnd;

/**
 * @author L2-scripts.com - (SanyaDC)
**/
public class TrickOfTransInstance extends NpcInstance
{
		// Рецепты
	private static int RED_PSTC = 9162; // Red Philosopher''s Stone Transmutation Circle
	private static int BLUE_PSTC = 9163; // Blue Philosopher''s Stone Transmutation Circle
	private static int ORANGE_PSTC = 9164; // Orange Philosopher''s Stone Transmutation Circle
	private static int BLACK_PSTC = 9165; // Black Philosopher''s Stone Transmutation Circle
	private static int WHITE_PSTC = 9166; // White Philosopher''s Stone Transmutation Circle
	private static int GREEN_PSTC = 9167; // Green Philosopher''s Stone Transmutation Circle
		// Ключ
	private static int A_CHEST_KEY = 9205; // Alchemist''s Chest Key
	// Ингридиенты
	private static int PhilosophersStoneOre = 9168; // Philosopher''s Stone Ore
	private static int PhilosophersStoneOreMax = 17; // Максимальное Кол-во
	private static int PhilosophersStoneConversionFormula = 9169; // Philosopher''s Stone Conversion Formula
	private static int MagicReagents = 9170; // Magic Reagents
	private static int MagicReagentsMax = 30; // Максимальное Кол-во


	public TrickOfTransInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	@Override
	public void onBypassFeedback(Player player, String command)
	{
		StringTokenizer st = new StringTokenizer(command, "_");
		String cmd = st.nextToken();
		if(cmd.equalsIgnoreCase("accept"))
		{
			ItemFunctions.addItem(player, RED_PSTC, 1);
			ItemFunctions.addItem(player, BLACK_PSTC, 1);
			ItemFunctions.addItem(player, BLUE_PSTC, 1);
			ItemFunctions.addItem(player, GREEN_PSTC, 1);
			ItemFunctions.addItem(player, ORANGE_PSTC, 1);
			ItemFunctions.addItem(player, WHITE_PSTC, 1);
			Functions.show("scripts/events/TrickOfTrans/TrickOfTrans_01.htm", player);
	}
	if(cmd.equalsIgnoreCase("open"))
	{
		{
		if(ItemFunctions.getItemCount(player, A_CHEST_KEY) > 0)
		{
			ItemFunctions.deleteItem(player, A_CHEST_KEY, 1);
			ItemFunctions.addItem(player, PhilosophersStoneOre, Rnd.get(1, PhilosophersStoneOreMax));
			ItemFunctions.addItem(player, MagicReagents, Rnd.get(1, MagicReagentsMax));
			if(Rnd.chance(80))
				ItemFunctions.addItem(player, PhilosophersStoneConversionFormula, 1);

			Functions.show("scripts/events/TrickOfTrans/TrickOfTrans_02.htm", player);
		}
		else
			Functions.show("scripts/events/TrickOfTrans/TrickOfTrans_03.htm", player);
	}
	}
	}
}