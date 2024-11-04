class UIControlTilelist extends UICommonAPI;

enum clickType 
{
	non,
	Button,
	itemRenderer,
	Max
};

struct clickData
{
	var clickType Type;
	var int rendererIndex;
	var string Name;
};

var private int itemNumTotal;
var private int ownerStandardWH;
var private int itemRendererNum;
var private int standardNum;
var private int standardWH;
var private int rendererNumPerScroll;
var private int scrollLineNum;
var private int firstIndex;
var private int maxScrollLine;
var private L2UITimerObject tickTimerObject;
var private L2UITimerObject tickTimerObjectClick;
var private L2UITimerObject tickTImerObjectRefresh;
var private clickData clickDataLast;
var private int pressedRendererIndex;
var private bool bUsePage;
var private bool bUseOver;
var private bool bUseSelect;
var private int overedRendererIndex;
var private int selectedRendererIndex;
var private int overedIndex;
var private int SelectedIndex;
var private bool bOptionChanged;


function _SetUsePage(bool bUse)
{
	bUsePage = bUse;
	bOptionChanged = true;
	// End:0x2D
	if(bUse)
	{
		rendererNumPerScroll = _GetItemRendererNum();		
	}
	else
	{
		rendererNumPerScroll = standardNum;
	}
	scrollLineNum = rendererNumPerScroll / standardNum;
	Validate();
}

delegate DelegateOnScroll();

delegate DelegateOnItemRenderer(string itemRendererID, int rendererIndex, int itemIndex);

delegate DelegateOnSelect(string itemRendererID, int rendererIndex, int itemIndex);

delegate DelegateOnRendererClick(string itemRendererPath, int rendererIndex, int itemIndex);

delegate DelegateOnClick(string BTNID, int rendererIndex, int itemIndex);

static function UIControlTilelist InitScript(WindowHandle wnd, int Col, int Row, optional bool _bV)
{
	local UIControlTilelist scr;

	wnd.SetScript("UIControlTilelist");
	scr = UIControlTilelist(wnd.GetScript());
	scr.InitWnd(wnd, Col, Row, _bV);
	return scr;
}

function InitWnd(WindowHandle wnd, int Col, int Row, bool _bV)
{
	m_hOwnerWnd = wnd;
	tickTimerObject = class'L2UITimer'.static.Inst()._AddNewTimerObject(1, 1, 0);
	tickTimerObject._DelegateOnEnd = RefreshState;
	tickTimerObjectClick = class'L2UITimer'.static.Inst()._AddNewTimerObject(1, 1, 0);
	tickTimerObjectClick._DelegateOnEnd = HandleClick;
	tickTImerObjectRefresh = class'L2UITimer'.static.Inst()._AddNewTimerObject(1, 1, 0);
	tickTImerObjectRefresh._DelegateOnEnd = RefreshRenderer;
	itemRendererNum = Row * Col;
	InitTileList(Col, Row, _bV);
	InitState();
	scrollLineNum = 1;
	rendererNumPerScroll = standardNum;
	ClearRendererIndexes();
}

private function InitState()
{
	local int i;
	local string rendererPath;

	overedIndex = -1;
	overedRendererIndex = -1;
	SelectedIndex = -1;
	selectedRendererIndex = -1;
	bUseOver = GetTextureHandle(_GetRendererPath(0) $ ".OverTexture").m_pTargetWnd != none;
	bUseSelect = GetTextureHandle(_GetRendererPath(0) $ ".SelectTexture").m_pTargetWnd != none;

	// End:0x120 [Loop If]
	for(i = 0; i < _GetItemRendererNum(); i++)
	{
		rendererPath = _GetRendererPath(i);
		// End:0xE5
		if(bUseOver)
		{
			GetTextureHandle(rendererPath $ ".OverTexture").SetAlpha(0);
		}
		// End:0x116
		if(bUseSelect)
		{
			GetTextureHandle(rendererPath $ ".SelectTexture").SetAlpha(0);
		}
	}	
}

private function InitTileList(int colNum, int rowNum, bool _bV)
{
	local int _ownerWndW, _ownerWndH;

	m_hOwnerWnd.GetWindowSize(_ownerWndW, _ownerWndH);
	// End:0x4D
	if(_bV)
	{
		standardNum = colNum;
		standardWH = _ownerWndH / rowNum;
		ownerStandardWH = _ownerWndH;		
	}
	else
	{
		standardNum = rowNum;
		standardWH = _ownerWndW / colNum;
		ownerStandardWH = _ownerWndW;
	}	
}

event OnScrollMove(string strID, int pos)
{
	OnScroll(pos);
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	local int rendererIndex;

	// End:0x34
	if(bUseOver)
	{
		rendererIndex = _GetItemRendererIndexWithWindow(a_WindowHandle);
		// End:0x34
		if(rendererIndex > -1)
		{
			_SetOver(-1);
		}
	}
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	local int rendererIndex;

	// End:0x3A
	if(bUseOver)
	{
		rendererIndex = _GetItemRendererIndexWithWindow(a_WindowHandle);
		// End:0x3A
		if(rendererIndex > -1)
		{
			_SetOver(_GetItemIndexWithRendererIndex(rendererIndex));
		}
	}
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	ValidateClick(clickType.Button/*1*/, a_ButtonHandle.GetWindowName(), _GetItemRendererIndexWithWindow(a_ButtonHandle));	
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	// End:0x34
	if(ChkInRenderer(pressedRendererIndex, X, Y))
	{
		ValidateClick(clickType.itemRenderer/*2*/, a_WindowHandle.GetWindowName(), pressedRendererIndex);
	}	
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	pressedRendererIndex = _GetItemRendererIndexWithWindow(a_WindowHandle);
	// End:0x3A
	if(bUseSelect)
	{
		// End:0x3A
		if(pressedRendererIndex > -1)
		{
			_SetSelect(_GetItemIndexWithRendererIndex(pressedRendererIndex));
		}
	}	
}

private function HandleClick()
{
	switch(clickDataLast.Type)
	{
		// End:0x42
		case clickType.Button/*1*/:
			DelegateOnClick(clickDataLast.Name, clickDataLast.rendererIndex, _GetItemIndexWithRendererIndex(clickDataLast.rendererIndex));
			// End:0x7B
			break;
		// End:0x78
		case clickType.itemRenderer/*2*/:
			DelegateOnRendererClick(clickDataLast.Name, clickDataLast.rendererIndex, _GetItemIndexWithRendererIndex(clickDataLast.rendererIndex));
			// End:0x7B
			break;
	}
	ClearRendererIndexes();	
}

private function RefreshOption()
{
	ApplyTileListSetting();
	bOptionChanged = false;
}

private function RefreshState()
{
	local int rendererIndex;

	// End:0x0F
	if(bOptionChanged)
	{
		RefreshOption();
	}
	rendererIndex = _GetItemRendererIndex(overedIndex);
	// End:0xD8
	if(overedRendererIndex != rendererIndex)
	{
		// End:0x80
		if(overedRendererIndex > -1 && overedRendererIndex < itemRendererNum)
		{
			GetTextureHandle(_GetRendererPath(overedRendererIndex) $ ".OverTexture").SetAlpha(0, 0.10f);
		}
		// End:0xCD
		if(rendererIndex > -1 && rendererIndex < itemRendererNum)
		{
			GetTextureHandle(_GetRendererPath(rendererIndex) $ ".OverTexture").SetAlpha(255);
		}
		overedRendererIndex = rendererIndex;
	}
	rendererIndex = _GetItemRendererIndex(SelectedIndex);
	// End:0x1C5
	if(selectedRendererIndex != rendererIndex)
	{
		// End:0x146
		if(selectedRendererIndex > -1 && selectedRendererIndex < itemRendererNum)
		{
			GetTextureHandle(_GetRendererPath(selectedRendererIndex) $ ".SelectTexture").SetAlpha(0);
		}
		// End:0x1B4
		if((rendererIndex > -1) && rendererIndex < itemRendererNum)
		{
			GetTextureHandle(_GetRendererPath(rendererIndex) $ ".SelectTexture").SetAlpha(255);
			DelegateOnSelect(_GetRendererPath(rendererIndex), rendererIndex, SelectedIndex);
		}
		selectedRendererIndex = _GetItemRendererIndex(SelectedIndex);
	}
}

private function RefreshRenderer()
{
	_Refresh();	
}

private function Validate()
{
	tickTimerObject._Reset();	
}

private function ValidateClick(clickType Type, string btnName, int rendererIndex)
{
	// End:0x17
	if(clickDataLast.Type == Button)
	{
		return;
	}
	clickDataLast.Type = Type;
	clickDataLast.Name = btnName;
	clickDataLast.rendererIndex = rendererIndex;
	tickTimerObjectClick._Reset();	
}

private function ValidateRefresh()
{
	tickTImerObjectRefresh._Reset();
}

function _SetPage(int Page)
{
	SetScrollIndex(Page);
}

function _NextPage()
{
	_SetPage(Min(GetScrollIndexMax(), (GetScrollIndex()) + 1));
}

function _PrevPage()
{
	_SetPage(Max(0, (GetScrollIndex()) - 1));
}

function int _PageMax()
{
	return GetScrollIndexMax();
}

function int _Page()
{
	return GetScrollIndex();
}

function _GotoItemIndex(int itemIndex)
{
	_SetPage(itemIndex / rendererNumPerScroll);
}

function _SetTileListItemNumTotal(int _itemNumTotal)
{
	itemNumTotal = _itemNumTotal;
	ApplyTileListSetting();
}

function int _GetSelectedIndex()
{
	return SelectedIndex;
}

function int _GetSelectedRendererIndex()
{
	return selectedRendererIndex;
}

function int _GetOveredIndex()
{
	return overedIndex;
}

function int _GetOveredRendererIndex()
{
	return overedRendererIndex;
}

function int _GetItemNumTotal()
{
	return itemNumTotal;
}

function int _GetItemRendererNum()
{
	return itemRendererNum;
}

function int _GetItemIndexWithRendererIndex(int itemRendererNum)
{
	// End:0x11
	if(firstIndex < 0)
	{
		return itemRendererNum;
	}
	return firstIndex + itemRendererNum;	
}

function int _GetItemRendererIndex(int Index)
{
	// End:0x11
	if(firstIndex < 0)
	{
		return -1;
	}
	return Index - firstIndex;	
}

function int _GetItemRendererIndexWithWindow(WindowHandle childWindow)
{
	local int i;
	local WindowHandle tmpWnd;

	// End:0x11
	if(childWindow == none)
	{
		return -1;
	}
	// End:0x2B
	if(childWindow.m_pTargetWnd == none)
	{
		return -1;
	}

	// End:0x6E [Loop If]
	for(i = 0; i < itemNumTotal; i++)
	{
		tmpWnd = GetWindowHandleItemRederer(i);
		// End:0x6B
		if(tmpWnd.GetWindowName() == "")
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x64
		if(childWindow.IsChildOf(tmpWnd))
		{
			return i;
		}
	}
	return -1;	
}

function _SetUseSelect(bool bUseSelectP)
{
	local int i;

	bUseSelect = bUseSelectP;
	// End:0x1A
	if(! bUseSelect)
	{
		return;
	}

	// End:0x69 [Loop If]
	for(i = 0; i < _GetItemRendererNum(); i++)
	{
		GetTextureHandle(_GetRendererPath(i) $ ".SelectTexture").SetAlpha(0);
	}
}

function _SetUseOver(bool bUseOverP)
{
	local int i;

	bUseOver = bUseOverP;
	// End:0x1A
	if(! bUseOver)
	{
		return;
	}

	// End:0x67 [Loop If]
	for(i = 0; i < _GetItemRendererNum(); i++)
	{
		GetTextureHandle(_GetRendererPath(i) $ ".OverTexture").SetAlpha(0);
	}
}

function _Refresh()
{
	local int i, showenlen, itemIndex, firstItemIndex;

	showenlen = _GetItemRendererNum();
	firstItemIndex = _GetItemIndexWithRendererIndex(i);

	// End:0x86 [Loop If]
	for(i = 0; i < showenlen; i++)
	{
		itemIndex = firstItemIndex + i;
		DelegateOnItemRenderer(_GetRendererPath(i), i, itemIndex);
	}
}

function _RefreshRenderer(int itemRendererIndex)
{
	local int itemIndex;

	itemIndex = _GetItemIndexWithRendererIndex(itemRendererIndex);
	DelegateOnItemRenderer(_GetRendererPath(itemRendererIndex), itemRendererIndex, itemIndex);
}

function _SetSelect(int itemIndex, optional bool forceToSelect)
{
	// End:0x11
	if(SelectedIndex == itemIndex)
	{
		return;
	}
	SelectedIndex = itemIndex;
	// End:0x37
	if(forceToSelect)
	{
		_SetPage(itemIndex / rendererNumPerScroll);
	}
	Validate();
}

function _SetOver(int itemIndex)
{
	// End:0x11
	if(overedIndex == itemIndex)
	{
		return;
	}
	overedIndex = itemIndex;
	Validate();	
}

private function ApplyTileListSetting()
{
	SetMaxScrollLine();
	GetWindowHandleScrollArea().SetScrollHeight(GetScrollMaxPosition());
	GetWindowHandleScrollArea().SetScrollUnit(GetPageWidth(), true);
	firstIndex = -1;
	GetWindowHandleScrollArea().SetScrollPosition(0);
}

private function SetMaxScrollLine()
{
	maxScrollLine = _GetItemNumTotal() / rendererNumPerScroll;
	// End:0x31
	if(_GetItemNumTotal() > maxScrollLine * rendererNumPerScroll)
	{
		maxScrollLine++;
	}	
}

private function OnScroll(int pos)
{
	local int selectedRendererIndex, currentFirstIndex, Page;

	Page = pos / GetPageWidth();
	// End:0x49
	if(pos != Page * GetPageWidth())
	{
		GetWindowHandleScrollArea().SetScrollPosition(Page * GetPageWidth());
		return;
	}
	currentFirstIndex = Page * rendererNumPerScroll;
	// End:0x6C
	if(firstIndex == currentFirstIndex)
	{
		return;
	}
	selectedRendererIndex = _GetItemRendererIndex(SelectedIndex);
	// End:0xCC
	if(selectedRendererIndex > -1 && selectedRendererIndex < _GetItemRendererNum())
	{
		GetTextureHandle(_GetRendererPath(selectedRendererIndex) $ ".SelectTexture").SetAlpha(0);
	}
	firstIndex = currentFirstIndex;
	// End:0xF7
	if(overedRendererIndex > -1)
	{
		overedIndex = _GetItemIndexWithRendererIndex(overedRendererIndex);
	}
	ValidateRefresh();
	Validate();
	DelegateOnScroll();
}

private function SetScrollIndex(int scrollINdex)
{
	GetWindowHandleScrollArea().SetScrollPosition(Min(GetScrollIndexMax(), scrollINdex) * (GetPageWidth()));	
}

private function int GetScrollIndex()
{
	return GetScrollPosition() / GetPageWidth();	
}

private function int GetScrollIndexMax()
{
	return (GetScrollMaxPosition() - ownerStandardWH) / GetPageWidth();	
}

private function int GetScrollPosition()
{
	return GetWindowHandleScrollArea().GetScrollPosition();	
}

function string _GetScrollPath()
{
	return m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollArea";	
}

function string _GetRendererPath(int itemRendererIndex)
{
	return m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollArea.itemRenderer" $ Int2Str(itemRendererIndex);	
}

private function WindowHandle GetWindowHandleItemRederer(int itemRendererIndex)
{
	return GetWindowHandle(_GetRendererPath(itemRendererIndex));
}

private function WindowHandle GetWindowHandleScrollArea()
{
	return GetWindowHandle(_GetScrollPath());
}

private function int GetScrollMaxPosition()
{
	return maxScrollLine * (GetPageWidth());	
}

private function int GetPageWidth()
{
	return standardWH * scrollLineNum;	
}

private function string Int2Str(int Num)
{
	// End:0x19
	if(Num < 10)
	{
		return "0" $ string(Num);
	}
	return string(Num);
}

private function bool ChkInRenderer(int rendererIndex, int X, int Y)
{
	local Rect rendererRect;

	// End:0x0D
	if(rendererIndex < 0)
	{
		return false;
	}
	// End:0x1F
	if(rendererIndex >= (_GetItemRendererNum()))
	{
		return false;
	}
	rendererRect = GetWindowHandle(_GetRendererPath(rendererIndex)).GetRect();
	// End:0x56
	if(X < rendererRect.nX)
	{
		return false;
	}
	// End:0x78
	if(X > rendererRect.nX + rendererRect.nWidth)
	{
		return false;
	}
	// End:0x8E
	if(Y < rendererRect.nY)
	{
		return false;
	}
	// End:0xB0
	if(Y > rendererRect.nY + rendererRect.nHeight)
	{
		return false;
	}
	return true;	
}

private function ClearRendererIndexes()
{
	pressedRendererIndex = -1;
	clickDataLast.Type = non;
	clickDataLast.Name = "";
	clickDataLast.rendererIndex = -1;	
}

defaultproperties
{
}
