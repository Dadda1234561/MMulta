class ArtifactItemListWnd extends UICommonAPI;

var WindowHandle                    Me;
var	String				            m_WindowName;

var WindowHandle                    ArtifactItemListDisable_Wnd;

var	ButtonHandle		m_CloseButton;
//var L2Util l2UtilScript;

// ���� ��ų Ʈ��
var TreeHandle mainTree;
const ROOTNAME = "root";
var bool bListLoaded;

// ���� ��ų Ʈ��
var TreeHandle subTree;

var string expenedNode;

var TextBoxHandle ArtifactNameText;
var TextureHandle ArtifactItemListWnd_InfoItem;
//var ItemWindowHandle ArtifactItemListWnd_InfoItem;

const ARTIFACTTYE_NORMAL = 4398046511104;
const ARTIFACTTYE_TYPE1 = 18014398509481984;
const ARTIFACTTYE_TYPE2 = 144115188075855872;
const ARTIFACTTYE_TYPE3 = 1152921504606846976;

// Ȯ�� ���� ���� ������.
var bool isLoaded;

struct ArtifactSkillInfoStruct
{
	var ItemID ID;
	var int SkillID;
	var int Level;
	//var int SubLevel;
	var String Name;
	var String IconName;
	var String IconPanel;
	var String Description;
	// Ư�� 1 ~ 3 , �Ϲ�
	var int ArtifactType;
	var int ArtifactPage;
	var int64 SlotBitType;	
	var int MaxSkillLevel;
	var int64 itemNum;
};




//var array<ArtifactSkillInfoStruct> artifactSkillInfos;



/*********************************************************************************************
 * On
 * *******************************************************************************************/
//function OnRegisterEvent()
//{	
//	//RegisterEvent(EV_InventoryOpenWindow);
//	//RegisterEvent(EV_InventoryHideWindow);	
//	//RegisterEvent(EV_InventoryToggleWindow);
//	//RegisterEvent(EV_ChangeCharacterPawn );	
//	//RegisterEvent(EV_SkillListStart );	
//	//RegisterEvent(EV_SkillList );	
//	//RegisterEvent(EV_SkillListEnd );	
//}

function OnLoad()
{	
	m_WindowName = getCurrentWindowName(String(self));
	InitHandleCOD();	
	//l2UtilScript = L2Util(GetScript("L2Util"));

	SetClosingOnESC();
}

//function OnEvent(int Event_ID, string param)
//{	
//	switch( Event_ID )
//	{	
//		default:
//			break;
//	};
//}

function OnShow()
{
	//MakeItemList();	
	StartTreeWnd();
	isLoaded = true;
	//Debug( "onShow");
}

//function OnHide()
//{	
//}

function OnClickButton ( string StrID )
{
	switch ( StrID ) 
	{
		//case "CloseButton" :
		//	Me.HideWindow();
		//break;
		default : 
			//Debug ( "OnClickedButton" @ StrID ) ;
			ClickTreeNode( StrID );			
			break;
	}
}

/********************************************************************************************
 * �ʱ�ȭ �� �⺻ handle ����
 * ******************************************************************************************/
function InitHandleCOD()
{
	Me=GetWindowHandle(m_WindowName);
	
	//m_CloseButton = GetButtonHandle(m_WindowName $ ".CloseButton");
	mainTree = GetTreeHandle( m_WindowName$".MainTree") ;	
	subTree = GetTreeHandle( m_WindowName$".subTree") ;	

	ArtifactNameText = GetTextBoxHandle ( m_WindowName$ ".ArtifactNameText" ) ;
	ArtifactItemListWnd_InfoItem = GetTextureHandle ( m_WindowName$ ".ArtifactItemListWnd_InfoItem" ) ;
	//ArtifactItemListWnd_InfoItem = GetItemWindowHandle ( m_WindowName$ ".ArtifactItemListWnd_InfoItem" ) ;

	ArtifactItemListDisable_Wnd = GetWindowHandle ( m_WindowName$".ArtifactItemListDisable_Wnd") ;
}


/********************************************************************************************
 * ����ŸƮ ó�� 
 * ******************************************************************************************/
//function HandleRestart()
//{
//	Me.HideWindow() ;	
//}


/********************************************************************************************
 * ��Ƽ��Ʈ ����Ʈ ���� Ʈ�� 
 * ******************************************************************************************/
//�ʱ�ȭ
function Clear()
{	
	ArtifactItemListDisable_Wnd.ShowWindow();
	mainTree.Clear();
	subTree.Clear();
	ArtifactItemListWnd_InfoItem.SetTexture( "" ) ;
	ArtifactNameText.SetText( "" ) ;

	//class'UIAPI_TREECTRL'.static.Clear("RecipeTreeWnd.MainTree");
}

//Start Function
function StartTreeWnd( )
{
	Clear();
	//if ( !bListLoaded ) 
	MakeItemList();
	//SetArtifactEffectInfo(RecipeID, m_AddSuccRate, m_CreateCritical);
}

function MakeItemList () 
{
	//local array<ItemInfo> ArtifactItemList;
	local array< ArtifactUIData>  ArtifactUIDataList;
	local array<ArtifactSkillInfoStruct> artifactSkillInfoList;
	local ArtifactSkillInfoStruct artifactSkillInfo;
	local int i;
	//local itemInfo tmpItemINfo;
	//bListLoaded = true;

	MakeRootNodes();
	
	class'UIDATA_ARTIFACT'.static.GetAllArtifactData( ArtifactUIDataList ) ;

	for ( i = 0 ; i < ArtifactUIDataList.Length ; i ++ ) 
	{	
		artifactSkillInfo = ArtifactUIDataToArtifactSkillInfoStruct( ArtifactUIDataList[i] );			
		artifactSkillInfoList[artifactSkillInfoList.Length] = artifactSkillInfo;		
	}

	artifactSkillInfoList = SortByItemHad( artifactSkillInfoList ) ;
	
	MakeNodes( artifactSkillInfoList );
}


function array< ArtifactSkillInfoStruct> SortByItemHad ( array< ArtifactSkillInfoStruct>  ArtifactUIDataList ) 
{
	local int i  ;
	local array< ArtifactSkillInfoStruct>  tmpArtifactUIDataList;

	for ( i = 0 ; i < ArtifactUIDataList.Length ; i ++ )
	{
		if ( ArtifactUIDataList[i].itemNum > 0 ) 
			tmpArtifactUIDataList[tmpArtifactUIDataList.Length] = ArtifactUIDataList[i];
	}

	for ( i = 0 ; i < ArtifactUIDataList.Length ; i ++ )
	{
		if ( ArtifactUIDataList[i].itemNum == 0 ) 
			tmpArtifactUIDataList[tmpArtifactUIDataList.Length] = ArtifactUIDataList[i];
	}

	return tmpArtifactUIDataList; 
}


// ��Ƽ��Ʈ ������ ������ ��Ƽ��Ʈ ��ų ������ 
function ArtifactSkillInfoStruct ArtifactUIDataToArtifactSkillInfoStruct(ArtifactUIData artifactData)
{
	local ArtifactSkillInfoStruct artifactSkillInfo;
	//local ArtifactUIData artifactData;
	local SkillInfo skillInfo; 	
	local ItemInfo info;

	local InventoryWnd InventoryWndScript;	

	InventoryWndScript = InventoryWnd( GetScript( "InventoryWnd") );

	//Debug ( "HandleArtifactItemList2SkillInfo" @ info.Name @ info.slotbitType );
	info = GetItemInfoByClassID ( artifactData.ArtifactItemID );
	//class'UIDATA_ITEM'.static.GetItemInfo(id, info);		

	// �׽�Ʈ�� ���� �������� �־� �ش�. 
//	info.SlotBitType = ArtifactSlotBitTypeByType( rand(4) ) ;

	//Debug( " slotBitType �� 0���� ��� �� ���� ���� �� " @ info.Name @ artifactSkillInfo.SlotBitType );
	
	//class'UIDATA_ARTIFACT'.static.FindArtifactData( info.ID.ClassID, artifactData ) ;

	//Debug(  "HandleArtifactItemList2SkillInfo" @ artifactData.EnchantSkillID @ info.Enchanted @  ) ;
	// ��ų ������ �޾ƾ� �ϰ�����.	

	GetSkillInfo( artifactData.EnchantSkillID , info.Enchanted + 1 , 0, skillInfo ) ;
	//Debug ( "HandleArtifactItemList2SkillInfo" @ skillInfo.SkillName @ artifactData.MaxSkillLevel );// skillInfo.SkillID @ skillInfo.SkillLevel ) ;
	artifactSkillInfo.Name = skillInfo.SkillName;
	artifactSkillInfo.Level = skillInfo.SkillLevel ;
	artifactSkillInfo.IconName = skillInfo.TexName;;	
	artifactSkillInfo.IconPanel = skillInfo.IconPanel;
	artifactSkillInfo.Description = skillInfo.SkillDesc;
	artifactSkillInfo.SkillID = skillInfo.SkillID;
	artifactSkillInfo.ID = info.ID;
	artifactSkillInfo.SlotBitType = info.SlotBitType;
	artifactSkillInfo.MaxSkillLevel = artifactData.MaxSkillLevel;
	artifactSkillInfo.itemNum = InventoryWndScript.getItemCountByClassID( info.ID.classID );

	return artifactSkillInfo;	
}


// Ÿ�Ժ� ��Ʈ ��� ���� 
function MakeRootNodes()
{
	local XMLTreeNodeInfo	infNode;		
	infNode.strName = ROOTNAME;

	// root�� �켱 �ϳ� ���� �Ѵ�. 
	mainTree.InsertNode( ROOTNAME, infNode );

	// + ��ư�� �� Ȯ�� ��带 �߰� �Ѵ�. 
	
	InsertExpandNode ( GetSystemString ( 3891 ), String ( ARTIFACTTYE_TYPE1 ) ) ;	
	InsertExpandNode ( GetSystemString ( 3892 ), String ( ARTIFACTTYE_TYPE2 ) ) ;
	InsertExpandNode ( GetSystemString ( 3893 ), String ( ARTIFACTTYE_TYPE3 ) ) ;
	InsertExpandNode ( GetSystemString ( 3894 ), String ( ARTIFACTTYE_NORMAL ) ) ;
}

// ù ��° ���� ��� ����
function string InsertExpandNode ( string title, string slotBitType ) 
{
	local string NodeName ;
	local Color nameColor;
	//Debug ( "InsertExpandNode" @ title @ slotBitType ) ;
	nameColor.R = 220;
	nameColor.G = 220;
	nameColor.B = 220;
	nameColor.A = 255;		
	NodeName =  ROOTNAME$"."$slotBitType;
	
	getInstanceL2Util().TreeHandleInsertExpandBtnNode( mainTree, slotBitType , ROOTNAME,,,,,,,,7 ) ;	
	TreeHandleInsertTextNodeItem ( mainTree, NodeName, title , 2 , 1, nameColor, true ) ;

	//if ( mainTree.IsExpandedNode ( NodeName )  )
	//{
	//	mainTree.SetExpandedNode( NodeName, true ) ;
	//}
	return NodeName;
}


function MakeNodes ( array<ArtifactSkillInfoStruct> artifactSkillInfos  ) 
{
	local int i, nameOffsetY, enchantOffsetX  ;
	//local int64 itemCount;
	local string strNodeName, ellipsedString;	
	local int artifactType ;
	local Color enchantedColor, nameColor, cantEnchantColor, numColor, nameColorDisabled ;
	local array<int> nodeNums;
	local bool isFirstNode, canEnchant, haveItem;	
	

	enchantedColor.R = 170;
	enchantedColor.G = 108;
	enchantedColor.B = 231;
	enchantedColor.A = 255;

	nameColor.R = 221;
	nameColor.G = 221;
	nameColor.B = 221;
	nameColor.A = 255;

	nameColorDisabled.R = 182;
	nameColorDisabled.G = 182;
	nameColorDisabled.B = 182;
	nameColorDisabled.A = 255;

	cantEnchantColor.R = 166;
	cantEnchantColor.G = 47;
	cantEnchantColor.B = 49;
	cantEnchantColor.A = 255;

	numColor.R = 255;
	numColor.G = 221;
	numColor.B = 102;
	numColor.A = 255;

	nodeNums.Length = 4;

	// Debug ( "MakeNodes" @ artifactSkillInfos.Length ) ;

	for ( i = 0 ; i < artifactSkillInfos.Length ; i ++ ) 
	{
		artifactType = artifactTypeBySlotBitType( artifactSkillInfos[i].SlotBitType ) ;
		
//		Debug ( i @ "/" @ artifactType  @ "/" @ artifactSkillInfos[i].SlotBitType   ) ; 
		if ( artifactType == -1 ) continue;
		
		isFirstNode = nodeNums[artifactType] == 0 ;

		// �̸� �Է�
		ellipsedString = GetEllipsisString( artifactSkillInfos[i].Name , 285 ) ;
		
		if ( ellipsedString != artifactSkillInfos[i].Name ) 
			strNodeName = makeNode( String(artifactSkillInfos[i].ID.classID )  , ROOTNAME $ "." $ artifactSkillInfos[i].SlotBitType, isFirstNode, artifactSkillInfos[i].Name  );		
		else 
			strNodeName = makeNode( String(artifactSkillInfos[i].ID.classID )  , ROOTNAME $ "." $ artifactSkillInfos[i].SlotBitType, isFirstNode, ""  );		
		
//		Debug ("MakeNodes" @ i @"/" @ nodeNums[artifactType] % 2  @ "/" @  artifactType ) ;

		if ( isFirstNode ) TreeInsertBlankNodeItem ( mainTree, strNodeName, 5 );

		if ( nodeNums[artifactType] % 2 == 0 ) 
			getInstanceL2Util().TreeHandleInsertTextureNodeItem( mainTree, strNodeName , "L2UI_CT1.EmptyBtn", 333, 38);
		else 
			getInstanceL2Util().TreeHandleInsertTextureNodeItem( mainTree, strNodeName , "L2UI_CH3.etc.textbackline", 333, 38, , , , , 14 );	

		getInstanceL2Util().TreeHandleInsertTextureNodeItem( mainTree, strNodeName, "L2UI_CT1.ItemWindow.ItemWindow_DF_SlotBox_Default", 36, 36, -333, 1 );
		getInstanceL2Util().TreeHandleInsertTextureNodeItem( mainTree, strNodeName, artifactSkillInfos[i].IconName, 32, 32, -34, 2 );
		getInstanceL2Util().TreeHandleInsertTextureNodeItem( mainTree, strNodeName, artifactSkillInfos[i].IconPanel, 32, 32, -32, 2 );	
		
//		itemCount = InventoryWndScript.getItemCountByClassID( artifactSkillInfos[i].ID.classID ) ;

		// Debug ("----- itemCount ----- " @  itemCount ) ;		
		

		canEnchant = artifactSkillInfos[i].MaxSkillLevel > 1;
		haveItem = ( artifactSkillInfos[i].itemNum > 0 ) ;

		if ( !haveItem ) 
		{
			getInstanceL2Util().TreeHandleInsertTextureNodeItem( mainTree, strNodeName, "L2UI_CT1.ItemWindow.ItemWindow_IconDisable", 32, 32, -32, 2 );
			nameColor = nameColorDisabled;
			enchantOffsetX = 37;
		}
		else 
			enchantOffsetX = 4;

		
		//enchantOffsetX;
		// --  �� �� ¥�� -- //
		if ( canEnchant && !haveItem ) 
			nameOffsetY = 13;	
		// -- �� �� ¥�� -- //
		else 
			nameOffsetY = 4;
		
		TreeHandleInsertTextNodeItem ( mainTree, strNodeName, ellipsedString , 4, nameOffsetY, nameColor, false  ) ;

		
		// ������ ����
		if ( haveItem ) 				
			TreeHandleInsertTextNodeItem ( mainTree, strNodeName, "x" $artifactSkillInfos[i].itemNum, 38, -17, numColor, true, true ) ;				

		// ��þƮ ����
		if ( !canEnchant ) 
			TreeHandleInsertTextNodeItem ( mainTree, strNodeName, "(" $GetSystemString ( 3896 ) $ ")" , enchantOffsetX, -17, cantEnchantColor, true, !haveItem ) ;

		nodeNums[artifactType]++;

		if ( MainTree.IsExpandedNode ( strNodeName ) ) 
		{
			SetSubDetailInfo( artifactSkillInfos[i].ID.classID ) ;
			MakeSubTree ( artifactSkillInfos[i].ID.classID ) ;
		}

	}	
	// ù �ε��̶�� ���� Ȯ���ض�.
	if ( !isLoaded ) ExpandNodes( ) ;
}

// �� ��° ���� ��� ���� ������ ���� �ϴ�.
function string makeNode  ( string NodeName, string ParentName, bool isFirstNode, optional string tooltipString ) 
{
	local XMLTreeNodeInfo		infNode;	
	local XMLTreeNodeInfo		infNodeClear;	
	
	infNode = infNodeClear ;

	infNode.bShowButton = 0;	
	infNode.strName = NodeName ;	
	infNode.bFollowCursor = true ;	
	
	//Expand�Ǿ������� BackTexture����
	//��Ʈ��ġ�� �׸��� ������ ExpandedWidth�� ����. ������ -2��ŭ ����� �׸���.		
	infNode.nOffsetX = 2;	
	infNode.nTexExpandedOffSetX = 0 ;
	if ( isFirstNode ) 
		infNode.nTexExpandedOffSetY = 5 ;
	else 
		infNode.nTexExpandedOffSetY = 0 ;
	infNode.nTexExpandedHeight = 36 ;	
	infNode.nTexExpandedRightWidth = 0 ;
	infNode.nTexExpandedLeftUWidth = 1 ;
	infNode.nTexExpandedLeftUHeight = 36 ;

	infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";

	infNode.tooltip = MakeTooltipSimpleText ( tooltipString );
	
	return mainTree.InsertNode (ParentName, infNode);
	// return class'UIAPI_TREECTRL'.static.InsertNode(m_WindowName$".TabBounsView.MainTree", ParentName, infNode);
}


// ���� �� �⺻ Ȯ�� 
function ExpandNodes( ) 
{	
	MainTree.SetExpandedNode( ROOTNAME$"."$ARTIFACTTYE_NORMAL, true );
	MainTree.SetExpandedNode( ROOTNAME$"."$ARTIFACTTYE_TYPE1, true );
	MainTree.SetExpandedNode( ROOTNAME$"."$ARTIFACTTYE_TYPE2, true );
	MainTree.SetExpandedNode( ROOTNAME$"."$ARTIFACTTYE_TYPE3, true );
}


function TreeInsertBlankNodeItem( TreeHandle tree,  string NodeName, int gabY )
{
	//Ʈ�� �������� ����
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_BLANK;	
	infNodeItem.b_nHeight = gabY;
	tree.InsertNodeItem(NodeName, infNodeItem );
	//class'UIAPI_TREECTRL'.static.InsertNodeItem( TreeName, NodeName, infNodeItem );
}


// �÷� ���� ���� �Է��ؾ� �ϱ� ������
function TreeHandleInsertTextNodeItem(TreeHandle tree,  string NodeName, string ItemName, int offSetX, int offSetY, Color c, bool OneLine, optional bool bLineBreak  )
{
	//Ʈ�� �������� ����
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.nOffSetX = offSetX;
	infNodeItem.nOffSetY = offSetY;	
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.t_bDrawOneLine = OneLine;
	
	//infNodeItem.nReserved = 0 ;
	
	infNodeItem.t_color.R = c.R;
	infNodeItem.t_color.G = c.G;
	infNodeItem.t_color.B = c.B;
	infNodeItem.t_color.A = c.A;	

	tree.InsertNodeItem(NodeName, infNodeItem);
}

/***************************************************************************************************************
 * Ʈ�� Ŭ���Ҷ�
 * *************************************************************************************************************/
function ClickTreeNode( string Name )
{
	//Tree�� ����
	local Array<string> Result ;//, bodyInfo;
	//Debug( "clickTreeList > " @ Name @ nodeNameByID ( 23 ) == Name  @ expenedNode == Name);	
	
	// ���� ��� Ŭ�� �� ó������ ���ƶ�.
	if ( expenedNode == Name  ) 
	{
		MainTree.SetExpandedNode( expenedNode, true );
		return;
	}

	// ������ ��尡 �ƴϸ� ���� ���� ���ƶ�.
	Split( Name, ".", Result );

	//Debug ("v��� Ŭ����" @  Name @ Result.Length ) ;
	if ( Result.Length < 3 )  return;
	
	MainTree.SetFocus();
	
	// ������ Ȯ���ߴ� ��带 ����( ���� ���� ) 
	if ( expenedNode != "" ) MainTree.SetExpandedNode( expenedNode, false );
	expenedNode = Name;		

	SetSubDetailInfo( int ( Result[2] ) );
	MakeSubTree ( int(  Result[2] )) ;
	// Ʈ���� ��Ŀ���� �ٴ� �� ����
}

function SetSubDetailInfo ( int cID ) 
{
	local ItemInfo info;
	// local string ellipsedString ;

	info = GetItemInfoByClassID ( cID );
	
	// ellipsedString = GetEllipsisString ( info.Name  , 235 );
	ArtifactNameText.setText( info.Name ); 


	//ArtifactNameText.SetTooltipType("Text");
	// GetTextBoxHandle("RecipeTreeWnd.txtName").SetTooltipText(strTmp);
	//if ( ellipsedString != ellipsedString ) 
	//	ArtifactNameText.SetTooltipText (info.Name ) ;

	//else ArtifactNameText.SetTooltipText ( "" ) ; 

	ArtifactItemListWnd_InfoItem.SetTexture ( info.IconName ) ;

	ArtifactItemListDisable_Wnd.HideWindow();
}

function MakeSubTree ( int cID )  
{
	local ArtifactUIData artifactData;
	local int i, j, itemNum ;	
	local SkillInfo skillinfo;
	local string strNodeName;

	local Color nameColor, enchantedColor, numColor;

	local array<ItemInfo> artifactItemArray, artifactItemArraySameClassID;
	

	local InventoryWnd InventoryWndScript;	
	InventoryWndScript = InventoryWnd( GetScript( "InventoryWnd") );
	
	nameColor.R = 220;
	nameColor.G = 220;
	nameColor.B = 220;
	nameColor.A = 255;		

	enchantedColor.R = 170;
	enchantedColor.G = 108;
	enchantedColor.B = 231;
	enchantedColor.A = 255;

	numColor.R = 255;
	numColor.G = 221;
	numColor.B = 102;
	numColor.A = 255;


	subTree.Clear ();

	// ��Ʈ�� �ϳ� �����.
	makeSubRootNode();
	
	class'UIDATA_ARTIFACT'.static.FindArtifactData ( cID, artifactData ) ;
	
	// classID �� ���� �� �� ���� ��.
	// �κ����� ���� ����, 
	class'UIDATA_INVENTORY'.static.GetAllArtifactItem(artifactItemArray);
	for ( i = 0 ; i < artifactItemArray.Length ; i ++ ) 
		if ( artifactItemArray[i].ID.classID == cID ) 
			artifactItemArraySameClassID[artifactItemArraySameClassID.Length] = artifactItemArray[i] ;

	// ��񿡼� ���� ��
	artifactItemArray = InventoryWndScript.GetArtifactEquipedList(0);
	for ( i = 0 ; i < artifactItemArray.Length ; i ++ ) 
		if ( artifactItemArray[i].ID.classID == cID ) 
			artifactItemArraySameClassID[artifactItemArraySameClassID.Length] = artifactItemArray[i] ;

	artifactItemArray = InventoryWndScript.GetArtifactEquipedList(1);
	for ( i = 0 ; i < artifactItemArray.Length ; i ++ ) 
		if ( artifactItemArray[i].ID.classID == cID ) 
			artifactItemArraySameClassID[artifactItemArraySameClassID.Length] = artifactItemArray[i] ;

	artifactItemArray = InventoryWndScript.GetArtifactEquipedList(2);
	for ( i = 0 ; i < artifactItemArray.Length ; i ++ ) 
		if ( artifactItemArray[i].ID.classID == cID ) 
			artifactItemArraySameClassID[artifactItemArraySameClassID.Length] = artifactItemArray[i] ;

	


	for ( i = 0 ; i < artifactData.MaxSkillLevel  ; i ++ ) 
	{
		itemNum = 0 ;

		GetSkillInfo( artifactData.EnchantSkillID , i + 1 , 0, skillInfo ) ;

		//Debug ( "strNodeName" @ skillInfo.skillname @ artifactData.MaxSkillLevel  );
//		Debug ( "MakeSubTree" @ skillInfo.Skilldesc ) ;	

		strNodeName = MakeSubNode ( String(cID), ROOTNAME ) ;

		if ( i != 0 ) TreeInsertBlankNodeItem( subTree, strNodeName, 16 ) ;
	
		// ��þ ��ġ
		TreeHandleInsertTextNodeItem ( subTree, strNodeName, "+" $ i , 0, 0, enchantedColor, true ) ;		

		for ( j = 0 ; j < artifactItemArraySameClassID.Length ; j ++ ) 
				if ( artifactItemArraySameClassID[j].enchanted == i ) 
					itemNum ++ ;

		if ( itemNum > 0 ) 
		{
			// �������� �ִ� ��� x88 �� ���� �� �۰�..
			TreeHandleInsertTextNodeItem ( subTree, strNodeName, GetEllipsisString ( skillInfo.SkillName, 235 ) , 4, 0, nameColor, true ) ;
			TreeHandleInsertTextNodeItem ( subTree, strNodeName, "x" $ itemNum , 4, 0, numColor, true ) ;
		}
		else TreeHandleInsertTextNodeItem ( subTree, strNodeName, GetEllipsisString ( skillInfo.SkillName, 250 ) , 4, 0, nameColor, true ) ; 

		// ������ ����
		getInstanceL2Util().TreeHandleInsertTextNodeItem( subTree, strNodeName, GetEllipsisString ( skillInfo.skillDesc, 250 ) , 22, 0, COLOR_GOLD, true, true );
	}
}

// �� ��° ���� ��� ���� ������ ���� �ϴ�.
function makeSubRootNode  () 
{
	local XMLTreeNodeInfo	infNode;	
	
	infNode.strName = ROOTNAME;
	
	subTree.InsertNode( ROOTNAME, infNode );
}

// ���� �Է�
function string MakeSubNode( string NodeName, string ParentName )
{
	//Ʈ�� ��� ����
	local XMLTreeNodeInfo infNode;

	infNode.strName = NodeName;

	infNode.bShowButton = 0;		

	subTree.InsertNode( ParentName, infNode  );


	return ROOTNAME$"."$NodeName ;
}



/********************************************************************************************
 * etc, util
 * ******************************************************************************************/

function int ArtifactTypeBySlotBitType ( int64 slotBitType ) 
{	
	switch ( slotBitType )
	{
		case INT64("18014398509481984") : return 0; 
		case INT64("144115188075855870") : return 1;
		case INT64("1152921504606847000") : return 2; 
		case INT64("4398046511104") : return 3; 
	}
	return -1;
}

function int64 ArtifactSlotBitTypeByType ( int type ) 
{
	//Debug ( "ArtifactSlotBitTypeByType" @ type ) ;
	switch ( type )
	{
		case 0 : return INT64("18014398509481984") ;
		case 1 : return INT64("144115188075855870") ;
		case 2 : return INT64("1152921504606847000") ;
		case 3 : return INT64("4398046511104") ;
	}
	return -1;
}

// ������ ... ó��
function String GetEllipsisString ( string str, int maxWidth  ) 
{
	local string fixedString;
	local int nWidth, nHeight, textWidth ;	
	
	textWidth = maxWidth;
	//str = str @ "123456789";
	GetTextSizeDefault( str $ "..."  , nWidth, nHeight);
	if ( nWidth < textWidth ) return Str;	
	
	fixedString = DivideStringWithWidth(str, textWidth);	
	if (fixedString != str)
		fixedString =  fixedString $ "...";
	
	return fixedString ;
}



//defaultproperties
//{
	
//}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();
}
defaultproperties
{
}
