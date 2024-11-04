/***
 *   ���� ���� ����Ʈ
 **/
class PrivateShopWndReport extends UICommonAPI;

var WindowHandle Me;

var L2Util       util;

var ListCtrlHandle ItemList_ListCtrl;
var ButtonHandle   Edit_Btn;
var ButtonHandle   StopSell_Btn;
var ButtonHandle   EditorSetting_Btn;
var ButtonHandle   history_Btn;

// ������ ���Ŀ� index 
//var int itemIndex;

// ���� ������ ���
var array<ItemInfo>	getItemInfoArray;
// �Ǹ�, ������ ������ ����
var array<int64> getItemNumArray;
//// ������ ���� 
//var array<int64> getItemPriceArray;

// �ȱ� �� ó�� ������ ����(�þ�ų�, �پ�� ������ üũ �ϸ� �ǰڴ�.)
//var array<int64> firstItemNumArray;


// buy �� ��� serverID�� �ٸ�, inventory addItem �� ��� �� �� ���� ��� ��� ����
var array<int>buyItemServerIDArray ;
var array<int64>buyItemNumArray ;
var array<String>buyUserNameArray;


var InventoryWnd  inventoryWndScript;


var EditBoxHandle SignEditInput_Edit;
var TextBoxHandle SignEditInput_Txt;
var TextBoxHandle SignEditInput_guide;

var TextBoxHandle privateShopTitle_Txt;
var TextBoxHandle Benefit_Input1_Txt;
var TextBoxHandle Benefit_Input2_Txt;

var TextBoxHandle BenefitTitle1_Txt ;
var TextBoxHandle BenefitTitle2_Txt ;

var  PrivateShopWnd privateShopScript ;

var string messageType;

const STRINGNUM_SALE_TITLE 		= 500;
const STRINGNUM_BUY_TITLE 		= 499;		
const STRINGNUM_SALE_BULK_TITLE = 1273;

var PrivateShopWndHistory PrivateShopWndHistoryScript;

//const DIALOG_EDIT_SHOP_MESSAGE  = 1234;


/*****************************************************************************
 * on ��
 ****************************************************************************/
event OnRegisterEvent()
{
	RegisterEvent(EV_InventoryUpdateItem);
	//RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_PrivateStoreBuyingResult);
	RegisterEvent(EV_PrivateStoreSellingResult);
}

event OnLoad()
{
	Initialize();
//	setDefaultShow(true);
}

event OnShow()
{
	messageType = getCurrentMessageType();
	Edit_Btn.EnableWindow();
	updateList();
	setPrivateShopMessageText();
	Me.SetFocus();
	GetWindowHandle("PetWnd").HideWindow();
}

event OnHide()
{
	init();
}

// OnClickButton
event OnClickButton(string Name)
{
	switch(Name)
	{		
		case "StopSell_Btn":
			 if(!checkShoppingEnd()) privateShopScript.stopSellFlag = true;
		case "Edit_Btn" :
			 handleQuit();
			 //OnStopSell_BtnClick();
			 break;
		case "history_Btn":
			Onhistory_BtnClick();
			break;
		case "EditorSetting_Btn":	
			togglePrivateShopEditor();
			break;
	}	
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if(a_WindowHandle == SignEditInput_guide || a_WindowHandle == SignEditInput_Txt)
		showPrivateShopEditor();
}


event onEvent(int a_EventID, string a_Param)
{
	if(! Me.IsShowWindow())return;
	switch(a_EventID){		
		case EV_InventoryUpdateItem :
			if(buyItemServerIDArray.Length > 0)				
				handleinventoryUpdateResult(a_Param);
		break;
		//case EV_DialogOK :
		//	handleDialogOK();
		//break;
		case EV_PrivateStoreBuyingResult :		
			 handleBuyResult(a_Param);
			 //Debug("onEvent EV_PrivateStoreBuyingResult " @ a_Param);
			 break;
		case EV_PrivateStoreSellingResult:
			 handleSellingResult(a_Param);
			 //Debug("onEvent EV_PrivateStoreSellingResult " @ a_Param);
			 break;

	}
}

/** OnKeyUp */
event OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	// Ű���� �������� üũ 	
	if(SignEditInput_Edit.IsFocused())
	{
		// txtPath
		if(nKey == IK_Enter)
		{
			togglePrivateShopEditor();
		}
		else if(nKey == IK_Escape)
		{
			hidePrivateShopwEditor();
		}
	}
}

/*****************************************************************************
 * �ʱ�ȭ
 ****************************************************************************/
function Initialize()
{
	Me           = GetWindowHandle("PrivateShopWndReport");
	ItemList_ListCtrl = GetListCtrlHandle("PrivateShopWndReport.ItemList_ListCtrl");
	StopSell_Btn     = GetButtonHandle("PrivateShopWndReport.StopSell_Btn");
	Edit_Btn     = GetButtonHandle("PrivateShopWndReport.Edit_Btn");

	history_Btn     = GetButtonHandle("PrivateShopWndReport.history_Btn");

	EditorSetting_Btn     = GetButtonHandle("PrivateShopWndReport.EditorSetting_Btn");	

	util                = L2Util(GetScript("L2Util"));
	inventoryWndScript  = inventoryWnd(GetScript("inventoryWnd"));

	// ���� ���� ����
	privateShopTitle_Txt     = GetTextBoxHandle("PrivateShopWndReport.privateShopTitle_Txt");

	// ���� ������ ���� ����
	SignEditInput_Txt = GetTextBoxHandle("PrivateShopWndReport.SignEditInput_Txt");
	// ���� �ȳ� �޽��� 
	SignEditInput_guide = GetTextBoxHandle("PrivateShopWndReport.SignEditInput_guide");
	// ���� �� ���� ����	
	SignEditInput_Edit = GetEditBoxHandle("PrivateShopWndReport.SignEditInput_Edit");

	// ����??
	Benefit_Input1_Txt = GetTextBoxHandle("PrivateShopWndReport.Benefit_Input1_Txt");
	// ����?? 
	Benefit_Input2_Txt = GetTextBoxHandle("PrivateShopWndReport.Benefit_Input2_Txt");

	BenefitTitle1_Txt = GetTextBoxHandle("PrivateShopWndReport.BenefitTitle1_Txt");
	BenefitTitle2_Txt = GetTextBoxHandle("PrivateShopWndReport.BenefitTitle2_Txt");

	PrivateShopWndHistoryScript = PrivateShopWndHistory(GetScript("PrivateShopWndHistory"));	

	ItemList_ListCtrl.SetSelectedSelTooltip(FALSE);	
	ItemList_ListCtrl.SetAppearTooltipAtMouseX(true);

	privateShopScript = PrivateShopWnd(GetScript("PrivateShopWnd"));

	SignEditInput_guide.SetText(GetSystemMessage(334));

	init();
}


// �ʱ�ȭ
function init()
{
	//local DialogBox DialogBox;

	getItemInfoArray.Length = 0;
	getItemNumArray.Length = 0;

	buyItemServerIDArray.Length = 0; ;
	buyItemNumArray.Length = 0; ;
	buyUserNameArray.Length = 0 ;
	//itemIndex = 99999;
	ItemList_ListCtrl.DeleteAllItem();	

	//DialogBox = DialogBox(GetScript("DialogBox"));
	//if(class'UIAPI_WINDOW'.static.IsShowWindow("DialogBox"))
	//{
	//	if(DialogIsMine())
	//		DialogBox.HandleCancel();
	//}
	hidePrivateShopwEditor();
}


/*****************************************************************************
 * ������ ����
 ****************************************************************************/

function handleBuyResult(string param)
{	
	local int serverId ; 
	local int64 amount;
	local string userName;
	
	parseInt(param, "ItemID", serverId);
	buyItemServerIDArray.Length = buyItemServerIDArray.Length + 1 ; ;
	buyItemServerIDArray[ buyItemServerIDArray.Length - 1 ] = serverId ;

	parseInt64(param, "Amount", amount);	
	buyItemNumArray.Length = buyItemNumArray.Length + 1 ; 
	buyItemNumArray[ buyItemNumArray.Length - 1 ] = amount ;

	parseString(param, "CharName", userName);
	buyUserNameArray.Length = buyUserNameArray.Length + 1 ;
	buyUserNameArray[buyUserNameArray.Length - 1] = userName;

}

function handleSellingResult(string param)
{	
	local int serverId ; 
	local int64 amount;
	local string userName;
	
	parseInt(param, "ItemID", serverId);
	parseInt64(param, "Amount", amount);
	parseString(param, "CharName", userName);

	findNModifyRecord(serverId, amount, userName);
}

function handleinventoryUpdateResult(string param)
{
	local int Count, i, Index;
	local ItemInfo updatedItemInfo;
	local LVDataRecord Record;
	local bool isSame, isStackable;

	//ParseItemID(param, itemID);
	ParamToItemInfo(param, updatedItemInfo);

	// ���� ���̵� ���� �� ���� ��ŭ 
	// End:0x1F5 [Loop If]
	for(i = 0; i < buyItemServerIDArray.Length; i++)
	{		
		if(buyItemServerIDArray[i] == updatedItemInfo.Id.ServerID)
		{
			// ���ڵ� ����Ʈ���� ã�ƶ�.
			// End:0x1EB [Loop If]
			for(Count = 0; count < ItemList_ListCtrl.GetRecordCount(); Count++)
			{
				ItemList_ListCtrl.GetRec(Count, Record);
				Index = int(Record.nReserved3);
				// �� �ȸ��� �ʾҴٸ�
				if(getItemNumArray[Index] != getItemInfoArray[Index].ItemNum)
				{
					isStackable = IsStackableItem(updatedItemInfo.ConsumeType);
					// End:0x123
					if(updatedItemInfo.Id.ClassID == getItemInfoArray[Index].Id.ClassID)
					{
						// End:0x106
						if(isStackable)
						{
							isSame = true;							
						}
						else
						{
							isSame = compareItem(getItemInfoArray[Index], updatedItemInfo);
						}
					}
					// ���� �������̸� ó���ϰ� �ߴ�.
					if(isSame)
					{
						Record = getModifyRecord(Record, buyItemNumArray[i]);
						ItemList_ListCtrl.ModifyRecord(Count, Record);
						PrivateShopWndHistoryScript.addHistory(Record.LVDataList[0].szData, isStackable, buyItemNumArray[i], buyUserNameArray[i]);
						setCurrentTotalPrice();
						buyItemServerIDArray.Remove(i, 1);
						buyItemNumArray.Remove(i, 1);
						buyUserNameArray.Remove(i, 1);
						// End:0x1DF
						if(checkShoppingEnd())
						{
							Edit_Btn.DisableWindow();
						}
						
						//Debug("handleinventoryUpdateResult" @ buyItemServerIDArray.Length @ buyItemNumArray.length );
						return;
					}
				}
			}
		}
	}
}

function LVDataRecord getModifyRecord(LVDataRecord Record, int64 amount )
{
	local int index ;

	index = int(Record.nReserved3);

	getItemNumArray[index] = getItemNumArray[index] + amount ;	

	Record.LVDataList[0] = makeItemNameRecord(Record, getItemNumArray[index]);
	Record.LVDataList[1] = makeItemNumRecord(Record, getItemNumArray[index]);
	Record.LVDataList[2] = makeItemPriceRecord(Record, getItemNumArray[index]);
	Record.LVDataList[3] = makeItemTotalPrice(Record, getItemNumArray[index]);



	// ��ȭ ǥ��
	//if(info.enchanted > 0)
	//{
	//	Record.LVDataList[0].arrTexture.Length = 3;
	//	lvTextureAddItemEnchantedTexture(info.enchanted, record.LVDataList[0].arrTexture[0], record.LVDataList[0].arrTexture[1],record.LVDataList[0].arrTexture[2], 9, 11);
	//}



	return Record;
}

function findNModifyRecord(int ServerID, int64 Amount, string UserName)
{
	local int Count;
	local LVDataRecord Record;

	getBuyItemInfo(ServerID);
	for(Count = 0; Count < ItemList_ListCtrl.GetRecordCount(); Count++)
	{
		ItemList_ListCtrl.GetRec(Count, Record);
		// End:0xE7
		if(Record.nReserved1 == ServerID)
		{
			Record = getModifyRecord(Record, Amount);
			ItemList_ListCtrl.ModifyRecord(Count, Record);
			PrivateShopWndHistoryScript.addHistory(Record.LVDataList[0].szData, Record.LVDataList[2].hasIcon, Amount, UserName);
			setCurrentTotalPrice();
			// End:0xE5
			if(checkShoppingEnd())
			{
				Edit_Btn.DisableWindow();
			}

			return;
			//Debug("step1" @ numOfItem @ info.itemNum @ info.ID.classID @ info.ID.serverID @ getItemInfoArray[index].ID.classID @ getItemInfoArray[index].ID.serverID @ IsStackableItem(info.ConsumeType)@ compareItem(info, getItemInfoArray[index]));			
		}
	}
}

function  getBuyItemInfo(int  serverID)
{
	local ItemInfo ResourceInfo;
	local itemID pItemID ;
	pItemID.serverID = serverID ;
	class'UIDATA_ITEM'.static.GetItemInfo(pItemID, ResourceInfo);
//	Debug("getBuyItemInfo" @ ResourceInfo.ID.classID);
}

//�������� �ٲ�.
//function handleAddedItemInfo(string a_Param)
//{
//	local ItemInfo info;

//	// �ʿ��� ���� : ������ ���� Ŭ���� ���̵�, ����Ŀ�� Ÿ��
//	Debug("handleAddedItemInfo" @ a_Param);
//	ParamToItemInfo(a_Param, info);
//	findNModifyRecord(info);
//}   

//function int findIdx(ItemInfo info)
//{
//	local int64 itemCount;
//	local int i;
//	for(i = 0 ; i < getItemInfoArray.Length ; i++)
//	{
//		if(getItemInfoArray[i].ID.classID == info.ID.classID )
//		{
//			itemCount = getAbs(firstItemNumArray[i] - info.ItemNum);
			
//			// �� ��ų� �ȸ��� �ʾҴٸ�, index�� ����
//			if(getItemNumArray[i] != itemCount )
//			{
//				getItemNumArray[i] = itemCount;
//				Debug("findIdx" @ itemCount  @ firstItemNumArray[i] @ info.ItemNum);
//				return i ;
//			}
//		}
//	}
//	return -1;
//}


function startOpenPrivateShop(string param)
{
	Me.showWindow();
}

/***********************************************************************************
 * Ÿ��Ʋ �� ���� ���� 
 * **********************************************************************************/

/* Ÿ��Ʋ */
function string getCurrentMessageType()
{
	switch (privateShopScript.m_type)
	{		
		case PT_SellList :
			if(privateShopScript.m_bBulk)
			{
				return "bulksell";				
			}
			else 
			{
				return "sell";			
			}
		break;
		case PT_BuyList :
			return "buy";			
		break;
	}	
	return "" ;
}

function handleGuideMessage()
{
	if(SignEditInput_Txt.GetText()== "")
		SignEditInput_guide.ShowWindow();
	else SignEditInput_guide.HideWindow();
}

function togglePrivateShopEditor()
{
	if(SignEditInput_Edit.IsShowWindow())
	{
		if(GetPrivateShopMessage(messagetype)!= SignEditInput_Edit.GetString()&& "" != SignEditInput_Edit.GetString())
		{
			//Debug("togglePrivateShopEditor" @  messageType @ SignEditInput_Edit.GetString());
			SetPrivateShopMessage(messageType, SignEditInput_Edit.GetString());
			SignEditInput_Txt.SetText(SignEditInput_Edit.GetString());
			handleGuideMessage();
		}

		hidePrivateShopwEditor();
	}
	else 
	{
		showPrivateShopEditor();
	}
}

function showPrivateShopEditor()
{
	//DialogSetDefaultOK();	
	//���� 25�� ����! ���� 25�� �����̾��µ� ������ �����Ͽ� 29�ڷ� �ø�
	//DialogSetEditBoxMaxLength(29);	
	
	//DialogSetID(DIALOG_EDIT_SHOP_MESSAGE );

	// ���̾�α� â�� �� ���� ��Ʈ���� ���� ��Ų��.
	// �������� edit �ؽ�Ʈ�� ������ ����� ���� ���� ���� ���¿��� ��Ʈ���� �־ ������ ���ܼ� 
	// ���� ��ģ ���̴�.
	//DialogShow(DialogModalType_Modalless, DialogType_OKCancelInput, GetSystemMessage(334), string(Self));
	//DialogSetString(GetPrivateShopMessage(messagetype));
	SignEditInput_Txt.hideWindow();
	SignEditInput_Edit.ShowWindow();
	
	SignEditInput_Edit.SetString(GetPrivateShopMessage(messagetype));
	SignEditInput_Edit.SetFocus();	
	SignEditInput_guide.HideWindow();
	EditorSetting_Btn.SetTexture("L2UI_CT1.Button.completeBtn_df","L2UI_CT1.Button.completeBtn_down", "L2UI_CT1.Button.completeBtn_over");
}

function hidePrivateShopwEditor()
{
	SignEditInput_Txt.ShowWindow();
	SignEditInput_Edit.hideWindow();
	EditorSetting_Btn.SetTexture("L2UI_CT1.Button.SettingBtn_n", "L2UI_CT1.Button.SettingBtn_d", "L2UI_CT1.Button.SettingBtn_o");
}

function setPrivateShopMessageText()
{	
	local string shopTitle;
	local color messageColor;	
	
	switch(messageType)
	{
		case "bulksell" :
			messageColor = getColor(255, 119, 119, 255);
			shopTitle = GetSystemString(STRINGNUM_SALE_BULK_TITLE);
			//ItemList_ListCtrl.SetColumnString(0, 137);
			//ItemList_ListCtrl.SetColumnString(1, 3597);
			ItemList_ListCtrl.SetColumnString(2, 2502);			
			ItemList_ListCtrl.SetColumnString(3, 3591);
			BenefitTitle1_Txt.SetText(GetSystemString(3593));
			BenefitTitle2_Txt.SetText(GetSystemString(3595));
		break;
		case "sell" :
			messageColor = getColor(221, 119, 238, 255);				
			shopTitle = GetSystemString(STRINGNUM_SALE_TITLE);
			//ItemList_ListCtrl.SetColumnString(0, 137);
			//ItemList_ListCtrl.SetColumnString(1, 3597);
			ItemList_ListCtrl.SetColumnString(2, 2502);
			ItemList_ListCtrl.SetColumnString(3, 3591);
			BenefitTitle1_Txt.SetText(GetSystemString(3593));
			BenefitTitle2_Txt.SetText(GetSystemString(3595));
		break;
		case "buy" :
			messageColor = getColor(170, 204, 17, 255);
			shopTitle = GetSystemString(STRINGNUM_BUY_TITLE);
			//ItemList_ListCtrl.SetColumnString(0, 137);
			//ItemList_ListCtrl.SetColumnString(1, 3597);
			ItemList_ListCtrl.SetColumnString(2, 3590);		
			ItemList_ListCtrl.SetColumnString(3, 3592);
			BenefitTitle1_Txt.SetText(GetSystemString(3594));
			BenefitTitle2_Txt.SetText(GetSystemString(3596));
		break;
	}
	
	privateShopTitle_Txt.SetText(shopTitle);
	privateShopTitle_Txt.SetTextColor(messageColor); 
	SignEditInput_Txt.SetTextColor(messageColor);
	SignEditInput_Txt.SetText(GetPrivateShopMessage(messagetype));
	handleGuideMessage();
	//SignEditInput_Txt.SetTextColor(messageColor);
}

//function handleDialogOK()
//{
//	local int id;
//	id = DialogGetID();

//	if(DialogIsMine())
//	{
//		switch(id)
//		{
//			case DIALOG_EDIT_SHOP_MESSAGE :
//				SetPrivateShopMessage(messageType, DialogGetString());

//				SignEditInput_Txt.SetText( DialogGetString());

////				Debug(messageType @ DialogGetString()@ GetPrivateShopMessage(messagetype));
//			break;
//		}
//	}
//}

/***********************************************************************************
 * �������� ���Ѵ�.
 * **********************************************************************************/
// �ǸŸ� ���� �߰��� ������
function externalAddItem(ItemInfo addItemInfo)
{
	//local int64 currentItemCount ;
	local int len, i  ;	
	
	// ���� �� ������ �ٸ� �������� ������ �ø� �� ����, ���� �񱳸� �ؾ� ��.
	if(privateShopScript.m_type == PT_BuyList)
	{		
		if(!IsStackableItem(addItemInfo.ConsumeType))
		{
			for(i = 0 ; i <  getItemInfoArray.Length ; i ++)
			{
				if(getItemInfoArray[i].ID.classID == addItemInfo.ID.classID)
				{
					if(compareItem(getItemInfoArray[i], addItemInfo))
					{					
						if(addItemInfo.price != getItemInfoArray[i].price)return ;
					}
				}
			}
		}
	}

	len = getItemInfoArray.Length + 1;
	getItemInfoArray.Length = len;
	getItemInfoArray[ len -1  ] =(addItemInfo);

	getItemNumArray.Length = len;
	getItemNumArray[ len - 1 ] = 0;
	
	//firstItemNumArray.Length = len;
	//firstItemNumArray[ len - 1 ] = inventoryWndScript.getItemCountByClassID(addItemInfo.ID.classID);
	//if(!IsStackableItem(addItemInfo.ConsumeType))firstItemNumArray[ len - 1 ] = 1;

	//Debug("externalAddItem" @ firstItemNumArray[ len - 1 ]  @ getItemInfoArray.Length  @ getItemNumArray.Length  @ firstItemNumArray.Length);

	if(Me.IsShowWindow())updateList();
}

// ��ü ��� ���� 
function updateList()
{
	local int i;

	ItemList_ListCtrl.DeleteAllItem();
	
	if(getItemInfoArray.Length > 0)
	{
		for(i = 0 ; i < getItemInfoArray.Length ; i++)
		{
			// �Ƶ����� ��� ����Ʈ�� ���� ����.(��ȹ: ����)
			if(getItemInfoArray[i].Id.ClassID != 57)
			{
				addItem(i);
			}
		}
	}

	setCurrentTotalPrice();
}

// ���� �� ���� �� ���� ���� ���� ���
function setCurrentTotalPrice()
{
	local int count, index ;
	local int64 itemNum, price, currentPrice, totalprice ;
	local LVDataRecord Record;
	
	currentPrice = 0 ;
	totalprice = 0 ;

	for(count = 0 ; count < ItemList_ListCtrl.GetRecordCount(); count ++)
	{
		ItemList_ListCtrl.GetRec(count, Record);

		index = int(Record.nReserved3);
		
		price = getItemInfoArray[ index ].price;
		itemNum = Record.nReserved2;
		
		currentPrice += getItemNumArray[index] * price ;
		totalprice += itemNum * price ;

		Benefit_Input1_Txt.SetText(ConvertNumToTextNoAdena(String(currentPrice)));
		Benefit_Input2_Txt.SetText(ConvertNumToTextNoAdena(String(totalprice - currentPrice)));
		if(Benefit_Input1_Txt.GetText()== "")Benefit_Input1_Txt.SetText("0");
		if(Benefit_Input2_Txt.GetText()== "")Benefit_Input2_Txt.SetText("0");
	}
}


// ������ �� ���� ǥ�� 
function LVData makeItemTotalPrice(LVDataRecord Record, int64 itemNum)
{
	local int64 price, totalPrice ;
	local string costString;
	
	price = getItemInfoArray[int(Record.nReserved3)].price ;
	
	totalPrice = price *  itemNum ;
	costString = MakeCostString(String(totalPrice));	
	Record.LVDataList[3].buseTextColor = true;

	if(itemNum == Record.nReserved2)
	{	
		Record.LVDataList[3].TextColor = getColor(120, 120, 120, 255);
	}
	else 
		Record.LVDataList[3].textColor = GetNumericColor(costString);		

	Record.LVDataList[3].szData = ConvertNumToTextNoAdena(String(totalPrice));	
	
	return Record.LVDataList[3];
}

// ������ ���� ǥ�� 
function LVData makeItemPriceRecord(LVDataRecord Record, int64 itemNum)
{
	local int64 price, remainingItemNum, remainingItemPrice ;
	local string remainingString;
	
	if(itemNum == Record.nReserved2)
	{	
		Record.LVDataList[2].bUseTextColor = true;
		Record.LVDataList[2].TextColor = getColor(120, 120, 120, 255);
		Record.LVDataList[2].attrColor = Record.LVDataList[2].TextColor;
	}

	// ������ �������� �ƴϸ� �Ǹ� ������ �հ踦 ����� �ʿ䰡 ����
	if(Record.LVDataList[2].hasIcon)
	{
		price = getItemInfoArray[ int(Record.nReserved3)].price ;
		remainingItemNum = Record.nReserved2 - itemNum;
		remainingItemPrice = remainingItemNum * price; 


		if(remainingItemNum == 0)
			remainingString = "0";
		else
			remainingString = ConvertNumToTextNoAdena(String(remainingItemPrice));

		Record.LVDataList[2].attrStat[0] = MakeFullSystemMsg(GetSystemMessage(3657), remainingString);
	}

	return Record.LVDataList[2];
}

// ������ ���� ǥ�� 
function LVData makeItemNumRecord(LVDataRecord Record, int64 itemNum)
{
	local string itemNumEasyRead;

	if(Record.nReserved2 > 9999)
		itemNumEasyRead = "9999+";
	else 
		itemNumEasyRead = String(Record.nReserved2);

	if(itemNum > Record.nReserved2)itemNum = Record.nReserved2;
	
	// ���� ���� ��� �� �ٷ� ǥ�� �ǹǷ�, ConsumeType == StackableItem �̴�. 
	Record.LVDataList[1].szData =(Record.nReserved2 - itemNum)$"/"$itemNumEasyRead;	
	
	//if(Record.LVDataList[2].hasIcon)	
	//	Record.LVDataList[1].szData =(Record.nReserved2 - itemNum)$"/"$itemNumEasyRead;	
	//else 	
	//	Record.LVDataList[1].szData = String(Record.nReserved2 - itemNum);
	
	//Record.LVDataList[1].HiddenStringForSorting = String(Record.nReserved2);	

	// �Ϸ� �� �޽��� ���� 
	if(itemNum == Record.nReserved2)
	{
		Record.LVDataList[1].bUseTextColor = true;
		Record.LVDataList[1].TextColor = getColor(120, 120, 120, 255);
		Record.LVDataList[1].attrColor = Record.LVDataList[1].TextColor;

		if(messageType == "buy") 
			Record.LVDataList[1].attrStat[0] = GetSystemString(3621);	
		else 
			Record.LVDataList[1].attrStat[0] = GetSystemString(3616);	
	}
	else if(messageType == "buy")
		Record.LVDataList[1].attrStat[0] = GetSystemString(1434)$":"$itemNum;
	else 
		Record.LVDataList[1].attrStat[0] = GetSystemString(1157)$":"$itemNum;	
	
	
	return Record.LVDataList[1];
}


// ��� �Ǹ� �� ��Ȱ�� ǥ�� 
function LVData makeItemNameRecord(LVDataRecord Record, int64 itemNum)
{
	if(itemNum == Record.nReserved2)
	{
		Record.LVDataList[0].bUseTextColor = true;
		Record.LVDataList[0].TextColor = getColor(120, 120, 120, 255);
		
		Record.LVDataList[0].iconPanelName = "L2UI_CT1.Windows.WindowDisable_BG";
		Record.LVDataList[0].panelOffsetXFromIconPosX=0;
		Record.LVDataList[0].panelOffsetYFromIconPosY=0;
		Record.LVDataList[0].panelWidth=32;
		Record.LVDataList[0].panelHeight=32;
		Record.LVDataList[0].panelUL=32;
		Record.LVDataList[0].panelVL=32;		
	}
	return Record.LVDataList[0];
}

function LVDataRecord makeRecord(int index)
{
	local LVDataRecord Record;
	local string param, fullNameString, costString;	
	local itemInfo Info;

	// ParamToItemInfo(param, info);
	// ParamAdd(param, "ClassID", string(info.ID.ClassID));
	
	Info = getItemInfoArray [index];	

	fullNameString = GetItemNameAll(info);

	//if(itemNameClass == 0)		 //������ ������ 
	//{
	//	fullNameString = MakeFullSystemMsg(GetSystemMessage(2332), fullNameString);
	//}
	//else if(itemNameClass == 2)//����� ������
	//{
	//	fullNameString = MakeFullSystemMsg(GetSystemMessage(2331), fullNameString);
	//}
	//if(Len(additionalName)> 0)
	//{
	//	fullNameString = fullNameString $ "(" $ additionalName $ ")";
	//}
	
	// �ش� ������ ���� ����Ʈ�� �����������ü� �ֵ��� ���  <- �߱��ʿ��� ���� api
	//class'UIDATA_ITEM'.static.GetItemInfoString(info.Id.ClassID, param);  

	// ������ �����ϱ� ���� param���� ���� ���
	ItemInfoToParam(info, param);
	
	// ���� ����
	Record.szReserved = param;	
	// ������ ���� ���̵�
	Record.nReserved1 = Int64(info.Id.ServerID);
	// ������ �ִ� ��
	Record.nReserved2 = info.ItemNum ;
	// ������ ������ index ��
	Record.nReserved3 = index;
	Record.LVDataList.length = 4;

	Record.LVDataList[0].szData = fullNameString;	

	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nTextureWidth=32;
	Record.LVDataList[0].nTextureHeight=32;
	Record.LVDataList[0].nTextureU=32;
	Record.LVDataList[0].nTextureV=32;
	Record.LVDataList[0].szTexture = info.IconName; 
	Record.LVDataList[0].IconPosX=10;
	Record.LVDataList[0].FirstLineOffsetX=6;
	Record.LVDataList[0].HiddenStringForSorting = fullNameString;// $ util.makeZeroString(3, enchanted);
	// Record.LVDataList[0].HiddenStringForSorting = itemName $ util.makeZeroString(3, enchanted);
	
	// back texture 
	Record.LVDataList[0].iconBackTexName="l2ui_ct1.ItemWindow_DF_SlotBox_Default";
	Record.LVDataList[0].backTexOffsetXFromIconPosX=-2;
	Record.LVDataList[0].backTexOffsetYFromIconPosY=-1;
	Record.LVDataList[0].backTexWidth=36;
	Record.LVDataList[0].backTexHeight=36;
	Record.LVDataList[0].backTexUL=36;
	Record.LVDataList[0].backTexVL=36;

	// ������ �׵θ�(�⺻ ����.pvp �����)
	Record.LVDataList[0].iconPanelName = info.iconPanel;
	Record.LVDataList[0].panelOffsetXFromIconPosX=0;
	Record.LVDataList[0].panelOffsetYFromIconPosY=0;
	Record.LVDataList[0].panelWidth=32;
	Record.LVDataList[0].panelHeight=32;
	Record.LVDataList[0].panelUL=32;
	Record.LVDataList[0].panelVL=32;
	// End:0x368
	if(isCollectionItem(Info))
	{
		Record.LVDataList[0].foreTextureName = "L2UI_EPIC.Icon.IconPanel_coll";
		Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
		Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
		Record.LVDataList[0].panelWidth = 32;
		Record.LVDataList[0].panelHeight = 32;
		Record.LVDataList[0].panelUL = 32;
		Record.LVDataList[0].panelVL = 32;
	}
	// End:0x3A5
	if(Info.IsBlessedItem)
	{
		Record.LVDataList[0].BlessedItemIconPanelName = "Icon.icon_panel.bless_panel";
	}

	// ��ȭ ǥ��
	if(Info.enchanted > 0)
	{
		Record.LVDataList[0].arrTexture.Length = 3;
		lvTextureAddItemEnchantedTexture(Info.enchanted, Record.LVDataList[0].arrTexture[0], Record.LVDataList[0].arrTexture[1],Record.LVDataList[0].arrTexture[2], 9, 11);
	}
	// IsStackableItem �� Record.LVDataList[2].hasIcon == true �� �Ǵ� �ϱ� ������ �ڿ� ������ ����.
	// ������, ������� ��� ����/��ü �� ǥ�� �ϵ��� ��
	Record.LVDataList[1].hasIcon = true;
	Record.LVDataList[1].attrColor = getColor(200, 200, 200, 255);	
	Record.LVDataList[1].textAlignment=TA_Center;
	//Record.LVDataList[1].HiddenStringForSorting = String(Record.nReserved2);
	Record.LVDataList[1] = makeItemNumRecord(Record, getItemNumArray[index]);
	

	costString = MakeCostString(String(info.Price));
	Record.LVDataList[2].szData = ConvertNumToTextNoAdena(String(info.Price));
	Record.LVDataList[2].buseTextColor = true;
	Record.LVDataList[2].textColor = GetNumericColor(costString);
	Record.LVDataList[2].textAlignment = TA_Right;	
	Record.LVDataList[2].HiddenStringForSorting = util.makeZeroString(20,info.Price);

	
	//Debug(info.ConsumeType @ IsStackableItem(info.ConsumeType));
	// ������ �������̶�� �� ���� ǥ��
	if(IsStackableItem(info.ConsumeType))
	{
		// hasIcon = true; ���ٷ� ǥ�� �Ͻÿ� 
		Record.LVDataList[2].hasIcon = true;
		Record.LVDataList[2].attrColor = getColor(200, 200, 200, 255);
		Record.LVDataList[2].attrStat[0] = MakeFullSystemMsg(GetSystemMessage(3657), ConvertNumToTextNoAdena(String(info.Price * info.itemNum)));		
		Record.LVDataList[2].textAlignment=TA_Right;
	}

	costString = MakeCostString(String(info.Price * getItemNumArray[index]));	
	Record.LVDataList[3].buseTextColor = true;
	Record.LVDataList[3].textColor = GetNumericColor(costString);	
	//Record.LVDataList[3].HiddenStringForSorting = String(info.Price);
	Record.LVDataList[3].szData = costString;
	Record.LVDataList[3].textAlignment = TA_Right;
	//Record.LVDataList[3].hasIcon = true;
	//Record.LVDataList[3].attrColor = getColor(200, 200, 200, 255);
	//Record.LVDataList[3].attrStat[0] = "("$ getItemNumArray[index] $")";
	//Record.LVDataList[3].textAlignment=TA_Right;

	return record ;
}

/** �������� �߰� �Ѵ�. */
function addItem(int index)
{
	ItemList_ListCtrl.InsertRecord(makeRecord(index));
}

/***********************************************************************************
 * �ݴ´�
 * **********************************************************************************/
function bool checkShoppingEnd()
{
	local int i ;
	for(i = 0 ; i < getItemInfoArray.length ; i++)
	{
		//Debug("checkShoppingEnd" @ getItemNumArray[i] @ getItemInfoArray[i].itemNum);
		if(getItemNumArray[i] != getItemInfoArray[i].itemNum)return false;
	}
	return true;
}

function Onhistory_BtnClick()
{
	if(class'UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWndHistory"))
		class'UIAPI_WINDOW'.static.hideWindow("PrivateShopWndHistory");
	else 
		class'UIAPI_WINDOW'.static.showWindow("PrivateShopWndHistory");

}

//function OnStopSell_BtnClick()
//{
//	// �� �ȸ��ų�, ���� ��ư Ŭ�� ��	
//	//if(checkShoppingEnd())Me.HideWindow();
//	//else handleQuit();
//}

function handleQuit()
{		
	if(!checkShoppingEnd())
		privateShopScript.contextMenuQuit();
	else if( !IsPlayerStand())ExecuteCommand("/stand");	
	Me.HideWindow();
}

/***********************************************************************************
 * ������ ��
 * **********************************************************************************/
function bool compareItem(itemInfo info1, itemInfo info2 )
{
	if(
		info1.Enchanted                     != info2.Enchanted ||
		info1.Damaged                       != info2.Damaged ||
		info1.RefineryOp1                   != info2.RefineryOp1 ||
		info1.RefineryOp2                   != info2.RefineryOp2 ||
		info1.LookChangeItemID              != info2.LookChangeItemID ||
		info1.AttackAttributeType           != info2.AttackAttributeType ||
		info1.AttackAttributeValue          != info2.AttackAttributeValue ||
		info1.DefenseAttributeValueFire     != info2.DefenseAttributeValueFire ||
		info1.DefenseAttributeValueWater    != info2.DefenseAttributeValueWater ||
		info1.DefenseAttributeValueWind     != info2.DefenseAttributeValueWind ||
		info1.DefenseAttributeValueEarth    != info2.DefenseAttributeValueEarth ||
		info1.DefenseAttributeValueHoly     != info2.DefenseAttributeValueHoly ||
		info1.DefenseAttributeValueUnholy   != info2.DefenseAttributeValueUnholy ||	
		info1.IsBlessedItem					!= info2.IsBlessedItem ||	
		!compareParamEnSoul(info1, info2)
	)return false;

	return true;
}

function bool compareParamEnSoul(ItemInfo info1, ItemInfo info2)
{
	local int i, n;
	local int cnt ;

	// ��ȥ �ý��� ����(2015-02-09 �߰�)
	for(i=EIST_NORMAL; i<EIST_MAX; i++)
	{
		cnt = info1.EnsoulOption[i - EIST_NORMAL].OptionArray.Length;

		if(cnt != info2.EnsoulOption[i - EIST_NORMAL].OptionArray.Length)return false;

		for(n=EISI_START; n<EISI_START + cnt; n++)
		{			
			if(info1.EnsoulOption[i - EIST_NORMAL].OptionArray[n - EISI_START] != info2.EnsoulOption[i - EIST_NORMAL].OptionArray[n - EISI_START])return false;
		}
	}
	return true;
}

defaultproperties
{
}
