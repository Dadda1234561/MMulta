class BlackCouponWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle ResultDialog_Wnd;
var ItemWindowHandle Result_ItemWnd;
var TextBoxHandle ItemName_Txt;
var TextBoxHandle Discription_Txt;
var ButtonHandle Ok_Btn;
var EffectViewportWndHandle EffectViewport02;
var WindowHandle ItemRecovery_Wnd;
var WindowHandle List_Wnd;
var WindowHandle Exchange_Wnd;
var WindowHandle ListDisable_Wnd;
var RichListCtrlHandle ExchangeItem_RichList;
var RichListCtrlHandle RecoveryRichList;
var WindowHandle Bottom_Wnd;
var TextBoxHandle Title_Txt;
var ButtonHandle Recovery_Btn;
var ButtonHandle Exchange_Btn;
var int nCurrentBrokenItemClassId;
var int nCurrentBrokenEnchantNum;
var int nCurrentFixedItemClassId;
var int currentRecoverTabNum;
var array<MultiSellInfo> m_MultiSellInfoList;
var int m_MultiSellGroupID;
var int m_nCurrentMultiSellInfoIndex;
var string m_WindowName;
var int nShowType;
var array<int> lastSelectedListArray;
var UIControlGroupButtonAssets TopGroupButtonAsset;
var UIControlGroupButtonAssets SubGroupButtonAsset;
var UIControlNeedItemList needItemScript;
var RecoveryCouponData CouponData;
var int currentCouponClassID;

function updateNeedItem()
{

}

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_ITEM_RESTORE_LIST);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_ITEM_RESTORE);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_ITEM_RESTORE_OPEN);
	RegisterEvent(EV_MultiSellInfoListBegin);
	RegisterEvent(EV_MultiSellResultItemInfo);
	RegisterEvent(EV_MultiSellOutputItemInfo);
	RegisterEvent(EV_MultiSellInputItemInfo);
	RegisterEvent(EV_MultiSellInfoListEnd);
	RegisterEvent(EV_MultiSellResult);
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_AdenaInvenCount);
}

function Initialize()
{
	Me = GetWindowHandle(m_WindowName);
	ResultDialog_Wnd = GetWindowHandle(m_WindowName $ ".ResultDialog_Wnd");
	Result_ItemWnd = GetItemWindowHandle(m_WindowName $ ".ResultDialog_Wnd.Result_ItemWnd");
	ItemName_Txt = GetTextBoxHandle(m_WindowName $ ".ResultDialog_Wnd.ItemName_Txt");
	Discription_Txt = GetTextBoxHandle(m_WindowName $ ".ResultDialog_Wnd.Discription_Txt");
	Ok_Btn = GetButtonHandle(m_WindowName $ ".ResultDialog_Wnd.Ok_Btn");
	EffectViewport02 = GetEffectViewportWndHandle(m_WindowName $ ".ResultDialog_Wnd.EffectViewport02");
	ItemRecovery_Wnd = GetWindowHandle(m_WindowName $ ".ItemRecovery_Wnd");
	List_Wnd = GetWindowHandle(m_WindowName $ ".ItemRecovery_Wnd.List_Wnd");
	ListDisable_Wnd = GetWindowHandle(m_WindowName $ ".ItemRecovery_Wnd.ListDisable_Wnd");
	RecoveryRichList = GetRichListCtrlHandle(m_WindowName $ ".List_Wnd.Item_RichList");
	Exchange_Wnd = GetWindowHandle(m_WindowName $ ".Exchange_Wnd");
	ExchangeItem_RichList = GetRichListCtrlHandle(m_WindowName $ ".ExchangeList_Wnd.ExchangeRichList");
	Bottom_Wnd = GetWindowHandle(m_WindowName $ ".Bottom_Wnd");
	Title_Txt = GetTextBoxHandle(m_WindowName $ ".Bottom_Wnd.Title_Txt");
	Recovery_Btn = GetButtonHandle(m_WindowName $ ".Bottom_Wnd.Recovery_Btn");
	Exchange_Btn = GetButtonHandle(m_WindowName $ ".Bottom_Wnd.Exchange_Btn");	
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	initGroupButton();
	InitNeedItem();
	SetPopupScript();
	GetRichListCtrlHandle(m_WindowName $ ".List_Wnd.Item_RichList").SetSelectedSelTooltip(false);
	GetRichListCtrlHandle(m_WindowName $ ".List_Wnd.Item_RichList").SetAppearTooltipAtMouseX(true);
	ExchangeItem_RichList.SetSelectedSelTooltip(false);
	ExchangeItem_RichList.SetAppearTooltipAtMouseX(true);
}

function initGroupButton()
{
	TopGroupButtonAsset = class'UIControlGroupButtonAssets'.static._InitScript(GetMeWindow("TopGroupButtonAsset"));
	TopGroupButtonAsset._SetStartInfo("L2UI_NewTex.tab.BigBrown_Tab_One_Unselected", "L2UI_NewTex.tab.BigBrown_Tab_One_Selected", "L2UI_NewTex.tab.BigBrown_Tab_One_Unselected_Over", true);
	TopGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButtonTopTab;
	SubGroupButtonAsset = class'UIControlGroupButtonAssets'.static._InitScript(GetMeWindow("ItemRecovery_Wnd.SubGroupButtonAsset"));
	SubGroupButtonAsset._SetStartInfo("L2UI_ct1.RankingWnd.RankingWnd_SubTabButton", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Down", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Over", true);
	SubGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButtonSubTab;	
}

function setTopGroupButtonCategory()
{
	local int tabNum;

	// End:0x44
	if(SubGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum() > 0)
	{
		// End:0x3A
		if(CouponData.DefaultMultisellId > 0)
		{
			tabNum = 2;			
		}
		else
		{
			tabNum = 1;
		}		
	}
	else
	{
		tabNum = 1;
	}
	// End:0xDA
	if(tabNum == 2)
	{
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(13668));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(0, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(13669));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(1, 1);		
	}
	else
	{
		// End:0x112
		if(CouponData.DefaultMultisellId > 0)
		{
			TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(14231));			
		}
		else
		{
			TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(13668));
		}
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(0, 0);
	}
	TopGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(tabNum);
	// End:0x255
	if(TopGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum() == 1)
	{
		TopGroupButtonAsset._GetGroupButtonsInstance()._fixedWidth(598, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_NewTex.tab.BigBrown_Tab_One_Unselected", "L2UI_NewTex.tab.BigBrown_Tab_One_Selected", "L2UI_NewTex.tab.BigBrown_Tab_One_Unselected_Over");		
	}
	else
	{
		TopGroupButtonAsset._GetGroupButtonsInstance()._fixedWidth(299, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected_Over");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(1, "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Unselected_Over");
	}
	TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0);	
}

function setSubGroupButtonCategory()
{
	local int i;

	// End:0x92 [Loop If]
	for(i = 0; i < CouponData.Categories.Length; i++)
	{
		SubGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(i, GetSystemString(CouponData.Categories[i].SysStringId));
		SubGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(i, CouponData.Categories[i].Category);
	}
	// End:0xBF
	if(CouponData.Categories.Length == 0)
	{
		SubGroupButtonAsset._GetGroupButtonsInstance()._HideAllButtons();		
	}
	else
	{
		SubGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(CouponData.Categories.Length);
	}
	// End:0x139
	if(SubGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum() > 0)
	{
		SubGroupButtonAsset._GetGroupButtonsInstance()._fixedWidth(110, 5);
		SubGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0);
	}	
}

function DelegateOnClickButtonTopTab(string parentWndName, string strName, int Index)
{
	Debug("-----메인 탭-------");
	Debug("strName" @ parentWndName);
	Debug("strName" @ strName);
	Debug("index" @ string(Index));
	// End:0xAB
	if(TopGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum() == 1)
	{
		// End:0xA8
		if(Index == 0)
		{
			// End:0xA1
			if(CouponData.DefaultMultisellId > 0)
			{
				GotoState('ExchangeState');				
			}
			else
			{
				GotoState('ItemRecoveryState');
			}
		}		
	}
	else
	{
		// End:0xC0
		if(Index == 0)
		{
			GotoState('ItemRecoveryState');			
		}
		else
		{
			GotoState('ExchangeState');
		}
	}	
}

function DelegateOnClickButtonSubTab(string parentWndName, string strName, int Index)
{
	Debug("-----서브 탭-------");
	Debug("strName" @ parentWndName);
	Debug("strName" @ strName);
	Debug("index" @ string(Index));
	currentRecoverTabNum = Index;
	API_C_EX_ITEM_RESTORE_LIST(SubGroupButtonAsset._GetGroupButtonsInstance()._getButtonValue(Index));	
}

function ClearMultiSellAll()
{
	m_nCurrentMultiSellInfoIndex = 0;
	m_MultiSellInfoList.Length = 0;
	m_MultiSellGroupID = 0;
}

function setUpdateSystemString()
{
	setWindowTitleBySysStringNum(CouponData.TitleSysstringId);
	Recovery_Btn.SetTooltipCustomType(recoverCustomTooltip());	
}

event OnShow()
{
	showProcess();	
}

function showProcess()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	GetRecoveryCouponData(currentCouponClassID, CouponData);
	setSubGroupButtonCategory();
	setTopGroupButtonCategory();
	setUpdateSystemString();
	lastSelectedListArray[0] = 0;
	lastSelectedListArray[1] = 0;
	lastSelectedListArray[2] = 0;
	lastSelectedListArray[3] = 0;
	lastSelectedListArray[4] = 0;
	ExchangeItem_RichList.DeleteAllItem();
	ListDisable_Wnd.HideWindow();
	showDisable(false);
	GetPopupExpandScript().Hide();
	ResultDialog_Wnd.HideWindow();
	// End:0xF9
	if(TopGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum() == 1)
	{
		GotoState('None');
		// End:0xEF
		if(CouponData.DefaultMultisellId > 0)
		{
			GotoState('ExchangeState');			
		}
		else
		{
			GotoState('ItemRecoveryState');
		}		
	}
	else
	{
		GotoState('None');
		GotoState('ItemRecoveryState');
	}
}

event OnHide()
{
	EffectViewport02.SpawnEffect("");
	RecoveryRichList.DeleteAllItem();
	needItemScript.CleariObjects();
}

function addRichList_ItemRecovery(RichListCtrlHandle richList, int ItemClassID, int fixedItemClassID, int EnchantedNum)
{
	local RichListCtrlRowData RowData;
	local ItemInfo Info;
	local string gradeString, enchantedString;

	RowData.cellDataList.Length = 3;
	Info = GetItemInfoByClassID(fixedItemClassID);
	Info.Enchanted = EnchantedNum;
	ItemInfoToParam(Info, RowData.szReserved);
	gradeString = getInstanceL2Util().getItemGradeSystemString(Info.CrystalType);
	// End:0x8E
	if(Info.Enchanted > 0)
	{
		enchantedString = "+" $ string(Info.Enchanted);
	}
	else
	{
		enchantedString = "-";
	}
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, Info, 42, 42, 4, 0);
	RowData.cellDataList[0].szData = GetItemNameAll(Info);
	RowData.cellDataList[0].HiddenStringForSorting = RowData.cellDataList[0].szData;
	RowData.cellDataList[0].nReserved1 = ItemClassID;
	RowData.cellDataList[0].nReserved2 = EnchantedNum;
	RowData.cellDataList[0].nReserved3 = fixedItemClassID;
	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetItemNameAll(Info), GTColor().White, false, 4, 12);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, gradeString, GTColor().ColorGold, false, 0, 0);
	RowData.cellDataList[1].HiddenStringForSorting = gradeString;
	addRichListCtrlString(RowData.cellDataList[2].drawitems, enchantedString, GTColor().WhiteSmoke, false, 0, 0);
	RowData.cellDataList[2].HiddenStringForSorting = enchantedString;
	richList.InsertRecord(RowData);
}

function addRichList_Exchange(RichListCtrlHandle richList, int ItemClassID, INT64 ItemNum, int multiSellindex)
{
	local RichListCtrlRowData RowData;
	local ItemInfo Info;

	RowData.cellDataList.Length = 2;
	Info = GetItemInfoByClassID(ItemClassID);
	Info.ItemNum = ItemNum;
	ItemInfoToParam(Info, RowData.szReserved);
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, Info, 42, 42, 4, 0);
	RowData.nReserved1 = multiSellindex;
	RowData.cellDataList[0].szData = Info.Name;
	RowData.cellDataList[0].HiddenStringForSorting = RowData.cellDataList[0].szData;
	addRichListCtrlString(RowData.cellDataList[0].drawitems, Info.Name, GTColor().White, false, 4, 12);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, MakeCostString(string(ItemNum)), GTColor().ColorGold, false, 0, 0);
	RowData.cellDataList[1].HiddenStringForSorting = MakeCostString(string(ItemNum));
	richList.InsertRecord(RowData);
}

function CustomTooltip recoverCustomTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText("- " $ GetSystemString(13673), getInstanceL2Util().BrightWhite, "", true, true);
	// End:0x81
	if(getInstanceUIData().getIsClassicServer())
	{
		drawListArr[drawListArr.Length] = addDrawItemText("- " $ GetSystemString(13675), getInstanceL2Util().BrightWhite, "", true, true);
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 50;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Ok_Btn":
			OnOk_BtnClick();
			break;
		case "Recovery_Btn":
			OnRecovery_BtnClick();
			break;
		case "Exchange_Btn":
			OnExchange_BtnClick();
			break;
	}
}

function OnOk_BtnClick()
{
	// End:0x39
	if(IsInState('ItemRecoveryState'))
	{
		ResultDialog_Wnd.HideWindow();
		API_C_EX_ITEM_RESTORE_LIST(SubGroupButtonAsset._GetGroupButtonsInstance()._getSelectedButtonValue());
	}
	showDisable(false);
}

function OnRecovery_BtnClick()
{
	local RichListCtrlRowData RowData;

	// End:0xA1
	if(RecoveryRichList.GetSelectedIndex() > -1)
	{
		RecoveryRichList.GetSelectedRec(RowData);
		nCurrentBrokenItemClassId = RowData.cellDataList[0].nReserved1;
		nCurrentBrokenEnchantNum = RowData.cellDataList[0].nReserved2;
		nCurrentFixedItemClassId = RowData.cellDataList[0].nReserved3;
		ShowPopup(GetSystemMessage(13394), "<" $ RowData.cellDataList[0].szData $ ">");
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3443));
	}
}

function OnExchange_BtnClick()
{
	local RichListCtrlRowData RowData;

	// End:0x5C
	if(ExchangeItem_RichList.GetSelectedIndex() > -1)
	{
		ExchangeItem_RichList.GetSelectedRec(RowData);
		ShowPopup(GetSystemMessage(13395), ("<" $ RowData.cellDataList[0].szData) $ ">");
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3443));
	}
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	// End:0x61
	if(ListCtrlID == "Item_RichList")
	{
		// End:0x5E
		if(RecoveryRichList.GetSelectedIndex() > -1)
		{
			lastSelectedListArray[currentRecoverTabNum] = RecoveryRichList.GetSelectedIndex();
			updateNeedItem();
			DelegateNeedItemOnUpdateItem();
		}
	}
	else if(ListCtrlID == "ExchangeRichList")
	{
		updateNeedItem();
		DelegateNeedItemOnUpdateItem();
	}
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	// End:0x3A
	if(needItemScript.GetCanBuy())
	{
		// End:0x34
		if(ListCtrlID == "Item_RichList")
		{
			OnRecovery_BtnClick();
		}
		else
		{
			OnExchange_BtnClick();
		}
	}
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(class'UIPacket'.const.S_EX_ITEM_RESTORE_OPEN):
			ParsePacket_S_EX_ITEM_RESTORE_OPEN();
			return;
		case EV_PacketID(class'UIPacket'.const.S_EX_ITEM_RESTORE_LIST):
			ParsePacket_S_EX_ITEM_RESTORE_LIST();
			return;
		case EV_PacketID(class'UIPacket'.const.S_EX_ITEM_RESTORE):
			ParsePacket_S_EX_ITEM_RESTORE();
			return;
		default:
			if(Event_ID == EV_MultiSellInfoListBegin)
			{
				ParseInt(param, "ShowType", nShowType);
			}
			if(nShowType == 3)
			{
				switch(Event_ID)
				{
					case EV_MultiSellInfoListBegin:
						HandleMultiSellInfoListBegin(param);
						break;
					case EV_MultiSellResultItemInfo:
						HandleMultiSellResultItemInfo(param);
						break;
					case EV_MultiSellOutputItemInfo:
						HandelMultiSellOutputItemInfo(param);
						break;
					// End:0xDE
					case EV_MultiSellInputItemInfo:
						HandelMultiSellInputItemInfo(param);
						break;
					// End:0xF4
					case EV_MultiSellInfoListEnd:
						HandleMultiSellInfoListEnd(param);
						break;
					case EV_MultiSellResult:
						showDisable(false);
						break;
					case EV_AdenaInvenCount:
						updateNeedItem();
						DelegateNeedItemOnUpdateItem();
						break;
				}
			}
	}
}

function HandleMultiSellInfoListBegin(string param)
{
	ClearMultiSellAll();
	ParseInt(param, "MultiSellGroupID", m_MultiSellGroupID);
}

function HandleMultiSellResultItemInfo(string param)
{
	local int nMultiSellInfoID, nBuyType;
	local ItemInfo Info;

	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "BuyType", nBuyType);
	ItemInfoToParam(Info, param);
	m_nCurrentMultiSellInfoIndex = m_MultiSellInfoList.Length;
	m_MultiSellInfoList.Length = m_MultiSellInfoList.Length + 1;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID = nMultiSellInfoID;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellType = nBuyType;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].ResultItemInfo = Info;
}

function HandelMultiSellOutputItemInfo(string param)
{
	local ItemInfo Info;
	local int nItemClassID, nMultiSellInfoID, nCurrentOutputItemInfoIndex;

	ParseItemID(param, Info.Id);
	class'UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);
	ParamToItemInfo(param, Info);
	ParseInt(param, "ClassID", nItemClassID);
	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
	{
		return;
	}
	nCurrentOutputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length = nCurrentOutputItemInfoIndex + 1;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex] = Info;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex].Reserved = m_nCurrentMultiSellInfoIndex;
}

function HandelMultiSellInputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentInputItemInfoIndex, nItemClassID;
	local ItemInfo Info;

	ParseItemID(param, Info.Id);
	class'UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);
	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "ClassID", nItemClassID);
	ParamToItemInfo(param, Info);
	if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
	{
		return;
	}
	if(nItemClassID != MSIT_FIELD_CYCLE_POINT)
	{
		nCurrentInputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length;
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length = nCurrentInputItemInfoIndex + 1;
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList[nCurrentInputItemInfoIndex] = Info;
	}
}

function HandleMultiSellInfoListEnd(string param)
{
	local int i, N, multiSellindex;

	multiSellindex = GetExchangeItemSelectedMultiSellIndex();
	ExchangeItem_RichList.DeleteAllItem();

	for(N = 0; N < m_MultiSellInfoList.Length; N++)
	{
		for(i = 0; i < m_MultiSellInfoList[N].OutputItemInfoList.Length; i++)
		{
			addRichList_Exchange(ExchangeItem_RichList, m_MultiSellInfoList[N].OutputItemInfoList[i].Id.ClassID, m_MultiSellInfoList[N].OutputItemInfoList[i].ItemNum, N);
		}
	}
	if(multiSellindex > -1)
	{
		ExchangeItem_RichList.SetSelectedIndex(multiSellindex, true);
		ExchangeItem_RichList.SetFocus();
		updateNeedItem();
	}
	else
	{
		// End:0x12A
		if(ExchangeItem_RichList.GetRecordCount() > 0)
		{
			ExchangeItem_RichList.SetSelectedIndex(0, true);
			ExchangeItem_RichList.SetFocus();
			updateNeedItem();
		}
	}
}

function ParsePacket_S_EX_ITEM_RESTORE_OPEN()
{
	local UIPacket._S_EX_ITEM_RESTORE_OPEN packet;

	// End:0x26
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		return;
	}
	// End:0x41
	if(! class'UIPacket'.static.Decode_S_EX_ITEM_RESTORE_OPEN(packet))
	{
		return;
	}
	Debug("ParsePacket_S_EX_ITEM_RESTORE_OPEN" @ string(packet.nItemClassID));
	// End:0xB2
	if(Me.IsShowWindow() && currentCouponClassID == packet.nItemClassID)
	{
		Me.HideWindow();
		return;
	}
	// End:0xF2
	if(Me.IsShowWindow() && currentCouponClassID != packet.nItemClassID)
	{
		currentCouponClassID = packet.nItemClassID;
		showProcess();
		return;
	}
	currentCouponClassID = packet.nItemClassID;
	Me.ShowWindow();
	Me.SetFocus();	
}

function ParsePacket_S_EX_ITEM_RESTORE_LIST()
{
	local UIPacket._S_EX_ITEM_RESTORE_LIST packet;
	local int i, lastSelectedIndex;

	if(! class'UIPacket'.static.Decode_S_EX_ITEM_RESTORE_LIST(packet))
	{
		return;
	}
	Debug(" -->  S_EX_ITEM_RESTORE_LIST  :  ");
	packet.Items.Sort(SortListDelegate);
	RecoveryRichList.DeleteAllItem();
	// End:0xDE
	if(packet.Items.Length > 0)
	{
		ListDisable_Wnd.HideWindow();
	}
	else
	{
		ListDisable_Wnd.ShowWindow();
	}

    for(i=0; i < packet.Items.Length; i++)
	{
		addRichList_ItemRecovery(RecoveryRichList, packet.Items[i].nBrokenItemClassID, packet.Items[i].nFixedItemClassID, packet.Items[i].cEnchant);
	}
	// End:0x252
	if(RecoveryRichList.GetRecordCount() > -1)
	{
		lastSelectedIndex = lastSelectedListArray[currentRecoverTabNum];
		if(lastSelectedIndex < RecoveryRichList.GetRecordCount())
		{
			RecoveryRichList.SetSelectedIndex(lastSelectedIndex, true);
		}
		else
		{
			RecoveryRichList.SetSelectedIndex(RecoveryRichList.GetRecordCount() - 1, true);
		}
		RecoveryRichList.SetFocus();
		updateNeedItem();
	}
}

function ParsePacket_S_EX_ITEM_RESTORE()
{
	local UIPacket._S_EX_ITEM_RESTORE packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_ITEM_RESTORE(packet))
	{
		return;
	}
	Debug(" -->  S_EX_ITEM_RESTORE  :  " @ string(packet.cResult));
	// End:0x66
	if(packet.cResult == 0)
	{
		setResult();
	}
	else
	{
		Me.HideWindow();
	}
}

delegate int SortListDelegate(UIPacket._PkItemRestoreNode a1, UIPacket._PkItemRestoreNode a2)
{
	if(a1.cOrder > a2.cOrder)
	{
		return -1;
	}
	return 0;
}

function InitNeedItem()
{
	local WindowHandle needItemWnd;

	needItemWnd = GetWindowHandle(m_WindowName $ ".Bottom_Wnd.needItemWnd");
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemScript.SetRichListControler(GetRichListCtrlHandle(m_WindowName $ ".Bottom_Wnd.needItemWnd.NeedItemRichListCtrl"));
	needItemScript.DelegateOnUpdateItem = DelegateNeedItemOnUpdateItem;
}

function DelegateNeedItemOnUpdateItem()
{
	// End:0x41
	if(needItemScript.GetCanBuy())
	{
		// End:0x2F
		if(IsInState('ItemRecoveryState'))
		{
			Recovery_Btn.EnableWindow();
		}
		else
		{
			Exchange_Btn.EnableWindow();
		}
	}
	else
	{
		// End:0x5E
		if(IsInState('ItemRecoveryState'))
		{
			Recovery_Btn.DisableWindow();
		}
		else
		{
			Exchange_Btn.DisableWindow();
		}
	}
}

function SetPopupScript()
{
	local WindowHandle popExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle disableWnd;

	popExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	popupExpandScript = class'UIControlDialogAssets'.static.InitScript(popExpandWnd);
	disableWnd = GetWindowHandle(m_WindowName $ ".disable_tex");
	popupExpandScript.SetDisableWindow(disableWnd);
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop(m_WindowName $ ".disable_tex", false);
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function ShowPopup(string Msg, string Param1)
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = GetPopupExpandScript();
	popupExpandScript.SetDialogDesc(MakeFullSystemMsg(Msg, Param1));
	popupExpandScript.Show();
	popupExpandScript.OKButton.EnableWindow();
	popupExpandScript.DelegateOnClickBuy = OnDialogOK;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	showDisable(true);
}

function OnDialogOK()
{
	local string param;
	local int multiSellindex;

	// End:0x35
	if(IsInState('ItemRecoveryState'))
	{
		GetPopupExpandScript().Hide();
		showDisable(true);
		API_C_EX_ITEM_RESTORE(nCurrentBrokenItemClassId, nCurrentBrokenEnchantNum);
	}
	else
	{
		GetPopupExpandScript().Hide();
		showDisable(true);
		multiSellindex = GetExchangeItemSelectedMultiSellIndex();
		ParamAdd(param, "MultiSellGroupID", string(m_MultiSellGroupID));
		ParamAdd(param, "MultiSellInfoID", string(m_MultiSellInfoList[multiSellindex].MultiSellInfoID));
		ParamAdd(param, "ItemCount", "1");
		ParamAdd(param, "Enchant", string(m_MultiSellInfoList[multiSellindex].resultItemInfo.Enchanted));
		ParamAdd(param, "RefineryOp1", string(m_MultiSellInfoList[multiSellindex].resultItemInfo.RefineryOp1));
		ParamAdd(param, "RefineryOp2", string(m_MultiSellInfoList[multiSellindex].resultItemInfo.RefineryOp2));
		ParamAdd(param, "AttrAttackType", string(m_MultiSellInfoList[multiSellindex].resultItemInfo.AttackAttributeType));
		ParamAdd(param, "AttrAttackValue", string(m_MultiSellInfoList[multiSellindex].resultItemInfo.AttackAttributeValue));
		ParamAdd(param, "AttrDefenseValueFire", string(m_MultiSellInfoList[multiSellindex].resultItemInfo.DefenseAttributeValueFire));
		ParamAdd(param, "AttrDefenseValueWater", string(m_MultiSellInfoList[multiSellindex].resultItemInfo.DefenseAttributeValueWater));
		ParamAdd(param, "AttrDefenseValueWind", string(m_MultiSellInfoList[multiSellindex].resultItemInfo.DefenseAttributeValueWind));
		ParamAdd(param, "AttrDefenseValueEarth", string(m_MultiSellInfoList[multiSellindex].resultItemInfo.DefenseAttributeValueEarth));
		ParamAdd(param, "AttrDefenseValueHoly", string(m_MultiSellInfoList[multiSellindex].resultItemInfo.DefenseAttributeValueHoly));
		ParamAdd(param, "AttrDefenseValueUnholy", string(m_MultiSellInfoList[multiSellindex].resultItemInfo.DefenseAttributeValueUnholy));
		addParamEnsoulOptionInfo(m_MultiSellInfoList[multiSellindex].resultItemInfo, param);
		ParamAdd(param, "IsBlessedItem", string(boolToNum(m_MultiSellInfoList[multiSellindex].resultItemInfo.IsBlessedItem)));
		RequestMultiSellChoose(param);
	}
}

function OnClickCancelDialog()
{
	GetPopupExpandScript().Hide();
	showDisable(false);
}

function setResult()
{
	local ItemInfo Info;

	ResultDialog_Wnd.ShowWindow();
	Info = GetItemInfoByClassID(nCurrentFixedItemClassId);
	Info.Enchanted = nCurrentBrokenEnchantNum;
	Result_ItemWnd.Clear();
	Result_ItemWnd.AddItem(Info);
	ItemName_Txt.SetText(GetItemNameAll(Info));
	playResultEffectViewPort("LineageEffect2.ui_upgrade_succ");
	PlaySound("ItemSound3.enchant_success");
}

function int getMultiSellID()
{
	local int serverNo, i;

	serverNo = GetServerNo();

	// End:0x57 [Loop If]
	for(i = 0; i < CouponData.ExtraMultisellServers.Length; i++)
	{
		// End:0x4D
		if(CouponData.ExtraMultisellServers[i] == serverNo)
		{
			return CouponData.ExtraMultisellId;
		}
	}
	return CouponData.DefaultMultisellId;	
}

function API_C_EX_ITEM_RESTORE_LIST(int cCategory)
{
	local array<byte> stream;
	local UIPacket._C_EX_ITEM_RESTORE_LIST packet;

	packet.cCategory = cCategory;
	if(!Class 'UIPacket'.static.Encode_C_EX_ITEM_RESTORE_LIST(stream, packet))
	{
		return;
	}
	RecoveryRichList.DeleteAllItem();
	Class 'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_ITEM_RESTORE_LIST, stream);
	Debug("----> Api Call : C_EX_ITEM_RESTORE_LIST  " @ string(cCategory));
}

function API_C_EX_ITEM_RESTORE(int nBrokenItemClassID, int cEnchant)
{
	local array<byte> stream;
	local UIPacket._C_EX_ITEM_RESTORE packet;

	packet.nBrokenItemClassID = nBrokenItemClassID;
	packet.cEnchant = cEnchant;
	if(!Class 'UIPacket'.static.Encode_C_EX_ITEM_RESTORE(stream, packet))
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_ITEM_RESTORE, stream);
	Debug("----> Api Call : C_EX_ITEM_RESTORE  " @ string(nBrokenItemClassID) @ string(cEnchant));
}

function API_C_EX_MULTI_SELL_LIST(int nMultiSellID)
{
	local array<byte> stream;
	local UIPacket._C_EX_MULTI_SELL_LIST packet;

	packet.nGroupID = nMultiSellID;
	if(!Class 'UIPacket'.static.Encode_C_EX_MULTI_SELL_LIST(stream, packet))
	{
		return;
	}
	Class 'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_MULTI_SELL_LIST, stream);
	Debug("----> Api Call : C_EX_MULTI_SELL_LIST 멀티셀 호출 " @ string(nMultiSellID));	
}

function int GetExchangeItemSelectedMultiSellIndex()
{
	local RichListCtrlRowData RowData;

	// End:0x1F
	if(ExchangeItem_RichList.GetSelectedIndex() == -1)
	{
		return -1;
	}
	// End:0x3A
	if(ExchangeItem_RichList.GetRecordCount() < 1)
	{
		return -1;
	}
	ExchangeItem_RichList.GetSelectedRec(RowData);
	return int(RowData.nReserved1);
}

function showDisable(bool bShow)
{
	// End:0x31
	if(bShow)
	{
		GetWindowHandle(m_WindowName $ ".disable_tex").ShowWindow();
	}
	else
	{
		GetWindowHandle(m_WindowName $ ".disable_tex").HideWindow();
	}
}

function playResultEffectViewPort(string effectPath)
{
	local Vector offset;

	// End:0x89
	if(effectPath == "LineageEffect2.ui_upgrade_succ")
	{
		offset.X = 10.0f;
		offset.Y = -5.0f;
		EffectViewport02.SetScale(6.0f);
		EffectViewport02.SetCameraDistance(1300.0f);
		EffectViewport02.SetOffset(offset);
	}
	else
	{
		// End:0x10B
		if(effectPath == "LineageEffect.d_firework_a")
		{
			offset.X = 10.0f;
			offset.Y = -5.0f;
			EffectViewport02.SetScale(6.0f);
			EffectViewport02.SetCameraDistance(1300.0f);
			EffectViewport02.SetOffset(offset);
		}
	}
	EffectViewport02.SetFocus();
	EffectViewport02.SpawnEffect(effectPath);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	// End:0x53
	if(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset").IsShowWindow())
	{
		showDisable(false);
		GetPopupExpandScript().Hide();
	}
	else
	{
		GetWindowHandle(m_WindowName).HideWindow();
	}
}

state ItemRecoveryState
{
	function BeginState()
	{
		Recovery_Btn.ShowWindow();
		Exchange_Btn.HideWindow();
		ItemRecovery_Wnd.ShowWindow();
		Exchange_Wnd.HideWindow();
		updateNeedItem();
		Debug("시작 스테이트 ItemRecoveryState");
	}

	function updateNeedItem()
	{
		needItemScript.CleariObjects();
		needItemScript.StartNeedItemList(1);
		needItemScript.AddNeedItemClassID(currentCouponClassID, 1);
		needItemScript.SetBuyNum(1);
	}
}

state ExchangeState
{
	function BeginState()
	{
		Recovery_Btn.HideWindow();
		Exchange_Btn.ShowWindow();
		ItemRecovery_Wnd.HideWindow();
		Exchange_Wnd.ShowWindow();
		Debug("시작 스테이트 ExchangeState");
		needItemScript.CleariObjects();
		API_C_EX_MULTI_SELL_LIST(getMultiSellID());
	}

	function updateNeedItem()
	{
		local int i, multiSellindex;

		multiSellindex = GetExchangeItemSelectedMultiSellIndex();
		// End:0xB3
		if(multiSellindex > -1)
		{
			needItemScript.CleariObjects();
			needItemScript.StartNeedItemList(1);

			for(i = 0; i < m_MultiSellInfoList[multiSellindex].InputItemInfoList.Length; i++)
			{
				needItemScript.AddNeedItemClassID(m_MultiSellInfoList[multiSellindex].InputItemInfoList[i].Id.ClassID, m_MultiSellInfoList[multiSellindex].InputItemInfoList[i].ItemNum);
			}
			needItemScript.SetBuyNum(1);
		}
	}
}

defaultproperties
{
     m_WindowName="BlackCouponWnd"
}
