//------------------------------------------------------------------------------------------------------------------------
//
// ����         : LogIn �������� ���� - SCALEFORM UI
//                ���� �α���
//
//------------------------------------------------------------------------------------------------------------------------
class LogInEula extends GFxUIScript;

//�÷��� �ɼ� ��ǥ
const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

//Gfx @ uc ������ ���� �Լ�
var array<GFxValue> args;
var GFxValue invokeResult;

var int currentScreenWidth, currentScreenHeight;

//UI�� UC
var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent(EV_ShowEula);
	RegisterEvent(EV_ShowChinaEula);
	RegisterEvent(EV_ResolutionChanged);
	RegisterEvent(EV_LoginFailFlash);
}

function OnLoad()
{
	RegisterState("LogInEula", "EULAMSGSTATE");
	SetContainer("ContainerHUD");
	SetAlwaysOnTop(true);
	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0 );
	//SetFixedPositionRate( 0.5f, 0.46f );
}

function OnShow();

function OnFlashLoaded();

function OnHide();

function OnFocus(bool bFlag, bool bTransparency);

function OnCallUCFunction(string logicID, string param)
{
	//����� ���� ��
	if(logicID == "0")
	{
		EulaAgree(true);
	}
	//����� ���� ��
	else if(logicID == "1")
	{
		EulaAgree(false);
	}
}

function OnEvent(int Event_ID, string param)
{
	//local string Eula;
	local string Eula1;
	local string Eula2;

	if(Event_ID == EV_ShowEula)
	{
		if(IsShowWindow() == false)
		{
			ShowWindow();
			SendEula();
			SetAlwaysOnTop(true);
		}
	}
	else if(Event_ID == EV_ShowChinaEula)
	{
		if(IsShowWindow() == false)
		{
			ParseString(param, "EulaTxt1", Eula1);
			ParseString(param, "EulaTxt2", Eula2);
			ShowWindow();
			SendChinaEula(Eula1, Eula2);
		}
	}
	else if(Event_ID == EV_ResolutionChanged)
	{
		// ���� �ػ󵵸� ��´�.
	}
}

//����� ��� ������.
function SendEula()
{
	CallGFxFunction("LoginEula", "SendEula", "");
}

//����� ��� ������. �߱�
function SendChinaEula(string Eula1, string Eula2)
{
	// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);

	// ���� �˶� : �̺�Ʈ ��ȣ 1��
	args[0].SetInt(1);
	CreateObject(args[1]);
	args[1].SetMemberString("Eula1", Eula1);
	args[1].SetMemberString("Eula2", Eula2);
	Invoke("_root.onEvent", args, invokeResult);
	CallGFxFunction("LoginEula", "SendChinaEula", "Eula1=" $ Eula1 @ "Eula2=" $ Eula2);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
}

defaultproperties
{
}
