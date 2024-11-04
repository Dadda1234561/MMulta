class ItemMultiEnchantWnd extends UICommonAPI;

const STATE_NONE = 'stateNone';
const STATE_READY_SCROLL = 'stateReadyScroll';
const STATE_READY_EQUIPMENT = 'stateReadyEquipment';
const STATE_ENCHANT = 'stateEnchant';
const STATE_COMPLETE_BLIND = 'stateCompleteBlind';
const STATE_COMPLETE_RESULT = 'stateCompleteResult';
const TIME_EMPTY = 500;
const TIME_ACTIVE = 2000;
const MAX_SLOT = 15;
const MAX_TRY = 50;
const PERMRIAD = 100;

enum slotRequestedType 
{
	Add,
	Remove,
	Refresh
};

enum slotStateEnum 
{
	non,
	active,
	resultSuccess,
	resultFail
};

enum slotProgress 
{
	non,
	Gray,
	Blue,
	Red
};

struct requestedEquipmentItemInfoStruct
{
	var slotRequestedType Type;
	var int Index;
	var ItemInfo iInfo;
};

var name PrevState;
var TextBoxHandle InstructionTxt;
var ButtonHandle EnchantBtn;
var ButtonHandle resetBtn;
var ItemWindowHandle scrollItemWindow;
var RichListCtrlHandle resultFailList_RichList;
var EffectViewportWndHandle EnchantEffectViewport;
var bool bUseLateAnnounce;
var requestedEquipmentItemInfoStruct requestedEqupmentItemInfo;
var L2UITimerObject timerObj;
var array<ItemInfo> failedItemList;
var array<ItemInfo> changePointList;
var int currentEnchantTarget;
var EnchantScrollSetUIData enchantScrollData;
var array<slotStateEnum> slotStates;
var array<slotProgress> slotProgresss;
var UIControlNumberInputSteper numberInputStepper;
var ItemEnchantGroupIDWnd groupIDWndScr;

function HandleClickButtonEnchant()
{}

static function ItemMultiEnchantWnd Inst()
{
	return ItemMultiEnchantWnd(GetScript("ItemMultiEnchantWnd"));
}

function InitUIControlNumberInputSteper()
{
	numberInputStepper = class'UIControlNumberInputSteper'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.EnchantGoalSet_wndAsset"));
	numberInputStepper.DelegateOnChangeEditBox = ChangeTargetEnchant;
	numberInputStepper.DelegateESCKey = OnReceivedCloseUI;
	numberInputStepper.m_hOwnerWnd.ShowWindow();
	numberInputStepper._SetDisable(true);
	numberInputStepper._setRangeMinMaxNum(0, MAX_TRY);
	numberInputStepper._setMaxLength(2);
}

event OnProgressTimeUp(string strID)
{
	EndProgress();
}

event OnLoad()
{
	SetClosingOnESC();
	InitUIControlNumberInputSteper();
	slotStates.Length = MAX_SLOT;
	slotProgresss.Length = MAX_SLOT;
	scrollItemWindow = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.ScrollItem_ItemWnd");
	resultFailList_RichList = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultFailItem_Wnd.resultFailList_RichList");
	InstructionTxt = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSlot_Wnd.Descrip_text");
	EnchantBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Enchant_Btn");
	resetBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Reset_Btn");
	numberInputStepper._setEditNum(1);
	currentEnchantTarget = 1;
	EnchantEffectViewport = GetEffectViewportWndHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectViewport");
	EnchantEffectViewport.SetCameraPitch(0);
	EnchantEffectViewport.SetCameraYaw(0);
	SetGrouIDWnd();
	GotoState(STATE_NONE);
	timerObj = class'L2UITimer'.static.Inst()._AddNewTimerObject(TIME_ACTIVE);
	timerObj._DelegateOnEnd = DelayGotoToStateCompleteREsult;
}

function SetGrouIDWnd()
{
	groupIDWndScr = ItemEnchantGroupIDWnd(GetScript("GroupIDWnd_ItemMultiEnchantWnd"));
	groupIDWndScr._Init();
}

event OnRegisterEvent()
{
	RegisterEvent(EV_Die);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_RES_SELECT_MULTI_ENCHANT_SCROLL));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_RES_SET_MULTI_ENCHANT_ITEM_LIST));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_RES_MULTI_ENCHANT_ITEM_LIST));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST));
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		// End:0x1E
		case EV_Die:
			m_hOwnerWnd.HideWindow();
			// End:0xA1
			break;
		// End:0x3E
		case EV_PacketID(class'UIPacket'.const.S_EX_RES_SELECT_MULTI_ENCHANT_SCROLL):
			RT_S_EX_RES_SELECT_MULTI_ENCHANT_SCROLL();
			// End:0xA1
			break;
		// End:0x5E
		case EV_PacketID(class'UIPacket'.const.S_EX_RES_SET_MULTI_ENCHANT_ITEM_LIST):
			RT_S_EX_RES_SET_MULTI_ENCHANT_ITEM_LIST();
			// End:0xA1
			break;
		// End:0x7E
		case EV_PacketID(class'UIPacket'.const.S_EX_RES_MULTI_ENCHANT_ITEM_LIST):
			RT_S_EX_RES_MULTI_ENCHANT_ITEM_LIST();
			// End:0xA1
			break;
		// End:0x9E
		case EV_PacketID(class'UIPacket'.const.S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST):
			RT_S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST();
			// End:0xA1
			break;
	}
}

event OnDropItemWithHandle(WindowHandle hTarget, ItemInfo infItem, int X, int Y)
{
	switch(infItem.DragSrcName)
	{
		// End:0x37
		case "itemEnchantSubWndItemWnd":
			_HandleOnDrop(infItem);
			// End:0x62
			break;
		// End:0x5F
		case "Enchant_ItemWnd":
			OnDBClickItemWithHandle(ItemWindowHandle(hTarget), 0);
			// End:0x62
			break;
	}
}

event OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	OnDBClickItemWithHandle(a_hItemWindow, a_Index);
}

event OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	// End:0x4D
	if(GetStateName() == STATE_READY_EQUIPMENT)
	{
		// End:0x4D
		if(a_hItemWindow.GetWindowName() == "Enchant_ItemWnd")
		{
			ClearItem(int(Right(a_hItemWindow.GetParentWindowName(), 2)));
		}
	}
}

function _HandleOnDrop(ItemInfo a_itemInfo)
{
	switch(GetStateName())
	{
		// End:0x1B
		case STATE_READY_SCROLL:
			RQ_C_EX_REQ_START_MULTI_ENCHANT_SCROLL(a_itemInfo);
			// End:0x34
			break;
		// End:0x31
		case STATE_READY_EQUIPMENT:
			SetSlotEmpty(a_itemInfo);
			// End:0x34
			break;
	}
}

event OnClickButton(string strID)
{
	Debug("OnClickButton" @ strID);
	switch(strID)
	{
		// End:0x3C
		case "Enchant_Btn":
			HandleClickButtonEnchant();
			// End:0xDE
			break;
		// End:0x6F
		case "Reset_Btn":
			// End:0x65
			if(class'UICommonAPI'.static.DialogIsOwnedBy(string(self)))
			{
				DialogHide();
			}
			GotoState(STATE_READY_SCROLL);
			// End:0xDE
			break;
		// End:0x92
		case "ItemEnchantWndTap_Btn":
			SwapItemEnchantWnd();
			// End:0xDE
			break;
		// End:0xB8
		case "point_btn":
			groupIDWndScr._ToggleShowHide();
			ChkWindowSizeGroupID();
			// End:0xDE
			break;
		// End:0xDB
		case "WndClose_BTN":
			m_hOwnerWnd.HideWindow();
			// End:0xDE
			break;
	}
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	m_hOwnerWnd.SetFocus();
	GotoState(STATE_READY_SCROLL);
	switch(DialogGetID())
	{
		// End:0x3F
		case 1111:
		// End:0x47
		case 2222:
		// End:0x4F
		case 3333:
		// End:0x57
		case 4444:
		// End:0x5F
		case 5555:
		// End:0x67
		case 6666:
		// End:0x6F
		case 7777:
		// End:0x77
		case 8888:
		// End:0x7F
		case 9998:
		// End:0x87
		case 9999:
		// End:0x98
		case 10000:
			DialogHide();
			// End:0x9B
			break;
	}
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemEnchantWndTap_Btn").EnableWindow();
	GetEffectViewportWndHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollBG_EffectViewport").SpawnEffect("LineageEffect2.ui_Enchant_item_select");
	groupIDWndScr._CheckShowHide();
	m_hOwnerWnd.SetWindowSize(858, 542);
	ChkWindowSizeGroupID();
	numberInputStepper._setEditNum(1);
	m_hOwnerWnd.DisableTick();
	StopProgress();
}

function ChkWindowSizeGroupID()
{
	// End:0x55
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
	GotoState(STATE_NONE);
	RQ_C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL();
	numberInputStepper._SetDisable(true);
	// End:0x4C
	if(DialogIsMine())
	{
		DialogHide();
	}
}

event OnTick()
{
	currentEnchantTarget++;
	StartProgress();
	m_hOwnerWnd.DisableTick();
}

function HandleShowDialog()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetFailString() $ "\\n\\n" $ GetSystemString(2336), string(self));
	class'DialogBox'.static.Inst().AnchorToOwner(0, 200);
	class'DialogBox'.static.Inst().DelegateOnCancel = DialogResultCancel;
	class'DialogBox'.static.Inst().DelegateOnOK = DialogResultOK;
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
}

function DialogResultOK()
{
	GotoState(STATE_ENCHANT);
}

function DialogResultCancel()
{
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Dialog_Wnd").HideWindow();
	m_hOwnerWnd.SetFocus();
	resetBtn.EnableWindow();
	EnchantBtn.EnableWindow();
}

function string GetFailString()
{
	local int i;
	local string crashString;
	local array<string> crashStrings;

	// End:0x141
	if(IsBreakable())
	{
		// End:0x2A
		if(IsFailureCrush())
		{
			crashStrings[crashStrings.Length] = GetSystemString(3338);
		}
		// End:0x4B
		if(IsFailureMaintain())
		{
			crashStrings[crashStrings.Length] = GetSystemString(2275);
		}
		// End:0x79
		if(crashStrings.Length == 0 && GetFailureDecrease() == 0)
		{
			crashString = GetSystemMessage(4144);			
		}
		else
		{
			crashString = crashStrings[0];

			// End:0xC4 [Loop If]
			for(i = 1; i < crashStrings.Length; i++)
			{
				crashString = (crashString $ ",") @ crashStrings[i];
			}
			// End:0xEF
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

function RemoveFailedItems()
{
	local int i;
	local ItemInfo iInfo;
	local string Path;

	// End:0xE0 [Loop If]
	for(i = 0; i < MAX_SLOT; i++)
	{
		// End:0x2B
		if(! GetItemInfoEquipment(i, iInfo))
		{
			// [Explicit Continue]
			continue;
		}
		// End:0xD6
		if(slotStates[i] == resultFail)
		{
			Path = getSlotPath(i);
			GetAnimTextureHandle(Path $ ".EnchantSlotProgress_ani").HideWindow();
			GetItemWindowHandle(Path $ ".Enchant_ItemWnd").Clear();
			GetTextBoxHandle(Path $ ".probability_text").HideWindow();
		}
	}
}

function StartProgress()
{
	local ProgressCtrlHandle StepBar_Progress;

	// End:0x16
	if(! m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	Debug("StartProgress: " @ string(currentEnchantTarget));
	SetCurrentProgress();
	StepBar_Progress = GetProgressCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.StepBar_Progress");
	// End:0xC8
	if(IsInActive())
	{
		PlaySound("Itemsound3.ui_multienchant_progress");
		StepBar_Progress.SetProgressTime(TIME_ACTIVE);		
	}
	else
	{
		PlaySound("Itemsound3.ui_multienchant_progresss_short");
		StepBar_Progress.SetProgressTime(TIME_EMPTY);
	}
	StepBar_Progress.Reset();
	StepBar_Progress.Start();
}

function SetCurrentProgress()
{
	local int i;
	local ItemInfo iInfo;

	Debug("SetCurrentProgress : " @ string(currentEnchantTarget));
	SetCurrentEnchantTarget(currentEnchantTarget);

	// End:0x91 [Loop If]
	for(i = 0; i < MAX_SLOT; i++)
	{
		// End:0x5C
		if(! GetItemInfoEquipment(i, iInfo))
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x75
		if(slotStates[i] == resultFail)
		{
			// [Explicit Continue]
			continue;
		}
		SetSlotState(i, slotStateEnum.active/*1*/, iInfo);
	}
}

function EndProgress()
{
	StopProgress();
	// End:0x5C
	if(IsInActive())
	{
		RQ_C_EX_REQ_MULTI_ENCHANT_ITEM_LIST();
		GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.NextStepAni_tex").Play();		
	}
	else
	{
		m_hOwnerWnd.EnableTick();
	}
}

function StopProgress()
{
	GetProgressCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.StepBar_Progress").Reset();
}

function ResetProgressStates()
{
	local int i;

	// End:0x2B [Loop If]
	for(i = 0; i < MAX_SLOT; i++)
	{
		slotProgresss[i] = non;
	}
}

function SwapItemEnchantWnd()
{
	local ItemInfo iInfo;

	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "ItemEnchantWnd");
	GetWindowHandle("ItemEnchantWnd").ShowWindow();
	m_hOwnerWnd.HideWindow();
	// End:0x84
	if(GetIteminfoScroll(iInfo))
	{
		class'ItemEnchantWnd'.static.Inst().API_RequestExAddEnchantScrollItem(iInfo);
	}	
}

function bool IsGreateSuccessEffect(int targetEnchant)
{
	// End:0x18
	if(enchantScrollData.GreatSuccessEffect == -1)
	{
		return false;
	}
	return enchantScrollData.GreatSuccessEffect <= targetEnchant;
}

function bool IsSuccess()
{
	local int i;

	// End:0x34 [Loop If]
	for(i = 0; i < MAX_SLOT; i++)
	{
		switch(slotStates[i])
		{
			// End:0x27
			case resultSuccess:
				return true;
		}
	}
	return false;
}

function bool IsBreakable()
{
	return numberInputStepper._getEditNum() > (GetFailureBase());
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
	local ItemInfo iInfo;
	scrollItemWindow.GetItem(0, iInfo);
	if (iInfo.Id.ClassID == 90995) {
		return true;
	}	
	
	return enchantScrollData.FailureCrush;
}

function bool IsActive(int Index)
{
	local ItemInfo iInfo;

	// End:0x17
	if(! GetItemInfoEquipment(Index, iInfo))
	{
		return false;
	}
	return iInfo.Enchanted < currentEnchantTarget;
}

function bool IsInActive()
{
	local int i;

	// End:0x2D [Loop If]
	for(i = 0; i < MAX_SLOT; i++)
	{
		// End:0x23
		if(IsActive(i))
		{
			return true;
		}
	}
	return false;
}

function bool canEnchant()
{
	local int equipmentCount, needScrollNum;
	local ItemInfo iInfo;

	switch(GetStateName())
	{
		// End:0x0D
		case STATE_READY_EQUIPMENT:
		// End:0x18
		case STATE_ENCHANT:
			// End:0x1D
			break;
		// End:0xFFFF
		default:
			return false;
			break;
	}
	equipmentCount = GetEquipmentsCount();
	// End:0x36
	if(equipmentCount == 0)
	{
		return false;
	}
	// End:0x48
	if(! GetIteminfoScroll(iInfo))
	{
		return false;
	}
	// End:0x5D
	if(iInfo.ItemNum == 0)
	{
		return false;
	}
	needScrollNum = GetNeedScrollNum(numberInputStepper._getEditNum());
	// End:0x91
	if(iInfo.ItemNum < needScrollNum)
	{
		return false;
	}
	// End:0x9E
	if(needScrollNum == 0)
	{
		return false;
	}
	return true;
}

function bool IsSafe(int Enchanted)
{
	return Enchanted < (GetFailureBase());
}

function int GetCanMaxTryNum()
{
	local ItemInfo scrolliInfo;
	local int i, j, needScrollNum, needScrollNumTotal;
	local array<ItemInfo> iInfos;
	local int trymaxnum;

	// End:0x12
	if(! GetIteminfoScroll(scrolliInfo))
	{
		return 0;
	}
	trymaxnum = Min(GetEnchantMax() + 1, MAX_TRY);
	iInfos = GetItemInfoEquipments();

	// End:0xCC [Loop If]
	for(i = 1; i <= trymaxnum; i++)
	{
		needScrollNum = 0;

		// End:0x90 [Loop If]
		for(j = 0; j < iInfos.Length; j++)
		{
			// End:0x86
			if(iInfos[j].Enchanted < i)
			{
				needScrollNum++;
			}
		}
		needScrollNumTotal = needScrollNumTotal + needScrollNum;
		// End:0xC2
		if(scrolliInfo.ItemNum < needScrollNumTotal)
		{
			return i - 1;
		}
	}
	return trymaxnum;
}

function int GetNeedScrollNum(int targetEnchant, optional bool bLimit)
{
	local int i, j, needScrollNum, needScrollNumTotal;
	local array<ItemInfo> iInfos;

	iInfos = GetItemInfoEquipments();

	// End:0x87 [Loop If]
	for(i = 1; i <= targetEnchant; i++)
	{
		needScrollNum = 0;

		// End:0x6B [Loop If]
		for(j = 0; j < iInfos.Length; j++)
		{
			// End:0x61
			if(iInfos[j].Enchanted < i)
			{
				++ needScrollNum;
			}
		}
		needScrollNumTotal = needScrollNumTotal + needScrollNum;
	}
	return needScrollNumTotal;
}

function int GetEquipmentsCount()
{
	local int i, Count;

	// End:0x72 [Loop If]
	for(i = 0; i < MAX_SLOT; i++)
	{
		// End:0x2C
		if(slotStates[i] == resultFail)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x68
		if(GetItemWindowHandle(getSlotPath(i) $ ".Enchant_ItemWnd").GetItemNum() == 1)
		{
			Count++;
		}
	}
	return Count;
}

function int GetEnchantMax()
{
	local int RangeMax, RangeMin, RandomValue;

	local ItemInfo iInfo;
	scrollItemWindow.GetItem(0, iInfo);
	if (iInfo.Id.ClassID == 90995) {
		return 10 - 1;
	}

	RangeMax = enchantScrollData.EnchantRangeDatas[enchantScrollData.EnchantRangeDatas.Length - 1].RangeMax;
	RangeMin = enchantScrollData.EnchantRangeDatas[enchantScrollData.EnchantRangeDatas.Length - 1].RangeMin;
	RandomValue = enchantScrollData.EnchantRangeDatas[enchantScrollData.EnchantRangeDatas.Length - 1].RandomValue;
	// End:0x9C
	if(RangeMax == -1 && RangeMin == -1 && RandomValue == 1)
	{
		return MAX_TRY;
	}
	return RangeMax;
}

function bool RefreshScroll(out ItemInfo scrolliInfo)
{
	local ItemInfo iInfo;

	// End:0x12
	if(! GetIteminfoScroll(scrolliInfo))
	{
		return false;
	}
	scrollItemWindow.Clear();
	// End:0x4B
	if(! class'UIDATA_INVENTORY'.static.FindItem(scrolliInfo.Id.ServerID, iInfo))
	{
		return false;
	}
	iInfo.bShowCount = true;
	Debug("스크롤 수량 갱신 " @ string(scrolliInfo.ItemNum) @ "->" @ string(iInfo.ItemNum));
	scrollItemWindow.AddItem(iInfo);
	return true;
}

function InputScrollItem(int sID)
{
	local ItemInfo iInfo;

	ClearScroll();
	// End:0x26
	if(! class'UIDATA_INVENTORY'.static.FindItem(sID, iInfo))
	{
		return;
	}
	API_GetEnchantScrollSetData(iInfo);
	iInfo.bShowCount = true;
	scrollItemWindow.AddItem(iInfo);
	GotoState(STATE_READY_EQUIPMENT);
	ClearEquipments();
	PlaySound("Itemsound3.ui_enchant_slot");
}

function ClearScroll()
{
	scrollItemWindow.Clear();
}

function bool GetIteminfoScroll(out ItemInfo iInfo)
{
	return scrollItemWindow.GetItem(0, iInfo);
}

function HandleRequestedEquipment()
{
	switch(requestedEqupmentItemInfo.Type)
	{
		// End:0x1A
		case slotRequestedType.Add/*0*/:
			InputEquipmentItem();
			// End:0x38
			break;
		// End:0x28
		case slotRequestedType.Remove/*1*/:
			ClearEquipmentItem();
			// End:0x38
			break;
		// End:0x35
		case slotRequestedType.Refresh/*2*/:
			RefreshActiveItem();
			return;
		// End:0xFFFF
		default:
			break;
	}
	AddCurrentGroupIDs();
	SyncProgressAnis();
	SetNeedScrollNum();
	numberInputStepper._setRangeMinMaxNum(1, GetCanMaxTryNum());
	class'ItemMultiEnchantSubWnd'.static.Inst().Refresh();
}

function AddCurrentGroupIDs()
{
	local int i;
	local array<ItemInfo> iInfos;

	groupIDWndScr._HideCurrentGroupID();
	iInfos = GetItemInfoEquipments();

	// End:0x66 [Loop If]
	for(i = 0; i < iInfos.Length; i++)
	{
		groupIDWndScr._AddCurrentGroupID(API_GetChallengePointGroupID(iInfos[i].Id.ClassID));
	}
}

function InputEquipmentItem()
{
	PlaySound("Itemsound3.ui_enchant_slot");
	SetSlotState(requestedEqupmentItemInfo.Index, slotStateEnum.active/*1*/, requestedEqupmentItemInfo.iInfo);
	GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.PrvStepAni_tex").Stop();
	GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.PrvStepAni_tex").Play();
}

function ClearEquipments()
{
	local int i;

	// End:0x2A [Loop If]
	for(i = 0; i < MAX_SLOT; i++)
	{
		SetSlotState(i, non);
	}
	groupIDWndScr._HideCurrentGroupID();
}

function SetSlotEmpty(ItemInfo iInfo)
{
	local int Index;
	local ItemInfo scrollInfo;

	// End:0x36
	if(! GetIteminfoScroll(scrollInfo))
	{
		class'L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13648));
		return;
	}
	// End:0x80
	if(scrollInfo.ItemNum / Max(1, GetEquipmentsCount() + 1) < 1)
	{
		class'L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13648));
		return;
	}
	Index = GetSlotEmpty();
	// End:0xC1
	if(Index == -1)
	{
		class'L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13647));
		return;
	}
	requestedEqupmentItemInfo.Type = Add;
	requestedEqupmentItemInfo.Index = Index;
	requestedEqupmentItemInfo.iInfo = iInfo;
	RQ_C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST();
}

function ClearEquipmentItem()
{
	local int Index;
	local ItemInfo iInfo, eiInfo;

	Index = requestedEqupmentItemInfo.Index;
	// End:0x28
	if(slotStates[Index] == non)
	{
		return;
	}
	SetSlotState(Index, non);

	// End:0xA1 [Loop If]
	for(Index = Index; Index < MAX_SLOT - 1; Index++)
	{
		iInfo = eiInfo;
		// End:0x75
		if(! GetItemInfoEquipment(Index + 1, iInfo))
		{
			// [Explicit Break]
			break;
		}
		SetSlotState(Index, slotStateEnum.active/*1*/, iInfo);
		SetSlotState(Index + 1, non);
	}
}

function ClearItem(int Index)
{
	local ItemInfo iInfo;

	// End:0x18
	if(slotStates[Index] == non)
	{
		return;
	}
	// End:0x2F
	if(! GetItemInfoEquipment(Index, iInfo))
	{
		return;
	}
	requestedEqupmentItemInfo.Type = Remove;
	requestedEqupmentItemInfo.Index = Index;
	requestedEqupmentItemInfo.iInfo = iInfo;
	RQ_C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST();
}

function RefreshActiveItem()
{
	local int i;
	local ItemInfo iInfo;

	// End:0x79 [Loop If]
	for(i = 0; i < MAX_SLOT; i++)
	{
		// End:0x2C
		if(slotStates[i] == non)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x45
		if(slotStates[i] == resultFail)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x5D
		if(! GetItemInfoEquipment(i, iInfo))
		{
			// [Explicit Continue]
			continue;
		}
		SetSlotState(i, slotStateEnum.active/*1*/, iInfo);
	}
	numberInputStepper._setRangeMinMaxNum(1, GetCanMaxTryNum());
}

function bool ChkEnchantBtn()
{
	// End:0x1D
	if(canEnchant())
	{
		EnchantBtn.EnableWindow();
		return true;		
	}
	else
	{
		EnchantBtn.DisableWindow();
		return false;
	}
}

function int GetSlotEmpty()
{
	local int i;


	// End:0x58 [Loop If]
	for(i = 0; i < MAX_SLOT; i++)
	{
		// End:0x4E
		if(GetItemWindowHandle(getSlotPath(i) $ ".Enchant_ItemWnd").GetItemNum() == 0)
		{
			return i;
		}
	}
	return -1;
}

function ChangeTargetEnchant(UIControlNumberInputSteper Target)
{
	ChkEnchantBtn();
	SetNeedScrollNum();
}

function bool GetItemInfoEquipment(int Index, out ItemInfo iInfo)
{
	return GetItemWindowHandle(getSlotPath(Index) $ ".Enchant_ItemWnd").GetItem(0, iInfo);
}

function SetSlotState(int Index, slotStateEnum slotstate, optional ItemInfo iInfo)
{
	local string slotPath;
	local AnimTextureHandle progressAni, boxAni;
	local ItemWindowHandle ItemWnd;
	local TextBoxHandle probTxt;
	local bool bIsActive;

	slotPath = getSlotPath(Index);
	progressAni = GetAnimTextureHandle(slotPath $ ".EnchantSlotProgress_ani");
	boxAni = GetAnimTextureHandle(slotPath $ ".EnchantSlotBox_ani");
	ItemWnd = GetItemWindowHandle(slotPath $ ".Enchant_ItemWnd");
	GetItemWindowHandle(slotPath $ ".Enchant_ItemWnd").SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	probTxt = GetTextBoxHandle(getSlotPath(Index) $ ".probability_text");
	probTxt.ShowWindow();
	slotStates[Index] = slotstate;
	switch(slotstate)
	{
		// End:0x194
		case slotStateEnum.non/*0*/:
			boxAni.HideWindow();
			progressAni.HideWindow();
			ItemWnd.Clear();
			probTxt.HideWindow();
			progressAni.HideWindow();
			slotProgresss[Index] = non;
			// End:0x554
			break;
		// End:0x3DD
		case slotStateEnum.active/*1*/:
			progressAni.ShowWindow();
			ItemWnd.Clear();
			ItemWnd.AddItem(iInfo);
			bIsActive = IsActive(Index);
			// End:0x270
			if(! bIsActive)
			{
				// End:0x200
				if(slotProgresss[Index] == Gray)
				{
					return;
				}
				probTxt.SetTextColor(class'L2Util'.static.Inst().Gray);
				slotProgresss[Index] = Gray;
				progressAni.SetTexture("L2UI.UISlotEffect.slot_active_gray_0000");				
			}
			else
			{
				// End:0x306
				if(IsSafe(currentEnchantTarget))
				{
					// End:0x296
					if(slotProgresss[Index] == Blue)
					{
						return;
					}
					probTxt.SetTextColor(class'L2Util'.static.Inst().Gray);
					slotProgresss[Index] = Blue;
					progressAni.SetTexture("L2UI.UISlotEffect.slot_active_blue_0000");					
				}
				else
				{
					// End:0x31E
					if(slotProgresss[Index] == Red)
					{
						return;
					}
					probTxt.SetTextColor(class'L2Util'.static.Inst().Yellow);
					probTxt.ShowWindow();
					slotProgresss[Index] = Red;
					progressAni.SetTexture("L2UI.UISlotEffect.slot_active_red_0000");
				}
			}
			progressAni.ShowWindow();
			progressAni.Stop();
			progressAni.SetLoopCount(999999);
			progressAni.Play();
			// End:0x554
			break;
		// End:0x4CC
		case slotStateEnum.resultSuccess/*2*/:
			ItemWnd.Clear();
			ItemWnd.AddItem(iInfo);
			// End:0x454
			if(IsSafe(iInfo.Enchanted))
			{
				boxAni.SetTexture("L2UI.UISlotEffect.slot_success_blue_0000");				
			}
			else
			{
				boxAni.SetTexture("L2UI.UISlotEffect.slot_success_red_0000");
			}
			boxAni.ShowWindow();
			boxAni.Stop();
			boxAni.SetLoopCount(1);
			boxAni.Play();
			// End:0x554
			break;
		// End:0x551
		case slotStateEnum.resultFail/*3*/:
			boxAni.ShowWindow();
			boxAni.SetTexture("L2UI.UISlotEffect.slot_fail_0000");
			boxAni.ShowWindow();
			boxAni.Stop();
			boxAni.SetLoopCount(1);
			boxAni.Play();
			// End:0x554
			break;
	}
}

function HandleInstructionTxt()
{
	// End:0x29
	if(GetEquipmentsCount() == 0)
	{
		InstructionTxt.SetText(GetSystemMessage(2339));		
	}
	else
	{
		InstructionTxt.SetText(GetSystemString(13930));
	}
}

function SetCurrentEnchantTarget(int Current)
{
	currentEnchantTarget = Current;
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.PrvNum_text").SetText(string(currentEnchantTarget - 1));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.NextNum_text").SetText(string(currentEnchantTarget));
}

function SetNeedScrollNum()
{
	local int needScrollNum;
	local TextBoxHandle txtHandle;
	local ItemInfo iInfo;

	txtHandle = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.NeedScrollNum_Txt");
	needScrollNum = GetNeedScrollNum(numberInputStepper._getEditNum());
	// End:0xD0
	if(! GetIteminfoScroll(iInfo))
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.NeedScrollNumTitle_Txt").SetText("");
		txtHandle.SetText("");
		return;		
	}
	else
	{
		// End:0x111
		if(iInfo.ItemNum < needScrollNum)
		{
			txtHandle.SetTextColor(class'L2Util'.static.Inst().Red);			
		}
		else
		{
			txtHandle.SetTextColor(class'L2Util'.static.Inst().White);
		}
	}
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.NeedScrollNumTitle_Txt").SetText(GetSystemString(13956));
	txtHandle.SetText(string(needScrollNum) $ "/" $ string(iInfo.ItemNum));
}

function SetEnchantProbs(array<UIPacket._EnchantProbInfo> enchantProbInfo)
{
	local int i, Index;

	// End:0x6D [Loop If]
	for(i = 0; i < enchantProbInfo.Length; i++)
	{
		Index = FindIndexEquipmentWithServerID(enchantProbInfo[i].nItemServerId);
		// End:0x63
		if(Index != -1)
		{
			SetSlotProb(Index, GetProbString(enchantProbInfo[i].nTotalSuccessProbPermyriad));
		}
	}
}

function SetSlotProb(int Index, string txt)
{
	GetTextBoxHandle(getSlotPath(Index) $ ".probability_text").SetText(txt);
}

function SyncProgressAnis()
{
	local int i;
	local ItemInfo iInfo;
	local AnimTextureHandle progressAni;

	// End:0x75 [Loop If]
	for(i = 0; GetItemInfoEquipment(i, iInfo); i++)
	{
		progressAni = GetAnimTextureHandle(getSlotPath(i) $ ".EnchantSlotProgress_ani");
		progressAni.Stop();
		progressAni.Play();
	}
}

function bool API_GetEnchantScrollSetData(ItemInfo iInfo)
{
	return class'UIDATA_ITEM'.static.GetEnchantScrollSetData(iInfo.Id.ClassID, enchantScrollData);
}

function int API_GetChallengePointGroupID(int ClassID)
{
	return class'UIDATA_ITEM'.static.GetChallengePointGroupID(ClassID);
}

function RQ_C_EX_REQ_START_MULTI_ENCHANT_SCROLL(ItemInfo iInfo)
{
	local ItemInfo scrolliInfo;
	local array<byte> stream;
	local UIPacket._C_EX_REQ_START_MULTI_ENCHANT_SCROLL packet;

	// End:0x1B
	if(GetIteminfoScroll(scrolliInfo))
	{
		RQ_C_EX_REQ_CHANGE_MULTI_ENCHANT_SCROLL(iInfo);
		return;
	}
	packet.nScrollItemSid = iInfo.Id.ServerID;
	// End:0x55
	if(! class'UIPacket'.static.Encode_C_EX_REQ_START_MULTI_ENCHANT_SCROLL(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_REQ_START_MULTI_ENCHANT_SCROLL, stream);
}

function RQ_C_EX_REQ_CHANGE_MULTI_ENCHANT_SCROLL(ItemInfo iInfo)
{
	local array<byte> stream;
	local UIPacket._C_EX_REQ_CHANGE_MULTI_ENCHANT_SCROLL packet;

	// End:0x20
	if(! class'UIPacket'.static.Encode_C_EX_REQ_CHANGE_MULTI_ENCHANT_SCROLL(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_REQ_CHANGE_MULTI_ENCHANT_SCROLL, stream);
}

function RT_S_EX_RES_SELECT_MULTI_ENCHANT_SCROLL()
{
	local UIPacket._S_EX_RES_SELECT_MULTI_ENCHANT_SCROLL packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_RES_SELECT_MULTI_ENCHANT_SCROLL(packet))
	{
		return;
	}
	switch(packet.nResult)
	{
		// End:0x3E
		case 0:
			InputScrollItem(packet.nScrollItemSid);
			// End:0x43
			break;
	}
}

function RQ_C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST()
{
	local int i;
	local array<byte> stream;
	local array<ItemInfo> iInfos;
	local UIPacket._C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST packet;

	iInfos = GetItemInfoEquipments();
	EnchantBtn.DisableWindow();
	resetBtn.DisableWindow();

	// End:0x77 [Loop If]
	for(i = 0; i < iInfos.Length; i++)
	{
		packet.vEnchantItemList[packet.vEnchantItemList.Length] = iInfos[i].Id.ServerID;
	}
	// End:0xBA
	if(requestedEqupmentItemInfo.Type == Add)
	{
		packet.vEnchantItemList[packet.vEnchantItemList.Length] = requestedEqupmentItemInfo.iInfo.Id.ServerID;		
	}
	else if(requestedEqupmentItemInfo.Type == Remove)
	{
		// End:0x12B [Loop If]
		for(i = 0; i < iInfos.Length; i++)
		{
			// End:0x121
			if(requestedEqupmentItemInfo.iInfo.Id == iInfos[i].Id)
			{
				packet.vEnchantItemList.Remove(i, 1);
				// [Explicit Break]
				break;
			}
		}
	}
	// End:0x159
	if(packet.vEnchantItemList.Length == 0)
	{
		HandleRequestedEquipment();
		HandleInstructionTxt();
		resetBtn.EnableWindow();
		return;
	}
	// End:0x179
	if(! class'UIPacket'.static.Encode_C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST, stream);
}

function RT_S_EX_RES_SET_MULTI_ENCHANT_ITEM_LIST()
{
	local UIPacket._S_EX_RES_SET_MULTI_ENCHANT_ITEM_LIST packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_RES_SET_MULTI_ENCHANT_ITEM_LIST(packet))
	{
		return;
	}
	resetBtn.EnableWindow();
	switch(packet.nResult)
	{
		// End:0x49
		case 0:
			HandleRequestedEquipment();
			HandleInstructionTxt();
			// End:0xF8
			break;
		// End:0x71
		case 1:
			class'L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(184));
			// End:0xF8
			break;
		// End:0x9D
		case 2:
			class'L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13649));
			// End:0xF8
			break;
		// End:0xC9
		case 3:
			class'L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(3675));
			// End:0xF8
			break;
		// End:0xF5
		case 4:
			class'L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13648));
			// End:0xF8
			break;
	}
	ChkEnchantBtn();
}

function RQ_C_EX_REQ_MULTI_ENCHANT_ITEM_LIST()
{
	local int i;
	local ItemInfo iInfo;
	local array<byte> stream;
	local UIPacket._C_EX_REQ_MULTI_ENCHANT_ITEM_LIST packet;

	EnchantBtn.DisableWindow();

	// End:0x144 [Loop If]
	for(i = 0; i < MAX_SLOT; i++)
	{
		// End:0x3B
		if(slotStates[i] == non)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x54
		if(slotStates[i] == resultFail)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x6D
		if(slotProgresss[i] == non)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x86
		if(slotProgresss[i] == Gray)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x9E
		if(! GetItemInfoEquipment(i, iInfo))
		{
			// [Explicit Continue]
			continue;
		}
		packet.vEnchantItemList[packet.vEnchantItemList.Length] = iInfo.Id.ServerID;
		Debug(" ---- serverID:" @ string(packet.vEnchantItemList[packet.vEnchantItemList.Length - 1]) @ iInfo.Name @ "렝스: " @ string(packet.vEnchantItemList.Length) @ "인첸티드 : " @ string(iInfo.Enchanted));
	}
	// End:0x157
	if(packet.vEnchantItemList.Length == 0)
	{
		return;
	}
	// End:0x1A5
	if(numberInputStepper._getEditNum() == currentEnchantTarget)
	{
		// End:0x18D
		if(IsGreateSuccessEffect(currentEnchantTarget))
		{
			groupIDWndScr._SetDisable();
		}
		packet.bUseLateAnnounce = 1;
		bUseLateAnnounce = true;		
	}
	else
	{
		bUseLateAnnounce = false;
		packet.bUseLateAnnounce = 0;
	}
	// End:0x1DA
	if(! class'UIPacket'.static.Encode_C_EX_REQ_MULTI_ENCHANT_ITEM_LIST(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_REQ_MULTI_ENCHANT_ITEM_LIST, stream);
}

function RT_S_EX_RES_MULTI_ENCHANT_ITEM_LIST()
{
	local ItemInfo iInfo;
	local UIPacket._S_EX_RES_MULTI_ENCHANT_ITEM_LIST packet;

	EnchantBtn.EnableWindow();
	// End:0x2A
	if(! class'UIPacket'.static.Decode_S_EX_RES_MULTI_ENCHANT_ITEM_LIST(packet))
	{
		return;
	}
	// End:0x41
	if(! RefreshScroll(iInfo))
	{
		GotoState(STATE_COMPLETE_RESULT);
	}
	groupIDWndScr._SetEnable();
	switch(packet.bResult)
	{
		// End:0x6B
		case 0:
			GotoState(STATE_READY_EQUIPMENT);
			// End:0x146
			break;
		// End:0x143
		case 1:
			SetFailItemList(packet.vFailChallengePointInfoList, packet.vFailRewardItemList);
			class'L2UITimer'.static.Inst()._AddTimer()._DelegateOnEnd = RemoveFailedItems;
			SetSlots(packet.vSuccessItemList, packet.vFailedItemList);
			// End:0x11E
			if(currentEnchantTarget == numberInputStepper._getEditNum())
			{
				// End:0xFD
				if(IsGreateSuccessEffect(currentEnchantTarget))
				{
					GotoState(STATE_COMPLETE_BLIND);					
				}
				else
				{
					timerObj._Reset();
					groupIDWndScr._SetEnable();
				}
			}
			++ currentEnchantTarget;
			// End:0x13A
			if(! canEnchant())
			{
				GotoState(STATE_COMPLETE_RESULT);				
			}
			else
			{
				StartProgress();
			}
			// End:0x146
			break;
	}

	SetNeedScrollNum();
}

function DelayGotoToStateCompleteREsult()
{
	GotoState(STATE_COMPLETE_RESULT);
}

function AddFailItemList(ItemInfo iInfo)
{
	local int i;

	// End:0x7A [Loop If]
	for(i = 0; i < failedItemList.Length; i++)
	{
		// End:0x70
		if(failedItemList[i].Id.ClassID == iInfo.Id.ClassID)
		{
			failedItemList[i].ItemNum = failedItemList[i].ItemNum + iInfo.ItemNum;
			return;
		}
	}
	failedItemList[failedItemList.Length] = iInfo;
}

function AddChangePointList(ItemInfo iInfo)
{
	local int i;

	// End:0x7A [Loop If]
	for(i = 0; i < changePointList.Length; i++)
	{
		// End:0x70
		if(changePointList[i].Id.ClassID == iInfo.Id.ClassID)
		{
			changePointList[i].ItemNum = changePointList[i].ItemNum + iInfo.ItemNum;
			return;
		}
	}
	changePointList[changePointList.Length] = iInfo;
}

function SetFailItemList(array<UIPacket._EnchantFailChallengePointInfo> vFailChallengePointInfo, array<UIPacket._EnchantFailRewardItem> failRewardItems)
{
	local int i;
	local ItemInfo iInfo;

	// End:0x82 [Loop If]
	for(i = 0; i < vFailChallengePointInfo.Length; i++)
	{
		class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(class'ItemEnchantGroupIDWnd'.static._GetClassIDPoint(vFailChallengePointInfo[i].nGroupID)), iInfo);
		iInfo.ItemNum = vFailChallengePointInfo[i].nChallengePoint;
		AddChangePointList(iInfo);
	}

	// End:0xF5 [Loop If]
	for(i = 0; i < failRewardItems.Length; i++)
	{
		class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(failRewardItems[i].nItemClassID), iInfo);
		iInfo.ItemNum = failRewardItems[i].nItemCount;
		AddFailItemList(iInfo);
	}
}

function CheckEmptyFailItemInfoToList()
{
	local RichListCtrlRowData RowData, emptyRowData;

	// End:0x17
	if(resultFailList_RichList.GetRecordCount() > 0)
	{
		return;
	}
	RowData.cellDataList.Length = 1;
	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetSystemString(14024), class'L2Util'.static.Inst().Gray, false, 10);
	resultFailList_RichList.InsertRecord(emptyRowData);
	resultFailList_RichList.InsertRecord(emptyRowData);
	resultFailList_RichList.InsertRecord(RowData);
}

function MakeFailItemList()
{
	local int i;
	local RichListCtrlRowData RowData;

	resultFailList_RichList.DeleteAllItem();

	// End:0x83 [Loop If]
	for(i = 0; i < changePointList.Length; i++)
	{
		// End:0x42
		if(changePointList[i].ItemNum == 0)
		{
			// [Explicit Continue]
			continue;
		}
		RowData.cellDataList.Length = 0;
		makeRecord(changePointList[i], RowData);
		resultFailList_RichList.InsertRecord(RowData);
	}

	// End:0xF7 [Loop If]
	for(i = 0; i < failedItemList.Length; i++)
	{
		// End:0xB6
		if(failedItemList[i].ItemNum == 0)
		{
			// [Explicit Continue]
			continue;
		}
		RowData.cellDataList.Length = 0;
		makeRecord(failedItemList[i], RowData);
		resultFailList_RichList.InsertRecord(RowData);
	}
}

function bool makeRecord(ItemInfo iInfo, out RichListCtrlRowData RowData)
{
	RowData.cellDataList.Length = 1;
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, iInfo, 32, 32, 7);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), class'L2Util'.static.Inst().White, false, 4, 3);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, "x" $ MakeCostStringINT64(iInfo.ItemNum), class'L2Util'.static.Inst().White, true, 42, 0);
	return true;
}

function SetSlots(array<UIPacket._EnchantSuccessItem> successItemLists, array<UIPacket._EnchantFailItem> failedItemList)
{
	local ItemInfo iInfo;
	local int i, Index;

	// End:0x8B
	if(currentEnchantTarget != numberInputStepper._getEditNum() || ! IsGreateSuccessEffect(currentEnchantTarget))
	{
		// End:0x5A
		if(successItemLists.Length > 0)
		{
			PlaySound("Itemsound3.ui_enchant_fx");			
		}
		else
		{
			// End:0x8B
			if(failedItemList.Length > 0)
			{
				PlaySound("Itemsound3.ui_enchant_fail_fx");
			}
		}
	}

	// End:0x108 [Loop If]
	for(i = 0; i < successItemLists.Length; i++)
	{
		Index = FindIndexEquipmentWithServerID(successItemLists[i].nItemSid);
		// End:0xFE
		if(GetItemInfoEquipment(Index, iInfo))
		{
			iInfo.Enchanted = successItemLists[i].nFinalEnchanted;
			SetSlotState(Index, slotStateEnum.resultSuccess/*2*/, iInfo);
		}
	}

	// End:0x165 [Loop If]
	for(i = 0; i < failedItemList.Length; i++)
	{
		Index = FindIndexEquipmentWithServerID(failedItemList[i].nItemSid);
		// End:0x15B
		if(GetItemInfoEquipment(Index, iInfo))
		{
			SetSlotState(Index, resultFail);
		}
	}

	// End:0x19E [Loop If]
	for(i = 0; i < MAX_SLOT; i++)
	{
		switch(slotStates[i])
		{
			// End:0x18A
			case resultSuccess:
			// End:0x191
			case resultFail:
				return;
		}
	}
}

function RQ_C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT()
{
	local array<byte> stream;
	local UIPacket._C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT packet;

	// End:0x0D
	if(! bUseLateAnnounce)
	{
		return;
	}
	// End:0x2D
	if(! class'UIPacket'.static.Encode_C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT(stream, packet))
	{
		return;
	}
	bUseLateAnnounce = false;
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT, stream);
	NoticeWnd(GetScript("NoticeWnd"))._CreateCollectionButtonBlind();
}

function RQ_C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL()
{
	local ItemInfo iInfo;
	local array<byte> stream;
	local UIPacket._C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL packet;

	Debug("RQ_C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL" @ string(GetIteminfoScroll(iInfo)));
	// End:0x5E
	if(! class'UIPacket'.static.Encode_C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL(stream, packet))
	{
		return;
	}
	Debug("취소 요청 함");
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL, stream);
}

function RT_S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST()
{
	local UIPacket._S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST(packet))
	{
		return;
	}
	SetEnchantProbs(packet.vProbList);
}

function bool ChkEnchantContinue()
{
	local ItemInfo ScrollItemInfo;

	StopProgress();
	SetCurrentEnchantTarget(1);
	RQ_C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT();
	// End:0x2C
	if(! RefreshScroll(ScrollItemInfo))
	{
		GotoState(STATE_READY_SCROLL);
		return false;
	}
	GotoState(STATE_READY_EQUIPMENT);
	// End:0x41
	if(GetEquipmentsCount() == 0)
	{
		return false;
	}
	numberInputStepper._SetDisable(false);
	requestedEqupmentItemInfo.Type = Refresh;
	RQ_C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST();
	return true;
}

function string GetProbString(int probPermriad)
{
	// End:0x26
	if(float(probPermriad) % PERMRIAD == 0)
	{
		return string(probPermriad / PERMRIAD) $ "%";
	}
	return string(float(probPermriad) / PERMRIAD) $ "%";
}

function array<ItemInfo> GetItemInfoEquipments()
{
	local int i, Index;
	local ItemInfo iInfo;
	local array<ItemInfo> iInfos;

	// End:0x61 [Loop If]
	for(i = 0; i < MAX_SLOT; i++)
	{
		// End:0x2C
		if(slotStates[i] == resultFail)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x57
		if(GetItemInfoEquipment(i, iInfo))
		{
			iInfos[Index] = iInfo;
			Index++;
		}
	}
	return iInfos;
}

function int FindIndexEquipmentWithServerID(int ServerID)
{
	local int i;
	local ItemInfo iInfo;

	// End:0x4F [Loop If]
	for(i = 0; i < MAX_SLOT; i++)
	{
		// End:0x45
		if(GetItemInfoEquipment(i, iInfo))
		{
			// End:0x45
			if(iInfo.Id.ServerID == ServerID)
			{
				return i;
			}
		}
	}
	return -1;
}

function string getSlotPath(int Index)
{
	return m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSlot_Wnd.Slot_Wnd" $ Int2Str(Index);
}

function string Int2Str(int i)
{
	// End:0x19
	if(i < 10)
	{
		return "0" $ string(i);
	}
	return string(i);
}

event OnReceivedCloseUI()
{
	// End:0x3E
	if(DialogIsMine() && class'DialogBox'.static.Inst().m_hOwnerWnd.IsShowWindow())
	{
		DialogHide();
		DialogResultCancel();
		return;
	}
	switch(GetStateName())
	{
		// End:0x65
		case STATE_ENCHANT:
			// End:0x63
			if(EnchantBtn.IsEnableWindow())
			{
				HandleClickButtonEnchant();
			}
			return;
	}
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
}

auto state stateNone
{
	function BeginState()
	{
		numberInputStepper._SetDisable(true);
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
		RQ_C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT();
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemEnchantWndTap_Btn").EnableWindow();
		InstructionTxt.SetText(GetSystemMessage(4146));
		RQ_C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL();
		EnchantBtn.DisableWindow();
		resetBtn.DisableWindow();
		EnchantBtn.SetNameText(GetSystemString(13935));
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultScreenFence_Wnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Dialog_Wnd").HideWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultFailItem_Wnd").HideWindow();
		ClearScroll();
		ClearEquipments();
		numberInputStepper._setEditNum(1);
		numberInputStepper._SetDisable(true);
		SetCurrentEnchantTarget(1);
		SetNeedScrollNum();
		class'ItemMultiEnchantSubWnd'.static.Inst().Show();
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
		HandleInstructionTxt();
		EnchantBtn.DisableWindow();
		EnchantBtn.SetNameText(GetSystemString(13935));
		resetBtn.EnableWindow();
		numberInputStepper._SetDisable(false);
		class'ItemMultiEnchantSubWnd'.static.Inst().Show();
	}

	function EndState()
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Dialog_Wnd").HideWindow();
		PrevState = GetStateName();
	}

	function HandleClickButtonEnchant()
	{
		// End:0x5D
		if(IsBreakable())
		{
			HandleShowDialog();
			resetBtn.DisableWindow();
			EnchantBtn.DisableWindow();
			GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Dialog_Wnd").ShowWindow();			
		}
		else
		{
			GotoState(STATE_ENCHANT);
		}
	}

}

state stateEnchant
{
	function BeginState()
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemEnchantWndTap_Btn").DisableWindow();
		Debug("StateEnchant" @ string(numberInputStepper._getEditNum()));
		numberInputStepper._SetDisable(true);
		InstructionTxt.SetText(GetSystemString(13931));
		failedItemList.Length = 0;
		changePointList.Length = 0;
		EnchantBtn.EnableWindow();
		EnchantBtn.SetNameText(GetSystemString(13936));
		class'ItemMultiEnchantSubWnd'.static.Inst().Hide();
		currentEnchantTarget = 1;
		ResetProgressStates();
		StartProgress();
	}

	function EndState()
	{
		currentEnchantTarget = 1;
		PrevState = GetStateName();
		m_hOwnerWnd.DisableTick();
		StopProgress();
	}

	function HandleClickButtonEnchant()
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemEnchantWndTap_Btn").EnableWindow();
		ChkEnchantContinue();
		timerObj._Stop();
	}

}

state stateCompleteBlind
{
	function BeginState()
	{
		InstructionTxt.SetText(GetSystemString(13953));
		EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_screen");
		EnchantEffectViewport.SetScale(1.340f);
		EnchantEffectViewport.SetCameraDistance(222.0f);
		EnchantEffectViewport.SetFocus();
		EnchantBtn.SetNameText(GetSystemString(13954));
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultScreenFence_Wnd").ShowWindow();
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultScreenFence_Wnd").SetFocus();
		EnchantEffectViewport.SetFocus();
		groupIDWndScr._SetDisable();
		PlaySound("Itemsound3.ui_enchant_screen");
	}

	function EndState()
	{
		EnchantEffectViewport.SpawnEffect("");
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultScreenFence_Wnd").HideWindow();
		PrevState = GetStateName();
		groupIDWndScr._SetEnable();
	}

	function HandleClickButtonEnchant()
	{
		GotoState(STATE_COMPLETE_RESULT);
	}

}

state stateCompleteResult
{
	function BeginState()
	{
		RQ_C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT();
		resetBtn.EnableWindow();
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemEnchantWndTap_Btn").EnableWindow();
		InstructionTxt.SetText(GetSystemString(13932));
		// End:0x1AE
		if(IsSuccess())
		{
			EnchantEffectViewport.SetCameraDistance(175.0f);
			// End:0x12B
			if(IsGreateSuccessEffect(numberInputStepper._getEditNum()))
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
		}
		else
		{
			EnchantEffectViewport.SetCameraDistance(160.0f);
			EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_fail");
			PlaySound("Itemsound3.ui_enchant_fail");
			PlaySound("Itemsound3.ui_enchant_fail_sfx");
		}
		EnchantEffectViewport.SetFocus();
		MakeFailItemList();
		EnchantBtn.SetNameText(GetSystemString(3135));
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultFailItem_Wnd").ShowWindow();
		CheckEmptyFailItemInfoToList();
	}

	function EndState()
	{
		EnchantEffectViewport.SpawnEffect("");
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultFailItem_Wnd").HideWindow();
		PrevState = GetStateName();
		numberInputStepper._SetDisable(false);
	}

	function HandleClickButtonEnchant()
	{
		ChkEnchantContinue();
	}
}

defaultproperties
{
}
