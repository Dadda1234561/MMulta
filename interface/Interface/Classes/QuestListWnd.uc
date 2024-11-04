class QuestListWnd extends UICommonAPI;

//Handle List
var WindowHandle	Me;
var ListCtrlHandle	lstQuest;
var TextureHandle	QuestTooltip;

event OnRegisterEvent()
{
	RegisterEvent( EV_QuestInfoStart );
	RegisterEvent( EV_QuestInfo );
}

event OnLoad()
{
	SetClosingOnESC();

	//Init Handle
	Me = GetWindowHandle( "QuestListWnd" );
	QuestTooltip = GetTextureHandle( "QuestListWnd.QuestTooltip" );
	lstQuest = GetListCtrlHandle( "QuestListWnd.lstQuest" );
	
	//Init Tooltip
	InitQuestTooltip();

	lstQuest.SetSelectedSelTooltip(false);	
	lstQuest.SetAppearTooltipAtMouseX(true);

}

event OnEvent(int Event_ID, string param)
{
	switch( Event_ID )
	{
		case EV_QuestInfoStart:
			 HandleQuestInfoStart();
			 break;

		case EV_QuestInfo:
			 HandleQuestInfo(param);
			 break;
	}
}

event OnHide ()
{
	getInstanceL2Util().HideGFxMiniMapSelectedPin(getInstanceL2Util().MapPinType.PIN_YELLOW);
}

event OnClickButton( string strID )
{	
	switch( strID )
	{
		case "btnLoc":
		     ShowQuestTarget();
		     break;
	}
}

event OnDBClickListCtrlRecord(string ID)
{

	//local int		idx;
	//local int		QuestID;
	//local int		NpcID;
	//local string	strTargetName;
	//local vector	vTargetPos;
	
	//local LVDataRecord record;
	
	if (ID == "lstQuest")
	{
		ShowQuestTarget();
	
		//idx = lstQuest.GetSelectedIndex();
		//if (idx>-1)
		//{
		//	lstQuest.GetRec(idx, record);
		//	QuestID = int(record.nReserved1);
		//}
		//if (QuestID>0)
		//{
		//	NpcID = class'UIDATA_QUEST'.static.GetStartNPCID(QuestID, 1);
		//	strTargetName = class'UIDATA_NPC'.static.GetNPCName(NpcID);
		//	vTargetPos = class'UIDATA_QUEST'.static.GetStartNPCLoc(QuestID, 1);
		//	//Debug("QuestID=" $ QuestID);
		//	//Debug("strTargetName=" $ strTargetName);
		//	//Debug("vTargetPos.x=" $ vTargetPos.x);
		//	//Debug("vTargetPos.y=" $ vTargetPos.y);
		//	//Debug("vTargetPos.z=" $ vTargetPos.z);
			
		//	if (Len(strTargetName)>0)
		//	{
		//		class'QuestAPI'.static.SetQuestTargetInfo(true, true, true, strTargetName, vTargetPos, QuestID, 1);
				
		//	}
		//}	
	}
	
}

//퀘스트 리스트 시작
function HandleQuestInfoStart()
{
	lstQuest.DeleteAllItem();
	Me.ShowWindow();
	Me.SetFocus();
}

//퀘스트 리스트를 추가
function HandleQuestInfo(string param)
{

	local int		QuestID;
	local string	QuestName;
	local string	QuestRequirement;
	local string	QuestLevel, QuestTypeText;
	local int		QuestType;
	local string	QuestNpcName;
	local string	QuestDecription;
	local string TempTxt;
	
	local LVDataRecord	record;
	
	//Debug("리스트 추가");
	ParseInt(param, "QuestID", QuestID);
	ParseString(param, "QuestName", QuestName);
	ParseString(param, "QuestRequirement", QuestRequirement);
	ParseString(param, "QuestLevel", QuestLevel);
	ParseInt(param, "QuestType", QuestType);
	ParseString(param, "QuestNpcName", QuestNpcName);
	ParseString(param, "QuestDecription", QuestDecription);

	/*
	if (QuestID == 490 ) 
		QuestType = 4;
	*/
	if (QuestNpcName == "" || QuestNpcName == "None")
	{
		TempTxt = GetSystemString(27);
		QuestNpcName = TempTxt;
	}
	
	record.LVDataList.Length = 5;
	
	record.LVDataList[0].szData = QuestName;			//퀘스트 이름
	record.LVDataList[1].szData = QuestRequirement;		//수행조건
	record.LVDataList[2].szData = QuestLevel;			//레벨대
	record.LVDataList[3].nTextureWidth = 16;
	record.LVDataList[3].nTextureHeight = 16;
	switch( QuestType )
	{
	case 0:
	case 2:
		record.LVDataList[3].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_1";
		record.LVDataList[3].szData = "1";//반복성

		QuestTypeText = GetSystemString( 861 );  //반복성
		break;
	case 1:
	case 3:
		record.LVDataList[3].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_2";
		record.LVDataList[3].szData = "2";//반복성

		QuestTypeText = GetSystemString( 862 ); // 일회성 퀘스트
		break;

	case 4:		
		//Debug("일일 파티");		
	case 5:
		record.LVDataList[3].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_3";
		record.LVDataList[3].szData = "3";//반복성

		QuestTypeText = GetSystemString( 2788 ); // "일일퀘스트"
		//Debug("일일 솔로");
		break;
	}

	record.LVDataList[3].nReserved1 = QuestType;//반복성
	
	record.LVDataList[4].szData = QuestNpcName;			//의뢰자
	record.szReserved = QuestDecription;				//설명
	record.nReserved1 = QuestID;


	ParamAdd(record.szReserved, "QuestName", QuestName);
	ParamAdd(record.szReserved, "LevelText", QuestLevel);
	ParamAdd(record.szReserved, "QuestTypeText", QuestTypeText);
	
	lstQuest.InsertRecord(record);	
}

function ShowQuestTarget()
{
	local int		idx;
	local int		QuestID;
	local int		NpcID;
	local string	strTargetName, questName;
	local vector	vTargetPos;
	//local MinimapWnd Script;
	//local MinimapWnd_Expand Script2;
	local LVDataRecord record;
	//local WindowHandle mapSWnd;
	
	//Script = MinimapWnd(GetScript("MinimapWnd"));
	//mapSWnd = GetWindowHandle( "MinimapWnd" );

	idx = lstQuest.GetSelectedIndex();
	if (idx>-1)
	{
		lstQuest.GetRec(idx, record);
		QuestID = int(record.nReserved1);
	}
	if (QuestID > 0)
	{
		questName = class'UIDATA_QUEST'.static.GetQuestName(QuestID, 1);
		NpcID = class'UIDATA_QUEST'.static.GetStartNPCID(QuestID, 1);
		strTargetName = class'UIDATA_NPC'.static.GetNPCName(NpcID);
		vTargetPos = class'UIDATA_QUEST'.static.GetStartNPCLoc(QuestID, 1);
		//Debug("QuestID=" $ QuestID);
		//Debug("strTargetName=" $ strTargetName);
		//Debug("vTargetPos.x=" $ vTargetPos.x);
		//Debug("vTargetPos.y=" $ vTargetPos.y);
		//Debug("vTargetPos.z=" $ vTargetPos.z);

		if (vTargetPos.x == 0 && vTargetPos.y == 0 && vTargetPos.z == 0)
		{
			getInstanceL2Util().showGfxScreenMessage( GetSystemMessage(5205));
			getInstanceL2Util().HideGFxMiniMapSelectedPin(getInstanceL2Util().MapPinType.PIN_YELLOW);
		//	 miniMapWndScript.hideYellowPin();
		}
		
		if (Len(strTargetName)>0)
		{
			getInstanceL2Util().ShowGFxMiniMapSelectedPin(getInstanceL2Util().MapPinType.PIN_YELLOW, vTargetPos, strTargetName, questName);
			// End:0x1AD
			if(class'UIAPI_WINDOW'.static.IsShowWindow("MiniMapGfxWnd"))
			{
				class'UIAPI_WINDOW'.static.ShowWindow("MiniMapGfxWnd");
			}
			//class'QuestAPI'.static.SetQuestTargetInfo(true, true, false, strTargetName, vTargetPos, QuestID, 1);

		//	miniMapWndScript.showYellowPin(vTargetPos, strTargetName, questName);
			
		//	if (!mapSWnd.IsShowWindow())
		//	{
		//		mapSWnd.ShowWindow();
		//	}
			//Script.OnClickTargetButton();
		}
	}	
}

//// 시작 NPC 위치 보여주기 
//function showStartNpc (string npcName, Vector XYZ ) 
//{
//	//local Vector XYZ;
//	//local int x, y, z;
	
//	local MinimapCtrlHandle m_MiniMap;
//	local MinimapWnd mapScript ;
//	local MinimapRegionInfo regionInfoForMapIcon;

//	mapScript = MinimapWnd( GetScript( "MinimapWnd"));

//	m_MiniMap = GetMinimapCtrlHandle( "MinimapWnd.Minimap" );

//	if (!GetWindowHandle("MinimapWnd").IsShowWindow()) GetWindowHandle("MinimapWnd").ShowWindow();
	
//	// 위치 이동
//	mapScript.SetContinent(m_MiniMap.GetContinent(XYZ));	
//	class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", XYZ, false );
	
//	m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Etc, true);

//	regionInfoForMapIcon = makeRegionInfo (npcName, XYZ);
//	m_MiniMap.EraseRegionInfoCtrl(EMinimapRegionType.MRT_Etc, 3) ;
//	m_MiniMap.AddRegionInfoCtrl(regionInfoForMapIcon);	
//}

//function hideStartNpc ( ) 
//{
//	local MinimapCtrlHandle m_MiniMap;
//	m_MiniMap = GetMinimapCtrlHandle( "MinimapWnd.Minimap" );
//	m_MiniMap.EraseRegionInfoCtrl(EMinimapRegionType.MRT_Etc, 3) ;
//}

//// 시작 NPC 위치 아이콘 만들기
//function MinimapRegionInfo makeRegionInfo( string tooltipString,  Vector pLoc )
//{
//	local MinimapRegionInfo regionInfoForMapIcon;
//	local MinimapRegionIconData iconData;
//	local string toolTipParam;

//	toolTipParam = "";	
//	ParamAdd(toolTipParam, "tooltipString", tooltipString);
//	ParamAdd(toolTipParam, "Type", String ( int ( EMinimapRegionType.MRT_Etc )));	
//	regionInfoForMapIcon.strTooltip = toolTipParam;

//	regionInfoForMapIcon.eType = EMinimapRegionType.MRT_Etc;
//	regionInfoForMapIcon.nIndex = 3; // 유일 값이어야 한다.
//	regionInfoForMapIcon.strDesc = "아아아";

//	iconData.nWidth = 32;
//	iconData.nHeight = 32;
//	iconData.nWorldLocX = pLoc.x;// - iconData.nIconOffsetX; // 3197;  // - 3197 은 기획(조중곤), 16픽셀에 해당하는값.
//	iconData.nWorldLocY = pLoc.y;// - iconData.nIconOffsetY; // 3197;
//	iconData.nWorldLocZ = pLoc.z;
//	iconData.nIconOffsetX = -3;
//    iconData.nIconOffsetY = -20;

//	iconData.strIconNormal = "L2UI_CT1.Minimap.Minimap_DF_Icon_Pin_Campaign_Over";
//	iconData.strIconOver   = "L2UI_CT1.Minimap.Minimap_DF_Icon_Pin_Campaign";
//	iconData.strIconPushed = "L2UI_CT1.Minimap.Minimap_DF_Icon_Pin_Campaign_Over";		

//	regionInfoForMapIcon.iconData = IconData ;
//	return regionInfoForMapIcon ;
//}


function InitQuestTooltip()
{
	//Custom Tooltip
	local CustomTooltip TooltipInfo;
		
	TooltipInfo.DrawList.length = 6;
	
	TooltipInfo.DrawList[0].eType = DIT_TEXTURE;
	TooltipInfo.DrawList[0].u_nTextureWidth = 16;
	TooltipInfo.DrawList[0].u_nTextureHeight = 16;
	TooltipInfo.DrawList[0].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_1";
	
	TooltipInfo.DrawList[1].eType = DIT_TEXT;
	TooltipInfo.DrawList[1].nOffSetX = 5;
	TooltipInfo.DrawList[1].t_bDrawOneLine = true;
	TooltipInfo.DrawList[1].t_strText = GetSystemString( 861 );
	
	TooltipInfo.DrawList[2].eType = DIT_TEXTURE;
	TooltipInfo.DrawList[2].nOffSetY = 2;
	TooltipInfo.DrawList[2].u_nTextureWidth = 16;
	TooltipInfo.DrawList[2].u_nTextureHeight = 16;
	TooltipInfo.DrawList[2].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_2";
	TooltipInfo.DrawList[2].bLineBreak = true;
	
	TooltipInfo.DrawList[3].eType = DIT_TEXT;
	TooltipInfo.DrawList[3].nOffSetY = 2;
	TooltipInfo.DrawList[3].nOffSetX = 5;
	TooltipInfo.DrawList[3].t_bDrawOneLine = true;
	TooltipInfo.DrawList[3].t_strText = GetSystemString( 862 );

	TooltipInfo.DrawList[4].eType = DIT_TEXTURE;
	TooltipInfo.DrawList[4].nOffSetY = 2;
	TooltipInfo.DrawList[4].u_nTextureWidth = 16;
	TooltipInfo.DrawList[4].u_nTextureHeight = 16;
	TooltipInfo.DrawList[4].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_3";
	TooltipInfo.DrawList[4].bLineBreak = true;
	
	TooltipInfo.DrawList[5].eType = DIT_TEXT;
	TooltipInfo.DrawList[5].nOffSetY = 2;
	TooltipInfo.DrawList[5].nOffSetX = 5;
	TooltipInfo.DrawList[5].t_bDrawOneLine = true;
	TooltipInfo.DrawList[5].t_strText = GetSystemString( 2788 ); // "일일퀘스트"
	
	QuestTooltip.SetTooltipCustomType(TooltipInfo);
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "QuestListWnd" ).HideWindow();
}

defaultproperties
{
}
