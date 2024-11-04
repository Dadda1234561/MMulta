/////////////////////////////////////////////////////////////////////////////////////////////
//								����Ʈ �˸��� â 									     //
//														- create by innowind 2007.10.17	     //
/////////////////////////////////////////////////////////////////////////////////////////////

class QuestAlarmWnd extends UICommonAPI;
	
// ������ ����
// Ȯ�� Ÿ�̸�
/*
const TIMER_ID=11;
const TIMER_DELAY=2000;			// �� �����̸�ŭ �����Ǹ� â�� Ȯ��ȴ�.
// ��� Ÿ�̸�
const TIMER_ID2=12;
const TIMER_DELAY2=500;			// �� �����̸�ŭ �����Ǹ� â�� ��ҵȴ�.
*/

const QUEST_REQUEST_TIMERID    = 1123;


const EXPEND_CONTRACT_GAP = 37;

const CONTRACT_WIN_WIDTH = 213;
const EXPEND_WIN_WIDTH = 250;		// Ȯ��� ��ü ������ ����

const CONTRACT_QUEST_NAME_WIDTH = 198;
const EXPEND_QUEST_NAME_WIDTH = 235;	// ����Ʈ �̸� ����

const CONTRACT_ITEM_NAME_WIDTH = 113;
const EXPEND_ITEM_NAME_WIDTH = 150;	// ������ �̸� ����

const QUEST_ITEM_NUM_DEFAULT = 85;		// ����Ʈ ������ ����


const TEXT_HEIGHT = 18;				// �ؽ�Ʈ �⺻ ����
//const TEXT_HEIGHT_MARGIN = 2;			// �ؽ�Ʈ ����

const WINDOW_HEIGHT_MARGIN = 10;		// ������ ������ ����

const MAX_ITEM = 5;				// �ִ� ������ ��
const MAX_QUEST = 5;			// �ִ� ����Ʈ ��
const MAX_QUEST_ALL = 25;		//���� �� ���� ���Ѱ� ;;

// �������� �����
//var bool isWaitExpand;		// â�� Ȯ���ϱ� ���� ��ٸ��� �ִ°�?
//var bool isWaitContract;	// â�� ��� �Ǳ� ���� ��ٸ��� �ִ°�?
//var bool isExpand;		// â�� ���� Ȯ��� �����ΰ�?



var bool isClickedAdd;		// ��ư Ŭ������ �ֵ� �ߴ��� Ȯ���ϴ� �Լ�

var int m_NumOfQuest;		// ���� �������� �ִ� ����Ʈ�� ����

var int i, j;				// for ������ ���� ����

var Color Gold;
var Color White;
var Color Gray;

var int RecentlyAddedQuestID;

// �ڵ� �����
var WindowHandle Me;
//var WindowHandle QuestWndOverCheck;
var ButtonHandle btnClose;

var WindowHandle QuestWnd[MAX_QUEST];
var NameCtrlHandle QuestAlarmName[MAX_QUEST];
var int QuestAlarmNameID[MAX_QUEST];
var NameCtrlHandle QuestItemName[MAX_QUEST_ALL];
var int QuestItemNameID[MAX_QUEST_ALL];
var TextBoxHandle QuestItemNum[MAX_QUEST_ALL];
var INT64 QuestItemNumInt[MAX_QUEST_ALL];
var int QuestAlarmLevel[MAX_QUEST];



var int         MonsterQuestID;
var array<int>  MonsterNpcId;  
var array<int>  QuestStringType; //ldw 1014 ��Ʈ�� �� ����Ʈ (����Ʈ �̸��� ��Ʈ������ ����)
var array<int>  MonsterNumOfKillMonsters;

var QuestTreeWnd scQuestTree;
var QuestTreeDrawerWnd scQuestTreeDrawer;
var bool bOptionQuestAlarm;

var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent( EV_GamingStateExit );
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent( EV_MouseOver );
	RegisterEvent( EV_MouseOut );

	RegisterEvent( EV_ExpandQuestAlarmKillMonsterStart );
	RegisterEvent( EV_ExpandQuestAlarmKillMonster );
	RegisterEvent( EV_ExpandQuestAlarmKillMonsterEnd );

	RegisterEvent( EV_InventoryAddItem );
	RegisterEvent( EV_InventoryUpdateItem );
	
	RegisterEvent( EV_QuestList );
	RegisterEvent( EV_Restart );
}

function OnLoad()
{
	OnRegisterEvent();

	Initialize();
	Load();
	initData();	//�ش� �������� �ʱ�ȭ�۾�
	FitWindowSize();	//������ �����۾�

	scQuestTree = QuestTreeWnd( GetScript( "QuestTreeWnd" ) );
	scQuestTreeDrawer = QuestTreeDrawerWnd( GetScript( "QuestTreeDrawerWnd" ) );

	util = L2Util( GetScript( "L2Util"));
}

// InfoWnd �� height�� ���� �⺻ ��ġ�� ����
/*function onDefaultPosition() 
{	
	local WindowHandle InfoWnd;		
	local Rect infoRectWnd, MeRectWnd;

	local int currentScreenWidth, currentScreenHeight;	

	if( !Me.IsShowWindow() ) return;

	GetCurrentResolution (currentScreenWidth, currentScreenHeight);

	InfoWnd = GetWindowHandle ( "InfoWnd");
	
	infoRectWnd = InfoWnd.GetRect();
	MeRectWnd = Me.GetRect();
	
	// ���̴� ���� �� + ���� ���� �ؾ� ��. 212 �� InfoWnd.�� ���� ��ġ
	Me.MoveTo( currentScreenWidth - 3 - MeRectWnd.nWidth , 212 + 5 + infoRectWnd.nHeight );
}*/

// �ڵ� �ʱ�ȭ
function Initialize()
{
	//�ڵ� ������
	Me = GetWindowHandle( "QuestAlarmWnd" );
	//QuestWndOverCheck = GetWindowHandle( "QuestWndOverCheck" );
	btnClose = GetButtonHandle ( "QuestAlarmWnd.btnClose" );
	
	for(i=0 ; i<MAX_QUEST ; i++)
	{
		QuestWnd[i] =  GetWindowHandle( "QuestAlarmWnd.QuestWnd" $ i+1 );
		QuestAlarmName[i] = GetNameCtrlHandle ( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestAlarmName1");
		for (j=0 ; j<MAX_ITEM ; j++)
		{			
			QuestItemName[i * 5 + j] = GetNameCtrlHandle ( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemName" $ j + 1);
			QuestItemNum[i*5 + j] = GetTextBoxHandle ( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemNum" $ j + 1);
			QuestItemNum[i*5 + j].SetAnchor("QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemName" $ j + 1, "TopRight", "TopLeft", 3, 0);
		}

		//GetButtonHandle ( "QuestAlarmWnd.hideButton" $ i + 1 ).HideWindow();
	}	

	bOptionQuestAlarm = GetOptionBool("Game", "autoQuestAlarm");
}

function Load()
{	
	Gold.R = 175;
	Gold.G = 152;
	Gold.B = 120;
	Gold.A = 255;
	
	White.R = 250;
	White.G = 250;
	White.B = 250;
	White.A = 255;
	
	Gray.R = 135;
	Gray.G = 135;
	Gray.B = 135;
	Gray.A = 255;
}

function initData()
{	
//	isWaitExpand = false;
//  isExpand = false;
	
	for(i=0 ; i<MAX_QUEST ; i++)
	{
		QuestAlarmNameID[i] = -1;	// -1�̸� �󽽷�
		QuestAlarmName[i].SetName("", NCT_Normal,TA_Left);
		for (j=0 ; j<MAX_ITEM ; j++)
		{			
			QuestItemNameID[i*5 + j] = -1; 	// -1�̸� �󽽷�
			QuestItemName[i*5 + j].SetName("", NCT_Normal,TA_Left);
			QuestItemNum[i*5 + j].SetText("");			
		}
		//GetButtonHandle ( "QuestAlarmWnd.hideButton" $ i + 1 ).HideWindow();
	}	
	m_NumOfQuest= 0;
	
	isClickedAdd = false;

	bOptionQuestAlarm = GetOptionBool("Game", "autoQuestAlarm");

}

function UpdateOptionData()
{
	bOptionQuestAlarm = GetOptionBool("Game", "autoQuestAlarm");
}

function HandleQuestList( String param )
{
	//�ʿ� �� ���� ** ���� ���� ���� ��.
	
	local int i;

	local int QuestID;
	local int Level; 	

	//local string GoalName;
	local int needQuestItemNum;
	local int NeedItemID;
	local int Completed;
	local int GoalType;

	//����Ʈ ������ param
	local string QuestParam, alarmTitleStr;
	//�ʿ� ������ Max ��
	local int Max;		
	local int count; 

	local bool oneCall;
	
	ParseInt( param, "QuestID", QuestID );
	ParseInt( param, "Level", Level );
	ParseInt( param, "Completed", Completed );

	count   = 0;	
	oneCall = false;

	if (Completed == 0 ) 
	{
		if (bOptionQuestAlarm == true)
		{
			// �˶� ��� ����.
			return;
		}

		QuestParam = class'UIDATA_QUEST'.static.GetQuestItem( QuestID, Level );	
		ParseInt( QuestParam, "Max", Max );	
		
		/// Debug("QuestParam" @ QuestParam);
		for ( i = 0; i < Max; i++ )
		{	
			//����Ʈ �ʿ� ������ ID
			ParseInt( QuestParam, "GoalID_" $ i, NeedItemID );
			//����Ʈ �ʿ� ������ ����
			ParseInt( QuestParam, "GoalNum_" $ i, needQuestItemNum);
			//����Ʈ ��Ʈ�� Ÿ�� ����
			ParseInt( QuestParam, "GoalType_" $ i, GoalType);
			// Debug("_" @ NeedItemID @ needQuestItemNum @ GoalType );

			//Goalname = "";//class'UIDATA_QUEST'.static.GetQuestGoalName( QuestID, setLevel) ;
					
			// npcString�� ����, Ư�� ���� ������ ���� ���� �ϴ� ����
			if(GoalType == 1) 
			{
				alarmTitleStr = GetNpcString(NeedItemID);
				//count = needQuestItemNum;

				if (Completed > 0)
					count = needQuestItemNum;
				else
					count = 0;

				//Debug("==GoalType��? npc alarmTitleStr" @ alarmTitleStr);
			}
			// óġ��
			else if( NeedItemID >= 1000000 )
			{
				alarmTitleStr = class'UIDATA_NPC'.static.GetNPCName( NeedItemID - 1000000) $ " " $ GetSystemString(2240) ;				
				count = needQuestItemNum;
				//  Debug("==óġ�� alarmTitleStr" @ alarmTitleStr);
			}
			// ���� ����..
			else
			{
				alarmTitleStr = class'UIDATA_ITEM'.static.GetItemName( GetItemID( NeedItemID ));
				count = int(GetInventoryItemCount( GetItemID( NeedItemID)));
				//  Debug("==���� �Ϲ��� alarmTitleStr" @ alarmTitleStr);
				//m_scriptAlarm.AddQuestAlarm( SelectQuestID, SelectLevel, SelectarrItemID[i], SelectarrItemNumList[i] );
				//������ Quest�� ������ ������ ��û�Ѵ�.
			}

			//alarmTitleStr = class'UIDATA_ITEM'.static.GetItemName( GetItemID( NeedItemID ) );
			//count = int ( GetInventoryItemCount( GetItemID( NeedItemID )));			

			if (bOptionQuestAlarm == false)
			{
				AddQuestAlarmNew
				( 
					QuestID, 
					class'UIDATA_QUEST'.static.GetQuestName(QuestID, Level), 
					NeedItemID,
					alarmTitleStr,  //npc �������� 
					count, 
					needQuestItemNum,
					Level
				);
			}
			
			//if (IsThereDiffQuestType(i) && oneCall == false)
			if (oneCall == false)
			{								
				oneCall = true;
				RequestAddExpandQuestAlarm(questId);
			}			
		}
	}
}

function HandleGamingStateEnter()
{
	// End:0x1A
	if(m_NumOfQuest > 0)
	{
		Me.ShowWindow();
	}
}

function OnEvent( int a_EventID, String a_Param )
{
	//local string CurrentWndName;
	//local string ParentWndName;
	
	local int ClassID;
	local int questId;
	local int npcId;
	local int numOfKillMonsters;
	local int isStringType; //ldw 1014	

	switch( a_EventID )
	{
	 case EV_Restart:
	 Me.KillTimer(QUEST_REQUEST_TIMERID);
	 RecentlyAddedQuestID = 0;
	 			initData();
	 break;

	 case EV_QuestList :
		ParseInt( a_Param, "QuestID", questId );
		// Debug("EV_QuestList" @ questId);
		// Debug("scQuestTree.m_recentlyQuestID" @ scQuestTree.m_recentlyQuestID);
		
		if ( scQuestTree.m_recentlyQuestID == questId )
		{	
			HandleQuestList( a_Param );
			//RequestAddExpandQuestAlarm(questId);			
			//scQuestTree.m_recentlyQuestID  = 0;?? 
		}	
		break;
	/*
	case EV_MouseOver: //3060 
		
			ParseString(a_Param, "Name", CurrentWndName);
			ParseString(a_Param, "TopWndName", ParentWndName);
			Debug ( "mouseOver "  @ CurrentWndName @ ParentWndName );
		break;
	
	case EV_MouseOver: //3060
		ParseString(a_Param, "Name", CurrentWndName);
		ParseString(a_Param, "TopWndName", ParentWndName);
		//debug("mouse over!! Name : " $ CurrentWndName $ " parent : " $ ParentWndName);
		if(CurrentWndName == "QuestWndOverCheck" || ParentWndName == "QuestWndOverCheck")
		{
			// â�� ��ҵ� ���¿����� Ȯ��� ���·� ���� �� ����
			if(isExpand == false)	
			{
				Me.SetTimer(TIMER_ID,TIMER_DELAY);
				isWaitExpand = true;
			}
		}
		break;
	
	case EV_MouseOut: //3070
		ParseString(a_Param, "Name", CurrentWndName);
		ParseString(a_Param, "TopWndName", ParentWndName);
		//debug("mouse out!! Name : " $ CurrentWndName $ " parent : " $ ParentWndName);
		if(CurrentWndName == "QuestWndOverCheck" || ParentWndName == "QuestWndOverCheck")
		{			
			// Ȯ��� ���¿����� �ٿ��� �� �ִ�.
			if(isExpand == true)	 
			{
				ContractWindowSize();
				isExpand = false;
				isWaitContract = false;
			}
			isWaitExpand = false;
		}
		break;
	*/
	//������ �ʱ�ȭ���ֱ�
	case EV_MouseOut: break;
	case EV_GamingStateEnter:
		HandleGamingStateEnter();
		break;

	//���͸� ����� ��� ����
	case EV_ExpandQuestAlarmKillMonsterStart: //4931
		//�ʱ�ȭ.
		//Debug("EV_ExpandQuestAlarmKillMonsterStart");
		MonsterQuestID = 0;
		MonsterNpcId.Remove(0, MonsterNpcId.Length);
		QuestStringType.Remove(0, QuestStringType.Length); //ldw 1014
		MonsterNumOfKillMonsters.Remove(0, MonsterNumOfKillMonsters.Length);
		break;	

	//���͸� ����� ���
	case EV_ExpandQuestAlarmKillMonster:		//4930
		// Debug("EV_ExpandQuestAlarmKillMonster" @ a_Param);
		ParseInt( a_Param, "questId", questId);
		ParseInt( a_Param, "npcId", npcId );
		ParseInt( a_Param, "numOfKillMonsters", numOfKillMonsters );
		ParseInt( a_Param, "type", isStringType );	
		
		if ( npcId == -1 && numOfKillMonsters == -1 ) 
		{
			//Debug("EV_ExpandQuestAlarmKillMonster" @  questId @ npcId @numOfKillMonsters@ isStringType );		//�Ѵ� -1�� ��� �ѹ��� ���� ���� ����  �����
		}

		MonsterQuestID = questId;		
		
		if( npcId == -1 )
		{				
			MonsterZeroCount();
			return;
		}				
		MonsterNpcId.Insert( 0, 1 ) ;
		MonsterNpcId[0] = npcId ;
		MonsterNumOfKillMonsters.Insert( 0, 1 ) ;
		MonsterNumOfKillMonsters[0] = numOfKillMonsters ;
		QuestStringType.Insert( 0, 1 ) ;
		QuestStringType[0] = isStringType ;
		
		//CountKillMonsterUpdate( questId, npcId, numOfKillMonsters );
		break;

	//���͸� ����� ��� ��
	case EV_ExpandQuestAlarmKillMonsterEnd: //4932
		// Debug("EV_ExpandQuestAlarmKillMonsterEnd");	
		MonsterCountUpdate();

		break;	

	//������
	//case EV_InventoryAddItem:
	case EV_InventoryUpdateItem: //2600		
		if(Me.IsShowWindow())
		{
			ParseInt( a_Param, "classID", ClassID );	
			UpdateItemCount(ClassID);
		 }		 		
		break;
	}
}


/**
 * ���� ���� ������ �ľ��Ͽ� ������Ʈ.
 */
function MonsterCountUpdate()
{	
	local int i;
	local int j;
	local int k;
	local int count;
	local int isStringType;
//	Debug ("MonsterCountUpdate" @ MonsterQuestID);
	//��ü ����Ʈ
	for( i = 0 ; i < scQuestTree.ArrQuest.Length ; i ++ )
	{
		//����Ʈ�� �ʿ��� ������ �Ǵ� óġ ����.
		for( j = 0 ; j < scQuestTree.ArrQuest[i].arrNeedItemIDList.Length ; j ++ )
		{			
//			Debug ("MonsterCountUpdate" @ MonsterQuestID @ scQuestTree.ArrQuest[i].QuestID );

			//���� ����Ʈ ���.
			if( MonsterQuestID == scQuestTree.ArrQuest[i].QuestID )
			{
				count = 0;
				//���� ���� �迭.
				for( k = 0 ; k < MonsterNpcId.Length ; k ++ )
				{
					if( MonsterNpcId[k] == scQuestTree.ArrQuest[i].arrNeedItemIDList[j] ) //
					{
//						Debug ("���� ID ����Ʈ�� ����" @ scQuestTree.ArrQuest[i].QuestID @ MonsterNpcId[k]);
						count = MonsterNumOfKillMonsters[k];
						isStringType = QuestStringType[k];
						CountKillMonsterUpdate( MonsterQuestID, scQuestTree.ArrQuest[i].arrNeedItemIDList[j], count, isStringType);
					}
				}
				
				//Debug("isStringType" @ isStringType);
				
			}
		}
	}
}

/**
 * ���͸� �Ѹ����� ���� �ʾ��� ���.
 */
function MonsterZeroCount()
{
	local int i;
	local int j;
	local int setLevel;
	local int GoalType;
	local string QuestParam;

	//��ü ����Ʈ
	for( i = 0 ; i < scQuestTree.ArrQuest.Length ; i ++ )
	{
		//����Ʈ�� �ʿ��� ������ �Ǵ� óġ ����.
		for( j = 0 ; j < scQuestTree.ArrQuest[i].arrNeedItemIDList.Length ; j ++ )
		{			
			//���� ����Ʈ ���.
			if( MonsterQuestID ==  scQuestTree.ArrQuest[i].QuestID )
			{				
				setLevel = util.getQuestLevelForID( MonsterQuestID ); //getLevel(MonsterQuestID);
				QuestParam = class'UIDATA_QUEST'.static.GetQuestItem( MonsterQuestID, setLevel );
				ParseInt( QuestParam, "GoalType_" $ j, GoalType);// �� Ÿ������ �޾Ƶ� �� ��.
				//Debug("GoalType" @ GoalType  );
				CountKillMonsterUpdate( MonsterQuestID, scQuestTree.ArrQuest[i].arrNeedItemIDList[j], 0, GoalType );
			}
		}
	}
}

function CountKillMonsterUpdate( int QuestID, int npcId, int numOfKillMonsters, int isStringType)
{
	local int i;

	//�ʿ� ����Ʈ ������ �ִ� ����
	local int Max;
	//����Ʈ �ʿ� ������ ID
	local array<int> needQuestItemID;
	//����Ʈ �ʿ� ������ ����
	local array<int> needQuestItemNum;
	
	local string QuestParam;	
	//����Ʈ�� ���� ��
	local int setLevel;

	local string    Goalname;
	local int       Count;

	local int       GoalType;

	//Debug ("CountKillMonsterUpdate ok");
	setLevel = util.getQuestLevelForID( QuestID);

	QuestParam = class'UIDATA_QUEST'.static.GetQuestItem( QuestID, setLevel );

	ParseInt( QuestParam, "Max", Max );	
	needQuestItemID.Length = Max;	
	needQuestItemNum.Length = Max;

	for ( i = 0; i < Max; i++ )
	{
		//����Ʈ �ʿ� ������ ID

		ParseInt( QuestParam, "GoalID_" $ i, needQuestItemID[i] );
		//����Ʈ �ʿ� ������ ����
		ParseInt( QuestParam, "GoalNum_" $ i, needQuestItemNum[i] );		
		//����Ʈ ��Ʈ�� Ÿ�� ����
		ParseInt( QuestParam, "GoalType_" $ i, GoalType);// �� Ÿ������ �޾Ƶ� �� ��.

		// Debug("QuestParam" @QuestParam);
		//Debug( "i" @ i  @  npcId @  needQuestItemID[i]);
		//if( npcId == needQuestItemID[i] && isStringType == GoalType )
		if( npcId == needQuestItemID[i])
		{
			
			//debug( class'UIDATA_NPC'.static.GetNPCName( needQuestItemID[i] - 1000000 )$"�� "$ numOfKillMonsters$"/"$needQuestItemNum[i] );			
			//���͸� ����� ��� ���� ��.
			Goalname = "";//class'UIDATA_QUEST'.static.GetQuestGoalName( QuestID, setLevel) ;

			
			//Ÿ���� ��Ʈ�� ������ ��� 			
			if(GoalType == 1 ) 
			{
				//Debug("numOfKillMonsters" @ numOfKillMonsters );
				UpdateAlarmItem( needQuestItemID[i], numOfKillMonsters );
				if ( Goalname == "" ) 	
				{
					//Debug ("1 GetNpcString" @ Goalname);
					Goalname = GetNpcString(npcId) ;				
				}
					//Goalname = class'UIDATA_NPC'.static.GetNpcString(npcId) ;				

				Count = numOfKillMonsters;				

			} 
			else if( needQuestItemID[i] - 1000000 > 0 ) //�л��� �� ���
			{
				//Debug("Monster" @ needQuestItemID[i] @ Goalname);
				//Debug("numOfKillMonsters" @ numOfKillMonsters);
				
//				Debug ("�л���" @ QuestID @ needQuestItemID[i] @ numOfKillMonsters);
				UpdateAlarmItem( needQuestItemID[i], numOfKillMonsters, QuestID );
				if ( Goalname == "" ) 	
				{
					Goalname = class'UIDATA_NPC'.static.GetNPCName( needQuestItemID[i] - 1000000) $ " " $ GetSystemString(2240) ;				
					//Debug ("2 GetNpcString" @ Goalname);
				}

				Count = numOfKillMonsters;				
			}
			//������ ���ϴ� ����� ���� ���� �� ���� �������� ��� ����.
			//������ �������� ���� ���.
			else
			{				
				if ( Goalname == "" ) 
				{
					//Debug ("3 GetNpcString" @ Goalname);
					Goalname = class'UIDATA_ITEM'.static.GetItemName( GetItemID( needQuestItemID[i] ) );
				}

//				Debug("Item" @ needQuestItemID[i] @ Goalname);

				Count = int( GetInventoryItemCount( GetItemID( needQuestItemID[i] ) ) ) ;
			}

			if (bOptionQuestAlarm == false)
			{
				AddQuestAlarmNew
				( 
					QuestID, 
					class'UIDATA_QUEST'.static.GetQuestName(QuestID, setLevel), 
					needQuestItemID[i],
					GoalName, 
					Count, 
					needQuestItemNum[i],
					setLevel
				);			
			}
		}
	}	
	scQuestTree.ButtonEnableCheck();
}



//����Ʈ ������ ���� ����(ClassID=0�̸� ��ü �������� ����, a_ItemCount �⺻�� 0)
function UpdateItemCount( int ClassID, optional INT64 a_ItemCount )
{	
	local int       i;
	local int       j;
	local int       k;
	local INT64     ItemCount;
	local int       localQuestID;
	local int       localQuestLv;
	local string    Goalname ;
	local ItemID    itemID;
	local bool      isAddedQuest;


	isAddedQuest = false;

	// Debug("������ ��UpdateItemCount ");
	for( i = 0 ; i < scQuestTree.ArrQuest.Length ; i ++ )
	{
		for( j = 0 ; j < scQuestTree.ArrQuest[i].arrNeedItemIDList.Length ; j ++ )
		{			
			if (scQuestTree.ArrQuest[i].arrGoalType[j] == 0) // ��Ÿ���� 0�̰�,
			{
				if( ClassID == scQuestTree.ArrQuest[i].ArrNeedItemIDList[j] )//������ �ֳ׿� �� ����Ʈ ������Ʈ �ϰų� ��� ����?
				{
					//�켱 ����Ʈ ID�� ���� ���� �����ô�.
					localQuestID = scQuestTree.ArrQuest[i].QuestID;
					localQuestLv = scQuestTree.ArrQuest[i].Level;

					//����Ʈ ������Ʈ�� �־�����, goalType�� 0�� �͵� ������Ʈ �� �� �ֵ��� �÷��׸� �ٲߴϴ�.
					isAddedQuest = true;

					for ( k = 0 ; k < scQuestTree.ArrQuest[i].ArrNeedItemIDList.Length ; k++ )//
					{	
						if ( scQuestTree.ArrQuest[i].arrGoalType[k] == 0 ) // arrGoalType �� 0 �� �͸� ����մϴ�.
						{
							
							//�ٸ� �����۵� �޾Ƽ� ���� �ǵ��� ����
							itemID = GetItemID( scQuestTree.ArrQuest[i].ArrNeedItemIDList[k] );
							ItemCount = GetInventoryItemCount( itemID );
							UpdateAlarmItem( scQuestTree.ArrQuest[i].ArrNeedItemIDList[k], ItemCount );
							Goalname = class'UIDATA_ITEM'.static.GetItemName( itemID );

							if (bOptionQuestAlarm == false)
							{
								AddQuestAlarmNew( 
												localQuestID,
												class'UIDATA_QUEST'.static.GetQuestName( localQuestID, localQuestLv ),
												scQuestTree.ArrQuest[i].ArrNeedItemIDList[k],
												Goalname,
												int(ItemCount),
												scQuestTree.ArrQuest[ i ].ArrNeedItemNumList[ k ],
												localQuestLv
												);
							}
						}
					}					
				}
				
				if (isAddedQuest) //��Ʈ�� ��� ������
				{
					if ( IsThereDiffQuestType (i) ) //�ٸ� Ÿ���� �ִ��� �˻� �ؼ�
					{
						if (GetOptionBool("Game", "autoQuestAlarm") == false)
							RequestAddExpandQuestAlarm( localQuestID ); //������Ʈ �Ͽ��� 
					}
					scQuestTree.ButtonEnableCheck();		

					return;
				}
			}
		}
	}
}

function bool IsThereDiffQuestType( int QuestNum )
{
	local int i;
	
	for( i = 0 ; i < scQuestTree.ArrQuest[QuestNum].arrNeedItemIDList.Length ; i ++ )
	{
		if ( scQuestTree.ArrQuest[QuestNum].arrGoalType[i] == 1)
			return true;
		if ( scQuestTree.ArrQuest[QuestNum].arrNeedItemIDList[i] >= 1000000 )
			return true;
	}
	return false;
}



// Ÿ�̸� �⵿
/*
function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID)
	{
		if(isExpand == false && isWaitExpand == true )	// â�� Ȯ����� ���� ���¿����� Ȯ�����ش�.
		{
			ExpendWindowSize();
			
			isExpand = true;
			isWaitExpand = false;
		}
		Me.KillTimer( TIMER_ID );
	}
}*/

function OnTimer(int TimerID)
{	
	if(TimerID == QUEST_REQUEST_TIMERID)
	{
		// Debug("QUEST_REQUEST_TIMERID ũ�ƾƾ�" @ RecentlyAddedQuestID);
		//RequestAddExpandQuestAlarm( RecentlyAddedQuestID ); //������Ʈ �Ͽ��� 
		class'QuestAPI'.static.RequestQuestList();
		Me.KillTimer( QUEST_REQUEST_TIMERID );
	}
}

function externalDelayTimerRequestAddExpandQuest(int nRecentlyAddedQuestID)
{
	RecentlyAddedQuestID = nRecentlyAddedQuestID;

	if (RecentlyAddedQuestID > 0)
	{
		Me.KillTimer( QUEST_REQUEST_TIMERID );
		Me.SetTimer(QUEST_REQUEST_TIMERID, 1000);
		
		//Debug("����" @ RecentlyAddedQuestID);
	}
}

function OnClickButton( string Name )
{
	//local string buttonStr;
	//local int buttonIndex;

	// Debug("Name" @ Name);
	switch( Name )
	{
		case "btnClose":
			OnbtnCloseClick();
			break;
	}

	//Debug("---?" @ Left(Name, 10));

	//if (Left(Name, 10) == "hideButton")
	//{
	//	buttonIndex = int(Right(Name, 1));	//��ư�� ���� �� ���ڸ� ������. 
	//	Debug("buttonIndex" @ buttonIndex);

	//	if (QuestAlarmNameID[buttonIndex - 1] > 0)
	//	{
	//		scQuestTree.selectQuestTree("root." $ QuestAlarmNameID[buttonIndex - 1], false);
	//	}
		
	//	//QuestAlarmName[idx].SetNameWithColor(QuestName, NCT_Normal,TA_Left, Gold);
	//	//QuestAlarmNameID[idx] = QuestID;
	//	//QuestAlarmLevel[idx] = Level;


	//}
}

function OnbtnCloseClick()
{
	initData();
	if(Me.isShowWindow()) Me.HideWindow();
}

// Ȯ��� ��� ������ ������ ��ȭ��
function ExpendWindowSize()
{
	local int Height;
	local String tempStr;
	local int nWidth, nHeight;
	
	Me.GetWindowSize(i, Height);	//���̴� ��¥�� ������� �ʱ� ������ �׳� ����(i) ��Ȱ��
	
	Me.SetWindowSize( EXPEND_WIN_WIDTH,  Height );
	
	for(i = 0; i<MAX_QUEST ; i++)
	{
		QuestWnd[i].GetWindowSize(j , Height); //���̴� ��¥�� ������� �ʱ� ������ �׳� ����(j) ��Ȱ��
		QuestWnd[i].SetWindowSize( EXPEND_QUEST_NAME_WIDTH,  Height );
		QuestAlarmName[i].SetWindowSize( EXPEND_QUEST_NAME_WIDTH,  TEXT_HEIGHT );
	}
	
	for(i = 0 ; i< MAX_QUEST_ALL ; i++)
	{
		tempStr = QuestItemName[i].GetName();
		GetTextSizeDefault(tempStr, nWidth, nHeight);
		if(nWidth < EXPEND_ITEM_NAME_WIDTH && nWidth > 5)	// 5�� �׳� ����. (������ �̸��� 5�ȼ� ������ �� ���� ������ ) �ſ� ���� ������ ������ ("") �� �������� ����� ���߷��� ���� ���ϰ� �ϱ� ����
		{
			QuestItemName[i].SetWindowSize( nWidth,  TEXT_HEIGHT );
		}
		else
		{		
			QuestItemName[i].SetWindowSize( EXPEND_ITEM_NAME_WIDTH,  TEXT_HEIGHT );
		}
	}
	
	Me.MoveEx(CONTRACT_WIN_WIDTH - EXPEND_WIN_WIDTH  ,0);	// ����ŭ �̵����� �ش�.
}

// ��ҵ� ��� ������ ������ ��ȭ��
/*
function ContractWindowSize()
{
	local int Height;
	local String tempStr;
	local int nWidth, nHeight;
	
	Me.GetWindowSize(i, Height);	//���̴� ��¥�� ������� �ʱ� ������ �׳� ����(i) ��Ȱ��	
	Me.SetWindowSize( CONTRACT_WIN_WIDTH,  Height );
	
	for(i = 0; i<MAX_QUEST ; i++)
	{
		QuestWnd[i].GetWindowSize(j , Height); //���̴� ��¥�� ������� �ʱ� ������ �׳� ����(j) ��Ȱ��
		QuestWnd[i].SetWindowSize( CONTRACT_QUEST_NAME_WIDTH,  Height );
		QuestAlarmName[i].SetWindowSize( CONTRACT_QUEST_NAME_WIDTH,  TEXT_HEIGHT );
	}
	
	for(i = 0 ; i< MAX_QUEST_ALL ; i++)
	{
		tempStr = QuestItemName[i].GetName();
		GetTextSizeDefault(tempStr, nWidth, nHeight);
		if(nWidth < CONTRACT_ITEM_NAME_WIDTH  && nWidth > 5) // 5�� �׳� ����. (������ �̸��� 5�ȼ� ������ �� ���� ������ ) �ſ� ���� ������ ������ ("") �� �������� ����� ���߷��� ���� ���ϰ� �ϱ� ����
		{
			QuestItemName[i].SetWindowSize( nWidth,  TEXT_HEIGHT );
		}
		else
		{		
			QuestItemName[i].SetWindowSize( CONTRACT_ITEM_NAME_WIDTH,  TEXT_HEIGHT );
		}
	}
	
	Me.MoveEx(EXPEND_WIN_WIDTH - CONTRACT_WIN_WIDTH   ,0);	// ����ŭ �̵����� �ش�.
}*/

// ���� ��ϵ� ����Ʈ�鿡 �°� ������ ����� �����Ѵ�.  (�ַ� ���� ������)
function FitWindowSize()
{

	local int Width, Height;
	
	local int totalHeight; //�� �������� ����
	local int oneWinHeight;	// ������ �ϳ��� ����
	
	totalHeight = 0;
	m_NumOfQuest = 0;
	for(i = 0; i<MAX_QUEST ; i++)	// ����Ʈ�� ��ϵǾ��ٸ�, ����Ʈ �����츦 ��� ���ش�. 
	{
		if( QuestAlarmNameID[i] == -1)	
		{
			if(QuestWnd[i].IsShowWindow())		//��ϵ��� �ʾҴµ� show �ǰ��ִٸ� ���̵� �����ش�.
			{
				QuestWnd[i].HideWindow();
				// GetButtonHandle ( "QuestAlarmWnd.hideButton" $ i + 1 ).HideWindow();
			}
		}
		else
		{
			m_NumOfQuest++;	// ǥ�õǰ� �ִ� ����Ʈ�� ���� ������Ų��.
			if(!QuestWnd[i].IsShowWindow())
			{
				QuestWnd[i].showWindow();
				// GetButtonHandle ( "QuestAlarmWnd.hideButton" $ i + 1 ).showWindow();
			}
			
			oneWinHeight = 0;
			
			oneWinHeight = oneWinHeight + TEXT_HEIGHT;	//����Ʈ �̸���			
			
			for(j=0 ; j<MAX_ITEM ; j++)
			{
				if( QuestItemNameID[i * 5 + j] != -1)	
				{
					oneWinHeight = oneWinHeight + TEXT_HEIGHT;
				}
			}
			totalHeight = totalHeight + oneWinHeight +WINDOW_HEIGHT_MARGIN;
			
			QuestWnd[i].GetWindowSize(Width, Height);
			QuestWnd[i].SetWindowSize(Width, oneWinHeight);
			
			//GetButtonHandle ( "QuestAlarmWnd.hideButton" $ i + 1 ).MoveTo(QuestWnd[i].GetRect().nX, QuestWnd[i].GetRect().nY);
			//GetButtonHandle ( "QuestAlarmWnd.hideButton" $ i + 1 ).SetWindowSize(Width, oneWinHeight);

			// QuestWnd[i].SetTooltipText("�� �Ͽ�! " @ i);
		}
	}
	
	if(m_NumOfQuest == 0)	
	{
		if(Me.IsShowWindow()) Me.HideWindow();
	}
	else
	{
		//debug("totalHeight = " $ totalHeight);
		Me.GetWindowSize(Width, Height);
		Me.SetWindowSize(Width, totalHeight);
		// End:0x1FC
		if(! Me.IsShowWindow())
		{
			// End:0x1FC
			if(GetGameStateName() != "COLLECTIONSTATE")
			{
				Me.ShowWindow();
			}
		}
	}
}

// ���� ���� ����Ʈ �˶��� ���
// �˸� ����� ���� ��
// forceOpen �� ����Ʈ �ɼ� autoQuestAlarm �� ���� ���� ���� �ݰ� ���ٶ� ���
function AddQuestAlarmNew( int QuestID, string QuestName, int ItemID, string ItemName, int itemCount, INT64 ItemNum, int Level)
{
	//local string QuestName, ItemName;
	local int idx, idxItem, idxItemSomeID;
	//local INT64 itemCount;
	local String tempStr;
	//local int nWidth, nHeight;
	local Color tmpColor;
	//local bool QuestAutoAlarm;

	//local CustomTooltip T;
	
	//Debug("AddQuestAlarmNew"@QuestID@QuestName@ItemID@ItemName@itemCount);
	//QuestAutoAlarm = GetOptionBool("Game", "autoQuestAlarm"); 

	//// �ɼ��� üũ�Ǿ� ������ �׳� ����
	// if (QuestAutoAlarm == true && forceOpen == false) return;

	//������ �̸��� �ƺΰ͵� ������ �� �� ���� �� ���̹Ƿ� ���� ��.
	if ( ItemName == "") return;
	
	idx = QuestSlotIdx(QuestID);
	// ����Ʈ ���̵�� �̹� ��ϵ� ����Ʈ���� �˻��Ѵ�.	
	if( idx == -1) 	// �̹� ��ϵǾ� ���� ���� ����Ʈ��.
	{
		idx = FindEmptyQuestSlot();

		// Debug("�󽽷� idx " @ idx);
		// Debug("isClickedAdd " @ isClickedAdd);

		if(idx == -1)	// �󽽷��� ������ ����!
		{
			// 5�� �̻� ����� �� �����ϴ�. �ý��� �޼��� �����ֱ�.
			if(isClickedAdd == true)
			{
				AddSystemMessage(2279);
			}			
			isClickedAdd = false;
			return;
		}
		else
		{
			QuestAlarmName[idx].SetNameWithColor(QuestName, NCT_Normal,TA_Left, Gold);			
			/* ����Ʈ �˶� ���� / ����Ʈ ��Ͻ� ������ ���� �ش�.*/
			/* ����Ʈ ��Ʈ ��ȹ ���� Ȯ�� �� ���� �� ��.
			QuestWnd[idx].SetTooltipType("text");			
			QuestWnd[idx].SetTooltipCustomType( getQuestToolTip(QuestID, Level) );
			*/
			//Debug ( "���� ó�� " $ getQuestToolTip(QuestID, Level) );			
			
			QuestAlarmNameID[idx] = QuestID;
			QuestAlarmLevel[idx] = Level;
//			Debug ( "����Ʈ�� ���� ���� " @ idx @ QuestName @ QuestAlarmNameID[idx] );
		}
	}

	// ������ �̸� �־��ֱ�.	
	idxItem = FindEmptyItemSlot(idx);	// Ư�� ����Ʈ�� ������ ������ ���� ���� üũ
	if(idxItem == -1)	// �󽽷��� ������ ����!
	{
		//���״� �ƴϰ� ������ �� ADD �ϸ� ���� ����	
		return;
	}
	else
	{
		idxItemSomeID = QuestItemSlotIdx(idx, ItemID);		
		
		if(idxItemSomeID == -1)	//���� �������� ���ٸ� �߰�
		{
			//Debug( "itemCount>>>>" $ string(itemCount));
			//Debug( "ItemNum>>>>" $ string(ItemNum));
			
			if( ItemNum < 0 )
				ItemNum = -ItemNum;			

			tempStr = "- " $ ItemName;			

			if(itemCount < ItemNum || ItemNum == 0)			
				tmpColor = White;
			else			
				tmpColor = Gray;

			QuestItemName[idx*5 + idxItem].SetNameWithColor( tempStr, NCT_Normal,TA_Left, tmpColor);
			QuestItemNum[idx*5 + idxItem].SetTextColor(tmpColor);

			/*
			GetTextSizeDefault(tempStr, nWidth, nHeight);

			if(nWidth < CONTRACT_ITEM_NAME_WIDTH)
			{
				QuestItemName[idx*5 + idxItem].GetWindowSize( i , nHeight);	// i�� ������� �ʴ� ����.
				QuestItemName[idx*5 + idxItem].SetWindowSize(nWidth , nHeight);
			}*/

			// ������ ���� ǥ��
			//if(ItemNum == 0)	QuestItemNum[idx*5 + idxItem].SetText( "(" $ itemCount $ "/" $ "�� )");
			//if(ItemNum == 0)	QuestItemNum[idx*5 + idxItem].SetText( "(" $ itemCount $ "/" $ GetSystemString(858) $ ")");

			// Debug( "// ������ ���� ���� �������� ������ ǥ�����ش�.>>>" $ string(ItemNum) );
			// ������ ���� ���� �������� ������ ǥ�����ش�.
			if(ItemNum == 0 )
			{
				QuestItemNum[idx*5 + idxItem].SetText( "(" $ string(itemCount) $ ")");
			}
			else				
			{				
				QuestItemNum[idx*5 + idxItem].SetText( "(" $ string(itemCount) $ "/" $ string(ItemNum) $ ")");
				//if( itemCount < ItemNum )		QuestItemNum[idx*5 + idxItem].SetText( "(" $ itemCount $ "/" $ ItemNum $ ")");
				//else 						QuestItemNum[idx*5 + idxItem].SetText( "(" $ ItemNum $ "/" $ ItemNum $ ")");
			}				
			
			QuestItemNameID[idx*5 + idxItem] = ItemID;	
			QuestItemNumInt[idx*5 + idxItem] = ItemNum;			
			setItemWindowSize( idx*5 + idxItem, tempStr);

//			Debug ( "AddQuestAlarmNew" @ idx @ idx*5 + idxItem @ QuestItemNameID[idx*5 + idxItem] @ QuestItemNum[idx*5 + idxItem].GetText());
		}
	}
	// Debug("idx" @ idx);
	// GetButtonHandle ( "QuestAlarmWnd.hideButton" $ idx + 1 ).SetTooltipCustomType(getQuestToolTip(QuestID, Level));
	
	FitWindowSize();
}

function setItemWindowSize( int index, string tmpStr )
{
	local int nWidth, nWidth2, nHeight;
	local Rect myRectWnd ;
	// ������ �ʴ� �� ( �ؽ�Ʈ ������ġ, �ؽ�Ʈ �ڽ����� ���� ��, ��溸�� ��� )
	local int offSetX ;	
	offSetX = 25;
	myRectWnd = Me.GetRect() ;

	GetTextSizeDefault( tmpStr, nWidth, nHeight);
	GetTextSizeDefault( QuestItemNum[index].GetText(), nWidth2, nHeight);

	QuestItemNum[index].GetWindowSize( nWidth2, nHeight );	

	if ( nWidth + nWidth2 + offSetX > myRectWnd.nWidth)
	{
		nWidth = myRectWnd.nWidth - nWidth2 - offSetX;	
	}
	
	QuestItemName[index].SetWindowSize ( nWidth, nHeight );
}

/**
 * Ŀ��������(������Ŭ������ȯ��ư�����)
 **/
function CustomTooltip getQuestToolTip (int QuestID, int Level)
{
	local CustomTooltip m_Tooltip;
	local string questDesc, trimStr, huntingStr, tempStr, journalName;

	local Vector questZoneLoc;
	local int questZoneID, tooltipLine;

	
	questZoneLoc    = class'UIDATA_QUEST'.static.GetTargetLoc(QuestID, Level);
	
	questZoneID		= class'UIDATA_QUEST'.static.GetQuestZone(QuestID, Level);
	// questZoneName   = GetInZoneNameWithZoneID(questZoneID) @ ":::" @ class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(questZoneID);

	journalName     = class'UIDATA_QUEST'.static.GetQuestJournalName(QuestID, Level);

	questDesc       = class'UIDATA_QUEST'.static.GetQuestDescription( QuestID, Level);
		
	trimstr = trim(questdesc);

	questdesc  = substitute( questdesc, "\\n", " ", false);

	huntingstr = cutthestr(questdesc, GetSystemString(3318), true);   // ����� ���� �� �������� Ŀ��
	tempstr    = cutthestr(questdesc, GetSystemString(3318), false);

	if (len(tempstr) > 0) questdesc = tempstr;

	if (len(huntingstr) > 0) tooltipLine = 4;
	else tooltipLine = 3;
	
	// ��ǰ ���� 
	if (Len(questDesc)>0)
	{	
		m_Tooltip.DrawList.Length = tooltipLine;
		
		m_Tooltip.MinimumWidth = 230;
		m_Tooltip.DrawList[0].eType = DIT_TEXT;
		m_Tooltip.DrawList[0].t_color.R = 255;
		m_Tooltip.DrawList[0].t_color.G = 255;
		m_Tooltip.DrawList[0].t_color.B = 255;
		m_Tooltip.DrawList[0].t_color.A = 255;
		m_Tooltip.DrawList[0].t_strText = journalName;

		m_Tooltip.DrawList[1].eType = DIT_BLANK;
		m_Tooltip.DrawList[1].b_nHeight = 3;
		
		/*
		m_Tooltip.DrawList[2].eType = DIT_SPLITLINE;
		m_Tooltip.DrawList[2].u_nTextureWidth = 230;			
		m_Tooltip.DrawList[2].u_nTextureHeight = 1;
		m_Tooltip.DrawList[2].u_strTexture ="L2ui_ch3.tooltip_line";*/
		
		m_Tooltip.DrawList[2].eType = DIT_TEXT;
		m_Tooltip.DrawList[2].nOffSetY = 4;
		m_Tooltip.DrawList[2].bLineBreak = true;
		m_Tooltip.DrawList[2].t_color.R = 178;
		m_Tooltip.DrawList[2].t_color.G = 190;
		m_Tooltip.DrawList[2].t_color.B = 207;
		m_Tooltip.DrawList[2].t_color.A = 255;
		m_Tooltip.DrawList[2].t_strText = questDesc;

		if (tooltipLine > 3)
		{
			// ���������� ���� ǥ��
			m_Tooltip.DrawList[3].eType = DIT_TEXT;
			m_Tooltip.DrawList[3].nOffSetY = 10;
			m_Tooltip.DrawList[3].bLineBreak = true;
			m_Tooltip.DrawList[3].t_color.R = 211;
			m_Tooltip.DrawList[3].t_color.G = 30;
			m_Tooltip.DrawList[3].t_color.B = 30;
			m_Tooltip.DrawList[3].t_color.A = 255;
			// m_Tooltip.DrawList[4].t_strFontName = "hs10";
			m_Tooltip.DrawList[3].t_strText = huntingStr;
		}
	}	

	return m_Tooltip;
}

function string TrimRight(string S)
{
	S = Left(S, Len(S) - 1);
	return S;
}

/** ������ ��Ʈ�� ����, ������ ���ڿ��� ©�� ����. **/
function string cutTheStr(string s, string t, bool cutStringEnd)
{
	local int i;
	
	i = InStr(s , t);

	if (i <= -1) return "";
	else 
	{
		if (cutStringEnd) return Mid(s, i , len(s));	
		else return Mid(s, 0, i);	
	}
	
}

// ����Ʈ �˶����� ����
function DeleteQuestAlarm(int QuestID )	
{
	local int idx;
	local Color tempColor;
	local int nWidth, nHeight;
	
	idx = QuestSlotIdx(QuestID); 
	
	if( idx == -1) 	// �̹� ��ϵǾ� ���� ���� ����Ʈ��� �ƹ��͵� ���� �ʴ´�.
	{
		return; 
	}
	else
	{		
		// �Ʒ� ����Ʈ�� �����ֱ�
		for(i = idx + 1 ;  i < MAX_QUEST ; i++)
		{
			QuestAlarmName[i -1].SetNameWithColor( QuestAlarmName[i].GetName(), NCT_Normal,TA_Left, Gold);
			//QuestWnd[i -1].SetTooltipType("text");
			//QuestWnd[i -1].SetTooltipText( "������ ���̴���2 ?" );
			//QuestAlarmName[i -1].SetTooltipCustomType( getQuestToolTip(QuestAlarmNameID[i], QuestAlarmLevel[i]) );
//			Debug ( "��������??" @ QuestAlarmNameID[i-1] @ QuestAlarmNameID[i] );
			QuestAlarmNameID[i-1] = QuestAlarmNameID[i];
			QuestAlarmLevel[i-1] = QuestAlarmLevel[i];
	
			for (j=0 ; j<MAX_ITEM ; j++)
			{		
				tempColor =  QuestItemNum[i*5 + j].GetTextColor();
				
				QuestItemName[(i-1)*5 + j].SetNameWithColor(QuestItemName[i*5 + j].GetName() , NCT_Normal,TA_Left, tempColor);
				QuestItemName[i*5 + j].GetWindowSize(nWidth, nHeight);			// ������ ����� �Ű��ش�.
				QuestItemName[(i-1)*5 + j].SetWindowSize(nWidth, nHeight);
//				Debug ( "�и�?" @ (i-1) @ (i-1)*5 + j);
				QuestItemNameID[(i-1)*5 + j] = QuestItemNameID[i*5 + j]; 	
				QuestItemNum[(i-1)*5 + j].SetText( QuestItemNum[i*5 + j].GetText() );
				QuestItemNum[(i-1)*5 + j].SetTextColor (tempColor);
				QuestItemNumInt[(i-1)*5 + j] = QuestItemNumInt[i*5 + j];
			}
		}
		
		idx = MAX_QUEST - 1;
		QuestAlarmName[idx].SetName("", NCT_Normal,TA_Left);

		QuestAlarmNameID[idx] = -1;	
//		Debug ( "��������2??" @ QuestAlarmNameID[idx]  );
		QuestAlarmLevel[idx] = -1;
		for (j=0 ; j<MAX_ITEM ; j++)
		{		
			QuestItemName[idx*5 + j].SetName("", NCT_Normal,TA_Left);		
//			Debug ( "����!" @ (i-1) @ idx*5 + j);
			QuestItemNameID[idx*5 + j] = -1; 	// -1�̸� �󽽷�
			QuestItemNum[idx*5 + j].SetText("");
			QuestItemNumInt[idx*5 + j] = -1;
		}
	} 
	
	 FitWindowSize();
}

// Ư�� ���̵� �ش��ϴ� ����Ʈ �������� ������ �����Ͽ� �ش�.
function UpdateAlarmItem(int ItemID , INT64 Count, optional int questID)
{
	local string NameTemp1;
	local INT64 counts;
	local int questNum;
	
	for( i = 0; i < MAX_QUEST_ALL; i++ )
	{
		questNum = i / MAX_QUEST;
//		Debug( "UpdateAlarmItem" @ i @ QuestItemName[i].GetName() @ ItemID @ QuestItemNameID[ i ] @  questID @ QuestAlarmNameID[questNum]  @ Count @ questNum ) ;
		// QuestItemNameID[ i ] == ItemID addquestal
		// questID == QuestAlarmNameID[i]  �� ���� óġ�� ��� ����Ʈ ���̵� ���� �͸� ���� �Ѵ�. 
		// QuestAlarmNameID[i] == -1  �� ���� ���� �ʴ� ��� 
		
		if( QuestItemNameID[ i ] == ItemID && ( questID == QuestAlarmNameID[questNum] || questID == 0 || QuestAlarmNameID[questNum] == -1) )	
		{	
//			Debug ( "�����ض�" @ i @ QuestItemName[i].GetName() @ QuestItemNameID[ i ] == ItemID  @ questID == QuestAlarmNameID[questNum]  @ questID == 0  @ QuestAlarmNameID[questNum] == -1);
			//debug( "[Count]" $string(Count) );
			//debug( "[QuestItemNumInt[ i ]]" $string(QuestItemNumInt[ i ]) );
			
			if( QuestItemNumInt[ i ] < 0 )
				counts = -(QuestItemNumInt[ i ]);
			else
				counts= QuestItemNumInt[ i ];

			if( Count < counts || counts == 0 )	
			{	
				NameTemp1 = QuestItemName[ i ].GetName();
				QuestItemName[ i ].SetNameWithColor( NameTemp1, NCT_Normal,TA_Left, White );
				QuestItemNum[ i ].SetTextColor( White );	
			}
			else
			{	
				NameTemp1 = QuestItemName[ i ].GetName();
				QuestItemName[ i ].SetNameWithColor( NameTemp1, NCT_Normal,TA_Left, Gray );
				QuestItemNum[ i ].SetTextColor( Gray );
			}

			if( counts == 0 )
			{
				QuestItemNum[i].SetText( "(" $ string( Count ) $ ")");
			}
			else
			{	
				QuestItemNum[i].SetText( "(" $ string( Count) $ "/" $ string( counts )  $ ")");
			}

			setItemWindowSize( i, NameTemp1);

			return;
		}
	}
}

function UpdateAlarmExpand(int npcId , int Count)
{
	local string NameTemp1;

	for( i = 0; i<MAX_QUEST_ALL ; i++ )
	{
		if( QuestItemNameID[ i ] == npcId )	
		{			
			if( Count < QuestItemNumInt[ i ]  || QuestItemNumInt[ i ] == 0)	
			{	
				NameTemp1 = QuestItemName[ i ].GetName();
				QuestItemName[ i ].SetNameWithColor( NameTemp1, NCT_Normal,TA_Left, White );
				QuestItemNum[ i ].SetTextColor( White );	
			}
			else
			{	
				NameTemp1 = QuestItemName[ i ].GetName( );
				QuestItemName[ i ].SetNameWithColor( NameTemp1, NCT_Normal,TA_Left, Gray );
				QuestItemNum[ i ].SetTextColor( Gray );
			}
			
			if( QuestItemNumInt[i] == 0 )	
			{
				QuestItemNum[ i ].SetText( " (" $ string(Count) $ ")");
			}
			else				
			{	
				QuestItemNum[i].SetText( " (" $ string(Count) $ "/" $ string(QuestItemNumInt[i])  $ ")");
			}				
		}
	}
}

// �� ����Ʈ ������ ã�´�. -1�̸� �� á��
function int FindEmptyQuestSlot()
{
	local int slotID;
	
	slotID = -1;
	
	for(i = 0; i<MAX_QUEST ; i++)
	{
		if( QuestAlarmNameID[i] == -1)	
		{
			slotID = i;
			break;
		}
	}
	
	return slotID;
}

//�ش� ����Ʈ ���̵��� ���ؽ��� �����Ѵ�. 
function int QuestSlotIdx(int QuestID)
{
	local int slotID;
	
	slotID = -1;
	
	for(i = 0; i<MAX_QUEST ; i++)
	{
		if( QuestAlarmNameID[i] == QuestID)
		{
			slotID = i;
			break;
		}
	}
	
	return slotID;
}

// �� ����Ʈ ������ ������ ã�´�. -1�̸� �� á��
function int FindEmptyItemSlot(int QuestIdx)
{
	local int itemSlotID;
	
	itemSlotID = -1;
	for(i = 0; i<MAX_ITEM ; i++)
	{
		if( QuestItemNameID[QuestIdx * 5 + i] == -1)	
		{
			itemSlotID = i;
			break;
		}
	}
	
	return itemSlotID;
}

//�ش� ����Ʈ �������� ���̵� ���ؽ��� �����Ѵ�. 
function int QuestItemSlotIdx(int QuestIdx , int ItemID)
{
	local int itemSlotID;
	
	itemSlotID = -1;	
	for(i = 0; i<MAX_ITEM ; i++)
	{
		if(QuestItemNameID[QuestIdx * 5 + i]== ItemID)
		{
			itemSlotID = i;
			break;
		}
	}
	
	return itemSlotID;
}


// ����Ʈ �˶��� ����Ѵ�.
/*
 * ��� �ϴ� ���� ���� .
function AddQuestAlarm(int QuestID, int Level, int ItemID, INT64 ItemNum)
{
	local string QuestName, ItemName;
	local int idx, idxItem, idxItemSomeID;
	local INT64 itemCount;
	local String tempStr;
	local int nWidth, nHeight;
	
	//local int nItemNumWidth, nItemNumHeight;
		
	QuestName = class'UIDATA_QUEST'.static.GetQuestName(QuestID, Level);
	ItemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(ItemID));
	
	//debug( "QuestName>>" $ QuestName );
	//debug( "ItemName>>" $ ItemName );

	// Debug("AddQuestAlarm"@QuestID@QuestName@ItemID@ItemName@itemCount);

	// ����Ʈ ���̵�� �̹� ��ϵ� ����Ʈ���� �˻��Ѵ�.	
	idx = QuestSlotIdx(QuestID);
	if( idx == -1) 	// �̹� ��ϵǾ� ���� ���� ����Ʈ��.
	{
		idx = FindEmptyQuestSlot();
		if(idx == -1)	// �󽽷��� ������ ����!
		{
			// 5�� �̻� ����� �� �����ϴ�. �ý��� �޼��� �����ֱ�.
			if(isClickedAdd == true)
			{
				AddSystemMessage(2279);
			}			
			isClickedAdd = false;
			return;
		}
		else
		{
			QuestAlarmName[idx].SetNameWithColor(QuestName, NCT_Normal,TA_Left, Gold);
			//QuestWnd[idx].SetTooltipCustomType( getQuestToolTip(QuestID, Level) );
			//QuestWnd[idx].SetTooltipType("text");
			//QuestWnd[idx].SetTooltipText( "������ ���̴��� ?" );//getQuestToolTip(QuestID, Level) );
			QuestAlarmNameID[idx] = QuestID;
		}
	}	
	
	// ������ �̸� �־��ֱ�.	
	idxItem = FindEmptyItemSlot(idx);	// Ư�� ����Ʈ�� ������ ������ ���� ���� üũ

	if(idxItem == -1)	// �󽽷��� ������ ����!
	{
		//���״� �ƴϰ� ������ �� ADD �ϸ� ���� ����	
		return;
	}
	else
	{
		idxItemSomeID = QuestItemSlotIdx(idx, ItemID);
		
		if(idxItemSomeID == -1)	//���� �������� ���ٸ� �߰�
		{
			itemCount = GetInventoryItemCount(GetItemID(ItemID));		
			
			//debug("itemcount  = " $ string(itemCount));
			
			if(itemCount < ItemNum || ItemNum == 0)
			{
				tempStr = "- " $ ItemName;				
				GetTextSizeDefault(tempStr, nWidth, nHeight);				
				QuestItemName[idx*5 + idxItem].SetNameWithColor( tempStr, NCT_Normal,TA_Left, White);
				QuestItemNum[idx*5 + idxItem].SetTextColor(White);
				
				if(nWidth < CONTRACT_ITEM_NAME_WIDTH)
				{
					QuestItemName[idx*5 + idxItem].GetWindowSize( i , nHeight);	// i�� ������� �ʴ� ����. 
					QuestItemName[idx*5 + idxItem].SetWindowSize(nWidth , nHeight);
				}
			}

			else
			{
				tempStr = "- " $ ItemName;
				GetTextSizeDefault(tempStr, nWidth, nHeight);
				QuestItemName[idx*5 + idxItem].SetNameWithColor(tempStr, NCT_Normal,TA_Left, Gray);
				QuestItemNum[idx*5 + idxItem].SetTextColor(Gray);
				
				if(nWidth < CONTRACT_ITEM_NAME_WIDTH)
				{
					QuestItemName[idx*5 + idxItem].GetWindowSize( i , nHeight);	// i�� ������� �ʴ� ����. 
					QuestItemName[idx*5 + idxItem].SetWindowSize(nWidth , nHeight);
				}
				//Debug ( "AddQuestAlarm" @ tempStr);
			}
			 
			// ������ ���� ǥ��
			//if(ItemNum == 0)	QuestItemNum[idx*5 + idxItem].SetText( "(" $ itemCount $ "/" $ "�� )");
			//if(ItemNum == 0)	QuestItemNum[idx*5 + idxItem].SetText( "(" $ itemCount $ "/" $ GetSystemString(858) $ ")");
			if(ItemNum < 1)	{QuestItemNum[idx*5 + idxItem].SetText( "(" $ string(itemCount) $ ")");}	// ������ ���� ���� �������� ������ ǥ�����ش�.
			else				
			{				
				QuestItemNum[idx*5 + idxItem].SetText( "(" $ string(itemCount) $ "/" $ string(ItemNum) $ ")");
				//if( itemCount < ItemNum )		QuestItemNum[idx*5 + idxItem].SetText( "(" $ itemCount $ "/" $ ItemNum $ ")");
				//else 						QuestItemNum[idx*5 + idxItem].SetText( "(" $ ItemNum $ "/" $ ItemNum $ ")");
			}
				
			QuestItemNameID[idx*5 + idxItem] = ItemID;	
			QuestItemNumInt[idx*5 + idxItem] = ItemNum;
		}
	}

	// Debug("idx" @ idx);
	// GetButtonHandle ( "QuestAlarmWnd.hideButton" $ idx + 1 ).SetTooltipCustomType(getQuestToolTip(QuestID, Level));
	
	FitWindowSize();
	
	isClickedAdd = false;
}

function AddQuestAlarmExpand(int questID, int questLevel, int npcId, int numOfKillMonsters, INT64 npcMaxCount )
{
	local int npcCurrentCount;

	local string questName, npcName;
	local int existQuestIndex ;//, emptySlotIndex;
	local int emptyNpcSlotIndex, existNpcSlotIndex;

	local string tempStr;
	local int nWidth, nHeight;

	questName = class'UIDATA_QUEST'.static.GetQuestName( questId, questLevel );

	//if( questType == 0)
	//{
	npcName = class'UIDATA_NPC'.static.GetNPCName( npcId - 1000000 );
	//}

	//debug( "questName>>" $ questName );
	//debug( "npcName>>" $ npcName );

	// óġ : 2240
	npcName = npcName $ " " $ GetSystemString(2240);

	npcCurrentCount = numOfKillMonsters;

	existQuestIndex = QuestSlotIdx( questId );
	if( existQuestIndex == -1 )
	{
		existQuestIndex = FindEmptyQuestSlot( );
		if( existQuestIndex == -1 )
		{
			if( isClickedAdd == true )
			{
				AddSystemMessage( 2279 );
			}	
			isClickedAdd = false;
			return;
		}
		else
		{
			QuestAlarmName[existQuestIndex].SetNameWithColor( questName, NCT_Normal, TA_Left, Gold );
			//QuestAlarmName[existQuestIndex].SetTooltipCustomType( getQuestToolTip(QuestID, questLevel) );
			//QuestWnd[existQuestIndex].SetTooltipType("text");
			//QuestWnd[existQuestIndex].SetTooltipText( "������ ���̴��� ?" );

			
			QuestAlarmNameID[existQuestIndex] = questId;
		}
	}

	emptyNpcSlotIndex = FindEmptyItemSlot( existQuestIndex );
	if(emptyNpcSlotIndex == -1)	
	{
		return;
	}
	else
	{
		existNpcSlotIndex = QuestItemSlotIdx( existQuestIndex, npcId );

		if( existNpcSlotIndex == -1 )
		{
			if( npcCurrentCount < npcMaxCount || npcMaxCount == 0 )
			{
				tempStr = "- " $ npcName;
				GetTextSizeDefault( tempStr, nWidth, nHeight );
				QuestItemName[ existQuestIndex * 5 + emptyNpcSlotIndex ].SetNameWithColor( tempStr, NCT_Normal, TA_Left, White );
				QuestItemNum[ existQuestIndex * 5 + emptyNpcSlotIndex ].SetTextColor( White );

				if( nWidth < CONTRACT_ITEM_NAME_WIDTH )
				{
					QuestItemName[existQuestIndex * 5 + emptyNpcSlotIndex].GetWindowSize( i , nHeight );
					QuestItemName[existQuestIndex * 5 + emptyNpcSlotIndex].SetWindowSize( nWidth , nHeight );
				}
			}
			else
			{
				tempStr = "- " $ npcName;
				GetTextSizeDefault( tempStr, nWidth, nHeight );
				QuestItemName[ existQuestIndex * 5 + emptyNpcSlotIndex ].SetNameWithColor( tempStr, NCT_Normal, TA_Left, Gray );
				QuestItemNum[ existQuestIndex * 5 + emptyNpcSlotIndex ].SetTextColor( Gray );

				if( nWidth < CONTRACT_ITEM_NAME_WIDTH )
				{
					QuestItemName[existQuestIndex * 5 + emptyNpcSlotIndex].GetWindowSize( i , nHeight );
					QuestItemName[existQuestIndex * 5 + emptyNpcSlotIndex].SetWindowSize( nWidth , nHeight );
				}
			}

			if( npcMaxCount < 1 )
			{
				QuestItemNum[existQuestIndex * 5 + emptyNpcSlotIndex ].SetText( " (" $ string( npcCurrentCount ) $ ")" );
			}
			else				
			{		
				QuestItemNum[existQuestIndex * 5 + emptyNpcSlotIndex ].SetText( " (" $ string( npcCurrentCount ) $ "/" $ string( npcMaxCount ) $ ")" );
			}
				
			QuestItemNameID[existQuestIndex * 5 + emptyNpcSlotIndex ] = npcId;
			QuestItemNumInt[existQuestIndex * 5 + emptyNpcSlotIndex ] = npcMaxCount;
		}
	}

	FitWindowSize();	
	isClickedAdd = false;	
}

function int getLevel (int QuestID)
{
	local int i;
	
	// ������ ������ �޾ƾ� �ϹǷ� �ڿ��� ���� ������.
	for( i = scQuestTree.ArrQuest.Length - 1 ; i >= 0  ; i -- )
	{
		if( QuestID == scQuestTree.ArrQuest[i].QuestID )
		{			
			return scQuestTree.ArrQuest[i].Level ;			
		}		
	}
	return 0 ;
}*/

defaultproperties
{
}
