/*------------------------------------------------------------------------------------------------------------------------

 ����         : ������ ���׷��̵� - SCALEFORM UI

 event ID : 10190  , Param : Flag=1
 npc : �丮�� 

 http://wallis-devsub/redmine/issues/4234

//���� 19440 2
//���� 17371 4
//���� 35563 50
//summon_attribute 18001 2 300 0 0 0 0 14 30462 30582 45 603 726
//���� 37417 1
-> ������ '���� �ܰ� ������'�� ����Ͽ� '+14 �ູ���� ����Į���� ������' �������� ���� ����

<����/��ȥ/�Ӽ�/��æƮ ��� �ο��ϴ� ���� ��ɾ�>
//summon_attribute 18001 2 300 0 0 0 0 14 30462 30582 45 603 726
-> '+14 �ູ���� ����Į���� ������'(�Ӽ�/��þƮ/����/��ȥ�� �ο���) ������ ����


- npc �丮��
//���� 1030847
- '+14 �ູ���� ����Į���� ������'(�Ӽ�/��þƮ/����/��ȥ�� �ο���) ������ ����
//summon_attribute 18001 2 300 0 0 0 0 14 30462 30582 45 603 726
//���� 17371 1000000
//���� 19440 50000
//���� 47951 10000
//���� 57 1000000000


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

	// Ŭ���İ� ���̺꿡 �ٸ� ���� ���
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
//	//������ ���콺 ��ġ�� 0,0����.
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
