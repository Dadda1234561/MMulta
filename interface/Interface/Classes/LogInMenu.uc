//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : LogInMenu 스케일폼 버전 - SCALEFORM UI
//                게임 메뉴
//
//------------------------------------------------------------------------------------------------------------------------
class LogInMenu extends GFxUIScript;

//플래쉬 옵셋 좌표
const DLG_ID_WAITING = 100021;

//Gfx @ uc 연동을 위한 함수
var array<GFxValue> args;
var GFxValue invokeResult;

//UI용 UC
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

	//Debug("OnCallUCLogic 로그인 메뉴" @ logicID);
	//branch 110720
	if(logicID == "0")
	{
		//태국어 예외처리
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
		//태국어 예외처리
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
	//크레딧.
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
		// 현재 해상도를 얻는다.
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
	// 대기열 발생
	else if(Event_ID == EV_LoginQueueTicket)
	{
		waitingProcess(param);
	}
	//   대기열 취소
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

/** 대기열 처리 **/
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
		// - "현재 서버 접속 대기 인원은 $s1명입니다. 취소 버튼을 누르시면 서버 접속을 종료 합니다." 
		messageString = MakeFullSystemMsg(GetSystemMessage(6830), string(nWaiterCount)); // 중국버전은 7202 시스템메시지를 사용하지만, 해외버전은 6830으로 변경함.

		if(Len(messageString) > 0)//|| !IsFinalRelease())
		{
			dScript.ShowDialog(DialogModalType_Modal, DialogType_Notice, messageString, string(Self));
			dScript.SetID(DLG_ID_WAITING);
			dScript.SetButtonName(1342);  // 취소
		}
	}
	else if(nResult == 1 && nWaiterCount == 0)
	{
		// 서버 입장
		// empty 
	}
	else
	{
		// - "서버 접속 대기 중에 오류가 발생하였습니다. 잠시 후에 다시 접속하시기 바랍니다."
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
 * 각 스테이지 별로 버튼의 상태 변경.
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

	// 플래시 타입 데이타 인스턴스 생성
	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);

	// 이벤트 번호 51번
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
 * 해상도 변경.
 */
function SendScreenSize()
{
	CallGFxFunction("LogInMenu", "SendScreenSize", "");
}

/**
 * 옵션 창 열기
 */
function HandleShowOptionWnd()
{
	local OptionWnd win;

	win = OptionWnd(GetScript("OptionWnd"));
	win.ToggleOpenMeWnd(false);  //그냥 열기 
}

defaultproperties
{
}
