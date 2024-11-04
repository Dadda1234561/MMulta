//------------------------------------------------------------------------------------------------------------------------
//
// ����  : LoginServerSelect  - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------

class LoginServerSelect extends GFxUIScript;

//�÷��� �ɼ� ��ǥ
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

function checkWarnimgMode() //�� ���� �� �޽��� ���
{
	local string msg;
	//Ÿ��Ʋ ���� �� ũ�� 15 #FFDF5F
	//13 #DCDCDC
	if(getLanguageNum() == 0) //�ѱ����� ��� 2.0
	{
		msg = GetSystemMessage(5070); //���� ���� �޽���
	}

	//msg �� "" �� ��� ��� ���
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
		//���� ����.
		case "selectServer":
			ParseInt(param, "serverNum", severNum);
			FindAge(severNum);
			RequestLoginServer(severNum);
			break;
		//���� ���� cancel
		case "selectServerCancle":
			GotoLogin();
			break;
		//��õ ������ ����
		case "sortServerList":
			RequestSortedServerInfo();
			break;
		case "showHelp":
			ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "server_help.htm");
			ExecuteEvent(EV_ShowHelp, strParam);
			break;
	}
}

//���ǥ�ø� ���� �۾�. ���� ������ Flash�� �ٲ�鼭 �߰� ��.
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
		// ��������Ʈ �ޱ� ����
		case EV_ServerListStart:
			if(IsShowWindow() == false)
			{
				ShowWindow();
			}
			sendServerListStart();
			//IsChinaClient();
			break;

		// ��������Ʈ �ޱ�
		case EV_ServerList:
			handleServerList(a_param);
			break;
		// ��������Ʈ �ޱ� �Ϸ�
		case EV_ServerListEnd:
			sendServerListEnd();
			break;
	}
}

function handleServerList(string a_param)
{
	local int ID;
	local int AgeLimit;

	// ������ ���� 2012.11.08
	local int IsWorldRaidServer;

	// ������ ������� ����Ʈ ������ �������� ���� 
	ParseInt(a_Param, "IsWorldRaidServer", IsWorldRaidServer);//bool

	if(IsWorldRaidServer == 1)
	{
		return;
	}

	ParseInt(a_Param, "ID", ID);
	//���������� 0, 1�� ���� �����ϹǷ� ���߿� ID���� ���� �ٲ� ��� ��.
	arrID.Length = arrID.Length + 1;
	arrID[arrID.Length - 1] = ID;

	ParseInt(a_Param, "AgeLimit", AgeLimit);
	//���������� 0, 1�� ���� �����ϹǷ� ���߿� ID���� ���� �ٲ� ��� ��.
	arrAgeLimit.Length = arrAgeLimit.Length + 1;
	arrAgeLimit[arrAgeLimit.Length - 1] = AgeLimit;

	CallGFxFunction("LoginServerSelect", "sendServerList", a_param);
}

/**
 * ���� ����Ʈ �ޱ� ����.
 * �߱� ó���� ����.
 */
function sendServerListStart()
{
	local string param;
	/*
	* gfx4.0 ����
	*/
	param = makeVar2Str("IsChinaClient", string(IsChinaClient()));
	param = param @ makeVar2Str("PkString", GetChinaPkString());
	CallGFxFunction("LoginServerSelect", "sendServerListStart", param);
}

/*
 * gfx4.0 ����
 */
function string makeVar2Str(string varName, string vars)
{
	return varName $ "=" $ vars;
}

/**
 * ���� ����Ʈ �ޱ� �Ϸ�.
 */
function sendServerListEnd()
{
	/*
	* gfx4.0 ����
	*/
	CallGFxFunction("LoginServerSelect", "sendServerListEnd", "");
}

defaultproperties
{
}
