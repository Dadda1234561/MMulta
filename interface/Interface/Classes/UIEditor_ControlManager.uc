class UIEditor_ControlManager extends UICommonAPI;

const XML_PATH = "..\\Interface\\Default";
const TIMERID_SELECT = 9;
const TIMER_SELECT = 200;

struct windowInfos
{
	var WindowHandle topWnd;
	var array<string> hiddenList;
	var array<string> foldedList;
};

var WindowHandle Me;

var TextBoxHandle txtNewControl;
var ListBoxHandle lstControls;
var ItemWindowHandle ControlItem;

var TextBoxHandle txtControlAlign;

var TextBoxHandle txtPathStr;

var CheckBoxHandle chkShowWindowBox;
var CheckBoxHandle chkVirtualBack;
var CheckBoxHandle chkExampleAni;
var ButtonHandle btnLeft;
var ButtonHandle btnCenter;
var ButtonHandle btnRight;
var ButtonHandle btnWidth;
var ButtonHandle btnHeight;
//var ButtonHandle	btnTop;
var ButtonHandle btnUp;
var ButtonHandle btnDown;
//var ButtonHandle	btnBottom;

var RichListCtrlHandle richListCurrentControl;

var WindowHandle m_CurTopWnd;

var WindowHandle selectWnd;

var bool bCallfromEvent;

var int lastFindIndex;
var ComboBoxHandle TypeFilter;
var array<windowInfos> attachedWindows;
var int windowInfosCurrentIndex;
var int dontInsertRecordCount;
var bool chkDbClick;

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		// End:0x28
		case TIMERID_SELECT:
			chkDbClick = false;
			m_hOwnerWnd.KillTimer(TIMERID_SELECT);
			// End:0x2B
			break;
	}
}

function InitNewControlList()
{
	local int i;
	local string strName;

	lstControls.Clear();
	TypeFilter.AddString("None");

	// End:0x8F [Loop If]
	for(i = 1; i < 100; i++)
	{
		strName = GetXMLControlString(EXMLControlType(i));
		// End:0x82
		if(Len(strName) > 0)
		{
			TypeFilter.AddString(strName);
			lstControls.AddString(strName);
			// [Explicit Continue]
			continue;
		}
		// [Explicit Break]
		break;
	}
}

function InitControlItem()
{
	local ItemInfo infItem;

	setWindowTitleByString("UIEditor - ControlManager");
	infItem.Name = "NewControl";
	infItem.IconName = "L2UI_CH3.MenuIcon.menuButton4";
	ControlItem.AddItem(infItem);
	txtControlAlign.SetText("Control Align");
	InitNewControlList();
}

event OnRegisterEvent()
{
	RegisterEvent(EV_TrackerAttach);
	RegisterEvent(EV_TrackerDetach);
	RegisterEvent(EV_EditorSetProperty);
}

event OnLoad()
{
	windowInfosCurrentIndex = -1;
	//Init Handle
	InitHandle();
	//Init Control Item
	InitControlItem();
}

function InitHandle()
{
	Me = GetWindowHandle("UIEditor_ControlManager");
	ControlItem = GetItemWindowHandle("UIEditor_ControlManager.NewControlItem");
	lstControls = GetListBoxHandle("UIEditor_ControlManager.lstControls");
	txtControlAlign = GetTextBoxHandle("UIEditor_ControlManager.txtControlAlign");
	txtPathStr = GetTextBoxHandle("UIEditor_ControlManager.txtPathStr");
	chkShowWindowBox = GetCheckBoxHandle("UIEditor_ControlManager.chkShowWindowBox");
	chkVirtualBack = GetCheckBoxHandle("UIEditor_ControlManager.chkVirtualBack");
	chkExampleAni = GetCheckBoxHandle("UIEditor_ControlManager.chkExampleAni");
	btnLeft = GetButtonHandle("UIEditor_ControlManager.btnLeft");
	btnCenter = GetButtonHandle("UIEditor_ControlManager.btnCenter");
	btnRight = GetButtonHandle("UIEditor_ControlManager.btnRight");
	btnWidth = GetButtonHandle("UIEditor_ControlManager.btnWidth");
	btnHeight = GetButtonHandle("UIEditor_ControlManager.btnHeight");
	TypeFilter = GetComboBoxHandle("UIEditor_ControlManager.TypeFilter");
	btnUp = GetButtonHandle("UIEditor_ControlManager.btnUp");
	btnDown = GetButtonHandle("UIEditor_ControlManager.btnDown");
	richListCurrentControl = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".richListCurrentControl");
}

event OnCompleteEditBox(string strID)
{
	switch(strID)
	{
		case "FindBox":
			handleFind();
			break;
	}
}

event OnComboBoxItemSelected(string strID, int Index)
{
	switch(strID)
	{
		case "TypeFilter":
			richListCurrentControl.DeleteAllItem();
			AddChildWIndowToList(m_CurTopWnd, "", 0);
			break;
	}
}

event OnEvent(int Event_ID, string param)
{
	if(Event_ID == EV_TrackerAttach)
	{
		HandleTrackerAttach();
	}
	else if(Event_ID == EV_TrackerDetach)
	{
		HandleTrackerDetach();
	}
	else if(Event_ID == EV_EditorSetProperty)
	{
		HandleEditorSetProperty(param);
	}
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnLeft":
		case "btnCenter":
		case "btnRight":
		case "btnWidth":
		case "btnHeight":
			OnAlignClick(Name);
			break;
		case "btnUp":
		case "btnDown":
			OnOrderClick(Name);
			// End:0xA8
			break;
		// End:0x90
		case "FindBtn":
			handleFind();
			// End:0xA8
			break;
		// End:0xA5
		case "listBtn":
			FoldRecord();
			// End:0xA8
			break;
	}
}

event OnClickItem(string strID, int Index)
{
	switch(strID)
	{
		case "NewControlItem":
			AddControl(selectWnd,0,0);
			break;
	}
}

event OnChangeEditBox(string strID)
{
	switch(strID)
	{
		case "FindBox":
			lastFindIndex = 0;
			break;
	}
}

event OnClickCheckBox(string Name)
{
	switch(Name)
	{
		case "chkShowWindowBox":
			ShowEnableTrackerBox(chkShowWindowBox.IsChecked());
			break;
		case "chkVirtualBack":
			ShowVirtualWindowBackground(chkVirtualBack.IsChecked());
			break;
		case "chkExampleAni":
			ShowExampleAnimation(chkExampleAni.IsChecked());
			break;
	}
}

function OnAlignClick(string Name)
{
	switch(Name)
	{
		case "btnLeft":
			ExecuteAlign(TAT_Left);
			break;
		case "btnCenter":
			ExecuteAlign(TAT_Center);
			break;
		case "btnRight":
			ExecuteAlign(TAT_Right);
			break;
		case "btnWidth":
			ExecuteAlign(TAT_Width);
			break;
		case "btnHeight":
			ExecuteAlign(TAT_Height);
			break;
	}
}

event OnDBClickListCtrlRecord(string strID)
{
	// End:0x24
	if(strID != "richListCurrentControl")
	{
		return;
	}
	SetShowHideSelectedList();
	chkDbClick = false;
	m_hOwnerWnd.KillTimer(9);
}

event OnClickListCtrlRecord(string strID)
{
	// End:0x24
	if(strID != "richListCurrentControl")
	{
		return;
	}
	SetClickListCtrlCurrentSelected();
}

event OnRClickListCtrlRecord(string strID)
{}

event OnRButtonUp(WindowHandle wndHandle, int X, int Y)
{
	ShowContextMenu(X, Y);
}

// »уЗП №жЗвЕ°·О ёЕЕ©·О і»їл, їЎµрЕН №ЪЅє ЖчДїЅє АМµї
event OnKeyUp(WindowHandle a_WindowHandle, EInputKey Key)
{
	// End:0x11
	if(a_WindowHandle != richListCurrentControl)
	{
		return;
	}
	// End:0x61
	if(class'InputAPI'.static.IsCtrlPressed() && class'InputAPI'.static.GetKeyString(Key) == "C")
	{
		listClipboardCopy("richListCurrentControl");
		return;
	}
	switch(Key)
	{
		case IK_Delete:
			SetClickListCtrlCurrentSelected();
			selectWnd.SetFocus();
			DeleteAttachedWindow();
			break;
		case IK_Left:
			FoldRecord();
			break;
		case IK_Right:
			SetShowHideSelectedList();
			break;
		// End:0xAF
		case IK_Space:
			break;
		// End:0xBD
		case IK_Enter:
			SetClickListCtrlCurrentSelected();
			break;
	}
}

event OnKeyDown(WindowHandle a_WindowHandle, EInputKey Key)
{
	local int SelectedIndex;

	// End:0x11
	if(a_WindowHandle != richListCurrentControl)
	{
		return;
	}
	SelectedIndex = richListCurrentControl.GetSelectedIndex();
	switch(Key)
	{
		// End:0x7A
		case IK_Up:
			// End:0x54
			if(class'InputAPI'.static.IsShiftPressed())
			{
				OnOrderClick("btnUp");				
			}
			else if(SelectedIndex > 0)
			{
				richListCurrentControl.SetSelectedIndex(SelectedIndex - 1, true);
			}
			// End:0xDD
			break;
		// End:0xDA
		case IK_Down:
			// End:0xA3
			if(class'InputAPI'.static.IsShiftPressed())
			{
				OnOrderClick("btnDown");				
			}
			else if(SelectedIndex < (richListCurrentControl.GetRecordCount() - 1))
			{
				richListCurrentControl.SetSelectedIndex(SelectedIndex + 1, true);
			}
			// End:0xDD
			break;
	}
}

function SetClickListCtrlCurrentSelected()
{
	local int idx;
	local RichListCtrlRowData rowDdata;

	idx = richListCurrentControl.GetSelectedIndex();
	// End:0x22
	if(idx < 0)
	{
		return;
	}
	bCallfromEvent = false;
	richListCurrentControl.GetRec(idx, rowDdata);
	SelectControl(rowDdata.szReserved);
}

// ДБЖ®·СіЧАУ, Е¬ёі єёµе Д«ЗЗ, ctrl + c
function listClipboardCopy(string strID)
{
	local int idx, SplitCount;
	local RichListCtrlRowData RowData;
	local array<string> arrSplit;

	// End:0x24
	if(strID != "richListCurrentControl")
	{
		return;
	}
	idx = richListCurrentControl.GetSelectedIndex();
	// End:0x46
	if(idx < 0)
	{
		return;
	}
	richListCurrentControl.GetRec(idx, RowData);
	SplitCount = Split(RowData.szReserved, ".", arrSplit);
	// End:0x9D
	if(SplitCount > 0)
	{
		ClipboardCopy(arrSplit[arrSplit.Length - 1]);
	}
}

function DeleteRecordIdexToEnd(int startIdx)
{
	local int i, Len;

	Len = richListCurrentControl.GetRecordCount();

	// End:0x4D [Loop If]
	for(i = startIdx; i < Len; i++)
	{
		richListCurrentControl.DeleteRecord(startIdx);
	}
}

function UpdateControlList()
{
	m_CurTopWnd = none;
}

function FoldRecord()
{
	local int idx;
	local RichListCtrlRowData RowData;
	local WindowHandle hWnd;
	local windowInfos wndInfo;
	local int foldedIndex;
	local bool isFolded;
	local array<WindowHandle> ChildList;

	idx = richListCurrentControl.GetSelectedIndex();
	// End:0x22
	if(idx < 0)
	{
		return;
	}
	richListCurrentControl.GetRec(idx, RowData);
	// End:0x50
	if(RowData.nReserved1 < 1)
	{
		return;
	}
	hWnd = FindWindowHandle(RowData.szReserved);
	ChildList = GetChildWindowListUtil(hWnd);
	// End:0x85
	if(ChildList.Length < 1)
	{
		return;
	}
	foldedIndex = GetfoldedWndIndex(RowData.szReserved);
	isFolded = foldedIndex > -1;
	wndInfo = windowInfosCur();
	// End:0xEF
	if(! isFolded)
	{
		attachedWindows[windowInfosCurrentIndex].foldedList[wndInfo.foldedList.Length] = RowData.szReserved;		
	}
	else
	{
		attachedWindows[windowInfosCurrentIndex].foldedList.Remove(foldedIndex, 1);
	}
	ModifyRecordFolded(idx, ! isFolded);
	dontInsertRecordCount = idx + 1;
	DeleteRecordIdexToEnd(dontInsertRecordCount);
	AddChildWIndowToList(m_CurTopWnd, "", 0);
}

function SetShowHideList(int idx, int hiddenIndex)
{
	local WindowHandle hWnd;
	local windowInfos wndInfo;
	local RichListCtrlRowData RowData;
	local bool isHidden;

	isHidden = hiddenIndex > -1;
	richListCurrentControl.GetRec(idx, RowData);
	// End:0x41
	if(RowData.nReserved1 < 1)
	{
		return;
	}
	hWnd = FindWindowHandle(RowData.szReserved);
	wndInfo = windowInfosCur();
	// End:0xA7
	if(! isHidden)
	{
		attachedWindows[windowInfosCurrentIndex].hiddenList[wndInfo.hiddenList.Length] = RowData.szReserved;
		hWnd.ExitState();		
	}
	else
	{
		attachedWindows[windowInfosCurrentIndex].hiddenList.Remove(hiddenIndex, 1);
		hWnd.EnterState();
	}
	ModifyRecordHidden(idx, ! isHidden);
}

function SetShowHideSelectedList()
{
	local int idx, hiddenIndex;
	local RichListCtrlRowData RowData;

	idx = richListCurrentControl.GetSelectedIndex();
	// End:0x22
	if(idx < 0)
	{
		return;
	}
	richListCurrentControl.GetRec(idx, RowData);
	// End:0x50
	if(RowData.nReserved1 < 1)
	{
		return;
	}
	hiddenIndex = GetHiddenWndIndex(RowData.szReserved);
	SetShowHideList(idx, hiddenIndex);
}

function RefreshControlList()
{
	UpdateControlList();
	HandleTrackerAttach();
}

function HandleTrackerAttach()
{
	local WindowHandle TrackerWnd;
	local WindowHandle TopWnd;
		local int Index;

	TrackerWnd = GetTrackerAttachedWindow();
	if(TrackerWnd==None)
		return;
	
	TopWnd = TrackerWnd.GetTopFrameWnd();
	if(TopWnd == None)
		return;
		
	if(m_CurTopWnd != TopWnd)
	{
		Index = GetTrackerIndex(topWnd);
		if(Index == -1)
		{
			SetChildListDepth(topWnd);
			windowInfosCurrentIndex = attachedWindows.Length;
			AddWindowInfo(topWnd);
		}
		else
			windowInfosCurrentIndex = Index;
		m_CurTopWnd = TopWnd;
		richListCurrentControl.DeleteAllItem();
		AddChildWIndowToList(TopWnd, "", 0);
	}
	// End:0x100
	if(selectWnd != TrackerWnd)
	{
		SelectControlList(GetfullName(TrackerWnd));
		chkDbClick = true;
		m_hOwnerWnd.SetTimer(TIMERID_SELECT, TIMER_SELECT);		
	}
	else if(chkDbClick)
	{
		chkDbClick = false;
		SetShowHideSelectedList();
	}
	else
	{
		chkDbClick = true;
		m_hOwnerWnd.SetTimer(TIMERID_SELECT, TIMER_SELECT);
	}
}

function HandleTrackerDetach()
{
	// End:0x1B
	if(windowInfosCurrentIndex > -1)
	{
		attachedWindows.Remove(windowInfosCurrentIndex, 1);
	}
	m_CurTopWnd = None;
	richListCurrentControl.DeleteAllItem();
}

function HandleEditorSetProperty(string Param)
{
	local string PropertyName;
	local int Count;
	local array<string> NameList;
	
	ParseString(Param, "PropertyName", PropertyName);
	
	if(Len(PropertyName)< 1)
		return;
		
	Count = Split(PropertyName, ".", NameList);
	if(Count < 2)
		return;
		
	if(NameList[Count-1] == "name" && NameList[Count-2] == "DefaultProperty")
	{
		UpdateControlList();
		HandleTrackerAttach();
	}
}

function ModifyRecordHidden(int idx, bool isHidden)
{
	local RichListCtrlRowData RowData;

	richListCurrentControl.GetRec(idx, RowData);
	SetListColorRowData(RowData, ColorByType(RowData.cellDataList[2].szData, isHidden));
	richListCurrentControl.ModifyRecord(idx, RowData);
}

function ModifyRecordFolded(int idx, bool isFolded)
{
	local RichListCtrlRowData RowData;

	richListCurrentControl.GetRec(idx, RowData);
	// End:0x1F7
	if(RowData.cellDataList[0].nReserved1 == 1)
	{
		// End:0x118
		if(isFolded)
		{
			RowData.cellDataList[0].drawitems[0].btnInfo.normalTex.sTex = "l2ui_ch3.QuestWnd.QuestWndPlusBtn";
			RowData.cellDataList[0].drawitems[0].btnInfo.pushedTex.sTex = "l2ui_ch3.QuestWnd.QuestWndPlusBtn_Over";
			RowData.cellDataList[0].drawitems[0].btnInfo.highlightTex.sTex = "l2ui_ch3.QuestWnd.QuestWndPlusBtn_Down";			
		}
		else
		{
			RowData.cellDataList[0].drawitems[0].btnInfo.normalTex.sTex = "l2ui_ch3.QuestWnd.QuestWndMinusBtn";
			RowData.cellDataList[0].drawitems[0].btnInfo.pushedTex.sTex = "l2ui_ch3.QuestWnd.QuestWndMinusBtn_Over";
			RowData.cellDataList[0].drawitems[0].btnInfo.highlightTex.sTex = "l2ui_ch3.QuestWnd.QuestWndMinusBtn_Down";
		}
	}
	richListCurrentControl.ModifyRecord(idx, RowData);
}

function AddChildWIndowToList(WindowHandle hWnd, string ParentName, int depth, optional bool isLast)
{
	local int idx;
	local EXMLControlType Type;
	local string Name, FullName;
	local array<WindowHandle> ChildList;
	local int ChildDepth;
	local string ChildHead;
	local bool isHidden, isFolded;
	local RichListCtrlRowData RowData;
	local Color C;

	// End:0x0D
	if(hWnd == none)
	{
		return;
	}
	Type = hWnd.GetControlType();
	// End:0x34
	if(Type == XCT_None)
	{
		return;
	}
	// End:0x4A
	if(! hWnd.IsShowWindow())
	{
		return;
	}

	//Make Name
	Name = hWnd.GetWindowName();
	// End:0x6E
	if(Len(Name) < 1)
	{
		return;
	}
	// End:0x95
	if(Len(ParentName) > 0)
	{
		FullName = ParentName $ "." $ Name;
	}
	else
	{
		FullName = Name;
	}
	ChildList = GetChildWindowListUtil(hWnd);
	// End:0x13E
	if(depth > 0)
	{
		for(idx=0; idx < depth; idx++)
		{
			// End:0x123
			if(idx == (depth - 1))
			{
				// End:0x10F
				if((ChildList.Length > 0) || isLast)
				{
					ChildHead = ChildHead $ "└";					
				}
				else
				{
					ChildHead = ChildHead $ "┡";
				}
				// [Explicit Continue]
				continue;
			}
			ChildHead = ChildHead $ "·";
		}
	}
	RowData.cellDataList.Length = 4;
	RowData.nReserved1 = depth;
	RowData.szReserved = FullName;
	isHidden = IsHiddenWindow(FullName);
	isFolded = IsFoldedWindow(FullName);
	// End:0x324
	if((ChildList.Length > 0) && m_CurTopWnd != hWnd)
	{
		RowData.cellDataList[0].nReserved1 = 1;
		// End:0x276
		if(isFolded)
		{
			addRichListCtrlButton(RowData.cellDataList[0].drawitems, "listBtn", 2 * depth - 1, 0, "l2ui_ch3.QuestWnd.QuestWndPlusBtn", "l2ui_ch3.QuestWnd.QuestWndPlusBtn_Over", "l2ui_ch3.QuestWnd.QuestWndPlusBtn_Down", 15, 15, 15, 15);			
		}
		else
		{
			addRichListCtrlButton(RowData.cellDataList[0].drawitems, "listBtn", 2 * depth - 1, 0, "l2ui_ch3.QuestWnd.QuestWndMinusBtn", "l2ui_ch3.QuestWnd.QuestWndMinusBtn_Over", "l2ui_ch3.QuestWnd.QuestWndMinusBtn_Down", 15, 15, 15, 15);
		}		
	}
	else
	{
		RowData.cellDataList[0].nReserved1 = 0;
	}
	RowData.cellDataList[0].szData = GetDepthString(depth);
	RowData.cellDataList[1].szData = ChildHead $ Name;
	RowData.cellDataList[1].szReserved = Name;
	RowData.cellDataList[2].szData = GetXMLControlString(Type);
	RowData.cellDataList[3].szData = ReverseParentName(ParentName);
	C = ColorByType(RowData.cellDataList[2].szData, isHidden);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, RowData.cellDataList[1].szData, C);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, RowData.cellDataList[2].szData, C);
	addRichListCtrlString(RowData.cellDataList[3].drawitems, RowData.cellDataList[3].szData, C);
	// End:0x4CC
	if(Type == TypeFilter.GetSelectedNum() || TypeFilter.GetSelectedNum() == 0)
	{
		dontInsertRecordCount--;
		// End:0x4CC
		if(dontInsertRecordCount < 0)
		{
			richListCurrentControl.InsertRecord(RowData);
		}
	}
	// End:0x4E2
	if(! hWnd.IsControlContainer())
	{
		return;
	}
	ChildDepth = depth + 1;
	if(! isFolded)
	{
		for(idx=0; idx<ChildList.Length; idx++)
			AddChildWIndowToList(ChildList[idx],FullName,ChildDepth, idx == (ChildList.Length - 1));
	}
}

function string ReverseParentName(string Name)
{
	local int idx, Count;
	local string NewName;
	local array<string> NameList;
	
	// End:0x10
	if(Len(Name) < 1)
	{
		return "";
	}
	
	Count = Split(Name, ".", NameList);
	for(idx = Count - 1; idx >= 0; idx--)
	{
		// End:0x5F
		if(Len(NewName) > 0)
		{
			NewName = NewName $ ".";
		}
		NewName = NewName $ NameList[idx];
	}
	
	return NewName;
}

function WindowHandle FindWindowHandle(string a_FullName)
{
	local int idx, Count;
	local string NewName;
	local array<string> NameList;
	local WindowHandle ParentHandle, FindedHandle;

	NewName = a_FullName;
	Count = Split(a_FullName, ".", NameList);
	// End:0xB0
	if(Count > 1)
	{
		NewName = "";
		for(idx = 1; idx < Count; idx++)
		{
			// End:0x6A
			if(Len(NewName) > 0)
			{
				NewName = NewName $ ".";
			}
			NewName = NewName $ NameList[idx];
		}
		ParentHandle = m_CurTopWnd;
		
		FindedHandle = FindHandle(NewName, ParentHandle);
	}
	else
		FindedHandle = m_CurTopWnd;

		
	return FindedHandle;
}

function SelectControl(string ControlName)
{
	local WindowHandle hWnd;
	
	// End:0x0F
	if(Len(ControlName) < 1)
	{
		return;
	}
	hWnd = FindWindowHandle(ControlName);
	// End:0x3A
	if(hWnd != none)
	{
		hWnd.SetFocus();
	}

	// Debug("-_-" @ hWnd.GetParentWindowName());
	
	selectWnd = hWnd;
	// End:0x5A
	if(hWnd.IsShowWindow())
	{		
	}
	else
	{
		hWnd.ShowWindow();
	}
}

function SelectControlList(string FullName)
{
	local int idx;
	local WindowHandle hWnd;
	local RichListCtrlRowData RowData;
	// End:0x0F
	if(Len(FullName) < 1)
	{
		return;
	}
	richListCurrentControl.GetRecordCount();

	for(idx= 0; idx < richListCurrentControl.GetRecordCount(); idx++)
	{
		richListCurrentControl.GetRec(idx, RowData);
		// End:0xEC
		if(RowData.szReserved == FullName)
		{
			hWnd = FindWindowHandle(RowData.szReserved);
			// End:0xE9
			if(hWnd != selectWnd)
			{
				selectWnd = hWnd;
				// End:0xE9
				if(hWnd != none)
				{
					richListCurrentControl.SetSelectedIndex(idx, bCallfromEvent);
					txtPathStr.SetText(RowData.cellDataList[3].szData);
					bCallfromEvent = true;
				}
			}
			// [Explicit Break]
			break;
		}
	}
}

function OnOrderClick(String Name)
{
	local WindowHandle TrackerWnd;
	
	TrackerWnd = GetTrackerAttachedWindow();
	if(TrackerWnd==None)
		return;
		
	switch(Name)
	{
		case "btnUp":
			TrackerWnd.ChangeControlOrder(COW_Up);
			break;
		case "btnDown":
			TrackerWnd.ChangeControlOrder(COW_Down);
			break;
	}
	
	RefreshControlList();
}


function EXMLControlType GetCurrentControlType()
{
	return GetXMLControlIndex(GetCurrentControlTypeString());
}

function string GetCurrentControlTypeString()
{
	return lstControls.GetSelectedString();
}

function handleFind()
{
	local int i, Cnt;
	local RichListCtrlRowData RowData;

	Cnt = richListCurrentControl.GetRecordCount();
	
	for(i = lastFindIndex + 1; i < Cnt; i++)
	{
		richListCurrentControl.GetRec(i, RowData);
		if(findMatchString(RowData.cellDataList[1].szReserved, GetEditBoxHandle("FindBox").GetString())!= -1)
		{
			richListCurrentControl.SetSelectedIndex(i, true);
			lastFindIndex = i;
			OnClickListCtrlRecord("richListCurrentControl");
			return;
		}
	}
	lastFindIndex = 0;
}

function int findMatchString(string targetString, string toFindString)
{
	local string delim;

	if(toFindString == "")
	{
		return 1;
	}
	delim = " ";
	if(StringMatching(targetString, toFindString, delim))
	{
		return 1;
	}
	else
	{
		return -1;
	}
	return 1;
}

function int GetTrackerIndex(WindowHandle TrackerWnd)
{
	local int i;

	for(i = 0;i < attachedWindows.Length;i++)
	{
		if(attachedWindows[i].topWnd == TrackerWnd)
		{
			return i;
		}
	}
	return -1;
}

function bool IsHiddenWindow(string wndname)
{
	return GetHiddenWndIndex(wndname)!= -1;
}

function int GetHiddenWndIndex(string wndname)
{
	local int i;
	local windowInfos wndInfo;

	wndInfo = windowInfosCur();
	
	for(i = 0;i < wndInfo.hiddenList.Length;i++)
	{
		if(wndInfo.hiddenList[i] == wndname)
		{
			return i;
		}
	}
	return -1;
}

function bool IsFoldedWindow(string wndname)
{
	return GetfoldedWndIndex(wndname) != -1;
}

function int GetfoldedWndIndex(string wndname)
{
	local int i;
	local windowInfos wndInfo;

	wndInfo = windowInfosCur();

	// End:0x52 [Loop If]
	for(i = 0; i < wndInfo.foldedList.Length; i++)
	{
		// End:0x48
		if(wndInfo.foldedList[i] == wndname)
		{
			return i;
		}
	}
	return -1;
}

function AddWindowInfo(WindowHandle topWnd)
{
	local windowInfos wndInfo;

	wndInfo.topWnd = topWnd;
	attachedWindows[attachedWindows.Length] = wndInfo;
}

function AddControl(WindowHandle targetHandle, int X, int Y)
{
	local WindowHandle ParentHandle;
	local WindowHandle TargetWndHandle;
	local WindowHandle NewWnd;
	local string strTarget;
	local EXMLControlType Type;

	if(targetHandle == None)
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "No Selected Control.", string(self));
		return;
	}
	TargetWndHandle = targetHandle;
	strTarget = targetHandle.GetWindowName();
	Type = GetCurrentControlType();

	while(!TargetWndHandle.IsControlContainer())
	{
		ParentHandle = TargetWndHandle.GetParentWindowHandle();
		if(ParentHandle != none)
		{
			if(ParentHandle.IsControlContainer())
				break; // ¬У¬в¬а¬Х¬Ц ¬Т¬н ¬а¬Я¬а

			ParentHandle = ParentHandle.GetParentWindowHandle();
			continue;
		}
		TargetWndHandle = ParentHandle;
	}

	if(TargetWndHandle == none)
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Can't Select Control to " $ strTarget $ ".", string(self));
		return;
	}
	if(strTarget == "Worksheet")
	{
		if(Type != XCT_FrameWnd && Type != XCT_ScrollWnd)
		{
			DialogShow(DialogModalType_Modalless, DialogType_OK, "Please Drop Container Control First!(Window, ScrollArea..)", string(self));
			return;
		}
	}
	UpdateControlList();
	NewWnd = TargetWndHandle.AddChildWnd(Type);
	if(NewWnd != None)
	{
		SetDefaultValue(NewWnd, Type, strTarget, X, Y);
	}
}

function SetDefaultValue(WindowHandle NewWnd, EXMLControlType Type, string strTarget, int X, int Y)
{
	local int DefaultWidth, defaultHeight;
	local ButtonHandle hButton;
	local TextBoxHandle hTextBox;
	local TextureHandle hTexture;
	local BarHandle hBar;

	DefaultWidth = 50;
	defaultHeight = 50;
	NewWnd.SetEditable(True);

	switch(Type)
	{
		case XCT_FrameWnd:
			if(strTarget == "Worksheet")
			{
				DefaultWidth = 256;
				defaultHeight = 256;
				NewWnd.SetBackTexture("Default.BlackTexture");
				NewWnd.SetXMLDocumentInfo("Created By L2UIEditor Ver1.0", "http://www.lineage2.co.kr/ui", "http://www.w3.org/2001/XMLSchema-instance", "http://www.lineage2.co.kr/ui ..\..\Schema.xsd");
			}
			else
			{
				DefaultWidth = 50;
				defaultHeight = 50;
			}
			break;
		case XCT_Button:
			DefaultWidth = 76;
			defaultHeight = 23;
			hButton = ButtonHandle(NewWnd);
			hButton.SetTexture("L2UI_ct1.Button.Button_DF", "L2UI_ct1.Button.Button_DF_Click", "L2UI_ct1.Button.Button_DF_Over");
			break;
		case XCT_TextBox:
			DefaultWidth = 100;
			defaultHeight = 12;
			hTextBox = TextBoxHandle(NewWnd);
			hTextBox.SetText(hTextBox.GetWindowName());
			break;
		case XCT_EditBox:
			DefaultWidth = 50;
			defaultHeight = 17;
			break;
		case XCT_TextureCtrl:
			hTexture = TextureHandle(NewWnd);
			hTexture.SetTexture("Default.WhiteTexture");
			break;
		case XCT_ChatListBox:
			break;
		case XCT_TabControl:
			break;
		case XCT_ItemWnd:
			break;
		case XCT_CheckBox:
			DefaultWidth = 80;
			defaultHeight = 12;
			break;
		case XCT_ComboBox:
			DefaultWidth = 50;
			defaultHeight = 19;
			break;
		case XCT_ProgressCtrl:
			break;
		case XCT_MultiEdit:
			DefaultWidth = 50;
			defaultHeight = 50;
			break;
		case XCT_ListCtrl:
			break;
		case XCT_ListBox:
			break;
		case XCT_StatusBarCtrl:
			DefaultWidth = 50;
			defaultHeight = 12;
			break;
		case XCT_NameCtrl:
			DefaultWidth = 50;
			defaultHeight = 12;
			break;
		case XCT_MinimapWnd:
			break;
		case XCT_ShortcutItemWnd:
			break;
		case XCT_XMLTreeCtrl:
			break;
		case XCT_SliderCtrl:
			break;
		case XCT_EffectButton:
			break;
		case XCT_TextListBox:
			break;
		case XCT_RadarWnd:
			break;
		case XCT_HtmlViewer:
			break;
		case XCT_RadioButton:
			DefaultWidth = 80;
			defaultHeight = 12;
			break;
		case XCT_InvenWeightWnd:
			break;
		case XCT_StatusIconCtrl:
			break;
		case XCT_BarCtrl:
			DefaultWidth = 50;
			defaultHeight = 6;
			hBar = BarHandle(NewWnd);
			hBar.SetValue(100, 25);
			break;
		case XCT_ScrollWnd:
			break;
		case XCT_FishViewportWnd:
			break;
		case XCT_VIPShopItemInfoWnd:
			break;
		case XCT_VIPShopNeededItemWnd:
			break;
		case XCT_DrawPanel:
			break;
	}
	NewWnd.SetWindowSize(DefaultWidth, defaultHeight);
	NewWnd.SetFocus();
}

function windowInfos windowInfosCur()
{
	return attachedWindows[windowInfosCurrentIndex];
}

function string GetfullName(WindowHandle hWnd)
{
	local EXMLControlType Type;
	local string FullName, ParentName;
	local WindowHandle hParent;
	
	// End:0x11
	if(hWnd == none)
	{
		return FullName;
	}
	FullName = hWnd.GetWindowName();
	hParent = hWnd.GetParentWindowHandle();
	while(hParent != none)
	{
		ParentName = hParent.GetWindowName();
		// End:0x8B
		if(ParentName == "Console" || ParentName == "Worksheet")
		{
			return FullName;
		}
		Type = hParent.GetControlType();
		// End:0xD6
		if(Type != XCT_None && Len(ParentName) > 0)
		{
			FullName = (ParentName $ ".") $ FullName;
		}
		hParent = hParent.GetParentWindowHandle();
	}
	return FullName;
}

function Color ColorByType(string Type, bool isHidden)
{
	// End:0x19
	if(isHidden)
	{
		return getInstanceL2Util().DarkGray;
	}
	switch(Type)
	{
		// End:0x3B
		case "Window":
			return getInstanceL2Util().DRed;
		// End:0x56
		case "Button":
			return getInstanceL2Util().Gold;
		// End:0x72
		case "Texture":
			return getInstanceL2Util().ColorGray;
		// End:0xFFFF
		default:
			return getInstanceL2Util().White;
			break;
	}
}

function string GetDepthString(int depth)
{
	return "";
	switch(depth)
	{
		// End:0x11
		case 0:
			return "";
		// End:0x1A
		case 1:
			return "¹";
		// End:0x24
		case 2:
			return "₂";
		// End:0x2E
		case 3:
			return "³";
		// End:0x38
		case 4:
			return "₄";
		// End:0x42
		case 5:
			return "ⁿ";
		// End:0xFFFF
		default:
			return "ⁿ";
			break;
	}
}

function SetListColorRowData(out RichListCtrlRowData RowData, Color sColor)
{
	RowData.cellDataList[1].drawitems[0].strInfo.strColor = sColor;
	RowData.cellDataList[2].drawitems[0].strInfo.strColor = sColor;
	RowData.cellDataList[3].drawitems[0].strInfo.strColor = sColor;
}

function array<WindowHandle> GetChildWindowListUtil(WindowHandle hWnd)
{
	local array<WindowHandle> ChildList;

	switch(hWnd.GetControlType())
	{
		// End:0x16
		case XCT_TabControl:
		// End:0x1E
		case XCT_ListBox:
			// End:0x38
			break;
		// End:0xFFFF
		default:
			hWnd.GetChildWindowList(ChildList);
			break;
	}
	return ChildList;
}

function SetChildListDepth(WindowHandle hWnd)
{
	local int i;
	local array<WindowHandle> childListBack, ChildList, childListTop, childes;

	childes = GetChildWindowListUtil(hWnd);

	// End:0xB0 [Loop If]
	for(i = 0; i < childes.Length; i++)
	{
		// End:0x5B
		if(childes[i].IsAlwaysOnBack())
		{
			childListBack[childListBack.Length] = childes[i];
			// [Explicit Continue]
			continue;
		}
		// End:0x8E
		if(childes[i].IsAlwaysOnTop())
		{
			childListTop[childListTop.Length] = childes[i];
			// [Explicit Continue]
			continue;
		}
		ChildList[ChildList.Length] = childes[i];
	}

	// End:0xE9 [Loop If]
	for(i = childListBack.Length - 1; i >= 0; i--)
	{
		childListBack[i].BringToFront();
	}

	// End:0x122 [Loop If]
	for(i = ChildList.Length - 1; i >= 0; i--)
	{
		ChildList[i].BringToFront();
	}

	// End:0x158 [Loop If]
	for(i = 0; i < childListTop.Length; i++)
	{
		childListTop[i].BringToFront();
	}

	// End:0x18A [Loop If]
	for(i = 0; i < childes.Length; i++)
	{
		SetChildListDepth(childes[i]);
	}
}

function string MakeHelpString()
{
	local string help, breakLine;

	breakLine = "\\n·";
	help = "※단축키";
	help = help $ breakLine $ "ENTER : 선택";
	help = help $ breakLine $ "더블클릭 : 숨기기/켜기";
	help = help $ breakLine $ "↑ : 위 선택";
	help = help $ breakLine $ "↓ : 아래 선택";
	help = help $ breakLine $ "→ : 숨기기/켜기";
	help = help $ breakLine $ "← : 폴더접고 펴기";
	help = help $ breakLine $ "+, - 버튼 클릭 : 폴더접고 펴기";
	help = help $ breakLine $ "DELETE : 삭제";
	return help;
}

function HandleOnClickContextMenu(int Index)
{
	local int i;

	switch(Index)
	{
		// End:0x14
		case 0:
			SetShowHideSelectedList();
			// End:0xE9
			break;
		// End:0x21
		case 1:
			FoldRecord();
			// End:0xE9
			break;
		// End:0x94
		case 2:
			// End:0x78 [Loop If]
			for(i = 0; i < attachedWindows[windowInfosCurrentIndex].hiddenList.Length; i++)
			{
				FindWindowHandle(attachedWindows[windowInfosCurrentIndex].hiddenList[i]).EnterState();
			}
			attachedWindows[windowInfosCurrentIndex].hiddenList.Length = 0;
			RefreshControlList();
			// End:0xE9
			break;
		// End:0x9C
		case 3:
			// End:0xE9
			break;
		// End:0xA4
		case 4:
			// End:0xE9
			break;
		// End:0xC5
		case 5:
			attachedWindows[windowInfosCurrentIndex].foldedList.Length = 0;
			RefreshControlList();
			// End:0xE9
			break;
		// End:0xE6
		case 999:
			DialogShow(DialogModalType_Modalless, DialogType_OK, MakeHelpString(), string(self), 0, 200);
			// End:0xE9
			break;
	}
}

function ShowContextMenu(int X, int Y)
{
	local int idx;
	local RichListCtrlRowData RowData;
	local UIControlContextMenu ContextMenu;

	idx = richListCurrentControl.GetSelectedIndex();
	richListCurrentControl.GetRec(idx, RowData);
	ContextMenu = class'UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	// End:0x9B
	if((GetHiddenWndIndex(RowData.szReserved)) > -1)
	{
		ContextMenu.MenuNew("보이기", 0);		
	}
	else
	{
		ContextMenu.MenuNew("숨기기", 0);
	}
	// End:0x117
	if(RowData.cellDataList[0].nReserved1 > 0)
	{
		// End:0xFF
		if(GetfoldedWndIndex(RowData.szReserved) > -1)
		{
			ContextMenu.MenuNew("+ 펴기", 1);			
		}
		else
		{
			ContextMenu.MenuNew("- 접기", 1);
		}
	}
	ContextMenu.MenuLineAdd();
	ContextMenu.MenuNew("모두 보이기", 2);
	ContextMenu.MenuNew("+ 모두 펴기", 5);
	ContextMenu.MenuNew("※단축키", 999, getInstanceL2Util().ColorGray);
	ContextMenu.Show(X + 1, Y + 1, string(self));
}

defaultproperties
{
}
