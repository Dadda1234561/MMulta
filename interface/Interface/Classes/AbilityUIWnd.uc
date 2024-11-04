class AbilityUIWnd extends UICommonAPI;

const DIALOGID_INIT = 1;
const DIALOGID_APPLY = 2;

var WindowHandle Me;
var WindowHandle AbilityCategory0;
var WindowHandle AbilityCategory1;
var WindowHandle AbilityCategory2;
var TextBoxHandle Category0TextBox;
var TextBoxHandle Category1TextBox;
var TextBoxHandle Category2TextBox;
var ButtonHandle InitButton;
var ButtonHandle ApplyButton;
var ButtonHandle CancelButton;
var int apTotal;
var int apTotalFirstValue;
var int apCategory0;
var int apCategory1;
var int apCategory2;
var int apCategory0Applied;
var int apCategory1Applied;
var int apCategory2Applied;
var TextBoxHandle TotalAPTextBox;
var INT64 nNeedResetSP;
var bool bInitClickRun;

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_ACQUIRE_AP_SKILL_LIST);	
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();	
}

function Initialize()
{
	Me = GetMeWindow();
	AbilityCategory0 = GetMeWindow("AbilityCategory0");
	AbilityCategory1 = GetMeWindow("AbilityCategory1");
	AbilityCategory2 = GetMeWindow("AbilityCategory2");
	Category0TextBox = GetMeTextBox("Category0TextBox");
	Category1TextBox = GetMeTextBox("Category1TextBox");
	Category2TextBox = GetMeTextBox("Category2TextBox");
	InitButton = GetMeButton("InitButton");
	ApplyButton = GetMeButton("ApplyButton");
	CancelButton = GetMeButton("CancelButton");
	TotalAPTextBox = GetMeTextBox("TotalAPTextBox");	
}

event OnShow()
{
	showDisable(true);
	API_C_EX_ABILITY_WND_OPEN();
	API_C_EX_REQUEST_POTENTIAL_SKILL_LIST();	
}

event OnHide()
{
	initAllAP();
	OnClickCancelDialog();
	API_C_EX_ABILITY_WND_CLOSE();	
}

event OnEvent(int Event_ID, string param)
{
	local UserInfo UserInfo;

	switch(Event_ID)
	{
		// End:0x3F
		case EV_GameStart:
			ApplyButton.DisableWindow();
			CancelButton.DisableWindow();
			InitButton.DisableWindow();
			// End:0xC2
			break;
		// End:0x9F
		case EV_UpdateUserInfo:
			// End:0x9C
			if(Me.IsShowWindow())
			{
				GetPlayerInfo(UserInfo);
				// End:0x81
				if(UserInfo.nLevel < 76)
				{
					Me.HideWindow();
				}
				InitButton.SetTooltipCustomType(getCustomTooltipInit());
				buttonStateCheck();
			}
			// End:0xC2
			break;
		// End:0xBF
		case EV_PacketID(class'UIPacket'.const.S_EX_ACQUIRE_AP_SKILL_LIST):
			ParsePacket_S_EX_ACQUIRE_AP_SKILL_LIST();
			// End:0xC2
			break;
	}	
}

function ParsePacket_S_EX_ACQUIRE_AP_SKILL_LIST()
{
	local UIPacket._S_EX_ACQUIRE_AP_SKILL_LIST packet;
	local int i;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_ACQUIRE_AP_SKILL_LIST(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_ACQUIRE_AP_SKILL_LIST :  " @ string(packet.bSuccess) @ string(packet.nResetSP) @ string(packet.nAP) @ string(packet.nAcquiredAbilityCount));
	showDisable(false);
	// End:0x1C9
	if(packet.bSuccess > 0)
	{
		// End:0xB4
		if(bInitClickRun == true)
		{
			initAllAP();			
		}
		else
		{
			initAllAP(true);
		}
		bInitClickRun = false;
		nNeedResetSP = packet.nResetSP;
		apTotalFirstValue = packet.nAP;
		apTotal = packet.nAP;
		InitButton.SetTooltipCustomType(getCustomTooltipInit());
		ApplyButton.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(4188)));

		// End:0x17E [Loop If]
		for(i = 0; i < packet.abilitySkills.Length; i++)
		{
			_setSlotAppliedAP(packet.abilitySkills[i].nID, packet.abilitySkills[i].nLevel);
		}
		class'UIDATA_PLAYER'.static.SetAbilityPoint(_getAPTotal());
		// End:0x1BA
		if(packet.abilitySkills.Length > 0)
		{
			_updateCategory(0);
			_updateCategory(1);
			_updateCategory(2);
		}
		updateTextBox();
		buttonStateCheck();		
	}
	else
	{
		AddSystemMessage(4559);
		Me.HideWindow();
	}	
}

function CustomTooltip getCustomTooltipInit()
{
	local UserInfo UserInfo;
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	GetPlayerInfo(UserInfo);
	drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(4191), MakeCostStringINT64(nNeedResetSP)), GTColor().Yellow, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1575) $ " : ", GTColor().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(MakeCostStringINT64(UserInfo.nSP), GTColor().Orange2, "", false, true);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;	
}

function _setSlotAppliedAP(int nID, int nLevel)
{
	local int nCategory, X, Y;

	// End:0xA6 [Loop If]
	for(nCategory = 0; nCategory < 3; nCategory++)
	{
		// End:0x9C [Loop If]
		for(X = 1; X <= 4; X++)
		{
			// End:0x92 [Loop If]
			for(Y = 1; Y <= 6; Y++)
			{
				// End:0x88
				if(getSlotControl(nCategory, X, Y)._getAbilityID() == nID)
				{
					getSlotControl(nCategory, X, Y)._setAppliedAP(nLevel);
					return;
				}
			}
		}
	}
}

function int _getAPTotal()
{
	return ((apTotal - apCategory0Applied) - apCategory1Applied) - apCategory2Applied;	
}

function _useAP(int useAtCategory)
{
	// End:0x47
	if(apTotal > 0)
	{
		apTotal--;
		switch(useAtCategory)
		{
			// End:0x27
			case 0:
				apCategory0++;
				// End:0x47
				break;
			// End:0x35
			case 1:
				apCategory1++;
				// End:0x47
				break;
			// End:0x44
			case 2:
				apCategory2++;
				// End:0x47
				break;
		}
	}
	else
	{
		updateTextBox();		
	}
}

function _removeAP(int useAtCategory)
{
	apTotal++;
	switch(useAtCategory)
	{
		// End:0x1C
		case 0:
			apCategory0--;
			// End:0x3C
			break;
		// End:0x2A
		case 1:
			apCategory1--;
			// End:0x3C
			break;
		// End:0x39
		case 2:
			apCategory2--;
			// End:0x3C
			break;
	}
	updateTextBox();	
}

function buttonStateCheck()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	// End:0x4D
	if(((apCategory0Applied + apCategory1Applied) + apCategory2Applied) > 0 && UserInfo.nSP >= nNeedResetSP)
	{
		InitButton.EnableWindow();		
	}
	else
	{
		InitButton.DisableWindow();
	}	
}

function int _getAPCategory(int useAtCategory)
{
	local int RValue;

	switch(useAtCategory)
	{
		// End:0x20
		case 0:
			RValue = apCategory0 + apCategory0Applied;
			// End:0x56
			break;
		// End:0x39
		case 1:
			RValue = apCategory1 + apCategory1Applied;
			// End:0x56
			break;
		// End:0x53
		case 2:
			RValue = apCategory2 + apCategory2Applied;
			// End:0x56
			break;
	}
	return RValue;	
}

function _updateCategory(int nCategory)
{
	local int X, Y;

	// End:0x59 [Loop If]
	for(X = 1; X <= 4; X++)
	{
		// End:0x4F [Loop If]
		for(Y = 1; Y <= 6; Y++)
		{
			getSlotControl(nCategory, X, Y)._updateSlot();
		}
	}	
}

function int _findMaxRequireAbilityLev(int nCategory, int RequireAbilityID)
{
	local int X, Y, V;

	// End:0x75 [Loop If]
	for(X = 1; X <= 4; X++)
	{
		// End:0x6B [Loop If]
		for(Y = 1; Y <= 6; Y++)
		{
			V = getSlotControl(nCategory, X, Y)._getMaxAbilityLev(RequireAbilityID);
			// End:0x61
			if(V > 0)
			{
				return V;
			}
		}
	}
	return -1;	
}

function int _findCurrentAP(int nCategory, int AbilityID)
{
	local int X, Y;

	// End:0x83 [Loop If]
	for(X = 1; X <= 4; X++)
	{
		// End:0x79 [Loop If]
		for(Y = 1; Y <= 6; Y++)
		{
			// End:0x6F
			if(getSlotControl(nCategory, X, Y)._getAbilityID() == AbilityID)
			{
				return getSlotControl(nCategory, X, Y)._getCurrentAP();
			}
		}
	}
	return -1;	
}

function int _totalAppliedAP()
{
	local int nCategory, X, Y, sumAP;

	// End:0x83 [Loop If]
	for(nCategory = 0; nCategory < 3; nCategory++)
	{
		// End:0x79 [Loop If]
		for(X = 1; X <= 4; X++)
		{
			// End:0x6F [Loop If]
			for(Y = 1; Y <= 6; Y++)
			{
				sumAP = sumAP + getSlotControl(nCategory, X, Y)._getCurrentAppliedAP();
			}
		}
	}
	return sumAP;	
}

function int _totalUseAP()
{
	local int nCategory, X, Y, sumAP;

	// End:0x83 [Loop If]
	for(nCategory = 0; nCategory < 3; nCategory++)
	{
		// End:0x79 [Loop If]
		for(X = 1; X <= 4; X++)
		{
			// End:0x6F [Loop If]
			for(Y = 1; Y <= 6; Y++)
			{
				sumAP = sumAP + getSlotControl(nCategory, X, Y)._getCurrentUseAP();
			}
		}
	}
	return sumAP;	
}

function bool _checkEnableRClick(int nCategory, int Col, int AbilityID)
{
	local int X, Y, sumAP;

	// End:0x6C [Loop If]
	for(Y = 1; Y <= (Col - 1); Y++)
	{
		// End:0x62 [Loop If]
		for(X = 1; X <= 4; X++)
		{
			sumAP = getSlotControl(nCategory, X, Y)._getCurrentAP() + sumAP;
		}
	}

	// End:0x182 [Loop If]
	for(Y = Y; Y <= 5; Y++)
	{
		// End:0xCC [Loop If]
		for(X = 1; X <= 4; X++)
		{
			sumAP = getSlotControl(nCategory, X, Y)._getCurrentAP() + sumAP;
		}
		Col = Y + 1;

		// End:0x178 [Loop If]
		for(X = 1; X <= 4; X++)
		{
			// End:0x115
			if(getSlotControl(nCategory, X, Col)._getCurrentAP() == 0)
			{
				// [Explicit Continue]
				continue;
			}
			// End:0x143
			if(getSlotControl(nCategory, X, Col)._getRequireCount() == sumAP)
			{
				return false;
				// [Explicit Continue]
				continue;
			}
			// End:0x16E
			if(getSlotControl(nCategory, X, Col)._getRequireAbilityID() == AbilityID)
			{
				return false;
			}
		}
	}
	return true;	
}

function _setCategoryApApplied(int nCategory, int addAP)
{
	switch(nCategory)
	{
		// End:0x20
		case 0:
			apCategory0Applied = addAP + apCategory0Applied;
			// End:0x56
			break;
		// End:0x39
		case 1:
			apCategory1Applied = addAP + apCategory1Applied;
			// End:0x56
			break;
		// End:0x53
		case 2:
			apCategory2Applied = addAP + apCategory2Applied;
			// End:0x56
			break;
	}
	updateTextBox();	
}

function Load()
{
	local int nCategory, X, Y;

	SetPopupScript();
	
	// End:0x72 [Loop If]
	for(nCategory = 0; nCategory < 3; nCategory++)
	{
		// End:0x68 [Loop If]
		for(X = 1; X <= 4; X++)
		{
			// End:0x5E [Loop If]
			for(Y = 1; Y <= 6; Y++)
			{
				AddControl(nCategory, X, Y);
			}
		}
	}
	_updateCategory(0);
	_updateCategory(1);
	_updateCategory(2);
	ApplyButton.DisableWindow();
	CancelButton.DisableWindow();
	InitButton.DisableWindow();	
}

function AddControl(int Category, int X, int Y)
{
	local WindowHandle targetWindowHandle;
	local AbilitySlot targetControl;

	targetWindowHandle = GetMeWindow("AbilityCategory" $ string(Category) $ "." $ "AbilitySlot" $ string(Y) $ string(X));
	targetWindowHandle.SetScript("AbilitySlot");
	targetControl = AbilitySlot(targetWindowHandle.GetScript());
	targetControl.Init(targetWindowHandle, self, Category, X, Y);	
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		// End:0x36
		case "InitButton":
			ShowPopup(GetSystemMessage(4192), 1, MakeCostStringINT64(nNeedResetSP));
			// End:0xF2
			break;
		// End:0x5E
		case "ApplyButton":
			ShowPopup(GetSystemMessage(4189), 2, "");
			// End:0xF2
			break;
		// End:0xCA
		case "CancelButton":
			cancelAllAP();
			L2UITween(GetScript("l2UITween")).StartShake("AbilityUIWnd", 4, 1000, L2UITween(GetScript("l2UITween")).directionType.small, 0);
			// End:0xF2
			break;
		// End:0xEF
		case "WindowHelp_BTN":
			ExecuteEvent(1210, "18");
			// End:0xF2
			break;
	}	
}

function AbilitySlot getSlotControl(int Category, int X, int Y)
{
	local WindowHandle targetWindowHandle;
	local AbilitySlot targetControl;

	targetWindowHandle = GetMeWindow("AbilityCategory" $ string(Category) $ "." $ "AbilitySlot" $ string(Y) $ string(X));
	targetControl = AbilitySlot(targetWindowHandle.GetScript());
	return targetControl;	
}

function cancelAllAP()
{
	local int nCategory, X, Y;

	// End:0x76 [Loop If]
	for(nCategory = 0; nCategory < 3; nCategory++)
	{
		// End:0x6C [Loop If]
		for(X = 1; X <= 4; X++)
		{
			// End:0x62 [Loop If]
			for(Y = 1; Y <= 6; Y++)
			{
				getSlotControl(nCategory, X, Y)._cancelAP();
			}
		}
	}
	apCategory0 = 0;
	apCategory1 = 0;
	apCategory2 = 0;
	apTotal = apTotalFirstValue;
	updateTextBox();
	_updateCategory(0);
	_updateCategory(1);
	_updateCategory(2);
	ApplyButton.DisableWindow();
	CancelButton.DisableWindow();	
}

function initAllAP(optional bool NoUseAPInit)
{
	local int nCategory, X, Y;

	// End:0x7C [Loop If]
	for(nCategory = 0; nCategory < 3; nCategory++)
	{
		// End:0x72 [Loop If]
		for(X = 1; X <= 4; X++)
		{
			// End:0x68 [Loop If]
			for(Y = 1; Y <= 6; Y++)
			{
				getSlotControl(nCategory, X, Y)._initAP(NoUseAPInit);
			}
		}
	}
	apCategory0 = 0;
	apCategory1 = 0;
	apCategory2 = 0;
	apCategory0Applied = 0;
	apCategory1Applied = 0;
	apCategory2Applied = 0;
	apTotal = 0;
	apTotalFirstValue = 0;
	updateTextBox();
	_updateCategory(0);
	_updateCategory(1);
	_updateCategory(2);
	ApplyButton.DisableWindow();
	CancelButton.DisableWindow();
	InitButton.DisableWindow();	
}

function updateTextBox()
{
	Category0TextBox.SetText(string(apCategory0 + apCategory0Applied) $ " " $ GetSystemString(5012));
	Category1TextBox.SetText(string(apCategory1 + apCategory1Applied) $ " " $ GetSystemString(5012));
	Category2TextBox.SetText(string(apCategory2 + apCategory2Applied) $ " " $ GetSystemString(5012));
	TotalAPTextBox.SetText(string(((apTotal - apCategory0Applied) - apCategory1Applied) - apCategory2Applied));	
}

function _callBackSlotClick(int Category, int X, int Y, int AbilityID)
{
	// End:0x2D
	if((_totalUseAP()) > 0)
	{
		ApplyButton.EnableWindow();
		CancelButton.EnableWindow();		
	}
	else
	{
		ApplyButton.DisableWindow();
		CancelButton.DisableWindow();
	}	
}

function SetPopupScript()
{
	local WindowHandle popExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle disableWnd;

	popExpandWnd = GetMeWindow("UIControlDialogAsset");
	popupExpandScript = class'UIControlDialogAssets'.static.InitScript(popExpandWnd);
	disableWnd = GetMeWindow("DisableWnd");
	popupExpandScript.SetDisableWindow(disableWnd);
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop("AbilityUIWnd.DisableWnd", false);	
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetMeWindow("UIControlDialogAsset");
	return UIControlDialogAssets(popExpandWnd.GetScript());	
}

function ShowPopup(string Msg, int dialogID, string Param1)
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = GetPopupExpandScript();
	popupExpandScript.SetDialogDesc(MakeFullSystemMsg(Msg, Param1));
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = OnDialogOK;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	popupExpandScript.SetDialogID(dialogID);
	showDisable(true);	
}

function OnDialogOK()
{
	switch(GetPopupExpandScript().GetDialogID())
	{
		// End:0x79
		case 1:
			bInitClickRun = true;
			API_C_EX_RESET_POTENTIAL_SKILL();
			L2UITween(GetScript("l2UITween")).StartShake("AbilityUIWnd", 8, 1000, L2UITween(GetScript("l2UITween")).directionType.small, 0);
			// End:0x8A
			break;
		// End:0x87
		case 2:
			API_C_EX_ACQUIRE_POTENTIAL_SKILL();
			// End:0x8A
			break;
		// End:0xFFFF
		default:
			break;
	}
	GetPopupExpandScript().Hide();
	showDisable(false);	
}

function OnClickCancelDialog()
{
	GetPopupExpandScript().Hide();
	showDisable(false);	
}

function showDisable(bool bShow)
{
	// End:0x28
	if(bShow)
	{
		GetMeWindow("DisableWnd").ShowWindow();		
	}
	else
	{
		GetMeWindow("DisableWnd").HideWindow();
	}	
}

function API_C_EX_ACQUIRE_POTENTIAL_SKILL()
{
	local array<byte> stream;
	local UIPacket._C_EX_ACQUIRE_POTENTIAL_SKILL packet;

	packet.nAP = _totalUseAP();
	packet.abilitySkillsPerType[0] = getArrayPkAbilitySkill(0);
	packet.abilitySkillsPerType[1] = getArrayPkAbilitySkill(1);
	packet.abilitySkillsPerType[2] = getArrayPkAbilitySkill(2);
	// End:0x6F
	if(! class'UIPacket'.static.Encode_C_EX_ACQUIRE_POTENTIAL_SKILL(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_ACQUIRE_POTENTIAL_SKILL, stream);
	Debug("api Call : C_EX_ACQUIRE_POTENTIAL_SKILL" @ string(packet.nAP));	
}

function API_C_EX_REQUEST_POTENTIAL_SKILL_LIST()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_REQUEST_POTENTIAL_SKILL_LIST, stream);
	Debug("API Call --> C_EX_REQUEST_POTENTIAL_SKILL_LIST");	
}

function API_C_EX_RESET_POTENTIAL_SKILL()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_RESET_POTENTIAL_SKILL, stream);
	Debug("API Call --> C_EX_RESET_POTENTIAL_SKILL");	
}

function API_C_EX_ABILITY_WND_OPEN()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_ABILITY_WND_OPEN, stream);
	Debug("API Call --> C_EX_ABILITY_WND_OPEN");
}

function API_C_EX_ABILITY_WND_CLOSE()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_ABILITY_WND_CLOSE, stream);
	Debug("API Call --> C_EX_ABILITY_WND_CLOSE");
}

function UIPacket._PkAbilitySkillsPerType getArrayPkAbilitySkill(int nCategory)
{
	local UIPacket._PkAbilitySkillsPerType skillPerType;
	local UIPacket._PkAbilitySkill pkSkill;
	local int X, Y, useAP, AbilityID;

	// End:0x11E [Loop If]
	for(Y = 1; Y <= 6; Y++)
	{
		// End:0x114 [Loop If]
		for(X = 1; X <= 4; X++)
		{
			useAP = 0;
			// End:0x99
			if(getSlotControl(nCategory, X, Y)._isShow())
			{
				useAP = getSlotControl(nCategory, X, Y)._getCurrentAP();
				AbilityID = getSlotControl(nCategory, X, Y)._getAbilityID();
			}
			// End:0x10A
			if((useAP > 0) && AbilityID > 0)
			{
				pkSkill.nID = AbilityID;
				pkSkill.nLevel = useAP;
				skillPerType.abilitySkills.Length = skillPerType.abilitySkills.Length + 1;
				skillPerType.abilitySkills[skillPerType.abilitySkills.Length - 1] = pkSkill;
			}
		}
	}
	Debug("skillPerType.abilitySkills.Length" @ string(nCategory) @ string(skillPerType.abilitySkills.Length));
	return skillPerType;	
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	// End:0x4B
	if(GetMeWindow("UIControlDialogAsset").IsShowWindow())
	{
		showDisable(false);
		GetPopupExpandScript().Hide();		
	}
	else
	{
		closeUI();
	}
}

defaultproperties
{
}
