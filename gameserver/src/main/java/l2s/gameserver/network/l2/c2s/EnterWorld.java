package l2s.gameserver.network.l2.c2s;

import java.util.Calendar;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

import l2s.commons.util.Rnd;
import l2s.gameserver.Announcements;
import l2s.gameserver.Config;
import l2s.gameserver.ThreadPoolManager;
import l2s.gameserver.dao.ItemsDAO;
import l2s.gameserver.dao.MailDAO;
import l2s.gameserver.dao.WorldExchangeManager;
import l2s.gameserver.data.QuestHolder;
import l2s.gameserver.data.string.StringsHolder;
import l2s.gameserver.data.htm.HtmCache;
import l2s.gameserver.data.xml.holder.ExperienceDataHolder;
import l2s.gameserver.data.xml.holder.ResidenceHolder;
import l2s.gameserver.data.xml.holder.SkillAcquireHolder;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.data.xml.holder.TeleportListHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.instancemanager.CoupleManager;
import l2s.gameserver.instancemanager.CursedWeaponsManager;
import l2s.gameserver.instancemanager.DailyQuestsManager;
import l2s.gameserver.instancemanager.OfflineBufferManager;
import l2s.gameserver.instancemanager.PetitionManager;
import l2s.gameserver.instancemanager.PlayerMessageStack;
import l2s.gameserver.instancemanager.RankManager;
import l2s.gameserver.listener.Acts;
import l2s.gameserver.listener.actor.player.OnAnswerListener;
import l2s.gameserver.listener.actor.player.impl.ReviveAnswerListener;
import l2s.gameserver.listener.hooks.ListenerHook;
import l2s.gameserver.listener.hooks.ListenerHookType;
import l2s.gameserver.model.*;
import l2s.gameserver.model.Mods.LilTutorialMulta.LilTutoriaMulta;
import l2s.gameserver.model.actor.CreatureSkillCast;
import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.model.actor.instances.player.AutoFarm;
import l2s.gameserver.model.actor.instances.player.ShortCut;
import l2s.gameserver.model.actor.variables.PlayerVariables;
import l2s.gameserver.model.base.Sex;
import l2s.gameserver.model.base.SoulShotType;
import l2s.gameserver.model.entity.olympiad.Olympiad;
import l2s.gameserver.model.entity.olympiad.OlympiadManager;
import l2s.gameserver.model.entity.residence.Castle;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.model.mail.Mail;
import l2s.gameserver.model.quest.Quest;
import l2s.gameserver.model.quest.QuestState;
import l2s.gameserver.network.authcomm.AuthServerCommunication;
import l2s.gameserver.network.authcomm.gs2as.ChangeAllowedHwid;
import l2s.gameserver.network.authcomm.gs2as.ChangeAllowedIp;
import l2s.gameserver.network.l2.GameClient;
import l2s.gameserver.network.l2.components.HtmlMessage;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.network.l2.s2c.*;
import l2s.gameserver.network.l2.s2c.collection.ExCollectionActiveEvent;
import l2s.gameserver.network.l2.s2c.collection.ExCollectionInfo;
import l2s.gameserver.network.l2.s2c.costume.ExSendCostumeListFull;
import l2s.gameserver.network.l2.s2c.enchant.ExEnchantChallengePointInfo;
import l2s.gameserver.network.l2.s2c.herobook.ExHeroBookInfo;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusPointInfo;
import l2s.gameserver.network.l2.s2c.homunculus.ExHomunculusReady;
import l2s.gameserver.network.l2.s2c.magiclamp.ExMagicLampExpInfo;
import l2s.gameserver.network.l2.s2c.pledge.ExPledgeCount;
import l2s.gameserver.network.l2.s2c.pledge.PledgeSkillListPacket;
import l2s.gameserver.network.l2.s2c.randomcraft.ExCraftInfo;
import l2s.gameserver.network.l2.s2c.updatetype.NpcInfoType;
import l2s.gameserver.skills.AbnormalEffect;
import l2s.gameserver.skills.SkillCastingType;
import l2s.gameserver.skills.SkillEntry;
import l2s.gameserver.skills.SkillEntryType;
import l2s.gameserver.stats.triggers.TriggerType;
import l2s.gameserver.templates.ExperienceData;
import l2s.gameserver.templates.TeleportInfo;
import l2s.gameserver.utils.GameStats;
import l2s.gameserver.utils.HtmlUtils;
import l2s.gameserver.utils.ItemFunctions;
import l2s.gameserver.utils.SkillUtils;
import l2s.gameserver.utils.TradeHelper;

import org.apache.commons.lang3.ArrayUtils;
import org.napile.primitive.pair.IntObjectPair;

public class EnterWorld extends L2GameClientPacket
{

	public static final String[] IP_LISTS = {"127.0.0.1", "178.54.181.166"};

	@Override
	protected boolean readImpl()
	{
		//readS(); - клиент всегда отправляет строку "narcasse"
		return true;
	}

	@Override
	protected void runImpl()
	{
		GameClient client = getClient();
		Player activeChar = client.getActiveChar();

		if(activeChar == null)
		{
			client.closeNow(false);
			return;
		}
		
		GameStats.incrementPlayerEnterGame();

		onEnterWorld(activeChar);
	}

	private static void onBotEnter(Player activeChar)
	{
		try {
			activeChar.setKarma(0);

			if (activeChar.isDead())
			{
				activeChar.doRevive(100.0d);
				activeChar.setCurrentCp(activeChar.getMaxCp());
				activeChar.setCurrentHpMp(activeChar.getMaxHp(), activeChar.getMaxMp());
			}

			SkillEntry entry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 7029, 4);
			if (entry != null) {
				entry.getEffects(activeChar, activeChar);
			}

			if (activeChar.getLevel() < 85)
			{
				activeChar.addExpAndSp(ExperienceDataHolder.getInstance().getData(85).getExp() - activeChar.getExp(), 0);
			}

			boolean isMage = activeChar.getClassId().isMage();
			List<SkillLearn> skillLearns = SkillAcquireHolder.getInstance().getAvailableSkillsM(isMage ? 242 : 241, activeChar).stream().filter(skillLearn -> skillLearn.getClassLevel().ordinal() <= activeChar.getClassId().getClassLevel().ordinal()).collect(Collectors.toList());
			if (!skillLearns.isEmpty()) {
				for (SkillLearn learn : skillLearns)
				{
					SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, learn.getId(), learn.getLevel());
					if (skillEntry != null) {
						SkillEntry knownSkill = activeChar.getKnownSkill(skillEntry.getId());
						if (knownSkill == null || knownSkill.getLevel() < skillEntry.getLevel()) {
							activeChar.addSkill(skillEntry, true);
						}
					}
				}
			}

			int[] skipBuffList = {1430};
			for (SkillEntry allSkill : activeChar.getAllSkills()) {
				if (!ArrayUtils.contains(skipBuffList, allSkill.getId()) && !allSkill.getTemplate().isDebuff() && allSkill.getTemplate().getEffectPoint() >= 0) {
					allSkill.getEffects(activeChar, activeChar);
				}
			}

			ThreadPoolManager.getInstance().schedule(() ->
			{
				int[] tpLocs = new int[] {28, 39,  77, 78, 101, 104, 105, 106, 107, 195};
				TeleportInfo teleportInfo = TeleportListHolder.getInstance().getTeleportInfo(Rnd.get(tpLocs));
				if (teleportInfo != null) {
					Location teleportInfoLoc = teleportInfo.getLoc();
					if (!activeChar.isInRange(teleportInfoLoc, 300)) {
						activeChar.teleToLocation(teleportInfoLoc);
//						System.out.println("Teleporting " + activeChar.getName() + " to " + teleportInfo.getId());
					}
				}
			}, 2500);

			ThreadPoolManager.getInstance().schedule(() ->
			{
				AutoFarm autoFarm = activeChar.getAutoFarm();
				autoFarm.setAutoPickUpItems(false);
				autoFarm.setTargetRaid(true);
				autoFarm.setLongAttackRange(3000);
				autoFarm.setMeleeAttackMode(false);
				autoFarm.setNextTargetMode(0);
				autoFarm.setFarmActivate(true);
				autoFarm.doAutoFarm();

//				activeChar.getFlags().getInvulnerable().start();
//				activeChar.getAbnormalEffects().add(AbnormalEffect.INVINCIBILITY);
//				activeChar.broadcastCharInfo();

			}, 3000);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void onEnterWorld(Player activeChar)
	{
		boolean first = activeChar.entering;

//		if (ArrayUtils.contains(IP_LISTS, activeChar.getIP()))
//		{
//			onBotEnter(activeChar);
//		}

		activeChar.sendItemList(false);
		activeChar.sendPacket(new ExAdenaInvenCount(activeChar));
		activeChar.sendPacket(new ShortCutInitPacket(activeChar));
		activeChar.sendPacket(new ExBasicActionList(activeChar));

		activeChar.sendPacket(ExLightingCandleEvent.DISABLED);
		//TODO: activeChar.sendPacket(new ExChannlChatEnterWorld(activeChar));
		//TODO: activeChar.sendPacket(new ExChannlChatPlegeInfo(activeChar));
		activeChar.sendPacket(new ExEnterWorldPacket());
		activeChar.sendPacket(new ExItemDeletionInfo());
		activeChar.sendPacket(new ExPeriodicHenna(activeChar));
		activeChar.sendAbilitiesInfo();
		activeChar.sendPacket(new HennaInfoPacket(activeChar));
		activeChar.setLearnSkillMaxLevel(activeChar.getVarBoolean("learnMaxLevel")); // DM learMaxLevel
		activeChar.setChampionLvlChange(activeChar.getVarInt(PlayerVariables.CHAMPION_LVL_CHANGE, 0));
		activeChar.setUpMonsterChange(activeChar.getVarInt(PlayerVariables.CHANGE_UP_MONSTER_LVL, 0));
		//activeChar.setRangeCfg(activeChar.getVarInt("setRangeCfg", 1000));
		List<Castle> castleList = ResidenceHolder.getInstance().getResidenceList(Castle.class);
		for(Castle c : castleList)
			activeChar.sendPacket(new ExCastleState(c));

		activeChar.sendSkillList();
		activeChar.sendPacket(new EtcStatusUpdatePacket(activeChar));
		if (activeChar.getTemplate() != null && activeChar.getVisualRace() != null) {
			double collisionRadius = 7.0;
			double collisionHeight = 22.0;

			switch (activeChar.getVisualRace()) {
				case HUMAN:
					if (activeChar.isMageClass()) {
						collisionRadius = activeChar.getSex() == Sex.MALE ? 7.5 : 6.5;
						collisionHeight = activeChar.getSex() == Sex.MALE ? 22.8 : 22.5;
					} else {
						collisionRadius = activeChar.getSex() == Sex.MALE ? 9.0 : 8.0;
						collisionHeight = activeChar.getSex() == Sex.MALE ? 23.0 : 23.5;
					}
					break;
				case ELF:
				case DARKELF:
					collisionRadius = 7.5;
					collisionHeight = activeChar.getSex() == Sex.MALE ? 24.0 : activeChar.isMageClass() ? 23.0 : 23.5;
					break;
				case ORC:
					if (activeChar.isMageClass()) {
						collisionRadius = activeChar.getSex() == Sex.MALE ? 7.0 : 8.0;
						collisionHeight = activeChar.getSex() == Sex.MALE ? 27.5 : 25.5;
					} else {
						collisionRadius = activeChar.getSex() == Sex.MALE ? 11.0 : 7.0;
						collisionHeight = activeChar.getSex() == Sex.MALE ? 28.0 : 27.0;
					}
					break;
				case ERTHEIA:
					collisionRadius = 6.0;
					collisionHeight = 19.0;
					break;
				case KAMAEL:
					if (activeChar.isMageClass()) {
						collisionRadius = activeChar.getSex() == Sex.MALE ? 8.0 : 7.0;
						collisionHeight = activeChar.getSex() == Sex.MALE ? 25.2 : 22.6;
					} else {
						collisionRadius = activeChar.getSex() == Sex.MALE ? 8.0 : 7.0;
						collisionHeight = activeChar.getSex() == Sex.MALE ? 25.2 : 22.6;
					}
					break;
				case DWARF:
					collisionRadius = 9.0;
					collisionHeight = activeChar.isMageClass() ? 18.0 : activeChar.getSex() == Sex.MALE ? 18.0 : 19.0;
					break;
			}

			activeChar.getTemplate().setCollisionRadius(collisionRadius);
			activeChar.getTemplate().setCollisionHeight(collisionHeight);
		}
		activeChar.broadcastUserInfo(true);

		activeChar.sendPacket(new UIPacket(activeChar));
		activeChar.sendPacket(new ExUserInfoInvenWeight(activeChar));
		activeChar.sendPacket(new ExUserInfoEquipSlot(activeChar));
		activeChar.sendPacket(new ExUserInfoCubic(activeChar));
		activeChar.sendPacket(new ExUserInfoAbnormalVisualEffect(activeChar));

		activeChar.sendPacket(SystemMsg.WELCOME_TO_THE_WORLD_OF_LINEAGE_II);

		double mpCostDiff = activeChar.getMPCostDiff(Skill.SkillMagicType.PHYSIC);
		if(mpCostDiff != 0)
			activeChar.sendPacket(new ExChangeMPCost(Skill.SkillMagicType.PHYSIC, mpCostDiff));

		mpCostDiff = activeChar.getMPCostDiff(Skill.SkillMagicType.MAGIC);
		if(mpCostDiff != 0)
			activeChar.sendPacket(new ExChangeMPCost(Skill.SkillMagicType.MAGIC, mpCostDiff));

		mpCostDiff = activeChar.getMPCostDiff(Skill.SkillMagicType.MUSIC);
		if(mpCostDiff != 0)
			activeChar.sendPacket(new ExChangeMPCost(Skill.SkillMagicType.MUSIC, mpCostDiff));

		activeChar.sendPacket(new QuestListPacket(activeChar));
		activeChar.initActiveAutoShots();
		activeChar.sendPacket(new ExGetBookMarkInfoPacket(activeChar));
		
		activeChar.getMacroses().sendMacroses();

		Announcements.getInstance().showAnnouncements(activeChar);

		WorldExchangeManager.getInstance().checkPlayerSellAlarm(activeChar);

		if(first)
		{
			activeChar.setOnlineStatus(true);
			if(activeChar.getPlayerAccess().GodMode && !Config.SHOW_GM_LOGIN && !Config.EVERYBODY_HAS_ADMIN_RIGHTS)
			{
				activeChar.setGMInvisible(true);
				activeChar.startAbnormalEffect(AbnormalEffect.STEALTH);
			}

			activeChar.setNonAggroTime(Long.MAX_VALUE);
			activeChar.setNonPvpTime(System.currentTimeMillis() + Config.NONPVP_TIME_ONTELEPORT);

			if(activeChar.isInBuffStore())
			{
				activeChar.setPrivateStoreType(Player.STORE_PRIVATE_NONE);
			}
			else if(activeChar.isInStoreMode())
			{
				if(!TradeHelper.validateStore(activeChar))
				{
					activeChar.setPrivateStoreType(Player.STORE_PRIVATE_NONE);
					activeChar.storePrivateStore();
				}
			}

			activeChar.setRunning();
			activeChar.standUp();
			activeChar.spawnMe();
			activeChar.startTimers();

			DailyQuestsManager.checkAndRemoveDisabledQuests(activeChar);
		}

		if (activeChar.isOnline() && Config.AGGRO_IF_PLAYER_IS_ONLINE)
		{
			ThreadPoolManager.getInstance().schedule(activeChar::setActive, Config.AGGRO_TIME_IF_PLAYER_IN_ONLINE, TimeUnit.SECONDS);
		}

		activeChar.setKarma(activeChar.getKarma());

		activeChar.sendPacket(new ExBloodyCoinCount(activeChar));
		activeChar.sendPacket(new ExVitalityEffectInfo(activeChar));
		activeChar.sendPacket(new ExBR_PremiumStatePacket(activeChar, activeChar.hasPremiumAccount()));
		activeChar.sendPacket(new ExFactionInfo(activeChar.getObjectId(), 0));

		activeChar.sendPacket(new ExSetCompassZoneCode(activeChar));
		activeChar.sendPacket(new ExRaidBossSpawnInfo(activeChar));

		//TODO: Исправить посылаемые данные.
		activeChar.sendPacket(new MagicAndSkillList(activeChar, 3503292, 730502));
		activeChar.sendPacket(new ExStorageMaxCountPacket(activeChar));
		activeChar.sendPacket(new ExVoteSystemInfoPacket(activeChar));
		activeChar.sendPacket(new ExBeautyItemList(activeChar));
		activeChar.getAttendanceRewards().onEnterWorld();
		activeChar.sendPacket(new ExReceiveShowPostFriend(activeChar));

		if(Config.ALLOW_WORLD_CHAT)
			activeChar.sendPacket(new ExWorldChatCnt(activeChar));

		if(Config.EX_USE_PRIME_SHOP)
			activeChar.sendPacket(ExBR_NewIConCashBtnWnd.HAS_UPDATES);	// TODO: Посылать при наличии новинок в Итем-молле 1, если нет, то 0.

		if (Config.RANDOM_CRAFT_SYSTEM_ENABLED)
			activeChar.sendPacket(new ExCraftInfo(activeChar));

		checkNewMail(activeChar);

		if(first)
			activeChar.getListeners().onEnter();

		if(first && activeChar.getCreateTime() > 0)
		{
			Calendar create = Calendar.getInstance();
			create.setTimeInMillis(activeChar.getCreateTime());
			Calendar now = Calendar.getInstance();

			int day = create.get(Calendar.DAY_OF_MONTH);
			if(create.get(Calendar.MONTH) == Calendar.FEBRUARY && day == 29)
				day = 28;

			int myBirthdayReceiveYear = activeChar.getVarInt(Player.MY_BIRTHDAY_RECEIVE_YEAR, 0);
			if(create.get(Calendar.MONTH) == now.get(Calendar.MONTH) && create.get(Calendar.DAY_OF_MONTH) == day)
			{
				if((myBirthdayReceiveYear == 0 && create.get(Calendar.YEAR) != now.get(Calendar.YEAR)) || myBirthdayReceiveYear > 0 && myBirthdayReceiveYear != now.get(Calendar.YEAR))
				{
					Mail mail = new Mail();
					mail.setSenderId(1);
					mail.setSenderName(StringsHolder.getInstance().getString(activeChar, "birthday.npc"));
					mail.setReceiverId(activeChar.getObjectId());
					mail.setReceiverName(activeChar.getName());
					mail.setTopic(StringsHolder.getInstance().getString(activeChar, "birthday.title"));
					mail.setBody(StringsHolder.getInstance().getString(activeChar, "birthday.text"));

					ItemInstance item = ItemFunctions.createItem(21169);
					item.setLocation(ItemInstance.ItemLocation.MAIL);
					item.setCount(1L);
					item.save();

					mail.addAttachment(item);
					mail.setUnread(true);
					mail.setType(Mail.SenderType.BIRTHDAY);
					mail.setExpireTime(720 * 3600 + (int) (System.currentTimeMillis() / 1000L));
					mail.save();

					activeChar.setVar(Player.MY_BIRTHDAY_RECEIVE_YEAR, String.valueOf(now.get(Calendar.YEAR)), -1);
				}
			}
		}

		activeChar.checkAndDeleteOlympiadItems();

		if(activeChar.getClan() != null)
		{
			activeChar.getClan().loginClanCond(activeChar, true);

			activeChar.sendPacket(activeChar.getClan().listAll());
			activeChar.sendPacket(new PledgeSkillListPacket(activeChar.getClan()));
		}
		else
			activeChar.sendPacket(new ExPledgeCount(0));

		// engage and notify Partner
		if(first && Config.ALLOW_WEDDING)
		{
			CoupleManager.getInstance().engage(activeChar);
			CoupleManager.getInstance().notifyPartner(activeChar);
		}

		if(first)
		{
			activeChar.getFriendList().notifyFriends(true);
			//activeChar.restoreDisableSkills(); Зачем дважды ресторить откат скиллов?
			activeChar.mentoringLoginConditions();
		}

		activeChar.checkHpMessages(activeChar.getMaxHp(), activeChar.getCurrentHp());
		activeChar.checkDayNightMessages();

		if(Config.SHOW_HTML_WELCOME)
		{
			String html = HtmCache.getInstance().getHtml("welcome.htm", activeChar);
			HtmlMessage msg = new HtmlMessage(5);
			msg.setHtml(HtmlUtils.bbParse(html));
			activeChar.sendPacket(msg);
		}

		if(Config.PETITIONING_ALLOWED)
			PetitionManager.getInstance().checkPetitionMessages(activeChar);

		if(!first)
		{
			CreatureSkillCast skillCast = activeChar.getSkillCast(SkillCastingType.NORMAL);
			if(skillCast.isCastingNow())
			{
				Creature castingTarget = skillCast.getTarget();
				SkillEntry castingSkillEntry = skillCast.getSkillEntry();
				long animationEndTime = skillCast.getAnimationEndTime();
				if(castingSkillEntry != null && !castingSkillEntry.getTemplate().isNotBroadcastable() && castingTarget != null && castingTarget.isCreature() && animationEndTime > 0)
					activeChar.sendPacket(new MagicSkillUse(activeChar, castingTarget, castingSkillEntry.getId(), castingSkillEntry.getLevel(), (int) (animationEndTime - System.currentTimeMillis()), 0, SkillCastingType.NORMAL));
			}

			skillCast = activeChar.getSkillCast(SkillCastingType.NORMAL_SECOND);
			if(skillCast.isCastingNow())
			{
				Creature castingTarget = skillCast.getTarget();
				SkillEntry castingSkillEntry = skillCast.getSkillEntry();
				long animationEndTime = skillCast.getAnimationEndTime();
				if(castingSkillEntry != null && !castingSkillEntry.getTemplate().isNotBroadcastable() && castingTarget != null && castingTarget.isCreature() && animationEndTime > 0)
					activeChar.sendPacket(new MagicSkillUse(activeChar, castingTarget, castingSkillEntry.getId(), castingSkillEntry.getLevel(), (int) (animationEndTime - System.currentTimeMillis()), 0, SkillCastingType.NORMAL_SECOND));
			}

			if(activeChar.isInBoat())
				activeChar.sendPacket(activeChar.getBoat().getOnPacket(activeChar, activeChar.getInBoatPosition()));

			if(activeChar.getMovement().isMoving() || activeChar.getMovement().isFollow())
				activeChar.sendPacket(activeChar.movePacket());

			if(activeChar.getMountNpcId() != 0)
				activeChar.sendPacket(new RidePacket(activeChar));

			if(activeChar.isFishing())
				activeChar.getFishing().stop();
		}

		activeChar.entering = false;

		if(activeChar.isSitting())
			activeChar.sendPacket(new ChangeWaitTypePacket(activeChar, ChangeWaitTypePacket.WT_SITTING));
		if(activeChar.isInStoreMode())
			activeChar.sendPacket(activeChar.getPrivateStoreMsgPacket(activeChar));

		activeChar.unsetVar("offline");
		activeChar.unsetVar("offlinebuff");
		activeChar.unsetVar("offlinebuff_price");
		activeChar.unsetVar("offlinebuff_itemid");
		activeChar.unsetVar("offlinebuff_skills");
		activeChar.unsetVar("offlinebuff_title");

		OfflineBufferManager.getInstance().getBuffStores().remove(activeChar.getObjectId());

		// на всякий случай
		activeChar.sendActionFailed();

		activeChar.sendPacket(new ExConnectedTimeAndGettableReward(activeChar));
		activeChar.sendPacket(new ExOneDayReceiveRewardList(activeChar));

		if(first && activeChar.isGM() && Config.SAVE_GM_EFFECTS && activeChar.getPlayerAccess().CanUseGMCommand)
		{
			//silence
			if(activeChar.getVarBoolean("gm_silence"))
			{
				activeChar.setMessageRefusal(true);
				activeChar.sendPacket(SystemMsg.MESSAGE_REFUSAL_MODE);
			}
			//invul
			if(activeChar.getVarBoolean("gm_invul"))
			{
				activeChar.getFlags().getInvulnerable().start();
				activeChar.getFlags().getDebuffImmunity().start();
				activeChar.startAbnormalEffect(AbnormalEffect.INVINCIBILITY);
				activeChar.sendMessage(activeChar.getName() + " is now immortal.");
			}
			//undying
			if(activeChar.getVarBoolean("gm_undying"))
			{
				activeChar.setGMUndying(true);
				activeChar.sendMessage("Undying state has been enabled.");
			}
			//gmspeed
			activeChar.setGmSpeed(activeChar.getVarInt("gm_gmspeed", 0));
		}

		PlayerMessageStack.getInstance().CheckMessages(activeChar);

		IntObjectPair<OnAnswerListener> entry = activeChar.getAskListener(false);
		if(entry != null && entry.getValue() instanceof ReviveAnswerListener)
			activeChar.sendPacket(new ConfirmDlgPacket(SystemMsg.C1_IS_MAKING_AN_ATTEMPT_TO_RESURRECT_YOU_IF_YOU_CHOOSE_THIS_PATH_S2_EXPERIENCE_WILL_BE_RETURNED_FOR_YOU, 0).addString("Other player").addString("some"));

		if(activeChar.isCursedWeaponEquipped())
			CursedWeaponsManager.getInstance().showUsageTime(activeChar, activeChar.getCursedWeaponEquippedId());

		if(!first)
		{
			//Персонаж вылетел во время просмотра
			if(activeChar.isInObserverMode())
			{
				if(activeChar.getObserverMode() == Player.OBSERVER_LEAVING)
					activeChar.returnFromObserverMode();
				else
					activeChar.leaveObserverMode();
			}
			else if(activeChar.isVisible())
				World.showObjectsToPlayer(activeChar);

			final List<Servitor> servitors = activeChar.getServitors();

			for(Servitor servitor : servitors)
				activeChar.sendPacket(new MyPetSummonInfoPacket(servitor));

			if(activeChar.isInParty())
			{
				Party party = activeChar.getParty();
				Player leader = party.getPartyLeader();
				if(leader != null) // некрасиво, но иначе NPE.
				{
					//sends new member party window for all members
					//we do all actions before adding member to a list, this speeds things up a little
					activeChar.sendPacket(new PartySmallWindowAllPacket(party, leader, activeChar));

					RelationChangedPacket rcp = new RelationChangedPacket();
					for(Player member : party.getPartyMembers())
					{
						if(member != activeChar)
						{
							activeChar.sendPacket(new PartySpelledPacket(member, true));

							for(Servitor servitor : servitors)
								activeChar.sendPacket(new PartySpelledPacket(servitor, true));

							rcp.add(member, activeChar);
							for(Servitor servitor : member.getServitors())
								rcp.add(servitor, activeChar);

							for(Servitor servitor : servitors)
								servitor.broadcastCharInfoImpl(activeChar, NpcInfoType.VALUES);
						}
					}

					activeChar.sendPacket(rcp);

					// Если партия уже в СС, то вновь прибывшем посылаем пакет открытия окна СС
					if(party.isInCommandChannel())
						activeChar.sendPacket(ExOpenMPCCPacket.STATIC);
				}
			}

			activeChar.sendPacket(new ExEnchantChallengePointInfo());

			activeChar.sendActiveAutoShots();

			for(Abnormal e : activeChar.getAbnormalList())
			{
				if(e.getSkill().isToggle() && !e.getSkill().isNotBroadcastable())
					activeChar.sendPacket(new MagicSkillLaunchedPacket(activeChar.getObjectId(), e.getSkill().getId(), e.getSkill().getLevel(), activeChar, SkillCastingType.NORMAL));
			}

			activeChar.broadcastCharInfo();
		}
		
		//activeChar.updateSymbolSealSkills();
		for (int i = 1; i < 8; i++)
		{
			activeChar.sendPacket(new ExCollectionInfo(activeChar, i));
		}
		activeChar.sendPacket(new ExCollectionActiveEvent());
		if (Olympiad.inCompPeriod()) {
			activeChar.sendPacket(new ExOlympiadInfo(0, 0));
		}

		if (Config.HOMUNCULUS_INFO_ENABLE) {
			activeChar.sendPacket(new ExHomunculusPointInfo(activeChar));
			activeChar.sendPacket(new ExHomunculusReady(true));
		}

		if (Config.HERO_BOOK_INFO_ENABLE) {
			activeChar.sendPacket(new ExHeroBookInfo(activeChar.getHeroBookProgress()));
		}

		if (Config.COSTUME_SERIVCE_ENABLE) {
			activeChar.sendPacket(new ExSendCostumeListFull());
		}

		// Reset gear score ui info
		activeChar.sendPacket(new ExItemScore(0));

		if (activeChar.getVarBoolean(PlayerVariables.FIRST_ENTER_WORLD, true))
		{
			//activeChar.sendPacket(UsmVideo.ANTHARAS.packet(activeChar));
			activeChar.setVar(PlayerVariables.FIRST_ENTER_WORLD, false);
		}

		if(activeChar.isDead())
			activeChar.sendPacket(new DiePacket(activeChar));


		activeChar.updateAbnormalIcons();
		activeChar.updateStats();
		activeChar.updateUserBonus();
		activeChar.updateStatBonus();
		// update gear score ui info
		activeChar.refreshGearScore(true, true);

		LilTutoriaMulta.info(activeChar);

		if(Config.ALT_PCBANG_POINTS_ENABLED)
		{
			if(!Config.ALT_PCBANG_POINTS_ONLY_PREMIUM || activeChar.hasPremiumAccount())
				activeChar.sendPacket(new ExPCCafePointInfoPacket(activeChar, 0, 1, 2, 12));
		}

		if(!activeChar.getPremiumItemList().isEmpty())
			activeChar.sendPacket(ExNotifyPremiumItem.STATIC);

		activeChar.checkLevelUpReward(true);
		activeChar.sendClassChangeAlert();

		if(first)
		{
			activeChar.useTriggers(activeChar, TriggerType.ON_ENTER_WORLD, null, null, 0);

			for(ListenerHook hook : ListenerHook.getGlobalListenerHooks(ListenerHookType.PLAYER_ENTER_GAME))
				hook.onPlayerEnterGame(activeChar);

			if(Config.ALLOW_IP_LOCK && Config.AUTO_LOCK_IP_ON_LOGIN)
				AuthServerCommunication.getInstance().sendPacket(new ChangeAllowedIp(activeChar.getAccountName(), activeChar.getIP()));

			if(Config.ALLOW_HWID_LOCK && Config.AUTO_LOCK_HWID_ON_LOGIN)
			{
				GameClient client = activeChar.getNetConnection();
				if(client != null)
					AuthServerCommunication.getInstance().sendPacket(new ChangeAllowedHwid(activeChar.getAccountName(), client.getHWID()));
			}
		}
		RankManager.getInstance().onPlayerEnter(activeChar);

		activeChar.getInventory().checkItems();

		int auctionItemObjectId = activeChar.getVarInt(Acts.RARE_AUCTION_PARTICIPATION_ACT, 0);
		if (auctionItemObjectId != 0) {
			ItemInstance auctionItem = ItemsDAO.getInstance().load(auctionItemObjectId);
			activeChar.getListeners().onAct(Acts.RARE_AUCTION_PARTICIPATION_ACT, auctionItem, false);
			activeChar.unsetVar(Acts.RARE_AUCTION_PARTICIPATION_ACT);
		}

		if (Config.MAGIC_LAMP_ENABLED)
			activeChar.sendPacket(new ExMagicLampExpInfo(true, activeChar));

		if(Config.ALLOW_CLASSIC_AUTO_SHOTS){
			ItemInstance soulShot = activeChar.getInventory().getItemByItemId(22086);
			ItemInstance blessSpiritShot = activeChar.getInventory().getItemByItemId(3952);

			if(soulShot != null) {
				activeChar.activateSoulShots(22086, SoulShotType.SOULSHOT);
				activeChar.addAutoShot(22086, true, SoulShotType.SOULSHOT);
				activeChar.sendPacket(new ExAutoSoulShot(22086, 3, SoulShotType.SOULSHOT));
			}
			if(blessSpiritShot != null) {
				activeChar.activateSoulShots(3952, SoulShotType.SPIRITSHOT);
				activeChar.addAutoShot(3952, true, SoulShotType.SPIRITSHOT);
				activeChar.sendPacket(new ExAutoSoulShot(3952, 3, SoulShotType.SPIRITSHOT));
			}
			activeChar.sendItemList(false);
		}

		if(activeChar.getQuestState(30) == null){
			Quest quest = QuestHolder.getInstance().getQuest(30);
			QuestState qs = quest.newQuestState(activeChar);
			ThreadPoolManager.getInstance().schedule(() ->
			{
				qs.setCond(1, true);
			}, 1500);

		}
	}

	private static void checkNewMail(Player activeChar)
	{
		activeChar.sendPacket(new ExUnReadMailCount(activeChar));
		for(Mail mail : MailDAO.getInstance().getReceivedMailByOwnerId(activeChar.getObjectId()))
		{
			if(mail.isUnread())
			{
				activeChar.sendPacket(ExNoticePostArrived.STATIC_FALSE);
				break;
			}
		}
	}
}