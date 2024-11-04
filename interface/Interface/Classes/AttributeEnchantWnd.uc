class AttributeEnchantWnd extends UICommonAPI;

const DIALOG_ASK_ITEM_COUNT                         = 55555;
const DIALOG_ENCHANT_COMPLETE                       = 55556;

//Handle List
var WindowHandle		Me;
var WindowHandle        DisableWnd;
var ItemWindowHandle	itemWnd;
var	ItemWindowHandle	InventoryItemHandle;
var TextBoxHandle	    TextBox;
var TextBoxHandle	    ItemCountTextBox;
var ButtonHandle		OkButton;
var ButtonHandle        AttributeCountEditBtn;


// ���� ���
var ItemInfo 		    SelectItemInfo;		    // ������ ������
var ItemInfo 		    ResourceInfo;		    // ��� ������
var int 			    ScrollCID;			    // ��ũ���� ������ �����Ѵ�. 
var INT64               LoopEnchantItemCount;   // �ݺ���ų �ִ� ����
var INT64               ResourceItemCount;      // ��� ������ ��ø ����
var int                 ItemClassID;

var EditBoxHandle    AttributeCountEditBox;
function OnRegisterEvent()
{
	RegisterEvent( EV_AttributeEnchantItemShow );
	RegisterEvent( EV_EnchantHide );
	RegisterEvent( EV_AttributeEnchantItemList );
	RegisterEvent( EV_AttributeEnchantResult );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
}

function OnLoad()
{
	SetClosingOnESC();

	DisableWnd = GetWindowHandle( "AttributeEnchantWnd.DisableWnd" );
	
	Me = GetWindowHandle( "AttributeEnchantWnd" );
	itemWnd = GetItemWindowHandle( "AttributeEnchantWnd.ItemWnd" );
	TextBox = GetTextBoxHandle( "AttributeEnchantWnd.txtScrollName" );
	OkButton = GetButtonHandle( "AttributeEnchantWnd.btnOK" );	
	AttributeCountEditBtn = GetButtonHandle( "AttributeEnchantWnd.AttributeCountEditBtn" );
	AttributeCountEditBox = GetEditBoxHandle( "AttributeEnchantWnd.AttributeCountEditBox" );
	InventoryItemHandle = GetItemWindowHandle( "InventoryWnd.InventoryItem" );
	ItemCountTextBox = GetTextBoxHandle( "AttributeEnchantWnd.itemCountTxt" );

	AttributeCountEditBox.SetMaxLength(6);
}

function onShow()
{
	// ������ �����츦 ������ �ݱ� ���  
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)), "InventoryWnd");
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_AttributeEnchantItemShow)
	{
		// �Ӽ� ���� â�� ���������� �Ӽ� ��þƮ�� ���ϰ� ���´�.
		if( class'UIAPI_WINDOW'.static.IsShowWindow("AttributeRemoveWnd") )	
		{	
			// �� �Ӽ� ��þƮ�� â�� �������� �ȳ�
			AddSystemMessage(3161);	
			OnCancelClick();
		}
		else
		{
			HandleAttributeEnchantShow(param);	
		}
	}
	else if (Event_ID == EV_EnchantHide)
	{
		HandleAttributeEnchantHide();
	}
	else if (Event_ID == EV_AttributeEnchantItemList)
	{
		HandleAttributeEnchantItemList(param);
	}
	else if (Event_ID == EV_AttributeEnchantResult)
	{
		HandleAttributeEnchantResult(param);
	}
	else if(Event_ID == EV_DialogOK)
	{
		HandleDialogOK();
	}
	else if(Event_ID == EV_DialogCancel)
	{
		HandleDialogCancel();
	}
}

function HandleDialogOK()
{
	local int id;
	local ItemID scID;
	local ItemInfo scInfo;
	local INT64 inputNum;

	if( DialogIsMine() )
	{
		id = DialogGetID();
	
		inputNum = INT64( DialogGetString() );

		if(ResourceItemCount < inputNum)
			inputNum = ResourceItemCount;
		scID = DialogGetReservedItemID();
		DialogGetReservedItemInfo(scInfo);
		
		if (id == DIALOG_ASK_ITEM_COUNT)
		{
			AttributeCountEditBox.SetString(String(inputNum));
			if(ResourceItemCount < inputNum)
				inputNum = ResourceItemCount;

			LoopEnchantItemCount = inputNum;
		}
	}
	
	DisableCurrentWindow(false);
} 

/** Desc : ���̾�α� �����츦 ���� Cancel ��ư ���� ��� */
function HandleDialogCancel()
{
	if( DialogIsMine() )
	{
		DisableCurrentWindow(false);
	}
	//Me.HideWindow();
	// �ٸ� ���̾�αװ� ĵ�� �Ǿ������� ��Ȱ��ȭ�� Ǯ��� �Ѵ�.
//	DisableCurrentWindow(false);
}

//�׼��� Ŭ��
function OnClickItem( string strID, int index )
{	
	if (strID == "ItemWnd")
	{		
		OkButton.EnableWindow();
	}
}

function OnClickButton( string strID )
{
	local INT64 itemCount;
	
	itemCount = Int64(AttributeCountEditBox.GetString());

	switch( strID )
	{
	case "btnOK":
		DisableCurrentWindow(true);
		if(ResourceItemCount < Int64(AttributeCountEditBox.GetString()))
			itemCount = ResourceItemCount;
		AttributeCountEditBox.SetString(String(itemCount));
		LoopEnchantItemCount = itemCount;
		OnOkClickProgress();
		break;
	case "btnCancel":
		OnCancelClick();
		break;
	case "AttributeCountEditBtn":
		CountBtnClick();
		break;
	}
}


function CountBtnClick()
{
	local ItemInfo info;
	
	if (itemWnd.GetItemNum() > 0)
	{
		itemWnd.GetItem(0, info);

		// Ask price
		DialogSetID( DIALOG_ASK_ITEM_COUNT);
		DialogSetReservedItemID( info.ID );				// ServerID
		//DialogSetReservedInt3( int(bAllItem) );		// ��ü�̵��̸� ���� ���� �ܰ踦 �����Ѵ�
		DialogSetEditType("number");
		DialogSetEditBoxMaxLength(6);
		DialogSetParamInt64( ResourceItemCount );
		DialogSetDefaultOK();
		debug(GetSystemMessage(4142));
		DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4142), string(Self) );	
		DisableCurrentWindow(true);
	}
}

function OnOkClickProgress()
{	
	local ProgressBox script;
	
	// ������ �������� ������ �޾ƿ´�. 
	itemWnd.GetSelectedItem(SelectItemInfo);

	if(SelectItemInfo.ID.ClassID != 0)	// ���õ� �������� ���� ��츸 ����
	{
		if(IsShowWindow("ItemEnchantWnd"))	//������ ��þƮ�� ���� ���ִٸ� ��æƮ�� �����Ű�� �ʴ´�. 
		{
			AddSystemMessage(2188);
			DisableCurrentWindow(false);
		}
		// ���� ���� c++ �ڵ�κ�
// enum AttributeResult
// {
// 	ATTR_ENCHAN_POSSIBLE,
// 	ATTR_ENCHAN_OPPOSITE_ATTR,
// 	ATTR_ENCHAN_MAX_NUM_WEAPON,
// 	ATTR_ENCHAN_MAX_NUM_ARMOR,
// 	ATTR_ENCHAN_MAX_ATTR,
// 	ATTR_ENCHAN_IMPOSSIBLE,
// 	ATTR_ENCHAN_FULL //3�Ӽ��� ��á��
// };
		else if(SelectItemInfo.Reserved != 0) //��æ�Ҽ� ���� �������̶��
		{
			if(SelectItemInfo.Reserved == 1)
				AddSystemMessage(3117);			
			if(SelectItemInfo.Reserved == 2)
				AddSystemMessage(3154);			
			if(SelectItemInfo.Reserved == 4)
				AddSystemMessage(3153);			
			if(SelectItemInfo.Reserved == 6)
				AddSystemMessage(3155);			

			DisableCurrentWindow(false);
		}

		else
		{
			// ���α׷��� �ٸ� ����ش�. 
			//Me.HideWindow();			
			script = ProgressBox( GetScript("ProgressBox") );
			script.Initialize();
			script.ShowDialog(MakeFullSystemMsg(GetSystemMessage(4140), ResourceInfo.Name, String(LoopEnchantItemCount), SelectItemInfo.Name), "AttributeEnchantWnd", 2000, ResourceInfo, SelectItemInfo);
		}
	}
}

function OnOKClick()
{
	//class'EnchantAPI'.static.RequestEnchantItemAttribute(SelectItemInfo.ID);
	class'EnchantAPI'.static.RequestEnchantItemAttribute(SelectItemInfo.ID, LoopEnchantItemCount);
}


function OnHide()
{
	local ItemID ID;
	
	ID = GetItemID(-1);
	//debug("request attribute cancle");
	class'EnchantAPI'.static.RequestEnchantItemAttribute(ID, LoopEnchantItemCount);
	Clear();
}

function OnCancelClick()
{
	Me.HideWindow();	
}

function Clear()
{
	itemWnd.Clear();
}

function HandleAttributeEnchantShow(string param)
{
	local ItemID cID;
	local INT64 count;
	Clear();
	ParseItemID(param, cID);
	ParseINT64(param, "ItemCount", count);
	ResourceItemCount = count;
	ScrollCID = cID.ClassID;				// ��ũ�� ���̵� ����
	TextBox.SetText(class'UIDATA_ITEM'.static.GetItemName(cID));
	ItemClassID = cID.ClassID;	

	class'UIDATA_ITEM'.static.GetItemInfo( cID, ResourceInfo );	

	ItemCountTextBox.SetText("x");
	AttributeCountEditBox.SetString("1");
	OkButton.DisableWindow();				// ó�� �ѷ��� ���� �������� �������� �ʾұ� ������ ������ Ȯ�� ��ư�� disable �����ش�. 

	Me.ShowWindow();
	Me.SetFocus();
	DisableCurrentWindow(false);
}

function DisableCurrentWindow(bool bFlag)
{
	if (bFlag)
	{
		DisableWnd.EnableWindow();
		DisableWnd.ShowWindow();
	}
	else 
	{
		DisableWnd.DisableWindow();
		DisableWnd.HideWindow();
	}
}

function HandleAttributeEnchantHide()
{
	//Me.HideWindow();
	//Clear();
}

// ���� ���� c++ �ڵ�κ�
// enum AttributeResult
// {
// 	ATTR_ENCHAN_POSSIBLE,
// 	ATTR_ENCHAN_OPPOSITE_ATTR,
// 	ATTR_ENCHAN_MAX_NUM_WEAPON,
// 	ATTR_ENCHAN_MAX_NUM_ARMOR,
// 	ATTR_ENCHAN_MAX_ATTR,
// 	ATTR_ENCHAN_IMPOSSIBLE,
// 	ATTR_ENCHAN_FULL //3�Ӽ��� ��á��
// };

function HandleAttributeEnchantItemList(string param)
{
	local ItemInfo infItem;
	local int Ispossible;
	ParseInt(param, "Ispossible", Ispossible);
	ParamToItemInfo(param, infItem);
	infItem.Reserved = Ispossible;
	
	//debug("Name :" $ infItem.Name $ " SlotBitType: "  $ infItem.SlotBitType $ " ShieldDefense : " $ infItem.ShieldDefense $ " CrystalType :"  $infItem.CrystalType);
	
	// item ������ �Ǵ��Ͽ� ��� ������ �����۸� insert �Ѵ�.  - ģ���� UI��å ^^ - innowind 
	// S�� �̻��� ����/ ���� �Ӽ� ��æƮ ����
	
	//itemWnd.AddItem(infItem);	// �������� �˾Ƽ� �ɷ��ִ°� ������ �Ʒ� �ڵ�� �ʿ� ����.
	
	//S�� �̻��� �����۸� �߰�. S80�� ���� �ε�ȣ�� ����Ͽ���. 
	//���д� �����Ѵ�. ���е� itemType�� 1�� ������ ������ shieldDefense ������ ���.
	// End:0xC3
	if( !infItem.bSecurityLock &&  (infItem.CrystalType > 4) && (infItem.SlotBitType != 268435456) && (infItem.SlotBitType != 1))
	{
		// End:0xAF
		if(Ispossible == 0) //ATTR_ENCHAN_POSSIBLE
			itemWnd.AddItem(infItem);
		else
			itemWnd.AddItemWithFaded(infItem);
	}
}

function String GetPropString(int id)
{
	switch(id)
	{
		case 9546:
			return GetSystemString(2753);
		break;
		case 9547:
			return GetSystemString(2754);
		break;
		case 9549:
			return GetSystemString(2755);
		break;
		case 9548:
			return GetSystemString(2756);
		break;
		case 9551:
			return GetSystemString(2757);
		break;
		case 9550:
			return GetSystemString(2758);
		break;
	}
}


function HandleAttributeEnchantResult(string param)
{	
	local int result, isWeapon, attrType, beforeAttrValue, afterAttrValue, failCount;
	local INT64 successCount;
	local ItemInfo iInfo;
	
	ParseInt(param, "Result", result);
	ParseInt(param, "IsWeapon", isWeapon);
	ParseInt(param, "AttrType", attrType);
	ParseInt(param, "BeforeAttrValue", beforeAttrValue);
	ParseInt(param, "AfterAttrValue", afterAttrValue);
	ParseInt(param, "FailCount", failCount);
	ParseINT64(param, "SuccessCount", successCount);

	//class'EnchantAPI'.static.RequestEnchantItemAttribute(SelectItemInfo.ID);

	InventoryItemHandle.GetItem(InventoryItemHandle.FindItem( ResourceInfo.ID ), iInfo);//d
	
	if(result != 2)
	{
		DialogSetID( DIALOG_ENCHANT_COMPLETE );
		DialogShowWithResize(DialogModalType_Modalless, DialogType_OK, 
	    MakeFullSystemMsg(GetSystemMessage(4141), 		
		ResourceInfo.Name,                                         //���ҽ� ������ �̸�
		String(LoopEnchantItemCount),                              //�ݺ�����
	    String(successCount),                                      //����Ƚ��
		String(failCount),                                         //����Ƚ��
		string(LoopEnchantItemCount - (successCount + failCount))),//��������
		-1, 260, string(Self));					  
	}
	
	DisableCurrentWindow(false);
	//����� ������� ������ Hide*/
	Me.HideWindow();
	Clear();
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);		
	HandleAttributeEnchantHide();
	OnCancelClick();
}

defaultproperties
{
}
