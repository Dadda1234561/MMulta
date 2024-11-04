//================================================================================
// RankingWnd_Pet.
//================================================================================

class RankingWnd_Pet extends UICommonAPI;

const TIMER_ID = 1001114;
const REFRESH_DELAY = 600;

var WindowHandle Me;
var WindowHandle DisableWnd;
var TextureHandle RaceMark;
var TextureHandle RankingFlag;
var WindowHandle PetItemWnd;
var TextureHandle PetItemBg;
var ItemWindowHandle PerItem;
var ButtonHandle PerItemButton;
var TextBoxHandle PetNameText;
var TextBoxHandle levelText;
var TextBoxHandle RaceText;
var TextBoxHandle NameText;
var TextBoxHandle ServerRankingText;
var ButtonHandle RankingHelpButton;
var TextureHandle ServerRankingArrow;
var TextBoxHandle ServerRankingEqualityText;
var TextBoxHandle ServerMyRankingText;
var TextureHandle ServerRankingBg;
var TextBoxHandle RaceRankingText;
var TextureHandle RaceRankingArrow;
var TextBoxHandle RaceRankingEqualityText;
var TextBoxHandle RaceMyRankingText;
var TextureHandle RaceRankingBg;
var TextureHandle RankingTrophy;
var TextureHandle RankingPattern;
var TextureHandle RankingBg1;
var WindowHandle RankingTabAllWnd;
var ButtonHandle Top150Button;
var ButtonHandle MyPetRankingButton;
var ButtonHandle refreshButton;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var WindowHandle petComboboxWnd;
var TextBoxHandle petCategoryText;
var ComboBoxHandle petCategoryCombobox;
var TextureHandle ServerRichListFrame;
var RichListCtrlHandle RankingTab_RichList;
var TextureHandle RankingBg2;
var TabHandle TabCtrl2;
var TextureHandle TabLineBg2;
var TextureHandle TabBg2;
var WindowHandle RankingWnd_PetSub;
var TextBoxHandle Inventory_Title_TextBox;
var TextureHandle PetSubIcon_Texture;
var TextureHandle SlotBg1_Texture;
var ItemWindowHandle SubWnd_Item1;
var TextureHandle tabBg;
var string m_WindowName;
var L2UIInventoryObject iObject;
var DetailStatusWnd DetailStatusWndScript;
var int nSelectPetItemSeverID;
var int nRanking;
var UserInfo myInfo;
var int nSelectNpcID;
var int nRankingGroup;
var int nRankingScope;
var RankingScope currentRankingScope;
var RankingGroup currentRankingGroup;
var bool bIAmRanker;
var int myRankingInList;
var bool isFirstInit;
var bool bCurrentSeason;

delegate int OnSortCompare(ItemInfo A, ItemInfo B)
{
	// End:0x22
	if(A.Enchanted < B.Enchanted)
	{
		return -1;		
	}
	else
	{
		return 0;
	}
}

function OnRegisterEvent()
{
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PET_RANKING_MY_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PET_RANKING_LIST);
}

function OnLoad()
{
	Initialize();
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	DisableWnd = GetWindowHandle(m_WindowName $ ".DisableWnd");
	RaceMark = GetTextureHandle(m_WindowName $ ".RaceMark");
	RankingFlag = GetTextureHandle(m_WindowName $ ".RankingFlag");
	PetItemWnd = GetWindowHandle(m_WindowName $ ".PetItemWnd");
	PetItemBg = GetTextureHandle(m_WindowName $ ".PetItemWnd.PetItemBg");
	PerItem = GetItemWindowHandle(m_WindowName $ ".PetItemWnd.PerItem");
	PerItemButton = GetButtonHandle(m_WindowName $ ".PetItemWnd.PerItemButton");
	PetNameText = GetTextBoxHandle(m_WindowName $ ".PetNameText");
	levelText = GetTextBoxHandle(m_WindowName $ ".LevelText");
	RaceText = GetTextBoxHandle(m_WindowName $ ".RaceText");
	NameText = GetTextBoxHandle(m_WindowName $ ".NameText");
	ServerRankingText = GetTextBoxHandle(m_WindowName $ ".ServerRankingText");
	RankingHelpButton = GetButtonHandle(m_WindowName $ ".RankingHelpButton");
	ServerRankingArrow = GetTextureHandle(m_WindowName $ ".ServerRankingArrow");
	ServerRankingEqualityText = GetTextBoxHandle(m_WindowName $ ".ServerRankingEqualityText");
	ServerMyRankingText = GetTextBoxHandle(m_WindowName $ ".ServerMyRankingText");
	ServerRankingBg = GetTextureHandle(m_WindowName $ ".ServerRankingBg");
	RaceRankingText = GetTextBoxHandle(m_WindowName $ ".RaceRankingText");
	RaceRankingArrow = GetTextureHandle(m_WindowName $ ".RaceRankingArrow");
	RaceRankingEqualityText = GetTextBoxHandle(m_WindowName $ ".RaceRankingEqualityText");
	RaceMyRankingText = GetTextBoxHandle(m_WindowName $ ".RaceMyRankingText");
	RaceRankingBg = GetTextureHandle(m_WindowName $ ".RaceRankingBg");
	RankingTrophy = GetTextureHandle(m_WindowName $ ".RankingTrophy");
	RankingPattern = GetTextureHandle(m_WindowName $ ".RankingPattern");
	RankingBg1 = GetTextureHandle(m_WindowName $ ".RankingBg1");
	RankingTabAllWnd = GetWindowHandle(m_WindowName $ ".RankingTabAllWnd");
	Top150Button = GetButtonHandle(m_WindowName $ ".RankingTabAllWnd.Top150Button");
	petComboboxWnd = GetWindowHandle(m_WindowName $ ".RankingTabAllWnd.petComboboxWnd");
	petCategoryText = GetTextBoxHandle(m_WindowName $ ".RankingTabAllWnd.petComboboxWnd.petCategoryText");
	petCategoryCombobox = GetComboBoxHandle(m_WindowName $ ".RankingTabAllWnd.petComboboxWnd.petCombobox");
	MyPetRankingButton = GetButtonHandle(m_WindowName $ ".RankingTabAllWnd.MyPetRankingButton");
	refreshButton = GetButtonHandle(m_WindowName $ ".RankingTabAllWnd.RefreshButton");
	DisableWndList = GetWindowHandle(m_WindowName $ ".RankingTabAllWnd.DisableWndList");
	List_Empty = GetTextBoxHandle(m_WindowName $ ".RankingTabAllWnd.DisableWndList.List_Empty");
	ServerRichListFrame = GetTextureHandle(m_WindowName $ ".RankingTabAllWnd.ServerRichListFrame");
	RankingTab_RichList = GetRichListCtrlHandle(m_WindowName $ ".RankingTabAllWnd.RankingTab_RichList");
	RankingBg2 = GetTextureHandle(m_WindowName $ ".RankingTabAllWnd.RankingBg2");
	TabCtrl2 = GetTabHandle(m_WindowName $ ".RankingTabAllWnd.TabCtrl2");
	TabLineBg2 = GetTextureHandle(m_WindowName $ ".RankingTabAllWnd.TabLineBg2");
	TabBg2 = GetTextureHandle(m_WindowName $ ".RankingTabAllWnd.TabBg2");
	RankingWnd_PetSub = GetWindowHandle(m_WindowName $ ".RankingWnd_PetSub");
	Inventory_Title_TextBox = GetTextBoxHandle(m_WindowName $ ".RankingWnd_PetSub.Inventory_Title_TextBox");
	PetSubIcon_Texture = GetTextureHandle(m_WindowName $ ".RankingWnd_PetSub.PetSubIcon_Texture");
	SlotBg1_Texture = GetTextureHandle(m_WindowName $ ".RankingWnd_PetSub.SlotBg1_Texture");
	SubWnd_Item1 = GetItemWindowHandle(m_WindowName $ ".RankingWnd_PetSub.SubWnd_Item1");
	tabBg = GetTextureHandle(m_WindowName $ ".RankingWnd_PetSub.tabbg");
	SetCusomTooltipAtHelpBtn();
	RankingTab_RichList.SetSelectedSelTooltip(false);
	RankingTab_RichList.SetAppearTooltipAtMouseX(true);
	RankingTab_RichList.SetUseStripeBackTexture(false);
	RankingTab_RichList.SetTooltipType("RankingPet");
}

function OnShow()
{
	// End:0x25
	if(GetWindowHandle("RankingWnd").IsShowWindow())
	{
		OnRefreshButtonClick();
	}
}

function OnHide()
{
	ShowRankingWnd_PetSub(false);
}

function initUI()
{
	nSelectPetItemSeverID = 0;
	ShowRankingWnd_PetSub(false);
	PerItemButton.SetTexture("L2UI_EPIC.RankingWnd_PetButton", "L2UI_EPIC.RankingWnd_PetButton_Down", "L2UI_EPIC.RankingWnd_PetButton_Over");
	SetCusomTooltipAtPetButton();
	setTabState("TabCtrl20");
	setLikeRadioButton("Top150Button");	
}

function initComboBox_PetID()
{
	local bool bSelect;
	local int i, selectIndex;
	local array<L2PetRaceEmblemUIData> petInfoArray;

	class'PetAPI'.static.GetPetRaceEmblemDataAll(petInfoArray);
	petCategoryCombobox.Clear();

	// End:0x73 [Loop If]
	for(i = 0; i < petInfoArray.Length; i++)
	{
		petCategoryCombobox.AddStringWithReserved(petInfoArray[i].RaceName, petInfoArray[i].PetID);
	}
	// End:0x92
	if(bSelect == false)
	{
		petCategoryCombobox.SetSelectedNum(0);		
	}
	else
	{
		petCategoryCombobox.SetSelectedNum(selectIndex);
	}
}

function SetCusomTooltipAtPetButton()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13413), GTColor().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13513), GTColor().ColorDesc, "", true, false);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	PerItemButton.SetTooltipCustomType(mCustomTooltip);
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x22
		case "PerItemButton":
			OnPerItemButtonClick();
			// End:0xDC
			break;
		// End:0x47
		case "Top150Button":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			// End:0xDC
			break;
		// End:0x72
		case "MyPetRankingButton":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			// End:0xDC
			break;
		// End:0x8D
		case "RefreshButton":
			OnRefreshButtonClick();
			// End:0xDC
			break;
		// End:0x9B
		case "TabCtrl20":
		// End:0xA9
		case "TabCtrl21":
		// End:0xB7
		case "TabCtrl22":
		// End:0xD9
		case "TabCtrl23":
			setTabState(Name);
			OnRefreshButtonClick();
			// End:0xDC
			break;
	}
}

function OnPerItemButtonClick()
{
	ShowRankingWnd_PetSub(! RankingWnd_PetSub.IsShowWindow());
}

function OnRefreshButtonClick()
{
	ShowRankingWnd_PetSub(false);
	syncPetItemInven();
	API_C_EX_PET_RANKING_MY_INFO(nSelectPetItemSeverID);
	API_C_EX_PET_RANKING_LIST(nSelectPetItemSeverID, petCategoryCombobox.GetReserved(petCategoryCombobox.GetSelectedNum()));
	checkVisibleCombo();
	setMyInfo();
	setDisableWnd();
}

function OnClickItem(string strID, int Index)
{
	local ItemInfo SelectItemInfo;

	// End:0x5E
	if(strID == "SubWnd_Item1")
	{
		SubWnd_Item1.GetItem(Index, SelectItemInfo);
		// End:0x51
		if(SelectItemInfo.Id.ClassID > 0)
		{
			setSelectPetItem(SelectItemInfo);
		}
		ShowRankingWnd_PetSub(false);
		OnRefreshButtonClick();
	}
}

function setSelectPetItem(ItemInfo SelectItemInfo)
{
	local PetNameInfo PetNameInfo;
	local string petNameStr;
	local L2PetRaceEmblemUIData PetEmblemData;

	// End:0x5B
	if(SelectItemInfo.Name == "")
	{
		RaceText.SetText(GetSystemString(27));
		PetNameText.SetText(GetSystemString(971));
		PerItem.Clear();
		nSelectPetItemSeverID = 0;		
	}
	else
	{
		class'PetAPI'.static.GetPetEvolveNameInfo(SelectItemInfo.PetNameID, PetNameInfo);
		petNameStr = PetNameInfo.Name;
		class'PetAPI'.static.GetPetEvolveNameInfo(SelectItemInfo.PetNamePrefixID, PetNameInfo);
		petNameStr = PetNameInfo.Name @ petNameStr;
		class'PetAPI'.static.GetPetRaceEmblemData(SelectItemInfo.PetID, PetEmblemData);
		RaceText.SetText("Lv" $ string(SelectItemInfo.Enchanted) @ PetEmblemData.RaceName);
		// End:0x138
		if(trim(petNameStr) == "")
		{
			PetNameText.SetText(GetSystemString(971));			
		}
		else
		{
			PetNameText.SetText(petNameStr);
		}
		PerItem.Clear();
		// End:0x184
		if(SelectItemInfo.Id.ClassID > 0)
		{
			PerItem.AddItem(SelectItemInfo);
		}
		nSelectPetItemSeverID = SelectItemInfo.Id.ServerID;
	}
}

function OnRClickButton(string Name)
{
	switch(Name)
	{
		// End:0x15
		case "TabCtrl20":
		// End:0x23
		case "TabCtrl21":
		// End:0x31
		case "TabCtrl22":
		// End:0x53
		case "TabCtrl23":
			setTabState(Name);
			OnRefreshButtonClick();
			// End:0x56
			break;
	}
}

function checkVisibleCombo()
{
	// End:0x44
	if(currentRankingGroup == 1)
	{
		// End:0x32
		if(currentRankingScope == 0)
		{
			petComboboxWnd.ShowWindow();			
		}
		else
		{
			petComboboxWnd.HideWindow();
		}		
	}
	else
	{
		petComboboxWnd.HideWindow();
	}
}

function setTabState(string tabName)
{
	switch(tabName)
	{
		// End:0x51
		case "TabCtrl20":
			SettingButton(Top150Button, true, 13016);
			SettingButton(MyPetRankingButton, true, 3975);
			petComboboxWnd.HideWindow();
			currentRankingGroup = ServerGroup;
			// End:0x10F
			break;
		// End:0x8C
		case "TabCtrl21":
			SettingButton(Top150Button, true,3972);
			SettingButton(MyPetRankingButton, true,3975);
			currentRankingGroup = RaceGroup;
			// End:0x10F
			break;
		// End:0xCC
		case "TabCtrl22":
			SettingButton(Top150Button, false);
			SettingButton(MyPetRankingButton, false);
			petComboboxWnd.HideWindow();
			currentRankingGroup = Pledge;
			// End:0x10F
			break;
		// End:0x10C
		case "TabCtrl23":
			SettingButton(Top150Button, false);
			SettingButton(MyPetRankingButton, false);
			petComboboxWnd.HideWindow();
			currentRankingGroup = Friends;
			// End:0x10F
			break;
	}
}

function setLikeRadioButton(string buttonName)
{
	// End:0x126
	if(buttonName == "Top150Button")
	{
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		MyPetRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = TopN;
	}
	else
	{
		// End:0x24F
		if(buttonName == "MyPetRankingButton")
		{
			MyPetRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
			Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
			currentRankingScope = AroundMe;
		}
	}
}

function SettingButton(ButtonHandle btn, bool bShow, optional int nSystemString)
{
	// End:0x35
	if(bShow)
	{
		btn.ShowWindow();
		btn.SetNameText(GetSystemString(nSystemString));
	}
	else
	{
		btn.HideWindow();
	}
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x18
		case EV_GameStart:
			initUI();
			// End:0x6F
			break;
		// End:0x2F
		case EV_Restart:
			isFirstInit = false;
			nSelectPetItemSeverID = 0;
			// End:0x6F
			break;
		// End:0x4C
		case EV_PacketID(class'UIPacket'.const.S_EX_PET_RANKING_MY_INFO):
			ParsePacket_S_EX_PET_RANKING_MY_INFO();
		// End:0x6C
		case EV_PacketID(class'UIPacket'.const.S_EX_PET_RANKING_LIST):
			ParsePacket_S_EX_PET_RANKING_LIST();
			// End:0x6F
			break;
	}
}

function ParsePacket_S_EX_PET_RANKING_MY_INFO()
{
	local UIPacket._S_EX_PET_RANKING_MY_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PET_RANKING_MY_INFO(packet))
	{
		return;
	}
	// End:0x36
	if(nSelectPetItemSeverID <= 0)
	{
		nSelectPetItemSeverID = packet.nCollarID;
	}
	// End:0x5B
	if(packet.nPrevRank == 0)
	{
		packet.nPrevRank = packet.nRank;
	}
	// End:0x80
	if(packet.nPrevRaceRank == 0)
	{
		packet.nPrevRaceRank = packet.nRaceRank;
	}
	// End:0x13A
	if((packet.nPrevRank - packet.nRank) > 0)
	{
		ServerRankingArrow.ShowWindow();
		ServerRankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowUp");
		ServerRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nPrevRank - packet.nRank)));
		ServerRankingEqualityText.SetTextColor(GetColor(230, 101, 101, 255));		
	}
	else if(packet.nPrevRank - packet.nRank < 0)
	{
		ServerRankingArrow.ShowWindow();
		ServerRankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowDown");
		ServerRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nPrevRank - packet.nRank)));
		ServerRankingEqualityText.SetTextColor(GetColor(0, 170, 255, 255));			
	}
	else
	{
		ServerRankingEqualityText.SetText("-");
		ServerRankingEqualityText.SetTextColor(GetColor(153, 153, 153, 255));
		ServerRankingArrow.HideWindow();
	}
	// End:0x3B0
	if((packet.nPrevRaceRank - packet.nRaceRank) > 0)
	{
		RaceRankingArrow.ShowWindow();
		RaceRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowUp");
		RaceRankingEqualityText.SetTextColor(GetColor(230, 101, 101, 255));
		RaceRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nPrevRaceRank - packet.nRaceRank)));		
	}
	else if(packet.nPrevRaceRank - packet.nRaceRank < 0)
	{
		RaceRankingArrow.ShowWindow();
		RaceRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowDown");
		RaceRankingEqualityText.SetTextColor(GetColor(0, 170, 255, 255));
		RaceRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nPrevRaceRank - packet.nRaceRank)));			
	}
	else
	{
		RaceRankingArrow.HideWindow();
		RaceRankingEqualityText.SetTextColor(GetColor(153, 153, 153, 255));
		RaceRankingEqualityText.SetText("-");
	}
	// End:0x4E1
	if(packet.nRank == 0)
	{
		ServerMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));		
	}
	else
	{
		ServerMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRank)));
	}
	// End:0x545
	if(packet.nRaceRank == 0)
	{
		RaceMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));		
	}
	else
	{
		RaceMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRaceRank)));
	}
}

function bool isSameEventWithCurrentState(int nRankingGroup, int nRankingScope, int nCurrentRankingGroup, int nCurrentRankingScope)
{
	switch(nRankingGroup)
	{
		// End:0x0E
		case 0:
		// End:0x3A
		case 1:
			// End:0x37
			if((nRankingGroup == nCurrentRankingGroup) && nRankingScope == nCurrentRankingScope)
			{
				return true;
			}
			// End:0x5F
			break;
		// End:0x41
		case 2:
		// End:0x5C
		case 3:
			// End:0x59
			if(nRankingGroup == nCurrentRankingGroup)
			{
				return true;
			}
			// End:0x5F
			break;
	}
	return false;
}

function ParsePacket_S_EX_PET_RANKING_LIST()
{
	local UIPacket._S_EX_PET_RANKING_LIST packet;
	local int i, nChangeRank, nRankingGroupTm, nRankingScopeTm;
	local ItemInfo currentPetInfo;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PET_RANKING_LIST(packet))
	{
		return;
	}
	nRankingGroupTm = packet.cRankingGroup;
	nRankingScopeTm = packet.cRankingScope;
	// End:0x9A
	if(isSameEventWithCurrentState(currentRankingGroup, currentRankingScope, packet.cRankingGroup, packet.cRankingScope))
	{
		RankingTab_RichList.DeleteAllItem();
		bIAmRanker = false;
		myRankingInList = 0;
		nRankingGroup = nRankingGroupTm;
		nRankingScope = nRankingScopeTm;
	}
	uDebug(" -->  Decode_S_EX_PET_RANKING_LIST :  " @ string(packet.cRankingGroup) @ string(packet.cRankingScope) @ string(packet.nIndex) @ string(packet.nCollarID));
	uDebug("packet.rankerInfoList.length : " @ string(packet.rankerInfoList.Length));
	// End:0x160
	if(PerItem.GetItemNum() > 0)
	{
		PerItem.GetItem(0, currentPetInfo);
	}

	// End:0x36F
	for(i = 0; i < packet.rankerInfoList.Length; i++)
	{
		// End:0x1F4
		if(1 == nRankingGroup || 0 == nRankingGroup)
		{
			// End:0x1BF
			if(packet.rankerInfoList[i].nPrevRank == 0)
			{
				nChangeRank = 0;				
			}
			else
			{
				nChangeRank = packet.rankerInfoList[i].nPrevRank - packet.rankerInfoList[i].nRank;
			}			
		}
		else
		{
			nChangeRank = 0;
		}
		// End:0x288
		if(packet.rankerInfoList[i].sUserName == myInfo.Name && currentPetInfo.Enchanted == packet.rankerInfoList[i].nPetLevel && currentPetInfo.PetID == packet.rankerInfoList[i].nPetIndex)
		{
			bIAmRanker = true;
			myRankingInList = RankingTab_RichList.GetRecordCount();
		}
		AddRankingSystemListItem(packet.rankerInfoList[i].nRank, nChangeRank, packet.rankerInfoList[i].nPrevRank, packet.rankerInfoList[i].sUserName, packet.rankerInfoList[i].sNickName, packet.rankerInfoList[i].nUserRace, packet.rankerInfoList[i].nUserLevel, packet.rankerInfoList[i].sPledgeName, packet.rankerInfoList[i].nNPCClassID, packet.rankerInfoList[i].nPetIndex, packet.rankerInfoList[i].nPetLevel);
	}
	rankingListEndHandler();
}

function AddRankingSystemListItem(int nRanking, int nChangeRank, int nPrevRank, string PlayerName, string sNickName, int nRace, int nLevel, string PledgeName, int nNPCClassID, int nPetIndex, int nPetLevel)
{
	local RichListCtrlRowData RowData;
	local string texStr, levelStr, nameStr;
	local Color applyColor;
	local int nH, nW, nAddY, nAddX, prefixID;

	local bool bisAllReward;
	local L2PetRaceEmblemUIData PetEmblemData;
	local array<string> nickNameArray;
	local PetNameInfo NameInfo;

	RowData.cellDataList.Length = 5;
	bisAllReward = true;
	class'PetAPI'.static.GetPetRaceEmblemData(nPetIndex, PetEmblemData);
	// End:0x15C
	if(nRanking <= 3 && nRanking > 0)
	{
		// End:0x80
		if(nRanking == 1)
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_1st";			
		}
		else if(nRanking == 2)
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_2nd";
		}
		else if(nRanking == 3)
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_3rd";
		}

		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, texStr, 38, 33, 10, 5);
		// End:0x134
		if(bisAllReward)
		{
			applyColor = GTColor().Frangipani;			
		}
		else
		{
			applyColor = GTColor().Charcoal;
		}
		nAddY = 12;
		nAddX = 6;		
	}
	else
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, string(nRanking), GTColor().Tallow, false, 20, 10);
		// End:0x1AF
		if(bisAllReward)
		{
			applyColor = GTColor().WhiteSmoke;			
		}
		else
		{
			applyColor = GTColor().Charcoal;
		}
		nAddY = 4;
		nAddX = 10;
	}
	// End:0x285
	if(nRankingGroup == 0 && nRankingScope == 0 && nPrevRank > 150 || nPrevRank == 0 || nRankingGroup == 1 && nRankingScope == 0 && nPrevRank > 100 || nPrevRank == 0)
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, "NEW", GTColor().Lime, false, nAddX, nAddY - 4);		
	}
	else if(nChangeRank > 0)
	{
		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowUp", 8, 8, 6, nAddY);
		addRichListCtrlString(RowData.cellDataList[0].drawitems, string(nChangeRank), GTColor().Froly, false, 2, -4);			
	}
	else if(nChangeRank == 0)
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, "-", GetColor(153, 153, 153, 255), false, nAddX, nAddY - 4);				
	}
	else
	{
		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowDown", 8, 8, 6, nAddY);
		addRichListCtrlString(RowData.cellDataList[0].drawitems, string(nChangeRank), GTColor().DeepSkyBlue, false, 2, -4);
	}
	levelStr = ("(Lv." $ string(nPetLevel)) $ ")";
	// End:0x422
	if(sNickName == "")
	{
		sNickName = class'UIDATA_NPC'.static.GetNPCName(nNPCClassID - 1000000);		
	}
	else
	{
		Split(sNickName, ";", nickNameArray);
		prefixID = class'PetAPI'.static.GetPetNameIDBySkill(int(nickNameArray[0]), int(nickNameArray[1]));
		class'PetAPI'.static.GetPetEvolveNameInfo(prefixID, NameInfo);
		nameStr = NameInfo.Name;
		class'PetAPI'.static.GetPetEvolveNameInfo(int(nickNameArray[2]), NameInfo);
		sNickName = nameStr @ NameInfo.Name;
	}
	RowData.cellDataList[0].szData = sNickName;
	RowData.cellDataList[1].szData = "Lv." $ string(nPetLevel);
	RowData.cellDataList[2].szData = PetEmblemData.RaceName;
	GetTextSizeDefault(sNickName, nW, nH);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, sNickName, applyColor, false, 4, -2);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, levelStr, applyColor, false, - nW, 15);
	addRichListCtrlTexture(RowData.cellDataList[2].drawitems, PetEmblemData.EmblemTexName, 32, 32, 28, 0);
	levelStr = "(Lv." $ string(nLevel) $ ")";
	GetTextSizeDefault(PlayerName, nW, nH);
	addRichListCtrlString(RowData.cellDataList[3].drawitems, PlayerName, applyColor, false, 4, -2);
	addRichListCtrlString(RowData.cellDataList[3].drawitems, levelStr, applyColor, false, - nW, 15);
	// End:0x646
	if(bisAllReward)
	{
		applyColor = GTColor().Silver;		
	}
	else
	{
		applyColor = GTColor().Charcoal;
	}
	// End:0x6A7
	if(nRanking <= 3 && nRanking > 0)
	{
		// End:0x68F
		if(bisAllReward)
		{
			GTColor().Frangipani;			
		}
		else
		{
			applyColor = GTColor().Charcoal;
		}		
	}
	else
	{
		// End:0x6C8
		if(bisAllReward)
		{
			applyColor = GTColor().Silver;			
		}
		else
		{
			applyColor = GTColor().Charcoal;
		}
	}
	// End:0x6FA
	if(PledgeName == "")
	{
		PledgeName = GetSystemString(431);
	}
	addRichListCtrlString(RowData.cellDataList[4].drawitems, PledgeName, applyColor, false, 5, 0);
	// End:0x7B2
	if(bisAllReward)
	{
		// End:0x774
		if(myInfo.Name == PlayerName)
		{
			RowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";			
		}
		else
		{
			RowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
		}
		RowData.OverlayTexU = 734;
		RowData.OverlayTexV = 45;		
	}
	else
	{
		// End:0x804
		if(myInfo.Name == PlayerName)
		{
			RowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyDisableRankBg";			
		}
		else
		{
			RowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_DisableRankBg";
		}
		RowData.OverlayTexU = 734;
		RowData.OverlayTexV = 45;
	}
	RankingTab_RichList.InsertRecord(RowData);
}

function rankingListEndHandler()
{
	local int nStartRow;

	// End:0x77
	if(RankingTab_RichList.GetRecordCount() > 0)
	{
		DisableWndList.HideWindow();
		// End:0x74
		if(bIAmRanker)
		{
			nStartRow = myRankingInList - 3;
			// End:0x74
			if(nStartRow > 0)
			{
				// End:0x74
				if(RankingTab_RichList.GetRecordCount() > nStartRow)
				{
					RankingTab_RichList.SetStartRow(nStartRow);
				}
			}
		}		
	}
	else
	{
		DisableWndList.ShowWindow();
		switch(currentRankingGroup)
		{
			// End:0xAF
			case ServerGroup:
				List_Empty.SetText(GetSystemString(13023));
				// End:0x118
				break;
			// End:0xD1
			case RaceGroup:
				List_Empty.SetText(GetSystemString(13023));
				// End:0x118
				break;
			// End:0xF3
			case Pledge:
				List_Empty.SetText(GetSystemString(13023));
				// End:0x118
				break;
			// End:0x115
			case Friends:
				List_Empty.SetText(GetSystemString(13023));
				// End:0x118
				break;
			// End:0xFFFF
			default:
				break;
		}
	}
	RankingTab_RichList.SetFocus();
}

function int syncPetItemInven()
{
	local int i;
	local int nSelect;
	local int nWindowWidth;
	local array<ItemInfo> itemarray;
	local array<ItemInfo> pickPetArray;
	local ItemInfo emptyItemInfo;

	GetObjectFindItemByCompare().DelegateCompare = petItemCompare;
	itemarray = GetObjectFindItemByCompare().GetAllItemByCompare();
	SubWnd_Item1.Clear();
	nSelect = -1;

	// End:0x93 [Loop If]
	for (i = 0; i < itemarray.Length; i++)
	{
		if(itemarray[i].Enchanted > 39)
		{
			InsertCheckInPetArray(itemarray[i], pickPetArray);
		}
	}

	pickPetArray.Sort(OnSortCompare);

	// End:0x128 [Loop If]
	for (i = 0; i < pickPetArray.Length; i++)
	{
		SubWnd_Item1.AddItem(pickPetArray[i]);
		// End:0x11E
		if(pickPetArray[i].Id.ServerID == nSelectPetItemSeverID)
		{
			nSelect = i;
			SubWnd_Item1.SetSelectedNum(i);
			setSelectPetItem(pickPetArray[i]);
		}
	}

	// End:0x159
	if(pickPetArray.Length > 0)
	{
		SubWnd_Item1.SetRow(1);
		SubWnd_Item1.SetCol(pickPetArray.Length);
	}
	// End:0x1B2
	if(pickPetArray.Length > 0)
	{
		SubWnd_Item1.SetWindowSize(34 + 4 * pickPetArray.Length, 34);
		nWindowWidth = (34 + 4 * pickPetArray.Length) + 10;
		RankingWnd_PetSub.SetWindowSize(nWindowWidth, 51);
	}
	// End:0x1F8
	if(nSelect == -1)
	{
		// End:0x1ED
		if(pickPetArray.Length > 0)
		{
			SubWnd_Item1.SetSelectedNum(0);
			setSelectPetItem(pickPetArray[0]);
		}
		else
		{
			setSelectPetItem(emptyItemInfo);
		}
	}
	return pickPetArray.Length;
}

function InsertCheckInPetArray(ItemInfo petItemInfo, out array<ItemInfo> pickPetArray)
{
	local int i;
	local bool bSameItem;

	// End:0x7A [Loop If]
	for(i = 0; i < pickPetArray.Length; i++)
	{
		// End:0x70
		if(petItemInfo.PetID == pickPetArray[i].PetID)
		{
			bSameItem = true;
			// End:0x70
			if(petItemInfo.Enchanted > pickPetArray[i].Enchanted)
			{
				pickPetArray[i] = petItemInfo;
				return;
			}
		}
	}
	// End:0x9A
	if(bSameItem == false)
	{
		pickPetArray[pickPetArray.Length] = petItemInfo;
		return;
	}
}

function bool petItemCompare(ItemInfo item)
{
	// End:0x2B
	if(EEtcItemType(item.EtcItemType) == ITEME_PET_COLLAR && item.PetID > 0)
	{
		return true;
	}
	return false;
}

function ShowRankingWnd_PetSub(bool bShow)
{
	local int petCount;

	// End:0x107
	if(bShow)
	{
		petCount = syncPetItemInven();
		// End:0x3D
		if(petCount <= 0)
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemString(13512));
			return;
		}
		RankingWnd_PetSub.ShowWindow();
		RankingWnd_PetSub.SetFocus();
		PerItemButton.SetTexture("L2UI_EPIC.RankingWnd.RankingWnd_PetClickButton", "L2UI_EPIC.RankingWnd.RankingWnd_PetClickButton_Down", "L2UI_EPIC.RankingWnd.RankingWnd_PetClickButton_Over");		
	}
	else
	{
		RankingWnd_PetSub.HideWindow();
		PerItemButton.SetTexture("L2UI_EPIC.RankingWnd_PetButton", "L2UI_EPIC.RankingWnd_PetButton_Down", "L2UI_EPIC.RankingWnd_PetButton_Over");
	}
	SetCusomTooltipAtPetButton();
}

function SetCusomTooltipAtHelpBtn()
{
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(13428), getInstanceL2Util().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(13429), getInstanceL2Util().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(13430), getInstanceL2Util().White, "", true, true);
	RankingHelpButton.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function setMyInfo()
{
	GetPlayerInfo(myInfo);
	NameText.SetText(myInfo.Name);
	uDebug("myInfo.Name" @ myInfo.Name);
	// End:0x44
	if(isFirstInit == false)
	{
		isFirstInit = true;
		syncPetItemInven();
		initComboBox_PetID();
	}
}

function OnComboBoxItemSelected(string strID, int Index)
{
	OnRefreshButtonClick();
}

function OnTimer(int TimeID)
{
	// End:0x15
	if(TimeID == TIMER_ID)
	{
		hideDisableWnd();
	}
}

function setDisableWnd()
{
	DisableWnd.ShowWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(true);
	Me.SetTimer(TIMER_ID, REFRESH_DELAY);
}

function hideDisableWnd()
{
	DisableWnd.HideWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(false);
	Me.KillTimer(TIMER_ID);
}

function API_C_EX_PET_RANKING_MY_INFO(int nPetServerID)
{
	local array<byte> stream;
	local UIPacket._C_EX_PET_RANKING_MY_INFO packet;

	packet.nCollarID = nPetServerID;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_PET_RANKING_MY_INFO(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PET_RANKING_MY_INFO, stream);
	uDebug("----> Api Call : C_EX_PET_RANKING_MY_INFO" @ string(nPetServerID));
}

function API_C_EX_PET_RANKING_LIST(int nPetServerID, int nIndex)
{
	local array<byte> stream;
	local UIPacket._C_EX_PET_RANKING_LIST packet;

	packet.cRankingGroup = currentRankingGroup;
	packet.cRankingScope = currentRankingScope;
	packet.nIndex = nIndex;
	packet.nCollarID = nPetServerID;
	// End:0x64
	if(! class'UIPacket'.static.Encode_C_EX_PET_RANKING_LIST(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PET_RANKING_LIST, stream);
	uDebug("----> Api Call : C_EX_PET_RANKING_LIST" @ string(currentRankingGroup) @ string(currentRankingScope) @ string(nIndex) @ string(nPetServerID));
}

defaultproperties
{
}
