class PrivateShopFind_Main extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle Desc01_txt;
var TextBoxHandle Desc03_txt;
var RichListCtrlHandle List01_RichList;
var RichListCtrlHandle List02_RichList;
var PrivateShopFindWnd PrivateShopFindWndScript;
var bool bFirstSetting;

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PRIVATE_STORE_SEARCH_STATISTICS);
}

function OnLoad()
{
	Initialize();
}

function OnShow()
{
	// End:0x65
	if(GetWindowHandle("PrivateShopFindWnd").IsShowWindow())
	{
		Debug("OnShow  PrivateShopFind_Main");
		// End:0x65
		if(bFirstSetting == false)
		{
			bFirstSetting = true;
			API_C_EX_PRIVATE_STORE_SEARCH_STATISTICS();
		}
	}
}

function Initialize()
{
	Me = GetWindowHandle("PrivateShopFind_Main");
	Desc01_txt = GetTextBoxHandle("PrivateShopFind_Main.Desc01_txt");
	Desc03_txt = GetTextBoxHandle("PrivateShopFind_Main.Desc03_txt");
	List01_RichList = GetRichListCtrlHandle("PrivateShopFind_Main.List01_RichList");
	List02_RichList = GetRichListCtrlHandle("PrivateShopFind_Main.List02_RichList");
	List01_RichList.SetSelectedSelTooltip(false);
	List01_RichList.SetAppearTooltipAtMouseX(true);
	List01_RichList.SetSelectable(false);
	List02_RichList.SetSelectedSelTooltip(false);
	List02_RichList.SetAppearTooltipAtMouseX(true);
	List02_RichList.SetSelectable(false);
	PrivateShopFindWndScript = PrivateShopFindWnd(GetScript("PrivateShopFindWnd"));
	bFirstSetting = false;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x1A
		case EV_GameStart:
			bFirstSetting = false;
			// End:0x4D
			break;
		// End:0x2A
		case EV_Restart:
			bFirstSetting = false;
			// End:0x4D
			break;
		// End:0x4A
		case EV_PacketID(class'UIPacket'.const.S_EX_PRIVATE_STORE_SEARCH_STATISTICS):
			ParsePacket_S_EX_PRIVATE_STORE_SEARCH_STATISTICS();
			// End:0x4D
			break;
	}
}

function ParsePacket_S_EX_PRIVATE_STORE_SEARCH_STATISTICS()
{
	local UIPacket._S_EX_PRIVATE_STORE_SEARCH_STATISTICS packet;
	local ItemInfo Info;
	local int i;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PRIVATE_STORE_SEARCH_STATISTICS(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_PRIVATE_STORE_SEARCH_STATISTICS :  " @ string(packet.mostItems.Length)) @ string(packet.highestItems.Length));
	List01_RichList.DeleteAllItem();

	// End:0x109 [Loop If]
	for(i = 0; i < packet.mostItems.Length; i++)
	{
		RequestDisassembleItemInfo(packet.mostItems[i].itemAssemble, Info);
		addRichListItemAmount(i + 1, Info.Id.ClassID, Info.ItemNum, packet.mostItems[i].nCount);
	}
	List02_RichList.DeleteAllItem();

	// End:0x190 [Loop If]
	for(i = 0; i < packet.highestItems.Length; i++)
	{
		RequestDisassembleItemInfo(packet.highestItems[i].itemAssemble, Info);
		addRichListItemPrice(i + 1, Info, Info.ItemNum, packet.highestItems[i].nPrice);
	}
}

function addRichListItemAmount(int Rank, int ClassID, INT64 Amount, INT64 dealCount)
{
	local RichListCtrlRowData RowData;
	local ItemInfo Info;

	Info = GetItemInfoByClassID(ClassID);
	RowData.cellDataList.Length = 3;
	addRichListCtrlString(RowData.cellDataList[0].drawitems, string(Rank), GTColor().White, false, 0, 0);
	AddRichListCtrlItem(RowData.cellDataList[1].drawitems, Info, 32, 32, 4, 2, "noTooltip");
	addRichListCtrlString(RowData.cellDataList[1].drawitems, GetItemNameAll(Info), GTColor().White, false, 4, 9);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, MakeCostStringINT64(dealCount), GTColor().White, false, 0, 0);
	List01_RichList.InsertRecord(RowData);
}

function addRichListItemPrice(int Rank, ItemInfo Info, INT64 Amount, INT64 adenaPrice)
{
	local RichListCtrlRowData RowData;

	RowData.cellDataList.Length = 3;
	addRichListCtrlString(RowData.cellDataList[0].drawitems, string(Rank), GTColor().White, false, 0, 0);
	AddRichListCtrlItem(RowData.cellDataList[1].drawitems, Info, 32, 32, 4, 2, "noTooltip");
	addRichListCtrlString(RowData.cellDataList[1].drawitems, GetItemNameAll(Info), GTColor().White, false, 4, 2);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, "x" $ MakeCostStringINT64(Amount), GTColor().White, true, 40, 2);
	addRichListCtrlTexture(RowData.cellDataList[2].drawitems, "L2UI_EPIC.RestartMenuWnd.Icon_Adena", 18, 13, 156, 10);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, "", GTColor().White, true, 0, 0);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, ConvertNumToTextNoAdena(string(adenaPrice)), GetNumericColor(MakeCostStringINT64(adenaPrice)), false, 0, -14);
	List02_RichList.InsertRecord(RowData);
}

function API_C_EX_PRIVATE_STORE_SEARCH_STATISTICS()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PRIVATE_STORE_SEARCH_STATISTICS, stream);
	Debug("api Call : C_EX_PRIVATE_STORE_SEARCH_STATISTICS");
}

defaultproperties
{
}
