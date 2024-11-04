class ZoneTitleWnd extends UICommonAPI;

const StartZoneNameX = 100;
const StartZoneNameY = 80;

const TIMER_ID = 0;
const TIMER_DELAY = 4000;

var string m_WindowName;
var WindowHandle m_hZoneTitleWnd;
var TextBoxHandle m_hTbZoneNameBack;
var TextBoxHandle m_hTbZoneNameFront;
var TextBoxHandle serverGroupTextBox;
var TextBoxHandle serverGroupTextBoxBack;

event OnRegisterEvent()
{
	RegisterEvent(EV_BeginShowZoneTitleWnd);
}

event OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_hZoneTitleWnd = GetHandle(m_WindowName);
		m_hTbZoneNameBack = TextBoxHandle(GetHandle(m_WindowName $ ".textZoneNameBack"));
		m_hTbZoneNameFront = TextBoxHandle(GetHandle(m_WindowName $ ".textZoneNameFront"));
		serverGroupTextBoxBack = TextBoxHandle(GetHandle(m_WindowName $ ".textWorldZoneNameBack"));
		serverGroupTextBox = TextBoxHandle(GetHandle(m_WindowName $ ".textWorldZoneName"));
	}
	else
	{
		m_hZoneTitleWnd = GetWindowHandle(m_WindowName);
		m_hTbZoneNameBack = GetTextBoxHandle(m_WindowName $ ".textZoneNameBack");
		m_hTbZoneNameFront = GetTextBoxHandle(m_WindowName $ ".textZoneNameFront");
		serverGroupTextBoxBack = GetTextBoxHandle(m_WindowName $ ".textWorldZoneNameBack");
		serverGroupTextBox = GetTextBoxHandle(m_WindowName $ ".textWorldZoneName");
	}
}

event OnEvent(int Event_ID, string param)
{
	local string ZoneName;
	local string SubZoneName1;
	local string SubZoneName2;
	local string ServerGroupParam;

	switch( Event_ID )
	{
		case EV_BeginShowZoneTitleWnd:
			if(GetOptionBool("ScreenInfo", "ShowZoneTitle") == true)
			{
				ParseString(param, "ZoneName", ZoneName);
				ParseString(param, "SubZoneName1", SubZoneName1);
				ParseString(param, "SubZoneName2", SubZoneName2);
				ParseString(param, "ServerGroupNames", ServerGroupParam);
				BeginShowZoneName(ZoneName, GetServerGroupText(ServerGroupParam), SubZoneName1, SubZoneName2);
			}
			break;
	}
}

function BeginShowZoneName(string ZoneName, string ServerGroupStr, string SubZoneName1, string SubZoneName2)
{
	local int TextWidth;
	local int TextHeight;
	local int ScreenWidth;
	local int ScreenHeight;

	// ������ ZoneName �� ����ϰ� �ִµ� Ŭ���̾�Ʈ ���� �ڵ尡 Ȯ�强�� ���� SubZoneName1, SubZoneName2 �� ���� �� �ְ� �Ǿ�����
	// �ʿ��ϴٸ� XML���� ��Ʈ���� �����ϰ� ��밡��
	// lancelot 2006. 8. 29.

//	class'UIAPI_TEXTBOX'.static.SetText("textZoneNameBack", ZoneName);
//	class'UIAPI_TEXTBOX'.static.SetText("textZoneNameFront", ZoneName);
	m_hTbZoneNameBack.SetText(ZoneName);
	m_hTbZoneNameFront.SetText(ZoneName);

	serverGroupTextBox.SetText(ServerGroupStr);
	serverGroupTextBoxBack.SetText(ServerGroupStr);

	GetTextSize(ZoneName, "ZoneTitle", TextWidth, TextHeight);
	GetCurrentResolution(ScreenWidth, ScreenHeight);

//	class'UIAPI_WINDOW'.static.SetWindowSize("ZoneTitleWnd", TextWidth+StartZoneNameX, 200);
//	class'UIAPI_WINDOW'.static.MoveTo("ZoneTitleWnd", ScreenWidth/2-TextWidth/2-StartZoneNameX, ScreenHeight/5-StartZoneNameY);
	m_hZoneTitleWnd.SetWindowSize(TextWidth+StartZoneNameX, 200);
	m_hZoneTitleWnd.MoveTo(ScreenWidth/2-TextWidth/2-StartZoneNameX, ScreenHeight/5-StartZoneNameY);


	m_hZoneTitleWnd.ShowWindow();

	m_hZoneTitleWnd.SetTimer(TIMER_ID, TIMER_DELAY);
}

function string GetServerGroupText(string ServerGroupParam)
{
	// End:0x1D
	if(ServerGroupParam == "" || IsAdenServer() == false)
	{
		return "";
	}
	ReplaceText(ServerGroupParam, ";", " ");
	return ServerGroupParam;	
}

event OnTimer(int TimerID)
{
	m_hZoneTitleWnd.KillTimer(TimerID);
	m_hZoneTitleWnd.HideWindow();
}

defaultproperties
{
     m_WindowName="ZoneTitleWnd"
}
