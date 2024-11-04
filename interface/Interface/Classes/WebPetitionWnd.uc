class WebPetitionWnd extends UICommonAPI;

var string m_WindowName;

var WindowHandle m_hPetitionWnd;
var WebBrowserHandle m_hBrowserViewer;
var EditBoxHandle ChatEditBox;

function OnRegisterEvent()
{
	RegisterEvent(EV_ShowWebPetitionMainPage);
	RegisterEvent(EV_ShowWebPetitionListPage);
}

function OnLoad()
{
	SetClosingOnESC(); 

	m_hPetitionWnd=GetWindowHandle(m_WindowName);
	m_hBrowserViewer=GetWebBrowserHandle(m_WindowName$".WebBrowser");


//	ChatEditBox = EditBoxHandle( GetHandle( "ChatWnd.ChatEditBox" )); COD-_-
	ChatEditBox = GetEditBoxHandle( "ChatWnd.ChatEditBox" );
}

function OnShow()
{
	m_hBrowserViewer.ShowWindow();
	if ( class'UIAPI_WINDOW'.static.IsShowWindow ( "IngameWebWnd") ) 
		class'UIAPI_WINDOW'.static.HideWindow( "IngameWebWnd");
}

function OnHide()
{
	m_hBrowserViewer.HideWindow();
}

function NavigateToPetitionPage()
{
	local string UserName;
	local int serverNo;
	local string lineage2PetitionURL, strNpLoginWebURL;
	local WebRequestInfo requestInfo;

	// 아래 사항들은 인게임 1:1 문의시에 해당 URL에서 필요한 정보들입니다.
	// 수정시엔 플랫폼팀에 문의하시기 바랍니다.
	if(GetINIString("URL", "L2InGameBrowserPetitionURL", lineage2PetitionURL, "l2.ini"))
	{
		// NPLoginWeb
		// 게임서버로부터 받은 session_id로 인증받던 WSM 기반 방식에서 Cligate를 통해 받은 AuthnToken 값으로 인증 받는 NP 기반 방식으로 변경 됨.
		if(GetINIString("URL", "NPLoginWebURL", strNpLoginWebURL, "l2.ini"))
		{
		////// Awesomium ver 1.6.6 사용 시. CEF 교체 후 삭제할 것. /////////////////////////////////
		/*	m_hBrowserViewer.WithWebSession();
			
			// default setting for in game browser petition 
			lineage2PetitionID = 32; // 고정된 값
			serverNo = GetServerNo();
			GetPlayerInfo( userinfo );
			
			// 캐릭터명만 URL Encoding.
			strURLEncoded = m_hBrowserViewer.GetURLEncodedAsUTF8( userinfo.Name );
			
			//strReturnURL = "http://mlogin.plaync.com/test/ingamesso";	// 개발망 테스트용 URL
			// sample: "gcsweblin2.plaync.com/home/main?target={petition_id}&server_id={server_num}&char_name={user_name}"
			strReturnURL = lineage2PetitionURL$"/"$additionalURL$"?"$"target="$lineage2PetitionID$"&"$"server_id="$serverNo$"&"$"char_name="$strURLEncoded;
	
			// parameter 포함 전체 경로 URL Encoding.
			strURLEncoded = m_hBrowserViewer.GetURLEncodedAsUTF8( strReturnURL );
	
			m_hBrowserViewer.PushParam( "return_url", strURLEncoded );
			
			// "/sso"는 NP 로그인웹의 토큰으로 로그인 요청 페이지.
			m_hBrowserViewer.NavigateAsGet( strNpLoginWebURL$"/sso" );*/
		////// Awesomium ver 1.6.6 사용 시. CEF 교체 후 삭제할 것. /////////////////////////////////
			
			// default setting for in game browser petition 
			serverNo = GetServerNo();
			UserName = GetPlayerRealName();

			requestInfo.eMethodType = EWMT_GET;
			requestInfo.strRequestUrl = lineage2PetitionURL;
			requestInfo.strNPAuthTokenLoginUrl = strNpLoginWebURL $ "/sso";
			requestInfo.arrRequestParams.Length = 6;
			requestInfo.arrRequestParams[0].strKey = "service";
			requestInfo.arrRequestParams[0].strValue = "lin2";
			requestInfo.arrRequestParams[1].strKey = "locale";
			requestInfo.arrRequestParams[1].strValue = "ko-KR";
			requestInfo.arrRequestParams[2].strKey = "sdk";
			requestInfo.arrRequestParams[2].strValue = "Lineage2Ingame";
			requestInfo.arrRequestParams[3].strKey = "hideTopBar";
			requestInfo.arrRequestParams[3].strValue = "true";
			requestInfo.arrRequestParams[4].bNeedUrlEncode = true;
			requestInfo.arrRequestParams[4].strKey = "characterName";
			requestInfo.arrRequestParams[4].strValue = UserName;
			requestInfo.arrRequestParams[5].strKey = "serverNo";
			requestInfo.arrRequestParams[5].strValue = string(serverNo);
			m_hBrowserViewer.Navigate(requestInfo);
		}
	}
}
function HandleShowWebPetitionMainPage()
{
	ChatEditBox.ReleaseFocus();

	//getInstanceChatWnd().setFocusInputEditBox();

	m_hPetitionWnd.ShowWindow();
	m_hPetitionWnd.SetFocus();
	
	// 메인 페이지
	NavigateToPetitionPage();
}

function HandleShowWebPetitionListPage()
{
	m_hPetitionWnd.ShowWindow();
	m_hPetitionWnd.SetFocus();
	
	// 문의 내역 페이지
	NavigateToPetitionPage();
}

function OnEvent(int Event_ID, String param)
{
	switch(Event_ID)
	{		
		case EV_ShowWebPetitionMainPage:
			HandleShowWebPetitionMainPage();
			break;
		
		case EV_ShowWebPetitionListPage:
			HandleShowWebPetitionListPage();
			break;
	}
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("WebPetitionWnd").HideWindow();
}

defaultproperties
{
     m_WindowName="WebPetitionWnd"
}
