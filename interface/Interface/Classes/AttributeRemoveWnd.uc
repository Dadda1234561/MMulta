class AttributeRemoveWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle txtRemoveAdenaStr;
var TextBoxHandle txtRemoveAdena;
var TextBoxHandle txtItemSelectStr;
var ItemWindowHandle itemWnd;
var TextureHandle ItemWndBg;
var TextureHandle txtRemoveAdenaBg;
var TextureHandle ItemWndScrollBg;
var ButtonHandle btnOK;
var ButtonHandle btnCancel;

var ButtonHandle btnHideBarButton0;             // ������ �Ӽ� ���� ���� 3���� ���� ��ư  
var ButtonHandle btnHideBarButton1;
var ButtonHandle btnHideBarButton2;

var Tooltip toolTipScript;                      // ������ ���ǵ� �Ӽ� �޼ҵ� ����� ���ؼ�..

// �� �Ӽ��� ǥ���� ������ ��Ʈ�� 
var BarHandle gageAttributeSelect0;
var BarHandle gageAttributeSelect1;
var BarHandle gageAttributeSelect2;

var CheckBoxHandle btnAttributeSelect0;
var CheckBoxHandle btnAttributeSelect1;
var CheckBoxHandle btnAttributeSelect2;

var TextBoxHandle txtAttributeSelect0;
var TextBoxHandle txtAttributeSelect1;
var TextBoxHandle txtAttributeSelect2;

var ItemInfo 	  SelectItemInfo;		        // ������ ������
var Array<string> tooltipStr;
var Array<string> attributeWord;
var Array<int>    attributerTypeRadio;
var Array<int>    memoryAttributeSelectedRadio; // ���� ���õ� ���� ��ư�� ��ġ�� ��� ��Ų��.

var int beforeClickedItem;                      // ������ Ŭ���� �Ӽ� ���� ������ ��ȣ
var int radioButtonCount;


const DIALOG_ATTRIBUTE_REMOVE = 9001;
const EQUIPITEM_Max = 37;				        // ���� �������� MAX����

const ATTRIBUTE_FIRE 	= 0;
const ATTRIBUTE_WATER 	= 1;
const ATTRIBUTE_WIND 	= 2;
const ATTRIBUTE_EARTH 	= 3;
const ATTRIBUTE_HOLY 	= 4;
const ATTRIBUTE_UNHOLY 	= 5;

var InventoryWnd script;                        //���� ���̵� ������ ������ ������ �ޱ� ���� �κ��丮 ��ũ��Ʈ�� �����´�. 


/****************************************************************************************************
 * 
 *  ���� ����
 *  
 ****************************************************************************************************/

/** onLoad */
function OnLoad()
{
	SetClosingOnESC();

	Initialize();

	// �Ӽ� ���������� �ʱ�ȭ �ϰ� , �Ⱥ��̰� �Ѵ�.
	initAttributeElements(false);
}

/** OnShow */
function OnShow()
{
	// ������ �����츦 ������ �ݱ� ��� 
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)), "InventoryWnd");
 
	initAttributeElements(false); 
}

/** OnRegisterEvent */
function OnRegisterEvent()
{
	RegisterEvent( EV_RemoveAttributeEnchantWndShow );
	RegisterEvent( EV_RemoveAttributeEnchantItemData );
	RegisterEvent( EV_RemoveAttributeEnchantResult );

	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
}

/** OnEvent */
function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_RemoveAttributeEnchantWndShow)
	{
		// IsShowWindow
		// �Ӽ� ��þƮ â�� ���� �ִٸ� ���� �ʴ´�.
		if( class'UIAPI_WINDOW'.static.IsShowWindow("AttributeEnchantWnd") )			// ���� ���� â�� �������� �ִٸ� ������Ʈ ���ش�.
		{
			AddSystemMessage(3161);
		}
		else
		{
			HandleAttributeRemoveShow(param);			
		}		
	}
	else if (Event_ID == EV_RemoveAttributeEnchantItemData)
	{
		HandleAttributeRemoveItemData(param);
	}
	else if (Event_ID == EV_RemoveAttributeEnchantResult)
	{
		HandleAttributeRemoveResult(param); 
	}
	else if	 (Event_ID == EV_DialogOK)
	{
		HandleDialogOK();
	}
	else if	 (Event_ID == EV_DialogCancel)
	{
		Me.EnableWindow();
	}
}

/** �Ӽ� ����, �ݱ� ��ư �� ó�� */
function OnClickButton( string Name )
{
	switch( Name )
	{
		// �Ӽ� ����
		case "btnOK":
			OnbtnOKClick();
			break;
		
		// �ݱ� 
		case "btnCancel":
			OnbtnCancelClick();
			break;
		
		// ���� ��ư ó�� 
		case "btnListSelect0":
			if (gageAttributeSelect0.IsShowWindow()) setRadioButton(0);
			break;
		case "btnListSelect1":
			if (gageAttributeSelect1.IsShowWindow()) setRadioButton(1);
			break;
		case "btnListSelect2":
			if (gageAttributeSelect2.IsShowWindow()) setRadioButton(2);
			break;
	}
}

/** Init */
function Initialize()
{
	if(CREATE_ON_DEMAND==0)
	{
		OnRegisterEvent();
	}

	Me = GetWindowHandle( "AttributeRemoveWnd" );
	txtRemoveAdenaStr = GetTextBoxHandle ( "AttributeRemoveWnd.txtRemoveAdenaStr" );
	txtRemoveAdena = GetTextBoxHandle ( "AttributeRemoveWnd.txtRemoveAdena" );
	txtItemSelectStr = GetTextBoxHandle ( "AttributeRemoveWnd.txtItemSelectStr" );
	itemWnd = GetItemWindowHandle ("AttributeRemoveWnd.ItemWnd" );
	ItemWndBg = GetTextureHandle ( "AttributeRemoveWnd.ItemWndBg" );
	txtRemoveAdenaBg = GetTextureHandle ( "AttributeRemoveWnd.txtRemoveAdenaBg" );
	ItemWndScrollBg = GetTextureHandle ( "AttributeRemoveWnd.ItemWndScrollBg" );
	btnOK = GetButtonHandle ( "AttributeRemoveWnd.btnOK" );
	btnCancel = GetButtonHandle ( "AttributeRemoveWnd.btnCancel" );

	btnHideBarButton0 = GetButtonHandle ( "AttributeRemoveWnd.btnListSelect0" );
	btnHideBarButton1 = GetButtonHandle ( "AttributeRemoveWnd.btnListSelect1" );
	btnHideBarButton2 = GetButtonHandle ( "AttributeRemoveWnd.btnListSelect2" );

	gageAttributeSelect0 = GetBarHandle ( "AttributeRemoveWnd.gageAttributeSelect0" );
	gageAttributeSelect1 = GetBarHandle ( "AttributeRemoveWnd.gageAttributeSelect1" );
	gageAttributeSelect2 = GetBarHandle ( "AttributeRemoveWnd.gageAttributeSelect2" );

	btnAttributeSelect0 = GetCheckBoxHandle( "AttributeRemoveWnd.btnAttributeSelect0" ); 
	btnAttributeSelect1 = GetCheckBoxHandle( "AttributeRemoveWnd.btnAttributeSelect1" ); 
	btnAttributeSelect2 = GetCheckBoxHandle( "AttributeRemoveWnd.btnAttributeSelect2" ); 

	txtAttributeSelect0 = GetTextBoxHandle ( "AttributeRemoveWnd.txtAttributeSelect0" ); 
	txtAttributeSelect1 = GetTextBoxHandle ( "AttributeRemoveWnd.txtAttributeSelect1" ); 
	txtAttributeSelect2 = GetTextBoxHandle ( "AttributeRemoveWnd.txtAttributeSelect2" ); 

	script = InventoryWnd( GetScript("InventoryWnd") );
	toolTipScript = Tooltip( GetScript( "Tooltip" ) );
	
	attributeWord[0] = "Fire";
	attributeWord[1] = "Water";
	attributeWord[2] = "Wind";
	attributeWord[3] = "Earth";
	attributeWord[4] = "Divine";
	attributeWord[5] = "Dark";

	beforeClickedItem = -1;
	// btnCancel.SetAlpha(0);	
}

/** �Ӽ� ���� ���� ��ư�� ������, �ؽ�Ʈ���� �ʱ�ȭ, ���̰� �Ⱥ��̱� ���� */
function initAttributeElements(bool visibleFlag)
{
	txtRemoveAdena.SetText("");

	gageAttributeSelect0.Clear();
	gageAttributeSelect1.Clear();
	gageAttributeSelect2.Clear();

	txtAttributeSelect0.SetText(""); 
	txtAttributeSelect1.SetText(""); 
	txtAttributeSelect2.SetText("");

	btnAttributeSelect0.SetCheck(false);
	btnAttributeSelect1.SetCheck(false);
	btnAttributeSelect2.SetCheck(false);

	if (visibleFlag == false)
	{
		btnAttributeSelect0.HideWindow();
		btnAttributeSelect1.HideWindow();
		btnAttributeSelect2.HideWindow();

		gageAttributeSelect0.HideWindow();
		gageAttributeSelect1.HideWindow();
		gageAttributeSelect2.HideWindow();

		txtAttributeSelect0.HideWindow();
		txtAttributeSelect1.HideWindow(); 
		txtAttributeSelect2.HideWindow();		
	}
	else
	{
		btnAttributeSelect0.ShowWindow();
		btnAttributeSelect1.ShowWindow();
		btnAttributeSelect2.ShowWindow();

		gageAttributeSelect0.ShowWindow();
		gageAttributeSelect1.ShowWindow();
		gageAttributeSelect2.ShowWindow();

		txtAttributeSelect0.ShowWindow();
		txtAttributeSelect1.ShowWindow(); 
		txtAttributeSelect2.ShowWindow();	
	}
}

/****************************************************************************************************
 * 
 *  �Ӽ� ���� ���� �Լ�
 *  
 ****************************************************************************************************/

/** �Ӽ� ��ȣ�� ������ �ش� �Ӽ� ��Ʈ���� ���� �Ѵ�. */
function string getAttributeNumToStr(int num)
{
	local string returnStr;
	returnStr = "";

	switch(num)
	{
		case ATTRIBUTE_FIRE:
			returnStr = GetSystemString(1622);
			break;
		case ATTRIBUTE_WATER:
			returnStr = GetSystemString(1623);
			break;
		case ATTRIBUTE_WIND:
			returnStr = GetSystemString(1624);
			break;
		case ATTRIBUTE_EARTH:
			returnStr = GetSystemString(1625);
			break;
		case ATTRIBUTE_HOLY:
			returnStr = GetSystemString(1626);
			break;
		case ATTRIBUTE_UNHOLY:
			returnStr = GetSystemString(1627);
			break;
		default :
			debug("UC Error : �߸��� �Ӽ� Ÿ�� ��ȣ�� getAttributeNumToStr �޼ҵ忡 �����Ͽ����ϴ�.");
	}

	return returnStr;
}

/** 
 *  �Ӽ��� ������ Ŭ���̾�Ʈ �Լ��� ȣ�� �Ѵ�. 
 *  ������ ��ȣ�� �Ű������� �Է�  
 **/
function applyAttribute(int attributeNum)
{
	// ������ �������� ������ �޾ƿ´�. 
	itemWnd.GetSelectedItem(SelectItemInfo);

	if(SelectItemInfo.AttackAttributeValue > 0) 
	{
		// ������
		class'EnchantAPI'.static.RequestRemoveAttribute(SelectItemInfo.ID, SelectItemInfo.AttackAttributeType);	
	}
	else
	{
		// �����
		class'EnchantAPI'.static.RequestRemoveAttribute(SelectItemInfo.ID, attributeNum);

		// debug(" == > att " $ attributeNum);

	}
}


/****************************************************************************************************
 * 
 *  �Ӽ� ���� ���� UI �޼ҵ� 
 *  
 ****************************************************************************************************/

/** �Ӽ� ������ Ŭ���� ���  */
function OnBtnOkClick()
{
	local string strName;
	local int attributeTypeByRadio;
	local int currentAttributerTypeRadio;

	strName = class'UIDATA_ITEM'.static.GetItemName( SelectItemInfo.ID );


	debug("==> Attack: " @ SelectItemInfo.AttackAttributeValue);
	Debug("==> strName" @ strName);

	attributeTypeByRadio = attributerTypeRadio[getRadioButtonSelected()];

	if(SelectItemInfo.AttackAttributeValue > 0) 
	{
		debug("==> call  " @ SelectItemInfo.AttackAttributeValue);
		currentAttributerTypeRadio = attributeTypeByRadio;
	}
	else
	{
		debug("==> def attributeTypeByRadio  " @ attributeTypeByRadio);
		// �ݴ� �Ӽ� ��Ʈ�� ���� ������ ����, (��: ���� �� ������ ��� �� �Ӽ��� ���� ���� ����)
		if (attributeTypeByRadio == 0)
		{
			currentAttributerTypeRadio = 1;
		}
		else if (attributeTypeByRadio == 1)
		{
			currentAttributerTypeRadio = 0;
		}
		else if (attributeTypeByRadio == 2)
		{
			currentAttributerTypeRadio = 3;
		}
		else if (attributeTypeByRadio == 3)
		{
			currentAttributerTypeRadio = 2;
		}
		else if (attributeTypeByRadio == 4)
		{
			currentAttributerTypeRadio = 5;
		}
		else if (attributeTypeByRadio == 5)
		{
			currentAttributerTypeRadio = 4;
		}		
	}

	Debug("GetAdena():" @GetAdena());
	Debug("txtRemoveAdena.GetText():" @txtRemoveAdena.GetText());

	Debug("itemWnd.GetSelectedNum()" @ itemWnd.GetSelectedNum());

	if (itemWnd.GetSelectedNum() <= -1)
	{
		// ����� �������ּ���.
		AddSystemMessage(242);
		return;
	}

	// ���� Ŭ���̾�Ʈ �ܿ� ����Ǿ� �ִ� �Ƶ����� ���� �� �����ᰡ ������ �޼��� ���
	if ( GetAdena() >= Int64(txtRemoveAdena.GetText()))
	{
		Debug("���̾�α� ���");
		me.DisableWindow();

		DialogSetID( DIALOG_ATTRIBUTE_REMOVE );

		DialogSetReservedInt( attributerTypeRadio[getRadioButtonSelected()] );

		// 3146 : ������ $s1�� $s2 �Ӽ��� �����Ͻðڽ��ϱ�?
		//DialogShow(DialogModalType_Modal, DialogType_Warning, MakeFullSystemMsg( GetSystemMessage(3146), strName, getAttributeNumToStr(attributerTypeRadio[getRadioButtonSelected()])), string(Self));
		DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg( GetSystemMessage(3146), strName, getAttributeNumToStr(currentAttributerTypeRadio)), string(Self));
	}
	else
	{
		// �����ᰡ ���� �ϴٴ� �޼��� ��� 
		AddSystemMessage(3156);
	}


}

/** ���̾�α� �ڽ� OK Ŭ���� */
function HandleDialogOK()
{
	if (DialogIsMine())
	{
		if( DialogGetID() == DIALOG_ATTRIBUTE_REMOVE )
		{
			// ������ �Ӽ� ���� 
			applyAttribute(DialogGetReservedInt());
			Me.EnableWindow();
		}
	}
}


/** �ݱ� ��ư�� Ŭ�� */
function OnbtnCancelClick()
{
	Me.HideWindow();
	itemWnd.Clear();
}

/** �Ӽ� ���� ������ ���� ���� �������� ���� -> OnClickItem ���� */
function OnClickItem( string strID, int index )
{	
	local ItemInfo infItem;
	local int Price;

	Debug("click strID" @ strID);
	Debug("index" @ index);


	if (strID == "ItemWnd")
	{			
		// ���� ���õ� �������� ���� ��ư ���¸� ���
		// �Ͽ� ���� �ٽ� �ش� �������� Ŭ�� ������ ���� ��ư ��ġ�� ���� ��Ű�� ���� ����Ѵ�.

		if (beforeClickedItem != -1)
		{
			memoryAttributeSelectedRadio[beforeClickedItem] = getRadioButtonSelected();
		}

		// debug("memoryAttributeSelectedRadio[beforeClickedItem]: " @ memoryAttributeSelectedRadio[index]);
		
		// debug("itemWnd.GetSelectedNum() :  " @ itemWnd.GetSelectedNum() @ "  :   " @ getRadioButtonSelected());
		
		itemWnd.GetItem( index, infItem );				
		
		// ������ �������� ������ �޾ƿ´�. 
		itemWnd.GetSelectedItem(SelectItemInfo);
		
		btnOK.EnableWindow();
		// getRadioButtonSelected();

		// Load();
		// �������� �Ӽ� �ؽ�Ʈ�� �����Ѵ�
		// memoryAttributeSelectedRadio[index]

		setAttributeGages(infItem, memoryAttributeSelectedRadio[index]);
		// debug("index selected == > " @ index);

		Price = int(infItem.DefaultPrice);
		txtRemoveAdena.SetText(MakeCostString(string(Price)));

		beforeClickedItem = index;
	}

}

/** �Ӽ� ���� ��ư ��Ȱ��ȭ�� �ʱ�ȭ */
function HandleAttributeRemoveShow(string param)
{
	//~ local ItemID cID;	
	itemWnd.Clear();
	initAttributeElements(false);
	btnOK.DisableWindow();				// ó�� �ѷ��� ���� �������� �������� �ʾұ� ������ ������ Ȯ�� ��ư�� disable �����ش�. 
	Me.ShowWindow();
	Me.SetFocus();
	Me.EnableWindow();
}

/**  ������ �������� ItemWnd ������ �����쿡 ��� ��Ų��. */
function HandleAttributeRemoveItemData(string param)
{
	//local int invenIdx;
	local int serverID;
	//local int i, Index;
	local INT64 adena;
	local ItemID sID;

	local ItemInfo infItem;
	
	ParseItemID(param, sID);
	ParseInt(param, "ServerID", serverID);
	ParseINT64(param, "Adena", adena);
	
	// debug ("HandleAttributeRemoveItemData Param : " @ Param);
	//invenIdx = script.m_invenItem.FindItem(sID);		//���� ���̵�� �κ��丮�� ������ �ε����� ������. 

	// Debug("invenIdx" @ invenIdx);
	// memoryAttributeSelectedRadio

	class'UIDATA_INVENTORY'.static.FindItem(serverID, infItem);
	infItem.DefaultPrice = adena;					//�����Ḧ DP�� �־�д�. 

	//if(invenIdx == -1)						//�κ��丮�� ������ ����â�� ������. 
	//{
	//	for( i = 0; i < EQUIPITEM_Max; ++i )
	//	{
	//		Index = script.m_equipItem[ i ].FindItem( sID );	// ServerID

	//		Debug("Index : " @  i @ " : " @ Index);
	//		// ���� ��ư�� ����Ʈ ���¸� ù��° ������ �ʱ�ȭ 
	//		memoryAttributeSelectedRadio[i] = 0;
	//		// debug("n��� index :" @  i);

	//		if( -1 != Index )
	//		{
	//			// ���� ��ư�� ����Ʈ ���¸� ù��° ������ �ʱ�ȭ 
	//			memoryAttributeSelectedRadio[i] = 0;

	//			// debug("��� index :" @  i);					
	//			script.m_equipItem[i].GetItem( Index, infItem );
	//			infItem.DefaultPrice = adena;						//�����Ḧ DP�� �־�д�. 
	//			break;
	//		}
	//	}
	//}
	//else
	//{	
	//	script.m_invenItem.GetItem( invenIdx, infItem );
	//	infItem.DefaultPrice = adena;					//�����Ḧ DP�� �־�д�. 
	//}
		
	// item ������ �Ǵ��Ͽ� ��� ������ �����۸� insert �Ѵ�.  - ģ���� UI��å ^^ - innowind 
	// S�� �̻��� ����/ ���� �Ӽ� ��æƮ ����
	
	//	if((infItem.CrystalType > 4))
	//	{
	if (infItem.Id.ClassID > 0)
	{
		itemWnd.AddItem(infItem);	//�����ϱ� Ư���� �ɷ��� �ʿ�� ����. 
	}
	//	}
}

/** �Ӽ� ������ �Ϸ� �� ��� ó�� */
function HandleAttributeRemoveResult(string param)
{
	
	local int result, removedAttr;
	local int getItemNum;

	local ItemID sID;

	local ItemInfo targetItem;
	
	// �����츦 Ȱ��ȭ ��Ų��.
	Me.EnableWindow();

	ParseInt(param, "Result", Result );
	ParseInt(param, "RemovedAttr", removedAttr );
	//ParseInt(param, "itemID", sID.ServerID );
	ParseInt(param, "ItemID", sID.ServerID );  // <- �빮�ڷ� ����Ǿ� ��������..

	sID.ClassID = 0;

	// ParseItemID(param, sID);

	 //debug("--> EV_RemoveAttributeEnchantResult" @ Result);
	 //debug("--> removedAttr " @ removedAttr);
	 //debug("--> item ID:  " @ sID);
	 //debug("--> ID " @ itemID);
	 //Debug("param :"  @ param);
	 //Debug("sID.ServerID" @ sID.ServerID);


	// �Ӽ��� ������ �������� ã��	
	//getItemNum = itemWnd.FindItem(sID);
	
	//class'UIDATA_ITEM'.static.GetItemInfo(sID, targetItem );

	//getItemNum = script.m_invenItem.FindItem(sID);

	getItemNum = itemWnd.GetSelectedNum();
	itemWnd.GetItem(getItemNum, targetItem);

	//debug("������      : " @ getItemNum);
	//debug("������ �̸� : " @ targetItem.Name);

	//class'UIDATA_INVENTORY'.static.FindItem(serverID, targetItem);

	
	if (Result == 1)
	{
		// ���� �Ӽ��� �ִ�.
		if (targetItem.AttackAttributeValue > 0)
		{
			// debug("���� ���� �Ӽ� ���� : ");
			targetItem.AttackAttributeValue = 0;

			// itemWnd ���� �Ӽ� ���� �Ǿ� �Ӽ��� ���� ���� ���� ������ ���� 
			// ���� �Ӽ��� �ϳ��̱� ������ ������ ����
			itemWnd.DeleteItem( getItemNum );		
			memoryAttributeSelectedRadio.Remove(getItemNum, 1);

			// ���� ItemWnd �� �������� ���� �ϸ� ���� �������� �ڵ����� �������ְ�, �������� 0�� �Ǹ�, â�� �ݴ´�
			if (itemWnd.GetItemNum() > 0)
			{
				itemWnd.SetSelectedNum(getItemNum - 1);
				OnClickItem("ItemWnd", getItemNum - 1);
			}
			else
			{
				itemWnd.Clear();
				initAttributeElements(false);
				btnOK.DisableWindow();
			}
		}
		else if (getDefenseAttributeValue(targetItem) > 0)
		{
				
			// ���� �Ǵ� �Ӽ��� ���� ���� 0���� ����
			switch( removedAttr )
			{
				case ATTRIBUTE_FIRE :
					targetItem.DefenseAttributeValueFire = 0;
					break;
				case ATTRIBUTE_WATER :
					targetItem.DefenseAttributeValueWater = 0;
					break;
				case ATTRIBUTE_WIND :
					targetItem.DefenseAttributeValueWind = 0;
					break;
				case ATTRIBUTE_EARTH :
					targetItem.DefenseAttributeValueEarth = 0;
					break;
				case ATTRIBUTE_HOLY :
					targetItem.DefenseAttributeValueHoly = 0;
					break;
				case ATTRIBUTE_UNHOLY :
					targetItem.DefenseAttributeValueUnholy = 0;
					break;
			}
			
			// ��� �Ӽ��� ���� �ִ�. 
			if (getDefenseAttributeValue(targetItem) > 0)
			{
				// itemWnd �� �������� ���� 
				itemWnd.SetItem( getItemNum, targetItem );

				// debug("1 memoryAttributeSelectedRadio[getItemNum] " @ memoryAttributeSelectedRadio[getItemNum]);

				if (memoryAttributeSelectedRadio[getItemNum] > 0) 
				{
					memoryAttributeSelectedRadio[getItemNum] = memoryAttributeSelectedRadio[getItemNum] - 1;
				}
				else
				{
					memoryAttributeSelectedRadio[getItemNum] = 0;
				}

				// �������� ������ Ŭ���Ǿ��� ����, �ڵ� ���� ������ ���� �ʵ��� �Ѵ�.
				beforeClickedItem = -1;

				// ���� ItemWnd �� �������� ���� �ϸ� ���� �������� �ڵ����� �������ְ�, �������� 0�� �Ǹ�, â�� �ݴ´�
				itemWnd.SetSelectedNum(getItemNum);

				// debug("1.5 memoryAttributeSelectedRadio[getItemNum] " @ memoryAttributeSelectedRadio[getItemNum]);
				OnClickItem("ItemWnd", getItemNum);

				// debug("2 memoryAttributeSelectedRadio[getItemNum] " @ memoryAttributeSelectedRadio[getItemNum]);
				// debug("d SetSelectedNum : " @ getItemNum);
			}
			// ��� �Ӽ��� ��� ���� �Ǿ���. itemWnd ���� ���� �Ǿ�� �Ѵ�.
			else
			{
				// debug("�� �Ӽ� ���� : " @ getItemNum);
				// itemWnd ���� �Ӽ� ���� �Ǿ� �Ӽ��� ���� ���� ���� ������ ���� 
				itemWnd.DeleteItem( getItemNum );
				memoryAttributeSelectedRadio.Remove(getItemNum, 1);

				// ���� ItemWnd �� �������� ���� �ϸ� ���� �������� �ڵ����� �������ְ�, �������� 0�� �Ǹ�, â�� �ݴ´�
				if (itemWnd.GetItemNum() > 0)
				{
					if (itemWnd.GetItemNum() == getItemNum)
					{
						itemWnd.SetSelectedNum(getItemNum - 1);
						OnClickItem("ItemWnd", getItemNum - 1);
						// debug("SetSelectedNum : " @ getItemNum - 1);

					}
					else
					{
						itemWnd.SetSelectedNum(getItemNum);
						OnClickItem("ItemWnd", getItemNum);
						// debug("SetSelectedNum : " @ getItemNum);
					}
					
				}
				else 
				{
					// ������ ��Ұ� ��� ������ ���� �ʴ´�. : ��ȹ���
					// Me.HideWindow();
					// itemWnd.Clear();
					itemWnd.Clear();
					initAttributeElements(false);
					btnOK.DisableWindow();
				}
			}

		}
		else
		{

		}
	}
	else
	{
		// ���� �ߴٸ� â�� �ݾ� �ش�. (�Ӽ��������� ���а� ����,  ������ ���� ����϶� ���)
		Me.HideWindow();
		itemWnd.Clear();
	}


	// debug("������ : " @ );	// memoryAttributeSelectedRadio.Remove(itemWnd.GetSelectedNum(), 1);

	//����� ������� ������ Hide
	// Me.HideWindow();
	// itemWnd.Clear();
	
		
}

/** ��� �Ӽ��� ������ ���� �ΰ�? 0�̸� ��� �Ӽ��� ���°��̰� 0���� ũ�� Ư�� ��� �Ӽ��� ���õ� ���� */
function int getDefenseAttributeValue (ItemInfo targetItem)
{
	return (targetItem.DefenseAttributeValueFire + targetItem.DefenseAttributeValueWater + 
			targetItem.DefenseAttributeValueWind + targetItem.DefenseAttributeValueEarth +
			targetItem.DefenseAttributeValueHoly + targetItem.DefenseAttributeValueUnholy);
}

/** ���� � ���� ��ư�� �����°� */
function int getRadioButtonSelected()
{
	local int returnValueM;
		
	//local String SelectedRadioButtonName;

	//SelectedRadioButtonName = class'UIAPI_WINDOW'.static.GetSelectedRadioButtonName( "AttributeRemoveWnd", 1 );

	//Debug ("getRadioButtonSelected" @  SelectedRadioButtonName);

	if ( btnAttributeSelect2.IsChecked() ) 
	{
		returnValueM = 2;
	}
	else if ( btnAttributeSelect1.IsChecked() )
	{
		returnValueM = 1;
	}
	else 
	{
		returnValueM = 0;
	}	

	//Debug( "getRadioButtonSelected" @ btnAttributeSelect0.IsChecked() @  btnAttributeSelect1.IsChecked() @  btnAttributeSelect2.IsChecked());
	
	return returnValueM;
}

/** ���� ��ư�� �ϳ��� Ŭ�� �ǵ��� Ŭ�� */
function setRadioButton (int selectNum)
{
	btnAttributeSelect0.SetCheck(false);
	btnAttributeSelect1.SetCheck(false);
	btnAttributeSelect2.SetCheck(false);

	if (selectNum == 1)
	{
		btnAttributeSelect1.SetCheck(true);
	}
	else if (selectNum == 2)
	{
		btnAttributeSelect2.SetCheck(true);
	}
	else
	{
		btnAttributeSelect0.SetCheck(true);
	}
}

/****************************************************************************************************
 * 
 *  �Ӽ� �� ��Ʈ�� ����
 *  
 ****************************************************************************************************/

/** �Ӽ� ������ �׷��ֱ�  (ToolTip �� �ִ� ������ Ŀ���� ����¡) */
function setAttributeGages(ItemInfo Item, int selectedRadioButtonNum)
{
	local int i;
	//local int highAttrValue[6];

	local BarHandle currentGage;
	local TextBoxHandle currentTextBox;
	local CheckBoxHandle currentRadioButton;

	for(i = 0; i < 6; i++)
	{
		tooltipStr[i] = "";
	}

	for(i = 0; i < 3; i++)
	{
		// 0~ 5 ���� �� �Ӽ��� ����Ѵ�. 9999�� ���� �ȵ� ��
		attributerTypeRadio[i] = 999;
	}
	
	initAttributeElements(false);

	radioButtonCount = 0;
	// ���� ������ �Ӽ�
	if (Item.AttackAttributeValue  > 0)
	{
		
		toolTipScript.SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_FIRE);
		toolTipScript.SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_WATER);
		toolTipScript.SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_WIND);
		toolTipScript.SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_EARTH);
		toolTipScript.SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_HOLY);
		toolTipScript.SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_UNHOLY); //������ ���������� ���Ѵ�.

		switch(Item.AttackAttributeType)
		{
			case ATTRIBUTE_FIRE:
				tooltipStr[ATTRIBUTE_FIRE] = GetSystemString(1622) $ " Lv " $ String(toolTipScript.AttackAttLevel[ATTRIBUTE_FIRE]) $ " ("$ GetSystemString(1622) $ " " $ 
											 GetSystemString(55) $ " " $ String(Item.AttackAttributeValue) $")";
			
				break;

			case ATTRIBUTE_WATER:
				tooltipStr[ATTRIBUTE_WATER] = GetSystemString(1623) $ " Lv " $ String(toolTipScript.AttackAttLevel[ATTRIBUTE_WATER]) $ " ("$ GetSystemString(1623) $ " " $ 
											  GetSystemString(55) $ " " $String(Item.AttackAttributeValue) $ ")";
				break;
			case ATTRIBUTE_WIND:
				tooltipStr[ATTRIBUTE_WIND] = GetSystemString(1624) $ " Lv " $ String(toolTipScript.AttackAttLevel[ATTRIBUTE_WIND]) $ " ("$ GetSystemString(1624) $ " " $ 
											 GetSystemString(55) $ " " $String(Item.AttackAttributeValue) $ ")";
				break;
			case ATTRIBUTE_EARTH:
				tooltipStr[ATTRIBUTE_EARTH] = GetSystemString(1625) $ " Lv " $ String(toolTipScript.AttackAttLevel[ATTRIBUTE_EARTH]) $ " ("$ GetSystemString(1625) $ " " $ 
											  GetSystemString(55) $ " " $ String(Item.AttackAttributeValue) $")";
				break;
			case ATTRIBUTE_HOLY:
				tooltipStr[ATTRIBUTE_HOLY] = GetSystemString(1626) $ " Lv " $ String(toolTipScript.AttackAttLevel[ATTRIBUTE_HOLY]) $ " ("$ GetSystemString(1626) $ " " $ 
											 GetSystemString(55) $ " " $String(Item.AttackAttributeValue) $ ")";
				break;
			case ATTRIBUTE_UNHOLY:
				tooltipStr[ATTRIBUTE_UNHOLY] = GetSystemString(1627) $ " Lv " $ String(toolTipScript.AttackAttLevel[ATTRIBUTE_UNHOLY]) $ " ("$ GetSystemString(1627) $ " " $ 
											   GetSystemString(55) $ " " $String(Item.AttackAttributeValue) $ ")";
				break;
		}
	} 
	// ��� ������ �Ӽ� �� ���
	else
	{
		toolTipScript.SetDefAttribute(Item.DefenseAttributeValueFire,ATTRIBUTE_FIRE);
		toolTipScript.SetDefAttribute(Item.DefenseAttributeValueWater,ATTRIBUTE_WATER);
		toolTipScript.SetDefAttribute(Item.DefenseAttributeValueWind,ATTRIBUTE_WIND);
		toolTipScript.SetDefAttribute(Item.DefenseAttributeValueEarth,ATTRIBUTE_EARTH);
		toolTipScript.SetDefAttribute(Item.DefenseAttributeValueHoly,ATTRIBUTE_HOLY);
		toolTipScript.SetDefAttribute(Item.DefenseAttributeValueUnholy,ATTRIBUTE_UNHOLY); //������ ���簪���� ���Ѵ�.

		if(Item.DefenseAttributeValueFire != 0) //���̾� �Ӽ� ���� �׸���
		{
			tooltipStr[ATTRIBUTE_FIRE] = GetSystemString(1623) $ " Lv " $ String(toolTipScript.DefAttLevel[ATTRIBUTE_FIRE]) $ " ("$ GetSystemString(1622) $ " " $ 
										 GetSystemString(54) $ " " $ String(Item.DefenseAttributeValueFire) $")";
		}
		if(Item.DefenseAttributeValueWater != 0) //�� �Ӽ� ���� �׸���
		{
			tooltipStr[ATTRIBUTE_WATER] = GetSystemString(1622) $ " Lv " $ String(toolTipScript.DefAttLevel[ATTRIBUTE_WATER]) $ " ("$ GetSystemString(1623) $ " " $ 
										  GetSystemString(54) $ " " $String(Item.DefenseAttributeValueWater) $ ")";
		}
		if(Item.DefenseAttributeValueWind != 0) //�ٶ� �Ӽ� ���� �׸���
		{
			tooltipStr[ATTRIBUTE_WIND] = GetSystemString(1625) $ " Lv " $ String(toolTipScript.DefAttLevel[ATTRIBUTE_WIND]) $ " ("$ GetSystemString(1624) $ " " $ 
										 GetSystemString(54) $ " " $String(Item.DefenseAttributeValueWind) $")";
		}
		if(Item.DefenseAttributeValueEarth != 0) //�� �Ӽ� ���� �׸���
		{
			tooltipStr[ATTRIBUTE_EARTH] = GetSystemString(1624) $ " Lv " $ String(toolTipScript.DefAttLevel[ATTRIBUTE_EARTH]) $ " ("$ GetSystemString(1625) $ " " $ 
										  GetSystemString(54) $ " " $String(Item.DefenseAttributeValueEarth) $ ")";
		}
		if(Item.DefenseAttributeValueHoly != 0) //�ż� �Ӽ� ���� �׸���
		{
			tooltipStr[ATTRIBUTE_HOLY] = GetSystemString(1627) $ " Lv " $ String(toolTipScript.DefAttLevel[ATTRIBUTE_HOLY]) $ " ("$ GetSystemString(1626) $ " " $ 
										 GetSystemString(54) $ " " $ String(Item.DefenseAttributeValueHoly) $")";
		}
		if(Item.DefenseAttributeValueUnholy != 0) //���� �Ӽ� ���� �׸���
		{
			tooltipStr[ATTRIBUTE_UNHOLY] = GetSystemString(1626) $ " Lv " $ String(toolTipScript.DefAttLevel[ATTRIBUTE_UNHOLY]) $ " ("$ GetSystemString(1627) $ " " $ 
											GetSystemString(54) $ " " $String(Item.DefenseAttributeValueUnholy) $ ")";
		}
	}

	if (Item.AttackAttributeValue  > 0)//���ݼӼ��ϰ��
	{
		for(i = 0; i < 6; i++)
		{
			// debug("==����==> " @ tooltipStr[i]);

			if(tooltipStr[i] == "") 
			{   
				continue;
			}
			else 
			{

				// debug("toolTipScript.AttackAttMaxValue[i] ==> " @ toolTipScript.AttackAttMaxValue[i]);
				// debug("toolTipScript.AttackAttCurrValue[i] ==> " @ toolTipScript.AttackAttCurrValue[i]);

				currentGage = GetBarHandle ( "AttributeRemoveWnd.gageAttributeSelect" $ String(radioButtonCount) );
				currentTextBox = GetTextBoxHandle ( "AttributeRemoveWnd.txtAttributeSelect" $ String(radioButtonCount) );
				currentRadioButton = GetCheckBoxHandle( "AttributeRemoveWnd.btnAttributeSelect" $ String(radioButtonCount) ); 

				currentGage.Clear();
				currentGage.SetValue(toolTipScript.AttackAttMaxValue[i], toolTipScript.AttackAttCurrValue[i]);
				setColorBar(currentGage, i);
				
				currentGage.ShowWindow();
				currentTextBox.ShowWindow();
				currentRadioButton.ShowWindow();
					
				currentTextBox.SetText(tooltipStr[i]);		

				// ���� ��ư�� ���� ���� ���� Ÿ���� ��� ��Ų��. 
				attributerTypeRadio[radioButtonCount] = i;
				
				/*
				// ù ��° ���� ��ư�� ���õǾ��� ���·� ����
				if (radioButtonCount == 0)
				{
					btnAttributeSelect0.SetCheck(true);
				}
				*/

		
				radioButtonCount++;
			}

		}
	
	}
	else
	{ 
		//��� �Ӽ��� ���
		for(i = 0; i < 6; i++)
		{
			// debug("==���==> " @ string(i)  @ " == " @ tooltipStr[i]);
			if(tooltipStr[i] == "") 
			{   
				continue;
			}
			else 
			{
				// debug("toolTipScript.DefAttMaxValue[i] ==> " @ toolTipScript.DefAttMaxValue[i]);
				// debug("toolTipScript.DefAttCurrValue[i] ==> " @ toolTipScript.DefAttCurrValue[i]);

				currentGage = GetBarHandle ( "AttributeRemoveWnd.gageAttributeSelect" $ String(radioButtonCount) );
				currentTextBox = GetTextBoxHandle ( "AttributeRemoveWnd.txtAttributeSelect" $ String(radioButtonCount) );
				currentRadioButton = GetCheckBoxHandle( "AttributeRemoveWnd.btnAttributeSelect" $ String(radioButtonCount) ); 
				
				currentGage.Clear();
				
				currentGage.SetValue(toolTipScript.DefAttMaxValue[i], toolTipScript.DefAttCurrValue[i]);
				setColorBar(currentGage, i);
				
				currentGage.ShowWindow();
				currentTextBox.ShowWindow();
				currentRadioButton.ShowWindow();

				currentTextBox.SetText(tooltipStr[i]);	

				// ���� ��ư�� ���� ���� ���� Ÿ���� ��� ��Ų��. 
				attributerTypeRadio[radioButtonCount] = i;
				/*
				// ù ��° ���� ��ư�� ���õǾ��� ���·� ����
				if (radioButtonCount == 0)
				{
					btnAttributeSelect0.SetCheck(true);
				}
				*/

				radioButtonCount++;
			}

		}
	}

	/*
	if (selectedRadioButtonNum == 1)
	{
		btnAttributeSelect1.SetCheck(true);
	}
	else if (selectedRadioButtonNum == 2)
	{
		btnAttributeSelect2.SetCheck(true);
	}
	else
	{
		btnAttributeSelect0.SetCheck(true);
	}
	*/
	setRadioButton(selectedRadioButtonNum);
}

/**
 * 
 *  ������ ���� ��(�ؽ��ĸ� ��ü �Ͽ� ��ȭ�� ���� ǥ�� �ϵ��� �Ѵ�.)
 *  �����ų barHandler, �� ��ȭ ��ų Ÿ�� ��ȣ (��0, ��1, �ٶ�2, ��3, �ż�4, ����5) 
 *  
 **/
function setColorBar(BarHandle bar, int selectNum)
{
	// 0:ForeLeft 1:ForeTexture 2:ForeRightTexture 3:BackLeftTexture 4:BackTexture 5:BackRightTexture
	bar.SetTexture(0, "L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[selectNum] $ "_Left");
	bar.SetTexture(1, "L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[selectNum] $ "_Center");
	bar.SetTexture(2, "L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[selectNum] $ "_Right");
	bar.SetTexture(3, "L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[selectNum] $ "_Bg_Left");
	bar.SetTexture(4, "L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[selectNum] $ "_Bg_Center");
	bar.SetTexture(5, "L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[selectNum] $ "_Bg_Right");	
}


/** ���� 0~ 2 ���� 3���� �������� ��ȣ�� ���� ���� �Ѵ�. */
function BarHandle selectBarHandle(int selectNum)
{
	local BarHandle returnValueM;

	if (selectNum == 0)
	{
		returnValueM = gageAttributeSelect0;
	}
	else if (selectNum == 1)
	{
		returnValueM = gageAttributeSelect1;
	}
	else if (selectNum == 2)
	{
		returnValueM = gageAttributeSelect2;
	}

	return returnValueM;
}
			

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);		
	OnbtnCancelClick();
}

defaultproperties
{
}