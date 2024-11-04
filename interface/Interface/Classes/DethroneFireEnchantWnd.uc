class DethroneFireEnchantWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle WindowHelp_BTN;
var WindowHandle disableWnd;
var WindowHandle UIControlDialogAsset;
var ButtonHandle FireButton;
var RichListCtrlHandle NeedItem_RichList;
var DethroneFireEnchantDetailStats DethroneFireEnchantDetailStatsScript;
var DethroneFireEnchantProcess DethroneFireEnchantProcessScript;
var DethroneFireEnchantChart DethroneFireEnchantChartScript;
var EffectViewportWndHandle EffectViewport02;
var UIControlNumberInputSteper numberInputStepper;
var UIControlNeedItemList needItemRichListScript;
var UIPacket._S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI OpenUI_Packet;
var UIPacket._EAOF_Element OpenUI_PacketElement;
var array<FireAbilityUIData> UIData;
var array<FireAbilityComboEffectUIData> effectUIData;
var int spIndex;
var int hpIndex;

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_UpdateMyHP);	
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	initDialogAssetes();
	InitNeedItemControl();
	InitUIControlNumberInputSteper();
	UIData.Length = 0;
}

function Initialize()
{
	Me = GetWindowHandle("DethroneFireEnchantWnd");
	WindowHelp_BTN = GetButtonHandle("DethroneFireEnchantWnd.WindowHelp_BTN");
	disableWnd = GetWindowHandle("DethroneFireEnchantWnd.DisableWnd");
	UIControlDialogAsset = GetWindowHandle("DethroneFireEnchantWnd.DisableWnd.UIControlDialogAsset");
	FireButton = GetButtonHandle("DethroneFireEnchantWnd.FireButton");
	NeedItem_RichList = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.NeedItem_RichList");
	DethroneFireEnchantChartScript = DethroneFireEnchantChart(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantChart"));
	DethroneFireEnchantDetailStatsScript = DethroneFireEnchantDetailStats(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantDetailStats"));
	DethroneFireEnchantProcessScript = DethroneFireEnchantProcess(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantProcess"));
	EffectViewport02 = GetEffectViewportWndHandle("DethroneFireEnchantWnd.EffectViewport02");
	GetWindowHandle("DethroneFireEnchantDetailStats").ShowWindow();
	GetWindowHandle("DethroneFireEnchantProcess").HideWindow();	
}

function OnShow()
{
	if(UIData.Length <= 0)
	{
		UIData.Length = 5;
		class'UIDataManager'.static.GetFireAbilityData(EFAT_PRIMAL_FIRE, UIData[0]);
		class'UIDataManager'.static.GetFireAbilityData(EFAT_PRIMAL_LIFE, UIData[1]);
		class'UIDataManager'.static.GetFireAbilityData(EFAT_PIECE_OF_FIRE, UIData[2]);
		class'UIDataManager'.static.GetFireAbilityData(EFAT_TOTEM_OF_FIRE, UIData[3]);
		class'UIDataManager'.static.GetFireAbilityData(EFAT_FIGHTING_SPIRIT, UIData[4]);
		class'UIDataManager'.static.GetFireAbilityComboEffectData(effectUIData);
		Debug("- 디스론 능력강화 Load Data - ");
	}
	Debug("onShow 디스론 인챈트 메인 창" @ string(DethroneFireEnchantChartScript.groupButtons._getSelectButtonIndex()));

	if(DethroneFireEnchantChartScript.groupButtons._getSelectButtonIndex() <= -1)
	{
		GetWindowHandle("DethroneFireEnchantDetailStats").ShowWindow();
		GetWindowHandle("DethroneFireEnchantProcess").HideWindow();
		DethroneFireEnchantChartScript.SetTopOrder(0);
	}
	refresh();
	DethroneFireEnchantChartScript.enableAll(true);
}

function OnHide()
{
	EffectViewport02.SpawnEffect("");
	DethroneFireEnchantProcessScript.InitHide();
	DethroneFireEnchantProcessScript.deleteRewardItems();
	DethroneFireEnchantProcessScript.initCheckBox();
	DethroneFireEnchantProcessScript.setCancelAutoStepNum();
	OnClickButton("cancelAutoNumStepPopUp_Btn");
}

function playResultEffectViewPort(string effectPath)
{
	if(effectPath == "LineageEffect2.ui_upgrade_succ")
	{
		PlaySound("Itemsound3.ui_enchant_success");
	}
	EffectViewport02.SetFocus();
	EffectViewport02.SpawnEffect(effectPath);
}

function dataParse()
{
	local int i, N, M;

	for(i = 0; i < 5; i++)
	{
		Debug("UIData[i].type " @ string(UIData[i].Type));
		Debug("UIData[i].DailyExpUpCount " @ string(UIData[i].DailyExpUpCount));
		Debug("UIData[i].DailyInitCount " @ string(UIData[i].DailyInitCount));
		Debug("UIData[i].DailyInitCost len:" @ string(UIData[i].DailyInitCost.Length));

		for(N = 0; N < UIData[i].DailyInitCost.Length; N++)
		{
			Debug("UIData[i].DailyInitCost itemClassID:" @ string(UIData[i].DailyInitCost[N].ItemClassID));
			Debug("UIData[i].DailyInitCost ItemAmount:" @ string(UIData[i].DailyInitCost[N].ItemAmount));
		}
		Debug("UIData[i].MaxLevel" @ string(UIData[i].MaxLevel));
		Debug("UIData[i].LevelupInfo len" @ string(UIData[i].LevelupInfo.Length));

		for(N = 0; N < UIData[i].LevelupInfo.Length; N++)
		{
			Debug("UIData[i].LevelupInfo Level " @ string(UIData[i].LevelupInfo[N].Level));
			Debug("UIData[i].LevelupInfo Exp" @ string(UIData[i].LevelupInfo[N].Exp));

			for(M = 0; M < UIData[i].LevelupInfo[N].ExpUpCostItem.Length; M++)
			{
				Debug("UIData[i].LevelupInfo ExpUpCostItem - ItemClassID" @ string(UIData[i].LevelupInfo[N].ExpUpCostItem[M].ItemClassID));
				Debug("UIData[i].LevelupInfo ExpUpCostItem - ItemAmount" @ string(UIData[i].LevelupInfo[N].ExpUpCostItem[M].ItemAmount));
			}
			Debug("UIData[i].LevelupInfo ExpUpSuccessRate" @ string(UIData[i].LevelupInfo[N].ExpUpSuccessRate));
			Debug("UIData[i].LevelupInfo[n].LevelUpCost.length" @ string(UIData[i].LevelupInfo[N].LevelUpCost.Length));

			for(M = 0; M < UIData[i].LevelupInfo[N].LevelUpCost.Length; M++)
			{
				Debug("UIData[i].LevelupInfo LevelUpCost - ItemClassID" @ string(UIData[i].LevelupInfo[N].LevelUpCost[M].ItemClassID));
				Debug("UIData[i].LevelupInfo LevelUpCost - ItemAmount" @ string(UIData[i].LevelupInfo[N].LevelUpCost[M].ItemAmount));
			}
			Debug("UIData[i].LevelupInfo[n].SkillEffect.length" @ string(UIData[i].LevelupInfo[N].SkillEffect.Length));

			for(M = 0; M < UIData[i].LevelupInfo[N].SkillEffect.Length; M++)
			{
				Debug("UIData[i].LevelupInfo SkillEffect" @ UIData[i].LevelupInfo[N].SkillEffect[M]);
			}
		}
	}	
}

function refresh()
{
	DethroneFireEnchantChartScript.groupButtons._setEnableAll();
	DethroneFireEnchantChartScript.refresh();

	if(GetWindowHandle("DethroneFireEnchantWnd.DethroneFireEnchantDetailStats").IsShowWindow())
	{
		Debug("메인창: 기본효과, 추가 효과 폼 갱신");
		DethroneFireEnchantDetailStatsScript.refresh();
	}
	else
	{
		Debug("메인창 인챈트 폼 갱신");
		DethroneFireEnchantProcessScript.refresh();
		DethroneFireEnchantProcessScript.initCheckBox();
	}
}

function InitNeedItemControl()
{
	needItemRichListScript = new class'UIControlNeedItemList';
	needItemRichListScript.SetRichListControler(GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.NeedItem_RichList"));
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.NeedItem_RichList").SetTooltipType("UIControlNeedItemList");
}

function DelegateOnUpdateItem()
{
	if(GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow() == false)
	{
		return;
	}

	if((needItemRichListScript.GetMaxNumCanBuy() > 0) && OpenUI_PacketElement.nExpUpCount > 0)
	{
	}
}

function InitUIControlNumberInputSteper()
{
	numberInputStepper = class'UIControlNumberInputSteper'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.NumberInputSteper"));
	numberInputStepper.DelegateOnChangeEditBox = ChangeTargetEnchant;
	numberInputStepper.DelegateESCKey = onEscPopup;
	numberInputStepper.m_hOwnerWnd.ShowWindow();
	numberInputStepper._SetDisable(false);
	numberInputStepper._setMaxLength(4);
}

function ChangeTargetEnchant(UIControlNumberInputSteper Target)
{
	local INT64 inputNum;

	Debug("-_- " @ string(Target._getEditNum()));
	inputNum = Min(Target._getEditNum(), int(needItemRichListScript.GetMaxNumCanBuy()));
	Debug("needItemRichListScript.GetMaxNumCanBuy() " @ string(needItemRichListScript.GetMaxNumCanBuy()));
	Debug("inputNum" @ string(inputNum));

	if(inputNum <= 0)
	{
		needItemRichListScript.SetBuyNum(1);
	}
	else
	{
		needItemRichListScript.SetBuyNum(inputNum);
	}

	if(inputNum > 0)
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.okAutoNumStepPopUp_Btn").EnableWindow();		
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.okAutoNumStepPopUp_Btn").DisableWindow();
	}
}

function initDialogAssetes()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = class'UIControlDialogAssets'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.UIControlDialogAsset"));
	disableWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd");
	popupExpandScript.SetDisableWindow(disableWnd);
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd", false);	
}

function UIControlDialogAssets GetDialogAssetScript()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.UIControlDialogAsset");
	return UIControlDialogAssets(poopExpandWnd.GetScript());
}

function ShowAutoNumStepPopup()
{
	disableWnd.ShowWindow();
	disableWnd.SetFocus();
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup").ShowWindow();
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup").SetFocus();
	GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.NumberInputSteper.ItemCount_EditBox").ShowWindow();
	setNeedItemCount();
}

function ShowDialogAsk(int dialogID)
{
	local string Message;
	local int N;
	local FireAbilityLevelupInfoUIData levelUPData;

	GetDialogAssetScript().SetDialogID(dialogID);

	if(dialogID == 1)
	{
		Message = GetSystemMessage(13810);
		GetDialogAssetScript().SetUseNeedItem(true);
		GetDialogAssetScript().StartNeedItemList(getSeletedUIData().DailyInitCost.Length);

		for(N = 0; N < getSeletedUIData().DailyInitCost.Length; N++)
		{
			GetDialogAssetScript().AddNeedItemClassID(getSeletedUIData().DailyInitCost[N].ItemClassID, getSeletedUIData().DailyInitCost[N].ItemAmount);
		}
	}
	else if(dialogID == 2)
	{
		levelUPData = getSelectedUIDataByLevel(getSelectedPacketDataElement().nLevel);
		Message = GetSystemMessage(13811);
		GetDialogAssetScript().SetUseNeedItem(true);
		GetDialogAssetScript().StartNeedItemList(levelUPData.LevelUpCost.Length);

		for(N = 0; N < levelUPData.LevelUpCost.Length; N++)
		{
			GetDialogAssetScript().AddNeedItemClassID(levelUPData.LevelUpCost[N].ItemClassID, levelUPData.LevelUpCost[N].ItemAmount);
		}
	}
	GetDialogAssetScript().SetDialogDesc(Message);
	GetDialogAssetScript().SetItemNum(1);
	GetDialogAssetScript().Show();
	GetDialogAssetScript().DelegateOnClickBuy = onClickDialog;
	GetDialogAssetScript().DelegateOnCancel = OnClickCancelDialog;
}

function onClickDialog()
{
	Debug("GetDialogAssetScript().GetDialogID: " @ string(GetDialogAssetScript().GetDialogID()));
	GetDialogAssetScript().Hide();

	if(GetDialogAssetScript().GetDialogID() == 1)
	{
		API_C_EX_ENHANCED_ABILITY_OF_FIRE_INIT(DethroneFireEnchantChartScript.getSelectedCType());
	}
	else
	{
		API_C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP(DethroneFireEnchantChartScript.getSelectedCType());
	}
}

function OnClickCancelDialog()
{
	GetDialogAssetScript().Hide();	
}

function OnClickButton(string Name)
{
	Debug("Name" @ Name);
	switch(Name)
	{
		case "WindowHelp_BTN":
			OnWindowHelp_BTNClick();
			break;
		case "FireButton":
			OnFireButtonClick();
			break;
		case "okAutoNumStepPopUp_Btn":
			disableWnd.HideWindow();
			GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup").HideWindow();
			DethroneFireEnchantProcessScript.setAutoStepNum(numberInputStepper._getEditNum(), true);
			break;
		case "cancelAutoNumStepPopUp_Btn":
			disableWnd.HideWindow();
			GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup").HideWindow();
			DethroneFireEnchantProcessScript.setCancelAutoStepNum();
			break;
	}	
}

function setNeedItemCount()
{
	local FireAbilityLevelupInfoUIData levelUPData;
	local int i;
	local UserInfo Info;

	levelUPData = getSelectedUIDataByLevel(getSelectedPacketDataElement().nLevel);
	OpenUI_PacketElement = getSelectedPacketDataElement();
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.EnchantCount_Text").SetText(string(OpenUI_PacketElement.nExpUpCount));
	needItemRichListScript.CleariObjects();
	needItemRichListScript.StartNeedItemList(levelUPData.ExpUpCostItem.Length);
	spIndex = -1;
	hpIndex = -1;
	Debug("숫자 입력 팝업창, 필요 아이템 수 " @ string(levelUPData.ExpUpCostItem.Length));

	for(i = 0; i < levelUPData.ExpUpCostItem.Length; i++)
	{
		if(levelUPData.ExpUpCostItem[i].ItemClassID == 82621)
		{
			GetPlayerInfo(Info);
			hpIndex = needItemRichListScript.AddNeeItemInfo(GetItemInfoByClassID(82621), levelUPData.ExpUpCostItem[i].ItemAmount, Info.nCurHP);
			continue;
		}

		if(levelUPData.ExpUpCostItem[i].ItemClassID == 82500)
		{
			GetPlayerInfo(Info);
			spIndex = needItemRichListScript.AddNeeItemInfo(GetItemInfoByClassID(82500), levelUPData.ExpUpCostItem[i].ItemAmount, Info.nSP);
			continue;
		}
		needItemRichListScript.AddNeeItemInfo(GetItemInfoByClassID(levelUPData.ExpUpCostItem[i].ItemClassID), levelUPData.ExpUpCostItem[i].ItemAmount, getInventoryItemNumByClassID(levelUPData.ExpUpCostItem[i].ItemClassID));
	}
	needItemRichListScript.SetBuyNum(1);
	numberInputStepper._setRangeMinMaxNum(1, Min(OpenUI_PacketElement.nExpUpCount, int(needItemRichListScript.GetMaxNumCanBuy())));
	numberInputStepper._setEditNum(Max(DethroneFireEnchantProcessScript.getAutoStepNum(), 1));
}

function OnWindowHelp_BTNClick()
{
	//class'HelpWnd'.static.ShowHelp(63, 5);	
}

function OnFireButtonClick();

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_GameStart:
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI):
			Debug("S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI");
			ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI();
			break;
		case EV_UpdateMyHP:
			break;
		case EV_UpdateUserInfo:
			break;
	}
}

function HandleUpdateUserInfo()
{
	local UserInfo UserInfo;

	if(GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow())
	{
		GetPlayerInfo(UserInfo);

		if((NeedItem_RichList.GetRecordCount() > 0) && spIndex > -1)
		{
			needItemRichListScript.ModifyCurrentAmount(spIndex, UserInfo.nSP);

			if((needItemRichListScript.GetMaxNumCanBuy() > 0) && OpenUI_PacketElement.nExpUpCount > 0)
			{
				numberInputStepper._setRangeMinMaxNum(1, Min(OpenUI_PacketElement.nExpUpCount, int(needItemRichListScript.GetMaxNumCanBuy())));				
			}
			else
			{
				numberInputStepper._setEditNum(0);
			}
			DelegateOnUpdateItem();
		}
	}
}

function HandleUpdateHP()
{
	local UserInfo UserInfo;

	if(GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow())
	{
		GetPlayerInfo(UserInfo);

		if((NeedItem_RichList.GetRecordCount() > 0) && hpIndex > -1)
		{
			needItemRichListScript.ModifyCurrentAmount(hpIndex, UserInfo.nCurHP);

			if((needItemRichListScript.GetMaxNumCanBuy() > 0) && OpenUI_PacketElement.nExpUpCount > 0)
			{
				numberInputStepper._setRangeMinMaxNum(1, Min(OpenUI_PacketElement.nExpUpCount, int(needItemRichListScript.GetMaxNumCanBuy())));				
			}
			else
			{
				numberInputStepper._setEditNum(0);
			}
			DelegateOnUpdateItem();
		}
	}
}

function ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI()
{
	if(! class'UIPacket'.static.Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI(OpenUI_Packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI :  " @ string(OpenUI_Packet.nSetEffectLevel));

	if(Me.IsShowWindow() == false)
	{
		Me.ShowWindow();
		Me.SetFocus();
	}
	else
	{
		refresh();
	}
}

function int getSetEffectLevel()
{
	return OpenUI_Packet.nSetEffectLevel;
}

function UIPacket._EAOF_Element getPacketDataElement(int cType)
{
	return OpenUI_Packet.elements[cType];
}

function UIPacket._EAOF_Element getSelectedPacketDataElement()
{
	return OpenUI_Packet.elements[DethroneFireEnchantChartScript.getSelectedCType()];
}

function updatePacketDataElement(int cType, int nEXP, int nExpUpCount)
{
	OpenUI_Packet.elements[cType].nEXP = nEXP;
	OpenUI_Packet.elements[cType].nExpUpCount = nExpUpCount;
}

function updatePacketDataElement_nInitCount(int cType, int nInitCount, int nExpUpCount)
{
	OpenUI_Packet.elements[cType].nInitCount = nInitCount;
	OpenUI_Packet.elements[cType].nExpUpCount = nExpUpCount;
}

function updatePacketDataElement_nLevel(int cType, int nLevel)
{
	OpenUI_Packet.elements[cType].nLevel = nLevel;
	OpenUI_Packet.elements[cType].nEXP = 0;	
}

function FireAbilityUIData getUIData(int cType)
{
	return UIData[cType];
}

function FireAbilityUIData getSeletedUIData()
{
	return UIData[DethroneFireEnchantChartScript.getSelectedCType()];
}

function FireAbilityLevelupInfoUIData getUIDataByLevel(int cType, int nLevel)
{
	local int i;
	local FireAbilityLevelupInfoUIData temp;

	for(i = 0; i < UIData[cType].LevelupInfo.Length; i++)
	{
		if(UIData[cType].LevelupInfo[i].Level == nLevel)
		{
			return UIData[cType].LevelupInfo[i];
		}
	}
	Debug("경고 : getUIDataByLevel level 이 이상하다. ");
	return temp;
}

function FireAbilityLevelupInfoUIData getSelectedUIDataByLevel(int nLevel)
{
	local int i;
	local FireAbilityLevelupInfoUIData temp;

	for(i = 0; i < UIData[DethroneFireEnchantChartScript.getSelectedCType()].LevelupInfo.Length; i++)
	{
		if(UIData[DethroneFireEnchantChartScript.getSelectedCType()].LevelupInfo[i].Level == nLevel)
		{
			return UIData[DethroneFireEnchantChartScript.getSelectedCType()].LevelupInfo[i];
		}
	}
	Debug("경고 : getSelectedUIDataByLevel level 이 이상하다. ");
	return temp;
}

function array<FireAbilityComboEffectUIData> getEffectUIData()
{
	return effectUIData;
}

function FireAbilityComboEffectUIData getEffectUIDataByLevel(int nLevel)
{
	local int i;
	local FireAbilityComboEffectUIData temp;

	for(i = 0; i < effectUIData.Length; i++)
	{
		if(effectUIData[i].Level == nLevel)
		{
			return effectUIData[i];
		}
	}
	Debug("경고 : getEffectUIData level 이 이상하다. ");
	return temp;
}

function API_C_EX_ENHANCED_ABILITY_OF_FIRE_INIT(int cType)
{
	local array<byte> stream;
	local UIPacket._C_EX_ENHANCED_ABILITY_OF_FIRE_INIT packet;

	packet.cType = cType;

	if(! class'UIPacket'.static.Encode_C_EX_ENHANCED_ABILITY_OF_FIRE_INIT(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_ENHANCED_ABILITY_OF_FIRE_INIT, stream);
	Debug("----> Api Call : C_EX_ENHANCED_ABILITY_OF_FIRE_INIT " @ string(cType));
}

function API_C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP(int cType)
{
	local array<byte> stream;
	local UIPacket._C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP packet;

	packet.cType = cType;

	if(! class'UIPacket'.static.Encode_C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP, stream);
	Debug("----> Api Call : C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP " @ string(cType));
}

function API_C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP(int cType)
{
	local array<byte> stream;
	local UIPacket._C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP packet;

	packet.cType = cType;

	if(! class'UIPacket'.static.Encode_C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP, stream);
	Debug("----> Api Call : C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP " @ string(cType));
}

function API_C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI, stream);
	Debug("----> Api Call : C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI");
}

function API_C_EX_HOLY_FIRE_OPEN_UI()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_HOLY_FIRE_OPEN_UI, stream);
	Debug("----> Api Call : C_EX_HOLY_FIRE_OPEN_UI");
}

function onEscPopup()
{
	if(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup").IsShowWindow())
	{
		GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.NumberInputSteper.ItemCount_EditBox").HideWindow();
	}	
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);

	if(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.UIControlDialogAsset").IsShowWindow())
	{
		OnClickCancelDialog();
	}
	else if(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup").IsShowWindow())
	{
		OnClickButton("cancelAutoNumStepPopUp_Btn");
	}
	else
	{
		GetWindowHandle("DethroneFireEnchantWnd").HideWindow();
	}
}

defaultproperties
{
}
