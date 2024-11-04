class UIDebugWnd extends GFxUIScript;

var array<GFxValue> args;
var GFxValue invokeResult;

var bool bShow;

function OnRegisterEvent()
{
	//���� �˸� �̺�Ʈ
	RegisterEvent( EV_FlashDebugMsg );
}

function OnLoad()
{
	RegisterState( "UIDebugWnd", "GamingState" );
}

function OnShow()
{
	bShow = true;
	AddSystemMessageString("UIDebug!!!! onShow");	
}

function OnFlashLoaded()
{	
}

function OnHide()
{
	bShow = false;
}

function OnEvent(int Event_ID, string param)
{
	if ( Event_ID == EV_FlashDebugMsg )
	{
		ShowWindow();
		AddSystemMessageString( param );
		if( bShow == true )
		{
			SendFlashDebug( param );
		}
	}
}

function SendFlashDebug(string param)
{
	// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);

	// �ߵ� ��ų ���� : �̺�Ʈ ��ȣ 0��
	args[0].SetInt( 0 );

	CreateObject(args[1]);
	args[1].SetMemberString( "Trace" , param );

	Invoke( "_root.onEvent", args, invokeResult );

	DeallocGFxValue( invokeResult );
	DeallocGFxValues( args );
}

defaultproperties
{
}
