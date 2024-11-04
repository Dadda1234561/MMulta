// �� �˻� �� �� 

class UISearchMapWnd extends UICommonAPI;
/**
var WindowHandle Me;
var ListCtrlHandle resultList;
var EditBoxHandle searchEditBox;
var ButtonHandle searchBtn;
var ButtonHandle initBtn;

var string m_WindowName;
var MinimapWnd MinimapWndScript;

const MAX_HUNTINGZONE_NUM = 400;

function OnRegisterEvent()
{
	//RegisterEvent(  );
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle( "UISearchMapWnd" );

	resultList    = GetListCtrlHandle( "UISearchMapWnd.resultList" );

	searchBtn     = GetButtonHandle( "UISearchMapWnd.searchBtn" );
	initBtn       = GetButtonHandle( "UISearchMapWnd.initBtn" );
	
	searchEditBox = GetEditBoxHandle( "UISearchMapWnd.searchEditBox" );

	MiniMapWndScript = MinimapWnd( GetScript("MinimapWnd" ) );

	GetTextBoxHandle("UISearchMapWnd.descTextBox").SetText("Ŭ��: �ʺ���, ����Ŭ��:�̵�");
}

function OnShow()
{
	initProcess();
}

function initProcess()
{
	searchEditBox.ClearAdditionalSearchList(ESearchListType.SLT_ADDITIONAL_LIST);
	inputData("", true);
}

function inputData(string searchStr, bool bAddList)
{
	local int i, MinLevel, MaxLevel, Zone, FieldType;
	local string HuntingZoneName, LevelLimit, modifiedString, mapWndStr;

	local LVDataRecord Record;	
	local Vector loc;

	resultList.DeleteAllItem();

	Record.LVDataList.length = 5;
	searchEditBox.ClearAdditionalSearchList(ESearchListType.SLT_ADDITIONAL_LIST);

	mapWndStr = MiniMapWndScript.currentWndName();
	class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget(mapWndStr $ ".Minimap");	

	for(i = 0; i < MAX_HUNTINGZONE_NUM ; i++)
	{		
		if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i))
		{
			FieldType = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i);
			//if( FieldType == 1 || FieldType == 2 )
			if(true)
			{	
				//����� ������ ������
				HuntingZoneName = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i); 
				MinLevel = class'UIDATA_HUNTINGZONE'.static.GetMinLevel(i); 
				MaxLevel = class'UIDATA_HUNTINGZONE'.static.GetMaxLevel(i); 
				Zone = class'UIDATA_HUNTINGZONE'.static.GetHuntingZone(i); 
				//Description = class'UIDATA_HUNTINGZONE'.static.GetHuntingDescription(i); 
					
				//������ ����
				if(MinLevel > 0 && MaxLevel > 0)
				{
			 		LevelLimit = MinLevel $ "~" $ MaxLevel;	
				}
				else if(minlevel > 0)
				{
					LevelLimit = MinLevel $ " " $ GetSystemString(859); // �̻�
				}else
				{
					LevelLimit = GetSystemString(866);  // ���� ����
				}	

				//Debug("HuntingZoneName: " @ HuntingZoneName);
				
				//FieldType_Name = conv_zoneType(FieldType);
				

				modifiedString = Substitute(HuntingZoneName, " ", "", FALSE);

				//Debug("modifiedString:" @ modifiedString);
				loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(i);
				if (loc.x != 0.f && loc.y != 0.f && loc.z != 0.f)
				{
					searchEditBox.AddNameToAdditionalSearchList(HuntingZoneName, ESearchListType.SLT_ADDITIONAL_LIST);

					if (StringMatching(modifiedString, searchStr, " ") || searchStr == "")
					{
						if (bAddList)
						{	
							if (searchStr != "") class'UIAPI_MINIMAPCTRL'.static.AddTarget(mapWndStr $ ".Minimap",loc);

							//���� �����͸� ���ڵ�� �����
							Record.LVDataList[0].nReserved1 = i;
							Record.LVDataList[0].szData = HuntingZoneName;
							//Record.LVDataList[1].szData = "-_-";
							//Record.LVDataList[2].szData = LevelLimit;

							resultList.InsertRecord( Record );
							
							//loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(i);
						}
					}
				}
			}
		}
	}
}

function OnDBClickListCtrlRecord(string ID)
{
	local LVDataRecord Record;
	local Vector loc;

	if ("resultList" == ID)
	{
		resultList.GetSelectedRec(Record);

		loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);

		if (loc.x != 0.f && loc.y != 0.f && loc.z != 0.f)
		{
			Debug("teleport -> " @ loc.x @ loc.Y @ loc.Z );
			ProcessChatMessage("//teleport" @ loc.x @ loc.Y @ loc.Z);
		}
		else
		{
			Debug("Error: loc X, Y, Z is zero");
		}
	}
}

function OnClickListCtrlRecord(string ID)
{
	local LVDataRecord Record;
	local Vector loc;
	local string mapWndStr;

	Debug("OnClickListCtrlRecord" @ ID);
	if ("resultList" == ID)
	{
		resultList.GetSelectedRec(Record);

		loc = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);

		mapWndStr = MiniMapWndScript.currentWndName();
		GetWindowHandle(mapWndStr).ShowWindow();

		MinimapWnd(GetScript("MinimapWnd")).SetLocContinent(loc);

		if (loc.x != 0.f && loc.y != 0.f && loc.z != 0.f)
		{
			class'UIAPI_MINIMAPCTRL'.static.AdjustMapView(mapWndStr $ ".Minimap",loc,false); 
			class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget(mapWndStr $ ".Minimap");
			class'UIAPI_MINIMAPCTRL'.static.AddTarget(mapWndStr $ ".Minimap",loc);
		}
		CallGFxFunction("MiniMapGFxWnd","findRegionInfoByLabel",Record.LVDataList[0].szData);
	}
}

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "searchBtn":
			 OnsearchBtnClick();
			 break;

		case "initBtn" :
			 class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget(MiniMapWndScript.currentWndName() $ ".Minimap");
			 searchEditBox.SetString("");
			 initProcess();
			 break;
	}
}

function OnsearchBtnClick()
{
	inputData(searchEditBox.GetString(), true);
}

/** OnKeyUp */
function OnKeyUp( WindowHandle a_WindowHandle, EInputKey nKey )
{
	// Ű���� �������� üũ 	
	if ( searchEditBox.IsFocused() )
	{	
		//// txtPath
		if (nKey == IK_Enter) 
		{
			OnsearchBtnClick();	
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
	GetWindowHandle( m_WindowName ).HideWindow();
}
**/

defaultproperties
{
}
