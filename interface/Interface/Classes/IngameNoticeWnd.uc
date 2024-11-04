class IngameNoticeWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle m_hIngameNoticeWnd;
var WebBrowserHandle m_hBrowserViewer;

function OnLoad()
{
	SetClosingOnESC();
	m_hIngameNoticeWnd = GetWindowHandle(m_WindowName);
	m_hBrowserViewer = GetWebBrowserHandle(m_WindowName $ ".WebBrowser");
}

function OnShow()
{
	m_hBrowserViewer.ShowWindow();
	if(m_hBrowserViewer.GetUrl() == "")
	{
		MainMenuShow();
	}
}

function OnHide()
{
	m_hBrowserViewer.HideWindow();
}

function OnRegisterEvent()
{
}

function NavigateToPetitionPage()
{
	local UserInfo UserInfo;
	local int serverNo;
	local string lineage2NoticeURL;
	local WebRequestInfo requestInfo;

	serverNo = GetServerNo();
	GetPlayerInfo(UserInfo);
	// End:0x120
	if(GetINIString("URL", "L2InGameBrowserNoticeURL", lineage2NoticeURL, "l2.ini"))
	{
		requestInfo.eMethodType = EWMT_POST;
		requestInfo.strRequestUrl = lineage2NoticeURL;
		requestInfo.arrRequestParams.Length = 2;
		requestInfo.arrRequestParams[0].strKey = "server_id";
		requestInfo.arrRequestParams[0].strValue = string(serverNo);
		requestInfo.arrRequestParams[1].strKey = "char_name";
		requestInfo.arrRequestParams[1].strValue = UserInfo.Name;
		m_hBrowserViewer.Navigate(requestInfo);
	}
}

function MainMenuShow()
{
	local UserInfo UserInfo;
	local int serverNo;
	local string lineage2NoticeURL;
	local WebRequestInfo requestInfo;

	serverNo = GetServerNo();
	GetPlayerInfo(UserInfo);
	// End:0xBB
	if(GetINIString("URL", "L2InGameBrowserNoticeURL", lineage2NoticeURL, "l2.ini"))
	{
		requestInfo.eMethodType = EWMT_POST;
		requestInfo.strRequestUrl = lineage2NoticeURL;
		requestInfo.arrRequestParams.Length = 2;
		requestInfo.arrRequestParams[0].strKey = "server_id";
		requestInfo.arrRequestParams[0].strValue = string(serverNo);
		requestInfo.arrRequestParams[1].strKey = "char_name";
		requestInfo.arrRequestParams[1].strValue = UserInfo.Name;
		m_hBrowserViewer.Navigate(requestInfo);
	}
}

function IsOpenWnd(string param)
{
	local string URL;
	local UserInfo UserInfo;
	local int serverNo;
	local string cookieKey;

	ParseString(param, "url", URL);
	// End:0x110
	if(URL == m_hBrowserViewer.GetUrl())
	{
		// End:0x6D
		if(m_hIngameNoticeWnd.IsShowWindow() == true)
		{
			m_hBrowserViewer.ExecuteJavaScript("getNoticeOpenStatus();");			
		}
		else
		{
			serverNo = GetServerNo();
			GetPlayerInfo(UserInfo);
			cookieKey = UserInfo.Name $ "_" $ string(serverNo) $ "_not_notice_again";
			// End:0x101
			if(m_hBrowserViewer.GetCookie(URL, cookieKey) == "")
			{
				m_hBrowserViewer.ExecuteJavaScript("getNoticeOpenStatus();");				
			}
			else
			{
				m_hBrowserViewer.HideWindow();
			}
		}
	}
}

function OpenWnd(string param)
{
	local string strStatus;

	ParseString(param, "Status", strStatus);
	// End:0x46
	if(strStatus == "Y")
	{
		m_hIngameNoticeWnd.ShowWindow();
		m_hIngameNoticeWnd.SetFocus();		
	}
	else
	{
		m_hBrowserViewer.HideWindow();
		m_hIngameNoticeWnd.HideWindow();
	}	
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{		
		case EV_WebBrowser_FinishedLoading:
			IsOpenWnd(param);
			break;
		//∞‘¿” Ω√¿€«“ ∂ß √÷√ 	
		case EV_GameStart:
			NavigateToPetitionPage();
			break;
		case EV_WebBrowser_NoticeOpenStatus:
			OpenWnd(param);
			// End:0x47
			break;
	}
}

/**
 * ¿©µµøÏ ESC ≈∞∑Œ ¥›±‚ √≥Æ 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_WindowName="IngameNoticeWnd"
}
