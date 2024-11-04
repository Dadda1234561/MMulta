class RecipeTreeWnd extends UICommonAPI;

const CRYSTAL_TYPE_WIDTH = 14;
const CRYSTAL_TYPE_HEIGHT = 14;

var TreeHandle mainTree;

var array<INT64> itemNeedCount;

var bool m_MultipleProduct;

function OnRegisterEvent()
{
	RegisterEvent( EV_RecipeShowRecipeTreeWnd );
	RegisterEvent( EV_InventoryAddItem );
	RegisterEvent( EV_InventoryUpdateItem );
}

function OnLoad()
{
	SetClosingOnESC();

	mainTree = GetTreeHandle( "RecipeTreeWnd.MainTree") ;
}

function OnEvent(int Event_ID, String param)
{
	if (Event_ID == EV_RecipeShowRecipeTreeWnd)
	{
		StartRecipeTreeWnd( param );
	}
	else if( Event_ID == EV_InventoryAddItem || Event_ID == EV_InventoryUpdateItem )
	{
		HandleInventoryItem(param);
	}
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnClose":
			CloseWindow();
		break;
	}
}

function onShow()
{
//	setWindowForm() ;
}

//������ �ݱ�
function CloseWindow()
{
	Clear();
	class'UIAPI_WINDOW'.static.HideWindow("RecipeTreeWnd");
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//�ʱ�ȭ
function Clear()
{
	class'UIAPI_TREECTRL'.static.Clear("RecipeTreeWnd.MainTree");
}

//Start Function
function StartRecipeTreeWnd(string param)
{
	local int RecipeID;	
	local int m_AddSuccRate;
	local int m_CreateCritical;

	ParseInt(param, "RecipeID", RecipeID);
	ParseInt(param, "AddSuccRate", m_AddSuccRate);
	ParseInt(param, "CreateCritical", m_CreateCritical);
	//Show
	class'UIAPI_WINDOW'.static.ShowWindow("RecipeTreeWnd");
	class'UIAPI_WINDOW'.static.SetFocus("RecipeTreeWnd");
	
	Clear();
	SetRecipeInfo(RecipeID, m_AddSuccRate, m_CreateCritical);
}

//������ ���� ����
function SetRecipeInfo(int RecipeID, int m_AddSuccRate, int m_CreateCritical)
{
	local string		strTmp;
	local string		strTmp2;
	local int			nTmp;
	local XMLTreeNodeInfo	infNode;
	
	local int			ProductID;
	local Rect          txtNameRect;

	local ItemInfo      newItem;
	
	//������ ������ �ؽ���
	//strTmp = class'UIDATA_RECIPE'.static.GetRecipeIconName(RecipeID);
	//������ �̸�
	ProductID = class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	
	class'UIDATA_ITEM'.static.GetItemInfo ( GetItemID(ProductID) , newItem  );
	
	class'UIAPI_ITEMWINDOW'.static.Clear( "RecipeTreeWnd.texItem" );
	class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeTreeWnd.texItem" , newItem ) ;
	
	//class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeManufactureWnd.texItem", strTmp);
/*
	if (Len(strTmp)>0)
	{
		class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeTreeWnd.texIcon", strTmp);
	}
	else
	{
		class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeTreeWnd.texIcon", "Default.BlackTexture");
	}
*/
	
	
	strTmp = MakeFullItemName(ProductID);
	
	//Crystal Type(Grade Emoticon���)
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
	strTmp2 = GetItemGradeTextureName(nTmp);

	class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeTreeWnd.texGrade", strTmp2);
	
	class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtName", strTmp);

	// txtName ���� ���ϰ�, ... ó�� ���θ� �����Ѵ�.
	txtNameRect = GetTextBoxHandle("RecipeTreeWnd.txtName").GetRect();

	if ( txtNameRect.nWidth > 150 ) 
	{  
		// ������ ... �� �ְ� �ؽ�Ʈ ����� �ٿ��� UI�ȿ� ��� ������ �ϵ� �ڵ�, TTP:47441 �ذ��� ����;
		GetTextBoxHandle("RecipeTreeWnd.txtName").SetWindowSize(141, txtNameRect.nHeight);		
		GetTextBoxHandle("RecipeTreeWnd.txtName").SetTextEllipsisWidth(141);
	}
	else 
	{  
		// ...  �ִ� ��� ĵ�� 
		GetTextBoxHandle("RecipeTreeWnd.txtName").SetTextEllipsisWidth(-1);
	}

	GetTextBoxHandle("RecipeTreeWnd.txtName").SetTooltipType("Text");
	GetTextBoxHandle("RecipeTreeWnd.txtName").SetTooltipText(strTmp);

	// S80 �׷��̵��� ��쿡 ���� ������ �ؽ��� ũ�⸦ 2��� �ø���. 6, 7
	// R95, R99 �׷��̵��� ��쿡 ���� ������ �ؽ��� ũ�⸦ 2��� �ø���. 9, 10
	// EVENT �׷��̵��� ��쿡 2��� �ø��� ���� �ְ� �ƴ� ���� �ִ�. �ֱ׷��� �𸣴ϱ� �ϴ��� ���� 11
	if( nTmp == CrystalType.CRT_S80 || nTmp == CrystalType.CRT_S84 || nTmp == CrystalType.CRT_R95 || nTmp == CrystalType.CRT_R99 || nTmp == CrystalType.CRT_R110 || nTmp == CrystalType.CRT_EVENT )
	{
		class'UIAPI_WINDOW'.static.SetWindowSize( "RecipeTreeWnd.texGrade", CRYSTAL_TYPE_WIDTH * 2, CRYSTAL_TYPE_HEIGHT );
	}
	else
	{
		class'UIAPI_WINDOW'.static.SetWindowSize( "RecipeTreeWnd.texGrade", CRYSTAL_TYPE_WIDTH, CRYSTAL_TYPE_HEIGHT );
	}
	
	//MP�Һ�
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtMPConsume", "" $ nTmp);
	
	//����Ȯ��
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtSuccessRate", nTmp $ "%");

	m_MultipleProduct = bool(class'UIDATA_RECIPE'.static.GetRecipeIsMultipleProduct(RecipeID));

	// �нú� ��ų�� ���� �߰� Ȯ���� ũ��Ƽ��
	handleAddSuccessNCritical( nTmp, m_AddSuccRate, m_CreateCritical );
	
	//������ ����
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.TxtForgeLevelValue", string(nTmp));
	
	//�ɼǺο� ����
	//m_MultipleProduct = true;
	if ( m_MultipleProduct )
		class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtOption", GetSystemMessage(2320));
	else
		class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtOption", "");

	
	//Ʈ���� Root�߰�
	infNode.strName = "root";
	infNode.nOffSetX = 1;
	infNode.nOffSetY = 5;
	strTmp = class'UIAPI_TREECTRL'.static.InsertNode("RecipeTreeWnd.MainTree", "", infNode);
	if (Len(strTmp) < 1)
	{
		//debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}
	
	itemNeedCount.Remove(0, itemNeedCount.Length);
	//Debug ( "itemNeedCount ���� " @ itemNeedCount.Length );
	//Ʈ�� �ۼ�
	AddRecipeItem(RecipeID, ProductID, 0, "root");
}

function setWindowForm( bool bUseCritical ) 
{
	//bUseCritical = true;
	//m_MultipleProduct = true;
	// m_MultipleProduct �� ���̺꿡����

	//Debug ( "setWindowForm" @ m_MultipleProduct ) ;
	if ( m_MultipleProduct ) 
	{		
		GetTextBoxHandle( "RecipeTreeWnd"$".txtCreateCritical" ).HideWindow();
		GetTextBoxHandle( "RecipeTreeWnd"$".txtCreateCriticalMid" ).HideWindow();
		GetTextBoxHandle( "RecipeTreeWnd"$".txtCreateCriticalValue" ).HideWindow();
		GetWindowHandle( "RecipeTreeWnd" ).SetWindowSize(254, 422);
		GetTextureHandle( "RecipeTreeWnd"$".RecipeBg" ).SetWindowSize( 241, 92 );
	}

	// bUseCritical �� Ŭ���� ������
	else if ( bUseCritical ) 
	{	
		GetTextBoxHandle( "RecipeTreeWnd"$".txtCreateCritical" ).ShowWindow();
		GetTextBoxHandle( "RecipeTreeWnd"$".txtCreateCriticalMid" ).ShowWindow();		
		GetTextBoxHandle( "RecipeTreeWnd"$".txtCreateCriticalValue" ).ShowWindow();
		GetWindowHandle( "RecipeTreeWnd" ).SetWindowSize(254, 422);
		GetTextureHandle( "RecipeTreeWnd"$".RecipeBg" ).SetWindowSize( 241, 92 );
	}
	else 
	{
		GetTextBoxHandle( "RecipeTreeWnd"$".txtCreateCritical" ).HideWindow();
		GetTextBoxHandle( "RecipeTreeWnd"$".txtCreateCriticalMid" ).HideWindow();
		GetTextBoxHandle( "RecipeTreeWnd"$".txtCreateCriticalValue" ).HideWindow();
		GetWindowHandle( "RecipeTreeWnd" ).SetWindowSize(254, 407);
		GetTextureHandle( "RecipeTreeWnd"$".RecipeBg" ).SetWindowSize( 241, 77 );
	}

}

// ũ��Ƽ�ð� �߰� Ȯ��
function handleAddSuccessNCritical( int m_SuccessRate, int m_AddSuccRate, int m_CreateCritical )
{	
	// �߰� ���� Ȯ����( ������ �ƴ� ) , ũ��Ƽ�� Ȯ�� 
	if ( getInstanceUIData().getIsClassicServer() ) 
	{
		if ( m_SuccessRate == 100 ) 
			class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtAddSuccessRate", "");
		else if ( m_SuccessRate + m_AddSuccRate <= 100 ) 
			class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtAddSuccessRate", "+" $ m_AddSuccRate $ "%");
		else 
			class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtAddSuccessRate", "+" $ 100 - m_SuccessRate $ "%");

		if ( m_CreateCritical == 0 ) 
			class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtCreateCriticalValue", GetSystemString(27) );
		else 
			class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtCreateCriticalValue", m_CreateCritical $ "%");
	}

	setWindowForm( m_CreateCritical != -1 && getInstanceUIData().getIsClassicServer() );
}

/*
 * �κ��丮 ������ ���� �̺�Ʈ 
 */

function HandleInventoryItem ( string param ) 
{
	//local int idx;
	//local ItemInfo infItem;	
	//local int64 invenItemCount;

	local itemID cID ;

	//������ �ʿ� �� 
	//local int64 needNum ;
//  local string type ;

	//findItem( cID.classID, "root" ) ;
	if (!GetWindowHandle("RecipeTreeWnd").IsShowWindow()) return;

	if (ParseItemID( param, cID ))
	{
		//needNum = 0;
		//���� �̺�Ʈ�� ���� �������� serverID ���� 0�̴�.
		//cID.serverID = 0;

		//class'UIAPI_TREECTRL'.static.IsNodeNameExist("RecipeTreeWnd.MainTree", "nodeName");
		findNFixItem( cID.classID, "root", -1 );//$ "." $ 17290 $ "." $ 36732 ) ;

	//
	//FindItemByClassID( cID );	// ClassID
/*
		ParseString( param, "type", type );

		if( type == "update" )
		{
			
		}
		else if( type == "delete" )
		{
			
		}
		//add�� ���� �ʿ� ����
		else if( type == "add" )
		{
		}	
*/
	}
}


/* 
 * �������� ����Ʈ���� �������� ã�� ī��Ʈ�� ���� �� ��. 
 */
function int findNFixItem (  int cID , string strNodeName, int index )
{
	local string strChildList;
	local array<string> ChildList, itemList;
	local string textureName ;

	//local XMLTreeNodeItemInfo	infNodeItem, infNodeItemClear;
	//local XMLTreeNodeInfo	infNode;

	local int i ;
	
	local INT64 nTmp ;
	//strChildList = GetChildNode( "RecipeTreeWnd.MainTree", strNodeName);

	//if ( strNodeName == "root" ) 
//		Debug ( "findItem root");	
	
	strChildList = mainTree.GetChildNode(strNodeName);
	 
	// child ��带 �޾Ƽ� �迭�� �ɰ� ��.
	Split ( strChildList , "|", ChildList );	

	if ( cID <= 0 ) return -1 ;

	//Debug ( "findItem index : " @ index @ cID @ ChildList.Length);

	for ( i = 0 ; i < ChildList.Length ; i ++ ) 
	{	
		if ( ChildList[i] != "" ) 
		{
			index ++ ;
			//Debug ( "findItem" @  index @ "="@ itemNeedCount[index] );			
			// root�� �ٷ� �ִ� �������� ���� ������� �ϴ� �������̸�, �������̳� �ʿ���� �����Ƿ� ������ ���� ������ �ʿ� ����
			if ( strNodeName != "root" ) 
			{		
				// �� �� ������ ID ������ cID �� �� �Ѵ�.
				Split ( ChildList[ i ], ".", itemList);

				//Debug ( i @ ChildList.Length @ ChildList[i] @ itemList[itemList.Length - 1] @ cID);
				if ( int ( itemList[itemList.Length - 1] ) == cID ) 
				{					
					//�κ��丮�� �ش� �������� ����
					nTmp = GetInventoryItemCount(GetItemID(cID));
					//Debug ( "findItem" @ ChildList[ i ] @ index @ itemNeedCount[index] );

					mainTree.SetNodeItemText(ChildList[ i ], 1, "("$nTmp$"/"$itemNeedCount[index]$")" );

					//��ᰡ �� �ȸ���� ����� �帴�ϰ� ǥ�� �װ� �ƴ϶�� �ؽ��ĸ� ������ �ʰ� ��.
					if (nTmp < itemNeedCount[index])
					{
						//Debug ( "���� �ؽ��ĸ� �ٲ�� �� " @ ChildList[ i ]  );
						textureName = "Default.ChatBack";
					}	
		
					mainTree.SetNodeItemTexture ( ChildList[ i ], 2 ,textureName,  0, 0, 0);
					class'UIAPI_TREECTRL'.static.SetNodeItemTexture ( "RecipeTreeWnd.MainTree",ChildList[ i ], 2, textureName , 0, 0, 0);
				}				
			}
			
			index = findNFixItem ( cID, ChildList[i], index);
		}
	}

	return index ; 
}

static function int Split( string strInput, string delim, out array<string> arrToken )
{
	local int arrSize;
	
	while ( InStr(strInput, delim)>0 )
	{
		arrToken.Insert(arrToken.Length, 1);
		arrToken[arrToken.Length-1] = Left(strInput, InStr(strInput, delim));
		strInput = Mid(strInput, InStr(strInput, delim)+1);
		arrSize = arrSize + 1;
	}
	arrToken.Insert(arrToken.Length, 1);
	arrToken[arrToken.Length-1] = strInput;
	arrSize = arrSize + 1;
	
	return arrSize;
}

function AddRecipeItem(int RecipeID, int ProductID, INT64 NeedCount, string NodeName)
{
	local int		i;
	local int		nMax;
	local INT64		nTmp;

	local bool		bIamRoot;

	local string	strTmp;
	local string	strTmp2;
	local string	param;
	local string	strRetName;

	local array<int>	arrMatID;
	local array<INT64>	arrMatNeedCount;
	local array<int>	arrMatRecipeID;

	local XMLTreeNodeInfo		infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo		infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;

	local L2util util;
	local itemInfo newItem;

	util = L2Util(GetScript("L2Util"));


	//������ �̸�
	strTmp = class'UIDATA_ITEM'.static.GetItemName(GetItemID(ProductID));


	//Child �����ǵ��� �߰�
	param = class'UIDATA_RECIPE'.static.GetRecipeMaterialItem(RecipeID);
	ParseInt(param, "Count", nMax);
	
	//���߿� Recursiveȣ���ϴ� �κ��� �����Ƿ�, Static�� Param�� �ϴ� ������ �̾ƾ�(?)�Ѵ�.
	arrMatID.Length = nMax;
	arrMatNeedCount.Length = nMax;
	arrMatRecipeID.Length = nMax;

	for (i=0; i<nMax; i++)
	{
		ParseInt(param, "ID_" $ i, arrMatID[i]);
		ParseINT64(param, "NeededNum_" $ i, arrMatNeedCount[i]);
		ParseInt(param, "RecipeID_" $ i, arrMatRecipeID[i]);	
	}


	if (NodeName == "root")
	{
		bIamRoot = true;
	}
	else
	{
		bIamRoot = false;
	}

		
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//Insert Node - with Button
	infNode = infNodeClear;
	infNode.strName = "" $ ProductID;
	infNode.Tooltip = MakeTooltipSimpleText(strTmp);
	infNode.bFollowCursor = true;
	
	if(nMax>0) //Child�� �ִ� ������
	{
		infNode.bShowButton = 1;

		if (!bIamRoot)
		{
			infNode.nOffSetX = 13;
		}
		infNode.nTexBtnOffSetY = 8;

		infNode.nTexBtnWidth = 15;
		infNode.nTexBtnHeight = 15;
		infNode.strTexBtnExpand = "l2ui_ch3.QuestWnd.QuestWndPlusBtn";
		infNode.strTexBtnCollapse = "l2ui_ch3.QuestWnd.QuestWndMinusBtn";
	}
	
	else
	{
		infNode.bShowButton = 0;
		infNode.nOffsetX = 30;
	}

	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("RecipeTreeWnd.MainTree", NodeName, infNode);

	//Debug ( "nodeName" @ strRetName ) ;
	if (Len(strRetName) < 1)
	{
		Log("ERROR: Can't insert node. Name: " $ infNode.strName);
		return;
	}
	
	//������ ������ �̸�
	class'UIDATA_ITEM'.static.GetItemInfo ( GetItemID(ProductID) , newItem  );
	strTmp2 = newItem.iconName;
	//strTmp2 = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ProductID));

	if (Len(strTmp2)<1)
	{
		strTmp2 = "Default.BlackTexture";
	}
	
	//Insert Node Item - ������ ������
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	if(nMax>0)
	{
		//Insert Node Item - �����۽��� ���
		util.TreeInsertTextureNodeItem( "RecipeTreeWnd.MainTree", strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, -2 );
		infNodeItem.nOffSetX = -34;
		// ������ 2����
	}
	else
	{
		//Insert Node Item - �����۽��� ���
		util.TreeInsertTextureNodeItem( "RecipeTreeWnd.MainTree", strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -2, -2 );
		infNodeItem.nOffsetX = -34;
	}
	// ���� 0
	infNodeItem.nOffSetY = 0;
	infNodeItem.u_nTextureWidth = 32;
	infNodeItem.u_nTextureHeight = 32;
	infNodeItem.u_strTexture = strTmp2;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem );
	
	//Debug  (  "strRetName"  @ infNodeItem.nOffSetX );

	util.TreeInsertTextureNodeItem( "RecipeTreeWnd.MainTree", strRetName, newItem.iconPanel, 32, 32,  -32);	
	
	//Insert Node Item - ������ ������(�׵θ�)
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -32;
	infNodeItem.nOffSetY = 0;
	infNodeItem.u_nTextureWidth = 32;
	infNodeItem.u_nTextureHeight = 32;
	if(nMax>0)
	{
		infNodeItem.u_strTexture = "L2UI.RecipeWnd.RecipeTreeIconBack";
		infNodeItem.u_strTextureExpanded = "L2UI.RecipeWnd.RecipeTreeIconBack_click";
	}
	else
	{
		//infNodeItem.u_strTexture = "L2UI.RecipeWnd.RecipeTreeIconDisableBack";
	}
	
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
	
	if (!bIamRoot)
	{
		//�κ��丮�� �ش� �������� ����
		nTmp = GetInventoryItemCount(GetItemID(ProductID));
		
		//��ᰡ �� �ȸ���� ����� �帴�ϰ� ǥ��
		//Insert Node Item - �帴 �ؽ���
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = -32;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureWidth = 32;
		infNodeItem.u_nTextureHeight = 32;
		infNodeItem.t_nTextID = 2;
		if (nTmp < NeedCount)
		{			
			infNodeItem.u_strTexture = "Default.ChatBack";
		}	
		class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
	}
	
	//Insert Node Item - ������ �̸�
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strTmp;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 3;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
	
	if (!bIamRoot)
	{
		//Insert Node Item - ��� ����
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_nTextID = 1 ;
		infNodeItem.t_strText = "(" $ string(nTmp) $ "/" $ string(NeedCount) $ ")";
		infNodeItem.bLineBreak = true;
		if(nMax>0)
		{
			infNodeItem.nOffSetX = 51;
		}
		else
		{
			infNodeItem.nOffsetX = 37;
		}
		infNodeItem.nOffSetY = -14;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
	}

	itemNeedCount.Length = itemNeedCount.Length +1 ;
	itemNeedCount[ itemNeedCount.Length -1 ] = NeedCount ;
//	Debug ( "addItem index " @ itemNeedCount.Length @ "=" @ itemNeedCount[ itemNeedCount.Length -1 ] );

	
	//Insert Node Item - Blank
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.bStopMouseFocus = true;
	if(nMax>0)
	{
		infNodeItem.b_nHeight = 6;
	}
	else
	{
		infNodeItem.b_nHeight = 4;
	}
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);


	for (i=0; i<nMax; i++)
	{
		//Recursive
		AddRecipeItem(arrMatRecipeID[i],arrMatID[i], arrMatNeedCount[i], strRetName);
	}
}


/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	CloseWindow();
}

defaultproperties
{
}
