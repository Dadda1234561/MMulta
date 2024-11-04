//================================================================================
// EventletterCollectorLauncher.
//================================================================================

class EventletterCollectorLauncher extends L2UIGFxScript
	dependsOn(UIProtocol);

var WindowHandle eventletterCollectorWndHandle;
var bool bActived;
var SideBar SideBarScript;

function OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_LETTER_COLLECTOR_UI_LAUNCHER));
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_StateChanged);
}

function OnLoad()
{
	SetSaveWnd(true, false);
	RegisterState("EventletterCollectorLauncher", "GamingState");
	SetContainerWindow(WINDOWTYPE_NOBG_NODRAG, 0);
	AddState("GAMINGSTATE");
	eventletterCollectorWndHandle = GetWindowHandle("EventletterCollectorWnd");
	SideBarScript = SideBar(GetScript("SideBar"));
}

function OnEvent(int Id, string param)
{
	switch(Id)
	{
		case EV_PacketID(class'UIPacket'.const.S_EX_LETTER_COLLECTOR_UI_LAUNCHER):
			HandleLuncherOnOf();
			break;
		case EV_UpdateUserInfo:
			HandleUpdateUserInfo();
			break;
		case EV_Restart:
			bActived = False;
			break;
		case EV_StateChanged:
			if(param == "GAMINGSTATE")
			{
				// End:0x6B
				return;
			}
			break;
	}
}

function showSideBar(string minLv)
{
	if(bActived)
	{
		Debug("showSideBarshowSideBarshowSideBar--->" @ minLv);
		SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_EVENTLETTERCOLLECTOR, true);
		Class'UIAPI_WINDOW'.static.ShowWindow("EventletterCollectorLauncher");
		SideBarScript.setMakegfxWindowTooltip(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_EVENTLETTERCOLLECTOR, minLv);
	}
	else
	{
		SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_EVENTLETTERCOLLECTOR, false);
	}
}

function OnShow()
{
	SideBarScript.ToggleByWindowName("EventletterCollectorLauncher", true);
	CallGFxFunction("EventletterCollectorLauncher", "LevelCheck", "");
}

function OnHide()
{
	SideBarScript.ToggleByWindowName("EventletterCollectorLauncher", false);
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "ShowHideCollectorWnd":
			ShowHideCollectorWnd();
			break;
	}
}

function ShowHideCollectorWnd()
{
	if(eventletterCollectorWndHandle.IsShowWindow())
	{
		eventletterCollectorWndHandle.HideWindow();
	}
	else
	{
		eventletterCollectorWndHandle.ShowWindow();
	}
}

function HandleUpdateUserInfo()
{
	if(Class'UIAPI_WINDOW'.static.IsShowWindow("EventletterCollectorLauncher"))
	{
		if(getInstanceUIData().isLevelUP() || getInstanceUIData().IsLevelDown())
		{
			CallGFxFunction("EventletterCollectorLauncher","LevelCheck","");
		}
	}
}

function HandleLuncherOnOf ()
{
	local UIPacket._S_EX_LETTER_COLLECTOR_UI_LAUNCHER packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_LETTER_COLLECTOR_UI_LAUNCHER(packet) )
	{
		return;
	}
	if ( packet.bActivate == 0 )
	{
		Class'UIAPI_WINDOW'.static.HideWindow("EventletterCollectorLauncher");
	}
	else
	{
		bActived = true;
		CallGFxFunction("EventletterCollectorLauncher", "SetMinLevel", string(packet.nMinLevel));
		class'UIAPI_WINDOW'.static.ShowWindow("EventletterCollectorLauncher");
		showSideBar(string(packet.nMinLevel));
	}
	EventletterCollectorWnd(GetScript("EventletterCollectorWnd")).MinLevel = packet.nMinLevel;
}

defaultproperties
{
}
