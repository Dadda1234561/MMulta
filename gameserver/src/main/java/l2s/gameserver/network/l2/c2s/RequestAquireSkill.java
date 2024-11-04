package l2s.gameserver.network.l2.c2s;

import l2s.commons.threading.RunnableImpl;
import l2s.gameserver.Config;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.common.DifferentMethods;
import l2s.gameserver.data.xml.holder.SkillAcquireHolder;
import l2s.gameserver.model.Mods.Multiproff;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.SkillLearn;
import l2s.gameserver.model.base.AcquireType;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.templates.item.data.ItemData;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.MulticlassUtils;
import l2s.gameserver.utils.SkillUtils;

public class RequestAquireSkill extends L2GameClientPacket
{
	private AcquireType _type;
	private int _id, _level, _subUnit;

	@Override
	protected boolean readImpl()
	{
		_id = readD();
		_level = readD();
		_type = AcquireType.getById(readD());
		if(_type == AcquireType.SUB_UNIT)
			_subUnit = readD();
		return true;
	}

	@Override
	protected void runImpl()
	{
		Player player = getClient().getActiveChar();
		if(player == null || player.isTransformed() || _type == null)
			return;

		NpcInstance trainer = player.getLastNpc();
		if((trainer == null || !player.checkInteractionDistance(trainer)) && !player.isGM())
			trainer = null;

		SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, _id, _level);
		if(skillEntry == null)
			return;

		ClassId selectedMultiClassId = player.getSelectedMultiClassId();
		if(_type == AcquireType.MULTICLASS)
		{
			if(selectedMultiClassId == null)
				return;
		}
		else
			selectedMultiClassId = null;

		if(!SkillAcquireHolder.getInstance().isSkillPossible(player, selectedMultiClassId, skillEntry.getTemplate(), _type))
			return;

		SkillLearn skillLearn = SkillAcquireHolder.getInstance().getSkillLearn(player, selectedMultiClassId, _id, _level, _type);
		if(skillLearn == null)
			return;

		if(skillLearn.getMinLevel() > player.getLevel())
			return;

		if(skillLearn.getDualClassMinLvl() > player.getDualClassLevel())
			return;

		if(!checkSpellbook(player, _type, skillLearn))
		{
			player.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_THE_NECESSARY_MATERIALS_OR_PREREQUISITES_TO_LEARN_THIS_SKILL);
			return;
		}

		final int playerPing = Math.min(getClient().getLastPing() + 100, 500);

		switch(_type)
		{
			/*case NORMAL:
				learnSimpleNextLevel(player, _type, skillLearn, skillEntry, true);
				break;*/
			case NORMAL:
				if (Config.ENABLE_MULTICLASS_SKILL_LEARN /* && !player.usevoice() */) {
					if (Config.MULTICLASS_SKILL_LEVEL_MAX) {
						learnSimple(player, skillLearn, skillEntry, true);
						if (trainer != null && player.getMulticlassId() != -1) {
							ThreadPoolManager.getInstance().schedule(new RunnableImpl() {
								@Override
								public void runImpl() {
									Multiproff.showSkillListM(player, player.getMulticlassId());
								}
							}, playerPing);
						}
					} else {
						learnSimple(player, skillLearn, skillEntry, true);
						if (trainer != null && player.getMulticlassId() != -1) {
							ThreadPoolManager.getInstance().schedule(new RunnableImpl() {
								@Override
								public void runImpl() {
									Multiproff.showSkillListM(player, player.getMulticlassId());
								}
							}, playerPing);
						}
					}
				}
			case MULTICLASS:
				if (Config.ENABLE_MULTICLASS_SKILL_LEARN /* && !player.usevoice() */) {
					if (Config.MULTICLASS_SKILL_LEVEL_MAX) {
						learnSimple(player, skillLearn, skillEntry, true);
						if (trainer != null && player.getMulticlassId() != -1) {
							ThreadPoolManager.getInstance().schedule(new RunnableImpl() {
								@Override
								public void runImpl() {
									Multiproff.showSkillListM(player, player.getMulticlassId());
								}
							}, playerPing);
						}
					} else {
						learnSimple(player, skillLearn, skillEntry, true);
						if (trainer != null && player.getMulticlassId() != -1) {
							ThreadPoolManager.getInstance().schedule(new RunnableImpl() {
								@Override
								public void runImpl() {
									Multiproff.showSkillListM(player, player.getMulticlassId());
								}
							}, playerPing);
						}
					}
				}/* else if (player.usevoice()) {
					learnSimpleNextLevel(player, skillLearn, skill, true);

					IVoicedCommandHandler vc = VoicedCommandHandler.getInstance().getVoicedCommandHandler("skill");
					if (vc != null) {
						player.setInUseVoice(false);
						vc.useVoicedCommand("skill", player, "skill");
					}
				} else {
					learnSimpleNextLevel(player, skillLearn, skill, true);

					if (trainer != null) {
						trainer.showSkillList(player);
					}
				}*/
			/*case CUSTOM:
				if (Config.ENABLE_MULTICLASS_SKILL_LEARN && Config.MULTICLASS_SKILL_LEVEL_MAX) {
					learnSimple(player, skillLearn, skillEntry, false);
				} else {
					learnSimpleNextLevel(player, skillLearn, skillEntry, false);
					if (trainer != null) {
						ThreadPoolManager.getInstance().schedule(new RunnableImpl() {
							@Override
							public void runImpl() {
								Multiproff.showCustomSkillList(player);
							}
						}, playerPing);
					}
				}
				break;
			case CUSTOM1:
				if (Config.ENABLE_MULTICLASS_SKILL_LEARN && Config.MULTICLASS_SKILL_LEVEL_MAX) {
					learnSimple(player, skillLearn, skillEntry, false);
				} else {
					learnSimpleNextLevel(player, skillLearn, skillEntry, false);
					if (trainer != null) {
						ThreadPoolManager.getInstance().schedule(new RunnableImpl() {
							@Override
							public void runImpl() {
								Multiproff.showCustomSkillList1(player);
							}
						}, playerPing);
					}
				}
				break;*/
			case TRANSFORMATION:
				if(trainer != null)
				{
					//learnSimpleNextLevel(player, _type, skillLearn, skillEntry, false);
					learnSimpleNextLevel(player, skillLearn, skillEntry, false);
					trainer.showTransformationSkillList(player, AcquireType.TRANSFORMATION);
				}
				break;
			case COLLECTION:
				if(trainer != null)
				{
					//learnSimpleNextLevel(player, _type, skillLearn, skillEntry, false);
					learnSimpleNextLevel(player, skillLearn, skillEntry, false);
					NpcInstance.showCollectionSkillList(player);
				}
				break;
			case TRANSFER_CARDINAL:
			case TRANSFER_EVA_SAINTS:
			case TRANSFER_SHILLIEN_SAINTS:
				if(trainer != null)
				{
					//learnSimple(player, _type, skillLearn, skillEntry, false);
					learnSimple(player, skillLearn, skillEntry, false);
					trainer.showTransferSkillList(player);
				}
				break;
			case FISHING:
				if(trainer != null)
				{
					//learnSimpleNextLevel(player, _type, skillLearn, skillEntry, false);
					learnSimpleNextLevel(player, skillLearn, skillEntry, false);
					NpcInstance.showFishingSkillList(player);
				}
				break;
			case DUAL_CERTIFICATION:
				if(trainer != null)
				{
					if(!player.getActiveDualClass().isBase())
					{
						player.sendPacket(SystemMsg.THIS_SKILL_CANNOT_BE_LEARNED_WHILE_IN_THE_SUBCLASS_STATE);
						return;
					}
					//learnSimpleNextLevel(player, _type, skillLearn, skillEntry, false);
					learnSimpleNextLevel(player, skillLearn, skillEntry, false);
					trainer.showTransformationSkillList(player, _type);
				}
				break;
			case CHAOS:
			case DUAL_CHAOS:
				if(trainer != null)
				{
					//learnSimpleNextLevel(player, _type, skillLearn, skillEntry, false);
					learnSimpleNextLevel(player, skillLearn, skillEntry, false);
					NpcInstance.showChaosSkillList(player);
				}
				break;
			case ALCHEMY:
				if(trainer != null)
				{
					learnAlchemyNextLevel(player, skillLearn, skillEntry);
					NpcInstance.showAlchemySkillList(player);
				}
				break;
			/*case MULTICLASS:
				learnSimpleNextLevel(player, _type, skillLearn, skillEntry, true);
				MulticlassUtils.showMulticlassAcquireList(player, selectedMultiClassId);
				break;
			case CUSTOM:
				player.getListeners().onLearnCustomSkill(skillLearn);
				break;*/
		}
	}

	/**
	 * Изучение следующего возможного уровня скилла
	 */
	/*private static void learnSimpleNextLevel(Player player, AcquireType type, SkillLearn skillLearn, SkillEntry skillEntry, boolean normal)
	{
		final int skillLevel = player.getSkillLevel(skillLearn.getId(), 0);
		if(SkillUtils.getSkillLevelFromMask(skillLevel) != skillLearn.getLevel() - 1)
			return;

		learnSimple(player, type, skillLearn, skillEntry, normal);
	}*/

	private static void learnSimpleNextLevel(Player player, SkillLearn skillLearn, SkillEntry skillEntry, boolean normal)
	{
		final int skillLevel = player.getSkillLevel(skillLearn.getId(), 0);
		if(skillLevel != skillLearn.getLevel() - 1)
			return;

		learnSimple(player, skillLearn, skillEntry, normal);
	}

	private static void learnSimple(Player player, SkillLearn skillLearn, SkillEntry skill, boolean isNormal) {
		int costSP = (int) Multiproff.getCost(player, skill.getTemplate(), Config.SKILL_LEARN_COST_SP, AcquireType.NORMAL);/*skillLearn.getCost() * Config.SKILL_LEARN_COST_SP;*/

		if (player.getSp() < costSP) {
			player.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_SP_TO_LEARN_THIS_SKILL);
			return;
		}

		if (Config.ENABLE_MULTICLASS_SKILL_LEARN && player.getAllSkills().size() >= Config.ENABLE_MULTICLASS_SKILL_LEARN_MAX) {
			player.sendMessage("Вы уже выучили больше " + Config.ENABLE_MULTICLASS_SKILL_LEARN_MAX + " скилов. Больше нельзя.");
			return;
		}

		if (skillLearn.getItemId() > 0) { //Если базовый итем для изучения присутствует, то проверяем только его.
			if (!player.consumeItem(skillLearn.getItemId(), skillLearn.getItemCount(), true)) {
				player.sendPacket(SystemMsg.INCORRECT_ITEM_COUNT);
				return;
			}
		} else if (Config.ENABLE_MULTICLASS_SKILL_LEARN && !Config.ENABLE_MULTICLASS_SKILL_LEARN_ITEM.isEmpty() && isNormal) {//Если итема нет, то проверяем включена ли у нас мультипрофа и берем итем из нее
			if (player.getClassId().ordinal() != player.getMulticlassId() && player.getMulticlassId() != -1) {
				String[] items_s = Config.ENABLE_MULTICLASS_SKILL_LEARN_ITEM.split(":");
				long cout = Integer.parseInt(items_s[1]) > 1 ? Integer.parseInt(items_s[1]) : costSP;
				System.out.println("DifferentMethods");
				if (!DifferentMethods.getPay(player, Integer.parseInt(items_s[0]), cout, true))
					return;
			}
		}

		boolean hasItems = true;
		for (final ItemData additionalRequiredItem : skillLearn.getAdditionalRequiredItems()) {
			if (!DifferentMethods.getPay(player, additionalRequiredItem.getId(), additionalRequiredItem.getCount(), true)) {
				hasItems = false;
				break;
			}
		}

		if (!hasItems) {
			player.sendMessage("Нет необходимых предметов.");
			return;
		}

		player.sendPacket(new SystemMessagePacket(SystemMsg.YOU_HAVE_EARNED_S1_SKILL).addSkillName(skill.getId(), skill.getLevel()));
		player.sendPacket(new SystemMessagePacket(SystemMsg.YOUR_SP_HAS_DECREASED_BY_S1).addInteger(costSP));
		player.setSp(player.getSp() - costSP);
		player.addSkill(skill, true);
		if (isNormal) {
			player.rewardSkills(false);
		}
		player.sendUserInfo();
		player.updateStats();

		player.sendSkillList(skill.getId());

		player.updateSkillShortcuts(skill.getId(), skill.getLevel());
	}

	/*private static void learnSimple(Player player, AcquireType type, SkillLearn skillLearn, SkillEntry skillEntry, boolean normal)
	{
		if(player.getSp() < skillLearn.getCost())
		{
			player.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_SP_TO_LEARN_THIS_SKILL);
			return;
		}

		player.getInventory().writeLock();
		try
		{
			for(ItemData item : skillLearn.getRequiredItemsForLearn(type))
			{
				if(!ItemFunctions.haveItem(player, item.getId(), item.getCount()))
					return;
			}

			for(ItemData item : skillLearn.getRequiredItemsForLearn(type))
				ItemFunctions.deleteItem(player, item.getId(), item.getCount(), true);
		}
		finally
		{
			player.getInventory().writeUnlock();
		}

		player.sendPacket(new SystemMessagePacket(SystemMsg.YOU_HAVE_EARNED_S1_SKILL).addSkillName(skillEntry.getId(), skillEntry.getLevel()));

		player.setSp(player.getSp() - skillLearn.getCost());
		player.addSkill(skillEntry, true);

		if(normal)
			player.rewardSkills(false);

		player.sendUserInfo();
		player.updateStats();

		player.sendSkillList(skillEntry.getId());

		player.updateSkillShortcuts(skillEntry.getId(), skillEntry.getLevel());
	}*/

	private static void learnAlchemyNextLevel(Player player, SkillLearn skillLearn, SkillEntry skillEntry)
	{
		final int skillLevel = player.getAlchemySkillLevel(skillLearn.getId(), 0);
		if(skillLevel != skillLearn.getLevel() - 1)
			return;

		if(player.getSp() < skillLearn.getCost())
		{
			player.sendPacket(SystemMsg.YOU_DO_NOT_HAVE_ENOUGH_SP_TO_LEARN_THIS_SKILL);
			return;
		}

		player.getInventory().writeLock();
		try
		{
			for(ItemData item : skillLearn.getRequiredItemsForLearn(AcquireType.ALCHEMY))
			{
				if(!ItemFunctions.haveItem(player, item.getId(), item.getCount()))
					return;
			}

			for(ItemData item : skillLearn.getRequiredItemsForLearn(AcquireType.ALCHEMY))
				ItemFunctions.deleteItem(player, item.getId(), item.getCount(), true);
		}
		finally
		{
			player.getInventory().writeUnlock();
		}

		player.sendPacket(new SystemMessagePacket(SystemMsg.YOU_HAVE_EARNED_S1_SKILL).addSkillName(skillEntry.getId(), skillEntry.getLevel()));

		player.setSp(player.getSp() - skillLearn.getCost());
		player.addAlchemySkill(skillEntry, true);

		player.sendAlchemySkillList();
	}

	private static boolean checkSpellbook(Player player, AcquireType type, SkillLearn skillLearn)
	{
		for(ItemData item : skillLearn.getRequiredItemsForLearn(type))
		{
			if(!ItemFunctions.haveItem(player, item.getId(), item.getCount()))
				return false;
		}
		return true;
	}
}