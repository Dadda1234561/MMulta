/******************************************************************************
//                                             Ȯ��� ��Ƽâ UI ���� ��ũ��Ʈ                                                                    //
******************************************************************************/
class PartyWndArena extends UICommonAPI;	

//�������.  
const NSTATUSICON_MAXCOL = 12;	    // status icon�� �ִ� ����.
const NPARTYSTATUS_HEIGHT = 42; //46;	    // status ����â�� ���α���.
const NPARTYPETSTATUS_HEIGHT = 18;	// status ����â�� ���α���.

const SMALL_BUF_ICON_SIZE = 6;	// �� ���� �������� ��ġ�Ƿ� �׻� �۰� ���ش�. 

const MAX_ArrayNum = 10; // MAX_ArrayNum = MAX_PartyMemberCount + 1 -> �ӽ� ������ �߰��� ��
const MAX_BUFF_ICONTYPE = 4;//�����ְ��� �ϴ� ���� ������ Ÿ�� ����

struct VnameData
{
	var int ID;
	var int UseVName;
	var int DominionIDForVName;
	var string VName;
	var string SummonVName;	
};

var bool	m_bCompact;	//����Ʈâ ���¿���.
var bool	m_bBuff;		//���� ǥ�û��� �÷���.

var int		m_arrID[MAX_ArrayNum];	// �ε����� �ش��ϴ� ��Ƽ���� ���� ID.
var int		m_arrPetID[MAX_ArrayNum];	// �ε����� �ش��ϴ� ��Ƽ���� ���Ǽ��� ID.
var int		m_arrSummonID[MAX_ArrayNum];	// �ε����� �ش��ϴ� ��Ƽ���� ��ȯ ���� ID -> CT3 �߰�
var int		m_arrPetIDOpen[MAX_ArrayNum];	// �ε����� �ش��ϴ� ��Ƽ���� ���� â�� �����ִ��� Ȯ��. 1�̸� ����, 2�̸� ����. -1�̸� ����
var int		m_CurCount;	
var int 	m_CurBf;
var int		m_TargetID;
var int		m_LastChangeColor;

// ������ ��Ƽ���� ID ( ���� updateStatus ���� �⺻ ������ ������ �ʱ� ���� 
var int     transformedMemberID;
// ������ ���� Ÿ�� ( �� ���� �� ��Ƽ�� ���� ���� ���� Ÿ���� �˰� �־�� �� ) 
var int transFormedType;

var VnameData m_Vname[MAX_ArrayNum];
var bool m_AmIRoomMaster; //�ڽ��� ��Ƽ���� ���������� ������ �ִ�. PartyMatchRoomWnd�� ���ؼ� ��Ƽ���� ������ ������ ���ŵȴ�




//Handle �� ���.
var WindowHandle		m_wndTop;
var WindowHandle		m_PartyStatus[MAX_ArrayNum];
var WindowHandle		m_PartyOption;
var NameCtrlHandle		m_PlayerName[MAX_ArrayNum];
var TextureHandle		m_ClassIcon[MAX_ArrayNum];
var TextureHandle		m_LeaderIcon[MAX_ArrayNum];
var TextureHandle		m_VPIcon[MAX_ArrayNum];

var TextureHandle		m_IsDead[MAX_ArrayNum];


var StatusIconHandle	m_StatusIconBuff[MAX_ArrayNum];
var StatusIconHandle	m_StatusIconDeBuff[MAX_ArrayNum];
var StatusIconHandle	m_StatusIconSongDance[MAX_ArrayNum];
var StatusIconHandle	m_StatusIconTriggerSkill[MAX_ArrayNum];
//var BarHandle			m_BarCP[MAX_ArrayNum];
var BarHandle			m_BarHP[MAX_ArrayNum];
var BarHandle			m_BarMP[MAX_ArrayNum];
var ButtonHandle		btnBuff;

var ButtonHandle		m_petButton[MAX_ArrayNum];
var ButtonHandle		m_petButtonTrash[MAX_ArrayNum];

var WindowHandle		m_PetPartyStatus[MAX_ArrayNum];
//var NameCtrlHandle		m_PetName[MAX_ArrayNum];
 
var StatusIconHandle	m_PetStatusIconBuff[MAX_ArrayNum];
var StatusIconHandle	m_PetStatusIconDeBuff[MAX_ArrayNum];
var StatusIconHandle	m_PetStatusIconSongDance[MAX_ArrayNum];
var StatusIconHandle	m_PetStatusIconTriggerSkill[MAX_ArrayNum];


var BarHandle			m_PetBarHP[MAX_ArrayNum];
var BarHandle			m_PetBarMP[MAX_ArrayNum];

var TextureHandle		m_PetClassIcon[MAX_ArrayNum];

// ct3 ���� ��ȯ - �߰� 
var TextureHandle m_ClassIconSummon[MAX_ArrayNum];
var TextureHandle m_ClassIconSummonNum[MAX_ArrayNum];
// var TextureHandle m_ClassIconPet[MAX_ArrayNum];


/**�ڵ���Ƽ�ý��� �߰�*/
//�ڵ���Ƽ�������ؽ���
//var TextureHandle m_AutoPartyMatchingIcon[MAX_ArrayNum];
//�ڵ���Ƽ�����ܹ�ư
//var ButtonHandle m_AutoPartyMatchingBtn[MAX_ArrayNum];

//�ڵ���Ƽ ���õ� index
//var int autoPartyIndex[MAX_ArrayNum];

var int partymasteridx;

var L2Util util;

//��Ƽ�� ���̵�
var int PartyLeaderID;

// ���� �̻���� ���� (����,�۴� ��) ��ư ���¸� �����մϴ�.
// 45842 TTP 
var string currentBuffButtonState;

//Ŭ���� �������� vp �������� ��� ����� offset
const ONCLASSICFORM_OFFSET_X = 12;
const ONAREAFORM_OFFSET_X = 3;

var int iconsOffsetX ;

// ��Ī �׷� �ɹ�
var Array<int> m_arrMatchGroupMember;	

// �׷� �ε��� ��
var int currentIndex, matchGroupCount, partyCount ;



/**************************************** ���� Ÿ�� ***********************************/
const BATTLETYPE_BASUTEI    = 0;
const BATTLETYPE_CLASH      = 1;
const BATTLETYPE_SIEGE      = 2;


// ���� ���� Ÿ��
var int currentBattleType;



function OnRegisterEvent()
{
	// �̺�Ʈ (���� Ȥ�� Ŭ���̾�Ʈ���� ����) �ڵ� ���.
	RegisterEvent( EV_ShowBuffIcon );
	
	RegisterEvent( EV_PartyAddParty);
	RegisterEvent( EV_PartyUpdateParty );
	RegisterEvent( EV_PartyDeleteParty );
	RegisterEvent( EV_PartyDeleteAllParty );
	RegisterEvent( EV_PartySpelledList );
	RegisterEvent( EV_PartyRenameMember );
	
	// ct3 ���� ��ȯ���� �� �и�
	
	RegisterEvent( EV_PartySummonAdd );
	RegisterEvent( EV_PartySummonUpdate );
	RegisterEvent( EV_PartySummonDelete );
	
	RegisterEvent( EV_PartyPetAdd );	
	RegisterEvent( EV_PartyPetUpdate );
	RegisterEvent( EV_PartyPetDelete );
	
	/*
	 *20130219 ���� �����ִ� ��ȹ���� ����. ��ȯ�� ������ �������� �ʴ´�.
	 */
	RegisterEvent( EV_PetStatusSpelledList );		// �� ������ ������� �̺�Ʈ
	//RegisterEvent( EV_SummonedStatusSpelledList );	// ��ȯ��  ������ ������� �̺�Ʈ
	
	RegisterEvent( EV_Restart );
	RegisterEvent( EV_TargetUpdate );	// Ÿ�� ������Ʈ �̺�Ʈ	

	RegisterEvent( EV_PartySpelledListDelete ); //1182
	RegisterEvent( EV_PartySpelledListInsert ); //1183
	RegisterEvent( EV_PetStatusSpelledListDelete ); //1052	
	RegisterEvent( EV_PetStatusSpelledListInsert ); //1053

	RegisterEvent( EV_NeedResetUIData);

	RegisterEvent( EV_StateChanged );

	RegisterEvent( EV_BattleReadyArena ); 

	RegisterEvent( EV_ClosedArena ); 
	//RegisterEvent( EV_TargetHideWindow );
}



function checkClassicForm() 
{
	local int idx;		

	if ( getInstanceUIData().getisClassicServer())
	{
		iconsOffsetX = ONCLASSICFORM_OFFSET_X;		
	}
	else if ( getInstanceUIData().getIsArenaServer() )
	{
		iconsOffsetX = ONAREAFORM_OFFSET_X;
	}
	else 
	{		
		iconsOffsetX = 0;
	}

	for (idx=0; idx<MAX_ArrayNum; idx++)
	{	
		
		if ( getInstanceUIData().getisClassicServer() || getInstanceUIData().getIsArenaServer()) 
		{
			m_VPIcon[idx].hideWindow();
			m_ClassIconSummonNum[idx].HideWindow();
		}
		else 
		{
			m_VPIcon[idx].showWindow();
			m_ClassIconSummonNum[idx].ShowWindow();
		}

		m_LeaderIcon[idx].SetAnchor( "PartyWndArena.PartyStatusWnd"$idx , "TopLeft", "TopLeft", 30 - iconsOffsetX, 8 );			
	}
}

// Ưȭ ������ ��� ���ӳ� ������ ������ �ʵ���
function setHideClassIconSummonNum( int idx ) 
{
	if ( getInstanceUIData().getisClassicServer() )
		m_ClassIconSummonNum[idx].HideWindow();
	else 	
		m_ClassIconSummonNum[idx].ShowWindow();
}

// ������ ������ �Ҹ��� �Լ�.
function OnLoad()
{
	local int idx;	// ������ ���Ե� int.

	util = L2Util(GetScript("L2Util"));

	InitHandleCOD();

	// �������� �ʱ�ȭ.
	partymasteridx = -1;
	m_bCompact = false;
	m_bBuff = false;
	m_CurBf = 0;
	m_TargetID = -1;
	m_LastChangeColor = -1;
	m_AmIRoomMaster = false;
	
	//Reset Anchor	// ������ ������� PartyWndCompact�� anchor point�� �����Ѵ�.
	for (idx=0; idx<MAX_ArrayNum; idx++)
	{
		m_StatusIconBuff[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ idx, "TopRight", "TopLeft", 0, 5);
		m_StatusIconDeBuff[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ idx, "TopRight", "TopLeft", 0, 5);
		m_StatusIconSongDance[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ idx, "TopRight", "TopLeft", 0, 5);
		m_StatusIconTriggerSkill[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ idx, "TopRight", "TopLeft", 0, 5);

		
		m_PetStatusIconBuff[idx].SetAnchor("PartyWndArena.PartyStatusSummonWnd" $ idx, "TopRight", "TopLeft", 1, 1);
		m_PetStatusIconDeBuff[idx].SetAnchor("PartyWndArena.PartyStatusSummonWnd" $ idx, "TopRight", "TopLeft", 1, 1);
		m_PetStatusIconSongDance[idx].SetAnchor("PartyWndArena.PartyStatusSummonWnd" $ idx, "TopRight", "TopLeft", 1, 1);
		m_PetStatusIconTriggerSkill[idx].SetAnchor("PartyWndArena.PartyStatusSummonWnd" $ idx, "TopRight", "TopLeft", 1, 1);

	}
	m_PartyOption.HideWindow();
	
	//Init VirtualDrag
	for (idx=0; idx<MAX_ArrayNum; idx++)
	{
		//m_PartyStatus[idx].SetVirtualDrag( true );
		m_PartyStatus[idx].SetDragOverTexture( "L2UI_CT1.ListCtrl.ListCtrl_DF_HighLight" );
	}
	
	ResetVName();
	
	transformedMemberID = -1;

	m_arrMatchGroupMember.Length = 0;
	//Debug("�ٽ� �ε�..");
}
/*
function InitHandle()
{
	local int idx;	// ������ ���Ե� int.

	//Init Handle
	m_wndTop = GetHandle( "PartyWndArena" );
	m_PartyOption = GetHandle("PartyWndOption");	// �ɼ�â�� �ڵ� �ʱ�ȭ.
	for (idx=0; idx<MAX_ArrayNum; idx++)	// �ִ���Ƽ�� �� ��ŭ �� �����͸� �ʱ�ȭ����.
	{
		m_PartyStatus[idx] = GetHandle( "PartyWndArena.PartyStatusWnd" $ idx );
		m_PlayerName[idx] = NameCtrlHandle( GetHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".PlayerName" ) ); 
		m_ClassIcon[idx] = TextureHandle( GetHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".ClassIcon" ) );
		m_LeaderIcon[idx] = TextureHandle( GetHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".LeaderIcon" ) );
		
		m_StatusIconBuff[idx] = StatusIconHandle( GetHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".StatusIconBuff" ) );
		m_StatusIconDeBuff[idx] = StatusIconHandle( GetHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".StatusIconDeBuff" ) );
		m_StatusIconSongDance[idx] = StatusIconHandle( GetHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".StatusIconSongDance" ) );
		m_StatusIconTriggerSkill[idx] = StatusIconHandle( GetHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".StatusIconTriggerSkill" ) );

		m_BarCP[idx] = BarHandle( GetHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".barCP" ) );
		m_BarHP[idx] = BarHandle( GetHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".barHP" ) );
		m_BarMP[idx] = BarHandle( GetHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".barMP" ) );
		//if(idx != 0) // ù��° â�� ��ư�� ��ӹ��� ��� â�� ��ư�� �������� ��¿�� ����. 
		//{
		//	m_petButtonTrash[idx] = ButtonHandle( GetHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".btnSummon0") );	
		//	m_petButtonTrash[idx].HideWindow();
		//}
		m_petButton[idx] = ButtonHandle( GetHandle( "PartyWndArena.btnSummon" $ idx) );	// ������ ���� ��ư		
		m_petButton[idx].HideWindow();
		
		m_PetPartyStatus[idx] = GetHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx );
		//m_PetName[idx] = NameCtrlHandle( GetHandle( 
"PartyWndArena.PartyStatusSummonWnd" $ idx $ ".SummonName" ) ); 
		m_PetClassIcon[idx] = TextureHandle( GetHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".ClassIcon" ) );
		
		m_PetStatusIconBuff[idx] = StatusIconHandle( GetHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".StatusIconBuff" ) );
		m_PetStatusIconDeBuff[idx] = StatusIconHandle( GetHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".StatusIconDebuff" ) );
		m_PetStatusIconSongDance[idx] = StatusIconHandle( GetHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".StatusIconSongDance" ) );
		m_PetStatusIconTriggerSkill[idx] = StatusIconHandle( GetHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".StatusIconTriggerSkill" ) );

		m_PetBarHP[idx] = BarHandle( GetHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".barHP" ) );
		m_PetBarMP[idx] = BarHandle( GetHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".barMP" ) );		
				
		m_arrPetIDOpen[idx] = -1;
		m_arrID[idx] = 0;
		
		if(idx == 0) //ù��° â�� ���̾ƿ��� �ٸ���. 
		{
			m_petButton[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 32);
		}
		else
			m_petButton[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 2);
		
	}
	btnBuff = ButtonHandle( GetHandle( "PartyWndArena.btnBuff" ) );
}
*/
function InitHandleCOD()
{
	local int idx;	// ������ ���Ե� int.

	//Init Handle
	m_wndTop = GetWindowHandle( "PartyWndArena" );
	m_PartyOption = GetWindowHandle("PartyWndOption");	// �ɼ�â�� �ڵ� �ʱ�ȭ.

	for (idx=0; idx<MAX_ArrayNum; idx++)	// �ִ���Ƽ�� �� ��ŭ �� �����͸� �ʱ�ȭ����. ->  �ӽ� ������ �� �Ѹ��� ���� �ݴϴ�.
	{
		m_PartyStatus[idx] = GetWindowHandle  ( "PartyWndArena.PartyStatusWnd" $ idx );
		m_PlayerName[idx]  = GetNameCtrlHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".PlayerName" ); 
		m_ClassIcon[idx]   = GetTextureHandle ( "PartyWndArena.PartyStatusWnd" $ idx $ ".ClassIcon" );
		m_LeaderIcon[idx]  = GetTextureHandle ( "PartyWndArena.PartyStatusWnd" $ idx $ ".LeaderIcon" );
		m_VPIcon[idx]      = GetTextureHandle ( "PartyWndArena.PartyStatusWnd" $ idx $ ".PartyVPIcon" );

		m_IsDead[idx]      = GetTextureHandle ( "PartyWndArena.PartyStatusWnd" $ idx $ ".IsDeadTexture" );
		
		m_StatusIconBuff[idx]          = GetStatusIconHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".StatusIconBuff" );
		m_StatusIconDeBuff[idx]        = GetStatusIconHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".StatusIconDeBuff" );
		m_StatusIconSongDance[idx]     = GetStatusIconHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".StatusIconSongDance" );
		m_StatusIconTriggerSkill[idx]  = GetStatusIconHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".StatusIconTriggerSkill" );

//		m_BarCP[idx] = GetBarHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".barCP" );
		m_BarHP[idx] = GetBarHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".barHP" );
		m_BarMP[idx] = GetBarHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".barMP" );

		m_petButton[idx] = GetButtonHandle( "PartyWndArena.btnSummon" $ idx);	// ������ ���� ��ư		
		m_petButton[idx].HideWindow();
		
		m_PetPartyStatus[idx] = GetWindowHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx );

		
		m_PetStatusIconBuff[idx] = GetStatusIconHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".StatusIconBuff" );
		m_PetStatusIconDeBuff[idx] = GetStatusIconHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".StatusIconDebuff" );
		m_PetStatusIconSongDance[idx] = GetStatusIconHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".StatusIconSongDance" );
		m_PetStatusIconTriggerSkill[idx] = GetStatusIconHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".StatusIconTriggerSkill" );

		m_PetBarHP[idx] = GetBarHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".barHP" );
		m_PetBarMP[idx] = GetBarHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".barMP" );		
		

		// m_PetClassIcon[idx] = GetTextureHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".ClassIcon" );

		// ct �� ����� �� Ŭ���� ������
		m_PetClassIcon[idx] = GetTextureHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".ClassIconPet" );


		// ct3 �� �߰��� ��, ��ȯ�� �ؽ��� (��ȯ�� ������, ��ȯ�� ��, �� ������)
		m_ClassIconSummon[idx]    =  GetTextureHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".ClassIconSummon" );
		
		m_ClassIconSummonNum[idx] =  GetTextureHandle( "PartyWndArena.PartyStatusSummonWnd" $ idx $ ".ClassIconSummonNum" );
		
		m_arrPetIDOpen[idx] = -1;
		m_arrSummonID[idx] = -1;
		m_arrID[idx] = 0;

		//m_AutoPartyMatchingIcon[idx]    = GetTextureHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".AutoPartyMatchingIcon" );
		//m_AutoPartyMatchingBtn[idx]     = GetButtonHandle( "PartyWndArena.PartyStatusWnd" $ idx $ ".AutoPartyMatchingBtn" );
		
		if(idx == 0) //ù��° â�� ���̾ƿ��� �ٸ���. 
		{
			m_petButton[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 32);
		}
		else
			m_petButton[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 2);
		
	}
	btnBuff = GetButtonHandle( "PartyWndArena.btnBuff" );
}

/** 
 * ��ȯ�� Ÿ�� �ޱ�   
 **/
function string getSummonSortString(int typeN)
{
	local string returnV;
	
	returnV = "";

	switch(typeN)
	{
		// ������ ��ȯ��
		case 0 : returnV = GetSystemString(2311); break;
		// ����� ��ȯ��
		case 1 : returnV = GetSystemString(2312); break;
		// ������ ��ȯ��
		case 2 : returnV = GetSystemString(2313); break;
		// ������ ��ȯ��
		case 3 : returnV = GetSystemString(2314); break;
		// �Ҹ��� ��ȯ��
		case 4 : returnV = GetSystemString(2315); break;
	}

	return returnV;
}
function OnShow()
{
	local int i;
	local int tmpInt;

	GetINIInt ( "PartyWndArena", "a", m_CurBf, "WindowsInfo.ini");
	SetBuffButtonTooltip();
	UpdateBuff();
	GetIniInt( "PartyWndArena", "p", tmpInt, "WindowsInfo.ini");	

	for(i=0; i <MAX_PartyMemberCount ; i++)
	{
		
		if( bool ( tmpInt ) ) 	
		{
			if(m_arrPetIDOpen[i] > 0)	m_arrPetIDOpen[i] = 2;		//���� ������ ��� �ݾ��ش�. 
		}
		else 
		{
			if(m_arrPetIDOpen[i] > 0)	m_arrPetIDOpen[i] = 1;		//���� ������ ��� �����ش�. 			
		}	
		// ���� ��ũ��Ʈ���� ��� ����.		
	}
	//�� ���� ��� ������ show�� ���� ������, onShow�� �ݺ� ���� �ϰ� ��
	//showWindow�� �� �������� �� ����
	

	//Debug ( "onShow partyWnd");
	resizeOnly() ;
	//ResizeWnd();
	//SetBuffButtonTooltip();
}

function OnHide()
{
	ResetVName();
}

function OnEnterState( name a_CurrentStateName )
{
	if (isAreaState() == false) return;
	
	m_bCompact = false;
	m_bBuff = false;
	// m_CurBf = 0;
	ResizeWnd();

	SetBuffButtonTooltip();
	UpdateBuff();
	
}

// �̺�Ʈ �ڵ� ó��.
function OnEvent(int Event_ID, string param)
{
	//Debug( "Event_ID>>>" $ string(Event_ID) $ "&&" $ param );
	//Debug("isAreaState()" @ isAreaState());
	// Debug ( "OnEvent" @  Event_ID );
	if (isAreaState() == false) return;

	if (Event_ID == EV_PartyAddParty)	//��Ƽ���� �߰��ϴ� �̺�Ʈ.
	{
		HandlePartyAddParty(param);
	}
	else if (Event_ID == EV_PartyUpdateParty)	//��Ƽ ������Ʈ. ���� HP �� ���¸� ó���ϱ� ����.
	{
		HandlePartyUpdateParty(param);
	}
	else if (Event_ID == EV_PartyDeleteParty)	//��Ƽ�� ����.
	{
		HandlePartyDeleteParty(param);
	}
	else if (Event_ID == EV_PartyDeleteAllParty)	//��� ��Ƽ�� ����. ��Ƽ�� �����ų� �ǰ���.
	{
		HandlePartyDeleteAllParty();
	}
	//20130221 ���� ��ȹ ������, �� �̻���´� ǥ�� ���� �ʴ� ������ �ľ� ��. �켱 summon �� ���� ����
	else if (Event_ID == EV_PartySpelledList || Event_ID == EV_PetStatusSpelledList )//|| Event_ID == EV_SummonedStatusSpelledList)	// ���� Ȥ�� ����� ó��.
	{
		HandlePartySpelledList(param);
		//Debug( EV_PartySpelledList @ "EV_PartySpelledList");
	}
	else if (Event_ID == EV_ShowBuffIcon)		// ����, �����, ����/����� ���̱� ��带 ��ȯ.
	{
		HandleShowBuffIcon(param);
	}
	else if (Event_ID == EV_PartySummonAdd)	//��Ƽ���� ��ȯ���� ��ȯ���� ���
	{
		HandlePartySummonAdd(param);
	}
	else if (Event_ID == EV_PartyPetAdd)	//��Ƽ���� ���� ��ȯ���� ���
	{
		HandlePartyPetAdd(param);
	}
	else if (Event_ID == EV_PartySummonUpdate)	//��ȯ�� ������Ʈ HP�� �� �׷���..
	{
		// Debug("EV_PartySummonUpdate:" @ param);
		HandlePartySummonUpdate(param);
		
	}
	else if (Event_ID == EV_PartyPetUpdate)	// �� ������Ʈ HP�� �� �׷���..
	{		
		HandlePartyPetUpdate(param);
	}
	else if (Event_ID == EV_PartySummonDelete)	// ��ȯ ����
	{
		// Debug("��ȯ�� ����"@ param);
		HandlePartySummonDelete(param);
	}
	else if (Event_ID == EV_PartyPetDelete)	    // �� ��ȯ ����
	{
		// Debug("�� ��ȯ ����" @ param);
		HandlePartyPetDelete(param);
	}

	else if (Event_ID == EV_Restart)
	{
		// Debug("����");
		HandleRestart();
	}
	
	else if (Event_ID == EV_TargetUpdate)
	{
		HandleCheckTarget();
	}
	else if (Event_ID == EV_PartyRenameMember)
	{
		HandlePartyRenameMember(param);
	}
	else if ( Event_ID == EV_PartySpelledListDelete	||  Event_ID == EV_PetStatusSpelledListDelete)
	{	
		HandlePartySpelledListDelete(param);		
	}
	else if  ( Event_ID == EV_PartySpelledListInsert ||  Event_ID == EV_PetStatusSpelledListInsert )
	{
		HandlePartySpelledListInsert(param);				
	}
	else if ( Event_ID == EV_NeedResetUIData ) 
	{
		checkClassicForm();
	}	
	else if ( Event_ID ==  EV_StateChanged )
	{
		if ( param == "ARENABATTLESTATE" && m_CurCount > 0 ) 
		{
//			Debug ( "�Ʒ��� ��Ʋ ������Ʈ ������ �Ѵ� !!!" @ m_arrMatchGroupMember.Length) ;
			m_wndTop.ShowWindow();		
		}
	} 
	else if ( Event_ID == EV_BattleReadyArena )
	{
		parseInt ( param, "BattleType", currentBattleType );
	}

	else if ( Event_ID == EV_ClosedArena ) 
	{
		transformedMemberID = -1;
	}
}

function onCallUCFunction ( string functionName, string param ) 
{
	//Debug ("onCallUCFunction" @  functionName @ param ) ;
	switch ( functionName ) 
	{
		case "addGroupMember":			
			m_arrMatchGroupMember.Length = m_arrMatchGroupMember.Length + 1 ;
			m_arrMatchGroupMember[m_arrMatchGroupMember.Length-1] = int ( param );
	//		Debug ( "addGroupMember" @ m_arrMatchGroupMember.Length @ m_arrMatchGroupMember[m_arrMatchGroupMember.Length-1]) ;
		break;
		case "resetGroupMember" :
	//		Debug ( "resetGroupMember" @ m_arrMatchGroupMember.Length ) ;
			m_arrMatchGroupMember.Length = 0 ;
		break;
		case "partyMemberTransformed" : 
			setTransForm (param) ;
		break;		
	}
}

function bool isMatchGroupMember ( int ID ) 
{
	local int i;
	for (i = 0 ; i < m_arrMatchGroupMember.Length ; i ++ )		
	{
		//Debug ( "isMatchGroupMember" @  m_arrMatchGroupMember[i] @ ID) ;
		if ( m_arrMatchGroupMember[i] == ID ) return true;
	}
	return false;
}

function HandlePartyRenameMember(string Param)
{
	local int idx;
	local int ID;
	local int UseVName;
	local int DominionIDForVName;
	local string VName;
	local string SummonVName;
	
	ParseInt(Param, "ID", ID);
	ParseInt(Param, "UseVName",UseVName);
	ParseInt(Param, "DominionIDForVName", DominionIDForVName);
	ParseString(Param, "VName", VName);
	ParseString(Param, "SummonVName", SummonVName);
	
	idx = GetVNameIndexByID( ID );
	if( idx > -1 )
	{
		m_Vname[idx].ID = ID;
		m_Vname[idx].UseVName = UseVName;
		m_Vname[idx].DominionIDForVName = DominionIDForVName;
		m_Vname[idx].VName = VName;
		m_Vname[idx].SummonVName = SummonVName;
		ExecuteEvent( EV_TargetUpdate);
	}	
}

// Ÿ���� ���� ��Ƽ���̸� ���� ���� ��ȭ�� �ش�.
function HandleCheckTarget()
{
	local int idx;
	
	idx = -1;
	
	m_TargetID = class'UIDATA_TARGET'.static.GetTargetID();
	if(m_TargetID > 0)	{	idx = FindPartyID(m_TargetID);	}
	
	// ������ ���� �ٲ��ذ� ������ �ٽ� ���� ����
	if( m_LastChangeColor != -1) 
	{			
		m_PartyStatus[m_LastChangeColor].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Darker");
		m_TargetID	 = -1;
		m_LastChangeColor = -1;
	}

	if(idx != -1) 
	{
		m_LastChangeColor = idx;
		m_PartyStatus[idx].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Over");
	}
}




//����ŸƮ�� �ϸ� ��Ŭ����
function HandleRestart()
{
	Clear();
}

function ClearTargetHighLight () 
{
	local int i;
	for ( i = 0 ; i < MAX_ArrayNum ; i ++ ) 	
		m_PartyStatus[i].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Darker");
	
	m_LastChangeColor = -1;
}

//�ʱ�ȭ
function Clear()
{	
	local int idx;
	for (idx=0; idx<MAX_ArrayNum; idx++)
	{
		ClearStatus(idx);		// ��� ���¸� �ʱ�ȭ���ش�. 
		ClearPetStatus(idx);
		ClearSummonStatus(idx);

		m_arrSummonID[idx] = -1;
	}

	currentIndex = 0 ;
	matchGroupCount = 0 ;
	partyCount = 0 ;

	m_CurCount = 0;
	m_TargetID	 = -1;
	m_LastChangeColor = -1;
	ResizeWnd();
	ClearTargetHighLight();

	//Debug("AutoPartyMatchingStatusWnd ����!!!!!");	
	//HideWindow( "AutoPartyMatchingStatusWnd" ); �ڵ���Ÿ ����
}

//����â�� �ʱ�ȭ
function ClearStatus(int idx)
{
	m_StatusIconBuff[idx].Clear();
	m_StatusIconDeBuff[idx].Clear();
	m_StatusIconSongDance[idx].Clear();
	m_StatusIconTriggerSkill[idx].Clear();
	m_PlayerName[idx].SetName("", NCT_Normal,TA_Left);
	m_LeaderIcon[idx].SetTexture("");
	m_ClassIcon[idx].SetTexture("");
//	UpdateCPBar(idx, 0, 0);
	UpdateHPBar(idx, 0, 0);
	UpdateMPBar(idx, 0, 0);
	m_arrID[idx] = 0;
}

// �� ����â�� �ʱ�ȭ
function ClearPetStatus(int idx)
{
	m_PetStatusIconBuff[idx].Clear();
	m_PetStatusIconDeBuff[idx].Clear();
	m_PetStatusIconSongDance[idx].Clear();
	m_PetStatusIconTriggerSkill[idx].Clear();
	//m_PetName[idx].SetName("", NCT_Normal,TA_Left);
	//m_PetClassIcon[idx].SetTexture("");
	m_PetClassIcon[idx].HideWindow();
	UpdateHPBar(idx + 100, 0, 0);
	UpdateMPBar(idx + 100, 0, 0);
	
	//if(m_PetPartyStatus[idx].IsShowWindow()) m_PetPartyStatus[idx].HideWindow();	// ��â ���ֱ�
	// if(m_petButton[idx].IsShowWindow()) m_petButton[idx].HideWindow();
	m_arrPetID[idx] = -1;
	m_arrPetIDOpen[idx] = -1;
	m_arrSummonID[idx] = -1;
}

// �� ����â�� �ʱ�ȭ
function ClearSummonStatus(int idx)
{
	m_arrSummonID[idx] = -1;

	m_ClassIconSummon[idx].HideWindow();
	m_ClassIconSummonNum[idx].HideWindow();
}

//��Ƽâ�� ���� (������ �Ǵ� ��Ƽâ�� �ε���, ������ ��Ƽâ�� �ε���)
function CopyStatus(int DesIndex, int SrcIndex)
{
	local string	strTmp;	
	local int		MaxValue;	// CP, HP, MP�� �ִ밪.
	local int		CurValue;	// CP, HP, MP�� ���簪.
	
	local int		Width;
	local int		Height;
	
	local int		Row;
	local int		Col;
	local int		MaxRow;
	local int		MaxCol;
	local StatusIconInfo info;
	
	//Custom Tooltip
	local CustomTooltip TooltipInfo;
	local CustomTooltip TooltipInfo2;
	
	local string vpIconTextureName, vpToolTipString;

	local Color nameColor ;	

	//ServerID
	m_arrID[DesIndex] = m_arrID[SrcIndex];	
	
	//Class Texture
	m_ClassIcon[DesIndex].SetTexture(m_ClassIcon[SrcIndex].GetTextureName());
	//Class Tooltip
	m_ClassIcon[SrcIndex].GetTooltipCustomType(TooltipInfo);
	m_ClassIcon[DesIndex].SetTooltipCustomType(TooltipInfo);
	
	//��Ƽ�� Texture
	strTmp = m_LeaderIcon[SrcIndex].GetTextureName();
	m_LeaderIcon[DesIndex].SetTexture(strTmp);
	if (Len(strTmp)>0)
	{
		//�������� �̸��� ���� ��ġ�����ش�.
		strTmp = m_PlayerName[DesIndex].GetName();
		GetTextSizeDefault(strTmp, Width, Height);
		//�ּ���ġ Ȯ����
		//m_LeaderIcon[DesIndex].SetAnchor("PartyWndArena.PartyStatusWnd" $ DesIndex, "TopCenter", "TopLeft", -(Width/2)-18, 8);		
		//SetTypePosition
		m_LeaderIcon[DesIndex].ShowWindow();
	}
	//���� ��� ����
	m_LeaderIcon[SrcIndex].GetTooltipCustomType(TooltipInfo2);
	m_LeaderIcon[DesIndex].SetTooltipCustomType(TooltipInfo2);
	
	//CP,HP,MP
//	m_BarCP[SrcIndex].GetValue(MaxValue, CurValue);
//	m_BarCP[DesIndex].SetValue(MaxValue, CurValue);	
	m_BarMP[SrcIndex].GetValue(MaxValue, CurValue);
	m_BarMP[DesIndex].SetValue(MaxValue, CurValue);

	m_BarHP[SrcIndex].GetValue(MaxValue, CurValue);
	m_BarHP[DesIndex].SetValue(MaxValue, CurValue);

	// �װų� ��ų�.
	if ( CurValue == 0 ) m_IsDead[DesIndex].ShowWindow();
	else m_IsDead[DesIndex].hideWindow();

	// ��Ī �׷��� ��� �̸��� �÷� ����
	if ( isMatchGroupMember ( m_arrID[DesIndex] ) ) 
	{
		// HP �� ���.
		nameColor.R = 238;
		nameColor.G = 170;
		nameColor.B = 255;
		nameColor.A = 255;
	}
	else nameColor = util.White;
	//Name
	m_PlayerName[DesIndex].SetNameWithColor(m_PlayerName[SrcIndex].GetName(), NCT_Normal,TA_Left, nameColor);
//	m_PlayerName[idx].SetNameWithColor(VName, NCT_Normal,TA_Left, nameColor);

	// vp ��ü 
	vpIconTextureName = m_VPIcon[DesIndex].GetTextureName();
	vpToolTipString = m_VPIcon[DesIndex].GetTooltipText();

	m_VPIcon[DesIndex].SetTexture(m_VPIcon[SrcIndex].GetTextureName());
	m_VPIcon[DesIndex].SetTooltipText(m_VPIcon[SrcIndex].GetTooltipText());

	m_VPIcon[SrcIndex].SetTexture(vpIconTextureName);
	m_VPIcon[SrcIndex].SetTooltipText(vpToolTipString);

	//BuffStatus
	m_StatusIconBuff[DesIndex].Clear();
	MaxRow = m_StatusIconBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconBuff[DesIndex].AddRow();
		MaxCol = m_StatusIconBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconBuff[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//DeBuffStatus
	m_StatusIconDeBuff[DesIndex].Clear();
	MaxRow = m_StatusIconDeBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconDeBuff[DesIndex].AddRow();
		MaxCol = m_StatusIconDeBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{			
			m_StatusIconDeBuff[SrcIndex].GetItem(Row, Col, info);
			info.bHideRemainTime = true;
			m_StatusIconDeBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//SongDanceStatus
	m_StatusIconSongDance[DesIndex].Clear();
	MaxRow = m_StatusIconSongDance[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconSongDance[DesIndex].AddRow();
		MaxCol = m_StatusIconSongDance[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconSongDance[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconSongDance[DesIndex].AddCol(Row, info);
		}
	}

	//TriggerSkillStatus
	m_StatusIconTriggerSkill[DesIndex].Clear();
	MaxRow = m_StatusIconTriggerSkill[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconTriggerSkill[DesIndex].AddRow();
		MaxCol = m_StatusIconTriggerSkill[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconTriggerSkill[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconTriggerSkill[DesIndex].AddCol(Row, info);
		}
	}	
	
	// -------------------------------------------�굵 �Ű��ش�. 
	//ServerID
	m_arrPetID[DesIndex] = m_arrPetID[SrcIndex];
	m_arrSummonID[DesIndex] = m_arrSummonID[SrcIndex];

	// �� & ��ȯ�� ���� â ���� �ִ°� ����
	m_arrPetIDOpen[DesIndex] = m_arrPetIDOpen[SrcIndex];
	
	//CP,HP,MP
	m_PetBarHP[SrcIndex].GetValue(MaxValue, CurValue);
	m_PetBarHP[DesIndex].SetValue(MaxValue, CurValue);
	m_PetBarMP[SrcIndex].GetValue(MaxValue, CurValue);
	m_PetBarMP[DesIndex].SetValue(MaxValue, CurValue);
	
	
	//BuffStatus
	m_PetStatusIconBuff[DesIndex].Clear();
	MaxRow = m_PetStatusIconBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconBuff[DesIndex].AddRow();
		MaxCol = m_PetStatusIconBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconBuff[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//DeBuffStatus
	m_PetStatusIconDeBuff[DesIndex].Clear();
	MaxRow = m_PetStatusIconDeBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconDeBuff[DesIndex].AddRow();
		MaxCol = m_PetStatusIconDeBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconDeBuff[SrcIndex].GetItem(Row, Col, info);
			info.bHideRemainTime = true;
			m_PetStatusIconDeBuff[DesIndex].AddCol(Row, info);
		}
	}

	//SongDanceStatus
	m_PetStatusIconSongDance[DesIndex].Clear();
	MaxRow = m_PetStatusIconSongDance[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconSongDance[DesIndex].AddRow();
		MaxCol = m_PetStatusIconSongDance[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconSongDance[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconSongDance[DesIndex].AddCol(Row, info);
		}
	}

	//TriggerSkillStatus
	m_PetStatusIconTriggerSkill[DesIndex].Clear();
	MaxRow = m_PetStatusIconTriggerSkill[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconTriggerSkill[DesIndex].AddRow();
		MaxCol = m_PetStatusIconTriggerSkill[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconTriggerSkill[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconTriggerSkill[DesIndex].AddCol(Row, info);
		}
	}

	// Ÿ���� ó��
	ClearTargetHighLight();
	HandleCheckTarget();
}

function resizeOnly() 
{
	local int idx;
	local Rect rectWnd;
	local bool bOption;
	local int i;
	local int OpenPetCount;

	local  PartyMemberInfo partyMemberInfo;

	local int tmpInt;

	// SetOptionBool�� ���. �� ������ PartyWndOption ���� �����
	GetINIInt( "PartyWndArena", "e", tmpInt, "Windowsinfo.ini"  ) ;
	bOption = bool ( tmpInt ) ;//GetOptionBool( "Game", "SmallPartyWnd" );
	
	// Debug("-- m_CurCount " @ m_CurCount);
	if (m_CurCount>0)
	{				
		for (idx=0; idx<MAX_ArrayNum; idx++)
		{
			if (idx<=m_CurCount-1)
			{
				if(idx >0 )	 //1 �̻��϶��� anchor�� ó�����ش�.
				{
					if(m_arrPetIDOpen[idx-1] == 1) // �� ��Ƽ���� ��ȯ���� �����ִٸ�
					{
						m_PartyStatus[idx].SetAnchor("PartyWndArena.PartyStatusSummonWnd" $ idx-1, "BottomLeft", "TopLeft", 0, -4);	// �� ������ ������ ��Ŀ
					}
					else// �� ��Ƽ���� ��ȯ���� �����ְų� ��ȯ���� ������
					{
						m_PartyStatus[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ idx-1, "BottomLeft", "TopLeft", 0, -4);	// ��Ƽ�� ������ ��Ŀ
					}
				}
				if(m_arrID[idx]!= 0 )
				{
					if (m_arrPetIDOpen[idx] > -1)  m_petButton[idx].showWindow();
					else	m_petButton[idx].HideWindow();

					m_PartyStatus[idx].SetVirtualDrag( true );
					m_PartyStatus[idx].ShowWindow();
				}
				// if(m_arrPetIDOpen[idx] == 1) m_PetPartyStatus[idx].ShowWindow();

				
				// ��Ƽ�� ����
				GetPartyMemberInfo(m_arrID[idx], partyMemberInfo);

				//Debug("RESIZE ---> partyMemberInfo.curSummonNum : "  @ partyMemberInfo.curSummonNum);
				// Debug("RESIZE ---> partyMemberInfo.curHavePet   : "  @ partyMemberInfo.curHavePet);
			
				// ��ȯ���� 1���� �̻� �ְų�, ���� �ִٸ�
				// ����â ����
				if (partyMemberInfo.curSummonNum > 0 || partyMemberInfo.curHavePet)
				{
					if (m_arrPetIDOpen[idx] == -1) 
					{
						m_arrPetIDOpen[idx] = 1;
					}
					
					// ����â�� ����.
					m_PetPartyStatus[idx].ShowWindow();

					// Debug("m_arrPetIDOpen[i] " @ m_arrPetIDOpen[idx]);
					// Debug("-����â�� ���� " @ idx @ "  - > "  @ partyMemberInfo.curSummonNum);

					// ��ȯ���� �Ѹ��� �� �ִٸ�..
					if (partyMemberInfo.curSummonNum > 0)
					{						
						m_ClassIconSummon[idx].ShowWindow();
						setHideClassIconSummonNum( idx ) ;
						//m_ClassIconSummonNum[idx].ShowWindow();
						m_ClassIconSummonNum[idx].SetTexture("L2UI_ch3.PartyWndArena.party_summmon_num" $ String(partyMemberInfo.curSummonNum));
					}
					else
					{
						// ��ȯ���� ���ٸ�..
						m_ClassIconSummon[idx].HideWindow();
						m_ClassIconSummonNum[idx].HideWindow();
					}

					// ��ư�� ���� ��&��ȯ�� Ȯ�� â�� ����ڰ� �ݾ� ���� ���°� �ƴ϶��..
					//if (m_arrPetIDOpen[idx] != 2)

					// ���� ���� �Ѵٸ�..
					if (partyMemberInfo.curHavePet)
					{
						m_PetBarMP[idx].ShowWindow();
						m_PetBarHP[idx].ShowWindow();
						m_PetClassIcon[idx].ShowWindow();
					}
					else
					{
						// ���� ���ٸ�..
						m_PetBarMP[idx].HideWindow();
						m_PetBarHP[idx].HideWindow();
						m_PetClassIcon[idx].HideWindow();
					}
				}
				else
				{
					// ��, ��ȯ�� �ϳ��� ���ٸ�.. ����â �ݱ� 					
					m_PetPartyStatus[idx].HideWindow();
					m_arrPetIDOpen[idx] = -1;
				}

			}
			else
			{
				//Debug("â �ݱ�---rerere " @idx);
				m_petButton[idx].HideWindow();
				m_PartyStatus[idx].SetVirtualDrag( false );
				m_PartyStatus[idx].HideWindow();
				m_PetPartyStatus[idx].HideWindow();
			}
		}

		// ��ü â ����� �����Ѵ�.
		OpenPetCount=0;
		for(i=0; i<MAX_ArrayNum; i++)
		{
			// Debug("m_arrPetIDOpen[i]==::" @ m_arrPetIDOpen[i]);
			if(m_arrPetIDOpen[i] == 1)
			{   
				OpenPetCount++;
			}
			else 	// �����ִ� ���°� �ƴѵ�..
			{
				 if(m_PetPartyStatus[i].IsShowWindow()) m_PetPartyStatus[i].HideWindow();
			}
		}

		// Debug("OpenPetCount : " @ OpenPetCount);
		
		//������ ������ ����
		rectWnd = m_wndTop.GetRect();
		m_wndTop.SetWindowSize(rectWnd.nWidth, NPARTYSTATUS_HEIGHT*m_CurCount + OpenPetCount * NPARTYPETSTATUS_HEIGHT);	
		// ��â�� ������ ��ŭ ������ ������� �����ش�. 
		m_wndTop.SetResizeFrameSize(10, NPARTYSTATUS_HEIGHT*m_CurCount  + OpenPetCount * NPARTYPETSTATUS_HEIGHT);
		
	}
	else	// ��Ƽ���� �������� ������ �� ������� ������ �ʴ´�.
	{
		m_wndTop.HideWindow();
	}
}


//�������� ������ ����
function ResizeWnd()
{
	local int idx;
	local Rect rectWnd;
	local bool bOption;
	local int i;
	local int OpenPetCount;

	local  PartyMemberInfo partyMemberInfo;

	local int tmpInt;

	// SetOptionBool�� ���. �� ������ PartyWndOption ���� �����
	GetINIInt( "PartyWndArena", "e", tmpInt, "Windowsinfo.ini"  ) ;
	bOption = bool ( tmpInt ) ;//GetOptionBool( "Game", "SmallPartyWnd" );
	
	// Debug("-- m_CurCount " @ m_CurCount);
	if (m_CurCount>0)
	{				
		for (idx=0; idx<MAX_ArrayNum; idx++)
		{
			if (idx<=m_CurCount-1)
			{
				if(idx >0 )	 //1 �̻��϶��� anchor�� ó�����ش�.
				{
					if(m_arrPetIDOpen[idx-1] == 1) // �� ��Ƽ���� ��ȯ���� �����ִٸ�
					{
						m_PartyStatus[idx].SetAnchor("PartyWndArena.PartyStatusSummonWnd" $ idx-1, "BottomLeft", "TopLeft", 0, -4);	// �� ������ ������ ��Ŀ
					}
					else// �� ��Ƽ���� ��ȯ���� �����ְų� ��ȯ���� ������
					{
						m_PartyStatus[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ idx-1, "BottomLeft", "TopLeft", 0, -4);	// ��Ƽ�� ������ ��Ŀ
					}
				}
				if(m_arrID[idx]!= 0 )
				{
					if (m_arrPetIDOpen[idx] > -1)  m_petButton[idx].showWindow();
					else	m_petButton[idx].HideWindow();

					m_PartyStatus[idx].SetVirtualDrag( true );
					m_PartyStatus[idx].ShowWindow();
				}
				// if(m_arrPetIDOpen[idx] == 1) m_PetPartyStatus[idx].ShowWindow();

				
				// ��Ƽ�� ����
				GetPartyMemberInfo(m_arrID[idx], partyMemberInfo);

				//Debug("RESIZE ---> partyMemberInfo.curSummonNum : "  @ partyMemberInfo.curSummonNum);
				// Debug("RESIZE ---> partyMemberInfo.curHavePet   : "  @ partyMemberInfo.curHavePet);
			
				// ��ȯ���� 1���� �̻� �ְų�, ���� �ִٸ�
				// ����â ����
				if (partyMemberInfo.curSummonNum > 0 || partyMemberInfo.curHavePet)
				{
					if (m_arrPetIDOpen[idx] == -1) 
					{
						m_arrPetIDOpen[idx] = 1;
					}
					
					// ����â�� ����.
					m_PetPartyStatus[idx].ShowWindow();

					// Debug("m_arrPetIDOpen[i] " @ m_arrPetIDOpen[idx]);
					// Debug("-����â�� ���� " @ idx @ "  - > "  @ partyMemberInfo.curSummonNum);

					// ��ȯ���� �Ѹ��� �� �ִٸ�..
					if (partyMemberInfo.curSummonNum > 0)
					{						
						m_ClassIconSummon[idx].ShowWindow();
						setHideClassIconSummonNum( idx ) ;
						//m_ClassIconSummonNum[idx].ShowWindow();
						m_ClassIconSummonNum[idx].SetTexture("L2UI_ch3.PartyWndArena.party_summmon_num" $ String(partyMemberInfo.curSummonNum));
					}
					else
					{
						// ��ȯ���� ���ٸ�..
						m_ClassIconSummon[idx].HideWindow();
						m_ClassIconSummonNum[idx].HideWindow();
					}

					// ��ư�� ���� ��&��ȯ�� Ȯ�� â�� ����ڰ� �ݾ� ���� ���°� �ƴ϶��..
					//if (m_arrPetIDOpen[idx] != 2)

					// ���� ���� �Ѵٸ�..
					if (partyMemberInfo.curHavePet)
					{
						m_PetBarMP[idx].ShowWindow();
						m_PetBarHP[idx].ShowWindow();
						m_PetClassIcon[idx].ShowWindow();
					}
					else
					{
						// ���� ���ٸ�..
						m_PetBarMP[idx].HideWindow();
						m_PetBarHP[idx].HideWindow();
						m_PetClassIcon[idx].HideWindow();
					}
				}
				else
				{
					// ��, ��ȯ�� �ϳ��� ���ٸ�.. ����â �ݱ� 					
					m_PetPartyStatus[idx].HideWindow();
					m_arrPetIDOpen[idx] = -1;
				}

			}
			else
			{
				//Debug("â �ݱ�---rerere " @idx);
				m_petButton[idx].HideWindow();
				m_PartyStatus[idx].SetVirtualDrag( false );
				m_PartyStatus[idx].HideWindow();
				m_PetPartyStatus[idx].HideWindow();
			}
		}

		// ��ü â ����� �����Ѵ�.
		OpenPetCount=0;
		for(i=0; i<MAX_ArrayNum; i++)
		{
			// Debug("m_arrPetIDOpen[i]==::" @ m_arrPetIDOpen[i]);
			if(m_arrPetIDOpen[i] == 1)
			{   
				OpenPetCount++;
			}
			else 	// �����ִ� ���°� �ƴѵ�..
			{
				 if(m_PetPartyStatus[i].IsShowWindow()) m_PetPartyStatus[i].HideWindow();
			}
		}

		// Debug("OpenPetCount : " @ OpenPetCount);
		
		//������ ������ ����
		rectWnd = m_wndTop.GetRect();
		m_wndTop.SetWindowSize(rectWnd.nWidth, NPARTYSTATUS_HEIGHT*m_CurCount + OpenPetCount * NPARTYPETSTATUS_HEIGHT);	
		// ��â�� ������ ��ŭ ������ ������� �����ش�. 
		m_wndTop.SetResizeFrameSize(10, NPARTYSTATUS_HEIGHT*m_CurCount  + OpenPetCount * NPARTYPETSTATUS_HEIGHT);

		m_wndTop.ShowWindow();

		//if (!bOption)	// �ɼ�â�� üũ�� �Ǿ����� ������ ���� (Ȯ���) �����츦 Ȱ��ȭ
		//	m_wndTop.ShowWindow();
		//else
		//	m_wndTop.HideWindow();
	}
	else	// ��Ƽ���� �������� ������ �� ������� ������ �ʴ´�.
	{
		m_wndTop.HideWindow();
	}
}

//ID�� ���° ǥ�õǴ� ��Ƽ������ ���Ѵ�
function int FindPartyID(int ID)
{
	local int idx;
	for (idx=0; idx<MAX_ArrayNum; idx++)
	{
		if (m_arrID[idx] == ID)
		{
			return idx;
		}
	}
	return -1;
}

//ID�� ���° ǥ�õǴ� ������ ���Ѵ�
function int FindPetID(int ID)
{
	local int idx;
	for (idx=0; idx<MAX_ArrayNum; idx++)
	{
		if (m_arrPetID[idx] == ID)
		{
			return idx;
		}
	}
	return -1;
}

//ID�� ���° ǥ�õǴ� ��ȯ�� ���������� ���Ѵ�
function int FindSummonMasterID(int ID)
{
	local int idx;
	for (idx=0; idx<MAX_ArrayNum; idx++)
	{
		if (m_arrSummonID[idx] == ID)
		{
			return idx;
		}
	}
	return -1;
}

//ADD	��Ƽ�� �߰�.
function HandlePartyAddParty(string param)
{
	local int ID;
	local int SummonID;
	
	local int UseVName;
	local int DominionIDForVName;
	local int SummonCount;
	local string VName;
	local string SummonVName;

	// ��Ƽ �ɹ� ����
	local PartyMemberInfo    partyMemberInfo;
	// ��Ƽ �ɹ� �� ����
	local PartyMemberPetInfo partyMemberPetInfo;

	local int index, i, summonClassID;

	local int summonType, summonMAXHP, summonMAXMP, summonHP, summonMP;
		

//	debug("HandlePartyAddParty>>" $ param);

	ParseInt(param, "ID", ID);	// ID�� �Ľ��Ѵ�.
	ParseInt(param, "SummonID", SummonID);
	ParseInt(Param, "UseVName",UseVName);
	ParseInt(Param, "DominionIDForVName", DominionIDForVName);
	// ParseString(Param, "VName", VName);
	ParseString(Param, "SummonVName", SummonVName);	
	
	GetPartyMemberInfo(ID, partyMemberInfo);

	// ��ȯ�� ���� ��´�.
	// ParseInt(Param, "SummonCount", summonCount);
	GetPartyMemberPetInfo(ID, partyMemberPetInfo);	

	if (ID>0)
	{		
		// ��Ƽ ����� ��� �տ� ��ġ ��Ų��.
		if ( isMatchGroupMember( ID ) )
		{
			currentIndex = matchGroupCount;
			matchGroupCount ++ ;
		}
		else 
		{		
			currentIndex = m_arrMatchGroupMember.Length + partyCount ;
			partyCount ++ ;
		}

		m_CurCount++;
		m_Vname[currentIndex].ID = ID;
		m_Vname[currentIndex].UseVName = UseVName;
		m_Vname[currentIndex].DominionIDForVName = DominionIDForVName;
		m_Vname[currentIndex].VName = VName;
		m_Vname[currentIndex].SummonVName = SummonVName;
		ExecuteEvent( EV_TargetUpdate);
	
//		Debug("HandlePartyAddParty" @ currentIndex @ matchGroupCount @ partyCount @ m_CurCount @ m_arrMatchGroupMember.Length @ isMatchGroupMember( ID )) ;
		
		m_arrID[currentIndex] = ID;
		UpdateStatus(currentIndex, param);

		// Debug("====================> param �� ���� " @ param);
		// Debug(":::: m_CurCount ====> " @ m_CurCount);
		// Debug("partyMemberInfo.curSummonNum: " @ partyMemberInfo.curSummonNum);
		// Debug("partyMemberInfo.curHavePet  : " @ partyMemberInfo.curHavePet);
		// if(SummonID > 0)	// ��ȯ���� ������ ��ȯ���� ������
		// ��ȯ���� �ִٸ�
		
		// ��ȯ���� �Ѹ��� �̻�, �Ǵ� ���� ���� �Ѵٸ�..
		if (partyMemberInfo.curSummonNum > 0)
		{
			// ��ȯ�� ������ ID �� �ְ� ��ȯ�� UI ����
			PartySummonProcess(ID);

			for (i = 0; i < SummonCount; i++)
			{
				ParseInt(param, "SummonType" $ i, summonType);
				ParseInt(param, "SummonClassID" $ i, summonClassID);

				// ��ȯ���� ���ٸ�..
				if (summonType == 1)
				{
					// ������ ��ȯ��, ����� ��ȯ�� ���� ������ �����Ѵ�.
					m_ClassIconSummon[currentIndex].SetTooltipText(GetSystemString(505));//getSummonSortString(class'UIDATA_NPC'.static.GetSummonSort(summonClassID)));
					//Debug( "npc : "@ class'UIDATA_NPC'.static.GetSummonSort(summonClassID) );
					
					break;
					// ���� ĵ�� 
				}				
			}
		}

		if ( partyMemberInfo.curHavePet == true)
		{			
			// ���� ���Ӱ� �߰� 
			index = FindPartyID(ID);
			// Debug("�߰� �߰� �� " @ index);
			// �ٷ� hp, mp �ٸ� ���� �ϱ� ���ؼ�

			ParseInt(param, "SummonCount", SummonCount);

			// summonType �� 2�� ���� ���̴�. ���� ã�Ƽ�..
			// HP, MP�ٸ� ���� ��Ų��. 
			for (i = 0; i < SummonCount; i++)
			{
				ParseInt(param, "SummonType" $ i, summonType);

				if (summonType == 2)
				{
					ParseInt(param, "SummonMaxHP" $ i, SummonMaxHP);
					ParseInt(param, "SummonMaxMP" $ i, SummonMaxMP);
					ParseInt(param, "SummonHP"    $ i, SummonHP);
					ParseInt(param, "SummonMP"    $ i, SummonMP);

					// Debug("�� ������Ʈ -> �߰� -> "@ SummonMaxHP);
					UpdateHPBar(index + 100, SummonHP, SummonMaxHP);
					UpdateMPBar(index + 100, SummonMP, SummonMaxMP);
				}				
			}

			m_arrPetID[index] = partyMemberPetInfo.petID;
			// m_arrPetIDOpen[index] = 1;			
		}		

		ResizeWnd();
	}
}


//UPDATE	Ư�� ��Ƽ�� ������Ʈ.
function HandlePartyUpdateParty(string param)
{
	local int	ID;
	local int	idx;
	
	//Debug("��Ƽ :" @ param);

	ParseInt(param, "ID", ID);	

	if (ID>0)
	{
		idx = FindPartyID(ID);
		UpdateStatus(idx, param);	// �ش� �ε����� ��Ƽ�� ������ ����
	}
}

//DELETE	Ư�� ��Ƽ���� ����.
function HandlePartyDeleteParty(string param)
{
	local int	ID;
	local int	idx;
	local int	i;
	
	//Debug("Ư�� ��Ƽ���� ���� :" @ param);
	
	ParseInt(param, "ID", ID);

	if (ID>0)
	{
		idx = FindPartyID(ID);	

		if (idx>-1)
		{	
			if ( isMatchGroupMember ( ID ) ) 				
				matchGroupCount --;
			else partyCount --;

			for (i=idx; i<m_CurCount-1; i++)	// �����Ϸ��� ��Ƽ�� �Ʒ��� ��Ƽ������ �����ش�. 
			{
				CopyStatus(i, i+1);
			}
			ClearStatus(m_CurCount-1);
			ClearPetStatus(m_CurCount-1);
			m_CurCount--;
			ResizeWnd();	// ���� ��Ƽ���� �ڽŹۿ� ���ٸ� �˾Ƽ� ��Ƽ������� �����.
		}
		
	}
}

//DELETE ALL	���� ��� �����..
function HandlePartyDeleteAllParty()
{
	Clear();
}

//Set Info	Ư�� �ε����� ��Ƽ���� ���� ����. ���� ���̵� ������ Ȯ���� ���� �ʿ��ϴ�.

function SetMasterTooltip(int lootingtype)
{
	if(partymasteridx < MAX_ArrayNum && partymasteridx > -1)
		m_LeaderIcon[partymasteridx].SetTooltipCustomType(MakeTooltipSimpleText(GetRoutingString(lootingtype)));	
}

function UpdateStatus(int idx, string param)
{
	local string	Name;
	//local int		MasterID;
	//local int		RoutingType;
	local int		ID;
	local int		CP;
	local int		MaxCP;
	local int		HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;
	local int		ClassID;
	local int		Level;
	local int		Vitality;
	//local userinfo 	TargetUser;
	//~ local int		SummonID;
	
	//local int		Width;
	//local int		Height;	
	
	local int UseVName;
	//local int DominionIDForVName;
	local string VName;
	//local string SummonVName;
	
	//��ȯ�� �� 
	local int SummonCount; 
	// ��ȯ�� ���� 
	//local string SummonTooltipStr;
	// ��ȯ�� �г��� 
	//local string SummonNickName; 
	
	//������Ƽ���� �ڵ���Ƽ ��û����
	local int iSubstatus;

	local Color nameColor;

	ParseInt(param, "SubStitute", iSubstatus);

	if (idx<0 || idx>=MAX_ArrayNum)
		return;
	
	ParseString(param, "Name", Name);
	ParseInt(param, "ID", ID);

	//if ( GetUserInfo(ID, TargetUser) ) 
	//{
	//	Debug ( "getUserInfo" @ ID ) ;
	//}
	//else 
	//{
	//	Debug ( "none target");
	//}
	
	ParseInt(param, "CurCP", CP);
	ParseInt(param, "MaxCP", MaxCP);
	ParseInt(param, "CurHP", HP);
	ParseInt(param, "MaxHP", MaxHP);
	ParseInt(param, "CurMP", MP);
	ParseInt(param, "MaxMP", MaxMP);
	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "Vitality", Vitality);

	ParseInt(param, "SummonCount", SummonCount);

	//��Ƽ�� ���̵�.
	//ParseInt(param, "MasterID", PartyLeaderID);

	if ( isMatchGroupMember ( ID ) ) 
	{		
		nameColor.R = 238;
		nameColor.G = 170;
		nameColor.B = 255;
		nameColor.A = 255 ;	
	}		
	else nameColor = util.White;

	if ( HP == 0 ) m_IsDead[idx].ShowWindow();
	else m_IsDead[idx].hideWindow();
	
	//���� ���ٸ� 0
	/*
	for(i = 0; i < SummonCount; i++) 
	{
		ParseString (param, "SummonNickName" $i, SummonNickName);		
		ParseInt(param, "SummonID"      $ i, SummonID);		
		ParseInt(param, "SummonType"    $ i, SummonType);
		ParseInt(param, "SummonClassID" $ i, SummonClassID);		
		ParseInt(param, "SummonHP"      $ i, SummonHP);
		ParseInt(param, "SummonMaxHP"   $ i, SummonMaxHP);
		ParseInt(param, "SummonMP"      $ i, SummonMP);
		ParseInt(param, "SummonMaxMP"   $ i, SummonMaxMP);
		ParseInt(param, "SummonLevel"   $ i, SummonLevel);
		
	}
	*/

	// ��ȯ���� ���� �Ѵٸ�..
	/*
	if (SummonCount > 0)
	{
		SummonTooltipStr = SummonNickName;
	}*/

	UseVName = m_Vname[idx].UseVName;
	//DominionIDForVName = m_Vname[idx].DominionIDForVName;
	VName = m_Vname[idx].VName;
	//SummonVName = m_Vname[idx].SummonVName;
	
	if (UseVName == 1)
		m_PlayerName[idx].SetNameWithColor(VName, NCT_Normal,TA_Left, nameColor);
	else
		m_PlayerName[idx].SetNameWithColor(Name, NCT_Normal,TA_Left, nameColor);
	
	//���� ������
	//if (ParseInt(param, "MasterID", MasterID))
	//{
	//	if (MasterID>0 && MasterID==ID)
	//	{	
	//		partymasteridx = idx;
	//		ParseInt(param, "RoutingType", RoutingType);
	//		m_LeaderIcon[idx].SetTexture("L2UI_CH3.PartyWndArena.party_leadericon");
	//		m_LeaderIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetRoutingString(RoutingType)));
			
	//		//�������� �̸��� ���� ��ġ�����ش�.
	//		GetTextSizeDefault(Name, Width, Height);
	//		//m_LeaderIcon[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ idx, "TopCenter", "TopLeft", -(Width/2)-18, 8);
	//		//SetTypePosition( idx, 1 );
	//	}
	//	else
	//	{
	//		m_LeaderIcon[idx].SetTexture("");
	//		m_LeaderIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(""));
	//		//SetTypePosition( idx, 0 );
	//	}
	//}
	
	//���� ������
	//m_ClassIcon[idx].SetTexture(GetClassRoleIconName(ClassID));	

	//Debug ( param) ;
	//Debug ( "�� ��Ƽ�� ���� ����? " @  ID @ TargetUser.nTransformID @ TargetUser.m_bPawnChanged @ TargetUser.Name ) ;
	//switch ( TargetUser.nTransformID  ) 
	//{
	//	// dragon
	//	case getInstanceUIData().TRANSFORMID_DRAGONSLAYER :
	//		m_ClassIcon[idx].SetTexture("���� �����̾� ������");
	//	break;
	//	case getInstanceUIData().TRANSFORMID_DRAGON :
	//		m_ClassIcon[idx].SetTexture("���� �巡�� ������");
	//	break;
	//	default :
			
	//	break;
	//}

	//Debug ( "transformedMemberID" @ transformedMemberID ) ;
	if ( transformedMemberID == -1 ) 
		m_ClassIcon[idx].SetTexture(GetClassArenaRoleIconName(ClassID));	
	else 
		setTransFormTexture( transformedMemberID ) ;

	m_ClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetClassRoleName(ClassID) $ " - " $ GetClassType(ClassID)));
	
	//���� ������
//	UpdateCPBar(idx, CP, MaxCP);
	UpdateHPBar(idx, HP, MaxHP);
	UpdateMPBar(idx, MP, MaxMP);

	//��Ƽ�� �߰��� ���� Vitality�� ����, ��Ƽ�� update�϶��� ����.???
}




function setTransForm ( string param ) 
{	
	local int userID ;	
	//local int teamNum;
	local int type;

	parseInt ( param, "userID", userID ) ;
	parseInt ( param, "teamNum", transFormedType ) ;
	parseInt ( param, "type", type ) ;
	
//	Debug ( "setTransForm" @ "userID" @ userID @ "teamNum" @ teamNum @ "type" @ type @"idx" @ idx  );

	switch ( type ) 
	{
		// ����
		case 4 :			
			setTransFormTexture(userID);
		break;
		// ���� ����
		case 5 :
			setClassTexture ( userID ) ;
		break;
	}
}

function setClassTexture ( int userID )
{
	local string textureName ;
	local partyMemberInfo partyMemberInfo;
	local int idx;

	GetPartyMemberInfo(userID, partyMemberInfo);

	idx = FindPartyID( userID );
	if ( idx == -1 ) return; 
	//Debug ( "partyMemberInfo.classID" @  partyMemberInfo.classID ) ;
	textureName = GetClassArenaRoleIconName(partyMemberInfo.classID);			
	m_ClassIcon[idx].SetTexture(textureName);
	transformedMemberID = -1;
}

function setTransFormTexture ( int userID  ) 
{
	local string textureName ;
	local int idx ;

	idx = FindPartyID( userID );
	if ( idx == -1 ) return; 
	transformedMemberID = userID; 
	
	switch ( transFormedType ) 
	{
		// dragon
		case 0 :
			textureName = "L2UI.TheArena.party_styleicon_teamDragon_Arena" ;
		break;
		case 1 :
			textureName = "L2UI.TheArena.party_styleicon_teamSlayer_Arena" ;
		break;				
	}
	m_ClassIcon[idx].SetTexture(textureName);
}


function HandlePartyPetAdd( string param )
{
	local int	MasterID;
	local int	ID;
	local int	i;

	// ��ȯ�� 1, �� 2
	local int   type;
	local int	MasterIndex;
	
	ParseInt(param, "Type", type);	// ������ ID�� �Ľ��Ѵ�.

	// Debug("�� �߰� @" @ param);
	if (type == 2)
	{
		// ������ ID�� �Ľ��Ѵ�.
		ParseInt(param, "MasterID", MasterID);	

		// ID�� �Ľ��Ѵ�.
		ParseInt(param, "ID", ID);	

		if (MasterID>0)
		{
			MasterIndex = -1;
			for(i=0; i< MAX_ArrayNum ; i++)
			{
				if(m_arrID[i] == MasterID) MasterIndex = i;
			}
			
			if(MasterIndex == -1)
			{
				//debug("HandlePartyPetAdd ERROR - Can't find master ID");
				return;
			}
						
			m_arrPetID[MasterIndex] = ID;
			m_arrPetIDOpen[MasterIndex] = 1;

			UpdatePetStatus(MasterIndex, param);
			ResizeWnd();
		}
	}
}

function HandlePartyPetUpdate( string param )
{
	local int	id;
	local int	idx;

	local int	type;
	
	//debug(" PartySummonUpdate !! ");

	// ��ȯ�� 1, �� 2 
	ParseInt(param, "Type", type);

	ParseInt(param, "ID", id);
	// Debug("�� ������Ʈ"@ param);
	
	// �� 
	if (type == 2)
	{	
		idx = FindPetID(id);

		// Debug("idx " @ idx);
		// �ش� �ε����� �� ������ ����
		UpdatePetStatus(idx, param);	
	}
}


function HandlePartyPetDelete( string param )
{
	local int	SummonID;
	local int	idx;
	//~ local int	i;
	
	ParseInt(param, "SummonID", SummonID);
	if (SummonID>0)
	{
		idx = FindPetID(SummonID);
		if (idx>-1)
		{	
			ClearPetStatus(idx);
			ResizeWnd();	// ���� ��Ƽ���� �ڽŹۿ� ���ٸ� �˾Ƽ� ��Ƽ������� �����.
		}
	}
}


function UpdatePetStatus(int idx, string param)
{
	local int		ID;			// �� ID
	local int		ClassID;	// �� ����
	local int		Type;		// �� Ÿ�� 1-��ȯ�� 2-��
	local int		MasterID;	// ������ ID
	// local string	NickName;  	// �� �̸�
		
	local int		HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;
	local int		Level;
	
	if (idx<0 || idx>=MAX_ArrayNum)
		return;
	
	ParseInt(param, "ID", ID);
	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Type", Type);
	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "HP", HP);
	ParseInt(param, "MaxHP", MaxHP);
	ParseInt(param, "MP", MP);
	ParseInt(param, "MaxMP", MaxMP);
	ParseInt(param, "Level", Level);
	
	//����
	// m_PetClassIcon[idx].SetTexture("L2UI_CT1.Icon.ICON_DF_PETICON");
	//m_PetClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(m_PetName[idx].GetName()));
			
	//�� ������
	//m_ClassIcon[idx].SetTexture(GetClassRoleIconName(SummonClassID));
	//m_ClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetClassRoleName(ClassID) $ " - " $ GetClassType(ClassID)));
	
	// debug(" idx :MaxHP" @ idx @ "__" @MaxHP);
	//���� ������
	UpdateHPBar(idx + 100, HP, MaxHP);
	UpdateMPBar(idx + 100, MP, MaxMP);
}

/**
 *  ��Ƽ���� ��ȯ�� �߰�
 **/
function HandlePartySummonAdd( string param )
{
	local int	MasterID;
	local int	ID;
	local int	idx;

	// ��ȯ�� 1, �� 2
	local int   type;

	local SummonInfo m_SummonInfo; 

	ParseInt(param, "Type", type);	
	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "ID", ID);

	GetSummonInfo(ID, m_SummonInfo);
	// debug("class " @  m_SummonInfo.nClassID);
	// Debug("��ȯ�� �߰� @" @ param);

	idx = FindSummonMasterID(MasterID);
	if (idx > 0)
	{
		m_ClassIconSummon[idx].SetTooltipText(GetSystemString(505));//getSummonSortString(class'UIDATA_NPC'.static.GetSummonSort(m_SummonInfo.nClassID)));
	}

	if (type == 1)
	{		
		PartySummonProcess(MasterID);
	}
}

/**
 *  ��Ƽ�� ��ȯ���� ������ �޾Ƽ� ����â���� ǥ�� 
 **/
function PartySummonProcess( int MasterID ) 
{
	local int	i;

	local int	MasterIndex;

	local PartyMemberInfo partyMemberInfo;
	
	if (MasterID>0)
	{
		MasterIndex = -1;
		for(i=0; i< MAX_ArrayNum ; i++)
		{
			if(m_arrID[i] == MasterID)
			{
				MasterIndex = i;
				break;
			}
		}
		
		if(MasterIndex == -1)
		{
			//debug("PartySummonProcess -> ERROR - Can't find master ID");
			return;
		}
		
		GetPartyMemberInfo(MasterID, partyMemberInfo);

		if (partyMemberInfo.curSummonNum > 0)
		{
			// �� ��ȯ�� ���� â ����
			// ��ȯ�� ������ ID �ֱ�
			m_arrSummonID[MasterIndex] = MasterID;
		}
		else
		{
			// �ݱ�
			// ��ȯ�� ������ ID �ֱ�
			m_arrSummonID[MasterIndex] = -1;			
		}
		
		// â ���� 
		ResizeWnd();		
	}
}

/**
 *  ��Ƽ���� ��ȯ�� ������Ʈ
 **/
function HandlePartySummonUpdate( string param )
{
	local int	MasterID;

	// ��ȯ�� 1, �� 2
	local int   type;

	// �ɹ� ���̵� ���ؼ� ��ȯ�� ���� ��� �װ� ���� ���ִ� �ڵ带 �־�� ��
	// debug("��ȯ�� ������Ʈ !" @param);

	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "Type", type);	

	// ��ȯ�� 
	if (type == 1)
	{	
		PartySummonProcess(MasterID);
	}
}



function HandlePartySummonDelete( string param )
{
	local int	SummonMasterID;
	local int	idx;
	local  PartyMemberInfo partyMemberInfo;

	
	ParseInt(param, "SummonMasterID", SummonMasterID);

	if (SummonMasterID>0)
	{

		// ��ȯ�� �������� index �� ã�´�.
		idx = FindSummonMasterID(SummonMasterID);

		GetPartyMemberInfo(SummonMasterID, partyMemberInfo);
		// Debug("����.. ---> partyMemberInfo.curSummonNum : "  @ partyMemberInfo.curSummonNum);

		// ��ȯ���� �Ѹ��� �� �ִٸ�..
		if (partyMemberInfo.curSummonNum > 0)
		{						
			m_ClassIconSummon[idx].ShowWindow();
			setHideClassIconSummonNum( idx ) ;
			//m_ClassIconSummonNum[idx].ShowWindow();
			m_ClassIconSummonNum[idx].SetTexture("L2UI_ch3.PartyWndArena.party_summmon_num" $ String(partyMemberInfo.curSummonNum));
		}
		else
		{
			// ��ȯ���� ���ٸ�..
			ClearSummonStatus(idx);
		}		
		ResizeWnd();			
	}
}

/**
 *  ��ȯ�� ���� ������Ʈ 
 **/
function UpdateSummonStatus(int idx, string param)
{
	local int		ID;			// �� ID
	local int		ClassID;		// �� ����
	local int		Type;		    // �� Ÿ�� 1-��ȯ�� 2-��
	local int		MasterID;	    // ������ ID
	// local string	NickName;  	// �� �̸�
		
	local int		HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;
	local int		Level;
	
	if (idx<0 || idx>=MAX_ArrayNum)
		return;
	
	ParseInt(param, "ID", ID);
	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Type", Type);
	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "HP", HP);
	ParseInt(param, "MaxHP", MaxHP);
	ParseInt(param, "MP", MP);
	ParseInt(param, "MaxMP", MaxMP);
	ParseInt(param, "Level", Level);
	
	
	// debug(":MaxHP" @MaxHP);
	//���� ������

	// �� ��ȯ���� ���� ���� ������ ǥ�� ���� ���� (���� ���� ǥ��)
	// UpdateHPBar(idx + 100, HP, MaxHP);
	// UpdateMPBar(idx + 100, MP, MaxMP);
}

//��������Ʈ����
function HandlePartySpelledList(string param)
{
	UpdateBuff();
}

//��������Ʈ����
function HandlePartySpelledListDelete(string param)
{
	UpdateBuff();
}

//���� ������ ������ ã�� ���� �ϴ� �Լ�
//ttp 60079 �� SpellerID �߰�.
function deleteBuff( StatusIconHandle tmpStatusIcon , int level, int classID, int SpellerID )
{
	local int row;	
	local int col;
	local StatusIconInfo info;	

	for ( row = 0 ; row < tmpStatusIcon.GetRowCount(); row++ )
	{
		for ( col = 0 ; col < tmpStatusIcon.GetColCount(row) ; col++)
		{
			tmpStatusIcon.GetItem(row, col, info );			
			if ( info.ID.classID == classID && info.level ==  level && info.SpellerID == SpellerID )
			{
				tmpStatusIcon.DelItem( row, col );
				refreshPostion( tmpStatusIcon , row );
				return;
			}
		}
	}
}
//������ �� �� �̻� �� ��� ������ �� ĭ�� ���� �ִ� �Լ�
function refreshPostion ( StatusIconHandle tmpStatusIcon , int deletedRow  )
{
	local int row;
	local StatusIconInfo info;	

	for ( row = deletedRow ; row < tmpStatusIcon.GetRowCount() -1 ; row ++ )
	{
		tmpStatusIcon.GetItem (row + 1 ,   0,  info );//���� �ٿ� �ִ� �� �� �� ���� ���� ���� ���� 
		tmpStatusIcon.addCol( row, info);// �� �������� ������ �ٿ� ä�� ���� ����
		tmpStatusIcon.DelItem( row + 1, 0 ); // �����.
	}
}

//��������Ʈ�߰�
function HandlePartySpelledListInsert(string param)
{
	local int i;	
	local int idx;
	local int ID;
	local int Max;

	local StatusIconInfo info;
	local StatusIconHandle tmpStatusIcon;

	local bool isPC;
		
	ParseInt(param, "ID", ID);	

	if (ID<1) return;	

	idx = FindPartyID(ID);	
	if ( idx < 0 ) 
	{
		isPC = false;
		idx = FindPetID(ID);
	} 
	else isPC = true;

	if ( idx < 0 ) return;
		
	//info �ʱ�ȭ
	if ( isPC ) 
	{
		info.Size = 16;
	}
	else 
	{
		info.Size = 10;
	}
	
	info.bShow = true;	

//	Debug( "HandlePartySpelledListInsert" @ String(isPC) @ idx);
	//Max=1 ID=1209091781 ClassID_0=77 Level_0=2 Sec_0=1200
	ParseInt(param, "Max", Max);

	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "Level_" $ i, info.Level);
		ParseInt(param, "SubLevel_" $ i, info.SubLevel);
		if ( IsIconHide(Info.Id,Info.Level,Info.SubLevel) )
		{			
			continue ;
		}
		// ���� ������ ��� add ���� ����.
		if ( class'UIDATA_SKILL'.static.IsToppingSkill( info.ID, info.Level, info.SubLevel) ) 
		{			
			continue ;
		}

		ParseInt(param, "Sec_" $ i, info.RemainTime);

		//ttp 60079
		ParseInt(param, "SpellerID_" $ i, info.SpellerID);
		//Debug( "HandlePartySpelledListInsert"  @ idx @ info.SpellerID @ info.Level @ info.ID.ClassID @  i ) ;

		if (IsValidItemID(info.ID))
		{
			info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, info.Level, info.SubLevel);
			info.bHideRemainTime = true;

			//������̸� 
			if (GetDebuffType( info.ID, info.Level, info.SubLevel) != 0 )
			{
				if ( isPC ) tmpStatusIcon = m_StatusIconDeBuff[idx];
				else 		tmpStatusIcon = m_PetStatusIconDeBuff[idx];				
				
			}
			//�۴�
			else if (IsSongDance( info.ID, info.Level, info.SubLevel) == true )
			{	
				if ( isPC ) tmpStatusIcon = m_StatusIconSongDance[idx];	
				else        tmpStatusIcon = m_PetStatusIconSongDance[idx];
			}
			//�����
			else if (IsTriggerSkill( info.ID, info.Level, info.SubLevel) == true )
			{								
				if ( isPC ) tmpStatusIcon = m_StatusIconTriggerSkill[idx];
				else        tmpStatusIcon = m_PetStatusIconTriggerSkill[idx];
			}
			//�Ϲ� ���� 
			else 
			{				
				if ( isPC ) tmpStatusIcon = m_StatusIconBuff[idx];
				else        tmpStatusIcon = m_PetStatusIconBuff[idx];
			} 	
			
			//���� �κ�
			deleteBuff ( tmpStatusIcon, info.Level, info.ID.ClassID, info.SpellerID ); 

			//�߰� �κ�			
			if ( tmpStatusIcon.GetRowCount() == 0 || tmpStatusIcon.GetColCount( tmpStatusIcon.GetRowCount() -1 ) % NSTATUSICON_MAXCOL == 0 )
			{				
				tmpStatusIcon.AddRow();
			}
			tmpStatusIcon.AddCol( tmpStatusIcon.GetRowCount() -1 , info);
		}
	}
	UpdateBuff();
}

//���������� ǥ��
function HandleShowBuffIcon(string param)
{
	local int nShow;
	ParseInt(param, "Show", nShow);
	
	m_CurBf = m_CurBf + 1;
	
	
	if (m_CurBf > MAX_BUFF_ICONTYPE)
	{
		m_CurBf = 0;
	}
	
	SetINIInt ( "PartyWndArena", "a", m_CurBf, "WindowsInfo.ini");	

	SetBuffButtonTooltip();
	UpdateBuff();
	//~ switch (m_CurBf)
	//~ {
		//~ case 1:
		//~ UpdateBuff();
		//~ break;
		//~ case 2:
		//~ UpdateBuff();
		//~ break;
		//~ case 0:
		//~ m_CurBf = 0;
		//~ UpdateBuff();
	//~ }
}

// ��ưŬ�� �̺�Ʈ
function OnClickButton( string strID )
{
	local int idx;

	switch( strID )
	{
	case "btnBuff":		//������ư Ŭ���� 
		OnBuffButton();
		//script.OnBuffButton();
		break;
	case "btnCompact":	// �ɼ� ��ư Ŭ����
		OnOpenPartyWndOption();
		//OnCompactButton();
		break;	
	case "btnSummon":	// ��ȯ�� ��ư Ŭ����
		//debug("ERROR - you can't enter here");	// ����� ������ ���� -_-;
		break;
	}

	if( inStr( strID , "btnSummon") > -1 )
	{
		idx = int( Right(strID , 1));
		// Debug("idx===> " @idx);
		if(m_PetPartyStatus[idx].isShowwindow())
		{
			// Debug(" ��ȯ�� â�� �ݾƶ�! ");
			m_PetPartyStatus[idx].HideWindow();

			m_arrPetIDOpen[idx] = 2;
		}
		else
		{
			m_PetPartyStatus[idx].ShowWindow();
			m_arrPetIDOpen[idx] = 1;
		}
		ResizeWnd();
	}
}

// �ɼǹ�ư Ŭ���� �Ҹ��� �Լ�
function OnOpenPartyWndOption()
{
	local int i;
	local PartyWndOption script;
	script = PartyWndOption( GetScript("PartyWndOption") );
	
	// �����ִ� ��ȯ�� â ������ �ɼ� ������ , ���� ������� �����Ѵ�. 
	for(i=0; i<MAX_ArrayNum; i++)
	{
		script.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
	}
	
	script.ShowPartyWndOption();
	m_PartyOption.SetAnchor("PartyWndArena.PartyStatusWnd0", "TopRight", "TopLeft", 5, 5);
	
	
}

// ������ �ʴ� �Լ��ε�.  PartyWnd, PartyWndCompact, PartyWndOption ���� ������� ����

//		function OnCompactButton()
//		{
//			local int idx;
//			local int Size;
//			
//			if (m_bCompact)
//			{
//				Size = 16;
//			}
//			else
//			{
//				Size = 10;
//			}
//			m_bCompact = !m_bCompact;
//			
//			for (idx=0; idx<MAX_ArrayNum; idx++)
//			{
//				m_StatusIconBuff[idx].SetIconSize(Size);	
//				m_StatusIconDeBuff[idx].SetIconSize(Size);	
//			}
//		}

// ������ư�� ������ ��� ����Ǵ� �Լ�
function OnBuffButton()
{
	m_CurBf = m_CurBf + 1;
	
	//3���� ��尡 ��ȯ�ȴ�.
	if (m_CurBf > MAX_BUFF_ICONTYPE)
	{
		m_CurBf = 0;
	}

	SetINIInt ( "PartyWndArena", "a", m_CurBf, "WindowsInfo.ini");	
	
	SetBuffButtonTooltip();
	UpdateBuff();
}

// ����ǥ��, ����� ǥ��,  ���� 3������带 ��ȯ�Ѵ�.
function UpdateBuff()
{
	local int idx;
	if (m_CurBf == 1)
	{
		for (idx=0; idx<MAX_ArrayNum; idx++)
		{
			m_StatusIconBuff[idx].ShowWindow();	
			m_PetStatusIconBuff[idx].ShowWindow();
			m_StatusIconDeBuff[idx].HideWindow();	
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();	
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();	
			m_PetStatusIconTriggerSkill[idx].HideWindow();
		}
	}
	else if (m_CurBf == 2)
	{
		for (idx=0; idx<MAX_ArrayNum; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();	
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].ShowWindow();	
			m_PetStatusIconDeBuff[idx].ShowWindow();
			m_StatusIconSongDance[idx].HideWindow();	
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();	
			m_PetStatusIconTriggerSkill[idx].HideWindow();			
		}
	}
	else if (m_CurBf == 3)
	{
		for (idx=0; idx<MAX_ArrayNum; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();	
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();	
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].ShowWindow();	
			m_PetStatusIconSongDance[idx].ShowWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();	
			m_PetStatusIconTriggerSkill[idx].HideWindow();			
		}
	}
	else if (m_CurBf == 4)
	{
		for (idx=0; idx<MAX_ArrayNum; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();	
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();	
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();	
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].ShowWindow();	
			m_PetStatusIconTriggerSkill[idx].ShowWindow();			
		}
	}
	else
	{
		for (idx=0; idx<MAX_ArrayNum; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();	
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();	
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();	
			m_PetStatusIconTriggerSkill[idx].HideWindow();			
		}
	}
	//m_bBuff = bShow;
}

//CP�� ����
//function UpdateCPBar(int idx, int Value, int MaxValue)
//{
//	m_BarCP[idx].SetValue(MaxValue, Value);
//}

//HP�� ����
function UpdateHPBar(int idx, int Value, int MaxValue)
{
	if(idx < 100)
		m_BarHP[idx].SetValue(MaxValue, Value);
	else
		m_PetBarHP[idx - 100].SetValue(MaxValue, Value);
}

//MP�� ����
function UpdateMPBar(int idx, int Value, int MaxValue)
{
	if(idx < 100)
		m_BarMP[idx].SetValue(MaxValue, Value);
	else 	// 100���� ũ�� ���� �����Ŷ��..
		m_PetBarMP[idx - 100].SetValue(MaxValue, Value);
}

//��Ƽ�� Ŭ�� ������..
function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect rectWnd, rectPetClassIcon;
	local UserInfo userinfo;
	local int idx;
	//�ڵ� ��Ÿ ��ư�� ��� ���� ó�������� ���.
	//local Rect rectAutoPart;		

	rectWnd = m_wndTop.GetRect();	

	if (X > rectWnd.nX + 13 && X < rectWnd.nX + rectWnd.nWidth -10)
	{
		if (GetPlayerInfo(userinfo))
		{
			//idx = (Y-rectWnd.nY) / NPARTYSTATUS_HEIGHT;	//�꺸���ֱ� ���� ���� �ڵ�
			idx = GetIdx( Y-rectWnd.nY );
			//debug("OnLButtonDown : " $ idx);			
			//rectAutoPart = m_AutoPartyMatchingBtn[idx].GetRect();	
/*
			//�ڵ� ��Ÿ ��ư�� ��� Ÿ�� ���� ����.
			if( X > rectAutoPart.nX && X < rectAutoPart.nX + rectAutoPart.nWidth )
			{
				if( Y > rectAutoPart.nY && Y <  ( rectAutoPart.nY + rectAutoPart.nHeight ) )
				{					
					return;
				}
			}*/

			rectWnd = m_PetPartyStatus[idx].GetRect();
			rectPetClassIcon = m_PetClassIcon[idx].GetRect();

			if (IsPKMode())
			{
				if(idx <100)
				{
					//Debug ("IsPKMode" @ idx< 100 @ m_arrID[idx] @ userinfo.Loc);
					RequestAttack(m_arrID[idx], userinfo.Loc);
				}
				else
				{
					
					//Debug ("IsPKMode else " ); 					
					if (X > rectPetClassIcon.nX && X < rectWnd.nX + rectWnd.nWidth -10)
					{
						//Debug ("IsPKMode pet " @ userinfo.Loc); 					
						RequestAttack(m_arrPetID[idx-100], userinfo.Loc);
					}
				}
			}
			else
			{
				if(idx < 100)
				{
					//Debug ("IsNotPKMode" @ idx< 100 @ m_arrID[idx] @ userinfo.Loc);
					RequestAction(m_arrID[idx], userinfo.Loc);
				}
				else
				{
					//Debug ("IsNotPKMode else " );
					if (X > rectPetClassIcon.nX && X < rectWnd.nX + rectWnd.nWidth -10)
					{
						//Debug ("IsNotPKMode pet " @ userinfo.Loc);						
						RequestAction(m_arrPetID[idx-100], userinfo.Loc);
					}
				}
			}
		}
	}
}

//��Ƽ���� ��ý�Ʈ
function OnRButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect rectWnd;
	local UserInfo userinfo;
	local int idx;
		
	rectWnd = m_wndTop.GetRect();
	if (X > rectWnd.nX + 13 && X < rectWnd.nX + rectWnd.nWidth -10)
	{
		if (GetPlayerInfo(userinfo))
		{
			//idx = (Y-rectWnd.nY) / NPARTYSTATUS_HEIGHT;	//�꺸���ֱ� ���� ���� �ڵ�
			idx = GetIdx( Y-rectWnd.nY );
			//debug("OnRButtonUp : " $ idx);
			if(idx <100)
				RequestAssist(m_arrID[idx], userinfo.Loc);
			else
				RequestAssist(m_arrPetID[idx-100], userinfo.Loc);
		}
	}
}

// Y ��ǥ�� �̿��� �迭�� �ε��� ���� ���Ѵ�. ���� ��쿡�� + 100�� �Ͽ� �������ش�. 
function int GetIdx(int y)
{
	local int tempY;	// �̺����� �迭�� ���������� �Ȱ� �������鼭 ���� ���ҽ�Ų��. 
	local int i;
	local int idx;
	
	idx = -1;
	tempY = y;
	
	for(i=0 ; i<MAX_ArrayNum ; i++)
	{
		tempY = tempY - NPARTYSTATUS_HEIGHT;
		
		if(tempY <0)	// 0���� ������ �ش� i�� IDX�� �ȴ�. 
		{
			idx = i;	//�ʿ��ұ� ������, ������ġ ��������..
			return idx;
		}
		else if( m_arrPetIDOpen[i] == 1) // �ش� �ε����� ���� �����ִٸ�
		{
			tempY = tempY - NPARTYPETSTATUS_HEIGHT;			
			if(tempY <0)	// 0���� ������ �ش� i�� IDX�� �ȴ�. 
			{
				idx = i + 100;	//���� ��� 100�� ���Ͽ� �����ش�. 
				return idx;
			}
		}		
	}
	
	return idx;
}

// ���� ������ �����Ѵ�.
function SetBuffButtonTooltip()
{
	local int idx;
	switch (m_CurBf)
	{
		case 0:	idx = 1496;
		break;
		case 1:	idx = 1497;
		break;
		case 2:	idx = 1741;
		break;
		case 3:	idx = 2307;
		break;
		case 4: idx = 1498;
		break;
	}
	btnBuff.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(idx)));
}

function OnDropWnd( WindowHandle hTarget, WindowHandle hDropWnd, int x, int y )
{
	local string sTargetName, sDropName ,sTargetParent;
	local int dropIdx, targetIdx, i;
	
	//local  PartyWnd script1;			// Ȯ��� ��Ƽâ�� Ŭ����
	//local PartyWndCompact script2;	// ��ҵ� ��Ƽâ�� Ŭ����
	
	//script1 = PartyWnd( GetScript("PartyWndArena") );
	//script2 = PartyWndCompact( GetScript("PartyWndCompact") );
	
	dropIdx = -1;
	targetIdx = -1;
	
	if( hTarget == None || hDropWnd == None )
		return;
	
	sTargetName = hTarget.GetWindowName();
	sDropName = hDropWnd.GetWindowName();
	sTargetParent = hTarget.GetParentWindowName();
	
	// PartyStatusWnd���� �巡�� �� ����� �� �� �ִ�. 
	//if(( InStr( "PartyStatusWnd", sTargetName ) == -1 ) || ( InStr( "PartyStatusWnd" ,sDropName) == -1 ))
	if( (( InStr( sTargetName , "PartyStatusWnd" ) == -1 ) && ( InStr( sTargetParent , "PartyStatusWnd" ) == -1 )   ) || ( InStr( sDropName, "PartyStatusWnd") == -1 ))
	{
		//Debug( "sTargetName: " $ sTargetName );
		//Debug( "sTargetName: " $ sDropName );
		return;
	}
	else
	{
		dropIdx = int(Right(sDropName , 1));
		
		if( InStr( sTargetName , "PartyStatusWnd" ) > -1 ) 	//Ÿ�� ������ ���� �ܿ�
			targetIdx = int(Right(sTargetName , 1));
		else									//Ÿ�� ������ ������ �θ��� �̸��� PartyStatusWnd �϶�
			targetIdx = int(Right(sTargetParent , 1));
		
		if( dropIdx <0 || targetIdx <0 )
		{
			//Debug( "ERROR IDX: " $ dropIdx $ " / " $  targetIdx);
		}
		
		// �Ʒ� Ȥ�� ���� �о��ִ� �ڵ�
		if( dropIdx > targetIdx)
		{
			CopyStatus ( MAX_PartyMemberCount , dropIdx );		//Ÿ���� �Űܳ���
		//	script2.CopyStatus ( MAX_PartyMemberCount , dropIdx );		//Ÿ���� �Űܳ���
			
			for (i=dropIdx-1; i>targetIdx-1; i--)	// �Ʒ��� �о��ش�. 
			{
				CopyStatus(i+1, i);
		//		script2.CopyStatus(i+1, i);
			}
			CopyStatus ( targetIdx , MAX_PartyMemberCount  );
		//	script2.CopyStatus ( targetIdx , MAX_PartyMemberCount  );
		}
		else if(dropIdx < targetIdx)
		{
			CopyStatus ( MAX_PartyMemberCount, dropIdx );		//Ÿ���� �Űܳ���
		//	script2.CopyStatus ( MAX_PartyMemberCount , dropIdx );		//Ÿ���� �Űܳ���
			
			for (i=dropIdx+1; i<targetIdx+1; i++)	// ���� �����ش�.
			{
				CopyStatus(i-1, i);
		//		script2.CopyStatus(i-1, i);
			}
			CopyStatus ( targetIdx , MAX_PartyMemberCount );
		//	script2.CopyStatus ( targetIdx , MAX_PartyMemberCount );
		}

		ClearStatus(MAX_PartyMemberCount);
		ClearPetStatus(MAX_PartyMemberCount);
		
		//Update Client Data
		class'UIDATA_PARTY'.static.MovePartyMember( dropIdx, targetIdx );
		
		ResizeWnd();
	}
}

function int GetVNameIndexByID( int ID )
{
	local int i;
	for (i=0; i<MAX_ArrayNum; i++)
	{
		if( m_Vname[i].ID == ID )
			return i;
	}
	return -1;
}

function ResetVName()
{
	local int i;
	
	for (i=0; i<MAX_ArrayNum; i++)
	{
		m_Vname[i].ID = i;
		m_Vname[i].UseVName = 0;
		m_Vname[i].DominionIDForVName = 0;
		m_Vname[i].VName = "";
		m_Vname[i].SummonVName = "";
	}
}


function HandleRegistPartySubstitute( string param )
{
	local int iOK;
	local int iUserID;

	ParseInt( param, "OK", iOK );
	ParseInt( param, "UserID", iUserID );

	//debug( "HandleRegistPartySubstitute OK>>>" $string(iOK) );
	//debug( "HandleRegistPartySubstitute UserID>>>" $string(iUserID) );
}

function HandleDeletePartySubstitute( string param )
{
	local int iOK;
	local int iUserID;

	ParseInt( param, "OK", iOK );
	ParseInt( param, "UserID", iUserID );

	//debug( "HandleDeletePartySubstitute OK>>>" $string(iOK) );
	//debug( "HandleDeletePartySubstitute UserID>>>" $string(iUserID) );
}

defaultproperties
{
}
