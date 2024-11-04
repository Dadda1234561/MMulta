/**
 * 
 *   UI °і№Я ЖнАЗ Еш,   єфµе ён·Йѕо ілЖ® (єфµеён·Йѕо ±вѕп, ЅЗЗа±в)
 *   
 *   By Dongland, 2017.03
 * 
 **/ 

class UICommandWnd extends UICommonAPI;

var WindowHandle Me;

const TIMER_ID = 601221;
const TIMER_ID_RUN = 601222;

// ё®ЅєЖ®
var ListCtrlHandle itemListCtrl;
var ListCtrlHandle noteListCtrl;

// їЎµрЕН №ЪЅє
var EditBoxHandle inputEditBox;
var EditBoxHandle descViewEditBox;
var EditBoxHandle newNoteEditBox;

var EditBoxHandle runTimeEditBox;
var EditBoxHandle itemToolEditBox;

// ЕШЅєЖ® ЗКµе
var TextBoxHandle noteNameTextBox;

// ГјЕ© №цЖ°
var CheckBoxHandle autoOpenCheckBox;

var CheckBoxHandle textBuildCommandCutCheckBox;
var CheckBoxHandle textSpCutCheckBox;
var CheckBoxHandle runExceptionCheckBox;

/// №цЖ°
var ButtonHandle runDownBtn;
var ButtonHandle runUpBtn;
var ButtonHandle removeListBtn;

var ButtonHandle editBtn;
var ButtonHandle deleteNoteBtn;
var ButtonHandle newNoteBtn;
var ButtonHandle selfTargetBtn;

var int nAutoOpen;
var bool nReloadOpen;
var bool isStepRun;
var string currentNoteName;

// АъАеµИ ілЖ®
var array<string> noteArray;

function OnRegisterEvent()
{
	RegisterEvent(EV_Paste);
	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_GameStart);

	RegisterEvent(EV_Restart);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
	RegisterEvent(EV_StateChanged);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle( "UICommandWnd" );
	//runDownBtn       = GetButtonHandle( "UICommandWnd.runDownBtn" );
	//runUpBtn         = GetButtonHandle( "UICommandWnd.runUpBtn" );
	//editBtn          = GetButtonHandle( "UICommandWnd.editBtn" );
	//removeListBtn    = GetButtonHandle( "UICommandWnd.removeListBtn" );
	//deleteNoteBtn    = GetButtonHandle( "UICommandWnd.deleteNoteBtn" );
	//newNoteBtn       = GetButtonHandle( "UICommandWnd.newNoteBtn" );
	//selfTargetBtn    = GetButtonHandle("UICommandWnd.selfTargetBtn");

	inputEditBox    = GetEditBoxHandle( "UICommandWnd.inputEditBox" );
	descViewEditBox = GetEditBoxHandle( "UICommandWnd.descViewEditBox" );

	newNoteEditBox  = GetEditBoxHandle( "UICommandWnd.newNoteEditBox" );

	runTimeEditBox  = GetEditBoxHandle( "UICommandWnd.runTimeEditBox" );

	itemToolEditBox  = GetEditBoxHandle( "UICommandWnd.itemToolEditBox" );
	

	noteNameTextBox = GetTextBoxHandle("UICommandWnd.noteNameTextBox");

	itemListCtrl = GetListCtrlHandle("UICommandWnd.itemListCtrl");
	noteListCtrl = GetListCtrlHandle("UICommandWnd.noteListCtrl");

	autoOpenCheckBox = GetCheckBoxHandle("UICommandWnd.autoOpenCheckBox");
	textBuildCommandCutCheckBox = GetCheckBoxHandle("UICommandWnd.textBuildCommandCutCheckBox");
	textSpCutCheckBox = GetCheckBoxHandle("UICommandWnd.textSpCutCheckBox");
	runExceptionCheckBox = GetCheckBoxHandle("UICommandWnd.runExceptionCheckBox");

	nAutoOpen = -9999;

	runTimeEditBox.SetString("1");
	playButtonTexture(true);

	setWindowTitleByString("UITools [BuildCommandNote] - ver:1.0 - By Dongland");
}

function playButtonTexture(bool bPlay)
{
	if(bPlay)
		GetButtonHandle("UICommandWnd.executeAllBtn").SetTexture("L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_Play", "L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_Play_Down", "L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_Play_Over");
	else 
		GetButtonHandle("UICommandWnd.executeAllBtn").SetTexture("L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_Stop", "L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_Stop_Down", "L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_Stop_Over");
}

function OnShow()
{
	if(GetReleaseMode() != RM_DEV) Me.HideWindow();

	nReloadOpen = true;

	LoadIni();
	Me.SetFocus();

	
	//executeLineCommand("#event1080#a=10 b=dong");
}

function LoadIni()
{
	local int i, nTextSpCutCheckBox, nTextBuildCommandCutCheckBox, nRunExceptionCheckBox;
	//local string cmdStr;
	local string noteListStr, strRunTimeEditBox;

	noteArray.Remove(0, noteArray.Length);
	
	GetINIString("___CommonInfo___", "runTimeEditBox", strRunTimeEditBox, "UIDEV_BuildCommand.ini");

	if (strRunTimeEditBox != "") runTimeEditBox.SetString(strRunTimeEditBox);

	// ЅєЖ®ёµ ї№їЬ Гіё®
	GetINIInt("___CommonInfo___", "textSpCutCheckBox", nTextSpCutCheckBox, "UIDEV_BuildCommand.ini");
	GetINIInt("___CommonInfo___", "textBuildCommandCutCheckBox", nTextBuildCommandCutCheckBox, "UIDEV_BuildCommand.ini");
	GetINIInt("___CommonInfo___", "runExceptionCheckBox", nRunExceptionCheckBox, "UIDEV_BuildCommand.ini");

	if (nTextSpCutCheckBox != -1) textSpCutCheckBox.SetCheck(numToBool(nTextSpCutCheckBox));
	if (nTextBuildCommandCutCheckBox != -1) textBuildCommandCutCheckBox.SetCheck(numToBool(nTextBuildCommandCutCheckBox));
	if (nRunExceptionCheckBox != -1) runExceptionCheckBox.SetCheck(numToBool(nRunExceptionCheckBox));

	GetINIString("___CommonInfo___", "startNote", currentNoteName, "UIDEV_BuildCommand.ini");
	GetINIString("___CommonInfo___", "noteList", noteListStr, "UIDEV_BuildCommand.ini");

	// ЅГАЫ ілЖ®°Ў ѕшґЩёй.. "baseNote" ¶уґВ ЖдАМБцё¦ »х·О ёёµзґЩ.
	if (currentNoteName == "" && noteListStr == "")
	{
		SetINIString("___CommonInfo___", "startNote", "baseNote", "UIDEV_BuildCommand.ini");

		currentNoteName = "baseNote";
		makeNewNote(currentNoteName);
	}
	else
	{
		// ілЖ® ёс·П АР±в
		//GetINIString("___CommonInfo___", "noteList", noteListStr, "UIDEV_BuildCommand.ini");

		Split( noteListStr, "|", noteArray );

		noteListCtrl.DeleteAllItem();
		for(i = 0; i < noteArray.Length; i++)
		{
			addListNote(noteArray[i]);

			if (noteArray[i] == currentNoteName)
			{
				noteListCtrl.SetSelectedIndex(i, false);
			}
		}

		if (currentNoteName == "" && noteArray.Length > 0)
		{
			currentNoteName = noteArray[0];
			SetINIString("___CommonInfo___", "startNote", currentNoteName, "UIDEV_BuildCommand.ini");
		}
	}
	//savedBuildCommandArray.Remove(0, itemListCtrl.GetRecordCount());
	openNoteCommand(currentNoteName);

	//itemListCtrl.DeleteAllItem();
	//noteNameTextBox.SetText(currentNoteName);

	//GetINIInt(currentNoteName, "max", max, "UIDEV_BuildCommand.ini");

	//for (i = 0; i < max; i++)
	//{		
	//	GetINIString(currentNoteName, string(i), cmdStr, "UIDEV_BuildCommand.ini");

	//	if (cmdStr != "")
	//	{
	//		//savedBuildCommandArray[i] = cmdStr;
	//		AddList(i, cmdStr);
	//	}
	//}

	//if (itemListCtrl.GetRecordCount() > 0)
	//	SetINIInt(currentNoteName, "max", itemListCtrl.GetRecordCount(), "UIDEV_BuildCommand.ini");
}

function openNoteCommand(string openNoteName)
{
	local int max, i;
	local string cmdStr;

	currentNoteName = openNoteName;

	itemListCtrl.DeleteAllItem();
	noteNameTextBox.SetText(currentNoteName);

	GetINIInt(currentNoteName, "max", max, "UIDEV_BuildCommand.ini");

	for (i = 0; i < max; i++)
	{		
		GetINIString(currentNoteName, string(i), cmdStr, "UIDEV_BuildCommand.ini");

		if (cmdStr != "")
		{
			//savedBuildCommandArray[i] = cmdStr;
			AddList(i, cmdStr);
		}
	}

	if (itemListCtrl.GetRecordCount() > 0)
		SetINIInt(currentNoteName, "max", itemListCtrl.GetRecordCount(), "UIDEV_BuildCommand.ini");

	SetINIString("___CommonInfo___", "startNote", currentNoteName, "UIDEV_BuildCommand.ini");
}

function OnCompleteEditBox( String strID )
{
	local String strInput;
	

	//Debug("strIDstrID"@strID);
	if (currentNoteName == "") 
	{
		getInstanceL2Util().showGfxScreenMessage( "АъБ¤µИ ілЖ®°Ў ѕшЅАґПґЩ. »х·О ёёµй°ЕіЄ ілЖ®ё¦ ї­ѕоБЦјјїд.");
		return;
	}

	// АФ·В
	if( strID == "inputEditBox" )
	{
		strInput = inputEditBox.GetString();
		if ( Len( strInput ) < 1 )
			return;

		if (textSpCutCheckBox.IsChecked()) strInput = deleteSpStr(strInput);

		executeLineCommand(strInput);
		inputEditBox.SetString("");		

		AddCommandList(currentNoteName, strInput);
		itemListCtrl.SetSelectedIndex(itemListCtrl.GetRecordCount() - 1, true);

		//itemListCtrl.SetScrollPosition(
	}

	// јцБ¤.
	else if( strID == "descViewEditBox" )
	{
		strInput = descViewEditBox.GetString();

		//if (textSpCutCheckBox.IsChecked()) strInput = deleteSpStr(strInput);

		if ( Len( strInput ) < 1 )
			return;

		OnEditBtnClick();
		//descViewEditBox.SetString("");
	}
}

function OnEvent(int Event_ID, String param)
{
	local int nOpen;

	//Debug("АМєҐЖ® Event_ID" @ Event_ID);
	// Debug("АМєҐЖ® param" @ param);

	if(GetReleaseMode() != RM_DEV) return;

	if (Event_ID == EV_DialogOK)
	{
		if (DialogIsMine())
		{
			removeNote();
			//ProcessInsertLine();
		}
	}
	else if (Event_ID == EV_DialogCancel)
	{	
	}
	else if (Event_ID == EV_Paste)
	{	
		pasteClipboardAtList();
	}
	else if (Event_ID == EV_Restart)
	{
		// Debug("restart");
		nReloadOpen = false;
		nAutoOpen = -9999;
		inputEditBox.ClearAdditionalSearchList(ESearchListType.SLT_ADDITIONAL_LIST);

		Me.KillTimer( TIMER_ID_RUN );
		playButtonTexture(true);
		isStepRun = false;
	}

	//else if (Event_ID == EV_AdenaInvenCount)
	//{
	else if (Event_ID == EV_GameStart)
	{
		//Debug("---EV_GameStart" @ nAutoOpen);
		if (nAutoOpen == -9999)
		{
			// Debug("---ёЮёЮ" @ EV_UpdateUserInfo);
			GetINIInt("___CommonInfo___", "autoOpen", nAutoOpen, "UIDEV_BuildCommand.ini");

			// Debug("nAutoOpen ini АРѕъА»¶§" @nAutoOpen);

			//if (nAutoOpen != -1) autoOpenCheckBox.SetCheck(numToBool(nAutoOpen));
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

			// ГіАЅ БўјУ ИД АЪµї ЅЗЗа
			Me.SetTimer(TIMER_ID, 5000);
			//autoExecuteCommand("[start]");
		}
	}

	else if(Event_ID == EV_StateChanged)
	{	
		
		if(GetReleaseMode() != RM_DEV) return;

		//Debug("nReloadOpen:" @ nReloadOpen);
		//Debug("param" @ param);

		//if (param == "GAMINGSTATE" && nReloadOpen)
		if (param == "GAMINGSTATE")
		{
			GetINIInt("___CommonInfo___", "autoOpen", nOpen, "UIDEV_BuildCommand.ini");

			if (nOpen == 1) 
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

function OnTimer(int TimerID)
{
	local string noteListStr;
	local array<string> tempNoteArray;
	local int i;

	if(TimerID == TIMER_ID)
	{
		GetINIString("___CommonInfo___", "noteList", noteListStr, "UIDEV_BuildCommand.ini");

		if (noteListStr != "")
		{
			Split( noteListStr, "|", tempNoteArray );

			for(i = 0; i < tempNoteArray.Length; i++)
			{
				if (tempNoteArray[i] == "[start]")
				{
					autoExecuteCommand("[start]");

					// Debug("АЪµї ЅЗЗа!!");
					break;
				}
			}
			
		}

		//Debug("ЕёАМёУ іЎ");
		Me.KillTimer( TIMER_ID );
	}
	else if (TimerID == TIMER_ID_RUN)
	{
		
		if (itemListCtrl.GetSelectedIndex() + 1 == itemListCtrl.GetRecordCount())
		{
			Me.KillTimer( TIMER_ID_RUN );
			isStepRun = false;
			playButtonTexture(true);

			Debug("TIMER_ID_RUN БЯБц");
		}

		OnRunDownBtnClick();
	}
}

function OnHide()
{
	Me.KillTimer( TIMER_ID_RUN );
	isStepRun = false;
	playButtonTexture(true);
}

function stepTimeExecuteCommand()
{
	Me.KillTimer( TIMER_ID_RUN );
	
	if (isStepRun)
	{
		isStepRun = false;
		playButtonTexture(true);
		return;
	}

	SetINIString("___CommonInfo___", "runTimeEditBox", runTimeEditBox.GetString(), "UIDEV_BuildCommand.ini");

	if (itemListCtrl.GetSelectedIndex() < 0) 
	{
		getInstanceL2Util().showGfxScreenMessage("Stop Command!");
		return;
	}

	if (float(runTimeEditBox.GetString()) > 0)
	{	
		isStepRun = true;
		Me.SetTimer(TIMER_ID_RUN, float(runTimeEditBox.GetString()));
		getInstanceL2Util().showGfxScreenMessage(runTimeEditBox.GetString() @ ", 1/1000ГКґз, ЗСБЩѕї ДїёЗµеё¦ ЅЗЗа!");
		playButtonTexture(false);
	}
	else
	{
		autoExecuteCommand(currentNoteName);
		getInstanceL2Util().showGfxScreenMessage(currentNoteName @ "ілЖ®АЗ АьГј ДїёЗµеё¦ ЅЗЗа!");
	}
}


function autoExecuteCommand(string executeNoteName)
{
	local int max, i;
	local string cmdStr;

	if (executeNoteName == "") return;
	
	GetINIInt(executeNoteName, "max", max, "UIDEV_BuildCommand.ini");

	for (i = 0; i < max; i++)
	{		
		GetINIString(executeNoteName, string(i), cmdStr, "UIDEV_BuildCommand.ini");

		if (cmdStr != "")
		{
			executeLineCommand(cmdStr);
		}
	}
}

//SetINIString("Tab1", strInput, strInput, "UIDEV_BuildCommand.ini");
function AddCommandList (string section, string bCommandStr)
{
	//local int i;
	//for(i = 0; i < savedBuildCommandArray.Length; i++)
	//{
	//	if (savedBuildCommandArray[i] == bCommandStr)
	//	{
	//		return;
	//	}
	//}

	if (bCommandStr != "")
	{
		//savedBuildCommandArray[savedBuildCommandArray.Length] = bCommandStr;

		SetINIString(section, String(itemListCtrl.GetRecordCount()),  bCommandStr, "UIDEV_BuildCommand.ini");
		AddList(itemListCtrl.GetRecordCount(), bCommandStr);

		
		SetINIInt(currentNoteName, "max", itemListCtrl.GetRecordCount(), "UIDEV_BuildCommand.ini");

		SaveINI("UIDEV_BuildCommand.ini");
	}

}

function addListNote (string noteName)
{
	local LVDataRecord record;
	
	if (trim(noteName) != "")
	{
		record.LVDataList.Length = 1;
		record.LVDataList[0].szData = noteName;

		// ё®ЅєЖ®їЎ ГЯ°Ў 
		noteListCtrl.InsertRecord(record);	
	}
}

function removeNote()
{
	local LVDataRecord record;
	
	if (noteListCtrl.GetSelectedIndex() > -1)
	{
		noteListCtrl.GetSelectedRec(record);
		removeNoteArray(record.LVDataList[0].szData);
		noteListCtrl.DeleteRecord(noteListCtrl.GetSelectedIndex());	

		// key °ЄА» єу№®АЪ·О іС±вёй јЅјЗАьГјё¦ Б¦°ЕЗФ.
		RemoveINI(record.LVDataList[0].szData, "", "UIDEV_BuildCommand.ini");

		// ЗцАз Бцїо ілЖ®°Ў, АЫѕчБЯАО ілЖ®їґґЩёй..
		if(currentNoteName == record.LVDataList[0].szData)
		{
			currentNoteName = "";
			noteNameTextBox.SetText(currentNoteName);
			itemListCtrl.DeleteAllItem();
			descViewEditBox.SetString("");
			inputEditBox.SetString("");
			
			if (noteListCtrl.GetRecordCount() > 0)
			{
				if (noteListCtrl.GetSelectedIndex() > -1)
				{
					noteListCtrl.GetSelectedRec(record);
				}
			}

			SetINIString("___CommonInfo___", "startNote", "", "UIDEV_BuildCommand.ini");
		}

		SaveINI("UIDEV_BuildCommand.ini");
	}
}

function string getNoteSelectedName()
{
	local LVDataRecord Record;

	noteListCtrl.GetSelectedRec(Record);
	return Record.LVDataList[0].szData;	
}

function reNameNewNote(string noteName)
{
	local int i;
	local string listStr;

	// End:0x14
	if(trim(noteName) == "")
	{
		return;
	}
	// End:0x5E
	if(hasNoteInArray(noteName))
	{
		getInstanceL2Util().showGfxScreenMessage(noteName @ "이미 같은 이름의 노트가 있습니다.");
		return;
	}
	SetINIString("___CommonInfo___", "startNote", noteName, "UIDEV_BuildCommand.ini");

	// End:0x129 [Loop If]
	for(i = 0; i < noteArray.Length; i++)
	{
		// End:0xDC
		if(noteArray[i] == getNoteSelectedName())
		{
			noteArray[i] = noteName;
		}
		// End:0x102
		if(i == 0)
		{
			listStr = listStr $ noteArray[i];
			// [Explicit Continue]
			continue;
		}
		listStr = listStr $ "|" $ noteArray[i];
	}
	SetINIString("___CommonInfo___", "noteList", listStr, "UIDEV_BuildCommand.ini");
	removeAndRenameNoteCommand(getNoteSelectedName(), noteName);
	LoadIni();	
}

function removeAndRenameNoteCommand(string openNoteName, string renameString)
{
	local int Max, i;
	local string cmdStr;

	GetINIInt(openNoteName, "max", Max, "UIDEV_BuildCommand.ini");
	SetINIInt(renameString, "max", Max, "UIDEV_BuildCommand.ini");

	// End:0xE4 [Loop If]
	for(i = 0; i < Max; i++)
	{
		GetINIString(openNoteName, string(i), cmdStr, "UIDEV_BuildCommand.ini");
		// End:0xDA
		if(cmdStr != "")
		{
			SetINIString(renameString, string(i), cmdStr, "UIDEV_BuildCommand.ini");
		}
	}
	removeNoteArray(openNoteName);
	RemoveINI(openNoteName, "", "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");	
}

function makeNewNote (string noteName)
{
	if (trim(noteName) != "")
	{
		getInstanceL2Util().showGfxScreenMessage(noteName @ "ілЖ®ё¦ »эјє ЗПїґЅАґПґЩ.");

		SetINIString("___CommonInfo___", "startNote", noteName, "UIDEV_BuildCommand.ini");
		SetINIInt(noteName, "max", 0, "UIDEV_BuildCommand.ini");

		noteNameTextBox.SetText(noteName);
		descViewEditBox.SetString("");

		newNoteEditBox.SetString("");

		addNoteArray(noteName);

		// ёс·П ґЩЅГ АР±в
		LoadIni();
	}
}

function removeNoteArray(string noteName)
{
	local int index, i;
	local string listStr;

	index = getNoteIndexInArray(noteName);

	if (index > -1)
	{
		getInstanceL2Util().showGfxScreenMessage(noteName @ "ілЖ®ё¦ »иБ¦ ЗПїґЅАґПґЩ.");
		noteArray.Remove(index, 1);
	}

	for(i = 0; i < noteArray.Length; i++)
	{
		if (i == 0) listStr = listStr $ noteArray[i];
		else listStr = listStr $ "|" $ noteArray[i];
	}

	// Debug("listStr : " @ listStr);

	SetINIString("___CommonInfo___", "noteList", listStr, "UIDEV_BuildCommand.ini");
}

function addNoteArray(string noteName)
{
	local int i;
	local string listStr;

	if (!hasNoteInArray(noteName))
	{
		noteArray[noteArray.Length] = noteName;
	}
	else return;

	for(i = 0; i < noteArray.Length; i++)
	{
		if (i == 0) listStr = listStr $ noteArray[i];
		else listStr = listStr $ "|" $noteArray[i];

		// Debug("+++listStr : " @ listStr);
	}

	//Debug("listStr : " @ listStr);

	SetINIString("___CommonInfo___", "noteList", listStr, "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");
}

function int getNoteIndexInArray(string noteName)
{
	local int i;

	for (i = 0; i < noteArray.Length; i++)
	{
		if (noteArray[i] == noteName) return i;
	}

	return -1;
}

function bool hasNoteInArray(string noteName)
{
	local int i;

	for (i = 0; i < noteArray.Length; i++)
	{
		if (noteArray[i] == noteName) return true;
	}

	return false;
}

function AddList (int index, string bCommandStr)
{
	local LVDataRecord record;
	
	record.LVDataList.Length = 2;

	record.LVDataList[0].szData = string(index);
	record.LVDataList[0].HiddenStringForSorting = getInstanceL2Util().makeZeroString(6, index);

	record.LVDataList[1].szData = bCommandStr;
	// record.LVDataList[0].szReserved = bCommandStr;

	// ё®ЅєЖ®їЎ ГЯ°Ў 
	itemListCtrl.InsertRecord(record);
	inputEditBox.AddNameToAdditionalSearchList(bCommandStr, ESearchListType.SLT_ADDITIONAL_LIST);
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord record;
	
	if (ListCtrlID == "itemListCtrl") 
	{
		if (itemListCtrl.GetSelectedIndex() > -1)
		{
			itemListCtrl.GetSelectedRec(record);
			descViewEditBox.SetString(record.LVDataList[1].szData);			
		}
	}
}

//function OnRButtonUp( WindowHandle a_WindowHandle, int X, int Y )
//{
//	Debug(a_WindowHandle.GetWindowName());
//	OnRClickListCtrlRecord(a_WindowHandle.GetWindowName());

//	Debug("x:"@X);
//	Debug("y"@Y);
//}


function OnDBClickListCtrlRecord( string ListCtrlID)
{
	local LVDataRecord record;

	if (ListCtrlID == "itemListCtrl") 
	{
		itemListCtrl.GetSelectedRec(record);

		if (record.LVDataList[1].szData != "")
		{
			//
			executeLineCommand(record.LVDataList[1].szData);
		}
	}
	else if (ListCtrlID == "noteListCtrl") 
	{
		noteListCtrl.GetSelectedRec(record);

		if (record.LVDataList[0].szData != "")
		{
			openNoteCommand(record.LVDataList[0].szData);
			getInstanceL2Util().showGfxScreenMessage(record.LVDataList[0].szData @ "ілЖ®ё¦ їАЗВ ЗЯЅАґПґЩ!");
		}
	}
}

function OnRButtonUp( WindowHandle a_WindowHandle, int X, int Y )
{
	//Debug(a_WindowHandle.GetWindowName());
	//OnRClickListCtrlRecord(a_WindowHandle.GetWindowName());
	inputEditBox.SetFocus();
}

function OnRClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord record;

	// Debug("ListCtrlID" @ ListCtrlID);

	if (ListCtrlID == "itemListCtrl") 
	{
		itemListCtrl.GetSelectedRec(record);
		
		if (record.LVDataList[1].szData != "")
		{
			//executeLineCommand(record.LVDataList[1].szData);
			//ClipboardCopy(record.LVDataList[1].szData);
			//getInstanceL2Util().showGfxScreenMessage("Е¬ёі єёµе Д«ЗЗ:" @ record.LVDataList[1].szData);

			OnClickListCtrlRecord("itemListCtrl");
			descViewEditBox.SetFocus();
		}
	}
	else if (ListCtrlID == "noteListCtrl") 
	{
		noteListCtrl.GetSelectedRec(record);

		if (record.LVDataList[0].szData != "")
		{
			openNoteCommand(record.LVDataList[0].szData);
			getInstanceL2Util().showGfxScreenMessage(record.LVDataList[0].szData @ "ілЖ®ё¦ їАЗВ ЗЯЅАґПґЩ!");
		}
	}
}
	
// »иБ¦ ЗП°н ini ѕчµҐАМЖ®
function removeListItem()
{
	local int i , currMax;
	local bool bLast;
	local LVDataRecord record;
	if (itemListCtrl.GetSelectedIndex() > -1)
	{
		if (itemListCtrl.GetRecordCount()  > 0)
		{
			if (itemListCtrl.GetSelectedIndex() == itemListCtrl.GetRecordCount() - 1)
			{
				bLast = true;
			}
		}

		// Бцїм±в АМАь АьГј °Є
		currMax = itemListCtrl.GetRecordCount();

		//RemoveINI(currentNoteName, String(itemListCtrl.GetSelectedIndex()), "UIDEV_BuildCommand.ini");

		itemListCtrl.GetSelectedRec(record);

		inputEditBox.DeleteNameFromAdditionalSearchList(record.LVDataList[1].szData, ESearchListType.SLT_ADDITIONAL_LIST);
		itemListCtrl.DeleteRecord(itemListCtrl.GetSelectedIndex());

		if (bLast && itemListCtrl.GetRecordCount()  > 0)
		{
			itemListCtrl.SetSelectedIndex(itemListCtrl.GetRecordCount() - 1, true);
		}
		
		OnClickListCtrlRecord("itemListCtrl");
		
		//refreshListLineNumber();

		for (i = itemListCtrl.GetSelectedIndex(); i < currMax; i++)
		{
			itemListCtrl.GetRec(i, record);

			if (i < itemListCtrl.GetRecordCount())
				SetINIString(currentNoteName, String(i), record.LVDataList[1].szData, "UIDEV_BuildCommand.ini");
			else
				RemoveINI(currentNoteName, String(i), "UIDEV_BuildCommand.ini");
		}

		SetINIInt(currentNoteName, "max", itemListCtrl.GetRecordCount(), "UIDEV_BuildCommand.ini");

		SaveINI("UIDEV_BuildCommand.ini");
	}
}


// БЩ№шИЈё¦ ґЩЅГ °»ЅЕ
//function refreshListLineNumber()
//{
//	local int i;
//	local LVDataRecord record;

//	for (i = 0; i < itemListCtrl.GetRecordCount(); i++)
//	{
//		itemListCtrl.GetRec(i, record);

//		record.LVDataList[0].szData = string(i);
//		record.LVDataList[0].HiddenStringForSorting = getInstanceL2Util().makeZeroString(6, i);

//		itemListCtrl.ModifyRecord(i, record);
//	}
//}

function OnClickCheckBox( string strID)
{
	switch( strID )
	{
		case "autoOpenCheckBox" :
			 OnAutoOpenCheckBoxBtnClick();
			 break;

		case "textBuildCommandCutCheckBox" :
			 OnTextBuildCommandCutCheckBoxClick();
			 break;

		case "textSpCutCheckBox" :
			 OnTextSpCutCheckBoxClick();
			 break;

		case "runExceptionCheckBox" :
			 OnRunExceptionCheckBoxClick();
			 break;
	}
}


function OnClickButton( string Name )
{
	switch( Name )
	{
		case "runUpBtn":
			 OnRunUpBtnClick();
			 break;

		case "runDownBtn":
			 OnRunDownBtnClick();
			 break;

		case "editBtn":
			 OnEditBtnClick();
			 break;

		case "removeListBtn":
			 removeListItem();
			 break;

		case "selfTargetBtn" :
			 OnSelfTargetBtn();
			 break;

		case "searchToolBtn" :
			 if (IsShowWindow("GMFindTreeWnd")) HideWindow("GMFindTreeWnd");
			 else 
			 {
				GMWnd(GetScript("GMWnd")).OnClickNPCListButton();
			 }
			 break;

		case "itemBtn" :

			 //itemToolEditBox.GetString()

			 toggleWindow("UIItemToolWnd", true);
			 //UIToolWnd(GetScript("UIToolWnd")).LoadWindowClick("UIItemToolWnd");
			 if (itemToolEditBox.GetString() != "")
			 {
				UIItemToolWnd(GetScript("UIItemToolWnd")).executeSearch(itemToolEditBox.GetString());
			 }

			 break;

		case "newNoteBtn":
			makeNewNote(newNoteEditBox.GetString());
			break;
		case "reNameNoteBtn":
			reNameNewNote(newNoteEditBox.GetString());
			// End:0x52A
			break;
	    case "deleteNoteBtn" :

			 DialogSetID( 10234 );
			 DialogShow(DialogModalType_Modalless, DialogType_Warning, "ілЖ®ё¦ Б¤ё» »иБ¦ ЗТ±оїд?", string(Self));
			 break;

	   case "powerBtn" :
			RequestSelfTarget();
			ExecuteCommand("//ЅєЕі»зїл 7029 3");
			ExecuteCommand("//ЅєЕі 4101 1");
			getInstanceL2Util().showGfxScreenMessage("ЅґЖЫЗмАМЅєЖ®: ИыВч°н °­ЗС №цЗБ!");
			break;

	   case "swordBtn" :
		    ExecuteCommand("//»эјє 1305");
			getInstanceL2Util().showGfxScreenMessage("°­ЗС №«±в ID: 1305 И№µж!");
		    break;

	   case "homeBtn" :
		    ExecuteCommand("//home");
			getInstanceL2Util().showGfxScreenMessage("//home А§ДЎ·О АМµї");
		    break;


	   case "hideOffBtn" :
		    ExecuteCommand("//Ехён Іы");
			break;

	   case "executeAllBtn" :
			stepTimeExecuteCommand();
			break;

	   case "lineUpMoveButton" :
			OnLineUpBtnClick();
			//Debug("up");
			break;

	   case "lineDownMoveButton" :
			 OnLineDownBtnClick();
			 //Debug("down");
		     break;

	   case "helpBtn" :
			 showHelp();
			 break;


	   case "test1Button" :
			 Debug("test1Button");
		     break;

	   case "uiOpenButton" :
			 toggleWindow("UIOpenToolWnd", true);
		     break;

		case "GMButton" :
			toggleWindow("GMWnd", true);
			break;

		case "powerToolButton":
			toggleWindow("UIPowerToolWnd", true);
			break;
		case "reloadUIButton":
			ExecuteCommand("///reloadui");
			// End:0x52A
			break;
		// End:0x46B
		case "rebuildUIButton":
			ExecuteCommand("///rebuildui");
			// End:0x52A
			break;
	   case "uiDebugButton" :
			 //ExecuteCommand("///uidebug");
			 toggleWindow("DebugWnd", true);
		     break;

	   case "restartButton" :
			 ExecRestart();
		     break;

       case "locSaveBtn" :
			 savePostion();
		     break;

	   case "resetUIButton":
			 getInstanceUIData().resetUIData();
		     break;
		case "noteUpMoveButton":
			OnNoteUpMoveButtonClick();
			// End:0x52A
			break;
		// End:0x527
		case "noteDownMoveButton":
			OnNoteDownMoveButtonClick();
			// End:0x52A
			break;
	}
}

function OnNoteUpMoveButtonClick()
{
	local LVDataRecord Record, tmRecord;
	local int selectIndex;

	// End:0xEC
	if(noteListCtrl.GetSelectedIndex() > -1)
	{
		noteListCtrl.GetSelectedRec(Record);
		selectIndex = noteListCtrl.GetSelectedIndex() - 1;
		// End:0xA9
		if(selectIndex > -1)
		{
			noteListCtrl.GetRec(selectIndex, tmRecord);
			noteListCtrl.ModifyRecord(noteListCtrl.GetSelectedIndex(), tmRecord);
			noteListCtrl.ModifyRecord(selectIndex, Record);
		}
		// End:0xEC
		if(selectIndex >= 0)
		{
			noteListCtrl.SetSelectedIndex(selectIndex, false);
			OnClickListCtrlRecord("noteListCtrl");
			noteListCtrl.SetFocus();
		}
	}
	relistSaveNote();	
}

function OnNoteDownMoveButtonClick()
{
	local LVDataRecord Record, tmRecord;
	local int selectIndex;

	// End:0x104
	if(noteListCtrl.GetSelectedIndex() > -1)
	{
		noteListCtrl.GetSelectedRec(Record);
		selectIndex = noteListCtrl.GetSelectedIndex() + 1;
		// End:0xB3
		if(selectIndex < noteListCtrl.GetRecordCount())
		{
			noteListCtrl.GetRec(selectIndex, tmRecord);
			noteListCtrl.ModifyRecord(noteListCtrl.GetSelectedIndex(), tmRecord);
			noteListCtrl.ModifyRecord(selectIndex, Record);
		}
		// End:0x104
		if(selectIndex < noteListCtrl.GetRecordCount())
		{
			noteListCtrl.SetSelectedIndex(selectIndex, false);
			OnClickListCtrlRecord("noteListCtrl");
			noteListCtrl.SetFocus();
		}
	}
	relistSaveNote();	
}

function relistSaveNote()
{
	local int i;
	local string listStr;
	local LVDataRecord tmRecord;

	noteArray.Remove(0, noteArray.Length);

	// End:0x7D [Loop If]
	for(i = 0; i < noteListCtrl.GetRecordCount(); i++)
	{
		noteListCtrl.GetRec(i, tmRecord);
		noteArray.Length = noteArray.Length + 1;
		noteArray[i] = tmRecord.LVDataList[0].szData;
	}

	// End:0xE1 [Loop If]
	for(i = 0; i < noteArray.Length; i++)
	{
		// End:0xBA
		if(i == 0)
		{
			listStr = listStr $ noteArray[i];
			// [Explicit Continue]
			continue;
		}
		listStr = listStr $ "|" $ noteArray[i];
	}
	SetINIString("___CommonInfo___", "noteList", listStr, "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");	
}

function savePostion()
{
	local vector PlayerPosition;

	PlayerPosition = GetPlayerPosition();

	inputEditBox.SetString("//ЕЪ " $ String(PlayerPosition.x) @ String(PlayerPosition.y) @ String(PlayerPosition.z));
	inputEditBox.SetFocus();
}

function string htmlSetHtmlStart(string targetHtml)
{
	return "<html><body>" $ targetHtml $ "</body></html>";
}

function showHelp()
{
	local string param, desc;

	desc = 
" - UI єфµе ён·Йѕо ілЖ® - <br1>" $
"єфµе ён·Йѕоё¦ №Эє№АыАё·О ДЎ±в ±НВъѕЖј­ ёёµз ЕшАФґПґЩ.<br1>" $
"<br>" $
"Е¬¶уАМѕрЖ® System ЖъґхUIDEV_BuildCommand.ini їЎ АъАе µЛґПґЩ.<br1>" $
"ілЖ®ЅДАё·О »зїлЗШµµ µЗ°н, єфµеён·Йѕо ЅЗЗа±в·О »зїлЗШµµ µЛґПґЩ.<br1>" $
"<br>" $
" =========== ЖЇјц ±вґЙ ёс·П ========<br1>" $
"* TTPµо ї©·Ї БЩ·О µИ єфµе ён·Йѕоё¦ є№»з ЗШј­ єЩАМґВ ±вґЙ <br1>" $
" ex) '//', '///' єфµе ДїёаЖ® ЗҐЅДАМАьїЎ ґЩѕзЗС ЅєЖ®ёµАМ єЩѕо АЦґВ ёЦЖј¶уАОА» ЗС№шїЎ Е¬ёієёµеїЎ є№»зЗШј­ єЩАМ±вё¦ ЗШєёјјїд.<br><br>" $
"  1.//Ехён Іы <br1>" $
"  2.//»эјє 57 100 <br1>" $
"  - //»эјє 1 <br1>" $
"  - ///ѕоВј°н <br1>" $
"  - ///sw name=ActionWnd <br1>" $
"  <br>" $
" --------------------------------------  <br1>" $
"* °ФАУ ЅЗЗаЅГ єфµеён·Йѕо АЪµї ЅЗЗа ±вґЙ - <br1>" $
"ілЖ® АМё§А» [start] ·О БцБ¤ЗП°н ілЖ®ё¦ ёёµйёй, <br1>" $
"°ФАУ ЅГАЫЅГ ЗШґз ён·Йѕо АьГј°Ў АЪµїАё·О ЅЗЗаµЛґПґЩ..<br1>" $
" --------------------------------------  <br1>" $
"  <br>" $
"* UI АМєҐЖ® °­Б¦ №Я»эЗП±в <br1>" $
"ex) UI АМєҐЖ® 18№шА» Param°ЄАё·О Flag=1 А» єёі»ґВ ї№<br1>" $
"#event18#Flag=1<br>" $
"  <br>" $
" --------------------------------------  <br1>" $
"* №Эє№ ±вґЙ  #goto<br1>" $

"ex) ЖЇБ¤ ён·Йѕо БЩ·О АМµї ЅГДС БЦґВ ±вґЙАФґПґЩ. АМ°Й АМїлЗШј­ №Эє№ ЅЗЗаА» ЗПёй ЖнЗХґПґЩ.<br1>" $
"#goto2<br1>" $
"А§ ї№Б¦ Гі·і АФ·ВЗПёй 2№шВ° ¶уАОАё·О АМµїЗХґПґЩ. #goto ён·ЙАє 0АМ Г№№шВ° БЩАФґПґЩ. <br1>" $
"* ГЦјТ ЅГ°ЈАє 100, 0.1ГК АМ»у АФ·ВЗШѕЯ goto ён·Йѕо°Ў АЫµїЗХґПґЩ. <br1>" $
"<br>" $
"№®АЗ »зЗЧАМіЄ №ц±ЧґВ VMЖА ±иµї±Щ(dongland@ncsoft.dev) ·О ѕЛ·ББЦјјїд.<br1>" $
"<br1>";
	
	ParamAdd( param, "HtmlString", htmlSetHtmlStart(desc));	
    HelpHtmlWnd(GetScript("HelpHtmlWnd")).HandleLoadHelpHtml(param);

	class'UIAPI_WINDOW'.static.ShowWindow("HelpHtmlWnd");
	class'UIAPI_WINDOW'.static.SetFocus("HelpHtmlWnd");

}

//------------------------------------------------------------------------------------
// ГјЕ© №ЪЅє	
function OnAutoOpenCheckBoxBtnClick()
{
	SetINIInt("___CommonInfo___", "autoOpen", boolToNum(autoOpenCheckBox.IsChecked()), "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");
}

function OnTextBuildCommandCutCheckBoxClick()
{
	SetINIInt("___CommonInfo___", "textBuildCommandCutCheckBox", boolToNum(textBuildCommandCutCheckBox.IsChecked()), "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");
}

function OnTextSpCutCheckBoxClick()
{
	SetINIInt("___CommonInfo___", "textSpCutCheckBox", boolToNum(textBuildCommandCutCheckBox.IsChecked()), "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");
}

function OnRunExceptionCheckBoxClick()
{
	SetINIInt("___CommonInfo___", "runExceptionCheckBox", boolToNum(runExceptionCheckBox.IsChecked()), "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");
}

//------------------------------------------------------------------------------------

function OnSelfTargetBtn()
{
	//ExecuteCommand("/target %self");
	RequestSelfTarget();
}

function OnRunUpBtnClick()
{
	local LVDataRecord record;
	local int selectIndex;

	if (itemListCtrl.GetSelectedIndex() > -1)
	{
		itemListCtrl.GetSelectedRec(record);

		if (record.LVDataList[1].szData != "")
		{
			executeLineCommand(record.LVDataList[1].szData);
			getInstanceL2Util().showGfxScreenMessage("ЅЗЗа:" @ record.LVDataList[1].szData);
		}

		selectIndex = itemListCtrl.GetSelectedIndex() - 1;

		if (selectIndex >= 0)
		{
			itemListCtrl.SetSelectedIndex(selectIndex, false);
			OnClickListCtrlRecord("itemListCtrl");
			itemListCtrl.SetFocus();			
		}
	}
}

function OnRunDownBtnClick()
{
	local LVDataRecord record;
	local int selectIndex;

	if (itemListCtrl.GetSelectedIndex() > -1)
	{
		itemListCtrl.GetSelectedRec(record);

		if (record.LVDataList[1].szData != "")
		{
			executeLineCommand(record.LVDataList[1].szData);
			getInstanceL2Util().showGfxScreenMessage("ЅЗЗа:" @ record.LVDataList[1].szData);
		}

		selectIndex = itemListCtrl.GetSelectedIndex() + 1;

		if (selectIndex < itemListCtrl.GetRecordCount())
		{
			itemListCtrl.SetSelectedIndex(selectIndex, false);
			OnClickListCtrlRecord("itemListCtrl");
			itemListCtrl.SetFocus();
		}
	}
}

function OnLineUpBtnClick()
{
	local LVDataRecord record;
	local LVDataRecord tmRecord;
	local int selectIndex;

	if (itemListCtrl.GetSelectedIndex() > -1)
	{
		itemListCtrl.GetSelectedRec(record);

		selectIndex = itemListCtrl.GetSelectedIndex() - 1;
		if (selectIndex > -1)
		{
			itemListCtrl.GetRec(selectIndex, tmRecord);
			itemListCtrl.ModifyRecord(itemListCtrl.GetSelectedIndex(), tmRecord);
			itemListCtrl.ModifyRecord(selectIndex, record);

			SetINIString(currentNoteName, String(itemListCtrl.GetSelectedIndex()), tmRecord.LVDataList[1].szData, "UIDEV_BuildCommand.ini");
			SetINIString(currentNoteName, String(selectIndex), record.LVDataList[1].szData, "UIDEV_BuildCommand.ini");
			SaveINI("UIDEV_BuildCommand.ini");
		}
		
		if (selectIndex >= 0)
		{
			itemListCtrl.SetSelectedIndex(selectIndex, false);
			OnClickListCtrlRecord("itemListCtrl");
			itemListCtrl.SetFocus();			
		}
	}
}

function OnLineDownBtnClick()
{
	local LVDataRecord record;
	local LVDataRecord tmRecord;
	local int selectIndex;

	if (itemListCtrl.GetSelectedIndex() > -1)
	{
		itemListCtrl.GetSelectedRec(record);

		selectIndex = itemListCtrl.GetSelectedIndex() + 1;
		if (selectIndex < itemListCtrl.GetRecordCount())
		{
			itemListCtrl.GetRec(selectIndex, tmRecord);
			itemListCtrl.ModifyRecord(itemListCtrl.GetSelectedIndex(), tmRecord);
			itemListCtrl.ModifyRecord(selectIndex, record);

			SetINIString(currentNoteName, String(itemListCtrl.GetSelectedIndex()), tmRecord.LVDataList[1].szData, "UIDEV_BuildCommand.ini");
			SetINIString(currentNoteName, String(selectIndex), record.LVDataList[1].szData, "UIDEV_BuildCommand.ini");
			SaveINI("UIDEV_BuildCommand.ini");
		}
		
		if (selectIndex < itemListCtrl.GetRecordCount())
		{
			itemListCtrl.SetSelectedIndex(selectIndex, false);
			OnClickListCtrlRecord("itemListCtrl");
			itemListCtrl.SetFocus();
		}
	}
}

function OnEditBtnClick()
{
	local LVDataRecord record;
	local int selectIndex;

	// јцБ¤.
	selectIndex = itemListCtrl.GetSelectedIndex();

	if (selectIndex > -1)
	{
		if (descViewEditBox.GetString() != "")
		{
			itemListCtrl.GetSelectedRec(record);

			inputEditBox.DeleteNameFromAdditionalSearchList(record.LVDataList[1].szData, ESearchListType.SLT_ADDITIONAL_LIST);

			record.LVDataList[1].szData = descViewEditBox.GetString();
			itemListCtrl.ModifyRecord(selectIndex, record);

			inputEditBox.AddNameToAdditionalSearchList(descViewEditBox.GetString(), ESearchListType.SLT_ADDITIONAL_LIST);

			SetINIString(currentNoteName, String(selectIndex), descViewEditBox.GetString(), "UIDEV_BuildCommand.ini");
			SaveINI("UIDEV_BuildCommand.ini");
		}
	}
}


// їЎµрЕН №ЪЅє 0~11 ¶уАО, єЩАМ±в bLastEditBoxFocusґВ ёЦЖј¶уАО єЩАМ±в АП¶§ ё¶Бцё·їЎ ЖчДїЅє БЦ±в
// onelineOverwrite ЗСБЩ єЩАМ±вё¦ ЗТ¶§ґЩ Бцїм±в
function pasteClipboardAtList()
{
	local array<string> commandArray;
	local int idx;//, nTextSpCutCheckBox, nTextBuildCommandCutCheckBox;
	local string pasteString, commandStr;

	if (!Me.isShowWindow() || !inputEditBox.IsFocused()) return;

	commandStr = clipboardpaste();
	//Split(commandStr, "\n", commandArray);

	//InStr( commandStr ,Chr(13) )

	// Debug("commandStr : " @ commandStr);
	Split(commandStr, Chr(13), commandArray);

	// \n їЈЕН °ЄАМ АЦіЄ? АЦАёёй ёЦЖј¶уАО..
	if(InStr( commandStr ,Chr(13) ) != -1)
	{
		for (idx = 0; idx < commandArray.Length; idx++)
		{
			pasteString = deleteEnter(commandArray[idx]);

			//AddList(itemListCtrl.GetRecordCount(), deleteFrontStr(pasteString));
			
			if (textSpCutCheckBox.IsChecked()) pasteString = deleteSpStr(pasteString);
			if (textBuildCommandCutCheckBox.IsChecked()) 
			{
				// єфµе ён·Йѕо°Ў ѕЖґПёй ґЩАЅАё·О іСѕо°ЈґЩ.
				if (InStr(pasteString, "//") == -1) continue;
			}

			AddCommandList(currentNoteName, deleteFrontStr(pasteString));
		}//»эјє 19785 (ЕЧЅєЖ®)

		itemListCtrl.SetSelectedIndex(itemListCtrl.GetRecordCount() - 1, true);
	}
	// ЗСБЩ іЦ±в
	else
	{
		//AddList(itemListCtrl.GetRecordCount(), deleteFrontStr(commandStr));
		//inputEditBox.SetString(deleteFrontStr(commandStr));
		if (textSpCutCheckBox.IsChecked()) commandStr = deleteSpStr(commandStr);

		if (textBuildCommandCutCheckBox.IsChecked()) inputEditBox.AddString(deleteFrontStr(commandStr));
		else inputEditBox.AddString(commandStr);
	}
}

function string deleteSpStr(string s)
{
	local int idx;
	local string str;

	idx = InStr(s, "(");
	
	if ( idx > 0 ) 
	{
		str = Mid(s, 0, idx);
	}
	else
	{
		str = s;
	}

	return str;
}

function string deleteFrontStr(string s)
{
	local int idx;
	local string str;

	idx = InStr(s, "//");

	if ( idx > 0 ) 
	{
		str = Mid(s, idx, Len(s));
	}
	else
	{
		str = s;
	}

	return str;
}

//executeLineCommand("#event1080#a=10 b=dong");
function executeLineCommand(string s)
{
	local int idx, i, gotoLine;//, m;
	local string str, param, sKey, sValue;//, commandStr, wordStr;
	local array<string> commandArray, wordArray;
	local string commandKey;

	idx = InStr(s, "#event");
	if (idx > -1) commandKey = "#event";

//	Debug("idx" @ idx);
	if (idx == -1)
	{
		idx = InStr(s, "#goto");
		if (idx > -1) commandKey = "#goto";
	}	

	if ( idx > -1 ) 
	{
		if(commandKey == "#goto")
		{
			str = Mid(s, idx + Len("#goto"), Len(s));
			Split(str, "#", commandArray);

			if (commandArray.Length > 0)
			{
				Debug("gotoґЩ!!" @ commandArray[0]);

				if(int(commandArray[0]) > -1)
				{
					gotoLine = int(commandArray[0]) - 1;
					if (gotoLine <= 0) gotoLine = 0;

					Debug("-->" @ int(runTimeEditBox.GetString()));
					// 0.1 ГК єёґЩ ДїѕЯ АЫµї
					if (int(runTimeEditBox.GetString()) < 100)
					{
						getInstanceL2Util().showGfxScreenMessage(runTimeEditBox.GetString() @ ", АЫµїѕИЗФ, 1/100ГК АМ»у ЅЗЗаЅГ°ЈАМ ДїѕЯ АЫµїЗХґПґЩ");
					}
					else
					{
						Me.KillTimer( TIMER_ID_RUN );
						isStepRun = false;

						getInstanceL2Util().showGfxScreenMessage(runTimeEditBox.GetString() @ ", №Эє№!");
						itemListCtrl.SetSelectedIndex(gotoLine, false);
						stepTimeExecuteCommand();
					}
				}
			}

		}
		// #event
		// АМєҐЖ® °­Б¦ №Я»э
		else if(commandKey == "#event")
		{
			str = Mid(s, idx + Len("#event"), Len(s));
			Split(str, "#", commandArray);

			if (commandArray.Length > 0)
			{
				if (commandArray.Length == 1)
				{
					ExecuteEvent(int(commandArray[0]), "");
				}
				else
				{
					//Debug("commandArray len:" @ commandArray.Length);

					for(i = 1;i < commandArray.Length; i++)
					{
						// Debug(i @ "commandArray" @ commandArray[i]);

						if (wordArray.Length > 0)
							wordArray.Remove(0,wordArray.Length);

						Split(commandArray[i], "=", wordArray);

						if (wordArray.Length > 0)
						{
							sKey = wordArray[0];
							sValue = "";
							if (wordArray.Length > 1)
							{
								sValue = wordArray[1];
							}
						}

						ParamAdd(param, sKey, sValue);
						//Debug(m @ "m:" @ wordArray[m]);
					}
						
					ExecuteEvent(int(commandArray[0]), param);
					//Debug("param : " @ param);
					//ExecuteEvent(int(commandArray[0]), commandArray[1]);
				}
			}
		}
		
		//Debug("ExecuteEvent :" @ s);
		//Debug("ExecuteEvent Array len :" @ commandArray.Length);
	}
	else
	{
		if (runExceptionCheckBox.IsChecked()) s = deleteSpStr(s);
		ExecuteCommand(s);

		getInstanceL2Util().showGfxScreenMessage("ЅЗЗа:" @ s);
	}
}


function OnKeyUp( WindowHandle a_WindowHandle, EInputKey nKey )
{
	local LVDataRecord record;
	//Debug("ДїёХ Е°:"@a_WindowHandle.GetWindowName());
	//Debug("class'InputAPI'.static.GetKeyString(nKey):" @ class'InputAPI'.static.GetKeyString(nKey));
	//Debug("class'InputAPI'.static.IsAltPressed()" @ class'InputAPI'.static.IsAltPressed());

	if ( class'InputAPI'.static.IsCtrlPressed() && class'InputAPI'.static.GetKeyString(nKey) == "C")
	{
		if (itemListCtrl.IsFocused())
		{
			itemListCtrl.GetSelectedRec(record);

			ClipboardCopy(record.LVDataList[1].szData);
			//getInstanceL2Util().showGfxScreenMessage("Е¬ёі єёµе Д«ЗЗ:" @ record.LVDataList[1].szData);
			AddSystemMessageString("Е¬ёі єёµе Д«ЗЗ:" @ record.LVDataList[1].szData);

			inputEditBox.SetFocus();
		}

	}
	if( class'InputAPI'.static.GetKeyString(nKey) == "ALT")
	{
		if(descViewEditBox.IsFocused())
		{
			inputEditBox.SetFocus();
		}
		else if(itemListCtrl.IsFocused())
		{
			descViewEditBox.SetFocus();
		}
		else
		{
			itemListCtrl.SetFocus();
		}
	}

	if( class'InputAPI'.static.GetKeyString(nKey) == "ENTER")
	{
		if(descViewEditBox.IsFocused())
		{
			OnEditBtnClick();
			itemListCtrl.SetFocus();
		}
	}
}


/**
 * А©µµїм ESC Е°·О ґЭ±в Гіё® 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();

	nReloadOpen = false;
}

defaultproperties
{
}
