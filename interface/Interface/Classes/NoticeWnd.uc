//================================================================================
// NoticeWnd.
//================================================================================

class NoticeWnd extends L2UIGFxScript;

const FLASH_XPOS = -7;
const FLASH_YPOS = -250;

const NOTICEBUTTON_DELETE = "900";
const NOTICEBUTTON_DELETEALL = "1000";
const LAYOUT_MULTILINE = "10001";
const LAYOUT_ONELINE = "10002";

enum ENoticeType
{
	TYPE_MAIL, // 0
	TYPE_QUEST, // 1
	TYPE_PREM, // 2
	TYPE_TUTORIAL, // 3
	TYPE_SKILL, // 4
	TYPE_CAMPAIGN, // 5
	TYPE_ZONE, // 6
	TYPE_AWAKENED, // 7
	TYPE_CURIOUSEHOUSE, // 8
	TYPE_EVENTCAMPAIGN, // 9
	TYPE_PLEDGEALARM, // 10
	TYPE_WEBPETITIONALARM, // 11
	TYPE_SINGLEMESHZONE, // 12
	TYPE_PVPBLOCKCHECKER, // 13
	TYPE_PVPCRATAECUBE, // 14
	TYPE_PVPMATCHRECORD, // 15
	TYPE_PVPCLEFT, // 16 
	TYPE_PATHTOAWAKENINGALARM, // 17
	TYPE_TODOLIST, // 18
	TYPE_LINEAGE2HOME, // 19
	TYPE_KILLER, // 20
	TYPE_PCROOM, // 21
	TYPE_ATTENDANCESTAMP, // 22 
	TYPE_CHINATUTORIAL, // 23
	TYPE_ABILITYPOINT, // 24
	TYPE_MONSTERBOOK, // 25
	TYPE_FACTION, // 26
	TYPE_AUCTION_FAIL, // 27
	TYPE_EVENT_INFO, // 28
	TYPE_NSHOPHOME, // 29
	TYPE_OLYMPIAD_OPENSEASON, // 30
	TYPE_ADVENTURE_GUIDE, // 31
	TYPE_CHANGE_CLASS, // 32
	TYPE_TELEPORTMAP, // 33
	TYPE_VITAMINMANAGER, // 34
	TYPE_TIME_HUNTINGZONE, // 35
	TYPE_RANKING, // 36
	TYPE_YETIMODE, // 37
	TYPE_REVENGEHELP, // 38
	TYPE_LOSTPROPERTY, // 39
	TYPE_COLLECTION, // 40
	TYPE_DETHRONE, // 41
	TYPE_WORLDEXCHANGE_BUY, // 42
	TYPE_GIFT, // 43
	TYPE_ATTENDCHECK, // 44
	TYPE_HOLY_FIRE // 45
};

var int RecentlyAddedQuestID;
var int HtmlString;
var int zonetype;

var array<GFxValue> args;
var GFxValue invokeResult;

var WindowHandle Me;

var WindowHandle AlarmWnd;

var MagicSkillWnd MagicSkillWndScript;
var QuestTreeWnd QuestTreeWndScript;
var YetiPCModeChangeWnd YetiPCModeChangeWndScript;

var UserInfo currentUserInfo;

var TabHandle m_TabCtrl;

var bool bCam;
var bool bZone;
var bool bEvent;

var bool bUseSingleMesh;
var int awakeClassID;
var int awakeImmediate;
var int currentScreenWidth;
var int currentScreenHeight;
var int PathToAwakeningAlarmType;
var int PathToAwakeningAlarmValue;
var int nUsePledgeV2Live;
var bool bChkAbilityPoint;
var bool isPrologueGrowTypeState;
var bool isGetPremium;
var bool isEnchantBlindState;
var ItemID collectionToFindiID;

function OnRegisterEvent()
{
	RegisterEvent(EV_ResolutionChanged);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_ArriveNewMail);
	RegisterEvent(EV_Notice_Post_Arrived);
	RegisterEvent(EV_SetRadarZoneCode);
	RegisterEvent(EV_ArriveShowQuest);
	RegisterEvent(EV_PremiumItemAlarm);
	RegisterEvent(EV_GoodsInventoryNoti);
	RegisterEvent(EV_ArriveTutorial);
	RegisterEvent(EV_SkillLearningNewArrival);
	RegisterEvent(EV_CallToChangeClass);
	RegisterEvent(EV_PledgeWaitingListAlarm);
	RegisterEvent(EV_CampaignArrived);
	RegisterEvent(EV_CampaignFinish);
	RegisterEvent(EV_ZoneQuestArrived);
	RegisterEvent(EV_CuriousHouseWaitState);
	RegisterEvent(EV_BR_Event_CampaignArrived);
	RegisterEvent(EV_EnterSingleMeshZone); //9540
	RegisterEvent(EV_ExitSingleMeshZone); //9541
	RegisterEvent(EV_WebPetitionReplyAlarm);
	RegisterEvent(EV_PathToAwakeningAlarm);
	RegisterEvent(EV_BlockStateTeam);
	RegisterEvent(EV_BlockStatePlayer);
	RegisterEvent(EV_CleftStateTeam);
	RegisterEvent(EV_CleftStatePlayer);
	RegisterEvent(EV_CrataeCubeRecordMyItem);
	RegisterEvent(EV_CrataeCubeRecordBegin);
	RegisterEvent(EV_CrataeCubeRecordRetire);
	RegisterEvent(EV_PVPMatchRecord);
	RegisterEvent(EV_QuestListEnd);
	RegisterEvent(EV_StateChanged);
	RegisterEvent(EV_OneDayRewardCount);
	RegisterEvent(EV_ClanInfo);
	RegisterGFxEvent(EV_GFX_ClanInfo); //10450;
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_ITEM_AUCTION_UPDATED_BIDDING_INFO);
	RegisterEvent(EV_FactionLevelUpNotify);
	RegisterEvent(EV_GotoWorldRaidServer);
	RegisterEvent(EV_ChangedSubjob);
	RegisterEvent(EV_OlympiadInfo);
	RegisterEvent(EV_ClassChangeAlarm);
	RegisterEvent(EV_SetRadarZoneCode);
	RegisterEvent(EV_PvpbookNewPk);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PVPBOOK_SHARE_REVENGE_NEW_REVENGEINFO);
	RegisterEvent(EV_PvpbookNewPk);
	RegisterEvent(EV_CollectionRegistEnableItem);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PENALTY_ITEM_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_DAILY_MISSION_COMPLETE);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_SETTLE_ALARM));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_GOODS_GIFT_CHANGED_NOTI));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_NOTIFY_ATTENDANCE));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_HOLY_FIRE_NOTIFY));
	RegisterEvent(EV_Test_5);
}

function OnLoad()
{
	RegisterState("NoticeWnd", "GamingState");
	SetContainerHUD(WINDOWTYPE_NONE, 0);
	AddState("GAMINGSTATE");
	AddState("ARENAGAMINGSTATE");
	// SetAlwaysFullAlpha(true);
	SetHavingFocus(false);
	SetDefaultShow(true);
	SetHUD();
	Me = GetWindowHandle("NoticeWnd");
	AlarmWnd = GetWindowHandle("PremiumItemAlarmWnd");
	MagicSkillWndScript = MagicSkillWnd(GetScript("MagicSkillWnd"));
	QuestTreeWndScript = QuestTreeWnd(GetScript("QuestTreeWnd"));
	YetiPCModeChangeWndScript = YetiPCModeChangeWnd(GetScript("YetiPCModeChangeWnd"));
	PathToAwakeningAlarmType = 0;
	PathToAwakeningAlarmValue = 0;
}

function OnShow()
{
	checkMultiLayOut();
}

function OnFlashLoaded()
{
	checkMultiLayOut();
}

function OnCallUCFunction(string functionName, string param)
{
	if(functionName == "updateButtonStateByCallUCFunction")
	{
		updateButtonStateByCallUCFunction(param);
	}
	else
	{
		clickNoticeButton(functionName, param);
	}
}

function updateButtonStateByCallUCFunction(string param)
{
	local int layerMode, Count, h, V, hGap, vGap,
		X, Y, posX, posY;

	ParseInt(param, "layerMode", layerMode);
	ParseInt(param, "count", Count);
	ParseInt(param, "h", h);
	ParseInt(param, "v", V);
	ParseInt(param, "x", X);
	ParseInt(param, "y", Y);
	ParseInt(param, "hGap", hGap);
	ParseInt(param, "vGap", vGap);
	ParseInt(param, "posX", posX);
	ParseInt(param, "posY", posY);
}

function clickNoticeButton(string logicIDStr, string param)
{
	local string strParam;
	local int logicID;
	local CampaignAlarmWnd campaign;
	local ZoneQuestAlarmWnd Zone;
	local GfxDialog GfxDialogScript;
	local BR_CampaignAlarmWnd br_eventcampaign;
	local int tutorialID, tutorialType;

	//local String tutorialName;

	logicID = int(logicIDStr);
	campaign = CampaignAlarmWnd(GetScript("CampaignAlarmWnd"));
	Zone = ZoneQuestAlarmWnd(GetScript("ZoneQuestAlarmWnd"));
	br_eventcampaign = BR_CampaignAlarmWnd(GetScript("BR_CampaignAlarmWnd"));

	// Debug("logicID" @ logicID);
	// Debug("zonetype" @ zonetype);

	if(logicID == ENoticeType.TYPE_MAIL)
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		RequestRequestReceivedPostList();
	}
	else if(logicID == ENoticeType.TYPE_QUEST)
	{
		if(getInstanceUIData().IsAdenServer())
		{
			if(!GetWindowHandle("QuestAcceptableListWnd").IsShowWindow())
			{
				getInstanceL2Util().syncWindowLoc("QuestWnd", "QuestAcceptableListWnd");
				GetWindowHandle("QuestAcceptableListWnd").ShowWindow();
			}
			else
			{
				GetWindowHandle("QuestAcceptableListWnd").HideWindow();
			}
			return;
		}
		ParamAdd(strParam, "QuestID", string(RecentlyAddedQuestID));
		ExecuteEvent(EV_QuestSetCurrentID, strParam);
	}
	else if(logicID == ENoticeType.TYPE_PREM)
	{
		if(IsUseGoodsInvnentory() == false)
		{
			if(!AlarmWnd.IsShowWindow())
			{
				AlarmWnd.ShowWindow();
			}
		}
		else
		{
			HandleShowProductInventory();
		}
	}
	else if(logicID == ENoticeType.TYPE_TUTORIAL)
	{
		//RequestTutorialQuestionMarkPressed(HtmlString);	

		ParseInt(param, "ID", tutorialID);
		ParseInt(param, "Type", tutorialType);

		//Debug("param: " @ param);
		//Debug("--> Call API : RequestTutorialMarkPressed");
		//Debug("tutorialID: " @ tutorialID);
		//Debug("tutorialType: " @ tutorialType);

		if(class'UIDATA_PLAYER'.static.IsInPrison())
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13773));						
		}
		else
		{
			RequestTutorialMarkPressed(tutorialType, tutorialID);
		}
	}
	else if(logicID == ENoticeType.TYPE_SKILL)
	{
		// MagicSkillWnd.ShowWindow();
		// m_TabCtrl.SetTopOrder(2, false);
		MagicSkillWndScript.externalCallLearnSkill();

		//MagicSkillWnd.onClickButton("TabCtrl2");
	}
	else if(logicID == ENoticeType.TYPE_CAMPAIGN)
	{
		bCam = false;
		campaign.RaderButtonClick();
	}
	else if(logicID == ENoticeType.TYPE_ZONE)
	{
		bZone = false;
		Zone.RaderButtonClick();
	}
	else if(logicID == ENoticeType.TYPE_AWAKENED)
	{
		ParamAdd(strParam, "Class", string(awakeClassID));

		GfxDialogScript = GfxDialog(GetScript("GfxDialog"));
		GfxDialogScript.showGfxDialog("dialogLinkageName", "AwakeNoticeDialog", strParam);
	}
	else if(logicID == ENoticeType.TYPE_CURIOUSEHOUSE)
	{
		RequestCuriousHouseHtml();
		///parseInt(param , "state",  HouseState)
	}
	//branch120516
	else if(logicID == ENoticeType.TYPE_EVENTCAMPAIGN)
	{
		bEvent = false;
		br_eventcampaign.RaderButtonClick();
	}
	else if(logicID == ENoticeType.TYPE_PLEDGEALARM)
	{
		if(!class'UIAPI_WINDOW'.static.IsShowWindow("ClanSearch"))
		{
			class'UIAPI_WINDOW'.static.ShowWindow("ClanSearch");
		}
	}
	else if(logicID == ENoticeType.TYPE_WEBPETITIONALARM)
	{
		ExecuteEvent(EV_ShowWebPetitionListPage);
		ResponsePetitionAlarm();
	}
	else if(logicID == ENoticeType.TYPE_SINGLEMESHZONE)
	{
		bUseSingleMesh = !bUseSingleMesh;

		SwitchSingleMeshMode(bUseSingleMesh);
		if(bUseSingleMesh)
		{
			createNoticeButton(ENoticeType.TYPE_SINGLEMESHZONE, 3031);
		}
		else
		{
			createNoticeButton(ENoticeType.TYPE_SINGLEMESHZONE, 3030);
		}
	}
	else if(logicID == ENoticeType.TYPE_PVPBLOCKCHECKER)
	{
		pvpButton(ENoticeType.TYPE_PVPBLOCKCHECKER);
	}
	else if(logicID == ENoticeType.TYPE_PVPCRATAECUBE)
	{
		pvpButton(ENoticeType.TYPE_PVPCRATAECUBE);
	}
	else if(logicID == ENoticeType.TYPE_PVPMATCHRECORD)
	{
		pvpButton(ENoticeType.TYPE_PVPMATCHRECORD);
	}
	else if(logicID == ENoticeType.TYPE_PATHTOAWAKENINGALARM)
	{
		ParamAdd(strParam, "Type", string(PathToAwakeningAlarmType));
		ParamAdd(strParam, "Value", string(PathToAwakeningAlarmValue));
		ExecuteEvent(EV_ShowWebPathMainPage, strParam);
	}
	else if(logicID == ENoticeType.TYPE_LINEAGE2HOME)
	{
		// 3471
		//showHideLineage2Home();
		showHideL2InGameWeb("main", "");
	}
	else if(logicID == ENoticeType.TYPE_ABILITYPOINT)
	{
		showHideAbilityWnd () ;
	}
	else if(logicID == ENoticeType.TYPE_MONSTERBOOK)
	{
		showhideMonsterBookWnd();
	}
	else if(logicID == ENoticeType.TYPE_FACTION)
	{
		showHideWindow("FactionWnd");
	}
	else if(logicID == ENoticeType.TYPE_AUCTION_FAIL)
	{
		handleAuctionFail();
	}
	else if(logicID == ENoticeType.TYPE_TODOLIST)
	{
		if(getInstanceUIData().getIsLiveServer())
		{
			if(class'UIAPI_WINDOW'.static.IsShowWindow("ToDoListWnd"))
			{
				class'UIAPI_WINDOW'.static.HideWindow("ToDoListWnd");
			}
			else
			{
				class'UIAPI_WINDOW'.static.ShowWindow("ToDoListWnd");
			}
		}
		else if(getInstanceUIData().getIsClassicServer() || getInstanceUIData().getIsArenaServer())
		{
			ExecuteEvent(EV_TodoListShow, "forceOpen=1");
		}
	}
	else if(logicID == ENoticeType.TYPE_EVENT_INFO)
	{
		showHideWindow("EventInfoWnd");
	}
	else if(logicID == ENoticeType.TYPE_NSHOPHOME)
	{
		showHideL2InGameWeb("nshop", "");
		// 3471
		//showHideHomePage("https://mink.ncsoft.com/");
		//Debug("TYPE_LINEAGE2HOME ѕЛёІ №цЖ° Е¬ёЇ!!!");
	}
	else if(logicID == ENoticeType.TYPE_OLYMPIAD_OPENSEASON)
	{
		if(class'UIAPI_WINDOW'.static.IsShowWindow("OlympiadWnd"))
		{
			class'UIAPI_WINDOW'.static.HideWindow("OlympiadWnd");
		}
		else
		{
			//Debug("---> Call API : RequestOlympiadRecord()");
			RequestOlympiadRecord();
		}
	}
	else if(logicID == ENoticeType.TYPE_CHANGE_CLASS)
	{
		showHideWindow("JobChangeWnd");
		Debug("전직 버튼 클릭!!");
	}
	else if(logicID == ENoticeType.TYPE_TELEPORTMAP)
	{
		if(class'UIConstants'.const.USE_XML_TELEPORT_UI)
		{
			showHideWindow("TeleportWnd");
		}
		else if(class'UIAPI_WINDOW'.static.IsShowWindow("TeleportMapWnd"))
		{
			class'UIAPI_WINDOW'.static.HideWindow("TeleportMapWnd");
		}
		else
		{
			TeleportMapWnd(GetScript("TeleportMapWnd")).Rq_C_EX_TELEPORT_UI();
		}
		Debug ("TYPE_TELEPORTMAP №цЖ° Е¬ёЇ!!");
	}
	else if(logicID == ENoticeType.TYPE_VITAMINMANAGER)
	{
		Debug("TYPE_VITAMINMANAGER��ư Ŭ��!!");
		RequestOpenWndWithoutNPC(OPEN_PREMIUM_MANAGER);
	}
	else if(logicID == ENoticeType.TYPE_TIME_HUNTINGZONE)
	{
		Debug("TYPE_TIME_HUNTINGZONE ��ư Ŭ��!!");
		if(class'UIAPI_WINDOW'.static.IsShowWindow("TimeZoneWnd"))
		{
			class'UIAPI_WINDOW'.static.HideWindow("TimeZoneWnd");
		}
		else
		{
			class'UIAPI_WINDOW'.static.ShowWindow("TimeZoneWnd");
		}
	}
	else if(logicID == ENoticeType.TYPE_RANKING)
	{
		if(class'UIAPI_WINDOW'.static.IsShowWindow("RankingWnd"))
		{
			class'UIAPI_WINDOW'.static.HideWindow("RankingWnd");
		}
		else
		{
			class'UIAPI_WINDOW'.static.ShowWindow("RankingWnd");
			class'UIAPI_WINDOW'.static.SetFocus("RankingWnd");
		}
	}
	else if(logicID == ENoticeType.TYPE_YETIMODE)
	{
		YetiPCModeChangeWndScript.setYetiMode(true);
	}
	else if(logicID == ENoticeType.TYPE_KILLER)
	{
		if(GetLanguage() != 4)
		{
			class'UIAPI_WINDOW'.static.ShowWindow("RevengeWnd");
		}
	}
	else if(logicID == ENoticeType.TYPE_REVENGEHELP)
	{
		class'UIAPI_WINDOW'.static.ShowWindow("RevengeWnd");
		GetTabHandle("RevengeWnd.RevengeTab").SetTopOrder(1, false);
	}
	else if(logicID == ENoticeType.TYPE_LOSTPROPERTY)
	{
		Debug("잃어 버린 아이템 복원! 창");
		toggleWindow("RestoreLostPropertyWnd");
	}
	else if(logicID == ENoticeType.TYPE_COLLECTION)
	{
		collectionFindItem();
	}
	else if(logicID == ENoticeType.TYPE_DETHRONE)
	{
		Debug("Click TYPE_DETHRONE");
		DethroneWnd(GetScript("DethroneWnd")).gotoTabMission();
		class'UIAPI_WINDOW'.static.ShowWindow("DethroneWnd");
		class'UIAPI_WINDOW'.static.SetFocus("DethroneWnd");
	}
	else if(logicID == ENoticeType.TYPE_WORLDEXCHANGE_BUY)
	{
		ToggleWorldExchangeRegiWnd();
	}
	else if(logicID == ENoticeType.TYPE_GIFT)
	{
		if(class'UIAPI_WINDOW'.static.IsShowWindow("GiftInventoryWnd"))
		{
			GiftInventoryWnd(GetScript("GiftInventoryWnd")).refresh();
			Debug("선물 갱신");
		}
		else
		{
			class'UIAPI_WINDOW'.static.ShowWindow("GiftInventoryWnd");
			class'UIAPI_WINDOW'.static.SetFocus("GiftInventoryWnd");
			Debug("선물 창 열기");
		}
	}
	else if(logicID == ENoticeType.TYPE_ATTENDCHECK)
	{
		if(class'UIAPI_WINDOW'.static.IsShowWindow("AttendCheckWnd"))
		{
			class'UIAPI_WINDOW'.static.HideWindow("AttendCheckWnd");
		}
		else
		{
			RequestAttendanceWndOpen();
		}
		Debug("출석부 클릭!!!!!");
	}
	else if(logicID == ENoticeType.TYPE_HOLY_FIRE)
	{
		DethroneFireEnchantWnd(GetScript("DethroneFireEnchantWnd")).API_C_EX_HOLY_FIRE_OPEN_UI();
	}
}

function ToggleWorldExchangeRegiWnd()
{
	class'WorldExchangeRegiWnd'.static.Inst()._CheckOnClickNoticeBtn();
}

function collectionFindItem()
{
	local ItemInfo iInfo;
	local CollectionSystem collectionSystemScript;

	if(!class'UIDATA_INVENTORY'.static.FindItem(collectionToFindiID.ServerID, iInfo))
	{
		return;
	}

	collectionSystemScript = CollectionSystem(GetScript("CollectionSystem"));
	collectionSystemScript.SetToFindItemInfo(iInfo);
	collectionSystemScript.API_C_EX_COLLECTION_OPEN_UI();

	collectionToFindiID.ServerID = -1;
	collectionToFindiID.ClassID = -1;
}

function ChkCreateCollectionButton()
{
	local ItemEnchantWnd itemEnchantWndscr;
	local ItemMultiEnchantWnd itemMultiEnchantWndscr;

	itemMultiEnchantWndscr = ItemMultiEnchantWnd(GetScript("ItemMultiEnchantwnd"));

	if(itemMultiEnchantWndscr.m_hOwnerWnd.IsShowWindow() && itemMultiEnchantWndscr.bUseLateAnnounce)
	{
		isEnchantBlindState = true;
		return;
	}
	itemEnchantWndscr = ItemEnchantWnd(GetScript("ItemEnchantWnd"));

	if(itemEnchantWndscr.m_hOwnerWnd.IsShowWindow() && itemEnchantWndscr.GetStateName() == itemEnchantWndscr.const.STATE_COMPLETE_BLIND)
	{
		isEnchantBlindState = true;
		return;
	}
	createNoticeButton(ENoticeType.TYPE_COLLECTION, 13490);
}

function _CreateCollectionButtonBlind()
{
	if(isEnchantBlindState)
	{
		isEnchantBlindState = false;
		createNoticeButton(ENoticeType.TYPE_COLLECTION, 13490);
	}
}

function handleAuctionFail()
{
	local string strParam;
	local HelpHtmlWnd script;

	script = HelpHtmlWnd(GetScript("HelpHtmlWnd"));
	ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "item_auction_rule_info002.htm");
	script.HandleShowHelp(strParam);
}

function showhideMonsterBookWnd()
{
	if(class'UIAPI_WINDOW'.static.IsShowWindow("MonsterBookWnd"))
	{
		class'UIAPI_WINDOW'.static.HideWindow("MonsterBookWnd");		
	}
	else
	{
		CallGFxFunction("MonsterBookWnd", "clearSearchCondition", "");
		CallGFxFunction("MonsterBookWnd", "ChangefactionCategroy", "0");
	}
}

function showHideWindow(string WindowName)
{
	if(class'UIAPI_WINDOW'.static.IsShowWindow(WindowName))
	{
		class'UIAPI_WINDOW'.static.HideWindow(WindowName);
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow(WindowName);
		class'UIAPI_WINDOW'.static.SetFocus(WindowName);
	}
}

function showHideAbilityWnd()
{
	showHideWindow("AbilityUIWnd");
}

function showHideL2InGameWeb(string Category, string Message)
{
	local string strParam;

	ParamAdd(strParam, "Category", Category);
	ParamAdd(strParam, "Message", "");
	ExecuteEvent(EV_InGameWebWnd_Info, strParam);
}

function OnEvent(int Event_ID, string param)
{
	local int iEffectNumber, level, statusInt;
	local string strParam;
	local string strTargetName;
	local Vector vTargetPos;
	local bool bOnlyMinimap;
	//local int nUsePledgeV2Live;//, nUsePledgeV2Classic;

	local GfxDialog GfxDialogScript;

	local int UserType;

	local int clanID;
	local int nRewardCount, isNewMissionLevelReward;

	if(Event_ID == EV_ArriveNewMail)
	{
//		Debug("EV_ArriveNewMail?? ѕрБ¦їАґВ°Ь??");
	}
	else if(Event_ID == EV_Notice_Post_Arrived)
	{
		ParseInt(param, "IdxMail", iEffectNumber);
		createNoticeButton(ENoticeType.TYPE_MAIL, 2074);
	}
	else if(Event_ID == EV_PledgeWaitingListAlarm)
	{
		createNoticeButton(ENoticeType.TYPE_PLEDGEALARM, 3068);
	}
	else if(Event_ID == EV_ArriveShowQuest)
	{
		// SetShowWindow();
		ParseInt(param, "QuestID", RecentlyAddedQuestID);
		ParseInt(param, "QuestLevel", level);

		//Debug("EV_ArriveShowQuest : " @ param);
		//Debug("RecentlyAddedQuestID" @ RecentlyAddedQuestID);
		//Debug("level" @ level);

		QuestAlarmWnd(GetScript("QuestAlarmWnd")).externalDelayTimerRequestAddExpandQuest(RecentlyAddedQuestID);

		///RequestAddExpandQuestAlarm(RecentlyAddedQuestID);

		ArriveShowQuest();

		GetPlayerInfo(currentUserInfo);

		// debug("RecentlyAddedQuestID" @ RecentlyAddedQuestID);
		//if(QuestTreeWndScript.isQuestIDSearch(10338) || (currentUserInfo.nClassID <= 147 && currentUserInfo.nClassID >= 139))

		if(RecentlyAddedQuestID == 10338 || currentUserInfo.nClassID <= 181 && currentUserInfo.nClassID >= 148 || currentUserInfo.nClassID == 188 || currentUserInfo.nClassID == 189)
		{
			ChangeToAwakenedArrived(false);
		}

		if(RecentlyAddedQuestID > 0 && Level > 0)
		{
			strTargetName = class'UIDATA_QUEST'.static.GetTargetName(RecentlyAddedQuestID, Level);
			vTargetPos = class'UIDATA_QUEST'.static.GetTargetLoc(RecentlyAddedQuestID, Level);

			ParamAdd(strParam, "X", string(vTargetPos.x));
			ParamAdd(strParam, "Y", string(vTargetPos.y));
			ParamAdd(strParam, "Z", string(vTargetPos.z));
			ParamAdd(strParam, "targetName", strTargetName);

			ParamAdd(strParam, "QuestID", string(RecentlyAddedQuestID));
			ParamAdd(strParam, "QuestLevel", string(Level));

			ParamAdd(strParam, "questName", class'UIDATA_QUEST'.static.GetQuestName(RecentlyAddedQuestID, Level));
			CallGFxFunction("RadarMapWnd", "showQuestTargetInfo", strParam);
			// CallGFxFunction("MiniMapGfxWnd", "showQuestTargetInfo" , strParam) ;

			bOnlyMinimap = class'UIDATA_QUEST'.static.IsMinimapOnly(RecentlyAddedQuestID, Level);
			QuestTreeWndScript.curQuestExpand(RecentlyAddedQuestID);

			if(bOnlyMinimap)
			{
				if(!IsPlayerOnWorldRaidServer())
				{
					class'QuestAPI'.static.SetQuestTargetInfo(true, false, false, strTargetName, vTargetPos, RecentlyAddedQuestID, Level);
				}
			}
			else
			{
				//Debug("Notice2" @ RecentlyAddedQuestID);
				if(!IsPlayerOnWorldRaidServer())
				{
					class'QuestAPI'.static.SetQuestTargetInfo(true, true, true, strTargetName, vTargetPos, RecentlyAddedQuestID, Level);
				}
			}
		}
		/// Debug("quest param" @ param);
	}
	else if(Event_ID == EV_PremiumItemAlarm  || Event_ID ==  EV_GoodsInventoryNoti)
	{
		// SetShowWindow();
		PremiumItemAlarm();
	}
	//else if(Event_ID == EV_ArriveNewTutorialQuestion)

	else if(Event_ID == EV_ArriveTutorial)
	{
		// SetShowWindow();
		//Debug("EV_ArriveNewTutorialQuestion" @ HtmlString);
		//ParseInt(param, "QuestionID", HtmlString);
		ArriveNewTutorialQuestion(param);
	}
	else if(Event_ID == EV_SkillLearningNewArrival)
	{
		// SetShowWindow();
		SkillLearningNewArrival();
	}
	else if(Event_ID == EV_CampaignArrived)
	{
		//SetShowWindow();
		bCam = true;

		CampaignArrived();
	}
	else if(Event_ID == EV_CampaignFinish)
	{
		ClearCampaignBtn();
	}
	else if(Event_ID == EV_ZoneQuestArrived)
	{
		// SetShowWindow();
		bZone = true;
		ZoneQuestArrived();
	}
	else if(Event_ID == EV_BR_Event_CampaignArrived)
	{
		// SetShowWindow();
		bEvent = true;

		EventCampaignArrived();
	}
	else if(Event_ID == EV_CallToChangeClass)
	{
		// 5470
		// SetShowWindow();

		ParseInt(param, "Class", awakeClassID);
		ParseInt(param, "Immediate", awakeImmediate);
		ParseInt(param, "UserType", UserType);

//		Debug("awakeClassID" @ awakeClassID);

		if(UserType == 0)// GetUIUserPremiumLevel() <= 0)
		{
			strParam = "";
			ParamAdd(strParam, "Class", string(awakeClassID));

			GfxDialogScript = GfxDialog(GetScript("GfxDialog"));
			GfxDialogScript.showGfxDialog("dialogLinkageName", "DualPayDialogStep1", strParam);
		}
		else if(awakeClassID <= 0)
		{
		}
		else
		{
			if(awakeImmediate == 1)
			{
				strParam = "";
				ParamAdd(strParam, "Class", string(awakeClassID));
				ParamAdd(strParam, "Immediate", string(awakeImmediate));

				GfxDialogScript = GfxDialog(GetScript("GfxDialog"));
				GfxDialogScript.showGfxDialog("dialogLinkageName", "AwakeNoticeDialog", strParam);
			}
			else
			{
				ChangeToAwakenedArrived(true);
			}
		}
	}
	else if(Event_ID == EV_Restart)
	{
		isGetPremium = false;
		isPrologueGrowTypeState = false;
		bChkAbilityPoint = false;
		removeALLNoticeButton();
	}
	else if(Event_ID == EV_ResolutionChanged)
	{
		// SendScreenSize();
		checkMultiLayOut();
	}
	else if(Event_ID == EV_CuriousHouseWaitState)
	{
		CuriousHouseHandle(param);
	}
	else if(Event_ID == EV_WebPetitionReplyAlarm)
	{
		WebPetitionReplyAlarm();
	}
	else if(Event_ID == EV_EnterSingleMeshZone)
	{
		bUseSingleMesh = true;

		if(bUseSingleMesh)
		{
			createNoticeButton(	ENoticeType.TYPE_SINGLEMESHZONE, 3031);
		}
		else
		{
			createNoticeButton(	ENoticeType.TYPE_SINGLEMESHZONE, 3030);
		}
	}
	else if(Event_ID == EV_ExitSingleMeshZone)
	{
		bUseSingleMesh = false;
		// SwitchSingleMeshMode(false);
		removeNoticeButton(ENoticeType.TYPE_SINGLEMESHZONE);
	}
	else if(Event_ID == EV_BlockStateTeam || Event_ID == EV_BlockStatePlayer)
	{
		createNoticeButton(ENoticeType.TYPE_PVPBLOCKCHECKER, 2445);
	}
	else if(Event_ID == EV_CrataeCubeRecordMyItem)
	{
		createNoticeButton(ENoticeType.TYPE_PVPCRATAECUBE, 2444);
	}
	else if(Event_ID == EV_CrataeCubeRecordBegin)
	{
		ParseInt(param, "Status", statusInt);

		if(statusInt == 0)
		{
			createNoticeButton(ENoticeType.TYPE_PVPCRATAECUBE, 2444);
		}
		else if(statusInt == 2)
		{
			removeNoticeButton(	ENoticeType.TYPE_PVPCRATAECUBE);
		}
	}
	else if(Event_ID == EV_CrataeCubeRecordRetire)
	{
		removeNoticeButton(ENoticeType.TYPE_PVPCRATAECUBE);
	}
	else if(Event_ID == EV_PVPMatchRecord)
	{
		ParseInt(param, "CurrentState", statusInt);

		if(statusInt == 0)
		{
			createNoticeButton(ENoticeType.TYPE_PVPMATCHRECORD, 2442);
		}
		else if(statusInt == 2)
		{
			removeNoticeButton(ENoticeType.TYPE_PVPMATCHRECORD);
		}
	}
	else if(Event_ID == EV_CleftStateTeam || Event_ID == EV_CleftStatePlayer)
	{
		createNoticeButton(ENoticeType.TYPE_PVPCLEFT, 2443);
	}
	else if(Event_ID == EV_QuestListEnd)
	{
		QuestTreeWndScript.findNowQuestExist(RecentlyAddedQuestID);
	}
	else if(Event_ID == EV_PathToAwakeningAlarm)
	{
		ParseInt(param, "Type", PathToAwakeningAlarmType);
		ParseInt(param, "Value", PathToAwakeningAlarmValue);

		createNoticeButton(ENoticeType.TYPE_PATHTOAWAKENINGALARM, 5178);
		// PathToAwakeningAlarm();
	}
	else if(Event_ID == EV_ClanInfo)
	{
		ParseInt(param, "ClanID", clanID);

		if(clanID > 0)
		{
			removeNoticeButton(ENoticeType.TYPE_PLEDGEALARM);
		}
	}
	else if(Event_ID == EV_UpdateUserInfo)
	{
		chkAbilityPoint();

		ParseInt(param, "ClanID", clanID);

		if(clanID > 0)
		{
			removeNoticeButton(ENoticeType.TYPE_PLEDGEALARM);
		}
	}
	else if(Event_ID == EV_ITEM_AUCTION_UPDATED_BIDDING_INFO)
	{
		createNoticeButton(ENoticeType.TYPE_AUCTION_FAIL, 3500);
	}
	else if(Event_ID == EV_FactionLevelUpNotify)
	{
		createNoticeButton(ENoticeType.TYPE_FACTION, 3443);
	}
	else if(Event_ID == EV_MonsterBookRewardIcon)
	{
		createNoticeButton(ENoticeType.TYPE_MONSTERBOOK, 3511);
	}
	else if(Event_ID == EV_OneDayRewardCount)
	{
		ParseInt(param, "rewardCount", nRewardCount);
		ParseInt(param, "isNewMissionLevelReward", isNewMissionLevelReward);

		if(nRewardCount > 0)
		{
			createNoticeButtonWithParam(ENoticeType.TYPE_TODOLIST, 3506, param);

			if(isNewMissionLevelReward > 0)
			{
				ToDoListWnd(GetScript("ToDoListWnd")).RequestMissionLevelRewardList();
			}		
		}
		else
		{
			removeNoticeButton(ENoticeType.TYPE_TODOLIST);
		}	
	}
	else if(Event_ID == EV_GotoWorldRaidServer)
	{
		// GetINIBool ("Localize", "UsePledgeV2Live", nUsePledgeV2Live, "L2.ini");

		//if(nUsePledgeV2Live > 0) removeNoticeButton(ENoticeType.TYPE_TODOLIST); 

		if(getInstanceL2Util().isClanV2())
		{
			removeNoticeButton(ENoticeType.TYPE_TODOLIST);
		}
	}
	else if(Event_ID == EV_OlympiadInfo)
	{
		/*Debug("EV_OlympiadInfo" @ param);

		ParseInt(param, "Open", nOlympiadOpenSeason);

		if(nOlympiadOpenSeason > 0) 
			createNoticeButtonWithParam(ENoticeType.TYPE_OLYMPIAD_OPENSEASON, 3845, param);  // 3845 : їГёІЗЗѕЖµе
		else
			removeNoticeButton(ENoticeType.TYPE_OLYMPIAD_OPENSEASON);*/
		HandleOlympiadEvent(param);
	}
	else if(Event_ID == EV_ChangedSubjob)
	{
		handleChangedSubjob(param);
	}
	else if(Event_ID == EV_StateChanged)
	{
		if(param == "GAMINGSTATE" || param == "ARENAGAMINGSTATE")
		{
		//	if(param != "ARENAGAMINGSTATE")
		//		createNoticeButton(ENoticeType.TYPE_TELEPORTMAP, 687);

			isPrologueGrowTypeState = getInstanceL2Util().getIsPrologueGrowType();
			//Debug ("EV_StateChanged" @ isPrologueGrowTypeState);
			if(!bUseL2Button())
				return;
			/*if(bUseL2Button())
			{
				// Debug("NoticeButton TYPE_LINEAGE2HOME");
				createNoticeButton(	ENoticeType.TYPE_LINEAGE2HOME, 3471);    // l2ИЁ				
				createNoticeButton(	ENoticeType.TYPE_NSHOPHOME, 3634);       // nјҐ
			}*/

		//	if(IsAdenServer() || getInstanceUIData().getIsClassicServer()) createNoticeButton(	ENoticeType.TYPE_VITAMINMANAGER, 3949);       // єсЕё№О ёЕґПАъ №цЖ°

			// if(isChinaVer()) createNoticeButton(	ENoticeType.TYPE_ADVENTURE_GUIDE, 7270); // ёрЗиАЗ ѕИі» (БЯ±№ Аьїл)
		}
	}
	else if(Event_ID == EV_ClassChangeAlarm)
	{
		createNoticeButton(ENoticeType.TYPE_CHANGE_CLASS, 1795); 
	}
	else if(Event_ID == EV_TimeRestrictFieldChargeResult || Event_ID == EV_TimeRestrictFieldUserAlarm)
	{
		createNoticeButton(ENoticeType.TYPE_TIME_HUNTINGZONE,13025);
	}
	else if(Event_ID == EV_ProtocolBegin + class'UIPacket'.const.S_EX_PVPBOOK_SHARE_REVENGE_NEW_REVENGEINFO)
	{
		S_EX_PVPBOOK_SHARE_REVENGE_NEW_REVENGEINFO();
	}
	else if(Event_ID == EV_ProtocolBegin + class'UIPacket'.const.S_EX_PENALTY_ITEM_INFO)
	{
		ParsePacket_S_EX_PENALTY_ITEM_INFO();
	}
	else if(Event_ID == EV_CollectionRegistEnableItem)
	{
		ParseInt(param, "classID", collectionToFindiID.ClassID);
		ParseInt(param, "ServerID", collectionToFindiID.ServerID);
		ChkCreateCollectionButton();
	}
	else if(Event_ID == EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM))
	{
		RT_S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM();
	}
	else if(Event_ID == EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_SETTLE_ALARM))
	{
		RT_S_EX_WORLD_EXCHANGE_SETTLE_ALARM();
	}
	else if(Event_ID == (EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_DAILY_MISSION_COMPLETE))
	{
		ParsePacket_S_EX_DETHRONE_DAILY_MISSION_COMPLETE();
	}
	else if(Event_ID == EV_PacketID(class'UIPacket'.const.S_EX_GOODS_GIFT_CHANGED_NOTI))
	{
		Debug("-> 선물 수신 동의 알람 S_EX_GOODS_GIFT_CHANGED_NOTI");
		createNoticeButton(ENoticeType.TYPE_GIFT, 14201);
	}
	else if(Event_ID == EV_PacketID(class'UIPacket'.const.S_EX_NOTIFY_ATTENDANCE))
	{
		Nt_S_EX_NOTIFY_ATTENDANCE();
	}
	else if(Event_ID == EV_PacketID(class'UIPacket'.const.S_EX_HOLY_FIRE_NOTIFY))
	{
		ParsePacket_S_EX_HOLY_FIRE_NOTIFY();
	}
	else if(Event_ID == EV_Test_5)
	{
		Debug("-> 테스트 5 출석부");
		createNoticeButton(ENoticeType.TYPE_ATTENDCHECK, 1);
	}

	//else if(Event_ID == EV_AbilityListStart) 
	//{
	//	Debug ("EV_AbilityListStart" @ param);
	//}
}

function ParsePacket_S_EX_HOLY_FIRE_NOTIFY()
{
	local UIPacket._S_EX_HOLY_FIRE_NOTIFY packet;

	if(!class'UIPacket'.static.Decode_S_EX_HOLY_FIRE_NOTIFY(packet))
	{
		return;
	}
	Debug("_S_EX_HOLY_FIRE_NOTIFY packet.cState" @ string(packet.cState));
	switch(packet.cState)
	{
		case 0:
		case 2:
		case 3:
			createNoticeButton(ENoticeType.TYPE_HOLY_FIRE, 14329);
			break;
	}
}

function Nt_S_EX_NOTIFY_ATTENDANCE()
{
	getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4322));
	createNoticeButton(ENoticeType.TYPE_ATTENDCHECK, 5190);
}

function RemoveAttendCheckNotice()
{
	removeNoticeButton(ENoticeType.TYPE_ATTENDCHECK);
}

function RT_S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM packet;
	local string param;

	if(!class'UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM(packet))
	{
		return;
	}
	if(class'WorldExchangeRegiWnd'.static.Inst().m_hOwnerWnd.IsShowWindow())
	{
		class'WorldExchangeRegiWnd'.static.Inst().HandleCancelCancel();
		class'WorldExchangeRegiWnd'.static.Inst().historyScr.HandleRefresh();
	}
	ParamAdd(param, "rewardCount", string(class'WorldExchangeRegiWnd'.static.Inst().historyScr.receivedNum));
	_CreateWorldExchangeBuyNotice(param);
	Debug("RT_S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM" @ param);
}

function RT_S_EX_WORLD_EXCHANGE_SETTLE_ALARM()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_SETTLE_ALARM packet;
	local string param;

	if(!class'UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_SETTLE_ALARM(packet))
	{
		return;
	}
	if(class'WorldExchangeRegiWnd'.static.Inst().m_hOwnerWnd.IsShowWindow())
	{
		class'WorldExchangeRegiWnd'.static.Inst().HandleCancelCancel();
		class'WorldExchangeRegiWnd'.static.Inst().historyScr.HandleRefresh();
	}
	param = "";
	ParamAdd(param, "rewardCount", string(packet.nCount));
	_CreateWorldExchangeBuyNotice(param);
}

function _CreateWorldExchangeBuyNotice(optional string param)
{
	createNoticeButtonWithParam(ENoticeType.TYPE_WORLDEXCHANGE_BUY, 14063, param);
}

function _RemoveNoticButtonWorldExchangeBuy()
{
	removeNoticeButton(ENoticeType.TYPE_WORLDEXCHANGE_BUY);
}

function _RemoveNoticButtonGift()
{
	removeNoticeButton(ENoticeType.TYPE_GIFT);
}

function _RemoveNoticButtonProductInventory()
{
	removeNoticeButton(ENoticeType.TYPE_PREM);
}

function ParsePacket_S_EX_DETHRONE_DAILY_MISSION_COMPLETE()
{
	local UIPacket._S_EX_DETHRONE_DAILY_MISSION_COMPLETE packet;
	local string param;

	if(!class'UIPacket'.static.Decode_S_EX_DETHRONE_DAILY_MISSION_COMPLETE(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_DETHRONE_DAILY_MISSION_COMPLETE : " @ string(packet.nCompleteMissionCount));
	ParamAdd(param, "rewardCount", string(packet.nCompleteMissionCount));

	if(packet.nCompleteMissionCount > 0)
	{
		createNoticeButtonWithParam(ENoticeType.TYPE_DETHRONE, 13733, param);
	}
	else
	{
		removeNoticeButton(ENoticeType.TYPE_DETHRONE);
	}
}

function removeNoticeDethroneMissionNotice()
{
	removeNoticeButton(ENoticeType.TYPE_DETHRONE);
}

function ParsePacket_S_EX_PENALTY_ITEM_INFO()
{
	local UIPacket._S_EX_PENALTY_ITEM_INFO packet;

	if(!class'UIPacket'.static.Decode_S_EX_PENALTY_ITEM_INFO(packet))
	{
		return;
	}
	LostPropertyArrived(packet.nCount);
}

function S_EX_PVPBOOK_SHARE_REVENGE_NEW_REVENGEINFO()
{
	local UIPacket._S_EX_PVPBOOK_SHARE_REVENGE_NEW_REVENGEINFO packet;

	if(!class'UIPacket'.static.Decode_S_EX_PVPBOOK_SHARE_REVENGE_NEW_REVENGEINFO(packet))
	{
		return;
	}
	if(packet.nShareType != 1)
	{
		RevengeHelpArrived();
	}
	if(packet.nShareType != 2 && packet.nShareType != 4)
	{
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13049), packet.sKillUserName));
		createNoticeButton(ENoticeType.TYPE_KILLER, 0, MakeFullSystemMsg(GetSystemMessage(13049), packet.sKillUserName));
	}
}

function chkAbilityPoint()
{
	local userinfo userInfo;

	GetPlayerInfo(userInfo);

	if(getInstanceUIData().isLevelUP()) bChkAbilityPoint = true;

	// Debug ( "chkAbilityPoint" @ getInstanceUIData().isLevelUP() @ userInfo.nRemainAbilityPoint @ bChkAbilityPoint);

	if(bChkAbilityPoint)
	{
		if(userInfo.nRemainAbilityPoint > 0)
		{
			createNoticeButton(ENoticeType.TYPE_ABILITYPOINT, 3151);
			bChkAbilityPoint = false;
		}
	}
}

function bool isChinaVer()
{
	local ELanguageType Language;
	local bool flag;

	Language = GetLanguage();

	if(Language == LANG_Chinese)
	{
		flag = true;
	}
	return flag;
}

function bool bUseL2Button()
{
	local ELanguageType Language;
	local bool flag;

	Language = GetLanguage();
	if(Language == LANG_Korean && !getInstanceUIData().getIsArenaServer())
	{
		flag = true;
	}

	return flag;
}

function toggleWindow(string WindowName)
{
	if(!GetWindowHandle(WindowName).IsShowWindow())
	{
		GetWindowHandle(WindowName).ShowWindow();
		GetWindowHandle(WindowName).SetFocus();		
	}
	else
	{
		GetWindowHandle(WindowName).HideWindow();
	}
}

function pvpButton(int SelectPVP)
{
	if(SelectPVP == ENoticeType.TYPE_PVPBLOCKCHECKER)
	{
		toggleWindow("BlockCurWnd");		
	}
	else if(SelectPVP == ENoticeType.TYPE_PVPCRATAECUBE)
	{
		if(!GetWindowHandle("KillPointRankWnd").IsShowWindow())
		{
			RequestStartShowCrataeCubeRank();
		}
		toggleWindow("KillPointRankWnd");
	}
	else if(SelectPVP == ENoticeType.TYPE_PVPMATCHRECORD)
	{
		toggleWindow("PVPDetailedWnd");
	}
	else if(SelectPVP == ENoticeType.TYPE_PVPCLEFT)
	{
		toggleWindow("CleftCurWnd");
	}
}

function CuriousHouseHandle(string param)
{
	local int HouseState;

	ParseInt(param, "State", HouseState);

	switch(HouseState)
	{
		case 1:
			createNoticeButton(ENoticeType.TYPE_CURIOUSEHOUSE, 2804);
			break;
		case 0:
		case 2:
		case 3:
			//eventID = 900;
			// args[1].SetMemberInt("Num", ENoticeType.TYPE_CURIOUSEHOUSE);
			// createNoticeButton(ENoticeType.TYPE_PLEDGEALARM);
			removeNoticeButton(ENoticeType.TYPE_CURIOUSEHOUSE);
			break;
	}
}

function PledgeAlarm()
{
	createNoticeButton(ENoticeType.TYPE_PLEDGEALARM, 3068);
}

function WebPetitionReplyAlarm()
{
	createNoticeButton(ENoticeType.TYPE_WEBPETITIONALARM, 3109);
}

function HandleOlympiadEvent(string param)
{
	local int nOlympiadOpenSeason;

	if(getInstanceUIData().getIsClassicServer())
	{
		NoticeHUD(GetScript("NoticeHUD")).HandleOlympiadNotice(param);
	}
	else
	{
		ParseInt(param, "Open", nOlympiadOpenSeason);
		if(nOlympiadOpenSeason > 0)
		{
			createNoticeButtonWithParam(ENoticeType.TYPE_OLYMPIAD_OPENSEASON, 3845, param);
		}
		else
		{
			removeNoticeButton(ENoticeType.TYPE_OLYMPIAD_OPENSEASON);
		}
	}
}

function Notice_Post_Arrived()
{
	createNoticeButton(ENoticeType.TYPE_MAIL, 2074);
}

function ArriveShowQuest()
{
	if(IsAdenServer())
	{
		createNoticeButton(ENoticeType.TYPE_QUEST, 14405);		
	}
	else
	{
		createNoticeButton(ENoticeType.TYPE_QUEST, 118);
	}
}

function PremiumItemAlarm()
{
	if(IsUseGoodsInvnentory() == false)
	{
		createNoticeButton(ENoticeType.TYPE_PREM, 1738);
		AddSystemMessage(2313);
	}
	else
	{
		createNoticeButton(ENoticeType.TYPE_PREM, 2680);
	}
}

function SkillLearningNewArrival()
{
	createNoticeButton(ENoticeType.TYPE_SKILL, 2369);
}

function CampaignArrived()
{
	createNoticeButton(ENoticeType.TYPE_CAMPAIGN, 2440);
}

function ZoneQuestArrived()
{
	createNoticeButton(ENoticeType.TYPE_ZONE, 2441);
}

function RevengeHelpArrived()
{
	createNoticeButton(ENoticeType.TYPE_REVENGEHELP, 13502);
}

function LostPropertyArrived(int nCount)
{
	local string param;

	ParamAdd(param, "rewardCount", string(nCount));

	if(nCount > 0)
	{
		createNoticeButtonWithParam(ENoticeType.TYPE_LOSTPROPERTY, 13526, param);		
	}
	else
	{
		removeNoticeButton(ENoticeType.TYPE_LOSTPROPERTY);
	}
}

function EventCampaignArrived()
{
	createNoticeButton(ENoticeType.TYPE_EVENTCAMPAIGN, 5143);
}

function EventInfoArrived()
{
	local SideBar SideBarScript;

	if(GetLanguage() == 0)
	{
		SideBarScript = SideBar(GetScript("SideBar"));
		SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENTINFO, true);
	}
}

function hideNoticeButton_EventInfo()
{
	removeNoticeButton(ENoticeType.TYPE_EVENT_INFO);
}

function ClearCampaignBtn()
{
	//Debug("bCam>>>>>>>>>" $ string(bCam));
	if(bCam == true)
	{
		removeNoticeButton(int(ENoticeType.TYPE_CAMPAIGN));

		bCam = false;
	}
}

function ClearZoneQuestBtn()
{
	if(bZone == true)
	{
		removeNoticeButton(int(ENoticeType.TYPE_ZONE));

		bZone = false;
	}
}

function PathToAwakeningAlarm()
{
	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);

	args[0].SetInt(ENoticeType.TYPE_PATHTOAWAKENINGALARM);
	CreateObject(args[1]);

	args[1].SetMemberInt("toolTipNum", 5178);

	Invoke("_root.onEvent", args, invokeResult);

	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
}

function ClearBRCampaignBtn()
{
	if(bEvent == true)
	{
		removeNoticeButton(int(ENoticeType.TYPE_EVENTCAMPAIGN));

		bEvent = false;
	}
}

function ChangeToAwakenedArrived(bool bOnOff)
{
	// SetShowWindow();

	if(bOnOff)
	{
		//CallGFxFunction("noticeWnd", String(ENoticeType.TYPE_AWAKENED), "toolTipNum=" $ string(2491));
		createNoticeButton(ENoticeType.TYPE_AWAKENED, 2491);
	}
	else
	{
		removeNoticeButton(int(ENoticeType.TYPE_AWAKENED));
	}
}

function HandleShowProductInventory()
{
	local WindowHandle win;

	win = GetWindowHandle("ProductInventoryWnd");

	if(!win.IsShowWindow())
	{
		win.ShowWindow();
		win.SetFocus();
	}
	else
	{
		ProductInventoryWnd(GetScript("ProductInventoryWnd")).refresh();
	}
}

function SetShowWindow()
{
	local bool bStateCheck;

	bStateCheck = GetGameStateName() == "GAMINGSTATE";
	bStateCheck = (bStateCheck || GetGameStateName() == "ARENAGAMINGSTATE");

	if(IsShowWindow() == false && bStateCheck)
	{
		ShowWindow();
	}
}

function OnEnterState(name a_CurrentStateName)
{
	SetShowWindow();
}

function checkMultiLayOut()
{
	local string param;

	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0);
	ParamAdd(param, "w", "-46");
	ParamAdd(param, "h", "-140");
	CallGFxFunction("noticeWnd", LAYOUT_ONELINE, param);
}

function ArriveNewTutorialQuestion(string param)
{
	local int toolTipNum;

	ParseInt(param, "toolTipNum", toolTipNum);

	if(toolTipNum <= 0)
	{
		toolTipNum = 448;
	}

	createNoticeButtonWithParam(ENoticeType.TYPE_TUTORIAL, toolTipNum, param);
}

function createNoticeButton(int nType, int nTooltipString, optional string forceTooltipString)
{
	local string paramStr;

	if(checkIisPrologueGrowType(nType))
	{
		return;
	}

	//GetINIBool ("Localize", "UsePledgeV2Live", nUsePledgeV2Live, "L2.ini");
	
	//if(nUsePledgeV2Live > 0 && IsPlayerOnWorldRaidServer() && nType == ENoticeType.TYPE_TODOLIST) return;
	if(getInstanceL2Util().isClanV2() && IsPlayerOnWorldRaidServer() && nType == ENoticeType.TYPE_TODOLIST) return;

	ParamAdd(paramStr, "toolTipNum", string(nTooltipString));
	if(forceTooltipString != "")
	{
		paramStr = "";
		ParamAdd(paramStr, "toolTipString", forceTooltipString);
	}

	CallGFxFunction("noticeWnd", string(nType), paramStr);
}

function createNoticeButtonWithParam(int nType, int nTooltipString, string paramStr)
{
	if(checkIisPrologueGrowType(nType))
	{
		return;
	}

	//GetINIBool ("Localize", "UsePledgeV2Live", nUsePledgeV2Live, "L2.ini");
	
	//if(nUsePledgeV2Live > 0 && IsPlayerOnWorldRaidServer() && nType == ENoticeType.TYPE_TODOLIST) return;
	if(getInstanceL2Util().isClanV2() && IsPlayerOnWorldRaidServer() && nType == ENoticeType.TYPE_TODOLIST) return;

	ParamAdd(paramStr, "toolTipNum", string(nTooltipString));
	CallGFxFunction("noticeWnd", string(nType), paramStr);
}

function removeNoticeButton(int nType)
{
	local string paramStr;

	if(IsShowWindow())
	{
		ParamAdd(paramStr, "type", string(nType));
		CallGFxFunction("noticeWnd", NOTICEBUTTON_DELETE, paramStr);
	}
}

function removeALLNoticeButton()
{
	if(IsShowWindow())
	{
		CallGFxFunction("noticeWnd", NOTICEBUTTON_DELETEALL, "");
	}
}

function hideNoticeButton_QUEST()
{
	removeNoticeButton(ENoticeType.TYPE_QUEST);
}

function hideNoticeButton_PVPBLOCKCHECKER()
{
	removeNoticeButton(ENoticeType.TYPE_PVPBLOCKCHECKER);
}

function hideNoticeButton_PVPCRATAECUBE()
{
	removeNoticeButton(ENoticeType.TYPE_PVPCRATAECUBE);
}

function hideNoticeButton_PVPMATCHRECORD()
{
	removeNoticeButton(ENoticeType.TYPE_PVPMATCHRECORD);
}

function hideNoticeButton_PVPCLEFT()
{
	removeNoticeButton(ENoticeType.TYPE_PVPCLEFT);
}

function hideNoticeButton_CAMPAIGN()
{
	removeNoticeButton(ENoticeType.TYPE_CAMPAIGN);
}

function hideNoticeButton_ZONE()
{
	removeNoticeButton(ENoticeType.TYPE_ZONE);
}

function handleChangedSubjob(string param)
{
	local bool tmpIsPrologueGrowTypeState;
	local UserInfo info;

	tmpIsPrologueGrowTypeState = getisPrologueGrowTypeState(param);
	if(tmpIsPrologueGrowTypeState != isPrologueGrowTypeState)
	{
		isPrologueGrowTypeState = tmpIsPrologueGrowTypeState;

		if(!isPrologueGrowTypeState)
		{
			if(EventInfoWnd(GetScript("EventInfoWnd")).hasNoticeIcon)
			{
				EventInfoArrived();
			}
			if(GetPlayerInfo(Info))
			{
				if(Info.nClanID <= 0)
				{
					createNoticeButton(ENoticeType.TYPE_PLEDGEALARM, 3068);
				}
			}

			//	if(bUseL2Button())
			//		createNoticeButton(ENoticeType.TYPE_NSHOPHOME, 3634);

			if(isGetPremium)
			{
				PremiumItemAlarm();
			}
		}
	}
}

function bool getisPrologueGrowTypeState(string param)
{
	local int currentClassID;

	if(param != "")
	{
		ParseInt(param, "CurrentSubjobClassID", currentClassID);
	}
	return getInstanceL2Util().getIsPrologueGrowType(currentClassID);
}

function bool checkIisPrologueGrowType(int nType)
{
	if(isPrologueGrowTypeState) //getInstanceL2Util().getIsPrologueGrowType())
	{
		switch(nType)
		{
			case ENoticeType.TYPE_PREM:
				isGetPremium = true;
			case ENoticeType.TYPE_TUTORIAL:
			case ENoticeType.TYPE_PLEDGEALARM:
			case ENoticeType.TYPE_EVENT_INFO:
			case ENoticeType.TYPE_NSHOPHOME:
				return true;
		}
	}

	return false;
}

defaultproperties
{
}
