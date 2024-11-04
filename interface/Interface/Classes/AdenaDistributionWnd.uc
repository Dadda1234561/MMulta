//�Ƶ��� �й� â
class AdenaDistributionWnd extends L2UIGFxScript;

var ItemWindowHandle InventoryItem;

const DIALOG_ADENADISTRIBUTTE = 200001;		// �Ƶ��� ��û

function OnRegisterEvent()
{	
	//�Ƶ��� ������Ʈ�� �ޱ� ���� 
	RegisterGFxEvent( EV_UpdateUserInfo );
	RegisterGFxEvent( EV_Restart );
	RegisterGFxEvent( EV_AdenaInvenCount );	

	//�߰��� �й� ���� �Լ� ��
	RegisterGFxEvent( EV_DivideAdenaStart );
	RegisterGFxEvent( EV_DivideAdenaCancel );	
	RegisterGFxEvent( EV_DivideAdenaDone );

	//������ ���� ���� �̺�Ʈ
	//�Ƶ��� ���� �̺�Ʈ
	RegisterGFxEvent( EV_HandOverPartyMaster ); //4918 ��Ƽ���� �絵�� 
	RegisterGFxEvent( EV_CommandChannelInfo );  //1380 ���� ä���� ���� > �ʿ� ���� ��
	RegisterGFxEvent( EV_BecamePartyMaster );   //��Ƽ���̵�
	RegisterGFxEvent( EV_RecvPartyMaster );     //��Ƽ���� �̾����
	RegisterGFxEvent( EV_PartyDeleteAllParty ); //��� ��Ƽ�� ����
	RegisterGFxEvent( EV_PartyAddParty );       //��Ƽ ������
	RegisterGFxEvent( EV_PartyDeleteParty );    //��Ƽ ���� ��

	RegisterGFxEvent( EV_CommandChannelEnd );   //ä�� ��
	RegisterGFxEvent( EV_CommandChannelStart ); //ä�� ����	

	//�׽�Ʈ ��
	//RegisterGFxEvent( 9997 );	
	//RegisterGFxEvent( 9998 );	
	//RegisterGFxEvent( 9999 );

	//RegisterEvent( 9997 );

	RegisterEvent(EV_DialogOK);          //1710
	RegisterEvent(EV_DialogCancel);      //1720
}

function OnLoad()
{	
	registerState( "AdenaDistributionWnd", "GamingState" );	
	SetContainerWindow( WINDOWTYPE_DECO_NORMAL, 0 );	
	//SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0 , 0);	

	//������ �� ��Ŀ���� ������ �ʵ��� ��( �����̳ʿ� ��Ŀ���� ���� �� ! ) 
	//SetHavingFocus( false );
	
	InventoryItem = GetItemWindowHandle( "InventoryWnd.InventoryItem");	
}

function onShow()
{
	// ������ �����츦 ������ �ݱ� ��� 
	local L2Util util;
	util = L2Util(GetScript("L2Util"));	
	util.ItemRelationWindowHide( "AdenaDistributionWnd" );	
}


function onEvent( int a_EventID, String a_Param )
{

	switch ( a_EventID )
	{	
		case EV_DialogOK:
			HandleDialogOK();
		break;

		case EV_DialogCancel:
			HandleDialogCancel();
		break;	
	//case 9997:
	//	ShowWindow();
	//	break;
	}
}

function onCallUCFunction( string functionName, string param )
{
	local int index ;
	local ItemInfo	info;
	//local ItemInfo	info;


	//Debug("onCallUCFunction"@ functionName );
	switch (functionName)
	{
	case "openDialogNumpad" :
		openDialogNumpad(int64 (param) );
	break;
	
	case "getAdenaServerID":	
	//�Ƶ��� ���� ���̵� �ޱ�
	info.ID.classID = 57;
	index = InventoryItem.FindItem( info.ID );	
	
	if( InventoryItem.GetItem(index, info) )
		callGfxFunction("AdenaDistributionWnd", "AdenaServerID", String( info.ID.serverID ));
	break;
	case "RequestCommandChannelInfo": 
		class'CommandChannelAPI'.static.RequestCommandChannelInfo();
	break;	
	}
}

function openDialogNumpad(int64 adena)
{
	// Ask price
	class'UICommonAPI'.static.DialogSetID( DIALOG_ADENADISTRIBUTTE );
	//DialogSetReservedItemID( info.ID );				// ServerID
	//DialogSetReservedInt3( int(bAllItem) );		// ��ü�̵��̸� ���� ���� �ܰ踦 �����Ѵ�
	class'UICommonAPI'.static.DialogSetEditType("number");
	class'UICommonAPI'.static.DialogSetParamInt64( adena );
	class'UICommonAPI'.static.DialogSetDefaultOK();
	class'UICommonAPI'.static.DialogShow(DialogModalType_Modalless, DialogType_NumberPad, getSystemString( 3138 ), string(Self) );	
}


/** Desc : ���̾�α� �����츦 ���� Cancel ��ư ���� ��� */
function HandleDialogCancel() //��Ƽ���ú��� ����â 
{

}

/** Desc : ���̾�α� �����츦 ���� OK ��ư ���� ��� */
function HandleDialogOK()
{	
	//local ItemInfo scInfo;
	local INT64 inputNum;
	local int id;

	if(!class'UICommonAPI'.static.DialogIsOwnedBy( string(Self) ))	return;	

	id = class'UICommonAPI'.static.DialogGetID();
	
	if ( id == DIALOG_ADENADISTRIBUTTE )
	{
		inputNum = INT64( class'UICommonAPI'.static.DialogGetString() );
		CallGFxFunction ( "AdenaDistributionWnd", "HandleDialogOK", String(inputNum));
	}	
}

defaultproperties
{
}
