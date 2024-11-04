//================================================================================
// UIEventManager.
//================================================================================

class UIEventManager extends Interactions
	native
	dynamicrecompile;

const MAX_PartyMemberCount = 9;
const CREATE_ON_DEMAND = 1;
const EV_UI_Internal_Event = 5;
const EV_Test = 10;
const EV_Test_1 = 11;
const EV_Test_2 = 12;
const EV_Test_3 = 13;
const EV_Test_4 = 14;
const EV_Test_5 = 15;
const EV_Test_6 = 16;
const EV_Test_7 = 17;
const EV_Test_8 = 18;
const EV_Test_9 = 19;
const EV_Paste = 20;
const EV_Restart = 40;
const EV_Die = 50;
const EV_CardKeyLogin = 60;
const EV_RegenStatus = 70;
const EV_RadarTransitionFinished = 80;
const EV_ShortcutCommand = 90;
const EV_ShortcutCommandSlot = 91;
const EV_MagicSkillList = 100;
const EV_SetRadarZoneCode = 110;
const EV_RaidRecord = 120;
const EV_ShowGuideWnd = 130;
const EV_ShowScreenMessage = 140;
const EV_ShowScreenNPCZoomMessage = 141;
const EV_GamingStateEnter = 150;
const EV_GamingStateExit = 160;
const EV_GamingStatePreExit = 161;
const EV_ServerAgeLimitChange = 170;
const EV_UpdateUserInfo = 180;
const EV_UpdateUserEquipSlotInfo = 181;
const EV_PreUpdateUserInfo = 182;
const EV_UpdateHP = 190;
const EV_UpdateMyHP = 191;
const EV_UpdateMaxHP = 200;
const EV_UpdateMyMaxHP = 201;
const EV_UpdateMP = 210;
const EV_UpdateMyMP = 211;
const EV_UpdateMaxMP = 220;
const EV_UpdateMyMaxMP = 221;
const EV_UpdateCP = 230;
const EV_UpdateMyCP = 231;
const EV_UpdateMaxCP = 240;
const EV_UpdateMyMaxCP = 241;
const EV_UpdateMyDP = 245;
const EV_UpdateMyMaxDP = 246;
const EV_UpdateMyBP = 247;
const EV_UpdateMyMaxBP = 248;
const EV_UpdatePetInfo = 250;
const EV_UpdateSummonInfo = 251;
const EV_UpdateHennaInfo = 260;
const EV_ReceiveAttack = 280;
const EV_ReceiveMagicSkillUse = 290;
const EV_ReceiveTargetLevelDiff = 300;
const EV_ShowReplayQuitDialogBox = 310;
const EV_ClanInfo = 320;
const EV_ClanInfoUpdate = 330;
const EV_ClanMyAuth = 340;
const EV_ClanAuthGradeList = 350;
const EV_ClanCrestChange = 360;
const EV_ClanAuth = 370;
const EV_ClanAuthMember = 380;
const EV_ClanAddMember = 400;
const EV_ClanAddMemberMultiple = 410;
const EV_ClanDeleteAllMember = 420;
const EV_ClanMemberInfo = 430;
const EV_ClanMemberInfoUpdate = 440;
const EV_ClanDeleteMember = 450;
const EV_ClanWarList = 460;
const EV_ClanClearWarList = 470;
const EV_ClanSubClanUpdated = 480;
const EV_ClanSkillList = 490;
const EV_ClanSkillListRenew = 500;
const EV_MinFrameRateChanged = 510;
const EV_PartyMemberChanged = 520;
const EV_ShowPCCafeCouponUI = 530;
const EV_ToggleShowPCCafeEventWnd = 531;
const EV_ChatMessage = 540;
const EV_ReceiveChatMessage = 541;
const EV_GFxScrMessage = 542;
const EV_ChatWndStatusChange = 550;
const EV_ChatWndOnResize = 555;
const EV_ChatWndSetString = 560;
const EV_ChatWndSetFocus = 570;
const EV_ChatWndMsnStatus = 571;
const EV_ChatWndMacroCommand = 572;
const EV_SystemMessage = 580;
const EV_MessageWndString = 581;
const EV_JoypadLButtonDown = 590;
const EV_JoypadLButtonUp = 600;
const EV_JoypadRButtonDown = 610;
const EV_JoypadRButtonUp = 620;
const EV_ShortcutUpdate = 630;
const EV_ShortcutSkillListUpdate = 631;
const EV_ShortcutPageUpdate = 640;
const EV_ShortcutClear = 650;
const EV_ShortcutJoypad = 660;
const EV_ShortcutPageDown = 670;
const EV_ShortcutPageUp = 680;
const EV_ShowShortcutWnd = 690;
const EV_ShortcutInit = 691;
const EV_ShortcutDataReceived = 692;
const EV_ShortcutKeyAssignChanged = 693;
const EV_ShortcutAutomaticUseActivated = 694;
const EV_QuestListStart = 700;
const EV_QuestList = 710;
const EV_QuestListEnd = 720;
const EV_QuestSetCurrentID = 730;
const EV_SSQStatus = 740;
const EV_SSQMainEvent = 750;
const EV_SSQSealStatus = 760;
const EV_SSQPreInfo = 770;
const EV_RecipeShowBuyListWnd = 780;
const EV_RecipeShopSellItem = 790;
const EV_RecipeShopItemInfo = 800;
const EV_RecipeShowRecipeTreeWnd = 810;
const EV_RecipeShowBookWnd = 820;
const EV_RecipeAddBookItem = 830;
const EV_RecipeItemMakeInfo = 840;
const EV_RecipeShopShowWnd = 850;
const EV_RecipeShopAddBookItem = 860;
const EV_RecipeShopAddShopItem = 870;
const EV_HeroShowList = 880;
const EV_HeroRecord = 890;
const EV_OlympiadTargetShow = 900;
const EV_OlympiadMatchEnd = 910;
const EV_OlympiadUserInfo = 920;
const EV_OlympiadBuffShow = 930;
const EV_OlympiadBuffInfo = 940;
const EV_AbnormalStatusNormalItem = 950;
const EV_AbnormalStatusEtcItem = 960;
const EV_AbnormalStatusShortItem = 970;
const EV_TargetUpdate = 980;
const EV_TargetSkillInfo = 981;
const EV_TargetSkillCancel = 982;
const EV_TargetHideWindow = 990;
const EV_ShowBuffIcon = 1000;
const EV_PetWndShow = 1010;
const EV_PetWndShowNameBtn = 1020;
const EV_PetWndRegPetNameFailed = 1030;
const EV_PetStatusShow = 1040;
const EV_PetStatusSpelledList = 1050;
const EV_PetStatusSpelledListDelete = 1052;
const EV_PetStatusSpelledListInsert = 1053;
const EV_PetInventoryItemStart = 1060;
const EV_PetInventoryItemList = 1070;
const EV_PetInventoryItemUpdate = 1080;
const EV_SummonedWndShow = 1090;
const EV_SummonedStatusShow = 1100;
const EV_SummonedStatusSpelledList = 1110;
const EV_SummonedStatusSpelledListDelete = 1112;
const EV_SummonedStatusSpelledListInsert = 1113;
const EV_SummonedStatusRemainTime = 1120;
const EV_PetStatusClose = 1130;
const EV_SummonedStatusClose = 1131;
const EV_SummonedDelete = 1132;
const EV_PartyAddParty = 1140;
const EV_PartyUpdateParty = 1150;
const EV_PartyDeleteParty = 1160;
const EV_PartyDeleteAllParty = 1170;
const EV_PartySpelledList = 1180;
const EV_PartyRenameMember = 1181;
const EV_PartySpelledListDelete = 1182;
const EV_PartySpelledListInsert = 1183;
const EV_ShowBBS = 1190;
const EV_ShowBoardPacket = 1200;
const EV_ShowHelp = 1210;
const EV_LoadHelpHtml = 1220;
const EV_LoadPetitionHtml = 1221;
const EV_MacroShowListWnd = 1230;
const EV_MacroUpdate = 1240;
const EV_MacroList = 1250;
const EV_MacroShowEditWnd = 1260;
const EV_MacroDeleted = 1270;
const EV_SkillListStart = 1280;
const EV_SkillList = 1290;
const EV_SkillListEnd = 1291;
const EV_ActionListStart = 1300;
const EV_ActionList = 1310;
const EV_ActionListNew = 1311;
const EV_ActionPetListStart = 1320;
const EV_ActionPetList = 1330;
const EV_ActionSummonedCommonListStart = 1340;
const EV_ActionSummonedCommonList = 1350;
const EV_ActionSummonedAllSkillListStart = 1351;
const EV_ActionSummonedAllSkillList = 1352;
const EV_CommandChannelStart = 1360;
const EV_CommandChannelEnd = 1370;
const EV_CommandChannelInfo = 1380;
const EV_CommandChannelPartyList = 1390;
const EV_CommandChannelPartyUpdate = 1395;
const EV_CommandChannelRoutingType = 1400;
const EV_CommandChannelPartyMember = 1420;
const EV_RestartMenuShow = 1430;
const EV_RestartMenuHide = 1440;
const EV_SiegeInfo = 1450;
const EV_SiegeInfoClanListStart = 1460;
const EV_SiegeInfoClanList = 1470;
const EV_SiegeInfoClanListEnd = 1480;
const EV_SiegeInfoSelectableTime = 1490;
const EV_IMEStatusChange = 1500;
const EV_ArriveNewTutorialQuestion = 1510;
const EV_ArriveTutorial = 1511;
const EV_ArriveShowQuest = 1520;
const EV_ArriveNewMail = 1530;
const EV_PartyMatchStart = 1540;
const EV_PartyMatchRoomStart = 1550;
const EV_PartyMatchingRoomHistory = 1551;
const EV_PartyMatchRoomClose = 1560;
const EV_PartyMatchList = 1570;
const EV_PartyMatchRoomMember = 1580;
const EV_PartyMatchRoomMemberUpdate = 1590;
const EV_PartyMatchChatMessage = 1600;
const EV_PartyMatchWaitListStart = 1610;
const EV_PartyMatchWaitList = 1620;
const EV_PartyMatchCommand = 1630;
const EV_HennaListWndShowHideEquip = 1640;
const EV_HennaListWndAddHennaEquip = 1650;
const EV_HennaInfoWndShowHideEquip = 1660;
const EV_HennaInfoWndShowHidePremiumEquip = 1661;
const EV_HennaListWndShowHideUnEquip = 1670;
const EV_HennaListWndClose = 1671;
const EV_HennaListWndAddHennaUnEquip = 1680;
const EV_HennaInfoWndShowHideUnEquip = 1690;
const EV_HennaInfoWndShowHidePremiumUnEquip = 1691;
const EV_CalculatorWndShowHide = 1700;
const EV_DialogOK = 1710;
const EV_DialogCancel = 1720;
const EV_RadarAddTarget = 1730;
const EV_RadarDeleteTarget = 1740;
const EV_RadarDeleteAllTarget = 1750;
const EV_RadarColor = 1760;
const EV_ShowTownMap = 1770;
const EV_ShowMinimap = 1780;
const EV_MinimapAddTarget = 1790;
const EV_MinimapDeleteTarget = 1800;
const EV_MinimapDeleteAllTarget = 1810;
const EV_MinimapShowQuest = 1820;
const EV_MinimapHideQuest = 1830;
const EV_MinimapChangeZone = 1840;
const EV_MinimapCursedWeaponList = 1850;
const EV_MinimapCursedWeaponLocation = 1860;
const EV_MinimapShowReduceBtn = 1870;
const EV_MinimapHideReduceBtn = 1880;
const EV_MinimapUpdateGameTime = 1890;
const EV_MinimapShowMultilayer = 1891;
const EV_MinimapCloseMultilayer = 1892;
const EV_MinimapAdjustViewLocation = 1893;
const EV_LanguageChanged = 1900;
const EV_PCCafePointInfo = 1910;
const EV_ShowPetitionWnd = 1920;
const EV_ShowUserPetitionWnd = 1921;
const EV_PetitionChatMessage = 1930;
const EV_EnablePetitionFeedback = 1940;
const EV_TradeStart = 1950;
const EV_TradeAddItem = 1960;
const EV_TradeDone = 1970;
const EV_TradeOtherOK = 1980;
const EV_TradeUpdateInventoryItem = 1990;
const EV_TradeRequestStartExchange = 2000;
const EV_SkillTrainListWndShow = 2010;
const EV_SkillTrainListWndHide = 2020;
const EV_SkillTrainListWndAddSkill = 2030;
const EV_SkillTrainInfoWndShow = 2040;
const EV_SkillTrainInfoWndHide = 2050;
const EV_SkillTrainInfoWndAddExtendInfo = 2051;
const EV_SkillLearningTabAddSkillBegin = 2055;
const EV_SkillLearningTabAddSkillItem = 2056;
const EV_SkillLearningTabAddSkillEnd = 2057;
const EV_SkillLearningDetailInfo = 2058;
const EV_SkillLearningNewArrival = 2059;
const EV_SkillEnchantInfoWndShow = 2064;
const EV_SkillEnchantInfoWndAddSkill = 2065;
const EV_SkillEnchantInfoWndAddExtendInfo = 2067;
const EV_SetMaxCount = 2070;
const EV_ShopOpenWindow = 2080;
const EV_OnEndTransactionList = 2081;
const EV_OnAddCastleTaxRateList = 2082;
const EV_ShopAddItem = 2090;
const EV_WarehouseOpenWindow = 2100;
const EV_WarehouseAddItem = 2110;
const EV_WarehouseDeleteItem = 2111;
const EV_PrivateShopOpenWindow = 2120;
const EV_PrivateShopAddItem = 2130;
const EV_SelectDeliverClear = 2140;
const EV_SelectDeliverAddName = 2150;
const EV_DeliverOpenWindow = 2160;
const EV_DeliverAddItem = 2170;
const EV_ShowEventMatchGMWnd = 2180;
const EV_EventMatchCreated = 2190;
const EV_EventMatchDestroyed = 2200;
const EV_EventMatchManage = 2210;
const EV_EventMatchPartyLeader = 2211;
const EV_StartEventMatchObserver = 2220;
const EV_EventMatchUpdateTeamName = 2230;
const EV_EventMatchUpdateScore = 2240;
const EV_EventMatchUpdateTeamInfo = 2250;
const EV_EventMatchUpdateUserInfo = 2260;
const EV_EventMatchGMMessage = 2270;
const EV_ShowGMWnd = 2280;
const EV_GMObservingUserInfoUpdate = 2290;
const EV_GMObservingUserInfoUpdateClassic = 2291;
const EV_GMObservingSkillListStart = 2300;
const EV_GMObservingSkillList = 2310;
const EV_GMObservingQuestListStart = 2320;
const EV_GMObservingQuestList = 2330;
const EV_GMObservingQuestListEnd = 2340;
const EV_GMObservingQuestItem = 2350;
const EV_GMObservingWarehouseItemListStart = 2360;
const EV_GMObservingWarehouseItemList = 2370;
const EV_GMObservingClan = 2380;
const EV_GMObservingClanMemberStart = 2390;
const EV_GMObservingClanMember = 2400;
const EV_GMObservingInventoryAddItem = 2401;
const EV_GMObservingInventoryClear = 2402;
const EV_GMAddHennaInfo = 2403;
const EV_GMUpdateHennaInfo = 2404;
const EV_GMAddPremiumHennaInfo = 2405;
const EV_GMSnoop = 2410;
const EV_BeginShowZoneTitleWnd = 2420;
const EV_TutorialViewerWndShow = 2430;
const EV_TutorialViewerWndShowHtmlFile = 2431;
const EV_TutorialViewerWndHide = 2440;
const EV_ObserverWndShow = 2450;
const EV_ObserverWndHide = 2460;
const EV_AutoFishStart = 2471;
const EV_FishViewportWndHide = 2480;
const EV_AutoFishEnd = 2481;
const EV_AutoFishAvailable = 2490;
const EV_MultiSellInfoListBegin = 2530;
const EV_NewMultiSellInfoListBegin = 2531;
const EV_MultiSellResultItemInfo = 2535;
const EV_NewMultiSellResultItemInfo = 2536;
const EV_MultiSellOutputItemInfo = 2540;
const EV_NewMultiSellOutputItemInfo = 2541;
const EV_MultiSellInputItemInfo = 2550;
const EV_NewMultiSellInputItemInfo = 2551;
const EV_MultiSellInfoListEnd = 2560;
const EV_NewMultiSellInfoListEnd = 2561;
const EV_MultiSellResult = 2565;
const EV_InventoryClear = 2570;
const EV_InventoryOpenWindow = 2580;
const EV_InventoryHideWindow = 2590;
const EV_InventoryAddItem = 2600;
const EV_InventoryUpdateItem = 2610;
const EV_InventoryItemListEnd = 2620;
const EV_InventoryAddHennaInfo = 2630;
const EV_InventoryToggleWindow = 2631;
const EV_InventoryAddPremiumHennaInfo = 2632;
const EV_InventoryPremiumHennaInfoClear = 2633;
const EV_ManorCropSellWndShow = 2640;
const EV_ManorCropSellWndAddItem = 2645;
const EV_ManorCropSellWndSetCropSell = 2646;
const EV_ManorCropSellChangeWndShow = 2647;
const EV_ManorCropSellChangeWndAddItem = 2648;
const EV_ManorCropSellChangeWndSetCropNameAndRewardType = 2649;
const EV_ManorInfoWndSeedShow = 2650;
const EV_ManorInfoWndSeedAdd = 2651;
const EV_ManorInfoWndCropShow = 2652;
const EV_ManorInfoWndCropAdd = 2653;
const EV_ManorInfoWndDefaultShow = 2654;
const EV_ManorInfoWndDefaultAdd = 2655;
const EV_ManorSeedInfoSettingWndShow = 2656;
const EV_ManorSeedInfoSettingWndAddItem = 2657;
const EV_ManorSeedInfoSettingWndAddItemEnd = 2658;
const EV_ManorSeedInfoSettingWndChangeValue = 2659;
const EV_ManorSeedInfoChangeWndShow = 2660;
const EV_ManorCropInfoSettingWndShow = 2665;
const EV_ManorCropInfoSettingWndAddItem = 2666;
const EV_ManorCropInfoSettingWndAddItemEnd = 2667;
const EV_ManorCropInfoSettingWndChangeValue = 2668;
const EV_ManorCropInfoChangeWndShow = 2670;
const EV_ManorShopWndOpen = 2680;
const EV_ManorShopWndAddItem = 2690;
const EV_DuelAskStart = 2700;
const EV_DuelReady = 2710;
const EV_DuelStart = 2720;
const EV_DuelEnd = 2730;
const EV_DuelUpdateUserInfo = 2740;
const EV_DuelEnemyRelation = 2750;
const EV_ShowRefineryInteface = 2760;
const EV_RefineryConfirmTargetItemResult = 2770;
const EV_RefineryConfirmRefinerItemResult = 2780;
const EV_RefineryConfirmGemStoneResult = 2790;
const EV_RefineryRefineResult = 2800;
const EV_ShowRefineryCancelInteface = 2810;
const EV_RefineryConfirmCancelItemResult = 2820;
const EV_RefineryRefineCancelResult = 2830;
const EV_QuestInfoStart = 2840;
const EV_QuestInfo = 2850;
const EV_EnchantShow = 2860;
const EV_EnchantHide = 2865;
const EV_EnchantResult = 2870;
const EV_EnchantPutTargetItemResult = 2880;
const EV_EnchantPutSupportItemResult = 2881;
const EV_EnchantPutScrollItemResult = 2882;
const EV_EnchantRemoveSupportItemResult = 2883;
const EV_AttributeEnchantItemShow = 2893;
const EV_AttributeEnchantItemList = 2894;
const EV_AttributeEnchantResult = 2895;
const EV_RemoveAttributeEnchantWndShow = 2896;
const EV_RemoveAttributeEnchantItemData = 2897;
const EV_RemoveAttributeEnchantResult = 2898;
const EV_ResolutionChanged = 2900;
const EV_TrackerAttach = 2920;
const EV_TrackerDetach = 2930;
const EV_EditorSetProperty = 2940;
const EV_EditorUpdateProperty = 2950;
const EV_RequestTooltipInfo = 2960;
const EV_NotifyObject = 2970;
const EV_NotifyPartyMemberPosition = 2971;
const EV_MinimapTravel = 2980;
const EV_MinimapRegionInfoBtnClick = 2990;
const EV_TextLinkLButtonClick = 3000;
const EV_TextLinkRButtonClick = 3010;
const EV_LobbyMenuButtonEnable = 3020;
const EV_LobbyAddCharacterName = 3021;
const EV_LobbyCharacterSelect = 3022;
const EV_LobbyClearCharacterName = 3023;
const EV_LobbyStartButtonClick = 3024;
const EV_LobbyShowDialog = 3025;
const EV_LobbyGetSelectedCharacterIndex = 3026;
const EV_LobbyCharacterReceivingFinished = 3027;
const EV_LobbyShowPremiumLevelInfo = 3028;
const EV_LobbyShowDormantUserCouponWnd = 3029;
const EV_ITEM_AUCTION_INFO = 3050;
const EV_ITEM_AUCTION_NEXT_INFO = 3051;
const EV_ITEM_AUCTION_NEXT_NOTEXIST = 3052;
const EV_ITEM_AUCTION_UPDATED_BIDDING_INFO = 3053;
const EV_MouseOver = 3060;
const EV_MouseOut = 3070;
const EV_ShowWindow = 3080;
const EV_PartyPetAdd = 3110;
const EV_PartyPetUpdate = 3120;
const EV_PartyPetDelete = 3130;
const EV_PartySummonAdd = 3131;
const EV_PartySummonUpdate = 3132;
const EV_PartySummonDelete = 3133;
const EV_ShowCastleInfo = 3140;
const EV_AddCastleInfo = 3150;
const EV_ShowFortressInfo = 3160;
const EV_AddFortressInfo = 3170;
const EV_ShowAgitInfo = 3180;
const EV_AddAgitInfo = 3190;
const EV_ShowFortressSiegeInfo = 3200;
const EV_ShowFortressMapInfo = 3201;
const EV_FortressMapBarrackInfo = 3202;
const EV_CharacterCreateSetClassDesc = 3210;
const EV_CharacterCreateClearClassDesc = 3220;
const EV_CharacterCreateClearSetupWnd = 3230;
const EV_CharacterCreateClearWnd = 3240;
const EV_CharacterCreateClearName = 3250;
const EV_CharacterCreateEnableRotate = 3260;
const EV_NPCDialogWndShow = 3270;
const EV_NPCDialogWndShowBig1 = 3271;
const EV_NPCDialogWndHide = 3280;
const EV_NPCDialogWndHideBig1 = 3281;
const EV_NPCDialogWndLoadHtmlFromString = 3290;
const EV_NPCDialogWndLoadHtmlFromStringBig1 = 3291;
const EV_ItemDescWndShow = 3300;
const EV_ItemDescWndLoadHtmlFromString = 3310;
const EV_ItemDescWndSetWindowTitle = 3320;
const EV_QuestIDWndLoadHtmlFromString = 3321;
const EV_QuestHtmlWndLoadHtmlFromString = 3322;
const EV_QuestHtmlWndShow = 3323;
const EV_QuestHtmlWndHide = 3324;
const EV_ToggleXMasSealWndShowHide = 3330;
const EV_OpenDialogQuit = 3340;
const EV_OpenDialogRestart = 3350;
const EV_FinishRotate = 3360;
const EV_PVPMatchRecord = 3370;
const EV_PVPMatchRecordEachUserInfo = 3380;
const EV_PVPMatchUserDie = 3390;
const EV_ToggleDetailStatusWnd = 3400;
const EV_StateChanged = 3410;
const EV_NotifyBeforeStateChanged = 3411;
const EV_ShowChangeNicknameNColor = 3440;
const EV_BookMarkList = 3450;
const EV_BookMarkShow = 3451;
const EV_SetShowAllStateInfo = 3452;
const EV_PremiumItemAlarm = 3460;
const EV_PremiumItemList = 3461;
const EV_CrataeCubeRecordBegin = 3470;
const EV_CrataeCubeRecordItem = 3480;
const EV_CrataeCubeRecordEnd = 3490;
const EV_CrataeCubeRecordMyItem = 3500;
const EV_CrataeCubeRecordRetire = 3501;
const EV_RenderDeviceRecreated = 3511;
const EV_ShowMiniGame1 = 3520;
const EV_AirShipUpdate = 3530;
const EV_AirShipState = 3540;
const EV_AirShipAltitude = 3541;
const EV_AirShipTeleportListStart = 3542;
const EV_AirShipTeleportList = 3543;
const EV_AITimer = 3550;
const EV_BirthdayItemAlarm = 3560;
const EV_ShowDominionWarJoinListStart = 3570;
const EV_ShowDominionWarJoinListEnemyDominionInfo = 3571;
const EV_ShowDominionWarJoinListEnd = 3572;
const EV_ResultJoinDominionWar = 3580;
const EV_DominionInfoCnt = 3590;
const EV_DominionInfo = 3600;
const EV_DominionsOwnPos = 3610;
const EV_DominionWarChannelSet = 3620;
const EV_DominionWarStart = 3630;
const EV_DominionWarEnd = 3640;
const EV_CleftListInfo = 3690;
const EV_CleftListStart = 3700;
const EV_CleftListAdd = 3710;
const EV_CleftListRemove = 3720;
const EV_CleftListClose = 3730;
const EV_CleftStateTeam = 3740;
const EV_CleftStatePlayer = 3750;
const EV_CleftStateResult = 3760;
const EV_FlightTransform = 3800;
const EV_ReserveShortCut = 3801;
const EV_ChangeCharacterPawn = 3810;
const EV_BlockRemainTime = 3820;
const EV_BlockListStart = 3830;
const EV_BlockListAdd = 3840;
const EV_BlockListRemove = 3850;
const EV_BlockListClose = 3860;
const EV_BlockListVote = 3870;
const EV_BlockListTimeUpset = 3880;
const EV_BlockStateTeam = 3890;
const EV_BlockStatePlayer = 3900;
const EV_BlockStateResult = 3910;
const EV_MpccRoomInfo = 4000;
const EV_ListMpccWaitingStart = 4010;
const EV_ListMpccWaitingRoomInfo = 4020;
const EV_ListMpccWaitingCount = 4021;
const EV_DismissMpccRoom = 4030;
const EV_ManageMpccRoomMember = 4040;
const EV_MpccRoomMemberStart = 4050;
const EV_MpccRoomMemberInfo = 4060;
const EV_MpccRoomChatMessage = 4070;
const EV_MpccPartyMasterList = 4080;
const EV_VitalityPointInfo = 4100;
const EV_VitalityEffectInfo = 4110;
const EV_GMVitalityEffectInfo = 4111;
const EV_LoginVitalityEffectInfo = 4120;
const EV_ShowSeedMapInfo = 4200;
const EV_PawnViewerWndAddItem = 4300;
const EV_PawnViewerWndAddHairMeshName = 4320;
const EV_PawnViewerWndAddFaceTextureName = 4330;
const EV_PawnViewerWndUpdateHairAccCoord = 4340;
const EV_PawnViewerWndClearAnimList = 4350;
const EV_PawnViewerWndAddAnimName = 4360;
const EV_PawnViewerWndShortcutSave = 4365;
const EV_PCViewerWndReload = 4370;
const EV_NPCViewerWndReload = 4380;
const EV_MSViewerWndAddSkill = 4400;
const EV_MSViewerWndShow = 4410;
const EV_MSViewerWndDeleteAllSkill = 4420;
const EV_MSProfilingResult = 4430;
const EV_MSProfilingClear = 4431;
const EV_SceneListUpdate = 4500;
const EV_SceneDataUpdate = 4510;
const EV_SceneDataSave = 4520;
const EV_UpdateSceneTreeData = 4530;
const EV_CurSceneIndexInit = 4540;
const EV_SlideShow = 4550;
const EV_ScenePlayStart = 4560;
const EV_ScenePlay = 4570;
const EV_SkillEnchantResult = 4600;
const EV_Notice_Post_Arrived = 4700;
const EV_StartReceivedPostList = 4710;
const EV_AddReceivedPostList = 4720;
const EV_EndReceivedPostList = 4730;
const EV_MailCommisionValue = 4731;
const EV_ReplyReceivedPostStart = 4740;
const EV_ReplyReceivedPostAddItem = 4741;
const EV_ReplyReceivedPostEnd = 4742;
const EV_StartSentPostList = 4750;
const EV_AddSentPostList = 4760;
const EV_EndSentPostList = 4770;
const EV_ReplySentPostStart = 4780;
const EV_ReplySentPostAddItem = 4781;
const EV_ReplySentPostEnd = 4782;
const EV_PostWriteOpen = 4790;
const EV_PostWriteAddItem = 4791;
const EV_PostWriteEnd = 4792;
const EV_DeleteReceivedPost = 4793;
const EV_OpenStateReceivedPost = 4794;
const EV_ReceivedStateReceivedPost = 4795;
const EV_DeleteSentPost = 4796;
const EV_OpenStateSentPost = 4797;
const EV_ReceivedStateSentPost = 4798;
const EV_ReplyWritePost = 4799;
const EV_ShowNewUserPetitionWnd = 4800;
const EV_AddNewUserPetitionCategoryStepOne = 4810;
const EV_ShowNewUserPetitionDescription = 4820;
const EV_AddNewUserPetitionCategoryStepTwo = 4830;
const EV_ShowNewUserPetitionContents = 4840;
const EV_ShowNewUserPetitionHtml = 4850;
const EV_ShowPrivateMarketList = 4860;
const EV_AddPrivateMarketList = 4861;
const EV_UsePartyMatchAction = 4870;
const EV_EffectViewerAddEffect = 4880;
const EV_EffectViewerShow = 4881;
const EV_ShowAskCoupleActionDialog = 4900;
const EV_AskPartyLootingModify = 4910;
const EV_PartyLootingHasModified = 4911;
const EV_MembershipType = 4912;
const EV_PartyHasDismissed = 4913;
const EV_BecamePartyMember = 4914;
const EV_BecamePartyMaster = 4915;
const EV_OustPartyMember = 4916;
const EV_WithdrawParty = 4917;
const EV_HandOverPartyMaster = 4918;
const EV_RecvPartyMaster = 4919;
const EV_CommandAddAllianceCrestFile = 4920;
const EV_ExpandQuestAlarmKillMonster = 4930;
const EV_ExpandQuestAlarmKillMonsterStart = 4931;
const EV_ExpandQuestAlarmKillMonsterEnd = 4932;
const EV_ReceiveNewVoteSystemInfo = 4940;
const EV_ShowNewVoteSystemHelp = 4941;
const EV_PostEffectShow = 4950;
const EV_UrlLinkClick = 4960;
const EV_ChatIconClick = 4961;
const EV_ReceiveFriendList = 4970;
const EV_ConfirmAddingPostFriend = 4980;
const EV_ReceivePostFriendList = 4990;
const EV_ReceivePledgeMemberList = 5000;
const EV_ShowWeatherWnd = 5010;
const EV_ReplayRecStarted = 5020;
const EV_ReplayRecEnded = 5021;
const EV_EnterOlympiadObserverMode = 5030;
const EV_ListCtrlLoseSelected = 5040;
const EV_HDRRenderTestWndShow = 5050;
const EV_SkillCancel = 5060;
const EV_NatureRenderShow = 5070;
const EV_ReceiveOlympiadGameList = 5080;
const EV_ReceiveOlympiadResult = 5081;
const EV_ReceiveOlympiadResultV2 = 5082;
const EV_SetEnterChatting = 5090;
const EV_UnSetEnterChatting = 5091;
const EV_NavitAdventPointInfo = 5100;
const EV_NavitAdventEffect = 5110;
const EV_NavitAdventTimeChange = 5120;
const EV_TargetSpelledList = 5120;
const EV_TargetStatusWndShow = 5121;
const EV_TargetStatusWndHide = 5122;
const EV_ActivateAlterSkill = 5130;
const EV_InactivateAlterSkill = 5131;
const EV_UseActiveAlterSkill = 5132;
const EV_CrystalizingEstimationList = 5140;
const EV_CrystalizingEstimationListEnd = 5141;
const EV_CrystalizingFail = 5142;
const EV_UpdateUltimateSkillPoint = 5150;
const EV_RegisterUltimateSkill = 5151;
const EV_ShowSheathingWnd = 5160;
const EV_SheathingInfo = 5170;
const EV_RequestStartPledgeWar = 5180;
const EV_RequestStopPledgeWar = 5181;
const EV_JumpWayPointUpdate = 5190;
const EV_JumpWayPointHide = 5200;
const EV_CampaignArrived = 5210;
const EV_ZoneQuestArrived = 5220;
const EV_CampaignProgressInfo = 5230;
const EV_ZoneQuestProgressInfo = 5240;
const EV_CampaignFinish = 5250;
const EV_ZoneQuestFinish = 5260;
const EV_CampaignRewardStart = 5270;
const EV_ZoneQuestRewardStart = 5280;
const EV_CampaignRewardFinish = 5290;
const EV_ZoneQuestRewardFinish = 5300;
const EV_CampaignResult = 5301;
const EV_ZoneQuestResult = 5302;
const EV_MinimapShowCampaign = 5303;
const EV_MinimapHideCampaign = 5304;
const EV_NotifySubjob = 5310;
const EV_CreatedSubjob = 5311;
const EV_ChangedSubjob = 5312;
const EV_HeadDisplayUpdate = 5320;
const EV_OwnSkillHasLaunched = 5330;
const EV_OwnSkillHasCanceled = 5340;
const EV_GStarObtainSkill = 5350;
const EV_GstarShowMissionGuide = 5351;
const EV_GstarPlayFlashMovie = 5352;
const EV_GstarUIInit = 5353;
const EV_GstarCloseSkill = 5354;
const EV_GstarZoneChange = 5355;
const EV_GstarSceneStateEnter = 5356;
const EV_GstarCommandLineIcon = 5357;
const EV_GstarGameEnd = 5358;
const EV_GstarNotifyMonsterCount = 5359;
const EV_ApplySkillAvailability = 5360;
const EV_ApplyPetSkillAvailability = 5365;
const EV_DamageTextCreate = 5370;
const EV_DamageTextUpdate = 5371;
const EV_NotifyTutorialQuest = 5380;
const EV_ClearTutorialQuest = 5381;
const EV_FriendInfoListEmpty = 5390;
const EV_FriendAdded = 5391;
const EV_FriendRemoved = 5392;
const EV_FriendInfoUpdate = 5393;
const EV_FriendDetailInfoUpdate = 5394;
const EV_BlockInfoListEmpty = 5400;
const EV_BlockAdded = 5401;
const EV_BlockRemoved = 5402;
const EV_BlockInfoUpdate = 5403;
const EV_BlockDetailInfoUpdate = 5404;
const EV_InzonePartyHistoryUpdate = 5410;
const EV_ShowPersonalConnectionWnd = 5411;
const EV_MovieCaptureStarted = 5420;
const EV_MovieCaptureEnded = 5430;
const EV_MovieCaptureFailDiskSpace = 5440;
const EV_CallToChangeClass = 5470;
const EV_ChangeToAwakenedClass = 5480;
const EV_ItemCommissionWndShow = 5490;
const EV_ItemCommissionWndRegistrableItemCnt = 5492;
const EV_ItemCommissionWndRegistrableItemList = 5495;
const EV_ItemCommissionWndResponseInfo = 5500;
const EV_ItemCommissionWndListStart = 5510;
const EV_ItemCommissionWndEachItem = 5520;
const EV_ItemCommissionWndListEnd = 5530;
const EV_ItemCommissionWndSearchFail = 5535;
const EV_ItemCommissionWndBuyInfo = 5540;
const EV_ItemCommissionWndBuyResult = 5550;
const EV_ItemCommissionWndDeleteResult = 5560;
const EV_ItemCommissionWndRegisterResult = 5570;
const EV_ItemCommissionWndCloseCauseOfLongDistance = 5571;
const EV_ItemCommissionRegisterWndCloseCauseOfFreeUser = 5572;
const EV_ItemCommissionWndSellingPremiumItemRegisterReset = 5498;
const EV_ItemCommissionWndSellingPremiumItemRegister = 5499;
const EV_FlashDebugMsg = 5580;
const EV_StatisticWndShow = 5590;
const EV_StatisticHotLinkWndShow = 5591;
const EV_StatisticNameInfo = 5592;
const EV_StatisticAllNameInfo = 5593;
const EV_StatisticWorldRecord = 5594;
const EV_StatisticUserRecord = 5595;
const EV_ShowGoodsInventoryWnd = 5600;
const EV_GoodsInventoryItemList = 5601;
const EV_GoodsInventoryItemDesc = 5602;
const EV_GoodsInventoryNoti = 5603;
const EV_GoodsInventoryResult = 5604;
const EV_SecondaryAuthCreate = 5610;
const EV_SecondaryAuthVerify = 5611;
const EV_SecondaryAuthBlocked = 5612;
const EV_SecondaryAuthSuccess = 5613;
const EV_SecondaryAuthCreateFail = 5614;
const EV_SecondaryAuthVerifyFail = 5615;
const EV_SecondaryAuthFailEtc = 5616;
const EV_CharacterNameCreatable = 5618;
const EV_ShowSceneClipView = 5620;
const EV_DeleteSceneClipView = 5621;
const EV_ShowUsm = 5622;
const EV_ShowFullSceneClipView = 5623;
const EV_DeleteFullSceneClipView = 5624;
const EV_LoginBegin = 5630;
const EV_LoginFail = 5640;
const EV_LoginFailFlash = 5641;
const EV_LoginOK = 5650;
const EV_LoginQueueTicket = 5651;
const EV_LoginWait = 5660;
const EV_LoginTelephoneWait = 5661;
const EV_LoginSecurityCard = 5670;
const EV_LoginGoogleOtp = 5671;
const EV_ShowEula = 5680;
const EV_ShowChinaEula = 5681;
const EV_ServerListStart = 5690;
const EV_ServerList = 5691;
const EV_ServerListEnd = 5692;
const EV_LoginUIGetFocus = 5700;
const EV_CreditXMLString = 5710;
const EV_OptionHasApplied = 5720;
const EV_ChangeAttribute_CandidateListClear = 5730;
const EV_ChangeAttribute_CandidateItem = 5731;
const EV_ChangeAttribute_ItemDetail = 5732;
const EV_ChangeAttribute_ItemResult = 5733;
const EV_WebBrowser_ShowFileRegisterWnd = 5740;
const EV_WebBrowser_FinishedLoading = 5750;
const EV_WebBrowser_ReceivedTitle = 5751;
const EV_WebBrowser_NoticeOpenStatus = 5752;
const EV_WebBrowser_EventParam = 5753;
const EV_ConfirmMentee = 5800;
const EV_MentorMenteeListStart = 5810;
const EV_MentorMenteeListInfo = 5820;
const EV_MenteeWaitingListStart = 5830;
const EV_MenteeWaitingList = 5840;
const EV_MenteeWaitingListEnd = 5850;
const EV_InzoneWaitingInfo = 5860;
const EV_OptionWndShow = 5870;
const EV_SetFullScreenCheck = 5871;
const EV_EventAttendanceInfo = 6000;
const EV_ExtraWorldChattingCnt = 6110;
const EV_UpdateQuestMarkRadarMap = 6120;
const EV_UpdateTargetSelectedRadarMap = 6130;
const EV_ReceiveWindowsInfo = 6200;
const EV_ReceiveChatFilter = 6210;
const EV_ReceiveOption = 6220;
const EV_NeedResetUIData = 8000;
const EV_MatchGroup = 8200;
const EV_MatchGroupAsk = 8210;
const EV_MatchGroupWithdraw = 8220;
const EV_MatchGroupOust = 8230;
const EV_RequestMatchArena = 8300;
const EV_CompleteMatchArena = 8310;
const EV_ConfirmMatchArena = 8320;
const EV_CancelMatchArena = 8330;
const EV_StartChooseClassArena = 8340;
const EV_ChangeClassArena = 8350;
const EV_ConfirmClassArena = 8360;
const EV_StartBattleReadyArena = 8370;
const EV_BattleReadyArena = 8380;
const EV_BattleResultArena = 8400;
const EV_BattleResultArenaReward = 8401;
const EV_BattleResultArenaStat = 8402;
const EV_ExitArena = 8410;
const EV_ClosingArena = 8420;
const EV_ClosedArena = 8430;
const EV_ArenaDashboard = 8500;
const EV_ArenaUpdateEquipSlot = 8510;
const EV_ArenaKillInfo = 8520;
const EV_TransformNotification = 8530;
const EV_ArenaBattleOccupyDashboard = 8540;
const EV_ArenaBattleOccupyStatus = 8541;
const EV_ArenaBattleOccupyScore = 8542;
const EV_ArenaBattleOccupyShowSkill = 8545;
const EV_ArenaBattleOccupyHideSkill = 8546;
const EV_ArenaCustomNotification = 8600;
const EV_ArenaShowEnemyParty = 8610;
const EV_ArenaRankAll = 8650;
const EV_ArenaMyRank = 8660;
const EV_HtmlWithNPCViewport = 8700;
const EV_HtmlWithNPCViewportClose = 8701;
const EV_NpcStrWithNPCViewport = 8702;
const EV_NpcStrWithNPCViewportClose = 8703;
const EV_ArenaChangeAbilpage = 8800;
const EV_ArenaEnd = 9000;
const EV_BR_CashShopToggleWindow = 9010;
const EV_BR_CashShopCateroyAdd = 9011;
const EV_BR_CashShopCateroyTabRemove = 9012;
const EV_BR_RecentProductListEnd = 9013;
const EV_BR_BasketProductListEnd = 9014;
const EV_BR_CashShopNewIconAnim = 9015;
const EV_BR_CashShopCateroyTabClear = 9016;
const EV_BR_CashShopAddItem = 9020;
const EV_BR_SetNewList = 9021;
const EV_BR_ProductListEnd = 9022;
const EV_BR_CashShopAddProductItem = 9023;
const EV_BR_SetRecentProduct = 9025;
const EV_BR_SetBasketProduct = 9026;
const EV_BR_AddRecentProductItem = 9027;
const EV_BR_AddBasketProductItem = 9028;
const EV_BR_SetNewProductInfo = 9030;
const EV_BR_SetPresentNewProductInfo = 9031;
const EV_BR_AddMyShopBasketProductItem = 9032;
const EV_BR_DeleteMyShopBasketProductItem = 9033;
const EV_BR_DeleteCashShopBasketProductItem = 9034;
const EV_BR_DeleteAllBasketProductItem = 9035;
const EV_BR_AddEachProductInfo = 9040;
const EV_BR_AddPresentEachProductInfo = 9041;
const EV_BR_SETGAMEPOINT = 9050;
const EV_BR_SETEVENTCOIN = 9051;
const EV_BR_RESULT_BUY_PRODUCT = 9060;
const EV_BR_SHOW_CONFIRM = 9070;
const EV_BR_HIDE_CONFIRM = 9071;
const EV_BR_PRESENT_SHOW_CONFIRM = 9072;
const EV_BR_PRESENT_HIDE_CONFIRM = 9073;
const EV_BR_RESULT_PRESENT_BUY_PRODUCT = 9061;
const EV_BR_PREMIUM_STATE = 9080;
const EV_BR_FireEventStateInfo = 9090;
const EV_BR_FireEventTimeInfo = 9091;
const EV_BR_EventHalloweenHelp = 9100;
const EV_BR_EventHalloweenShow = 9101;
const EV_BR_EventRankerNowList = 9102;
const EV_BR_EventRankerLastList = 9103;
const EV_BR_EventChristmasShow = 9110;
const EV_BR_EventCommonHtml1 = 9111;
const EV_BR_EventCommonHtml2 = 9112;
const EV_BR_EventCommonHtml3 = 9113;
const EV_BR_MinigameMyRanking = 9120;
const EV_BR_MinigameAllRanking = 9121;
const EV_BR_EventValentineShow = 9130;
const EV_BR_Die_EnableNPC = 9140;
const EV_BR_RestartByNPCButtonEnable = 9150;
const EV_NotifyImportedCrestImage = 9220;
const EV_FlyMoveText = 9230;
const EV_NotifyFlyMoveStart = 9231;
const EV_BeastTestShow = 9240;
const EV_EnvTestShow = 9250;
const EV_ItemLookChangeShow = 9260;
const EV_ItemLookChangeHide = 9270;
const EV_ItemLookChangeResult = 9280;
const EV_ItemLookChangePutTargetItemResult = 9290;
const EV_ItemLookChangePutSupportItemResult = 9300;
const EV_CuriousHouseWaitState = 9310;
const EV_CuriousHouseEnter = 9320;
const EV_CuriousHouseLeave = 9330;
const EV_CuriousHouseMemberListStart = 9340;
const EV_CuriousHouseMemberList = 9341;
const EV_CuriousHouseMemberListEnd = 9342;
const EV_CuriousHouseMemberUpdate = 9350;
const EV_CuriousHouseRemainTime = 9360;
const EV_CuriousHouseResultIsVictory = 9370;
const EV_CuriousHouseResultListStart = 9380;
const EV_CuriousHouseResultList = 9381;
const EV_CuriousHouseResultListEnd = 9382;
const EV_CuriousHouseObserveListStart = 9390;
const EV_CuriousHouseObserveList = 9391;
const EV_CuriousHouseObserveListEnd = 9392;
const EV_CuriousHouseObserveModeON = 9400;
const EV_CuriousHouseObserveModeOFF = 9401;
const EV_UpdateHaircolorData = 9410;
const EV_ReceivePledgeUnionStateInfo = 9420;
const EV_ReceiveUnionPoint = 9421;
const EV_ReceivePledgeUnionOpenNPC = 9422;
const EV_RequestOpenClanUnionInfoWnd = 9425;
const EV_SendIsActiveUnionInfoBtn = 9426;
const EV_SendRequestResult = 9427;
const EV_EventKalieState = 9430;
const EV_EventKalieJackpotUser = 9431;
const EV_EventKalieDisable = 9432;
const EV_EventBalthusState = 9433;
const EV_EventBalthusJackpotUser = 9434;
const EV_EventBalthusDisable = 9435;
const EV_HairAccessoryPriority = 9439;
const EV_OpenBeautyshopWindow = 9440;
const EV_ReceiveBeautyItemList = 9441;
const EV_OpenBeautyshopResetWindow = 9442;
const EV_SendUserAdenaAndCoin = 9443;
const EV_IsSuccessBuyingStyle = 9444;
const EV_CurrentUserStyle = 9445;
const EV_OldUserStyle = 9446;
const EV_EndSocialAction = 9447;
const EV_ExitBeautyshop = 9448;
const EV_PurchaseItemList = 9449;
const EV_ShowWebPetitionMainPage = 9450;
const EV_ShowWebPetitionListPage = 9451;
const EV_WebPetitionReplyAlarm = 9452;
const EV_BR_Event_CampaignArrived = 9500;
const EV_BR_Event_CampaignProgressInfo = 9510;
const EV_BR_Event_CampaignFinish = 9520;
const EV_BR_Event_CampaignResult = 9530;
const EV_EnterSingleMeshZone = 9540;
const EV_ExitSingleMeshZone = 9541;
const EV_UnReadMailCount = 9550;
const EV_PledgeCount = 9560;
const EV_AdenaInvenCount = 9570;
const EV_PledgeRecruitBoardStart = 9580;
const EV_PledgeRecruitBoardItem = 9581;
const EV_PledgeRecruitInfo = 9582;
const EV_PledgeRecruitInfoItem = 9583;
const EV_PledgeRecruitBoardDetail = 9590;
const EV_PledgeWaitingListApplied = 9591;
const EV_PledgeWaitingListStart = 9600;
const EV_PledgeWaitingListItem = 9601;
const EV_PledgeWaitingUser = 9610;
const EV_PledgeDraftListStart = 9620;
const EV_PledgeDraftListItem = 9621;
const EV_PledgeWaitingListAlarm = 9630;
const EV_PledgeSigninForOpenJoiningMethod = 9631;
const EV_PledgeRecruitApplyInfo = 9640;
const EV_ShowEventChristmasWnd = 9650;
const EV_CardRewardStart = 9660;
const EV_CardListProperty = 9670;
const EV_CardProperty = 9680;
const EV_BR_10thAnniBannerShow = 9681;
const EV_DivideAdenaStart = 9690;
const EV_DivideAdenaCancel = 9700;
const EV_DivideAdenaDone = 9710;
const EV_CharacterDeleteFail = 9740;
const EV_GameStart = 9750;
const EV_NewEnchantPushOneOK = 9760;
const EV_NewEnchantPushOneFail = 9770;
const EV_NewEnchantPushTwoOK = 9780;
const EV_NewEnchantPushTwoFail = 9790;
const EV_NewEnchantRemoveOneOK = 9800;
const EV_NewEnchantRemoveOneFail = 9810;
const EV_NewEnchantRemoveTwoOK = 9820;
const EV_NewEnchantRemoveTwoFail = 9830;
const EV_NewEnchantTrySuccess = 9840;
const EV_NewEnchantTryFail = 9850;
const EV_NewEnchantRetryPutItemsOK = 9851;
const EV_NewEnchantRetryPutItemsFail = 9852;
const EV_ContextMenu = 9860;
const EV_AlchemySkillList = 9870;
const EV_AlchemySkillListForXML = 9873;
const EV_AlchemyMixCubeInfo = 9875;
const EV_AlchemyTryMixCube = 9880;
const EV_AlchemyConversion = 9890;
const EV_AlchemySkillInfoFromScript = 9900;
const EV_AlchemyPushItemOnMixCube = 9910;
const EV_AlchemyAdditionPushItemOnMixCube = 9920;
const EV_UIDebugMsg = 9995;
const EV_BR_EventFastivalInkMax = 10000;
const EV_BR_EventFastivalInkEnergy = 10001;
const EV_ShowWebPathMainPage = 10010;
const EV_ShowWebPathListPage = 10011;
const EV_ShowWebPathAlarm = 10012;
const EV_ShowLuckyGame = 10021;
const EV_LuckyGameStart = 10022;
const EV_LuckyGameResult = 10023;
const EV_ShowTrainingRoom = 10030;
const EV_TrainingRoomStart = 10031;
const EV_TrainingRoomStutus = 10032;
const EV_TrainingRoomEnd = 10033;
const EV_TrainingRoomStart_SecondInfo = 10034;
const EV_PathToAwakeningAlarm = 10040;
const EV_InitEnterChattingSelectMode = 10041;
const EV_VipAttendanceItemList = 10050;
const EV_VipAttendanceCheck = 10051;
const EV_VipAttendanceRefresh = 10052;
const EV_NotifyAttendance = 10053;
const EV_EnsoulWndShow = 10060;
const EV_EnsoulResult = 10061;
const EV_EnsoulExtractionWndShow = 10062;
const EV_EnsoulExtractionResult = 10063;
const EV_CastleWarSeasonResult = 10070;
const EV_CastleWarSeasonReward = 10071;
const EV_FactionInfo = 10080;
const EV_VipBotCaptchaInfo = 10090;
const EV_VipBotCaptchaResult = 10091;
const EV_SendAgitFuncInfo = 10100;
const EV_ResponseDecoNPCAvalability = 10110;
const EV_InGameWebWnd_Info = 10120;
const EV_AI_CONTENT_MONSTER_ARENA_SCORE = 10130;
const EV_GotoWorldRaidServer = 10140;
const EV_MonsterBookStart = 10150;
const EV_MonsterBookInfo = 10151;
const EV_MonsterBookEnd = 10152;
const EV_MonsterBookRewardIcon = 10160;
const EV_MonsterBookOpenResult = 10161;
const EV_MonsterBookCloseForce = 10162;
const EV_FactionInfoRewardIcon = 10170;
const EV_FactionLevelUpNotify = 10171;
const EV_AddAgitSiegeInfo = 10180;
const EV_RaidBossSpawnInfo = 10181;
const EV_RaidServerInfo = 10182;
const EV_ItemAuctionStatus = 10183;
const EV_ShowUpgradeSystem = 10190;
const EV_UpgradeSystemResult = 10191;
const EV_KserthFieldEventStep = 10200;
const EV_KserthFieldEventPoint = 10210;
const EV_PrivateStoreBuyingResult = 10220;
const EV_PrivateStoreSellingResult = 10221;
const EV_CurrentServerTime = 10230;
const EV_TeleportFreeLevel = 10231;
const EV_CardUpdownGameStart = 10240;
const EV_CardUpdownGamePickResult = 10250;
const EV_CardUpdownGamePrepReward = 10260;
const EV_CardUpdownGameRewardReply = 10270;
const EV_CardUpdownGameQuit = 10280;
const EV_PledgeContributionRank = 10350;
const EV_PledgeContributionInfo = 10360;
const EV_PledgeContributionReward = 10370;
const EV_PledgeRaidRank = 10400;
const EV_PledgeRaidInfo = 10410;
const EV_PledgeLevelUp = 10420;
const EV_PledgeShowInfoUpdate = 10430;
const EV_PledgeMissionInfo = 10440;
const EV_PledgeMissionRewardCount = 10441;
const EV_GFX_ClanInfo = 10450;
const EV_GFX_ClanInfoEnd = 10451;
const EV_GFX_ClanInfoUpdate = 10460;
const EV_GFX_ClanDeleteAllMember = 10470;
const EV_GFX_ClanAddMember = 10480;
const EV_GFX_ClanAddMemberMultiple = 10490;
const EV_GFX_ClanDeleteMember = 10500;
const EV_GFX_ClanMemberInfoUpdate = 10510;
const EV_GFX_ClanMyAuth = 10520;
const EV_GFX_ClanAuth = 10530;
const EV_GFX_ClanAuthMember = 10540;
const EV_GFX_ClanAuthGradeList = 10550;
const EV_GFX_ClanSubClanUpdated = 10560;
const EV_GFX_ResultJoinDominionWar = 10570;
const EV_GFX_AskStartPledgeWar = 10580;
const EV_GFX_ClanCrestChange = 10590;
const EV_GFX_ClanMemberInfo = 10600;
const EV_GFX_ClanSkillList = 10610;
const EV_GFX_ClanSkillListRenew = 10620;
const EV_GFX_ClanWarList = 10630;
const EV_GFX_ClanClearWarList = 10640;
const EV_GFX_ReceivePledgeMemberList = 10650;
const EV_GFX_AskStopPledgeWar = 10660;
const EV_PledgeMasteryInfo = 10670;
const EV_PledgeMasterySet = 10680;
const EV_PledgeMasteryReset = 10690;
const EV_TutorialShowID = 10700;
const EV_PledgeSkillInfo = 10710;
const EV_PledgeSkillActivate = 10720;
const EV_PledgeItemList = 10730;
const EV_PledgeItemActivate = 10740;
const EV_PledgeAnnounce = 10750;
const EV_PledgeAnnounceSet = 10760;
const EV_PledgeCrestSet = 10770;
const EV_PledgeEmblemSet = 10780;
const EV_AllyCrestSet = 10790;
const EV_PledgeCreateShow = 10800;
const EV_PledgeItemInfo = 10810;
const EV_PledgeItemBuy = 10820;
const EV_DismissPledge = 10830;
const EV_OustPledge = 10840;
const EV_WithdrawPledge = 10850;
const EV_ElementalSpiritInfo = 10860;
const EV_ElementalSpiritExtractInfo = 10870;
const EV_ElementalSpiritExtract = 10871;
const EV_ElementalSpiritEvolutionInfo = 10880;
const EV_ElementalSpiritEvolution = 10890;
const EV_ElementalSpiritSetTalent = 10900;
const EV_ElementalSpiritAbsorbInfo = 10910;
const EV_ElementalSpiritAbsorb = 10920;
const EV_ElementalSpiritGetExp = 10930;
const EV_ElementalSpiritSimpleInfo = 10940;
const EV_LockedItemShow = 11000;
const EV_LockedResult = 11010;
const EV_OlympiadInfo = 11020;
const EV_OlympiadRecord = 11021;
const EV_OlympiadMatchInfo = 11022;
const EV_OlympiadMatchMakingResult = 11023;
const EV_NextTargetModeChange = 11030;
const EV_GFX_ItemAnnounce = 11040;
const EV_Enchant_Artifact_Result = 11050;
const EV_BloodyCoinCount = 11060;
const EV_PurchaseLimitShopListBegin = 11061;
const EV_PurchaseLimitShopItemInfo = 11062;
const EV_PurchaseLimitShopListEnd = 11063;
const EV_PurchaseLimitShopItemBuy = 11064;
const EV_ClassChangeAlarm = 11070;
const EV_ClassChangeFlagOff = 11071;
const EV_MagicLamp_ExpInfo = 11080;
const EV_MagicLamp_GameInfo = 11081;
const EV_MagicLamp_GameResult = 11082;
const EV_MyTargetIsDead = 11090;
const EV_MinimapTreasureBoxLocation = 11110;
const EV_ShowCursedBarrierInfo = 11120;
const EV_PremiumManagerWndLoadHtmlFromString = 11130;
const EV_PremiumManagerWndShow = 11131;
const EV_PaybackListBegin = 11140;
const EV_PaybackListInfo = 11141;
const EV_PaybackListEnd = 11142;
const EV_PaybackGiveReward = 11143;
const EV_PaybackUILauncher = 11144;
const EV_CounterAttackListAdded = 11150;
const EV_CounterAttackListEmpty = 11151;
const EV_CounterAttack = 11152;
const EV_DieInfoBegin = 11160;
const EV_DieInfoDropItem = 11161;
const EV_DieInfoDamage = 11162;
const EV_DieInfoEnd = 11163;
const EV_AutoplaySetting = 11170;
const EV_AutoplayDoMacro = 11171;
const EV_GachaShopInfo = 11180;
const EV_GachaShopGachaGroup = 11181;
const EV_GachaShopGachaItemBegin = 11182;
const EV_GachaShopGachaItemInfo = 11183;
const EV_GachaShopGachaItemEnd = 11184;
const EV_TimeRestrictFieldListStart = 11190;
const EV_TimeRestrictFieldInfo = 11200;
const EV_TimeRestrictFieldListEnd = 11210;
const EV_TimeRestrictFieldEnterResult = 11220;
const EV_TimeRestrictFieldChargeResult = 11230;
const EV_TimeRestrictFieldUserAlarm = 11240;
const EV_TimeRestrictFieldExit = 11250;
const EV_MyRankingDetailInfo = 11260;
const EV_MyRankingHistoryList = 11261;
const EV_CharacterRankingListBegin = 11270;
const EV_CharacterRankingInfo = 11271;
const EV_CharacterRankingListEnd = 11272;
const EV_ToggleCombatMode = 11280;
const EV_MCW_CastleInfo = 11300;
const EV_MCW_CastleSiegeHUDInfo = 11310;
const EV_MCW_CastleSiegeInfo = 11315;
const EV_MCW_CastleSiegeAttackerListStart = 11320;
const EV_MCW_CastleSiegeAttackerListItem = 11321;
const EV_MCW_CastleSiegeAttackerListEnd = 11322;
const EV_MCW_CastleSiegeDefenderListStart = 11330;
const EV_MCW_CastleSiegeDefenderListItem = 11331;
const EV_MCW_CastleSiegeDefenderListEnd = 11332;
const EV_PledgeMercenaryMemberListStart = 11340;
const EV_PledgeMercenaryMemberListItem = 11341;
const EV_PledgeMercenaryMemberListEnd = 11342;
const EV_PledgeMercenaryMemberJoin = 11350;
const EV_PvpbookListStart = 11360;
const EV_PvpbookListItem = 11370;
const EV_PvpbookListEnd = 11380;
const EV_PvpbookKillerLocation = 11390;
const EV_PvpbookNewPk = 11400;
const EV_UpdateWarMark = 11410;
const EV_UpdateTargetDead = 11420;
const EV_EquipItemTooltipClear = 11430;
const EV_SharedPositionAction = 11440;
const EV_GFX_TeleportFavoritesList = 11450;
const EV_XML_TeleportFavoritesList = 11451;
const EV_ShowHomunculusList = 11460;
const EV_ShowHomunculusBirthInfo = 11470;
const EV_PetSkillList = 11480;
const EV_PetAcquireSkillAlarm = 11481;
const EV_RequestEnemyPledgeRegister = 11490;
const EV_CollectionInfoEnd = 11500;
const EV_CollectionList = 11501;
const EV_CollectionUpdateFavorite = 11502;
const EV_CollectionFavoriteList = 11503;
const EV_CollectionSummary = 11504;
const EV_CollectionRegister = 11505;
const EV_CollectionComplete = 11506;
const EV_CollectionReceiveReward = 11507;
const EV_CollectionReset = 11508;
const EV_CollectionActiveEvent = 11509;
const EV_CollectionRegistEnableItem = 11510;
const EV_CollectionResetReward = 11511;
const EV_Hair2SlotEnable = 11520;
const EV_PenaltyItemListBegin = 11530;
const EV_PenaltyItemInfo = 11531;
const EV_PenaltyItemListEnd = 11532;
const EV_WorldCastleWarSiegeAttackerListStart = 11540;
const EV_WorldCastleWarSiegeAttackerList = 11541;
const EV_WorldCastleWarSiegeAttackerListEnd = 11542;
const EV_RequestInvitePartyAction = 11550;
const EV_RequestShowXMLDetailTooltip = 11555;
const EV_HideXMLDetailTooltip = 11560;
const EV_ScalingUI = 11570;
const EV_DisplayChanged = 11575;
const EV_ShowSimpleItemExchangeMultisellWnd = 11580;
const EV_DualInventoryInfo = 11590;
const EV_RequestDualInventorySwap = 11591;
const EV_UpdateMyAP = 11600;
const EV_UpdateMyMaxAP = 11601;
const EV_VipProductItemStart = 20140;
const EV_VipProductItem = 20141;
const EV_VipProductItemEnd = 20142;
const EV_VipLuckyGameInfo = 20143;
const EV_VipLuckyGameItemList = 20144;
const EV_VipLuckyGameResult = 20145;
const EV_VipInfo = 20150;
const EV_VipInfoRemainTime = 20151;
const EV_TodoListShow = 20160;
const EV_TodoList = 20161;
const EV_TodoListHTML = 20162;
const EV_TodoListRecommandRenew = 20163;
const EV_TodoListInzoneRenew = 20164;
const EV_TodoListRecommandEnd = 20165;
const EV_TodoListInzoneEnd = 20166;
const EV_OneDayRewardListStart = 20170;
const EV_OneDayRewardList = 20171;
const EV_OneDayRewardListEnd = 20172;
const EV_OneDayRewardItemListStart = 20173;
const EV_OneDayRewardItemList = 20174;
const EV_OneDayRewardItemListEnd = 20175;
const EV_ConnectedTimeAndGettableReward = 20176;
const EV_OneDayRewardCount = 20177;
const EV_SoulShotUpdate = 20180;
const EV_MyPetSummonEvent = 20181;
const EV_BeginSoulShotUpdate = 20182;
const EV_PledgeBonusOpen = 20190;
const EV_PledgeBonusList = 20191;
const EV_PledgeBonusMarkReset = 20192;
const EV_PledgeBonusUpdate = 20193;
const EV_PledgeClassicRaidInfo = 20194;
const EV_TeleportMapWndShow = 20200;
const EV_UserBanInfo = 20240;
const EV_CostumeUseItem = 20250;
const EV_CostumeChooseItem = 20251;
const EV_CostumeList = 20252;
const EV_CostumeEvolution = 20253;
const EV_CostumeExtract = 20254;
const EV_CostumeLock = 20255;
const EV_CostumeShortCutList = 20256;
const EV_CostumeFullList = 20257;
const EV_CostumeCollectSkillActive = 20258;
const EV_FestivalInfo = 20260;
const EV_FestivalAllItemInfo = 20270;
const EV_FestivalTopItemInfo = 20280;
const EV_FestivalGame = 20290;
const EV_QTReceiveCurRoomInfo = 20420;
const EV_QTReceiveClanRoomID = 20421;
const EV_VitalExInfo = 20430;
const EV_PkPenaltyInfoList = 20440;
const EV_NotifyWM_SetFocus = 20450;
const EV_UniqueGachaOpen = 20451;
const EV_PrivateShopFindOpen = 20460;
const EV_ProtocolBegin = 100000;
const EV_CustomUIEvent = 200000;
const EV_CustomProtocolBegin = 300000;
const MSIT_VITAL_POINT = -800;
const MSIT_CRAFT_POINT = -600;
const MSIT_RAID_POINT = -500;
const MSIT_FIELD_CYCLE_POINT = -400;
const MSIT_PVP_POINT = -300;
const MSIT_PLEDGE_POINT = -200;
const MSIT_PCCAFE_POINT = -100;
const MSIT_SP = -900;
const MSIT_DETHRONE_POINT = -1000;
const ESTT_NORMAL = 0;
const ESTT_FISHING = 1;
const ESTT_CLAN = 2;
const ESTT_SUB_CLAN = 3;
const ESTT_TRANSFORM = 4;
const ESTT_SUBJOB = 5;
const ESTT_COLLECT = 6;
const ESTT_BISHOP_SHARING = 7;
const ESTT_ELDER_SHARING = 8;
const ESTT_SILEN_ELDER_SHARING = 9;
const CLAN_AUTH_VIEW = 1;
const CLAN_AUTH_EDIT = 2;
const CLAN_MAIN = 0;
const CLAN_KNIGHT1 = 100;
const CLAN_KNIGHT2 = 200;
const CLAN_KNIGHT3 = 1001;
const CLAN_KNIGHT4 = 1002;
const CLAN_KNIGHT5 = 2001;
const CLAN_KNIGHT6 = 2002;
const CLAN_ACADEMY = -1;
const CLAN_KNIGHTHOOD_COUNT = 8;
const CLAN_MEMBERTYPE_COUNT = 2;
const CLAN_AUTH_GRADE1 = 1;
const CLAN_AUTH_GRADE2 = 2;
const CLAN_AUTH_GRADE3 = 3;
const CLAN_AUTH_GRADE4 = 4;
const CLAN_AUTH_GRADE5 = 5;
const CLAN_AUTH_GRADE6 = 6;
const CLAN_AUTH_GRADE7 = 7;
const CLAN_AUTH_GRADE8 = 8;
const CLAN_AUTH_GRADE9 = 9;
const DisabledByStat = 1;
const DisabledByItem = 2;
const DisabledByCost = 4;
const DisabledByCasterAbnormalState = 8;
const DisabledByTargetAbnormalState = 16;
const DisabledByUltimateSkillPoint = 32;
const BLACKCOUPON_OLDSERVER = 1000001;
const MAX_RELATED_QUEST = 10;
const MAX_INCLUDE_ITEM = 10;
const EIST_INVALID = 0;
const EIST_NORMAL = 1;
const EIST_BM = 2;
const EIST_MAX = 3;
const EISI_INVALID = -1;
const EISI_START = 1;
const EISI_MAX = 2;
const SBT_NONE = 0;
const SBT_UNDERWEAR = 1;
const SBT_REAR = 2;
const SBT_LEAR = 4;
const SBT_NECK = 8;
const SBT_RFINGER = 16;
const SBT_LFINGER = 32;
const SBT_HEAD = 64;
const SBT_RHAND = 128;
const SBT_LHAND = 256;
const SBT_GLOVES = 512;
const SBT_CHEST = 1024;
const SBT_LEGS = 2048;
const SBT_FEET = 4096;
const SBT_BACK = 8192;
const SBT_RLHAND = 16384;
const SBT_ONEPIECE = 32768;
const SBT_HAIR = 65536;
const SBT_ALLDRESS = 131072;
const SBT_HAIR2 = 262144;
const SBT_HAIRALL = 524288;
const SBT_RBRACELET = 1048576;
const SBT_LBRACELET = 2097152;
const SBT_DECO1 = 4194304;
const SBT_DECO2 = 8388608;
const SBT_DECO3 = 16777216;
const SBT_DECO4 = 33554432;
const SBT_DECO5 = 67108864;
const SBT_DECO6 = 134217728;
const SBT_WAIST = 268435456;
const SBT_BROOCH = 536870912;
const SBT_JEWEL1 = 1073741824;
const SBT_JEWEL2 = 2147483648;
const SBT_JEWEL3 = 4294967296;
const SBT_JEWEL4 = 8589934592;
const SBT_JEWEL5 = 17179869184;
const SBT_JEWEL6 = 34359738368;
const SBT_AGATHION_MAIN = 68719476736;
const SBT_AGATHION_SUB1 = 137438953472;
const SBT_AGATHION_SUB2 = 274877906944;
const SBT_AGATHION_SUB3 = 549755813888;
const SBT_AGATHION_SUB4 = 1099511627776;
const SBT_ARTIFACTBOOK = 2199023255552;
const SBT_ARTIFACT_A1 = 4398046511104;
const SBT_ARTIFACT_A2 = 8796093022208;
const SBT_ARTIFACT_A3 = 17592186044416;
const SBT_ARTIFACT_A4 = 35184372088832;
const SBT_ARTIFACT_A5 = 70368744177664;
const SBT_ARTIFACT_A6 = 140737488355328;
const SBT_ARTIFACT_A7 = 281474976710656;
const SBT_ARTIFACT_A8 = 562949953421312;
const SBT_ARTIFACT_A9 = 1125899906842624;
const SBT_ARTIFACT_A10 = 2251799813685248;
const SBT_ARTIFACT_A11 = 4503599627370496;
const SBT_ARTIFACT_A12 = 9007199254740992;
const SBT_ARTIFACT_B1 = 18014398509481984;
const SBT_ARTIFACT_B2 = 36028797018963968;
const SBT_ARTIFACT_B3 = 72057594037927936;
const SBT_ARTIFACT_C1 = 144115188075855872;
const SBT_ARTIFACT_C2 = 288230376151711744;
const SBT_ARTIFACT_C3 = 576460752303423488;
const SBT_ARTIFACT_D1 = 1152921504606846976;
const SBT_ARTIFACT_D2 = 2305843009213693952;
const SBT_ARTIFACT_D3 = 4611686018427387904;
const SSB_None = 0;
const SSB_Unacquirable = 1;
const SSB_Acquirable = 2;
const SSB_AcquirableNextLevel = 4;
const SSB_RegistShortcut = 8;
const SSB_Enchantable = 16;
const SSB_ActiveSkill = 32;
const AutoplayMacroSlotID = 276;
const AutoHPPotionSlotID = 277;
const AutoHPPetPotionSlotID = 278;
const AutoplayMacroSlotID2 = 279;
const VALIDATE_ENUM_MAX = 16;

enum EGMCommandType {
	GMCOMMAND_None,
	GMCOMMAND_StatusInfo,
	GMCOMMAND_ClanInfo,
	GMCOMMAND_SkillInfo,
	GMCOMMAND_QuestInfo,
	GMCOMMAND_InventoryInfo,
	GMCOMMAND_WarehouseInfo
};

enum ELanguageType {
	LANG_Korean, // 0
	LANG_English, // 1
	LANG_Japanese, // 2
	LANG_Taiwan, // 3
	LANG_Chinese, // 4
	LANG_Thai, // 5
	LANG_Philippine, // 6
	LANG_Indonesia, // 7
	LANG_Russia, // 8
	LANG_Euro, // 9
	LANG_Germany, // 10
	LANG_France, // 11
	LANG_Poland, // 12
	LANG_Turkey, // 13
	LANG_Spain // 14
};

enum EIMEType {
	IME_NONE, // 0
	IME_KOR, // 1
	IME_ENG, // 2
	IME_JPN, // 3
	IME_CHN, // 4
	IME_TAIWAN_CHANGJIE, // 5
	IME_TAIWAN_DAYI, // 6
	IME_TAIWAN_NEWPHONETIC, // 7
	IME_TAIWAN_BOSHAMY, // 8
	IME_CHN_MS, // 9
	IME_CHN_JB, // 10
	IME_CHN_ABC, // 11
	IME_CHN_WUBI, // 12
	IME_CHN_WUBI2, // 13
	IME_THAI, // 14
	IME_RUSSIA, // 15
	IME_GERMANY, // 16
	IME_FRANCE, // 17
	IME_POLAND, // 18
	IME_TURKEY, // 19
	IME_SPAIN // 20
};

enum EXMLControlType {
	XCT_None,
	XCT_FrameWnd,
	XCT_Button,
	XCT_TextBox,
	XCT_EditBox,
	XCT_TextureCtrl,
	XCT_ChatListBox,
	XCT_TabControl,
	XCT_ItemWnd,
	XCT_CheckBox,
	XCT_ComboBox,
	XCT_ProgressCtrl,
	XCT_MultiEdit,
	XCT_ListCtrl,
	XCT_ListBox,
	XCT_StatusBarCtrl,
	XCT_StatusRoundCtrl,
	XCT_NameCtrl,
	XCT_MinimapWnd,
	XCT_ShortcutItemWnd,
	XCT_XMLTreeCtrl,
	XCT_SliderCtrl,
	XCT_EffectButton,
	XCT_TextListBox,
	XCT_RadarWnd,
	XCT_HtmlViewer,
	XCT_RadioButton,
	XCT_InvenWeightWnd,
	XCT_StatusIconCtrl,
	XCT_BarCtrl,
	XCT_ScrollWnd,
	XCT_FishViewportWnd,
	XCT_VIPShopItemInfoWnd,
	XCT_VIPShopNeededItemWnd,
	XCT_DrawPanel,
	XCT_RadarMapCtrl,
	XCT_PropertyController,
	XCT_FlashCtrl,
	XCT_CharacterViewportWnd,
	XCT_SceneCameraCtrl,
	XCT_SceneNpcCtrl,
	XCT_ScenePcCtrl,
	XCT_SceneScreenCtrl,
	XCT_SceneMusicCtrl,
	XCT_RichListCtrl,
	XCT_EffectViewportWnd
};

enum ETrackerAlignType {
	TAT_Left,
	TAT_Center,
	TAT_Right,
	TAT_Width,
	TAT_Height
};

enum EControlPropertyGroupType {
	CPGT_None,
	CPGT_Single,
	CPGT_SingleRequired,
	CPGT_Multiple,
	CPGT_MultipleRequired,
	CPGT_Choice
};

enum EControlPropertyItemType {
	CPIT_None,
	CPIT_Boolean,
	CPIT_Integer,
	CPIT_String
};

enum EControlPropertyRestrictionType {
	CPRT_None,
	CPRT_Integer,
	CPRT_String
};

enum ETextLinkType {
	TLT_None,
	TLT_ServerItem,
	TLT_LocalItem,
	TLT_User,
	TLT_SKill,
	TLT_URL,
	TLT_SharedPosition,
	TLT_EmojiIcon,
	TLT_InviteParty,
	TLT_ChatMenuIcon
};

enum EControlOrderWay {
	COW_None,
	COW_Top,
	COW_Up,
	COW_Down,
	COW_Bottom
};

enum EProgressBarType {
	PBT_None,
	PBT_RightLeft,
	PBT_LeftRight,
	PBT_TopBottom,
	PBT_BottomTop
};

enum ETextureAutoRotateType {
	ETART_None,
	ETART_Camera,
	ETART_Pawn
};

enum EItemWindowType {
	ITEMWNDTYPE_ScrollType,
	ITEMWNDTYPE_SideButtonType,
	ITEMWNDTYPE_UpDownButtonType
};

enum EItemWindowIconDrawType {
	ITEMWND_IconDraw_Default,
	ITEMWND_IconDraw_NoConditionalEffect,
	ITEMWND_IconDraw_ShowNewlyAcquired
};

enum EAnchorPointType {
	ANCHORPOINT_None,
	ANCHORPOINT_TopLeft,
	ANCHORPOINT_TopCenter,
	ANCHORPOINT_TopRight,
	ANCHORPOINT_CenterLeft,
	ANCHORPOINT_CenterCenter,
	ANCHORPOINT_CenterRight,
	ANCHORPOINT_BottomLeft,
	ANCHORPOINT_BottomCenter,
	ANCHORPOINT_BottomRight
};

enum EStatisticUnitType {
	SUT_NONE,
	SUT_HOUR,
	SUT_MINUTE,
	SUT_SECOND,
	SUT_RAID,
	SUT_TIME
};

enum EMinimapTargetIcon {
	TARGET_QUEST,
	TARGET_ME
};

enum EMinimapRegionType {
	MRT_Castle,
	MRT_Fortress,
	MRT_Agit,
	MRT_HuntingZone_Base,
	MRT_Faction,
	MRT_HuntingZone_Mission,
	MRT_InstantZone,
	MRT_Raid,
	MRT_Quest,
	MRT_Etc
};

enum EQuestStatus {
	QuestStatus_None,
	QuestStatus_Doing,
	QuestStatus_Done
};

enum EAttributeType {
	ATTRIBUTE_FIRE,
	ATTRIBUTE_WATER,
	ATTRIBUTE_WIND,
	ATTRIBUTE_EARTH,
	ATTRIBUTE_HOLY,
	ATTRIBUTE_UNHOLY
};

enum EMixMagicType {
	MIXMAGICTYPE_DEFAULT,
	MIXMAGICTYPE_EARTHTOGGLE,
	MIXMAGICTYPE_WINDTOGGLE,
	MIXMAGICTYPE_WATERTOGGLE,
	MIXMAGICTYPE_FIRETOGGLE,
	MIXMAGICTYPE_HOLYTOGGLE,
	MIXMAGICTYPE_UNHOLYTOGGLE,
	MIXMAGICTYPE_APPLIEDSKILL,
	MIXMAGICTYPE_ALTERSKILL,
	MIXMAGICTYPE_EQUILTOGGLE,
	MIXMAGICTYPE_RAGETOGGLE,
	MIXMAGICTYPE_ULTIMATEMAX
};

enum EMPlayerPushCategory {
	MPPC_NONE,
	MPPC_AUTOPLAY_OFF,
	MPPC_DIE,
	MPPC_ATTACKED,
	MPPC_EMPTY_VITAL_CLASSIC,
	MPPC_EMPTY_VITAL
};

enum ESearchListType {
	SLT_FRIEND_LIST,
	SLT_PLEDGEMEMBER_LIST,
	SLT_ADDITIONALFRIEND_LIST,
	SLT_ADDITIONAL_LIST
};

enum EEventMatchObsMsgType {
	MESSAGE_GM,
	MESSAGE_Finish,
	MESSAGE_Start,
	MESSAGE_GameOver,
	MESSAGE_1,
	MESSAGE_2,
	MESSAGE_3,
	MESSAGE_4,
	MESSAGE_5
};

enum ETextAlign {
	TA_Undefined,
	TA_Left,
	TA_Center,
	TA_Right,
	TA_MacroIcon
};

enum ETextVAlign {
	TVA_Undefined,
	TVA_Top,
	TVA_Middle,
	TVA_Bottom
};

enum ETextureCtrlType {
	TCT_Stretch,
	TCT_Normal,
	TCT_Tile,
	TCT_Draggable,
	TCT_Control,
	TCT_Mask
};

enum ETextureLayer {
	TL_None,
	TL_Normal,
	TL_Background
};

enum ENameCtrlType {
	NCT_Normal,
	NCT_Item
};

enum EItemType {
	ITEM_WEAPON,
	ITEM_ARMOR,
	ITEM_ACCESSARY,
	ITEM_QUESTITEM,
	ITEM_ASSET,
	ITEM_ETCITEM
};

enum EItemParamType {
	ITEMP_WEAPON, // 0
	ITEMP_ARMOR, // 1
	ITEMP_SHIELD, // 2
	ITEMP_ACCESSARY, // 3
	ITEMP_ETC // 4
};

enum EEtcItemType {
	ITEME_NONE,
	ITEME_SCROLL, // 1
	ITEME_ARROW,
	ITEME_POTION,
	ITEME_SPELLBOOK,
	ITEME_RECIPE,
	ITEME_MATERIAL,
	ITEME_PET_COLLAR,
	ITEME_CASTLE_GUARD,
	ITEME_DYE,
	ITEME_SEED,
	ITEME_SEED2,
	ITEME_HARVEST,
	ITEME_LOTTO,
	ITEME_RACE_TICKET,
	ITEME_TICKET_OF_LORD,
	ITEME_LURE,
	ITEME_CROP,
	ITEME_MATURECROP,
	ITEME_ENCHT_WP, // 19
	ITEME_ENCHT_AM, // 20
	ITEME_BLESS_ENCHT_WP, // 21
	ITEME_BLESS_ENCHT_AM, // 22
	ITEME_COUPON,
	ITEME_ELIXIR,
	ITEME_ENCHT_ATTR,
	ITEME_ENCHT_ATTR_CURSED,
	ITEME_BOLT,
	ITEME_ENCHT_ATTR_INC_PROP_ENCHT_WP, // 28
	ITEME_ENCHT_ATTR_INC_PROP_ENCHT_AM, // 29
	ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_AM, // 30
	ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_WP, // 31
	ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM, // 32
	ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP, // 33
	ITEME_ENCHT_ATTR_RUNE,
	ITEME_ENCHT_ATTRT_RUNE_SELECT,
	ITEME_TELEPORTBOOKMARK,
	ITEME_CHANGE_ATTR,
	ITEME_SOULSHOT,
	ITEME_SHAPE_SHIFTING_WP,
	ITEME_BLESS_SHAPE_SHIFTING_WP,
	ITEME_SHAPE_SHIFTING_WP_FIXED,
	ITEME_SHAPE_SHIFTING_AM,
	ITEME_BLESS_SHAPE_SHIFTING_AM,
	ITEME_SHAPE_SHIFTING_AM_FIXED,
	ITEME_SHAPE_SHIFTING_HAIRACC,
	ITEME_BLESS_SHAPE_SHIFTING_HAIRACC,
	ITEME_SHAPE_SHIFTING_HAIRACC_FIXED,
	ITEME_RESTORE_SHAPE_SHIFTING_WP,
	ITEME_RESTORE_SHAPE_SHIFTING_AM,
	ITEME_RESTORE_SHAPE_SHIFTING_HAIRACC,
	ITEME_RESTORE_SHAPE_SHIFTING_ALLITEM,
	ITEME_BLESS_INC_PROP_ENCHT_WP,
	ITEME_BLESS_INC_PROP_ENCHT_AM,
	ITEME_CARD_EVENT,
	ITEME_SHAPE_SHIFTING_ALLITEM_FIXED,
	ITEME_MULTI_ENCHT_WP,
	ITEME_MULTI_ENCHT_AM,
	ITEME_MULTI_INC_PROB_ENCHT_WP,
	ITEME_MULTI_INC_PROB_ENCHT_AM,
	ITEME_ENSOUL_STONE,
	ITEME_NICK_COLOR_OLD,
	ITEME_NICK_COLOR_NEW,
	ITEME_ENCHT_AG,
	ITEME_BLESS_ENCHT_AG,
	ITEME_MULTI_ENCHT_AG,
	ITEME_ANCIENT_CRYSTAL_ENCHANT_AG,
	ITEME_INC_PROP_ENCHT_AG,
	ITEME_BLESS_INC_PROP_ENCHT_AG,
	ITEME_MULTI_INC_PROB_ENCHT_AG,
	ITEME_LOCK_ITEM,
	ITEME_UNLOCK_ITEM,
	ITEME_BULLET,
	ITEME_COSTUME_BOOK,
	ITEME_COSTUME_BOOK_RD_ALL,
	ITEME_COSTUME_BOOK_RD_PART,
	ITEME_COSTUME_BOOK_1,
	ITEME_COSTUME_BOOK_2,
	ITEME_COSTUME_BOOK_3,
	ITEME_COSTUME_BOOK_4,
	ITEME_COSTUME_BOOK_5,
	ITEME_MAGIC_LAMP,
	ITEME_POLY_ENCHANT_WP,
	ITEME_POLY_ENCHANT_AM,
	ITEME_POLY_INC_ENCHANT_PROP_WP,
	ITEME_POLY_INC_ENCHANT_PROP_AM,
	ITEME_CURSED_ENCHANT_WP,
	ITEME_CURSED_ENCHANT_AM,
	ITEME_VITAL_LEGACY_ITEM_1D,
	ITEME_VITAL_LEGACY_ITEM_7D,
	ITEME_VITAL_LEGACY_ITEM_30D,
	ITEME_BLESS_UPGRADE,
	ITEME_ORB,
	ITEME_ITEM_RESTORE_COIN,
	ITEME_SPECIAL_ENCHT_WP,
	ITEME_SPECIAL_ENCHT_AM,
	ITEME_NICK_COLOR_ICON,
	ITEME_TRADE_TICKET
};

enum ESkillCategory {
	SKILL_Active,
	SKILL_Passive
};

enum EActionCategory {
	ACTION_NONE,
	ACTION_BASIC,
	ACTION_PARTY,
	ACTION_TACTICALSIGN,
	ACTION_SOCIAL,
	ACTION_PET,
	ACTION_SUMMON,
	ACTION_SUMMON_DIRECT,
	ACTION_SUMMON_AI,
	ACTION_SUMMON_REACT,
	ACTION_SUMMON_SKILL
};

enum EXMLTreeNodeItemType {
	XTNITEM_BLANK,
	XTNITEM_TEXT,
	XTNITEM_TEXTURE
};

enum EServerAgeLimit {
	SERVER_AGE_LIMIT_15,
	SERVER_AGE_LIMIT_18,
	SERVER_AGE_LIMIT_Free
};

enum EInterfaceSoundType {
	IFST_CLICK1,
	IFST_CLICK2,
	IFST_CLICK_FAILED,
	IFST_PICKUP,
	IFST_TRASH_BASKET,
	IFST_WINDOW_OPEN,
	IFST_WINDOW_CLOSE, // 6
	IFST_QUEST_TUTORIAL,
	IFST_MINIMAP_OPEN_CLOSE,
	IFST_COOLTIME_END,
	IFST_PETITION,
	IFST_STATUSWND_OPEN,
	IFST_STATUSWND_CLOSE,
	IFST_INVENWND_OPEN,
	IFST_INVENWND_CLOSE,
	IFST_MAPWND_OPEN,
	IFST_MAPWND_CLOSE,
	IFST_SYSTEMWND_OPEN,
	IFST_SYSTEMWND_CLOSE,
	IFST_WORKSHOP_OPEN,
	IFST_WORKSHOP_CLOSE,
	IFST_SYSTEMWND_TELEAUTHFAIL
};

enum SayPacketType {
	SPT_NORMAL,
	SPT_SHOUT,
	SPT_TELL,
	SPT_PARTY,
	SPT_PLEDGE,
	SPT_SYSTEM,
	SPT_USER_PET,
	SPT_GM_PET,
	SPT_MARKET,
	SPT_ALLIANCE,
	SPT_ANNOUNCE,
	SPT_CUSTOM,
	SPT_L2_FRIEND,
	SPT_MSN_CHAT,
	SPT_PARTY_ROOM_CHAT,
	SPT_COMMANDER_CHAT,
	SPT_INTER_PARTYMASTER_CHAT,
	SPT_HERO,
	SPT_CRITICAL_ANNOUNCE,
	SPT_SCREEN_ANNOUNCE,
	SPT_DOMINIONWAR,
	SPT_MPCC_ROOM_CHAT,
	SPT_NPC_NORMAL,
	SPT_NPC_SHOUT,
	SPT_FRIEND_ANNOUNCE,
	SPT_WORLD,
	SPT_PLEDGE_INRAIDSERVER,
	SPT_ALLIANCE_INRAIDSERVER,
	SPT_CASTLEWAR_PLEDGE_COMMAND_MSG,
	SPT_WORLD_INRAIDSERVER
};

enum ESystemMsgType {
	SYSTEM_NONE,
	SYSTEM_BATTLE,
	SYSTEM_SERVER,
	SYSTEM_DAMAGE,
	SYSTEM_POPUP,
	SYSTEM_ERROR,
	SYSTEM_PETITION,
	SYSTEM_USEITEMS,
	SYSTEM_POPUPWITHMSG,
	SYSTEM_DAMAGETEXT,
	SYSTEM_CLIENT_DEBUG_MSG,
	SYSTEM_GETITEMS,
	SYSTEM_DICE,
	SYSTEM_ESSENTIAL
};

enum ESystemMsgParamType {
	SMPT_STRING,
	SMPT_NUMBER,
	SMPT_NPCID,
	SMPT_ITEMID,
	SMPT_SKILLID,
	SMPT_CASTLEID,
	SMPT_BIGNUMBER,
	SMPT_ZONENAME
};

enum EMoveType {
	MVT_NONE,
	MVT_SLOW,
	MVT_FAST
};

enum EEnvType {
	ET_NONE,
	ET_GROUND,
	ET_UNDERWATER,
	ET_AIR,
	ET_HOVER
};

enum EControlReturnType {
	CRTT_NO_CONTROL_USE,
	CRTT_CONTROL_USE,
	CRTT_USE_AND_HIDE
};

enum EShortCutItemType {
	SCIT_NONE,
	SCIT_ITEM,
	SCIT_SKILL,
	SCIT_ACTION,
	SCIT_MACRO,
	SCIT_RECIPE,
	SCIT_BOOKMARK,
	SCIT_ATTRIBUTE
};

enum EInventoryUpdateType {
	IVUT_NONE,
	IVUT_ADD,
	IVUT_UPDATE,
	IVUT_DELETE
};

enum RestartPoint {
	RESTART_VILLAGE,
	RESTART_AGIT,
	RESTART_CASTLE,
	RESTART_FORTRESS,
	RESTART_BATTLE_CAMP,
	RESTART_ORIGINAL_PLACE,
	RESTART_VILLAGE_BY_DISMOUNT,
	RESTART_ORIGINAL_PLACE_LIMIT,
	RESTART_ARENA,
	RESTART_VILLAGE_USING_ITEM,
	RESTART_DUMMY_10,
	RESTART_DUMMY_11,
	RESTART_DUMMY_12,
	RESTART_DUMMY_13,
	RESTART_DUMMY_14,
	RESTART_DUMMY_15,
	RESTART_DUMMY_16,
	RESTART_DUMMY_17,
	RESTART_DUMMY_18,
	RESTART_DUMMY_19,
	RESTART_BRANCH_START,
	RESTART_BY_AGATHION,
	RESTART_BY_NPC,
	RESURRECT_BY_SKILL,
	RESTART_NEARBY_BATTLE_FIELD,
	RESTART_TIME_FIELD_START_POS
};

enum ECastleSiegeDefenderType {
	CSDT_NOT_DEFENDER,
	CSDT_CASTLE_OWNER,
	CSDT_WAITING_CONFIRM,
	CSDT_APPROVED,
	CSDT_REJECTED
};

enum ETooltipSourceType {
	NTST_TEXT,
	NTST_ITEM,
	NTST_LIST,
	NTST_LIST_DRAWITEM
};

enum EBR_CashShopProduct {
	BRCSP_PRODUCT,
	BRCSP_RECENT,
	BRCSP_BASKET
};

enum EClassIconType {
	CICON_LEVEL_TWO_WARRIOR,
	CICON_LEVEL_TWO_ROGUE,
	CICON_LEVEL_TWO_ARCHER,
	CICON_LEVEL_TWO_FIGHTER,
	CICON_LEVEL_TWO_SONGDANCER,
	CICON_LEVEL_TWO_WIZARD,
	CICON_LEVEL_TWO_HEALER,
	CICON_LEVEL_TWO_SUMMONER,
	CICON_LEVEL_ONE_WARRIOR,
	CICON_LEVEL_ONE_WIZARD,
	CICON_LEVEL_THREE_WARRIOR,
	CICON_LEVEL_THREE_ROGUE,
	CICON_LEVEL_THREE_ARCHER,
	CICON_LEVEL_THREE_FIGHTER,
	CICON_LEVEL_THREE_SONGDANCER,
	CICON_LEVEL_THREE_WIZARD,
	CICON_LEVEL_THREE_HEALER,
	CICON_LEVEL_THREE_SUMMONER,
	CICON_LEVEL_FOUR_FIGHTER,
	CICON_LEVEL_FOUR_WARRIOR,
	CICON_LEVEL_FOUR_ROGUE,
	CICON_LEVEL_FOUR_ARCHER,
	CICON_LEVEL_FOUR_WIZARD,
	CICON_LEVEL_FOUR_ENCHANTER,
	CICON_LEVEL_FOUR_SUMMONER,
	CICON_LEVEL_FOUR_HEALER,
	CICON_LEVEL_FIVE_FIGHTER,
	CICON_LEVEL_FIVE_WARRIOR,
	CICON_LEVEL_FIVE_ROGUE,
	CICON_LEVEL_FIVE_ARCHER,
	CICON_LEVEL_FIVE_WIZARD,
	CICON_LEVEL_FIVE_ENCHANTER,
	CICON_LEVEL_FIVE_SUMMONER,
	CICON_LEVEL_FIVE_HEALER
};

enum EClassRoleType {
	ECRT_NONE,
	ECRT_KNIGHT,
	ECRT_WARRIOR,
	ECRT_ROGUE,
	ECRT_ARCHOR,
	ECRT_WIZARD,
	ECRT_SUMMONER,
	ECRT_ENCHANTER,
	ECRT_SUPPORT,
	ECRT_NOVICE,
	ECRT_SHAMAN,
	ECRT_BARD,
	ECRT_DEATHKNIGHT,
	ECRT_HUNTER
};

enum EItemInventoryType {
	EIIT_NONE,
	EIIT_EQUIPMENT,
	EIIT_CONSUMABLE,
	EIIT_MATERIAL,
	EIIT_ETC,
	EIIT_QUEST
};

enum ECharacterDeleteFailType {
	ECDFT_NONE,
	ECDFT_UNKNOWN,
	ECDFT_PLEDGE_MEMBER,
	ECDFT_PLEDGE_MASTER,
	ECDFT_PROHIBIT_CHAR_DELETION,
	ECDFT_COMMISSION,
	ECDFT_MENTOR,
	ECDFT_MENTEE,
	ECDFT_MAIL
};

enum ETimerCheckType
{
    ETCT_STEADYBOX
};

enum AttackType {
	AT_NONE,
	AT_SWORD,
	AT_TWOHANDSWORD,
	AT_BUSTER,
	AT_BLUNT,
	AT_TWOHANDBLUNT,
	AT_STAFF,
	AT_TWOHANDSTAFF,
	AT_DAGGER,
	AT_POLE,
	AT_FIST,
	AT_BOW,
	AT_ETC,
	AT_DUAL,
	AT_DUALFIST,
	AT_FISHINGROD,
	AT_RAPIER,
	AT_CROSSBOW,
	AT_ANCIENTSWORD,
	AT_FLAG,
	AT_DUALDAGGER,
	AT_OWNTHING,
	AT_TWOHANDCROSSBOW,
	AT_DUALBLUNT,
	AT_PISTOL,
	AT_SHOOTER,
	AT_MAX
};

enum ArmorType {
	AMT_NONE,
	AMT_LIGHT,
	AMT_HEAVY,
	AMT_MAGIC,
	AMT_SIGIL
};

enum EBlessPanelDrawType {
	BPDT_NEED_NONE,
	BPDT_NEED_BLESS,
	BPDT_NEED_NO_BLESS
};

enum EListCtlDrawItemType {
	LCDIT_TEXT,
	LCDIT_TEXTURE,
	LCDIT_BUTTON,
	LCDIT_ITEM,
	LCDIT_STATUS,
	LCDIT_SKILL
};

enum ESkillTraitType {
	ESkillTrait_None,
	ESkillTrait_Hold,
	ESkillTrait_Infection,
	ESkillTrait_Sleep,
	ESkillTrait_Shock,
	ESkillTrait_Paralyze,
	ESkillTrait_Seal,
	ESkillTrait_Pull,
	ESkillTrait_Silence,
	ESkillTrait_Fear,
	ESkillTrait_SlowDown,
	ESkillTrait_TurnStone,
	ESkillTrait_Disarm,
	ESkillTrait_Hate,
	ESkillTrait_PhysicalBlockade,
	ESkillTrait_RootPhysically,
	ESkillTrait_Deport,
	ESkillTrait_Bluff,
	ESkillTrait_Poison,
	ESkillTrait_Bleed,
	ESkillTrait_Changebody,
	ESkillTrait_Derangement,
	ESkillTrait_AirBind,
	ESkillTrait_WindStun,
	ESkillTrait_Psychic,
	ESkillTrait_KnockBack,
	ESkillTrait_KnockDown,
	ESkillTrait_Max
};

enum ESkillTargetType {
	ESkillTarget_None,
	ESkillTarget_Enemy,
	ESkillTarget_EnemyOnly,
	ESkillTarget_EnemyNot,
	ESkillTarget_Self,
	ESkillTarget_Summon,
	ESkillTarget_Target,
	ESkillTarget_TargetSelf,
	ESkillTarget_RealEnemyOnly,
	ESkillTarget_Max
};

enum ESkillAffectScope {
	ESkillAffect_None,
	ESkillAffect_Single,
	ESkillAffect_Party,
	ESkillAffect_Pledge,
	ESkillAffect_Fan,
	ESkillAffect_PointBlank,
	ESkillAffect_RangeSortByDist,
	ESkillAffect_RangeSortByHp,
	ESkillAffect_Range,
	ESkillAffect_Square,
	ESkillAffect_Range_sort_by_block_act,
	ESkillAffect_Fan_with_relation,
	ESkillAffect_Point_blank_with_relation,
	ESkillAffect_Range_with_relation,
	ESkillAffect_Square_with_relation,
	ESkillAffect_Max
};

enum ESkillConditionEquipType {
	SCET_NONE,
	SCET_SHIELD,
	SCET_WEAPON,
	SCET_MAX
};

enum E_CHARACTER_COLOR {
	ECC_NONE,
	ECC_RED,
	ECC_BLUE,
	ECC_PURPLE,
	ECC_MAX
};

enum EDrawItemType {
	DIT_BLANK,
	DIT_TEXT,
	DIT_TEXTURE,
	DIT_SPLITLINE,
	DIT_TEXTLINK,
	DIT_OVERLAY_TEXTURE,
	DIT_FORMATTEXT
};

enum EDrawItemAlignType {
	DIAT_LEFT,
	DIAT_CENTER,
	DIAT_RIGHT,
	DIAT_RIGHT_BOTTOM
};

enum EKeepType {
	EKT_NONE,
	EKT_INDIVIDUAL,
	EKT_PLEDGE,
	EKT_INDIVIDUAL_PLEDGE,
	EKT_CASTLE,
	EKT_INDIVIDUAL_CASTLE,
	EKT_PLEDGE_CASTLE,
	EKT_ALL,
	EKT_ACCOUNTSHARE,
	EKT_INDIVIDUAL_ACCOUNTSHARE,
	EKT_PLEDGE_ACCOUNTSHARE,
	EKT_INDIVIDUAL_PLEDGE_ACCOUNTSHARE,
	EKT_CASTLE_ACCOUNTSHARE,
	EKT_INDIVIDUAL_CASTLE_ACCOUNTSHARE,
	EKT_PLEDGE_CASTLE_ACCOUNTSHARE,
	EKT_ALL_ACCOUNTSHARE
};

enum EKeepSelectType {
	EKST_NORMAL,
	EKST_ENCHANT
};

enum EFactionRequsetType {
	FIRT_NONE,
	FIRT_SHOW,
	FIRT_REFRESH
};

enum EWebMethodType {
	EWMT_GET,
	EWMT_POST
};

enum EAutoNextTargetMode {
	ANTM_DEFAULT,
	ANTM_HOSTILE_NPC,
	ANTM_HOSTILE_PC,
	ANTM_FRIENDLY_NPC,
	ANTM_DEFAULT_AND_COUNTER_ATTACK,
	ANTM_MAX
};

enum EAutomaticUseItemType {
	AUIT_NONE,
	AUIT_ITEM,
	AUIT_HP_POTION,
	AUIT_HP_PET_POTION,
	AUIT_BOX,
	AUIT_MAX
};

enum EOnedayRewardCheckType {
	OneDayRCT_CHAR,
	OneDayRCT_ACCOUNT,
	OneDayRCT_MAX
};

enum EAutomaticUseSkillType {
	AUST_NONE,
	AUST_BUFF_SKILL,
	AUST_SEQUENTIAL_SKILL,
	AUST_PRIORITY_BUFF_SKILL,
	AUST_MAX
};

enum PLSHOP_RESET_TYPE {
	PLSHOP_RESET_ALWAYS,
	PLSHOP_RESET_ONEDAY,
	PLSHOP_RESET_ONEWEEK,
	PLSHOP_RESET_ONEMONTH,
	PLSHOP_RESET_TYPE_MAX
};

enum PLSHOP_EVENT_TYPE {
	PLSHOP_EVNET_NONE,
	PLSHOP_LIMITED_PERIOD
};

enum PLSHOP_BUY_RESULT_TYPE {
	PLSHOP_BUY_SUCCESS,
	PLSHOP_BUY_SYSTEM_FAIL,
	PLSHOP_BUY_NOT_ENOUGH_COST_ITEM,
	PLSHOP_BUY_NOT_ENOUGH_ITEM_AMOUNT,
	PLSHOP_BUY_NOT_ENOUGH_LEVEL,
	PLSHOP_BUY_NOT_EVENT_TIME,
	PLSHOP_BUY_NOT_ENOUGH_SERVER_ITEM_AMOUNT,
	PLSHOP_BUY_NOT_ENOUGH_INVENTORY,
	PLSHOP_BUY_NOT_ENOUGH_CARRY_WEIGHT,
	PLSHOP_BUY_NOT_ENOUGH_PLEDGE_LEVEL,
	PLSHOP_BUY_NOT_ALIVE,
	PLSHOP_BUY_RESULT_TYPE_MAX
};

enum PLSHOP_LIMIT_TYPE {
	PLSHOP_LIMIT_NONE,
	PLSHOP_LIMIT_CHARACTER,
	PLSHOP_LIMIT_ACCOUNT,
	PLSHOP_LIMIT_TYPE_MAX
};

enum ELCoinShopMarkType {
	LCoinShopMark_None,
	LCoinShopMark_Event,
	LCoinShopMark_Sale,
	LCoinShopMark_Best,
	LCoinShopMark_Limited,
	LCoinShopMark_New,
	LCoinShopMark_Relay,
	LCoinShopMark_Max
};

enum ELCoinShopFilterType {
	LCoinShopFilter_None,
	LCoinShopFilter_RareWeapon,
	LCoinShopFilter_NormalWeapon,
	LCoinShopFilter_RareArmor,
	LCoinShopFilter_HeavyArmor,
	LCoinShopFilter_LightArmor,
	LCoinShopFilter_Robe,
	LCoinShopFilter_Shield,
	LCoinShopFilter_Dye,
	LCoinShopFilter_Scroll,
	LCoinShopFilter_Etc,
	LCoinShopFilter_Belt,
	LCoinShopFilter_Elixir,
	LCoinShopFilter_Skillbook_S1,
	LCoinShopFilter_Skillbook_S2,
	LCoinShopFilter_Skillbook_S3,
	LCoinShopFilter_Max
};

enum HTML_OPEN_TYPE {
	OPEN_HTML_NONE_TYPE,
	OPEN_PCCAFE_HTML,
	OPEN_PLSHOP_HTML,
	OPEN_15EVENT_HTML,
	OPEN_LCOINSHOP_HTML,
	OPEN_PREMIUM_MANAGER,
	OPEN_PAYBACK_HELP_HTML,
	OPEN_EINHASAD_COIN_HTML,
	OPEN_HTML_MAX_TYPE
};

enum PAYBACK_EVENT_ID_TYPE {
	CR_EVENT_INVALID,
	CR_EVENT_LCOIN_2018,
	CR_EVENT_MAX
};

enum AttackerTypeEnum {
	ATTACKER_NONE,
	ATTACKER_NPC,
	ATTACKER_PC
};

enum DamageTypeEnum {
	DAMAGE_NONE,
	DAMAGE_NORMAL,
	DAMAGE_HEIGHT,
	DAMAGE_WATER,
	DAMAGE_SKILL,
	DAMAGE_SUICIDE,
	DAMAGE_AREA,
	DAMAGE_OVER_HIT,
	DAMAGE_POISON,
	DAMAGE_TRANSFER,
	DAMAGE_CHRONO,
	DAMAGE_CURSED_WEAPON_EXPIRED,
	DAMAGE_FIST,
	DAMAGE_SUICIDE_SKILL,
	DAMAGE_SHIELD,
	DAMAGE_EVENT,
	DAMAGE_END
};

enum GACHA_SHOP_RESULT_TYPE {
	GACHA_SHOP_GACHA_SUCESS,
	GACHA_SHOP_GACHA_SYSTEM_FAIL,
	GACHA_SHOP_NOT_ENOUGH_COST_ITEM,
	GACHA_SHOP_NOT_EVENT_TIME
};

enum RankingGroup {
	ServerGroup,
	RaceGroup,
	Pledge,
	Friends,
	ClassRankingGroup
};

enum RankingScope {
	TopN,
	AroundMe
};

enum RankingType {
	RANKTYPE_Character,
	RANKTYPE_Olympiad,
	RANKTYPE_Pledge,
	RANKTYPE_PVP,
	RANKTYPE_MAX
};

enum StatBonusType {
	SBT_STR,
	SBT_INT,
	SBT_DEX,
	SBT_WIT,
	SBT_CON,
	SBT_MEN,
	SBT_MAX
};

enum RaidNPCRespawnType {
	RNRT_NoUse,
	RNRT_Unknown,
	RNRT_AfterDeath,
	RNRT_SpecificTime,
	RNRT_SpecificDayTime,
	RNRT_MAX
};

enum RandomCraftAnnounceGrade {
	RCAG_None,
	RCAG_1,
	RCAG_2,
	RCAG_3
};

enum MableGameEventType {
	MGET_NONE,
	MGET_BACK,
	MGET_NEXT,
	MGET_WARP,
	MGET_PRISON,
	MGET_REWARD
};

enum PetEvolveConditionType {
	PECT_NONE,
	PECT_LEVEL
};

enum BlessOptionType {
	BOT_BASE,
	BOT_ENCHANT
};

enum EItemAnnounce {
	IA_ENCHANT,
	IA_REAR_ITEM,
	IA_CRAFT,
	IA_PURCHASE_LIMIT_SHOP,
	IA_RECIPE,
	IA_FESTIVAL,
	IA_PURCHASE_LIMIT_SERVER_CRAFT,
	IA_FIXED_REAR_ITEM,
	IA_COMBINATION,
	IA_PURCHASE_SPECIAL_CRAFT
};

enum EWorldCastleWarMapNPCType {
	WCWMNT_Occupy,
	WCWMNT_Door,
	WCWMNT_Golem
};

enum ECombinationAutomaticType {
	ECAT_NONE,
	ECAT_REPEAT,
	ECAT_GROWNUP,
	ECAT_LEVELUP,
	ECAT_MAX
};

enum EScalableSizeType {
	SSIZE_Type1,
	SSIZE_Type2,
	SSIZE_Type3
};

enum ValidateEnum {
	PDEFEND,
	MDEFEND,
	pAttack,
	mAttack,
	pAttackSpeed,
	mAttackSpeed,
	PSKILLSPEED,
	PHIT,
	MHIT,
	PCRITICAL,
	MCRITICAL,
	Speed,
	ShieldDefense,
	ShieldDefenseRate,
	pAvoid,
	mAvoid,
	Max
};

enum EStringMatchingItemFilter {
	SMIF_AllItem,
	SMIF_WorldExchangeItem
};

enum ENQuestType {
	NQT_NONE,
	NQT_ONETIME,
	NQT_DAILY,
	NQT_WEEKLY,
	NQT_REPEAT
};

enum EFireAbilityType {
	EFAT_PRIMAL_FIRE,
	EFAT_PRIMAL_LIFE,
	EFAT_PIECE_OF_FIRE,
	EFAT_TOTEM_OF_FIRE,
	EFAT_FIGHTING_SPIRIT
};


enum ECoinType 
{
	ERCT_ALL,
	ERCT_LCOIN,
	ERCT_ADENA,
};

struct DynamicContentInfo
{
	var string Title;
	var string Name;
	var string ToolTip;
	var int GoalCnt;
	var array<int> GoalID;
	var array<string> GoalDescription;
};

struct EventContentInfo
{
	var string Title;
	var string Name;
	var string ToolTip;
	var int GoalCnt;
	var array<int> GoalID;
	var array<string> GoalDescription;
};

struct ItemID
{
	var int ClassID;
	var int ServerID;
};

struct ToppingSkillExtraInfo
{
	var int Id;
	var int Level;
	var int SubLevel;
	var int SlotIndex;
	var bool bIsDefault;
};

struct AgitDecoPriceToken
{
	var int ItemClassID;
	var int Cnt;
};

struct AgitDecoNPCData
{
	var int DecoNpcId;
	var int NpcID;
	var int Level;
	var int FactionType;
	var int NpcType;
	var int NpcTypeIdx;
	var int SubType;
	var int SubTypeIdx;
	var INT64 PriceAdena;
	var array<AgitDecoPriceToken> PriceToken;
	var int Period;
	var string Desc;
};

struct AgitDecoNPCTypeList
{
	var int NpcType;
	var int NpcTypeIdx;
};

struct EnsoulOptionInfo
{
	var array<int> OptionArray;
};

struct ItemInfo
{
	var ItemID Id;
	var string Name;
	var string AdditionalName;
	var string IconName;
	var string IconNameEx1;
	var string IconNameEx2;
	var string IconNameEx3;
	var string IconNameEx4;
	var string ForeTexture;
	var string Description;
	var string DragSrcName;
	var string IconPanel;
	var string IconPanel2;
	var int DragSrcReserved;
	var string MacroCommand;
	var int ItemType;
	var int EtcItemType;
	var int ShortcutType;
	var INT64 ItemNum;
	var INT64 Price;
	var int Level;
	var int SubLevel;
	var INT64 SlotBitType;
	var int Weight;
	var int MaterialType;
	var int WeaponType;
	var float pDefense;
	var float mDefense;
	var float pAttack;
	var float mAttack;
	var float pAttackSpeed;
	var float mAttackSpeed;
	var float pHitRate;
	var float mHitRate;
	var float pCriRate;
	var float mCriRate;
	var float MoveSpeed;
	var float ShieldDefense;
	var float ShieldDefenseRate;
	var float pAvoid;
	var float mAvoid;
	var INT64 n64DefaultPriceFromScript;
	var int nGrindPoint;
	var int nGrindCommission;
	var int Durability;
	var int CrystalType;
	var int RandomDamage;
	var int MpConsume;
	var int ArmorType;
	var int Damaged;
	var int Enchanted;
	var int MpBonus;
	var int SoulshotCount;
	var int SpiritshotCount;
	var int PopMsgNum;
	var int BodyPart;
	var int RefineryOp1;
	var int RefineryOp2;
	var int CurrentDurability;
	var int CurrentPeriod;
	var int Reserved;
	var INT64 Reserved64;
	var INT64 DefaultPrice;
	var int ConsumeType;
	var int Blessed;
	var INT64 AllItemCount;
	var int IconIndex;
	var bool bEquipped;
	var bool bRecipe;
	var bool bArrow;
	var bool bShowCount;
	var int bDisabled;
	var int iSkillDisabled;
	var bool bSecurityLockable;
	var bool bSecurityLock;
	var int AttackAttributeType;
	var int AttackAttributeValue;
	var int DefenseAttributeValueFire;
	var int DefenseAttributeValueWater;
	var int DefenseAttributeValueWind;
	var int DefenseAttributeValueEarth;
	var int DefenseAttributeValueHoly;
	var int DefenseAttributeValueUnholy;
	var int RelatedQuestID[10];
	var int ReuseDelayShareGroupID;
	var int Attribution;
	var bool IsToggleSkill;
	var bool IsToggle;
	var int IsBRPremium;
	var int IncludeItem[10];
	var int BR_CurrentEnergy;
	var int BR_MaxEnergy;
	var int LookChangeIconID;
	var int LookChangeItemID;
	var string LookChangeItemName;
	var string LookChangeIconPanel;
	var EnsoulOptionInfo EnsoulOption[2];
	var int ORDER;
	var string tooltipTexutre;
	var string tooltipBGTexture;
	var string tooltipBGTextureCompare;
	var string tooltipBGDecoTexture;
	var int CurUseCount;
	var int MaxUseCount;
	var float RemainReuseDelay;
	var float MaxReuseDelay;
	var float ReceivedAppSec;
	var bool IsNewlyAcquired;
	var bool bAutomaticUseActivated;
	var int nKeepType;
	var bool bIsTradeAble;
	var bool bIsDropAble;
	var bool bIsDesturctAble;
	var bool bIsPrivateType;
	var bool bIsNpcTradeAble;
	var bool bIsAuctionAble;
	var bool bSimpleExchangeItem;
	var bool IsBlessedItem;
	var int EnchantBlessGroupID;
	var int PetEvolveStep;
	var int PetNamePrefixID;
	var int PetNameID;
	var int PetID;
	var INT64 PetExp;
	var INT64 nDBDeleteDate;
	var bool IsCreateItem;
	var int SortOrder;
	var UIEventManager.EBlessPanelDrawType BlessPanelDrawType;
	var int AuctionCategory;
	var int HeroBookPoint;
	var byte Grade;
	var byte SkillStateBitflag;
};

struct LVTexture
{
	var Texture objTex;
	var int X;
	var int Y;
	var int Width;
	var int Height;
	var int U;
	var int V;
	var int UL;
	var int VL;
	var bool IsFront;
};

struct LVData
{
	var bool hasIcon;
	var int nsortPrior;
	var bool iconPostion;
	var string szData;
	var string szReserved;
	var string HiddenStringForSorting;
	var int FirstLineOffsetX;
	var UIEventManager.ETextAlign textAlignment;
	var bool bUseTextColor;
	var Color TextColor;
	var int nReserved1;
	var int nReserved2;
	var int nReserved3;
	var string AttrStat[6];
	var array<LVTexture> AttrIconTexArray;
	var Color AttrColor;
	var string szTexture;
	var int nTextureWidth;
	var int nTextureHeight;
	var int nTextureU;
	var int nTextureV;
	var int IconPosX;
	var string iconBackTexName;
	var int backTexOffsetXFromIconPosX;
	var int backTexOffsetYFromIconPosY;
	var int backTexWidth;
	var int backTexHeight;
	var int backTexUL;
	var int backTexVL;
	var string iconPanelName;
	var int panelOffsetXFromIconPosX;
	var int panelOffsetYFromIconPosY;
	var int panelWidth;
	var int panelHeight;
	var int panelUL;
	var int panelVL;
	var string foreTextureName;
	var string LookChangeiconPanelName;
	var array<LVTexture> arrTexture;
	var int nStatusBarCurrentCount;
	var int nStatusBarMaxCount;
	var string BlessedItemIconPanelName;
};

struct LVDataRecord
{
	var array<LVData> LVDataList;
	var string szReserved;
	var INT64 nReserved1;
	var INT64 nReserved2;
	var INT64 nReserved3;
	var bool bUseStatusBar;
	var int nStatusBarIndex;
	var string strStatusBarForeLeftTex;
	var string strStatusBarForeCenterTex;
	var string strStatusBarForeRightTex;
	var string strStatusBarBackLeftTex;
	var string strStatusBarBackCenterTex;
	var string strStatusBarBackRightTex;
	var int nStatusBarWidth;
	var int nStatusBarHeight;
};

struct StringDrawItem
{
	var string FontName;
	var string strData;
	var Color strColor;
	var bool bStrNewLine;
};

struct TextureDrawItem
{
	var string sTex;
	var int Width;
	var int Height;
	var int U;
	var int V;
	var int UL;
	var int VL;
};

struct ButtonDrawItem
{
	var string strID;
	var TextureDrawItem highlightTex;
	var TextureDrawItem normalTex;
	var TextureDrawItem pushedTex;
};

struct ItemDrawItem
{
	var ItemInfo ItemInfo;
	var int Width;
	var int Height;
};

struct StatusDrawItem
{
	var int Width;
	var int Height;
	var string Text;
	var string FontName;
	var Color FontColor;
	var int FontSize;
	var bool bNewLine;
	var string sBackLeftTex;
	var string sBackCenterTex;
	var string sBackRightTex;
	var string sForeLeftTex;
	var string sForeCenterTex;
	var string sForeRightTex;
	var string sOverLeftTex;
	var string sOverCenterTex;
	var string sOverRightTex;
	var int TexWidth;
	var int TexHeight;
	var float ForeProgress;
	var float OverProgress;
};

struct RichListCtrlDrawItem
{
	var UIEventManager.EListCtlDrawItemType eType;
	var bool bNotScalable;
	var int nPosX;
	var int nPosY;
	var int nReservedTooltipID;
	var string TooltipDesc;
	var string TooltipTypeString;
	var StringDrawItem strInfo;
	var TextureDrawItem texInfo;
	var ButtonDrawItem btnInfo;
	var ItemDrawItem ItemInfo;
	var StatusDrawItem statusInfo;
};

struct RichListCtrlCellData
{
	var string HiddenStringForSorting;
	var int iSortPrior;
	var string szData;
	var string szReserved;
	var int nReserved1;
	var int nReserved2;
	var int nReserved3;
	var array<RichListCtrlDrawItem> drawitems;
};

struct RichListCtrlRowData
{
	var array<RichListCtrlCellData> cellDataList;
	var string sOverlayTex;
	var int OverlayTexU;
	var int OverlayTexV;
	var bool ForceRefreshTooltip;
	var string szReserved;
	var INT64 nReserved1;
	var INT64 nReserved2;
	var INT64 nReserved3;
};

struct UserInfo
{
	var int nID;
	var string Name;
	var string strNickName;
	var string RealName;
	var int nSex;
	var int Race;
	var int Class;
	var int nLevel;
	var int nClassID;
	var int nSubClass;
	var INT64 nSP;
	var int nCurHP;
	var int nMaxHP;
	var int nCurMP;
	var int nMaxMP;
	var int nCurCP;
	var int nMaxCP;
	var INT64 nCurExp;
	var int nUserRank;
	var int nClanID;
	var int nAllianceID;
	var int nCarryWeight;
	var int nCarringWeight;
	var int nPhysicalAttack;
	var int nPhysicalDefense;
	var int nHitRate;
	var int nCriticalRate;
	var int nPhysicalAttackSpeed;
	var int nPhysicalSkillCastingSpeed;
	var int nMagicalAttack;
	var int nMagicDefense;
	var int nMagicAvoid;
	var int nMagicHitRate;
	var int nMagicCriticalRate;
	var int nPhysicalAvoid;
	var int nWaterMaxSpeed;
	var int nWaterMinSpeed;
	var int nAirMaxSpeed;
	var int nAirMinSpeed;
	var int nGroundMaxSpeed;
	var int nGroundMinSpeed;
	var float fNonAttackSpeedModifier;
	var int nMagicCastingSpeed;
	var int nAddPAttack;
	var int nAddMAttack;
	var int nStr;
	var int nDex;
	var int nCon;
	var int nInt;
	var int nWit;
	var int nMen;
	var int nLuc;
	var int nCha;
	var int nTotalBonus;
	var int nStrBonus;
	var int nDexBonus;
	var int nConBonus;
	var int nIntBonus;
	var int nWitBonus;
	var int nMenBonus;
	var int nStrAdditional;
	var int nDexAdditional;
	var int nConAdditional;
	var int nIntAdditional;
	var int nWitAdditional;
	var int nMenAdditional;
	var int nCriminalRate;
	var int nDualCount;
	var int nPKCount;
	var int nVoteCount;
	var int nBonusCount;
	var int nNegativeVoteCount;
	var int nNotoriety;
	var int nNobless;
	var bool bHero;
	var bool bLegend;
	var bool bNpc;
	var bool bPet;
	var bool bCanBeAttacked;
	var bool m_bPawnChanged;
	var bool WantHideName;
	var Vector Loc;
	var int AttrAttackType;
	var int AttrAttackValue;
	var int AttrDefenseValFire;
	var int AttrDefenseValWater;
	var int AttrDefenseValWind;
	var int AttrDefenseValEarth;
	var int AttrDefenseValHoly;
	var int AttrDefenseValUnholy;
	var int nTransformID;
	var int nInvenLimit;
	var int PvPPointRestrain;
	var int PvPPoint;
	var int RaidPoint;
	var Color NicknameColor;
	var int nVitality;
	var int nVitalBonus;
	var int nVitalItem;
	var int nMasterID;
	var int nTalismanNum;
	var int nJewelNum;
	var int nAgathionMainNum;
	var int nAgathionSubNum;
	var int nArtifactGroupNum;
	var int nFullArmor;
	var int JoinedDominionID;
	var int DominionIDForVirtualName;
	var float fExpPercentRate;
	var int UltimateSkillPoint;
	var int TacticSign;
	var int nRemainAbilityPoint;
	var int nFireAttack;
	var int nWaterAttack;
	var int nWindAttack;
	var int nEarthAttack;
	var int nFireDefend;
	var int nWaterDefend;
	var int nWindDefend;
	var int nEarthDefend;
	var int nDyeChargeAmount;
	var bool bRaidBattleBuff;
	var int nActivatedElixirPoint;
	var int nOrcRiderShapeLevel;
	var int nWorldID;
};

struct SkillInfo
{
	var string SkillName;
	var string SkillDesc;
	var int SkillID;
	var int SkillLevel;
	var int SkillSubLevel;
	var int OperateType;
	var int MpConsume;
	var int HpConsume;
	var int CastRange;
	var int CastStyle;
	var float HitTime;
	var float CoolTime;
	var float ReuseDelay;
	var bool IsUsed;
	var int IsMagic;
	var int IsDouble;
	var string AnimName;
	var string SkillPresetName;
	var string TexName;
	var string IconPanel;
	var string IconPanel2;
	var int IconType;
	var int Debuff;
	var string EnchantName;
	var string EnchantDesc;
	var int Enchanted;
	var int EnchantSkillLevel;
	var string EnchantIcon;
	var int RumbleSelf;
	var int RumbleTarget;
	var int MagicType;
	var bool LevelHide;
	var int DpConsume;
	var int EnergyConsume;
	var INT64 DBDeleteDate;
	var int AbnormalTime;
	var UIEventManager.ESkillTraitType TraitType;
	var UIEventManager.ESkillTargetType TargetType;
	var UIEventManager.ESkillAffectScope AffectScope;
	var int Grade;
};

struct PetInfo
{
	var int nServerID;
	var int nClassID;
	var string Name;
	var int nLevel;
	var INT64 nSP;
	var int nCurHP;
	var int nMaxHP;
	var int nCurMP;
	var int nMaxMP;
	var INT64 nCurExp;
	var INT64 nMaxExp;
	var INT64 nMinExp;
	var int nCarryWeight;
	var int nCarringWeight;
	var int nPhysicalAttack;
	var int nPhysicalDefense;
	var int nHitRate;
	var int nCriticalRate;
	var int nPhysicalAttackSpeed;
	var int nPhysicalSkillCastingSpeed;
	var int nPhysicalAvoid;
	var int nMagicalAttack;
	var int nMagicDefense;
	var int nMagicalAvoid;
	var int nMagicalHitRate;
	var int nMagicalCritical;
	var int nMovingSpeed;
	var int nMagicCastingSpeed;
	var int nSoulShotCosume;
	var int nSpiritShotConsume;
	var int nFatigue;
	var int nMaxFatigue;
	var int PetOrSummoned;
	var int nPetID;
	var int nEvolutionID;
	var int nEvolutionStep;
	var int nEvolutionLook;
	var int nEvolutionNamePrefixID;
	var int nEvolutionNameID;
};

struct SummonInfo
{
	var int nServerID;
	var int nClassID;
	var string Name;
	var int nLevel;
	var INT64 nSP;
	var int nCurHP;
	var int nMaxHP;
	var int nCurMP;
	var int nMaxMP;
	var INT64 nCurExp;
	var INT64 nMaxExp;
	var INT64 nMinExp;
	var int nCarryWeight;
	var int nCarringWeight;
	var int nPhysicalAttack;
	var int nPhysicalDefense;
	var int nHitRate;
	var int nCriticalRate;
	var int nPhysicalAttackSpeed;
	var int nPhysicalSkillCastingSpeed;
	var int nMagicalAttack;
	var int nMagicDefense;
	var int nMagicalHitRate;
	var int nMagicalAvoid;
	var int nMagicalCritical;
	var int nPhysicalAvoid;
	var int nMovingSpeed;
	var int nMagicCastingSpeed;
	var int nSoulShotCosume;
	var int nSpiritShotConsume;
	var int nFatigue;
	var int nMaxFatigue;
	var int PetOrSummoned;
	var int nEvolutionID;
};

struct MacroInfo
{
	var int Id;
	var string Name;
	var string IconName;
	var string IconTextureName;
	var int IconSkillId;
	var string Description;
	var string CommandList[20];
};

struct MacroPresetInfo
{
	var int Id;
	var string Name;
	var string IconName;
	var string IconTextureName;
	var string Description;
	var string PresetDescription;
	var string CommandList[20];
};

struct Rect
{
	var int nX;
	var int nY;
	var int nWidth;
	var int nHeight;
};

struct ClanMemberInfo
{
	var int clanType;
	var string sName;
	var int Level;
	var int ClassID;
	var int gender;
	var int Race;
	var int Id;
	var int bActive;
	var int bHaveMaster;
};

struct ClanInfo
{
	var array<ClanMemberInfo> m_array;
	var string m_sName;
	var string m_sMasterName;
};

struct ResolutionInfo
{
	var int nWidth;
	var int nHeight;
	var int nColorBit;
};

struct FileNameInfo
{
	var string Filename;
	var bool bIsFile;
};

struct DriveInfo
{
	var string driveChar;
};

struct KeepSelectInfo
{
	var UIEventManager.EKeepSelectType KeepSelectType;
	var int KeepEnchantCondition;
	var UIEventManager.EKeepType KeepOption1;
	var UIEventManager.EKeepType KeepOption2;
};

struct TextSectionInfo
{
	var Color TextColor;
	var int pos;
};

struct DrawItemInfo
{
	var UIEventManager.EDrawItemType eType;
	var int nOffSetX;
	var int nOffSetY;
	var bool bLineBreak;
	var int b_nHeight;
	var int t_ID;
	var string t_strText;
	var Color t_color;
	var bool t_bDrawOneLine;
	var int t_MaxWidth;
	var array<TextSectionInfo> t_SectionList;
	var string t_strFontName;
	var int u_nTextureWidth;
	var int u_nTextureHeight;
	var int u_nTextureUWidth;
	var int u_nTextureUHeight;
	var int u_nTextureU;
	var int u_nTextureV;
	var string u_strTexture;
	var string Condition;
	var UIEventManager.EDrawItemAlignType eAlignType;
};

struct CustomTooltip
{
	var int MinimumWidth;
	var int SimpleLineCount;
	var array<DrawItemInfo> DrawList;
};

struct XMLTreeNodeItemInfo
{
	var UIEventManager.EXMLTreeNodeItemType eType;
	var int nOffSetX;
	var int nOffSetY;
	var bool bLineBreak;
	var bool bStopMouseFocus;
	var int b_nHeight;
	var int t_nTextID;
	var string t_strText;
	var Color t_color;
	var bool t_bDrawOneLine;
	var UIEventManager.ETextVAlign t_vAlign;
	var int t_nMaxHeight;
	var int t_nMaxWidth;
	var int u_nTextureWidth;
	var int u_nTextureHeight;
	var int u_nTextureUWidth;
	var int u_nTextureUHeight;
	var string u_strTexture;
	var string u_strTextureMouseOn;
	var string u_strTextureExpanded;
	var int nReserved;
	var int nReserved2;
};

struct XMLTreeNodeInfo
{
	var string strName;
	var int nOffSetX;
	var int nOffSetY;
	var int bDrawBackground;
	var int bTexBackHighlight;
	var int nTexBackHighlightHeight;
	var int nTexBackWidth;
	var int nTexBackUWidth;
	var int nTexBackOffSetX;
	var int nTexBackOffSetY;
	var int nTexBackOffSetBottom;
	var string strTexExpandedLeft;
	var string strTexExpandedRight;
	var int nTexExpandedOffSetX;
	var int nTexExpandedOffSetY;
	var int nTexExpandedHeight;
	var int nTexExpandedRightWidth;
	var int nTexExpandedLeftUWidth;
	var int nTexExpandedLeftUHeight;
	var int nTexExpandedRightUWidth;
	var int nTexExpandedRightUHeight;
	var int bShowButton;
	var int nTexBtnWidth;
	var int nTexBtnHeight;
	var int nTexBtnOffSetX;
	var int nTexBtnOffSetY;
	var string strTexBtnExpand;
	var string strTexBtnCollapse;
	var string strTexBtnExpand_Over;
	var string strTexBtnCollapse_Over;
	var CustomTooltip ToolTip;
	var bool bFollowCursor;
};

struct StatusIconInfo
{
	var int ServerID;
	var string Name;
	var string IconName;
	var string IconPanel;
	var int Size;
	var string Description;
	var string BackTex;
	var int RemainTime;
	var ItemID Id;
	var int Level;
	var int SubLevel;
	var bool bOwnership;
	var bool bShow;
	var bool bShortItem;
	var bool bEtcItem;
	var int Debuff;
	var int SpellerID;
	var bool bHideRemainTime;
};

struct GameTipData
{
	var int Id;
	var int Priority;
	var int TargetLevel;
	var bool Validity;
	var string TipMsg;
	var string TipImg;
};

struct HennaInfo
{
	var int HennaID;
	var int ClassID;
	var int Num;
	var int Fee;
	var int CanUse;
	var int INTnow;
	var int INTchange;
	var int STRnow;
	var int STRchange;
	var int CONnow;
	var int CONchange;
	var int MENnow;
	var int MENchange;
	var int DEXnow;
	var int DEXchange;
	var int WITnow;
	var int WITchange;
	var int LUCnow;
	var int LUCchange;
	var int CHAnow;
	var int CHAchange;
};

struct EventMatchUserData
{
	var int UserID;
	var string UserName;
	var int HPNow;
	var int HPMax;
	var int MPNow;
	var int MPMax;
	var int CPNow;
	var int CPMax;
	var int UserLv;
	var int UserClass;
	var int UserGender;
	var int UserRace;
	var array<int> BuffIDList;
	var array<int> BuffRemainList;
};

struct EventMatchTeamData
{
	var int Score;
	var string TeamName;
	var int PartyMemberCount;
	var EventMatchUserData User[9];
};

struct ShortcutCommandItem
{
	var string sCommand;
	var string Key;
	var string subkey1;
	var string subkey2;
	var string sState;
	var string sCategory;
	var string sAction;
	var int Id;
};

struct ShortcutScriptData
{
	var int Id;
	var string sCommand;
	var int sysString;
	var int sysMsg;
};

struct EventMatchData
{
	var EventMatchTeamData Team[2];
};

struct RequestItem
{
	var int Id;
	var INT64 Amount;
};

struct PartyMemberInfo
{
	var int CreatureID;
	var string Name;
	var int CurHP;
	var int MaxHP;
	var int curMP;
	var int maxMP;
	var int curCP;
	var int maxCP;
	var int vitality;
	var int ClassID;
	var int Level;
	var bool curHavePet;
	var int curSummonNum;
	var int iSubstitute;
};

struct PartyMemberPetInfo
{
	var int CreatureID;
	var int PetID;
	var int petClassID;
	var int Type;
	var int petHP;
	var int petMaxHP;
	var int petMP;
	var int petMaxMP;
};

struct PartyMemberSummonedInfo
{
	var int CreatureID;
	var int summonedID;
	var int summonedClassID;
	var int Type;
	var int summonedHP;
	var int summonedMaxHP;
	var int summonedMP;
	var int summonedMaxMP;
};

struct AlchemyDataInfo
{
	var int SkillID;
	var int SkillLevel;
	var int SkillMaxLevel;
	var bool GradeType;
	var int CategoryType;
	var int StringID;
	var array<int> RecipeItemClassIDs;
	var array<int> RecipeItemNums;
	var int ResultItemClassID;
	var int ResultItemNum;
};

struct CommissionPremiumItemInfo
{
	var int commissionItemId;
	var string commissionItemName;
	var int commissionPeriod;
	var int commissionExpired;
	var int commissionDiscountInfoType;
	var int commissionDiscountInfo;
};

struct ProductItem
{
	var int iItemID;
	var int iAmount;
	var int iWeight;
	var int iTradable;
	var string strDesc;
};

struct ProductInfo
{
	var int iProductID;
	var int iCategory;
	var int iPaymentType;
	var int iShowTab;
	var int iPanel_Type;
	var int iMinLevel;
	var int iMaxLevel;
	var int iMinBirthday;
	var int iMaxBirthday;
	var int iRestrictionDay;
	var int iAvailableCount;
	var int iSale_Percent;
	var int iPrice;
	var string strName;
	var string strIconName;
	var int iDayWeek;
	var int iStartSale;
	var int iEndSale;
	var int iStartHour;
	var int iStartMin;
	var int iEndHour;
	var int iEndMin;
	var int iStock;
	var int iMaxStock;
	var bool bLimited;
	var bool bEnable;
	var bool bMyShopBasketEnable;
	var string strDesc;
	var string strMainSubject;
	var array<ProductItem> itemarray;
};

struct L2UserFactionUIInfo
{
	var int nFactionID;
	var int nFactionLevel;
	var float fFactionPointRate;
	var bool bIsFactionLevelLimited;
	var bool bIsFactionRewardIcon;
};

struct L2FactionLevelUIData
{
	var int nFactionLevel;
	var string strIconTexture;
	var array<int> arrQuestID;
	var array<int> arrQuestLevel;
	var array<string> arrQuestName;
	var array<string> arrFactionRewardTitle;
	var array<string> arrFactionRewardDesc;
	var array<int> arrFactionRewardGroup;
};

struct L2FactionUIData
{
	var int nFactionID;
	var string strFactionName;
	var string strEmblemTexture;
	var string strEmblemBigTexture;
	var string strFactionDesc;
	var array<string> arrFactionNPCName;
	var array<int> arrFactionAreaZoneID;
	var array<string> arrFactionAreaName;
	var array<int> arrFactionAreaLevel;
	var int nRegionID;
	var int nMonsterbookUse;
	var array<L2FactionLevelUIData> arrLevelData;
};

struct L2MonsterBookUIData
{
	var int nMonsterBookID;
	var int nSortOrder;
	var int nNpcID;
	var int nNpcLevel;
	var string strNpcName;
	var string strNpcNick;
	var INT64 nNpcHP;
	var INT64 nNpcMP;
	var array<int> arrNpcProperty;
	var int nTrophyLevel;
	var int nTrophyCount;
	var int nTrophyMax;
	var array<int> arrDropItemID;
	var array<string> arrDropItemName;
	var string strCardTexture;
	var string strCardPanel;
	var int nZoneID;
	var string strZoneName;
	var int nFactionID;
	var string strFactionName;
	var string strFactionEmblem;
	var array<int> arrRewardFP;
	var array<INT64> arrRewardExp;
	var array<int> arrRewardSP;
	var array<int> arrRewardItem1;
	var array<int> arrRewardItem2;
	var array<int> arrRewardItem3;
	var array<int> arrRewardItem4;
	var int nViewX;
	var int nViewY;
	var float fViewScale;
	var int nViewRot;
	var int nViewDist;
};

struct OfferingItemList
{
	var int nItemID;
	var INT64 nAmount;
};

struct MinimapRegionIconData
{
	var string strIconNormal;
	var string strIconOver;
	var string strIconPushed;
	var int nWorldLocX;
	var int nWorldLocY;
	var int nWorldLocZ;
	var int nWidth;
	var int nHeight;
	var int nIconOffsetX;
	var int nIconOffsetY;
	var int nDescOffsetX;
	var int nDescOffsetY;
	var string strDescFontName;
	var bool bIgnoreMouseInput;
};

struct MinimapRegionInfo
{
	var UIEventManager.EMinimapRegionType eType;
	var int nIndex;
	var string strDesc;
	var Color DescColor;
	var string strTooltip;
	var MinimapRegionIconData IconData;
};

struct HuntingZoneUIData
{
	var string strName;
	var int nType;
	var int nMinLevel;
	var int nMaxLevel;
	var Vector nWorldLoc;
	var int nSearchZoneID;
	var int nRegionID;
	var int nNpcID;
	var array<int> arrQuestIDs;
	var int nInstantZoneID;
};

struct EventAlarmUIData
{
	var int nEventID;
	var int nEventType;
	var string strNotifyIcon;
	var string strTitle;
	var int nStartDate;
	var int nEndDate;
	var int nStartTime;
	var int nEndTime;
	var int nActivateTime;
	var int nDeactivateTime;
	var array<int> nEventDay;
	var string strEventDesc;
	var int nIntTimeStart;
	var int nIntTimeEnd;
};

struct L2UITime
{
	var int nYear;
	var int nMonth;
	var int nDay;
	var int nHour;
	var int nMin;
	var int nSec;
	var int nWeekDay;
	var int nYDay;
};

struct WebRequestParam
{
	var bool bNeedUrlEncode;
	var string strKey;
	var string strValue;
};

struct WebRequestInfo
{
	var UIEventManager.EWebMethodType eMethodType;
	var string strRequestUrl;
	var string strNPAuthTokenLoginUrl;
	var array<WebRequestParam> arrRequestParams;
	var array<WebRequestParam> arrHeaderParams;
};

struct TutorialIndex
{
	var int Id;
	var int Category;
	var int LevelCount;
	var string Name;
	var int ORDER;
};

struct TutorialBody
{
	var string Description;
	var int DisplayType;
};

struct PledgeLevelData
{
	var int PledgeLevel;
	var int NeedPledgeExp;
	var int NumGeneral;
	var string MeritDesc;
	var array<string> OpenContents;
	var array<int> SellingItemList;
	var array<string> SkillNameList;
};

struct PledgeMissionRewardItem
{
	var int ItemClassID;
	var int ItemCount;
};

struct PledgeMissionCondition
{
	var int PledgeLevel;
	var string PledgeMasteryName;
	var int MinLevel;
	var int MaxLevel;
	var bool JobMain;
	var bool JobDual;
	var bool JobSub;
	var int PreMissionID;
	var int StartDate;
	var int EndDate;
	var int StartTime;
	var int EndTime;
	var int ActivateTime;
	var int DeactivateTime;
	var array<int> AvailableDays;
};

struct PledgeMissionUIData
{
	var int MissionID;
	var int Category;
	var bool IsRepeat;
	var string MissionName;
	var PledgeMissionCondition Condition;
	var string GoalDesc;
	var int GoalCount;
	var int RewardPledgeNameValue;
	var int RewardPVPPoint;
	var array<PledgeMissionRewardItem> RewardItems;
};

struct PledgeDonationData
{
	var int DonationType;
	var array<PledgeMissionRewardItem> PersonalRewards;
	var array<PledgeMissionRewardItem> PledgeRewards;
	var int DonationItem;
	var INT64 DonationItemAmount;
};

struct ArtifactUIData
{
	var int ArtifactItemID;
	var int EnchantSkillID;
	var int MaxSkillLevel;
};

struct AutoplaySettingData
{
	var bool IsAutoPlayOn;
	var bool IsPickupOn;
	var UIEventManager.EAutoNextTargetMode NextTargetMode;
	var bool IsNearTargetMode;
	var int HPPotionPercent;
	var int HPPetPotionPercent;
	var bool IsMannerModeOn;
	var bool IsClientRequest;
	var byte MacroIndex;
};

struct LCoinShopBuyItemInfo
{
	var int ItemClassID;
	var int Count;
	var string ProductName;
	var int LevelMin;
	var int LevelMax;
};

struct LCoinShopProductUIData
{
	var int ProductID;
	var int Category;
	var UIEventManager.ELCoinShopMarkType MarkType;
	var array<LCoinShopBuyItemInfo> BuyItems;
	var int ProductType;
	var UIEventManager.PLSHOP_LIMIT_TYPE LimitType;
	var UIEventManager.PLSHOP_RESET_TYPE ResetType;
	var int LimitCountMax;
	var int ServerCountMax;
	var string ProductDesc;
	var string ProductHtm;
	var string HeadLine;
};

struct LCoinShopBannerUIData
{
	var string TextureName;
	var string LinkURL;
};

struct PurchaseLimitCraftBuyItemInfo
{
	var int ItemClassID;
	var int Count;
	var float Prob;
	var int Enchant;
	var int ProductRank;
	var bool IsLimitServer;
};

struct PurchaseLimitCraftUIData
{
	var int ShopIndex;
	var int ProductID;
	var int Category;
	var int CategorySub;
	var UIEventManager.ELCoinShopMarkType MarkType;
	var int MaxBuyCount;
	var string ProductName;
	var int ProductItemClassID;
	var int ProductItemEnchant;
	var array<PurchaseLimitCraftBuyItemInfo> BuyItems;
	var int LevelMin;
	var int LevelMax;
	var UIEventManager.PLSHOP_LIMIT_TYPE LimitType;
	var UIEventManager.PLSHOP_RESET_TYPE ResetType;
	var int LimitCountMax;
	var int ServerCountMax;
	var int LimitServerBuyCountMax;
	var array<int> RequirementBuySkills;
	var bool KeepOption;
	var array<PurchaseLimitCraftBuyItemInfo> KeepOptionFee;
};

struct PledgeShopBuyItemInfo
{
	var int ItemClassID;
	var int Count;
	var float Prob;
};

struct PledgeShopProductUIData
{
	var int ShopIndex;
	var int ProductID;
	var string ProductName;
	var int ProductItemClassID;
	var array<PledgeShopBuyItemInfo> BuyItems;
	var int LevelMin;
	var int LevelMax;
	var int PledgeLevelMin;
	var int PledgeLevelMax;
	var UIEventManager.PLSHOP_LIMIT_TYPE LimitType;
	var UIEventManager.PLSHOP_RESET_TYPE ResetType;
	var int LimitCountMax;
	var int ServerCountMax;
	var string ProductDesc;
};

struct L2GachaShopItemInfo
{
	var int ClassID;
	var int Count;
};

struct L2GachaShopGroupItemInfo
{
	var L2GachaShopItemInfo ItemInfo;
	var float ItemProb;
};

struct L2GachaShopGroupUIData
{
	var int GroupID;
	var float GroupProb;
	var array<L2GachaShopItemInfo> PickCosts;
	var int TitleItemClassID;
	var array<L2GachaShopGroupItemInfo> ItemList;
};

struct L2GachaShopUIData
{
	var int ShopID;
	var array<L2GachaShopItemInfo> RollCosts;
};

struct TimeRestrictFieldUIData
{
	var string Type;
	var int FieldId;
	var string FieldName;
	var string Desc;
	var array<int> RefillItemList;
	var int Category;
	var string FieldImage;
	var int PvpType;
	var bool IsEvent;
	var string TimeInfo;
};

struct LetterCollectUIData
{
	var int Id;
	var array<int> LetterItemIDs;
};

struct StatBonusNameUIData
{
	var UIEventManager.StatBonusType Type;
	var int Grade;
	var string Desc;
};

struct ServerInfoUIData
{
	var int ServerID;
	var int ServerExtID;
	var string ServerName;
	var bool IsClassicServer;
	var bool IsArenaServer;
	var bool IsBroadCastServer;
	var bool IsAdenServer;
	var bool IsBloodyServer;
	var bool IsTestServer;
	var bool IsWorldRaidServer;
};

struct SharedPositionData
{
	var int SharingCostLCoin;
	var int UsingCostLCoin;
	var int UsingMaxCount;
};

struct MableGameCellRewardItem
{
	var int ItemClassID;
	var int ItemCount;
};

struct MableGameCellData
{
	var int CellColor;
	var string CellName;
	var array<MableGameCellRewardItem> RewardItems;
};

struct MableGameEventData
{
	var string EventGroupDesc;
	var string EventDesc;
};

struct EvolveCondition
{
	var int ConditionType;
	var int Value;
};

struct PetNameInfo
{
	var int NameID;
	var int SkillID;
	var int SkillLevel;
	var string Name;
	var string Desc;
};

struct PetLookInfo
{
	var int LookID;
	var string Name;
	var string Desc;
};

struct ActionUIData
{
	var int Id;
	var int Category;
	var string Icon;
	var string Name;
	var string Desc;
};

struct BlessOptionData
{
	var int OptionType;
	var int EnchantedValue;
	var string OptionDesc;
};

struct EnchantBlessScrollUIData
{
	var int ScrollItemClassID;
	var float Probability;
	var array<int> EnchantableGroupIDs;
};

struct PetAcquireSkillInfo
{
	var bool bEnable;
	var int SkillID;
	var int SkillLevel;
	var int NeedPetEvolveStep;
	var int NeedPetLevel;
	var array<RequestItem> NeedItem;
};

struct PetExtractInfo
{
	var INT64 ExtractExp;
	var int ExtractItemClassID;
	var RequestItem DefaultExtractCost;
	var RequestItem ExtractCost;
};

struct L2PetRaceEmblemUIData
{
	var int PetID;
	var string RaceName;
	var string EmblemTexName;
};

struct CollectionOption
{
	var string Name;
	var bool diff;
	var float Value;
};

struct CollectionSlotItem
{
	var int ItemID;
	var int ItemCount;
	var int EnchantCondition;
	var int BlessCondition;
	var int SlotID;
	var bool Representative;
	var int ReplaceID;
};

struct CollectionRewardItem
{
	var int ItemID;
	var int ItemCount;
};

struct CollectionRewardSkill
{
	var int SkillID;
	var int SkillLevel;
};

struct CollectionData
{
	var int collection_ID;
	var string collection_name;
	var int main_category;
	var int Period;
	var int option_id;
	var array<CollectionOption> Option_filter;
	var array<CollectionSlotItem> SlotItems;
	var array<CollectionRewardItem> RewardItems;
	var array<CollectionRewardSkill> RewardSkills;
	var string startDateTime;
	var string endDateTime;
};

struct CollectionMainData
{
	var int main_id;
	var int background_level;
	var int Category;
	var int collection_ID;
	var int key_item_id;
	var int key_effect;
};

struct CollectionItemInfo
{
	var int nItemClassID;
	var bool bBless;
	var int Enchant;
	var int Amount;
	var int BlessCondition;
};

struct CollectionInfo
{
	var CollectionItemInfo ItemInfo[6];
	var bool isFavorite;
	var bool isReward;
	var int RemainTime;
	var bool isActiveEvent;
};

struct CollectionCount
{
	var int CollectionTotalCount;
	var int CollectionCompleteCount;
	var int CollectionProgressCount;
	var int SlotTotalCount;
	var int SlotRegistCount;
};

struct L2CharacterAbilityUIData
{
	var string Category;
	var string Detail;
	var bool IsPercent;
	var string TooltipDesc;
};

struct SubjugationData
{
	var int Id;
	var string Name;
	var string Desc;
	var string Banner;
	var int MinLevel;
	var int MaxLevel;
	var int MaxSubjugationPoint;
	var int MaxGachaPoint;
	var int MaxPeriodicGachaPoint;
	var int GachaCostItem;
	var int GachaCostNum;
	var int MaxUsePoint;
	var int TeleportID;
	var array<int> Cycle;
	var array<int> HotTimes;
	var array<int> ShowGachaMain;
	var array<int> ShowGachaSub;
	var array<int> RewardRank1;
	var array<int> RewardRank2;
	var array<int> RewardRank3;
	var array<int> RewardRank4;
	var array<int> RewardRank5;
};

struct L2PassRewardData
{
	var int PassType;
	var int RewardIndex;
	var int FreeRewardType;
	var int FreeRewardItemID;
	var int FreeRewardItemCnt;
	var int PaidRewardType;
	var int PaidRewardItemID;
	var int PaidRewardItemCnt;
};

struct L2PassRewardTotalData
{
	var int PassType;
	var int IsPaid;
	var int ItemID;
	var int ItemCurrCnt;
	var int ItemMaxCnt;
};

struct L2PassAdvanceData
{
	var int nIndex;
	var int nAdvanceType;
	var string AdvanceTypeName;
	var array<int> arrTargetItem;
	var array<int> arrTargetEnchantValue;
	var string Desc;
};

struct DethroneDailyMissionData
{
	var string Name;
	var int Id;
	var int GoalCount;
	var string ProgressDetailDesc;
};

struct UniqueGachaItemInfo
{
	var int RankType;
	var int ItemType;
	var INT64 Amount;
	var float fProb;
};

struct UniquegachaGameTypeInfo
{
	var int GameCount;
	var INT64 CostItemAmount;
};

struct RangedIDData
{
	var int Id;
	var int Min;
	var int Max;
};

struct NickNameItemData
{
	var int Id;
	var array<RangedIDData> Color;
	var array<RangedIDData> Icon;
};

struct DyePotentialUIData
{
	var int DyePotentialID;
	var int DyeSlotID;
	var int MaxSkillLevel;
	var int SkillID;
	var string EffectName;
};

struct DyePotentialExpUIData
{
	var int DyePotentialLevel;
	var int Exp;
};

struct DyePotentialEnchantExp
{
	var int Exp;
	var float Prob;
};

struct DyePotentialUpgradeItemInfo
{
	var int ItemClassID;
	var int ItemCount;
};

struct DyePotentialFeeUIData
{
	var int EnchantFeeStep;
	var int DailyCount;
	var array<DyePotentialEnchantExp> EnchantExps;
	var array<DyePotentialUpgradeItemInfo> UpgradeItemInfos;
};

struct DyeCombinationUIData
{
	var int SlotOneItemID;
	var int SlotTwoItemID;
	var int Commission;
	var float Prob;
};

struct WorldCastleWarMapData
{
	var int NpcType;
	var int ClassID;
	var int Tier;
	var Vector Location;
};

struct CombinationResultItem
{
	var int ClassID;
	var int Enchant;
	var int Num;
	var int Display;
	var int Prob;
};

struct CombinationItemUIData
{
	var int GroupID;
	var int AutomaticType;
	var int Level;
	var int MaxLevel;
	var int SlotOneClassID;
	var int SlotOneEnchant;
	var int SlotTwoClassID;
	var int SlotTwoEnchant;
	var array<CombinationResultItem> ResultItems;
	var int IsNoFail;
	var int ResultEffectType2;
	var INT64 Commission;
};

struct EnchantValidateUIData
{
	var float EnchantValue[16];
	var float PropertyValue[16];
};

struct EnchantRangeData
{
	var int RangeMin;
	var int RangeMax;
	var int RandomValue;
};

struct EnchantScrollSetUIData
{
	var byte ScrollSetID;
	var byte FailureBase;
	var byte FailureDecrease;
	var bool FailureMaintain;
	var bool FailureCrush;
	var int IncBaseMin;
	var int IncBaseMax;
	var byte GreatSuccessEffect;
	var array<EnchantRangeData> EnchantRangeDatas;
	var array<byte> EnchantGroupIDs;
};

struct EnchantChallengePointSettingUIData
{
	var byte MaxPoint;
	var byte MaxTicketCharge;
	var byte ProbInc1Fee;
	var byte ProbInc2Fee;
	var byte OverUpProbFee;
	var byte NumResetProbFee;
	var byte NumDownProbFee;
	var byte NumProtectProbFee;
};

struct EnchantOptionData
{
	var float Prob;
	var int RangeMin;
	var int RangeMax;
};

struct EnchantOverUpValue
{
	var byte Value;
	var float Prob;
};

struct EnchantOverUpData
{
	var array<EnchantOverUpValue> OverUps;
	var int RangeMin;
	var int RangeMax;
};

struct EnchantChallengePointUIData
{
	var byte PointGroupID;
	var EnchantOptionData ProbInc1;
	var EnchantOptionData ProbInc2;
	var EnchantOverUpData OverUpProb;
	var EnchantOptionData NumResetProb;
	var EnchantOptionData NumDownProb;
	var EnchantOptionData NumProtectProb;
};

struct VariationOptionProbData
{
	var int OptionID;
	var string Probablity;
};

struct VariationProbUIData
{
	var array<VariationOptionProbData> Options;
};

struct MagicLampResultItemUIData
{
	var int ItemClassID;
	var int Exp;
	var int Sp;
	var float Probability;
};

struct CreateResultItemData
{
	var string ItemName;
	var string AdditionalName;
	var string Prob;
	var int Count;
	var int EnchantValue;
	var byte NameClass;
};

struct ItemCreateUIData
{
	var array<CreateResultItemData> Items;
	var byte Category;
};

struct BalrogwarUIData
{
	var int Level;
	var int MinPlayerPt;
	var int EventBeginPt;
	var int normal_1st_midboss_pt;
	var int normal_2nd_midboss_pt;
	var int normal_final_boss_pt;
	var int specail_final_boss_pt;
};

struct MissionRewardItem
{
	var int RewardLevel;
	var int ItemClassID;
	var int Amount;
};

struct MissionLevelUIData
{
	var int SeasonDate;
	var int SeasonRemainTime;
	var int LimitLevel;
	var array<MissionRewardItem> BaseRewardItems;
	var array<MissionRewardItem> KeyRewardItems;
	var MissionRewardItem SpecialRewardItem;
	var MissionRewardItem ExtraRewardItem;
};

struct WorldExchangeUIData
{
	var array<int> UseableServerIDs;
	var int UseableLevel;
	var int RegistFee;
	var int MaxSellFee;
	var byte SellFee;
};

struct HeroBookData
{
	var int BookSkillID;
	var int BookSkillLevel;
	var int PrevSkillID;
	var int PrevSkillLevel;
	var int NextSkillID;
	var int NextSkillLevel;
	var int SuccessItemID;
	var int SuccessItemCount;
	var int SuccessSkillID;
	var int SuccessSkillLevel;
	var int Commission;
	var int MaxPoint;
};

struct HeroBookListData
{
	var int Id;
	var int BookSkillID;
	var int BookSkillLevel;
	var int SuccessItemID;
	var int SuccessItemCount;
	var int SuccessSkillID;
	var int SuccessSkillLevel;
};

struct DyePotentialSlotFeeUIData
{
	var int DyeSlotID;
	var int DyePotentialMinLevel;
	var int DyePotentialMaxLevel;
	var array<DyePotentialFeeUIData> DyePotentialFeeUIDataList;
};

struct PrisonUIData
{
	var int PrisonType;
	var int MinPKCount;
	var int MaxPKCount;
	var int DonationAdena;
	var RequestItem NeedItem;
	var int HoldingMinute;
};

struct RecoveryCouponCategoryData
{
	var int Category;
	var int SysStringId;
};

struct RecoveryCouponData
{
	var array<RecoveryCouponCategoryData> Categories;
	var int TitleSysstringId;
	var int DefaultMultisellId;
	var int ExtraMultisellId;
	var array<int> ExtraMultisellServers;
};

struct ItemExchangeMultisellUIData
{
	var int MultisellID;
	var string MultisellName;
};

struct PledgeCrestPresetUIData
{
	var int Id;
	var string CrestTexName;
};

struct AbilityItemUIData
{
	var int AbilityID;
	var int AbilityLev;
	var int RequireAbilityID;
	var int RequireCount;
	var string Name;
	var string Icon;
	var string IconPanel;
	var array<string> LevelDesc;
};

struct NQuestNPCData
{
	var int Id;
	var int TeleportID;
	var Vector Location;
};

struct NQuestGoalData
{
	var string Name;
	var int Num;
};

struct NQuestRewardItemData
{
	var int ItemClassID;
	var int Amount;
};

struct NQuestRewardData
{
	var int Level;
	var int Exp;
	var int Sp;
	var array<NQuestRewardItemData> Items;
};

struct NQuestUIData
{
	var int Id;
	var UIEventManager.ENQuestType Type;
	var string Name;
	var array<int> ClassFilter;
	var array<int> PreQuestIDs;
	var int LevelMin;
	var int LevelMax;
	var int QuestItem;
	var int StartItem;
	var int TeleportID;
	var Vector Location;
	var NQuestNPCData StartNPC;
	var NQuestNPCData EndNPC;
	var NQuestGoalData Goal;
	var NQuestRewardData Reward;
};

struct NQuestDialogUIData
{
	var int QuestID;
	var string StartDialog;
	var string AcceptDialog;
	var string CompleteDialog;
	var string EndDialog;
	var string QuestInfo;
};

struct NQuestNpcPortraitUIData
{
	var int NpcID;
	var int ViewOffsetX;
	var int ViewOffsetY;
	var int ViewOffsetZ;
	var int ViewDist;
	var int ViewRotationYaw;
	var float ViewScale;
};

struct ChargeExpItem
{
	var ItemInfo item;
	var int ChargeExp;
	var int commissionItemId;
	var INT64 CommissionCount;
	var byte GroupID;
};

struct SkillAcquireData
{
	var INT64 ConsumeSP;
	var INT64 ConsumeAdena;
	var int ConsumePriorityItemID;
	var int ConsumePriorityItemCount;
	var int ConsumeItemID;
	var int ConsumeItemCount;
	var int MultisellGroupID;
	var int SystemMsgID;
	var byte Level;
	var byte GetLevel;
	var byte CategoryIndex;
};

struct L2ItemAmount
{
	var int ItemClassID;
	var int ItemAmount;
};

struct DethroneShopUIData
{
	var int Id;
	var L2ItemAmount item;
	var array<L2ItemAmount> NeedItemList;
};

struct FireAbilityLevelupInfoUIData
{
	var int Level;
	var int Exp;
	var array<L2ItemAmount> ExpUpCostItem;
	var int ExpUpAmount;
	var float ExpUpSuccessRate;
	var array<L2ItemAmount> LevelUpCost;
	var array<L2ItemAmount> ExpUpSuccessReward;
	var array<string> SkillEffect;
};

struct FireAbilityUIData
{
	var UIEventManager.EFireAbilityType Type;
	var int DailyExpUpCount;
	var int DailyInitCount;
	var array<L2ItemAmount> DailyInitCost;
	var int MaxLevel;
	var array<FireAbilityLevelupInfoUIData> LevelupInfo;
};

struct FireAbilityComboEffectUIData
{
	var int Level;
	var string Title;
	var array<string> DescriptionList;
};

// Export UUIEventManager::execExecuteEvent(FFrame&, void* const)
native function ExecuteEvent(int a_EventID, optional string a_Param);

// Export UUIEventManager::execParamAdd(FFrame&, void* const)
native function ParamAdd(out string strParam, string strName, string strValue);

// Export UUIEventManager::execParamAddINT64(FFrame&, void* const)
native function ParamAddINT64(out string strParam, string strName, INT64 sValue);

// Export UUIEventManager::execParseString(FFrame&, void* const)
native function bool ParseString(string a_strCmd, string a_strMatch, out string a_strResult);

// Export UUIEventManager::execParseInt(FFrame&, void* const)
native function bool ParseInt(string a_strCmd, string a_strMatch, out int a_Result);

// Export UUIEventManager::execParseINT64(FFrame&, void* const)
native function bool ParseINT64(string a_strCmd, string a_strMatch, out INT64 a_Result);

// Export UUIEventManager::execParseFloat(FFrame&, void* const)
native function bool ParseFloat(string a_strCmd, string a_strMatch, out float a_Result);

// Export UUIEventManager::execParamToItemInfo(FFrame&, void* const)
native function ParamToItemInfo(string param, out ItemInfo Info);

// Export UUIEventManager::execItemInfoToParam(FFrame&, void* const)
native function ItemInfoToParam(ItemInfo Info, out string param);

// Export UUIEventManager::execRegisterEvent(FFrame&, void* const)
native function RegisterEvent(int ev);

// Export UUIEventManager::execRegisterState(FFrame&, void* const)
native function RegisterState(string WindowName, string State);

// Export UUIEventManager::execSetUIState(FFrame&, void* const)
native function SetUIState(string State);

// Export UUIEventManager::execMessageBox(FFrame&, void* const)
native function MessageBox(string Msg);

// Export UUIEventManager::execSMessageBox(FFrame&, void* const)
native function SMessageBox(int SystemMsgNum);

// Export UUIEventManager::execGetUIState(FFrame&, void* const)
native function string GetUIState();

defaultproperties
{
}
