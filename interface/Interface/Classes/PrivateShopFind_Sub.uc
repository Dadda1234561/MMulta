class PrivateShopFind_Sub extends UICommonAPI;

enum ItemType
{
	Equipment,
	Artifact,
	Enchant,
	Consumable,
	EtcType
};

enum ItemSubtype
{
	Weapon,
	Armor,
	Accessary,
	EtcEquipment,
	ArtifactB1,
	ArtifactC1,
	ArtifactD1,
	ArtifactA1,
	ENCHANTSCROLL,
	BlessEnchantScroll,
	MultiEnchantScroll,
	AncientEnchantScroll,
	Spiritshot,
	Soulshot,
	Buff,
	VariationStone,
	dye,
	SoulCrystal,
	SkillBook,
	EtcEnchant,
	PotionAndEtcScroll,
	ticket,
	Craft,
	IncEnchantProp,
	EtcSubtype
};

enum StoreType
{
	Sell,
	Buy,
	Wholesale,
	AllStoreType
};

struct categoryStruct
{
	var int SelectedIndex;
	var array<string> categoryStringArray;
	var array<string> categoryKeyArray;
};

var WindowHandle Me;
var ButtonHandle ReFresh_btn;
var TextureHandle GroupBox_tex;
var TextureHandle ListDeco_tex;
var RichListCtrlHandle List_RichList;
var WindowHandle FindDisable_Wnd;
var UIControlGroupButtonAssets SubUIControlGroupButtonAsset;
var PrivateShopFindWnd PrivateShopFindWndScript;
var UIControlGroupButtonAssets SubGroupButtonAsset;
var string m_WindowName;
var bool m_IsPrivateStoreBypass;
var array<categoryStruct> categoryArray;
var array<UIPacket._pkPSSearchItem> pkSearchItemListArray;
var array<UIPacket._pkPSSearchHistory> pkHistoryArray;

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PRIVATE_STORE_SEARCH_ITEM);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PRIVATE_STORE_SEARCH_HISTORY);
}

function OnLoad()
{
	Initialize();
}

function OnShow()
{
	if(GetWindowHandle("PrivateShopFindWnd").IsShowWindow())
	{
		Debug("OnShow PrivateShopFind_Sub");
		initCategoryData();
	}
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	FindDisable_Wnd = GetWindowHandle(m_WindowName $ ".FindDisable_Wnd");
	ReFresh_btn = GetButtonHandle(m_WindowName $ ".PrivateShopFind_Sub.Refresh_btn");
	GroupBox_tex = GetTextureHandle(m_WindowName $ ".PrivateShopFind_Sub.GroupBox_tex");
	ListDeco_tex = GetTextureHandle(m_WindowName $ ".PrivateShopFind_Sub.ListDeco_tex");
	List_RichList = GetRichListCtrlHandle(m_WindowName $ ".PrivateShopFind_Sub.List_RichList");
	PrivateShopFindWndScript = PrivateShopFindWnd(GetScript("PrivateShopFindWnd"));
	initGroupButton();
	categoryArray.Length = 0;
	List_RichList.SetSelectedSelTooltip(false);
	List_RichList.SetAppearTooltipAtMouseX(true);
	m_IsPrivateStoreBypass = IsPrivateStoreBypass();
	List_RichList.SetColumnString(4, 7244);
}

function initCategoryData()
{
	local string categoryValueStr;

	if(categoryArray.Length <= 0)
	{
		if(getInstanceUIData().getIsClassicServer())
		{
			categoryValueStr = "-1," $ string(0) $ "," $ string(1) $ "," $ string(2) $ "," $ string(3);
			categoryArray[categoryArray.Length] = getCategoryStruct("1046,2520,2532,2537,49", categoryValueStr);
			categoryValueStr = "-1," $ string(8) $ "," $ string(17) $ "," $ string(15) $ "," $ string(16) $ "," $ string(18) $ "," $ string(19);
			categoryArray[categoryArray.Length] = getCategoryStruct("1046,1532,2554,2553,25,2558,49", categoryValueStr);
			categoryValueStr = "-1," $ string(20) $ "," $ string(21) $ "," $ string(22) $ "," $ string(24);
			categoryArray[categoryArray.Length] = getCategoryStruct("1046,13848,5834,13892,49", categoryValueStr);
			categoryValueStr = "-1," $ string(0) $ "," $ string(2) $ "," $ string(4);
			categoryArray[categoryArray.Length] = getCategoryStruct("1046,116,13846,49", categoryValueStr);			
		}
		else
		{
			categoryValueStr = "-1," $ string(0) $ "," $ string(1) $ "," $ string(2);
			categoryArray[categoryArray.Length] = getCategoryStruct("1046,2520,2532,2537", categoryValueStr);
			categoryValueStr = "-1," $ string(4) $ "," $ string(5) $ "," $ string(6) $ "," $ string(7);
			categoryArray[categoryArray.Length] = getCategoryStruct("144,3891,3892,3893,3894", categoryValueStr);
			categoryValueStr = "-1," $ string(8) $ "," $ string(9) $ "," $ string(10) $ "," $ string(11);
			categoryArray[categoryArray.Length] = getCategoryStruct("144,2611,13841,13842,13843", categoryValueStr);
			categoryValueStr = "-1," $ string(12) $ "," $ string(13) $ "," $ string(14);
			categoryArray[categoryArray.Length] = getCategoryStruct("144,2545,2544,13318", categoryValueStr);
			categoryValueStr = "-1," $ string(15) $ "," $ string(16) $ "," $ string(23) $ "," $ string(24);
			categoryArray[categoryArray.Length] = getCategoryStruct("144,3349,25,13844,49", categoryValueStr);
			categoryArray[categoryArray.Length] = getCategoryStruct("144", "0");
		}
	}
}

function categoryStruct getCategoryStruct(string categoryString, string matchKeyString)
{
	local categoryStruct Data;

	getInstanceL2Util().setSystemStringArrayByNumStr(categoryString, Data.categoryStringArray);
	getInstanceL2Util().setArrayByNumStr(matchKeyString, Data.categoryKeyArray);
	return Data;
}

function initGroupButton()
{
	SubGroupButtonAsset = class'UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle(m_WindowName $ ".SubUIControlGroupButtonAsset"));
	SubGroupButtonAsset._SetStartInfo("L2UI_ct1.RankingWnd.RankingWnd_SubTabButton", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Down", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Over", true);
	SubGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButton;
	SubGroupButtonAsset._setDelayTime(1500);
	SubGroupButtonAsset.DelegateOnDelayTime = DelegateOnDelayTime;
}

function DelegateOnDelayTime(bool bOnTime)
{
	if(bOnTime)
	{
		ReFresh_btn.DisableWindow();
	}
	else
	{
		ReFresh_btn.EnableWindow();
	}
}

function setGroupButtonCategory(int Index)
{
	local int i;

	for(i = 0; i < categoryArray[Index].categoryStringArray.Length; i++)
	{
		SubGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(i, categoryArray[Index].categoryStringArray[i]);
		SubGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(i, int(categoryArray[Index].categoryKeyArray[i]));
	}
	SubGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(categoryArray[Index].categoryStringArray.Length);
	SubGroupButtonAsset._GetGroupButtonsInstance()._fixedWidth(110, 5);
	SubGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(categoryArray[Index].SelectedIndex);
}

function DelegateOnClickButton(string parentWndName, string strName, int Index)
{
	local int topButtonGroupIndex;

	topButtonGroupIndex = PrivateShopFindWndScript.TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex() - 1;
	categoryArray[topButtonGroupIndex].SelectedIndex = Index;
	refresh();
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_GameStart:
			categoryArray.Length = 0;
			break;
		case EV_Restart:
			categoryArray.Length = 0;
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_PRIVATE_STORE_SEARCH_ITEM):
			ParsePacket_S_EX_PRIVATE_STORE_SEARCH_ITEM();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_PRIVATE_STORE_SEARCH_HISTORY):
			ParsePacket_S_EX_PRIVATE_STORE_SEARCH_HISTORY();
			break;
	}
}

function ParsePacket_S_EX_PRIVATE_STORE_SEARCH_ITEM()
{
	local UIPacket._S_EX_PRIVATE_STORE_SEARCH_ITEM packet;
	local int i;

	if(!class'UIPacket'.static.Decode_S_EX_PRIVATE_STORE_SEARCH_ITEM(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_PRIVATE_STORE_SEARCH_ITEM :  " @ string(packet.Items.Length));

	if(packet.Items.Length == 0)
	{
		FindDisable_Wnd.ShowWindow();
	}
	else
	{
		FindDisable_Wnd.HideWindow();
	}
	Debug("packet.cCurrentPage" @ string(packet.cCurrentPage));
	Debug("packet.cMaxPage" @ string(packet.cMaxPage));

	if(packet.cCurrentPage == 1)
	{
		PrivateShopFindWndScript.DisableWnd.ShowWindow();
		pkSearchItemListArray.Length = 0;
		pkHistoryArray.Length = 0;
	}

	for(i = 0; i < packet.Items.Length; i++)
	{
		pkSearchItemListArray[pkSearchItemListArray.Length] = packet.Items[i];
	}
}

function ParsePacket_S_EX_PRIVATE_STORE_SEARCH_HISTORY()
{
	local UIPacket._S_EX_PRIVATE_STORE_SEARCH_HISTORY packet;
	local ItemInfo Info;
	local Vector Loc;
	local int i;

	if(!class'UIPacket'.static.Decode_S_EX_PRIVATE_STORE_SEARCH_HISTORY(packet))
	{
		return;
	}

	for(i = 0; i < packet.histories.Length; i++)
	{
		pkHistoryArray[pkHistoryArray.Length] = packet.histories[i];
	}

	if(packet.cCurrentPage == packet.cMaxPage)
	{
		for(i = 0; i < pkSearchItemListArray.Length; i++)
		{
			RequestDisassembleItemInfo(pkSearchItemListArray[i].itemAssemble, Info);
			Loc.X = float(pkSearchItemListArray[i].nX);
			Loc.Y = float(pkSearchItemListArray[i].nY);
			Loc.Z = float(pkSearchItemListArray[i].nZ);

			if(m_IsPrivateStoreBypass)
			{
				pkSearchItemListArray[i].sUserName = GetSystemString(13198);
			}
			addRichListItem(pkSearchItemListArray[i].cStoreType, Info, Info.ItemNum, pkSearchItemListArray[i].nPrice, pkSearchItemListArray[i].sUserName, pkSearchItemListArray[i].nUserSID, Loc);
		}
		PrivateShopFindWndScript.DisableWnd.HideWindow();
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Refresh_btn":
			OnReFresh_btnClick();
			break;
		case "teleportBtn":
			OnTeleportBtnListClick();
			break;
	}
}

function OnReFresh_btnClick()
{
	refresh();
}

function OnTeleportBtnListClick()
{
	OnDBClickListCtrlRecord("List_RichList");
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData RowData;

	if(ListCtrlID == "List_RichList")
	{
		List_RichList.GetSelectedRec(RowData);

		if(m_IsPrivateStoreBypass)
		{
			API_C_EX_PRIVATE_STORE_BUY_SELL(RowData.cellDataList[3].nReserved1);			
		}
		else
		{
			Debug("\\tRowData.cellDataList[5].nReserved1 " @ string(RowData.cellDataList[5].nReserved1));

			if(RowData.cellDataList[5].nReserved1 > -1)
			{
				PrivateShopFindWndScript.ShowPopupTeleport(RowData.cellDataList[5].nReserved1);
			}
			else
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13562));
			}
		}
	}
}

function setUserTargetCommand()
{
	local RichListCtrlRowData RowData;

	if(List_RichList.GetSelectedIndex() > -1)
	{
		List_RichList.GetSelectedRec(RowData);
		ChatWnd(GetScript("ChatWnd")).SetChatEditBox(MakeFullSystemMsg(GetSystemMessage(13571), RowData.cellDataList[3].szReserved));
	}
}

function addRichListItem(int nShopType, ItemInfo Info, INT64 Amount, INT64 adenaPrice, string pcName, int UserSid, Vector LocVector)
{
	local RichListCtrlRowData RowData;
	local string toolTipParam;
	local Color tColor;

	RowData.cellDataList.Length = 6;

	if(nShopType == 2)
	{
		tColor = GetColor(136, 136, 255, 255);
	}
	else
	{
		if(nShopType == 1)
		{
			tColor = GetColor(255, 102, 102, 255);
		}
		else
		{
			tColor = GetColor(85, 153, 255, 255);
		}
	}
	addRichListCtrlString(RowData.cellDataList[0].drawitems, getStringShopType(nShopType), tColor, false, 0, 0);
	RowData.cellDataList[1].HiddenStringForSorting = getStringShopType(nShopType);
	addRichListCtrlTexture(RowData.cellDataList[1].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 8, 1);
	AddRichListCtrlItem(RowData.cellDataList[1].drawitems, Info, 32, 32, -34, 2);

	if(Info.IconPanel != "")
	{
		addRichListCtrlTexture(RowData.cellDataList[1].drawitems, Info.IconPanel, 32, 32, -32, 0);
	}
	addRichListCtrlString(RowData.cellDataList[1].drawitems, GetItemNameAll(Info), GTColor().White, false, 4, 7);
	RowData.cellDataList[1].HiddenStringForSorting = GetItemNameAll(Info);
	RowData.cellDataList[1].nReserved1 = Info.Id.ClassID;
	addRichListCtrlString(RowData.cellDataList[1].drawitems, ("(" $ MakeCostStringINT64(Amount)) $ ")", GTColor().White, false, 4, 0);
	addRichListCtrlTexture(RowData.cellDataList[2].drawitems, "L2UI_EPIC.RestartMenuWnd.Icon_Adena", 18, 16, 210, 15);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, "", GTColor().White, true, 0, 0);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, ConvertNumToText(string(adenaPrice)), GetNumericColor(MakeCostStringINT64(adenaPrice)), false, 30, -14);
	RowData.cellDataList[2].HiddenStringForSorting = getInstanceL2Util().makeZeroString(20, adenaPrice);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, "", GTColor().White, true, 0, 0);
	toolTipParam = getParamHistory(Info.Id.ClassID);
	addRichListCtrlButton(RowData.cellDataList[2].drawitems, "ReceipBtn", 0, -22, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_ReceiptIcon", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_ReceiptIcon", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_ReceiptIcon", 24, 30, 24, 30, 2, toolTipParam);
	addRichListCtrlString(RowData.cellDataList[3].drawitems, pcName, GTColor().White, false, 4, 2);
	RowData.cellDataList[3].HiddenStringForSorting = pcName;
	RowData.cellDataList[3].szReserved = pcName;
	RowData.cellDataList[3].nReserved1 = UserSid;

	if(m_IsPrivateStoreBypass)
	{
		addRichListCtrlString(RowData.cellDataList[4].drawitems, GetSystemString(7244), GTColor().White, false, 4, 2);
	}
	else
	{
		addRichListCtrlString(RowData.cellDataList[4].drawitems, GetZoneNameWithLocation(LocVector), GTColor().White, false, 4, 2);
		RowData.cellDataList[4].HiddenStringForSorting = GetZoneNameWithLocation(LocVector);
	}
	RowData.cellDataList[5].nReserved1 = getInstanceUIData().GetTeleportIDByXYZ(LocVector.X, LocVector.Y, LocVector.Z, true);

	if(m_IsPrivateStoreBypass)
	{
		addRichListCtrlButton(RowData.cellDataList[5].drawitems, "teleportBtn", 0, 0, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_ExchangeBtn_Normal", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_ExchangeBtn_Down", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_ExchangeBtn_Over", 30, 30, 30, 30, 1);		
	}
	else
	{
		addRichListCtrlButton(RowData.cellDataList[5].drawitems, "teleportBtn", 0, 0, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_TeleportBtn_Normal", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_TeleportBtn_Down", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_TeleportBtn_Over", 30, 30, 30, 30, 1);
	}
	List_RichList.InsertRecord(RowData);
}

function string getParamHistory(int nClassID)
{
	local string param;
	local int Count, i;

	for(i = 0; i < pkHistoryArray.Length; i++)
	{
		if(pkHistoryArray[i].nClassID == nClassID)
		{
			Count++;
			ParamAdd(param, "shopType" $ string(Count), string(pkHistoryArray[i].cStoreType));
			ParamAdd(param, "adenaString" $ string(Count), string(pkHistoryArray[i].nPrice));
			ParamAdd(param, "enchant" $ string(Count), string(pkHistoryArray[i].cEnchant));
		}
	}
	ParamAdd(param, "count", string(Count));
	return param;
}

function refresh()
{
	local string inputText;
	local int nStoreType, nItemType, nItemSubtype;
	local bool bCollectionUse;

	PrivateShopFindWndScript.TopGroupButtonAsset._tryDelayClick();
	SubGroupButtonAsset._tryDelayClick();
	inputText = PrivateShopFindWndScript.uicontrolTextInputScr.GetString();
	nStoreType = PrivateShopFindWndScript.getStoreTypeByCheckBox();
	nItemType = PrivateShopFindWndScript.TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectedButtonValue();
	nItemSubtype = SubGroupButtonAsset._GetGroupButtonsInstance()._getSelectedButtonValue();

	if(getInstanceUIData().getIsClassicServer())
	{
		if(nItemType == PrivateShopFindWndScript.const.COLLECTION_ITEM_TYPE)
		{
			bCollectionUse = true;
			nItemType = SubGroupButtonAsset._GetGroupButtonsInstance()._getSelectedButtonValue();
			nItemSubtype = -1;
		}
		else
		{
			bCollectionUse = false;
		}
	}
	else
	{
		if(nItemType == PrivateShopFindWndScript.const.COLLECTION_ITEM_TYPE)
		{
			bCollectionUse = true;
			nItemType = SubGroupButtonAsset._GetGroupButtonsInstance()._getSelectedButtonValue();
			nItemSubtype = -1;
		}
		else
		{
			bCollectionUse = false;
		}
	}
	Debug("------------- refresh ----------------------");
	Debug("inputText" @ inputText);
	Debug("nStoreType" @ string(nStoreType));
	Debug("nItemType" @ string(nItemType));
	Debug("nItemSubtype" @ string(nItemSubtype));
	Debug("bCollectionUse" @ string(bCollectionUse));
	List_RichList.DeleteAllItem();
	API_C_EX_PRIVATE_STORE_SEARCH_LIST(inputText, nStoreType, nItemType, nItemSubtype, bCollectionUse);
}

function string getStringShopType(int nShopType)
{
	if(nShopType == 2)
	{
		return GetSystemString(13851);
	}
	else if(nShopType == 1)
	{
		return GetSystemString(13850);
	}
	return GetSystemString(1157);
}

function API_C_EX_PRIVATE_STORE_SEARCH_LIST(string sSearchWord, int cStoreType, int cItemType, int cItemSubtype, bool bCollectionUse)
{
	local array<byte> stream;
	local UIPacket._C_EX_PRIVATE_STORE_SEARCH_LIST packet;

	sSearchWord = Caps(sSearchWord);
	packet.sSearchWord = sSearchWord;
	packet.cStoreType = cStoreType;
	packet.cItemType = cItemType;
	packet.cItemSubtype = cItemSubtype;
	packet.bSearchCollection = byte(boolToNum(bCollectionUse));

	if(!class'UIPacket'.static.Encode_C_EX_PRIVATE_STORE_SEARCH_LIST(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PRIVATE_STORE_SEARCH_LIST, stream);
	Debug("api Call : C_EX_PRIVATE_STORE_SEARCH_LIST" @ packet.sSearchWord @ string(packet.cStoreType) @ string(packet.cItemType) @ string(packet.cItemSubtype) @ string(packet.bSearchCollection));
}

function API_C_EX_PRIVATE_STORE_BUY_SELL(int nUserSID)
{
	local array<byte> stream;
	local UIPacket._C_EX_PRIVATE_STORE_BUY_SELL packet;

	packet.nTargetSid = nUserSID;

	if(!class'UIPacket'.static.Encode_C_EX_PRIVATE_STORE_BUY_SELL(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PRIVATE_STORE_BUY_SELL, stream);
	Debug("api Call : C_EX_PRIVATE_STORE_BUY_SELL" @ string(packet.nTargetSid));
}

defaultproperties
{
}
