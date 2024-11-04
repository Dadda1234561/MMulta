class SkillSpExtractWnd extends UICommonAPI;

const ITEM_ID_SP_EXTRACT = 98232;
const ITEM_ID_SP = 15624;

struct SpExtractInfo
{
	var ItemInfo spExtractItemInfo;
	var ItemInfo spItemInfo;
	var INT64 haveSp;
	var UIPacket._S_EX_SP_EXTRACT_INFO Info;
};

var SpExtractInfo _spExctractInfo;
var WindowHandle Me;
var ItemWindowHandle itemWnd;
var ItemWindowHandle resultItemWnd;
var ItemWindowHandle resultCritLeftItemWnd;
var ItemWindowHandle resultCritRightItemWnd;
var TextBoxHandle criticalTextBox;
var TextBoxHandle itemNumTextBox;
var TextBoxHandle rateTextBox;
var TextBoxHandle itemNameTextBox;
var TextBoxHandle itemRateTextBox;
var TextBoxHandle dailyCntTextBox;
var TextBoxHandle dialogRateTextBox;
var TextBoxHandle resultItemNameTextBox;
var TextBoxHandle resultItemNumTextBox;
var TextBoxHandle resultDailyCntTextBox;
var TextBoxHandle resultDescTextBox;
var TextBoxHandle resultCritDailyCntTextBox;
var TextBoxHandle resultCritLeftItemNumTextBox;
var TextBoxHandle resultCritLeftItemNameTextBox;
var TextBoxHandle resultCritRightItemNumTextBox;
var TextBoxHandle resultCritRightItemNameTextBox;
var TextBoxHandle errorDescTextBox;
var ButtonHandle dailyInfoBtn;
var ButtonHandle criticalInfoBtn;
var ButtonHandle BuyBtn;
var ButtonHandle CloseBtn;
var WindowHandle dialogContainerWnd;
var WindowHandle confirmDialogWnd;
var WindowHandle resultDialogWnd;
var WindowHandle resultCriticalWnd;
var WindowHandle errorDialogWnd;
var UIControlNeedItemList needItemScript;
var UIControlNeedItemList dialogNeedItemScript;
var EffectViewportWndHandle ResultEffectViewport;

static function SkillSpExtractWnd Inst()
{
	return SkillSpExtractWnd(GetScript("SkillSpExtractWnd"));	
}

function Initialize()
{
	InitControls();	
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle needItemWnd, dialogNeedItemWnd;
	local RichListCtrlHandle needItemRichList, dialogNeedItemRichList;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	itemWnd = GetItemWindowHandle(ownerFullPath $ ".SpExtract_ItemWnd");
	criticalTextBox = GetTextBoxHandle(ownerFullPath $ ".Critical_Txt");
	itemNumTextBox = GetTextBoxHandle(ownerFullPath $ ".SpExtractNum_Txt");
	itemNameTextBox = GetTextBoxHandle(ownerFullPath $ ".SpExtractTitle_Txt");
	itemRateTextBox = GetTextBoxHandle(ownerFullPath $ ".Probability_Txt");
	dailyCntTextBox = GetTextBoxHandle(ownerFullPath $ ".DailyCount_Txt");
	dailyInfoBtn = GetButtonHandle(ownerFullPath $ ".Help01_Btn");
	criticalInfoBtn = GetButtonHandle(ownerFullPath $ ".Help02_Btn");
	BuyBtn = GetButtonHandle(ownerFullPath $ ".Ok_Btn");
	CloseBtn = GetButtonHandle(ownerFullPath $ ".Cancel_Btn");
	dialogContainerWnd = GetWindowHandle(ownerFullPath $ ".Dialog_Wnd");
	confirmDialogWnd = GetWindowHandle(dialogContainerWnd.m_WindowNameWithFullPath $ ".Production_Wnd");
	resultDialogWnd = GetWindowHandle(dialogContainerWnd.m_WindowNameWithFullPath $ ".Result_Wnd");
	dialogRateTextBox = GetTextBoxHandle(confirmDialogWnd.m_WindowNameWithFullPath $ ".Probabaility_Txt");
	resultItemWnd = GetItemWindowHandle(resultDialogWnd.m_WindowNameWithFullPath $ ".SpExtract_ItemWnd");
	resultItemNameTextBox = GetTextBoxHandle(resultDialogWnd.m_WindowNameWithFullPath $ ".SpExtractTitle_Txt");
	resultItemNumTextBox = GetTextBoxHandle(resultDialogWnd.m_WindowNameWithFullPath $ ".SpExtractNum_Txt");
	resultDailyCntTextBox = GetTextBoxHandle(resultDialogWnd.m_WindowNameWithFullPath $ ".DailyCount_Txt");
	resultDescTextBox = GetTextBoxHandle(resultDialogWnd.m_WindowNameWithFullPath $ ".Result_Txt");
	resultCriticalWnd = GetWindowHandle(resultDialogWnd.m_WindowNameWithFullPath $ ".Critical_Wnd");
	resultCritDailyCntTextBox = GetTextBoxHandle(resultCriticalWnd.m_WindowNameWithFullPath $ ".DailyCount_Txt");
	resultCritLeftItemNumTextBox = GetTextBoxHandle(resultCriticalWnd.m_WindowNameWithFullPath $ ".SpExtractNum1_Txt");
	resultCritLeftItemNameTextBox = GetTextBoxHandle(resultCriticalWnd.m_WindowNameWithFullPath $ ".SpExtractTitle1_Txt");
	resultCritLeftItemWnd = GetItemWindowHandle(resultCriticalWnd.m_WindowNameWithFullPath $ ".SpExtract1_ItemWnd");
	resultCritRightItemNumTextBox = GetTextBoxHandle(resultCriticalWnd.m_WindowNameWithFullPath $ ".SpExtractNum2_Txt");
	resultCritRightItemNameTextBox = GetTextBoxHandle(resultCriticalWnd.m_WindowNameWithFullPath $ ".SpExtractTitle2_Txt");
	resultCritRightItemWnd = GetItemWindowHandle(resultCriticalWnd.m_WindowNameWithFullPath $ ".SpExtract2_ItemWnd");
	ResultEffectViewport = GetEffectViewportWndHandle(resultDialogWnd.m_WindowNameWithFullPath $ ".EnchantEffectViewport");
	errorDialogWnd = GetWindowHandle(dialogContainerWnd.m_WindowNameWithFullPath $ ".Error_Wnd");
	errorDescTextBox = GetTextBoxHandle(errorDialogWnd.m_WindowNameWithFullPath $ ".Description_Txt");
	needItemWnd = GetWindowHandle(ownerFullPath $ ".Cost_Wnd");
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemRichList = GetRichListCtrlHandle(needItemWnd.m_WindowNameWithFullPath $ ".Cost_RichList");
	needItemScript.SetRichListControler(needItemRichList);
	needItemScript.__DelegateOnUpdateItem__Delegate = OnNeedItemUpdate;
	dialogNeedItemWnd = GetWindowHandle(confirmDialogWnd.m_WindowNameWithFullPath $ ".ProductionItemList_Wnd");
	dialogNeedItemWnd.SetScript("UIControlNeedItemList");
	dialogNeedItemScript = UIControlNeedItemList(dialogNeedItemWnd.GetScript());
	dialogNeedItemRichList = GetRichListCtrlHandle(dialogNeedItemWnd.m_WindowNameWithFullPath $ ".ProductionItemList_RichList");
	dialogNeedItemScript.SetRichListControler(dialogNeedItemRichList);	
}

function ResetInfo()
{
	local SpExtractInfo defaultInfo;

	_spExctractInfo = defaultInfo;
	_spExctractInfo.Info.nRate = 100;
	_spExctractInfo.Info.nCriticalRate = 0;	
}

function ShowConfirmDialog()
{
	UpdateConfirmDialogControls();
	confirmDialogWnd.ShowWindow();
	dialogContainerWnd.ShowWindow();	
}

function ShowResultDialog(UIPacket._S_EX_SP_EXTRACT_ITEM packet)
{
	local ItemInfo ResultItemInfo, criticalItemInfo;
	local int resultItemCnt;
	local string resultDesc;

	resultCriticalWnd.HideWindow();
	// End:0x1BB
	if(packet.cResult == 0)
	{
		ResultItemInfo = GetItemInfoByClassID(_spExctractInfo.Info.nItemID);
		resultItemCnt = _spExctractInfo.Info.nExtractCount;
		ShowResultEffect(true);
		// End:0x18E
		if(packet.bCritical == 1)
		{
			resultDesc = GetSystemString(14308);
			criticalItemInfo = GetItemInfoByClassID(_spExctractInfo.Info.criticalItem.nItemClassID);
			// End:0xC7
			if(! resultCritLeftItemWnd.SetItem(0, ResultItemInfo))
			{
				resultCritLeftItemWnd.AddItem(ResultItemInfo);
			}
			// End:0xF5
			if(! resultCritRightItemWnd.SetItem(0, criticalItemInfo))
			{
				resultCritRightItemWnd.AddItem(criticalItemInfo);
			}
			resultCritLeftItemNameTextBox.SetText(ResultItemInfo.Name);
			resultCritLeftItemNumTextBox.SetText(GetSystemString(2503) @ string(resultItemCnt));
			resultCritRightItemNameTextBox.SetText(criticalItemInfo.Name);
			resultCritRightItemNumTextBox.SetText(GetSystemString(2503) @ string(_spExctractInfo.Info.criticalItem.nAmount));
			resultCriticalWnd.ShowWindow();			
		}
		else
		{
			resultDesc = GetSystemString(13277);
		}
		class'SkillEnchantWnd'.static.Inst().ResetChargeInvenAndUpdate();		
	}
	else
	{
		// End:0x21F
		if(packet.cResult == 1)
		{
			ResultItemInfo = GetItemInfoByClassID(_spExctractInfo.Info.failedItem.nItemClassID);
			resultItemCnt = int(_spExctractInfo.Info.failedItem.nAmount);
			resultDesc = GetSystemString(14309);
			ShowResultEffect(false);
		}
	}
	// End:0x24D
	if(! resultItemWnd.SetItem(0, ResultItemInfo))
	{
		resultItemWnd.AddItem(ResultItemInfo);
	}
	resultItemNameTextBox.SetText(ResultItemInfo.Name);
	resultItemNumTextBox.SetText(GetSystemString(2503) @ string(resultItemCnt));
	resultDescTextBox.SetText(resultDesc);
	resultDialogWnd.ShowWindow();
	dialogContainerWnd.ShowWindow();	
}

function ShowErrorDialog(UIPacket._S_EX_SP_EXTRACT_ITEM packet)
{
	// End:0x2E
	if(packet.cResult == 3)
	{
		errorDescTextBox.SetText(GetSystemMessage(3675));		
	}
	else
	{
		errorDescTextBox.SetText(GetSystemMessage(4559));
	}
	errorDialogWnd.ShowWindow();
	dialogContainerWnd.ShowWindow();	
}

function ShowResultEffect(bool IsSuccess)
{
	// End:0x17
	if(Me.IsShowWindow() == false)
	{
		return;
	}
	// End:0xD2
	if(IsSuccess)
	{
		ResultEffectViewport.ShowWindow();
		ResultEffectViewport.SetScale(0.80f);
		ResultEffectViewport.SetCameraDistance(200.0f);
		ResultEffectViewport.SetCameraPitch(0);
		ResultEffectViewport.SetCameraYaw(0);
		ResultEffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_succ");
		PlaySound("Itemsound3.ui_enchant_success_sfx");		
	}
	else
	{
		ResultEffectViewport.ShowWindow();
		ResultEffectViewport.SetScale(0.80f);
		ResultEffectViewport.SetCameraDistance(200.0f);
		ResultEffectViewport.SetCameraPitch(0);
		ResultEffectViewport.SetCameraYaw(0);
		ResultEffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_fail");
		PlaySound("Itemsound3.ui_enchant_fail_sfx");
	}	
}

function CloseDialog()
{
	dialogContainerWnd.HideWindow();
	resultDialogWnd.HideWindow();
	confirmDialogWnd.HideWindow();
	errorDialogWnd.HideWindow();	
}

function UpdateItemInfoControls()
{
	local string tooltipStr;
	local ItemInfo criticalItemInfo;

	itemNameTextBox.SetText(_spExctractInfo.spExtractItemInfo.Name);
	itemNumTextBox.SetText(GetSystemString(2503) @ string(_spExctractInfo.Info.nExtractCount));
	dailyCntTextBox.SetText(GetSystemString(14305) @ string(_spExctractInfo.Info.nRemainCount) $ "/" $ string(_spExctractInfo.Info.nMaxDailyCount));
	// End:0xC8
	if(! itemWnd.SetItem(0, _spExctractInfo.spExtractItemInfo))
	{
		itemWnd.AddItem(_spExctractInfo.spExtractItemInfo);
	}
	// End:0xF0
	if(_spExctractInfo.Info.nRate >= 100)
	{
		itemRateTextBox.HideWindow();		
	}
	else
	{
		itemRateTextBox.SetText((GetSystemString(13938) @ ":") @ string(_spExctractInfo.Info.nRate) $ "%");
		itemRateTextBox.ShowWindow();
	}
	// End:0x16C
	if(_spExctractInfo.Info.nCriticalRate <= 0)
	{
		criticalTextBox.HideWindow();
		criticalInfoBtn.HideWindow();		
	}
	else
	{
		criticalTextBox.SetText(MakeFullSystemMsg(GetSystemMessage(13807), string(_spExctractInfo.Info.nCriticalRate)));
		criticalTextBox.ShowWindow();
		criticalItemInfo = GetItemInfoByClassID(_spExctractInfo.Info.criticalItem.nItemClassID);
		tooltipStr = MakeFullSystemMsg(GetSystemMessage(13814), criticalItemInfo.Name) @ "x" $ string(_spExctractInfo.Info.criticalItem.nAmount);
		criticalInfoBtn.SetTooltipCustomType(MakeTooltipSimpleText(tooltipStr));
		criticalInfoBtn.ShowWindow();
	}
	tooltipStr = MakeFullSystemMsg(GetSystemMessage(13813), string(_spExctractInfo.Info.nMaxDailyCount)) $ "\\n" $ GetSystemString(13872);
	dailyInfoBtn.SetTooltipCustomType(MakeTooltipSimpleText(tooltipStr));	
}

function UpdateCostInfoControls()
{
	local ItemInfo needSpItemInfo;
	local UIPacket._ItemInfo needAddItemInfo;

	needItemScript.StartNeedItemList(2);
	needItemScript.SetBuyNum(1);
	needSpItemInfo = _spExctractInfo.spItemInfo;
	needAddItemInfo = _spExctractInfo.Info.commissionItem;
	needItemScript.AddNeedPoint(needSpItemInfo.Name, needSpItemInfo.IconName, _spExctractInfo.Info.nNeedSP, _spExctractInfo.haveSp);
	// End:0xCC
	if(needAddItemInfo.nItemClassID > 0 && needAddItemInfo.nAmount > 0)
	{
		needItemScript.AddNeedItemClassID(needAddItemInfo.nItemClassID, needAddItemInfo.nAmount);
	}
	UpdateBuyBtnState();	
}

function UpdateBuyBtnState()
{
	// End:0x3C
	if(needItemScript.GetCanBuy() && _spExctractInfo.Info.nRemainCount != 0)
	{
		BuyBtn.SetEnable(true);		
	}
	else
	{
		BuyBtn.SetEnable(false);
	}	
}

function UpdateConfirmDialogControls()
{
	local ItemInfo needSpItemInfo;
	local UIPacket._ItemInfo needAddItemInfo;

	// End:0x28
	if(_spExctractInfo.Info.nRate >= 100)
	{
		dialogRateTextBox.HideWindow();		
	}
	else
	{
		dialogRateTextBox.SetText(GetSystemString(13938) @ ":" @ string(_spExctractInfo.Info.nRate) $ "%");
		dialogRateTextBox.ShowWindow();
	}
	dialogNeedItemScript.StartNeedItemList(2);
	dialogNeedItemScript.SetBuyNum(1);
	needSpItemInfo = _spExctractInfo.spItemInfo;
	needAddItemInfo = _spExctractInfo.Info.commissionItem;
	dialogNeedItemScript.AddNeedPoint(needSpItemInfo.Name, needSpItemInfo.IconName, _spExctractInfo.Info.nNeedSP, _spExctractInfo.haveSp);
	// End:0x13A
	if((needAddItemInfo.nItemClassID > 0) && needAddItemInfo.nAmount > 0)
	{
		dialogNeedItemScript.AddNeedItemClassID(needAddItemInfo.nItemClassID, needAddItemInfo.nAmount);
	}	
}

function UpdateResultDialogControls()
{
	local string dailyCntStr;

	dailyCntStr = GetSystemString(14305) @ string(_spExctractInfo.Info.nRemainCount) $ "/" $ string(_spExctractInfo.Info.nMaxDailyCount);
	resultDailyCntTextBox.SetText(dailyCntStr);
	resultCritDailyCntTextBox.SetText(dailyCntStr);	
}

function UpdateUIControls()
{
	UpdateItemInfoControls();
	UpdateCostInfoControls();
	UpdateResultDialogControls();	
}

function Rq_C_EX_SP_EXTRACT_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_SP_EXTRACT_INFO packet;

	packet.nItemID = ITEM_ID_SP_EXTRACT;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_SP_EXTRACT_INFO(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SP_EXTRACT_INFO, stream);	
}

function Rq_C_EX_SP_EXTRACT_ITEM()
{
	local array<byte> stream;
	local UIPacket._C_EX_SP_EXTRACT_ITEM packet;

	packet.nItemID = ITEM_ID_SP_EXTRACT;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_SP_EXTRACT_ITEM(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SP_EXTRACT_ITEM, stream);	
}

function Rs_S_EX_SP_EXTRACT_INFO()
{
	local UIPacket._S_EX_SP_EXTRACT_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_SP_EXTRACT_INFO(packet))
	{
		return;
	}
	_spExctractInfo.Info = packet;
	UpdateUIControls();
	Debug("Rs_S_EX_SP_EXTRACT_INFO" @ string(packet.nItemID) @ string(packet.nNeedSP) @ string(packet.nRate) @ string(packet.nCriticalRate) @ string(packet.nRemainCount) @ string(packet.nMaxDailyCount) @ string(packet.commissionItem.nAmount));	
}

function Rs_S_EX_SP_EXTRACT_ITEM()
{
	local UIPacket._S_EX_SP_EXTRACT_ITEM packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_SP_EXTRACT_ITEM(packet))
	{
		return;
	}
	Debug("Rs_S_EX_SP_EXTRACT_ITEM" @ string(packet.cResult) @ string(packet.nItemID) @ string(packet.bCritical));
	Rq_C_EX_SP_EXTRACT_INFO();
	// End:0x89
	if(packet.cResult < 2)
	{
		ShowResultDialog(packet);		
	}
	else
	{
		ShowErrorDialog(packet);
	}	
}

function Nt_EV_UpdateUserInfo()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	// End:0x40
	if(_spExctractInfo.haveSp != UserInfo.nSP)
	{
		_spExctractInfo.haveSp = UserInfo.nSP;
		UpdateCostInfoControls();
	}	
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_SP_EXTRACT_INFO));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_SP_EXTRACT_ITEM));
	RegisterEvent(EV_UpdateUserInfo);	
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();	
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_SP_EXTRACT_INFO):
			Rs_S_EX_SP_EXTRACT_INFO();
			// End:0x58
			break;
		// End:0x47
		case EV_PacketID(class'UIPacket'.const.S_EX_SP_EXTRACT_ITEM):
			Rs_S_EX_SP_EXTRACT_ITEM();
			// End:0x58
			break;
		// End:0x55
		case EV_UpdateUserInfo:
			Nt_EV_UpdateUserInfo();
			// End:0x58
			break;
	}	
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x1B
		case "Ok_Btn":
			ShowConfirmDialog();
			// End:0xBA
			break;
		// End:0x3C
		case "Cancel_Btn":
			Me.HideWindow();
			// End:0xBA
			break;
		// End:0x5D
		case "Dialog_Ok_Btn":
			Rq_C_EX_SP_EXTRACT_ITEM();
			CloseDialog();
			// End:0xBA
			break;
		// End:0x7C
		case "Dialog_Cancel_Btn":
			CloseDialog();
			// End:0xBA
			break;
		// End:0x97
		case "Result_Ok_Btn":
			CloseDialog();
			// End:0xBA
			break;
		// End:0xB7
		case "ErrorDialog_Ok_Btn":
			CloseDialog();
			// End:0xBA
			break;
	}	
}

event OnNeedItemUpdate()
{
	// End:0x18
	if(Me.IsShowWindow())
	{
		UpdateBuyBtnState();
	}	
}

event OnShow()
{
	local UserInfo UserInfo;

	Me.SetFocus();
	ResultEffectViewport.HideWindow();
	GetPlayerInfo(UserInfo);
	_spExctractInfo.haveSp = UserInfo.nSP;
	_spExctractInfo.spExtractItemInfo = GetItemInfoByClassID(ITEM_ID_SP_EXTRACT);
	_spExctractInfo.spItemInfo = GetItemInfoByClassID(ITEM_ID_SP);
	CloseDialog();
	UpdateUIControls();
	Rq_C_EX_SP_EXTRACT_INFO();	
}

event OnHide()
{
	CloseDialog();
	ResetInfo();
	needItemScript.CleariObjects();
	dialogNeedItemScript.CleariObjects();	
}

event OnReceivedCloseUI()
{
	// End:0x1B
	if(dialogContainerWnd.IsShowWindow())
	{
		CloseDialog();		
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}	
}

defaultproperties
{
}
