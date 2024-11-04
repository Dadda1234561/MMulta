class BoxCreateInfosLikeTooltip extends UICommonAPI;

const ITEMNAME_ICON_WHITESPACE = 70;
const ITEMNAME_HEIGHT = 58;
const LIST_HEIGHT = 28;
const LIST_SHOWROW = 20;

var WindowHandle Me;
var RichListCtrlHandle List_ListCtrl;
var ItemWindowHandle Item_ItemWindow;
var HtmlHandle ItemName_HtmlCtrl;
var array<CreateResultItemData> fixedItemList;
var array<CreateResultItemData> addItemList;
var array<CreateResultItemData> randomItemList;
var bool bUsePercentColumn;
var int LIST_PERCENT_COLUMN;

function OnRegisterEvent()
{
	RegisterEvent(EV_RequestShowXMLDetailTooltip);
	RegisterEvent(EV_HideXMLDetailTooltip);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_GameStart);
}

function OnLoad()
{
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle("BoxCreateInfosLikeTooltip");
	List_ListCtrl = GetRichListCtrlHandle("BoxCreateInfosLikeTooltip" $ ".List_ListCtrl");
	Item_ItemWindow = GetItemWindowHandle("BoxCreateInfosLikeTooltip" $ ".Item_ItemWindow");
	ItemName_HtmlCtrl = GetHtmlHandle("BoxCreateInfosLikeTooltip" $ ".ItemName_HtmlCtrl");
	List_ListCtrl.SetSelectable(false);
}

event OnEvent(int a_EventID, string a_Param)
{
	local int IconX, IconY, ClassID, clientW, clientH, ShortcutType;

	local string TooltipType;

	switch(a_EventID)
	{
		// End:0xC8
		case EV_RequestShowXMLDetailTooltip:
			ParseString(a_Param, "TooltipType", TooltipType);
			// End:0x3F
			if(TooltipType == "Skill")
			{
				return;
			}
			// End:0x52
			if(TooltipType == "Macro")
			{
				return;
			}
			// End:0x66
			if(TooltipType == "Action")
			{
				return;
			}
			ParseInt(a_Param, "ShortCutType", ShortcutType);
			if((ShortcutType == 1) || ShortcutType == 0)
			{
				ParseInt(a_Param, "IconX", IconX);
				ParseInt(a_Param, "IconY", IconY);
				ParseInt(a_Param, "clientW", clientW);
				ParseInt(a_Param, "clientH", clientH);
				ParseInt(a_Param, "classID", ClassID);
				ShowCreateInfos(IconX, IconY, clientW, clientH, ClassID);
				Me.SetFocus();
				List_ListCtrl.SetFocus();
			}
			// End:0x197
			break;
		// End:0xD0
		case EV_GameStart:
		// End:0xD5
		case EV_Restart:
		// End:0x101
		case EV_HideXMLDetailTooltip:
			// End:0xFE
			if(Me.IsShowWindow())
			{
				Me.HideWindow();
			}
			// End:0x104
			break;
	}
}

event OnShow()
{
	ReturnShowXMLDetailTooltip(true);
}

event OnHide()
{}

function ShowCreateInfos(int lconX, int lconY, int clientW, int clientH, int ClassID)
{
	local int i, Count, maxTextW, W, h, N,
		itemNameTextW;

	local array<ItemCreateUIData> o_ItemList;
	local string titleStr, htmlAdd;
	local ItemInfo Info;
	local int OffsetX, toolTipWidth, TooltipHeight;

	class'UIDATA_ITEM'.static.GetItemCreateInfo(ClassID, o_ItemList);
	bUsePercentColumn = true;
	// End:0x2F
	if(o_ItemList.Length == 0)
	{
		return;
	}
	Info = GetItemInfoByClassID(ClassID);
	Item_ItemWindow.Clear();
	Item_ItemWindow.AddItem(Info);
	GetTextSize(Info.Name @ Info.AdditionalName, "gameDefault10", itemNameTextW, h);
	htmlAdd = htmlAddText(Info.Name, "gameDefault10", getColorHexString(GTColor().BrightWhite));
	// End:0x12C
	if(Info.AdditionalName != "")
	{
		htmlAdd = htmlAdd $ (htmlAddText(" " $ Info.AdditionalName, "gameDefault10", getColorHexString(GTColor().Yellow)));
	}
	ItemName_HtmlCtrl.SetWindowSize(itemNameTextW + LIST_SHOWROW, h + 4);
	ItemName_HtmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(htmlAdd));
	List_ListCtrl.DeleteAllItem();
	// End:0x31C
	if(Info.MaxUseCount <= 0)
	{
		itemNameTextW = itemNameTextW + ITEMNAME_ICON_WHITESPACE;
		toolTipWidth = divCreateInfos(maxTextW, o_ItemList);

		// End:0x225 [Loop If]
		for(i = 0; i < fixedItemList.Length; i++)
		{
			// End:0x1F4
			if(i == 0)
			{
				List_ListCtrl.InsertRecord(makeTitleListItem(GetSystemString(13978)));
				Count++;
			}
			List_ListCtrl.InsertRecord(makeRecord(fixedItemList[i]));
			Count++;
		}

		// End:0x29F [Loop If]
		for(i = 0; i < addItemList.Length; i++)
		{
			// End:0x26E
			if(i == 0)
			{
				List_ListCtrl.InsertRecord(makeTitleListItem(GetSystemString(13979)));
				Count++;
			}
			List_ListCtrl.InsertRecord(makeRecord(addItemList[i]));
			Count++;
		}

		// End:0x319 [Loop If]
		for(i = 0; i < randomItemList.Length; i++)
		{
			// End:0x2E8
			if(i == 0)
			{
				List_ListCtrl.InsertRecord(makeTitleListItem(GetSystemString(13980)));
				Count++;
			}
			List_ListCtrl.InsertRecord(makeRecord(randomItemList[i]));
			Count++;
		}		
	}
	else
	{
		itemNameTextW = itemNameTextW + ITEMNAME_ICON_WHITESPACE;

		// End:0x476 [Loop If]
		for(i = 0; i < o_ItemList.Length; i++)
		{
			// End:0x36E
			if(o_ItemList[i].Category == 0)
			{
				titleStr = GetSystemString(13981);				
			}
			else
			{
				titleStr = MakeFullSystemMsg(GetSystemMessage(13625), string(o_ItemList[i].Category));
			}
			GetTextSizeDefault(titleStr, W, h);
			// End:0x3C6
			if(toolTipWidth < W)
			{
				toolTipWidth = W;
			}
			List_ListCtrl.InsertRecord(makeTitleListItem(titleStr));
			Count++;

			// End:0x46C [Loop If]
			for(N = 0; N < o_ItemList[i].Items.Length; N++)
			{
				List_ListCtrl.InsertRecord(makeRecord(o_ItemList[i].Items[N]));
				toolTipWidth = getMaxWidthInCreateResultItemData(toolTipWidth, o_ItemList[i].Items[N]);
				Count++;
			}
		}
	}
	// End:0x48A
	if(bUsePercentColumn)
	{
		LIST_PERCENT_COLUMN = 120;		
	}
	else
	{
		LIST_PERCENT_COLUMN = 0;
	}
	// End:0x4E6
	if(itemNameTextW > (toolTipWidth + LIST_PERCENT_COLUMN))
	{
		List_ListCtrl.SetColumnWidth(0, toolTipWidth);
		List_ListCtrl.SetColumnWidth(1, itemNameTextW - toolTipWidth);
		toolTipWidth = itemNameTextW;		
	}
	else
	{
		List_ListCtrl.SetColumnWidth(0, toolTipWidth);
		List_ListCtrl.SetColumnWidth(1, LIST_PERCENT_COLUMN);
		toolTipWidth = toolTipWidth + LIST_PERCENT_COLUMN;
	}
	Debug("LIST_PERCENT_COLUMN" @ string(LIST_PERCENT_COLUMN));
	toolTipWidth = toolTipWidth + 9;
	// End:0x5AB
	if(Count >= LIST_SHOWROW)
	{
		TooltipHeight = (LIST_HEIGHT * LIST_SHOWROW) + ITEMNAME_HEIGHT;
		Me.SetWindowSize(toolTipWidth, TooltipHeight);
		List_ListCtrl.SetWindowSize(toolTipWidth - 9, LIST_HEIGHT * LIST_SHOWROW);		
	}
	else
	{
		TooltipHeight = (LIST_HEIGHT * Count) + ITEMNAME_HEIGHT;
		Me.SetWindowSize(toolTipWidth, TooltipHeight);
		List_ListCtrl.SetWindowSize(toolTipWidth - 9, LIST_HEIGHT * Count);
	}
	// End:0x61C
	if(lconY - TooltipHeight < 0)
	{
		lconY = 0;
		OffsetX = 32;		
	}
	else
	{
		lconY = lconY - TooltipHeight;
	}
	// End:0x675
	if(lconX + OffsetX + toolTipWidth > clientW)
	{
		OffsetX = OffsetX - (((lconX + OffsetX) + toolTipWidth) - clientW);		
	}
	else
	{
		// End:0x699
		if(lconX + OffsetX < 0)
		{
			lconX = lconX + OffsetX;
		}
	}
	Me.MoveC(lconX + OffsetX, lconY);
	Me.ShowWindow();
}

function RichListCtrlRowData makeRecord(CreateResultItemData boxinfo)
{
	local RichListCtrlRowData RowData;
	local Color applyColor;

	RowData.cellDataList.Length = 2;
	applyColor = GTColor().White;
	// End:0x7F
	if(boxinfo.EnchantValue > 0)
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, ("+" $ string(boxinfo.EnchantValue)) $ " ", GTColor().Yellow, false, 0, 0, "GameDefault");
	}
	addRichListCtrlString(RowData.cellDataList[0].drawitems, boxinfo.ItemName, applyColor, false, 0, 0, "GameDefault");
	// End:0x10A
	if(boxinfo.AdditionalName != "")
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, " " $ boxinfo.AdditionalName, GetColor(255, 217, 105, 255), false, 0, 0, "GameDefault");
	}
	addRichListCtrlString(RowData.cellDataList[0].drawitems, " " $ MakeFullSystemMsg(GetSystemMessage(1983), string(boxinfo.Count)), GTColor().White, false, 0, 0, "GameDefault");
	// End:0x1C8
	if((float(boxinfo.Prob) == 0) || bUsePercentColumn == false)
	{
		bUsePercentColumn = false;
		addRichListCtrlString(RowData.cellDataList[1].drawitems, "", GTColor().White, false, 14, 0, "GameDefault");		
	}
	else
	{
		addRichListCtrlString(RowData.cellDataList[1].drawitems, getInstanceL2Util().CutFloatIntByString(boxinfo.Prob), GTColor().White, false, 14, 0, "GameDefault");
	}
	Debug("boxinfo.ItemName" @ boxinfo.ItemName);
	Debug("boxinfo.prob" @ boxinfo.Prob);
	Debug("bUsePercentColumn" @ string(bUsePercentColumn));
	return RowData;
}

function RichListCtrlRowData makeTitleListItem(string Str)
{
	local Color applyColor;
	local RichListCtrlRowData RowData;

	RowData.cellDataList.Length = 1;
	RowData.sOverlayTex = "L2UI_NewTex.ToolTip.TooltipwndListHeader";
	applyColor = GetColor(238, 170, 34, 255);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, Str, applyColor, false, 0, 0, "gameDefault10");
	RowData.OverlayTexU = 256;
	RowData.OverlayTexV = LIST_HEIGHT;
	return RowData;
}

function int getMaxWidthInCreateResultItemData(int maxTextW, CreateResultItemData ItemData)
{
	local string AdditionalName, enchantedStr, countStr, allStr;
	local int W, h;

	// End:0x2C
	if(ItemData.EnchantValue > 0)
	{
		enchantedStr = ("+" $ string(ItemData.EnchantValue)) $ " ";
	}
	// End:0x52
	if(ItemData.AdditionalName != "")
	{
		AdditionalName = " " $ ItemData.AdditionalName;
	}
	countStr = " " $ MakeFullSystemMsg(GetSystemMessage(1983), string(ItemData.Count));
	allStr = ((enchantedStr $ ItemData.ItemName) $ AdditionalName) $ countStr;
	GetTextSizeDefault(allStr, W, h);
	W = W + 30;
	// End:0xDD
	if(maxTextW < W)
	{
		maxTextW = W;
	}
	return maxTextW;
}

function int divCreateInfos(int maxTextW, array<ItemCreateUIData> ItemCreateUIDatas)
{
	local int i, N;

	fixedItemList.Length = 0;
	addItemList.Length = 0;
	randomItemList.Length = 0;

	// End:0x152 [Loop If]
	for(i = 0; i < ItemCreateUIDatas.Length; i++)
	{
		// End:0x148 [Loop If]
		for(N = 0; N < ItemCreateUIDatas[i].Items.Length; N++)
		{
			switch(ItemCreateUIDatas[i].Category)
			{
				// End:0x9E
				case 0:
					fixedItemList.Insert(fixedItemList.Length, 1);
					fixedItemList[fixedItemList.Length - 1] = ItemCreateUIDatas[i].Items[N];
					// End:0x117
					break;
				// End:0xD9
				case 1:
					addItemList.Insert(addItemList.Length, 1);
					addItemList[addItemList.Length - 1] = ItemCreateUIDatas[i].Items[N];
					// End:0x117
					break;
				// End:0x114
				case 2:
					randomItemList.Insert(randomItemList.Length, 1);
					randomItemList[randomItemList.Length - 1] = ItemCreateUIDatas[i].Items[N];
					// End:0x117
					break;
			}
			maxTextW = getMaxWidthInCreateResultItemData(maxTextW, ItemCreateUIDatas[i].Items[N]);
		}
	}
	fixedItemList.Sort(OnSortProbCompare);
	addItemList.Sort(OnSortProbCompare);
	randomItemList.Sort(OnSortProbCompare);
	return maxTextW;
}

delegate int OnSortProbCompare(CreateResultItemData A, CreateResultItemData B)
{
	// End:0x26
	if(float(A.Prob) > float(B.Prob))
	{
		return -1;		
	}
	else
	{
		return 0;
	}
}

function Color GetNameClassColor(int NameClass)
{
	local Color applyColor;

	switch(NameClass)
	{
		// End:0x22
		case 0:
			applyColor = GetColor(137, 137, 137, 255);
			// End:0xAB
			break;
		// End:0x3E
		case 2:
			applyColor = GetColor(255, 251, 4, 255);
			// End:0xAB
			break;
		// End:0x5A
		case 3:
			applyColor = GetColor(240, 68, 68, 255);
			// End:0xAB
			break;
		// End:0x76
		case 4:
			applyColor = GetColor(33, 164, 255, 255);
			// End:0xAB
			break;
		// End:0x91
		case 5:
			applyColor = GetColor(255, 0, 255, 255);
			// End:0xAB
			break;
		// End:0xFFFF
		default:
			applyColor = GetColor(255, 255, 255, 255);
			// End:0xAB
			break;
	}
	return applyColor;
}

defaultproperties
{
}
