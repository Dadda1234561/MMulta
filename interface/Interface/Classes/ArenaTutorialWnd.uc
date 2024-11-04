class ArenaTutorialWnd extends UICommonAPI;


var string m_WindowName;

var WindowHandle	m_hNPCDialogViewPortWnd;
var WindowHandle    m_hViewPortWndArena;
var HtmlHandle		m_hHtmlViewer;
var ViewPortWndArena     m_hViewPortWndArenaScript;

//var bool	m_bRecievedCloseUI;
//var bool	m_bNpcZoomMode;

//var Vector locPosition;

//const TIMER_UPDATE_LOC = 0 ;
//const TIMER_UPDATEDELAY = 10 ;

function OnRegisterEvent()
{
	//RegisterEvent(EV_NPCDialogWndShow);
	//RegisterEvent(EV_NPCDialogWndHide);
	//RegisterEvent(EV_NPCDialogWndLoadHtmlFromString);
	//RegisterEvent(EV_QuestIDWndLoadHtmlFromString);

	RegisterEvent(EV_HtmlWithNPCViewport);
	RegisterEvent(EV_HtmlWithNPCViewportClose);

	RegisterEvent(EV_NpcStrWithNPCViewport);
	RegisterEvent(EV_NpcStrWithNPCViewportClose);

	//RegisterEvent(EV_Test_3);

	// register gamingstate enter/exit event 
	// - 등록하지 않으면, 처음 호출될때 OnEnter와 OnExit가 호출되지 않음.
	//RegisterEvent(EV_GamingStateEnter);
	//RegisterEvent(EV_GamingStateExit);	
}

function OnLoad()
{
	SetClosingOnESC();
	
	m_hNPCDialogViewPortWnd=GetWindowHandle(m_WindowName);
	m_hHtmlViewer=GetHtmlHandle(m_WindowName$".HtmlViewer");
	m_hViewPortWndArena = GetWindowHandle("ViewPortWndArena");
	m_hViewPortWndArenaScript = ViewPortWndArena( GetScript( "ViewPortWndArena"));
}


function OnSetFocus ( WindowHandle a_WindowHandle, bool isFocused ) 
{	
	if ( isFocused )  m_hViewPortWndArena.BringToFront();
}

function onShow()
{	
	//getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(Self)), "QuestHTMLWnd,m_hNPCDialogViewPortWnd");
	// 멀티셀이 열려 있다면 닫는다.
	//if(GetWindowHandle("MultiSellWnd").IsShowWindow()) GetWindowHandle("MultiSellWnd").HideWindow();	
}

function OnHide()
{
	//ProcCloseNPCDialogWnd();
	//getInstanceL2Util().syncWindowLocAuto("QuestHTMLWnd,m_hNPCDialogViewPortWnd");
	m_hViewPortWndArena.HideWindow();
	m_hViewPortWndArena.ClearAnchor();	

//	m_hNPCDialogViewPortWnd.KillTimer(TIMER_UPDATE_LOC);	
}


function OnEvent(int Event_ID, String param)
{
	//Debug( "OnEvent" @ Event_ID @ param );
	switch(Event_ID)
	{
	//case EV_NPCDialogWndShow :
	//	ShowNPCDialogWnd();
	//	break;
		
	//case EV_NPCDialogWndHide :
	//	HideNPCDialogWnd();
	//	break;
		
	//case EV_NPCDialogWndLoadHtmlFromString :
	//	m_hNPCDialogViewPortWnd.SetWindowTitle(GetSystemString(444));	 //타이틀을 "대화"로 바꿔준다. 
	//	HandleLoadHtmlFromString(param);
	//	break;
	//case EV_QuestIDWndLoadHtmlFromString:
	//	m_hNPCDialogViewPortWnd.HideWindow();
	//	break;
	case EV_HtmlWithNPCViewportClose    :
	case EV_NpcStrWithNPCViewportClose  : 
		m_hNPCDialogViewPortWnd.HideWindow();
		break;
	case EV_HtmlWithNPCViewport :
		handleHtmlViewPort (param);
		//Debug ( param ) ;
		break;
	case EV_NpcStrWithNPCViewport :
		handleMessageWithViewPort ( param ) ;
		//Debug ( param ) ;
		break;
	}
}


function handleMessageWithViewPort ( string param ) 
{
	local int stringID, ID, Show, SocialAnim, AttackAnim  ;
	local string npcString ;

	ParseInt ( param, "ID", ID );
	parseInt ( param, "NpcStringID", stringID ) ;
	npcString = GetNpcString ( stringID );

	if ( ID == -1 ) 
		m_hNPCDialogViewPortWnd.HideWindow();

	ParseInt ( param, "Show", Show );

	//ShowWindowWithFocus(m_WindowName);
	m_hViewPortWndArenaScript.SetNPCViewportData( ID ) ;
	
	if ( Show == 1 ) 
	{
		m_hViewPortWndArenaScript.SpawnNPC();
		m_hViewPortWndArenaScript.ShowNPC( 0.1f);
	}

	getInstanceL2Util().showGfxScreenMessage ( npcString, 5 ) ;
	//CallGFxFunction ( "GfxScreenMessageBG" , "showNPCStringBG", "");

	//Debug ("handleMessageWithViewPort" @  npcString ) ;

	ParseInt ( param, "AttackAnim", AttackAnim );
	ParseInt ( param, "SocialAnim", SocialAnim );

	//m_hViewPortWndArena.ClearAnchor();
	m_hViewPortWndArena.ShowWindow();
	//m_hViewPortWndArena.SetAnchor( "", "BottomCenter", "BottomCenter", 350, -40 );
	m_hViewPortWndArena.SetAnchor( "", "BottomCenter", "BottomCenter", 350, -28 );
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop("ViewPortWndArena", true );

	m_hViewPortWndArena.BringToFront() ;	
	
	if ( AttackAnim > -1 )  m_hViewPortWndArenaScript.PlayAnimation( AttackAnim ) ;
	else if ( SocialAnim > -1 ) m_hViewPortWndArenaScript.PlayAnimation( SocialAnim ) ;


}

function handleHtmlViewPort ( string param ) 
{		
	local int ID, Show, SocialAnim, AttackAnim ;
	local string htmlStr ;

	ParseInt ( param, "ID", ID );

	if ( ID == -1 ) 
		m_hNPCDialogViewPortWnd.HideWindow();

	ParseInt ( param, "Show", Show );	
	ParseString ( param, "HtmlStr", htmlStr );
	loadHtml( htmlStr ) ;

	ShowWindowWithFocus(m_WindowName);

	m_hViewPortWndArenaScript.SetNPCViewportData( ID ) ;
	
	if ( Show == 1 ) 
	{
		m_hViewPortWndArenaScript.SpawnNPC();
		m_hViewPortWndArenaScript.ShowNPC( 0.1f);
	}

	ParseInt ( param, "AttackAnim", AttackAnim );
	ParseInt ( param, "SocialAnim", SocialAnim );

	m_hViewPortWndArena.ShowWindow();
	m_hViewPortWndArena.SetAnchor( m_WindowName, "CenterRight", "CenterLeft", 0, 0 );
	//m_hViewPortWndArenaScript.
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop("ViewPortWndArena", false );
	m_hViewPortWndArena.BringToFront();	
	
	if ( AttackAnim > -1 )  m_hViewPortWndArenaScript.PlayAnimation( AttackAnim ) ;
	else if ( SocialAnim > -1 ) m_hViewPortWndArenaScript.PlayAnimation( SocialAnim ) ;
}

//function OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle)
//{
//	if(a_HtmlHandle==m_hHtmlViewer)	
//		m_hNPCDialogViewPortWnd.HideWindow();		
//}

//function HandleLoadHtmlFromString(string param)
//{
//	local string htmlString;
//	ParseString(param, "HTMLString", htmlString);

//	m_hHtmlViewer.LoadHtmlFromString(htmlString);
//}

/******************************************************************************************************************************
 * desc를 불러 오는 곳
 * ****************************************************************************************************************************/
function loadHtml ( string param )
{	
	m_hHtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(param));
	m_hNPCDialogViewPortWnd.SetFocus();
}

function string htmlSetHtmlStart(string targetHtml)
{
	return "<html><body>" $ targetHtml $ "</body></html>";
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{	
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hNPCDialogViewPortWnd.HideWindow();	
}

defaultproperties
{
     m_WindowName="ArenaTutorialWnd"
}
