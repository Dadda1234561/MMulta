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
 * â ����� ��� �Ʒ�â �ʱ�ȭ.
 */
function OnHide()
{
	local BR_NewCashShopReceiverListWnd Script;
	
	Script = BR_NewCashShopReceiverListWnd(GetScript("BR_NewCashShopReceiverListWnd"));
	Script.selectedInit();
	Script.EnableTab();
	
	eName.SetString("");
}

//���̸� �߰� â���� �߰�, �ݱ� ��ư�� ���� �̺�Ʈ
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

//�߰� ��ư Ŭ�� ��
function OnBtnAddClick()
{
	local UserInfo userinfo;
	local string UserName;
	local string AddName;
	
	AddName = eName.GetString();
	
	//�ڱ� �̸� �޾ƿ�.
	if( GetPlayerInfo( userinfo ) )
	{
		UserName = userinfo.Name;		
	}	

	if( eName.GetString() != "" )
	{
		//�ڱ� �̸��� ������ Ȯ��
		if( UserName == AddName )
		{
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3221), string(Self) );
		}
		else
		{			
			//���� �� �߰��� ģ���� �̹� ��� �Ǿ� ������.
			if( SearchPostFriend( AddName ) )
			{
				DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3216), string(Self) );
				//DialogShow( DialogModalType_Modalless,DialogType_Notice, "�̹� �޴� �� �߰� ��Ͽ� �����ϴ� �̸� �Դϴ�." );
			}
			//�̸� �߰�.
			else
			{
				class'PostWndAPI'.static.RequestAddingPostFriend( AddName );
				Me.HideWindow();
			}
			
			eName.SetString("");
		}
	}
}

//�޴� �� �߰� ��Ͽ��� �̹� �߰��� �̸��� �˻�. 
function bool SearchPostFriend( string s )
{
	local int i;
	local int count;
	local LVDataRecord record;	
	local ListCtrlHandle AddList;

	AddList = GetListCtrlHandle( "BR_NewCashShopReceiverListWnd.BR_NewCashShopReceiverListWnd_Add.AddList" );
	//�� ���ڵ� ī��Ʈ
	count = class'UIAPI_LISTCTRL'.static.GetRecordCount( "BR_NewCashShopReceiverListWnd.AddList" );
	
	//Ȯ��.
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

//�ݱ�.
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
