class DethroneShopWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle UIControlDialogAsset;
var WindowHandle inputItemWnd;
var WindowHandle BuyItemRichListCtrl;
var RichListCtrlHandle NeedItemRichListCtrl;
var RichListCtrlHandle Shop_RichListCtrl;
var WindowHandle disableWnd;
var string m_WindowName;
var UIControlDialogAssets popupExpandScript;
var UIControlNumberInput inputItemScript;
var UIControlNeedItemList needItemScript;
var ButtonHandle Buy_Button;
var L2Util util;
var int selectnSlotNum;
var int selectIndex;
var INT64 CurrentSP;
var INT64 currentDP;
var array<DethroneShopUIData> shopDataArray;
var int tryBuyID;
var INT64 tryBuyAmount;
var int spIndex;
var int dpIndex;
var L2UITimerObject delayTimeObject;

function OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_SHOP_BUY));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_POINT_INFO));
	RegisterEvent(EV_UpdateUserInfo);	
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();	
}

function SetPopupScript()
{
	local WindowHandle poopExpandWnd, disableWnd;

	poopExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	popupExpandScript = class'UIControlDialogAssets'.static.InitScript(poopExpandWnd);
	popupExpandScript.DelegateOnCancel = OnClickPopupCancel;
	popupExpandScript.DelegateOnClickBuy = OnClickPopupBuy;
	popupExpandScript.SetUseBuyItem(true);
	popupExpandScript.SetUseNeedItem(false);
	popupExpandScript.SetUseNumberInput(false);
	disableWnd = GetWindowHandle(m_WindowName $ ".DisableWnd");
	popupExpandScript.SetDisableWindow(disableWnd);
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop(m_WindowName $ ".DisableWnd", false);	
}

function OnClickPopupBuy()
{
	API_C_EX_DETHRONE_SHOP_BUY(tryBuyID, tryBuyAmount);
	GetPopupExpandScript().Hide();
	showDisable(false);	
}

function OnClickPopupCancel()
{
	GetPopupExpandScript().Hide();
	showDisable(false);	
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	return UIControlDialogAssets(popExpandWnd.GetScript());	
}

function InitNeedItem()
{
	BuyItemRichListCtrl.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(BuyItemRichListCtrl.GetScript());
	needItemScript.SetRichListControler(NeedItemRichListCtrl);
	needItemScript.DelegateOnUpdateItem = DelegateOnUpdateItem;	
}

function DelegateOnUpdateItem()
{
	inputItemScript.SetControlerBtns();
	// End:0x63
	if(needItemScript.GetMaxNumCanBuy() > 0)
	{
		// End:0x51
		if(inputItemScript.GetCount() > 0)
		{
			Buy_Button.EnableWindow();			
		}
		else
		{
			Buy_Button.DisableWindow();
		}		
	}
	else
	{
		Buy_Button.DisableWindow();
	}	
}

function InitInputControl()
{
	inputItemWnd.SetScript("UIControlNumberInput");
	inputItemScript = UIControlNumberInput(inputItemWnd.GetScript());
	inputItemScript.Init(m_WindowName $ ".ShopItemInfoWnd.inputItemWnd");
	inputItemScript.DelegateGetCountCanBuy = MaxNumCanBuy;
	inputItemScript.DelegateOnItemCountEdited = OnItemCountChanged;
	inputItemScript.DelegateESCKey = OnESCKey;
	inputItemScript.Reset_Btn = GetButtonHandle(m_WindowName $ ".ShopItemInfoWnd.inputItemWnd.Reset_Btn");
	inputItemScript.Buy_Btn = GetButtonHandle(m_WindowName $ ".ShopItemInfoWnd.Buy_Button");	
}

function INT64 MaxNumCanBuy()
{
	local RichListCtrlRowData RowData;
	local int Index;
	local INT64 Count;
	local ItemInfo Info;

	Index = Shop_RichListCtrl.GetSelectedIndex();
	Shop_RichListCtrl.GetRec(Index, RowData);
	Info = GetItemInfoByClassID(int(RowData.nReserved1));
	// End:0x7C
	if(IsStackableItem(Info.ConsumeType))
	{
		Count = Min(int(needItemScript.GetMaxNumCanBuy()), 9999);		
	}
	else
	{
		Count = needItemScript.GetMaxNumCanBuy();
	}
	return Count;	
}

function OnItemCountChanged(INT64 ItemCount)
{
	ItemCount = MAX64(1, ItemCount);
	needItemScript.SetBuyNum(ItemCount);	
}

event OnShow()
{
	local int i;

	API_C_EX_DETHRONE_SHOP_OPEN_UI();
	shopDataArray.Length = 0;
	class'UIDataManager'.static.GetDethroneShopDataList(shopDataArray);
	showDisable(false);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	Shop_RichListCtrl.DeleteAllItem();

	// End:0xC1 [Loop If]
	for(i = 0; i < shopDataArray.Length; i++)
	{
		Shop_RichListCtrl.InsertRecord(makeRecord(shopDataArray[i].item.ItemClassID, shopDataArray[i].item.ItemAmount, shopDataArray[i].Id));
	}
	spIndex = -1;
	dpIndex = -1;
	Shop_RichListCtrl.SetSelectedIndex(0, true);
	class'L2UITimer'.static.Inst()._AddTimer(100)._DelegateOnTime = OnTime;	
}

function OnTime(int Count)
{
	ClickRecord();	
}

event OnHide()
{
	needItemScript.CleariObjects();
	class'UIAPI_MULTISELLITEMINFO'.static.Clear("DethroneShopWnd.multiSellItemInfo");	
}

function int getNeedItemsIndexByID(int Id)
{
	local int i;

	// End:0x41 [Loop If]
	for(i = 0; i < shopDataArray.Length; i++)
	{
		// End:0x37
		if(shopDataArray[i].Id == Id)
		{
			return i;
		}
	}
	return -1;	
}

function RichListCtrlRowData makeRecord(int nItemClassID, int nItemAmount, int Id)
{
	local RichListCtrlRowData Record;
	local ItemInfo iInfo;
	local string toolTipParam;

	Record.cellDataList.Length = 1;
	iInfo = GetItemInfoByClassID(nItemClassID);
	iInfo.ItemNum = nItemAmount;
	ItemInfoToParam(iInfo, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.nReserved1 = iInfo.Id.ClassID;
	Record.nReserved2 = iInfo.ItemNum;
	Record.nReserved3 = Id;
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, iInfo, 32, 32, 4, 6);
	addRichListCtrlString(Record.cellDataList[0].drawitems, GetItemNameAllByClassID(iInfo.Id.ClassID), GTColor().White, false, 4, 9);
	addRichListCtrlString(Record.cellDataList[0].drawitems, " x" $ string(iInfo.ItemNum), GTColor().Gold, false, 0, 0);
	return Record;	
}

function Initialize()
{
	Me = GetWindowHandle(m_WindowName);
	UIControlDialogAsset = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	inputItemWnd = GetWindowHandle(m_WindowName $ ".ShopItemInfoWnd.inputItemWnd");
	BuyItemRichListCtrl = GetWindowHandle(m_WindowName $ ".ShopItemInfoWnd.BuyItemRichListCtrl");
	NeedItemRichListCtrl = GetRichListCtrlHandle(m_WindowName $ ".ShopItemInfoWnd.BuyItemRichListCtrl.NeedItemRichListCtrl");
	Shop_RichListCtrl = GetRichListCtrlHandle(m_WindowName $ ".ShopListWnd.Shop_RichListCtrl");
	disableWnd = GetWindowHandle(m_WindowName $ ".DisableWnd");
	Buy_Button = GetButtonHandle(m_WindowName $ ".ShopItemInfoWnd.Buy_Button");
	util = L2Util(GetScript("L2Util"));
	Shop_RichListCtrl.SetSelectedSelTooltip(false);
	Shop_RichListCtrl.SetAppearTooltipAtMouseX(true);
	selectIndex = 0;
	SetPopupScript();
	InitNeedItem();
	InitInputControl();
	delayTimeObject = class'L2UITimer'.static.Inst()._AddNewTimerObject(1, 1);
	delayTimeObject._DelegateOnTime = delayAutoCall;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x15
		case EV_UpdateUserInfo:
			HandleUpdateUserInfo();
			// End:0x58
			break;
		// End:0x35
		case EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_SHOP_BUY):
			HandleS_EX_DETHRONE_SHOP_BUY();
			// End:0x58
			break;
		// End:0x55
		case EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_POINT_INFO):
			HandleS_EX_DETHRONE_POINT_INFO();
			// End:0x58
			break;
	}	
}

function HandleUpdateUserInfo()
{
	local UserInfo UserInfo;

	// End:0x84
	if(Me.IsShowWindow())
	{
		GetPlayerInfo(UserInfo);
		CurrentSP = UserInfo.nSP;
		// End:0x84
		if(Me.IsShowWindow())
		{
			// End:0x84
			if((NeedItemRichListCtrl.GetRecordCount() > 0) && spIndex > -1)
			{
				needItemScript.ModifyCurrentAmount(spIndex, CurrentSP);
				DelegateOnUpdateItem();
			}
		}
	}	
}

function HandleS_EX_DETHRONE_SHOP_BUY()
{
	local UIPacket._S_EX_DETHRONE_SHOP_BUY packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_SHOP_BUY(packet))
	{
		return;
	}
	Debug("packet.bSuccess" @ string(packet.bSuccess));
	// End:0x70
	if(packet.bSuccess > 0)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(6001));		
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(6002));
	}
	showDisable(false);
	delayTimeObject._Stop();
	delayTimeObject._Play();
}

function delayAutoCall(int Count)
{
	Debug("needItemScript.GetMaxNumCanBuy()" @ string(needItemScript.GetMaxNumCanBuy()));
	if(needItemScript.GetMaxNumCanBuy() > 0)
	{
		inputItemScript.SetCount(1);		
	}
	else
	{
		inputItemScript.SetCount(int(needItemScript.GetMaxNumCanBuy()));
	}
}

function HandleS_EX_DETHRONE_POINT_INFO()
{
	local UIPacket._S_EX_DETHRONE_POINT_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_POINT_INFO(packet))
	{
		return;
	}
	currentDP = packet.nPersonalPoint;
	// End:0x82
	if(Me.IsShowWindow())
	{
		// End:0x82
		if((NeedItemRichListCtrl.GetRecordCount() > 0) && dpIndex > -1)
		{
			needItemScript.ModifyCurrentAmount(dpIndex, currentDP);
			DelegateOnUpdateItem();
		}
	}
	Debug("currentDP" @ string(currentDP));	
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x1F
		case "Buy_Button":
			OnBuy_ButtonClick();
			// End:0x22
			break;
	}	
}

function OnBuy_ButtonClick()
{
	local RichListCtrlRowData RowData;
	local ItemInfo Info;

	// End:0x31
	if(Shop_RichListCtrl.GetSelectedIndex() < 0)
	{
		util.showGfxScreenMessage(GetSystemMessage(326));
		return;
	}
	Shop_RichListCtrl.GetSelectedRec(RowData);
	tryBuyID = int(RowData.nReserved3);
	tryBuyAmount = inputItemScript.GetCount();
	Info = GetItemInfoByClassID(int(RowData.nReserved1));
	popupExpandScript.SetDialogDesc(MakeFullSystemMsg(GetSystemMessage(13404), GetItemNameAll(Info)));
	popupExpandScript.SetBuyItemClassID(Info.Id.ClassID, int(RowData.nReserved2));
	popupExpandScript.SetItemNum(int(inputItemScript.GetCount()));
	popupExpandScript.OKButton.EnableWindow();
	popupExpandScript.Show();
	showDisable(true);	
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		// End:0x26
		case "Shop_RichListCtrl":
			ClickRecord();
			// End:0x29
			break;
	}	
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		// End:0x3E
		case "Shop_RichListCtrl":
			// End:0x3B
			if(needItemScript.GetMaxNumCanBuy() > 0)
			{
				OnBuy_ButtonClick();
			}
			// End:0x41
			break;
	}	
}

function ClickRecord()
{
	local int i, Index, needItemIndex;
	local ItemInfo Info;
	local RichListCtrlRowData RowData;

	Index = Shop_RichListCtrl.GetSelectedIndex();
	// End:0x26
	if(Index <= -1)
	{
		return;
	}
	Shop_RichListCtrl.GetRec(Index, RowData);
	Info = GetItemInfoByClassID(int(RowData.nReserved1));
	class'UIAPI_MULTISELLITEMINFO'.static.Clear("DethroneShopWnd.multiSellItemInfo");
	class'UIAPI_MULTISELLITEMINFO'.static.SetItemInfo("DethroneShopWnd.multiSellItemInfo", 0, Info);
	needItemIndex = getNeedItemsIndexByID(int(RowData.nReserved3));
	// End:0x2C4
	if(needItemIndex > -1)
	{
		NeedItemRichListCtrl.DeleteAllItem();
		needItemScript.StartNeedItemList(shopDataArray[needItemIndex].NeedItemList.Length);
		spIndex = -1;
		dpIndex = -1;

		// End:0x2C4 [Loop If]
		for(i = 0; i < shopDataArray[needItemIndex].NeedItemList.Length; i++)
		{
			Debug("필요아이템 classid:" @ string(shopDataArray[needItemIndex].NeedItemList[i].ItemClassID));
			// End:0x1F3
			if(shopDataArray[needItemIndex].NeedItemList[i].ItemClassID == 82499)
			{
				dpIndex = needItemScript.AddNeeItemInfo(GetItemInfoByClassID(82499), shopDataArray[needItemIndex].NeedItemList[i].ItemAmount, currentDP);
				// [Explicit Continue]
				continue;
			}
			// End:0x273
			if(shopDataArray[needItemIndex].NeedItemList[i].ItemClassID == 82500)
			{
				CurrentSP = getInstanceUIData().getCurrentSP();
				spIndex = needItemScript.AddNeeItemInfo(GetItemInfoByClassID(82500), shopDataArray[needItemIndex].NeedItemList[i].ItemAmount, CurrentSP);
				// [Explicit Continue]
				continue;
			}
			needItemScript.AddNeedItemClassID(shopDataArray[needItemIndex].NeedItemList[i].ItemClassID, shopDataArray[needItemIndex].NeedItemList[i].ItemAmount);
		}
	}
	// End:0x2F1
	if(needItemScript.GetMaxNumCanBuy() > 0)
	{
		inputItemScript.SetCount(1);		
	}
	else
	{
		inputItemScript.SetCount(int(needItemScript.GetMaxNumCanBuy()));
	}	
}

function showDisable(bool bShow)
{
	// End:0x78
	if(bShow)
	{
		GetWindowHandle(m_WindowName $ ".DisableWnd").ShowWindow();
		GetEditBoxHandle(m_WindowName $ ".ShopItemInfoWnd.inputItemWnd.ItemCount_EditBox").HideWindow();		
	}
	else
	{
		GetWindowHandle(m_WindowName $ ".DisableWnd").HideWindow();
		GetEditBoxHandle(m_WindowName $ ".ShopItemInfoWnd.inputItemWnd.ItemCount_EditBox").ShowWindow();
	}	
}

function API_C_EX_DETHRONE_SHOP_BUY(int ClassID, INT64 nCount)
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_SHOP_BUY packet;

	packet.nID = ClassID;
	packet.nCount = nCount;
	// End:0x40
	if(! class'UIPacket'.static.Encode_C_EX_DETHRONE_SHOP_BUY(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_SHOP_BUY, stream);
	Debug("API Call --> C_EX_DETHRONE_SHOP_BUY" @ string(ClassID) @ string(nCount));	
}

function API_C_EX_DETHRONE_SHOP_OPEN_UI()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_SHOP_OPEN_UI, stream);
	Debug("API Call --> C_EX_DETHRONE_SHOP_OPEN_UI");	
}

function OnESCKey()
{
	Shop_RichListCtrl.SetFocus();	
}

function OnReceivedCloseUI()
{
	// End:0x69
	if(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset").IsShowWindow())
	{
		showDisable(false);
		GetWindowHandle(m_WindowName $ ".UIControlDialogAsset").HideWindow();		
	}
	else
	{
		showDisable(false);
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		GetWindowHandle(m_WindowName).HideWindow();
	}	
}

defaultproperties
{
     m_WindowName="DethroneShopWnd"
}
