/***
 *   종료 리포트 (종료, 리스타트 창), 보조 아이템 목록 보기 창
 **/
class RestartMenuWndReportLostItem extends UICommonAPI;

struct DieInfoDropItemData
{
	var int ItemClassID;
	var int itemEnchant;
	var int ItemAmount;
};

var string m_WindowName;
var WindowHandle Me;
var RichListCtrlHandle itemListCtrl;
var ButtonHandle CloseBtn;
var L2Util util;

function Initialize()
{
	Me = GetWindowHandle(m_WindowName);
	itemListCtrl = GetRichListCtrlHandle(m_WindowName $ ".RestartmenuWndReport_ListCtrl");
	CloseBtn = GetButtonHandle(m_WindowName $ ".CloseBtn");
	util = L2Util(GetScript("L2Util"));
	itemListCtrl.SetSelectedSelTooltip(false);
	itemListCtrl.SetAppearTooltipAtMouseX(true);
}

event OnRegisterEvent()
{
	RegisterEvent(EV_DieInfoBegin  );
	RegisterEvent(EV_DieInfoEnd  );
	RegisterEvent(EV_DieInfoDropItem  );
	// RegisterEvent(EV_DieInfoDamage  );
}

event OnEvent ( int eventID, string param ) 
{

	// Debug ( "OnEvent" @ eventID @ param ) ;
	switch ( eventID ) 
	{
		case EV_DieInfoBegin :
			handleDieInfoBegin();
			break;
		//case EV_DieInfoDamage : 
		//	handleDieInfoDamage( param );
		//	break;		
		case EV_DieInfoDropItem : 
			handleDieInfoDropitem ( param );
			Debug ( "EV_DieInfoDropItem" @ param );
			break;
		case EV_DieInfoEnd : 
			handleDieInfoEnd();
			break;

	}
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

// OnClickButton
event OnClickButton( string Name )
{
	switch( Name )
	{
		case "minCloseButton" :
		case "CloseBtn":
			 Me.HideWindow();
			 break;
	}
}

function handleDieInfoBegin()
{
	itemListCtrl.DeleteAllItem();
}


function handleDieInfoEnd() {}

function handleDieInfoDropitem(string param)
{
	local ItemID cID;
	local RichListCtrlRowData RowData;
	local DieInfoDropItemData Data;
	local ItemInfo Info;
	local string ItemName, IconName;
	local int tW, tH;

	RowData.cellDataList.Length = 1;
	Data = GetDieInfoLostItem(param);
	cID.ClassID = Data.ItemClassID;
	Info = GetItemInfoByClassID(Data.ItemClassID);
	ItemName = GetItemNameAll(Info);
	IconName = class'UIDATA_ITEM'.static.GetItemTextureName(cID);
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 0);
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, IconName, 32, 32, -34, 2);
	// End:0x130
	if(Data.itemEnchant < 1)
	{
		AddEllipsisString(RowData.cellDataList[0].drawitems, ItemName, 290, getInstanceL2Util().BrightWhite, false, true, 3, 9);		
	}
	else
	{
		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.ENCHANTNUMBER_SMALL_plus", 6, 8, -34, 24);
		// End:0x211
		if(Data.itemEnchant < 10)
		{
			addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ string(Data.itemEnchant), 6, 8, 0, 0);
			addRichListCtrlString(RowData.cellDataList[0].drawitems, "+" $ string(Data.itemEnchant), GetColor(170, 110, 230, 255), false, 26, -14);			
		}
		else
		{
			addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ string(Data.itemEnchant / 10), 6, 8, 0, 0);
			addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ string(int(float(Data.itemEnchant) % float(10))), 6, 8, 0, 0);
			addRichListCtrlString(RowData.cellDataList[0].drawitems, "+" $ string(Data.itemEnchant), GetColor(170, 110, 230, 255), false, 20, -14);
		}
		GetTextSizeDefault("+" $ string(Data.itemEnchant), tW, tH);
		AddEllipsisString(RowData.cellDataList[0].drawitems, ItemName, 288 - tW, getInstanceL2Util().BrightWhite, false, true, 5);
	}
	// End:0x39A
	if(IsStackableItem(Info.ConsumeType))
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, "x" $ string(Data.ItemAmount), GetColor(200, 170, 120, 255), false, 5, 0);
	}
	itemListCtrl.InsertRecord(RowData);
}


/** 칼라 를 리턴한다. */
function Color GetColor (int r, int g, int b, int a  )
{
	local Color tColor;
	tColor.R = r;
	tColor.G = g;
	tColor.B = b;	
	tColor.A = a;	

	return tColor;
}

function DieInfoDropItemData GetDieInfoLostItem(string param)
{
	local DieInfoDropItemData Data;

	ParseInt(param, "ItemClassID", Data.ItemClassID);
	ParseInt(param, "ItemEnchant", Data.itemEnchant);
	ParseInt(param, "ItemAmount", Data.ItemAmount);
	return Data;
}

// 리스트 컨트롤에 인챈트 수치 표현하기 
// "0" ~ "9"  "plus"
//	record.LVDataList[0].arrTexture.Length = 3;
//	lvTextureAddItemEnchantedTexture(14, record.LVDataList[0].arrTexture[0], record.LVDataList[0].arrTexture[1],record.LVDataList[0].arrTexture[2], 100, 7);
function lvTextureAddItemEnchantedTexture(int nEnchanted, out LVTexture lvTexture1, out LVTexture lvTexture2, out LVTexture lvTexture3, int x, int y)
{
	local string s1, s2;
	local string ss;

	if(nEnchanted > 0)
		lvTextureAdd(lvTexture1, "L2UI_CT1.ENCHANTNUMBER_SMALL_plus", x, y, 6, 8);

	if(nEnchanted > 9)
	{
		ss = string(nEnchanted);
		s1 = Left(ss, 1);
		s2 = Right(ss, 1);
		lvTextureAdd(lvTexture2, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ s1, x + 6, y, 6, 8);
		lvTextureAdd(lvTexture3, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ s2, x + 12, y, 6, 8);
	}
	else if (nEnchanted > 0 && nEnchanted < 10)
	{
		lvTextureAdd(lvTexture2, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ String(nEnchanted), x + 6, y, 6, 8);
	}
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();
}

defaultproperties
{
     m_WindowName="RestartMenuWndReportLostItem"
}
