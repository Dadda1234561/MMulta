class CardDrawEventWnd extends L2UIGFxScriptNoneContainer;

var String gameTryCount ;

var InventoryWnd inventoryWndScript;

function OnRegisterEvent()
{	
	RegisterGFxEvent(EV_CardUpdownGameStart);
	RegisterGFxEvent(EV_CardUpdownGamePickResult);
	RegisterGFxEvent(EV_CardUpdownGamePrepReward);
	RegisterGFxEvent(EV_CardUpdownGameRewardReply); //6000
	RegisterGFxEvent(EV_CardUpdownGameQuit ); //6000
	
	//RegisterGFxEvent(EV_Test_8); 	
	//RegisterGFxEvent(EV_Test_6); 
	//RegisterGFxEvent(EV_Test_5); 
	//RegisterGFxEvent(EV_Test_7); 
}

function onCallUCFunction ( string id, string param ) 
{		
	// 13�ֳ� ������ �̺�Ʈ �޾� ����

	switch ( id ) 
	{
		case "getItemCount" :			 
			gameTryCount = String(inventoryWndScript.getItemCountByClassID ( int ( param ) )) ;
		break;
	}
}

function onShow()
{
	//if (class'UIAPI_WINDOW'.static.IsShowWindow("CardDrawEventWnd"))
	//	class'UIAPI_WINDOW'.static.HideWindow("CardDrawEventWnd");

	if (class'UIAPI_WINDOW'.static.IsShowWindow("ItemUpgrade"))
		class'UIAPI_WINDOW'.static.HideWindow("ItemUpgrade");

	if (class'UIAPI_WINDOW'.static.IsShowWindow("ElementalSpiritWnd"))
		class'UIAPI_WINDOW'.static.HideWindow("ElementalSpiritWnd");
	super.onShow();
}


function OnLoad()
{	
	SetClosingOnESC();
	//registerState( "CardDrawEventWnd", "GamingState" );	
	AddState("GAMINGSTATE");	
	//setDefaultShow(true);
	inventoryWndScript = inventoryWnd(GetScript("inventoryWnd"));
	//SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0 , 0);
}

function OnFlashLoaded()
{	
	//RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Container);

	//ī�� ���� ��������Ʈ 
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_CardUpdownGame);

	//�ɼ� ���� ��������Ʈ
	//RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Option);

	//�⺻ ���� ��������Ʈ? �ɼǿ��� ��� ���̾���
	//RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Default);

	// ���� ����Ÿ �� �ޱ� ����
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_GameData);

	//SetAlwaysOnTop(true);
}

defaultproperties
{
}
