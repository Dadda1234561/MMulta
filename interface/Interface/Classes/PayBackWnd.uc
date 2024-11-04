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
	// 페이백 목록 내 인덱스
    var int SetIndex;
	// 보상 조건 충족에 필요 수량
    var int Requirement;	
	// 0: 보상 미수령, 1: 보상 수령 완료
	var int Received;

	// 보상 아이템 개수 : 기획에서 MAX 3으로
	var int RewardItemCount;

	var array<int> RewardItemClassId;
	var array<int> RewardItemAmount;	
};

//리스트 저장 배열 ( 체크 상태에 따라 보여지거나 안보여 질 수 있으므로, 
var array<PayBackItemInfo> itemListArray;

var int ConsumedItemAmount;

//목록 갱신용 타이머 ID
const TIMER_CLICK       = 69901;
//목록 갱신용 타이머 딜레이 3초
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
	//사용
	PayBackItemWindow = GetItemWindowHandle( "PayBackWnd.PayBackTabWnd.PayBackItemWindow" );

	PayBackDesc_Txt = GetTextBoxHandle( "PayBackWnd.PayBackTabWnd.PayBackDesc_Txt" );
	//사용
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
		//목록 갱신용 타이머 시작
		Me.SetTimer( TIMER_CLICK, TIMER_DELAYC );
		//버튼 비활성
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
 * 리스트 정보 
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
		/* PC 방 포인트 테스트용
		if( _limitShopItemInfo.CostItemId[i] != 0 )
		{
			_limitShopItemInfo.CostItemId[i] = -100;
		}*/
		//cID = GetItemInfoByClassID(_limitShopItemInfo.RewardItemClassId[i]);
		parseInt ( param, "RewardItemAmount_"$i, _limitShopItemInfo.RewardItemAmount[i]);
	}

	//정렬을 위해 배열에 insert
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

	//소모량 테스트
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
/* 보상 수령 결과
"Result" : int (0:실패, 1:성공)
"EventIDType" : int (enum PAYBACK_EVENT_ID_TYPE)
"SetIndex" : int (페이백 목록 내 인덱스)
*/
function RewardComplete( string param )
{
	local int Result;

	parseInt ( param, "Result", Result );

	if( Result == 0 )
	{
		//Debug("아이템 수령 실패!!");
	}
	else
	{
		//Debug("아이템 수령 성공!!!");
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
 * 시간 타이머 && 목록 갱신 타이머 이벤트
 ***/
function OnTimer(int TimerID) 
{
	//목록갱신 버튼 활성화
	if( TimerID == TIMER_CLICK )
	{
		PayBackMyCostRefresh_Btn.EnableWindow();
		Me.KillTimer( TIMER_CLICK );
	}
}

/***************************************************************************************************************
 * 초기화
 * *************************************************************************************************************/
function ClearAll()
{	
	itemListArray.Remove(0, itemListArray.Length);
}

/**
 * 윈도우 ESC 키로 닫기 처리 
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
