class FlightTransformCtrlWnd extends UIScript;

// ������
const MAX_ShortcutPerPage = 12;	// 12ĭ�� ������ �����Ѵ�. 
const FTShortcutPage = 10;		// ���ຯ��ü�� 10�� �������� ����Ѵ�.  //branch EP3.0 2016.7.27 luciper3 - �Ϻ� ��û���� ������ 10 -> 20 ���� ����

const SelectTex_X = 1;
const SelectTex_Y = 1;

const FT_TIME = 45000;	// �ý��� Ʃ�丮���� �����ϰ� ���̴� �ð�	//45�ʿ� 1ȸ��
const FT_TIME1 = 1000;	// ������ 1�ʿ� �ѹ��� �����Ѵ�. 

const FT_TIMER_ID = 150;	// Ÿ�̸� ���̵�
const FT_TIMER_ID1 = 152;	// Ÿ�̸� ���̵� // 151�� radarmap �� �ִ�. -_-;;?

// ���� ����
var WindowHandle Me;
var WindowHandle ShortcutWnd;

//var RadarMapWnd scriptRadarMapWnd;	// ���̴� ��ũ��Ʈ ��������

//var	CheckBoxHandle 	Chk_EnterChatting;	//shortcut assign wnd�� ����ä�� ��� üũ�ڽ�.
//var	CheckBoxHandle 	Chk_EnterChatting1;	//shortcut assign wnd�� ����ä�� ��� üũ�ڽ�.

var	ButtonHandle	LockBtn;			// ��� ��ư
var	ButtonHandle	UnlockBtn;			// ��� ���� ��ư
var	ButtonHandle	JoypadBtn;			// �����е�

var	TextureHandle	SelectTex;			// ���õ� �������� �˷��ִ� �ؽ���

var  ShortcutWnd 	scriptShortcutWnd;	

var	int i;							//���� ������ ����ϴ� ����
var	bool 		preEnterChattingOption;

var	bool isNowActiveFlightTransShortcut;	// ���� ����ü��������� �����Ѵ�. ���� ���̴����� ������ �ε��� ���� �� �����Ƿ�.

var 	bool m_IsLocked;	// ���� ��� ����
var	int preSlot;			// ������ Ȱ��ȭ�� ������ �����صд�.

// �̺�Ʈ ���
function OnRegisterEvent()
{
	RegisterEvent( EV_FlightTransform );
	
	RegisterEvent( EV_ShortcutUpdate );
	RegisterEvent( EV_ShortcutClear );
	RegisterEvent( EV_ShortcutPageUpdate );
	RegisterEvent( EV_ShortcutCommandSlot );	//���� �̺�Ʈ
	RegisterEvent( EV_ReserveShortCut);		// ����� ���� �̺�Ʈ
	
	registerEvent( EV_GamingStateExit );	// ����ŸƮ �� ���
}

function OnLoad()
{
	
	Me = GetWindowHandle( "FlightTransformCtrlWnd" );
	ShortcutWnd = GetWindowHandle( "ShortcutWnd" );
	//���� ä�ÿ�.
	//Chk_EnterChatting	    =	GetCheckBoxHandle( "ShortcutAssignWnd.Chk_EnterChatting" );
	//Chk_EnterChatting1	    =	GetCheckBoxHandle( "ShortcutAssignWnd.Chk_EnterChatting1" );

	SelectTex = GetTextureHandle( "FlightTransformCtrlWnd.SelectTex");		
	LockBtn = GetButtonHandle ( "FlightTransformCtrlWnd.FlightShortCut.LockBtn");
	UnlockBtn = GetButtonHandle ( "FlightTransformCtrlWnd.FlightShortCut.UnlockBtn");
	JoypadBtn = GetButtonHandle ( "FlightTransformCtrlWnd.FlightShortCut.JoypadBtn");		
	
	// scriptRadarMapWnd = RadarMapWnd( GetScript("RadarMapWnd") );
	scriptShortcutWnd = ShortcutWnd( GetScript("ShortcutWnd") );	
	JoypadBtn.HideWindow();
	isNowActiveFlightTransShortcut = false;
	preSlot = -1;
	updateLockButton();	// ��� ���¸� ������Ʈ �Ѵ�. 
	ShortCutUpdateAll();
}

function updateLockButton()
{
	/*
	local int tmpInt;
	GetINIInt ( "ShortcutWnd", "l",  tmpInt, "WindowsInfo.ini");
	m_IsLocked = bool ( tmpInt );
*/
	m_IsLocked = GetOptionBool( "Game", "IsLockShortcutWnd" );
	if(m_IsLocked)
	{
		if(!LockBtn.isShowwindow()) LockBtn.ShowWindow();
		if(UnlockBtn.isShowwindow()) UnlockBtn.HideWindow();
	}
	else
	{
		if(LockBtn.isShowwindow()) LockBtn.HideWindow();
		if(!UnlockBtn.isShowwindow()) UnlockBtn.ShowWindow();
	}
	scriptShortcutWnd.ArrangeWnd();
}

function OnClickButton( String strID )
{
	switch( strID )
	{
	case "LockBtn":
		m_IsLocked = false;		
		//SetINIInt ( "ShortcutWnd", "l",  0, "WindowsInfo.ini");	
		SetOptionBool( "Game", "IsLockShortcutWnd", false );
		updateLockButton();
		break;
	case "UnlockBtn":
		m_IsLocked = true;
		//SetINIInt ( "ShortcutWnd", "l",  1, "WindowsInfo.ini");	
		SetOptionBool( "Game", "IsLockShortcutWnd", true );
		updateLockButton();
		break;
	}
}

//���̴� ���� ������Ʈ ������ ������ ������
/*
function OnEnterState( name CurrentStateName )
{
	
	if(isNowActiveFlightTransShortcut)	// ������忴���ٸ�
	{
		if( CurrentStateName == 'ShaderBuildState')
		{			
			if(!Me.isShowwindow()) Me.ShowWindow();					//���� �������� ����
			if(ShortcutWnd.isShowwindow()) ShortcutWnd.HideWindow();
			
			Me.SetTimer( FT_TIMER_ID1, FT_TIME1 );	// ������ �������� Ÿ�̸Ӹ� �Ҵ�.			
			if(!scriptRadarMapWnd.FlightStatusAltitude.isShowWindow()) scriptRadarMapWnd.FlightStatusAltitude.ShowWindow();		//���� �����ֱ�	
		}
	}

}*/

function OnExitState( name a_CurrentStateName )
{
	//local OptionWnd win;	
	//win = OptionWnd( GetScript("OptionWnd") );
		
	////���̴� ���� ������Ʈ ������ ������ ������
	///*
	//if( a_NextStateName != 'ShaderBuildState')	// ���̴� ���׷� ���� ��찡 �ƴ϶��,  üũ�ڽ��� �𽺿��̺��� Ǯ���ش�. 
	//{
	
	//}*/
	//win.dispatchEventToFlash_Int(200, 3); //�𼭺� ����

	CallGFxFunction( "OptionWnd", "onSwitchDisableEnterChatting", string ( false ) ) ;
}


function bool getIsArenaServer () 
{
	local UIData script ;
	script = UIData( GetScript ( "UIData"));	
	return script.getIsArenaServer();	
}


// �̺�Ʈ ó��
function OnEvent( int a_EventID, String a_Param )
{
	// �Ʒ��������� ó�� ���� ����
	if ( getIsArenaServer() ) return;

	switch( a_EventID )
	{
	case EV_FlightTransform:
		OnFlightTransformState( a_Param );
		break;
	case EV_ShortcutCommandSlot:
		ExecuteShortcutCommandBySlot(a_Param);	// ����Ű ���� �̺�Ʈ
		break;
	case EV_ReserveShortCut:
		OnReserveShortCut( a_Param );
		break;
	case EV_GamingStateExit:
		Me.KillTimer( FT_TIMER_ID );				// Ÿ�̸Ӹ� �׿��ش�.
		Me.KillTimer( FT_TIMER_ID1 );		
		// if(scriptRadarMapWnd.FlightStatusAltitude.isShowWindow()) scriptRadarMapWnd.FlightStatusAltitude.HideWindow();		//���� ����
		break;
	case EV_ShortcutUpdate:
		HandleShortcutUpdate( a_Param );
		break;
	case EV_ShortcutPageUpdate:	// �������� ���� ������ ��ü�� ������Ʈ �Ѵ�.
		ShortCutUpdateAll();
		break;
	case EV_ShortcutClear:
		HandleShortcutClear();
		updateLockButton();
		break;
	default:
		break;
	}
}

// ��Ÿ�̸� �̺�Ʈ!
function OnTimer(int TimerID)
{
	local vector MyPosition;
	if(TimerID == FT_TIMER_ID)
	{
		if(!GetOptionBool( "ScreenInfo", "SystemTutorialBox" ))	// �ý��� Ʃ�丮�� üũ�ڽ��� Ȯ���� �־�� �Ѵ�. 
		{	
			ShowAirTutorial(-1);	// �ý��� �޼��� ���� �߰�
		}
		else
		{
			Me.KillTimer( FT_TIMER_ID );	// Ÿ�̸Ӹ� �׿��ش�.
		}
	}
	else if(TimerID == FT_TIMER_ID1)	// ������ �������ִ� Ÿ�̸�.
	{
		MyPosition = GetPlayerPosition();	// �� ��ġ ����
		
		// scriptRadarMapWnd.updateAltitudeTex( MyPosition.z );
	}
}


function OnFlightTransformState( string a_Param )
{	
	local int       IsFlying;
	//local MainMenu	scriptMain;
	//local OptionWnd scriptOptionWnd;	
	
	//scriptOptionWnd = OptionWnd( GetScript("OptionWnd") );
	//scriptMain = MainMenu ( GetScript("MainMenu") );
	
	ParseInt( a_Param, "IsFly", IsFlying );
	
	//debug ("EV_FlightTransform : " $ IsFlying);
	
	if(IsFlying > 0)	// ���� ����
	{		
		if(!GetOptionBool( "ScreenInfo", "SystemTutorialBox" ))
		{
			ShowAirTutorial(2493);	// �ý��� �޼����� ������ �������ش�.
			ShowAirTutorial(2495);
			// ���⼭ Ÿ�̸Ӹ� �Ҵ�.
			Me.SetTimer( FT_TIMER_ID,FT_TIME );
		}	
		
		Me.SetTimer( FT_TIMER_ID1, FT_TIME1 );	// ������ �������� Ÿ�̸Ӹ� �Ҵ�.
		//if(!scriptRadarMapWnd.FlightStatusAltitude.isShowWindow()) scriptRadarMapWnd.FlightStatusAltitude.ShowWindow();		//���� �����ֱ�			
		
		preEnterChattingOption = GetChatFilterBool ( "Global", "EnterChatting");		
		SetChatFilterBool ( "Global", "EnterChatting", true);		
		//preEnterChattingOption = GetOptionBool("CommunIcation", "EnterChatting");		//���� ����ä�� �ɼ��� �����صд�. 		
		//SetOptionBool( "CommunIcation", "EnterChatting", true );	//���� ���� ä��

		//scriptOptionWnd.dispatchEventToFlash_Int(200, 1); //üũ
		//scriptOptionWnd.dispatchEventToFlash_Int(200, 2); //�𼭺�
		Debug ( "OnFlightTransformState true"  ) ;
		CallGFxFunction( "OptionWnd", "onSwitchEnterChatting", String ( true ) );		
		CallGFxFunction( "OptionWnd", "onSwitchDisableEnterChatting", String ( true ) );		
		
		updateLockButton();	// ��� ���¸� ������Ʈ �Ѵ�. 
		class'ShortcutAPI'.static.ActivateGroup("FlightTransformShortcut");	//���� �׷� ����		
		//scriptMain.changeEnterChat( "FlightTransformShortcut" );
		if(!Me.isShowwindow()) 
		{
			Me.ShowWindow();					//���� �������� ����
			ShortcutWnd.HideWindow();
		}
		
		isNowActiveFlightTransShortcut = true;
	}
	else	// ���� ���� ����
	{
		//if(scriptRadarMapWnd.FlightStatusAltitude.isShowWindow()) scriptRadarMapWnd.FlightStatusAltitude.HideWindow();		//���� ����
			
		Me.KillTimer( FT_TIMER_ID );	// Ÿ�̸Ӹ� �׿��ش�.
		Me.KillTimer( FT_TIMER_ID1 );
		
		//scriptOptionWnd.dispatchEventToFlash_Int(200, 3); //�𼭺�����		
		CallGFxFunction( "OptionWnd", "onSwitchDisableEnterChatting", String ( false ) );		
		
		class'ShortcutAPI'.static.DeactivateGroup("FlightTransformShortcut"); // ���� �׷� ����
		
		//SetOptionBool( "CommunIcation", "EnterChatting", preEnterChattingOption );	//����ص� ����ä�� �ɼ��� �ٽ� �־��ش�.	
		SetChatFilterBool ( "Global", "EnterChatting", preEnterChattingOption);			
		if(preEnterChattingOption)	// ������ ��� ���¿� ���� ���� ä���� Ȱ��ȭ ���ش�.			
		{			
			class'ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
			//scriptMain.changeEnterChat( "TempStateShortcut" );
		}
		//else
		//{
		//	scriptMain.changeEnterChat( "GamingStateShortcut" );
		//}

	//	CallGFxFunction ( "Menu", "onSetShortcut", "");
	//	CallGFxFunction ( "MenuWnd", "onSetShortcut", "");

	//	Debug ( "OnFlightTransformState" @ preEnterChattingOption ) ;
		CallGFxFunction( "OptionWnd", "onSwitchEnterChatting", String ( preEnterChattingOption ) );		
		
		//if (preEnterChattingOption ) 
		//{
		//	scriptOptionWnd.dispatchEventToFlash_Int(200, 1); //üũ ���� ä�� üũ
		//}
		//else 
		//{
		//	scriptOptionWnd.dispatchEventToFlash_Int(200, 0); //üũ ���� ä�� üũ
		//}
		//Chk_EnterChatting.SetCheck(preEnterChattingOption);	
		//Chk_EnterChatting1.SetCheck(preEnterChattingOption);	
		
		if(Me.isShowwindow())	
		{
			Me.HideWindow();					// ���� �������� ��������
			ShortcutWnd.ShowWindow();
		}
		
		isNowActiveFlightTransShortcut = false;
	}
}

function ShortCutUpdateAll()
{
	local int nShortcutID;
	
	nShortcutID = MAX_ShortcutPerPage * FTShortcutPage;
	
	for( i = 0; i < MAX_ShortcutPerPage; ++i )
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut( "FlightTransformCtrlWnd.FlightShortCut.Shortcut" $ ( i + 1 ), nShortcutID );
		nShortcutID++;
	}
}


// ���� ������Ʈ
function HandleShortcutUpdate(string param)
{
	local int nShortcutID;
	local int nShortcutNum;
	
	ParseInt(param, "ShortcutID", nShortcutID);
	nShortcutNum = ( nShortcutID - MAX_ShortcutPerPage * FTShortcutPage) + 1;
	
	if((nShortcutNum > 0 ) && ( nShortcutNum  < MAX_ShortcutPerPage + 1 ))	// ��������� ��쿡��  ������Ʈ
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut( "FlightTransformCtrlWnd.FlightShortCut.Shortcut" $ nShortcutNum, nShortcutID );
		
	}
}

 //���� Ŭ����
function HandleShortcutClear()
{		
	for( i = 0; i < MAX_ShortcutPerPage; ++i )
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.clear( "FlightTransformCtrlWnd.FlightShortCut.Shortcut" $ ( i + 1 ) );
	}
}

function HandleShortcutPageUpdate(string param)	// ������ ������Ʈ
{
	//~ local int i;
	//~ local int nShortcutID;
	local int ShortcutPage;
	
	if( ParseInt(param, "ShortcutPage", ShortcutPage) )
	{
		debug ("----------------ShortcutPage " $ ShortcutPage);
		if( ShortcutPage == FTShortcutPage)	ShortCutUpdateAll();
	}
}

function ExecuteShortcutCommandBySlot( string a_Param )
{
	local int slot;
	local int slotFromOne;
	ParseInt(a_Param, "Slot", slot);
	
	// 120������ 131�������� ������ ������ �������ش�. 
	if( (slot >= MAX_ShortcutPerPage * FTShortcutPage) && ( slot < MAX_ShortcutPerPage * (FTShortcutPage + 1)))
	{	
		slotFromOne = slot - MAX_ShortcutPerPage * FTShortcutPage + 1;
		class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(slot);
		SelectTex.SetAnchor( "FlightTransformCtrlWnd.F" $ slotFromOne $ "Tex" , "TopLeft", "TopLeft", SelectTex_X, SelectTex_Y );
	}
}

function OnReserveShortCut( string a_Param )
{
	local int slot;
	local int slotFromOne;
	ParseInt(a_Param, "Slot", slot);
	
	// 120������ 131�������� ������ ������ �������ش�. 
	if( (slot >= MAX_ShortcutPerPage * FTShortcutPage) && ( slot < MAX_ShortcutPerPage * (FTShortcutPage + 1)))
	{	
		slotFromOne = slot - MAX_ShortcutPerPage * FTShortcutPage + 1;
		SelectTex.SetAnchor( "FlightTransformCtrlWnd.F" $ slotFromOne $ "Tex" , "TopLeft", "TopLeft", SelectTex_X, SelectTex_Y );
		
		if( preSlot == slotFromOne )	// �̹� ���õ� ���¿��� �ѹ� �� ������ ����ȴ�.
		{
			class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(slot);
		}
		else
		{
			preSlot = slotFromOne;
		}
	}
}

function ShowAirTutorial( int SystemMsgID)
{
	local int RandVal;
	local int RandSystemMsgID;
	
	if(SystemMsgID < 0)	// 0���� ������ ������ �ý��� �޼����� �����ش�. 
	{
		RandVal = Rand(4);
		
		RandSystemMsgID = 2493;	// ������ ���� ����Ʈ�� -_-
		
		switch(RandVal)
		{
			case 0:	RandSystemMsgID = 2493;		break;		// ������ �ý��� �޼��� ���̵� �����ش�
			case 1:	RandSystemMsgID = 2495;		break;
			case 2:	RandSystemMsgID = 2496;		break;
			case 3:	RandSystemMsgID = 2497;		break;
		}
	}
	else
	{
		RandSystemMsgID = SystemMsgID;
	}
	
	if(!GetOptionBool( "ScreenInfo", "SystemTutorialBox" ))	// �ý��� Ʃ�丮�� üũ�ڽ��� Ȯ���� �־�� �Ѵ�. 
	{	
		AddSystemMessage(RandSystemMsgID);	// �ý��� �޼��� �߰�
	}
	else
	{
		Me.KillTimer( FT_TIMER_ID );	// Ÿ�̸Ӹ� �׿��ش�.
	}
}

defaultproperties
{
}