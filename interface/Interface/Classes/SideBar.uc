//================================================================================
// SideBar.
//================================================================================

class SideBar extends UICommonAPI;

const WINDOWSIZE = 49;
const WINDOW_H_MIN = 2;
const WINDOW_H_GAP = 2;
const DIALOG_ID_MYSTERIOUS_CANCEL = 0;
const SIDEBAR_WIDTH = 52;

enum SIDEBAR_WINDOWS
{
	TYPE_VP, // 0
	TYPE_ELEMENT, // 1
	TYPE_L2PASS, // 2
	TYPE_LIVELCOINCRAFT, // 3
	TYPE_EINHASD, // 4
	TYPE_TIMEZONE, // 5
	TYPE_MYSTERIOUSHOUSE, // 6
	TYPE_HEROBOOK, // 7
	TYPE_NSHOP, // 8
	TYPE_VITAMANMANAGER, // 9
	TYPE_RANKING, // 10
	//TYPE_HOMUNCULUSWND, // 11
	TYPE_EVENTINFO, // 12
	TYPE_EVENT_EVENTLETTERCOLLECTOR, // 13
	TYPE_EVENT_EVENTBALTHUS, // 14
	TYPE_EVENT_MARBLEGAME, // 15
	TYPE_EVENT_FESTIVAL, // 16
	TYPE_EVENT_FESTIVAL_WRANKING, // 17
	TYPE_EVENT_FESTIVALRANKING, // 18
	TYPE_STEADYBOX, // 19
	TYPE_VIP, // 20
	TYPE_L2PASS_LIVE, // 21
	TYPE_CASHSHOP, // 22
	TYPE_COLLECTIONSYSTEM, // 23
	TYPE_HELPWINDOW, // 24
	TYPE_DISCORD, // 25
	TYPE_WORLDEXCHANGE, // 26
	TYPE_UNIQUEGACHA, // 27
	Max // 28
};

enum SIDEBAR_TYPE
{
	TYPE_NORMAL,  // 0
	TYPE_ONEVENT, // 1
	TYPE_SIDEBAR  // 2
};

struct ItemData
{
	var string WindowName;
	var bool IsActive;
	var bool isAlarm;
	var bool UseEffect;
	var SIDEBAR_TYPE Type;
};

var private string m_WindowName;
var private WindowHandle Me;
var private Rect rectWndLDowned;
var private bool isShowSideBar;
var private bool isLockVOption;
var private array<ItemData> itemDatas;
var private string DiscordURL;

static function SideBar Inst()
{
	return SideBar(GetScript("SideBar"));
}

private function SetWindowInit()
{
//	if(GetGameStateName() != "GAMINGSTATE") return;

	itemDatas.Length = SIDEBAR_WINDOWS.Max;
	itemDatas[SIDEBAR_WINDOWS.TYPE_VP].WindowName = "SideBarVPWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_VP].Type = TYPE_SIDEBAR;
	itemDatas[SIDEBAR_WINDOWS.TYPE_VP].UseEffect = true;
	itemDatas[SIDEBAR_WINDOWS.TYPE_ELEMENT].WindowName = "ElementalSpiritWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_LIVELCOINCRAFT].WindowName = "ShopLcoinCraftWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_EINHASD].WindowName = "EinhasdWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_TIMEZONE].WindowName = "TimeZoneWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE].WindowName = "MysteriousMansionWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE].Type = TYPE_ONEVENT;
	itemDatas[SIDEBAR_WINDOWS.TYPE_NSHOP].WindowName = "NShopWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_VITAMANMANAGER].WindowName = "PremiumManagerWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_RANKING].WindowName = "RankingWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_HEROBOOK].WindowName = "HeroBookWnd";
	//itemDatas[SIDEBAR_WINDOWS.TYPE_HOMUNCULUSWND].WindowName = "HomunculusWnd";
	//itemDatas[SIDEBAR_WINDOWS.TYPE_HOMUNCULUSWND].UseEffect = true;
	itemDatas[SIDEBAR_WINDOWS.TYPE_COLLECTIONSYSTEM].WindowName = "CollectionSystem";
	itemDatas[SIDEBAR_WINDOWS.TYPE_HELPWINDOW].WindowName = "HelpWindow";
	itemDatas[SIDEBAR_WINDOWS.TYPE_DISCORD].WindowName = "DiscordWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_WORLDEXCHANGE].WindowName = "WorldExchangeBuyWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENTINFO].WindowName = "EventInfoWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENTINFO].Type = TYPE_ONEVENT;
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENT_EVENTLETTERCOLLECTOR].WindowName = "EventletterCollectorLauncher";
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENT_EVENTLETTERCOLLECTOR].Type = TYPE_ONEVENT;
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENT_EVENTBALTHUS].WindowName = "EventBalthus";
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENT_EVENTBALTHUS].Type = TYPE_ONEVENT;
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENT_MARBLEGAME].WindowName = "SideBarMarbleGameWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENT_MARBLEGAME].Type = TYPE_ONEVENT;
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL].WindowName = "EventFestivalWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL].Type = TYPE_ONEVENT;
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL].UseEffect = true;
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVALRANKING].WindowName = "FestivaRankingWindowTooltip";
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVALRANKING].Type = TYPE_ONEVENT;

	if(getInstanceUIData().getIsLiveServer())
	{
		itemDatas[SIDEBAR_WINDOWS.TYPE_L2PASS_LIVE].WindowName = "L2PassWnd";
	}
	else
	{
		itemDatas[SIDEBAR_WINDOWS.TYPE_L2PASS].WindowName = "L2PassWnd";
	}

	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL_WRANKING].WindowName = "FestivalWRankingWindowTooltip";
	itemDatas[SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL_WRANKING].Type = TYPE_ONEVENT;
	itemDatas[SIDEBAR_WINDOWS.TYPE_VIP].WindowName = "VIPInfoWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_CASHSHOP].WindowName = "BR_NewCashShopWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_UNIQUEGACHA].WindowName = "UniqueGacha";
	itemDatas[SIDEBAR_WINDOWS.TYPE_UNIQUEGACHA].Type = TYPE_ONEVENT;

	if(GetLanguage() == LANG_Korean)
	{
		return;
	}

	itemDatas[SIDEBAR_WINDOWS.TYPE_STEADYBOX].WindowName = "SteadyBoxWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_STEADYBOX].Type = TYPE_ONEVENT;
	itemDatas[SIDEBAR_WINDOWS.TYPE_STEADYBOX].UseEffect = true;
	itemDatas[SIDEBAR_WINDOWS.TYPE_VIP].WindowName = "VIPInfoWnd";
	itemDatas[SIDEBAR_WINDOWS.TYPE_CASHSHOP].WindowName = "BR_NewCashShopWnd";

	GetINIString("URL", "DiscordURL", DiscordURL, "InterfaceSettings.ini");

}

event OnRegisterEvent()
{
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_CuriousHouseWaitState);
	RegisterEvent(EV_CuriousHouseEnter);
	RegisterEvent(EV_VipInfo);
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HERO_BOOK_INFO);
}

event OnLoad()
{
	SetWindowInit();
	Me = GetWindowHandle(m_WindowName);
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case EV_Restart:
			SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE, false);
			break;
		case EV_CuriousHouseEnter:
			SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE, false);
			break;
		case EV_CuriousHouseWaitState:
			HandleCuriousHouse(a_Param);
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
		case EV_GameStart:
			HandleOnGameStart();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_HERO_BOOK_INFO):
			ParsePacket_S_EX_HERO_BOOK_INFO();
			break;
	}
}

event OnShow()
{
	local int i;

	for(i = 0; i < itemDatas.Length; i++)
	{
		if(itemDatas[i].WindowName == "")
		{
			continue;
		}
		if(itemDatas[i].UseEffect)
		{
			GetWindowHandle(itemDatas[i].WindowName $ "Effect").SetAlpha(255);
		}
	}
	HandleCheckMainBGBtns();
	EffectsBringToFrontOf();
	CheckWorldRanking();
}

event OnClickButton(string a_ButtonID)
{
	if(CheckDrag())
	{
		return;
	}

	switch(a_ButtonID)
	{
		case "MinimizeButton":
			class'MinimizeManager'.static.Inst()._MinimizeWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
			break;	
	}
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	rectWndLDowned = Me.GetRect();
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local string WindowName;
	local int Index;

	if(CheckDrag())
	{
		return;
	}
	WindowName = GetWindowNameByBtnName(a_ButtonHandle.GetParentWindowHandle().GetWindowName());
	Debug(a_ButtonHandle.GetParentWindowName() @ WindowName @ string(Index));
	Index = GetWindowIndexByName(WindowName);

	if(Index == -1)
	{
		return;
	}
	
	if(itemDatas[Index].Type == TYPE_SIDEBAR)
	{
		return;
	}

	switch(a_ButtonHandle.GetWindowName())
	{
		case "MainBGBtn0":
			SetShowTargetWindowByIndex(Index);
			break;
		case "MainBGBtn1":
			SetHideTargetWindowByIndex(Index);
			break;
	}
}

event OnMouseOver(WindowHandle W)
{
	local int Index;
	local string WindowName;

	if(W.GetWindowName() != "MainBGBtn0" && W.GetWindowName() != "MainBGBtn1")
	{
		return;
	}
	WindowName = GetWindowNameByBtnName(W.GetParentWindowHandle().GetWindowName());
	Index = GetWindowIndexByName(WindowName);
	if(Index == -1)
	{
		return;
	}
	if(Index == 0)
	{
		ShowWindowTooltip(Index);
	}

	switch(Index)
	{
		//case SIDEBAR_WINDOWS.TYPE_HOMUNCULUSWND:
		//	break;
		case SIDEBAR_WINDOWS.TYPE_L2PASS:
		case SIDEBAR_WINDOWS.TYPE_L2PASS_LIVE:
			break;
		case SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL:
		case SIDEBAR_WINDOWS.TYPE_VIP:
			ShowWindowTooltip(Index);
			break;

		default:
			SetAlarmOnOff(Index, false);
			break;
	}
}

event OnMouseOut(WindowHandle W)
{
	local int Index;
	local string WindowName;

	if(W == Me)
	{
		return;
	}
	WindowName = GetWindowNameByBtnName(W.GetParentWindowHandle().GetWindowName());
	Index = GetWindowIndexByName(WindowName);

	if(Index == -1)
	{
		return;
	}
	if(Index == 0)
	{
		HideWindowTooltip(Index);
	}

	switch(Index)
	{
		case SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL:
		case SIDEBAR_WINDOWS.TYPE_VIP:
			HideWindowTooltip(Index);
			break;
	}
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	if(bFocused)
	{
		EffectsBringToFrontOf();
	}
}

event OnHide()
{
	local int i;

	for(i = 0; i < itemDatas.Length; i++)
	{
		if(itemDatas[i].WindowName == "")
		{
			continue;
		}
		if(itemDatas[i].UseEffect)
		{
			GetWindowHandle(itemDatas[i].WindowName $ "Effect").SetAlpha(0, 0.40f);
		}
	}
}

function SetWindowShowHideByIndex(int Index, optional bool isShow)
{
	local int isShowLink;
	local WindowHandle tmpItemWnd;

	if(GetGameStateName() == "COLLECTIONSTATE")
	{
		return;
	}
	tmpItemWnd = GetWindowByIndex(Index);
	itemDatas[Index].IsActive = isShow;

	if(itemDatas[Index].Type != 2)
	{
		if(LoadVOption(itemDatas[Index].WindowName))
		{
			SetShowTargetWindowByIndex(Index);
		}
		ToggleMainBGBtn(Index, isShowLink == 1 || CheckIsShowLinkWindow(Index));
	}
	if(isShow == tmpItemWnd.IsShowWindow())
	{
		return;
	}
	if(isShow)
	{
		tmpItemWnd.ShowWindow();
	}
	else
	{
		tmpItemWnd.HideWindow();
	}
	SortWindows();
}

private function HandleOnGameStart()
{
	local int i;

	for(i = 0; i < itemDatas.Length; i++)
	{
		if(itemDatas[i].WindowName == "")
		{
			continue;
		}
		SetAlarmOnOff(i, false);
		itemDatas[i].IsActive = false;
	}
	SetHideAllWindow();
	DefaultShowHide();
}

private function DefaultShowHide()
{
	local bool bShowVP, isKorean;
	local int bVitaminManager;

	isKorean = GetLanguage() == LANG_Korean;

	if(!isKorean)
	{
		SetLocalization();
	}
	bShowVP = getInstanceUIData().getIsClassicServer() || IsAdenServer();
	GetINIBool("Localize", "UseVitaminMgrLive", bVitaminManager, "L2.ini");

	if(bShowVP)
	{
		SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_VP, bShowVP);
	}

	SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_LIVELCOINCRAFT, getInstanceUIData().getIsLiveServer());
	SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_TIMEZONE, true);
	SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_HEROBOOK, getInstanceUIData().getIsLiveServer());
	SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_NSHOP, GetLanguage() == LANG_Korean);
	SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_VITAMANMANAGER, getInstanceUIData().getIsClassicServer() || bVitaminManager == 1);
	SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_RANKING, true);
	SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_HELPWINDOW, true);
	SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_DISCORD, true);
	//SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_HOMUNCULUSWND, getInstanceUIData().getIsLiveServer());
	SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_COLLECTIONSYSTEM, getInstanceUIData().getIsLiveServer());
	SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_WORLDEXCHANGE, true);

	//SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_WORLDEXCHANGE, getInstanceUIData().getIsLiveServer());

	//if(getInstanceUIData().getIsLiveServer() && class'WorldExchangeBuyWnd'.static.Inst().ChkUseableServerID())
	//{
	//	SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_WORLDEXCHANGE, true);
	//}

}

private function EffectsBringToFrontOf()
{
	local int i;

	for(i = 0; i < itemDatas.Length; i++)
	{
		if(itemDatas[i].WindowName == "")
		{
			continue;
		}
		if(itemDatas[i].UseEffect)
		{
			GetWindowHandle(itemDatas[i].WindowName $ "Effect").BringToFrontOf(m_WindowName);
		}
	}
}

private function SortWindows()
{
	local int i;
	local int nWndHMax;
	local int nMenuY;
	local Rect rectWnd;
	local WindowHandle tmpWindow;

	rectWnd = Me.GetRect();
	isShowSideBar = false;
	nWndHMax = 0;
	nMenuY = 0;

	for (i = 0; i < itemDatas.Length; i++)
	{
		if(itemDatas[i].WindowName == "")
		{
			continue;
		}
		tmpWindow = GetWindowByIndex(i);
		if(itemDatas[i].IsActive)
		{
			tmpWindow.MoveTo(rectWnd.nX, (rectWnd.nY + nWndHMax) + 25);
			nWndHMax = nWndHMax + WINDOWSIZE;
			isShowSideBar = true;
			if(tmpWindow.IsShowWindow())
			{
				nMenuY++;
			}
		}
	}
	if(nMenuY == 0)
	{
		nMenuY = 1;
	}

	Me.SetWindowSize(SIDEBAR_WIDTH, nMenuY * WINDOWSIZE + 34);
	if(isShowSideBar && !class'MinimizeManager'.static.Inst()._IsMin(m_hOwnerWnd.m_WindowNameWithFullPath))
	{
		Me.ShowWindow();
	}
	else
	{
		Me.HideWindow();
	}
}

private function HandleDialogOK()
{
	if(!class'UICommonAPI'.static.DialogIsOwnedBy(string(self)))
	{
		return;
	}

	switch(class'UICommonAPI'.static.DialogGetID())
	{
		case 0:
			RequestCancelCuriousHouse();
			break;
	}
}

private function ToggleMainBGBtn(int Index, bool On)
{
	if(On)
	{
		GetButtonHandle(m_WindowName $ ".Btn" $ itemDatas[Index].WindowName $ ".MainBGBtn0").HideWindow();
		GetButtonHandle(m_WindowName $ ".Btn" $ itemDatas[Index].WindowName $ ".MainBGBtn1").ShowWindow();
	}
	else
	{
		GetButtonHandle(m_WindowName $ ".Btn" $ itemDatas[Index].WindowName $ ".MainBGBtn1").HideWindow();
		GetButtonHandle(m_WindowName $ ".Btn" $ itemDatas[Index].WindowName $ ".MainBGBtn0").ShowWindow();
	}
}

private function HandleCheckMainBGBtns()
{
	local int i;
	local WindowHandle targetWindow;

	for(i = 0; i < itemDatas.Length; i++)
	{
		if(itemDatas[i].WindowName == "")
		{
			continue;
		}
		targetWindow = GetTargetWindowByIndex(i);

		if(targetWindow.m_pTargetWnd != none)
		{
			ToggleMainBGBtn(i, targetWindow.IsShowWindow());
			continue;
		}
		ToggleMainBGBtn(i, false);
	}
}

function ToggleByWindowName(string WindowName, bool On)
{
	local int Index;

	Index = GetWindowIndexByName(WindowName);
	ToggleMainBGBtn(Index, On);
}

function SideBarLockVOption(bool _isLockVOption)
{
	isLockVOption = _isLockVOption;
}

function SetPointByIndex(SIDEBAR_WINDOWS Index, int Min, int Max)
{
	GetStatusBarByIndex(Index).SetPoint(Min, Max);
}

function SetPointExpPercentRate(SIDEBAR_WINDOWS Index, float Per)
{
	GetStatusBarByIndex(Index).SetPointExpPercentRate(Per);
}

function SetIconTexture(SIDEBAR_WINDOWS Index, string TextureName)
{
	GetMainIconByIndex(Index).SetTexture(TextureName);
}

function SetDisableItem(SIDEBAR_WINDOWS Index)
{
	GetButtonHandle(m_WindowName $ ".Btn" $ itemDatas[Index].WindowName $ ".MainBGBtn1").DisableWindow();
	GetButtonHandle(m_WindowName $ ".Btn" $ itemDatas[Index].WindowName $ ".MainBGBtn0").DisableWindow();
}

function SetEnableItem(SIDEBAR_WINDOWS Index)
{
	GetButtonHandle(m_WindowName $ ".Btn" $ itemDatas[Index].WindowName $ ".MainBGBtn1").EnableWindow();
	GetButtonHandle(m_WindowName $ ".Btn" $ itemDatas[Index].WindowName $ ".MainBGBtn0").EnableWindow();
}

function TextBoxHandle GetTooltipTextBoxByIndex(int Index, int textIndex)
{
	return GetTooltipTextBoxByName(itemDatas[Index].WindowName, "text" $ string(textIndex));
}

function TextBoxHandle GetTooltipTextBoxByName(string WindowName, string TextBoxName)
{
	return GetTextBoxHandle(m_WindowName $ ".Btn" $ WindowName $ ".TooltipWnd." $ TextBoxName);
}

function TextureHandle GetMainIconByIndex(int Index)
{
	return GetMainIconByWindowName(itemDatas[Index].WindowName);
}

function TextureHandle GetMainIconByWindowName(string WindowName)
{
	return GetTextureHandle(m_WindowName $ ".Btn" $ WindowName $ ".IconMain");
}

function WindowHandle GetWindowByIndex(int Index)
{
	return GetWindowHandle(m_WindowName $ ".Btn" $ itemDatas[Index].WindowName);
}

function StatusRoundHandle GetStatusBarByIndex(int Index)
{
	return GetStatusRoundHandle(m_WindowName $ ".Btn" $ itemDatas[Index].WindowName $ ".MainStatus");
}

function TextureHandle GetMainAlarmByIndex(int Index)
{
	return GetTextureHandle(m_WindowName $ ".Btn" $ itemDatas[Index].WindowName $ ".MainAlarm");
}

function TextureHandle GetMainAlarmByName(string WindowName)
{
	return GetTextureHandle(m_WindowName $ ".Btn" $ WindowName $ ".MainAlarm");
}

private function WindowHandle GetTargetWindowByIndex(int Index)
{
	switch(Index)
	{
		case SIDEBAR_WINDOWS.TYPE_NSHOP:
			if(GetWindowHandle("IngameWebWnd").IsShowWindow())
			{
				if(IngameWebWnd(GetScript("IngameWebWnd")).Key == "l2nshop")
				{
					return GetWindowHandle("IngameWebWnd");
				}
			}
			break;
		case SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE:
			break;
		case SIDEBAR_WINDOWS.TYPE_EINHASD:
			return GetWindowHandle("PremiumManagerWnd");
		default:
			return GetWindowHandle(itemDatas[Index].WindowName);
	}
}

function AnimTextureHandle GetEffectAniTextureByIndex(int windowIndex, int Index)
{
	return GetAnimTextureHandle(itemDatas[windowIndex].WindowName $ "Effect.EffectAnim" $ string(Index));
}

function EffectViewportWndHandle GetEffectViewportByIndex(int widowIndex, int Index)
{
	return GetEffectViewportWndHandle(itemDatas[widowIndex].WindowName $ "Effect.EffectViewport" $ string(Index));
}

private function bool GetSomeAlarmActived()
{
	local int i;

	for(i = 0; i < itemDatas.Length; i++)
	{
		if(itemDatas[i].WindowName == "")
		{
			continue;
		}
		if(itemDatas[i].isAlarm)
		{
			return true;
		}
	}
	return false;
}

function bool _IsAlarmActived(SIDEBAR_WINDOWS Index)
{
	return itemDatas[Index].isAlarm;
}

private function bool CheckIsShowLinkWindow(int Index)
{
	switch(Index)
	{
		case SIDEBAR_WINDOWS.TYPE_NSHOP:
			if(GetWindowHandle("IngameWebWnd").IsShowWindow())
			{
				return IngameWebWnd(GetScript("IngameWebWnd")).Key == "l2nshop";
			}
			break;
		case SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE:
			break;
		case SIDEBAR_WINDOWS.TYPE_EINHASD:
			break;
		default:
			return class'UIAPI_WINDOW'.static.IsShowWindow(itemDatas[Index].WindowName);
	}
	return false;
}

private function bool CheckDrag()
{
	local Rect rectWnd;

	rectWnd = Me.GetRect();
	return GetAbs(rectWndLDowned.nX - rectWnd.nX) > 5 || GetAbs(rectWndLDowned.nY - rectWnd.nY) > 5;
}

function SetAlarmOnOff(int Index, bool On)
{
	if(!itemDatas[Index].IsActive && On)
	{
		return;
	}
	itemDatas[Index].isAlarm = On;
	if(On)
	{
		PlayMainEffectByIndex(Index);
		GetMainAlarmByIndex(Index).ShowWindow();
	}
	else
	{
		GetMainAlarmByIndex(Index).HideWindow();
	}
	if(GetSomeAlarmActived())
	{
		class'MinimizeManager'.static.Inst()._ShowAlarm(m_hOwnerWnd.m_WindowNameWithFullPath);		
	}
	else
	{
		class'MinimizeManager'.static.Inst()._HideAlarm(m_hOwnerWnd.m_WindowNameWithFullPath);
	}
}

function PlayMainEffectByIndex(int Index)
{
	local AnimTextureHandle effectTextureHandle;

	effectTextureHandle = GetAnimTextureHandle(m_WindowName $ ".Btn" $ itemDatas[Index].WindowName $ ".MainEffect");
	effectTextureHandle.Stop();
	effectTextureHandle.SetLoopCount(1);
	effectTextureHandle.Play();
}

function SaveVOption(string WindowName, bool On)
{
	if(! isLockVOption)
	{
		SetINIBool(WindowName, "v", On, "WindowsInfo.ini");
	}
}

private function bool LoadVOption(string WindowName)
{
	local int Value;

	if(! GetINIBool(WindowName, "v", Value, "WindowsInfo.ini"))
	{
		return false;
	}
	return Value == 1;
}

private function CustomTooltip getCustomToolTip(string Text)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info;

	ToolTip.MinimumWidth = 144;
	ToolTip.DrawList.Length = 1;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	Info.t_color.R = 178;
	Info.t_color.G = 190;
	Info.t_color.B = 207;
	Info.t_color.A = 255;
	Info.t_strText = Text;
	ToolTip.DrawList[0] = Info;
	return ToolTip;
}

private function string GetEllipsisString(string Str, int MaxWidth)
{
	local string fixedString;
	local int nWidth;
	local int nHeight;
	local int textWidth;

	textWidth = MaxWidth;
	GetTextSizeDefault(Str $ "...", nWidth, nHeight);

	if(nWidth < textWidth)
	{
		return Str;
	}
	fixedString = DivideStringWithWidth(Str, textWidth);

	if(fixedString != Str)
	{
		fixedString = fixedString $ "...";
	}
	return fixedString;
}

private function int GetWindowIndexByName(string WindowName)
{
	local int i;

	for(i = 0; i < itemDatas.Length; i++)
	{
		if(itemDatas[i].WindowName == "")
		{
			continue;
		}
		if(ToUpper(itemDatas[i].WindowName) == ToUpper(WindowName))
		{
			return i;
		}
	}
	return -1;
}

private function string GetWindowNameByBtnName(string btnName)
{
	return Right(btnName, Len(btnName) - 3);
}

private function int GetAbs(int Num)
{
	if(Num < 0)
	{
		return - Num;
	}
	return Num;
}

private function SetHideAllWindow()
{
	local int i;

	for(i = 0; i < itemDatas.Length; i++)
	{
		if(itemDatas[i].WindowName == "")
		{
			continue;
		}
		GetWindowByIndex(i).HideWindow();
	}
}

private function SetShowAllWindow()
{
	local int i;

	for(i = 0; i < itemDatas.Length; i++)
	{
		if(itemDatas[i].WindowName == "")
		{
			continue;
		}
		if(itemDatas[i].IsActive)
		{
			GetWindowByIndex(i).ShowWindow();
		}
	}
}

private function SetHideTargetWindowByIndex(int Index)
{
	local WindowHandle targetWindow;
	local WindowHandle emtyWindow;

	switch(Index)
	{
		case SIDEBAR_WINDOWS.TYPE_ELEMENT:
		case SIDEBAR_WINDOWS.TYPE_EVENT_EVENTLETTERCOLLECTOR:
		case SIDEBAR_WINDOWS.TYPE_EVENT_EVENTBALTHUS:
		case SIDEBAR_WINDOWS.TYPE_VIP:
			class'UIAPI_WINDOW'.static.HideWindow(itemDatas[Index].WindowName);
			return;
		case SIDEBAR_WINDOWS.TYPE_WORLDEXCHANGE:
			class'UIAPI_WINDOW'.static.HideWindow("WorldExchangeBuyWnd");
			class'UIAPI_WINDOW'.static.HideWindow("WorldExchangeRegiWnd");
			return;
		case SIDEBAR_WINDOWS.TYPE_UNIQUEGACHA:
			UniqueGacha(GetScript("UniqueGacha")).closeAltW();
			return;
	}

	targetWindow = GetTargetWindowByIndex(Index);

	if(emtyWindow == targetWindow)
	{
		return;
	}
	targetWindow.HideWindow();

	if(itemDatas[Index].Type == TYPE_SIDEBAR)
	{
		SaveVOption(targetWindow.GetWindowName(), false);
	}
}

private function SetShowTargetWindowByIndex(int Index)
{
	local WindowHandle targetWindow;
	local WindowHandle emptyWindow;

	switch(Index)
	{
		case SIDEBAR_WINDOWS.TYPE_NSHOP:
			showHideL2InGameWeb("nshop", "");
			return;
		case SIDEBAR_WINDOWS.TYPE_VITAMANMANAGER:
			RequestOpenWndWithoutNPC(OPEN_PREMIUM_MANAGER);
			return;
		case SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE:
			HandleMysteriousBtn();
			return;
		case SIDEBAR_WINDOWS.TYPE_ELEMENT:
			ElementalSpiritWnd(GetScript("ElementalSpiritWnd"))._API_RequestElementalSpiritInfo(true);
			break;
		case SIDEBAR_WINDOWS.TYPE_EVENT_EVENTLETTERCOLLECTOR:
		case SIDEBAR_WINDOWS.TYPE_EVENT_EVENTBALTHUS:
		case SIDEBAR_WINDOWS.TYPE_VIP:
			class'UIAPI_WINDOW'.static.ShowWindow(itemDatas[Index].WindowName);
			return;
		case SIDEBAR_WINDOWS.TYPE_CASHSHOP:
			ShowIngameShop();
			return;
		case SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL:
			EventFestivalWndWindowTooltip(GetScript("EventFestivalWndWindowTooltip")).OpenMainWindow();
			return;
		case SIDEBAR_WINDOWS.TYPE_EINHASD:
			RequestOpenWndWithoutNPC(OPEN_EINHASAD_COIN_HTML);
			return;
		case SIDEBAR_WINDOWS.TYPE_COLLECTIONSYSTEM:
			OpenCollectionSelectedItem();
			return;
		case SIDEBAR_WINDOWS.TYPE_HELPWINDOW:
			OnWindowHelp_BTNClick();
			return;
		case SIDEBAR_WINDOWS.TYPE_STEADYBOX:
			SteadyBoxWnd(GetScript("SteadyBoxWnd")).API_C_EX_STEADY_BOX_LOAD();
			return;
		case SIDEBAR_WINDOWS.TYPE_DISCORD:
			OpenGivenURL(DiscordURL);
			return;
	}
	
	targetWindow = GetTargetWindowByIndex(Index);

	if(targetWindow == emptyWindow)
	{
		return;
	}
	if(targetWindow.IsShowWindow())
	{
		return;
	}
	targetWindow.ShowWindow();
	targetWindow.SetFocus();
}

function setMakegfxWindowTooltip(int Type, string Str)
{
	if(Type == SIDEBAR_WINDOWS.TYPE_EVENT_EVENTLETTERCOLLECTOR)
	{
		GetWindowByIndex(SIDEBAR_WINDOWS.TYPE_EVENT_EVENTLETTERCOLLECTOR).SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(13105), getInstanceL2Util().White, "", true, MakeFullSystemMsg(GetSystemMessage(13070), Str $ GetSystemString(537)), getInstanceL2Util().White, "", true));
	}
	else if(Type == SIDEBAR_WINDOWS.TYPE_EVENT_EVENTBALTHUS)
	{
		GetWindowByIndex(SIDEBAR_WINDOWS.TYPE_EVENT_EVENTBALTHUS).SetTooltipCustomType(MakeTooltipSimpleText(Str));
	}
}

private function ShowWindowTooltip(int Index)
{
	local WindowHandle windowTooltip;

	windowTooltip = GetWindowHandle(itemDatas[Index].WindowName $ "WindowTooltip");
	windowTooltip.SetAnchor(m_WindowName $ ".BTN" $ itemDatas[Index].WindowName, "BottomLeft", "BottomRight", 0, 0);
	if(CheckTooltipLeftArea(windowTooltip))
	{
		windowTooltip.SetAnchor(m_WindowName $ ".BTN" $ itemDatas[Index].WindowName, "BottomRight", "BottomLeft", 0, 0);
	}
	windowTooltip.ShowWindow();
	windowTooltip.SetFocus();
}

private function HideWindowTooltip(int Index)
{
	local WindowHandle windowTooltip;

	windowTooltip = GetWindowHandle(itemDatas[Index].WindowName $ "WindowTooltip");
	windowTooltip.HideWindow();
}

private function bool CheckTooltipLeftArea(WindowHandle targetWindowTooltip)
{
	local Rect windowTooltipRect;

	windowTooltipRect = targetWindowTooltip.GetRect();

	if(windowTooltipRect.nX < 0)
	{
		return true;
	}
	return false;
}

private function SetLocalization()
{
	local int nShowUsePrimeShop, nUseVipInfoWnd;
	local string strShopType, VipinfoServerType;

	if(getInstanceUIData().getIsClassicServer())
	{
		if(IsAdenServer())
		{
			VipinfoServerType = "UseVipInfoWndAden";
			strShopType = "UseAdenPrimeShop";
		}
		else
		{
			VipinfoServerType = "UseVipInfoWndClassic";
			strShopType = "UseClassicPrimeShop";
		}
	}
	else
	{
		VipinfoServerType = "UseVipInfoWnd";
		strShopType = "UsePrimeShop";
	}
	GetINIBool("VipSystem", VipinfoServerType, nUseVipInfoWnd, "L2.ini");
	SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_VIP, nUseVipInfoWnd > 0);
	GetINIBool("PrimeShop", strShopType, nShowUsePrimeShop, "L2.ini");
	SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_CASHSHOP, nShowUsePrimeShop > 0);
}

private function ShowIngameShop()
{
	if(getInstanceUIData().getIsClassicServer() && !IsAdenServer())
	{
		toggleWindow("IngameShopWnd", true, true);
	}
	else
	{
		ExecuteEvent(EV_BR_CashShopToggleWindow);
	}
}

private function HandleCuriousHouse(string a_Param)
{
	local int HouseState;
	local AnimTextureHandle BgCircle_Ani;

	ParseInt(a_Param, "State", HouseState);
	GetWindowByIndex(SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(2812)));
	switch(HouseState)
	{
		case 0:
		case 1:
			BgCircle_Ani = GetAnimTextureHandle(m_WindowName $ ".BtnMysteriousMansionWnd.BgCircle_Ani");
			BgCircle_Ani.Stop();
			SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE, false);
			SetAlarmOnOff(SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE, false);
			break;
		case 2:
			AddSystemMessage(3732);
			SetEnableItem(SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE);
			SetWindowShowHideByIndex(SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE, true);
			PlayMainEffectByIndex(SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE);
			SetAlarmOnOff(SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE, true);
			BgCircle_Ani = GetAnimTextureHandle(m_WindowName $ ".BtnMysteriousMansionWnd.BgCircle_Ani");
			BgCircle_Ani.SetLoopCount(9999999);
			BgCircle_Ani.Play();
			BgCircle_Ani.ShowWindow();
			break;
		case 3:
			BgCircle_Ani = GetAnimTextureHandle(m_WindowName $ ".BtnMysteriousMansionWnd.BgCircle_Ani");
			BgCircle_Ani.Stop();
			BgCircle_Ani.HideWindow();
			SetDisableItem(SIDEBAR_WINDOWS.TYPE_MYSTERIOUSHOUSE);
			break;
	}
}

private function HandleMysteriousBtn()
{
	DialogSetID(0);
	DialogShow(DialogModalType_Modal, DialogType_OKCancel, GetSystemMessage(3783), string(self));
}

function showHideL2InGameWeb(string Category, string Message)
{
	local string strParam;

	ParamAdd(strParam, "Category", Category);
	ParamAdd(strParam, "Message", "");
	ExecuteEvent(10120, strParam);
}

function OpenCollectionSelectedItem()
{
	local CollectionSystem collectionSystemScript;

	collectionSystemScript = CollectionSystem(GetScript("collectionSystem"));
	collectionSystemScript.API_C_EX_COLLECTION_OPEN_UI();
}

function OnWindowHelp_BTNClick()
{
	class'HelpWnd'.static.ShowHelp(1);	
}

private function CheckWorldRanking()
{
	if(IsAdenServer() && IsPlayerOnWorldRaidServer())
	{
		SetIconTexture(SIDEBAR_WINDOWS.TYPE_RANKING, "L2UI_NewTex.SideBar.SideBar_WorldRankingIcon");		
	}
	else
	{
		SetIconTexture(SIDEBAR_WINDOWS.TYPE_RANKING, "L2UI_NewTex.SideBar.SideBar_RankingIcon");
	}
}

private function ParsePacket_S_EX_HERO_BOOK_INFO()
{
	local UIPacket._S_EX_HERO_BOOK_INFO packet;
	local HeroBookData levelData;
	local string perString;
	local Color applyColor;

	if(! class'UIPacket'.static.Decode_S_EX_HERO_BOOK_INFO(packet))
	{
		return;
	}
	class'HeroBookAPI'.static.GetHeroBookData(packet.nLevel, levelData);

	if(packet.nPoint >= levelData.MaxPoint)
	{
		perString = GetSystemString(3451);
		applyColor = getInstanceL2Util().ColorLightBrown;		
	}
	else
	{
		perString = cutZeroDecimalStr(ConvertFloatToString((float(packet.nPoint) / float(levelData.MaxPoint)) * 100, 2, false)) $ "%";

		if((float(packet.nPoint) / float(levelData.MaxPoint)) * 100 >= 10)
		{
			applyColor = GetColor(255, 221, 102, 255);			
		}
		else
		{
			applyColor = GTColor().White;
		}
	}

	if(levelData.NextSkillID <= 0)
	{
		perString = GetSystemString(88) $ "" $ string(packet.nLevel);		
	}
	else
	{
		perString = GetSystemString(88) $ "" $ string(packet.nLevel) $ " (" $ perString $ ")";
	}
	GetWindowByIndex(SIDEBAR_WINDOWS.TYPE_HEROBOOK).SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(14157), getInstanceL2Util().White, "", true, perString, applyColor, "", true));
}

defaultproperties
{
	m_WindowName="SideBar"
}
