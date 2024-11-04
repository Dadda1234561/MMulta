//================================================================================
// RankingWnd.
//================================================================================

class RankingWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle characterRankingWnd;
var WindowHandle olympiadRankingWnd;
var WindowHandle pvpRankingWnd;
var WindowHandle petRankingWnd;
var WindowHandle clanRankingWnd;
var WindowHandle combatPowerRankingWnd;

var ButtonHandle RankingTab1Button;
var ButtonHandle RankingTab2Button;
var ButtonHandle RankingTab3Button;
var ButtonHandle RankingTab4Button;
var ButtonHandle RankingTab5Button;
var ButtonHandle RankingTab6Button;

var int currentTabIndex;

var int TOTAL_TABS;


function OnRegisterEvent ()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_Restart);
}

function OnLoad ()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize ()
{
	Me = GetWindowHandle("RankingWnd");
	RankingTab1Button = GetButtonHandle("RankingWnd.RankingTab1Button");
	RankingTab2Button = GetButtonHandle("RankingWnd.RankingTab2Button");
	RankingTab3Button = GetButtonHandle("RankingWnd.RankingTab3Button");
	RankingTab4Button = GetButtonHandle("RankingWnd.RankingTab4Button");
	RankingTab5Button = GetButtonHandle("RankingWnd.RankingTab5Button");
	RankingTab6Button = GetButtonHandle("RankingWnd.RankingTab6Button");
	TOTAL_TABS = 6;
	characterRankingWnd = GetWindowHandle("RankingWnd.RankingWnd_Character");
	olympiadRankingWnd = GetWindowHandle("RankingWnd.RankingWnd_Olympiad");
	pvpRankingWnd = GetWindowHandle("RankingWnd.RankingWnd_Pvp");
	petRankingWnd = GetWindowHandle("RankingWnd.RankingWnd_Pet");
	clanRankingWnd = GetWindowHandle("RankingWnd.RankingWnd_Clan");
	combatPowerRankingWnd = GetWindowHandle("RankingWnd.RankingWnd_CombatPower");
	setLikeRadioButton("RankingTab1Button");
}

function ShowRankging()
{
	Me.ShowWindow();
	setLikeRadioButton("RankingTab2Button");
	OnClickButton("RankingTab2Button");
}

function OnShow()
{
	// End:0x38
	if(getInstanceUIData().getIsLiveServer())
	{
		// End:0x38
		if(IsPlayerOnWorldRaidServer())
		{
			AddSystemMessage(4047);
			Me.HideWindow();
			return;
		}
	}
	settingTabButton();
	tabDisable(false);
	
	if(currentTabIndex == 0)
	{
		characterRankingWnd.ShowWindow();
		if(characterRankingWnd.IsShowWindow())
		{
			RankingWnd_Character(GetScript("RankingWnd.RankingWnd_Character")).OnShow();
		}
	}
	else if(currentTabIndex == 1)
	{
		olympiadRankingWnd.ShowWindow();
		if(olympiadRankingWnd.IsShowWindow())
		{
			RankingWnd_Olympiad(GetScript("RankingWnd.RankingWnd_Olympiad")).OnShow();
		}
	}
	else if(currentTabIndex == 2)
	{
		pvpRankingWnd.ShowWindow();
		if(pvpRankingWnd.IsShowWindow())
		{
			RankingWnd_Pvp(GetScript("RankingWnd.RankingWnd_Pvp")).OnShow();
		}
	}
	else if(currentTabIndex == 3)
	{
		petRankingWnd.ShowWindow();
		if(petRankingWnd.IsShowWindow())
		{
			RankingWnd_Pet(GetScript("RankingWnd.RankingWnd_Pet")).OnShow();
		}
	}
	else if(currentTabIndex == 4)
	{
		clanRankingWnd.ShowWindow();
		if(clanRankingWnd.IsShowWindow())
		{
			RankingWnd_Clan(GetScript("RankingWnd.RankingWnd_Clan")).OnShow();
		}
	}
	else if(currentTabIndex == 5)
	{
		combatPowerRankingWnd.ShowWindow();
		if(combatPowerRankingWnd.IsShowWindow())
		{
			RankingWnd_CombatPower(GetScript("RankingWnd.RankingWnd_InstanceZone")).OnShow();
		}
	}

	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), true);
}

function OnEvent(int a_EventID, string param)
{
	// End:0x28
	if(a_EventID == EV_Restart)
	{
		setLikeRadioButton("RankingTab1Button");
	}
}

function settingTabButton()
{
	local Rect rectWnd;

	// End:0x393
	if(getInstanceUIData().getIsClassicServer())
	{
		// End:0x20B
		if(IsAdenServer())
		{
			if(IsPlayerOnWorldRaidServer())
			{
				RankingTab1Button.ShowWindow();
				RankingTab2Button.HideWindow();
				RankingTab3Button.ShowWindow();
				RankingTab4Button.HideWindow();
				RankingTab5Button.HideWindow();
				RankingTab6Button.HideWindow();
				rectWnd = Me.GetRect();
				RankingTab3Button.MoveTo(rectWnd.nX + 124, rectWnd.nY + 35);
				GetTextureHandle("RankingWnd.RankingTabLineBg").HideWindow();
				GetTextureHandle("RankingWnd.RankingTabLine2Bg").ShowWindow();
				GetTextureHandle("RankingWnd.RankingTabLine3Bg").HideWindow();
				GetTextureHandle("RankingWnd.RankingTabLine4Bg").HideWindow();
				GetTextureHandle("RankingWnd.RankingTabLine5Bg").HideWindow();
				GetTextureHandle("RankingWnd.RankingWnd_Character.TabBlindBG_Wnd").HideWindow();
				return;
			}
			RankingTab1Button.ShowWindow();
			RankingTab2Button.ShowWindow();
			RankingTab3Button.ShowWindow();
			RankingTab4Button.ShowWindow();
			RankingTab5Button.ShowWindow();
			RankingTab2Button.SetButtonName(13208);
			GetTextureHandle("RankingWnd.RankingTabLineBg").HideWindow();
			GetTextureHandle("RankingWnd.RankingTabLine2Bg").HideWindow();
			GetTextureHandle("RankingWnd.RankingTabLine3Bg").HideWindow();
			GetTextureHandle("RankingWnd.RankingTabLine4Bg").ShowWindow();
			GetTextureHandle("RankingWnd.RankingTabLine5Bg").ShowWindow();
			GetTextureHandle("RankingWnd.RankingWnd_Character.TabBlindBG_Wnd").HideWindow();
			rectWnd = Me.GetRect();
			RankingTab3Button.MoveTo(rectWnd.nX + 238, rectWnd.nY + 35);
		}
		else
		{
			RankingTab1Button.ShowWindow();
			RankingTab2Button.ShowWindow();
			RankingTab3Button.ShowWindow();
			RankingTab4Button.HideWindow();
			RankingTab5Button.ShowWindow();
			RankingTab6Button.HideWindow();
			GetTextureHandle("RankingWnd.RankingTabLineBg").HideWindow();
			GetTextureHandle("RankingWnd.RankingTabLine2Bg").HideWindow();
			GetTextureHandle("RankingWnd.RankingTabLine3Bg").ShowWindow();
			GetTextureHandle("RankingWnd.RankingTabLine4Bg").HideWindow();
			GetTextureHandle("RankingWnd.RankingTabLine5Bg").HideWindow();
			GetTextureHandle("RankingWnd.RankingWnd_Character.TabBlindBG_Wnd").HideWindow();
			rectWnd = Me.GetRect();
			RankingTab5Button.MoveTo(rectWnd.nX + 352, rectWnd.nY + 35);
		}		
	}
	else
	{
		GetTextureHandle("RankingWnd.RankingTabLineBg").ShowWindow();
		GetTextureHandle("RankingWnd.RankingTabLine2Bg").ShowWindow();
		GetTextureHandle("RankingWnd.RankingTabLine3Bg").ShowWindow();
		GetTextureHandle("RankingWnd.RankingTabLine4Bg").ShowWindow();
		GetTextureHandle("RankingWnd.RankingTabLine5Bg").ShowWindow();
		GetTextureHandle("RankingWnd.RankingWnd_Character.TabBlindBG_Wnd").HideWindow();
		RankingTab1Button.ShowWindow();
		RankingTab2Button.ShowWindow();
		RankingTab3Button.HideWindow();
		RankingTab4Button.HideWindow();
		RankingTab5Button.HideWindow();
		RankingTab6Button.ShowWindow();
	}
}


function setLikeRadioButton(string buttonName)
{
	if(buttonName == "RankingTab1Button")
	{
		RankingTab1Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected");
		RankingTab2Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab3Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab4Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab5Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab6Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		currentTabIndex = 0;
	}
	else if(buttonName == "RankingTab2Button")
	{
		RankingTab1Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab2Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected");
		RankingTab3Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab4Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab5Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab6Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		currentTabIndex = 1;			
	}
	else if(buttonName == "RankingTab3Button")
	{
		RankingTab1Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab2Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab3Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected");
		RankingTab4Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab5Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab6Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		currentTabIndex = 2;				
	}
	else if(buttonName == "RankingTab4Button")
	{
		RankingTab1Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab2Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab3Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab4Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected");
		RankingTab5Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab6Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		currentTabIndex = 3;					
	}
	else if(buttonName == "RankingTab5Button")
	{
		RankingTab1Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab2Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab3Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab4Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab5Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected");
		RankingTab6Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		currentTabIndex = 4;
	}
	else if(buttonName == "RankingTab6Button")
	{
		RankingTab1Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab2Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab3Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab4Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab5Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Unselected_Over");
		RankingTab6Button.SetTexture("L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected", "L2UI_CT1.Tab.Tab_DF_Tab_Selected");
		currentTabIndex = 5;
	}
}

function tabDisable(bool bisDisable)
{
	// End:0x57
	if(bisDisable)
	{
		RankingTab1Button.DisableWindow();
		RankingTab2Button.DisableWindow();
		RankingTab3Button.DisableWindow();
		RankingTab4Button.DisableWindow();
		RankingTab5Button.DisableWindow();		
		RankingTab6Button.DisableWindow();		
	}
	else
	{
		RankingTab1Button.EnableWindow();
		RankingTab2Button.EnableWindow();
		RankingTab3Button.EnableWindow();
		RankingTab4Button.EnableWindow();
		RankingTab5Button.EnableWindow();
		RankingTab6Button.EnableWindow();
	}
}

function OnClickButton(string btn)
{
	local int i;
	local string WindowName;
	uDebug("Btn" @ btn);
	setLikeRadioButton(btn);
	if(btn == "RankingTab1Button")
	{
		ShowWindow("RankingWnd.RankingWnd_Character");
		HideWindow("RankingWnd.RankingWnd_Olympiad");
		HideWindow("RankingWnd.RankingWnd_Pet");
		HideWindow("RankingWnd.RankingWnd_Pvp");
		HideWindow("RankingWnd.RankingWnd_Clan");
		HideWindow("RankingWnd.RankingWnd_CombatPower");
	}
	else if(btn == "RankingTab2Button")
	{
		HideWindow("RankingWnd.RankingWnd_Character");
		ShowWindow("RankingWnd.RankingWnd_Olympiad");
		HideWindow("RankingWnd.RankingWnd_Pvp");
		HideWindow("RankingWnd.RankingWnd_Pet");
		HideWindow("RankingWnd.RankingWnd_Clan");
		HideWindow("RankingWnd.RankingWnd_CombatPower");
	}
	else if(btn == "RankingTab3Button")
	{
		HideWindow("RankingWnd.RankingWnd_Character");
		HideWindow("RankingWnd.RankingWnd_Olympiad");
		ShowWindow("RankingWnd.RankingWnd_Pvp");
		HideWindow("RankingWnd.RankingWnd_Pet");
		HideWindow("RankingWnd.RankingWnd_Clan");
		HideWindow("RankingWnd.RankingWnd_CombatPower");
	}
	else if(btn == "RankingTab4Button")
	{
		HideWindow("RankingWnd.RankingWnd_Character");
		HideWindow("RankingWnd.RankingWnd_Olympiad");
		HideWindow("RankingWnd.RankingWnd_Pvp");
		ShowWindow("RankingWnd.RankingWnd_Pet");
		HideWindow("RankingWnd.RankingWnd_Clan");
		HideWindow("RankingWnd.RankingWnd_CombatPower");
	}
	else if(btn == "RankingTab5Button")
	{
		HideWindow("RankingWnd.RankingWnd_Character");
		HideWindow("RankingWnd.RankingWnd_Olympiad");
		HideWindow("RankingWnd.RankingWnd_Pvp");
		HideWindow("RankingWnd.RankingWnd_Pet");
		ShowWindow("RankingWnd.RankingWnd_Clan");
		HideWindow("RankingWnd.RankingWnd_CombatPower");
	}
	else if(btn == "RankingTab6Button")
	{
		HideWindow("RankingWnd.RankingWnd_Character");
		HideWindow("RankingWnd.RankingWnd_Olympiad");
		HideWindow("RankingWnd.RankingWnd_Pvp");
		HideWindow("RankingWnd.RankingWnd_Pet");
		HideWindow("RankingWnd.RankingWnd_Clan");
		ShowWindow("RankingWnd.RankingWnd_CombatPower");
	}
}

function OnHide()
{
	RankingWnd_Character(GetScript("RankingWnd.RankingWnd_Character")).OnHide();
	RankingWnd_Olympiad(GetScript("RankingWnd.RankingWnd_Olympiad")).OnHide();
	RankingWnd_Pvp(GetScript("RankingWnd.RankingWnd_Pvp")).OnHide();
	RankingWnd_Pet(GetScript("RankingWnd.RankingWnd_Pet")).OnHide();
	RankingWnd_Clan(GetScript("RankingWnd.RankingWnd_Clan")).OnHide();
	RankingWnd_Clan(GetScript("RankingWnd.RankingWnd_CombatPower")).OnHide();
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), false);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
