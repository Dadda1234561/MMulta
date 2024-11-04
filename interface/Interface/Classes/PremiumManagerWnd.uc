class PremiumManagerWnd extends UICommonAPI;


var string m_WindowName;

var WindowHandle	m_hPremiumManagerWnd;
var HtmlHandle		m_hHtmlViewer;

var bool	m_bRecievedCloseUI;
var bool	m_bNpcZoomMode;

function OnRegisterEvent()
{
	RegisterEvent(EV_PremiumManagerWndShow);
	RegisterEvent(EV_NPCDialogWndHide);
	RegisterEvent(EV_PremiumManagerWndLoadHtmlFromString);
	RegisterEvent(EV_QuestIDWndLoadHtmlFromString);
	
	// register gamingstate enter/exit event 
	// - ������� ������, ó�� ȣ��ɶ� OnEnter�� OnExit�� ȣ����� ����.
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_GamingStateExit);
}

function OnLoad()
{
	SetClosingOnESC();

	m_hPremiumManagerWnd = GetWindowHandle(m_WindowName);
	m_hHtmlViewer = GetHtmlHandle(m_WindowName $ ".HtmlViewer");
}

function onShow()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(Self)), "QuestHTMLWnd,PremiumManagerWnd");

	// ��Ƽ���� ���� �ִٸ� �ݴ´�.
	if(GetWindowHandle("MultiSellWnd").IsShowWindow())
		GetWindowHandle("MultiSellWnd").HideWindow();

	SideBar(GetScript("SideBar")).ToggleByWindowName(m_WindowName,m_hPremiumManagerWnd.IsShowWindow());
	SideBar(GetScript("SideBar")).ToggleByWindowName("EinhasdWnd", m_hPremiumManagerWnd.IsShowWindow());
}

function OnHide()
{
	ProcClosePremiumManagerWnd();
	getInstanceL2Util().syncWindowLocAuto("QuestHTMLWnd,PremiumManagerWnd");

	SideBar(GetScript("SideBar")).ToggleByWindowName(m_WindowName,m_hPremiumManagerWnd.IsShowWindow());
	SideBar(GetScript("SideBar")).ToggleByWindowName("EinhasdWnd", m_hPremiumManagerWnd.IsShowWindow());
}

function OnEvent(int Event_ID, String param)
{
	switch(Event_ID)
	{
	case EV_PremiumManagerWndShow :
		ShowPremiumManagerWnd();
		break;
		
	case EV_NPCDialogWndHide :
		HideNPCDialogWnd();
		break;
		
	case EV_PremiumManagerWndLoadHtmlFromString :
		if(getInstanceUIData().getIsLiveServer())
		{
			setWindowTitleByString(GetSystemString(13535));
		}
		else
		{
			setWindowTitleByString(GetSystemString(3949));
		}
		HandleLoadHtmlFromString(param);
		break;
	case EV_QuestIDWndLoadHtmlFromString:
		m_hPremiumManagerWnd.HideWindow();
		break;
	}
}

function OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle)
{
	if(a_HtmlHandle==m_hHtmlViewer)
	{
		HideNPCDialogWnd();
	}
}

function HandleLoadHtmlFromString(string param)
{
	local string htmlString;
	ParseString(param, "HTMLString", htmlString);

	m_hHtmlViewer.LoadHtmlFromString(htmlString);
}


function PressCloseButton()
{
	if(m_bNpcZoomMode)
	{
		m_bRecievedCloseUI = true;
	}
}

function OnClickButton( string Name )
{
	PressCloseButton();
}

function BeginNpcZoomMode()
{
	m_bRecievedCloseUI = false;
	m_bNpcZoomMode = true;
}

function EndNpcZoomMode()
{
	ProcClosePremiumManagerWnd();
	
	m_bRecievedCloseUI = false;
	m_bNpcZoomMode = false;
}

function OnExitState( name a_CurrentStateName )
{
	if( a_CurrentStateName == 'NpcZoomCameraState' )
	{
		EndNpcZoomMode();
	}
}

function OnEnterState( name a_CurrentStateName )
{
	if( a_CurrentStateName == 'NpcZoomCameraState')
	{
		BeginNpcZoomMode();
	}
}

function ShowPremiumManagerWnd()
{
	ExecuteEvent(EV_QuestHtmlWndHide);
	m_hPremiumManagerWnd.ShowWindow();
	m_hPremiumManagerWnd.SetFocus();
}

function HideNPCDialogWnd()
{
	m_hPremiumManagerWnd.HideWindow();
}

function ProcClosePremiumManagerWnd()
{
	if( m_bRecievedCloseUI && m_bNpcZoomMode )
	{
		// must first m_bReShowPremiumManagerWnd be false because calling recursive function.	
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
	m_WindowName = "PremiumManagerWnd";

	PressCloseButton();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "PremiumManagerWnd" ).HideWindow();	
}

defaultproperties
{
     m_WindowName="PremiumManagerWnd"
}
