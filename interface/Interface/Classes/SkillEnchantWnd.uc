class SkillEnchantWnd extends UICommonAPI;

const ENCHANT_TYPE_UINT = 1000;
const COUNT_DIALOG_ID = 1;

struct SkillEnchantUIInfo
{
	var array<ChargeExpItem> invenItemInfos;
	var array<ChargeExpItem> chargeItemInfos;
	var array<int> subLevelInfos;
	var int enchantLevel;
	var int enchantMaxLavel;
	var SkillInfo SkillInfo;
	var int replaceSkillId;
	var UIPacket._S_EX_SKILL_ENCHANT_INFO enchantInfo;
};

struct ChargeExpectInfo
{
	var ItemInfo costItemInfo;
	var int totalPoint;
	var array<UIPacket._ItemServerInfo> chargeItems;
};

var WindowHandle Me;
var WindowHandle dialogContainerWnd;
var WindowHandle enchantDialogWnd;
var WindowHandle enchantResultDialogWnd;
var WindowHandle errorDialogWnd;
var WindowHandle costDisableWnd;
var UIControlDialogAssets chargeDialogAsset;
var ItemWindowHandle skillItemWnd;
var ItemWindowHandle invenItemWnd;
var ItemWindowHandle chargeItemWnd;
var ItemWindowHandle chargeCostItemWnd;
var TextBoxHandle skillNameTextBox;
var TextBoxHandle skillLevelTextBox;
var TextBoxHandle chargeProbTextBox;
var TextBoxHandle chargeCostTextBox;
var TextBoxHandle statusBarTextBox;
var TextBoxHandle maxLevelTextBox;
var TextBoxHandle skillEnchantLvTextBox;
var StatusBarHandle chargeStatusBar;
var StatusBarHandle chargeExpectStatusBar;
var UIControlNeedItemList needItemScript;
var UIControlNeedItemList dialogNeedItemScript;
var HtmlHandle currentDescHtml;
var HtmlHandle nextDescHtml;
var ButtonHandle chargeBtn;
var ButtonHandle EnchantBtn;
var EffectViewportWndHandle ResultEffectViewport;
var TextureHandle skillGradeTex;
var SkillEnchantUIInfo _info;
var bool _isNeedShowResult;
var int _enchantResult;
var bool _isOpenedDialog;

static function SkillEnchantWnd Inst()
{
	return SkillEnchantWnd(GetScript("SkillEnchantWnd"));	
}

function Initialize()
{
	InitControls();	
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle descContainerWnd, chargeContainerWnd, needItemWnd, dialogNeedItemWnd, chargeDialogWnd;

	local RichListCtrlHandle needItemRichList, dialogNeedItemRichList;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	skillItemWnd = GetItemWindowHandle(ownerFullPath $ ".SkillItem_ItemWindow");
	skillNameTextBox = GetTextBoxHandle(ownerFullPath $ ".SkillName_Txt");
	skillLevelTextBox = GetTextBoxHandle(ownerFullPath $ ".SkillLevel_Txt");
	skillEnchantLvTextBox = GetTextBoxHandle(ownerFullPath $ ".SkillEnchantNum_Txt");
	skillGradeTex = GetTextureHandle(ownerFullPath $ ".IconPanel_Tex");
	descContainerWnd = GetWindowHandle(ownerFullPath $ ".EnchantEffectItem_Wnd");
	currentDescHtml = GetHtmlHandle(descContainerWnd.m_WindowNameWithFullPath $ ".CurrentEffectDesc1_Txt");
	nextDescHtml = GetHtmlHandle(descContainerWnd.m_WindowNameWithFullPath $ ".CurrentEffectDesc2_Txt");
	maxLevelTextBox = GetTextBoxHandle(descContainerWnd.m_WindowNameWithFullPath $ ".MaxLevel_txt");
	chargeContainerWnd = GetWindowHandle(ownerFullPath $ ".EnchantInventory_Wnd");
	chargeProbTextBox = GetTextBoxHandle(chargeContainerWnd.m_WindowNameWithFullPath $ ".Probability_Txt");
	chargeStatusBar = GetStatusBarHandle(chargeContainerWnd.m_WindowNameWithFullPath $ ".statusCraftPoint");
	chargeStatusBar.SetDrawPoint(false);
	chargeExpectStatusBar = GetStatusBarHandle(chargeContainerWnd.m_WindowNameWithFullPath $ ".statusExpectPoint");
	chargeExpectStatusBar.SetDrawPoint(false);
	statusBarTextBox = GetTextBoxHandle(chargeContainerWnd.m_WindowNameWithFullPath $ ".StatusBar_Txt");
	invenItemWnd = GetItemWindowHandle(chargeContainerWnd.m_WindowNameWithFullPath $ ".Inventory_Wnd.InvenSlot_ItemWindow");
	chargeItemWnd = GetItemWindowHandle(chargeContainerWnd.m_WindowNameWithFullPath $ ".AbsorptionItem_Wnd.ChargeSlot_ItemWindow");
	chargeCostItemWnd = GetItemWindowHandle(chargeContainerWnd.m_WindowNameWithFullPath $ ".AbsorptionCost_ItemWindow");
	chargeCostTextBox = GetTextBoxHandle(chargeContainerWnd.m_WindowNameWithFullPath $ ".AbsorptionCost_Txt");
	chargeBtn = GetButtonHandle(chargeContainerWnd.m_WindowNameWithFullPath $ ".Absorption_Btn");
	EnchantBtn = GetButtonHandle(ownerFullPath $ ".Enchant_Btn");
	costDisableWnd = GetWindowHandle(chargeContainerWnd.m_WindowNameWithFullPath $ ".Disable_Wnd");
	dialogContainerWnd = GetWindowHandle(ownerFullPath $ ".Popup_Wnd");
	enchantDialogWnd = GetWindowHandle(dialogContainerWnd.m_WindowNameWithFullPath $ ".SkillEnchantPopup_Wnd");
	enchantResultDialogWnd = GetWindowHandle(dialogContainerWnd.m_WindowNameWithFullPath $ ".SkillEnchantResultPopup_Wnd");
	errorDialogWnd = GetWindowHandle(dialogContainerWnd.m_WindowNameWithFullPath $ ".Error_Wnd");
	ResultEffectViewport = GetEffectViewportWndHandle(enchantResultDialogWnd.m_WindowNameWithFullPath $ ".EnchantEffectViewport");
	chargeDialogWnd = GetWindowHandle(dialogContainerWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset");
	chargeDialogAsset = class'UIControlDialogAssets'.static.InitScript(chargeDialogWnd);
	chargeDialogAsset.__DelegateOnCancel__Delegate = OnChargeDialogCancel;
	chargeDialogAsset.__DelegateOnClickBuy__Delegate = OnChargeDialogConfirm;
	chargeDialogAsset.SetUseBuyItem(false);
	chargeDialogAsset.SetUseNeedItem(true);
	chargeDialogAsset.SetUseNumberInput(false);
	needItemWnd = GetWindowHandle(ownerFullPath $ ".Cost_Wnd");
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemRichList = GetRichListCtrlHandle(needItemWnd.m_WindowNameWithFullPath $ ".Cost_RichListCtrl");
	needItemScript.SetRichListControler(needItemRichList);
	dialogNeedItemWnd = GetWindowHandle(enchantDialogWnd.m_WindowNameWithFullPath $ ".Cost_Wnd");
	dialogNeedItemWnd.SetScript("UIControlNeedItemList");
	dialogNeedItemScript = UIControlNeedItemList(dialogNeedItemWnd.GetScript());
	dialogNeedItemRichList = GetRichListCtrlHandle(dialogNeedItemWnd.m_WindowNameWithFullPath $ ".Cost_RichListCtrl");
	dialogNeedItemScript.SetRichListControler(dialogNeedItemRichList);	
}

function ResetInfo()
{
	local SkillEnchantUIInfo defaultInfo;

	_info = defaultInfo;
	_isNeedShowResult = false;
	_enchantResult = 0;	
}

function int ConvertEnchantLevel(int SubLevel)
{
	local int enchantLevel;

	enchantLevel = SubLevel;
	// End:0x32
	if(SubLevel >= ENCHANT_TYPE_UINT)
	{
		enchantLevel = int(float(SubLevel) % ENCHANT_TYPE_UINT);
	}
	return enchantLevel;	
}

function int ConvertSubLevel(int enchantLevel)
{
	local int SubLevel;

	SubLevel = -1;
	// End:0x36
	if(enchantLevel < _info.subLevelInfos.Length)
	{
		SubLevel = _info.subLevelInfos[enchantLevel];
	}
	return SubLevel;	
}

function string ConvertHtmlDesc(string SkillDesc)
{
	local string htmlStr;

	htmlStr = SkillDesc;
	htmlStr = Substitute(htmlStr, "<", "&lt;", false);
	htmlStr = Substitute(htmlStr, ">", "&gt;", false);
	htmlStr = Substitute(htmlStr, "&lt;font", "<font", false);
	htmlStr = Substitute(htmlStr, "\"&gt;", "\">", false);
	htmlStr = Substitute(htmlStr, "&lt;/font&gt;", "</font>", false);
	htmlStr = Substitute(htmlStr, "\\n\\n", "<br>", false);
	htmlStr = Substitute(htmlStr, "\\n", "<br1>", false);
	htmlStr = htmlSetHtmlStart(htmlStr);
	return htmlStr;	
}

function string GetSkillGradeTextureName(int Grade)
{
	switch(Grade)
	{
		// End:0x39
		case 1:
			return "L2UI_NewTex.SkillWnd.SkillPanel_Magicbook01";
		// End:0x6C
		case 2:
			return "L2UI_NewTex.SkillWnd.SkillPanel_Magicbook02";
		// End:0x9F
		case 3:
			return "L2UI_NewTex.SkillWnd.SkillPanel_Magicbook03";
		// End:0xD2
		case 4:
			return "L2UI_NewTex.SkillWnd.SkillPanel_Magicbook04";
	}
	return "";
}

function string GetEnchantLvName(int enchantLevel)
{
	// End:0x0E
	if(enchantLevel <= 0)
	{
		return "";
	}
	return "+" $ string(enchantLevel);	
}

function string GetSkillLevelStr(int Level)
{
	// End:0x0E
	if(Level <= 0)
	{
		return "";
	}
	return "Lv." $ string(Level);	
}

function INT64 GetValidChargeCount(int itemSId, INT64 Count)
{
	local int leftPoint;
	local ChargeExpItem TargetInfo;
	local ChargeExpectInfo expectInfo;

	FindInvenChargeExpItem(itemSId, TargetInfo);
	expectInfo = GetChargeExpectInfo();
	leftPoint = _info.enchantInfo.nMaxExp - (expectInfo.totalPoint + _info.enchantInfo.nEXP);
	// End:0x5D
	if(leftPoint <= 0)
	{
		return 0;
	}
	return Min64(Count, appCeil(float(leftPoint) / float(TargetInfo.ChargeExp)));	
}

function InteractionChargeItem(bool isUnregister, ItemInfo TargetInfo, bool isAllItem)
{
	local int Index;
	local ItemInfo tmpItemInfo;
	local INT64 ItemNum;

	// End:0x4E
	if((isUnregister == false) && _info.enchantInfo.nEXP >= _info.enchantInfo.nMaxExp)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13101));
		return;
	}
	// End:0xB4
	if(isUnregister == true)
	{
		Index = chargeItemWnd.FindItem(TargetInfo.Id);
		// End:0xB1
		if(Index != -1)
		{
			chargeItemWnd.GetItem(Index, tmpItemInfo);
			ItemNum = tmpItemInfo.ItemNum;
		}		
	}
	else
	{
		Index = invenItemWnd.FindItem(TargetInfo.Id);
		// End:0x10B
		if(Index != -1)
		{
			invenItemWnd.GetItem(Index, tmpItemInfo);
			ItemNum = tmpItemInfo.ItemNum;
		}
	}
	// End:0x15D
	if(isAllItem == true)
	{
		// End:0x140
		if(isUnregister == true)
		{
			UnregisterChargeItem(TargetInfo.Id.ServerID, ItemNum);			
		}
		else
		{
			RegisterChargeItem(TargetInfo.Id.ServerID, ItemNum);
		}		
	}
	else
	{
		// End:0x184
		if(ItemNum > 1)
		{
			ShowItemCountDialog(isUnregister, TargetInfo, ItemNum);			
		}
		else
		{
			// End:0x1AB
			if(isUnregister == true)
			{
				UnregisterChargeItem(TargetInfo.Id.ServerID, 1);				
			}
			else
			{
				RegisterChargeItem(TargetInfo.Id.ServerID, 1);
			}
		}
	}
	UpdateInvenControls();
	UpdateChargeGaugeControls();	
}

function RegisterChargeItem(int itemSId, INT64 Count)
{
	local int i;
	local INT64 tmpItemNum;
	local ChargeExpItem invenChargeExpItem;
	local INT64 validCount;

	validCount = GetValidChargeCount(itemSId, Count);
	// End:0x26
	if(validCount == 0)
	{
		return;
	}
	// End:0x10B [Loop If]
	for(i = 0; i < _info.chargeItemInfos.Length; i++)
	{
		invenChargeExpItem = _info.chargeItemInfos[i];
		// End:0x101
		if(invenChargeExpItem.item.Id.ServerID == itemSId)
		{
			tmpItemNum = invenChargeExpItem.item.ItemNum + validCount;
			invenChargeExpItem.item.ItemNum = tmpItemNum;
			_info.chargeItemInfos[i] = invenChargeExpItem;
			Debug("RegisterChargeItem : " @ string(itemSId) @ string(Count) @ string(validCount) @ string(tmpItemNum));
			return;
		}
	}
	// End:0x16F
	if(FindInvenChargeExpItem(itemSId, invenChargeExpItem) == true)
	{
		invenChargeExpItem.item.ItemNum = validCount;
		_info.chargeItemInfos.Length = _info.chargeItemInfos.Length + 1;
		_info.chargeItemInfos[_info.chargeItemInfos.Length - 1] = invenChargeExpItem;
	}	
}

function UnregisterChargeItem(int itemSId, INT64 Count)
{
	local int i, RemoveIndex;
	local INT64 tmpItemNum;
	local ChargeExpItem invenChargeExpItem;

	// End:0xFD [Loop If]
	for(i = 0; i < _info.chargeItemInfos.Length; i++)
	{
		invenChargeExpItem = _info.chargeItemInfos[i];
		// End:0xF3
		if(invenChargeExpItem.item.Id.ServerID == itemSId)
		{
			tmpItemNum = invenChargeExpItem.item.ItemNum - Count;
			// End:0x8C
			if(tmpItemNum <= 0)
			{
				RemoveIndex = i;
				// [Explicit Break]
				break;
				// [Explicit Continue]
				continue;
			}
			invenChargeExpItem.item.ItemNum = tmpItemNum;
			_info.chargeItemInfos[i] = invenChargeExpItem;
			Debug((("UnregisterChargeItem : " @ string(itemSId)) @ string(Count)) @ string(tmpItemNum));
			return;
		}
	}
	_info.chargeItemInfos.Remove(RemoveIndex, 1);	
}

function bool FindRegisteredChargeItem(int itemSId, out ItemInfo ItemInfo)
{
	local int i;
	local ChargeExpItem tempInfo;

	// End:0x6C [Loop If]
	for(i = 0; i < _info.chargeItemInfos.Length; i++)
	{
		tempInfo = _info.chargeItemInfos[i];
		// End:0x62
		if(tempInfo.item.Id.ServerID == itemSId)
		{
			ItemInfo = tempInfo.item;
			return true;
		}
	}
	return false;	
}

function bool FindInvenChargeExpItem(int itemSId, out ChargeExpItem outinfo)
{
	local int i;
	local ChargeExpItem tempInfo;

	// End:0x67 [Loop If]
	for(i = 0; i < _info.invenItemInfos.Length; i++)
	{
		tempInfo = _info.invenItemInfos[i];
		// End:0x5D
		if(tempInfo.item.Id.ServerID == itemSId)
		{
			outinfo = tempInfo;
			return true;
		}
	}
	return false;	
}

function ChargeExpectInfo GetChargeExpectInfo()
{
	local ChargeExpectInfo resultInfo;
	local ChargeExpItem tmpExpItemInfo;
	local UIPacket._ItemServerInfo tmpServerItem;
	local array<UIPacket._ItemServerInfo> chargeItems;
	local ItemInfo CostItem;
	local INT64 totalCost;
	local int totalPoint, i;

	for(i = 0; i < _info.chargeItemInfos.Length; i++)
	{
		tmpExpItemInfo = _info.chargeItemInfos[i];
		totalPoint = totalPoint + (int(tmpExpItemInfo.item.ItemNum) * tmpExpItemInfo.ChargeExp);
		// End:0x7D
		if(i == 0)
		{
			CostItem = GetItemInfoByClassID(tmpExpItemInfo.commissionItemId);
		}
		totalCost = totalCost + (tmpExpItemInfo.CommissionCount * tmpExpItemInfo.item.ItemNum);
		tmpServerItem.nItemServerId = tmpExpItemInfo.item.Id.ServerID;
		tmpServerItem.nAmount = tmpExpItemInfo.item.ItemNum;
		chargeItems[chargeItems.Length] = tmpServerItem;
	}
	CostItem.ItemNum = totalCost;
	resultInfo.costItemInfo = CostItem;
	resultInfo.chargeItems = chargeItems;
	resultInfo.totalPoint = totalPoint;
	return resultInfo;	
}

function ShowItemCountDialog(bool isUnregister, ItemInfo ItemInfo, INT64 maxNum)
{
	DialogHide();
	DialogSetReservedItemID(ItemInfo.Id);
	DialogSetReservedInt(int(isUnregister));
	DialogSetReservedInt2(maxNum);
	DialogSetParamInt64(maxNum);
	DialogSetID(1);
	DialogSetCancelD(1);
	_isOpenedDialog = true;
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), ItemInfo.Name), string(self));
	dialogContainerWnd.ShowWindow();
	class'DialogBox'.static.Inst().AnchorToOwner(0, 100);
	class'DialogBox'.static.Inst().DelegateOnCancel = OnItemCountDialogCancel;
	class'DialogBox'.static.Inst().DelegateOnOK = OnItemCountDialogConfirm;
	class'DialogBox'.static.Inst().DelegateOnHide = OnItemCountDialogHide;
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultOK);	
}

function ShowChargeDialog()
{
	local string htmlDescText;
	local ChargeExpectInfo expectInfo;

	expectInfo = GetChargeExpectInfo();
	chargeDialogAsset.StartNeedItemList(1);
	htmlDescText = htmlSetHtmlStart(htmlAddText(GetSystemString(14162), "") $ "<br><br>" $ htmlAddText(GetSystemString(14163), "", getColorHexString(GTColor().Red)));
	chargeDialogAsset.SetDialogDesc(htmlDescText, 0, 0, true);
	chargeDialogAsset.AddNeedItemClassID(expectInfo.costItemInfo.Id.ClassID, expectInfo.costItemInfo.ItemNum);
	chargeDialogAsset.SetItemNum(1);
	chargeDialogAsset.Show();
	dialogContainerWnd.ShowWindow();	
}

function ShowEnchantDialog()
{
	local ItemInfo skillItemInfo;
	local ItemWindowHandle itemWnd;
	local TextBoxHandle skillNameTextBox, currentELvTextBox, nextELvTextBox, probTextBox;
	local ButtonHandle confirmBtn;

	itemWnd = GetItemWindowHandle(enchantDialogWnd.m_WindowNameWithFullPath $ ".SkillItem_ItemWindow");
	skillNameTextBox = GetTextBoxHandle(enchantDialogWnd.m_WindowNameWithFullPath $ ".SkillName_Txt");
	currentELvTextBox = GetTextBoxHandle(enchantDialogWnd.m_WindowNameWithFullPath $ ".PrvEnchantNum_Txt");
	nextELvTextBox = GetTextBoxHandle(enchantDialogWnd.m_WindowNameWithFullPath $ ".NextEnchantNum_Txt");
	probTextBox = GetTextBoxHandle(enchantDialogWnd.m_WindowNameWithFullPath $ ".Probability_Txt");
	confirmBtn = GetButtonHandle(enchantDialogWnd.m_WindowNameWithFullPath $ ".EnchantDialog_Ok_Btn");
	// End:0x158
	if(_info.SkillInfo.LevelHide == true)
	{
		skillNameTextBox.SetText(_info.SkillInfo.SkillName);		
	}
	else
	{
		skillNameTextBox.SetText(_info.SkillInfo.SkillName @ GetSkillLevelStr(_info.SkillInfo.SkillLevel));
	}
	probTextBox.SetText(GetSystemString(13938) @ ":" @ ConvertFloatToString(float(_info.enchantInfo.nProbPerHundred) / float(100), 2, false) $ "%");
	currentELvTextBox.SetText("+" $ string(_info.enchantLevel));
	nextELvTextBox.SetText("+" $ string(_info.enchantLevel + 1));
	class'L2Util'.static.GetSkill2ItemInfo(_info.SkillInfo, skillItemInfo);
	skillItemInfo.Id.ClassID = 0;
	skillItemInfo.SubLevel = 0;
	// End:0x27F
	if(! itemWnd.SetItem(0, skillItemInfo))
	{
		itemWnd.AddItem(skillItemInfo);
	}
	dialogNeedItemScript.StartNeedItemList(1);
	// End:0x2F2
	if(_info.enchantInfo.commissionItem.nItemClassID != 0)
	{
		dialogNeedItemScript.AddNeedItemClassID(_info.enchantInfo.commissionItem.nItemClassID, _info.enchantInfo.commissionItem.nAmount);
		dialogNeedItemScript.SetBuyNum(1);
	}
	// End:0x35D
	if(dialogNeedItemScript.GetMaxNumCanBuy() > 0 && _info.enchantInfo.nEXP >= _info.enchantInfo.nMaxExp && _info.enchantLevel < _info.enchantMaxLavel)
	{
		confirmBtn.SetEnable(true);		
	}
	else
	{
		confirmBtn.SetEnable(false);
	}
	enchantDialogWnd.ShowWindow();
	dialogContainerWnd.ShowWindow();	
}

function ShowEnchantResultDialog(int Result)
{
	local ItemInfo skillItemInfo;
	local ItemWindowHandle itemWnd;
	local TextBoxHandle skillNameTextBox, currentELvTextBox, resultTextBox;
	local string resultStr;

	itemWnd = GetItemWindowHandle(enchantResultDialogWnd.m_WindowNameWithFullPath $ ".SkillItem_ItemWindow");
	skillNameTextBox = GetTextBoxHandle(enchantResultDialogWnd.m_WindowNameWithFullPath $ ".SkillName_Txt");
	currentELvTextBox = GetTextBoxHandle(enchantResultDialogWnd.m_WindowNameWithFullPath $ ".PrvEnchantNum_Txt");
	resultTextBox = GetTextBoxHandle(enchantResultDialogWnd.m_WindowNameWithFullPath $ ".Result_Txt");
	// End:0xEF
	if(_info.SkillInfo.LevelHide == true)
	{
		skillNameTextBox.SetText(_info.SkillInfo.SkillName);		
	}
	else
	{
		skillNameTextBox.SetText(_info.SkillInfo.SkillName @ (GetSkillLevelStr(_info.SkillInfo.SkillLevel)));
	}
	currentELvTextBox.SetText(GetEnchantLvName(_info.enchantLevel));
	class'L2Util'.static.GetSkill2ItemInfo(_info.SkillInfo, skillItemInfo);
	skillItemInfo.Id.ClassID = 0;
	skillItemInfo.SubLevel = 0;
	// End:0x1AC
	if(! itemWnd.SetItem(0, skillItemInfo))
	{
		itemWnd.AddItem(skillItemInfo);
	}
	// End:0x1D2
	if(Result == 0)
	{
		resultStr = GetSystemString(14364);
		ShowResultEffect(true);		
	}
	else if(Result == 1)
	{
		resultStr = GetSystemString(14365) $ "\\n" $ MakeFullSystemMsg(GetSystemMessage(13812), MakeCostString(string(_info.enchantInfo.nEXP)));
		ShowResultEffect(false);			
	}
	else
	{
		resultStr = GetSystemMessage(4559);
	}
	resultTextBox.SetText(resultStr);
	enchantResultDialogWnd.ShowWindow();
	dialogContainerWnd.ShowWindow();	
}

function ShowErrorDialog()
{
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
	// End:0xD5
	if(IsSuccess)
	{
		ResultEffectViewport.ShowWindow();
		ResultEffectViewport.SetScale(2.40f);
		ResultEffectViewport.SetCameraDistance(200.0f);
		ResultEffectViewport.SetCameraPitch(0);
		ResultEffectViewport.SetCameraYaw(0);
		ResultEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_success");
		PlaySound("Itemsound3.ui_enchant_success_sfx");		
	}
	else
	{
		ResultEffectViewport.ShowWindow();
		ResultEffectViewport.SetScale(2.40f);
		ResultEffectViewport.SetCameraDistance(200.0f);
		ResultEffectViewport.SetCameraPitch(0);
		ResultEffectViewport.SetCameraYaw(0);
		ResultEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_fail");
		PlaySound("Itemsound3.ui_enchant_fail_sfx");
	}	
}

function OpenWindow(int SkillID, int Level, int SubLevel, int replaceSkillId)
{
	local SkillInfo SkillInfo, replaceSkillInfo;

	// End:0x30
	if(! GetSkillInfo(SkillID, Level, SubLevel, SkillInfo))
	{
		Me.HideWindow();
		return;
	}
	_info.SkillInfo = SkillInfo;
	_info.replaceSkillId = replaceSkillId;
	// End:0xC8
	if((replaceSkillId >= 0) && GetSkillInfo(replaceSkillId, Level, SubLevel, replaceSkillInfo))
	{
		_info.SkillInfo.SkillName = replaceSkillInfo.SkillName;
		_info.SkillInfo.Grade = replaceSkillInfo.Grade;
		_info.SkillInfo.TexName = replaceSkillInfo.TexName;
	}
	// End:0xF9
	if(GetSkillSubLevelList(SkillID, Level, _info.subLevelInfos) == 0)
	{
		Me.HideWindow();
		return;
	}
	_info.enchantMaxLavel = _info.subLevelInfos.Length - 1;
	_info.enchantLevel = ConvertEnchantLevel(SubLevel);
	UpdateUIControls();
	Rq_C_EX_SKILL_ENCHANT_INFO(SkillID, Level, SubLevel);
	Me.ShowWindow();	
}

function CloseDialog()
{
	dialogContainerWnd.HideWindow();
	enchantDialogWnd.HideWindow();
	enchantResultDialogWnd.HideWindow();
	chargeDialogAsset.Hide();
	errorDialogWnd.HideWindow();	
}

function UpdateSkillInfoControls()
{
	local ItemInfo skillItemInfo;
	local SkillInfo tempSkillInfo, descSkillInfo;

	skillNameTextBox.SetText(_info.SkillInfo.SkillName);
	// End:0x74
	if(_info.replaceSkillId >= 0 && GetSkillInfo(_info.replaceSkillId, _info.SkillInfo.SkillLevel, _info.SkillInfo.SkillSubLevel, tempSkillInfo))
	{
		descSkillInfo = tempSkillInfo;		
	}
	else
	{
		descSkillInfo = _info.SkillInfo;
	}
	// End:0xAE
	if(_info.SkillInfo.LevelHide == true)
	{
		skillLevelTextBox.SetText("");		
	}
	else
	{
		skillLevelTextBox.SetText(GetSkillLevelStr(_info.SkillInfo.SkillLevel));
	}
	skillEnchantLvTextBox.SetText(GetEnchantLvName(_info.enchantLevel));
	// End:0x12E
	if(skillEnchantLvTextBox.GetText() == "")
	{
		skillEnchantLvTextBox.SetWindowSize(0, skillEnchantLvTextBox.GetRect().nHeight);		
	}
	else
	{
		skillEnchantLvTextBox.SetText(skillEnchantLvTextBox.GetText() $ " ");
	}
	class'L2Util'.static.GetSkill2ItemInfo(_info.SkillInfo, skillItemInfo);
	skillItemInfo.Id.ClassID = 0;
	skillItemInfo.SubLevel = 0;
	// End:0x1BA
	if(! skillItemWnd.SetItem(0, skillItemInfo))
	{
		skillItemWnd.AddItem(skillItemInfo);
	}
	skillGradeTex.SetTexture(GetSkillGradeTextureName(_info.SkillInfo.Grade));
	currentDescHtml.LoadHtmlFromString(ConvertHtmlDesc(descSkillInfo.SkillDesc));
	// End:0x24E
	if(_info.enchantLevel == _info.enchantMaxLavel)
	{
		nextDescHtml.LoadHtmlFromString(ConvertHtmlDesc(""));
		maxLevelTextBox.ShowWindow();
		costDisableWnd.ShowWindow();		
	}
	else
	{
		GetSkillInfo(descSkillInfo.SkillID, _info.SkillInfo.SkillLevel, ConvertSubLevel(_info.enchantLevel + 1), tempSkillInfo);
		nextDescHtml.LoadHtmlFromString(ConvertHtmlDesc(tempSkillInfo.SkillDesc));
		maxLevelTextBox.HideWindow();
		costDisableWnd.HideWindow();
	}	
}

function UpdateEnchantInfoControls()
{
	needItemScript.StartNeedItemList(1);
	// End:0x73
	if(_info.enchantInfo.commissionItem.nItemClassID != 0)
	{
		needItemScript.AddNeedItemClassID(_info.enchantInfo.commissionItem.nItemClassID, _info.enchantInfo.commissionItem.nAmount);
		needItemScript.SetBuyNum(1);
	}
	// End:0xDE
	if(needItemScript.GetMaxNumCanBuy() > 0 && _info.enchantInfo.nEXP >= _info.enchantInfo.nMaxExp && _info.enchantLevel < _info.enchantMaxLavel)
	{
		EnchantBtn.SetEnable(true);		
	}
	else
	{
		EnchantBtn.SetEnable(false);
	}	
}

function UpdateChargeGaugeControls()
{
	local ChargeExpectInfo ChargeExpectInfo;
	local bool isDisableChargeBtn;

	chargeProbTextBox.SetText(GetSystemString(13938) @ ":" @ ConvertFloatToString(float(_info.enchantInfo.nProbPerHundred) / 100, 2, false) $ "%");
	chargeStatusBar.SetPoint(_info.enchantInfo.nEXP, _info.enchantInfo.nMaxExp);
	ChargeExpectInfo = GetChargeExpectInfo();
	chargeExpectStatusBar.SetPoint(_info.enchantInfo.nEXP + ChargeExpectInfo.totalPoint, _info.enchantInfo.nMaxExp);
	chargeCostTextBox.SetText(MakeCostStringINT64(ChargeExpectInfo.costItemInfo.ItemNum));
	statusBarTextBox.SetText(MakeCostString(string(_info.enchantInfo.nEXP + ChargeExpectInfo.totalPoint)) @ "/" @ MakeCostString(string(_info.enchantInfo.nMaxExp)));
	// End:0x16C
	if(! chargeCostItemWnd.SetItem(0, ChargeExpectInfo.costItemInfo))
	{
		chargeCostItemWnd.AddItem(ChargeExpectInfo.costItemInfo);
	}
	// End:0x1A1
	if(_info.enchantInfo.nEXP >= _info.enchantInfo.nMaxExp)
	{
		chargeBtn.SetEnable(false);
		return;
	}
	// End:0x1B9
	if(ChargeExpectInfo.totalPoint == 0)
	{
		isDisableChargeBtn = true;
	}
	// End:0x20C
	if(GetInventoryItemCount(ChargeExpectInfo.costItemInfo.Id) < ChargeExpectInfo.costItemInfo.ItemNum)
	{
		chargeCostTextBox.SetTextColor(getInstanceL2Util().DRed);
		isDisableChargeBtn = true;		
	}
	else
	{
		chargeCostTextBox.SetTextColor(getInstanceL2Util().White);
	}
	chargeBtn.SetEnable(! isDisableChargeBtn);	
}

function UpdateInvenControls()
{
	local int i;
	local INT64 tmpItemNum;
	local array<ChargeExpItem> invenInfos;
	local ItemInfo tmpInvenItemInfo, tmpChargeItemInfo;

	GetEnchantExpItemListFromInven(_info.SkillInfo.Grade, invenInfos);
	_info.invenItemInfos = invenInfos;
	invenItemWnd.Clear();
	chargeItemWnd.Clear();

	// End:0x11B [Loop If]
	for(i = 0; i < invenInfos.Length; i++)
	{
		tmpInvenItemInfo = invenInfos[i].item;
		// End:0xFD
		if((FindRegisteredChargeItem(tmpInvenItemInfo.Id.ServerID, tmpChargeItemInfo)) == true)
		{
			// End:0xFA
			if(IsStackableItem(tmpChargeItemInfo.ConsumeType) == true)
			{
				tmpItemNum = tmpInvenItemInfo.ItemNum - tmpChargeItemInfo.ItemNum;
				// End:0xFA
				if(tmpItemNum > 0)
				{
					tmpInvenItemInfo.ItemNum = tmpItemNum;
					invenItemWnd.AddItem(tmpInvenItemInfo);
				}
			}
			// [Explicit Continue]
			continue;
		}
		invenItemWnd.AddItem(tmpInvenItemInfo);
	}

	// End:0x170 [Loop If]
	for(i = 0; i < _info.chargeItemInfos.Length; i++)
	{
		tmpInvenItemInfo = _info.chargeItemInfos[i].item;
		chargeItemWnd.AddItem(tmpInvenItemInfo);
	}	
}

function UpdateUIControls()
{
	UpdateSkillInfoControls();
	UpdateInvenControls();
	UpdateChargeGaugeControls();
	UpdateEnchantInfoControls();	
}

function ResetChargeInvenAndUpdate()
{
	_info.chargeItemInfos.Length = 0;
	// End:0x25
	if(Me.IsShowWindow())
	{
		UpdateUIControls();
	}	
}

function Rq_C_EX_SKILL_ENCHANT_INFO(int SkillID, int Level, int SubLevel)
{
	local array<byte> stream;
	local UIPacket._C_EX_SKILL_ENCHANT_INFO packet;

	packet.nSkillID = SkillID;
	packet.nLevel = Level;
	packet.nSubLevel = SubLevel;
	// End:0x50
	if(! class'UIPacket'.static.Encode_C_EX_SKILL_ENCHANT_INFO(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SKILL_ENCHANT_INFO, stream);	
}

function Rq_C_EX_SKILL_ENCHANT_CHARGE(int SkillID, int Level, int SubLevel, array<UIPacket._ItemServerInfo> Items)
{
	local array<byte> stream;
	local UIPacket._C_EX_SKILL_ENCHANT_CHARGE packet;

	packet.nSkillID = SkillID;
	packet.nLevel = Level;
	packet.nSubLevel = SubLevel;
	packet.Items = Items;
	// End:0x60
	if(! class'UIPacket'.static.Encode_C_EX_SKILL_ENCHANT_CHARGE(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SKILL_ENCHANT_CHARGE, stream);	
}

function Rq_C_EX_REQ_ENCHANT_SKILL(int SkillID, int Level, int nextSubLevel)
{
	RequestExEnchantSkill(0, SkillID, Level, nextSubLevel);	
}

function Rs_S_EX_SKILL_ENCHANT_INFO()
{
	local UIPacket._S_EX_SKILL_ENCHANT_INFO packet;
	local SkillInfo newSkillInfo, newReplaceSkillInfo;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_SKILL_ENCHANT_INFO(packet))
	{
		return;
	}
	_info.enchantInfo = packet;
	GetSkillInfo(_info.SkillInfo.SkillID, _info.SkillInfo.SkillLevel, packet.nSubLevel, newSkillInfo);
	_info.SkillInfo = newSkillInfo;
	// End:0xFF
	if((_info.replaceSkillId >= 0) && GetSkillInfo(_info.replaceSkillId, _info.SkillInfo.SkillLevel, packet.nSubLevel, newReplaceSkillInfo))
	{
		_info.SkillInfo.SkillName = newReplaceSkillInfo.SkillName;
		_info.SkillInfo.Grade = newReplaceSkillInfo.Grade;
		_info.SkillInfo.TexName = newReplaceSkillInfo.TexName;
	}
	_info.enchantLevel = ConvertEnchantLevel(packet.nSubLevel);
	// End:0x139
	if(_isNeedShowResult == true)
	{
		_isNeedShowResult = false;
		ShowEnchantResultDialog(_enchantResult);
	}
	UpdateUIControls();	
}

function Rs_S_EX_SKILL_ENCHANT_CHARGE()
{
	local UIPacket._S_EX_SKILL_ENCHANT_CHARGE packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_SKILL_ENCHANT_CHARGE(packet))
	{
		return;
	}
	// End:0x34
	if(packet.cReault == 0)
	{
		ResetChargeInvenAndUpdate();		
	}
	else
	{
		Debug("Rs_S_EX_SKILL_ENCHANT_CHARGE ERROR");
	}
	Debug(("Rs_S_EX_SKILL_ENCHANT_CHARGE" @ string(packet.nSkillID)) @ string(packet.cReault));	
}

function Rs_EV_SkillEnchantResult(string param)
{
	local int Result;

	ParseInt(param, "success", Result);
	_isNeedShowResult = true;
	_enchantResult = Result;
	Debug("Rs_EV_SkillEnchantResult" @ param);	
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_SKILL_ENCHANT_INFO));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_SKILL_ENCHANT_CHARGE));
	RegisterEvent(EV_SkillEnchantResult);	
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_SKILL_ENCHANT_INFO):
			Rs_S_EX_SKILL_ENCHANT_INFO();
			// End:0x60
			break;
		// End:0x47
		case EV_PacketID(class'UIPacket'.const.S_EX_SKILL_ENCHANT_CHARGE):
			Rs_S_EX_SKILL_ENCHANT_CHARGE();
			// End:0x60
			break;
		// End:0x5D
		case EV_SkillEnchantResult:
			Rs_EV_SkillEnchantResult(param);
			// End:0x60
			break;
	}	
}

event OnChargeDialogConfirm()
{
	Rq_C_EX_SKILL_ENCHANT_CHARGE(_info.SkillInfo.SkillID, _info.SkillInfo.SkillLevel, _info.SkillInfo.SkillSubLevel, GetChargeExpectInfo().chargeItems);
	CloseDialog();	
}

event OnChargeDialogCancel()
{
	CloseDialog();	
}

event OnItemCountDialogConfirm()
{
	local bool isUnregister;
	local INT64 maxNum;
	local int itemSId;
	local INT64 Number;

	// End:0x0E
	if((DialogIsMine()) == false)
	{
		return;
	}
	Number = int64(DialogGetString());
	isUnregister = bool(DialogGetReservedInt());
	maxNum = DialogGetReservedInt2();
	itemSId = DialogGetReservedItemID().ServerID;
	// End:0x6A
	if((Number < 1) || Number > maxNum)
	{
		return;
	}
	Debug("OnItemCountDialogConfirm : " @ string(Number) @ string(isUnregister) @ string(itemSId));
	// End:0xC5
	if(isUnregister)
	{
		UnregisterChargeItem(itemSId, Number);		
	}
	else
	{
		RegisterChargeItem(itemSId, Number);
	}
	UpdateInvenControls();
	UpdateChargeGaugeControls();	
}

event OnItemCountDialogCancel()
{
	// End:0x23
	if(DialogIsMine())
	{
		// End:0x23
		if(_isOpenedDialog == true)
		{
			_isOpenedDialog = false;
			CloseDialog();
		}
	}	
}

event OnItemCountDialogHide()
{
	// End:0x26
	if((DialogIsMine()) == true)
	{
		// End:0x26
		if(_isOpenedDialog == true)
		{
			_isOpenedDialog = false;
			CloseDialog();
		}
	}	
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x37
		case "SPExtract_Btn":
			toggleWindow("SkillSpExtractWnd", true, true);
			// End:0x20E
			break;
		// End:0xF4
		case "AllLevelCheck_Btn":
			Debug("OnClickButton SkillEnchantAllLevelWnd");
			// End:0xC4
			if(class'SkillEnchantAllLevelWnd'.static.Inst().Me.IsShowWindow())
			{
				class'SkillEnchantAllLevelWnd'.static.Inst().Me.HideWindow();				
			}
			else
			{
				class'SkillEnchantAllLevelWnd'.static.Inst().ShowInfo(_info.SkillInfo, _info.replaceSkillId);
			}
			// End:0x20E
			break;
		// End:0x110
		case "Absorption_Btn":
			ShowChargeDialog();
			// End:0x20E
			break;
		// End:0x129
		case "Enchant_Btn":
			ShowEnchantDialog();
			// End:0x20E
			break;
		// End:0x182
		case "EnchantDialog_Ok_Btn":
			Rq_C_EX_REQ_ENCHANT_SKILL(_info.SkillInfo.SkillID, _info.SkillInfo.SkillLevel, ConvertSubLevel(_info.enchantLevel + 1));
			CloseDialog();
			// End:0x20E
			break;
		// End:0x1A8
		case "EnchantDialog_Cancel_Btn":
			CloseDialog();
			// End:0x20E
			break;
		// End:0x1C9
		case "ResultDialog_Ok_Btn":
			CloseDialog();
			// End:0x20E
			break;
		// End:0x1E9
		case "ErrorDialog_Ok_Btn":
			CloseDialog();
			// End:0x20E
			break;
		// End:0x20B
		case "HelpBtn":
			//class'HelpWnd'.static.ShowHelp(15, 3);
			// End:0x20E
			break;
	}	
}

event OnDBClickItemWithHandle(ItemWindowHandle itemWnd, int Index)
{
	local ItemInfo targetItemInfo;
	local bool isUnregister;

	// End:0x22
	if((itemWnd != invenItemWnd) && itemWnd != chargeItemWnd)
	{
		return;
	}
	// End:0x7D
	if(Index >= 0)
	{
		itemWnd.GetItem(Index, targetItemInfo);
		// End:0x5D
		if(itemWnd == chargeItemWnd)
		{
			isUnregister = true;
		}
		InteractionChargeItem(isUnregister, targetItemInfo, class'InputAPI'.static.IsAltPressed());
	}	
}

event OnRClickItemWithHandle(ItemWindowHandle itemWnd, int Index)
{
	OnDBClickItemWithHandle(itemWnd, Index);	
}

event OnDropItemSource(string strTarget, ItemInfo Info)
{
	// End:0x66
	if(strTarget == "ChargeSlot_ItemWindow" && Info.DragSrcName == "InvenSlot_ItemWindow")
	{
		InteractionChargeItem(false, Info, class'InputAPI'.static.IsAltPressed());		
	}
	else if(strTarget == "InvenSlot_ItemWindow" && Info.DragSrcName == "ChargeSlot_ItemWindow")
	{
		InteractionChargeItem(true, Info, class'InputAPI'.static.IsAltPressed());
	}
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();	
}

event OnShow()
{
	CloseDialog();
	ResultEffectViewport.HideWindow();
	class'SkillWnd'.static.Inst().Me.HideWindow();
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	Me.SetFocus();	
}

event OnHide()
{
	// End:0x0F
	if(DialogIsMine())
	{
		DialogHide();
	}
	// End:0x56
	if(class'SkillEnchantAllLevelWnd'.static.Inst().Me.IsShowWindow())
	{
		class'SkillEnchantAllLevelWnd'.static.Inst().Me.HideWindow();
	}
	CloseDialog();
	class'SkillWnd'.static.Inst().Me.ShowWindow();
	ResetInfo();
	needItemScript.CleariObjects();
	dialogNeedItemScript.CleariObjects();	
}

event OnReceivedCloseUI()
{
	// End:0x12
	if(DialogIsMine())
	{
		DialogHide();		
	}
	else if(dialogContainerWnd.IsShowWindow())
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
