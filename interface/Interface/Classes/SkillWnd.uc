class SkillWnd extends UICommonAPI;

const SKILL_GROUP_NUM_MAX = 15;
const ITEM_SKILL_ICON_TYPE = 36;
const TIMER_SHORTCUT_UPDATE_ID = 1;
const TIMER_SHORTCUT_UPDATEDELAY = 100;

struct SkillSlotInfo
{
	var bool learned;
	var bool isActiveSkill;
	var bool isItemTypeSkill;
	var bool isCanEnchant;
	var bool isEnchantSkill;
	var bool isCanLevelUp;
	var bool isShortCut;
	var int orderId;
	var int groupType;
	var int enchantLevel;
	var int replaceSkillId;
	var SkillInfo SkillInfo;
	var ItemInfo skillItemInfo;
};

struct SkillNoticeNumInfo
{
	var int activeLearnNum;
	var int passiveLearnNum;
	var int activeEnchantNum;
	var int passiveEnchantNum;
};

struct SkillGroupInfo
{
	var int groupType;
	var array<SkillSlotInfo> skills;
};

var array<SkillGroupInfo> _characterSKillActiveGroups;
var array<SkillGroupInfo> _characterSKillPassiveGroups;
var array<SkillGroupInfo> _itemSkillGroups;
var array<SkillGroupInfo> _canLearnSKillGroups;
var array<SkillGroupInfo> _canEnchantSkillGroups;
var array<SkillSlotInfo> _totalSkillInfos;
var array<SkillSlotInfo> _characterSkillInfos;
var array<SkillSlotInfo> _itemSkillInfos;
var bool _isWaitingSkillListResponse;
var int _selectedTabIndex;
var int _playerLevel;
var array<int> _shortcutSKillList;
var SkillSlotInfo _invenExpandSkillInfo;
var SkillNoticeNumInfo _skillNoticeNumInfo;
var WindowHandle Me;
var array<SkillWndGroupItem> skillGroupItemList;
var WindowHandle skillScrollArea;
var WindowHandle activeNoticeNumWnd;
var WindowHandle passiveNoticeNumWnd;
var TextBoxHandle skillEmptyTextBox;
var TextBoxHandle itemSkillTitle;
var TextBoxHandle activeNoticeNumTextBox;
var TextBoxHandle passiveNoticeNumTextBox;
var UIControlGroupButtonAssets tabGroupButtonAsset;
var TabHandle subTabHandle;
var TextureHandle characterSkillDecoTex;
var TextureHandle itemSkillDecoTex;
var ButtonHandle spExtractBtn;

static function SkillWnd Inst()
{
	return SkillWnd(GetScript("SkillWnd"));	
}

function Initialize()
{
	InitControls();	
}

function InitControls()
{
	local int i;
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	skillScrollArea = GetWindowHandle(ownerFullPath $ ".SkillMain_Wnd.Skill_Wnd.Skill.SkillScroll");
	skillEmptyTextBox = GetTextBoxHandle(ownerFullPath $ ".SkillMain_Wnd.Skill_Wnd.Empty_Txt");
	subTabHandle = GetTabHandle(ownerFullPath $ ".SkillMain_Wnd.Skill_Tab");
	characterSkillDecoTex = GetTextureHandle(ownerFullPath $ ".SkillMain_Wnd.TabBgLine_Tex");
	itemSkillDecoTex = GetTextureHandle(ownerFullPath $ ".SkillMain_Wnd.TabBgLine2_Tex");
	itemSkillTitle = GetTextBoxHandle(ownerFullPath $ ".SkillMain_Wnd.SkillHeader_Txt");
	spExtractBtn = GetButtonHandle(ownerFullPath $ ".SkillMain_Wnd.SPExtract_Btn");
	activeNoticeNumWnd = GetWindowHandle(ownerFullPath $ ".SkillMain_Wnd.TabNum1_Wnd");
	passiveNoticeNumWnd = GetWindowHandle(ownerFullPath $ ".SkillMain_Wnd.TabNum2_Wnd");
	activeNoticeNumTextBox = GetTextBoxHandle(activeNoticeNumWnd.m_WindowNameWithFullPath $ ".Num_Txt");
	passiveNoticeNumTextBox = GetTextBoxHandle(passiveNoticeNumWnd.m_WindowNameWithFullPath $ ".Num_Txt");
	tabGroupButtonAsset = class'UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle(ownerFullPath $ ".TopGroupButtonAsset"));
	tabGroupButtonAsset._SetStartInfo("L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", true);
	tabGroupButtonAsset._GetGroupButtonsInstance().__DelegateOnClickButton__Delegate = OnTabGroupBtnClicked;
	tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected_Over");
	tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(1, "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Unselected_Over");
	tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(2, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected_Over");	tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(2321));
	tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(0, 0);
	tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(117));
	tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(1, 1);
	tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(2, GetSystemString(14409));
	tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(2, 2);
	tabGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(3);
	tabGroupButtonAsset._GetGroupButtonsInstance()._setAutoWidth(524, 0);

	// End:0x69F [Loop If]
	for(i = 0; i < SKILL_GROUP_NUM_MAX; i++)
	{
		AddGroupItemControl(skillGroupItemList, "Skill", i, skillScrollArea);
	}	
}

function AddGroupItemControl(out array<SkillWndGroupItem> componentList, string componentName, int Index, WindowHandle parentWnd)
{
	local WindowHandle targetWindowHandle;
	local SkillWndGroupItem targetControl;

	targetWindowHandle = GetWindowHandle(parentWnd.m_WindowNameWithFullPath $ "." $ componentName $ string(Index));
	targetWindowHandle.SetScript("SkillWndGroupItem");
	targetControl = SkillWndGroupItem(targetWindowHandle.GetScript());
	targetControl.Init(targetWindowHandle);
	targetControl.DelegateOnSkillInfoClicked = OnSkillSlotInfoClicked;
	componentList[componentList.Length] = targetControl;	
}

function ResetSkillNoticeNumInfo()
{
	local SkillNoticeNumInfo defaultNumInfo;

	_skillNoticeNumInfo = defaultNumInfo;	
}

function ResetSkillGroupInfo()
{
	_characterSKillActiveGroups.Length = 0;
	_characterSKillPassiveGroups.Length = 0;
	_itemSkillGroups.Length = 0;
	_canLearnSKillGroups.Length = 0;	
	_canEnchantSkillGroups.Length = 0;
}

function ResetInfo()
{
	ResetSkillGroupInfo();
	_totalSkillInfos.Length = 0;	
}

function UpdateShortcutSkillInfo()
{
	_shortcutSKillList.Length = 0;
	class'ShortcutWndAPI'.static.GetSkillListFromShortcutItems(_shortcutSKillList);	
}

function UpdateShortcutInfoWithTimer()
{
	Me.KillTimer(TIMER_SHORTCUT_UPDATE_ID);
	Me.SetTimer(TIMER_SHORTCUT_UPDATE_ID, TIMER_SHORTCUT_UPDATEDELAY);	
}

function UpdateSkillInfos()
{
	local int i;
	local SkillSlotInfo slotInfo;
	local array<SkillSlotInfo> itemSkills, characterActiveSkills, characterPassiveSkills, canLearnSKills, canEnchantSkills;

	ResetSkillNoticeNumInfo();

	// End:0x16A [Loop If]
	for(i = 0; i < _totalSkillInfos.Length; i++)
	{
		slotInfo = _totalSkillInfos[i];
		// End:0x63
		if(slotInfo.learned == true)
		{
			slotInfo.isShortCut = CheckShortcutRegistered(slotInfo.SkillInfo.SkillID);			
		}
		else
		{
			slotInfo.isShortCut = false;
		}
		// End:0x93
		if(slotInfo.isItemTypeSkill)
		{
			itemSkills[itemSkills.Length] = slotInfo;
			// [Explicit Continue]
			continue;
		}
		// End:0xC3
		if(slotInfo.isCanLevelUp || slotInfo.isCanEnchant)
		{
			canLearnSKills[canLearnSKills.Length] = slotInfo;
			if(slotInfo.isCanEnchant)
			{
				canEnchantSkills[canEnchantSkills.Length] = slotInfo;
			}
		}
		// End:0x11A
		if(slotInfo.isActiveSkill)
		{
			// End:0xEB
			if(slotInfo.isCanLevelUp)
			{
				_skillNoticeNumInfo.activeLearnNum++;
			}
			// End:0x105
			if(slotInfo.isCanEnchant)
			{
				_skillNoticeNumInfo.activeEnchantNum++;
			}
			characterActiveSkills[characterActiveSkills.Length] = slotInfo;
			// [Explicit Continue]
			continue;
		}
		// End:0x134
		if(slotInfo.isCanLevelUp)
		{
			_skillNoticeNumInfo.passiveLearnNum++;
		}
		// End:0x14E
		if(slotInfo.isCanEnchant)
		{
			_skillNoticeNumInfo.passiveEnchantNum++;
		}
		characterPassiveSkills[characterPassiveSkills.Length] = slotInfo;
	}
	MakeSkillGroupInfos(characterActiveSkills, _characterSKillActiveGroups);
	MakeSkillGroupInfos(characterPassiveSkills, _characterSKillPassiveGroups);
	MakeSkillGroupInfos(itemSkills, _itemSkillGroups);
	MakeSkillGroupInfos(canLearnSKills, _canLearnSKillGroups);	
	MakeSkillGroupInfos(canEnchantSkills, _canEnchantSkillGroups);
}

function MakeSkillGroupInfos(array<SkillSlotInfo> skillInfos, out array<SkillGroupInfo> outSkillGroupInfos)
{
	local int i, IconType;
	local SkillSlotInfo tempInfo;
	local SkillGroupInfo tempGroupInfo, defaultGroupInfo;
	local array<SkillGroupInfo> tempGroupInfos, finalGroupInfos;
	local array<SkillSlotInfo> tempSkillArray;

	// End:0xC0 [Loop If]
	for(i = 0; i < skillInfos.Length; i++)
	{
		tempInfo = skillInfos[i];
		IconType = tempInfo.SkillInfo.IconType;
		// End:0x61
		if(IconType < tempGroupInfos.Length)
		{
			tempGroupInfo = tempGroupInfos[IconType];			
		}
		else
		{
			tempGroupInfo = defaultGroupInfo;
		}
		tempGroupInfo.skills.Length = tempGroupInfo.skills.Length + 1;
		tempGroupInfo.skills[tempGroupInfo.skills.Length - 1] = tempInfo;
		tempGroupInfos[IconType] = tempGroupInfo;
	}

	// End:0x150 [Loop If]
	for(i = 0; i < tempGroupInfos.Length; i++)
	{
		tempGroupInfo = tempGroupInfos[i];
		// End:0x146
		if(tempGroupInfo.skills.Length > 0)
		{
			tempSkillArray = tempGroupInfo.skills;
			tempSkillArray.Sort(__OnSortByOrder__Delegate);
			tempGroupInfo.skills = tempSkillArray;
			tempGroupInfo.groupType = i;
			finalGroupInfos[finalGroupInfos.Length] = tempGroupInfo;
		}
	}
	outSkillGroupInfos = finalGroupInfos;	
}

function CustomTooltip GetSkillNoticeNumTooltipInfo(int learnNum, int enchantNum)
{
	local array<DrawItemInfo> drawListArr;

	// End:0xBF
	if(learnNum > 0)
	{
		drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.ToolTip.TooltipIcon_SkillPanel01", false, false, 0, 0, 13, 13, 13, 13);
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14371) $ ": ", getInstanceL2Util().ColorGray, "", false, true, 4);
		drawListArr[drawListArr.Length] = addDrawItemText(string(learnNum), getInstanceL2Util().ColorGold, "", false, false, 0);
	}
	// End:0x1C8
	if(enchantNum > 0)
	{
		// End:0x114
		if(learnNum > 0)
		{
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
			drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(100);
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		}
		drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.ToolTip.TooltipIcon_SkillPanel04", false, false, 0, 0, 10, 13, 10, 13);
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14409) $ ": ", getInstanceL2Util().ColorGray, "", false, true, 4);
		drawListArr[drawListArr.Length] = addDrawItemText(string(enchantNum), getInstanceL2Util().ColorGold, "", false, false, 0);
	}
	return MakeTooltipMultiTextByArray(drawListArr);	
}

function UpdateSkillTabControls()
{
	local int activeNoticeTotalNum, passiveNoticeTotalNum;

	activeNoticeTotalNum = _skillNoticeNumInfo.activeLearnNum + _skillNoticeNumInfo.activeEnchantNum;
	passiveNoticeTotalNum = _skillNoticeNumInfo.passiveLearnNum + _skillNoticeNumInfo.passiveEnchantNum;
	// End:0x158
	if(_selectedTabIndex == 0)
	{
		subTabHandle.ShowWindow();
		characterSkillDecoTex.ShowWindow();
		itemSkillDecoTex.HideWindow();
		itemSkillTitle.HideWindow();
		// End:0xDB
		if(activeNoticeTotalNum > 0)
		{
			activeNoticeNumTextBox.SetText(string(activeNoticeTotalNum));
			activeNoticeNumWnd.SetTooltipCustomType(GetSkillNoticeNumTooltipInfo(_skillNoticeNumInfo.activeLearnNum, _skillNoticeNumInfo.activeEnchantNum));
			activeNoticeNumWnd.ShowWindow();			
		}
		else
		{
			activeNoticeNumWnd.HideWindow();
		}
		// End:0x146
		if(passiveNoticeTotalNum > 0)
		{
			passiveNoticeNumTextBox.SetText(string(passiveNoticeTotalNum));
			passiveNoticeNumWnd.SetTooltipCustomType(GetSkillNoticeNumTooltipInfo(_skillNoticeNumInfo.passiveLearnNum, _skillNoticeNumInfo.passiveEnchantNum));
			passiveNoticeNumWnd.ShowWindow();			
		}
		else
		{
			passiveNoticeNumWnd.HideWindow();
		}		
	}
	else
	{
		if(_selectedTabIndex == 1)
		{
			itemSkillTitle.SetText(GetSystemString(14393));			
		}
		else
		{
			itemSkillTitle.SetText(GetSystemString(14409));
		}
		subTabHandle.HideWindow();
		characterSkillDecoTex.HideWindow();
		itemSkillDecoTex.ShowWindow();
		itemSkillTitle.ShowWindow();
		activeNoticeNumWnd.HideWindow();
		passiveNoticeNumWnd.HideWindow();
	}	
}

function UpdateSkillGroupControls()
{
	local int i, wndHeight;
	local SkillWndGroupItem groupItem;
	local array<SkillGroupInfo> skillGroupInfos;

	UpdateSkillTabControls();
	skillEmptyTextBox.HideWindow();
	spExtractBtn.HideWindow();
	if(_selectedTabIndex == 0)
	{
		// End:0x43
		if(subTabHandle.GetTopIndex() == 0)
		{
			skillGroupInfos = _characterSKillActiveGroups;			
		}
		else if(subTabHandle.GetTopIndex() == 1)
		{
			skillGroupInfos = _characterSKillPassiveGroups;
		}
		else if(subTabHandle.GetTopIndex() == 2)
		{
			skillGroupInfos = _canLearnSKillGroups;
		}
	}
	else
	{
		// End:0x6A
		if(_selectedTabIndex == 1)
		{
			skillGroupInfos = _itemSkillGroups;			
		}
		else if(_selectedTabIndex == 2)
		{
			skillGroupInfos = _canEnchantSkillGroups;
			spExtractBtn.ShowWindow();
		}
	}

	// End:0x194 [Loop If]
	for(i = 0; i < skillGroupItemList.Length; i++)
	{
		groupItem = skillGroupItemList[i];
		// End:0xC0
		if(i >= skillGroupInfos.Length)
		{
			groupItem.SetDisable(true);
			// [Explicit Continue]
			continue;
		}
		groupItem.SetGroupInfo(skillGroupInfos[i]);
		groupItem.SetDisable(false);
		wndHeight = wndHeight + groupItem.Me.GetRect().nHeight;
		// End:0x172
		if(i > 0)
		{
			groupItem.Me.SetAnchor(skillGroupItemList[i - 1].Me.m_WindowNameWithFullPath, "BottomCenter", "TopCenter", 0, 0);
		}
		groupItem.Me.ClearAnchor();
	}
	// End:0x1AF
	if(skillGroupInfos.Length == 0)
	{
		skillEmptyTextBox.ShowWindow();
	}
	skillScrollArea.SetScrollHeight(wndHeight);	
}

function UpdateUIControls()
{
	// End:0x17
	if(Me.IsShowWindow() == false)
	{
		return;
	}
	UpdateSkillGroupControls();	
}

function CloseSkillInfoWnd()
{
	class'SkillInfoWnd'.static.Inst().Me.HideWindow();	
}

delegate int OnSortByOrder(SkillSlotInfo A, SkillSlotInfo B)
{
	// End:0x3D
	if(A.groupType != B.groupType)
	{
		// End:0x37
		if(A.groupType < B.groupType)
		{
			return 0;			
		}
		else
		{
			return -1;
		}
	}
	// End:0x87
	if(A.learned != B.learned)
	{
		// End:0x81
		if((A.learned == true) && B.learned == false)
		{
			return 0;			
		}
		else
		{
			return -1;
		}
	}
	// End:0xC4
	if(A.orderId != B.orderId)
	{
		// End:0xBE
		if(A.orderId < B.orderId)
		{
			return 0;			
		}
		else
		{
			return -1;
		}
	}
	// End:0xEC
	if(A.SkillInfo.SkillID < B.SkillInfo.SkillID)
	{
		return 0;		
	}
	else
	{
		return -1;
	}	
}

function bool IsActiveTypeSkill(int OperateType)
{
	return ! IsPassiveTypeSkill(OperateType);	
}

function bool IsPassiveTypeSkill(int OperateType)
{
	// End:0x0E
	if(OperateType == 2)
	{
		return true;
	}
	return false;	
}

function bool isItemTypeSkill(int IconType)
{
	// End:0x0E
	if(IconType >= ITEM_SKILL_ICON_TYPE)
	{
		return true;
	}
	return false;	
}

function bool CheckShortcutRegistered(int SkillID)
{
	local int i;

	// End:0x38 [Loop If]
	for(i = 0; i < _shortcutSKillList.Length; i++)
	{
		// End:0x2E
		if(_shortcutSKillList[i] == SkillID)
		{
			return true;
		}
	}
	return false;	
}

function bool FindSkillSlotInfo(int SkillID, out SkillSlotInfo slotInfo)
{
	local int i;

	// End:0x0D
	if(SkillID == 0)
	{
		return false;
	}

	// End:0x60 [Loop If]
	for(i = 0; i < _totalSkillInfos.Length; i++)
	{
		// End:0x56
		if(_totalSkillInfos[i].SkillInfo.SkillID == SkillID)
		{
			slotInfo = _totalSkillInfos[i];
			return true;
		}
	}
	return false;	
}

function ShowAndInvenExpandSkillInfo()
{
	// End:0x17
	if(_invenExpandSkillInfo.SkillInfo.SkillID == 0)
	{
		return;
	}
	subTabHandle.SetTopOrder(1, false);
	Me.ShowWindow();
	class'SkillInfoWnd'.static.Inst().OpenWindow(_invenExpandSkillInfo);	
}

function SetSelectedTabIndex(int Index)
{
	_selectedTabIndex = Index;
	skillScrollArea.SetScrollPosition(0);
	UpdateUIControls();	
}

function Rs_EV_SkillListStart(string param)
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	_playerLevel = UserInfo.nLevel;
	ResetInfo();
	_isWaitingSkillListResponse = true;
	_invenExpandSkillInfo.SkillInfo.SkillID = 0;	
}

function Rs_EV_SkillList(string param)
{
	local int ClassID, Level, SubLevel, isCanEnchant, ReuseDelayShareGroupID, SkillDisabled,
		orderId, groupType, replaceSkillId;

	local SkillSlotInfo SkillSlotInfo;
	local SkillInfo SkillInfo, replaceSkillInfo;
	local string strCommand;
	local array<int> subLevelInfos;

	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "SubLevel", SubLevel);
	ParseInt(param, "CanEnchant", isCanEnchant);
	ParseInt(param, "ReuseDelayShareGroupID", ReuseDelayShareGroupID);
	ParseInt(param, "iSkillDisabled", SkillDisabled);
	ParseInt(param, "OrderID", orderId);
	ParseInt(param, "GroupType", groupType);
	ParseInt(param, "ReplaceSkillID", replaceSkillId);
	ParseString(param, "Command", strCommand);
	// End:0x13C
	if(! GetSkillInfo(ClassID, Level, SubLevel, SkillInfo))
	{
		return;
	}
	SkillSlotInfo.SkillInfo = SkillInfo;
	SkillSlotInfo.learned = true;
	SkillSlotInfo.isCanEnchant = bool(isCanEnchant);
	SkillSlotInfo.isEnchantSkill = bool(isCanEnchant);
	class'L2Util'.static.GetSkill2ItemInfo(SkillInfo, SkillSlotInfo.skillItemInfo);
	SkillSlotInfo.skillItemInfo.ReuseDelayShareGroupID = ReuseDelayShareGroupID;
	SkillSlotInfo.skillItemInfo.iSkillDisabled = SkillDisabled;
	SkillSlotInfo.skillItemInfo.MacroCommand = strCommand;
	SkillSlotInfo.enchantLevel = class'SkillEnchantWnd'.static.Inst().ConvertEnchantLevel(SubLevel);
	SkillSlotInfo.orderId = orderId;
	SkillSlotInfo.groupType = groupType;
	SkillSlotInfo.isItemTypeSkill = isItemTypeSkill(SkillInfo.IconType);
	SkillSlotInfo.isActiveSkill = IsActiveTypeSkill(SkillInfo.OperateType);
	SkillSlotInfo.replaceSkillId = replaceSkillId;
	// End:0x303
	if((replaceSkillId >= 0) && GetSkillInfo(replaceSkillId, Level, SubLevel, replaceSkillInfo))
	{
		SkillSlotInfo.SkillInfo.Grade = replaceSkillInfo.Grade;
		SkillSlotInfo.skillItemInfo.Grade = byte(replaceSkillInfo.Grade);
		SkillSlotInfo.SkillInfo.IconType = replaceSkillInfo.IconType;
		SkillSlotInfo.isItemTypeSkill = isItemTypeSkill(replaceSkillInfo.IconType);
	}
	// End:0x34F
	if(isCanEnchant == 1)
	{
		// End:0x34F
		if(GetSkillSubLevelList(ClassID, Level, subLevelInfos) > 0)
		{
			// End:0x34F
			if(SubLevel == subLevelInfos[subLevelInfos.Length - 1])
			{
				SkillSlotInfo.isCanEnchant = false;
			}
		}
	}
	_totalSkillInfos[_totalSkillInfos.Length] = SkillSlotInfo;	
}

function Rs_EV_SkillListEnd(string param);

function Rs_EV_SkillLearningTabAddSkillBegin(string param);

function UpdateSkillDisableState(array<int> stateChangedSkills)
{
	local int i;

	if(Me.IsShowWindow() == false)
	{
		return;
	}

	for(i = 0; i < skillGroupItemList.Length; i++)
	{
		skillGroupItemList[i].UpdateSkillDisableState(stateChangedSkills);
	}	
}

function Rs_EV_SkillLearningTabAddSkillItem(string param)
{
	local int i, ClassID, Level, SubLevel, orderId, groupType,
		requiredLevel;

	local SkillSlotInfo SkillSlotInfo, tmpSkillSlotInfo;
	local SkillInfo SkillInfo;

	ParseInt(param, "ID", ClassID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "SubLevel", SubLevel);
	ParseInt(param, "OrderID", orderId);
	ParseInt(param, "RequiredLevel", requiredLevel);
	ParseInt(param, "GroupType", groupType);
	// End:0xA6
	if(_isWaitingSkillListResponse == false)
	{
		return;
	}
	// End:0xC7
	if(! GetSkillInfo(ClassID, Level, SubLevel, SkillInfo))
	{
		return;
	}

	// End:0x141 [Loop If]
	for(i = 0; i < _totalSkillInfos.Length; i++)
	{
		tmpSkillSlotInfo = _totalSkillInfos[i];
		// End:0x137
		if(tmpSkillSlotInfo.SkillInfo.SkillID == ClassID)
		{
			// End:0x135
			if(requiredLevel <= _playerLevel)
			{
				tmpSkillSlotInfo.isCanLevelUp = true;
				_totalSkillInfos[i] = tmpSkillSlotInfo;
			}
			return;
		}
	}
	// End:0x153
	if(SkillInfo.SkillLevel > 1)
	{
		return;
	}
	// End:0x172
	if(requiredLevel <= _playerLevel)
	{
		SkillSlotInfo.isCanLevelUp = true;		
	}
	else
	{
		SkillSlotInfo.isCanLevelUp = false;
	}
	SkillSlotInfo.SkillInfo = SkillInfo;
	SkillSlotInfo.learned = false;
	SkillSlotInfo.isCanEnchant = false;
	SkillSlotInfo.isEnchantSkill = false;
	class'L2Util'.static.GetSkill2ItemInfo(SkillInfo, SkillSlotInfo.skillItemInfo);
	SkillSlotInfo.enchantLevel = class'SkillEnchantWnd'.static.Inst().ConvertEnchantLevel(SubLevel);
	SkillSlotInfo.orderId = orderId;
	SkillSlotInfo.groupType = groupType;
	SkillSlotInfo.isShortCut = false;
	SkillSlotInfo.isItemTypeSkill = isItemTypeSkill(SkillInfo.IconType);
	SkillSlotInfo.isActiveSkill = IsActiveTypeSkill(SkillInfo.OperateType);
	SkillSlotInfo.replaceSkillId = -1;
	_totalSkillInfos[_totalSkillInfos.Length] = SkillSlotInfo;	
}

function Rs_EV_SkillLearningTabAddSkillEnd(string param)
{
	// End:0x1E
	if(_isWaitingSkillListResponse == true)
	{
		ResetSkillGroupInfo();
		UpdateSkillInfos();
		UpdateUIControls();
	}
	_isWaitingSkillListResponse = false;	
}

function Nt_EV_ApplySkillAvailability(string param)
{
	local int i, preSkillDisable, newSKillDisable;
	local SkillSlotInfo slotInfo;
	local bool needUpdateUIControls;
	local array<int> stateChangedSkills;

	// End:0x17
	if(Me.IsShowWindow() == false)
	{
		return;
	}

	// End:0xD4 [Loop If]
	for(i = 0; i < _totalSkillInfos.Length; i++)
	{
		slotInfo = _totalSkillInfos[i];
		preSkillDisable = slotInfo.skillItemInfo.iSkillDisabled;
		newSKillDisable = GetSkillAvailability(slotInfo.SkillInfo.SkillID, slotInfo.SkillInfo.SkillLevel, slotInfo.SkillInfo.SkillSubLevel);
		// End:0xCA
		if(preSkillDisable != newSKillDisable)
		{
			needUpdateUIControls = true;
			slotInfo.skillItemInfo.iSkillDisabled = newSKillDisable;
			_totalSkillInfos[i] = slotInfo;
			stateChangedSkills[stateChangedSkills.Length] = slotInfo.SkillInfo.SkillID;
		}
	}
	// End:0xEC
	if(needUpdateUIControls == true)
	{
		UpdateSkillDisableState(stateChangedSkills);
	}	
}

function Rs_EV_NotifySubjob(string param);

function Rs_EV_CreatedSubjob(string param);

function Rs_EV_ChangedSubjob(string param);

function Rs_EV_UpdateUserInfo(string param)
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	_playerLevel = UserInfo.nLevel;	
}

function Nt_EV_ShortcutSkillListUpdate(string param)
{
	// End:0x17
	if(Me.IsShowWindow() == false)
	{
		return;
	}
	UpdateShortcutInfoWithTimer();	
}

function Nt_EV_GamingStateExit()
{
	Me.HideWindow();	
}

event OnRegisterEvent()
{
	// End:0x0E
	if((IsUseRenewalSkillWnd()) == false)
	{
		return;
	}
	RegisterEvent(EV_SkillListStart);
	RegisterEvent(EV_SkillList);
	RegisterEvent(EV_SkillListEnd);
	RegisterEvent(EV_SkillLearningTabAddSkillBegin);
	RegisterEvent(EV_SkillLearningTabAddSkillItem);
	RegisterEvent(EV_SkillLearningTabAddSkillEnd);
	RegisterEvent(EV_ApplySkillAvailability);
	RegisterEvent(EV_NotifySubjob);
	RegisterEvent(EV_CreatedSubjob);
	RegisterEvent(EV_ChangedSubjob);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_ShortcutSkillListUpdate);
	RegisterEvent(EV_GamingStateExit);	
}

event OnEvent(int EventID, string param)
{
	// End:0x0E
	if((IsUseRenewalSkillWnd()) == false)
	{
		return;
	}
	// End:0x25
	if(Me.IsShowWindow() == false)
	{
		return;
	}
	switch(EventID)
	{
		// End:0x42
		case EV_SkillListStart:
			Rs_EV_SkillListStart(param);
			// End:0x142
			break;
		// End:0x58
		case EV_SkillList:
			Rs_EV_SkillList(param);
			// End:0x142
			break;
		// End:0x6E
		case EV_SkillListEnd:
			Rs_EV_SkillListEnd(param);
			// End:0x142
			break;
		// End:0x84
		case EV_SkillLearningTabAddSkillBegin:
			Rs_EV_SkillLearningTabAddSkillBegin(param);
			// End:0x142
			break;
		// End:0x9A
		case EV_SkillLearningTabAddSkillItem:
			Rs_EV_SkillLearningTabAddSkillItem(param);
			// End:0x142
			break;
		// End:0xB0
		case EV_SkillLearningTabAddSkillEnd:
			Rs_EV_SkillLearningTabAddSkillEnd(param);
			// End:0x142
			break;
		// End:0xC6
		case EV_ApplySkillAvailability:
			Nt_EV_ApplySkillAvailability(param);
			// End:0x142
			break;
		// End:0xDC
		case EV_NotifySubjob:
			Rs_EV_NotifySubjob(param);
			// End:0x142
			break;
		// End:0xF2
		case EV_CreatedSubjob:
			Rs_EV_CreatedSubjob(param);
			// End:0x142
			break;
		// End:0x108
		case EV_ChangedSubjob:
			Rs_EV_ChangedSubjob(param);
			// End:0x142
			break;
		// End:0x11B
		case EV_UpdateUserInfo:
			Rs_EV_UpdateUserInfo(param);
			// End:0x142
			break;
		// End:0x131
		case EV_ShortcutSkillListUpdate:
			Nt_EV_ShortcutSkillListUpdate(param);
			// End:0x142
			break;
		// End:0x13F
		case EV_GamingStateExit:
			Nt_EV_GamingStateExit();
			// End:0x142
			break;
	}	
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "Skill_Tab0":
		case "Skill_Tab1":
		case "Skill_Tab2":
			UpdateUIControls();
			skillScrollArea.SetScrollPosition(0);
			break;
		case "HelpBtn":
			//class'HelpWnd'.static.ShowHelp(15, 1);
			break;
		case "SPExtract_Btn":
			toggleWindow("SkillSpExtractWnd", true, true);
			break;
	}	
}

event OnRClickButton(string btnName)
{
	switch(btnName)
	{
		// End:0x16
		case "Skill_Tab0":
		// End:0x33
		case "Skill_Tab1":
			OnClickButton(btnName);
			// End:0x36
			break;
	}	
}

event OnSkillSlotInfoClicked(SkillSlotInfo SkillSlotInfo)
{
	local bool isShowSkillLearnPage;

	// End:0x14
	if(_selectedTabIndex == 2 || _selectedTabIndex == 0 && subTabHandle.GetTopIndex() == 2)
	{
		isShowSkillLearnPage = true;
	}
	class'SkillInfoWnd'.static.Inst().OpenWindow(SkillSlotInfo, isShowSkillLearnPage);	
}

event OnTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	SetSelectedTabIndex(Index);
}

function OnTimer(int TimerID)
{
	// End:0x2D
	if(TimerID == TIMER_SHORTCUT_UPDATE_ID)
	{
		UpdateShortcutSkillInfo();
		UpdateSkillInfos();
		UpdateSkillGroupControls();
		Me.KillTimer(TIMER_SHORTCUT_UPDATE_ID);
	}	
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();	
}

event OnShow()
{
	// End:0x29
	if(GetGameStateName() != "GAMINGSTATE")
	{
		Me.HideWindow();
		return;
	}
	class'SkillEnchantWnd'.static.Inst().Me.HideWindow();
	Me.SetFocus();
	if(MagicSkillWnd(GetScript("MagicSkillWnd"))._isSkillLearnNotice == true)
	{
		_selectedTabIndex = 0;
		subTabHandle.SetTopOrder(2, false);
		MagicSkillWnd(GetScript("MagicSkillWnd"))._isSkillLearnNotice = false;		
	}
	tabGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(_selectedTabIndex, true);
	UpdateShortcutSkillInfo();
	RequestSkillList();
	UpdateUIControls();
	skillEmptyTextBox.HideWindow();	
}

event OnHide()
{
	class'SkillInfoWnd'.static.Inst().Me.HideWindow();
	class'SkillInfoWnd'.static.Inst().OnHide();
	_shortcutSKillList.Length = 0;
	Me.KillTimer(TIMER_SHORTCUT_UPDATE_ID);
	_isWaitingSkillListResponse = false;
	ResetInfo();	
}

event OnReceivedCloseUI()
{
	// End:0x41
	if(class'SkillInfoWnd'.static.Inst().Me.IsShowWindow())
	{
		class'SkillInfoWnd'.static.Inst().OnReceivedCloseUI();		
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
