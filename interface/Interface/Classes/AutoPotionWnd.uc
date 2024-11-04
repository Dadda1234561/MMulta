//================================================================================
// AutoPotionWnd.
//================================================================================

class AutoPotionWnd extends UICommonAPI;

var WindowHandle Me;
var string m_WindowName;
var ShortcutWnd ShortcutWndScript;
var AutoPotionSubWnd AutoPotionSubWndScript;
var YetiPCModeChangeWnd YetiPCModeChangeWndScript;
var YetiQuickSlotWnd YetiQuickSlotwndScript;
var ButtonHandle hSettingButton;
var ButtonHandle vSettingButton;
var int currentSlotClassID;
var int currentSettingHpPercent;
var bool bActiveAutoPotionSlot;
const AutoHPPotionSlotID=157;

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
	Me = GetWindowHandle("AutoPotionWnd");
	hSettingButton = GetButtonHandle("AutoPotionWnd.AutoPotionWnd_HorWnd.HP_PotionWnd_HorWnd.setting_Btn");
	vSettingButton = GetButtonHandle("AutoPotionWnd.AutoPotionWnd_VerWnd.HP_PotionWnd_VerWnd.setting_Btn");
	ShortcutWndScript = ShortcutWnd(GetScript("ShortcutWnd"));
	AutoPotionSubWndScript = AutoPotionSubWnd(GetScript("AutoPotionSubWnd"));
	YetiQuickSlotwndScript = YetiQuickSlotWnd(GetScript("YetiQuickSlotwnd"));
	YetiPCModeChangeWndScript = YetiPCModeChangeWnd(GetScript("YetiPCModeChangeWnd"));
}

function HandleShortcutPageUpdateAll ()
{
	Class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoPotionWnd.AutoPotionWnd_HorWnd.HP_PotionSlot",AutoHPPotionSlotID);
	Class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoPotionWnd.AutoPotionWnd_VerWnd.HP_PotionSlot",AutoHPPotionSlotID);
	setPotionStateCustomTooltip();
}

function HandleShortcutClear (string param)
{
	local int nShortcutID;

	ParseInt(param,"ShortcutID",nShortcutID);
	if ( nShortcutID == AutoHPPotionSlotID )
	{
		Class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("AutoPotionWnd.AutoPotionWnd_HorWnd.HP_PotionWnd_HorWnd.HP_PotionSlot");
		Class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("AutoPotionWnd.AutoPotionWnd_VerWnd.HP_PotionWnd_VerWnd.HP_PotionSlot");
		currentSlotClassID = 0;
		setPotionStateCustomTooltip();
		bActiveAutoPotionSlot = False;
		YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
	}
}

function HandleShortcutUpdate (string param)
{
	local int nShortcutID;
	local int nClassID;

	ParseInt(param,"ShortcutID",nShortcutID);
	ParseInt(param,"ClassID",nClassID);
	if ( nShortcutID == AutoHPPotionSlotID )
	{
		currentSlotClassID = nClassID;
		Class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoPotionWnd.AutoPotionWnd_HorWnd.HP_PotionWnd_HorWnd.HP_PotionSlot",nShortcutID);
		Class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoPotionWnd.AutoPotionWnd_VerWnd.HP_PotionWnd_VerWnd.HP_PotionSlot",nShortcutID);
		setPotionStateCustomTooltip();
		if ( nClassID <= 0 )
			bActiveAutoPotionSlot = False;
		YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
		if ( nClassID > 0 )
			AutoPotionSubWndScript.ExSetSelectPostion(nClassID);
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
    Debug("----------EV_ShortcutUpdate" @ param);
    HandleShortcutUpdate(param);
    break;
    case EV_ShortcutClear:
    Debug("----------EV_ShortcutClear" @ param);
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
	windowPositionAutoMove();
    break;
    default:
  }
}

function ShortcutAutomaticUseActivatedHandler (string param)
{
	local int nShortcutID;
	local int nAutomaticUseActivated;

	ParseInt(param,"ShortcutID",nShortcutID);
	ParseInt(param,"AutomaticUseActivated",nAutomaticUseActivated);
	if ( nShortcutID == AutoHPPotionSlotID )
	{
		if ( nAutomaticUseActivated > 0 )
		{
			bActiveAutoPotionSlot = True;
		}
		else
		{
			bActiveAutoPotionSlot = False;
		}
		YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
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
		hSettingButton.SetTooltipCustomType(getUsePotionCustomTooltip());
		vSettingButton.SetTooltipCustomType(getUsePotionCustomTooltip());
	} else {
		hSettingButton.SetTooltipCustomType(getPotionDescCustomTooltip());
		vSettingButton.SetTooltipCustomType(getPotionDescCustomTooltip());
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

		default:
	}
}

function Onsetting_BtnClick ()
{
	if ( GetWindowHandle("AutoPotionSubWnd").IsShowWindow() )
	{
		GetWindowHandle("AutoPotionSubWnd").HideWindow();
	} else {
		if ( IsVertical() )
		{
			GetWindowHandle("AutoPotionSubWnd").SetAnchor(m_WindowName $ ".AutoPotionWnd_VerWnd","TopLeft","TopRight",100,0);
		} else {
			GetWindowHandle("AutoPotionSubWnd").SetAnchor(m_WindowName $ ".AutoPotionWnd_HorWnd","TopLeft","BottomLeft",15,80);
		}
		GetWindowHandle("AutoPotionSubWnd").ShowWindow();
		GetWindowHandle("AutoPotionSubWnd").SetFocus();
	}
}

function string getShortcutIndexStr ()
{
	local int nIndex;
	local string RValue;

	nIndex = ShortcutWndScript.getExpandNum();
	if ( nIndex <= 0 )
	{
		RValue = "";
	} else {
		RValue = "_" $ string(nIndex);
	}
	return RValue;
}

function bool IsVertical ()
{
	return ShortcutWndScript.IsVertical();
}

function bool isShowPetOrSummonSlot ()
{
	return numToBool(Class'UIDATA_PET'.static.GetSummonNum()) || Class'UIDATA_PET'.static.IsHavePet();
}

function int getAutoPotionSlotID ()
{
	return AutoHPPotionSlotID;
}

function windowPositionAutoMove ()
{
	local int addPosPetSlot;

	if ( GetGameStateName() != "GAMINGSTATE" )
	{
		return;
	}
	if ( YetiPCModeChangeWndScript.isYetiMode() )
	{
		GetWindowHandle("AutoPotionSubWnd").HideWindow();
		GetWindowHandle(m_WindowName $ ".AutoPotionWnd_VerWnd").HideWindow();
		GetWindowHandle(m_WindowName $ ".AutoPotionWnd_HorWnd").HideWindow();
		return;
	}
	GetWindowHandle(m_WindowName).ClearAnchor();
	GetWindowHandle(m_WindowName $ ".AutoPotionWnd_VerWnd").HideWindow();
	GetWindowHandle(m_WindowName $ ".AutoPotionWnd_HorWnd").HideWindow();
	if ( isShowPetOrSummonSlot() )
	{
		addPosPetSlot = addPosPetSlot + 100;
	}
	if ( IsVertical() )
	{
		GetWindowHandle(m_WindowName).SetAnchor("ShortcutWnd.ShortcutWndVertical" $ getShortcutIndexStr(),"TopLeft","TopRight",-1,129 + addPosPetSlot);
		GetWindowHandle(m_WindowName $ ".AutoPotionWnd_VerWnd").ShowWindow();
	} else {
		GetWindowHandle(m_WindowName).SetAnchor("ShortcutWnd.ShortcutWndHorizontal" $ getShortcutIndexStr(),"TopLeft","BottomLeft",129 + addPosPetSlot,-1);
		GetWindowHandle(m_WindowName $ ".AutoPotionWnd_HorWnd").ShowWindow();
	}
}

defaultproperties
{
	m_WindowName="AutoPotionWnd"
}
