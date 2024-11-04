/**
 *  이벤트 강제 발생 UI 개발 유틸 (툴)
 *  
 **/
class UIPowerToolWnd extends UICommonAPI;

var WindowHandle  Me;

var ButtonHandle  event1Btn, event2Btn, event3Btn, event4Btn, event5Btn, renameNoteButton, initBtn, callEventAllButton;

var ButtonHandle  copyClipBoard1Btn, copyClipBoard2Btn, copyClipBoard3Btn, copyClipBoard4Btn, copyClipBoard5Btn;

var EditBoxHandle param1Edit, param2Edit, param3Edit, param4Edit, param5Edit;
var EditBoxHandle eventNum1Edit, eventNum2Edit, eventNum3Edit, eventNum4Edit, eventNum5Edit;

var EditBoxHandle titleEditBox;

var ListCtrlHandle noteListCtrl;

// 체크 버튼
var CheckBoxHandle autoOpenCheckBox;


var int currentPageNum;
var int nAutoOpen;
var bool nReloadOpen;


//-----------------------------------------------------------------------------------------------------------
//  Init
//-----------------------------------------------------------------------------------------------------------
function OnRegisterEvent()
{
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_StateChanged);
	RegisterEvent(EV_GameStart);
}

function OnShow()
{
	nReloadOpen = true;
	LoadIni();
}

function OnHide()
{
	saveCurrentPage();
}

function saveCurrentPage()
{
	setEditByINI(currentPageNum, 1);
	setEditByINI(currentPageNum, 2);
	setEditByINI(currentPageNum, 3);
	setEditByINI(currentPageNum, 4);
	setEditByINI(currentPageNum, 5);

	SaveINI("UIDEV.ini");
}

function OnLoad()
{
	SetClosingOnESC(); 
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle( "UIPowerToolWnd" );

	// 초기화
	initBtn    = GetButtonHandle( "UIPowerToolWnd.initBtn" );

	// 이벤트 보내기, 버튼
	event1Btn  = GetButtonHandle( "UIPowerToolWnd.event1Btn" );
	event2Btn  = GetButtonHandle( "UIPowerToolWnd.event2Btn" );
	event3Btn  = GetButtonHandle( "UIPowerToolWnd.event3Btn" );
	event4Btn  = GetButtonHandle( "UIPowerToolWnd.event4Btn" );
	event5Btn  = GetButtonHandle( "UIPowerToolWnd.event5Btn" );

	copyClipBoard1Btn   = GetButtonHandle( "UIPowerToolWnd.copyClipBoard1Btn" );
	copyClipBoard2Btn   = GetButtonHandle( "UIPowerToolWnd.copyClipBoard2Btn" );
	copyClipBoard3Btn   = GetButtonHandle( "UIPowerToolWnd.copyClipBoard3Btn" );
	copyClipBoard4Btn   = GetButtonHandle( "UIPowerToolWnd.copyClipBoard4Btn" );
	copyClipBoard5Btn   = GetButtonHandle( "UIPowerToolWnd.copyClipBoard5Btn" );

	InitBtn             = GetButtonHandle( "UIPowerToolWnd.initBtn" );
	renameNoteButton    = GetButtonHandle( "UIPowerToolWnd.renameNoteButton" );
	callEventAllButton  = GetButtonHandle( "UIPowerToolWnd.callEventAllButton" );

	// 이벤트 매개변수 스트링, 에디터 
	param1Edit = GetEditBoxHandle( "UIPowerToolWnd.param1Edit" );
	param2Edit = GetEditBoxHandle( "UIPowerToolWnd.param2Edit" );
	param3Edit = GetEditBoxHandle( "UIPowerToolWnd.param3Edit" );
	param4Edit = GetEditBoxHandle( "UIPowerToolWnd.param4Edit" );
	param5Edit = GetEditBoxHandle( "UIPowerToolWnd.param5Edit" );
	
	// 이벤트 번호, 에디터 
	eventNum1Edit = GetEditBoxHandle( "UIPowerToolWnd.eventNum1Edit" );
	eventNum2Edit = GetEditBoxHandle( "UIPowerToolWnd.eventNum2Edit" );
	eventNum3Edit = GetEditBoxHandle( "UIPowerToolWnd.eventNum3Edit" );	
	eventNum4Edit = GetEditBoxHandle( "UIPowerToolWnd.eventNum4Edit" );
	eventNum5Edit = GetEditBoxHandle( "UIPowerToolWnd.eventNum5Edit" );	

	titleEditBox  = GetEditBoxHandle( "UIPowerToolWnd.titleEditBox" );	
	noteListCtrl  = GetListCtrlHandle( "UIPowerToolWnd.noteListCtrl" );

	autoOpenCheckBox = GetCheckBoxHandle("UIPowerToolWnd.autoOpenCheckBox");

	setWindowTitleByString("UIPowerTools [ EventTool ]");

	nAutoOpen = -9999;
	currentPageNum = 1;
}

function OnEvent(int Event_ID, String param)
{
	// Debug("이벤트 Event_ID" @ Event_ID);
	// Debug("이벤트 param" @ param);

	if(GetReleaseMode() != RM_DEV) return;

	if (Event_ID == EV_Restart)
	{
		nReloadOpen = false;
		nAutoOpen = -9999;
	}
	else if (Event_ID == EV_GameStart)
	{
		// Debug("---EV_GameStart" @ param);
		if (nAutoOpen == -9999)
		{
			// Debug("---메메" @ EV_UpdateUserInfo);
			GetINIInt("___CommonInfo___", "UIPowerToolWndAutoOpen", nAutoOpen, "UIDEV.ini");

			// Debug("nAutoOpen ini 읽었을때" @nAutoOpen);
			// if (nAutoOpen != -1) autoOpenCheckBox.SetCheck(numToBool(nAutoOpen));
			if (nAutoOpen == 1) 
			{
				Me.ShowWindow();		
				autoOpenCheckBox.SetCheck(true);
			}
			else
			{
				autoOpenCheckBox.SetCheck(false);
			}

			//Debug("nAutoOpen :" @ nAutoOpen);
			// 처음 접속 후 자동 실행
			//Me.SetTimer(TIMER_ID, 500);
			//autoExecuteCommand("[start]");
		}
	}

	else if(Event_ID == EV_StateChanged)
	{	
		
		if(GetReleaseMode() != RM_DEV) return;

		//Debug("nReloadOpen:" @ nReloadOpen);
		if (param == "GAMINGSTATE")
		{
			GetINIInt("___CommonInfo___", "UIPowerToolWndAutoOpen", nAutoOpen, "UIDEV.ini");

			if (nAutoOpen == 1) 
			{
				Me.ShowWindow();		
				autoOpenCheckBox.SetCheck(true);
			}
			else
			{
				autoOpenCheckBox.SetCheck(false);
			}
		}		
	}
}

function OnClickCheckBox( string strID)
{
	switch( strID )
	{
		case "autoOpenCheckBox" :
			 OnAutoOpenCheckBoxBtnClick();
			 break;
	}
}

// 체크 박스	
function OnAutoOpenCheckBoxBtnClick()
{
	SetINIInt("___CommonInfo___", "UIPowerToolWndAutoOpen", boolToNum(autoOpenCheckBox.IsChecked()), "UIDEV.ini");
	SaveINI("UIDEV_BuildCommand.ini");
}

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "event1Btn":
 			 event1BtnClick();
			 break;

		case "event2Btn":
			 event2BtnClick();
			 break;

		case "event3Btn":
			 event3BtnClick();
			 break;

		case "event4Btn":
			 event4BtnClick();
			 break;

		case "event5Btn":
			 event5BtnClick();
			 break;

		//--
		case "copyClipBoard1Btn":
 			 clipBoardCopyBtnClick(1);
			 break;

		case "copyClipBoard2Btn":
			 clipBoardCopyBtnClick(2);
			 break;

		case "copyClipBoard3Btn":
			 clipBoardCopyBtnClick(3);
			 break;

		case "copyClipBoard4Btn":
			 clipBoardCopyBtnClick(4);
			 break;

		case "copyClipBoard5Btn":
			 clipBoardCopyBtnClick(5);
			 break;

		//--

		case "InitBtn" :
			 InitBtnClick();
			 break;

		case "renameNoteButton" :
			 renameBtnClick();
			 break;

		case "callEventAllButton" :
			 callEventAllButtonClick();
			 break;
	}
}

//-----------------------------------------------------------------------------------------------------------
//  Handle
//-----------------------------------------------------------------------------------------------------------

function clipBoardCopyBtnClick(int nBtnNum)
{
	local string rStr;

	switch(nBtnNum)
	{
		case 1:
			   rStr = makeCopyString(eventNum1Edit.GetString(), param1Edit.GetString());
			   if (rStr != "")
			   {
				   ClipboardCopy(rStr);
				   AddSystemMessageString("Complete! StringCopy for CommandTool");
			   }			   
			   break;
		case 2:
			   rStr = makeCopyString(eventNum2Edit.GetString(), param2Edit.GetString());
			   if (rStr != "")
			   {
				   ClipboardCopy(rStr);
				   AddSystemMessageString("Complete! StringCopy for CommandTool");
			   }
			   break;
		case 3:
			   rStr = makeCopyString(eventNum3Edit.GetString(), param3Edit.GetString());
			   if (rStr != "")
			   {
				   ClipboardCopy(rStr);
				   AddSystemMessageString("Complete! StringCopy for CommandTool");
			   }
			   break;
		case 4:
			   rStr = makeCopyString(eventNum4Edit.GetString(), param4Edit.GetString());
			   if (rStr != "")
			   {
				   ClipboardCopy(rStr);
				   AddSystemMessageString("Complete! StringCopy for CommandTool");
			   }
			   break;
		case 5:
			   rStr = makeCopyString(eventNum5Edit.GetString(), param5Edit.GetString());
			   if (rStr != "")
			   {
				   ClipboardCopy(rStr);
				   AddSystemMessageString("Complete! StringCopy for CommandTool");
			   }
			   break;
	}
}

function string makeCopyString(string eventIDStr, string param)
{
	local int i;
	local string commandStr;
	local array<string> commandArray;

	commandStr = "#event" $ eventIDStr;

	//idx = InStr(s, "#event");

	Split(param, " ", commandArray);

	for(i = 0; i < commandArray.Length; i++)
	{
		commandStr = commandStr $ "#" $ trim(commandArray[i]);
	}

	if (i == 0) commandStr = "";

	Debug("commandStr:" @commandStr);

	return commandStr;
}

function event1BtnClick()
{
	ExecuteEvent(int(eventNum1Edit.GetString()), param1Edit.GetString());
	setEditByINI(currentPageNum, 1);	
}

function event2BtnClick()
{
	ExecuteEvent(int(eventNum2Edit.GetString()), param2Edit.GetString());
	setEditByINI(currentPageNum, 2);
}

function event3BtnClick()
{
	ExecuteEvent(int(eventNum3Edit.GetString()), param3Edit.GetString());
	setEditByINI(currentPageNum, 3);
}

function event4BtnClick()
{
	ExecuteEvent(int(eventNum4Edit.GetString()), param4Edit.GetString());
	setEditByINI(currentPageNum, 4);
}

function event5BtnClick()
{
	ExecuteEvent(int(eventNum5Edit.GetString()), param5Edit.GetString());
	setEditByINI(currentPageNum, 5);
}

function callEventAllButtonClick()
{
	event1BtnClick();
	event2BtnClick();
	event3BtnClick();
	event4BtnClick();
	event5BtnClick();	
}

function InitBtnClick()
{
	param1Edit.SetString("");
	param2Edit.SetString("");
	param3Edit.SetString("");
	param4Edit.SetString("");
	param5Edit.SetString("");

	eventNum1Edit.SetString("");
	eventNum2Edit.SetString("");
	eventNum3Edit.SetString(""); 
	eventNum4Edit.SetString("");
	eventNum5Edit.SetString(""); 
}

function renameBtnClick()
{
	local LVDataRecord record;

	if (trim(titleEditBox.GetString()) == "") return;

	//Debug("currentPageNum" @ currentPageNum @ ": " @ titleEditBox.GetString());

	SetINIString("EventPowerToolWnd" $ currentPageNum, "eventNoteName", titleEditBox.GetString(), "UIDEV.ini");
	//saveCurrentPage();

	noteListCtrl.GetSelectedRec(record);
	record.LVDataList[0].szData = titleEditBox.GetString();
	noteListCtrl.ModifyRecord(noteListCtrl.GetSelectedIndex(), record);
}

//-----------------------------------------------------------------------------------------------------------
//  function
//-----------------------------------------------------------------------------------------------------------
/** init load */
function loadEditByINI(int nPage, int index)
{
	local string stringValue;

	stringValue = "";	

	// Event Param 
	GetINIString("EventPowerToolWnd" $ nPage, "event" $ index, stringValue, "UIDEV.ini");
	GetEditBoxHandle( "UIPowerToolWnd.param" $ index $ "Edit" ).SetString(stringValue);

	// Event Number 
	GetINIString("EventPowerToolWnd" $ nPage, "eventNum" $ index, stringValue, "UIDEV.ini");
	GetEditBoxHandle( "UIPowerToolWnd.eventNum"  $ index $ "Edit" ).SetString(stringValue);
}

/** init load */
function setEditByINI(int nPage, int index)
{
	// Event Param 
	SetINIString("EventPowerToolWnd" $ nPage, "event" $ index, GetEditBoxHandle( "UIPowerToolWnd.param"     $ index $ "Edit" ).GetString(), "UIDEV.ini");
	// Event Number 
	SetINIString("EventPowerToolWnd" $ nPage, "eventNum" $ index, GetEditBoxHandle( "UIPowerToolWnd.eventNum"  $ index $ "Edit" ).GetString(), "UIDEV.ini");
}

function LoadIni()
{
	local int i, n;

	//local array<string>	noteArray;

	local string startNoteNum;

	local string currentNoteName;

	// 아이템 관계된 윈도우 이름 배열
	//Split(ItemRelationWindowString, ",", ItemRelationWindowArrayStr);

	//noteArray.Remove(0, noteArray.Length);

	GetINIString("EventPowerToolWnd", "startNoteNum", startNoteNum, "UIDEV.ini");

	// 시작 노트가 없다면.. "
	if (startNoteNum == "")
	{
		SetINIString("EventPowerToolWnd", "startNoteNum", "1", "UIDEV.ini");

		currentPageNum = 1;
		
		noteListCtrl.DeleteAllItem();
		for(i = 1; i < 17; i++)
		{
			currentNoteName = "page" $ i;

			addListNote(currentNoteName, i);

			//SetINIString("EventPowerToolWnd" $ i, "eventName", noteName, "UIDEV.ini");

			SetINIString("EventPowerToolWnd" $ i, "eventNoteName", currentNoteName, "UIDEV.ini");
			for (n = 1; n < 6; n++)
			{				
				makeListNote(i, currentNoteName, n);
			}
		}

		setEditByINI(currentPageNum, 1);
		setEditByINI(currentPageNum, 2);
		setEditByINI(currentPageNum, 3);
		setEditByINI(currentPageNum, 4);
		setEditByINI(currentPageNum, 5);

		// 무조건 첫번째로 세팅
		noteListCtrl.SetSelectedIndex(0, false);

		titleEditBox.SetString(currentNoteName);
	}
	else
	{
		// 노트 목록 읽기

		GetINIString("EventPowerToolWnd", "startNoteNum", startNoteNum, "UIDEV.ini");

		currentPageNum = int(startNoteNum);

		// 목록 트리 만들기
		noteListCtrl.DeleteAllItem();
		for(i = 1; i < 17; i++)
		{
			GetINIString("EventPowerToolWnd" $ i, "eventNoteName", currentNoteName, "UIDEV.ini");
			addListNote(currentNoteName, i);

			// 만약 로딩할 노트 페이지라면 로딩 
			if (String(i) == startNoteNum)
			{
				titleEditBox.SetString(currentNoteName);

				for (n = 1; n < 6; n++)
				{				
					//GetINIString("EventPowerToolWnd" $ i, "event"    $ n, eventStr       , "UIDEV.ini");
					// GetINIString("EventPowerToolWnd" $ i, "eventNum" $ n, eventNumStr    , "UIDEV.ini");

					loadEditByINI(int(startNoteNum), n);
				}

				noteListCtrl.SetSelectedIndex(currentPageNum - 1, false);
				//Debug("noteListCtrl 열기 선택: " @ i @", "@ currentPageNum);
			}
		}
	}
}

function makeListNote (int pageNum, string noteName, int paramNum)
{
	if (trim(noteName) != "")
	{
		SetINIString("EventPowerToolWnd" $ pageNum, "event"     $ paramNum, "", "UIDEV.ini");
		SetINIString("EventPowerToolWnd" $ pageNum, "eventNum"  $ paramNum, "", "UIDEV.ini");		
	}
}

function addListNote (string noteName, int nPageNum)
{
	local LVDataRecord record;
	
	if (trim(noteName) != "")
	{
		record.LVDataList.Length = 1;
		record.LVDataList[0].szData = noteName;
		record.LVDataList[0].nReserved1 = nPageNum;

		// 리스트에 추가 
		noteListCtrl.InsertRecord(record);	
	}
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord record;
	local int n;

	if (ListCtrlID == "noteListCtrl") 
	{
		if (noteListCtrl.GetSelectedIndex() > -1)
		{
			saveCurrentPage();

			noteListCtrl.GetSelectedRec(record);
			//Debug(" --> " @ record.LVDataList[0].szData);
			//Debug(" --> " @ record.LVDataList[0].nReserved1);

			//noteListCtrl.SetSelectedIndex(i, false);

			for (n = 1; n < 6; n++)
			{				
				//GetINIString("EventPowerToolWnd" $ i, "event"    $ n, eventStr       , "UIDEV.ini");
				// GetINIString("EventPowerToolWnd" $ i, "eventNum" $ n, eventNumStr    , "UIDEV.ini");

				loadEditByINI(record.LVDataList[0].nReserved1, n);
			}

			titleEditBox.SetString(record.LVDataList[0].szData);
			currentPageNum = record.LVDataList[0].nReserved1;

			SetINIString("EventPowerToolWnd", "startNoteNum", String(currentPageNum), "UIDEV.ini");
		}
	}
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "UIPowerToolWnd" ).HideWindow();
	
	nReloadOpen = false;
}

defaultproperties
{
}
