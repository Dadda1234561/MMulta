/**
 *   디 아레나, 전용 숏컷 , 2015-09-04 부터, 
 *   
 *   기존 숏컷에서 기능 삭제 위주로 정리 하여 만든 버전.
 *   
 **/
class ShortcutWndArena extends UICommonAPI;

const MAX_Page = 2;
// 원본
const MAX_ShortcutPerPage = 12;
// 바꿀거 1
//const MAX_ShortcutPerPage1 = 11;
// 바꿀거 2
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

// 변신체 스킬 라인
const SKILLLINE_DRAGON      = 10;
const SKILLLINE_DRAGONSLAYER= 11;

// 0번 줄의 현재 단축키 리스트 숏컷라인은 1번이다.
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
	// 아레나 에서만 처리
	if(!getInstanceUIData().getIsArenaServer())return;

	//Debug("Shortcut OnEvent" @ a_EventID);

	switch(a_EventID)
	{
		case EV_ShortcutCommandSlot:
			ExecuteShortcutCommandBySlot(a_Param);
			break;
			//첫번째숏컷창의 페이지가 새로 설정되었을 때 날라오는 이벤트
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
			// 클리어 한 뒤 다시 세팅 해줘야 드래그 인 기능이 작동 함.
			handleSetShortcutID();
//			Debug("EV_ShortcutClear" @ currentPage0);
			break;

		case EV_ShortcutkeyassignChanged:		
			//Debug("EV_ShortcutkeyassignChanged");
		case EV_SetEnterChatting:
			//Debug("EV_SetEnterChatting");
		case EV_UnSetEnterChatting:
			ClearAllShortcutItemTooltip();
			//Debug("EV_ShortcutkeyassignChanged 기타 등등" @ currentPage0);
			class'ShortcutWndAPI'.static.SetShortcutPage(0);
			class'ShortcutWndAPI'.static.SetShortcutPage(currentPage0);			
			break;	
			// 변신 시 변신 ID로 보여줘야 할 숏컷을 바꾸기 위함.
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
* 변신체 스킬 
*************************************************************************************************************/
function handleTransform()
{
	local UserInfo	info;
	if(GetPlayerInfo(info))
	{
		//Debug("GetPlayerInfo" @ transFormed @ info.nTransformID @ info.nTransformID == TRANSFORMID_DRAGON);
		if(currentPage0 != 1)
		{
			// 0번 줄로 
			if(info.nTransformID == 0)
			{				
				SetCurPage0(1);				
			}
		}
		// 변신 상태가 아니거나, 변신ID가 0이 아닌 경우
		else 
		{
			// 변신 상태의 스킬 ID로 
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

// 1 번줄 숏컷 페이지 바꾸기(아랫 줄)
function SetCurPage0(int newPage)
{
	currentPage0 = newPage;
	//HandleShortcutClear();
	//Debug("setCurPage " @ newPage);
	class'ShortcutWndAPI'.static.SetShortcutPage(0);
	class'ShortcutWndAPI'.static.SetShortcutPage(currentPage0);
}


/*************************************************************************************************************
* 스킬 업그레이드 관련 함수 
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

// 스킬 업그레이드 이벤트 
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
* 스킬 붙이기
*************************************************************************************************************/

// 스킬 업그레이드 활성화 및 붙이기
function setAnchorShortcut(string shortcutName)
{
	SlotEffect_Ani.Play();
	PlusEffect_Ani.SetLoopCount(999);
	PlusEffect_Ani.Play();
	
	SlotEffect_Ani.SetAnchor(shortcutName, "CenterCenter", "CenterCenter", 0, 0);
	PlusEffect_Ani.SetAnchor(shortcutName, "CenterCenter", "CenterCenter", 0, 0);
}


// nShortcutID로 스킬 이름 가져 오기 
function String handleGetShortcutName(int nShortcutID)
{
	local string shortcutName ;
	local int shortcutPage, nShortcutNum;

	nShortcutNum =(nShortcutID % MAX_ShortcutPerPage)+ 1;	
	shortcutPage = nShortcutID / MAX_ShortcutPerPage ;
	// 변신체인 경우 숏컷 라인을 1로
	if(shortcutPage == currentPage0)shortcutPage = 1;
	
	if(shortcutPage < 0 || shortcutPage >= MAX_Page)return "";

	shortcutName = makeShortcutPathName(shortcutPage)$ nShortcutNum;	

//	Debug("handleGetShortcutName" @  shortcutName @ nShortcutID);
	return shortcutName ;
	//return GetTextBoxHandle(shortcutName);
}

// 숏컷 까지의 패스 네임 받기
function String makeShortcutPathName(int shortcutLine)
{
	return "ShortcutWndArena.ShortcutWndHorizontalArena_"$shortcutLine$".Shortcut";
}



/*************************************************************************************************************
* 스킬 배열 관리 함수  
*************************************************************************************************************/
function int getSkillShortcutHandleType(int idx, EShortCutItemType ShortcutType)
{
	local bool isSkillID;
	isSkillID = EShortCutItemType.SCIT_SKILL == ShortcutType;	
	// 추가 : 스킬인데 인덱스가 없는 경우 추가
	if(isSkillID &&(idx == -1))return SKILLID_ADD;
	// 갱신 : 스킬인 경우
	if(isSkillID)return SKILLID_UPDATE;
	// 삭제 : 스킬 아닌데 인덱스 남아 있는 경우 
	if((idx != -1))return SKILLID_REMOVE;
	return SKILLID_NONE;	
}

// 스킬 업데이트 시 배열 관리, 업그렝드 이팩트 변경
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


// 스킬 배열 중 classID로 index 검색
function int getSkillShortcutIdxByClassID(int classID)
{
	local int i ;
	for(i = 0 ; i < skillClassIDs.Length ; i ++)
	{
		if(skillClassIDs[i] == classID)return i;
	}
	return -1;
}


// 스킬 배열 중 shortcutID 를 키 값으로 index 검색
function int getSkillArrIndexByShortcutID(int ShortcutID)
{
	local int i ;
	for(i = 0 ; i < skillShortIDs.Length ; i ++)
	{
		if(skillShortIDs[i] == ShortcutID )return i;
	}
	return -1;
}

/// 스킬 배열 관리 3종 함수 
function skillIDRemove(int idx)
{
	local bool isUpgradeSkill, isMineSkill;

	isUpgradeSkill = skillClassIDs[idx] == currentUpgraeSkillID;
	isMineSkill = upgradeSkillShortcutName == handleGetShortcutName(skillShortIDs[idx]);
	isMineSkill = isMineSkill && upgradeSkillShortcutName != "" ;

	skillClassIDs.Remove(idx, 1);
	skillShortIDs.Remove(idx, 1);

	// 배열에서 업그레이드 스킬 삭제 시 같은 스킬이 하나 더 있다면 거기로 옮김
	if(isUpgradeSkill)
	{
		idx = getSkillShortcutIdxByClassID(currentUpgraeSkillID);
		// 업그레이드할 스킬이 없다면 숨김 
		if(idx == -1)skillUpgradeHide();
		// idx 위에 스킬 업그레이드가 있다면 다른 곳으로 옮긴다. 
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
* 업데이트
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
		// 변신체 인 경우 11 번 페이지 숏컷 데이터를 요청 한다 0, 1 보다 크다면 변신체 숏컷 일 것
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
	//debug("현재 슬롯넘버" @ slot);	
	// 창이 보여질 때만 수행하도록 처리.
	if(Me.isShowwindow())		
	{		
		// 변신 상태를 고려 
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
