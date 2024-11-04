/******************************************************************************
// Ȯ��� ��Ƽâ UI ���� ��ũ��Ʈ                                            //
******************************************************************************/
class PartyWnd extends UICommonAPI;	

//�������.  
const SMALL_BUF_ICON_SIZE = 6;	// �� ���� �������� ��ġ�Ƿ� �׻� �۰� ���ش�. 
const MAX_ArrayNum = 10; //

const NSTATUSICON_MAXCOL = 12; // status icon�� �ִ� ����.

// ��Ƽ ������ ������ ���� ������ ����,(����� �����ϴ� ���� �ƴ�)
const PARTY_MASTER_WEIGHT = 18; 

// ��Ƽ �ɹ� �̸� ��ġ
const PARTY_NAME_POSTION_X = 4; 
const PARTY_NAME_POSTION_Y = 8; 

var int  DEFAULT_NPARTYSTATUS_HEIGHT; // status �÷��̾� ����â�� ���α���.
var int  DEFAULT_NPARTYPETSTATUS_HEIGHT; // status �� ����â�� ���α���.

var int DEFAULT_BUFFICON_SIZE;
var int DEFAULT_BUFFICON_SIZE_FORSUMMON;

var int DEFAULT_STATUS_GAP;

var int DEFAULT_FIRSTWND_ADD_HEIGHT;       //ù��°â�� �߰������� �÷��� ����


struct VnameData
{
	var int ID;
	var int UseVName;
	var int DominionIDForVName;
	var string VName;
	var string SummonVName;
};

var string m_WindowName;


var bool m_bCompact;	//����Ʈâ ���¿���.
var bool m_bBuff;    //���� ǥ�û��� �÷���.

var int m_arrID[MAX_ArrayNum];	// �ε����� �ش��ϴ� ��Ƽ���� ���� ID.
var int m_arrPetID[MAX_ArrayNum];	// �ε����� �ش��ϴ� ��Ƽ���� ���Ǽ��� ID.
var int m_arrSummonID[MAX_ArrayNum];	// �ε����� �ش��ϴ� ��Ƽ���� ��ȯ ���� ID -> CT3 �߰�
var int m_arrPetIDOpen[MAX_ArrayNum];	// �ε����� �ش��ϴ� ��Ƽ���� ���� â�� �����ִ��� Ȯ��. 1�̸� ����, 2�̸� ����. -1�̸� ����
var int m_CurCount;
var int m_CurBf;
var int m_TargetID;
var int m_LastChangeColor;

var int MAX_BUFF_ICONTYPE;  // �����ְ��� �ϴ� ���� ������ Ÿ�� ����

var VnameData m_Vname[MAX_ArrayNum];
var bool m_AmIRoomMaster; //�ڽ��� ��Ƽ���� ���������� ������ �ִ�. PartyMatchRoomWnd�� ���ؼ� ��Ƽ���� ������ ������ ���ŵȴ�

//Handle �� ���.
var WindowHandle m_wndTop;
var WindowHandle m_PartyStatus[MAX_ArrayNum];
var WindowHandle m_PartyOption;
var NameCtrlHandle m_PlayerName[MAX_ArrayNum];
var TextureHandle m_ClassIcon[MAX_ArrayNum];
var TextureHandle m_LeaderIcon[MAX_ArrayNum];
var AnimTextureHandle m_AssistAnimTex[MAX_ArrayNum];
//SG(������ ����)
var TextureHandle m_SGIcon[MAX_ArrayNum];

var StatusIconHandle m_StatusIconBuff[MAX_ArrayNum];
var StatusIconHandle m_StatusIconDeBuff[MAX_ArrayNum];
var StatusIconHandle m_StatusIconSongDance[MAX_ArrayNum];
var StatusIconHandle m_StatusIconItem[MAX_ArrayNum];
var StatusIconHandle m_StatusIconTriggerSkill[MAX_ArrayNum];
var StatusBarHandle m_BarCP[MAX_ArrayNum];
var StatusBarHandle m_BarHP[MAX_ArrayNum];
var StatusBarHandle m_BarMP[MAX_ArrayNum];
var ButtonHandle btnBuff;

var ButtonHandle m_petButton[MAX_ArrayNum];

var WindowHandle m_PetPartyStatus[MAX_ArrayNum];
 
var StatusIconHandle m_PetStatusIconBuff[MAX_ArrayNum];
var StatusIconHandle m_PetStatusIconDeBuff[MAX_ArrayNum];
var StatusIconHandle m_PetStatusIconSongDance[MAX_ArrayNum];
var StatusIconHandle m_PetStatusIconItem[MAX_ArrayNum];
var StatusIconHandle m_PetStatusIconTriggerSkill[MAX_ArrayNum];

var StatusBarHandle m_PetBarHP[MAX_ArrayNum];
var StatusBarHandle m_PetBarMP[MAX_ArrayNum];

var TextureHandle m_PetClassIcon[MAX_ArrayNum];

// ct3 ���� ��ȯ - �߰� 
var TextureHandle m_ClassIconSummon[MAX_ArrayNum];
var TextureHandle m_ClassIconSummonNum[MAX_ArrayNum];
var TextureHandle m_IsDead[MAX_ArrayNum];
var PartyWndOption PartyWndOptionScript;

var int partymasteridx;
var int partymasterClassIDidx;
var int partymasterRoutingType;

var L2Util util;

//��Ƽ�� ���̵�
var int PartyLeaderID;

// ���� �̻���� ����(����,�۴� ��)��ư ���¸� �����մϴ�.
// 45842 TTP 
var string currentBuffButtonState;

//Ŭ���� �������� vp �������� ��� ����� offset
//const ONCLASSICFORM_OFFSET_X = 12;
//var int iconsOffsetX ;

function OnRegisterEvent()
{
	// �̺�Ʈ(���� Ȥ�� Ŭ���̾�Ʈ���� ����)�ڵ� ���.
	RegisterEvent(EV_ShowBuffIcon);
	
	RegisterEvent(EV_PartyAddParty);
	RegisterEvent(EV_PartyUpdateParty);
	RegisterEvent(EV_PartyDeleteParty);
	RegisterEvent(EV_PartyDeleteAllParty);
	RegisterEvent(EV_PartySpelledList);
	RegisterEvent(EV_PartyRenameMember);
	
	// ct3 ���� ��ȯ���� �� �и�
	
	RegisterEvent(EV_PartySummonAdd);
	RegisterEvent(EV_PartySummonUpdate);
	RegisterEvent(EV_PartySummonDelete);
	
	RegisterEvent(EV_PartyPetAdd);	
	RegisterEvent(EV_PartyPetUpdate);
	RegisterEvent(EV_PartyPetDelete);
	
	/*
	 *20130219 ���� �����ִ� ��ȹ���� ����. ��ȯ�� ������ �������� �ʴ´�.
	 */
	RegisterEvent(EV_PetStatusSpelledList);		// �� ������ ������� �̺�Ʈ
	//RegisterEvent(EV_SummonedStatusSpelledList);	// ��ȯ��  ������ ������� �̺�Ʈ
	
	RegisterEvent(EV_Restart);	
	RegisterEvent(EV_TargetUpdate);	// Ÿ�� ������Ʈ �̺�Ʈ	

	RegisterEvent(EV_PartySpelledListDelete); //1182
	RegisterEvent(EV_PartySpelledListInsert); //1183
	RegisterEvent(EV_PetStatusSpelledListDelete); //1052	
	RegisterEvent(EV_PetStatusSpelledListInsert); //1053

	RegisterEvent(EV_NeedResetUIData);
}

function checkClassicForm()
{
	local int idx;		

	//if(getInstanceUIData().getisClassicServer())
	//{
	//	iconsOffsetX = ONCLASSICFORM_OFFSET_X;		
	//}
	//else 
	//{		
	//	iconsOffsetX = 0;
	//}

	for(idx=0; idx < MAX_ArrayNum; idx++)
	{	
		if(getInstanceUIData().getIsClassicServer())
		{
			//m_VPIcon[idx].hideWindow();
			m_ClassIconSummonNum[idx].HideWindow();
		}
		else 
		{
			//m_VPIcon[idx].showWindow();
			m_ClassIconSummonNum[idx].ShowWindow();
		}

		//m_LeaderIcon[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ idx , "TopLeft", "TopLeft", 0, 16);			
	}
}

// Ưȭ ������ ��� ���ӳ� ������ ������ �ʵ���
function setHideClassIconSummonNum(int idx)
{
	if(getInstanceUIData().getisClassicServer())
		m_ClassIconSummonNum[idx].HideWindow();
	else 	
		m_ClassIconSummonNum[idx].ShowWindow();
}

function CustomTooltip partyInfoTooltip(bool bMaster, string userName, int classID, optional int nRoutingType)
{
	local CustomTooltip mCustomTooltip;
	local Array<DrawItemInfo> drawListArr;
	

	if(bMaster)
	{	
		drawListArr[drawListArr.Length] = addDrawItemText(userName $ "(" $ GetSystemString(408)$ ")", getInstanceL2Util().Yellow, "", true, true); // ����� ����
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(userName, getInstanceL2Util().BrightWhite, "", true, true); // ����� ����
	}

	if(getInstanceUIData().getIsClassicServer())
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetClassType(ClassID),getInstanceL2Util().White,"",True,True);
	} else {
		drawListArr[drawListArr.Length] = addDrawItemText(GetClassRoleName(ClassID)$ " - " $ GetClassType(ClassID),getInstanceL2Util().White,"",True,True);
	}

	if(bMaster)
	{
		
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		//drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(150);
		//drawListArr[drawListArr.Length] = addDrawItemBlank(4);

		drawListArr[drawListArr.Length] = addDrawItemText(GetRoutingString(nRoutingType), getInstanceL2Util().Gold, "", true, true); // ����� ����		
		
	}

	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);

	if(bMaster)setCustomToolTipMinimumWidth(mCustomTooltip);

	return mCustomTooltip;
}





// ������ ������ �Ҹ��� �Լ�.
function OnLoad()
{
	local int idx;	// ������ ���Ե� int.

	util = L2Util(GetScript("L2Util"));

	PartyWndOptionScript = PartyWndOption(GetScript("PartyWndOption"));

	InitHandleCOD();

	// �������� �ʱ�ȭ.
	partymasteridx = -1;
	partymasterClassIDidx = -1;
	m_bCompact = false;
	m_bBuff = false;
	m_CurBf = 0;
	m_TargetID = -1;
	m_LastChangeColor = -1;
	m_AmIRoomMaster = false;
	
	//Reset Anchor
	for(idx=0; idx<MAX_ArrayNum; idx++)
	{
		// End:0x3F7
		if(getInstanceUIData().getIsClassicServer())
		{
			m_StatusIconBuff[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 15, 5);
			m_StatusIconDeBuff[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 15, 5);
			m_StatusIconSongDance[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 15, 5);
			m_StatusIconItem[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 15, 5);
			m_StatusIconTriggerSkill[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 15, 5);
			m_PetStatusIconBuff[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 15, 1);
			m_PetStatusIconDeBuff[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 15, 1);
			m_PetStatusIconSongDance[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 15, 1);
			m_PetStatusIconTriggerSkill[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 15, 1);
			m_PetStatusIconItem[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 15, 1);
			// [Explicit Continue]
			continue;
		}
		m_StatusIconBuff[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,5);
		m_StatusIconDeBuff[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,5);
		m_StatusIconSongDance[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,5);
		m_StatusIconItem[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,5);
		m_StatusIconTriggerSkill[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx),"TopRight","TopLeft",0,5);
		m_PetStatusIconBuff[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusSummonWnd" $ string(idx),"TopRight","TopLeft",1,1);
		m_PetStatusIconDeBuff[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusSummonWnd" $ string(idx),"TopRight","TopLeft",1,1);
		m_PetStatusIconSongDance[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusSummonWnd" $ string(idx),"TopRight","TopLeft",1,1);
		m_PetStatusIconTriggerSkill[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusSummonWnd" $ string(idx),"TopRight","TopLeft",1,1);
		m_PetStatusIconItem[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusSummonWnd" $ string(idx),"TopRight","TopLeft",1,1);
	}
	m_PartyOption.HideWindow();
	
	//Init VirtualDrag
	for(idx=0; idx<MAX_ArrayNum; idx++)
	{
		//m_PartyStatus[idx].SetVirtualDrag(true);
		m_PartyStatus[idx].SetDragOverTexture("L2UI_CT1.ListCtrl.ListCtrl_DF_HighLight");
	}
	
	ResetVName();
}

function InitHandleCOD()
{
	local int idx;	// ������ ���Ե� int.

	//Init Handle
	m_wndTop = GetWindowHandle(m_WindowName);
	m_PartyOption = GetWindowHandle("PartyWndOption");	// �ɼ�â�� �ڵ� �ʱ�ȭ.

	for(idx=0; idx < MAX_ArrayNum; idx++)	// �ִ���Ƽ�� �� ��ŭ �� �����͸� �ʱ�ȭ����. ->  �ӽ� ������ �� �Ѹ��� ���� �ݴϴ�.
	{
		m_PartyStatus[idx] = GetWindowHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx);
		m_ClassIcon[idx] = GetTextureHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx $ ".ClassIcon");

		if(!isCompact())
		{
			m_PlayerName[idx] = GetNameCtrlHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx $ ".PlayerName"); 
			m_LeaderIcon[idx] = GetTextureHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx $ ".LeaderIcon");
			m_SGIcon[idx] = GetTextureHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx $ ".PartySGIcon_Texture");
			m_IsDead[idx] = GetTextureHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx $ ".IsDeadTexture");
			m_AssistAnimTex[idx] = GetAnimTextureHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx $ ".AssistAnimTex");
		}

		m_StatusIconBuff[idx] = GetStatusIconHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx $ ".StatusIconBuff");
		m_StatusIconDeBuff[idx] = GetStatusIconHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx $ ".StatusIconDeBuff");
		m_StatusIconSongDance[idx] = GetStatusIconHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx $ ".StatusIconSongDance");
		m_StatusIconItem[idx] = GetStatusIconHandle(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx)$ ".StatusIconItem");
		m_StatusIconTriggerSkill[idx] = GetStatusIconHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx $ ".StatusIconTriggerSkill");
		m_BarCP[idx] = GetStatusBarHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx $ ".barCP");
		m_BarHP[idx] = GetStatusBarHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx $ ".barHP");
		m_BarMP[idx] = GetStatusBarHandle(m_WindowName $ "." $ "PartyStatusWnd" $ idx $ ".barMP");

		if(isCompact())
		{
			if(idx == 0)
			{
				m_BarCP[idx].Move(0, 5, 0f);
				m_BarHP[idx].Move(0, 5, 0f);
				m_BarMP[idx].Move(0, 5, 0f);
			}
		}

		m_petButton[idx] = GetButtonHandle(m_WindowName $ "." $ "btnSummon" $ idx);	// ������ ���� ��ư		
		m_petButton[idx].HideWindow();
		m_PetPartyStatus[idx] = GetWindowHandle(m_WindowName $ "." $ "PartyStatusSummonWnd" $ idx);
		m_PetStatusIconBuff[idx] = GetStatusIconHandle(m_WindowName $ "." $ "PartyStatusSummonWnd" $ idx $ ".StatusIconBuff");
		m_PetStatusIconDeBuff[idx] = GetStatusIconHandle(m_WindowName $ "." $ "PartyStatusSummonWnd" $ idx $ ".StatusIconDebuff");
		m_PetStatusIconSongDance[idx] = GetStatusIconHandle(m_WindowName $ "." $ "PartyStatusSummonWnd" $ idx $ ".StatusIconSongDance");
		m_PetStatusIconTriggerSkill[idx] = GetStatusIconHandle(m_WindowName $ "." $ "PartyStatusSummonWnd" $ idx $ ".StatusIconTriggerSkill");
		m_PetStatusIconItem[idx] = GetStatusIconHandle(m_WindowName $ "." $ "PartyStatusSummonWnd" $ string(idx)$ ".StatusIconItem");
		m_PetBarHP[idx] = GetStatusBarHandle(m_WindowName $ "." $ "PartyStatusSummonWnd" $ idx $ ".barHP");
		m_PetBarMP[idx] = GetStatusBarHandle(m_WindowName $ "." $ "PartyStatusSummonWnd" $ idx $ ".barMP");
		m_PetClassIcon[idx] = GetTextureHandle(m_WindowName $ "." $ "PartyStatusSummonWnd" $ idx $ ".ClassIconPet");
		m_ClassIconSummon[idx] = GetTextureHandle(m_WindowName $ "." $ "PartyStatusSummonWnd" $ idx $ ".ClassIconSummon");
		m_ClassIconSummonNum[idx] = GetTextureHandle(m_WindowName $ "." $ "PartyStatusSummonWnd" $ idx $ ".ClassIconSummonNum");

		m_arrPetIDOpen[idx] = -1;
		m_arrSummonID[idx] = -1;
		m_arrID[idx] = 0;

		// ��ȯ�� ��ư ��ġ
		if(isCompact())
		{
			if(idx == 0)//ù��° â�� ���̾ƿ��� �ٸ���. 
			{
				m_petButton[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 16);
			}
			else
			{
				m_petButton[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 2);
			}
		}
		else
		{
			if(idx == 0)//ù��° â�� ���̾ƿ��� �ٸ���. 
			{
				if(getInstanceUIData().getIsClassicServer())
				{
					m_petButton[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx), "TopLeft", "TopRight", -3, 40);				
				}
				else
				{
					m_petButton[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx), "TopLeft", "TopRight", 0, 32);
				}
			}
			// [Explicit Continue]
			continue;
		}
		
		// End:0xAA2
		if(getInstanceUIData().getIsClassicServer())
		{
			m_petButton[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ string(idx), "TopLeft", "TopRight", -4, 2);
			// [Explicit Continue]
			continue;
		}
	}

	btnBuff = GetButtonHandle(m_WindowName $ "." $ "btnBuff");
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

function setSummonPetOpen()
{
	local int i;
	local int tmpInt;

	GetINIInt(m_WindowName,"p",tmpInt,"WindowsInfo.ini");

	for(i=0; i <MAX_PartyMemberCount ; i++)
	{
		if(bool(tmpInt))	
		{
			if(m_arrPetID[i] > 0 || m_arrSummonID[i] > 0)	m_arrPetIDOpen[i] = 2;		//���� ������ ��� �ݾ��ش�. 			
		}
		else 
		{
			if(m_arrPetID[i] > 0 || m_arrSummonID[i] > 0)	m_arrPetIDOpen[i] = 1;		//���� ������ ��� �����ش�. 			
		}	

		//Debug("m_arrSummonID:" @ m_arrSummonID[i]);
		//Debug("m_arrPetID:" @ m_arrPetID[i]);
		//Debug("m_arrPetIDOpen:" @ m_arrPetIDOpen[i]);
		// ���� ��ũ��Ʈ���� ��� ����.		
	}
}

function OnShow()
{
	//local int i;
	//local int tmpInt;

	GetINIInt(m_WindowName,"a",m_CurBf,"WindowsInfo.ini");
	SetBuffButtonTooltip();
	UpdateBuff();

	//GetIniInt("PartyWnd", "p", tmpInt, "WindowsInfo.ini");	
	//Debug("MAX_PartyMemberCount" @ MAX_PartyMemberCount);

	//setSummonPetOpen();

	//for(i=0; i <MAX_PartyMemberCount ; i++)
	//{
	//	if(bool(tmpInt))	
	//	{
	//		if(m_arrPetIDOpen[i] > 0)	m_arrPetIDOpen[i] = 2;		//���� ������ ��� �ݾ��ش�. 
	//	}
	//	else 
	//	{
	//		if(m_arrPetIDOpen[i] > 0)	m_arrPetIDOpen[i] = 1;		//���� ������ ��� �����ش�. 			
	//	}	

	//	//Debug("m_arrPetIDOpen:" @ m_arrPetIDOpen[i]);
	//	// ���� ��ũ��Ʈ���� ��� ����.		
	//}
	//�� ���� ��� ������ show�� ���� ������, onShow�� �ݺ� ���� �ϰ� ��
	//showWindow�� �� �������� �� ����
		
	ResizeWnd(false);
	//resizeOnly();
}

function OnHide()
{
	ResetVName();

}

function EachServerEnterState(name a_CurrentStateName)
{
	Debug("OnEnterState ");
	m_bCompact = false;
	m_bBuff = false;
	// m_CurBf = 0;
	ResizeWnd(true);

	SetBuffButtonTooltip();
	UpdateBuff();	
}


function OnEnterState(name a_CurrentStateName)
{
	if(getInstanceUIData().getIsLiveServer())
	{
		EachServerEnterState(a_CurrentStateName);
	}
}

function OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().getIsLiveServer())
	{
		EachServerEvent(Event_ID,param);
	}
}

// �̺�Ʈ �ڵ� ó��.
function EachServerEvent(int Event_ID, string param)
{
	//Debug("Event_ID>>>" $ string(Event_ID)$ "&&" $ param);

	if(Event_ID == EV_PartyAddParty)	//��Ƽ���� �߰��ϴ� �̺�Ʈ.
	{
		HandlePartyAddParty(param);
	}
	else if(Event_ID == EV_PartyUpdateParty)	//��Ƽ ������Ʈ. ���� HP �� ���¸� ó���ϱ� ����.
	{
		HandlePartyUpdateParty(param);
	}
	else if(Event_ID == EV_PartyDeleteParty)	//��Ƽ�� ����.
	{
		HandlePartyDeleteParty(param);
		
	}
	else if(Event_ID == EV_PartyDeleteAllParty)	//��� ��Ƽ�� ����. ��Ƽ�� �����ų� �ǰ���.
	{
		HandlePartyDeleteAllParty();
	}
	//20130221 ���� ��ȹ ������, �� �̻���´� ǥ�� ���� �ʴ� ������ �ľ� ��. �켱 summon �� ���� ����
	else if(Event_ID == EV_PartySpelledList || Event_ID == EV_PetStatusSpelledList)//|| Event_ID == EV_SummonedStatusSpelledList)	// ���� Ȥ�� ����� ó��.
	{
		HandlePartySpelledList(param);
		//Debug(EV_PartySpelledList @ "EV_PartySpelledList");
	}
	else if(Event_ID == EV_ShowBuffIcon)		// ����, �����, ����/����� ���̱� ��带 ��ȯ.
	{
		HandleShowBuffIcon(param);
	}
	else if(Event_ID == EV_PartySummonAdd)	//��Ƽ���� ��ȯ���� ��ȯ���� ���
	{
		HandlePartySummonAdd(param);
	}
	else if(Event_ID == EV_PartyPetAdd)	//��Ƽ���� ���� ��ȯ���� ���
	{
		HandlePartyPetAdd(param);
	}
	else if(Event_ID == EV_PartySummonUpdate)	//��ȯ�� ������Ʈ HP�� �� �׷���..
	{
		// Debug("EV_PartySummonUpdate:" @ param);
		HandlePartySummonUpdate(param);
		
	}
	else if(Event_ID == EV_PartyPetUpdate)	// �� ������Ʈ HP�� �� �׷���..
	{		
		HandlePartyPetUpdate(param);
	}
	else if(Event_ID == EV_PartySummonDelete)	// ��ȯ ����
	{
		//Debug("��ȯ�� ����"@ param);
		HandlePartySummonDelete(param);
	}
	else if(Event_ID == EV_PartyPetDelete)	    // �� ��ȯ ����
	{
		// Debug("�� ��ȯ ����" @ param);
		HandlePartyPetDelete(param);
	}

	else if(Event_ID == EV_Restart)
	{
		HandleRestart();
	}

	else if(Event_ID == EV_TargetUpdate)
	{
		HandleCheckTarget();
	}
	
	else if(Event_ID == EV_PartyRenameMember)
	{
		HandlePartyRenameMember(param);
	}
	else if(Event_ID == EV_PartySpelledListDelete	||  Event_ID == EV_PetStatusSpelledListDelete)
	{	
		HandlePartySpelledListDelete(param);		
	}
	else if (Event_ID == EV_PartySpelledListInsert ||  Event_ID == EV_PetStatusSpelledListInsert)
	{
		HandlePartySpelledListInsert(param);				
	}
	else if(Event_ID == EV_NeedResetUIData)
	{
		checkClassicForm();
	}
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
	
	idx = GetVNameIndexByID(ID);
	if(idx > -1)
	{
		m_Vname[idx].ID = ID;
		m_Vname[idx].UseVName = UseVName;
		m_Vname[idx].DominionIDForVName = DominionIDForVName;
		m_Vname[idx].VName = VName;
		m_Vname[idx].SummonVName = SummonVName;
		ExecuteEvent(EV_TargetUpdate);
	}	
}

function ClearTargetHighLight()
{
	local int i;

	if(isCompact())return;

	for(i = 0 ; i < MAX_ArrayNum ; i ++)	
	{
		if(getInstanceUIData().getIsLiveServer())
		{
			m_PartyStatus[i].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg");
		}
		m_PartyStatus[i].SetBackTexture("L2UI_NewTex.Windows.PartyWndBG");
	}
	
	m_LastChangeColor = -1;
}

// Ÿ���� ���� ��Ƽ���̸� ���� ���� ��ȭ�� �ش�.
function HandleCheckTarget()
{
	local int idx;

	if(isCompact())return;
	
	idx = -1;
	
	m_TargetID = class'UIDATA_TARGET'.static.GetTargetID();
	if(m_TargetID > 0)	{	idx = FindPartyID(m_TargetID);	}
	
	// ������ ���� �ٲ��ذ� ������ �ٽ� ���� ����
	if(m_LastChangeColor != -1)
	{			
		m_PartyStatus[m_LastChangeColor].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg");
		if(getInstanceUIData().getIsLiveServer())
		{
			m_PartyStatus[m_LastChangeColor].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg");
		} else {
			m_PartyStatus[m_LastChangeColor].SetBackTexture("L2UI_NewTex.Windows.PartyWndBG");
		}
		m_TargetID	 = -1;
		m_LastChangeColor = -1;
	}

	if(idx != -1)
	{
		m_LastChangeColor = idx;
		if(getInstanceUIData().getIsLiveServer())
		{
			m_PartyStatus[idx].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Over");
		} else {
			m_PartyStatus[idx].SetBackTexture("L2UI_NewTex.PartyWndBG_OverClassic");
		}
	}
}


//����ŸƮ�� �ϸ� ��Ŭ����
function HandleRestart()
{
	Clear();
}

//�ʱ�ȭ
function Clear()
{
	local int idx;
	for(idx=0; idx<MAX_ArrayNum; idx++)
	{
		ClearStatus(idx);		// ��� ���¸� �ʱ�ȭ���ش�. 
		ClearPetStatus(idx);
		ClearSummonStatus(idx);

		m_arrSummonID[idx] = -1;
	}
	m_CurCount = 0;
	m_TargetID	 = -1;
	m_LastChangeColor = -1;
	ResizeWnd(false);
	ClearTargetHighLight();

	//Debug("AutoPartyMatchingStatusWnd ����!!!!!");	
	//HideWindow("AutoPartyMatchingStatusWnd"); �ڵ���Ÿ ����
}

//����â�� �ʱ�ȭ
function ClearStatus(int idx)
{
	m_StatusIconBuff[idx].Clear();
	m_StatusIconDeBuff[idx].Clear();
	m_StatusIconSongDance[idx].Clear();
	m_StatusIconItem[idx].Clear();
	m_StatusIconTriggerSkill[idx].Clear();

	if(isCompact()== false)
	{
		m_PlayerName[idx].SetName("", NCT_Normal,TA_Left);
		m_LeaderIcon[idx].SetTexture("");
		m_SGIcon[idx].SetTexture("");
		//m_AssistAnimTex[idx].HideWindow();
	}
	
	m_ClassIcon[idx].SetTexture("");

	UpdateCPBar(idx, 0, 0);
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
	m_PetStatusIconItem[idx].Clear();

	m_PetClassIcon[idx].HideWindow();

	UpdateHPBar(idx + 100, 0, 0);
	UpdateMPBar(idx + 100, 0, 0);
	
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

function CheckDeadTarget(int idx)
{
  Debug("CheckDeadTarget" @ string(m_arrID[idx])@ string(m_targetID));
  if(m_targetID == m_arrID[idx])
  {
    RequestReTargetUser(m_arrID[idx]);
  }
}

function CheckNHideDeadTargetTexture(int idx)
{
	Debug("CheckNHideDeadTargetTexture" @ string(m_arrID[idx])@ string(m_targetID));
	if(m_targetID == m_arrID[idx])
	{
		TargetStatusWnd(GetScript("TargetStatusWnd")).DeathTexture.HideWindow();
	}
}

//��Ƽâ�� ����(������ �Ǵ� ��Ƽâ�� �ε���, ������ ��Ƽâ�� �ε���)
function CopyStatus(int DesIndex, int SrcIndex)
{
	local string	strTmp;
	//SG��
	local string	strTmp1;
	local INT64		MaxValue;	// CP, HP, MP�� �ִ밪.
	local INT64		CurValue;	// CP, HP, MP�� ���簪.
	
	//local int		Width;
	//local int		Height;
	
	local int		Row;
	local int		Col;
	local int		MaxRow;
	local int		MaxCol;
	local StatusIconInfo info;
	
	//Custom Tooltip
	local CustomTooltip TooltipInfo;
	local CustomTooltip TooltipInfo2;


	local CustomTooltip TooltipStatusInfo;
	//local CustomTooltip TooltipStatusInfo2;

	//local string vpIconTextureName, vpToolTipString;
	//ServerID
	m_arrID[DesIndex] = m_arrID[SrcIndex];
	
	//Name
	//if(!isCompact())m_PlayerName[DesIndex].SetName(m_PlayerName[SrcIndex].GetName(), NCT_Normal,TA_Left);

	m_PartyStatus[SrcIndex].GetTooltipCustomType(TooltipStatusInfo);
	m_PartyStatus[DesIndex].SetTooltipCustomType(TooltipStatusInfo);

	//Class Texture
	m_ClassIcon[DesIndex].SetTexture(m_ClassIcon[SrcIndex].GetTextureName());
	//Class Tooltip
	m_ClassIcon[SrcIndex].GetTooltipCustomType(TooltipInfo);
	m_ClassIcon[DesIndex].SetTooltipCustomType(TooltipInfo);
	
	//��Ƽ�� Texture

	if(!isCompact())
	{
		strTmp = m_LeaderIcon[SrcIndex].GetTextureName();
		strTmp1 = m_SGIcon[SrcIndex].GetTextureName();
		m_LeaderIcon[DesIndex].SetTexture(strTmp);
		m_SGIcon[DesIndex].SetTexture(strTmp1);
		if(Len(strTmp)> 0)
		{
			//GetTextSizeDefault(strTmp, Width, Height);
			m_LeaderIcon[DesIndex].ShowWindow();
			m_PlayerName[DesIndex].SetNameWithColor(m_PlayerName[SrcIndex].GetName(), NCT_Normal,TA_Left, getInstanceL2Util().Yellow);
		}
		else
		{
			m_PlayerName[DesIndex].SetNameWithColor(m_PlayerName[SrcIndex].GetName(), NCT_Normal,TA_Left, getInstanceL2Util().BrightWhite);
		}


		if(Len(strTmp1)> 0)
		{
			m_SGIcon[DesIndex].ShowWindow();
		}

		SetNamePostion(SrcIndex);
		SetNamePostion(DesIndex);

		//���� ��� ����
		m_LeaderIcon[SrcIndex].GetTooltipCustomType(TooltipInfo2);
		m_LeaderIcon[DesIndex].SetTooltipCustomType(TooltipInfo2);
	}
	
	//CP,HP,MP
	m_BarCP[SrcIndex].GetPoint(CurValue,MaxValue);
	m_BarCP[DesIndex].SetPoint(CurValue,MaxValue);
	m_BarHP[SrcIndex].GetPoint(CurValue,MaxValue);
	m_BarHP[DesIndex].SetPoint(CurValue,MaxValue);

	// �װų� ��ų�.
	if(!isCompact())
	{
		if(CurValue == 0)m_IsDead[DesIndex].ShowWindow();
		else m_IsDead[DesIndex].hideWindow();
	}

	if(CurValue == 0)
	{
		CheckDeadTarget(DesIndex);
	} else {
		CheckNHideDeadTargetTexture(DesIndex);
	}
	m_BarMP[SrcIndex].GetPoint(CurValue,MaxValue);
	m_BarMP[DesIndex].SetPoint(CurValue,MaxValue);


	//BuffStatus
	m_StatusIconBuff[DesIndex].Clear();
	MaxRow = m_StatusIconBuff[SrcIndex].GetRowCount();
	for(Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconBuff[DesIndex].AddRow();
		MaxCol = m_StatusIconBuff[SrcIndex].GetColCount(Row);
		for(Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconBuff[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//DeBuffStatus
	m_StatusIconDeBuff[DesIndex].Clear();
	MaxRow = m_StatusIconDeBuff[SrcIndex].GetRowCount();
	for(Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconDeBuff[DesIndex].AddRow();
		MaxCol = m_StatusIconDeBuff[SrcIndex].GetColCount(Row);
		for(Col=0; Col<MaxCol; Col++)
		{			
			m_StatusIconDeBuff[SrcIndex].GetItem(Row, Col, info);
			info.bHideRemainTime = true;
			m_StatusIconDeBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//SongDanceStatus
	m_StatusIconSongDance[DesIndex].Clear();
	MaxRow = m_StatusIconSongDance[SrcIndex].GetRowCount();
	for(Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconSongDance[DesIndex].AddRow();
		MaxCol = m_StatusIconSongDance[SrcIndex].GetColCount(Row);
		for(Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconSongDance[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconSongDance[DesIndex].AddCol(Row, info);
		}
	}

	m_StatusIconItem[DesIndex].Clear();
	maxrow = m_StatusIconItem[SrcIndex].GetRowCount();
	for(Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconItem[DesIndex].AddRow();
		MaxCol = m_StatusIconItem[SrcIndex].GetColCount(Row);
		for(Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconItem[SrcIndex].GetItem(Row,Col,Info);
			m_StatusIconItem[DesIndex].AddCol(Row,Info);
		}
	}

	//TriggerSkillStatus
	m_StatusIconTriggerSkill[DesIndex].Clear();
	MaxRow = m_StatusIconTriggerSkill[SrcIndex].GetRowCount();
	for(Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconTriggerSkill[DesIndex].AddRow();
		MaxCol = m_StatusIconTriggerSkill[SrcIndex].GetColCount(Row);
		for(Col=0; Col<MaxCol; Col++)
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
	m_PetBarHP[SrcIndex].GetPoint(CurValue,MaxValue);
	m_PetBarHP[DesIndex].SetPoint(CurValue,MaxValue);
	m_PetBarMP[SrcIndex].GetPoint(CurValue,MaxValue);
	m_PetBarMP[DesIndex].SetPoint(CurValue,MaxValue);
	
	//BuffStatus
	m_PetStatusIconBuff[DesIndex].Clear();
	MaxRow = m_PetStatusIconBuff[SrcIndex].GetRowCount();
	for(Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconBuff[DesIndex].AddRow();
		MaxCol = m_PetStatusIconBuff[SrcIndex].GetColCount(Row);
		for(Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconBuff[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//DeBuffStatus
	m_PetStatusIconDeBuff[DesIndex].Clear();
	MaxRow = m_PetStatusIconDeBuff[SrcIndex].GetRowCount();
	for(Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconDeBuff[DesIndex].AddRow();
		MaxCol = m_PetStatusIconDeBuff[SrcIndex].GetColCount(Row);
		for(Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconDeBuff[SrcIndex].GetItem(Row, Col, info);
			info.bHideRemainTime = true;
			m_PetStatusIconDeBuff[DesIndex].AddCol(Row, info);
		}
	}

	//SongDanceStatus
	m_PetStatusIconSongDance[DesIndex].Clear();
	MaxRow = m_PetStatusIconSongDance[SrcIndex].GetRowCount();
	for(Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconSongDance[DesIndex].AddRow();
		MaxCol = m_PetStatusIconSongDance[SrcIndex].GetColCount(Row);
		for(Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconSongDance[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconSongDance[DesIndex].AddCol(Row, info);
		}
	}

	//TriggerSkillStatus
	m_PetStatusIconTriggerSkill[DesIndex].Clear();
	MaxRow = m_PetStatusIconTriggerSkill[SrcIndex].GetRowCount();
	for(Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconTriggerSkill[DesIndex].AddRow();
		MaxCol = m_PetStatusIconTriggerSkill[SrcIndex].GetColCount(Row);
		for(Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconTriggerSkill[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconTriggerSkill[DesIndex].AddCol(Row, info);
		}
	}

	m_PetStatusIconItem[DesIndex].Clear();
	maxrow = m_PetStatusIconItem[SrcIndex].GetRowCount();
	for(Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconItem[DesIndex].AddRow();
		MaxCol = m_PetStatusIconItem[SrcIndex].GetColCount(Row);
		for(Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconItem[SrcIndex].GetItem(Row,Col,Info);
			m_PetStatusIconItem[DesIndex].AddCol(Row,Info);
		}
	}

	// Ÿ���� Į�� ó��
	ClearTargetHighLight();
	HandleCheckTarget();
}

//�������� ������ ����
function ResizeWnd(bool bTryShow)
{
	local int idx;
	local Rect rectWnd;
	local int i;
	local int OpenPetCount;
	//local int nWndHeight;

	local  PartyMemberInfo partyMemberInfo;

	//Debug("ResizeWnd");
	// SetOptionBool�� ���. �� ������ PartyWndOption ���� �����
	
	// Debug("-- m_CurCount " @ m_CurCount);
	if(m_CurCount>0)
	{
		for(idx=0; idx<MAX_ArrayNum; idx++)
		{
			if(idx<=m_CurCount-1)
			{
				if(idx >0)	 //1 �̻��϶��� anchor�� ó�����ش�.
				{
					if(m_arrPetIDOpen[idx-1] == 1)// �� ��Ƽ���� ��ȯ���� �����ִٸ�
					{
						m_PartyStatus[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusSummonWnd" $ idx-1, "BottomLeft", "TopLeft", 0, DEFAULT_STATUS_GAP);//-4);	// �� ������ ������ ��Ŀ
					}
					else// �� ��Ƽ���� ��ȯ���� �����ְų� ��ȯ���� ������
					{
						m_PartyStatus[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ idx-1, "BottomLeft", "TopLeft", 0, DEFAULT_STATUS_GAP);// -4);	// ��Ƽ�� ������ ��Ŀ
					}
				}
				//if(m_arrID[idx] != 0)
				//{
				//	if(m_arrPetIDOpen[idx] > -1) m_petButton[idx].showWindow();
				//	else m_petButton[idx].HideWindow();

				//	m_PartyStatus[idx].SetVirtualDrag(true);
				//	m_PartyStatus[idx].ShowWindow();
				//}
				
				// ��Ƽ�� ����
				GetPartyMemberInfo(m_arrID[idx], partyMemberInfo);

				//Debug("RESIZE ---> partyMemberInfo.curSummonNum : "  @ partyMemberInfo.curSummonNum);
				// Debug("RESIZE ---> partyMemberInfo.curHavePet   : "  @ partyMemberInfo.curHavePet);
			
				// ��ȯ���� 1���� �̻� �ְų�, ���� �ִٸ�
				// ����â ����
				if(partyMemberInfo.curSummonNum > 0 || partyMemberInfo.curHavePet)
				{
					if(m_arrPetIDOpen[idx] == -1)
					{
						m_arrPetIDOpen[idx] = 1;
					}
					
					// ����â�� ����.
					m_PetPartyStatus[idx].ShowWindow();

					// Debug("m_arrPetIDOpen[i] " @ m_arrPetIDOpen[idx]);
					// Debug("-����â�� ���� " @ idx @ "  - > "  @ partyMemberInfo.curSummonNum);

					// ��ȯ���� �Ѹ��� �� �ִٸ�..
					if(partyMemberInfo.curSummonNum > 0)
					{						
						m_ClassIconSummon[idx].ShowWindow();
						setHideClassIconSummonNum(idx);
						//m_ClassIconSummonNum[idx].ShowWindow();
						m_ClassIconSummonNum[idx].SetTexture("L2UI_ch3.PARTYWND.party_summmon_num" $ String(partyMemberInfo.curSummonNum));
					}
					else
					{
						// ��ȯ���� ���ٸ�..
						m_ClassIconSummon[idx].HideWindow();
						m_ClassIconSummonNum[idx].HideWindow();
					}

					// ��ư�� ���� ��&��ȯ�� Ȯ�� â�� ����ڰ� �ݾ� ���� ���°� �ƴ϶��..
					//if(m_arrPetIDOpen[idx] != 2)

					// ���� ���� �Ѵٸ�..
					if(partyMemberInfo.curHavePet)
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

				if(m_arrID[idx] != 0)
				{
					if(m_arrPetIDOpen[idx] > -1) m_petButton[idx].showWindow();
					else m_petButton[idx].HideWindow();

					m_PartyStatus[idx].SetVirtualDrag(true);
					m_PartyStatus[idx].ShowWindow();
				}   

			}
			else
			{
				//Debug("â �ݱ�---rerere " @idx);
				m_petButton[idx].HideWindow();
				m_PartyStatus[idx].SetVirtualDrag(false);
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
				 if(m_PetPartyStatus[i].IsShowWindow())m_PetPartyStatus[i].HideWindow();
			}
		}

		//// �ϳ� �� ���� ������ ��� �ݱ�� ���
		//if(OpenPetCount > 0)
		//{
		//	//Debug("OpenPetCount" @ OpenPetCount);
		//	PartyWndOptionScript.setCheckAllPetClose(false);
		//}

		// Debug("OpenPetCount : " @ OpenPetCount);
		
		//������ ������ ����
		rectWnd = m_wndTop.GetRect();

		if(isCompact())
		{
			m_wndTop.SetWindowSize(rectWnd.nWidth,(DEFAULT_NPARTYSTATUS_HEIGHT * m_CurCount + OpenPetCount * DEFAULT_NPARTYPETSTATUS_HEIGHT)+ DEFAULT_FIRSTWND_ADD_HEIGHT);
		
			// ��â�� ������ ��ŭ ������ ������� �����ش�. 
			m_wndTop.SetResizeFrameSize(10, (DEFAULT_NPARTYSTATUS_HEIGHT * m_CurCount + OpenPetCount * DEFAULT_NPARTYPETSTATUS_HEIGHT)+ DEFAULT_FIRSTWND_ADD_HEIGHT);
		}
		else
		{
			//Debug("m_CurCount" @ m_CurCount);
			//if(m_CurCount == 1)nWndHeight = 0;
			//else nWndHeight = DEFAULT_FIRSTWND_ADD_HEIGHT;

			m_wndTop.SetWindowSize(rectWnd.nWidth,(DEFAULT_NPARTYSTATUS_HEIGHT * m_CurCount + OpenPetCount * DEFAULT_NPARTYPETSTATUS_HEIGHT + DEFAULT_STATUS_GAP *(m_CurCount - 1))+ DEFAULT_FIRSTWND_ADD_HEIGHT);
		
			Debug("DEFAULT_NPARTYSTATUS_HEIGHT!!" @ string(DEFAULT_NPARTYSTATUS_HEIGHT));
			Debug("DEFAULT_NPARTYPETSTATUS_HEIGHT!!" @ string(DEFAULT_NPARTYPETSTATUS_HEIGHT));
			// ��â�� ������ ��ŭ ������ ������� �����ش�. 
			if(getInstanceUIData().getIsClassicServer())
			{
				m_wndTop.SetResizeFrameSize(14, (((DEFAULT_NPARTYSTATUS_HEIGHT * m_CurCount) + (OpenPetCount * DEFAULT_NPARTYPETSTATUS_HEIGHT)) + (DEFAULT_STATUS_GAP * (m_CurCount - 1))) + DEFAULT_FIRSTWND_ADD_HEIGHT);				
			}
			else
			{
				m_wndTop.SetResizeFrameSize(10, (((DEFAULT_NPARTYSTATUS_HEIGHT * m_CurCount) + (OpenPetCount * DEFAULT_NPARTYPETSTATUS_HEIGHT)) + (DEFAULT_STATUS_GAP * (m_CurCount - 1))) + DEFAULT_FIRSTWND_ADD_HEIGHT);
			}
		}

			//m_wndTop.SetWindowSize(rectWnd.nWidth,(DEFAULT_NPARTYSTATUS_HEIGHT * m_CurCount + OpenPetCount * DEFAULT_NPARTYPETSTATUS_HEIGHT + DEFAULT_STATUS_GAP *(m_CurCount - 1))+ DEFAULT_FIRSTWND_ADD_HEIGHT);
		
			//// ��â�� ������ ��ŭ ������ ������� �����ش�. 
			//m_wndTop.SetResizeFrameSize(10       ,(DEFAULT_NPARTYSTATUS_HEIGHT * m_CurCount + OpenPetCount * DEFAULT_NPARTYPETSTATUS_HEIGHT + DEFAULT_STATUS_GAP *(m_CurCount - 1))+ DEFAULT_FIRSTWND_ADD_HEIGHT);// + DEFAULT_STATUS_GAP);


		// �ּ�ȭ ���, �Ϲ� ������ ��� ���� �ݱ�
		GetWindowHandle(m_WindowName).ShowWindow();
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
	for(idx=0; idx<MAX_ArrayNum; idx++)
	{
		if(m_arrID[idx] == ID)
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
	for(idx=0; idx<MAX_ArrayNum; idx++)
	{
		if(m_arrPetID[idx] == ID)
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
	for(idx=0; idx<MAX_ArrayNum; idx++)
	{
		if(m_arrSummonID[idx] == ID)
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

	ParseString(Param, "VName", VName);

	ParseString(Param, "SummonVName", SummonVName);	
	
	GetPartyMemberInfo(ID, partyMemberInfo);

	// ��ȯ�� ���� ��´�.
	// ParseInt(Param, "SummonCount", summonCount);
	GetPartyMemberPetInfo(ID, partyMemberPetInfo);
	
	if(ID>0)
	{
		m_Vname[m_CurCount].ID = ID;
		m_Vname[m_CurCount].UseVName = UseVName;
		m_Vname[m_CurCount].DominionIDForVName = DominionIDForVName;
		m_Vname[m_CurCount].VName = VName;
		m_Vname[m_CurCount].SummonVName = SummonVName;
		ExecuteEvent(EV_TargetUpdate);
	
		m_CurCount++;	
		
		m_arrID[m_CurCount-1] = ID;
		UpdateStatus(m_CurCount-1, param);

		// Debug("====================> param �� ���� " @ param);
		// Debug(":::: m_CurCount ====> " @ m_CurCount);
		// Debug("partyMemberInfo.curSummonNum: " @ partyMemberInfo.curSummonNum);
		// Debug("partyMemberInfo.curHavePet  : " @ partyMemberInfo.curHavePet);
		// if(SummonID > 0)	// ��ȯ���� ������ ��ȯ���� ������
		// ��ȯ���� �ִٸ�
		
		// ��ȯ���� �Ѹ��� �̻�, �Ǵ� ���� ���� �Ѵٸ�..
		if(partyMemberInfo.curSummonNum > 0)
		{
			// ��ȯ�� ������ ID �� �ְ� ��ȯ�� UI ����
			PartySummonProcess(ID);

			for(i = 0; i < SummonCount; i++)
			{
				ParseInt(param, "SummonType" $ i, summonType);
				ParseInt(param, "SummonClassID" $ i, summonClassID);

				// ��ȯ���� ���ٸ�..
				if(summonType == 1)
				{
					// ������ ��ȯ��, ����� ��ȯ�� ���� ������ �����Ѵ�.
					m_ClassIconSummon[m_CurCount - 1].SetTooltipText(GetSystemString(505));//getSummonSortString(class'UIDATA_NPC'.static.GetSummonSort(summonClassID)));
					//Debug("npc : "@ class'UIDATA_NPC'.static.GetSummonSort(summonClassID));
					
					break;
					// ���� ĵ�� 
				}				
			}
		}

		if(partyMemberInfo.curHavePet == true)
		{
			// ���� ���Ӱ� �߰� 
			index = FindPartyID(ID);
			// Debug("�߰� �߰� �� " @ index);
			// �ٷ� hp, mp �ٸ� ���� �ϱ� ���ؼ�

			ParseInt(param, "SummonCount", SummonCount);

			// summonType �� 2�� ���� ���̴�. ���� ã�Ƽ�..
			// HP, MP�ٸ� ���� ��Ų��. 
			for(i = 0; i < SummonCount; i++)
			{
				ParseInt(param, "SummonType" $ i, summonType);

				if(summonType == 2)
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

		setSummonPetOpen();
		ResizeWnd(true);
	}
}

//UPDATE	Ư�� ��Ƽ�� ������Ʈ.
function HandlePartyUpdateParty(string param)
{
	local int	ID;
	local int	idx;
	
	//Debug("��Ƽ :" @ param);
	ParseInt(param, "ID", ID);	

	if(ID>0)
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
	if(ID>0)
	{
		idx = FindPartyID(ID);
		if(idx>-1)
		{	
			for(i=idx; i<m_CurCount-1; i++)	// �����Ϸ��� ��Ƽ�� �Ʒ��� ��Ƽ������ �����ش�. 
			{
				CopyStatus(i, i+1);
			}
			ClearStatus(m_CurCount-1);
			ClearPetStatus(m_CurCount-1);
			m_CurCount--;
			ResizeWnd(true);	// ���� ��Ƽ���� �ڽŹۿ� ���ٸ� �˾Ƽ� ��Ƽ������� �����.
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
	{

		if(!isCompact())m_LeaderIcon[partymasteridx].SetTooltipCustomType(MakeTooltipSimpleText(GetRoutingString(lootingtype)));	

		m_PartyStatus[partymasteridx].SetTooltipCustomType(partyInfoTooltip(true, m_PlayerName[partymasteridx].GetName(), partymasterClassIDidx, lootingtype));
		m_ClassIcon[partymasteridx].SetTooltipCustomType(partyInfoTooltip(true, m_PlayerName[partymasteridx].GetName(), partymasterClassIDidx, lootingtype));
	}
}

function UpdateStatus(int idx, string param)
{
	local string	Name;
	
	local int		MasterID;
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
	local userinfo 	TargetUser;
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
	
	local string useName;
	//������Ƽ���� �ڵ���Ƽ ��û����
	local int iSubstatus;

	ParseInt(param, "SubStitute", iSubstatus);

	if(idx<0 || idx>=MAX_ArrayNum)
		return;
	
	ParseString(param, "Name", Name);
	ParseInt(param, "ID", ID);
	GetUserInfo(ID, TargetUser);
	
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

	// ���� ¡ǥ�� �������� �۾����ָ� ������ ��, ���� ¡ǥ�� �� update �̺�Ʈ�� �ȿ��� ������ ��� ����
	//if(class'UIDATA_PARTY'.static.GetMemberTacticalSign(ID)== 0)
	//{
	//	m_texMark[idx].HideWindow();
	//}
	//else
	//{
	//	m_texMark[idx].ShowWindow();
	//	m_texMark[idx].SetTexture("l2ui_Ct1.TargetStatusWnd_DF_mark_0" $ string(class'UIDATA_PARTY'.static.GetMemberTacticalSign(ID)- 1));
	//}

	//��Ƽ�� ���̵�.
	ParseInt(param, "MasterID", MasterID);

	if(MasterID > 0)
	{
		PartyLeaderID = MasterID;
	}

	if(!isCompact())
	{
		if(HP == 0)m_IsDead[idx].ShowWindow();
		else m_IsDead[idx].hideWindow();
	}
	
	if(HP == 0)
	{
		CheckDeadTarget(idx);
	} else {
		CheckNHideDeadTargetTexture(idx);
	}
	
	UseVName = m_Vname[idx].UseVName;
	//DominionIDForVName = m_Vname[idx].DominionIDForVName;
	VName = m_Vname[idx].VName;
	//SummonVName = m_Vname[idx].SummonVName;
	
	if(UseVName == 1)
	{
		useName = VName;
		//if(!isCompact())m_PlayerName[idx].SetName(VName, NCT_Normal,TA_Left);
	}
	else
	{
		useName = Name;
		//if(!isCompact())m_PlayerName[idx].SetName(Name, NCT_Normal,TA_Left);
	}

	//���� ������
	m_ClassIcon[idx].SetTexture(GetClassRoleIconNameBig(ClassID));
	//m_ClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetClassRoleName(ClassID)$ " - " $ GetClassType(ClassID)));
	
	//Debug("UpdateStatus" @ param);
	//Debug("MasterID" @ MasterID);
	//Debug("PartyLeaderID" @ PartyLeaderID);
	//Debug("ID" @ ID);

	//���� ������
	if(PartyLeaderID == ID)
	{	
		partymasteridx = idx;
		partymasterClassIDidx = ClassID;
		ParseInt(param, "RoutingType", partymasterRoutingType);

		//Debug("PartyLeaderID" @PartyLeaderID);
		//Debug("ID" @ID);
		//Debug("RoutingType" @ partymasterRoutingType);

		if(!isCompact())
		{
			m_LeaderIcon[idx].SetTexture("L2UI_CH3.PartyWnd.party_leadericon");
			m_LeaderIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetRoutingString(partymasterRoutingType)));
			m_PlayerName[idx].SetNameWithColor(useName, NCT_Normal,TA_Left, getInstanceL2Util().Yellow);
		}

		m_PartyStatus[idx].SetTooltipCustomType(partyInfoTooltip(true, useName, ClassID, partymasterRoutingType));
		m_ClassIcon[idx].SetTooltipCustomType(partyInfoTooltip(true, useName, ClassID, partymasterRoutingType));
	}
	else
	{
		if(!isCompact())
		{
			m_LeaderIcon[idx].SetTexture("");
			m_LeaderIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(""));
			m_PlayerName[idx].SetNameWithColor(useName, NCT_Normal,TA_Left, getInstanceL2Util().BrightWhite);
		}

		m_PartyStatus[idx].SetTooltipCustomType(partyInfoTooltip(false, useName, ClassID));
		m_ClassIcon[idx].SetTooltipCustomType(partyInfoTooltip(false, useName, ClassID));
	}
	// End:0x4E8
	if(getInstanceUIData().getIsLiveServer())
	{
		// End:0x4AC
		if(vitality != 0)
		{
			m_SGIcon[idx].SetTexture("L2UI_CT1.PartyStatusWnd.VPICON_ON");
		}
		else
		{
			m_SGIcon[idx].SetTexture("L2UI_CT1.PartyStatusWnd.VPICON_OFF");
		}
	}
	else
	{
		// End:0x52E
		if(vitality != 0)
		{
			m_SGIcon[idx].SetTexture("L2UI_CT1.PartyStatusWnd.SGICON_ON");			
		}
		else
		{
			m_SGIcon[idx].SetTexture("L2UI_CT1.PartyStatusWnd.SGICON_OFF");
		}
	}

	SetNamePostion(idx);
	
	//���� ������
	UpdateCPBar(idx, CP, MaxCP);
	UpdateHPBar(idx, HP, MaxHP);
	UpdateMPBar(idx, MP, MaxMP);
}

function HandlePartyPetAdd(string param)
{
	local int	MasterID;
	local int	ID;
	local int	i;

	// ��ȯ�� 1, �� 2
	local int   type;
	local int	MasterIndex;
	
	ParseInt(param, "Type", type);	// ������ ID�� �Ľ��Ѵ�.

	// Debug("�� �߰� @" @ param);
	if(type == 2)
	{
		// ������ ID�� �Ľ��Ѵ�.
		ParseInt(param, "MasterID", MasterID);	

		// ID�� �Ľ��Ѵ�.
		ParseInt(param, "ID", ID);	

		if(MasterID>0)
		{
			MasterIndex = -1;
			for(i=0; i< MAX_ArrayNum ; i++)
			{
				if(m_arrID[i] == MasterID)MasterIndex = i;
			}
			
			if(MasterIndex == -1)
			{
				//debug("HandlePartyPetAdd ERROR - Can't find master ID");
				return;
			}
						
			m_arrPetID[MasterIndex] = ID;
			m_arrPetIDOpen[MasterIndex] = 1;

			UpdatePetStatus(MasterIndex, param);
			ResizeWnd(true);
		}
	}
}

function HandlePartyPetUpdate(string param)
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
	if(type == 2)
	{	
		idx = FindPetID(id);

		// Debug("idx " @ idx);
		// �ش� �ε����� �� ������ ����
		UpdatePetStatus(idx, param);	
	}
}


function HandlePartyPetDelete(string param)
{
	local int	SummonID;
	local int	idx;
	//~ local int	i;
	
	ParseInt(param, "SummonID", SummonID);
	if(SummonID>0)
	{
		idx = FindPetID(SummonID);
		if(idx>-1)
		{	
			ClearPetStatus(idx);
			ResizeWnd(true);	// ���� ��Ƽ���� �ڽŹۿ� ���ٸ� �˾Ƽ� ��Ƽ������� �����.
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
	
	if(idx<0 || idx>=MAX_ArrayNum)
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
	//m_ClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetClassRoleName(ClassID)$ " - " $ GetClassType(ClassID)));
	
	// debug(" idx :MaxHP" @ idx @ "__" @MaxHP);
	//���� ������
	UpdateHPBar(idx + 100, HP, MaxHP);
	UpdateMPBar(idx + 100, MP, MaxMP);
}

/**
 *  ��Ƽ���� ��ȯ�� �߰�
 **/
function HandlePartySummonAdd(string param)
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

	//debug("class " @  m_SummonInfo.nClassID);
	//Debug("��ȯ�� �߰� @" @ param);

	idx = FindSummonMasterID(MasterID);
	if(idx > 0)
	{
		m_ClassIconSummon[idx].SetTooltipText(GetSystemString(505));//getSummonSortString(class'UIDATA_NPC'.static.GetSummonSort(m_SummonInfo.nClassID)));
	}

	if(type == 1)
	{		
		PartySummonProcess(MasterID);
	}

	setSummonPetOpen();
	ResizeWnd(true);
}

/**
 *  ��Ƽ�� ��ȯ���� ������ �޾Ƽ� ����â���� ǥ�� 
 **/
function PartySummonProcess(int MasterID)
{
	local int	i;

	local int	MasterIndex;

	local PartyMemberInfo partyMemberInfo;
	
	if(MasterID>0)
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

		if(partyMemberInfo.curSummonNum > 0)
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
		//ResizeWnd();		
	}
}

/**
 *  ��Ƽ���� ��ȯ�� ������Ʈ
 **/
function HandlePartySummonUpdate(string param)
{
	local int	MasterID;

	// ��ȯ�� 1, �� 2
	local int   type;

	// �ɹ� ���̵� ���ؼ� ��ȯ�� ���� ��� �װ� ���� ���ִ� �ڵ带 �־�� ��
	// debug("��ȯ�� ������Ʈ !" @param);

	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "Type", type);	

	// ��ȯ�� 
	if(type == 1)
	{	
		PartySummonProcess(MasterID);
		ResizeWnd(true);
	}
}



function HandlePartySummonDelete(string param)
{
	local int	SummonMasterID;
	local int	idx;
	local  PartyMemberInfo partyMemberInfo;

	
	ParseInt(param, "SummonMasterID", SummonMasterID);

	if(SummonMasterID > 0)
	{

		// ��ȯ�� �������� index �� ã�´�.
		idx = FindSummonMasterID(SummonMasterID);

		GetPartyMemberInfo(SummonMasterID, partyMemberInfo);
		// Debug("����.. ---> partyMemberInfo.curSummonNum : "  @ partyMemberInfo.curSummonNum);

		// ��ȯ���� �Ѹ��� �� �ִٸ�..
		if(partyMemberInfo.curSummonNum > 0)
		{						
			m_ClassIconSummon[idx].ShowWindow();
			setHideClassIconSummonNum(idx);
			//m_ClassIconSummonNum[idx].ShowWindow();
			m_ClassIconSummonNum[idx].SetTexture("L2UI_ch3.PARTYWND.party_summmon_num" $ String(partyMemberInfo.curSummonNum));
		}
		else
		{
			// ��ȯ���� ���ٸ�..
			ClearSummonStatus(idx);
		}		
		ResizeWnd(true);		
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
	
	if(idx<0 || idx>=MAX_ArrayNum)
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

	// �� ��ȯ���� ���� ���� ������ ǥ�� ���� ����(���� ���� ǥ��)
	// UpdateHPBar(idx + 100, HP, MaxHP);
	// UpdateMPBar(idx + 100, MP, MaxMP);
}


//��������Ʈ����
function HandlePartySpelledList(string param)
{
	local int i;
	local int idx;
	local int ID;
	local int Max;
	
	local int BuffCnt;
	local int BuffCurRow;
	
	local int DeBuffCnt;
	local int DeBuffCurRow;
	
	//~ local int SongDanceCnt;
	//local int SongDanceCurRow;
	
	local int TriggerSkillCnt;
	local int TriggerSkillCurRow;
	local int ItemCnt;
	local int ItemCntCurRow;

	local bool isPC;	//pc���� ������ üũ�ϴ� �Լ�
	
	local StatusIconInfo info;
	
	DeBuffCurRow = -1;
	BuffCurRow = -1;
	//SongDanceCurRow = -1;
	TriggerSkillCurRow = -1;
	isPC = false;
	ItemCntCurRow = -1;

	ParseInt(param, "ID", ID);
	if(ID<1)
	{
		return;
	}
	
	idx = FindPartyID(ID);
	if(idx >=0)
	{
		//���� �ʱ�ȭ
		m_StatusIconBuff[idx].Clear();
		m_StatusIconDeBuff[idx].Clear();
		m_StatusIconSongDance[idx].Clear();
		m_StatusIconItem[idx].Clear();
		m_StatusIconTriggerSkill[idx].Clear();
		isPC = true;
	}
	else	// ��Ƽ���̸� ���� �׳� �н�
	{
		idx = FindPetID(ID);	// ��Ƽ���� �ƴ϶��, ������ ���캻��. 
		if(idx >= 0)
		{
			//���� �ʱ�ȭ
			m_PetStatusIconBuff[idx].Clear();
			m_PetStatusIconDeBuff[idx].Clear();
			m_PetStatusIconSongDance[idx].Clear();
			m_PetStatusIconTriggerSkill[idx].Clear();
			m_PetStatusIconItem[idx].Clear();
			isPC = false;
		}
		else
		{
			return;	// �� ���̵��� ���ٸ� �� ���ù���
		}
	}
		
	//info �ʱ�ȭ
	if(isPC)
	{
		info.Size = DEFAULT_BUFFICON_SIZE;
	}
	else 
	{
		info.Size = DEFAULT_BUFFICON_SIZE_FORSUMMON;
	}
	
	info.bShow = true;
	
	ParseInt(param, "Max", Max);
	for(i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "Level_" $ i, info.Level);
		ParseInt(param, "SubLevel_" $ i, info.SubLevel);

		if(IsIconHide(Info.Id,Info.Level,Info.SubLevel))
		{
			continue ;
		}
		// ���� ������ ��� add ���� ����.
		if(class'UIDATA_SKILL'.static.IsToppingSkill(info.ID, info.Level, info.SubLevel))
		{			
			continue ;
		}

		ParseInt(param, "Sec_" $ i, info.RemainTime);

		ParseInt(param, "SpellerID_" $ i, info.SpellerID);

		//Debug("HandlePartySpelledList" @ idx @ info.SpellerID @ info.Level @ info.ID.ClassID @  i);

		if(IsValidItemID(info.ID))
		{
			info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, info.Level, info.SubLevel);
			info.IconPanel = class'UIDATA_SKILL'.static.GetIconPanel(info.Id,info.Level,info.SubLevel);

			if(GetDebuffType(info.ID, info.Level, info.SubLevel)!= 0)
			{
				info.bHideRemainTime = true;
				if(DeBuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					DeBuffCurRow++;
					if(isPC)	
					{			
						m_StatusIconDeBuff[idx].AddRow();
					}
					else		
					{	
						m_PetStatusIconDeBuff[idx].AddRow();
					}
				}
				if(isPC)	
				{				
					m_StatusIconDeBuff[idx].AddCol(DeBuffCurRow, info);	
				}
				else 		
				{					
					m_PetStatusIconDeBuff[idx].AddCol(DeBuffCurRow, info);	
				}
				DeBuffCnt++;
			}
			else if(GetIndexByIsMagic(Info)== 3)
			{
				//~ debug("�۴��Դϱ�?");
				//~ SongDanceCurRow++;
				if(isPC)	
				{					
					m_StatusIconSongDance[idx].AddRow();
				}
				else		
				{				
					m_PetStatusIconSongDance[idx].AddRow();
				}
				
				if(isPC)	
				{				
					m_StatusIconSongDance[idx].AddCol(0, info);	
				}
				else 		
				{				
					m_PetStatusIconSongDance[idx].AddCol(0, info);	
				}
				//~ SongDanceCurRow++;
			}
			else if(GetIndexByIsMagic(Info)== 4)
			{
				if(ItemCnt % NSTATUSICON_MAXCOL == 0)
				{
					ItemCntCurRow++;
					if(isPC)
					{
						m_StatusIconItem[idx].AddRow();
					}
					else
					{
						m_PetStatusIconItem[idx].AddRow();
					}
				}
				if(isPC)
				{
					m_StatusIconItem[idx].AddCol(ItemCntCurRow,Info);
				}
				else
				{
					m_PetStatusIconItem[idx].AddCol(ItemCntCurRow,Info);
				}
				ItemCnt++;
			}
			else if(GetIndexByIsMagic(Info)== 5)
			{
				//~ debug("�ߵ������Դϱ�?");
				if(TriggerSkillCnt % NSTATUSICON_MAXCOL == 0)
				{
					TriggerSkillCurRow++;
					if(isPC)	
					{				
						m_StatusIconTriggerSkill[idx].AddRow();
					}
					else		
					{					
						m_PetStatusIconTriggerSkill[idx].AddRow();
					}
				}
					
				if(isPC)	
				{					
					m_StatusIconTriggerSkill[idx].AddCol(TriggerSkillCurRow, info);	
				}
				else 		
				{				
					m_PetStatusIconTriggerSkill[idx].AddCol(TriggerSkillCurRow, info);	
				}
				TriggerSkillCnt++;
			}
			else
			{
				//~ debug("�Ϲ� �����Դϱ�?");
				if(BuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					BuffCurRow++;
					if(isPC)	
					{						
						m_StatusIconBuff[idx].AddRow();
					}
					else
					{					
						m_PetStatusIconBuff[idx].AddRow();
					}
				}
				if(isPC)	
				{					
					m_StatusIconBuff[idx].AddCol(BuffCurRow, info);	
				}
				else		
				{				
					m_PetStatusIconBuff[idx].AddCol(BuffCurRow, info);	
				}
				BuffCnt++;
			}
		}
	}
	UpdateBuff();
}

//��������Ʈ����
function HandlePartySpelledListDelete(string param)
{
	local int i;		
	local int idx;
	local int ID;
	local int Max;		
	local StatusIconInfo info;		

	local bool isPC;
	
	ParseInt(param, "ID", ID);	

	if(ID<1)return;	
	idx = FindPartyID(ID);	
	if(idx < 0)
	{
		isPC = false;
		idx = FindPetID(ID);
	} 
	else isPC = true;

	if(idx < 0)return;	
		
	ParseInt(param, "Max", Max);	

	for(i=0; i<Max; i++)
	{
		//���� ������ �˱� ���� ID, Level
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "Level_" $ i, info.Level);
		ParseInt(param, "SubLevel_" $ i, info.SubLevel);

		//ttp 60079
		ParseInt(param, "SpellerID_" $ i, info.SpellerID);

		//Debug("HandlePartySpelledListDelete"  @ idx @ info.SpellerID @ info.Level @ info.ID.ClassID @  i);
		
		if(IsValidItemID(info.ID))
		{	
			//������̸� 
			if(GetDebuffType(info.ID, info.Level, info.SubLevel)!= 0)
			{
				if(isPC)deleteBuff(m_StatusIconDeBuff[idx], info.Level, info.ID.ClassID, info.SpellerID); 
				else 		deleteBuff(m_PetStatusIconDeBuff[idx], info.Level, info.ID.ClassID, info.SpellerID); 							
			}
			//�۴�
			else if(GetIndexByIsMagic(Info)== 3)
			{	
				if(isPC)deleteBuff(m_StatusIconSongDance[idx], info.Level, info.ID.ClassID, info.SpellerID);
				else        deleteBuff(m_PetStatusIconSongDance[idx], info.Level, info.ID.ClassID, info.SpellerID);
			}
			else if(GetIndexByIsMagic(Info)== 4)
			{
				if(isPC)
					deleteBuff(m_StatusIconItem[idx],Info.Level,Info.Id.ClassID,Info.SpellerID);
				else
					deleteBuff(m_PetStatusIconItem[idx],Info.Level,Info.Id.ClassID,Info.SpellerID);
			}
			//�����
			else if(GetIndexByIsMagic(Info)== 5)
			{								
				if(isPC)deleteBuff(m_StatusIconTriggerSkill[idx], info.Level, info.ID.ClassID, info.SpellerID);
				else        deleteBuff(m_PetStatusIconTriggerSkill[idx], info.Level, info.ID.ClassID, info.SpellerID); 
			}
			//�Ϲ� ���� 
			else
			{				
				if(isPC)deleteBuff(m_StatusIconBuff[idx], info.Level, info.ID.ClassID, info.SpellerID); 
				else        deleteBuff(m_PetStatusIconBuff[idx], info.Level, info.ID.ClassID, info.SpellerID);
			}
			
			
		}
	}
	UpdateBuff();
}

//���� ������ ������ ã�� ���� �ϴ� �Լ�
//ttp 60079 �� SpellerID �߰�.
function deleteBuff(StatusIconHandle tmpStatusIcon , int level, int classID, int SpellerID)
{
	local int row;	
	local int col;
	local StatusIconInfo info;	

	for(row = 0 ; row < tmpStatusIcon.GetRowCount(); row++)
	{
		for(col = 0 ; col < tmpStatusIcon.GetColCount(row); col++)
		{
			tmpStatusIcon.GetItem(row, col, info);			
			if(info.ID.classID == classID && info.level ==  level && info.SpellerID == SpellerID)
			{
				tmpStatusIcon.DelItem(row, col);
				refreshPostion(tmpStatusIcon , row);
				return;
			}
		}
	}
}
//������ �� �� �̻� �� ��� ������ �� ĭ�� ���� �ִ� �Լ�
function refreshPostion(StatusIconHandle tmpStatusIcon , int deletedRow )
{
	local int row;
	local StatusIconInfo info;	

	for(row = deletedRow ; row < tmpStatusIcon.GetRowCount()-1 ; row ++)
	{
		tmpStatusIcon.GetItem(row + 1 ,   0,  info);//���� �ٿ� �ִ� �� �� �� ���� ���� ���� ���� 
		tmpStatusIcon.addCol(row, info);// �� �������� ������ �ٿ� ä�� ���� ����
		tmpStatusIcon.DelItem(row + 1, 0); // �����.
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

	if(ID<1)return;	

	idx = FindPartyID(ID);	
	if(idx < 0)
	{
		isPC = false;
		idx = FindPetID(ID);
	} 
	else isPC = true;

	if(idx < 0)return;
		
	//info �ʱ�ȭ
	if(isPC)
	{
		info.Size = DEFAULT_BUFFICON_SIZE;
	}
	else 
	{
		info.Size = DEFAULT_BUFFICON_SIZE_FORSUMMON;
	}
	
	info.bShow = true;	

//	Debug("HandlePartySpelledListInsert" @ String(isPC)@ idx);
	//Max=1 ID=1209091781 ClassID_0=77 Level_0=2 Sec_0=1200
	ParseInt(param, "Max", Max);

	for(i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "Level_" $ i, info.Level);
		ParseInt(param, "SubLevel_" $ i, info.SubLevel);

		if(IsIconHide(Info.Id,Info.Level,Info.SubLevel))
		{			
			continue ;
		}

		// ���� ������ ��� add ���� ����.
		if(class'UIDATA_SKILL'.static.IsToppingSkill(info.ID, info.Level, info.SubLevel))
		{			
			continue ;
		}

		ParseInt(param, "Sec_" $ i, info.RemainTime);

		//ttp 60079
		ParseInt(param, "SpellerID_" $ i, info.SpellerID);
		//Debug("HandlePartySpelledListInsert"  @ idx @ info.SpellerID @ info.Level @ info.ID.ClassID @  i);

		if(IsValidItemID(info.ID))
		{
			info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, info.Level, info.SubLevel);
			info.IconPanel = class'UIDATA_SKILL'.static.GetIconPanel(info.Id,info.Level,info.SubLevel);
			info.bHideRemainTime = true;

			//������̸� 
			if(GetDebuffType(info.ID, info.Level, info.SubLevel)!= 0)
			{
				if(isPC)tmpStatusIcon = m_StatusIconDeBuff[idx];
				else 		tmpStatusIcon = m_PetStatusIconDeBuff[idx];				
				
			}
			//�۴�
			else if(GetIndexByIsMagic(Info)== 3)
			{	
				if(isPC)tmpStatusIcon = m_StatusIconSongDance[idx];	
				else        tmpStatusIcon = m_PetStatusIconSongDance[idx];
			}
			else if(GetIndexByIsMagic(Info)== 4)
			{
				if(isPC)
					tmpStatusIcon = m_StatusIconItem[idx];
				else
					tmpStatusIcon = m_PetStatusIconItem[idx];
			}
			//�����
			else if(GetIndexByIsMagic(Info)== 5)
			{								
				if(isPC)tmpStatusIcon = m_StatusIconTriggerSkill[idx];
				else        tmpStatusIcon = m_PetStatusIconTriggerSkill[idx];
			}
			//�Ϲ� ���� 
			else 
			{				
				if(isPC)tmpStatusIcon = m_StatusIconBuff[idx];
				else        tmpStatusIcon = m_PetStatusIconBuff[idx];
			} 	
			
			//���� �κ�
			deleteBuff(tmpStatusIcon, info.Level, info.ID.ClassID, info.SpellerID); 

			//�߰� �κ�			
			if(tmpStatusIcon.GetRowCount()== 0 || tmpStatusIcon.GetColCount(tmpStatusIcon.GetRowCount()-1)% NSTATUSICON_MAXCOL == 0)
			{				
				tmpStatusIcon.AddRow();
			}
			tmpStatusIcon.AddCol(tmpStatusIcon.GetRowCount()-1 , info);
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
		
	if(m_CurBf > MAX_BUFF_ICONTYPE)
	{
		m_CurBf = 0;
	}
	
	SetINIInt(m_WindowName,"a",m_CurBf,"WindowsInfo.ini");

	SetBuffButtonTooltip();
	UpdateBuff();
}

// ��ưŬ�� �̺�Ʈ
function OnClickButton(string strID)
{
	local int idx;
	
	//Debug("strID" @ strID);
	switch(strID)
	{
		case "btnBuff":		//������ư Ŭ���� 
			OnBuffButton();
			break;

		case "btnOption":
		//case "btnCompact":	// �ɼ� ��ư Ŭ����
			OnOpenPartyWndOption();
			break;	

		case "btnSummon":	// ��ȯ�� ��ư Ŭ����
			debug("ERROR - you can't enter here");	// ����� ������ ���� -_-;
			break;
	}

	if(inStr(strID , "btnSummon")> -1)
	{
		idx = int(Right(strID , 1));

		//Debug("idx===> " @idx);

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
		ResizeWnd(true);
	}
}

// �ɼǹ�ư Ŭ���� �Ҹ��� �Լ�
function OnOpenPartyWndOption()
{
	local int i;
	local PartyWndOption script;
	script = PartyWndOption(GetScript("PartyWndOption"));
	
	// �����ִ� ��ȯ�� â ������ �ɼ� ������ , ���� ������� �����Ѵ�. 
	for(i=0; i < MAX_PartyMemberCount; i++)
	{
		script.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
	}
	
	script.ShowPartyWndOption();
	m_PartyOption.SetAnchor(m_WindowName $ "." $ "PartyStatusWnd0", "TopRight", "TopLeft", 5, 5);
}

// ������ư�� ������ ��� ����Ǵ� �Լ�
function OnBuffButton()
{
	m_CurBf = m_CurBf + 1;

	//3���� ��尡 ��ȯ�ȴ�.
	if(m_CurBf > MAX_BUFF_ICONTYPE)
	{
		m_CurBf = 0;
	}

	SetINIInt(m_WindowName,"a",m_CurBf,"WindowsInfo.ini");
	
	SetBuffButtonTooltip();
	UpdateBuff();
}

// ����ǥ��, ����� ǥ��,  ���� 3������带 ��ȯ�Ѵ�.
function UpdateBuff()
{
	local int idx;
	if(m_CurBf == 1)
	{
		for(idx=0; idx<MAX_ArrayNum; idx++)
		{
			m_StatusIconBuff[idx].ShowWindow();
			m_PetStatusIconBuff[idx].ShowWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
		}
	}
	else if(m_CurBf == 2)
	{
		for(idx=0; idx<MAX_ArrayNum; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();	
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].ShowWindow();	
			m_PetStatusIconDeBuff[idx].ShowWindow();
			m_StatusIconSongDance[idx].HideWindow();	
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();	
			m_PetStatusIconTriggerSkill[idx].HideWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
		}
	}
	else if(m_CurBf == 3)
	{
		for(idx=0; idx<MAX_ArrayNum; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();	
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();	
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].ShowWindow();	
			m_PetStatusIconSongDance[idx].ShowWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();	
			m_PetStatusIconTriggerSkill[idx].HideWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
		}
	}
	else if(m_CurBf == 4)
	{
		for(idx=0; idx<MAX_ArrayNum; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();	
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();	
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();	
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconItem[idx].ShowWindow();
			m_PetStatusIconItem[idx].ShowWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
		}
	}
	else
	{
		for(idx=0; idx<MAX_ArrayNum; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();	
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();	
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();	
			m_PetStatusIconTriggerSkill[idx].HideWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
		}
	}
}

//CP�� ����
function UpdateCPBar(int idx, int Value, int MaxValue)
{
	m_BarCP[idx].SetPoint(Value, MaxValue);
}

//HP�� ����
function UpdateHPBar(int idx, int Value, int MaxValue)
{
	if(idx < 100)
		m_BarHP[idx].SetPoint(Value,MaxValue);
	else
		m_PetBarHP[idx - 100].SetPoint(Value, MaxValue);
}

//MP�� ����
function UpdateMPBar(int idx, int Value, int MaxValue)
{
	if(idx < 100)
		m_BarMP[idx].SetPoint(Value,MaxValue);
	else 	// 100���� ũ�� ���� �����Ŷ��..
		m_PetBarMP[idx - 100].SetPoint(Value,MaxValue);
}

function int getIdxByWindowHandle(WindowHandle a_WindowHandle)
{
	local int idx, i;

	idx = -1;

	if(a_WindowHandle == None)return -1;

	// �ֻ��� ������� �θ� üũ ���� �ʴ´�. 
	if(a_WindowHandle.GetWindowName()== m_WindowName)return -1;

	if(Left(a_WindowHandle.GetWindowName(), Len("PartyStatusWnd"))== "PartyStatusWnd")
	{
		idx = int(Right(a_WindowHandle.GetWindowName(), 1));

		//Debug("a_WindowHandle : " @ a_WindowHandle.GetWindowName());
		//Debug("���� Ÿ�� indedx " @ idx);
	}
	else
	{
		i = -1;
		if(Left(a_WindowHandle.GetParentWindowName(), Len("PartyStatusWnd"))== "PartyStatusWnd")
		{
			idx = int(Right(a_WindowHandle.GetParentWindowName(), 1));

			//Debug("�θ� a_WindowHandle : " @ a_WindowHandle.GetParentWindowName());
			//Debug("�θ� ���� Ÿ�� indedx " @ idx);

		}
		// �� ���� Ŭ�� �ߴ��� üũ
		
		else if(Left(a_WindowHandle.GetWindowName(), Len("PartyStatusSummonWnd"))== "PartyStatusSummonWnd")
		{
			i = int(Right(a_WindowHandle.GetWindowName(), 1));
		}
		else if(Left(a_WindowHandle.GetParentWindowName(), Len("PartyStatusSummonWnd"))== "PartyStatusSummonWnd")
		{
			i = int(Right(a_WindowHandle.GetParentWindowName(), 1));
		}
		if(i > -1)
		{
			if(m_arrPetIDOpen[i] == 1)// �ش� �ε����� ���� �����ִٸ�
			{
				idx = i + 100;	//���� ��� 100�� ���Ͽ� �����ش�. 
			}
		}

		//Debug("�� a_WindowHandle : " @ a_WindowHandle.GetParentWindowName());
		//Debug("�� ���� Ÿ�� indedx " @ idx);
	}

	return idx;
}

//��Ƽ�� Ŭ�� ������..
function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local UserInfo userinfo;
	local int idx;

	idx = getIdxByWindowHandle(a_WindowHandle);

	//Debug("idx" @ idx);


	if(idx == -1 || a_WindowHandle == None)return;

	if(GetPlayerInfo(userinfo))
	{
		if(IsPKMode())
		{
			if(idx <100)
			{
				// ��Ƽ��
				RequestAttack(m_arrID[idx], userinfo.Loc);
			}
			else
			{			
				// ��, ��ȯ��
				RequestAttack(m_arrPetID[idx-100], userinfo.Loc);
			}
		}
		else
		{
			if(idx < 100)
			{
				RequestAction(m_arrID[idx], userinfo.Loc);
			}
			else
			{
				RequestAction(m_arrPetID[idx-100], userinfo.Loc);
			}
		}
	}
}

//��Ƽ���� ��ý�Ʈ
function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local UserInfo userinfo;
	local int idx;

	idx = getIdxByWindowHandle(a_WindowHandle);

	if(idx == -1 || a_WindowHandle == None)return;

	if(GetPlayerInfo(userinfo))
	{
		if(idx <100)
		{
			RequestAssist(m_arrID[idx], userinfo.Loc);
			m_AssistAnimTex[idx].Stop();
			m_AssistAnimTex[idx].Play();
		}
		else
		{
			RequestAssist(m_arrPetID[idx-100], userinfo.Loc);
		}
	}
}

// ���� ������ �����Ѵ�.
function SetBuffButtonTooltip()
{
	local Color b1, b2, b3, b4;//, b0;
	local Array<DrawItemInfo> drawListArr;

	b1 = getInstanceL2Util().Gray;
	b2 = getInstanceL2Util().Gray;
	b3 = getInstanceL2Util().Gray;
	b4 = getInstanceL2Util().Gray;
	//b0 = getInstanceL2Util().Gray;
	//Debug("m_CurBf" @ m_CurBf);

	//Debug("m_CurBf" @ m_CurBf);

	if(m_CurBf == 0)
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbutton_off", "L2ui_CH3.PartyWnd.party_buffbutton_off",  "L2ui_CH3.PartyWnd.party_buffbutton_off");
	}
	else
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbutton_" $ m_CurBf,  "L2ui_CH3.PartyWnd.party_buffbutton_" $ m_CurBf, "L2ui_CH3.PartyWnd.party_buffbutton_" $ m_CurBf);
	}

	switch(m_CurBf)
	{
		case 0:	
			//b0 = getInstanceL2Util().Yellow;
			break;

		case 1:	
			b1 = getInstanceL2Util().Yellow;
			break;

		case 2:
			b2 = getInstanceL2Util().Yellow;
			break;

		case 3:
			b3 = getInstanceL2Util().Yellow;
			break;

		case 4:
			b4 = getInstanceL2Util().Yellow;
			break;
	}
	//drawListArr.Length = 5;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1496), b1, "", true, true); // ����� ����
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1497), b2, "", true, true); // �ó���/��/�� ����
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1741), b3, "", true, true); // Ư�� �̻���� ����
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2307), b4, "", true, true); // �̻���� ����

	//drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(228), b0, "", true, true);  // ����
	btnBuff.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function OnDropWnd(WindowHandle hTarget, WindowHandle hDropWnd, int x, int y)
{
	local string sTargetName, sDropName ,sTargetParent;
	local int dropIdx, targetIdx, i;
	
	//local  PartyWnd script1;			// Ȯ��� ��Ƽâ�� Ŭ����
	//local PartyWndCompact script2;	// ��ҵ� ��Ƽâ�� Ŭ����
	
	//script1 = PartyWnd(GetScript("PartyWnd"));
	//script2 = PartyWndCompact(GetScript("PartyWndCompact"));
	
	dropIdx = -1;
	targetIdx = -1;
	
	if(hTarget == None || hDropWnd == None)
		return;
	
	sTargetName = hTarget.GetWindowName();
	sDropName = hDropWnd.GetWindowName();
	sTargetParent = hTarget.GetParentWindowName();
	
	// PartyStatusWnd���� �巡�� �� ����� �� �� �ִ�. 
	if(((InStr(sTargetName , "PartyStatusWnd")== -1)&&(InStr(sTargetParent , "PartyStatusWnd")== -1) )||(InStr(sDropName, "PartyStatusWnd")== -1))
	{
		return;
	}
	else
	{
		dropIdx = int(Right(sDropName , 1));
		
		if(InStr(sTargetName , "PartyStatusWnd")> -1)	//Ÿ�� ������ ���� �ܿ�
			targetIdx = int(Right(sTargetName , 1));
		else									//Ÿ�� ������ ������ �θ��� �̸��� PartyStatusWnd �϶�
			targetIdx = int(Right(sTargetParent , 1));
		
		if(dropIdx <0 || targetIdx <0)
		{
			//Debug("ERROR IDX: " $ dropIdx $ " / " $  targetIdx);
		}
		
		// �Ʒ� Ȥ�� ���� �о��ִ� �ڵ�
		if(dropIdx > targetIdx)
		{
			CopyStatus(MAX_PartyMemberCount , dropIdx);		//Ÿ���� �Űܳ���
			//script2.CopyStatus(MAX_PartyMemberCount , dropIdx);		//Ÿ���� �Űܳ���
			
			for(i=dropIdx-1; i>targetIdx-1; i--)	// �Ʒ��� �о��ش�. 
			{
				CopyStatus(i+1, i);
				//script2.CopyStatus(i+1, i);
			}
			CopyStatus(targetIdx , MAX_PartyMemberCount );
			//script2.CopyStatus(targetIdx , MAX_PartyMemberCount );
		}
		else if(dropIdx < targetIdx)
		{
			CopyStatus(MAX_PartyMemberCount, dropIdx);		//Ÿ���� �Űܳ���
			//script2.CopyStatus(MAX_PartyMemberCount , dropIdx);		//Ÿ���� �Űܳ���
			
			for(i=dropIdx+1; i<targetIdx+1; i++)	// ���� �����ش�.
			{
				CopyStatus(i-1, i);
				//script2.CopyStatus(i-1, i);
			}
			CopyStatus(targetIdx , MAX_PartyMemberCount);
			//script2.CopyStatus(targetIdx , MAX_PartyMemberCount);
		}

		ClearStatus(MAX_PartyMemberCount);
		ClearPetStatus(MAX_PartyMemberCount);
		
		//Update Client Data
		class'UIDATA_PARTY'.static.MovePartyMember(dropIdx, targetIdx);
		
		ResizeWnd(true);
	}
}

function int GetVNameIndexByID(int ID)
{
	local int i;
	for(i=0; i<MAX_ArrayNum; i++)
	{
		if(m_Vname[i].ID == ID)
			return i;
	}
	return -1;
}

function ResetVName()
{
	local int i;
	
	for(i=0; i<MAX_ArrayNum; i++)
	{
		m_Vname[i].ID = i;
		m_Vname[i].UseVName = 0;
		m_Vname[i].DominionIDForVName = 0;
		m_Vname[i].VName = "";
		m_Vname[i].SummonVName = "";
	}
}

// ��Ƽ�� ���ο� ���� �̸� ��ġ�� ����
function SetNamePostion(int idx)
{
	// ����Ʈ ���� ���� ������ ����
	if(!isCompact())
	{
		if(m_LeaderIcon[idx].GetTextureName()!= "")
		{
			//������ ����� ���� �ؽ�Ʈ �ʵ� ������ ����
			m_PlayerName[idx].SetWindowSizeRel(1.0f, 0, -48, 14);
			m_PlayerName[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ idx, "TopLeft", "TopLeft", PARTY_NAME_POSTION_Y + PARTY_MASTER_WEIGHT , PARTY_NAME_POSTION_Y);
			// End:0x169
			if(m_SGIcon[idx].GetTextureName()!= "")
			{
				//Debug("//������ ����� ���� �ؽ�Ʈ �ʵ� ������ ����1111"@m_SGIcon[idx].GetTextureName());
				m_LeaderIcon[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ idx, "TopLeft", "TopLeft", 16 + 3, PARTY_NAME_POSTION_Y);
				m_PlayerName[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ idx, "TopLeft", "TopLeft", PARTY_NAME_POSTION_X + 16 + 19, PARTY_NAME_POSTION_Y);
			}
		}
		else
		{
			m_PlayerName[idx].SetWindowSizeRel(1.0f, 0, -28, 14);
			// End:0x259
			if(m_SGIcon[idx].GetTextureName() != "")
			{
				//Debug("//������ ����� ���� �ؽ�Ʈ �ʵ� ������ ����2222"@m_SGIcon[idx].GetTextureName());				
				m_PlayerName[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ idx, "TopLeft", "TopLeft", PARTY_NAME_POSTION_X + 16, PARTY_NAME_POSTION_Y);
				// ���� �Ҭ�֬�, �߬� �ެ� �Ӭ����Ѭ߬ѬӬݬڬӬѬ� "�� ���ڬԬڬ߬Ѭ�":)
				m_PlayerName[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ idx, "TopLeft", "TopLeft", PARTY_NAME_POSTION_X + 16, PARTY_NAME_POSTION_Y);
			}
			else
			{
				
				m_PlayerName[idx].SetAnchor(m_WindowName $ "." $ "PartyStatusWnd" $ idx, "TopLeft", "TopLeft", PARTY_NAME_POSTION_X, PARTY_NAME_POSTION_Y);
			}
		}
	}
}

function int GetIndexByIsMagic(StatusIconInfo Info)
{
	local SkillInfo SkillInfo;

	// End:0x39
	if(! GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, SkillInfo))
	{
		return -1;
	}
	return SkillInfo.IsMagic;
}

function bool isCompact()
{
	// End:0x1D
	if(m_WindowName == "PartyWndCompact")
	{
		return true;
	}
	return false;
}

defaultproperties
{
     DEFAULT_NPARTYSTATUS_HEIGHT=59
     DEFAULT_NPARTYPETSTATUS_HEIGHT=16
     DEFAULT_BUFFICON_SIZE=16
     DEFAULT_BUFFICON_SIZE_FORSUMMON=10
     DEFAULT_STATUS_GAP=-3
     m_WindowName="PartyWnd"
     MAX_BUFF_ICONTYPE=4
}
