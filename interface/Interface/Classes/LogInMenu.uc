//------------------------------------------------------------------------------------------------------------------------
//
// ����         : LogInMenu �������� ���� - SCALEFORM UI
//                ���� �޴�
//
//------------------------------------------------------------------------------------------------------------------------
class LogInMenu extends GFxUIScript;

//�÷��� �ɼ� ��ǥ
const DLG_ID_WAITING = 100021;

//Gfx @ uc ������ ���� �Լ�
var array<GFxValue> args;
var GFxValue invokeResult;

//UI�� UC
var L2Util util;
var DialogBox dScript;

var bool useMiniLogo;

function OnRegisterEvent()
{
	RegisterEvent(EV_LoginBegin);
	RegisterEvent(EV_ResolutionChanged);
	RegisterEvent(EV_StateChanged);
	//OpenGivenURL
	RegisterEvent(EV_LoginQueueTicket);
	RegisterEvent(EV_DialogOK);
}

function OnLoad()
{
	useMiniLogo = true;
	SetHavingFocus(false);
	SetContainer("ContainerHUD");
	dScript = DialogBox(GetScript("DialogBox"));
}

function OnFlashLoaded()
{
	SendCurrLanguage();
	//Debug("laugnage" @ string( language));
}

function OnFocus(bool bFlag, bool bTransparency){}

function OnHide()
{
	//RestartFlash();
}

function OnCallUCFunction(string logicID, string param)
{
	local string strParam;

	//Debug("OnCallUCLogic �α��� �޴�" @ logicID);
	//branch 110720
	if(logicID == "0")
	{
		//�±��� ����ó��
		if(IsNative() == false && getLanguageNum() == 5)
		{
			ParamAdd(strParam, "type", "s");
			ParamAdd(strParam, "ErrorMsg", MakeFullSystemMsg(GetSystemMessage(6090), GetSystemMessage(6088), GetSystemMessage(6089)));
		}
		else
		{
			ParamAdd(strParam, "type", "s");
			ParamAdd(strParam, "ErrorMsg", GetSystemMessage(5019));
		}
		ExecuteEvent(EV_LoginFailFlash, strParam);
	}
	else if(logicID == "1")
	{
		//�±��� ����ó��
		if(IsNative() == false && getLanguageNum() == 5)
		{
			ParamAdd(strParam, "ErrorMsg", MakeFullSystemMsg(GetSystemMessage(6087), GetSystemMessage(6088), GetSystemMessage(6089)));
		}
		else
		{
			ParamAdd(strParam, "ErrorMsg", GetSystemMessage(5020));
		}
		ExecuteEvent(EV_LoginFailFlash, strParam);
	}
	//end of branch
	else if(logicID == "2")
	{
		OpenL2Home();
	}
	//ũ����.
	else if(logicID == "3")
	{
		StartCredit();
	}
	else if(logicID == "4")
	{
		SetUIState("ReplaySelectState");
	}
	else if(logicID == "5")
	{
		HandleShowOptionWnd();
	}
	else if(logicID == "6")
	{
		ParamAdd(strParam, "type", "s");
		ParamAdd(strParam, "ErrorMsg", GetSystemMessage(4082));
		ExecuteEvent(EV_LoginFailFlash, strParam);
	}
	else if(logicID == "7")
	{
		RefuseLogin();
	}
	else if(logicID == "100")
	{
	}
}

function OnEvent(int Event_ID, string param)
{
	if(Event_ID == EV_LoginBegin)
	{
		if(IsShowWindow() == false)
		{
			ShowWindow();
			SendScreenSize();
		}
	}
	else if(Event_ID == EV_ResolutionChanged)
	{
		// ���� �ػ󵵸� ��´�.
		SendScreenSize();
	}
	else if(Event_ID == EV_StateChanged)
	{
		switch(param)
		{
			case "LoginState":
				if(GetLanguage() == LANG_Korean)
				{
					SendSetButtonVisible(false);
				}
				else
				{
					SendSetButtonVisible(true);
				}
				break;
			case "ReplaySelectState":
			case "LOGINWAITSTATE":
			case "EULAMSGSTATE":
			case "SERVERLISTSTATE":
			case "LOGINWAITSTATE":
				ShowWindow();
				SendScreenSize();

				if(IsTencentLoginSystem())
				{
					SendSetButtonVisible(false);
					RequestAuthLoginForTCLS();
				}
				else
				{
					SendSetButtonVisible(false);
				}
				break;

			default:
				HideWindow();
				break;
		}
	}
	// ��⿭ �߻�
	else if(Event_ID == EV_LoginQueueTicket)
	{
		waitingProcess(param);
	}
	//   ��⿭ ���
	else if(Event_ID == EV_DialogOK)
	{
		if(! (dScript.GetTarget() == string(Self)))
		{
			return;
		}

		switch(dScript.GetID())
		{
			case DLG_ID_WAITING:
				Debug("LoginState->" @ param);
				CancelWaitingQueueTicket();

				if(!IsTencentLoginSystem())
				{
					SetUIState("LoginState");
				}
				break;
		}
	}
}

/** ��⿭ ó�� **/
function waitingProcess(string param)
{
	local int nResult;
	local int nWaiterCount;

	local string messageString;

	ParseInt(param, "nResult", nResult);
	ParseInt(param, "nWaiterCount", nWaiterCount);

	messageString = "";

	Debug("waitingProcess param" @ param);

	dScript.HideDialog();

	if(nResult == 1 && nWaiterCount > 0)
	{
		// - "���� ���� ���� ��� �ο��� $s1���Դϴ�. ��� ��ư�� �����ø� ���� ������ ���� �մϴ�." 
		messageString = MakeFullSystemMsg(GetSystemMessage(6830), string(nWaiterCount)); // �߱������� 7202 �ý��۸޽����� ���������, �ؿܹ����� 6830���� ������.

		if(Len(messageString) > 0)//|| !IsFinalRelease())
		{
			dScript.ShowDialog(DialogModalType_Modal, DialogType_Notice, messageString, string(Self));
			dScript.SetID(DLG_ID_WAITING);
			dScript.SetButtonName(1342);  // ���
		}
	}
	else if(nResult == 1 && nWaiterCount == 0)
	{
		// ���� ����
		// empty 
	}
	else
	{
		// - "���� ���� ��� �߿� ������ �߻��Ͽ����ϴ�. ��� �Ŀ� �ٽ� �����Ͻñ� �ٶ��ϴ�."
		messageString = MakeFullSystemMsg(GetSystemMessage(7203), string(nWaiterCount));
		dScript.ShowDialog(DialogModalType_Modal, DialogType_Notice, messageString, string(Self));
		dScript.SetID(DLG_ID_WAITING);
	}
}

/*
 *	registerState("LogInMenu", "ReplayState");
	registerState("LogInMenu", "LOGINWAITSTATE");
	registerState("LogInMenu", "EULAMSGSTATE");
	registerState("LogInMenu", "SERVERLISTSTATE");*/

/**
 * �� �������� ���� ��ư�� ���� ����.
 */
function SendSetButtonVisible(bool b)
{
	if(IsTencentLoginSystem())
	{
		CallGFxFunction("LogInMenu", "SendSetStartButtonVisible", "bool=" $ b);
	}
	CallGFxFunction("LogInMenu", "SendSetButtonVisible", "bool=" $ b);
}

function SendCurrLanguage()
{
	local int languageNum;

	// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);

	// �̺�Ʈ ��ȣ 51��
	args[0].SetInt(51);
	CreateObject(args[1]);

	//branch 110706
	languageNum = getLanguageNum();

	if(IsNative() == false && getLanguageNum() == 5)
	{
		languageNum = 1;
	}

	CallGFxFunction("LogInMenu", "SendCurrLanguage", "language=" $ languageNum);
	args[1].SetMemberInt("language", languageNum);
	Invoke("_root.onEvent", args, invokeResult);
	//end of branch

	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
}

function int getLanguageNum()
{
	local ELanguageType Language;

	Language = GetLanguage();
	return int(Language);
}

/**
 * �ػ� ����.
 */
function SendScreenSize()
{
	CallGFxFunction("LogInMenu", "SendScreenSize", "");
}

/**
 * �ɼ� â ����
 */
function HandleShowOptionWnd()
{
	local OptionWnd win;

	win = OptionWnd(GetScript("OptionWnd"));
	win.ToggleOpenMeWnd(false);  //�׳� ���� 
}

defaultproperties
{
}
