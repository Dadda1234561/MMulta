package services.petevolve;

import l2s.commons.dao.JdbcEntityState;
import l2s.gameserver.data.xml.holder.NpcHolder;
import l2s.gameserver.data.xml.holder.PetDataHolder;
import l2s.gameserver.handler.bypass.Bypass;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.model.instances.PetInstance;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.templates.npc.NpcTemplate;
import l2s.gameserver.utils.Functions;

/**
 * User: darkevil
 * Date: 16.05.2008
 * Time: 12:19:36
 */
public class wolfevolve
{
	private static final int WOLF = PetDataHolder.PET_WOLF_ID; //Чтоб было =), проверка на Wolf
	private static final int GREAT_WOLF_NPC_ID = PetDataHolder.GREAT_WOLF_ID;
	private static final int WOLF_COLLAR = 2375; // Ошейник Wolf
	private static final int GREAT_WOLF_NECKLACE = 9882; // Ожерелье Great Wolf

	@Bypass("services.petevolve.wolfevolve:evolve")
	public void evolve(Player player, NpcInstance npc, String[] param)
	{
		PetInstance pl_pet = player.getPet();
		if(player.getInventory().getItemByItemId(WOLF_COLLAR) == null)
		{
			Functions.show("scripts/services/petevolve/no_item.htm", player, npc);
			return;
		}
		if(pl_pet == null || pl_pet.isDead())
		{
			Functions.show("scripts/services/petevolve/evolve_no.htm", player, npc);
			return;
		}
		if(pl_pet.getNpcId() != WOLF)
		{
			Functions.show("scripts/services/petevolve/no_wolf.htm", player, npc);
			return;
		}
		if(pl_pet.getLevel() < 55)
		{
			Functions.show("scripts/services/petevolve/no_level.htm", player, npc);
			return;
		}

		int controlItemId = pl_pet.getControlItemObjId();
		pl_pet.unSummon(false);

		NpcTemplate template = NpcHolder.getInstance().getTemplate(GREAT_WOLF_NPC_ID);
		if(template == null)
			return;

		ItemInstance control = player.getInventory().getItemByObjectId(controlItemId);
		control.setItemId(GREAT_WOLF_NECKLACE);
		control.setEnchantLevel(template.level);
		control.setJdbcState(JdbcEntityState.UPDATED);
		control.update();

		player.sendItemList(false);

		Functions.show("scripts/services/petevolve/yes_wolf.htm", player, npc);
	}
}