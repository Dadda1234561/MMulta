class AutoPotionSubWndPet extends UICommonAPI;

var WindowHandle Me;
var string m_WindowName;
var TextBoxHandle use_Text;
var TextBoxHandle Percent_Text;
var SliderCtrlHandle HPSetting_SliderCtrl;
var ProgressCtrlHandle BarSkillProgress;
var ItemWindowHandle ItemWnd_SubWnd;
var ButtonHandle Apply_Button;
var ItemWindowHandle InventoryItem_ItemWnd;
var InventoryWnd inventoryWndScript;
var AutoPotionWndPet AutoPotionWndPetSrcipt;
var int nHPPetPotionPercent;
var int nCurrentHPPetPotionPercent;
var int atShowTimeHpSliderValue;

const AUTO_HP_PET_POTION_SHORTCUT_NUM= 158;
const DEFAULT_HPPERCENT= 80;

function Initialize ()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	use_Text = GetTextBoxHandle(m_WindowName $ ".SettingWnd.use_Text");
	Percent_Text = GetTextBoxHandle(m_WindowName $ ".SettingWnd.Percent_Text");
	HPSetting_SliderCtrl = GetSliderCtrlHandle(m_WindowName $ ".SettingWnd.HPSetting_SliderCtrl");
	BarSkillProgress = GetProgressCtrlHandle(m_WindowName $ ".SettingWnd.BarSkillProgress");
	ItemWnd_SubWnd = GetItemWindowHandle(m_WindowName $ ".Potion_Inventory_Window.ItemWnd_SubWnd");
	Apply_Button = GetButtonHandle(m_WindowName $ ".SettingWnd.apply_Button");
	BarSkillProgress.SetProgressTime(100);
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	AutoPotionWndPetSrcipt = AutoPotionWndPet(GetScript("PetStatusWndClassic.AutoPotionWndPet"));
}

function OnLoad ()
{
	SetClosingOnESC();
	Initialize();
}

function OnRegisterEvent ()
{
	RegisterEvent(EV_AutoplaySetting);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_InventoryUpdateItem);
	RegisterEvent(EV_InventoryAddItem);
}

function OnShow ()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	syncInventoryByAll();
	Apply_Button.DisableWindow();
	atShowTimeHpSliderValue = nCurrentHPPetPotionPercent;
}

function OnHide ()
{
	if ( nCurrentHPPetPotionPercent != nHPPetPotionPercent )
	{
		setHPPotionPercent(nHPPetPotionPercent);
	}
}

function OnClickItem (string strID, int Index)
{
	local ItemInfo SelectItemInfo;

	ItemWnd_SubWnd.GetItem(Index,SelectItemInfo);
	Debug("index" @ string(Index));
	Debug("Name:" @ SelectItemInfo.Name);
	if ( SelectItemInfo.Id.ClassID > 0 )
	{
		Class'ShortcutWndAPI'.static.RequestRegisterShortcut(AUTO_HP_PET_POTION_SHORTCUT_NUM, SelectItemInfo);
	}
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "CloseButton":
			Me.HideWindow();
			setHPPotionPercent(nHPPetPotionPercent);
			break;
		case "apply_Button":
			OnApply_ButtonClick();
			break;
	}
}

function OnEvent (int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_InventoryUpdateItem:
		case EV_InventoryAddItem:
			syncInventory(param);
			break;
		case EV_AutoplaySetting:
			AutoplaySettingHandler(param);
			break;
		case EV_Restart:
			ItemWnd_SubWnd.Clear();
			break;
	}
}

event OnModifyCurrentTickSliderCtrl (string strID, int iCurrentTick)
{
	switch (strID)
	{
		case "HPSetting_SliderCtrl":
			Percent_Text.SetText(string(iCurrentTick + 1) $ "%");
			BarSkillProgress.SetPos(99 - iCurrentTick + 1);
			nCurrentHPPetPotionPercent = iCurrentTick + 1;
			if ( atShowTimeHpSliderValue == nCurrentHPPetPotionPercent )
			{
				Apply_Button.DisableWindow();
			}
			else
			{
				Apply_Button.EnableWindow();
			}
			break;
	}
}

function AutoplaySettingHandler (string param)
{
	ParseInt(param,"HPPetPotionPercent",nHPPetPotionPercent);
	if ( (nHPPetPotionPercent > 0) && (nCurrentHPPetPotionPercent != nHPPetPotionPercent) )
	{
		if ( AutoPotionWndPetSrcipt.getCurrentSlotClassID() > 0 )
		{
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(5293),string(nHPPetPotionPercent)));
		} else {
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(5293),string(nHPPetPotionPercent)));
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13003),string(nHPPetPotionPercent)));
		}
	}
	setHPPotionPercent(nHPPetPotionPercent);
}

function setHPPotionPercent (int hpPoint)
{
	if ( hpPoint > 0 && hpPoint <= 100 )
		Debug("#### 경고(값이 비정상입니다.) :: HPPetPotionPercent :" @ string(hpPoint));
	else
		hpPoint = 1;

	Percent_Text.SetText(string(hpPoint) $ "%");
	BarSkillProgress.SetPos(100 - hpPoint);
	HPSetting_SliderCtrl.SetCurrentTick(hpPoint - 1);
	nCurrentHPPetPotionPercent = hpPoint;
}

function syncInventory (string param)
{
	local ItemInfo updatedItemInfo;
	local string Type;
	local int Index;

	if ( !Me.IsShowWindow() )
	{
		return;
	}
	ParamToItemInfo(param,updatedItemInfo);
	ParseString(param,"type",Type);
	if ( Class'UIDATA_ITEM'.static.GetAutomaticUseItemType(updatedItemInfo.Id.ClassID) == 3 )
	{
		Index = ItemWnd_SubWnd.FindItemByClassID(updatedItemInfo.Id);
		if ( Type == "delete" )
		{
			if ( Index > -1 )
			{
				ItemWnd_SubWnd.DeleteItem(Index);
			}
		} else {
			setShowItemCount(updatedItemInfo);
			if ( Index > -1 )
			{
				ItemWnd_SubWnd.SetItem(Index,updatedItemInfo);
			} else {
				ItemWnd_SubWnd.AddItem(updatedItemInfo);
			}
		}
	}
}

function ExSetSelectPostion (int nClassID)
{
	local int i;

	i = ItemWnd_SubWnd.FindItemByClassID(GetItemID(nClassID));
	if ( i > -1 )
	{
		ItemWnd_SubWnd.SetSelectedNum(i);
	}
}

function syncInventoryByAll ()
{
	local array<ItemInfo> itemarray;
	local int i;

	itemarray = inventoryWndScript.getInventoryAllItemArray(True);
	ItemWnd_SubWnd.Clear();
	
	for ( i = 0;i < itemarray.Length;i++ )
	{
		if ( Class'UIDATA_ITEM'.static.GetAutomaticUseItemType(itemarray[i].Id.ClassID) == 3 )
		{
			setShowItemCount(itemarray[i]);
			ItemWnd_SubWnd.AddItem(itemarray[i]);
		}
	}
	if ( AutoPotionWndPetSrcipt.getCurrentSlotClassID() > 0 )
	{
		ExSetSelectPostion(AutoPotionWndPetSrcipt.getCurrentSlotClassID());
	}
}

function OnApply_ButtonClick ()
{
	Debug("OnApply_ButtonClick" @ string(nCurrentHPPetPotionPercent) @ m_WindowName);
	SetINIInt("AutoPotionSubWndPet","e",nCurrentHPPetPotionPercent,"WindowsInfo.ini");
	AutomaticPlay(GetScript("AutomaticPlay")).requestAutoPlayForAutoPotionPet(nCurrentHPPetPotionPercent);
	Me.HideWindow();
}

function OnReceivedCloseUI ()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
}

defaultproperties
{
}
