//------------------------------------------------------------------------------------------------------------------------
//
// 제목  : LoginServerSelect  - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------

class LoginServerSelect extends GFxUIScript;

//플래쉬 옵셋 좌표
const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

var array<int> arrID;
var array<int> arrAgeLimit;

var int currentScreenWidth, currentScreenHeight;

function int getLanguageNum()
{
	local ELanguageType Language;

	Language = GetLanguage();
	return int(Language);
}

function OnShow()
{
	//checkWarnimgMode();
	//ExecuteCommand("///uidebug");
}

function OnFlashLoaded()
{}

function checkWarnimgMode() //각 조건 별 메시지 출력
{
	local string msg;
	//타이틀 색생 및 크기 15 #FFDF5F
	//13 #DCDCDC
	if(getLanguageNum() == 0) //한국어일 경우 2.0
	{
		msg = GetSystemMessage(5070); //서버 통합 메시지
	}

	//msg 가 "" 일 경우 노멀 모드
	CallGFxFunction("LoginServerSelect", "showWarningMode", msg);
}

function OnHide(){}

/*
 * GGx4.x
 */
function OnCallUCFunction(string funcName, string param)
{
	local int severNum;
	local string strParam;

	//debug("OnCallUCFunction" @ funcName @  param);
	switch(funcName)
	{
		//서버 선택.
		case "selectServer":
			ParseInt(param, "serverNum", severNum);
			FindAge(severNum);
			RequestLoginServer(severNum);
			break;
		//서버 선택 cancel
		case "selectServerCancle":
			GotoLogin();
			break;
		//추천 서버로 정렬
		case "sortServerList":
			RequestSortedServerInfo();
			break;
		case "showHelp":
			ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "server_help.htm");
			ExecuteEvent(EV_ShowHelp, strParam);
			break;
	}
}

//등급표시를 위한 작업. 서버 선택이 Flash로 바뀌면서 추가 됨.
function FindAge(int serverID)
{
	local int i;
	local int intAge;
	local string strParam;

	for(i = 0; i < arrID.Length; i++)
	{
		if(serverID == arrID[i])
		{
			//debug( "!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@!@" $ string( arrAgeLimit[i] ) $ arrTest[i] );
			if(arrAgeLimit[i] == 15)
			{
				intAge = 0;
			}
			else if(arrAgeLimit[i] == 18)
			{
				intAge = 1;
			}
			else
			{
				intAge = 1;
			}
			ParamAdd(strParam, "ServerAgeLimit", string(intAge));
			ParamAdd(strParam, "GlobalVersion", string(getLanguageNum()));
			ExecuteEvent(EV_ServerAgeLimitChange, strParam);
			break;
		}
	}
}


function OnEvent(int Event_ID, string a_param)
{
	//Debug (" server Select" @ Event_ID @ a_param);
	switch(Event_ID)
	{
		// 서버리스트 받기 시작
		case EV_ServerListStart:
			if(IsShowWindow() == false)
			{
				ShowWindow();
			}
			sendServerListStart();
			//IsChinaClient();
			break;

		// 서버리스트 받기
		case EV_ServerList:
			handleServerList(a_param);
			break;
		// 서버리스트 받기 완료
		case EV_ServerListEnd:
			sendServerListEnd();
			break;
	}
}

function handleServerList(string a_param)
{
	local int ID;
	local int AgeLimit;

	// 공성전 서버 2012.11.08
	local int IsWorldRaidServer;

	// 공성전 서버라면 리스트 정보를 보내주지 않음 
	ParseInt(a_Param, "IsWorldRaidServer", IsWorldRaidServer);//bool

	if(IsWorldRaidServer == 1)
	{
		return;
	}

	ParseInt(a_Param, "ID", ID);
	//서버에서는 0, 1로 값을 구분하므로 나중에 ID맞춰 값을 바꿔 줘야 함.
	arrID.Length = arrID.Length + 1;
	arrID[arrID.Length - 1] = ID;

	ParseInt(a_Param, "AgeLimit", AgeLimit);
	//서버에서는 0, 1로 값을 구분하므로 나중에 ID맞춰 값을 바꿔 줘야 함.
	arrAgeLimit.Length = arrAgeLimit.Length + 1;
	arrAgeLimit[arrAgeLimit.Length - 1] = AgeLimit;

	CallGFxFunction("LoginServerSelect", "sendServerList", a_param);
}

/**
 * 서버 리스트 받기 시작.
 * 중국 처리도 해줌.
 */
function sendServerListStart()
{
	local string param;
	/*
	* gfx4.0 버젼
	*/
	param = makeVar2Str("IsChinaClient", string(IsChinaClient()));
	param = param @ makeVar2Str("PkString", GetChinaPkString());
	CallGFxFunction("LoginServerSelect", "sendServerListStart", param);
}

/*
 * gfx4.0 버젼
 */
function string makeVar2Str(string varName, string vars)
{
	return varName $ "=" $ vars;
}

/**
 * 서버 리스트 받기 완료.
 */
function sendServerListEnd()
{
	/*
	* gfx4.0 버젼
	*/
	CallGFxFunction("LoginServerSelect", "sendServerListEnd", "");
}

defaultproperties
{
}
