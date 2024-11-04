class ContainerHUD extends GFxUIScript;

var string registedState;

function OnLoad()
{	
	SetSaveWnd(True,False);

	SetClosingOnESC();	
	//registedState = "GAMINGSTATE";

	//registerState( "ContainerHUD", registedState );

	SetDefaultShow(true);
	setHUD();
	//SetHavingFocus( true );
//	setAlwaysOnBack(true);

//	SetGFxPassThrough(true);
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
	
	RegisterEvent(EV_StateChanged);
}


function onCallUCFunction( string functionName, string param )
{
	switch(functionName)
	{
		//setFocus�� �ص� view �� container�� ��Ŀ�� ���� ....
		case "focusContainer":
			SetFocus();
		break;
	}
}
function OnFlashLoaded()
{		
	local GFxValue l2SysStringTranslator;
	local GFxValue obj;

	//SetHasTexfield ���� ��������Ʈ
	RegisterDelegateHandler(EDHandler_Container);
	
	//ä�ð���
	RegisterDelegateHandler(EDHandler_ChatWnd);

	//SetHasTexfield ���� ��������Ʈ
	RegisterDelegateHandler(EDHandler_Container);

	//���� ����
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_ShortcutAPI);

	//�ɼ� ���� ��������Ʈ
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Option);
	
	//�Է� ���� ��������Ʈ
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_InputAPI);

	//���̴� ���� ��������Ʈ
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_RadarMap);

	//����ų� ��ų . ��ų ��� ����
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_UseSkill);

	//���� ���� ��������Ʈ
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_FishWnd);

	//�Ʒ��� ���� ��������Ʈ
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Arena);

	//�α��� �߰� �̿��� ����
	//RegisterDelegateHandler(EDelegateHandlerType.EDHandler_LoginPIAgreementWnd);
	//�����Ƽ ���� ��������Ʈ
	//RegisterDelegateHandler(EDelegateHandlerType.EDHandler_AbilityWnd);
	//���� ���� �ý���
	//RegisterDelegateHandler(EDelegateHandlerType.EDHandler_PledgeRecruit);
	// ���� �̹��� ���� �� �ֵ��� ����
	//SetImageLoader(EFlashImageLoaderType.EImgLoader_Pledge);

	AllocGFxValue(l2SysStringTranslator);
	AllocGFxValue(obj);

	//GetVariable(obj,"_root.l2SysStringTranslator");
	
	GetFunction(l2SysStringTranslator, EExternalFunctionType.EFunc_SysStringTranslator);
	obj.SetMemberValue("getTranslatedString", l2SysStringTranslator);

	DeallocGFxValue(l2SysStringTranslator);
	DeallocGFxValue(obj);
}

function OnFocus(bool bFlag, bool bTransparency)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	args[0].SetBool(bFlag);
	args[1].SetBool(bTransparency);
	AllocGFxValue(invokeResult);
	Invoke("onFocusContainer", args, invokeResult);
	
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case EV_NotifyBeforeStateChanged://3411 EV_StateChanged:
			handleNotifyBeforeStateChanged ( a_Param ) ;
			break;
		case EV_StateChanged:
			if ( a_Param == "CHARACTERCREATESTATE" )
				SetAlwaysOnBack(True);
			else if ( a_Param == "GAMINGSTATE" )
				SetAlwaysOnBack(True);
			break;

		/*
			args[1].SetMemberString( "state" , a_Param );		
			invoke("onChangeState", args, invokeResult);
			
			if ( a_Param == registedState )
			{
				Invoke("onEnterState", args, invokeResult);
			}
			else 
			{
				Invoke("onExitState", args, invokeResult);			
			}
		break;
		case EV_ResolutionChanged:
			//Debug( "EV_ResolutionChanged" @  a_Param );
			ParseInt(a_Param, "NewWidth", _width);
			ParseInt(a_Param, "NewHeight", _height);
				
			args[1].SetMemberInt( "NewWidth" , _width );		
			args[1].SetMemberInt( "NewHeight" , _height );		
			invoke( "onResolutionChanged", args, invokeResult);
		case EV_ReceiveWindowsInfo :
			invoke( "onReceiveWindowsInfo", args, invokeResult);
		break;
	*/
	}
}

function handleNotifyBeforeStateChanged(string param)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);

	args[0].SetInt(EV_NotifyBeforeStateChanged);
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
 **/
function OnReceivedCloseUI()
{
	invokeToFlash("onPressESC");
}

function OnDefaultPosition()
{
	invokeToFlash("onDefaultPosition");
}

function invokeToFlash(string invokeID)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 1);
	//args[0].setMemberString ( "param", param) ;

	Invoke( invokeID, args, invokeResult);

	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
}

defaultproperties
{
}
