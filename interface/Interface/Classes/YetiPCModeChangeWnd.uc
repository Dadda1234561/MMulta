//================================================================================
// YetiPCModeChangeWnd.
//================================================================================

class YetiPCModeChangeWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle YetiPCChange_Btn;
var Shortcut ShortcutScript;
var ShortcutWnd ShortcutWndScript;
var AutoPotionWnd AutoPotionWndScript;
var AutoUseItemWnd AutoUseItemWndScript;
var AutomaticPlay AutomaticPlayScript;
var bool bActiveYetiMode;

function OnRegisterEvent ()
{
	RegisterEvent(EV_Restart);
}

function OnLoad ()
{
	Initialize();
}

function Initialize ()
{
	Me = GetWindowHandle("YetiPCModeChangeWnd");
	YetiPCChange_Btn = GetButtonHandle("YetiPCModeChangeWnd.YetiPCChange_Btn");
	ShortcutScript = Shortcut(GetScript("Shortcut"));
	ShortcutWndScript = ShortcutWnd(GetScript("ShortcutWnd"));
	AutoPotionWndScript = AutoPotionWnd(GetScript("AutoPotionWnd"));
	AutoUseItemWndScript = AutoUseItemWnd(GetScript("AutoUseItemWnd"));
	AutomaticPlayScript = AutomaticPlay(GetScript("AutomaticPlay"));
	bActiveYetiMode = false;
}

function bool isYetiMode ()
{
	return bActiveYetiMode;
}

function OnEvent (int a_EventID, string a_Param)
{
	switch (a_EventID)
	{
		case EV_Restart:
			bActiveYetiMode = False;
			break;
	}
}

function setYetiMode (bool bUseYetiMode)
{
	ShortcutScript.HandleCloseAllWindow();
	if ( bUseYetiMode )
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(13096));
		bActiveYetiMode = True;
		if ( Class'UIAPI_WINDOW'.static.IsShowWindow("RadarMapWnd") )
		{
			Class'UIAPI_WINDOW'.static.HideWindow("RadarMapWnd");
		}
		if ( Class'UIAPI_WINDOW'.static.IsShowWindow("ShortcutWnd") )
		{
			Class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd");
		}
		if ( Class'UIAPI_WINDOW'.static.IsShowWindow("AutoPotionWnd") )
		{
			Class'UIAPI_WINDOW'.static.HideWindow("AutoPotionWnd");
		}
		if ( Class'UIAPI_WINDOW'.static.IsShowWindow("Menu") )
		{
			Class'UIAPI_WINDOW'.static.HideWindow("Menu");
		}
		if ( Class'UIAPI_WINDOW'.static.IsShowWindow("NoticeWnd") )
		{
			Class'UIAPI_WINDOW'.static.HideWindow("NoticeWnd");
		}
		ShortcutScript.HandleForceShowChatWindow(false);
		if ( getInstanceUIData().getIsLiveServer() )
		{
			AutoUseItemWndScript.showHideForYeti(false);
		}
		else
		{
			AutomaticPlayScript.showHideForYeti(false);
		}
		Class'UIAPI_WINDOW'.static.ShowWindow("YetiPCModeChangeWnd");
		Class'UIAPI_WINDOW'.static.ShowWindow("YetiQuickSlotWnd");
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(13097));
		bActiveYetiMode = False;
		if ( !(Class'UIAPI_WINDOW'.static.IsShowWindow("RadarMapWnd")) )
		{
			Class'UIAPI_WINDOW'.static.ShowWindow("RadarMapWnd");
		}
		if ( !(Class'UIAPI_WINDOW'.static.IsShowWindow("ShortcutWnd")) )
		{
			Class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd");
		}
		if ( !(Class'UIAPI_WINDOW'.static.IsShowWindow("AutoPotionWnd")) )
		{
			Class'UIAPI_WINDOW'.static.ShowWindow("AutoPotionWnd");
		}
		if ( !(Class'UIAPI_WINDOW'.static.IsShowWindow("Menu")) )
		{
			Class'UIAPI_WINDOW'.static.ShowWindow("Menu");
		}
		if ( !(Class'UIAPI_WINDOW'.static.IsShowWindow("NoticeWnd")) )
		{
			Class'UIAPI_WINDOW'.static.ShowWindow("NoticeWnd");
		}
		AutoPotionWndScript.windowPositionAutoMove();
		ShortcutScript.HandleForceShowChatWindow(True);
		if(getInstanceUIData().getIsLiveServer())
		{
			AutoUseItemWndScript.showHideForYeti(True);
		}
		else
		{
			AutomaticPlayScript.showHideForYeti(True);
		}
		Class'UIAPI_WINDOW'.static.HideWindow("YetiPCModeChangeWnd");
		Class'UIAPI_WINDOW'.static.HideWindow("YetiQuickSlotWnd");
	}
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "YetiPCChange_Btn":
			OnYetiPCChange_BtnClick();
			break;
	}
}

function OnYetiPCChange_BtnClick ()
{
	setYetiMode(False);
}

defaultproperties
{
}
