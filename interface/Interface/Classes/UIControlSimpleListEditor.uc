class UIControlSimpleListEditor extends UICommonAPI;

struct COPYED_DATA_STRUCT
{
	var string Title;
	var string param;
};

var private RichListCtrlHandle targetList;
var private EditBoxHandle targetEditBox;
var string iniName;
var string sessionName;
var string KeyName;
var COPYED_DATA_STRUCT copyed_data;

delegate DelegateOnInsert(string _title, string _param)
{}

delegate DelegateOnUp()
{}

delegate DelegateOnDown()
{}

delegate DelegateOnX()
{}

delegate DelegateOnDeleteAll()
{}

delegate DelegateOnCopy()
{}

delegate DelegateOnPaste()
{}

delegate DelegateHandleInsertDialogOK()
{}

delegate string delegateGetTitle();

delegate string delegateGetParam();

static function UIControlSimpleListEditor InitScript(WindowHandle wnd)
{
	local UIControlSimpleListEditor scr;

	wnd.SetScript("UIControlSimpleListEditor");
	scr = UIControlSimpleListEditor(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

private function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	_SetIniname("UIDevSimpleListEditor");
}

function _SetTargetRichCtrlHandleList(RichListCtrlHandle _targetRichList)
{
	targetList = _targetRichList;
	sessionName = targetList.m_WindowNameWithFullPath;
	LoadAll();
}

function _SetEditBoxHandle(EditBoxHandle Editor)
{
	targetEditBox = Editor;
}

function _InsertRecord(RichListCtrlRowData Record)
{
	targetList.InsertRecord(Record);
	Save(Record.cellDataList[0].szData, Record.szReserved);
	DelegateOnInsert(Record.cellDataList[0].szData, Record.szReserved);
	targetList.SetSelectedIndex(targetList.GetRecordCount() - 1, true);
}

function _Insert(string param)
{
	_InsertRecord(makeRecord(class'DialogBox'.static.Inst().GetEditMessage(), param));
}

private function HandleInsertDialogOK()
{
	local string Title;

	Title = class'DialogBox'.static.Inst().GetEditMessage();

	if(Title == "")
	{
		return;
	}
	_Insert(delegateGetParam());
	DelegateHandleInsertDialogOK();
}

function _SetKeyName(string _keyName)
{
	KeyName = _keyName;
}

function _SetSessionName(string _sessionName)
{
	sessionName = _sessionName;
}

function _SetIniname(string _iniName)
{
	iniName = _iniName;
}

function Save(string Title, string param)
{
	saveIndex(Title, param, targetList.GetRecordCount() - 1);
}

function saveIndex(string Title, string param, int Index)
{
	SetINIString(sessionName, (KeyName $ "_") $ string(Index), param, iniName);
	SaveINI(iniName);
}

function SaveAll()
{
	local int Index;
	local RichListCtrlRowData Record;

	for(Index = 0; Index < targetList.GetRecordCount(); Index++)
	{
		targetList.GetRec(Index, Record);
		saveIndex(Record.cellDataList[0].szData, Record.szReserved, Index);
	}
	SaveINI(iniName);
}

function LoadAll()
{
	local int Index;
	local string savedString, Title;

	while(GetINIString(sessionName, KeyName $ "_" $ string(Index), savedString, iniName))
	{
		ParseString(savedString, "*t", Title);
		targetList.InsertRecord(makeRecord(Title, savedString));
		Index++;
	}
}

function RemoveAll()
{
	RemoveINI(sessionName, "", iniName);
	SaveINI(iniName);
}

function RemoveIndex(int Index)
{
	local RichListCtrlRowData Record;

	targetList.DeleteRecord(Index);

	for(Index = Index; Index < targetList.GetRecordCount(); Index++)
	{
		targetList.GetRec(Index, Record);
		SetINIString(sessionName, (KeyName $ "_") $ string(Index), Record.szReserved, iniName);
	}
	RemoveINI(sessionName, (KeyName $ "_") $ string(targetList.GetRecordCount()), iniName);
	SaveINI(iniName);
}

function Copy()
{
	local int Index;
	local RichListCtrlRowData Record;

	Index = targetList.GetSelectedIndex();
	targetList.GetRec(Index, Record);
	copyed_data.Title = Record.cellDataList[0].szData;
	copyed_data.param = Record.szReserved;
}

function Paste()
{
	_InsertRecord(makeRecord(copyed_data.Title, copyed_data.param));
}

function OnAddClicked()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKInput, GetSystemMessage(328), string(self));
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultOK);
	class'DialogBox'.static.Inst().DelegateOnOK = HandleInsertDialogOK;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "BtnEditAdd":
			OnAddClicked();
			if(targetEditBox.m_pTargetWnd != none)
			{
				class'DialogBox'.static.Inst().SetEditMessage(targetEditBox.GetString());
			}
			break;
		case "Copy_Btn":
			Copy();
			DelegateOnCopy();
			break;
		case "Paste_Btn":
			Paste();
			DelegateOnPaste();
			break;
		case "BtnEditdel":
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, "선택 된 항목을 삭제 하시겠습니까?", string(self));
			class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
			class'DialogBox'.static.Inst().DelegateOnOK = DelSelected;
			break;
		case "BtnEditAlldel":
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, "모든 항목을 삭제 하시겠습니까?", string(self));
			class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
			class'DialogBox'.static.Inst().DelegateOnOK = DelAll;
			break;
		case "BtnEditUp":
			HandleUP();
			break;
		case "BtnEditDown":
			HandleDown();
			break;
	}
}

private function DelSelected()
{
	RemoveIndex(targetList.GetSelectedIndex());
	DelegateOnX();
}

private function DelAll()
{
	targetList.DeleteAllItem();
	RemoveAll();
	DelegateOnDeleteAll();
	DelegateOnX();
}

private function HandleUP()
{
	local int SelectedIndex;
	local RichListCtrlRowData Record, Record2;

	DelegateOnUp();

	if(targetList.GetSelectedIndex() > 0)
	{
		SelectedIndex = targetList.GetSelectedIndex();
		targetList.GetRec(SelectedIndex, Record);
		targetList.GetRec(SelectedIndex - 1, Record2);
		targetList.ModifyRecord(SelectedIndex - 1, Record);
		targetList.ModifyRecord(SelectedIndex, Record2);
		targetList.SetSelectedIndex(SelectedIndex - 1, true);
		saveIndex(Record.cellDataList[0].szData, Record.szReserved, SelectedIndex - 1);
		saveIndex(Record2.cellDataList[0].szData, Record2.szReserved, SelectedIndex);
	}
}

private function HandleDown()
{
	local int SelectedIndex;
	local RichListCtrlRowData Record, Record2;

	DelegateOnDown();

	if(targetList.GetRecordCount() > (targetList.GetSelectedIndex() + 1))
	{
		SelectedIndex = targetList.GetSelectedIndex();
		targetList.GetRec(SelectedIndex, Record);
		targetList.GetRec(SelectedIndex + 1, Record2);
		targetList.ModifyRecord(SelectedIndex + 1, Record);
		targetList.ModifyRecord(SelectedIndex, Record2);
		targetList.SetSelectedIndex(SelectedIndex + 1, true);
		saveIndex(Record.cellDataList[0].szData, Record.szReserved, SelectedIndex + 1);
		saveIndex(Record2.cellDataList[0].szData, Record2.szReserved, SelectedIndex);
	}
}

private function RichListCtrlRowData makeRecord(string _title, string _param)
{
	local RichListCtrlRowData Record;

	ParamAdd(_param, "*t", _title);
	Record.cellDataList.Length = 1;
	Record.szReserved = _param;
	Record.cellDataList[0].szData = _title;
	addRichListCtrlString(Record.cellDataList[0].drawitems, _title, getInstanceL2Util().BrightWhite, false, 4, 4);
	return Record;
}

defaultproperties
{
}
