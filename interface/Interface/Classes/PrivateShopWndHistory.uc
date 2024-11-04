/***
 *   ���� ���� ����Ʈ
 **/
class PrivateShopWndHistory extends UICommonAPI;

var WindowHandle Me;

var ListCtrlHandle ItemListCtrl;
var ButtonHandle   closeBtn;

var PrivateShopWndReport PrivateShopWndReportScript;

function Initialize()
{
	SetClosingOnESC();
	Me = GetWindowHandle( "PrivateShopWndHistory" );
	ItemListCtrl = GetListCtrlHandle( "PrivateShopWndHistory.ItemList" );
	closeBtn = GetButtonHandle( "PrivateShopWndHistory.closeBtn" );	
	PrivateShopWndReportScript = PrivateShopWndReport( GetScript ( "PrivateShopWndReport"));

	// ���� Ŭ�� ���ص� ��������..
	ItemListCtrl.SetSelectedSelTooltip(false);	
	ItemListCtrl.SetAppearTooltipAtMouseX(true);
	Init();

}

function OnRegisterEvent()
{	
	//RegisterEvent(EV_ChatMessage);
	RegisterEvent( EV_Restart );
	//RegisterEvent( EV_PrivateStoreBuyingResult );
	//RegisterEvent( EV_PrivateStoreSellingResult );
}

function onEvent ( int Event_ID, string param ) 
{
	switch( Event_ID )
	{
		//case EV_ChatMessage:
		//	 handleChatMessage( param ) ;
			 //break;
		case EV_Restart:
			 itemListCtrl.DeleteAllItem();
			 break;
		//case EV_PrivateStoreBuyingResult :			 
		//	 break;
		//case EV_PrivateStoreSellingResult:
		//	 break;

	}
}

function OnLoad()
{
	Initialize();
//	setDefaultShow(true);
}

function OnShow()
{
	Me.SetFocus();
}

function OnHide()
{
	Init();
}

// OnClickButton
function OnClickButton( string Name )
{
	switch( Name )
	{
		case "close_Btn":
			 Me.hideWindow() ;
			 break;
	}
}

// �ʱ�ȭ
function Init()
{
	//itemListCtrl.DeleteAllItem();
}


/*********************************************************************************************************
 * ����Ʈ ���ϱ� 
 * *******************************************************************************************************/
function color getcolorbymessagetype () 
{
	switch ( PrivateShopWndReportScript.messagetype ) 
	{
		case "bulksell" :   return getcolor(255, 119, 119, 255);
		break;
		case "sell" :       return getcolor(221, 119, 238, 255);	
		break;
		case "buy" :        return getcolor(170, 204, 17, 255);
		break;
	}
}

function addHistory ( String itemName, bool isStackable, int64 itemNum, string userName ) 
{
	local int systemMsgNum;
	local string systemMsg;	
	
	switch ( PrivateShopWndReportScript.messageType ) 
	{
		case "bulksell" :  			
		case "sell" :      
			if ( isStackable ) systemMsgNum = 380 ; else systemMsgNum = 378 ; 
		break;
		case "buy" :        				
			if ( isStackable ) systemMsgNum = 561 ; else systemMsgNum = 559 ; 
			
		break;
	}

	if ( isStackable ) 
		systemMsg = MakeFullSystemMsg ( GetSystemMessage(systemMsgNum), userName, itemName, String(itemNum) ) ;
	else
		systemMsg = MakeFullSystemMsg (  GetSystemMessage(systemMsgNum), userName, itemName ) ;			
	
	ItemListCtrl.InsertRecord( makeRecord ( systemMsg, getcolorbymessagetype(), userName ));
}

function LVDataRecord makeRecord ( string message, color messageColor, string userName )
{
	local LVDataRecord Record;	
	local int textWidth, textHeight ;

	// ���� Ŭ�� �� �Ӹ� ó�� �Ϸ� ������ ���� 
//	Record.szReserved = userName;	
	Record.LVDataList.length = 1;

	GetTextSizeDefault( message  , textWidth, textHeight);

	Record.LVDataList[0].buseTextColor = true;		
	Record.LVDataList[0].textColor = messageColor;
	Record.LVDataList[0].textAlignment = TA_LEFT;

	if ( textWidth > 430 ) 
	{
		Record.szReserved = message ;
		Record.LVDataList[0].szData = ellipsisWidth ( message, 430  ) ;	
		Record.nReserved1 = int (messageColor.R) ;
		Record.nReserved2 = int (messageColor.G) ;
		Record.nReserved3 = int (messageColor.B) ;
	}
	else Record.LVDataList[0].szData = message;

	return Record;
}

/* ������ ǥ�� */
function string ellipsisWidth ( string text, int maxWidth ) 
{
	local int nWidth, nHeight, i ;	
	
	GetTextSizeDefault( text $ ".."  , nWidth, nHeight);
	if ( nWidth  < maxWidth ) return text;

	for ( i = 0 ; i < 200 ; i ++ ) 
	{	
		GetTextSizeDefault( text $ ".."  , nWidth, nHeight);			
		if ( nWidth  < maxWidth ) return  text$"..";
		text = mid(text, 0, len(text) - 1);		
		//text
	}
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);	
	GetWindowHandle( "PrivateShopWndHistory"  ).HideWindow();
}

defaultproperties
{
}
