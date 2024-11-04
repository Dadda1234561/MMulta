/***
 *   종료 리포트 (종료, 리스타트 창), 보조 아이템 목록 보기 창
 **/
class QuitReportDrawerWnd extends UICommonAPI;

var WindowHandle Me;

var ListCtrlHandle ItemListCtrl;
var ButtonHandle   closeBtn;

// 아이템 정렬용 index 
var int itemIndex;

var L2Util util;
var InventoryWnd  inventoryWndScript;
var QuitReportWnd QuitReportWndScript;

function OnRegisterEvent()
{
	//RegisterEvent(  );
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}


function OnShow()
{
	updateList();
}

function OnHide()
{
}

function Initialize()
{
	Me           = GetWindowHandle( "QuitReportDrawerWnd" );
	ItemListCtrl = GetListCtrlHandle( "QuitReportDrawerWnd.InstanceDungeon_ListCtrl" );
	closeBtn     = GetButtonHandle( "QuitReportDrawerWnd.EnsoulInfoBtn" );

	util                = L2Util(GetScript("L2Util"));
	inventoryWndScript  = inventoryWnd(GetScript("inventoryWnd"));
	QuitReportWndScript = QuitReportWnd(GetScript("QuitReportWnd"));

	ItemListCtrl.SetSelectedSelTooltip(FALSE);	
	ItemListCtrl.SetAppearTooltipAtMouseX(true);

	init();
}

// OnClickButton
function OnClickButton( string Name )
{
	switch( Name )
	{
		case "EnsoulInfoBtn":
			 OnEnsoulInfoBtnClick();
			 break;
	}
}

// 외부(인벤토리) 에서 아이템을 추가 하는 것
function externalAddItem(ItemInfo addItemInfo)
{
	// Debug("addItemInfo:::" @ addItemInfo.Id.ClassID);

	// 수량성 아이템이면
	if ( IsStackableItem( addItemInfo.ConsumeType ))
	{
		// Debug("수량성 아이템 처리-----------");
		sumStackableItem(addItemInfo);
	}
	else
	{
		// Debug("일반 아이템 처리-----------");
		// 수량성 아이템이 아니면 그냥 그대로 넣는다.
		AddItem(addItemInfo);
	}

	if (Me.IsShowWindow()) updateList();
}

function int getTotalItemCount()
{
	return itemListCtrl.GetRecordCount();
}

// 초기화
function Init()
{
	itemIndex = 99999;
	itemListCtrl.DeleteAllItem();
}

// 수량성 아이템인 경우 처리
function sumStackableItem(ItemInfo addItemInfo)
{
	local int Index;
	local ItemInfo beforeItemInfo;

	inventoryWndScript.getInventoryItemInfo(addItemInfo.Id, beforeItemInfo, true);
	// 빠진 경우도 update 이벤트로 오기 때문에 더해진 경우만..
	if(beforeItemInfo.ItemNum < addItemInfo.ItemNum)
	{
		addItemInfo.ItemNum = getIndexListItemCount(addItemInfo.Id.ClassID) + (addItemInfo.ItemNum - beforeItemInfo.ItemNum);
		Index = getIndexList(addItemInfo.Id.ClassID);
		// End:0xB1
		if(Index > -1)
		{
			AddItem(addItemInfo, Index, true);			
		}
		else
		{
			AddItem(addItemInfo);
		}
	}
}

// 전체 목록 갱신 
function updateList()
{
	QuitReportWndScript.UpdateUserInfoHandler();	
}

function int getIndexList(int ClassID)
{
	local LVDataRecord Record;
	local int i;

	// End:0x60 [Loop If]
	for(i = 0; i < itemListCtrl.GetRecordCount(); i++)
	{
		itemListCtrl.GetRec(i, Record);
		// End:0x56
		if(Record.nReserved1 == ClassID)
		{
			return i;
		}
	}
	return -1;	
}

function INT64 getIndexListItemCount(int ClassID)
{
	local LVDataRecord Record;
	local int i;

	// End:0x65 [Loop If]
	for(i = 0; i < itemListCtrl.GetRecordCount(); i++)
	{
		itemListCtrl.GetRec(i, Record);
		// End:0x5B
		if(Record.nReserved1 == ClassID)
		{
			return Record.nReserved2;
		}
	}
	return 0;	
}

/** 아이템을 추가 한다. */
function AddItem(ItemInfo Info, optional int modifyIndex, optional bool bModifyList)
{
	local LVDataRecord Record;
	local string param, AdditionalName, fullNameString, itemNumEasyRead;
	local int itemNameClass;

	// End:0x18
	if(Info.Id.ClassID == 57)
	{
		return;
	}
	// ParamToItemInfo(param, info);
	// ParamAdd(param, "ClassID", string(info.ID.ClassID));
	itemIndex--;

	fullNameString = Info.Name;
	itemNameClass = class'UIDATA_ITEM'.static.GetItemNameClass(Info.Id);
	AdditionalName = class'UIDATA_ITEM'.static.GetItemAdditionalName(Info.Id);

	if(itemNameClass == 0)		 //보급형 아이템 
	{
		fullNameString = MakeFullSystemMsg(GetSystemMessage(2332), fullNameString);
	}
	else if(itemNameClass == 2) //희귀한 아이템
	{
		fullNameString = MakeFullSystemMsg(GetSystemMessage(2331), fullNameString);
	}
	if(Len(AdditionalName) > 0)
	{
		fullNameString = fullNameString $ "(" $ AdditionalName $ ")";
	}
	
	// 해당 아이템 정보 리스트에 넣을때꺼내올수 있도록 기억  <- 중국쪽에서 만든 api
	//class'UIDATA_ITEM'.static.GetItemInfoString(info.Id.ClassID, param);  

	ItemInfoToParam(Info, param);
	Record.szReserved = param;
	Record.nReserved1 = Info.Id.ClassID;
	Record.nReserved2 = Info.ItemNum;
	Record.LVDataList.length = 4;
	// 아이템 
	////record.LVDataList[0].buseTextColor = True;
	//if ( IsStackableItem( info.ConsumeType ) )
	//{
	//	 Record.LVDataList[0].textColor =  getColor(100,111,22, 255);
	//}
	//else Record.LVDataList[0].textColor = getColor(100,30,3, 255);
	Record.LVDataList[0].szData = fullNameString;
	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nTextureWidth = 32;
	Record.LVDataList[0].nTextureHeight = 32;
	Record.LVDataList[0].nTextureU = 32;
	Record.LVDataList[0].nTextureV = 32;
	Record.LVDataList[0].szTexture = Info.IconName;
	Record.LVDataList[0].IconPosX = 10;
	Record.LVDataList[0].FirstLineOffsetX = 6;
	Record.LVDataList[0].HiddenStringForSorting = string(itemIndex);// $ util.makeZeroString(3, enchanted);
	// Record.LVDataList[0].HiddenStringForSorting = itemName $ util.makeZeroString(3, enchanted);
	// back texture
	Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
	Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
	Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
	Record.LVDataList[0].backTexWidth = 36;
	Record.LVDataList[0].backTexHeight = 36;
	Record.LVDataList[0].backTexUL = 36;
	Record.LVDataList[0].backTexVL = 36;
	// 아이콘 테두리 (기본 병기.pvp 무기등)
	Record.LVDataList[0].iconPanelName = Info.IconPanel;
	Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
	Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
	Record.LVDataList[0].panelWidth = 32;
	Record.LVDataList[0].panelHeight = 32;
	Record.LVDataList[0].panelUL = 32;
	Record.LVDataList[0].panelVL = 32;

	// 강화 표시
	if (info.enchanted > 0)
	{
		Record.LVDataList[0].arrTexture.Length = 3;
		lvTextureAddItemEnchantedTexture(Info.Enchanted, Record.LVDataList[0].arrTexture[0], Record.LVDataList[0].arrTexture[1],Record.LVDataList[0].arrTexture[2], 9, 11);
	}

	// 수량성 아이템
	if(IsStackableItem(Info.ConsumeType))
	{

		if(Info.ItemNum > 9999) itemNumEasyRead = "9999+";
		else itemNumEasyRead = String(Info.ItemNum);

		Record.LVDataList[1].szData = itemNumEasyRead;
		Record.LVDataList[1].textAlignment = TA_Center;
		Record.LVDataList[1].HiddenStringForSorting =  util.makeZeroString(13, Info.ItemNum);
	}
	else
	{
		Record.LVDataList[1].HiddenStringForSorting = util.makeZeroString(13, Info.ItemNum);
	}
	// End:0x4D5
	if(bModifyList)
	{
		itemListCtrl.ModifyRecord(modifyIndex, Record);		
	}
	else
	{
		itemListCtrl.InsertRecord(Record);
	}
}

function OnEnsoulInfoBtnClick()
{
	// 오픈 버튼 "<-" 텍스쳐 교체
	QuitReportWndScript.setDrawerButtonState(true);
	Me.HideWindow();
}


/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(Self))).HideWindow();
}

defaultproperties
{
}
