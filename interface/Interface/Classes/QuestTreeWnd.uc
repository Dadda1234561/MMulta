class QuestTreeWnd extends UICommonAPI;

const QUESTTREEWND_MAX_COUNT = 40;

const QUEST_WINDOW_ONE = 0;
const QUEST_WINDOW_REPEAT  = 1;
const QUEST_WINDOW_EPIC = 2;
const QUEST_WINDOW_JOB = 3;
const QUEST_WINDOW_SPECIAL = 4;

var WindowHandle Me;
var TabHandle QuestTreeTab;
var TextureHandle TexTabBg;
var TextureHandle TexTabBgLine;
var TextBoxHandle txtQuestTreeTitle;
var TextBoxHandle txtQuestNum;

var TreeHandle MainTree0;
var TreeHandle MainTree1;
var TreeHandle CurTree;

var CheckBoxHandle chkAssignNotifier;
var CheckBoxHandle chkNpcPosBox;
var ButtonHandle btnDetailInfo;

//Tree Root �̸�.
var string ROOTNAME;
//��ȸ�� ����Ʈ Tree
var string TREE0;
//�ݺ��� ����Ʈ Tree
var string TREE1;
//���� ����Ʈ Tree
var string TREE2;
//���� ����Ʈ Tree
var string TREE3;
//Ư�� ����Ʈ Tree
var string TREE4;

struct QuestUseInfo
{
	//����Ʈ ���̵� ����
	var int                 QuestID;
	//����Ʈ ���� ����
	var int                 Level;
	//����Ʈ �Ϸ� ����
	var int                 Completed;
	//����Ʈ Ÿ�� ����
	var int                 QuestType;

	//?? ���� �Ӹ�..;;
	var bool                bShowCompletionItem;

	//����Ʈ �ʿ� ������ ID
	var array<int>		    ArrNeedItemIDList;
	//����Ʈ �ʿ� ������ ����
	var array<int>		    ArrNeedItemNumList;
	//����Ʈ �� Ÿ�� 
	var array<int>		    ArrGoalType;

	
	//���� ������ ID
	var Array<int>          RewardIDList;	
	//���� ������ ����
	var Array<INT64>          RewardNumList;
};

//����Ʈ ������ �迭
var array<QuestUseInfo> ArrQuest;

//tree ���� ����
var bool bDrawBgTree;

var string beforeTreeName;

var QuestAlarmWnd       scQuestAlarm;
var QuestTreeDrawerWnd  scTreeDrawer;
	
var ButtonHandle      m_btnAddAlarm;
var ButtonHandle      m_btnDeleteAlarm;


//Tree ������ ����
var L2Util util;

var int     QuestID_Alarm;
var int     QuestLevel_Alarm;
var int     QuestEnd_Alarm;

//���� ����Ʈ ����
var int		m_QuestNum;	
//���� ����Ʈ ��ȣ
var int		m_OldQuestID;

//�̴ϸ� ���� ���� ����Ʈ
var ListCtrlHandle 					ListTrackItem1;
var array<LVDataRecord>				m_QuestTrackData;
var int	m_TrackID;

var int		    m_DeleteQuestID;
var string		m_DeleteNodeName;

//GM Tool ��.
var String 		m_WindowName;

var int         m_recentlyQuestID; //���� ���� ����Ʈ �ӽ� ����  (getExpandQuestID�� ����� �۵� ���� ����)

var NoticeWnd      noticeWndScript;

// ���� ������ ����Ű�� �ִ� (����ʿ���)
var vector currentQuestDirectTargetPos;
var string currentQuestDirectTargetString;

var bool   QuestAutoAlarm;
//var Bool        m_IsShowArrow; //ldw 3D ȭ��ǥ�� ���� ���� �ִ��� ���� -> ����Ʈ â������ 3d ȭ��ǥ�� ���� ų �� �ֵ��� �ϴ� ��ɿ� ��.

//var EMinimapTargetIcon DirIconDestType; //ldw ���� ���� ���� �ִ� Ÿ��ȭ��ǥ Ÿ��

static function QuestTreeWnd Inst()
{
	return QuestTreeWnd(GetScript("QuestTreeWnd"));	
}

event OnRegisterEvent()
{	
	RegisterEvent( EV_QuestListStart );
	RegisterEvent( EV_QuestList );
	RegisterEvent( EV_QuestListEnd );
	RegisterEvent( EV_QuestSetCurrentID );	
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_Restart );
}

event OnLoad()
{
	SetClosingOnESC();

	Initialize();

	util = L2Util(GetScript("L2Util"));	
	scQuestAlarm = QuestAlarmWnd( GetScript( "QuestAlarmWnd" ) );
	scTreeDrawer = QuestTreeDrawerWnd(GetScript("QuestTreeDrawerWnd"));
	noticeWndScript = NoticeWnd(GetScript("NoticeWnd"));

	//	m_IsShowArrow = false;
	CurTree = MainTree0;
	chkNpcPosBox.SetCheck(true);
	bDrawBgTree = false;
	m_QuestNum = 0;
	m_OldQuestID = 0;
	m_recentlyQuestID = 0;
}

function Initialize()
{
	Me =                    GetWindowHandle( m_WindowName );
	QuestTreeTab =          GetTabHandle(m_WindowName$".QuestTreeTab" );
	TexTabBg =              GetTextureHandle( m_WindowName$".TexTabBg" );
	TexTabBgLine =          GetTextureHandle( m_WindowName$".TexTabBgLine" );
	txtQuestTreeTitle =     GetTextBoxHandle( m_WindowName$".txtQuestTreeTitle" );
	txtQuestNum =           GetTextBoxHandle( m_WindowName$".txtQuestNum" );
	
	MainTree0 =             GetTreeHandle( m_WindowName$".MainTree0" );
	MainTree1 =             GetTreeHandle( m_WindowName$".MainTree1" );
	chkAssignNotifier =     GetCheckBoxHandle( m_WindowName$".chkAssignNotifier" );
	chkNpcPosBox =          GetCheckBoxHandle( m_WindowName$".chkNpcPosBox" );
	btnDetailInfo =         GetButtonHandle( m_WindowName$".btnDetailInfo" );

	m_btnAddAlarm =         GetButtonHandle("QuestTreeDrawerWnd.btnAddAlarm");
	m_btnDeleteAlarm =      GetButtonHandle("QuestTreeDrawerWnd.btnDeleteAlarm");

	//ListTrackItem1 = GetListCtrlHandle( "MiniMapDrawerWnd.ListTrackItem1" );
}

function OnDefaultPosition()
{
	QuestTreeTab.MergeTab(QUEST_WINDOW_ONE);
//	QuestTreeTab.MergeTab(QUEST_WINDOW_REPEAT);
//	QuestTreeTab.MergeTab(QUEST_WINDOW_EPIC);
	QuestTreeTab.MergeTab(QUEST_WINDOW_JOB);
//	QuestTreeTab.MergeTab(QUEST_WINDOW_SPECIAL);
	QuestTreeTab.SetTopOrder(0, true);
}


function OnShow()
{	
	local string    ExpandedNode;
	local int       nQuestType;

	//Debug ( " onShow");
	QuestTreeTab.InitTabCtrl();		

	//ldw ����Ʈ ������ ���� �߰� �� �κ�
	ExpandedNode = GetExpandedNode();
	nQuestType = Class'UIDATA_QUEST'.static.GetQuestIscategory(getCurQuestID(), 1);
//	Debug("nQuestType" @ nQuestType @ "getCurQuestID()"@getCurQuestID() @"ExpandedNode"@ExpandedNode);
	//ldw ����Ʈ ������ ���� �߰� �� �κ�
//	InsertQuestTrackList();
	
	ShowQuestList();	//���� �ִ� �κ� ����Ʈ�� �ٽ� ����
	
	CurTree = GetTreeHandle(m_WindowName$".MainTree"$getTreeNum(nQuestType));

	if (ExpandedNode != "NULL"){	
		QuestTreeTab.SetTopOrder(getTreeNum(nQuestType),false); //�� �ٲٰ�

		CurTree.SetExpandedNode( ExpandedNode, true);//��� Ȯ��		
		//Debug("OnShow "@ ExpandedNode);
		CheckQuestTrackList();                       //�̴ϸ��� üũ ���� �ٲ�
	}
	

	//InsertQuestTrackList();
	
	//Debug("GetExpandedNode()4"@ GetExpandedNode());
	
	QuestAutoAlarm = GetOptionBool("Game", "autoQuestAlarm");
	scQuestAlarm.UpdateOptionData();
	
	if(QuestAutoAlarm == true)
	{
		chkAssignNotifier.SetCheck(true);
	}
	else
	{
		chkAssignNotifier.SetCheck(false);
	}
	//MainTree0.HideWindow();
	//MainTree1.HideWindow();
	//MainTree2.HideWindow();
	//MainTree3.HideWindow();
	//MainTree4.HideWindow();
	
	
	/*if (CurTree == MainTree0)
	{
		QuestTreeTab.SetTopOrder(0,false);
	}
	else if (CurTree == MainTree1)
	{
		QuestTreeTab.SetTopOrder(1,false);
	}
	else if (CurTree == MainTree2)
	{
		QuestTreeTab.SetTopOrder(2,false);
	}
	else if (CurTree == MainTree3)
	{
		QuestTreeTab.SetTopOrder(3,false);
	}
	else if (CurTree == MainTree4)
	{
		QuestTreeTab.SetTopOrder(4,false);
	}*/
	CurTree.Setfocus();
}

//////////////////////
//Request Quest List
function ShowQuestList()
{
	class'QuestAPI'.static.RequestQuestList();		//EV_QuestListStart -> EV_QuestList -> EV_QuestListEnd	
}

function OnClickButton( string strID )
{
	// Debug("onClickButton"@strID);
	
	switch( strID )
	{
		case "btnClose":
			if (class'UIAPI_WINDOW'.static.IsShowWindow("QuestTreeDrawerWnd"))
			{
				class'UIAPI_WINDOW'.static.HideWindow( "QuestTreeDrawerWnd" );	
			}
			else 
			{
				UpdateTargetInfo();
				class'UIAPI_WINDOW'.static.ShowWindow( "QuestTreeDrawerWnd" );	
			}
			break;	

		case "QuestTreeTab0":
			setTabChange(0);
			break;

		case "QuestTreeTab1":
			setTabChange(1);
			break;

		case "btnDetailInfo":
			OnbtnDetailInfoClick();
			break;
	}

	selectQuestTree(strID, true);
	
//	HandleQuestSetCurrentID(strID);

	/*
	if ( Left( strID, 4 ) == ROOTNAME )
	{	
		UpdateTargetInfo();
		//GetCurrentJournalID(strID);
		//Drawer_btnGiveUpCurrentQuest.EnableWindow();		
		// Ŭ�� �� ����Ʈ�� ù��° ����� ��� ������ ����� ����Ʈ�� ���� �� ��.
		scTreeDrawer.showQuestDrawer( strID );

		//showQuestDrawerLstChild(); ldw ����� �� ����
		
		ButtonEnableCheck();ui4 
	}
}*/

}

// ����Ʈ Ʈ�� ����
function selectQuestTree(string strID, bool isButtonClick)
{
	local int SplitCount ;//, questCategory;
	local array<string>	arrSplit;	

	if ( Left( strID, 4 ) == ROOTNAME )
	{			

		// Ŭ�� �� ����Ʈ�� ù��° ����� ��� ������ ����� ����Ʈ�� ���� �� ��.
		SplitCount = Split( strID, ".", arrSplit );

		//questCategory = Class'UIDATA_QUEST'.static.GetQuestType(int(arrSplit[1]), 1 );

		//Debug("quest num :" @ arrSplit[1]);

		// ������ �Լ��� ������Ѽ� Ʈ���� �����ϴ� �Ͱ� Ʈ���� ��ư�� Ŭ�� �ϴ� �� ����
		if (isButtonClick == false)	CurTree.SetExpandedNode(strID, true);

		m_recentlyQuestID = 0;
		UpdateTargetInfo();		
		if (getExpandedNode() == "" )  //Ȯ�� �� ��尡 ���� 
		{		
			if (class'UIAPI_WINDOW'.static.IsShowWindow("QuestTreeDrawerWnd"))
			{
				class'UIAPI_WINDOW'.static.HideWindow( "QuestTreeDrawerWnd" );	
			}
			//ListTrackItem1.SetSelectedIndex(-1, false);//�̴ϸ��� ����Ʈ ���� ����
		} 
		else 
		{   			
			//GetCurrentJournalID(strID);
			//Drawer_btnGiveUpCurrentQuest.EnableWindow();					
			//setMiniMapDrawerQuest();
			
			if( SplitCount == 2 )
			{
				scTreeDrawer.showQuestDrawer( LastNodeName( int(arrSplit[1]), 1, Class'UIDATA_QUEST'.static.GetQuestIscategory( int( arrSplit[1] ), 1 ) ) );			
			}
			else if( SplitCount == 4 )
			{
				scTreeDrawer.showQuestDrawer( strID );
			}
			ButtonEnableCheck();
		}
	}		
}


/*function showQuestDrawerLstChild()
{
	local array<string>		arrSplit;
	local int				SplitCount;
	
	local int QuestID;
	local int Level;
	local int Completed;
	
	local string strChildList;
	local string strTargetNode;
	
	local string strNodeName;
	local string strTargetName;
	local vector vTargetPos;
	local bool bOnlyMinimap;

	//��ġǥ�� üũ�ڽ�
	if ( !chkNpcPosBox.IsChecked() )
	{
		 SetQuestOff();
		 return;
	}
	
	strNodeName = GetExpandedNode();

	if (Len(strNodeName)<1)
	{
		SetQuestOff();
		return;
	}

	///////////////////////////////////////////////////////////////////////
	//Expanded�� ��尡 ����Ű�� ����Ʈ�� Targetǥ�ÿ� ������ ã�ƾ���
	///////////////////////////////////////////////////////////////////////
	
	// 1. Child��带 ���Ѵ�.
	strChildList = CurTree.GetChildNode(strNodeName);
	
	// 2. Child�� ������, Child�߿��� ���� ������ Child�� Targetǥ�ÿ� ����
	if (Len(strChildList)>0)
	{
		SplitCount = Split(strChildList, "|", arrSplit);
		strTargetNode = arrSplit[SplitCount-1];
		Debug("strTargetNode" @ strTargetNode);
	}
	else
	{
		SetQuestOff();
		return;
	}
	// 3. �̸��� �м��ؼ�, QuestID�� Level�� ���  �ʿ� ���� ����Ʈ ��常 �ʿ�
	arrSplit.Remove(0,arrSplit.Length);
	SplitCount = Split( strTargetNode, ".", arrSplit );
	QuestID = int( arrSplit[1] );

	if( SplitCount == 2 )
	{
		Level = 1;
		Completed = 0;
	}
	else if( SplitCount == 4 )
	{
		Level = int( arrSplit[2] );
		Completed = int( arrSplit[3] );
	}

	if ( QuestID > 0 && Level > 0 )
	{
		//Target�̸� ���
		strTargetName = class'UIDATA_QUEST'.static.GetTargetName(QuestID, Level);
		vTargetPos = class'UIDATA_QUEST'.static.GetTargetLoc(QuestID, Level);
		
		if (Completed==0 && Len(strTargetName)>0)
		{
			bOnlyMinimap = class'UIDATA_QUEST'.static.IsMinimapOnly(QuestID, Level);
			if (bOnlyMinimap)
			{
				class'QuestAPI'.static.SetQuestTargetInfo( true, false, false, strTargetName, vTargetPos, QuestID);
				m_IsShowArrow = false;
			}
			else
			{
				class'QuestAPI'.static.SetQuestTargetInfo( true, true, true, strTargetName, vTargetPos, QuestID);
				m_IsShowArrow = true;
			}
		}
		else
		{
			SetQuestOff();
		}
	}	
}*/

/**
 * �� �̵��� ����. 
 */
function setTabChange( int select )
{	

	local array<string>		arrSplit;
	local int				SplitCount;

	local string            expandedNode;

	CurTree.HideWindow();	
	CurTree = GetTreeHandle( m_WindowName$".MainTree" $ string(select) );
	GetTreeHandle( m_WindowName$".MainTree" $ string(select) ).ShowWindow();	
	scTreeDrawer.btnGiveUpCurrentQuest.DisableWindow();

	// ldw ���� ���� �ִ� ���� Ȯ�� �� ����� ����Ʈ�� Ȱ��ȭ �ؾ� ��.
	expandedNode =  GetExpandedNode(); 
	UpdateTargetInfo();
	if (expandedNode == "") 
	{
			if (class'UIAPI_WINDOW'.static.IsShowWindow("QuestTreeDrawerWnd"))
			{
				class'UIAPI_WINDOW'.static.HideWindow( "QuestTreeDrawerWnd" );	
			}
			//ListTrackItem1.SetSelectedIndex(-1, false);//�̴ϸ��� ����Ʈ ���� ����		
	}
	else 
	{
		if ( Left( GetExpandedNode(), 4 ) == ROOTNAME )
		{				
			//setMiniMapDrawerQuest();
			//GetCurrentJournalID(strID);
			//Drawer_btnGiveUpCurrentQuest.EnableWindow();		

			// Ŭ�� �� ����Ʈ�� ù��° ����� ��� ������ ����� ����Ʈ�� ���� �� ��.
			SplitCount = Split( expandedNode, ".", arrSplit );
			
			if( SplitCount == 2 )
			{
				scTreeDrawer.showQuestDrawer( LastNodeName( int(arrSplit[1]), 1, Class'UIDATA_QUEST'.static.GetQuestIscategory( int( arrSplit[1] ), 1 ) ) );			
			}
			else if( SplitCount == 4 )
			{
				scTreeDrawer.showQuestDrawer( expandedNode );			
			}
			ButtonEnableCheck();
		}
	}


	if( select != 4 )
		class'UIAPI_WINDOW'.static.ShowWindow( m_WindowName$".txtQuestNum" );
	else
		class'UIAPI_WINDOW'.static.HideWindow( m_WindowName$".txtQuestNum" );

}

function OnClickCheckBox( String strID )
{
	switch( strID )
	{
		case "chkNpcPosBox":
			UpdateTargetInfo();
		/*
		if ( chkNpcPosBox.IsChecked() )
		{
			UpdateTargetInfo();
		}
		*/ 
		break;
		 
		case "chkAssignNotifier":
		//����Ʈ �˸��� �ڵ� ������ üũ�Ǿ� ���� ���
		if( chkAssignNotifier.IsChecked() )
		{
			SetOptionBool("Game", "autoQuestAlarm",true);
			QuestAutoAlarm = true;
		}
		else 
		{
			SetOptionBool("Game", "autoQuestAlarm",false);
			QuestAutoAlarm = false;
		}

		scQuestAlarm.UpdateOptionData();
		
		break;
	 }
}

function OnbtnDetailInfoClick()
{
	//local QuestTreeDrawerTestWnd Drawer;
	//Drawer =  GetWindowHandle( "QuestTreeDrawerTestWnd" );
	//Drawer.ShowWindow();
	class'UIAPI_WINDOW'.static.ShowWindow( "QuestTreeDrawerWnd" );	
}

function OnEvent(int Event_ID,String param)
{	
	if( Event_ID == EV_QuestListStart )
	{		
		//Debug ("EV_QuestListStart" @ param);		
		HandleQuestListStart();		
		//Me.ShowWindow();
	}
	else if( Event_ID == EV_QuestList )
	{	
		//Debug ("EV_QuestList" @ param);		
		HandleQuestList( param );				
	}
	else if( Event_ID == EV_QuestListEnd )
	{	
		//Debug ("EV_QuestListEnd" @ param);
		
		HandleQuestListEnd(); // �� ���ķ� GetExpandedNode �� �� �� ���� Ȱ��ȭ �ȴ�.
		
		InsertQuestTrackList();		
		//curTree.SetExpandedNode( "root.10322", true);//Ȯ���� �ȴ�. ���� Ȱ��ȭ�� �ȵ�.
		//scTreeDrawer.showQuestDrawer( "root.10322" );

		//.ButtonEnableCheck()

		ButtonEnableCheck();

			
//		Debug( "EV_QuestListEnd3" @ curTree.GetExpandedNode( "root" ) );
	}
	else if( Event_ID == EV_QuestSetCurrentID )
	{
		//Debug("�˸� ���������� ȣ�� �Ͽ� �� ��� ������~ param EV_QuestSetCurrentID>>" $ param );
		HandleQuestSetCurrentID( param );
		CurTree.Setfocus();
		Me.SetFocus();
	}
	else if ( Event_ID == EV_DialogOK )
	{
		if (DialogIsMine())
		{
			//Cancel
			if (DialogGetID() == 0 )
			{
				scQuestAlarm.DeleteQuestAlarm( m_DeleteQuestID );	// �˸��̿����� ����
				
				class'QuestAPI'.static.RequestDestroyQuest(m_DeleteQuestID);
				SetQuestOff();
				
				//��� ����
				CurTree.DeleteNode(m_DeleteNodeName);
				
				m_DeleteQuestID = 0;
				m_DeleteNodeName = "";
				class'UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");
			}
			//Cannot Cancel
			else
			{
			}
		}
	}
	else if( Event_ID == EV_Restart ){
		SetQuestOff();
//		m_IsShowArrow = false;
	}
}

function curQuestExpand(int QuestID){
	
	m_recentlyQuestID = QuestID;
	//curTree.SetExpandedNode( "root."$QuestID, true);

	//Debug ("curQuestExpand2" @ curTree.GetExpandedNode( "root" ) );
}

/**
 * ����Ʈ ����Ʈ ����.
 */
function HandleQuestListStart()
{
	//�ʱ�ȭ
	
	InitTree();	
	initVars();	
}

/**
 * ����Ʈ ����Ʈ ���� ����.
 */
function HandleQuestList( String param )
{
	
	local int i;

	local int QuestID;
	local int Level; 
	local int Completed;
	local int nQuestType;

	//����Ʈ ������ param
	local string QuestParam;
	//�ʿ� ������ Max ��
	local int Max;	

	ParseInt( param, "QuestID", QuestID );
	ParseInt( param, "Level", Level );
	ParseInt( param, "Completed", Completed );
	
	nQuestType = Class'UIDATA_QUEST'.static.GetQuestIscategory(QuestID, Level);
	
	
	ArrQuest.insert( ArrQuest.Length, 1 );
	//����Ʈ ���̵� ����.
	ArrQuest[ ArrQuest.Length -1 ].QuestID         = QuestID;
	//����Ʈ ���� ����
	ArrQuest[ ArrQuest.Length -1 ].Level           = Level;
	//����Ʈ �Ϸ� ����
	ArrQuest[ ArrQuest.Length -1 ].Completed       = Completed;
	//����Ʈ Ÿ�� ����
	ArrQuest[ ArrQuest.Length -1 ].QuestType       = nQuestType;

	if( Completed == 0 )
	{
		QuestParam = class'UIDATA_QUEST'.static.GetQuestItem( QuestID, Level );	

		ParseInt( QuestParam, "Max", Max );	
		ArrQuest[ ArrQuest.Length -1 ].arrNeedItemIDList.Length = Max;	
		ArrQuest[ ArrQuest.Length -1 ].arrNeedItemNumList.Length = Max;
		ArrQuest[ ArrQuest.Length -1 ].arrGoalType.Length = Max;		

		for ( i = 0; i < Max; i++ )
		{
			//����Ʈ �ʿ� ������ ID
			ParseInt( QuestParam, "GoalID_" $ i, ArrQuest[ ArrQuest.Length -1 ].arrNeedItemIDList[i] );
			//����Ʈ �ʿ� ������ ����
			ParseInt( QuestParam, "GoalNum_" $ i, ArrQuest[ ArrQuest.Length -1 ].arrNeedItemNumList[i] );
			//����Ʈ �� Ÿ��
			ParseInt( QuestParam, "GoalType_" $ i, ArrQuest[ ArrQuest.Length -1 ].arrGoalType[i] );
		}

		//���� ������
		class'UIDATA_QUEST'.static.GetQuestReward( QuestID, Level, ArrQuest[ ArrQuest.Length -1 ].rewardIDList, ArrQuest[ ArrQuest.Length -1 ].rewardNumList );
	}

	if (m_OldQuestID != QuestID)
	{
		if ( nQuestType != 4 )
			m_QuestNum++;
	}

	m_OldQuestID = QuestID;	
}

/** �ܺο��� ���� �޾��� ����Ʈ ID�� �˻��Ѵ� */
function bool isQuestIDSearch( int questID )
{
	local int  i, questLen;
	local bool flag;

	flag = false;
	questLen = ArrQuest.Length;
	
	for(i = 0; i < questLen; i++)
	{   
		// ���ٸ� true ����
		if (questID == ArrQuest[i].QuestID)
		{
			flag = true;
			break;
		}
	}
	
	return flag;
		
}

/**
 * ����Ʈ ����Ʈ ��
 */
function HandleQuestListEnd()
{
	local int       i;
	local int       j;
	local int       nQuestType;	

	//TTP #47783
	//����Ʈ�� ���� ��� â�ݱ�.
	//Debug("m_QuestNum>>>" $ string(m_QuestNum) );
	if( m_QuestNum == 0 )
	{
		class'UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");
		scTreeDrawer.AllClear();
		//btnDetailInfo.DisableWindow();
	}
	else
	{
		//btnDetailInfo.EnableWindow();
	}
	setTreeQuestList();	//���� GetExpandedNode�� ������
	
	//�Ϸ� �Ǿ��� ��� ����.
	for( i = 0 ; i < ArrQuest.Length ; i ++ )
	{
		for ( j = 0 ; j < 5 ; j ++ )
		{
			//Debug( "ArrQuest[i].QuestID == scQuestAlarm.QuestAlarmNameID[j]" $ string(ArrQuest[i].QuestID) $ "==" $ string(scQuestAlarm.QuestAlarmNameID[j]) );
			//Debug( "ArrQuest[i].Level == scQuestAlarm.QuestAlarmLevel[j]" $ string(ArrQuest[i].Level) $ "==" $ string(scQuestAlarm.QuestAlarmLevel[j]) );
			if( ArrQuest[i].QuestID == scQuestAlarm.QuestAlarmNameID[j] && ArrQuest[i].Level == scQuestAlarm.QuestAlarmLevel[j] )
			{
				if( ArrQuest[i].Completed == 1 )
				{
					//Debug( "ArrQuest[i].QuestID == scQuestAlarm.QuestAlarmNameID[j]" $ string(ArrQuest[i].QuestID) $ "==" $ string(scQuestAlarm.QuestAlarmNameID[j]) );
					//Debug( "ArrQuest[i].Level == scQuestAlarm.QuestAlarmLevel[j]" $ string(ArrQuest[i].Level) $ "==" $ string(scQuestAlarm.QuestAlarmLevel[j]) );
					//Debug( "J��??-->" $ string(j) );
					scQuestAlarm.DeleteQuestAlarm( scQuestAlarm.QuestAlarmNameID[ j ] );
				}
			}
		}
	}
	//�Ϸ� �� ����Ʈ�� ���� �Ǿ��� ��� �˸� ����.
	for ( j = 0 ; j < 5 ; j ++ )
	{
		if( scQuestAlarm.QuestAlarmNameID[j] != -1 )
		{
			findNowQuestExist( scQuestAlarm.QuestAlarmNameID[j] );
		}
	}
	UpdateQuestCount();	
	/*
	//QuestAlarmNameID[MAX_QUEST]�� ������ ���� ���� 25�� ������ �մϴ�.
	// �˸��̿��� �ִµ� ����Ʈ�� ������ �ش� �˸��̴� �����Ͽ��ش�.
	// �ϵ��ڵ� �˼��մϴ�. (__)
	for( all = 0; all < 25 ; all++ )	
	{
		tempItemID = scQuestAlarm.QuestItemNameID[all];

		if( tempItemID  == -1 )
			return;		

		for( i = 0 ; i < ArrQuest.Length ; i ++ )
		{
			for( j = 0 ; j < ArrQuest[i].arrNeedItemIDList.Length ; j ++ )
			{
				debug( "HandleQuestListEnd ���ſ�!!>>>" $ class'UIDATA_ITEM'.static.GetItemName( GetItemID( ArrQuest[i].ArrNeedItemIDList[j] ) ) );
				if( tempItemID == ArrQuest[i].ArrNeedItemIDList[j] )
				{
					isExist = true;	
					break;
				}
			}
		}

		if(isExist == false)
		{
			debug("222222���� ����?? ����222" $ string( all / 5 ) );
			scQuestAlarm.DeleteQuestAlarm( scQuestAlarm.QuestAlarmNameID[ all / 5 ] );
		}
	}*/	
	if ( m_recentlyQuestID != 0 )
	{
		nQuestType = Class'UIDATA_QUEST'.static.GetQuestIscategory(m_recentlyQuestID, 1);
		QuestTreeTab.SetTopOrder(getTreeNum(nQuestType),false);
		//setTabChange( nQuestType );
		setCurrentTree(nQuestType);

		CurTree.SetExpandedNode( "root."$m_recentlyQuestID, true);
		scTreeDrawer.showQuestDrawer( "root."$m_recentlyQuestID );
			
		scTreeDrawer.showQuestDrawer( LastNodeName( m_recentlyQuestID, 1, nQuestType ) );			
		//ExpandclildNode( m_recentlyQuestID );//���ϵ尡 ������ �װɷ� �ͽ��ҵ�
		//CheckQuestTrackList();                       //�̴ϸ��� üũ ���� �ٲ�
		//scTreeDrawer.showQuestDrawer( arrSplit[SplitCount-1] );
	}
	Detele3DArrow(); // ����Ʈ �� 3dȭ��ǥ�� �̴ϸ��� ȭ��ǥ�� ���� �Ѵ�.
	//UpdateTargetInfo(); // ����Ʈ�� �ްų� ����Ʈ �Ϸ� �� 3dȭ��ǥ�� �������ų� ������, ����Ʈâ�� ���� �ΰ� �ݾ� �ΰ� ��� ����
}

/*function gedExpandclildNode(int QuestID)
{
	local string            strChildList;	
	local array<string>		arrSplit;
	local int				SplitCount;
	
	strChildList = CurTree.GetChildNode("root."$QuestID);
	if (Len(strChildList)>0)
	{
		SplitCount = Split(strChildList, "|", arrSplit);
		strTargetNode = arrSplit[SplitCount-1];
	}
	// 3. �̸��� �м��ؼ�, QuestID�� Level�� ���
	arrSplit.Remove(0,arrSplit.Length);
	SplitCount = Split( strTargetNode, ".", arrSplit );
	QuestID = int( arrSplit[1] );
}*/

function Detele3DArrow()
{
//	local int i;
	//local bool b3Darrow;
	local int QuestID;
	//local int n3DLevel;

	//local string strTargetName;
	local vector vTargetPos;

	//b3Darrow = false;
	QuestID = getCurQuestID(); //������ ����Ʈ ID �� ���� ��� ����Ʈ ���� ������, 3D ȭ��ǥ ����
	//Debug("getCurQuestID()" @ getCurQuestID());
	//�Ϸ� �Ǿ��� ��� ����.
	/*for( i = 0 ; i < ArrQuest.Length ; i ++ )
	{
		if( n3DQuest == ArrQuest[i].QuestID )
		{
			b3Darrow = true;
			n3DLevel = ArrQuest[i].Level;
		}		
	}*/
	
	
	//UpdateTargetInfo();
	if (QuestID == 0) // ��ó�� ����Ʈ�� ������ ���� 
	//if( !b3Darrow )
	{
		// End:0x41
		if(! IsPlayerOnWorldRaidServer())
		{
			class'QuestAPI'.static.SetQuestTargetInfo(false, false, false, "", vTargetPos, questID, 0);
		}
		//n3DLevel = ArrQuest[i].Level;
		//strTargetName = class'UIDATA_QUEST'.static.GetTargetName(n3DQuest, n3DLevel);
		//vTargetPos = class'UIDATA_QUEST'.static.GetTargetLoc(n3DQuest, n3DLevel);
		//class'QuestAPI'.static.SetQuestTargetInfo( false, false, false, strTargetName, vTargetPos, n3DQuest, n3DLevel);	
		//class'QuestAPI'.static.SetQuestTargetInfo( false, false, false, "", vTargetPos, QuestID, 0);	
	//	DisableAllDirIcon();
		class'UIAPI_WINDOW'.static.HideWindow( "QuestTreeDrawerWnd" );	
		//scTreeDrawer.HideWindow();
		CallGFxFunction("RadarMapWnd", "hideQuestTargetInfo" , "" ) ;
		CallGFxFunction("MiniMapGfxWnd","hideQuestTargetInfo","");
	} 
	else 
	{
		
	}
}


/**
 * ����Ʈ�� ���ٸ� �˸��� �����ش�.
 */
function findNowQuestExist( int QuestID )
{
	local int i;
	local bool isExist;

	for( i = 0 ; i < ArrQuest.Length ; i ++ )
	{
		if( ArrQuest[i].QuestID == QuestID )
		{
			isExist = true;	
			break;
		}
	}

	if( !isExist )
	{
		scQuestAlarm.DeleteQuestAlarm( QuestID );

		// ���߸��� �۵� �ϵ���..
		if(GetReleaseMode() == RM_DEV) 
		{
			// ���߸����� reloadfs �� �ڲ� �ٿ� �Ǵ� ������ �־ ���߸������� ��� ����.
			// empty
		}
		else
		{
			if(class'UIAPI_WINDOW'.static.IsShowWindow("NoticeWnd"))
			{
				// ����Ʈ�� �������� �ʿ� ���� ����Ʈ �˸��� �������ش�.
				noticeWndScript.hideNoticeButton_QUEST();
			}
		}
	}
}

//Ʈ�� �ʱ�ȭ.
function initTree()
{
	MainTree0.Clear();
	MainTree1.Clear();
}

//���� �ʱ�ȭ
function initVars()
{
	m_QuestNum = 0;
	m_OldQuestID = 0;
	m_TrackID = 0;

	m_DeleteQuestID = 0;
	m_DeleteNodeName = "";

	ArrQuest.Remove(0, ArrQuest.Length);
}


function setTreeQuestList()
{
	local int i;
	//�߰� �� Tree �̸�
	local string TreeName;
	//����Ʈ ����
	local string QuestName;
	//����Ʈ �� ����
	local string JournalName;	
	//
	local string setTreeName;

	local string strRetName;
	
	local LVDataRecord Record;
	local LVData data1;
	local LVData data2;	
	
	for( i = 0 ; i < ArrQuest.Length ; i ++ )
	{		
		TreeName = m_WindowName$".MainTree" $ getTreeNum(ArrQuest[i].QuestType);
		setTreeName = ROOTNAME$"."$string( ArrQuest[i].QuestID );			
		JournalName = class'UIDATA_QUEST'.static.GetQuestJournalName( ArrQuest[i].QuestID, ArrQuest[i].Level );
		//branch 110720_0804
		JournalName = class'UIDATA_QUEST'.static.GetQuestJournalNameSplit( JournalName, ArrQuest[i].Completed );
		//end of branch
		//Debug("JournalName" @ JournalName);
		// ���� ����Ʈ ��尡 ���� �Ѵٸ� 
		
		if (class'UIAPI_TREECTRL'.static.IsNodeNameExist( TreeName, setTreeName))
		{			
			//������ �ٲ� ��
			QuestName = class'UIDATA_QUEST'.static.GetQuestName( ArrQuest[i].QuestID, ArrQuest[i].Level);
			class'UIAPI_TREECTRL'.static.SetNodeItemText ( TreeName, setTreeName, 0, QuestName) ;
			//Debug ( TreeName @ setTreeName @ ROOTNAME @ QuestName @ i ) ;

		}
		//if( ArrQuest[i].Level == 1 )
		else 
		{				
			QuestName = class'UIDATA_QUEST'.static.GetQuestName( ArrQuest[i].QuestID, ArrQuest[i].Level);			
			
			//Root ��� ����.
			
			util.TreeInsertRootNode( TreeName, ROOTNAME, "", 0, 4 );
			//+��ư �ִ� ���� ��� ����
			//���� �� Ȯ�� �� Ȥ�� Ȯ�� �� ���·� ����
			
			//Debug(TreeName @ string( ArrQuest[i].QuestID ) @  ROOTNAME);
			//Debug( "Ȯ��0" @ curTree.GetExpandedNode( "root" ) );
			util.TreeInsertExpandBtnNode( TreeName, string( ArrQuest[i].QuestID ), ROOTNAME );	/********/ //���⼭ Ȯ��ȴٱ� ����.. Ȯ�� �� ���� ����.					
			//Debug(TreeName @ string( ArrQuest[i].QuestID ) @  ROOTNAME);
			//Debug( "Ȯ��1" @ curTree.GetExpandedNode( "root" ) );
			//���� ��忡 �۾� ������ �߰�
			util.TreeInsertTextNodeItem( TreeName, ROOTNAME$"."$string( ArrQuest[i].QuestID ), QuestName, 5, 0, util.ETreeItemTextType.COLOR_DEFAULT, true );			
			//setTreeQuestList( ArrQuest[i].QuestID, ArrQuest[i].Level, ArrQuest[i].QuestType );
			data1.nReserved1 = ArrQuest[i].QuestID;
			data2.nReserved2 = ArrQuest[i].Level;
			data1.nReserved3 = ArrQuest[i].QuestType;
			data1.szData = QuestName;
			Record.LVDataList[0] = data1;
			Record.LVDataList[1] = data2;
			m_QuestTrackData[m_TrackID] = Record;
			m_TrackID = m_TrackID + 1;
		}		
	
		
		//����Ʈ ������ Node����
		strRetName = QuestJournalNodeMake( TREENAME, setTreeName, ArrQuest[i].Level, ArrQuest[i].Completed );		

		if( bDrawBgTree )
		{
			//Insert Node Item - ��� ���� ���
			util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 209, 24, 4,,,,14 );
		}
		else
		{
			util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 209, 24, 4 );
		}
		bDrawBgTree = !bDrawBgTree;		
		
		//Insert Node Item - ������ �̸�
		//util.TreeInsertTextNodeItem( TREENAME, strRetName, JournalName, -202, 7, util.ETreeItemTextType.COLOR_GRAY, true );				
		//(�Ϸ�) ǥ��
		//branch 110720_0804
		if( ArrQuest[i].Completed == 1 )
		{
			util.TreeInsertTextNodeItem( TREENAME, strRetName, "("$GetSystemString(898)$")", -202, 7, util.ETreeItemTextType.COLOR_GOLD, true );		
			util.TreeInsertTextNodeItem( TREENAME, strRetName, JournalName, 4, 7, util.ETreeItemTextType.COLOR_GRAY, true );				
		}
		else
		{
			util.TreeInsertTextNodeItem( TREENAME, strRetName, JournalName, -202, 7, util.ETreeItemTextType.COLOR_GRAY, true );				
		}
		//end of branch
			
	}
}

function setMiniMapTrackInsert( int QuestID, int Level, int nQuestType )
{

}

/**
 * ���� ���� ������ node ����
 */
function string QuestJournalNodeMake( string TreeName, string ParentName, int Level, int Completed )
{
	//Ʈ�� ����� ���� ��ü�� ����
	local XMLTreeNodeInfo		infNode;					

	infNode.strName = "" $ Level $ "." $ Completed;
	infNode.nOffSetX = 14;
	infNode.bShowButton = 0;
	infNode.bDrawBackground = 1;

	infNode.bTexBackHighlight = 0;
	infNode.nTexBackHighlightHeight = 15;
	infNode.nTexBackWidth = 211; 
	infNode.nTexBackUWidth = 211;
	infNode.nTexBackOffSetX = 3;
	infNode.nTexBackOffSetY = 0;
	infNode.nTexBackOffSetBottom = 1;

	return class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}

function vector getCurrentQuestDirectTargetPos()
{
	return currentQuestDirectTargetPos;
}

function string getCurrentQuestDirectTargetString()
{
	return currentQuestDirectTargetString;
}

//function int GetContinent(vector loc)
//{
//	if (loc.X < -163840)
//	{
//		return 1;		//Gracia
//	}
//	else
//	{
//		return 0;		//Aden
//	}
//}


function UpdateTargetNoneCheckPosBox(bool showArrow){
	local array<string>		arrSplit;
	local int				SplitCount;
	
	local int QuestID;
	local int Level;
	local int Completed;
	
	local string strChildList;
	local string strTargetNode;
	
	local string strNodeName;
	local string strTargetName;
	local vector vTargetPos;
	local bool bOnlyMinimap;

	local string strParam;

	strNodeName = GetExpandedNode();	

	if ( Len(strNodeName) < 1 )
	{
		SetQuestOff();
		return;
	}

	///////////////////////////////////////////////////////////////////////
	//Expanded�� ��尡 ����Ű�� ����Ʈ�� Targetǥ�ÿ� ������ ã�ƾ���
	///////////////////////////////////////////////////////////////////////
	
	// 1. Child��带 ���Ѵ�.
	strChildList = CurTree.GetChildNode(strNodeName);
	
	// 2. Child�� ������, Child�߿��� ���� ������ Child�� Targetǥ�ÿ� ����
	if (Len(strChildList)>0)
	{
		SplitCount = Split(strChildList, "|", arrSplit);
		strTargetNode = arrSplit[SplitCount-1];
	}
	else
	{
		SetQuestOff();
		return;
	}
	// 3. �̸��� �м��ؼ�, QuestID�� Level�� ���
	arrSplit.Remove(0,arrSplit.Length);
	SplitCount = Split( strTargetNode, ".", arrSplit );
	QuestID = int( arrSplit[1] );

	if( SplitCount == 2 )
	{
		Level = 1;
		Completed = 0;
	}
	else if( SplitCount == 4 )
	{
		Level = int( arrSplit[2] );
		Completed = int( arrSplit[3] );
	}

	if ( QuestID > 0 && Level > 0 )
	{
		//Target�̸� ���
		strTargetName = class'UIDATA_QUEST'.static.GetTargetName(QuestID, Level);
		vTargetPos = class'UIDATA_QUEST'.static.GetTargetLoc(QuestID, Level);

		ParamAdd(strParam, "X", string ( vTargetPos.x ));
		ParamAdd(strParam, "Y", string ( vTargetPos.y ));
		ParamAdd(strParam, "Z", string ( vTargetPos.z ));
		ParamAdd(strParam, "targetName", strTargetName);

		ParamAdd(strParam, "QuestID",  string (QuestID));
		ParamAdd(strParam, "QuestLevel",  string (Level));

		ParamAdd(strParam, "questName", class'UIDATA_QUEST'.static.GetQuestName( QuestID, Level ));
		CallGFxFunction("RadarMapWnd", "showQuestTargetInfo" , strParam ) ;
		CallGFxFunction("MiniMapGfxWnd","showQuestTargetInfo",strParam);

		if (Completed==0 && Len(strTargetName)>0)
		{
			bOnlyMinimap = class'UIDATA_QUEST'.static.IsMinimapOnly(QuestID, Level);

			if(bOnlyMinimap)
			{
				// End:0x2F6
				if(! IsPlayerOnWorldRaidServer())
				{
					class'QuestAPI'.static.SetQuestTargetInfo(true, false, false, strTargetName, vTargetPos, questID, Level);
				}
			}
			else
			{
				// End:0x32F
				if(! IsPlayerOnWorldRaidServer())
				{
					class'QuestAPI'.static.SetQuestTargetInfo(true, true, ShowArrow, strTargetName, vTargetPos, questID, Level);
				}
			}
			
			//Debug("DirIconDest"@vTargetPos @ DirIconDestGetToolTip( QuestID, Level) );

			//DirIconDest(EMinimapTargetIcon.TARGET_QUEST , vTargetPos, DirIconDestGetToolTip( QuestID, Level)  );
			
		}
		else
		{
			//m_MiniMap.DisableDirIcon( EMinimapTargetIcon.TARGET_QUEST );
			SetQuestOff();
		}
	}	
}

//����Ʈ ������ ǥ�� ����
function UpdateTargetInfo()
{

	//��ġǥ�� üũ�ڽ�
	if ( !chkNpcPosBox.IsChecked() )
	{
		 SetQuestOff();
		 return;
	}

	UpdateTargetNoneCheckPosBox(true);
}

/*20110419 ldw gd1.0 ���� ���� �� ���� ��ġǥ�ÿ� ���õ� ������ ���� �Լ� : 
*1 .��ġǥ�ÿ� ��� ���� ����Ʈ ��ġ ǥ��
*2. ����Ʈ���� 3D ȭ��ǥ�� ���� ���� ��� ȭ��ǥ �� ���� ǥ�� -> �� �κ��� ���� ����
*/
/*
function UpdateTargetInfoNoneChkNPCPosBox()
{
	local array<string>		arrSplit;
	local int				SplitCount;
	
	local int QuestID;
	local int Level;
	local int Completed;
	
	local string strChildList;
	local string strTargetNode;
	
	local string strNodeName;
	local string strTargetName;
	local vector vTargetPos;
	local bool bOnlyMinimap;
	
	strNodeName = GetExpandedNode();

	if (Len(strNodeName)<1)
	{
		SetQuestOff();
		return;
	}

	///////////////////////////////////////////////////////////////////////
	//Expanded�� ��尡 ����Ű�� ����Ʈ�� Targetǥ�ÿ� ������ ã�ƾ���
	///////////////////////////////////////////////////////////////////////
	
	// 1. Child��带 ���Ѵ�.
	strChildList = CurTree.GetChildNode(strNodeName);
	
	// 2. Child�� ������, Child�߿��� ���� ������ Child�� Targetǥ�ÿ� ����
	if (Len(strChildList)>0)
	{
		SplitCount = Split(strChildList, "|", arrSplit);
		strTargetNode = arrSplit[SplitCount-1];
	}
	else
	{
		SetQuestOff();
		return;
	}
	// 3. �̸��� �м��ؼ�, QuestID�� Level�� ���
	arrSplit.Remove(0,arrSplit.Length);
	SplitCount = Split( strTargetNode, ".", arrSplit );
	QuestID = int( arrSplit[1] );

	if( SplitCount == 2 )
	{
		Level = 1;
		Completed = 0;
	}
	else if( SplitCount == 4 )
	{
		Level = int( arrSplit[2] );
		Completed = int( arrSplit[3] );
	}

	if ( QuestID > 0 && Level > 0 )
	{
		//Target�̸� ���
		strTargetName = class'UIDATA_QUEST'.static.GetTargetName(QuestID, Level);
		vTargetPos = class'UIDATA_QUEST'.static.GetTargetLoc(QuestID, Level);
		
		if (Completed==0 && Len(strTargetName)>0)
		{
			bOnlyMinimap = class'UIDATA_QUEST'.static.IsMinimapOnly(QuestID, Level);
			if (bOnlyMinimap)
				class'QuestAPI'.static.SetQuestTargetInfo( true, false, false, strTargetName, vTargetPos, QuestID, Level);
			else				
				class'QuestAPI'.static.SetQuestTargetInfo( true, true, true, strTargetName, vTargetPos, QuestID, Level);//m_IsShowArrow, strTargetName, vTargetPos, QuestID);
		}
		else
		{
			SetQuestOff();
		}
	}	
}
*/

function SetQuestOff()
{
	local vector vVector, emptyLoc;

	// End:0x26
	if(! IsPlayerOnWorldRaidServer())
	{
		class'QuestAPI'.static.SetQuestTargetInfo(false, false, false, "", vVector, 0, 0);
	}

	CallGFxFunction("RadarMapWnd", "hideQuestTargetInfo" , "" ) ;

//	Debug ( "SetQuestOff");

	CallGFxFunction("MiniMapGfxWnd","hideQuestTargetInfo","");

//	m_IsShowArrow = false;
		
	QuestID_Alarm = -1;
	QuestLevel_Alarm = -1;
	QuestEnd_Alarm = -1;
	m_recentlyQuestID = 0;

	currentQuestDirectTargetPos = emptyLoc;
	currentQuestDirectTargetString = "";
}


function string GetExpandedNode()
{
	local array<string>	arrSplit;
	local int		SplitCount;
	local string	strNodeName;	

	strNodeName = CurTree.GetExpandedNode("root");
	//Debug ("GetExpandedNode" @  strNodeName) ;
	SplitCount = Split(strNodeName, "|", arrSplit);
	if (SplitCount>0)
	{
		strNodeName = arrSplit[0];
	}	
	return strNodeName;
}

//expanded �� ��带 �������� ��ư�� Ȱ��ȭ �� �� ������ ó���Ѵ�. 
function ButtonEnableCheck()
{	
	local int   i, m;	
	local int   QuestIDSlot;
	local bool  isCanBeAddAlarm;

	QuestAutoAlarm = GetOptionBool("Game", "autoQuestAlarm");

	GetNodeInfo_Alarm();	
	// ����Ʈ�� �˸��̸� ǥ���� �� �ִ��� �˻��Ѵ�.
	
	isCanBeAddAlarm = false;	

	// �˸��� �ʿ����� ������ Ȯ��.
	// ���� �ִ�..npc goal Ÿ�� üũ �ϴ� ��..
	for ( i = 0 ; i < ArrQuest.Length ; i++ )
	{
		if( ArrQuest[ i ].QuestID == QuestID_Alarm )
		{
			//ArrQuest[ i ].ArrGoalType[]
			if( ArrQuest[ i ].arrNeedItemIDList.Length > 0 )
			{
				isCanBeAddAlarm = true;
				break;
			}

			// goal Ÿ�� üũ
			for ( m = 0; m < ArrQuest[i].ArrGoalType.Length; m++ )
			{
				if(ArrQuest[i].ArrGoalType[m] == 1)
				{
					isCanBeAddAlarm = true;
					break;
				}
			}
		}
	}
	
	QuestIDSlot = scQuestAlarm.QuestSlotIdx( QuestID_Alarm );

	if( QuestID_Alarm <= 0 )
	{	
		m_btnAddAlarm.DisableWindow();
		m_btnDeleteAlarm.DisableWindow();
	}
	else
	{
		// ��ϵ��� ���� ����Ʈ�� ������ ǥ�� ������ ���  : ��� ��ư enable, ��� ���� ��ư disable
		if( QuestIDSlot < 0 )
		{			
			if(isCanBeAddAlarm == true)	
			{	
				m_btnAddAlarm.EnableWindow();	
				m_btnDeleteAlarm.DisableWindow();
			}
			else					
			{	
				m_btnAddAlarm.DisableWindow();	
				m_btnDeleteAlarm.DisableWindow();
			}			
		}
		else	// �̹� ��ϵ� ����Ʈ�� �˻�. ��Ϲ�ư disable, ��� ���� ��ư enable
		{
			m_btnAddAlarm.DisableWindow();
			m_btnDeleteAlarm.EnableWindow();
		}
	}
}

// EXPand ��忡�� QuestID, QuestLevel, �Ϸ� ���θ� ���������� �����Ѵ�.
function GetNodeInfo_Alarm()
{	
	local string strNodeName;
	local string strTargetNode;
	
	local int		i;
	local array<string>	arrSplit;
	local int		SplitCount;
	
	local string strChildList;	
	

	strNodeName = GetExpandedNode();
	
	// 1. Child��带 ���Ѵ�.
	strChildList = CurTree.GetChildNode(strNodeName);
	
	// 2. Child�� ������, Child�߿��� ���� ������ Child�� Targetǥ�ÿ� ����
	if (Len(strChildList)>0)
	{
		SplitCount = Split(strChildList, "|", arrSplit);
		strTargetNode = arrSplit[SplitCount-1];
	}
	else
	{
		SetQuestOff();
		return;
	}
	// 3. �̸��� �м��ؼ�, QuestID�� Level�� ���
	arrSplit.Remove( 0 , arrSplit.Length );
	SplitCount = Split(strTargetNode, ".", arrSplit);

	for (i=0; i < SplitCount; i++)
	{
		switch(i)
		{
			//"root"
			case 0:
				break;
			//"QuestID"
			case 1:
				QuestID_Alarm = int(arrSplit[i]);
				break;
			//"QuestLevel"
			case 2:
				QuestLevel_Alarm = int(arrSplit[i]);
				break;
			//"IsCompleted"
			case 2:
				QuestEnd_Alarm = int(arrSplit[i]);
				break;
		}
	}	
}


// ����Ʈ �˸��̿��� ����
function HandleDeleteAlarm()
{
	local int		i;
		
	GetNodeInfo_Alarm();
	
	// ����Ʈ ���̵�� ����� ����Ʈ �������� ����Ѵ�. 
	//�˸��� �ʿ����� ������ Ȯ��.
	for ( i = 0 ; i < ArrQuest.Length ; i++ )
	{
		if( ArrQuest[ i ].QuestID == QuestID_Alarm )
		{
			scQuestAlarm.DeleteQuestAlarm( QuestID_Alarm );
		}
	}	
	ButtonEnableCheck();
}

//���� ����Ʈ ���� ����
function UpdateQuestCount()
{
	txtQuestNum.SetText("(" $ m_QuestNum $ "/" $ QUESTTREEWND_MAX_COUNT $ ")");
}

//�˸� �����ܿ��� ������ ���.
function HandleQuestSetCurrentID(string param)
{
	local string strNodeName;
	local string strChildList;
	local int RecentlyAddedQuestID;
	local int SplitCount;
	local int nQuestType;
	local array<string>	arrSplit;
	
	if (!ParseInt(param, "QuestID", RecentlyAddedQuestID))
		return;

	if (RecentlyAddedQuestID>0)
	{	
		nQuestType = Class'UIDATA_QUEST'.static.GetQuestIscategory(RecentlyAddedQuestID, 1);
		setCurrentTree(nQuestType);
		/*
		switch(	nQuestType )
		{
			case 0 : CurTree = MainTree0; break;
			case 1 : CurTree = MainTree1; break;
			case 2 : CurTree = MainTree2; break;
			case 3 : CurTree = MainTree3; break;
			case 4 : CurTree = MainTree4; break;
			default : CurTree = MainTree0;
		}*/
		QuestTreeTab.SetTopOrder(getTreeNum(nQuestType),false);//on show ���� ó�� �ϱ� ������ ���� ���� �κ��� �ڷ� �Űܾ� ��.

		// 1. QuestNode Expand
		strNodeName = "root." $ RecentlyAddedQuestID;
		// debug("strNodeName::" @ strNodeName);
		CurTree.SetExpandedNode(strNodeName, true);

		if(!Me.isShowWindow())	//����Ʈ ��ư�� ������ â�� �������� �Ѵ�.  (���� â�� �ȶ����� ���)
		{
			Me.ShowWindow();			
			PlayConsoleSound(IFST_WINDOW_OPEN);	// ���嵵 �߰�
		} 
			
		// 2. JournalNode Expand
		strChildList = CurTree.GetChildNode(strNodeName);		
		// debug("��� �� : " @ Len(strChildList));

		// Child�߿��� ���� ������ Child�� Expand�� ����
		if (Len(strChildList)>0)
		{
			SplitCount = Split(strChildList, "|", arrSplit);
			CurTree.SetExpandedNode(arrSplit[SplitCount-1], true);
		}

		// 2009 9.21 �߰� , ����Ʈ �˶� ��ư�� Ŭ���ϸ� �ڵ����� ����Ʈ ���� �������� ����
		if (Left(strNodeName, 4) == "root")
		{				
			scTreeDrawer.showQuestDrawer( arrSplit[SplitCount-1] );
			//setMiniMapDrawerQuest(); //�̴ϸ��� ����Ʈ���� üũ
		}
		
		//Target���� ����
		UpdateTargetInfo();

		// 2018.01.29 �߰�
		RequestAddExpandQuestAlarm( RecentlyAddedQuestID ); //������Ʈ �Ͽ��� 


		selectQuestTree(strNodeName, false);

		if (QuestAutoAlarm == false)
			scTreeDrawer.OnbtnAddAlarmClick();
	}
}

//�̴ϸ� ���� �������� ����Ʈ Ŭ�� �� ���.
function HandleQuestSetCurrentIDfromMiniMap(int QuestID, int Level, int nQuestType)
{
	local string strNodeName;
	local string strChildList;
	local int RecentlyAddedQuestID;
	local int SplitCount;
	local array<string>	arrSplit;
	//local  TreeHandle tempCurTree; //�� ��� �߾�����?

	//tempCurTree = CurTree; //���

	RecentlyAddedQuestID = QuestID;

	//Debug ("CurTree" @ CurTree);

	setCurrentTree(nQuestType);
	/*
	switch (nQuestType)
	{
		case 0:
			CurTree = MainTree0;
			break;
		case 1:
			CurTree = MainTree1;
			break;
		case 2:
			CurTree = MainTree2;
			break;
		case 3:
			CurTree = MainTree3;
			break;
		case 4:
			CurTree = MainTree4;
			break;
	}*/
	QuestTreeTab.SetTopOrder(getTreeNum(nQuestType),false);
	//Debug ("RecentlyAddedQuestID" @ RecentlyAddedQuestID @ "nQuestType" @ nQuestType);
	if (RecentlyAddedQuestID>0)
	{
		// 1. QuestNode Expand
		strNodeName = "root." $ RecentlyAddedQuestID;
		//Debug("RecentlyAddedQuestID" @ RecentlyAddedQuestID);
		CurTree.SetExpandedNode(strNodeName, true);

		//Debug ("RecentlyAddedQuestID>0" @ strNodeName);
			
		
		// 2. JournalNode Expand
		strChildList = CurTree.GetChildNode(strNodeName);
		
		// Child�߿��� ���� ������ Child�� Expand�� ����
		if ( Len( strChildList ) >0 )
		{
			SplitCount = Split( strChildList, "|", arrSplit );
			CurTree.SetExpandedNode( arrSplit[SplitCount-1], true );
			//Debug ("Len( strChildList ) >0 " @ arrSplit[SplitCount-1]);
		}
		
		//Target���� ����
		//UpdateTargetInfo();	//20110419 LDW GD1.0���� ���� ��ġǥ�� �ڽ� chkNPC....�� üũ�� ���� ���� ó�� �ǵ��� ���� .  -> �ѹ�
		UpdateTargetNoneCheckPosBox( true );//20110516 LDW GD1.0

		if (Left(strNodeName, 4) == "root")
		{
		//	Debug(strNodeName @  arrSplit[SplitCount-1]);
			scTreeDrawer.showQuestDrawer( arrSplit[SplitCount-1] );
		}
	}
	//CurTree = tempCurTree; //restore �ڵ�		
//	Debug("GetExpandedNode ="@GetExpandedNode());
}

/**
 * �̴ϸ� ���� ������ �߰�.
 */
function CheckQuestTrackList() // ����Ʈ�� üũ ��Ŵ
{
	local int i;	
	local int QuestID;
	
	QuestID = getCurQuestID();
	for (i= 0; i <m_TrackID; i++)
	{	
		if (m_QuestTrackData[i].LVDataList[0].nReserved1 == QuestID ) 
		{			
			//ListTrackItem1.SetSelectedIndex(i, true);
			return;
		}
	}
}

function InsertQuestTrackList() //����Ʈ�� �μ�Ʈ�� ��
{
	local int i;	
	local int QuestID;
	
	QuestID = getCurQuestID();	
	//ListTrackItem1.DeleteAllItem();	
	for (i= 0; i <m_TrackID; i++)
	{
		//ListTrackItem1.InsertRecord( m_QuestTrackData[i] );
		if (m_QuestTrackData[i].LVDataList[0].nReserved1 == QuestID ) 
		{			
			//ListTrackItem1.SetSelectedIndex(i, true);
		}
	}
}

function int getCurQuestID()
{
	local int       QuestID;
	local string	strNodeName;
	local int       SplitCount;
	local array<string>	arrSplit;
	
	strNodeName = GetExpandedNode();

//	debug("strNodeName" @ strNodeName);

	SplitCount = Split(strNodeName, ".", arrSplit);
	if (SplitCount>1)
	{
		QuestID = int(arrSplit[1]);
	} else 		
		QuestID =  0 ;

	return QuestID ; 
}

//function setMiniMapDrawerQuest() //  ������ ���� �� ����Ʈ�� ������ ��ġǥ�ø� ����ȭ �ϴ� �Լ� 
//{
//	local int       QuestID;
//	local int       i;
//	//local LVDataRecord Record;

//	QuestID = getCurQuestID();	
//	for (i= 0; i <m_TrackID; i++)
//	{	
//		//ListTrackItem1.GetRec(i, Record);
//		if (m_QuestTrackData[i].LVDataList[0].nReserved1 == QuestID ) // Record.LVDataList[0].nReserved1 )
//		{
//			//Debug("QUDSTID" @ m_QuestTrackData[i].LVDataList[0].nReserved1@Record.LVDataList[0].nReserved1);
//			//ListTrackItem1.SetSelectedIndex(i, true);
//			return;
//		}
//	}
//}


//����Ʈ �ߴ�
function HandleQuestCancel()
{
	local array<string>	arrSplit;
	local int		SplitCount;
	
	local string	strNodeName;
	
	local string	strDeleteQuestName;	
	local string	strDeleteQuestMessage;	

	m_DeleteQuestID = 0;
	m_DeleteNodeName = "";
	
	//Expanded�� ��带 ���Ѵ�.
	strNodeName = GetExpandedNode();
	SplitCount = Split(strNodeName, "|", arrSplit);
	if (SplitCount>0)
	{
		strNodeName = arrSplit[0];
		
		arrSplit.Remove(0,arrSplit.Length);
		SplitCount = Split(strNodeName, ".", arrSplit);
		if (SplitCount>1)
		{
			m_DeleteQuestID = int(arrSplit[1]);
			m_DeleteNodeName = strNodeName;
		}
	}
	if (Len(m_DeleteNodeName)<1)
	{
		//Set Delete Quest Message
		strDeleteQuestMessage = GetSystemMessage(1201);
		
		DialogShow(DialogModalType_Modalless,DialogType_Notice, strDeleteQuestMessage, string(Self));
		DialogSetID(1);
	}
	else
	{
		/*
		strChildList = CurTree.GetChildNode(strNodeName);
		// Child�߿��� ���� ������ Child�� Expand�� ����
		if (Len(strChildList)>0)
		{
			SplitCount = Split(strChildList, "|", arrSplit);
			//strNodeName = arrSplit [SplitCount-1];
			//Debug ( "SetExpandedNode1" @ SplitCount @ arrSplit[ arrSplit.Length - 1]) ;
		}
		if (SplitCount > 0)
		{			
			SplitCount = Split( arrSplit[ arrSplit.Length - 1], ".", arrSplit2);			
			//Debug( "SetExpandedNode2" @ arrSplit[ arrSplit.Length - 1] @ SplitCount @ arrSplit2 [ 2 ] @ arrSplit2[ SplitCount -1 ] );
		}
		//Get Delete Quest Name		
		if( SplitCount == 2 )
		{
			Level = 1;			
		}
		else if( SplitCount == 4 )
		{
			Level = int( arrSplit2[2] );
		}

		*/
		//Debug ( "arrSplit[0]" @ SplitCount @"/"@ strNodeName @ "/"@ arrSplit[ 2 ] @ "/"@ m_DeleteQuestID @ "/"@ Level );
		strDeleteQuestName = class'UIDATA_QUEST'.static.GetQuestName(m_DeleteQuestID, util.getQuestLevelForID( m_DeleteQuestID ));
		
		//Set Delete Quest Message
		strDeleteQuestMessage = MakeFullSystemMsg( GetSystemMessage(182), strDeleteQuestName, "");
		
//		Debug( "strDeleteQuestMessage>>>>>>>>>>>" $ strDeleteQuestMessage );


		DialogShow(DialogModalType_Modalless,DialogType_Warning, strDeleteQuestMessage, string(Self) );
		DialogSetID(0);
	}
}





/*
//�ϴ� GMQuestWnd������ ����.
//����Ʈ ������ ���� ����(ClassID=0�̸� ��ü �������� ����)
function UpdateItemCount( int ClassID, optional INT64 a_ItemCount )
{

	local int i;
	local int nPos;
	local INT64 ItemCount;
	local string strTmp;
	
	for (i=0; i<m_arrItemID.Length; i++)
	{	
		if (ClassID==0 || ClassID==m_arrItemID[i])
		{
			ItemCount = a_ItemCount;
			if( a_ItemCount == -1 )
			{
				ItemCount = 0;
			}
			else if( a_ItemCount == 0 )
			{
				ItemCount = GetInventoryItemCount(GetItemID(m_arrItemID[i]));
			}
			nPos = InStr(m_arrItemString[i], "%s");
			if (nPos>-1)
			{
				strTmp = Left(m_arrItemString[i], nPos) $ string(ItemCount) $ Mid(m_arrItemString[i], nPos+2);
				CurTree.SetNodeItemText(m_arrItemNodeName[i], m_arrItemID.Length-i, strTmp);
					
				if(ItemCount < 0)	ItemCount = ItemCount * -1;	// ������ ��� - ~�̻��̹Ƿ� ����� �ٲ��ش�.				
				m_scriptAlarm.UpdateAlarmItem(m_arrItemID[i], ItemCount);	//������ ������Ʈ ���ֱ�
			}
		}
	}	
}*/


//�̴ϸ� ���� �������� ����Ʈ Ŭ�� �� ���.
function string LastNodeName(int QuestID, int Level, int nQuestType)
{
	local string strNodeName;
	local string strChildList;
	local int RecentlyAddedQuestID;
	local int SplitCount;
	local array<string>	arrSplit;
	local  TreeHandle tempCurTree;
	tempCurTree = CurTree; //���

	RecentlyAddedQuestID = QuestID;

	setCurrentTree(nQuestType);
	/*switch (nQuestType)
	{
		case 0:
			CurTree = MainTree0;
			break;
		case 1:
			CurTree = MainTree1;
			break;
		case 2:
			CurTree = MainTree2;
			break;
		case 3:
			CurTree = MainTree3;
			break;
		case 4:
			CurTree = MainTree4;
			break;
	}*/

	QuestTreeTab.SetTopOrder(getTreeNum(nQuestType),false);

	if (RecentlyAddedQuestID>0)
	{
		// 1. QuestNode Expand
		strNodeName = "root." $ RecentlyAddedQuestID;
		//CurTree.SetExpandedNode(strNodeName, true);
			
		
		// 2. JournalNode Expand
		strChildList = CurTree.GetChildNode(strNodeName);
		
		// Child�߿��� ���� ������ Child�� Expand�� ����
		if (Len(strChildList)>0)
		{
			SplitCount = Split(strChildList, "|", arrSplit);
			CurTree.SetExpandedNode( arrSplit[SplitCount-1], true );
			//Debug( "SetExpandedNode" @ arrSplit[SplitCount-1] );
		}
	}
	CurTree = tempCurTree; //restore �ڵ�

	return arrSplit[SplitCount-1];
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

// NEW 245
function setCurrentTree (int nQuestType)
{
	switch (nQuestType)
	{
		case 3:
			CurTree = MainTree0;
			break;
		default:
			CurTree = MainTree1;
			break;
	}
}

function int getTreeNum (int nQuestType)
{
	local int treeNum;

	switch (nQuestType)
	{
		case 3:
			treeNum = 0;
			break;
		default:
			treeNum = 1;
			break;
	}
	return treeNum;
}

defaultproperties
{
     ROOTNAME="root"
     m_WindowName="QuestTreeWnd"
}
