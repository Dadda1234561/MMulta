class EffectTester extends L2UIGFxScriptNoneContainer;

function OnRegisterEvent()
{	
	RegisterEvent(EV_Test_9);
}

function OnLoad()
{
	SetClosingOnESC();	
	//SetContainerWindow( WINDOWTYPE_DECO_NORMAL, 0);
	AddState("GAMINGSTATE");
	
	//�����ϸ� ó�� ���� �������� ���� ��
	//SetDefaultShow(true);
	//SetRenderOnTop(true);
	//SetAlwaysOnTop(true);
	//SetHavingFocus( false );
}

//function onFocus ( bool bFlag, bool bTransparency ) 
//{
//	if ( bFlag ) 
//	{
//		class'UIAPI_WINDOW'.static.BringToFront("EffectWnd") ;
//	}	
//}

function onEvent ( int id , string param  ) 
{
	ShowWindow( "EffectTester");	
	//CallUcFunction ( "EffectTester", "show", "");
}

function OnFlashLoaded () 
{	
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Container);

	//�ɼ� ���� ��������Ʈ
	//RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Option);

	////�⺻ ���� ��������Ʈ? �ɼǿ��� ��� ���̾���
	//RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Default);

}


////�׽�Ʈ�� �Լ�
//function onCallUCFunction( string functionName, string param )
//{	
//	Debug("sampe's onCallUCFunction" @ functionName @ param);
//	switch ( functionName ) 
//	{
//		case "sunnomMonster" :
//			ouputCheck( param );
//		break;
//	}
//}

defaultproperties
{
}
