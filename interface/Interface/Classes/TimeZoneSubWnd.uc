//================================================================================
// TimeZoneSubWnd.
//================================================================================

class TimeZoneSubWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var ItemWindowHandle TimeZoneSubWnd_ItemWnd;
var TimeZoneWnd timeZoneWndScript;

function Initialize()
{
	Me = GetWindowHandle(m_WindowName);
	TimeZoneSubWnd_ItemWnd = GetItemWindowHandle(m_WindowName $ ".TimeZoneSubWnd_ItemWnd");
}

function OnRegisterEvent()
{
	RegisterEvent(EV_TimeRestrictFieldChargeResult);
	RegisterEvent(EV_InventoryUpdateItem);
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_TimeRestrictFieldChargeResult:
			HandleTimeRestrictFieldChargeResult(param);
			break;
		case EV_InventoryUpdateItem:
			HandleUpdateItem(param);
			break;
	}
}

function HandleUpdateItem(string param)
{
	local int i;
	local int ItemNum;
	local int ClassID;
	local ItemInfo Info;
	local string Type;

	if (!Me.IsShowWindow())
	{
		return;
	}
	ParseInt(param, "ClassID", ClassID);

	for (i = 0;i < TimeZoneSubWnd_ItemWnd.GetItemNum();i++)
	{
		TimeZoneSubWnd_ItemWnd.GetItem(i, Info);
		if (Info.Id.ClassID == ClassID)
		{
			ParseString(param, "type", Type);
			if (Type == "delete")
			{
				TimeZoneSubWnd_ItemWnd.DeleteItem(i);
				HandleSort(i);
				return;
			}
			else
			{
				ParseInt(param, "ItemNum", ItemNum);
				Info.ItemNum = ItemNum;
			}
			TimeZoneSubWnd_ItemWnd.SetItem(i, Info);
			return;
		}
	}
}

function HandleSort(int startIndex)
{
	local int i;
	local int ItemNum;
	local ItemInfo Info;

	ItemNum = TimeZoneSubWnd_ItemWnd.GetItemNum();
	if (ItemNum == 0)
	{
        TimeZoneSubWnd_ItemWnd.Clear();
	}
	else
	{
		i = startIndex;
		if (TimeZoneSubWnd_ItemWnd.GetItem(startIndex + 1, Info))
		{
			TimeZoneSubWnd_ItemWnd.SetItem(i, Info);
		}
	}
}

function HandleTimeRestrictFieldChargeResult(string param)
{
    local int FieldId;

	if (!Me.IsShowWindow())
	{
		return;
	}
	ParseInt(param, "FieldID", FieldId);
}

function OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	OnRClickItemWithHandle(a_hItemWindow, Index);
}

function OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	local ItemInfo Info;

	a_hItemWindow.GetItem(Index, Info);
	RequestUseItem(Info.Id);
}

function OnClickButton(string Name)
{
	switch (Name)
	{
		case "Close_Btn":
			Me.HideWindow();
			break;
		default:
			break;
	}
}

function OnShow()
{
	Me.SetFocus();
	// End:0x32
	if(getInstanceUIData().getIsClassicServer())
	{
		Me.SetDraggable(false);
	}
}

function API_GetTimeRestrictFieldInfo(int FieldId, out TimeRestrictFieldUIData fieldUIData)
{
    GetTimeRestrictFieldInfo(FieldId, fieldUIData);
}

function HandleGetItemList(int FieldId)
{
	local int i;
	local array<int> RefillItemList;
	local TimeRestrictFieldUIData fieldUIData;
	local ItemInfo refillItemInfo;
	local InventoryWnd invenScript;
	local ItemID cID;

	TimeZoneSubWnd_ItemWnd.Clear();
	API_GetTimeRestrictFieldInfo(FieldId, fieldUIData);
	RefillItemList = fieldUIData.RefillItemList;
	invenScript = InventoryWnd(GetScript("InventoryWnd"));

	for (i = 0;i < RefillItemList.Length;i++)
	{
		cID.ClassID = RefillItemList[i];
		if (invenScript.getInventoryItemInfo(cID, refillItemInfo, true))
		{
			refillItemInfo.bShowCount = true;
			TimeZoneSubWnd_ItemWnd.AddItem(refillItemInfo);
		}
	}
}

function SetShowSubWindow(int FieldId, ButtonHandle targetButton)
{
	local int currentScreenWidth;
	local int currentScreenHeight;
	local int myWidth;
	local int targetX;
	local Rect rectWnd;

	HandleGetItemList(FieldId);
	rectWnd = Me.GetRect();
	myWidth = rectWnd.nWidth;
	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	rectWnd = targetButton.GetRect();
	if (currentScreenWidth < rectWnd.nX + myWidth)
	{
		targetX = currentScreenWidth - myWidth;
	}
	else
	{
		targetX = rectWnd.nX + 20;
	}
	Me.ClearAnchor();
	Me.MoveTo(targetX, rectWnd.nY);
	Me.ShowWindow();
	Me.SetDraggable(true);	
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
     m_WindowName="TimeZoneSubWnd"
}
