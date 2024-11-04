class DethroneFireEnchantProcess extends UICommonAPI;

const ENCHANTING_TIME = 1000;

var WindowHandle Me;
var RichListCtrlHandle NeedItem_RichList;
var RichListCtrlHandle Reward_RichList;
var TextBoxHandle SelectTypeWithLv_text;
var TextBoxHandle Desc_text;
var ButtonHandle Init_Btn;
var ButtonHandle Enchant_Btn;
var ButtonHandle Upgrade_Btn;
var ButtonHandle Back_Btn;
var ButtonHandle AutoNumStepChange_Btn;
var CheckBoxHandle AutoCheckBox;
var CheckBoxHandle NumStepCheckBox;
var StatusBarHandle Proficiency_StatusBar;
var EffectViewportWndHandle effectViewport;
var EffectViewportWndHandle effectViewportResult;
var EffectViewportWndHandle effectViewportItemResult;
var UIControlNeedItemList needItemRichListScript;
var TextBoxHandle EnchantButtonLimit_Text;
var TextBoxHandle InitButtonLimit_Text;
var TextBoxHandle EnchantButton_Text;
var TextBoxHandle InitButton_Text;
var TextureHandle IntTextBg_tex;
var TextureHandle EnchantTextBg_tex;
var TextBoxHandle StatusBar_Text;
var TextBoxHandle EnchantPer_Text;
var TextBoxHandle AutoNumStep_Text;
var TextureHandle Cover_tex;
var TextBoxHandle Cover_Desc02_text;
var DethroneFireEnchantWnd DethroneFireEnchantWndScript;
var DethroneFireEnchantDetailStats DethroneFireEnchantDetailStatsScript;
var DethroneFireEnchantChart DethroneFireEnchantChartScript;
var L2UITimerObject timeObject;
var L2UITimerObject enchantTimeObject;
var ItemWindowHandle Icon_Item;
var int nCurHP;
var INT64 nSP;
var int spIndex;
var int hpIndex;
var FireAbilityLevelupInfoUIData levelUPData;
var UIPacket._EAOF_Element OpenUI_PacketElement;
var FireAbilityUIData UIData;
var bool isEnchanting;
var int nAutoStepNum;
var bool bResultNumStepCheckValue;
var bool bResultAutoCheckValue;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_ENHANCED_ABILITY_OF_FIRE_INIT);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_UpdateMyHP);
	RegisterEvent(EV_Test_7);	
}

function OnShow()
{
	initCheckBox();	
}

function InitNeedItemControl()
{
	needItemRichListScript = new class'UIControlNeedItemList';
	needItemRichListScript.SetRichListControler(GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem_RichList"));
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem_RichList").SetTooltipType("UIControlNeedItemList");
	needItemRichListScript.DelegateOnUpdateItem = DelegateOnUpdateItem;
}

function OnLoad()
{
	Initialize();
	InitNeedItemControl();
}

function Initialize()
{
	Me = GetWindowHandle("DethroneFireEnchantProcess");
	SelectTypeWithLv_text = GetTextBoxHandle("DethroneFireEnchantProcess.SelectTypeWithLv_text");
	NeedItem_RichList = GetRichListCtrlHandle("DethroneFireEnchantProcess.NeedItem_RichList");
	Reward_RichList = GetRichListCtrlHandle("DethroneFireEnchantProcess.Reward_RichList");
	Desc_text = GetTextBoxHandle("DethroneFireEnchantProcess.Desc_text");
	Init_Btn = GetButtonHandle("DethroneFireEnchantProcess.Init_Btn");
	Enchant_Btn = GetButtonHandle("DethroneFireEnchantProcess.Enchant_Btn");
	Upgrade_Btn = GetButtonHandle("DethroneFireEnchantProcess.Upgrade_Btn");
	Back_Btn = GetButtonHandle("DethroneFireEnchantProcess.Back_Btn");
	AutoNumStepChange_Btn = GetButtonHandle("DethroneFireEnchantProcess.AutoNumStepChange_Btn");
	effectViewport = GetEffectViewportWndHandle("DethroneFireEnchantProcess.effectViewport");
	effectViewportResult = GetEffectViewportWndHandle("DethroneFireEnchantProcess.effectViewportResult");
	effectViewportItemResult = GetEffectViewportWndHandle("DethroneFireEnchantProcess.effectViewportItemResult");
	Proficiency_StatusBar = GetStatusBarHandle("DethroneFireEnchantProcess.Proficiency_StatusBar");
	EnchantButton_Text = GetTextBoxHandle("DethroneFireEnchantProcess.EnchantButton_Text");
	EnchantButtonLimit_Text = GetTextBoxHandle("DethroneFireEnchantProcess.EnchantButtonLimit_Text");
	InitButton_Text = GetTextBoxHandle("DethroneFireEnchantProcess.InitButton_Text");
	EnchantPer_Text = GetTextBoxHandle("DethroneFireEnchantProcess.EnchantPer_Text");
	AutoNumStep_Text = GetTextBoxHandle("DethroneFireEnchantProcess.AutoNumStep_Text");
	InitButtonLimit_Text = GetTextBoxHandle("DethroneFireEnchantProcess.InitButtonLimit_Text");
	AutoCheckBox = GetCheckBoxHandle("DethroneFireEnchantProcess.AutoCheckBox");
	NumStepCheckBox = GetCheckBoxHandle("DethroneFireEnchantProcess.NumStepCheckBox");
	StatusBar_Text = GetTextBoxHandle("DethroneFireEnchantProcess.StatusBar_Text");
	Cover_tex = GetTextureHandle("DethroneFireEnchantProcess.Cover_tex");
	Cover_Desc02_text = GetTextBoxHandle("DethroneFireEnchantProcess.Desc02_text");
	IntTextBg_tex = GetTextureHandle("DethroneFireEnchantProcess.IntTextBg_tex");
	EnchantTextBg_tex = GetTextureHandle("DethroneFireEnchantProcess.EnchantTextBg_tex");
	Icon_Item = GetItemWindowHandle("DethroneFireEnchantProcess.Icon_Item");
	DethroneFireEnchantWndScript = DethroneFireEnchantWnd(GetScript("DethroneFireEnchantWnd"));
	DethroneFireEnchantChartScript = DethroneFireEnchantChart(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantChart"));
	DethroneFireEnchantDetailStatsScript = DethroneFireEnchantDetailStats(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantDetailStats"));
	Reward_RichList.SetSelectable(false);
	Reward_RichList.SetSelectedSelTooltip(false);
	Reward_RichList.SetUseStripeBackTexture(false);
	Reward_RichList.SetAppearTooltipAtMouseX(true);
	Reward_RichList.SetTooltipType("SellItemList");
	enchantTimeObject = class'L2UITimer'.static.Inst()._AddNewTimerObject(1, 1);
	enchantTimeObject._DelegateOnTime = delayAutoCall;
	timeObject = class'L2UITimer'.static.Inst()._AddNewTimerObject(ENCHANTING_TIME, 1);
	timeObject._DelegateOnTime = OnTime;
	Enchant_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14427), 250));	
}

function refresh()
{
	local int cType, i;
	local UserInfo Info;
	local Rect rectWnd;

	OpenUI_PacketElement = DethroneFireEnchantWndScript.getSelectedPacketDataElement();
	cType = DethroneFireEnchantChartScript.getSelectedCType();
	Debug("인챈트 처리창 refresh" @ string(cType));
	Icon_Item.Clear();
	Icon_Item.AddItem(getCTypeIconItemInfo(cType));
	UIData = DethroneFireEnchantWndScript.getSeletedUIData();
	levelUPData = DethroneFireEnchantWndScript.getSelectedUIDataByLevel(OpenUI_PacketElement.nLevel);
	if(levelUPData.ExpUpSuccessRate == float(0))
	{
		EnchantPer_Text.SetText(" - ");		
	}
	else
	{
		EnchantPer_Text.SetText(string0100Per(levelUPData.ExpUpSuccessRate) $ "%");
	}
	AutoNumStepChange_Btn.DisableWindow();
	needItemRichListScript.CleariObjects();
	needItemRichListScript.StartNeedItemList(levelUPData.ExpUpCostItem.Length);
	spIndex = -1;
	hpIndex = -1;

	// End:0x235 [Loop If]
	for(i = 0; i < levelUPData.ExpUpCostItem.Length; i++)
	{
		// End:0x182
		if(levelUPData.ExpUpCostItem[i].ItemClassID == 82621)
		{
			GetPlayerInfo(Info);
			hpIndex = needItemRichListScript.AddNeeItemInfo(GetItemInfoByClassID(82621), levelUPData.ExpUpCostItem[i].ItemAmount, Info.nCurHP);
			// [Explicit Continue]
			continue;
		}
		// End:0x1F0
		if(levelUPData.ExpUpCostItem[i].ItemClassID == 82500)
		{
			GetPlayerInfo(Info);
			spIndex = needItemRichListScript.AddNeeItemInfo(GetItemInfoByClassID(82500), levelUPData.ExpUpCostItem[i].ItemAmount, Info.nSP);
			// [Explicit Continue]
			continue;
		}
		needItemRichListScript.AddNeedItemClassID(levelUPData.ExpUpCostItem[i].ItemClassID, levelUPData.ExpUpCostItem[i].ItemAmount);
	}
	needItemRichListScript.SetBuyNum(1);
	EnchantButtonLimit_Text.SetText(string(OpenUI_PacketElement.nExpUpCount) $ "/" $ string(UIData.DailyExpUpCount));
	InitButtonLimit_Text.SetText(string(OpenUI_PacketElement.nInitCount) $ "/" $ string(UIData.DailyInitCount));
	setBar();
	// End:0x331
	if(cType == 0)
	{
		Back_Btn.EnableWindow();
		Init_Btn.DisableWindow();
		AutoCheckBox.SetCheck(false);
		NumStepCheckBox.SetCheck(false);
		AutoCheckBox.DisableWindow();
		NumStepCheckBox.DisableWindow();
		AutoNumStepChange_Btn.DisableWindow();
		Enchant_Btn.DisableWindow();
		Cover_tex.ShowWindow();
		Cover_Desc02_text.ShowWindow();
		rectWnd = Me.GetRect();
		Upgrade_Btn.MoveTo(rectWnd.nX + 112, rectWnd.nY + 515);
		Init_Btn.HideWindow();
		Enchant_Btn.HideWindow();
		InitButton_Text.HideWindow();
		InitButtonLimit_Text.HideWindow();
		EnchantButton_Text.HideWindow();
		EnchantButtonLimit_Text.HideWindow();
		IntTextBg_tex.HideWindow();
		EnchantTextBg_tex.HideWindow();
	}
	else
	{
		setEnableUI(true);
		Cover_tex.HideWindow();
		Cover_Desc02_text.HideWindow();
		rectWnd = Me.GetRect();
		Upgrade_Btn.MoveTo(rectWnd.nX + 239, rectWnd.nY + 515);
		Init_Btn.ShowWindow();
		Enchant_Btn.ShowWindow();
		InitButton_Text.ShowWindow();
		InitButtonLimit_Text.ShowWindow();
		EnchantButton_Text.ShowWindow();
		EnchantButtonLimit_Text.ShowWindow();
		IntTextBg_tex.ShowWindow();
		EnchantTextBg_tex.ShowWindow();
	}
	Desc_text.SetText(GetSystemString(getDescStringByCType(cType)));	
}

function CheckEnableButton()
{
	local int cType;

	cType = DethroneFireEnchantChartScript.getSelectedCType();
	UIData = DethroneFireEnchantWndScript.getSeletedUIData();
	OpenUI_PacketElement = DethroneFireEnchantWndScript.getSelectedPacketDataElement();
	levelUPData = DethroneFireEnchantWndScript.getSelectedUIDataByLevel(OpenUI_PacketElement.nLevel);
	// End:0xC4
	if((OpenUI_PacketElement.nEXP >= levelUPData.Exp) && UIData.MaxLevel > OpenUI_PacketElement.nLevel)
	{
		Upgrade_Btn.EnableWindow();
		Upgrade_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14399)));		
	}
	else
	{
		// End:0x100
		if(UIData.MaxLevel <= OpenUI_PacketElement.nLevel)
		{
			Upgrade_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14416)));			
		}
		else
		{
			Upgrade_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14399)));
		}
		Upgrade_Btn.DisableWindow();
	}
	// End:0x1AC
	if((OpenUI_PacketElement.nExpUpCount > 0) && needItemRichListScript.GetCanBuy())
	{
		// End:0x170
		if(cType == 0)
		{
			Enchant_Btn.DisableWindow();			
		}
		else
		{
			Enchant_Btn.EnableWindow();
			// End:0x1A9
			if(isEnchanting == false)
			{
				AutoCheckBox.EnableWindow();
				NumStepCheckBox.EnableWindow();
			}
		}		
	}
	else
	{
		Enchant_Btn.DisableWindow();
		AutoCheckBox.DisableWindow();
		NumStepCheckBox.DisableWindow();
		initCheckBox();
	}
	// End:0x213
	if(OpenUI_PacketElement.nExpUpCount <= 0 && OpenUI_PacketElement.nInitCount > 0)
	{
		Init_Btn.EnableWindow();		
	}
	else
	{
		Init_Btn.DisableWindow();
	}	
}

function setBar()
{
	local UIPacket._EAOF_Element OpenUI_PacketElement;
	local float per;

	OpenUI_PacketElement = DethroneFireEnchantWndScript.getSelectedPacketDataElement();
	SelectTypeWithLv_text.SetText(getCTypeTitleSting(DethroneFireEnchantChartScript.getSelectedCType()) @ "Lv." $ string(OpenUI_PacketElement.nLevel));
	levelUPData = DethroneFireEnchantWndScript.getSelectedUIDataByLevel(OpenUI_PacketElement.nLevel);
	Proficiency_StatusBar.SetPoint(OpenUI_PacketElement.nEXP, levelUPData.Exp);
	per = float(ConvertFloatToString((float(OpenUI_PacketElement.nEXP) / float(levelUPData.Exp)) * 100, 2, false));
	StatusBar_Text.SetText(string0100Per(per) $ "/100");	
}

function int getDescStringByCType(int cType)
{
	local int stringNum;

	switch(cType)
	{
		// End:0x19
		case 0:
			stringNum = 14340;
			// End:0x67
			break;
		// End:0x2B
		case 1:
			stringNum = 14336;
			// End:0x67
			break;
		// End:0x3E
		case 2:
			stringNum = 14339;
			// End:0x67
			break;
		// End:0x51
		case 3:
			stringNum = 14338;
			// End:0x67
			break;
		// End:0x64
		case 4:
			stringNum = 14337;
			// End:0x67
			break;
	}
	return stringNum;	
}

function OnClickCheckBox(string strID)
{
	// End:0x88
	if(strID == "NumStepCheckBox")
	{
		AutoCheckBox.SetCheck(false);
		// End:0x59
		if(NumStepCheckBox.IsChecked() == false)
		{
			setAutoStepNum(0);
			AutoNumStepChange_Btn.DisableWindow();			
		}
		else
		{
			// End:0x76
			if(nAutoStepNum == 0)
			{
				DethroneFireEnchantWndScript.ShowAutoNumStepPopup();				
			}
			else
			{
				AutoNumStepChange_Btn.EnableWindow();
			}
		}		
	}
	else
	{
		// End:0xC6
		if(strID == "AutoCheckBox")
		{
			NumStepCheckBox.SetCheck(false);
			setAutoStepNum(0);
			AutoNumStepChange_Btn.DisableWindow();
		}
	}	
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x1D
		case "Init_Btn":
			OnInit_BtnClick();
			// End:0x94
			break;
		// End:0x36
		case "Enchant_Btn":
			OnEnchant_BtnClick();
			// End:0x94
			break;
		// End:0x4F
		case "Upgrade_Btn":
			OnUpgrade_BtnClick();
			// End:0x94
			break;
		// End:0x65
		case "Back_Btn":
			OnBack_BtnClick();
			// End:0x94
			break;
		// End:0x91
		case "AutoNumStepChange_Btn":
			DethroneFireEnchantWndScript.ShowAutoNumStepPopup();
			// End:0x94
			break;
	}	
}

function OnInit_BtnClick()
{
	DethroneFireEnchantWndScript.ShowDialogAsk(1);	
}

function InitHide()
{
	timeObject._Stop();
	enchantTimeObject._Stop();
	isEnchanting = false;
	EnchantButton_Text.SetText(GetSystemString(5005));
}

function OnEnchant_BtnClick()
{
	timeObject._Stop();
	// End:0x97
	if(isEnchanting)
	{
		isEnchanting = false;
		EnchantButton_Text.SetText(GetSystemString(5005));
		Desc_text.SetText(GetSystemString(getDescStringByCType(DethroneFireEnchantChartScript.getSelectedCType())));
		setEnableUI(true);
		DethroneFireEnchantChartScript.enableAll(true);
		effectViewport.SpawnEffect("");		
	}
	else
	{
		timeObject._Play();
		setEnableUI(false);
		isEnchanting = true;
		EnchantButton_Text.SetText(GetSystemString(5198));
		Desc_text.SetText(GetSystemString(14341));
		effectViewport.SetScale(1.0f);
		effectViewport.SetCameraDistance(250.0f);
		effectViewport.SpawnEffect("LineageEffect2.ui_Enchant_start");
		DethroneFireEnchantChartScript.enableAll(false);
	}	
}

function OnEnchant_Auto()
{
	timeObject._Stop();
	Debug("자동 인챈트 진행..");
	timeObject._Play();
	setEnableUI(false);
	isEnchanting = true;
	EnchantButton_Text.SetText(GetSystemString(5198));
	Desc_text.SetText(GetSystemString(14341));
	effectViewport.SetScale(1.0f);
	effectViewport.SetCameraDistance(250.0f);
	effectViewport.SpawnEffect("LineageEffect2.ui_Enchant_start");
	DethroneFireEnchantChartScript.enableAll(false);
}

function OnTime(int Count)
{
	Debug("시간 됨");
	isEnchanting = false;
	if(AutoCheckBox.IsChecked() == false && NumStepCheckBox.IsChecked() == false)
	{
		Debug("복원");
		EnchantButton_Text.SetText(GetSystemString(5005));
		DethroneFireEnchantChartScript.enableAll(true);
		Desc_text.SetText(GetSystemString(getDescStringByCType(DethroneFireEnchantChartScript.getSelectedCType())));
	}
	DethroneFireEnchantWndScript.API_C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP(DethroneFireEnchantChartScript.getSelectedCType());	
}

function OnUpgrade_BtnClick()
{
	DethroneFireEnchantWndScript.ShowDialogAsk(2);	
}

function OnBack_BtnClick()
{
	deleteRewardItems();
	GetWindowHandle("DethroneFireEnchantDetailStats").ShowWindow();
	Me.HideWindow();
	DethroneFireEnchantDetailStatsScript.refresh();	
}

function setEnableUI(bool bEnable)
{
	// End:0x54
	if(bEnable)
	{
		Back_Btn.EnableWindow();
		CheckEnableButton();
		// End:0x42
		if(NumStepCheckBox.IsChecked())
		{
			AutoNumStepChange_Btn.EnableWindow();			
		}
		else
		{
			AutoNumStepChange_Btn.DisableWindow();
		}		
	}
	else
	{
		Upgrade_Btn.DisableWindow();
		Back_Btn.DisableWindow();
		Init_Btn.DisableWindow();
		AutoCheckBox.DisableWindow();
		NumStepCheckBox.DisableWindow();
		AutoNumStepChange_Btn.DisableWindow();
	}	
}

function setAutoStepNum(int AutoStepNum, optional bool bSetCheck)
{
	nAutoStepNum = AutoStepNum;
	AutoNumStep_Text.SetText(string(nAutoStepNum));
	// End:0x59
	if(bSetCheck)
	{
		AutoCheckBox.SetCheck(false);
		NumStepCheckBox.SetCheck(true);
		AutoNumStepChange_Btn.EnableWindow();
	}	
}

function int getAutoStepNum()
{
	return nAutoStepNum;	
}

function initCheckBox()
{
	setAutoStepNum(0);
	setCancelAutoStepNum();
	AutoCheckBox.SetCheck(false);	
}

function setCancelAutoStepNum()
{
	// End:0x31
	if(nAutoStepNum == 0)
	{
		NumStepCheckBox.SetCheck(false);
		setAutoStepNum(0);
		AutoNumStepChange_Btn.DisableWindow();
	}	
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(class'UIPacket'.const.S_EX_ENHANCED_ABILITY_OF_FIRE_INIT):
			ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_INIT();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP):
			ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP):
			ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP();
			break;
		case EV_UpdateMyHP:
			HandleUpdateHP();
			break;
		// End:0x83
		case EV_UpdateUserInfo:
			HandleUpdateUserInfo();
			break;
		case EV_Test_7:
			ParseInt(param, "msec", timeObject._time);
			// End:0xCD
			if(timeObject._time <= 100)
			{
				timeObject._time = 100;
			}
			break;
	}	
}

function HandleUpdateUserInfo()
{
	local UserInfo UserInfo;

	// End:0x80
	if(GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow())
	{
		GetPlayerInfo(UserInfo);
		// End:0x80
		if(NeedItem_RichList.GetRecordCount() > 0 && spIndex > -1)
		{
			needItemRichListScript.ModifyCurrentAmount(spIndex, UserInfo.nSP);
			DelegateOnUpdateItem();
		}
	}	
}

function HandleUpdateHP()
{
	local UserInfo UserInfo;

	// End:0x82
	if(GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow())
	{
		GetPlayerInfo(UserInfo);
		// End:0x82
		if((NeedItem_RichList.GetRecordCount() > 0) && hpIndex > -1)
		{
			needItemRichListScript.ModifyCurrentAmount(hpIndex, UserInfo.nCurHP);
			DelegateOnUpdateItem();
		}
	}	
}

function DelegateOnUpdateItem()
{
	// End:0x30
	if(GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow() == false)
	{
		return;
	}
	CheckEnableButton();	
}

function ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_INIT()
{
	local UIPacket._S_EX_ENHANCED_ABILITY_OF_FIRE_INIT packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_INIT(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_INIT :  " @ string(packet.cType) @ string(packet.cResult) @ string(packet.nInitCount));
	// End:0xC6
	if(packet.cResult > 0)
	{
		DethroneFireEnchantWndScript.updatePacketDataElement_nInitCount(packet.cType, packet.nInitCount, UIData.DailyExpUpCount);
		refresh();		
	}
	else
	{
		Debug("초기화 오류 입니다. ");
		GetWindowHandle("DethroneFireEnchantWnd").HideWindow();
	}	
}

function ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP()
{
	local UIPacket._S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP packet;
	local int i;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP :  " @ string(packet.cType) @ string(packet.cResult) @ string(packet.nEXP) @ string(packet.nExpUpCount));
	DethroneFireEnchantWndScript.updatePacketDataElement(packet.cType, packet.nEXP, packet.nExpUpCount);
	refresh();
	DethroneFireEnchantChartScript.refresh();
	bResultAutoCheckValue = AutoCheckBox.IsChecked();
	bResultNumStepCheckValue = NumStepCheckBox.IsChecked();
	if(packet.cResult > 0)
	{
		Debug("=획득 아이템=> packet.rewards.length" @ string(packet.rewards.Length));

		if(packet.rewards.Length > 0)
		{
			effectViewportItemResult.SpawnEffect("LineageEffect2.ui_screen_message_flow");
		}
		for(i = 0; i < packet.rewards.Length; i++)
		{
			Debug("nItemClassId" @ string(packet.rewards[i].nItemClassID));
			Debug("nAmount" @ string(packet.rewards[i].nAmount));
			setRec(packet.rewards[i].nItemClassID, packet.rewards[i].nAmount);
		}
		effectViewportResult.SetScale(0.570f);
		effectViewportResult.SetCameraDistance(250.0f);
		effectViewportResult.SpawnEffect("LineageEffect2.ui_wi_mrfire");
		PlaySound("ItemSound3.enchant_success");
		class'L2UITween'.static.Inst()._AddTweenTwinlkle(StatusBar_Text, 2.0f, 0.50f, 500.0f);
		DethroneFireEnchantChartScript.Shake(true);
		enchantTimeObject._Stop();
		enchantTimeObject._Play();
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(3885));	
	}
	else if(packet.cResult == 0)
	{
		effectViewportResult.SetScale(1.0f);
		effectViewportResult.SetCameraDistance(250.0f);
		effectViewportResult.SpawnEffect("LineageEffect2.ui_upgrade_fail");
		PlaySound("ItemSound3.enchant_fail");
		DethroneFireEnchantChartScript.Shake(true);
		enchantTimeObject._Stop();
		enchantTimeObject._Play();
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(3886));		
	}
	else if(packet.cResult == -2)
	{
		AddSystemMessage(13830);
		initCheckBox();
		EnchantButton_Text.SetText(GetSystemString(5005));
		DethroneFireEnchantChartScript.groupButtons._setEnableAll();				
	}
	else
	{
		GetWindowHandle("DethroneFireEnchantWnd").HideWindow();
		Debug("디스론 능력 인챈트 중 알 수 없는 오류 입니다.");
	}
}

function setRec(int ClassID, INT64 Amount)
{
	local RichListCtrlRowData Record;
	local bool bModify;
	local int i;

	for(i = 0; i < Reward_RichList.GetRecordCount(); i++)
	{
		Reward_RichList.GetRec(i, Record);
		if(ClassID == Record.nReserved1)
		{
			Reward_RichList.ModifyRecord(i, makeRecord(int(Record.nReserved1), Record.nReserved2 + Amount));
			bModify = true;
			// [Explicit Break]
			break;
		}
	}
	if(bModify == false)
	{
		Reward_RichList.InsertRecord(makeRecord(ClassID, Amount));
	}	
}

function RichListCtrlRowData makeRecord(int ClassID, INT64 Amount)
{
	local RichListCtrlRowData Record;
	local ItemInfo iInfo;
	local string toolTipParam;

	Record.cellDataList.Length = 1;
	iInfo = GetItemInfoByClassID(ClassID);
	ItemInfoToParam(iInfo, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.nReserved1 = ClassID;
	Record.nReserved2 = Amount;
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, iInfo, 32, 32, -34, 1);
	addRichListCtrlString(Record.cellDataList[0].drawitems, GetItemNameAll(iInfo, true), getInstanceL2Util().BrightWhite, false, 5, 0);
	addRichListCtrlString(Record.cellDataList[0].drawitems, iInfo.AdditionalName, getInstanceL2Util().Yellow03, false, 5, 0);
	addRichListCtrlString(Record.cellDataList[0].drawitems, "x" $ MakeCostStringINT64(Amount), getInstanceL2Util().White, true, 40, 5);
	return Record;	
}

function deleteRewardItems()
{
	Reward_RichList.DeleteAllItem();	
}

function delayAutoCall(int Count)
{
	OpenUI_PacketElement = DethroneFireEnchantWndScript.getSelectedPacketDataElement();
	Debug("OpenUI_PacketElement.nExpUpCount" @ string(OpenUI_PacketElement.nExpUpCount));
	Debug("needItemRichListScript.GetCanBuy()" @ string(needItemRichListScript.GetCanBuy()));
	Debug("AutoCheckBox.IsChecked()" @ string(AutoCheckBox.IsChecked()));
	Debug("bResultAutoCheckValue" @ string(bResultAutoCheckValue));
	if(bResultAutoCheckValue)
	{
		// End:0x5F
		if(AutoCheckBox.IsChecked() && OpenUI_PacketElement.nExpUpCount > 0 && needItemRichListScript.GetCanBuy())
		{
			OnEnchant_Auto();			
		}
		else
		{
			initCheckBox();
			EnchantButton_Text.SetText(GetSystemString(5005));
			DethroneFireEnchantChartScript.enableAll(true);
		}		
	}
	else
	{
		// End:0x14D
		if(bResultNumStepCheckValue)
		{
			nAutoStepNum--;
			// End:0x103
			if(NumStepCheckBox.IsChecked() && OpenUI_PacketElement.nExpUpCount > 0 && needItemRichListScript.GetCanBuy() && nAutoStepNum > 0)
			{
				setAutoStepNum(nAutoStepNum);
				OnEnchant_Auto();				
			}
			else
			{
				setAutoStepNum(nAutoStepNum);
				initCheckBox();
				EnchantButton_Text.SetText(GetSystemString(5005));
				setEnableUI(true);
				DethroneFireEnchantChartScript.enableAll(true);
			}
		}
		else
		{
			initCheckBox();
			EnchantButton_Text.SetText(GetSystemString(5005));
			DethroneFireEnchantChartScript.enableAll(true);
		}
	}	
}

function ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP()
{
	local UIPacket._S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP :  " @ string(packet.cType) @ string(packet.cResult) @ string(packet.nLevel));
	DethroneFireEnchantWndScript.updatePacketDataElement_nLevel(packet.cType, packet.nLevel);
	// End:0x112
	if(packet.cResult > 0)
	{
		Debug("디스론 승급 성공");
		refresh();
		DethroneFireEnchantChartScript.refresh();
		DethroneFireEnchantWndScript.playResultEffectViewPort("LineageEffect2.ui_Enchant_success");
		AddSystemMessage(13832);
		class'L2UITween'.static.Inst()._AddTweenTwinlkle(SelectTypeWithLv_text, 2.0f, 0.50f, 1000.0f);	
	}
	else if(packet.cResult == 0)
	{
		GetWindowHandle("DethroneFireEnchantWnd").HideWindow();
		Debug("디스론 승급 실패");			
	}
	else
	{
		GetWindowHandle("DethroneFireEnchantWnd").HideWindow();
		Debug("디스론 승급 중 알 수 없는 오류 입니다.");
	}
}

function OnReceivedCloseUI()
{
	Debug("esc");
	DethroneFireEnchantWndScript.OnReceivedCloseUI();	
}

function ItemInfo getCTypeIconItemInfo(int cType)
{
	local ItemInfo Info;

	switch(cType)
	{
		case 0:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_source_1";
			break;
		case 1:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_life_1";
			break;
		case 2:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_combat_1";
			break;
		case 3:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_totem_1";
			break;
		case 4:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_piece_1";
			break;
	}
	return Info;	
}

function string getCTypeTitleSting(int cType)
{
	local string RValue;

	switch(cType)
	{
		case 0:
			RValue = GetSystemString(14320);
			break;
		case 1:
			RValue = GetSystemString(14323);
			break;
		case 2:
			RValue = GetSystemString(14324);
			break;
		case 3:
			RValue = GetSystemString(14322);
			break;
		case 4:
			RValue = GetSystemString(14321);
			break;
	}
	return RValue;	
}

private function InsertRecord(RichListCtrlRowData rowDataNew, int Index)
{
	local int i, lastIndex;
	local RichListCtrlRowData RowData;

	// End:0x2C
	if(Reward_RichList.GetRecordCount() == 0)
	{
		Reward_RichList.InsertRecord(rowDataNew);		
	}
	else
	{
		lastIndex = Reward_RichList.GetRecordCount() - 1;
		Reward_RichList.GetRec(lastIndex, RowData);
		Reward_RichList.InsertRecord(RowData);

		// End:0xCA [Loop If]
		for(i = lastIndex; i > Index; i--)
		{
			Reward_RichList.GetRec(i - 1, RowData);
			Reward_RichList.ModifyRecord(i, RowData);
		}
		Reward_RichList.ModifyRecord(Index, rowDataNew);
	}	
}

defaultproperties
{
}
