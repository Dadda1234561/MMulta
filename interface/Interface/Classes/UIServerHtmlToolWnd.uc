/***
 * 
 *  UI-HTMLTOOL  Dongland �� �۾� �ø��� 3
 *  
 *  UIServerHtmlToolWnd
 *  
 *  $ShanghaiStudio/Graphic/UI�۾�/HtmlList2INI/  ������ ����, Ư�� html ������ ����Ʈ�� INI �� ����� ���α׷��� ����.
 *  �װɷ� serverHtmlList.ini �� �̾� ���� System ������ ī�� �ؼ� ��� �ϴ� ������
 *  
 **/

class UIServerHtmlToolWnd extends UICommonAPI;
const TIME_ID    = 2001111;
const TIME_DELAY = 100;

var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;

var string m_fileName;

function OnLoad()
{
	SetClosingOnESC(); 
	//getInstanceUIData().addEscCloseWindow(getCurrentWindowName(string(Self)));

	Me = GetWindowHandle("UIServerHtmlToolWnd");
	FileListCtrl = GetListCtrlHandle("UIServerHtmlToolWnd.fileListCtrl");
	FileListCtrl.SetHeaderAlignment(0,TA_LEFT);
	FileListCtrl.SetResizable(false);

	EditBoxCtrl = GetEditBoxHandle("UIServerHtmlToolWnd.fileNameEditBox");
	// EditBoxCtrl.ClearAdditionalSearchList(ESearchListType.SLT_ADDITIONAL_LIST);

	setWindowTitleByString("UIPowerTools - [ ServerHtmlTool ]");
}

//function OnEvent(int Event_ID, String param)
//{
//	switch( Event_ID )
//	{
//		case EV_LostFocus: Debug(param);
//	}
//}

function int SearchFileListWithName(string s)
{
	local int i, num;
	local LVDataRecord record;
	num = FileListCtrl.GetRecordCount();

	for ( i = 0; i < num; ++i )
	{
		FileListCtrl.GetRec(i,record);
		if ( record.LVDataList[0].szData == s )
			return i;
	}
	return -1;
}


function OnDBClickListCtrlRecord( String strID )
{
	local int Idx;
	local LVDataRecord record;

	if ( strID != "fileListCtrl" )
		return;
	
	Idx = FileListCtrl.GetSelectedIndex();
	if( Idx < 0 )
		return;
		
	FileListCtrl.GetRec( Idx, record );
	
	if (record.LVDataList[0].szData != "") loadServerHtml(record.LVDataList[0].szData);

	FileListCtrl.SetFocus();
	Me.KillTimer(TIME_ID);
	Me.SetTimer(TIME_ID, TIME_DELAY);
}

function OnTimer(int TimeID)
{
	if (TimeID ==TIME_ID)
	{
		FileListCtrl.SetFocus();
		Me.KillTimer(TIME_ID);
	}
}
function OnClickListCtrlRecord( String strID )
{
	local int Idx;
	local LVDataRecord record;
	
	if( strID != "fileListCtrl" )
		return;

	Idx = FileListCtrl.GetSelectedIndex();

	if( Idx < 0 )
		return;
	
	FileListCtrl.GetRec( Idx, record );

	// Debug("record.LVDataList[0].szData" @ record.LVDataList[0].szData);	
	EditBoxCtrl.SetString(record.LVDataList[0].szData);
}

function addHtmlFileAtList(string fileName  )
{
	local LVDataRecord Record;
	
	Record.LVDataList.Length = 1;
	Record.LVDataList[0].szData = fileName;

	FileListCtrl.InsertRecord(Record);
}


function OnShow()
{	
	EditBoxCtrl.Clear();	
	FileListCtrl.InitListCtrl();
	FileListCtrl.DeleteAllItem();

	// getHtmlListInINI();
} 

function getHtmlListInINI()
{
	local string tempString;
	local int i, fileCount;	

	EditBoxCtrl.Clear();	
	FileListCtrl.DeleteAllItem();

	GetINIString("HtmlList", "totalFileCount", tempstring, "serverHtmlList.ini");

	fileCount = int(tempstring);

	for (i = 0; i < fileCount; i++)
	{
		GetINIString("HtmlList", "html" $ i, tempstring, "serverHtmlList.ini");
		addHtmlFileAtList(tempstring);
	}
}

function OnHide()
{
}


function OnClickButton( string strID )
{
	switch( strID )
	{
		case "htmlSmallViewButton" : OnDBClickListCtrlRecord("fileListCtrl"); break;
		case "refreshButton"       : getHtmlListInINI(); break; // loadServerHtml(EditBoxCtrl.GetString()); break;
	}
}

function loadServerHtml(string htmlFileName)
{
	ExecuteCommand("//loadhtml " $ htmlFileName );	

	EditBoxCtrl.AddNameToAdditionalSearchList(htmlFileName, ESearchListType.SLT_ADDITIONAL_LIST);

	//FileListCtrl.SetSelectedIndex(Idx, false);
	//if (Idx > 24) FileListCtrl.SetScrollPosition(Idx - 24);
}

/** OnKeyUp */
function OnKeyUp( WindowHandle a_WindowHandle, EInputKey nKey )
{
	// Ű���� �������� üũ 	
	if (EditBoxCtrl.IsFocused())
	{	
		if (nKey == IK_Enter) 
		{
			Debug("EditBoxCtrl");
			loadServerHtml(EditBoxCtrl.GetString());
		}
	}
	else if (FileListCtrl.IsFocused())
	{
		if (nKey == IK_Enter) 
		{
			Debug("���ϸ���Ʈ");
			OnDBClickListCtrlRecord("fileListCtrl");
			
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
	GetWindowHandle("UIServerHtmlToolWnd").HideWindow();
}

defaultproperties
{
}
