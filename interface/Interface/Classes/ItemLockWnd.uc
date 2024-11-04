class ItemLockWnd extends UICommonAPI;

///////////////////////////////////////////////////////////////////////////////////////////
//	ItemLockWnd 1.0																//
///////////////////////////////////////////////////////////////////////////////////////////

// ���
// 1. ���ΰ�, ���� â�� ����
// 2. ���¿� ���� ����
//  ���� <-> ��� -> ���
//  ���� <-> ��� -> ���

const       C_ANIMLOOPCOUNT = 1;

enum WindowType 
{
	LOCK,
	UNLOCK,
	ERROR
};

enum StateStep 
{
	START,
	READY,
	POPUP,
	PROGRESS,
	END
} ;

// �ڽ�
var WindowHandle        Me ;
// ��� ����
var TextBoxHandle       Instruction_Txt ;
// ������ �̸�
var TextBoxHandle       ItemName_Txt ;
// ���� �ֹ��� �ؽ�Ʈ
var TextBoxHandle       ItemLockPaperTitle_txt ;
// ���� �ֹ��� �ؽ�Ʈ
var TextBoxHandle       ItemUnLockPaperTitle_txt ;
// �ֹ��� ����
var TextBoxHandle       ItemLockPaperinput_txt ;
// ����, ���� ������ 
var ItemWindowHandle    ItemLock_ItemWindow ;
// ����, ���� ���α׷��� ��
var ProgressCtrlHandle	itemLock_Progress ;
var ProgressCtrlHandle	itemUnLock_Progress ;
var ProgressCtrlHandle  currentProgress;

// ��ư
var ButtonHandle        ItemLockBtn ;
// ���
var WindowHandle        ItemLockAlert_Wnd ;
var WindowHandle        DisableWnd ;
// ���� â
var WindowHandle        SubWnd ;
var ItemLockSubWnd      ItemLockSubWndScript;

// ������ ��� ���� ����Ʈ 
var TextureHandle       DropHighlight_ItemLock_AniPanel;


// ���� 
var WindowType          currentWindowType ;

var StateStep           currentState ;
// ���� ��ũ�� ID 
var int                 currentScrollItemClassID ;
// ���� ��ũ�� ����
var int64               currentScrollNum;

var InventoryWnd inventoryWndScript ;
	

// ���� �ʱ�ȭ
function Initialize()
{	
	currentState = stateStep.START;
}


function OnLoad()
{
	SetClosingOnESC();
	
	Me = GetWindowHandle( "ItemLockWnd" );

	Instruction_Txt             = GetTextBoxHandle (  "ItemLockWnd.Instruction_Txt"  );
// ������ �̸�
	ItemName_Txt                = GetTextBoxHandle (  "ItemLockWnd.ItemName_Txt"  );
// ���� �ֹ��� �ؽ�Ʈ
	ItemLockPaperTitle_txt	    = GetTextBoxHandle (  "ItemLockWnd.ItemLockPaperTitle_txt"  );
// ���� �ֹ��� �ؽ�Ʈ
	ItemUnLockPaperTitle_txt	= GetTextBoxHandle (  "ItemLockWnd.ItemUnLockPaperTitle_txt"  );
// ����, ���� ������ 
	ItemLock_ItemWindow	        = GetItemWindowHandle (  "ItemLockWnd.ItemLock_ItemWindow"  );
// ����, ���� ���α׷��� ��
	itemLock_Progress	        = GetProgressCtrlHandle("ItemLockWnd.itemLock_Progress");
	itemUnLock_Progress	        = GetProgressCtrlHandle("ItemLockWnd.itemUnLock_Progress");
// ��ư
	ItemLockBtn	                = GetButtonHandle (  "ItemLockWnd.ItemLockBtn"  );

	DisableWnd                  = GetWindowHandle( "ItemLockWnd.DisableWnd" );
	ItemLockAlert_Wnd           = GetWindowHandle( "ItemLockWnd.ItemLockAlert_Wnd" );

	ItemLockPaperinput_txt      = GetTextBoxHandle ( "ItemLockWnd.ItemLockPaperinput_txt"  );

	SubWnd                      = GetWindowHandle( "ItemLockSubWnd");

	ItemLockSubWndScript        = ItemLockSubWnd( GetScript ( "ItemLockSubWnd" ) );

	DropHighlight_ItemLock_AniPanel = GetTextureHandle ( "ItemLockWnd.DropHighlight_ItemLock_AniPanel");

	//itemLock_Progress.SetProgressTime(1500);	        
	//itemUnLock_Progress.SetProgressTime(1500);

	inventoryWndScript =InventoryWnd ( GetScript ("InventoryWnd") );

	if ( getInstanceUIData().getIsClassicServer() ) GetButtonHandle (  "ItemLockWnd.BtnWindowHelp"  ).HideWindow();	
}

function OnRegisterEvent()
{
	RegisterEvent ( EV_LockedItemShow  ) ;
	RegisterEvent ( EV_LockedResult  ) ;
}

function onShow()
{ 
	// ������ �����츦 ������ �ݱ� ��� 	
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)));
	Initialize();
	
	setWindowByType();
	handleState () ;

	SubWnd.ShowWindow();
}

function OnHide()
{		
	
//	Debug("onHide");
	// ���� ���
	switch ( currentWindowType) 
	{
		case LOCK :
			RequestLockedItemCancel();
		break;
		case UNLOCK:
			RequestUnlockedItemCancel();
		break;
	}
}

function OnClickButton( string Name )
{
	//Debug( "OnClickButton"  @ Name);
	switch( Name )
	{
		case "ItemLockBtn":
			// �ʱ�ȭ
			switch ( currentState ) 
			{
				// �˾��� ���� �ش�.
				case stateStep.READY :	
					if ( currentWindowType == LOCK ) 
						currentState = stateStep.POPUP;
					else 
						currentState = stateStep.PROGRESS;
				break;				
				case stateStep.PROGRESS :
					currentState = stateStep.READY;	
				break;
				case stateStep.END :
					scrollItemReuse () ;					
					//currentState = stateStep.START;
				break;			
			}	
		break;
		case "AlertWnd_Confirm_Btn" :
			currentState = stateStep.PROGRESS ;			
			break ;
		case "AlertWnd_Close_Btn" : 
			currentState = stateStep.READY;						
			break;
		case "BtnWindowHelp": 
			ExecuteEvent(EV_ShowHelp, "131");
			return;
			break;
	}

	handleState () ;	
}

function scrollItemReuse () 
{
	local iteminfo outinfo ;
	local itemID id;
	
	id.classID = currentScrollItemClassID;
	inventoryWndScript.getInventoryItemInfo( id, outinfo, true ) ;
	RequestUseItem(outinfo.ID);
}

function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{	
	if ( a_ItemInfo.DragSrcName != "ItemLockSubWnd_Item1" ) return;		

	setItemInfo ( a_ItemInfo ) ;
	//if ( X > rectWnd.nX + 9 && X < rectWnd.nWidth + 9 && Y > rectWnd.nY + 39 && Y < rectWnd.nHeight + 39 )//���� ����		
}


function OnEvent(int Event_ID, string param)
{
	//Debug("OnEvent" @ Event_ID @ param);
	switch ( Event_ID ) 
	{
		case EV_LockedItemShow :			
			setShow( param ) ;
		break;
		case EV_LockedResult :
			handleResult (param )  ;			
			handleState();
		break;
	}
}

function OnProgressTimeUp ( string strID ) 
{
	switch ( strID ) 
	{
		case "itemLock_Progress":
			RequestLockedItem ( getCurrentItemServerID () ) ;
			//Debug ( "RequestLockedItem" @ getCurrentItemServerID () ) ;
			ItemLockBtn.DisableWindow();
		break;
		case "itemUnLock_Progress":
			RequestUnLockedItem ( getCurrentItemServerID () ) ;
			//Debug ( "itemUnLock_Progress" @ getCurrentItemServerID () ) ;
			ItemLockBtn.DisableWindow();
		break;
		
	}
}

/************************************************************ ���� ********************************************************************/

// ��ũ�� ����
function setScrollNum ( int classID ) 
{	
	currentScrollNum = inventoryWndScript.getItemCountByClassID( classID ) ;

	if ( currentScrollNum == 0 ) 
		 ItemLockPaperinput_txt.SetTextColor( getInstanceL2Util().DRed ) ;
	else ItemLockPaperinput_txt.SetTextColor( getInstanceL2Util().White ) ;

	ItemLockPaperinput_txt.SetText( String(currentScrollNum) ) ;
}

// ������ ����
function setItemInfo ( itemInfo a_ItemInfo ) 
{
	if ( currentState != stateStep.START && currentState != stateStep.READY) return;

	ItemLock_ItemWindow.SetItem( 0, a_ItemInfo );
	ItemLock_ItemWindow.AddItem( a_ItemInfo );	

	// ������ �̸� ��� 

	ItemName_Txt.SetText ( GetItemNameAll (a_ItemInfo) ) ;	

	DropHighlight_ItemLock_AniPanel.HideWindow();

	currentState = READY;	
	handleState () ;
}

function setShow( string param ) 
{	
	local string LockType;

	parseString ( param, "LockType", LockType ) ;

	switch ( LockType ) 
	{
		case "Error" :
			currentWindowType = ERROR;
			Me.HideWindow();						
			break;
		case "UnLock" :
			currentWindowType = UNLOCK;
			if ( Me.IsShowWindow() ) onShow();
			Me.ShowWindow();
			break;
		case "Lock" :
			currentWindowType = LOCK;
			if ( Me.IsShowWindow() ) onShow();
			Me.ShowWindow();
			break;
	}

	parseInt ( param, "ScrollItemClassID", currentScrollItemClassID );
	setScrollNum ( currentScrollItemClassID ) ;
}

/*********************************************** ������ ���� **************************************************************/
function  handleClearItem( )
{			
	ItemLock_ItemWindow.Clear();
	// ������ �̸� ��� 	
	ItemName_Txt.SetText ( "" ) ;	
	DropHighlight_ItemLock_AniPanel.ShowWindow();
}

/*******************************************************************************************************************
* ������ ���� ó��
*******************************************************************************************************************/
/***************************************************** ������ Ÿ�� ************************************************/
function setWindowByType ( ) 
{
	if(currentWindowType == LOCK)
	{
		itemUnLock_Progress.HideWindow();
		setWindowTitleByString(GetSystemString(3770));
		ItemLockPaperTitle_txt.SetText(GetSystemString ( 3772 ));	
		ItemLockPaperTitle_txt.SetTextColor(getColor(255, 153, 0, 255)) ;
		currentProgress = itemLock_Progress;
	}
	else
	{
		itemLock_Progress.HideWindow();
		setWindowTitleByString(GetSystemString(3771));
		ItemLockPaperTitle_txt.SetText(GetSystemString(3773));
		ItemUnLockPaperTitle_txt.ShowWindow();
		ItemLockPaperTitle_txt.SetTextColor(getColor(136, 255, 255, 255));
		currentProgress = itemUnLock_Progress;
	}

	currentProgress.ShowWindow();
}

/***************************************************** ������Ʈ  ************************************************/
// ������Ʈ�� ���� ������ ���� ó��

function handleState () 
{
	setWindowByState();
	setButtonByState () ;
	setWindowInstruction() ;
}

function setWindowByState () 
{
	switch ( currentState ) 
	{
		case START :
			hideAlert();			
			handleClearItem();
			ItemLockSubWndScript.syncInventory();
			ItemLockSubWndScript.setLock( false ) ;
		case READY:
			currentProgress.Reset();
			//currentProgress.SetPos(0);
			hideAlert() ;
			ItemLockSubWndScript.setLock( false ) ;
		break;		
		case POPUP :
			showAlert();
		break;
		case PROGRESS : 
			ItemLockSubWndScript.setLock( true ) ;
			Playsound("ItemSound3.enchant_process");
			currentProgress.SetProgressTime(1500);
			currentProgress.Reset();			
			currentProgress.Start();
			hideAlert() ;
		break;
		case END:   			
			ItemLockSubWndScript.syncInventory();
			ItemLockSubWndScript.setLock( true ) ;
		break;
	}
}

// ��ư ó�� 
function setButtonByState () 
{
	local int buttonString;
	if( currentWindowType == LOCK ) 
	{
		switch ( currentState ) 
		{
			case START :
				buttonString = 3774;
				ItemLockBtn.DisableWindow();				
			break;	
			case READY : 
				buttonString = 3774;
				ItemLockBtn.EnableWindow();
			break;
			case PROGRESS :
				buttonString = 141;		
			break;
			case END:
				buttonString = 1731;	
				//Debug ( "handleState" @  currentScrollNum  ) ;
				if ( currentScrollNum > 0 ) ItemLockBtn.EnableWindow();
			break;
		default: return;
		}
	}
	else	
	{
		switch ( currentState ) 
		{
			case START :
				buttonString = 3808;
				ItemLockBtn.DisableWindow();				
			break;	
			case READY : 
				buttonString = 3808;
				ItemLockBtn.EnableWindow();
				break;
			case PROGRESS :
				buttonString = 141;		
			break;
			case END:
				buttonString = 1731;	
				//Debug ( "handleState" @  currentScrollNum  ) ;
				if ( currentScrollNum > 0 )  ItemLockBtn.EnableWindow();
			break;
			default: return;
		}
	}

	ItemLockBtn.SetButtonName( buttonString );
}


// ��� �ȳ� ���� ����
function setWindowInstruction( ) 
{
	local int systemMessage;
	if( currentWindowType == LOCK ) 
	{
		switch ( currentState ) 
		{
			case START :
				systemMessage = 5129;				
			break;
			case READY :
				systemMessage = 5130;
			break;
			case END:
				systemMessage = 5121;
			break;
			default: return;
		}
	}
	else
	{
		switch ( currentState ) 
		{
			case START :				
				systemMessage = 5132;
			break;						
			case READY : 
				systemMessage = 5133;
				break;
			case END:   
				systemMessage = 5122;				
			break;
			default: return;
		}
	}

	Instruction_Txt.SetText(GetSystemMessage( systemMessage ));
}


/*********************************************** ������ ���� �� ������ �ʿ� �ϴٴ� ��� ���� **************************************************************/
function showAlert( )
{
	DisableWnd.ShowWindow();
	ItemLockAlert_Wnd.ShowWindow();
}

function hideAlert () 
{
	DisableWnd.HideWindow();
	ItemLockAlert_Wnd.HideWindow();
}

/*********************************************** ���� �ޱ� **************************************************************/
function int getCurrentItemServerID () 
{
	local itemInfo info ; 

	ItemLock_ItemWindow.GetItem( 0, info );

	if ( IsValidItemID( info.ID)  ) return info.ID.serverID  ;
	return - 1;
}

/*********************************************** ��æ ���� **************************************************************/
function handleResult ( string param ) 
{
	local int result ;	
	local itemInfo info;

	parseInt ( param, "Result", result ) ;
	if ( result == 0 ) 
	{
		Me.HideWindow();
		//if ( currentWindowType == LOCK ) RequestLockedItemCancel();
		//else RequestUnlockedItemCancel();
		//currentState = START;
	}
	else 
	{			
		ItemLock_ItemWindow.GetItem( 0, info );
		info.bSecurityLock = currentWindowType == LOCK;
		
		ItemLock_ItemWindow.SetItem( 0, info );
		ItemLock_ItemWindow.AddItem( info );



		switch ( currentWindowType ) 
		{
		case LOCK : 		
			AddSystemMessage( 5121 );
			break;
		case UNLOCK : 
			AddSystemMessage( 5122 );
			break;
		}
		 
		setScrollNum ( currentScrollItemClassID ) ;
		Playsound("ItemSound3.enchant_success");	
		currentState = END;
	}
}


/******************************************************** API ****************************************/
// ���� ��û
function RequestLockedItem  ( int targetItemID )
{
	class'EnchantAPI'.static.RequestLockedItem ( targetItemID ) ;
}

// ����
function RequestUnlockedItem ( int targetItemID )
{
	class'EnchantAPI'.static.RequestUnlockedItem( targetItemID );
}

// ���� ���
function RequestUnlockedItemCancel ( )
{
	class'EnchantAPI'.static.RequestUnlockedItemCancel( );
}

// ���� ���
function RequestLockedItemCancel  ()
{
	class'EnchantAPI'.static.RequestLockedItemCancel();
}

 

/*********************************************** ���� �ݱ� **************************************************************/
function ToggleShowWindow()
{	
	if (Me.IsShowWindow())
		Me.HideWindow();
	else 
		Me.ShowWindow();
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "ItemLockWnd" ).HideWindow();
}

defaultproperties
{
}
