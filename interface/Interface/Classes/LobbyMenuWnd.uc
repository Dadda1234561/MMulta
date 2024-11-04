//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : lobbyMenuWnd  - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class LobbyMenuWnd extends L2UIGFxScript;

//const FLASH_WIDTH  = 800;
//const FLASH_HEIGHT = 600;

//플래쉬 옵셋 좌표
const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

const DLG_ID_DELETE=0;
const DLG_ID_RESTORE=1;

//다이얼로그 ID
const DLG_ID_DormantUserCoupon=3;

var int currentScreenWidth, currentScreenHeight;

var int selectedNum;
//const  maxCharacterNum = 7;
var int  maxCharacterNum;

var bool isDeleting;


var bool isStarting;

var bool isPrologueGrowSelected;

function OnRegisterEvent()
{
	RegisterEvent(EV_LobbyAddCharacterName); // 3021
	RegisterEvent(EV_LobbyCharacterSelect); // 3022
	RegisterEvent(EV_LobbyClearCharacterName); // 3023
	RegisterEvent(EV_LobbyShowDialog); // 3025
	RegisterEvent(EV_DialogOK); // 1710
	RegisterEvent(EV_DIalogCancel); // 1720
	RegisterEvent(EV_LobbyGetSelectedCharacterIndex); // 3026
	RegisterEvent(EV_LobbyStartButtonClick); // 3024
	RegisterEvent(EV_StateChanged); //  3410
	RegisterEvent(EV_LobbyCharacterReceivingFinished); // 3027
	RegisterEvent(EV_LoginVitalityEffectInfo); // 4120
	// (러시아) 해외 제재 이벤트
}

function OnLoad()
{
	registerState( "lobbyMenuWnd", "CHARACTERSELECTSTATE" );

	// 캐릭터 이름이 foreGround에서 그려지므로, 로비 UI 위에 그려지게 됨, 윈도우로 컨테이너를 갈아 탐.
	SetContainerWindow( WINDOWTYPE_NONE, 0);
	//SetContainer( "ContainerHUD" );

	SetAnchor( "", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, FLASH_XPOS, FLASH_YPOS );

	maxCharacterNum = 0;	
}

function OnShow()
{
	isStarting = false;
	SetFocus();	
}

function int getLanguageNum()
{
	local ELanguageType Language;
	//local int languageNum;
	Language = GetLanguage();
	return int(Language);
}

function OnCallUCFunction(string logicID, string param)
{
	local string btnName;
	local int Index;

	ParseString(param, "btnName", btnName);
	switch(btnName)
	{
		case "startBtn":
			// End:0x3E
			if(! isDeleting)
			{
				OnClickStartButton();
			}
			break;
		case "prev" ://이전케릭 선택 //next로는 삭제 케릭터가 선택이 되지 않아야 함.
			onClickPrevNext(false);
			break;
		case "next" ://다음케릭 선택 //next로는 삭제 케릭터가 선택이 되지 않아야 함.
			onClickPrevNext(true);
			break;
		case "createBtn" : //케릭 생성으로
			CreateNewCharacter();
			break;
		case "deleteBtn" : //케릭 삭제
			OnClickDeleteCharacter();
			break;
		case "loginBtn" :  //다시 로그인
			GotoLogin();
			break;
		case "restoreBtn" : //케릭터 재생 메시지
			if(! isDeleting)
			{
				ShowRestoreDialog(selectedNum);
			}
			break;
		case "isPrologueGrowSelected":
			isPrologueGrowSelected = bool(logicID);
			break;
		case "selectByIndex":
			ParseInt(param, "index", Index);
			onCharacterSelectChanged(Index);
			break;
		case "add":
			ParseInt(param, "index", Index);
			CreateNewCharacter();
			break;
		case "creditBtn":
			StartCredit();
			break;
	}
}

function OnClickDeleteCharacter()
{
	local string Msg;
	local UserInfo info;

	//시작 하는 중이면 버튼 처리 하지 말 것 -> 삭제 다이얼로그 메시지가
	if(isStarting)
	{
		return;
	}

	// 삭제예정이거나 제재 대상이면 패스, 삭제 중이라도 패스
	if(IsScheduledToDeleteCharacter(selectedNum) || IsDisciplineCharacter(selectedNum))
		return;

	//branch
	// F2P 시스템 활성 캐릭터 수 제한 - gorillazin 11.09.15.
	/*
	if (!IsActivateCharacter(selectedNum))
	{
		ParamAdd(strMsg, "Message", GetSystemMessage(6095));
		ExecuteEvent(EV_MessageWndString, strMsg);
		return;
	}*/
	//end of branch	

	if ( !GetSelectedCharacterInfo( selectedNum, info ))  return ;	

	if ( GetUIUserPremiumLevel() > 0) 
	{
		Msg = MakeFullSystemMsg( GetSystemMessage( 4076 ), info.Name );
	}
	else 
	{
		if ( IsActivateCharacter( selectedNum ) )
		{
			Msg = MakeFullSystemMsg( GetSystemMessage( 4075 ), info.Name );
		}
		else 
		{
			Msg = MakeFullSystemMsg( GetSystemMessage( 4076 ), info.Name );
		}
	}	
	ShowDeleteDialog( selectedNum, Msg );
}


function ShowDeleteDialog(int index, string Msg)
{
	class'UICommonAPI'.static.DialogSetID(DLG_ID_DELETE);
	class'UICommonAPI'.static.DialogSetReservedInt(index);
	class'UICommonAPI'.static.DialogShow(DialogModalType_Modal, DialogType_OKCancel, Msg, string(Self));	
}

function OnClickStartButton()
{
	if(class'UIAPI_WINDOW'.static.IsShowWindow("DialogBox"))
	{
		return;
	}
	
	if(Class'UIAPI_WINDOW'.static.IsShowWindow("Credit"))
	{
		return;
	}

	// 삭제예정이거나 제재 대상이면 패스, 삭제 중이라도 패스
	if(IsScheduledToDeleteCharacter(selectedNum) || IsDisciplineCharacter(selectedNum))
		return;

	isStarting = true;

	PlaySoundUntilEnd("InterfaceSound.game_start"); // 스타트 버튼 소리 나기.
	StartGame(selectedNum);
}

function bool isLiveServer()
{
	local string message;

	// End:0x17
	if(! getInstanceUIData().getIsClassicServer())
	{
		return false;
	}

	ParamAdd(message, "Message", GetSystemMessage( 4304 ));
	//message = GetSystemMessage( 11 );
	switch(GetReleaseMode())
	{		
		case RM_LIVE:
			ExecuteEvent(EV_MessageWndString, message);
			return true;
			break;
		case RM_DEV :break;
		case RM_RC  :break;
		case RM_TEST:break;
	}
	return false;
}

function OnEvent(int Event_ID, string a_param)
{
	local UserInfo Info;
	local int i;

	//Debug("OnEvent" @ Event_ID @ a_param);
	switch(Event_ID)
	{

	//case EV_LobbyMenuButtonEnable :
	//	isDeleting = false;
	//	Debug("Event_ID" @ "EV_LobbyMenuButtonEnable" @ a_param);
	//	HandleMenuButtonEnable(a_Param);
	//  break;
	case EV_StateChanged :
		if (a_param == "CHARACTERSELECTSTATE"){
			if( IsShowWindow() == false )
			{
				//selectedNum = -1;
				ShowWindow();
				
				//dispatchEventToFlash_String( 1, "");
				callGFxFunction("LobbyMenuWnd", "1", "");
			}
		} 
		else
		{				
			//dispatchEventToFlash_String( 2, "");
			callGFxFunction("LobbyMenuWnd", "2", "");
			HideWindow();
		}	
	break;
	case EV_LobbyAddCharacterName : //케릭터 번호 세는 데 쓰임 파라메타 값은 없어도 될 것 같음.
		//Debug("Event_ID" @ "EV_LobbyAddCharacterName" @ a_param);		
		//dispatchEventToFlash_String(11,String(maxCharacterNum));
		maxCharacterNum++;		
		break;
	case EV_LobbyCharacterSelect :
		SetFocus();		
		//dispatchEventToFlash_String(11,"");
		callGFxFunction("LobbyMenuWnd", "11", "");
		HandleCharacterSelect(a_Param);
		break;
	case EV_LobbyClearCharacterName :
	//	Debug("Event_ID" @ "EV_LobbyClearCharacterName" @ a_param);
//		dispatchEventToFlash_String(9, GetSystemMessage(5060));
		callGFxFunction("LobbyMenuWnd", "9", "string="$GetSystemMessage(5060));
		ResetCharacterSelectWindow();	
		break;
	case EV_LobbyShowDialog : //각종 다이얼 로그 메시지 지만 이 uc에서는 restore 확인 다이얼 로그에만 뜸. 추후 이름을 바꿔 주지 않으면 헷갈릴 듯.
		//Debug("Event_ID" @ "EV_LobbyShowDialog" @ a_param);
		HandleSetRestoreButton(a_param);
		//HandleShowDialog(a_param);
		break;
	case EV_DialogOK :
	//	Debug("Event_ID" @ "EV_DialogOK" @ a_param);
		HandleDialogResult(true);
		break;
	case EV_DialogCancel :
		//Debug("Event_ID" @ "EV_DialogCancel" @ a_param);
		HandleDialogResult(false);
		break;
	case EV_LobbyGetSelectedCharacterIndex : 
		//Debug("Event_ID" @ "EV_LobbyGetSelectedCharacterIndex" @ selectedNum);
//		dispatchEventToFlash_String(10, "0");
		SetSelectedCharacter(selectedNum);//m_hCbCharacterName.GetSelectedNum());//외부
		break;
	case EV_LobbyStartButtonClick :
		//Debug("Event_ID" @ "EV_LobbyStartButtonClick" @ a_param);
		if ( !isDeleting ) OnClickStartButton();
		break;
	case EV_LobbyCharacterReceivingFinished : 
		isDeleting = False;
		for ( i = 0;i < 7; i++ )
			setParamsCharacterInfo(i,"disable");

		for ( i = 0;i < maxCharacterNum; i++ )
			if ( GetSelectedCharacterInfo(i,Info) )
			setParamsCharacterInfo(i,"normal");

		setParamsCharacterInfo(maxCharacterNum,"add");
		break;
	/*case EV_MessageWndString : //581
		parseString(a_param, "Message", msg);
		handleShowMessage(msg);*/
	case EV_LoginVitalityEffectInfo:
		//Debug("EV_LoginVitalityEffectInfo" @ a_Param);
		HandleVitalityEffectInfoParam( a_Param );
		break;
	}
}

function HandleVitalityEffectInfoParam( string a_Param )
{
	//local GFXValue argArray;
	
	local int nVitalityBonus;
	local int nVitalityItemRestoreCount;	
	local string VitalityMessage1;
	local string VitalityMessage2;
	local string result;

	//AllocGFxValue(argArray);
	//createObject(argArray);
	
	//nVitalityBonus = 300;
	//nVitalityBonus = 0;
	//nVitalityItemRestoreCount = 5;	

	ParseInt(a_Param, "vitalityBonus", nVitalityBonus);
	ParseInt(a_Param, "vitalItemCount", nVitalityItemRestoreCount);

	VitalityMessage1 = MakeFullSystemMsg( GetSystemMessage(6072), String(nVitalityBonus) $"%" );//몇백 % 남았습니다.
	//VitalityMessage = VitalityMessage $ " ";
	VitalityMessage2 = MakeFullSystemMsg( GetSystemMessage(6073), String(nVitalityItemRestoreCount));// 몇 개 남았습니다.
	//Debug("UC' HandleVitalityEffectInfo" @ nVitalityBonus @ nVitalityItemRestoreCount);
	//Create, Delete, Start;
	//argArray.SetMemberInt("nVitality",nVitality);	 
	//argArray.SetMemberInt("nVitalityBonus",nVitalityBonus);	 
	//argArray.SetMemberInt("nVitalityItemRestoreCount",nVitalityItemRestoreCount);
	//argArray.SetMemberString("VitalityMessage1", VitalityMessage1);
	//argArray.SetMemberString("VitalityMessage2", VitalityMessage2);


	result = result $ setParamString("vitalityBonus", string(nVitalityBonus));
	result = result @ setParamString("vitalItemCount", string(nVitalityItemRestoreCount));
	result = result @ setParamString("VitalityMessage1", VitalityMessage1);
	result = result @ setParamString("VitalityMessage2", VitalityMessage2);

	callGFxFunction( "LobbyMenuWnd", "10", result);

	//dispatchEventToFlash(10, argArray);
	//DeallocGFxValue(argArray);
}

function string setParamString(string paramName, string vars)
{
	local string result;
	result = paramName $ "=" $ vars;
	return result;
}

function string setParamInt(string paramName, int vars)
{
	local string result;
	result = paramName $ "=" $ vars;
	return result;
}

function string setParamInt64(string paramName, INT64 vars)
{
	local string result;
	result = paramName $ "=" $ vars;
	return result;
}

function setParams(int index)
{
	local UserInfo info;
	//local GFXValue argArray;
	local int toDeleteChar;
	local int IsDisciplineChar;
	local string result;
	local int disciplineCharacter;
	local string lastConnectTime;
	local int nTimeToLastLogoutCharacter;
	local int deleteRemainSec;

	if (GetSelectedCharacterInfo(index, info)) {

		//AllocGFxValue(argArray);
		//createObject(argArray);		
		nTimeToLastLogoutCharacter = GetTimeToLastLogoutCharacter(Index);
		if ( nTimeToLastLogoutCharacter > 0 )
			lastConnectTime = BR_ConvertTimeToStr(GetTimeToLastLogoutCharacter(Index),0);
		deleteRemainSec = GetTimeToDeleteCharacter(Index);

		if(IsScheduledToDeleteCharacter(index) ) toDeleteChar = 1; else toDeleteChar = 0; //삭제 대기 케릭터
		if(IsDisciplineCharacter(index))     IsDisciplineChar = 1; else IsDisciplineChar = 0;//블럭 케릭터
		/*
		argArray.SetMemberInt("toDeleteChar", toDeleteChar );
		argArray.SetMemberInt("IsDisciplineChar", IsDisciplineChar);


		argArray.SetMemberInt("index" , index);
		argArray.SetMemberString("Name" , info.Name); //이름		
		argArray.SetMemberInt("LV",info.nLevel); //레벨
		argArray.SetMemberString("SC",GetClassType(info.nSubClass)); //서브클레스  
		argArray.SetMemberInt("SP",info.nSP);	 //SP
		argArray.SetMemberInt("CR",info.nCriminalRate);			
		argArray.SetMemberInt("HP",info.nCurHP);	 //HP
		argArray.SetMemberInt("maxHP",info.nMaxHP);	 //HPMAX
		argArray.SetMemberInt("MP",info.nCurMP);	 //MP
		argArray.SetMemberInt("maxMP",info.nMaxMP);	 //MPMAX
		argArray.SetMemberFloat("EXP",info.fExpPercentRate);	 //EXP				
		argArray.SetMemberInt("VP",info.nVitality);	 //VP
		argArray.SetMemberInt("maxVP",140000);	 //VPMAX
*/

		result = result $ setParamInt("toDeleteChar" , toDeleteChar);
		result = result @ setParamInt("IsDisciplineChar" , IsDisciplineChar);
		result = result @ setParamInt("index" , index);
		result = result @ setParamString("Name" , info.Name); //이름		
		result = result @ setParamInt("LV", info.nLevel); //레벨
		result = result @ setParamString("SC", GetClassType(info.nSubClass)); //서브클레스  
		result = result @ setParamInt64("SP", info.nSP);	 //SP
		result = result @ setParamInt("CR", info.nCriminalRate);			
		result = result @ setParamInt("HP", info.nCurHP);	 //HP
		result = result @ setParamInt("maxHP", info.nMaxHP);	 //HPMAX
		result = result @ setParamInt("MP", info.nCurMP);	 //MP
		result = result @ setParamInt("maxMP", info.nMaxMP);	 //MPMAX
		result = result @ setParamString("EXP", string(info.fExpPercentRate * 1000000));	 //EXP
		result = result @ setParamInt("VP", info.nVitality);	 //VP
		//result = result @ setParamInt("maxVP", 3500000);	 //VPMAX
		result = result @ setParamInt("maxVP", GetMaxVitality());	 //VPMAX

		//Debug ( "classID" @  info.nSubClass ) ;
		result = result @ setParamInt("classID", info.nSubClass);	 //VPMAX
		result = result @ setParamString("characterImage",getCharacterImg(Info.Race,Info.nSubClass,Info.nSex));
		result = result @ setParamInt("disciplineCharacter",disciplineCharacter);
		result = result @ setParamInt("deleteRemainSec",deleteRemainSec);
		result = result @ setParamString("lastConnectTime",lastConnectTime);
		Debug("캐릭터 이미지 : " @ getCharacterImg(Info.Race, Info.nSubClass, Info.nSex));
		CallGFxFunction( "LobbyMenuWnd", "8", result);
//		debug("인덱스 선택 " @ string(info.fExpPercentRate * 10000) );
		//dispatchEventToFlash(8, argArray);
		//DeallocGFxValue(argArray);
		HandleVitalityEffectInfo( info.nVitalBonus, info.nVitalItem);		
	}
}

function setParamsCharacterInfo (int Index, string selectButtonState)
{
	local UserInfo Info;
	local int toDeleteChar;
	local int IsDisciplineChar;
	local int disciplineCharacter;
	local string lastConnectTime;
	local int nTimeToLastLogoutCharacter;
	local int deleteRemainSec;
	local string result;

	if ( (selectButtonState == "disable") || (selectButtonState == "add") )
	{
		result = result @ setParamInt("test",0);
		result = result @ setParamString("SelectButtonState",selectButtonState);
		result = result @ setParamInt("index",Index);
		CallGFxFunction("LobbyMenuWnd","15",result);
	}
	else if ( GetSelectedCharacterInfo(Index,Info) )
	{
		if ( IsScheduledToDeleteCharacter(Index) )
			toDeleteChar = 1;
		else
			toDeleteChar = 0;

		if ( IsDisciplineCharacter(Index) )
			IsDisciplineChar = 1;
		else
			IsDisciplineChar = 0;

		disciplineCharacter = GetTimeToDisciplineCharacter(Index);
		nTimeToLastLogoutCharacter = GetTimeToLastLogoutCharacter(Index);
		if ( nTimeToLastLogoutCharacter > 0 )
			lastConnectTime = BR_ConvertTimeToStr(GetTimeToLastLogoutCharacter(Index),0);

		deleteRemainSec = GetTimeToDeleteCharacter(Index);
		result = result $ setParamInt("toDeleteChar",toDeleteChar);
		result = result @ setParamInt("IsDisciplineChar",IsDisciplineChar);
		result = result @ setParamInt("index",Index);
		result = result @ setParamString("Name",Info.Name);
		result = result @ setParamInt("LV",Info.nLevel);
		result = result @ setParamString("SC",GetClassType(Info.nSubClass));
		result = result @ setParamInt64("SP",Info.nSP);
		result = result @ setParamInt("CR",Info.nCriminalRate);
		result = result @ setParamInt("HP",Info.nCurHP);
		result = result @ setParamInt("maxHP",Info.nMaxHP);
		result = result @ setParamInt("MP",Info.nCurMP);
		result = result @ setParamInt("maxMP",Info.nMaxMP);
		result = result @ setParamString("EXP",string(Info.fExpPercentRate * 1000000));
		result = result @ setParamInt("VP",Info.nVitality);
		result = result @ setParamInt("maxVP",GetMaxVitality());
		result = result @ setParamInt("classID",Info.nSubClass);
		result = result @ setParamString("characterImage",getCharacterImg(Info.Race,Info.nSubClass,Info.nSex));
		result = result @ setParamString("SelectButtonState",selectButtonState);
		result = result @ setParamInt("disciplineCharacter",disciplineCharacter);
		result = result @ setParamString("lastConnectTime",lastConnectTime);
		result = result @ setParamInt("deleteRemainSec",deleteRemainSec);
		CallGFxFunction("LobbyMenuWnd","15",result);
	}
}


function HandleVitalityEffectInfo( int nVitalBonus , int nVitalItem)
{
	//local GFXValue argArray;
	
	local string VitalityMessage1;
	local string VitalityMessage2;
	local string result;

	//AllocGFxValue(argArray);
	//createObject(argArray);	


	// 버프 형태의 활력 추가 수치를 로비에서는 알 수 없으므로, 적용 중인지 미 적용 중인지만 표시 
//	VitalityMessage1 = MakeFullSystemMsg( GetSystemMessage(6072), String(nVitalBonus) $"%" );//몇백 % 남았습니다.
	VitalityMessage1 = GetSystemString ( 2495 ) ;
	
	VitalityMessage1 = VitalityMessage1 $ ",";
	VitalityMessage2 = MakeFullSystemMsg( GetSystemMessage(6073), String(nVitalItem));// 몇 개 남았습니다.	
	

	/*
	argArray.SetMemberString("VitalityMessage1", VitalityMessage1);
	argArray.SetMemberString("VitalityMessage2", VitalityMessage2);
	//Debug("HandleVitalityEffectInfo" @ VitalityMessage1@VitalityMessage2);
*/

	result = result $ setParamString("VitalityMessage1", VitalityMessage1);
	result = result @ setParamString("VitalityMessage2", VitalityMessage2);

	callGFxFunction( "LobbyMenuWnd", "10", result);

	//dispatchEventToFlash(10, argArray);
	//DeallocGFxValue(argArray);
}



function HandleCharacterSelect(string param)
{
	local int index;
	ParseInt(param, "index", index);

	if(index==-1)
	{
//		setModalByDeleting( false ); // 선택할 케릭이 없으므로, 모달 상태 해제.
		return;
	}
	onCharacterSelectChanged(index);
}

function bool checkSelectEnable ()
{
	if (  !IsDisciplineCharacter(selectedNum) )
		return true;
	return false;
}

function int setEnableSelectedNum()
{
	if (selectedNum < 0)
	{
		selectedNum = maxCharacterNum - 1;
	} 
	else if( selectedNum >= maxCharacterNum )
	{
		selectedNum = 0;
	}
	return selectedNum;
}

function onClickPrevNext(bool isNext)
{
	local int Id;

	if ( maxCharacterNum > 1 )
	{
		if ( isNext )
		{
			selectedNum++;
			Id = 7;
		}
		else
		{
			selectedNum--;
			Id = 6;
		}
		setEnableSelectedNum();
		RequestCharacterSelect(selectedNum); //클릭 처리는 안됨 않음.
		CallGFxFunction("LobbyMenuWnd",string(Id),"string=" $ string(selectedNum));
		setParams(selectedNum);
	}
}

/*function setModalByDeleting(bool isDelete)
{
	Debug ("setModalByDeleting("@ isDelete @")");
	isDeleting = isDelete;
	//SetModal( !isDeleting); //케릭터 클릭을 못하도록 하거나 할 수 있도록 함.	
}*/

function onCharacterSelectChanged( int index )
{
	local UserInfo info;
	local int toDeleteChar;
	local int disciplineCharacter;
	local string lastConnectTime;
	local int nTimeToLastLogoutCharacter;
	local int deleteRemainSec;

	RequestCharacterSelect(index);
	if (GetSelectedCharacterInfo(index, info)) 
	{
		if(IsScheduledToDeleteCharacter(index) ) toDeleteChar = 1; else toDeleteChar = 0; //삭제 대기 케릭터
	}
	if ( selectedNum != index )
	{
		nTimeToLastLogoutCharacter = GetTimeToLastLogoutCharacter(Index);
		if ( nTimeToLastLogoutCharacter > 0 )
			lastConnectTime = BR_ConvertTimeToStr(GetTimeToLastLogoutCharacter(Index),0);

		deleteRemainSec = GetTimeToDeleteCharacter(Index);
		if ( selectedNum > Index )
			CallGFxFunction("LobbyMenuWnd","6","string=" $ string(Index) @ "toDeleteChar=" $ string(toDeleteChar) @ "disciplineCharacter=" $ string(disciplineCharacter) @ "deleteRemainSec=" $ string(deleteRemainSec) @ "lastConnectTime=" $ lastConnectTime);
		else
			CallGFxFunction("LobbyMenuWnd","7","string=" $ string(Index) @ "toDeleteChar=" $ string(toDeleteChar) @ "disciplineCharacter=" $ string(disciplineCharacter) @ "deleteRemainSec=" $ string(deleteRemainSec) @ "lastConnectTime=" $ lastConnectTime);
	selectedNum = Index;
	}
	else {
//		Debug("onCharacterSelectChanged  selectedNum == index");
	}
	
	setParams(index);
}

function HandleSetRestoreButton(string param){
	local string type;	
	ParseString(param, "Type", type);
	callGFxFunction("LobbyMenuWnd", "5", "string="$type);
}

function HandleShowDialog(string param)
{
	local string type;
	local int SelectedCharacter;

	ParseString(param, "Type", type);

	switch(type)
	{
		case "restore":
			ParseInt(param, "SelectedCharacter", SelectedCharacter);
			ShowRestoreDialog(SelectedCharacter);
			break;
	}
}

function ShowRestoreDialog(int SelectedCharacter)
{
	class'UICommonAPI'.static.DialogSetEnterDoNothing();
	class'UICommonAPI'.static.DialogSetID(DLG_ID_RESTORE);
	class'UICommonAPI'.static.DialogSetReservedInt(SelectedCharacter);
	class'UICommonAPI'.static.DialogShow(DialogModalType_Modal, DialogType_OKCancel, GetSystemMessage( 1555 ), string(Self) );	
}

function HandleDialogResult(bool bOK)
{
	local int DlgID;
	local int Reserved;

	if(!class'UICommonAPI'.static.DialogIsOwnedBy( string(Self) ))
		return;

	DlgID = class'UICommonAPI'.static.DialogGetID();
	Reserved = class'UICommonAPI'.static.DialogGetReservedInt();

	switch(DlgID)
	{
		case DLG_ID_RESTORE:
			HandleDialogRestore(bOK, Reserved);
			break;
		case DLG_ID_DELETE:
			HandleDialogDelete(bOK, Reserved);
			break;
		case DLG_ID_DormantUserCoupon:
			HandleDormantUserCoupon(bOK);
			break;
	}
}

function HandleDormantUserCoupon(bool bOK)
{
	// End:0x20
	if(bOK)
	{
		OpenGivenURL(GetSystemString(3119));
		GotoLogin();
	}	
}

function HandleDialogRestore(bool bOK, int SelectedCharacter)
{
	// End:0x14
	if(bOK)
	{
		RequestRestoreCharacter(SelectedCharacter);
	}

	RequestCharacterSelect(SelectedCharacter);
}

function HandleDialogDelete(bool bOK, int SelectedCharacter)
{
	// End:0x1C
	if(bOK)
	{
		isDeleting = true;
		RequestDeleteCharacter(SelectedCharacter);
	}
}

function ResetCharacterSelectWindow()
{
	selectedNum = -1;
	CallGFxFunction("LobbyMenuWnd", "6", "string=-1");
	maxCharacterNum = 0;
}

function string getCharacterImg(int nRace, int nClassID, int nSex)
{
	local string sexStr, playerType;

	playerType = L2Util(GetScript("L2Util")).getPlayerType(nClassID, nRace);
	// End:0x44
	if(nSex == 0)
	{
		sexStr = "M";
	}
	else
	{
		sexStr = "W";
	}
	// End:0x62
	if(nRace == 6)
	{
		sexStr = "W";
	}

	return getInstanceL2Util().GetRaceString(nRace) $ "_" $ playerType $ "_" $ sexStr;
}

function bool numToBool(int bNum)
{
	// End:0x10
	if(bNum > 0)
	{
		return true;		
	}
	else
	{
		return false;
	}
}

function int boolToNum(bool Num)
{
	// End:0x0E
	if(Num)
	{
		return 1;		
	}
	else
	{
		return 0;
	}
}

defaultproperties
{
}
