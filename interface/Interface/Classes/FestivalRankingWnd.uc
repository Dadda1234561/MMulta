//================================================================================
// FestivalRankingWnd.
// emu-dev.ru
//================================================================================
class FestivalRankingWnd extends UICommonAPI
	dependson(FestivaRankingWindowTooltip)
	dependson(FestivaRankingWindowTooltip)
	dependson(FestivaRankingWindowTooltip)
	dependson(FestivaRankingWindowTooltip);

const buyIDTOP150 = 1;
const buyIDMyRank = 2;
const TIME_REMAINTIME = 60000;
const TIMERID_REMAINTIME = 88;
const TIME_REFRESHTIME = 3000;
const TIMERID_REFRESHTIME = 89;

struct festivalRankingMyDataStruct
{
	var int MyRanking;
	var int myRewardNum;
	var INT64 myBuyAmount;
};

struct festivalStateDataStruct
{
	var bool isOn;
	var INT64 remainTimeMin;
};

var WindowHandle Me;
var string m_WindowName;
var string m_WindowNameTimer;
var string m_WindowNameMyRanking;
var string m_WindowNameRankingReward;
var string m_WindowNameBM;
var string m_WindowNameList;
var WindowHandle FestivalRankingBuyWnd;
var string FestivalRankingBMBuyWnd;
var WindowHandle FestivalRankingBMConfirmWnd;
var string FestivalRankingBMConfirmWndName;
var FestivalRankingBonusWnd FestivalRankingBonusWndScript;
var FestivaRankingWindowTooltip FestivaRankingWindowTooltipScript;
var ItemWindowHandle MyPointItemWnd;
var TextBoxHandle MyPointTextBox;
var TextBoxHandle MyPointTitleTextBox;
var TextureHandle OnOff_Tex;
var TextBoxHandle Time_txt;
var ButtonHandle ReFresh_btn;
var festivalStateDataStruct festivalStateData;
var festivalRankingMyDataStruct festivalRankingMyData;
var UIPacket._RFBuyItemInfo festivalBuyItemData;
var UIPacket._RFBuyItemInfo festivalBuyItemDataBundle;
var array<UIPacket._RFRankingRewardInfo> rewardInfos;
var array<UIPacket._RFBonusInfo> bonusInfos;
var int buyID;
var int buyNum;
var UIControlNumberInput uiControlNumberInputScript;
var TextureHandle GiftBox_Tex;
var bool bReceiveReward;
var INT64 myGamePoint;
var int buyCostType;
var L2UIInventoryObjectSimple iObject;

function Initialize()
{
	local int i;
	local RichListCtrlHandle ListCtrl;

	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	iObject = AddItemListenerSimple(0);
	iObject.DelegateOnUpdateItem = HandleUpdateCostItem;
	m_WindowNameTimer = m_WindowName $ ".Time_Wnd";
	m_WindowNameRankingReward = m_WindowName $ ".RankingReward_Wnd";
	m_WindowNameMyRanking = m_WindowName $ ".MyRanking_Wnd";
	m_WindowNameBM = m_WindowName $ ".BMBuy_Wnd";
	m_WindowNameList = m_WindowName $ ".RankingList_Wnd";
	OnOff_Tex = GetTextureHandle(m_WindowNameTimer $ ".OnOff_Tex");
	Time_txt = GetTextBoxHandle(m_WindowNameTimer $ ".Time_Txt");
	GetButtonHandle(m_WindowName $ ".WindowHelp_BTN").SetTooltipCustomType(MakeTooltipSimpleText("툴팁00"));
	FestivalRankingBMBuyWnd = m_WindowName $ ".FestivalRankingBMBuyWnd";
	FestivalRankingBuyWnd = GetWindowHandle(FestivalRankingBMBuyWnd);
	InitUIControlNumberInput();
	FestivalRankingBMConfirmWndName = m_WindowName $ ".FestivalRankingBMConfirmWnd";
	FestivalRankingBMConfirmWnd = GetWindowHandle(FestivalRankingBMConfirmWndName);
	FestivalRankingBonusWndScript = FestivalRankingBonusWnd(GetScript("FestivalRankingBonusWnd"));
	FestivaRankingWindowTooltipScript = FestivaRankingWindowTooltip(GetScript("FestivaRankingWindowTooltip"));
	GiftBox_Tex = GetTextureHandle(m_WindowNameMyRanking $ ".GiftBox_Tex");
	GiftBox_Tex.HideWindow();
	ListCtrl = GetRichListCtrlHandle(m_WindowNameList $ ".RankingList_ListCtrl00");
	ListCtrl.SetSelectable(false);
	ListCtrl.SetAppearTooltipAtMouseX(true);
	ListCtrl.SetSelectedSelTooltip(false);
	ListCtrl.SetColumnWidth(0, 60);
	ListCtrl = GetRichListCtrlHandle(m_WindowNameList $ ".RankingList_ListCtrl01");
	ListCtrl.SetSelectable(false);
	ListCtrl.SetAppearTooltipAtMouseX(true);
	ListCtrl.SetSelectedSelTooltip(false);
	ListCtrl.SetColumnWidth(0, 60);
	ReFresh_btn = GetButtonHandle(m_WindowName $ ".RankingList_Wnd.Refresh_Btn");
	MyPointItemWnd = GetItemWindowHandle(m_WindowNameBM $ ".MyPointItemWnd");
	MyPointTextBox = GetTextBoxHandle(m_WindowNameBM $ ".MyPointTextBox");
	MyPointTitleTextBox = GetTextBoxHandle(m_WindowNameBM $ ".MyPointTitleTextBox");

	for(i = 1; i <= 7; i++)
	{
		GetItemWindowHandle(GetRankingRewardBoxPathByRankingGroup(i) $ ".SlotItem_ItemWnd").SetDisableTex("L2UI_ct1.ItemWindow.ItemWindow_IconDisable");
	}
	SetTooltip();
}

function SetTooltip()
{
	local array<DrawItemInfo> drawListArr;

	drawListArr[0] = addDrawItemText(" - " $ GetSystemString(5931), getInstanceL2Util().White, "", true, true);
	drawListArr[1] = addDrawItemText(" - " $ GetSystemString(5932), getInstanceL2Util().White, "", true, true);
	drawListArr[2] = addDrawItemText(" - " $ GetSystemString(5933), getInstanceL2Util().White, "", true, true);
	GetButtonHandle(m_WindowNameList $ ".TimeHelp_BTN").SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	drawListArr[0] = addDrawItemText(" - " $ GetSystemString(5934), getInstanceL2Util().White, "", true, true);
	drawListArr[1] = addDrawItemText(" - " $ GetSystemString(5935), getInstanceL2Util().White, "", true, true);
	drawListArr[2] = addDrawItemText(" - " $ GetSystemString(5936), getInstanceL2Util().White, "", true, true);
	GetButtonHandle(m_WindowNameList $ ".RankHelp_BTN").SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function InitUIControlNumberInput()
{
	local WindowHandle uicontrolNumber;

	uicontrolNumber = GetWindowHandle(FestivalRankingBMBuyWnd);
	uicontrolNumber.SetScript("UIControlNumberInput");
	uiControlNumberInputScript = UIControlNumberInput(uicontrolNumber.GetScript());
	uiControlNumberInputScript.Init(FestivalRankingBMBuyWnd);
	uiControlNumberInputScript.DelegateGetCountCanBuy = GetCountCanBuy;
	uiControlNumberInputScript.DelegateOnItemCountEdited = OnItemCountEdited;
	uiControlNumberInputScript.DelegateOnCancel = OnClickCancel;
	uiControlNumberInputScript.DelegateOnClickBuy = OnClickBuy;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_MYINFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_SIDEBAR_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_BUY);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_BONUS);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_RANKING);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_REWARD);
	RegisterEvent(EV_BR_SETGAMEPOINT);
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

event OnShow()
{
	SetGiftBox(false);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	RequestBR_GamePoint();
	C_EX_RANKING_FESTIVAL_OPEN();
	C_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS();
	UpdateMyPointControls();
}

event OnHide()
{
	if(FestivalRankingBonusWndScript.Me.IsShowWindow())
	{
		FestivalRankingBonusWndScript.Me.HideWindow();
	}
	iObject.setId();
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_MYINFO:
			S_EX_RANKING_FESTIVAL_MYINFO();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_SIDEBAR_INFO:
			S_EX_RANKING_FESTIVAL_SIDEBAR_INFO();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_BUY:
			S_EX_RANKING_FESTIVAL_BUY();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_BONUS:
			S_EX_RANKING_FESTIVAL_BONUS();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_RANKING:
			S_EX_RANKING_FESTIVAL_RANKING();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS:
			S_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_FESTIVAL_REWARD:
			S_EX_RANKING_FESTIVAL_REWARD();
			break;
		case EV_BR_SETGAMEPOINT:
			Nt_EV_BR_SETGAMEPOINT(param);
			break;
	}
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "PopUpOkBtn":
			break;
		case "Refresh_Btn":
			Me.SetTimer(TIMERID_REFRESHTIME, TIME_REFRESHTIME);
			ReFresh_btn.DisableWindow();
			C_EX_RANKING_FESTIVAL_RANKING(GetTopIndex());
			break;
		case "BtnBuyLast":
			HandleClickBtnBuy();
			break;
		case "BtnCancelBtn":
			FestivalRankingBuyWnd.HideWindow();
			break;
		case "Reward_Btn":
			if(FestivalRankingBonusWndScript.Me.IsShowWindow())
			{
				FestivalRankingBonusWndScript.Me.HideWindow();				
			}
			else
			{
				C_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS();
				FestivalRankingBonusWndScript.Show();
			}
			break;
		case "OK_Button":
			HandleClickBtnBuy();
			break;
		case "Cancel_Button":
			FestivalRankingBMConfirmWnd.HideWindow();
			break;
	}
}

event OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	local ItemInfo iInfo;

	a_hItemWindow.GetItem(a_Index, iInfo);

	if(iInfo.bDisabled == 1)
	{
		return;
	}
	C_EX_RANKING_FESTIVAL_REWARD();
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	if(a_ButtonHandle.GetWindowName() == "BuyBM_Btn")
	{
		switch(a_ButtonHandle.GetParentWindowName())
		{
			case "BMItem_Wnd00":
				ShowFestivalRankingBuyWnd(festivalBuyItemData.nBuyId);
				break;
			case "BMItem_Wnd01":
				ShowFestivalRankingBuyWnd(festivalBuyItemDataBundle.nBuyId);
				break;
		}
	}
}

event OnTimer(int tID)
{
	switch(tID)
	{
		case TIMERID_REFRESHTIME:
			Me.KillTimer(tID);
			ReFresh_btn.EnableWindow();
			break;
		default:
			festivalStateData.remainTimeMin = festivalStateData.remainTimeMin - 1;
			festivalStateData.isOn = festivalStateData.remainTimeMin > 0;
			SetTimeText();
			SetTimerState(festivalStateData.isOn);

			if(Me.IsShowWindow())
			{
				C_EX_RANKING_FESTIVAL_RANKING(0);

				if(festivalRankingMyData.MyRanking < 151)
				{
					C_EX_RANKING_FESTIVAL_RANKING(1);
				}
			}
			if(!festivalStateData.isOn)
			{
				Me.KillTimer(TIMERID_REMAINTIME);
			}
			break;
	}
}

function ClearAllRankingBox()
{
	local int i;
	local string rankingBoxPath;
	local ItemInfo iInfo;

	for(i = 1; i <= 7; i++)
	{
		rankingBoxPath = GetRankingRewardBoxPathByRankingGroup(i);
		GetAnimTextureHandle(rankingBoxPath $ ".SlotRewardAni").HideWindow();
		GetTextureHandle(rankingBoxPath $ ".MyRankWndBg_Tex").HideWindow();
		GetItemWindowHandle(rankingBoxPath $ ".SlotItem_ItemWnd").GetItem(0, iInfo);
		iInfo.bDisabled = 1;
		GetItemWindowHandle(rankingBoxPath $ ".SlotItem_ItemWnd").SetItem(0, iInfo);
	}
}

function SetMyRanking(int Ranking, int Amount)
{
	local string rankingBoxPath;
	local AnimTextureHandle slotRewardAni;
	local ItemInfo iInfo;

	festivalRankingMyData.MyRanking = Ranking;
	festivalRankingMyData.myBuyAmount = Amount;
	SetMyRankingInfo(Ranking, Amount);
	FestivalRankingBonusWndScript.SetMyAmount(Amount);
	ClearAllRankingBox();
	rankingBoxPath = GetRankingRewardBoxPathByRanking(Ranking);

	if(rankingBoxPath == "")
	{
		return;
	}

	if(!bReceiveReward)
	{
		GetItemWindowHandle(rankingBoxPath $ ".SlotItem_ItemWnd").GetItem(0, iInfo);
		iInfo.bDisabled = 0;
		GetItemWindowHandle(rankingBoxPath $ ".SlotItem_ItemWnd").SetItem(0, iInfo);
	}
	GetTextureHandle(rankingBoxPath $ ".MyRankWndBg_Tex").ShowWindow();
	slotRewardAni = GetAnimTextureHandle(rankingBoxPath $ ".SlotRewardAni");
	slotRewardAni.SetFocus();

	if(!festivalStateData.isOn)
	{
		slotRewardAni.ShowWindow();
		slotRewardAni.Stop();
		slotRewardAni.SetLoopCount(9999);
		slotRewardAni.Play();		
	}
	else
	{
		slotRewardAni.HideWindow();
	}
}

function SetMyRankingInfo(int Ranking, int Amount)
{
	local int Min, Max, currentAmount;

	GetMyRankingMinMax(Amount, Min, Max, currentAmount);

	if(Ranking == 0)
	{
		GetTextBoxHandle(m_WindowNameMyRanking $ ".MyRankNum_Txt").SetText(GetSystemString(1374));		
	}
	else
	{
		GetTextBoxHandle(m_WindowNameMyRanking $ ".MyRankNum_Txt").SetText(string(Ranking) @ GetSystemString(1375));
	}
	GetTextBoxHandle(m_WindowNameMyRanking $ ".ItemNumBuyMine_txt").SetText(MakeCostString(string(Amount)) $ GetSystemString(932));
	GetTextBoxHandle(m_WindowNameMyRanking $ ".ItemNumRhombus_Txt").SetText(string(Max));
	GetProgressCtrlHandle(m_WindowNameMyRanking $ ".ItemNum_Progress").SetProgressTime(Max - Min);
	GetProgressCtrlHandle(m_WindowNameMyRanking $ ".ItemNum_Progress").SetPos(currentAmount);
}

function InitTimer()
{
	Me.KillTimer(TIMERID_REMAINTIME);
}

function ResetTimer()
{
	InitTimer();
}

function SetTimeText()
{
	local string timeString;

	if(festivalStateData.isOn)
	{
		if(GetLanguage() == LANG_English)
		{
			timeString = GetSystemString(6001) @ ":" $ GetTimeStringByMin(int(festivalStateData.remainTimeMin), false);
		}
		else
		{
			timeString = GetSystemString(1108) @ ":" $ GetTimeStringByMin(int(festivalStateData.remainTimeMin), false);
		}
	}
	else
	{
		timeString = GetSystemString(7036);
	}
	Time_txt.SetText(timeString);
	FestivaRankingWindowTooltipScript.SetTimeText(timeString);
}

function SetTimer(INT64 maxTIme)
{
	festivalStateData.remainTimeMin = maxTIme;
	SetTimeText();
	Me.SetTimer(TIMERID_REMAINTIME, TIME_REMAINTIME);
}

function SetTimerState(bool isOn)
{
	local string timerTextureName;

	festivalStateData.isOn = isOn;

	if(festivalStateData.isOn)
	{
		timerTextureName = "L2UI_ct1.OlympiadWnd.ONICON";
		GetBuyBMBtn(0).EnableWindow();
		GetBuyBMBtn(1).EnableWindow();		
	}
	else
	{
		timerTextureName = "L2UI_ct1.OlympiadWnd.OFFICON";
		GetBuyBMBtn(0).DisableWindow();
		GetBuyBMBtn(1).DisableWindow();
	}
	OnOff_Tex.SetTexture(timerTextureName);
	FestivaRankingWindowTooltipScript.SetTimerState(timerTextureName);
}

function SetRankingRewardInfoBig(int RankingGroup, string UserName, INT64 Amount)
{
	local ItemWindowHandle rewardItemWindow;
	local string rankingBoxPath;
	local ItemInfo iInfo;
	local UserInfo uInfo;

	GetPlayerInfo(uInfo);

	if(UserName == "")
	{
		UserName = "-";
	}
	rankingBoxPath = GetRankingRewardBoxPathByRankingGroup(RankingGroup);
	iInfo = GetrewardItemInfoByRankingGroup(RankingGroup);
	rewardItemWindow = GetItemWindowHandle(rankingBoxPath $ ".SlotItem_ItemWnd");
	rewardItemWindow.Clear();

	if(uInfo.Name != UserName)
	{
		iInfo.bDisabled = 1;
	}
	rewardItemWindow.AddItem(iInfo);
	GetTextBoxHandle(rankingBoxPath $ ".Name_Txt00").SetText(UserName);
	GetTextBoxHandle(rankingBoxPath $ ".Number_Txt01").SetText(MakeCostString(string(Amount)));
	GetTextureHandle(rankingBoxPath $ ".MyRankWndBg_Tex").HideWindow();
	GetAnimTextureHandle(rankingBoxPath $ ".SlotRewardAni").HideWindow();
	iInfo.bDisabled = 0;
	FestivaRankingWindowTooltipScript.SetRankingRewardInfoBig(RankingGroup, UserName, Amount, iInfo);
}

function SetRankingRewardInfoSmall(int RankingGroup)
{
	local ItemWindowHandle rewardItemWindow;
	local string rankingBoxPath;
	local ItemInfo iInfo;

	rankingBoxPath = GetRankingRewardBoxPathByRankingGroup(RankingGroup);
	iInfo = GetrewardItemInfoByRankingGroup(RankingGroup);
	rewardItemWindow = GetItemWindowHandle(rankingBoxPath $ ".SlotItem_ItemWnd");
	rewardItemWindow.Clear();
	rewardItemWindow.AddItem(iInfo);
	GetTextBoxHandle(rankingBoxPath $ ".RankNum_Txt").SetText(GetRankingText(RankingGroup));
	GetTextureHandle(rankingBoxPath $ ".MyRankWndBg_Tex").HideWindow();
	GetAnimTextureHandle(rankingBoxPath $ ".SlotRewardAni").HideWindow();
}

function SetBMInfo(array<UIPacket._RFBuyItemInfo> buyItemInfos)
{
	local ItemInfo iInfo;

	if(buyItemInfos.Length == 0)
	{
		return;
	}
	festivalBuyItemData = buyItemInfos[0];
	festivalBuyItemDataBundle = buyItemInfos[1];
	iInfo = GetItemInfoByClassID(festivalBuyItemData.nBuyItemClassId);
	GetBMItemWindow(0).Clear();
	GetBMItemWindow(0).AddItem(iInfo);
	GetBMItemNameTxt(0).SetText(iInfo.Name);
	GetBMItemNumberTxt(0).SetText("x" $ string(festivalBuyItemData.nBuyItemAmount));
	iInfo = GetItemInfoByClassID(festivalBuyItemData.nCostItemClassID);
	GetBMItemWindowCost(0).Clear();
	GetBMItemWindowCost(0).AddItem(iInfo);
	GetBMItemCostTxt(0).SetText(MakeCostString(string(festivalBuyItemData.nCostItemAmount)));

	if(festivalBuyItemData.bSale == 1)
	{
		GetBMRibbon(0).ShowWindow();		
	}
	else
	{
		GetBMRibbon(0).HideWindow();
	}

	if(buyCostType == 1)
	{
		iObject.setId(iInfo.Id);
	}
	iInfo = GetItemInfoByClassID(festivalBuyItemDataBundle.nBuyItemClassId);
	GetBMItemWindow(1).Clear();
	GetBMItemWindow(1).AddItem(iInfo);
	GetBMItemNameTxt(1).SetText(iInfo.Name);
	GetBMItemNumberTxt(1).SetText("x" $ string(festivalBuyItemDataBundle.nBuyItemAmount));
	iInfo = GetItemInfoByClassID(festivalBuyItemDataBundle.nCostItemClassID);
	GetBMItemWindowCost(1).Clear();
	GetBMItemWindowCost(1).AddItem(iInfo);
	GetBMItemCostTxt(1).SetText(MakeCostString(string(festivalBuyItemDataBundle.nCostItemAmount)));

	if(festivalBuyItemDataBundle.bSale == 1)
	{
		GetBMRibbon(1).ShowWindow();		
	}
	else
	{
		GetBMRibbon(1).HideWindow();
	}

	if(buyCostType == 2)
	{
		GetBMItemWindowCost(0).SetTooltipType("");
		GetBMItemWindowCost(1).SetTooltipType("");		
	}
	else
	{
		GetBMItemWindowCost(0).SetTooltipType("Inventory");
		GetBMItemWindowCost(1).SetTooltipType("Inventory");
	}
}

function TextBoxHandle GetBMItemNameTxt(int Num)
{
	return GetTextBoxHandle(m_WindowNameBM $ "." $ "BMItem_Wnd0" $ string(Num) $ ".BMItemName_Txt00");
}

function TextBoxHandle GetBMItemNumberTxt(int Num)
{
	return GetTextBoxHandle(m_WindowNameBM $ "." $ "BMItem_Wnd0" $ string(Num) $ ".BMItemNumber_Txt01");
}

function TextBoxHandle GetBMItemCostTxt(int Num)
{
	return GetTextBoxHandle(m_WindowNameBM $ "." $ "BMItem_Wnd0" $ string(Num) $ ".Cost_Txt");
}

function ItemWindowHandle GetBMItemWindow(int Num)
{
	return GetItemWindowHandle(m_WindowNameBM $ "." $ "BMItem_Wnd0" $ string(Num) $ ".BMItem_ItemWnd");
}

function ItemWindowHandle GetBMItemWindowCost(int Num)
{
	return GetItemWindowHandle(m_WindowNameBM $ "." $ "BMItem_Wnd0" $ string(Num) $ ".CostIcon_ItemWnd");
}

function TextureHandle GetBMRibbon(int Num)
{
	return GetTextureHandle(m_WindowNameBM $ "." $ "BMItem_Wnd0" $ string(Num) $ ".Ribbon_Tex");
}

function ButtonHandle GetBuyBMBtn(int Num)
{
	return GetButtonHandle(m_WindowNameBM $ "." $ "BMItem_Wnd0" $ string(Num) $ ".BuyBM_Btn");
}

function SetRankingList(array<UIPacket._RFRankingInfo> rankingInfos)
{
	local int i;
	local RichListCtrlHandle ListCtrl;

	ListCtrl = GetRichListCtrlHandle(m_WindowNameList $ ".RankingList_ListCtrl00");
	ListCtrl.DeleteAllItem();

	for(i = 0; i < rankingInfos.Length; i++)
	{
		ListCtrl.InsertRecord(MakeRecordRanking(rankingInfos[i].nRank, rankingInfos[i].charName, rankingInfos[i].nBuyCount));
	}
}

function SetRankingListMine(array<UIPacket._RFRankingInfo> rankingInfos)
{
	local int i, MyIndex;
	local RichListCtrlHandle ListCtrl;
	local UserInfo uInfo;

	ListCtrl = GetRichListCtrlHandle(m_WindowNameList $ ".RankingList_ListCtrl01");
	ListCtrl.DeleteAllItem();
	GetPlayerInfo(uInfo);
	rankingInfos.Sort(OnSortCompare);

	for(i = 0; i < rankingInfos.Length; i++)
	{
		if(rankingInfos[i].charName == uInfo.Name)
		{
			MyIndex = i;
		}
		ListCtrl.InsertRecord(MakeRecordRanking(rankingInfos[i].nRank, rankingInfos[i].charName, rankingInfos[i].nBuyCount));
	}
	ListCtrl.SetStartRow(MyIndex);
}

function GetMyRankingMinMax(int Amount, out int Min, out int Max, out int currentAmount)
{
	local int i;

	if(Amount < bonusInfos[0].nPoint)
	{
		Min = 0;
		Max = bonusInfos[0].nPoint;
		currentAmount = Amount;
		return;
	}

	for(i = 0; i < (bonusInfos.Length - 1); i++)
	{
		if(bonusInfos[i].nPoint <= Amount && bonusInfos[i + 1].nPoint > Amount)
		{
			Min = bonusInfos[i].nPoint;
			Max = bonusInfos[i + 1].nPoint;
			currentAmount = Amount - Min;
			return;
		}
	}
	Min = bonusInfos[bonusInfos.Length - 2].nPoint;
	Max = bonusInfos[bonusInfos.Length - 1].nPoint;
	currentAmount = Amount - Min;
}

function int GetTopIndex()
{
	return GetTabHandle(m_WindowNameList $ ".RankingList_Tab").GetTopIndex();
}

function ItemInfo GetrewardItemInfoByRankingGroup(int RankingGroup)
{
	local ItemInfo iInfo;
	local UIPacket._RFRankingRewardInfo rankingRewardInfo;

	rankingRewardInfo = rewardInfos[RankingGroup - 1];
	iInfo = GetItemInfoByClassID(rankingRewardInfo.nRewardItemClassId);
	setShowItemCount(iInfo);
	iInfo.ItemNum = rankingRewardInfo.nRewardItemAmount;
	return iInfo;
}

function RichListCtrlRowData MakeRecordRanking(int Ranking, string Name, int buyNum)
{
	local RichListCtrlRowData Record;
	local Color tmpTextColor;
	local UserInfo uInfo;

	Record.cellDataList.Length = 3;
	Record.szReserved = "툴팁 정보들";
	GetPlayerInfo(uInfo);

	if(Ranking < 4)
	{
		tmpTextColor = GetColor(170, 153, 119, 255);		
	}
	else
	{
		tmpTextColor = getInstanceL2Util().BrightWhite;
	}

	if(Ranking == 0)
	{
		addRichListCtrlString(Record.cellDataList[0].drawitems, "-");
		Name = uInfo.Name;		
	}
	else
	{
		addRichListCtrlString(Record.cellDataList[0].drawitems, string(Ranking) @ GetSystemString(1375));
	}

	if(Name == "")
	{
		Name = GetSystemString(13198);
	}
	addRichListCtrlString(Record.cellDataList[1].drawitems, Name, tmpTextColor);
	addRichListCtrlString(Record.cellDataList[2].drawitems, MakeCostString(string(buyNum)));

	if(Name == uInfo.Name)
	{
		Record.sOverlayTex = "L2UI_EPIC.RankingFestivalWnd.MyRankListBg";
		Record.OverlayTexU = 306;
		Record.OverlayTexV = 35;
	}
	return Record;
}

function RichListCtrlRowData MakeRecordMyRanking(int Ranking, string Name, int buyNum)
{
	local RichListCtrlRowData Record;
	local Color tmpTextColor;

	Record.cellDataList.Length = 2;
	Record.szReserved = "툴팁 정보들";

	if(Ranking < 3)
	{
		tmpTextColor = GetColor(170, 153, 119, 255);		
	}
	else
	{
		tmpTextColor = getInstanceL2Util().BrightWhite;
	}
	addRichListCtrlString(Record.cellDataList[0].drawitems, string(Ranking + 1));
	addRichListCtrlString(Record.cellDataList[0].drawitems, "999", tmpTextColor, false, 20);
	addRichListCtrlString(Record.cellDataList[1].drawitems, MakeCostString(string(buyNum)));
	return Record;
}

function string GetTimeStringByMin(int Min, bool bRemainStr)
{
	local int timeDay, timeHour, timeMin;
	local string returnStr;

	if(Min < 0)
	{
		Min = 0;
	}
	returnStr = "";
	timeMin = int(float(Min) % float(60));
	timeHour = int(float(Min / 60) % float(24));
	timeDay = (Min / 60) / 24;
	returnStr = "";

	if(Min < 1)
	{
		return " " $ MakeFullSystemMsg(GetSystemMessage(4360), "1");
	}

	if(timeDay > 0)
	{
		if(GetLanguage() == LANG_English)
		{
			returnStr = returnStr @ MakeFullSystemMsg(GetSystemMessage(6899), string(timeDay));			
		}
		else
		{
			returnStr = returnStr @ MakeFullSystemMsg(GetSystemMessage(3418), string(timeDay));
		}
	}

	if(timeHour > 0)
	{
		if(GetLanguage() == LANG_English)
		{
			returnStr = returnStr @ MakeFullSystemMsg(GetSystemMessage(6900), string(timeHour));			
		}
		else
		{
			returnStr = returnStr @ MakeFullSystemMsg(GetSystemMessage(3406), string(timeHour));
		}
	}

	if(timeMin > 0)
	{
		if(GetLanguage() == LANG_English)
		{
			returnStr = returnStr @ MakeFullSystemMsg(GetSystemMessage(6901), string(timeMin));			
		}
		else
		{
			returnStr = returnStr @ MakeFullSystemMsg(GetSystemMessage(3390), string(timeMin));
		}
	}
	return returnStr;
}

function string GetRankingText(int RankingGroup)
{
	local UIPacket._RFRankingRewardInfo rankingRewardInfo;

	rankingRewardInfo = rewardInfos[RankingGroup - 1];
	return string(rankingRewardInfo.nStartRank) $ " ~ " $ string(rankingRewardInfo.nEndRank) @ GetSystemString(1375);
}

function int GetRankingGroupByRanking(int Ranking)
{
	local int i;

	for(i = 0; i < rewardInfos.Length; i++)
	{
		if(rewardInfos[i].nStartRank <= Ranking && Ranking <= rewardInfos[i].nEndRank)
		{
			return i + 1;
		}
	}
	return -1;
}

function string GetRankingRewardBoxPathByRanking(int Ranking)
{
	local int RankingGroup;

	RankingGroup = GetRankingGroupByRanking(Ranking);

	if(RankingGroup == -1)
	{
		return "";
	}
	return GetRankingRewardBoxPathByRankingGroup(RankingGroup);
}

function string GetRankingRewardBoxPathByRankingGroup(int RankingGroup)
{
	if(RankingGroup == -1)
	{
		return "";
	}
	return m_WindowNameRankingReward $ ".Reward_Wnd0" $ string(RankingGroup - 1);
}

delegate int OnSortCompare(UIPacket._RFRankingInfo A, UIPacket._RFRankingInfo B)
{
	if(A.nRank <= B.nRank)
	{
		return 0;		
	}
	else
	{
		return -1;
	}
}

function S_EX_RANKING_FESTIVAL_SIDEBAR_INFO()
{
	local SideBar SideBarScript;
	local UIPacket._S_EX_RANKING_FESTIVAL_SIDEBAR_INFO packet;

	if(!class'UIPacket'.static.Decode_S_EX_RANKING_FESTIVAL_SIDEBAR_INFO(packet))
	{
		return;
	}
	SideBarScript = SideBar(GetScript("SideBar"));
	SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVALRANKING, packet.bShowEvent == 1);
	ResetTimer();
	SetTimerState(packet.bOnEvent == 1);
	SetTimer(packet.nEndTime / 60);

	if(packet.rankingRewardInfos.Length > 0)
	{
		rewardInfos = packet.rankingRewardInfos;
	}
	SetRankingRewardInfoBig(1, packet.rankingInfos[0].charName, packet.rankingInfos[0].nBuyCount);
	SetRankingRewardInfoBig(2, packet.rankingInfos[1].charName, packet.rankingInfos[1].nBuyCount);
	SetRankingRewardInfoBig(3, packet.rankingInfos[2].charName, packet.rankingInfos[2].nBuyCount);
	SetRankingRewardInfoSmall(4);
	SetRankingRewardInfoSmall(5);
	SetRankingRewardInfoSmall(6);
	SetRankingRewardInfoSmall(7);
	buyCostType = packet.nCostType;
	SetBMInfo(packet.buyItemInfos);
	UpdateMyPointControls();

	if(packet.bonusInfos.Length > 0)
	{
		bonusInfos = packet.bonusInfos;
		FestivalRankingBonusWndScript.SetBonusList(bonusInfos);
	}
	if(Me.IsShowWindow())
	{
		C_EX_RANKING_FESTIVAL_RANKING(0);

		if(festivalRankingMyData.MyRanking < 151)
		{
			C_EX_RANKING_FESTIVAL_RANKING(1);
		}
	}
}

function S_EX_RANKING_FESTIVAL_MYINFO()
{
	local UIPacket._S_EX_RANKING_FESTIVAL_MYINFO packet;

	if(!class'UIPacket'.static.Decode_S_EX_RANKING_FESTIVAL_MYINFO(packet))
	{
		return;
	}
	HandleReceivedReward(packet.bReceiveReward == 1);
	SetMyRanking(packet.nMyRanking, packet.nTotalBuyCount);
}

function HandleReceivedReward(bool bReceived)
{
	bReceiveReward = bReceived;
	SetMyRanking(festivalRankingMyData.MyRanking, int(festivalRankingMyData.myBuyAmount));
}

function C_EX_RANKING_FESTIVAL_OPEN()
{
	local array<byte> stream;
	local UIPacket._C_EX_RANKING_FESTIVAL_OPEN packet;

	if(!class'UIPacket'.static.Encode_C_EX_RANKING_FESTIVAL_OPEN(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_RANKING_FESTIVAL_OPEN, stream);
}

function C_EX_RANKING_FESTIVAL_BUY(int buyID, int ItemNum)
{
	local array<byte> stream;
	local UIPacket._C_EX_RANKING_FESTIVAL_BUY packet;

	packet.nBuyId = buyID;
	packet.nBuyCount = ItemNum;
	Debug("C_EX_RANKING_FESTIVAL_BUY" @ string(buyID) @ string(ItemNum));

	if(!class'UIPacket'.static.Encode_C_EX_RANKING_FESTIVAL_BUY(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_RANKING_FESTIVAL_BUY, stream);
}

function S_EX_RANKING_FESTIVAL_BUY()
{
	local UIPacket._S_EX_RANKING_FESTIVAL_BUY packet;

	if(!class'UIPacket'.static.Decode_S_EX_RANKING_FESTIVAL_BUY(packet))
	{
		return;
	}
	C_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS();

	if(buyCostType == 2)
	{
		RequestBR_GamePoint();
	}
}

function C_EX_RANKING_FESTIVAL_BONUS(array<int> nPoints)
{
	local array<byte> stream;
	local UIPacket._C_EX_RANKING_FESTIVAL_BONUS packet;

	packet.nPoints = nPoints;

	if(!class'UIPacket'.static.Encode_C_EX_RANKING_FESTIVAL_BONUS(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_RANKING_FESTIVAL_BONUS, stream);
}

function S_EX_RANKING_FESTIVAL_BONUS()
{
	local UIPacket._S_EX_RANKING_FESTIVAL_BONUS packet;

	if(!class'UIPacket'.static.Decode_S_EX_RANKING_FESTIVAL_BONUS(packet))
	{
		return;
	}
	if(packet.bSuccess == 1)
	{
		FestivalRankingBonusWndScript.AddBonusReceived(packet.nPoints);
	}
}

function C_EX_RANKING_FESTIVAL_RANKING(int RankingType)
{
	local array<byte> stream;
	local UIPacket._C_EX_RANKING_FESTIVAL_RANKING packet;

	packet.nRankingType = RankingType;

	if(!class'UIPacket'.static.Encode_C_EX_RANKING_FESTIVAL_RANKING(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_RANKING_FESTIVAL_RANKING, stream);
}

function S_EX_RANKING_FESTIVAL_RANKING()
{
	local UIPacket._S_EX_RANKING_FESTIVAL_RANKING packet;

	if(!class'UIPacket'.static.Decode_S_EX_RANKING_FESTIVAL_RANKING(packet))
	{
		return;
	}
	if(packet.nRankingType == 0)
	{
		SetRankingList(packet.rankingInfos);		
	}
	else
	{
		SetRankingListMine(packet.rankingInfos);
	}
}

function C_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS()
{
	local array<byte> stream;
	local UIPacket._C_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS packet;

	if(!class'UIPacket'.static.Encode_C_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS, stream);
}

function S_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS()
{
	local UIPacket._S_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS packet;

	if(!class'UIPacket'.static.Decode_S_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS(packet))
	{
		return;
	}
	FestivalRankingBonusWndScript.SetBonusReceived(packet.receivedPoints);
}

function Nt_EV_BR_SETGAMEPOINT(string param)
{
	ParseINT64(param, "GamePoint", myGamePoint);
	UpdateMyPointControls();
}

function SetGiftBox(bool isShow)
{
	FestivaRankingWindowTooltipScript.SetGiftBox(isShow);

	if(isShow)
	{
		GiftBox_Tex.ShowWindow();		
	}
	else
	{
		GiftBox_Tex.HideWindow();
	}
}

function API_RequestRankingFestivalBonus(array<int> nPoints)
{
	RequestRankingFestivalBonus(nPoints);
}

function C_EX_RANKING_FESTIVAL_REWARD()
{
	local array<byte> stream;
	local UIPacket._C_EX_RANKING_FESTIVAL_REWARD packet;

	if(!class'UIPacket'.static.Encode_C_EX_RANKING_FESTIVAL_REWARD(stream, packet))
	{
		return;
	}
	packet.dummy = 1;
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_RANKING_FESTIVAL_REWARD, stream);
}

function S_EX_RANKING_FESTIVAL_REWARD()
{
	local UIPacket._S_EX_RANKING_FESTIVAL_REWARD packet;

	if(!class'UIPacket'.static.Decode_S_EX_RANKING_FESTIVAL_REWARD(packet))
	{
		return;
	}
	if(packet.bSuccess == 1)
	{
		HandleReceivedReward(true);
	}
}

function SetSubWndBuyItemInfo()
{
	local UIPacket._RFBuyItemInfo currentBMmInfo;
	local ItemInfo iInfo;
	local int buyIndex;

	currentBMmInfo = GetBuyItemInfoByBuyID(buyID);
	buyIndex = currentBMmInfo.nBuyId - 1;
	GetBMItemWindow(buyIndex).GetItem(0, iInfo);
	GetItemWindowHandle(FestivalRankingBMBuyWnd $ "." $ "Item01_ItemWindow").Clear();
	GetItemWindowHandle(FestivalRankingBMBuyWnd $ "." $ "Item01_ItemWindow").AddItem(iInfo);
	GetItemWindowHandle(FestivalRankingBMConfirmWndName $ "." $ "Result_ItemWnd").Clear();
	GetItemWindowHandle(FestivalRankingBMConfirmWndName $ "." $ "Result_ItemWnd").AddItem(iInfo);
	GetTextBoxHandle(FestivalRankingBMBuyWnd $ "." $ "Item01Title_TextBox").SetText(iInfo.Name);
	GetTextBoxHandle(FestivalRankingBMConfirmWndName $ "." $ "ItemName_TextBox").SetText(iInfo.Name);
	GetBMItemWindowCost(buyIndex).GetItem(0, iInfo);
	GetItemWindowHandle(FestivalRankingBMBuyWnd $ "." $ "CostItem01_ItemWindow").Clear();
	GetItemWindowHandle(FestivalRankingBMBuyWnd $ "." $ "CostItem01_ItemWindow").AddItem(iInfo);
	GetTextBoxHandle(FestivalRankingBMBuyWnd $ "." $ "CostItem01Title_TextBox").SetText(iInfo.Name);
	GetTextBoxHandle(FestivalRankingBMConfirmWndName $ "." $ "BCTitle_TextBox").SetText(iInfo.Name);

	if(buyCostType == 2)
	{
		GetItemWindowHandle(FestivalRankingBMBuyWnd $ "." $ "CostItem01_ItemWindow").SetTooltipType("");		
	}
	else
	{
		GetItemWindowHandle(FestivalRankingBMBuyWnd $ "." $ "CostItem01_ItemWindow").SetTooltipType("Inventory");
	}
}

function SetSubWndBuyItemCount(int ItemNum)
{
	local UIPacket._RFBuyItemInfo currentBMmInfo;
	local ItemInfo iInfo;
	local int buyIndex;
	local array<ItemInfo> iInfos;
	local INT64 myItemNum;

	currentBMmInfo = GetBuyItemInfoByBuyID(buyID);
	buyIndex = currentBMmInfo.nBuyId - 1;
	GetTextBoxHandle(FestivalRankingBMBuyWnd $ "." $ "Item01NumTitle_TextBox").SetText("x" $ string(currentBMmInfo.nBuyItemAmount * ItemNum));
	GetTextBoxHandle(FestivalRankingBMConfirmWndName $ "." $ "ItemNum_TextBox").SetText("x" $ string(currentBMmInfo.nBuyItemAmount * ItemNum));
	GetBMItemWindowCost(buyIndex).GetItem(0, iInfo);
	GetTextBoxHandle(FestivalRankingBMBuyWnd $ "." $ "CostItem01NumTitle_TextBox").SetText("x" $ MakeCostString(string(currentBMmInfo.nCostItemAmount * ItemNum)));
	GetTextBoxHandle(FestivalRankingBMConfirmWndName $ "." $ "BCTitle_TextBox").SetText(iInfo.Name);
	GetTextBoxHandle(FestivalRankingBMConfirmWndName $ "." $ "BCNum_TextBox").SetText(MakeCostString(string(currentBMmInfo.nCostItemAmount * ItemNum)));

	if(buyCostType == 2)
	{
		myItemNum = myGamePoint;		
	}
	else
	{
		class'UIDATA_INVENTORY'.static.FindItemByClassID(iInfo.Id.ClassID, iInfos);
		myItemNum = iInfos[0].ItemNum;
	}
	GetTextBoxHandle(FestivalRankingBMBuyWnd $ "." $ "CostItem01MyNumTitle_TextBox").SetText("(" $ MakeCostString(string(myItemNum)) $ ")");

	if(myItemNum >= (currentBMmInfo.nCostItemAmount * ItemNum))
	{
		GetTextBoxHandle(FestivalRankingBMBuyWnd $ "." $ "CostItem01MyNumTitle_TextBox").SetTextColor(getInstanceL2Util().BLUE01);		
	}
	else
	{
		GetTextBoxHandle(FestivalRankingBMBuyWnd $ "." $ "CostItem01MyNumTitle_TextBox").SetTextColor(getInstanceL2Util().DRed);
	}
}

function INT64 GetCountCanBuy()
{
	local UIPacket._RFBuyItemInfo currentBMmInfo;
	local array<ItemInfo> iInfos;
	local INT64 ItemNum;
	local int buyIndex;
	local ItemInfo iInfo;

	currentBMmInfo = GetBuyItemInfoByBuyID(buyID);
	buyIndex = currentBMmInfo.nBuyId - 1;
	GetBMItemWindowCost(buyIndex).GetItem(0, iInfo);

	if(buyCostType == 2)
	{
		ItemNum = myGamePoint;		
	}
	else
	{
		class'UIDATA_INVENTORY'.static.FindItemByClassID(iInfo.Id.ClassID, iInfos);
		ItemNum = iInfos[0].ItemNum;
	}
	return int(ItemNum / currentBMmInfo.nCostItemAmount);
}

function UIPacket._RFBuyItemInfo GetBuyItemInfoByBuyID(int buyID)
{
	switch(buyID)
	{
		case 1:
			return festivalBuyItemData;
			break;
		case 2:
			return festivalBuyItemDataBundle;
			break;
	}
	return festivalBuyItemData;
}

function OnClickBuy()
{
	FestivalRankingBMConfirmWnd.ShowWindow();
	FestivalRankingBMConfirmWnd.SetFocus();
}

function OnClickCancel()
{
	FestivalRankingBuyWnd.HideWindow();
}

function OnItemCountEdited(INT64 changedNum)
{
	buyNum = int(changedNum);
	SetSubWndBuyItemCount(int(changedNum));
}

function HandleClickBtnBuy()
{
	FestivalRankingBuyWnd.HideWindow();
	FestivalRankingBMConfirmWnd.HideWindow();
	switch(buyID)
	{
		case 1:
			C_EX_RANKING_FESTIVAL_BUY(buyID, buyNum);
			break;
		case 2:
			C_EX_RANKING_FESTIVAL_BUY(buyID, buyNum);
			break;
	}
}

function ShowFestivalRankingBuyWnd(int bmBuyID)
{
	buyID = bmBuyID;
	SetSubWndBuyItemInfo();
	uiControlNumberInputScript.SetCount(1);
	SetSubWndBuyItemCount(1);
	FestivalRankingBuyWnd.ShowWindow();
}

function UpdateMyPointControls(optional INT64 forceItemNum)
{
	local ItemInfo costItemInfo;
	local INT64 myPoint;
	local array<ItemInfo> iInfos;

	if(Me.IsShowWindow() == false)
	{
		return;
	}
	costItemInfo = GetItemInfoByClassID(festivalBuyItemData.nCostItemClassID);

	if(buyCostType == 2)
	{
		MyPointItemWnd.SetTooltipType("");
		myPoint = myGamePoint;		
	}
	else
	{
		MyPointItemWnd.SetTooltipType("Inventory");

		if(forceItemNum > 0)
		{
			myPoint = forceItemNum;			
		}
		else
		{
			class'UIDATA_INVENTORY'.static.FindItemByClassID(costItemInfo.Id.ClassID, iInfos);

			if(iInfos.Length > 0)
			{
				myPoint = iInfos[0].ItemNum;				
			}
			else
			{
				myPoint = 0;
			}
		}
	}

	if(!MyPointItemWnd.SetItem(0, costItemInfo))
	{
		MyPointItemWnd.AddItem(costItemInfo);
	}
	MyPointTextBox.SetText(MakeCostString(string(myPoint)));
	MyPointTitleTextBox.SetText(costItemInfo.Name);
}

function HandleUpdateCostItem(array<ItemInfo> iInfos, optional int Index)
{
	UpdateMyPointControls(iInfos[0].ItemNum);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
}

defaultproperties
{
}
