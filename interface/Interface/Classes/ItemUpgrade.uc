/*------------------------------------------------------------------------------------------------------------------------

 제목         : 아이템 업그레이드 - SCALEFORM UI

 event ID : 10190  , Param : Flag=1
 npc : 페리스 

 http://wallis-devsub/redmine/issues/4234

//생성 19440 2
//생성 17371 4
//생성 35563 50
//summon_attribute 18001 2 300 0 0 0 0 14 30462 30582 45 603 726
//생성 37417 1
-> 생성된 '광선 단검 가공석'을 사용하여 '+14 축복받은 아포칼립스 셰이퍼' 아이템을 외형 변경

<제련/집혼/속성/인챈트 모두 부여하는 빌더 명령어>
//summon_attribute 18001 2 300 0 0 0 0 14 30462 30582 45 603 726
-> '+14 축복받은 아포칼립스 셰이퍼'(속성/인첸트/제련/집혼이 부여된) 아이템 생성


- npc 페리스
//생성 1030847
- '+14 축복받은 아포칼립스 셰이퍼'(속성/인첸트/제련/집혼이 부여된) 아이템 생성
//summon_attribute 18001 2 300 0 0 0 0 14 30462 30582 45 603 726
//생성 17371 1000000
//생성 19440 50000
//생성 47951 10000
//생성 57 1000000000


------------------------------------------------------------------------------------------------------------------------*/
class ItemUpgrade extends L2UIGFxScriptNoneContainer;

function OnRegisterEvent()
{	
	//RegisterEvent( EV_Restart );
	//RegisterEvent( EV_Test_8 );
	

	//RegisterEvent( EV_RestartMenuShow );
	RegisterGFxEvent( EV_ShowUpgradeSystem );	
	RegisterGFxEvent( EV_UpgradeSystemResult );	

}

function OnLoad()
{		
	//AddState( "GAMINGSTATE" );

	//SetContainerWindow(WINDOWTYPE_NONE, 0);		

	SetClosingOnESC();

	registerState( "ItemUpgrade", "GamingState" );
	registerState( "ItemUpgrade", "ARENAGAMINGSTATE" );

	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0,0);
	///SetHavingFocus( false );
}

function OnShow()
{
	class'UIAPI_WINDOW'.static.HideWindow("CardDrawEventWnd");

	super.onShow();
	L2Util(GetScript("L2Util")).ItemRelationWindowHide(getCurrentWindowName(String(self)));

	//L2Util.HideWindow("CardDrawEventWnd");
}

//function onFocus ( bool bFlag, bool bTransparency ) 
//{
//	//if ( bFlag ) 
//	//{
//	//	class'UIAPI_WINDOW'.static.BringToFront("EffectWnd") ;
//	//	if (IsShowWindow("QuitReportWnd")) GetWindowHandle("QuitReportWnd").ShowWindow();
//	//}	
//}

function OnFlashLoaded()
{		
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_UpgradeSystemWnd);
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Container);
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Default);
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_GameData);

	//SetRenderOnTop(true);
	//SetAlwaysOnTop(true);
	//SetAlwaysFullAlpha(true);
}

function onCallUCFunction( string functionName, string param )
{
	// local string strParam;
	//Debug("sampe's onCallUCFunction" @ functionName @ param);
	switch ( functionName ) 
	{
		case "OpenHelpHTML" :
			OnClickHelp();

			break;		
	}
}

function OnClickHelp( ) 
{
	local string strParam;

	// 클래식과 라이브에 다른 도움말 사용
	if ( getInstanceUIData().getIsClassicServer() ) 
	{
		ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "help_item_upgrade.htm");
		ExecuteEvent(EV_ShowHelp, strParam);
	}
}

//function onEvent ( int id, string param) 
//{
//	switch ( id ) 
//	{
//	//	case EV_UpdateMyHP : HandleUpdateHP( param ) ;break;
//		// case EV_RestartMenuShow : ShowWindow() ;break;
//		// case EV_RestartMenuHide : 
//		// case EV_Restart :hideWindow() ;break;

//		//case EV_Test_8 :ShowWindow() ;break;
		
//	}
//}


//event OnMouseOut( WindowHandle w )
//{
//	dispatchEventToFlash_String(0, "");
//	//강제로 마우스 위치를 0,0으로.
//	//ForceToMoveMousePos( 0, 0 );
//}

//event onMouseOver ( WindowHandle w )
//{
//	dispatchEventToFlash_String(1, "");
//}


//function dispatchEventToFlash_String(int Event_ID, string argString){
//	local array<GFxValue> args;
//	local GFxValue invokeResult;

//	AllocGFxValues(args, 2);
//	AllocGFxValue(invokeResult);
//	args[0].SetInt(Event_ID);
//	CreateObject(args[1]);

////	Debug("argString"@argString);
//	args[1].SetMemberString("string", argString );

//	Invoke("onEvent", args, invokeResult);
//	DeallocGFxValue(invokeResult);
//	DeallocGFxValues(args);
//}

defaultproperties
{
}
