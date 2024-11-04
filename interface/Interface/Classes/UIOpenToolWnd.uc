/**
 *    UC ������ �������� UI ���⸦ �ϵ��� �ϴ� �׽�Ʈ �� 
 *    Create By : dongland
 **/
class UIOpenToolWnd extends UICommonAPI;

var WindowHandle   Me;

var ButtonHandle   searchBtn;
var ButtonHandle   InitBtn;
var ButtonHandle   showBtn;

var EditBoxHandle  searchEditBox;
var EditBoxHandle  itemCountEditBox;
var EditBoxHandle  descViewEditBox;

var ListCtrlHandle itemListCtrl;

var Array<string> FileList;
var string m_CurPath;

const XML_EXT  = ".xml";
const UC_EXT   = ".uc";
const PREV_DIR = "..";

function OnRegisterEvent()
{
	//RegisterEvent(  );
}

function OnLoad()
{
	SetClosingOnESC(); 
	Initialize();
	Load();
}

function Initialize()
{
	Me               = GetWindowHandle( "UIOpenToolWnd" );

	// ����Ʈ �ڽ�
	itemListCtrl     = GetListCtrlHandle( "UIOpenToolWnd.itemListCtrl" );

	// ������ �ڽ�
	searchEditBox    = GetEditBoxHandle( "UIOpenToolWnd.searchEditBox" );
	itemCountEditBox = GetEditBoxHandle( "UIOpenToolWnd.itemCountEditBox" );
	descViewEditBox  = GetEditBoxHandle( "UIOpenToolWnd.descViewEditBox" );

	// ��ư
	searchBtn        = GetButtonHandle( "UIOpenToolWnd.searchBtn" );
	InitBtn          = GetButtonHandle( "UIOpenToolWnd.InitBtn" );
	showBtn          = GetButtonHandle( "UIOpenToolWnd.showBtn" );
}

function Load()
{
	//..
}

function onShow()
{
	setWindowTitleByString("UIOpenTool [UC Files List]");
	m_CurPath = GetInterfaceDir() $ "\\CLASSES\\COMMON\\";
	updateUCFiles();
}

function OnClickButton( string Name )
{
	local string str;

	switch( Name )
	{
		case "searchBtn":
			 OnsearchBtnClick();
			 break;

		case "InitBtn":
			 OnInitBtnClick();
			 break;

		case "showBtn":
			 OnshowBtnClick();
			 break;

		case "copyBtn" :
			 str = descViewEditBox.GetString();
			 if (str != "")  
			 {
				getInstanceL2Util().showGfxScreenMessage("Copy!! ClipBoard  -o-)/");
				ClipboardCopy(descViewEditBox.GetString());
			 }
			break;
	}
}

function OnsearchBtnClick()
{
	local int idx;
	local LVDataRecord recordInfo;
	
	if (searchEditBox.GetString() == "")
	{
		updateUCFiles(); 
		return;
	}

	itemListCtrl.DeleteAllItem();

	searchEditBox.ClearAdditionalSearchList(ESearchListType.SLT_ADDITIONAL_LIST);
	for( idx=0; idx < FileList.Length; idx++ )
	{

		if ( InStr( Caps(FileList[idx]), Caps(searchEditBox.GetString()) ) != -1 )
		{
			recordInfo.LVDataList.length = 3;
			recordInfo.LVDataList[0].szData = FileList[idx];

			itemListCtrl.InsertRecord(recordInfo);
			
			searchEditBox.AddNameToAdditionalSearchList(FileList[idx], ESearchListType.SLT_ADDITIONAL_LIST);

		}
		//Debug("FileList[idx]"@FileList[idx]);
	}

	itemCountEditBox.SetString(String(itemListCtrl.GetRecordCount()));	
}

function OnInitBtnClick()
{
	searchEditBox.SetString("");
}

function string GetSelectedStr()
{
	local LVDataRecord Record;
	
	local string str;

	itemListCtrl.GetSelectedRec(Record);

	str = "///sw name=" $ Record.LVDataList[0].szData;

	return str;
}

function OnClickListCtrlRecord(string str)
{
	Debug("str" @ str);
	descViewEditBox.SetString(GetSelectedStr());
}

function OnShowBtnClick()
{
	local LVDataRecord Record;
	
	local string str;

	itemListCtrl.GetSelectedRec(Record);

	str = Record.LVDataList[0].szData;

	if( str != "" )
	{
		if ( class'UIAPI_WINDOW'.static.IsShowWindow (str) )
		{
			class'UIAPI_WINDOW'.static.HideWindow(str);
		}
		else
		{
			class'UIAPI_WINDOW'.static.ShowWindow(str);			
			class'UIAPI_WINDOW'.static.SetFocus(str);
		}
	}	
}

function OnDBClickListCtrlRecord( string ListCtrlID)
{
	if (ListCtrlID == "itemListCtrl") OnShowBtnClick();
}


function updateUCFiles()
{
	
	local int idx;

	local LVDataRecord recordInfo;
	local LVData data1;

	// local script NewWindow;
	
	itemListCtrl.DeleteAllItem();
	
	searchEditBox.ClearAdditionalSearchList(ESearchListType.SLT_ADDITIONAL_LIST);
	FileList.Remove(0, FileList.Length);
	GetFileList( FileList, m_CurPath, UC_EXT );
	
	for( idx=0; idx<FileList.Length; idx++ )
	{
		FileList[idx] = Left( FileList[idx], Len(FileList[idx]) - 3 );

		data1.szData = FileList[idx];

		recordInfo.LVDataList.length = 3;
		recordInfo.LVDataList[0] = data1;

		// Debug(""@ GetWindowHandle( data1.szData ).IsEnableWindow());

		//// �ָŷ� gfx ���� uc���� �Ǵ�.. (��Ȯ���� ���� ����..-_-..)
		//if (NewWindow.IsEnableWindow() == true)
		//{
		//	recordInfo.LVDataList[1].szData = "XML";
		//}
		//else
		//{
		//	recordInfo.LVDataList[1].szData = "GFX";
		//}

		itemListCtrl.InsertRecord(recordInfo);

		searchEditBox.AddNameToAdditionalSearchList(FileList[idx], ESearchListType.SLT_ADDITIONAL_LIST);
	}

	descViewEditBox.SetString("Total UC Files: " $ FileList.Length);
}

/** OnKeyUp */
function OnKeyUp( WindowHandle a_WindowHandle, EInputKey nKey )
{
	// local string MainKey;

	// Ű���� �������� üũ 	
	if (searchEditBox.IsFocused())
	{	
		// txtPath
		if (nKey == IK_Enter) 
		{
			// Ű���� �Է��� �ƹ��͵� �Է� ���� �ʾ����� ��ü �˻��� ������� �ʴ´�.
			// �Ǽ��� �ڲ� ������ ��찡 �־..
			if (trim(searchEditBox.GetString()) != "") OnsearchBtnClick();
		}
	}
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "UIOpenToolWnd" ).HideWindow();
}

defaultproperties
{
}
