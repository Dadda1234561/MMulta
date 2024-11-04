//------------------------------------------------------------------------------------------------------------------------
//
// ����         : LogIn �������� ���� - SCALEFORM UI
//                ���� �α���
//
//------------------------------------------------------------------------------------------------------------------------
class Login extends GFxUIScript;

//�÷��� �ɼ� ��ǥ
const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

//Gfx @ uc ������ ���� �Լ�
var array<GFxValue> args;
var GFxValue invokeResult;

var string logInID;

//UI�� UC
var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent(EV_LoginBegin);
	RegisterEvent(EV_LoginFail);
	RegisterEvent(EV_LoginOK);
	//5700 ���ε� ������ ��
	RegisterEvent(EV_LoginUIGetFocus);
}

function OnLoad()
{
	RegisterState("LogIn", "LoginState");
	SetContainer("ContainerHUD");
	//SetDefaultShow(true);
	SetHUD();
	//SetFixedPositionRate(0.5f, 0.59f);
	SetAlwaysOnTop(true);
	logInID = "";
	HasTextField(false);

	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0);	
}

function OnShow(){}

function OnFlashLoaded(){}

function OnHide()
{
	//RestartFlash();
}

/*
 * gfx4.x
 */
function OnCallUCFunction(String funcName, string param)
{
	local string id;
	local string pass;
	local int ncopt;
	
	local string delString;
	local int i;

	local string url;
	//debug("onCallUCFunction" @ funcName @ param);

	switch(funcName)
	{
		case "setLogin":
			//���̵�
			ParseString(param, "ID", id);
			SaveLastLoginID(id);
			//�н�����
			ParseString(param, "pass", pass);
			//OPT
			ParseInt(param, "ncopt", ncopt);

			//�α��� ��û API
			RequestLogin(ID, pass, ncopt);
			delString = "";

			for(i = 0 ; i < Len(param); i ++)
			{
				delString = delString $ "*";
			}
			param = delString;

			delString = "";

			for(i = 0 ; i < Len(pass); i ++)
			{
				delString = delString $ "*";
			}
			pass = delString;

			delString = "";

			for(i = 0; i < Len(id); i ++)
			{
				delString = delString $ "*";
			}
			id = delString;

			delString = "";

			for(i = 0; i < Len(ncopt); i ++)
			{
				delString = delString $ "0";
			}
			ncopt = int(delString);

			param = "";
			id = "";
			pass = "";
			ncopt = -1;

			//Debug("login" @ param @ id @ pass @ ncopt);
			//Debug("login" @ param.Length @ id.Length @ pass.Length @ ncopt.Length);

			break;
		case "out":
			RefuseLogin();
			break;
		case "openURL":
			url = getSystemString(5192);
			OpenGivenURL(url);
			break;
	}
}

function OnEvent(int Event_ID, string param)
{
	local string ErrorMsg;

	//Debug("uc onEvent" @ Event_ID);

	if(Event_ID == EV_LoginBegin)
	{
		//Debug("OnEvent EV_LoginBegin" @ IsShowWindow());
		if(IsShowWindow() == false)
		{
			ShowWindow();
			FlashInit();
			SendErrorMsg("");
		}
	}
	else if(Event_ID == EV_LoginOK)
	{
		SendLogInSuccess();
	}
	else if(Event_ID == EV_LoginFail)
	{
		ParseString(param, "ErrorMsg", ErrorMsg);
		SendErrorMsg(ErrorMsg);
	}
}

//���� ��.
function FlashInit()
{
	local string param;

	// gfx4.0 ���� /////////////////////////////////////////////////////////////////////	
	//Debug("111111GetLastLoginID()" @ GetLastLoginID());
	param = makeVar2Str("logInID", GetLastLoginID());
	param = param @ makeVar2Str("isOTP", string(IsUseOTP()));
	param = param @ makeVar2Str("optMsg", GetSystemMessage(5068));
	param = param @ makeVar2Str("isUseEMailAccount", String(IsUseEMailAccount()));
	CallGFxFunction("LogIn", "flashInit", param);
}

/*
 * gfx4.0 ����
 */
function string makeVar2Str(string varName, string vars)
{
	return varName $ "=" $ vars;
}

function SendLogInSuccess()
{
	// gfx4.0 ���� /////////////////////////////////////////////////////////////////////
	HideWindow();
	CallGFxFunction("LogIn", "loginSuccess", "");
}

//���� �޽��� ����.
function SendErrorMsg(string ErrorMsg)
{
	// gfx4.0 ���� /////////////////////////////////////////////////////////////////////
	CallGFxFunction("LogIn", "ErrorMsg", ErrorMsg);
}

//Flash�� ���콺 ������ �̺�Ʈ �߻�.
event OnMouseOver(WindowHandle W)
{}

//Flash�� ���콺 �ƿ��� �̺�Ʈ �߻�.
event OnMouseOut(WindowHandle W)
{
	//������ ���콺 ��ġ�� 0,0����.
	ForceToMoveMousePos(0, 0);
}

defaultproperties
{
}
