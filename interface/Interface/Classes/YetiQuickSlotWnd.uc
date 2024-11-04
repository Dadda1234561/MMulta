//================================================================================
// YetiQuickSlotWnd.
//================================================================================

class YetiQuickSlotWnd extends UICommonAPI;

struct ReturningSpellbook
{
	var string Name;
	var INT64 totalItemNum;
	var array<int> nItemIDArray;
};

var WindowHandle Me;
var ButtonHandle ReturnScrollSlot_Btn;
var ButtonHandle ReturnScrollSlotSetting_Btn;
var ButtonHandle ViewPoint_Reset_Btn;
var ButtonHandle ViewPoint_180_Btn;
var AnimTextureHandle ToggleEffect_Anim;
var ButtonHandle AutoHunt_All_Btn;
var TextBoxHandle ReturnScrollSlot_num;
var WindowHandle ReturnScrollSubWnd;
var ButtonHandle ReturnScroll_Town01_Btn;
var ButtonHandle ReturnScroll_Town02_Btn;
var ButtonHandle ReturnScroll_Town03_Btn;
var ButtonHandle ReturnScroll_Town04_Btn;
var AutoUseItemWnd AutoUseItemWndScript;
var AutoPotionWnd AutoPotionWndScript;
var AutomaticPlay AutomaticPlayScript;
var array<ReturningSpellbook> returningSpellbookArray;
var int CURRENTITEMINDEX;
var bool bAutoBtnToggle;

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_SetMaxCount);
	RegisterEvent(EV_Restart);
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle("YetiQuickSlotWnd");
	ReturnScrollSlotSetting_Btn = GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSlotSetting_Btn");
	ReturnScrollSlot_Btn = GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSlot_Btn");
	ReturnScrollSlot_num = GetTextBoxHandle("YetiQuickSlotWnd.ReturnScrollSlot_num");
	ViewPoint_Reset_Btn = GetButtonHandle("YetiQuickSlotWnd.ViewPoint_Reset_Btn");
	ViewPoint_180_Btn = GetButtonHandle("YetiQuickSlotWnd.ViewPoint_180_Btn");
	AutoHunt_All_Btn = GetButtonHandle("YetiQuickSlotWnd.AutoHunt_All_Btn");
	ToggleEffect_Anim = GetAnimTextureHandle("YetiQuickSlotWnd.ToggleEffect_Anim");
	ReturnScrollSubWnd = GetWindowHandle("YetiQuickSlotWnd.ReturnScrollSubWnd");
	ReturnScroll_Town01_Btn = GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town01_Btn");
	ReturnScroll_Town02_Btn = GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town02_Btn");
	ReturnScroll_Town03_Btn = GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town03_Btn");
	ReturnScroll_Town04_Btn = GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town04_Btn");
	ReturnScroll_Town01_Btn.SetTooltipType("text");
	ReturnScroll_Town02_Btn.SetTooltipType("text");
	ReturnScroll_Town03_Btn.SetTooltipType("text");
	ReturnScroll_Town04_Btn.SetTooltipType("text");
	AutoUseItemWndScript = AutoUseItemWnd(GetScript("AutoUseItemWnd"));
	AutoPotionWndScript = AutoPotionWnd(GetScript("AutoPotionWnd"));
	AutomaticPlayScript = AutomaticPlay(GetScript("AutomaticPlay"));
}

function Load()
{
	bAutoBtnToggle = false;
	setServerTypeSetting();
}

function setServerTypeSetting()
{
	returningSpellbookArray.Remove(0, returningSpellbookArray.Length);
	returningSpellbookArray.Length = 4;
	ReturnScroll_Town01_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13088)));
	if(getInstanceUIData().getIsLiveServer())
	{
		ReturnScroll_Town02_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13089)));
	}
	else
	{
		ReturnScroll_Town02_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13109)));
	}
	ReturnScroll_Town03_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13090)));
	ReturnScroll_Town04_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13091)));
	returningSpellbookArray[0].Name = GetSystemString(13088);
	if(getInstanceUIData().getIsLiveServer())
	{
		returningSpellbookArray[1].Name = GetSystemString(13089);
	}
	else
	{
		returningSpellbookArray[1].Name = GetSystemString(13109);
	}
	returningSpellbookArray[2].Name = GetSystemString(13090);
	returningSpellbookArray[3].Name = GetSystemString(13091);
	if(getInstanceUIData().getIsLiveServer())
	{
		setReturningSpellbookItemID(returningSpellbookArray[0].nItemIDArray, "736");
		setReturningSpellbookItemID(returningSpellbookArray[1].nItemIDArray, "1538,9156,33640");
		setReturningSpellbookItemID(returningSpellbookArray[2].nItemIDArray, "1829");
		setReturningSpellbookItemID(returningSpellbookArray[3].nItemIDArray, "1830");
	}
	else
	{
		setReturningSpellbookItemID(returningSpellbookArray[0].nItemIDArray, "736");
		setReturningSpellbookItemID(returningSpellbookArray[1].nItemIDArray, "91689,49500,49087");
		setReturningSpellbookItemID(returningSpellbookArray[2].nItemIDArray, "1829");
		setReturningSpellbookItemID(returningSpellbookArray[3].nItemIDArray, "1830");
	}
}

function setReturningSpellbookItemID(out array<int> nItemIDArray, string ArrayStr)
{
	local array<string> strItemIDArray;
	local int i;

	Split(ArrayStr,",",strItemIDArray);
	nItemIDArray.Remove (0,nItemIDArray.Length);
	
	for (i = 0; i < strItemIDArray.Length ; i++)
	{
		nItemIDArray.Insert(nItemIDArray.Length, 1);
		nItemIDArray[nItemIDArray.Length - 1] = int(strItemIDArray[i]);
	}
}

function OnShow()
{
	setServerTypeSetting();
	SetAutoMode();
	GetINIInt("YetiQuickSlotWnd", "a", CURRENTITEMINDEX, "WindowsInfo.ini");
	ReturnScrollSubWnd.HideWindow();
	syncInventory();
	setItemButtonByIndex(CURRENTITEMINDEX);
	if(getInstanceUIData().getIsLiveServer())
	{
		GetTextureHandle("YetiQuickSlotWnd.Check_AutoUseItemIcon").ShowWindow();
	}
	else
	{
		GetTextureHandle("YetiQuickSlotWnd.Check_AutoUseItemIcon").HideWindow();
	}
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_GameStart:
			setServerTypeSetting();
			break;
		case EV_AdenaInvenCount:
		case EV_SetMaxCount:
			syncInventory();
			break;
		case EV_Restart:
			bAutoBtnToggle = false;
			CURRENTITEMINDEX = -1;
			break;
	}
}

function syncInventory()
{
	local string itemCountStr;

	if(! Me.IsShowWindow())
	{
		return;
	}
	setItemButton(1, returningSpellbookArray[0].nItemIDArray, returningSpellbookArray[0].totalItemNum);
	setItemButton(2, returningSpellbookArray[1].nItemIDArray, returningSpellbookArray[1].totalItemNum);
	setItemButton(3, returningSpellbookArray[2].nItemIDArray, returningSpellbookArray[2].totalItemNum);
	setItemButton(4, returningSpellbookArray[3].nItemIDArray, returningSpellbookArray[3].totalItemNum);
	if(CURRENTITEMINDEX > -1)
	{
		if(returningSpellbookArray[CURRENTITEMINDEX].totalItemNum > 99)
		{
			itemCountStr = "+99";
		}
		else
		{
			itemCountStr = string(returningSpellbookArray[CURRENTITEMINDEX].totalItemNum);
		}

		if(returningSpellbookArray[CURRENTITEMINDEX].totalItemNum <= 0)
		{
			ReturnScrollSlot_num.SetText("");
			GetTextureHandle("YetiQuickSlotWnd.ReturnScroll_ItemIcon").HideWindow();
			ReturnScrollSlot_Btn.ClearTooltip();
			ReturnScrollSlot_Btn.DisableWindow();
			CURRENTITEMINDEX = -1;
		}
		else
		{
			ReturnScrollSlot_num.SetText(itemCountStr);
			ReturnScrollSlot_Btn.EnableWindow();
		}
	}
}

function setItemButton(int buttonIndex, array<int> nItemIDArray, out INT64 ItemCount)
{
	local array<ItemInfo> itemInfoArray;
	local string itemCountStr;
	local int i;

	ItemCount = 0;
	for ( i = 0;i < nItemIDArray.Length;i++ )
	{
		itemInfoArray.Remove(0, itemInfoArray.Length);
		class'UIDATA_INVENTORY'.static.FindItemByClassID(nItemIDArray[i], itemInfoArray);
		if(itemInfoArray.Length > 0)
		{
			ItemCount = ItemCount + itemInfoArray[0].ItemNum;
		}
	}
	if(ItemCount > 0)
	{
		GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex) $ "_Btn").EnableWindow();
		if(ItemCount > 99)
		{
			itemCountStr = "+99";
		}
		else
		{
			itemCountStr = string(ItemCount);
		}
		GetTextBoxHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex) $ "_num").SetText(itemCountStr);
		if(ItemCount > 0)
		{
			GetTextureHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex) $ "_ItemIcon").ShowWindow();
		}
		else
		{
			GetTextureHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex) $ "_ItemIcon").HideWindow();
		}
	}
	else
	{
		GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex) $ "_Btn").DisableWindow();
		GetTextBoxHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex) $ "_num").SetText("");
		GetTextureHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex) $ "_ItemIcon").HideWindow();
	}
}

function string getReturnSpellBookTextureName (int i)
{
	if ( i == 0 )
	{
		return "L2UI_CT1.YetiWnd.736_Yeti";
	}
	else if ( i == 1 )
	{
		return "L2UI_CT1.YetiWnd.1538_Yeti";
	}
	else if ( i == 2 )
	{
		return "L2UI_CT1.YetiWnd.1829_Yeti";
	}
	return "L2UI_CT1.YetiWnd.1830_Yeti";
}

function setItemButtonByIndex(int Index)
{
	local string itemCountStr;

	if(returningSpellbookArray[Index].totalItemNum > 0)
	{
		if(returningSpellbookArray[Index].totalItemNum > int64(99))
		{
			itemCountStr = "+99";
		}
		else
		{
			itemCountStr = string(returningSpellbookArray[Index].totalItemNum);
		}
		ReturnScrollSlot_num.SetText(itemCountStr);
		ReturnScrollSubWnd.HideWindow();
		GetTextureHandle("YetiQuickSlotWnd.ReturnScroll_ItemIcon").SetTexture(getReturnSpellBookTextureName(Index));
		GetTextureHandle("YetiQuickSlotWnd.ReturnScroll_ItemIcon").ShowWindow();
		ReturnScrollSlot_Btn.SetTooltipCustomType(MakeTooltipSimpleText(returningSpellbookArray[Index].Name));
		ReturnScrollSlot_Btn.EnableWindow();
	}
	else
	{
		ReturnScrollSlot_num.SetText("");
		GetTextureHandle("YetiQuickSlotWnd.ReturnScroll_ItemIcon").HideWindow();
		ReturnScrollSlot_Btn.ClearTooltip();
		CURRENTITEMINDEX = -1;
		ReturnScrollSlot_Btn.DisableWindow();
	}
}

function setPlayAutoTargetActiveAnim ()
{
	if(!Me.IsShowWindow())
	{
		return;
	}
	// End:0xBA
	if(IsAutoMode())
	{
		AnimTexturePlay(ToggleEffect_Anim, true);
		AutoHunt_All_Btn.SetTexture("L2UI_CT1.YetiWnd.YetiAuto_ON_BTN_Normal", "L2UI_CT1.YetiWnd.YetiAuto_ON_BTN_Down","L2UI_CT1.YetiWnd.YetiAuto_ON_BTN_Over");
		eachAutoModeToggleTexture();
	}
	else
	{
		AnimTextureStop(ToggleEffect_Anim, true);
		AutoHunt_All_Btn.SetTexture("L2UI_CT1.YetiWnd.YetiAuto_OFF_BTN_Normal","L2UI_CT1.YetiWnd.YetiAuto_OFF_BTN_Down","L2UI_CT1.YetiWnd.YetiAuto_OFF_BTN_Over");
		GetTextureHandle("YetiQuickSlotWnd.Check_AutoTargetIcon").SetTexture("L2UI_CT1.YetiWnd.Yeti_AutoTargetIcon_OFF");
		GetTextureHandle("YetiQuickSlotWnd.Check_AutopotionIcon").SetTexture("L2UI_CT1.YetiWnd.Yeti_AutopotionIcon_OFF");
		GetTextureHandle("YetiQuickSlotWnd.Check_AutoUseItemIcon").SetTexture("L2UI_CT1.YetiWnd.Yeti_AutoUseItemIcon_OFF");
	}
}

function eachAutoModeToggleTexture()
{
	if(AutoUseItemWndScript.getUseAutoTarget() || AutomaticPlayScript.getUseAutoTarget())
	{
		GetTextureHandle("YetiQuickSlotWnd.Check_AutoTargetIcon").SetTexture("L2UI_CT1.YetiWnd.Yeti_AutoTargetIcon_ON");
	}
	else
	{
		GetTextureHandle("YetiQuickSlotWnd.Check_AutoTargetIcon").SetTexture("L2UI_CT1.YetiWnd.Yeti_AutoTargetIcon_OFF");
	}
	if(AutoUseItemWndScript.getActivateAll() || AutomaticPlayScript.getActivateAll())
	{
		GetTextureHandle("YetiQuickSlotWnd.Check_AutoUseItemIcon").SetTexture("L2UI_CT1.YetiWnd.Yeti_AutoUseItemIcon_ON");
	}
	else
	{
		GetTextureHandle("YetiQuickSlotWnd.Check_AutoUseItemIcon").SetTexture("L2UI_CT1.YetiWnd.Yeti_AutoUseItemIcon_OFF");
	}
	if(AutoPotionWndScript.getActiveAutoPotionSlot())
	{
		GetTextureHandle("YetiQuickSlotWnd.Check_AutopotionIcon").SetTexture("L2UI_CT1.YetiWnd.Yeti_AutopotionIcon_ON");
	}
	else
	{
		GetTextureHandle("YetiQuickSlotWnd.Check_AutopotionIcon").SetTexture("L2UI_CT1.YetiWnd.Yeti_AutopotionIcon_OFF");
	}
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "ReturnScrollSlot_Btn":
			OnReturnScrollSlot_BtnClick();
			break;
		case "ReturnScrollSlotSetting_Btn":
			OnReturnScrollSlotSetting_BtnClick();
			break;
		case "ViewPoint_Reset_Btn":
			OnViewPoint_Reset_BtnClick();
			break;
		case "ViewPoint_180_Btn":
			OnViewPoint_180_BtnClick();
			break;
		case "AutoHunt_All_Btn":
			OnAutoHunt_All_BtnClick(true);
			break;
		case "ReturnScroll_Town01_Btn":
		case "ReturnScroll_Town02_Btn":
		case "ReturnScroll_Town03_Btn":
		case "ReturnScroll_Town04_Btn":
			OnReturnScroll_Town_BtnClick(Name);
			break;
		case "Close_BTN":
			OnReturnScrollSlotSetting_BtnClick();
			break;
		default:
	}
}

function OnReturnScroll_Town_BtnClick(string buttonName)
{
	local string strID;
	local int Index;

	strID = Mid(buttonName, Len("ReturnScroll_Town0"), 1);
	Index = int(strID) - 1;
	CURRENTITEMINDEX = Index;
	SetINIInt("YetiQuickSlotWnd", "a", CURRENTITEMINDEX, "WindowsInfo.ini");
	setItemButtonByIndex(CURRENTITEMINDEX);
}

function OnReturnScrollSlot_BtnClick()
{
	TryUseItem();
}

function TryUseItem()
{
	local int i;
	local ItemInfo tmItemInfo;

	if(CURRENTITEMINDEX > -1)
	{
		for (i = 0; i < returningSpellbookArray[CURRENTITEMINDEX].nItemIDArray.Length; i++ )
		{
			if(getIInventemInfoByClassID(returningSpellbookArray[CURRENTITEMINDEX].nItemIDArray[i],tmItemInfo))
			{
				if(tmItemInfo.ItemNum > 0)
				{
					RequestUseItem(tmItemInfo.Id);
					break;
				}
			}
		}
	}
}

function bool getIInventemInfoByClassID(int ClassID, out ItemInfo outItemInfo)
{
	local array<ItemInfo> itemInfoArray;

	Class'UIDATA_INVENTORY'.static.FindItemByClassID(ClassID, itemInfoArray);
	if(itemInfoArray.Length > 0)
	{
		outItemInfo = itemInfoArray[0];
		return true;
	}
	return false;
}

function OnReturnScrollSlotSetting_BtnClick()
{
	if(ReturnScrollSubWnd.IsShowWindow())
	{
		ReturnScrollSubWnd.HideWindow();
	}
	else
	{
		ReturnScrollSubWnd.ShowWindow();
	}
}

function OnViewPoint_Reset_BtnClick()
{
	Class'ShortcutAPI'.static.ExecuteShortcutCommand("FixedDefaultCamera");
}

function OnViewPoint_180_BtnClick()
{
	Class'ShortcutAPI'.static.ExecuteShortcutCommand("TurnBack");
}

function OnAutoHunt_All_BtnClick(optional bool bUseAutoPostion)
{
	bAutoBtnToggle = !bAutoBtnToggle;
	if(getInstanceUIData().getIsLiveServer())
	{
		AutoUseItemWndScript.requestAutoPlay(bAutoBtnToggle);
		Class'ShortcutWndAPI'.static.RequestAutomaticUseItemActivateAll(bAutoBtnToggle);
	}
	else
	{
		AutomaticPlayScript.requestAutoPlay(bAutoBtnToggle);
	}
	if(bUseAutoPostion)
	{
		Class'ShortcutWndAPI'.static.RequestAutomaticUseItemActivate(AutoPotionWndScript.getAutoPotionSlotID(),bAutoBtnToggle);
	}
}

function bool IsAutoMode()
{
	local bool bAutoMode;

	if(AutoPotionWndScript.getActiveAutoPotionSlot() || AutoUseItemWndScript.getActivateAll() || AutoUseItemWndScript.getUseAutoTarget() || AutomaticPlayScript.getActivateAll() || AutomaticPlayScript.getUseAutoTarget())
	{
		bAutoMode = true;
	}
	return bAutoMode;
}

function SetAutoMode()
{
	if(IsAutoMode())
	{
		bAutoBtnToggle = true;
	}
	else
	{
		bAutoBtnToggle = false;
	}
	if(bAutoBtnToggle)
	{
		eachAutoModeToggleTexture();
		AnimTexturePlay(ToggleEffect_Anim, true);
		AutoHunt_All_Btn.SetTexture("L2UI_CT1.YetiWnd.YetiAuto_ON_BTN_Normal", "L2UI_CT1.YetiWnd.YetiAuto_ON_BTN_Down", "L2UI_CT1.YetiWnd.YetiAuto_ON_BTN_Over");
	}
	else
	{
		AnimTextureStop(ToggleEffect_Anim, true);
		AutoHunt_All_Btn.SetTexture("L2UI_CT1.YetiWnd.YetiAuto_OFF_BTN_Normal", "L2UI_CT1.YetiWnd.YetiAuto_OFF_BTN_Down", "L2UI_CT1.YetiWnd.YetiAuto_OFF_BTN_Over");
		GetTextureHandle("YetiQuickSlotWnd.Check_AutoTargetIcon").SetTexture("L2UI_CT1.YetiWnd.Yeti_AutoTargetIcon_OFF");
		GetTextureHandle("YetiQuickSlotWnd.Check_AutopotionIcon").SetTexture("L2UI_CT1.YetiWnd.Yeti_AutopotionIcon_OFF");
		GetTextureHandle("YetiQuickSlotWnd.Check_AutoUseItemIcon").SetTexture("L2UI_CT1.YetiWnd.Yeti_AutoUseItemIcon_OFF");
	}
}

defaultproperties
{
}
