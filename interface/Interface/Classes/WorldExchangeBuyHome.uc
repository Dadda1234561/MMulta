class WorldExchangeBuyHome extends UICommonAPI;

const refreshTime = 5000;

var private bool bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST;
var private bool bRQ_COININFO;
var private UIControlTextInput uicontrolTextInputScr;
var private UIControlTextInput UIControlTextInputResultScr;
var private string lastFindString;
var private array<int> ItemList;
var private WindowHandle SearchResult_Wnd;
var private RichListCtrlHandle SearchResult_RichList;
var private bool isSearchResultWndShow;
var private L2UITimerObject timerObj;

static function WorldExchangeBuyHome Inst()
{
	return WorldExchangeBuyHome(GetScript("WorldExchangeBuyWnd.Home_Wnd"));	
}

private function InitSearchResult_Wnd()
{
	SearchResult_Wnd = GetWindowHandle("WorldExchangeBuyWnd.SearchResult_Wnd");
	SearchResult_RichList = GetRichListCtrlHandle("WorldExchangeBuyWnd.SearchResult_Wnd.SearchResult_RichList");	
}

private function InitTimer()
{
	timerObj = class'L2UITimer'.static.Inst()._AddNewTimerObject(5000);
	timerObj._DelegateOnEnd= CoolTimeEnd;	
}

private function CoolTimeEnd()
{
	Debug("쿨타입 종료 ");
	bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST = false;	
}

private function InitFindItem()
{
	Debug("init 합니다" @ m_hOwnerWnd.m_WindowNameWithFullPath);
	uicontrolTextInputScr = class'UIControlTextInput'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeFind_Wnd.TextInput"));
	uicontrolTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolTextInputScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	uicontrolTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	uicontrolTextInputScr.DelegateOnClear = DelegateOnClear;
	uicontrolTextInputScr.SetDefaultString(GetSystemString(2507));
	uicontrolTextInputScr.SetEdtiable(true);
	UIControlTextInputResultScr = class'UIControlTextInput'.static.InitScript(GetWindowHandle("WorldExchangeBuyWnd.SearchResult_Wnd.SearchResultFind_Wnd.TextInput"));
	UIControlTextInputResultScr.DelegateESCKey = _SwapToFind;
	UIControlTextInputResultScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	UIControlTextInputResultScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	UIControlTextInputResultScr.DelegateOnClear = DelegateOnClear;
	UIControlTextInputResultScr.SetDefaultString(GetSystemString(2507));
	UIControlTextInputResultScr.SetEdtiable(true);	
}

private function RichListCtrlHandle GetRichList()
{
	return GetRichListCtrlHandle("WorldExchangeBuyWnd.SearchResult_Wnd.SearchResult_RichList");	
}

private function DelegateESCKey()
{
	class'WorldExchangeBuyWnd'.static.Inst().DelegateESCKey();	
}

private function DelegateOnClear()
{
	_HandleClear();	
}

function _HandleClear()
{
	local array<int> _itemList;

	lastFindString = "";
	ItemList.Length = 0;
	ClearList();
	uicontrolTextInputScr.Clear();
	class'WorldExchangeBuyWnd'.static.Inst()._SetFindString("", _itemList);	
}

function DelegateOnChangeEdited(string Text)
{
	// End:0x46
	if(Text == "")
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeFind_Wnd.BtnFind").DisableWindow();		
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeFind_Wnd.BtnFind").EnableWindow();
	}
	Debug(("DelegateOnChangeEdited" @ lastFindString) @ Text);
	// End:0xF6
	if(lastFindString == Text)
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SearchResult_Wnd.BtnFind").DisableWindow();		
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SearchResult_Wnd.BtnFind").EnableWindow();
	}	
}

function DelegateOnCompleteEditBox(string Text)
{
	local array<int> _itemList;

	// End:0x54
	if(! CheckFindString(Text, _itemList))
	{
		class'L2Util'.static.Inst().showGfxScreenMessage("&#34;" $ Text $ "&#34;" $ GetSystemMessage(4356));
		return;
	}
	// End:0x87
	if(_itemList.Length > 300)
	{
		class'L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13767));
		return;
	}
	uicontrolTextInputScr.SetString(Text);
	UIControlTextInputResultScr.SetString(Text);
	class'WorldExchangeBuyWnd'.static.Inst()._SetFindString(Text, _itemList);
	lastFindString = Text;
	ItemList = _itemList;
	RQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST();	
}

function Initialize()
{
	InitSearchResult_Wnd();
	InitFindItem();
	RegisterEvents();
	InitTimer();	
}

function OnLoad()
{
	Debug(" 셋 스?트 이후에 실행 되는가 여부 확인");
	Initialize();
	return;
}

private function RegisterEvents()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_TOTAL_LIST));	
}

private function bool MakeRowData(UIPacket._WorldExchangeTotalListData _itemData, out RichListCtrlRowData outRowData)
{
	local RichListCtrlRowData RowData;
	local ItemInfo iInfo;
	local string strcom, itemParam;
	local float unitPrice;
	local INT64 perPrice;

	// End:0x12
	if(_itemData.nItemClassID < 1)
	{
		return false;
	}
	// End:0x3D
	if(! class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(_itemData.nItemClassID), iInfo))
	{
		return false;
	}
	RowData.cellDataList.Length = 4;
	RowData.nReserved1 = _itemData.nItemClassID;
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 0, 1);
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), GTColor().White, false, 4, 9);
	Debug("_itemData.nMinPricePerPiece - " @ string(float(_itemData.nMinPricePerPiece * 100)));
	perPrice = _itemData.nMinPricePerPiece / 100;
	unitPrice = float(_itemData.nMinPricePerPiece) / 100;
	strcom = MakeCostStringINT64(perPrice);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, "." $ GetDecimalNnmStr(unitPrice), GetColor(123, 123, 123, 255), false, 0, 1, "hs7");
	addRichListCtrlString(RowData.cellDataList[1].drawitems, strcom, GetNumericColor(strcom), false, 0, -2);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, string(_itemData.nAmount), GTColor().White, false);
	addRichListCtrlButton(RowData.cellDataList[3].drawitems, "gotoBtn", 0, 0, "L2UI.WorldExchangeWnd.FindButton", "L2UI.WorldExchangeWnd.FindButton_Down", "L2UI.WorldExchangeWnd.FindButton_Over", 32, 32, 32, 32);
	ItemInfoToParam(iInfo, itemParam);
	RowData.szReserved = itemParam;
	outRowData = RowData;
	return true;	
}

event OnShow()
{
	Debug("열렸다");
	m_hOwnerWnd.SetFocus();	
}

event OnHide()
{
	Debug("닫혔다 !!");	
}

event OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_TOTAL_LIST):
			RT_S_EX_WORLD_EXCHANGE_TOTAL_LIST();
			// End:0x2A
			break;
	}	
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		// End:0x1C
		case "BtnFind":
			_HandleClickBtnFind();
			// End:0x1F
			break;
	}	
}

function _HandleClickBtnFind()
{
	DelegateOnCompleteEditBox(uicontrolTextInputScr.GetString());	
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
	SearchResult_Wnd.HideWindow();	
}

function _Show()
{
	// End:0x2A
	if(isSearchResultWndShow)
	{
		SearchResult_Wnd.ShowWindow();
		SearchResult_Wnd.SetFocus();		
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
		m_hOwnerWnd.SetFocus();
	}
	RQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST();	
}

function _SwapToResult()
{
	isSearchResultWndShow = true;
	m_hOwnerWnd.HideWindow();
	SearchResult_Wnd.ShowWindow();
	SearchResult_Wnd.SetFocus();
	UIControlTextInputResultScr.SetString(uicontrolTextInputScr.GetString());	
}

function _SwapToFind()
{
	isSearchResultWndShow = false;
	SearchResult_Wnd.HideWindow();
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	uicontrolTextInputScr.SetString(UIControlTextInputResultScr.GetString());	
}

function _GotoFind()
{
	local RichListCtrlRowData RowData;

	// End:0x17
	if(SearchResult_RichList.GetSelectedIndex() < 0)
	{
		return;
	}
	SearchResult_RichList.GetSelectedRec(RowData);
	class'WorldExchangeBuyWnd'.static.Inst()._SetCategoryIndexByClassID(int(RowData.nReserved1));	
}

function _RQ_COININFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_TOTAL_LIST packet;

	Debug("월드 거래소 아이템 리스트 요청 RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST" @ string(bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST));
	// End:0x5C
	if(bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST)
	{
		return;
	}
	bRQ_COININFO = true;
	bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST = true;
	timerObj._Reset();
	SetDisablbRefresh();
	packet.vItemIDList[0] = 57;
	// End:0xB0
	if(! class'UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_TOTAL_LIST(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLD_EXCHANGE_TOTAL_LIST, stream);	
}

function _RQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST_WithInfos(array<int> iInfos)
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_TOTAL_LIST packet;

	Debug("월드 거래소 아이템 리스트 요청 _RQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST_WithInfos" @ string(bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST));
	// End:0x68
	if(bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST)
	{
		return;
	}
	class'WorldExchangeBuyWnd'.static.Inst()._DotTextureAllHide();
	// End:0x8F
	if(iInfos.Length == 0)
	{
		return;
	}
	bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST = true;
	timerObj._Reset();
	SetDisablbRefresh();
	packet.vItemIDList = iInfos;
	// End:0xDC
	if(! class'UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_TOTAL_LIST(stream, packet))
	{
		return;
	}
	Debug("월드 거래소 아이템 리스트 요청 C_EX_WORLD_EXCHANGE_TOTAL_LIST End");
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLD_EXCHANGE_TOTAL_LIST, stream);	
}

function RQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST()
{
	_RQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST_WithInfos(ItemList);	
}

private function RT_S_EX_WORLD_EXCHANGE_TOTAL_LIST()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_TOTAL_LIST packet;

	bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST = false;
	Debug("RT_S_EX_WORLD_EXCHANGE_TOTAL_LIST sep0 ");
	// End:0x52
	if(! class'UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_TOTAL_LIST(packet))
	{
		return;
	}
	Debug("RT_S_EX_WORLD_EXCHANGE_TOTAL_LIST OK");
	Handle_S_EX_WORLD_EXCHANGE_TOTAL_LIST(packet);	
}

private function SetAdenaInfo(INT64 nAmount, INT64 nPrice, INT64 nMinPricePerPiece)
{
	local ItemInfo iInfo;
	local float perPiece;

	iInfo = GetItemInfoByClassID(57);
	perPiece = float(nMinPricePerPiece) / float(100);
	Debug("SetAdenaInfo" @ string(nPrice) @ string(nMinPricePerPiece));
	iInfo.ItemNum = nAmount;
	class'WorldExchangeBuyWnd'.static.Inst()._MakeAdenaitemInfo(iInfo);
	GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.ItemWnd_Wnd").Clear();
	GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.ItemWnd_Wnd").AddItem(iInfo);
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Text00_Txt").SetText(MakeCostStringINT64(iInfo.ItemNum));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Text00_Txt").SetTextColor(GetNumericColor(string(iInfo.ItemNum)));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Text01_Txt").SetText(MakeCostStringINT64(nPrice) @ class'WorldExchangeRegiWnd'.static.Inst().strLCoinName);
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Text00_Txt").SetTextColor(GetNumericColor(string(nPrice)));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Text02_Txt").SetText(ConvertFloatToString(perPiece, 2, false) @ class'WorldExchangeRegiWnd'.static.Inst().strLCoinName);
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Text02_Txt").SetTextColor(GetNumericColor(string(int(perPiece))));
	Debug("아데나다");	
}

function ClearList()
{
	SearchResult_RichList.DeleteAllItem();
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SearchResult_Wnd.FindDisable_Wnd").ShowWindow();
	class'WorldExchangeBuyWnd'.static.Inst()._DotTextureAllHide();	
}

private function Handle_S_EX_WORLD_EXCHANGE_TOTAL_LIST(UIPacket._S_EX_WORLD_EXCHANGE_TOTAL_LIST packet)
{
	local int i;
	local RichListCtrlRowData RowData;

	Debug("Handle_S_EX_WORLD_EXCHANGE_TOTAL_LIST" @ string(class'WorldExchangeBuyWnd'.static.Inst()._GetCurrentMainType()));
	// End:0x97
	if(bRQ_COININFO)
	{
		bRQ_COININFO = false;
		SetAdenaInfo(packet.vItemIDList[0].nAmount, packet.vItemIDList[0].nPrice, packet.vItemIDList[0].nMinPricePerPiece);		
	}
	else
	{
		// End:0x2A9
		if(class'WorldExchangeBuyWnd'.static.Inst()._GetCurrentMainType() == class'WorldExchangeBuyWnd'.static.Inst().ItemMainType.home)
		{
			ClearList();
			class'WorldExchangeBuyWnd'.static.Inst()._DotTextureAllHide();
			Debug("홈이고" @ string(packet.vItemIDList[i].nItemClassID) @ string(packet.vItemIDList.Length));

			// End:0x22F [Loop If]
			for(i = 0; i < packet.vItemIDList.Length; i++)
			{
				// End:0x1C5
				if(packet.vItemIDList[i].nItemClassID == 57)
				{
					SetAdenaInfo(packet.vItemIDList[i].nAmount, packet.vItemIDList[i].nPrice, packet.vItemIDList[i].nMinPricePerPiece);
					class'L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13786));
					// [Explicit Continue]
					continue;
				}
				// End:0x225
				if(MakeRowData(packet.vItemIDList[i], RowData))
				{
					SearchResult_RichList.InsertRecord(RowData);
					class'WorldExchangeBuyWnd'.static.Inst()._DotAdd(packet.vItemIDList[i].nItemClassID);
				}
			}
			// End:0x2A0
			if(SearchResult_RichList.GetRecordCount() > 0)
			{
				GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SearchResult_Wnd.FindDisable_Wnd").HideWindow();
				class'WorldExchangeBuyWnd'.static.Inst()._DotSubCurrentSet();
			}
			_SwapToResult();			
		}
		else
		{
			class'WorldExchangeBuyWnd'.static.Inst()._DotTextureAllHide();

			// End:0x3AF [Loop If]
			for(i = 0; i < packet.vItemIDList.Length; i++)
			{
				// End:0x342
				if(packet.vItemIDList[i].nItemClassID == 57)
				{
					SetAdenaInfo(packet.vItemIDList[i].nAmount, packet.vItemIDList[i].nPrice, packet.vItemIDList[i].nMinPricePerPiece);
					// [Explicit Continue]
					continue;
				}
				// End:0x3A5
				if(class'WorldExchangeBuyWnd'.static.Inst()._GetCurrentMainType() != class'WorldExchangeBuyWnd'.static.Inst().ItemMainType.Adena)
				{
					class'WorldExchangeBuyWnd'.static.Inst()._DotAdd(packet.vItemIDList[i].nItemClassID);
				}
			}
			class'WorldExchangeBuyWnd'.static.Inst()._DotSubCurrentSet();
			return;
		}
	}	
}

private function SetDisablbRefresh();

function API_GetStringMatchingItemList(string a_str, string a_delim, EStringMatchingItemFilter a_filter, bool a_bAscend, out array<int> o_ItemList)
{
	class'UIDATA_ITEM'.static.GetStringMatchingItemList(a_str, a_delim, a_filter, a_bAscend, o_ItemList);	
}

function int API_GetServerPrivateStoreSearchItemSubType(int ClassID)
{
	return GetServerPrivateStoreSearchItemSubType(ClassID);	
}

private function bool CheckFindString(string Text, out array<int> _itemList)
{
	// End:0x0E
	if(Text == "")
	{
		return true;
	}
	API_GetStringMatchingItemList(Text, " ", EStringMatchingItemFilter.SMIF_WorldExchangeItem, true, _itemList);
	return _itemList.Length > 0;	
}

function string GetDecimalNnmStr(float Num)
{
	local array<string> nums;

	Split(string(Num), ".", nums);
	return nums[1];	
}

function string GetInt64NumStr(float Num)
{
	local array<string> nums;

	Split(string(Num), ".", nums);
	return nums[0];	
}

function string MakeUintString(float unitPrice)
{
	local string int64numStr, unitPricStr;

	int64numStr = MakeCostString(GetInt64NumStr(unitPrice));
	unitPricStr = GetDecimalNnmStr(unitPrice);
	return int64numStr $ "." $ unitPricStr;	
}

function _OnLoadEachServer()
{
	// End:0x68
	if(class'WorldExchangeBuyWnd'.static.Inst()._IsNewServer())
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Header02_Txt").SetText(GetSystemString(14424));		
	}
	else
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Header02_Txt").SetText(GetSystemString(14192));
	}	
}

defaultproperties
{
}
