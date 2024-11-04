class UniqueGacha extends UICommonAPI;

const TimeID_RemainTime = 1001022;
const GACHA_TITLE_FORM = 1;
const GACHA_VIDEO_FORM = 2;
const GACHA_GAME_FORM = 3;
const GACHA_GETUR_RESULT_FORM = 4;
const RANK_UR = 1;
const RANK_SR = 2;
const RANK_R = 3;

var WindowHandle Me;
var RichListCtrlHandle History_ListCtrl;
var string m_WindowName;
var int nVideoRankType;
var int nFirstSettting;
var array<UniqueGachaItemInfo> ShowItemInfo;
var array<UniqueGachaItemInfo> RewardItemInfo;
var array<UniquegachaGameTypeInfo> GameTypeInfo;
var int CostType;
var int CostItemType;
var int nResult;
var int nMyConfirmCount;
var int nRemainSecTime;
var int nFullInfo;
var int nShowProb;
var int nOpenMode;
var INT64 nMyCostItemAmount;
var INT64 gamePrice1;
var INT64 gamePrice11;
var UIPacket._S_EX_UNIQUE_GACHA_GAME gacha_game_packet;
var WindowHandle GachaRewardList01_wnd;
var WindowHandle GachaRewardList02_wnd;
var WindowHandle UIControlDialogAsset;
var int currentGachaGameNum;
var string gachaURLLink;
var int nOpenURCardNum;
var int currentFormStepNum;
var string bigCardPathAdd;
var L2UITimerObject timeObjectMotion;

function OnRegisterEvent()
{
	RegisterEvent(EV_UniqueGachaOpen);
	RegisterEvent(EV_NotifyWM_SetFocus);
	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_UNIQUE_GACHA_GAME);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_UNIQUE_GACHA_HISTORY);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_UNIQUE_GACHA_SIDEBAR_INFO);
	RegisterEvent(EV_GotoWorldRaidServer);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	SetPopupScript();

	if(GetLanguage() == LANG_Japanese)
	{
		GetMeButton("J_btn").ShowWindow();
	} else {
		GetMeButton("J_btn").HideWindow();
	}
	nFirstSettting = 1;
	GetINIString("URL", "L2UniqueGachaURL", gachaURLLink, "L2.ini");
	History_ListCtrl.SetSelectedSelTooltip(false);
	History_ListCtrl.SetAppearTooltipAtMouseX(true);
	History_ListCtrl.SetSelectable(false);
	GetMeRichListCtrl("GachaRewardList01_wnd.GachaRewardList01").SetSelectedSelTooltip(false);
	GetMeRichListCtrl("GachaRewardList01_wnd.GachaRewardList01").SetAppearTooltipAtMouseX(true);
	GetMeRichListCtrl("GachaRewardList01_wnd.GachaRewardList01").SetSelectable(false);
	GetMeRichListCtrl("GachaRewardList01_wnd.GachaRewardList02").SetSelectedSelTooltip(false);
	GetMeRichListCtrl("GachaRewardList01_wnd.GachaRewardList02").SetAppearTooltipAtMouseX(true);
	GetMeRichListCtrl("GachaRewardList01_wnd.GachaRewardList02").SetSelectable(false);
}

function Initialize()
{
	Me = GetWindowHandle(m_WindowName);
	History_ListCtrl = GetMeRichListCtrl("UniqueGachaHistoryListWnd.History_ListCtrl");
}

function OnShow()
{
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		Me.HideWindow();
		return;
	}
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_WindowName, Me.IsShowWindow());
	showDisable(true);

	if(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset").IsShowWindow())
	{
		GetPopupExpandScript().Hide();
	}
	if(GetMeWindow("Result_wnd").IsShowWindow())
	{
		GetMeWindow("Result_wnd").HideWindow();
	}
	if(GetMeWindow("URReward_wnd").IsShowWindow())
	{
		GetMeWindow("URReward_wnd").HideWindow();
	}
	if(GetMeWindow("UniqueGachaHistoryListWnd").IsShowWindow())
	{
		GetMeWindow("UniqueGachaHistoryListWnd").HideWindow();
	}
	if(GetMeWindow("GachaRewardList01_wnd").IsShowWindow())
	{
		GetMeWindow("GachaRewardList01_wnd").HideWindow();
	}
	if(GetMeWindow("GachaRewardList02_wnd").IsShowWindow())
	{
		GetMeWindow("GachaRewardList02_wnd").HideWindow();
	}
	API_C_EX_UNIQUE_GACHA_OPEN(nFirstSettting, 1);
}

function OnHide()
{
	if(GetUniqueGachaVideo())
	{
		SetUniqueGachaVideo(false);
		ExecuteEvent(EV_DeleteSceneClipView, "");
	}
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_WindowName, Me.IsShowWindow());
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local int Index;

	if(a_ButtonHandle.GetWindowName() == "ResultCard_btn")
	{
		Debug("GetWindowName" @ a_ButtonHandle.GetWindowName());
		Debug("GetParentWindowName" @ a_ButtonHandle.GetParentWindowName());

		if(ToUpper("ResultCard01_BigWnd") == ToUpper(a_ButtonHandle.GetParentWindowName()))
		{
			Index = int(Mid(a_ButtonHandle.GetParentWindowName(), 10, 2));
		} else {
			Index = int(Mid(a_ButtonHandle.GetParentWindowName(), 10, 2));
		}
		Debug("index" @ string(Index));
		setCardFront(Index);
	}
}

function OnClickButton(string Name)
{
	Debug("Name" @ Name);
	switch(Name)
	{
		case "Gacha1_Btn":
			currentGachaGameNum = 1;
			if(currentGachaGameNum == 1)
			{
				bigCardPathAdd = "Big";
			}
			ShowPopup(currentGachaGameNum);
			break;
		case "Gacha10_Btn":
			currentGachaGameNum = 11;

			if(currentGachaGameNum == 11)
			{
				bigCardPathAdd = "";
			}
			ShowPopup(currentGachaGameNum);
			break;
		case "J_btn":
			OnJapanBtnClicked();
			break;
		case "History_btn":
			if(GetMeWindow("UniqueGachaHistoryListWnd").IsShowWindow())
			{
				GetMeWindow("UniqueGachaHistoryListWnd").HideWindow();				
			}
			else
			{
				showDisable(true);
				GetMeWindow("UniqueGachaHistoryListWnd").ShowWindow();
				API_C_EX_UNIQUE_GACHA_HISTORY();
			}
			break;
		case "Storage_btn":
			toggleWindow("UniqueGachaWarehouseWnd", true);
			break;
		case "GachaRewardList_Btn":
			showDisable(true);
			showRewardTotalList(RewardItemInfo, numToBool(nShowProb));
			break;
		case "Close_Btn":
			Me.HideWindow();
			break;
		case "List01Close_Btn":
			showDisable(false);
			GetMeWindow("GachaRewardList01_wnd").HideWindow();
			break;
		case "List02Close_Btn":
			showDisable(false);
			GetMeWindow("GachaRewardList02_wnd").HideWindow();
			break;
		case "RewardClose_Btn":
		case "URRewardConfirm_btn":
			showDisable(false);
			GetMeWindow("URReward_wnd").HideWindow();
			GetMeWindow("Result_wnd").ShowWindow();
			GetMeEffectViewportWnd("URReward_wnd.UREffectViewport").SpawnEffect("");
			GetMeEffectViewportWnd("URReward_wnd.UREffectViewport02").SpawnEffect("");
			AnimTexturePlay(GetMeAnimTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(nOpenURCardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardOpenEffect_tex"), true, 1);
			GetMeEffectViewportWnd("Result_wnd.ResultCard" $ fillZeroString(2, string(nOpenURCardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardOpenEffect02_tex").SpawnEffect("LineageEffect.d_ar_attractcubic_ta");
			break;
		case "ResultConfirm_btn":
			openAllRCard();
			break;
		case "GachaExit_Btn":
			setShowStep(1);
			break;
		case "GachaCostCharge_btn":
			OpenWebSite(gachaURLLink);
			break;
		case "HistoryListClose_Btn":
			showDisable(false);
			GetMeWindow("UniqueGachaHistoryListWnd").HideWindow();
			break;
		case "Refresh_btn":
			API_C_EX_UNIQUE_GACHA_HISTORY();
			break;
	}
}

function OnEvent(int a_EventID, string a_Param)
{
	local array<ItemInfo> iInfos;

	switch(a_EventID)
	{
		case EV_UniqueGachaOpen:
			UniqueGachaOpenHandle(a_Param);

			if(nOpenMode == 1)
			{
				setShowStep(1);
			}
			break;
		case EV_NotifyWM_SetFocus:
			if(Me.IsShowWindow())
			{
				if(GetWindowHandle(m_WindowName $ ".disable_tex").IsShowWindow() == false)
				{
					Debug("EV_NotifyWM_SetFocus");
					API_C_EX_UNIQUE_GACHA_OPEN(nFirstSettting, 0);
				}
			}
			break;
		case EV_Restart:
			Me.KillTimer(TimeID_RemainTime);
			nFirstSettting = 1;
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_UNIQUE_GACHA_GAME):
			ParsePacket_S_EX_UNIQUE_GACHA_GAME();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_UNIQUE_GACHA_HISTORY):
			ParsePacket_S_EX_UNIQUE_GACHA_HISTORY();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_UNIQUE_GACHA_SIDEBAR_INFO):
			ParsePacket_S_EX_UNIQUE_GACHA_SIDEBAR_INFO();
			break;
		case EV_AdenaInvenCount:
			if(CostType == 1 && CostItemType > 0)
			{
				class'UIDATA_INVENTORY'.static.FindItemByClassID(CostItemType, iInfos);

				if(iInfos.Length > 0)
				{
					nMyCostItemAmount = iInfos[0].ItemNum;
					GetMeTextBox("GachaCost_wnd.GachaCostNum_txt").SetText(MakeCostString(string(nMyCostItemAmount)));
					checkGameStartButtonState();
				}
			}
			break;
		case EV_GotoWorldRaidServer:
			if(Me.IsShowWindow())
			{
				Me.HideWindow();
			}
			break;
	}
}

function ParsePacket_S_EX_UNIQUE_GACHA_SIDEBAR_INFO()
{
	local UIPacket._S_EX_UNIQUE_GACHA_SIDEBAR_INFO packet;
	local SideBar SideBarScript;

	SideBarScript = SideBar(GetScript("SideBar"));

	if(! class'UIPacket'.static.Decode_S_EX_UNIQUE_GACHA_SIDEBAR_INFO(packet))
	{
		return;
	}
	Debug("---> ����ũ ��í Sidebar packet.cOnOffFlag: " @ string(packet.cOnOffFlag));

	if(packet.cOnOffFlag == 1)
	{
		SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_UNIQUEGACHA, true);
	}
	else
	{
		SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_UNIQUEGACHA, false);
	}
}

function ParsePacket_S_EX_UNIQUE_GACHA_HISTORY()
{
	local UIPacket._S_EX_UNIQUE_GACHA_HISTORY packet;
	local int i;

	if(! class'UIPacket'.static.Decode_S_EX_UNIQUE_GACHA_HISTORY(packet))
	{
		return;
	}
	History_ListCtrl.DeleteAllItem();

	for(i = 0; i < packet.historyItems.Length; i++)
	{
		Debug(" -->  Decode_S_EX_UNIQUE_GACHA_HISTORY :  " @ string(packet.historyItems[i].nGetTimeSec));
		Debug(" -->  cRankType :  " @ string(packet.historyItems[i].itemBaseInfo.cRankType));
		Debug(" -->  nItemType :  " @ string(packet.historyItems[i].itemBaseInfo.nItemType));
		Debug(" -->  nAmount   :  " @ string(packet.historyItems[i].itemBaseInfo.nAmount));
		Debug(" -->  nGetTimeSec   :  " @ string(packet.historyItems[i].nGetTimeSec));
		addRichListRowDataHistory(packet.historyItems[i].itemBaseInfo.cRankType, packet.historyItems[i].itemBaseInfo.nItemType, packet.historyItems[i].itemBaseInfo.nAmount, packet.historyItems[i].nGetTimeSec);
	}
}

function addRichListRowDataHistory(int cRankType, int ClassID, INT64 nAmount, int RemainSec)
{
	local RichListCtrlRowData RowData;
	local ItemInfo Info;
	local Color itemNameColor;

	RowData.cellDataList.Length = 3;
	Info = GetItemInfoByClassID(ClassID);
	Info.ItemNum = nAmount;

	if(Info.ItemNum > 1)
	{
		Info.bShowCount = true;
	}
	if(cRankType == 1)
	{
		RowData.sOverlayTex = "L2UI_NewTex.UniqueGacha.UniqueGachaListURBg02";
		RowData.OverlayTexU = 494;
		RowData.OverlayTexV = 45;
		itemNameColor = GTColor().BrightWhite;		
	}
	else if(cRankType == 2)
	{
		RowData.sOverlayTex = "L2UI_NewTex.UniqueGacha.UniqueGachaListSRBg02";
		RowData.OverlayTexU = 494;
		RowData.OverlayTexV = 45;
		itemNameColor = GTColor().BrightWhite;
	}
	else
	{
		itemNameColor = GTColor().White;
	}
	ItemInfoToParam(Info, RowData.szReserved);
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, Info, 32, 32, 6, 6);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetItemNameAllByClassID(ClassID), itemNameColor, false, 4, 8);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, MakeCostStringINT64(nAmount), GTColor().White, false, 0, 12);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, getInstanceL2Util().getTimeStringBySec2(RemainSec), GTColor().White, false, 0, 12);
	History_ListCtrl.InsertRecord(RowData);
}

function setShowStep(int stepNum)
{
	local int i;

	currentFormStepNum = stepNum;

	if(stepNum == GACHA_TITLE_FORM)
	{
		GetMeButton("Storage_btn").EnableWindow();
		GetMeButton("History_btn").EnableWindow();
		GetMeWindow("GachaReward_wnd").ShowWindow();
		GetMeWindow("GachaBtn_wnd").ShowWindow();
		GetMeButton("GachaBtn_wnd.GachaExit_Btn").HideWindow();
		GetMeWindow("Result_wnd").HideWindow();
		GetMeWindow("GachaCost_wnd").ShowWindow();
		GetMeButton("Close_Btn").ShowWindow();
		GetMeTexture("ResultBg_tex").HideWindow();
		GetMeWindow("LeftTime_wnd").ShowWindow();

		for(i = 0; i < ShowItemInfo.Length; i++)
		{
			setDefaultShowItemInfo(i + 1, ShowItemInfo[i].RankType, ShowItemInfo[i].ItemType, ShowItemInfo[i].Amount);
		}
		updateGachaBtn_wnd();
		checkGameStartButtonState();		
	}
	else if(stepNum == GACHA_VIDEO_FORM)
	{
		GetMeButton("Close_Btn").HideWindow();

		if(nVideoRankType == RANK_UR || nVideoRankType == RANK_SR)
		{
			SceneClipView(GetScript("SceneClipView")).customPlayUsm(-4, -4, 894, 620, 1, 4, "unique_01b.usm", SceneClipView(GetScript("SceneClipView")).const.MOVIEID_GACHA_URSR, "UniqueGacha");
			SetUniqueGachaVideo(true);
			showDisable(true);
			GetMeWindow("GachaBtn_wnd").HideWindow();				
		}
		else
		{
			SceneClipView(GetScript("SceneClipView")).customPlayUsm(-4, -4, 894, 620, 1, 4, "unique_01a.usm", SceneClipView(GetScript("SceneClipView")).const.MOVIEID_GACHA_R, "UniqueGacha");
			SetUniqueGachaVideo(true);
			showDisable(true);
			GetMeWindow("GachaBtn_wnd").HideWindow();
		}			
	}
	else if(stepNum == GACHA_GAME_FORM)
	{
		showDisable(false);
		SetUniqueGachaVideo(false);
		GetMeButton("Storage_btn").DisableWindow();
		GetMeButton("History_btn").DisableWindow();
		GetMeWindow("GachaReward_wnd").HideWindow();
		GetMeWindow("GachaBtn_wnd").HideWindow();
		GetMeWindow("Result_wnd").ShowWindow();
		GetMeTextBox("Result_wnd.ResultConfirm_txt").ShowWindow();
		GetMeButton("Result_wnd.ResultConfirm_btn").ShowWindow();
		GetMeTexture("ResultBg_tex").ShowWindow();
		GetMeWindow("LeftTime_wnd").HideWindow();

		if(bHasOnlyRHigherCard())
		{
			GetMeButton("Result_wnd.ResultConfirm_btn").DisableWindow();
			GetMeTextBox("Result_wnd.ResultConfirm_txt").SetText(GetSystemString(5235));					
		}
		else
		{
			GetMeButton("Result_wnd.ResultConfirm_btn").EnableWindow();
			GetMeTextBox("Result_wnd.ResultConfirm_txt").SetText(GetSystemString(5234));
		}
		GetMeButton("Close_Btn").HideWindow();
		ShowAllMotionCards();				
	}
	else if(stepNum == GACHA_GETUR_RESULT_FORM)
	{
		showDisable(true);
		SetUniqueGachaVideo(false);
		GetMeWindow("Result_wnd").HideWindow();
		GetMeWindow("URReward_wnd").ShowWindow();
		GetMeWindow("URReward_wnd").SetFocus();
		GetMeEffectViewportWnd("URReward_wnd.UREffectViewport").SpawnEffect("LineageEffect.d_ar_attractcubic_ta");
		GetMeEffectViewportWnd("URReward_wnd.UREffectViewport02").SpawnEffect("LineageEffect2.ave_white_trans_deco");
		getInstanceL2Util().childWindowMoveToCenter(Me, GetMeWindow(m_WindowName $ ".URReward_wnd"));
		L2UITween(GetScript("l2UITween")).StartShake(m_WindowName $ ".URReward_wnd", 6, 1000, L2UITween(GetScript("l2UITween")).directionType.small, 0);
		playNpcViewport(GetMeCharacterViewportWindow("URReward_wnd.Object01Viewport"), 8275, 170, 33000, 0, 0, 0.0f, "", 1);
		playNpcViewport(GetMeCharacterViewportWindow("URReward_wnd.Object02Viewport"), 8276, 170, 33000, 0, 0, 0.0f, "", 0);
		GetMeButton("Close_Btn").ShowWindow();
	}
}

function ShowAllMotionCards()
{
	local int i;
	local WindowHandle W;

	for(i = 0; i < gacha_game_packet.ResultItems.Length; i++)
	{
		W = GetMeWindow("Result_wnd.ResultCard" $ fillZeroString(2, string(i + 1)) $ "_" $ bigCardPathAdd $ "wnd");
		W.ClearAnchor();
		W.SetAlpha(0);
		TweenAdd(W, 255, i + 1, 500, 0, 15, class'L2UITween'.static.Inst().easeType.OUT_BOUNCE, i * 50);

		if(gacha_game_packet.ResultItems[i].cRankType == RANK_SR || gacha_game_packet.ResultItems[i].cRankType == RANK_UR)
		{
			AnimTexturePlay(GetMeAnimTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(i + 1)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardEffect02_tex"), true, 99999999);
			continue;
		}
		AnimTextureStop(GetMeAnimTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(i + 1)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardEffect02_tex"), true);
	}
	timeObjectMotion = class'L2UITimer'.static.Inst()._AddNewTimerObject(50, gacha_game_packet.ResultItems.Length);
	timeObjectMotion._DelegateOnTime = OnTimeMotion;
	timeObjectMotion._Stop();
	timeObjectMotion._Play();
}

function OnTimeMotion(int Count)
{
	local string smallString;

	if(currentGachaGameNum == 11)
	{
		smallString = "small";
	}
	GetMeAnimTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(Count + 1)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardOpenAni_tex").SetTexture("L2UI_NewTex.UniqueGacha.UniqueGacha" $ getCardType(Count + 1) $ "OpenAni" $ smallString $ "_01");
	AnimTexturePlay(GetMeAnimTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(Count + 1)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardOpenAni_tex"), true, 1);
}

function string getCardType(int cardSquenceNum)
{
	switch(cardSquenceNum)
	{
		case 1:
			return "B";
		case 2:
			return "A";
		case 3:
			return "B";
		case 4:
			return "A";
		case 5:
			return "B";
		case 6:
			return "A";
		case 7:
			return "A";
		case 8:
			return "B";
		case 9:
			return "A";
		case 10:
			return "B";
		case 11:
			return "A";

		default:
			Debug("���!!! getCardType error, �߸��� CardSquenceNum�� �־���.");
			return "";
	}
}

function string getCardRankString(int Rank)
{
	switch(Rank)
	{
		case RANK_UR:
			return "UR";
		case RANK_SR:
			return "SR";
		case RANK_R:
			return "R";
		default:
			Debug("���!!! getCardRankString error, �߸��� rank�� �־���.");
			return "";
	}
}

function openAllRCard()
{
	local int i, cardNum;

	cardNum = gacha_game_packet.ResultItems.Length;

	for(i = 0; i < cardNum; i++)
	{
		if(gacha_game_packet.ResultItems[i].cRankType == RANK_R)
		{
			setCardFront(i + 1);
		}
	}
	if(bAllCardFront())
	{
		GetMeTextBox("Result_wnd.ResultConfirm_txt").SetText(GetSystemString(5234));		
	}
	else
	{
		GetMeTextBox("Result_wnd.ResultConfirm_txt").SetText(GetSystemString(5235));
	}
}

function bool bAllCardFront()
{
	local int i, cardNum, openCardNum;

	cardNum = gacha_game_packet.ResultItems.Length;

	for(i = 0; i < cardNum; i++)
	{
		if(GetMeItemWindow("Result_wnd.ResultCard" $ fillZeroString(2, string(i + 1)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardItem_itemwindow").IsShowWindow())
		{
			++ openCardNum;
		}
	}
	Debug("openCardNum" @ string(openCardNum));
	Debug("cardNum" @ string(cardNum));

	if(openCardNum == cardNum)
	{
		return true;
	}
	return false;
}

function bool bHasOnlyRHigherCard()
{
	local int i, cardNum, totalHigherCardNum;

	cardNum = gacha_game_packet.ResultItems.Length;

	for(i = 0; i < cardNum; i++)
	{
		if(gacha_game_packet.ResultItems[i].cRankType == RANK_SR || gacha_game_packet.ResultItems[i].cRankType == RANK_UR)
		{
			totalHigherCardNum++;
		}
	}
	if(cardNum == totalHigherCardNum)
	{
		return true;
	}
	return false;
}

function bool bAllRCardFront()
{
	local int i, cardNum, openCardNum, totalRCardNum;

	cardNum = gacha_game_packet.ResultItems.Length;

	for(i = 0; i < cardNum; i++)
	{
		if(gacha_game_packet.ResultItems[i].cRankType == 3)
		{
			if(GetMeItemWindow("Result_wnd.ResultCard" $ fillZeroString(2, string(i + 1)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardItem_itemwindow").IsShowWindow())
			{
				openCardNum++;
			}
			totalRCardNum++;
		}
	}

	if(openCardNum == totalRCardNum)
	{
		return true;
	}
	return false;
}

function setCardFront(int cardNum)
{
	local int Rank, ClassID;
	local INT64 Amount;
	local string bigString;

	Rank = gacha_game_packet.ResultItems[cardNum - 1].cRankType;
	ClassID = gacha_game_packet.ResultItems[cardNum - 1].nItemType;
	Amount = gacha_game_packet.ResultItems[cardNum - 1].nAmount;
	GetMeButton("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCard_btn").HideWindow();

	if(Rank == RANK_UR)
	{
		GetMeTextBox("URReward_wnd.URRewardName_txt").SetText(GetItemNameAllByClassID(ClassID));
		GetMeTextBox("URReward_wnd.URRewardNum_txt").SetText("x" $ string(Amount));
		GetMeItemWindow("URReward_wnd.URRewardIcon_Itemwindow").Clear();
		GetMeItemWindow("URReward_wnd.URRewardIcon_Itemwindow").AddItem(GetItemInfoByClassID(ClassID));
		GetMeButton("Close_Btn").HideWindow();
		SceneClipView(GetScript("SceneClipView")).customPlayUsm(-4, -4, 894, 620, 1, 4, "unique_02.usm", SceneClipView(GetScript("SceneClipView")).const.MOVIEID_GACHA_GET_UR, "UniqueGacha");
		SetUniqueGachaVideo(true);
		showDisable(true);
	}
	GetMeItemWindow("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardItem_itemwindow").ShowWindow();
	GetMeItemWindow("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardItem_itemwindow").Clear();
	GetMeItemWindow("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardItem_itemwindow").AddItem(GetItemInfoByClassID(ClassID));
	GetMeTextBox("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardItemNum_txt").ShowWindow();
	GetMeTextBox("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardItemNum_txt").SetText("x" $ string(Amount));

	if(Rank == RANK_UR)
	{
		GetMeEffectViewportWnd("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardOpenEffect02_tex").SpawnEffect("LineageEffect.d_ar_attractcubic_ta");
		GetMeAnimTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardOpenEffect_tex").SetTexture("L2UI_NewTex.SideBar.SideBar_VP_Apply_Effect_00");
		AnimTexturePlay(GetMeAnimTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardEffect02_tex"), true, 99999999);
	}
	else if(Rank == RANK_SR)
	{
		GetMeEffectViewportWnd("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardOpenEffect02_tex").SpawnEffect("LineageEffect.d_ar_attractcubic_ta");
		GetMeAnimTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardOpenEffect_tex").SetTexture("L2UI_NewTex.SideBar.SideBar_VP_Apply_Effect_00");
		AnimTexturePlay(GetMeAnimTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardEffect02_tex"), true, 99999999);
	}
	else
	{
		GetMeAnimTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardOpenEffect_tex").SetTexture("L2UI_NewTex.SideBar.SideBar_VP_Apply_Effect_00");
		AnimTextureStop(GetMeAnimTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardEffect02_tex"), true);
	}
	nOpenURCardNum = cardNum;
	AnimTexturePlay(GetMeAnimTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardOpenEffect_tex"), true, 1);

	if(currentGachaGameNum == 1)
	{
		bigString = "BIG";
	}
	GetMeTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardBackBg_tex").SetTexture("L2UI_NewTex.UniqueGacha.UniqueGacha" $ getCardType(cardNum) $ bigString $ "_" $ getCardRankString(Rank));
	GetMeTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardBg_tex").ShowWindow();
	GetMeTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardBg02_tex").ShowWindow();

	if(bAllCardFront())
	{
		GetMeTextBox("Result_wnd.ResultConfirm_txt").HideWindow();
		GetMeButton("Result_wnd.ResultConfirm_btn").HideWindow();
		GetMeWindow("GachaBtn_wnd").ShowWindow();
		GetMeWindow("GachaBtn_wnd").SetFocus();
		updateGachaBtn_wnd();
		GetMeButton("GachaBtn_wnd.GachaExit_Btn").ShowWindow();

		if(GetUniqueGachaVideo() == false)
		{
			GetMeButton("Close_Btn").ShowWindow();
		}
	}
	if(bAllRCardFront())
	{
		GetMeButton("Result_wnd.ResultConfirm_btn").DisableWindow();		
	}
	else
	{
		GetMeButton("Result_wnd.ResultConfirm_btn").EnableWindow();
	}
}

function setCardBack(int cardNum, int Rank)
{
	local string bigString;

	GetMeButton("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCard_btn").ShowWindow();

	if(currentGachaGameNum == 1)
	{
		bigString = "BIG";
	}
	GetMeButton("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCard_btn").SetTexture("L2UI_CT1.Button.emptyBtn_over", "L2UI_CT1.Button.emptyBtn_over", "L2UI_NewTex.UniqueGacha.UniqueGacha" $ getCardType(cardNum) $ bigString $ "_Over");
	GetMeTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardBg_tex").HideWindow();
	GetMeTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardBackBg_tex").ShowWindow();
	GetMeTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardBackBg_tex").SetTexture("L2UI_NewTex.UniqueGacha.UniqueGacha" $ getCardType(cardNum) $ bigString $ "_" $ getCardRankString(Rank));
	GetMeTexture("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardBg02_tex").HideWindow();
	GetMeItemWindow("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardItem_itemwindow").HideWindow();
	GetMeTextBox("Result_wnd.ResultCard" $ fillZeroString(2, string(cardNum)) $ "_" $ bigCardPathAdd $ "wnd.ResultCardItemNum_txt").HideWindow();
}

function checkGameStartButtonState()
{
	local bool bBgAnim;

	if(nMyCostItemAmount >= gamePrice1 && nRemainSecTime > 0)
	{
		GetMeButton("GachaBtn_wnd.Gacha1_Btn").EnableWindow();
		GetMeButton("GachaBtn_wnd.Gacha1_Btn").SetTooltipCustomType(MakeTooltipSimpleText(""));		
	}
	else
	{
		GetMeButton("GachaBtn_wnd.Gacha1_Btn").DisableWindow();
		GetMeButton("GachaBtn_wnd.Gacha1_Btn").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(5229)));
	}
	if(nMyCostItemAmount >= gamePrice11 && nRemainSecTime > 0)
	{
		GetMeButton("GachaBtn_wnd.Gacha10_Btn").EnableWindow();
		GetMeButton("GachaBtn_wnd.Gacha10_Btn").SetTooltipCustomType(MakeTooltipSimpleText(""));		
	}
	else
	{
		GetMeButton("GachaBtn_wnd.Gacha10_Btn").DisableWindow();
		GetMeButton("GachaBtn_wnd.Gacha10_Btn").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(5229)));
	}
	if(nMyConfirmCount == 1)
	{
		bBgAnim = true;
		AnimTexturePlay(GetMeAnimTexture("GachaBtn_wnd.100%Gacha1_tex"), true, 999999999);

		if(GetMeButton("GachaBtn_wnd.Gacha1_Btn").IsEnableWindow())
		{
			GetMeButton("GachaBtn_wnd.Gacha1_Btn").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(6230)));
		}		
	}
	else
	{
		GetMeAnimTexture("GachaBtn_wnd.100%Gacha1_tex").HideWindow();

		if(GetMeButton("GachaBtn_wnd.Gacha1_Btn").IsEnableWindow())
		{
			GetMeButton("GachaBtn_wnd.Gacha1_Btn").SetTooltipCustomType(MakeTooltipSimpleText(""));
		}
	}
	if(nMyConfirmCount <= 11 && nMyConfirmCount >= 0)
	{
		bBgAnim = true;
		AnimTexturePlay(GetMeAnimTexture("GachaBtn_wnd.100%Gacha10_tex"), true, 999999999);

		if(GetMeButton("GachaBtn_wnd.Gacha10_Btn").IsEnableWindow())
		{
			GetMeButton("GachaBtn_wnd.Gacha10_Btn").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(6230)));
		}		
	}
	else
	{
		GetMeAnimTexture("GachaBtn_wnd.100%Gacha10_tex").HideWindow();

		if(GetMeButton("GachaBtn_wnd.Gacha10_Btn").IsEnableWindow())
		{
			GetMeButton("GachaBtn_wnd.Gacha10_Btn").SetTooltipCustomType(MakeTooltipSimpleText(""));
		}
	}
	if(bBgAnim)
	{
		if(currentFormStepNum == 3)
		{
			GetMeAnimTexture("GachaBtn_wnd.100%DescBg_tex").SetTexture("L2UI_NewTex.UniqueGacha.UniqueGachaResultDescAni_00");			
		}
		else
		{
			GetMeAnimTexture("GachaBtn_wnd.100%DescBg_tex").SetTexture("L2UI_NewTex.UniqueGacha.UniqueGachaMainDescAni_00");
		}
		AnimTexturePlay(GetMeAnimTexture("GachaBtn_wnd.100%DescBg_tex"), true, 999999999);		
	}
	else
	{
		GetMeAnimTexture("GachaBtn_wnd.100%DescBg_tex").HideWindow();
	}
}

function updateGachaBtn_wnd()
{
	local string htmlAdd;

	htmlAdd = htmlAddTableTD(MakeFullSystemMsg(htmlAddText(GetSystemMessage(6229), "hs11", "FFFFFF"), MakeFullSystemMsg(htmlAddText(GetSystemMessage(6238), "hs12", "EBCD00"), string(nMyConfirmCount))), "center", "Bottom", 0, 0, "", false);
	htmlSetTableTR(htmlAdd);
	htmlSetTable(htmlAdd, 0, 600, 0, "", 0, 0);
	GetMeHtml("GachaBtn_wnd.Desc_txt").LoadHtmlFromString(htmlSetHtmlStart(htmlAdd));

	if(nMyConfirmCount > 0)
	{
		GetMeHtml("GachaBtn_wnd.Desc_txt").ShowWindow();
		Debug("==================> currentFormStepNum" @ string(currentFormStepNum));

		if(currentFormStepNum == 1)
		{
			GetMeTexture("GachaBtn_wnd.DescBg_tex").SetTexture("L2UI_NewTex.UniqueGacha.UniqueGachaMainDescBg");			
		}
		else
		{
			GetMeTexture("GachaBtn_wnd.DescBg_tex").SetTexture("L2UI_NewTex.UniqueGacha.UniqueGachaResultDescBg");
		}
		GetMeTexture("GachaBtn_wnd.DescBg_tex").ShowWindow();		
	}
	else
	{
		GetMeHtml("GachaBtn_wnd.Desc_txt").HideWindow();
		GetMeTexture("GachaBtn_wnd.DescBg_tex").HideWindow();
		GetMeAnimTexture("GachaBtn_wnd.100%DescBg_tex").HideWindow();
	}
}

function ParsePacket_S_EX_UNIQUE_GACHA_GAME()
{
	local int i;
	local Rect R;

	if(! class'UIPacket'.static.Decode_S_EX_UNIQUE_GACHA_GAME(gacha_game_packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_UNIQUE_GACHA_GAME :  " @ string(gacha_game_packet.cResult));
	Debug(" -->  nMyCostItemAmount :  " @ string(gacha_game_packet.nMyCostItemAmount));
	Debug(" -->  nMyConfirmCount :  " @ string(gacha_game_packet.nMyConfirmCount));
	Debug(" -->  cRankType :  " @ string(gacha_game_packet.cRankType));
	Debug(" -->  resultItems.length :  " @ string(gacha_game_packet.ResultItems.Length));

	if(gacha_game_packet.cResult <= 0)
	{
		AddSystemMessage(4559);
		Me.HideWindow();
		return;
	}
	nVideoRankType = gacha_game_packet.cRankType;
	setShowStep(2);
	nMyCostItemAmount = gacha_game_packet.nMyCostItemAmount;
	nMyConfirmCount = gacha_game_packet.nMyConfirmCount;
	GetMeTextBox("GachaCost_wnd.GachaCostNum_txt").SetText(MakeCostString(string(nMyCostItemAmount)));

	if(GetMeWindow("UniqueGachaWarehouseWnd").IsShowWindow())
	{
		GetMeWindow("UniqueGachaWarehouseWnd").HideWindow();
	}
	updateGachaBtn_wnd();
	checkGameStartButtonState();

	if(gacha_game_packet.ResultItems.Length == 1)
	{
		for(i = 0; i < 11; i++)
		{
			GetMeWindow("Result_wnd.ResultCard" $ fillZeroString(2, string(i + 1)) $ "_wnd").HideWindow();
		}
		R = Me.GetRect();
		GetMeWindow("Result_wnd.ResultCard01_" $ bigCardPathAdd $ "wnd").ShowWindow();
		GetMeWindow("Result_wnd.ResultCard01_" $ bigCardPathAdd $ "wnd").ClearAnchor();
		GetMeWindow("Result_wnd.ResultCard01_" $ bigCardPathAdd $ "wnd").MoveTo(R.nX + 374, R.nY + 175);
		setCardBack(1, gacha_game_packet.ResultItems[0].cRankType);		
	}
	else
	{
		GetMeWindow("Result_wnd.ResultCard01_Bigwnd").HideWindow();
		R = Me.GetRect();

		for(i = 0; i < 11; i++)
		{
			GetMeWindow("Result_wnd.ResultCard" $ fillZeroString(2, string(i + 1)) $ "_wnd").ClearAnchor();

			if(i > 5)
			{
				GetMeWindow("Result_wnd.ResultCard" $ fillZeroString(2, string(i + 1)) $ "_wnd").MoveTo((R.nX + ((i - 5) * 150)) - 85, R.nY + 250);				
			}
			else
			{
				GetMeWindow("Result_wnd.ResultCard" $ fillZeroString(2, string(i + 1)) $ "_wnd").MoveTo((R.nX + (i * 140)) + 4, R.nY + 70);
			}
			GetMeWindow("Result_wnd.ResultCard" $ fillZeroString(2, string(i + 1)) $ "_wnd").ShowWindow();
			setCardBack(i + 1, gacha_game_packet.ResultItems[i].cRankType);
		}
	}
}

private function TweenAdd(WindowHandle targetWnd, int TargetAlpha, int Id, int Duration, int nX, int nY, L2UITween.easeType Type, optional float Delay)
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tweenObjectData.Id = Id;
	tweenObjectData.Target = targetWnd;
	tweenObjectData.Duration = float(Duration);
	tweenObjectData.Alpha = float(TargetAlpha);
	tweenObjectData.ease = Type;
	tweenObjectData.MoveX = float(nX);
	tweenObjectData.MoveY = float(nY);
	tweenObjectData.Delay = Delay;
	TweenStop(Id);
	class'L2UITween'.static.Inst().AddTweenObject(tweenObjectData);
}

private function TweenStop(int Id)
{
	class'L2UITween'.static.Inst().StopTween(m_hOwnerWnd.m_WindowNameWithFullPath, Id);
}

function UniqueGachaOpenHandle(string a_Param)
{
	local int i;

	ParseInt(a_Param, "Result", nResult);
	ParseInt(a_Param, "OpenMode", nOpenMode);
	ParseINT64(a_Param, "MyCostItemAmount", nMyCostItemAmount);
	ParseInt(a_Param, "MyConfirmCount", nMyConfirmCount);
	ParseInt(a_Param, "RemainSecTime", nRemainSecTime);
	ParseInt(a_Param, "FullInfo", nFullInfo);
	ParseInt(a_Param, "ShowProb", nShowProb);
	Debug("EV_UniqueGachaOpen" @ a_Param);

	if(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset").IsShowWindow() || GetMeWindow("GachaRewardList01_wnd").IsShowWindow() || GetMeWindow("GachaRewardList02_wnd").IsShowWindow() || GetMeWindow("UniqueGachaHistoryListWnd").IsShowWindow() || GetMeWindow("URReward_wnd").IsShowWindow())
	{
		showDisable(true);		
	}
	else
	{
		showDisable(false);
	}
	Debug("���� �ð�" @ getInstanceL2Util().getTimeStringBySec2(nRemainSecTime));
	GetMeTextBox("LeftTime_wnd.LeftTime_txt").SetText(getInstanceL2Util().getTimeStringBySec2(nRemainSecTime));

	if(nRemainSecTime > 0)
	{
		Me.KillTimer(TimeID_RemainTime);
		Me.SetTimer(TimeID_RemainTime, 60000);
	}
	GetMeTextBox("GachaCost_wnd.GachaCostNum_txt").SetText(MakeCostString(string(nMyCostItemAmount)));
	GetUniqueGachaCostInfo(CostType, CostItemType);
	Debug("=======================================================");
	Debug("CostType" @ string(CostType));
	Debug("CostItemType" @ string(CostItemType));
	GetUniqueGachaGameTypeInfo(GameTypeInfo);
	Debug("GameTypeInfo.Length : " @ string(GameTypeInfo.Length));

	for(i = 0; i < GameTypeInfo.Length; i++)
	{
		Debug("GameTypeInfo GameCount" @ string(GameTypeInfo[i].GameCount));
		Debug("GameTypeInfo CostItemAmount" @ string(GameTypeInfo[i].CostItemAmount));
		Debug("--------------------------------------------------------");

		if(GameTypeInfo[i].GameCount == 1)
		{
			GetMeTextBox("GachaBtn_wnd.Gacha1Num_txt").SetText(MakeCostString(string(GameTypeInfo[i].CostItemAmount)));
			gamePrice1 = GameTypeInfo[i].CostItemAmount;
			continue;
		}
		if(GameTypeInfo[i].GameCount == 11)
		{
			GetMeTextBox("GachaBtn_wnd.Gacha10Num_txt").SetText(MakeCostString(string(GameTypeInfo[i].CostItemAmount)));
			gamePrice11 = GameTypeInfo[i].CostItemAmount;
		}
	}
	updateGachaBtn_wnd();
	checkGameStartButtonState();

	if(nFirstSettting == 0)
	{
		return;
	}
	ShowItemInfo.Length = 0;
	RewardItemInfo.Length = 0;
	GameTypeInfo.Length = 0;
	GetUniqueGachaShowItem(ShowItemInfo);
	Debug("showItemInfo.Length : " @ string(ShowItemInfo.Length));

	for(i = 0; i < ShowItemInfo.Length; i++)
	{
		Debug("showItemInfo RankType" @ string(ShowItemInfo[i].RankType));
		Debug("showItemInfo ItemType" @ string(ShowItemInfo[i].ItemType));
		Debug("showItemInfo Amount" @ string(ShowItemInfo[i].Amount));
		Debug("showItemInfo fProb" @ string(ShowItemInfo[i].fProb));
		Debug("--------------------------------------------------------");
	}
	GetUniqueGachaRewardItem(RewardItemInfo);
	Debug("RewardItemInfo.Length : " @ string(RewardItemInfo.Length));

	for(i = 0; i < RewardItemInfo.Length; i++)
	{
		Debug("RewardItemInfo RankType" @ string(RewardItemInfo[i].RankType));
		Debug("RewardItemInfo ItemType" @ string(RewardItemInfo[i].ItemType));
		Debug("RewardItemInfo Amount" @ string(RewardItemInfo[i].Amount));
		Debug("RewardItemInfo fProb" @ string(RewardItemInfo[i].fProb));
		Debug("--------------------------------------------------------");
	}
	GetMeTexture("GachaCost_wnd.GachaCostIcon_tex").SetTexture(GetItemTextureNameByClassID(CostItemType));
	GetMeTexture("GachaCost_wnd.GachaCostIcon_tex").SetTooltipCustomType(MakeTooltipSimpleText(GetItemNameAllByClassID(CostItemType)));
	GetMeTexture("GachaBtn_wnd.Gacha1CostIcon_tex").SetTexture(GetItemTextureNameByClassID(CostItemType));
	GetMeTexture("GachaBtn_wnd.Gacha10CostIcon_tex").SetTexture(GetItemTextureNameByClassID(CostItemType));
	nFirstSettting = 0;
}

function OnTimer(int TimeID)
{
	if(TimeID == TimeID_RemainTime)
	{
		nRemainSecTime = nRemainSecTime - 60;

		if(nRemainSecTime <= 0)
		{
			Me.KillTimer(TimeID_RemainTime);
			nRemainSecTime = 0;
			GetMeTextBox("LeftTime_wnd.LeftTime_txt").SetText(GetSystemString(2662));
			checkGameStartButtonState();			
		}
		else
		{
			GetMeTextBox("LeftTime_wnd.LeftTime_txt").SetText(getInstanceL2Util().getTimeStringBySec2(nRemainSecTime));
		}
	}
}

function API_C_EX_UNIQUE_GACHA_OPEN(int cFullInfo, int nOpenMode)
{
	local array<byte> stream;
	local UIPacket._C_EX_UNIQUE_GACHA_OPEN packet;

	packet.cFullInfo = cFullInfo;
	packet.cOpenMode = nOpenMode;

	if(! class'UIPacket'.static.Encode_C_EX_UNIQUE_GACHA_OPEN(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_UNIQUE_GACHA_OPEN, stream);
	Debug("API C_EX_UNIQUE_GACHA_OPEN :" @ string(cFullInfo) @ string(packet.cOpenMode));
}

function API_C_EX_UNIQUE_GACHA_GAME(int nGameCount)
{
	local array<byte> stream;
	local UIPacket._C_EX_UNIQUE_GACHA_GAME packet;

	packet.nGameCount = nGameCount;

	if(! class'UIPacket'.static.Encode_C_EX_UNIQUE_GACHA_GAME(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_UNIQUE_GACHA_GAME, stream);
	Debug("API C_EX_UNIQUE_GACHA_GAME :" @ string(nGameCount));
}

function API_C_EX_UNIQUE_GACHA_HISTORY()
{
	local array<byte> stream;
	local UIPacket._C_EX_UNIQUE_GACHA_HISTORY packet;

	Debug("API C_EX_UNIQUE_GACHA_HISTORY ");

	if(! class'UIPacket'.static.Encode_C_EX_UNIQUE_GACHA_HISTORY(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_UNIQUE_GACHA_HISTORY, stream);
}

event OnJapanBtnClicked()
{
	local string strParam;

	ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "g_uniquegacha_japan001.htm");
	Debug("EV_ShowHelp : " @ strParam);
	ExecuteEvent(EV_ShowHelp, strParam);
}

function setDefaultShowItemInfo(int nCardNum, int RankType, int nItemClassID, INT64 nAmount)
{
	GetMeTextBox("Item0" $ string(nCardNum) $ ".ItemNum_txt").SetText("x" $ string(nAmount));
	GetMeItemWindow("Item0" $ string(nCardNum) $ ".Item_Itemwindow").Clear();
	GetMeItemWindow("Item0" $ string(nCardNum) $ ".Item_Itemwindow").AddItem(GetItemInfoByClassID(nItemClassID));
}

function SetPopupScript()
{
	local WindowHandle popExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle disableWnd;

	popExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	popupExpandScript = class'UIControlDialogAssets'.static.InitScript(popExpandWnd);
	disableWnd = GetWindowHandle(m_WindowName $ ".disable_tex");
	popupExpandScript.SetDisableWindow(disableWnd);
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop(m_WindowName $ ".disable_tex", false);
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function ShowPopup(int currentGameNum)
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = GetPopupExpandScript();
	popupExpandScript.SetDialogDesc(GetSystemMessage(6231));
	popupExpandScript.Show();
	popupExpandScript.OKButton.EnableWindow();
	popupExpandScript.DelegateOnClickBuy = OnDialogOK;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	showDisable(true);
}

function OnDialogOK()
{
	if(currentGachaGameNum == 1)
	{
		if(nMyCostItemAmount >= gamePrice1)
		{
			API_C_EX_UNIQUE_GACHA_GAME(currentGachaGameNum);
		}		
	}
	else if(currentGachaGameNum == 11)
	{
		if(nMyCostItemAmount >= gamePrice11)
		{
			API_C_EX_UNIQUE_GACHA_GAME(currentGachaGameNum);
		}
	}
	GetPopupExpandScript().Hide();
	showDisable(false);
}

function OnClickCancelDialog()
{
	GetPopupExpandScript().Hide();
	showDisable(false);
}

function showDisable(bool bShow)
{
	if(bShow)
	{
		GetWindowHandle(m_WindowName $ ".disable_tex").ShowWindow();
		GetWindowHandle(m_WindowName $ ".disable_tex").SetFocus();		
	}
	else
	{
		GetWindowHandle(m_WindowName $ ".disable_tex").HideWindow();
	}
}

function playNpcViewport(CharacterViewportWindowHandle ObjectViewport, int NpcID, int Distance, optional int Rotation, optional int nX, optional int nY, optional float Duration, optional string SpawnEffect, optional int nPlayAnim)
{
	ObjectViewport.SetCameraDistance(Distance);
	ObjectViewport.SetCharacterOffsetX(nX);
	ObjectViewport.SetCharacterOffsetY(nY);
	ObjectViewport.SetCurrentRotation(Rotation);
	ObjectViewport.ShowWindow();
	ObjectViewport.SetSpawnDuration(Duration);
	ObjectViewport.SetNPCInfo(NpcID);
	ObjectViewport.SetUISound(true);
	ObjectViewport.SetSpawnDuration(0.10f);
	ObjectViewport.SpawnNPC();
	ObjectViewport.PlayAnimation(nPlayAnim);
	ObjectViewport.SpawnEffect(SpawnEffect);
}

function string GetItemTextureNameByClassID(int ClassID)
{
	local ItemID cID;

	cID.ClassID = ClassID;
	return class'UIDATA_ITEM'.static.GetItemTextureName(cID);
}

function showRewardTotalList(array<UniqueGachaItemInfo> Items, bool bProb)
{
	local int i;

	if(bProb)
	{
		GetMeWindow("GachaRewardList01_wnd").HideWindow();
		GetMeWindow("GachaRewardList02_wnd").ShowWindow();
		GetMeRichListCtrl("GachaRewardList02_wnd.GachaRewardList02").DeleteAllItem();		
	}
	else
	{
		GetMeWindow("GachaRewardList02_wnd").HideWindow();
		GetMeWindow("GachaRewardList01_wnd").ShowWindow();
		GetMeRichListCtrl("GachaRewardList01_wnd.GachaRewardList01").DeleteAllItem();
	}
	addRichListRowDataRewardTotalTitle(1, bProb);

	for(i = 0; i < Items.Length; i++)
	{
		if(Items[i].RankType == RANK_UR)
		{
			addRichListRowDataRewardTotal(Items[i].RankType, Items[i].ItemType, Items[i].Amount, Items[i].fProb, bProb);
		}
	}
	addRichListRowDataRewardTotalTitle(2, bProb);

	for(i = 0; i < Items.Length; i++)
	{
		if(Items[i].RankType == RANK_SR)
		{
			addRichListRowDataRewardTotal(Items[i].RankType, Items[i].ItemType, Items[i].Amount, Items[i].fProb, bProb);
		}
	}
	addRichListRowDataRewardTotalTitle(3, bProb);

	for(i = 0; i < Items.Length; i++)
	{
		if(Items[i].RankType == RANK_R)
		{
			addRichListRowDataRewardTotal(Items[i].RankType, Items[i].ItemType, Items[i].Amount, Items[i].fProb, bProb);
		}
	}
}

function addRichListRowDataRewardTotalTitle(int cRankType, bool bProb)
{
	local RichListCtrlRowData RowData;
	local string Title;

	if(bProb)
	{
		RowData.cellDataList.Length = 3;		
	}
	else
	{
		RowData.cellDataList.Length = 2;
	}

	if(cRankType == RANK_UR)
	{
		RowData.sOverlayTex = "L2UI_NewTex.UniqueGacha.UniqueGachaListURBg";
		Title = GetSystemString(5225);		
	}
	else if(cRankType == RANK_SR)
	{
		RowData.sOverlayTex = "L2UI_NewTex.UniqueGacha.UniqueGachaListSRBg";
		Title = GetSystemString(5226);			
	}
	else
	{
		RowData.sOverlayTex = "L2UI_NewTex.UniqueGacha.UniqueGachaListRBg";
		Title = GetSystemString(5227);
	}
	addRichListCtrlString(RowData.cellDataList[0].drawitems, Title, GTColor().White, false, 24, 14, "hs10");
	RowData.OverlayTexU = 494;
	RowData.OverlayTexV = 45;

	if(bProb)
	{
		GetMeRichListCtrl("GachaRewardList02_wnd.GachaRewardList02").InsertRecord(RowData);		
	}
	else
	{
		GetMeRichListCtrl("GachaRewardList01_wnd.GachaRewardList01").InsertRecord(RowData);
	}
}

function addRichListRowDataRewardTotal(int cRankType, int ClassID, INT64 nAmount, float dProb, bool bProb)
{
	local RichListCtrlRowData RowData;
	local ItemInfo Info;

	if(bProb)
	{
		RowData.cellDataList.Length = 3;		
	}
	else
	{
		RowData.cellDataList.Length = 2;
	}
	Info = GetItemInfoByClassID(ClassID);
	Info.ItemNum = nAmount;
	ItemInfoToParam(Info, RowData.szReserved);

	if(Info.ItemNum > 1)
	{
		Info.bShowCount = true;
	}
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, Info, 32, 32, 6, 6);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetItemNameAllByClassID(ClassID), GTColor().White, false, 4, 8);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, MakeCostStringINT64(nAmount), GTColor().White, false, 0, 12);

	if(bProb)
	{
		addRichListCtrlString(RowData.cellDataList[2].drawitems, getInstanceL2Util().CutFloatIntByString(ConvertFloatToString(dProb, 6, false)), GTColor().White, false, 0, 12);
	}
	if(bProb)
	{
		GetMeRichListCtrl("GachaRewardList02_wnd.GachaRewardList02").InsertRecord(RowData);		
	}
	else
	{
		GetMeRichListCtrl("GachaRewardList01_wnd.GachaRewardList01").InsertRecord(RowData);
	}
}

function closeAltW()
{
	if(GetMeButton("Close_Btn").IsShowWindow())
	{
		closeUI();
	}
}

function OnReceivedCloseUI()
{
	if(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset").IsShowWindow())
	{
		GetPopupExpandScript().Hide();		
	}
	else if(GetMeWindow("GachaRewardList01_wnd").IsShowWindow())
	{
		showDisable(false);
		GetMeWindow("GachaRewardList01_wnd").HideWindow();			
	}
	else if(GetMeWindow("GachaRewardList02_wnd").IsShowWindow())
	{
		showDisable(false);
		GetMeWindow("GachaRewardList02_wnd").HideWindow();				
	}
	else if(GetMeWindow("UniqueGachaHistoryListWnd").IsShowWindow())
	{
		showDisable(false);
		GetMeWindow("UniqueGachaHistoryListWnd").HideWindow();					
	}
	else if(GetMeWindow("URReward_wnd").IsShowWindow())
	{
		OnClickButton("URRewardConfirm_btn");						
	}
	else if(GetMeButton("Close_Btn").IsShowWindow())
	{
		closeUI();
	}
}

defaultproperties
{
	m_WindowName="UniqueGacha"
}