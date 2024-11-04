//================================================================================
// EventFestivalWndWindowTooltip.
//================================================================================

class EventFestivalWndWindowTooltip extends UICommonAPI;

const TIMER_ID= 1010122;
var string m_WindowName;
var WindowHandle Me;
var TextBoxHandle TimeNumberText;
var TextBoxHandle TimeInfoText;
var int FestivalID;
var int FestivalEndTime;
var TextureHandle FestivalProgressIcon;
var TextureHandle FestivalDisable;
var int newFestivalID;
var EventFestivalWnd EventFestivalWndScript;
var SideBar SideBarScript;
var int nRemainItemTotalNum;

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	TimeInfoText = GetTextBoxHandle(m_WindowName $ ".TimeInfoText");
	FestivalProgressIcon = GetTextureHandle(m_WindowName $ ".FestivalInnerWnd.FestivalProgressIcon");
	TimeNumberText = GetTextBoxHandle(m_WindowName $ ".FestivalInnerWnd.TimeNumberText");
	FestivalDisable = GetTextureHandle(m_WindowName $ ".FestivalInnerWnd.FestivalDisable");
	newFestivalID = -1;
	SideBarScript = SideBar(GetScript("SideBar"));
	GetHandleItemWindowItem(0).SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	GetHandleItemWindowItem(1).SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	GetHandleItemWindowItem(2).SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	EventFestivalWndScript = EventFestivalWnd(GetScript("EventFestivalWnd"));
}

function OnRegisterEvent()
{
	RegisterEvent(EV_FestivalTopItemInfo);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_GotoWorldRaidServer);
}

function OnLoad()
{
	Initialize();
}

function OnShow()
{
	HandleOnShow();
}

function OnHide()
{
	HandleOnHide();
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case TimerID:
			FestivalEndTime = FestivalEndTime - 1;
			if(FestivalEndTime <= 0)
			{
				FestivalEndTime = 0;
				Me.KillTimer(TIMER_ID);
			}
			TimeNumberText.SetText(GetSecToTimeStr(FestivalEndTime));
			EventFestivalWndScript.UpdateTime();
			break;
	}
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_GotoWorldRaidServer:
			SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL, false);
			GetWindowHandle("EventFestivalWnd").HideWindow();
		case EV_Restart:
			Me.KillTimer(TIMER_ID);
			DisableAllItemWindow();
			newFestivalID = -1;
			break;
		case EV_FestivalTopItemInfo:
			if(IsPlayerOnWorldRaidServer())
			{
				return;
			}
			SetFestivalTopItemInfo(param);
			break;
	}
}

function CheckFestavalID(int tmpFestavalID, int nIsUseFestival)
{
	local EffectViewportWndHandle Viewport;

	Debug("CheckFestavalID" @ string(nIsUseFestival) @ SideBarScript.GetEffectViewportByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL, 0).GetWindowName());
	Viewport = SideBarScript.GetEffectViewportByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL, 0);
	switch(nIsUseFestival)
	{
		case 0:
			Me.HideWindow();
			SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL, false);
			Viewport.SpawnEffect("");
			Viewport.HideWindow();
			GetWindowHandle("EventFestivalWnd").HideWindow();
			break;
		case 1:
			SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL, true);
			if(newFestivalID != tmpFestavalID)
			{
				Viewport.SpawnEffect("LineageEffect2.ui_star_circle");
				Viewport.ShowWindow();
			}
			GotoState('StateActive');
			break;
		case 2:
			SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL, true);
			Viewport.HideWindow();
			Viewport.SpawnEffect("");
			GotoState('StateDeActive');
			GetWindowHandle("EventFestivalWnd").HideWindow();
			// End:0x1F7
			if(nRemainItemTotalNum == 0)
			{
				TimeInfoText.SetText(GetSystemString(13958) $ ":");				
			}
			else
			{
				TimeInfoText.SetText(GetSystemString(13046) $ ":");
			}
			break;
	}
	newFestivalID = tmpFestavalID;
}

function int getFestivalEndTime()
{
	return FestivalEndTime;
}

function SetFestivalTopItemInfo(string param)
{
	local int ListCount;
	local int tmpFestavalID;
	local int Grade;
	local int ItemID;
	local int RemainItemNum;
	local int MaxItemNum;
	local int i;
	local int nIsUseFestival;

	ParseInt(param,"IsUseFestival",nIsUseFestival);
	ParseInt(param,"FestivalID",tmpFestavalID);
	ParseInt(param,"ListCount",ListCount);
	ParseInt(param,"FestivalEndTime",FestivalEndTime);
	nRemainItemTotalNum = 0;
	for (i = 0; i < ListCount; i++)
	{
		ParseInt(param,"Grade" $ string(i),Grade);
		ParseInt(param,"itemID" $ string(i),ItemID);
		ParseInt(param,"MaxItemNum" $ string(i),MaxItemNum);
		ParseInt(param,"RemainItemNum" $ string(i),RemainItemNum);
		SetItemInfoByIndex(i,ItemID,RemainItemNum,MaxItemNum);
		nRemainItemTotalNum = nRemainItemTotalNum + RemainItemNum;
	}
	CheckFestavalID(tmpFestavalID, nIsUseFestival);
	Me.KillTimer(TIMER_ID);
	Me.SetTimer(TIMER_ID,1000);
}

function SetItemInfoByIndex (int Index, int ItemID, int RemainItemNum, int MaxItemNum)
{
	local ItemInfo Info;
	local ItemWindowHandle iWindowHandle;
	local TextBoxHandle textBoxItemName;
	local TextBoxHandle textBoxItemNum;

	Info = GetItemInfoByClassID(ItemID);
	iWindowHandle = GetHandleItemWindowItem(Index);
	textBoxItemName = GetHandleTextBoxHandleItemName(Index);
	textBoxItemNum = GetHandleTextBoxhandleItemNum(Index);
	iWindowHandle.Clear();
	iWindowHandle.AddItem(Info);
	textBoxItemName.SetText(makeShortStringByPixel(Info.Name,157,".."));
	textBoxItemNum.SetText(string(RemainItemNum) $ "/" $ string(MaxItemNum));
	SoldOutItemwindow(Index,RemainItemNum == 0);
}

function HandleOnShow()
{
	SideBarScript.GetEffectViewportByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_FESTIVAL, 0).HideWindow();
}

function HandleOnHide()
{
}

function ItemWindowHandle GetHandleItemWindowItem(int Index)
{
	return GetItemWindowHandle(m_WindowName $ ".itemGroup" $ string(Index) $ ".GoldItemWindow");
}

function TextBoxHandle GetHandleTextBoxHandleItemName(int Index)
{
	return GetTextBoxHandle(m_WindowName $ ".itemGroup" $ string(Index) $ ".GoldText");
}

function TextBoxHandle GetHandleTextBoxhandleItemNum(int Index)
{
	return GetTextBoxHandle(m_WindowName $ ".itemGroup" $ string(Index) $ ".GoldNumberText");
}

function TextureHandle GetHandleTextureSoldOut(int Index)
{
	return GetTextureHandle(m_WindowName $ ".itemGroup" $ string(Index) $ ".SoldOutImg");
}

function string GetSecToTimeStr(int Sec)
{
	local int m_timeDay;
	local int m_timeHour;
	local int m_timeMin;
	local int total_m;
	local int total_h;

	total_m = Sec / 60;
	total_h = total_m / 60;
	m_timeDay = total_h / 24;
	m_timeHour = int(total_h % 24);
	m_timeMin = int(total_m % 60);
	if ( m_timeDay > 0 )
	{
		return MakeFullSystemMsg(GetSystemMessage(4466),string(m_timeDay),string(m_timeHour),string(m_timeMin));
	}
	else if ( m_timeHour > 0 )
	{
		return MakeFullSystemMsg(GetSystemMessage(3304),string(m_timeHour),string(m_timeMin));
	} else if ( m_timeMin > 0 )
	{
		return MakeFullSystemMsg(GetSystemMessage(3390),string(m_timeMin));
	} else {
		return MakeFullSystemMsg(GetSystemMessage(4360),"1");
	}
	return "00:00:00";
}

function DisableAllItemWindow()
{
	DisableItemWindow(0);
	DisableItemWindow(1);
	DisableItemWindow(2);
}

function SoldOutItemwindow(int Index, bool isSoldout)
{
	if (isSoldout)
	{
		DisableItemWindow(Index);
		GetHandleTextureSoldOut(Index).ShowWindow();
	} else {
		EnableItemWindow(Index);
		GetHandleTextureSoldOut(Index).HideWindow();
	}
}

function DisableItemWindow(int Index)
{
	GetHandleItemWindowItem(Index).DisableWindow();
	GetHandleTextBoxHandleItemName(Index).SetTextColor(getInstanceL2Util().Gray);
	GetHandleTextBoxhandleItemNum(Index).SetTextColor(getInstanceL2Util().Gray);
}

function EnableItemWindow(int Index)
{
	GetHandleItemWindowItem(Index).EnableWindow();
	GetHandleTextBoxHandleItemName(Index).SetTextColor(getInstanceL2Util().White);
	GetHandleTextBoxhandleItemNum(Index).SetTextColor(getInstanceL2Util().Yellow);
}

function OpenMainWindow ();

auto state StateActive
{
	function BeginState()
	{
		FestivalDisable.HideWindow();
		TimeInfoText.SetText(GetSystemString(1108) $ ":");
		TimeNumberText.SetText(GetSecToTimeStr(FestivalEndTime));
		TimeNumberText.SetTooltipText(GetSystemString(1108));
		TimeInfoText.SetTextColor(GetColor(174, 152, 121, 255));
		TimeNumberText.SetTextColor(GetColor(174, 152, 121, 255));
		FestivalProgressIcon.SetTexture("L2UI_CT1.OlympiadWnd.ONICON");
		Debug("State StateActive");
	}

	function EndState()
	{
	}

	function OpenMainWindow()
	{
		EventFestivalWndScript.Me.ShowWindow();
	}
	
}

state StateDeActive
{
	function BeginState()
	{
		FestivalDisable.ShowWindow();
		TimeNumberText.SetTooltipText(GetSystemString(13046));
		TimeNumberText.SetText(GetSecToTimeStr(FestivalEndTime));
		TimeInfoText.SetTextColor(getInstanceL2Util().Gray);
		TimeNumberText.SetTextColor(getInstanceL2Util().Gray);
		FestivalProgressIcon.SetTexture("L2UI_CT1.OlympiadWnd.OffICON");
		Debug("State StateDeActive");
	}

	function EndState()
	{
	}

	function OpenMainWindow()
	{
		EventFestivalWndScript.Me.HideWindow();
		AddSystemMessage(13287);
	}
	
}

defaultproperties
{
}
