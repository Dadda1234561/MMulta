class BR_CashShopReceiverListAddWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle BtnAdd;
var ButtonHandle BtnCancel;
var EditBoxHandle eName;
var TextBoxHandle Description;
var TextureHandle GroupBox;

var bool            bOpenCashShopReceiverListAddWnd;


function OnRegisterEvent()
{
	//RegisterEvent(  );
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle( "BR_CashShopReceiverListAddWnd" );
	BtnAdd = GetButtonHandle( "BR_CashShopReceiverListAddWnd.BtnAdd" );
	BtnCancel = GetButtonHandle( "BR_CashShopReceiverListAddWnd.BtnCancel" );
	eName = GetEditBoxHandle( "BR_CashShopReceiverListAddWnd.Name" );
	Description = GetTextBoxHandle( "BR_CashShopReceiverListAddWnd.Description" );
	GroupBox = GetTextureHandle( "BR_CashShopReceiverListAddWnd.GroupBox" );
}

function Load()
{
}

/**
 * 창 사라질 경우 아래창 초기화.
 */
function OnHide()
{
	local BR_NewCashShopReceiverListWnd Script;
	
	Script = BR_NewCashShopReceiverListWnd(GetScript("BR_NewCashShopReceiverListWnd"));
	Script.selectedInit();
	Script.EnableTab();
	
	eName.SetString("");
}

//새이름 추가 창에서 추가, 닫기 버튼에 대한 이벤트
function OnClickButton( string Name )
{
	switch( Name )
	{
	case "BtnAdd":
		OnBtnAddClick();
		break;
	case "BtnCancel":
		OnBtnCancelClick();
		break;
	}
}

//추가 버튼 클릭 시
function OnBtnAddClick()
{
	local UserInfo userinfo;
	local string UserName;
	local string AddName;
	
	AddName = eName.GetString();
	
	//자기 이름 받아옴.
	if( GetPlayerInfo( userinfo ) )
	{
		UserName = userinfo.Name;		
	}	

	if( eName.GetString() != "" )
	{
		//자기 이름과 같은지 확인
		if( UserName == AddName )
		{
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3221), string(Self) );
		}
		else
		{			
			//받은 이 추가에 친구로 이미 등록 되어 있을때.
			if( SearchPostFriend( AddName ) )
			{
				DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3216), string(Self) );
				//DialogShow( DialogModalType_Modalless,DialogType_Notice, "이미 받는 이 추가 목록에 존재하는 이름 입니다." );
			}
			//이름 추가.
			else
			{
				class'PostWndAPI'.static.RequestAddingPostFriend( AddName );
				Me.HideWindow();
			}
			
			eName.SetString("");
		}
	}
}

//받는 이 추가 목록에서 이미 추가된 이름을 검색. 
function bool SearchPostFriend( string s )
{
	local int i;
	local int count;
	local LVDataRecord record;	
	local ListCtrlHandle AddList;

	AddList = GetListCtrlHandle( "BR_NewCashShopReceiverListWnd.BR_NewCashShopReceiverListWnd_Add.AddList" );
	//총 레코드 카운트
	count = class'UIAPI_LISTCTRL'.static.GetRecordCount( "BR_NewCashShopReceiverListWnd.AddList" );
	
	//확인.
	for( i = 0 ; i < count ; i++ )
	{
		AddList.GetRec( i, record );
		if( s == record.LVDataList[0].szData )
		{
			return true;
		}
	}
	return false;
}

//닫기.
function OnBtnCancelClick()
{
	local BR_NewCashShopReceiverListWnd Script;
	
	Script = BR_NewCashShopReceiverListWnd(GetScript("BR_NewCashShopReceiverListWnd"));
	Script.selectedInit();
	Script.EnableTab();

	Me.HideWindow();
	eName.SetString("");
}

defaultproperties
{
}
