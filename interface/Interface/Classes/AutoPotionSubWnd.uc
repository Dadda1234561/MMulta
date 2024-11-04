//================================================================================
// AutoPotionSubWnd.
//================================================================================

class AutoPotionSubWnd extends UICommonAPI;

const DEFAULT_HPPERCENT= 80;

var WindowHandle Me;
var WindowHandle ParentWindow;
var WindowHandle AutoPotionSubWnd;
var TextBoxHandle use_Text;
var TextBoxHandle Percent_Text;
var ProgressCtrlHandle BarSkillProgress;
var ButtonHandle Apply_Button;
var SliderCtrlHandle HPSetting_SliderCtrl;
var ItemWindowHandle ItemWnd_SubWnd;
var ItemWindowHandle InventoryItem_ItemWnd;
var InventoryWnd inventoryWndScript;
var AutoPotionWnd AutoPotionWndSrcipt;
var string m_WindowName;
var int nHPPotionPercent;
var int nCurrentHPPotionPercent;
var bool firstSetting;
var int atShowTimeHpSliderValue;
var bool Initialized;

function Initialize()
{
	Me = GetWindowHandle("AutoPotionSubWnd");
	use_Text = GetTextBoxHandle("AutoPotionSubWnd.SettingWnd.use_Text");
	Percent_Text = GetTextBoxHandle("AutoPotionSubWnd.SettingWnd.Percent_Text");
	BarSkillProgress = GetProgressCtrlHandle("AutoPotionSubWnd.SettingWnd.BarSkillProgress");
	Apply_Button = GetButtonHandle("AutoPotionSubWnd.SettingWnd.apply_Button");
	HPSetting_SliderCtrl = GetSliderCtrlHandle("AutoPotionSubWnd.SettingWnd.HPSetting_SliderCtrl");
	ItemWnd_SubWnd = GetItemWindowHandle("AutoPotionSubWnd.Potion_Inventory_Window.ItemWnd_SubWnd");
	BarSkillProgress.SetProgressTime(100);
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	AutoPotionWndSrcipt = AutoPotionWnd(GetScript("AutoPotionWnd"));
	Initialized = true;	
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

event OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_AutoplaySetting);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_InventoryUpdateItem);
	RegisterEvent(EV_InventoryAddItem);
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	syncInventoryByAll();
	Apply_Button.DisableWindow();
	atShowTimeHpSliderValue = nCurrentHPPotionPercent;
}

event OnHide()
{
	if(nCurrentHPPotionPercent != nHPPotionPercent)
	{
		setHPPotionPercent(nHPPotionPercent);
	}	
}

event OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	switch (strID)
	{
		case "HPSetting_SliderCtrl":
			// End:0x2D
			if(! Initialized)
			{
				return;
			}
			Percent_Text.SetText(string(iCurrentTick + 1) $ "%");
			BarSkillProgress.SetPos(99 - (iCurrentTick + 1));
			nCurrentHPPotionPercent = iCurrentTick + 1;
			// End:0x95
			if(atShowTimeHpSliderValue == nCurrentHPPotionPercent)
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

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_GameStart:
			break;
		case EV_InventoryUpdateItem:
		case EV_InventoryAddItem:
			syncInventory(param);
			checkRecoverAutoPlayHpPoint();
			break;
		case EV_AutoplaySetting:
			AutoplaySettingHandler(param);
			break;
		case EV_Restart:
			ItemWnd_SubWnd.Clear();
			firstSetting = False;
			break;
		default:
	}
}

event OnClickItem(string strID, int Index)
{
	local ItemInfo SelectItemInfo;

	ItemWnd_SubWnd.GetItem(Index, SelectItemInfo);
	if(SelectItemInfo.Id.ClassID > 0)
	{
		Class'ShortcutWndAPI'.static.RequestRegisterShortcut(157, SelectItemInfo);
	}
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "CloseButton":
			Me.HideWindow();
			setHPPotionPercent(nHPPotionPercent);
			break;
		case "apply_Button":
			OnApply_ButtonClick();
			break;
		default:
	}
}

function checkRecoverAutoPlayHpPoint ()
{
	local int nHpPoint;
	local int nHpPetPoint;

	if ( firstSetting == False )
	{
		firstSetting = True;
		GetINIInt(m_WindowName,"e",nHpPoint,"WindowsInfo.ini");
		GetINIInt(m_WindowName,"l",nHpPetPoint,"WindowsInfo.ini");
		
		if ( nHpPoint == 0 )
		{
			nHpPoint = DEFAULT_HPPERCENT;
		}

		if ( nHpPetPoint == 0 )
		{
			nHpPetPoint = AutoPotionSubWndPet(GetScript("PetStatusWndClassic.AutoPotionSubWndPet")).DEFAULT_HPPERCENT;
		}

		if ( getInstanceUIData().getIsLiveServer() )
		{
			AutoUseItemWnd(GetScript("AutoUseItemWnd")).requestAutoPlayForAutoPotion(nHpPoint);
		}
		else
		{
			AutomaticPlay(GetScript("AutomaticPlay")).requestAutoPlayForAutoPotionWithPet(nHpPoint,nHpPetPoint);
		}
	}
}

function AutoplaySettingHandler (string param)
{
	ParseInt(param,"HPPotionPercent",nHPPotionPercent);
	if ( (nHPPotionPercent > 0) && (nCurrentHPPotionPercent != nHPPotionPercent) )
	{
		if ( AutoPotionWndSrcipt.getCurrentSlotClassID() > 0 )
		{
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(5293),string(nHPPotionPercent)));
		}
		else
		{
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(5293),string(nHPPotionPercent)));
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13003),string(nHPPotionPercent)));
		}
	}
	setHPPotionPercent(nHPPotionPercent);
}

function setHPPotionPercent (int hpPoint)
{
	if ( hpPoint > 0 && hpPoint <= 100 )
		Debug("#### 경고(값이 비정상입니다.) :: HPPotionPercent :" @ string(nHPPotionPercent));
	else
		hpPoint = 1;
	Percent_Text.SetText(string(hpPoint) $ "%");
	BarSkillProgress.SetPos(100 - hpPoint);
	HPSetting_SliderCtrl.SetCurrentTick(hpPoint - 1);
	nCurrentHPPotionPercent = hpPoint;
}

function syncInventory (string param)
{
	local ItemInfo updatedItemInfo;
	local string Type;
	local int Index;

	if (  !Me.IsShowWindow() )
	{
		return;
	}
	ParamToItemInfo(param,updatedItemInfo);
	ParseString(param,"type",Type);
	if ( Class'UIDATA_ITEM'.static.GetAutomaticUseItemType(updatedItemInfo.Id.ClassID) == 2 )
	{
		Index = ItemWnd_SubWnd.FindItemByClassID(updatedItemInfo.Id);
		if ( Type == "delete" )
		{
			if ( Index > -1 )
			{
				ItemWnd_SubWnd.DeleteItem(Index);
			}
		}
		else
		{
			setShowItemCount(updatedItemInfo);
			if ( Index > -1 )
			{
				ItemWnd_SubWnd.SetItem(Index,updatedItemInfo);
			}
			else
			{
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
		if ( Class'UIDATA_ITEM'.static.GetAutomaticUseItemType(itemarray[i].Id.ClassID) == 2 )
		{
			setShowItemCount(itemarray[i]);
			ItemWnd_SubWnd.AddItem(itemarray[i]);
		}
	}
	if ( AutoPotionWndSrcipt.getCurrentSlotClassID() > 0 )
	{
		ExSetSelectPostion(AutoPotionWndSrcipt.getCurrentSlotClassID());
	}
}

function OnApply_ButtonClick()
{
	SetINIInt(m_WindowName,"e",nCurrentHPPotionPercent,"WindowsInfo.ini");
	if ( getInstanceUIData().getIsLiveServer() )
	{
		AutoUseItemWnd(GetScript("AutoUseItemWnd")).requestAutoPlayForAutoPotion(nCurrentHPPotionPercent);
	}
	else
	{
		AutomaticPlay(GetScript("AutomaticPlay")).requestAutoPlayForAutoPotion(nCurrentHPPotionPercent);
	}
	Me.HideWindow();
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
}

defaultproperties
{
     m_WindowName="AutoPotionSubWnd"
}
