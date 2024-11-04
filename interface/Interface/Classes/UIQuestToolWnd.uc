/**
 *   GetQuestWnd �� GmFindTreeWnd �� �����ؼ� ����Ʈ �˻� �� �ϳ� ������� by Dongland
 *   
 *   �̰͵� ���ο� �뵵��.. �׳� �뷫 ¥����� ����Ŷ�.. ����� �����.. -_-)/
 *
 **/
class UIQuestToolWnd extends UICommonAPI;

const TIMER_ID_CHANGETEXT    = 10234567;
const TIMER_ID_UPDATELOCINFO = 10234568;

var WindowHandle   Me;
var ListCtrlHandle questListCtrl;
var HtmlHandle     QuestHtmlViewer;
var ButtonHandle   searchItemBtn;
//var ComboBoxHandle QuestTypeComboBox;
//var ComboBoxHandle QuestGradeComboBox;
var EditBoxHandle  searchEditBox;
var EditBoxHandle  itemCountEditBox;
//var EditBoxHandle  descViewEditBox;
var ButtonHandle   InitBtn;
var ButtonHandle   getItemBtn;
//var TextBoxHandle  ItemDescTextBox;
var TextBoxHandle  etcTextBox;
var TextBoxHandle  cTextBox;

var TextBoxHandle  playerLocText;

var Color Gold;
// var MinimapCtrlHandle QuestMinimap;

var HtmlHandle        DetailInfoHtmlCtrl;

var string htmlMsg;
var string QuestDescription;
var string selectNPCName; // ������ npc�̸�

var int freeNum;        // ���������
var int chargeNum;      // ���������
var int selectQuestId;  // ������ ����Ʈ ���̵� 
var int bicIconLen;

var Color redColor;

var bool apiChk;

function OnRegisterEvent()
{
	//RegisterEvent(  );
}

function OnLoad()
{
	SetClosingOnESC();
	//getInstanceUIData().addEscCloseWindow(getCurrentWindowName(string(Self)));	
	Initialize();
}

function Initialize()
{
	Me              = GetWindowHandle( "UIQuestToolWnd" );
	QuestListCtrl   = GetListCtrlHandle( "UIQuestToolWnd.QuestListCtrl" );
	QuestHtmlViewer = GetHtmlHandle( "UIQuestToolWnd.QuestHtmlViewer" );
	searchItemBtn   = GetButtonHandle( "UIQuestToolWnd.searchItemBtn" );

	//QuestTypeComboBox  = GetComboBoxHandle( "UIQuestToolWnd.QuestTypeComboBox" );
	//QuestGradeComboBox = GetComboBoxHandle( "UIQuestToolWnd.QuestGradeComboBox" );
	searchEditBox      = GetEditBoxHandle( "UIQuestToolWnd.searchEditBox" );
	itemCountEditBox   = GetEditBoxHandle( "UIQuestToolWnd.itemCountEditBox" );
	// descViewEditBox    = GetEditBoxHandle( "UIQuestToolWnd.descViewEditBox" );

	InitBtn    = GetButtonHandle( "UIQuestToolWnd.InitBtn" );
	getItemBtn = GetButtonHandle( "UIQuestToolWnd.getItemBtn" );

	// ItemDescTextBox = GetTextBoxHandle( "UIQuestToolWnd.ItemDescTextBox" );
	// QuestMinimap    = GetMinimapCtrlHandle( "UIQuestToolWnd.QuestMinimap" );

	DetailInfoHtmlCtrl = GetHtmlHandle("UIQuestToolWnd.DetailInfoHtmlCtrl");
	etcTextBox         = GetTextBoxHandle("UIQuestToolWnd.etcTextBox");
	cTextBox           = GetTextBoxHandle("UIQuestToolWnd.cTextBox");
	playerLocText      = GetTextBoxHandle("UIQuestToolWnd.playerLocText");

	Gold.R = 176;
	Gold.G = 153;
	Gold.B = 121;
	Gold.A = 100;
}

function OnTimer(int TimerID)
{
	local Vector pVec;
	local ELanguageType Language;

	if(TimerID == TIMER_ID_CHANGETEXT)
	{
		Language = GetLanguage();

		if(Language == LANG_Korean)
		{
			switch(Rand(7))
			{
				case  1 : cTextBox.SetText("�˻��� ����Ʈ ��Ͽ��� ���� Ŭ���� �ϸ�, �ش� ����Ʈ�� ��˻� �ȴ�."); break;
				case  2 : cTextBox.SetText("����, ����Ʈ����, �� �ܰ�,npc ������ ��� �˻��� �����ϴ�."); break;
				case  3 : cTextBox.SetText("QuestName-k ������ UIDATA_Quest API�� ����ؼ� ���������."); break;
				case  4 : cTextBox.SetText("Dongland���� �Ŀ��� �� ��ǰ�� ������ ����� ��� �ɼ� �ִ�."); break;
				case  5 : cTextBox.SetText("(-_-)/~~~~�� ���� �ѱ� ���������� ���Դϴ�~ "); break;
				case  6 : cTextBox.SetText("�߱� ������2�� ���� ����Ʈ �˻� ���Դϴ�."); break;
				default : cTextBox.SetText("���� ������ �ִ��� ��� �׽�Ʈ�� �ȵǼ� ���� ���װ� ���� �� ������ Ȯ���� �ʿ��ϴ�."); break;
			}
		}
	}
	else if (TimerID == TIMER_ID_UPDATELOCINFO) 
	{
		pVec = GetPlayerPosition();

		playerLocText.SetText("CurrentPlayer Position" $ "\\nx" $ int(pVec.x) $ " y" $ int(pVec.Y) $ " z" $ int(pVec.z));
	}
}

function OnShow()
{
	Me.KillTimer(TIMER_ID_CHANGETEXT);
	Me.SetTimer(TIMER_ID_CHANGETEXT, 10000);

	Me.KillTimer(TIMER_ID_UPDATELOCINFO);
	Me.SetTimer(TIMER_ID_UPDATELOCINFO, 100);

}

function OnHide()
{
	Me.KillTimer(TIMER_ID_CHANGETEXT);
}

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "searchItemBtn":
			OnsearchItemBtnClick();
			break;

		case "InitBtn":
			OnInitBtnClick();
			break;

		case "getQuestButton":
			getQuestButtonClick();
			break;

		case "MoveStartNPCButton":
			MoveStartNPCButtonClick();
			break;

		case "MoveTargetLocButton":
			MoveTargetLocButtonClick();
			break;
	}
}

function OnsearchItemBtnClick()
{
	FindAllQuest(searchEditBox.GetString());
}

function OnInitBtnClick()
{
	searchEditBox.SetString("");
	questListCtrl.DeleteAllItem();
}

function getQuestButtonClick()
{
	local int questID, nSelect;
	local LVDataRecord dataRecord;
	// local Vector loc;

	if(getInstanceUIData().getIsClassicServer())
	{
	}

	nSelect = questListCtrl.GetSelectedIndex();

	if (nSelect >= 0) 
	{
		questListCtrl.GetSelectedRec(dataRecord);
		questID = int(dataRecord.LVDataList[0].szData);

		Debug("questID" @ questID);
		if (questID > 0)
			ProcessChatMessage("//setquest " $ questID $ " 1");
	}
}

function MoveStartNPCButtonClick()
{
	local int questID, nSelect;
	local LVDataRecord dataRecord;
	local Vector loc;

	nSelect = questListCtrl.GetSelectedIndex();

	if (nSelect >= 0) 
	{  
		questListCtrl.GetSelectedRec(dataRecord);

		questID = int(dataRecord.LVDataList[0].szData);
		loc     = class'UIDATA_QUEST'.static.GetStartNPCLoc(questID, 1 );

		if (loc.x + loc.y + loc.z != 0)	
		{
			Debug("teleport -> " @ loc.x @ loc.Y @ loc.Z );
			ProcessChatMessage("//teleport" @ loc.x @ loc.Y @ loc.Z);
		}
		if (questID <= 0)
		{
			AddSystemMessageString("questID is wrong:" @ questID);
		}
	}
}

function MoveTargetLocButtonClick()
{
	local int questID, nSelect, questLevel;
	local LVDataRecord dataRecord;
	local Vector loc;

	nSelect = questListCtrl.GetSelectedIndex();

	if (nSelect >= 0) 
	{  
		questListCtrl.GetSelectedRec(dataRecord);

		questID    = int(dataRecord.LVDataList[0].szData);
		questLevel = int(dataRecord.nReserved2);
		
		loc = class'UIDATA_QUEST'.static.GetTargetLoc(QuestID, questLevel);

		if (loc.x + loc.y + loc.z != 0)	
		{
			if (questID > 0) 
			{
				Debug("teleport -> " @ loc.x @ loc.Y @ loc.Z );
				ProcessChatMessage("//teleport" @ loc.x @ loc.Y @ loc.Z);
			}
			else
			{
				AddSystemMessageString("questID is wrong:" @ questID);
			}
		}
	}
}

function FindAllQuest( String a_Param )
{
	local int ID, i, NpcID;
	local string modifiedString, fullNameString, NpcName;
	local string JournalName, beforeJournalName;
	local string modifiedParam, zoneName;
	local int directQuestID;
	local Vector zoneLoc;

	// m_ComboList.Remove(0, m_ComboList.Length);

	questListCtrl.DeleteAllItem();

	if (int(a_Param) > 0)
	{
		a_Param = class'UIDATA_QUEST'.static.GetQuestName( int(a_Param) );

		directQuestID = int(a_Param);
	}

	modifiedParam=Substitute(a_Param, " ", "", FALSE);
	
	for( ID = class'UIDATA_QUEST'.static.GetFirstID(); -1 != ID ; ID = class'UIDATA_QUEST'.static.GetNextID() )
	{
		fullNameString  = class'UIDATA_QUEST'.static.GetQuestName( ID );

		//modifiedString = Substitute(fullNameString, " ", "", FALSE);

		NpcID           = class'UIDATA_QUEST'.static.GetStartNPCID(ID, 1 );
		NpcName         = class'UIDATA_NPC'.static.GetNPCName( NpcID );


		for(i = 0; i < 100; i++)
		{
			// ������ 
			zoneLoc = class'UIDATA_QUEST'.static.GetTargetLoc(ID, i);

			zoneName = class'UIDATA_QUEST'.static.GetQuestName(class'UIDATA_QUEST'.static.GetQuestZone(id, i));
			// zoneName = GetZoneName(zoneLoc.x, zoneLoc.y, zoneLoc.z);

			JournalName = class'UIDATA_QUEST'.static.GetQuestJournalName( ID, i );
			JournalName = class'UIDATA_QUEST'.static.GetQuestJournalNameLine( JournalName );

			modifiedString = fullNameString $ JournalName $ NpcName $ zoneName;

			modifiedString = Substitute(modifiedString, " ", "", FALSE);

			// level 0 �� ������,  ������ , �����̸��� ���..���� ó�� 
			if ((len(JournalName) <= 0 || i == 0))
			{
				continue;
			}
			else
			{
				if (len(JournalName) != 0 && beforeJournalName == JournalName)
				{
					continue;
				}
			}
			if ( InStr( modifiedString  , modifiedParam ) != -1)
			{
				addItem(ID, i, fullNameString, JournalName);
				beforeJournalName = JournalName;
			}
			else if (int(a_Param) > 0)
			{
				addItem(ID, i, fullNameString, JournalName);

				JournalName = class'UIDATA_QUEST'.static.GetQuestJournalName( ID, i );
				JournalName = class'UIDATA_QUEST'.static.GetQuestJournalNameLine( JournalName );

				beforeJournalName = JournalName;
			}
		}
	}
}

/** �������� �߰� �Ѵ�. */
function addItem(int nItemID, int questLevel, string fullNameString, string JournalName)
{
	local LVDataRecord Record;
	local string questTypeStr, levelLimit, npcName;
	local int questType, minLevel, maxLevel;
	local int NpcID, clearedQuestID;
	local Vector loc;
	local bool bStartLoc, bTargetLoc;
	Record.nReserved1 = nItemID;
	Record.LVDataList.length = 8;

	questType    = class'UIDATA_QUEST'.static.GetQuestType( nItemID, questLevel );
	
	questTypeStr = getQuestTypeString(questType);

	minLevel        = class'UIDATA_QUEST'.static.GetMinLevel        ( nItemID, 1 );
	maxLevel        = class'UIDATA_QUEST'.static.GetMaxLevel        ( nItemID, 1 );

	// ��õ����
	if ( minLevel > 0 && maxLevel > 0 )
	{
		levelLimit = minLevel $ "~" $ maxLevel;	
	}
	else if  ( minlevel > 0 )
	{
		levelLimit = minLevel $ " " $ GetSystemString(859); // �̻�
	}
	else
	{
		levelLimit = GetSystemString(866); // ���Ѿ���
	}
	record.nReserved2 = questLevel;
	record.LVDataList[0].szData        = string( nItemID );
	record.LVDataList[1].TextColor     = Gold;
	record.LVDataList[1].buseTextColor = True;
	record.LVDataList[1].szData        = questTypeStr;
	record.LVDataList[2].szData = levelLimit;
	record.LVDataList[3].buseTextColor = True;
	
	if (questLevel == 1) 
	{
		record.LVDataList[3].szData     = "[" $ fullNameString $ "]"; // $ ", " $ i $ GetSystemString(537) $ ":" @ JournalName;
		record.LVDataList[3].TextColor  = getInstanceL2Util().Yellow;
	}
	else
	{
		record.LVDataList[3].szData        = "   [" $ fullNameString $ "]"; // $ ", " $ i $ GetSystemString(537) $ ":" @ JournalName;
		record.LVDataList[3].TextColor     = Gold;
	}

	Record.LVDataList[3].hasIcon = true;
	Record.LVDataList[3].attrColor.R=200;
	Record.LVDataList[3].attrColor.G=200;
	Record.LVDataList[3].attrColor.B=200;

	Record.LVDataList[3].attrStat[0]   = Substitute("   " $ questLevel $ ": " $ JournalName, "\\n", "<br1>", FALSE);

	NpcID           = class'UIDATA_QUEST'.static.GetStartNPCID(nItemID, 1 );
	NpcName         = class'UIDATA_NPC'.static.GetNPCName( NpcID );
	
	Record.LVDataList[4].szData = npcName;	

	clearedQuestID = class'UIDATA_QUEST'.static.GetClearedQuest(nItemID, questLevel);

	// ������ 
	loc = class'UIDATA_QUEST'.static.GetTargetLoc(nItemID, questLevel);

	record.LVDataList[5].szData = class'UIDATA_QUEST'.static.GetQuestName(class'UIDATA_QUEST'.static.GetQuestZone(nItemID, questLevel));
	
	//record.LVDataList[5].szData = GetZoneName(loc.x, loc.y, loc.z);

	if (isVectorZero(loc) == false)
	{
		bTargetLoc = true;
	}
	loc = class'UIDATA_QUEST'.static.GetStartNPCLoc(nItemID, questLevel);
	if (isVectorZero(loc) == false)
	{
		bStartLoc = true;
	}

	if (bTargetLoc == true && bStartLoc == true)
	{
		record.LVDataList[6].szData = "OK";
	}
	else if (bTargetLoc == true && bStartLoc == false)
	{   
		record.LVDataList[6].szData = "No StartNPCLoc";
	}
	else if (bTargetLoc == false && bStartLoc == true)
	{   
		record.LVDataList[6].szData = "No TargetLoc";
	}
	else
	{
		record.LVDataList[6].szData = "No Loc(StartNpcLoc,TargetLoc)";
	}

	if (clearedQuestID > 0)
	{
		record.LVDataList[7].buseTextColor = True;
		record.LVDataList[7].TextColor  = Gold;
		Record.LVDataList[7].szData = "QuestID:" $ String(clearedQuestID) $ ": "$ class'UIDATA_QUEST'.static.GetQuestName( clearedQuestID );
		Record.LVDataList[7].hasIcon = true;
		Record.LVDataList[7].attrColor.R=200;
		Record.LVDataList[7].attrColor.G=200;
		Record.LVDataList[7].attrColor.B=200;
		Record.LVDataList[7].attrStat[0] = GetSystemString(1201) $ ":" $ class'UIDATA_QUEST'.static.GetRequirement(nItemID, questLevel);
	}

	//Record.LVDataList[1].HiddenStringForSorting = util.makeZeroString(6, info.crystalType);
	//Record.LVDataList[1].textAlignment=TA_Left;

	//Record.LVDataList[2].szData = String(info.Id.ClassID);
	//Record.LVDataList[2].textAlignment=TA_Left;

	questListCtrl.InsertRecord( Record );
}

function OnRButtonClickListCtrl(string ListCtrlID, int SelectedIndex)
{
	if (ListCtrlID == "QuestListCtrl") 
	{
		// TargetLoc ���� �̵� 
		OnClickButton("MoveTargetLocButton");
	}
}

function OnDBClickListCtrlRecord( string ListCtrlID)
{
	local int questID, nSelect, questLevel;
	local LVDataRecord dataRecord;

	nSelect = questListCtrl.GetSelectedIndex();

	if (ListCtrlID == "QuestListCtrl") 
	{
		if (nSelect >= 0) 
		{
			questListCtrl.GetSelectedRec(dataRecord);

			questID    = int(dataRecord.LVDataList[0].szData);
			questLevel = int(dataRecord.nReserved2);
			
			// loc = class'UIDATA_QUEST'.static.GetTargetLoc(QuestID, questLevel);
			
			if (questID > 0)
			{
				// searchEditBox.SetString(string(questID));
				//OnClickButton( "searchItemBtn" );
				FindAllQuest(string(questID));
			}
		}
	}
}


/**
 * ����Ʈ ������ 
 */
function showQuestDrawer( int QuestID, int level)
{
	local int i;

	//����Ʈ ����
	// local int Level;
	//����Ʈ Ÿ��
	local int QuestType;

	//��õ ���� ����, �ְ�
	local int MinLevel, MaxLevel;

	//����Ʈ ������ param
	local string QuestParam;
	//����Ʈ ������ ����
	local int Max;

	//����Ʈ �ʿ� ������ ID
	local array<int>		arrItemIDList;
	//����Ʈ �ʿ� ������ ����
	local array<int>		arrItemNumList;

	//���� ������ ID
	local Array<int> rewardIDList;
	//���� ������ ����
	local Array<INT64> rewardNumList;

	//����Ʈ �� ����
	local string JournalName;
	local string titleName;

	local string npcName;

	local string targetString;
	local string levelText;
	local string questTypeText;

	///////////////////////////
	local Vector loc, targetLoc;
	local string locHtml;
	local int npcID;
	local int questZone;
	local string questArea;
	local string ItemNumStr;
	local string etcOutputStr;

	htmlMsg="";
	htmlMsg="<html><body>" $ htmlTableAdd();

	//Level = 1;

	MinLevel = class'UIDATA_QUEST'.static.GetMinLevel( QuestID, Level );
	MaxLevel = class'UIDATA_QUEST'.static.GetMaxLevel( QuestID, Level );

	npcID   = class'UIDATA_QUEST'.static.GetStartNPCID( QuestID, 1 );
	npcName = class'UIDATA_NPC'.static.GetNPCName( npcID );

	etcOutputStr = etcOutputStr $ "NpcID :" @ npcID $ ", npcName :" @ npcName $ "\\n\\n";

	QuestDescription = class'UIDATA_QUEST'.static.GetQuestDescription( QuestID, Level );
	QuestDescription = Substitute(QuestDescription, "\\n", "<br1>", FALSE);

	questZone       = class'UIDATA_QUEST'.static.GetQuestZone            ( QuestID, 1 );
	// questArea       = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName( questZone );

	//����Ʈ ������
	JournalName = class'UIDATA_QUEST'.static.GetQuestJournalName( QuestID, Level );
	JournalName = class'UIDATA_QUEST'.static.GetQuestJournalNameLine( JournalName );
	titleName = htmlAddText( "[" @ JournalName  @ "]", "hs10", "d4af6f" );

	//���� ǥ��( 1~23, 11�̻�, ���� ���� )
	//txtRecommandedLevelText.SetTextColor( util.Token1 );
	if ( MaxLevel > 0 && MinLevel > 0)
		levelText =  MinLevel $ "~" $ MaxLevel;
	else if ( MinLevel > 0 )
		levelText =  MinLevel $ " " $ GetSystemString(859);
	else
		levelText = GetSystemString(866);

	//levelText = htmlAddText( levelText, "GameDefault", "ffe58f" );

	//����Ʈ Ÿ��
	questType = class'UIDATA_QUEST'.static.GetQuestType( questID, 1 );
	//QuestType = Class'UIDATA_QUEST'.static.GetQuestIscategory( QuestID, Level );

	// ����Ʈ�з� ����, ����...
	if( 0 <= questType && questType <= 13 ) questTypeText = getQuestTypeString(questType);

	questTypeText = htmlfontAdd( questTypeText $ "  [" );

	// ��ġǥ��
	loc = class'UIDATA_QUEST'.static.GetStartNPCLoc( QuestID, 1 );

	etcOutputStr = etcOutputStr $ "startNpc Loc :" @ " x" $ int(loc.x) $ " y" $ int(loc.Y) $ " z" $ int(loc.z) $ "\\n\\n";

	// ���� npc ������ ���ٸ� targetLoc �� ����
	if (loc.x ==0 && loc.y == 0 && loc.z == 0)	
	{
		loc = class'UIDATA_QUEST'.static.GetTargetLoc(QuestID, Level);
		etcOutputStr = etcOutputStr $ "TargetLoc :" @ " x" $ int(loc.x) $ " y" $ int(loc.Y) $ " z" $ int(loc.z) $ "\\n\\n";
	}
	else
	{
		targetLoc = class'UIDATA_QUEST'.static.GetTargetLoc(QuestID, Level);
		etcOutputStr = etcOutputStr $ "TargetLoc :" @ " x" $ int(targetLoc.x) $ " y" $ int(targetLoc.Y) $ " z" $ int(targetLoc.z) $ "\\n\\n";
	}

	etcOutputStr = etcOutputStr $ "TargetName :" @ class'UIDATA_QUEST'.static.GetTargetName(QuestID, Level)  $ "\\n\\n";

	etcOutputStr = etcOutputStr $ "bOnlyMinimap :" @ class'UIDATA_QUEST'.static.IsMinimapOnly(QuestID, Level)  $ "\\n\\n";

	// npc ���� ��ġ�� �������� ���̸��� ���� ���� ��Ȯ�� �������� ��´�.
	//questArea    = GetZoneName(loc.x, loc.y, loc.z); // �߱� ���� �Լ��ε�..
	etcOutputStr = etcOutputStr $ "ZoneLoc :" @ " x" $ int(loc.x) $ " y" $ int(loc.Y) $ " z" $ int(loc.z) $ "\\n";

	//Debug("loc.x" @ loc.x);
	//Debug("loc.y" @ loc.y);
	//Debug("loc.z" @ loc.z);

	npcName = Substitute( npcName, " ", "!!", FALSE);

	// ZoomTownMap=0 ���� ����, ��ü�� �� ��������� ���̱� ����...
	//locHtml = "<a action="$ "\"" $ "event eventString=minimap X=" $ loc.x $" Y=" $ loc.y $ " Z=" $ loc.z 
	//		$ " ZoomTownMap=1 UseGrid=0 toolTipStr=" $ npcName $ "\"" $ ">" $ questArea @ GetSystemString(7199) $ "</a>"; //849ba2 8bc733

	locHtml = "(" $ npcName $ ")" $ questArea @ GetSystemString(7199) $ "<br>"; //849ba2 8bc733

	// ����Ʈ�̸�, ��õü�� : ����
	htmlMsg = htmlMsg $ titleName $ "<br1>" $ htmlfontAdd(GetSystemString(922) @":"@ levelText) 
		      $ "<br1>" $ questTypeText $ locHtml $ htmlfontAdd("]") $ "<br1></td></tr></table><br>";

	QuestParam = class'UIDATA_QUEST'.static.GetQuestItem( QuestID, Level );

	ParseInt( QuestParam, "Max", Max );	
	arrItemIDList.Length = Max;	
	arrItemNumList.Length = Max;

	////////// 12.04.20 ��ǥ�� ǥ���� ������ �ִ°�? ////////////////////////////////////////////////////////////////////////

	for ( i = 0; i < Max; i++ )
	{
		//����Ʈ �ʿ� ������ ID
		ParseInt( QuestParam, "ItemID_" $ i, arrItemIDList[i] );
		//����Ʈ �ʿ� ������ ����
		ParseInt( QuestParam, "ItemNum_" $ i, arrItemNumList[i] );

		//������ 0�� ��� 
		if( arrItemNumList[i] == 0 )
		{
			ItemNumStr = GetSystemString( 7292 );
		}
		else
		{
			ItemNumStr = string(arrItemNumList[i]);
		}

		if( arrItemIDList[i] - 1000000 > 0 )
		{

			targetString = htmlfontAdd( targetString $ class'UIDATA_NPC'.static.GetNPCName( arrItemIDList[i] - 1000000) 
				@ ItemNumStr $ "NeedKill") $ "<br1>";  // óġ
		}
		else
		{
			targetString = htmlfontAdd( targetString $ class'UIDATA_ITEM'.static.GetItemName( GetItemID( arrItemIDList[i] ) )
				@ ItemNumStr $ "NeedItem" ) $ "<br1>"; // ȹ��
		}
	}

	if( Max > 0  ) // ��ǥ �߰�
	{
		targetString = htmlTableAdd() $ "<font name=hs10 color=\"d4af6f\">" $ GetSystemString(7259) $ "</font>" $ "<br1>" 
					   $ targetString $ "<br1></td></tr></table><br>"; 
		htmlMsg = htmlMsg @ targetString; 
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	rewardIDList.Remove(0, rewardIDList.Length);
	rewardNumList.Remove(0, rewardNumList.Length);

	class'UIDATA_QUEST'.static.GetQuestReward( QuestID, Level, rewardIDList, rewardNumList);

	// ���� 
	if ( rewardIDList.length > 0 )
	{
		setRewardItem( rewardIDList, rewardNumList );
	}

	etcTextBox.SetText(etcOutputStr);

}

/**
 * ������ ���� �������߰�.
 */
function setRewardItem( array<int> rewardIDList, array<INT64> rewardNumList )
{
	local int i;
	local string iconName;
	local string itemName;

	//////////////
	local string rewardSmallIconHtml, rewardMsgHtml, rewardEndMsgHtml, itemText;
	local int tableIndex, smallIconIndex;

	local string addItemHtml, htmlString;

	tableIndex = 0;
	smallIconIndex = 0;
	bicIconLen = 0;

	rewardSmallIconHtml = "<table width=280 border=0 cellpadding=0 cellspacing=2 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";
	rewardMsgHtml = "<table width=280 border=0 cellpadding=0 cellspacing=2 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";

	for ( i = 0 ; i < rewardIDList.Length ; i++ )
	{
		if ( rewardIDList[i] != 57 && rewardIDList[i] != 15623 && rewardIDList[i] != 15624 && rewardIDList[i] != 47130)
		{
			bicIconLen++;
		}
	}
	
	if ( rewardIDList.length > 0 )
	{
		for( i = 0 ; i < rewardIDList.Length ; i++ )
		{

			if( i == 0 )
			{
				//addItemHtml = htmlTableAdd( "L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Up" ) $ 
				//			  "<font color=\"d4af6f\" name=name=GameDefault>" $ GetSystemString(1127) $ "</font>" $ 
				//			  "<br1><img src=L2UI_CT1.Divider.Divider_DF_Ver width=286 height=2><br1></td></tr></table>"; // ����

				addItemHtml = // htmlTableAdd( "L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Up" ) $ 
							  htmlTableAdd( "L2UI_CT1.GroupBox.GroupBox_DF" ) $ 					
							  "<font color=\"ffcc00\" name=GameDefault>" $ GetSystemString(2006) $ "</font>" $ "</td></tr></table>"; // ���� ������
			}
							  
							  //"<br1><img src=L2UI_CT1.Divider.Divider_DF_Ver width=274 height=2><br></td></tr></table>"; // ����


				switch (rewardIDList[i])
				{
					case 57: // �Ƶ��� iconName = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(57));	
					case 15623: // ����ġ
					case 15624: // sp, ��ų����Ʈ
					case 47130: // ��ȣ��
						itemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(rewardIDList[i]));
						if( rewardIDList[i] == 57 )
						{
							iconName = "L2UI_CT1.HtmlWnd.HTMLWnd_adena";
							itemName = GetSystemString(469);
						}
						else if( rewardIDList[i] == 15623 )
						{
							if (getLanguageNumber() == 1)
							{
								// �̱� 
								// ���Ŀ� xp ���������� ��ü �ϸ� �ɵ�..
							}

							iconName = "L2UI_CT1.HtmlWnd.HTMLWnd_EXP";
						}
						else if(  rewardIDList[i] == 15624 )
						{
							iconName = "L2UI_CT1.HtmlWnd.HTMLWnd_SP";
						}

						// 2015-11-23 FP �߰� (���� ������)
						else if(  rewardIDList[i] == 47130 )
						{
							iconName = "L2UI_CT1.HtmlWnd.HTMLWnd_FP";
						}

						//����
						if (rewardNumList[i] == 0)
						{
							itemText = GetSystemString(584);
						}
						else
						{
							// SP �� ��� 
							if (rewardIDList[i] == 15624)
							{
								//itemText = string(getInstanceUIData().getSPChangedValue(rewardNumList[i]));
								itemText = (String(rewardNumList[i]));
								// Debug("sp rewardNumList[i]" @ rewardNumList[i]);
							}
							// �׿�
							else
							{
								itemText = (String(rewardNumList[i]));
							}
						}

						//$ " itemtooltip=\"" $ rewardIDList[i] $ "\"" 
						//rewardSmallIconHtml = rewardSmallIconHtml $ "<tr><td width=38 height=22 align=center valign=center><button width=32 height=16"											  
						//					  $	" back=\"" $ iconName $ "\"" $ " high=\"" $ iconName $ "\"" $ " fore=\"" $ iconName $ "\"></td><td height=22 width=246><font color=ba8860>" 
						//					  $ itemText $"</font>" @ htmlfontAdd(itemName) $ "</td></tr>";

						rewardSmallIconHtml = rewardSmallIconHtml $ "<tr><td width=45 height=23 align=center valign=center><Img width=32 height=18"											  
											  $	" src=\"" $ iconName $ "\"" $ "></td><td height=23 width=246><font color=ba8860>" 
											  $ itemText $"</font>" @ htmlfontAdd(itemName) $ "</td></tr>";

						smallIconIndex = smallIconIndex + 1;
						break;

					default:
						iconName = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(rewardIDList[i]));
						itemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(rewardIDList[i]));

						// Debug("iconName" @ iconName);
						// Debug("rewardIDList[i]"  @ rewardIDList[i]);

						//������ ����
						//����
						if (rewardNumList[i] == 0)
						{
							itemText = htmlfontAdd( GetSystemString(584), "ba8860" );
						}
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
								rewardIDList[i] == 15633)
							{
								itemText = htmlfontAdd((string(rewardNumList[i])), "ba8860");
							}
							else
							{
								itemText =MakeFullSystemMsg(htmlfontAdd(GetSystemMessage(1983)), htmlfontAdd((string(rewardNumList[i])),"ba8860"),"");
							}
						}

						// ū������ �������� �ϳ��϶� ������ǥ �ȵǰ� 
						if( bicIconLen == 1 )
						{
							rewardMsgHtml = rewardMsgHtml $ "<tr><td align=center valign=center width=43 height=39><button width=32 height=32" 
											$ " itemtooltip=\"" $ rewardIDList[i] $ "\"" $ " back=\"" $ iconName $ "\"" $ " high=\"" $ iconName 
											$ "\"" $  " fore=\"" $ iconName $ "\"></button></td><td width=240 hdight=39>" $ htmlfontAdd(itemName) 
											$ "<br1>"$ itemText $ "</td></tr>";
						}
						else
						{
							if( rewardIDList.Length > 0 && len(itemName) > 8 )
							{
								itemName = mid(itemName, 0 , 8) $ "..";
							}

							if( tableIndex % 2 > 0 ) // ù��° 
							{
								rewardMsgHtml = mid(rewardMsgHtml, 0 , len(rewardMsgHtml)-5);
								rewardMsgHtml = rewardMsgHtml $ "<td align=center valign=center width=43 height=39><button width=32 height=32" 
												$ " itemtooltip=\"" $ rewardIDList[i] $ "\"" $ " back=\"" $ iconName $ "\"" $ " high=\"" $ iconName 
												$ "\"" $  " fore=\"" $ iconName $ "\"></button></td><td width=115 hdight=39>" $ htmlfontAdd(itemName) 
												$ "<br1>"$ itemText $ "<br1>" $"</td></tr>";
							}
							else 
							{
								rewardMsgHtml = rewardMsgHtml $ htmlTableTrAdd() $  "<tr><td align=center valign=center width=43 height=39><button width=32 height=32" 
												$ " itemtooltip=\"" $ rewardIDList[i] $ "\"" $ " back=\"" $ iconName $ "\"" $ " high=\"" $ iconName 
												$ "\"" $  " fore=\"" $ iconName $ "\"></button></td><td width=115 hdight=39>" $ htmlfontAdd(itemName) 
												$ "<br1>"$ itemText $ "</td></tr>";
							}
						}

						/// Debug("iconName" @ iconName);

						tableIndex = tableIndex + 1;
				}
			
		}

		///////// ����Ʈ ���� ��� ����////////////////////////////////////
		if( tableIndex > 0 )
		{
			rewardMsgHtml = rewardMsgHtml $ "</table>";
		}
		else
		{
			rewardMsgHtml = "";
		}

		if( smallIconIndex > 0 )
		{
			rewardSmallIconHtml = rewardSmallIconHtml $ "</table>";
		}
		else
		{
			rewardSmallIconHtml = "";
		}
		/////////////////////////////////////////////////////////////////////
		
		htmlString = mid(htmlString, 6, len(htmlString)); //<html> �ױ� ����
		htmlString = mid(htmlString, 0, len(htmlString) - 7); //</html> �ױ� ����
		
		//rewardEndMsgHtml = "<table width=290 border=0 cellpadding=0 cellspacing=3 background=L2UI_Ct1_Cn.Deco.TitleBaseBarMini_HtmlTableDown><tr><td width=290></td></tr></table>";
		rewardEndMsgHtml = "<table width=278 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Down><tr><td width=278></td></tr></table>";

		addItemHtml = htmlString $ addItemHtml $ rewardSmallIconHtml $ rewardMsgHtml $ rewardEndMsgHtml;

		//addItemHtml =  "<html><body>" $ addItemHtml $ "<br><table border=0 cellpadding=0 cellspacing=3 width=288 ><tr><td height=15 align=center valign=center><img src=L2UI_CT1_CN.Deco.Horizontal_Deco width=286 height=8></td></tr><tr><td></td></tr></table></body></html>";
		addItemHtml =  "<html><body>" $ addItemHtml $ "<br><table border=0 cellpadding=0 cellspacing=3 width=288 ><tr><td height=11 align=center valign=center></td></tr><tr><td></td></tr></table><br><br>" $ rewardEndMsgHtml $ QuestDescription $ "</body></html>";
		//addItemHtml =  "<html><body>" $ addItemHtml $ "<br><table border=0 cellpadding=0 cellspacing=3 width=288 ><tr><td height=15 align=center valign=center></td></tr><tr><td></td></tr></table></body></html>";

	//rewardEndMsgHtml = "<table width=290 border=0 cellpadding=0 cellspacing=3 background=L2UI_Ct1_Cn.Deco.TitleBaseBarMini_HtmlTableDown><tr><td width=290></td></tr></table>";

	//QuestDescription = "<br><table border=0 cellpadding=0 cellspacing=3 width=288 ><tr><td height=15 align=center valign=center><img src=L2UI_CT1_CN.Deco.Horizontal_Deco width=286 height=8></td></tr><tr><td>" $ QuestDescription $ "</td></tr></table>";

	//htmlMsg = htmlMsg $ rewardSmallIconHtml $ rewardMsgHtml $ rewardEndMsgHtml $ QuestDescription $ "</body></html>"; // ����κ� �߰�
	
		DetailInfoHtmlCtrl.LoadHtmlFromString( addItemHtml );
	}
}

function string htmlTableAdd( optional string backgroundUrl )
{
	local string htmlStr;

	if( backgroundUrl == "" ) 
		htmlStr = "<table width=279 cellpadding=0 border=0 cellspacing=3" $ "><tr><td width=4></td><td width=273>";
	else 
		htmlStr = "<table width=279 cellpadding=0 border=0 cellspacing=3 background="$ backgroundUrl $"><tr><td width=0></td><td width=273>";
		// backgroundUrl = "L2UI_Ct1_Cn.Deco.TitleBaseBarMini";

	return htmlStr;
}

function string htmlTableTrAdd()
{
	return "<tr><td width=40 ></td><td width=115 ></td><td width=40 ></td><td width=115 ></td></tr>";
}

function string htmlfontAdd( string strText, optional string fontColor )
{
	local string targetHtml;
	if( fontColor == "" ) fontColor = "d3c5ae";
	
	targetHtml = "<font color=\"" $ fontColor $ "\"" $ ">" $ strText $ "</font>";

	return targetHtml;
}

/***
 * ����Ʈ ��Ʈ���� Ŭ�� ������ 
 **/
function OnClickListCtrlRecord( string ListCtrlID )
{
	if ( ListCtrlID == "QuestListCtrl" )
	{ 
		addPinInTheMap( ListCtrlID, -1 );
	}
}

///** �ʿ� ���� �Ŵ´�.  */
function addPinInTheMap( string ListCtrlID, int SelectedIndex )
{
	local LVDataRecord	record;	
	local int questID, level;

	if ( ListCtrlID == "QuestListCtrl" )
	{ 
		if ( SelectedIndex != -1 ) QuestListCtrl.SetSelectedIndex( SelectedIndex, false );

		QuestListCtrl.GetSelectedRec( record );
		questID = INT( record.nReserved1 ); 
		level = INT( record.nReserved2 ); 
		showQuestDrawer( questID, level );

		//// ���� ���� ������ �ش� ��ġ�� ���� �̵�
		//if ( GetWindowHandle("MiniMapWnd").IsShowWindow() )
		//{			
		//	loc     = class'UIDATA_QUEST'.static.GetStartNPCLoc( questID, 1 );
		//	// ���� npc ������ ���ٸ� targetLoc �� ����
		//	if (loc.x + loc.y + loc.z != 0)	loc = class'UIDATA_QUEST'.static.GetTargetLoc(QuestID, 1);

		//	npcID   = class'UIDATA_QUEST'.static.GetStartNPCID( questID, 1 );
		//	npcName = class'UIDATA_NPC'.static.GetNPCName( npcID );
		//	npcName = Substitute( npcName, " ", "!!", FALSE);

		//	//ExecuteEvent(EV_ShowMinimapByHtml, "x=" $ loc.x @ 
		//	//								   "y=" $ loc.y @ 
		//	//								   "z=" $ loc.z @ 
		//	//								   "ZoomTownMap=1" @ 
		//	//								   "UseGrid=0" @ 
		//	//								   "toolTipStr=" $ npcName);

		//	// GetWindowHandle("miniMapWnd").SetFocus();
		//}

		// ����Ʈ ����Ʈ�� ��Ŀ���� �ش�
		if( SelectedIndex == -1 ) QuestListCtrl.SetFocus();

		//if( INT( record.nReserved2 ) == 1 )
		//{
		//	TeleportButton.DisableWindow();
		//}
		//else
		//{
		//	TeleportButton.EnableWindow();
		//}
	}
}

// �̱� xp ǥ���� ���ؼ�..
function int getLanguageNumber()
{
	local ELanguageType Language;
	local int languageNum;

	Language = GetLanguage();

	switch( Language )
	{
		case LANG_Korean:
			languageNum = 0;
			break;	
		case LANG_English:
			languageNum = 1;
			break;
		case LANG_Japanese:
			languageNum = 2;
			break;
		case LANG_Taiwan:
			languageNum = 3;
			break;
		case LANG_Chinese:
			languageNum = 4;
			break;
		case LANG_Thai:
			languageNum = 5;
			break;
		case LANG_Philippine:
			languageNum = 6;
			break;
		case LANG_Indonesia:
			languageNum = 7;
			break;
		case LANG_Russia:
			languageNum = 8;
			break;
		case LANG_Euro:
			languageNum = 9;
			break;
		case LANG_Germany:
			languageNum = 10;
			break;
		case LANG_France:
			languageNum = 11;
			break;
		case LANG_Poland:
			languageNum = 12;
			break;
		case LANG_Turkey:
			languageNum = 13;
			break;
		//end of branch
		default:
			languageNum = 0;
			break;
	}

	return languageNum;
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	GetWindowHandle(getCurrentWindowName(string(Self))).HideWindow();
}

/** OnKeyUp */
function OnKeyUp( WindowHandle a_WindowHandle, EInputKey nKey )
{
	// Ű���� �������� üũ
	if (searchEditBox.IsFocused())
	{
		// txtPath
		if (nKey == IK_Enter)
		{
			// Ű���� �Է��� �ƹ��͵� �Է� ���� �ʾ����� ��ü �˻��� ������� �ʴ´�.
			// �Ǽ��� �ڲ� ������ ��찡 �־..
			if (trim(searchEditBox.GetString()) != "") OnsearchItemBtnClick();
		}
	}
}

defaultproperties
{
}
