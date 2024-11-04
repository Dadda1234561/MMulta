package l2s.gameserver.model.items.listeners;

import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.AgathionHolder;
import l2s.gameserver.data.xml.parser.AgathionParser;
import l2s.gameserver.listener.inventory.OnEquipListener;
import l2s.gameserver.model.Playable;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.actor.instances.player.Agathion;
import l2s.gameserver.model.items.Inventory;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.templates.agathion.AgathionData;
import l2s.gameserver.templates.agathion.AgathionTemplate;
import l2s.gameserver.templates.item.ItemTemplate;
import l2s.gameserver.skills.EffectUseType;
import l2s.gameserver.skills.SkillEntry;
import org.apache.commons.lang3.ArrayUtils;

public final class AccessoryListener implements OnEquipListener
{
	private static final AccessoryListener _instance = new AccessoryListener();

	public static AccessoryListener getInstance()
	{
		return _instance;
	}

	@Override
	public int onEquip(int slot, ItemInstance item, Playable actor)
	{
		if(!item.isEquipable())
			return 0;

		if(!actor.isPlayer())
			return 0;

		Player player = actor.getPlayer();

		boolean isCustomOnEquipAgathion = ArrayUtils.contains(Config.AUTO_AGATHION_SUMMON_ITEM_IDS, item.getItemId());
		if(slot == Inventory.PAPERDOLL_AGATHION_MAIN || isCustomOnEquipAgathion)
		{
			AgathionTemplate agathionTemplate = isCustomOnEquipAgathion ? AgathionHolder.getInstance().getTemplate(Config.AUTO_AGATHION_SUMMON_AGATHION_ID) :  item.getTemplate().getAgathionTemplate();
			if(agathionTemplate == null)
				return 0;

			Agathion agathion = new Agathion(player, agathionTemplate, null);
			agathion.init();
		}
		return 0;
	}

	@Override
	public int onUnequip(int slot, ItemInstance item, Playable actor)
	{
		if(!item.isEquipable())
			return 0;

		if(!actor.isPlayer())
			return 0;

		Player player = actor.getPlayer();

		boolean isCustomOnEquipAgathion = ArrayUtils.contains(Config.AUTO_AGATHION_SUMMON_ITEM_IDS, item.getItemId());
		if(item.getBodyPart() == ItemTemplate.SLOT_L_BRACELET || item.getBodyPart() == ItemTemplate.SLOT_AGATHION || isCustomOnEquipAgathion)
		{
			int transformNpcId = player.getTransformId();
			for(SkillEntry skillEntry : item.getTemplate().getAttachedSkills())
			{
				Skill skill = skillEntry.getTemplate();
				if(skill.getNpcId() == transformNpcId && skill.hasEffect(EffectUseType.NORMAL, "Transformation"))
					player.setTransform(null);
			}

			if ((slot == Inventory.PAPERDOLL_AGATHION_MAIN) || item.getBodyPart() == ItemTemplate.SLOT_L_BRACELET || isCustomOnEquipAgathion)
			{
				Agathion agathion = player.getAgathion();
				if (agathion == null)
				{
					return 0;
				}
				player.deleteAgathion();
			}
		}
		return 0;
	}

	@Override
	public int onRefreshEquip(ItemInstance item, Playable actor)
	{
		return 0;
	}
}