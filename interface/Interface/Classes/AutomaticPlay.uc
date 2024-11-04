//================================================================================
// AutomaticPlay.
//================================================================================

class AutomaticPlay extends UICommonAPI
	dependson(YetiQuickSlotWnd);

var WindowHandle Me;
var WindowHandle AutoTargetWnd;
var TextBoxHandle AutoTargetTitle_text;
var AnimTextureHandle AutoTargetAllON_ToggleEffect_Anim;
var AnimTextureHandle AutoTargetAllON_ToggleEffect_Anim2;
var ButtonHandle WinMinBTN;
var TextureHandle AutoCircleFrameExpand;
var TextureHandle LineBG;
var ButtonHandle TargetNext_BTN;
var ButtonHandle TargetSwap_BTN;
var ButtonHandle TargetPickupToggle_BTN;
var ButtonHandle TargetMannerToggle_BTN;
var ButtonHandle Combat_BTN;
var WindowHandle AutoTargetAllON_Win;
var WindowHandle AutoTargetAllOFF_Win;
var ButtonHandle AutoTargetAll_BTN;
var bool autotarget_bShortTarget;
var bool autotarget_bUseAutoTarget;
var bool autotarget_bIsPickupOn;
var EAutoNextTargetMode autotarget_nTargetMode;
var int autotarget_nHPPotionPercent;
var bool autotarget_bIsMannerModeOn;
var bool bActivateAll;
var int nCombatOnOff;
var int autotarget_nHPPetPotionPercent;
var YetiQuickSlotWnd YetiQuickSlotwndScript;
var Rect rectWndLDowned;

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_AutoplaySetting);
	RegisterEvent(EV_NextTargetModeChange);
	RegisterEvent(EV_OptionHasApplied);
	RegisterEvent(EV_CounterAttack);
	RegisterEvent(EV_ToggleCombatMode);
}

function OnLoad()
{
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle("AutomaticPlay");
	AutoTargetWnd = GetWindowHandle("AutomaticPlay.AutoTargetWnd");
	AutoTargetTitle_text = GetTextBoxHandle("AutomaticPlay.AutoTargetWnd.AutoTargetTitle_text");
	AutoTargetAllON_ToggleEffect_Anim = GetAnimTextureHandle("AutomaticPlay.AutoTargetWnd.AutoTargetAllON_Win.ToggleEffect_Anim");
	AutoTargetAllON_ToggleEffect_Anim2 = GetAnimTextureHandle("AutomaticPlay.AutoTargetWnd.AutoTargetAllON_Win.AutoAllArrowOn_texture");
	AutoTargetAllON_Win = GetWindowHandle("AutomaticPlay.AutoTargetWnd.AutoTargetAllON_Win");
	WinMinBTN = GetButtonHandle("AutomaticPlay.WinMinBTN");
	LineBG = GetTextureHandle("AutomaticPlay.LineBgTex");
	AutoCircleFrameExpand = GetTextureHandle("AutomaticPlay.AutoTargetWnd.AutoCircleFrameExpand");
	TargetNext_BTN = GetButtonHandle("AutomaticPlay.AutoTargetWnd.TargetNext_BTN");
	TargetSwap_BTN = GetButtonHandle("AutomaticPlay.AutoTargetWnd.TargetSwap_BTN");
	TargetPickupToggle_BTN = GetButtonHandle("AutomaticPlay.AutoTargetWnd.TargetPickupToggle_BTN");
	TargetMannerToggle_BTN = GetButtonHandle("AutomaticPlay.AutoTargetWnd.TargetMannerToggle_BTN");
	AutoTargetAllOFF_Win = GetWindowHandle("AutomaticPlay.AutoTargetWnd.AutoTargetAllOFF_Win");
	AutoTargetAll_BTN = GetButtonHandle("AutomaticPlay.AutoTargetWnd.AutoTargetAll_BTN");
	Combat_BTN = GetButtonHandle("AutomaticPlay.AutoTargetWnd.Combat_BTN");
	setCombatTooltip();
	Autotarget_updateCombatButton();
	YetiQuickSlotwndScript = YetiQuickSlotWnd(GetScript("YetiQuickSlotwnd"));
	WinMinBTN.SetButtonValue(0);
}

function OnShow()
{
	if(getInstanceUIData().getIsLiveServer())
	{
		Me.HideWindow();
		return;
	}
	OptionIniLoad();
	updateElements();
}

function updateElements()
{
	Autotarget_UpdateAutoTargetState();
	Autotarget_updateSwapTargetButton();
	Autotarget_SwapTargetSetCusomTooltip();
	Autotarget_updatePickupButton();
	Autotarget_PickupSetCusomTooltip();
	Autotarget_updateMannerModeButton();
	Autotarget_MannerModeSetCusomTooltip();
	Autotarget_updateNextTargetButton();
	Autotarget_NextTargetSetCusomTooltip();
}

function OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().getIsLiveServer())
	{
		return;
	}

	switch(Event_ID)
	{
		case EV_GameStart:
			initAll();
			break;
		case EV_Restart:
			bActivateAll = false;
			nCombatOnOff = 0;
			setCombatTooltip();
			Autotarget_updateCombatButton();
			Autotarget_Init();
			break;
		case EV_AutoplaySetting:
			AutoplaySettingHandler(param);
			break;
		case EV_NextTargetModeChange:
		case EV_OptionHasApplied:
			NextTargetModeHandler();
			break;
		case EV_CounterAttack:
			if(autotarget_bUseAutoTarget)
			{
				requestAutoPlay(false);
			}
			break;
		case EV_ToggleCombatMode:
			ParseInt(param, "OnOff", nCombatOnOff);
			setCombatTooltip();
			Autotarget_updateCombatButton();
			break;
	}
}

function setCombatTooltip()
{
	local array<DrawItemInfo> drawListArr;

	if(nCombatOnOff > 0)
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13263), getInstanceL2Util().PKNameColor, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13264), getInstanceL2Util().White, "", true, true);
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13263), getInstanceL2Util().White, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13264), getInstanceL2Util().PKNameColor, "", true, true);
	}
	Combat_BTN.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function initAll()
{
	Me.ShowWindow();
	bActivateAll = false;
	YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
}

function NextTargetModeHandler()
{
	local EAutoNextTargetMode nTargetMode;

	nTargetMode = GetNextTargetModeOption();

	if(autotarget_nTargetMode != nTargetMode)
	{
		if(autotarget_bUseAutoTarget)
		{
			requestAutoPlay(autotarget_bUseAutoTarget);
		}
	}
	Autotarget_NextTargetSetCusomTooltip();
}

function AutoplaySettingHandler(string param)
{
	local int nIsAutoPlayOn;
	local int nNextTargetMode;
	local int nIsNearTargetMode;
	local int nIsPickupOn;
	local int nHPPotionPercent;
	local int nIsMannerModeOn;
	local int nHPPetPotionPercent;

	ParseInt(param, "IsPickupOn", nIsPickupOn);
	ParseInt(param, "IsAutoPlayOn", nIsAutoPlayOn);
	ParseInt(param, "NextTargetMode", nNextTargetMode);
	ParseInt(param, "IsNearTargetMode", nIsNearTargetMode);
	ParseInt(param, "HPPotionPercent", nHPPotionPercent);
	ParseInt(param, "HPPetPotionPercent", nHPPetPotionPercent);
	ParseInt(param, "IsMannerModeOn", nIsMannerModeOn);
	autotarget_bUseAutoTarget = numToBool(nIsAutoPlayOn);
	autotarget_bShortTarget = numToBool(nIsNearTargetMode);
	autotarget_bIsPickupOn = numToBool(nIsPickupOn);
	autotarget_bIsMannerModeOn = numToBool(nIsMannerModeOn);
	autotarget_nHPPotionPercent = nHPPotionPercent;
	autotarget_nHPPetPotionPercent = nHPPetPotionPercent;
	updateElements();
}

function bool getActivateAll()
{
	return bActivateAll;
}

function OnClickButton(string Name)
{
	local int Value;

	if(CheckDrag())
	{
		return;
	}

	switch(Name)
	{
		case "WinMinBTN":
			Value = WinMinBTN.GetButtonValue();
			WinMinMax(Value);
			break;
		case "AutoAll_BTN":
			class'ShortcutWndAPI'.static.RequestAutomaticUseItemActivateAll(!bActivateAll);
			break;
		case "TargetSwap_BTN":
			Autotarget_OnSwap_Target_BTNClick();
			requestAutoPlay(autotarget_bUseAutoTarget);
			break;
		case "TargetPickupToggle_BTN":
			Autotarget_TargetPickupToggle_BTNClick();
			requestAutoPlay(autotarget_bUseAutoTarget);
			break;
		case "TargetMannerToggle_BTN":
			Autotarget_TargetMannerToggle_BTNClick();
			requestAutoPlay(autotarget_bUseAutoTarget);
			break;
		case "AutoTargetAll_BTN":
			requestAutoPlay(!autotarget_bUseAutoTarget);
			break;
		case "Combat_BTN":
			ExecuteCommand("/combatmode");
			break;
		case "TargetNext_BTN":
			Autotarget_OnNext_Target_BTNClick();
			break;
	}
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if("AutoAll_BTN" == a_WindowHandle.GetWindowName())
	{
		OnClickButton(a_WindowHandle.GetWindowName());
	}
}

function bool CheckDrag()
{
	local Rect rectWnd;

	rectWnd = Me.GetRect();
	return GetAbs(rectWndLDowned.nX - rectWnd.nX) > 5 || GetAbs(rectWndLDowned.nY - rectWnd.nY) > 5;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	rectWndLDowned = Me.GetRect();
}

function OptionIniLoad()
{
	local int nLongTarget, nIsPickupOn, nIsMannerModeOn;

	if(!GetINIBool("AutomaticPlay", "e", nIsPickupOn, "windowsInfo.ini"))
	{
		nIsPickupOn = 1;
		SetINIBool("AutomaticPlay", "e", numToBool(nIsPickupOn), "windowsInfo.ini");
	}
	if(!GetINIBool("AutomaticPlay", "a", nLongTarget, "windowsInfo.ini"))
	{
		nLongTarget = 1;
		SetINIBool("AutomaticPlay", "a", numToBool(nLongTarget), "windowsInfo.ini");
	}
	if(!GetINIBool("AutomaticPlay", "p", nIsMannerModeOn, "windowsInfo.ini"))
	{
		nIsMannerModeOn = 1;
		SetINIBool("AutomaticPlay", "p", numToBool(nIsMannerModeOn), "windowsInfo.ini");
	}
	autotarget_bIsPickupOn = numToBool(nIsPickupOn);
	autotarget_bShortTarget = !numToBool(nLongTarget);
	autotarget_bIsMannerModeOn = numToBool(nIsMannerModeOn);
}

function Autotarget_Init()
{
	autotarget_bUseAutoTarget = false;
}

function executeTarget()
{
	if(autotarget_bShortTarget)
	{
		ExecuteCommand("/targetnext");
	}
	else
	{
		ExecuteCommand("/targetnext2");
	}
}

function setShortcutTooltip(string tooltipStr)
{
	AutoTargetAll_BTN.SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(2165), getInstanceL2Util().White,, true, tooltipStr, getInstanceL2Util().BWhite,, true));
}

function Autotarget_SwapTargetSetCusomTooltip()
{
	local Color b0, b1;
	local array<DrawItemInfo> drawListArr;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;

	if(autotarget_bShortTarget)
	{
		b0 = getInstanceL2Util().Yellow;
	}
	else
	{
		b1 = getInstanceL2Util().Yellow;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3956), b0, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3957), b1, "", true, true);
	TargetSwap_BTN.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function Autotarget_PickupSetCusomTooltip()
{
	local Color b0, b1;
	local array<DrawItemInfo> drawListArr;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;
	TargetPickupToggle_BTN.ClearTooltip();
	TargetPickupToggle_BTN.SetTooltipType("text");

	if(autotarget_bIsPickupOn)
	{
		b0 = getInstanceL2Util().Yellow;
	}
	else
	{
		b1 = getInstanceL2Util().Yellow;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3993), b0, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3992), b1, "", true, true);
	TargetPickupToggle_BTN.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function Autotarget_MannerModeSetCusomTooltip()
{
	local Color b0, b1;
	local array<DrawItemInfo> drawListArr;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;
	TargetMannerToggle_BTN.ClearTooltip();
	TargetMannerToggle_BTN.SetTooltipType("text");

	if(autotarget_bIsMannerModeOn)
	{
		b0 = getInstanceL2Util().Yellow;
	}
	else
	{
		b1 = getInstanceL2Util().Yellow;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13080), b0, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13081), b1, "", true, true);
	TargetMannerToggle_BTN.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function Autotarget_NextTargetSetCusomTooltip()
{
	local int N;
	local Color b0, b1, b2, b3, b4;

	local array<DrawItemInfo> drawListArr;
	local string toolString;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;
	b2 = getInstanceL2Util().Gray;
	b3 = getInstanceL2Util().Gray;
	b4 = getInstanceL2Util().Gray;
	TargetNext_BTN.ClearTooltip();
	TargetNext_BTN.SetTooltipType("text");
	N = GetOptionInt("Communication", "NextTargetModeClassic");

	if(N == 0)
	{
		TargetNext_BTN.SetTexture("L2UI_NewTex.AutomaticPlay.L2UI_NewTex.AutomaticPlay.TargetBTN_threat", "L2UI_NewTex.AutomaticPlay.TargetBTN_threat_Over", "L2UI_NewTex.AutomaticPlay.TargetBTN_threat_Down");
		b0 = getInstanceL2Util().Yellow;
	}
	else if(N == 1)
	{
		TargetNext_BTN.SetTexture("L2UI_NewTex.AutomaticPlay.TargetBTN_Next_Normal", "L2UI_NewTex.AutomaticPlay.TargetBTN_Next_Over", "L2UI_NewTex.AutomaticPlay.TargetBTN_Next_Normal");
		b2 = getInstanceL2Util().Yellow;
	}
	else if(N == 2)
	{
		TargetNext_BTN.SetTexture("L2UI_NewTex.AutomaticPlay.TargetBTN_pc", "L2UI_NewTex.AutomaticPlay.TargetBTN_pc_Over", "L2UI_NewTex.AutomaticPlay.TargetBTN_pc_Down");
		b3 = getInstanceL2Util().Yellow;
	}
	else if(N == 3)
	{
		TargetNext_BTN.SetTexture("L2UI_NewTex.AutomaticPlay.TargetBTN_Next_Normal", "L2UI_NewTex.AutomaticPlay.TargetBTN_Next_Over", "L2UI_NewTex.AutomaticPlay.TargetBTN_Next_Normal");
		b4 = getInstanceL2Util().Yellow;
	}
	else if(N == 4)
	{
		TargetNext_BTN.SetTexture("L2UI_NewTex.AutomaticPlay.L2UI_NewTex.AutomaticPlay.TargetBTN_threat", "L2UI_NewTex.AutomaticPlay.TargetBTN_threat_Over", "L2UI_NewTex.AutomaticPlay.TargetBTN_threat_Down");
		b1 = getInstanceL2Util().Yellow;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3862), b0, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13732), b1, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3863), b2, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3864), b3, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3865), b4, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	toolString = MenuEntireWnd(GetScript("MenuEntireWnd")).setMainShortcutString(MenuEntireWnd(GetScript("MenuEntireWnd")).getAssignedKeyGroup(), "NextTargetModeChange");
	drawListArr[drawListArr.Length] = addDrawItemText(toolString, getInstanceL2Util().White, "", true, true);
	TargetNext_BTN.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle.GetWindowName())
	{
		case "AutoTargetAll_BTN":
		case "MacroShortcutItem":
			requestAutoPlay(!autotarget_bUseAutoTarget);
			break;
	}
}

function bool getUseAutoTarget()
{
	return autotarget_bUseAutoTarget;
}

function Autotarget_OnNext_Target_BTNClick()
{
	local string strParam;
	local int targetMode;

	strParam = "";
	switch(GetOptionInt("CommunIcation", "NextTargetModeClassic"))
	{
		case 0:
			targetMode = 4;
			break;
		case 1:
			targetMode = 2;
			break;
		case 2:
			targetMode = 3;
			break;
		case 3:
			targetMode = 0;
			break;
		case 4:
			targetMode = 1;
			break;
	}
	SetOptionInt("Communication", "NextTargetModeClassic", targetMode);
	ParamAdd(strParam, "NextTargetMode", string(targetMode));
	ExecuteEvent(EV_NextTargetModeChange, strParam);
	Autotarget_NextTargetSetCusomTooltip();
	Autotarget_updateNextTargetButton();
}

function Autotarget_OnSwap_Target_BTNClick()
{
	autotarget_bShortTarget = !autotarget_bShortTarget;
	SetINIBool("AutomaticPlay", "a", !autotarget_bShortTarget, "windowsInfo.ini");
	if(autotarget_bShortTarget)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(3956));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(3957));
	}
	Autotarget_SwapTargetSetCusomTooltip();
	Autotarget_updateSwapTargetButton();
}

function Autotarget_TargetMannerToggle_BTNClick()
{
	autotarget_bIsMannerModeOn = !autotarget_bIsMannerModeOn;
	SetINIBool("AutomaticPlay", "p", autotarget_bIsMannerModeOn, "windowsInfo.ini");
	if(autotarget_bIsMannerModeOn)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(13080));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(13081));
	}
	Autotarget_updateMannerModeButton();
	Autotarget_MannerModeSetCusomTooltip();
}

function Autotarget_TargetPickupToggle_BTNClick()
{
	autotarget_bIsPickupOn = !autotarget_bIsPickupOn;
	SetINIBool("AutomaticPlay", "e", autotarget_bIsPickupOn, "windowsInfo.ini");

	if(autotarget_bIsPickupOn)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(3993));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(3992));
	}
	Autotarget_updatePickupButton();
	Autotarget_PickupSetCusomTooltip();
}

function Autotarget_updateSwapTargetButton()
{
	if(autotarget_bShortTarget)
	{
		TargetSwap_BTN.SetTexture("L2UI_NewTex.AutomaticPlay.TargetBTN_ShotD_Normal", "L2UI_NewTex.AutomaticPlay.TargetBTN_ShotD_Normal", "L2UI_NewTex.AutomaticPlay.TargetBTN_ShotD_Over");
	}
	else
	{
		TargetSwap_BTN.SetTexture("L2UI_NewTex.AutomaticPlay.TargetBTN_LongD_Normal", "L2UI_NewTex.AutomaticPlay.TargetBTN_LongD_Normal", "L2UI_NewTex.AutomaticPlay.TargetBTN_LongD_Over");
	}
}

function Autotarget_updateNextTargetButton();

function Autotarget_updatePickupButton()
{
	if(autotarget_bIsPickupOn)
	{
		TargetPickupToggle_BTN.SetTexture("L2UI_NewTex.AutomaticPlay.GetBTNON_Normal", "L2UI_NewTex.AutomaticPlay.GetBTNON_Normal", "L2UI_NewTex.AutomaticPlay.GetBTNON_Over");
	}
	else
	{
		TargetPickupToggle_BTN.SetTexture("L2UI_NewTex.AutomaticPlay.GetBTNOff_Normal", "L2UI_NewTex.AutomaticPlay.GetBTNOff_Normal", "L2UI_NewTex.AutomaticPlay.GetBTNOff_Over");
	}
}

function Autotarget_updateMannerModeButton()
{
	if(autotarget_bIsMannerModeOn)
	{
		TargetMannerToggle_BTN.SetTexture("L2UI_NewTex.AutomaticPlay.MannerBTNON_Normal", "L2UI_NewTex.AutomaticPlay.MannerBTNON_Normal", "L2UI_NewTex.AutomaticPlay.MannerBTNON_over");
	}
	else
	{
		TargetMannerToggle_BTN.SetTexture("L2UI_NewTex.AutomaticPlay.MannerBTNOff_Normal", "L2UI_NewTex.AutomaticPlay.MannerBTNOff_Normal", "L2UI_NewTex.AutomaticPlay.MannerBTNOff_over");
	}
}

function Autotarget_updateCombatButton()
{
	if(nCombatOnOff > 0)
	{
		Combat_BTN.SetTexture("L2UI_NewTex.AutomaticPlay.CombatBTNON_Normal", "L2UI_NewTex.AutomaticPlay.CombatBTNON_Normal", "L2UI_NewTex.AutomaticPlay.CombatBTNON_Over");		
	}
	else
	{
		Combat_BTN.SetTexture("L2UI_NewTex.AutomaticPlay.CombatBTNOff_Normal", "L2UI_NewTex.AutomaticPlay.CombatBTNOff_Normal", "L2UI_NewTex.AutomaticPlay.CombatBTNOff_Over");
	}
}

function Autotarget_UpdateAutoTargetState()
{
	if(autotarget_bUseAutoTarget)
	{
		AnimTexturePlay(AutoTargetAllON_ToggleEffect_Anim, true);
		AnimTexturePlay(AutoTargetAllON_ToggleEffect_Anim2, true);
		GetWindowHandle("AutomaticPlay.AutoTargetWnd.AutoTargetAllON_Win").ShowWindow();
		GetWindowHandle("AutomaticPlay.AutoTargetWnd.AutoTargetAllOFF_Win").HideWindow();
	}
	else
	{
		AnimTextureStop(AutoTargetAllON_ToggleEffect_Anim, true);
		AnimTextureStop(AutoTargetAllON_ToggleEffect_Anim2, true);
		GetWindowHandle("AutomaticPlay.AutoTargetWnd.AutoTargetAllON_Win").HideWindow();
		GetWindowHandle("AutomaticPlay.AutoTargetWnd.AutoTargetAllOFF_Win").ShowWindow();
	}
	YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
}

function requestAutoPlay(bool bUseAutoTarget, optional int nHPPotionPercent, optional int nHPPetPotionPercent)
{
	local AutoplaySettingData pAutoplaySettingData;

	autotarget_nTargetMode = GetNextTargetModeOption();
	pAutoplaySettingData.IsAutoPlayOn = bUseAutoTarget;
	pAutoplaySettingData.IsPickupOn = autotarget_bIsPickupOn;
	pAutoplaySettingData.NextTargetMode = autotarget_nTargetMode;
	pAutoplaySettingData.IsNearTargetMode = autotarget_bShortTarget;
	pAutoplaySettingData.IsMannerModeOn = autotarget_bIsMannerModeOn;

	if(nHPPotionPercent > 0)
	{
		pAutoplaySettingData.HPPotionPercent = nHPPotionPercent;
	}
	else
	{
		pAutoplaySettingData.HPPotionPercent = autotarget_nHPPotionPercent;
	}

	if(nHPPetPotionPercent > 0)
	{
		pAutoplaySettingData.HPPetPotionPercent = nHPPetPotionPercent;
	}
	else
	{
		pAutoplaySettingData.HPPetPotionPercent = autotarget_nHPPetPotionPercent;
	}

	UpdateAutoplaySetting(pAutoplaySettingData);
}

function requestAutoPlayForAutoPotion(int nHPPotionPercent)
{
	requestAutoPlay(autotarget_bUseAutoTarget, nHPPotionPercent);
}

function requestAutoPlayForAutoPotionPet(int nHPPetPotionPercent)
{
	requestAutoPlay(autotarget_bUseAutoTarget, autotarget_nHPPotionPercent, nHPPetPotionPercent);
}

function requestAutoPlayForAutoPotionWithPet(int nHPPotionPercent, int nHPPetPotionPercent)
{
	requestAutoPlay(autotarget_bUseAutoTarget, nHPPotionPercent, nHPPetPotionPercent);
}

function showHideForYeti(bool bShow)
{
	if(bShow)
	{
		Me.ShowWindow();
	}
	else
	{
		Me.HideWindow();
	}
}

function WinMinMax(int Value)
{
	if(Value == 0)
	{
		WinMinBTN.SetButtonValue(1);
		WinMinBTN.SetTexture("L2UI_NewTex.AutomaticPlay.WinExpandButton_Normal", "L2UI_NewTex.AutomaticPlay.WinExpandButton_Down", "L2UI_NewTex.AutomaticPlay.WinExpandButton_Over");
		LineBG.SetTexture("");
		AutoCircleFrameExpand.SetTexture("L2UI_NewTex.AutomaticPlay.AutoCircleFrameSmall");
		TargetNext_BTN.HideWindow();
		TargetSwap_BTN.HideWindow();
		TargetPickupToggle_BTN.HideWindow();
		TargetMannerToggle_BTN.HideWindow();
		Combat_BTN.HideWindow();
	}
	else
	{
		WinMinBTN.SetButtonValue(0);
		WinMinBTN.SetTexture("L2UI_NewTex.AutomaticPlay.WinMinButton_Normal", "L2UI_NewTex.AutomaticPlay.WinMinButton_Down", "L2UI_NewTex.AutomaticPlay.WinMinButton_Over");
		LineBG.SetTexture("L2UI_NewTex.AutomaticPlay.LineBG");
		AutoCircleFrameExpand.SetTexture("L2UI_NewTex.AutomaticPlay.AutoCircleFrameExpand");
		TargetNext_BTN.ShowWindow();
		TargetSwap_BTN.ShowWindow();
		TargetPickupToggle_BTN.ShowWindow();
		TargetMannerToggle_BTN.ShowWindow();
		Combat_BTN.ShowWindow();
	}
}

function int GetAbs(int Num)
{
	if(Num < 0)
	{
		return - Num;
	}
	return Num;
}

defaultproperties
{
}
