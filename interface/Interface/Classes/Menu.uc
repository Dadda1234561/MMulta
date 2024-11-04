//------------------------------------------------------------------------------------------------------------------------
//
// 제목				 : Menu 스케일폼 버전 - SCALEFORM UI
//								메인 메뉴
//
//------------------------------------------------------------------------------------------------------------------------
class Menu extends UICommonAPI;

const MAX_BUTTON_NUM = 12;
const UTXPATH = "L2UI_NewTex.MenuWnd.icon_Menu_";

var WindowHandle Me;
var array<int> menuListToolip;
var array<MenuButtonSlotStruct> menuList;
var MenuEntireWnd MenuEntireWndScript;
var bool bExpandMenuShow;

function OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
}

function OnLoad()
{
	Initialize();
}

function Initialize()
{
	MenuEntireWndScript = MenuEntireWnd(GetScript("MenuEntireWnd"));
	Me = GetWindowHandle("Menu");
}

function Load()
{
	ShowWindowWithFocus("Menu");
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local string Num, win;

	// End:0x3B
	if("SystemMenuWnd" == a_ButtonHandle.GetWindowName())
	{
		win = a_ButtonHandle.GetWindowName();		
	}
	else if("ExpandMenuButton" == a_ButtonHandle.GetWindowName())
	{
		win = a_ButtonHandle.GetWindowName();			
	}
	else
	{
		Debug("a_buttonHandle" @ a_ButtonHandle.GetParentWindowName());
		Num = Right(a_ButtonHandle.GetParentWindowName(), 2);
		win = menuList[menuList.Length - (int(Num) + 1)].MenuName;
	}
	Debug("win" @ win);
	switch(win)
	{
		// End:0x110
		case "SystemMenuWnd":
			clickSystemMenu();
			// End:0x150
			break;
		// End:0x136
		case "ExpandMenuButton":
			ShowHideMenus(! bExpandMenuShow);
			// End:0x150
			break;
		// End:0xFFFF
		default:
			MenuEntireWndScript.onMenuClick(win);
			// End:0x150
			break;
	}	
}

event OnEnterState(name a_CurrentStateName)
{
	Load();
	setBTN();
}

function setBTN()
{
	local string ToolTipString, BtnTex, bZoomMenu;
	local int i;

	menuList = MenuEntireWndScript.getCheckboxChecked();
	ToolTipString = MenuEntireWnd(GetScript("MenuEntireWnd")).setMainShortcutString(MenuEntireWnd(GetScript("MenuEntireWnd")).getAssignedKeyGroup(), "SystemMenuWnd");
	GetMeButton("MainMenuWnd.SystemMenuWnd").SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(193), getInstanceL2Util().White, "", false, ToolTipString, getInstanceL2Util().White, "", true));

	// End:0x11A [Loop If]
	for(i = 0; i < MAX_BUTTON_NUM; i++)
	{
		GetMeWindow("BTNWnd_" $ fillZero(i)).HideWindow();
	}

	// End:0x378 [Loop If]
	for(i = 0; i < menuList.Length; i++)
	{
		ToolTipString = MenuEntireWnd(GetScript("MenuEntireWnd")).setMainShortcutString(MenuEntireWnd(GetScript("MenuEntireWnd")).getAssignedKeyGroup(), menuList[menuList.Length - (i + 1)].MenuName);
		GetMeButton("BTNWnd_" $ fillZero(i) $ ".MenuButton").ClearTooltip();
		GetMeButton("BTNWnd_" $ fillZero(i) $ ".MenuButton").SetTooltipCustomType(MakeTooltipMultiText(menuList[menuList.Length - (i + 1)].buttonText, getInstanceL2Util().White, "", false, ToolTipString, getInstanceL2Util().White, "", true));
		BtnTex = MenuEntireWndScript.getMenuIconTexture(menuList[menuList.Length - (i + 1)].MenuName);
		GetMeButton("BTNWnd_" $ fillZero(i) $ ".MenuButton").SetTexture(BtnTex, BtnTex $ "_Down", BtnTex $ "_Over");
		GetMeWindow("BTNWnd_" $ fillZero(i)).ShowWindow();
		GetMeWindow("BTNWnd_" $ fillZero(i)).ClearAnchor();
		GetMeWindow("BTNWnd_" $ fillZero(i)).SetAnchor("", "BottomRight", "", - i * 39 - 60, -36);
	}
	// End:0x3A9
	if(menuList.Length == 0)
	{
		GetMeButton("ExpandMenuButton").HideWindow();		
	}
	else
	{
		GetMeButton("ExpandMenuButton").ShowWindow();
	}
	GetINIString("MenuEntireWnd", "b", bZoomMenu, "WindowsInfo.ini");
	ShowHideMenus(numToBool(int(bZoomMenu)));	
}

function clickSystemMenu()
{
	local string strParam;

	ParamAdd(strParam, "Name", "SystemMenuWnd");
	ParamAdd(strParam, "SystemMenuWndFocus", "1");
	ExecuteEvent(EV_ShowWindow, strParam);	
}

function ShowHideMenus(bool bShow)
{
	local int i;

	bExpandMenuShow = bShow;
	// End:0x13F
	if(bShow)
	{
		// End:0x59 [Loop If]
		for(i = 0; i < MAX_BUTTON_NUM; i++)
		{
			GetMeWindow("BTNWnd_" $ fillZero(i)).HideWindow();
		}

		// End:0xA0 [Loop If]
		for(i = 0; i < menuList.Length; i++)
		{
			GetMeWindow("BTNWnd_" $ fillZero(i)).ShowWindow();
		}
		GetMeButton("ExpandMenuButton").SetTexture("L2UI_NewTex.MenuWnd.MainMenu_-Btn_Normal", "L2UI_NewTex.MenuWnd.MainMenu_-Btn_Down", "L2UI_NewTex.MenuWnd.MainMenu_-Btn_Over");		
	}
	else
	{
		// End:0x182 [Loop If]
		for(i = 0; i < MAX_BUTTON_NUM; i++)
		{
			GetMeWindow("BTNWnd_" $ fillZero(i)).HideWindow();
		}
		GetMeButton("ExpandMenuButton").SetTexture("L2UI_NewTex.MenuWnd.MainMenu_+Btn_Normal", "L2UI_NewTex.MenuWnd.MainMenu_+Btn_Down", "L2UI_NewTex.MenuWnd.MainMenu_+Btn_Over");
	}
	SetINIString("MenuEntireWnd", "b", string(boolToNum(bShow)), "WindowsInfo.ini");	
}

function string fillZero(int Num)
{
	// End:0x19
	if(Num <= 9)
	{
		return "0" $ string(Num);
	}
	return string(Num);	
}

defaultproperties
{
}
