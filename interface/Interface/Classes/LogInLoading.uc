//------------------------------------------------------------------------------------------------------------------------
//
// ����         : LogInLoading �������� ���� - SCALEFORM UI
//                ���� �ε�, ��ȭ����
//
//------------------------------------------------------------------------------------------------------------------------
class LogInLoading extends GFxUIScript;

//�÷��� �ɼ� ��ǥ
const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

//Gfx @ uc ������ ���� �Լ�
var array<GFxValue> args;
var GFxValue invokeResult;
var int CurrEventID;

//UI�� UC
var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent(EV_LoginWait);
	RegisterEvent(EV_LoginTelephoneWait);
	RegisterEvent(EV_LoginSecurityCard);
	RegisterEvent(EV_LoginGoogleOtp);
	RegisterEvent(EV_StateChanged);
}

function OnLoad()
{
	RegisterState("LogInLoading", "LOGINWAITSTATE");
	RegisterState("LogInLoading", "TelephoneAuthState");
	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0);
	//SetFixedPositionRate(0.5f, 0.59f);
	SetContainer("ContainerHUD");
	SetAlwaysOnTop(true);
	CurrEventID = 0;
}

function OnShow(){}
function OnFlashLoaded(){}
function OnHide(){}
function OnFocus(bool bFlag, bool bTransparency){}

function OnCallUCFunction(string logicID, string param)
{
	local string cardNum;

	//�α��� ������ ����
	if(logicID == "0")
	{
		//ī�� ��ȣ
		ParseString(param, "cardNum", cardNum);
		
		if(CurrEventID == EV_LoginGoogleOtp)
		{
			// google otp
			RequestGoogleOtpLogin(cardNum);
		}
		else
		{
			//�α��� ��û API
			RequestSecurityCardLogin(param);
		}
	}
	//������
	else if(logicID == "1")
	{
		if(CurrEventID == EV_LoginGoogleOtp)
		{
			RequestExit();
		}
		else
		{
			RequestCardKeyLoginCancel();
		}
	}
	//�α��� ���
	else if(logicID == "2")
	{
		StopLogin();
	}
}

function OnEvent(int Event_ID, string param)
{
	if(isChinaVer())
	{
		return;
	}
	if(Event_ID == EV_LoginWait)
	{
		if(IsShowWindow() == false)
		{
			ShowWindow();
			SendLoading(param);
		}
	}
	else if(Event_ID == EV_LoginTelephoneWait)
	{
		if(IsShowWindow() == false)
		{
			ShowWindow();
			SendTelephoneWait(param);
		}
	}
	if(Event_ID == EV_LoginSecurityCard)
	{
		if(IsShowWindow() == false)
		{
			ShowWindow();
			SendSecurityCard(param);
		}
	}
	if(Event_ID == EV_LoginGoogleOtp)
	{
		CurrEventID = Event_ID;
		ShowWindow();
		SendSecurityCard(param);
	}
	if(Event_ID == EV_StateChanged)
	{
		CallGFxFunction("LogInLoading", "StateChange", "state=" $ param);
		HideWindow();
	}
}

//�ε��� ���.
function SendLoading(string param)
{
	local string Msg;

	ParseString(param, "WaitMsg", Msg);

	// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
	CallGFxFunction("LogInLoading", "SendLoading", "eventID=0 msg=" $ Msg);
}

function SendTelephoneWait(string param)
{
	local string Msg;

	ParseString(param, "WaitMsg", Msg);

	// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
	CallGFxFunction("LogInLoading", "SendTelephoneWait", "eventID=5 msg=" $ Msg);
}

//����ī�� �� ���.
function SendSecurityCard(string param)
{
	local string Msg;

	ParseString(param, "msg", Msg);

	// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
	CallGFxFunction("LogInLoading", "SendSecurityCard", "eventID=10 msg=" $ Msg);
}

function bool isChinaVer()
{
	return GetLanguage() == LANG_Chinese;
}

function bool isOldChinaVer()
{
	return GetLanguage() == LANG_Chinese && !IsAdenServer();
}

defaultproperties
{
}
