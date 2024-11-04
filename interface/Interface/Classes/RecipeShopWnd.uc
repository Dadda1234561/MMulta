class RecipeShopWnd extends UICommonAPI;

const RECIPESHOP_MAX_ITEM_SELL = 20;

var int		m_ShopItemMaxCount_Dwarf;
var int		m_ShopItemMaxCount_Normal;

var int		m_BookItemCount;
var int		m_ShopItemCount;

var int		m_BookType;
var ItemInfo	m_HandleItem;

var bool isStartCraft;

function OnRegisterEvent()
{
	RegisterEvent( EV_RecipeShopShowWnd );
	RegisterEvent( EV_RecipeShopAddBookItem );
	RegisterEvent( EV_RecipeShopAddShopItem );
	RegisterEvent( EV_SetMaxCount );
	RegisterEvent( EV_DialogOK );
}

function OnLoad()
{
	SetClosingOnESC();
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
}

function OnShow()
{
	PlayConsoleSound(IFST_WORKSHOP_OPEN);

	// ������ �����츦 ������ �ݱ� ��� 
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)));
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnEnd":
		//class'RecipeAPI'.static.RequestRecipeShopManageQuit();
		CloseWindow();
		break;
	case "btnMsg":
		DialogSetEditBoxMaxLength(29);
		DialogShow(DialogModalType_Modalless,DialogType_OKCancelInput, GetSystemMessage(334), string(Self));
		DialogSetID(0);
		DialogSetString(class'UIDATA_PLAYER'.static.GetRecipeShopMsg());
		break;
	case "btnStart":
		
		StartRecipeShop();
		CloseWindow();
		break;
	case "btnMoveUp":
		HandleMoveUpItem();
		break;
	case "btnMoveDown":
		HandleMoveDownItem();
		break;
	}
}

function OnEvent(int Event_ID, string param)
{
	local string strPrice;
	
	local int RecipeID;
	local int CanbeMade;
	local INT64 MakingFee;
	local INT64 Price;
	if (Event_ID == EV_RecipeShopShowWnd)
	{
		Clear();
		
		//Show
		class'UIAPI_WINDOW'.static.ShowWindow("RecipeShopWnd");
		class'UIAPI_WINDOW'.static.SetFocus("RecipeShopWnd");
		
		//enum RecipeBookClass
		//{
		//	RBC_DWARF  = 0,	//������� �����Ǽ�
		//	RBC_NORMAL		//���� �����Ǽ�
		//};
		ParseInt(param, "Type", m_BookType);
		if (m_BookType == 1)
		{
			setWindowTitleBySysStringNum(1212);	
		}
		else
		{
			setWindowTitleBySysStringNum(1213);
		}
	}
	else if (Event_ID == EV_RecipeShopAddBookItem)
	{
		ParseInt( param, "RecipeID", RecipeID );
		AddRecipeBookItem( RecipeID );
	}
	else if (Event_ID == EV_RecipeShopAddShopItem)
	{
		ParseInt( param, "RecipeID", RecipeID );
		ParseInt( param, "CanbeMade", CanbeMade );
		ParseInt64( param, "MakingFee", MakingFee );
		AddRecipeShopItem( RecipeID, CanbeMade, MakingFee );
	}
	else if (Event_ID == EV_SetMaxCount)
	{
		HandleSetMaxCount(param);
	}
	else if (Event_ID == EV_DialogOK)
	{
		if (DialogIsMine())
		{	
			//�޽��� �Է�
			if (DialogGetID() == 0 )
			{
				class'RecipeAPI'.static.RequestRecipeShopMessageSet(DialogGetString());
			}
			else if (DialogGetID() == 1 )
			{
				//������ "0"���̶�, ���� �Է��� �� �־�߸� �������� �߰�
				strPrice = DialogGetString();
				if (Len(strPrice)>0)
				{
					//�Է��� ������ 20���� ������ ���� �ʰ� ������ �ѷ��ش�.
					Price = INT64(strPrice);
					if( Price >= INT64("1000000000000") )
					{
						DialogSetID(2);
						DialogShow(DialogModalType_Modalless,DialogType_Warning, GetSystemMessage(1369), string(Self));
					}
					else
					{
						m_HandleItem.Price = Price;
						UpdateShopItem(m_HandleItem);
					}
				}
				ClearHandleItem();
			}
		}
	}
}

//Frame�� "X"�� ������ �� (���� ���带 ����� �ʿ䰡 ����)
function OnSendPacketWhenHiding()
{
	//class'RecipeAPI'.static.RequestRecipeShopManageQuit();
	Clear();
}

//������ �ݱ�
function CloseWindow()
{
	Clear();
	class'UIAPI_WINDOW'.static.HideWindow("RecipeShopWnd");
	//class'RecipeAPI'.static.RequestRecipeShopManageQuit();
}

//ItemWindow���� Ŭ�� ó��
function OnDBClickItem( string strID, int index )
{
	local int Max;
	local int i;
	local ItemInfo infItem;
	local ItemInfo DeleteItem;
	
	ClearHandleItem();
	
	if (strID == "BookItemWnd" && m_BookItemCount>index)
	{
		class'UIAPI_ITEMWINDOW'.static.GetItem( "RecipeShopWnd.BookItemWnd", index, infItem);
			
		// �̹� �Ʒ��� �����ϴ� �������̶�� ��������� �Ѵ�. 
		Max = class'UIAPI_ITEMWINDOW'.static.GetItemNum( "RecipeShopWnd.ShopItemWnd");
		for (i=0; i<Max; i++)
		{
			if (class'UIAPI_ITEMWINDOW'.static.GetItem( "RecipeShopWnd.ShopItemWnd", i, DeleteItem))
			{
				if (IsSameClassID(DeleteItem.ID, infItem.ID))
				{
					DeleteShopItem(infItem);	// �ش�������� �����ϰ� �����Ѵ�. 
					return;
				}
			}
		}
			
		//������ ���ϵ��� �ʰ� �Ѿ�Դٸ�, ������ �Է��ϴ� â���� �̵�.		
		class'UIAPI_ITEMWINDOW'.static.GetItem( "RecipeShopWnd.BookItemWnd", index, infItem);
		ShowShopItemAddDialog(infItem);
	}
	//Shop���� ����Ŭ���� �ϸ� ���̾�αװ� ��Ÿ���� ������ �Է�������, �����δ� �ƹ��� �۵��� �����ʴ´�.(���� �̷���)
	//���� �̷��� �ƴѰ����ϴ�. TTP�� ����Գ׿�. �Ʒ��κп��� ����Ŭ���ϸ� �������� �����մϴ�. -innowind
	else if (strID == "ShopItemWnd" && m_ShopItemCount>index)
	{
		class'UIAPI_ITEMWINDOW'.static.GetItem( "RecipeShopWnd.ShopItemWnd", index, infItem);
		DeleteShopItem(infItem);	// �ش�������� �����Ѵ�. 
		//ShowShopItemAddDialog(infItem);
	}
}

//������ ��� ó��
function OnDropItem( string strID, ItemInfo infItem, int x, int y)
{
	if (strID == "BookItemWnd")
	{
		if (infItem.DragSrcName == "ShopItemWnd")
		{
			//Shop���� Book���� ����� ���, Shop�� �������� �����Ѵ�.
			DeleteShopItem(infItem);
		}
	}
	else if (strID == "ShopItemWnd")
	{
		if (infItem.DragSrcName == "BookItemWnd")
		{
			//Book���� Shop���� ����� ���, Shop�� �������� �߰��Ѵ�.
			ShowShopItemAddDialog(infItem);
		}
	}
}

//�ʱ�ȭ
function Clear()
{
	ClearHandleItem();	
	m_BookItemCount = 0;
	m_ShopItemCount = 0;
	UpdateShopItemCount(0);
	
	class'UIAPI_ITEMWINDOW'.static.Clear("RecipeShopWnd.BookItemWnd");
	class'UIAPI_ITEMWINDOW'.static.Clear("RecipeShopWnd.ShopItemWnd");
}

//Handle������ Ŭ����
function ClearHandleItem()
{
	local ItemInfo ItemClear;
	m_HandleItem = ItemClear;
}

//�����Ǽ� ������ �߰�
function AddRecipeBookItem(int RecipeID)
{
	local ItemInfo	infItem;
	local int		ProductID;
	
	//Product ID
	ProductID = class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	
	//����������
	infItem.ID = class'UIDATA_RECIPE'.static.GetRecipeItemID(RecipeID);
	infItem.Level = class'UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
	
	infItem.Name = class'UIDATA_ITEM'.static.GetItemName(infItem.ID);
	infItem.Description = class'UIDATA_ITEM'.static.GetItemDescription(infItem.ID);
	infItem.Weight = class'UIDATA_ITEM'.static.GetItemWeight(infItem.ID);

	//���깰����
	infItem.IconName = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ProductID));
	infItem.CrystalType = class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
	
	//ItemWnd�� �߰�
	class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeShopWnd.BookItemWnd", infItem);
	
	m_BookItemCount++;
}

//�̹� �����  ������ �߰�
function AddRecipeShopItem(int RecipeID, int CanbeMade, INT64 MakingFee)
{
	local ItemInfo	infItem;
	local int		ProductID;
	
	//Product ID
	ProductID = class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	
	//����������
	infItem.ID = class'UIDATA_RECIPE'.static.GetRecipeItemID(RecipeID);
	infItem.Level = class'UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
	infItem.Price = MakingFee;
	infItem.Reserved = CanbeMade;
	
	infItem.Name = class'UIDATA_ITEM'.static.GetItemName(infItem.ID);
	infItem.Description = class'UIDATA_ITEM'.static.GetItemDescription(infItem.ID);
	infItem.Weight = class'UIDATA_ITEM'.static.GetItemWeight(infItem.ID);

	//���깰����
	infItem.IconName = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ProductID));
	infItem.CrystalType = class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
	
	//ItemWnd�� �߰�
	class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeShopWnd.ShopItemWnd", infItem);
	
	m_ShopItemCount++;
	UpdateShopItemCount(m_ShopItemCount);
}

//�����Ǽ��� ������ �߰� ���̾�α� �ڽ� ǥ��
function ShowShopItemAddDialog(ItemInfo AddItem)
{
	m_HandleItem = AddItem;
	DialogSetID(1);
	DialogSetParamInt64(-1);
	DialogSetDefaultOK();	
	DialogShow(DialogModalType_Modalless,DialogType_NumberPad, GetSystemMessage(963), string(Self));
}

//�����Ǽ��� ������ �߰�
function UpdateShopItem(ItemInfo AddItem)
{
	local int		i;
	local int		Max;
	local ItemInfo	infItem;
	local bool		bDuplicated;
	
	bDuplicated = false;
	
	Max = class'UIAPI_ITEMWINDOW'.static.GetItemNum( "RecipeShopWnd.ShopItemWnd");
	for (i=0; i<Max; i++)
	{
		if (class'UIAPI_ITEMWINDOW'.static.GetItem( "RecipeShopWnd.ShopItemWnd", i, infItem))
		{
			if (IsSameClassID(AddItem.ID, infItem.ID))
			{
				bDuplicated = true;
				break;
			}
		}
	}
	if (!bDuplicated)
	{
		class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeShopWnd.ShopItemWnd", AddItem);
		m_ShopItemCount++;
		UpdateShopItemCount(m_ShopItemCount);
	}
}

//�����Ǽ��� ������ ����
function DeleteShopItem(ItemInfo DeleteItem)
{
	local int		i;
	local int		Max;
	local ItemInfo	infItem;
	
	Max = class'UIAPI_ITEMWINDOW'.static.GetItemNum( "RecipeShopWnd.ShopItemWnd");
	for (i=0; i<Max; i++)
	{
		if (class'UIAPI_ITEMWINDOW'.static.GetItem( "RecipeShopWnd.ShopItemWnd", i, infItem))
		{
			if (IsSameClassID(DeleteItem.ID, infItem.ID))
			{
				class'UIAPI_ITEMWINDOW'.static.DeleteItem( "RecipeShopWnd.ShopItemWnd", i);
				m_ShopItemCount--;
				UpdateShopItemCount(m_ShopItemCount);
				break;
			}
		}
	}
}

//��ϵ� ������ ���� ����
function UpdateShopItemCount(int Count)
{
	if (m_BookType == 1)
	{
		class'UIAPI_TEXTBOX'.static.SetText("RecipeShopWnd.txtCount", "(" $ Count $ "/" $ m_ShopItemMaxCount_Normal $ ")");	
	}
	else
	{
		class'UIAPI_TEXTBOX'.static.SetText("RecipeShopWnd.txtCount", "(" $ Count $ "/" $ m_ShopItemMaxCount_Dwarf $ ")");	
	}		
}

//�����Ǽ� ����
function StartRecipeShop()
{
	local int		i;
	local int		Max;
	local ItemInfo	infItem;
	
	local string	param;
	local INT64		Price;
	
	Max = class'UIAPI_ITEMWINDOW'.static.GetItemNum( "RecipeShopWnd.ShopItemWnd");
	ParamAdd(param, "Max", string(Max));
	
	for (i=0; i<Max; i++)
	{
		Price = 0;
		if (class'UIAPI_ITEMWINDOW'.static.GetItem( "RecipeShopWnd.ShopItemWnd", i, infItem))
		{
			Price = infItem.Price;
		}
		ParamAddItemIDWithIndex(param, infItem.ID, i);
		ParamAdd(param, "Price_" $ i, string(Price));
	}

	isStartCraft = true;
	class'RecipeAPI'.static.RequestRecipeShopListSet( param );
}

//������ ��
function HandleMoveUpItem()
{
	local ItemInfo infItem;
	
	if (class'UIAPI_ITEMWINDOW'.static.GetSelectedItem( "RecipeShopWnd.ShopItemWnd", infItem))
	{
		DeleteShopItem(infItem);
	}
}

//������ �ٿ�
function HandleMoveDownItem()
{
	local ItemInfo infItem;
	
	if (class'UIAPI_ITEMWINDOW'.static.GetSelectedItem( "RecipeShopWnd.BookItemWnd", infItem))
	{
		ShowShopItemAddDialog(infItem);
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

function onHide()
{
	PlayConsoleSound(IFST_WORKSHOP_CLOSE);

	//���� (��ư Ŭ��) ���� �� ���� ��� �̺�Ʈ�� ���� �ʵ��� ����
	//���� �ʿ��� ���� ó�� �Ǵ� ���� �α� ���� ������ Ǯ���ٰ� ��.
	if ( !isStartCraft ) class'RecipeAPI'.static.RequestRecipeShopManageQuit();
	isStartCraft = false;
}

function HandleSetMaxCount( string param )
{
	ParseInt( param, "dwarvenRecipeShop", m_ShopItemMaxCount_Dwarf );	
	ParseInt(param, "recipeShop", m_ShopItemMaxCount_Normal);
}

defaultproperties
{
}
