//------------------------------------------------------------------------------------------------------------------------------------------
//    
//    월드맵 ( 리뉴얼 ) 2016-04, 확장 맵을 삭제 하고 통합
//
//
// ex)
//마검 혈검 빌드 명령어, 적 몬스터 타겟을 하고, 마검, 혈검을 몬스터에 심어두고, 죽이면 검이 떨어진다.
//give_cursed_weapon 8190
//give_cursed_weapon 8689
//
// 삭제
//cursed_weapon_delete 8190
//cursed_weapon_delete 8689
//------------------------------------------------------------------------------------------------------------------------------------------

class MinimapWnd extends UICommonAPI;
/**
const OTHER_HIGHLIGHT_ICON_INDEX = 100;
const QUEST_START_NPC_ICON_INDEX = 3;

const REGIONINFO_OFFSETX = 225;
const REGIONINFO_OFFSETY = 400;
const TIMER_ID = 225;
const TIMER_DELAY = 1500;

// 맵 서버 정보
struct CursedWeapon
{
	var bool bDrop;  // 마검, 혈검만 사용

	var string name;
	var int npcID;
	var int itemClassID;
	var int isowned;

	var int x;
	var int y;
	var int z;

	var INT64  fixedAdena;
	var INT64  variableAdena;

	// 서버 정보 타입
	var int nServerInfoType;

	var Vector loc;
	var string eventParam;
};


var string m_WindowName;
var int m_PartyMemberCount;
var int m_PartyLocIndex;
var int isNoShowMissionWindow;
var bool m_AdjustCursedLoc;

var bool m_bShowCurrentLocation;	// 현재위치 보여줄것인가를 기ㅕㅑ4억하는 변수
var bool m_bShowGameTime;			// 현재시간 보여줄것인가를 기억하는 변수
//var bool bHaveItem;					//아이템 소지여부
var bool bMiniMapDisabled;			//미니맵 사용 불가 세팅
var bool m_bExpandState;
var Vector BlockedLoc1;
var Vector BlockedLoc2;

var int FortressID;
var int SiegeStatus;
var int TotalBarrackCnt;
var int GlobalCurFortressID;
var int G_ZoneID;
var int G_ZoneID2;
//var bool GlobalCurFortressStatus;
var string m_combocursedName;

var int m_CurContinent;

var int CurrentLayer;               //ldw 테스트 현재 위치 층 인자
var int TotalLayers;                //ldw 테스트 미내맵에 보여 지는 맵이 다층일 경우 총 층 수

//var int TUTORIALQUEST[5];           //LDW 튜토리얼 퀘스트 정보 저장 
//var string TUTORIALQUEST_NPC_Name;  //LDW 튜토리얼 퀘스트 NPC 1202 테스트 후 한달 내 삭제 요망
//var string TutorialQuestParam;    //ldw 튜토리얼 퀘스트 1202 테스트 후 한달 내 삭제 요망

var WindowHandle 	me;
var WindowHandle 	m_MinimapMissionWnd;

var ItemWindowHandle	m_questItem;
var MinimapCtrlHandle 	m_MiniMap;

var ButtonHandle 	ReduceButton;

var TabHandle 		m_MapSelectTab;

//var Array<int> loc_fortress;
//var Array<int> loc_component;
//var Array<int> loc_sysstr;
//var Array<int> loc_xloc;
//var Array<int> loc_yloc;

//var array<int> g_CastleID;
//var array<int> agitid1;
//var array<int> agitid2;
//var array<int> agitid3;

// 서버 정보, 버튼
var ButtonHandle ServerInfo01_Button;
var ButtonHandle ServerInfo02_Button;
var ButtonHandle ServerInfo03_Button;
var ButtonHandle ServerInfo04_Button;

var ButtonHandle ServerInfo05_Button;
var ButtonHandle ServerInfo06_Button;


// 서버 정보를 각 타입에 따라서 하나씩 자리를 만들어 놓는다. 7개 타입의 서버 정보가 있으니.. 7개로..
var array<MapServerInfo> serverInfoArray;

//var WindowHandle 	MiniMapDrawerWnd;

///ldw 추가 
var Vector	QuestLocation;

// 씨앗 정보를 요청 한 뒤 타이머 함수 ~ldw
var int DelayRequestSeedInfo;

//ldw 추가 씨앗 정보를 저장함( 잦은 서버 request 를 막음 ) 
var array<string> SeedDataforMap;

var TextureHandle TabBg_Line;

// 위치,nx, ny를 기억하기 위한 정보 
var Rect smallMapRect;

var MinimapMissionWnd MinimapMissionWndScript;

var bool bCompleteBaseElementShow;
var bool bIsTownMap;
var int  nTownMapZoneID;

var MinimapCtrlHandle TeleportBookMarkWnd_MiniMap;

// 마검, 혈검, 보물상자(마검), 보물상자(혈검), 총 4개 타입
var array<CursedWeapon> CursedWeaponArray;


function OnRegisterEvent()
{
	return;
	RegisterEvent( EV_ShowMinimap );
	RegisterEvent( EV_PartyMemberChanged );
	RegisterEvent( EV_MinimapAddTarget );
	RegisterEvent( EV_MinimapDeleteTarget );
	RegisterEvent( EV_MinimapDeleteAllTarget );
	RegisterEvent( EV_MinimapShowQuest );
	RegisterEvent( EV_MinimapHideQuest );
	RegisterEvent( EV_MinimapChangeZone );

	// 마검 혈검
	RegisterEvent( EV_MinimapCursedWeaponList );
	RegisterEvent( EV_MinimapCursedWeaponLocation );

	// 저주 받은 검, 보물상자 위치 
	RegisterEvent( EV_MinimapTreasureBoxLocation );



	// ZoneName 이 바뀌면 현재위치 업데이트 해야하므로
	RegisterEvent( EV_BeginShowZoneTitleWnd );		

	// 전체맵과 마을맵을 오갈때 들어 오는 이벤트
	RegisterEvent( EV_MinimapShowReduceBtn );
	RegisterEvent( EV_MinimapHideReduceBtn );

	RegisterEvent( EV_MinimapUpdateGameTime );
	RegisterEvent( EV_MinimapTravel );	
	RegisterEvent( EV_MinimapRegionInfoBtnClick );

	 RegisterEvent( EV_ShowFortressMapInfo );
	 RegisterEvent( EV_FortressMapBarrackInfo);
	 RegisterEvent( EV_ShowFortressSiegeInfo );

	RegisterEvent( EV_SystemMessage );	

	//ldw 테스트 다층 타워로 들어갔을 시
	RegisterEvent( EV_MinimapShowMultilayer ); 
	//ldw 테스트 다층 타워에서 나왔을 경우
	RegisterEvent( EV_MinimapCloseMultilayer );

	RegisterEvent( EV_GamingStateEnter );
	registerEvent( EV_ResolutionChanged);

	// 리뉴얼 작업 
	//
	// 공성 정보
	RegisterEvent(EV_AddCastleInfo);

	// 요새
	RegisterEvent(EV_AddFortressInfo);

	// 아지트
	RegisterEvent(EV_AddAgitSiegeInfo);	

	// 진멸, 크세르스 정보
	RegisterEvent( EV_ShowSeedMapInfo );

	// 차원 레이드, 차원 공성전 진행 정보
	RegisterEvent( EV_RaidServerInfo );

	// 경매 정보
	RegisterEvent( EV_ItemAuctionStatus );

	// 클라쪽에 확인 결과 사용 안한다함.
	//ldw 튜토리얼 퀘스트 시작 이벤트 리전 데이타 지우기 이벤트로 인해 여기에 이벤트 설치. 데이타 지우기 이벤트 후 항시 퀘스트 튜토리얼을 검사 하고 나타내야 함. 확장 판은 한번 나타내고 지우면 됨.
	//RegisterEvent( EV_NotifyTutorialQuest ); 
	//RegisterEvent( EV_ClearTutorialQuest ); //ldw 튜토리얼 종료 이벤트

	//존네임 관련 리세팅
	RegisterEvent( EV_NeedResetUIData );

	RegisterEvent( EV_FactionInfo );

	RegisterEvent( EV_Restart );


	// http://wallis-devsub/redmine/issues/3707
	// 위치 알림 화살표(TargetDirectionIcon) 클릭 시.. 
	RegisterEvent( EV_MinimapAdjustViewLocation );


	//RegisterEvent( EV_Test_2 );

	RegisterEvent( EV_GameStart );


	
	// RegisterEvent( EV_ShowCursedBarrierInfo );


	// RegisterEvent( EV_ShowPrisonOfSoulDialogBox );	
}

// 신규, 블러드 서버
function initByServer()
{
	if (IsBloodyServer())
	{
		// 월드 정보 버튼 숨김 
		GetButtonHandle("MinimapWnd.OpenGuideWnd").HideWindow();
	}
	else 
	{
		GetButtonHandle("MinimapWnd.OpenGuideWnd").ShowWindow();
	}
}

function OnLoad()
{
	local Color txtVarCurLocColor;//ldw txtVarCurLoc 색상 지정
	return;
	SetClosingOnESC();

	MinimapMissionWndScript = MinimapMissionWnd(GetScript("MinimapMissionWnd"));

	// 하드코딩 데이타 로딩 (제발 스크립트로 빼길..)
	//SetCastleLocData();

	// 하드 코딩된 Array 데이터 읽기 (onLoad에서 하면 될듯..)
	//GetLocData();

	//MiniMapDrawerWnd = GetWindowHandle( "MiniMapDrawerWnd" );
	me = GetWindowHandle( "MinimapWnd" );

	m_MinimapMissionWnd = GetWindowHandle( "MinimapMissionWnd" );
	m_questItem = GetItemWindowHandle("InventoryWnd.QuestItem");

	m_MiniMap = GetMinimapCtrlHandle( "MinimapWnd.Minimap" );

	///Btn_Refresh = GetButtonHandle("MinimapWnd.Btn_Refresh");
	ReduceButton = GetButtonHandle( "MinimapWnd.btnReduce");
	m_MapSelectTab = GetTabHandle("MiniMapWnd.MapSelectTab");

	//ListTrackItem2 = 	GetListCtrlHandle("MiniMapDrawerWnd.ListTrackItem2"); 
	//CleftCurTriggerWnd = GetWindowHandle("CleftCurTriggerWnd");		

	TabBg_Line = GetTextureHandle( "MiniMapWnd.TabBg_Line" );

	// 서버 버튼
	ServerInfo01_Button = GetButtonHandle("MiniMapWnd.ServerInfo01_Button");
	ServerInfo02_Button = GetButtonHandle("MiniMapWnd.ServerInfo02_Button");
	ServerInfo03_Button = GetButtonHandle("MiniMapWnd.ServerInfo03_Button");
	ServerInfo04_Button = GetButtonHandle("MiniMapWnd.ServerInfo04_Button");
	ServerInfo05_Button = GetButtonHandle("MiniMapWnd.ServerInfo05_Button");
	ServerInfo06_Button = GetButtonHandle("MiniMapWnd.ServerInfo06_Button");


	TeleportBookMarkWnd_MiniMap = GetMinimapCtrlHandle ( "TeleportBookMarkWnd.Minimap" );

	m_PartyLocIndex = -1;
	m_PartyMemberCount = GetPartyMemberCount();
	
	m_AdjustCursedLoc = false;
	//m_bShowSSQType=true;
	m_bShowCurrentLocation=true;
	m_bShowGameTime=true;
	//m_bExpandState=false;
	//GlobalCurFortressStatus=false;
	
	// 헬바운드 맵 확대 방지. 
	BlockedLoc1.x = -32768f;
	BlockedLoc1.y = 32768f;
	BlockedLoc2.x = 229376f;
	BlockedLoc2.y = 262144f;
	bMiniMapDisabled = true;

	// ini 초기화(한번만 읽도록..)
	isNoShowMissionWindow = -1;

	//DrawCleftStatus();
	
	txtVarCurLocColor.R = 254;//ldw 현재 위치 색상
	txtVarCurLocColor.G = 243;
	txtVarCurLocColor.B = 124;

	class'UIAPI_TEXTBOX'.static.SetTextColor("Minimapwnd.txtVarCurLoc",txtVarCurLocColor);//ldw 현재 위치 텍스트 색상 교체

	// 마검 혈검,보물상자 4개
	CursedWeaponArray.Length = 4;

	initServerInfoArray();
	initServerButton();
}

//---------------------------------------------------------------------------------------------------------------------------------------
// OnEvent
//---------------------------------------------------------------------------------------------------------------------------------------
function OnEvent( int a_EventID, String a_Param )
{	
	//Debug( "OnEvent" @ a_EventID);
	switch( a_EventID )
	{			
		case EV_GameStart :
			initByServer();
			initCursedWeaponArray();
			class'UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon( "MinimapWnd.Minimap");			

			break;
		case EV_BeginShowZoneTitleWnd: //존 네임이 바뀔 때			
			//Debug("minimap" @ "EV_BeginShowZoneTitleWnd" @ a_Param );
			HandleZoneTitle();
			SetCurrentLocation();
			G_ZoneID2 = GetCurrentZoneID();
			break;

		case EV_MinimapRegionInfoBtnClick:	    //??????
			//Debug("minimap" @ "EV_MinimapRegionInfoBtnClick" @ a_Param );
			HandleDungeonMapRefresh(a_Param);
			break;

		case EV_ShowMinimap:
			//Debug("minimap" @ "EV_ShowMinimap" @ a_Param );//다층 타운 맵
			//Debug("EV_ShowMinimap");//ldw 다층타운맵
			//CloseMultilayer();//ldw 다층타운맵 콤보 박스 닫고 시작 하기
			G_ZoneID2 = GetCurrentZoneID();
			HandleShowMinimap( a_Param );
			break;

		case EV_PartyMemberChanged:             //파티 맴버가 바뀔 때.
			//Debug("minimap" @ "EV_PartyMemberChanged" @ a_Param );			
			HandlePartyMemberChanged( a_Param );
			break;

		case EV_MinimapAddTarget:               //미니맵에 타겟이 더해 질 때.
			//Debug("minimap" @ "EV_MinimapAddTarget" @ a_Param );
			HandleMinimapAddTarget( a_Param );
			break;

		case EV_MinimapDeleteTarget:            //미니맵에 타겟이 삭제 될 때.	
			//Debug("minimap" @ "EV_MinimapDeleteTarget" @ a_Param );
			HandleMinimapDeleteTarget( a_Param );
			break;
		case EV_MinimapDeleteAllTarget:         //미니맵에 타겟이 모두 삭제 될 때.					
			//Debug("minimap" @ "EV_MinimapDeleteAllTarget" @ a_Param );
			HandleMinimapDeleteAllTarget();
			break;

		//미니맵 퀘스트 보기;
		case EV_MinimapShowQuest:		        
			//Debug("minimap" @ "EV_MinimapShowQuest" @ a_Param );
			HandleMinimapShowQuest();
			break;

		//미니맵 퀘스트 숨기기.
		case EV_MinimapHideQuest:	            
			//Debug("minimap" @ "EV_MinimapHideQuest" @ a_Param );
			HandleMinimapHideQuest();
			break;

		//미니맵 존 바뀔 때.			
		case EV_MinimapChangeZone :             
			AdjustMapToPlayerPosition( true );
			G_ZoneID2 = GetCurrentZoneID();
			ParamAdd(a_Param, "ZoneID", String(G_ZoneID2));
			//ExecuteFortressSiegeStatus(a_Param);			
			Class'MiniMapAPI'.static.RequestSeedPhase();
			break;

		//미니맵 저주 받은 무기 리스트, 추적UI가 사라지면서 사용 안함(월드맵 리뉴얼 2016-04)
		case EV_MinimapCursedweaponList :       
			Debug("minimap" @ "EV_MinimapCursedweaponList" @ a_Param );
			//HandleCursedWeaponList(a_Param);
			// 사용 안함.
			
			break;

		// 저주 받은검 보물상자 위치  // 11110
		case EV_MinimapTreasureBoxLocation :  
			Debug("minimap" @ "EV_MinimapTreasureBoxLocation" @ a_Param );
			HandleCursedWeaponLoctaion(a_Param, true);
			break;


		//미니맵 저주 받은 무기 위치
		case EV_MinimapCursedweaponLocation :   
			Debug("minimap" @ "EV_MinimapCursedweaponLocation" @ a_Param );
			HandleCursedWeaponLoctaion(a_Param, false) ;
			break;

		//타운 맵으로			
		case EV_MinimapShowReduceBtn :          
			if (a_Param != "") ParseInt(a_Param,"ZoneID", nTownMapZoneID);
			else nTownMapZoneID = 0;
			bIsTownMap = true;
			//nTownMapZoneID = G_ZoneID2;
			////ldw 맵 축소	
			
			ReduceButton.ShowWindow();
			//ExecuteFortressSiegeStatus(a_Param);
			showAllRegionIcon(false);
			setDirIconDest();
			//Debug("--> 타운 맵으로 EV_MinimapShowReduceBtn" @ a_Param);
			//Debug("nTownMapZoneID" @nTownMapZoneID);
			
			break;

		//월드 맵으로
		case EV_MinimapHideReduceBtn :    
			//ParseInt(a_Param,"ZoneID",nTownMapZoneID);
			bIsTownMap = false;
			ReduceButton.HideWindow();
			//m_MiniMap.EraseAllRegionInfo();
			showAllRegionIcon(true);
			setDirIconDest();	
			//DrawSeedMapInfo();
			//Debug("--> 월드 맵으로 EV_MinimapHideReduceBtn" @ a_Param);
			//Debug("nTownMapZoneID" @nTownMapZoneID);
			
			break;

		//게임 시간 갱신 시간 텍스트만 바꿔 주며, 다른 이벤트에 영향이 없음.
		case EV_MinimapUpdateGameTime :         
			if(m_bShowGameTime)
			{
				HandleUpdateGameTime(a_Param);
				//setDirIconDest();
			}
			break;

		//미니맵 여행?
		case EV_MinimapTravel:                  
			//Debug("minimap" @ "EV_MinimapTravel" @ a_Param );
			//Debug("EV_MinimapHideReduceBtn" @ a_Param);
			HandleMinimapTravel( a_Param );
			break;

		// 요새 맵 정보
		case EV_ShowFortressMapInfo:            
			//Debug("minimap" @ "EV_ShowFortressMapInfo" @ a_Param );
			//	HandleShowFortressMapInfo(a_Param);
			
			break;

 		// 요새 건물 정보
		case EV_FortressMapBarrackInfo:         
			//Debug("minimap" @ "EV_FortressMapBarrackInfo" @ a_Param );
		//	HandleFortressMapBarrackInfo(a_Param);
			break;

		//요새전
		case EV_ShowFortressSiegeInfo:          
			//Debug("minimap" @ "EV_ShowFortressSiegeInfo" @ a_Param );
		//	GlobalCurFortressStatus = true;
		//	ParseInt( a_Param, "FortressID", GlobalCurFortressID);			
			break;

		//시스템 메시지
		case EV_SystemMessage:                  
			//Debug("minimap" @ "EV_SystemMessage" @ a_Param );
			//To update Fortress Information Data on System Message Update
			//if (me.IsShowWindow()) HandleChatmessage(a_Param);
			//break;

		// 엔터 스테이트
		case EV_GamingStateEnter:               
			//Debug("minimap" @ "EV_GamingStateEnter" @ a_Param );
			//RequestAllFortressInfo(); //ldw  원래 onLoad에 있던 함수.

			SiegeStatus = 0;
			FortressID =0;
			TotalBarrackCnt =0;
			GlobalCurFortressID = 0;
			G_ZoneID = 0;
			G_ZoneID2 = 0;
			//GlobalCurFortressStatus = false;
			break;

		case EV_MinimapShowMultilayer:          //ldw 테스트 다층맵 지역으로 들어왔을 때 콤보 박스
			//Debug("minimap" @ "EV_MinimapShowMultilayer" @ a_Param );
			ShowMultilayer(a_param);
			break;

		case EV_MinimapCloseMultilayer:         //ldw 테스트 다층맵 다층맵에서 빠져 나갈 때 호출 되는 이벤트
			//Debug("minimap" @ "EV_MinimapCloseMultilayer" @ a_Param );
			CloseMultilayer();
			break;

		// 클라쪽에서 쏴주는 부분이 없다 하여 안쓰는 걸로 보고 주석 처리 
		//case EV_NotifyTutorialQuest:            //ldw 튜토리얼 보임
		//	//Debug("minimap" @ "EV_NotifyTutorialQuest" @ a_Param );			
		//	OnNotifyTutorialQuest(a_Param);
		//	break;

		//case EV_ClearTutorialQuest:             //ldw 튜토리얼 삭제
		//	// Debug("minimap" @ "EV_ClearTutorialQuest" @ a_Param );			
		//	OnClearTutorialQuest();
		//	break;

		case EV_NeedResetUIData:
			class'UIAPI_MINIMAPCTRL'.static.ResetMinimapData( "MinimapWnd.Minimap" );
			checkClassicForm();			
			break;

		case EV_ResolutionChanged:
			// 큰 사이즈 맵인 경우에는 해상도에 따른 리사이징 수행
			if (IsExpandState()) setMapSize(true);
			break;

		// 공성 정보 3150
		case EV_AddCastleInfo:
			LoadCastleInfo(a_Param);
			break;

		// 요새 정보
		case EV_AddFortressInfo :
			LoadFortressInfo(a_Param);
			break;

		// 아지트 정보
		case EV_AddAgitSiegeInfo :
			LoadAgitSiegeInfo(a_Param);
			break;

		//진멸의 씨앗 정보를 받음 4200
		case EV_ShowSeedMapInfo:  
			//Debug("minimap" @ "EV_ShowSeedMapInfo" );						
			HandleSeedMapInfo(a_Param);
			break;

		// 차원 레이드, 차원 공성전 진행 정보,  10182
		case EV_RaidServerInfo :
			LoadRaidServerInfo(a_Param);
			break;

		// 경매 정보
		case EV_ItemAuctionStatus :
			LoadItemAuctionStatus(a_Param);
			break;

		// 세력 정보
		case EV_FactionInfo :
			loadFactionInfo(a_Param);
			break;

		case EV_MinimapAdjustViewLocation :
			minimapAdjustViewLocationProcess(a_Param);
			break;

		case EV_Restart :
			class'UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon( "MinimapWnd.Minimap");
			isNoShowMissionWindow = -1; // ini 한번만 읽도록..
			resetMapData();
			initCursedWeaponArray();
			break;

		//case EV_Test_2 :
		//	testCode(a_Param);
		//	break;
	}
}

function minimapAdjustViewLocationProcess(string param)
{
	local int x, y, z;
	local Vector loc;

	Debug("param" @ param);

	ParseInt(Param, "LocX", x);  
	ParseInt(Param, "LocY", y);
	ParseInt(Param, "LocZ", z);

	loc = setVector(x, y, z);

	SetLocContinent(loc);
	class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", loc, true);
}


function testCode(string param)
{
	local int x, y, z;
	local Vector loc;


	ParseInt(Param, "x", x);  
	ParseInt(Param, "y", y);
	ParseInt(Param, "z", z);
	loc = setVector(x, y, z);

	SetLocContinent(loc);
	class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", loc, true);
}

// 세력 정보, 
function loadFactionInfo(string a_Param)
{
	local array<L2UserFactionUIInfo>  factionInfoListArray;
	local MinimapRegionInfo regionInfo;
	local UserInfo pUserInfo;	
	//local int i;

	//local L2FactionUIData factionData;

	//local MinimapRegionIconData iconData;

	if (Me.IsShowWindow())
	{
		GetPlayerInfo(pUserInfo);

		//// 서버에서 알아서 보낼때..
		//if(RequestType == EFactionRequsetType.FIRT_NONE)
		//{
			
		//}	//factionInfoListArray.Remove(0, factionInfoListArray.Length);
		//GetUserFactionInfoList(pUserInfo.nID, factionInfoListArray);

		//Debug("####  세력 정보 EV_FactionInfo a_Param:" @ a_Param);	
		//Debug("factionInfoListArray" @ factionInfoListArray.Length);

		// 맵 아이콘 요소를 한번이라도 그렸어야 업데이트 한다.
		if (bCompleteBaseElementShow)
			drawFactionMapIcon(true);
		else
			drawFactionMapIcon();
	}
}

// 최초 한번
function drawFactionMapIcon(optional bool bUseUpdate)
{
	local array<L2UserFactionUIInfo>  factionInfoListArray;
	local MinimapRegionInfo regionInfo, emptyRegionInfo;
	local UserInfo pUserInfo;	
	local int i;

	local L2FactionUIData factionData;

	local MinimapRegionIconData iconData;

	GetPlayerInfo(pUserInfo);

	GetUserFactionInfoList(pUserInfo.nID, factionInfoListArray);

	for(i = 0; i < factionInfoListArray.Length; i++)
	{   
		regionInfo = emptyRegionInfo;
		//Debug("factionInfoListArray[i].nFactionID:" @ factionInfoListArray[i].nFactionID);
		GetFactionData(factionInfoListArray[i].nFactionID, factionData);

		//Debug("factionInfoListArray[i].nRegionID:" @ factionData.nRegionID);
		//Debug("factionInfoListArray[i].nRegionID:" @ factionData.strName);
		// var array<string> arrFactionAreaName;

		ParamAdd(regionInfo.strTooltip, "Type", String(EMinimapRegionType.MRT_Faction));           // 세력 타입
		ParamAdd(regionInfo.strTooltip, "nFactionID", String(factionInfoListArray[i].nFactionID));  
		ParamAdd(regionInfo.strTooltip, "nFactionLevel", String(factionInfoListArray[i].nFactionLevel));  

		regionInfo.nIndex = factionData.nRegionID;
		regionInfo.eType = EMinimapRegionType.MRT_Faction;
		regionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;

		if(GetMinimapRegionIconData(factionData.nRegionID, iconData))
		{
			regionInfo.IconData = iconData;

			regionInfo.iconData.nIconOffsetX = -16;
			regionInfo.iconData.nIconOffsetY = -16;

			//Debug("strIconNormal: " @ iconData.strIconNormal);
			//Debug("nWorldLocX: " @ iconData.nWorldLocX);
			//Debug("nWorldLocY: " @ iconData.nWorldLocY);
			//Debug("nWorldLocZ: " @ iconData.nWorldLocZ);
			//Debug("nWidth: " @ iconData.nWidth);
			//Debug("nHeight: " @ iconData.nHeight);
			//Debug("strDescFontName: " @ iconData.strDescFontName);
		}
		
		addMapIcon(regionInfo, bUseUpdate);
	}
}


function resetMapData()
{
	Debug("resetMapData");
	bCompleteBaseElementShow = false;

	initServerInfoArray();
	
	m_MiniMap.EraseAllRegionInfo();

	TeleportBookMarkWnd_MiniMap.EraseAllRegionInfo();
}

//-------------------------------------------------------------------------
// 경매 정보
//-------------------------------------------------------------------------
function LoadItemAuctionStatus ( string Param )
{
	local Vector loc;
	local int nState;
	local bool bUse;

	ParseInt(Param, "State", nState);  // 0: 대기중, 1: 진행중

	// 경매 진행 중이면 경매 위치 좌표 받기
	if (nState > 0)
	{
		// 경매 버튼 보이게 하고
		bUse = true; 
		// 경매 위치
		ParseFloat(Param, "WorldLocX", loc.x);
		ParseFloat(Param, "WorldLocY", loc.y);
		ParseFloat(Param, "WorldLocZ", loc.z);
		Debug("클릭!!!");
	}
	
	//Debug("bUse" @ bUse);
	Debug("LoadItemAuctionStatus " @ Param);
	setServerParse(MapServerInfoType.AUCTION, Param, bUse, loc);
}

//-------------------------------------------------------------------------
// 차원 레이드, 차원 공성전 진행 정보
//-------------------------------------------------------------------------
function LoadRaidServerInfo ( string Param )
{
	local int nWorldRaidState, nWorldCastleSiegeState;
	local bool bUse;

	Debug("LoadRaidServerInfo Param: " @Param);

	// "WorldRaidState" : 0:평화상태, 1:진행중
	// "WorldCastleSiegeState" : 0:평화상태, 1:진행중
	ParseInt( Param, "WorldRaidState"       , nWorldRaidState);
	ParseInt( Param, "WorldCastleSiegeState", nWorldCastleSiegeState);

	// 차원 레이드
	if (nWorldRaidState > 0) bUse = true;
	else bUse = false;
	setServerParse(MapServerInfoType.RAID_DIMENSION, Param, bUse);

	// 차원 공성전, 진행 여부에 따라 서버 버튼 활성화
	if (nWorldCastleSiegeState > 0) bUse = true;
	else bUse = false;
	setServerParse(MapServerInfoType.SIEGEWARFARE_DIMENSION, Param, bUse);	
}

//-------------------------------------------------------------------------
// 아지트 정보 정보
//-------------------------------------------------------------------------
function LoadAgitSiegeInfo( string Param)
{
	local MinimapRegionInfo regionInfo, emptyRegionInfo;
	local MinimapRegionIconData iconData;
	local int nRegionID;

	local string OwnerClanName, OwnerClanMasterName;
	
	local string OwnerClanNameToolTip;

	local string NextSiegeYear;
	local string NextSiegeMonth;
	local string NextSiegeDay;
	local string NextSiegeHour;
	local string NextSiegeMin;
	local string NextSiegeSec;
	
	local int i;
	local int agitCount, agitID;//, agitGetType;

	local string NextSiegeTime, agitName;

	//Debug("----------->>> EV_AddCastleInfo  : Param"@ Param);	
	//Debug("EV_AddAgitSiegeInfo Param :" @ Param);
	
	ParseInt( Param, "AgitCount", agitCount);

	for(i = 0; i < agitCount; i++)
	{
		regionInfo = emptyRegionInfo;

		ParseInt( Param, "AgitID" $ i, agitID);

		// 다음 공성일 
		//연도에다가는 무조건 1900을 더해야 한다. 
		ParseString( Param, "NextSiegeYear"   $ i, NextSiegeYear);
		ParseString( Param, "NextSiegeMonth"  $ i, NextSiegeMonth);
		ParseString( Param, "NextSiegeDay"    $ i, NextSiegeDay);
		ParseString( Param, "NextSiegeHour"   $ i, NextSiegeHour);
		ParseString( Param, "NextSiegeMin"    $ i, NextSiegeMin);
		ParseString( Param, "NextSiegeSec"    $ i, NextSiegeSec);

		ParseString( Param, "OwnerClanName"       $ i, OwnerClanName);
		ParseString( Param, "OwnerClanMasterName" $ i, OwnerClanMasterName);

		//ParseInt( Param, "Type" $ i, agitGetType);      // 아트지 획득 경위
		//ParseInt( Param, "SiegeState" $ i, siegeState); // 0: 평화상태, 1:공성중

		nRegionID = GetCastleRegionID(agitID);

		agitName = GetCastleName(agitID);

		// Debug("agitID" @ agitID);
		// Debug("agitName" @ agitName);

		if (OwnerClanName == "")
		{
			OwnerClanName =  GetSystemString(27);           // 없음
			OwnerClanNameToolTip =  GetSystemMessage(2196); // 소유 혈맹 없음
		}
		else
		{
			// $s1혈맹 소유 중
			OwnerClanNameToolTip = MakeFullSystemMsg(GetSystemMessage(2197), OwnerClanName);
			OwnerClanName = OwnerClanName @ GetSystemString(439); // 혈맹
		}
		
		if (NextSiegeMonth == "0" && NextSiegeYear == "70" && NextSiegeDay == "1")
		{
			// 미정
			NextSiegeTime = GetSystemString(584);
		}
		else 
		{
			/// NextSiegeTotalTime 값이 없어서 일단 안함. 아마도 요청해서 해야 하지 않나 싶음.
			////branch EP1.0 2014-7-29 luciper3 - 러시아 요청으로 표시방식 변경 TTP #65769
			//if( Int(NextSiegeTotalTime) > 0 )
			//{
			//	NextSiegeTime = BR_ConvertTimeToStr(Int(NextSiegeTotalTime), 0);
			//}
			//else
			//{
			//	NextSiegeMonth = String(Int(NextSiegeMonth)+1);
 			//	NextSiegeTime = MakeFullSystemMsg(GetSystemMessage(2203), NextSiegeMonth, NextSiegeDay);
			//}

			NextSiegeMonth = String(Int(NextSiegeMonth) + 1);
			NextSiegeTime = MakeFullSystemMsg(GetSystemMessage(2203), NextSiegeMonth, NextSiegeDay) $ ", " $ MakeFullSystemMsg(GetSystemMessage(2204), NextSiegeHour);
			//11월 10일, 4시
		}

		// Debug("아지트 :::::: nRegionID" @ nRegionID);

		// 아지트 이름
		ParamAdd(regionInfo.strTooltip, "AgitName", agitName);                               // 아지트 이름
		ParamAdd(regionInfo.strTooltip, "Type", String(EMinimapRegionType.MRT_Agit));        // 아지트 타입
		ParamAdd(regionInfo.strTooltip, "OwnerClanName", OwnerClanName);                     // 소유 혈맹명
		ParamAdd(regionInfo.strTooltip, "OwnerClanMasterName", OwnerClanMasterName);         // 혈맹 소유주
		ParamAdd(regionInfo.strTooltip, "NextSiegeTime", NextSiegeTime);                     // 다음 아지트 전
		ParamAdd(regionInfo.strTooltip, "LocationName", GetCastleLocationName(agitID));      // 소속 영지
		
		regionInfo.nIndex = nRegionID;

		regionInfo.eType = EMinimapRegionType.MRT_Agit;
		regionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;

		// 월드맵 아이콘, 위치 정보
		if(GetMinimapRegionIconData(nRegionID, iconData))
		{
			regionInfo.IconData = iconData;
		}

		//m_MiniMap.UpdateRegionInfoCtrl(regionInfo);
		if(nRegionID > 0) addMapIcon(regionInfo, true);
	}
}	

//-------------------------------------------------------------------------
// 요새 정보 정보
//-------------------------------------------------------------------------
function LoadFortressInfo( string Param)
{
	local MinimapRegionInfo regionInfo;
	local MinimapRegionIconData iconData;
	local int nRegionID;

	local string tempStr;

	//요새전 데이터
	local int FortressID;
	local string OwnerClanName;
	//local string OwnerClanNameToolTip;
	local int SiegeState;
	local int LastOwndedTime;

	//local Vector loc;
	//local string DataforMap;
	local string CastleName;
	local string Statcur;
	//local int ZoneID;
	local string iconname;
	
	local int Hour;
	local int Date;
	local int Min;
	//local int Sec;
	
	local string DateTotal;
	
	//Debug("EV_AddFortressInfo Param: " @ Param);
	Hour = 0;
	Date = 0;
	Min = 0;
	
	//요새 아이디
	ParseInt( Param, "FortressID", FortressID);
	//요새  이름
	CastleName = GetCastleName(FortressID);
	//소유혈맹
	ParseString( Param, "OwnerClanName", OwnerClanName);
	//요새전 진행
	ParseInt( Param, "SiegeStatae", SiegeState);
	//해당혈맹의 마지막 소유현황
	ParseInt( Param, "LastOwnedTime", LastOwndedTime);

	nRegionID = GetCastleRegionID(FortressID);

	//지형데이터아이디
	//ZoneID = g_CastleID[FortressID];	
	//Debug("요새 zoneID" @ZoneID);

	if (OwnerClanName == "")
		OwnerClanName = GetSystemString(27);
	else
		OwnerClanName = OwnerClanName @ GetSystemString(439);

	// 전쟁 상태
	if (SiegeState == 0)
	{
		Statcur = GetSystemString(894); // 평화상태
		iconname = "L2UI_CT1.ICON_DF_SIEGE_SHIELD";  // 현재 이것들을 사용 안함.. 써야 할거 같은데..
	} 
	else if(SiegeState == 1)
	{
		Statcur = GetSystemString(340); // 전쟁중
		iconname = "L2UI_CT1.ICON_DF_SIEGE_SWORD";
	}

	Min = (LastOwndedTime/60);
	Hour = (Min/60);
	Date = (Hour/24);
	
	//~ debug ("계산값" @ Min @ Hour @ Date );

	if (Min <60 && Min != 0)
	{
		DateTotal = String(Min) @ GetSystemString(1111);
	}
	else if (Hour <60 && Hour != 0)
	{
		DateTotal = String(Hour) @ GetSystemString(1110);
	}
	else if (Date != 0)
	{
		DateTotal = String(Date) @ GetSystemString(1109);
	}

	// 성 이름
	ParamAdd(regionInfo.strTooltip, "Type", String(EMinimapRegionType.MRT_Fortress));    // 요새 타입
	ParamAdd(regionInfo.strTooltip, "CastleName", CastleName);                           // 요새 이름 
	ParamAdd(regionInfo.strTooltip, "OwnerClanName", OwnerClanName);                     // 소유 혈맹명
	ParamAdd(regionInfo.strTooltip, "SiegeState", Statcur);                              // 평화 상태, 전쟁중
	ParamAdd(regionInfo.strTooltip, "LocationName", GetCastleLocationName(FortressID));  // 소속 영지
	
	ParamAdd(regionInfo.strTooltip, "DateTotal", DateTotal);                             // 점령 시간

	regionInfo.nIndex = nRegionID;//FortressID;

	regionInfo.eType = EMinimapRegionType.MRT_Fortress;
	regionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;
	// Debug("nRegionID: " @ nRegionID);

	// 월드맵 아이콘, 위치 정보
	if(GetMinimapRegionIconData(nRegionID, iconData))
	{
		regionInfo.IconData = iconData;
	}

	//m_MiniMap.UpdateRegionInfoCtrl(regionInfo);
	addMapIcon(regionInfo, true);
}	

//-------------------------------------------------------------------------
// 공성전 정보
//-------------------------------------------------------------------------
function LoadCastleInfo( string Param)
{
	//공성 데이터
	local int castleID;
	local string OwnerClanName;
	local string OwnerClanNameToolTip;
	local string TaxRate;
	local string NextSiegeTime;
	local string NextSiegeYear;
	local string NextSiegeMonth;
	local string NextSiegeDay;
	local string NextSiegeHour;
	local string NextSiegeMin;
	local string NextSiegeSec;
	local string NextSiegeTotalTime;
	
	local string CastleName;
	local int siegeState, castleType;

	local MinimapRegionInfo regionInfo;
	local MinimapRegionIconData iconData;
	local int nRegionID, huntingZoneIndex;
	local bool bUse;
	local Vector tVector, emptyVector;

	local string tempStr;

	// Debug("----------->>> EV_AddCastleInfo  : Param"@ Param);

	//성 아이디
	ParseInt( Param, "CastleID", castleID);
	//성 이름
	CastleName = GetCastleName(castleID);
	//소유혈맹
	ParseString( Param, "OwnerClanName", OwnerClanName);
	//세금정보
	ParseString( Param, "TaxRate", TaxRate);

	// 다음 공성일 
	//연도에다가는 무조건 1900을 더해야 한다. 
	ParseString( Param, "NextSiegeYear", NextSiegeYear);
	ParseString( Param, "NextSiegeMonth", NextSiegeMonth);
	ParseString( Param, "NextSiegeDay", NextSiegeDay);
	ParseString( Param, "NextSiegeHour", NextSiegeHour);
	ParseString( Param, "NextSiegeMin", NextSiegeMin);
	ParseString( Param, "NextSiegeSec", NextSiegeSec);

	ParseString( Param, "NextSiegeTime", NextSiegeTotalTime);	
	
	ParseInt( Param, "SiegeState", siegeState); // 0: 평화상태, 1:공성중
	ParseInt( Param, "CastleType", castleType); // 0: 없음, 1: 빛, 2: 어둠

	// Debug("----------->>> EV_AddCastleInfo  : Param"@ Param);
	// Debug("----------->>> CastleName  : "@ CastleName);

	//지형데이터아이디
	//ZoneID = g_CastleID[castleID];		
	
	if (OwnerClanName == "")
	{
		OwnerClanName =  GetSystemString(27);           // 없음
		OwnerClanNameToolTip =  GetSystemMessage(2196); // 소유 혈맹 없음
	}
	else
	{
		// $s1혈맹 소유 중
		OwnerClanNameToolTip = MakeFullSystemMsg(GetSystemMessage(2197), OwnerClanName);
		OwnerClanName = OwnerClanName @ GetSystemString(439); // 혈맹
	}
	
	if (NextSiegeMonth == "0" && NextSiegeYear == "70" && NextSiegeDay == "1")
	{
		// 미정
		NextSiegeTime = GetSystemString(584);
	}
	else 
	{
		//branch EP1.0 2014-7-29 luciper3 - 러시아 요청으로 표시방식 변경 TTP #65769
		if( Int(NextSiegeTotalTime) > 0 )
		{
			NextSiegeTime = BR_ConvertTimeToStr(Int(NextSiegeTotalTime), 0);
		}
		else
		{
			NextSiegeMonth = String(Int(NextSiegeMonth)+1);
 			NextSiegeTime = MakeFullSystemMsg(GetSystemMessage(2203), NextSiegeMonth, NextSiegeDay);
		}
		//end of branch
	}

	nRegionID = GetCastleRegionID(castleID);

	// 성 이름
	ParamAdd(regionInfo.strTooltip, "Type", String(EMinimapRegionType.MRT_Castle));  // 성 타입
	ParamAdd(regionInfo.strTooltip, "CastleName", CastleName);                        // 성이름 
	ParamAdd(regionInfo.strTooltip, "CastleID", String(castleID));                    // 성ID
	ParamAdd(regionInfo.strTooltip, "LocationName", GetCastleLocationName(castleID));   // 소속 영지

	
	
	ParamAdd(regionInfo.strTooltip, "OwnerClanNameToolTip", OwnerClanNameToolTip);    // $s1혈맹 소유 중
	ParamAdd(regionInfo.strTooltip, "OwnerClanName", OwnerClanName);                  // 소유 혈맹명
	ParamAdd(regionInfo.strTooltip, "NextSiegeTime", NextSiegeTime);                  // 다음 공성전 시간
	ParamAdd(regionInfo.strTooltip, "TaxRate", TaxRate $ "%");                        // 세금

	
	tempStr = "";
	if (siegeState == 0) 
	{
		bUse = false;
		tempStr = GetSystemString(894); // 0: 평화상태
	}
	else 
	{
		bUse = true;
		tempStr = GetSystemString(339); // 1: 공성 중
	}

	ParamAdd(regionInfo.strTooltip, "SiegeState", tempStr); // 평화상태, 공성중

	//if (castleType == 0) 
	//	tempStr = GetSystemString(7400); // 0: 없음
	tempStr = "";
	if (castleType == 1) 
		tempStr = GetSystemString(3519); // 1: 빛
	else if (castleType == 2) 
		tempStr = GetSystemString(3520); // 2: 어둠
	else
		tempStr = ""; // GetSystemString(7400); // 그외 : 없음
	
	ParamAdd(regionInfo.strTooltip, "CastleType", tempStr); // 0: 없음, 1: 빛, 2: 어둠

	regionInfo.eType = EMinimapRegionType.MRT_Castle;
	regionInfo.nIndex = nRegionID;//castleID;	
	regionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;
	regionInfo.strDesc = CastleName;
	//Debug("nRegionID: " @ nRegionID);

	tVector = emptyVector;

	// 월드맵 아이콘, 위치 정보
	if(GetMinimapRegionIconData(nRegionID, iconData))
	{
		regionInfo.IconData = iconData;
		//Debug("strIconNormal: " @ iconData.strIconNormal);
		//Debug("nWorldLocX: " @ iconData.nWorldLocX);
		//Debug("nWorldLocY: " @ iconData.nWorldLocY);
		//Debug("nWorldLocZ: " @ iconData.nWorldLocZ);
		//Debug("nWidth: " @ iconData.nWidth);
		//Debug("nHeight: " @ iconData.nHeight);
		//Debug("strDescFontName: " @ iconData.strDescFontName);

		tVector.x = iconData.nWorldLocX;
		tVector.y = iconData.nWorldLocY;
		tVector.z = iconData.nWorldLocZ;
		
	}

	// huntingZoneIndex = getHuntingZoneIndexByName(CastleName);

	// Debug("만든 성 툴팁" @ regionInfo.strTooltip);
	// Debug("성 nRegionID" @ nRegionID);

	//if(bCompleteBaseElementShow)
	//m_MiniMap.UpdateRegionInfoCtrl(regionInfo);

	addMapIcon(regionInfo, true);

	//else 
	//	m_MiniMap.AddRegionInfoCtrl(regionInfo);
	
	// 성 이름을 param으로 넣어서 추가 되도록 한다.
	setServerParse(MapServerInfoType.SIEGEWARFARE, CastleName, bUse, tVector, nRegionID);
}	

//// 클라 쪽에 문의 결과 사용안한다고 함. 
//function OnNotifyTutorialQuest(string a_Param)
//{
//	//ldw 튜토리얼 1202 테스트 후 주석 처리 부분 삭제 요망
//	// 5380     QuestID=1 QuestLevel=2 X=1 Y=2 Z=3
//	local int QuestID;
//	local int QuestLevel;
//	local int LocX;
//	local int LocY;
//	local int LocZ;

//	OnClearTutorialQuest(); //지난 정보를 지우고, 
	
//	ParseInt(a_Param, "QuestID", QuestID);
//	ParseInt(a_Param, "QuestLevel", QuestLevel);
//	ParseInt(a_Param, "X", LocX);
//	ParseInt(a_Param, "Y", LocY);
//	ParseInt(a_Param, "Z", LocZ);

//	m_MiniMap.RegisterQuestIcon(QuestID , LocX, LocY, LocZ, "QuestTutorial" );

//	TUTORIALQUEST[0] = QuestID;
//}

//function OnClearTutorialQuest()
//{
//	//ldw 튜토리얼 퀘스트 삭제.
//	//Debug("clearTutorialQuest");

//	m_MiniMap.EraseQuestIcon(TUTORIALQUEST[0]);
//	TUTORIALQUEST[0] = -1;
//}

function String currentWndName()
{
	local string mapName;
	mapName = "MinimapWnd";
	return mapName;
}

//ldw 다층맵 콤보박스 열기
function ShowMultilayer(string Param)
{
	local int i;
	local string ComboBoxName;
	local string ComboBoxShadowName;
	local string WndName;
	local string btnString_None;
	local string btnString_Down;
	local string btnString_Over;

	WndName= currentWndName();
	ComboBoxShadowName = WndName$".ComboBoxShadow";
	ComboBoxName = WndName$".FloorComboBox";

	class'UIAPI_WINDOW'.static.ShowWindow(ComboBoxName);
	class'UIAPI_WINDOW'.static.ShowWindow(ComboBoxShadowName);

	ParseInt(Param, "CurrentLayer",CurrentLayer);
	ParseInt(Param, "TotalLayers",TotalLayers);

	class'UIAPI_COMBOBOX'.static.Clear(ComboBoxName);

	for( i=1;i<=TotalLayers;i++)
	{
		class'UIAPI_COMBOBOX'.static.AddString( ComboBoxName,i $ GetSystemString(5081));
		class'UIAPI_COMBOBOX'.static.SetSelectedNum( ComboBoxName,CurrentLayer-1 );
	}

	btnString_None="L2ui_ct1.Minimap.Minimap_DF_Minusbtn_Purple";
	btnString_Down="L2ui_ct1.Minimap.Minimap_DF_Minusbtn_Purple_Down";
	btnString_Over="L2ui_ct1.Minimap.Minimap_DF_Minusbtn_Purple_Over";

	ReduceButton.SetTexture(btnString_None, btnString_Down, btnString_Over);

	//ReduceButton_Expand.SetTexture(btnString_None, btnString_Down, btnString_Over);
}

//ldw 테스트 다층맵 콤보박스 닫기
function CloseMultilayer()
{
	local string ComboBoxName;
	local string ComboBoxShadowName;
	local string WndName;
	local string btnString_None;
	local string btnString_Down;
	local string btnString_Over;

	WndName = currentWndName();
	ComboBoxShadowName = WndName $".ComboBoxShadow";
	ComboBoxName = WndName $ ".FloorComboBox";

	class'UIAPI_COMBOBOX'.static.Clear(ComboBoxName);
	class'UIAPI_WINDOW'.static.HideWindow(ComboBoxName);
	class'UIAPI_WINDOW'.static.HideWindow(ComboBoxShadowName);

	btnString_None="L2ui_ct1.Minimap.Minimap_df_Minusbtn_Blue";
	btnString_Down="L2ui_ct1.Minimap.Minimap_df_Minusbtn_Blue_Down";
	btnString_Over="L2ui_ct1.Minimap.Minimap_df_Minusbtn_Blue_Over";
	ReduceButton.SetTexture(btnString_None, btnString_Down, btnString_Over);
	//ReduceButton_Expand.SetTexture(btnString_None, btnString_Down, btnString_Over);
}

//function DrawSeedMapInfo ( ) 
//{
//	local int i ;	
//	local int index ;

//	//Debug("DrawSeedMapInfo" @ SeedDataforMap.Length @ SeedDataforMap[0]);
//	//Debug("DrawSeedMapInfo" @ i @ index);

//	//창이 보이지 않는 경우 
//	if ( !me.IsShowWindow() ) return ;
//	//그라시아 대륙이 아닌 경우 
//	if ( m_CurContinent != 1 ) return;	

//	//SeedDataforMap 정보가 없을 경우 
//	if ( SeedDataforMap.Length == 0 ) return ;
			
//	i = SeedDataforMap.Length - 1 ;	
//	parseInt ( SeedDataforMap[i], "Index",  index);	
//	m_MiniMap.EraseRegionInfo( index );	
//	m_MiniMap.AddRegionInfo(SeedDataforMap[i]);

//}


// 진멸의 씨앗 데이타 업데이트 전투 상태
// 진멸의 씨앗 전투 상태 : 시작, 도전, 진격, 정체 값을 받아서 아이콘 툴팁을 업데이트 시키는데 사용한다. 
function HandleSeedMapInfo(string Param)
{
	local int i;
	local int nSeedCount;

	local MinimapRegionInfo regionInfo;
	local MinimapRegionIconData iconData;	
	local string toolTipParam, huntingZoneName;
	local int huntingZoneID, huntingZoneIndex, SeedMessageNum;
	local bool bUse;
	local HuntingZoneUIData huntingZoneData;

	// debug ("진멸, 크세 Event Seed Info" @ Param);
	
	if ( getInstanceUIData().getIsClassicServer() ) return;

	ParseInt(param, "SeedCount", nSeedCount);

	for(i = 0; i < nSeedCount; i++)
	{
		ParseInt(param, "HuntingZoneID_" $ i, huntingZoneID);
		ParseInt(param, "SysMsgNo_" $ i, SeedMessageNum);

		if(class'UIDATA_HUNTINGZONE'.static.IsValidData(huntingZoneID) == false) continue;

		// 진멸의 씨앗은 파티형 사냥터
		regionInfo.eType  = EMinimapRegionType.MRT_HuntingZone_Base;

		//HuntingZoneName = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(huntingZoneID); 

		// 써도 되지만 인덱스 값이 헌팅존 ID와 늘 같다. 빈것도 하나의 배열 공간으로 잡아 놓았기 때문에..
		// 그래도 혹시 모르니 나둔다만 없이 그냥 헌팅존 ID를 헌팅존 인덱스로 써도 무방하다.
		//huntingZoneIndex = getHuntingZoneIndexByName(HuntingZoneName);

		//Debug("진멸 HuntingZoneName" @ HuntingZoneName);
		//Debug("진멸 index" @ huntingZoneIndex);
		//Debug("진멸 SeedMessage" @ SeedMessageNum);
		
		//if (huntingZoneIndex == -1) continue;

		// 진멸의 씨앗, 크세르스 동맹 연합기지
		if(huntingZoneID == 303 || huntingZoneID == 286)
		{
			class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(huntingZoneID, huntingZoneData);

			toolTipParam = "";
			ParamAdd(toolTipParam, "Type", String(regionInfo.eType));
			ParamAdd(toolTipParam, "Index", String(huntingZoneID));
			//ParamAdd(toolTipParam, "Index", String(huntingZoneIndex));
			ParamAdd(toolTipParam, "SeedMessage", GetSystemMessage(SeedMessageNum));

			

			regionInfo.nIndex = huntingZoneData.nRegionID; // huntingZoneIndex;

			regionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;
			regionInfo.strDesc = huntingZoneData.strName;

			regionInfo.strTooltip = toolTipParam;

			GetMinimapRegionIconData(huntingZoneData.nRegionID, iconData);
			regionInfo.IconData = iconData;

			// 헌팅존에 진멸의 씨앗은 포함되어 있어 창을 처음 열면 이미 그려져 있는 상황. 즉 업데이트만 하면됨.
			//m_MiniMap.UpdateRegionInfoCtrl(regionInfo);
			addMapIcon(regionInfo, true);
			
			// 크세르스 동맹 연합기지라면 서버 정보로 인식해서 버튼을 생성한다.
			if (huntingZoneID == 286)
			{
				bUse = false;
				// 크세르스 방어전 - 진행중 일때만 서버 정보 버튼을 켜준다.
				switch(SeedMessageNum)
				{
					case 4432 :
					//case 4433 :
					//case 4434 :
					//case 4435 : 
								bUse = true;
					            break;
				}
				// bUse = true;
				setServerParse(MapServerInfoType.DEFENSEWARFARE, GetSystemMessage(SeedMessageNum), bUse, huntingZoneData.nWorldLoc, huntingZoneData.nRegionID, SeedMessageNum);

				// Debug("크세 정보 저장 SeedMessageNum:" @ SeedMessageNum);
			}
		}
	}

	DelayRequestSeedInfo = 0;
}

//function HandleChatmessage( String param )
//{
//	local int SystemMsgIndex;
//	ParseInt ( param, "Index", SystemMsgIndex );
//	switch (SystemMsgIndex)
//	{
//		////요새전 시작 메시지가 왔을때 요새전 현황을 갱신받는다. 
//		//case 2090:
//		//	GlobalCurFortressStatus = true;
//		//	//if (ReduceButton_Expand.IsShowWindow() || ReduceButton.IsShowWindow())
//		//	if (ReduceButton.IsShowWindow())
//		//	{
//		//		ExecuteFortressSiegeStatus("");
//		//		//~ RequestFortressSiegeInfo();
//		//	}
//		//	//else if (!ReduceButton_Expand.IsShowWindow() || !ReduceButton.IsShowWindow())
//		//	else if (!ReduceButton.IsShowWindow())
//		//		RequestFortressSiegeInfo();
				
//		//break;
//		////요새전 주요 진행 상황중 리셋을 요청한다. 
//		//case 2164:
//		//case 2165:
//		//case 2166:
//		//	GlobalCurFortressStatus = true;
//		//	//if (ReduceButton_Expand.IsShowWindow() || ReduceButton.IsShowWindow())
//		//	if (ReduceButton.IsShowWindow())
//		//	{
//		//		ExecuteFortressSiegeStatus("");
//		//		//~ RequestFortressSiegeInfo();
//		//	}
//		//	//else if (!ReduceButton_Expand.IsShowWindow() || !ReduceButton.IsShowWindow())
//		//	else if (!ReduceButton.IsShowWindow())
//		//	{
//		//		RequestFortressSiegeInfo();
//		//	}
//		//break;
//		//요새전이 종료되면 요새전 상황을 리셋한다.
//		case 2183:
//			GlobalCurFortressStatus = false;
//			//if (ReduceButton_Expand.IsShowWindow() || ReduceButton.IsShowWindow())
//			if (ReduceButton.IsShowWindow())
//			{
//				ExecuteFortressSiegeStatus("");
//				//~ RequestFortressSiegeInfo();	
//			}
//			//else if (!ReduceButton_Expand.IsShowWindow() || !ReduceButton.IsShowWindow())
//			else if (!ReduceButton.IsShowWindow())
//				RequestFortressSiegeInfo();
//		break;
//	}
//}

function HandleZoneTitle()
{
	local int nZoneID;
	//local string DataforMap;
	nZoneID = GetCurrentZoneID();
	// When a PC has entered specified Zone 
	if( IsHideMinimapZone(nZoneID) )
	{
		//Close MiniMapWnd if it is shown and the PC has no item in inventory
		//if(me.IsShowWindow() && bHaveItem==false && !IsBuilderPC())
		if(me.IsShowWindow() && !IsBuilderPC())
		{
			me.HideWindow();
			
			// 미니맵을 사용할 수 없는 지역에 들어왔습니다. 미니맵을 닫습니다.
			if (bMiniMapDisabled )
				AddSystemMessage(2205);
			// 미니맵을 사용할 수 없는 지역이므로 미니맵을 열 수 없습니다.
			else 
				AddSystemMessage(2207);
		}
		// 안쓰나 봄. 어디선가 + 를 나오게 해야 한다.
		//// 헬바운드 쪽에 "+" 버튼을 나오게..
		//else if(me.IsShowWindow() && bHaveItem && ReduceButton.IsShowWindow()== false)
		//{
		//	//~ m_MiniMap.EraseAllRegionInfo();
		//	ParamAdd(DataforMap, "Index", "8888");
		//	ParamAdd(DataforMap, "WorldX", "13187");
		//	ParamAdd(DataforMap, "WorldY", "246159");
		//	ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_PlusBtn_Blue");
		//	ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_PlusBtn_Blue_Down");
		//	ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_PlusBtn_Blue_Over");
		//	ParamAdd(DataforMap, "BtnWidth", "33");
		//	ParamAdd(DataforMap, "BtnHeight", "33");
		//	ParamAdd(DataforMap, "Description", "");
		//	ParamAdd(DataforMap, "DescOffsetX", "0");
		//	ParamAdd(DataforMap, "DescOffsetY", "0");
		//	ParamAdd(DataforMap, "Tooltip", "");
		//	m_MiniMap.AddRegionInfo(DataforMap);
		//	//~ m_MiniMap_Expand.AddRegionInfo(DataforMap);
		//}	
		bMiniMapDisabled = false;
	}
	else 
	{
		if (bMiniMapDisabled == false)
		{
			// 미니맵을 사용할 수 있는 지역에 들어왔습니다.
			AddSystemMessage(2206);
		}
		bMiniMapDisabled = true;
	}
	
	if (IsHideMinimapZone_new(nZoneID) )
	{
		//Close MiniMapWnd if it is shown and the PC has no item in inventory
		//if(me.IsShowWindow() && bHaveItem==false && !IsBuilderPC()  )
		if(me.IsShowWindow() && !IsBuilderPC()  )
		{
			me.HideWindow();
			
			if (bMiniMapDisabled ) 
				AddSystemMessage(2205); // 미니맵을 사용할 수 없는 지역에 들어왔습니다. 미니맵을 닫습니다.
			else 
				AddSystemMessage(2207); // 미니맵을 사용할 수 없는 지역이므로 미니맵을 열 수 없습니다.
		}
		//else	if(m_hExpandWnd.IsShowWindow() && bHaveItem==false && !IsBuilderPC() )
		//{
		//	m_hExpandWnd.HideWindow();
		//	if (bMiniMapDisabled )
		//		AddSystemMessage(2205);
		//	else
		//		AddSystemMessage(2207);
		//}
		bMiniMapDisabled = false;
	}
	else 
	{
		if (bMiniMapDisabled == false)
		{
			AddSystemMessage(2206);
		}		
		bMiniMapDisabled = true;
	}
}

function HandleDungeonMapRefresh(string Param)
{
	local int Index;
	
	ParseInt(Param, "Index", Index);
	
	if (Index == 8888)
	{
		if (me.IsShowWindow())
		{
			me.HideWindow();
			me.ShowWindow();
		}
	}
}

function FilterDungeonMap()
{
	local Vector MyPosition;
	MyPosition = GetPlayerPosition();

	if (MyPosition.x > BlockedLoc1.x && MyPosition.x < BlockedLoc2.x && MyPosition.y > BlockedLoc1.y && MyPosition.y < BlockedLoc2.y)
	{
		///if (bHaveItem==false && !IsBuilderPC() )
		if (!IsBuilderPC() )
		{
			class'UIAPI_MINIMAPCTRL'.static.RequestReduceBtn("MinimapWnd.Minimap");
			//HideWindow("MinimapWnd.btnReduce");
			ReduceButton.HideWindow();
		}
	}
	
}	

//---------------------------------------------------
//  OnShow
//---------------------------------------------------
function OnShow()
{
	//local int i;
	//local ItemInfo info;	
	if (isNoShowMissionWindow == -1)
		GetInIBool ( "MinimapWnd", "l", isNoShowMissionWindow, "windowsInfo.ini");

	AdjustMapToPlayerPosition( true );
	class'AudioAPI'.static.PlaySound( "interfacesound.Interface.map_open_01" );

	if(isNoShowMissionWindow > 0) m_MinimapMissionWnd.HideWindow(); 
	else 
	{
		if (IsBloodyServer() == false)
			m_MinimapMissionWnd.ShowWindow();
	}

	initCursedWeaponArray();
	SetCurrentLocation();
	
	class'UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon("MinimapWnd.Minimap");
	
	//// 헬바운드 지도, 아이템 소지 여부 세팅
	//bHaveItem = false;

	//// 헬바운드 지도를 가지고 있나? (누가 이렇게 짠거냐...이씨...)
	//for (i=0;i<100;i++)
	//{
	//	if (m_questItem.GetItem(i, info) == true)
	//	{
	//		if (info.Name == GetSystemString(1647))
	//			bHaveItem = true;
	//	}
	//}

	// 지역 이름 출력, 미니맵이 있는 , 없는 지역인지등을 표시
	HandleZoneTitle();

	// 대륙 탭 갱신
	ContinentLoc();

	// 맵 정보 갱신
	mapRefresh();

	// ldw 내위치 화살표 보이기	
	setDirIconDest(); 
}

// 맵 정보 갱신
function mapRefresh()
{
	local UserInfo pUserInfo;

	//// 맵 기본 요소 그리기 (사냥터, 낚시, 성아이콘 맵에 그려진 텍스트 등등)
	showMapIconElement();

	// 월드 정보 쪽 정보 갱신 
	MinimapMissionWndScript.refresh();
	
	// 성 정보
	RequestAllCastleInfo();

	// 요새 정보
	RequestAllFortressInfo();


	if(!getInstanceUIData().getIsClassicServer()) 
	{		
		// 아지트 정보
		Class'MiniMapAPI'.static.RequestShowAgitSiegeInfo();

		// 세력 정보
		GetPlayerInfo(pUserInfo);
		RequestUserFactionInfo(EFactionRequsetType.FIRT_NONE, pUserInfo.nID);
		
		// 차원 레이드, 차원 공성전 진행 여부
		// 신규 블러디 서버는 막는다. 
		if (IsBloodyServer() == false)
		{
			Class'MiniMapAPI'.static.RequestRaidServerinfo();

			// 경매 정보
			class'MiniMapAPI'.static.RequestItemAuctionStatus();

			// 진멸의 씨앗, 크세르스 정보
			Class'MiniMapAPI'.static.RequestSeedPhase();
		}

		// 혈검, 마검
		requestCursedWeapon();

		// 인존 정보 
		RequestInzoneWaitingTime(false);
	}
}

function requestCursedWeapon()
{
	class'UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon("MinimapWnd.Minimap");

	if(!getInstanceUIData().getIsClassicServer()) 
	{
		// 혈검 마검
		//class'MiniMapAPI'.static.RequestCursedWeaponList();
		class'MiniMapAPI'.static.RequestCursedWeaponLocation();
		// 저주받은 검, 마검 혈검, 보물상자 위치
		Class'MiniMapAPI'.static.RequestTreasureBoxLocation();
	}
}

// 헌팅존 스크립트에 들어 있는 요소를 보여준다.
function addMapIcon(MinimapRegionInfo regionInfo, optional bool bUpdate)
{
	if(!isVectorZeroXYZ(regionInfo.IconData.nWorldLocX, regionInfo.IconData.nWorldLocX, regionInfo.IconData.nWorldLocZ))
	{
		if (bUpdate)
		{
			m_MiniMap.UpdateRegionInfoCtrl(regionInfo);
			
			// 자유텔레포트
			switch(regionInfo.eType)
			{
				case EMinimapRegionType.MRT_HuntingZone_Base :
				case EMinimapRegionType.MRT_Castle :
				case EMinimapRegionType.MRT_Fortress :
				case EMinimapRegionType.MRT_Agit :
					 TeleportBookMarkWnd_MiniMap.UpdateRegionInfoCtrl(regionInfo);
			         break;
			}
		}
		else
		{
			m_MiniMap.AddRegionInfoCtrl(regionInfo);
			
			// 자유텔레포트
			switch(regionInfo.eType)
			{
				case EMinimapRegionType.MRT_HuntingZone_Base :
				case EMinimapRegionType.MRT_Castle :
				case EMinimapRegionType.MRT_Fortress :
				case EMinimapRegionType.MRT_Agit :
					 TeleportBookMarkWnd_MiniMap.AddRegionInfoCtrl(regionInfo);
			         break;
			}
		}			
	}
}

// 헌팅존 스크립트에 들어 있는 요소를 보여준다.
function showMapIconElement()
{
	local HuntingZoneUIData huntingZoneData;
	local MinimapRegionIconData iconData;
	local MinimapRegionInfo regionInfo;
	local int i;//, fieldType;
	local string toolTipParam;
	local RaidUIData raidData;
	local array<int> raidDataKeyList;
	local int raidMin, raidMax;

	class'UIDATA_RAID'.static.GetRaidDataKeyList(raidDataKeyList);

	// 이미 그렸다면 다시 그리지 않는다.
	if(bCompleteBaseElementShow) 
	{
		// * 레벨등의 이유로 목록 자체가 변하기 때문에 업데이트 하지 않고 
		//   임무 사냥터, 레이드 몬스터, 인스턴스 존은 각 레이어를 삭제 후 다시 그린다. 

		// 인존 타입을 다 지움
		m_MiniMap.EraseRegionInfoByType(EMinimapRegionType.MRT_InstantZone);
		// 임무 사냥터 다 지움
		m_MiniMap.EraseRegionInfoByType(EMinimapRegionType.MRT_HuntingZone_Mission);
		// 레이드 타입 다 지움,
		m_MiniMap.EraseRegionInfoByType(EMinimapRegionType.MRT_Raid);

		// 레벨에 맞는 인존 아이콘 맵에 그리기
		for (i = 0; i < 500; i++)
		{
			// 사냥터, 미션창 연동
			if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i) == false) continue;

			class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);

			if(huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_SOLO ||
			   huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTY ||
			   huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTYWITH_SOLO)
			{
				drawMinimapRegionInfo(EMinimapRegionType.MRT_HuntingZone_Mission, i, true);
			}

			// 인스턴스 존, 미션창 연동
			if(huntingZoneData.nType == HuntingZoneType.INSTANCE_ZONE_SOLO ||
			   huntingZoneData.nType == HuntingZoneType.INSTANCE_ZONE_PARTY) 
			{
				// 인존 아이콘 그리기, 인존은 평소에 활성화되어 있고 귀속되면 비활성화되는 식이다.
				drawMinimapRegionInfo(EMinimapRegionType.MRT_InstantZone, i, true);
			}
		}

		//local int raidMin, raidMax;
		if (IsBloodyServer())
		{
			raidMin = getInstanceUIData().RAID_BLOODY_MIN;
			raidMax = getInstanceUIData().RAID_BLOODY_MAXCOUNT;
		}
		else
		{
			raidMin = getInstanceUIData().RAID_MIN;
			raidMax = getInstanceUIData().RAID_MAXCOUNT;
		}

		// 레벨에 맞는 레이드 아이콘 맵에 그리기
		for(i = 0; i < raidDataKeyList.Length; i++)
		{
			raidData = getRaidDataByIndex(raidDataKeyList[i]);
			// 0, 0, 0 위치 좌표가 모두 0이면 기획쪽에서 보여주길 원치 않는 데이타로 판단 해서 무시함.
			if(raidData.nWorldLoc.x == 0 && raidData.nWorldLoc.y == 0 && raidData.nWorldLoc.z == 0) continue;

			// 레이드의 경우는 활성화는 비활성화로 해서 생성한다. 그 후 서버에서 정보가 오면 그걸 기준으로 업데이트 하여 활성화 해준다.
			drawMinimapRegionInfo(EMinimapRegionType.MRT_Raid,raidDataKeyList[i],false);
		}
	}
	else
	{
		// 맵을 처음 오픈 하고 나서 그린다.
		for (i = 0; i < 500; i++)
		{
			// 빈 구조체라면 다음으로..
			if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i) == false) continue;

			class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);

			// 헌팅존 아이콘 깃발 그리기, 헌틴존 깃발은 무조건 레벨과 관계 없이 그린다.
			// 그런 후 업데이트 되는 정보(레벨)에 따라 업데이트로 해당 아이콘을 업데이트 해주는 식으로 코딩할 예정
			if(huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_SOLO ||
			   huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTY || 
			   huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTYWITH_SOLO)
			{
				drawMinimapRegionInfo(EMinimapRegionType.MRT_HuntingZone_Mission, i);
			}
			else if(huntingZoneData.nType == HuntingZoneType.INSTANCE_ZONE_SOLO ||
					huntingZoneData.nType == HuntingZoneType.INSTANCE_ZONE_PARTY)
			//else if(fieldType == HuntingZoneType.INSTANCE_ZONE_SOLO ||
			//		fieldType == HuntingZoneType.INSTANCE_ZONE_PARTY)
			{
				drawMinimapRegionInfo(EMinimapRegionType.MRT_InstantZone, i, true);
			} 

			// 값이 있는 경우
			if (huntingZoneData.nRegionID > 0)
			{
				// 헌팅존 스크립트에는 성도 들어 가 있다.
				// 성 또한 레벨등 조건에 따라 보였다 안보였다 하는 요소가 아닌지라 별도의 레이어로는 놓지만 한번 그려 준후 업데이트 한다.
				//if (fieldType == HuntingZoneType.CASTLE)
				
				if (huntingZoneData.nType == HuntingZoneType.CASTLE)
				{
					regionInfo.eType  = EMinimapRegionType.MRT_Castle;
					//Debug("=========>>>> 성 그린다 strName::" @ huntingZoneData.strName @ " eType" @ String(regionInfo.eType));					
				}
				else if (huntingZoneData.nType == HuntingZoneType.AGIT)
				{
					regionInfo.eType  = EMinimapRegionType.MRT_Agit;
					//Debug("=========>>>> 아지트 그린다 strName::" @ huntingZoneData.strName);
				}
				else if (huntingZoneData.nType == HuntingZoneType.FORTRESS)
				{
					regionInfo.eType  = EMinimapRegionType.MRT_Fortress;
					//Debug("=========>>>> 요새 그린다 strName::" @ huntingZoneData.strName);
				}
				else
				{
					if (huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_SOLO ||
						huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTY ||
						huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTYWITH_SOLO)
					{
						// 사냥터 타입의 nRegionID가 0이면 아무것도 안함.
						if (huntingZoneData.nRegionID <= 0) continue;
					}

					regionInfo.eType  = EMinimapRegionType.MRT_HuntingZone_Base;
					//Debug("****======>>>> 일반 그린다. strName::" @ huntingZoneData.strName);
				}

				toolTipParam = "";
				ParamAdd(toolTipParam, "Type", String(regionInfo.eType));
				ParamAdd(toolTipParam, "Index", String(i));

				// nRegionID가 단일 고유값이니 이걸 사용.
				regionInfo.nIndex = huntingZoneData.nRegionID; //i; //huntingZoneData.nSearchZoneID;

				regionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;
				regionInfo.strDesc = huntingZoneData.strName;

				regionInfo.strTooltip = toolTipParam;

				GetMinimapRegionIconData(huntingZoneData.nRegionID, iconData);
				regionInfo.IconData = iconData;

				//m_MiniMap.AddRegionInfoCtrl(regionInfo);
				
				// 기존
				addMapIcon(regionInfo);
			}
		}

		//local int raidMin, raidMax;
		if (IsBloodyServer())
		{
			raidMin = getInstanceUIData().RAID_BLOODY_MIN;
			raidMax = getInstanceUIData().RAID_BLOODY_MAXCOUNT;
		}
		else
		{
			raidMin = getInstanceUIData().RAID_MIN;
			raidMax = getInstanceUIData().RAID_MAXCOUNT;
		}

		// 레벨에 맞는 레이드 아이콘 맵에 그리기
		for(i = 0; i < raidDataKeyList.Length; i++)
		{
			raidData = getRaidDataByIndex(raidDataKeyList[i]);
			// 0, 0, 0 위치 좌표가 모두 0이면 기획쪽에서 보여주길 원치 않는 데이타로 판단 해서 무시함.
			if(raidData.nWorldLoc.x == 0 && raidData.nWorldLoc.y == 0 && raidData.nWorldLoc.z == 0) continue;

			drawMinimapRegionInfo(EMinimapRegionType.MRT_Raid,raidDataKeyList[i],false);
		}

		// 팩션 맵 아이콘 그리기(툴팁 정보는 없고, 맵에 아이콘만.. 정보는 업데이트 됨)
		drawFactionMapIcon();
	}

	bCompleteBaseElementShow = true;

	// Debug("---------------map 기본 요소 그리기 완료 ----------------------------- ");

}

function setDirIconDest()// ldw 내위치 표시 화살표 
{	
	local vector playerPos, questLoc;
	local string questTooltipStr;

	playerPos = GetPlayerPosition();
	m_MiniMap.SetDirIconDest( EMinimapTargetIcon.TARGET_ME, playerPos, GetSystemString(887) );	
		
	questLoc = QuestTreeWnd(GetScript("QuestTreeWnd")).getCurrentQuestDirectTargetPos();
	questTooltipStr = QuestTreeWnd(GetScript("QuestTreeWnd")).getCurrentQuestDirectTargetString();

	if (questTooltipStr != "") 
	{
		//Debug("퀘스트 화살표 보정x" @ questLoc.x);
		//Debug("퀘스트 화살표 보정y" @ questLoc.y);
		//Debug("퀘스트 화살표 보정z" @ questLoc.z);
		m_MiniMap.SetDirIconDest( EMinimapTargetIcon.TARGET_QUEST, questLoc, questTooltipStr);	
	}

	//if ( m_CurContinent == m_MiniMap.GetContinent( playerPos ) )// 같은 대륙일 대만 표시
	//{
	//	m_MiniMap.SetDirIconDest( EMinimapTargetIcon.TARGET_ME, playerPos, GetSystemString(887) );	
			
	//	questLoc = QuestTreeWnd(GetScript("QuestTreeWnd")).getCurrentQuestDirectTargetPos();
	//	questTooltipStr = QuestTreeWnd(GetScript("QuestTreeWnd")).getCurrentQuestDirectTargetString();
		
	//	//Debug("playerPos 보정x" @ playerPos.x);
	//	//Debug("playerPos 보정y" @ playerPos.y);
	//	//Debug("playerPos 보정z" @ playerPos.z);

	//	//Debug("questTooltipStr" @ questTooltipStr);
	//	if (questTooltipStr != "") 
	//	{
	//		//Debug("퀘스트 화살표 보정x" @ questLoc.x);
	//		//Debug("퀘스트 화살표 보정y" @ questLoc.y);
	//		//Debug("퀘스트 화살표 보정z" @ questLoc.z);
	//		m_MiniMap.SetDirIconDest( EMinimapTargetIcon.TARGET_QUEST, questLoc, questTooltipStr);	
	//	}
	//}
	//else 
	//{
	//	m_MiniMap.DisableDirIcon(EMinimapTargetIcon.TARGET_ME) ;
	//	m_MiniMap.DisableDirIcon(EMinimapTargetIcon.TARGET_QUEST) ;
	//	//m_MiniMap_Expand.DisableDirIcon(EMinimapTargetIcon.TARGET_ME) ;
	//}
}


//맵 대륙 탭, 그레시아, 아덴 대륙, 탭전환
function ContinentLoc()
{
	local Vector MyPosition;
	MyPosition = GetPlayerPosition();
	
	if (m_MiniMap.GetContinent(MyPosition) == 1)
	{	
		SetContinent(1);
		m_MapSelectTab.SetTopOrder(0, true);
	}
	else if (m_MiniMap.GetContinent(MyPosition) == 0)
	{
		SetContinent(0);
		m_MapSelectTab.SetTopOrder(1, true);
	}

	
}

function SetCurrentLocation()
{
	local string ZoneName;

	ZoneName=GetCurrentZoneName();
	class'UIAPI_TEXTBOX'.static.SetText("Minimapwnd.txtVarCurLoc", ZoneName); 
}

function OnHide()
{
	//CloseMultilayer();//ldw 다층 타운 맵 콤보 박스 닫기
	if( m_MinimapMissionWnd.IsShowWindow() )
	{
		m_MinimapMissionWnd.HideWindow();
	}
	class'AudioAPI'.static.PlaySound( "interfacesound.Interface.map_close_01" );

	initServerInfoArray();
	initServerButton();	

	Me.KillTimer( TIMER_ID );
	m_MiniMap.EraseRegionInfoCtrl(EMinimapRegionType.MRT_Etc, OTHER_HIGHLIGHT_ICON_INDEX);
	m_MiniMap.EraseRegionInfoCtrl(EMinimapRegionType.MRT_Quest, QUEST_START_NPC_ICON_INDEX);
	// 성정보는 add 이벤트만 오기 때문에 창을 닫을 떄 다시 초기화 해야 한다. 안그럼 쌓인다.
	// serverInfoArray[MapServerInfoType.SIEGEWARFARE].szReserved = "";																  
}

function HandlePartyMemberChanged( String a_Param )
{
	ParseInt( a_Param, "PartyMemberCount", m_PartyMemberCount );
}

//function SetExpandState(bool bExpandState)
//{
//	m_bExpandState=bExpandstate;
//}

function bool IsExpandState()
{
	local int w, h;
	GetWindowHandle(m_WindowName).GetWindowSize(w, h);

	// 확대 상태 라면...
	if (w >= 800) return true;
	return false;
}

function HandleShowMinimap( String a_Param )
{
	// 작은 윈도우 상태, 토글 Show,Hide
	if(IsShowWindow("MinimapWnd"))
	{
		HideWindow("MinimapWnd");
	}
	else
	{
		ShowWindowWithFocus("MinimapWnd");
	}
}

function HandleMinimapAddTarget( String a_Param )
{
	local Vector Loc;
	
	if( ParseFloat( a_Param, "X", Loc.x )
		&& ParseFloat( a_Param, "Y", Loc.y )
		&& ParseFloat( a_Param, "Z", Loc.z ) )
	{		
		class'UIAPI_MINIMAPCTRL'.static.AddTarget( "MinimapWnd.Minimap", Loc );
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", Loc, false, false);
	}
}

function HandleMinimapDeleteTarget( String a_Param )
{
	local Vector Loc;
	local int LocX;
	local int LocY;
	local int LocZ;

	if( ParseInt( a_Param, "X", LocX )
		&& ParseInt( a_Param, "Y", LocY )
		&& ParseInt( a_Param, "Z", LocZ ) )
	{
		Loc.x = float(LocX);
		Loc.y = float(LocY);
		Loc.z = float(LocZ);
		class'UIAPI_MINIMAPCTRL'.static.DeleteTarget( "MinimapWnd.Minimap", Loc );
	}
}

function HandleMinimapDeleteAllTarget()
{
	class'UIAPI_MINIMAPCTRL'.static.DeleteAllTarget( "MinimapWnd.Minimap" );
}

function HandleMinimapShowQuest()
{
	class'UIAPI_MINIMAPCTRL'.static.SetShowQuest( "MinimapWnd.Minimap", true );
	//m_MiniMap.SetDirIconDest(  EMinimapTargetIcon.TARGET_QUEST ,  vTargetPos , "가나다라" );
}

function HandleMinimapHideQuest()
{

	class'UIAPI_MINIMAPCTRL'.static.SetShowQuest( "MinimapWnd.Minimap", false );
}

// 다층 타운맵 (층 표시 콤보 박스 선택시)
function OnComboBoxItemSelected( string sName, int index )
{   	
	switch (sName)
	{
		//ldw 테스트 다층타워맵		
		case "FloorComboBox": 
			 select_floor(index);
			 break;	
	}
}

//ldw 테스트 다층 타워맵, 콤보 선택
function select_floor(int index)
{
	local int tmpNum;	
	local string WndName;
	local string ComboBoxName;
	WndName = currentWndName();
	ComboBoxName = WndName$".FloorComboBox";
	tmpNum=index+1;	
	
	class'UIAPI_MINIMAPCTRL'.static.ShowCertainLayer(WndName$".Minimap",tmpNum);
	class'UIAPI_COMBOBOX'.static.SetSelectedNum( ComboBoxName, index);	
}


function OnClickButton( String a_ButtonID )
{	
	// Debug("a_ButtonID" @ a_ButtonID);

	switch( a_ButtonID )
	{
		//~ case "TargetButton":
			//~ OnClickTargetButton();
			//~ break;
		case "MyLocButton":
			OnClickMyLocButton();
			break;
		case "PartyLocButton":
			OnClickPartyLocButton();
			break;
		case "OpenGuideWnd":
			if( m_MinimapMissionWnd.IsShowWindow() )
			{
				isNoShowMissionWindow = 1;
				SetInIBool ( "MinimapWnd", "l", numToBool(isNoShowMissionWindow), "windowsInfo.ini");

				m_MinimapMissionWnd.HideWindow();
			}
			else
			{
				isNoShowMissionWindow = 0;
				SetInIBool ( "MinimapWnd", "l", numToBool(isNoShowMissionWindow), "windowsInfo.ini");
					
				m_MinimapMissionWnd.ShowWindow();
				m_MinimapMissionWnd.SetFocus();
			}
			break;

		// 맵 컨트롤, 축소
		case "btnReduce" :
			OnClickReduceButton();
			//m_MiniMap.EraseAllRegionInfo();
			//DrawSeedMapInfo();
			break;

		//case "Btn_Refresh" :
		//	ExecuteFortressSiegeStatus("");
		//	break;

		case "MapSelectTab1":
			//debug("tab selected 1");
			// Assign World Continent 
			if (IsExpandState()) setMapSize(true);
			SetContinent(0);
			
			//RequestFortressSiegeInfo();
			InitializeLocation();

			requestCursedWeapon();

			setDirIconDest();

			break;

		case "MapSelectTab0":
			/// debug("tab selected 0");
			//특화 서버일 경우 탭버튼 반을 하지 않도록 한다.
			if ( getInstanceUIData().getisClassicServer() ) return;

			if (IsExpandState()) setMapSize(true);

			SetContinent(1);

			// 마검, 혈검 정보 갱신			
			requestCursedWeapon();

			InitializeLocation();
			setDirIconDest();
			
			break;

		// 맵 확대, 축소
		case "ExpandButton" :
			 expandMapSize();
			 break;

		// 서버 버튼 클릭
		case "ServerInfo01_Button" :
		case "ServerInfo02_Button" :
		case "ServerInfo03_Button" :
		case "ServerInfo04_Button" :
		case "ServerInfo05_Button" :
		case "ServerInfo06_Button" :

			 clickServerInfoButton(a_ButtonID);
			 break;
	}
}

function bool isSameContinent()
{
	return (m_MiniMap.GetContinent( GetPlayerPosition() ) == m_CurContinent);
}

// 맵 확대, 축소
function expandMapSize(optional bool bForceExpandSize)
{
	local int gWidth, gHeight;
	
	me.GetWindowSize(gWidth, gHeight);
	
	//Debug("gWidth"@ gWidth);
	//Debug("gHeight"@ gHeight);
	//getInstanceUIData().getScreenHeight()
 
	Debug("bIsTownMap" @ bIsTownMap);
	Debug("nTownMapZoneID" @ nTownMapZoneID);
	Debug("GetCurrentZoneID()" @ GetCurrentZoneID());

	if(800 <= gWidth)
	{
		// 축소맵 (작은 사이즈)
		setMapSize(false);		
		GetButtonHandle(m_WindowName $ ".ExpandButton").SetButtonName(1474); // 지도확대로 버튼 스트링 변경		
		
		if(m_MiniMap.GetContinent( GetPlayerPosition() ) == m_CurContinent)
		{
			if (!bIsTownMap)
			{
				AdjustMapToPlayerPosition( bIsTownMap );
			}
			else
			{
				if(nTownMapZoneID == GetCurrentZoneID() || nTownMapZoneID == 0) AdjustMapToPlayerPosition( bIsTownMap );			
			}
		}
	}
	else
	{
		smallMapRect = Me.GetRect();
		// 확대맵 (큰 사이즈)
		setMapSize(true);
		
		GetButtonHandle(m_WindowName $ ".ExpandButton").SetButtonName(2734); // 지도축소로 버튼 스트링 변경

		if(m_MiniMap.GetContinent( GetPlayerPosition() ) == m_CurContinent)
		{
			if (!bIsTownMap)
			{
				AdjustMapToPlayerPosition( bIsTownMap );
			}
			else
			{
				if(nTownMapZoneID == GetCurrentZoneID() || nTownMapZoneID == 0) AdjustMapToPlayerPosition( bIsTownMap );
			}
		}
	}

	// 자기 중심으로 위치를 다시 잡아 준다. 잡아 주지 않으면 맵이 비정상적 위치를 보여 주고 있는 문제 발생.
	//OnClickMyLocButton();
}

// 맵 사이즈 조절
function setMapSize(bool bBigSize)
{
	local int wSum, hSum, moveX, moveY;
	local Rect rect;

	if(bBigSize)
	{
		rect = me.GetRect();

		wSum = 377 + getExtendMapSize() - 800;
		//hSum = 92;

		// 타운 맵등이 1024니까 더 크면 안나온다. 최대 1024
		if (getInstanceUIData().getScreenHeight() >= 1024)
			hSum = 1024;
		else 
			hSum = getInstanceUIData().getScreenHeight();

		me.SetWindowSize(getExtendMapSize(), hSum);		
		// 맵 컨트롤 사이즈
		m_MiniMap.SetWindowSize(411 + wSum, hSum - 95);

		// 맵위에 쉐도우
		GetTextureHandle(m_WindowName $ ".texShadowBottom").SetWindowSize(411 + wSum, 43);
		GetTextureHandle(m_WindowName $ ".TexMapStroke").SetWindowSize(413 + wSum, hSum - 93);
		GetTextureHandle(m_WindowName $ ".TexMapStrokeGrow").SetWindowSize(413 + wSum, hSum - 93);

		GetTextureHandle(m_WindowName $ ".texShadowTop").SetWindowSize(411 + wSum, 43);
		

		// 맵을 감싸는 라인 박스
		GetTextureHandle(m_WindowName $ ".TabBg").SetWindowSize(424 + wSum, hSum - 59);

		if ( getInstanceUIData().getisClassicServer() )
		{
			TabBg_Line.SetWindowSize( 318 + wSum + 86 , 23);
			TabBg_Line.SetAnchor( m_WindowName, "TopLeft", "TopLeft", 101 , 31);		
		}
		else 
		{			
			TabBg_Line.SetWindowSize( 140 + wSum + 86, 23);
			TabBg_Line.SetAnchor( m_WindowName, "TopLeft", "TopLeft", 193 , 31);	
		}

		moveX = rect.nX;
		moveY = 1;

		// 해상도와 창 위치에 따른 위치 보정.
		if(rect.nX + getExtendMapSize() > getInstanceUIData().getScreenWidth())
			moveX = getInstanceUIData().getScreenWidth() - getExtendMapSize();

		me.MoveTo(moveX, moveY);	
	}
	else
	{
		me.MoveTo(smallMapRect.nX, smallMapRect.nY);
		me.SetWindowSize(423, 508);

		// 맵 컨트롤 사이즈
		m_MiniMap.SetWindowSize(411, 413);

		// 맵위에 쉐도우
		GetTextureHandle(m_WindowName $ ".texShadowBottom").SetWindowSize(411, 43);
		GetTextureHandle(m_WindowName $ ".TexMapStroke").SetWindowSize(413, 415);
		GetTextureHandle(m_WindowName $ ".TexMapStrokeGrow").SetWindowSize(413, 415);

		// 맵을 감싸는 라인 박스
		GetTextureHandle(m_WindowName $ ".TabBg").SetWindowSize(424, 447);

		if ( getInstanceUIData().getisClassicServer() )
		{
			TabBg_Line.SetWindowSize( 318 + 86 , 23);
			TabBg_Line.SetAnchor( m_WindowName, "TopLeft", "TopLeft", 101 , 31);		
		}
		else 
		{			
			TabBg_Line.SetWindowSize( 140 + 86, 23);
			TabBg_Line.SetAnchor( m_WindowName, "TopLeft", "TopLeft", 193 , 31);	
		}
	}

	// 확대 축소를 했을때 임무 창이 뒤에 가리지 않도록 포커스를 준다.
	if (m_MinimapMissionWnd.IsShowWindow()) m_MinimapMissionWnd.SetFocus();
}

function int getExtendMapSize()
{
	local int nSize;

	// 클래식이면 무조건 1024, 그라시아 대륙이 없어서..
	if ( getInstanceUIData().getisClassicServer() )
	{
		nSize = 1024;
	}
	else
	{
		// 그라시아
		if(m_MapSelectTab.GetTopIndex() == 0)
		{
			nSize = 834;
		}
		else
		{
			nSize = 1024;
			
		}
	}

	return nSize;
}

function OnClickReduceButton()
{
	Debug("OnClickReduceButton");
	class'UIAPI_MINIMAPCTRL'.static.RequestReduceBtn("MinimapWnd.Minimap"); // 기본 값으로 내 위치로 찾아 감.  -> EV_minimapHideReduceBtn 이벤트 날라옴
	//if( 퀘스트 추적 도구가 켜져 있으면 )  퀘스트 위치로 타운 맵도 해당 위치로
	// +눌렀을 때 여러 처리가 필요 함.
	HideWindow("MinimapWnd.btnReduce"); 
	//Btn_Refresh.HideWindow();
	//Btn_Refresh_Expand.HideWindow();
	//RequestFortressSiegeInfo();
	HandleZoneTitle();
	//setDirIconDest();
	//SetSSQTypeText();ldw 20101227 세븐 사인이 없어지므로 주석 처리
}

function OnClickTargetButton()
{
	if( GetQuestLocation(QuestLocation ) )
	{
		SetLocContinent(QuestLocation);
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", QuestLocation, false );
		
		if(  QuestLocation.x ==19714 && QuestLocation.y == 243420  && QuestLocation.z == -205)
		{
			OnClickReduceButton();
		}	
		else if (QuestLocation.x ==8800  && QuestLocation.y == 251652  && QuestLocation.z == -2032 )
		{
			OnClickReduceButton();
		}
		else if (QuestLocation.x ==27491  && QuestLocation.y == 247340  && QuestLocation.z == -3256 )
		{
			OnClickReduceButton();
		}
	}
}

// 내 위치로 맵 이동
function OnClickMyLocButton()
{
	AdjustMapToPlayerPosition( true );
}

// 플레이어 중심으로 맵 이동
function AdjustMapToPlayerPosition( bool a_ZoomToTownMap )
{
	local Vector PlayerPosition;

	PlayerPosition = GetPlayerPosition();
	SetLocContinent(PlayerPosition);
	class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", PlayerPosition, a_ZoomToTownMap );
}


// 파티 위치로 맵 이동
function OnClickPartyLocButton()
{
	local Vector PartyMemberLocation;

	m_PartyMemberCount = GetPartyMemberCount();
	
	if( 0 == m_PartyMemberCount )
		return;

	m_PartyLocIndex = ( m_PartyLocIndex + 1 ) % m_PartyMemberCount;
	if( GetPartyMemberLocation( m_PartyLocIndex, PartyMemberLocation ) )
	{
		SetLocContinent(PartyMemberLocation);
		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", PartyMemberLocation, false );
	}
}

function cursedWeaponInit(out CursedWeapon CursedWeaponData)
{
	CursedWeaponData.bDrop = false;
	
	CursedWeaponData.itemClassID = 0;
	CursedWeaponData.fixedAdena = 0;
	CursedWeaponData.isowned = 0;
	CursedWeaponData.name = "";
	CursedWeaponData.npcID = 0;
	CursedWeaponData.nServerInfoType = 0;
	CursedWeaponData.variableAdena = 0;
	CursedWeaponData.x = 0;
	CursedWeaponData.y = 0;
	CursedWeaponData.z = 0;
	CursedWeaponData.eventParam = "";

	CursedWeaponData.loc.x = 0;
	CursedWeaponData.loc.y = 0;
	CursedWeaponData.loc.z = 0;
}

function initCursedWeaponArray()
{
	local int i;
	for (i = 0; i < CursedWeaponArray.Length; i++)
		cursedWeaponInit(CursedWeaponArray[i]);

}

// 저주 받은 검, 위치 
function HandleCursedWeaponLoctaion( string param , bool isTreasureBox)
{
	local int num;  
	local int i;
	local Vector cursedWeaponLocation, nullVector;
	
	ParseInt( param, "NUM", num );

	class'UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon( "MinimapWnd.Minimap");

	// 혈검 마검이 없다면..
	if(num == 0)
	{	
		if (isTreasureBox == true)
		{
			// 보물 상자
			cursedWeaponInit(CursedWeaponArray[2]);
			cursedWeaponInit(CursedWeaponArray[3]);
			setServerParse(MapServerInfoType.CURSEDWEAPON_MAGICAL_TreasureBox, "", false, nullVector);
			setServerParse(MapServerInfoType.CURSEDWEAPON_BLOOD_TreasureBox, "", false, nullVector);

		}
		else
		{
			// 마검 혈검 배열 두개 초기화 
			cursedWeaponInit(CursedWeaponArray[0]);
			cursedWeaponInit(CursedWeaponArray[1]);

			setServerParse(MapServerInfoType.CURSEDWEAPON_BLOOD, "", false, nullVector);
			setServerParse(MapServerInfoType.CURSEDWEAPON_MAGICAL, "", false, nullVector);
		}

		// 지우고, 만약 배열에 그릴 것이 있다면 다시 그림.
		DrawCursedWeaponbyArray();

		return;
	}
	// 혈검 마검이 있다면..
	else
	{
		// 1, 2 가 num 으로 들어 옴.
		if (isTreasureBox == false)
		{
			for(i=0; i < num; i++)
			{
				ParseInt( param, "ID" $ i, CursedWeaponArray[i].itemClassID );
				ParseString( param, "NAME" $ i, CursedWeaponArray[i].name );
				ParseInt( param, "X" $ i, CursedWeaponArray[i].x );
				ParseInt( param, "Y" $ i, CursedWeaponArray[i].y );
				ParseInt( param, "Z" $ i, CursedWeaponArray[i].z );

				ParseInt64( param, "FIXED" $ i, CursedWeaponArray[i].fixedAdena );
				ParseInt64( param, "VARIABLE" $ i, CursedWeaponArray[i].variableAdena );	

				cursedWeaponLocation.x = CursedWeaponArray[i].x;
				cursedWeaponLocation.y = CursedWeaponArray[i].y;
				cursedWeaponLocation.z = CursedWeaponArray[i].z;

				CursedWeaponArray[i].eventParam = CursedWeaponArray[i].name $"|" $ CursedWeaponArray[i].fixedAdena $ "|" $ CursedWeaponArray[i].variableAdena;


				// Debug ( "HandleCursedWeaponLoctaion" @ CursedWeaponArray[i].eventParam);
				// Debug( "!HandleCursedWeaponLoctaion" @ param  @ CursedWeaponArray[i].fixedAdena  @ CursedWeaponArray[i].variableAdena  ) ;
				

				Normal(cursedWeaponLocation);
				CursedWeaponArray[i].loc = cursedWeaponLocation;

				// 8190 마검,8689 혈검은 아이템 id
				if (CursedWeaponArray[i].itemClassID == 8190 || CursedWeaponArray[i].itemClassID == 8689)
				{
					ParseInt( param, "ISOWNED" $ i, CursedWeaponArray[i].isowned );

					// 기본 보상, 증가 변동된 보상 
					//ParseINT64( param, "FIXED" $ i, CursedWeaponArray[i].fixedAdena );
					//ParseINT64( param, "VARIABLE" $ i, CursedWeaponArray[i].variableAdena );

					// 마검 자리체
					if( CursedWeaponArray[i].itemClassID == 8190 )
					{	
						setServerParse(MapServerInfoType.CURSEDWEAPON_MAGICAL, "", true, cursedWeaponLocation);

						// 서버 버튼 삭제
						if (num == 1)
						{
							setServerParse(MapServerInfoType.CURSEDWEAPON_BLOOD, "", false, nullVector);
						}
					}
					// 혈검 아카마나프
					else if( CursedWeaponArray[i].itemClassID == 8689 )
					{
						setServerParse(MapServerInfoType.CURSEDWEAPON_BLOOD, "", true, cursedWeaponLocation);

						// 서버 버튼 삭제
						if (num == 1) 
						{
							setServerParse(MapServerInfoType.CURSEDWEAPON_MAGICAL, "", false, nullVector);
						}
					}
				}
			}

			if (num == 1)
			{
				cursedWeaponInit(CursedWeaponArray[1]);
			}
		}
		// 보물상자라면..
		else
		{
			for(i = 2; i < num + 2; i++)
			{
				ParseInt( param, "ID" $ i - 2, CursedWeaponArray[i].itemClassID );
				ParseString( param, "NAME" $ i - 2, CursedWeaponArray[i].name );
				ParseInt( param, "X" $ i - 2, CursedWeaponArray[i].x );
				ParseInt( param, "Y" $ i - 2, CursedWeaponArray[i].y );
				ParseInt( param, "Z" $ i - 2, CursedWeaponArray[i].z );

				cursedWeaponLocation.x = CursedWeaponArray[i].x;
				cursedWeaponLocation.y = CursedWeaponArray[i].y;
				cursedWeaponLocation.z = CursedWeaponArray[i].z;

				CursedWeaponArray[i].eventParam = CursedWeaponArray[i].name;
				Normal(cursedWeaponLocation);
				CursedWeaponArray[i].loc = cursedWeaponLocation;

				//Debug("CursedWeaponArray[i].name " @ CursedWeaponArray[i].name);
				//Debug("CursedWeaponArray[i].itemClassID " @ CursedWeaponArray[i].itemClassID);

				// 보물상자는 npc ID임 .
				//24370, 자리체의 보물상자(마검) 
				if( CursedWeaponArray[i].itemClassID == 24370 )
				{	
					setServerParse(MapServerInfoType.CURSEDWEAPON_MAGICAL_TreasureBox, "", true, cursedWeaponLocation);
					// 서버 버튼 삭제
					if (num == 1)
					{
						setServerParse(MapServerInfoType.CURSEDWEAPON_BLOOD_TreasureBox, "", false, nullVector);
					}

				}
				//24371, 아카마나프의 보물상자 (혈검)
				else if( CursedWeaponArray[i].itemClassID == 24371 )
				{
					setServerParse(MapServerInfoType.CURSEDWEAPON_BLOOD_TreasureBox, "", true, cursedWeaponLocation);
					// 서버 버튼 삭제
					if (num == 1)
					{
						setServerParse(MapServerInfoType.CURSEDWEAPON_MAGICAL_TreasureBox, "", false, nullVector);
					}
				}
			}

			if (num == 1) cursedWeaponInit(CursedWeaponArray[3]);

		}
	}

	DrawCursedWeaponbyArray();
}

function DrawCursedWeaponbyArray()
{
	local int i, m;

	m = 0;

	//--------------------------------
	// 마검 혈검 
	//--------------------------------
	// 마검이랑 자리체가 겹쳐 있으면..
	if (CursedWeaponArray.Length > 1)
	{
		// 마검 혈검이 id가 들어 있다면..
		if (CursedWeaponArray[0].itemClassID != 0 && CursedWeaponArray[1].itemClassID != 0)
		{
			// 그리드에 겹치면, 마검혈검이.. 해골 이미지로 변경.
			if (class'UIAPI_MINIMAPCTRL'.static.IsOverlapped("MinimapWnd.Minimap", CursedWeaponArray[0].loc.x, CursedWeaponArray[0].loc.y, CursedWeaponArray[1].loc.x, CursedWeaponArray[1].loc.y))
			{
				//if (CursedWeaponArray[0].loc.x == 0 && CursedWeaponArray[0].loc.y == 0 && CursedWeaponArray[0].loc.z == 0)
				// 마검 혈검이 합쳐진것.

				Debug("---------------!!!!!!! 그리기 cursedmapicon00 해골" @ CursedWeaponArray[0].itemClassID);
				class'UIAPI_MINIMAPCTRL'.static.DrawGridIcon( "MinimapWnd.Minimap","L2UI_CH3.MiniMap.cursedmapicon00", CursedWeaponArray[0].loc,true,60, 99, 0, 0, "sword|" $ CursedWeaponArray[0].eventParam $ "|" $ CursedWeaponArray[1].eventParam);
				// eventParam 은 0,1 인덱스 배열의 값이 모두 같기 때문에 아무거나 넣어줌.
				m = 2;
			}
		}
	}

	//--------------------------------
	// 보물상자
	//--------------------------------
	for(i = m; i < CursedWeaponArray.Length; i++)
	{
		if (CursedWeaponArray[i].itemClassID > 0)
		{
			DrawCursedWeapon("MinimapWnd.Minimap", CursedWeaponArray[i].itemClassID, 
				CursedWeaponArray[i].eventParam, CursedWeaponArray[i].loc, CursedWeaponArray[i].isowned == 0, false, 
				CursedWeaponArray[i].fixedAdena, CursedWeaponArray[i].variableAdena);
		}
	}
}

// 저주 받은 검 아이템을 맵에 그리기.
function DrawCursedWeapon(string WindowName, int id, string cursedName, Vector vecLoc, bool bDropped, bool bRefresh, INT64 fixedAdena, INT64 variableAdena)
{
	local string itemIconName;

	// 아이템 ID
	// 마검 자리체
	if(id == 8190)
	{
		ItemIconName = "L2UI_CH3.MiniMap.cursedmapicon01";
		if(bDropped) ItemIconName = ItemIconName$"_drop";
	}
	// 혈검 아카마나프
	else if(id == 8689)
	{
		ItemIconName ="L2UI_CH3.MiniMap.cursedmapicon02";
		if(bDropped) ItemIconName = ItemIconName$"_drop";
	}

	// npcID로 체크 
	// 자리체의 보물상자(마검)
	else if(id == 24370)
	{
		ItemIconName = "L2UI_CT1.Minimap.Cursedmapicon_Treasurebox01";
	}
	// 아카마나프의 보물상자(혈검)
	else if(id == 24371)
	{
		ItemIconName ="L2UI_CT1.Minimap.Cursedmapicon_Treasurebox02";
	}


	// 마검, 혈검
	if (id == 8190 || id == 8689)
	{
		class'UIAPI_MINIMAPCTRL'.static.DrawGridIcon(WindowName, ItemIconName, vecLoc, bRefresh, 60, 72, 0, 0, "sword|" $ cursedName);

		Debug("---------------!!!!!!! 그리기 마검혈검" @ ItemIconName);
	}
	// 보물상자
	else if (id == 24370 || id == 24371)
	{
		class'UIAPI_MINIMAPCTRL'.static.DrawGridIcon(WindowName, ItemIconName, vecLoc, bRefresh, 45, 45, 0, 0, "treasureBox|" $ cursedName);
		Debug("---------------!!!!!!! 그리기 보물상자" @ ItemIconName);
	}
}

// 게임 시간
function HandleUpdateGameTime(string a_Param)
{
	local int GameHour;
	local int GameMinute;

	local string GameTimeString;

	ParseInt(a_Param, "GameHour", GameHour);
	ParseInt(a_Param, "GameMinute", GameMinute);

	GameTimeString = "";

	if ( me.IsShowWindow() ) 
	{
		// 일정 시간 마다 진멸의 씨앗 정보를 리퀘스트 하나 봄. -_-.. 
		DelayRequestSeedInfo ++;
		if ( DelayRequestSeedInfo == 60 ) 
		{			
			Class'MiniMapAPI'.static.RequestSeedPhase();
		}
	}	

	SelectSunOrMoon(GameHour);

	if ( GameHour == 0 ) GameHour = 12;
	GameTimeString = GameTimeString $ string(GameHour) $ " : ";

	if(GameMinute<10)
		GameTimeString = GameTimeString $ "0" $ string(GameMinute);
	else
		GameTimeString = GameTimeString $ string(GameMinute);

	class'UIAPI_TEXTBOX'.static.SetText("MinimapWnd.txtGameTime", GameTimeString);
}

function HandleMinimapTravel( String a_Param )
{
	local int TravelX;
	local int TravelY;

	if( !ParseInt( a_Param, "TravelX", TravelX ) )
		return;

	if( !ParseInt( a_Param, "TravelY", TravelY ) )
		return;

	ExecuteCommand( "//teleport" @ TravelX @ TravelY );
}

function SelectSunOrMoon(int GameHour)
{
	if ( GameHour >= 6 && GameHour <= 24 )
	{
		ShowWindow("MinimapWnd.texSun");
		HideWindow("MinimapWnd.texMoon");
	}
	else
	{
		ShowWindow("MinimapWnd.texMoon");
		HideWindow("MinimapWnd.texSun");
	}
}

function InitializeLocationByContinent()
{	
	local Vector Location;

	// Changed by JoeyPark 2010/10/12
	//MyPosition = GetPlayerPosition();	
	
	if (m_CurContinent == 0) //Aden 대륙
	{
		Location.x = -86916;
		Location.y = 222183;
		Location.z = -4656;			
	}
	else if (m_CurContinent == 1) //Gracia 대륙
	{
		Location.x = -181823;
		Location.y = 224580;
		Location.z = -4104;
	}			
	m_MiniMap.adjustMapView(Location, false);	
	// End changing
}

function InitializeLocation()
{		
	local Vector MyPosition;	

	// Changed by JoeyPark 2010/10/12
	MyPosition = GetPlayerPosition();	
	
	if ( m_MiniMap.GetContinent( MyPosition ) == m_CurContinent ) //같은 대륙이면 현재 위치에 따라 설정.
	{
		m_MiniMap.adjustMapView(MyPosition, true);
		//m_MiniMap.adjustMapView(MyPosition, bIsTownMap);
	}
	else InitializeLocationByContinent();
	// End changing
}

// 클래식, 라이브에 따라 변경. (클래식은 그라시아 없음 2016-04)
function checkClassicForm() 
{

	if ( getInstanceUIData().getisClassicServer() )
	{
		m_MapSelectTab.SetTopOrder(0, false);
		m_MapSelectTab.SetButtonDisableTexture(1, "L2UI_ct1.Misc_DF_Blank");
		//아덴 대륙으로 바꿈
		m_MapSelectTab.SetButtonName(0, GetSystemString(1769));
		m_MapSelectTab.SetDisable(1, true);			
		m_MapSelectTab.SetButtonName(1, "");				
		TabBg_Line.SetWindowSize( 318 + 86, 23);
		TabBg_Line.SetAnchor( m_WindowName, "TopLeft", "TopLeft", 101 , 31);		
		//TabBg_Line.setahcn
	}
	else 
	{			
		//그라시아
		m_MapSelectTab.SetButtonName(0, GetSystemString(1768));
		//아덴
		m_MapSelectTab.SetButtonName(1, getSystemString (1769));
		m_MapSelectTab.SetDisable(1, false);
		TabBg_Line.SetWindowSize( 140 + 86 , 23);
		TabBg_Line.SetAnchor( m_WindowName, "TopLeft", "TopLeft", 193 , 31);	
	}
} 


// 맵 (대륙) 으로 로드하고 현재 위치에 맞는 탭으로 변경.
function SetContinent(int continent)
{
	m_CurContinent = continent;
	
	m_MiniMap.SetContinent(m_CurContinent);
	if (m_CurContinent == 1)
		m_MapSelectTab.SetTopOrder(0, true);
	else if(m_CurContinent == 0)
		m_MapSelectTab.SetTopOrder(1, true);

	if (IsExpandState()) setMapSize(true);
}

// 위치 좌표에 따라 대륙 이동
function SetLocContinent(vector loc)
{
	m_CurContinent = m_MiniMap.GetContinent(loc);
		
	SetContinent(m_CurContinent);
}

//// 현재 위치한 대륙 정보 리턴, 0 아덴, 1 그라시아, 클라이언트 mapCtrl 함수로 변경됨(2016.04)
//function int GetContinent(vector loc)
//{
//	//JYLee, 2011. 11. 23.
//	//그레시아 지역 인던의 exception data 처리 수정
//	local int curContinentInScript;
//	curContinentInScript = m_MiniMap.GetPlayerContinent();
	
//	if(curContinentInScript != -1)
//		return curContinentInScript;
//	//~JYLee
	
//	if (loc.X < -163840)
//	{
//		return 1;		//Gracia
//	}
//	else
//	{
//		return 0;		//Aden
//	}
//}

// 새로 생긴 함수로 지우지 않고, 보였다 안보였다 show, hide를 하는 함수
function showAllRegionIcon(bool bShow)
{
	//Debug("--> bIsTownMap" @ bIsTownMap);
	//// 예외처리, 블랙버드 야영지(정령의 사원) 같은 경우 뭔가 지역 스크립트가 안맞는 건지 해서..
	//// 혹시 몰라서 타운 맵일때는 보이지 않도록 처리
	//if (bIsTownMap == true) bShow = false;

	m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Castle, bShow);
	m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Fortress, bShow);
	m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Agit, bShow);
	m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_HuntingZone_Base, bShow);
	m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Etc, bShow);

	// 임무에 사냥터, 레이드, 인존을 보여 줄지 여부에 따라서
	if(bShow && MinimapMissionWndScript.isShowHuntingZone())
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_HuntingZone_Mission, true);
	else 
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_HuntingZone_Mission, false);

	///if(bShow && MinimapMissionWndScript.isShowInzone())
	// [타운맵으로 전환 시 인존 & 세력 아이콘 Hide 안함]
	if(MinimapMissionWndScript.isShowInzone())
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_InstantZone, true);
	else 
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_InstantZone, false);

	if(bShow && MinimapMissionWndScript.isShowRaid())
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Raid, true);
	else 
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Raid, false);

}

// 새로 생긴 함수로 지우지 않고, 보였다 안보였다 show, hide를 하는 함수
function showRegionIcon(int nRegionType, bool bShow)
{
	if (nRegionType == EMinimapRegionType.MRT_Castle)
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Castle, bShow);

	else if (nRegionType == EMinimapRegionType.MRT_Fortress)
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Fortress, bShow);

	else if (nRegionType == EMinimapRegionType.MRT_Agit)
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Agit, bShow);

	else if (nRegionType == EMinimapRegionType.MRT_HuntingZone_Base)
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_HuntingZone_Base, bShow);

	else if (nRegionType == EMinimapRegionType.MRT_Etc)
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Etc, bShow);

	else if (nRegionType == EMinimapRegionType.MRT_HuntingZone_Mission)
	{
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_HuntingZone_Mission, bShow);
		Debug("SetShowRegionInfoByType.MRT_HuntingZone_Mission ->" @ bShow);
	}
	else if (nRegionType == EMinimapRegionType.MRT_InstantZone)
	{
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_InstantZone, bShow);
		Debug("SetShowRegionInfoByType.MRT_InstantZone ->" @ bShow);
	}

	else if (nRegionType == EMinimapRegionType.MRT_Raid)
	{
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Raid, bShow);
		Debug("SetShowRegionInfoByType.MRT_Raid ->" @ bShow);
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------
// 서버 버튼 관련 
//---------------------------------------------------------------------------------------------------------------------------------------
function initServerButton()
{
	ServerInfo01_Button.HideWindow();	
	ServerInfo02_Button.HideWindow();
	ServerInfo03_Button.HideWindow();
	ServerInfo04_Button.HideWindow();

	ServerInfo05_Button.HideWindow();
	ServerInfo06_Button.HideWindow();

	GetTextureHandle(m_WindowName $ ".texShadowTop").HideWindow();
}

function initServerInfoArray()
{
	local Vector loc;

	// 서버 정보 타입에 따라 추가
	serverInfoArray.Remove(0, serverInfoArray.Length);
	
	// 버튼 추가 순서가 바뀌면 안된다.
	// 각 버튼에 대한 기본 세팅만 해놓고, 위치 정보나 툴팁 관련 정보는 경우에 따라 업데이트 받는다.

	// 공성전
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_siege_i00", "L2UI_CT1.Minimap.map_siege_i00_Down", "L2UI_CT1.Minimap.map_siege_i00_Over",
																  MapServerInfoType.SIEGEWARFARE, GetSystemString(3534), "", loc);

	// 차원 공성전
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_siege_demension_i00", "L2UI_CT1.Minimap.map_siege_demension_i00_Down", "L2UI_CT1.Minimap.map_siege_demension_i00_Over", 
																  MapServerInfoType.SIEGEWARFARE_DIMENSION, GetSystemString(3535), GetSystemMessage(4), loc);

	// 차원 레이드
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_raid_demension_i00", "L2UI_CT1.Minimap.map_raid_demension_i00_Down", "L2UI_CT1.Minimap.map_raid_demension_i00_Over", 
																  MapServerInfoType.RAID_DIMENSION,  GetSystemString(3536), GetSystemMessage(6), loc);

	// 마검 자리체
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_cursed_weapon_i01", "L2UI_CT1.Minimap.map_cursed_weapon_i01_Down", "L2UI_CT1.Minimap.map_cursed_weapon_i01_Over", 
																  MapServerInfoType.CURSEDWEAPON_MAGICAL, MakeFullSystemMsg(GetSystemMessage(4437), GetSystemString(1464)), "", loc);

	// 혈검 아카마나프
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_cursed_weapon_i00", "L2UI_CT1.Minimap.map_cursed_weapon_i00_Down", "L2UI_CT1.Minimap.map_cursed_weapon_i00_Over", 
																  MapServerInfoType.CURSEDWEAPON_BLOOD, MakeFullSystemMsg(GetSystemMessage(4437), GetSystemString(1499)), "", loc);

	// 경매
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_auction_i00", "L2UI_CT1.Minimap.map_auction_i00_Down", "L2UI_CT1.Minimap.map_auction_i00_Over", 
																  MapServerInfoType.AUCTION, GetSystemString(3538), "", loc);

	
	// 크세르스 동맹 연합기지 방어전
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_siege_kserth_i00", "L2UI_CT1.Minimap.map_siege_kserth_i00_Down", "L2UI_CT1.Minimap.map_siege_kserth_i00_Over", 
																  MapServerInfoType.DEFENSEWARFARE, GetSystemString(3540), "", loc);



	// 마검 자리체의 보물상자 
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_cursed_treasurebox_i01", "L2UI_CT1.Minimap.map_cursed_treasurebox_i01_Down", "L2UI_CT1.Minimap.map_cursed_treasurebox_i01_Over", 
																  MapServerInfoType.CURSEDWEAPON_MAGICAL, GetSystemString(3952), "", loc);

	// 혈검 아카마나프의 보물상자
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_cursed_treasurebox_i00", "L2UI_CT1.Minimap.map_cursed_treasurebox_i00_Down", "L2UI_CT1.Minimap.map_cursed_treasurebox_i00_Over", 
																  MapServerInfoType.CURSEDWEAPON_BLOOD, GetSystemString(3953), "", loc);

}

// 서버 정보 타입별 정보를 채운다.
function MapServerInfo setServerInfoButton(bool bUse, string normalTex, string pushedTex, string highlightTex, int nServerInfoType, 
										   string toolTipString, string buttonName, Vector clickedLoc)
{
	local MapServerInfo severInfo;
	
	severInfo.bUse = bUse;
	
	severInfo.normalTex = normalTex;
	severInfo.pushedTex = pushedTex;
	severInfo.highlightTex = highlightTex;
	severInfo.nServerInfoType = nServerInfoType;
	severInfo.toolTipString = toolTipString;
	severInfo.buttonName = buttonName;

	//severInfo.clickedLocArray[0] = clickedLoc;
	severInfo.clickedLocClickCount = 0;

	return severInfo;
}

// 실제로 맵에 서버 버튼을 배치 하는 기능
function setServerButton(ButtonHandle serverButton, int nServerInfoType, MapServerInfo mServerInfo)
{
	//Debug("mServerInfo.bUse" @ mServerInfo.bUse);
	if(mServerInfo.bUse)
	{		
		// Debug("serverButton Show " @ serverButton.GetWindowName());
		serverButton.ShowWindow();
		serverButton.SetTexture(mServerInfo.normalTex, mServerInfo.pushedTex, mServerInfo.highlightTex);	
		serverButton.SetTooltipCustomType(MakeTooltipSimpleText(mServerInfo.toolTipString));
		//serverButton.SetTooltipText(mServerInfo.toolTipString);

		// 현재 서버 버튼
		serverInfoArray[nServerInfoType].buttonName = serverButton.GetWindowName();

		//Debug("mServerInfo.toolTipString" @ mServerInfo.toolTipString);
	}
}

// 마검이나 혈검이 활성화 되어 있나?
function bool isActiveCursedWeapon()
{
	local int i;

	for (i = 0; i < serverInfoArray.Length; i++)
	{		
		// 마검 혈검이 활성화 되어 있다면...
		if (serverInfoArray[i].nServerInfoType == MapServerInfoType.CURSEDWEAPON_MAGICAL || 
			serverInfoArray[i].nServerInfoType == MapServerInfoType.CURSEDWEAPON_BLOOD ||
			serverInfoArray[i].nServerInfoType == MapServerInfoType.CURSEDWEAPON_MAGICAL_TreasureBox ||
			serverInfoArray[i].nServerInfoType == MapServerInfoType.CURSEDWEAPON_BLOOD_TreasureBox)
		{
			if(serverInfoArray[i].bUse)
			{
				Debug("-> 마검 혈검이 활성화 되어 있음");
				return true;
			}
		}
	}

	return false;
}

// 크세르스 요세에서 받은 systemMessage를 받기 위해서 사용
// getServerNData(MapServerInfoType.DEFENSEWARFARE)
function int getServerNData(int serverInfoType)
{
	local int i;

	for (i = 0; i < serverInfoArray.Length; i++)
	{		
		// 마검 혈검이 활성화 되어 있다면...
		if (serverInfoArray[i].nServerInfoType == serverInfoType)
		{
			return serverInfoArray[i].nData;
		}
	}

	return 0;
}

// 클릭: 서버 정보 버튼 
function clickServerInfoButton(string clickButtonName)
{
	local int i, n, clickCount, addIconX, addIconY;
	local MinimapRegionIconData iconData, emptyIconData;

	for (i = 0; i < serverInfoArray.Length; i++)
	{		
		if(serverInfoArray[i].buttonName == clickButtonName)
		{
			Debug("버튼 누름 (서버 버튼) , 서버타입은?:" @ serverInfoArray[i].nServerInfoType @ ", click Array :" @ serverInfoArray[i].clickedLocArray.Length );
			Debug("nRegionID" @ serverInfoArray[i].nRegionID);

			if(serverInfoArray[i].clickedLocArray.Length > 0)
			{
				clickCount = serverInfoArray[i].clickedLocClickCount;
				iconData = emptyIconData;
				addIconX = 0;
				addIconY = 0;

				Debug("serverInfoArray[i].clickedLoc.x " @ serverInfoArray[i].clickedLocArray[clickCount].x);
				Debug("serverInfoArray[i].clickedLoc.y " @ serverInfoArray[i].clickedLocArray[clickCount].y);
				Debug("serverInfoArray[i].clickedLoc.z " @ serverInfoArray[i].clickedLocArray[clickCount].z);

				// 하나라도 0과 같지 않다면.. 위치로 이동
				if (serverInfoArray[i].clickedLocArray[clickCount].x != 0 ||
					serverInfoArray[i].clickedLocArray[clickCount].y != 0 ||
					serverInfoArray[i].clickedLocArray[clickCount].z != 0)
				{					
					// 헌팅존 인덱스가 있는 서버 정보면.. 맵 포커싱 하일라이트를 위해..
					if (serverInfoArray[i].nRegionID > 0)
					{
						GetMinimapRegionIconData(serverInfoArray[i].nRegionID, iconData);
					}

					if (serverInfoArray[i].nServerInfoType == MapServerInfoType.CURSEDWEAPON_MAGICAL || 
						serverInfoArray[i].nServerInfoType == MapServerInfoType.CURSEDWEAPON_BLOOD || 
						serverInfoArray[i].nServerInfoType == MapServerInfoType.CURSEDWEAPON_MAGICAL_TreasureBox || 
						serverInfoArray[i].nServerInfoType == MapServerInfoType.CURSEDWEAPON_BLOOD_TreasureBox
						)
					{
						Debug("--> 마검 혈검 서버 버튼으로 갱신");
						requestCursedWeapon();

						SetLocContinent(serverInfoArray[i].clickedLocArray[clickCount]);	
						// 마검 혈검은 그리드 방식으로 출력하기 때문에 하일라이팅 표시를 하지 않는다.
					}
					else
					{
						SetLocContinent(serverInfoArray[i].clickedLocArray[clickCount]);	
						mapIconHighlight(serverInfoArray[i].clickedLocArray[clickCount], iconData, addIconX, addIconY);
					}

					OnClickReduceButton();
					class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", serverInfoArray[i].clickedLocArray[clickCount], false);

				}
				else
				{
					// 위치 정보가 없어 표시할 수 없습니다.
					AddSystemMessage(4431);
				}
				if (serverInfoArray[i].clickedLocArray.Length > serverInfoArray[i].clickedLocClickCount + 1)
					serverInfoArray[i].clickedLocClickCount++;
				else 
					serverInfoArray[i].clickedLocClickCount = 0;
			}

			break;
		}
	}
}

// 서버 정보 버튼 갱신
function refreshServerInfoButton()
{
	local int i;
	local bool bUse;

	// 버튼을 다 비우고 다시 갱신
	initServerButton();
	for (i = 0; i < serverInfoArray.Length; i++)
	{		
		setServerButton(getServerInfoButton(), i, serverInfoArray[i]);

		if (serverInfoArray[i].bUse) bUse = true;
	}

	// 서버 정보 버튼이 잘보이게 어두운 쉐도우를 버튼이 하나라도 있으면 보이게 한다.
	if (bUse) GetTextureHandle(m_WindowName $ ".texShadowTop").ShowWindow();
	else GetTextureHandle(m_WindowName $ ".texShadowTop").HideWindow();
}

function ButtonHandle getServerInfoButton()
{
	if (!ServerInfo01_Button.IsShowWindow()) return ServerInfo01_Button;
	if (!ServerInfo02_Button.IsShowWindow()) return ServerInfo02_Button;
	if (!ServerInfo03_Button.IsShowWindow()) return ServerInfo03_Button;
	if (!ServerInfo04_Button.IsShowWindow()) return ServerInfo04_Button;
	if (!ServerInfo05_Button.IsShowWindow()) return ServerInfo05_Button;
	if (!ServerInfo06_Button.IsShowWindow()) return ServerInfo06_Button;

	Debug("MAP 서버 버튼이 가득 찼습니다. 6번 버튼에 덥어 씁니다.");
	return ServerInfo06_Button;

}

// 서버로 부터 정보가 들어 오면 그걸 파싱해서 맵서버 정보 구조체에 넣고,
// 그걸 바탕으로 비어 있는 서버 버튼에 보여 주는 방식이다.
function setServerParse(int serverInfoType, string param, bool bUse, optional Vector clickedLoc, optional int nRegionID, optional int nData)
{
	// 공성전
	if (serverInfoType == MapServerInfoType.SIEGEWARFARE)
	{
		if (bUse)
		{
			serverInfoArray[serverInfoType].bUse = true;
			// 공성중 성 목록을 넣었다가 툴팁으로 씀.
			if(serverInfoArray[serverInfoType].szReserved == "")
				serverInfoArray[serverInfoType].szReserved = param;
			else
				serverInfoArray[serverInfoType].szReserved = serverInfoArray[serverInfoType].szReserved $ "," $ param;

			serverInfoArray[serverInfoType].toolTipString =	GetSystemString(3534) $ " : " $ serverInfoArray[serverInfoType].szReserved;
			if (nRegionID > 0) serverInfoArray[serverInfoType].nRegionID = nRegionID;
			serverInfoArray[serverInfoType].clickedLocArray[serverInfoArray[serverInfoType].clickedLocArray.Length] = clickedLoc;

			Debug("clickedLoc x" @ clickedLoc.x);
			Debug("clickedLoc y" @ clickedLoc.y);
			Debug("clickedLoc z" @ clickedLoc.z);
		}
	}

	// 차원 공성전
	else if (serverInfoType == MapServerInfoType.SIEGEWARFARE_DIMENSION)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		if (bUse)
		{
			//// 공성중 성 목록을 넣었다가 툴팁으로 씀.
			//if(serverInfoArray[serverInfoType].szReserved == "")
			//	serverInfoArray[serverInfoType].szReserved = param;
			//else
			//	serverInfoArray[serverInfoType].szReserved = serverInfoArray[serverInfoType].szReserved $ "," $ param;

			// serverInfoArray[serverInfoType].toolTipString =	GetSystemString(3534) $ " : " $ serverInfoArray[serverInfoType].szReserved;
			//if (nRegionID > 0) serverInfoArray[serverInfoType].nRegionID = nRegionID;
			//serverInfoArray[serverInfoType].clickedLocArray[0] = setVector(147457, 990, 216);    // 아덴성
			//serverInfoArray[serverInfoType].clickedLocArray[1] = setVector(14032, -49151, 976);  // 루운성

			serverInfoArray[serverInfoType].clickedLocArray[0] = setVector(147461, 8000, -592);    // 아덴성			
			serverInfoArray[serverInfoType].clickedLocArray[1] = setVector(14659, -49230, -160);  // 루운성
		}
	}

    // 차원 레이드
	else if (serverInfoType == MapServerInfoType.RAID_DIMENSION)
	{
		serverInfoArray[serverInfoType].bUse = bUse;

		serverInfoArray[serverInfoType].clickedLocArray[0] = setVector(116503, 75392, -2712);    // 사냥꾼의 마을 메를로		
	}

	// 마검 자리체
	else if (serverInfoType == MapServerInfoType.CURSEDWEAPON_MAGICAL)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		serverInfoArray[serverInfoType].clickedLocArray[0] = clickedLoc;
	}

	// 혈검 자리체
	else if (serverInfoType == MapServerInfoType.CURSEDWEAPON_BLOOD)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		serverInfoArray[serverInfoType].clickedLocArray[0] = clickedLoc;
	}

	// 마검 자리체의 보물상자
	else if (serverInfoType == MapServerInfoType.CURSEDWEAPON_MAGICAL_TreasureBox)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		serverInfoArray[serverInfoType].clickedLocArray[0] = clickedLoc;
	}

	// 혈검 아카마나프의 보물상자
	else if (serverInfoType == MapServerInfoType.CURSEDWEAPON_BLOOD_TreasureBox)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		serverInfoArray[serverInfoType].clickedLocArray[0] = clickedLoc;
	}

	// 경매
	else if (serverInfoType == MapServerInfoType.AUCTION)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		serverInfoArray[serverInfoType].clickedLocArray[0] = clickedLoc; //setVector(80323, 145501, -3504);
	}

	// 크세르스 동맹 연합기지 방어전
	else if (serverInfoType == MapServerInfoType.DEFENSEWARFARE)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		serverInfoArray[serverInfoType].clickedLocArray[0] = setVector(-184750, 240723, 1568);
		serverInfoArray[serverInfoType].nData = nData; // 크세르스 동맹 기지에 대한 시스템 메세지를 받음
	}

	// 서버 버튼 갱신
	refreshServerInfoButton();

}
//--------------------------------------------------------------------------------------------------------------------------------------
// 맵에 아이콘 그리기 
//--------------------------------------------------------------------------------------------------------------------------------------

// 실제 미니맵에 그리라고 넣을 구조체
function drawMinimapRegionInfo(EMinimapRegionType nMinimapRegionType, int i, optional bool bActive, optional bool bUseUpdate)
{
	local HuntingZoneUIData huntingZoneData;
	local MinimapRegionInfo regionInfoForMapIcon;
	local string toolTipParam;
	local bool bEnableLevel;
	local UserInfo pUserInfo;

	local MinimapRegionIconData iconData;
	local RaidUIData raidData;

	class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);

	GetPlayerInfo ( pUserInfo );

	// 헌팅 존 미션 아이콘 
	regionInfoForMapIcon.eType = nMinimapRegionType;
	regionInfoForMapIcon.nIndex = i; //huntingZoneData.nSearchZoneID;
	regionInfoForMapIcon.strDesc = "";
	
	// 툴팁 생성
	toolTipParam = "";

	if(nMinimapRegionType == EMinimapRegionType.MRT_HuntingZone_Mission)
	{
		// 레벨 체크 
		bEnableLevel = tryLevelCheck(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel);

		if (bEnableLevel)
		{
			ParamAdd(toolTipParam, "Type", String(nMinimapRegionType));
			ParamAdd(toolTipParam, "Index", String(i));

			// 아이콘 생성
			iconData = makeMapIcon(nMinimapRegionType, bEnableLevel, huntingZoneData.nWorldLoc);

			regionInfoForMapIcon.IconData = iconData;
			regionInfoForMapIcon.strTooltip = toolTipParam;

			// 실제 맵에 그리기
			addMapIcon(regionInfoForMapIcon, bUseUpdate);
		}
		
	}
	else if(nMinimapRegionType == EMinimapRegionType.MRT_InstantZone)
	{
		// 레벨 체크 
		bEnableLevel = tryLevelCheck(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel);

		if (bEnableLevel)
		{
			ParamAdd(toolTipParam, "Type", String(nMinimapRegionType));
			ParamAdd(toolTipParam, "Index", String(i));
			ParamAdd(toolTipParam, "Active", String(boolToNum(bActive)));

			// 아이콘 생성
			iconData = makeMapIcon(nMinimapRegionType, bActive, huntingZoneData.nWorldLoc);

			regionInfoForMapIcon.IconData = iconData;
			regionInfoForMapIcon.strTooltip = toolTipParam;

			// 실제 맵에 그리기
			addMapIcon(regionInfoForMapIcon, bUseUpdate);
		}
	}
	else if(nMinimapRegionType == EMinimapRegionType.MRT_Raid)
	{
		// 블러디 서버에서는 레이드 정보 표시 안함
		// if(IsBloodyServer()) return;

		raidData = getRaidDataByIndex(i);

		// 레벨 체크 
		bEnableLevel = tryLevelCheck(pUserInfo.nLevel, raidData.nMinLevel, raidData.nMaxLevel);

		if (bEnableLevel)
		{
			ParamAdd(toolTipParam, "Type", String(nMinimapRegionType));
			ParamAdd(toolTipParam, "Index", String(i));
			ParamAdd(toolTipParam, "active", String(boolToNum(bActive)));

			// Debug("toolTipParam" @ toolTipParam);
		
			// 아이콘 생성
			iconData = makeMapIcon(nMinimapRegionType, bActive, raidData.nWorldLoc);

			regionInfoForMapIcon.IconData = iconData;
			regionInfoForMapIcon.strTooltip = toolTipParam;

			// 실제 맵에 그리기
			addMapIcon(regionInfoForMapIcon, bUseUpdate);
			
			CallGFxFunction("MiniMapGfxWnd","drawMinimapRegionInfo",MakeMapIconParam(i,raidData.nWorldLoc));
		}
	}
}

function string MakeMapIconParam (int Index, Vector vec)
{
	local string param;

	param = "";
	param = GetLocParam(vec);
	ParamAdd(param,"Index",string(Index));
	return param;
}

function string GetLocParam (Vector vec)
{
	local string param;

	param = "";
	ParamAdd(param,"X",string(vec.X));
	ParamAdd(param,"Y",string(vec.Y));
	ParamAdd(param,"Z",string(vec.Z));
	return param;
}

// 맵안에 찍히는 핀 타입의 아이콘 (깃발, 레이드 몬스터, 인턴 아이콘.. )
function MinimapRegionIconData makeMapIcon(int iconType, bool bActive, Vector pLoc)
{
	local MinimapRegionIconData iconData;

	local HuntingZoneUIData huntingZoneData;
	
	iconData.nWidth = 32;
	iconData.nHeight = 32;
	iconData.nWorldLocX = pLoc.x;// - iconData.nIconOffsetX; // 3197;  // - 3197 은 기획(조중곤), 16픽셀에 해당하는값.
	iconData.nWorldLocY = pLoc.y;// - iconData.nIconOffsetY; // 3197;
	iconData.nWorldLocZ = pLoc.z;
    iconData.nIconOffsetX = -16;
    iconData.nIconOffsetY = -16;

	//iconData.toolTipParam = toolTipString;

	if (iconType == EMinimapRegionType.MRT_HuntingZone_Mission)
	{
		if (bActive)
		{
			// 파란 깃발
			iconData.strIconNormal = "L2UI_CT1.Minimap.map_huntingzone_i00";
			iconData.strIconOver   = "L2UI_CT1.Minimap.map_huntingzone_i00_Over";
			iconData.strIconPushed = "L2UI_CT1.Minimap.map_huntingzone_i00";
		}
		else
		{
			// 사용 안함.
			// 회색 깃발
			iconData.strIconNormal = "L2UI_CT1.Minimap.map_huntingzoneInactive_i00";
			iconData.strIconOver   = "L2UI_CT1.Minimap.map_huntingzoneInactive_i00_Over";
			iconData.strIconPushed = "L2UI_CT1.Minimap.map_huntingzoneInactive_i00";
		}
	}
	else if (iconType == EMinimapRegionType.MRT_InstantZone)
	{
		if (bActive)
		{		
			//debug("밝은 인존 사용..");
			iconData.strIconNormal = "L2UI_CT1.Minimap.map_inzone_gate_i00";
			iconData.strIconOver   = "L2UI_CT1.Minimap.map_inzone_gate_i00_Over";
			iconData.strIconPushed = "L2UI_CT1.Minimap.map_inzone_gate_i00";
		}
		else
		{
			//debug("칙칙한 인존 사용..");
			iconData.strIconNormal = "L2UI_CT1.Minimap.map_inzone_gateInactive_i00";
			iconData.strIconOver   = "L2UI_CT1.Minimap.map_inzone_gateInactive_i00_Over";
			iconData.strIconPushed = "L2UI_CT1.Minimap.map_inzone_gateInactive_i00";
		}
	}
	else if (iconType == EMinimapRegionType.MRT_Raid)
	{
		if (bActive)
		{
			// 파란 깃발
			iconData.strIconNormal = "L2UI_CT1.Minimap.map_raid_spawning_i00";
			iconData.strIconOver   = "L2UI_CT1.Minimap.map_raid_spawning_i00_Over";
			iconData.strIconPushed = "L2UI_CT1.Minimap.map_raid_spawning_i00";
		}
		else
		{
			// 회색 깃발
			iconData.strIconNormal = "L2UI_CT1.Minimap.map_raid_respawn_i00";
			iconData.strIconOver   = "L2UI_CT1.Minimap.map_raid_respawn_i00_Over";
			iconData.strIconPushed = "L2UI_CT1.Minimap.map_raid_respawn_i00";
		}
	}

	return iconData;
}

function MinimapRegionInfo makeFocusMapIcon( Vector pLoc, optional bool bEmpty )
{
	local MinimapRegionInfo regionInfoForMapIcon;
	local MinimapRegionIconData iconData;

	regionInfoForMapIcon.eType = EMinimapRegionType.MRT_Etc;
	regionInfoForMapIcon.nIndex = OTHER_HIGHLIGHT_ICON_INDEX; 

	iconData.nWidth = 64;
	iconData.nHeight = 64;
	iconData.nWorldLocX = pLoc.x;
	iconData.nWorldLocY = pLoc.y;
	iconData.nWorldLocZ = pLoc.z;

	// 롤오버가 안되도록..(툴팁 가려지지 않게)
	//iconData.bUseMouseAction = false;
	iconData.bIgnoreMouseInput = true;
    //iconData.nIconOffsetX = -32;
    //iconData.nIconOffsetY = -32;
	
	if(bEmpty)
	{
		iconData.strIconNormal = "L2UI_CT1.EmptyBtn";
		iconData.strIconOver   = "L2UI_CT1.EmptyBtn";
		iconData.strIconPushed = "L2UI_CT1.EmptyBtn";	
	}
	else
	{
		iconData.strIconNormal = "L2UI_CT1.Minimap.map_SelectAni01";
		iconData.strIconOver   = "L2UI_CT1.Minimap.map_SelectAni01";
		iconData.strIconPushed = "L2UI_CT1.Minimap.map_SelectAni01";	
	}

	regionInfoForMapIcon.iconData = IconData ;
	return regionInfoForMapIcon ;
}

function mapIconHighlight(Vector loc, optional MinimapRegionIconData iconData, optional int addIconPosX, optional int addIconPosY)
{
	local MinimapRegionInfo regionInfoForMapIcon;

	m_MiniMap.EraseRegionInfoCtrl(EMinimapRegionType.MRT_Etc, OTHER_HIGHLIGHT_ICON_INDEX) ;

	regionInfoForMapIcon = makeFocusMapIcon (loc);

	regionInfoForMapIcon.IconData.nIconOffsetX = -32 + (iconData.nWidth / 2)  + addIconPosX;
	regionInfoForMapIcon.IconData.nIconOffsetY = -32 + (iconData.nHeight / 2) + addIconPosY;

	m_MiniMap.AddRegionInfoCtrl(regionInfoForMapIcon);

	Me.KillTimer( TIMER_ID );
	Me.SetTimer(TIMER_ID, TIMER_DELAY);
}

function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID)
	{
		m_MiniMap.EraseRegionInfoCtrl(EMinimapRegionType.MRT_Etc, OTHER_HIGHLIGHT_ICON_INDEX) ;
		Me.KillTimer( TIMER_ID );
	}
}

//Description: 
// * To Hide the minimap at certain location.
function bool IsHideMinimapZone(int nZoneID)
{	
	// Debug( "IsHideMinimapZone" @ nZoneID);
	switch(nZoneID)
	{ 
		//case 363:		//헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 364:		//헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 365:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 366:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 367:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 368:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 369:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 370:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 371:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 372:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 373:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 374:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 375:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 376:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 377:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 378:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		case 453:		// 공간의 탑
		case 454:		// 공간의 탑
		case 455:		// 톨레스의 공작소
		case 456:		// 톨레스의 공작소
		case 457:		// 나이아의 탑
		case 458:		// 나이아의 탑
			return true;
		default:
			return false;
	}		
}

//Description: 
// * To Hide the minimap at certain location.
function bool IsHideMinimapZone_new(int nZoneID)
{	
	//Debug( "IsHideMinimapZone_new" @ nZoneID);
	switch(nZoneID)
	{
		//case 363:		//헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 364:		//헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 365:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 366:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 367:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 368:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 369:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 370:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 371:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 372:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 373:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 374:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 375:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 376:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 377:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		//case 378:     //헬바운드 GD3.5 2013-04-09 헬바운드도 일반 유저들에게 레이더 맵 공개
		case 453:		// 공간의 탑
		case 454:		// 공간의 탑
		case 455:		// 톨레스의 공작소
		case 456:		// 톨레스의 공작소
		case 457:		// 나이아의 탑
		case 458:		// 나이아의 탑
			return true;
		default:
			return false;
	}		
}

// 노란 핀 꼽고 툴팁 보여주기 ,퀘스트 관련 정보의 위치를 보여주는 용도로 MRT_Quest 추가
function showYellowPin (Vector XYZ, string tooltipString, string tooltipString2) 
{
	//local Vector XYZ;
	//local int x, y, z;
	
	//local MinimapCtrlHandle m_MiniMap;
	//local MinimapWnd mapScript ;
	local MinimapRegionInfo regionInfoForMapIcon;

	//mapScript = MinimapWnd( GetScript( "MinimapWnd"));

	//m_MiniMap = GetMinimapCtrlHandle( "MinimapWnd.Minimap" );

	if (!GetWindowHandle("MinimapWnd").IsShowWindow()) GetWindowHandle("MinimapWnd").ShowWindow();
	
	// 위치 이동	
	SetContinent(m_MiniMap.GetContinent(XYZ));	
	class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", XYZ, false );
	
	//m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Etc, true);
	m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Quest, true);

	regionInfoForMapIcon = makeYellowPinRegionInfo (XYZ, tooltipString, tooltipString2);
	m_MiniMap.EraseRegionInfoCtrl(EMinimapRegionType.MRT_Quest, QUEST_START_NPC_ICON_INDEX) ;
	m_MiniMap.AddRegionInfoCtrl(regionInfoForMapIcon);	
}

// 노란 핀 숨기기 
function hideYellowPin () 
{
	//m_MiniMap.EraseRegionInfoCtrl(EMinimapRegionType.MRT_Etc, QUEST_START_NPC_ICON_INDEX) ;
	m_MiniMap.EraseRegionInfoCtrl(EMinimapRegionType.MRT_Quest, QUEST_START_NPC_ICON_INDEX) ;
}

// 시작 NPC 위치 아이콘 만들기
function MinimapRegionInfo makeYellowPinRegionInfo(Vector pLoc, string tooltipString, optional string tooltipString2)
{
	local MinimapRegionInfo regionInfoForMapIcon;
	local MinimapRegionIconData iconData;
	local string toolTipParam;

	toolTipParam = "";	
	ParamAdd(toolTipParam, "tooltipString", tooltipString);
	ParamAdd(toolTipParam, "tooltipString2", tooltipString2);
	//ParamAdd(toolTipParam, "Type", String ( int ( EMinimapRegionType.MRT_Etc )));	
	ParamAdd(toolTipParam, "Type", String ( int ( EMinimapRegionType.MRT_Quest )));	
	regionInfoForMapIcon.strTooltip = toolTipParam;

	//regionInfoForMapIcon.eType = EMinimapRegionType.MRT_Etc;

	regionInfoForMapIcon.eType = EMinimapRegionType.MRT_Quest;
	regionInfoForMapIcon.nIndex = QUEST_START_NPC_ICON_INDEX; // 유일 값이어야 한다.
	//regionInfoForMapIcon.strDesc = "테스트어쩌고 감감감";

	iconData.nWidth = 32;
	iconData.nHeight = 32;
	iconData.nWorldLocX = pLoc.x;// - iconData.nIconOffsetX; // 3197;  // - 3197 은 기획(조중곤), 16픽셀에 해당하는값.
	iconData.nWorldLocY = pLoc.y;// - iconData.nIconOffsetY; // 3197;
	iconData.nWorldLocZ = pLoc.z;
	iconData.nIconOffsetX = -3;
    iconData.nIconOffsetY = -20;

	// 노란 핀
	iconData.strIconNormal = "L2UI_CT1.Minimap_DF_Icon_Pin_Destination_over";
	iconData.strIconOver   = "L2UI_CT1.Minimap_DF_Icon_Pin_Destination";
	iconData.strIconPushed = "L2UI_CT1.Minimap_DF_Icon_Pin_Destination_over";		

	regionInfoForMapIcon.iconData = IconData ;
	return regionInfoForMapIcon ;
}



function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}
**/

defaultproperties
{
}
