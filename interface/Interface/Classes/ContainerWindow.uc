class ContainerWindow extends L2UIGFxScript;

//var string registedState;

function OnLoad()
{
	SetSaveWnd(True,False);

	SetClosingOnESC();
	//SetAnchor( "", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0 );	
	//registedState = "GAMINGSTATE";

	registerState( "ContainerWindow", "GAMINGSTATE" );
	registerState( "ContainerWindow", "TRAININGROOMSTATE" );
	//SetDefaultShow(true);	
	//SetHavingFocus(false);
}

function OnRegisterEvent()
{
	//RegisterEvent( EV_StateChanged );	
	RegisterEvent( EV_NotifyBeforeStateChanged );	

	RegisterGfxEvent( EV_ResolutionChanged );		
	RegisterGfxEvent( EV_ReceiveWindowsInfo );
	RegisterGfxEvent( EV_DialogOK );
	RegisterGfxEvent( EV_DialogCancel );

	//L2UIData�� �Ƶ���, �κ�ī��Ʈ ����
	RegisterGFxEvent( EV_AdenaInvenCount );	

	//�Ƶ��� ���� ���� ( ���ʿ��� �ε���� �����̳ʿ��� �Ƶ��� ������ ��� ���� ) 
	RegisterGfxEvent( EV_AdenaInvenCount );
	//RegisterEvent( EV_ReceiveChatFilter );
	//RegisterEvent( EV_ReceiveOption );	
}

function OnFlashLoaded()
{
	local GFxValue l2SysStringTranslator;
	local GFxValue obj;

	//���ݼ� ���� ��������Ʈ
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_AlchemyAPI);

	//10�ֳ��̺�Ʈ ��������Ʈ
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Event10thAnniversary);

	//�Ʒü�
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_TrainingRoomWnd);

	//��Ű ���� ���� �ڵ鷯
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_LuckyGameWnd);
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_EventCardWnd);
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Container);

	//���� ����
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_ShortcutAPI);

	//�ɼ� ���� ��������Ʈ
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Option);

    // VIP �ý��� ��������Ʈ
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_VipSystem);

	//�Է� ���� ��������Ʈ
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_InputAPI);

	//���� ���� �ý���
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_PledgeRecruit);

	//�Ƶ��� �й� â
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_AdenaDistributionWnd);

	//�ø��ǾƵ� ��� â �ڵ�
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_OlympiadArenaList);

	//�⺻ ���� ��������Ʈ? �ɼǿ��� ��� ���̾���
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Default);

	// �Ѽ� ������ ��������Ʈ �߰�	
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_FactionWnd);

	//�Ʒ��� ���� ��������Ʈ
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Arena);

	//���̴� ���� ��������Ʈ ( faction �� startNPC ��ġ �ޱ� ����. 
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_RadarMap);

	// ���� ����Ÿ �� �ޱ� ����
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_GameData);
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_PledgeWnd);

	// �Ӽ� ���� �ý���
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_ElementalSpirit);
	// �̴ϸ� ����Ÿ�� ����
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Minimap);

	//���� ����
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_ClassChange);
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_TeleportList);

	//�����Ƽ ���� ��������Ʈ
	//RegisterDelegateHandler(EDelegateHandlerType.EDHandler_AbilityWnd);
	//ũ�������� �̺�Ʈ ���� 
	////RegisterDelegateHandler(EDelegateHandlerType.EDHandler_EventChristmasWnd);
	// ���� �̹��� ���� �� �ֵ��� ����
	//SetImageLoader(EFlashImageLoaderType.EImgLoader_Pledge);
	//ä�ð���
	//RegisterDelegateHandler(EDHandler_ChatWnd);
	

	AllocGFxValue(l2SysStringTranslator);
	AllocGFxValue(obj);

	//GetVariable(obj,"_root.l2SysStringTranslator");
	
	//�ý��� ��Ʈ�� ���� 
	GetFunction(l2SysStringTranslator, EExternalFunctionType.EFunc_SysStringTranslator);
	obj.SetMemberValue("getTranslatedString", l2SysStringTranslator);

	DeallocGFxValue(l2SysStringTranslator);
	DeallocGFxValue(obj);
}

function onCallUCFunction ( string functionName, string param ) 
{
	switch ( functionName ) 
	{
		/*
		 *����â ��� ���� �ڵ� 
		case "setSubWindowPosition" :
			setSubWindowPosition ( param ) ;
		break;
		case "setFocusInSubWindow" :
			setFocusInSubWindow( param ) ;
		break;
		case "setFocusOutSubWindow" :
			setFocusOutSubWindow( param ) ;
		break;
		case "bringToFront":
			//BringToFront (getCurrentWindowName(string(Self))) ;
			Debug( "bringToFront" @ getCurrentWindowName(string(Self)) )  ;				
			class'UIAPI_WINDOW'.static.BringToFront (getCurrentWindowName(string(Self)));	
		*/
	}
}

/****************************************************************************************************************
 * ����â ��� ���� �ڵ� 
 * **************************************************************************************************************
function setFocusInSubWindow ( string param )
{
	//local WindowHandle subWindow;
	//local string windowName;	
	//parseString ( param, "windowName", windowName );
	//subWindow = GetWindowHandle ( param );
	//subWindow.SetFocus();
	Debug(  "setFocusInSubWindow" @ param ) ;
	//class'UIAPI_WINDOW'.static.SetAlwaysOnTop( param, true );
	class'UIAPI_WINDOW'.static.BringToFront (param);
}

function setFocusOutSubWindow ( string param )
{
	//local WindowHandle subWindow;
	//local string windowName;	
	//parseString ( param, "windowName", windowName );
	//subWindow = GetWindowHandle ( param );
	//subWindow.SetFocus();
	Debug(  "setFocusOutSubWindow" @ param ) ;
	//class'UIAPI_WINDOW'.static.SetAlwaysOnTop( param, false );
}


function setSubWindowPosition ( string param )
{	
	local WindowHandle subWindow;
	local string windowName;
	local int offsetX, offsetY, x, y, width, height, targetX, targetY ;

	parseString ( param, "windowName", windowName );
	subWindow = GetWindowHandle ( windowName );

	if ( !subWindow.IsShowWindow() ) return;
	
	parseInt ( param , "offsetX", offsetX) ;
	parseInt ( param , "offsetY", offsetY) ;
	parseInt ( param , "width", width) ;
	parseInt ( param , "height", height) ;
	parseInt ( param , "x", x) ;
	parseInt ( param , "y", y) ;

	targetX = x + width + offsetX ;
	targetY = y + offsetY ;	
	subWindow.SetAnchor( "" , "TopLeft", "TopLeft", targetX, targetY );	
}*/

function OnEvent(int a_EventID, string a_Param) 
{	
	switch (a_EventID)
	{
	case EV_NotifyBeforeStateChanged://3411 EV_StateChanged:
		handleNotifyBeforeStateChanged ( a_Param ) ;
		//handleNotifyBeforeStateChanged( a_Param ) ;
		//invoke("onChangeState", args, invokeResult);

		/*
		if ( a_Param == registedState )
		{
			Invoke("onEnterState", args, invokeResult);			
		}
		else 
		{
			Invoke("onExitState", args, invokeResult);			
		}
*/
	break;
	/*
	case EV_ResolutionChanged:
		//Debug( "EV_ResolutionChanged" @  a_Param );
		ParseInt(a_Param, "NewWidth", _width);
		ParseInt(a_Param, "NewHeight", _height);
			
		args[1].SetMemberInt( "NewWidth" , _width );		
		args[1].SetMemberInt( "NewHeight" , _height );		
		invoke( "onResolutionChanged", args, invokeResult);
	break;
	case EV_ReceiveWindowsInfo:
		//Debug ( "---------EV_ReceiveWindowsInfo");
		invoke( "onReceiveWindowsInfo", args, invokeResult);
	break;
	case EV_ReceiveChatFilter:
//		Debug ( "---------EV_ReceiveChatFilter");
		invoke( "onReceiveChatFilter", args, invokeResult);
	break;
	case EV_ReceiveOption:
//		Debug ( "---------EV_ReceiveOption");
		invoke( "onReceiveOption", args, invokeResult);
	break;
*/
	}
}

function OnFocus(bool bFlag, bool bTransparency)
{	
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args,2) ;	
	args[0].setbool(bflag) ;
	args[1].setbool(bTransparency);
	AllocGFxValue(invokeResult);	
		
	Invoke("onFocusContainer", args, invokeResult);		
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);	
}

function onHide () 
{
	invokeToFlash ("onHide");
}

function handleNotifyBeforeStateChanged( string param ) 
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);

	args[0].SetInt( EV_NotifyBeforeStateChanged );
	CreateObject(args[1]);

//	Debug("argString"@argString);
	args[1].SetMemberString( "state" , param  );

	Invoke("onEvent", args, invokeResult);
	
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 **
 ***/
function OnReceivedCloseUI()
{
	invokeToFlash ("onPressESC");
}

function OnDefaultPosition()
{
	invokeToFlash( "onDefaultPosition" );
}


function invokeToFlash ( string invokeID ) 
{
	local array<GFxValue> args;
	local GFxValue invokeResult;
	
	//if ( param != NU ) 
	AllocGFxValues(args, 1);
	//args[0].setMemberString ( "param", param) ;
	
	Invoke( invokeID, args, invokeResult);

	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);		
}

defaultproperties
{
}
