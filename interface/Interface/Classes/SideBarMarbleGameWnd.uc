class SideBarMarbleGameWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var ButtonHandle GameStart_Btn;
var SideBar SideBarScript;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_UI_LAUNCHER);
}

function OnLoad()
{
	Me = GetWindowHandle(m_WindowName);
	GameStart_Btn = GetButtonHandle(m_WindowName $ ".GameStart_Btn");
	SideBarScript = SideBar(GetScript("sideBar"));
	SetClosingOnESC();
}

function OnEvent(int Event_ID, string param)
{
	if ( Event_ID == EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_UI_LAUNCHER )
	{
		ParsePacket_S_EX_MABLE_GAME_UI_LAUNCHER();
	}
}

function ParsePacket_S_EX_MABLE_GAME_UI_LAUNCHER()
{
	local UIPacket._S_EX_MABLE_GAME_UI_LAUNCHER packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_MABLE_GAME_UI_LAUNCHER(packet) )
	{
		return;
	}
	if ( packet.bActivate > 0 )
	{
		SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_MARBLEGAME, true);
	} else {
		SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_MARBLEGAME, false);
	}
}

function OnClickButton(string a_ButtonID)
{
	switch (a_ButtonID)
	{
		case "GameStart_Btn":
			if ( IsPlayerOnWorldRaidServer() )
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
				return;
			}
			if ( !GetWindowHandle("MarbleGameWnd").IsShowWindow() )
			{
				API_C_EX_MABLE_GAME_OPEN();
			}
			else
			{
				GetWindowHandle("MarbleGameWnd").HideWindow();
			}
			break;
		default:
			Me.HideWindow();
			break;
	}
}

function OnShow()
{
	SideBarScript.ToggleByWindowName(m_WindowName, Me.IsShowWindow());
}

function OnHide()
{
	SideBarScript.ToggleByWindowName(m_WindowName, Me.IsShowWindow());
}

function API_C_EX_MABLE_GAME_OPEN()
{
	local array<byte> stream;

	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_MABLE_GAME_OPEN,stream);
	Debug("---> C_EX_MABLE_GAME_OPEN");
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
}

defaultproperties
{
     m_WindowName="SideBarMarbleGameWnd"
}
