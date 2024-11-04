class PetExtractWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle DisableWnd;
var WindowHandle resultWnd;
var AnimTextureHandle ResulteEffect_ani;
var ButtonHandle ResultWnd_btn;
var TextBoxHandle ResultWndSlotDesc_txt;
var ItemWindowHandle ResultWndItemSlot_ItemWnd;
var WindowHandle ChargeWnd;
var ItemWindowHandle InventoryWnd_ItemWnd;
var WindowHandle PetExtractSlot1_wnd;
var ItemWindowHandle PetExtractSlot1_ItemWindow;
var TextureHandle PetExtractWndSlot1_Active;
var WindowHandle PetExtractSlot2_wnd;
var ItemWindowHandle PetExtractSlot2_ItemWindow;
var TextureHandle PetExtractWndSlot2_Active;
var AnimTextureHandle PetExtractEffect_ani;
var ButtonHandle PetExtract_Btn;
var ButtonHandle PetReset_Btn;
var TextureHandle PetExtractSlotArrow_Tex;
var ProgressCtrlHandle PetExtractProgress;
var bool isProgress;
var ItemInfo selectedPetItemInfo;
var PetExtractInfo ExtractInfo;
var INT64 ResultItemNum;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_SHOW_PET_EXTRACT_SYSTEM);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HIDE_PET_EXTRACT_SYSTEM);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_RESULT_PET_EXTRACT_SYSTEM);
	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_SetMaxCount);
	RegisterEvent(EV_Restart);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle("PetExtractWnd");
	DisableWnd = GetWindowHandle("PetExtractWnd.DisableWnd");
	resultWnd = GetWindowHandle("PetExtractWnd.ResultWnd");
	ResulteEffect_ani = GetAnimTextureHandle("PetExtractWnd.ResultWnd.ResulteEffect_ani");
	PetExtractEffect_ani = GetAnimTextureHandle("PetExtractWnd.PetExtractEffect_ani");
	ResultWnd_btn = GetButtonHandle("PetExtractWnd.ResultWnd.ResultWnd_btn");
	ResultWndSlotDesc_txt = GetTextBoxHandle("PetExtractWnd.ResultWnd.ResultWndSlotDesc_txt");
	ResultWndItemSlot_ItemWnd = GetItemWindowHandle("PetExtractWnd.ResultWnd.ResultWndItemSlot_ItemWnd");
	ChargeWnd = GetWindowHandle("PetExtractWnd.ChargeWnd");
	InventoryWnd_ItemWnd = GetItemWindowHandle("PetExtractWnd.ExtractInventoryWnd.InventoryWnd_ItemWnd");
	PetExtractSlot1_wnd = GetWindowHandle("PetExtractWnd.PetExtractSlot1_wnd");
	PetExtractSlot1_ItemWindow = GetItemWindowHandle("PetExtractWnd.PetExtractSlot1_wnd.PetExtractSlot_ItemWindow");
	PetExtractWndSlot1_Active = GetTextureHandle("PetExtractWnd.PetExtractSlot1_wnd.PetExtractWndSlot_Active");
	PetExtractSlot2_wnd = GetWindowHandle("PetExtractWnd.PetExtractSlot2_wnd");
	PetExtractSlot2_ItemWindow = GetItemWindowHandle("PetExtractWnd.PetExtractSlot2_wnd.PetExtractSlot_ItemWindow");
	PetExtractWndSlot2_Active = GetTextureHandle("PetExtractWnd.PetExtractSlot2_wnd.PetExtractWndSlot_Active");
	PetExtractSlotArrow_Tex = GetTextureHandle("PetExtractWnd.PetExtractSlotArrow_Tex");
	PetExtract_Btn = GetButtonHandle("PetExtractWnd.PetExtract_Btn");
	PetReset_Btn = GetButtonHandle("PetExtractWnd.PetReset_Btn");
	PetExtractProgress = GetProgressCtrlHandle("PetExtractWnd.PetExtractProgress");
	PetExtractProgress.SetProgressTime(100);
}

function Load();

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	syncPetItemInven();
	GotoState('SelectPetItemState');
}

function OnClickButton(string Name)
{
	switch (Name)
	{
		case "ResultWnd_btn":
		case "PetReset_Btn":
			GotoState('SelectPetItemState');
			break;
		case "PetExtract_Btn":
			OnPetExtract_BtnClick();
			break;
	}
}

function OnPetExtract_BtnClick()
{
	// End:0xC7
	if(isProgress)
	{
		PetExtract_Btn.SetNameText(GetSystemString(13444));
		PetExtractEffect_ani.Stop();
		PetExtractEffect_ani.HideWindow();
		PetExtractProgress.SetPos(0);
		PetExtractProgress.Reset();
		isProgress = false;
		PetExtractSlotArrow_Tex.ShowWindow();
		PetReset_Btn.EnableWindow();
		GetTextBoxHandle("PetExtractWnd.PetExtract_Desc_txt").SetText(GetSystemString(13447));
	}
	else
	{
		PetExtractEffect_ani.ShowWindow();
		PetExtractEffect_ani.Stop();
		PetExtractEffect_ani.Play();
		PetExtractProgress.SetProgressTime(1500);
		PetExtractProgress.SetPos(0);
		PetExtractProgress.Reset();
		PetExtractProgress.Start();
		isProgress = true;
		PetExtractSlotArrow_Tex.HideWindow();
		PetExtract_Btn.SetNameText(GetSystemString(141));
		PetReset_Btn.DisableWindow();
		GetTextBoxHandle("PetExtractWnd.PetExtract_Desc_txt").SetText(GetSystemString(13449));
	}
}

function OnProgressTimeUp(string strID)
{
	Debug("strID" @ strID);
	if(strID == "PetExtractProgress")
	{
		if(Me.IsShowWindow())
		{
			API_C_EX_TRY_PET_EXTRACT_SYSTEM(selectedPetItemInfo.Id.ServerID);
		}
	}
}

function syncPetItemInven()
{
	local array<ItemInfo> itemarray;
	local int i;

	InventoryWnd_ItemWnd.Clear();
	GetObjectFindItemByCompare().DelegateCompare = petItemCompare;
	itemarray = GetObjectFindItemByCompare().GetAllItemByCompare();
	
	for ( i = 0;i < itemarray.Length;i++ )
	{
		InventoryWnd_ItemWnd.AddItem(itemarray[i]);
	}
}

function bool petItemCompare (ItemInfo item)
{
	local PetExtractInfo invenExtractInfo;
	local bool bFlag;

	if (EEtcItemType(item.EtcItemType) == ITEME_PET_COLLAR)
	{
		if ( item.PetExp <= 0 )
		{
			return false;
		}
		bFlag = class'PetAPI'.static.GetPetExtractInfo(item.PetID, item.Enchanted, invenExtractInfo);
		// End:0x66
		if(bFlag)
		{
			return true;
		}
	}
	return false;
}

function bool setNeedCost(int SlotIndex, int ItemID, INT64 ItemCount)
{
	local TextBoxHandle myCostText, needCostText;
	local ItemWindowHandle CostItemWindow;
	local TextureHandle CostIconBg_Texture;
	local INT64 itemCountMine;
	local ItemInfo CostItem;
	local bool bEnable;

	needCostText = GetTextBoxHandle("PetExtractWnd.ChargeWnd.Cost0" $ string(SlotIndex) $ "_Txt");
	myCostText = GetTextBoxHandle("PetExtractWnd.ChargeWnd.MyCost0" $ string(SlotIndex) $ "_Txt");
	CostItemWindow = GetItemWindowHandle("PetExtractWnd.ChargeWnd.CostIcon0" $ string(SlotIndex) $ "_ItemWindow");
	CostIconBg_Texture = GetTextureHandle("PetExtractWnd.ChargeWnd.CostSlot0" $ string(SlotIndex) $ "_Tex");
	if(ItemID > 0)
	{
		CostItem = GetItemInfoByClassID(ItemID);
		needCostText.SetText("x" $ MakeCostString(string(ItemCount)));
		CostIconBg_Texture.ShowWindow();
		CostItemWindow.ShowWindow();
		CostItemWindow.Clear();
		CostItemWindow.AddItem(CostItem);
		itemCountMine = GetInstanceL2UIInventory().GetInventoryItemCount(GetItemID(ItemID));
		myCostText.SetText("(" $ MakeCostString(string(itemCountMine)) $ ")");

		if(ItemCount > itemCountMine)
		{
			myCostText.SetTextColor(GTColor().DRed);
			bEnable = false;
		}
		else
		{
			myCostText.SetTextColor(GTColor().BLUE01);
			bEnable = true;
		}
	}
	else
	{
		needCostText.SetText("");
		myCostText.SetText("");
		CostItemWindow.HideWindow();
		CostItemWindow.Clear();
		CostIconBg_Texture.HideWindow();
	}
	return bEnable;
}

function clearNeedCost()
{
	setNeedCost(1, 0, 0);
	setNeedCost(2, 0, 0);	
}

function OnClickItem(string strID, int Index)
{
	Debug("strID" @ strID @ string(Index));
	InventoryWnd_ItemWnd.GetSelectedItem(selectedPetItemInfo);
	// End:0xC3
	if(selectedPetItemInfo.Id.ClassID > 0)
	{
		Debug("선택" @ string(selectedPetItemInfo.Id.ClassID));
		Debug("선택 selectedPetItemInfo.PetID" @ string(selectedPetItemInfo.PetID));
		PetExtractSlot1_ItemWindow.Clear();
		PetExtractSlot1_ItemWindow.AddItem(selectedPetItemInfo);
		GotoState('TryPetExtractState');
	}
}

function refreshNeedItem()
{
	local bool bCheckExtract1, bCheckExtract2;

	class'PetAPI'.static.GetPetExtractInfo(selectedPetItemInfo.PetID, selectedPetItemInfo.Enchanted, ExtractInfo);
	Debug("selectedPetItemInfo.PetID" @ string(selectedPetItemInfo.PetID));
	Debug("ExtractInfo.ExtractItemClassID" @ string(ExtractInfo.ExtractItemClassID));
	PetExtractSlot2_ItemWindow.Clear();
	PetExtractSlot2_ItemWindow.AddItem(GetItemInfoByClassID(ExtractInfo.ExtractItemClassID));
	ResultItemNum = selectedPetItemInfo.PetExp / ExtractInfo.ExtractExp;
	GetTextBoxHandle("PetExtractWnd.PetExtractSlot2_wnd.PetExtractWndSlotDesc_txt").SetText("x" $ MakeCostString(string(ResultItemNum)));
	Debug("selectedPetItemInfo.PetExp : " @ string(selectedPetItemInfo.PetExp));
	Debug("ExtractExp : " @ string(ExtractInfo.ExtractExp));
	clearNeedCost();
	bCheckExtract1 = setNeedCost(1, ExtractInfo.DefaultExtractCost.Id, ExtractInfo.DefaultExtractCost.Amount);
	bCheckExtract2 = setNeedCost(2, ExtractInfo.ExtractCost.Id, ExtractInfo.ExtractCost.Amount * ResultItemNum);
	// End:0x25E
	if(bCheckExtract1 && bCheckExtract2)
	{
		GetTextBoxHandle("PetExtractWnd.ChargeWnd.ChargeWndDesc_txt").SetText(GetSystemString(13445));
		PetExtract_Btn.EnableWindow();		
	}
	else
	{
		GetTextBoxHandle("PetExtractWnd.ChargeWnd.ChargeWndDesc_txt").SetText(GetSystemString(13448));
		PetExtract_Btn.DisableWindow();
	}	
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x12
		case 9750:
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_SHOW_PET_EXTRACT_SYSTEM):
			Debug("event -> S_EX_SHOW_PET_EXTRACT_SYSTEM");
			Me.ShowWindow();
			Me.SetFocus();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_HIDE_PET_EXTRACT_SYSTEM):
			Me.HideWindow();
			Debug("event -> S_EX_HIDE_PET_EXTRACT_SYSTEM");
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_RESULT_PET_EXTRACT_SYSTEM):
			ParsePacket_S_EX_RESULT_PET_EXTRACT_SYSTEM();
			break;
		case EV_AdenaInvenCount:
		case EV_SetMaxCount:
			if(Me.IsShowWindow() && IsInState('TryPetExtractState'))
			{
				refreshNeedItem();
			}
			break;
		case EV_Restart:
			InventoryWnd_ItemWnd.Clear();
			break;
	}
}

function ParsePacket_S_EX_RESULT_PET_EXTRACT_SYSTEM()
{
	local UIPacket._S_EX_RESULT_PET_EXTRACT_SYSTEM packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_RESULT_PET_EXTRACT_SYSTEM(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_RESULT_PET_EXTRACT_SYSTEM :  " @ string(packet.bSuccess));
	// End:0x7C
	if(packet.bSuccess > 0)
	{
		GotoState('ResultExtractState');		
	}
	else
	{
		Me.HideWindow();
	}
}

function API_C_EX_TRY_PET_EXTRACT_SYSTEM(int nPetItemSID)
{
	local array<byte> stream;
	local UIPacket._C_EX_TRY_PET_EXTRACT_SYSTEM packet;

	packet.nPetItemSID = nPetItemSID;
	if(! class'UIPacket'.static.Encode_C_EX_TRY_PET_EXTRACT_SYSTEM(stream,packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_TRY_PET_EXTRACT_SYSTEM,stream);
	Debug("----> Api Call : C_EX_TRY_PET_EXTRACT_SYSTEM" @ string(nPetItemSID));
}

function OnReceivedCloseUI()
{
	// End:0x12
	if(isProgress)
	{
		OnPetExtract_BtnClick();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
}

state SelectPetItemState
{
	function BeginState ()
	{
		DisableWnd.HideWindow();
		resultWnd.HideWindow();
		PetReset_Btn.HideWindow();
		GetWindowHandle("PetExtractWnd.ExtractInventoryWnd").ShowWindow();
		InventoryWnd_ItemWnd.ShowWindow();
		ChargeWnd.HideWindow();
		PetExtract_Btn.HideWindow();
		GetTextBoxHandle("PetExtractWnd.PetExtract_Desc_txt").SetText(GetSystemString(13446));
		PetExtractSlot1_wnd.ShowWindow();
		PetExtractSlot2_wnd.HideWindow();
		PetExtractWndSlot1_Active.ShowWindow();
		PetExtractWndSlot2_Active.HideWindow();
		ResulteEffect_ani.Stop();
		ResulteEffect_ani.HideWindow();
		PetExtractEffect_ani.Stop();
		PetExtractEffect_ani.HideWindow();
		PetExtractEffect_ani.Stop();
		PetExtractEffect_ani.HideWindow();
		PetExtractSlot1_ItemWindow.Clear();
		syncPetItemInven();
		// End:0x185
		if(isProgress)
		{
			OnPetExtract_BtnClick();
		}
		PetExtractSlotArrow_Tex.HideWindow();
	}
}

state TryPetExtractState
{
	function BeginState ()
	{
		isProgress = False;
		PetExtract_Btn.SetNameText(GetSystemString(13444));
		PetExtractEffect_ani.Stop();
		PetExtractEffect_ani.HideWindow();
		PetExtractSlotArrow_Tex.ShowWindow();
		GetTextBoxHandle("PetExtractWnd.PetExtract_Desc_txt").SetText(GetSystemString(13447));
		PetReset_Btn.ShowWindow();
		PetReset_Btn.EnableWindow();
		GetWindowHandle("PetExtractWnd.ExtractInventoryWnd").HideWindow();
		InventoryWnd_ItemWnd.HideWindow();
		ChargeWnd.ShowWindow();
		PetExtract_Btn.ShowWindow();
		PetExtractSlot1_wnd.ShowWindow();
		PetExtractSlot2_wnd.ShowWindow();
		PetExtractWndSlot1_Active.HideWindow();
		PetExtractWndSlot2_Active.ShowWindow();
		ResulteEffect_ani.Stop();
		ResulteEffect_ani.HideWindow();
		refreshNeedItem();
	}
}

state ResultExtractState
{
	function BeginState()
	{
		DisableWnd.ShowWindow();
		DisableWnd.SetFocus();
		resultWnd.ShowWindow();
		resultWnd.SetFocus();
		PetReset_Btn.ShowWindow();
		PetReset_Btn.EnableWindow();
		ResulteEffect_ani.ShowWindow();
		ResulteEffect_ani.Stop();
		ResulteEffect_ani.Play();
		ResultWndSlotDesc_txt.SetText("x" $ MakeCostString(string(ResultItemNum)));
		ResultWndItemSlot_ItemWnd.Clear();
		ResultWndItemSlot_ItemWnd.AddItem(GetItemInfoByClassID(ExtractInfo.ExtractItemClassID));		
	}
}

defaultproperties
{
}
