//================================================================================
// RestartMenuWnd.
// emu-dev.ru
//================================================================================

class RestartMenuWnd extends UICommonAPI
	dependson(RestartMenuWndOption);

//єОИ° Аз»зїл ЕёАМёУ »ујц
const TimerValue1 = 329;
//ѕЖµ§ ±ЧіЙ Restart
const DIALOG_CONFIRM_RESTART = 1640;
// ДЪАО »зїл єОИ° И®АО ґЩАМѕу·О±Ч ID
const DIALOG_CONFIRM_COINRESTART = 1641;
const DIALOG_CONFIRM_FORTRESS = 1642;
const DIALOG_CONFIRM_CASTLE = 1643;
const DIALOG_CONFIRM_RESTART_TIME_ZONE = 1644;
const RESTARTPOINTITEM_ADENA = 57;
const RESTARTPOINTITEM_LCOIN = 91663;

var string m_WindowName;
var bool m_bRestartON;
var WindowHandle m_wndTop;
var ButtonHandle m_btnVillage;
var ButtonHandle m_btnNearbyBattleField;
var ButtonHandle m_btnAgit;
var ButtonHandle m_btnCastle;
var ButtonHandle m_btnBattleCamp;
var ButtonHandle m_btnFortress;
var ButtonHandle m_btnUnPenaltyLimit;
var ButtonHandle m_btnTimeZone;
var WindowHandle m_BressFeatherWnd;
var ButtonHandle m_btnOriginal;
var TextBoxHandle UnPenaltyTime;
var WindowHandle Adenserver_Window;
var WindowHandle FreeCostRestart_wnd;
var TextBoxHandle FreeLcoinTitle_Text;
var TextBoxHandle LcoinTitle_Text;
var WindowHandle PayCostRestart_wnd;
var TextBoxHandle LcoinPersentBtn_txt;
var TextBoxHandle AdenaPersentBtn_txt;
var WindowHandle DieReportWnd;
var TextureHandle backTexture;
var ButtonHandle m_BtnDamage;
var ButtonHandle m_BtnLostItem;
var int nCostItemClassID;
var int nCostItemAmount;
var bool _isTimeZoneDie;
var int nRemainFreeRestoreCount;
var int nAdenaRestoreCost;
var int nAdenaRestoreRatio;
var int nLConinRestoreCost;
var int nLConinResotreRatio;
var string DialogAsset_path;
var L2Util util;
var int DelayToUseRebirthItem;
var array<WindowHandle> RestartAll;
var WindowHandle LastBtn;

event OnRegisterEvent()
{
	RegisterEvent(EV_Die);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_RestartMenuShow);
	RegisterEvent(EV_RestartMenuHide);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
	RegisterEvent(EV_DieInfoBegin);
	RegisterEvent(EV_DieInfoDamage);
	RegisterEvent(EV_DieInfoDropItem);
}

event OnLoad()
{
	//Init Handle
	SetClosingOnESC();
	DialogAsset_path = m_WindowName $ ".UIControlDialogAsset";
	m_wndTop = GetWindowHandle(m_WindowName);
	m_btnVillage = GetButtonHandle(m_WindowName $ ".btnVillage");
	m_btnTimeZone = GetButtonHandle(m_WindowName $ ".btnTimeZone");
	m_btnNearbyBattleField = GetButtonHandle(m_WindowName $ ".btnNearbyBattleField");
	m_btnAgit = GetButtonHandle(m_WindowName $ ".btnAgit");
	m_btnCastle = GetButtonHandle(m_WindowName $ ".btnCastle");
	m_btnBattleCamp = GetButtonHandle(m_WindowName $ ".btnBattleCamp");
	m_btnFortress = GetButtonHandle(m_WindowName $ ".btnFortress");
	m_btnUnPenaltyLimit = GetButtonHandle(m_WindowName $ ".btnUnPenaltyLimit"); //ёрЗи°ЎАЗ іл·Ў
	m_btnOriginal = GetButtonHandle(m_WindowName $ ".UnPenaltyWnd.BtnUnPenalty");
	m_BressFeatherWnd = GetWindowHandle(m_WindowName $ ".UnPenaltyWnd");
	UnPenaltyTime = GetTextBoxHandle(m_WindowName $ ".UnPenaltyWnd.UnPenaltyTime");
	Adenserver_Window = GetWindowHandle(m_WindowName $ ".Adenserver_Window");
	FreeCostRestart_wnd = GetWindowHandle(m_WindowName $ ".FreeCostRestart_wnd");
	FreeLcoinTitle_Text = GetTextBoxHandle(m_WindowName $ ".FreeCostRestart_wnd.FreeLcoinTitle_Text");
	LcoinTitle_Text = GetTextBoxHandle(m_WindowName $ ".FreeCostRestart_wnd.LcoinTitle_Text");
	PayCostRestart_wnd = GetWindowHandle(m_WindowName $ ".PayCostRestart_wnd");
	LcoinPersentBtn_txt = GetTextBoxHandle(m_WindowName $ ".PayCostRestart_wnd.LcoinPersentBtn_txt");
	AdenaPersentBtn_txt = GetTextBoxHandle(m_WindowName $ ".PayCostRestart_wnd.AdenaPersentBtn_txt");
	DieReportWnd = GetWindowHandle(m_WindowName $ ".DieReportWnd");
	backTexture = GetTextureHandle(m_WindowName $ ".BackTexture");
	m_BtnDamage = GetButtonHandle(m_WindowName $ ".DieReportWnd.BtnDamage");
	m_BtnLostItem = GetButtonHandle(m_WindowName $ ".DieReportWnd.BtnLostItem");
	util = L2Util(GetScript("L2Util"));
	m_bRestartON = false;
	PushWnd(m_btnTimeZone, RestartAll);
	PushWnd(m_btnVillage, RestartAll);
	PushWnd(m_btnNearbyBattleField, RestartAll);
	PushWnd(Adenserver_Window, RestartAll);
	PushWnd(m_btnAgit, RestartAll);
	PushWnd(m_btnCastle, RestartAll);
	PushWnd(m_btnBattleCamp, RestartAll);
	PushWnd(m_btnFortress, RestartAll);
	PushWnd(m_btnUnPenaltyLimit, RestartAll);
	PushWnd(m_btnOriginal, RestartAll);
	GetButtonHandle(m_WindowName $ ".Adenserver_Window.Help_Button").SetTooltipCustomType(getFeeHelpCustomTooltip());
}

function CustomTooltip getFeeHelpCustomTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13718), GTColor().White, "", true, true);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function CustomTooltip getFeeCustomTooltip(int ItemClassID, int Amount)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(637), GetColor(230, 220, 190, 255), "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom(class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ItemClassID)), true, true, 0, 4, 32, 32);
	drawListArr[drawListArr.Length] = addDrawItemText((class'UIDATA_ITEM'.static.GetItemName(GetItemID(ItemClassID)) $ " x") $ MakeCostString(string(Amount)), GTColor().White, "", false, true, 4, 10);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

event OnEnterState(name a_CurrentStateName)
{
	if(m_bRestartON)
	{
		ShowMe();
	}
	else
	{
		HideMe();
	}
	if(IsAdenServer())
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SettingBTN").ShowWindow();		
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SettingBTN").HideWindow();
	}
}

event OnEvent(int Event_ID, string param)
{
	// Debug("OnEvent" @ Event_ID);
	if(Event_ID == EV_Die)
	{
		HandleDie(param);
	}
	else if(Event_ID == EV_Restart)
	{
		HideMe();
	}
	else if(Event_ID == EV_RestartMenuShow)
	{
		ShowMe();
	}
	else if(Event_ID == EV_RestartMenuHide)
	{
		HideMe();
	}
	else if(Event_ID == EV_DialogOK)
	{
		HandleDialogOK();
	}
	else if(Event_ID == EV_DialogCancel)
	{
		//HandleDialogCancel();
	}
	else if(Event_ID == EV_DieInfoBegin)
	{
		m_BtnDamage.DisableWindow();
		m_BtnLostItem.DisableWindow();
	}
	else if(Event_ID == EV_DieInfoDamage)
	{
		m_BtnDamage.EnableWindow();
	}
	else if(Event_ID == EV_DieInfoDropItem)
	{
		m_BtnLostItem.EnableWindow();
	}
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnTimeZone":
			timerAllKill();
			OnTimeZoneClick();
			break;
		case "btnVillage":
			timerAllKill();
			OnVillageClick();
			break;
		case "btnNearbyBattleField":
			OnNearByBattleFieldClick();
			break;
		case "btnAgit":
			timerAllKill();
			OnAgitClick();
			break;
		case "btnCastle":
			timerAllKill();
			OnCastleClick();
			break;
		case "btnBattleCamp":
			timerAllKill();
			OnBattleCampClick();
			break;
		case "BtnUnPenalty":
			timerAllKill();
			OnOriginalClick();
			break;
		case "btnFortress":
			timerAllKill();
			OnFortressClick();
			break;
		case "btnUnPenaltyLimit": //ёрЗи°ЎАЗ іл·Ў
			timerAllKill();
			OnUnPenaltyLimitClick();
			break;
		case "BtnDamage":
			ShowHide("RestartMenuWndReportDamage");
			break;
		case "BtnLostItem":
			ShowHide("RestartMenuWndReportLostItem");
			break;
		case "payLcoinVillage":
			if(isTimeZoneDie())
			{
				showAskFeeDialog(1, MakeFullSystemMsg(GetSystemMessage(13708), string(nLConinResotreRatio) $ "%"), RESTARTPOINTITEM_LCOIN, nLConinRestoreCost);				
			}
			else
			{
				showAskFeeDialog(1, MakeFullSystemMsg(GetSystemMessage(13410), string(nLConinResotreRatio) $ "%"), RESTARTPOINTITEM_LCOIN, nLConinRestoreCost);
			}
			break;
		case "payAdenaVillage":
			if(isTimeZoneDie())
			{
				showAskFeeDialog(2, MakeFullSystemMsg(GetSystemMessage(13708), string(nAdenaRestoreRatio) $ "%"), RESTARTPOINTITEM_ADENA, nAdenaRestoreCost);
			}
			else
			{
				showAskFeeDialog(2, MakeFullSystemMsg(GetSystemMessage(13410), string(nAdenaRestoreRatio) $ "%"), RESTARTPOINTITEM_ADENA, nAdenaRestoreCost);
			}
			break;
		case "FeeVillage":
			DialogSetID(1641);
			if(isTimeZoneDie())
			{
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(13705), "100%"), string(self));				
			}
			else
			{
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(5265), "100%"), string(self));
			}
			break;
		case "SettingBTN":
			ToggleWindowRestartMenuWndOption();
			break;
	}
}

function ShowHide(string Name)
{
	if(class'UIAPI_WINDOW'.static.IsShowWindow(Name))
	{
		class'UIAPI_WINDOW'.static.HideWindow(Name);
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow(Name);
		class'UIAPI_WINDOW'.static.SetFocus(Name);
	}
}

//ЕёАМёУ
event OnTimer(int TimerID)
{
	if(TimerID == TimerValue1)
	{
		-- DelayToUseRebirthItem;
		setReLiveText();

		if(DelayToUseRebirthItem == 0)
		{
			m_wndTop.KillTimer(TimerValue1);
			m_btnOriginal.EnableWindow();
		}
	}
}

event OnHide()
{
	GetWindowHandle("RestartMenuWndOption").HideWindow();
}

/*******************************************************************************************************
 * №цЖ° Е¬ёЇ Гіё®
 * ****************************************************************************************************/
function OnVillageClick()
{
	if(IsAdenServer())
	{
		OnClickDialogCancel();
		DialogSetID(DIALOG_CONFIRM_RESTART);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(5266), string(self));
	}
	else
	{
		RequestRestartPoint(RESTART_VILLAGE, 0, 0);
	}
}

function OnTimeZoneClick()
{
	if(IsAdenServer())
	{
		OnClickDialogCancel();
		DialogSetID(1644);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13706), string(self));		
	}
	else
	{
		RequestRestartPoint(RESTART_TIME_FIELD_START_POS, 0, 0);
	}
}

function OnNearByBattleFieldClick()
{
	RequestRestartPoint(RESTART_NEARBY_BATTLE_FIELD, 0, 0);
}

function OnAgitClick()
{
	RequestRestartPoint(RESTART_AGIT, 0, 0);
}

function OnCastleClick()
{
	if(IsAdenServer())
	{
		OnClickDialogCancel();
		DialogSetID(DIALOG_CONFIRM_CASTLE);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13420), string(self));		
	}
	else
	{
		RequestRestartPoint(RESTART_CASTLE, 0, 0);
	}
}

function OnFortressClick()
{
	if(IsAdenServer())
	{
		OnClickDialogCancel();
		DialogSetID(DIALOG_CONFIRM_FORTRESS);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13421), string(self));		
	}
	else
	{
		RequestRestartPoint(RESTART_FORTRESS, 0, 0);
	}
}

function OnBattleCampClick()
{
	RequestRestartPoint(RESTART_BATTLE_CAMP, 0, 0);
}

// Гає№АЗ ±кЕР Е¬ёЇ
function OnOriginalClick()
{
	RequestRestartPoint(RESTART_ORIGINAL_PLACE, 0, 0);
}

function OnUnPenaltyLimitClick()//ёрЗи°ЎАЗ іл·Ў
{
	RequestRestartPoint(RESTART_ORIGINAL_PLACE_LIMIT, 0, 0);
}

function ToggleWindowRestartMenuWndOption()
{
	if(GetWindowHandle("RestartMenuWndOption").IsShowWindow())
	{
		GetWindowHandle("RestartMenuWndOption").HideWindow();
	}
	else
	{
		GetWindowHandle("RestartMenuWndOption").ShowWindow();
	}
}

function showAskFeeDialog(int nDialogID, string Msg, int nCostItemClassID, int nCount)
{
	DialogHide();
	CommonDialogGetScript(DialogAsset_path).StartNeedItemList(1);
	CommonDialogGetScript(DialogAsset_path).AddNeedItemClassID(nCostItemClassID, nCount);
	CommonDialogGetScript(DialogAsset_path).SetItemNum(1);
	CommonDialogGetScript(DialogAsset_path).SetDialogID(nDialogID);
	CommonDialogShow(DialogAsset_path, Msg, true);
}

function OnClickDialogCancel()
{
	CommonDialogHide(DialogAsset_path);
}

function OnClickDialogOk()
{
	if(CommonDialogGetScript(DialogAsset_path).GetDialogID() == 1)
	{
		RequestRestartPoint(RESTART_VILLAGE_USING_ITEM, 91663, nLConinRestoreCost);
	}
	else
	{
		RequestRestartPoint(RESTART_VILLAGE_USING_ITEM, 57, nAdenaRestoreCost);
	}
	CommonDialogHide(DialogAsset_path);
}

/*******************************************************************************************************
 * ґЩАМѕу·О±Ч
 * ****************************************************************************************************/
function HandleDialogOK()
{
	local int id;				//ґЩАМѕу·О±Ч ѕЖАМµрё¦ №ЮѕЖїВґЩ. 
	//local ItemInfo itemInfo;

	if(DialogIsMine())
	{
		id = DialogGetID();

		if(id == DIALOG_CONFIRM_COINRESTART)
		{
			//itemInfo = GetItemInfoByClassID(nCostItemClassID);
			RequestRestartPoint(RESTART_VILLAGE_USING_ITEM, nCostItemClassID, nCostItemAmount);
		}
		else if(id == DIALOG_CONFIRM_RESTART)
		{
			RequestRestartPoint(RESTART_VILLAGE, 0, 0);
		}
		else if(id == DIALOG_CONFIRM_RESTART_TIME_ZONE)
		{
			RequestRestartPoint(RESTART_TIME_FIELD_START_POS, 0, 0);
		}
		else if(id == DIALOG_CONFIRM_FORTRESS)
		{
			RequestRestartPoint(RESTART_FORTRESS, 0, 0);
		}
		else if(id == DIALOG_CONFIRM_CASTLE)
		{
			RequestRestartPoint(RESTART_CASTLE, 0, 0);
		}
	}
}

//ё®ЅєЕёЖ® ЖчАОЖ®ё¦ №ЮѕТА»¶§
function HandleDie(string param)
{
	local bool tmpOpt;
	local ButtonHandle emptyBtn;

	HideAllWindow();
	LastBtn = emptyBtn;
	_isTimeZoneDie = GetOptionBoolFromParam(param, "TimeFieldStartPos");
	SetBtnsPostion(m_btnTimeZone, _isTimeZoneDie);
	tmpOpt = GetOptionBoolFromParam(param, "Village");
	SetBtnsPostion(m_btnVillage, tmpOpt);
	tmpOpt = GetOptionBoolFromParam(param, "Agit");
	SetBtnsPostion(m_btnAgit, tmpOpt);
	tmpOpt = GetOptionBoolFromParam(param, "NearbyBattleField");
	SetBtnsPostion(m_btnNearbyBattleField, tmpOpt);
	tmpOpt = GetOptionBoolFromParam(param, "Castle");
	SetBtnsPostion(m_btnCastle, tmpOpt);
	tmpOpt = GetOptionBoolFromParam(param, "BattleCamp");
	SetBtnsPostion(m_btnBattleCamp, tmpOpt);
	tmpOpt = GetOptionBoolFromParam(param, "Fortress");
	SetBtnsPostion(m_btnFortress, tmpOpt);
	tmpOpt = GetOptionBoolFromParam(param, "AvailableCountRebirthItem");
	SetBtnsPostion(m_btnUnPenaltyLimit, tmpOpt);
	UnPenaltyTime.SetText("");
	tmpOpt = GetOptionBoolFromParam(param, "Original");
	SetBtnsPostion(m_BressFeatherWnd, tmpOpt);
	SetBressFeather(param);
	tmpOpt = SetAdenServerWindow(param);
	SetBtnsPostion(Adenserver_Window, tmpOpt);
	UpdateVillageInfoUI(_isTimeZoneDie);
	SetWindowSize();
}

function UpdateVillageInfoUI(bool isTimeZoneDie)
{
	local TextBoxHandle freeCostTitleTextBox, payCostTitleTextBox;

	freeCostTitleTextBox = GetTextBoxHandle(FreeCostRestart_wnd.m_WindowNameWithFullPath $ ".VillageTitle_Text");
	payCostTitleTextBox = GetTextBoxHandle(PayCostRestart_wnd.m_WindowNameWithFullPath $ ".VillageTitle_Text");

	if(isTimeZoneDie)
	{
		freeCostTitleTextBox.SetText(GetSystemString(14132));
		payCostTitleTextBox.SetText(GetSystemString(14132));
	}
	else
	{
		freeCostTitleTextBox.SetText(GetSystemString(372));
		payCostTitleTextBox.SetText(GetSystemString(372));
	}
}

function bool isTimeZoneDie()
{
	return _isTimeZoneDie;
}

function ShowMe()
{
	CommonDialogSetScript(DialogAsset_path, "", true);
	CommonDialogGetScript(DialogAsset_path).DelegateOnCancel = OnClickDialogCancel;
	CommonDialogGetScript(DialogAsset_path).DelegateOnClickBuy = OnClickDialogOk;
	m_bRestartON = true;
	m_wndTop.ShowWindow();
	m_wndTop.SetFocus();
}

function HideMe()
{
	timerAllKill();
	m_bRestartON = false;
	m_wndTop.HideWindow();
	m_BtnDamage.DisableWindow();
	m_BtnLostItem.DisableWindow();
	CommonDialogHide(DialogAsset_path);
}

/*******************************************************************************************************
 * Гає№АЗ ±кЕР
 * ****************************************************************************************************/
//Гає№№ЮАє ±кЕР ёЮЅГБц »С·ББЬ
function setReLiveText()
{
	local string str;

	if(DelayToUseRebirthItem == 0)
	{
		str = "";
	}
	else
	{
		str = MakeFullSystemMsg(GetSystemMessage(3278), string(DelayToUseRebirthItem));
	}
	UnPenaltyTime.SetText(str);
}

// Гає№АЗ ±кЕР ЕёАМёУ µоА» И°їл »зАМБо Б¶Аэ
function SetBressFeather(string param)
{
	// єОИ° Аз»зїл ЅГ°Ј
	ParseInt(param, "DelayToUseRebirthItem", DelayToUseRebirthItem);

	if(DelayToUseRebirthItem != 0)
	{
		timerAllKill();
		// Гає№ №ЮАє ±кЕНА» »зїлЗПБц ёшЗП°Ф ЗФ. 
		m_btnOriginal.DisableWindow();
		DelayToUseRebirthItem = DelayToUseRebirthItem - 1;
		setReLiveText();
		m_wndTop.SetTimer(TimerValue1, 1000);
		m_BressFeatherWnd.SetWindowSize(176, 40);
	}
	else
	{
		m_btnOriginal.EnableWindow();
		UnPenaltyTime.SetText("");
		m_BressFeatherWnd.SetWindowSize(176, 27);
	}
}

/*******************************************************************************************************
 * А©µµїм »зАМБо Жы Б¶Аэ
 * ****************************************************************************************************/
function SetWindowSize()
{
	local Rect lastBtnRect, topRectWnd;
	local int sizeH;

	lastBtnRect = LastBtn.GetRect();
	topRectWnd = m_wndTop.GetRect();
	sizeH = lastBtnRect.nY + lastBtnRect.nHeight + 8 + 35 - topRectWnd.nY;

	if(sizeH < 187)
	{
		sizeH = 187;
	}
	WindowReSize(sizeH);
}

// ѕЖµ§ ј­№ц А©µµїм 
function bool SetAdenServerWindow(string param)
{
	if(IsAdenServer())
	{
		ParseInt(param, "RemainFreeRestoreCount", nRemainFreeRestoreCount);

		if(nRemainFreeRestoreCount > 0)
		{
			FreeCostRestart_wnd.ShowWindow();
			PayCostRestart_wnd.HideWindow();
			LcoinTitle_Text.SetText(MakeFullSystemMsg(GetSystemMessage(2297), string(nRemainFreeRestoreCount)));			
		}
		else
		{
			ParseInt(param, "AdenaRestoreCost", nAdenaRestoreCost);
			ParseInt(param, "AdenaRestoreRatio", nAdenaRestoreRatio);
			ParseInt(param, "LConinRestoreCost", nLConinRestoreCost);
			ParseInt(param, "LConinResotreRatio", nLConinResotreRatio);
			LcoinPersentBtn_txt.SetText(string(nLConinResotreRatio) $ "%");
			AdenaPersentBtn_txt.SetText(string(nAdenaRestoreRatio) $ "%");
			FreeCostRestart_wnd.HideWindow();
			PayCostRestart_wnd.ShowWindow();
			GetButtonHandle("RestartMenuWnd.PayCostRestart_wnd.payLcoinVillage").SetTooltipType("Text");
			GetButtonHandle("RestartMenuWnd.PayCostRestart_wnd.payLcoinVillage").SetTooltipCustomType(getFeeCustomTooltip(91663, nLConinRestoreCost));
		}
		return true;
	}
	return false;
}

//Гў »зАМБо Б¶Аэ
function WindowReSize(int size)
{
	//local Rect rectWnd;
	BackTexture.SetWindowSize(199, size);

	//rectWnd = DieReportWnd.GetRect();	
	m_wndTop.SetWindowSize(280, size );//+ rectWnd.nHeight);
}

function TextureHandle GetLockTexture(int lockIndex)
{
	local RestartMenuWndOption restartMenuWNdOptionScr;

	restartMenuWNdOptionScr = RestartMenuWndOption(GetScript("RestartMenuWNdOption"));
	return GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ restartMenuWNdOptionScr.GetRestartName(restartMenuWNdOptionScr.restartPointLocks[lockIndex].restartPointLock, restartMenuWNdOptionScr.restartPointLocks[lockIndex].ClassID) $ "_lock");
}

/**********************************************************************************************************************
 * util
 * *******************************************************************************************************************/
// ЖД¶чїЎј­ bool ·О їЙјЗ ІЁі»±в
function bool GetOptionBoolFromParam(string param, string paramName)
{
	local int tmpOption;

	ParseInt(param, paramName, tmpOption);
	return tmpOption > 0;
}

// №иї­їЎ А©µµїм јХЅ±°Ф іЦ±в
function PushWnd(WindowHandle btnWnd, out array<WindowHandle> targetArray)
{
	targetArray.Length = targetArray.Length + 1;
	targetArray[RestartAll.Length - 1] = btnWnd;
}

// °ў №цЖ°µй А§ДЎ ёВГЯ±в
function SetBtnsPostion(WindowHandle mWnd, bool bUseBtn)
{
	HandleBtnLock(mWnd, bUseBtn);

	if(!bUseBtn)
	{
		return;
	}
	if(LastBtn.m_pTargetWnd == none)
	{
		mWnd.SetAnchor(m_WindowName $ "." $ m_btnVillage.GetWindowName(), "TopLeft", "TopLeft", 0, 2);		
	}
	else
	{
		mWnd.SetAnchor(m_WindowName $ "." $ LastBtn.GetWindowName(), "BottomLeft", "TopLeft", 0, 2);
	}
	mWnd.ShowWindow();
	LastBtn = mWnd;
}

function HandleBtnLock(WindowHandle mWnd, bool bUseBtn)
{
	local int lockIndex;
	local RestartMenuWndOption restartMenuWNdOptionScr;

	if(!IsAdenServer())
	{
		return;
	}
	restartMenuWNdOptionScr = RestartMenuWndOption(GetScript("RestartMenuWndOption"));
	lockIndex = restartMenuWNdOptionScr.GetIndexByName(mWnd.GetWindowName());

	if(lockIndex == -1)
	{
		return;
	}
	if(!bUseBtn)
	{
		GetLockTexture(lockIndex).HideWindow();
		return;
	}
	if(restartMenuWNdOptionScr.GetLockedByName(mWnd.GetWindowName()))
	{
		if((mWnd == m_btnVillage || mWnd == m_btnTimeZone) && !restartMenuWNdOptionScr.bExpDown)
		{
			GetLockTexture(lockIndex).HideWindow();
		}
		else
		{
			GetLockTexture(lockIndex).ShowWindow();
		}		
	}
	else
	{
		GetLockTexture(lockIndex).HideWindow();
	}
}

// ёрµз Гў ґЭ±в
function HideAllWindow()
{
	m_btnVillage.HideWindow();
	m_btnTimeZone.HideWindow();
	m_btnNearbyBattleField.HideWindow();
	Adenserver_Window.HideWindow();
	m_btnAgit.HideWindow();
	m_btnCastle.HideWindow();
	m_btnBattleCamp.HideWindow();
	m_btnFortress.HideWindow();
	m_btnUnPenaltyLimit.HideWindow(); //ёрЗи°ЎАЗ іл·Ў
	m_BressFeatherWnd.HideWindow();
}

//єОЗТ Аз»зїл ЕёАМёУ »иБ¦
function timerAllKill()
{
	m_wndTop.KillTimer(TimerValue1);
}

event OnReceivedCloseUI()
{
	if(GetWindowHandle(DialogAsset_path).IsShowWindow())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		CommonDialogHide(DialogAsset_path);
	}
	else if(GetWindowHandle("RestartmenuWndOption").IsShowWindow())
	{
		GetWindowHandle("RestartmenuWndOption").HideWindow();
	}
}

/**********************************************************************************************************************
 * etc
 * *******************************************************************************************************************/

defaultproperties
{
	m_WindowName="RestartmenuWnd"
}
