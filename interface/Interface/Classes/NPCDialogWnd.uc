class NPCDialogWnd extends UICommonAPI;

const DEFAULT_SIZE_X = 314;
const DEFAULT_SIZE_Y = 418;

var string m_WindowName;

var WindowHandle m_hNPCDialogWnd;
var HtmlHandle m_hHtmlViewer;

var bool m_bRecievedCloseUI;
var bool m_bNpcZoomMode;
var bool m_skipWindow;

event OnRegisterEvent()
{
	RegisterEvent(EV_NPCDialogWndShow);
	RegisterEvent(EV_NPCDialogWndHide);
	RegisterEvent(EV_NPCDialogWndLoadHtmlFromString);
	RegisterEvent(EV_QuestIDWndLoadHtmlFromString);
	
	// register gamingstate enter/exit event 
	// - ������� ������, ó�� ȣ��ɶ� OnEnter�� OnExit�� ȣ����� ����.
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_GamingStateExit);
}

event OnLoad()
{
	SetClosingOnESC();
	m_hNPCDialogWnd = GetWindowHandle(m_WindowName);
	m_hHtmlViewer = GetHtmlHandle(m_WindowName $ ".HtmlViewer");
}

event OnShow()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "QuestHTMLWnd,NPCDialogWnd");
	// End:0x73
	if(GetWindowHandle("MultiSellWnd").IsShowWindow())
	{
		GetWindowHandle("MultiSellWnd").HideWindow();
	}
}

event OnHide()
{
	ProcCloseNPCDialogWnd();
	getInstanceL2Util().syncWindowLocAuto("QuestHTMLWnd,NPCDialogWnd");
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_NPCDialogWndShow :
			ShowNPCDialogWnd();
			// End:0x76
			break;
		case EV_NPCDialogWndHide :
			HideNPCDialogWnd();
			// End:0x76
			break;
		// End:0x59
		case EV_NPCDialogWndLoadHtmlFromString :
			setWindowTitleByString(GetSystemString(444));	 //Ÿ��Ʋ�� "��ȭ"�� �ٲ��ش�. 
			HandleLoadHtmlFromString(param);
			// End:0x76
			break;
		// End:0x73
		case EV_QuestIDWndLoadHtmlFromString:
			m_hNPCDialogWnd.HideWindow();
			// End:0x76
			break;
	}
}

event OnExitState(name a_CurrentStateName)
{
	// End:0x15
	if(a_CurrentStateName == 'NpcZoomCameraState')
	{
		EndNpcZoomMode();
	}
}

event OnEnterState(name a_CurrentStateName)
{
	// End:0x15
	if(a_CurrentStateName == 'NpcZoomCameraState')
	{
		BeginNpcZoomMode();
	}
}

event OnClickButton(string Name)
{
	PressCloseButton();
}

event OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle)
{
	// End:0x15
	if(a_HtmlHandle == m_hHtmlViewer)
	{
		HideNPCDialogWnd();
	}
}

function HandleLoadHtmlFromString(string param)
{
	local string tmpHtmlString;
	local int bSkipWindow;
	local int sizeX, sizeY;
	
	ParseString(param, "HTMLString", tmpHtmlString);	
	//tmpHtmlString = GetEditBoxHandle("ChatWnd.ChatEditBox").GetString() @ tmpHtmlString;	
	ParseInt(tmpHtmlString, "size_x", sizeX);
	ParseInt(tmpHtmlString, "size_y", sizeY);
	ParseInt(tmpHtmlString, "skip_window", bSkipWindow);

	m_skipWindow = bSkipWindow == 1;

	if(sizeX > 0 && sizeY == 0) //X only
	{
		m_hNPCDialogWnd.SetWindowSize(sizeX, DEFAULT_SIZE_Y);		
	}	
	else if(sizeY > 0 && sizeX == 0) //Y only
	{
		m_hNPCDialogWnd.SetWindowSize(DEFAULT_SIZE_X, sizeY);
	}	
	else if(sizeX > 0 && sizeY > 0) //X+Y
	{
		m_hNPCDialogWnd.SetWindowSize(sizeX, sizeY);
	}
	else
	{
		m_hNPCDialogWnd.SetWindowSize(DEFAULT_SIZE_X, DEFAULT_SIZE_Y);
	}	
	
	if (bSkipWindow == 0) {
		m_hHtmlViewer.LoadHtmlFromString(tmpHtmlString);
	}
}

function PressCloseButton()
{
	// End:0x11
	if(m_bNpcZoomMode)
	{
		m_bRecievedCloseUI = true;
	}
}

function BeginNpcZoomMode()
{
	m_bRecievedCloseUI = false;
	m_bNpcZoomMode = true;
}

function EndNpcZoomMode()
{
	ProcCloseNPCDialogWnd();
	m_bRecievedCloseUI = false;
	m_bNpcZoomMode = false;
}

function ShowNPCDialogWnd()
{	
	if (m_skipWindow) {
		HideNPCDialogWnd();
		return;
	}
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
		// must first m_bReShowNPCDialogWnd be false because calling recursive function.	
		m_bRecievedCloseUI = false;
		RequestFinishNPCZoomCamera();
	}
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PressCloseButton();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("NPCDialogWnd").HideWindow();
}

defaultproperties
{
     m_WindowName="NPCDialogWnd"
}
