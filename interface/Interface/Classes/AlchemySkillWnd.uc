// ----------------------------------------------------------------------------------------------------------
// 
// Name : MagicSkillWnd �� �������� ���۵� ���ݼ� UI
// 
//  npc ���ξ� , ���Ƕ�, ���Լ� ��ų�� ���� �Ѵ�. 
// ----------------------------------------------------------------------------------------------------------
class AlchemySkillWnd extends UICommonAPI;

const Skill_MAX_COUNT     = 24;
const Skill_GROUP_COUNT   = 8;

//��ų ���� ����
const SKILL_COL_COUNT     = 7;

const Skill_GROUP_COUNT_P = 6;	//�нú��

const SKILL_ITEMWND_WIDTH = 260;
const SKILL_SLOTBG_WIDTH  = 252;
const TOP_MARGIN = 5;
const NAME_WND_HEIGHT     = 20;
const BETWEEN_NAME_ITEM   = 3;

// ��ų �׷� ��ȣ
const SKILL_NORMAL     = 0; // ���� ��ų. ������ �� ��, ���� ����.
const SKILL_BUF        = 1;	// ����
const SKILL_DEBUF      = 2;	// �����
const SKILL_TOGGLE     = 3;	// ���
const SKILL_SONG_DANCE = 4;	// �۴�
const SKILL_ITEM       = 5; // ������ ��ų
const SKILL_HERO       = 6;	// ���� ��ų
const SKILL_CHANGE     = 7;	// ���� ��ų

const SKILLTYPE_ALCHEMYSKILL = 140;


//////////////////////////////////////////////////////////////////////////////
// CONST
//////////////////////////////////////////////////////////////////////////////
const OFFSET_X_ICON_TEXTURE=0;
const OFFSET_Y_ICON_TEXTURE=4;
const OFFSET_Y_SECONDLINE = -17;

var WindowHandle	m_wndTop;
var WindowHandle	m_wndSkillDrawWnd;
// ��Ƽ���

var bool m_bShow;
var String m_WindowName;

var int currentUserLevel;
var WindowHandle	Drawer;

//��ų ����� ����
var L2Util util;

var bool bDrawBgTree1;
var bool bDrawBgTree2;
var bool bDrawBgTree3;

var string TREENAME;
var string ROOTNAME;
var string LIST1;
var string LIST2;
var string LIST3;

var int selectedRequestLevel, totalSkillCount, addCount;

var string beforeTreeName;

var int nScrollHeight;	   	  // ��ü �������� ��ũ�� ũ�� ����

// var AnimTextureHandle TexTabLightActive;

// var AnimTextureHandle TexTabLightPassive;

var TreeHandle m_UITree;

// var ButtonHandle ResearchButton;

// Ʈ�� ��� �̸� �迭
var array<string> treeNodeNameNewSkillArray;
var array<string> treeNodeNameLevelUpArray;
var string clickedTreeNodeName;

var array<SkillTrainInfo> skillTrainInfoArray;

var int clickedTreeNodeIndex;

var WindowHandle SkillTrainInfoWndScript;

var int levelUpSkillIndex, newSkillIndex;

var UserInfo playerInfo;

var bool bRefreshSelect;
var int mainLevel;

//var int dualLevel;
// var int currentType;

function OnRegisterEvent()
{
	RegisterEvent( EV_SkillTrainListWndShow );
	//RegisterEvent( EV_SkillTrainListWndHide );
	RegisterEvent( EV_SkillTrainListWndAddSkill );

	RegisterEvent(EV_UpdateUserInfo);

	// RegisterEvent(EV_RESTART);
}

function OnLoad()
{
	SetClosingOnESC();

	OnRegisterEvent();

	InitHandle();

	util = L2Util(GetScript("L2Util"));	
	SkillTrainInfoWndScript = GetWindowHandle("AlchemySkillLearnWnd");

	m_bShow = false;
}

function InitHandle()
{
	m_UITree = GetTreeHandle("AlchemySkillWnd.SkillTrainTree");
}

function OnShow()
{
	GetPlayerInfo(playerInfo);
	currentUserLevel = playerInfo.nLevel;
	// ���� Ŭ�� ���� �ʱ�ȭ
	clickedTreeNodeName = "";
	clickedTreeNodeIndex = -1;

	// RequestSkillList();
	m_bShow = true;
}

function OnHide()
{
	m_bShow = false;

	if (GetWindowHandle("AlchemySkillLearnWnd").IsShowWindow())
		GetWindowHandle("AlchemySkillLearnWnd").HideWindow();
}

function OnEvent(int Event_ID, String param)
{
	//local string strIconName;
	//local string strName;
	//local int iID;
	//local int iLevel;
	//local int iSPConsume;
	//local string strEnchantName;
	//local int NewSkillID;
	//local SkillInfo skillInfo;
	//local UserInfo userinfo;
			
	local int iType;


	// �������̾� ���ݼ� ��ų Ÿ�� �̶��..
	
	// SKILLTYPE_ALCHEMYSKILL : ���ݼ� Ÿ��	
	
	switch(Event_ID)
	{
		case EV_SkillTrainListWndShow :
			 
			 ParseInt(param, "Type"	, iType);

			 if (iType == SKILLTYPE_ALCHEMYSKILL)
			 {   
				ParseInt(param, "Count"	, totalSkillCount);	
				
				//��ų ������ ���� �� â�� �ݴ´� 
				//EV_SkillTrainListWndHide �̺�Ʈ�� ���� ����
				if(totalSkillCount == 0)
				{
					if(IsShowWindow("AlchemySkillWnd"))
						HideWindow("AlchemySkillWnd");

					return;
				}

				GetPlayerInfo(playerInfo);
				currentUserLevel = playerInfo.nLevel;
				TreeClear();
				ShowSkillTree();
				levelUpSkillIndex = 0;
				newSkillIndex = 0;
				bRefreshSelect = false;
				treeNodeNameNewSkillArray.Remove(0, treeNodeNameNewSkillArray.Length);
				treeNodeNameLevelUpArray.Remove(0, treeNodeNameLevelUpArray.Length);
				skillTrainInfoArray.Remove(0, skillTrainInfoArray.Length);

				if(!IsShowWindow("AlchemySkillWnd"))
			 		ShowWindow("AlchemySkillWnd");
			 }
			 break;

		case EV_SkillTrainListWndAddSkill :
			 Debug("��ų �߰�" @ param);
			 ParseInt(param, "iType"	, iType);
			 if (iType == SKILLTYPE_ALCHEMYSKILL) 
			 {
				AddSkillTrainListItem(param);
				buildTree();
			 }
			 break;
		
		case EV_UpdateUserInfo :
			 GetPlayerInfo(playerInfo);

			 // â�� ���� �ִ� �߰��� ������ ���ϸ� â�� �ݴ´�.
			 if (currentUserLevel != playerInfo.nLevel)
			 {
				 if(IsShowWindow("AlchemySkillWnd"))
					 HideWindow("AlchemySkillWnd");
			 }
			 currentUserLevel = playerInfo.nLevel;

		     break;
		/*
		case EV_SkillTrainListWndHide:
			 
			 //ParseInt(param, "iType"	, iType);
		     Debug("��ųâ �ݴ´�>>>>>>>>>>>>>");
			
			 if(iType == SKILLTYPE_ALCHEMYSKILL) 
			 {
				if(IsShowWindow("AlchemySkillWnd"))
					 HideWindow("AlchemySkillWnd");
			 }
			 break;	*/	
	}
}

function buildTree()
{
	local int i;

	local bool bGetInfo;

	if (skillTrainInfoArray.Length >= totalSkillCount)
	{
		// ����
		quicksortchar(0, skillTrainInfoArray.Length - 1 , false);

		for(i = 0; i < skillTrainInfoArray.Length; i++)
		{
			createTreeNode(skillTrainInfoArray[i]);
			//Debug("clickedTreeNodeName" @ clickedTreeNodeName);
			//Debug("Left(clickedTreeNodeName, 15):" @  Left(clickedTreeNodeName, 15));

			switch(Left(clickedTreeNodeName, 15))
			{
				// ���ο� ��ų ���� Ʈ��
				case "root.SKILLLIST1" :  
										  
					 if (bGetInfo == false && treeNodeNameNewSkillArray.Length - 1 >= clickedTreeNodeIndex)
					 {
						// Debug("�� ��ų" @ clickedTreeNodeName);
								
						beforeTreeName = treeNodeNameNewSkillArray[clickedTreeNodeIndex];
						OnClickButton(treeNodeNameNewSkillArray[clickedTreeNodeIndex]);
						bGetInfo = true;
					 }
					 break;

				// ���� �� Ʈ��
				case "root.SKILLLIST2" : 
					 if (bGetInfo == false && treeNodeNameLevelUpArray.Length - 1 >= clickedTreeNodeIndex)
					 {
						 // Debug("������ ��ų" @ clickedTreeNodeName);
						 beforeTreeName = treeNodeNameLevelUpArray[clickedTreeNodeIndex];
						 OnClickButton(treeNodeNameLevelUpArray[clickedTreeNodeIndex]);
						 bGetInfo = true;
					 }
					 break;
			}
		}	
	}
}

// ��ưŬ�� �̺�Ʈ
function OnClickButton( string strID )
{
//	local int index;

	//Tree�� ����
	local Array<string> Result;
	local string treelist;
	local array<string> SkillIDLevel;
	
//	index = int(Right(strID, 1));	//��ư�� ���� �� ���ڸ� ������. 

	treelist = Left(strID, 4);
	
	// Debug("Ʈ�� Ŭ�� " @ strID);

	//Tree�� Ŭ�� ���� �ÿ��� 
	if( treelist == ROOTNAME )
	{			
		Split( strID, ".", Result );

		// Debug("Ʈ�� Ŭ�� Ȯ��" @ strID);

		if( Result.Length > 2)
		{
			if( Result[1] == LIST1 || Result[1] == LIST2 )// || Result[1] == LIST3 )
			{
				if( beforeTreeName != strID )
				{
					m_UITree.SetExpandedNode( beforeTreeName, false );
				}
				else
				{
					m_UITree.SetExpandedNode( beforeTreeName, true );
				}

				beforeTreeName = strID;
			}
			else
			{
				m_UITree.SetExpandedNode( strID, false );
			}

			if( Result[1] == LIST1 || Result[1] == LIST2 )
			{				
				Split( Result[2], ",", SkillIDLevel );				
				clickedTreeNodeName = strID;
				clickedTreeNodeIndex = int(SkillIDLevel[2]);

				//Debug("- Ŭ���ε���" @ SkillIDLevel[2]);
				//Debug("SkillIDLevel[0]" @ SkillIDLevel[0]);
				//Debug("SkillIDLevel[1]" @ SkillIDLevel[1]);
				
				// selectedRequestLevel = 

				//GetWindowHandle("AlchemySkillWnd.SkillTrain").GetWindowSize(nWndWidth, nWndHeight);

				//Debug("nWndWidth" @ nWndWidth);
				//Debug("nWndHeight" @ nWndHeight);
				//Debug("nWndHeight" @ GetWindowHandle("AlchemySkillWnd.SkillTrain").);

				// nScrollHeight = nScrollHeight - nWndHeight - BETWEEN_NAME_ITEM;	// ����� ���߱� ������ ��ũ�� ���̸� �������ش�. 
				
				//���ݼ� ���� ��ų������ 0�Դϴ�. ������ ���� ��ų �޴� ����� �����ؼ� ó�� �ϵ��� �� ��
				Debug("-------> RequestAcquireSkillInfo");
				RequestAcquireSkillInfo( int(SkillIDLevel[0]), int(SkillIDLevel[1]), 0,  SKILLTYPE_ALCHEMYSKILL );
			}
		}
	}
}

// Ʈ�� ����
function TreeClear()
{
	class'UIAPI_TREECTRL'.static.Clear( TREENAME );
}

function ShowSkillTree()
{	
	//Root ��� ����.
	util.TreeHandleInsertRootNode( m_UITree, ROOTNAME, "", 0, 4 );
	//+��ư �ִ� ���� ��� ����
	util.TreeHandleInsertExpandBtnNode( m_UITree, LIST1, ROOTNAME );
	//���� ��忡 �۾� ������ �߰�
	util.TreeHandleInsertTextNodeItem( m_UITree, ROOTNAME$"."$LIST1, GetSystemString(2370), 5, 0, util.ETreeItemTextType.COLOR_DEFAULT, true );
	
	//+��ư �ִ� ���� ��� ����
	util.TreeHandleInsertExpandBtnNode( m_UITree, LIST2, ROOTNAME );
	//���� ��忡 �۾� ������ �߰�
	util.TreeHandleInsertTextNodeItem( m_UITree, ROOTNAME$"."$LIST2, GetSystemString(2371), 5, 0, util.ETreeItemTextType.COLOR_DEFAULT, true );

	//+��ư �ִ� ���� ��� ����
	util.TreeHandleInsertExpandBtnNode( m_UITree, LIST3, ROOTNAME );
	//���� ��忡 �۾� ������ �߰�
	util.TreeHandleInsertTextNodeItem( m_UITree, ROOTNAME$"."$LIST3, GetSystemString(2372), 5, 0, util.ETreeItemTextType.COLOR_DEFAULT, true );

	m_UITree.SetExpandedNode( ROOTNAME$"."$LIST1, true );
	m_UITree.SetExpandedNode( ROOTNAME$"."$LIST2, true );
	m_UITree.SetExpandedNode( ROOTNAME$"."$LIST3, true );
}

// requestLevel�� ��� ����. 
function int getSkillRequestLevel(int nSkillID, int nSkillLevel)
{
	local int i, rValue;

	// ���� ���ٸ�.. -1
	rValue = -1;

	for (i = 0; i < skillTrainInfoArray.Length; i++)
	{
		if (skillTrainInfoArray[i].id == nSkillID  && skillTrainInfoArray[i].level == nSkillLevel)
		{
			rValue = skillTrainInfoArray[i].requiredLevel;
			break;
		}
	}

	return rValue;
}

//function AddSkillTrainListItem(string strIconName, string strName, int iID, int iLevel, int iSPConsume, string strEnchantName)
function AddSkillTrainListItem( string param )
{
	//��ų ���̵�.
	local int ID;
	//��ų ����
	local int Level;
	local int SubLevel;
	//�Ҹ� SP
	local INT64 SpConsume;
	//�䱸���� ( �÷��̾��� ���� ������ ���ؼ� ������ �������� �Ǵ��ϸ��)
	local int RequiredLevel;
	
	//�䱸���� ( �÷��̾��� ��� Ŭ���� ������ �� �Ͽ� �� ���� �������� �Ǵ�.)
	// local int RequiredDualLevel;

	local string strName;
	local string strIconName;

	local string strEnchantName;
	local SkillTrainInfo Info;

		
	

	ParseString(param, "strIconName", strIconName); 
	ParseString(param, "strName", strName);
	ParseString(param, "strEnchantName", strEnchantName);

	ParseInt(param   , "iID", ID);
	ParseInt(param   , "iLevel", Level);	
	ParseInt(param   , "iSubLevel", SubLevel);	

	
	
	ParseInt(param   , "iRequiredLevel", RequiredLevel);
	ParseInt64(param , "iSPConsume", SPConsume);
	
	if (ID <= 0) return;

	addCount++;
	Info.id = ID;
	Info.level = Level;
	Info.sublevel = SubLevel;
	Info.spConsume = SPConsume;
	Info.requiredLevel = RequiredLevel;
	
	Info.strName = strName;
	Info.strIconName = strIconName;
	Info.strEnchantName = strEnchantName;

	skillTrainInfoArray[skillTrainInfoArray.Length] = Info;
}

function createTreeNode(SkillTrainInfo info)
{
	local SkillInfo skillinfo;
	local string setTreeName;
	local string panelName;
	local int Level, ID, RequiredLevel;
	local string strName;	
	local string strIconName;


	//Player ����
	local UserInfo userinfo;

	//��ų ���̵�.
	local ItemID cID;

	local string strRetName;
	local CustomTooltip T;

	local bool isMaster;

	// Debug("skillTrainInfoArray"@ skillTrainInfoArray.Length);

	ID = info.ID;
	RequiredLevel = info.requiredLevel;

	cID = GetItemID(info.ID);
	//���ݼ� ��ų�� subLevel �� 0��
	GetSkillInfo( info.ID , info.Level, info.SubLevel, skillInfo );
	GetPlayerInfo( userinfo );

	strName = skillInfo.SkillName;
	strIconName = class'UIDATA_SKILL'.static.GetIconName( cID, info.level, info.SubLevel );
	panelName = skillInfo.IconPanel;
	Level = info.level;
	
	// Debug("param  ->" @ param);
	
	// Debug( "strName>>>>" $  strName );
	// Debug( "ID>>>>>" $ string( ID ) );
	// Debug( "Level>>>>>" $ string( Level ) );	
	// Debug( "SpConsume>>>>>" $ string( SpConsume ) );	
	//Debug( "RequiredLevel>>>>>" $ string( RequiredLevel ) );	
	//Debug( "RequiredDualLevel>>>>>" $ string( RequiredDualLevel ) );	
	//debug("class'UIDATA_SKILL'.static.SkillIsNewOrUp( cID )>>>" $ string( class'UIDATA_SKILL'.static.SkillIsNewOrUp( cID ) ) );
	

	//��������.
	util.setCustomTooltip( T );
	util.ToopTipMinWidth( 200 );
	
	MakeSkillToolTip( strName, cID, Level, info );	

	// 4���� ������? ��ų (�ֿ� ��ų�̶� ��������� ǥ�� �ϱ� ���ؼ�..)
	if (GetAlchemySkillGradeType(ID, Level) == 4)
		isMaster = true;
	else
		isMaster = false;

	// Debug("isMaster" @ isMaster);

	//if(RequiredDualLevel > 0 )
	//{
	//	currentMainLevel = mainLevel;	
	//	currentDualLevel = dualLevel;
	//}
	//else
	//{
	//	currentMainLevel = userinfo.nLevel;
	//	currentDualLevel = userinfo.nLevel;
	//}

	//userinfo.nLevel

	// if( RequiredLevel <= currentMainLevel && RequiredDualLevel <= currentDualLevel)
	if( RequiredLevel <= playerInfo.nLevel)	
	{
		//if( class'UIDATA_SKILL'.static.SkillIsNewOrUp( cID ) == 0 )
		// ������ 1�� ���ٸ� ���� ��� ��ų, �װ� �ƴϸ� ������ �� ��ų
		if( Level == 1 )
		{		
			// ���� ��� ��ų
			setTreeName = ROOTNAME$"."$LIST1;			
			strRetName = util.TreeInsertItemTooltipNode( TREENAME, ""$ ID $","$ Level  $","$ newSkillIndex, setTreeName, -7, 0, 38, 0, 30, 38, util.getCustomToolTip() );

			treeNodeNameNewSkillArray[newSkillIndex] = strRetName;
			//Debug("treeNodeNameNewSkillArray[newSkillIndex]->" @ treeNodeNameNewSkillArray[newSkillIndex]);
			newSkillIndex++;

			if( bDrawBgTree1 )
			{
				//Insert Node Item - ������ ���?
				util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_CH3.etc.textbackline", 262, 38, , , , ,14 );
			}
			else
			{
				util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_CT1.EmptyBtn", 262, 38 );
			}

			bDrawBgTree1 = !bDrawBgTree1;

			//********************************************************************************************************************************************************************

			//Insert Node Item - �����۽��� ���
			util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2 );
			//Insert Node Item - ������ ������
			util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, strIconName, 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1 );
			
			//-----------------------------------------------IconPanel--------------------------------------------------------------------------------------->
			if( skillInfo.IconPanel != "" )
				util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, panelName, 32, 32, -32, OFFSET_Y_ICON_TEXTURE - 1 );
			//<--------------------------------------------------------------------------------------------------------------------------------------------------

			//Operate Type(��Ƽ��/�нú�)
			//if( TypeCheck( skillinfo ) == true )
			//if( class'UIDATA_SKILL'.static.GetOperateType(cID, Level) == GetSystemString(311) )
			//{
				//Insert Node Item - ������ ������
				// util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Active", 32, 32, -33, OFFSET_Y_ICON_TEXTURE - 2 );
				
				if (isMaster)
				{
					util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, strName, 5, 5, util.ETreeItemTextType.YELLOW03, true );
				}
				else
				{
					//Insert Node Item - ������ �̸�
					util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, strName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true );
				}
				//Insert Node Item - "Lv"
				util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, GetSystemString(88), 46, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY, true, true );
				//Insert Node Item - ���� ��
				util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, string(Level), 2, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GOLD );

				////Insert Node Item - MP���� ������ ( �Ҹ��� )
				//util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_MP", 15, 15, 5, OFFSET_Y_SECONDLINE + 1 );
				////Insert Node Item - "�Ҹ��� ��"
				//util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, string(skillInfo.MpConsume), 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY );
				////Insert Node Item - �ð� ������ ( �����ð� )
				//util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_use", 15, 15, 5, OFFSET_Y_SECONDLINE + 1 );
				////Insert Node Item - "�����ð� ��"
				//util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, util.MakeTimeString( skillInfo.HitTime, skillInfo.CoolTime ), 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY );
				////Insert Node Item - �ð� ������ ( ����ð� )
				//util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_Reuse", 15, 15, 5, OFFSET_Y_SECONDLINE + 1 );
				////Insert Node Item - "����ð� ��"
				//util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, util.MakeTimeString( skillInfo.ReuseDelay ) , 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY );
			//}
			//else
			//{
			//	util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Passive", 32, 32, -33, OFFSET_Y_ICON_TEXTURE - 2 );

			//	//Insert Node Item - ������ �̸�
			//	util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, strName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true );
			//	//Insert Node Item - "Lv"
			//	util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, GetSystemString(88), 46, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY, true, true );
			//	//Insert Node Item - ���� ��
			//	util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, string(Level), 2, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GOLD );
			//}
		}
		else
		{	
			//if( RequiredLevel <= _currentMainLevel && RequiredDualLevel <= _currentDualLevel)
			if( RequiredLevel <= playerInfo.nLevel)
			{
				// ������ �� ��ų 
				setTreeName = ROOTNAME$"."$LIST2;
				strRetName = util.TreeInsertItemTooltipNode( TREENAME, ""$ ID $","$ Level $","$ levelUpSkillIndex , setTreeName, -7, 0, 38, 0, 32, 38, util.getCustomToolTip() );
				treeNodeNameLevelUpArray[levelUpSkillIndex] = strRetName;
				//Debug("treeNodeNameNewSkillArray[newSkillIndex]->" @ treeNodeNameLevelUpArray[levelUpSkillIndex]);

				levelUpSkillIndex++;

				if( bDrawBgTree2 )
				{
					//Insert Node Item - ������ ���?
					util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_CH3.etc.textbackline", 257, 38, , , , ,14 );
				}
				else
				{
					util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_CT1.EmptyBtn", 257, 38 );
				}

				bDrawBgTree2 = !bDrawBgTree2;

				//********************************************************************************************************************************************************************

				//Insert Node Item - �����۽��� ���
				util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2 );
				//Insert Node Item - ������ ������
				util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, strIconName, 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1 );

				//-----------------------------------------------IconPanel--------------------------------------------------------------------------------------->
				if( skillInfo.IconPanel != "" )
					util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, panelName, 32, 32, -32, OFFSET_Y_ICON_TEXTURE - 1 );
				//<--------------------------------------------------------------------------------------------------------------------------------------------------
				
				if (isMaster)
				{
					util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, strName, 5, 5, util.ETreeItemTextType.YELLOW03, true );
				}
				else
				{
					//Insert Node Item - ������ �̸�
					util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, strName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true );
				}
				//insert node item - "lv"
				util.treehandleinserttextnodeitem( m_uitree, strretname, getsystemstring(88), 46, offset_y_secondline, util.etreeitemtexttype.color_gray, true, true );
				//insert node item - ���� ��
				util.treehandleinserttextnodeitem( m_uitree, strretname, string(level), 2, offset_y_secondline, util.etreeitemtexttype.color_gold );

				////Operate Type(��Ƽ��/�нú�)
				////if( class'UIDATA_SKILL'.static.GetOperateType(cID, Level) == GetSystemString(311) )
				//if( TypeCheck( skillinfo ) == true )
				//{
				//	//Insert Node Item - ������ ������
				//	util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Active", 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1 );

				//	//Insert Node Item - ������ �̸�
				//	util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, strName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true );
				//	//Insert Node Item - "Lv"
				//	util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, GetSystemString(88), 46, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY, true, true );
				//	//Insert Node Item - ���� ��
				//	util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, string(Level), 2, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GOLD );
				//	////Insert Node Item - MP���� ������ ( �Ҹ��� )
				//	//util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_MP", 15, 15, 5, OFFSET_Y_SECONDLINE + 1 );
				//	////Insert Node Item - "�Ҹ��� ��"
				//	//util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, string(skillInfo.MpConsume), 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY );
				//	////Insert Node Item - �ð� ������ ( �����ð� )
				//	//util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_use", 15, 15, 5, OFFSET_Y_SECONDLINE + 1 );
				//	////Insert Node Item - "�����ð� ��"
				//	//util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, util.MakeTimeString( skillInfo.HitTime, skillInfo.CoolTime ), 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY );
				//	////Insert Node Item - �ð� ������ ( ����ð� )
				//	//util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_Reuse", 15, 15, 5, OFFSET_Y_SECONDLINE + 1 );
				//	////Insert Node Item - "����ð� ��"
				//	//util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, util.MakeTimeString( skillInfo.ReuseDelay ) , 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY );
				//}
				//else
				//{
				//	util.treehandleinserttexturenodeitem( m_uitree, strretname, "l2ui_ct1.skillwnd_df_listicon_passive", 32, 32, -34, offset_y_icon_texture - 1 );

				//	//insert node item - ������ �̸�
				//	util.treehandleinserttextnodeitem( m_uitree, strretname, strname, 5, 5, util.etreeitemtexttype.color_default, true );
				//	//insert node item - "lv"
				//	util.treehandleinserttextnodeitem( m_uitree, strretname, getsystemstring(88), 46, offset_y_secondline, util.etreeitemtexttype.color_gray, true, true );
				//	//insert node item - ���� ��
				//	util.treehandleinserttextnodeitem( m_uitree, strretname, string(level), 2, offset_y_secondline, util.etreeitemtexttype.color_gold );
				//}
			}
		}	
	}
	else
	{		
		setTreeName = ROOTNAME$"."$LIST3;
		strRetName = util.TreeInsertItemTooltipNode( TREENAME, ""$ ID $","$ Level, setTreeName, -7, 0, 38, 0, 32, 38, util.getCustomToolTip() );

		if( bDrawBgTree3 )
		{
			//Insert Node Item - ������ ���?
			util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_CH3.etc.textbackline", 257, 38, , , , ,14 );
		}
		else
		{
			util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_CT1.EmptyBtn", 257, 38 );
		}

		bDrawBgTree3 = !bDrawBgTree3;

		//********************************************************************************************************************************************************************

		//Insert Node Item - �����۽��� ���
		util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2 );
		//Insert Node Item - ������ ������
		util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, strIconName, 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1 );

		util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "l2ui_ct1.ItemWindow_IconDisable", 32, 32, -32, OFFSET_Y_ICON_TEXTURE - 1 );

		//Operate Type(��Ƽ��/�нú�)
		//if( class'UIDATA_SKILL'.static.GetOperateType(cID, Level) == GetSystemString(311) )
		if( TypeCheck( skillinfo ) == true )
		{
			//Insert Node Item - ������ ������
			util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Active", 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1 );		}
		else
		{
			//Insert Node Item - ������ ������
			util.TreeHandleInsertTextureNodeItem( m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Passive", 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1 );
		}

		//Insert Node Item - ������ �̸�
		util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, strName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true );

		//Insert Node Item - "ĳ���� Lv"
		util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, GetSystemString(2381) $ " : ", 46, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY, true, true );

		//Insert Node Item - �䱸 ���� ��
		util.TreeHandleInsertTextNodeItem( m_UITree, strRetName, string(RequiredLevel), 2, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_RED );
		//********************************************************************************************************************************************************************
	}


	//if (addCount >= totalSkillCount)
	//{
	//	if (bRefreshSelect == false)
	//	{
	//		switch(Left(clickedTreeNodeName, 15))
	//		{
	//			case "root.SKILLLIST1" :  
										  
	//									 if (treeNodeNameNewSkillArray.Length - 1 >= clickedTreeNodeIndex)
	//									 {
	//										for (i = 0; i < treeNodeNameNewSkillArray.Length; i++)
	//										{
	//											if (clickedTreeNodeName == treeNodeNameNewSkillArray[i])
	//											{
	//												Debug("�� ��ų" @ clickedTreeNodeName);
													
	//												beforeTreeName = treeNodeNameNewSkillArray[clickedTreeNodeIndex];
	//												OnClickButton(treeNodeNameNewSkillArray[clickedTreeNodeIndex]);
	//												break;
	//											}
	//										}
	//										bRefreshSelect = true;

	//									 }
	//									 break;

	//			case "root.SKILLLIST2" : 
	//									 if (treeNodeNameLevelUpArray.Length - 1 >= clickedTreeNodeIndex)
	//									 {
	//										for (i = 0; i < treeNodeNameLevelUpArray.Length; i++)
	//										{
	//											if (clickedTreeNodeName == treeNodeNameLevelUpArray[i])
	//											{
	//												Debug("������ ��ų" @ clickedTreeNodeName);
	//												 bRefreshSelect = true;
	//												 beforeTreeName = treeNodeNameLevelUpArray[clickedTreeNodeIndex];
	//												 OnClickButton(treeNodeNameLevelUpArray[clickedTreeNodeIndex]);
	//												 break;
	//											}
	//										}
	//									 }
	//									 break;
	//		}
	//	}
	//}

	/*
	switch(m_iType)
	{
	case ESTT_CLAN :
	case ESTT_SUB_CLAN:
		infNodeItem.t_strText = GetSystemString(1437)$" : ";
		break;
	//case ESTT_NORMAL :
	//case ESTT_FISHING :
	//case 4:
	default:
		infNodeItem.t_strText = GetSystemString(365)$" : ";
		break;
	}
	*/
}

function MakeSkillToolTip( string strName, ItemID ID, int Level, SkillTrainInfo pSkillTrainInfo )
{	
	local SkillInfo skillinfo;

	local int skillID;

	//�䱸���� ( �÷��̾��� ���� ������ ���ؼ� ������ �������� �Ǵ��ϸ��)
	local int RequiredLevel;
	//�䱸���� ( �÷��̾��� ��� Ŭ���� ������ �� �Ͽ� �� ���� �������� �Ǵ�.)
	// local int RequiredDualLevel;

	//��ų�� �ʿ��� ������ ���� 
	// local int RequiredItemTotalCnt;
	//ItemID (���� �� ������ŭ �ݺ�) 
	// local int requiredItemID;
	//Item �ʿ䰹�� (���� �� ������ŭ �ݺ�) 
	// local int requiredItemCnt;


	//��ų�� �ʿ��� ���� ��ų ���� 
	//local INT64 RequiredSkillCnt;
	//�ʿ� Skill�� ID (���� �� ������ŭ �ݺ�) 
	// local int requiredSkillID;
	//�ʿ� Skill�� level (���� �� ������ŭ �ݺ�) 
	// local int requiredSkillLevel;


	// local itemID requiredID;

	// local int i;

	//local string additionalName;
	local int nTmp;


	if ( !m_bShow ) return;

	//ParseInt(param, "iID", skillID);

	skillID = pSkillTrainInfo.id;
	RequiredLevel = pSkillTrainInfo.requiredLevel;
	
	GetSkillInfo( skillID , Level, 0, skillInfo );

	// ParseInt(param, "iRequiredLevel", RequiredLevel);
	// ParseInt(param, "RequiredDualLevel", RequiredDualLevel);

	// ParseInt(param, "RequiredItemTotalCnt", RequiredItemTotalCnt);
	// ParseINT64(param, "RequiredSkillCnt", RequiredSkillCnt);

	//additionalName = class'UIDATA_ITEM'.static.GetItemAdditionalName( ID );

	//������ �̸�
	// Debug("-----" @ strName);
	if (GetAlchemySkillGradeType(skillID, Level) == 4)
	{
		util.ToopTipInsertText( strName, true, false, util.ETooltipTextType.COLOR_YELLOW03 );	
		// Debug("isMaster" @ true @ "skillID" @ skillID @ "Level" @ Level);
	}
	else
	{
		util.ToopTipInsertText( strName, true, false, util.ETooltipTextType.COLOR_DEFAULT );	
		// Debug("isMaster" @ true @ "skillID" @ skillID @ "Level" @ Level);
	}
	
	//ex) " Lv "
	util.ToopTipInsertText( " " $ GetSystemString(88), true, false, util.ETooltipTextType.COLOR_GRAY );
	//��ų ����
	util.ToopTipInsertText( " " $ string(Level), true, false, util.ETooltipTextType.COLOR_GOLD );
	
	//��æƮ ����
	//util.ToopTipInsertText( additionalName, true, false, util.ETooltipTextType.COLOR_GOLD, 5 );

	//Operate Type(��Ƽ��/�нú�)
	util.ToopTipInsertText( class'UIDATA_SKILL'.static.GetOperateType( ID, Level, 0 ), true, true, util.ETooltipTextType.COLOR_GOLD, 0, 6 );

	util.TooltipInsertItemBlank( 6 );

	//�Ҹ�HP
	nTmp = class'UIDATA_SKILL'.static.GetHpConsume( ID, Level, 0 );
	if (nTmp>0)
	{
		util.TwoWordCombineColon( GetSystemString(1195), string( nTmp ), util.ETooltipTextType.COLOR_GRAY, util.ETooltipTextType.COLOR_GOLD, true );
	}

	//�Ҹ�MP
	nTmp = class'UIDATA_SKILL'.static.GetMpConsume( ID, Level, 0 );
	if (nTmp>0)
	{
		util.TwoWordCombineColon( GetSystemString(320), string( nTmp ), util.ETooltipTextType.COLOR_GRAY, util.ETooltipTextType.COLOR_GOLD, true );
	}

	////��ȿ�Ÿ�
	//nTmp = class'UIDATA_SKILL'.static.GetCastRange( ID, Level );
	//if (nTmp>=0)
	//{
	//	util.TwoWordCombineColon( GetSystemString(321), string( nTmp ), util.ETooltipTextType.COLOR_GRAY, util.ETooltipTextType.COLOR_GOLD, true );
	//}
	
	////�����ð� ��
	//if( class'UIDATA_SKILL'.static.GetOperateType( ID, Level ) == GetSystemString(311) )
	//{
	//	util.TwoWordCombineColon( GetSystemString(2377), util.MakeTimeString( int(skillInfo.HitTime ), int(skillInfo.CoolTime ) ), util.ETooltipTextType.COLOR_GRAY, util.ETooltipTextType.COLOR_GOLD, true );
	//}

	////����ð�
	//if( class'UIDATA_SKILL'.static.GetOperateType( ID, Level ) == GetSystemString(311) )
	//{
	//	util.TwoWordCombineColon( GetSystemString(2378), util.MakeTimeString( int(skillInfo.ReuseDelay ) ), util.ETooltipTextType.COLOR_GRAY, util.ETooltipTextType.COLOR_GOLD, true );
	//}

	//��ų ����
	util.ToopTipInsertText( class'UIDATA_SKILL'.static.GetDescription( ID, Level, 0 ), false, true, util.ETooltipTextType.COLOR_GRAY, 0, 6 );

	util.TooltipInsertItemBlank( 6 );
	util.TooltipInsertItemLine();
	util.TooltipInsertItemBlank( 3 );

	//<���� ����>
	util.ToopTipInsertText( "<"$GetSystemString(2375)$">", true, true );
	util.TwoWordCombineColon( GetSystemString(2381), string(RequiredLevel), util.ETooltipTextType.COLOR_GRAY, util.ETooltipTextType.COLOR_GOLD, true );
}

/**
 * ��ų Ÿ�� ����
 **/ 
function bool TypeCheck( SkillInfo info )
{
	return isActiveSkill(Info.IconType);
}

///**
// * �ܺο��� ��ų �н��� ��ﶧ �� �Ѵ�.
// **/
//function externalCallLearnSkill()
//{
//	// ������ ����
//	m_wndTop.ShowWindow();

//	// ��ų ���� ������ �̵�
//	GetTabHandle("AlchemySkillWnd.TabCtrl").SetTopOrder(2, false);

//	// �� ���� ��� ó�� 
//	onClickButton("TabCtrl2");	
//}

 /**
  *  Ʈ�� �ݱ�
  */
function closeTreeNode()
{
	m_UITree.SetExpandedNode( beforeTreeName, false );
	beforeTreeName = "";
}

/**
 * ����, level �������� 
 * @example quicksortchar(0, productInfoArray.Length - 1 , true);
 */
function quickSortChar(int left, int right, bool desc )
{
	local int q;

	if( right - left == 0 )
	{
		return;
	}
	else if( left < right )
	{
		q = partitionChar(left,right, desc);
		quickSortChar(left, q - 1, desc);
		quickSortChar( q + 1, right, desc);
	}
}

/** ����, partitionChar */
function int partitionChar(int low, int high, bool desc )
{
	local string pivot;
	local string temp;
	local int i;
	local int j;
	//productInfoArray[low].sortString;
		
	pivot = Caps(skillTrainInfoArray[low].level);
	j = low;

	for(i = low + 1 ; i <= high ; i++)
	{
		temp = Caps(skillTrainInfoArray[i].level);
		if( desc )
		{
			if( temp > pivot )
			{
				j++;
				swap(i,j);
			}
		}
		else
		{
			if( temp < pivot )
			{
				j++;
				swap(i,j);
			}
		}		
	}	
	swap(low,j);
	return j;
}

/** ����, swap */
function swap(int i, int j)
{
	local SkillTrainInfo info;
	info = skillTrainInfoArray[i];
	skillTrainInfoArray[i] = skillTrainInfoArray[j];
	skillTrainInfoArray[j] = info;
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

defaultproperties
{
     m_WindowName="AlchemySkillWnd"
     treeName="AlchemySkillWnd.SkillTrainTree"
     ROOTNAME="root"
     LIST1="SKILLLIST1"
     LIST2="SKILLLIST2"
     LIST3="SKILLLIST3"
}
