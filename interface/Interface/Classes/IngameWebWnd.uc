class IngameWebWnd extends UICommonAPI;

var string							m_WindowName;

var WindowHandle			m_hIngameWebWnd;
var WebBrowserHandle	m_hBrowserViewer;
var WebBrowserHandle	m_hBrowserForSessionRefresh; // ���� ����

var bool				m_bCheckFinishPageForSession;
var String				m_strRequestURL;			// ��û�� ������ URL

const LINEAGE2_WEB_ID = 32;					// ������2 ������
const TIMER_ID_WEB_SESSION = 8989;			// �� ���� Ÿ�̸� ID
const INGAMEWEB_SECTION_CLASSIC = "IngameWeb_Classic"; // L2.INI �� Ŭ���Ŀ� �ΰ����� URL�� ���� �̸�
const INGAMEWEB_SECTION_LIVE = "IngameWeb_Live";		 // ������ ��� ���� ����.

// �� ���� ���� Ÿ��(40��) - 1�ð� ���� ������ ���������� ���������� 40������ ��.
// Aion�� 20��, ���� 50������ �Ѵٰ� ��. - y2jinc
const REFRESH_WEB_SESSION_TIME = 2400000;	// 1�ʰ� 1000 * 60 * 40 = 2400000 (40 ��)
//const REFRESH_WEB_SESSION_TIME = 5000;	// ���� ���� �׽�Ʈ�� 5�ʿ� �ϴ� �κ� (Ȯ�ν� �����Ƽ� �ּ����� ���ܳ���)

const Time_ID_Delay= 102234;

var string lastShowCategory;
var string Key;

function OnLoad()
{
	SetClosingOnESC();
	
	m_hIngameWebWnd = GetWindowHandle(m_WindowName);
	m_hBrowserViewer = GetWebBrowserHandle(m_WindowName$".WebBrowser");
	m_hBrowserForSessionRefresh = GetWebBrowserHandle(m_WindowName$".WebBrowserForSession");
	m_hBrowserForSessionRefresh.HideWindow();
	
	m_bCheckFinishPageForSession = FALSE;
}

function OnRegisterEvent()
{
	RegisterEvent(EV_WebBrowser_FinishedLoading);
	RegisterEvent(EV_InGameWebWnd_Info);
	//10140
	RegisterEvent(EV_GotoWorldRaidServer);	

	// Ÿ��Ʋ�� �ٲ������ ���� �̺�Ʈ - y2jinc
	RegisterEvent(EV_WebBrowser_ReceivedTitle);

	RegisterEvent(EV_WebBrowser_EventParam);
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_ResolutionChanged);
}

function OnSetFocus (WindowHandle a_WindowHandle, bool bFocused)
{
	if ( a_WindowHandle.GetWindowName() == m_WindowName && bFocused == True && !m_hBrowserViewer.IsFocused())
		m_hBrowserViewer.SetFocus();
}

function OnEvent(int Event_ID, String param)
{
	switch (Event_ID)
	{
		case EV_WebBrowser_FinishedLoading:
			OnWebBrowser_FinishedLoading(param);
			break;
		case EV_InGameWebWnd_Info:		
			if ( !getInstanceUIData().getIsArenaServer() )
				NavigatePage(param);
			break;
		// ���� ������ �̵� ��
		case EV_GotoWorldRaidServer:
			m_hIngameWebWnd.HideWindow();
			break;
		case EV_WebBrowser_ReceivedTitle:
			OnWebBrowser_ReceivedTitle(param);
			m_hIngameWebWnd.SetFocus();
			break;
		case EV_WebBrowser_EventParam:
			setWindowType(param);
			break;
		case EV_Restart :
			lastShowCategory = "";
			break;
		case EV_GameStart:
			//if ( getInstanceUIData().getIsClassicServer() )
			//	HandleOpenCategory("main");
			break;
		case EV_ResolutionChanged:
			checkWindowLoc();
			break;
	}
}

function HandleOpenCategory (string Category)
{
	local string strURL;

	if ( GetUrlPageAtL2INI(Category,strURL) )
	{
		lastShowCategory = Category;
		NavigateUrlPage(strURL);
	}
}

function setWindowType (string param)
{
	local int nW;
	local int nH;

	ParseString(param,"key", Key);

	SideBar(GetScript("SideBar")).ToggleByWindowName("NShopWnd", Key == "l2nshop");
	nW = 971;
	nH = 817;

	
	m_hIngameWebWnd.SetWindowSize(nW + 21, nH + 49);
	m_hBrowserViewer.SetWindowSize(nW, nH);
	m_hBrowserForSessionRefresh.SetWindowSize(nW, nH);
}


function NavigatePage(String param)
{
	local string category;
	local string message;

	parseString(param, "Category", category);
	parseString(param, "Message", message);

	if (category == "url")
	{
		NavigateUrlPage(message);
	}	
	else if (category == "test_url")
	{
		NavigateUrlPageWithoutNPToken(message);
	}
	else if (category == "check_session")
	{
		TestCheckSession();
	}
	else
	{
		// �˸� ��ư�̳� �޴����� ���� ���� �ִ� ī�װ��� �ٽ� ���⸦ ��û �ߴٸ� �������� ó��
		if (lastShowCategory == category && IsShowWindow("InGameWebWnd"))
		{
			HideWindow("InGameWebWnd");
			return;
		}
		HandleOpenCategory(category);

		// �ϴ� url ����� ī�װ� ������ ó���ϵ��� ������
		// ���� �۾� ���� �ϴٰ� ������ �ؾ��ϴ� ��찡 �����
		// else if �� ī�װ� ������ �б��ؾ� ��.
		/*if (GetUrlPageAtL2INI(category, strURL))
		{
			lastShowCategory = category;
			NavigateUrlPage(strURL);
		}*/
	}
}

////// Awesomium ver 1.6.6 ��� ��. CEF ��ü �� ������ ��. /////////////////////////////////
// sample: "gcsweblin2.plaync.com/home/main?target={petition_id}&server_id={server_num}&char_name={user_name}"
/*function String GetParameterForNPSession(String strURL)
{
	local UserInfo userinfo;
	local int serverNo;
	local int lineage2WebID;
	local string strReturnURL;
	local string strURLEncoded;

	local string strExtraParam;
	local int ParamIndex;	
	
	ParamIndex = InStr(strURL, "?");
	if (ParamIndex > 0)
	{
		// ? ���Ŀ� �Ķ���͸� ��´�.
		strExtraParam = Mid(strURL, ParamIndex+1);
	
		// ? ���Ŀ� ���� �Ķ���͸� �����ϰ� URL�� ��´�.
		strURL = Left(strURL, ParamIndex);	

		//debug("[InGameWebWnd]strURL="$strURL$" ExtraParam="$strExtraParam);
	}

	// default setting for in game browser petition 
	lineage2WebID = LINEAGE2_WEB_ID;
	serverNo = GetServerNo();
	GetPlayerInfo(userinfo);

	// ĳ���͸� URL Encoding.
	strURLEncoded = m_hBrowserViewer.GetURLEncodedAsUTF8(userinfo.Name);
	strReturnURL = strURL$"?"$"target="$lineage2WebID$"&"$"server_id="$serverNo$"&"$"char_name="$strURLEncoded;
	if (Len(strExtraParam) > 0 )
	{
		strReturnURL = strReturnURL$"&"$strExtraParam;
	}

	//debug("[InGameWebWnd]strReturnURL="$strReturnURL$"==================================");
	
	// parameter ���� ��ü ��� URL Encoding.
	strURLEncoded = m_hBrowserViewer.GetURLEncodedAsUTF8(strReturnURL);

	return strURLEncoded;
}*/
////// Awesomium ver 1.6.6 ��� ��. CEF ��ü �� ������ ��. /////////////////////////////////

// sample: "gcsweblin2.plaync.com/home/main?target={petition_id}&server_id={server_num}&char_name={user_name}"
function String GetParameterForNPSession(String strURL, out array<WebRequestParam> arrParams)
{
	local UserInfo userinfo;
	local int serverNo;
	local int lineage2WebID;

	local string strExtraParam;
	local int nStrIndex;
	local int nArrayIndex;
	local string strKey;
	local string strValue;
	
	nStrIndex = InStr(strURL, "?");
	if (nStrIndex > 0)
	{
		// ? ���Ŀ� �Ķ���͸� ��´�.
		strExtraParam = Mid(strURL, nStrIndex+1);
	
		// ? ���Ŀ� ���� �Ķ���͸� �����ϰ� URL�� ��´�.
		strURL = Left(strURL, nStrIndex);	

		//debug("[InGameWebWnd]strURL="$strURL$" ExtraParam="$strExtraParam);
	}

	// default setting for in game browser petition 
	lineage2WebID = LINEAGE2_WEB_ID;
	serverNo = GetServerNo();
	GetPlayerInfo(userinfo);
	
	nArrayIndex = arrParams.Length;
	
	arrParams.Insert(nArrayIndex, 1);
	arrParams[nArrayIndex].strKey = "target";
	arrParams[nArrayIndex].strValue = string(lineage2WebID);
	nArrayIndex++;
	
	arrParams.Insert(nArrayIndex, 1);
	arrParams[nArrayIndex].strKey = "server_id";
	arrParams[nArrayIndex].strValue = string(serverNo);
	nArrayIndex++;
	
	arrParams.Insert(nArrayIndex, 1);
	arrParams[nArrayIndex].bNeedUrlEncode = true;	// ĳ���͸� URL Encoding.
	arrParams[nArrayIndex].strKey = "char_name";
	arrParams[nArrayIndex].strValue = userinfo.Name;
	nArrayIndex++;
	
	if (Len(strExtraParam) > 0)
	{
		nStrIndex = InStr(strExtraParam, "=");
		while (nStrIndex > 0)
		{
			// '=' ���� ���ڿ�(key��)�� ��´�.
			strKey = Left(strExtraParam, nStrIndex);
			
			// '=' ���� ���ڿ��� '&' ���ڰ� �ִ��� �˻�.
			strExtraParam = Mid(strExtraParam, nStrIndex+1);
			nStrIndex = InStr(strExtraParam, "&");
			if (nStrIndex > 0 )
			{
				// '&' ���� ���� ���ڿ�(value��)�� ��´�.
				strValue = Left(strExtraParam, nStrIndex);
				strExtraParam = Mid(strExtraParam, nStrIndex+1);
			}
			else
			{
				// ������ ���ڿ��� value ������ �ִ´�.
				strValue = strExtraParam;
			}
			
			// parameter array�� �߰�.
			arrParams.Insert(nArrayIndex, 1);
			arrParams[nArrayIndex].strKey = strKey;
			arrParams[nArrayIndex].strValue = strValue;
			nArrayIndex++;
			
			nStrIndex = InStr(strExtraParam, "=");
		}
	}

	return strURL;
}

function CloseAnotherWebWnd()
{
	// todo : ���⼭ ������ �����ִ� NP ��ū���� ���� ������ ������ â���� �ݴ´�.
	// ����� ����â �̴�. -> ����â�� �㶧�� �ش� â�� ������ �Ѵ�. - y2jinc
}

function bool GetUrlPageAtL2INI(String category, out String outURL)
{
	local String strSection;

	// ���̺굵 ���ԵǸ� ���̺��϶��� ���� �̸� ���ؼ� ���� ��.
	if (getInstanceUIData().getIsClassicServer())
	{
		strSection = INGAMEWEB_SECTION_CLASSIC;
	}
	else 
	{
		strSection = INGAMEWEB_SECTION_LIVE;
	}
	
	if (GetINIString(strSection, category, outURL, "l2.ini"))
	{
		return true;
	}

	//debug("[InGameWebWnd] >> section :" @ strSection @ "category : " @ category @ "is not exist.(l2.ini)");

	return false;
}

// Ư�� URL�� NP ������ ���� ��ū ������ �޾� �� �� 
// �������� ��û �ϴ� �Լ�.
function NavigateUrlPage(String strURL)
{
//	local String strParameter;
	local String strNpLoginWebURL;
	local WebRequestInfo requestInfo;

	// ���� �̵� �� 
	if ( IsPlayerOnWorldRaidServer() ) 
	{
		getInstanceL2Util().showGfxScreenMessage( GetSystemMessage(4047));
		return;
	}

	m_hIngameWebWnd.ShowWindow();
	m_hIngameWebWnd.SetFocus();

	debug("[InGameWebWnd]NavigateUrlPage URL :" @ strURL);

	// ���Ӽ����κ��� ���� session_id�� �����޴� WSM ��� ��Ŀ��� Cligate�� ���� ���� AuthnToken ������ ���� �޴� NP ��� ������� ���� ��.
	if (GetINIString("URL", "NPLoginWebURL", strNpLoginWebURL, "l2.ini"))
	{
		CloseAnotherWebWnd();

	////// Awesomium ver 1.6.6 ��� ��. CEF ��ü �� ������ ��. /////////////////////////////////
	/*	m_hBrowserViewer.BeginParam("");

		m_bCheckFinishPageForSession = TRUE; // ���� ���� �����ؼ� �ʿ��� �÷���.
		m_hIngameWebWnd.KillTimer(TIMER_ID_WEB_SESSION);
		m_hBrowserViewer.WithWebSession();	 // NP �� ���� ���� ������ �ޱ����ؼ��� �ش� �Լ��� �ҷ���� ��.

		// �Ʒ� parameter ������ �ᱹ strNpLoginWebURL$strParameter �������� �������� ��û �ϰ� ��.
		strParameter = GetParameterForNPSession(strURL);
		m_hBrowserViewer.PushParam("return_url", strParameter);

		// "/sso"�� NP �α������� ��ū���� �α��� ��û ������.
		m_hBrowserViewer.NavigateAsGet(strNpLoginWebURL$"/sso");*/
	////// Awesomium ver 1.6.6 ��� ��. CEF ��ü �� ������ ��. /////////////////////////////////
	
		m_bCheckFinishPageForSession = TRUE; // ���� ���� �����ؼ� �ʿ��� �÷���.
		m_hIngameWebWnd.KillTimer(TIMER_ID_WEB_SESSION);
	
		requestInfo.eMethodType = EWMT_GET;
		requestInfo.strRequestUrl = GetParameterForNPSession(strURL, requestInfo.arrRequestParams);
		requestInfo.strNPAuthTokenLoginUrl = strNpLoginWebURL $ "/sso";
		requestInfo.arrHeaderParams.Length = 1;
		requestInfo.arrHeaderParams[0].strKey = "User-Agent";
		requestInfo.arrHeaderParams[0].strValue = "Lineage2";
		
		m_hBrowserViewer.Navigate(requestInfo);

		m_strRequestURL = strURL;
	}
}

// Ư�� URL�� NP ������ ���� ��ū ������ �޾� �� �ʿ� ���� 
// �������� ��û �ϴ� �Լ�. - �׽�Ʈ �뵵�� ���� - y2jinc
function NavigateUrlPageWithoutNPToken(String strURL)
{
	local WebRequestInfo requestInfo;
	
	m_hIngameWebWnd.ShowWindow();

	debug("[InGameWebWnd]NavigateUrlPageWithoutNPToken URL :" @ strURL);	
	
////// Awesomium ver 1.6.6 ��� ��. CEF ��ü �� ������ ��. /////////////////////////////////
/*	m_hBrowserViewer.WithoutWebSession();
	m_hBrowserViewer.BeginParam("");	

	m_hBrowserViewer.NavigateAsGet(strURL);*/
////// Awesomium ver 1.6.6 ��� ��. CEF ��ü �� ������ ��. /////////////////////////////////
	
	requestInfo.eMethodType = EWMT_GET;
	requestInfo.strRequestUrl = strURL;
	
	// �׽�Ʈ ������������ User-Agent �� ���� ����� �׽�Ʈ �� �� �ֵ��� �߰��� ��.
	requestInfo.arrHeaderParams.Length = 1;
	requestInfo.arrHeaderParams[0].strKey = "User-Agent";
	requestInfo.arrHeaderParams[0].strValue = "Lineage2";
	
	m_hBrowserViewer.Navigate(requestInfo);
	
	m_strRequestURL = strURL;
}

// ���� ���� Ȯ��.(���߸��� ����)
function bool TestCheckSession()
{
	local WebRequestInfo requestInfo;

////// Awesomium ver 1.6.6 ��� ��. CEF ��ü �� ������ ��. /////////////////////////////////
/*	m_hBrowserViewer.BeginParam("");
	m_hBrowserViewer.WithoutWebSession();
	m_hBrowserViewer.NavigateAsGet("http://mlogin.plaync.com/test/ingamesso");*/
////// Awesomium ver 1.6.6 ��� ��. CEF ��ü �� ������ ��. /////////////////////////////////
	
	requestInfo.eMethodType = EWMT_GET;
	requestInfo.strRequestUrl = "http://dev.mlogin.plaync.com/test/ingamesso";
	
	m_hBrowserViewer.Navigate(requestInfo);

	debug("[InGameWebWnd]TestCheckSession");
	return true;
}


// ���ǿ��� �ϱ�(1 �ð� ���� �ȴ�)
function bool RefreshWebSession()
{
	local String strNpLoginWebURL;
	local WebRequestInfo requestInfo;

	if (GetINIString("URL", "NPLoginWebURL", strNpLoginWebURL, "l2.ini"))
	{
	////// Awesomium ver 1.6.6 ��� ��. CEF ��ü �� ������ ��. /////////////////////////////////
	/*	m_hBrowserForSessionRefresh.BeginParam("");
		m_hBrowserForSessionRefresh.WithoutWebSession();	// NP�κ��� ���� ������ ���� �ʿ� ������ �θ�.		
		m_hBrowserForSessionRefresh.NavigateAsGetJson(strNpLoginWebURL$"/check"$"?return_url=about:blank");*/
	////// Awesomium ver 1.6.6 ��� ��. CEF ��ü �� ������ ��. /////////////////////////////////
		
		requestInfo.eMethodType = EWMT_GET;
		requestInfo.strRequestUrl = strNpLoginWebURL$"/check";
		requestInfo.arrRequestParams.Length = 1;
		requestInfo.arrRequestParams[0].strKey = "return_url";
		requestInfo.arrRequestParams[0].strValue = "about:blank";
		requestInfo.arrHeaderParams.Length = 1;
		requestInfo.arrHeaderParams[0].strKey = "Accept";
		requestInfo.arrHeaderParams[0].strValue = "application/json";
		
		m_hBrowserForSessionRefresh.Navigate(requestInfo);
	}

	debug("[InGameWebWnd]RefreshWebSession");
	return true;
}

function OnHide()
{
	m_hIngameWebWnd.KillTimer(TIMER_ID_WEB_SESSION);
	m_bCheckFinishPageForSession = FALSE;

	lastShowCategory = "";

////// Awesomium ver 1.6.6 ��� ��. CEF ��ü �� ������ ��. /////////////////////////////////
/*	// ���� �� �ʱ�ȭ �������� �� ������ �ҷ��ش�.
	m_hBrowserViewer.BeginParam("");
	m_hBrowserViewer.WithoutWebSession();	
	m_hBrowserViewer.NavigateAsGet("about:blank");*/
////// Awesomium ver 1.6.6 ��� ��. CEF ��ü �� ������ ��. /////////////////////////////////
	
	m_hBrowserViewer.HideWindow();
	m_hBrowserForSessionRefresh.HideWindow();
	SideBar(GetScript("SideBar")).ToggleByWindowName("NShopWnd",False);
}

function OnTimer(int TimerID)
{
	if (TimerID == TIMER_ID_WEB_SESSION)
	{
		RefreshWebSession();
		m_hIngameWebWnd.KillTimer(TIMER_ID_WEB_SESSION);
		m_hIngameWebWnd.SetTimer(TIMER_ID_WEB_SESSION, REFRESH_WEB_SESSION_TIME);
	}
}

function OnWebBrowser_FinishedLoading(String param)
{
	local string url;
	local String strNpLoginWebURL;
	local int Index;

	ParseString(param, "url", url);

	// ���� ���� ó�� ����
	// url �� �α��� ��û �������� ���� ������ ���� �ѰŴ�.
	if (m_bCheckFinishPageForSession && GetINIString("URL", "NPLoginWebURL", strNpLoginWebURL, "l2.ini"))
	{
		Index = InStr(url, m_strRequestURL);
		if (Index >= 0)
		{
			m_hIngameWebWnd.KillTimer(TIMER_ID_WEB_SESSION);
			m_hIngameWebWnd.SetTimer(TIMER_ID_WEB_SESSION, REFRESH_WEB_SESSION_TIME);
			m_bCheckFinishPageForSession = FALSE;
		}	
	}

	debug("[InGameWebWnd]EV_WebBrowser_FinishedLoading >> " @ url @ m_bCheckFinishPageForSession);
	debug("[InGameWebWnd]EV_WebBrowser_FinishedLoading >> GetURL" @ m_hBrowserViewer.GetUrl());
}

function OnWebBrowser_ReceivedTitle(string param)
{
	local string WindowName;
	local string Title;

	ParseString(param, "WindowName", WindowName);
	ParseString(param, "Title", Title);

	if(InStr(WindowName, "IngameWebWnd") >= 0 && Len(Title) > 0)
	{
		setWindowTitleByString(Title);
	}
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( m_WindowName ).HideWindow();

	Debug("m_WindowName>>>>>>" @ m_WindowName);
}

function onShow()
{	
	if ( class'UIAPI_WINDOW'.static.IsShowWindow ( "WebPetitionWnd") ) 
		class'UIAPI_WINDOW'.static.HideWindow( "WebPetitionWnd");
		
	m_hBrowserViewer.ShowWindow();
	checkWindowLoc();
}

function OnDefaultPosition ()
{
	checkWindowLoc();
}

function checkWindowLoc ()
{
	local Rect R;

	R = GetWindowHandle("IngameWebWnd").GetRect();
	if ( getInstanceUIData().getScreenWidth() != 0 && getInstanceUIData().getScreenHeight() != 0 )
	{
		if ( R.nX + R.nWidth > getInstanceUIData().getScreenWidth() )
		{
			R.nX = getInstanceUIData().getScreenWidth() - R.nWidth;
		}
		if ( R.nY < 0 )
		{
			R.nY = 0;
		}
		GetWindowHandle("IngameWebWnd").MoveC(R.nX,R.nY);
	}
}

defaultproperties
{
     m_WindowName="IngameWebWnd"
}
