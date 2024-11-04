//================================================================================
// RandomCraftChargingWnd.
//================================================================================

class RandomCraftChargingWnd extends UICommonAPI;

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const PRICE_ADENA_CLASSID = 57;

var string m_WindowName;
var WindowHandle Me;
var ItemWindowHandle m_topList;
var ItemWindowHandle m_bottomList;
var WindowHandle m_dialogWnd;
var StatusBarHandle statusCraftPoint;
var int craftPoint;
var byte craftPointMax;
var int craftPointAdded;
var int craftCharge;
var int craftChargeMax;
var int craftChargeAdded;
var INT64 craftChargePrice;
var WindowHandle m_Confirm_Wnd;
var WindowHandle m_SelectItemWnd;
var TextBoxHandle m_txtCraftPointAdded;
var TextBoxHandle m_statusGaugeMaxText;

function InitHandle()
{
	Me = GetWindowHandle(m_WindowName);
	m_dialogWnd = GetWindowHandle("DialogBox");
	m_topList = GetItemWindowHandle(m_WindowName $ ".TopList");
	m_bottomList = GetItemWindowHandle(m_WindowName $ ".BottomList");
	statusCraftPoint = GetStatusBarHandle(m_WindowName $ ".statusCraftPoint");
	m_SelectItemWnd = GetWindowHandle(m_WindowName $ ".SelectItemWnd");
	m_Confirm_Wnd = GetWindowHandle(m_WindowName $ ".Confirm_Wnd");
	m_txtCraftPointAdded = GetTextBoxHandle(m_WindowName $ ".Confirm_Wnd.ConfirmDetails_Wnd.txtCraftPointAdded");
	m_statusGaugeMaxText = GetTextBoxHandle(m_WindowName $ ".statusGaugeMaxText");
	statusCraftPoint.SetDecimalPlace(2);
}

function OnRegisterEvent()
{
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_CRAFT_INFO));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_CRAFT_EXTRACT));
	RegisterEvent(EV_AdenaInvenCount);
}

function OnLoad()
{
	SetClosingOnESC();
	InitHandle();
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "RandomCraftWnd");
	Clear();
	craftPointMax = API_GetMaxItemPoint();
	craftChargeMax = API_GetMaxGaugeValue();
	m_Confirm_Wnd.HideWindow();
	SetItems();
	SetAdenaItem();
	SetStatusCraftPoint(craftCharge);
	CheckAddedCondition();
	SetCraftPointTxt();
	Me.SetFocus();
}

function SetStatusCraftPoint(int craftChargePercent, optional int pointAdded)
{
	craftPointAdded = pointAdded;
	if ((craftPoint + craftPointAdded >= craftPointMax)
        && (craftChargePercent >= craftChargeMax - 1))
	{
		m_statusGaugeMaxText.ShowWindow();
		statusCraftPoint.SetDrawPoint(false);
	}
	else
	{
		m_statusGaugeMaxText.HideWindow();
		statusCraftPoint.SetDrawPoint(true);
	}
	craftChargeAdded = craftChargePercent;
	statusCraftPoint.SetPointPercent(getInstanceL2Util().Get9999Percent(craftChargePercent, craftChargeMax), 0, craftChargeMax);
}

function CheckAddedCondition()
{
	local StatusBaseHandle Handle;

	Handle = statusCraftPoint.GetSelfScript();
	if (m_bottomList.GetItemNum() > 0)
	{
		m_SelectItemWnd.ShowWindow();
		statusCraftPoint.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeCenter, GetColor(65, 90, 24, 255));
		GetButtonHandle(m_WindowName $ ".OKButton").EnableWindow();
		GetButtonHandle(m_WindowName $ ".ResetButton").SetButtonName(479);
	}
	else
	{
		m_SelectItemWnd.HideWindow();
		statusCraftPoint.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeCenter, GetColor(5, 57, 134, 255));
		GetButtonHandle(m_WindowName $ ".OKButton").DisableWindow();
		GetButtonHandle(m_WindowName $ ".ResetButton").SetButtonName(938);
	}
}

function SetAdenaItem()
{
	local ItemInfo iInfo;
	local ItemID iID;

	iID.ClassID = PRICE_ADENA_CLASSID;
	class'UIDATA_ITEM'.static.GetItemInfo(iID, iInfo);
	GetItemWindowHandle(m_WindowName $ ".AdenaIcon").AddItem(iInfo);
	GetTextBoxHandle(m_WindowName $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemText").SetText(iInfo.Name);
	GetItemWindowHandle(m_WindowName $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupIcon").AddItem(iInfo);
}

function SetItems()
{
	local array<ItemInfo> iItems;
	local int i;

	iItems = InventoryWnd(GetScript("InventoryWnd")).getInventoryAllItemArray(True);

	for (i = 0; i < iItems.Length; i++)
	{
		// End:0xB3
		if(IsChargingItem(iItems[i]))
		{
			// End:0x99
			if(isCollectionItem(iItems[i]))
			{
				iItems[i].ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
			}
			m_topList.AddItem(iItems[i]);
		}
	}
}

function bool IsChargingItem(ItemInfo iInfo)
{
	// End:0x12
	if(iInfo.nGrindPoint <= 0)
	{
		return false;
	}
	// End:0x22
	if(iInfo.bSecurityLock)
	{
		return false;
	}
	// End:0x34
	if(! iInfo.bIsDesturctAble)
	{
		return false;
	}
	if(EItemType(iInfo.ItemType) == EItemType.ITEM_QUESTITEM)
	{
		return false;
	}
	return true;
}

function OnHide()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_topList.EnableWindow();
	m_bottomList.EnableWindow();
	if(DialogIsMine() && m_dialogWnd.IsShowWindow())
	{
		DialogHide();
		m_dialogWnd.HideWindow();
	}
}

function OnEvent(int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_DialogOK:
			HandleDialogOK();
			break;
		case EV_DialogCancel:
			HandleDialogCancel();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_CRAFT_EXTRACT):
			ParsePacket_S_EX_CRAFT_EXTRACT();
			break;
		case EV_AdenaInvenCount:
			HandleAdena();
			break;
	}
}

function HandleAdena()
{
	local INT64 Adena;
	local TextBoxHandle adenaCostText;

	Adena = GetAdena();
	adenaCostText = GetTextBoxHandle(m_WindowName $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemNumCurrentText");
	// End:0xCD
	if(Adena < craftChargePrice)
	{
		adenaCostText.SetTextColor(getInstanceL2Util().DRed);
		GetButtonHandle(m_WindowName $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupOK_BTN").DisableWindow();
	}
	else
	{
		adenaCostText.SetTextColor(getInstanceL2Util().BLUE01);
		GetButtonHandle(m_WindowName $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupOK_BTN").EnableWindow();
	}
	adenaCostText.SetText("(" $ MakeCostString(string(Adena)) $ ")");
}

function OnClickButton(string ControlName)
{
    if (ControlName == "OKButton")
    {
        ShowPopup();
    }
    else if (ControlName == "CancelButton")
    {
        Clear();
        HideWindow(m_WindowName);
    }
    else if (ControlName == "SortButton")
    {
        getInstanceL2Util().SortItem(m_topList);
    }
    else if (ControlName == "ResetButton")
    {
        Clear();
        SetItems();
    }
    else if (ControlName == "PopupOK_BTN")
    {
        API_C_EX_CRAFT_EXTRACT();
        GetButtonHandle(m_WindowName $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupOK_BTN").DisableWindow();
    }
    else if (ControlName == "PopupCancel_BTN")
    {
        m_Confirm_Wnd.HideWindow();
    }
}

function OnRClickItem(string strID, int Index)
{
    OnDBClickItem(strID, Index);
}

function OnDBClickItem(string ControlName, int Index)
{
    if (Index >= 0)
    {
        if (ControlName == "TopList")
        {
            MoveItemTopToBottom(Index, Class 'InputAPI'.static.IsAltPressed());
        }
        else
        {
            if (ControlName == "BottomList")
            {
                MoveItemBottomToTop(Index, Class 'InputAPI'.static.IsAltPressed());
            }
        }
    }
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	local int Index;

	if(strID == "TopList" && Info.DragSrcName == "BottomList")
	{
		Index = m_bottomList.FindItemWithAllProperty(Info);
		if(Index >= 0)
		{
			MoveItemBottomToTop(Index, Info.AllItemCount > 0);
		}
	}
	else
	{
		if(strID == "BottomList" && Info.DragSrcName == "TopList")
		{
			Index = m_topList.FindItemWithAllProperty(Info);
			// End:0xE3
			if(Index >= 0)
			{
				MoveItemTopToBottom(Index, Info.AllItemCount > 0);
			}
		}
	}
}

function Clear()
{
	m_topList.Clear();
	m_bottomList.Clear();
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".AdenaText", "0");
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".AdenaText", "");
	SetStatusCraftPoint(craftCharge);
	CheckAddedCondition();
	m_SelectItemWnd.HideWindow();
	m_Confirm_Wnd.HideWindow();
	m_statusGaugeMaxText.HideWindow();
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
	local ItemInfo topInfo;
	local ItemInfo bottomInfo;
	local int bottomIndex;
	local INT64 toAddNum;

	if(m_statusGaugeMaxText.IsShowWindow())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13101));
		return;
	}
	// End:0x45
	if(! m_topList.IsEnableWindow())
	{
		return;
	}
	// End:0x242
	if(m_topList.GetItem(Index, topInfo))
	{
		if(!bAllItem && IsStackableItem(topInfo.ConsumeType) && topInfo.ItemNum > 1)
		{
			DialogSetID(DIALOG_TOP_TO_BOTTOM);
			DialogSetReservedItemID(topInfo.Id);
			DialogSetParamInt64(topInfo.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), topInfo.Name, ""), string(self));
			m_topList.DisableWindow();
			m_bottomList.DisableWindow();
		}
		else
		{
			bottomIndex = m_bottomList.FindItem(topInfo.Id);
			toAddNum = CheckNumEnough(topInfo.ItemNum, topInfo.nGrindPoint);
			// End:0x177
			if(topInfo.ItemNum == toAddNum)
			{
				m_topList.DeleteItem(Index);
			}
			else
			{
				topInfo.ItemNum = topInfo.ItemNum - toAddNum;
				m_topList.SetItem(Index, topInfo);
			}
			// End:0x218
			if(bottomIndex != -1 && IsStackableItem(topInfo.ConsumeType))
			{
				m_bottomList.GetItem(bottomIndex, bottomInfo);
				bottomInfo.ItemNum += toAddNum;
				m_bottomList.SetItem(bottomIndex, bottomInfo);
			}
			else
			{
				topInfo.ItemNum = toAddNum;
				m_bottomList.AddItem(topInfo);
			}
			SetChargingInfos();
		}
	}
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
	local ItemInfo bottomInfo, topInfo;
	local int topIndex;

	if(!m_bottomList.IsEnableWindow())
	{
		return;
	}
	// End:0x19A
	if(m_bottomList.GetItem(Index, bottomInfo))
	{
		if(! bAllItem && IsStackableItem(bottomInfo.ConsumeType) && bottomInfo.ItemNum > 1)
		{
			DialogSetID(DIALOG_BOTTOM_TO_TOP);
			DialogSetReservedItemID(bottomInfo.Id);
			DialogSetParamInt64(bottomInfo.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), bottomInfo.Name, ""), string(self));
			m_topList.DisableWindow();
			m_bottomList.DisableWindow();
		}
		else
		{
			topIndex = m_topList.FindItem(bottomInfo.Id);
			// End:0x16C
			if(topIndex != -1 && IsStackableItem(bottomInfo.ConsumeType))
			{
				m_topList.GetItem(topIndex, topInfo);
				topInfo.ItemNum += bottomInfo.ItemNum;
				m_topList.SetItem(topIndex, topInfo);
			}
			else
			{
				m_topList.AddItem(bottomInfo);
			}
			m_bottomList.DeleteItem(Index);
			SetChargingInfos();
		}
	}
}

function HandleDialogCancel()
{
	m_topList.EnableWindow();
	m_bottomList.EnableWindow();
}

function HandleDialogOK()
{
	local int Id, Index, topIndex;
	local INT64 Num;
	local ItemInfo Info, topInfo;
	local ItemID cID;

	// End:0x352
	if(DialogIsMine())
	{
		Id = DialogGetID();
		Num = int64(DialogGetString());
		cID = DialogGetReservedItemID();
		m_topList.EnableWindow();
		m_bottomList.EnableWindow();

		if(Id == 111 && Num > 0)
		{
			topIndex = m_topList.FindItem(cID);
			// End:0x1DA
			if(topIndex >= 0)
			{
				m_topList.GetItem(topIndex, topInfo);
				Num = Min64(Num, topInfo.ItemNum);
				Num = CheckNumEnough(Num, topInfo.nGrindPoint);
				Index = m_bottomList.FindItem(cID);
				// End:0x149
				if(Index >= 0)
				{
					m_bottomList.GetItem(Index, Info);
					Info.ItemNum += Num;
					m_bottomList.SetItem(Index, Info);
				}
				else
				{
					Info = topInfo;
					Info.ItemNum = Num;
					Info.bShowCount = false;
					m_bottomList.AddItem(Info);
				}
				topInfo.ItemNum -= Num;
				// End:0x1C1
				if(topInfo.ItemNum <= 0)
				{
					m_topList.DeleteItem(topIndex);
				}
				else
				{
					m_topList.SetItem(topIndex, topInfo);
				}
			}
		}
		else if(Id == 222 && Num > 0)
		{
			Index = m_bottomList.FindItem(cID);
			if(Index >= 0)
			{
				m_bottomList.GetItem(Index, Info);
				Num = Min64(Num, Info.ItemNum);
				Info.ItemNum -= Num;

				if(Info.ItemNum > 0)
				{
					m_bottomList.SetItem(Index, Info);
				}
				else
				{
					m_bottomList.DeleteItem(Index);
				}
				topIndex = m_topList.FindItem(cID);
				if(topIndex >= 0 && IsStackableItem(Info.ConsumeType))
				{
					m_topList.GetItem(topIndex, topInfo);
					topInfo.ItemNum += Num;
					m_topList.SetItem(topIndex, topInfo);
				}
				else
				{
					Info.ItemNum = Num;
					m_topList.AddItem(Info);
				}
			}
		}
		SetChargingInfos();
	}
}

function HandleOKButton()
{
	HideWindow(m_WindowName);
}

function ShowPopup()
{
	HandleAdena();
	GetButtonHandle(m_WindowName $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupOK_BTN").EnableWindow();
	m_Confirm_Wnd.ShowWindow();
	m_Confirm_Wnd.SetFocus();
}

function INT64 GetCraftChargeCurrentTotal()
{
	return craftPoint * craftChargeMax + craftCharge;
}

function SetChargingInfos()
{
	local int i;
	local INT64 craftChargePercent;
	local string addedString;
	local INT64 tmpCraftPointAdded, tmpCraftPointTotal, craftChargeAdded, craftChargeCurrentTotal;
	local ItemInfo iInfo;

	craftChargeAdded = 0;
	craftChargePrice = 0;

	// End:0xA3 [Loop If]
	for (i = 0; i < m_bottomList.GetItemNum(); i++)
	{
		m_bottomList.GetItem(i, iInfo);
		craftChargeAdded = craftChargeAdded + iInfo.nGrindPoint * iInfo.ItemNum;
		craftChargePrice = craftChargePrice + iInfo.nGrindCommission * iInfo.ItemNum;
	}
	craftChargeCurrentTotal = GetCraftChargeCurrentTotal();
	tmpCraftPointTotal = (craftChargeAdded + craftChargeCurrentTotal) / craftChargeMax;
	// End:0x104
	if(tmpCraftPointTotal > int(craftPointMax))
	{
		tmpCraftPointAdded = craftPointMax - craftPoint;
		craftChargePercent = craftChargeMax;
	}
	else
	{
		tmpCraftPointAdded = tmpCraftPointTotal - craftPoint;
		craftChargePercent = craftChargeCurrentTotal + craftChargeAdded - tmpCraftPointTotal * craftChargeMax;
	}
	SetStatusCraftPoint(craftChargePercent, tmpCraftPointAdded);
	CheckAddedCondition();
	addedString = "+ " $ string(tmpCraftPointAdded) $ GetSystemString(2293);
	m_txtCraftPointAdded.SetText(addedString);
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".AdenaText", MakeCostString(string(craftChargePrice)));
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".AdenaText", ConvertNumToText(string(craftChargePrice)));
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemNumText", "x" $ MakeCostString(string(craftChargePrice)));
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemNumText", ConvertNumToText(string(craftChargePrice)));
}

function INT64 CheckNumEnough(INT64 itemMax, int nGrindPoint)
{
	local INT64 enoughNum;

	enoughNum = GetNumEnough(itemMax, nGrindPoint);
	if(itemMax != enoughNum)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13101));
	}
	return enoughNum;
}

function INT64 GetNumEnough(INT64 itemMax, int nGrindPoint)
{
	local INT64 craftChargeCurrentTotal, canputChargeNum, canCharge;

	craftChargeCurrentTotal = craftPoint * craftChargeMax + craftPointAdded * craftChargeMax + craftChargeAdded;
	canCharge = craftPointMax * craftChargeMax + craftChargeMax - 1;
	canCharge = canCharge - craftChargeCurrentTotal;
	canputChargeNum = canCharge / nGrindPoint;
	if (canputChargeNum * nGrindPoint < canCharge)
	{
		canputChargeNum = canputChargeNum + 1;
	}
	return Min64(itemMax, canputChargeNum);
}

function SetShowPopup()
{
	m_Confirm_Wnd.ShowWindow();
	m_Confirm_Wnd.SetFocus();
}

function int API_GetMaxGaugeValue()
{
	return Class 'RandomCraftAPI'.static.GetMaxGaugeValue();
}

function byte API_GetMaxItemPoint()
{
	return Class 'RandomCraftAPI'.static.GetMaxItemPoint();
}

function API_C_EX_CRAFT_EXTRACT()
{
	local array<byte> stream;
	local UIPacket._C_EX_CRAFT_EXTRACT packet;
	local ItemInfo iInfo;
	local int i;

	packet.Items.Length = m_bottomList.GetItemNum();
   
	for (i = 0; i < m_bottomList.GetItemNum(); i++)
	{
		m_bottomList.GetItem(i, iInfo);
		packet.Items[i].nItemServerId = iInfo.Id.ServerID;
		packet.Items[i].nAmount = iInfo.ItemNum;
	}
	if(! class'UIPacket'.static.Encode_C_EX_CRAFT_EXTRACT(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_CRAFT_EXTRACT, stream);
}

function ParsePacket_S_EX_CRAFT_EXTRACT()
{
	local UIPacket._S_EX_CRAFT_EXTRACT packet;

	if(! class'UIPacket'.static.Decode_S_EX_CRAFT_EXTRACT(packet))
	{
		return;
	}
	switch(packet.cResult)
	{
		case 0:
			m_bottomList.Clear();
			CheckAddedCondition();
			break;
		// End:0xFFFF
		default:
			// End:0x49
			break;
	}
	m_Confirm_Wnd.HideWindow();
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".AdenaText", "0");
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".AdenaText", "");
}

function ParsePacket_S_EX_CRAFT_INFO(UIPacket._S_EX_CRAFT_INFO packet)
{
	craftPoint = packet.nPoint;
	craftCharge = packet.nCharge;
	SetStatusCraftPoint(craftCharge, craftPointAdded);
	CheckAddedCondition();
	SetCraftPointTxt();
	if (packet.bGiveItem > 0)
	{
		GetTextureHandle("RandomCraftChargingWnd.CraftIcon").SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon");
	}
	else
	{
		GetTextureHandle("RandomCraftChargingWnd.CraftIcon").SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon_dis");
	}
}

function SetCraftPointTxt()
{
    Class 'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".txtCraftPoint", GetSystemString(13159) @ "x" $ string(craftPoint) $ "/" $ string(craftPointMax));
}

function OnReceivedCloseUI()
{
	// End:0x24
	if(m_Confirm_Wnd.IsShowWindow())
	{
		m_Confirm_Wnd.HideWindow();		
	}
	else
	{
		GetWindowHandle(m_WindowName).HideWindow();
	}
}

defaultproperties
{
     m_WindowName="RandomCraftChargingWnd"
}
