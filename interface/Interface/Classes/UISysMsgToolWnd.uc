class UISysMsgToolWnd extends UICommonAPI;

var WindowHandle  Me;
var String m_WindowName;
var bool bShow;	// GM창에서 버튼을 한번 더 누르면 사라지게 하기 위한 변수
var Color Gold;

var ListCtrlHandle	m_hFindTreeList;

var EditBoxHandle	m_hEditBox;

//var ComboBoxHandle  m_hComboBox;

var ButtonHandle    m_hBtnSummon, b_btnInit;

const ASK_SUMMON_NUMBER = 10000;

function OnRegisterEvent()
{	
}

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("UISysMsgToolWnd");
	m_hFindTreeList = GetListCtrlHandle(m_WindowName $ ".ListFindWnd");
//	m_hEdSummonCnt = GetEditBoxHandle(m_WindowName$".edSummonCnt");
	
	m_hEditBox = GetEditBoxHandle(m_WindowName$".EditBox");
	
	//m_hComboBox = GetComboBoxHandle (m_WindowName$".ComboBox" );

	m_hBtnSummon = GetButtonHandle (m_WindowName$".btnSummon" );
	b_btnInit = GetButtonHandle (m_WindowName$".btnInit" );

	// 상해에서 만든 api , 툴팁을 클릭 롤 오버만 해도 보이도록
	m_hFindTreeList.SetSelectedSelTooltip(false);	
	m_hFindTreeList.SetAppearTooltipAtMouseX(true);


	//bSummon = false;
	//SummonType = SUMMONTYPE_None;
	bShow = false;

	Gold.R = 176;
	Gold.G = 153;
	Gold.B  = 121;

	GetEditBoxHandle(m_WindowName$".param" $ "1" $ "EditBox").SetString("a");
	GetEditBoxHandle(m_WindowName$".param" $ "2" $ "EditBox").SetString("b");
	GetEditBoxHandle(m_WindowName$".param" $ "3" $ "EditBox").SetString("c");
	GetEditBoxHandle(m_WindowName$".param" $ "4" $ "EditBox").SetString("d");
	GetEditBoxHandle(m_WindowName$".param" $ "5" $ "EditBox").SetString("e");
}

function OnShow()
{
	m_hEditBox.SetString("");
	m_hEditBox.SetFocus();

	handleFind();
}

function ShowList ( String a_Param )
{	
	FindAllSystemMessage( a_Param );
	
	Me.ShowWindow();
	Me.SetFocus();
}

function FindAllSystemMessage( string a_Param) 
{
	local int i;
	local String fullNameString;

	ClearList();

	for (i = 0; i <= 20000; i++)
	{
		fullNameString = GetSystemMessage ( i ) ;
		
		if ( fullNameString != "" )
		{	
			//Debug( "FindAllSystemMessage" @ fullNameString );
			if ( InsertRecordFindTreeList ( fullNameString, a_Param, i, "" ) >= 20000 ) 
			{
				AddSystemMessage(3489);	
				return;		
			}
		}
	}	
}

function int InsertRecordFindTreeList( string fullNameString , string a_param, int id, string iconName) 
{
	local  string modifiedString, msgType;
	local LVDataRecord record;		
	
	local SystemMsgData sysMsgData;
	
	
	record.LVDataList.Length = 3;
	
	modifiedString = Substitute(fullNameString, " ", "", FALSE);

	if ( findMatchString ( modifiedString, a_Param ) != -1 || a_Param == "" || a_Param == String ( id ) )
	{	
		record.LVDataList[0].buseTextColor = True;		
		record.LVDataList[0].TextColor = Gold;		

		//if (curListType ==LISTTYPE_ITEM)
		//{
		//	// 해당 아이템 정보 리스트에 넣을때꺼내올수 있도록 기억  <- 중국쪽에서 만든 api
		//	class'UIDATA_ITEM'.static.GetItemInfoString(id, itemParam);  
		//	Record.szReserved = itemParam;
		//	Record.nReserved1 = Int64(id);
		//}
		//else if ( curListType == LISTTYPE_SKILL) 
		//{				
		//	record.LVDataList[1].nReserved1 = makeSkillLevel( id );
		//	fullNameString = fullNameString @ "Lv" $ record.LVDataList[1].nReserved1 ; 		
		//}			
		
		//if ( iconName != "" ) record = InsertIconData(record, iconName);

		record.LVDataList[0].szData = fullNameString;

		record.LVDataList[1].szData= string( id );
		record.LVDataList[1].TextColor = Gold;	
		record.LVDataList[1].nReserved1 = id;


		//  var String OnScrMsg;
			//  var string GFxScrMsg;
		//  var string GFxScrParam;
		GetSystemMsgInfo(record.LVDataList[1].nReserved1, sysMsgData);

		if (sysMsgData.OnScrMsg != "")
			msgType = "S" $ string(SysMsgData.WindowType);

		if (sysMsgData.GFxScrMsg != "")
			msgType = msgType $ "G";

		record.LVDataList[2].szData = msgType;
		
		m_hFindTreeList.InsertRecord(record);

		return m_hFindTreeList.GetRecordCount();
	}
}

function int findMatchString( string modifiedString, string a_Param )
{
	//local array <string> modifiedParamArr;
	//local int i ;
	local string delim;
	//local int _inStr;

	//branch GD35_0828 2013-11-13 luciper3 - 미국에서 지엠명령어 대소문 구분없이 사용가능하도록 수정해달라고함.
	//local bool bIsUsa;
	//local string strTemp1;
	//local string strTemp2;
	//end of branch

	delim  = " ";
	
	if (StringMatching(modifiedString, a_Param, delim))
		return 1;
	else
		return -1;


	return 1;
}


function OnDBClickListCtrlRecord( string ListCtrlID)
{
	summon(1, 2);
}

function Summon(Int64 cnt, int buttonType)
{
	local LVDataRecord record;
	local string strParam;
	local SystemMsgData sysMsgData;
	record.LVDataList.Length = 3;

	//if ( !bSummon )  return; 

	if( GetSelectedListCtrlItem( record ) )
	{
		if ( record.LVDataList[1].szData != "")
		{
			//ProcessChatMessage("///sm"@record.LVDataList[1].szData, 0);
			if (buttonType == 1)
			{
				
			    AddSystemMessageString(MakeFullSystemMsg(record.LVDataList[0].szData,
				GetEditBoxHandle(m_WindowName$".param" $ "1" $ "EditBox").GetString(),
				GetEditBoxHandle(m_WindowName$".param" $ "2" $ "EditBox").GetString(),
				GetEditBoxHandle(m_WindowName$".param" $ "3" $ "EditBox").GetString(),
				GetEditBoxHandle(m_WindowName$".param" $ "4" $ "EditBox").GetString(),
				GetEditBoxHandle(m_WindowName$".param" $ "5" $ "EditBox").GetString()
				));

				//  var String OnScrMsg;
				//  var string GFxScrMsg;
				//  var string GFxScrParam;
				GetSystemMsgInfo(record.LVDataList[1].nReserved1, sysMsgData);

				// 스크린 메세지
				if (sysMsgData.OnScrMsg != "")
				{
					ParamAdd(strParam, "MsgType", String(1));
					ParamAdd(strParam, "WindowType", String(sysMsgData.WindowType));
					ParamAdd(strParam, "FontType", String(sysMsgData.FontType));
					ParamAdd(strParam, "BackgroundType", String(sysMsgData.BackgroundType));
					ParamAdd(strParam, "LifeTime", String(sysMsgData.LifeTime * 1000) );
					ParamAdd(strParam, "AnimationType", String(sysMsgData.AnimationType));
					//ParamAdd(strParam, "Msg", MakeFullSystemMsg(SystemMsgCurrent.OnScrMsg,Schemestr));
					ParamAdd(strParam, "MsgColorR", String(sysMsgData.FontColor.R));
					ParamAdd(strParam, "MsgColorG", String(sysMsgData.FontColor.G));
					ParamAdd(strParam, "MsgColorB", String(sysMsgData.FontColor.B));
			
					ParamAdd(strParam, "Msg", MakeFullSystemMsg(sysMsgData.OnScrMsg,
						GetEditBoxHandle(m_WindowName$".param" $ "1" $ "EditBox").GetString(),
						GetEditBoxHandle(m_WindowName$".param" $ "2" $ "EditBox").GetString(),
						GetEditBoxHandle(m_WindowName$".param" $ "3" $ "EditBox").GetString(),
						GetEditBoxHandle(m_WindowName$".param" $ "4" $ "EditBox").GetString(),
						GetEditBoxHandle(m_WindowName$".param" $ "5" $ "EditBox").GetString()));

					ExecuteEvent(EV_ShowScreenMessage, strParam);	

					Debug("strParam " @ strParam);
				}


				if (sysMsgData.GFxScrMsg != "")
				{
					getInstanceL2Util().showGfxScreenMessage( MakeFullSystemMsg(sysMsgData.GFxScrMsg,
						GetEditBoxHandle(m_WindowName$".param" $ "1" $ "EditBox").GetString(),
						GetEditBoxHandle(m_WindowName$".param" $ "2" $ "EditBox").GetString(),
						GetEditBoxHandle(m_WindowName$".param" $ "3" $ "EditBox").GetString(),
						GetEditBoxHandle(m_WindowName$".param" $ "4" $ "EditBox").GetString(),
						GetEditBoxHandle(m_WindowName$".param" $ "5" $ "EditBox").GetString()));
				}
			}
			else
			{
				ExecuteCommand("///sm m1 " $ record.LVDataList[1].nReserved1);
			}
				
		}

	}
}

function OnClickListCtrlRecord( string ListCtrlID )
{
	local LVDataRecord Record;
	//local string param;
	
	local int selectIndex;
	local SystemMsgData sysMsgData;

	m_hBtnSummon.EnableWindow();

	selectIndex = m_hFindTreeList.GetSelectedIndex();

	if (selectIndex >= 0) 
	{
		m_hFindTreeList.GetSelectedRec(Record);		

		GetSystemMsgInfo(record.LVDataList[1].nReserved1, sysMsgData);

		GetEditBoxHandle(m_WindowName$".scrMsgEditBox").SetString("");
		GetEditBoxHandle(m_WindowName$".gfxMsgEditBox").SetString("");

		if (sysMsgData.OnScrMsg != "")
			GetEditBoxHandle(m_WindowName$".scrMsgEditBox").SetString(sysMsgData.OnScrMsg);
		// End:0x137
		if(SysMsgData.OnScrParam != "")
		{
			GetEditBoxHandle(m_WindowName $ ".scrParamEditBox").SetString(SysMsgData.OnScrParam);
		}
		if (sysMsgData.GFxScrMsg != "")
			GetEditBoxHandle(m_WindowName$".gfxMsgEditBox").SetString(sysMsgData.GFxScrMsg);
	}
}

function OnClickButton( string strID )
{
	//local string summonCnt;

	switch( strID )
	{
		case "btnSummon":
			summon(1, 1);
			break;

		case "sysButton":
			summon(1, 2);
			break;

		case "btnFind":
			handleFind();		
			break;

		case "btnInit":
			m_hEditBox.SetString("");
			GetEditBoxHandle(m_WindowName$".scrMsgEditBox").SetString("");
			GetEditBoxHandle(m_WindowName$".gfxMsgEditBox").SetString("");
			GetEditBoxHandle(m_WindowName $ ".scrParamEditBox").SetString("");
			GetEditBoxHandle(m_WindowName$".param" $ "1" $ "EditBox").SetString("");
			GetEditBoxHandle(m_WindowName$".param" $ "2" $ "EditBox").SetString("");
			GetEditBoxHandle(m_WindowName$".param" $ "3" $ "EditBox").SetString("");
			GetEditBoxHandle(m_WindowName$".param" $ "4" $ "EditBox").SetString("");
			GetEditBoxHandle(m_WindowName$".param" $ "5" $ "EditBox").SetString("");
			break;
	}
}

function handleFind()
{
	local string EditBoxString;
	EditBoxString = m_hEditBox.GetString();	
	ShowList(EditBoxString);
}



function bool GetSelectedListCtrlItem(out LVDataRecord record)
{
	local int index;

	index = m_hFindTreeList.GetSelectedIndex();
	if( index >= 0 )
	{
		m_hFindTreeList.GetRec(index, record);
		return true;
	}
	return false;
}

// List related operations
function ClearList()
{
	m_hFindTreeList.DeleteAllItem();
	m_hFindTreeList.ClearTooltip();
	m_hFindTreeList.SetTooltipType("");
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( m_WindowName ).HideWindow();
}



/** OnKeyUp */
function OnKeyUp( WindowHandle a_WindowHandle, EInputKey nKey )
{
	// 키보드 누름으로 체크 	
	if ( m_hEditBox.IsFocused() )
	{	
		// txtPath
		if (nKey == IK_Enter) 
		{
			// 키보드 입력은 아무것도 입력 하지 않았을때 전체 검색을 허용하지 않는다.
			// 실수로 자꾸 누르는 경우가 있어서..
			if (trim( m_hEditBox.GetString()) != "") handleFind();
		}
	}
}

defaultproperties
{
     m_WindowName="UISysMsgToolWnd"
}
