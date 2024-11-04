class AutoPotionWndPet extends UICommonAPI;

var WindowHandle Me;
var string m_WindowName;
var string m_ParentName;
var AutoPotionSubWndPet AutoPotionSubWndPetScript;
var ButtonHandle SettingButton;
var int currentSlotClassID;
var int currentSettingHpPercent;
var bool bActiveAutoPotionSlot;
const AUTO_HP_PET_POTION_SHORTCUT_NUM= 158;

function OnRegisterEvent ()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_ShortcutUpdate);
	RegisterEvent(EV_ShortcutClear);
	RegisterEvent(EV_ShortcutAutomaticUseActivated);
	RegisterEvent(EV_AutoplaySetting);
}

function OnLoad ()
{
	SetClosingOnESC();
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	m_ParentName = Me.GetParentWindowName();
	SettingButton = GetButtonHandle(m_WindowName $ ".setting_Btn");
	AutoPotionSubWndPetScript = AutoPotionSubWndPet(GetScript(m_ParentName $ ".AutoPotionSubWndPet"));
}

function HandleShortcutPageUpdateAll ()
{
	Class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(m_WindowName $ ".HP_PotionSlot",AUTO_HP_PET_POTION_SHORTCUT_NUM);
	setPotionStateCustomTooltip();
}

function HandleShortcutClear (string param)
{
	local int nShortcutID;

	ParseInt(param,"ShortcutID",nShortcutID);
	if ( nShortcutID == AUTO_HP_PET_POTION_SHORTCUT_NUM )
	{
		Class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear(m_WindowName $ ".HP_PotionSlot");
		currentSlotClassID = 0;
		setPotionStateCustomTooltip();
		bActiveAutoPotionSlot = False;
	}
}

function HandleShortcutUpdate (string param)
{
	local int nShortcutID;
	local int nClassID;

	ParseInt(param,"ShortcutID",nShortcutID);
	ParseInt(param,"ClassID",nClassID);
	if ( nShortcutID == AUTO_HP_PET_POTION_SHORTCUT_NUM )
	{
		currentSlotClassID = nClassID;
		Class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(m_WindowName $ ".HP_PotionSlot",nShortcutID);
		setPotionStateCustomTooltip();
		if ( nClassID <= 0 )
		{
			bActiveAutoPotionSlot = False;
		}
		if ( nClassID > 0 )
		{
			AutoPotionSubWndPetScript.ExSetSelectPostion(nClassID);
		}
	}
}

function int getCurrentSlotClassID ()
{
	return currentSlotClassID;
}

function OnEvent (int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_GameStart:
			bActiveAutoPotionSlot = False;
			HandleShortcutPageUpdateAll();
			break;
		case EV_ShortcutUpdate:
			HandleShortcutUpdate(param);
			break;
		case EV_ShortcutClear:
			HandleShortcutClear(param);
			break;
		case EV_ShortcutAutomaticUseActivated:
			ShortcutAutomaticUseActivatedHandler(param);
			break;
		case EV_AutoplaySetting:
			setPotionStateCustomTooltip();
			break;
		case EV_Restart:
			currentSlotClassID = 0;
			bActiveAutoPotionSlot = False;
			break;
	}
}

function ShortcutAutomaticUseActivatedHandler (string param)
{
	local int nShortcutID;
	local int nAutomaticUseActivated;

	ParseInt(param,"ShortcutID",nShortcutID);
	if ( nShortcutID == AUTO_HP_PET_POTION_SHORTCUT_NUM )
	{
		ParseInt(param,"AutomaticUseActivated",nAutomaticUseActivated);
		bActiveAutoPotionSlot = nAutomaticUseActivated > 0;
	}
}

function bool getActiveAutoPotionSlot ()
{
	return bActiveAutoPotionSlot;
}

function setPotionStateCustomTooltip ()
{
	if ( currentSlotClassID > 0 )
	{
		SettingButton.SetTooltipCustomType(getUsePotionCustomTooltip());
	} else {
		SettingButton.SetTooltipCustomType(getPotionDescCustomTooltip());
	}
}

function CustomTooltip getUsePotionCustomTooltip ()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13008),getInstanceL2Util().BrightWhite,"",True,True);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(5292),string(currentSettingHpPercent)),getInstanceL2Util().DRed,"",True,True);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function CustomTooltip getPotionDescCustomTooltip ()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13008),getInstanceL2Util().BrightWhite,"",True,True);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemMessage(5291),getInstanceL2Util().ColorDesc,"",True,False);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "setting_Btn":
			Onsetting_BtnClick();
			break;
	}
}

function Onsetting_BtnClick ()
{
	if ( AutoPotionSubWndPetScript.Me.IsShowWindow() )
	{
		AutoPotionSubWndPetScript.Me.HideWindow();
	} else {
		AutoPotionSubWndPetScript.Me.ShowWindow();
		AutoPotionSubWndPetScript.Me.SetFocus();
	}
}

function int getAutoPotionSlotIDPet ()
{
	return AUTO_HP_PET_POTION_SHORTCUT_NUM;
}

defaultproperties
{
}
