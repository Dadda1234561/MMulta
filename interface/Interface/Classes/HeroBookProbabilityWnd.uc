class HeroBookProbabilityWnd extends UICommonAPI;

var WindowHandle Me;
var RichListCtrlHandle StatBonus_ListCtrl;
var int chargeCurrent;
var int nCurrentLevel;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HERO_BOOK_INFO);	
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();	
}

function Initialize()
{
	Me = GetWindowHandle("HeroBookProbabilityWnd");
	StatBonus_ListCtrl = GetRichListCtrlHandle("HeroBookProbabilityWnd.StatBonus_ListCtrl");
	StatBonus_ListCtrl.SetSelectedSelTooltip(false);
	StatBonus_ListCtrl.SetAppearTooltipAtMouseX(true);
	StatBonus_ListCtrl.SetUseStripeBackTexture(false);	
}

function OnShow()
{
	Refresh();	
}

function Refresh()
{
	local int i;
	local array<HeroBookListData> listDatas;

	class'HeroBookAPI'.static.GetAllHeroBookListData(listDatas);
	StatBonus_ListCtrl.DeleteAllItem();

	// End:0x55 [Loop If]
	for(i = 0; i < listDatas.Length; i++)
	{
		AddList(listDatas[i]);
	}
	StatBonus_ListCtrl.SetStartRow(nCurrentLevel - 1);	
}

function AddList(HeroBookListData Data)
{
	local RichListCtrlRowData RowData;
	local SkillInfo a_SkillInfo;
	local ItemInfo a_itemInfo;
	local int addX;

	RowData.cellDataList.Length = 3;
	// End:0x3C
	if(Data.BookSkillLevel > 0 && Data.BookSkillLevel < 10)
	{
		addX = 6;		
	}
	else if(Data.BookSkillLevel > 9 && Data.BookSkillLevel < 100)
	{
		addX = 3;
	}
	addRichListCtrlString(RowData.cellDataList[0].drawitems, string(Data.Id), GTColor().White, false, addX, 3);
	GetSkillInfo(Data.BookSkillID, Data.BookSkillLevel, 0, a_SkillInfo);
	AddRichListCtrlSkillBySkillInfo(RowData.cellDataList[1].drawitems, a_SkillInfo, 32, 32, 5, 0);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, a_SkillInfo.SkillName, GTColor().White, false, 10, 10);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, GetSystemString(88) $ string(a_SkillInfo.SkillLevel), GetColor(176, 155, 121, 255), false, 5, 0);
	// End:0x1AD
	if(Data.SuccessItemID <= 0 && Data.SuccessSkillID <= 0)
	{
		addRichListCtrlString(RowData.cellDataList[2].drawitems, "-", GTColor().Gray, false, 35, 2);		
	}
	else
	{
		// End:0x211
		if(Data.SuccessItemID > 0)
		{
			a_itemInfo = GetItemInfoByClassID(Data.SuccessItemID);
			a_itemInfo.ItemNum = Data.SuccessItemCount;
			AddRichListCtrlItem(RowData.cellDataList[2].drawitems, a_itemInfo, 32, 32, 5, 0);			
		}
		else
		{
			addRichListCtrlTexture(RowData.cellDataList[2].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 32, 32, 5, 0);
		}
		// End:0x2B6
		if(Data.SuccessSkillID > 0)
		{
			GetSkillInfo(Data.SuccessSkillID, Data.SuccessSkillLevel, 0, a_SkillInfo);
			AddRichListCtrlSkillBySkillInfo(RowData.cellDataList[2].drawitems, a_SkillInfo, 32, 32, 5, 0);			
		}
		else
		{
			addRichListCtrlTexture(RowData.cellDataList[2].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 32, 32, 5, 0);
		}
	}
	// End:0x369
	if(nCurrentLevel == Data.BookSkillLevel)
	{
		RowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";
		RowData.OverlayTexU = 734;
		RowData.OverlayTexV = 45;
	}
	StatBonus_ListCtrl.InsertRecord(RowData);
	// End:0x3A9
	if(nCurrentLevel == Data.BookSkillLevel)
	{
		StatBonus_ListCtrl.SetSelectedIndex(nCurrentLevel - 1, false);
	}	
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_HERO_BOOK_INFO):
			ParsePacket_S_EX_HERO_BOOK_INFO();
			// End:0x2A
			break;
	}	
}

function ParsePacket_S_EX_HERO_BOOK_INFO()
{
	local UIPacket._S_EX_HERO_BOOK_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_HERO_BOOK_INFO(packet))
	{
		return;
	}
	chargeCurrent = packet.nPoint;
	nCurrentLevel = packet.nLevel;
	// End:0x53
	if(Me.IsShowWindow())
	{
		Refresh();
	}	
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x21
		case "Close_Button":
			OnClose_ButtonClick();
			// End:0x24
			break;
	}	
}

function OnClose_ButtonClick()
{
	closeUI();	
}

function OnReceivedCloseUI()
{
	closeUI();	
}

defaultproperties
{
}
