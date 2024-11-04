//================================================================================
// QuitReportDrawerInstantZoneWnd.
//================================================================================

class QuitReportDrawerInstantZoneWnd extends UICommonAPI;

var WindowHandle Me;
var ListCtrlHandle itemListCtrl;
var ButtonHandle CloseBtn;
var int itemIndex;
var array<ItemInfo> getItemInfoArray;
var L2Util util;
var InventoryWnd inventoryWndScript;
var QuitReportInstantZoneWnd QuitReportWndScript;

function OnRegisterEvent ()
{
}

function OnLoad ()
{
	SetClosingOnESC();
	Initialize();
}

function OnShow ()
{
	updateList();
}

function OnHide ()
{
}

function Initialize ()
{
	Me = GetWindowHandle("QuitReportDrawerInstantZoneWnd");
	itemListCtrl = GetListCtrlHandle("QuitReportDrawerInstantZoneWnd.InstanceDungeon_ListCtrl");
	CloseBtn = GetButtonHandle("QuitReportDrawerInstantZoneWnd.EnsoulInfoBtn");
	util = L2Util(GetScript("L2Util"));
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	QuitReportWndScript = QuitReportInstantZoneWnd(GetScript("QuitReportInstantZoneWnd"));
	itemListCtrl.SetSelectedSelTooltip(False);
	itemListCtrl.SetAppearTooltipAtMouseX(True);
	Init();
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "EnsoulInfoBtn":
		OnEnsoulInfoBtnClick();
		break;
		default:
	}
}

function externalAddItem (ItemInfo addItemInfo)
{
	if (!QuitReportWndScript.bGainStart )
	{
		return;
	}
	if ( IsStackableItem(addItemInfo.ConsumeType) )
	{
		sumStackableItem(addItemInfo);
	} else {
		getItemInfoArray.Length = getItemInfoArray.Length + 1;
		getItemInfoArray[getItemInfoArray.Length - 1] = addItemInfo;
	}
	if ( Me.IsShowWindow() )
	{
		updateList();
	}
}

function int getTotalItemCount ()
{
	local int adenItem;
	local int itemLen;
	local int i;

	adenItem = 0;
	itemLen = getItemInfoArray.Length;
	
	for ( i = 0;i < itemLen; i++ )
	{
		if ( getItemInfoArray.Length > 0 )
		{
			if ( getItemInfoArray[i].Id.ClassID == 57 )
			{
				adenItem = -1;
		break;
			}
		}
	}
	return getItemInfoArray.Length + adenItem;
}

function Init ()
{
	if ( getItemInfoArray.Length > 0 )
	{
		getItemInfoArray.Remove (0,getItemInfoArray.Length);
	}
	itemIndex = 99999;
	itemListCtrl.DeleteAllItem();
}

function sumStackableItem (ItemInfo addItemInfo)
{
	local int i;
	local ItemInfo beforeItemInfo;
	local bool bAdd;

	
	for ( i = 0;i < getItemInfoArray.Length; i++ )
	{
		if ( getItemInfoArray[i].Id.ClassID == addItemInfo.Id.ClassID )
		{
			inventoryWndScript.getInventoryItemInfo(addItemInfo.Id,beforeItemInfo,True);
			if ( beforeItemInfo.ItemNum < addItemInfo.ItemNum )
			{
				addItemInfo.ItemNum = getItemInfoArray[i].ItemNum + addItemInfo.ItemNum - beforeItemInfo.ItemNum;
				getItemInfoArray.Remove (i,1);
				getItemInfoArray.Length = getItemInfoArray.Length + 1;
				getItemInfoArray[getItemInfoArray.Length - 1] = addItemInfo;
			}
			bAdd = True;
		break;
		}
	}
	if ( bAdd == False )
	{
		inventoryWndScript.getInventoryItemInfo(addItemInfo.Id,beforeItemInfo,True);
		if ( beforeItemInfo.ItemNum < addItemInfo.ItemNum )
		{
			if ( getItemInfoArray.Length > 0 )
			{
				addItemInfo.ItemNum = getItemInfoArray[i].ItemNum + addItemInfo.ItemNum - beforeItemInfo.ItemNum;
			} else {
				addItemInfo.ItemNum = addItemInfo.ItemNum - beforeItemInfo.ItemNum;
			}
			getItemInfoArray.Length = getItemInfoArray.Length + 1;
			getItemInfoArray[getItemInfoArray.Length - 1] = addItemInfo;
		}
	}
}

function updateList ()
{
	local int i;

	itemListCtrl.DeleteAllItem();
	if ( getItemInfoArray.Length > 0 )
	{
	 
		for (	i = getItemInfoArray.Length - 1;i > -1;i-- )
		{
			if ( getItemInfoArray[i].Id.ClassID != 57 )
			{
				AddItem(getItemInfoArray[i]);
			}
		}
	}
	QuitReportWndScript.UpdateUserInfoHandler();
}

function AddItem (ItemInfo Info)
{
	local LVDataRecord Record;
	local string param;
	local string AdditionalName;
	local string fullNameString;
	local string itemNumEasyRead;
	local int itemNameClass;

	itemIndex-- ;
	fullNameString = Info.Name;
	itemNameClass = Class'UIDATA_ITEM'.static.GetItemNameClass(Info.Id);
	AdditionalName = Class'UIDATA_ITEM'.static.GetItemAdditionalName(Info.Id);
	if ( itemNameClass == 0 )
	{
		fullNameString = MakeFullSystemMsg(GetSystemMessage(2332),fullNameString);
	} else {
		if ( itemNameClass == 2 )
		{
			fullNameString = MakeFullSystemMsg(GetSystemMessage(2331),fullNameString);
		}
	}
	if ( Len(AdditionalName) > 0 )
	{
		fullNameString = fullNameString $ "(" $ AdditionalName $ ")";
	}
	ItemInfoToParam(Info,param);
	Record.szReserved = param;
	Record.nReserved1 = Info.Id.ClassID;
	Record.LVDataList.Length = 4;
	Record.LVDataList[0].szData = fullNameString;
	Record.LVDataList[0].hasIcon = True;
	Record.LVDataList[0].nTextureWidth = 32;
	Record.LVDataList[0].nTextureHeight = 32;
	Record.LVDataList[0].nTextureU = 32;
	Record.LVDataList[0].nTextureV = 32;
	Record.LVDataList[0].szTexture = Info.IconName;
	Record.LVDataList[0].IconPosX = 10;
	Record.LVDataList[0].FirstLineOffsetX = 6;
	Record.LVDataList[0].HiddenStringForSorting = string(itemIndex);
	Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
	Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
	Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
	Record.LVDataList[0].backTexWidth = 36;
	Record.LVDataList[0].backTexHeight = 36;
	Record.LVDataList[0].backTexUL = 36;
	Record.LVDataList[0].backTexVL = 36;
	Record.LVDataList[0].iconPanelName = Info.IconPanel;
	Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
	Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
	Record.LVDataList[0].panelWidth = 32;
	Record.LVDataList[0].panelHeight = 32;
	Record.LVDataList[0].panelUL = 32;
	Record.LVDataList[0].panelVL = 32;

	if ( Info.Enchanted > 0 )
	{
		Record.LVDataList[0].arrTexture.Length = 3;
		lvTextureAddItemEnchantedTexture(Info.Enchanted,Record.LVDataList[0].arrTexture[0],Record.LVDataList[0].arrTexture[1],Record.LVDataList[0].arrTexture[2],9,11);
	}

	if(IsStackableItem(Info.ConsumeType))
	{
		if(Info.ItemNum > int64(9999))
		{
			itemNumEasyRead = "9999+";
		}
		else
		{
			itemNumEasyRead = string(Info.ItemNum);
		}
		Record.LVDataList[1].szData = itemNumEasyRead;
		Record.LVDataList[1].textAlignment = TA_Center;
		Record.LVDataList[1].HiddenStringForSorting = util.makeZeroString(13, Info.ItemNum);
	}
	else
	{
		Record.LVDataList[1].HiddenStringForSorting = util.makeZeroString(13, Info.ItemNum);
	}
	itemListCtrl.InsertRecord(Record);
}

function OnEnsoulInfoBtnClick ()
{
	QuitReportWndScript.setDrawerButtonState(True);
	Me.HideWindow();
}

function OnReceivedCloseUI ()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
