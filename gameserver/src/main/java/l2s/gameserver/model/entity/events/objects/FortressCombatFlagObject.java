package l2s.gameserver.model.entity.events.objects;

import l2s.gameserver.templates.item.ItemTemplate;
import org.apache.commons.lang3.ArrayUtils;
import l2s.commons.dao.JdbcEntityState;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.model.entity.Reflection;
import l2s.gameserver.model.entity.events.Event;
import l2s.gameserver.model.entity.events.impl.FortressSiegeEvent;
import l2s.gameserver.model.entity.events.impl.SiegeEvent;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.model.items.ItemInstance.ItemLocation;
import l2s.gameserver.model.items.attachment.FlagItemAttachment;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.utils.ItemFunctions;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author VISTALL
 * @date 11:59/24.03.2011
 * Item ID: 9819
 */
public class FortressCombatFlagObject implements SpawnableObject, FlagItemAttachment
{
	private static final Logger _log = LoggerFactory.getLogger(FortressCombatFlagObject.class);
	private ItemInstance _item;
	private Location _location;

	private Event _event;

	public FortressCombatFlagObject(Location location)
	{
		_location = location;
	}

	@Override
	public void spawnObject(Event event, Reflection reflection)
	{
		if(_item != null)
		{
			_log.info("FortressCombatFlagObject: can't spawn twice: " + event);
			return;
		}
		_item = ItemFunctions.createItem(9819);
		_item.setAttachment(this);
		_item.dropMe(null, _location);
		_item.setDropTime(0);

		_event = event;
	}

	@Override
	public void despawnObject(Event event, Reflection reflection)
	{
		if(_item == null)
			return;

		Player owner = GameObjectsStorage.getPlayer(_item.getOwnerId());
		if(owner != null)
		{
			owner.getInventory().destroyItem(_item);
			owner.sendDisarmMessage(_item);
		}

		_item.setAttachment(null);
		_item.setJdbcState(JdbcEntityState.UPDATED);
		_item.delete();

		_item.deleteMe();
		_item = null;

		_event = null;
	}

	@Override
	public void respawnObject(Event event, Reflection reflection)
	{

	}

	@Override
	public void refreshObject(Event event, Reflection reflection)
	{

	}

	@Override
	public void onLogout(Player player)
	{
		onLeaveSiegeZone(player);
	}

	@Override
	public void onLeaveSiegeZone(Player player)
	{
		player.getInventory().removeItem(_item);

		_item.setLocation(ItemLocation.VOID);
		_item.setJdbcState(JdbcEntityState.UPDATED);
		_item.update();

		_item.dropMe(null, _location);
		_item.setDropTime(0);
	}

	@Override
	public void onDeath(Player owner, Creature killer)
	{
		onLeaveSiegeZone(owner);
		owner.sendPacket(new SystemMessagePacket(SystemMsg.YOU_HAVE_DROPPED_S1).addItemName(_item.getItemId()));
	}

	@Override
	public boolean canPickUp(Player player)
	{
		if(player.getActiveWeaponFlagAttachment() != null || player.isMounted())
			return false;
		if(!player.containsEvent(getEvent()))
			return false;
		if(!(getEvent() instanceof SiegeEvent))
			return false;
		SiegeClanObject object = ((SiegeEvent) getEvent()).getSiegeClan(FortressSiegeEvent.ATTACKERS, player.getClan());
		if(object == null)
			return false;
		return true;
	}

	@Override
	public void pickUp(Player player)
	{
		player.getInventory().equipItem(_item);

		if(getEvent() instanceof SiegeEvent)
			((SiegeEvent) getEvent()).broadcastTo(new SystemMessagePacket(SystemMsg.C1_HAS_ACQUIRED_THE_FLAG).addName(player), FortressSiegeEvent.ATTACKERS, FortressSiegeEvent.DEFENDERS);
	}

	@Override
	public boolean canAttack(Player player)
	{
		player.sendPacket(SystemMsg.THAT_WEAPON_CANNOT_PERFORM_ANY_ATTACKS);
		return false;
	}

	@Override
	public boolean canCast(Player player, Skill skill)
	{
		ItemTemplate weaponTemplate = player.getActiveWeaponTemplate();
		if(weaponTemplate != null) {
			for(SkillEntry skillEntry : weaponTemplate.getAttachedSkills()) {
				if(skillEntry.getTemplate().equals(skill))
					return true;
			}
		}
		player.sendPacket(SystemMsg.THAT_WEAPON_CANNOT_USE_ANY_OTHER_SKILL_EXCEPT_THE_WEAPONS_SKILL);
		return false;
	}

	@Override
	public void setItem(ItemInstance item)
	{
		// ignored
	}

	public Event getEvent()
	{
		return _event;
	}
}
