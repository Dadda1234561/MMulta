package l2s.gameserver.network.l2.s2c.timerestrictfield;

import java.util.HashMap;
import java.util.Map;

import l2s.gameserver.data.QuestHolder;
import l2s.gameserver.data.xml.holder.TimeRestrictFieldHolder;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.templates.TimeRestrictFieldInfo;

/**
 * @author nexvill
 */
public class ExTimeRestrictFieldUserEnter extends L2GameServerPacket
{
	private final Player _player;
	private final int _fieldId;
	private Map<Integer, TimeRestrictFieldInfo> _fields = new HashMap<>();

	public ExTimeRestrictFieldUserEnter(Player player, int fieldId)
	{
		_player = player;
		_fieldId = fieldId;
		_fields = TimeRestrictFieldHolder.getInstance().getFields();
	}

	@Override
	protected final void writeImpl()
	{
		TimeRestrictFieldInfo field = _fields.get(_fieldId);
		int remainTime = 0;
		if (field != null) {
			remainTime = field.getRemainingTime(_player);
			if (remainTime <= 0) {
				_player.sendMessage("No more time available...");
				return;
			}

			_player.setVar(PlayerVariables.RESTRICT_FIELD_TIMESTART + "_" + field.getReflectionId(), System.currentTimeMillis());
			_player.setVar(PlayerVariables.RESTRICT_FIELD_TIMELEFT + "_" + field.getReflectionId(), remainTime);

			if (_player.getRebirthCount() >= 50 && field.getFieldId() == 1) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.STORM_ISLE);
					_player.setReflection(ReflectionManager.STORM_ISLE);
					_player.setActiveReflection(ReflectionManager.STORM_ISLE);
					telepotToLocationPacket(remainTime);
				}
			}
			else if (_player.getRebirthCount() >= 15 && field.getFieldId() == 6) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.PRIMEVAL_ISLE);
					_player.setReflection(ReflectionManager.PRIMEVAL_ISLE);
					_player.setActiveReflection(ReflectionManager.PRIMEVAL_ISLE);
					telepotToLocationPacket(remainTime);
				}
			}
			else if (_player.getRebirthCount() >= 70 && field.getFieldId() == 7) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.GOLDEN_ALTAR);
					_player.setReflection(ReflectionManager.GOLDEN_ALTAR);
					_player.setActiveReflection(ReflectionManager.GOLDEN_ALTAR);
					telepotToLocationPacket(remainTime);
				}
			}
			else if (_player.getRebirthCount() >= 130 && field.getFieldId() == 8) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.TOWER_OF_INSOLENCE);
					_player.setReflection(ReflectionManager.TOWER_OF_INSOLENCE);
					_player.setActiveReflection(ReflectionManager.TOWER_OF_INSOLENCE);
					telepotToLocationPacket(remainTime);
				}
			}
			else if (_player.getRebirthCount() >= 100 && field.getFieldId() == 11) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.COAL_MINES);
					_player.setReflection(ReflectionManager.COAL_MINES);
					_player.setActiveReflection(ReflectionManager.COAL_MINES);
					telepotToLocationPacket(remainTime);
				}
			}
			else if (_player.getRebirthCount() >= 30 && field.getFieldId() == 12) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.IMPERIAL_TOMB);
					_player.setReflection(ReflectionManager.IMPERIAL_TOMB);
					_player.setActiveReflection(ReflectionManager.IMPERIAL_TOMB);
					//if (!_player.isQuestCompleted(933)) {
					//	if (_player.getQuestState(933) == null) {
					//		Quest quest = QuestHolder.getInstance().getQuest(933);
					//		QuestState qs = quest.newQuestState(_player);
					//		qs.setCond(1);
					//	}
					//	else {
					//		_player.getQuestState(933).setCond(1);
					//	}
					//}
					telepotToLocationPacket(remainTime);
				}
			}
			else if (_player.getRebirthCount() >= 10 && field.getFieldId() == 14) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.ASTATINE_FACTORY);
					_player.setReflection(ReflectionManager.ASTATINE_FACTORY);
					_player.setActiveReflection(ReflectionManager.ASTATINE_FACTORY);
					telepotToLocationPacket(remainTime);
				}
			}
			else if (_player.getRebirthCount() >= 150 && field.getFieldId() == 23) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.SUPERION_FORTRESS);
					_player.setReflection(ReflectionManager.SUPERION_FORTRESS);
					_player.setActiveReflection(ReflectionManager.SUPERION_FORTRESS);
					telepotToLocationPacket(remainTime);
				}
			}
			else if (_player.getRebirthCount() >= 150 && field.getFieldId() == 18) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.FROST_LORDS_CASTLE);
					_player.setReflection(ReflectionManager.FROST_LORDS_CASTLE);
					_player.setActiveReflection(ReflectionManager.FROST_LORDS_CASTLE);
					telepotToLocationPacket(remainTime);
				}
			}
			else if (_player.getRebirthCount() >= 100 && field.getFieldId() == 21) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.FAFURION_TEMPLE);
					_player.setReflection(ReflectionManager.FAFURION_TEMPLE);
					_player.setActiveReflection(ReflectionManager.FAFURION_TEMPLE);
					telepotToLocationPacket(remainTime);
				}
			}
			else if (_player.getRebirthCount() >= 100 && field.getFieldId() == 20) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.ORBIS_TEMPLE);
					_player.setReflection(ReflectionManager.ORBIS_TEMPLE);
					_player.setActiveReflection(ReflectionManager.ORBIS_TEMPLE);
					telepotToLocationPacket(remainTime);
				}
			}
			else if (_player.getRebirthCount() >= 100 && field.getFieldId() == 19) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.FAIRY_COLONY);
					_player.setReflection(ReflectionManager.FAIRY_COLONY);
					_player.setActiveReflection(ReflectionManager.FAIRY_COLONY);
					telepotToLocationPacket(remainTime);
				}
			}
			else if (_player.getRebirthCount() >= 100 && field.getFieldId() == 22) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.FOG_INSTANCE);
					_player.setReflection(ReflectionManager.FOG_INSTANCE);
					_player.setActiveReflection(ReflectionManager.FOG_INSTANCE);
					telepotToLocationPacket(remainTime);
				}
			}
			else if (_player.getRebirthCount() >= 300 && field.getFieldId() == 23) {
				if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
					_player.teleToLocation(field.getEnterLoc(), ReflectionManager.ADEN_SIEGE_INSTANCE);
					_player.setReflection(ReflectionManager.ADEN_SIEGE_INSTANCE);
					_player.setActiveReflection(ReflectionManager.ADEN_SIEGE_INSTANCE);
					telepotToLocationPacket(remainTime);
				}
			}
			//else if (_player.getRebirthCount() >= 100 && field.getFieldId() == 24) {
			//	if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
			//		_player.teleToLocation(field.getEnterLoc(), ReflectionManager.COAL_MINE);
			//		_player.setReflection(ReflectionManager.COAL_MINE);
			//		_player.setActiveReflection(ReflectionManager.COAL_MINE);
			//		telepotToLocationPacket(remainTime);
			//	}
			//}
			//else if (_player.getRebirthCount() >= 100 && field.getFieldId() == 25) {
			//	if (_player.consumeItem(field.getItemId(), field.getItemCount(), true)) {
			//		_player.teleToLocation(field.getEnterLoc(), ReflectionManager.FROZEN_CANYON);
			//		_player.setReflection(ReflectionManager.FROZEN_CANYON);
			//		_player.setActiveReflection(ReflectionManager.FROZEN_CANYON);
			//		telepotToLocationPacket(remainTime);
			//	}
			//}
			else {
				_player.sendPacket(new SystemMessagePacket(SystemMsg.COUNT_REBIRTHS_NOT_CORRESPOND_THE_ZONE_CONDITION));
			}
		} else {
			_log.info("[ExTimeRestrictFieldUserEnter]: Field id " + _fieldId + " is not found!");
		}
	}

	private void telepotToLocationPacket(int remainTime)
	{
		_player.startTimeRestrictField();
		writeC(1);
		writeD(_fieldId);
		writeD((int) (System.currentTimeMillis() / 1000));
		writeD(remainTime);
	}
}