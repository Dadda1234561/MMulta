class QuestTreeDrawerWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle GroupBox_Title;
var TextureHandle GroupBox_DescriptionTree;
var TextureHandle GroupBox_DescriptionTreeLarge;
var TextureHandle GroupBox_ItemTree;
var TextureHandle GroupBox_RewardItemTree;
var TextBoxHandle txtQuestTitle;
var TextBoxHandle txtRecommandedLevel;
var TextBoxHandle txtRecommandedLevelText;
var TextBoxHandle txtQuestType;
var TreeHandle QuestDescriptionTree;
var TreeHandle QuestDescriptionLargeTree;
var TextBoxHandle txtQuestItemTitle;
var TextBoxHandle txtQuestRewardItemTreeTitle;
var TreeHandle QuestItemTree;
var TreeHandle QuestRewardItemTree;
var ButtonHandle btnGiveUpCurrentQuest;
var ButtonHandle btnAddAlarm;
var ButtonHandle btnClose;
var ButtonHandle btnDeleteAlarm;

//Utill ����
var L2Util util;

//���õ� ����Ʈ QuestID
var int SelectQuestID;
//���õ� ����Ʈ ����
var int SelectLevel;
//���õ� ����Ʈ �Ϸ�
var int SelectCompleted;
//
var array<int> SelectarrItemID;

var array<int> SelectarrItemNumList;

var array<int> SelectarrGoalType;

var QuestAlarmWnd m_scriptAlarm;

var QuestTreeWnd scQuestTree;
	
function OnRegisterEvent()
{
}

function OnLoad()
{
	Initialize();
	Load();
	
	util = L2Util(GetScript("L2Util"));	

	m_scriptAlarm = QuestAlarmWnd( GetScript( "QuestAlarmWnd" ));
	scQuestTree = QuestTreeWnd( GetScript( "QuestTreeWnd" ) );

	btnAddAlarm.DisableWindow();
	btnDeleteAlarm.DisableWindow();
}

function Initialize()
{
	Me = GetWindowHandle( "QuestTreeDrawerWnd" );
	GroupBox_Title = GetTextureHandle( "QuestTreeDrawerWnd.GroupBox_Title" );
	GroupBox_DescriptionTree = GetTextureHandle( "QuestTreeDrawerWnd.GroupBox_DescriptionTree" );
	GroupBox_DescriptionTreeLarge = GetTextureHandle( "QuestTreeDrawerWnd.GroupBox_DescriptionTreeLarge" );
	GroupBox_ItemTree = GetTextureHandle( "QuestTreeDrawerWnd.GroupBox_ItemTree" );
	GroupBox_RewardItemTree = GetTextureHandle( "QuestTreeDrawerWnd.GroupBox_RewardItemTree" );
	txtQuestTitle = GetTextBoxHandle( "QuestTreeDrawerWnd.txtQuestTitle" );
	txtRecommandedLevel = GetTextBoxHandle( "QuestTreeDrawerWnd.txtRecommandedLevel" );
	txtRecommandedLevelText = GetTextBoxHandle( "QuestTreeDrawerWnd.txtRecommandedLevelText" );
	txtQuestType = GetTextBoxHandle( "QuestTreeDrawerWnd.txtQuestType" );
	QuestDescriptionTree = GetTreeHandle( "QuestTreeDrawerWnd.QuestDescriptionTree" );
	QuestDescriptionLargeTree = GetTreeHandle( "QuestTreeDrawerWnd.QuestDescriptionLargeTree" );
	txtQuestItemTitle = GetTextBoxHandle( "QuestTreeDrawerWnd.txtQuestItemTitle" );
	txtQuestRewardItemTreeTitle = GetTextBoxHandle( "QuestTreeDrawerWnd.txtQuestRewardItemTreeTitle" );
	QuestItemTree = GetTreeHandle( "QuestTreeDrawerWnd.QuestItemTree" );
	QuestRewardItemTree = GetTreeHandle( "QuestTreeDrawerWnd.QuestRewardItemTree" );
	btnGiveUpCurrentQuest = GetButtonHandle( "QuestTreeDrawerWnd.btnGiveUpCurrentQuest" );
	btnAddAlarm = GetButtonHandle( "QuestTreeDrawerWnd.btnAddAlarm" );
	btnClose = GetButtonHandle( "QuestTreeDrawerWnd.btnClose" );
	btnDeleteAlarm = GetButtonHandle( "QuestTreeDrawerWnd.btnDeleteAlarm" );
}

function Load()
{
}

function OnEvent( int EventID, String param )
{
}

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "btnGiveUpCurrentQuest":
			OnbtnGiveUpCurrentQuestClick();
			break;
		case "btnAddAlarm":
			OnbtnAddAlarmClick();
			break;
		case "btnClose":
			OnbtnCloseClick();
			break;
		case "btnDeleteAlarm":
			OnbtnDeleteAlarmClick();
			break;
	}
}

function OnbtnGiveUpCurrentQuestClick()
{
	local QuestTreeWnd Script;
	Script = QuestTreeWnd(GetScript("QuestTreeWnd"));
	
	Script.HandleQuestCancel();
	//class'QuestAPI'.static.RequestDestroyQuest( SelectQuestID );
}

function OnbtnAddAlarmClick()
{
	local int i, count;
	local string alarmTitleStr;

	// ����Ʈ ���̵�� ����� ����Ʈ �������� ����Ѵ�.		
	//Debug("SelectarrItemID.Length" @ SelectarrItemID.Length);

	if (SelectarrItemID.Length > 0)
	{
		//Debug("Call --> RequestAddExpandQuestAlarm : " $ string(SelectQuestID) );
		RequestAddExpandQuestAlarm( SelectQuestID );
	}

	for ( i = 0 ; i < SelectarrItemID.Length ; i++ )
	{	
		alarmTitleStr = "";

		// npcString�� ����, Ư�� ���� ������ ���� ���� �ϴ� ����
		if(SelectarrGoalType[i] == 1) 
		{
			alarmTitleStr = GetNpcString(SelectarrItemID[i]);
			//count = SelectarrItemNumList[i];
			// Debug("��ȭ��? alarmTitleStr" @ alarmTitleStr);
		}
		// óġ��
		else if( SelectarrItemID[i] >= 1000000 )
		{
			alarmTitleStr = class'UIDATA_NPC'.static.GetNPCName( SelectarrItemID[i] - 1000000) $ " " $ GetSystemString(2240) ;	
			// óġ���� ��� óġ ī��Ʈ�� �̺�Ʈ�� �޴´�.
			count = 0;//SelectarrItemNumList[i];
			// Debug("óġ�� alarmTitleStr" @ alarmTitleStr);
		}
		// ���� ����..
		else
		{
			alarmTitleStr = class'UIDATA_ITEM'.static.GetItemName( GetItemID( SelectarrItemID[i] ));
			count = int(GetInventoryItemCount( GetItemID( SelectarrItemID[i])));
			// Debug("���� �Ϲ��� alarmTitleStr" @ alarmTitleStr);
			//m_scriptAlarm.AddQuestAlarm( SelectQuestID, SelectLevel, SelectarrItemID[i], SelectarrItemNumList[i] );
			//������ Quest�� ������ ������ ��û�Ѵ�.
		}
		
		m_scriptAlarm.AddQuestAlarmNew( 
			SelectQuestID,
			class'UIDATA_QUEST'.static.GetQuestName( SelectQuestID, SelectLevel ),
			SelectarrItemID[i],
			alarmTitleStr,
			count,
			SelectarrItemNumList[i],
			SelectLevel);

			//Debug("Call --> m_scriptAlarm.AddQuestAlarmNew : " $ string(SelectQuestID) );
			//Debug("SelectQuestID: " $ string(SelectQuestID) );
			//Debug("getItemNAme: " $ class'UIDATA_ITEM'.static.GetItemName( GetItemID( SelectarrItemID[i] )));
			//Debug("GetInventoryItemCount( GetItemID( SelectarrItemID[i] ) ): " $ string(GetInventoryItemCount( GetItemID( SelectarrItemID[i] ) )) );
			//Debug("SelectarrItemNumList[i]: " $ string(SelectarrItemNumList[i]) );
			//Debug("SelectLevel: " $ SelectLevel );
	}

	scQuestTree.ButtonEnableCheck();
}

function OnbtnCloseClick()
{
	Me.HideWindow();
}

function OnbtnDeleteAlarmClick()
{
	scQuestTree.HandleDeleteAlarm();
}

function showQuestDrawer( string str )
{
	local int i;
	local int SplitCount;
	local array<string>	arrSplit;

	//����Ʈ ���̵�
	local int QuestID;
	//����Ʈ ����
	local int Level;
	//����Ʈ �Ϸ�
	local int Completed;
	//����Ʈ Ÿ��
	local int QuestType;
	//����Ʈ ���� Ÿ�� ���� �� ���� �뵵
	local int Type;

	//��õ ���� ����, �ְ�
	local int MinLevel, MaxLevle;

	//����Ʈ ����
	local string QuestDescription;

	//����Ʈ ������ param
	local string QuestParam;
	//����Ʈ ������ ����
	local int Max;

	//����Ʈ �ʿ� ������ ID
	local array<int>		arrItemIDList;
	//����Ʈ �ʿ� ������ ����
	local array<int>		arrItemNumList;
	//?? ���� �Ӹ�..;;
	local bool			bShowCompletionItem;

	//���� ������ ID
	local Array<int> rewardIDList;	
	//���� ������ ����
	local Array<INT64> rewardNumList;
	
	//����Ʈ �� ����
	local string JournalName;	

	//���� 
	local bool bQuest;

	//��Ʈ�� Ÿ������ üũ
	local array<int> arrGoalType;

	bQuest = false;


	if( !Me.IsShowWindow() )
		Me.ShowWindow();

	btnGiveUpCurrentQuest.EnableWindow();

	SplitCount = Split( str, ".", arrSplit );
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

	MinLevel = class'UIDATA_QUEST'.static.GetMinLevel( QuestID, Level );
	MaxLevle = class'UIDATA_QUEST'.static.GetMaxLevel( QuestID, Level );

	QuestDescription = class'UIDATA_QUEST'.static.GetQuestDescription( QuestID, Level );

	//����Ʈ ������
	JournalName = class'UIDATA_QUEST'.static.GetQuestJournalName( QuestID, Level );
	//branch 110720_0804
	JournalName = class'UIDATA_QUEST'.static.GetQuestJournalNameLine( JournalName );
	//end of branch
	txtQuestTitle.SetText( JournalName );

	//��õ����
	txtRecommandedLevel.SetTextColor( util.White );
	txtRecommandedLevel.SetText( GetSystemString(922) @ ":");

	//���� ǥ��( 1~23, 11�̻�, ���� ���� )
	txtRecommandedLevelText.SetTextColor( util.Token1 );
	if ( MaxLevle > 0 && MinLevel > 0)
		txtRecommandedLevelText.SetText( MinLevel $ "~" $ MaxLevle );
	else if ( MinLevel > 0 )
		txtRecommandedLevelText.SetText( MinLevel $ " " $ GetSystemString(859) );
	else
		txtRecommandedLevelText.SetText( GetSystemString(866) );

	//����Ʈ Ÿ��( ���� ����Ʈ, ��ȸ�� ����Ʈ �� )
	QuestType = Class'UIDATA_QUEST'.static.GetQuestIscategory( QuestID, Level );

	//����Ʈ Ÿ�� (�ַ�, ��Ƽ, ����, �ݺ� ����)
	
	txtQuestType.SetTextColor( util.White );
	switch (QuestType)
	{
		case 0:
			txtQuestType.SetText(GetSystemString(862));
			break;
		case 1:
			Type = class'UIDATA_QUEST'.static.GetQuestType(QuestID, Level);
			if ( Type == 4 || Type == 5 )
				txtQuestType.SetText(GetSystemString( 2788 )); //���� ����Ʈ 
			else 
				txtQuestType.SetText(GetSystemString(861));				
			break;
		case 2:
			txtQuestType.SetText(GetSystemString(1998));
			break;
		case 3:
			txtQuestType.SetText(GetSystemString(1999));
			break;
		case 4:
			txtQuestType.SetText(GetSystemString(2000));
			break;
	}


	QuestParam = class'UIDATA_QUEST'.static.GetQuestItem( QuestID, Level );

	ParseInt( QuestParam, "Max", Max );	
	arrItemIDList.Length = Max;	
	arrItemNumList.Length = Max;
	arrGoalType.Length = Max;

	for ( i = 0; i < Max; i++ )
	{
		//����Ʈ �ʿ� ������ ID
		ParseInt( QuestParam, "GoalID_" $ i, arrItemIDList[i] );
		//����Ʈ �ʿ� ������ ����
		ParseInt( QuestParam, "GoalNum_" $ i, arrItemNumList[i] );
		//����Ʈ ��Ʈ�� Ÿ�� ����
		ParseInt( QuestParam, "GoalType_" $ i, arrGoalType[i]) ;

		if( arrItemIDList[i] < 1000000 && arrGoalType[i] != 1)
		{
			bQuest = true;// true; //������ ��
		}
	}

	rewardIDList.Remove(0, rewardIDList.Length);
	rewardNumList.Remove(0, rewardNumList.Length);

	class'UIDATA_QUEST'.static.GetQuestReward( QuestID, Level, rewardIDList, rewardNumList);

	//��ų ����	
	util.TreeClear( "QuestTreeDrawerWnd.QuestDescriptionTree" );
	util.TreeClear( "QuestTreeDrawerWnd.QuestDescriptionLargeTree" );
	//Root ��� ����.
	util.TreeInsertRootNode( "QuestTreeDrawerWnd.QuestDescriptionTree", "root", "" );
	util.TreeInsertRootNode( "QuestTreeDrawerWnd.QuestDescriptionLargeTree", "root", "" );
	
	if( Max != 0 )
	{
		//�𸣰��� ���� �ڵ��� �̷��� �Ǿ� ����.
			// 2009.11 ����Ʈ ��Ʈ���� ��û 
			// 100�� ���� �� ����Ʈ �����ۿ� ��� ���� �ʴ´�.
			// (��: �ͼ� óġ ����Ʈ���� ���͸� ��� ��ƶ�! ��� �Ѵٸ� , Item_id �� 100�� 10 �̶� �Ѵٸ� Ư�� ���͸� 10���� ��ƶ�
			// �̷������� ����Ʈ ��Ʈ���� ó���� �Ǿ� �ִ�. �׷��� ��� ���� �ڵ��̴�.)
			// [ �����ϸ� ���� �Ӽ����� �̷� ���� ó�� ������ ���� ���̴�. ]
		//Ȯ�� ���� ����.
		/*
		 * ���� ��..;;;
		 */

		if( !bQuest )
		{
			setQuestItemShow( false ); //�л���
			//Insert Node Item - ������ �̸�
			util.TreeInsertTextNodeItem( "QuestTreeDrawerWnd.QuestDescriptionLargeTree", "root", QuestDescription );
		}
		else
		{
			setQuestItemShow( true );
			//Insert Node Item - ������ �̸�
			util.TreeInsertTextNodeItem( "QuestTreeDrawerWnd.QuestDescriptionTree", "root", QuestDescription );
		}
	}
	else
	{
		setQuestItemShow( false );
		//Insert Node Item - ������ �̸�
		util.TreeInsertTextNodeItem( "QuestTreeDrawerWnd.QuestDescriptionLargeTree", "root", QuestDescription );
	}


	if( Max > 0 )
	{
		if( bQuest )
		{
			bShowCompletionItem = class'UIDATA_QUEST'.static.IsShowableItemNumQuest( QuestID, Level );
			setQuestItem( Completed, Max, arrItemIDList, arrItemNumList, bShowCompletionItem, arrGoalType);
		}
	}

	if ( rewardIDList.length > 0 )
	{
		setRewardItem( rewardIDList, rewardNumList );
	}


	selectQuestLastCall( QuestID );
	/*
	//������ ����Ʈ [����Ʈ �˶��� �ΰ�??]
	SelectQuestID = QuestID;
	SelectLevel = Level;
	SelectCompleted = Completed;

	SelectarrItemID = arrItemIDList;
	SelectarrItemNumList = arrItemNumList;
	*/


}

/**
 * ����Ʈ ������ Tree�� �߰�.
 */
function setQuestItem( int Completed, int count, array<int> IDList, array<int> ItemNum, bool bShowCompletionItem, array<int> arrGoalType )
{
	local int i;
	local string TREENAME;
	local string setTreeName;
	local string strRetName;

	local bool bDrawBgTreeQuestItem;
	local string iconName;
	local string itemName;

	TREENAME = "QuestTreeDrawerWnd.QuestItemTree";
	TreeClear( TREENAME );

	bDrawBgTreeQuestItem = false;
	//Roots ��� ����.
	util.TreeInsertRootNode( TREENAME, "List", "", 0, 2 );
	setTreeName = "List";

	for( i = 0 ; i < count ; i++ )
	{
		if ( arrGoalType[i] == 0 )
		{			
			if( IDList[i] < 1000000 )
			{
				strRetName = util.TreeInsertItemNode( TREENAME, string(i), setTreeName, false, -4, -2 );
				iconName = class'UIDATA_ITEM'.static.GetItemTextureName( GetItemID( IDList[i] ) );
				itemName = class'UIDATA_ITEM'.static.GetItemName( GetItemID( IDList[i] ) );

				if( !bDrawBgTreeQuestItem )
				{
					//Insert Node Item - ������ ���?
					util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 244, 38, , , , ,14 );
				}
				else
				{
					util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 244, 38 );
				}
				bDrawBgTreeQuestItem = !bDrawBgTreeQuestItem;

				//Insert Node Item - �����۽��� ���
				util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -238, 2 );
				//Insert Node Item - ������ ������
				util.TreeInsertTextureNodeItem( TREENAME, strRetName, IconName, 32, 32, -34, 3 );
				//Insert Node Item - ������ �̸�
				//[����Ʈ ������ ���� �߰�] ����Ʈ �����ۿ� ������ ǥ���ϱ� ���� item class id�� ����.
				util.TreeInsertTextNodeItem( TREENAME, strRetName, itemName, 5, 6, util.ETreeItemTextType.COLOR_DEFAULT, true, , IDList[i] );

				//������ ���� ǥ��
				if( ItemNum[i] > 0 )
				{
					if( Completed > 0 && bShowCompletionItem )
						util.TreeInsertTextNodeItem( TREENAME, strRetName, "(" $ GetSystemString(898) $ "/" $ ItemNum[i] $ ")", 48, -18, util.ETreeItemTextType.COLOR_GOLD, ,true );
					else
						util.TreeInsertTextNodeItem( TREENAME, strRetName, "(" $ ItemNum[i] $ ")", 48, -18, util.ETreeItemTextType.COLOR_GOLD, ,true );
				}
				else if( ItemNum[i] == 0 )
				{
					if( Completed > 0 && bShowCompletionItem )
						util.TreeInsertTextNodeItem( TREENAME, strRetName, "(" $ GetSystemString(898) $ "/" $ GetSystemString(858) $ ")", 48, -18, util.ETreeItemTextType.COLOR_GOLD, ,true );
					else
						util.TreeInsertTextNodeItem( TREENAME, strRetName, "(" $ GetSystemString(858) $ ")", 48, -18, util.ETreeItemTextType.COLOR_GOLD, ,true );				
				}
				else
				{
					if( Completed > 0 && bShowCompletionItem )
						util.TreeInsertTextNodeItem( TREENAME, strRetName, "(" $ GetSystemString(898) $ "/" $ string(-ItemNum[i]) $ GetSystemString(859) $ ")", 48, -18, util.ETreeItemTextType.COLOR_GOLD, ,true );
					else
						util.TreeInsertTextNodeItem( TREENAME, strRetName, "(" $ string(-ItemNum[i]) $ GetSystemString(859) $ ")", 48, -18, util.ETreeItemTextType.COLOR_GOLD, ,true );
				}
			}
		}
	}
}

/**
 * ���� ������ Tree�� �߰�.
 */
function setRewardItem( array<int> rewardIDList, array<INT64> rewardNumList )
{
	local int i;
	local string TREENAME;
	local string setTreeName;
	local string strRetName;
	
	local bool bDrawBgTreeReward;
	local string iconName;
	local string itemName;

	TREENAME = "QuestTreeDrawerWnd.QuestRewardItemTree";
	TreeClear( TREENAME );

	bDrawBgTreeReward = false;

	//Roots ��� ����.
	util.TreeInsertRootNode( TREENAME, "List", "", 0, 2 );
	setTreeName = "List";

	for( i = 0 ; i < rewardIDList.Length ; i++ )
	{
		strRetName = util.TreeInsertItemNode( TREENAME, string(i), setTreeName, false, -4, -2 );

		if( !bDrawBgTreeReward )
		{
			//Insert Node Item - ������ ���?
			util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 244, 38, , , , ,14 );
		}
		else
		{
			util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 244, 38 );
		}
		bDrawBgTreeReward = !bDrawBgTreeReward;

		//Insert Node Item - �����۽��� ���
		util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -238, 2 );
		
		//������ ������ ����
		switch (rewardIDList[i])
		{
			case 57:
				//�Ƶ��� �� ���
				iconName = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(57));		
				itemName = GetSystemString(469);

				//Insert Node Item - ������ ������
				util.TreeInsertTextureNodeItem( TREENAME, strRetName, IconName, 32, 32, -34, 3 );
				//Insert Node Item - ������ �̸�
				//[����Ʈ ������ ���� �߰�] ����Ʈ �����ۿ� ������ ǥ���ϱ� ���� item class id�� ����.
				util.TreeInsertTextNodeItem( TREENAME, strRetName, itemName, 5, 6, util.ETreeItemTextType.COLOR_DEFAULT, true );
					
				//�Ƶ��� ��
				//����
				if ( rewardNumList[i] == 0 )
					util.TreeInsertTextNodeItem( TREENAME, strRetName, GetSystemString(584), 48, -18, util.ETreeItemTextType.COLOR_GOLD, ,true );
				else 
					util.TreeInsertTextNodeItem( TREENAME, strRetName, MakeFullSystemMsg(GetSystemMessage(2932), MakeCostString(string(rewardNumList[i])),""), 48, -18, util.ETreeItemTextType.COLOR_GOLD, , true );
				break;
				
			default:
				iconName = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(rewardIDList[i]));
				itemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(rewardIDList[i]));

				//Insert Node Item - ������ ������
				util.TreeInsertTextureNodeItem( TREENAME, strRetName, IconName, 32, 32, -34, 3 );
				//Insert Node Item - ������ �̸�
				//[����Ʈ ������ ���� �߰�] ����Ʈ �����ۿ� ������ ǥ���ϱ� ���� item class id�� ����.
				util.TreeInsertTextNodeItem( TREENAME, strRetName, itemName, 5, 6, util.ETreeItemTextType.COLOR_DEFAULT, true, , rewardIDList[i] );

				//������ ����
				//����
				if (rewardNumList[i] == 0)
					util.TreeInsertTextNodeItem( TREENAME, strRetName, GetSystemString(584), 48, -18, util.ETreeItemTextType.COLOR_GOLD, ,true );
				else
				{
					// �Ʒ��� �ش��ϴ� ��� �� "��" ǥ�ð� �ȵǾ�� �Ѵ�.
					if (rewardIDList[i] == 15623 ||   // ����ġ  
						rewardIDList[i] == 15624 ||   // ��ų ����Ʈ
						rewardIDList[i] == 15625 ||   // ����ǥ        
						rewardIDList[i] == 15626 ||   // Ȱ�� ����Ʈ
						rewardIDList[i] == 15627 ||   // ���� ����Ʈ
						rewardIDList[i] == 15628 ||   // ���� ����
						rewardIDList[i] == 15629 ||   // ������ ����
						rewardIDList[i] == 15630 ||   // �߰� ����
						rewardIDList[i] == 15631 ||   // ���� Ŭ���� ���� ȹ��
						rewardIDList[i] == 15632 ||   // PK ī��Ʈ �϶� 
						rewardIDList[i] == 15633 || 						
						rewardIDList[i] == 47130      // ��ȣ��
						)
					{
						util.TreeInsertTextNodeItem( TREENAME, strRetName, MakeCostString(string(rewardNumList[i])), 48, -18, util.ETreeItemTextType.COLOR_GOLD, ,true );
					}
					else if(rewardIDList[i] == 95641)
					{
						util.TreeInsertTextNodeItem(treeName, strRetName, MakeFullSystemMsg(GetSystemMessage(13405), MakeCostString(string(rewardNumList[i])), ""), 48, -18, util.ETreeItemTextType.COLOR_GOLD,, true);							
					}
					else
					{
						util.TreeInsertTextNodeItem( TREENAME, strRetName, MakeFullSystemMsg(GetSystemMessage(1983), MakeCostString(string(rewardNumList[i])),""), 48, -18, util.ETreeItemTextType.COLOR_GOLD, ,true );      
					}
				}
				break;
		}
	}
}

/**
 * ����Ʈ �������� �ִ� ��� ���� ��� â ���� �ٲ�.
 */
function setQuestItemShow( bool b )
{
	if( b )
	{
		QuestDescriptionLargeTree.HideWindow();
		QuestDescriptionTree.ShowWindow();
		txtQuestItemTitle.ShowWindow();
		GroupBox_DescriptionTree.ShowWindow();
		GroupBox_ItemTree.ShowWindow();
		QuestItemTree.ShowWindow();
	}
	else
	{
		QuestDescriptionTree.HideWindow();
		QuestDescriptionLargeTree.ShowWindow();
		txtQuestItemTitle.HideWindow();
		QuestItemTree.HideWindow();
		GroupBox_DescriptionTree.HideWindow();
		GroupBox_ItemTree.HideWindow();
	}

}

// Ʈ�� ����
function TreeClear( string str )
{
	class'UIAPI_TREECTRL'.static.Clear( str );	
}


/**
 * ������ ����Ʈ�� ������ ������ �˸� â�� ������.
 */
function selectQuestLastCall( int selectQuest )
{
	local int Level;

	local int i;

	//����Ʈ ������ param
	local string QuestParam;
	//����Ʈ ������ ����
	local int Max;

	//����Ʈ �ʿ� ������ ID
	local array<int>		arrItemIDList;
	//����Ʈ �ʿ� ������ ����
	local array<int>		arrItemNumList;
	//����Ʈ ������� ��Ʈ�� Ÿ������?
	local array<int>        arrGoalType;

	Level = 0;

	//��ü ����Ʈ
	Level = util.getQuestLevelForID (selectQuest);

	QuestParam = class'UIDATA_QUEST'.static.GetQuestItem( selectQuest, Level );

	ParseInt( QuestParam, "Max", Max );	
	arrItemIDList.Length = Max;	
	arrItemNumList.Length = Max;
	arrGoalType.Length = Max;

	for ( i = 0; i < Max; i++ )
	{
		//����Ʈ �ʿ� ������ ID
		ParseInt( QuestParam, "GoalID_" $ i, arrItemIDList[i] );
		//����Ʈ �ʿ� ������ ����
		ParseInt( QuestParam, "GoalNum_" $ i, arrItemNumList[i] );
		//����Ʈ ��Ʈ�� Ÿ�� ����
		ParseInt( QuestParam, "GoalType_" $ i, arrGoalType[i]);
	}

	SelectQuestID = selectQuest;
	SelectLevel = Level;

	SelectarrItemID = arrItemIDList;
	SelectarrItemNumList = arrItemNumList;
	SelectarrGoalType = arrGoalType;
}


function onHide()
{
	AllClear();
}

function AllClear()
{
	util.TreeClear( "QuestTreeDrawerWnd.QuestItemTree" );
	util.TreeClear( "QuestTreeDrawerWnd.QuestRewardItemTree" );
	util.TreeClear( "QuestTreeDrawerWnd.QuestDescriptionTree" );
	util.TreeClear( "QuestTreeDrawerWnd.QuestDescriptionLargeTree" );

	txtQuestTitle.SetText("");
	//��õ����
	txtRecommandedLevel.SetText("");
	txtRecommandedLevelText.SetText("");
	txtQuestType.SetText("");

	btnGiveUpCurrentQuest.DisableWindow();
}

/*
//function array<string> getSystemStringArray(int type)
function array<int> getQuestItemID()
{
	//SelectarrItemNumList = arrItemNumList;
	return SelectarrItemID;
	//return item1Array;
}

function array<int> getQuestItemNum()
{
	//SelectarrItemNumList = arrItemNumList;
	return SelectarrItemNumList;	
}
*/

defaultproperties
{
}
