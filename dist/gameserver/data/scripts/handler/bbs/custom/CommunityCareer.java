package handler.bbs.custom;


import java.util.StringTokenizer;

import l2s.gameserver.dao.CustomHeroDAO;
import l2s.gameserver.data.QuestHolder;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.data.htm.HtmTemplates;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.DualClass;
import l2s.gameserver.model.base.ClassId;
import l2s.gameserver.model.base.ClassLevel;
import l2s.gameserver.model.base.DualClassType;
import l2s.gameserver.model.base.Experience;
import l2s.gameserver.model.base.NobleType;
import l2s.gameserver.model.base.Race;
import l2s.gameserver.model.entity.Hero;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.ExSubjobInfo;
import l2s.gameserver.network.l2.s2c.MagicSkillUse;
import l2s.gameserver.network.l2.s2c.ShowBoardPacket;
import l2s.gameserver.network.l2.s2c.SocialActionPacket;
import l2s.gameserver.network.l2.s2c.SystemMessagePacket;
import l2s.gameserver.utils.HtmlUtils;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.TimeUtils;
import l2s.gameserver.utils.Util;

/**
 * @author Bonux
**/
public class CommunityCareer extends CustomCommunityHandler
{
	@Override
	public String[] getBypassCommands()
	{
		return new String[]
		{
			"_cbbscareer"
		};
	}

	@Override
	protected void doBypassCommand(Player player, String bypass)
	{
		StringTokenizer st = new StringTokenizer(bypass, "_");
		String cmd = st.nextToken();
		String html = "";

		if("cbbscareer".equals(cmd))
		{
			String cmd2 = st.nextToken();
			if("noble".equals(cmd2))
			{
				if(BBSConfig.NOBLE_SERVICE_COST_ITEM_ID == 0)
				{
					player.sendMessage(player.isLangRus() ? "Данный сервис отключен." : "This service disallowed.");
					player.sendPacket(ShowBoardPacket.CLOSE);
					return;
				}

				HtmTemplates tpls = HtmCache.getInstance().getTemplates("scripts/handler/bbs/pages/noble.htm", player);
				html = tpls.get(0);

				final long price = BBSConfig.NOBLE_SERVICE_COST_ITEM_COUNT;

				StringBuilder content = new StringBuilder();
				if(player.isNoble())
					content.append(tpls.get(5));
				else if(player.getDualLevel() < 85)
					content.append(tpls.get(4));
				else
				{
					if(!st.hasMoreTokens())
					{
						if(price > 0)
						{
							String priceMsg = tpls.get(1).replace("<?fee_item_count?>", Util.formatAdena(price));
							priceMsg = priceMsg.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(BBSConfig.NOBLE_SERVICE_COST_ITEM_ID));
							content.append(priceMsg);
						}
						else
							content.append(tpls.get(2));

						content.append(tpls.get(3));
					}
					else
					{
						String cmd3 = st.nextToken();
						if("buy".equals(cmd3))
						{
							if(!BBSConfig.GLOBAL_USE_FUNCTIONS_CONFIGS && !checkUseCondition(player))
							{
								onWrongCondition(player);
								return;
							}

							if(price == 0 || ItemFunctions.deleteItem(player, BBSConfig.NOBLE_SERVICE_COST_ITEM_ID, price, true))
							{
								player.setNobleType(NobleType.NORMAL);
								content.append(tpls.get(7));
							}
							else
							{
								String errorMsg = tpls.get(6).replace("<?fee_item_count?>", Util.formatAdena(price));
								errorMsg = errorMsg.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(BBSConfig.NOBLE_SERVICE_COST_ITEM_ID));
								content.append(errorMsg);
							}
						}
					}
				}
				html = html.replace("<?content?>", content.toString());
			}
			else if("noble2".equals(cmd2))
			{
				if(BBSConfig.NOBLE_SERVICE_COST_ITEM_ID_2 == 0)
				{
					player.sendMessage(player.isLangRus() ? "Данный сервис отключен." : "This service disallowed.");
					player.sendPacket(ShowBoardPacket.CLOSE);
					return;
				}

				HtmTemplates tpls = HtmCache.getInstance().getTemplates("scripts/handler/bbs/pages/noble2.htm", player);
				html = tpls.get(0);

				final long price = BBSConfig.NOBLE_SERVICE_COST_ITEM_COUNT_2;

				StringBuilder content = new StringBuilder();
				if(player.isNoble())
					content.append(tpls.get(5));
				else
				{
					if(!st.hasMoreTokens())
					{
						if(price > 0)
						{
							String priceMsg = tpls.get(1).replace("<?fee_item_count?>", Util.formatAdena(price));
							priceMsg = priceMsg.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(BBSConfig.NOBLE_SERVICE_COST_ITEM_ID_2));
							content.append(priceMsg);
						}
						else
							content.append(tpls.get(2));

						content.append(tpls.get(3));
					}
					else
					{
						String cmd3 = st.nextToken();
						if("buy2".equals(cmd3))
						{
							if(!BBSConfig.GLOBAL_USE_FUNCTIONS_CONFIGS && !checkUseCondition(player))
							{
								onWrongCondition(player);
								return;
							}

							if(price == 0 || ItemFunctions.deleteItem(player, BBSConfig.NOBLE_SERVICE_COST_ITEM_ID_2, price, true))
							{
								player.setNobleType(NobleType.NORMAL);
								content.append(tpls.get(7));
							}
							else
							{
								String errorMsg = tpls.get(6).replace("<?fee_item_count?>", Util.formatAdena(price));
								errorMsg = errorMsg.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(BBSConfig.NOBLE_SERVICE_COST_ITEM_ID_2));
								content.append(errorMsg);
							}
						}
					}
				}
				html = html.replace("<?content?>", content.toString());
			}
			else if("dualclass".equals(cmd2))
			{
				final boolean isErtheia = player.getRace() == Race.ERTHEIA;
				final int itemId = isErtheia ? BBSConfig.ERTHEIA_DUALCLASS_SERVICE_COST_ITEM_ID : BBSConfig.DUALCLASS_SERVICE_COST_ITEM_ID;
				if(itemId == 0)
				{
					player.sendMessage(player.isLangRus() ? "Данный сервис отключен." : "This service disallowed.");
					player.sendPacket(ShowBoardPacket.CLOSE);
					return;
				}

				HtmTemplates tpls = HtmCache.getInstance().getTemplates("scripts/handler/bbs/pages/dualclass.htm", player);
				html = tpls.get(0);

				final long price = isErtheia ? BBSConfig.ERTHEIA_DUALCLASS_SERVICE_COST_ITEM_COUNT : BBSConfig.DUALCLASS_SERVICE_COST_ITEM_COUNT;

				StringBuilder content = new StringBuilder();

				boolean haveDualClass = false;
				for(DualClass dual : player.getDualClassList().values())
				{
					if(dual.isDual())
					{
						haveDualClass = true;
						break;
					}
				}

				if(haveDualClass)
					content.append(tpls.get(5));
				else if(!isErtheia && (player.isBaseClassActive() || !ClassId.VALUES[player.getBaseClassId()].isOfLevel(ClassLevel.AWAKED) || player.getLevel() < 80))
					content.append(tpls.get(4));
				else if(isErtheia && (!player.isBaseClassActive() || !player.getClassId().isOfLevel(ClassLevel.THIRD) || player.getLevel() < 85))
					content.append(tpls.get(8));
				else
				{
					if(!st.hasMoreTokens())
					{
						if(price > 0)
						{
							String priceMsg = tpls.get(1).replace("<?fee_item_count?>", Util.formatAdena(price));
							priceMsg = priceMsg.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(itemId));
							content.append(priceMsg);
						}
						else
							content.append(tpls.get(2));

						content.append(tpls.get(3));
					}
					else
					{
						String cmd3 = st.nextToken();
						if("buy".equals(cmd3))
						{
							final DualClass dual = player.getActiveDualClass();
							if(dual == null)
								return;

							if(dual.isDual())
								return;

							if(price == 0 || ItemFunctions.deleteItem(player, itemId, price, true))
							{
								if(isErtheia)
								{
									сompleteQuest(10472, player);

									content.append(tpls.get(9));
								}
								else
								{
									dual.setType(DualClassType.DUAL_CLASS);

									// Для добавления дуал-класс скиллов.
									player.restoreSkills(true);
									player.sendSkillList();

									int classId = dual.getClassId();
									player.sendPacket(new SystemMessagePacket(SystemMsg.SUBCLASS_S1_HAS_BEEN_UPGRADED_TO_DUEL_CLASS_S2_CONGRATULATIONS).addClassName(classId).addClassName(classId));
									player.sendPacket(new ExSubjobInfo(player, true));
									player.broadcastPacket(new SocialActionPacket(player.getObjectId(), SocialActionPacket.LEVEL_UP));

									content.append(tpls.get(7));
								}
							}
							else
							{
								String errorMsg = tpls.get(6).replace("<?fee_item_count?>", Util.formatAdena(price));
								errorMsg = errorMsg.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(itemId));
								content.append(errorMsg);
							}
						}
					}
				}
				html = html.replace("<?content?>", content.toString());
			}
			else if("honornoble".equals(cmd2))
			{
				if(BBSConfig.HONOR_NOBLE_SERVICE_COST_ITEM_ID == 0)
				{
					player.sendMessage(player.isLangRus() ? "Данный сервис отключен." : "This service disallowed.");
					player.sendPacket(ShowBoardPacket.CLOSE);
					return;
				}

				HtmTemplates tpls = HtmCache.getInstance().getTemplates("scripts/handler/bbs/pages/honornoble.htm", player);
				html = tpls.get(0);

				final long price = BBSConfig.HONOR_NOBLE_SERVICE_COST_ITEM_COUNT;

				StringBuilder content = new StringBuilder();
				if(player.getNobleType() == NobleType.HONORABLE)
					content.append(tpls.get(5));
				else if(player.getDualLevel() < 99 || player.getNobleType() != NobleType.NORMAL)
					content.append(tpls.get(4));
				else
				{
					if(!st.hasMoreTokens())
					{
						if(price > 0)
						{
							String priceMsg = tpls.get(1).replace("<?fee_item_count?>", Util.formatAdena(price));
							priceMsg = priceMsg.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(BBSConfig.HONOR_NOBLE_SERVICE_COST_ITEM_ID));
							content.append(priceMsg);
						}
						else
							content.append(tpls.get(2));

						content.append(tpls.get(3));
					}
					else
					{
						String cmd3 = st.nextToken();
						if("buy".equals(cmd3))
						{
							if(!BBSConfig.GLOBAL_USE_FUNCTIONS_CONFIGS && !checkUseCondition(player))
							{
								onWrongCondition(player);
								return;
							}

							if(price == 0 || ItemFunctions.deleteItem(player, BBSConfig.HONOR_NOBLE_SERVICE_COST_ITEM_ID, price, true))
							{
								ItemFunctions.addItem(player, 45644, 1, true); // Почетная Тиара 
								ItemFunctions.addItem(player, 37763, 1, true);	// Почетный Плащ
								player.setNobleType(NobleType.HONORABLE);
								content.append(tpls.get(7));
							}
							else
							{
								String errorMsg = tpls.get(6).replace("<?fee_item_count?>", Util.formatAdena(price));
								errorMsg = errorMsg.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(BBSConfig.HONOR_NOBLE_SERVICE_COST_ITEM_ID));
								content.append(errorMsg);
							}
						}
					}
				}
				html = html.replace("<?content?>", content.toString());
			}
			else if("hero".equals(cmd2))
			{
				if(BBSConfig.HERO_SERVICE_COST_ITEM_ID_PER_1_DAY <= 0 && BBSConfig.HERO_SERVICE_COST_ITEM_ID_PER_FOREVER <= 0)
				{
					player.sendMessage(player.isLangRus() ? "Данный сервис отключен." : "This service disallowed.");
					player.sendPacket(ShowBoardPacket.CLOSE);
					return;
				}

				HtmTemplates tpls = HtmCache.getInstance().getTemplates("scripts/handler/bbs/pages/hero.htm", player);
				html = tpls.get(0);

				StringBuilder content = new StringBuilder();

				if(Hero.getInstance().isHero(player.getObjectId()))
					content.append(tpls.get(1));
				else if(Hero.getInstance().isInactiveHero(player.getObjectId()))
					content.append(tpls.get(2));
				else if(!player.isNoble())
					content.append(tpls.get(12));
				else
				{
					int expiryTime = CustomHeroDAO.getInstance().getExpiryTime(player.getObjectId());
					if(expiryTime != -1 && expiryTime < (System.currentTimeMillis() / 1000))
						expiryTime = (int) (System.currentTimeMillis() / 1000);

					if(!st.hasMoreTokens())
					{
						if(expiryTime == -1)
							content.append(tpls.get(3));
						else
						{
							if(expiryTime > (System.currentTimeMillis() / 1000))
							{
								String activeHero = tpls.get(4);
								activeHero = activeHero.replace("<?expire_time?>", String.valueOf(TimeUtils.toSimpleFormat(expiryTime * 1000L)));
								content.append(activeHero);
							}

							if(BBSConfig.HERO_SERVICE_COST_ITEM_ID_PER_1_DAY > 0)
							{
								for(int period : BBSConfig.HERO_SERVICE_PERIOD_VARIATIONS)
								{
									String tempBlock = tpls.get(5);
									tempBlock = tempBlock.replace("<?period?>", String.valueOf(period));

									long price = BBSConfig.HERO_SERVICE_COST_ITEM_COUNT_PER_1_DAY * period;
									if(price > 0)
									{
										String tempFeeBlock = tpls.get(10);
										tempFeeBlock = tempFeeBlock.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(BBSConfig.HERO_SERVICE_COST_ITEM_ID_PER_1_DAY));
										tempFeeBlock = tempFeeBlock.replace("<?fee_item_count?>", Util.formatAdena(price));
										tempBlock = tempBlock.replace("<?fee_block?>", tempFeeBlock);
									}
									else
										tempBlock = tempBlock.replace("<?fee_block?>", tpls.get(11));

									content.append(tempBlock);
								}
							}

							if(BBSConfig.HERO_SERVICE_COST_ITEM_ID_PER_FOREVER > 0)
							{
								String tempBlock = tpls.get(6);

								long price = BBSConfig.HERO_SERVICE_COST_ITEM_COUNT_PER_FOREVER;
								if(price > 0)
								{
									String tempFeeBlock = tpls.get(10);
									tempFeeBlock = tempFeeBlock.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(BBSConfig.HERO_SERVICE_COST_ITEM_ID_PER_FOREVER));
									tempFeeBlock = tempFeeBlock.replace("<?fee_item_count?>", Util.formatAdena(price));
									tempBlock = tempBlock.replace("<?fee_block?>", tempFeeBlock);
								}
								else
									tempBlock = tempBlock.replace("<?fee_block?>", tpls.get(11));

								content.append(tempBlock);
							}
						}
					}
					else
					{
						String cmd3 = st.nextToken();
						if("buy".equals(cmd3))
						{
							if(!st.hasMoreTokens())
								return;

							if(expiryTime == -1)
								return;

							String cmd4 = st.nextToken();
							if("unlim".equals(cmd4))
							{
								long price = BBSConfig.HERO_SERVICE_COST_ITEM_COUNT_PER_FOREVER;
								if(price <= 0 || ItemFunctions.deleteItem(player, BBSConfig.HERO_SERVICE_COST_ITEM_ID_PER_1_DAY, price, true))
								{
									CustomHeroDAO.getInstance().addCustomHero(player.getObjectId(), -1);
									if(!player.isHero())
									{
										player.setHero(true);
										player.updatePledgeRank();
										player.broadcastPacket(new SocialActionPacket(player.getObjectId(), SocialActionPacket.GIVE_HERO));
										player.checkHeroSkills();
									}
									content.append(tpls.get(9));
								}
								else
								{
									String feeInfo = tpls.get(7);
									feeInfo = feeInfo.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(BBSConfig.HERO_SERVICE_COST_ITEM_ID_PER_1_DAY));
									feeInfo = feeInfo.replace("<?fee_item_count?>", Util.formatAdena(price));
									content.append(feeInfo);
								}
							}
							else
							{
								int days = Integer.parseInt(cmd4);
								long price = BBSConfig.HERO_SERVICE_COST_ITEM_COUNT_PER_1_DAY * days;
								if(price <= 0 || ItemFunctions.deleteItem(player, BBSConfig.HERO_SERVICE_COST_ITEM_ID_PER_1_DAY, price, true))
								{
									CustomHeroDAO.getInstance().addCustomHero(player.getObjectId(), expiryTime + (days * 24 * 60 * 60));
									if(!player.isHero())
									{
										player.setHero(true);
										player.updatePledgeRank();
										player.broadcastPacket(new SocialActionPacket(player.getObjectId(), SocialActionPacket.GIVE_HERO));
										player.checkHeroSkills();
									}
									content.append(tpls.get(8));
								}
								else
								{
									String feeInfo = tpls.get(7);
									feeInfo = feeInfo.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(BBSConfig.HERO_SERVICE_COST_ITEM_ID_PER_1_DAY));
									feeInfo = feeInfo.replace("<?fee_item_count?>", Util.formatAdena(price));
									content.append(feeInfo);
								}
							}
						}
					}
				}
				html = html.replace("<?content?>", content.toString());
			}
			else if("level".equals(cmd2)) {
				if(!BBSConfig.LEVEL_SERVICE_ENABLED) {
					player.sendMessage(player.isLangRus() ? "Данный сервис отключен." : "This service disallowed.");
					player.sendPacket(ShowBoardPacket.CLOSE);
					return;
				}

				HtmTemplates tpls = HtmCache.getInstance().getTemplates("scripts/handler/bbs/pages/level.htm", player);
				html = tpls.get(0);

				final int riseItemId = BBSConfig.LEVEL_RISE_SERVICE_ITEM[player.getLevel()][0];
				final int riseItemCount = BBSConfig.LEVEL_RISE_SERVICE_ITEM[player.getLevel()][1];
				final int downItemId = BBSConfig.LEVEL_DOWN_SERVICE_ITEM[player.getLevel() - 1][0];
				final int downItemCount = BBSConfig.LEVEL_DOWN_SERVICE_ITEM[player.getLevel() - 1][1];

				StringBuilder content = new StringBuilder();
				if(player.isPK())
					content.append(tpls.get(8));
				else
				{
					if(!st.hasMoreTokens()) {
						boolean canUse = false;
						if(player.getLevel() < player.getMaxLevel()) {
							if (riseItemId > 0) {
								if (riseItemCount > 0) {
									String priceMsg = tpls.get(1).replace("<?rise_fee_item_count?>", Util.formatAdena(riseItemCount));
									priceMsg = priceMsg.replace("<?rise_fee_item_name?>", HtmlUtils.htmlItemName(riseItemId));
									priceMsg = priceMsg.replace("<?rise_level?>", String.valueOf(player.getLevel() + 1));
									content.append(priceMsg);
								} else
									content.append(tpls.get(3));

								content.append(tpls.get(5));
								canUse = true;
							}
						}

						if(canUse)
							content.append("<br><br>");

						if(player.getLevel() > 1) {
							if (downItemId > 0) {
								if (downItemCount > 0) {
									String priceMsg = tpls.get(2).replace("<?down_fee_item_count?>", Util.formatAdena(downItemCount));
									priceMsg = priceMsg.replace("<?down_fee_item_name?>", HtmlUtils.htmlItemName(downItemId));
									priceMsg = priceMsg.replace("<?down_level?>", String.valueOf(player.getLevel() - 1));
									content.append(priceMsg);
								} else
									content.append(tpls.get(4));

								content.append(tpls.get(6));
								canUse = true;
							}
						}

						if(!canUse)
							content.append(tpls.get(7));
					}
					else {
						String cmd3 = st.nextToken();
						if("rise".equals(cmd3)) {
							if(!BBSConfig.GLOBAL_USE_FUNCTIONS_CONFIGS && !checkUseCondition(player)) {
								onWrongCondition(player);
								return;
							}

							if(riseItemId == 0) {
								player.sendMessage(player.isLangRus() ? "Данный сервис отключен." : "This service disallowed.");
								player.sendPacket(ShowBoardPacket.CLOSE);
								return;
							}

							int level = player.getLevel();
							if(level == Experience.getMaxLevel()) {
								player.sendMessage(player.isLangRus() ? "Вы уже достигли последнего уровня." : "You have already reached the last level.");
								player.sendPacket(ShowBoardPacket.CLOSE);
								return;
							}

							if(riseItemCount == 0 || ItemFunctions.deleteItem(player, riseItemId, riseItemCount, true)) {
								long exp = Experience.getExpForLevel(level + 1) - player.getExp();
								player.addExpAndSp(exp, 0);
								content.append(tpls.get(10));
							}
							else {
								String errorMsg = tpls.get(9).replace("<?fee_item_count?>", Util.formatAdena(riseItemCount));
								errorMsg = errorMsg.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(riseItemId));
								content.append(errorMsg);
							}
						}
						else if("down".equals(cmd3)) {
							if(!BBSConfig.GLOBAL_USE_FUNCTIONS_CONFIGS && !checkUseCondition(player)) {
								onWrongCondition(player);
								return;
							}

							if(downItemId == 0) {
								player.sendMessage(player.isLangRus() ? "Данный сервис отключен." : "This service disallowed.");
								player.sendPacket(ShowBoardPacket.CLOSE);
								return;
							}

							int level = player.getLevel();
							if(level == 1) {
								player.sendMessage(player.isLangRus() ? "Нельзя понизить уровень ниже первого." : "You cannot lower the level below the first.");
								player.sendPacket(ShowBoardPacket.CLOSE);
								return;
							}

							if(downItemCount == 0 || ItemFunctions.deleteItem(player, downItemId, downItemCount, true)) {
								long exp = Experience.getExpForLevel(level - 1)  - player.getExp();
								player.addExpAndSp(exp, 0);
								player.broadcastPacket(new MagicSkillUse(player, player, 23128, 1, 1, 0));
								content.append(tpls.get(11));
							}
							else {
								String errorMsg = tpls.get(9).replace("<?fee_item_count?>", Util.formatAdena(riseItemCount));
								errorMsg = errorMsg.replace("<?fee_item_name?>", HtmlUtils.htmlItemName(riseItemId));
								content.append(errorMsg);
							}
						}
					}
				}
				html = html.replace("<?content?>", content.toString());
			}
		}
		ShowBoardPacket.separateAndSend(html, player);
	}

	@Override
	protected void doWriteCommand(Player player, String bypass, String arg1, String arg2, String arg3, String arg4, String arg5)
	{
		//
	}

	private static void сompleteQuest(int questId, Player player)
	{
		Quest quest = QuestHolder.getInstance().getQuest(questId);
		QuestState qs = player.getQuestState(quest.getId());
		if(qs == null)
			qs = quest.newQuestState(player);
		qs.finishQuest();
	}
}