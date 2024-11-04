class FileRegisterWnd extends UICommonAPI;
var bool m_bShow;
var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;
var ComboBoxHandle FilePathComboBoxCtrl;
var ComboBoxHandle FileExtComboBoxCtrl;
var string m_filePath;
var string FileTextureName, FolderTextureName, UpFolderTextureName;
var string CurrentForerTextureName, DesktopTextureName, MyDocumentsTextureName, DriveTextureName;
var _FileHandler FileHandler;
var bool IsIdle;
var string m_fileName;

//////////////////////////////////////////////////////////////////////// jdh84 /////////////////
//                             fileRegisterWnd�� ����.
//
// 1. filewnd�� XXX���� ��Ͽ� ����ϰ�ʹ�.
// 2. UICommonAPI�� _FileHandler �� ���ο� ENUM(TYPE) ���� �߰��Ѵ�.
// 3. ������ ��Ͻ�Ű�� API�� �ۼ��Ѵ�.
// 4. UploadFile�Լ��� �� ���� �ڵ鷯�� �´� API�� ����Ѵ�.
// 5-1. AddFileWndFileExt �Լ��� ClearFileWndFileExt �Լ��� ����� Ȯ���� �ڽ��� �����Ѵ�
// 5-2. FileRegisterWndShow(2������ ������ Ÿ��)�Լ��� ȣ���Ͽ� Ȱ��ȭ�Ѵ�  
////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
function ShowFileRegisterWnd(_FileHandler filehandlertype) //UICommanAPI �� ����ϱ� ���� Filewnd �� ĸ��ȭ
{
	if(m_bShow) 
	{
		return; //�̹� �ٸ� ���� ����â�� ���ִ�. �ǵ���� �־� �ݽô�
	}
	
	FileHandler = filehandlertype;
	
	// 2229 �ý��۽�Ʈ�� : ���ϵ�� 
	// ���� ��Ͻ� ������ Ÿ��Ʋ �̸��� ������ �ʿ䰡 �ִٸ�.. 
	switch(FileHandler)
	{
		case FH_PLEDGE_CREST_UPLOAD:
			setWindowTitleByString(GetSystemString(2229));
			break;
		case FH_PLEDGE_EMBLEM_UPLOAD:
			setWindowTitleByString(GetSystemString(2229));
			break;
		case FH_ALLIANCE_CREST_UPLOAD:
		case FH_WEBBROWSER_FILE_UPLOAD:
		default:
			setWindowTitleByString(GetSystemString(2229));
			break;
	}
	Me.ShowWindow();
	Me.SetFocus();
}

//���������츦 �����ش�. �ڵ鷯�� �����ϰ�, 
//FileWnd.uc�� Upload�Լ��� �����ؼ� ���ϵ�Ͻ� ����� �Լ��� ������ ����.
/*
	FH_NONE,                    0
	FH_PLEDGE_CREST_UPLOAD,     1
	FH_PLEDGE_EMBLEM_UPLOAD,    2
	FH_ALLIANCE_CREST_UPLOAD,   3
	FH_WEBBROWSER_FILE_UPLOAD,  4 
	FH_MAX      
*/
function FileRegisterWndShowByTypeStr(string numStr) 
{
	local Array<string> fileextarr;

	Debug("FileRegisterWndShowByTypeStr : " @ numStr);

	switch(numStr)
	{
		case "FH_PLEDGE_CREST_UPLOAD":
			fileextarr.Length = 1;
			fileextarr[0] = "bmp";			
			ClearFileRegisterWndFileExt();
			ClearFileExt();
			AddFileRegisterWndFileExt(GetSystemString(2811), fileextarr);
			ShowFileRegisterWnd(_FileHandler.FH_PLEDGE_CREST_UPLOAD); 
			break;

		case "FH_PLEDGE_EMBLEM_UPLOAD"  : 
			fileextarr.Length = 2;
			fileextarr[0] = "tga";
			fileextarr[1] = "bmp";
			ClearFileRegisterWndFileExt();
			AddFileRegisterWndFileExt(GetSystemString(2233), fileextarr);
			ShowFileRegisterWnd(_FileHandler.FH_PLEDGE_EMBLEM_UPLOAD); 
			break;

		case "FH_ALLIANCE_CREST_UPLOAD" : 
			fileextarr.Length = 1;
			fileextarr[0] = "bmp";			
			ClearFileRegisterWndFileExt();
			ClearFileExt();
			AddFileRegisterWndFileExt(GetSystemString(2811), fileextarr);
			ShowFileRegisterWnd(_FileHandler.FH_ALLIANCE_CREST_UPLOAD); 
			break;

		case "FH_WEBBROWSER_FILE_UPLOAD": ShowFileRegisterWnd(_FileHandler.FH_WEBBROWSER_FILE_UPLOAD); break;

		default : Debug("Error: FileRegisterWndShowByNum �Լ��� �߸��� ��ȣ�� ����:" @ numStr);
	}
}


function HideFileRegisterWnd() //UICommanAPI �� ����ϱ� ���� Filewnd �� ĸ��ȭ
{
	Me.HideWindow();
}

function AddFileExt(string str, array<string> strArray) //UICommanAPI �� ����ϱ� ���� Filewnd �� ĸ��ȭ
{
	FileExtComboBoxCtrl.AddStringWithFileExt(str,strArray);	
}

function ClearFileExt() //UICommanAPI �� ����ϱ� ���� Filewnd �� ĸ��ȭ
{
	FileExtComboBoxCtrl.Clear();
}
/////////////////////////////////////////////////////////////////////////////////////////////////////


function bool RequestWebBrowserRegisterByFilePath(string path)
{	
	local WebBrowserWnd script;
	script = WebBrowserWnd(GetScript("WebBrowserWnd"));
	
	debug("RequestWebBrowserRegisterByFilePath");
	
	script.UploadFileFullPath(path);

	return true;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
function bool UploadFile(string filePath, string fileName) 
{
	local string filestr;
	filestr = filePath $ "\\" $ fileName;
	if(FileHandler >= FH_MAX) return true;
	SetOptionString("Game", "FileRegisterPath" $ string(FileHandler), filePath);
	UploadFileFullPath(filestr);
}

function bool UploadFileFullPath(string path)
{
//	debug(path);
	
	if(FileHandler >= FH_MAX) return true;
	
	switch(FileHandler)
	{
		case FH_NONE:
			return true;
		case FH_PLEDGE_CREST_UPLOAD:		
			 Me.HideWindow();
			 return RequestClanRegisterCrestByFilePath(path); //���͹��� ���
		case FH_PLEDGE_EMBLEM_UPLOAD:		
			 Me.HideWindow();
			 return RequestClanRegisterEmblemByFilePath(path); //�������� ���
		case FH_ALLIANCE_CREST_UPLOAD:
			 Me.HideWindow();
			 return RequestAllianceRegisterCrestByFilePath(path); //���� ���� ���
		case FH_WEBBROWSER_FILE_UPLOAD:
			 Me.HideWindow();
			 return RequestWebBrowserRegisterByFilePath(path); // �������� ���� ���
		default:
			return true;
	}
}

function OnLoad()
{
	// hard coding
	local array<string> strArray;

	SetClosingOnESC();
	
	IsIdle = true; //ó������ idle ����(�ΰ��̻��� ���������츦 �������� �ʵ���)
	FileHandler = FH_NONE; //�ʱ���´� ���� �ڵ鷯�� ����
	FileTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_BMP"; //������ �ؽ���
	FolderTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_Folder"; //������ �ؽ���
	UpFolderTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_FolderUp";

	CurrentForerTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_FolderOpen";
	DesktopTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_Desktop";
	MyDocumentsTextureName= "L2UI_CT1.FileRegisterWnd_DF_Icon_MyDocument";
	DriveTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_Drive";

	if(CREATE_ON_DEMAND==0)
	{
	}
	else
	{
		Me = GetWindowHandle( "FileRegisterWnd" );
		FileListCtrl = GetListCtrlHandle("FileRegisterWnd.fileListCtrl");
		FileListCtrl.SetHeaderAlignment(0,TA_LEFT);
		FileListCtrl.SetResizable(false);
		EditBoxCtrl = GetEditBoxHandle("FileRegisterWnd.fileNameEditBox");
		FilePathComboBoxCtrl = GetComboBoxHandle("FileRegisterWnd.FileLocationComboBox");
		FileExtComboBoxCtrl = GetComboBoxHandle("FileRegisterWnd.FileTypeComboBox");
		
		FileListCtrl.SetHeaderTextOffset(0,135);
		strArray.Length = 1;
		strArray[0] = "*";
		FileExtComboBoxCtrl.AddStringWithFileExt("��� ����", strArray);
		SetFilePathnAdjustControl(GetMydocumentPath());
	}
	m_bShow = false;
}

function SetFilePathnAdjustControl( string s )
{
	local array<FileNameInfo> fInfoArray;
	local array<string> fExtArray;

	EditBoxCtrl.Clear();
	UpdateFilePathComboBox(s);
	
	fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
	fInfoArray = GetFilesInfoList(m_filePath,fExtArray);
	EnumerateFile(fInfoArray);
}

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

function OnCompleteEditBox( String strID )
{
	local LVDataRecord record;
	local int idx;
	local string strEdit, filePath;

	if ( strID != "fileNameEditBox" )
		return;

	strEdit = EditBoxCtrl.GetString();
	idx = SearchFileListWithName(strEdit);
	
	if ( idx < 0 )  //����Ʈ�ڽ��� ���ϸ��� �� ���丮�� ���ٸ� Full path�� ��������
	{
		UploadFileFullPath(strEdit);
		EditBoxCtrl.Clear();
		return;
	}

	FileListCtrl.GetRec(idx, record);

	m_fileName = record.LVDataList[0].szData;

	if ( record.nReserved1 == 1 ) //check
	{
		if ( UploadFile(m_filePath, m_fileName))
			Me.HideWindow();
		else
			;
	}
	else
		SetFilePathnAdjustControl(filePath);
	
}

function OnDBClickListCtrlRecord( String strID )
{
	local int index;
	local int Idx;
	local LVDataRecord record;
	local string str;
	local string editStr;
	if ( strID != "fileListCtrl" )
		return;
	
	Idx = FileListCtrl.GetSelectedIndex();
	if( Idx < 0 )
		return;
		
	FileListCtrl.GetRec( Idx, record );
	
	if(record.nReserved2 == 1) //��������
	{
		index = InStrFromBack(m_filePath,"\\");
		if ( index >= 0 )
		{
			editStr = Left(m_filePath,index);
			SetFilePathnAdjustControl(editStr);
		}
		return;
	}
	str = record.LVDataList[0].szData;		
	
	if ( record.nReserved1 == 0 )		// case of directory
	{
		
		str = m_filePath $ "\\" $ str;
		
		SetFilePathnAdjustControl(str);
		
	}
	else
	{
		m_fileName = record.LVDataList[0].szData;
		if ( UploadFile(m_filePath, m_fileName))
			Me.HideWindow();
		else
			;
	}
}


function UpdateFilePathComboBox(String str)
{
	local int i, j, k, drivenum;
	
	local array<DriveInfo> arrDrvInfo;
	local int width;
	local int selectednum;
	local string desktop;
	selectednum = 0;
	if ( Len(str) <= 0 ) return;

	FilePathComboBoxCtrl.Clear();
	m_filePath = str;
	k = -1;

	desktop = GetDesktopPath();
	if(len(desktop) != 0)
	{
		FilePathComboBoxCtrl.AddStringWithIconWithStr(Mid(desktop,InstrFromBack(desktop,"\\")+1) , DesktopTextureName, desktop);			
		selectednum++;
	}
	desktop = GetMydocumentPath();
	if(len(desktop) != 0)
	{
		FilePathComboBoxCtrl.AddStringWithIconWithStr(Mid(desktop,InstrFromBack(desktop,"\\")+1) , MyDocumentsTextureName, desktop);			
		selectednum++;
	}

	arrDrvInfo = GetDrivesInfoList();
	
	for ( drivenum = 0; drivenum < arrDrvInfo.Length; ++drivenum )
	{
		if ( Left(arrDrvInfo[drivenum].driveChar,1) != Left(m_filePath,1) ) //current path�� ��ġ�ϴ� ����̺��� ������ �ƴϸ� ������ ǥ���Ѵ�
		{
			FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr(Left(arrDrvInfo[drivenum].driveChar,1) $ ":" ,DriveTextureName,1, Left(arrDrvInfo[drivenum].driveChar,1) $ ":");			
			selectednum++;
		}
		else //current path �� drive��� �󼼰�θ� ��� ǥ���Ѵ�.
		{
			i = 0; //last "\\" founded index
			j = 0;
			k = 0; //gap
			while(true)
			{
				
				j = i; //preserve "\\" index is founded in previous step
				if(j == 0) //���ڿ��� ó������ "/"�� �����Ƿ� �������ش�
				{
					i = inStr(Mid(str,j), "\\");
					width = j; //ù / �� ���� /�� ����
				}
				else
				{
					i = inStr(Mid(str,j+1), "\\");
					width = j + 1;
				}
					

				if(i == -1) // ��ο� "\"�� ��������
				{	
					
					if(j == 0)
						FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr( Mid(str,j) , DriveTextureName, k+1, str);		
					else
						FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr( Mid(str,j+1) , CurrentForerTextureName, k+1, str);		
					break;
				}
				else
				{
					i += width;
				
					if(j == 0)
						FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr( Mid(str,j,i-j) , DriveTextureName, k+1, Left(str,i));							
					else
						FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr( Mid(str,j+1,i-j-1) , FolderTextureName, k+1, Left(str,i));							
					k++;
				}
			}

		FilePathComboBoxCtrl.SetSelectedNum(k+selectednum); // necessary for modifying
		}
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
	EditBoxCtrl.SetString(record.LVDataList[0].szData);
}

function EnumerateFile( array<FileNameInfo> FList )
{
	local int k;
	local LVDataRecord Record;
	FileListCtrl.DeleteAllItem();
	
	Record.LVDataList.Length = 1;
	Record.LVDataList[0].szData = "..";
	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nTextureWidth=19;
	Record.LVDataList[0].nTextureHeight=15;
	Record.LVDataList[0].nTextureU=19;
	Record.LVDataList[0].nTextureV=15;
	Record.LVDataList[0].IconPosX=3;

	Record.LVDataList[0].nsortPrior = 2;
	Record.LVDataList[0].szTexture = UpFolderTextureName;
	Record.nReserved2 = 1; //case of an upfolder
	k = InStrFromBack(m_filePath,"\\");
	
	if(k != -1)
		FileListCtrl.InsertRecord(Record); // not a root directory. insert Upforder.
	
	for (k = 0; k < FList.Length; k++)
	{
		
		Record.LVDataList[0].szData = FList[k].fileName;
		Record.LVDataList[0].hasIcon = true;
		Record.nReserved2 = 0; //case of not an upfolder

		if(FList[k].bIsFile)
		{
			Record.LVDataList[0].nsortPrior = 0;
			Record.LVDataList[0].szTexture = FileTextureName;
		}
		else
		{
			Record.LVDataList[0].nsortPrior = 1;
			Record.LVDataList[0].szData = Right(Record.LVDataList[0].szData, Len(Record.LVDataList[0].szData)-1);//�����տ� "/"�� ��� ��������
			Record.LVDataList[0].szTexture = FolderTextureName;
		}
				
		Record.nReserved1 = INT64( FList[k].bIsFile );
		FileListCtrl.InsertRecord(Record);
	}
	FileListCtrl.AdjustColumnWidth(0);
	FileListCtrl.SetSelectedIndex(0,true);
}


function OnShow()
{
	local array<string> fExtArray;

	EditBoxCtrl.Clear();
	FileListCtrl.InitListCtrl();
	FileExtComboBoxCtrl.SetSelectedNum(0);
	fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
	
	
	if(GetOptionString("Game", "FileRegisterPath" $ string(FileHandler)) == "")
		m_filePath = GetMydocumentPath();
	else
		m_filePath = GetOptionString("Game", "FileRegisterPath" $ string(FileHandler));

	if(m_filePath != "")
		SetFilePathnAdjustControl(m_filePath);
	else
	{
		m_filePath = "C:";
		SetFilePathnAdjustControl(m_filePath);
	}

	m_bShow = true;
}

function OnHide()
{
	m_bShow = false;
}

function OnComboBoxItemSelected( String strID, int index )
{
	local string str;
//	local int i, s, e;
	local array<FileNameInfo> fInfoArray;
	local array<string> fExtArray;
	if ( index < 0 ) return;

	if (strID == "fileLocationComboBox" )
	{
		str = FilePathComboBoxCtrl.GetAdditionalString(FilePathComboBoxCtrl.GetSelectedNum());
		SetFilePathnAdjustControl(str);
	}
	else if ( strID == "fileTypeComboBox" )
	{
		fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
		fInfoArray = GetFilesInfoList(m_filePath,fExtArray);
		EnumerateFile(fInfoArray);
	}
}

function OnClickButton( string strID )
{
	local string editStr, filePath;
	local int index;
	local LVDataRecord record;


	switch( strID )
	{
	case "registOKButton" :
		
		editStr = EditBoxCtrl.GetString();
		index = SearchFileListWithName(editStr);
		if ( index < 0 )
		{
			AddSystemMessage(528);
			EditBoxCtrl.Clear();
			break;
		}
		FileListCtrl.GetRec(index, record);

		if ( record.nReserved1 == 1 )
		{
			m_fileName = record.LVDataList[0].szData;
			if ( UploadFile(m_filePath, m_fileName) )
				Me.HideWindow();
			else
				;
		}
		else
		{
			filePath = m_filePath $ "\\" $record.LVDataList[0].szData;
			SetFilePathnAdjustControl(filePath);
		}
		break;
	case "registCancleButton":
		Me.HideWindow();
		break;
	case "refreshButton":
		SetFilePathnAdjustControl(m_filePath);
		break;
	
	}
}

///**
// * ������ ESC Ű�� �ݱ� ó�� 
// * "Esc" Key
// ***/
//function OnKeyDown( WindowHandle a_WindowHandle, EInputKey Key )
//{
//	if( Key == IK_Escape )
//	{
//		PlayConsoleSound(IFST_WINDOW_CLOSE);		
//		GetWindowHandle( "FileRegisterWnd" ).HideWindow();
//	}
//}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "FileRegisterWnd" ).HideWindow();
}

defaultproperties
{
}
