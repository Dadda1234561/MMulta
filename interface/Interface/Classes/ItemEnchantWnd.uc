class ItemEnchantWnd extends UICommonAPI;

const STATE_NONE = 'stateNone';
const STATE_READY_SCROLL = 'stateReadyScroll';
const STATE_READY_EQUIPMENT = 'stateReadyEquipment';
const STATE_READY_SUPPORT = 'stateReadySupport';
const STATE_READY_SUPPORT_SYSTEM = 'stateReadySupportsystem';
const STATE_READY_SUPPORT_STONE = 'stateReadySupportstone';
const STATE_ENCHANT = 'stateEnchant';
const STATE_COMPLETE_BLIND = 'stateCompleteBlind';
const STATE_COMPLETE_RESULT = 'stateCompleteResult';
const STATE_COMPLETE_RESULT_FAIL = 'stateCompleteResultfail';
const PERMRIAD = 100f;

struct failchallangePointInfoStruct
{
	var int gropuID;
	var int point;
	var int rewardPnt;
};

var ButtonHandle EnchantBtn;
var ButtonHandle EnchantBtnAuto;
var ButtonHandle resetBtn;
var TextBoxHandle WarningTxt00;
var TextBoxHandle WarningTxt01;
var TextBoxHandle InstructionTxt;
var ItemWindowHandle scrollItemWindow;
var ItemWindowHandle equipmentItemWindow;
var ItemWindowHandle supportItemWindow;
var AnimTextureHandle ResultSlotani_Tex;

// °б°ъ ЅЅ·Ф 
var ItemWindowHandle EnchantedItemSlot;
var WindowHandle supportItemListWnd;
var ItemWindowHandle supportItemWnds;
var WindowHandle supportSystemListWnd;
var TextureHandle supportSystemActiveImage;
var RichListCtrlHandle supportSystemList;
var ItemInfo requestedItemInfoScroll;
var ItemInfo requestedItemInfoEquipment;
var ItemInfo requestedItemInfoSupport;
var int64 mEnchantItemType;
var EffectViewportWndHandle EnchantEffectViewport;
var ItemWindowHandle InventoryItem;
var L2UITimerObject timerObject;
var array<UIPacket._EnchantChallengePointInfo> vCurrentPointInfo;
var bool bIsShopping;
var bool bUsedTicket;
var EnchantScrollSetUIData enchantScrollData;
var bool isGreateSuccess;
var bool bWaitTargetItem;
var ItemEnchantGroupIDWnd groupIDWndScr;
var name PrevState;
var name resultState;
var int SelectedSystemSupport;
var failchallangePointInfoStruct failChallangePointInfo;
var private bool isAutoEnchanting;
var private bool isAutoEnchantingStop;
var TextBoxHandle scrollItemNum;

function HandleClickButtonEnchant()
{}

function HandleClickButtonReset()
{}

private function bool CanUseAutoMode()
{
	local EEtcItemType Type;

	Type = EEtcItemType(GetIteminfoScroll().EtcItemType);
	switch(Type)
	{
		case EEtcItemType.ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM/*32*/:
		case EEtcItemType.ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP/*33*/:
		case EEtcItemType.ITEME_ANCIENT_CRYSTAL_ENCHANT_AG/*66*/:
			return true;
	}
	return false;
}

private function SetAutoMode()
{
	EnchantBtn.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "BottomCenter", "BottomCenter", 85, -7);
	EnchantBtnAuto.SetNameText(GetSystemString(14237));
	EnchantBtnAuto.EnableWindow();
	EnchantBtnAuto.ShowWindow();
}

private function SetNormalMode()
{
	EnchantBtn.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "BottomCenter", "BottomCenter", 0, -7);
	EnchantBtnAuto.HideWindow();
}

static function ItemEnchantWnd Inst()
{
	return ItemEnchantWnd(GetScript("ItemEnchantWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(EV_Die); // 50
	RegisterEvent(EV_EnchantShow); //2860
	RegisterEvent(EV_EnchantHide); //2865
	RegisterEvent(EV_EnchantResult); //2870
	RegisterEvent(EV_EnchantPutTargetItemResult); //2880
	RegisterEvent(EV_EnchantPutSupportItemResult);//2881
	RegisterEvent(EV_EnchantPutScrollItemResult); //2882
	RegisterEvent(EV_EnchantRemoveSupportItemResult);//2883
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_ENCHANT_CHALLENGE_POINT_INFO));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_RESET_ENCHANT_CHALLENGE_POINT));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_SET_ENCHANT_CHALLENGE_POINT));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_RES_ENCHANT_ITEM_FAIL_REWARD_INFO));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST));
}

event OnLoad()
{
	scrollItemWindow = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".scrollItemWnd.itemSlot");
	equipmentItemWindow = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".equipmentItemWnd.itemSlot");
	supportItemWindow = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemWnd.itemSlotSupport");
	supportItemWnds = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemListWnd.supportItemWnds");
	supportItemListWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemListWnd");
	supportSystemActiveImage = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd.ActiveImage");
	supportSystemListWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd");
	supportSystemList = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.supportSystemList");
	EnchantBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantBtn");
	EnchantBtnAuto = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantBtnAuto");
	resetBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResetBtn");
	EnchantedItemSlot = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.EnchantedItemSlot");
	InstructionTxt = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".InstructionTxt");
	WarningTxt00 = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WarningTxt00");
	WarningTxt01 = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WarningTxt01");
	scrollItemNum = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".scrollItemNum");
	EnchantEffectViewport = GetEffectViewportWndHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectViewport");
	EnchantEffectViewport.SetCameraPitch(0);
	EnchantEffectViewport.SetCameraYaw(0);
	InventoryItem = GetItemWindowHandle("InventoryWnd.InventoryItem");
	timerObject = class'L2UITimer'.static.Inst()._AddNewTimerObject();
	SetGrouIDWnd();
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.FailGetItme_RichList").SetSelectedSelTooltip(false);
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.FailGetItme_RichList").SetAppearTooltipAtMouseX(true);
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.FailGetItme_RichList").SetSelectable(false);
	SetClosingOnESC();
}

function SetGrouIDWnd()
{
	Debug("--- SetGrouIDWnd ---- " @ string(GetWindowHandle("GroupIDWnd_ItmeEnchantWnd").m_pTargetWnd == none));
	groupIDWndScr = ItemEnchantGroupIDWnd(GetScript("GroupIDWnd_ItmeEnchantWnd"));
	groupIDWndScr._Init();
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	m_hOwnerWnd.SetFocus();
	WarningTxt00.SetText("");
	WarningTxt01.SetText("");
	
	// ·№ЅГЗЗё¦ »зїлЗТ °НАОБцё¦ №°А» ¶§
	// ѕЖАМЕЫ»зїл ЅГ БцБ¤µИ ЖЛѕчёЮЅГБцё¦ ¶зїп ¶§
	// ѕЖАМЕЫА» №ЩґЪїЎ №цё± ¶§(ЗС°і)
	// ѕЖАМЕЫА» №ЩґЪїЎ №цё± ¶§(ї©·Ї°і, °іјцё¦ №°ѕоє»ґЩ)
	// ѕЖАМЕЫА» №ЩґЪїЎ №цё± ¶§(MoveAll »уЕВАП ¶§)
	// ѕЖАМЕЫА» ИЮБцЕлїЎ №цё± ¶§(ЗС°і)
	// ѕЖАМЕЫА» ИЮБцЕлїЎ №цё± ¶§(MoveAll »уЕВАП ¶§)
	// ѕЖАМЕЫА» ИЮБцЕлїЎ №цё± ¶§(ї©·Ї°і, °іјцё¦ №°ѕоє»ґЩ)
	// ѕЖАМЕЫА» °бБ¤И­ ЗТ¶§
	// °бБ¤И­°Ў єТ°ЎґЙЗПґЩґВ °ж°н
	// ЖкАОєҐїЎј­ ѕЖАМЕЫАМ µе·УµЗѕъА» ¶§

	// ЗШґз id·О ї­ё° ґЩАМѕу·О±Ч №ЪЅє°Ў АОГ¦Ж® ГўА» ї­ѕъА»¶§ ї­·Б АЦґЩёй..
	// QA їдГ» »зЗЧ : QA ±иИЇјц їдГ»
	switch(DialogGetID())
	{
		case 1111:
		case 2222:
		case 3333:
		case 4444:
		case 5555:
		case 6666:
		case 7777:
		case 8888:
		case 9998:
		case 9999:
		case 10000:
			DialogHide();
			break;
	}
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMultiEnchantWndTap_Btn").EnableWindow();
	GetEffectViewportWndHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".MainBgEffectViewport").SpawnEffect("LineageEffect2.ui_Enchant_bg");
	groupIDWndScr._CheckShowHide();
	ChkWindowSizeGroupID();
	m_hOwnerWnd.SetWindowSize(858, 542);
	PlaySound("Itemsound3.ui_enchant_open");
}

function ChkWindowSizeGroupID()
{
	if(groupIDWndScr.m_hOwnerWnd.IsShowWindow())
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Point_txt").SetText(GetSystemString(14016));
	}
	else
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Point_txt").SetText(GetSystemString(14015));
	}
}

event OnHide()
{
	NoticeWnd(GetScript("NoticeWnd"))._CreateCollectionButtonBlind();
	isAutoEnchanting = false;
	isAutoEnchantingStop = false;

	if(DialogIsMine())
	{
		DialogHide();
	}
	API_RequestExCancelEnchantItem();
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "EnchantBtnAuto":
			if(GetStateName() == 'stateEnchant')
			{
				HandleClickButtonEnchant();
			}
			else
			{
				HandleShowDialogAuto();
			}
			break;
		case "EnchantBtn":
			isAutoEnchanting = false;
			scrollItemNum.HideWindow();
			HandleClickButtonEnchant();
			break;
		case "ResetBtn":
			if(class'UICommonAPI'.static.DialogIsOwnedBy(string(self)))
			{
				DialogHide();
			}
			API_RequestExCancelEnchantItem();
			GotoState(STATE_READY_SCROLL);
			break;
		case "StoneActivBtn":
			ToggleSupportItemListWnd();
			break;
		case "SystemActivBtn":
		case "Close_Btn":
			ToggleSupportSystemListWndWnd();
			break;
		case "SystemActivBtnPoint":
			API_C_EX_SET_ENCHANT_CHALLENGE_POINT(false);
			break;
		case "SystemActivBtnTicket":
			API_C_EX_SET_ENCHANT_CHALLENGE_POINT(true);
			break;
		case "SystemResetBtn":
			API_C_EX_RESET_ENCHANT_CHALLENGE_POINT();
			break;
		case "EnchantEffect_BTN":
			ToggleEnchantEffectItem_Wnd();
			break;
		case "ItemMultiEnchantWndTap_Btn":
			SwapMultiEnchantWnd();
			break;
		case "PointBtn":
			groupIDWndScr._ToggleShowHide();
			ChkWindowSizeGroupID();
			break;
		case "WndClose_BTN":
			m_hOwnerWnd.HideWindow();
			break;
		case "Refresh_btn":
			SetSupportSystemList();
			break;
	}
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData Record;

	supportSystemList.GetSelectedRec(Record);
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.SystemActivBtnPoint").EnableWindow();

	if((Record.cellDataList[3].nReserved1 <= (GetCurrentPoint())) && Record.nReserved2 == 1)
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.SystemActivBtnPoint").EnableWindow();
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.SystemActivBtnPoint").DisableWindow();
	}

	if((Record.cellDataList[4].nReserved1 > 0) && Record.nReserved2 == 1)
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.SystemActivBtnTicket").EnableWindow();
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.SystemActivBtnTicket").DisableWindow();
	}
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_Die:
			m_hOwnerWnd.HideWindow();
			break;
		case EV_EnchantShow:
			if(! bIsShopping)
			{
				GotoState(STATE_NONE);
				HandleEnchantShow(param);
			}
			else
			{
				API_RequestExCancelEnchantItem();
			}
			break;
		case EV_EnchantResult:
			HandleEnchantResult(param);
			break;
		case EV_EnchantPutTargetItemResult:
			HandlePutTargetItemResult(param);
			break;
		case EV_EnchantPutSupportItemResult:
			HandlePutSupportItemResult(param);
			break;
		case EV_EnchantRemoveSupportItemResult:
			HandleRemoveSupportItemResult(param);
			break;
		case EV_EnchantPutScrollItemResult:
			HandlePutScrollResult(param);
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_ENCHANT_CHALLENGE_POINT_INFO):
			Handle_S_EX_ENCHANT_CHALLENGE_POINT_INFO();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_RESET_ENCHANT_CHALLENGE_POINT):
			Handle_S_EX_RESET_ENCHANT_CHALLENGE_POINT();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_SET_ENCHANT_CHALLENGE_POINT):
			Handle_S_EX_SET_ENCHANT_CHALLENGE_POINT();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_RES_ENCHANT_ITEM_FAIL_REWARD_INFO):
			Handle_S_EX_RES_ENCHANT_ITEM_FAIL_REWARD_INFO();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST):
			if(m_hOwnerWnd.IsShowWindow())
			{
				Handle_S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST();
			}
	}
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo a_itemInfo;

	switch(ControlName)
	{
		case "itemSlotSupport":
			API_RequestExRemoveEnchantSupportItem();
			break;
		case "supportItemWnds":
			supportItemWnds.GetItem(Index, a_itemInfo);
			API_RequestExTryToPutEnchantSupportItem(a_itemInfo);
			break;
	}
}

event OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	Debug("OnDropItem " @ a_WindowID);

	switch(a_itemInfo.DragSrcName)
	{
		case "supportItemWnds":
			API_RequestExTryToPutEnchantSupportItem(a_itemInfo);
			break;
		case "itemEnchantSubWndItemWnd":
			RequestInputItemInfo(a_itemInfo);
			break;

		default:
			RequestInputItemInfo(a_itemInfo);
			break;
	}
}

event OnDropItemSource(string strTarget, ItemInfo Info)
{
	if(strTarget == "Console" || GetStateName() == STATE_READY_SUPPORT_STONE)
	{
		switch(Info.DragSrcName)
		{
			case "itemSlotSupport":
				API_RequestExRemoveEnchantSupportItem();
				break;
		}
	}
}

function RequestInputItemInfo(ItemInfo iInfo)
{
	switch(GetStateName())
	{
		case STATE_READY_SCROLL:
			Debug("OnDropItem std scroll ");
			API_RequestExAddEnchantScrollItem(iInfo);
			break;
		case STATE_READY_EQUIPMENT:
		case STATE_READY_SUPPORT:
		case STATE_READY_SUPPORT_STONE:
		case STATE_READY_SUPPORT_SYSTEM:
			Debug("OnDropItem stp support");
			API_RequestExTryToPutEnchantTargetItem(iInfo);
			break;
	}
}

function HandleShowDialogAuto()
{
	local ItemInfo iInfo;

	iInfo = GetIteminfoScroll();
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(13787), iInfo.Name, MakeCostStringINT64(iInfo.ItemNum)), string(self), 340);
	class'DialogBox'.static.Inst().AnchorToOwner(0, 200);
	class'DialogBox'.static.Inst().DelegateOnCancel = DialogResultCancel;
	class'DialogBox'.static.Inst().DelegateOnOK = DialogResultOKAuto;
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	class'ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.HideWindow();	
}

function HandleShowDialog()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetFailString() $ "\\n\\n" $ GetSystemString(2336), string(self), 340);
	class'DialogBox'.static.Inst().AnchorToOwner(0, 200);
	class'DialogBox'.static.Inst().DelegateOnCancel = DialogResultCancel;
	class'DialogBox'.static.Inst().DelegateOnOK = DialogResultOK;
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	class'ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.HideWindow();
}

function DialogResultOKAuto()
{
	isAutoEnchanting = true;
	scrollItemNum.SetText((GetSystemString(5027) @ ":") @ MakeCostStringINT64(requestedItemInfoScroll.ItemNum));
	HandleClickButtonEnchant();
}

function DialogResultOK()
{
	GotoState(STATE_ENCHANT);
}

function DialogResultCancel()
{
	m_hOwnerWnd.SetFocus();
	resetBtn.EnableWindow();
	EnchantBtn.EnableWindow();
	EnchantBtnAuto.EnableWindow();
	isAutoEnchanting = false;
	class'ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
}

// ѕЖ°ЎЅГїВ јєАе ЅєЕ©·С »уЕВАО°Ў?
function bool IsAGScrollType()
{
	local EEtcItemType Type;

	Type = EEtcItemType(GetIteminfoScroll().EtcItemType);
	return Type == ITEME_ENCHT_AG || Type == ITEME_BLESS_ENCHT_AG || Type == ITEME_MULTI_ENCHT_AG || Type == ITEME_ANCIENT_CRYSTAL_ENCHANT_AG;
}

function SetTitleByItemType()
{
	// ѕЖ°ЎЅГїВ °ь·Г 
	// ѕЖ°ЎЅГїВ °­И­ БЦ№®ј­, Гає№№ЮАє ѕЖ°ЎЅГїВ °­И­, °ЕАОАЗ ѕЖ°ЎЅГїВ °­И­ БЦ№®ј­
	if(IsAGScrollType())
	{
		setWindowTitleByString(GetSystemString(3639));
	}
	else
	{
		setWindowTitleByString(GetSystemString(1220));
	}
}

function HandleInstructionTxt()
{
	switch(GetStateName())
	{
		case STATE_READY_EQUIPMENT:
			if(IsAGScrollType())
			{
				InstructionTxt.SetText(GetSystemMessage(4504));
			}
			else
			{
				InstructionTxt.SetText(GetSystemMessage(2339));
			}
			break;
		case STATE_READY_SUPPORT:
		case STATE_READY_SUPPORT_SYSTEM:
		case STATE_READY_SUPPORT_STONE:
			if(IsAGScrollType())
			{
				if(EEtcItemType(GetIteminfoScroll().EtcItemType) == ITEME_BLESS_ENCHT_AG)
				{
					InstructionTxt.SetText(GetSystemMessage(4508));
				}
				else
				{
					InstructionTxt.SetText(GetSystemMessage(4505));
				}
			}
			else
			{
				if(CanUseAutoMode())
				{
					InstructionTxt.SetText(GetSystemString(14239));
				}
				else
				{
					InstructionTxt.SetText(GetSystemString(13930));
				}
			}
			break;
		case STATE_ENCHANT:
			InstructionTxt.SetText(GetSystemString(13931));
			break;
		case STATE_COMPLETE_BLIND:
		case STATE_COMPLETE_RESULT:
		case STATE_COMPLETE_RESULT_FAIL:
			InstructionTxt.SetText(GetSystemString(13932));
			break;
	}
}

function CheckWarningTxt()
{
	WarningTxt00.SetText(GetSuccessString());
	WarningTxt01.SetText(GetFailString());
}

function string GetSuccessString()
{
	local int ramdonV;
	local EEtcItemType EEtcItemType;
	local string successString, randomstring;

	EEtcItemType = EEtcItemType(GetIteminfoScroll().EtcItemType);
	ramdonV = GetRandomValue();

	if(ramdonV > 1)
	{
		randomstring = "1~" $ string(ramdonV);
	}
	else
	{
		randomstring = "1";
	}

	if(EEtcItemType == ITEME_CURSED_ENCHANT_WP || EEtcItemType == ITEME_CURSED_ENCHANT_AM)
	{
		successString = MakeFullSystemMsg(GetSystemMessage(13630), randomstring);
	}
	else
	{
		successString = MakeFullSystemMsg(GetSystemMessage(13629), randomstring);
	}
	return successString;
}

function string GetFailStringNormal()
{
	local int i;
	local string crashString;
	local array<string> crashStrings;

	if(IsBreakable())
	{
		if(IsFailureCrush())
		{
			crashStrings[crashStrings.Length] = GetSystemString(3338);
		}

		if(IsFailureMaintain())
		{
			crashStrings[crashStrings.Length] = GetSystemString(2275);
		}

		if(crashStrings.Length == 0 && GetFailureDecrease() == 0)
		{
			crashString = MakeFullSystemMsg(GetSystemMessage(13626), GetSystemString(479));	
		}
		else
		{
			crashString = crashStrings[0];

			for(i = 1; i < crashStrings.Length; i++)
			{
				crashString = crashString $ "," @ crashStrings[i];
			}

			if(GetFailureDecrease() == 0)
			{
				crashString = MakeFullSystemMsg(GetSystemMessage(13626), crashString);
			}
			else if(crashString == "")
			{
				crashString = MakeFullSystemMsg(GetSystemMessage(13627), string(GetFailureDecrease()));
			}
			else
			{
				crashString = MakeFullSystemMsg(GetSystemMessage(13628), crashString, string(GetFailureDecrease()));
			}
		}
	}
	return crashString;
}

function string GetFailString()
{
	local int Prob;
	local string crashString;
	local RichListCtrlRowData Record;

	switch(GetStateName())
	{
		case STATE_READY_SUPPORT:
			crashString = GetFailStringNormal();
			break;
		case STATE_READY_SUPPORT_STONE:
			Debug(" 13650 스톤 경고 표시 ");
			crashString = GetSystemMessage(13650);
			break;
		case STATE_READY_SUPPORT_SYSTEM:
			if(SelectedSystemSupport > -1)
			{
				supportSystemList.GetRec(SelectedSystemSupport, Record);
				Prob = Record.cellDataList[1].nReserved1;
				Debug((" 실패 수치 " @ string(Record.nReserved1)) @ string(Prob));

				if(Prob < 100)
				{
					switch(Record.nReserved1)
					{
						case 3:
							crashString = MakeFullSystemMsg(GetSystemMessage(13651), string(Prob));
							break;
						case 4:
							crashString = MakeFullSystemMsg(GetSystemMessage(13652), string(Prob));
							break;
						case 5:
							crashString = MakeFullSystemMsg(GetSystemMessage(13653), string(Prob));
							break;
						default:
							crashString = GetFailStringNormal();
							break;
					}
				}
				else
				{
					switch(Record.nReserved1)
					{
						case 3:
							crashString = MakeFullSystemMsg(GetSystemMessage(13626), GetSystemString(479));
							break;
						case 4:
							crashString = MakeFullSystemMsg(GetSystemMessage(13627), "1");
							break;
						case 5:
							crashString = MakeFullSystemMsg(GetSystemMessage(13626), GetSystemString(2275));
							break;

						default:
							crashString = GetFailStringNormal();
							break;
					}
				}
			}
			else
			{
				crashString = GetFailStringNormal();
			}
			break;
	}
	return crashString;
}

function HandlePutTargetItemResult(string param)
{
	local int ResultID;

	ParseInt(param, "Result", ResultID);

	if(ResultID == 0)
	{
		GotoState(STATE_READY_EQUIPMENT);
		return;
	}
	InputEquipmentItem();

	if(bWaitTargetItem)
	{
		API_RequestExTryToPutEnchantSupportItem(requestedItemInfoSupport);
	}
}

//ЅєЕ©·С ѕЖАМДЬА» №ЩІЫґЩ.
function HandlePutScrollResult(string param)
{
	local int ResultID;

	ParseInt(param, "Result", ResultID);
	Debug("HandlePutScrollResult" @ param);

	if(ResultID == 0)
	{
		return;
	}
	InputScrollItem();
}

function HandlePutSupportItemResult(string param)
{
	local int ResultID;

	EnchantBtn.EnableWindow();
	ParseInt(param, "Result", ResultID);

	if(ResultID == 0)
	{
		return;
	}
	InputSupportItem();
}

function HandleRemoveSupportItemResult(string param)
{
	supportItemWindow.Clear();
	GotoState(STATE_READY_SUPPORT);
	HandleInstructionTxt();
}

function HandleEnchantShow(string param)
{
	local ItemID cID;
	local array<ItemInfo> iInfos;

	ParseItemID(param, cID);

	if(! class'L2UIInventory'.static.Inst().FindItem(cID, iInfos))
	{
		return;
	}
	requestedItemInfoScroll = iInfos[0];
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	InputScrollItem();
}

function Handle_S_EX_ENCHANT_CHALLENGE_POINT_INFO()
{
	local UIPacket._S_EX_ENCHANT_CHALLENGE_POINT_INFO packet;

	if(! class'UIPacket'.static.Decode_S_EX_ENCHANT_CHALLENGE_POINT_INFO(packet))
	{
		return;
	}
	vCurrentPointInfo = packet.vCurrentPointInfo;
	Debug(" enchant Handle_S_EX_ENCHANT_CHALLENGE_POINT_INFO " @ string(vCurrentPointInfo[0].nPointGroupId) @ string(vCurrentPointInfo[0].nChallengePoint));
}

function Handle_S_EX_RESET_ENCHANT_CHALLENGE_POINT()
{
	local UIPacket._S_EX_RESET_ENCHANT_CHALLENGE_POINT packet;

	if(! class'UIPacket'.static.Decode_S_EX_RESET_ENCHANT_CHALLENGE_POINT(packet))
	{
		return;
	}

	if(packet.bResult == 1)
	{
		SelectedSystemSupport = -1;
		GotoState(STATE_READY_SUPPORT);
	}
}

function Handle_S_EX_SET_ENCHANT_CHALLENGE_POINT()
{
	local UIPacket._S_EX_SET_ENCHANT_CHALLENGE_POINT packet;

	if(! class'UIPacket'.static.Decode_S_EX_SET_ENCHANT_CHALLENGE_POINT(packet))
	{
		return;
	}
	EnchantBtn.EnableWindow();

	if(packet.bResult == 0)
	{
		Debug("Handle_S_EX_SET_ENCHANT_CHALLENGE_POINT 결과가 0으로 들어 온다....");
		return;
	}
	Debug("도전 포인트 사용 여부 확인  " @ string(SelectedSystemSupport));
	InputSupportSystem();
}

function Handle_S_EX_RES_ENCHANT_ITEM_FAIL_REWARD_INFO()
{
	local UIPacket._S_EX_RES_ENCHANT_ITEM_FAIL_REWARD_INFO packet;

	if(! class'UIPacket'.static.Decode_S_EX_RES_ENCHANT_ITEM_FAIL_REWARD_INFO(packet))
	{
		return;
	}
	SetFailItems(packet.nEnchantChallengePointGroupId, packet.nEnchantChallengePoint, packet.vRewardItemList);
}

function Handle_S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST()
{
	local UIPacket._S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST packet;

	if(! class'UIPacket'.static.Decode_S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST(packet))
	{
		return;
	}
	SetEnchantProb(packet.vProbList);
}

function ToggleSupportItemListWnd()
{
	if(supportItemListWnd.IsShowWindow())
	{
		supportItemListWnd.HideWindow();
	}
	else
	{
		supportSystemListWnd.HideWindow();
		supportItemListWnd.ShowWindow();
		SetSupportItemList();
	}
}

function SetSupportItemList()
{
	if(supportItemListWnd.IsShowWindow())
	{
		class'ItemEnchantSubWnd'.static.Inst().SetSupportItems(supportItemWnds);
	}
}

function ToggleSupportSystemListWndWnd()
{
	if(supportSystemListWnd.IsShowWindow())
	{
		supportSystemListWnd.HideWindow();		
	}
	else
	{
		supportItemListWnd.HideWindow();
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.SystemActivBtnPoint").DisableWindow();
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.SystemActivBtnTicket").DisableWindow();
		supportSystemListWnd.ShowWindow();
	}
}

function ToggleEnchantEffectItem_Wnd()
{
	if(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd").IsShowWindow())
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectBTN_Text").SetText(GetSystemString(1797));
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd").HideWindow();		
	}
	else
	{
		supportItemListWnd.HideWindow();
		supportSystemListWnd.HideWindow();
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectBTN_Text").SetText(GetSystemString(646));
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd").ShowWindow();
		SetEnchantEffectItem();
	}
}

function SetEnchantEffectItem()
{
	local HtmlHandle htmlInfo, htmlInfoAfter;
	local ItemInfo iInfo;

	htmlInfo = GetHtmlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.CurrentEffect_Ctrl00");
	htmlInfoAfter = GetHtmlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.CurrentEffect_Ctrl01");
	htmlInfo.Clear();
	htmlInfoAfter.Clear();
	iInfo = GetItemInfoEquipment();
	htmlInfo.LoadHtmlFromString(GetItemInfoHtml(iInfo, false, true));
	switch(EEtcItemType(GetIteminfoScroll().EtcItemType))
	{
		case ITEME_CURSED_ENCHANT_WP:
		case ITEME_CURSED_ENCHANT_AM:
			iInfo.Enchanted = iInfo.Enchanted - 1;
			break;

		default:
			iInfo.Enchanted = iInfo.Enchanted + 1;
			break;
	}
	htmlInfoAfter.LoadHtmlFromString(GetItemInfoHtml(iInfo));
}

function SaveFailChallangePointInfo(int GroupID, int point)
{
	failChallangePointInfo.gropuID = GroupID;
	failChallangePointInfo.point = point;
}

function SetFailItems(int GroupID, int point, array<UIPacket._EnchantRewardItem> rewardItemLits)
{
	local int Index, i;
	local ItemInfo iInfo;
	local string Path, CurrentPath;

	Debug("SetFailItems -- " @ string(GroupID) @ string(point) @ string(rewardItemLits.Length));
	SaveFailChallangePointInfo(GroupID, point);
	Path = m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.FailprdctItem_wnd0";

	if(point > 0)
	{
		class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(class'ItemEnchantGroupIDWnd'.static._GetClassIDPoint(GroupID)), iInfo);
		CurrentPath = (Path $ string(Index)) $ ".";
		GetItemWindowHandle(CurrentPath $ "FailItem_ItemWnd").Clear();
		GetItemWindowHandle(CurrentPath $ "FailItem_ItemWnd").AddItem(iInfo);
		GetTextBoxHandle(CurrentPath $ "FailItemName_txt").SetText(iInfo.Name);
		class'L2Util'.static.SetEllipsisTextBox(GetTextBoxHandle(CurrentPath $ "FailItemName_txt"));
		GetTextBoxHandle(CurrentPath $ "FailItemNum_txt").SetText("x" $ string(point));
		Index++;
	}

	for(i = 0; i < rewardItemLits.Length; i++)
	{
		if(! class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(rewardItemLits[i].nItemClassID), iInfo))
		{
			continue;
		}
		CurrentPath = (Path $ string(Index)) $ ".";
		GetItemWindowHandle(CurrentPath $ "FailItem_ItemWnd").Clear();
		GetItemWindowHandle(CurrentPath $ "FailItem_ItemWnd").AddItem(iInfo);
		GetTextBoxHandle(CurrentPath $ "FailItemName_txt").SetText(iInfo.Name);
		class'L2Util'.static.SetEllipsisTextBox(GetTextBoxHandle(CurrentPath $ "FailItemName_txt"));
		GetTextBoxHandle(CurrentPath $ "FailItemNum_txt").SetText("x" $ string(rewardItemLits[i].nCount));
		Index++;
	}

	for(i = Index; GetWindowHandle(Path $ string(i)).m_pTargetWnd != none; i++)
	{
		CurrentPath = (Path $ string(Index)) $ ".";
		GetItemWindowHandle(CurrentPath $ "FailItem_ItemWnd").Clear();
		GetTextBoxHandle(CurrentPath $ "FailItemName_txt").SetText("");
		GetTextBoxHandle(CurrentPath $ "FailItemNum_txt").SetText("");
		Index++;
	}
}

function DrawItemInfo GetProbDrawItemInfo(string probStr, int Prob)
{
	if(Prob == 0)
	{
		return addDrawItemText(probStr, getInstanceL2Util().Gray, "", true, true);
	}
	return addDrawItemText(probStr, getInstanceL2Util().Yellow, "", true, true);
}

function SetEnchantProb(array<UIPacket._EnchantProbInfo> enchantProbInfo)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local string totlaStringProb;

	switch(EEtcItemType(GetIteminfoScroll().EtcItemType))
	{
		case ITEME_CURSED_ENCHANT_WP:
		case ITEME_CURSED_ENCHANT_AM:
			totlaStringProb = "100%";
			break;

		default:
			totlaStringProb = GetProbString(enchantProbInfo[0].nTotalSuccessProbPermyriad);
			break;
	}
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ProbWnd.probTxt").SetText(totlaStringProb);
	drawListArr[drawListArr.Length] = GetProbDrawItemInfo(GetSystemString(13939) $ ":" @ totlaStringProb, enchantProbInfo[0].nTotalSuccessProbPermyriad);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = GetProbDrawItemInfo(GetSystemString(13940) $ ":" @ (GetProbString(enchantProbInfo[0].nBaseProbPermyriad)), enchantProbInfo[0].nBaseProbPermyriad);
	drawListArr[drawListArr.Length] = GetProbDrawItemInfo(GetSystemString(13941) $ ":" @ (GetProbString(enchantProbInfo[0].nSupportProbPermyriad)), enchantProbInfo[0].nSupportProbPermyriad);
	drawListArr[drawListArr.Length] = GetProbDrawItemInfo(GetSystemString(13942) $ ":" @ (GetProbString(enchantProbInfo[0].nItemSkillProbPermyriad)), enchantProbInfo[0].nItemSkillProbPermyriad);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ProbWnd.probTooltipBtn").SetTooltipCustomType(mCustomTooltip);
}

function bool IsGreateSuccessEffect(int targetEnchant)
{
	if(enchantScrollData.GreatSuccessEffect == -1)
	{
		return false;
	}
	return enchantScrollData.GreatSuccessEffect <= targetEnchant;
}

function bool UseSupportSlot()
{
	if(enchantScrollData.IncBaseMin == -1)
	{
		return false;
	}

	if(enchantScrollData.IncBaseMin > GetItemInfoEquipment().Enchanted)
	{
		return false;
	}

	if(enchantScrollData.IncBaseMax != -1)
	{
		if(GetItemInfoEquipment().Enchanted > enchantScrollData.IncBaseMax)
		{
			return false;
		}
	}

	if (requestedItemInfoScroll.Id.ClassID == 90995)
	{
		return false;
	}

	return true;
}

function bool IsBreakable()
{
	switch(EEtcItemType(GetIteminfoScroll().EtcItemType))
	{
		case ITEME_CURSED_ENCHANT_WP:
		case ITEME_CURSED_ENCHANT_AM:
			return false;

		default:
			return GetItemInfoEquipment().Enchanted >= GetFailureBase();
	}
}

function int GetFailureBase()
{
	return enchantScrollData.FailureBase;
}

function int GetFailureDecrease()
{
	return enchantScrollData.FailureDecrease;
}

function bool IsFailureMaintain()
{
	return enchantScrollData.FailureMaintain;
}

function bool IsFailureCrush()
{
	if (requestedItemInfoScroll.Id.ClassID == 90995)
	{
		return true;
	}	
	return enchantScrollData.FailureCrush;
}

function int GetRandomValue()
{
	local int i, Min, Max;
	local ItemInfo iInfo;

	iInfo = GetItemInfoEquipment();

	for(i = 0; i < enchantScrollData.EnchantRangeDatas.Length; i++)
	{
		Min = enchantScrollData.EnchantRangeDatas[i].RangeMin;
		Max = enchantScrollData.EnchantRangeDatas[i].RangeMax;

		if(Max == -1)
		{
			return enchantScrollData.EnchantRangeDatas[i].RandomValue;
		}

		if(Min <= iInfo.Enchanted && iInfo.Enchanted <= Max)
		{
			return enchantScrollData.EnchantRangeDatas[i].RandomValue;
		}
	}
	return -1;
}

function int GetEnchantMax()
{
	return enchantScrollData.EnchantRangeDatas[enchantScrollData.EnchantRangeDatas.Length - 1].RangeMax;
}

function int _GetEnchantMin()
{
	return enchantScrollData.EnchantRangeDatas[0].RangeMin;	
}

function AddFailChallangePointInfo()
{
	local ItemInfo iInfo;

	Debug("AddFailChallangePointInfo" @ string(failChallangePointInfo.point) @ string(groupIDWndScr._GetMaxPoint()) @ string(groupIDWndScr._GetPoint(failChallangePointInfo.gropuID)));

	if(failChallangePointInfo.rewardPnt > 0)
	{
		class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(class'ItemEnchantGroupIDWnd'.static._GetClassIDPoint(failChallangePointInfo.gropuID)), iInfo);
		iInfo.ItemNum = failChallangePointInfo.rewardPnt;
		AddFailItemInfoToList(iInfo);
	}
}

function AddFailItemInfoToList(ItemInfo iInfo)
{
	local RichListCtrlRowData RowData;

	if(iInfo.ItemNum < 1)
	{
		return;
	}

	if(MakeRecordFailItem(iInfo, RowData))
	{
		GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.FailGetItme_RichList").InsertRecord(RowData);
	}
}

function CheckEmptyFailItemInfoToList()
{
	local RichListCtrlRowData RowData, emptyRowData;
	local RichListCtrlHandle List;

	List = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.FailGetItme_RichList");

	if(List.GetRecordCount() > 0)
	{
		return;
	}
	RowData.cellDataList.Length = 1;
	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetSystemString(14024), class'L2Util'.static.Inst().Gray, false, 10);
	List.InsertRecord(emptyRowData);
	List.InsertRecord(emptyRowData);
	List.InsertRecord(RowData);
}

function bool MakeRecordFailItem(ItemInfo iInfo, out RichListCtrlRowData RowData)
{
	RowData.cellDataList.Length = 1;
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, iInfo, 32, 32, 7);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), class'L2Util'.static.Inst().White, false, 4, 3);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, "x" $ MakeCostStringINT64(iInfo.ItemNum), class'L2Util'.static.Inst().White, true, 42, 0);
	return true;
}

function SetFailEndTxt(string endTxt)
{
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.NextEnchantFail_Text").SetText(endTxt);
}

function HandleEnchantResult(string param)
{
	local int IntResult;
	local ItemID ItemID;
	local INT64 Count;
	local ItemInfo resultItemInfo, failResultItem2;
	local string endTxt;
	local int EnchantValue, SecondClassID, SecondCount;
	local ItemInfo SelectItemInfo;

	SelectItemInfo = GetItemInfoEquipment();
	ParseInt(param, "Result", IntResult);
	ParseItemID(param, ItemID);
	ParseINT64(param, "Count", Count);
	ParseInt(param, "EnchantValue", EnchantValue);
	class'UIDATA_ITEM'.static.GetItemInfo(ItemID, resultItemInfo);
	resultItemInfo.Enchanted = EnchantValue;
	resultItemInfo.ItemNum = Count;
	resultItemInfo.bShowCount = IsStackableItem(resultItemInfo.ConsumeType);
	EnchantedItemSlot.Clear();
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.FailGetItme_RichList").DeleteAllItem();

	if(SelectItemInfo.Enchanted == 0)
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.PrvEnchantNum_Text").SetText("0");
	}
	else
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.PrvEnchantNum_Text").SetText("+" $ string(SelectItemInfo.Enchanted));
	}
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.NextEnchantNum_Text").SetText("+" $ string(EnchantValue));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.EnchantResultMsg").SetText(GetSystemString(3903));

	if(IntResult != 2)
	{
		ResetScrollNum();
		ResetSupportNum();
	}
	switch(IntResult)
	{
		case 0:
			resultState = STATE_COMPLETE_RESULT;
			SelectItemInfo.Enchanted = EnchantValue;
			GetHtmlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.EnchantEffect_Ctrl").LoadHtmlFromString(GetItemInfoHtml(SelectItemInfo, true));
			EnchantedItemSlot.AddItem(SelectItemInfo);
			GetHtmlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.ItemName_Ctrl").LoadHtmlFromString(htmlSetHtmlStart(GetCenterTable(GetNameHtmlFull(SelectItemInfo), 300, 0)));
			break;
		case 1:
			resultState = STATE_COMPLETE_RESULT_FAIL;

			if(IsAGScrollType())
			{
				endTxt = GetSystemMessage(4511);
			}
			else
			{
				endTxt = MakeFullSystemMsg(GetSystemMessage(64), GetItemInfoEquipment().Name);
			}
			SetFailEndTxt(endTxt);
			Debug("resultItemInfo.itemNum" @ string(resultItemInfo.ItemNum));
			AddFailItemInfoToList(resultItemInfo);
			AddFailChallangePointInfo();
			break;
		case 2:
			isGreateSuccess = false;
			resultState = STATE_READY_SCROLL;
			break;
		case 3:
			break;
		case 4:
			resultState = STATE_COMPLETE_RESULT_FAIL;

			if(IsAGScrollType())
			{
				endTxt = GetSystemMessage(4511);
			}
			else
			{
				endTxt = MakeFullSystemMsg(GetSystemMessage(64), SelectItemInfo.Name, "");
			}
			SetFailEndTxt(endTxt);
			break;
		case 5:
			break;
		case 6:
			resultState = STATE_COMPLETE_RESULT_FAIL;
			endTxt = MakeFullSystemMsg(GetSystemMessage(2343), ("+" $ string(EnchantValue)) @ SelectItemInfo.Name, "1");
			SetFailEndTxt(endTxt);
			SelectItemInfo.Enchanted = EnchantValue;
			AddFailItemInfoToList(SelectItemInfo);
			break;
		case 7:
			resultState = STATE_COMPLETE_RESULT;
			endTxt = GetSystemMessage(13137);
			GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.EnchantResultMsg").SetText(endTxt);
			SelectItemInfo.Enchanted = EnchantValue;
			EnchantedItemSlot.AddItem(SelectItemInfo);
			GetHtmlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.ItemName_Ctrl").LoadHtmlFromString(htmlSetHtmlStart(GetCenterTable(GetNameHtmlFull(SelectItemInfo), 300, 0)));
			GetHtmlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.EnchantEffect_Ctrl").LoadHtmlFromString(GetItemInfoHtml(SelectItemInfo, true));
			break;
		case 8:
			if(isAutoEnchanting || isAutoEnchantingStop)
			{
				Debug("남은 스크롤 아이템 수 " $ string(GetIteminfoScroll().ItemNum));

				if(GetIteminfoScroll().ItemNum > 0)
				{
					if(isGreateSuccess)
					{
						API_C_EX_REQ_VIEW_ENCHANT_RESULT();
					}
					API_RequestExAddEnchantScrollItem(requestedItemInfoScroll);
					return;
				}
				isAutoEnchantingStop = false;
				EnchantBtnAuto.EnableWindow();
			}
			resultState = STATE_COMPLETE_RESULT_FAIL;

			if(IsAGScrollType())
			{
				endTxt = GetSystemMessage(4509);
			}
			else
			{
				endTxt = GetSystemMessage(6004);
			}
			SetFailEndTxt(endTxt);
			AddFailItemInfoToList(SelectItemInfo);
			break;
		case 9:
			resultState = STATE_COMPLETE_RESULT_FAIL;
			SelectItemInfo.Enchanted = EnchantValue;
			Debug("감소 됨  결과 아이템 " @ "+" $ string(EnchantValue) $ SelectItemInfo.Name);

			if(IsAGScrollType())
			{
				endTxt = GetSystemMessage(4511);
			}
			else
			{
				endTxt = MakeFullSystemMsg(GetSystemMessage(2343), ("+" $ string(EnchantValue)) $ SelectItemInfo.Name, "1");
			}
			SetFailEndTxt(endTxt);
			AddFailItemInfoToList(SelectItemInfo);
			break;
		case 10:
			resultState = STATE_COMPLETE_RESULT_FAIL;

			if(IsAGScrollType())
			{
				endTxt = GetSystemMessage(4512);
			}
			else
			{
				endTxt = MakeFullSystemMsg(GetSystemMessage(2343), SelectItemInfo.Name, "1");
			}

			if(isAutoEnchanting || isAutoEnchantingStop && SelectItemInfo.Enchanted == EnchantValue)
			{
				Debug("남은 스크롤 아이템 수 " $ string(GetIteminfoScroll().ItemNum));

				if(GetIteminfoScroll().ItemNum > 0)
				{
					if(isGreateSuccess)
					{
						API_C_EX_REQ_VIEW_ENCHANT_RESULT();
					}
					API_RequestExAddEnchantScrollItem(requestedItemInfoScroll);
					return;
				}
				isAutoEnchantingStop = false;
				EnchantBtnAuto.EnableWindow();
			}
			SetFailEndTxt(endTxt);
			SelectItemInfo.Enchanted = EnchantValue;
			AddFailItemInfoToList(SelectItemInfo);
			break;
	}

	if((isGreateSuccess && ! isAutoEnchanting) && ! isAutoEnchantingStop)
	{
		GotoState(STATE_COMPLETE_BLIND);
	}
	else
	{
		if(isGreateSuccess)
		{
			API_C_EX_REQ_VIEW_ENCHANT_RESULT();
		}
		GotoState(resultState);
	}
	ParseInt(param, "SecondClassID", SecondClassID);
	ParseInt(param, "SecondCount", SecondCount);

	if((SecondClassID > 0) && SecondCount > 0)
	{
		failResultItem2 = GetItemInfoByClassID(SecondClassID);
		failResultItem2.ItemNum = SecondCount;
		AddFailItemInfoToList(failResultItem2);
	}
	resetBtn.EnableWindow();	
}

function GetSlotAniPlay(string Path)
{
	local AnimTextureHandle aniTex;

	aniTex = GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path $ ".activeAni");
	aniTex.Stop();
	aniTex.ShowWindow();
	aniTex.SetLoopCount(9999999);
	aniTex.Play();
}

function SetSlotInputAniPlay(string Path)
{
	local AnimTextureHandle aniTex;

	aniTex = GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path $ ".inputAni");
	aniTex.Stop();
	aniTex.ShowWindow();
	aniTex.SetLoopCount(1);
	aniTex.Play();
}

function GetSlotAniStop(string Path)
{
	local AnimTextureHandle aniTex;

	aniTex = GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path $ ".activeAni");
	aniTex.HideWindow();
	aniTex = GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path $ ".inputAni");
	aniTex.HideWindow();
}

function GetSupportActiveAniPlay(string Name)
{
	local AnimTextureHandle aniTex;

	aniTex = GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Name $ "activeAni");
	aniTex.Stop();
	aniTex.ShowWindow();
	aniTex.SetLoopCount(9999999);
	aniTex.Play();
}

function GetSupportActiveAniStop(string Name)
{
	local AnimTextureHandle aniTex;

	aniTex = GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Name $ "activeAni");
	aniTex.HideWindow();
}

function ChangeEquipmentAni()
{
	local AnimTextureHandle aniTex;

	aniTex = GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".equipmentItemWnd.activeAni");
	Debug("ChangeEquipmentAni" @ string(IsBreakable()));

	if(IsBreakable())
	{
		aniTex.SetTexture("L2UI.UISlotEffect.itemsquare_0000");		
	}
	else
	{
		aniTex.SetTexture("L2UI.UISlotEffect.itemsquareSafe_0000");
	}
	aniTex.Stop();
	aniTex.ShowWindow();
	aniTex.SetLoopCount(9999999);
	aniTex.Play();
}

function API_RequestExCancelEnchantItem()
{
	class'EnchantAPI'.static.RequestExCancelEnchantItem();
}

function API_RequestExAddEnchantScrollItem(ItemInfo iInfo)
{
	requestedItemInfoScroll = iInfo;
	class'EnchantAPI'.static.RequestExAddEnchantScrollItem(GetItemInfoEquipment().Id, iInfo.Id);
}

function API_RequestExTryToPutEnchantTargetItem(ItemInfo iInfo)
{
	requestedItemInfoEquipment = iInfo;
	class'EnchantAPI'.static.RequestExTryToPutEnchantTargetItem(iInfo.Id);
}

function API_RequestExTryToPutEnchantSupportItem(ItemInfo iInfo, optional bool _bWaitTargetItem)
{
	bWaitTargetItem = _bWaitTargetItem;
	requestedItemInfoSupport = iInfo;

	if(_bWaitTargetItem)
	{
		return;
	}

	if(! supportItemWindow.IsShowWindow())
	{
		AddSystemMessage(6094);
		return;
	}
	EnchantBtn.DisableWindow();
	Debug("API_RequestExTryToPutEnchantSupportItem" @ iInfo.Name @ GetItemInfoEquipment().Name);
	API_C_EX_RESET_ENCHANT_CHALLENGE_POINT();
	class'EnchantAPI'.static.RequestExTryToPutEnchantSupportItem(iInfo.Id, GetItemInfoEquipment().Id);
}

function API_RequestExRemoveEnchantSupportItem()
{
	if(supportItemWindow.GetItemNum() == 0)
	{
		return;
	}
	EnchantBtn.DisableWindow();
	class'EnchantAPI'.static.RequestExRemoveEnchantSupportItem();
}

function API_RequestEnchantItem(bool enc)
{
	class'EnchantAPI'.static.RequestEnchantItem(GetItemInfoEquipment().Id, enc);
	Debug("- API_RequestEnchantItem -" @ string(bUsedTicket) @ string(SelectedSystemSupport) @ string(GetCurrentPoint()) @ string(groupIDWndScr._GetPoint(failChallangePointInfo.gropuID)) @ string(GetSelectedFee()));

	if(! bUsedTicket && SelectedSystemSupport > -1)
	{
		failChallangePointInfo.rewardPnt = Min(failChallangePointInfo.point, (groupIDWndScr._GetMaxPoint() - (GetCurrentPoint())) + (GetSelectedFee()));		
	}
	else
	{
		failChallangePointInfo.rewardPnt = Min(failChallangePointInfo.point, groupIDWndScr._GetMaxPoint() - (GetCurrentPoint()));
	}

	if(enc)
	{
		groupIDWndScr._SetDisable();
	}
}

function bool API_GetEnchantScrollSetData(ItemInfo iInfo)
{
	return class'UIDATA_ITEM'.static.GetEnchantScrollSetData(iInfo.Id.ClassID, enchantScrollData);
}

function API_C_EX_SET_ENCHANT_CHALLENGE_POINT(bool useTicket)
{
	local array<byte> stream;
	local UIPacket._C_EX_SET_ENCHANT_CHALLENGE_POINT packet;
	local RichListCtrlRowData Record;

	bUsedTicket = useTicket;

	if(bUsedTicket)
	{
		packet.bUseTicket = 1;
	}
	else
	{
		packet.bUseTicket = 0;
	}
	SelectedSystemSupport = supportSystemList.GetSelectedIndex();
	supportSystemList.GetSelectedRec(Record);
	packet.nUseType = int(Record.nReserved1);
	Debug("도전 포인트 사용 여부 확인  " @ string(SelectedSystemSupport) @ string(Record.nReserved1));

	if(! class'UIPacket'.static.Encode_C_EX_SET_ENCHANT_CHALLENGE_POINT(stream, packet))
	{
		return;
	}
	API_RequestExRemoveEnchantSupportItem();
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SET_ENCHANT_CHALLENGE_POINT, stream);
}

function API_C_EX_RESET_ENCHANT_CHALLENGE_POINT()
{
	local array<byte> stream;
	local UIPacket._C_EX_RESET_ENCHANT_CHALLENGE_POINT packet;

	if(! class'UIPacket'.static.Encode_C_EX_RESET_ENCHANT_CHALLENGE_POINT(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_RESET_ENCHANT_CHALLENGE_POINT, stream);
}

function int API_GetChallengePointGroupID()
{
	return class'UIDATA_ITEM'.static.GetChallengePointGroupID(GetItemInfoEquipment().Id.ClassID);
}

function API_GetEnchantChallengePointSettingData(out EnchantChallengePointSettingUIData o_data)
{
	class'UIDATA_ITEM'.static.GetEnchantChallengePointSettingData(o_data);
}

function bool API_GetEnchantChallengePointData(int GroupID, out EnchantChallengePointUIData o_data)
{
	return class'UIDATA_ITEM'.static.GetEnchantChallengePointData(GroupID, o_data);
}

function API_GetEnchantValidateValue(int Enchanted, out EnchantValidateUIData oData)
{
	class'UIDATA_ITEM'.static.GetEnchantValidateValue(GetItemInfoEquipment().Id.ClassID, Enchanted, oData);
}

function API_C_EX_REQ_ENCHANT_FAIL_REWARD_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_REQ_ENCHANT_FAIL_REWARD_INFO packet;

	packet.nItemServerId = GetItemInfoEquipment().Id.ServerID;

	if(! class'UIPacket'.static.Encode_C_EX_REQ_ENCHANT_FAIL_REWARD_INFO(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_REQ_ENCHANT_FAIL_REWARD_INFO, stream);
}

function API_C_EX_REQ_VIEW_ENCHANT_RESULT()
{
	local array<byte> stream;
	local UIPacket._C_EX_REQ_VIEW_ENCHANT_RESULT packet;

	if(! class'UIPacket'.static.Encode_C_EX_REQ_VIEW_ENCHANT_RESULT(stream, packet))
	{
		return;
	}
	NoticeWnd(GetScript("NoticeWnd"))._CreateCollectionButtonBlind();
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_REQ_VIEW_ENCHANT_RESULT, stream);
}

function CheckEnchantNEncht()
{
	if(IsBreakable())
	{
		HandleShowDialog();
		resetBtn.DisableWindow();
		EnchantBtn.DisableWindow();
	}
	else
	{
		GotoState('stateEnchant');
	}
}

function StartAutoEnchant()
{
	if(isAutoEnchantingStop)
	{
		GotoState(PrevState);
		return;
	}
	EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_openbox");
	timerObject._Reset();
	EnchantBtnAuto.EnableWindow();
}

function RequestEnchant()
{
	isGreateSuccess = IsGreateSuccessEffect(GetItemInfoEquipment().Enchanted + 1);
	API_RequestEnchantItem(isGreateSuccess);
}

function SetSupportSystemList()
{
	local int i;
	local RichListCtrlRowData Record;

	supportSystemList.DeleteAllItem();

	for(i = 0; i < 6; i++)
	{
		if(MakeRecordSupportSystem(i, Record))
		{
			supportSystemList.InsertRecord(Record);
		}
	}
}

function int GetIndexPointInfo(int pointGrouID)
{
	local int i;

	for(i = 0; i < vCurrentPointInfo.Length; i++)
	{
		if(vCurrentPointInfo[i].nPointGroupId == pointGrouID)
		{
			return i;
		}
	}
	return -1;
}

function bool ChkEnchantContinue()
{
	local ItemInfo ScrollItemInfo, equipmentInfo, supportItem;

	EnchantBtn.SetNameText(GetSystemString(13935));
	EnchantBtnAuto.SetNameText(GetSystemString(14237));

	if(! RefreshScroll(ScrollItemInfo))
	{
		API_RequestExCancelEnchantItem();
		GotoState('stateReadyScroll');
		return false;
	}

	if(! RefreshEquipment(equipmentInfo) || GetEnchantMax() != -1 && GetEnchantMax() <= equipmentInfo.Enchanted)
	{
		Debug("인챈티드 수치 1" @ string(equipmentInfo.Enchanted));

		if(supportItemWindow.GetItemNum() > 0)
		{
			API_RequestExRemoveEnchantSupportItem();
		}

		if(SelectedSystemSupport > -1)
		{
			API_C_EX_RESET_ENCHANT_CHALLENGE_POINT();
		}
		GotoState('stateReadyScroll');
		API_RequestExAddEnchantScrollItem(ScrollItemInfo);
		return false;
	}

	if(! class'UIDATA_INVENTORY'.static.FindItem(equipmentInfo.Id.ServerID, equipmentInfo))
	{
		return false;
	}
	Debug("인챈티드 수치 2" @ string(equipmentInfo.Enchanted));
	API_RequestExTryToPutEnchantTargetItem(equipmentInfo);

	if(supportItemWindow.GetItemNum() > 0)
	{
		if(! RefreshSupportStone(supportItem))
		{
			API_RequestExRemoveEnchantSupportItem();
		}
		else
		{
			API_RequestExTryToPutEnchantSupportItem(supportItem, true);
		}
	}
	else
	{
		if(SelectedSystemSupport > -1)
		{
			API_C_EX_RESET_ENCHANT_CHALLENGE_POINT();
		}
	}
	return true;
}

function bool RefreshEquipment(out ItemInfo equipmentiInfo)
{
	local ItemInfo iInfo;

	equipmentiInfo = GetItemInfoEquipment();
	equipmentItemWindow.Clear();

	if(! class'UIDATA_INVENTORY'.static.FindItem(equipmentiInfo.Id.ServerID, iInfo))
	{
		return false;
	}
	equipmentItemWindow.AddItem(iInfo);
	return true;
}

function bool RefreshScroll(out ItemInfo scrolliInfo)
{
	local ItemInfo iInfo;

	scrolliInfo = GetIteminfoScroll();
	scrollItemWindow.Clear();

	if(! class'UIDATA_INVENTORY'.static.FindItem(scrolliInfo.Id.ServerID, iInfo))
	{
		return false;
	}
	iInfo.bShowCount = true;
	scrolliInfo = iInfo;
	scrollItemWindow.AddItem(iInfo);
	return true;
}

function bool RefreshSupportStone(out ItemInfo supportlliInfo)
{
	local ItemInfo iInfo;

	supportlliInfo = GetItemInfoSupport();
	supportItemWindow.Clear();

	if(! class'UIDATA_INVENTORY'.static.FindItem(supportlliInfo.Id.ServerID, iInfo))
	{
		return false;
	}
	iInfo.bShowCount = true;
	supportItemWindow.AddItem(iInfo);
	return true;
}

private function ResetScrollNum()
{
	requestedItemInfoScroll.ItemNum = requestedItemInfoScroll.ItemNum - 1;
	scrollItemNum.SetText(GetSystemString(5027) @ ":" @ MakeCostStringINT64(requestedItemInfoScroll.ItemNum));
	scrollItemWindow.SetItem(0, requestedItemInfoScroll);	
}

private function ResetSupportNum()
{
	requestedItemInfoSupport.ItemNum = requestedItemInfoSupport.ItemNum - 1;
	supportItemWindow.SetItem(0, requestedItemInfoSupport);	
}

function ItemInfo GetIteminfoScroll()
{
	local ItemInfo iInfo;

	scrollItemWindow.GetItem(0, iInfo);
	return iInfo;
}

function ItemInfo GetItemInfoEquipment()
{
	local ItemInfo iInfo;

	equipmentItemWindow.GetItem(0, iInfo);
	return iInfo;
}

function ItemInfo GetItemInfoSupport()
{
	local ItemInfo iInfo;

	supportItemWindow.GetItem(0, iInfo);
	return iInfo;
}

function SwapMultiEnchantWnd()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "ItemMultiEnchantWnd");
	GetWindowHandle("ItemMultiEnchantWnd").ShowWindow();
	GetWindowHandle("ItemMultiEnchantWnd").SetFocus();
	class'ItemMultiEnchantWnd'.static.Inst()._HandleOnDrop(GetIteminfoScroll());
	m_hOwnerWnd.HideWindow();
}

function string GetEnchantValueResultHtm(int enchantBefore, int enchantAfter)
{
	local int i;
	local EnchantValidateUIData oData, oDataAfter;
	local string colorString, tableHtmAfter, tableHtmTrAfter;

	API_GetEnchantValidateValue(enchantBefore, oData);
	API_GetEnchantValidateValue(enchantAfter, oDataAfter);
	tableHtmAfter = "";

	for(i = 0; i < ValidateEnum.Max - 1; i++)
	{
		if(oDataAfter.EnchantValue[i] > 0)
		{
			if(oDataAfter.EnchantValue[i] > oData.EnchantValue[i])
			{
				colorString = "c8ffc8";
			}
			else
			{
				colorString = "c8c8c8";
			}
			tableHtmAfter = htmlAddTableTD(htmlAddText(GetEnchantEffectName(ValidateEnum(i)), "GameDefault", "c8c8c8"), "left", "center", 200, 0);
			tableHtmAfter = tableHtmAfter $ htmlAddTableTD(htmlAddText(string(int(oDataAfter.EnchantValue[i])), "GameDefault", colorString), "right", "center", 100, 0);
			tableHtmTrAfter = tableHtmTrAfter $ htmlSetTableTR(tableHtmAfter);
		}
	}
	return tableHtmTrAfter;
}

function string GetProbString(int probPermriad)
{
	if(float(probPermriad) % 100 == 0)
	{
		return string(probPermriad / 100) $ "%";
	}
	return string(float(probPermriad) / 100) $ "%";
}

function string GetEnchantEffectHtmlString(ValidateEnum Type, ItemInfo iInfo, EnchantValidateUIData oData)
{
	local int Value;
	local string htm;

	Value = GetItemInfoValueEnchantType(Type, iInfo);
	htm = htmlAddText(GetEnchantEffectName(Type) $ " : ", "GameDefault", "ffffff");
	htm = htm $ (htmlAddText(string(int(float(Value) + oData.EnchantValue[Type])), "GameDefault", "EBCD00"));

	if(oData.EnchantValue[Type] > 0)
	{
		htm = htm $ htmlAddText(" (" $ string(Value), "GameDefault", getColorHexString(GetColor(176, 155, 121, 255)));
		htm = htm $ htmlAddText(" +" $ string(int(oData.EnchantValue[Type])), "GameDefault", getColorHexString(GetColor(238, 170, 34, 255)));
		htm = htm $ htmlAddText(")", "GameDefault", getColorHexString(GetColor(176, 155, 121, 255)));
	}
	htm = htm $ htmlAddTableTD(htm, "left", "center", 310, 20);
	htmlSetTableTR(htm);
	return htm;
}

function int GetItemInfoValueEnchantType(ValidateEnum Type, ItemInfo iInfo)
{
	switch(Type)
	{
		case PDEFEND:
			return int(iInfo.pDefense);
		case MDEFEND:
			return int(iInfo.mDefense);
		case pAttack:
			return int(iInfo.pAttack);
		case mAttack:
			return int(iInfo.mAttack);
		case pAttackSpeed:
			return int(iInfo.pAttackSpeed);
		case mAttackSpeed:
			return int(iInfo.mAttackSpeed);
		case PSKILLSPEED:
			return 9999;
		case PHIT:
			return int(iInfo.pHitRate);
		case MHIT:
			return int(iInfo.mHitRate);
		case PCRITICAL:
			return int(iInfo.pCriRate);
		case MCRITICAL:
			return int(iInfo.mCriRate);
		case Speed:
			return int(iInfo.MoveSpeed);
		case ShieldDefense:
			return int(iInfo.ShieldDefense);
		case ShieldDefenseRate:
			return int(iInfo.ShieldDefenseRate);
		case pAvoid:
			return int(iInfo.pAvoid);
		case mAvoid:
			return int(iInfo.mAvoid);

		default:
			return 0;
	}
}

function string GetEnchantEffectName(ValidateEnum Type)
{
	switch(Type)
	{
		case PDEFEND:
			return GetSystemString(95);
		case MDEFEND:
			return GetSystemString(99);
		case pAttack:
			return GetSystemString(94);
		case mAttack:
			return GetSystemString(98);
		case pAttackSpeed:
			return GetSystemString(13966);
		case mAttackSpeed:
			return GetSystemString(112);
		case PSKILLSPEED:
			return GetSystemString(13968);
		case PHIT:
			return GetSystemString(96);
		case MHIT:
			return GetSystemString(2363);
		case PCRITICAL:
			return GetSystemString(2362);
		case MCRITICAL:
			return GetSystemString(2365);
		case Speed:
			return GetSystemString(432);
		case ShieldDefense:
			return GetSystemString(13206);
		case ShieldDefenseRate:
			return GetSystemString(317);
		case pAvoid:
			return GetSystemString(2361);
		case mAvoid:
			return GetSystemString(2364);

		default:
			return "";
	}
}

function string AddEnchantEffectDescTooltipHtml(ItemInfo item)
{
	local int i;
	local array<string> descriptions;
	local int nFontLevel;
	local string HTML, colorString;

	if(class'UIDATA_ITEM'.static.GetEnchantedItemSkillDesc(item.Id.ClassID, item.Enchanted, descriptions, nFontLevel))
	{
		colorString = GetColorEnchentEffectDescFontLevel(nFontLevel);
		HTML = htmlAddText(GetSystemString(2214), "GameDefault", "B09B79");
		HTML = htmlAddTableTD(HTML, "left", "center", 200, 0);
		htmlSetTableTR(HTML);
		HTML = "<tr><td></td></tr>" $ HTML;

		for(i = 0; i < descriptions.Length; i++)
		{
			HTML = HTML $ (Desc2HtmlTR(descriptions[i], colorString));
		}
	}
	return HTML;
}

function string GetColorEnchentEffectDescFontLevel(int nFontLevel)
{
	switch(nFontLevel)
	{
		case 1:
			return "ffe57f";
		case 2:
			return "6778ff";
		case 3:
			return "cb77ff";
		case 4:
			return "dc00fe";

		default:
			return "FF0000";
	}
}

function string GetItemInfoHtml(ItemInfo iInfo, optional bool bHideName, optional bool bBeforeInfo)
{
	local int i;
	local string namehtml, tableHtmTr, ehcnatEffectHtmlString, agaString;
	local EnchantValidateUIData oData, oDataAfter;

	API_GetEnchantValidateValue(iInfo.Enchanted, oData);

	if(! bHideName)
	{
		namehtml = GetNameHtmlFull(iInfo) $ "<br>";
	}
	API_GetEnchantValidateValue(iInfo.Enchanted + 1, oDataAfter);

	for(i = 0; i < ValidateEnum.Max - 1; i++)
	{
		if(bBeforeInfo)
		{
			if(oDataAfter.EnchantValue[i] == 0 && oData.EnchantValue[i] == 0)
			{
				continue;
			}			
		}
		else
		{
			if(oData.EnchantValue[i] == 0)
			{
				continue;
			}
		}
		ehcnatEffectHtmlString = GetEnchantEffectHtmlString(ValidateEnum(i), iInfo, oData);
		tableHtmTr = tableHtmTr $ ehcnatEffectHtmlString;
	}
	tableHtmTr = tableHtmTr $ (AddEnchantEffectDescTooltipHtml(iInfo));

	if((iInfo.ItemType == EItemType.ITEM_ACCESSARY) && iInfo.SlotBitType == (16 + 32))
	{
		agaString = AgathionSkillInfoToHtml(iInfo);

		if(agaString != "")
		{
			tableHtmTr = (agaString $ "<tr></tr>") $ tableHtmTr;
		}
	}
	htmlSetTable(tableHtmTr, 0, 310, 0, "", 0, 5);

	if(namehtml != "" && tableHtmTr != "")
	{
		namehtml = namehtml $ (htmlAddImg("L2UI_EPIC.ClanWnd.ClanWnd_ShadowDivider2", 310, 8));
	}
	ReplaceText(tableHtmTr, "&lt;", "<");
	ReplaceText(tableHtmTr, "&gt;", ">");
	return htmlSetHtmlStart(namehtml $ tableHtmTr);
}

function string AgathionSkillInfoToHtml(ItemInfo Info)
{
	local array<SkillInfo> mainSkillList, subSkillList;
	local int i;
	local Color titleColor, DescColor;
	local string HTML, titleHtm;

	GetAgathionMainSkillList(Info.Id.ClassID, Info.Enchanted, mainSkillList);
	GetAgathionSubSkillList(Info.Id.ClassID, Info.Enchanted, subSkillList);

	if(mainSkillList.Length > 0)
	{
		if((GetAgathionIndex(Info.Id)) == 0)
		{
			titleColor = class'L2UIColor'.static.Inst().Red3;
			titleColor = class'L2UIColor'.static.Inst().ColorGray;
		}
		else
		{
			titleColor = class'L2UIColor'.static.Inst().Charcoal;
			titleColor.R = 100;
			DescColor = class'L2UIColor'.static.Inst().DarkGray;
		}
		titleHtm = htmlAddText(GetSystemString(3640), "GameDefault", getColorHexString(titleColor));
		htmlSetTableTR(titleHtm);
		HTML = HTML $ titleHtm;

		for(i = 0; i < mainSkillList.Length; i++)
		{
			HTML = HTML $ (Desc2HtmlTR(mainSkillList[i].SkillDesc, getColorHexString(DescColor)));
		}
	}
	if(subSkillList.Length > 0)
	{
		if(GetAgathionIndex(Info.Id) > 0 || GetAgathionIndex(Info.Id) == 0)
		{
			titleColor = class'L2UIColor'.static.Inst().Red3;
			titleColor = class'L2UIColor'.static.Inst().ColorGray;			
		}
		else
		{
			titleColor = class'L2UIColor'.static.Inst().Charcoal;
			titleColor.R = 100;
			DescColor = class'L2UIColor'.static.Inst().DarkGray;
		}
		titleHtm = htmlAddText(GetSystemString(3641), "GameDefault", getColorHexString(titleColor));
		titleHtm = htmlAddTableTD(titleHtm, "left", "center", 200, 0);
		htmlSetTableTR(titleHtm);
		HTML = HTML $ titleHtm;

		for(i = 0; i < subSkillList.Length; i++)
		{
			HTML = HTML $ (Desc2HtmlTR(subSkillList[i].SkillDesc, getColorHexString(DescColor)));
		}
	}
	return HTML;
}

function string Desc2HtmlTR(string Desc, string colorString)
{
	local int i;
	local array<string> descriptArray;
	local string HTML;

	Desc = Substitute(Desc, "<", "&lt;", false);
	Desc = Substitute(Desc, ">", "&gt;", false);
	Desc = Substitute(Desc, "%%", "%", false);
	Desc = Substitute(Desc, "\\n\\n", "^@@^", false);
	Desc = Substitute(Desc, "\\n", "^", false);
	Split(Desc, "^", descriptArray);

	for(i = 0; i < descriptArray.Length; i++)
	{
		if(descriptArray[i] == "@@")
		{
			HTML = HTML $ "<tr><td></td></tr>";
			continue;
		}
		Desc = htmlAddText(" " $ descriptArray[i], "GameDefault", colorString);
		Desc = htmlAddTableTD(Desc, "left", "center", 200, 0);
		HTML = HTML $ htmlSetTableTR(Desc);
	}
	return HTML;
}

function string GetSystemEnchantEffectName()
{
	local RichListCtrlRowData Record;

	if(SelectedSystemSupport == -1)
	{
		return "";
	}
	supportSystemList.GetRec(SelectedSystemSupport, Record);
	return Record.cellDataList[0].drawitems[0].strInfo.strData;
}

function int GetSelectedFee()
{
	local RichListCtrlRowData Record;

	supportSystemList.GetRec(SelectedSystemSupport, Record);
	return Record.cellDataList[3].nReserved1;
}

function int GetCurrentTicket(int pointUseType)
{
	local int pointIndex;

	pointIndex = GetCurrentPointInfoIndex();

	if(pointIndex == -1)
	{
		return 0;
	}
	switch(pointUseType)
	{
		case 0:
			return vCurrentPointInfo[pointIndex].nTicketPointOpt1;
		case 1:
			return vCurrentPointInfo[pointIndex].nTicketPointOpt2;
		case 2:
			return vCurrentPointInfo[pointIndex].nTicketPointOpt3;
		case 3:
			return vCurrentPointInfo[pointIndex].nTicketPointOpt4;
		case 4:
			return vCurrentPointInfo[pointIndex].nTicketPointOpt5;
		case 5:
			return vCurrentPointInfo[pointIndex].nTicketPointOpt6;

		default:
			return 0;
	}
}

function int GetCurrentPoint()
{
	local int pointIndex;

	pointIndex = GetCurrentPointInfoIndex();

	if(pointIndex != -1)
	{
		return vCurrentPointInfo[pointIndex].nChallengePoint;
	}
	return 0;
}

function int GetCurrentPointInfoIndex()
{
	local int GroupID, i;

	GroupID = API_GetChallengePointGroupID();

	for(i = 0; i < vCurrentPointInfo.Length; i++)
	{
		if(vCurrentPointInfo[i].nPointGroupId == GroupID)
		{
			return i;
		}
	}
	return -1;
}

function InputScrollItem()
{
	scrollItemWindow.Clear();
	requestedItemInfoScroll.bShowCount = true;
	scrollItemWindow.AddItem(requestedItemInfoScroll);

	if(isAutoEnchanting || isAutoEnchantingStop)
	{
		API_RequestExTryToPutEnchantTargetItem(requestedItemInfoEquipment);
		return;
	}
	SetSlotInputAniPlay("scrollItemWnd");
	API_GetEnchantScrollSetData(requestedItemInfoScroll);
	supportItemListWnd.HideWindow();
	supportSystemListWnd.HideWindow();
	API_RequestExRemoveEnchantSupportItem();
	GotoState('stateReadyEquipment');
	class'ItemEnchantSubWnd'.static.Inst().Refresh();
	PlaySound("Itemsound3.ui_enchant_slot");
}

function CheckSupports()
{
	local EnchantChallengePointUIData UIData;

	if(UseSupportSlot())
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemWnd").ShowWindow();
	}
	else
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemWnd").HideWindow();
	}

	if(API_GetChallengePointGroupID() > 0 && API_GetEnchantChallengePointData(API_GetChallengePointGroupID(), UIData) && GetFailureDecrease() == 0 && ! IsFailureMaintain() && IsFailureCrush() && GetRandomValue() == 1)
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd").ShowWindow();
	}
	else
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd").HideWindow();
	}
}

function InputEquipmentItem()
{
	equipmentItemWindow.Clear();
	equipmentItemWindow.AddItem(requestedItemInfoEquipment);

	if(isAutoEnchanting || isAutoEnchantingStop)
	{
		StartAutoEnchant();
		return;		
	}
	else
	{
		if(CanUseAutoMode())
		{
			SetAutoMode();			
		}
		else
		{
			SetNormalMode();
		}
	}
	SetSlotInputAniPlay("equipmentItemWnd");
	supportItemListWnd.HideWindow();
	supportSystemListWnd.HideWindow();
	API_RequestExRemoveEnchantSupportItem();
	CheckSupports();
	GotoState('stateReadySupport');
	SetTitleByItemType();
	HandleInstructionTxt();
	class'ItemEnchantSubWnd'.static.Inst().Refresh();
	PlaySound("Itemsound3.ui_enchant_slot");
	SetSupportSystemList();
	API_C_EX_REQ_ENCHANT_FAIL_REWARD_INFO();
	groupIDWndScr._SetCurrentGroupID(API_GetChallengePointGroupID());
	ChangeEquipmentAni();
	CheckWarningTxt();
}

function InputSupportItem()
{
	supportItemWindow.Clear();
	requestedItemInfoSupport.bShowCount = true;
	supportItemWindow.AddItem(requestedItemInfoSupport);
	SetSlotInputAniPlay("supportItemWnd");
	supportItemListWnd.HideWindow();
	supportSystemListWnd.HideWindow();
	PlaySound("Itemsound3.ui_enchant_slot");
	GotoState('stateReadySupportstone');
	HandleInstructionTxt();
}

function InputSupportSystem()
{
	supportItemWindow.Clear();
	SetSlotInputAniPlay("supportSystemWnd");
	supportItemListWnd.HideWindow();
	supportSystemListWnd.HideWindow();
	PlaySound("Itemsound3.ui_enchant_slot");
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd.supportSystemSelectedWnd.EnchantEffect_Text").SetText(GetSystemEnchantEffectName());
	SetSupportSystemList();
	GotoState('stateReadySupportsystem');
	HandleInstructionTxt();
	CheckWarningTxt();
}

function string GetUseConditionString(int Min, int Max)
{
	local string minString, maxString;

	if(Min == -1)
	{
		return GetSystemString(869);
	}

	if(Min > 0)
	{
		minString = "+" $ string(Min) $ GetSystemString(859);
	}

	if(Max != -1)
	{
		maxString = "+" $ string(Max) $ GetSystemString(13266);
	}

	if(minString == "" && maxString == "")
	{
		return "-";
	}

	if(minString != "" && maxString != "")
	{
		return minString $ "," @ maxString;
	}
	else if(minString == "")
	{
		return maxString;
	}
	else if(maxString == "")
	{
		return minString;
	}
}

function bool GetUseCondition(int Min, int Max)
{
	if(Min == -1)
	{
		return false;
	}

	if(Max == -1)
	{
		Max = 999999;
	}
	return (Min <= GetItemInfoEquipment().Enchanted) && GetItemInfoEquipment().Enchanted <= Max;
}

function bool MakeRecordSupportSystem(int Index, out RichListCtrlRowData Record)
{
	local EnchantChallengePointUIData UIData;
	local EnchantOptionData currentOptionData;
	local EnchantOverUpData currentOverUpData;
	local Color TextColor;
	local string UseCondition;
	local bool bUseCondition;
	local string Title, probString;
	local RichListCtrlRowData emptyRecord;
	local int Fee, ticket, i;
	local EnchantChallengePointSettingUIData o_data;
	local int Prob;

	ticket = GetCurrentTicket(Index);
	Record = emptyRecord;

	if(! API_GetEnchantChallengePointData(API_GetChallengePointGroupID(), UIData))
	{
		return false;
	}
	API_GetEnchantChallengePointSettingData(o_data);
	Debug("index" @ string(Index) @ string(API_GetEnchantChallengePointData(API_GetChallengePointGroupID(), UIData)) @ string(API_GetChallengePointGroupID()) @ "소폿 시스템 만드는 중");
	switch(Index)
	{
		case 0:
			Title = GetSystemString(13982);
			currentOptionData = UIData.ProbInc1;
			Debug("index:" $ string(Index) @ string(currentOptionData.RangeMin) @ string(currentOptionData.RangeMax));

			if((currentOptionData.RangeMin == -1) && currentOptionData.RangeMax == -1)
			{
				return false;
			}
			Fee = o_data.ProbInc1Fee;
			Prob = int(currentOptionData.Prob);
			probString = string(Prob) $ "%";
			bUseCondition = GetUseCondition(currentOptionData.RangeMin, currentOptionData.RangeMax);
			UseCondition = GetUseConditionString(currentOptionData.RangeMin, currentOptionData.RangeMax);
			break;
		case 1:
			Title = GetSystemString(13983);
			currentOptionData = UIData.ProbInc2;
			Debug("index:" $ string(Index) @ string(currentOptionData.RangeMin) @ string(currentOptionData.RangeMax));

			if((currentOptionData.RangeMin == -1) && currentOptionData.RangeMax == -1)
			{
				return false;
			}
			Fee = o_data.ProbInc2Fee;
			Prob = int(currentOptionData.Prob);
			probString = string(Prob) $ "%";
			bUseCondition = GetUseCondition(currentOptionData.RangeMin, currentOptionData.RangeMax);
			UseCondition = GetUseConditionString(currentOptionData.RangeMin, currentOptionData.RangeMax);
			break;
		case 2:
			currentOverUpData = UIData.OverUpProb;
			Debug("index:" $ string(Index) @ string(currentOverUpData.RangeMin) @ string(currentOverUpData.RangeMax));

			if((currentOverUpData.RangeMin == -1) && currentOverUpData.RangeMax == -1)
			{
				return false;
			}
			Fee = o_data.OverUpProbFee;
			Title = MakeFullSystemMsg(GetSystemMessage(13655), (string(currentOverUpData.OverUps[0].Value) $ "~") $ string(currentOverUpData.OverUps[currentOverUpData.OverUps.Length - 1].Value));
			Prob = int(currentOverUpData.OverUps[0].Prob);
			probString = string(Prob) $ "%";

			for(i = 1; i < currentOverUpData.OverUps.Length; i++)
			{
				probString = ((probString $ "/") $ string(currentOverUpData.OverUps[i].Prob)) $ "%";
			}
			bUseCondition = GetUseCondition(currentOverUpData.RangeMin, currentOverUpData.RangeMax);
			UseCondition = GetUseConditionString(currentOverUpData.RangeMin, currentOverUpData.RangeMax);
			break;
		case 3:
			Title = GetSystemString(13985);
			currentOptionData = UIData.NumResetProb;
			Debug("index:" $ string(Index) @ string(currentOptionData.RangeMin) @ string(currentOptionData.RangeMax));

			if((currentOptionData.RangeMin == -1) && currentOptionData.RangeMax == -1)
			{
				return false;
			}
			Fee = o_data.NumResetProbFee;
			Prob = int(currentOptionData.Prob);
			probString = string(Prob) $ "%";
			bUseCondition = GetUseCondition(currentOptionData.RangeMin, currentOptionData.RangeMax);
			UseCondition = GetUseConditionString(currentOptionData.RangeMin, currentOptionData.RangeMax);
			break;
		case 4:
			Title = GetSystemString(13986);
			currentOptionData = UIData.NumDownProb;
			Debug("index:" $ string(Index) @ string(currentOptionData.RangeMin) @ string(currentOptionData.RangeMax));

			if((currentOptionData.RangeMin == -1) && currentOptionData.RangeMax == -1)
			{
				return false;
			}
			Fee = o_data.NumDownProbFee;
			Prob = int(currentOptionData.Prob);
			probString = string(Prob) $ "%";
			bUseCondition = GetUseCondition(currentOptionData.RangeMin, currentOptionData.RangeMax);
			UseCondition = GetUseConditionString(currentOptionData.RangeMin, currentOptionData.RangeMax);
			break;
		case 5:
			Title = GetSystemString(13987);
			currentOptionData = UIData.NumProtectProb;

			if(currentOptionData.RangeMin == -1 && currentOptionData.RangeMax == -1)
			{
				return false;
			}
			Fee = o_data.NumProtectProbFee;
			Prob = int(currentOptionData.Prob);
			probString = string(Prob) $ "%";
			bUseCondition = GetUseCondition(currentOptionData.RangeMin, currentOptionData.RangeMax);
			UseCondition = GetUseConditionString(currentOptionData.RangeMin, currentOptionData.RangeMax);
			break;
	}
	Record.cellDataList.Length = 5;

	if(bUseCondition)
	{
		TextColor = getInstanceL2Util().White;
		Record.nReserved2 = 1;		
	}
	else
	{
		TextColor = getInstanceL2Util().DarkGray;
		Record.nReserved2 = 0;
	}
	addRichListCtrlString(Record.cellDataList[0].drawitems, Title, TextColor);
	Record.cellDataList[1].nReserved1 = Prob;
	addRichListCtrlString(Record.cellDataList[1].drawitems, probString, TextColor);
	addRichListCtrlString(Record.cellDataList[2].drawitems, UseCondition, TextColor);
	addRichListCtrlString(Record.cellDataList[3].drawitems, string(Fee), TextColor);

	if(bUseCondition)
	{
		addRichListCtrlTexture(Record.cellDataList[3].drawitems, "L2UI_NewTex.ItemEnchantWnd.EnchantPointIcon", 20, 20, 5, -3);		
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[3].drawitems, "L2UI_NewTex.ItemEnchantWnd.EnchantPointIcon_disable", 20, 20, 5, -3);
	}
	Record.cellDataList[3].nReserved1 = Fee;
	addRichListCtrlString(Record.cellDataList[4].drawitems, (string(ticket) $ "/") $ string(o_data.MaxTicketCharge), TextColor);
	Record.cellDataList[4].nReserved1 = ticket;

	if(SelectedSystemSupport == supportSystemList.GetRecordCount())
	{
		Record.sOverlayTex = "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_KeyCollectionBg";
		Record.OverlayTexU = 510;
		Record.OverlayTexV = 24;
	}
	Record.nReserved1 = Index;
	return true;
}

function int GetSelectedSystemSupportIndex()
{
	local RichListCtrlRowData Record;

	supportSystemList.GetRec(SelectedSystemSupport, Record);
	return int(Record.nReserved1);
}

/********************************************************************************************
 * јоЗО°Є јјЖГ
 * ******************************************************************************************/
function SetIsShopping(bool isShopping)
{
	bIsShopping = isShopping;
}

/**
 * А©µµїм ESC Е°·О ґЭ±в Гіё® 
 * "Esc" Key
 ***/
event OnReceivedCloseUI()
{
	if(DialogIsMine() && class'DialogBox'.static.Inst().m_hOwnerWnd.IsShowWindow())
	{
		DialogHide();
		DialogResultCancel();
		return;
	}
	else if(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd").IsShowWindow())
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd").HideWindow();
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectBTN_Text").SetText(GetSystemString(1797));
		return;
	}

	switch(GetStateName())
	{
		case 'stateEnchant':
			HandleClickButtonEnchant();
			break;

		default:
			PlayConsoleSound(IFST_WINDOW_CLOSE);

			if(supportItemListWnd.IsShowWindow())
			{
				supportItemListWnd.HideWindow();
			}
			else
			{
				if(supportSystemListWnd.IsShowWindow())
				{
					supportSystemListWnd.HideWindow();
				}
				else
				{
					m_hOwnerWnd.HideWindow();
				}
			}
			break;
	}
}

auto state stateNone
{
	function BeginState()
	{
		EnchantBtn.DisableWindow();
		EnchantBtnAuto.HideWindow();
		resetBtn.DisableWindow();
		scrollItemWindow.Clear();
		equipmentItemWindow.Clear();
		supportItemWindow.Clear();
		EnchantEffectViewport.SpawnEffect("");
		GotoState('stateReadyScroll');
		scrollItemNum.HideWindow();		
	}

	function EndState()
	{
		PrevState = GetStateName();
	}
}

state stateReadyScroll
{
	function BeginState()
	{
		isAutoEnchantingStop = false;
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMultiEnchantWndTap_Btn").EnableWindow();
		scrollItemWindow.Clear();
		equipmentItemWindow.Clear();
		supportItemWindow.Clear();
		EnchantEffectViewport.SpawnEffect("");
		GetSlotAniStop("scrollItemWnd");
		GetSlotAniStop("equipmentItemWnd");
		GetSlotAniStop("supportItemWnd");
		GetSlotAniStop("supportSystemWnd");
		GetSupportActiveAniStop("stone");
		GetSupportActiveAniStop("system");
		EnchantBtn.DisableWindow();
		SetNormalMode();
		EnchantBtn.SetNameText(GetSystemString(13935));
		resetBtn.DisableWindow();
		InstructionTxt.SetText(GetSystemMessage(4146));
		WarningTxt00.SetText("");
		WarningTxt01.SetText("");
		EnchantedItemSlot.Clear();
		supportItemWindow.Clear();
		class'ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemWnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Fail_Wnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.ResultScreenFence_Wnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd.supportSystemSelectedWnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd").HideWindow();
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectBTN_Text").SetText(GetSystemString(1797));
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffect_BTN").DisableWindow();
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".StoneActiveAni").HideWindow();
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".systemActiveAni").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ProbWnd").HideWindow();
		supportItemListWnd.HideWindow();
		supportSystemListWnd.HideWindow();
		supportSystemActiveImage.HideWindow();
		class'ItemEnchantSubWnd'.static.Inst().Refresh();
		groupIDWndScr._SetCurrentGroupID(-1);
		scrollItemNum.HideWindow();		
	}

	function EndState()
	{
		PrevState = GetStateName();
	}
}

state stateReadyEquipment
{
	function BeginState()
	{
		equipmentItemWindow.Clear();
		supportItemWindow.Clear();
		EnchantedItemSlot.Clear();
		EnchantEffectViewport.SpawnEffect("");
		GetSlotAniStop("equipmentItemWnd");
		GetSlotAniStop("supportItemWnd");
		GetSlotAniStop("supportSystemWnd");
		GetSupportActiveAniStop("stone");
		GetSupportActiveAniStop("system");
		class'ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemWnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Fail_Wnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.ResultScreenFence_Wnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd.supportSystemSelectedWnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd").HideWindow();
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectBTN_Text").SetText(GetSystemString(1797));
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffect_BTN").DisableWindow();
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".StoneActiveAni").HideWindow();
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".systemActiveAni").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ProbWnd").HideWindow();
		supportItemListWnd.HideWindow();
		supportSystemListWnd.HideWindow();
		supportSystemActiveImage.HideWindow();
		class'ItemEnchantSubWnd'.static.Inst().Refresh();
		SelectedSystemSupport = -1;
		EnchantBtn.DisableWindow();
		EnchantBtn.SetNameText(GetSystemString(13935));
		SetNormalMode();
		HandleInstructionTxt();
		WarningTxt00.SetText("");
		WarningTxt01.SetText("");
		GetSlotAniPlay("scrollItemWnd");
		resetBtn.EnableWindow();
		groupIDWndScr._SetCurrentGroupID(-1);
		scrollItemNum.HideWindow();
	}

	function EndState()
	{
		PrevState = GetStateName();
	}
}

state stateReadySupport
{
	function BeginState()
	{
		isAutoEnchantingStop = false;
		EnchantBtn.EnableWindow();
		GetSlotAniPlay("scrollItemWnd");
		GetSlotAniPlay("equipmentItemWnd");
		GetSlotAniStop("supportItemWnd");
		GetSlotAniStop("supportSystemWnd");
		GetSupportActiveAniStop("stone");
		GetSupportActiveAniStop("system");
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".StoneActiveAni").HideWindow();
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".systemActiveAni").HideWindow();
		SetSupportSystemList();
		API_RequestExRemoveEnchantSupportItem();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd.supportSystemSelectedWnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffect_BTN").EnableWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ProbWnd").ShowWindow();
		CheckWarningTxt();
		CheckSupports();
		ChangeEquipmentAni();

		if(CanUseAutoMode())
		{
			SetAutoMode();
		}
		else
		{
			SetNormalMode();
		}
		scrollItemNum.HideWindow();
	}

	function EndState()
	{
		PrevState = GetStateName();
	}

	function HandleClickButtonEnchant()
	{
		CheckEnchantNEncht();
	}
}

state stateReadySupportsystem
{
	function BeginState()
	{
		GetSlotAniPlay("scrollItemWnd");
		GetSlotAniPlay("equipmentItemWnd");
		GetSlotAniStop("supportItemWnd");
		GetSlotAniPlay("supportSystemWnd");
		GetSupportActiveAniPlay("system");
		GetSupportActiveAniStop("stone");
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".StoneActiveAni").HideWindow();
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".systemActiveAni").ShowWindow();
		supportSystemActiveImage.ShowWindow();
		EnchantBtn.EnableWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd.supportSystemSelectedWnd").ShowWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffect_BTN").EnableWindow();
		scrollItemNum.HideWindow();		
	}

	function EndState()
	{
		supportSystemActiveImage.HideWindow();
		PrevState = GetStateName();
		supportItemListWnd.HideWindow();
		supportSystemListWnd.HideWindow();
	}

	function HandleClickButtonEnchant()
	{
		CheckEnchantNEncht();
	}
}

state stateReadySupportstone
{
	function BeginState()
	{
		CheckWarningTxt();
		GetSlotAniPlay("scrollItemWnd");
		GetSlotAniPlay("equipmentItemWnd");
		GetSlotAniPlay("supportItemWnd");
		GetSlotAniStop("supportSystemWnd");
		GetSupportActiveAniPlay("stone");
		GetSupportActiveAniStop("system");
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".StoneActiveAni").ShowWindow();
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".systemActiveAni").HideWindow();
		EnchantBtn.EnableWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffect_BTN").EnableWindow();
		scrollItemNum.HideWindow();
	}

	function EndState()
	{
		PrevState = GetStateName();
		supportItemListWnd.HideWindow();
		supportSystemListWnd.HideWindow();
	}

	function HandleClickButtonEnchant()
	{
		CheckEnchantNEncht();
	}
}

state stateEnchant
{
	function BeginState()
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMultiEnchantWndTap_Btn").DisableWindow();
		class'ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.HideWindow();
		HandleInstructionTxt();
		EnchantEffectViewport.SetCameraDistance(175.0f);
		timerObject._DelegateOnEnd = RequestEnchant;

		if(isAutoEnchanting)
		{
			EnchantEffectViewport.SetScale(0.20f);
			timerObject._time = 600;
			EnchantBtn.DisableWindow();
			EnchantBtnAuto.SetNameText(GetSystemString(14238));
			StartAutoEnchant();
			scrollItemNum.ShowWindow();
		}
		else
		{
			EnchantEffectViewport.SetScale(1.0f);
			EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_start");
			PlaySound("Itemsound3.ui_enchant_start");
			PlaySound("Itemsound3.ui_enchant_start_sfx");
			EnchantBtn.EnableWindow();
			EnchantBtn.SetNameText(GetSystemString(13936));
			EnchantBtnAuto.DisableWindow();
			timerObject._time = 1500;
			timerObject._Play();
		}
		EnchantEffectViewport.SetFocus();
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffect_BTN").DisableWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd").HideWindow();
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectBTN_Text").SetText(GetSystemString(1797));
		supportItemListWnd.HideWindow();
	}

	function EndState()
	{
		SetNormalMode();
		EnchantBtn.SetNameText(GetSystemString(13935));
		PrevState = GetStateName();
		EnchantEffectViewport.SpawnEffect("");
		timerObject._Stop();
		resetBtn.EnableWindow();
		isAutoEnchanting = false;
	}

	function HandleClickButtonEnchant()
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMultiEnchantWndTap_Btn").EnableWindow();
		class'ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.ShowWindow();

		if(isAutoEnchanting)
		{
			isAutoEnchantingStop = true;
			InstructionTxt.SetText(GetSystemString(14239));
		}
		else
		{
			GotoState(PrevState);
			HandleInstructionTxt();
		}
	}
}

state stateCompleteBlind
{
	function BeginState()
	{
		SelectedSystemSupport = -1;
		Debug(" 스테이트 네임 stateCompleteBlind -------- ");
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd").ShowWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.ResultScreenFence_Wnd").ShowWindow();
		HandleInstructionTxt();
		EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_screen");
		EnchantEffectViewport.SetScale(1.340f);
		EnchantEffectViewport.SetCameraDistance(222.0f);
		EnchantEffectViewport.SetFocus();
		EnchantBtn.SetNameText(GetSystemString(140));
		resetBtn.DisableWindow();
		groupIDWndScr._SetDisable();
		PlaySound("Itemsound3.ui_enchant_screen");
	}

	function EndState()
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.ResultScreenFence_Wnd").HideWindow();
		PrevState = GetStateName();
		EnchantEffectViewport.SpawnEffect("");
		resetBtn.EnableWindow();
		groupIDWndScr._SetEnable();
	}

	function HandleClickButtonEnchant()
	{
		API_C_EX_REQ_VIEW_ENCHANT_RESULT();
		GotoState(resultState);
	}
}

state stateCompleteResult
{
	function BeginState()
	{
		isAutoEnchanting = false;
		isAutoEnchantingStop = false;
		SelectedSystemSupport = -1;
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMultiEnchantWndTap_Btn").EnableWindow();
		EnchantEffectViewport.SetScale(1.0f);
		switch(EEtcItemType(GetIteminfoScroll().EtcItemType))
		{
			case ITEME_CURSED_ENCHANT_WP:
			case ITEME_CURSED_ENCHANT_AM:
				EnchantEffectViewport.SetCameraDistance(160.0f);
				EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_fail");
				PlaySound("Itemsound3.ui_enchant_fail");
				PlaySound("Itemsound3.ui_enchant_fail_sfx");
				break;

			default:
				EnchantEffectViewport.SetCameraDistance(175.0f);

				if(isGreateSuccess)
				{
					EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_great_success");
					PlaySound("Itemsound3.ui_enchant_great_success");
					PlaySound("Itemsound3.ui_enchant_success_sfx");
				}
				else
				{
					EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_success");
					PlaySound("Itemsound3.ui_enchant_success");
					PlaySound("Itemsound3.ui_enchant_success_sfx");
				}
				break;
		}
		EnchantEffectViewport.SetFocus();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd").ShowWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.NextEnchantFail_Text").ShowWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd").ShowWindow();
		HandleInstructionTxt();
		EnchantBtn.EnableWindow();
		EnchantBtn.SetNameText(GetSystemString(3135));
		SetNormalMode();
	}

	function EndState()
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd").HideWindow();
		PrevState = GetStateName();
		EnchantEffectViewport.SpawnEffect("");
	}

	function HandleClickButtonEnchant()
	{
		class'ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
		ChkEnchantContinue();
	}
}

state stateCompleteResultfail
{
	function BeginState()
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMultiEnchantWndTap_Btn").EnableWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd").ShowWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Fail_Wnd").ShowWindow();
		HandleInstructionTxt();
		EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_fail");
		PlaySound("Itemsound3.ui_enchant_fail");
		PlaySound("Itemsound3.ui_enchant_fail_sfx");
		EnchantEffectViewport.SetScale(1.0f);
		EnchantEffectViewport.SetCameraDistance(160.0f);
		EnchantEffectViewport.SetFocus();
		EnchantBtn.EnableWindow();
		EnchantBtn.SetNameText(GetSystemString(3135));
		SetNormalMode();
		CheckEmptyFailItemInfoToList();
	}

	function EndState()
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Fail_Wnd").HideWindow();
		PrevState = GetStateName();
		EnchantEffectViewport.SpawnEffect("");
	}

	private function bool IsCanContinueEEtcTypeScroll()
	{
		switch(EEtcItemType(GetIteminfoScroll().EtcItemType))
		{
			case ITEME_BLESS_ENCHT_WP:
			case ITEME_BLESS_ENCHT_AM:
			case ITEME_BLESS_ENCHT_AG:
			case ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM:
			case ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP:
			case ITEME_ANCIENT_CRYSTAL_ENCHANT_AG:
				return true;
		}
		return false;
	}

	function HandleClickButtonEnchant()
	{
		local ItemInfo iInfo;
		local bool bScroll;

		if(getInstanceUIData().getIsLiveServer())
		{
			if(IsCanContinueEEtcTypeScroll())
			{
				if(ChkEnchantContinue())
				{
					return;
				}
			}
		}

		bScroll = RefreshScroll(iInfo);

		if(supportItemWindow.GetItemNum() > 0)
		{
			API_RequestExRemoveEnchantSupportItem();
		}

		if(SelectedSystemSupport > -1)
		{
			API_C_EX_RESET_ENCHANT_CHALLENGE_POINT();
		}
		GotoState('stateReadyScroll');
		API_RequestExCancelEnchantItem();

		if(bScroll)
		{
			Debug("HandleClickButtonEnchant refresh Ok");
			API_RequestExAddEnchantScrollItem(iInfo);
		}
	}
}

defaultproperties
{
}
