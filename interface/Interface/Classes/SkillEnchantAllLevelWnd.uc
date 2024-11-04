class SkillEnchantAllLevelWnd extends UICommonAPI;

const LIST_NUM_MAX = 10;

var WindowHandle Me;
var WindowHandle listWnd;
var ItemWindowHandle skillItemWnd;
var TextBoxHandle skillNameTextBox;
var TextBoxHandle skillLevelTextBox;
var TextBoxHandle skillEnchantLvTextBox;
var WindowHandle listScrollArea;
var array<WindowHandle> listWnds;

static function SkillEnchantAllLevelWnd Inst()
{
	return SkillEnchantAllLevelWnd(GetScript("SkillEnchantAllLevelWnd"));	
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
	listWnd = GetWindowHandle(ownerFullPath $ ".SkillList_Wnd");
	skillItemWnd = GetItemWindowHandle(ownerFullPath $ ".SkillItem_ItemWindow");
	skillNameTextBox = GetTextBoxHandle(ownerFullPath $ ".SkillName_Txt");
	skillLevelTextBox = GetTextBoxHandle(ownerFullPath $ ".SkillLevel_Txt");
	skillEnchantLvTextBox = GetTextBoxHandle(ownerFullPath $ ".SkillEnchantNum_Txt");
	listScrollArea = GetWindowHandle(listWnd.m_WindowNameWithFullPath $ ".SkillList_Scroll");
	listWnds.Length = 0;
	
	// End:0x156 [Loop If]
	for(i = 0; i < LIST_NUM_MAX; i++)
	{
		AddListItemControl(listWnds, "LevelList", i, listScrollArea);
	}	
}

function AddListItemControl(out array<WindowHandle> componentList, string componentName, int Index, WindowHandle parentWnd)
{
	local WindowHandle targetWindowHandle;

	targetWindowHandle = GetWindowHandle(parentWnd.m_WindowNameWithFullPath $ "." $ componentName $ string(Index));
	componentList[componentList.Length] = targetWindowHandle;	
}

function ShowInfo(SkillInfo baseSkillInfo, int replaceSkillId)
{
	local ItemInfo skillItemInfo;
	local int i, enchantLevel, wndHeight;
	local array<int> subLevelInfos;
	local WindowHandle itemListWnd;
	local TextBoxHandle TitleTextBox, currentlyTextBox;
	local HtmlHandle descHtml;
	local SkillInfo Info, descSkillInfo;

	Info = baseSkillInfo;
	// End:0x26
	if(replaceSkillId > 0)
	{
		Info.SkillID = replaceSkillId;
	}
	// End:0x5C
	if(GetSkillSubLevelList(Info.SkillID, Info.SkillLevel, subLevelInfos) == 0)
	{
		return;
		Me.HideWindow();
	}
	class'L2Util'.static.GetSkill2ItemInfo(Info, skillItemInfo);
	skillItemInfo.Id.ClassID = 0;
	skillItemInfo.SubLevel = 0;
	// End:0xC0
	if(! skillItemWnd.SetItem(0, skillItemInfo))
	{
		skillItemWnd.AddItem(skillItemInfo);
	}

	// End:0x368 [Loop If]
	for(i = 0; i < listWnds.Length; i++)
	{
		itemListWnd = listWnds[i];
		// End:0x10A
		if(i >= subLevelInfos.Length)
		{
			itemListWnd.HideWindow();
			// [Explicit Continue]
			continue;
		}
		TitleTextBox = GetTextBoxHandle(itemListWnd.m_WindowNameWithFullPath $ ".Level_Txt");
		descHtml = GetHtmlHandle(itemListWnd.m_WindowNameWithFullPath $ ".Description_Txt");
		currentlyTextBox = GetTextBoxHandle(itemListWnd.m_WindowNameWithFullPath $ ".Currently_Txt");
		GetSkillInfo(Info.SkillID, Info.SkillLevel, subLevelInfos[i], descSkillInfo);
		TitleTextBox.SetText("+" $ string(i));
		descHtml.LoadHtmlFromString(class'SkillEnchantWnd'.static.Inst().ConvertHtmlDesc(descSkillInfo.SkillDesc));
		itemListWnd.ShowWindow();
		// End:0x254
		if(Info.SkillSubLevel == subLevelInfos[i])
		{
			enchantLevel = i;
			currentlyTextBox.SetText(GetSystemString(3351));			
		}
		else
		{
			currentlyTextBox.SetText("");
		}
		descHtml.SetDraggable(false);
		descHtml.SetWindowSize(descHtml.GetRect().nWidth, descHtml.GetFrameMaxHeight());
		itemListWnd.SetWindowSize(itemListWnd.GetRect().nWidth, descHtml.GetRect().nHeight + 41);
		wndHeight = wndHeight + itemListWnd.GetRect().nHeight;
		// End:0x34F
		if(i > 0)
		{
			itemListWnd.SetAnchor(listWnds[i - 1].m_WindowNameWithFullPath, "BottomCenter", "TopCenter", 0, 0);
		}
		itemListWnd.ClearAnchor();
	}
	listScrollArea.SetScrollHeight(wndHeight);
	skillNameTextBox.SetText(Info.SkillName);
	// End:0x3BA
	if(Info.LevelHide == true)
	{
		skillLevelTextBox.SetText("");		
	}
	else
	{
		skillLevelTextBox.SetText(class'SkillEnchantWnd'.static.Inst().GetSkillLevelStr(Info.SkillLevel));
	}
	skillEnchantLvTextBox.SetText(class'SkillEnchantWnd'.static.Inst().GetEnchantLvName(enchantLevel));
	// End:0x456
	if(skillEnchantLvTextBox.GetText() == "")
	{
		skillEnchantLvTextBox.SetWindowSize(0, skillEnchantLvTextBox.GetRect().nHeight);		
	}
	else
	{
		skillEnchantLvTextBox.SetText(skillEnchantLvTextBox.GetText() $ " ");
	}
	listScrollArea.SetScrollPosition(0);
	Me.ShowWindow();
	Me.SetFocus();	
}

event OnLoad()
{
	Initialize();	
}

defaultproperties
{
}
