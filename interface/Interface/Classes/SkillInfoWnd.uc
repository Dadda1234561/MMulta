class SkillInfoWnd extends UICommonAPI
	dependson(SkillWnd);

const SKILL_MIN_LEVEL = 1;
const ITEM_ID_SP = 15624;
const ITEM_ID_ADENA = 57;

struct FindCostItemInfo
{
	var int SystemMsgID;
	var int MultisellID;
	var int findCategory;
	var INT64 ConsumeAdena;
	var int ConsumeItemID;
	var string findName;
};

var WindowHandle Me;
var WindowHandle dialogContainerWnd;
var WindowHandle learnDialogWnd;
var WindowHandle errorDialogWnd;
var WindowHandle needItemLearnNoticeWnd;
var ButtonHandle learnBtn;
var ButtonHandle EnchantBtn;
var ButtonHandle levelPrevBtn;
var ButtonHandle levelNextBtn;
var ButtonHandle RefreshBtn;
var TextureHandle levelPrevAnimTex;
var TextureHandle levelNextAnimTex;
var ItemWindowHandle skillItemWnd;
var TextBoxHandle skillNameTextBox;
var TextBoxHandle skillLevelTextBox;
var TextBoxHandle skillEnchantLvTextBox;
var TextBoxHandle skillLvStatusTextBox;
var TextBoxHandle needItemEmptyTextBox;
var HtmlHandle descHtml;
var RichListCtrlHandle needItemRichList;
var UIControlNeedItemList needItemScript;
var SkillWnd.SkillSlotInfo _skillSlotInfo;
var array<SkillAcquireData> _skillAcquireData;
var array<int> _blockSkills;
var int _currentLevel;
var int _maxLevel;
var int _canLearnLevel;
var INT64 _haveSP;
var FindCostItemInfo _findCostItemInfo;
var bool _isWaitingLearnResponse;

static function SkillInfoWnd Inst()
{
	return SkillInfoWnd(GetScript("SkillInfoWnd"));	
}

function Initialize()
{
	InitControls();	
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle needItemWnd;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	skillItemWnd = GetItemWindowHandle(ownerFullPath $ ".SkillItem_ItemWindow");
	skillNameTextBox = GetTextBoxHandle(ownerFullPath $ ".SkillName_Txt");
	skillLevelTextBox = GetTextBoxHandle(ownerFullPath $ ".SkillLevel_Txt");
	skillLvStatusTextBox = GetTextBoxHandle(ownerFullPath $ ".SkillLevelStatus_Txt");
	skillEnchantLvTextBox = GetTextBoxHandle(ownerFullPath $ ".SkillEnchantNum_Txt");
	levelPrevBtn = GetButtonHandle(ownerFullPath $ ".Left_Btn");
	levelNextBtn = GetButtonHandle(ownerFullPath $ ".Right_Btn");
	descHtml = GetHtmlHandle(ownerFullPath $ ".SkillDescription_Txt");
	learnBtn = GetButtonHandle(ownerFullPath $ ".Dialog_Learn_Btn");
	EnchantBtn = GetButtonHandle(ownerFullPath $ ".Dialog_Enchant_Btn");
	levelPrevAnimTex = GetTextureHandle(ownerFullPath $ ".LeftBtn_Ani");
	levelNextAnimTex = GetTextureHandle(ownerFullPath $ ".RightBtn_Ani");
	dialogContainerWnd = GetWindowHandle(ownerFullPath $ ".Popup_Wnd");
	learnDialogWnd = GetWindowHandle(dialogContainerWnd.m_WindowNameWithFullPath $ ".SkillLearnPopup_Wnd");
	errorDialogWnd = GetWindowHandle(dialogContainerWnd.m_WindowNameWithFullPath $ ".Error_Wnd");
	needItemWnd = GetWindowHandle(ownerFullPath $ ".Cost_Wnd");
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemRichList = GetRichListCtrlHandle(needItemWnd.m_WindowNameWithFullPath $ ".Cost_RichListCtrl");
	needItemScript.SetRichListControler(needItemRichList);
	needItemRichList.SetSelectedSelTooltip(false);
	needItemRichList.SetAppearTooltipAtMouseX(true);
	needItemRichList.SetTooltipType("SkillLearnCostListTooltip");
	needItemScript.DelegateOnClickButton = OnCostListButtonClicked;
	RefreshBtn = GetButtonHandle(needItemWnd.m_WindowNameWithFullPath $ ".Refresh_Btn");
	needItemEmptyTextBox = GetTextBoxHandle(needItemWnd.m_WindowNameWithFullPath $ ".Empty_Txt");
	needItemLearnNoticeWnd = GetWindowHandle(needItemWnd.m_WindowNameWithFullPath $ ".Shortcut_Wnd");
	needItemLearnNoticeWnd.HideWindow();
	HideLevelNaviBtnAnimTex();	
}

function OpenWindow(SkillWnd.SkillSlotInfo SkillSlotInfo, optional bool isShowSkillLearnPage)
{
	CloseDialog();
	SetInfo(SkillSlotInfo, isShowSkillLearnPage);
	Me.ShowWindow();	
}

function SetInfo(SkillWnd.SkillSlotInfo SkillSlotInfo, optional bool isShowSkillLearnPage)
{
	local UserInfo UserInfo;
	local SkillAcquireData acquireData;

	_isWaitingLearnResponse = false;
	_skillSlotInfo = SkillSlotInfo;
	_currentLevel = SkillSlotInfo.SkillInfo.SkillLevel;
	_blockSkills.Length = 0;
	// End:0x15F
	if(GetPlayerInfo(UserInfo))
	{
		_haveSP = UserInfo.nSP;
		_canLearnLevel = -1;
		_maxLevel = GetSkillAcquireList(UserInfo.nSubClass, SkillSlotInfo.SkillInfo.SkillID, _skillAcquireData, _blockSkills);
		// End:0x96
		if(_maxLevel == 0)
		{
			_maxLevel = _currentLevel;
		}
		// End:0xF5
		if(_skillSlotInfo.learned == false)
		{
			acquireData = GetSkillAcquireData(SkillSlotInfo.SkillInfo.SkillLevel);
			// End:0xF2
			if(acquireData.GetLevel <= UserInfo.nLevel)
			{
				_canLearnLevel = SkillSlotInfo.SkillInfo.SkillLevel;
			}			
		}
		else
		{
			// End:0x15F
			if(_maxLevel > SkillSlotInfo.SkillInfo.SkillLevel)
			{
				acquireData = GetSkillAcquireData(SkillSlotInfo.SkillInfo.SkillLevel + 1);
				// End:0x15F
				if(acquireData.GetLevel <= UserInfo.nLevel)
				{
					_canLearnLevel = SkillSlotInfo.SkillInfo.SkillLevel + 1;
				}
			}
		}
	}
	// End:0x181
	if(isShowSkillLearnPage == true)
	{
		// End:0x181
		if(_canLearnLevel > 0)
		{
			_currentLevel = _canLearnLevel;
		}
	}
	UpdateUIControls();	
}

function ResetFindCostItemInfo()
{
	local FindCostItemInfo defaultInfo;

	_findCostItemInfo = defaultInfo;	
}

function SetCurrentSkillLevel(int targetSkill)
{
	_currentLevel = targetSkill;
	UpdateUIControls();	
}

function SkillAcquireData GetSkillAcquireData(int Level)
{
	local SkillAcquireData acquireData;
	local int Index;

	Index = Level - 1;
	// End:0x3C
	if((Index >= 0) && Index < _skillAcquireData.Length)
	{
		acquireData = _skillAcquireData[Index];
	}
	return acquireData;	
}

function int GetCurrentSkillId()
{
	// End:0x25
	if(Me.IsShowWindow())
	{
		return _skillSlotInfo.SkillInfo.SkillID;		
	}
	else
	{
		return 0;
	}	
}

function ShowLearnDialog()
{
	local int i;
	local ItemWindowHandle skillItemWnd;
	local TextBoxHandle skillNameTextBox, currentLvTextBox, nextLvTextBox, firstLearnTextBox;
	local TextureHandle arrowTex;
	local ItemInfo skillItemInfo;
	local RichListCtrlHandle deleteSkillRichList;
	local RichListCtrlRowData RowData;
	local L2Util util;
	local SkillInfo tempSkillInfo;
	local WindowHandle blockSkillEmptyWnd;

	util = L2Util(GetScript("L2Util"));
	skillItemWnd = GetItemWindowHandle(learnDialogWnd.m_WindowNameWithFullPath $ ".SkillItem_ItemWindow");
	skillNameTextBox = GetTextBoxHandle(learnDialogWnd.m_WindowNameWithFullPath $ ".SkillName_Txt");
	currentLvTextBox = GetTextBoxHandle(learnDialogWnd.m_WindowNameWithFullPath $ ".PrvLevelNum_Txt");
	nextLvTextBox = GetTextBoxHandle(learnDialogWnd.m_WindowNameWithFullPath $ ".NextLevelNum_Txt");
	deleteSkillRichList = GetRichListCtrlHandle(learnDialogWnd.m_WindowNameWithFullPath $ ".DeleteSkill_RichListCtrl");
	firstLearnTextBox = GetTextBoxHandle(learnDialogWnd.m_WindowNameWithFullPath $ ".First_Txt");
	arrowTex = GetTextureHandle(learnDialogWnd.m_WindowNameWithFullPath $ ".Arrow_Tex");
	blockSkillEmptyWnd = GetWindowHandle(learnDialogWnd.m_WindowNameWithFullPath $ ".NoDeleteSkill_Wnd");
	deleteSkillRichList.SetSelectedSelTooltip(false);
	deleteSkillRichList.SetSelectable(false);
	deleteSkillRichList.SetTooltipType("UIControlNeedItemList");
	skillNameTextBox.SetText(_skillSlotInfo.skillItemInfo.Name @ class'SkillEnchantWnd'.static.Inst().GetSkillLevelStr(_skillSlotInfo.SkillInfo.SkillLevel));
	// End:0x26A
	if(_skillSlotInfo.learned == false)
	{
		firstLearnTextBox.ShowWindow();
		arrowTex.HideWindow();
		currentLvTextBox.HideWindow();
		nextLvTextBox.HideWindow();		
	}
	else
	{
		currentLvTextBox.SetText(class'SkillEnchantWnd'.static.Inst().GetSkillLevelStr(_skillSlotInfo.SkillInfo.SkillLevel));
		nextLvTextBox.SetText(class'SkillEnchantWnd'.static.Inst().GetSkillLevelStr(_skillSlotInfo.SkillInfo.SkillLevel + 1));
		firstLearnTextBox.HideWindow();
		arrowTex.ShowWindow();
		currentLvTextBox.ShowWindow();
		nextLvTextBox.ShowWindow();
	}
	skillItemInfo.IconName = _skillSlotInfo.skillItemInfo.IconName;
	// End:0x35F
	if(! skillItemWnd.SetItem(0, skillItemInfo))
	{
		skillItemWnd.AddItem(skillItemInfo);
	}
	RowData.cellDataList.Length = 1;
	deleteSkillRichList.DeleteAllItem();
	// End:0x476
	if(_blockSkills.Length > 0 && _skillSlotInfo.learned == false)
	{
		// End:0x464 [Loop If]
		for(i = 0; i < _blockSkills.Length; i++)
		{
			GetSkillInfo(_blockSkills[i], 1, 0, tempSkillInfo);
			util.GetSkill2ItemInfo(tempSkillInfo, skillItemInfo);
			RowData.cellDataList[0].drawitems.Length = 0;
			AddRichListCtrlSkill(RowData.cellDataList[0].drawitems, skillItemInfo);
			addRichListCtrlString(RowData.cellDataList[0].drawitems, skillItemInfo.Name, util.White, false, 10, 8);
			deleteSkillRichList.InsertRecord(RowData);
		}
		blockSkillEmptyWnd.HideWindow();		
	}
	else
	{
		blockSkillEmptyWnd.ShowWindow();
	}
	// End:0x4E2
	if(blockSkillEmptyWnd.IsShowWindow() == false || _findCostItemInfo.ConsumeAdena > 0 || _findCostItemInfo.ConsumeItemID > 0)
	{
		learnDialogWnd.ShowWindow();
		dialogContainerWnd.ShowWindow();		
	}
	else
	{
		RequestLearnSkill();
	}	
}

function ShowErrorDialog(int errorStrId)
{
	local string errorDesc;
	local TextBoxHandle descTextBox;

	descTextBox = GetTextBoxHandle(errorDialogWnd.m_WindowNameWithFullPath $ ".Description_Txt");
	// End:0x4D
	if(errorStrId == 0)
	{
		errorDesc = GetSystemMessage(4559);		
	}
	else
	{
		errorDesc = GetSystemMessage(errorStrId);
	}
	descTextBox.SetText(errorDesc);
	errorDialogWnd.ShowWindow();
	dialogContainerWnd.ShowWindow();	
}

function CloseDialog()
{
	learnDialogWnd.HideWindow();
	errorDialogWnd.HideWindow();
	dialogContainerWnd.HideWindow();	
}

function HideLevelNaviBtnAnimTex()
{
	levelPrevAnimTex.HideWindow();
	levelNextAnimTex.HideWindow();	
}

function string AddHtmlNewLine(string sourceStr, string addStr)
{
	// End:0x12
	if(addStr == "")
	{
		return sourceStr;
	}
	return sourceStr $ "<br1>" $ addStr;	
}

function string AddHtmlSkillStatInfo(string sourceStr, int statNameId, string statValue, optional bool notUseValueColor)
{
	local string statStr, valueStr;

	// End:0x17
	if(notUseValueColor)
	{
		valueStr = statValue;		
	}
	else
	{
		valueStr = htmlAddText(statValue, "", "b09b79");
	}
	statStr = (htmlAddText(GetSystemString(statNameId), "", "a3a3a3") $ ":") @ valueStr;
	return AddHtmlNewLine(sourceStr, statStr);	
}

function string AddHtmlDescCrossLine(string sourceStr)
{
	// End:0x0F
	if(sourceStr == "")
	{
		return "";
	}
	return sourceStr $ "<br1><img src = \"L2ui_ch3.tooltip_line\" width = 380 height = 1><br>";	
}

function string ConvertHtmlDesc(SkillInfo SkillInfo, SkillWnd.SkillSlotInfo SkillSlotInfo, SkillAcquireData acquireData)
{
	local string htmlStr, skillInfoA, skillInfoB, skillInfoC, SkillDesc, tempStr;

	local UserInfo UserInfo;
	local L2Util util;
	local int ConsumeItemCount, consumeClassID;

	util = L2Util(GetScript("L2Util"));
	GetPlayerInfo(UserInfo);
	SkillDesc = SkillInfo.SkillDesc;
	SkillDesc = Substitute(SkillDesc, "<", "&lt;", false);
	SkillDesc = Substitute(SkillDesc, ">", "&gt;", false);
	SkillDesc = Substitute(SkillDesc, "&lt;font", "<font", false);
	SkillDesc = Substitute(SkillDesc, "\"&gt;", "\">", false);
	SkillDesc = Substitute(SkillDesc, "&lt;/font&gt;", "</font>", false);
	SkillDesc = Substitute(SkillDesc, "\\n\\n", "<br>", false);
	SkillDesc = Substitute(SkillDesc, "\\n", "<br1>", false);
	SkillDesc = AddHtmlDescCrossLine(SkillDesc);
	htmlStr = AddHtmlNewLine(htmlStr, "<br>" $ SkillDesc);
	skillInfoA = AddHtmlSkillStatInfo(skillInfoA, 14374, getSkillTypeString(SkillInfo.IconType));
	// End:0x1DB
	if(acquireData.GetLevel > 0)
	{
		// End:0x1B0
		if(acquireData.GetLevel > UserInfo.nLevel)
		{
			skillInfoA = AddHtmlSkillStatInfo(skillInfoA, 14375, htmlAddText(string(acquireData.GetLevel), "", "FF0000"), true);			
		}
		else
		{
			skillInfoA = AddHtmlSkillStatInfo(skillInfoA, 14375, htmlAddText(string(acquireData.GetLevel), ""), true);
		}
	}
	skillInfoA = AddHtmlDescCrossLine(skillInfoA);
	htmlStr = AddHtmlNewLine(htmlStr, skillInfoA);
	// End:0x234
	if(SkillInfo.MpConsume > 0)
	{
		skillInfoB = AddHtmlSkillStatInfo(skillInfoB, 7503, string(SkillInfo.MpConsume));
	}
	// End:0x266
	if(SkillInfo.HpConsume > 0)
	{
		skillInfoB = AddHtmlSkillStatInfo(skillInfoB, 7504, string(SkillInfo.HpConsume));
	}
	// End:0x298
	if(SkillInfo.DpConsume > 0)
	{
		skillInfoB = AddHtmlSkillStatInfo(skillInfoB, 13578, string(SkillInfo.DpConsume));
	}
	// End:0x2CA
	if(SkillInfo.EnergyConsume > 0)
	{
		skillInfoB = AddHtmlSkillStatInfo(skillInfoB, 13579, string(SkillInfo.EnergyConsume));
	}
	class'UIDATA_SKILL'.static.GetMSCondItem(SkillInfo.SkillID, SkillInfo.SkillLevel, SkillInfo.SkillSubLevel, consumeClassID, ConsumeItemCount);
	// End:0x35B
	if(consumeClassID > 0)
	{
		skillInfoB = AddHtmlSkillStatInfo(skillInfoB, 13580, MakeFullSystemMsg(GetSystemMessage(1983), class'UIDATA_ITEM'.static.GetItemName(GetItemID(consumeClassID)) $ " " $ string(ConsumeItemCount)));
	}
	skillInfoB = AddHtmlDescCrossLine(skillInfoB);
	htmlStr = AddHtmlNewLine(htmlStr, skillInfoB);
	// End:0x3CA
	if((SkillInfo.CastRange >= 0) && SkillInfo.CastRange < 1300)
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 321, string(SkillInfo.CastRange));
	}
	// End:0x425
	if(SkillSlotInfo.isActiveSkill && SkillInfo.CoolTime > 0)
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 2377, util.MakeTimeString(SkillInfo.HitTime, SkillInfo.CoolTime));
	}
	// End:0x476
	if(SkillSlotInfo.isActiveSkill && SkillInfo.ReuseDelay > 0)
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 14376, util.MakeTimeString(SkillInfo.ReuseDelay));
	}
	// End:0x4B7
	if(SkillInfo.AbnormalTime > 0)
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 13582, util.GetTimeStringBySec5(float(SkillInfo.AbnormalTime)));
	}
	tempStr = getSkillTargetTypeString(SkillInfo.TargetType);
	// End:0x4F4
	if(tempStr != "")
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 13584, tempStr);
	}
	tempStr = getSkillAffectTypeString(SkillInfo.AffectScope);
	// End:0x531
	if(tempStr != "")
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 13585, tempStr);
	}
	tempStr = getSkillEquipNameStr(SkillInfo.SkillID, SkillInfo.SkillLevel, SkillInfo.SkillSubLevel);
	// End:0x582
	if(tempStr != "")
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 13586, tempStr);
	}
	htmlStr = AddHtmlNewLine(htmlStr, skillInfoC);
	htmlStr = htmlSetHtmlStart(htmlStr);
	return htmlStr;	
}

function UpdateSkillInfoControls()
{
	local ItemInfo skillItemInfo;
	local int validSkillSubLevel, validEnchantLevel;
	local SkillInfo validSkillInfo;
	local SkillAcquireData acquireData;
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	acquireData = GetSkillAcquireData(_currentLevel);
	// End:0x5D
	if(_skillSlotInfo.SkillInfo.SkillLevel <= _currentLevel)
	{
		validSkillSubLevel = _skillSlotInfo.SkillInfo.SkillSubLevel;
		validEnchantLevel = _skillSlotInfo.enchantLevel;		
	}
	else
	{
		validSkillSubLevel = 0;
		validEnchantLevel = 0;
	}
	// End:0x9D
	if(_skillSlotInfo.replaceSkillId >= 0)
	{
		GetSkillInfo(_skillSlotInfo.replaceSkillId, _currentLevel, validSkillSubLevel, validSkillInfo);		
	}
	else
	{
		GetSkillInfo(_skillSlotInfo.SkillInfo.SkillID, _currentLevel, validSkillSubLevel, validSkillInfo);
	}
	skillEnchantLvTextBox.SetText(class'SkillEnchantWnd'.static.Inst().GetEnchantLvName(validEnchantLevel));
	// End:0x12B
	if(skillEnchantLvTextBox.GetText() == "")
	{
		skillEnchantLvTextBox.SetWindowSize(0, skillEnchantLvTextBox.GetRect().nHeight);		
	}
	else
	{
		skillEnchantLvTextBox.SetText(skillEnchantLvTextBox.GetText() $ " ");
	}
	skillNameTextBox.SetText(validSkillInfo.SkillName);
	// End:0x18C
	if(validSkillInfo.LevelHide == true)
	{
		skillLevelTextBox.SetText("");		
	}
	else
	{
		skillLevelTextBox.SetText(class'SkillEnchantWnd'.static.Inst().GetSkillLevelStr(_currentLevel));
	}
	descHtml.LoadHtmlFromString(ConvertHtmlDesc(validSkillInfo, _skillSlotInfo, acquireData));
	skillItemInfo.IconName = validSkillInfo.TexName;
	// End:0x245
	if(_currentLevel == _canLearnLevel)
	{
		skillLvStatusTextBox.SetText("(" $ GetSystemString(14371) $ ")");
		skillLvStatusTextBox.SetFontColor(GetColor(119, 255, 153, 255));		
	}
	else
	{
		// End:0x280
		if(acquireData.GetLevel > UserInfo.nLevel)
		{
			skillItemInfo.bDisabled = 1;
			skillLvStatusTextBox.SetText("");			
		}
		else
		{
			// End:0x2F0
			if((validSkillInfo.LevelHide == false) && _currentLevel == _skillSlotInfo.SkillInfo.SkillLevel)
			{
				skillLvStatusTextBox.SetText("(" $ GetSystemString(14370) $ ")");
				skillLvStatusTextBox.SetFontColor(GetColor(170, 153, 119, 255));				
			}
			else
			{
				skillLvStatusTextBox.SetText("");
			}
		}
	}
	// End:0x32F
	if(! skillItemWnd.SetItem(0, skillItemInfo))
	{
		skillItemWnd.AddItem(skillItemInfo);
	}
	HideLevelNaviBtnAnimTex();
	// End:0x3AA
	if(_skillSlotInfo.isEnchantSkill == true)
	{
		learnBtn.SetAnchor("SkillInfoWnd", "BottomCenter", "BottomRight", -2, -5);
		EnchantBtn.ShowWindow();
		EnchantBtn.SetEnable(true);		
	}
	else
	{
		learnBtn.SetAnchor("SkillInfoWnd", "BottomCenter", "BottomRight", 70, -5);
		EnchantBtn.HideWindow();
		EnchantBtn.SetEnable(false);
	}
	// End:0x436
	if(_maxLevel == 1)
	{
		levelPrevBtn.SetEnable(false);
		levelNextBtn.SetEnable(false);		
	}
	else
	{
		// End:0x468
		if(_currentLevel == _maxLevel)
		{
			levelPrevBtn.SetEnable(true);
			levelNextBtn.SetEnable(false);			
		}
		else if(_currentLevel == SKILL_MIN_LEVEL)
		{
			levelPrevBtn.SetEnable(false);
			levelNextBtn.SetEnable(true);				
		}
		else
		{
			levelPrevBtn.SetEnable(true);
			levelNextBtn.SetEnable(true);
		}
	}
	// End:0x500
	if(_canLearnLevel > 0)
	{
		// End:0x4E2
		if(_currentLevel < _canLearnLevel)
		{
			levelNextAnimTex.ShowWindow();			
		}
		else if(_currentLevel > _canLearnLevel)
		{
			levelPrevAnimTex.ShowWindow();
		}
	}	
}

function UpdateCostInfoControls()
{
	local SkillAcquireData acquireData;
	local ItemInfo needItemInfo;
	local UserInfo UserInfo;
	local int levelIndex, needItemListIndex;
	local bool learned;
	local string texturePath;
	local RichListCtrlRowData RowData;
	local INT64 consumePriorityInvenCnt, consumeInvenCnt;
	local bool needLearnBtnTooltip;

	needItemScript.StartNeedItemList(2);
	levelIndex = _currentLevel - 1;
	needItemListIndex = -1;
	ResetFindCostItemInfo();
	// End:0x64
	if((_skillSlotInfo.learned == true) && _currentLevel <= _skillSlotInfo.SkillInfo.SkillLevel)
	{
		learned = true;
	}
	// End:0x2B4
	if((levelIndex >= 0) && levelIndex < _skillAcquireData.Length)
	{
		acquireData = _skillAcquireData[levelIndex];
		// End:0x2B4
		if(learned == false)
		{
			_findCostItemInfo.MultisellID = acquireData.MultisellGroupID;
			_findCostItemInfo.SystemMsgID = acquireData.SystemMsgID;
			// End:0x129
			if(acquireData.ConsumeSP > 0)
			{
				GetPlayerInfo(UserInfo);
				needItemInfo = GetItemInfoByClassID(ITEM_ID_SP);
				needItemScript.AddNeedPoint(needItemInfo.Name, needItemInfo.IconName, acquireData.ConsumeSP, _haveSP);
			}
			// End:0x16C
			if(acquireData.ConsumeAdena > 0)
			{
				needItemScript.AddNeedItemClassID(ITEM_ID_ADENA, acquireData.ConsumeAdena);
				_findCostItemInfo.ConsumeAdena = acquireData.ConsumeAdena;
			}
			// End:0x2B4
			if((acquireData.ConsumeItemID > 0) && acquireData.ConsumeItemCount > 0)
			{
				_findCostItemInfo.findName = GetItemInfoByClassID(acquireData.ConsumeItemID).Name;
				_findCostItemInfo.findCategory = acquireData.CategoryIndex;
				_findCostItemInfo.ConsumeItemID = acquireData.ConsumeItemID;
				// End:0x277
				if((acquireData.ConsumePriorityItemID > 0) && acquireData.ConsumePriorityItemCount > 0)
				{
					needLearnBtnTooltip = true;
					consumePriorityInvenCnt = GetInventoryItemCount(GetItemID(acquireData.ConsumePriorityItemID));
					consumeInvenCnt = GetInventoryItemCount(GetItemID(acquireData.ConsumeItemID));
					needItemScript.AddNeeItemInfo(GetItemInfoByClassID(acquireData.ConsumeItemID), acquireData.ConsumeItemCount, consumePriorityInvenCnt + consumeInvenCnt);					
				}
				else
				{
					needItemScript.AddNeedItemClassID(acquireData.ConsumeItemID, acquireData.ConsumeItemCount);
				}
				needItemListIndex = needItemRichList.GetRecordCount() - 1;
			}
		}
	}
	needItemLearnNoticeWnd.HideWindow();
	// End:0x2EA
	if(needItemRichList.GetRecordCount() > 0)
	{
		needItemEmptyTextBox.HideWindow();		
	}
	else
	{
		// End:0x34E
		if(learned == true)
		{
			// End:0x322
			if(_canLearnLevel > 0)
			{
				needItemLearnNoticeWnd.ShowWindow();
				needItemEmptyTextBox.HideWindow();				
			}
			else
			{
				needItemEmptyTextBox.SetText(GetSystemString(14392));
				needItemEmptyTextBox.ShowWindow();
			}			
		}
		else
		{
			needItemEmptyTextBox.SetText(GetSystemString(13466));
			needItemEmptyTextBox.ShowWindow();
		}
	}
	// End:0x609
	if(needItemListIndex >= 0)
	{
		needItemRichList.GetRec(needItemListIndex, RowData);
		RowData.nReserved1 = acquireData.ConsumePriorityItemID;
		RowData.nReserved2 = acquireData.ConsumeItemID;
		RowData.nReserved3 = acquireData.SystemMsgID;
		// End:0x4E4
		if(acquireData.SystemMsgID == 0)
		{
			addRichListCtrlString(RowData.cellDataList[0].drawitems, "",, true);
			addRichListCtrlButton(RowData.cellDataList[0].drawitems, "skillCostItemBackBtn", -20, -40, "L2UI_CT1.EmptyBtn", "L2UI_NewTex.Button.List_Down", "L2UI_NewTex.Button.List_Over", 400, 40, 322, 40, 0, "skillCostItemBackBtn");
			texturePath = "L2UI_NewTex.SkillWnd.Icon_Magnifier";			
		}
		else
		{
			texturePath = "L2UI_NewTex.SkillWnd.Icon_Help";
		}
		addRichListCtrlString(RowData.cellDataList[0].drawitems, "",, true);
		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, texturePath, 20, 20, 354, -28, 20, 20);
		// End:0x5E1
		if((acquireData.ConsumePriorityItemID > 0) && acquireData.ConsumePriorityItemCount > 0)
		{
			addRichListCtrlString(RowData.cellDataList[0].drawitems, "",, true);
			addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_NewTex.SkillWnd.Icon_Substitution", 20, 20, 330, -20, 20, 20);
		}
		needItemRichList.DeleteRecord(needItemListIndex);
		needItemRichList.InsertRecord(RowData);
	}
	needItemScript.SetBuyNum(1);
	// End:0x690
	if(_currentLevel == _canLearnLevel)
	{
		// End:0x67D
		if(needItemRichList.GetRecordCount() > 0)
		{
			// End:0x66A
			if(needItemScript.GetMaxNumCanBuy() > 0)
			{
				learnBtn.SetEnable(true);				
			}
			else
			{
				learnBtn.SetEnable(false);
			}			
		}
		else
		{
			learnBtn.SetEnable(true);
		}		
	}
	else
	{
		learnBtn.SetEnable(false);
	}
	learnBtn.SetTooltipType("Text");
	// End:0x6E1
	if(needLearnBtnTooltip)
	{
		learnBtn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14402)));		
	}
	else
	{
		learnBtn.SetTooltipCustomType(MakeTooltipSimpleText(""));
	}	
}

function UpdateUIControls()
{
	UpdateSkillInfoControls();
	UpdateCostInfoControls();	
}

function UpdateFromSkillWndInfo(int SkillID)
{
	local SkillWnd.SkillSlotInfo slotInfo;

	// End:0x0D
	if(SkillID == 0)
	{
		return;
	}
	// End:0x3E
	if(class'SkillWnd'.static.Inst().FindSkillSlotInfo(SkillID, slotInfo))
	{
		SetInfo(slotInfo);
	}	
}

function RequestLearnSkill()
{
	// End:0x9C
	if(_skillSlotInfo.SkillInfo.SkillID > 0 && _canLearnLevel > 0)
	{
		Debug("RequestLearnSkill" @ string(_skillSlotInfo.SkillInfo.SkillID) @ string(_canLearnLevel) @ string(_skillSlotInfo.SkillInfo.SkillSubLevel));
		RequestAcquireSkill(_skillSlotInfo.SkillInfo.SkillID, _canLearnLevel, _skillSlotInfo.SkillInfo.SkillSubLevel, 0);
		_isWaitingLearnResponse = true;
	}	
}

function Rq_C_EX_MULTI_SELL_LIST(int MultisellID)
{
	local array<byte> stream;
	local UIPacket._C_EX_MULTI_SELL_LIST packet;

	packet.nGroupID = MultisellID;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_MULTI_SELL_LIST(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_MULTI_SELL_LIST, stream);	
}

function Nt_S_EX_ACQUIRE_SKILL_RESULT()
{
	local string skillNameStr;
	local UIPacket._S_EX_ACQUIRE_SKILL_RESULT packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_ACQUIRE_SKILL_RESULT(packet))
	{
		return;
	}
	Debug("Nt_S_EX_ACQUIRE_SKILL_RESULT" @ string(packet.cResult) @ string(packet.nLevel) @ string(packet.nSkillID) @ string(packet.nSysMsg));
	// End:0xA4
	if(packet.nSkillID != _skillSlotInfo.SkillInfo.SkillID)
	{
		Me.HideWindow();
	}
	// End:0x150
	if(packet.cResult == 0)
	{
		_skillSlotInfo.SkillInfo.SkillLevel = packet.nLevel;
		_skillSlotInfo.learned = true;
		SetInfo(_skillSlotInfo);
		OnPageNavigateBtnClicked(true);
		skillNameStr = _skillSlotInfo.SkillInfo.SkillName @ class'SkillEnchantWnd'.static.Inst().GetSkillLevelStr(packet.nLevel);
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13817), skillNameStr));		
	}
	else
	{
		ShowErrorDialog(packet.nSysMsg);
	}
	_isWaitingLearnResponse = false;	
}

function Nt_EV_UpdateUserInfo()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	// End:0x5F
	if(_haveSP != UserInfo.nSP)
	{
		_haveSP = UserInfo.nSP;
		// End:0x5F
		if(Me.IsShowWindow() && _skillSlotInfo.SkillInfo.SkillID > 0)
		{
			UpdateCostInfoControls();
		}
	}	
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_ACQUIRE_SKILL_RESULT));
	RegisterEvent(EV_UpdateUserInfo);	
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_ACQUIRE_SKILL_RESULT):
			Nt_S_EX_ACQUIRE_SKILL_RESULT();
			// End:0x38
			break;
		// End:0x35
		case EV_UpdateUserInfo:
			Nt_EV_UpdateUserInfo();
			// End:0x38
			break;
	}	
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x1E
		case "Left_Btn":
			OnPageNavigateBtnClicked(false);
			// End:0x137
			break;
		// End:0x36
		case "Right_Btn":
			OnPageNavigateBtnClicked(true);
			// End:0x137
			break;
		// End:0x60
		case "Dialog_Learn_Btn":
			// End:0x5D
			if(_isWaitingLearnResponse == false)
			{
				ShowLearnDialog();
			}
			// End:0x137
			break;
		// End:0xCA
		case "Dialog_Enchant_Btn":
			class'SkillEnchantWnd'.static.Inst().OpenWindow(_skillSlotInfo.SkillInfo.SkillID, _skillSlotInfo.SkillInfo.SkillLevel, _skillSlotInfo.SkillInfo.SkillSubLevel, _skillSlotInfo.replaceSkillId);
			// End:0x137
			break;
		// End:0xF0
		case "LearnDialog_Ok_Btn":
			RequestLearnSkill();
			CloseDialog();
			// End:0x137
			break;
		// End:0x114
		case "LearnDialog_Cancel_Btn":
			CloseDialog();
			// End:0x137
			break;
		// End:0x134
		case "ErrorDialog_Ok_Btn":
			CloseDialog();
			// End:0x137
			break;
	}	
}

event OnCostListButtonClicked(string btnName)
{
	switch(btnName)
	{
		// End:0x20
		case "skillCostItemFindBtn":
		// End:0x42
		case "skillCostItemBackBtn":
			OnSkillCostItemFindBtnClicked();
			// End:0x75
			break;
		// End:0x5B
		case "Refresh_Btn":
			UpdateCostInfoControls();
			// End:0x75
			break;
		// End:0x72
		case "GoNow_Btn":
			OnSkillLearnPageMoveClicked();
			// End:0x75
			break;
	}	
}

event OnPageNavigateBtnClicked(bool isNext)
{
	local int TargetLevel;

	TargetLevel = _currentLevel;
	// End:0x2D
	if(isNext)
	{
		// End:0x2A
		if(TargetLevel != _maxLevel)
		{
			TargetLevel++;
		}		
	}
	else
	{
		// End:0x3F
		if(TargetLevel != 1)
		{
			TargetLevel--;
		}
	}
	SetCurrentSkillLevel(TargetLevel);	
}

event OnSkillCostItemFindBtnClicked()
{
	// End:0x12
	if(_findCostItemInfo.SystemMsgID > 0)
	{
		return;
	}
	// End:0x34
	if(_findCostItemInfo.MultisellID > 0)
	{
		Rq_C_EX_MULTI_SELL_LIST(_findCostItemInfo.MultisellID);
		return;
	}
	// End:0x83
	if(_findCostItemInfo.findCategory > 0)
	{
		ShopLcoinCraftWnd(GetScript("ShopLcoinCraftWnd")).ShowAndFindItem(_findCostItemInfo.findName, _findCostItemInfo.findCategory - 1);
	}	
}

event OnSkillLearnPageMoveClicked()
{
	// End:0x27
	if((_canLearnLevel > 0) && _canLearnLevel <= _maxLevel)
	{
		SetCurrentSkillLevel(_canLearnLevel);
	}	
}

event OnLoad()
{
	Initialize();	
}

event OnShow()
{
	CloseDialog();	
}

event OnHide()
{
	needItemScript.CleariObjects();
	_isWaitingLearnResponse = false;	
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
