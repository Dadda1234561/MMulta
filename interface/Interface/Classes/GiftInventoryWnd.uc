class GiftInventoryWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle GiftInventoryConfirmWnd;
var TextureHandle Result_ItemWnd;
var TextBoxHandle ItemName_TextBox;
var TextBoxHandle Discription_TextBox;
var ButtonHandle OK_Button;
var ButtonHandle Cancel_Button;
var AnimTextureHandle RecieveBtnAni;
var TextureHandle GiftTabNew_tex;
var ButtonHandle HelpHtmlBtn;
var WindowHandle DisableWndList;
var TextBoxHandle GiftInventory_Empty;
var WindowHandle DisableWndAll;
var ButtonHandle ProductTab_Btn;
var ButtonHandle GiftTab_Btn;
var TextureHandle GiftInventory_Divider2;
var TextBoxHandle GiftItemListTitle;
var TextBoxHandle GiftItemListTotal;
var RichListCtrlHandle GiftItemList_Lc;
var TextBoxHandle GiftItemDetailInfoTitle;
var TextBoxHandle GiftBuyInfo;
var TextureHandle GiftItem_Msg;
var TextureHandle GiftItem;
var TextureHandle GiftItemSlotBg;
var TextBoxHandle GiftItemText;
var HtmlHandle GiftItemDiscription;
var TextBoxHandle GiftItemDetailListTitle;
var TextBoxHandle GiftItemDetailListCounter;
var TextBoxHandle GiftItemDesc_txt;
var RichListCtrlHandle GiftItemDetailListTitle_Lc;
var ButtonHandle RecieveBtn;
var ButtonHandle RefuseBtn;
var ButtonHandle CloseBtn;
var L2Util util;
var L2UITween l2UITweenScript;
var bool bReceiveAsk;
var int selectedProductListIndex;
var array<UIPacket._SGiftInfo> giftGoodsItemArray;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_GOODS_GIFT_LIST_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_GOODS_GIFT_ACCEPT_RESULT);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_GOODS_GIFT_REFUSE_RESULT);	
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();	
}

function Initialize()
{
	Me = GetWindowHandle("GiftInventoryWnd");
	GiftInventoryConfirmWnd = GetWindowHandle("GiftInventoryWnd.GiftInventoryConfirmWnd");
	Result_ItemWnd = GetTextureHandle("GiftInventoryWnd.GiftInventoryConfirmWnd.Result_ItemWnd");
	ItemName_TextBox = GetTextBoxHandle("GiftInventoryWnd.GiftInventoryConfirmWnd.ItemName_TextBox");
	Discription_TextBox = GetTextBoxHandle("GiftInventoryWnd.GiftInventoryConfirmWnd.Discription_TextBox");
	OK_Button = GetButtonHandle("GiftInventoryWnd.GiftInventoryConfirmWnd.OK_Button");
	Cancel_Button = GetButtonHandle("GiftInventoryWnd.GiftInventoryConfirmWnd.Cancel_Button");
	RecieveBtnAni = GetAnimTextureHandle("GiftInventoryWnd.RecieveBtnAni");
	GiftTabNew_tex = GetTextureHandle("GiftInventoryWnd.GiftTabNew_tex");
	HelpHtmlBtn = GetButtonHandle("GiftInventoryWnd.HelpHtmlBtn");
	DisableWndList = GetWindowHandle("GiftInventoryWnd.DisableWndList");
	GiftInventory_Empty = GetTextBoxHandle("GiftInventoryWnd.DisableWndList.GiftInventory_Empty");
	DisableWndAll = GetWindowHandle("GiftInventoryWnd.DisableWndAll");
	ProductTab_Btn = GetButtonHandle("GiftInventoryWnd.ProductTab_Btn");
	GiftTab_Btn = GetButtonHandle("GiftInventoryWnd.GiftTab_Btn");
	GiftItemListTitle = GetTextBoxHandle("GiftInventoryWnd.GiftItemListTitle");
	GiftItemListTotal = GetTextBoxHandle("GiftInventoryWnd.GiftItemListTotal");
	GiftItemList_Lc = GetRichListCtrlHandle("GiftInventoryWnd.GiftItemList_Lc");
	GiftItemDetailInfoTitle = GetTextBoxHandle("GiftInventoryWnd.GiftItemDetailInfoTitle");
	GiftBuyInfo = GetTextBoxHandle("GiftInventoryWnd.GiftBuyInfo");
	GiftItem_Msg = GetTextureHandle("GiftInventoryWnd.GiftItem_Msg");
	GiftItem = GetTextureHandle("GiftInventoryWnd.GiftItem");
	GiftItemText = GetTextBoxHandle("GiftInventoryWnd.GiftItemText");
	GiftItemDiscription = GetHtmlHandle("GiftInventoryWnd.GiftItemDiscription");
	GiftItemDetailListTitle = GetTextBoxHandle("GiftInventoryWnd.GiftItemDetailListTitle");
	GiftItemDetailListCounter = GetTextBoxHandle("GiftInventoryWnd.GiftItemDetailListCounter");
	GiftItemDesc_txt = GetTextBoxHandle("GiftInventoryWnd.GiftItemDesc_txt");
	GiftItemDetailListTitle_Lc = GetRichListCtrlHandle("GiftInventoryWnd.GiftItemDetailListTitle_Lc");
	RecieveBtn = GetButtonHandle("GiftInventoryWnd.RecieveBtn");
	RefuseBtn = GetButtonHandle("GiftInventoryWnd.RefuseBtn");
	CloseBtn = GetButtonHandle("GiftInventoryWnd.CloseBtn");	
}

function Load()
{
	util = L2Util(GetScript("L2Util"));
	l2UITweenScript = L2UITween(GetScript("l2UITween"));
	GiftItemList_Lc.SetSelectedSelTooltip(false);
	GiftItemList_Lc.SetAppearTooltipAtMouseX(true);
	GiftItemDetailListTitle_Lc.SetSelectedSelTooltip(false);
	GiftItemDetailListTitle_Lc.SetAppearTooltipAtMouseX(true);
	selectedProductListIndex = -1;	
}

function Refresh()
{
	GiftTabNew_tex.HideWindow();
	setItemDesc(0, "", "");
	GiftItemList_Lc.DeleteAllItem();
	GiftItemDetailListTitle_Lc.DeleteAllItem();
	askRecieve(false);
	askConfirm(false);
	API_C_EX_GOODS_GIFT_LIST_INFO();	
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	Refresh();	
}

function OnHide()
{
	askRecieve(false);
	askConfirm(false);
	selectedProductListIndex = -1;	
}

function OnClickListCtrlRecord(string strID)
{
	local int idx, i, Size, nClassID, nCount;

	local RichListCtrlRowData RowData;

	// End:0x154
	if(strID == "GiftItemList_Lc")
	{
		idx = GiftItemList_Lc.GetSelectedIndex();
		GiftItemList_Lc.GetRec(idx, RowData);
		setItemDesc(int(RowData.nReserved2), RowData.cellDataList[1].HiddenStringForSorting, RowData.cellDataList[1].szReserved);
		ParseInt(RowData.szReserved, "size", Size);
		GiftItemDetailListTitle_Lc.DeleteAllItem();

		// End:0x142 [Loop If]
		for(i = 0; i < Size; i++)
		{
			ParseInt(RowData.szReserved, "nClassId_" $ string(i), nClassID);
			ParseInt(RowData.szReserved, "nCount_" $ string(i), nCount);
			addProductBoxInsideItemList(GetItemID(nClassID), GetItemInfoByClassID(nClassID).Name, nClassID, nCount);
		}
		selectedProductListIndex = idx;
		askRecieve(true);
	}	
}

function askRecieve(bool bShow)
{
	local int idx;

	// End:0x7A
	if(bShow)
	{
		idx = GiftItemList_Lc.GetSelectedIndex();
		// End:0x4A
		if(idx <= -1)
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(326));
			return;
		}
		GiftItemDesc_txt.ShowWindow();
		RecieveBtn.ShowWindow();
		RefuseBtn.ShowWindow();		
	}
	else
	{
		GiftItemDesc_txt.HideWindow();
		RecieveBtn.HideWindow();
		RefuseBtn.HideWindow();
		RecieveBtnAni.HideWindow();
	}	
}

function askConfirm(bool bShow, optional bool bReceive)
{
	local RichListCtrlRowData RowData;
	local int idx;

	// End:0x12B
	if(bShow)
	{
		idx = GiftItemList_Lc.GetSelectedIndex();
		// End:0x4A
		if(idx <= -1)
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(326));
			return;
		}
		DisableWndAll.ShowWindow();
		DisableWndAll.SetFocus();
		GiftInventoryConfirmWnd.ShowWindow();
		GiftInventoryConfirmWnd.SetFocus();
		bReceiveAsk = bReceive;
		// End:0xB9
		if(bReceive)
		{
			Discription_TextBox.SetText(GetSystemMessage(13732));			
		}
		else
		{
			Discription_TextBox.SetText(GetSystemMessage(13733));
		}
		GiftItemList_Lc.GetSelectedRec(RowData);
		ItemName_TextBox.SetText(RowData.cellDataList[1].HiddenStringForSorting);
		Result_ItemWnd.SetTexture(GetGoodsIconName(int(RowData.nReserved2)));		
	}
	else
	{
		DisableWndAll.HideWindow();
		GiftInventoryConfirmWnd.HideWindow();
	}	
}

function setItemDesc(int goodsIconID, string goodsName, string goodsDesc)
{
	// End:0x1F
	if(goodsIconID == 0)
	{
		GiftItem.SetTexture("");		
	}
	else
	{
		GiftItem.SetTexture(GetGoodsIconName(goodsIconID));
	}
	GiftItemText.SetText(goodsName);
	GiftItemDiscription.LoadHtmlFromString(htmlSetHtmlStart(htmlAddText(goodsDesc, "GameDefault", "afb9cd")));	
}

function addProductItemList(int nPurchaseId, int nCount, int nIconId, string giftName, string senderName, string giftDesc, int nRemainTimeSec, string itemListParam)
{
	local RichListCtrlRowData RowData;

	RowData.cellDataList.Length = 3;
	addRichListCtrlString(RowData.cellDataList[0].drawitems, senderName, GTColor().White, false, 2, 4);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, giftName $ " (" $ string(nCount) $ ")", GTColor().White, false, 2, 4);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, util.getTimeStringBySec3(nRemainTimeSec), GTColor().White, false, 0, 4);
	RowData.cellDataList[0].HiddenStringForSorting = senderName;
	RowData.cellDataList[1].HiddenStringForSorting = giftName;
	RowData.cellDataList[2].HiddenStringForSorting = util.makeZeroString(10, nRemainTimeSec);
	RowData.cellDataList[1].szReserved = giftDesc;
	RowData.szReserved = itemListParam;
	RowData.nReserved1 = nPurchaseId;
	RowData.nReserved2 = nIconId;
	GiftItemList_Lc.InsertRecord(RowData);	
}

function addProductBoxInsideItemList(ItemID cID, string goodsName, int gameItemClassID, int ItemNum)
{
	local RichListCtrlRowData RowData;
	local ItemInfo tmItemInfo;

	RowData.cellDataList.Length = 1;
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, class'UIDATA_ITEM'.static.GetItemTextureName(cID), 32, 32, 5);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, goodsName $ " (" $ string(ItemNum) $ ")", GTColor().White, false, 5, 10);
	tmItemInfo = GetItemInfoByClassID(gameItemClassID);
	// End:0xB0
	if(ItemNum > 0)
	{
		tmItemInfo.ItemNum = ItemNum;
	}
	ItemInfoToParam(tmItemInfo, RowData.szReserved);
	GiftItemDetailListTitle_Lc.InsertRecord(RowData);	
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x1E
		case "OK_Button":
			OnOK_ButtonClick();
			// End:0x9D
			break;
		// End:0x39
		case "Cancel_Button":
			OnCancel_ButtonClick();
			// End:0x9D
			break;
		// End:0x55
		case "ProductTab_Btn":
			OnProductTab_BtnClick();
			// End:0x9D
			break;
		// End:0x6D
		case "RecieveBtn":
			OnRecieveBtnClick();
			// End:0x9D
			break;
		// End:0x84
		case "RefuseBtn":
			OnRefuseBtnClick();
			// End:0x9D
			break;
		// End:0x9A
		case "CloseBtn":
			OnCloseBtnClick();
			// End:0x9D
			break;
	}	
}

function OnOK_ButtonClick()
{
	local RichListCtrlRowData RowData;

	GiftItemList_Lc.GetSelectedRec(RowData);
	// End:0x32
	if(bReceiveAsk)
	{
		API_C_EX_GOODS_GIFT_ACCEPT(int(RowData.nReserved1));		
	}
	else
	{
		API_C_EX_GOODS_GIFT_REFUSET(int(RowData.nReserved1));
	}
	askConfirm(false);	
}

function OnCancel_ButtonClick()
{
	askConfirm(false);	
}

function OnProductTab_BtnClick()
{
	Me.HideWindow();
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "ProductInventoryWnd");
	ShowWindow("ProductInventoryWnd");	
}

function OnRecieveBtnClick()
{
	askConfirm(true, true);	
}

function OnRefuseBtnClick()
{
	askConfirm(true, false);	
}

function OnCloseBtnClick()
{
	Me.HideWindow();	
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_GOODS_GIFT_LIST_INFO):
			ParsePacket_S_EX_GOODS_GIFT_LIST_INFO();
			// End:0x6A
			break;
		// End:0x47
		case EV_PacketID(class'UIPacket'.const.S_EX_GOODS_GIFT_ACCEPT_RESULT):
			ParsePacket_S_EX_GOODS_GIFT_ACCEPT_RESULT();
			// End:0x6A
			break;
		// End:0x67
		case EV_PacketID(class'UIPacket'.const.S_EX_GOODS_GIFT_REFUSE_RESULT):
			ParsePacket_S_EX_GOODS_GIFT_REFUSE_RESULT();
			// End:0x6A
			break;
	}	
}

function ParsePacket_S_EX_GOODS_GIFT_LIST_INFO()
{
	local UIPacket._S_EX_GOODS_GIFT_LIST_INFO packet;
	local int i, N;
	local string itemListParam;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_GOODS_GIFT_LIST_INFO(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_GOODS_GIFT_LIST_INFO :  ");
	Debug("packet.nTotalPage" @ string(packet.nTotalPage));
	Debug("packet.nCurrentPage" @ string(packet.nCurrentPage));
	Debug("packet.giftList.length" @ string(packet.giftList.Length));
	Debug("packet.cResult" @ string(packet.cResult));
	// End:0x142
	if(packet.cResult == 1 || packet.cResult == 2)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(184));
		AddSystemMessage(184);
		Me.HideWindow();
		return;
	}
	// End:0x169
	if(packet.nCurrentPage == 1)
	{
		GiftItemList_Lc.DeleteAllItem();
		giftGoodsItemArray.Length = 0;
	}
	// End:0x23D
	if(packet.giftList.Length == 0 && packet.nTotalPage == 1 && packet.nCurrentPage == 1)
	{
		DisableWndList.ShowWindow();
		DisableWndList.SetFocus();
		setItemDesc(0, "", "");
		GiftItemListTotal.SetText(GetSystemString(2512) $ " : " $ string(GiftItemList_Lc.GetRecordCount()));
		GiftItemDetailListTitle_Lc.DeleteAllItem();
		askConfirm(false);
		askRecieve(false);
		NoticeWnd(GetScript("NoticeWnd"))._RemoveNoticButtonGift();
		return;		
	}
	else
	{
		DisableWndList.HideWindow();
	}

	// End:0x28F [Loop If]
	for(i = 0; i < packet.giftList.Length; i++)
	{
		giftGoodsItemArray[giftGoodsItemArray.Length] = packet.giftList[i];
	}
	// End:0x4BC
	if(packet.nTotalPage == packet.nCurrentPage)
	{
		// End:0x412 [Loop If]
		for(i = 0; i < giftGoodsItemArray.Length; i++)
		{
			itemListParam = "";
			ParamAdd(itemListParam, "size", string(giftGoodsItemArray[i].ItemList.Length));

			// End:0x38D [Loop If]
			for(N = 0; N < giftGoodsItemArray[i].ItemList.Length; N++)
			{
				ParamAdd(itemListParam, "nClassId_" $ string(N), string(giftGoodsItemArray[i].ItemList[N].nClassID));
				ParamAdd(itemListParam, "nCount_" $ string(N), string(giftGoodsItemArray[i].ItemList[N].nCount));
			}
			addProductItemList(giftGoodsItemArray[i].nPurchaseId, giftGoodsItemArray[i].nCount, giftGoodsItemArray[i].nIconId, giftGoodsItemArray[i].wstrGiftName, giftGoodsItemArray[i].wstrSenderName, giftGoodsItemArray[i].wstrGiftDesc, giftGoodsItemArray[i].nRemainTimeSec, itemListParam);
		}
		// End:0x42B
		if(selectedProductListIndex == -1)
		{
			selectedProductListIndex = 0;			
		}
		else
		{
			// End:0x45C
			if(selectedProductListIndex >= GiftItemList_Lc.GetRecordCount())
			{
				selectedProductListIndex = GiftItemList_Lc.GetRecordCount() - 1;
			}
		}
		GiftItemList_Lc.SetSelectedIndex(selectedProductListIndex, true);
		OnClickListCtrlRecord("GiftItemList_Lc");
		GiftItemListTotal.SetText(GetSystemString(2512) $ " : " $ string(GiftItemList_Lc.GetRecordCount()));
	}	
}

delegate int SortByRemainTimeSec(UIPacket._SGiftInfo a1, UIPacket._SGiftInfo a2)
{
	// End:0x1F
	if(a1.nRemainTimeSec < a2.nRemainTimeSec)
	{
		return -1;
	}
	return 0;	
}

function ParsePacket_S_EX_GOODS_GIFT_ACCEPT_RESULT()
{
	local UIPacket._S_EX_GOODS_GIFT_ACCEPT_RESULT packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_GOODS_GIFT_ACCEPT_RESULT(packet))
	{
		return;
	}
	Debug("--> ParsePacket_S_EX_GOODS_GIFT_ACCEPT_RESULT");
	Debug("packet.nPurchaseId" @ string(packet.nPurchaseId));
	Debug("packet.bSuccess" @ string(packet.bSuccess));
	// End:0x10C
	if(packet.bSuccess > 0)
	{
		GiftTabNew_tex.ShowWindow();
		l2UITweenScript.StartShake("GiftInventoryWnd.GiftTabNew_tex", 6, 1500, l2uiTweenScript.directionType.small, 0);
		AddSystemMessage(13746);
	}
	API_C_EX_GOODS_GIFT_LIST_INFO();	
}

function ParsePacket_S_EX_GOODS_GIFT_REFUSE_RESULT()
{
	local UIPacket._S_EX_GOODS_GIFT_REFUSE_RESULT packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_GOODS_GIFT_REFUSE_RESULT(packet))
	{
		return;
	}
	Debug("--> ParsePacket_S_EX_GOODS_GIFT_REFUSE_RESULT");
	Debug("packet.bSuccess" @ string(packet.bSuccess));
	Debug("packet.nPurchaseId" @ string(packet.nPurchaseId));
	// End:0xBA
	if(packet.bSuccess > 0)
	{
		AddSystemMessage(13734);
	}
	API_C_EX_GOODS_GIFT_LIST_INFO();	
}

function API_C_EX_GOODS_GIFT_LIST_INFO()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_GOODS_GIFT_LIST_INFO, stream);
	Debug("API Call --> C_EX_GOODS_GIFT_LIST_INFO");	
}

function API_C_EX_GOODS_GIFT_ACCEPT(int nPurchaseId)
{
	local array<byte> stream;
	local UIPacket._C_EX_GOODS_GIFT_ACCEPT packet;

	packet.nPurchaseId = nPurchaseId;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_GOODS_GIFT_ACCEPT(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_GOODS_GIFT_ACCEPT, stream);
	Debug("API Call --> C_EX_GOODS_GIFT_ACCEPT " @ string(nPurchaseId));	
}

function API_C_EX_GOODS_GIFT_REFUSET(int nPurchaseId)
{
	local array<byte> stream;
	local UIPacket._C_EX_GOODS_GIFT_REFUSE packet;

	packet.nPurchaseId = nPurchaseId;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_GOODS_GIFT_REFUSE(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_GOODS_GIFT_REFUSE, stream);
	Debug("API Call --> C_EX_GOODS_GIFT_REFUSE " @ string(nPurchaseId));	
}

function OnReceivedCloseUI()
{
	// End:0x1C
	if(GiftInventoryConfirmWnd.IsShowWindow())
	{
		askConfirm(false);		
	}
	else
	{
		closeUI();
	}	
}

defaultproperties
{
}
