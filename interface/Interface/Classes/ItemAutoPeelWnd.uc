class ItemAutoPeelWnd extends UICommonAPI;

const TIMER_ID_ITEM_PEEL_DELAY = 1;
const TIMER_DELAY_ITEM_PEEL = 50;
const DIALOG_ID_ITEM_SET_COUNT = 1;
const RARE_ANOUNCE_LEVEL = 4;

struct ItemAutoPeelInfo
{
	var int targetItemSId;
	var string targetItemName;
	var INT64 remainPeelCnt;
	var INT64 totalPeelCnt;
	var bool isPeeling;
	var bool isPause;
	var bool isExpand;
	var bool isComplete;
	var int readyTargetItemSid;
	var INT64 readyTotalPeelCnt;
	var int maxAnounceLevel;
	var array<UIPacket._AutoPeelResultItem> normalItemInfos;
	var array<UIPacket._AutoPeelResultItem> rareItemInfos;
};

var ItemAutoPeelInfo _itemAutoPeelInfo;
var bool _is_waiting_close;
var bool _is_opened_dialog;
var WindowHandle Me;
var ButtonHandle expandBtn;
var ItemWindowHandle targetItemWnd;
var TextBoxHandle statusTextBox;
var StatusBarHandle statusBar;
var TextureHandle anounceLevelTex;
var CharacterViewportWindowHandle itemPeelEffect;
var EditBoxHandle testEditBox;
var L2UIInventoryObjectSimple iObject;

static function ItemAutoPeelWnd Inst()
{
	return ItemAutoPeelWnd(GetScript("ItemAutoPeelWnd"));
}

function Initialize()
{
	initControls();
	iObject = AddItemListenerSimple(0);
	iObject.DelegateOnUpdateItem = HandleUpdateTargetItem;
}

function initControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	expandBtn = GetButtonHandle(ownerFullPath $ ".ExpandBTN");
	statusBar = GetStatusBarHandle(ownerFullPath $ ".ProgressBar");
	statusTextBox = GetTextBoxHandle(ownerFullPath $ ".ProgressBar_Text");
	targetItemWnd = GetItemWindowHandle(ownerFullPath $ ".BoxItem_itemWnd");
	anounceLevelTex = GetTextureHandle(ownerFullPath $ ".LvDot_tex");
	itemPeelEffect = GetCharacterViewportWindowHandle(ownerFullPath $ ".ChEffectViewport");
}

function UpdateProgressInfoControls()
{
	// End:0x2E
	if(_itemAutoPeelInfo.isComplete == true)
	{
		statusTextBox.SetText(GetSystemString(898));		
	}
	else
	{
		// End:0x5E
		if(_itemAutoPeelInfo.remainPeelCnt == 0)
		{
			statusTextBox.SetText(GetSystemString(14092));			
		}
		else
		{
			statusTextBox.SetText(MakeCostString(string(_itemAutoPeelInfo.remainPeelCnt)));
		}
	}
	statusBar.SetPoint(_itemAutoPeelInfo.remainPeelCnt, _itemAutoPeelInfo.totalPeelCnt);
	// End:0xF7
	if(_itemAutoPeelInfo.maxAnounceLevel >= 4 && _itemAutoPeelInfo.isExpand == false)
	{
		anounceLevelTex.SetTexture(GetAnounceLevelTextureName(_itemAutoPeelInfo.maxAnounceLevel));
		anounceLevelTex.ShowWindow();		
	}
	else
	{
		anounceLevelTex.HideWindow();
	}
}

function UpdateExpandWnd()
{
	// End:0x45
	if(_itemAutoPeelInfo.isExpand == true)
	{
		expandBtn.HideWindow();
		class'ItemAutoPeelExpandWnd'.static.Inst().m_hOwnerWnd.ShowWindow();		
	}
	else
	{
		expandBtn.ShowWindow();
		class'ItemAutoPeelExpandWnd'.static.Inst().m_hOwnerWnd.HideWindow();
	}
}

function UpdateSimpleInvenWnd()
{
	// End:0x49
	if(_itemAutoPeelInfo.isExpand == true)
	{
		// End:0x3F
		if(_itemAutoPeelInfo.isPeeling == true && _itemAutoPeelInfo.isPause == false)
		{
			ShowSimpleInven(false);			
		}
		else
		{
			ShowSimpleInven(true);
		}		
	}
	else
	{
		ShowSimpleInven(false);
	}
}

function UpdateTargetItemInfoControls()
{
	local ItemInfo targetItemInfo;

	// End:0x84
	if(class'UIDATA_INVENTORY'.static.FindItem(_itemAutoPeelInfo.targetItemSId, targetItemInfo))
	{
		targetItemInfo.bDisabled = 0;
		targetItemInfo.bShowCount = true;
		// End:0x81
		if(! targetItemWnd.SetItem(0, targetItemInfo))
		{
			targetItemWnd.AddItem(targetItemInfo);
			iObject.setId(targetItemInfo.Id);
		}		
	}
	else
	{
		targetItemWnd.Clear();
		iObject.setId();
		// End:0xBE
		if(_itemAutoPeelInfo.targetItemSId > 0)
		{
			Rq_C_EX_STOP_ITEM_AUTO_PEEL();
			ResetTargetInfo();
		}
	}
}

function UpdateWnd()
{
	UpdateExpandWnd();
	UpdateSimpleInvenWnd();
}

function UpdateUIControls()
{
	UpdateTargetItemInfoControls();
	UpdateProgressInfoControls();
	class'ItemAutoPeelExpandWnd'.static.Inst().UpdateUIControls();
}

function RegisterItem(int itemSId, bool isAllItem)
{
	local INT64 ItemNum;

	// End:0x41
	if(_itemAutoPeelInfo.isPeeling == true && _itemAutoPeelInfo.isPause == false)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13666));
		return;
	}
	Me.ShowWindow();
	SetExpand(true);
	// End:0xE0
	if(itemSId != 0)
	{
		ItemNum = GetItemNum(itemSId);
		_itemAutoPeelInfo.readyTargetItemSid = itemSId;
		// End:0xAB
		if(isAllItem == true)
		{
			_itemAutoPeelInfo.readyTotalPeelCnt = 0;
			Rq_C_EX_READY_ITEM_AUTO_PEEL(itemSId);			
		}
		else
		{
			// End:0xC7
			if(ItemNum > 1)
			{
				ShowItemCountDialog(itemSId);				
			}
			else
			{
				_itemAutoPeelInfo.readyTotalPeelCnt = 1;
				Rq_C_EX_READY_ITEM_AUTO_PEEL(itemSId);
			}
		}
	}
}

function StartItemAutoPeel()
{
	_itemAutoPeelInfo.isPeeling = true;
	_itemAutoPeelInfo.isPause = false;
	_itemAutoPeelInfo.isComplete = false;
	CheckAndContinueItemPeel();
	UpdateSimpleInvenWnd();
	UpdateUIControls();
}

function PauseItemAutoPeel()
{
	_itemAutoPeelInfo.isPeeling = true;
	_itemAutoPeelInfo.isPause = true;
	KillItemPeelDelayTimer();
	UpdateSimpleInvenWnd();
	UpdateUIControls();
}

function StopItemAutoPeel()
{
	_itemAutoPeelInfo.isPeeling = false;
	_itemAutoPeelInfo.isPause = false;
	KillItemPeelDelayTimer();
	UpdateSimpleInvenWnd();
	UpdateUIControls();
}

function CompleteItemAutoPeel()
{
	_itemAutoPeelInfo.isComplete = true;
	StopItemAutoPeel();
}

function CheckAndContinueItemPeel()
{
	// End:0x76
	if(_itemAutoPeelInfo.targetItemSId != 0 && _itemAutoPeelInfo.isPeeling == true && _itemAutoPeelInfo.isPause == false)
	{
		// End:0x52
		if(_itemAutoPeelInfo.remainPeelCnt == 0)
		{
			StopItemAutoPeel();			
		}
		else
		{
			Rq_C_EX_REQUEST_ITEM_AUTO_PEEL(_itemAutoPeelInfo.targetItemSId, _itemAutoPeelInfo.remainPeelCnt, _itemAutoPeelInfo.totalPeelCnt);
		}
	}
}

function AddResultItemInfo(array<UIPacket._AutoPeelResultItem> resultItemInfos)
{
	local int i;
	local UIPacket._AutoPeelResultItem tempInfo;

	// End:0x7D [Loop If]
	for(i = 0; i < resultItemInfos.Length; i++)
	{
		tempInfo = resultItemInfos[i];
		// End:0x68
		if(tempInfo.AnnounceLevel >= 4)
		{
			_itemAutoPeelInfo.maxAnounceLevel = Max(_itemAutoPeelInfo.maxAnounceLevel, tempInfo.AnnounceLevel);
			AddRareResultInfo(tempInfo);
			// [Explicit Continue]
			continue;
		}
		AddNormalResultInfo(tempInfo);
	}
}

function AddRareResultInfo(UIPacket._AutoPeelResultItem resultItemInfo)
{
	local bool isFound;
	local int i;
	local UIPacket._AutoPeelResultItem tempInfo;

	// End:0x98 [Loop If]
	for(i = 0; i < _itemAutoPeelInfo.rareItemInfos.Length; i++)
	{
		tempInfo = _itemAutoPeelInfo.rareItemInfos[i];
		// End:0x8E
		if(tempInfo.nItemClassID == resultItemInfo.nItemClassID)
		{
			isFound = true;
			tempInfo.nAmount = tempInfo.nAmount + resultItemInfo.nAmount;
			_itemAutoPeelInfo.rareItemInfos[i] = tempInfo;
			// [Explicit Break]
			break;
		}
	}
	// End:0xD0
	if(isFound == false)
	{
		_itemAutoPeelInfo.rareItemInfos[_itemAutoPeelInfo.rareItemInfos.Length] = resultItemInfo;
		_itemAutoPeelInfo.rareItemInfos.Sort(OnItemSortCompare);
	}
}

function AddNormalResultInfo(UIPacket._AutoPeelResultItem resultItemInfo)
{
	local bool isFound;
	local int i;
	local UIPacket._AutoPeelResultItem tempInfo;

	// End:0x98 [Loop If]
	for(i = 0; i < _itemAutoPeelInfo.normalItemInfos.Length; i++)
	{
		tempInfo = _itemAutoPeelInfo.normalItemInfos[i];
		// End:0x8E
		if(tempInfo.nItemClassID == resultItemInfo.nItemClassID)
		{
			isFound = true;
			tempInfo.nAmount = tempInfo.nAmount + resultItemInfo.nAmount;
			_itemAutoPeelInfo.normalItemInfos[i] = tempInfo;
			// [Explicit Break]
			break;
		}
	}
	// End:0xC0
	if(isFound == false)
	{
		_itemAutoPeelInfo.normalItemInfos[_itemAutoPeelInfo.normalItemInfos.Length] = resultItemInfo;
	}
}

delegate int OnItemSortCompare(UIPacket._AutoPeelResultItem A, UIPacket._AutoPeelResultItem B)
{
	// End:0x22
	if(A.AnnounceLevel < B.AnnounceLevel)
	{
		return -1;		
	}
	else
	{
		return 0;
	}
}

function ResetTargetItem()
{
	// End:0x16
	if(_itemAutoPeelInfo.targetItemSId > 0)
	{
		Rq_C_EX_STOP_ITEM_AUTO_PEEL();
	}
}

function ResetTargetInfo()
{
	_itemAutoPeelInfo.targetItemSId = 0;
	_itemAutoPeelInfo.targetItemName = "";
	_itemAutoPeelInfo.remainPeelCnt = 0;
	_itemAutoPeelInfo.totalPeelCnt = 0;
	_itemAutoPeelInfo.isPeeling = false;
	_itemAutoPeelInfo.isPause = false;
}

function ResetResultInfo()
{
	_itemAutoPeelInfo.maxAnounceLevel = 0;
	_itemAutoPeelInfo.normalItemInfos.Length = 0;
	_itemAutoPeelInfo.rareItemInfos.Length = 0;
	_itemAutoPeelInfo.isComplete = false;
}

function ResetInfo()
{
	ResetTargetInfo();
	ResetResultInfo();
}

function SetExpand(bool isExpand)
{
	_itemAutoPeelInfo.isExpand = isExpand;
	UpdateExpandWnd();
	UpdateSimpleInvenWnd();
	UpdateProgressInfoControls();
}

function ShowSimpleInven(bool isShow)
{
	// End:0x31
	if(isShow == true)
	{
		class'ItemAutoPeelInvenWnd'.static.Inst().m_hOwnerWnd.ShowWindow();		
	}
	else
	{
		class'ItemAutoPeelInvenWnd'.static.Inst().m_hOwnerWnd.HideWindow();
	}
}

function ShowItemCountDialog(optional int forceSId)
{
	local ItemInfo targetItemInfo;

	// End:0x2F
	if(forceSId > 0)
	{
		// End:0x2C
		if(class'UIDATA_INVENTORY'.static.FindItem(forceSId, targetItemInfo) == false)
		{
			return;
		}		
	}
	else
	{
		// End:0x55
		if(class'UIDATA_INVENTORY'.static.FindItem(_itemAutoPeelInfo.targetItemSId, targetItemInfo) == false)
		{
			return;
		}
	}
	DialogHide();
	DialogSetReservedItemID(targetItemInfo.Id);
	DialogSetParamInt64(targetItemInfo.ItemNum);
	DialogSetID(1);
	DialogSetCancelD(1);
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(13657), targetItemInfo.Name), string(self));
	_is_opened_dialog = true;
	class'DialogBox'.static.Inst().AnchorToOwner(0, 100);
	class'DialogBox'.static.Inst().DelegateOnCancel = OnItemCountDialogCancel;
	class'DialogBox'.static.Inst().DelegateOnOK = OnItemCountDialogConfirm;
	class'DialogBox'.static.Inst().DelegateOnHide = OnItemCountDialogHide;
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "AttributeEnchantWnd,AttributeRemoveWnd,UnrefineryWnd,CrystallizationWnd,ItemAttributeChangeWnd,ProgressBox,AlchemyMixCubeWnd");
	SetCountDialogModal(true);
}

function StartItemPeelDelayTimer()
{
	KillItemPeelDelayTimer();
	Me.SetTimer(TIMER_ID_ITEM_PEEL_DELAY, TIMER_DELAY_ITEM_PEEL);
}

function KillItemPeelDelayTimer()
{
	Me.KillTimer(TIMER_ID_ITEM_PEEL_DELAY);
}

function PlayItemPeelEffect()
{
	// End:0x17
	if(Me.IsShowWindow() == false)
	{
		return;
	}
	itemPeelEffect.ShowWindow();
	itemPeelEffect.SpawnEffect("LineageEffect2.ui_openbox");
}

function StopItemPeelEffect()
{
	itemPeelEffect.HideWindow();
}

function SetCountDialogModal(bool isModal)
{
	// End:0x5A
	if(isModal == true)
	{
		class'ItemAutoPeelInvenWnd'.static.Inst().m_hOwnerWnd.DisableWindow();
		class'ItemAutoPeelExpandWnd'.static.Inst().ShowDisableWnd(true);
		Me.DisableWindow();		
	}
	else
	{
		class'ItemAutoPeelInvenWnd'.static.Inst().m_hOwnerWnd.EnableWindow();
		class'ItemAutoPeelExpandWnd'.static.Inst().ShowDisableWnd(false);
		Me.EnableWindow();
	}
	UpdateUIControls();
}

function SetTargetTotalPeelCnt(INT64 Count)
{
	local INT64 oldPeelCnt, newPeelCnt;

	// End:0x73
	if(_itemAutoPeelInfo.isPeeling == false)
	{
		oldPeelCnt = _itemAutoPeelInfo.totalPeelCnt;
		newPeelCnt = Min64(GetTargetItemNum(), Count);
		// End:0x73
		if(oldPeelCnt != newPeelCnt)
		{
			_itemAutoPeelInfo.totalPeelCnt = newPeelCnt;
			_itemAutoPeelInfo.remainPeelCnt = _itemAutoPeelInfo.totalPeelCnt;
			UpdateUIControls();
		}
	}
}

function CloseWindow()
{
	// End:0x17
	if(Me.IsShowWindow() == false)
	{
		return;
	}
	// End:0x38
	if(_itemAutoPeelInfo.targetItemSId > 0)
	{
		_is_waiting_close = true;
		Rq_C_EX_STOP_ITEM_AUTO_PEEL();		
	}
	else
	{
		Me.HideWindow();
	}
}

function string GetAnounceLevelTextureName(int anounceLevel)
{
	local int validAnounceLevel;

	validAnounceLevel = Min(anounceLevel, 4 + 2);
	switch(validAnounceLevel)
	{
		// End:0x51
		case 4:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelDOT_Lv4";
		// End:0x8B
		case 4 + 1:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelDOT_Lv5";
		// End:0xC6
		case 4 + 2:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelDOT_Lv6";
		// End:0xFFFF
		default:
			return "";
	}
}

function INT64 GetItemNum(int itemSId)
{
	local ItemInfo tempInfo;

	// End:0x26
	if(class'UIDATA_INVENTORY'.static.FindItem(itemSId, tempInfo) == false)
	{
		return 0;		
	}
	else
	{
		return tempInfo.ItemNum;
	}
}

function INT64 GetTargetItemNum()
{
	local int TargetItemID;

	TargetItemID = _itemAutoPeelInfo.targetItemSId;
	// End:0x1F
	if(TargetItemID == 0)
	{
		return 0;
	}
	return GetItemNum(TargetItemID);
}

function ItemAutoPeelInfo GetItemAutoPeelInfo()
{
	return _itemAutoPeelInfo;
}

function bool IsItemPeeling()
{
	// End:0x26
	if(_itemAutoPeelInfo.isPeeling == true && _itemAutoPeelInfo.isPause == false)
	{
		return true;
	}
	return false;
}

function bool IsItemReady()
{
	// End:0x12
	if(_itemAutoPeelInfo.targetItemSId > 0)
	{
		return true;
	}
	return false;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

event OnShow()
{
	itemPeelEffect.SetNPCInfo(19671);
	itemPeelEffect.SpawnNPC();
	ResetInfo();
	Me.SetFocus();
	UpdateUIControls();
	_is_waiting_close = false;
}

event OnHide()
{
	// End:0x0F
	if(DialogIsMine())
	{
		DialogHide();
	}
	// End:0x25
	if(_itemAutoPeelInfo.targetItemSId > 0)
	{
		Rq_C_EX_STOP_ITEM_AUTO_PEEL();
	}
}

event OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	// End:0x72
	if(strID == "BoxItem_itemWnd")
	{
		// End:0x5C
		if(class'UIDATA_ITEM'.static.IsDefaultActionPeel(Info.Id.ClassID) == false)
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(1960));
			return;
		}
		RegisterItem(Info.Id.ServerID, false);
	}
}

event OnDBClickItem(string strID, int Index)
{
	// End:0x48
	if(strID == "BoxItem_itemWnd")
	{
		// End:0x42
		if(_itemAutoPeelInfo.isPeeling == true && _itemAutoPeelInfo.isPause == false)
		{			
		}
		else
		{
			ResetTargetItem();
		}
	}
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x1F
		case "ExpandBTN":
			SetExpand(true);
			// End:0x22
			break;
	}
}

event OnTimer(int TimerID)
{
	// End:0x17
	if(TimerID == 1)
	{
		KillItemPeelDelayTimer();
		CheckAndContinueItemPeel();
	}
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_READY_ITEM_AUTO_PEEL));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_RESULT_ITEM_AUTO_PEEL));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_STOP_ITEM_AUTO_PEEL));
	RegisterEvent(EV_Restart);
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_READY_ITEM_AUTO_PEEL):
			Rs_S_EX_READY_ITEM_AUTO_PEEL();
			// End:0x7E
			break;
		// End:0x47
		case EV_PacketID(class'UIPacket'.const.S_EX_RESULT_ITEM_AUTO_PEEL):
			Rs_S_EX_RESULT_ITEM_AUTO_PEEL();
			// End:0x7E
			break;
		// End:0x67
		case EV_PacketID(class'UIPacket'.const.S_EX_STOP_ITEM_AUTO_PEEL):
			Rs_S_EX_STOP_ITEM_AUTO_PEEL();
			// End:0x7E
			break;
		// End:0x7B
		case EV_Restart:
			StopItemAutoPeel();
			ResetInfo();
			// End:0x7E
			break;
	}
}

event OnItemCountDialogConfirm()
{
	local INT64 reserved2;
	local int itemSId;
	local INT64 Number;

	// End:0x6F
	if(DialogIsMine())
	{
		Number = int64(DialogGetString());
		// End:0x27
		if(Number < 1)
		{
			return;
		}
		reserved2 = DialogGetReservedInt2();
		itemSId = DialogGetReservedItemID().ServerID;
		_itemAutoPeelInfo.readyTotalPeelCnt = Number;
		_itemAutoPeelInfo.readyTargetItemSid = itemSId;
		Rq_C_EX_READY_ITEM_AUTO_PEEL(itemSId);
	}
}

event OnItemCountDialogCancel()
{
	// End:0x24
	if(DialogIsMine())
	{
		// End:0x24
		if(_is_opened_dialog == true)
		{
			_is_opened_dialog = false;
			SetCountDialogModal(false);
		}
	}
}

event OnItemCountDialogHide()
{
	// End:0x27
	if(DialogIsMine() == true)
	{
		// End:0x27
		if(_is_opened_dialog == true)
		{
			_is_opened_dialog = false;
			SetCountDialogModal(false);
		}
	}
}

function Rq_C_EX_READY_ITEM_AUTO_PEEL(int itemServerID)
{
	local array<byte> stream;
	local UIPacket._C_EX_READY_ITEM_AUTO_PEEL packet;

	packet.nItemSid = itemServerID;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_READY_ITEM_AUTO_PEEL(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_READY_ITEM_AUTO_PEEL, stream);
}

function Rq_C_EX_REQUEST_ITEM_AUTO_PEEL(int itemServerID, INT64 remainPeelCnt, INT64 totalPeelCnt)
{
	local array<byte> stream;
	local UIPacket._C_EX_REQUEST_ITEM_AUTO_PEEL packet;

	packet.nItemSid = itemServerID;
	packet.nRemainPeelCount = remainPeelCnt;
	packet.nTotalPeelCount = totalPeelCnt;
	// End:0x50
	if(! class'UIPacket'.static.Encode_C_EX_REQUEST_ITEM_AUTO_PEEL(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_REQUEST_ITEM_AUTO_PEEL, stream);
}

function Rq_C_EX_STOP_ITEM_AUTO_PEEL()
{
	local array<byte> stream;
	local UIPacket._C_EX_STOP_ITEM_AUTO_PEEL packet;

	// End:0x20
	if(! class'UIPacket'.static.Encode_C_EX_STOP_ITEM_AUTO_PEEL(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_STOP_ITEM_AUTO_PEEL, stream);
}

function Rs_S_EX_READY_ITEM_AUTO_PEEL()
{
	local UIPacket._S_EX_READY_ITEM_AUTO_PEEL packet;
	local bool IsSuccess;
	local ItemInfo targetItemInfo;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_READY_ITEM_AUTO_PEEL(packet))
	{
		return;
	}
	IsSuccess = bool(packet.bResult);
	// End:0x10B
	if(IsSuccess == true)
	{
		_itemAutoPeelInfo.targetItemSId = packet.nItemSid;
		// End:0x102
		if(class'UIDATA_INVENTORY'.static.FindItem(_itemAutoPeelInfo.targetItemSId, targetItemInfo) == true)
		{
			_itemAutoPeelInfo.targetItemName = targetItemInfo.Name;
			// End:0xC8
			if(_itemAutoPeelInfo.readyTotalPeelCnt == 0)
			{
				_itemAutoPeelInfo.totalPeelCnt = targetItemInfo.ItemNum;
				_itemAutoPeelInfo.remainPeelCnt = _itemAutoPeelInfo.totalPeelCnt;				
			}
			else
			{
				_itemAutoPeelInfo.totalPeelCnt = Min64(_itemAutoPeelInfo.readyTotalPeelCnt, targetItemInfo.ItemNum);
				_itemAutoPeelInfo.remainPeelCnt = _itemAutoPeelInfo.totalPeelCnt;
			}
		}
		ResetResultInfo();		
	}
	else
	{
		ResetTargetInfo();
	}
	_itemAutoPeelInfo.readyTargetItemSid = 0;
	_itemAutoPeelInfo.readyTotalPeelCnt = 0;
	UpdateUIControls();
}

function Rs_S_EX_RESULT_ITEM_AUTO_PEEL()
{
	local UIPacket._S_EX_RESULT_ITEM_AUTO_PEEL packet;
	local bool IsSuccess;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_RESULT_ITEM_AUTO_PEEL(packet))
	{
		return;
	}
	IsSuccess = bool(packet.bResult);
	// End:0xD7
	if(IsSuccess == true)
	{
		_itemAutoPeelInfo.remainPeelCnt = packet.nRemainPeelCount;
		_itemAutoPeelInfo.totalPeelCnt = packet.nTotalPeelCount;
		AddResultItemInfo(packet.vResultItemList);
		PlayItemPeelEffect();
		// End:0xCE
		if(packet.nRemainPeelCount == 0 && packet.nTotalPeelCount > 0)
		{
			CompleteItemAutoPeel();
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13656));
			Rq_C_EX_STOP_ITEM_AUTO_PEEL();
			return;			
		}
		else
		{
			StartItemPeelDelayTimer();
		}		
	}
	else
	{
		// End:0xF0
		if(_itemAutoPeelInfo.targetItemSId == 0)
		{
			StopItemAutoPeel();			
		}
		else
		{
			// End:0x117
			if(_itemAutoPeelInfo.remainPeelCnt > (GetTargetItemNum()))
			{
				_itemAutoPeelInfo.remainPeelCnt = GetTargetItemNum();
			}
			PauseItemAutoPeel();
		}
	}
	UpdateUIControls();
}

function Rs_S_EX_STOP_ITEM_AUTO_PEEL()
{
	local UIPacket._S_EX_STOP_ITEM_AUTO_PEEL packet;
	local bool IsSuccess;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_STOP_ITEM_AUTO_PEEL(packet))
	{
		return;
	}
	IsSuccess = bool(packet.bResult);
	// End:0x6C
	if(IsSuccess == true)
	{
		ResetTargetInfo();
		// End:0x69
		if(_is_waiting_close == true)
		{
			_is_waiting_close = false;
			Me.HideWindow();
			ResetInfo();
		}		
	}
	else
	{
		// End:0x78
		if(_is_waiting_close == true)
		{
		}
	}
	UpdateUIControls();
	UpdateWnd();
}

function HandleUpdateTargetItem(optional array<ItemInfo> iInfo, optional int Index)
{
	// End:0x39
	if(_itemAutoPeelInfo.targetItemSId > 0 && iInfo.Length > 0)
	{
		// End:0x39
		if(iInfo[0].ItemNum == 0)
		{
			UpdateUIControls();
		}
	}
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	CloseWindow();
}

defaultproperties
{
}
