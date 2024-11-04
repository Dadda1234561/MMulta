class PayBackWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle DisableWnd;
var TextBoxHandle Disable_Txt;
var WindowHandle PayBackTabWnd;

var ButtonHandle PayBackHelp_Btn;
var ButtonHandle PayBackMyCostRefresh_Btn;
var ItemWindowHandle PayBackItemWindow;
var TextBoxHandle PayBackDesc_Txt;
var TextBoxHandle PayBackTitle_Txt;
var TextBoxHandle PayBackMyCostTitle_Txt;
var TextBoxHandle PayBackMyCostNum_Txt;
var TextBoxHandle Complet_text;

var string m_WindowName;

var L2Util util;

struct PayBackItemInfo 
{
	//(enum PAYBACK_EVENT_ID_TYPE)
	var int EventIDType;
	// ���̹� ��� �� �ε���
    var int SetIndex;
	// ���� ���� ������ �ʿ� ����
    var int Requirement;	
	// 0: ���� �̼���, 1: ���� ���� �Ϸ�
	var int Received;

	// ���� ������ ���� : ��ȹ���� MAX 3����
	var int RewardItemCount;

	var array<int> RewardItemClassId;
	var array<int> RewardItemAmount;	
};

//����Ʈ ���� �迭 ( üũ ���¿� ���� �������ų� �Ⱥ��� �� �� �����Ƿ�, 
var array<PayBackItemInfo> itemListArray;

var int ConsumedItemAmount;

//��� ���ſ� Ÿ�̸� ID
const TIMER_CLICK       = 69901;
//��� ���ſ� Ÿ�̸� ������ 3��
const TIMER_DELAYC       = 3000;



function OnRegisterEvent()
{
	RegisterEvent( EV_PaybackListBegin );
	RegisterEvent( EV_PaybackListInfo );
	RegisterEvent( EV_PaybackListEnd );

	RegisterEvent( EV_PaybackGiveReward );

	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle( m_WindowName );
	DisableWnd = GetWindowHandle( "PayBackWnd.DisableWnd" );
	Disable_Txt = GetTextBoxHandle( "PayBackWnd.DisableWnd.Disable_Txt" );

	PayBackTabWnd = GetWindowHandle( "PayBackWnd.PayBackTabWnd" );

	PayBackHelp_Btn = GetButtonHandle( "PayBackWnd.PayBackTabWnd.PayBackHelp_Btn" );
	PayBackMyCostRefresh_Btn = GetButtonHandle( "PayBackWnd.PayBackTabWnd.PayBackMyCostRefresh_Btn" );
	//���
	PayBackItemWindow = GetItemWindowHandle( "PayBackWnd.PayBackTabWnd.PayBackItemWindow" );

	PayBackDesc_Txt = GetTextBoxHandle( "PayBackWnd.PayBackTabWnd.PayBackDesc_Txt" );
	//���
	PayBackTitle_Txt = GetTextBoxHandle( "PayBackWnd.PayBackTabWnd.PayBackTitle_Txt" );

	PayBackMyCostTitle_Txt = GetTextBoxHandle( "PayBackWnd.PayBackTabWnd.PayBackMyCostTitle_Txt" );
	PayBackMyCostNum_Txt = GetTextBoxHandle( "PayBackWnd.PayBackTabWnd.PayBackMyCostNum_Txt" );


	
	util                       = L2Util(GetScript("L2Util"));

	initUI();
}


function Load()
{
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "PayBackHelp_Btn":
		OnPayBackHelp_BtnClick();
		break;
	case "PayBackMyCostRefresh_Btn":
		//��� ���ſ� Ÿ�̸� ����
		Me.SetTimer( TIMER_CLICK, TIMER_DELAYC );
		//��ư ��Ȱ��
		PayBackMyCostRefresh_Btn.DisableWindow();
		OnPayBackMyCostRefresh_BtnClick();
		break;
	}
}

function OnClickButtonWithHandle( ButtonHandle a_ButtonHandle )
{
	local array<string> arr;
	local int num;

	if( a_ButtonHandle.GetWindowName() == "Reward_Btn")
	{
		Split( a_ButtonHandle.GetParentWindowName(), "_", arr);

		num = int( Right( arr[1], 2) );

		//Debug("RequestPaybackGiveReward->" @ itemListArray[num].EventIDType@"&&"@ itemListArray[num].SetIndex);
		RequestPaybackGiveReward( itemListArray[num].EventIDType, itemListArray[num].SetIndex);
	}
}


function OnShow()
{
	Me.SetFocus();
	PlayConsoleSound(IFST_WINDOW_OPEN);
}


function initUI()
{
	local int i;

	for( i = 0 ; i < 10 ; i++)
	{
		GetWindowHandle( m_WindowName $ ".PayBack_Contents0" $ i $ "_Wnd" ).HideWindow();
		GetItemWindowHandle( m_WindowName $ ".PayBack_Contents0" $ i $ "_Wnd.Contents_ItemWindow" ).Clear();
	}

	PayBackDesc_Txt.SetText( "" );
	PayBackMyCostNum_Txt.SetText( "" );
	PayBackTitle_Txt.SetText( "" );

	ClearAll();
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
// OnEvent
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnEvent( int Event_ID, string param )
{
	switch( Event_ID )
	{
		case EV_PaybackListBegin :
			//Debug("--- EV_PaybackListBegin : " @ param);
			HandleItemBegin(param);			
			break;

		case EV_PaybackListInfo :
			//Debug("--- EV_PaybackListInfo : " @ param);
			HandleItemList(param);			
			break;

		case EV_PaybackListEnd:
			HandleItemEnd(param);
			//Debug("--- EV_PaybackListEnd : " @ param);
			break;

		case EV_PaybackGiveReward:
			Debug("--- EV_PaybackGiveReward : " @ param);
			RewardComplete( param );
			break;


		case EV_DialogOK :
			//HandleDialogOK();

			break;
		case EV_DialogCancel :
			//HandleDialogCancel();
			break;
	}
}

function HandleItemBegin( string param )
{
	local ItemInfo itemInfo;
	local int ConsumedItemClassID;
	local string str;
	local int EventEndYear;
	local int EventEndMonth;
	local int EventEndDay;
	local int EventEndHour;
	initUI();

	parseInt ( param, "ConsumedItemClassID", ConsumedItemClassID );
	parseInt ( param, "ConsumedItemAmount", ConsumedItemAmount );

	parseInt ( param, "EventEndYear", EventEndYear );
	parseInt ( param, "EventEndMonth", EventEndMonth );
	parseInt ( param, "EventEndDay", EventEndDay );
	parseInt ( param, "EventEndHour", EventEndHour );

	itemInfo = GetItemInfoByClassID(ConsumedItemClassID);	
	
	PayBackItemWindow.Clear();
	PayBackItemWindow.AddItem( itemInfo );
	PayBackItemWindow.SetTooltipType( "Inventory");

	PayBackTitle_Txt.SetText(itemInfo.Name);
	

	str = MakeFullSystemMsg( GetSystemMessage(2201), string(EventEndYear), string(EventEndMonth), string(EventEndDay));
	str = str@MakeFullSystemMsg( GetSystemMessage(2204), string(EventEndHour) );

	PayBackDesc_Txt.SetText( MakeFullSystemMsg( GetSystemMessage(5261), str) );
	PayBackMyCostNum_Txt.SetText( string(ConsumedItemAmount) );
}

/***************************************************************************************************************
 * ����Ʈ ���� 
 * *************************************************************************************************************/

function HandleItemList( string param )
{	
	local PayBackItemInfo _limitShopItemInfo;
	local int i;

	parseInt ( param, "EventIDType", _limitShopItemInfo.EventIDType );
	parseInt ( param, "SetIndex", _limitShopItemInfo.SetIndex );
	parseInt ( param, "Requirement", _limitShopItemInfo.Requirement );
	parseInt ( param, "Received", _limitShopItemInfo.Received );

	parseInt ( param, "RewardItemCount", _limitShopItemInfo.RewardItemCount );

	_limitShopItemInfo.RewardItemClassId.Length = _limitShopItemInfo.RewardItemCount;
	_limitShopItemInfo.RewardItemAmount.Length = _limitShopItemInfo.RewardItemCount;

	for( i = 0 ; i < _limitShopItemInfo.RewardItemCount ; i++)
	{
		parseInt ( param, "RewardItemClassId_"$i, _limitShopItemInfo.RewardItemClassId[i]);
		/* PC �� ����Ʈ �׽�Ʈ��
		if( _limitShopItemInfo.CostItemId[i] != 0 )
		{
			_limitShopItemInfo.CostItemId[i] = -100;
		}*/
		//cID = GetItemInfoByClassID(_limitShopItemInfo.RewardItemClassId[i]);
		parseInt ( param, "RewardItemAmount_"$i, _limitShopItemInfo.RewardItemAmount[i]);
	}

	//������ ���� �迭�� insert
	itemListArray.Insert( itemListArray.Length, 1 );
	itemListArray[ itemListArray.Length - 1] = _limitShopItemInfo;
}

function HandleItemEnd( string param ) 
{
	if( itemListArray.Length == 0 )
	{
		PayBackDesc_Txt.SetText( "" );
		PayBackMyCostNum_Txt.SetText( "" );
		PayBackTitle_Txt.SetText( "" );
		DisableWnd.ShowWindow();
	}
	else
	{
		listAddItem();
		DisableWnd.HideWindow();
	}
	Me.ShowWindow();
}

function listAddItem()
{
	local int i,j;
	local WindowHandle wnd;
	local ItemInfo info;

	//�Ҹ� �׽�Ʈ
	//ConsumedItemAmount = 250;

	for( i = 0 ; i < itemListArray.Length ; i++)
	{
		wnd = GetWindowHandle( m_WindowName $ ".PayBack_Contents0" $ i $ "_Wnd" );
		wnd.ShowWindow();

		GetTextBoxHandle( wnd.GetWindowName()$".Contents_Name_text").SetText( MakeFullSystemMsg( getSystemMessage(5263), string(itemListArray[i].Requirement)) );

		if( itemListArray[i].Received == 1)
		{
			GetTextureHandle( wnd.GetWindowName()$".ContentsDisable_texture").ShowWindow();
			GetStatusBarHandle( wnd.GetWindowName()$".Completegage_statusbar" ).HideWindow();
			GetButtonHandle( wnd.GetWindowName()$".Reward_Btn" ).HideWindow();
			GetTextureHandle( wnd.GetWindowName()$".Complet_text").ShowWindow();
		}
		else
		{
			GetTextureHandle( wnd.GetWindowName()$".Complet_text").HideWindow();
			GetTextureHandle( wnd.GetWindowName()$".ContentsDisable_texture").HideWindow();

			if( ConsumedItemAmount >= itemListArray[i].Requirement )
			{
				GetButtonHandle( wnd.GetWindowName()$".Reward_Btn" ).ShowWindow();
				GetStatusBarHandle( wnd.GetWindowName()$".Completegage_statusbar" ).HideWindow();
			}
			else
			{
				GetButtonHandle( wnd.GetWindowName()$".Reward_Btn" ).HideWindow();
				GetStatusBarHandle( wnd.GetWindowName()$".Completegage_statusbar" ).ShowWindow();
				GetStatusBarHandle( wnd.GetWindowName()$".Completegage_statusbar" ).SetPoint(ConsumedItemAmount, itemListArray[i].Requirement);
			}

		}

		for( j = 0 ; j < itemListArray[i].RewardItemCount ; j++ )
		{
			info = GetItemInfoByClassID( itemListArray[i].RewardItemClassId[j] );

			info.ItemNum = itemListArray[i].RewardItemAmount[j];
			setShowItemCount(info);

			GetItemWindowHandle( wnd.GetWindowName()$".Contents_ItemWindow").AddItem(info);
			GetItemWindowHandle( wnd.GetWindowName()$".Contents_ItemWindow").SetTooltipType( "Inventory" );
		}				
	}
}
/* ���� ���� ���
"Result" : int (0:����, 1:����)
"EventIDType" : int (enum PAYBACK_EVENT_ID_TYPE)
"SetIndex" : int (���̹� ��� �� �ε���)
*/
function RewardComplete( string param )
{
	local int Result;

	parseInt ( param, "Result", Result );

	if( Result == 0 )
	{
		//Debug("������ ���� ����!!");
	}
	else
	{
		//Debug("������ ���� ����!!!");
		//AddSystemMessageString( GetSystemMessage(5276) );
		//AddSystemMessage( 5276 );
	}
	ListRefresh();
}


function OnPayBackHelp_BtnClick()
{
	RequestOpenWndWithoutNPC(OPEN_PAYBACK_HELP_HTML);
}

function OnPayBackMyCostRefresh_BtnClick()
{
	ListRefresh();
}

function ListRefresh()
{
	RequestPaybackList( PAYBACK_EVENT_ID_TYPE.CR_EVENT_LCOIN_2018 );
}


/**
 * �ð� Ÿ�̸� && ��� ���� Ÿ�̸� �̺�Ʈ
 ***/
function OnTimer(int TimerID) 
{
	//��ϰ��� ��ư Ȱ��ȭ
	if( TimerID == TIMER_CLICK )
	{
		PayBackMyCostRefresh_Btn.EnableWindow();
		Me.KillTimer( TIMER_CLICK );
	}
}

/***************************************************************************************************************
 * �ʱ�ȭ
 * *************************************************************************************************************/
function ClearAll()
{	
	itemListArray.Remove(0, itemListArray.Length);
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{		
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName (string(Self))).HideWindow();
}

defaultproperties
{
     m_WindowName="PayBackWnd"
}
