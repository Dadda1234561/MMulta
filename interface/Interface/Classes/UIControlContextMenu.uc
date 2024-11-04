class UIControlContextMenu extends UICommonAPI;

var RichListCtrlHandle List_ListCtrl;
var string Owner;
var int menuHeight;
var array<UIControlContextMenuObject> menuObjects;
var private string m_reservedString;
var private int m_reservedInt;

static function UIControlContextMenu GetInstance()
{
	return UIControlContextMenu(GetScript("UIControlContextMenu"));	
}

delegate DelegateOnClickContextMenu(int SelectedIndex);

delegate DelegateOnHide();

function Initialize()
{
	List_ListCtrl = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".List_ListCtrl");
	List_ListCtrl.SetUseStripeBackTexture(false);
	List_ListCtrl.SetSelectedSelTooltip(false);	
}

event OnLoad()
{
	Initialize();	
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local int SelectedIndex;

	SelectedIndex = List_ListCtrl.GetSelectedIndex();
	List_ListCtrl.SetSelectable(false);
	DelegateOnClickContextMenu(menuObjects[SelectedIndex].Index);	
}

event OnShow()
{
	List_ListCtrl.SetSelectable(true);
	List_ListCtrl.SetSelectedIndex(-1, false);
	m_hOwnerWnd.SetFocus();	
}

event OnHide()
{
	DelegateOnHide();	
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	// End:0x11
	if(a_WindowHandle != m_hOwnerWnd)
	{
		return;
	}
	// End:0x1C
	if(bFocused)
	{
		return;
	}
	// End:0x32
	if(! m_hOwnerWnd.IsFocused())
	{
		return;
	}
	Hide();	
}

function _SetReservedString(string Str)
{
	m_reservedString = Str;	
}

function string _GetReservedString()
{
	return m_reservedString;	
}

function _SetReservedInt(int Num)
{
	m_reservedInt = Num;	
}

function int _GetReservedInt()
{
	return m_reservedInt;	
}

function _ShowTo(WindowHandle targetWnd, string OwnerName, optional string RelativePoint, optional string AnchorPoint, optional int OffsetX, optional int OffsetY)
{
	local Rect rectWnd;

	// End:0x1B
	if(RelativePoint == "")
	{
		RelativePoint = "TopLeft";
	}
	// End:0x39
	if(AnchorPoint == "")
	{
		AnchorPoint = "BottomLeft";
	}
	m_hOwnerWnd.SetAnchor(targetWnd.m_WindowNameWithFullPath, RelativePoint, AnchorPoint, OffsetX, OffsetY);
	Show(rectWnd.nX, rectWnd.nY, OwnerName);
	rectWnd = m_hOwnerWnd.GetRect();
	m_hOwnerWnd.ClearAnchor();	
}

function Show(int X, int Y, string OwnerName)
{
	local int i, currentScreenWidth, currentScreenHeight;
	local array<int> wh;

	// End:0x0E
	if(OwnerName == "")
	{
		return;
	}
	Owner = OwnerName;
	// End:0x27
	if(menuObjects.Length < 1)
	{
		return;
	}

	// End:0x82 [Loop If]
	for(i = 0; i < menuObjects.Length; i++)
	{
		// End:0x78
		if(! menuObjects[i].bCustomRecord)
		{
			List_ListCtrl.InsertRecord(makeRecord(menuObjects[i]));
		}
	}
	wh = HandleSetWindowSize();
	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	// End:0xCA
	if(wh[0] + X > currentScreenWidth)
	{
		X = currentScreenWidth - wh[0];
	}
	// End:0xF6
	if(wh[1] + Y > currentScreenHeight)
	{
		Y = currentScreenHeight - wh[1];
	}
	m_hOwnerWnd.MoveTo(X, Y);
	m_hOwnerWnd.ShowWindow();	
}

function Hide()
{
	Owner = "";
	m_hOwnerWnd.HideWindow();	
}

function UIControlContextMenuObject MenuNew(string Name, optional int Index, optional Color TextColor)
{
	local int Len;

	Len = menuObjects.Length;
	menuObjects[Len] = new class'UIControlContextMenuObject';
	menuObjects[Len].Name = Name;
	menuObjects[Len].Index = Index;
	// End:0xCA
	if(TextColor.R == 0 && TextColor.G == 0 && TextColor.B == 0 && TextColor.A == 0)
	{
		menuObjects[Len].TextColor = getInstanceL2Util().BrightWhite;		
	}
	else
	{
		menuObjects[Len].TextColor = TextColor;
	}
	return menuObjects[Len];	
}

function MenuAddIcon(string IconTextureName, optional int iconWidth, optional int iconHeight)
{
	local int lastIndex;

	lastIndex = menuObjects.Length - 1;
	// End:0x34
	if(iconWidth == 0)
	{
		menuObjects[lastIndex].iconWidth = 19;		
	}
	else
	{
		menuObjects[lastIndex].iconWidth = iconWidth;
	}
	// End:0x73
	if(iconHeight == 0)
	{
		menuObjects[lastIndex].iconHeight = 19;		
	}
	else
	{
		menuObjects[lastIndex].iconHeight = iconHeight;
	}
	lastIndex = menuObjects.Length - 1;
	menuObjects[lastIndex].Icon = IconTextureName;	
}

function MenuAddRecord(RichListCtrlRowData Record)
{
	local int Len;

	Len = List_ListCtrl.GetRecordCount();
	menuObjects[Len] = new class'UIControlContextMenuObject';
	menuObjects[Len].Index = Len;
	menuObjects[Len].bCustomRecord = true;
	List_ListCtrl.InsertRecord(Record);	
}

function MenuLineAdd()
{
	GetDividText(0).ShowWindow();
	GetDividText(0).MoveC(2, menuObjects.Length * 26);	
}

function MenuRem(int Index)
{
	menuObjects.Remove(Index, 1);	
}

function bool MenuFix(int Index, UIControlContextMenuObject menuObject)
{
	// End:0x12
	if(menuObjects.Length < Index)
	{
		return false;
	}
	menuObjects[Index] = menuObject;
	List_ListCtrl.InsertRecord(makeRecord(menuObjects[Index]));
	return true;	
}

function Clear()
{
	GetDividText(0).HideWindow();
	menuObjects.Length = 0;
	List_ListCtrl.DeleteAllItem();
	SetMenuHeight(26);	
}

function SetMenuHeight(int Height)
{
	List_ListCtrl.SetContentsHeight(Height);
	menuHeight = Height;	
}

private function array<int> HandleSetWindowSize()
{
	local int nWidth, nHeight, i, maxLen;
	local array<int> wh;

	maxLen = 0;

	// End:0x9A [Loop If]
	for(i = 0; i < menuObjects.Length; i++)
	{
		GetTextSizeDefault(menuObjects[i].Name, nWidth, nHeight);
		// End:0x7E
		if(menuObjects[i].Icon != "")
		{
			nWidth = nWidth + menuObjects[i].iconWidth;
		}
		maxLen = Max(nWidth, maxLen);
	}
	nHeight = menuObjects.Length * menuHeight;
	m_hOwnerWnd.SetWindowSize(maxLen + 25, nHeight + 2);
	GetDividText(0).SetWindowSize(maxLen + 21, 1);
	List_ListCtrl.SetWindowSize(maxLen + 23, nHeight);
	wh[0] = maxLen + 25;
	wh[1] = nHeight + 2;
	return wh;	
}

private function RichListCtrlRowData makeRecord(UIControlContextMenuObject menuObject)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 1;
	// End:0x9F
	if(menuObject.Icon != "")
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, menuObject.Icon, menuObject.iconHeight, menuObject.iconWidth, 0, 0);
		addRichListCtrlString(Record.cellDataList[0].drawitems, menuObject.Name, menuObject.TextColor, false, 0, 3);		
	}
	else
	{
		addRichListCtrlString(Record.cellDataList[0].drawitems, menuObject.Name, menuObject.TextColor);
	}
	return Record;	
}

private function TextureHandle GetDividText(int Index)
{
	return GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ContextMenu_Divid");	
}

function bool IsMine(string Name)
{
	return Owner == Name;	
}

defaultproperties
{
}
