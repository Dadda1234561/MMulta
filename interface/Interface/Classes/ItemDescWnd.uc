class ItemDescWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle	m_hItemDescWnd;
var HtmlHandle		m_hHtmlViewer;

const DEFAULT_SIZE_X = 765;
const DEFAULT_SIZE_Y = 418;


function OnRegisterEvent()
{
	RegisterEvent(EV_ItemDescWndShow);
	RegisterEvent(EV_ItemDescWndLoadHtmlFromString);
	RegisterEvent(EV_ItemDescWndSetWindowTitle);
}

function OnLoad()
{
	SetClosingOnESC();

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_hItemDescWnd=GetHandle(m_WindowName);
		m_hHtmlViewer=HtmlHandle(GetHandle(m_WindowName$".HtmlViewer"));
	}
	else
	{
		m_hItemDescWnd=GetWindowHandle(m_WindowName);
		m_hHtmlViewer=GetHtmlHandle(m_WindowName$".HtmlViewer");
	}
}

function OnEvent(int Event_ID, String param)
{
	switch(Event_ID)
	{
		case EV_ItemDescWndShow:
			m_hItemDescWnd.ShowWindow();
			m_hItemDescWnd.SetFocus();
			break;
		case EV_ItemDescWndLoadHtmlFromString:
			HandleLoadHtmlFromString(param);
			break;
		case EV_ItemDescWndSetWindowTitle:
			HandleWindowTitle(param);
			break;
	}
}

function HandleWindowTitle(string param)
{
	local string title;
	ParseString(param, "Title", title);
	setWindowTitleByString(Title);
}

function HandleLoadHtmlFromString(string param)
{
	local string tmpHtmlString;
	local int sizeX, sizeY;
	
	ParseString(param, "HTMLString", tmpHtmlString);	
	//tmpHtmlString = GetEditBoxHandle("ChatWnd.ChatEditBox").GetString() @ tmpHtmlString;	
	ParseInt(tmpHtmlString, "size_x", sizeX);
	ParseInt(tmpHtmlString, "size_y", sizeY);

	
	if(sizeX > 0 && sizeY == 0) //X only
	{
		m_hItemDescWnd.SetWindowSize(sizeX, DEFAULT_SIZE_Y);		
	}	
	else if(sizeY > 0 && sizeX == 0) //Y only
	{
		m_hItemDescWnd.SetWindowSize(DEFAULT_SIZE_X, sizeY);
	}	
	else if(sizeX > 0 && sizeY > 0) //X+Y
	{
		m_hItemDescWnd.SetWindowSize(sizeX, sizeY);
	}
	else
	{
		m_hItemDescWnd.SetWindowSize(DEFAULT_SIZE_X, DEFAULT_SIZE_Y);
	}	
	m_hHtmlViewer.LoadHtmlFromString(tmpHtmlString);
}

/**
 * l2text �� html ������ ���� ����.
 **/
function ShowHelp(string strPath)
{
	if (Len(strPath)>0)
	{
		m_hHtmlViewer.LoadHtml(strPath);

		m_hItemDescWnd.ShowWindow();
		m_hItemDescWnd.SetFocus();
	}
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_WindowName="ItemDescWnd"
}
