//  마몬?�� ????��?��?�� ?���? ?��?�� ?��?��?��
// //?��?�� 1031126

class TokenTradeWnd extends UICommonAPI;

const DelaySelectedTimerID = 12131212;
const DelayTimer = 50;
const TOKENSELLWND_DIALOG_OK = 1124;

//?�� ?���? ?��?��?��?�� ?���? 모름.
struct MultiSellInfo
{
	var int MultiSellInfoID;
	var int MultiSellType;
	var INT64 NeededItemNum;
	var ItemInfo ResultItemInfo;
	var array<ItemInfo> OutputItemInfoList;
	var array<ItemInfo> InputItemInfoList;
	var array<string> per;
	var array<string> param;
};

var WindowHandle Me;
var ButtonHandle TradeBtn;
var ButtonHandle CancelBtn;
var TextBoxHandle ItemTypeText;
var TextBoxHandle TradePossibleText;
var TextBoxHandle ItemExplainText;

//var TextBoxHandle NeedItemText;
//var TextBoxHandle NeedItemNameText;
//var TextBoxHandle NeedItemNumberText;

var TreeHandle ItemTypeTree;
var TreeHandle NeedItemTree;
var ListCtrlHandle TradePossibleListCtrl;

var TextureHandle NeedItemIcon;

//?��?�� 배우기용 �??��
var L2Util util;

var array<MultiSellInfo> m_MultiSellInfoList;
var int m_MultiSellGroupID;
var int m_nSelectedMultiSellInfoIndex;
var int m_nCurrentMultiSellInfoIndex;

// 최종 ?��?�� ?��?�� ?��?��?�� ?���? 기억 ?��?���? 복원 ?��?�� ?��?��
var int lastSelectNitemID;
var int lastSelectIndex;

function OnRegisterEvent()
{
	RegisterEvent(EV_NewMultiSellInfoListBegin);
	RegisterEvent(EV_NewMultiSellResultItemInfo);
	RegisterEvent(EV_NewMultiSellOutputItemInfo);
	RegisterEvent(EV_NewMultiSellInputItemInfo);
	RegisterEvent(EV_NewMultiSellInfoListEnd);
	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_DialogOK);
}

function OnLoad()
{
	SetClosingOnESC();

	Initialize();
	Load();
}

function OnShow()
{
	Me.KillTimer(DelaySelectedTimerID);
	lastSelectNitemID = 0;
	lastSelectIndex = 0;

	// �??��?�� ?��?��?���? ?��?��?�� ?���? 기능
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
}

function Initialize()
{
	Me = GetWindowHandle("TokenTradeWnd");
	TradeBtn = GetButtonHandle("TokenTradeWnd.TradeBtn");
	CancelBtn = GetButtonHandle("TokenTradeWnd.CancelBtn");
	ItemTypeText = GetTextBoxHandle("TokenTradeWnd.ItemTypeText");
	TradePossibleText = GetTextBoxHandle("TokenTradeWnd.TradePossibleText");
	ItemExplainText = GetTextBoxHandle("TokenTradeWnd.ItemExplainText");
	ItemTypeTree = GetTreeHandle("TokenTradeWnd.ItemTypeTree");
	NeedItemTree = GetTreeHandle("TokenTradeWnd.NeedItemTree");
	TradePossibleListCtrl = GetListCtrlHandle("TokenTradeWnd.TradePossibleListCtrl");
	NeedItemIcon = GetTextureHandle("TokenTradeWnd.NeedItemIcon");
	TradePossibleListCtrl.SetSelectedSelTooltip(false);
	TradePossibleListCtrl.SetAppearTooltipAtMouseX(true);
}

function Load()
{
	util = L2Util(GetScript("L2Util"));
}

function OnClickButton(string strID)
{
	//Tree?�� �??��
	local array<string> Result;
	local string treelist;

	treelist = Left(strID, 4);

	if(strID == "TradeBtn")
	{
		OnTradeBtnClick();
	}
	else if(strID == "CancelBtn")
	{
		OnCancelBtnClick();
	}

	if(treelist == "Root")
	{
		Split(strID, ".", Result);
		SelectChangeItem(int(Result[1]));
	}
}

function OnTradeBtnClick()
{
	local array<string> Result;
	local string treelist;
	local int selectedIndex;

	treelist = class'UIAPI_TREECTRL'.static.GetExpandedNode("TokenTradeWnd.ItemTypeTree", "Root");
	Split(treelist, ".", Result);

	if(treelist != "")
	{
		selectedIndex = int(Result[1]);

		DialogSetReservedInt(selectedIndex);
		DialogSetReservedInt2(1);
		DialogSetID(TOKENSELLWND_DIALOG_OK);
		DialogShow(DialogModalType_Modalless,DialogType_Warning, GetSystemMessage(1383), string(self));
		m_nSelectedMultiSellInfoIndex = selectedIndex;

		lastSelectNitemID = m_MultiSellInfoList[m_nSelectedMultiSellInfoIndex].MultiSellInfoID;
	}
}

function OnCancelBtnClick()
{
	Clear();
	Me.HideWindow();
}

function OnHide()
{
	Me.KillTimer(DelaySelectedTimerID);
	lastSelectNitemID = 0;
	lastSelectIndex = 0;
}

function HandleDialogOK()
{
	local string param;
	local int SelectedIndex;

	if(DialogIsMine())
	{
		SelectedIndex = DialogGetReservedInt();

		if(SelectedIndex >= m_MultiSellInfoList.Length)
		{
			//debug("MultiSellWnd::HandleDialogOK - Invalid SelectIndex(" $ SelectedIndex $ ")" );
			return;
		}

		ParamAdd(param, "MultiSellGroupID",			string(m_MultiSellGroupID));
		ParamAdd(param, "MultiSellInfoID",			string(m_MultiSellInfoList[SelectedIndex].MultiSellInfoID));
		ParamAdd(param, "ItemCount",				string(DialogGetReservedInt2()));
		ParamAdd(param, "Enchant",					string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.Enchanted));
		ParamAdd(param, "RefineryOp1",				string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp1));
		ParamAdd(param, "RefineryOp2",				string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp2));
		ParamAdd(param, "AttrAttackType",			string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeType));
		ParamAdd(param, "AttrAttackValue",			string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeValue));
		ParamAdd(param, "AttrDefenseValueFire",		string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueFire));
		ParamAdd(param, "AttrDefenseValueWater",	string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWater));
		ParamAdd(param, "AttrDefenseValueWind",		string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWind));
		ParamAdd(param, "AttrDefenseValueEarth",	string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueEarth));
		ParamAdd(param, "AttrDefenseValueHoly",		string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueHoly));
		ParamAdd(param, "AttrDefenseValueUnholy",	string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueUnholy));

		addParamEnsoulOptionInfo(m_MultiSellInfoList[SelectedIndex].ResultItemInfo, param);

		RequestMultiSellChoose(param);
	}
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_NewMultiSellInfoListBegin:
			//Debug("EV_NewMultiSellInfoListBegin: " @ param);
			HandleMultiSellInfoListBegin(param);
			break;
		case EV_NewMultiSellResultItemInfo:
			HandleMultiSellResultItemInfo(param);
			break;
		case EV_NewMultiSellOutputItemInfo:
			HandelMultiSellOutputItemInfo(param);
			break;
		case EV_NewMultiSellInputItemInfo:
			HandelMultiSellInputItemInfo(param);
			break;
		case EV_NewMultiSellInfoListEnd:
			HandleMultiSellInfoListEnd(param);
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
		case EV_AdenaInvenCount:
			if(Me.IsShowWindow())
			{
				needItemUpdate(lastSelectIndex);
			}
			break;
	}
}

/**
 * ?��?�� 받기 ?��?��.
 */
function HandleMultiSellInfoListBegin(string param)
{
	Clear();
	ParseInt(param, "MultiSellGroupID", m_MultiSellGroupID);
}

function HandleMultiSellResultItemInfo(string param)
{
	local int		nMultiSellInfoID;
	local int		nBuyType;
	local ItemInfo	Info;

	// ?���? 집혼 ?��?��
	local int       ensoulNormalSlot, ensoulBmSlot;

	//Debug("-----------------------------");
	//Debug( "HandleMultiSellResultItemInfo>>" $ param );

	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "BuyType", nBuyType);
	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);

	// ?���? 집혼 추�?? (2015-03-09)
	ParseInt(param, "EnsoulOptionNum_" $ EIST_BM, ensoulBmSlot);
	ParseInt(param, "EnsoulOptionNum_" $ EIST_NORMAL, ensoulNormalSlot);

	// ?��?��?��?�� 집혼 ?��보�?? ?��?�� ?��?��
	addEnsoulInfo(EIST_BM, ensoulBmSlot, param, Info);
	addEnsoulInfo(EIST_NORMAL, ensoulNormalSlot, param, Info);

	m_nCurrentMultiSellInfoIndex = m_MultiSellInfoList.Length;
	m_MultiSellInfoList.Length = m_nCurrentMultiSellInfoIndex + 1;

	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID = nMultiSellInfoID;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellType = nBuyType;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].ResultItemInfo = Info;
}

function HandelMultiSellOutputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentOutputItemInfoIndex;
	local ItemInfo Info;
	local int nItemClassID;
	local string Per;

	// ?���? 집혼 ?��?��
	local int ensoulNormalSlot, ensoulBmSlot;

	Debug("HandelMultiSellOutputItemInfo : " $ param);
	//Debug("-----------------------------");
	//Debug( "HandelMultiSellOutputItemInfo : " $ param );

	ParseItemID(param, Info.ID);
	class'UIDATA_ITEM'.static.GetItemInfo(Info.ID, Info);
	ParseInt(param, "ClassID", nItemClassID);
	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt64(param, "SlotBitType", Info.SlotBitType); // INT -> INT64, JEWEL 추�?? - by y2jinc (2013. 9. 2)
	ParseInt(param, "ItemType", Info.ItemType);

	// ?���? ?��?�� 그�??�? ?��?��.
	ParseInt64(param, "ItemCount", Info.ItemNum);

	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);

	// 추�??ttp 66923
	ParseInt(param, "Attribution", Info.Attribution);

	ParseString(param, "Probability", Per);

	// ?���? 집혼 추�?? (2015-03-09)
	ParseInt(param, "EnsoulOptionNum_" $ EIST_BM, ensoulBmSlot);
	ParseInt(param, "EnsoulOptionNum_" $ EIST_NORMAL, ensoulNormalSlot);

	// ?��?��?��?�� 집혼 ?��보�?? ?��?�� ?��?��
	addEnsoulInfo(EIST_BM, ensoulBmSlot, param, Info);
	addEnsoulInfo(EIST_NORMAL, ensoulNormalSlot, param, Info);

	if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
	{
		//debug("MultiSellWnd::HandelMultiSellOutputItemInfo - Invalid nMultiSellInfoID");
		return;
	}

	if(nItemClassID == MSIT_PVP_POINT)
	{
		Info.Name = GetSystemString(102);
		Info.IconName = "icon.pvp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}

	// ?��?��병기?�� 경우 강제�?, 100% Durability�? ?��?��?���? ?��?��?�� - NeverDie
	if(0 < Info.Durability)
	{
		Info.CurrentDurability = Info.Durability;
	}

	nCurrentOutputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].Per.Length = nCurrentOutputItemInfoIndex + 1;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].Per[nCurrentOutputItemInfoIndex] = Per;

	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].param.Length = nCurrentOutputItemInfoIndex + 1;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].param[nCurrentOutputItemInfoIndex] = param;

	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length = nCurrentOutputItemInfoIndex + 1;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex] = Info;
}

function HandelMultiSellInputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentInputItemInfoIndex, nItemClassID;
	local ItemInfo Info;

	// ?���? 집혼 ?��?��
	local int ensoulNormalSlot, ensoulBmSlot;

	// Debug(":::::::::::: HandelMultiSellInputItemInfo>>>" @ param);

	ParseItemID(param, Info.Id);
	class'UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);

	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "ClassID", nItemClassID);
	ParseInt(param, "ItemType", Info.ItemType);
	ParseInt64(param, "ItemCount", Info.ItemNum);
	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);

	// 추�??ttp 66923 
	ParseInt(param, "Attribution", Info.Attribution);

	// ?���? 집혼 추�?? (2015-03-09)
	ParseInt(param, "EnsoulOptionNum_" $ EIST_BM, ensoulBmSlot);
	ParseInt(param, "EnsoulOptionNum_" $ EIST_NORMAL, ensoulNormalSlot);

	//Debug("ensoulBmSlot" @ ensoulBmSlot);
	//Debug("ensoulBmSlot" @ ensoulNormalSlot);

	// ?��?��?��?�� 집혼 ?��보�?? ?��?�� ?��?��
	addEnsoulInfo(EIST_BM, ensoulBmSlot, param, Info);
	addEnsoulInfo(EIST_NORMAL, ensoulNormalSlot, param, Info);

	if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
	{
		//debug("MultiSellWnd::HandelMultiSellInputItemInfo - Invalid nMultiSellInfoID");
		return;
	}

	if(nItemClassID == MSIT_PCCAFE_POINT)
	{
		Info.Name = GetSystemString(1277);
		Info.IconName = GetPcCafeItemIconPackageName();//"icon.etc_i.etc_pccafe_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if(nItemClassID == MSIT_PLEDGE_POINT)
	{
		Info.Name = GetSystemString(1311);
		Info.IconName = "icon.etc_i.etc_bloodpledge_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if(nItemClassID == MSIT_PVP_POINT)
	{
		Info.Name = GetSystemString(102);
		Info.IconName = "icon.pvp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else
	{
		Info.Name = class'UIDATA_ITEM'.static.GetItemName(Info.Id);
		//if (Info.Enchanted > 0) Info.Name = "+" $ String(Info.Enchanted) @ GetEnsoulOptionNameAll(info);
		//else Info.Name = GetEnsoulOptionNameAll(Info);

		//Debug("GetEnsoulOptionNameAll(Info);" @ GetEnsoulOptionNameAll(Info));
		//Info.IconName = class'UIDATA_ITEM'.static.GetItemTextureName(Info.Id);
	}

	Info.ItemType = class'UIDATA_ITEM'.static.GetItemDataType(Info.Id);
	Info.CrystalType = class'UIDATA_ITEM'.static.GetItemCrystalType(Info.Id);

	//-400 ?��?��?��?��?��?�� 경우 ?���? ?��?��?��?�� ?��?��?���? ?��?��?�� ?��?���? 처리 ?��.
	if(nItemClassID != MSIT_FIELD_CYCLE_POINT)
	{
		nCurrentInputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length;
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length = nCurrentInputItemInfoIndex + 1;
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList[nCurrentInputItemInfoIndex] = Info;
	}
}

function HandleMultiSellInfoListEnd(string param)
{
	local WindowHandle m_inventoryWnd;

	//?��벤토�?
	m_inventoryWnd = GetWindowHandle("InventoryWnd");

	//?��벤토�? 창이 ?��?��?��?���? ?��?���??��.
	if(m_inventoryWnd.IsShowWindow())
	{
		m_inventoryWnd.HideWindow();
	}

	ShowWindow("TokenTradeWnd");
	class'UIAPI_WINDOW'.static.SetFocus("TokenTradeWnd");
	ShowItemList();
}

function ShowItemList()
{
	local ItemInfo Info, tempInfo;
	local int i;
	local string treeName;
	local bool bDrawBgTree;
	local string setTreeName, strRetName, itemAllName;
	local bool bIsSetLastIndex;

	bIsSetLastIndex = false;
	treeName = "TokenTradeWnd.ItemTypeTree";
	TreeClear(treeName);

	//Root ?��?�� ?��?��.
	util.TreeInsertRootNode(treeName, "Root", "", 0, 0);
	setTreeName = "Root";

	for(i=0; i < m_MultiSellInfoList.Length; i++)
	{
		Info = m_MultiSellInfoList[i].OutputItemInfoList[0];
		
		strRetName = util.TreeInsertItemTooltipSimpleNode(treeName, string(i), setTreeName, -7, 0, 38, 0, 30, 38);

		if(bDrawBgTree)
		{
			//Insert Node Item - ?��?��?�� 배경?
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.etc.textbackline", 245, 38, , , , , 14);
		}
		else
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", 245, 38);
		}
		bDrawBgTree = !bDrawBgTree;

		//Insert Node Item - ?��?��?��?���? 배경
		util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -244, 2);
		//Insert Node Item - ?��?��?�� ?��?���?
		util.TreeInsertTextureNodeItem(treeName, strRetName, Info.IconName, 32, 32, -34, 3);

		class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(Info.Id.ClassID), tempInfo);
		if(tempInfo.IconPanel != "")	
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, tempInfo.IconPanel, 32, 32, -34, 3);
		}

		// 강화 ?��?��
		if(Info.Enchanted > 0)
		{
			lvTextureTreeEnchantedTexture(treeName, strRetName, Info.Enchanted, -34, 27);
			// �? ?��?��즈에 맞게 조절
			util.TreeInsertTextMultiNodeItem(treeName, strRetName, "", 18, 0, 18, util.ETreeItemTextType.COLOR_DEFAULT);
		}

		if(Info.Enchanted > 0)
		{
			itemAllName = "+" $ string(Info.Enchanted) @ Info.Name @ Info.AdditionalName @ GetEnsoulOptionNameAll(Info);
		}
		else
		{
			itemAllName = Info.Name @ Info.AdditionalName @ GetEnsoulOptionNameAll(Info);
		}

		util.TreeInsertTextMultiNodeItem(treeName, strRetName, itemAllName, 4, 0, 38, util.ETreeItemTextType.COLOR_DEFAULT);

		//util.TreeInsertTextMultiNodeItem( TREENAME, strRetName, goodsName, 4, 0, 38, util.ETreeItemTextType.COLOR_DEFAULT );
		//Insert Node Item - ?��?��?�� ?���?
		//util.TreeInsertTextNodeItem( TREENAME, strRetName, info.AdditionalName, 5, 12, util.ETreeItemTextType.COLOR_YELLOW, true );		
		//util.TreeInsertTextMultiNodeItem( TREENAME, strRetName, info.AdditionalName, 5, 12, util.ETreeItemTextType.COLOR_YELLOW );		

		if(lastSelectNitemID == m_MultiSellInfoList[i].MultiSellInfoID)
		{
			if(bIsSetLastIndex == false)
			{
				bIsSetLastIndex = true;
				lastSelectIndex = i;
			}
		}
	}

	// ????��?�� ?��?���? 복원
	if(lastSelectNitemID > 0 && lastSelectIndex > 0)
	{
		ItemTypeTree.SetExpandedNode("Root." $ lastSelectIndex, true);

		Me.SetTimer(DelaySelectedTimerID, DelayTimer);
		// SelectChangeItem(selectIndex);
	}
	else if(m_MultiSellInfoList.Length > 0)
	{
		//처음�? ?��?��.
		ItemTypeTree.SetExpandedNode("Root.0", true);
		SelectChangeItem(0);
		ItemTypeTree.SetScrollPosition(0);
		// ItemTypeTree.SetToolt
    }
}

function OnTimer(int TimerID)
{
	if(TimerID == DelaySelectedTimerID)
	{
		SelectChangeItem(lastSelectIndex);
		Me.KillTimer(DelaySelectedTimerID);
	}
}

function SelectChangeItem(int Num)
{
	local ItemInfo Info;
	local LVDataRecord Record;
	local string strParam;
	local int i, ensoulBmSlot, ensoulNormalSlot;
	local string enchantedStr;

	Debug("lastSelectIndex" @ string(lastSelectIndex));
	TradePossibleListCtrl.DeleteAllItem();
	for(i=0; i < m_MultiSellInfoList[Num].OutputItemInfoList.Length; ++i)
	{
		Info = m_MultiSellInfoList[Num].OutputItemInfoList[i];

		if(Info.Enchanted <= 0)
		{
			enchantedStr = "";
		}
		else
		{
			enchantedStr = "+" $ string(Info.Enchanted) $ " ";
		}

		//Debug( "NEW???" $ param );
		//ParseString(param, "iconName", iconName);
		//ParseString(param, "name", itemName);
		
		//multisell 716
		strParam = m_MultiSellInfoList[Num].param[i];

		// Debug("------------------------------------------------------------------");
		// Debug(strParam);
		//무기?�� ?��?��
		ParamAdd(strParam, "name", Info.Name);
		ParamAdd(strParam, "WeaponType", string(Info.WeaponType));
		ParamAdd(strParam, "Enchanted", string(Info.Enchanted));
		ParamAdd(strParam, "Weight", string(Info.Weight));
		ParamAdd(strParam, "Description", Info.Description);
		ParamAdd(strParam, "IconName", Info.IconName);
		ParamAdd(strParam, "SoulshotCount", string(Info.SoulshotCount));
		ParamAdd(strParam, "SpiritshotCount", string(Info.SpiritshotCount));
		ParamAdd(strParam, "CrystalType", string(Info.CrystalType));
		ParamAdd(strParam, "AdditionalName", Info.AdditionalName);

		//branch121212
		ParamAdd(strParam, "pAttack", string(Info.pAttack));
		ParamAdd(strParam, "mAttack", string(Info.mAttack));

		ParamAdd(strParam, "pCriRate", string(Info.pCriRate));
		ParamAdd(strParam, "mCriRate", string(Info.mCriRate));
		//end of branch

		ParamAdd(strParam, "pAttackSpeed", string(Info.pAttackSpeed));
		ParamAdd(strParam, "mAttackSpeed", string(Info.mAttackSpeed));
		//ParamAdd(strParam, "PhysicalAttackSpeed", Info.PhysicalAttackSpeed);

		//debug(Info.Description);

		//방어구용 ?��?��
		ParamAdd(strParam, "pDefense", string(Info.pDefense));
		ParamAdd(strParam, "ShieldDefense", string(Info.ShieldDefense));
		ParamAdd(strParam, "pAvoid", string(Info.pAvoid));
		ParamAdd(strParam, "ArmorType", string(Info.ArmorType));

		// 마법 ????�� 추�??
		ParamAdd(strParam, "mDefense", string(Info.mDefense));

		// 추�??ttp 66923
		ParamAdd(strParam, "Attribution", string(Info.Attribution));

		// ?���? 집혼 추�?? (2015-03-09)
		ParseInt(strParam, "EnsoulOptionNum_" $ EIST_BM, ensoulBmSlot);
		ParseInt(strParam, "EnsoulOptionNum_" $ EIST_NORMAL, ensoulNormalSlot);

		// ?��?��?��?�� 집혼 ?��보�?? ?��?�� ?��?��
		addEnsoulInfo(EIST_BM, ensoulBmSlot, strParam, Info);
		addEnsoulInfo(EIST_NORMAL, ensoulNormalSlot, strParam, Info);

		// ?��?�� ?��?��?�� ?���? 리스?��?�� ?��?��?��꺼내?��?�� ?��?���? 기억
		Record.szReserved = strParam;

		// ?��코드 구성
		Record.LVDataList.length = 2;

		// ?��?��?�� ?���?
		if(Info.Enchanted > 0)
		{
			Record.LVDataList[0].szData = "+" $ string(Info.Enchanted) @ Info.Name @ Info.AdditionalName @ GetEnsoulOptionNameAll(Info);
		}
		else
		{
			Record.LVDataList[0].szData = Info.Name @ Info.AdditionalName @ GetEnsoulOptionNameAll(Info);
		}

		// Record.LVDataList[0].szData = enchantedStr $ Info.Name $ " " $ Info.AdditionalName;

		Record.LVDataList[0].hasIcon = true;
		Record.LVDataList[0].nTextureWidth = 32;
		Record.LVDataList[0].nTextureHeight = 32;
		Record.LVDataList[0].nTextureU = 32;
		Record.LVDataList[0].nTextureV = 32;
		Record.LVDataList[0].szTexture = Info.IconName;
		Record.LVDataList[0].IconPosX = 4;
		Record.LVDataList[0].FirstLineOffsetX = 6;

		// ?��?��
		Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
		Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
		Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
		Record.LVDataList[0].backTexWidth = 36;
		Record.LVDataList[0].backTexHeight = 36;
		Record.LVDataList[0].backTexUL = 36;
		Record.LVDataList[0].backTexVL = 36;

		Record.LVDataList[0].IconPanelName = Info.IconPanel;
		Record.LVDataList[0].panelOffsetXFromIconPosX=0;
		Record.LVDataList[0].panelOffsetYFromIconPosY=0;
		Record.LVDataList[0].panelWidth=32;
		Record.LVDataList[0].panelHeight=32;
		Record.LVDataList[0].panelUL=32;
		Record.LVDataList[0].panelVL=32;

		// 강화 ?��?��
		if(Info.Enchanted > 0)
		{
			Record.LVDataList[0].arrTexture.Length = 3;
			lvTextureAddItemEnchantedTexture(Info.Enchanted, Record.LVDataList[0].arrTexture[0], Record.LVDataList[0].arrTexture[1], Record.LVDataList[0].arrTexture[2], 9, 11);
		}

		Record.LVDataList[0].AttrColor.R = 200;
		Record.LVDataList[0].AttrColor.G = 200;
		Record.LVDataList[0].AttrColor.B = 200;
		Record.LVDataList[0].AttrStat[0] = "x" $ string(Info.ItemNum);

		Record.LVDataList[1].bUseTextColor = true;
		// End:0x775
		if(float(m_MultiSellInfoList[Num].Per[i]) > 30)
		{
			Record.LVDataList[1].TextColor = util.Token0;
		}
		else if(float(m_MultiSellInfoList[Num].Per[i]) <= 30 && float(m_MultiSellInfoList[Num].Per[i]) >= 11)
		{
			Record.LVDataList[1].TextColor = util.Token1;
		}
		else if(float(m_MultiSellInfoList[Num].Per[i]) <= 10 && float(m_MultiSellInfoList[Num].Per[i]) >= 5)
		{
			Record.LVDataList[1].TextColor = util.Token2;
		}
		else
		{
			Record.LVDataList[1].TextColor = util.Token3;
		}
		Record.LVDataList[1].szData = getInstanceL2Util().CutFloatIntByString(m_MultiSellInfoList[Num].Per[i]);
		Record.LVDataList[1].textAlignment = TA_Center;
		TradePossibleListCtrl.InsertRecord(Record);
	}

	needItemUpdate(Num);
}

function needItemUpdate(int Num)
{
	//?���? 배경?��.
	local bool bDrawBgTree;
	//Tree ?���?.
	local string treeName;

	local string setTreeName;
	local string strRetName;

	//보유 ?��?��?�� string
	local string strNeed;

	//?��?�� ?��?��?��.
	local ItemInfo infoNeed, tempInfo;
	local int i;

	lastSelectIndex = Num;

	treeName = "TokenTradeWnd.NeedItemTree";
	TreeClear(treeName);

	//Root ?��?�� ?��?��.
	util.TreeInsertRootNode(treeName, "Need", "", 0, 2);
	setTreeName = "Need";

	for(i=0; i < m_MultiSellInfoList[Num].InputItemInfoList.Length; i++)
	{
		infoNeed = m_MultiSellInfoList[Num].InputItemInfoList[i];

		strRetName = util.TreeInsertItemNode(treeName, string(i), setTreeName, false, -6, -2);//, 38, 0, 30, 38 );

		if(bDrawBgTree)
		{
			//Insert Node Item - ?��?��?�� 배경?
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.etc.textbackline", 545, 38, , , , , 14);
		}
		else
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", 545, 38);
		}
		bDrawBgTree = !bDrawBgTree;

		//Insert Node Item - ?��?��?��?���? 배경
		util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -538, 2);

		switch(infoNeed.Id.ClassID)
		{
			case 57:
				//?��?��?�� ?�� 경우
				//Insert Node Item - ?��?��?�� ?��?���?
				util.TreeInsertTextureNodeItem(treeName, strRetName, infoNeed.IconName, 32, 32, -34, 3);
				//Insert Node Item - ?��?��?�� ?���?
				//[??�스?�� ?��?��?�� ?��?�� 추�??] ??�스?�� ?��?��?��?�� ?��?��?�� ?��?��?���? ?��?�� item class id�? ????��.
				util.TreeInsertTextNodeItem(treeName, strRetName, infoNeed.Name, 5, 6, util.ETreeItemTextType.COLOR_DEFAULT, true);

				//?��?��?�� ?��
				//?��?��?�� 개수
				strNeed = "x" $ string(infoNeed.ItemNum) $ " / " $ GetSystemString(2035) $ " " $ GetInventoryItemCount(infoNeed.Id);
				util.TreeInsertTextNodeItem(treeName, strRetName, strNeed, 48, -18, util.ETreeItemTextType.COLOR_GRAY, , true);

				//미정
				/*
				if ( rewardNumList[i] == 0 )
					util.TreeInsertTextNodeItem(treeName, strRetName, GetSystemString(584), 48, -18, util.ETreeItemTextType.COLOR_GOLD, ,true );
				else 
					util.TreeInsertTextNodeItem(treeName, strRetName, MakeFullSystemMsg(GetSystemMessage(2932), string(rewardNumList[i]),""), 48, -18, util.ETreeItemTextType.COLOR_GOLD, , true );
				*/
				break;

			default:
				//Insert Node Item - ?��?��?�� ?��?���?
				util.TreeInsertTextureNodeItem(treeName, strRetName, infoNeed.IconName, 32, 32, -34, 3);

				class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(infoNeed.Id.ClassID), tempInfo);

				//Debug("tempInfo.IconPanel:" @ infoNeed.Id.ClassID);
				//Debug("tempInfo.IconPanel:" @ tempInfo.IconPanel);

				if(tempInfo.IconPanel != "")
				{
					util.TreeInsertTextureNodeItem(treeName, strRetName, tempInfo.IconPanel, 32, 32, -34, 3);
					//Debug("?��?�� ?��?�� :" @ tempInfo.IconPanel);
				}

				// 강화 ?��?��
				if(infoNeed.Enchanted > 0)
				{
					lvTextureTreeEnchantedTexture(treeName, strRetName, infoNeed.Enchanted, -34, 27);
					// �? ?��?��즈에 맞게 조절
					util.TreeInsertTextMultiNodeItem(treeName, strRetName, "", 18, 0, 18, util.ETreeItemTextType.COLOR_DEFAULT);
				}

				//Insert Node Item - ?��?��?�� ?���?
				//[??�스?�� ?��?��?�� ?��?�� 추�??] ??�스?�� ?��?��?��?�� ?��?��?�� ?��?��?���? ?��?�� item class id�? ????��.
				util.TreeInsertTextNodeItem(treeName, strRetName, infoNeed.Name @ infoNeed.AdditionalName, 5, 6, util.ETreeItemTextType.COLOR_DEFAULT, true, , infoNeed.Id.ClassID);

				//?��?��?�� 개수
				strNeed = "x" $ string(infoNeed.ItemNum) $ " / " $ GetSystemString(2035) $ " " $ GetInventoryItemCount(infoNeed.Id);
				util.TreeInsertTextNodeItem(treeName, strRetName, strNeed, 48, -18, util.ETreeItemTextType.COLOR_GRAY, , true);

				/*
				//미정
				if (rewardNumList[i] == 0)
					util.TreeInsertTextNodeItem( TREENAME, strRetName, GetSystemString(584), 48, -18, util.ETreeItemTextType.COLOR_GOLD, ,true );
				*/
		}
	}
}

// ?���? 비우�?
function TreeClear(string Str)
{
	class'UIAPI_TREECTRL'.static.Clear(Str);
}

/**
 * ?���?, �??��, ?��?��?��, ?��?���? ?��?�� 초기?��.
 */
function Clear()
{
	TreeClear("TokenTradeWnd.ItemTypeTree");
	TreeClear("TokenTradeWnd.NeedItemTree");
	//TreeClear("TokenTradeWnd.TradePossibleTree");
	TradePossibleListCtrl.DeleteAllItem();
	m_nCurrentMultiSellInfoIndex = 0;
	m_MultiSellInfoList.Length = 0;
	m_MultiSellGroupID = 0;

	//NeedItemIcon.SetTexture( "L2UI_CT1.Misc.Misc_DF_Blank" );
	//NeedItemNameText.SetText( "" );
	//NeedItemNumberText.SetText( "" );
}

// ?���? 집혼 �??�� ?��?��??? 추�??
function addEnsoulInfo(int slotType, int slotCount, string param, out ItemInfo Info)
{
	local int n, nEOptionID;

	for(n = EISI_START; n < slotCount + EISI_START; n++)
	{
		ParseInt(param, "EnsoulOptionID_" $ slotType $ "_" $ n, nEOptionID);

		Info.EnsoulOption[slotType - 1].OptionArray[n - EISI_START] = nEOptionID;
	}
}

/**
 * ?��?��?�� ESC ?���? ?���? 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	OnCancelBtnClick();
}

defaultproperties
{
}
