/**
 *   �� �Ʒ���, ���� ���� , 2015-09-04 ����, 
 *   
 *   ���� ���ƿ��� ��� ���� ���ַ� ���� �Ͽ� ���� ����.
 *   
 **/
class ShortcutWndArena extends UICommonAPI;

const MAX_Page = 2;
// ����
const MAX_ShortcutPerPage = 12;
// �ٲܰ� 1
//const MAX_ShortcutPerPage1 = 11;
// �ٲܰ� 2
//const MAX_ShortcutPerPage2 = 6;

var WindowHandle Me;

var AnimTextureHandle SlotEffect_Ani;
var AnimTextureHandle PlusEffect_Ani;

var array<int> skillShortIDs;
var array<int> skillClassIDs;

var int currentUpgraeSkillID ;
var string upgradeSkillShortcutName ;

var bool preIsLockFlag ;

const SKILLID_NONE      = 0;
const SKILLID_ADD       = 1;
const SKILLID_UPDATE    = 2;
const SKILLID_REMOVE    = 3;

// ����ü ��ų ����
const SKILLLINE_DRAGON      = 10;
const SKILLLINE_DRAGONSLAYER= 11;

// 0�� ���� ���� ����Ű ����Ʈ ���ƶ����� 1���̴�.
var int currentPage0  ;

function OnRegisterEvent()
{
	RegisterEvent(EV_ShortcutUpdate);
	RegisterEvent(EV_ShortcutPageUpdate);

	RegisterEvent(EV_ShortcutClear);
	RegisterEvent(EV_ShortcutCommandSlot);

	RegisterEvent(EV_ShortcutkeyassignChanged);
	
	RegisterEvent(EV_SetEnterChatting);
	RegisterEvent(EV_UnSetEnterChatting);

	RegisterEvent(EV_UpdateUserInfo);

	//RegisterEvent(EV_StateChanged);
}


function onShow()
{
	currentPage0 = 1;
	handleTransform();

	preIsLockFlag = GetOptionBool("Game", "IsLockShortcutWnd");
	SetOptionBool("Game", "IsLockShortcutWnd", true);	
}

function onHide()
{	
	SetOptionBool("Game", "IsLockShortcutWnd", preIsLockFlag);	
}

function OnLoad()
{
	local Tooltip Script;

	if(!getInstanceUIData().getIsArenaServer())return;

	Script = Tooltip(GetScript("Tooltip"));
	Script.setBoolSelect(true);

	Me = GetWindowHandle("ShortcutWndArena");

	SlotEffect_Ani = GetAnimTextureHandle("ShortcutWndArena.SlotEffect_Ani");
	PlusEffect_Ani = GetAnimTextureHandle("ShortcutWndArena.PlusEffect_Ani");

	handleNotUseShortcut();
}


function OnEvent(int a_EventID, String a_Param)
{	
	// �Ʒ��� ������ ó��
	if(!getInstanceUIData().getIsArenaServer())return;

	//Debug("Shortcut OnEvent" @ a_EventID);

	switch(a_EventID)
	{
		case EV_ShortcutCommandSlot:
			ExecuteShortcutCommandBySlot(a_Param);
			break;
			//ù��°����â�� �������� ���� �����Ǿ��� �� ������� �̺�Ʈ
		case EV_ShortcutPageUpdate:			
//			Debug("EV_ShortcutPageUpdate");
			HandleShortcutPageUpdate(a_Param);
			break;
		case EV_ShortcutUpdate:
//			Debug("EV_ShortcutUpdate");
			HandleShortcutUpdate(a_Param);			
			break;
		case EV_ShortcutClear:
			HandleShortcutClear();
			// Ŭ���� �� �� �ٽ� ���� ����� �巡�� �� ����� �۵� ��.
			handleSetShortcutID();
//			Debug("EV_ShortcutClear" @ currentPage0);
			break;

		case EV_ShortcutkeyassignChanged:		
			//Debug("EV_ShortcutkeyassignChanged");
		case EV_SetEnterChatting:
			//Debug("EV_SetEnterChatting");
		case EV_UnSetEnterChatting:
			ClearAllShortcutItemTooltip();
			//Debug("EV_ShortcutkeyassignChanged ��Ÿ ���" @ currentPage0);
			class'ShortcutWndAPI'.static.SetShortcutPage(0);
			class'ShortcutWndAPI'.static.SetShortcutPage(currentPage0);			
			break;	
			// ���� �� ���� ID�� ������� �� ������ �ٲٱ� ����.
		case EV_UpdateUserInfo:		
			handleTransform();			
			break;
		//case EV_StateChanged:
		//	if(a_Param == "ARENAGAMINGSTATE")handleSetShortcutID();
		//	break;
	}
}

function handleSetShortcutID()
{	
	local int i;

	//Debug(" init handleSetShortcutID");

	for(i=0 ; i < MAX_ShortcutPerPage ; ++i)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWndArena.ShortcutWndHorizontalArena_0.Shortcut" $(i+1), i);
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWndArena.ShortcutWndHorizontalArena_1.Shortcut" $(i+1), i + MAX_ShortcutPerPage);		
	}
}

function onCallUCFunction(string id, string param)
{		
	handleSkillUpgrade(int(param));
}

/*************************************************************************************************************
* ����ü ��ų 
*************************************************************************************************************/
function handleTransform()
{
	local UserInfo	info;
	if(GetPlayerInfo(info))
	{
		//Debug("GetPlayerInfo" @ transFormed @ info.nTransformID @ info.nTransformID == TRANSFORMID_DRAGON);
		if(currentPage0 != 1)
		{
			// 0�� �ٷ� 
			if(info.nTransformID == 0)
			{				
				SetCurPage0(1);				
			}
		}
		// ���� ���°� �ƴϰų�, ����ID�� 0�� �ƴ� ���
		else 
		{
			// ���� ������ ��ų ID�� 
			switch(info.nTransformID)
			{
				case getInstanceUIData().TRANSFORMID_DRAGONSLAYER :					
					SetCurPage0(SKILLLINE_DRAGONSLAYER);
				break;
					case getInstanceUIData().TRANSFORMID_DRAGON:					
					SetCurPage0(SKILLLINE_DRAGON);
				break;
			}
		}
	}
}

// 1 ���� ���� ������ �ٲٱ�(�Ʒ� ��)
function SetCurPage0(int newPage)
{
	currentPage0 = newPage;
	//HandleShortcutClear();
	//Debug("setCurPage " @ newPage);
	class'ShortcutWndAPI'.static.SetShortcutPage(0);
	class'ShortcutWndAPI'.static.SetShortcutPage(currentPage0);
}


/*************************************************************************************************************
* ��ų ���׷��̵� ���� �Լ� 
*************************************************************************************************************/
function skillUpgradeHide()
{	
	SlotEffect_Ani.HideWindow();
	PlusEffect_Ani.HideWindow();
}

function skillUpgradeShow(string shortcutName)
{
	upgradeSkillShortcutName = shortcutName;
	// End:0x19
	if(shortcutName == "")
	{
		return;
	}
	SlotEffect_Ani.ShowWindow();
	PlusEffect_Ani.ShowWindow();	
	
	setAnchorShortcut(shortcutName);	
	
}

// ��ų ���׷��̵� �̺�Ʈ 
function handleSkillUpgrade(int classID)
{
	local int idx ;

	currentUpgraeSkillID = classID;	

	idx = getSkillShortcutIdxByClassID(currentUpgraeSkillID);

//	Debug("handleSkillUpgrade" @ idx @ currentUpgraeSkillID  @ handleGetShortcutName(skillShortIDs[idx]));

	if(currentUpgraeSkillID == -1 || idx == -1 )
		skillUpgradeHide();
	else 
		skillUpgradeShow(handleGetShortcutName(skillShortIDs[idx]));
}

/*************************************************************************************************************
* ��ų ���̱�
*************************************************************************************************************/

// ��ų ���׷��̵� Ȱ��ȭ �� ���̱�
function setAnchorShortcut(string shortcutName)
{
	SlotEffect_Ani.Play();
	PlusEffect_Ani.SetLoopCount(999);
	PlusEffect_Ani.Play();
	
	SlotEffect_Ani.SetAnchor(shortcutName, "CenterCenter", "CenterCenter", 0, 0);
	PlusEffect_Ani.SetAnchor(shortcutName, "CenterCenter", "CenterCenter", 0, 0);
}


// nShortcutID�� ��ų �̸� ���� ���� 
function String handleGetShortcutName(int nShortcutID)
{
	local string shortcutName ;
	local int shortcutPage, nShortcutNum;

	nShortcutNum =(nShortcutID % MAX_ShortcutPerPage)+ 1;	
	shortcutPage = nShortcutID / MAX_ShortcutPerPage ;
	// ����ü�� ��� ���� ������ 1��
	if(shortcutPage == currentPage0)shortcutPage = 1;
	
	if(shortcutPage < 0 || shortcutPage >= MAX_Page)return "";

	shortcutName = makeShortcutPathName(shortcutPage)$ nShortcutNum;	

//	Debug("handleGetShortcutName" @  shortcutName @ nShortcutID);
	return shortcutName ;
	//return GetTextBoxHandle(shortcutName);
}

// ���� ������ �н� ���� �ޱ�
function String makeShortcutPathName(int shortcutLine)
{
	return "ShortcutWndArena.ShortcutWndHorizontalArena_"$shortcutLine$".Shortcut";
}



/*************************************************************************************************************
* ��ų �迭 ���� �Լ�  
*************************************************************************************************************/
function int getSkillShortcutHandleType(int idx, EShortCutItemType ShortcutType)
{
	local bool isSkillID;
	isSkillID = EShortCutItemType.SCIT_SKILL == ShortcutType;	
	// �߰� : ��ų�ε� �ε����� ���� ��� �߰�
	if(isSkillID &&(idx == -1))return SKILLID_ADD;
	// ���� : ��ų�� ���
	if(isSkillID)return SKILLID_UPDATE;
	// ���� : ��ų �ƴѵ� �ε��� ���� �ִ� ��� 
	if((idx != -1))return SKILLID_REMOVE;
	return SKILLID_NONE;	
}

// ��ų ������Ʈ �� �迭 ����, ���׷��� ����Ʈ ����
function setSkillID(String param, int nShortcutID, String shortcutName)
{
	local int ClassID, idx, ShortcutType, type ;
	local bool isUpgradeSkill ;	

	parseInt(param, "ShortcutType", ShortcutType);
	
	idx =  getSkillArrIndexByShortcutID(nShortcutID);

	type = getSkillShortcutHandleType(idx, EShortCutItemType(ShortcutType));	

	parseInt(param, "ClassID", ClassID); 

	isUpgradeSkill = currentUpgraeSkillID == ClassID  ;

	//Debug("setSkillID" @ type @ idx @ nShortcutID @ ClassID @ currentUpgraeSkillID @ isUpgradeSkill);

	switch(type)
	{
		case SKILLID_ADD :			
			skillIDAdd(nShortcutID,ClassID);			
			if(isUpgradeSkill)skillUpgradeShow(shortcutName);
		break;
		case SKILLID_UPDATE :			
			skillIDUpdate(nShortcutID, ClassID, idx);
			if(isUpgradeSkill)skillUpgradeShow(shortcutName);
		break;
		case SKILLID_REMOVE:			
			skillIDRemove(idx);
		break;
	}
}


// ��ų �迭 �� classID�� index �˻�
function int getSkillShortcutIdxByClassID(int classID)
{
	local int i ;
	for(i = 0 ; i < skillClassIDs.Length ; i ++)
	{
		if(skillClassIDs[i] == classID)return i;
	}
	return -1;
}


// ��ų �迭 �� shortcutID �� Ű ������ index �˻�
function int getSkillArrIndexByShortcutID(int ShortcutID)
{
	local int i ;
	for(i = 0 ; i < skillShortIDs.Length ; i ++)
	{
		if(skillShortIDs[i] == ShortcutID )return i;
	}
	return -1;
}

/// ��ų �迭 ���� 3�� �Լ� 
function skillIDRemove(int idx)
{
	local bool isUpgradeSkill, isMineSkill;

	isUpgradeSkill = skillClassIDs[idx] == currentUpgraeSkillID;
	isMineSkill = upgradeSkillShortcutName == handleGetShortcutName(skillShortIDs[idx]);
	isMineSkill = isMineSkill && upgradeSkillShortcutName != "" ;

	skillClassIDs.Remove(idx, 1);
	skillShortIDs.Remove(idx, 1);

	// �迭���� ���׷��̵� ��ų ���� �� ���� ��ų�� �ϳ� �� �ִٸ� �ű�� �ű�
	if(isUpgradeSkill)
	{
		idx = getSkillShortcutIdxByClassID(currentUpgraeSkillID);
		// ���׷��̵��� ��ų�� ���ٸ� ���� 
		if(idx == -1)skillUpgradeHide();
		// idx ���� ��ų ���׷��̵尡 �ִٸ� �ٸ� ������ �ű��. 
		else if(isMineSkill)skillUpgradeShow(handleGetShortcutName(skillShortIDs[idx]));
	}
	//Debug("skillIDRremove2" @ idx  @ skillClassIDs[idx] @ skillShortIDs[ idx ] @ skillClassIDs.Length);
}

function skillIDUpdate(int ShortcutID, int ClassID, int idx )
{
	skillShortIDs[idx] = ShortcutID;
	skillClassIDs[idx] = ClassID;
}

function skillIDAdd(int ShortcutID, int ClassID)
{
	local int idx;
	idx = skillClassIDs.Length;
	skillShortIDs.Length = idx + 1;
	skillClassIDs.Length = skillShortIDs.Length;
	skillShortIDs[ idx ] = ShortcutID;
	//Debug("skillIDAdd" @ skillShortIDs[ idx ] @ idx @ ShortcutID);
	skillClassIDs[ idx ] = ClassID;
}


/*************************************************************************************************************
* ������Ʈ
*************************************************************************************************************/

function ClearAllShortcutItemTooltip()
{
	Me.ClearAllChildShortcutItemTooltip();
}

function HandleShortcutPageUpdate(string param)
{
	local int i;
	local int nstartShortcutID;
	local int ShortcutPage;
	local string shortcutPath ;

	if(ParseInt(param, "ShortcutPage", ShortcutPage))
	{
//		Debug("HandleShortcutPageUpdate" @ ShortcutPage @ makeShortcutPathName(ShortcutPage));		
		// ����ü �� ��� 11 �� ������ ���� �����͸� ��û �Ѵ� 0, 1 ���� ũ�ٸ� ����ü ���� �� ��
		if(currentPage0 == ShortcutPage)shortcutPath = makeShortcutPathName(1);
		else if(ShortcutPage >= MAX_Page ||  0 > ShortcutPage)return ;
		else shortcutPath = makeShortcutPathName(ShortcutPage);

		nstartShortcutID = ShortcutPage * MAX_ShortcutPerPage;

		for(i = 0; i < MAX_ShortcutPerPage ; ++i)
			class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(shortcutPath $(i + 1), nstartShortcutID + i);
	}
}


function HandleShortcutUpdate(string param)
{
	local int nShortcutID ;
	//local Rect rectWnd;
	local string shortcutName;
	
	ParseInt(param, "ShortcutID", nShortcutID);

	if(nShortcutID < 0)return;

	shortcutName = handleGetShortcutName(nShortcutID);

//	Debug("HandleShortcutUpdate" @ nShortcutID @ shortcutName);
	setSkillID(param, nShortcutID, shortcutName);	

	if(shortcutName != "")class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(shortcutName, nShortcutID);
}

function HandleShortcutClear()
{
	local int i;	

	skillClassIDs.Length = 0;
	skillShortIDs.Length = 0;
	currentUpgraeSkillID = -1;
	skillUpgradeHide();
	
	//Debug("clear shortcut Arena ");
	for(i=0 ; i < MAX_ShortcutPerPage ; ++i)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWndArena.ShortcutWndHorizontalArena_0.Shortcut" $(i+1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWndArena.ShortcutWndHorizontalArena_1.Shortcut" $(i+1));		
	}
}

function ExecuteShortcutCommandBySlot(string param)
{
	local int slot;	
	ParseInt(param, "Slot", slot);
	//debug("���� ���Գѹ�" @ slot);	
	// â�� ������ ���� �����ϵ��� ó��.
	if(Me.isShowwindow())		
	{		
		// ���� ���¸� ��� 
		if(slot >= MAX_ShortcutPerPage )
		{
			slot =(currentPage0 - 1)* MAX_ShortcutPerPage + slot ;
			//slot =(currentPage0)* MAX_ShortcutPerPage + slot % MAX_ShortcutPerPage ;
		}
		else if(slot < 0)return;

		class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(slot);
	}
}

function handleNotUseShortcut()
{
	local string shortcutPath;

	shortcutPath = makeShortcutPathName(0);
	GetWindowHandle(shortcutPath $ "1").HideWindow();
	GetWindowHandle(shortcutPath $ "2").HideWindow();
	GetWindowHandle(shortcutPath $ "3").HideWindow();

	GetWindowHandle(shortcutPath $ "9").HideWindow();
	GetWindowHandle(shortcutPath $ "10").HideWindow();
	GetWindowHandle(shortcutPath $ "12").HideWindow();

	GetWindowHandle(makeShortcutPathName(1)$ "12").HideWindow();
}

defaultproperties
{
}
