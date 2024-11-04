class SystemMenuWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle m_hOptionWnd;
var WindowHandle m_hUserPetitionWnd;
var WindowHandle m_hNewUserPetitionWnd;
var WindowHandle m_hMovieCaptureWnd;//ldw ������ ĸ�������� 
var WindowHandle m_hArchiveViewWnd;//ldw �ڹ��� ������
var WindowHandle m_hMovieCaptureWnd_Expand;
var WindowHandle PostBoxWnd;
var TextBoxHandle m_hTbBBS;
var TextBoxHandle m_hTbMacro;

var int IsPeaceZone;		//���� ���� PeaceZone�ΰ�

const DIALOGID_Gohome = 0;

function OnRegisterEvent()
{
	RegisterEvent( EV_LanguageChanged );
	RegisterEvent( EV_SetRadarZoneCode );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
}

function OnLoad()
{
	SetClosingOnESC();

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		
		m_hArchiveViewWnd=GetHandle("ArchiveViewWnd");//ldw �ڹ��� ������
		m_hMovieCaptureWnd=GetHandle("MovieCaptureWnd");//ldw ������ ĸ��
		m_hMovieCaptureWnd_Expand = GetHandle("MovieCaptureWnd_Expand");//ldw ������ ĸ��
		m_hOptionWnd=GetHandle("OptionWnd");
		m_hUserPetitionWnd=GetHandle("UserPetitionWnd");
		m_hNewUserPetitionWnd=GetHandle("NewUserPetitionWnd");
		m_hTbBBS=TextBoxHandle(GetHandle("SystemMenuWnd.txtBBS"));
		m_hTbMacro=TextBoxHandle(GetHandle("SystemMenuWnd.txtMacro"));
		PostBoxWnd=GetHandle("PostBoxWnd");
	}
	else
	{
		m_hArchiveViewWnd=GetWindowHandle("ArchiveViewWnd");//ldw �ڹ��� ������
		m_hMovieCaptureWnd=GetWindowHandle("MovieCaptureWnd");//ldw ������ ĸ��
		m_hMovieCaptureWnd_Expand = GetWindowHandle("MovieCaptureWnd_Expand");//ldw ������ ĸ��
		m_hOptionWnd=GetWindowHandle("OptionWnd");
		m_hUserPetitionWnd=GetWindowHandle("UserPetitionWnd");
		m_hNewUserPetitionWnd=GetWindowHandle("NewUserPetitionWnd");
		m_hTbBBS=GetTextBoxHandle("SystemMenuWnd.txtBBS");
		m_hTbMacro=GetTextBoxHandle("SystemMenuWnd.txtMacro");
		PostBoxWnd=GetWindowHandle("PostBoxWnd");
	}

	SetMenuString();
}

function OnClickButton( string strID )
{
	switch( strID )
	{


	case "btnArchive":
		HandlebtnArchive();
		break;
	case "btnPersonalConnections":	
		HandlePersonalConnectionsWnd();
		break;
	case "btnPost":
		HandleShowPostBoxWnd();
		break;
	case "btnBBS":
		HandleShowBoardWnd();
		break;
	case "btnMacro":
		HandleShowMacroListWnd();
		break;
	case "btnMovieCapture"://ldw ������ ĸ��
		//Debug("MovieCapture button Clicked");
		HandleShowMovieCaptureWnd();
		break;
	case "btnHelpHtml":
		HandleShowHelpHtmlWnd();
		break;
	case "btnPetition":
		HandleShowPetitionBegin();
		break;
	case "btnOption":
		HandleShowOptionWnd();
		break;
	//Ȩ������ ��ũ(10.1.18 ������ �߰�)
	case "btnHomepage":
		linkHomePage();
		break;
	//
	case "btnRestart":
		ExecuteEvent(EV_OpenDialogRestart);
		break;
	case "btnQuit":
		ExecuteEvent(EV_OpenDialogQuit);
		break;
	}
}

function HandlebtnArchive(){
	/*if (m_hArchiveViewWnd.IsShowWindow())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		m_hArchiveViewWnd.HideWindow();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		ExecuteEvent(EV_StatisticWndshow);
		//m_hArchiveViewWnd.ShowWindow();
		//m_hArchiveViewWnd.SetFocus();
	}*/
	Debug("HandlebtnArchive button clicked");
	ExecuteEvent(EV_StatisticWndshow);
}

function OnEvent(int Event_ID, String param)
{
	local int zonetype;
	if( Event_ID == EV_LanguageChanged )
	{
		SetMenuString();
	}
	else if ( Event_ID == EV_SetRadarZoneCode )
	{
		ParseInt( param, "ZoneCode", zonetype );		
		if (zonetype == 12)
		{
			IsPeaceZone = 1;
		}
		else
		{
			IsPeaceZone = 0;
		}
	}
	else if( Event_ID == EV_DialogOK )
	{
		HandleDialogOK();
	}
	else if( Event_ID == EV_DialogCancel )
	{
		
	}
}

// �͸ư��� �ý��� ���� 
function HandlePersonalConnectionsWnd ()
{
	if( GetWindowHandle("PersonalConnectionsWnd").isShowWindow())
	{
		GetWindowHandle("PersonalConnectionsWnd").HideWindow();
	}
	else
	{
		GetWindowHandle("PersonalConnectionsWnd").ShowWindow();
		GetWindowHandle("PersonalConnectionsWnd").SetFocus();
	}
	
}

//Ȩ������ ��ũ(10.1.18 ������ �߰�)

function linkHomePage()
{
	DialogSetID( DIALOGID_Gohome);
	DialogShow( DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage( 3208 ), string(Self));
}

function HandleDialogOK()
{
	if( !DialogIsMine())
		return;

	switch( DialogGetID())
	{
	case DIALOGID_Gohome:
		OpenL2Home();
		break;
	}
}

function HandleShowPostBoxWnd()
{
	if( PostBoxWnd.isShowWindow())
	{
		PostBoxWnd.HideWindow();
	}
	else
	{
		RequestRequestReceivedPostList();
		if (IsPeaceZone == 0)
			AddSystemMessage(3066);
	}
}


function HandleShowBoardWnd()
{
	local string strParam;
	ParamAdd(strParam, "Init", "1");
	ExecuteEvent(EV_ShowBBS, strParam);
}

function HandleShowHelpHtmlWnd()
{
	local  AgeWnd script1;	// ���ǥ�� ��ũ��Ʈ ��������
	
	local string strParam;
	ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "help.htm");
	ExecuteEvent(EV_ShowHelp, strParam);
	
	script1 = AgeWnd( GetScript("AgeWnd") );
	
	if(script1.bBlock == false)	script1.startAge();	//���ǥ�ø� ���ش�. 
}

function HandleShowMacroListWnd()
{
	ExecuteEvent(EV_MacroShowListWnd);
}


function HandleShowMovieCaptureWnd()//ldw ������ ĸ�� ������ ����
{
	local bool tmpBool;
	/*local  MovieCaptureWnd  script;	
	script = MovieCaptureWnd( GetScript( "MovieCaptureWnd" ) );	
	tmpBool = script.IsCapturingFlag;		
	Debug("IsCapturingFlag = "$script.IsCapturingFlag);*/
	tmpBool =IsNowMovieCapturing();

	if(tmpBool){//ldw ���ĸ� �ǰ� �ִٸ�
		m_hMovieCaptureWnd.HideWindow();//Ȥ�� �𸣴� ���� ����.
		if (m_hMovieCaptureWnd_Expand.IsShowWindow()){//Ȯ�� â�� ���� ���ٸ�
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			m_hMovieCaptureWnd_Expand.HideWindow();
		} else {			
			PlayConsoleSound(IFST_WINDOW_OPEN);
			m_hMovieCaptureWnd_Expand.ShowWindow();
			m_hMovieCaptureWnd_Expand.SetFocus();
		}
	} else {//�ƴ϶�� �Ϲ� â ���� �ݱ�
		if (m_hMovieCaptureWnd.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			m_hMovieCaptureWnd.HideWindow();
		} else{	
			PlayConsoleSound(IFST_WINDOW_OPEN);
			m_hMovieCaptureWnd.ShowWindow();
			m_hMovieCaptureWnd.SetFocus();
		}
	}	
}


function HandleShowPetitionBegin()
{
	local WindowHandle win;	
	local WindowHandle win1;	
	local WindowHandle win2;	
	local PetitionMethod useNewPetition;

	win = GetWindowHandle( "NewUserPetitionWnd" );
	win1 = GetWindowHandle( "UserPetitionWnd" );
	win2 = GetWindowHandle( "WebPetitionWnd" );

	useNewPetition = GetPetitionMethod();

	if( useNewPetition == PetitionMethod_New )
	{
		if(win.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			RequestShowPetitionAsMethod();
		}
	}
	else if( useNewPetition == PetitionMethod_Default )
	{
		if (win1.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win1.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			win1.ShowWindow();
			win1.SetFocus();
		}
	}
	else if( useNewPetition == PetitionMethod_Web )
	{
		if (win2.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win2.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			RequestShowPetitionAsMethod();
		}
	}
}


function HandleShowOptionWnd()
{
	if (m_hOptionWnd.IsShowWindow())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		m_hOptionWnd.HideWindow();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		m_hOptionWnd.ShowWindow();
		m_hOptionWnd.SetFocus();
	}
}

function SetMenuString()
{
	//����Ű �ٿ��ֱ�
	m_hTbBBS.SetText(GetSystemString(387) $ "(Alt+B)");
	m_hTbMacro.SetText(GetSystemString(711) $ "(Alt+R)");
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( m_WindowName ).HideWindow();
}

defaultproperties
{
     m_WindowName="SystemMenuWnd"
}
