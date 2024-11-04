class QuestConfirmWnd extends UICommonAPI;

const DIALOG_TOOLTIP_KEY0 = "\\#$Tooltip0";

var private TextBoxHandle txtQuestTitle;
var private TextBoxHandle txtQuestCategory;
var private TextBoxHandle txtRecommandedLevel;
var private TextBoxHandle txtRecommandedLevelText;
var private TextBoxHandle txtQuestType;
var private TextBoxHandle txtQuestTarget;
var private TextBoxHandle txtQuestRewardItemTreeTitle;
var private TreeHandle QuestRewardItemTree;
var private HtmlHandle txtQuestInfo;
var L2Util util;

static function QuestConfirmWnd Inst()
{
	return QuestConfirmWnd(GetScript("QuestConfirmWnd"));	
}

event OnLoad()
{
	Initialize();
	util = L2Util(GetScript("L2Util"));	
}

function Initialize()
{
	txtQuestTitle = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestTitle");
	txtQuestCategory = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestCategory");
	txtRecommandedLevel = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtRecommandedLevel");
	txtRecommandedLevelText = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtRecommandedLevelText");
	txtQuestType = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestType");
	txtQuestTarget = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestTarget");
	txtQuestRewardItemTreeTitle = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestRewardItemTreeTitle");
	QuestRewardItemTree = GetTreeHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestRewardItemTree");
	txtQuestInfo = GetHtmlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestInfo");	
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x20
		case "confirmlBtn":
			HandoeClickConfirm();
			// End:0x43
			break;
		// End:0x40
		case "cancelBtn":
			m_hOwnerWnd.HideWindow();
			// End:0x43
			break;
	}	
}

event OnHide()
{
	allclear();	
}

event OnShow()
{
	m_hOwnerWnd.SetFocus();	
}

private function HandoeClickConfirm()
{
	Debug("퀘스트 수락");
	m_hOwnerWnd.HideWindow();
	class'QuestDialogWnd'.static.Inst()._ConfirmQuest();	
}

function _ShowQuestEnd()
{
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".confirmlBtn").SetButtonName(898);
	SetCurrentQuestInfos(false);	
}

function _ShowQuestConfirm()
{
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".confirmlBtn").SetButtonName(7422);
	SetCurrentQuestInfos(true);	
}

private function SetCurrentQuestInfos(bool bConfirm)
{
	local NQuestUIData qUIData;
	local QuestDialogWnd QuestDialogWndScr;
	local NQuestDialogUIData questDialogUIData;
	local string QuestInfo;

	QuestDialogWndScr = class'QuestDialogWnd'.static.Inst();
	// End:0x35
	if(! GetNQuestData(QuestDialogWndScr._currentQuestID, qUIData))
	{
		return;
	}
	// End:0x58
	if(QuestDialogWndScr._currentQuestID < QuestDialogWndScr.const.QUEST_CATEGORY_MAIN)
	{
		return;
	}
	txtQuestTitle.SetText(qUIData.Name);
	// End:0xAF
	if(QuestDialogWndScr._currentQuestID < QuestDialogWndScr.const.QUEST_CATEGORY_SUB)
	{
		txtQuestCategory.SetText(GetSystemString(2738));		
	}
	else
	{
		// End:0xED
		if(QuestDialogWndScr._currentQuestID < QuestDialogWndScr.const.QUEST_CATEGORY_SPECIAL)
		{
			txtQuestCategory.SetText(GetSystemString(2341));			
		}
		else
		{
			txtQuestCategory.SetText(GetSystemString(1796));
		}
	}
	txtRecommandedLevel.SetText(GetSystemString(922) @ ":");
	// End:0x179
	if(qUIData.LevelMax > 0 && qUIData.LevelMin > 0)
	{
		txtRecommandedLevelText.SetText(string(qUIData.LevelMin) $ "~" $ string(qUIData.LevelMax));		
	}
	else if(qUIData.LevelMin > 0)
	{
		txtRecommandedLevelText.SetText(string(qUIData.LevelMin) $ " " $ GetSystemString(859));			
	}
	else
	{
		txtRecommandedLevelText.SetText(GetSystemString(866));
	}

	switch(qUIData.Type)
	{
		// End:0x201
		case NQT_ONETIME:
			txtQuestType.SetText(GetSystemString(862));
			// End:0x26A
			break;
		// End:0x223
		case NQT_DAILY:
			txtQuestType.SetText(GetSystemString(2788));
			// End:0x26A
			break;
		// End:0x245
		case NQT_WEEKLY:
			txtQuestType.SetText(GetSystemString(14389));
			// End:0x26A
			break;
		// End:0x267
		case NQT_REPEAT:
			txtQuestType.SetText(GetSystemString(861));
			// End:0x26A
			break;
	}
	// End:0x2B8
	if(qUIData.Goal.Num > 1)
	{
		txtQuestTarget.SetText(qUIData.Goal.Name $ "x" $ string(qUIData.Goal.Num));		
	}
	else
	{
		txtQuestTarget.SetText(qUIData.Goal.Name);
	}
	API_GetNQuestDialogData(QuestDialogWndScr._currentQuestID, questDialogUIData);
	QuestInfo = questDialogUIData.QuestInfo;
	ReplaceText(QuestInfo, DIALOG_TOOLTIP_KEY0 $ "S", "");
	ReplaceText(QuestInfo, DIALOG_TOOLTIP_KEY0 $ "E", "");
	txtQuestInfo.LoadHtmlFromString(htmlSetHtmlStart(QuestInfo));
	setRewardItem(qUIData.Reward);
	m_hOwnerWnd.ShowWindow();	
}

private function InsertRewardItems(array<NQuestRewardItemData> Items)
{
	local string treeName;
	local int i;
	local string setTreeName, strRetName, IconName, ItemName;

	treeName = m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestRewardItemTree";
	TreeClear(treeName);
	util.TreeInsertRootNode(treeName, "List", "", 0, 2);
	setTreeName = "List";

	// End:0x477 [Loop If]
	for(i = 0; i < Items.Length; i++)
	{
		strRetName = util.TreeInsertItemNode(treeName, string(i), setTreeName, false, -4, -2);
		// End:0x100
		if((float(i) % float(2)) == float(1))
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.etc.textbackline", 244, 38,,,,, 14);			
		}
		else
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", 244, 38);
		}
		util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -238, 2);
		IconName = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(Items[i].ItemClassID));
		ItemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(Items[i].ItemClassID));
		util.TreeInsertTextureNodeItem(treeName, strRetName, IconName, 32, 32, -34, 3);
		util.TreeInsertTextNodeItem(treeName, strRetName, ItemName, 5, 6, util.ETreeItemTextType.COLOR_DEFAULT, true,, Items[i].ItemClassID);
		// End:0x292
		if(Items[i].Amount == 0)
		{
			util.TreeInsertTextNodeItem(treeName, strRetName, GetSystemString(584), 48, -18, util.ETreeItemTextType.COLOR_GOLD,, true);
			// [Explicit Continue]
			continue;
		}
		switch(Items[i].ItemClassID)
		{
			// End:0x304
			case 57:
				util.TreeInsertTextNodeItem(treeName, strRetName, MakeFullSystemMsg(GetSystemMessage(2932), MakeCostString(string(Items[i].Amount)), ""), 44, -17, util.ETreeItemTextType.COLOR_GOLD,, true);
				// End:0x46D
				break;
			// End:0x30C
			case 15623:
			// End:0x314
			case 15624:
			// End:0x31C
			case 15625:
			// End:0x324
			case 15626:
			// End:0x32C
			case 15627:
			// End:0x334
			case 15628:
			// End:0x33C
			case 15629:
			// End:0x344
			case 15630:
			// End:0x34C
			case 15631:
			// End:0x354
			case 15632:
			// End:0x35C
			case 15633:
			// End:0x3AC
			case 47130:
				util.TreeInsertTextNodeItem(treeName, strRetName, MakeCostString(string(Items[i].Amount)), 44, -17, util.ETreeItemTextType.COLOR_GOLD,, true);
				// End:0x46D
				break;
			// End:0x40F
			case 95641:
				util.TreeInsertTextNodeItem(treeName, strRetName, MakeFullSystemMsg(GetSystemMessage(13405), MakeCostString(string(Items[i].Amount)), ""), 44, -17, util.ETreeItemTextType.COLOR_GOLD,, true);
				// End:0x46D
				break;
			// End:0xFFFF
			default:
				util.TreeInsertTextNodeItem(treeName, strRetName, MakeFullSystemMsg(GetSystemMessage(1983), MakeCostString(string(Items[i].Amount)), ""), 44, -17, util.ETreeItemTextType.COLOR_GOLD,, true);
				// End:0x46D
				break;
		}
	}	
}

private function setRewardItem(NQuestRewardData rewardDatas)
{
	local int i;
	local array<NQuestRewardItemData> Items;
	local NQuestRewardItemData rewardItemData;

	// End:0x47
	if(rewardDatas.Level > 0)
	{
		rewardItemData.ItemClassID = 95641;
		rewardItemData.Amount = rewardDatas.Level;
		Items[Items.Length] = rewardItemData;
	}
	// End:0x8E
	if(rewardDatas.Exp > 0)
	{
		rewardItemData.ItemClassID = 15623;
		rewardItemData.Amount = rewardDatas.Exp;
		Items[Items.Length] = rewardItemData;
	}
	// End:0xD5
	if(rewardDatas.Sp > 0)
	{
		rewardItemData.ItemClassID = 15624;
		rewardItemData.Amount = rewardDatas.Sp;
		Items[Items.Length] = rewardItemData;
	}

	// End:0x118 [Loop If]
	for(i = 0; i < rewardDatas.Items.Length; i++)
	{
		Items[Items.Length] = rewardDatas.Items[i];
	}
	InsertRewardItems(Items);	
}

function TreeClear(string Str)
{
	class'UIAPI_TREECTRL'.static.Clear(Str);	
}

function allclear()
{
	util.TreeClear(m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestRewardItemTree");
	txtQuestTitle.SetText("");
	txtRecommandedLevel.SetText("");
	txtRecommandedLevelText.SetText("");
	txtQuestType.SetText("");
	txtQuestTarget.SetText("");	
}

private function bool API_GetNQuestDialogData(int a_QuestID, out NQuestDialogUIData o_data)
{
	return GetNQuestDialogData(a_QuestID, o_data);	
}

private function string GetCurrentTeleportName()
{
	local int tID;
	local TeleportListAPI.TeleportListData tInfo;

	tID = class'QuestDialogWnd'.static.Inst()._GetCurrentTeleportID();
	tInfo = class'TeleportListAPI'.static.GetFirstTeleportListData();

	// End:0x7C [Loop If]
	while("" != tInfo.Name)
	{
		// End:0x64
		if(tInfo.Id == tID)
		{
			return tInfo.Name;
		}
		tInfo = class'TeleportListAPI'.static.GetNextTeleportListData();
	}
	return "";	
}

defaultproperties
{
}
