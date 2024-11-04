//================================================================================
// NPCDialogLargeWnd.
//================================================================================

class NPCDialogLargeWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle m_hNPCDialogWnd;
var HtmlHandle m_hHtmlViewer;
var bool m_bRecievedCloseUI;
var bool m_bNpcZoomMode;

function OnRegisterEvent()
{
	RegisterEvent(EV_NPCDialogWndShowBig1);
	RegisterEvent(EV_NPCDialogWndHideBig1);
	RegisterEvent(EV_NPCDialogWndLoadHtmlFromStringBig1);
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_GamingStateExit);
}

function OnLoad()
{
	SetClosingOnESC();
	if(CREATE_ON_DEMAND == 0)
	{
		OnRegisterEvent();
	}
	// End:0x53
	if(CREATE_ON_DEMAND == 0)
	{
		m_hNPCDialogWnd = GetHandle(m_WindowName);
		m_hHtmlViewer = HtmlHandle(GetHandle(m_WindowName $ ".HtmlViewer"));
	}
	else
	{
		m_hNPCDialogWnd = GetWindowHandle(m_WindowName);
		m_hHtmlViewer = GetHtmlHandle(m_WindowName $ ".HtmlViewer");
	}
}

function OnShow()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "QuestHTMLWnd,NPCDialogWnd");
	// End:0x73
	if(GetWindowHandle("MultiSellWnd").IsShowWindow())
	{
		GetWindowHandle("MultiSellWnd").HideWindow();
	}
}

function OnHide()
{
	ProcCloseNPCDialogWnd();
	getInstanceL2Util().syncWindowLocAuto("QuestHTMLWnd,NPCDialogWnd");
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_NPCDialogWndShowBig1:
			ShowNPCDialogWnd();
			break;
		case EV_NPCDialogWndHideBig1:
			HideNPCDialogWnd();
			break;
		case EV_NPCDialogWndLoadHtmlFromStringBig1:
			setWindowTitleByString(GetSystemString(444));
			HandleLoadHtmlFromString(param);
			break;
		case EV_QuestIDWndLoadHtmlFromString:
			m_hNPCDialogWnd.HideWindow();
			break;
			default:
	}
}

function OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle)
{
	if(a_HtmlHandle == m_hHtmlViewer)
	{
		HideNPCDialogWnd();
	}
}

function HandleLoadHtmlFromString(string param)
{
	local string HtmlString;

	ParseString(param,"HTMLString",HtmlString);
	m_hHtmlViewer.LoadHtmlFromString(HtmlString);
}

function PressCloseButton()
{
	if(m_bNpcZoomMode)
	{
		m_bRecievedCloseUI = True;
	}
}

function OnClickButton(string Name)
{
	PressCloseButton();
}

function BeginNpcZoomMode()
{
	m_bRecievedCloseUI = False;
	m_bNpcZoomMode = True;
}

function EndNpcZoomMode()
{
	ProcCloseNPCDialogWnd();
	m_bRecievedCloseUI = False;
	m_bNpcZoomMode = False;
}

function OnExitState(name a_CurrentStateName)
{
	if(a_CurrentStateName == 'NpcZoomCameraState')
	{
		EndNpcZoomMode();
	}
}

function OnEnterState(name a_CurrentStateName)
{
	if(a_CurrentStateName == 'NpcZoomCameraState')
	{
		BeginNpcZoomMode();
	}
}

function ShowNPCDialogWnd()
{
	ExecuteEvent(EV_QuestHtmlWndHide);
	m_hNPCDialogWnd.ShowWindow();
	m_hNPCDialogWnd.SetFocus();
}

function HideNPCDialogWnd()
{
	m_hNPCDialogWnd.HideWindow();
}

function ProcCloseNPCDialogWnd()
{
	// End:0x22
	if(m_bRecievedCloseUI && m_bNpcZoomMode)
	{
		m_bRecievedCloseUI = false;
		RequestFinishNPCZoomCamera();
	}
}

function OnReceivedCloseUI()
{
	PressCloseButton();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("NPCDialogLargeWnd").HideWindow();
}

defaultproperties
{
     m_WindowName="NPCDialogLargeWnd"
}
