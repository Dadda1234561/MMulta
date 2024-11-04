class SkillWndGroupItem extends UICommonAPI;

const SKILL_SLOT_COLUMN_NUM = 8;
const SKILL_SLOT_GAP_Y_ = 12;
const SKILL_SLOT_HEIGHT = 48;

var SkillWnd.SkillGroupInfo _info;
var array<SkillWnd.SkillSlotInfo> _slotInfos;
var WindowHandle Me;
var TextBoxHandle TitleTextBox;
var ItemWindowHandle skillItemWnd;

delegate DelegateOnSkillInfoClicked(SkillWnd.SkillSlotInfo SkillSlotInfo);

function Init(WindowHandle Owner)
{
	local string ownerFullPath;

	ownerFullPath = Owner.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	TitleTextBox = GetTextBoxHandle(ownerFullPath $ ".SkillNameStr");
	skillItemWnd = GetItemWindowHandle(ownerFullPath $ ".SkillItem");	
}

function SetGroupInfo(SkillWnd.SkillGroupInfo Info)
{
	local int i, windowHeight, SlotIndex, Row, prevGroup, nextGroup;

	local SkillWnd.SkillSlotInfo tmpSkillInfo;

	_info = Info;
	_slotInfos.Length = 0;

	// End:0xCD [Loop If]
	for(i = 0; i < _info.skills.Length; i++)
	{
		tmpSkillInfo = _info.skills[i];
		nextGroup = tmpSkillInfo.groupType;
		// End:0xAB
		if(i > 0)
		{
			prevGroup = _info.skills[i - 1].groupType;
			// End:0xAB
			if(prevGroup != nextGroup)
			{
				SlotIndex = (appCeil(float(_slotInfos.Length) / SKILL_SLOT_COLUMN_NUM)) * SKILL_SLOT_COLUMN_NUM;
			}
		}
		_slotInfos[SlotIndex] = tmpSkillInfo;
		SlotIndex++;
	}
	TitleTextBox.SetText(getSkillTypeString(Info.groupType));
	skillItemWnd.Clear();

	// End:0x1D8 [Loop If]
	for(i = 0; i < _slotInfos.Length; i++)
	{
		tmpSkillInfo = _slotInfos[i];
		// End:0x15F
		if(tmpSkillInfo.learned == false)
		{
			tmpSkillInfo.skillItemInfo.ForeTexture = "L2UI_CT1.WindowDisable_BG";
		}
		// End:0x19A
		if(tmpSkillInfo.SkillInfo.SkillID == 0)
		{
			tmpSkillInfo.skillItemInfo.ShortcutType = 2;
			tmpSkillInfo.skillItemInfo.ForeTexture = "";
		}
		tmpSkillInfo.skillItemInfo.SkillStateBitflag = MakeSkillStateBitflag(tmpSkillInfo);
		skillItemWnd.AddItem(tmpSkillInfo.skillItemInfo);
	}
	Row = appCeil(float(_slotInfos.Length) / SKILL_SLOT_COLUMN_NUM);
	windowHeight = (SKILL_SLOT_GAP_Y_ + SKILL_SLOT_HEIGHT) * Row;
	skillItemWnd.SetWindowSize(skillItemWnd.GetRect().nWidth, windowHeight);
	Me.SetWindowSize(Me.GetRect().nWidth, windowHeight + 45);	
}

function byte MakeSkillStateBitflag(SkillWnd.SkillSlotInfo slotInfo)
{
	local byte bitflag;

	// End:0x3A
	if((slotInfo.learned == false) && slotInfo.isCanLevelUp == false)
	{
		bitflag = byte(bitflag | byte(1));
	}
	// End:0x75
	if((slotInfo.learned == false) && slotInfo.isCanLevelUp == true)
	{
		bitflag = byte(bitflag | byte(2));
	}
	// End:0xB0
	if((slotInfo.learned == true) && slotInfo.isCanLevelUp == true)
	{
		bitflag = byte(bitflag | byte(4));
	}
	// End:0xD5
	if(slotInfo.isShortCut)
	{
		bitflag = byte(bitflag | byte(8));
	}
	// End:0xFA
	if(slotInfo.isCanEnchant)
	{
		bitflag = byte(bitflag | byte(16));
	}
	// End:0x11F
	if(slotInfo.isActiveSkill)
	{
		bitflag = byte(bitflag | byte(32));
	}
	return bitflag;	
}

function SkillWnd.SkillSlotInfo GetSkillSlotInfo(int SkillID, int SkillLevel)
{
	local SkillWnd.SkillSlotInfo SkillSlotInfo;
	local int i;

	// End:0x76 [Loop If]
	for(i = 0; i < _info.skills.Length; i++)
	{
		SkillSlotInfo = _info.skills[i];
		// End:0x6C
		if((SkillSlotInfo.SkillInfo.SkillID == SkillID) && SkillSlotInfo.SkillInfo.SkillLevel == SkillLevel)
		{
			return SkillSlotInfo;
		}
	}
	SkillSlotInfo.SkillInfo.SkillID = 0;
	return SkillSlotInfo;	
}

function UpdateSkillDisableState(array<int> stateChangedSkills)
{
	local int i, Id, Level, SubLevel, SkillDisabled;

	// End:0x17
	if(Me.IsShowWindow() == false)
	{
		return;
	}

	for(i = 0; i < skillItemWnd.GetItemNum(); i++)
	{
		skillItemWnd.GetItemIdLevel(i, Id, Level, SubLevel);
		SkillDisabled = GetSkillAvailability(Id, Level, SubLevel);
		skillItemWnd.SetItemSkillDisabled(i, SkillDisabled);
	}	
}

function SetDisable(bool IsDisable)
{
	// End:0x2D
	if(IsDisable == true)
	{
		skillItemWnd.Clear();
		Me.HideWindow();		
	}
	else
	{
		Me.ShowWindow();
	}	
}

event OnClickItem(string strID, int Index)
{
	local ItemInfo Info;
	local SkillWnd.SkillSlotInfo SkillSlotInfo;

	skillItemWnd.GetItem(Index, Info);
	// End:0x30
	if(Info.Id.ClassID == 0)
	{
		return;
	}
	SkillSlotInfo = GetSkillSlotInfo(Info.Id.ClassID, Info.Level);
	// End:0x9D
	if((SkillSlotInfo.learned == true) && SkillSlotInfo.isActiveSkill == true)
	{
		UseSkill(SkillSlotInfo.skillItemInfo.Id, SkillSlotInfo.skillItemInfo.ShortcutType);
	}	
}

event OnRClickItemWithHandle(ItemWindowHandle itemWnd, int Index)
{
	local ItemInfo Info;

	itemWnd.GetItem(Index, Info);
	// End:0x30
	if(Info.Id.ClassID == 0)
	{
		return;
	}
	DelegateOnSkillInfoClicked(GetSkillSlotInfo(Info.Id.ClassID, Info.Level));	
}

event OnDBClickItemWithHandle(ItemWindowHandle itemWnd, int Index)
{
	OnRClickItemWithHandle(itemWnd, Index);	
}

defaultproperties
{
}
