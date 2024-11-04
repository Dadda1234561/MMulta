class RecipeBuyManufactureWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// RECIPE CONST
//////////////////////////////////////////////////////////////////////////////
const RECIPEWND_MAX_MP_WIDTH = 165.0f;

const CRYSTAL_TYPE_WIDTH = 14;
const CRYSTAL_TYPE_HEIGHT = 14;

const DIALOG_STACKABLE_ITEM_REMOVE  = 1230;
const DIALOG_STACKABLE_ITEM_ADD     = 1240;

var string  m_WindowName;
var int		m_MerchantID;	//�Ǹ����� ServerID
var int		m_RecipeID;	//RecipeID
var int		m_SuccessRate;	//������
var INT64	m_Adena;		//�Ƶ���

var int		m_MaxMP;		//�Ƶ���


var int	    m_AddSuccRate;      // �߰� ������s
var int     m_CreateCritical;   // ũ��Ƽ�� ���� Ȯ��

var BarHandle MPBar;

//���� ������ ������
var ItemWindowHandle m_TributeItemWnd;
var TextBoxHandle    m_offeringRateTextBox;
var int               m_offering;

var ItemWindowHandle m_ItemWnd;

function OnRegisterEvent()
{
	RegisterEvent( EV_RecipeShopItemInfo );
	RegisterEvent( EV_UpdateMP );
	RegisterEvent( EV_UpdateMyMP );
	
	RegisterEvent( EV_InventoryAddItem );
	RegisterEvent( EV_InventoryUpdateItem );

	RegisterEvent( EV_DialogOK );		
}

function OnLoad()
{
	SetClosingOnESC();

	MPBar = GetBarHandle( "RecipeBuyManufactureWnd.barMp" );
	
	m_ItemWnd = GetItemWindowHandle ( ( m_WindowName$".ItemWnd")); 

	m_TributeItemWnd = GetItemWindowHandle ( m_WindowName$".TributeWnd.TributeItemWnd");
	m_offeringRateTextBox = GetTextBoxHandle ( m_WindowName$".txtOfferingRate" );

	GetTextBoxHandle ( m_WindowName$".txtOffering" ).SetText ( GetSystemString (654 )$GetSystemString (642 ) );
}

function OnEvent(int Event_ID, string param)
{
	local Rect 	rectWnd;
	local int		ServerID;
	local int		MPValue;

	// 2006/07/10 NeverDie
	local int		MerchantID;
	local int		RecipeID;
	local int		CurrentMP;
	local int		MaxMP;
	local int		MakingResult;
	local INT64		Adena;
	// ũ��Ƽ���� ���� �ߴ��� ����.
	local int       IsCreateCriticalSuccess;
	
	if (Event_ID == EV_RecipeShopItemInfo)
	{	
		
		Clear();
		
		//�������� ��ġ�� RecipeBuyListWnd�� ����
		
		if ( IsShowWindow ( "RecipeBuyListWnd" ) ) 
		{
			rectWnd = class'UIAPI_WINDOW'.static.GetRect("RecipeBuyListWnd");
			class'UIAPI_WINDOW'.static.MoveTo("RecipeBuyManufactureWnd", rectWnd.nX, rectWnd.nY);
			class'UIAPI_WINDOW'.static.HideWindow("RecipeBuyListWnd");
		}		
		
		//show
		class'UIAPI_WINDOW'.static.ShowWindow("RecipeBuyManufactureWnd");
		class'UIAPI_WINDOW'.static.SetFocus("RecipeBuyManufactureWnd");
		
		ParseInt( param, "MerchantID", MerchantID );
		ParseInt( param, "RecipeID", RecipeID );
		ParseInt( param, "CurrentMP", CurrentMP );
		ParseInt( param, "MaxMP", MaxMP );
		ParseInt( param, "MakingResult", MakingResult );
		ParseINT64( param, "Adena", Adena );		

		ParseInt( param, "UseOffering", m_offering );

		ParseInt ( param, "AddSuccRate", m_AddSuccRate ) ;
		ParseInt ( param, "CreateCritical", m_CreateCritical ) ;

		ParseInt ( param , "IsCreateCriticalSuccess", IsCreateCriticalSuccess ) ;

		//Debug( "�߰�, ũ��Ƽ��:" @ m_AddSuccRate @ m_CreateCritical) ;
		
		ReceiveRecipeShopSellList( MerchantID, RecipeID, CurrentMP, MaxMP, MakingResult, Adena, IsCreateCriticalSuccess );

		setWindowForm ( m_CreateCritical != -1 && getInstanceUIData().getIsClassicServer() );
		setOfferingRate() ;
		//setOfferingRateString( setOfferingRate() );
//		debug("MP" $CurrentMP $"  " $MaxMP);		
	}
	else if (Event_ID == EV_UpdateMP || Event_ID == EV_UpdateMyMP)
	{
		ParseInt(param, "ServerID", ServerID);
		ParseInt(param, "CurrentMP", MPValue );
		if (m_MerchantID==ServerID && m_MerchantID>0)
		{
			SetMPBar(MPValue);
		}
	}
	else if( Event_ID == EV_InventoryAddItem || Event_ID == EV_InventoryUpdateItem )
	{
		HandleInventoryItem(param);
	}

	else if ( Event_ID == EV_DialogOK ) HandleDialogOK();	
}

function HandleDialogOK()
{
	local ItemInfo scInfo;
	local INT64 inputNum;	
	local int tributeID;
	local ItemInfo tributeItemInfo;
	local bool allItemMove; // ��� �������� �ű�� ���ΰ�? ����Ŀ���� ��� ��� �������� a���� b�� �ű�� ���̶�� a���� �����־���Ѵ�.
	local int id;

	//���� �ִ� �������� ��� �ʿ� ���� ���� �� ��.
	if (DialogIsMine() )
	{
		id = DialogGetID();
	
		if (id == DIALOG_STACKABLE_ITEM_REMOVE || id == DIALOG_STACKABLE_ITEM_ADD)
		{
			DialogGetReservedItemInfo( scInfo );
			inputNum =  INT64(DialogGetString() );

			// ��û�� ������ 0���� Ŀ���Ѵ�.
			if ( inputNum <= 0 ) return;		
			
			// �Է� �� ���� ������ ���� ���� ũ�ٸ�,
			if ( inputNum >= scInfo.itemNum )
			{
				// ���簡���� �ִ� ���� �������ش�. Maximum��..					
				inputNum = scInfo.itemNum; 

				// Maixmum���¸� �����Ѵ�.
				allItemMove = true; 
			}

			tributeID = m_TributeItemWnd.FindItem( scInfo.id);

			// ������ ����
			if ( id == DIALOG_STACKABLE_ITEM_REMOVE)
			{	
				if (allItemMove) 
				{
					// ���� �ű�� ���̹Ƿ� �����ش�.
					m_TributeItemWnd.DeleteItem( tributeID );
				}
				else	
				{
					// �Ϻθ� �Ű��ֹǷ� ������ �����Ѵ�.
					scInfo.ItemNum -= inputNum;
					m_TributeItemWnd.SetItem( tributeID , scInfo);
				}
			}

			// ������ ���ϱ�
			else if (id == DIALOG_STACKABLE_ITEM_ADD )
			{	
				// ���� ������ �������� �ִٸ� ������� �Ѵ�.
				if (tributeID >= 0)
				{
					m_TributeItemWnd.GetItem(tributeID, tributeItemInfo);
					//��� ���� item�� ���� ���� �ش�.
					tributeItemInfo.ItemNum += inputNum;
					
					//�ִ� �� ��� 
					if ( scInfo.itemNum < tributeItemInfo.ItemNum ) tributeItemInfo.ItemNum =  scInfo.itemNum;

					m_TributeItemWnd.SetItem(tributeID, tributeItemInfo);
				}
				else //
				{				
					scInfo.itemNum = inputNum;
					m_TributeItemWnd.AddItem ( scInfo ) ;
				}
			}		

			setOfferingRate() ;
		}
	}
}

/*
 *
 * ������ �̵� �� ���̾�α׸� ������ �� ���� ����
 */
function bool isShowDialogOnMoveStackableItem ( ItemInfo infItem ) 
{
	//Debug ( "���̾�α� ���� ���� üũ " @ IsStackableItem( infItem.ConsumeType) @ infItem.ItemNum @ infItem.AllItemCount @ class'InputAPI'.static.IsAltPressed() );
	if (IsStackableItem( infItem.ConsumeType) && infItem.ItemNum != 1)
	{		
		//infItem.AllItemCount <= 0
		if ( !class'InputAPI'.static.IsAltPressed() )
		{		
			return true;
		}				
	}	
	return false;
}


/*
 * ���� �������� remove ��� ����
 */
function deleteTributeItem(ItemInfo infItem)
{	
	local int tributeItemID;
	
	tributeItemID = m_TributeItemWnd.FindItem( infItem.id );

	if ( isShowDialogOnMoveStackableItem ( infItem ) )
	{		
		showStackItemDialog( DIALOG_STACKABLE_ITEM_REMOVE, infItem ) ;		
	}
	else
	{
		m_TributeItemWnd.DeleteItem(tributeItemID);

		setOfferingRate() ;
	}
}

/*
 * ���� ���̾�α� �����ּ���
 */
function showStackItemDialog ( int ID, iteminfo infItem  ) 
{
	local string systemMsg;

	DialogSetID(ID);	

	if ( ID == DIALOG_STACKABLE_ITEM_REMOVE) 
	{
		systemMsg = GetSystemMessage(6193);
	}
	else if ( ID == DIALOG_STACKABLE_ITEM_ADD )
	{
		systemMsg = GetSystemMessage(6192);
	}
	else systemMsg = GetSystemMessage(72);	

	DialogSetReservedItemInfo(infItem);
	DialogSetParamInt64(infItem.ItemNum);
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( systemMsg, infItem.Name, "" ), string(Self));
}


/*
 * ������ �ڵ鷯�� ���� ���� ���� ����
 */
function handleRemoveItem ( ItemWindowHandle a_hItemWindow, int index ) 
{	
	local ItemInfo info;

	if (!a_hItemWindow.GetItem(index, info)) return;
	
	switch ( a_hItemWindow.GetWindowName() ) 
	{
		case "TributeItemWnd" :
			deleteTributeItem( info );
			break;
	}
}

/*
 *���� �������� ���� �ϴ� ������ ��� 
 *
 *  OnDBClickItemWithHandle         : ���� Ŭ��
 *  OnRClickItemWithHandle          : �� Ŭ��
 *  OnDropItemSource                : ����� ���
 */
function OnDBClickItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
{
	handleRemoveItem( a_hItemWindow, index );
}

function OnRClickItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
{
	handleRemoveItem( a_hItemWindow, index );
}

//���⼭ �巡�� ���� ���� ��, �ٸ� ���� ��� �� ��� �߻�
function OnDropItemSource( String strTarget, ItemInfo info )
{	
	if ( strTarget == "Console")
	{		
		switch (info.DragSrcName  )
		{
			case "TributeItemWnd":		
				deleteTributeItem ( info );
			break;
		}		
	}
}

/*
 * ���� �������� ����
 */
function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{	
	if(!(
		a_ItemInfo.DragSrcName == "InventoryItem"     ||		
		a_ItemInfo.DragSrcName == "InventoryItem_1"   ||
		a_ItemInfo.DragSrcName == "InventoryItem_2"   ||
		a_ItemInfo.DragSrcName == "InventoryItem_3"   ||
		a_ItemInfo.DragSrcName == "InventoryItem_4"   ||
		a_ItemInfo.DragSrcName == "PetInvenWnd"       ||
		-1 != InStr( a_ItemInfo.DragSrcName, "EquipItem" ))) 
		return ;

	/*
	 * �� �κ��丮���� ��� ���� ��� 
	 * �� �κ��丮�� �ִ¾������� ������ ����� �� �����ϴ�. �޽��� ���
	 */	
	if ( a_ItemInfo.DragSrcName == "PetInvenWnd" ) 
	{
		AddSystemMessage( 6184 );
		return;
	}
}

/*
 * �߰�Ȯ�� �� ����
 */
function setOfferingRateString ( int64 OfferingRate ) 
{
	local string strTmp;
	local L2Util util;

	local Color offeringRateColor;
	util = L2Util( getScript ( "L2Util"));	
	
	strTmp = OfferingRate$"%";// $ "/"$maxOffering$"%";

	if ( ( 100 - m_SuccessRate ) <= OfferingRate ) 
	{
		strTmp = strTmp $ GetSystemString ( 2610 );
		offeringRateColor.R = 255;
		offeringRateColor.G = 102;
		offeringRateColor.B = 102;
		//m_offeringRate.SetTextColor( util.COLOR_RED );
		
	} else 
	{
		offeringRateColor = util.Yellow03;
	}

	m_offeringRateTextBox.SetTextColor( offeringRateColor );
	m_offeringRateTextBox.SetText( strTmp );	
}


/*
 * ���� �������� ��ü DP�� ����
 */
function setOfferingRate() 
{
	/**local int64 totalDefaultPrice;
	local int i;
	local itemInfo tributeItemInfo;

	totalDefaultPrice = 0;

	for ( i = 0 ; i < m_TributeItemWnd.GetItemNum() ; i ++ ) 
	{
		m_TributeItemWnd.GetItem(i, tributeItemInfo ) ; 
		totalDefaultPrice += tributeItemInfo.itemNum * tributeItemInfo.n64DefaultPriceFromScript;
	}	

	m_CurrRate = RefreshRecipeOfferingRate(totalDefaultPrice,true);

	setOfferingRateString(m_CurrRate);**/
}

/* 
 * ������ �Ƶ����� ��� �ʿ��� ��� �ΰ� ��� ��.
 */
function int64 getMaxTributeItemNum ( itemInfo tributeItem )
{	
	local itemInfo infItem ;
	local int idx ;
	local int64 needNum;

	needNum = 0;
	idx = m_ItemWnd.FindItemByClassID ( tributeItem.ID ) ;

	if ( idx > -1 ) 
	{	
		m_ItemWnd.GetItem ( idx, infItem ) ;
		needNum = infItem.Reserved64;
		
		/*
		 * �� ������ ������ ���� ����� ��� ������ ���� �� ����.		 
		 */		
	}

    else if ( isAdena( tributeItem.ID ) ) 
	{
		needNum = m_Adena;		
	}
	
	return tributeItem.itemNum - needNum;	
}

/*
 * ���� �������� ����Ʈ�� ���� ������.
  
 */
function ManufactureWidthTribute( )
{
	/**local Array<OfferingItemList> tributeItemList ;
	local int i;
	local iteminfo tributeItem;

	tributeItemList.Length = m_TributeItemWnd.GetItemNum();
	for ( i = 0 ; i < tributeItemList.Length ; i++ )
	{
		m_TributeItemWnd.GetItem(i, tributeItem);
		tributeItemList[i].nItemID = tributeItem.ID.serverID;	
		tributeItemList[i].nAmount = tributeItem.itemNum;
	}
	//Debug ( "ManufactureWidthTribute" @ m_TributeItemWnd.GetItemNum()@ tributeItemList[0].nItemID @ tributeItemList[0].nAmount );
	class'RecipeAPI'.static.RequestRecipeShopMakeDo(m_MerchantID, m_RecipeID, m_Adena, m_TributeItemWnd.GetItemNum(), tributeItemList);**/
}

// ũ��Ƽ�ð� �߰� Ȯ��
function handleAddSuccessNCritical()
{	
	// �߰� ���� Ȯ����( ������ �ƴ� ) , ũ��Ƽ�� Ȯ�� 
	if ( getInstanceUIData().getIsClassicServer() ) 
	{
		if ( m_SuccessRate == 100 ) 
			class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtAddSuccessRate", "");
		else if ( m_SuccessRate + m_AddSuccRate <= 100 ) 
			class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtAddSuccessRate", "+" $ m_AddSuccRate $ "%");
		else 
			class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtAddSuccessRate", "+" $ 100 - m_SuccessRate $ "%");

		if ( m_CreateCritical == 0 ) 
			class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtCreateCriticalValue", GetSystemString(27) );
		else 
			class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtCreateCriticalValue", m_CreateCritical $ "%");
	}
}

/*
 * ������ ũ�� ����
 * 1. ���� �ý���
 * 2. ũ��Ƽ�� Ȯ�� 
 * 3. ���� ���� : ���� ���� ��
 */
function setWindowForm( bool bUseCritical ) 
{
	local int criticalHeight ;
	// �ؽ�Ʈ �ʵ� �Ѱ� �߰� �� 15 �� �þ� ��.
	if ( bUseCritical ) 
	{
		criticalHeight = 15;
		GetTextBoxHandle( m_WindowName$".txtCreateCritical" ).ShowWindow();
		GetTextBoxHandle( m_WindowName$".txtCreateCriticalMid" ).ShowWindow();	
		GetTextBoxHandle( m_WindowName$".txtCreateCriticalValue" ).ShowWindow();	
	}
	else 
	{
		GetTextBoxHandle( m_WindowName$".txtCreateCritical" ).HideWindow();
		GetTextBoxHandle( m_WindowName$".txtCreateCriticalMid" ).HideWindow();
		GetTextBoxHandle( m_WindowName$".txtCreateCriticalValue" ).HideWindow();
	}
	
	if ( m_offering > 0  ) 	
	{
		//���� ����
		GetWindowHandle( m_WindowName$".TributeWnd" ).ShowWindow();
		GetWindowHandle( m_WindowName ).SetWindowSize(254, 537);
		GetTextureHandle( m_WindowName$".RecipeBg" ).SetWindowSize( 241, 92 + criticalHeight );	

		GetTextBoxHandle( m_WindowName$".txtOffering" ).ShowWindow();
		GetTextBoxHandle( m_WindowName$".txtOfferMid" ).ShowWindow();
		//GetTextBoxHandle( m_WindowName$".txtOfferingRate" ).ShowWindow();
		m_offeringRateTextBox.ShowWindow();
	}
	else
	{	
		GetWindowHandle( m_WindowName$".TributeWnd" ).HideWindow(); 
		GetWindowHandle( m_WindowName ).SetWindowSize(254, 407);
		GetTextureHandle( m_WindowName$".RecipeBg" ).SetWindowSize( 241, 77 + criticalHeight );
		GetTextBoxHandle( m_WindowName$".txtOffering" ).Hidewindow();
		GetTextBoxHandle( m_WindowName$".txtOfferMid" ).Hidewindow();
		m_offeringRateTextBox.HideWindow();
		//GetTextBoxHandle( m_WindowName$".txtOfferingRate" ).Hidewindow();		
	}	
}


function OnClickButton( string strID )
{
	local string param;
	local Rect   	rectWnd;
	
	switch( strID )
	{
	case "btnClose":
		CloseWindow();
		break;
	case "btnPrev":
		//RecipeBuyListWnd�� ���ư�
		class'RecipeAPI'.static.RequestRecipeShopSellList(m_MerchantID);

		rectWnd = class'UIAPI_WINDOW'.static.GetRect(m_WindowName);		
		class'UIAPI_WINDOW'.static.MoveTo("RecipeBuyListWnd", rectWnd.nX, rectWnd.nY);
		
		CloseWindow();
		break;

	case "btnRecipeTree":
		if (class'UIAPI_WINDOW'.static.IsShowWindow("RecipeTreeWnd"))
		{
			class'UIAPI_WINDOW'.static.HideWindow("RecipeTreeWnd");	
		}
		else
		{
			ParamAdd(param, "RecipeID", string(m_RecipeID));
			ParamAdd(param, "SuccessRate", string(m_SuccessRate));

			ParamAdd(param, "AddSuccRate", string(m_AddSuccRate));
			ParamAdd(param, "CreateCritical", string(m_CreateCritical));

			ExecuteEvent( EV_RecipeShowRecipeTreeWnd, param);
		}
		break;
	case "btnManufacture":
		if(m_offering > 0)
		{
			ManufactureWidthTribute();
		}
		else
		{
			class'RecipeAPI'.static.RequestRecipeShopMakeDo(m_MerchantID, m_RecipeID, m_Adena);
		}
		break;
	}
}

//������ �ݱ�
function CloseWindow()
{
	Clear();
	class'UIAPI_WINDOW'.static.HideWindow("RecipeBuyManufactureWnd");
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//�ʱ�ȭ
function Clear()
{
	m_MerchantID = 0;
	m_RecipeID = 0;
	m_SuccessRate = 0;
	m_Adena = 0;
	m_MaxMP = 0;
	m_ItemWnd.Clear();
	//class'UIAPI_ITEMWINDOW'.static.Clear("RecipeManufactureWnd.ItemWnd");
	//â�� ���� ���� �� ������ ��� �õ� �ϴ� ��� ������ clear ���� ���ƶ�. 
	if ( !IsShowWindow( m_WindowName ) ) m_TributeItemWnd.Clear();	
	m_offering = 0;
}

//�⺻���� ����
function ReceiveRecipeShopSellList(int MerchantID,int RecipeID,int CurrentMP,int MaxMP,int MakingResult,INT64 Adena, int IsCreateCriticalSuccess)
{
	local int			i;
	
	local string		strTmp;
	local int			nTmp;
	local int			nTmp2;
	
	local int			ProductID;
	local int			ProductNum;
	local string		ItemName;
	
	local string		param;
	local ItemInfo		infItem, newItem;
	
	//�������� ����
	m_MerchantID = MerchantID;
	m_RecipeID = RecipeID;
	m_SuccessRate = class'UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID);
	m_Adena = Adena;
	m_MaxMP = MaxMP;
	
	//������ Ÿ��Ʋ ����
	strTmp = GetSystemString(663) $ " - " $ class'UIDATA_USER'.static.GetUserName(MerchantID);
	setWindowTitleByString(strTmp);
	//Product ID
	ProductID = class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	
	//(������)�ؽ���	
	class'UIDATA_ITEM'.static.GetItemInfo ( GetItemID(ProductID) , newItem  );	
	class'UIAPI_ITEMWINDOW'.static.Clear("RecipeBuyManufactureWnd.texItem");
	class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeBuyManufactureWnd.texItem" , newItem ) ;		
	
	//Crystal Type(Grade Emoticon���)
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);

	strTmp = GetItemGradeTextureName(nTmp);
	class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeBuyManufactureWnd.texGrade", strTmp);

	
	// S80 �׷��̵��� ��쿡 ���� ������ �ؽ��� ũ�⸦ 2��� �ø���. 6
	// R95, R99 �׷��̵��� ��쿡 ���� ������ �ؽ��� ũ�⸦ 2��� �ø���. 8, 9
	// EVENT �׷��̵��� ��쿡 2��� �ø��� ���� �ְ� �ƴ� ���� �ִ�. �ֱ׷��� �𸣴ϱ� �ϴ��� ���� 10
	if( nTmp == CrystalType.CRT_S80 || nTmp == CrystalType.CRT_R95 || nTmp == CrystalType.CRT_R99 || nTmp == CrystalType.CRT_R110 || nTmp == CrystalType.CRT_EVENT )
	{
		class'UIAPI_WINDOW'.static.SetWindowSize( "RecipeManufactureWnd.texGrade", CRYSTAL_TYPE_WIDTH * 2, CRYSTAL_TYPE_HEIGHT );
	}
	else	//�������� ���� �������
	{
		class'UIAPI_WINDOW'.static.SetWindowSize( "RecipeManufactureWnd.texGrade", CRYSTAL_TYPE_WIDTH, CRYSTAL_TYPE_HEIGHT );
	}

	//������ �̸�
	ItemName = MakeFullItemName(ProductID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtName", ItemName);	
	
	//MP�Һ�
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMPConsume", "" $ nTmp);
	
	//����Ȯ��
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtSuccessRate", m_SuccessRate $ "%");

	handleAddSuccessNCritical();

	//�������
	ProductNum = class'UIDATA_RECIPE'.static.GetRecipeProductNum(RecipeID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtResultValue", "" $ ProductNum);
	
	//MP�� ǥ��
	//debug("CurrentMP" $CurrentMP);
	SetMPBar(CurrentMP);
	
	//��������
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtCountValue", "" $ string(GetInventoryItemCount(GetItemID(ProductID))));

	//���۰��
	strTmp = "";
	if (MakingResult == 0)
	{
		strTmp = MakeFullSystemMsg(GetSystemMessage(960), ItemName, "");
	}
	else if (MakingResult == 1)
	{
		if ( IsCreateCriticalSuccess == 0 ) 
			strTmp = MakeFullSystemMsg(GetSystemMessage(959), ItemName, "" $ ProductNum);
		else if ( IsCreateCriticalSuccess == 1 ) 
			strTmp = MakeFullSystemMsg(GetSystemMessage(959), ItemName, "" $ ProductNum *  2);
	}
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMsg", strTmp);
	
	//ItemWnd�� �߰�
	param = class'UIDATA_RECIPE'.static.GetRecipeMaterialItem(RecipeID);
	ParseInt(param, "Count", nTmp);
	for (i=0; i<nTmp; i++)
	{
		//Set ItemID
		ParseInt(param, "ID_" $ i, nTmp2);
		infItem.ID = GetItemID(nTmp2);
		
		class'UIDATA_ITEM'.static.GetItemInfo ( GetItemID(nTmp2) , infItem  );
		
		//NeedNum 
		ParseINT64(param, "NeededNum_" $ i, infItem.Reserved64);	
		infItem.ItemNum = GetInventoryItemCount(infItem.ID);
		if (infItem.Reserved64>infItem.ItemNum)
			infItem.bDisabled = 1;
		else
			infItem.bDisabled = 0;
		class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeBuyManufactureWnd.ItemWnd", infItem);
	}
}
/*
function ReceiveRecipeShopSellList (int merchantId, int RecipeID, int currentMP, int maxMP, int MakingResult, INT64 Adena, int IsCreateCriticalSuccess)
{
  Class'UIAPI_TEXTBOX'.SetText("RecipeBuyManufactureWnd.txtCountValue","" $ UnknownFunction796(Loge()));
  if ( ProductID )
  {
    strTmp = "";
    if ( MakingResult == 0 )
    {
      strTmp = MakeFullSystemMsg(GetSystemMessage(960),ItemName,"");
      goto JL04A0;
      if ( MakingResult == 1 )
      // There are 1 jump destination(s) inside the last statement!
      {
        if ( IsCreateCriticalSuccess == 0 )
        {
          strTmp = MakeFullSystemMsg(GetSystemMessage(959),ItemName,"" $ string(ProductNum));
          goto JL04A0;
          if ( IsCreateCriticalSuccess == 1 )
          // There are 1 jump destination(s) inside the last statement!
          {
            strTmp = MakeFullSystemMsg(GetSystemMessage(959),ItemName,"" $ string(ProductNum * 2));
            Class'UIAPI_TEXTBOX'.SetText("RecipeBuyManufactureWnd.txtMsg",strTmp);
            // There are 2 jump destination(s) inside the last statement!
          }
        }
      }
    }
    param = Class'UIDATA_RECIPE'.GetRecipeMaterialItem(RecipeID);
    ParseInt(param,"Count",nTmp);
    i = 0;
    if ( i < nTmp )
    {
      ParseInt(param,"ID_" $ string(i),nTmp2);
      infItem.Id = GetItemID(nTmp2);
      Class'UIDATA_ITEM'.GetItemInfo(GetItemID(nTmp2),infItem);
      ParseINT64(param,"NeededNum_" $ string(i),infItem.Reserved64);
      infItem.ItemNum = GetInventoryItemCount(infItem.Id);
      if ( infItem.Reserved64 > infItem.ItemNum )
      {
        infItem.bDisabled = 1;
        goto JL05E8;
        infItem.bDisabled = 0;
        // There are 1 jump destination(s) inside the last statement!
      }
      Class'UIAPI_ITEMWINDOW'.AddItem("RecipeBuyManufactureWnd.ItemWnd",infItem);
      i++;
      goto JL050C;
      return;

      // There are 1 jump destination(s) inside the last statement!
    }
}*/

//MP Bar
function SetMPBar(int CurrentMP)
{
	/*
	local int	nTmp;
	local int	nMPWidth;
	
	nTmp = RECIPEWND_MAX_MP_WIDTH * CurrentMP;
	nMPWidth = nTmp / m_MaxMP;
	if (nMPWidth>RECIPEWND_MAX_MP_WIDTH)
	{
		nMPWidth = RECIPEWND_MAX_MP_WIDTH;
	}
	class'UIAPI_WINDOW'.static.SetWindowSize("RecipeBuyManufactureWnd.texMPBar", nMPWidth, 12);
	*/
//	debug("MP STATUS" $m_MaxMP $" " $CurrentMP);
	MPBar.SetValue(m_MaxMP , CurrentMP);
}

//�κ��������� ������Ʈ�Ǹ� �������� ���纸������ �ٲ��ش�
function HandleInventoryItem(string param)
{
	local ItemID cID;
	local int idx;
	local ItemInfo infItem;	
	local int64 invenItemCount;

	//������ �ʿ� �� 
	local int64 needNum ;

	local string type ;

	if ( !IsShowWindow( m_WindowName ) ) return;

	if (ParseItemID( param, cID ))
	{
		needNum = 0;
		//�̺�Ʈ�� ���� �������� serverID ���� 0�̴�.
		//cID.serverID = 0;
		idx = m_ItemWnd.FindItemByClassID( cID );	// ClassID

		if (idx>-1)
		{
			m_ItemWnd.GetItem( idx, infItem);
			infItem.ItemNum = GetInventoryItemCount(infItem.ID);			

			if (infItem.Reserved64>infItem.ItemNum)
				infItem.bDisabled = 1;
			else
				infItem.bDisabled = 0;
			m_ItemWnd.SetItem( idx, infItem);
			needNum = infItem.Reserved64;
		}
		
		idx = m_TributeItemWnd.FindItem( cID );		
		
		if (idx>-1)
		{
			ParseString( param, "type", type );

			m_TributeItemWnd.GetItem( idx, infItem);
			
			if( type == "update" )
			{
				invenItemCount = GetInventoryItemCount(infItem.ID) - needNum;				
				if ( invenItemCount <= 0 ) 
				{
					m_TributeItemWnd.DeleteItem ( idx );
				}
				else if ( invenItemCount < infItem.ItemNum )
				{
					infItem.ItemNum = invenItemCount;
					m_TributeItemWnd.SetItem( idx, infItem);
				}	
			}
			else if( type == "delete" )
			{
				m_TributeItemWnd.DeleteItem ( idx ) ;
			}
			//add�� ���� �ʿ� ����
			else if( type == "add" ){}			

//			Debug ( "HandleInventoryItem" @ cID.serverID @ idx @ GetInventoryItemCount(infItem.ID));

			setOfferingRate() ;
		}
	}
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("RecipeBuyManufactureWnd").HideWindow();
}

defaultproperties
{
     m_WindowName="RecipeBuyManufactureWnd"
}
