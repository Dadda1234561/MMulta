//================================================================================
// GlobalEventWnd.
// emu-dev.ru
//================================================================================
class GlobalEventWnd extends UICommonAPI;

const EVENT_BTN_NAME = "eventBtn_";
const TIMER_ID_BTN_DELAY = 1;
const TIMER_DELAY_BTN_DISABLE = 500;

struct GlobalEventInfo
{
	var int Index;
	var string Title;
	var string Desc;
};

var array<GlobalEventInfo> _eventInfoList;
var WindowHandle Me;
var string m_WindowName;
var RichListCtrlHandle eventRichListCtrl;
var bool _isWaitingBtnDelay;

function Initialize()
{
	InitControls();
	InitData();
}

function InitControls()
{
	Me = GetWindowHandle(m_WindowName);

	eventRichListCtrl = GetRichListCtrlHandle(m_WindowName $ ".List_ListCtrl");
	eventRichListCtrl.SetAppearTooltipAtMouseX(true);
	eventRichListCtrl.SetSelectedSelTooltip(false);
	eventRichListCtrl.SetSelectable(false);
	eventRichListCtrl.SetTooltipType("L2PassAdvanceListTooltip");
}

function InitData()
{
	_eventInfoList.Length = 0;
}

function GlobalEventInfo MakeEventInfo(int eventIndex)
{
	local string titleStr, descStr;
	local GlobalEventInfo eventInfo;

	GetEventHtmlString(eventIndex, titleStr, descStr);
	eventInfo.Index = eventIndex;
	eventInfo.Title = titleStr;
	eventInfo.Desc = descStr;

	return eventInfo;
}

function UpdateEventInfoControls()
{
	local int i;
	local RichListCtrlRowData eventRowData;
	local GlobalEventInfo eventInfo;
	local string wndTitle, EventTitle, eventTooltip;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));

	if(Me.IsShowWindow() == false)
	{
		return;
	}
	if(getInstanceUIData().getIsClassicServer())
	{
		wndTitle = GetSystemString(3949);		
	}
	else
	{
		wndTitle = GetSystemString(13535);
	}

	Me.SetWindowTitle(wndTitle);
	eventRichListCtrl.DeleteAllItem();
	eventRowData.cellDataList.Length = 2;

	for(i = 0; i < _eventInfoList.Length; i++)
	{
		eventInfo = _eventInfoList[i];
		eventRowData.cellDataList[0].drawitems.Length = 0;
		eventRowData.cellDataList[1].drawitems.Length = 0;
		eventRowData.ForceRefreshTooltip = true;
		EventTitle = eventInfo.Title;
		eventTooltip = (EventTitle $ "\\n") $ eventInfo.Desc;
		util.GetEllipsisString(EventTitle, 190);
		eventRowData.szReserved = eventTooltip;
		eventRowData.nReserved1 = 0;
		addRichListCtrlString(eventRowData.cellDataList[0].drawitems, EventTitle);
		addRichListCtrlButton(eventRowData.cellDataList[1].drawitems, EVENT_BTN_NAME $ string(eventInfo.Index), 0, 0, "L2UI_NewTex.GlobalEventWnd.GlobalEventBtn_Normal", "L2UI_NewTex.GlobalEventWnd.GlobalEventBtn_Down", "L2UI_NewTex.GlobalEventWnd.GlobalEventBtn_Over", 64, 32);
		eventRichListCtrl.InsertRecord(eventRowData);
	}
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

event OnShow()
{
	KillBtnDelayTimer();
	UpdateEventInfoControls();
	Me.SetFocus();
	eventRichListCtrl.SetScrollPosition(0);
}

event OnHide()
{
	KillBtnDelayTimer();
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_INIT_GLOBAL_EVENT_UI));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_SHOW_GLOBAL_EVENT_UI));
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(class'UIPacket'.const.S_EX_INIT_GLOBAL_EVENT_UI):
			Nt_S_EX_INIT_GLOBAL_EVENT_UI();
			break;
				case EV_PacketID(class'UIPacket'.const.S_EX_SHOW_GLOBAL_EVENT_UI):
			Nt_S_EX_SHOW_GLOBAL_EVENT_UI();
			break;
	}
}

event OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID_BTN_DELAY)
	{
		KillBtnDelayTimer();
	}
}

event OnClickButton(string Name)
{
	local int SelectedIndex;

	if(Left(Name, Len(EVENT_BTN_NAME)) == "eventBtn_")
	{
		if(!_isWaitingBtnDelay)
		{
			StartBtnDelayTimer();
			SelectedIndex = int(Right(Name, Len(Name) - Len(EVENT_BTN_NAME)));
			Rq_C_EX_SELECT_GLOBAL_EVENT_UI(SelectedIndex);
		}
	}
}

function Rq_C_EX_SELECT_GLOBAL_EVENT_UI(int eventIndex)
{
	local array<byte> stream;
	local UIPacket._C_EX_SELECT_GLOBAL_EVENT_UI packet;

	packet.nEventIndex = eventIndex;

	if(!class'UIPacket'.static.Encode_C_EX_SELECT_GLOBAL_EVENT_UI(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SELECT_GLOBAL_EVENT_UI, stream);
}

function Nt_S_EX_INIT_GLOBAL_EVENT_UI()
{
	local UIPacket._S_EX_INIT_GLOBAL_EVENT_UI packet;
	local int i;

	if(!class'UIPacket'.static.Decode_S_EX_INIT_GLOBAL_EVENT_UI(packet))
	{
		return;
	}
	_eventInfoList.Length = 0;

	for(i = 0; i < packet.vEventList.Length; i++)
	{
		_eventInfoList[i] = MakeEventInfo(packet.vEventList[i]);
		continue;
	}
	UpdateEventInfoControls();
}

function Nt_S_EX_SHOW_GLOBAL_EVENT_UI()
{
	Me.ShowWindow();
}

function StartBtnDelayTimer()
{
	_isWaitingBtnDelay = true;
	Me.SetTimer(TIMER_ID_BTN_DELAY, TIMER_DELAY_BTN_DISABLE);
}

function KillBtnDelayTimer()
{
	Me.KillTimer(TIMER_ID_BTN_DELAY);

	_isWaitingBtnDelay = false;
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
	m_WindowName="GlobalEventWnd"
}