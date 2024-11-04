class UIEditor_FileManager extends UICommonAPI;

const XML_EXT = ".xml";
const UC_EXT = ".uc";
const PREV_DIR = "..";
const TIMER_ID_UPDATEUI = 1022345;
const DELAY_UPDATEUI = 3000;

var WindowHandle Me;
var ListCtrlHandle lstDirs;
var ListCtrlHandle lstFiles;
var ButtonHandle btnLoad;
var ButtonHandle btnSave;
var ButtonHandle btnMakeUC;
var ButtonHandle exitButton;
var ButtonHandle reLoadButton;
var EditBoxHandle txtPath;
var WindowHandle WorkSheet;
var CheckBoxHandle AutoReloadCheckBox;
var string m_CurPath, lastLoadedFile;
var string m_LastCurPath;
var array<string> dirNameArray;
var array<string> fileNameArray;

function InitHandle()
{
	Me = GetWindowHandle("UIEditor_FileManager");
	lstDirs = GetListCtrlHandle("UIEditor_FileManager.wndFileManager.lstDirs");
	lstFiles = GetListCtrlHandle("UIEditor_FileManager.wndFileManager.lstFiles");
	btnLoad = GetButtonHandle("UIEditor_FileManager.wndFileManager.btnLoad");
	btnSave = GetButtonHandle("UIEditor_FileManager.wndFileManager.btnSave");
	btnMakeUC = GetButtonHandle("UIEditor_FileManager.wndFileManager.btnMakeUC");
	txtPath = GetEditBoxHandle("UIEditor_FileManager.wndFileManager.txtPath");
	WorkSheet = GetWindowHandle("Worksheet.Worksheet");
	reLoadButton = GetButtonHandle("UIEditor_FileManager.reLoadButton");
	AutoReloadCheckBox = GetCheckBoxHandle("UIEditor_FileManager.AutoReloadCheckBox");
}

function InitControlItem()
{
	//Set Title
	setWindowTitleByString("UIEditor - FileManager");
	//Interface Path
	m_CurPath = GetOptionString("UIEditor", "SysPath");
	if( Len(m_CurPath) > 1 )
	{
		//Debug("InStr( strID ,GetInterfaceDir() )" @ InStr( m_CurPath ,GetInterfaceDir() ));

		if ( InStr( m_CurPath ,GetInterfaceDir() ) <= -1 )
		{
			m_CurPath = GetInterfaceDir() $ "\\Default\\";
		}
	}
	else
	{
		m_CurPath = GetInterfaceDir() $ "\\Default\\";
	}

	txtPath.SetString( m_CurPath );
}

//var name m_PrevStateName;

event OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
}

event OnLoad()
{
	//Init Handle
	InitHandle();
	//Init Control Item
	InitControlItem();
	Update();
}

event OnShow()
{
	Me.KillTimer(TIMER_ID_UPDATEUI);
	// Me.SetTimer(TIMER_ID_UPDATEUI, DELAY_UPDATEUI);
	AutoReloadCheckBox.SetCheck(false);
}

event OnHide()
{
	Me.KillTimer(TIMER_ID_UPDATEUI);
	AutoReloadCheckBox.SetCheck(false);	
}

event OnTimer(int timerID)
{
	if(timerID == TIMER_ID_UPDATEUI)
	{
		if(AutoReloadCheckBox.IsChecked())
		{
			// reLoadButton.SetFocus();
			//OnClickButton("reLoadButton");			
			reloadTargetXMLUI();
			Me.KillTimer(TIMER_ID_UPDATEUI);
			Me.SetTimer(TIMER_ID_UPDATEUI, DELAY_UPDATEUI);
		}
	}	
}

event OnEvent(int Event_ID, string param)
{
	local string FileName;
	
	if (Event_ID == EV_DialogOK)
	{
		if (DialogIsMine())
		{
			if( DialogGetID() == 98 )
			{
				FileName = DialogGetString();
				if(Len(FileName) < 1)
					return;
				MakeUC(FileName);
			}
			else if(DialogGetID() == 99)
			{
				FileName = DialogGetString();
				if( Len(FileName) < 1 )
					return;
					
				SaveXMLFile( FileName );
			}		
		}
	}
}

event OnDBClickListCtrlRecord(string strID)
{
	local string DirName;
	local LVDataRecord Record;

	// End:0x8F
	if(strID == "lstDirs")
	{
		lstDirs.GetSelectedRec(Record);
		DirName = Record.LVDataList[0].szData;
		// End:0x6C
		if(DirName == "..")
		{
			m_LastCurPath = GetLastFineName();
			m_CurPath = GetParentDirectory(m_CurPath);			
		}
		else
		{
			m_LastCurPath = "";
			m_CurPath = m_CurPath $ DirName;
		}
		Update();		
	}
	else
	{
		// End:0xA9
		if(strID == "lstFiles")
		{
			OnLoadClick();
		}
	}	
}

event OnClickCheckBox(string strID)
{
	if(strID == "AutoReloadCheckBox")
	{
		if(AutoReloadCheckBox.IsChecked())
		{
			Me.KillTimer(TIMER_ID_UPDATEUI);
			Me.SetTimer(TIMER_ID_UPDATEUI, DELAY_UPDATEUI);
		}
		else
		{
			Me.KillTimer(TIMER_ID_UPDATEUI);
		}
	}
}

event OnCompleteEditBox(string strID)
{
	switch(strID)
	{
		case "txtPath":
			m_CurPath = txtPath.GetString();
			Update();
			break;
	}
}

event OnKeyDown(WindowHandle a_WindowHandle, EInputKey nKey)
{
	// End:0x17
	if(Me.IsShowWindow() == false)
	{
		return;
	}
	// End:0x3B
	if((nKey < EInputKey.IK_A) || nKey > EInputKey.IK_Z)
	{
		return;
	}
	switch(a_WindowHandle)
	{
		// End:0x62
		case lstDirs:
			FindAndSelectList(lstDirs, nKey, dirNameArray);
			// End:0x85
			break;
		// End:0x82
		case lstFiles:
			FindAndSelectList(lstFiles, nKey, fileNameArray);
			// End:0x85
			break;
	}	
}

function UpdateDirectory()
{
	local array<string> DirList;
	local int idx;
	local LVDataRecord Record;
	local string dirStr;

	Record.LVDataList.Length = 1;
	lstDirs.DeleteAllItem();
	lstFiles.DeleteAllItem();
	dirNameArray.Length = 0;
	fileNameArray.Length = 0;
	GetDirList(DirList, m_CurPath);
	Record.LVDataList[0].szData = "..";
	lstDirs.InsertRecord(Record);
	dirNameArray[dirNameArray.Length] = "..";

	for(idx=0; idx < DirList.Length; idx++)
	{
		dirStr = DirList[idx];
		Record.LVDataList[0].szData = dirStr;
		lstDirs.InsertRecord(Record);
		dirNameArray[dirNameArray.Length] = dirStr;
		txtPath.AddNameToAdditionalSearchList(m_CurPath $ DirList[idx], ESearchListType.SLT_ADDITIONAL_LIST);
		// End:0x13B
		if(DirList[idx] == m_LastCurPath)
		{
			lstDirs.SetSelectedIndex(idx + 1, true);
		}
	}
	lstDirs.SetFocus();	
}

function UpdateFileList()
{
	local array<string> FileList;
	local int idx;
	local LVDataRecord Record;
	local string filestr;

	Record.LVDataList.Length = 1;
	lstFiles.DeleteAllItem();
	fileNameArray.Length = 0;
	GetFileList(FileList, m_CurPath, XML_EXT);
	
	for(idx = 0; idx < FileList.Length; idx++)
	{
		filestr = FileList[idx];
		Record.LVDataList[0].szData = filestr;
		lstFiles.InsertRecord(Record);
		fileNameArray[fileNameArray.Length] = filestr;
		txtPath.AddNameToAdditionalSearchList(m_CurPath $ FileList[idx], ESearchListType.SLT_ADDITIONAL_LIST);
	}
	lstFiles.SetFocus();	
}

function Update()
{
	if( Right( m_CurPath, 1 ) != "\\" )
		m_CurPath = m_CurPath $ "\\";
	
	SetOptionString( "UIEditor", "SysPath", m_CurPath );
	txtPath.SetString( m_CurPath );
	txtPath.ClearAdditionalSearchList(ESearchListType.SLT_ADDITIONAL_LIST);

	Debug("m_CurPath : " @ m_CurPath);

	UpdateDirectory();
	UpdateFileList();
}

function string GetLastFineName()
{
	local string Path;
	local array<string> DirList;

	Path = m_CurPath;
	// End:0x32
	if(Right(Path, 1) == "\\")
	{
		Path = Left(Path, Len(Path) - 1);
	}
	Split(Path, "\\", DirList);
	return DirList[DirList.Length - 1];	
}

function string GetParentDirectory( String Path )
{
	local array<String> DirList;
	local int Count;
	local int idx;
	local string NewPath;
	
	if( Len(Path) < 1 )
		return NewPath;
		
	if( Right( Path, 1 ) == "\\" )
		Path = Left( Path, Len(Path) - 1 );
	
	Count = Split( Path, "\\", DirList );
	
	if( Count == 1 )
		return Path;
	
	for( idx=0; idx<Count-1; idx++ )
		NewPath = NewPath $ DirList[idx] $ "\\";
	
	return NewPath;
}

event OnClickButton( string Name )
{
	switch( Name )
	{
		case "btnLoad":
			OnLoadClick();
			break;

		case "btnSave":
			OnSaveClick();
			break;

		case "btnMakeUC":
			OnMakeClick();
			break;

		case "exitButton":
			Update();
			class'UIDATA_API'.static.ChangeToPrevState();
			break;
		case "reLoadButton" :
			 reloadTargetXMLUI();
			 break;
	}
}

function OnLoadClick()
{
	local WindowHandle NewControl;
	local string Filename;
	local string FullName;
	local LVDataRecord Record;
	
	if(WorkSheet == None)
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Can't Find Worksheet.", string(Self));
		return;
	}
	lstFiles.GetSelectedRec(Record);
	Filename = Record.LVDataList[0].szData;
	if( Len(Filename) < 1 )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Please Select XML File.", string(Self));
		return;
	}
	FullName = m_CurPath $ Filename;

	NewControl = WorkSheet.LoadXMLWindow( FullName );
	if( NewControl == None )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Load XML Window Failed!", string(Self));
		return;
	}
	
	lastLoadedFile = FullName;

	NewControl.SetScript( "UIEditor_Worksheet" );
	NewControl.ConvertToEditable();
	NewControl.SetFocus();
}

/**
 *   해당 XML UI 재로딩 , ART 강성욱, 요청 사항
 **/
function reloadTargetXMLUI()
{
	local WindowHandle NewControl;
	local Array<WindowHandle> WindowList;
	local int i;

	if( WorkSheet == None )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Can't Find Worksheet.", string(Self));
		return;
	}

	// 작업 스테이지 삭제
	//ClearTracker();
	//DeleteAttachedWindow();		

	WorkSheet.SetFocus();
	 // 해당 윈도우 자식 목록을 얻고..
	 WorkSheet.GetChildWindowList(WindowList);

	 // 목록을 검색해서 지우면 되는듯.. 
	 for(i = 0; i < WindowList.Length; i++)
	 {
		// 포커싱 후 삭제 
		WindowList[i].SetFocus();
		DeleteAttachedWindow();	
		ClearTracker();
	 }

	NewControl = WorkSheet.LoadXMLWindow( lastLoadedFile );
	if( NewControl == None )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Load XML Window Failed!", string(Self));
		return;
	}
	
	NewControl.SetScript( "UIEditor_Worksheet" );
	NewControl.ConvertToEditable();
	NewControl.SetFocus();
}

function OnSaveClick()
{
	local string FileName;
	local LVDataRecord Record;

	lstFiles.GetSelectedRec(Record);
	FileName = Record.LVDataList[0].szData;
	
	DialogSetEditBoxMaxLength(100);
	DialogSetID(99);
	DialogShow(DialogModalType_Modalless,DialogType_OKCancelInput, "Input File Name.", string(Self));
	DialogSetString( FileName );
}

function OnMakeClick()
{
	local WindowHandle TrackerWnd;
	local WindowHandle TopWnd;
	
	local string ScriptName;
	local string FileName;
	
	//Find SciptName
	TrackerWnd = GetTrackerAttachedWindow();
	if( TrackerWnd==None )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Select Target Window to save.", string(Self));
		return;
	}
	TopWnd = TrackerWnd.GetTopFrameWnd();
	if( TopWnd == None )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Target Window Have No XML Infomation.", string(Self));
		return;
	}
	ScriptName = TopWnd.GetScriptName();
	if( Len(ScriptName) < 1 )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Target Window Have No Script Name.", string(Self));
		return;
	}
	
	FileName = ScriptName $ UC_EXT;
	DialogSetEditBoxMaxLength(100);
	DialogSetID(98);
	DialogShow(DialogModalType_Modalless,DialogType_OKCancelInput, "Input Script File Name.", string(Self));
	DialogSetString( FileName );
}

function SaveXMLFile( string FileName )
{
	local WindowHandle TrackerWnd;
	local WindowHandle TopWnd;
	
	local string FullName;
	
	if( Len(FileName) < 1 )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Please Input Save File Name!", string(Self));
		return;
	}
	
	TrackerWnd = GetTrackerAttachedWindow();
	if( TrackerWnd==None )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Select Target Window to save.", string(Self));
		return;
	}
	
	TopWnd = TrackerWnd.GetTopFrameWnd();
	if( TopWnd == None )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Target Window Have No XML Infomation.", string(Self));
		return;
	}
	
	FullName = m_CurPath $ FileName;
	
	if( TopWnd.SaveXMLWindow( FullName ) )
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Save Complete. (" $ FullName $ ")", string(Self) );
	else
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Save Failed. OTL", string(Self) );
		
	Update();
}

function MakeUC( string FileName )
{
	local WindowHandle TrackerWnd;
	local WindowHandle TopWnd;
	
	local array<String> NameList;
	local int Idx;
	local int Count;
	
	local string UCName;
	local string FullName;
	
	if( Len(FileName) < 1 )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Please Input Save File Name!", string(Self));
		return;
	}
	
	Count = Split( FileName, ".", NameList );
	if( ( "." $ NameList[Count-1] ) != UC_EXT )
		FileName = FileName $ UC_EXT;
	
	Count = Split( FileName, ".", NameList );
	for( idx=0; idx<Count-1; idx++ )
	{
		if( Idx > 0 )
			UCName = UCName $ ".";
		UCName = UCName $ NameList[Idx];
	}
	
	TrackerWnd = GetTrackerAttachedWindow();
	if( TrackerWnd==None )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Select Target Window to save.", string(Self));
		return;
	}
	TopWnd = TrackerWnd.GetTopFrameWnd();
	if( TopWnd == None )
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Target Window Have No XML Infomation.", string(Self));
		return;
	}
	
	FullName = m_CurPath $ FileName;
	
	if( TopWnd.MakeBaseUC( UCName, FullName ) )
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Save Complete. (" $ FullName $ ")", string(Self) );
	else
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Save Failed. OTL", string(Self) );
}

function FindAndSelectList(ListCtrlHandle targetListCtrl, EInputKey nKey, array<string> listStrArray)
{
	local string keyStr;
	local int i, SelectedIndex;
	local bool isSelected;

	keyStr = class'InputAPI'.static.GetKeyString(nKey);
	SelectedIndex = targetListCtrl.GetSelectedIndex();
	// End:0xAC
	if(SelectedIndex >= 0)
	{
		// End:0xAC
		if(keyStr == ToUpper(Left(listStrArray[SelectedIndex], 1)))
		{
			// End:0xAC
			if(listStrArray.Length > (SelectedIndex + 1))
			{
				// End:0xAC
				if(keyStr == ToUpper(Left(listStrArray[SelectedIndex + 1], 1)))
				{
					targetListCtrl.SetSelectedIndex(SelectedIndex + 1, true);
					isSelected = true;
				}
			}
		}
	}
	// End:0x10F
	if(isSelected == false)
	{
		// End:0x10F [Loop If]
		for(i = 0; i < listStrArray.Length; i++)
		{
			// End:0x105
			if(keyStr == ToUpper(Left(listStrArray[i], 1)))
			{
				targetListCtrl.SetSelectedIndex(i, true);
				// [Explicit Break]
				break;
			}
		}
	}	
}

defaultproperties
{
}
