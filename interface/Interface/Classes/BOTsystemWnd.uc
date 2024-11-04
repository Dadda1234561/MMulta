/**
 *   
 *   VOT �Ű� �ý���
 *   
 **/
class BOTsystemWnd extends UICommonAPI;

const TIMER_ID      = 1234;
CONST TIMER_DELAY   = 5000;
const TIMER_ID2     = 12345;
CONST TIMER_DELAY2  = 1000;

const DIALOG_ID     = 1234;

const INPUT_MAX = 6;

var ButtonHandle  Help_Button;
var ButtonHandle  btnOk;
var ButtonHandle  Refresh_Button;

var ButtonHandle  btnKey1;
var ButtonHandle  btnKey2;
var ButtonHandle  btnKey3;
var ButtonHandle  btnKey4;
var ButtonHandle  btnKey5;
var ButtonHandle  btnKey6;
var ButtonHandle  btnKey7;
var ButtonHandle  btnKey8;
var ButtonHandle  btnKey9;
var ButtonHandle  btnKey0;
var ButtonHandle  btnKeyClear;
var ButtonHandle  btnKeyBack;

var TextBoxHandle Notice_textBox;
var TextBoxHandle InputTime_textBox;
var TextBoxHandle InputCaptcha_textBox;

var textureHandle CaptchaImg_texture;
var WindowHandle  Me;

var int64 TransactionID ;
var int TryCount  ;
var int RemainTime;


var array<int>    keyArray;

var L2Util        util;

function Initialize()
{
	Me = GetWindowHandle( "BOTsystemWnd" );
	
	Notice_textBox = GetTextBoxHandle( "BOTsystemWnd.Notice_textBox" );

	Help_Button = GetButtonHandle( "BOTsystemWnd.Help_Button" );
	btnOk = GetButtonHandle( "BOTsystemWnd.btnOk" );		
	Refresh_Button = GetButtonHandle( "BOTsystemWnd.Refresh_Button" );

	btnKey1 = GetButtonHandle( "BOTsystemWnd.btnKey1" );
	btnKey2 = GetButtonHandle( "BOTsystemWnd.btnKey2" );
	btnKey3 = GetButtonHandle( "BOTsystemWnd.btnKey3" );
	btnKey4 = GetButtonHandle( "BOTsystemWnd.btnKey4" );
	btnKey5 = GetButtonHandle( "BOTsystemWnd.btnKey5" );
	btnKey6 = GetButtonHandle( "BOTsystemWnd.btnKey6" );
	btnKey7 = GetButtonHandle( "BOTsystemWnd.btnKey7" );
	btnKey8 = GetButtonHandle( "BOTsystemWnd.btnKey8" );
	btnKey9 = GetButtonHandle( "BOTsystemWnd.btnKey9" );
	btnKey0 = GetButtonHandle( "BOTsystemWnd.btnKey0" );
	btnKeyClear = GetButtonHandle( "BOTsystemWnd.btnKeyClear" );
	btnKeyBack = GetButtonHandle( "BOTsystemWnd.btnKeyBack" );

	CaptchaImg_texture = GetTextureHandle ( "BOTsystemWnd.CaptchaImg_texture" );

	InputCaptcha_textBox = GetTextBoxHandle ( "BOTsystemWnd.InputCaptcha_textBox" );

	InputTime_textBox = GetTextBoxHandle ( "BOTsystemWnd.InputTime_textBox" );	

	//CaptchaImg_texture = GetTextBoxHandle ( "BOTsystemWnd.Notice_textBox" );	
}

function onShow () 
{
//	Debug ( "botSystem onShow");
	makeRandomPasswordButton();
	InputCaptcha_textBox.SetText ( "" );
	btnOk.SetEnable( false ) ;
	setDefaultPosistionOnShow();
}

//TT 69399 ĸ���� ���� �� ���� �⺻ ��ġ�� �̵�	.
function setDefaultPosistionOnShow()
{
	local int currentScreenWidth, currentScreenHeight;
	local Rect rectWnd;

	GetCurrentResolution (currentScreenWidth, currentScreenHeight);
	rectWnd = Me.GetRect();
	Me.MoveTo( 10 , currentScreenHeight - 341 - rectWnd.nHeight );		
}

function onLoad()
{
	Initialize();

	util = L2Util(GetScript("L2Util"));

	Notice_textBox.SetText( GetSystemMessage ( 6803 ));	
//	Debug ( "botsystem onLoad");
}

/** ��ȣ ��ư ���� ��ġ */
function makeRandomPasswordButton ()
{
	local int i;
	
	// 0~ 9 ���� ��ȣ ����
	for(i = 0; i < 10; i++) keyArray[i] = i;

	// �迭 ����
	util.arrayShuffleInt(keyArray);

	// ��ȣ ��ư ��ġ (0 ~ 9 ��ư)
	for(i = 0; i < 10; i++) GetButtonHandle("BOTsystemWnd.btnKey" $ i).SetTexture("L2UI_CT1.Button.Botsystem_DF_Key" $ keyArray[i],
																				  "L2UI_CT1.Button.Botsystem_DF_Key" $ keyArray[i],
																				  "L2UI_CT1.Button.Botsystem_DF_Key" $ keyArray[i] $ "_over");
}


function onHide() 
{		
	//Me.KillTimer( TIMER_ID );		
	Me.KillTimer( TIMER_ID2 );	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ��ư Ŭ�� �̺�Ʈ 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnClickButton( string Name )
{
	// Debug("click " @ Name);
	switch( Name )
	{
	case "Refresh_Button"      : handleRefreshCaptchImage(); break;
	case "Help_Button"         : helpClick();           break;
	case "btnOk"               : tryPasswordCheck();    break;		

	case "btnKey1":
	case "btnKey2":
	case "btnKey3":
	case "btnKey4":
	case "btnKey5":
	case "btnKey6":
	case "btnKey7":
	case "btnKey8":
	case "btnKey9":
	case "btnKey0":
	case "btnKeyClear":
	case "btnKeyBack":
		 passwordKeyBoardClick(Name);
		 break;
	}
}

/** ��ȣ �Է� */
function tryPasswordCheck ()
{	
	RequestCaptchaAnswer ( TransactionID, int ( InputCaptcha_textBox.GetText() ) );
	InputCaptcha_textBox.SetText ( "" );
	btnOk.SetEnable( false ) ;
}

/** ���� ��ư Ŭ�� */
function helpClick()
{
	local string strParam;

	ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "antibot_help001.htm");
	ExecuteEvent(EV_ShowHelp, strParam);
}

/** �������� */
function handleRefreshCaptchImage()
{
	RequestRefreshCaptchaImage ( TransactionID );
	//5�ʰ� �������� ����
	Me.SetTimer ( TIMER_ID , TIMER_DELAY );
	Refresh_Button.SetEnable ( false );	
	InputCaptcha_textBox.SetText ( "" );
	btnOk.SetEnable( false ) ;
}

function OnTimer(int TimerID)
{
	switch ( TimerID ) 
	{
	case TIMER_ID:
		Refresh_Button.SetEnable( true ) ;
		break;
	case TIMER_ID2:
		refreshTime ();
		break;
	}
}


function refreshTime () 
{	
	InputTime_textBox.SetText ( i2s ( RemainTime / 60 ) @ ":" @ i2s ( RemainTime % 60 ) );	
	 
	if ( RemainTime == 0 ) Me.KillTimer( TIMER_ID2 );

	RemainTime --;
}

function string i2s ( int num ) 
{
	if ( num < 10 )  
	{
		return "0"$num;
	} 
	else 
	{
		return string (num) ;
	}
}


/** ���콺�� Ŭ�� �Ͽ� ��ȣ �Է�(���콺 Ŭ���� ����) */
function passwordKeyBoardClick(string Name)
{
	local string inputNumChar;
	local string tempStr;

	if (Name == "btnKeyClear")
	{
		// �� Ŭ����
		InputCaptcha_textBox.SetText ( "" );	
	}
	else if (Name == "btnKeyBack")
	{
		// �ѱ��� ����
		tempStr = InputCaptcha_textBox.GetText ();		

		if(Len(tempStr) > 0)
		{
			InputCaptcha_textBox.setText (  Left(tempStr, Len(tempStr) - 1) );			
		}
	}
	else
	{
		//�ѱ��ھ� �Է�		
		tempStr = InputCaptcha_textBox.GetText ();
		 
		if(Len(tempStr) < INPUT_MAX)
		{
			inputNumChar = Right( Name, 1 );
			InputCaptcha_textBox.SetText ( tempStr $ keyArray[int(inputNumChar)] ) ;			
		}
	}	

	
	btnOk.SetEnable( Len(InputCaptcha_textBox.GetText ()) >= INPUT_MAX ) ;	

	// Debug("tempStr"  @ getPasswordString(currentFocusTextBoxHandle));
}

function OnRegisterEvent()
{
	RegisterEvent(EV_VipBotCaptchaInfo);
	RegisterEvent(EV_VipBotCaptchaResult);
	RegisterEvent(EV_GamingStatePreExit);
}

/** onEvent */
function OnEvent(int Event_ID, string param)
{		
//	Debug ( Event_ID @ param ) ;
	switch( Event_ID )
	{
		case EV_VipBotCaptchaInfo :
			handleCapchaInfo ( param ) ;
		break;	
		case EV_VipBotCaptchaResult :
		    Me.SetUnConditionalShow(false);  //branch EP2.0 2015.7.20 luciper3 - BOT ĸí���� ������ Show ���¸� �����ؾߵǴ� â�� �������ش�.
			Me.HideWindow();
		break;
		case EV_GamingStatePreExit:
			Me.SetUnConditionalShow(false);
			break;
	}
}

function handleCapchaInfo( string param ) 
{
	//local texture	CaptchImage;

	Me.SetUnConditionalShow(true);  //branch EP2.0 2015.7.20 luciper3 - BOT ĸí���� ������ Show ���¸� �����ؾߵǴ� â�� �������ش�.

	Me.ShowWindow();
	Me.SetFocus();

	parseInt64 ( param ,"TransactionID" ,TransactionID );
	parseInt ( param ,"TryCount" ,TryCount );
	parseInt ( param ,"RemainTime" ,RemainTime );

	//CaptchImage = GetCaptchaImageTex();

	Me.KillTimer( TIMER_ID2 );
	Me.SetTimer ( TIMER_ID2 , TIMER_DELAY2 ) ;

	CaptchaImg_texture.SetTexturewithObject ( GetCaptchaImageTex() );
}

defaultproperties
{
}
