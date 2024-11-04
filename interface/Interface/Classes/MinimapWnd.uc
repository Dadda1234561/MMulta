//------------------------------------------------------------------------------------------------------------------------------------------
//    
//    ����� ( ������ ) 2016-04, Ȯ�� ���� ���� �ϰ� ����
//
//
// ex)
//���� ���� ���� ��ɾ�, �� ���� Ÿ���� �ϰ�, ����, ������ ���Ϳ� �ɾ�ΰ�, ���̸� ���� ��������.
//give_cursed_weapon 8190
//give_cursed_weapon 8689
//
// ����
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

// �� ���� ����
struct CursedWeapon
{
	var bool bDrop;  // ����, ���˸� ���

	var string name;
	var int npcID;
	var int itemClassID;
	var int isowned;

	var int x;
	var int y;
	var int z;

	var INT64  fixedAdena;
	var INT64  variableAdena;

	// ���� ���� Ÿ��
	var int nServerInfoType;

	var Vector loc;
	var string eventParam;
};


var string m_WindowName;
var int m_PartyMemberCount;
var int m_PartyLocIndex;
var int isNoShowMissionWindow;
var bool m_AdjustCursedLoc;

var bool m_bShowCurrentLocation;	// ������ġ �����ٰ��ΰ��� ��Ť�4���ϴ� ����
var bool m_bShowGameTime;			// ����ð� �����ٰ��ΰ��� ����ϴ� ����
//var bool bHaveItem;					//������ ��������
var bool bMiniMapDisabled;			//�̴ϸ� ��� �Ұ� ����
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

var int CurrentLayer;               //ldw �׽�Ʈ ���� ��ġ �� ����
var int TotalLayers;                //ldw �׽�Ʈ �̳��ʿ� ���� ���� ���� ������ ��� �� �� ��

//var int TUTORIALQUEST[5];           //LDW Ʃ�丮�� ����Ʈ ���� ���� 
//var string TUTORIALQUEST_NPC_Name;  //LDW Ʃ�丮�� ����Ʈ NPC 1202 �׽�Ʈ �� �Ѵ� �� ���� ���
//var string TutorialQuestParam;    //ldw Ʃ�丮�� ����Ʈ 1202 �׽�Ʈ �� �Ѵ� �� ���� ���

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

// ���� ����, ��ư
var ButtonHandle ServerInfo01_Button;
var ButtonHandle ServerInfo02_Button;
var ButtonHandle ServerInfo03_Button;
var ButtonHandle ServerInfo04_Button;

var ButtonHandle ServerInfo05_Button;
var ButtonHandle ServerInfo06_Button;


// ���� ������ �� Ÿ�Կ� ���� �ϳ��� �ڸ��� ����� ���´�. 7�� Ÿ���� ���� ������ ������.. 7����..
var array<MapServerInfo> serverInfoArray;

//var WindowHandle 	MiniMapDrawerWnd;

///ldw �߰� 
var Vector	QuestLocation;

// ���� ������ ��û �� �� Ÿ�̸� �Լ� ~ldw
var int DelayRequestSeedInfo;

//ldw �߰� ���� ������ ������( ���� ���� request �� ���� ) 
var array<string> SeedDataforMap;

var TextureHandle TabBg_Line;

// ��ġ,nx, ny�� ����ϱ� ���� ���� 
var Rect smallMapRect;

var MinimapMissionWnd MinimapMissionWndScript;

var bool bCompleteBaseElementShow;
var bool bIsTownMap;
var int  nTownMapZoneID;

var MinimapCtrlHandle TeleportBookMarkWnd_MiniMap;

// ����, ����, ��������(����), ��������(����), �� 4�� Ÿ��
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

	// ���� ����
	RegisterEvent( EV_MinimapCursedWeaponList );
	RegisterEvent( EV_MinimapCursedWeaponLocation );

	// ���� ���� ��, �������� ��ġ 
	RegisterEvent( EV_MinimapTreasureBoxLocation );



	// ZoneName �� �ٲ�� ������ġ ������Ʈ �ؾ��ϹǷ�
	RegisterEvent( EV_BeginShowZoneTitleWnd );		

	// ��ü�ʰ� �������� ������ ��� ���� �̺�Ʈ
	RegisterEvent( EV_MinimapShowReduceBtn );
	RegisterEvent( EV_MinimapHideReduceBtn );

	RegisterEvent( EV_MinimapUpdateGameTime );
	RegisterEvent( EV_MinimapTravel );	
	RegisterEvent( EV_MinimapRegionInfoBtnClick );

	 RegisterEvent( EV_ShowFortressMapInfo );
	 RegisterEvent( EV_FortressMapBarrackInfo);
	 RegisterEvent( EV_ShowFortressSiegeInfo );

	RegisterEvent( EV_SystemMessage );	

	//ldw �׽�Ʈ ���� Ÿ���� ���� ��
	RegisterEvent( EV_MinimapShowMultilayer ); 
	//ldw �׽�Ʈ ���� Ÿ������ ������ ���
	RegisterEvent( EV_MinimapCloseMultilayer );

	RegisterEvent( EV_GamingStateEnter );
	registerEvent( EV_ResolutionChanged);

	// ������ �۾� 
	//
	// ���� ����
	RegisterEvent(EV_AddCastleInfo);

	// ���
	RegisterEvent(EV_AddFortressInfo);

	// ����Ʈ
	RegisterEvent(EV_AddAgitSiegeInfo);	

	// ����, ũ������ ����
	RegisterEvent( EV_ShowSeedMapInfo );

	// ���� ���̵�, ���� ������ ���� ����
	RegisterEvent( EV_RaidServerInfo );

	// ��� ����
	RegisterEvent( EV_ItemAuctionStatus );

	// Ŭ���ʿ� Ȯ�� ��� ��� ���Ѵ���.
	//ldw Ʃ�丮�� ����Ʈ ���� �̺�Ʈ ���� ����Ÿ ����� �̺�Ʈ�� ���� ���⿡ �̺�Ʈ ��ġ. ����Ÿ ����� �̺�Ʈ �� �׽� ����Ʈ Ʃ�丮���� �˻� �ϰ� ��Ÿ���� ��. Ȯ�� ���� �ѹ� ��Ÿ���� ����� ��.
	//RegisterEvent( EV_NotifyTutorialQuest ); 
	//RegisterEvent( EV_ClearTutorialQuest ); //ldw Ʃ�丮�� ���� �̺�Ʈ

	//������ ���� ������
	RegisterEvent( EV_NeedResetUIData );

	RegisterEvent( EV_FactionInfo );

	RegisterEvent( EV_Restart );


	// http://wallis-devsub/redmine/issues/3707
	// ��ġ �˸� ȭ��ǥ(TargetDirectionIcon) Ŭ�� ��.. 
	RegisterEvent( EV_MinimapAdjustViewLocation );


	//RegisterEvent( EV_Test_2 );

	RegisterEvent( EV_GameStart );


	
	// RegisterEvent( EV_ShowCursedBarrierInfo );


	// RegisterEvent( EV_ShowPrisonOfSoulDialogBox );	
}

// �ű�, ���� ����
function initByServer()
{
	if (IsBloodyServer())
	{
		// ���� ���� ��ư ���� 
		GetButtonHandle("MinimapWnd.OpenGuideWnd").HideWindow();
	}
	else 
	{
		GetButtonHandle("MinimapWnd.OpenGuideWnd").ShowWindow();
	}
}

function OnLoad()
{
	local Color txtVarCurLocColor;//ldw txtVarCurLoc ���� ����
	return;
	SetClosingOnESC();

	MinimapMissionWndScript = MinimapMissionWnd(GetScript("MinimapMissionWnd"));

	// �ϵ��ڵ� ����Ÿ �ε� (���� ��ũ��Ʈ�� ����..)
	//SetCastleLocData();

	// �ϵ� �ڵ��� Array ������ �б� (onLoad���� �ϸ� �ɵ�..)
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

	// ���� ��ư
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
	
	// ��ٿ�� �� Ȯ�� ����. 
	BlockedLoc1.x = -32768f;
	BlockedLoc1.y = 32768f;
	BlockedLoc2.x = 229376f;
	BlockedLoc2.y = 262144f;
	bMiniMapDisabled = true;

	// ini �ʱ�ȭ(�ѹ��� �е���..)
	isNoShowMissionWindow = -1;

	//DrawCleftStatus();
	
	txtVarCurLocColor.R = 254;//ldw ���� ��ġ ����
	txtVarCurLocColor.G = 243;
	txtVarCurLocColor.B = 124;

	class'UIAPI_TEXTBOX'.static.SetTextColor("Minimapwnd.txtVarCurLoc",txtVarCurLocColor);//ldw ���� ��ġ �ؽ�Ʈ ���� ��ü

	// ���� ����,�������� 4��
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
		case EV_BeginShowZoneTitleWnd: //�� ������ �ٲ� ��			
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
			//Debug("minimap" @ "EV_ShowMinimap" @ a_Param );//���� Ÿ�� ��
			//Debug("EV_ShowMinimap");//ldw ����Ÿ���
			//CloseMultilayer();//ldw ����Ÿ��� �޺� �ڽ� �ݰ� ���� �ϱ�
			G_ZoneID2 = GetCurrentZoneID();
			HandleShowMinimap( a_Param );
			break;

		case EV_PartyMemberChanged:             //��Ƽ �ɹ��� �ٲ� ��.
			//Debug("minimap" @ "EV_PartyMemberChanged" @ a_Param );			
			HandlePartyMemberChanged( a_Param );
			break;

		case EV_MinimapAddTarget:               //�̴ϸʿ� Ÿ���� ���� �� ��.
			//Debug("minimap" @ "EV_MinimapAddTarget" @ a_Param );
			HandleMinimapAddTarget( a_Param );
			break;

		case EV_MinimapDeleteTarget:            //�̴ϸʿ� Ÿ���� ���� �� ��.	
			//Debug("minimap" @ "EV_MinimapDeleteTarget" @ a_Param );
			HandleMinimapDeleteTarget( a_Param );
			break;
		case EV_MinimapDeleteAllTarget:         //�̴ϸʿ� Ÿ���� ��� ���� �� ��.					
			//Debug("minimap" @ "EV_MinimapDeleteAllTarget" @ a_Param );
			HandleMinimapDeleteAllTarget();
			break;

		//�̴ϸ� ����Ʈ ����;
		case EV_MinimapShowQuest:		        
			//Debug("minimap" @ "EV_MinimapShowQuest" @ a_Param );
			HandleMinimapShowQuest();
			break;

		//�̴ϸ� ����Ʈ �����.
		case EV_MinimapHideQuest:	            
			//Debug("minimap" @ "EV_MinimapHideQuest" @ a_Param );
			HandleMinimapHideQuest();
			break;

		//�̴ϸ� �� �ٲ� ��.			
		case EV_MinimapChangeZone :             
			AdjustMapToPlayerPosition( true );
			G_ZoneID2 = GetCurrentZoneID();
			ParamAdd(a_Param, "ZoneID", String(G_ZoneID2));
			//ExecuteFortressSiegeStatus(a_Param);			
			Class'MiniMapAPI'.static.RequestSeedPhase();
			break;

		//�̴ϸ� ���� ���� ���� ����Ʈ, ����UI�� ������鼭 ��� ����(����� ������ 2016-04)
		case EV_MinimapCursedweaponList :       
			Debug("minimap" @ "EV_MinimapCursedweaponList" @ a_Param );
			//HandleCursedWeaponList(a_Param);
			// ��� ����.
			
			break;

		// ���� ������ �������� ��ġ  // 11110
		case EV_MinimapTreasureBoxLocation :  
			Debug("minimap" @ "EV_MinimapTreasureBoxLocation" @ a_Param );
			HandleCursedWeaponLoctaion(a_Param, true);
			break;


		//�̴ϸ� ���� ���� ���� ��ġ
		case EV_MinimapCursedweaponLocation :   
			Debug("minimap" @ "EV_MinimapCursedweaponLocation" @ a_Param );
			HandleCursedWeaponLoctaion(a_Param, false) ;
			break;

		//Ÿ�� ������			
		case EV_MinimapShowReduceBtn :          
			if (a_Param != "") ParseInt(a_Param,"ZoneID", nTownMapZoneID);
			else nTownMapZoneID = 0;
			bIsTownMap = true;
			//nTownMapZoneID = G_ZoneID2;
			////ldw �� ���	
			
			ReduceButton.ShowWindow();
			//ExecuteFortressSiegeStatus(a_Param);
			showAllRegionIcon(false);
			setDirIconDest();
			//Debug("--> Ÿ�� ������ EV_MinimapShowReduceBtn" @ a_Param);
			//Debug("nTownMapZoneID" @nTownMapZoneID);
			
			break;

		//���� ������
		case EV_MinimapHideReduceBtn :    
			//ParseInt(a_Param,"ZoneID",nTownMapZoneID);
			bIsTownMap = false;
			ReduceButton.HideWindow();
			//m_MiniMap.EraseAllRegionInfo();
			showAllRegionIcon(true);
			setDirIconDest();	
			//DrawSeedMapInfo();
			//Debug("--> ���� ������ EV_MinimapHideReduceBtn" @ a_Param);
			//Debug("nTownMapZoneID" @nTownMapZoneID);
			
			break;

		//���� �ð� ���� �ð� �ؽ�Ʈ�� �ٲ� �ָ�, �ٸ� �̺�Ʈ�� ������ ����.
		case EV_MinimapUpdateGameTime :         
			if(m_bShowGameTime)
			{
				HandleUpdateGameTime(a_Param);
				//setDirIconDest();
			}
			break;

		//�̴ϸ� ����?
		case EV_MinimapTravel:                  
			//Debug("minimap" @ "EV_MinimapTravel" @ a_Param );
			//Debug("EV_MinimapHideReduceBtn" @ a_Param);
			HandleMinimapTravel( a_Param );
			break;

		// ��� �� ����
		case EV_ShowFortressMapInfo:            
			//Debug("minimap" @ "EV_ShowFortressMapInfo" @ a_Param );
			//	HandleShowFortressMapInfo(a_Param);
			
			break;

 		// ��� �ǹ� ����
		case EV_FortressMapBarrackInfo:         
			//Debug("minimap" @ "EV_FortressMapBarrackInfo" @ a_Param );
		//	HandleFortressMapBarrackInfo(a_Param);
			break;

		//�����
		case EV_ShowFortressSiegeInfo:          
			//Debug("minimap" @ "EV_ShowFortressSiegeInfo" @ a_Param );
		//	GlobalCurFortressStatus = true;
		//	ParseInt( a_Param, "FortressID", GlobalCurFortressID);			
			break;

		//�ý��� �޽���
		case EV_SystemMessage:                  
			//Debug("minimap" @ "EV_SystemMessage" @ a_Param );
			//To update Fortress Information Data on System Message Update
			//if (me.IsShowWindow()) HandleChatmessage(a_Param);
			//break;

		// ���� ������Ʈ
		case EV_GamingStateEnter:               
			//Debug("minimap" @ "EV_GamingStateEnter" @ a_Param );
			//RequestAllFortressInfo(); //ldw  ���� onLoad�� �ִ� �Լ�.

			SiegeStatus = 0;
			FortressID =0;
			TotalBarrackCnt =0;
			GlobalCurFortressID = 0;
			G_ZoneID = 0;
			G_ZoneID2 = 0;
			//GlobalCurFortressStatus = false;
			break;

		case EV_MinimapShowMultilayer:          //ldw �׽�Ʈ ������ �������� ������ �� �޺� �ڽ�
			//Debug("minimap" @ "EV_MinimapShowMultilayer" @ a_Param );
			ShowMultilayer(a_param);
			break;

		case EV_MinimapCloseMultilayer:         //ldw �׽�Ʈ ������ �����ʿ��� ���� ���� �� ȣ�� �Ǵ� �̺�Ʈ
			//Debug("minimap" @ "EV_MinimapCloseMultilayer" @ a_Param );
			CloseMultilayer();
			break;

		// Ŭ���ʿ��� ���ִ� �κ��� ���� �Ͽ� �Ⱦ��� �ɷ� ���� �ּ� ó�� 
		//case EV_NotifyTutorialQuest:            //ldw Ʃ�丮�� ����
		//	//Debug("minimap" @ "EV_NotifyTutorialQuest" @ a_Param );			
		//	OnNotifyTutorialQuest(a_Param);
		//	break;

		//case EV_ClearTutorialQuest:             //ldw Ʃ�丮�� ����
		//	// Debug("minimap" @ "EV_ClearTutorialQuest" @ a_Param );			
		//	OnClearTutorialQuest();
		//	break;

		case EV_NeedResetUIData:
			class'UIAPI_MINIMAPCTRL'.static.ResetMinimapData( "MinimapWnd.Minimap" );
			checkClassicForm();			
			break;

		case EV_ResolutionChanged:
			// ū ������ ���� ��쿡�� �ػ󵵿� ���� ������¡ ����
			if (IsExpandState()) setMapSize(true);
			break;

		// ���� ���� 3150
		case EV_AddCastleInfo:
			LoadCastleInfo(a_Param);
			break;

		// ��� ����
		case EV_AddFortressInfo :
			LoadFortressInfo(a_Param);
			break;

		// ����Ʈ ����
		case EV_AddAgitSiegeInfo :
			LoadAgitSiegeInfo(a_Param);
			break;

		//������ ���� ������ ���� 4200
		case EV_ShowSeedMapInfo:  
			//Debug("minimap" @ "EV_ShowSeedMapInfo" );						
			HandleSeedMapInfo(a_Param);
			break;

		// ���� ���̵�, ���� ������ ���� ����,  10182
		case EV_RaidServerInfo :
			LoadRaidServerInfo(a_Param);
			break;

		// ��� ����
		case EV_ItemAuctionStatus :
			LoadItemAuctionStatus(a_Param);
			break;

		// ���� ����
		case EV_FactionInfo :
			loadFactionInfo(a_Param);
			break;

		case EV_MinimapAdjustViewLocation :
			minimapAdjustViewLocationProcess(a_Param);
			break;

		case EV_Restart :
			class'UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon( "MinimapWnd.Minimap");
			isNoShowMissionWindow = -1; // ini �ѹ��� �е���..
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

// ���� ����, 
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

		//// �������� �˾Ƽ� ������..
		//if(RequestType == EFactionRequsetType.FIRT_NONE)
		//{
			
		//}	//factionInfoListArray.Remove(0, factionInfoListArray.Length);
		//GetUserFactionInfoList(pUserInfo.nID, factionInfoListArray);

		//Debug("####  ���� ���� EV_FactionInfo a_Param:" @ a_Param);	
		//Debug("factionInfoListArray" @ factionInfoListArray.Length);

		// �� ������ ��Ҹ� �ѹ��̶� �׷Ⱦ�� ������Ʈ �Ѵ�.
		if (bCompleteBaseElementShow)
			drawFactionMapIcon(true);
		else
			drawFactionMapIcon();
	}
}

// ���� �ѹ�
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

		ParamAdd(regionInfo.strTooltip, "Type", String(EMinimapRegionType.MRT_Faction));           // ���� Ÿ��
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
// ��� ����
//-------------------------------------------------------------------------
function LoadItemAuctionStatus ( string Param )
{
	local Vector loc;
	local int nState;
	local bool bUse;

	ParseInt(Param, "State", nState);  // 0: �����, 1: ������

	// ��� ���� ���̸� ��� ��ġ ��ǥ �ޱ�
	if (nState > 0)
	{
		// ��� ��ư ���̰� �ϰ�
		bUse = true; 
		// ��� ��ġ
		ParseFloat(Param, "WorldLocX", loc.x);
		ParseFloat(Param, "WorldLocY", loc.y);
		ParseFloat(Param, "WorldLocZ", loc.z);
		Debug("Ŭ��!!!");
	}
	
	//Debug("bUse" @ bUse);
	Debug("LoadItemAuctionStatus " @ Param);
	setServerParse(MapServerInfoType.AUCTION, Param, bUse, loc);
}

//-------------------------------------------------------------------------
// ���� ���̵�, ���� ������ ���� ����
//-------------------------------------------------------------------------
function LoadRaidServerInfo ( string Param )
{
	local int nWorldRaidState, nWorldCastleSiegeState;
	local bool bUse;

	Debug("LoadRaidServerInfo Param: " @Param);

	// "WorldRaidState" : 0:��ȭ����, 1:������
	// "WorldCastleSiegeState" : 0:��ȭ����, 1:������
	ParseInt( Param, "WorldRaidState"       , nWorldRaidState);
	ParseInt( Param, "WorldCastleSiegeState", nWorldCastleSiegeState);

	// ���� ���̵�
	if (nWorldRaidState > 0) bUse = true;
	else bUse = false;
	setServerParse(MapServerInfoType.RAID_DIMENSION, Param, bUse);

	// ���� ������, ���� ���ο� ���� ���� ��ư Ȱ��ȭ
	if (nWorldCastleSiegeState > 0) bUse = true;
	else bUse = false;
	setServerParse(MapServerInfoType.SIEGEWARFARE_DIMENSION, Param, bUse);	
}

//-------------------------------------------------------------------------
// ����Ʈ ���� ����
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

		// ���� ������ 
		//�������ٰ��� ������ 1900�� ���ؾ� �Ѵ�. 
		ParseString( Param, "NextSiegeYear"   $ i, NextSiegeYear);
		ParseString( Param, "NextSiegeMonth"  $ i, NextSiegeMonth);
		ParseString( Param, "NextSiegeDay"    $ i, NextSiegeDay);
		ParseString( Param, "NextSiegeHour"   $ i, NextSiegeHour);
		ParseString( Param, "NextSiegeMin"    $ i, NextSiegeMin);
		ParseString( Param, "NextSiegeSec"    $ i, NextSiegeSec);

		ParseString( Param, "OwnerClanName"       $ i, OwnerClanName);
		ParseString( Param, "OwnerClanMasterName" $ i, OwnerClanMasterName);

		//ParseInt( Param, "Type" $ i, agitGetType);      // ��Ʈ�� ȹ�� ����
		//ParseInt( Param, "SiegeState" $ i, siegeState); // 0: ��ȭ����, 1:������

		nRegionID = GetCastleRegionID(agitID);

		agitName = GetCastleName(agitID);

		// Debug("agitID" @ agitID);
		// Debug("agitName" @ agitName);

		if (OwnerClanName == "")
		{
			OwnerClanName =  GetSystemString(27);           // ����
			OwnerClanNameToolTip =  GetSystemMessage(2196); // ���� ���� ����
		}
		else
		{
			// $s1���� ���� ��
			OwnerClanNameToolTip = MakeFullSystemMsg(GetSystemMessage(2197), OwnerClanName);
			OwnerClanName = OwnerClanName @ GetSystemString(439); // ����
		}
		
		if (NextSiegeMonth == "0" && NextSiegeYear == "70" && NextSiegeDay == "1")
		{
			// ����
			NextSiegeTime = GetSystemString(584);
		}
		else 
		{
			/// NextSiegeTotalTime ���� ��� �ϴ� ����. �Ƹ��� ��û�ؼ� �ؾ� ���� �ʳ� ����.
			////branch EP1.0 2014-7-29 luciper3 - ���þ� ��û���� ǥ�ù�� ���� TTP #65769
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
			//11�� 10��, 4��
		}

		// Debug("����Ʈ :::::: nRegionID" @ nRegionID);

		// ����Ʈ �̸�
		ParamAdd(regionInfo.strTooltip, "AgitName", agitName);                               // ����Ʈ �̸�
		ParamAdd(regionInfo.strTooltip, "Type", String(EMinimapRegionType.MRT_Agit));        // ����Ʈ Ÿ��
		ParamAdd(regionInfo.strTooltip, "OwnerClanName", OwnerClanName);                     // ���� ���͸�
		ParamAdd(regionInfo.strTooltip, "OwnerClanMasterName", OwnerClanMasterName);         // ���� ������
		ParamAdd(regionInfo.strTooltip, "NextSiegeTime", NextSiegeTime);                     // ���� ����Ʈ ��
		ParamAdd(regionInfo.strTooltip, "LocationName", GetCastleLocationName(agitID));      // �Ҽ� ����
		
		regionInfo.nIndex = nRegionID;

		regionInfo.eType = EMinimapRegionType.MRT_Agit;
		regionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;

		// ����� ������, ��ġ ����
		if(GetMinimapRegionIconData(nRegionID, iconData))
		{
			regionInfo.IconData = iconData;
		}

		//m_MiniMap.UpdateRegionInfoCtrl(regionInfo);
		if(nRegionID > 0) addMapIcon(regionInfo, true);
	}
}	

//-------------------------------------------------------------------------
// ��� ���� ����
//-------------------------------------------------------------------------
function LoadFortressInfo( string Param)
{
	local MinimapRegionInfo regionInfo;
	local MinimapRegionIconData iconData;
	local int nRegionID;

	local string tempStr;

	//����� ������
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
	
	//��� ���̵�
	ParseInt( Param, "FortressID", FortressID);
	//���  �̸�
	CastleName = GetCastleName(FortressID);
	//��������
	ParseString( Param, "OwnerClanName", OwnerClanName);
	//����� ����
	ParseInt( Param, "SiegeStatae", SiegeState);
	//�ش������� ������ ������Ȳ
	ParseInt( Param, "LastOwnedTime", LastOwndedTime);

	nRegionID = GetCastleRegionID(FortressID);

	//���������;��̵�
	//ZoneID = g_CastleID[FortressID];	
	//Debug("��� zoneID" @ZoneID);

	if (OwnerClanName == "")
		OwnerClanName = GetSystemString(27);
	else
		OwnerClanName = OwnerClanName @ GetSystemString(439);

	// ���� ����
	if (SiegeState == 0)
	{
		Statcur = GetSystemString(894); // ��ȭ����
		iconname = "L2UI_CT1.ICON_DF_SIEGE_SHIELD";  // ���� �̰͵��� ��� ����.. ��� �Ұ� ������..
	} 
	else if(SiegeState == 1)
	{
		Statcur = GetSystemString(340); // ������
		iconname = "L2UI_CT1.ICON_DF_SIEGE_SWORD";
	}

	Min = (LastOwndedTime/60);
	Hour = (Min/60);
	Date = (Hour/24);
	
	//~ debug ("��갪" @ Min @ Hour @ Date );

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

	// �� �̸�
	ParamAdd(regionInfo.strTooltip, "Type", String(EMinimapRegionType.MRT_Fortress));    // ��� Ÿ��
	ParamAdd(regionInfo.strTooltip, "CastleName", CastleName);                           // ��� �̸� 
	ParamAdd(regionInfo.strTooltip, "OwnerClanName", OwnerClanName);                     // ���� ���͸�
	ParamAdd(regionInfo.strTooltip, "SiegeState", Statcur);                              // ��ȭ ����, ������
	ParamAdd(regionInfo.strTooltip, "LocationName", GetCastleLocationName(FortressID));  // �Ҽ� ����
	
	ParamAdd(regionInfo.strTooltip, "DateTotal", DateTotal);                             // ���� �ð�

	regionInfo.nIndex = nRegionID;//FortressID;

	regionInfo.eType = EMinimapRegionType.MRT_Fortress;
	regionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;
	// Debug("nRegionID: " @ nRegionID);

	// ����� ������, ��ġ ����
	if(GetMinimapRegionIconData(nRegionID, iconData))
	{
		regionInfo.IconData = iconData;
	}

	//m_MiniMap.UpdateRegionInfoCtrl(regionInfo);
	addMapIcon(regionInfo, true);
}	

//-------------------------------------------------------------------------
// ������ ����
//-------------------------------------------------------------------------
function LoadCastleInfo( string Param)
{
	//���� ������
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

	//�� ���̵�
	ParseInt( Param, "CastleID", castleID);
	//�� �̸�
	CastleName = GetCastleName(castleID);
	//��������
	ParseString( Param, "OwnerClanName", OwnerClanName);
	//��������
	ParseString( Param, "TaxRate", TaxRate);

	// ���� ������ 
	//�������ٰ��� ������ 1900�� ���ؾ� �Ѵ�. 
	ParseString( Param, "NextSiegeYear", NextSiegeYear);
	ParseString( Param, "NextSiegeMonth", NextSiegeMonth);
	ParseString( Param, "NextSiegeDay", NextSiegeDay);
	ParseString( Param, "NextSiegeHour", NextSiegeHour);
	ParseString( Param, "NextSiegeMin", NextSiegeMin);
	ParseString( Param, "NextSiegeSec", NextSiegeSec);

	ParseString( Param, "NextSiegeTime", NextSiegeTotalTime);	
	
	ParseInt( Param, "SiegeState", siegeState); // 0: ��ȭ����, 1:������
	ParseInt( Param, "CastleType", castleType); // 0: ����, 1: ��, 2: ���

	// Debug("----------->>> EV_AddCastleInfo  : Param"@ Param);
	// Debug("----------->>> CastleName  : "@ CastleName);

	//���������;��̵�
	//ZoneID = g_CastleID[castleID];		
	
	if (OwnerClanName == "")
	{
		OwnerClanName =  GetSystemString(27);           // ����
		OwnerClanNameToolTip =  GetSystemMessage(2196); // ���� ���� ����
	}
	else
	{
		// $s1���� ���� ��
		OwnerClanNameToolTip = MakeFullSystemMsg(GetSystemMessage(2197), OwnerClanName);
		OwnerClanName = OwnerClanName @ GetSystemString(439); // ����
	}
	
	if (NextSiegeMonth == "0" && NextSiegeYear == "70" && NextSiegeDay == "1")
	{
		// ����
		NextSiegeTime = GetSystemString(584);
	}
	else 
	{
		//branch EP1.0 2014-7-29 luciper3 - ���þ� ��û���� ǥ�ù�� ���� TTP #65769
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

	// �� �̸�
	ParamAdd(regionInfo.strTooltip, "Type", String(EMinimapRegionType.MRT_Castle));  // �� Ÿ��
	ParamAdd(regionInfo.strTooltip, "CastleName", CastleName);                        // ���̸� 
	ParamAdd(regionInfo.strTooltip, "CastleID", String(castleID));                    // ��ID
	ParamAdd(regionInfo.strTooltip, "LocationName", GetCastleLocationName(castleID));   // �Ҽ� ����

	
	
	ParamAdd(regionInfo.strTooltip, "OwnerClanNameToolTip", OwnerClanNameToolTip);    // $s1���� ���� ��
	ParamAdd(regionInfo.strTooltip, "OwnerClanName", OwnerClanName);                  // ���� ���͸�
	ParamAdd(regionInfo.strTooltip, "NextSiegeTime", NextSiegeTime);                  // ���� ������ �ð�
	ParamAdd(regionInfo.strTooltip, "TaxRate", TaxRate $ "%");                        // ����

	
	tempStr = "";
	if (siegeState == 0) 
	{
		bUse = false;
		tempStr = GetSystemString(894); // 0: ��ȭ����
	}
	else 
	{
		bUse = true;
		tempStr = GetSystemString(339); // 1: ���� ��
	}

	ParamAdd(regionInfo.strTooltip, "SiegeState", tempStr); // ��ȭ����, ������

	//if (castleType == 0) 
	//	tempStr = GetSystemString(7400); // 0: ����
	tempStr = "";
	if (castleType == 1) 
		tempStr = GetSystemString(3519); // 1: ��
	else if (castleType == 2) 
		tempStr = GetSystemString(3520); // 2: ���
	else
		tempStr = ""; // GetSystemString(7400); // �׿� : ����
	
	ParamAdd(regionInfo.strTooltip, "CastleType", tempStr); // 0: ����, 1: ��, 2: ���

	regionInfo.eType = EMinimapRegionType.MRT_Castle;
	regionInfo.nIndex = nRegionID;//castleID;	
	regionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;
	regionInfo.strDesc = CastleName;
	//Debug("nRegionID: " @ nRegionID);

	tVector = emptyVector;

	// ����� ������, ��ġ ����
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

	// Debug("���� �� ����" @ regionInfo.strTooltip);
	// Debug("�� nRegionID" @ nRegionID);

	//if(bCompleteBaseElementShow)
	//m_MiniMap.UpdateRegionInfoCtrl(regionInfo);

	addMapIcon(regionInfo, true);

	//else 
	//	m_MiniMap.AddRegionInfoCtrl(regionInfo);
	
	// �� �̸��� param���� �־ �߰� �ǵ��� �Ѵ�.
	setServerParse(MapServerInfoType.SIEGEWARFARE, CastleName, bUse, tVector, nRegionID);
}	

//// Ŭ�� �ʿ� ���� ��� �����Ѵٰ� ��. 
//function OnNotifyTutorialQuest(string a_Param)
//{
//	//ldw Ʃ�丮�� 1202 �׽�Ʈ �� �ּ� ó�� �κ� ���� ���
//	// 5380     QuestID=1 QuestLevel=2 X=1 Y=2 Z=3
//	local int QuestID;
//	local int QuestLevel;
//	local int LocX;
//	local int LocY;
//	local int LocZ;

//	OnClearTutorialQuest(); //���� ������ �����, 
	
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
//	//ldw Ʃ�丮�� ����Ʈ ����.
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

//ldw ������ �޺��ڽ� ����
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

//ldw �׽�Ʈ ������ �޺��ڽ� �ݱ�
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

//	//â�� ������ �ʴ� ��� 
//	if ( !me.IsShowWindow() ) return ;
//	//�׶�þ� ����� �ƴ� ��� 
//	if ( m_CurContinent != 1 ) return;	

//	//SeedDataforMap ������ ���� ��� 
//	if ( SeedDataforMap.Length == 0 ) return ;
			
//	i = SeedDataforMap.Length - 1 ;	
//	parseInt ( SeedDataforMap[i], "Index",  index);	
//	m_MiniMap.EraseRegionInfo( index );	
//	m_MiniMap.AddRegionInfo(SeedDataforMap[i]);

//}


// ������ ���� ����Ÿ ������Ʈ ���� ����
// ������ ���� ���� ���� : ����, ����, ����, ��ü ���� �޾Ƽ� ������ ������ ������Ʈ ��Ű�µ� ����Ѵ�. 
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

	// debug ("����, ũ�� Event Seed Info" @ Param);
	
	if ( getInstanceUIData().getIsClassicServer() ) return;

	ParseInt(param, "SeedCount", nSeedCount);

	for(i = 0; i < nSeedCount; i++)
	{
		ParseInt(param, "HuntingZoneID_" $ i, huntingZoneID);
		ParseInt(param, "SysMsgNo_" $ i, SeedMessageNum);

		if(class'UIDATA_HUNTINGZONE'.static.IsValidData(huntingZoneID) == false) continue;

		// ������ ������ ��Ƽ�� �����
		regionInfo.eType  = EMinimapRegionType.MRT_HuntingZone_Base;

		//HuntingZoneName = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(huntingZoneID); 

		// �ᵵ ������ �ε��� ���� ������ ID�� �� ����. ��͵� �ϳ��� �迭 �������� ��� ���ұ� ������..
		// �׷��� Ȥ�� �𸣴� ���дٸ� ���� �׳� ������ ID�� ������ �ε����� �ᵵ �����ϴ�.
		//huntingZoneIndex = getHuntingZoneIndexByName(HuntingZoneName);

		//Debug("���� HuntingZoneName" @ HuntingZoneName);
		//Debug("���� index" @ huntingZoneIndex);
		//Debug("���� SeedMessage" @ SeedMessageNum);
		
		//if (huntingZoneIndex == -1) continue;

		// ������ ����, ũ������ ���� ���ձ���
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

			// �������� ������ ������ ���ԵǾ� �־� â�� ó�� ���� �̹� �׷��� �ִ� ��Ȳ. �� ������Ʈ�� �ϸ��.
			//m_MiniMap.UpdateRegionInfoCtrl(regionInfo);
			addMapIcon(regionInfo, true);
			
			// ũ������ ���� ���ձ������ ���� ������ �ν��ؼ� ��ư�� �����Ѵ�.
			if (huntingZoneID == 286)
			{
				bUse = false;
				// ũ������ ����� - ������ �϶��� ���� ���� ��ư�� ���ش�.
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

				// Debug("ũ�� ���� ���� SeedMessageNum:" @ SeedMessageNum);
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
//		////����� ���� �޽����� ������ ����� ��Ȳ�� ���Ź޴´�. 
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
//		////����� �ֿ� ���� ��Ȳ�� ������ ��û�Ѵ�. 
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
//		//������� ����Ǹ� ����� ��Ȳ�� �����Ѵ�.
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
			
			// �̴ϸ��� ����� �� ���� ������ ���Խ��ϴ�. �̴ϸ��� �ݽ��ϴ�.
			if (bMiniMapDisabled )
				AddSystemMessage(2205);
			// �̴ϸ��� ����� �� ���� �����̹Ƿ� �̴ϸ��� �� �� �����ϴ�.
			else 
				AddSystemMessage(2207);
		}
		// �Ⱦ��� ��. ��𼱰� + �� ������ �ؾ� �Ѵ�.
		//// ��ٿ�� �ʿ� "+" ��ư�� ������..
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
			// �̴ϸ��� ����� �� �ִ� ������ ���Խ��ϴ�.
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
				AddSystemMessage(2205); // �̴ϸ��� ����� �� ���� ������ ���Խ��ϴ�. �̴ϸ��� �ݽ��ϴ�.
			else 
				AddSystemMessage(2207); // �̴ϸ��� ����� �� ���� �����̹Ƿ� �̴ϸ��� �� �� �����ϴ�.
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
	
	//// ��ٿ�� ����, ������ ���� ���� ����
	//bHaveItem = false;

	//// ��ٿ�� ������ ������ �ֳ�? (���� �̷��� §�ų�...�̾�...)
	//for (i=0;i<100;i++)
	//{
	//	if (m_questItem.GetItem(i, info) == true)
	//	{
	//		if (info.Name == GetSystemString(1647))
	//			bHaveItem = true;
	//	}
	//}

	// ���� �̸� ���, �̴ϸ��� �ִ� , ���� ������������ ǥ��
	HandleZoneTitle();

	// ��� �� ����
	ContinentLoc();

	// �� ���� ����
	mapRefresh();

	// ldw ����ġ ȭ��ǥ ���̱�	
	setDirIconDest(); 
}

// �� ���� ����
function mapRefresh()
{
	local UserInfo pUserInfo;

	//// �� �⺻ ��� �׸��� (�����, ����, �������� �ʿ� �׷��� �ؽ�Ʈ ���)
	showMapIconElement();

	// ���� ���� �� ���� ���� 
	MinimapMissionWndScript.refresh();
	
	// �� ����
	RequestAllCastleInfo();

	// ��� ����
	RequestAllFortressInfo();


	if(!getInstanceUIData().getIsClassicServer()) 
	{		
		// ����Ʈ ����
		Class'MiniMapAPI'.static.RequestShowAgitSiegeInfo();

		// ���� ����
		GetPlayerInfo(pUserInfo);
		RequestUserFactionInfo(EFactionRequsetType.FIRT_NONE, pUserInfo.nID);
		
		// ���� ���̵�, ���� ������ ���� ����
		// �ű� ���� ������ ���´�. 
		if (IsBloodyServer() == false)
		{
			Class'MiniMapAPI'.static.RequestRaidServerinfo();

			// ��� ����
			class'MiniMapAPI'.static.RequestItemAuctionStatus();

			// ������ ����, ũ������ ����
			Class'MiniMapAPI'.static.RequestSeedPhase();
		}

		// ����, ����
		requestCursedWeapon();

		// ���� ���� 
		RequestInzoneWaitingTime(false);
	}
}

function requestCursedWeapon()
{
	class'UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon("MinimapWnd.Minimap");

	if(!getInstanceUIData().getIsClassicServer()) 
	{
		// ���� ����
		//class'MiniMapAPI'.static.RequestCursedWeaponList();
		class'MiniMapAPI'.static.RequestCursedWeaponLocation();
		// ���ֹ��� ��, ���� ����, �������� ��ġ
		Class'MiniMapAPI'.static.RequestTreasureBoxLocation();
	}
}

// ������ ��ũ��Ʈ�� ��� �ִ� ��Ҹ� �����ش�.
function addMapIcon(MinimapRegionInfo regionInfo, optional bool bUpdate)
{
	if(!isVectorZeroXYZ(regionInfo.IconData.nWorldLocX, regionInfo.IconData.nWorldLocX, regionInfo.IconData.nWorldLocZ))
	{
		if (bUpdate)
		{
			m_MiniMap.UpdateRegionInfoCtrl(regionInfo);
			
			// �����ڷ���Ʈ
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
			
			// �����ڷ���Ʈ
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

// ������ ��ũ��Ʈ�� ��� �ִ� ��Ҹ� �����ش�.
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

	// �̹� �׷ȴٸ� �ٽ� �׸��� �ʴ´�.
	if(bCompleteBaseElementShow) 
	{
		// * �������� ������ ��� ��ü�� ���ϱ� ������ ������Ʈ ���� �ʰ� 
		//   �ӹ� �����, ���̵� ����, �ν��Ͻ� ���� �� ���̾ ���� �� �ٽ� �׸���. 

		// ���� Ÿ���� �� ����
		m_MiniMap.EraseRegionInfoByType(EMinimapRegionType.MRT_InstantZone);
		// �ӹ� ����� �� ����
		m_MiniMap.EraseRegionInfoByType(EMinimapRegionType.MRT_HuntingZone_Mission);
		// ���̵� Ÿ�� �� ����,
		m_MiniMap.EraseRegionInfoByType(EMinimapRegionType.MRT_Raid);

		// ������ �´� ���� ������ �ʿ� �׸���
		for (i = 0; i < 500; i++)
		{
			// �����, �̼�â ����
			if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i) == false) continue;

			class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);

			if(huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_SOLO ||
			   huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTY ||
			   huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTYWITH_SOLO)
			{
				drawMinimapRegionInfo(EMinimapRegionType.MRT_HuntingZone_Mission, i, true);
			}

			// �ν��Ͻ� ��, �̼�â ����
			if(huntingZoneData.nType == HuntingZoneType.INSTANCE_ZONE_SOLO ||
			   huntingZoneData.nType == HuntingZoneType.INSTANCE_ZONE_PARTY) 
			{
				// ���� ������ �׸���, ������ ��ҿ� Ȱ��ȭ�Ǿ� �ְ� �ͼӵǸ� ��Ȱ��ȭ�Ǵ� ���̴�.
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

		// ������ �´� ���̵� ������ �ʿ� �׸���
		for(i = 0; i < raidDataKeyList.Length; i++)
		{
			raidData = getRaidDataByIndex(raidDataKeyList[i]);
			// 0, 0, 0 ��ġ ��ǥ�� ��� 0�̸� ��ȹ�ʿ��� �����ֱ� ��ġ �ʴ� ����Ÿ�� �Ǵ� �ؼ� ������.
			if(raidData.nWorldLoc.x == 0 && raidData.nWorldLoc.y == 0 && raidData.nWorldLoc.z == 0) continue;

			// ���̵��� ���� Ȱ��ȭ�� ��Ȱ��ȭ�� �ؼ� �����Ѵ�. �� �� �������� ������ ���� �װ� �������� ������Ʈ �Ͽ� Ȱ��ȭ ���ش�.
			drawMinimapRegionInfo(EMinimapRegionType.MRT_Raid,raidDataKeyList[i],false);
		}
	}
	else
	{
		// ���� ó�� ���� �ϰ� ���� �׸���.
		for (i = 0; i < 500; i++)
		{
			// �� ����ü��� ��������..
			if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i) == false) continue;

			class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);

			// ������ ������ ��� �׸���, ��ƾ�� ����� ������ ������ ���� ���� �׸���.
			// �׷� �� ������Ʈ �Ǵ� ����(����)�� ���� ������Ʈ�� �ش� �������� ������Ʈ ���ִ� ������ �ڵ��� ����
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

			// ���� �ִ� ���
			if (huntingZoneData.nRegionID > 0)
			{
				// ������ ��ũ��Ʈ���� ���� ��� �� �ִ�.
				// �� ���� ������ ���ǿ� ���� ������ �Ⱥ����� �ϴ� ��Ұ� �ƴ����� ������ ���̾�δ� ������ �ѹ� �׷� ���� ������Ʈ �Ѵ�.
				//if (fieldType == HuntingZoneType.CASTLE)
				
				if (huntingZoneData.nType == HuntingZoneType.CASTLE)
				{
					regionInfo.eType  = EMinimapRegionType.MRT_Castle;
					//Debug("=========>>>> �� �׸��� strName::" @ huntingZoneData.strName @ " eType" @ String(regionInfo.eType));					
				}
				else if (huntingZoneData.nType == HuntingZoneType.AGIT)
				{
					regionInfo.eType  = EMinimapRegionType.MRT_Agit;
					//Debug("=========>>>> ����Ʈ �׸��� strName::" @ huntingZoneData.strName);
				}
				else if (huntingZoneData.nType == HuntingZoneType.FORTRESS)
				{
					regionInfo.eType  = EMinimapRegionType.MRT_Fortress;
					//Debug("=========>>>> ��� �׸��� strName::" @ huntingZoneData.strName);
				}
				else
				{
					if (huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_SOLO ||
						huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTY ||
						huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTYWITH_SOLO)
					{
						// ����� Ÿ���� nRegionID�� 0�̸� �ƹ��͵� ����.
						if (huntingZoneData.nRegionID <= 0) continue;
					}

					regionInfo.eType  = EMinimapRegionType.MRT_HuntingZone_Base;
					//Debug("****======>>>> �Ϲ� �׸���. strName::" @ huntingZoneData.strName);
				}

				toolTipParam = "";
				ParamAdd(toolTipParam, "Type", String(regionInfo.eType));
				ParamAdd(toolTipParam, "Index", String(i));

				// nRegionID�� ���� �������̴� �̰� ���.
				regionInfo.nIndex = huntingZoneData.nRegionID; //i; //huntingZoneData.nSearchZoneID;

				regionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;
				regionInfo.strDesc = huntingZoneData.strName;

				regionInfo.strTooltip = toolTipParam;

				GetMinimapRegionIconData(huntingZoneData.nRegionID, iconData);
				regionInfo.IconData = iconData;

				//m_MiniMap.AddRegionInfoCtrl(regionInfo);
				
				// ����
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

		// ������ �´� ���̵� ������ �ʿ� �׸���
		for(i = 0; i < raidDataKeyList.Length; i++)
		{
			raidData = getRaidDataByIndex(raidDataKeyList[i]);
			// 0, 0, 0 ��ġ ��ǥ�� ��� 0�̸� ��ȹ�ʿ��� �����ֱ� ��ġ �ʴ� ����Ÿ�� �Ǵ� �ؼ� ������.
			if(raidData.nWorldLoc.x == 0 && raidData.nWorldLoc.y == 0 && raidData.nWorldLoc.z == 0) continue;

			drawMinimapRegionInfo(EMinimapRegionType.MRT_Raid,raidDataKeyList[i],false);
		}

		// �Ѽ� �� ������ �׸���(���� ������ ����, �ʿ� �����ܸ�.. ������ ������Ʈ ��)
		drawFactionMapIcon();
	}

	bCompleteBaseElementShow = true;

	// Debug("---------------map �⺻ ��� �׸��� �Ϸ� ----------------------------- ");

}

function setDirIconDest()// ldw ����ġ ǥ�� ȭ��ǥ 
{	
	local vector playerPos, questLoc;
	local string questTooltipStr;

	playerPos = GetPlayerPosition();
	m_MiniMap.SetDirIconDest( EMinimapTargetIcon.TARGET_ME, playerPos, GetSystemString(887) );	
		
	questLoc = QuestTreeWnd(GetScript("QuestTreeWnd")).getCurrentQuestDirectTargetPos();
	questTooltipStr = QuestTreeWnd(GetScript("QuestTreeWnd")).getCurrentQuestDirectTargetString();

	if (questTooltipStr != "") 
	{
		//Debug("����Ʈ ȭ��ǥ ����x" @ questLoc.x);
		//Debug("����Ʈ ȭ��ǥ ����y" @ questLoc.y);
		//Debug("����Ʈ ȭ��ǥ ����z" @ questLoc.z);
		m_MiniMap.SetDirIconDest( EMinimapTargetIcon.TARGET_QUEST, questLoc, questTooltipStr);	
	}

	//if ( m_CurContinent == m_MiniMap.GetContinent( playerPos ) )// ���� ����� �븸 ǥ��
	//{
	//	m_MiniMap.SetDirIconDest( EMinimapTargetIcon.TARGET_ME, playerPos, GetSystemString(887) );	
			
	//	questLoc = QuestTreeWnd(GetScript("QuestTreeWnd")).getCurrentQuestDirectTargetPos();
	//	questTooltipStr = QuestTreeWnd(GetScript("QuestTreeWnd")).getCurrentQuestDirectTargetString();
		
	//	//Debug("playerPos ����x" @ playerPos.x);
	//	//Debug("playerPos ����y" @ playerPos.y);
	//	//Debug("playerPos ����z" @ playerPos.z);

	//	//Debug("questTooltipStr" @ questTooltipStr);
	//	if (questTooltipStr != "") 
	//	{
	//		//Debug("����Ʈ ȭ��ǥ ����x" @ questLoc.x);
	//		//Debug("����Ʈ ȭ��ǥ ����y" @ questLoc.y);
	//		//Debug("����Ʈ ȭ��ǥ ����z" @ questLoc.z);
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


//�� ��� ��, �׷��þ�, �Ƶ� ���, ����ȯ
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
	//CloseMultilayer();//ldw ���� Ÿ�� �� �޺� �ڽ� �ݱ�
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
	// �������� add �̺�Ʈ�� ���� ������ â�� ���� �� �ٽ� �ʱ�ȭ �ؾ� �Ѵ�. �ȱ׷� ���δ�.
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

	// Ȯ�� ���� ���...
	if (w >= 800) return true;
	return false;
}

function HandleShowMinimap( String a_Param )
{
	// ���� ������ ����, ��� Show,Hide
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
	//m_MiniMap.SetDirIconDest(  EMinimapTargetIcon.TARGET_QUEST ,  vTargetPos , "�����ٶ�" );
}

function HandleMinimapHideQuest()
{

	class'UIAPI_MINIMAPCTRL'.static.SetShowQuest( "MinimapWnd.Minimap", false );
}

// ���� Ÿ��� (�� ǥ�� �޺� �ڽ� ���ý�)
function OnComboBoxItemSelected( string sName, int index )
{   	
	switch (sName)
	{
		//ldw �׽�Ʈ ����Ÿ����		
		case "FloorComboBox": 
			 select_floor(index);
			 break;	
	}
}

//ldw �׽�Ʈ ���� Ÿ����, �޺� ����
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

		// �� ��Ʈ��, ���
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
			//Ưȭ ������ ��� �ǹ�ư ���� ���� �ʵ��� �Ѵ�.
			if ( getInstanceUIData().getisClassicServer() ) return;

			if (IsExpandState()) setMapSize(true);

			SetContinent(1);

			// ����, ���� ���� ����			
			requestCursedWeapon();

			InitializeLocation();
			setDirIconDest();
			
			break;

		// �� Ȯ��, ���
		case "ExpandButton" :
			 expandMapSize();
			 break;

		// ���� ��ư Ŭ��
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

// �� Ȯ��, ���
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
		// ��Ҹ� (���� ������)
		setMapSize(false);		
		GetButtonHandle(m_WindowName $ ".ExpandButton").SetButtonName(1474); // ����Ȯ��� ��ư ��Ʈ�� ����		
		
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
		// Ȯ��� (ū ������)
		setMapSize(true);
		
		GetButtonHandle(m_WindowName $ ".ExpandButton").SetButtonName(2734); // ������ҷ� ��ư ��Ʈ�� ����

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

	// �ڱ� �߽����� ��ġ�� �ٽ� ��� �ش�. ��� ���� ������ ���� �������� ��ġ�� ���� �ְ� �ִ� ���� �߻�.
	//OnClickMyLocButton();
}

// �� ������ ����
function setMapSize(bool bBigSize)
{
	local int wSum, hSum, moveX, moveY;
	local Rect rect;

	if(bBigSize)
	{
		rect = me.GetRect();

		wSum = 377 + getExtendMapSize() - 800;
		//hSum = 92;

		// Ÿ�� �ʵ��� 1024�ϱ� �� ũ�� �ȳ��´�. �ִ� 1024
		if (getInstanceUIData().getScreenHeight() >= 1024)
			hSum = 1024;
		else 
			hSum = getInstanceUIData().getScreenHeight();

		me.SetWindowSize(getExtendMapSize(), hSum);		
		// �� ��Ʈ�� ������
		m_MiniMap.SetWindowSize(411 + wSum, hSum - 95);

		// ������ ������
		GetTextureHandle(m_WindowName $ ".texShadowBottom").SetWindowSize(411 + wSum, 43);
		GetTextureHandle(m_WindowName $ ".TexMapStroke").SetWindowSize(413 + wSum, hSum - 93);
		GetTextureHandle(m_WindowName $ ".TexMapStrokeGrow").SetWindowSize(413 + wSum, hSum - 93);

		GetTextureHandle(m_WindowName $ ".texShadowTop").SetWindowSize(411 + wSum, 43);
		

		// ���� ���δ� ���� �ڽ�
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

		// �ػ󵵿� â ��ġ�� ���� ��ġ ����.
		if(rect.nX + getExtendMapSize() > getInstanceUIData().getScreenWidth())
			moveX = getInstanceUIData().getScreenWidth() - getExtendMapSize();

		me.MoveTo(moveX, moveY);	
	}
	else
	{
		me.MoveTo(smallMapRect.nX, smallMapRect.nY);
		me.SetWindowSize(423, 508);

		// �� ��Ʈ�� ������
		m_MiniMap.SetWindowSize(411, 413);

		// ������ ������
		GetTextureHandle(m_WindowName $ ".texShadowBottom").SetWindowSize(411, 43);
		GetTextureHandle(m_WindowName $ ".TexMapStroke").SetWindowSize(413, 415);
		GetTextureHandle(m_WindowName $ ".TexMapStrokeGrow").SetWindowSize(413, 415);

		// ���� ���δ� ���� �ڽ�
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

	// Ȯ�� ��Ҹ� ������ �ӹ� â�� �ڿ� ������ �ʵ��� ��Ŀ���� �ش�.
	if (m_MinimapMissionWnd.IsShowWindow()) m_MinimapMissionWnd.SetFocus();
}

function int getExtendMapSize()
{
	local int nSize;

	// Ŭ�����̸� ������ 1024, �׶�þ� ����� ���..
	if ( getInstanceUIData().getisClassicServer() )
	{
		nSize = 1024;
	}
	else
	{
		// �׶�þ�
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
	class'UIAPI_MINIMAPCTRL'.static.RequestReduceBtn("MinimapWnd.Minimap"); // �⺻ ������ �� ��ġ�� ã�� ��.  -> EV_minimapHideReduceBtn �̺�Ʈ �����
	//if( ����Ʈ ���� ������ ���� ������ )  ����Ʈ ��ġ�� Ÿ�� �ʵ� �ش� ��ġ��
	// +������ �� ���� ó���� �ʿ� ��.
	HideWindow("MinimapWnd.btnReduce"); 
	//Btn_Refresh.HideWindow();
	//Btn_Refresh_Expand.HideWindow();
	//RequestFortressSiegeInfo();
	HandleZoneTitle();
	//setDirIconDest();
	//SetSSQTypeText();ldw 20101227 ���� ������ �������Ƿ� �ּ� ó��
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

// �� ��ġ�� �� �̵�
function OnClickMyLocButton()
{
	AdjustMapToPlayerPosition( true );
}

// �÷��̾� �߽����� �� �̵�
function AdjustMapToPlayerPosition( bool a_ZoomToTownMap )
{
	local Vector PlayerPosition;

	PlayerPosition = GetPlayerPosition();
	SetLocContinent(PlayerPosition);
	class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", PlayerPosition, a_ZoomToTownMap );
}


// ��Ƽ ��ġ�� �� �̵�
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

// ���� ���� ��, ��ġ 
function HandleCursedWeaponLoctaion( string param , bool isTreasureBox)
{
	local int num;  
	local int i;
	local Vector cursedWeaponLocation, nullVector;
	
	ParseInt( param, "NUM", num );

	class'UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon( "MinimapWnd.Minimap");

	// ���� ������ ���ٸ�..
	if(num == 0)
	{	
		if (isTreasureBox == true)
		{
			// ���� ����
			cursedWeaponInit(CursedWeaponArray[2]);
			cursedWeaponInit(CursedWeaponArray[3]);
			setServerParse(MapServerInfoType.CURSEDWEAPON_MAGICAL_TreasureBox, "", false, nullVector);
			setServerParse(MapServerInfoType.CURSEDWEAPON_BLOOD_TreasureBox, "", false, nullVector);

		}
		else
		{
			// ���� ���� �迭 �ΰ� �ʱ�ȭ 
			cursedWeaponInit(CursedWeaponArray[0]);
			cursedWeaponInit(CursedWeaponArray[1]);

			setServerParse(MapServerInfoType.CURSEDWEAPON_BLOOD, "", false, nullVector);
			setServerParse(MapServerInfoType.CURSEDWEAPON_MAGICAL, "", false, nullVector);
		}

		// �����, ���� �迭�� �׸� ���� �ִٸ� �ٽ� �׸�.
		DrawCursedWeaponbyArray();

		return;
	}
	// ���� ������ �ִٸ�..
	else
	{
		// 1, 2 �� num ���� ��� ��.
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

				// 8190 ����,8689 ������ ������ id
				if (CursedWeaponArray[i].itemClassID == 8190 || CursedWeaponArray[i].itemClassID == 8689)
				{
					ParseInt( param, "ISOWNED" $ i, CursedWeaponArray[i].isowned );

					// �⺻ ����, ���� ������ ���� 
					//ParseINT64( param, "FIXED" $ i, CursedWeaponArray[i].fixedAdena );
					//ParseINT64( param, "VARIABLE" $ i, CursedWeaponArray[i].variableAdena );

					// ���� �ڸ�ü
					if( CursedWeaponArray[i].itemClassID == 8190 )
					{	
						setServerParse(MapServerInfoType.CURSEDWEAPON_MAGICAL, "", true, cursedWeaponLocation);

						// ���� ��ư ����
						if (num == 1)
						{
							setServerParse(MapServerInfoType.CURSEDWEAPON_BLOOD, "", false, nullVector);
						}
					}
					// ���� ��ī������
					else if( CursedWeaponArray[i].itemClassID == 8689 )
					{
						setServerParse(MapServerInfoType.CURSEDWEAPON_BLOOD, "", true, cursedWeaponLocation);

						// ���� ��ư ����
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
		// �������ڶ��..
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

				// �������ڴ� npc ID�� .
				//24370, �ڸ�ü�� ��������(����) 
				if( CursedWeaponArray[i].itemClassID == 24370 )
				{	
					setServerParse(MapServerInfoType.CURSEDWEAPON_MAGICAL_TreasureBox, "", true, cursedWeaponLocation);
					// ���� ��ư ����
					if (num == 1)
					{
						setServerParse(MapServerInfoType.CURSEDWEAPON_BLOOD_TreasureBox, "", false, nullVector);
					}

				}
				//24371, ��ī�������� �������� (����)
				else if( CursedWeaponArray[i].itemClassID == 24371 )
				{
					setServerParse(MapServerInfoType.CURSEDWEAPON_BLOOD_TreasureBox, "", true, cursedWeaponLocation);
					// ���� ��ư ����
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
	// ���� ���� 
	//--------------------------------
	// �����̶� �ڸ�ü�� ���� ������..
	if (CursedWeaponArray.Length > 1)
	{
		// ���� ������ id�� ��� �ִٸ�..
		if (CursedWeaponArray[0].itemClassID != 0 && CursedWeaponArray[1].itemClassID != 0)
		{
			// �׸��忡 ��ġ��, ����������.. �ذ� �̹����� ����.
			if (class'UIAPI_MINIMAPCTRL'.static.IsOverlapped("MinimapWnd.Minimap", CursedWeaponArray[0].loc.x, CursedWeaponArray[0].loc.y, CursedWeaponArray[1].loc.x, CursedWeaponArray[1].loc.y))
			{
				//if (CursedWeaponArray[0].loc.x == 0 && CursedWeaponArray[0].loc.y == 0 && CursedWeaponArray[0].loc.z == 0)
				// ���� ������ ��������.

				Debug("---------------!!!!!!! �׸��� cursedmapicon00 �ذ�" @ CursedWeaponArray[0].itemClassID);
				class'UIAPI_MINIMAPCTRL'.static.DrawGridIcon( "MinimapWnd.Minimap","L2UI_CH3.MiniMap.cursedmapicon00", CursedWeaponArray[0].loc,true,60, 99, 0, 0, "sword|" $ CursedWeaponArray[0].eventParam $ "|" $ CursedWeaponArray[1].eventParam);
				// eventParam �� 0,1 �ε��� �迭�� ���� ��� ���� ������ �ƹ��ų� �־���.
				m = 2;
			}
		}
	}

	//--------------------------------
	// ��������
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

// ���� ���� �� �������� �ʿ� �׸���.
function DrawCursedWeapon(string WindowName, int id, string cursedName, Vector vecLoc, bool bDropped, bool bRefresh, INT64 fixedAdena, INT64 variableAdena)
{
	local string itemIconName;

	// ������ ID
	// ���� �ڸ�ü
	if(id == 8190)
	{
		ItemIconName = "L2UI_CH3.MiniMap.cursedmapicon01";
		if(bDropped) ItemIconName = ItemIconName$"_drop";
	}
	// ���� ��ī������
	else if(id == 8689)
	{
		ItemIconName ="L2UI_CH3.MiniMap.cursedmapicon02";
		if(bDropped) ItemIconName = ItemIconName$"_drop";
	}

	// npcID�� üũ 
	// �ڸ�ü�� ��������(����)
	else if(id == 24370)
	{
		ItemIconName = "L2UI_CT1.Minimap.Cursedmapicon_Treasurebox01";
	}
	// ��ī�������� ��������(����)
	else if(id == 24371)
	{
		ItemIconName ="L2UI_CT1.Minimap.Cursedmapicon_Treasurebox02";
	}


	// ����, ����
	if (id == 8190 || id == 8689)
	{
		class'UIAPI_MINIMAPCTRL'.static.DrawGridIcon(WindowName, ItemIconName, vecLoc, bRefresh, 60, 72, 0, 0, "sword|" $ cursedName);

		Debug("---------------!!!!!!! �׸��� ��������" @ ItemIconName);
	}
	// ��������
	else if (id == 24370 || id == 24371)
	{
		class'UIAPI_MINIMAPCTRL'.static.DrawGridIcon(WindowName, ItemIconName, vecLoc, bRefresh, 45, 45, 0, 0, "treasureBox|" $ cursedName);
		Debug("---------------!!!!!!! �׸��� ��������" @ ItemIconName);
	}
}

// ���� �ð�
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
		// ���� �ð� ���� ������ ���� ������ ������Ʈ �ϳ� ��. -_-.. 
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
	
	if (m_CurContinent == 0) //Aden ���
	{
		Location.x = -86916;
		Location.y = 222183;
		Location.z = -4656;			
	}
	else if (m_CurContinent == 1) //Gracia ���
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
	
	if ( m_MiniMap.GetContinent( MyPosition ) == m_CurContinent ) //���� ����̸� ���� ��ġ�� ���� ����.
	{
		m_MiniMap.adjustMapView(MyPosition, true);
		//m_MiniMap.adjustMapView(MyPosition, bIsTownMap);
	}
	else InitializeLocationByContinent();
	// End changing
}

// Ŭ����, ���̺꿡 ���� ����. (Ŭ������ �׶�þ� ���� 2016-04)
function checkClassicForm() 
{

	if ( getInstanceUIData().getisClassicServer() )
	{
		m_MapSelectTab.SetTopOrder(0, false);
		m_MapSelectTab.SetButtonDisableTexture(1, "L2UI_ct1.Misc_DF_Blank");
		//�Ƶ� ������� �ٲ�
		m_MapSelectTab.SetButtonName(0, GetSystemString(1769));
		m_MapSelectTab.SetDisable(1, true);			
		m_MapSelectTab.SetButtonName(1, "");				
		TabBg_Line.SetWindowSize( 318 + 86, 23);
		TabBg_Line.SetAnchor( m_WindowName, "TopLeft", "TopLeft", 101 , 31);		
		//TabBg_Line.setahcn
	}
	else 
	{			
		//�׶�þ�
		m_MapSelectTab.SetButtonName(0, GetSystemString(1768));
		//�Ƶ�
		m_MapSelectTab.SetButtonName(1, getSystemString (1769));
		m_MapSelectTab.SetDisable(1, false);
		TabBg_Line.SetWindowSize( 140 + 86 , 23);
		TabBg_Line.SetAnchor( m_WindowName, "TopLeft", "TopLeft", 193 , 31);	
	}
} 


// �� (���) ���� �ε��ϰ� ���� ��ġ�� �´� ������ ����.
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

// ��ġ ��ǥ�� ���� ��� �̵�
function SetLocContinent(vector loc)
{
	m_CurContinent = m_MiniMap.GetContinent(loc);
		
	SetContinent(m_CurContinent);
}

//// ���� ��ġ�� ��� ���� ����, 0 �Ƶ�, 1 �׶�þ�, Ŭ���̾�Ʈ mapCtrl �Լ��� �����(2016.04)
//function int GetContinent(vector loc)
//{
//	//JYLee, 2011. 11. 23.
//	//�׷��þ� ���� �δ��� exception data ó�� ����
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

// ���� ���� �Լ��� ������ �ʰ�, ������ �Ⱥ����� show, hide�� �ϴ� �Լ�
function showAllRegionIcon(bool bShow)
{
	//Debug("--> bIsTownMap" @ bIsTownMap);
	//// ����ó��, ������ �߿���(������ ���) ���� ��� ���� ���� ��ũ��Ʈ�� �ȸ´� ���� �ؼ�..
	//// Ȥ�� ���� Ÿ�� ���϶��� ������ �ʵ��� ó��
	//if (bIsTownMap == true) bShow = false;

	m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Castle, bShow);
	m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Fortress, bShow);
	m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Agit, bShow);
	m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_HuntingZone_Base, bShow);
	m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Etc, bShow);

	// �ӹ��� �����, ���̵�, ������ ���� ���� ���ο� ����
	if(bShow && MinimapMissionWndScript.isShowHuntingZone())
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_HuntingZone_Mission, true);
	else 
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_HuntingZone_Mission, false);

	///if(bShow && MinimapMissionWndScript.isShowInzone())
	// [Ÿ������� ��ȯ �� ���� & ���� ������ Hide ����]
	if(MinimapMissionWndScript.isShowInzone())
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_InstantZone, true);
	else 
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_InstantZone, false);

	if(bShow && MinimapMissionWndScript.isShowRaid())
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Raid, true);
	else 
		m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Raid, false);

}

// ���� ���� �Լ��� ������ �ʰ�, ������ �Ⱥ����� show, hide�� �ϴ� �Լ�
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
// ���� ��ư ���� 
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

	// ���� ���� Ÿ�Կ� ���� �߰�
	serverInfoArray.Remove(0, serverInfoArray.Length);
	
	// ��ư �߰� ������ �ٲ�� �ȵȴ�.
	// �� ��ư�� ���� �⺻ ���ø� �س���, ��ġ ������ ���� ���� ������ ��쿡 ���� ������Ʈ �޴´�.

	// ������
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_siege_i00", "L2UI_CT1.Minimap.map_siege_i00_Down", "L2UI_CT1.Minimap.map_siege_i00_Over",
																  MapServerInfoType.SIEGEWARFARE, GetSystemString(3534), "", loc);

	// ���� ������
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_siege_demension_i00", "L2UI_CT1.Minimap.map_siege_demension_i00_Down", "L2UI_CT1.Minimap.map_siege_demension_i00_Over", 
																  MapServerInfoType.SIEGEWARFARE_DIMENSION, GetSystemString(3535), GetSystemMessage(4), loc);

	// ���� ���̵�
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_raid_demension_i00", "L2UI_CT1.Minimap.map_raid_demension_i00_Down", "L2UI_CT1.Minimap.map_raid_demension_i00_Over", 
																  MapServerInfoType.RAID_DIMENSION,  GetSystemString(3536), GetSystemMessage(6), loc);

	// ���� �ڸ�ü
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_cursed_weapon_i01", "L2UI_CT1.Minimap.map_cursed_weapon_i01_Down", "L2UI_CT1.Minimap.map_cursed_weapon_i01_Over", 
																  MapServerInfoType.CURSEDWEAPON_MAGICAL, MakeFullSystemMsg(GetSystemMessage(4437), GetSystemString(1464)), "", loc);

	// ���� ��ī������
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_cursed_weapon_i00", "L2UI_CT1.Minimap.map_cursed_weapon_i00_Down", "L2UI_CT1.Minimap.map_cursed_weapon_i00_Over", 
																  MapServerInfoType.CURSEDWEAPON_BLOOD, MakeFullSystemMsg(GetSystemMessage(4437), GetSystemString(1499)), "", loc);

	// ���
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_auction_i00", "L2UI_CT1.Minimap.map_auction_i00_Down", "L2UI_CT1.Minimap.map_auction_i00_Over", 
																  MapServerInfoType.AUCTION, GetSystemString(3538), "", loc);

	
	// ũ������ ���� ���ձ��� �����
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_siege_kserth_i00", "L2UI_CT1.Minimap.map_siege_kserth_i00_Down", "L2UI_CT1.Minimap.map_siege_kserth_i00_Over", 
																  MapServerInfoType.DEFENSEWARFARE, GetSystemString(3540), "", loc);



	// ���� �ڸ�ü�� �������� 
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_cursed_treasurebox_i01", "L2UI_CT1.Minimap.map_cursed_treasurebox_i01_Down", "L2UI_CT1.Minimap.map_cursed_treasurebox_i01_Over", 
																  MapServerInfoType.CURSEDWEAPON_MAGICAL, GetSystemString(3952), "", loc);

	// ���� ��ī�������� ��������
	serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_cursed_treasurebox_i00", "L2UI_CT1.Minimap.map_cursed_treasurebox_i00_Down", "L2UI_CT1.Minimap.map_cursed_treasurebox_i00_Over", 
																  MapServerInfoType.CURSEDWEAPON_BLOOD, GetSystemString(3953), "", loc);

}

// ���� ���� Ÿ�Ժ� ������ ä���.
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

// ������ �ʿ� ���� ��ư�� ��ġ �ϴ� ���
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

		// ���� ���� ��ư
		serverInfoArray[nServerInfoType].buttonName = serverButton.GetWindowName();

		//Debug("mServerInfo.toolTipString" @ mServerInfo.toolTipString);
	}
}

// �����̳� ������ Ȱ��ȭ �Ǿ� �ֳ�?
function bool isActiveCursedWeapon()
{
	local int i;

	for (i = 0; i < serverInfoArray.Length; i++)
	{		
		// ���� ������ Ȱ��ȭ �Ǿ� �ִٸ�...
		if (serverInfoArray[i].nServerInfoType == MapServerInfoType.CURSEDWEAPON_MAGICAL || 
			serverInfoArray[i].nServerInfoType == MapServerInfoType.CURSEDWEAPON_BLOOD ||
			serverInfoArray[i].nServerInfoType == MapServerInfoType.CURSEDWEAPON_MAGICAL_TreasureBox ||
			serverInfoArray[i].nServerInfoType == MapServerInfoType.CURSEDWEAPON_BLOOD_TreasureBox)
		{
			if(serverInfoArray[i].bUse)
			{
				Debug("-> ���� ������ Ȱ��ȭ �Ǿ� ����");
				return true;
			}
		}
	}

	return false;
}

// ũ������ �似���� ���� systemMessage�� �ޱ� ���ؼ� ���
// getServerNData(MapServerInfoType.DEFENSEWARFARE)
function int getServerNData(int serverInfoType)
{
	local int i;

	for (i = 0; i < serverInfoArray.Length; i++)
	{		
		// ���� ������ Ȱ��ȭ �Ǿ� �ִٸ�...
		if (serverInfoArray[i].nServerInfoType == serverInfoType)
		{
			return serverInfoArray[i].nData;
		}
	}

	return 0;
}

// Ŭ��: ���� ���� ��ư 
function clickServerInfoButton(string clickButtonName)
{
	local int i, n, clickCount, addIconX, addIconY;
	local MinimapRegionIconData iconData, emptyIconData;

	for (i = 0; i < serverInfoArray.Length; i++)
	{		
		if(serverInfoArray[i].buttonName == clickButtonName)
		{
			Debug("��ư ���� (���� ��ư) , ����Ÿ����?:" @ serverInfoArray[i].nServerInfoType @ ", click Array :" @ serverInfoArray[i].clickedLocArray.Length );
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

				// �ϳ��� 0�� ���� �ʴٸ�.. ��ġ�� �̵�
				if (serverInfoArray[i].clickedLocArray[clickCount].x != 0 ||
					serverInfoArray[i].clickedLocArray[clickCount].y != 0 ||
					serverInfoArray[i].clickedLocArray[clickCount].z != 0)
				{					
					// ������ �ε����� �ִ� ���� ������.. �� ��Ŀ�� ���϶���Ʈ�� ����..
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
						Debug("--> ���� ���� ���� ��ư���� ����");
						requestCursedWeapon();

						SetLocContinent(serverInfoArray[i].clickedLocArray[clickCount]);	
						// ���� ������ �׸��� ������� ����ϱ� ������ ���϶����� ǥ�ø� ���� �ʴ´�.
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
					// ��ġ ������ ���� ǥ���� �� �����ϴ�.
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

// ���� ���� ��ư ����
function refreshServerInfoButton()
{
	local int i;
	local bool bUse;

	// ��ư�� �� ���� �ٽ� ����
	initServerButton();
	for (i = 0; i < serverInfoArray.Length; i++)
	{		
		setServerButton(getServerInfoButton(), i, serverInfoArray[i]);

		if (serverInfoArray[i].bUse) bUse = true;
	}

	// ���� ���� ��ư�� �ߺ��̰� ��ο� �����츦 ��ư�� �ϳ��� ������ ���̰� �Ѵ�.
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

	Debug("MAP ���� ��ư�� ���� á���ϴ�. 6�� ��ư�� ���� ���ϴ�.");
	return ServerInfo06_Button;

}

// ������ ���� ������ ��� ���� �װ� �Ľ��ؼ� �ʼ��� ���� ����ü�� �ְ�,
// �װ� �������� ��� �ִ� ���� ��ư�� ���� �ִ� ����̴�.
function setServerParse(int serverInfoType, string param, bool bUse, optional Vector clickedLoc, optional int nRegionID, optional int nData)
{
	// ������
	if (serverInfoType == MapServerInfoType.SIEGEWARFARE)
	{
		if (bUse)
		{
			serverInfoArray[serverInfoType].bUse = true;
			// ������ �� ����� �־��ٰ� �������� ��.
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

	// ���� ������
	else if (serverInfoType == MapServerInfoType.SIEGEWARFARE_DIMENSION)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		if (bUse)
		{
			//// ������ �� ����� �־��ٰ� �������� ��.
			//if(serverInfoArray[serverInfoType].szReserved == "")
			//	serverInfoArray[serverInfoType].szReserved = param;
			//else
			//	serverInfoArray[serverInfoType].szReserved = serverInfoArray[serverInfoType].szReserved $ "," $ param;

			// serverInfoArray[serverInfoType].toolTipString =	GetSystemString(3534) $ " : " $ serverInfoArray[serverInfoType].szReserved;
			//if (nRegionID > 0) serverInfoArray[serverInfoType].nRegionID = nRegionID;
			//serverInfoArray[serverInfoType].clickedLocArray[0] = setVector(147457, 990, 216);    // �Ƶ���
			//serverInfoArray[serverInfoType].clickedLocArray[1] = setVector(14032, -49151, 976);  // ��

			serverInfoArray[serverInfoType].clickedLocArray[0] = setVector(147461, 8000, -592);    // �Ƶ���			
			serverInfoArray[serverInfoType].clickedLocArray[1] = setVector(14659, -49230, -160);  // ��
		}
	}

    // ���� ���̵�
	else if (serverInfoType == MapServerInfoType.RAID_DIMENSION)
	{
		serverInfoArray[serverInfoType].bUse = bUse;

		serverInfoArray[serverInfoType].clickedLocArray[0] = setVector(116503, 75392, -2712);    // ��ɲ��� ���� �޸���		
	}

	// ���� �ڸ�ü
	else if (serverInfoType == MapServerInfoType.CURSEDWEAPON_MAGICAL)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		serverInfoArray[serverInfoType].clickedLocArray[0] = clickedLoc;
	}

	// ���� �ڸ�ü
	else if (serverInfoType == MapServerInfoType.CURSEDWEAPON_BLOOD)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		serverInfoArray[serverInfoType].clickedLocArray[0] = clickedLoc;
	}

	// ���� �ڸ�ü�� ��������
	else if (serverInfoType == MapServerInfoType.CURSEDWEAPON_MAGICAL_TreasureBox)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		serverInfoArray[serverInfoType].clickedLocArray[0] = clickedLoc;
	}

	// ���� ��ī�������� ��������
	else if (serverInfoType == MapServerInfoType.CURSEDWEAPON_BLOOD_TreasureBox)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		serverInfoArray[serverInfoType].clickedLocArray[0] = clickedLoc;
	}

	// ���
	else if (serverInfoType == MapServerInfoType.AUCTION)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		serverInfoArray[serverInfoType].clickedLocArray[0] = clickedLoc; //setVector(80323, 145501, -3504);
	}

	// ũ������ ���� ���ձ��� �����
	else if (serverInfoType == MapServerInfoType.DEFENSEWARFARE)
	{
		serverInfoArray[serverInfoType].bUse = bUse;
		serverInfoArray[serverInfoType].clickedLocArray[0] = setVector(-184750, 240723, 1568);
		serverInfoArray[serverInfoType].nData = nData; // ũ������ ���� ������ ���� �ý��� �޼����� ����
	}

	// ���� ��ư ����
	refreshServerInfoButton();

}
//--------------------------------------------------------------------------------------------------------------------------------------
// �ʿ� ������ �׸��� 
//--------------------------------------------------------------------------------------------------------------------------------------

// ���� �̴ϸʿ� �׸���� ���� ����ü
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

	// ���� �� �̼� ������ 
	regionInfoForMapIcon.eType = nMinimapRegionType;
	regionInfoForMapIcon.nIndex = i; //huntingZoneData.nSearchZoneID;
	regionInfoForMapIcon.strDesc = "";
	
	// ���� ����
	toolTipParam = "";

	if(nMinimapRegionType == EMinimapRegionType.MRT_HuntingZone_Mission)
	{
		// ���� üũ 
		bEnableLevel = tryLevelCheck(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel);

		if (bEnableLevel)
		{
			ParamAdd(toolTipParam, "Type", String(nMinimapRegionType));
			ParamAdd(toolTipParam, "Index", String(i));

			// ������ ����
			iconData = makeMapIcon(nMinimapRegionType, bEnableLevel, huntingZoneData.nWorldLoc);

			regionInfoForMapIcon.IconData = iconData;
			regionInfoForMapIcon.strTooltip = toolTipParam;

			// ���� �ʿ� �׸���
			addMapIcon(regionInfoForMapIcon, bUseUpdate);
		}
		
	}
	else if(nMinimapRegionType == EMinimapRegionType.MRT_InstantZone)
	{
		// ���� üũ 
		bEnableLevel = tryLevelCheck(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel);

		if (bEnableLevel)
		{
			ParamAdd(toolTipParam, "Type", String(nMinimapRegionType));
			ParamAdd(toolTipParam, "Index", String(i));
			ParamAdd(toolTipParam, "Active", String(boolToNum(bActive)));

			// ������ ����
			iconData = makeMapIcon(nMinimapRegionType, bActive, huntingZoneData.nWorldLoc);

			regionInfoForMapIcon.IconData = iconData;
			regionInfoForMapIcon.strTooltip = toolTipParam;

			// ���� �ʿ� �׸���
			addMapIcon(regionInfoForMapIcon, bUseUpdate);
		}
	}
	else if(nMinimapRegionType == EMinimapRegionType.MRT_Raid)
	{
		// ���� ���������� ���̵� ���� ǥ�� ����
		// if(IsBloodyServer()) return;

		raidData = getRaidDataByIndex(i);

		// ���� üũ 
		bEnableLevel = tryLevelCheck(pUserInfo.nLevel, raidData.nMinLevel, raidData.nMaxLevel);

		if (bEnableLevel)
		{
			ParamAdd(toolTipParam, "Type", String(nMinimapRegionType));
			ParamAdd(toolTipParam, "Index", String(i));
			ParamAdd(toolTipParam, "active", String(boolToNum(bActive)));

			// Debug("toolTipParam" @ toolTipParam);
		
			// ������ ����
			iconData = makeMapIcon(nMinimapRegionType, bActive, raidData.nWorldLoc);

			regionInfoForMapIcon.IconData = iconData;
			regionInfoForMapIcon.strTooltip = toolTipParam;

			// ���� �ʿ� �׸���
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

// �ʾȿ� ������ �� Ÿ���� ������ (���, ���̵� ����, ���� ������.. )
function MinimapRegionIconData makeMapIcon(int iconType, bool bActive, Vector pLoc)
{
	local MinimapRegionIconData iconData;

	local HuntingZoneUIData huntingZoneData;
	
	iconData.nWidth = 32;
	iconData.nHeight = 32;
	iconData.nWorldLocX = pLoc.x;// - iconData.nIconOffsetX; // 3197;  // - 3197 �� ��ȹ(���߰�), 16�ȼ��� �ش��ϴ°�.
	iconData.nWorldLocY = pLoc.y;// - iconData.nIconOffsetY; // 3197;
	iconData.nWorldLocZ = pLoc.z;
    iconData.nIconOffsetX = -16;
    iconData.nIconOffsetY = -16;

	//iconData.toolTipParam = toolTipString;

	if (iconType == EMinimapRegionType.MRT_HuntingZone_Mission)
	{
		if (bActive)
		{
			// �Ķ� ���
			iconData.strIconNormal = "L2UI_CT1.Minimap.map_huntingzone_i00";
			iconData.strIconOver   = "L2UI_CT1.Minimap.map_huntingzone_i00_Over";
			iconData.strIconPushed = "L2UI_CT1.Minimap.map_huntingzone_i00";
		}
		else
		{
			// ��� ����.
			// ȸ�� ���
			iconData.strIconNormal = "L2UI_CT1.Minimap.map_huntingzoneInactive_i00";
			iconData.strIconOver   = "L2UI_CT1.Minimap.map_huntingzoneInactive_i00_Over";
			iconData.strIconPushed = "L2UI_CT1.Minimap.map_huntingzoneInactive_i00";
		}
	}
	else if (iconType == EMinimapRegionType.MRT_InstantZone)
	{
		if (bActive)
		{		
			//debug("���� ���� ���..");
			iconData.strIconNormal = "L2UI_CT1.Minimap.map_inzone_gate_i00";
			iconData.strIconOver   = "L2UI_CT1.Minimap.map_inzone_gate_i00_Over";
			iconData.strIconPushed = "L2UI_CT1.Minimap.map_inzone_gate_i00";
		}
		else
		{
			//debug("ĢĢ�� ���� ���..");
			iconData.strIconNormal = "L2UI_CT1.Minimap.map_inzone_gateInactive_i00";
			iconData.strIconOver   = "L2UI_CT1.Minimap.map_inzone_gateInactive_i00_Over";
			iconData.strIconPushed = "L2UI_CT1.Minimap.map_inzone_gateInactive_i00";
		}
	}
	else if (iconType == EMinimapRegionType.MRT_Raid)
	{
		if (bActive)
		{
			// �Ķ� ���
			iconData.strIconNormal = "L2UI_CT1.Minimap.map_raid_spawning_i00";
			iconData.strIconOver   = "L2UI_CT1.Minimap.map_raid_spawning_i00_Over";
			iconData.strIconPushed = "L2UI_CT1.Minimap.map_raid_spawning_i00";
		}
		else
		{
			// ȸ�� ���
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

	// �ѿ����� �ȵǵ���..(���� �������� �ʰ�)
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
		//case 363:		//��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 364:		//��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 365:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 366:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 367:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 368:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 369:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 370:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 371:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 372:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 373:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 374:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 375:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 376:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 377:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 378:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		case 453:		// ������ ž
		case 454:		// ������ ž
		case 455:		// �緹���� ���ۼ�
		case 456:		// �緹���� ���ۼ�
		case 457:		// ���̾��� ž
		case 458:		// ���̾��� ž
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
		//case 363:		//��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 364:		//��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 365:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 366:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 367:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 368:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 369:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 370:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 371:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 372:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 373:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 374:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 375:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 376:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 377:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		//case 378:     //��ٿ�� GD3.5 2013-04-09 ��ٿ�嵵 �Ϲ� �����鿡�� ���̴� �� ����
		case 453:		// ������ ž
		case 454:		// ������ ž
		case 455:		// �緹���� ���ۼ�
		case 456:		// �緹���� ���ۼ�
		case 457:		// ���̾��� ž
		case 458:		// ���̾��� ž
			return true;
		default:
			return false;
	}		
}

// ��� �� �Ű� ���� �����ֱ� ,����Ʈ ���� ������ ��ġ�� �����ִ� �뵵�� MRT_Quest �߰�
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
	
	// ��ġ �̵�	
	SetContinent(m_MiniMap.GetContinent(XYZ));	
	class'UIAPI_MINIMAPCTRL'.static.AdjustMapView( "MinimapWnd.Minimap", XYZ, false );
	
	//m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Etc, true);
	m_MiniMap.SetShowRegionInfoByType(EMinimapRegionType.MRT_Quest, true);

	regionInfoForMapIcon = makeYellowPinRegionInfo (XYZ, tooltipString, tooltipString2);
	m_MiniMap.EraseRegionInfoCtrl(EMinimapRegionType.MRT_Quest, QUEST_START_NPC_ICON_INDEX) ;
	m_MiniMap.AddRegionInfoCtrl(regionInfoForMapIcon);	
}

// ��� �� ����� 
function hideYellowPin () 
{
	//m_MiniMap.EraseRegionInfoCtrl(EMinimapRegionType.MRT_Etc, QUEST_START_NPC_ICON_INDEX) ;
	m_MiniMap.EraseRegionInfoCtrl(EMinimapRegionType.MRT_Quest, QUEST_START_NPC_ICON_INDEX) ;
}

// ���� NPC ��ġ ������ �����
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
	regionInfoForMapIcon.nIndex = QUEST_START_NPC_ICON_INDEX; // ���� ���̾�� �Ѵ�.
	//regionInfoForMapIcon.strDesc = "�׽�Ʈ��¼�� ������";

	iconData.nWidth = 32;
	iconData.nHeight = 32;
	iconData.nWorldLocX = pLoc.x;// - iconData.nIconOffsetX; // 3197;  // - 3197 �� ��ȹ(���߰�), 16�ȼ��� �ش��ϴ°�.
	iconData.nWorldLocY = pLoc.y;// - iconData.nIconOffsetY; // 3197;
	iconData.nWorldLocZ = pLoc.z;
	iconData.nIconOffsetX = -3;
    iconData.nIconOffsetY = -20;

	// ��� ��
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
