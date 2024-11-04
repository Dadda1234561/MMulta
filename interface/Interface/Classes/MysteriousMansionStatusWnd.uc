//------------------------------------------------------------------------------------------------------------------------
//
// ����         : MysteriousMansionStatusWnd  - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class MysteriousMansionStatusWnd extends L2UIGFxScript;

//const FLASH_WIDTH  = 800;
//const FLASH_HEIGHT = 600;

//�÷��� �ɼ� ��ǥ
//const FLASH_XPOS = 0;
//const FLASH_YPOS = 0;

//const DLG_ID_DELETE=0;
//const DLG_ID_RESTORE=1;

//var int currentScreenWidth, currentScreenHeight;

//var bool isFlashLoaded;
//var bool toSetPosition;

//var int selectedNum;
//const  maxCharacterNum = 7;
//var int  maxCharacterNum;

//var bool deleteEnable ;
//var bool startEnable ; 

// ���� 
//var toolTipWnd toolTipWndGFXScript;

//var bool isDeleting;

//var bool isPosition;


function OnRegisterEvent()
{
	//RegisterEvent ( EV_StateChanged ) ;	
	RegisterGFxEvent ( EV_CuriousHouseMemberListStart ) ;
	RegisterGFxEvent ( EV_CuriousHouseMemberList ) ;
	RegisterGFxEvent ( EV_CuriousHouseMemberUpdate ) ;
	
	RegisterGFxEvent ( EV_CuriousHouseMemberListEnd ) ;

	RegisterEvent ( EV_CuriousHouseRemainTime ) ;

	//RegisterEvent ( EV_CuriousHouseEnter ) ;
	RegisterGFxEvent ( EV_CuriousHouseLeave ) ;


	
}

function OnLoad()
{		
	registerState( "MysteriousMansionStatusWnd", "GamingState" );

	SetContainerWindow (WINDOWTYPE_SIMPLE_DRAG, 0 );
	AddState("GAMINGSTATE");

	//toolTipWndGFXScript = toolTipWnd(GetScript("toolTipWnd"));	
	//isFlashLoaded = false;
	//toSetPosition = false;
}

function OnDefaultPosition()
{
	CallGFxFunction ( getCurrentWindowName ( String ( self ) ), "OnDefaultPosition", "" ) ;	
}

/*
//Flash�� ���콺 ������ �̺�Ʈ �߻�.
event OnMouseOver( WindowHandle w )
{		
	dispatchEventToFlash_String(5, "");
//	Debug("OnMouseOver");
}
//Flash�� ���콺 �ƿ��� �̺�Ʈ �߻�.
event OnMouseOut( WindowHandle w )
{	
	dispatchEventToFlash_String(6, "");
//	Debug("OnMouseOut");
}


function OnShow()
{
	SetFocus();	
}


function OnFlashLoaded(){	
	//beforeFlashLoadedEvent();
	//local GFxValue l2SysStringTranslator;
	local GFxValue obj;
	
	//AllocGFxValue(l2SysStringTranslator);
	AllocGFxValue(obj);

	GetVariable(obj,"_root.l2SysStringTranslator");
	
//	GetFunction(l2SysStringTranslator, EExternalFunctionType.EFunc_SysStringTranslator);
	//obj.SetMemberValue("getTranslatedString", l2SysStringTranslator);

	//DeallocGFxValue(l2SysStringTranslator);
	
	toSetPosition = true; //�÷��� �ε��� ���� �������߸� �ѹ� �����Ŵ��� �� ��

	DeallocGFxValue(obj);
	
	isFlashLoaded = true;
}

function setPosition()
{	
	local float xLoc;
	local float yLoc;	

	local array<GFxValue> args;
	local GFxValue invokeResult;


	//â�� �⺻ ��ġ ���� �� ���̺� �� â��ġ�� �̵�.
	if( IsSavedInfo() )
	{
		SetGFxFromSavedInfo();
	}
	else
	{		
		// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
		AllocGFxValues(args, 2);
		AllocGFxValue(invokeResult);

		GetAnchorPointFromWindow( xLoc, yLoc, EAnchorPointType.ANCHORPOINT_CenterCenter );

		args[0].SetInt( int(xLoc) + FLASH_XPOS );
		args[1].SetInt( int(yLoc) + FLASH_YPOS );
		
		Invoke( "_root.onMove", args, invokeResult );

		DeallocGFxValue( invokeResult );
		DeallocGFxValues( args );
	}
}

function OnDefaultPosition()
{	
	//Debug("ArchiveViewWnd.uc.onDefaultPosition()");
}

function beforeFlashLoadedEvent() // �÷��� �ε� ���� ���Ӵ� ���� �̺�Ʈ ���� �ε�
{
}

function OnHide()
{
}

function OnCallUCLogic( int logicID, string param )
{	
	local int ServerID;		
	local UserInfo userinfo;

	ParseInt(param, "ServerID", ServerID);

	if (serverID != -1)
	{				
		if (GetPlayerInfo(userinfo))
		{					
			RequestAction(serverID, userinfo.Loc);
			//Debug ("ServerID" @ ServerID);
		}	
	} 
}
*/

function OnCallUCFunction( string functionName, string param )
{	
	local int ServerID;		
	local UserInfo userinfo;

	ServerID = int ( param ) ;
	//Debug( "OnCallUCFunction" @ functionName @ ServerID );
	//ParseInt(param, "ServerID", ServerID);
	switch ( functionName ) 
	{
		case "targetAction" :
			if (ServerID != -1)
			{				
				if (GetPlayerInfo(userinfo))
				{					
					RequestAction( int( param), userinfo.Loc);
				//	Debug ("ServerID" @ ServerID);
				}	
			} 
		break;
	}
}



function OnEvent(int Event_ID, string a_param)
{	
	switch(Event_ID)
	{	
		/*
	case  EV_CuriousHouseLeave :
		if( IsShowWindow()  ) hideWindow();
	break;
	case EV_CuriousHouseMemberListStart: //9340
		if( !IsShowWindow() ) ShowWindow();		
		handleCuriousHouseMemberListStart( );
		break;
	case EV_CuriousHouseMemberList: //9341
		handleCuriousHouseMemberList( a_param );
		break;
	case EV_CuriousHouseMemberListEnd: //9342
		handleCuriousHouseMemberListEnd( a_param );
		break;	
	case EV_CuriousHouseMemberUpdate: //9350		
		handleCuriousHouseMemberListUpdate( a_param );
		break;*/
	case EV_CuriousHouseRemainTime : //9360 �ý��� �޽����� 120 /60/30/5/4/3/2/1 �ʸ��� �ѷ� ��
		handleRemainTime(a_param); 
		break;
	}
}

function handleRemainTime (string a_param) 
{
	local string    strParam;
//	local string    title;
	local int    RemainTimeInSec;
	
	parseInt (a_param, "RemainTimeInSec" , RemainTimeInSec ) ;
 
	//���� �ð� 
	
	ParamAdd(strParam, "EventID", String(4) );  // startTime
	//ParamAdd(strParam, "Param1", "" );  // countDowUp
	ParamAdd(strParam, "Param2", String(RemainTimeInSec) );  // startTime
	//ParamAdd(strParam, "Param3", "" );  // endTime
	ParamAdd(strParam, "Param4", GetSystemString(1108) );  // Title

	ExecuteEvent( EV_AITimer, strParam );	
}

/*
function handleCuriousHouseMemberListStart( )
{
	dispatchEventToFlash_String(0, "");
}

function handleCuriousHouseMemberList(string a_param )
{
	local GFXValue argArray;

	local int       ServerID;
	local string    UserName;

	local UserInfo userinfo;

	ParseInt(a_param, "ServerID", ServerID);

	if ( GetPlayerInfo( userinfo ) ){
		if (  userinfo.nID != ServerID ) //�ڱ� �ڽ��� ������ ����
		{
			AllocGFxValue(argArray);
			createObject(argArray);
	
			ParseString(a_param, "UserName", UserName);	
			argArray.SetMemberInt("ServerID", ServerID);
			argArray.SetMemberString("UserName", UserName);						
			dispatchEventToFlash(1, argArray);//onLoad  	

			DeallocGFxValue(argArray);
		}				
	}
}

function handleCuriousHouseMemberListUpdate(string a_param)
{
	local GFXValue argArray;
	local int ServerID;
	local int curHP;
	local int MaxHP;
	local int curCP;
	local int MaxCP;

	AllocGFxValue(argArray);
	createObject(argArray);	

	ParseInt(a_param, "ServerID",  ServerID);
	ParseInt(a_param, "CurrentHP", curHP);
	ParseInt(a_param, "MaxHP",  MaxHP);
	ParseInt(a_param, "CurrentCP", curCP);
	ParseInt(a_param, "MaxCP",  MaxCP);

	argArray.SetMemberInt("ServerID",ServerID);
	argArray.SetMemberInt("CP",curCP);
	argArray.SetMemberInt("MAXCP",MaxCP);
	argArray.SetMemberInt("HP",curHP);
	argArray.SetMemberInt("MAXHP",MaxHP);

	//Debug("ServerID" @ ServerID);
	
	dispatchEventToFlash(3, argArray);//onLoad
	DeallocGFxValue(argArray);
}


function handleCuriousHouseMemberListEnd(string a_param )
{
	if (toSetPosition ) //�̷��� �ؾ�, Ÿ���� ���� ���� �� �� �������� ��´�. 
	{
		setPosition();
		toSetPosition = false;//�����Ŵ� �� �ʿ� ����
	}	
}




function dispatchEventToFlash(int Event_ID, GFxValue argArray){

	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);
	args[0].SetInt(Event_ID);
	CreateObject(args[1]);

	args[1].SetMemberValue("param", argArray );

	Invoke("_root.onEvent", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);	
}

function dispatchEventToFlash_String(int Event_ID, string argString){
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);
	args[0].SetInt(Event_ID);
	CreateObject(args[1]);

//	Debug("argString"@argString);
	args[1].SetMemberString("string", argString );

	Invoke("_root.onEvent", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
}
*/

defaultproperties
{
}
