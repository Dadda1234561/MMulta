class RestoreLostPropertyWnd extends UICommonAPI;

const Dialog_Retore = 11000111;
const MAX_ITEM_COUNT = 30;

var string m_WindowName;
var WindowHandle Me;
var WindowHandle RestoreLostPropertyDisableWnd;
var TextureHandle RestoreLostPropertyDisable_Tex;
var TextBoxHandle RestoreLostPropertyDisable_Txt;
var TextureHandle RestoreLostPropertyListBG_texture;
var WindowHandle AdenaRichCtrlWnd;
var TextureHandle ListCtrlDeco_texture;
var RichListCtrlHandle List_ListCtrl;
var TextureHandle RestoreLostPropertyDescBg_Tex;
var TextBoxHandle RestoreLostPropertyBtnName_Txt;
var ButtonHandle RestoreLostProperty_Btn;
var TextureHandle RestoreLostPropertyTabBg01_Tex;
var TextureHandle RestoreLostPropertyTabBg02_Tex;
var TextureHandle RestoreLostPropertyBg_Tex;
var WindowHandle Confirm_Wnd;
var WindowHandle ConfirmNeedItemDialogWnd;
var UIControlNeedItemDialog needItemDialogScript;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PENALTY_ITEM_RESTORE);
	RegisterEvent(EV_PenaltyItemListBegin);
	RegisterEvent(EV_PenaltyItemInfo);
	RegisterEvent(EV_PenaltyItemListEnd);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle("RestoreLostPropertyWnd");
	Confirm_Wnd = GetWindowHandle("RestoreLostPropertyWnd.Confirm_Wnd");
	RestoreLostPropertyDisableWnd = GetWindowHandle("RestoreLostPropertyWnd.RestoreLostPropertyDisableWnd");
	RestoreLostPropertyDisable_Tex = GetTextureHandle("RestoreLostPropertyWnd.RestoreLostPropertyDisableWnd.RestoreLostPropertyDisable_Tex");
	RestoreLostPropertyDisable_Txt = GetTextBoxHandle("RestoreLostPropertyWnd.RestoreLostPropertyDisableWnd.RestoreLostPropertyDisable_Txt");
	RestoreLostPropertyListBG_texture = GetTextureHandle("RestoreLostPropertyWnd.RestoreLostPropertyListBG_texture");
	AdenaRichCtrlWnd = GetWindowHandle("RestoreLostPropertyWnd.AdenaRichCtrlWnd");
	ListCtrlDeco_texture = GetTextureHandle("RestoreLostPropertyWnd.AdenaRichCtrlWnd.ListCtrlDeco_texture");
	List_ListCtrl = GetRichListCtrlHandle("RestoreLostPropertyWnd.AdenaRichCtrlWnd.List_ListCtrl");
	RestoreLostPropertyDescBg_Tex = GetTextureHandle("RestoreLostPropertyWnd.RestoreLostPropertyDescBg_Tex");
	RestoreLostPropertyBtnName_Txt = GetTextBoxHandle("RestoreLostPropertyWnd.RestoreLostPropertyBtnName_Txt");
	RestoreLostProperty_Btn = GetButtonHandle("RestoreLostPropertyWnd.RestoreLostProperty_Btn");
	RestoreLostPropertyTabBg01_Tex = GetTextureHandle("RestoreLostPropertyWnd.RestoreLostPropertyTabBg01_Tex");
	RestoreLostPropertyTabBg02_Tex = GetTextureHandle("RestoreLostPropertyWnd.RestoreLostPropertyTabBg02_Tex");
	RestoreLostPropertyBg_Tex = GetTextureHandle("RestoreLostPropertyWnd.RestoreLostPropertyBg_Tex");
	List_ListCtrl.SetSelectedSelTooltip(false);
	List_ListCtrl.SetAppearTooltipAtMouseX(true);
}

function Load()
{
	SetScript_UIControlNeedItemDialog();
}

function OnShow()
{
	setWindowTitleByString(GetSystemString(13517) $ " (" $ string(List_ListCtrl.GetRecordCount()) $ "/" $ string(MAX_ITEM_COUNT) $ ")");
	// End:0x72
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		Me.HideWindow();
		return;		
	}
	else
	{
		RestoreLostPropertyDisableWnd.HideWindow();
		hideAllDialog();
		API_C_EX_PENALTY_ITEM_LIST();
	}
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_PENALTY_ITEM_RESTORE):
			ParsePacket_S_EX_PENALTY_ITEM_RESTORE();
			// End:0xA0
			break;
		// End:0x41
		case EV_PenaltyItemListBegin:
			Debug("EV_PenaltyItemListBegin" @ param);
			List_ListCtrl.DeleteAllItem();
			// End:0xA0
			break;
		// End:0x57
		case EV_PenaltyItemInfo:
			Debug("EV_PenaltyItemInfo" @ param);
			Parse_PENALTY_ITEM_LIST(param);
			// End:0xA0
			break;
		// End:0x9D
		case EV_PenaltyItemListEnd:
			Debug("EV_PenaltyItemListEnd" @ param);
			setWindowTitleByString(GetSystemString(13517) $ " (" $ string(List_ListCtrl.GetRecordCount()) $ "/" $ string(MAX_ITEM_COUNT) $ ")");
			// End:0x10A
			break;
	}
}

function Parse_PENALTY_ITEM_LIST(string param)
{
	local ItemInfo Info;
	local L2UITime l2Time;
	local string timeStr;
	local int nDropDate, nItemDBID;
	local INT64 nRestoreCost, nRestoreLCoinCost;

	ParamToItemInfo(param, Info);
	Info.bDisabled = 0;
	ParseInt(param, "DropDate", nDropDate);
	ParseInt(param, "ItemDBID", nItemDBID);
	ParseINT64(param, "RestoreCost", nRestoreCost);
	ParseINT64(param, "RestoreLCoin", nRestoreLCoinCost);
	GetTimeStruct(nDropDate, l2Time);
	timeStr = string(l2Time.nYear) $ "-" $ getInstanceL2Util().makeZeroString(2, int64(l2Time.nMonth)) $ "-" $ getInstanceL2Util().makeZeroString(2, int64(l2Time.nDay)) $ " " $ getInstanceL2Util().makeZeroString(2, int64(l2Time.nHour)) $ ":" $ getInstanceL2Util().makeZeroString(2, int64(l2Time.nMin));
	List_ListCtrl.InsertRecord(MakeListRecord(Info, Info.Id.ClassID, nRestoreCost, nRestoreLCoinCost, nItemDBID, timeStr));
}

function ParsePacket_S_EX_PENALTY_ITEM_RESTORE()
{
	local UIPacket._S_EX_PENALTY_ITEM_RESTORE packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PENALTY_ITEM_RESTORE(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_PENALTY_ITEM_RESTORE : " @ string(packet.nResult));
	API_C_EX_PENALTY_ITEM_LIST();
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "RestoreLostProperty_Btn":
			OnRestoreLostProperty_BtnClick(1);
			break;
		case "RestoreLostProperty02_Btn":
			OnRestoreLostProperty_BtnClick(0);
			break;
	}
}

function OnRestoreLostProperty_BtnClick(int nIsAdena)
{
	if(List_ListCtrl.GetSelectedIndex() > -1)
	{
		tryDialog(Dialog_Retore, nIsAdena);		
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(326));
	}
}

function RichListCtrlRowData MakeListRecord(ItemInfo Info, int needItemClassID, INT64 needItemAmount, INT64 needItemLcoinAmount, int dbID, string dataString)
{
	local RichListCtrlRowData Record;
	local int nW, nH;

	ItemInfoToParam(Info, Record.szReserved);
	Record.cellDataList.Length = 2;
	Record.nReserved1 = int64(dbID);
	Record.nReserved2 = needItemAmount;
	Record.nReserved3 = needItemLcoinAmount;
	GetTextSizeDefault(GetItemNameAll(Info), nW, nH);
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, Info, 32, 32, 4);
	addRichListCtrlString(Record.cellDataList[0].drawitems, GetItemNameAll(Info), getInstanceL2Util().BrightWhite, false, 6, 0);
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin", 18, 18, - nW, nH + 5);
	addRichListCtrlString(Record.cellDataList[0].drawitems, MakeCostStringINT64(needItemLcoinAmount), getInstanceL2Util().BrightWhite, false, 4, 0);
	GetTextSizeDefault(MakeCostStringINT64(needItemLcoinAmount), nW, nH);
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_ct1.Icon.Icon_DF_Common_Adena", 18, 13, - nW + 70, 0);
	addRichListCtrlString(Record.cellDataList[0].drawitems, MakeCostStringINT64(needItemAmount), getInstanceL2Util().BrightWhite, false, 4, 0);
	addRichListCtrlString(Record.cellDataList[1].drawitems, dataString, getInstanceL2Util().BrightWhite, false, 0, 0);
	return Record;
}

function SetScript_UIControlNeedItemDialog()
{
	local string m_name;

	m_name = m_WindowName $ ".Confirm_Wnd.ConfirmNeedItemDialogWnd";
	ConfirmNeedItemDialogWnd = GetWindowHandle(m_name);
	ConfirmNeedItemDialogWnd.SetScript("UIControlNeedItemDialog");
	needItemDialogScript = UIControlNeedItemDialog(ConfirmNeedItemDialogWnd.GetScript());
	needItemDialogScript.SetWindow(m_name, m_WindowName $ ".Confirm_Wnd");
	needItemDialogScript.DelegateOnClickCancleButton = OnClickHideDialog;
	needItemDialogScript.DelegateOnClickOkButton = OnClickOkDialog;
}

function hideAllDialog()
{
	needItemDialogScript.Hide();
}

function OnClickHideDialog(optional int nDialogKey)
{
	hideAllDialog();
}

function OnClickOkDialog(optional int nDialogKey)
{
	hideAllDialog();
	Debug("optional int nDialogKey" @ string(nDialogKey));
	// End:0x9C
	if(nDialogKey == Dialog_Retore)
	{
		Debug("복구할 BID " @ string(needItemDialogScript.GetReservedInt()));
		// End:0x9C
		if(needItemDialogScript.GetReservedInt() > 0)
		{
			API_C_EX_PENALTY_ITEM_RESTORE(needItemDialogScript.GetReservedInt(), needItemDialogScript.GetReservedInt2());
		}
	}
}

function tryDialog(int nDialogKey, int nIsAdena)
{
	local string dialogStr;
	local ItemInfo ItemInfo;
	local RichListCtrlRowData Record;

	Debug("nDialogKey" @ string(nDialogKey));
	// End:0x13E
	if(nDialogKey == Dialog_Retore)
	{
		List_ListCtrl.GetSelectedRec(Record);
		needItemDialogScript.Show();
		ParamToItemInfo(Record.szReserved, ItemInfo);
		dialogStr = MakeFullSystemMsg(GetSystemMessage(13325), "\\" $ GetItemNameAll(ItemInfo) $ "\\");
		needItemDialogScript.setInit(dialogStr, nDialogKey,,, true);
		needItemDialogScript.SetReservedInt(int(Record.nReserved1));
		needItemDialogScript.SetReservedInt2(nIsAdena);
		needItemDialogScript.StartNeedItemList();
		// End:0x111
		if(nIsAdena == 1)
		{
			needItemDialogScript.AddNeedItem(57, Record.nReserved2);
		}
		else
		{
			needItemDialogScript.AddNeedItem(91663, Record.nReserved3);
		}
		needItemDialogScript.EndNeedItemList();
	}
}

function API_C_EX_PENALTY_ITEM_LIST(optional int nReserved)
{
	local array<byte> stream;
	local UIPacket._C_EX_PENALTY_ITEM_LIST packet;

	packet.nReserved = nReserved;
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PENALTY_ITEM_LIST, stream);
	Debug("----> Api Call : C_EX_PENALTY_ITEM_LIST " @ string(nReserved));
}

function API_C_EX_PENALTY_ITEM_RESTORE(int nItemDBID, optional int bByAdena)
{
	local array<byte> stream;
	local UIPacket._C_EX_PENALTY_ITEM_RESTORE packet;

	packet.nItemDBID = nItemDBID;
	packet.bByAdena = byte(bByAdena);
	// End:0x42
	if(! class'UIPacket'.static.Encode_C_EX_PENALTY_ITEM_RESTORE(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PENALTY_ITEM_RESTORE, stream);
	Debug("----> Api Call : C_EX_PENALTY_ITEM_RESTORE " @ string(nItemDBID) @ string(bByAdena));
}

function OnReceivedCloseUI()
{
	// End:0x1B
	if(ConfirmNeedItemDialogWnd.IsShowWindow())
	{
		hideAllDialog();		
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		GetWindowHandle(m_WindowName).HideWindow();
	}
}

defaultproperties
{
     m_WindowName="RestoreLostPropertyWnd"
}
