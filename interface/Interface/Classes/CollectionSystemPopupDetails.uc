class CollectionSystemPopupDetails extends UICommonAPI;

const ItemNum = 6;

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var CollectionSystem collectionSystemScript;
var CollectionSystemSub collectionSystemSubScript;
var WindowHandle ItemRegistrationList_Wnd;
var ItemWindowHandle ItemRegistrationList_ItemWnd;
var ButtonHandle Registration_Btn;
var TextureHandle ItemAllow_Tex;
var int currentSlotID;
var int collectionid;
var UIControlNeedItemDialog needItemDialogScript;
var ItemWindowHandle RewardItem_ItemWnd;
var ItemWindowHandle RewardSkill_ItemWnd;
var ButtonHandle Reward_Btn;
var AnimTextureHandle Complete_Ani;
var TextureHandle Complete_Tex;
var AnimTextureHandle GetSkill_Ani;
var TextureHandle GetSkill_Tex;
var AnimTextureHandle GetItem_Ani;
var TextureHandle GetItem_Tex;
var bool isCompleted;

function OnRegisterEvent()
{
	RegisterEvent(EV_DialogOK);
}

function HandleDialogOK()
{
	// End:0x0D
	if(! DialogIsMine())
	{
		return;
	}
	collectionSystemScript.API_C_EX_COLLECTION_RECEIVE_REWARD(collectionid);
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	util = L2Util(GetScript("L2Util"));
	collectionSystemScript = CollectionSystem(GetScript("CollectionSystem"));
	collectionSystemSubScript = CollectionSystemSub(GetScript("CollectionSystem.CollectionSystemSub"));
	ItemRegistrationList_Wnd = GetWindowHandle(m_WindowName $ ".ItemRegistrationList_Wnd");
	ItemRegistrationList_ItemWnd = GetItemWindowHandle(m_WindowName $ ".ItemRegistrationList_Wnd.ItemRegistrationList_ItemWnd");
	Registration_Btn = GetButtonHandle(m_WindowName $ ".ItemRegistrationList_Wnd.Registration_Btn");
	InitItemWnds();
	SetScript_UIControlNeedItemDialog();
	RewardItem_ItemWnd = GetItemWindowHandle(m_WindowName $ ".PopupDetailsContents.RewardItem_ItemWnd");
	RewardSkill_ItemWnd = GetItemWindowHandle(m_WindowName $ ".PopupDetailsContents.RewardSkill_ItemWnd");
	Reward_Btn = GetButtonHandle(m_WindowName $ ".PopupDetailsContents.Reward_Btn");
	Complete_Ani = GetAnimTextureHandle(m_WindowName $ ".PopupDetailsContents.Complete_Ani");
	GetItem_Ani = GetAnimTextureHandle(m_WindowName $ ".PopupDetailsContents.GetItem_Ani");
	GetSkill_Ani = GetAnimTextureHandle(m_WindowName $ ".PopupDetailsContents.GetSkill_Ani");
	Complete_Tex = GetTextureHandle(m_WindowName $ ".PopupDetailsContents.Complete_Tex");
	GetItem_Tex = GetTextureHandle(m_WindowName $ ".PopupDetailsContents.GetItem_Tex");
	GetSkill_Tex = GetTextureHandle(m_WindowName $ ".PopupDetailsContents.GetSkill_Tex");
	ItemAllow_Tex = GetTextureHandle(m_WindowName $ ".PopupDetailsContents.ItemAllow_Tex");
}

function InitItemWnds()
{
	local int i;

	for(i = 0; i < ItemNum; i++)
	{
		GetItemWndByIndex(i).SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
		GetNotEnoughEnchantedTextureHandle(i).SetTextureCtrlType(TCT_Control);
		GetNotEnoughEnchantedTextureHandle(i).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13666)));
	}
}

event OnLoad()
{
	Initialize();
}

event OnClickButton(string strID)
{
	local ItemInfo iInfo, inveniInfo;

	switch(strID)
	{
		case "ItemRegistrationListClose_Btn":
			HandleHideItemRegistrationList();
			// End:0x18E
			break;
		case "Ok_Btn":
		case "Close_Btn":
			collectionSystemScript.SetState(collectionSystemScript.collectionState.Sub);
			break;
		// End:0x13E
		case "Registration_Btn":
			needItemDialogScript.setInit(GetSystemString(13493), 0, 0, 0, true);
			needItemDialogScript.StartNeedItemList();
			// End:0xC1
			if(ItemRegistrationList_ItemWnd.GetSelectedNum() < 0)
			{
				return;
			}
			ItemRegistrationList_ItemWnd.GetSelectedItem(iInfo);
			NeedItemDialogShow();
			class'UIDATA_INVENTORY'.static.FindItem(iInfo.Id.ServerID, inveniInfo);
			needItemDialogScript.AddNeeItemInfo(iInfo, iInfo.Reserved64, inveniInfo.ItemNum);
			needItemDialogScript.EndNeedItemList();
			CheckRegistBtn();
			// End:0x18E
			break;
		// End:0x18B
		case "Reward_Btn":
			class'UICommonAPI'.static.DialogSetID(9999);
			class'UICommonAPI'.static.DialogSetDefaultCancle();
			DialogShow(DialogModalType_Modal, DialogType_OKCancel, GetSystemString(13510), string(self));
			break;
	}
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x18
		case 1710:
			HandleDialogOK();
			// End:0x1B
			break;
	}
}

event OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
	switch(a_WindowHandle)
	{
		// End:0x3C
		case Complete_Ani:
			// End:0x2A
			if(isCompleted)
			{
				Complete_Tex.ShowWindow();
			}
			else
			{
				Complete_Tex.HideWindow();
			}
			// End:0x73
			break;
		// End:0x56
		case GetItem_Ani:
			GetItem_Tex.ShowWindow();
			// End:0x73
			break;
		// End:0x70
		case GetSkill_Ani:
			GetSkill_Tex.ShowWindow();
			// End:0x73
			break;
		// End:0xFFFF
	}
}

event OnShow()
{
	Init();
}

event OnMouseOver(WindowHandle W)
{
	local string wndname, Id;
	local Rect rectWnd;
	local array<ItemInfo> replaceiInfos;
	local CollectionData cdata;

	wndname = W.GetWindowName();
	// End:0x6A
	if(GetStringIDFromBtnName(wndname, "Item_ItemWnd", Id))
	{
		// End:0x67
		if(GetItemWndByIndex(int(Id)).IsEnableWindow())
		{
			GetOverTextureHandle(int(Id)).ShowWindow();
		}
	}
	else
	{
		// End:0x110
		if(GetStringIDFromBtnName(wndname, "ItemReplace_Btn", Id))
		{
			// End:0xAE
			if(! collectionSystemScript.API_GetCollectionData(collectionid, cdata))
			{
				return;
			}
			// End:0x110
			if(GetReplaceItems(cdata, int(Id), replaceiInfos))
			{
				rectWnd = GetItemReplace_Btn(int(Id)).GetRect();
				ShowContextMenu(rectWnd.nX + rectWnd.nWidth, rectWnd.nY, replaceiInfos);
			}
		}
	}
}

event OnMouseOut(WindowHandle W)
{
	local string wndname, Id;
	local UIControlContextMenu ContextMenu;

	wndname = W.GetWindowName();
	if(GetStringIDFromBtnName(wndname, "Item_ItemWnd", Id))
	{
		GetOverTextureHandle(int(Id)).HideWindow();
	}
	else if(GetStringIDFromBtnName(wndname, "ItemReplace_Btn", Id))
	{
		ContextMenu = class'UIControlContextMenu'.static.GetInstance();
		ContextMenu.Hide();
	}
}

event OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	switch(a_hItemWindow.GetWindowName())
	{
		// End:0x56
		case "ItemRegistrationList_ItemWnd":
			// End:0x53
			if(CheckRegistBtn())
			{
				OnClickButton("Registration_Btn");
			}
			break;
	}
}

event OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	a_hItemWindow.SetSelectedNum(a_Index);
	switch(a_hItemWindow.GetWindowName())
	{
		case "ItemRegistrationList_ItemWnd":
			OnDBClickItemWithHandle(a_hItemWindow, a_Index);
			break;
	}
}

event OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	if(a_hItemWindow.GetWindowName() == "ItemRegistrationList_ItemWnd")
	{
		CheckRegistBtn();
	}
	else
	{
		HandleBtnClick(a_hItemWindow.GetWindowName());
	}
}

function bool CheckRegistBtn()
{
	local ItemInfo iInfo;

	if(! ItemRegistrationList_ItemWnd.GetSelectedItem(iInfo))
	{
		return false;
	}
	if(needItemDialogScript.Me.IsShowWindow() || iInfo.bDisabled == 1)
	{
		Registration_Btn.DisableWindow();
	}
	else
	{
		Registration_Btn.EnableWindow();
		return true;
	}
	return false;
}

function HandleBtnClick(string strID)
{
	local string Id;
	local ItemInfo iInfo;

	if(GetStringIDFromBtnName(strID, "Item_ItemWnd", Id))
	{
		currentSlotID = int(Id);
		GetItemWndByIndex(currentSlotID).GetSelectedItem(iInfo);
		if(iInfo.bDisabled == 0)
		{
			return;
		}
		HndleShowItemRegistrationList();
	}
}

function SetReplaceTooltip(CollectionData cdata, int SlotID)
{
	local array<ItemInfo> replaceiInfos;

	if(GetReplaceItems(cdata, SlotID, replaceiInfos))
	{
		GetItemReplace_Btn(SlotID).ShowWindow();
		GetItemReplace_Tex(SlotID).ShowWindow();
	}
	else
	{
		GetItemReplace_Btn(SlotID).HideWindow();
		GetItemReplace_Tex(SlotID).HideWindow();
	}
}

function bool SetDetails()
{
	local int i;
	local CollectionInfo cInfo;
	local CollectionData cdata;
	local array<ItemInfo> iIonfos, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList;
	local ItemInfo iInfo;
	local SkillInfo SkillInfo;
	local bool canregist;

	isCompleted = false;
	Complete_Ani.Stop();
	Complete_Ani.HideWindow();
	Complete_Tex.HideWindow();
	GetItem_Ani.HideWindow();
	GetSkill_Ani.HideWindow();
	GetItem_Tex.HideWindow();
	GetSkill_Tex.HideWindow();
	collectionid = collectionSystemSubScript.GetSelectedCollectionID();
	if(! collectionSystemScript.API_GetCollectionInfo(collectionid, cInfo))
	{
		return false;
	}
	if(! collectionSystemScript.API_GetCollectionData(collectionid, cdata))
	{
		return false;
	}
	GetTextBoxHandle(m_WindowName $ ".PopupDetailsContents.DetailsTitle_Txt").SetText(cdata.collection_name);
	GetTextBoxHandle(m_WindowName $ ".PopupDetailsContents.Period_Txt").SetText(GetEndDateTime(cdata.endDateTime));
	GetTextBoxHandle(m_WindowName $ ".PopupDetailsContents.CollectionEffect_Txt").SetText(collectionSystemSubScript.GetOptionByOptionID(cdata.option_id));
	if(cdata.Period > 0)
	{
		GetTextBoxHandle(m_WindowName $ ".PopupDetailsContents.Time_Txt").SetText(GetRemainTimeString(cdata.Period, cInfo.RemainTime));
		if(cInfo.RemainTime > 0)
		{
			GetTextBoxHandle(m_WindowName $ ".PopupDetailsContents.Time_Txt").SetTextColor(getInstanceL2Util().Yellow);
		}
		else
		{
			GetTextBoxHandle(m_WindowName $ ".PopupDetailsContents.Time_Txt").SetTextColor(getInstanceL2Util().Gray);
		}
		GetTextureHandle(m_WindowName $ ".PopupDetailsContents.Time_Tex").ShowWindow();
	}
	else
	{
		GetTextBoxHandle(m_WindowName $ ".PopupDetailsContents.Time_Txt").SetText("");
		GetTextureHandle(m_WindowName $ ".PopupDetailsContents.Time_Tex").HideWindow();
	}
	isCompleted = collectionSystemSubScript.GetItemList(cInfo, cdata, iIonfos);

	for(i = 0; i < iIonfos.Length; i++)
	{
		GetItemWndByIndex(i).Clear();
		GetItemWndByIndex(i).AddItem(iIonfos[i]);
		GetItemWndByIndex(i).EnableWindow();
		GetItemRegistrationTextureHandle(i).HideWindow();
		GetNotEnoughEnchantedTextureHandle(i).HideWindow();
		GetOverEnchantedTextureHandle(i).HideWindow();
		SetReplaceTooltip(cdata, i);
		GetOverTextureHandle(i).HideWindow();
		notEnoughEnchantedList.Length = 0;
		haveNotEnoughList.Length = 0;
		overNeedEnchantList.Length = 0;
		if(cInfo.ItemInfo[i].nItemClassID > 0)
		{
			continue;
		}
		canregist = CanRegistration(cdata, i, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList);
		if(canregist)
		{
			Debug("CanRegistration" @ string(i) @ string(notEnoughEnchantedList.Length));
			GetItemRegistrationTextureHandle(i).ShowWindow();
			continue;
		}
		// End:0x4BF
		if(notEnoughEnchantedList.Length > 0)
		{
			Debug(("notEnoughEnchantedList.length" @ string(i)) @ string(notEnoughEnchantedList.Length));
			GetNotEnoughEnchantedTextureHandle(i).ShowWindow();
			continue;
		}
		// End:0x4E0
		if(haveNotEnoughList.Length > 0)
		{
			Debug(("haveNotEnoughList.length" @ string(i)) @ string(haveNotEnoughList.Length));
			GetNotEnoughEnchantedTextureHandle(i).ShowWindow();
			continue;
		}
		if(overNeedEnchantList.Length > 0)
		{
			Debug(("overNeedEnchantList.length" @ string(i)) @ string(overNeedEnchantList.Length));
			GetOverEnchantedTextureHandle(i).ShowWindow();
		}
	}

	for(i = i; i < ItemNum; i++)
	{
		GetItemWndByIndex(i).Clear();
		GetItemWndByIndex(i).DisableWindow();
		GetItemReplace_Btn(i).HideWindow();
		GetItemReplace_Tex(i).HideWindow();
		GetOverTextureHandle(i).HideWindow();
		GetItemRegistrationTextureHandle(i).HideWindow();
		GetNotEnoughEnchantedTextureHandle(i).HideWindow();
		GetOverEnchantedTextureHandle(i).HideWindow();
	}
	RewardItem_ItemWnd.Clear();
	RewardSkill_ItemWnd.Clear();
	// End:0x672
	if(cdata.RewardItems.Length > 0)
	{
		class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(cdata.RewardItems[0].ItemID), iInfo);
		iInfo.ItemNum = cdata.RewardItems[0].ItemCount;
		// End:0x636
		if(iInfo.ItemNum > 0)
		{
			iInfo.bShowCount = true;
		}
		RewardItem_ItemWnd.AddItem(iInfo);
		// End:0x672
		if(isCompleted && cInfo.isReward)
		{
			GetItem_Tex.ShowWindow();
		}
	}
	// End:0x6E3
	if(cdata.RewardSkills.Length > 0)
	{
		GetSkillInfo(cdata.RewardSkills[0].SkillID, cdata.RewardSkills[0].SkillLevel, 0, SkillInfo);
		RewardSkill_ItemWnd.AddItem(getItemInfoBySkillInfo(SkillInfo));
		// End:0x6E3
		if(isCompleted)
		{
			GetSkill_Tex.ShowWindow();
		}
	}
	// End:0x6FB
	if(isCompleted)
	{
		Complete_Tex.ShowWindow();
	}
	if((cdata.RewardItems.Length > 0 && ! cInfo.isReward) && isCompleted)
	{
		Reward_Btn.EnableWindow();
	}
	else
	{
		Reward_Btn.DisableWindow();
	}
	NeedItemDialogHide();
	return true;
}

function HndleShowItemRegistrationList()
{
	local int i;
	local array<ItemInfo> iInfos, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList;

	ItemRegistrationList_ItemWnd.Clear();
	ItemRegistrationList_Wnd.ShowWindow();
	class'UIAPI_WINDOW'.static.SetAnchor(m_WindowName $ ".PopupDetailsContents.ItemAllow_Tex", m_WindowName $ ".PopupDetailsContents.Item_ItemWnd" $ Int2Str2(currentSlotID), "BottomRight", "BottomRight", 8, 8);
	ItemAllow_Tex.ShowWindow();
	iInfos = GetCanRegisrationsCurrentSlot(currentSlotID, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList);

	for(i = 0; i < iInfos.Length; i++)
	{
		iInfos[i].bDisabled = 0;
		ItemRegistrationList_ItemWnd.AddItem(iInfos[i]);
	}

	for(i = 0; i < notEnoughEnchantedList.Length; i++)
	{
		notEnoughEnchantedList[i].bDisabled = 1;
		ItemRegistrationList_ItemWnd.AddItem(notEnoughEnchantedList[i]);
	}

	for(i = 0; i < haveNotEnoughList.Length; i++)
	{
		haveNotEnoughList[i].bDisabled = 1;
		ItemRegistrationList_ItemWnd.AddItem(haveNotEnoughList[i]);
	}

	// End:0x280 [Loop If]
	for(i = 0; i < overNeedEnchantList.Length; i++)
	{
		overNeedEnchantList[i].bDisabled = 1;
		ItemRegistrationList_ItemWnd.AddItem(overNeedEnchantList[i]);
	}

	Registration_Btn.DisableWindow();
}

function HandleHideItemRegistrationList()
{
	ItemRegistrationList_Wnd.HideWindow();
	ItemAllow_Tex.HideWindow();
	NeedItemDialogHide();
}

function ItemWindowHandle GetItemWndByIndex(int Index)
{
	return GetItemWindowHandle(m_WindowName $ ".PopupDetailsContents.Item_ItemWnd" $ Int2Str2(Index));
}

function ButtonHandle GetItemReplace_Btn(int Index)
{
	return GetButtonHandle(m_WindowName $ ".PopupDetailsContents.ItemReplace_Btn" $ Int2Str2(Index));
}

function TextureHandle GetItemReplace_Tex(int Index)
{
	return GetTextureHandle(m_WindowName $ ".PopupDetailsContents.ItemReplace_Tex" $ Int2Str2(Index));
}

function TextureHandle GetOverTextureHandle(int Index)
{
	return GetTextureHandle(m_WindowName $ ".PopupDetailsContents.Item" $ Int2Str2(Index) $ "_Over_tex");
}

function TextureHandle GetItemRegistrationTextureHandle(int Index)
{
	return GetTextureHandle(m_WindowName $ ".PopupDetailsContents.ItemRegistration_Tex" $ Int2Str2(Index));
}

function TextureHandle GetNotEnoughEnchantedTextureHandle(int Index)
{
	return GetTextureHandle(m_WindowName $ ".PopupDetailsContents.ItemInsufficient_Tex" $ Int2Str2(Index));
}

function TextureHandle GetOverEnchantedTextureHandle(int Index)
{
	return GetTextureHandle(m_WindowName $ ".PopupDetailsContents.ItemOverEnchant_Tex" $ Int2Str2(Index));	
}

function ShowContextMenu(int X, int Y, array<ItemInfo> iItemInfos)
{
	local int i;
	local UIControlContextMenu ContextMenu;

	ContextMenu = class'UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();

	for(i = 0; i < iItemInfos.Length; i++)
	{
		ContextMenu.MenuAddRecord(MenuRecord(iItemInfos[i]));
		ContextMenu.menuObjects[i].iconHeight = 32;
		ContextMenu.menuObjects[i].iconWidth = 32;
		ContextMenu.menuObjects[i].Icon = iItemInfos[i].IconName;
		ContextMenu.menuObjects[i].Name = GetItemNameAll(iItemInfos[i]);
	}
	ContextMenu.SetMenuHeight(36);
	ContextMenu.Show(X, Y, string(self));
}

function RichListCtrlRowData MenuRecord(ItemInfo iInfo)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 1;
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, iInfo, 32, 32);
	addRichListCtrlString(Record.cellDataList[0].drawitems, GetItemNameAll(iInfo), getInstanceL2Util().BrightWhite, false, 2, 2);
	addRichListCtrlString(Record.cellDataList[0].drawitems, "x" $ string(iInfo.ItemNum), getInstanceL2Util().BrightWhite, true, 35, 1);
	return Record;
}

function Init()
{
	Complete_Ani.Stop();
	Complete_Ani.HideWindow();
	GetItem_Tex.HideWindow();
	GetSkill_Tex.HideWindow();
	HandleHideItemRegistrationList();
	SetDetails();
}

function SetScript_UIControlNeedItemDialog()
{
	local WindowHandle ItemRegistrationConfirm_Wnd;

	ItemRegistrationConfirm_Wnd = GetWindowHandle(m_WindowName $ ".ItemRegistrationConfirm_Wnd");
	ItemRegistrationConfirm_Wnd.SetScript("UIControlNeedItemDialog");
	needItemDialogScript = UIControlNeedItemDialog(ItemRegistrationConfirm_Wnd.GetScript());
	needItemDialogScript.SetWindow(m_WindowName $ ".ItemRegistrationConfirm_Wnd");
	needItemDialogScript.DelegateOnClickCancleButton = OnClickHideDialog;
	needItemDialogScript.DelegateOnClickOkButton = OnClickOkDialog;
}

function OnClickHideDialog(optional int nDialogKey)
{
	NeedItemDialogHide();
}

function OnClickOkDialog(optional int nDialogKey)
{
	local ItemInfo iInfo;

	NeedItemDialogHide();
	ItemRegistrationList_ItemWnd.GetSelectedItem(iInfo);
	collectionSystemScript.API_C_EX_COLLECTION_REGISTER(collectionid, currentSlotID, iInfo.Id.ServerID);
}

function HandleCollectionRegisted(int tmpCollectionID)
{
	// End:0x29
	if(collectionid != tmpCollectionID)
	{
		collectionSystemScript.SetState(collectionSystemScript.collectionState.Sub);
	}
	Init();
}

function HandleCompleted(int tmpCollectionID)
{
	local CollectionData cdata;

	// End:0x29
	if(collectionid != tmpCollectionID)
	{
		collectionSystemScript.SetState(collectionSystemScript.collectionState.Sub);
	}
	Init();
	collectionSystemScript.API_GetCollectionData(tmpCollectionID, cdata);
	Complete_Tex.HideWindow();
	Complete_Ani.ShowWindow();
	Complete_Ani.Stop();
	Complete_Ani.SetLoopCount(1);
	Complete_Ani.Play();
	// End:0xE2
	if(cdata.RewardSkills.Length > 0)
	{
		GetSkill_Ani.ShowWindow();
		GetSkill_Ani.Stop();
		GetSkill_Ani.SetLoopCount(1);
		GetSkill_Ani.Play();
	}
}

function HandleReceiveReward(int tmpCollectionID)
{
	// End:0x29
	if(collectionid != tmpCollectionID)
	{
		collectionSystemScript.SetState(collectionSystemScript.collectionState.Sub);
	}
	Init();
	GetItem_Tex.HideWindow();
	GetItem_Ani.ShowWindow();
	GetItem_Ani.Stop();
	GetItem_Ani.SetLoopCount(1);
	GetItem_Ani.Play();
}

function bool CanRegistration(CollectionData cdata, int SlotID, out array<ItemInfo> notEnoughEnchantedList, out array<ItemInfo> haveNotEnoughList, out array<ItemInfo> overNeedEnchantList)
{
	local array<ItemInfo> iInfos;

	iInfos = GetCanRegisrations(cdata, SlotID, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList);
	return iInfos.Length > 0;
}

function array<ItemInfo> GetCanRegisrationsCurrentSlot(int SlotID, out array<ItemInfo> notEnoughEnchantedList, out array<ItemInfo> haveNotEnoughList, out array<ItemInfo> overNeedEnchantList)
{
	local array<ItemInfo> iInfos;
	local CollectionData cdata;

	// End:0x24
	if(! collectionSystemScript.API_GetCollectionData(collectionid, cdata))
	{
		return iInfos;
	}
	iInfos = GetCanRegisrations(cdata, SlotID, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList);
	return iInfos;
}

function array<ItemInfo> GetCanRegisrations(CollectionData cdata, int SlotID, out array<ItemInfo> notEnoughEnchantedList, out array<ItemInfo> haveNotEnoughList, out array<ItemInfo> overNeedEnchantList)
{
	local int i, j;
	local array<ItemInfo> iInfos, iInfosResult;
	local CollectionRegistFailReason failReason;
	local bool canregist;

	notEnoughEnchantedList.Length = 0;
	haveNotEnoughList.Length = 0;
	overNeedEnchantList.Length = 0;

	for(i = 0; i < cdata.SlotItems.Length; i++)
	{
		// End:0x4E
		if(cdata.SlotItems[i].SlotID != SlotID)
		{
			continue;
		}
		iInfos.Length = 0;
		class'UIDATA_INVENTORY'.static.FindItemByClassID(cdata.SlotItems[i].ItemID, iInfos);

		for(j = 0; j < iInfos.Length; j++)
		{
			canregist = collectionSystemScript.API_IsCollectionRegistEnableItemWithReason(iInfos[j].Id, cdata.collection_ID, SlotID, failReason);
			// End:0xF0
			if(! canregist && failReason == CRFR_None)
			{
				// [Explicit Continue]
				continue;
			}
			iInfos[j].Reserved64 = cdata.SlotItems[i].ItemCount;
			switch(failReason)
			{
				// End:0x13F
				case CRFR_UnderNeedEnchant:
					notEnoughEnchantedList[notEnoughEnchantedList.Length] = iInfos[j];
					break;
				// End:0x15F
				case CRFR_HaveNotEnoughItem:
					haveNotEnoughList[haveNotEnoughList.Length] = iInfos[j];
					break;
				case CRFR_OverNeedEnchant/*3*/:
					overNeedEnchantList[overNeedEnchantList.Length] = iInfos[j];
					// End:0x2A1
					break;
				default:
					iInfosResult[iInfosResult.Length] = iInfos[j];
					break;
			}
		}
	}
	return iInfosResult;
}

function bool GetReplaceItems(CollectionData cdata, int SlotID, out array<ItemInfo> replaceInfos)
{
	local int i;
	local ItemInfo iInfo;

	for(i = 0; i < cdata.SlotItems.Length; i++)
	{
		// End:0x84
		if(cdata.SlotItems[i].SlotID == SlotID)
		{
			// End:0x84
			if(cdata.SlotItems[i].Representative == false)
			{
				getSlotItemInfo(cdata.SlotItems[i], iInfo);
				replaceInfos[replaceInfos.Length] = iInfo;
			}
		}
	}
	return replaceInfos.Length > 0;
}

function bool getSlotItemInfo(CollectionSlotItem cSItem, out ItemInfo slotItemInfo)
{
	// End:0x2B
	if(! class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(cSItem.ItemID), slotItemInfo))
	{
		return false;
	}
	slotItemInfo.IsBlessedItem = false;
	slotItemInfo.Enchanted = cSItem.EnchantCondition;
	slotItemInfo.ItemNum = cSItem.ItemCount;
	slotItemInfo.BlessPanelDrawType = EBlessPanelDrawType(cSItem.BlessCondition);
	slotItemInfo.bShowCount = IsStackableItem(slotItemInfo.ConsumeType);
	return true;
}

function NeedItemDialogHide()
{
	needItemDialogScript.Hide();
	ItemRegistrationList_ItemWnd.EnableWindow();
	GetButtonHandle(m_WindowName $ ".ItemRegistrationList_Wnd.ItemRegistrationListClose_Btn").EnableWindow();
	GetButtonHandle(m_WindowName $ ".PopupDetailsContents.Close_Btn").EnableWindow();
	GetButtonHandle(m_WindowName $ ".PopupDetailsContents.OK_Btn").EnableWindow();
	CheckRegistBtn();
}

function NeedItemDialogShow()
{
	needItemDialogScript.Show();
	ItemRegistrationList_ItemWnd.DisableWindow();
	GetButtonHandle(m_WindowName $ ".ItemRegistrationList_Wnd.ItemRegistrationListClose_Btn").DisableWindow();
	GetButtonHandle(m_WindowName $ ".PopupDetailsContents.Close_Btn").DisableWindow();
	GetButtonHandle(m_WindowName $ ".PopupDetailsContents.OK_Btn").DisableWindow();
	CheckRegistBtn();
}

function OnClickESC()
{
	// End:0x24
	if(needItemDialogScript.Me.IsShowWindow())
	{
		NeedItemDialogHide();
	}
	else
	{
		// End:0x3F
		if(ItemRegistrationList_Wnd.IsShowWindow())
		{
			HandleHideItemRegistrationList();
		}
		else
		{
			collectionSystemScript.SetState(collectionSystemScript.collectionState.Sub);
		}
	}
}

function ItemInfo getItemInfoBySkillInfo(SkillInfo rSkilInfo)
{
	local ItemInfo infItem;

	infItem.Id.ClassID = rSkilInfo.SkillID;
	infItem.Level = 1;
	infItem.SubLevel = 0;
	infItem.Name = rSkilInfo.SkillName;
	infItem.IconName = rSkilInfo.TexName;
	infItem.IconPanel = rSkilInfo.IconPanel;
	infItem.Description = rSkilInfo.SkillDesc;
	infItem.ShortcutType = 2;
	infItem.ItemType = 1;
	return infItem;
}

function string Int2Str2(int i)
{
	// End:0x19
	if(i < 10)
	{
		return "0" $ string(i);
	}
	return string(i);
}

function bool GetStringIDFromBtnName(string btnName, string someString, out string strID)
{
	// End:0x17
	if(! CheckBtnName(btnName, someString))
	{
		return false;
	}
	strID = Mid(btnName, Len(someString));
	return true;
}

function bool CheckBtnName(string btnName, string someString)
{
	return Left(btnName, Len(someString)) == someString;
}

function bool ChkSerVer()
{
	return getInstanceUIData().getIsLiveServer();
}

function string GetEndDateTime(string endDateTime)
{
	local array<string> endDatatimes;

	// End:0x0F
	if(endDateTime == "")
	{
		return "";
	}
	Split(endDateTime, "T", endDatatimes);
	return endDatatimes[0] @ GetSystemString(13714);
}

function string GetRemainTimeString(int Period, int RemainTime)
{
	local string periodStr, dateString, timeString;

	// End:0x41
	if(((Period / 60) / 60) > 24)
	{
		periodStr = string(((Period / 60) / 60) / 24);
		dateString = GetSystemString(1109);
	}
	else
	{
		periodStr = string((Period / 60) / 60);
		dateString = GetSystemString(1110);
	}
	// End:0xCD
	if(RemainTime > 0)
	{
		timeString = util.getTimeStringBySec2(RemainTime);
		// End:0xA8
		if(timeString != "")
		{
			timeString = "-" @ timeString;
		}
		return MakeFullSystemMsg(GetSystemMessage(13314), periodStr $ dateString) @ timeString;
	}
	return MakeFullSystemMsg(GetSystemMessage(13314), periodStr $ dateString);
}

defaultproperties
{
}
