class UIListNoteWnd extends UICommonAPI;

var private RichListCtrlHandle itemListCtrl;
var private EditBoxHandle EditBox;
var private UIControlSimpleListEditor Editor;
var private WindowHandle Owner;
var string sessionName;

delegate string delegateGetTitle();

delegate string delegateGetParam();

delegate delegateOnDBClick(string param)
{}

static function UIListNoteWnd Inst()
{
	return UIListNoteWnd(GetScript("UIListNoteWnd"));
}

function Initialize()
{
	itemListCtrl = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".itemListCtrl");
	EditBox = GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".editBox");
	Editor = class'UIControlSimpleListEditor'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".UIControlSimpleListEditorExpands"));
	Editor._SetTargetRichCtrlHandleList(itemListCtrl);
	Editor._SetEditBoxHandle(EditBox);
	Editor._SetSessionName(m_hOwnerWnd.m_WindowNameWithFullPath);
	Editor.delegateGetParam = getParam;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

event OnShow()
{
	itemListCtrl.DeleteAllItem();
	Editor.LoadAll();
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData Record;

	itemListCtrl.GetRec(itemListCtrl.GetSelectedIndex(), Record);
	delegateOnDBClick(Record.szReserved);
}

function _Show(WindowHandle _owner, optional string iniName, optional string sessionName, optional string KeyName)
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.HideWindow();
		return;
	}
	Owner = _owner;
	class'L2Util'.static.Inst().windowAnchorToSide(Owner, m_hOwnerWnd, 10);
	m_hOwnerWnd.SetWindowTitle("〓" $ Owner.m_WindowNameWithFullPath);

	if(KeyName == "")
	{
		KeyName = _owner.m_WindowNameWithFullPath;
	}
	if(sessionName == "")
	{
		sessionName = m_hOwnerWnd.m_WindowNameWithFullPath;
	}
	if(iniName == "")
	{
		iniName = "UIDevSimpleListEditor";
	}
	SetIniName(iniName);
	Editor._SetKeyName(KeyName);
	Editor._SetSessionName(sessionName);
	itemListCtrl.DeleteAllItem();
	ShowWindowWithFocus(m_hOwnerWnd.m_WindowNameWithFullPath);
}

function _SetString(string Str)
{
	EditBox.SetString(Str);
}

function string _GetString()
{
	return EditBox.GetString();
}

private function SetIniName(string iniName)
{
	Editor._SetIniname(iniName);
}

function string GetName()
{
	return delegateGetTitle();
}

function string getParam()
{
	return delegateGetParam();
}

private function RichListCtrlRowData makeRecord(string _title, string _param)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 1;
	Record.szReserved = _param;
	Record.cellDataList[0].szData = _title;
	addRichListCtrlString(Record.cellDataList[0].drawitems, _title, getInstanceL2Util().BrightWhite, false, 4, 4);
	return Record;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("UISoundWnd").HideWindow();
}

defaultproperties
{
}
