class WorldExchangeRegiWndItemHistoryTabWnd extends UICommonAPI;

const REFRESHLIMIT = 2000;

enum listType 
{
	Received,
	TimeOut,
	Normal
};

var array<UIPacket._WorldExchangeItemData> _itemDatas;
var L2UITimerObject tObject;
var RichListCtrlHandle ItemHistory_RichList;
var TextureHandle AddReward;
var INT64 nWEIndexRequested;
var int receivedNum;
var private bool b_DisableWindow;

function ReduceReceiveNum()
{
	receivedNum--;
	CheckNoticeWnd();
}

function CheckNoticeWnd()
{
	local NoticeWnd noticeWndScr;
	local string param;

	noticeWndScr = NoticeWnd(GetScript("NoticeWnd"));
	// End:0x39
	if(receivedNum < 1)
	{
		noticeWndScr._RemoveNoticButtonWorldExchangeBuy();		
	}
	else
	{
		ParamAdd(param, "rewardCount", string(receivedNum));
		noticeWndScr._CreateWorldExchangeBuyNotice(param);
	}
}

function SetRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_SETTLE_LIST));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT));
}

event OnLoad()
{
	SetClosingOnESC();
	tObject = class'L2UITimer'.static.Inst()._AddNewTimerObject(REFRESHLIMIT);
	tObject._DelegateOnEnd = SetEnableRefresh;
	ItemHistory_RichList = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemHistory_RichList");
	ItemHistory_RichList.SetSelectedSelTooltip(false);
	ItemHistory_RichList.SetAppearTooltipAtMouseX(true);
	SetRegisterEvent();
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_SETTLE_LIST):
			RT_S_EX_WORLD_EXCHANGE_SETTLE_LIST();
			// End:0x4A
			break;
		// End:0x47
		case EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT):
			RT_S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT();
			// End:0x4A
			break;
	}
}

event OnShow()
{
	// End:0x18
	if(b_DisableWindow)
	{
		tObject._Reset();
	}
	SetMyInfos();
}

function SetMyInfos()
{
	Debug("SetMyInfos");
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		// End:0x3C
		case "Refresh_Btn":
			HandleRefresh();
			// End:0x4D
			break;
		// End:0xFFFF
		default:
			ChckBtnName(strID);
			// End:0x4D
			break;
	}
}

function RQ_C_EX_WORLD_EXCHANGE_SETTLE_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_SETTLE_LIST packet;

	// End:0x20
	if(! class'UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_SETTLE_LIST(stream, packet))
	{
		return;
	}
	b_DisableWindow = true;
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLD_EXCHANGE_SETTLE_LIST, stream);
}

function RT_S_EX_WORLD_EXCHANGE_SETTLE_LIST()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_SETTLE_LIST packet;

	Debug("RT_S_EX_WORLD_EXCHANGE_SETTLE_LIST");
	// End:0x45
	if(! class'UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_SETTLE_LIST(packet))
	{
		return;
	}
	ItemHistory_RichList.DeleteAllItem();
	AddList(packet.vRecvItemDataList, listType.Received);
	AddList(packet.vTimeOutItemDataList, listType.TimeOut);
	AddList(packet.vRegiItemDataList, listType.Normal);
	receivedNum = packet.vRecvItemDataList.Length;
	CheckNoticeWnd();
	handleResult();
	b_DisableWindow = false;
}

function handleResult()
{
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".MyRegiItemNumTxt_Apply").SetText(string(_GetRegiItemCount()));
	AddReward = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AddReward");
	class'WorldExchangeRegiWnd'.static.Inst()._SetCurrentRigedItemNum(_GetRegiItemCount());
	// End:0xA5
	if(receivedNum == 0)
	{
		AddReward.HideWindow();		
	}
	else if(receivedNum < 10)
	{
		AddReward.SetTexture("L2UI_CT1.tab.TabNoticeCount_0" $ string(receivedNum));
		AddReward.ShowWindow();			
	}
	else if(receivedNum > 9)
	{
		AddReward.SetTexture("L2UI_CT1.tab.TabNoticeCount_09Plus");
		AddReward.ShowWindow();
	}
}

function int _GetRegiItemCount()
{
	return ItemHistory_RichList.GetRecordCount();
}

function AddList(array<UIPacket._WorldExchangeItemData> itemDatas, listType _listType)
{
	local int i;
	local RichListCtrlRowData RowData;

	// End:0x53 [Loop If]
	for(i = 0; i < itemDatas.Length; i++)
	{
		// End:0x63
		if(itemDatas[i].nItemClassID == 57)
		{
			// End:0x60
			if(MakeRowDataAdena(itemDatas[i], RowData, _listType))
			{
				ItemHistory_RichList.InsertRecord(RowData);
			}
			// [Explicit Continue]
			continue;
		}
		// End:0x95
		if(MakeRowData(itemDatas[i], RowData, _listType))
		{
			ItemHistory_RichList.InsertRecord(RowData);
		}
	}
}

function RQ_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT packet;

	Debug("RQ_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT" @ string(nWEIndexRequested));
	packet.nWEIndex = nWEIndexRequested;
	// End:0x6A
	if(! class'UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT, stream);
}

function RT_S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT packet;

	Debug("RT_S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT");
	// End:0x4C
	if(! class'UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT(packet))
	{
		return;
	}
	switch(packet.cSuccess)
	{
		// End:0x65
		case 1:
			HandleRecvResult();
			// End:0xB0
			break;
		// End:0x87
		case 0:
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13686));
			// End:0xB0
			break;
		// End:0xAD
		case -1:
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13687));
			// End:0xB0
			break;
	}
	GetWindowHandle("WorldExchangeRegiWnd.CancelSaleDialog_Wnd").HideWindow();
}

function HandleRecvResult()
{
	local int i;
	local RichListCtrlRowData RowData;

	i = GetRichListCtrlRowData(nWEIndexRequested, RowData);
	// End:0x23
	if(i < 0)
	{
		return;
	}
	switch(int(RowData.nReserved3))
	{
		// End:0x5C
		case 0:
			ReduceReceiveNum();
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13668));
			// End:0xA9
			break;
		// End:0x81
		case 1:
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13669));
			// End:0xA9
			break;
		// End:0xA6
		case 2:
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13670));
			// End:0xA9
			break;
		// End:0xFFFF
		default:
			break;
	}
	ItemHistory_RichList.DeleteRecord(i);
	handleResult();
}

function int GetRichListCtrlRowData(INT64 nWEIndex, out RichListCtrlRowData outRowData)
{
	local int i;

	i = GetListIndexWithnWEIndex(nWEIndex);
	ItemHistory_RichList.GetRec(i, outRowData);
	return i;
}

function SetDisablbRefresh()
{
	b_DisableWindow = true;
	class'WorldExchangeRegiWnd'.static.Inst()._ShowDisableWIndow();
	tObject._Reset();
}

function SetEnableRefresh()
{
	b_DisableWindow = false;
	class'WorldExchangeRegiWnd'.static.Inst()._HideDisableWindow();
}

function ChckBtnName(string btnName)
{
	local array<string> names;

	Split(btnName, "_", names);
	// End:0x36
	if(names[0] == "btnBuy")
	{
		SetShowBuyDialogWindow(int(names[1]));
	}
}

function SetShowBuyDialogWindow(int WEIndex)
{
	local RichListCtrlRowData RowData;
	local int listIndex;

	// End:0x26
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		return;
	}
	listIndex = GetListIndexWithnWEIndex(WEIndex);
	ItemHistory_RichList.GetRec(listIndex, RowData);
	nWEIndexRequested = WEIndex;
	switch(RowData.nReserved3)
	{
		// End:0x72
		case 0:
		// End:0x82
		case 1:
			RQ_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT();
			// End:0x9F
			break;
		// End:0x9C
		case 2:
			ShowDialog(RowData.szReserved);
			// End:0x9F
			break;
	}
}

function _RQ_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT()
{
	RQ_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT();
}

function ShowDialog(string itemReservedString)
{
	class'WorldExchangeRegiWnd'.static.Inst()._SetShowCancelDialog(itemReservedString);
}

function int GetListIndexWithnWEIndex(INT64 nWEIndex)
{
	local int i;
	local RichListCtrlRowData RowData;

	// End:0x5E [Loop If]
	for(i = 0; i < ItemHistory_RichList.GetRecordCount(); i++)
	{
		ItemHistory_RichList.GetRec(i, RowData);
		// End:0x54
		if(RowData.nReserved1 == nWEIndex)
		{
			return i;
		}
	}
	return -1;
}

function _Show()
{}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
}

function HandleRefresh()
{
	Debug(" Handle Refresh");
	SetDisablbRefresh();
	RQ_C_EX_WORLD_EXCHANGE_SETTLE_LIST();
}

function bool MakeRowDataAdena(UIPacket._WorldExchangeItemData _itemData, out RichListCtrlRowData outRowData, listType _listType)
{
	local RichListCtrlRowData RowData;
	local ItemInfo iInfo, iPriceInfo;
	local string strcom, itemParam;
	local int nWidth, nHeight, buttonW, RemainTime;
	local float unitPrice;

	RowData.cellDataList.Length = 6;
	// End:0x20
	if(_itemData.nItemClassID < 1)
	{
		return false;
	}
	// End:0x4B
	if(! class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(_itemData.nItemClassID), iInfo))
	{
		return false;
	}

	if (!class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(_itemData.nCurrencyId), iPriceInfo))
	{
		return false;
	}

	RowData.nReserved1 = _itemData.nWEIndex;
	RemainTime = (_itemData.nExpiredTime - class'UIData'.static.Inst().serverStartTime) - class'UIData'.static.Inst().GameConnectTimeSec();
	RowData.nReserved3 = int(_listType);
	iInfo = GetItemInfoByClassID(57);
	iInfo.ItemNum = _itemData.nAmount;
	iInfo.bShowCount = true;
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 8, 1);
	class'WorldExchangeBuyWnd'.static.Inst()._MakeAdenaitemInfo(iInfo);
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, class'WorldExchangeBuyWnd'.static.Inst().MakeAdenaStringNew(iInfo.ItemNum), GetNumericColor(string(iInfo.ItemNum)), false, 4, 9);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, "1", GTColor().White, false);
	switch(_listType)
	{
		// End:0x241
		case listType.Normal/*2*/:
			addRichListCtrlString(RowData.cellDataList[2].drawitems, class'L2Util'.static.Inst().getTimeStringBySec3(RemainTime), GTColor().White, false);
			// End:0x28D
			break;
		// End:0xFFFF
		default:
			addRichListCtrlString(RowData.cellDataList[2].drawitems, class'L2Util'.static.Inst().getTimeStringBySec3(RemainTime), GTColor().Red, false);
			// End:0x28D
			break;
			break;
	}
	iInfo.Price = _itemData.nPrice;
	strcom = MakeCostStringINT64(iInfo.Price);
	addRichListCtrlString(RowData.cellDataList[3].drawitems, iPriceInfo.Name, GetColor(147, 136, 112, 255), false, 18, 0);
	addRichListCtrlString(RowData.cellDataList[3].drawitems, strcom, GetNumericColor(strcom), false, 5, 0);
	buttonW = 110;
	switch(_listType)
	{
		// End:0x453
		case listType.Received/*0*/:
			addRichListCtrlButton(RowData.cellDataList[5].drawitems, "btnBuy_" $ string(_itemData.nWEIndex), 0, 0, "L2UI_NewTex.Button.SimpleBtnGreen_DF", "L2UI_NewTex.Button.SimpleBtnGreen_Down", "L2UI_NewTex.Button.SimpleBtnGreen_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(14068), nWidth, nHeight);
			addRichListCtrlString(RowData.cellDataList[5].drawitems, GetSystemString(14068), getInstanceL2Util().White, false, - buttonW + nWidth / 2, 8);
			// End:0x6A9
			break;
		// End:0x57B
		case listType.TimeOut/*1*/:
			addRichListCtrlButton(RowData.cellDataList[5].drawitems, "btnBuy_" $ string(_itemData.nWEIndex), 0, 0, "L2UI_NewTex.Button.SimpleBtnBlue_DF", "L2UI_NewTex.Button.SimpleBtnBlue_Down", "L2UI_NewTex.Button.SimpleBtnBlue_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(14069), nWidth, nHeight);
			addRichListCtrlString(RowData.cellDataList[5].drawitems, GetSystemString(14069), getInstanceL2Util().White, false, - buttonW + nWidth / 2, 8);
			// End:0x6A9
			break;
		// End:0x6A6
		case listType.Normal/*2*/:
			addRichListCtrlButton(RowData.cellDataList[5].drawitems, "btnBuy_" $ string(_itemData.nWEIndex), 0, 0, "L2UI_NewTex.Button.SimpleBtnBrown_DF", "L2UI_NewTex.Button.SimpleBtnBrown_Down", "L2UI_NewTex.Button.SimpleBtnBrown_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(2519), nWidth, nHeight);
			addRichListCtrlString(RowData.cellDataList[5].drawitems, GetSystemString(2519), getInstanceL2Util().White, false, - buttonW + nWidth / 2, 8);
			// End:0x6A9
			break;
		// End:0xFFFF
		default:
			break;
	}
	unitPrice = float(iInfo.Price) / (float(iInfo.ItemNum) / float(class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT));
	strcom = MakeCostStringINT64(iInfo.Price / (iInfo.ItemNum / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT));
	addRichListCtrlString(RowData.cellDataList[4].drawitems, "", GetColor(0, 0, 0, 0), false, 0, 0);
	addRichListCtrlString(RowData.cellDataList[4].drawitems, "." $ class'WorldExchangeBuyWnd'.static.Inst().GetDecimalNnmStr(unitPrice), GetColor(123, 123, 123, 255), false, 0, 1, "hs7");
	addRichListCtrlString(RowData.cellDataList[4].drawitems, strcom, GetNumericColor(strcom), false, 0, -2);
	addRichListCtrlButton(RowData.cellDataList[4].drawitems, "btnTooltipAdena", 3, -2, "L2UI_NewTex.Icon.ExclamationMark_s", "L2UI_NewTex.Icon.ExclamationMark_s", "L2UI_NewTex.Icon.ExclamationMark_s", 16, 16, 16, 16, int(_itemData.nWEIndex), "btnTooltipAdena");
	ItemInfoToParam(iInfo, itemParam);
	RowData.szReserved = itemParam;
	RowData.nReserved2 = iInfo.Price - (GetCommitionSell(iInfo.Price));
	outRowData = RowData;
	return true;	
}

function bool MakeRowData(UIPacket._WorldExchangeItemData _itemData, out RichListCtrlRowData outRowData, listType _listType)
{
	local RichListCtrlRowData RowData;
	local ItemInfo iInfo, iPriceInfo;
	local string strcom, itemParam;
	local int nWidth, nHeight, buttonW, RemainTime;
	local float unitPrice;

	RowData.cellDataList.Length = 6;
	// End:0x20
	if(_itemData.nItemClassID < 1)
	{
		return false;
	}
	// End:0x4B
	if(! class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(_itemData.nItemClassID), iInfo))
	{
		return false;
	}

	if (!class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(_itemData.nCurrencyId), iPriceInfo))
	{
		return false;
	}

	RowData.nReserved1 = _itemData.nWEIndex;
	RemainTime = (_itemData.nExpiredTime - class'UIData'.static.Inst().serverStartTime) - class'UIData'.static.Inst().GameConnectTimeSec();
	RowData.nReserved3 = int(_listType);
	iInfo.ItemNum = _itemData.nAmount;
	iInfo.bShowCount = IsStackableItem(iInfo.ConsumeType);
	iInfo.Enchanted = _itemData.nEnchant;
	iInfo.RefineryOp1 = _itemData.nVariationOpt1;
	iInfo.RefineryOp2 = _itemData.nVariationOpt2;
	iInfo.AttackAttributeType = _itemData.nBaseAttributeAttackType;
	iInfo.AttackAttributeValue = _itemData.nBaseAttributeAttackValue;
	iInfo.DefenseAttributeValueFire = _itemData.nBaseAttributeDefendValue[0];
	iInfo.DefenseAttributeValueWater = _itemData.nBaseAttributeDefendValue[1];
	iInfo.DefenseAttributeValueWind = _itemData.nBaseAttributeDefendValue[2];
	iInfo.DefenseAttributeValueEarth = _itemData.nBaseAttributeDefendValue[3];
	iInfo.DefenseAttributeValueHoly = _itemData.nBaseAttributeDefendValue[4];
	iInfo.DefenseAttributeValueUnholy = _itemData.nBaseAttributeDefendValue[5];
	iInfo.LookChangeItemID = _itemData.nShapeShiftingClassId;
	iInfo.LookChangeItemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(_itemData.nShapeShiftingClassId));
	// End:0x25C
	if(_itemData.nShapeShiftingClassId > 0)
	{
		iInfo.LookChangeIconPanel = "BranchSys3.Icon.pannel_lookChange";
	}
	iInfo.EnsoulOption[1 - 1].OptionArray[0] = _itemData.nEsoulOption[0];
	iInfo.EnsoulOption[1 - 1].OptionArray[1] = _itemData.nEsoulOption[1];
	iInfo.EnsoulOption[2 - 1].OptionArray[0] = _itemData.nEsoulOption[2];
	iInfo.IsBlessedItem = _itemData.nBlessOption == 1;
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 8, 1);
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), GTColor().White, false, 4, 7);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, string(_itemData.nAmount), GTColor().White, false);
	switch(_listType)
	{
		// End:0x3A3
		case listType.Normal/*2*/:
			addRichListCtrlString(RowData.cellDataList[2].drawitems, class'L2Util'.static.Inst().getTimeStringBySec3(RemainTime), GTColor().White, false);
			// End:0x3EF
			break;
		// End:0xFFFF
		default:
			addRichListCtrlString(RowData.cellDataList[2].drawitems, class'L2Util'.static.Inst().getTimeStringBySec3(RemainTime), GTColor().Red, false);
			// End:0x3EF
			break;
	}
	iInfo.Price = _itemData.nPrice;
	strcom = MakeCostStringINT64(iInfo.Price);
	addRichListCtrlString(RowData.cellDataList[3].drawitems, iPriceInfo.Name, GetColor(147, 136, 112, 255), false, 18, 0);
	addRichListCtrlString(RowData.cellDataList[3].drawitems, strcom, GetNumericColor(strcom), false, 5, 0);
	buttonW = 110;
	switch(_listType)
	{
		// End:0x61C
		case listType.Received/*0*/:
			addRichListCtrlButton(RowData.cellDataList[5].drawitems, "btnBuy_" $ string(_itemData.nWEIndex), 0, 0, "L2UI_NewTex.Button.SimpleBtnGreen_DF", "L2UI_NewTex.Button.SimpleBtnGreen_Down", "L2UI_NewTex.Button.SimpleBtnGreen_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(14068), nWidth, nHeight);
			addRichListCtrlString(RowData.cellDataList[5].drawitems, GetSystemString(14068), getInstanceL2Util().White, false, - buttonW + nWidth / 2, 8);
			// End:0x872
			break;
		// End:0x744
		case listType.TimeOut/*1*/:
			addRichListCtrlButton(RowData.cellDataList[5].drawitems, "btnBuy_" $ string(_itemData.nWEIndex), 0, 0, "L2UI_NewTex.Button.SimpleBtnBlue_DF", "L2UI_NewTex.Button.SimpleBtnBlue_Down", "L2UI_NewTex.Button.SimpleBtnBlue_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(14069), nWidth, nHeight);
			addRichListCtrlString(RowData.cellDataList[5].drawitems, GetSystemString(14069), getInstanceL2Util().White, false, - buttonW + nWidth / 2, 8);
			// End:0x872
			break;
		// End:0x86F
		case listType.Normal/*2*/:
			addRichListCtrlButton(RowData.cellDataList[5].drawitems, "btnBuy_" $ string(_itemData.nWEIndex), 0, 0, "L2UI_NewTex.Button.SimpleBtnBrown_DF", "L2UI_NewTex.Button.SimpleBtnBrown_Down", "L2UI_NewTex.Button.SimpleBtnBrown_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(2519), nWidth, nHeight);
			addRichListCtrlString(RowData.cellDataList[5].drawitems, GetSystemString(2519), getInstanceL2Util().White, false, - buttonW + nWidth / 2, 8);
			// End:0x872
			break;
	}
	unitPrice = float(iInfo.Price) / float(iInfo.ItemNum);
	strcom = MakeCostStringINT64(iInfo.Price / iInfo.ItemNum);
	addRichListCtrlString(RowData.cellDataList[4].drawitems, "", GetColor(0, 0, 0, 0), false, 0, 0);
	addRichListCtrlString(RowData.cellDataList[4].drawitems, "." $ class'WorldExchangeBuyWnd'.static.Inst().GetDecimalNnmStr(unitPrice), GetColor(123, 123, 123, 255), false, 0, 1, "hs7");
	addRichListCtrlString(RowData.cellDataList[4].drawitems, strcom, GetNumericColor(strcom), false, 0, -2);
	ItemInfoToParam(iInfo, itemParam);
	RowData.szReserved = itemParam;
	RowData.nReserved2 = iInfo.Price - (GetCommitionSell(iInfo.Price));
	outRowData = RowData;
	return true;
}

function INT64 GetCommitionSell(INT64 Cnt)
{
	local WorldExchangeUIData tmpWorldExchangeUIData;

	tmpWorldExchangeUIData = class'WorldExchangeRegiWnd'.static.Inst().API_GetWorldExchangeData();
	return Min(tmpWorldExchangeUIData.MaxSellFee, int(float(Cnt) * (float(tmpWorldExchangeUIData.SellFee) / float(100))));	
}

event OnReceivedCloseUI()
{
	class'WorldExchangeRegiWnd'.static.Inst()._Hide();
}

defaultproperties
{
}
