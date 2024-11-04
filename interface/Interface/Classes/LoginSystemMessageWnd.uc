//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : lobbyMenuWnd  - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class LoginSystemMessageWnd extends GFxUIScript;

var array<string> stateArr;
var array<int> titleSystemInt;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

function OnRegisterEvent()
{
	RegisterEvent(EV_StateChanged);
	RegisterEvent(EV_MessageWndString);
	RegisterEvent(EV_CharacterDeleteFail);//9740
}

function OnLoad()
{
	local int i;
	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, FLASH_XPOS, FLASH_YPOS);	

	stateArr[0] = "EULAMSGSTATE"; //이용약관
	stateArr[1] = "SERVERLISTSTATE"; //서버선택
	stateArr[2] = "CHARACTERSELECTSTATE";  //캐릭터 선택
	
	if(LogInMenu(GetScript("LoginMenu")).useMiniLogo)
	{
		titleSystemInt[0] = 0;
		titleSystemInt[1] = 0;
	}
	else
	{
		titleSystemInt[0] = 2686;
		titleSystemInt[1] = 2693;
	}
	titleSystemInt[2] = 157;

	for (i = 0; i < stateArr.Length; i++)
	{
		RegisterState("loginSystemMessageWnd", stateArr[i]);
	}
	SetHavingFocus(false);
	SetHUD();
	SetContainer("ContainerHUD");
	SetDefaultShow(true);
	SetAlwaysFullAlpha(true);
	SetMsgPassThrough(true);
}

function HandleShowMessage(string systemMessage)
{
	dispatchEventToFlash_String(3, systemMessage);
}

function OnEvent(int Event_ID, string a_Param)
{
	local string Msg;
	switch(Event_ID)
	{
		case EV_StateChanged:
			HandleStateChange(a_Param);
			break;
		case EV_MessageWndString : //581
			ParseString(a_Param, "Message", Msg);
			HandleShowMessage(Msg);
			break;
		case EV_CharacterDeleteFail:
			handleShowDeleteFail(a_Param);
			break;
	}
}

function handleShowDeleteFail(string a_param)
{
	local int type;
	local int msgInt;
	local string systemMessage;

	parseInt(a_param, "type", type);

//	if ( type == 0 ) return // 성공 할 경우 .

	switch ( type ) 
	{
		//성공 적으로 삭제 한 경우.
		case ECharacterDeleteFailType.ECDFT_NONE:
			return;
			break;
		case ECharacterDeleteFailType.ECDFT_UNKNOWN:
			msgInt = 306;
			break;
		case ECharacterDeleteFailType.ECDFT_PLEDGE_MEMBER:
			msgInt = 541;
			break;
		case ECharacterDeleteFailType.ECDFT_PLEDGE_MASTER:
			msgInt = 540;
			break;
		case ECharacterDeleteFailType.ECDFT_PROHIBIT_CHAR_DELETION:
			msgInt = 3091;
			break;
		case ECharacterDeleteFailType.ECDFT_COMMISSION:
			msgInt = 3529;
			break;
		case ECharacterDeleteFailType.ECDFT_MENTOR:
			msgInt = 3716;
			break;
		case ECharacterDeleteFailType.ECDFT_MAIL:
			msgInt = 4198;
			break;
	}
	systemMessage = GetSystemMessage(msgInt);
	dispatchEventToFlash_String(3, systemMessage);
}

function HandleStateChange(string a_Param)
{
	local int stateNum;

	stateNum = chkState(a_Param);
	
	if(stateNum != -1)
	{
		dispatchEventToFlash_Int(1, titleSystemInt[stateNum]);
	}
	else
	{
		dispatchEventToFlash_Int(2, -1);
	}
}

function int chkState(string State)
{
	local int i;

	for (i = 0; i < stateArr.Length; i++)
		if (State == stateArr[i])
			return i;
	
	return -1;
}

function handleShowKindOfAccount(string a_Param)
{
	local int premiumLevel;
	local array<int> kindOfAccount[20];

	kindOfAccount[0] = 5097; //Free Account;
	kindOfAccount[1] = 5098; //Premium Account;
	ParseInt(a_Param, "premiumLevel", premiumLevel);
	dispatchEventToFlash_Int(4, kindOfAccount[premiumLevel]);
}

function dispatchEventToFlash_String(int Event_ID, string argString)
{
	CallGFxFunction("LoginSystemMessageWnd", "logSystemMsgFunc", "eventID=" $ Event_ID @ "string=" $ argString);
}

function dispatchEventToFlash_Int(int Event_ID, int argInt)
{
	CallGFxFunction("LoginSystemMessageWnd", "logSystemMsgFunc", "eventID=" $ Event_ID @ "num=" $ argInt);
}

defaultproperties
{
}
