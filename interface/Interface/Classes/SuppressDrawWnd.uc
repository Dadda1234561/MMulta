class SuppressDrawWnd extends UICommonAPI;

struct resultItem
{
	var int ClassID;
	var int ItemNum;
	var int ColorIndex;
};

var WindowHandle Me;
var WindowHandle SuppressDrawResultWnd;
var RichListCtrlHandle SuppressDrawResulrtList_ListCtrl;
var RichListCtrlHandle SuppressDrawList_ListCtrl;
var TextureHandle ListBg_tex;
var RichListCtrlHandle NeedItemRichListCtrl;
var WindowHandle inputItemWnd;
var WindowHandle needItemWnd;
var ButtonHandle Draw_btn;
var TextBoxHandle SuppressDrawTitle_txt;
var TextureHandle SuppressDrawWndBg05_tex;
var TextureHandle SuppressDrawImg_tex;
var TextureHandle SuppressDrawWndBg01_tex;
var TextureHandle SuppressDrawWndBg02_tex;
var EffectViewportWndHandle EffectViewport02;
var string m_WindowName;
var UIControlNumberInput inputItemScript;
var UIControlNeedItemList needItemScript;
var SubjugationData currentSubjugationData;
var int AddGachaNeedPointListIndex;
var int lastSelectedListIndex;
var array<resultItem> ResultItemArray;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_SUBJUGATION_GACHA);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_SUBJUGATION_GACHA_UI);
}

function Initialize()
{
	Me = GetWindowHandle("SuppressDrawWnd");
	EffectViewport02 = GetEffectViewportWndHandle("SuppressDrawWnd.EffectViewport02");
	SuppressDrawResultWnd = GetWindowHandle("SuppressDrawWnd.SuppressDrawResultWnd");
	SuppressDrawResulrtList_ListCtrl = GetRichListCtrlHandle("SuppressDrawWnd.SuppressDrawResultWnd.SuppressDrawResulrtList_ListCtrl");
	SuppressDrawList_ListCtrl = GetRichListCtrlHandle("SuppressDrawWnd.SuppressDrawList_ListCtrl");
	ListBg_tex = GetTextureHandle("SuppressDrawWnd.ListBg_tex");
	Draw_btn = GetButtonHandle("SuppressDrawWnd.Draw_btn");
	SuppressDrawTitle_txt = GetTextBoxHandle("SuppressDrawWnd.SuppressDrawTitle_txt");
	SuppressDrawWndBg05_tex = GetTextureHandle("SuppressDrawWnd.SuppressDrawWndBg05_tex");
	SuppressDrawImg_tex = GetTextureHandle("SuppressDrawWnd.SuppressDrawImg_tex");
	SuppressDrawWndBg01_tex = GetTextureHandle("SuppressDrawWnd.SuppressDrawWndBg01_tex");
	SuppressDrawWndBg02_tex = GetTextureHandle("SuppressDrawWnd.SuppressDrawWndBg02_tex");
	inputItemWnd = GetWindowHandle("SuppressDrawWnd.inputItemWnd");
	needItemWnd = GetWindowHandle("SuppressDrawWnd.needItemWnd");
	NeedItemRichListCtrl = GetRichListCtrlHandle("SuppressDrawWnd.needItemWnd.NeedItemRichListCtrl");
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	InitNeedItem();
	InitInputControl();
	SetPopupScript();
	SuppressDrawList_ListCtrl.SetSelectedSelTooltip(false);
	SuppressDrawList_ListCtrl.SetAppearTooltipAtMouseX(true);
	SuppressDrawList_ListCtrl.SetSelectable(false);
	SuppressDrawList_ListCtrl.SetUseStripeBackTexture(false);
	SuppressDrawResulrtList_ListCtrl.SetSelectedSelTooltip(false);
	SuppressDrawResulrtList_ListCtrl.SetAppearTooltipAtMouseX(true);
	SuppressDrawResulrtList_ListCtrl.SetSelectable(false);
	SuppressDrawResulrtList_ListCtrl.SetUseStripeBackTexture(false);
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	GetPopupExpandScript().Hide();
	SuppressDrawResultWnd.HideWindow();
	showDisable(false);
	inputItemScript.SetCount(int(needItemScript.GetMaxNumCanBuy()));
}

event OnHide()
{
	EffectViewport02.SpawnEffect("");
	needItemScript.CleariObjects();	
}

function setScriptData(int subjugationID)
{
	local int i;
	local ItemInfo Info;

	currentSubjugationData = SuppressWnd(GetScript("SuppressWnd")).getSubjugationDataByID(subjugationID);
	setWindowTitleByString(GetSystemString(13630) $ " - " $ currentSubjugationData.Name);
	ResultItemArray.Length = 0;
	API_C_EX_SUBJUGATION_GACHA_UI(currentSubjugationData.Id);

	for(i = 0; i < (currentSubjugationData.ShowGachaMain.Length / 3); i++)
	{
		Info = GetItemInfoByClassID(currentSubjugationData.ShowGachaMain[i * 3]);
		Info.ItemNum = currentSubjugationData.ShowGachaMain[(i * 3) + 1];
		// End:0xF6
		if(Info.ItemNum > 1)
		{
			Info.bShowCount = true;
		}
		GetItemWindowHandle(m_WindowName $ ".valueItem0" $ string(i + 1) $ "_wnd.itemWindow").Clear();
		GetItemWindowHandle(m_WindowName $ ".valueItem0" $ string(i + 1) $ "_wnd.itemWindow").AddItem(Info);
		GetTextureHandle(m_WindowName $ ".valueItem0" $ string(i + 1) $ "_wnd.ItemSlot_tex").SetTexture("L2UI_EPIC.SuppressWnd.SuppressItem0" $ string(currentSubjugationData.ShowGachaMain[(i * 3) + 2]) $ "_Bg");
		GetTextBoxHandle(m_WindowName $ ".valueItem0" $ string(i + 1) $ "_wnd.ItemName_txt").SetText(Info.Name);
		GetTextBoxHandle(m_WindowName $ ".valueItem0" $ string(i + 1) $ "_wnd.ItemNum_txt").SetText("x" $ string(Info.ItemNum));
		textBoxShortStringWithTooltip(GetTextBoxHandle(m_WindowName $ ".valueItem0" $ string(i + 1) $ "_wnd.ItemName_txt"), true);
	}
	SuppressDrawList_ListCtrl.DeleteAllItem();

	for(i = 0; i < (currentSubjugationData.ShowGachaSub.Length / 3); i++)
	{
		addRichListReward(currentSubjugationData.ShowGachaSub[i * 3], currentSubjugationData.ShowGachaSub[(i * 3) + 1], currentSubjugationData.ShowGachaSub[(i * 3) + 2]);
	}
	needItemScript.StartNeedItemList(2);
	needItemScript.AddNeedItemClassID(currentSubjugationData.GachaCostItem, currentSubjugationData.GachaCostNum);
	AddGachaNeedPointListIndex = needItemScript.AddNeedPoint(GetSystemString(13634), "L2UI_EPIC.SuppressWnd.etc_Supprespoint_i00", 1, 0);
}

function addRichListReward(int nClassID, int nAmount, int ColorIndex)
{
	local RichListCtrlRowData RowData;
	local ItemInfo Info;

	RowData.cellDataList.Length = 1;
	Info = GetItemInfoByClassID(nClassID);
	// End:0x3E
	if(Info.ItemNum > 1)
	{
		Info.bShowCount = true;
	}
	ItemInfoToParam(Info, RowData.szReserved);
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, Info, 42, 42, 5, 8);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetItemNameAll(Info), GetColor(254, 215, 160, 255), false, 4, 5);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, "x" $ MakeCostString(string(nAmount)), GTColor().White, true, 52, 0);
	// End:0x139
	if(ColorIndex == 4)
	{
		RowData.sOverlayTex = "L2UI_CT1.EmptyBtn";		
	}
	else
	{
		RowData.sOverlayTex = "L2UI_EPIC.SuppressWnd.SuppressList0" $ string(ColorIndex) $ "_Bg";
	}
	RowData.OverlayTexU = 420;
	RowData.OverlayTexV = 60;
	SuppressDrawList_ListCtrl.InsertRecord(RowData);
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Draw_btn":
			ShowPopup();
			// End:0x44
			break;
		case "ok_btn":
			showDisable(false);
			SuppressDrawResultWnd.HideWindow();
			// End:0x44
			break;
		case "Main_BTN":
			toggleWindow("SuppressWnd", true, true);
			// End:0x69
			break;
	}
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_SUBJUGATION_GACHA):
			ParsePacket_S_EX_SUBJUGATION_GACHA();
			// End:0x4A
			break;
		// End:0x47
		case EV_PacketID(class'UIPacket'.const.S_EX_SUBJUGATION_GACHA_UI):
			ParsePacket_S_EX_SUBJUGATION_GACHA_UI();
			// End:0x4A
			break;
	}
}

function API_C_EX_SUBJUGATION_GACHA_UI(int nID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SUBJUGATION_GACHA_UI packet;

	packet.nID = nID;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_SUBJUGATION_GACHA_UI(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SUBJUGATION_GACHA_UI, stream);
	Debug("--> C_EX_SUBJUGATION_GACHA_UI " @ string(nID));
}

function ParsePacket_S_EX_SUBJUGATION_GACHA_UI()
{
	local UIPacket._S_EX_SUBJUGATION_GACHA_UI packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_SUBJUGATION_GACHA_UI(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_SUBJUGATION_GACHA_UI :  " @ string(packet.nGachaPoint));
	needItemScript.ModifyCurrentAmount(AddGachaNeedPointListIndex, packet.nGachaPoint);
	Debug("needItemScript.GetMaxNumCanBuy()" @ string(needItemScript.GetMaxNumCanBuy()));
	// End:0x144
	if(needItemScript.GetMaxNumCanBuy() > 0)
	{
		// End:0xFB
		if(inputItemScript.GetCount() == 0)
		{
			inputItemScript.SetCount(9999);			
		}
		else
		{
			// End:0x141
			if(inputItemScript.GetCount() > needItemScript.GetMaxNumCanBuy())
			{
				inputItemScript.SetCount(int(needItemScript.GetMaxNumCanBuy()));
			}
		}		
	}
	else
	{
		inputItemScript.SetCount(int(needItemScript.GetMaxNumCanBuy()));
	}
}

function API_C_EX_SUBJUGATION_GACHA(int nID, int nCount)
{
	local array<byte> stream;
	local UIPacket._C_EX_SUBJUGATION_GACHA packet;

	packet.nID = nID;
	packet.nCount = nCount;
	// End:0x40
	if(! class'UIPacket'.static.Encode_C_EX_SUBJUGATION_GACHA(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SUBJUGATION_GACHA, stream);
	Debug("--> C_EX_SUBJUGATION_GACHA " @ string(nID) @ string(nCount));
}

function ParsePacket_S_EX_SUBJUGATION_GACHA()
{
	local UIPacket._S_EX_SUBJUGATION_GACHA packet;
	local int i;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_SUBJUGATION_GACHA(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_SUBJUGATION_GACHA :  ");
	API_C_EX_SUBJUGATION_GACHA_UI(currentSubjugationData.Id);
	showDisable(true);
	SuppressDrawResultWnd.ShowWindow();
	SuppressDrawResultWnd.SetFocus();
	playResultEffectViewPort("LineageEffect2.ui_upgrade_succ");
	PlaySound("ItemSound3.enchant_success");
	SuppressDrawResulrtList_ListCtrl.DeleteAllItem();
	ResultItemArray.Length = 0;

	for(i = 0; i < packet.vItems.Length; i++)
	{
		Debug("-nClassID" @ string(packet.vItems[i].nClassID));
		Debug("-nAmount" @ string(packet.vItems[i].nAmount));
		Debug("-colorIndex" @ string(getResultColorIndex(packet.vItems[i].nClassID, packet.vItems[i].nAmount)));
		ResultItemArray.Length = ResultItemArray.Length + 1;
		ResultItemArray[ResultItemArray.Length - 1].ClassID = packet.vItems[i].nClassID;
		ResultItemArray[ResultItemArray.Length - 1].ItemNum = packet.vItems[i].nAmount;
		ResultItemArray[ResultItemArray.Length - 1].ColorIndex = getResultColorIndex(packet.vItems[i].nClassID, packet.vItems[i].nAmount);
	}
	ResultItemArray.Sort(SortResultItemDelegate);

	for(i = 0; i < ResultItemArray.Length; i++)
	{
		addRichListResult(ResultItemArray[i].ClassID, ResultItemArray[i].ItemNum, ResultItemArray[i].ColorIndex);
	}
}

delegate int SortResultItemDelegate(resultItem a1, resultItem a2)
{
	// End:0x1F
	if(a1.ColorIndex > a2.ColorIndex)
	{
		return -1;
	}
	return 0;
}

function addRichListResult(int nClassID, int nAmount, int ColorIndex)
{
	local RichListCtrlRowData RowData;
	local ItemInfo Info;
	local string ItemName;

	RowData.cellDataList.Length = 1;
	Info = GetItemInfoByClassID(nClassID);
	// End:0x3E
	if(Info.ItemNum > 1)
	{
		Info.bShowCount = true;
	}
	ItemInfoToParam(Info, RowData.szReserved);
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, Info, 32, 32, 5, 14);
	ItemName = GetItemNameAll(Info);
	class'L2Util'.static.GetEllipsisString(ItemName, 233);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, ItemName, GetColor(254, 215, 160, 255), false, 4, 4);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, "x" $ MakeCostString(string(nAmount)), GTColor().White, true, 40, 0);
	// End:0x136
	if(ColorIndex == 4)
	{
		RowData.sOverlayTex = "L2UI_CT1.EmptyBtn";		
	}
	else
	{
		RowData.sOverlayTex = "L2UI_EPIC.SuppressWnd.SuppressItemResult0" $ string(ColorIndex) $ "_Bg";
	}
	Debug("RowData.sOverlayTex: " @ RowData.sOverlayTex);
	RowData.OverlayTexU = 310;
	RowData.OverlayTexV = 61;
	SuppressDrawResulrtList_ListCtrl.InsertRecord(RowData);
}

function playResultEffectViewPort(string effectPath)
{
	local Vector offset;

	// End:0x89
	if(effectPath == "LineageEffect2.ui_upgrade_succ")
	{
		offset.X = 10.0f;
		offset.Y = -5.0f;
		EffectViewport02.SetScale(6.0f);
		EffectViewport02.SetCameraDistance(1300.0f);
		EffectViewport02.SetOffset(offset);		
	}
	else if(effectPath == "LineageEffect.d_firework_a")
	{
		offset.X = 10.0f;
		offset.Y = -5.0f;
		EffectViewport02.SetScale(6.0f);
		EffectViewport02.SetCameraDistance(1300.0f);
		EffectViewport02.SetOffset(offset);
	}
	EffectViewport02.SetFocus();
	EffectViewport02.SpawnEffect(effectPath);
}

function int getResultColorIndex(int ClassID, int ItemNum)
{
	local int i;

	for(i = 0; i < (currentSubjugationData.ShowGachaMain.Length / 3); i++)
	{
		// End:0x57
		if(ClassID == currentSubjugationData.ShowGachaMain[i * 3])
		{
			return currentSubjugationData.ShowGachaMain[(i * 3) + 2];
		}
	}

	for(i = 0; i < (currentSubjugationData.ShowGachaSub.Length / 3); i++)
	{
		// End:0xB8
		if(ClassID == currentSubjugationData.ShowGachaSub[i * 3])
		{
			return currentSubjugationData.ShowGachaSub[(i * 3) + 2];
		}
	}
	return 4;
}

function SetPopupScript()
{
	local WindowHandle popExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle DisableWnd;

	popExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	popupExpandScript = class'UIControlDialogAssets'.static.InitScript(popExpandWnd);
	DisableWnd = GetWindowHandle(m_WindowName $ ".disable_tex");
	popupExpandScript.SetDisableWindow(DisableWnd);
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop(m_WindowName $ ".disable_tex", false);
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function ShowPopup()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = GetPopupExpandScript();
	popupExpandScript.SetDialogDesc(GetSystemString(13631));
	popupExpandScript.Show();
	popupExpandScript.OKButton.EnableWindow();
	popupExpandScript.DelegateOnClickBuy = OnDialogOK;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	showDisable(true);
}

function OnDialogOK()
{
	API_C_EX_SUBJUGATION_GACHA(currentSubjugationData.Id, int(inputItemScript.GetCount()));
	GetPopupExpandScript().Hide();
	showDisable(false);
}

function OnClickCancelDialog()
{
	GetPopupExpandScript().Hide();
	showDisable(false);
}

function InitNeedItem()
{
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemScript.SetRichListControler(NeedItemRichListCtrl);
}

function InitInputControl()
{
	inputItemWnd.SetScript("UIControlNumberInput");
	inputItemScript = UIControlNumberInput(inputItemWnd.GetScript());
	inputItemScript.Init(m_WindowName $ ".inputItemWnd");
	inputItemScript.DelegateGetCountCanBuy = MaxNumCanBuy;
	inputItemScript.DelegateOnItemCountEdited = OnItemCountChanged;
	inputItemScript.DelegateESCKey = OnESCKey;
	inputItemScript.Buy_Btn = GetButtonHandle(m_WindowName $ ".Draw_btn");
}

function INT64 MaxNumCanBuy()
{
	return Min(int(needItemScript.GetMaxNumCanBuy()), currentSubjugationData.MaxUsePoint);
}

function OnItemCountChanged(INT64 ItemCount)
{
	ItemCount = MAX64(1, ItemCount);
	needItemScript.SetBuyNum(ItemCount);
}

function showDisable(bool bShow)
{
	// End:0x69
	if(bShow)
	{
		GetWindowHandle(m_WindowName $ ".disable_tex").ShowWindow();
		GetEditBoxHandle(m_WindowName $ ".inputItemWnd.ItemCount_EditBox").HideWindow();		
	}
	else
	{
		GetWindowHandle(m_WindowName $ ".disable_tex").HideWindow();
		GetEditBoxHandle(m_WindowName $ ".inputItemWnd.ItemCount_EditBox").ShowWindow();
	}
}

function OnESCKey()
{
	SuppressDrawList_ListCtrl.SetFocus();
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	// End:0x53
	if(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset").IsShowWindow())
	{
		showDisable(false);
		GetPopupExpandScript().Hide();		
	}
	else
	{
		// End:0x7E
		if(SuppressDrawResultWnd.IsShowWindow())
		{
			showDisable(false);
			SuppressDrawResultWnd.HideWindow();			
		}
		else
		{
			GetWindowHandle(m_WindowName).HideWindow();
		}
	}
}

defaultproperties
{
     m_WindowName="SuppressDrawWnd"
}
