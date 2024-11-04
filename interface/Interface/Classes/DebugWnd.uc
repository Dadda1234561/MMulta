/*

// 각 UC에 아래와 같이 하면 디버그를 끌 수 있다.
// defaultproperties
// {
//	bDoNotUseDebug = true;
// }
// Ctrl 키 누르면 자동으로 맨 아래ㄹ..

*/
class DebugWnd extends UICommonAPI;


var WindowHandle    Me;

// 메인 탭 
var TabHandle       MainTab;

// 목록 
var ListCtrlHandle itemListCtrl0;
var ListCtrlHandle itemListCtrl1;
var ListCtrlHandle itemListCtrl2;
var ListCtrlHandle itemListCtrl3;
var ListCtrlHandle itemListCtrl4;
var ListCtrlHandle itemListCtrl5;

// Debug 탭별 창 
var WindowHandle    AllWnd;
var WindowHandle   WarningWnd;
var WindowHandle   ErrorWnd;
var WindowHandle   ScriptWnd;
var WindowHandle   GfxWnd;
var WindowHandle   CustomWnd;

var CheckBoxHandle autoOpenCheckBox;

var CheckBoxHandle wCheckBox;
var CheckBoxHandle eCheckBox;
var CheckBoxHandle sCheckBox;
var CheckBoxHandle gCheckBox;

var ButtonHandle startToggleButton;
var L2Util util;


var bool bUselastLineFocus;
var int nAutoOpen, nTabIndex;
var bool nReloadOpen;

var int nW_Filter;
var int nE_Filter;
var int nS_Filter;
var int nG_Filter;

var CheckBoxHandle FilterCheckBox;
var ButtonHandle LineDnButton;
var EditBoxHandle filterEditBox;
var int nF_Filter;
var HtmlHandle mTextParamHtmlCtrl;
var string mTextParamStr;
var array<string> filterArray;

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_StateChanged);
		
	RegisterEvent(EV_UIDebugMsg); // 9995
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle( "DebugWnd" );
	MainTab = GetTabHandle( "DebugWnd.MainTab" );
		
	AllWnd      = GetWindowHandle( "DebugWnd.AllWnd" );
	WarningWnd  = GetWindowHandle( "DebugWnd.WarningWnd" );
	ErrorWnd    = GetWindowHandle( "DebugWnd.ErrorWnd" );
	ScriptWnd   = GetWindowHandle( "DebugWnd.ScriptWnd" );
	GfxWnd      = GetWindowHandle( "DebugWnd.GfxWnd" );
	CustomWnd   = GetWindowHandle( "DebugWnd.CustomWnd" );

	itemListCtrl0 = GetListCtrlHandle( "DebugWnd.AllWnd.itemListCtrl0" );
	itemListCtrl1 = GetListCtrlHandle( "DebugWnd.WarningWnd.itemListCtrl1" );
	itemListCtrl2 = GetListCtrlHandle( "DebugWnd.ErrorWnd.itemListCtrl2" );
	itemListCtrl3 = GetListCtrlHandle( "DebugWnd.ScriptWnd.itemListCtrl3" );
	itemListCtrl4 = GetListCtrlHandle( "DebugWnd.GfxWnd.itemListCtrl4" );
	itemListCtrl5 = GetListCtrlHandle( "DebugWnd.CustomWnd.itemListCtrl5" );

	autoOpenCheckBox = GetCheckBoxHandle("DebugWnd.autoOpenCheckBox");

	wCheckBox = GetCheckBoxHandle("DebugWnd.wCheckBox");
	eCheckBox = GetCheckBoxHandle("DebugWnd.eCheckBox");
	sCheckBox = GetCheckBoxHandle("DebugWnd.sCheckBox");
	gCheckBox = GetCheckBoxHandle("DebugWnd.gCheckBox");

	FilterCheckBox = GetCheckBoxHandle("DebugWnd.FilterCheckBox");

	startToggleButton = GetButtonHandle("DebugWnd.startToggleButton");

	mTextParamHtmlCtrl = GetHtmlHandle("DebugWnd.TextParamHtmlCtrl");
	filterEditBox = GetEditBoxHandle("DebugWnd.filterEditBox");

	nAutoOpen= -9999;
	checkBoxFilterShow(false);
	setWindowTitleByString("UITools - UDebug");
	util = L2Util(GetScript("L2Util"));
	mTextParamStr = "";
}

function OnShow()
{
	setStartToggleButton(true);
	
}

function setStartToggleButton(bool bFlag)
{
	bUselastLineFocus = bFlag;

	if(bFlag)
	{
		startToggleButton.SetNameText("Stop");
		getCurrentListCtrlHandle().SetSelectedIndex(getCurrentListCtrlHandle().GetRecordCount() - 1, true);
	}
	else
	{
		startToggleButton.SetNameText("Start");		
	}
}


function Load()
{
	
}

function OnClickListCtrlRecord( String strID )
{
	local LVDataRecord record;

	if (getCurrentListCtrlHandle().GetSelectedIndex() != -1)
	{
		getCurrentListCtrlHandle().GetSelectedRec(record);
		mTextParamHtmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(Record.LVDataList[1].szReserved));
		mTextParamStr = Record.LVDataList[1].szReserved;
		getCurrentListCtrlHandle().SetFocus();	}		
}

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "NetChatButton":
			ExecuteCommand("///netlog chat");
			break;

		case "reloadUIButton":
			 ExecuteCommand("///rebuildui");
			 break;

		case "startToggleButton":			 
			 setStartToggleButton(!bUselastLineFocus);
			 getCurrentListCtrlHandle().SetFocus();
			 break;

		case "cmdToolButton":			 
			 toggleWindow("UICommandWnd", true, false);
			 break;

		case "gmButton":
			 toggleWindow("GMWnd", true, false);
			 break;

		case "debugButton":
			 ExecuteCommand("///uidebug");
			 break;

	    case "ClearButton" :
			 getCurrentListCtrlHandle().DeleteAllItem();
			 break;

	    case "CopyButton":
			ClipboardCopy(mTextParamStr);

			 
			 break;

	    case "ResetUIDataButton" :
			getInstanceUIData().resetUIData();
			break;
		case "LineDnButton":
			getCurrentListCtrlHandle().SetSelectedIndex(getCurrentListCtrlHandle().GetRecordCount() - 1,True);
			break;
		case "RestartButton":
			ExecRestart();
			break;
		case "TextFilterButton":
			break;
		default : 
				//	Debug("Left(Name, 6)" @ Left(Name, 7));
				if (Left(Name, 7) == "MainTab")
				{
					if(bUselastLineFocus)
					{
						getCurrentListCtrlHandle().SetSelectedIndex(getCurrentListCtrlHandle().GetRecordCount() - 1, true);
					}
					if(Name == "MainTab5")
					{
						checkBoxFilterShow(true);
					}
					else
					{
						checkBoxFilterShow(false);
					}

					nTabIndex = int(Right(Name, 1));

					SetINIInt("Debug", "tabIndex", nTabIndex, "UIDEV.ini");
					SaveINI("UIDEV.ini");

					//MainTab.SetTopOrder(nTabIndex, false);
				}
	}
}

function checkBoxFilterShow(bool bShow)
{
	if (bShow)
	{
		wCheckBox.ShowWindow();
		eCheckBox.ShowWindow();
		sCheckBox.ShowWindow();
		gCheckBox.ShowWindow();
	}
	else
	{
		wCheckBox.HideWindow();
		eCheckBox.HideWindow();
		sCheckBox.HideWindow();
		gCheckBox.HideWindow();
	}	
}

function OnEvent(int Event_ID, string param)
{
	local int nOpen;
	local string filterStr;

	if (Event_ID == EV_UIDebugMsg)
	{
		//debug("param" @ nDebugMsgType @ "=========="@ param);
		parseParamMsg(param);
	}
	else if (Event_ID == EV_GameStart)
	{
		//Debug("---EV_GameStart" @ nAutoOpen);
		if (nAutoOpen == -9999)
		{
			setStartToggleButton(true);

			GetINIString("Debug","filter",filterStr,"UIDEV.ini");
			filterEditBox.SetString(filterStr);
			sliceFilterText();

			// Debug("---메메" @ EV_UpdateUserInfo);
			GetINIInt("Debug", "autoOpen", nAutoOpen, "UIDEV.ini");

			GetINIInt("Debug", "w", nW_Filter, "UIDEV.ini");
			GetINIInt("Debug", "e", nE_Filter, "UIDEV.ini");
			GetINIInt("Debug", "s", nS_Filter, "UIDEV.ini");
			GetINIInt("Debug", "g", nG_Filter, "UIDEV.ini");

			// Debug("nAutoOpen ini 읽었을때" @nAutoOpen);

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

			GetINIInt("Debug", "tabIndex", nTabIndex, "UIDEV.ini");
			MainTab.SetTopOrder(nTabIndex, false);
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
			GetINIInt("Debug", "autoOpen", nOpen, "UIDEV.ini");

			if (nOpen == 1) 
			{
				Me.ShowWindow();		
				autoOpenCheckBox.SetCheck(true);
								
				GetINIInt("Debug", "w", nW_Filter, "UIDEV.ini");
				GetINIInt("Debug", "e", nE_Filter, "UIDEV.ini");
				GetINIInt("Debug", "s", nS_Filter, "UIDEV.ini");
				GetINIInt("Debug", "g", nG_Filter, "UIDEV.ini");

				wCheckBox.SetCheck(numToBool(nW_Filter));
				eCheckBox.SetCheck(numToBool(nE_Filter));
				sCheckBox.SetCheck(numToBool(nS_Filter));
				gCheckBox.SetCheck(numToBool(nG_Filter));

				GetINIString("Debug","filter",filterStr,"UIDEV.ini");
				filterEditBox.SetString(filterStr);
				sliceFilterText();
				GetINIInt("Debug","Usefilter",nF_Filter,"UIDEV.ini");
				FilterCheckBox.SetCheck(numToBool(nF_Filter));

				GetINIInt("Debug", "tabIndex", nTabIndex, "UIDEV.ini");
				MainTab.SetTopOrder(nTabIndex, false);

				setStartToggleButton(true);
			}
			else
			{
				autoOpenCheckBox.SetCheck(false);
			}
		}		
	}
	else if (Event_ID == EV_Restart)
	{
		nReloadOpen = false;
		nAutoOpen = -9999;
	}
}

//enum EUIDebugMsgType
//{
//    EUDMT_NONE,    // 일반 메시지
//    EUDMT_ERROR,    // 에러 메시지
//    EUDMT_WARNING,    // 경고 메시지
//    EUDMT_SCRIPT,    // UC Script의 debug(str) 함수 호출 메시지
//    EUDMT_GFX,    // Flash & GFx 관련 메시지
//};

function parseParamMsg(string param)
{
	local int nDebugMsgType, i;
	local string debugMsg;

	ParseInt( param, "Type", nDebugMsgType );
	//ParseString( param, "Msg" , debugMsg );

	//debugMsg = param;

	// 파싱시 짤리는 문제로 임시로 처리
	i = InStr(param, "Msg=");

	
	if (i > -1)
	{
		
		debugMsg = Mid(param, i + 4, Len(param) - 1);
		
		addList(nDebugMsgType, trimParam(debugMsg));
	}
}

function addList(int nDebugMsgType, string debugMsg)
{
	local LVDataRecord Record;
	local string viewStr, szStr, callerWindowName;

	local string strData;
	
	local ListCtrlHandle itemListCtrl;

	local array<string>	arrSplit;

	local bool bAddCustom;
	local int i;
	local bool bFilterColor;

	strData = debugMsg;
	debugMsg = deleteEnter(debugMsg);
	if ( FilterCheckBox.IsChecked() )
	{
		for ( i = 0;i < filterArray.Length;i++ )
		{
			if ( InStr(ToLower(debugMsg), ToLower(filterArray[i])) != -1 )
			{
				bFilterColor = True;
				break;
			}
		}
	}
	split(debugMsg, DEBUG_SPLIT_STR, arrSplit );

	itemListCtrl = getCurrentListCtrlHandle();

	Record.LVDataList.length = 2;
	Record.nReserved1 = nDebugMsgType;

	if(arrSplit.Length < 2)
	{
		viewStr = "(" $ GetTimeString() $ ")" @ debugMsg;
	}
	else
	{
		callerWindowName = arrSplit[0];
		if(arrSplit.Length > 1)	viewStr = Right(arrSplit[1], (Len(arrSplit[1]) + 1) - Len(DEBUG_SPLIT_STR));
		viewStr = "(" $ GetTimeString() $ ")" @ viewStr;
	}

	szStr = viewStr;
	if ( Len(viewStr) > 100 )
	{
		viewStr = Mid(viewStr,0,99);
	}

	record.LVDataList[0].szData = "";//String(nDebugMsgType);
	if ( bFilterColor )
	{
		Record.LVDataList[0].bUseTextColor = True;
		Record.LVDataList[0].szData = "#";
		Record.LVDataList[0].TextColor = GetColor(255,240,0,255);
	}
	record.LVDataList[1].buseTextColor = True;
	Record.LVDataList[1].szData = viewStr;
	//Record.LVDataList[1].szReserved = szStr;

	Record.LVDataList[1].szReserved = strData;

	Record.LVDataList[1].textAlignment = TA_Left;
	Record.szReserved = callerWindowName;
	
	if (nDebugMsgType == EUIDebugMsgType.EUDMT_NONE) 
	{
		Record.LVDataList[1].textColor = getColor(238, 170, 34, 255);
		bAddCustom = true;
	}
	else if (nDebugMsgType == EUIDebugMsgType.EUDMT_WARNING) 
	{		
		Record.LVDataList[1].textColor = getColor(238, 111, 34, 255);
		itemListCtrl1.InsertRecord( Record );

		if (nW_Filter > 0) bAddCustom = true;
	}

	else if (nDebugMsgType == EUIDebugMsgType.EUDMT_ERROR) 
	{
		Record.LVDataList[1].textColor = getColor(255, 0, 0, 255);
		itemListCtrl2.InsertRecord( Record );

		if (nE_Filter > 0) bAddCustom = true;
	}
	else if (nDebugMsgType == EUIDebugMsgType.EUDMT_SCRIPT) 
	{
		//Record.LVDataList[1].textColor = getColor(111, 170, 33, 255);
		Record.LVDataList[1].textColor = getColor(222, 222, 222, 255);
		itemListCtrl3.InsertRecord( Record );
		if (nS_Filter > 0) bAddCustom = true;
	}
	else if (nDebugMsgType == EUIDebugMsgType.EUDMT_GFX) 
	{
		Record.LVDataList[1].textColor = getColor(222, 172, 220, 255);
		//Record.LVDataList[1].szData = viewStr;
		// All 에는 GFX 표시
		Record.LVDataList[1].szData ="(" $ GetTimeString() $ ")" @ "GFX" @ debugMsg;

		itemListCtrl4.InsertRecord( Record );


		if (nG_Filter > 0) bAddCustom = true;

	}
	//getCurrentListCtrlHandle().InsertRecord( Record );

	// All
	itemListCtrl0.InsertRecord( Record );


	// Custom 
	if (bAddCustom) itemListCtrl5.InsertRecord( Record );

	if (bUselastLineFocus)
	{
		if (itemListCtrl.GetRecordCount() -1 < itemListCtrl.GetSelectedIndex() + 2)
		{	
			itemListCtrl.SetSelectedIndex(itemListCtrl.GetRecordCount() - 1, true);	
		}		
	}
}

//레코드를 더블클릭하면....
function OnDBClickListCtrlRecord( string ListCtrlID )
{
	//Debug("ListCtrlID" @ ListCtrlID);

	
	setSymbolSelectedRecord();

	//switch(ListCtrlID)
	//{
	//	case "itemListCtrl0" :
	//		 GetSelectedRecord(itemListCtrl0);
	//		 break;
	//	case "itemListCtrl1" :
	//		 GetSelectedRecord(itemListCtrl1);
	//		 break;
	//	case "itemListCtrl2" :
	//		 GetSelectedRecord(itemListCtrl2);
	//		 break;
	//	case "itemListCtrl3" :
	//		 GetSelectedRecord(itemListCtrl3);
	//		 break;
	//	case "itemListCtrl4" :
	//		 GetSelectedRecord(itemListCtrl4);
	//		 break;
	//}
}


function setSymbolSelectedRecord()
{
	local LVDataRecord record;
	
	local ListCtrlHandle itemListCtrl;

	itemListCtrl = getCurrentListCtrlHandle();

	itemListCtrl.GetSelectedRec(record);

	record.LVDataList[0].buseTextColor = True;
	
	if (record.LVDataList[0].szData == "o")	
	{
		record.LVDataList[0].textColor = util.Yellow;
		record.LVDataList[0].szData= "*";
	}
	else if (record.LVDataList[0].szData == "*")	
	{
		record.LVDataList[0].szData= "";
	}
	else 
	{
		record.LVDataList[0].textColor = util.DRed;
		record.LVDataList[0].szData= "o";
	}
	
	itemListCtrl.ModifyRecord(itemListCtrl.GetSelectedIndex(), record);
}

function OnKeyUp( WindowHandle a_WindowHandle, EInputKey nKey )
{
	local LVDataRecord record;

	local ListCtrlHandle itemListCtrl;
	local string copyStr;

	itemListCtrl = getCurrentListCtrlHandle();


	//Debug("커먼 키:"@a_WindowHandle.GetWindowName());
	//Debug("class'InputAPI'.static.GetKeyString(nKey):" @ class'InputAPI'.static.GetKeyString(nKey));
	//Debug("class'InputAPI'.static.IsAltPressed()" @ class'InputAPI'.static.IsAltPressed());

	if ( class'InputAPI'.static.IsCtrlPressed() && class'InputAPI'.static.GetKeyString(nKey) == "C")
	{
		if (itemListCtrl.IsFocused())
		{
			itemListCtrl.GetSelectedRec(record);

			if(Len(record.LVDataList[1].szReserved) > 10)
			{
				copyStr = Right(record.LVDataList[1].szReserved, Len(record.LVDataList[1].szReserved) - 11);
			}
			else
			{
				copyStr = record.LVDataList[1].szReserved;
			}

			if (copyStr == "")
			{
				//AddSystemMessageString("클립 보드 카피할 스트링이 없음.");
			}
			else
			{
				ClipboardCopy(copyStr);
				// AddSystemMessageString("클립 보드 카피:" @ copyStr);
			}

			//itemListCtrl.SetFocus();
		}
	}
	
	else if (class'InputAPI'.static.IsAltPressed())// (class'InputAPI'.static.GetKeyString(nKey) == "ALT")
	{
		setStartToggleButton(true);
	}
	//setStartToggleButton(true);	

	//if( class'InputAPI'.static.GetKeyString(nKey) == "ALT")
	//{
	//	if(itemListCtrl.IsFocused())
	//	{
	//		descViewEditBox.SetFocus();
	//	}
	//	else
	//	{
	//		itemListCtrl.SetFocus();
	//	}
	//}

	//if( class'InputAPI'.static.GetKeyString(nKey) == "ENTER")
	//{
	//	if(descViewEditBox.IsFocused())
	//	{
	//		OnEditBtnClick();
	//		itemListCtrl.SetFocus();
	//	}
	//}
}

//------------------------------------------------------------------------------------
// 체크 박스	

function OnClickCheckBox( string strID)
{
	switch( strID )
	{
		case "autoOpenCheckBox" :
			 OnAutoOpenCheckBoxBtnClick();
			 break;

		case "wCheckBox" :
			SetINIInt("Debug", "w", boolToNum(wCheckBox.IsChecked()), "UIDEV.ini");
			SaveINI("UIDEV.ini");
			nW_Filter = boolToNum(wCheckBox.IsChecked());

			break;
		case "eCheckBox" :
			SetINIInt("Debug", "e", boolToNum(eCheckBox.IsChecked()), "UIDEV.ini");
			SaveINI("UIDEV.ini");
			nE_Filter = boolToNum(eCheckBox.IsChecked());

			break;
		case "sCheckBox" :
			SetINIInt("Debug", "s", boolToNum(sCheckBox.IsChecked()), "UIDEV.ini");
			SaveINI("UIDEV.ini");

			nS_Filter = boolToNum(sCheckBox.IsChecked());

			break;
		case "gCheckBox" :
			SetINIInt("Debug", "g", boolToNum(gCheckBox.IsChecked()), "UIDEV.ini");
			SaveINI("UIDEV.ini");
			nG_Filter = boolToNum(gCheckBox.IsChecked());

			break;
		case "FilterCheckBox":
			SetINIInt("Debug","Usefilter",boolToNum(FilterCheckBox.IsChecked()),"UIDEV.ini");
			SaveINI("UIDEV.ini");
			nF_Filter = boolToNum(FilterCheckBox.IsChecked());
			break;
	}
}

function onFilterCheckboxClick(string strID)
{
	
}

function OnAutoOpenCheckBoxBtnClick()
{
	SetINIInt("Debug", "autoOpen", boolToNum(autoOpenCheckBox.IsChecked()), "UIDEV.ini");
	SaveINI("UIDEV.ini");
}


function ListCtrlHandle getCurrentListCtrlHandle()
{
	switch(MainTab.GetTopIndex())
	{
		case 1 : return itemListCtrl1;
		case 2 : return itemListCtrl2;
		case 3 : return itemListCtrl3;
		case 4 : return itemListCtrl4;
		case 5 : return itemListCtrl5;
	}

	return itemListCtrl0;	
}

function OnCompleteEditBox (string strID)
{
	if ( strID == "filterEditBox" )
	{
		sliceFilterText();
		SetINIString("Debug","filter",filterEditBox.GetString(),"UIDEV.ini");
		SaveINI("UIDEV.ini");
	}
}

function OnChangeEditBox (string strID)
{
	if ( strID == "filterEditBox" )
	{
		if ( filterEditBox.GetString() == "" )
		{
			sliceFilterText();
			SetINIString("Debug","filter",filterEditBox.GetString(),"UIDEV.ini");
			SaveINI("UIDEV.ini");
		}
	}
}

function sliceFilterText ()
{
	filterArray.Length = 0;
	if ( filterEditBox.GetString() != "" )
	{
		Split(filterEditBox.GetString(),"/",filterArray);
	}
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	// 디버그니까 안하는게..
	//PlayConsoleSound(IFST_WINDOW_CLOSE);
	//GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();
}

defaultproperties
{
}
