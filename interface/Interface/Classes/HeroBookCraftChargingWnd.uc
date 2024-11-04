class HeroBookCraftChargingWnd extends UICommonAPI;

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const PRICE_ADENA_CLASSID = 57;

var WindowHandle m_dialogWnd;
var string m_WindowName;
var WindowHandle Me;
var WindowHandle m_Confirm_Wnd;
var TextureHandle statusGaugeHighlight;
var TextBoxHandle statusGaugeMaxText;
var ItemWindowHandle ReceiveSkill_Item;
var TextBoxHandle SkillLevel_textbox;
var TextBoxHandle SkillName_textbox;
var StatusBarHandle PossiblePointStatusBar;
var StatusBarHandle statusCraftPointStatusBar;
var ItemWindowHandle m_topList;
var ItemWindowHandle m_bottomList;
var int nCurrentHeroPoint;
var int nCurrentLevel;
var int nCommission;
var int nMaxHeroPoint;
var INT64 chargeAdded;
var INT64 chargeCurrent;
var INT64 chargePrice;
var bool bProgress;

function OnRegisterEvent()
{
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HERO_BOOK_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HERO_BOOK_CHARGE);
	RegisterEvent(EV_AdenaInvenCount);	
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();	
}

function Initialize()
{
	Me = GetWindowHandle("HeroBookCraftChargingWnd");
	m_Confirm_Wnd = GetWindowHandle("HeroBookCraftChargingWnd.Confirm_Wnd");
	statusGaugeHighlight = GetTextureHandle("HeroBookCraftChargingWnd.statusGaugeHighlight");
	statusGaugeMaxText = GetTextBoxHandle("HeroBookCraftChargingWnd.statusGaugeMaxText");
	ReceiveSkill_Item = GetItemWindowHandle("HeroBookCraftChargingWnd.ReceiveSkill_Item");
	SkillLevel_textbox = GetTextBoxHandle("HeroBookCraftChargingWnd.SkillLevel_textbox");
	SkillName_textbox = GetTextBoxHandle("HeroBookCraftChargingWnd.SkillName_textbox");
	PossiblePointStatusBar = GetStatusBarHandle("HeroBookCraftChargingWnd.PossiblePoint");
	statusCraftPointStatusBar = GetStatusBarHandle("HeroBookCraftChargingWnd.statusCraftPoint");
	m_topList = GetItemWindowHandle("HeroBookCraftChargingWnd.TopList");
	m_bottomList = GetItemWindowHandle("HeroBookCraftChargingWnd.BottomList");
	statusCraftPointStatusBar.SetDrawPoint(false);
	PossiblePointStatusBar.SetDrawPoint(false);	
}

function Load()
{
	local StatusBaseHandle Handle;

	Handle = PossiblePointStatusBar.GetSelfScript();
	PossiblePointStatusBar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeCenter, GTColor().Green2);	
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	Clear();
	SetAdenaItem();
	SetItems();
	SetChargingInfos();
	SetStatusCraftPoint();
	CheckAddedCondition();
	Debug("GetHeroBookMaxPoint : " @ "(" @ string(nCurrentLevel) @ " :" @ string(class'HeroBookAPI'.static.GetHeroBookMaxPoint(nCurrentLevel)));	
}

function OnHide()
{
	m_topList.EnableWindow();
	m_bottomList.EnableWindow();
	// End:0x2D
	if(DialogIsMine())
	{
		DialogHide();
	}	
}

function SetStatusCraftPoint()
{
	statusCraftPointStatusBar.SetPoint(chargeCurrent, nMaxHeroPoint);
	PossiblePointStatusBar.SetPoint(chargeCurrent + chargeAdded, nMaxHeroPoint);
	if(nMaxHeroPoint <= (chargeCurrent + chargeAdded))
	{
		statusGaugeMaxText.SetText(GetSystemString(3451));		
	}
	else
	{
		statusGaugeMaxText.SetText(cutZeroDecimalStr(ConvertFloatToString((float(chargeCurrent + chargeAdded) / float(nMaxHeroPoint)) * float(100), 2, false)) $ "%");
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

	class'HeroBookAPI'.static.GetHeroBookItemListFromInven(iItems);
	m_topList.Clear();

	// End:0xD2 [Loop If]
	for(i = 0; i < iItems.Length; i++)
	{
		// End:0xAE
		if(isCollectionItem(iItems[i]))
		{
			iItems[i].ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
		}
		m_topList.AddItem(iItems[i]);
	}	
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x20
		case "PopupOK_BTN":
			OnPopupOK_BTNClick();
			// End:0x89
			break;
		// End:0x3D
		case "PopupCancel_BTN":
			OnPopupCancel_BTNClick();
			// End:0x89
			break;
		// End:0x53
		case "OKButton":
			OnOKButtonClick();
			// End:0x89
			break;
		// End:0x6D
		case "CancelButton":
			OnCancelButtonClick();
			// End:0x89
			break;
		// End:0x86
		case "ResetButton":
			OnResetButtonClick();
			// End:0x89
			break;
		// End:0xFFFF
		default:
			break;
	}	
}

function OnPopupOK_BTNClick()
{
	API_C_EX_HERO_BOOK_CHARGE();	
}

function OnPopupCancel_BTNClick()
{
	hidePopup();	
}

function OnOKButtonClick()
{
	ShowPopup();	
}

function OnCancelButtonClick()
{
	Me.HideWindow();
	toggleWindow("HeroBookWnd", true, false);
	StopSound("InterfaceSound.ui_bookenchant_open");
	PlaySound("InterfaceSound.ui_bookenchant_open_short");	
}

function OnResetButtonClick()
{
	Clear();
	CheckAddedCondition();
	SetItems();
	SetChargingInfos();	
}

function OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);	
}

function OnDBClickItem(string ControlName, int Index)
{
	// End:0x6B
	if(Index >= 0)
	{
		// End:0x3B
		if(ControlName == "TopList")
		{
			MoveItemTopToBottom(Index, class'InputAPI'.static.IsAltPressed());			
		}
		else
		{
			// End:0x6B
			if(ControlName == "BottomList")
			{
				MoveItemBottomToTop(Index, class'InputAPI'.static.IsAltPressed());
			}
		}
	}	
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	local int Index;

	// End:0x73
	if(strID == "TopList" && Info.DragSrcName == "BottomList")
	{
		Index = m_bottomList.FindItemWithAllProperty(Info);
		// End:0x70
		if(Index >= 0)
		{
			MoveItemBottomToTop(Index, Info.AllItemCount > 0);
		}		
	}
	else if(strID == "BottomList" && Info.DragSrcName == "TopList")
	{
		Index = m_topList.FindItemWithAllProperty(Info);
		// End:0xE3
		if(Index >= 0)
		{
			MoveItemTopToBottom(Index, Info.AllItemCount > 0);
		}
	}	
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
	local ItemInfo topInfo, bottomInfo;
	local int bottomIndex;
	local INT64 toAddNum;

	// End:0x3C
	if(statusGaugeMaxText.GetText() == GetSystemString(3451))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13101));
		return;
	}
	// End:0x52
	if(! m_topList.IsEnableWindow())
	{
		return;
	}
	// End:0x24F
	if(m_topList.GetItem(Index, topInfo))
	{
		// End:0x119
		if(! bAllItem && IsStackableItem(topInfo.ConsumeType) && topInfo.ItemNum > 1)
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
			toAddNum = CheckNumEnough(topInfo.ItemNum, topInfo.HeroBookPoint);
			// End:0x184
			if(topInfo.ItemNum == toAddNum)
			{
				m_topList.DeleteItem(Index);				
			}
			else
			{
				topInfo.ItemNum = topInfo.ItemNum - toAddNum;
				m_topList.SetItem(Index, topInfo);
			}
			// End:0x225
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

function INT64 CheckNumEnough(INT64 itemMax, int nHeroBookPoint)
{
	local INT64 enoughNum;

	enoughNum = GetNumEnough(itemMax, nHeroBookPoint);
	Debug("CheckNumEnough" @ string(enoughNum) @ string(itemMax) @ string(nHeroBookPoint));
	// End:0x72
	if(itemMax != enoughNum)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13101));
	}
	return enoughNum;	
}

function INT64 GetNumEnough(INT64 itemMax, int nHeroBookPoint)
{
	local INT64 CraftChargeCurrentTotal, canPutChargeNum, canCharge;

	CraftChargeCurrentTotal = chargeCurrent + chargeAdded;
	canCharge = nMaxHeroPoint - CraftChargeCurrentTotal;
	canPutChargeNum = canCharge / nHeroBookPoint;
	Debug("맥스 포인트 nMaxHeroPoint" @ string(nMaxHeroPoint));
	Debug("현재 전체 포인트 CraftChargeCurrentTotal" @ string(CraftChargeCurrentTotal));
	Debug("충전 가능한 포인트 canCharge" @ string(canCharge));
	Debug("nHeroBookPoint :  nHeroBookPoint" @ string(nHeroBookPoint));
	Debug("넣을 수 있는 수량 canPutChargeNum" @ string(canPutChargeNum));
	// End:0x15B
	if((canPutChargeNum * nHeroBookPoint) < canCharge)
	{
		canPutChargeNum = canPutChargeNum + 1;
	}
	return Min64(itemMax, canPutChargeNum);	
}

function SetChargingInfos()
{
	local int i;
	local INT64 canCharge;
	local ItemInfo iInfo;

	chargePrice = 0;
	chargeAdded = 0;

	// End:0xED [Loop If]
	for(i = 0; i < m_bottomList.GetItemNum(); i++)
	{
		m_bottomList.GetItem(i, iInfo);
		chargeAdded = chargeAdded + (iInfo.ItemNum * iInfo.HeroBookPoint);
		chargePrice = chargePrice + (iInfo.HeroBookPoint * nCommission * iInfo.ItemNum);
		Debug("chargePrice :" @ string(chargePrice) @ string(iInfo.HeroBookPoint) @ string(nCommission) @ string(iInfo.ItemNum));
	}
	// End:0x14F
	if(nMaxHeroPoint < (chargeAdded + chargeCurrent))
	{
		canCharge = nMaxHeroPoint - (chargeAdded + chargeCurrent);
		// End:0x14F
		if(canCharge < 0)
		{
			chargePrice = chargePrice + (canCharge * nCommission);
		}
	}
	SetStatusCraftPoint();
	CheckAddedCondition();
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".AdenaText", MakeCostString(string(chargePrice)));
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".AdenaText", ConvertNumToText(string(chargePrice)));
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemNumText", "x" $ MakeCostString(string(chargePrice)));
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemNumText", ConvertNumToText(string(chargePrice)));	
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
	local ItemInfo bottomInfo, topInfo;
	local int topIndex;

	// End:0x16
	if(! m_bottomList.IsEnableWindow())
	{
		return;
	}
	// End:0x19A
	if(m_bottomList.GetItem(Index, bottomInfo))
	{
		// End:0xDD
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
		// End:0x1DD
		if(Id == DIALOG_TOP_TO_BOTTOM && Num > 0)
		{
			topIndex = m_topList.FindItem(cID);
			// End:0x1DA
			if(topIndex >= 0)
			{
				m_topList.GetItem(topIndex, topInfo);
				Num = Min64(Num, topInfo.ItemNum);
				Num = CheckNumEnough(Num, topInfo.HeroBookPoint);
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
		else if(Id == DIALOG_BOTTOM_TO_TOP && Num > 0)
		{
			Index = m_bottomList.FindItem(cID);
			// End:0x34C
			if(Index >= 0)
			{
				m_bottomList.GetItem(Index, Info);
				Num = Min64(Num, Info.ItemNum);
				Info.ItemNum -= Num;
				// End:0x293
				if(Info.ItemNum > 0)
				{
					m_bottomList.SetItem(Index, Info);						
				}
				else
				{
					m_bottomList.DeleteItem(Index);
				}
				topIndex = m_topList.FindItem(cID);
				// End:0x328
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

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x18
		case EV_DialogOK:
			HandleDialogOK();
			// End:0x80
			break;
		// End:0x29
		case EV_DialogCancel:
			HandleDialogCancel();
			// End:0x80
			break;
		// End:0x49
		case EV_PacketID(class'UIPacket'.const.S_EX_HERO_BOOK_INFO):
			ParsePacket_S_EX_HERO_BOOK_INFO();
			// End:0x80
			break;
		// End:0x69
		case EV_PacketID(class'UIPacket'.const.S_EX_HERO_BOOK_CHARGE):
			ParsePacket_S_EX_HERO_BOOK_CHARGE();
			// End:0x80
			break;
		// End:0x7A
		case EV_AdenaInvenCount:
			HandleAdena();
			// End:0x80
			break;
	}
}

function HandleAdena()
{
	local INT64 Adena;
	local TextBoxHandle adenaCostText;

	Adena = GetAdena();
	adenaCostText = GetTextBoxHandle(m_WindowName $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemNumCurrentText");
	// End:0xC5
	if(Adena < chargePrice)
	{
		adenaCostText.SetTextColor(getInstanceL2Util().DRed);
		GetMeButton("Confirm_Wnd.ConfirmDetails_Wnd.PopupOK_BTN").DisableWindow();		
	}
	else
	{
		adenaCostText.SetTextColor(getInstanceL2Util().BLUE01);
		GetMeButton("Confirm_Wnd.ConfirmDetails_Wnd.PopupOK_BTN").EnableWindow();
	}
	adenaCostText.SetText("(" $ MakeCostString(string(Adena)) $ ")");	
}

function Clear()
{
	m_topList.Clear();
	m_bottomList.Clear();
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".AdenaText", "0");
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".AdenaText", "");
	SetStatusCraftPoint();
	m_Confirm_Wnd.HideWindow();	
}

function ShowPopup()
{
	HandleAdena();
	m_Confirm_Wnd.ShowWindow();
	m_Confirm_Wnd.SetFocus();	
}

function hidePopup()
{
	HandleAdena();
	m_Confirm_Wnd.HideWindow();	
}

function CheckAddedCondition()
{
	local StatusBaseHandle Handle;

	Handle = statusCraftPointStatusBar.GetSelfScript();
	// End:0x59
	if(chargeCurrent >= nMaxHeroPoint / 10)
	{
		statusCraftPointStatusBar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeCenter, GTColor().Yellow2);		
	}
	else
	{
		statusCraftPointStatusBar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeCenter, GTColor().DarkGray);
	}
	// End:0xE8
	if(m_bottomList.GetItemNum() > 0)
	{
		GetButtonHandle(m_WindowName $ ".OKButton").EnableWindow();
		GetButtonHandle(m_WindowName $ ".ResetButton").SetButtonName(479);		
	}
	else
	{
		GetButtonHandle(m_WindowName $ ".OKButton").DisableWindow();
		GetButtonHandle(m_WindowName $ ".ResetButton").SetButtonName(938);
	}	
}

function setProgress(bool bProgressP)
{
	CheckAddedCondition();
	bProgress = bProgressP;
	// End:0x71
	if(bProgress)
	{
		GetButtonHandle(m_WindowName $ ".OKButton").DisableWindow();
		hidePopup();
		m_topList.EnableWindow();
		m_bottomList.EnableWindow();
		// End:0x71
		if(DialogIsMine())
		{
			DialogHide();
		}
	}	
}

function API_C_EX_HERO_BOOK_CHARGE()
{
	local array<byte> stream;
	local UIPacket._C_EX_HERO_BOOK_CHARGE packet;
	local ItemInfo iInfo;
	local int i;

	packet.Items.Length = m_bottomList.GetItemNum();
	Debug("API_C_EX_HERO_BOOK_CHARGE" @ string(m_bottomList.GetItemNum()) @ string(packet.Items.Length));

	// End:0x162 [Loop If]
	for(i = 0; i < m_bottomList.GetItemNum(); i++)
	{
		m_bottomList.GetItem(i, iInfo);
		packet.Items[i].nItemServerId = iInfo.Id.ServerID;
		packet.Items[i].nAmount = iInfo.ItemNum;
		Debug("packet.items[i].nItemServerId" @ string(packet.Items[i].nItemServerId));
		Debug("packet.items[i].nAmount" @ string(packet.Items[i].nAmount));
	}
	// End:0x182
	if(! class'UIPacket'.static.Encode_C_EX_HERO_BOOK_CHARGE(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_HERO_BOOK_CHARGE, stream);	
}

function ParsePacket_S_EX_HERO_BOOK_INFO()
{
	local UIPacket._S_EX_HERO_BOOK_INFO packet;
	local HeroBookData levelData;
	local SkillInfo pSkillInfo;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_HERO_BOOK_INFO(packet))
	{
		return;
	}
	chargeCurrent = packet.nPoint;
	nCurrentLevel = packet.nLevel;
	class'HeroBookAPI'.static.GetHeroBookData(nCurrentLevel, levelData);
	nCommission = levelData.Commission;
	nMaxHeroPoint = levelData.MaxPoint;
	pSkillInfo = GetSkillInfoByValue(levelData.BookSkillID, levelData.BookSkillLevel, 0);
	ReceiveSkill_Item.Clear();
	ReceiveSkill_Item.AddItem(getSkillToItemInfo(pSkillInfo));
	SkillLevel_textbox.SetText(pSkillInfo.SkillName);
	SkillName_textbox.SetText(GetSystemString(88) $ "." $ string(pSkillInfo.SkillLevel));
	SetChargingInfos();
	SetStatusCraftPoint();
	OnResetButtonClick();	
}

function ParsePacket_S_EX_HERO_BOOK_CHARGE()
{
	local UIPacket._S_EX_HERO_BOOK_CHARGE packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_HERO_BOOK_CHARGE(packet))
	{
		return;
	}
	Debug("ParsePacket_S_EX_HERO_BOOK_CHARGE" @ string(packet.bSuccess));
	switch(packet.bSuccess)
	{
		// End:0xB3
		case 1:
			Debug("차징 성공 ");
			m_bottomList.Clear();
			AddSystemMessage(13722);
			PlaySound("ItemSound3.sys_bonus_hunt");
			// End:0xE5
			break;
		// End:0xFFFF
		default:
			AddSystemMessage(13723);
			Debug("차징 실패 ");
			Me.HideWindow();
			// End:0xE5
			break;
			break;
	}
	m_Confirm_Wnd.HideWindow();
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".AdenaText", "0");
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".AdenaText", "");
	class'L2UITimer'.static.Inst()._AddTimer(1, 1)._DelegateOnTime = OnTime;	
}

function OnTime(int Count)
{
	CheckAddedCondition();
	OnResetButtonClick();	
}

function OnReceivedCloseUI()
{
	// End:0x1B
	if(m_Confirm_Wnd.IsShowWindow())
	{
		hidePopup();		
	}
	else
	{
		closeUI();
	}	
}

defaultproperties
{
     m_WindowName="HeroBookCraftChargingWnd"
}
