//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : CharacterCreateMenuWndWnd  - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class CharacterCreateMenuWnd extends L2UIGFxScript;

const DLG_ID_CREATE = 3300;

const MAX_GENDER = 2;

// default character
/* 기본 적인 종족 갯수 공식 드워프, 카마엘 예외 처리 
 * race*(job_max * gender_max)+ job*gender_max + gender ; 
 */
//const MAX_CHARACTER = 24;

enum BASIC_JOBINDEX
{
	WARRIOR,
	MAGE,
	EXTRAJOB,
	ASSASIN
};

var L2Util util;

var bool m_bZoomed;

var int Race;
var int Job;
var int gender;
var int HairType;
var int HairColor;
var int FaceType;
var string Name;
var bool IsCreate; // 이름 중복 이벤트를 받은 뒤 생성인지, 확인인지 구분 할 때 씀.
var CharacterCreateEditbox characterCreateEditboxScript;
var int characterID;

/*************************************************************************************************************
 * 데이타
 * ***********************************************************************************************************/
//머리 스타일 남자 5, 여자 7 이고 카마엘, 아르테이아 머리 색상이 3인거 빼고는 나머지는 같다.
function int GetFaceTypeMaxNum()
{
	if(IsDeathKnight(Race, Job))
	{
		return 1;
	}
	if(IsAssassin(Job))
	{
		return 1;
	}
	if(IsAdenServer() && IsHumanMage(Race, Job))
	{
		return 5;
	}
	return 3;
}

function int getHairColorMaxNum()
{
	if(IsDeathKnight(Race, Job))
	{
		if(getInstanceUIData().getIsLiveServer())
		{
			return 3;
		}
		else
		{
			return 1;
		}
	}
	if(IsAssassin(Job))
	{
		return 1;
	}
	switch(GetRaceString(Race))
	{
		case "KAMAEL":
		case "ERTHEIA":
		case "SYLPH":
			return 3;

		default:
			return 4;
	}
}

function int getHairTypeMaxNum()
{
	if(IsDeathKnight(Race, Job))
	{
		return 1;
	}
	if(IsAdenServer() && IsHumanMage(Race, Job))
	{
		if(gender == 0)
		{
			return 9;
		}
		else
		{
			return 12;
		}
	}
	if(IsAssassin(Job))
	{
		return 1;
	}
	if(gender == 1 || GetRaceString(Race) == "ERTHEIA")
	{
		return 7;
	}
	return 5;
}

function ResetStyle()
{
	HairType = 0;
	HairColor = 0;
	FaceType = 0;
	if(GetRaceString(Race) == "KAMAEL" && getInstanceUIData().getIsClassicServer())
	{
		FaceType = 1;
	}
	HandleSetCharacterStyle();
}

/*************************************************************************************************************
 * On ~ 
 * ***********************************************************************************************************/
event OnRegisterEvent()
{
	RegisterEvent(EV_CharacterCreateSetClassDesc);
	RegisterEvent(EV_CharacterNameCreatable);
	RegisterEvent(EV_StateChanged);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
	RegisterEvent(EV_MessageWndString);
}

event OnLoad()
{
	SetContainerHUD(WINDOWTYPE_NONE, 0);
	AddState("CHARACTERCREATESTATE");
	SetAlwaysOnTop(true);
	HasTextField(true);
	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0);
	util = L2Util(GetScript("L2Util"));
	characterCreateEditboxScript = CharacterCreateEditbox(GetScript("CharacterCreateEditbox"));
}

event OnHide()
{
	UnsetRotateCursor();
	CallGFxFunction("CharacterCreateMenuWnd", "EXIT", "0");
}

event OnEvent(int Event_ID, string param)
{
	if(Event_ID == EV_StateChanged)
	{
		if(param == "CHARACTERCREATESTATE")
		{
			// fade 처리를 위해 캐릭터 생성 스테이트에 들어왔을 때 race를 초기화 시켜 줌.
			race = -1;
			CallGFxFunction("CharacterCreateMenuWnd", "ENTER", "0");
		}
		else CallGFxFunction("CharacterCreateMenuWnd", "EXIT", "0");
	}
	else if(Event_ID == EV_CharacterNameCreatable)
	{ //5618
		//이 이벤트는 GMPCManagerWnd 에서도 사용 하므로 스테이트 검사 필요
		if(GetGameStateName() == "CHARACTERCREATESTATE")
			HandlecharacterNameCreatable(param);
	}
	else if(Event_ID == EV_DialogOK)
	{
		HandleDialogResult(true);
	}
	else if(Event_ID == EV_DialogCancel)
	{
		HandleDialogResult(false);
	}
	else if(Event_ID == EV_MessageWndString)
	{
		HandleShowMessage(param);
	}
	// 3210 설명을 param 으로 받음
	/*
	else if(Event_ID == EV_CharacterCreateSetClassDesc)
	{ 
		//race = -1;
		//!!!!!!!!!!!!!!!!  아리트이아 종족이 우선 선택 되어 있도록 수정 2013.11.04  아중에 삭제 할 것
		//if(getInstanceUIData().getIsClassicServer())
		//{
		//	tmpRace = Rand(MAX_RACE - 2);
		//}
		//else
		//{
		//	tmpRace = Rand(MAX_RACE);
		//}
		//job = Rand(getMaxJob(tmpRace));
		//gender = Rand(MAX_GENDER);
		//setStep1Handle(tmpRace, job, gender);
	/*}else if(Event_ID == EV_MessageWndString){ //581
		parseString(param, "Message", msg);	
		handleShowMessage(msg);*/
	//} else if(Event_ID == EV_CharacterCreateEnableRotate){ //3260 로테이션 풀때// 필요 없음.
		//HandleEnableRotate(a_param);
		//ShowOnlyOneDefaultCharacter(5);
	//} else if(Event_ID == EV_CharacterCreateClearSetupWnd){ // 주어진 설정 지우기.
	} */
}

event OnCallUCFunction(string logicID, string param)
{
	local string btnName;
	local string targetName;

	ParseString(param, "btnName", btnName);

	if(isChinaVer())
	{
		GetWindowHandle("CharacterCreateEditbox").ClearAnchor();
		GetWindowHandle("CharacterCreateEditbox").SetAnchor("", "BottomCenter", "TopLeft", -125, -73);
		characterCreateEditboxScript.setFocusTarget();
	}
	switch(btnName)
	{
		case "exit":
			if(IsShowWindow("CharacterCreateMenuWnd"))
			{
				RequestPrevState();
			}
			break;
		case "confirm":
			IsCreate = false;
			ParseString(param, "Name", Name);
			if(isChinaVer())
			{
				Name = characterCreateEditboxScript.getCharacterNameTextFieldValue();
			}
			handleNameConfirm();
			break;
		case "left":
			handleTurnLeft(int(logicID));
			break;
		case "right":
			handleTurnRight(int(logicID));
			break;
		case "zoom":
			//debug("logicID:>" @ logicID);
			if(logicID == "1")
			{
				zoomIn();
			}
			else
			{
				zoomOut();
			}
			//if(!m_bZoomed)zoomIn(); else  zoomOut();
			break;
		case "race":
			SetCharacterChange(int(logicID), job, gender);
			break;
		case "gender":
			SetCharacterChange(race, job, int(logicID));
			break;
		case "job":
			SetCharacterChange(race, int(logicID), gender);
			break;
		case "faceType":
			FaceType = int(logicID);
			HandleSetCharacterStyle();
			break;
		case "hairType":
			HairType = int(logicID);
			HandleSetCharacterStyle();
			break;
		case "hairColor":
			HairColor = int(logicID);
			HandleSetCharacterStyle();
			break;
		case "create":
			IsCreate = true;
			ParseString(param, "Name", Name);
			if(isChinaVer())
			{
				Name = characterCreateEditboxScript.getCharacterNameTextFieldValue();
			}
			handleNameConfirm();
			//RequestCharacterNameCreatable(Name); //사용중인 이름인지 확인 	 EV_CharacterNameCreatable{ //5618 발생 -> HandlecharacterNameCreatable 실행 - > 111107 대석시 요청으로 handleNameConfirm 사용 
			break;
		case "class":
			ParseString(param, "targetName", targetName);
			classDescription(int(logicID), targetName);
			break;
		case "dragPoint":
			handleDragCharacter(float(logicID), param);
			break;
		case "ID":
			characterID = int(logicID);
			break;
		case "setRandom":
			setRandom(logicID);
			break;
		case "xmlEditBoxFocus":
			characterCreateEditboxScript.setFocusTarget();
			break;
	}
}

/***********************************************************************************************************
 * 케릭터 변경
 * *********************************************************************************************************/
// 입장 시 랜덤 값 설정
function setRandom(string param)
{
	local int nextRace, nextGender, nextJob;

	ParseInt(param, "randRace", nextRace);
	ParseInt(param, "randGender", nextGender);
	ParseInt(param, "randJob", nextJob);
	SetCharacterChange(nextRace, nextJob, nextGender);
}

function SetCharacterChange(int nextRace, int nextJob, int nextGender)
{
	if(IsAdenServer())
	{
		if(Race != nextRace)
		{
			if(GetRaceString(nextRace) == "HUMAN")
			{
				nextGender = 0;
				nextJob = 3;
			}
			else if(GetRaceString(nextRace) == "DARKELF")
			{
				nextGender = 1;
				nextJob = 3;
			}
		}
	}
	nextJob = GetCanSelectJob(nextRace, nextGender, nextJob);
	SetSceneChange(nextRace, nextJob, nextGender);
	SetGFxUIStep1();
	SetGFxUIStep2();
}

function SetSceneChange(int nextRace, int nextJob, int nextGender)
{
	local bool bSceneChange;

	bSceneChange = IsSceneChange(nextRace, nextJob);
	Debug("SetSceneChange" @ string(bSceneChange) @ string(nextJob) @ string(Job) @ string(characterID));
	ShowDefaultCharacter(characterID, bSceneChange);
	if(bSceneChange)
	{
		m_bZoomed = false;
		FadeInOut(nextRace, nextJob);
	}
	Race = nextRace;
	Job = nextJob;
	gender = nextGender;
}

function string SetGFxUIStep1()
{
	local string Result;
	local array<int> initialStat;       //초기 스탯 

	if(GetRaceString(Race) == "KAMAEL")//카마엘 일 경우 옵션은 젠더 임
		initialStat = GetClassInitialStat(util.GetInitClassID(Race, gender));
	else
		initialStat = GetClassInitialStat(util.GetInitClassID(Race, Job));

	ParamAdd(Result, "STR", string(initialStat[0]));
	ParamAdd(Result, "DEX", string(initialStat[1]));
	ParamAdd(Result, "CON", string(initialStat[2]));
	ParamAdd(Result, "INT", string(initialStat[3]));
	ParamAdd(Result, "WIT", string(initialStat[4]));
	ParamAdd(Result, "MEN", string(initialStat[5]));
	ParamAdd(Result, "LUC", string(initialStat[6]));
	ParamAdd(Result, "CHA", string(initialStat[7]));
	ParamAdd(Result, "race", string(Race));
	ParamAdd(Result, "gender", string(gender));
	ParamAdd(Result, "job", string(Job));
	ParamAdd(Result, "max_faceType", string(GetFaceTypeMaxNum()));
	ParamAdd(Result, "max_hairType", string(getHairTypeMaxNum()));
	ParamAdd(Result, "max_hairColor", string(getHairColorMaxNum()));
	CallGFxFunction("CharacterCreateMenuWnd", "STEP_CHANGED_1", Result);
	return Result;
}

function SetGFxUIStep2()
{
	local string Result;

	Result = "";
	ResetStyle();
	ParamAdd(Result, "faceType", string(FaceType));
	ParamAdd(Result, "hairType", string(HairType));
	ParamAdd(Result, "hairColor", string(HairColor));
	CallGFxFunction("CharacterCreateMenuWnd", "STEP_CHANGED_2", Result);
}

function HandleSetCharacterStyle()
{
	if(IsDeathKnight(Race, Job) && getInstanceUIData().getIsLiveServer())
	{
		SetCharacterColor(E_CHARACTER_COLOR(GetHairColor() + 1));
	}
	else
	{
		SetCharacterStyle(characterID, HairType, GetHairColor(), FaceType);
	}
}

/***********************************************************************************************************
 * 케릭터 조작
 * *********************************************************************************************************/
// 종족 변경 시 페이드 인 아웃
function bool IsSceneChange(int nextRace, int nextJob)
{
	if(Race != nextRace)
	{
		return true;
	}
	if(nextJob == Job)
	{
		return false;
	}
	if(getInstanceUIData().getIsLiveServer())
	{
		return false;
	}
	if(IsDeathKnight(Race, Job) || IsDeathKnight(nextRace, nextJob))
	{
		return true;
	}
	if(!IsAdenServer())
	{
		return false;
	}
	if(IsOrcRider(Race, Job) || IsOrcRider(nextRace, nextJob))
	{
		return true;
	}
	if(IsAssassin(Job) || IsAssassin(nextJob))
	{
		return true;
	}
	return false;
}

function classDescription(int ClassID, string TargetName)
{
	local string Result;

	Result = "";
	ParamAdd(Result, "classID", string(ClassID));
	ParamAdd(Result, "classType", GetClassType(ClassID));
	ParamAdd(Result, "desc", GetClassDescription(ClassID));
	ParamAdd(Result, "targetName", TargetName);
	CallGFxFunction("CharacterCreateMenuWnd", "NAME_CHECK_RESULT", Result);
}

function string GetSceneName(int tmpRace, int tmpJob)
{
	if(tmpRace == -1)
	{
		return "";
	}
	if(IsOrcRider(tmpRace, tmpJob))
	{
		return "OrcRider_";
	}
	if(IsAssassin(tmpJob))
	{
		return "Assassin_";
	}
	if(!getInstanceUIData().getIsLiveServer() && IsDeathKnight(tmpRace, tmpJob))
	{
		return (GetRaceString(tmpRace)) $ "_DK_";
	}

	return GetRaceString(tmpRace) $ "_";
}

function FadeInOut(int nextRace, int nextJob)
{
	Debug("FadeInOut" @ string(nextRace) @ string(nextJob) @ (GetSceneName(nextRace, nextJob)) @ "/" @ (GetSceneName(Race, Job)));
	if(Race == -1)//첫 시작은 fadein만
	{
		ExecLobbyEvent(GetSceneName(nextRace, nextJob) $ "FadeIn");
	}
	else
	{
		ExecLobbyEvent(GetSceneName(Race, Job) $ "FadeOut");
		ExecLobbyNextEvent(GetSceneName(Race, Job) $ "FadeOut", GetSceneName(nextRace, nextJob) $ "FadeIn");
	}
}

function handleDragCharacter(float Speed, string param)
{
	local string Type;
	local int MaxSpeed;

	MaxSpeed = 10000;

	ParseString(param, "type", Type);

	if(Type == "rollOver" || Type == "press" || Type == "click")
	{
		SetRotateCursor();
	}
	else if(Type == "releaseOutside" || Type == "rollOut")
	{
		UnsetRotateCursor();
	}
	else if(Speed != 0)
	{
		Speed = Speed * 400;

		if(Speed > MaxSpeed)
		{
			Speed = MaxSpeed;
		}
		else
		{
			if(Speed < -MaxSpeed)
			{
				Speed = -MaxSpeed;
			}
		}
		DefaultCharacterMouseTurn(characterID, Speed);
	}
}

function handleTurnLeft(int logicID)
{
	if(logicID == 3)
	{
		DefaultCharacterTurn(characterID, 6.0f);
	}
	else
	{
		DefaultCharacterStop(characterID);
	}
}

function handleTurnRight(int logicID)
{
	if(logicID == 3)
	{
		DefaultCharacterTurn(characterID, -6.0f);
	}
	else
	{
		DefaultCharacterStop(characterID);
	}
}

function zoomIn()
{
	ExecLobbyEvent(GetSceneName(Race, Job) $ "ZoomIn");
	m_bZoomed = true;
}

function zoomOut()
{
	ExecLobbyEvent(GetSceneName(Race, Job) $ "ZoomOut");
	m_bZoomed = false;
}

function int GetCanSelectJob(int nextRace, int nextGender, int nextJob)
{
	if(nextJob == 2)
	{
		if(!CanSelectRaceDk(nextRace, nextGender) && !CanSelectRaceOrcRider(nextRace, nextGender))
		{
			return 0;
		}
	}
	else if(nextJob == 3)
	{
		if(!CanSelectJobAssassin(nextRace, nextGender))
		{
			return 0;
		}
	}
	return nextJob;
}

function bool CanSelectJobAssassin(int nextRace, int nextGender)
{
	if(!IsAdenServer())
	{
		return false;
	}
	switch(GetRaceString(nextRace))
	{
		case "HUMAN":
			return nextGender == 0;
		case "DARKELF":
			return nextGender == 1;

		default:
			return false;
	}
}

function bool CanSelectRaceDk(int tmpRace, int tmpGender)
{
	if(tmpGender != 0)
	{
		return false;
	}
	switch(GetRaceString(tmpRace))
	{
		case "HUMAN":
			return true;
		case "ELF":
		case "DARKELF":
			return getInstanceUIData().getIsClassicServer();

		default:
			return false;
	}
}

function bool CanSelectRaceOrcRider(int tmpRace, int tmpGender)
{
	if(tmpGender != 0)
	{
		return false;
	}
	if(!IsAdenServer())
	{
		return false;
	}
	if(GetRaceString(tmpRace) != "ORC")
	{
		return false;
	}
	return true;
}

private function int GetHairColor()
{
	if(IsHumanMageNewHairtype())
	{
		return 0;
	}
	return HairColor;
}

function bool IsHumanMageNewHairtype()
{
	if(!IsAdenServer() || !IsHumanMage(Race, Job))
	{
		return false;
	}
	if(gender == 0)
	{
		return HairType >= 5;
	}
	else
	{
		return HairType >= 7;
	}
	return false;
}

/***********************************************************************************************************
 * 케릭터 생성
 * *********************************************************************************************************/
function HandleCreateCharacter(bool bOK)
{
	local int ClassID;

	if(bOK)
	{
		ClassID = CharacterCreateGetClassType(Race, Job, gender);
		if(getInstanceUIData().getIsLiveServer() && IsDeathKnight(Race, Job))
		{
			RequestCreateCharacter(Name, Race, ClassID, gender, HairType, GetHairColor(), FaceType, E_CHARACTER_COLOR(GetHairColor() + 1));
		}
		else
		{
			RequestCreateCharacter(Name, Race, ClassID, gender, HairType, GetHairColor(), FaceType, ECC_NONE);
		}
	}
}

function HandlecharacterNameCreatable(string a_param)
{
	local int CreateFailType;
	local array<int> systemStringArr[8];

	ParseInt(a_param, "CreateFailType", CreateFailType);

	if(CreateFailType == -1){
		if(IsCreate){ //생성 버튼이라면 
			ShowCreateDialog(); /// 생성 다이얼로그 뜸.
		} else { //이름 체크 라면
			ShowMessage(GetSystemMessage(3539)); // 사용 가능한 이름입니다.
		}
	} else {
		systemStringArr[0] =  128; //캐릭터 생성에 실패했습니다.
		systemStringArr[1] =   77; //이제는 더 만들 수 없습니다. 이미 잇는 캐릭터를 지우고 다시 시도해 주십시오.
		systemStringArr[2] =   79; //이미 존재하는 이름입니다.
		systemStringArr[3] =   80; //한글 1자 이상 8자 이내, 영문 1자 이상 16자 이내로 정해주십시오.
		systemStringArr[4] =  204; //잘못된 이름입니다. 다시 입력해 주세요.
		systemStringArr[5] = 1882; //현재 이 서버에서는 캐릭터를 생성할 수 없습니다.
		systemStringArr[6] = 2037; //캐릭터를 생성할 수 없습니다. 해당 서버는 예전에 생성한........
		systemStringArr[7] = 6074; //영문을 섞을 수 없습니다......

		ShowMessage(GetSystemMessage(systemStringArr[CreateFailType])); // 이 이름들은 여러가지 이유로 사용 할 수 없습니다.
	}
}

function ShowCreateDialog()
{
	class'UICommonAPI'.static.DialogSetID(DLG_ID_CREATE);
	class'UICommonAPI'.static.DialogShow(DialogModalType_Modal, DialogType_OKCancel, GetSystemMessage(3533), string(self));
}

function handleNameConfirm()
{
	//Debug("handleNameConfirm nameConfirm" @ tmpName);
	//Debug(String(Len(tmpName))@ !CheckNameLength(tmpName)@ !CheckValidName(tmpName));

	if(Len(Name) == 0 || !CheckNameLength(Name))//글자수 체크
	{
		ShowMessage(GetSystemMessage(80));
		return;
	}
	else if(!CheckValidName(Name))//NPC 이름과 중복 되는 것을 확인함.
	{
		ShowMessage(GetSystemMessage(204));  //잘못된 이름입니다. 다시 입력해 주세요.
		return;
	}
	RequestCharacterNameCreatable(Name);//사용중인 이름인지 확인 	 EV_CharacterNameCreatable{ //5618 발생 -> HandlecharacterNameCreatable 실행
}

function HandleDialogResult(bool bOk)
{
	local int DlgID;

	if(!class'UICommonAPI'.static.DialogIsOwnedBy(string(self)))
	{
		return;
	}

	DlgID = class'UICommonAPI'.static.DialogGetID();
	//Reserved = class'UICommonAPI'.static.DialogGetReservedInt();

	switch(DlgID)
	{
		case DLG_ID_CREATE:
			HandleCreateCharacter(bOk);
			break;
	}
}

function bool isChinaVer()
{
	return 4 == GetLanguage();
}

function bool isOldChinaVer()
{
	return (4 == GetLanguage()) && !IsAdenServer();
}

function HandleShowMessage(string param)
{
	local string Msg;

	ParseString(param, "Message", Msg);
	ShowMessage(Msg);
}

function ShowMessage(string Msg)
{
	CallGFxFunction("CharacterCreateMenuWnd", "EV_SystemMsgChanged", Msg);
}

function bool IsDeathKnight(int tmpRace, int tmpJob)
{
	return tmpJob == 2 && GetRaceString(tmpRace) != "ORC";
}

function bool IsOrcRider(int tmpRace, int tmpJob)
{
	return tmpJob == 2 && GetRaceString(tmpRace) == "ORC";
}

private function bool IsAssassin(int tmpJob)
{
	return tmpJob == 3;
}

function bool IsHumanMage(int tmpRace, int tmpJob)
{
	return tmpJob == 1 && GetRaceString(tmpRace) == "HUMAN";
}

function string GetRaceString(int raceID)
{
	switch(raceID)
	{
		case 0:
			return "HUMAN";
		case 1:
			return "ELF";
		case 2:
			return "DARKELF";
		case 3:
			return "ORC";
		case 4:
			return "DWARF";
		case 5:
			return "KAMAEL";
		case 6:
			return "ERTHEIA";
		case 30:
			return "SYLPH";
	}
}

defaultproperties
{
}
