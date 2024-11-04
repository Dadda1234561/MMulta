//-----------------------------------------------------------------------------------------------------------
//  멀티셀 개선 UI , 2015-04-10(작업 시작일)

//
//카페포인트 1000
//pccafe on
//

// //multisell 551     <- 혈맹관련 포인트
// //multisell 917     <- pvp 포인트 사용 멀티셀 917~924
// //multisell 890     <- raid 포인트 사용 멀티셀 890

//-----------------------------------------------------------------------------------------------------------

class MultiSellWnd extends UICommonAPI;

const DIALOG_ASK_PRICE = 1123;
const MULTISELLWND_DIALOG_OK = 1122;

const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -14;

const ROOTNAME = "root";
const treeName = "tree";
const ITEMNAME_TOTAL_WIDTH = 240;

const TIMER_UPDATE_ID = 1235552;
const TIMER_UPDATEDELAY = 10;

//-----------------------------------------------------------------------------------------------------------
// Var
//-----------------------------------------------------------------------------------------------------------
struct NoStackableItemData
{
	var int ClassID;
	var INT64 Count;
	var int EnchantLevel;
};

struct multiSellData
{
	var int PcCafePoint;
	var int clanPoint;
	var int PvPPoint;
	var int RaidPoint;
	var int craftPoint;
	var INT64 vitalityPoint;
	var INT64 Adena;
};

var WindowHandle Me;

var TextBoxHandle ItemInfo_Text;
var TextBoxHandle NeedItem_Text;
var TextBoxHandle ExchangeNum_Text;

// 검색이 항목이 없으면 여기다..
var TextBoxHandle DescriptionMsg_Text;
var TabHandle MultiSellTab;
// 전체 목록 윈도우
var WindowHandle MultisellTabTotalWnd;
var ItemWindowHandle MultisellTabTotalWnd_ItemWindow;
var RichListCtrlHandle MultisellTabTotalWnd_ListCtrl;
// 교환 가능한 윈도우
var WindowHandle MultisellTabEnableWnd;
var ItemWindowHandle MultisellTabEnableWnd_ItemWindow;
var RichListCtrlHandle MultisellTabEnableWnd_ListCtrl;
var WindowHandle DisableWnd;
// 검색 입력 텍스트
var EditBoxHandle Search_EditBox;

// 아이템 수량 입력 에디터
var EditBoxHandle ItemCount_EditBox;
var ButtonHandle InventoryViewerCall_Button;

// 검색, 갱신, 초기화
var ButtonHandle Search_button;
var ButtonHandle Refrash_Button;
var ButtonHandle Clear_Button;

// 교환, 닫기 
var ButtonHandle ExChange_Button;
var ButtonHandle Close_Button;

var ButtonHandle IconTabIcon_Button;
var ButtonHandle ListTabIcon_Button;

// 입력기 버튼
var ButtonHandle MultiSell_Up_Button;
var ButtonHandle MultiSell_Down_Button;
var ButtonHandle MultiSell_Input_Button;

var int toFindClassID;
var string m_WindowName;
var WindowHandle BuyItemRichListCtrl;
var UIControlNeedItemList needItemScript;
var RichListCtrlHandle NeedRichListCtrl;
var WindowHandle inputItemWnd;
var UIControlNumberInput inputItemScript;
var array<MultiSellInfo> m_MultiSellInfoList;
var int m_MultiSellGroupID;
var int m_nSelectedMultiSellInfoIndex;
var int m_nCurrentMultiSellInfoIndex;

// PVP, Raid 포인트를 얻어올때 사용
var UserInfo PlayerInfo;

var multiSellData mData;
var L2Util util;

var UIData UIDataScript;

// 창을 열었을때 한번만 처리 할 것들을 위한 flag
var bool bFirstAdd;
var bool bClose;

// 멀티셀 세팅 값(AI에서 설정한..)
var int nShowAll;
var int nRepeat;
var int nKeepEnchant;
var int nShowEnsoul;

// 결과 이후, 입력 아이템 카운트
var int nRepeatTimeCurrentInputItemInfoIndex;

// 최종 선택 했던 아이템 정보 기억 했다가 복원 할때 사용
var ItemInfo lastSelectItemInfo;

var string dialogMessage;

// tick 당 갱신 및 추가를 위한 변수
var bool useTick;
var int tickIndex;
var int tickItemListIndex;

// 검색어 string 
var string searchStr;
var bool searchMode;
var bool bForceUpdate;
var int bShowVariationItem;
var int ShowType;

//-----------------------------------------------------------------------------------------------------------
// Init
//-----------------------------------------------------------------------------------------------------------
function OnRegisterEvent()
{
	RegisterEvent(EV_MultiSellInfoListBegin);
	RegisterEvent(EV_MultiSellResultItemInfo);
	RegisterEvent(EV_MultiSellOutputItemInfo);
	RegisterEvent(EV_MultiSellInputItemInfo);
	RegisterEvent(EV_MultiSellInfoListEnd);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
	RegisterEvent(EV_MultiSellResult);
	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_UpdateUserInfo);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

// 드래그가 없는 것은 Down으로 처리 했다. 
function OnLButtonDown(WindowHandle a_WindowHandle, int nX, int nY)
{
	if(GetWindowHandle("InventoryViewer").IsShowWindow())
	{
		GetWindowHandle("InventoryViewer").BringToFront();

		if(GetWindowHandle("DialogBox").IsShowWindow())
		{
			GetWindowHandle("DialogBox").SetFocus();
		}
	}
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	bFirstAdd = true;
	Search_EditBox.SetString("");
	disableWindowWithText(false, "");
	DisableWnd.HideWindow();
	inputItemScript.SetCount(0);
	MultiSell_Input_Button.DisableWindow();
}

function OnHide()
{
	local ItemInfo nullInfo;

	lastSelectItemInfo = nullInfo;
	bClose = false;
	Me.DisableTick();
	useTick = false;

	if(DialogIsMine())
	{
		DialogHide();
	}

	Me.KillTimer(TIMER_UPDATE_ID);
	iniListWithItemWindow();

	if(GetWindowHandle("InventoryViewer").IsShowWindow())
	{
		GetWindowHandle("InventoryViewer").HideWindow();
	}
	needItemScript.CleariObjects();
}

function Initialize()
{
	util = L2Util(GetScript("L2Util"));
	UIDataScript = UIData(GetScript("UIData"));
	Me = GetWindowHandle("MultiSellWnd");
	DisableWnd = GetWindowHandle("MultiSellWnd.DisableWnd");
	ItemInfo_Text = GetTextBoxHandle("MultiSellWnd.ItemInfo_Text");
	NeedItem_Text = GetTextBoxHandle("MultiSellWnd.NeedItem_Text");
	ExchangeNum_Text = GetTextBoxHandle("MultiSellWnd.ExchangeNum_Text");
	DescriptionMsg_Text = GetTextBoxHandle("MultiSellWnd.DescriptionMsgWnd.DescriptionMsg_Text");
	MultiSellTab = GetTabHandle("MultiSellWnd.MultiSellTab");
	MultisellTabTotalWnd = GetWindowHandle("MultiSellWnd.MultisellTabTotalWnd");
	MultisellTabTotalWnd_ListCtrl = GetRichListCtrlHandle("MultiSellWnd.MultisellTabTotalWnd.MultisellTabTotalWnd_ListCtrl");
	MultisellTabTotalWnd_ItemWindow = GetItemWindowHandle("MultiSellWnd.MultisellTabTotalWnd.MultisellTabTotalWnd_ItemWindow");
	MultisellTabEnableWnd = GetWindowHandle("MultiSellWnd.MultisellTabEnableWnd");
	MultisellTabEnableWnd_ListCtrl = GetRichListCtrlHandle("MultiSellWnd.MultisellTabEnableWnd.MultisellTabEnableWnd_ListCtrl");
	MultisellTabEnableWnd_ItemWindow = GetItemWindowHandle("MultiSellWnd.MultisellTabEnableWnd.MultisellTabEnableWnd_ItemWindow");
	Search_EditBox = GetEditBoxHandle("MultiSellWnd.Search_EditBox");
	ItemCount_EditBox = GetEditBoxHandle("MultiSellWnd.inputItemWnd.ItemCount_EditBox");
	BuyItemRichListCtrl = GetWindowHandle("MultiSellWnd.BuyItemRichListCtrl");
	NeedRichListCtrl = GetRichListCtrlHandle("MultiSellWnd.BuyItemRichListCtrl.NeedRichListCtrl");
	inputItemWnd = GetWindowHandle("MultiSellWnd.InputItemWnd");
	Search_button = GetButtonHandle("MultiSellWnd.Search_Button");
	Refrash_Button = GetButtonHandle("MultiSellWnd.Refrash_Button");
	Clear_Button = GetButtonHandle("MultiSellWnd.Clear_Button");
	ExChange_Button = GetButtonHandle("MultiSellWnd.ExChange_Button");
	Close_Button = GetButtonHandle("MultiSellWnd.Close_Button");
	IconTabIcon_Button = GetButtonHandle("MultiSellWnd.IconTabIcon_Button");
	ListTabIcon_Button = GetButtonHandle("MultiSellWnd.ListTabIcon_Button");
	MultiSell_Up_Button = GetButtonHandle("MultiSellWnd.inputItemWnd.MultiSell_Up_Button");
	MultiSell_Down_Button = GetButtonHandle("MultiSellWnd.inputItemWnd.MultiSell_Down_Button");
	MultiSell_Input_Button = GetButtonHandle("MultiSellWnd.MultiSell_Input_Button_2");
	InventoryViewerCall_Button = GetButtonHandle("MultiSellWnd.InventoryViewerCall_Button");
	MultisellTabTotalWnd_ListCtrl.SetSelectedSelTooltip(false);
	MultisellTabTotalWnd_ListCtrl.SetAppearTooltipAtMouseX(true);
	MultisellTabEnableWnd_ListCtrl.SetSelectedSelTooltip(false);
	MultisellTabEnableWnd_ListCtrl.SetAppearTooltipAtMouseX(true);
	IconTabIcon_Button.SetTooltipText(GetSystemString(3397));
	ListTabIcon_Button.SetTooltipText(GetSystemString(3397));
	// 초기화 토글
	toggleListWithIconWindow(true);
	InitNeedItem();
	InitInputControl();
}

// 아이콘 윈도우, 리스트 컨트롤로 토글 하면서 보여주도록
function toggleListWithIconWindow(optional bool bInit)
{
	if(bInit)
	{
		// 리스트를 기본으로.. 
		IconTabIcon_Button.HideWindow();
		ListTabIcon_Button.ShowWindow();
	}

	if(ListTabIcon_Button.IsShowWindow())
	{
		// 아이콘 목록이 보이게
		IconTabIcon_Button.ShowWindow();
		ListTabIcon_Button.HideWindow();
		MultisellTabTotalWnd_ItemWindow.HideWindow();
		MultisellTabTotalWnd_ListCtrl.ShowWindow();
		MultisellTabEnableWnd_ItemWindow.HideWindow();
		MultisellTabEnableWnd_ListCtrl.ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listSlotBg1_Texture_MultisellTabIconWnd").HideWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listSlotBg2_Texture_MultisellTabIconWnd").HideWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listSlotBg1_Texture_MultisellTabIconWnd").HideWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listSlotBg2_Texture_MultisellTabIconWnd").HideWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listGroupBg_Texture_MultisellTabIistWnd").ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listGroupBg_Texture_MultisellTabIistWnd").ShowWindow();
	}
	else
	{
		// 리스트 목록이 보이게
		IconTabIcon_Button.HideWindow();
		ListTabIcon_Button.ShowWindow();
		MultisellTabTotalWnd_ListCtrl.HideWindow();
		MultisellTabTotalWnd_ItemWindow.ShowWindow();
		MultisellTabEnableWnd_ListCtrl.HideWindow();
		MultisellTabEnableWnd_ItemWindow.ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listSlotBg1_Texture_MultisellTabIconWnd").ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listSlotBg2_Texture_MultisellTabIconWnd").ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listSlotBg1_Texture_MultisellTabIconWnd").ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listSlotBg2_Texture_MultisellTabIconWnd").ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listGroupBg_Texture_MultisellTabIistWnd").HideWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listGroupBg_Texture_MultisellTabIistWnd").HideWindow();
	}
}

function InitNeedItem()
{
	BuyItemRichListCtrl.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(BuyItemRichListCtrl.GetScript());
	needItemScript.SetRichListControler(NeedRichListCtrl);
}

function InitInputControl()
{
	inputItemWnd.SetScript("UIControlNumberInput");
	inputItemScript = UIControlNumberInput(inputItemWnd.GetScript());
	inputItemScript.Init(m_WindowName $ ".inputItemWnd");
	inputItemScript.DelegateGetCountCanBuy = MaxNumCanBuy;
	inputItemScript.DelegateOnItemCountEdited = OnItemCountChanged;
	inputItemScript.DelegateESCKey = OnESCKey;
	inputItemScript.Reset_Btn = GetButtonHandle(m_WindowName $ ".inputItemWnd.Reset_Btn");
	inputItemScript.Buy_Btn = GetButtonHandle(m_WindowName $ ".ExChange_Button");
	MultiSell_Up_Button.DisableWindow();
	MultiSell_Down_Button.DisableWindow();
	MultiSell_Input_Button.DisableWindow();
}

function INT64 MaxNumCanBuy()
{
	local RichListCtrlRowData RowData;
	local int Count, Index;

	if(MultiSellTab.GetTopIndex() == 0)
	{
		Index = MultisellTabTotalWnd_ListCtrl.GetSelectedIndex();
		MultisellTabTotalWnd_ListCtrl.GetRec(Index, RowData);		
	}
	else
	{
		Index = MultisellTabEnableWnd_ListCtrl.GetSelectedIndex();
		MultisellTabEnableWnd_ListCtrl.GetRec(Index, RowData);
	}

	if(IsStackableItem(int(RowData.nReserved1)))
	{
		Count = int(needItemScript.GetMaxNumCanBuy());		
	}
	else
	{
		Count = Min(1, int(needItemScript.GetMaxNumCanBuy()));
	}
	return Count;
}

function OnItemCountChanged(INT64 ItemCount)
{
	ItemCount = MAX64(1, ItemCount);
	needItemScript.SetBuyNum(int(ItemCount));
}

//-----------------------------------------------------------------------------------------------------------
// OnEvent
//-----------------------------------------------------------------------------------------------------------
function OnEvent(int Event_ID, string param)
{
	local UserInfo UserInfo;

	if(Event_ID == EV_MultiSellInfoListBegin)
	{
		ParseInt(param, "ShowType", ShowType);
	}
	if(ShowType == 3)
	{
		return;
	}
	if(ShowType == 4)
	{
		return;
	}

	switch(Event_ID)
	{
		case EV_MultiSellInfoListBegin:
			if(!bClose)
			{
				HandleMultiSellInfoListBegin(param);
			}
			break;
		case EV_MultiSellResultItemInfo:
			if(!bClose)
			{
				HandleMultiSellResultItemInfo(param);
			}
			break;
		case EV_MultiSellOutputItemInfo:
			if(!bClose)
			{
				HandelMultiSellOutputItemInfo(param);
			}
			break;
		case EV_MultiSellInputItemInfo:
			if(!bClose)
			{
				HandelMultiSellInputItemInfo(param);
			}
			break;
		case EV_MultiSellInfoListEnd:
			Me.DisableTick();
			useTick = false;
			Me.KillTimer(TIMER_UPDATE_ID);

			if(bClose)
			{
				Me.HideWindow();
			}
			else
			{
				HandleMultiSellInfoListEnd(param);

				if(getInstanceUIData().getIsClassicServer())
				{
					if(nShowAll == 0)
					{
						MultiSellTab.SetTopOrder(1, true);						
					}
					else
					{
						MultiSellTab.SetTopOrder(0, true);
					}
				}
				ShowItemList();
			}
			break;
		case EV_DialogOK:
			HandleDialogOK(true);
			break;
		case EV_DialogCancel:
			HandleDialogOK(false);
			break;
		case EV_MultiSellResult:
			HandleMultiSellResult(param);
			break;
		case EV_AdenaInvenCount:
			if(Me.IsShowWindow())
			{
			}
			break;
		case EV_UpdateUserInfo:
			if(Me.IsShowWindow())
			{
				if(GetPlayerInfo(UserInfo))
				{
					mData.vitalityPoint = UserInfo.nVitality;
				}
			}
			break;
	}
}

function OnTimer(int TimerID)
{
	if(TimerID == TIMER_UPDATE_ID)
	{
		Me.DisableTick();
		useTick = false;

		if(isExchangeWindowState())
		{
			setSelectItem(lastSelectItemInfo);
		}
		updateUIControl();
		Me.KillTimer(TIMER_UPDATE_ID);
	}
}

//  초기화
function ClearAll()
{
	Me.KillTimer(TIMER_UPDATE_ID);
	m_nCurrentMultiSellInfoIndex = 0;
	m_MultiSellInfoList.Length = 0;
	m_MultiSellGroupID = 0;
	disableWindowWithText(false, "");
	DisableWnd.HideWindow();
	iniListWithItemWindow();
}

// 기본 컨트롤 초기화
function iniListWithItemWindow()
{
	// 교환할 아이템 목록, 아이템 윈도우, 리스트 초기화
	MultisellTabTotalWnd_ListCtrl.DeleteAllItem();
	MultisellTabTotalWnd_ItemWindow.Clear();
	MultisellTabEnableWnd_ItemWindow.Clear();
	MultisellTabEnableWnd_ListCtrl.DeleteAllItem();
}

// HandleMultiSellInfoListBegin
function HandleMultiSellInfoListBegin(string param)
{
	local ItemInfo nullInfo;

	bShowVariationItem = 0;
	ParseInt(param, "ShowAll", nShowAll);
	ParseInt(param, "Repeat", nRepeat);
	ParseInt(param, "ShowVariationItem", bShowVariationItem);
	ParseInt(param, "KeepEnchant", nKeepEnchant);
	ParseInt(param, "ShowEnsoul", nShowEnsoul);

	if(! (nRepeat == 1) && nShowAll == 1)
	{
		bFirstAdd = true;
		ClearAll();
	}

	if(nRepeat == 0)
	{
		lastSelectItemInfo = nullInfo;
	}
	ParseInt(param, "MultiSellGroupID", m_MultiSellGroupID);

	if(nRepeat == 1)
	{
		m_nCurrentMultiSellInfoIndex = 0;
		m_MultiSellInfoList.Length = 0;
	}

	ParseInt(param, "ShowType", ShowType);
	Debug("ShowType" @ string(ShowType));
	switch(ShowType)
	{
		case 0:
			MultiSellTab.SetButtonName(1, GetSystemString(3396));
			setWindowTitleByString(GetSystemString(136));
			ExChange_Button.SetButtonName(445);
			break;
		case 1:
			MultiSellTab.SetButtonName(1, GetSystemString(13183));
			setWindowTitleByString(GetSystemString(645));
			ExChange_Button.SetButtonName(645);
			break;
		case 2:
			MultiSellTab.SetButtonName(1, GetSystemString(3396));
			setWindowTitleByString(GetSystemString(13161));
			ExChange_Button.SetButtonName(445);
			break;
	}
}

/*---------------------------------------------------------------------------------------------------------
  구매 시도 후 결과
 ---------------------------
  Success -> 1은 성공, 0은 실패
  NumPoint -> 아래 type, point 페어 갯수
  Type0 -> 첫번째 포인트 타입(타입 EnuM은 미정)
  Point0 -> 변경된 포인트
  Type1 -> 두번째 포인트 타입
  Point1 -> 변경된 포인트
---------------------------------------------------------------------------------------------------------*/
function HandleMultiSellResult(string param)
{
	local int Success;

	if(Me.IsShowWindow())
	{
		Me.DisableTick();
		useTick = false;
		Me.KillTimer(TIMER_UPDATE_ID);

		if(dialogMessage == GetSystemMessage(4363) && hasExceptionMultiSellID() == false)
		{
			bClose = true;
		}
		else
		{
			ParseInt(param, "Success", Success);
			getCurrentSelectedItemInfo(lastSelectItemInfo);
			updateMultiSellData(param);
			bClose = false;
		}
	}
}

// 강제 닫기를 안하게 할 멀티셀 ID 
// 방어구, 세트 등을 다시 환불 받는데 멀티셀이 닫힐 경우 하나 하나 다시 열기 너무 힘듬. 그걸 위한 하드코딩
function bool hasExceptionMultiSellID()
{
	local bool bFlag;

	switch(m_MultiSellGroupID)
	{
		case 903:
			bFlag = true;
		case 2196:
			bFlag = true;

		default:
			return bFlag;
	}
}

function HandleMultiSellResultItemInfo(string param)
{
	local int nMultiSellInfoID, nBuyType, nIsBlessedItem;
	local ItemInfo Info;
	local int ensoulNormalSlot, ensoulBmSlot;

	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "BuyType", nBuyType);

	ParseInt(param, "Enchanted", Info.Enchanted);

	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);

	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);

	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);
	// 신규 집혼 추가(2015-03-09)
	ParseInt(param, "EnsoulOptionNum_" $ EIST_BM, ensoulBmSlot);
	ParseInt(param, "EnsoulOptionNum_" $ EIST_NORMAL, ensoulNormalSlot);
	// 아이템에 집혼 정보를 적용 시킴
	addEnsoulInfo(EIST_BM, ensoulBmSlot, param, Info);
	addEnsoulInfo(EIST_NORMAL, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);
	m_nCurrentMultiSellInfoIndex = m_MultiSellInfoList.Length;
	m_MultiSellInfoList.Length = m_MultiSellInfoList.Length + 1;
	nRepeatTimeCurrentInputItemInfoIndex = 0;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID = nMultiSellInfoID;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellType = nBuyType;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].ResultItemInfo = Info;
}

// HandelMultiSellOutputItemInfo
function HandelMultiSellOutputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentOutputItemInfoIndex, nIsBlessedItem;
	local ItemInfo Info;
	local int nItemClassID, ensoulNormalSlot, ensoulBmSlot;

	ParseItemID(param, Info.Id);
	class'UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);
	ParseInt(param, "ClassID", nItemClassID);
	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseINT64(param, "SlotBitType", Info.SlotBitType); // INT -> INT64, JEWEL 추가 - by y2jinc(2013. 9. 2)
	ParseInt(param, "ItemType", Info.ItemType);
	ParseINT64(param, "ItemCount", Info.ItemNum);
	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);

	// 신규 집혼 추가(2015-03-09)
	ParseInt(param, "EnsoulOptionNum_" $ EIST_BM, ensoulBmSlot);
	ParseInt(param, "EnsoulOptionNum_" $ EIST_NORMAL, ensoulNormalSlot);

	// 아이템에 집혼 정보를 적용 시킴
	addEnsoulInfo(EIST_BM, ensoulBmSlot, param, Info);
	addEnsoulInfo(EIST_NORMAL, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);

	if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
	{
		//debug("MultiSellWnd::HandelMultiSellOutputItemInfo - Invalid nMultiSellInfoID");
		return;
	}

	if(nItemClassID == MSIT_PCCAFE_POINT)
	{
		Info.Name = GetSystemString(1277);
		Info.IconName = GetPcCafeItemIconPackageName();//"icon.etc_i.etc_pccafe_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if(nItemClassID == MSIT_PLEDGE_POINT)
	{
		Info.Name = GetSystemString(1311);
		Info.IconName = "icon.etc_i.etc_bloodpledge_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if(nItemClassID == MSIT_PVP_POINT)
	{
		Info.Name = GetSystemString(102);
		Info.IconName = "icon.pvp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if(nItemClassID == MSIT_RAID_POINT)
	{
		Info.Name = GetSystemString(3183);
		Info.IconName = "icon.etc_i.etc_rp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if(nItemClassID == MSIT_CRAFT_POINT)
	{
		Info.Name = GetSystemString(13159);
		Info.IconName = "Icon.etc_i.craft_point";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if(nItemClassID == MSIT_VITAL_POINT)
	{
		Info.Name = GetSystemString(2492);
		Info.IconName = "icon.etc_sayha_point_01";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}

	// 투영병기의 경우 강제로, 100% Durability를 표시하게 합니다 - NeverDie
	if(0 < Info.Durability)
	{
		Info.CurrentDurability = Info.Durability;
	}
	nCurrentOutputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length = nCurrentOutputItemInfoIndex + 1;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex] = Info;

	// 현재 출력되고 있는 전체 목록의 index를 임시로 저장시킨다.
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex].Reserved = m_nCurrentMultiSellInfoIndex;
}

// HandelMultiSellInputItemInfo
function HandelMultiSellInputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentInputItemInfoIndex, nItemClassID, nIsBlessedItem;
	local ItemInfo Info;
	local int ensoulNormalSlot, ensoulBmSlot;

	ParseItemID(param, Info.Id);
	class'UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);

	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "ClassID", nItemClassID);
	ParseInt(param, "ItemType", Info.ItemType);
	ParseINT64(param, "ItemCount", Info.ItemNum);
	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);

	// 신규 집혼 추가(2015-03-09)
	ParseInt(param, "EnsoulOptionNum_" $ EIST_BM, ensoulBmSlot);
	ParseInt(param, "EnsoulOptionNum_" $ EIST_NORMAL, ensoulNormalSlot);

	// 아이템에 집혼 정보를 적용 시킴
	addEnsoulInfo(EIST_BM, ensoulBmSlot, param, Info);
	addEnsoulInfo(EIST_NORMAL, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);

	if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
	{
		//debug("MultiSellWnd::HandelMultiSellInputItemInfo - Invalid nMultiSellInfoID");
		return;
	}
	if(nItemClassID == MSIT_PCCAFE_POINT)
	{
		Info.Name = GetSystemString(1277);
		Info.IconName = GetPcCafeItemIconPackageName();//"icon.etc_i.etc_pccafe_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if(nItemClassID == MSIT_PLEDGE_POINT)
	{
		Info.Name = GetSystemString(1311);
		Info.IconName = "icon.etc_i.etc_bloodpledge_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if(nItemClassID == MSIT_PVP_POINT)
	{
		Info.Name = GetSystemString(102);
		Info.IconName = "icon.pvp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if(nItemClassID == MSIT_RAID_POINT)
	{
		Info.Name = GetSystemString(3183);
		Info.IconName = "icon.etc_i.etc_rp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if(nItemClassID == MSIT_CRAFT_POINT)
	{
		Info.Name = GetSystemString(13159);
		Info.IconName = "Icon.etc_i.craft_point";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if(nItemClassID == MSIT_VITAL_POINT)
	{
		Info.Name = GetSystemString(2492);
		Info.IconName = "icon.etc_sayha_point_01";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else
	{
		Info.Name = class'UIDATA_ITEM'.static.GetItemName(Info.Id);
		Info.IconName = class'UIDATA_ITEM'.static.GetItemTextureName(Info.Id);
	}

	// 이걸 왜 이렇게 하는지 의문.. 아이템 타입이 아니다. 
	Info.CrystalType = class'UIDATA_ITEM'.static.GetItemCrystalType(Info.Id);

	//-400 필드사이클일 경우 아무 데이터도 삽입 안하는 것으로 처리 함. 
	if(nItemClassID != MSIT_FIELD_CYCLE_POINT)
	{
		nCurrentInputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length;
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length = nCurrentInputItemInfoIndex + 1;
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList[nCurrentInputItemInfoIndex] = Info;
	}
}

// HandleMultiSellInfoListEnd
function HandleMultiSellInfoListEnd(string param)
{
	if(!Me.IsShowWindow())
	{
		Me.ShowWindow();
	}
	updateMultiSellData();
}

function OnTick()
{
	local int i;

	for(i = 0; i < 50; i++)
	{
		tickItemAdd();

		tickItemListIndex++;

		if(tickItemListIndex >= m_MultiSellInfoList.Length)
		{
			Me.DisableTick();
			useTick = false;
			bFirstAdd = false;
			bForceUpdate = false;

			// 검색모드와 전체목록 모드에 따라 아이템이 없을떄 나오는 disable 메세지를 다
			if(searchMode)
			{
				// 전체 목록
				if(MultiSellTab.GetTopIndex() == 0)
				{
					if(MultisellTabTotalWnd_ItemWindow.GetItemNum() <= 0)
					{
						disableWindowWithText(true, MakeFullSystemMsg(GetSystemMessage(4356), searchStr)); // <$s1>\n검색어에 해당되는 아이템이 없습니다
					}
					else
					{
						disableWindowWithText(false, "");
					}
				}
				else
				{
					if(MultisellTabEnableWnd_ItemWindow.GetItemNum() <= 0)
					{
						disableWindowWithText(true, MakeFullSystemMsg(GetSystemMessage(4356), searchStr));
					}
					else
					{
						disableWindowWithText(false, "");
					}
				}
			}
			else
			{
				if(MultiSellTab.GetTopIndex() == 1 && MultisellTabEnableWnd_ItemWindow.GetItemNum() <= 0)
				{
					disableWindowWithText(true, GetSystemMessage(4357));
				}
				else
				{
					disableWindowWithText(false, "");
				}
			}

			Me.KillTimer(TIMER_UPDATE_ID);
			Me.SetTimer(TIMER_UPDATE_ID, TIMER_UPDATEDELAY);
			break;
		}
	}
}

function tickItemAdd()
{
	local int i;
	local ItemInfo Info;
	local string fullNameString;
	local array<NoStackableItemData> NoStackableItemDataArray;
	local bool bNoExchange, bCheck;
	local int arrayIndex, N;

	i = tickItemListIndex;

	if(m_MultiSellInfoList.Length > i)
	{
		Info = m_MultiSellInfoList[i].OutputItemInfoList[0];

		if(bFirstAdd || isExchangeWindowState())
		{
			Search_EditBox.AddNameToAdditionalSearchList(Info.Name, ESearchListType.SLT_ADDITIONAL_LIST);
		}

		fullNameString = GetItemNameAll(Info);

		// 키워드가 매칭될때,  검색모드가 아니면 그냥 통과
		if(findMatchString(fullNameString, searchStr) != -1 || searchMode == false)
		{
			bNoExchange = false;
			NoStackableItemDataArray.Length = 0;

			for(N=0; N < m_MultiSellInfoList[i].InputItemInfoList.Length; N++)
			{
				// 수량성 아이템인가?
				if(IsStackableItem(m_MultiSellInfoList[i].InputItemInfoList[N].ConsumeType))
				{
					bCheck = CompareWithInven(m_MultiSellInfoList[i].InputItemInfoList[N]);
				}
				else
				{
					arrayIndex = GetNoStackableItemCountArrayIndex(m_MultiSellInfoList[i].InputItemInfoList[N], NoStackableItemDataArray);
					bCheck = CompareWithInven(m_MultiSellInfoList[i].InputItemInfoList[N], NoStackableItemDataArray[arrayIndex]);
				}
				if(bCheck == false)
				{
					bNoExchange = true;
				}
			}
			if(bNoExchange == false)
			{
				// 교환 가능한 아이콘
				Info.ForeTexture = "L2UI_CT1.SellablePanel";

				// 구매 가능한 목록 추가
				MultisellTabEnableWnd_ItemWindow.AddItem(Info);
				addItem_RichListCtrl(MultisellTabEnableWnd_ListCtrl, Info);
			}
			// 최초로 목록이 들어 올때 전체 탭에 추가, 그외에는 검색에서 강제로 추가
			if(bFirstAdd || bForceUpdate)
			{
				// 전체 목록에 추가
				MultisellTabTotalWnd_ItemWindow.AddItem(Info);
				addItem_RichListCtrl(MultisellTabTotalWnd_ListCtrl, Info);
			}
			else
			{
				// 전체 탭 상태일때만 업데이트
				if(isExchangeWindowState() == false)
				{
					MultisellTabTotalWnd_ItemWindow.SetItem(i, Info);
				}
			}
		}
	}
}

// 아이템 목록을 추가한다. 
function ShowItemList()
{
	searchStr = Search_EditBox.GetString();

	if(searchStr != "")
	{
		searchMode = true;
		bFirstAdd = true;
	}
	else
	{
		searchMode = false;
	}
	needItemScript.CleariObjects();
	class'UIAPI_MULTISELLITEMINFO'.static.Clear("MultiSellWnd.multiSellItemInfo");

	if(bFirstAdd || bForceUpdate)
	{
		iniListWithItemWindow();
		Search_EditBox.ClearAdditionalSearchList(ESearchListType.SLT_ADDITIONAL_LIST);
	}

	if(isExchangeWindowState())
	{
		MultisellTabEnableWnd_ItemWindow.Clear();
		MultisellTabEnableWnd_ListCtrl.DeleteAllItem();
	}
	tickItemListIndex = 0;
	useTick = true;
	Me.EnableTick();
}

function bool isExchangeWindowState()
{
	return(MultiSellTab.GetTopIndex()== 1 || bForceUpdate);
}

// 검색 후 결과 값이 없으면 보여줄 텍스트 
function disableWindowWithText(bool bShow, string msgTxt)
{
	if(bShow)
	{
		DescriptionMsg_Text.SetText(msgTxt);
		GetWindowHandle("MultiSellWnd.DescriptionMsgWnd").ShowWindow();
	}
	else
	{
		GetWindowHandle("MultiSellWnd.DescriptionMsgWnd").HideWindow();
	}
}

// 인벤토리와 비교
function bool CompareWithInven(ItemInfo Info, optional NoStackableItemData noStackableItemDataInfo)
{
	local ItemInfo InvenItemInfo;
	local bool flag;
	local int hasItemCount;
	local array<ItemInfo> itemInfoArr;

	// MSIT_PCCAFE_POINT
	if(Info.IconName == GetPcCafeItemIconPackageName())
	{
		// Debug("pcUIDataScript.getCurrentPcCafePoint()" @ UIDataScript.getCurrentPcCafePoint());
		if(mData.PcCafePoint >= Info.ItemNum)
		{
			return true;
		}
	}
	// MSIT_PLEDGE_POINT
	else if(Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00")
	{
		if(mData.clanPoint >= Info.ItemNum)
		{
			return true;
		}
	}
	// MSIT_PVP_POINT
	else if(Info.IconName == "icon.pvp_point_i00")
	{
		if(mData.PvPPoint >= Info.ItemNum)
		{
			return true;
		}
	}
	// MSIT_RAID_POINT
	else if(Info.IconName == "icon.etc_i.etc_rp_point_i00")
	{
		if(mData.RaidPoint >= Info.ItemNum)
		{
			return true;
		}
	}
	// 인벤토리에 있나
	else if(Info.IconName == "Icon.etc_i.craft_point")
	{
		if(mData.craftPoint >= Info.ItemNum)
		{
			return true;
		}
	}
	else if(Info.IconName == "icon.etc_sayha_point_01")
	{
		if(mData.vitalityPoint >= Info.ItemNum)
		{
			return true;
		}
	}
	else if(Info.Id.ClassID > 0)
	{
		// 아이템이 인벤에 있나? classID 로 비교
		itemInfoArr.Length = 0;
		itemInfoArr = FindItems(Info.Id.ClassID);
		hasItemCount = itemInfoArr.Length;

		if(hasItemCount > 0)
		{
			// 아이템을 가지고 있다면
			InvenItemInfo = itemInfoArr[0];
			// 수량에 맞게 있나?
			if(IsStackableItem(InvenItemInfo.ConsumeType))
			{
				if(InvenItemInfo.ItemNum >= Info.ItemNum)
				{
					return true;
				}
			}
			else
			{
				// 비수량성 아이템은 별도의 수량을 표시 하지 않고 존재 한다는 의미로 1 를 넣는다.
				if(noStackableItemDataInfo.ClassID > 0)
				{

					if (noStackableItemDataInfo.EnchantLevel > 0)
					{
						if (Info.Enchanted != noStackableItemDataInfo.EnchantLevel)
						{
							return false;
						}
					}

					if(noStackableItemDataInfo.Count > 0)
					{
						flag = true;
					}
				}
				return flag;
			}
		}
	}

	return false;
}

function addItem_RichListCtrl(RichListCtrlHandle itemListCtrl, ItemInfo Info)
{
	local RichListCtrlRowData Record;
	local string fullNameString, toolTipParam;

	fullNameString = GetItemNameAll(Info, true);
	ItemInfoToParam(Info, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.cellDataList.Length = 1;
	Record.nReserved1 = int64(Info.ConsumeType);
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 8, 1);
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, Info, 32, 32, -34, 1);

	if(Info.IconPanel != "")
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconPanel, 32, 32, -32, 0);
	}
	if(Info.IsBlessedItem)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "Icon.icon_panel.bless_panel", 32, 32, -32, 0);
	}
	if(Info.Enchanted > 0)
	{
	}
	if(Info.ForeTexture != "")
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.ForeTexture, 32, 32, -32, 0);
	}
	if(IsStackableItem(Info.ConsumeType))
	{
		fullNameString = makeShortStringByPixel(fullNameString, 192, "..");
		addRichListCtrlString(Record.cellDataList[0].drawitems, fullNameString, getInstanceL2Util().White, false, 6, 10);

		if(Info.AdditionalName != "")
		{
			addRichListCtrlString(Record.cellDataList[0].drawitems, Info.AdditionalName, getInstanceL2Util().Yellow03, false, 3, 0);
		}

		if(Info.ItemNum > 0)
		{
			addRichListCtrlString(Record.cellDataList[0].drawitems, ("(" $ string(Info.ItemNum)) $ ")", getInstanceL2Util().White, false, 0, 0);			
		}
		else
		{
			addRichListCtrlString(Record.cellDataList[0].drawitems, "(1)", getInstanceL2Util().White, false, 0, 0);
		}
	}
	else
	{
		fullNameString = makeShortStringByPixel(fullNameString, 210, "..");
		addRichListCtrlString(Record.cellDataList[0].drawitems, fullNameString, getInstanceL2Util().White, false, 6, 10);

		if(Info.AdditionalName != "")
		{
			addRichListCtrlString(Record.cellDataList[0].drawitems, Info.AdditionalName, getInstanceL2Util().Yellow03, false, 3, 0);
		}
	}
	itemListCtrl.InsertRecord(Record);
}

// 멀티셀 에서 사용하는 데이타를 갱신한다.
function updateMultiSellData(optional string serverUpdateParam)
{
	// 서버 결과 값에 따라서 여기서
	local int nPointCount, nPoint, nType, N;

	// 유저 정보를 새로 받고..
	GetPlayerInfo(PlayerInfo);

	ParseInt(serverUpdateParam, "NumPoint", nPointCount);

	for(N = 0; N < nPointCount; N++)
	{
		ParseInt(serverUpdateParam, "Type" $ string(N), nType);
		ParseInt(serverUpdateParam, "Point" $ string(N), nPoint);

		if(MSIT_RAID_POINT == nType)
		{
			mData.PvPPoint = nPoint;
		}
		else if(MSIT_PVP_POINT == nType)
		{
			mData.PvPPoint = nPoint;
		}
		else if(MSIT_PLEDGE_POINT == nType)
		{
			mData.clanPoint = nPoint;
			UIDataScript.setCurrentClanNameValue(nPoint);
		}
		else if(MSIT_PCCAFE_POINT == nType)
		{
			mData.PcCafePoint = nPoint;
			UIDataScript.setPcCafePoint(nPoint);

			//Debug("mData.PcCafePoint" @ mData.PcCafePoint);
		}
		else if(MSIT_CRAFT_POINT == nType)
		{
			mData.craftPoint = nPoint;
		}
	}

	//Debug("nPointCount" @ nPointCount);

	// 서버에서 지정한 값으로 업데이트가 아닌 경우 내부 정보로 업데이트
	if(nPointCount <= 0)
	{
		mData.PvPPoint = PlayerInfo.PvPPoint;
		mData.RaidPoint = PlayerInfo.RaidPoint;
		mData.PcCafePoint = UIDataScript.getCurrentPcCafePoint();
		mData.clanPoint = UIDataScript.getCurrentClanNameValue();
		mData.craftPoint = UIDataScript.getCurrentCraftPoint();
	}
	mData.vitalityPoint = UIDataScript.getCurrentVitalityPoint();
}

//-----------------------------------------------------------------------------------------------------------
// HandleDialogOK
//-----------------------------------------------------------------------------------------------------------
function HandleDialogOK(bool bOK)
{
	local string param;
	local int SelectedIndex, Id, tryExchangeCount;
	local INT64 inputNum;

	if(DialogIsMine())
	{
		DisableWnd.HideWindow();
		Id = DialogGetID();

		// ok를 눌렀을때 
		if(bOK)
		{
			if(Id == DIALOG_ASK_PRICE)
			{
				inputNum = int64(DialogGetString());

				if(inputNum <= 0)
				{
					inputNum = 1;
				}
				tryExchangeCount = Min(int(inputNum), int(needItemScript.GetMaxNumCanBuy()));
				inputItemScript.SetCount(tryExchangeCount);
			}
			else
			{
				tryExchangeCount = int(ItemCount_EditBox.GetString());
				setTreeNeedItemInfo();
				SelectedIndex = DialogGetReservedInt();

				if(SelectedIndex >= m_MultiSellInfoList.Length)
				{
					//debug("MultiSellWnd::HandleDialogOK - Invalid SelectIndex(" $ SelectedIndex $ ")");
					return;
				}

				ParamAdd(param, "MultiSellGroupID", string(m_MultiSellGroupID));
				ParamAdd(param, "MultiSellInfoID", string(m_MultiSellInfoList[SelectedIndex].MultiSellInfoID));
				ParamAdd(param, "ItemCount", string(DialogGetReservedInt2()));
				ParamAdd(param, "Enchant", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.Enchanted));
				ParamAdd(param, "RefineryOp1", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp1));
				ParamAdd(param, "RefineryOp2", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp2));
				ParamAdd(param, "AttrAttackType", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeType));
				ParamAdd(param, "AttrAttackValue", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeValue));
				ParamAdd(param, "AttrDefenseValueFire", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueFire));
				ParamAdd(param, "AttrDefenseValueWater", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWater));
				ParamAdd(param, "AttrDefenseValueWind", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWind));
				ParamAdd(param, "AttrDefenseValueEarth", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueEarth));
				ParamAdd(param, "AttrDefenseValueHoly", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueHoly));
				ParamAdd(param, "AttrDefenseValueUnholy", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueUnholy));
				addParamEnsoulOptionInfo(m_MultiSellInfoList[SelectedIndex].ResultItemInfo, param);
				ParamAdd(param, "IsBlessedItem", string(boolToNum(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.IsBlessedItem)));
				RequestMultiSellChoose(param);
			}
		}
		else
		{
			DisableWnd.HideWindow();
		}
	}
}

//-----------------------------------------------------------------------------------------------------------
// OnClickItem, OnClickListCtrlRecord, OnClickButton
//-----------------------------------------------------------------------------------------------------------
function OnDBClickItem(string Name, int Index)
{
	// Debug("Name" @ Name);

	if(Name == "MultisellTabTotalWnd_ItemWindow" || Name == "MultisellTabEnableWnd_ItemWindow")
	{
		OnExChange_ButtonClick();
	}
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	if(Me.IsShowWindow())
	{
		OnExChange_ButtonClick();
	}
}

function OnClickItem(string strID, int Index)
{
	if(strID == "MultisellTabTotalWnd_ItemWindow")
	{
		updateMultiSellData();
		MultisellTabTotalWnd_ListCtrl.SetSelectedIndex(Index, true);
		Me.KillTimer(TIMER_UPDATE_ID);
		updateUIControl();
	}
	else if(strID == "MultisellTabEnableWnd_ItemWindow")
	{
		updateMultiSellData();
		MultisellTabEnableWnd_ListCtrl.SetSelectedIndex(Index, true);
		Me.KillTimer(TIMER_UPDATE_ID);
		updateUIControl();
	}
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "MultisellTabTotalWnd_ListCtrl":
			updateMultiSellData();
			MultisellTabTotalWnd_ItemWindow.SetSelectedNum(MultisellTabTotalWnd_ListCtrl.GetSelectedIndex());
			Me.KillTimer(TIMER_UPDATE_ID);
			updateUIControl();
			break;
		case "MultisellTabEnableWnd_ListCtrl":
			updateMultiSellData();
			MultisellTabEnableWnd_ItemWindow.SetSelectedNum(MultisellTabEnableWnd_ListCtrl.GetSelectedIndex());
			Me.KillTimer(TIMER_UPDATE_ID);
			updateUIControl();
			break;
	}
}

function OnClickButton(string Name)
{
	// Debug("Name" @Name);
	switch(Name)
	{
		case "InventoryViewerCall_Button":
			//toggleWindow("InventoryViewer");
			//Me.SetFocus();
			getInstanceInventoryViewer().showWindowByParentWindow(Me, true);
			break;
		case "Search_Button":
			OnSearch_ButtonClick();
			break;
		// 검색 초기화
		case "Refrash_Button":
			OnRefrash_ButtonClick();
			break;
		// 교환
		case "ExChange_Button":
			OnExChange_ButtonClick();
			break;
		case "Close_Button":
			OnClose_ButtonClick();
			break;
		case "IconTabIcon_Button":
		case "ListTabIcon_Button":
			toggleListWithIconWindow();
			break;
		case "MultiSell_Input_Button_2":
			updateMultiSellData();
			OnPriceEditBtnHandler();
			break;
		case "MultiSellTab0":
			MultiSellTab.SetTopOrder(0, true);
			disableWindowWithText(false, "");

			if((Search_EditBox.GetString() == "") && MultisellTabTotalWnd_ItemWindow.GetItemNum() != m_MultiSellInfoList.Length)
			{
				bForceUpdate = true;
			}
			else
			{
				bForceUpdate = false;
			}
			ShowItemList();
			updateUIControl();
			break;
		// 교환 가능
		case "MultiSellTab1":
			MultiSellTab.SetTopOrder(1, true);
			disableWindowWithText(false, "");
			bForceUpdate = false;
			ShowItemList();
			updateUIControl();
			break;
	}
}

// 교환 버튼 클릭
function OnExChange_ButtonClick()
{
	local int i, SelectedIndex, inputItemLen;
	local INT64 ItemNum;
	local ItemInfo rItemInfo, inputItemInfo;
	local bool hasEItemcheck;

	if(getCurrentSelectedItemInfo(rItemInfo))
	{
		SelectedIndex = rItemInfo.Reserved;
		ItemNum = int64(ItemCount_EditBox.GetString());
		inputItemLen = m_MultiSellInfoList[SelectedIndex].InputItemInfoList.Length;

		//--------------------------------------------------------------
		// 필요 아이템이 무기, 방어구, 악세사리가 포함되어 있다면..  이걸 사용 안하고, 멀티셀그룹 아이디로 구분 하기로 함.
		for(i = 0; i < inputItemLen; i++)
		{
			inputItemInfo = m_MultiSellInfoList[SelectedIndex].InputItemInfoList[i];

			// 필요 아이템에 무기, 방어구, 악세사리가 포함되어 있다면.. 
			//if(nKeepEnchant != 1 ||
			if(inputItemInfo.ItemType == EItemType.ITEM_WEAPON || inputItemInfo.ItemType == EItemType.ITEM_ARMOR || inputItemInfo.ItemType == EItemType.ITEM_ACCESSARY)
			{
				// Debug("m_MultiSellInfoList[selectedIndex].InputItemInfoList[i].ItemType" @inputItemInfo.ItemType);
				// Debug("inputItemInfo.Id.ClassID" @inputItemInfo.Id.ClassID);
				// Debug("inputItemInfo.Name" @inputItemInfo.Name);

				// 무기 타입이 0인가로 들어와서 이것도 체크..
				// 각종 포인트이 아닌 경우만.. 
				if(isPointType(inputItemInfo) == false)
				{
					// 무기, 방어구, 악세사리를 집혼하려고 할때..
					hasEItemcheck = true;
				}
			}
		}

		// 다이얼로그 메세지 상황에 따라 다르게..
		if(hasEItemcheck)
		{
			dialogMessage = GetSystemMessage(4363); // 인챈트 등 아이템 속성이 날라간다 경고
		}
		else
		{
			switch(ShowType)
			{
				case 0:
					dialogMessage = GetSystemMessage(1383);
					break;
				case 1:
					dialogMessage = GetSystemMessage(13098);
					break;
				case 2:
					dialogMessage = GetSystemMessage(1383);
					break;
			}
		}

		// Debug("dialogMessage" @ dialogMessage);

		if(SelectedIndex >= 0)
		{
			DisableWnd.ShowWindow();
			DisableWnd.SetFocus();
			DialogSetReservedInt(SelectedIndex);
			DialogSetReservedInt2(ItemNum);
			DialogSetID(MULTISELLWND_DIALOG_OK);
			DialogSetCancelD(MULTISELLWND_DIALOG_OK);
			DialogSetString("");
			DialogShow(DialogModalType_Modalless, DialogType_Warning, dialogMessage, string(self));
			m_nSelectedMultiSellInfoIndex = SelectedIndex;
		}
	}
}

/** 개당 판매 가격 입력 계산기 */
function OnPriceEditBtnHandler()
{
	local ItemInfo Info;

	DisableWnd.ShowWindow();
	DisableWnd.SetFocus();
	// Ask price
	DialogSetID(DIALOG_ASK_PRICE);
	DialogSetEditBoxMaxLength(6);
	DialogSetCancelD(DIALOG_ASK_PRICE);
	DialogSetReservedItemID(Info.Id);				// ServerID
	DialogSetEditType("number");
	DialogSetParamInt64(needItemScript.GetMaxNumCanBuy());
	DialogSetDefaultOK();
	// 구매개수를 입력해주세요.
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4362), string(self));
}

// 목록에서 검색
function OnSearch_ButtonClick()
{
	local string searchStr;

	searchStr = Search_EditBox.GetString();

	if(searchStr == "")
	{
		OnRefrash_ButtonClick();
	}
	else
	{
		ShowItemList();
	}
}

// 검색 초기화 버튼
function OnRefrash_ButtonClick()
{
	disableWindowWithText(false, "");
	DisableWnd.HideWindow();
	bForceUpdate = true;
	Search_EditBox.SetString("");
	updateMultiSellData();
	ShowItemList();
	updateUIControl();
}

function OnClose_ButtonClick()
{
	Me.HideWindow();
}

//-----------------------------------------------------------------------------------------------------------
// OnKeyUp
//-----------------------------------------------------------------------------------------------------------
function OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	local string mainKey;

	// 키보드 누름으로 체크
	if(Search_EditBox.IsFocused())
	{
		// 엔터로 검색어 입력 가능 하도록..
		mainKey = class'InputAPI'.static.GetKeyString(nKey);

		if(mainKey == "ENTER")
		{
			ShowItemList();
		}
	}
}

//-----------------------------------------------------------------------------------------------------------
// Tree 구성 , 아이템 정보, 필요 아이템
//-----------------------------------------------------------------------------------------------------------

// 멀티셀 아이템 정보, 필요 아이템 트리, 수량 입력 부분 업데이트
function updateUIControl()
{
	updateItemInfo();
	setTreeNeedItemInfo();
}

// 멀티셀 아이템 정보  업데이트
function updateItemInfo()
{
	local int i, Index;
	local ItemInfo rItemInfo;

	if(getCurrentSelectedItemInfo(rItemInfo))
	{
		Index = rItemInfo.Reserved;

		if(Index <= -1)
		{
			return;
		}
		class'UIAPI_MULTISELLITEMINFO'.static.Clear("MultiSellWnd.multiSellItemInfo");

		if(Index >= 0 && Index < m_MultiSellInfoList.Length)
		{
			for(i = 0; i < m_MultiSellInfoList[Index].OutputItemInfoList.Length; i++)
			{
				class'UIAPI_MULTISELLITEMINFO'.static.SetItemInfo("MultiSellWnd.multiSellItemInfo", i, m_MultiSellInfoList[Index].OutputItemInfoList[i]);

				//***************************************************************************************** 
				// 추후 꼭 빼야 할 부분.
				// 명성치 TTP 69194 는 아이템이 아니기 때문에 아이템 정보 뷰어로 보여 줄수 없다.
				// 그래서 XML과 UI에서 하드코딩으로 텍스트 필드를 넣어서 아이템 정보 뷰어에서 보여 주는 것 처럼 
				// 꾸민 것이다. 
				// 기획쪽(강정원)에서도 빼는 방향으로 한다고 했고 추후 작업을 해야한다
				//*****************************************************************************************
				if(m_MultiSellInfoList[Index].OutputItemInfoList[i].IconName == "icon.pvp_point_i00")
				{
					class'UIAPI_WINDOW'.static.ShowWindow("MultiSellWnd.txtPointItemDescription");
					class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.txtPointItemDescription", GetSystemMessage(2334));
					continue;
				}

				class'UIAPI_WINDOW'.static.HideWindow("MultiSellWnd.PointItemName");
				class'UIAPI_WINDOW'.static.HideWindow("MultiSellWnd.txtPointItemDescription");
				class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.PointItemName", "");
				class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.txtPointItemDescription", "");
			}
		}
	}
}

function int GetIndexArray(int ClassID, out array<NoStackableItemData> NoStackableItemDataArray)
{
	local int i;

	for(i = 0; i < NoStackableItemDataArray.Length; i++)
	{
		if(NoStackableItemDataArray[i].ClassID == ClassID)
		{
			return i;
		}
	}

	return -1;
}

// onlyUNLOCKTYPE : 봉인 안 된 아이템만 검색
// ensoul(룬)장착 에 따른 아이템만 검색 - 2017-10-31(클래식 요청)
function int GetNoStackableItemCountArrayIndex(ItemInfo inputItemInfo, out array<NoStackableItemData> NoStackableItemDataArray)//, optional bool onlyUNLOCKTYPE)
{
	local int arrayIndex, nClassID;
	local INT64 noStackableNeedItemNum;
	local array<ItemInfo> hasItemInfoArray;

	// 수량성 아이템이 아닌..
	if(!IsStackableItem(inputItemInfo.ConsumeType))
	{
		// 아이템의 수량 
		nClassID = inputItemInfo.ID.ClassID;
		//noStackableNeedItemNum = inventoryWndScript.getItemCountByClassID(nClassID);

		hasItemInfoArray = FindItems(nClassID);
		noStackableNeedItemNum = int64(hasItemInfoArray.Length);

		//if(onlyUNLOCKTYPE)noStackableNeedItemNum = util.FindItemByClassID(nClassID, hasItemInfoArray, Util.EItemLockedCheckType.UNLOCK, !numToBool(nShowEnsoul));
		//else  noStackableNeedItemNum =  class'UIDATA_INVENTORY'.static.FindItemByClassID(nClassID, hasItemInfoArray);

		arrayIndex = GetIndexArray(nClassID, NoStackableItemDataArray);

		// 해당 클래스 아이디를 가진 요소가 없다면.. 배열에 추가
		if(arrayIndex == -1)
		{
			NoStackableItemDataArray.Length = NoStackableItemDataArray.Length + 1;

			if(NoStackableItemDataArray.Length > 0)
			{
				NoStackableItemDataArray[NoStackableItemDataArray.Length - 1].ClassID = nClassID;
				NoStackableItemDataArray[NoStackableItemDataArray.Length - 1].Count = noStackableNeedItemNum;
				NoStackableItemDataArray[NoStackableItemDataArray.Length - 1].EnchantLevel = inputItemInfo.Enchanted;

				// 동일 클래스 id를 가진 값이 1개 보다 크면 인챈, 집혼등 이름을 표시 안하기 위한 표기
				//if(noStackableNeedItemNum > 1)NoStackableItemDataArray[NoStackableItemDataArray.Length - 1].bNoEnchantName = true;
			}

			if(arrayIndex == -1)
			{
				arrayIndex = NoStackableItemDataArray.Length - 1;
			}
		}
		else
		{
			// 있다면 1씩 뺀다.
			if(NoStackableItemDataArray[arrayIndex].Count > 0)
			{
				NoStackableItemDataArray[arrayIndex].Count = NoStackableItemDataArray[arrayIndex].Count - 1;
			}
		}
	}

	return arrayIndex;
}

// 필요 아이템 트리 업데이트 
function setTreeNeedItemInfo()
{
	local int i, Index;
	local ItemInfo rItemInfo;

	if(getCurrentSelectedItemInfo(rItemInfo))
	{
		Index = rItemInfo.Reserved;

		// Debug("index--->" @ index);

		// 특정 아이템을 선택되지 않았다.
		if(Index <= -1)
		{
			return;
		}
		needItemScript.CleariObjects();
		needItemScript.StartNeedItemList(4);

		if(Index >= 0 && Index < m_MultiSellInfoList.Length)
		{
			for(i = 0; i < m_MultiSellInfoList[Index].InputItemInfoList.Length ; i++)
			{
				if(isPointType(m_MultiSellInfoList[Index].InputItemInfoList[i]))
				{
					needItemScript.AddNeedPoint(m_MultiSellInfoList[Index].InputItemInfoList[i].Name, m_MultiSellInfoList[Index].InputItemInfoList[i].IconName, m_MultiSellInfoList[Index].InputItemInfoList[i].ItemNum, getHasItemOrPointCount(m_MultiSellInfoList[Index].InputItemInfoList[i]));
					continue;
				}
				needItemScript.AddNeeItemInfo(m_MultiSellInfoList[Index].InputItemInfoList[i], m_MultiSellInfoList[Index].InputItemInfoList[i].ItemNum, getHasItemOrPointCount(m_MultiSellInfoList[Index].InputItemInfoList[i]));
			}
		}

		if(needItemScript.GetMaxNumCanBuy() > 0)
		{
			inputItemScript.SetCount(1);
		}
		else
		{
			inputItemScript.SetCount(0);
		}

		itemCountTextEditEnable(true);

		// 목록에 비수량성 아이템이면 1개씩만 구매 가능하도록..
		if(!IsStackableItem(rItemInfo.ConsumeType))
		{
			itemCountTextEditEnable(false);
		}

		if((Index >= 0) && Index < m_MultiSellInfoList.Length)
		{
			for(i = 0; i < m_MultiSellInfoList[Index].InputItemInfoList.Length; i++)
			{
				if((IsStackableItem(m_MultiSellInfoList[Index].InputItemInfoList[i].ConsumeType) == false) && (isPointType(m_MultiSellInfoList[Index].InputItemInfoList[i])) == false)
				{
					itemCountTextEditEnable(false);
				}
			}
		}
	}
}

// 특수 포인트 타입인가? 인벤토리에 없는..
function bool isPointType(ItemInfo Info)
{
	local bool RValue;

	// MSIT_PCCAFE_POINT
	if(Info.IconName == GetPcCafeItemIconPackageName())
	{
		RValue = true;
	}
	// MSIT_PLEDGE_POINT
	else if(Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00")
	{
		RValue = true;
	}
	// MSIT_PVP_POINT
	else if(Info.IconName == "icon.pvp_point_i00")
	{
		RValue = true;
	}
	// MSIT_RAID_POINT
	else if(Info.IconName == "icon.etc_i.etc_rp_point_i00")
	{
		RValue = true;
	}
	else if(Info.IconName == "Icon.etc_i.craft_point")
	{
		RValue = true;
	}
	else if(Info.IconName == "icon.etc_sayha_point_01")
	{
		RValue = true;
	}
	Debug("Info.IconName " @ Info.IconName);
	return RValue;
}

// 가지고 있는 아이템, 또는 포인트 카운트
function INT64 getHasItemOrPointCount(ItemInfo Info)
{
	local INT64 hasNum;
	local array<ItemInfo> itemInfoArray;
	local int itemCount;

	// MSIT_PCCAFE_POINT 
	if(Info.IconName == GetPcCafeItemIconPackageName())
	{
		hasNum = mData.PcCafePoint;
	}
	// MSIT_PLEDGE_POINT
	else if(Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00")
	{
		hasNum = mData.clanPoint;
	}
	// MSIT_PVP_POINT
	else if(Info.IconName == "icon.pvp_point_i00")
	{
		hasNum = mData.PvPPoint;
	}
	// MSIT_RAID_POINT
	else if(Info.IconName == "icon.etc_i.etc_rp_point_i00")
	{
		hasNum = mData.RaidPoint;
	}
	// 인벤토리에 있나
	else if(Info.IconName == "Icon.etc_i.craft_point")
	{
		hasNum = mData.craftPoint;
	}
	else if(Info.IconName == "icon.etc_sayha_point_01")
	{
		hasNum = mData.vitalityPoint;
	}
	else
	{
		// 아이템이 인벤에 있나? classID 로 비교
		itemInfoArray = FindItems(Info.Id.ClassID);
		itemCount = itemInfoArray.Length;

		if(itemCount > 0)
		{
			hasNum = itemInfoArray[0].ItemNum;
		}
	}

	return hasNum;
}

// 수량 입력 에디터 , 활성 비활성
function itemCountTextEditEnable(bool bEnable)
{
	if(bEnable)
	{
		MultiSell_Input_Button.EnableWindow();
	}
	else
	{
		MultiSell_Input_Button.DisableWindow();
	}
}

//----------------------------------------------------------------------------------------------------------------------------------
// 전용 util
//----------------------------------------------------------------------------------------------------------------------------------

// 현재 선택되어 있는 아이템 정보을 리턴한다.
function bool getCurrentSelectedItemInfo(out ItemInfo rItemInfo)
{
	local bool bFlag;

	// 전체 탭
	if(MultiSellTab.GetTopIndex() == 0)
	{
		bFlag = MultisellTabTotalWnd_ItemWindow.GetSelectedItem(rItemInfo);
	}
	// 교환 가능 탭
	else
	{
		bFlag = MultisellTabEnableWnd_ItemWindow.GetSelectedItem(rItemInfo);
	}
	return bFlag;
}

// 현재 선택되어 있는 아이템 목록의 index 번호를 리턴한다.
function int GetCurrentSelectedIndex()
{
	local int RValue;

	RValue = -1;

	// 전체 탭
	if(MultiSellTab.GetTopIndex() == 0)
	{
		RValue = MultisellTabTotalWnd_ItemWindow.GetSelectedNum();
	}
	// 교환 가능 탭
	else
	{
		RValue = MultisellTabEnableWnd_ItemWindow.GetSelectedNum();
	}

	// Debug("버튼 " @ rValue);
	return RValue;
}

// 구매 완료 후 다시 선택되도록 하는 용도로 사용
function setSelectItem(ItemInfo Info)
{
	local int lastSelectedIndex, N;
	local ItemInfo tempInfo;

	lastSelectedIndex = Info.Reserved;
	
	// 전체 목록은 목록을 유지 해서 필요 없고, 교환가능 목록만 검색해서 찾는다.
	// 아이템 정보가 동일한게 있는 경우도 있어서, Reserved 값으로 전체 index 고유 값으로 찾아서 이동하게
	// 만들었다.

	if(Info.Name == "")
	{
		return;
	}
	//Debug(" 선택 복원" @ Info.Name);

	// 전체 탭 
	if(MultiSellTab.GetTopIndex() == 0)
	{
		// 전체 목록
		for(N = 0; n < MultisellTabTotalWnd_ItemWindow.GetItemNum(); N++)
		{
			MultisellTabTotalWnd_ItemWindow.GetItem(N, tempInfo);

			if(tempInfo.Reserved == lastSelectedIndex)
			{
				MultisellTabTotalWnd_ItemWindow.SetSelectedNum(N);
				MultisellTabTotalWnd_ListCtrl.SetSelectedIndex(N, true);
				break;
			}
		}
	}
	// 교환 가능 탭
	else
	{
		// 교환 가능 목록
		for(N = 0; N < MultisellTabEnableWnd_ItemWindow.GetItemNum(); N++)
		{
			MultisellTabEnableWnd_ItemWindow.GetItem(N, tempInfo);

			if(tempInfo.Reserved == lastSelectedIndex)
			{
				MultisellTabEnableWnd_ItemWindow.SetSelectedNum(N);
				MultisellTabEnableWnd_ListCtrl.SetSelectedIndex(N, true);
				break;
			}
		}
	}
}

//-----------------------------------------------------------------------------------------------------------
// UTIL
//-----------------------------------------------------------------------------------------------------------

// 문자열 검색 
function int findMatchString(string targetStr, string a_Param)
{
	local array<string> modifiedParamArr;
	local int i;
	local string delim, modifiedString;
	local int _inStr;
	local string strTemp1, strTemp2;

	modifiedString = Substitute(targetStr, " ", "", false);
	delim = " ";
	_inStr = InStr(a_Param, delim);

	while(_inStr > -1)
	{
		modifiedParamArr.Insert(modifiedParamArr.Length, 1);
		modifiedParamArr[modifiedParamArr.Length - 1] = Left(a_Param, _inStr);
		a_Param = Mid(a_Param, _inStr + 1);
		_inStr = InStr(a_Param, delim);
	}

	modifiedParamArr.Insert(modifiedParamArr.Length, 1);
	modifiedParamArr[modifiedParamArr.Length - 1] = a_Param;

	for(i = 0; i < modifiedParamArr.Length; i++)
	{
		strTemp1 = Caps(modifiedString);
		strTemp2 = Caps(modifiedParamArr[i]);

		if(InStr(strTemp1, strTemp2) == -1 && modifiedParamArr[i] != " ")
		{
			return -1;
		}
	}

	return 1;
}

// 신규 집혼 관련 데이타 추가
function addEnsoulInfo(int slotType, int slotCount, string param, out ItemInfo info)
{
	local int n, nEOptionID;

	for(n = EISI_START; n < slotCount + EISI_START; n++)
	{
		ParseInt(param, "EnsoulOptionID_" $ slotType $ "_" $ n, nEOptionID);
		Info.EnsoulOption[slotType - 1].OptionArray[n - EISI_START] = nEOptionID;
	}
}

function array<ItemInfo> FindItems(int ClassID)
{
	toFindClassID = ClassID;
	GetObjectFindItemByCompare().DelegateCompare = Compare;
	return GetObjectFindItemByCompare().GetAllItemByCompare();
}

function array<ItemInfo> FilterBlessedItems(array<ItemInfo> infos, bool IsBlessedItem)
{
	local int i;
	local array<ItemInfo> iInfos;

	for(i = 0; i < infos.Length; i++)
	{
		if(infos[i].IsBlessedItem == IsBlessedItem)
		{
			iInfos[iInfos.Length] = infos[i];
		}
	}
	return iInfos;
}

function bool Compare(ItemInfo iInfo)
{
	local bool bUseExceptionEnsoul;

	if(toFindClassID != iInfo.Id.ClassID)
	{
		return false;
	}
	bUseExceptionEnsoul = !numToBool(nShowEnsoul);

	if(iInfo.bSecurityLock)
	{
		return false;
	}

	if(bUseExceptionEnsoul)
	{
		if(getInstanceL2Util().hasEnsoulOption(iInfo))
		{
			return false;
		}
	}
	return true;
}

function OnESCKey()
{
	if(MultiSellTab.GetTopIndex() == 0)
	{
		MultisellTabTotalWnd.SetFocus();
	}
	else
	{
		MultisellTabEnableWnd.SetFocus();
	}
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
	m_WindowName="MultiSellWnd"
}
