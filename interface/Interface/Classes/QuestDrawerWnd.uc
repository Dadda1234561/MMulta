class QuestDrawerWnd extends UICommonAPI;

const DIALOG_TOOLTIP_KEY0 = "\\#$Tooltip0";

var private TextBoxHandle txtQuestTitle;
var private TextBoxHandle txtQuestCategory;
var private TextBoxHandle txtRecommandedLevel;
var private TextBoxHandle txtRecommandedLevelText;
var private TextBoxHandle txtQuestType;
var private TextBoxHandle txtQuestTarget;
var private TreeHandle QuestRewardItemTree;
var private HtmlHandle txtQuestInfo;
var L2Util util;
var int currentQuestID;
var private bool isComplete;
var private bool isEnd;
var private bool isProgress;
var private UIControlDialogAssets teleportDialog;
var private WindowHandle modalWnd;

static function QuestDrawerWnd Inst()
{
	return QuestDrawerWnd(GetScript("QuestDrawerWnd"));	
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
	txtQuestInfo = GetHtmlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestInfo");
	QuestRewardItemTree = GetTreeHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestRewardItemTree");
	modalWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WindowDisable_Wnd");
	teleportDialog = class'UIControlDialogAssets'.static.InitScript(GetWindowHandle(modalWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset"));
	teleportDialog.SetDisableWindow(modalWnd);
	teleportDialog.NeedItemRichListCtrl.SetColumnWidth(0, 220);	
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x2A
		case "btnGiveUpCurrentQuest":
			OnbtnGiveUpCurrentQuestClick();
			// End:0x75
			break;
		// End:0x45
		case "btnShowDialog":
			_OnbtnShowDialog();
			// End:0x75
			break;
		// End:0x5B
		case "btnClose":
			OnBtnCloseClick();
			// End:0x75
			break;
		// End:0x72
		case "btnAction":
			_OnbtnActionClick();
			// End:0x75
			break;
	}	
}

event OnHide()
{
	teleportDialog.Hide();
	allclear();
	currentQuestID = -1;	
}

event OnShow()
{
	m_hOwnerWnd.SetFocus();	
}

private function OnbtnGiveUpCurrentQuestClick()
{
	local NQuestUIData qUIData;

	// End:0x17
	if(! API_GetNQuestData(currentQuestID, qUIData))
	{
		return;
	}
	// End:0x31
	if(currentQuestID < class'QuestDialogWnd'.const.QUEST_CATEGORY_SUB)
	{
		return;
	}
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(182), qUIData.Name, ""), string(self));
	class'DialogBox'.static.Inst().AnchorToOwner(0);
	class'DialogBox'.static.Inst().DelegateOnOK = RQ_C_EX_QUEST_CANCEL;	
}

function _OnbtnShowDialog()
{
	class'QuestDialogWnd'.static.Inst()._SohwDialogAgain(currentQuestID);	
}

private function OnBtnCloseClick()
{
	m_hOwnerWnd.HideWindow();	
}

function _OnbtnActionClick()
{
	// End:0x2D
	if(isComplete)
	{
		// End:0x1B
		if(isProgress)
		{
			ShowCompleteDialog();			
		}
		else
		{
			m_hOwnerWnd.HideWindow();
		}		
	}
	else
	{
		ShowTeleportDialog();
	}	
}

private function ShowCompleteDialog()
{
	class'QuestDialogWnd'.static.Inst()._ShowCompleteDialog(currentQuestID);	
}

private function int GetCurrentTeleportID()
{
	local NQuestUIData questUIData;

	API_GetNQuestData(currentQuestID, questUIData);
	return questUIData.TeleportID;	
}

private function ShowTeleportDialog()
{
	local string Desc, teleportName;
	local TeleportListAPI.TeleportListData targetTeleport;
	local INT64 teleportCost;

	// End:0x12
	if(! GetCurrentTeleportInfo(targetTeleport))
	{
		return;
	}
	// End:0x55
	if(targetTeleport.Level > 0)
	{
		teleportName = "(" $ targetTeleport.Name $ " Lv " $ string(targetTeleport.Level) $ ")";		
	}
	else
	{
		teleportName = "(" $ targetTeleport.Name $ ")";
	}
	Desc = GetSystemMessage(5239) $ "\\n\\n" $ teleportName;
	GetRichListCtrlHandle(modalWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset.NeedItemWnd.NeedItemRichListCtrl").SetUseHorizontalScrollBar(false);
	teleportDialog.SetDialogDesc(Desc);
	teleportDialog.SetUseNeedItem(true);
	teleportDialog.StartNeedItemList(1);
	teleportCost = class'TeleportWnd'.static.Inst().GetTeleportCost(targetTeleport.Price[0].Amount, targetTeleport.UsableLevel, targetTeleport.UsableTransferDegree);
	// End:0x20E
	if(targetTeleport.Price.Length > 0)
	{
		teleportDialog.AddNeedItemClassID(targetTeleport.Price[0].Id, teleportCost);
	}
	teleportDialog.SetItemNum(1);
	teleportDialog.Show();
	teleportDialog.DelegateOnClickBuy = OnTeleportDialogConfirm;
	teleportDialog.DelegateOnCancel = OnTeleportDialogCancel;	
}

private function OnTeleportDialogConfirm()
{
	local UserInfo UserInfo;

	teleportDialog.Hide();
	// End:0x22
	if((GetPlayerInfo(UserInfo)) == false)
	{
		return;
	}
	// End:0x5E
	if(UserInfo.nCurHP == 0)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5243));
		teleportDialog.Hide();
		return;
	}
	class'TeleportListAPI'.static.RequestTeleport(GetCurrentTeleportID());
	GetWindowHandle("QuestTreeWnd").HideWindow();	
}

private function OnTeleportDialogCancel()
{
	teleportDialog.Hide();	
}

private function bool GetCurrentTeleportInfo(out TeleportListAPI.TeleportListData o_tInfo)
{
	local TeleportListAPI.TeleportListData tInfo;
	local int TeleportID;

	TeleportID = GetCurrentTeleportID();
	tInfo = class'TeleportListAPI'.static.GetFirstTeleportListData();

	// End:0x6B [Loop If]
	while("" != tInfo.Name)
	{
		// End:0x53
		if(tInfo.Id == TeleportID)
		{
			o_tInfo = tInfo;
			return true;
		}
		tInfo = class'TeleportListAPI'.static.GetNextTeleportListData();
	}
	return false;	
}

function _SetCurrentQuestInfos(int qID, int nCount, int cState)
{
	local NQuestUIData qUIData;
	local NQuestDialogUIData questDialogUIData;
	local string QuestInfo;

	currentQuestID = qID;
	teleportDialog.Hide();
	isProgress = cState == 1;
	// End:0x40
	if(! API_GetNQuestData(currentQuestID, qUIData))
	{
		return;
	}
	// End:0x5A
	if(qID < class'QuestDialogWnd'.const.QUEST_CATEGORY_MAIN)
	{
		return;
	}
	isComplete = qUIData.Goal.Num <= nCount;
	isEnd = cState == 2;
	if(isEnd)
	{
		txtQuestTitle.SetTextColor(GetColor(100, 83, 49, 255));		
	}
	else
	{
		// End:0x109
		if(isComplete)
		{
			txtQuestTitle.SetTextColor(GetColor(255, 221, 102, 255));			
		}
		else
		{
			txtQuestTitle.SetTextColor(GetColor(170, 153, 119, 255));
		}
	}
	txtQuestTitle.SetText(qUIData.Name);
	// End:0x174
	if(qID < class'QuestDialogWnd'.const.QUEST_CATEGORY_SUB)
	{
		txtQuestCategory.SetText(GetSystemString(2738));		
	}
	else
	{
		// End:0x1A9
		if(currentQuestID < class'QuestDialogWnd'.const.QUEST_CATEGORY_SPECIAL)
		{
			txtQuestCategory.SetText(GetSystemString(2341));			
		}
		else
		{
			txtQuestCategory.SetText(GetSystemString(1796));
		}
	}
	txtRecommandedLevel.SetText(GetSystemString(922) @ ":");
	// End:0x235
	if((qUIData.LevelMax > 0) && qUIData.LevelMin > 0)
	{
		txtRecommandedLevelText.SetText(string(qUIData.LevelMin) $ "~" $ string(qUIData.LevelMax));		
	}
	else
	{
		// End:0x275
		if(qUIData.LevelMin > 0)
		{
			txtRecommandedLevelText.SetText(string(qUIData.LevelMin) $ " " $ GetSystemString(859));			
		}
		else
		{
			txtRecommandedLevelText.SetText(GetSystemString(866));
		}
	}
	switch(qUIData.Type)
	{
		// End:0x2BD
		case NQT_ONETIME:
			txtQuestType.SetText(GetSystemString(862));
			// End:0x326
			break;
		// End:0x2DF
		case NQT_DAILY:
			txtQuestType.SetText(GetSystemString(2788));
			// End:0x326
			break;
		// End:0x301
		case NQT_WEEKLY:
			txtQuestType.SetText(GetSystemString(14389));
			// End:0x326
			break;
		// End:0x323
		case NQT_REPEAT:
			txtQuestType.SetText(GetSystemString(861));
			// End:0x326
			break;
	}
	SetGoalText(qUIData.Goal.Name, nCount, qUIData.Goal.Num);
	API_GetNQuestDialogData(currentQuestID, questDialogUIData);
	QuestInfo = questDialogUIData.QuestInfo;
	ReplaceText(QuestInfo, DIALOG_TOOLTIP_KEY0 $ "S", "");
	ReplaceText(QuestInfo, DIALOG_TOOLTIP_KEY0 $ "E", "");
	txtQuestInfo.LoadHtmlFromString(htmlSetHtmlStart(QuestInfo));
	setRewardItem(qUIData.Reward);
	m_hOwnerWnd.ShowWindow();
	SetButtons();	
}

private function SetGoalText(string Goalname, int Cnt, int goalNum)
{
	local string goalNuMString, goalnameEllipsed;
	local int numW, numH, nameW, nameH;

	// End:0x2B
	if(goalNum > 1)
	{
		goalNuMString = " " $ string(Cnt) $ "/" $ string(goalNum);
	}
	GetTextSizeDefault(Goalname, nameW, nameH);
	GetTextSizeDefault(goalNuMString, numW, numH);
	goalnameEllipsed = Goalname;
	// End:0xA4
	if(class'L2Util'.static.Inst().GetEllipsisString(goalnameEllipsed, 277 - numW))
	{
		txtQuestTarget.SetTooltipString(Goalname);		
	}
	else
	{
		txtQuestTarget.SetTooltipString("");
	}
	txtQuestTarget.SetText(goalnameEllipsed $ goalNuMString);	
}

private function SetButtons()
{
	// End:0x53
	if(currentQuestID < class'QuestDialogWnd'.const.QUEST_CATEGORY_SUB)
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnGiveUpCurrentQuest").DisableWindow();		
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnGiveUpCurrentQuest").EnableWindow();
	}
	// End:0x15D
	if(isComplete)
	{
		// End:0xFD
		if(isProgress)
		{
			GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction").SetButtonName(898);
			GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction").EnableWindow();			
		}
		else
		{
			GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction").SetButtonName(646);
			GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction").EnableWindow();
		}		
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction").SetButtonName(900);
		// End:0x1C9
		if((GetCurrentTeleportID()) < 1)
		{
			GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction").DisableWindow();			
		}
		else
		{
			GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction").EnableWindow();
		}
	}	
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

private function RQ_C_EX_QUEST_CANCEL()
{
	local array<byte> stream;
	local UIPacket._C_EX_QUEST_CANCEL packet;

	packet.nID = currentQuestID;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_QUEST_CANCEL(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_QUEST_CANCEL, stream);	
}

private function bool API_GetNQuestDialogData(int a_QuestID, out NQuestDialogUIData o_data)
{
	return GetNQuestDialogData(a_QuestID, o_data);	
}

private function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);	
}

function int _GetCurrentQuestID()
{
	return currentQuestID;	
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
