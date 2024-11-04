///////////////////////////////////////////////////////////////////////////////////////////
//	ItemJewelEnchantWnd 1.0																//
//
// 2018.03.22 ЗХјє UIёё
// АОГ¦Ж®? ѕЦґПёЮАМјЗ јУµµё¦ 1ГК·О єЇ°жЗФ.
///////////////////////////////////////////////////////////////////////////////////////////

class ItemJewelEnchantWnd extends UICommonAPI;

const C_ANIMLOOPCOUNT = 1;
const TIMER_DELAY = 1000;
const TIMER_DELAY_SKIP = 150;
const TIMER_DELAY_AUTO = 25;
const TIMER_DELAY_AUTOEffect2 = 700;
const DLG_ID_CRASH_ALERT = 1;
const ITEMINVENTORY_COLNUM = 12;
const ITEM_ID_MOVE_TWEEN0 = 0;
const ITEM_ID_MOVE_TWEEN1 = 1;
const ITEM_ID_MOVE_TWEENEND = 2;
const STATE_BEGIN = 'stateBegin';
const STATE_READY = 'stateReady';
const STATE_ONEREADY = 'stateOneReady';
const STATE_ALLREADY = 'stateAllReady';
const STATE_PROCESS = 'stateProcess';
const STATE_RESULT = 'stateResult';
const STATE_AUTORESULT = 'stateAutoResult';

enum EnchantType 
{
	Normal,
	dye
};

enum ResultType 
{
	result_fail,
	result_Success,
	result_only
};

enum AUTOPROCESS_STEP_TYPE 
{
	non,
	onResult,
	itputResult,
	itputResultReady,
	inputNext,
	inputNextReady,
	Progress,
	progressStart,
	resultBylevel
};

var private name PrevState;
var ItemWindowHandle EnchantJewel1;
var ItemWindowHandle EnchantJewel2;
var ItemWindowHandle EnchantedItemSlot;
var TextBoxHandle InstructionTxt;
var TextBoxHandle WarningTxt;
var TextBoxHandle ProbTxt;
var TextureHandle EnchantJewel1BackTex;
var TextureHandle EnchantJewel2BackTex;
var TextureHandle EnchantedJewelBackTex;
var TextureHandle DropHighlight_EnchantJewel2;
var TextureHandle DropHighlight_EnchantJewel1;
var private TextureHandle Groupbox0_tex;
var private ButtonHandle EnchantBtn;
var private ButtonHandle InitBtn;
var private ButtonHandle nextbtn;
var private ButtonHandle continueBtn;
var private ButtonHandle CancelBtn;
var ProgressCtrlHandle m_hItemEnchantWndEnchantProgress;
var CheckBoxHandle Skip_CheckBox;
var UIControlNeedItemList UIControlNeedItemListObj;
var UIControlNumberInputSteper numberInputStepper;
var private ItemInfo jewel1ItemInfo;
var private ItemInfo jewel2ItemInfo;
var private bool bRequestedPushRetry;
var private bool bRequestPushOne;
var private bool bRequestPushTwo;
var private bool bRequestRemoveOne;
var private bool bRequestRemoveTwo;
var private bool bRequestTryEnchant;
var EnchantType currentEnchantType;
var ItemJewelEnchantSubWnd ItemJewelEnchantSubWndScript;
var ItemWindowHandle itemJewelEnchantSubWnd_ItemWnd;
var ItemWindowHandle InvenInventoryItem;
var ItemWindowHandle InventoryItem;
var private WindowHandle AutoEnchant_wnd;
var private Rect slot1StartRect;
var private Rect slot2StartRect;
var private Rect slotEndStartRect;
var private EffectViewportWndHandle mainEffectViewport;
var private ItemWindowHandle moveItem1;
var private ItemWindowHandle moveItem2;
var private AnimTextureHandle shadowItem_tex1;
var private AnimTextureHandle shadowItem_tex2;
var private AnimTextureHandle ShadowItem_texEnd;
var private AnimTextureHandle dropResult_AniTex1;
var private AnimTextureHandle dropResult_AniTex2;
var private L2UIInventoryObject iObject;
var private L2UITimerObject uiTimerObj;
var private AUTOPROCESS_STEP_TYPE autoProcessStepType;
var private bool bPausedAuto;
var private INT64 currentCommissionAdena;
var WindowHandle Dialog_Wnd;
var RichListCtrlHandle EnchantItemList_RichList;

private function StateFuncOnCclickEnchantBtn();

private function StateFuncOnCclickCancelBtn();

private function InitFlags()
{
	bRequestedPushRetry = false;
	bRequestTryEnchant = false;
	bRequestPushOne = false;
	bRequestPushTwo = false;
	bRequestRemoveOne = false;
	bRequestRemoveTwo = false;	
}

private function InitRichListScript()
{
	UIControlNeedItemListObj = class'UIControlNeedItemList'.static.InitScript(GetWindowHandle("ItemJewelEnchantWnd.NeedItemWnd"));
	UIControlNeedItemListObj._SetUseAnimation(true);
	UIControlNeedItemListObj.DelegateOnUpdateItem = OnItemUpdateItem;
	UIControlNeedItemListObj._SetAnimationRate(0.50f);	
}

function InitUIControlNumberInputSteper()
{
	numberInputStepper = class'UIControlNumberInputSteper'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.EnchantGoalSet_wndAsset"));
	numberInputStepper.DelegateESCKey = OnReceivedCloseUI;
	numberInputStepper.DelegateOnChangeEditBox = OnChangedLevel;
	numberInputStepper.m_hOwnerWnd.ShowWindow();
	numberInputStepper._SetDisable(true);
	numberInputStepper._setMaxLength(2);	
}

private function InitAutoEnchant()
{
	local Rect wndRect;

	AutoEnchant_wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd");
	InventoryItem = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.AutoJewelItemWindow");
	InventoryItem.SetIconDrawType(EItemWindowIconDrawType.ITEMWND_IconDraw_ShowNewlyAcquired);
	slot1StartRect = EnchantJewel1.GetRect();
	slot2StartRect = EnchantJewel2.GetRect();
	slotEndStartRect = EnchantedItemSlot.GetRect();
	wndRect = m_hOwnerWnd.GetRect();
	slot1StartRect.nX = slot1StartRect.nX - wndRect.nX;
	slot1StartRect.nY = slot1StartRect.nY - wndRect.nY;
	slot2StartRect.nX = slot2StartRect.nX - wndRect.nX;
	slot2StartRect.nY = slot2StartRect.nY - wndRect.nY;
	slotEndStartRect.nX = slotEndStartRect.nX - wndRect.nX;
	slotEndStartRect.nY = slotEndStartRect.nY - wndRect.nY;
	moveItem1.HideWindow();
	moveItem2.HideWindow();
	shadowItem_tex1.HideWindow();
	shadowItem_tex2.HideWindow();
	ShadowItem_texEnd.HideWindow();
	dropResult_AniTex1.HideWindow();
	dropResult_AniTex2.HideWindow();	
}

static function ItemJewelEnchantWnd Inst()
{
	return ItemJewelEnchantWnd(GetScript("ItemJewelEnchantWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(EV_NewEnchantPushOneOK);		// 9760;	
	RegisterEvent(EV_NewEnchantPushOneFail);	//9761;
	RegisterEvent(EV_NewEnchantPushTwoOK);		//9762;
	RegisterEvent(EV_NewEnchantPushTwoFail);	//9763;
	RegisterEvent(EV_NewEnchantRemoveOneOK);	//9764;
	RegisterEvent(EV_NewEnchantRemoveOneFail);	//9765;
	RegisterEvent(EV_NewEnchantRemoveTwoOK);	//9766;
	RegisterEvent(EV_NewEnchantRemoveTwoFail);	//9767;
	RegisterEvent(EV_NewEnchantTrySuccess);	    //9768;
	RegisterEvent(EV_NewEnchantTryFail);		//9769;
	RegisterEvent(EV_NewEnchantRetryPutItemsOK);
	RegisterEvent(EV_NewEnchantRetryPutItemsFail);
}

event OnLoad()
{
	SetClosingOnESC();
	Skip_CheckBox = GetCheckBoxHandle("ItemJewelEnchantWnd.Skip_CheckBox");
	Skip_CheckBox.SetCheck(GetOptionBool("UI", "ItemJewelEnchantWndAnimShow"));
	EnchantJewel1 = GetItemWindowHandle("ItemJewelEnchantWnd.EnchantJewel1");
	EnchantJewel2 = GetItemWindowHandle("ItemJewelEnchantWnd.EnchantJewel2");
	EnchantedItemSlot = GetItemWindowHandle("ItemJewelEnchantWnd.EnchantedItemSlot");
	InvenInventoryItem = GetItemWindowHandle("InventoryWnd.InventoryItem");
	itemJewelEnchantSubWnd_ItemWnd = GetItemWindowHandle("ItemJewelEnchantSubWnd.ItemJewelEnchantSubWnd_ItemWnd");
	moveItem1 = GetItemWindowHandle("ItemJewelEnchantWnd.moveItem1");
	moveItem2 = GetItemWindowHandle("ItemJewelEnchantWnd.moveItem2");
	InstructionTxt = GetTextBoxHandle("ItemJewelEnchantWnd.InstructionTxt");
	WarningTxt = GetTextBoxHandle("ItemJewelEnchantWnd.WarningTxt");
	ProbTxt = GetTextBoxHandle("ItemJewelEnchantWnd.ProbTxt");
	EnchantBtn = GetButtonHandle("ItemJewelEnchantWnd.EnchantBtn");
	InitBtn = GetButtonHandle("ItemJewelEnchantWnd.InitBtn");
	nextbtn = GetButtonHandle("ItemJewelEnchantWnd.nextbtn");
	continueBtn = GetButtonHandle("ItemJewelEnchantWnd.continueBtn");
	CancelBtn = GetButtonHandle("itemJewelEnchantWnd.CancelBtn");
	EnchantJewel1BackTex = GetTextureHandle("ItemJewelEnchantWnd.EnchantJewel1BackTex");
	EnchantJewel2BackTex = GetTextureHandle("ItemJewelEnchantWnd.EnchantJewel2BackTex");
	EnchantedJewelBackTex = GetTextureHandle("ItemJewelEnchantWnd.EnchantedJewelBackTex");
	DropHighlight_EnchantJewel1 = GetTextureHandle("ItemJewelEnchantWnd.DropHighlight_EnchantJewel1");
	DropHighlight_EnchantJewel2 = GetTextureHandle("ItemJewelEnchantWnd.DropHighlight_EnchantJewel2");
	Groupbox0_tex = GetTextureHandle("ItemJewelEnchantWnd.TopBg_Wnd.Groupbox0_tex");
	shadowItem_tex1 = GetAnimTextureHandle("ItemJewelEnchantWnd.shadowItem_tex1");
	shadowItem_tex2 = GetAnimTextureHandle("ItemJewelEnchantWnd.shadowItem_tex2");
	ShadowItem_texEnd = GetAnimTextureHandle("ItemJewelEnchantWnd.shadowItem_texEnd");
	dropResult_AniTex1 = GetAnimTextureHandle("ItemJewelEnchantWnd.dropResult_AniTex1");
	dropResult_AniTex2 = GetAnimTextureHandle("ItemJewelEnchantWnd.dropResult_AniTex2");
	m_hItemEnchantWndEnchantProgress = GetProgressCtrlHandle("ItemJewelEnchantWnd.EnchantProgress");
	mainEffectViewport = GetEffectViewportWndHandle("ItemJewelEnchantWnd.mainEffectViewport");
	Dialog_Wnd = GetWindowHandle("ItemJewelEnchantWnd.Dialog_Wnd");
	EnchantItemList_RichList = GetRichListCtrlHandle("ItemJewelEnchantWnd.Dialog_Wnd.EnchantItemList_RichList");
	ItemJewelEnchantSubWndScript = ItemJewelEnchantSubWnd(GetScript("ItemJewelEnchantSubWnd"));
	uiTimerObj = class'L2UITimer'.static.Inst()._AddNewTimerObject();
	uiTimerObj._DelegateOnEnd = NextProcess;
	iObject = class'L2UIInventory'.static.Inst().NewObject();
	iObject.DelegateOnAddItem = HandleOnAddItem;
	iObject.DelegateOnUpdateItem = HandleOnUpdateItem;
	iObject.DelegateOnCompare = HandleOnCompare;
	InitRichListScript();
	InitUIControlNumberInputSteper();
	InitAutoEnchant();
	InitTransformAutoEncahnt();
	SetState(STATE_BEGIN);	
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x1D
		case EV_NewEnchantPushOneOK:
			HandleAddJewel1(param);
			// End:0x124
			break;
		// End:0x30
		case EV_NewEnchantPushOneFail:
			bRequestPushOne = false;
			// End:0x124
			break;
		// End:0x46
		case EV_NewEnchantPushTwoOK:
			HandleAddJewel2(param);
			// End:0x124
			break;
		// End:0x59
		case EV_NewEnchantPushTwoFail:
			bRequestPushTwo = false;
			// End:0x124
			break;
		// End:0x6F
		case EV_NewEnchantRemoveOneOK:
			HandleRemoveJewel1(param);
			// End:0x124
			break;
		// End:0x88
		case EV_NewEnchantRemoveOneFail:
			bRequestRemoveOne = false;
			// End:0x124
			break;
		// End:0x9E
		case EV_NewEnchantRemoveTwoOK:
			HandleRemoveJewel2(param);
			// End:0x124
			break;
		// End:0xB7
		case EV_NewEnchantRemoveTwoFail:
			bRequestRemoveTwo = false;
			// End:0x124
			break;
		// End:0xCD
		case EV_NewEnchantTrySuccess:
			HandleEnchantResult(param);
			// End:0x124
			break;
		// End:0xE3
		case EV_NewEnchantTryFail:
			HandleEnchantResult(param);
			// End:0x124
			break;
		// End:0x102
		case EV_NewEnchantRetryPutItemsOK:
			HandleNewEnchantRetryPutItems(true, param);
			// End:0x124
			break;
		// End:0x121
		case EV_NewEnchantRetryPutItemsFail:
			HandleNewEnchantRetryPutItems(false, param);
			// End:0x108
			break;
	}
}

event OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		// End:0x2D
		case class'L2UITween'.const.TWEENEND:
			HandleOnTweenEnd(int(param));
			// End:0x30
			break;
	}	
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	InitTransformDye();
	SetState(STATE_READY);
	GetWindowHandle("ItemJewelEnchantSubWnd").ShowWindow();
	ItemJewelEnchantSubWndScript._Refresh();
	m_hOwnerWnd.SetFocus();
	PlayEffectStandBy();
	PlaySound("InterfaceSound.ui_synthesis_open");	
}

event OnHide()
{
	SetState(STATE_READY);
	API_RequestClose();
	InitFlags();
	// End:0x60
	if((DialogIsMine()) && class'DialogBox'.static.Inst().m_hOwnerWnd.IsShowWindow())
	{
		class'DialogBox'.static.Inst().HideDialog();
	}
	uiTimerObj._Stop();
	// End:0xDE
	if(currentEnchantType == EnchantType.dye/*1*/)
	{
		class'L2Util'.static.Inst().syncWindowLoc(m_hOwnerWnd.m_WindowNameWithFullPath, "HennaDyeEnchantWnd");
		GetWindowHandle("HennaDyeEnchantWnd").ShowWindow();
	}
}

event OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	// End:0x15
	if(a_itemInfo.ShortcutType == EShortCutItemType.SCIT_MACRO)
	{
		return;
	}
	// End:0x46
	if(a_itemInfo.DragSrcName != "ItemJewelEnchantSubWnd_ItemWnd")
	{
		return;
	}
	// End:0x51
	if(_IsWorkingEnchant())
	{
		return;
	}
	switch(GetStateName())
	{
		// End:0x6D
		case STATE_READY:
			_DropProcess(a_itemInfo, 1);
			// End:0x90
			break;
		// End:0x75
		case STATE_ONEREADY:
		// End:0x8D
		case STATE_ALLREADY:
			_DropProcess(a_itemInfo, 2);
			// End:0x90
			break;
	}
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo tmpJewelItemInfo1, tmpJewelItemInfo2;

	// End:0x0B
	if(_IsWorkingEnchant())
	{
		return;
	}
	switch(ControlName)
	{
		// End:0x73
		case "EnchantJewel1":
			// End:0x42
			if(_GetSlot1ItemInfo(tmpJewelItemInfo1))
			{
				API_RequestRemoveOne(tmpJewelItemInfo1.Id);
			}
		// End:0xD8
		case "EnchantJewel2":
			// End:0x79
			if(_GetSlot2ItemInfo(tmpJewelItemInfo2))
			{
				API_RequestRemoveTwo(tmpJewelItemInfo2.Id);
			}
			// End:0xFA
			break;
		// End:0xA2
		case "AutoJewelItemWindow":
			RemoveInventoryItem(Index);
			// End:0xA5
			break;
	}
}

event OnDropItemSource(string strTarget, ItemInfo Info)
{
	local int Index;

	// End:0x0B
	if(_IsWorkingEnchant())
	{
		return;
	}
	// End:0x7C
	if(strTarget == "Console")
	{
		switch(Info.DragSrcName)
		{
			// End:0x64
			case "AutoJewelItemWindow":
				Index = InventoryItem.FindItem(Info.Id);
				// End:0x67
				break;
		}
		OnDBClickItem(Info.DragSrcName, Index);
	}
}

event OnClickCheckBox(string strID)
{
	switch(strID)
	{
		// End:0x8B
		case "Skip_CheckBox":
			SetOptionBool("UI", "ItemJewelEnchantWndAnimShow", Skip_CheckBox.IsChecked());
			break;
	}
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x8B
		case "InitBtn":
			// End:0x49
			if(GetStateName() == STATE_RESULT || GetStateName() == STATE_AUTORESULT)
			{
				SetState(STATE_READY);
				RefreshSubWnd();
				API_RequestClose();
			}
			else
			{
				OnDBClickItem("EnchantJewel1", 0);
			}
			// End:0x196
			break;
		// End:0x84
		case "AutoEnchantClose_btn":
			TransformAutoEnchantClose();
			// End:0x196
			break;
		// End:0xA5
		case "AutoEnchantOpen_btn":
			TransFormAutoEnchantOpen();
			// End:0x196
			break;
		// End:0xBA
		case "nextbtn":
			HandleOnCLickResultItem();
			// End:0x196
			break;
		// End:0xD3
		case "continueBtn":
			HandleOnClickRetry();
			// End:0x196
			break;
		// End:0xEB
		case "EnchantBtn":
			StateFuncOnCclickEnchantBtn();
			// End:0x196
			break;
		// End:0x111
		case "DialogConfirmBtn":
			SetState(STATE_PROCESS);
			PlayEffectProgress();
		// End:0x12E
		case "DialogCancelBtn":
			HideDialog_Wnd();
			// End:0x196
			break;
		// End:0x17C
		case "WindowHelp_BTN":
			// End:0x168
			if(getInstanceUIData().getIsClassicServer())
			{
				//class'HelpWnd'.static.ShowHelp(72);				
			}
			else
			{
				//class'HelpWnd'.static.ShowHelp(127);
			}
			// End:0x196
			break;
		// End:0x193
		case "cancelBtn":
			StateFuncOnCclickCancelBtn();
			// End:0x196
			break;
	}
}

event OnTextureAnimEnd(AnimTextureHandle a_AnimTextureHandle)
{
	switch(a_AnimTextureHandle)
	{
		// End:0x15
		case shadowItem_tex1:
			InventoryItemAllClearClearItems();
		// End:0x2F
		case shadowItem_tex2:
			a_AnimTextureHandle.HideWindow();
			// End:0x54
			break;
		// End:0x37
		case dropResult_AniTex2:
		// End:0x51
		case dropResult_AniTex1:
			a_AnimTextureHandle.HideWindow();
			// End:0x54
			break;
	}
}

event OnScrollMove(string strID, int pos)
{
	Debug("OnScrommMove" @ strID @ string(pos));	
}

event OnProgressTimeUp(string strID)
{
	switch(strID)
	{
		// End:0x24
		case "EnchantProgress":
			API_RequestTryEnchant();
			// End:0x27
			break;
	}	
}

private function int GetProgressTIme()
{
	// End:0x24
	if(_IsAutoMode())
	{
		// End:0x1E
		if(GetResultEffectType() > 0)
		{
			return TIMER_DELAY_AUTOEffect2;			
		}
		else
		{
			return TIMER_DELAY_AUTO;
		}		
	}
	else
	{
		// End:0x39
		if(Skip_CheckBox.IsChecked())
		{
			return TIMER_DELAY_SKIP;
		}
	}
	return TIMER_DELAY;	
}

private function FindSameItemArray(ItemInfo iInfo, out array<ItemInfo> iInfos)
{
	local int i;
	local array<ItemInfo> iiInfos;

	iInfos.Length = 0;
	// End:0x40
	if(IsStackableItem(iInfo.ConsumeType))
	{
		class'UIDATA_INVENTORY'.static.FindItemByClassID(iInfo.Id.ClassID, iInfos);
		return;
	}
	// End:0x88
	if(getInstanceUIData().getIsClassicServer())
	{
		getInstanceL2Util().FindItemByClassIDWithFilter(iInfo.Id.ClassID, iiInfos, getInstanceL2Util().EItemLockedCheckType.UNLOCK,, 1);		
	}
	else
	{
		getInstanceL2Util().FindItemByClassID(iInfo.Id.ClassID, iiInfos, getInstanceL2Util().EItemLockedCheckType.UNLOCK);
	}

	// End:0x166 [Loop If]
	for(i = 0; i < iiInfos.Length; i++)
	{
		// End:0x15C
		if(iiInfos[i].Id.ClassID == iInfo.Id.ClassID && iiInfos[i].Enchanted == iInfo.Enchanted && iInfo.Id.ServerID != iiInfos[i].Id.ServerID)
		{
			iInfos[iInfos.Length] = iiInfos[i];
		}
	}	
}

private function HandleOnClickRetry()
{
	local int i;
	local array<ItemInfo> itemInfoArray;

	FindSameItemArray(jewel1ItemInfo, itemInfoArray);
	API_RequestPushOne(itemInfoArray[0], true);
	FindSameItemArray(jewel2ItemInfo, itemInfoArray);
	// End:0x76
	if(IsStackableItem(jewel1ItemInfo.ConsumeType))
	{
		API_RequestPushTwo(itemInfoArray[0], true);
		API_RequestEnchantRetryPutItems(jewel1ItemInfo.Id.ServerID, jewel2ItemInfo.Id.ServerID);		
	}
	else
	{
		// End:0xF7 [Loop If]
		for(i = 0; i < itemInfoArray.Length; i++)
		{
			// End:0xED
			if(itemInfoArray[i].Id != jewel1ItemInfo.Id)
			{
				API_RequestPushTwo(itemInfoArray[i], true);
				API_RequestEnchantRetryPutItems(jewel1ItemInfo.Id.ServerID, itemInfoArray[i].Id.ServerID);
				return;
			}
		}
	}	
}

private function HandleOnCLickResultItem()
{
	local int i;
	local ItemInfo resultJewelItemInfo;
	local INT64 nCommissionAdena;
	local array<ItemInfo> MaterialItems;
	local array<int> CandidateMaterials;

	EnchantedItemSlot.GetItem(0, resultJewelItemInfo);
	// End:0x4E
	if(! ItemJewelEnchantSubWndScript._CanEnchatItem(resultJewelItemInfo.Id.ClassID, resultJewelItemInfo.Enchanted, nCommissionAdena, MaterialItems))
	{
		return;
	}
	EnchantJewel1DeleteItem();
	EnchantJewel2DeleteItem();
	// End:0x101
	if(API_GetEnchantCandidateMaterialList(resultJewelItemInfo.Id.ClassID, CandidateMaterials) == 1)
	{
		API_RequestPushOne(resultJewelItemInfo, true);

		// End:0x101 [Loop If]
		for(i = 0; i < MaterialItems.Length; i++)
		{
			// End:0xF7
			if(MaterialItems[i].Id != resultJewelItemInfo.Id)
			{
				API_RequestPushTwo(MaterialItems[i], true);
				API_RequestEnchantRetryPutItems(jewel1ItemInfo.Id.ServerID, jewel2ItemInfo.Id.ServerID);
				return;
			}
		}
	}
	API_RequestPushOne(resultJewelItemInfo);	
}

private function SetClearRichListNeedItem()
{
	Debug(" -------------------------- _SetClearRichListNeedItem 클리어 오브젝트 ------------------------------------- ");
	UIControlNeedItemListObj.CleariObjects();
	currentCommissionAdena = 0;	
}

private function SetRichListNeedItem()
{
	local INT64 Commission;
	local array<ItemInfo> MaterialItems;

	API_GetMaterialItemForEnchantFromInven(jewel1ItemInfo.Id.ClassID, jewel1ItemInfo.Enchanted, jewel2ItemInfo.Id.ClassID, jewel2ItemInfo.Enchanted, Commission, MaterialItems);
	// End:0x64
	if((currentCommissionAdena == Commission) && currentCommissionAdena != 0)
	{
		return;
	}
	UIControlNeedItemListObj.StartNeedItemList(1);
	UIControlNeedItemListObj.AddNeedItemClassID(57, Commission);
	UIControlNeedItemListObj.SetBuyNum(1);
	currentCommissionAdena = Commission;	
}

private function InitTransformDye()
{
	// End:0x56
	if(currentEnchantType == EnchantType.dye/*1*/)
	{
		setWindowTitleByString(GetSystemString(13812));
		getInstanceL2Util().syncWindowLoc("HennaDyeEnchantWnd", m_hOwnerWnd.m_WindowNameWithFullPath);		
	}
	else
	{
		setWindowTitleByString(GetSystemString(3189));
	}	
}

private function InitTransformAutoEncahnt()
{
	// End:0x12
	if(_IsAutoMode())
	{
		TransFormAutoEnchantOpen();		
	}
	else
	{
		TransformAutoEnchantClose();
	}
}

private function TransFormAutoEnchantOpen()
{
	SetINIInt(m_hOwnerWnd.m_WindowNameWithFullPath, "e", 1, "WindowsInfo.ini");
	AutoEnchant_wnd.SetFocus();
	AutoEnchant_wnd.ShowWindow();
	m_hOwnerWnd.SetWindowSize(696, 770);
	RefreshSubWnd();
	Skip_CheckBox.HideWindow();
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".TopBg_Wnd.SubTitle_Txt").SetText(GetSystemString(14117));
}

private function TransformAutoEnchantClose()
{
	SetINIInt(m_hOwnerWnd.m_WindowNameWithFullPath, "e", 0, "WindowsInfo.ini");
	AutoEnchant_wnd.HideWindow();
	m_hOwnerWnd.SetWindowSize(696, 624);
	ClearAutoJewelItemWindow();
	RefreshSubWnd();
	Skip_CheckBox.ShowWindow();
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".TopBg_Wnd.SubTitle_Txt").SetText(GetSystemString(14116));
}

private function EnableTransformAutosNCheckBox()
{
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.AutoEnchantClose_btn").EnableWindow();
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.AutoEnchantOpen_btn").EnableWindow();
	Skip_CheckBox.EnableWindow();
}

private function DisableTransformAutosNCheckBox()
{
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.AutoEnchantClose_btn").DisableWindow();
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.AutoEnchantOpen_btn").DisableWindow();
	Skip_CheckBox.DisableWindow();
}

private function EnchantJewel1AddItem(ItemInfo iInfo)
{
	EnchantJewel1.Clear();
	EnchantJewel1.AddItem(iInfo);
	EnchantJewel1.ShowWindow();
	EnchantJewel1BackTex.HideWindow();
	dropResult_AniTex1.ShowWindow();
	dropResult_AniTex1.SetLoopCount(1);
	dropResult_AniTex1.Play();
}

private function EnchantJewel2AddItem(ItemInfo iInfo)
{
	EnchantJewel2.Clear();
	EnchantJewel2.AddItem(iInfo);
	EnchantJewel2.ShowWindow();
	EnchantJewel2BackTex.HideWindow();
	dropResult_AniTex2.ShowWindow();
	dropResult_AniTex2.SetLoopCount(1);
	dropResult_AniTex2.Play();
	SetateTxtProbTxt();
	SetRichListNeedItem();
}

private function EnchantJewel1DeleteItem()
{
	EnchantJewel1.Clear();
	EnchantJewel1BackTex.ShowWindow();
	dropResult_AniTex1.HideWindow();
}

private function EnchantJewel2DeleteItem()
{
	EnchantJewel2.Clear();
	EnchantJewel2BackTex.ShowWindow();
	dropResult_AniTex2.HideWindow();
	SetClearRichListNeedItem();
	ClearAutoJewelItemWindow();
}

private function EnchantedItemSlotAdd(ItemInfo iInfo)
{
	EnchantedItemSlot.MoveC(slotEndStartRect.nX, slotEndStartRect.nY);
	EnchantedItemSlot.SetAlpha(0);
	EnchantedItemSlot.Clear();
	EnchantedItemSlot.AddItem(iInfo);
	EnchantedItemSlot.ShowWindow();
	// End:0x87
	if(_IsAutoMode())
	{
		EnchantedItemSlot.SetAlpha(255, 0.10f);		
	}
	else
	{
		EnchantedItemSlot.SetAlpha(255, 0.50f);
	}
	EnchantedJewelBackTex.ShowWindow();
}

private function EnchantedItemSlotDelete()
{
	EnchantedItemSlot.SetAlpha(0);
	EnchantedItemSlot.HideWindow();
	EnchantedJewelBackTex.HideWindow();
}

private function HandleAddJewel1(optional string param)
{
	// End:0x23
	if(! m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.ShowWindow();
	}
	EnchantJewel1AddItem(jewel1ItemInfo);
	// End:0x5B
	if(bRequestPushOne)
	{
		numberInputStepper._setRangeMinMaxNum(1, 1);
		bRequestPushOne = false;
		SetState(STATE_ONEREADY);
	}
	// End:0x6C
	if(! SetItemSlot2())
	{
		RefreshSubWnd();
	}	
}

private function HandleAddJewel2(optional string param)
{
	EnchantJewel2AddItem(jewel2ItemInfo);
	// End:0x3D
	if(bRequestPushTwo)
	{
		SetState(STATE_ALLREADY);
		bRequestPushTwo = false;
	}
	RefreshSubWnd();	
}

private function HandleRemoveJewel1(optional string param)
{
	bRequestRemoveOne = false;
	EnchantJewel1DeleteItem();
	SetState(STATE_READY);
	RefreshSubWnd();
}

private function HandleRemoveJewel2(optional string param)
{
	bRequestRemoveTwo = false;
	EnchantJewel2DeleteItem();
	SetState(STATE_ONEREADY);
	RefreshSubWnd();	
}

private function HandleNewEnchantRetryPutItems(bool bSuccess, optional string param)
{
	bRequestedPushRetry = false;
	Debug("------------ HandleNewEnchantRetryPutItems --------------");
	Debug("bSuccess" @ string(bSuccess));
	Debug("param:" @ param);
	// End:0xFB
	if(bSuccess)
	{
		HandleAddJewel1();
		HandleAddJewel2();
		// End:0xC5
		if(_IsAutoMode())
		{
			PlaySound("InterfaceSound.ui_synthesis_in");
			NextProcess();			
		}
		else
		{
			PlaySound("InterfaceSound.ui_synthesis_slot");
			SetState(STATE_ALLREADY);
		}		
	}
	else
	{
		HandleRemoveJewel1();
		HandleRemoveJewel2();
	}
	RefreshSubWnd();	
}

function ItemID _DropProcess(ItemInfo a_itemInfo, int SlotIndex, optional bool bNoRequestServer)
{
	local ItemInfo tmpJewelItemInfo1, tmpJewelItemInfo2;
	local ItemID emptyItemID;
	local int i;
	local array<ItemInfo> itemInfoArray;

	// End:0x16
	if(a_itemInfo.bDisabled > 0)
	{
		return emptyItemID;
	}
	// End:0x2F
	if(a_itemInfo.ShortcutType == 4)
	{
		return emptyItemID;
	}
	// End:0x5D
	if(GetStateName() == STATE_ALLREADY && _IsAutoMode())
	{
		AddInventoryItem(a_itemInfo);
		return a_itemInfo.Id;
	}
	_GetSlot1ItemInfo(tmpJewelItemInfo1);
	_GetSlot2ItemInfo(tmpJewelItemInfo2);
	// End:0xA5
	if(SlotIndex == 0)
	{
		// End:0x9D
		if(tmpJewelItemInfo1.Id.ClassID <= 0)
		{
			SlotIndex = 1;			
		}
		else
		{
			SlotIndex = 2;
		}
	}
	// End:0x123
	if(IsStackableItem(a_itemInfo.ConsumeType))
	{
		InvenInventoryItem.GetItem(InventoryItem.FindItemByClassID(a_itemInfo.Id), a_itemInfo);
		// End:0x104
		if(SlotIndex == 1)
		{
			API_RequestPushOne(a_itemInfo, bNoRequestServer);			
		}
		else
		{
			API_RequestPushTwo(a_itemInfo, bNoRequestServer);
		}
		return a_itemInfo.Id;		
	}
	else
	{
		// End:0x16B
		if(getInstanceUIData().getIsClassicServer())
		{
			getInstanceL2Util().FindItemByClassIDWithFilter(a_itemInfo.Id.ClassID, itemInfoArray, getInstanceL2Util().EItemLockedCheckType.UNLOCK,, 1);			
		}
		else
		{
			getInstanceL2Util().FindItemByClassID(a_itemInfo.Id.ClassID, itemInfoArray, getInstanceL2Util().EItemLockedCheckType.UNLOCK);
		}
		// End:0x20E
		if(SlotIndex == 1)
		{
			// End:0x20B [Loop If]
			for(i = 0; i < itemInfoArray.Length; i++)
			{
				// End:0x1DF
				if(itemInfoArray[i].Enchanted != a_itemInfo.Enchanted)
				{
					// [Explicit Continue]
					continue;
				}
				API_RequestPushOne(a_itemInfo, bNoRequestServer);
				return itemInfoArray[i].Id;
			}			
		}
		else if(SlotIndex == 2)
		{
			// End:0x2B1 [Loop If]
			for(i = 0; i < itemInfoArray.Length; i++)
			{
				// End:0x253
				if(itemInfoArray[i].Enchanted != a_itemInfo.Enchanted)
				{
					// [Explicit Continue]
					continue;
				}
				// End:0x27F
				if(itemInfoArray[i].Id.ServerID == jewel1ItemInfo.Id.ServerID)
				{
					// [Explicit Continue]
					continue;
				}
				API_RequestPushTwo(itemInfoArray[i], bNoRequestServer);
				return itemInfoArray[i].Id;
			}
		}
	}
	return emptyItemID;	
}

private function bool SetItemSlot2()
{
	local INT64 nCommissionAdena;
	local array<ItemInfo> itemInfoArray;
	local array<int> CandidateMaterials;

	// End:0x64
	if(_GetClassIDBySlotItemIndex(2) < 1)
	{
		// End:0x64
		if(class'ItemJewelEnchantSubWnd'.static.Inst()._GetCanEnchantItemCurrent(nCommissionAdena, itemInfoArray))
		{
			// End:0x64
			if((API_GetEnchantCandidateMaterialList(_GetClassIDBySlotItemIndex(1), CandidateMaterials)) == 1)
			{
				return _DropProcess(itemInfoArray[0], 2).ClassID > 0;
			}
		}
	}
	return false;	
}

private function RefreshSubWnd()
{
	// End:0x18
	if(BRequesteEnd())
	{
		ItemJewelEnchantSubWndScript._Refresh();
	}
}

private function HandleEnchantResult(string param)
{
	local int ClassID, Enchanted;
	local ItemInfo iInfo;

	ParseInt(param, "ItemClassID", ClassID);
	Debug(" 결과 보기 HandleEnchantResult" @ param);
	// End:0x7E
	if(ClassID == 0)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(213));
		m_hOwnerWnd.HideWindow();
		return;
	}
	class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(ClassID), iInfo);
	ParseInt(param, "ItemEnchant", Enchanted);
	iInfo.Enchanted = Enchanted;
	iInfo.ItemNum = 1;
	// End:0x103
	if(iInfo.AdditionalName != "")
	{
		iInfo.AdditionalName = iInfo.AdditionalName $ " ";
	}
	// End:0x121
	if(GetResult(iInfo))
	{
		showResult(ResultType.result_Success/*1*/, iInfo);		
	}
	else
	{
		// End:0x13A
		if(API_IsNoFailResultEffectType())
		{
			showResult(ResultType.result_only/*2*/, iInfo);			
		}
		else
		{
			showResult(ResultType.result_fail/*0*/, iInfo);
		}
	}
	EnchantedItemSlotAdd(iInfo);
	SetState(STATE_RESULT);
}

private function bool GetResult(out ItemInfo _resultItem)
{
	local bool bSuccess;
	local CombinationItemUIData o_data;

	API_GetCombinationItemDataCurrent(o_data);
	Debug(string(_resultItem.Id.ClassID) @ string(o_data.ResultItems[0].ClassID) @ string(_resultItem.Enchanted) @ string(o_data.ResultItems[0].Enchant));
	bSuccess = (_resultItem.Id.ClassID == o_data.ResultItems[0].ClassID) && _resultItem.Enchanted == o_data.ResultItems[0].Enchant;
	// End:0xCF
	if(bSuccess)
	{
		_resultItem.ItemNum = o_data.ResultItems[0].Num;		
	}
	else
	{
		_resultItem.ItemNum = o_data.ResultItems[1].Num;
	}
	return bSuccess;
}

private function showResult(ResultType Type, ItemInfo iInfo)
{
	local int strMsgNum;
	local string ItemName;

	switch(Type)
	{
		// End:0x20
		case ResultType.result_fail/*0*/:
			strMsgNum = 4414;
			PlayEffectFail();
			// End:0x55
			break;
		// End:0x39
		case ResultType.result_Success/*1*/:
			strMsgNum = 4413;
			PlayEffectSuccess();
			// End:0x55
			break;
		// End:0x52
		case ResultType.result_only/*2*/:
			strMsgNum = 4417;
			PlayEffectSuccess();
			// End:0x55
			break;
	}
	ItemName = iInfo.Name @ iInfo.AdditionalName;
	// End:0x9F
	if(iInfo.Enchanted > 0)
	{
		ItemName = ("+" $ string(iInfo.Enchanted)) @ ItemName;
	}
	InstructionTxt.SetText(MakeFullSystemMsg(GetSystemMessage(strMsgNum), ItemName, string(iInfo.ItemNum)));	
}

private function ShowDialog(ItemInfo iInfo)
{
	local INT64 limitNum;

	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_BG").ShowWindow();
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_BG").SetFocus();
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), iInfo.Name, ""), string(self));
	limitNum = ItemJewelEnchantSubWndScript._GetIneventoryItemNum(iInfo);
	DialogSetInputlimit(limitNum);
	DialogSetParamInt64(limitNum);
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultOK);
	class'DialogBox'.static.Inst().SetReservedItemInfo(iInfo);
	class'DialogBox'.static.Inst().AnchorToOwner();
	class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
	class'DialogBox'.static.Inst().DelegateOnHide = HandleDialogOnHide;	
}

private function HandleDialogOK()
{
	local INT64 ItemNum;
	local ItemInfo iInfo;

	ItemNum = MAX64(0, int64(DialogGetString()));
	// End:0x27
	if(ItemNum == 0)
	{
		return;
	}
	class'DialogBox'.static.Inst().GetReservedItemInfo(iInfo);
	ItemJewelEnchantSubWndScript._MoveToOwner(iInfo, ItemNum);	
}

private function HandleDialogOnHide()
{
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_BG").HideWindow();	
}

//ё®ДщЅєЖ®їЎ ґлЗС ґдєЇА» ёрµО №ЮѕТґВБц ГјЕ© ЗФ.(ї№їЬ »зЗЧА» БЩАМ±в А§ЗФ)
function bool BRequesteEnd()
{
	return !bRequestedPushRetry && !bRequestTryEnchant && !bRequestPushOne && !bRequestPushTwo && !bRequestRemoveOne && ! bRequestRemoveTwo;	
}

function bool _HasItemInSlot(int SlotIndex)
{
	local ItemInfo Info;

	// End:0x1A
	if(SlotIndex == 1)
	{
		return _GetSlot1ItemInfo(Info);		
	}
	else
	{
		return _GetSlot2ItemInfo(Info);
	}
	return false;	
}

function bool _IsWorkingEnchant()
{
	switch(GetStateName())
	{
		// End:0x0D
		case STATE_RESULT:
		// End:0x17
		case STATE_PROCESS:
			return true;
	}
	return false;
}

function bool _IsAutoMode()
{
	local int E;

	GetINIInt(m_hOwnerWnd.m_WindowNameWithFullPath, "e", E, "WindowsInfo.ini");
	return E == 1;	
}

function HandleOnAddItem(optional ItemInfo iInfo, optional int Index)
{
	SetNextOnResultItem(iInfo);	
}

function HandleOnUpdateItem(optional ItemInfo iInfo, optional int Index)
{
	SetNextOnResultItem(iInfo);	
}

private function SetNextOnResultItem(ItemInfo iInfo)
{
	local ItemInfo resultJewelItemInfo;

	bRequestTryEnchant = false;
	EnchantedItemSlot.GetItem(0, resultJewelItemInfo);
	// End:0x4B
	if(IsStackableItem(iInfo.ConsumeType))
	{
		iInfo.bShowCount = true;
		iInfo.ItemNum = 1;
	}
	EnchantedItemSlot.SetItem(0, iInfo);
	// End:0x72
	if(_IsAutoMode())
	{
		NextProcess();		
	}
	else
	{
		RefreshSubWnd();
		CheckBtnsOnResult();
	}	
}

function bool HandleOnCompare(optional ItemInfo iInfo, optional int Index)
{
	local ItemInfo resultJewelItemInfo;

	// End:0x16
	if(! m_hOwnerWnd.IsShowWindow())
	{
		return false;
	}
	// End:0x23
	if(! bRequestTryEnchant)
	{
		return false;
	}
	// End:0x32
	if(GetStateName() != STATE_RESULT)
	{
		return false;
	}
	// End:0x4E
	if(! EnchantedItemSlot.GetItem(0, resultJewelItemInfo))
	{
		return false;
	}
	// End:0x8E
	if(iInfo.Id.ClassID == resultJewelItemInfo.Id.ClassID && resultJewelItemInfo.Enchanted == iInfo.Enchanted)
	{
		return true;
	}
	return false;	
}

private function InventoryItemAllClearClearItems()
{
	local int idx;
	local ItemInfo ClearItem;

	GetClearItem(ClearItem);

	// End:0x5D [Loop If]
	while(InventoryItem.GetItem(idx, ClearItem))
	{
		// End:0x53
		if(! IsValidItemID(ClearItem.Id))
		{
			InventoryItem.DeleteItem(idx);			
		}
		else
		{
			idx++;
		}
	}	
}

private function int GetClearItemIndex()
{
	local int idx;
	local ItemInfo ClearItem;

	// End:0x41 [Loop If]
	while(InventoryItem.GetItem(idx, ClearItem))
	{
		// End:0x37
		if(! IsValidItemID(ClearItem.Id))
		{
			return idx;
		}
		idx++;
	}
	return -1;	
}

private function int GetSameItemIndex(ItemInfo iInfo)
{
	local int idx;
	local ItemInfo iiInfo;

	// End:0x6A [Loop If]
	while(InventoryItem.GetItem(idx, iiInfo))
	{
		// End:0x60
		if(iInfo.Id.ClassID == iiInfo.Id.ClassID && iInfo.Enchanted == iiInfo.Enchanted)
		{
			return idx;
		}
		idx++;
	}
	return -1;	
}

private function NextProcess()
{
	// End:0x12
	if(autoProcessStepType == AUTOPROCESS_STEP_TYPE.resultBylevel/*8*/)
	{
		return;
	}
	Debug(" ----- ** NextProcess ** ---- " @ string(autoProcessStepType));
	autoProcessStepType = AUTOPROCESS_STEP_TYPE(autoProcessStepType + 1);
	switch(autoProcessStepType)
	{
		// End:0x82
		case AUTOPROCESS_STEP_TYPE.onResult/*1*/:
			uiTimerObj._time = TIMER_DELAY_AUTO;
			uiTimerObj._Reset();
			// End:0x1AE
			break;
		// End:0xB0
		case AUTOPROCESS_STEP_TYPE.itputResult/*2*/:
			uiTimerObj._time = 200;
			uiTimerObj._Reset();
			NextProcessInputResult();
			// End:0x1AE
			break;
		// End:0xDE
		case AUTOPROCESS_STEP_TYPE.itputResultReady/*3*/:
			uiTimerObj._time = 10;
			uiTimerObj._Reset();
			NextProcessInputResultReady();
			// End:0x1AE
			break;
		// End:0x10C
		case AUTOPROCESS_STEP_TYPE.inputNext/*4*/:
			uiTimerObj._time = 200;
			uiTimerObj._Reset();
			NextProcessInputNext();
			// End:0x1AE
			break;
		// End:0x119
		case AUTOPROCESS_STEP_TYPE.inputNextReady/*5*/:
			NextProcessInputNextReady();
			return;
		// End:0x187
		case AUTOPROCESS_STEP_TYPE.Progress/*6*/:
			// End:0x13F
			if(! UIControlNeedItemListObj.GetCanBuy())
			{
				SetState(STATE_ALLREADY);
				return;
			}
			// End:0x158
			if(bPausedAuto)
			{
				SetState(STATE_ALLREADY);
				return;				
			}
			else
			{
				SetResultEffectType();
				uiTimerObj._time = 10;
				uiTimerObj._Reset();
				SetateTxtProbTxt();
			}
			// End:0x1AE
			break;
		// End:0x1AB
		case AUTOPROCESS_STEP_TYPE.progressStart/*7*/:
			// End:0x1A3
			if(bPausedAuto)
			{
				SetState(STATE_ALLREADY);				
			}
			else
			{
				NextProcessProgress();
			}
			return;
	}	
}

private function NextProcessProgress()
{
	SetState(STATE_PROCESS);	
}

private function NextProcessInputResult()
{
	local Rect slotRect, wndRect;
	local int nX, nY, idx;
	local ItemInfo resultJewelItemInfo, ClearItem, iInfo;

	EnchantedItemSlot.GetItem(0, resultJewelItemInfo);
	idx = FindLastInventoryItemIndexItemInfo(resultJewelItemInfo);
	InventoryItem.GetItem(idx, iInfo);
	// End:0x95
	if((IsStackableItem(resultJewelItemInfo.ConsumeType) && resultJewelItemInfo.Id.ClassID == iInfo.Id.ClassID) && resultJewelItemInfo.Enchanted == iInfo.Enchanted)
	{		
	}
	else
	{
		GetClearItem(ClearItem);
		InsertInventoryItemItemInfo(idx, ClearItem);
	}
	// End:0xC5
	if(GetPosItemWIndowWithIndex(idx, slotRect))
	{
		return;
	}
	wndRect = m_hOwnerWnd.GetRect();
	nX = slotRect.nX - wndRect.nX;
	nY = slotRect.nY - wndRect.nY;
	shadowItem_tex2.Stop();
	shadowItem_tex2.MoveC(nX, nY);
	shadowItem_tex2.ShowWindow();
	shadowItem_tex2.SetLoopCount(1);
	shadowItem_tex2.Play();
	EnchantedItemSlot.BringToFrontOf("AutoEnchant_wnd");
	EnchantedItemSlot.SetAlpha(255);
	TweenAdd(EnchantedItemSlot, -255, 2, uiTimerObj._time, 0, 0, class'L2UITween'.static.Inst().easeType.IN_STRONG);
	PlaySound("InterfaceSound.ui_synthesis_out");	
}

private function NextProcessInputResultReady()
{
	local int idx;
	local ItemInfo resultJewelItemInfo;

	EnchantedItemSlot.GetItem(0, resultJewelItemInfo);
	EnchantedItemSlot.DeleteItem(0);
	idx = GetClearItemIndex();
	// End:0xE9
	if(idx == -1)
	{
		// End:0x64
		if(IsStackableItem(resultJewelItemInfo.ConsumeType))
		{
			idx = GetSameItemIndex(resultJewelItemInfo);
		}
		// End:0xC3
		if(idx > -1)
		{
			InventoryItem.GetItem(idx, resultJewelItemInfo);
			resultJewelItemInfo.ItemNum = resultJewelItemInfo.ItemNum + 1;
			InventoryItem.SetItem(idx, resultJewelItemInfo);			
		}
		else
		{
			AddAutoJewelItemWindow(resultJewelItemInfo);
			idx = InventoryItem.GetItemNum() - 1;
		}		
	}
	else
	{
		InventoryItem.SetItem(idx, resultJewelItemInfo);
	}
	InventoryItem.SetNewlyAcquired(idx, true);
	InventoryItemAllClearClearItems();	
}

private function NextProcessInputNext()
{
	local int index1, index2;

	Debug(" ** NextProcessInputNext ** ");
	// End:0x46
	if(! GetNextTryIndexAutoMode(index1, index2))
	{
		SetState(STATE_AUTORESULT);
		return;
	}
	Animation2(index2);
	Animation1(index1);
	PlayEffectProgress();	
}

private function NextProcessInputNextReady()
{
	local ItemInfo iInfo, iiInfo;

	class'UIDATA_INVENTORY'.static.FindItem(jewel1ItemInfo.Id.ServerID, iInfo);
	class'UIDATA_INVENTORY'.static.FindItem(jewel2ItemInfo.Id.ServerID, iiInfo);
	InventoryItemAllClearClearItems();
	shadowItem_tex1.HideWindow();
	shadowItem_tex2.HideWindow();
	API_RequestEnchantRetryPutItems(jewel1ItemInfo.Id.ServerID, jewel2ItemInfo.Id.ServerID);	
}

private function Animation1(int Index)
{
	local Rect slotRect, wndRect;
	local int nX, nY;
	local ItemInfo ClearItem;
	local bool isOut;

	wndRect = m_hOwnerWnd.GetRect();
	isOut = GetPosItemWIndowWithIndex(Index, slotRect);
	InventoryItem.GetItem(Index, jewel1ItemInfo);
	nX = slotRect.nX - wndRect.nX;
	nY = slotRect.nY - wndRect.nY;
	// End:0xD5
	if(jewel1ItemInfo.ItemNum > 1)
	{
		jewel1ItemInfo.ItemNum = jewel1ItemInfo.ItemNum - 1;
		InventoryItem.SetItem(Index, jewel1ItemInfo);
		jewel1ItemInfo.ItemNum = 1;		
	}
	else
	{
		GetClearItem(ClearItem);
		InventoryItem.SetItem(Index, ClearItem);
	}
	// End:0x15A
	if(! isOut)
	{
		shadowItem_tex1.MoveC(nX, nY);
		shadowItem_tex1.ShowWindow();
		shadowItem_tex1.SetLoopCount(1);
		shadowItem_tex1.Stop();
		shadowItem_tex1.Play();
	}	
}

private function Animation2(int Index)
{
	local Rect slotRect, wndRect;
	local int nX, nY;
	local ItemInfo ClearItem;
	local bool inOut;

	wndRect = m_hOwnerWnd.GetRect();
	inOut = GetPosItemWIndowWithIndex(Index, slotRect);
	nX = slotRect.nX - wndRect.nX;
	nY = slotRect.nY - wndRect.nY;
	InventoryItem.GetItem(Index, jewel2ItemInfo);
	// End:0xD5
	if(jewel2ItemInfo.ItemNum > 1)
	{
		jewel2ItemInfo.ItemNum = jewel2ItemInfo.ItemNum - 1;
		InventoryItem.SetItem(Index, jewel2ItemInfo);
		jewel2ItemInfo.ItemNum = 1;		
	}
	else
	{
		GetClearItem(ClearItem);
		InventoryItem.SetItem(Index, ClearItem);
	}
	// End:0x14B
	if(! inOut)
	{
		shadowItem_tex2.MoveC(nX, nY);
		shadowItem_tex2.ShowWindow();
		shadowItem_tex2.SetLoopCount(1);
		shadowItem_tex2.Play();
	}	
}

private function HandleOnTweenEnd(int Id)
{
	switch(Id)
	{
		// End:0x4B
		case 0:
			moveItem1.HideWindow();
			dropResult_AniTex1.ShowWindow();
			dropResult_AniTex1.SetLoopCount(1);
			dropResult_AniTex1.Play();
			// End:0x64
			break;
		// End:0x61
		case 1:
			moveItem2.HideWindow();
			// End:0x64
			break;
	}
}

private function bool GetNextTryIndexAutoMode(out int index1, out int index2)
{
	local int i, Len;
	local ItemInfo iInfo;
	local int MaxLevel;
	local CombinationItemUIData o_data;

	API_GetCombinationItemDataCurrent(o_data);
	Len = InventoryItem.GetItemNum();
	MaxLevel = numberInputStepper._getEditNum();
	index1 = -1;
	index2 = -1;
	switch(o_data.AutomaticType)
	{
		// End:0x60
		case 0:
			return false;
		// End:0x149
		case 1:
			// End:0x139 [Loop If]
			for(i = 0; i < 2; i++)
			{
				// End:0x9A
				if(! InventoryItem.GetItem(i, iInfo))
				{
					return false;
				}
				// End:0xE6
				if(jewel1ItemInfo.Id.ClassID == iInfo.Id.ClassID && jewel1ItemInfo.Enchanted == iInfo.Enchanted)
				{
					index1 = i;
					// [Explicit Continue]
					continue;
				}
				// End:0x12F
				if(jewel2ItemInfo.Id.ClassID == iInfo.Id.ClassID && jewel2ItemInfo.Enchanted == iInfo.Enchanted)
				{
					index2 = i;
				}
			}
			return (index1 + index2) > 0;
		// End:0x1B2
		case 3:
			// End:0x180
			if(API_GetCombinationItemDataIndex(1, 0, o_data))
			{
				index1 = 1;
				index2 = 0;
				return o_data.Level < MaxLevel;
			}
			// End:0x1B0
			if(API_GetCombinationItemDataIndex(0, 1, o_data))
			{
				index1 = 0;
				index2 = 1;
				return o_data.Level < MaxLevel;
			}
			return false;
		// End:0x2C6
		case 2:
			// End:0x2C3 [Loop If]
			for(i = 0; i < Len; i++)
			{
				InventoryItem.GetItem(i, iInfo);
				// End:0x252
				if(IsStackableItem(iInfo.ConsumeType))
				{
					// End:0x252
					if(iInfo.ItemNum > 1)
					{
						// End:0x252
						if(API_GetCombinationItemDataIndex(i, i, o_data))
						{
							// End:0x252
							if(o_data.Level < MaxLevel)
							{
								index1 = i;
								index2 = i;
								return true;
							}
						}
					}
				}
				// End:0x267
				if(i == (Len - 1))
				{
					// [Explicit Continue]
					continue;
				}
				// End:0x287
				if(! API_GetCombinationItemDataIndex(i, i + 1, o_data))
				{
					// [Explicit Continue]
					continue;
				}
				// End:0x29E
				if(o_data.Level >= MaxLevel)
				{
					// [Explicit Continue]
					continue;
				}
				index1 = i;
				index2 = i + 1;
				return true;
			}
			// End:0x2C9
			break;
	}
	return false;	
}

private function OnChangedLevel(UIControlNumberInputSteper mySelf)
{
	local int i;
	local ItemInfo iInfo;

	// End:0x6A [Loop If]
	for(i = 0; i < InventoryItem.GetItemNum(); i++)
	{
		InventoryItem.GetItem(i, iInfo);
		// End:0x60
		if(CheckNDisabledItem(iInfo))
		{
			InventoryItem.SetItem(i, iInfo);
		}
	}	
}

function bool CheckNDisabledItem(out ItemInfo iInfo)
{
	local int j, GroupID;
	local CombinationItemUIData o_data;
	local array<int> CandidateMaterials;

	// End:0x22
	if(API_GetEnchantCandidateMaterialList(iInfo.Id.ClassID, CandidateMaterials) == 0)
	{
		return false;
	}
	API_GetCombinationItemDataCurrent(o_data);
	// End:0x63
	if(o_data.AutomaticType == 1 || o_data.AutomaticType == 0)
	{
		iInfo.bDisabled = 0;
		return true;
	}
	GroupID = o_data.GroupID;

	// End:0x116 [Loop If]
	for(j = 0; j < CandidateMaterials.Length; j++)
	{
		API_GetCombinationItemData(iInfo.Id.ClassID, iInfo.Enchanted, CandidateMaterials[j], 0, o_data);
		// End:0xD1
		if(GroupID != o_data.GroupID)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0xFE
		if(o_data.Level >= numberInputStepper._getEditNum())
		{
			iInfo.bDisabled = 1;			
		}
		else
		{
			iInfo.bDisabled = 0;
		}
		return true;
	}
	return false;	
}

function _SortItemInventory()
{
	local int i, InvenLimit;
	local ItemInfo item;
	local array<ItemInfo> ItemListAll;

	InvenLimit = InventoryItem.GetItemNum();

	// End:0x78 [Loop If]
	for(i = 0; i < InvenLimit; i++)
	{
		InventoryItem.GetItem(i, item);
		// End:0x5C
		if(! IsValidItemID(item.Id))
		{
			// [Explicit Continue]
			continue;
		}
		ItemListAll[ItemListAll.Length] = item;
	}
	// End:0x8F
	if(ItemListAll.Length > 0)
	{
		ItemListAll.Sort(SortByLevelDelegate);
	}
	ClearAutoJewelItemWindow();

	// End:0xC7 [Loop If]
	for(i = 0; i < ItemListAll.Length; i++)
	{
		AddAutoJewelItemWindow(ItemListAll[i]);
	}	
}

private function RemoveInventoryItem(int Index)
{
	// End:0x0F
	if(GetStateName() != STATE_ALLREADY)
	{
		return;
	}
	InventoryItem.DeleteItem(Index);
	// End:0x7F
	if(InventoryItem.GetItemNum() == 0)
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.InventoryDisable_Wnd").ShowWindow();
	}
	RefreshSubWnd();	
}

function AddInventoryItem(ItemInfo iInfo)
{
	local INT64 ItemNum;

	ItemNum = ItemJewelEnchantSubWndScript._GetIneventoryItemNum(iInfo);
	// End:0x58
	if(class'InputAPI'.static.IsAltPressed() || ItemNum == 1)
	{
		ItemJewelEnchantSubWndScript._MoveToOwner(iInfo, ItemNum);		
	}
	else
	{
		ShowDialog(iInfo);
	}	
}

function _AddInventoryItem(ItemInfo iInfo)
{
	local int idx;
	local ItemInfo iiInfo;

	// End:0xA6
	if(IsStackableItem(iInfo.ConsumeType))
	{
		idx = InventoryItem.FindItem(iInfo.Id);
		// End:0x4F
		if(idx == -1)
		{
			AddAutoJewelItemWindow(iInfo);			
		}
		else
		{
			InventoryItem.GetItem(idx, iiInfo);
			iiInfo.ItemNum = iiInfo.ItemNum + iInfo.ItemNum;
			InventoryItem.SetItem(idx, iiInfo);
		}		
	}
	else
	{
		AddAutoJewelItemWindow(iInfo);
	}	
}

delegate int SortByLevelDelegate(ItemInfo aItemInfo, ItemInfo bItemInfo)
{
	local int j;
	local CombinationItemUIData o_data, o_Datb;
	local array<int> CandidateMaterialsA, CandidateMaterialsB;

	// End:0x26
	if(API_GetEnchantCandidateMaterialList(aItemInfo.Id.ClassID, CandidateMaterialsA) == 0)
	{
		return -1;
	}
	// End:0x48
	if(API_GetEnchantCandidateMaterialList(bItemInfo.Id.ClassID, CandidateMaterialsB) == 0)
	{
		return 0;
	}

	// End:0xAA [Loop If]
	for(j = 0; j < CandidateMaterialsA.Length; j++)
	{
		// End:0x9D
		if(! API_GetCombinationItemData(aItemInfo.Id.ClassID, aItemInfo.Enchanted, CandidateMaterialsA[j], 0, o_data))
		{
			return -1;
		}
		break;
	}

	// End:0x108 [Loop If]
	for(j = 0; j < CandidateMaterialsB.Length; j++)
	{
		// End:0xFB
		if(! API_GetCombinationItemData(bItemInfo.Id.ClassID, bItemInfo.Enchanted, CandidateMaterialsB[j], 0, o_Datb))
		{
			return 0;
		}
		break;
	}
	// End:0x127
	if(o_Datb.Level < o_data.Level)
	{
		return -1;
	}
	return 0;	
}

private function ShowDialog_Wnd()
{
	local int i, j, Len;
	local ItemInfo iInfoA;
	local RichListCtrlRowData RowData;
	local array<ItemInfo> iInfos;
	local bool IsNew;

	numberInputStepper.checkMinMax();
	EnchantItemList_RichList.DeleteAllItem();
	iInfos[0] = jewel1ItemInfo;
	// End:0x89
	if(jewel1ItemInfo.Id.ClassID == jewel2ItemInfo.Id.ClassID && jewel1ItemInfo.Enchanted == jewel2ItemInfo.Enchanted)
	{
		iInfos[0].ItemNum = jewel2ItemInfo.ItemNum + 1;		
	}
	else
	{
		iInfos[1] = jewel2ItemInfo;
	}
	Len = InventoryItem.GetItemNum();

	// End:0x1AD [Loop If]
	for(i = 0; i < Len; i++)
	{
		InventoryItem.GetItem(i, iInfoA);
		IsNew = false;

		// End:0x186 [Loop If]
		for(j = 0; j < iInfos.Length; j++)
		{
			// End:0x17C
			if(iInfoA.Id.ClassID == iInfos[j].Id.ClassID && iInfoA.Enchanted == iInfos[j].Enchanted)
			{
				iInfos[j].ItemNum = iInfos[j].ItemNum + iInfoA.ItemNum;
				IsNew = true;
				// [Explicit Break]
				break;
			}
		}
		// End:0x1A3
		if(! IsNew)
		{
			iInfos[iInfos.Length] = iInfoA;
		}
	}

	// End:0x1FB [Loop If]
	for(i = 0; i < iInfos.Length; i++)
	{
		// End:0x1F1
		if(MakeRowData(iInfos[i], RowData))
		{
			EnchantItemList_RichList.InsertRecord(RowData);
		}
	}
	Dialog_Wnd.ShowWindow();
	Dialog_Wnd.SetFocus();	
}

private function HideDialog_Wnd()
{
	Dialog_Wnd.HideWindow();	
}

private function bool MakeRowData(ItemInfo iInfo, out RichListCtrlRowData RowData)
{
	local RichListCtrlRowData newRowData;

	newRowData.cellDataList.Length = 1;
	iInfo.bShowCount = false;
	addRichListCtrlTexture(newRowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 24, 24, 0, 3);
	AddRichListCtrlItem(newRowData.cellDataList[0].drawitems, iInfo, 20, 20, -22, 1);
	addRichListCtrlString(newRowData.cellDataList[0].drawitems, GetItemNameAll(iInfo, true), getInstanceL2Util().BrightWhite, false, 5, 3);
	addRichListCtrlString(newRowData.cellDataList[0].drawitems, iInfo.AdditionalName, getInstanceL2Util().Yellow03, false, 5, 0);
	addRichListCtrlString(newRowData.cellDataList[0].drawitems, "x" $ MakeCostStringINT64(iInfo.ItemNum), getInstanceL2Util().White, false, 5, 0);
	RowData = newRowData;
	return true;	
}

private function API_RequestClose()
{
	class'NewEnchantAPI'.static.RequestClose();	
}

private function API_RequestRemoveOne(ItemID iID)
{
	bRequestRemoveOne = true;
	class'NewEnchantAPI'.static.RequestRemoveOne(iID);	
}

private function API_RequestRemoveTwo(ItemID iID)
{
	bRequestRemoveTwo = true;
	class'NewEnchantAPI'.static.RequestRemoveTwo(iID);	
}

private function API_GetMaterialItemForEnchantFromInven(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out INT64 Commission, out array<ItemInfo> MaterialItems)
{
	local int i;

	MaterialItems.Length = 0;
	// End:0x4C
	if(getInstanceUIData().getIsClassicServer())
	{
		class'NewEnchantAPI'.static.GetMaterialItemForEnchantFromInven(OneSlotItemClassID, OneSlotItemEnchant, TwoSlotItemClassID, TwoSlotItemEnchant, Commission, MaterialItems, 1);		
	}
	else
	{
		class'NewEnchantAPI'.static.GetMaterialItemForEnchantFromInven(OneSlotItemClassID, OneSlotItemEnchant, TwoSlotItemClassID, TwoSlotItemEnchant, Commission, MaterialItems);
	}

	// End:0xC2 [Loop If]
	for(i = 0; i < MaterialItems.Length; i++)
	{
		MaterialItems[i].bShowCount = IsStackableItem(MaterialItems[i].ConsumeType);
	}	
}

private function API_RequestPushOne(ItemInfo iInfo, optional bool bNoRequestServer)
{
	// End:0x2C
	if(! bNoRequestServer)
	{
		class'NewEnchantAPI'.static.RequestPushOne(iInfo.Id);
		bRequestPushOne = true;
	}
	jewel1ItemInfo = iInfo;
	jewel1ItemInfo.ItemNum = 1;
	Debug("API_RequestPushOne" @ jewel1ItemInfo.Name @ string(jewel1ItemInfo.Id.ServerID));	
}

private function API_RequestPushTwo(ItemInfo iInfo, optional bool bNoRequestServer)
{
	// End:0x2C
	if(! bNoRequestServer)
	{
		class'NewEnchantAPI'.static.RequestPushTwo(iInfo.Id);
		bRequestPushTwo = true;
	}
	jewel2ItemInfo = iInfo;
	jewel2ItemInfo.ItemNum = 1;
	Debug("API_RequestPushTwo" @ jewel2ItemInfo.Name @ string(jewel2ItemInfo.Id.ServerID));	
}

private function API_RequestEnchantRetryPutItems(int serverID1, int serverID2)
{
	// End:0x21
	if(serverID1 < 1 || serverID2 < 1)
	{
		HandleNewEnchantRetryPutItems(false);
		return;
	}
	bRequestedPushRetry = true;
	Debug(" ---  API_RequestEnchantRetryPutItems " @ string(serverID1) @ string(serverID2));
	class'NewEnchantAPI'.static.RequestEnchantRetryPutItems(serverID1, serverID2);	
}

private function API_RequestTryEnchant()
{
	// End:0x0B
	if(bRequestTryEnchant)
	{
		return;
	}
	bRequestTryEnchant = true;
	Debug("RequestEnchantItem" @ jewel1ItemInfo.Name @ string(jewel1ItemInfo.Id.ClassID) @ string(jewel1ItemInfo.Id.ServerID) @ jewel2ItemInfo.Name @ string(jewel2ItemInfo.Id.ClassID) @ string(jewel2ItemInfo.Id.ServerID));
	class'NewEnchantAPI'.static.RequestTryEnchant();	
}

private function int API_GetEnchantCandidateMaterialList(int ClassID, out array<int> CandidateMaterials)
{
	class'NewEnchantAPI'.static.GetEnchantCandidateMaterialList(ClassID, CandidateMaterials);
	return CandidateMaterials.Length;	
}

private function bool API_IsNoFailResultEffectType()
{
	return class'NewEnchantAPI'.static.IsNoFailResultEffectType(_GetClassIDBySlotItemIndex(1), _GetEnchantedBySlotItemIndex(1), _GetClassIDBySlotItemIndex(2), _GetEnchantedBySlotItemIndex(2));	
}

private function bool API_GetCombinationItemDataIndex(int index1, int index2, out CombinationItemUIData o_data)
{
	local ItemInfo iInfo, iiInfo;

	// End:0x20
	if(! InventoryItem.GetItem(index1, iInfo))
	{
		return false;
	}
	// End:0x40
	if(! InventoryItem.GetItem(index2, iiInfo))
	{
		return false;
	}
	return API_GetCombinationItemData(iInfo.Id.ClassID, iInfo.Enchanted, iiInfo.Id.ClassID, iiInfo.Enchanted, o_data);	
}

private function bool API_GetCombinationItemData(int classID1, int enchanted1, int classID2, int enchanted2, out CombinationItemUIData o_data)
{
	return class'NewEnchantAPI'.static.GetCombinationItemData(classID1, enchanted1, classID2, enchanted2, o_data);	
}

private function bool API_GetCombinationItemDataCurrent(out CombinationItemUIData o_data)
{
	Debug("현재 컴비 데이타 받기" @ string(_GetClassIDBySlotItemIndex(1)) @ string(_GetEnchantedBySlotItemIndex(1)) @ string(_GetClassIDBySlotItemIndex(2)) @ string(_GetEnchantedBySlotItemIndex(2)));
	return API_GetCombinationItemData(_GetClassIDBySlotItemIndex(1), _GetEnchantedBySlotItemIndex(1), _GetClassIDBySlotItemIndex(2), _GetEnchantedBySlotItemIndex(2), o_data);	
}

private function StopEffect()
{
	mainEffectViewport.SpawnEffect("");	
}

private function PlayEffectProgress()
{
	switch(GetProgressTIme())
	{
		// End:0x10
		case TIMER_DELAY_AUTOEffect2:
		// End:0x4C
		case TIMER_DELAY:
			PlaySound("InterfaceSound.ui_synthesis_progress_long");
			// End:0x8E
			break;
		// End:0x51
		case TIMER_DELAY_AUTO:
		// End:0x8B
		case TIMER_DELAY_SKIP:
			PlaySound("InterfaceSound.ui_synthesis_progress_short");
			// End:0x8E
			break;
	}
	mainEffectViewport.SpawnEffect("LineageEffect2.ui_compose_progress");
	mainEffectViewport.SetCameraDistance(104.0f);	
}

private function PlayEffectSuccess()
{
	PlaySound("InterfaceSound.ui_synthesis_success");
	mainEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_success");
	mainEffectViewport.SetCameraDistance(104.0f);	
}

private function PlayEffectFail()
{
	PlaySound("InterfaceSound.ui_synthesis_fail");
	mainEffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_fail");
	mainEffectViewport.SetCameraDistance(248.0f);	
}

private function PlayEffectStandBy()
{
	mainEffectViewport.SpawnEffect("LineageEffect2.ui_compose_standby");
	mainEffectViewport.SetCameraDistance(104.0f);	
}

private function SetState(name Type)
{
	local ItemInfo iInfo;

	PrevState = GetStateName();
	switch(Type)
	{
		// End:0x1B
		case STATE_READY:
			// End:0x70
			break;
		// End:0x41
		case STATE_ONEREADY:
			// End:0x3E
			if(! _GetSlot1ItemInfo(iInfo))
			{
				Type = STATE_READY;
			}
			// End:0x70
			break;
		// End:0x4C
		case STATE_ALLREADY:
			// End:0x70
			break;
		// End:0x57
		case STATE_PROCESS:
			// End:0x70
			break;
		// End:0x62
		case STATE_RESULT:
			// End:0x70
			break;
		// End:0x6D
		case STATE_AUTORESULT:
			// End:0x70
			break;
	}
	HandleStateBtnsEnd();
	GotoState(Type);
	HandleStateBtns();	
}

private function HandleStateBtns()
{
	switch(GetStateName())
	{
		// End:0x84
		case STATE_READY:
			EnchantBtn.ShowWindow();
			EnchantBtn.DisableWindow();
			continueBtn.HideWindow();
			nextbtn.HideWindow();
			InitBtn.DisableWindow();
			CancelBtn.SetNameText(GetSystemString(646));
			CancelBtn.EnableWindow();
			// End:0x2F7
			break;
		// End:0xF4
		case STATE_ONEREADY:
			EnchantBtn.DisableWindow();
			continueBtn.HideWindow();
			nextbtn.HideWindow();
			InitBtn.EnableWindow();
			CancelBtn.SetNameText(GetSystemString(646));
			CancelBtn.EnableWindow();
			// End:0x2F7
			break;
		// End:0x197
		case STATE_ALLREADY:
			EnchantBtn.ShowWindow();
			// End:0x12F
			if(UIControlNeedItemListObj.GetCanBuy())
			{
				EnchantBtn.EnableWindow();				
			}
			else
			{
				EnchantBtn.DisableWindow();
			}
			continueBtn.HideWindow();
			nextbtn.HideWindow();
			InitBtn.EnableWindow();
			CancelBtn.SetNameText(GetSystemString(646));
			CancelBtn.EnableWindow();
			// End:0x2F7
			break;
		// End:0x236
		case STATE_PROCESS:
			// End:0x1EF
			if(! _IsAutoMode())
			{
				EnchantBtn.HideWindow();
				CheckNShowHideContinueBtn();
				continueBtn.DisableWindow();
				nextbtn.ShowWindow();
				nextbtn.DisableWindow();				
			}
			else
			{
				EnchantBtn.DisableWindow();
			}
			CancelBtn.SetNameText(GetSystemString(141));
			CancelBtn.EnableWindow();
			InitBtn.DisableWindow();
			// End:0x2F7
			break;
		// End:0x284
		case STATE_RESULT:
			// End:0x281
			if(! _IsAutoMode())
			{
				CancelBtn.SetNameText(GetSystemString(646));
				CancelBtn.EnableWindow();
				InitBtn.EnableWindow();
			}
			// End:0x2F7
			break;
		// End:0x2F4
		case STATE_AUTORESULT:
			EnchantBtn.DisableWindow();
			InitBtn.EnableWindow();
			continueBtn.HideWindow();
			nextbtn.HideWindow();
			CancelBtn.SetNameText(GetSystemString(646));
			CancelBtn.EnableWindow();
			// End:0x2F7
			break;
	}	
}

private function CheckNShowHideContinueBtn()
{
	local CombinationItemUIData o_data;

	// End:0x0B
	if(_IsAutoMode())
	{
		return;
	}
	API_GetCombinationItemDataCurrent(o_data);
	// End:0x79
	if(o_data.AutomaticType != 3)
	{
		nextbtn.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "BottomCenter", "BottomLeft", 2, -3);
		continueBtn.ShowWindow();		
	}
	else
	{
		nextbtn.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "BottomCenter", "BottomCenter", 0, -3);
	}	
}

private function HandleStateBtnsEnd()
{
	switch(GetStateName())
	{
		// End:0x10
		case STATE_READY:
			// End:0x73
			break;
		// End:0x1B
		case STATE_ONEREADY:
			// End:0x73
			break;
		// End:0x26
		case STATE_ALLREADY:
			// End:0x73
			break;
		// End:0x31
		case STATE_PROCESS:
			// End:0x73
			break;
		// End:0x56
		case STATE_RESULT:
			// End:0x53
			if(! _IsAutoMode())
			{
				EnchantBtn.ShowWindow();
			}
			// End:0x73
			break;
		// End:0x70
		case STATE_AUTORESULT:
			EnchantBtn.ShowWindow();
			// End:0x73
			break;
	}	
}

private function SetResultEffectType()
{
	// End:0x42
	if(GetResultEffectType() > 0)
	{
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg3");		
	}
	else
	{
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");
	}	
}

private function int GetResultEffectType()
{
	local CombinationItemUIData o_data;

	API_GetCombinationItemDataCurrent(o_data);
	return o_data.ResultEffectType2;	
}

private function CheckBtnsOnResult()
{
	local ItemInfo resultJewelItemInfo;
	local CombinationItemUIData o_data;

	// End:0x0B
	if(_IsAutoMode())
	{
		return;
	}
	EnchantedItemSlot.GetItem(0, resultJewelItemInfo);
	API_GetCombinationItemDataCurrent(o_data);
	// End:0x78
	if(o_data.AutomaticType != 3)
	{
		// End:0x78
		if(ItemJewelEnchantSubWndScript._CheckCanEnchatItem(jewel1ItemInfo.Id.ClassID, jewel1ItemInfo.Enchanted))
		{
			continueBtn.EnableWindow();
		}
	}
	switch(o_data.AutomaticType)
	{
		// End:0x8B
		case 1:
		// End:0x94
		case 0:
			return;
		// End:0x124
		case 2:
			// End:0x121
			if(GetResult(resultJewelItemInfo))
			{
				// End:0x121
				if(jewel1ItemInfo.Id.ClassID != resultJewelItemInfo.Id.ClassID || jewel1ItemInfo.Enchanted != resultJewelItemInfo.Enchanted)
				{
					// End:0x121
					if(ItemJewelEnchantSubWndScript._CheckCanEnchatItem(resultJewelItemInfo.Id.ClassID, resultJewelItemInfo.Enchanted))
					{
						nextbtn.EnableWindow();
					}
				}
			}
			// End:0x16B
			break;
		// End:0x168
		case 3:
			// End:0x165
			if(ItemJewelEnchantSubWndScript._CheckCanEnchatItem(resultJewelItemInfo.Id.ClassID, resultJewelItemInfo.Enchanted))
			{
				nextbtn.EnableWindow();
			}
			// End:0x16B
			break;
	}	
}

function OnItemUpdateItem()
{
	// End:0x40
	if(GetStateName() == STATE_ALLREADY)
	{
		// End:0x31
		if(UIControlNeedItemListObj.GetCanBuy())
		{
			EnchantBtn.EnableWindow();			
		}
		else
		{
			EnchantBtn.DisableWindow();
		}
	}	
}

private function StateTxtWarningTxt()
{
	switch(GetStateName())
	{
		// End:0x0D
		case STATE_ALLREADY:
		// End:0x58
		case STATE_PROCESS:
			// End:0x3B
			if(API_IsNoFailResultEffectType())
			{
				WarningTxt.SetText(GetSystemMessage(4424));				
			}
			else
			{
				WarningTxt.SetText(GetSystemMessage(4234));
			}
			// End:0x6C
			break;
		// End:0xFFFF
		default:
			WarningTxt.SetText("");
			break;
	}	
}

private function StateTxtInstructionTxt()
{
	InstructionTxt.SetTextColor(GetColor(187, 187, 187, 255));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.InventoryDisable_Wnd.descrip_text").SetTextColor(GetColor(187, 187, 187, 255));
	switch(GetStateName())
	{
		// End:0xC6
		case STATE_READY:
			InstructionTxt.SetText(GetSystemMessage(4232));
			InstructionTxt.SetTextColor(GetColor(255, 255, 187, 255));
			// End:0x1E6
			break;
		// End:0xEB
		case STATE_ONEREADY:
			InstructionTxt.SetText(GetSystemString(3501));
			// End:0x1E6
			break;
		// End:0x172
		case STATE_ALLREADY:
			InstructionTxt.SetText(GetSystemMessage(4233));
			GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.InventoryDisable_Wnd.descrip_text").SetTextColor(GetColor(255, 255, 187, 255));
			// End:0x1E6
			break;
		// End:0x18E
		case STATE_PROCESS:
			InstructionTxt.SetText("");
			// End:0x1E6
			break;
		// End:0x1BE
		case STATE_RESULT:
			// End:0x1BB
			if(! _IsAutoMode())
			{
				InstructionTxt.SetText(GetSystemString(14118));
			}
			// End:0x1E6
			break;
		// End:0x1E3
		case STATE_AUTORESULT:
			InstructionTxt.SetText(GetSystemString(14118));
			// End:0x1E6
			break;
	}	
}

private function SetateTxtProbTxt()
{
	local float Prob;

	if(GetProb(Prob))
	{
		ProbTxt.SetText((GetSystemString(642) @ ":") @ class'L2Util'.static.Inst().CutFloatIntByString(class'L2Util'.static.Inst().CutFloatDecimalPlaces(Prob, 4, true)));
	}
	else
	{
		ProbTxt.SetText("");
	}	
}

private function ClearAutoJewelItemWindow()
{
	InventoryItem.Clear();
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.InventoryDisable_Wnd").ShowWindow();	
}

private function AddAutoJewelItemWindow(ItemInfo iInfo)
{
	CheckNDisabledItem(iInfo);
	InventoryItem.AddItem(iInfo);
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.InventoryDisable_Wnd").HideWindow();	
}

private function array<ItemInfo> GetDyeCombines(array<ItemInfo> iInfos)
{
	local int i;
	local DyeCombinationUIData o_data;
	local array<ItemInfo> dyeCombines;

	// End:0x65 [Loop If]
	for(i = 0; i < iInfos.Length; i++)
	{
		// End:0x5B
		if(class'UIDATA_HENNA'.static.GetDyeCombinationData(iInfos[i].Id.ClassID, o_data))
		{
			dyeCombines[dyeCombines.Length] = iInfos[i];
		}
	}
	return dyeCombines;	
}

private function CheckNRemoveSameClassid(int ClassID, int Enchanted, out array<ItemInfo> MaterialItems)
{
	local int i;

	// End:0xAA [Loop If]
	for(i = 0; i < MaterialItems.Length; i++)
	{
		// End:0xA0
		if(MaterialItems[i].Id.ClassID == ClassID && MaterialItems[i].Enchanted == Enchanted)
		{
			MaterialItems[i].ItemNum = MaterialItems[i].ItemNum - 1;
			// End:0x9E
			if(MaterialItems[i].ItemNum == 0)
			{
				MaterialItems.Remove(i, 1);
			}
			return;
		}
	}	
}

private function GetClearItem(out ItemInfo iInfo)
{
	local ItemInfo ClearItemInfo;

	ClearItemID(ClearItemInfo.Id);
	ClearItemInfo.IconName = "L2ui_ct1.emptyBtn";
	iInfo = ClearItemInfo;	
}

private function InsertInventoryItemItemInfo(int Index, ItemInfo iInfo)
{
	local int i, Len;

	Len = InventoryItem.GetItemNum();
	AddAutoJewelItemWindow(iInfo);
	// End:0x31
	if(Index == -1)
	{
		return;
	}

	// End:0x71 [Loop If]
	for(i = Len; i > Index; i--)
	{
		InventoryItem.SwapItems(i, i - 1);
	}	
}

private function int FindLastInventoryItemIndexItemInfo(ItemInfo resultiInfo)
{
	local int i, Len, Level;
	local ItemInfo iiInfo;
	local CombinationItemUIData o_data;

	API_GetCombinationItemDataCurrent(o_data);
	Len = InventoryItem.GetItemNum();
	switch(o_data.AutomaticType)
	{
		// End:0xDF
		case 1:
			// End:0xD9
			if(IsStackableItem(resultiInfo.ConsumeType))
			{
				// End:0xD9 [Loop If]
				for(i = 0; InventoryItem.GetItem(i, iiInfo); i++)
				{
					// End:0xCF
					if((resultiInfo.Id.ClassID == iiInfo.Id.ClassID) && resultiInfo.Enchanted == iiInfo.Enchanted)
					{
						resultiInfo.ItemNum = iiInfo.ItemNum + resultiInfo.ItemNum;
						return i;
					}
				}
			}
			return Len;
		// End:0xE6
		case 0:
		// End:0xF3
		case 3:
			return Len;
		// End:0xFD
		case 2:
			// End:0x100
			break;
	}
	API_GetCombinationItemData(resultiInfo.Id.ClassID, resultiInfo.Enchanted, resultiInfo.Id.ClassID, resultiInfo.Enchanted, o_data);
	Level = o_data.Level;

	// End:0x237 [Loop If]
	for(i = Len - 1; InventoryItem.GetItem(i, iiInfo); i--)
	{
		// End:0x22D
		if(API_GetCombinationItemData(iiInfo.Id.ClassID, iiInfo.Enchanted, iiInfo.Id.ClassID, iiInfo.Enchanted, o_data))
		{
			// End:0x22D
			if(Level >= o_data.Level)
			{
				// End:0x224
				if(IsStackableItem(resultiInfo.ConsumeType) && resultiInfo.Id.ClassID == iiInfo.Id.ClassID && resultiInfo.Enchanted == iiInfo.Enchanted)
				{
					return i;
				}
				return i + 1;
			}
		}
	}
	return 0;	
}

function INT64 _GetIneventoryItemNum(ItemInfo iInfo)
{
	local int i, idx;
	local INT64 ItemNum;
	local ItemInfo iiInfo;

	// End:0x6C
	if(IsStackableItem(iInfo.ConsumeType))
	{
		idx = InventoryItem.FindItem(iInfo.Id);
		// End:0x45
		if(idx == -1)
		{
			return 0;
		}
		InventoryItem.GetItem(idx, iiInfo);
		return iiInfo.ItemNum;		
	}
	else
	{
		// End:0x10B [Loop If]
		for(i = 0; i < InventoryItem.GetItemNum(); i++)
		{
			// End:0xB4 [Loop If]
			while(! InventoryItem.GetItem(idx, iiInfo))
			{
				idx++;
			}
			// End:0x101
			if(iInfo.Id.ClassID == iiInfo.Id.ClassID)
			{
				// End:0x101
				if(iInfo.Enchanted == iiInfo.Enchanted)
				{
					ItemNum = ItemNum + 1;
				}
			}
		}
	}
	return ItemNum;	
}

function bool _GetSlot1ItemInfo(out ItemInfo iInfo)
{
	return EnchantJewel1.GetItem(0, iInfo);	
}

function bool _GetSlot2ItemInfo(out ItemInfo iInfo)
{
	return EnchantJewel2.GetItem(0, iInfo);	
}

private function bool GetPosItemWIndowWithIndex(int Index, out Rect invenRect)
{
	local bool isOut;
	local int colIndex, rowIndex, scrollPosition;

	invenRect = InventoryItem.GetRect();
	scrollPosition = InventoryItem.GetScrollPosition();
	colIndex = int(float(Index) % float(12));
	rowIndex = Min(3, Max(-1, (Index / 12) - scrollPosition));
	invenRect.nX = (invenRect.nX + (colIndex * 36)) + 1;
	invenRect.nY = (invenRect.nY + (rowIndex * 36)) + 1;
	switch(rowIndex)
	{
		// End:0xD9
		case -1:
			invenRect.nY = invenRect.nY + 15;
			isOut = true;
			// End:0x105
			break;
		// End:0x102
		case 3:
			invenRect.nY = invenRect.nY - 15;
			isOut = true;
			// End:0x105
			break;
	}
	return isOut;	
}

private function TweenAdd(WindowHandle targetWnd, int TargetAlpha, int Id, int Duration, int nX, int nY, L2UITween.easeType Type, optional float Delay)
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tweenObjectData.Id = Id;
	tweenObjectData.Target = targetWnd;
	tweenObjectData.Duration = float(Duration);
	tweenObjectData.Alpha = float(TargetAlpha);
	tweenObjectData.ease = Type;
	tweenObjectData.MoveX = float(nX);
	tweenObjectData.MoveY = float(nY);
	tweenObjectData.Delay = Delay;
	TweenStop(Id);
	class'L2UITween'.static.Inst().AddTweenObject(tweenObjectData);	
}

private function TweenStop(int Id)
{
	class'L2UITween'.static.Inst().StopTween(m_hOwnerWnd.m_WindowNameWithFullPath, Id);	
}

private function SetUIControlNumberInputSteper()
{
	local CombinationItemUIData o_data;

	API_GetCombinationItemDataCurrent(o_data);
	// End:0x46
	if((o_data.AutomaticType == 1) || o_data.AutomaticType == 0)
	{
		numberInputStepper._SetDisable(true);		
	}
	else
	{
		// End:0xDE
		if(o_data.MaxLevel == 0)
		{
			GetTextBoxHandle(numberInputStepper.m_hOwnerWnd.m_WindowNameWithFullPath $ ".PlusText_txt").HideWindow();
			GetEditBoxHandle(numberInputStepper.m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemCount_EditBox").HideWindow();
			numberInputStepper._SetDisable(true);			
		}
		else
		{
			GetTextBoxHandle(numberInputStepper.m_hOwnerWnd.m_WindowNameWithFullPath $ ".PlusText_txt").ShowWindow();
			GetEditBoxHandle(numberInputStepper.m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemCount_EditBox").ShowWindow();
			numberInputStepper._SetDisable(false);
		}
		numberInputStepper._setRangeMinMaxNum(o_data.Level + 1, o_data.MaxLevel + 1);
		switch(PrevState)
		{
			// End:0x19B
			case STATE_PROCESS:
			// End:0x1A6
			case STATE_RESULT:
				// End:0x1C8
				break;
			// End:0xFFFF
			default:
				numberInputStepper._setEditNum(o_data.MaxLevel + 1);
				// End:0x1C8
				break;
		}
	}	
}

private function bool GetProb(out float Prob)
{
	local CombinationItemUIData o_data;

	API_GetCombinationItemDataCurrent(o_data);
	Prob = float(o_data.ResultItems[0].Prob) / 10000;
	// End:0xD2
	if(o_data.IsNoFail > 0)
	{
		return false;
	}
	// End:0xE1
	if(Prob > 0)
	{
		return true;
	}
	return false;
}

function int _GetClassIDBySlotItemIndex(int SlotIndex)
{
	local ItemInfo Info;

	switch(SlotIndex)
	{
		// End:0x24
		case 1:
			// End:0x21
			if(! _GetSlot1ItemInfo(Info))
			{
				return -1;
			}
			// End:0x45
			break;
		// End:0x42
		case 2:
			// End:0x3F
			if(! _GetSlot2ItemInfo(Info))
			{
				return -1;
			}
			// End:0x45
			break;
	}
	return Info.Id.ClassID;	
}

function int _GetServerIDBySlotItemIndex(int SlotIndex)
{
	local ItemInfo Info;

	switch(SlotIndex)
	{
		// End:0x24
		case 1:
			// End:0x21
			if(! _GetSlot1ItemInfo(Info))
			{
				return -1;
			}
			// End:0x45
			break;
		// End:0x42
		case 2:
			// End:0x3F
			if(! _GetSlot2ItemInfo(Info))
			{
				return -1;
			}
			// End:0x45
			break;
	}
	return Info.Id.ServerID;	
}

function int _GetEnchantedBySlotItemIndex(int SlotIndex)
{
	local ItemInfo Info;

	// End:0x19
	if(SlotIndex == 1)
	{
		_GetSlot1ItemInfo(Info);		
	}
	else
	{
		_GetSlot2ItemInfo(Info);
	}
	return Info.Enchanted;	
}

//Ед±Ы №ю
function ToggleShowWindow(optional EnchantType Type)
{
	// End:0x24
	if(m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.HideWindow();
	}
	else if(! ItemEnchantWnd(GetScript("ItemEnchantWnd")).bIsShopping)
	{
		currentEnchantType = Type;
		m_hOwnerWnd.ShowWindow();
	}
}

function _HandleDropedItem(ItemInfo a_itemInfo)
{
	local ItemInfo tmpJewelItemInfo1, tmpJewelItemInfo2;

	_GetSlot1ItemInfo(tmpJewelItemInfo1);
	_GetSlot2ItemInfo(tmpJewelItemInfo2);
	currentEnchantType = EnchantType.Normal;
	if((_IsWorkingEnchant()) && m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	// End:0x73
	if(IsSameItemID(tmpJewelItemInfo1.Id, a_itemInfo.Id) || IsSameItemID(tmpJewelItemInfo2.Id, a_itemInfo.Id))
	{
		return;
	}
	// End:0x96
	if(tmpJewelItemInfo1.Id.ServerID == 0)
	{
		API_RequestPushOne(a_itemInfo);		
	}
	else
	{
		API_RequestPushTwo(a_itemInfo);
	}
}

/**
 * А©µµїм ESC Е°·О ґЭ±в Гіё® 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	// End:0x1A
	if(Dialog_Wnd.IsShowWindow())
	{
		HideDialog_Wnd();
		return;
	}
	// End:0x3C
	if(bPausedAuto)
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		m_hOwnerWnd.HideWindow();
		return;
	}
	switch(GetStateName())
	{
		// End:0x75
		case STATE_RESULT:
			// End:0x5B
			if(_IsAutoMode())
			{
				StateFuncOnCclickEnchantBtn();
			}
			else
			{
				PlayConsoleSound(IFST_WINDOW_CLOSE);
				m_hOwnerWnd.HideWindow();
			}
			// End:0xA8
			break;
		// End:0x8B
		case STATE_PROCESS:
			SetState(STATE_ALLREADY);
			// End:0xA8
			break;
		// End:0xFFFF
		default:
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			m_hOwnerWnd.HideWindow();
			// End:0xA8
			break;
	}
}

auto state stateBegin
{
	function EndState()
	{
		EnchantJewel1DeleteItem();
		EnchantJewel2DeleteItem();
		EnchantedItemSlotDelete();
		ProbTxt.SetText("");
		numberInputStepper._setRangeMinMaxNum(1, 1);
		numberInputStepper._setEditNum(1);
		numberInputStepper._SetDisable(true);
		m_hItemEnchantWndEnchantProgress.SetPos(0);
		m_hItemEnchantWndEnchantProgress.Reset();
		DropHighlight_EnchantJewel1.SetTexture("L2UI_NewTex.ItemEnchantWnd.EnchantSlotEffect2_64");
		DropHighlight_EnchantJewel2.SetTexture("L2UI_NewTex.ItemEnchantWnd.EnchantSlotEffect2_64");
		EnchantedItemSlot.HideWindow();
		EnchantedJewelBackTex.HideWindow();		
	}

}

state stateReady
{
	function BeginState()
	{
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");
		GetWindowHandle("ItemJewelEnchantSubWnd").ShowWindow();
		EnchantJewel1DeleteItem();
		EnchantJewel2DeleteItem();
		ClearAutoJewelItemWindow();
		StateTxtWarningTxt();
		StateTxtInstructionTxt();
		ProbTxt.SetText("");
		DropHighlight_EnchantJewel1.SetTexture("L2UI_NewTex.ItemEnchantWnd.EnchantSlotEffect1_64");
		PlayEffectStandBy();
		numberInputStepper._setRangeMinMaxNum(1, 1);		
	}

	function EndState()
	{
		DropHighlight_EnchantJewel1.SetTexture("L2UI_NewTex.ItemEnchantWnd.EnchantSlotEffect2_64");		
	}

	private function StateFuncOnCclickCancelBtn()
	{
		m_hOwnerWnd.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);		
	}

}

state stateOneReady
{
	function BeginState()
	{
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");
		Debug(" ** State One Ready");
		StateTxtWarningTxt();
		StateTxtInstructionTxt();
		DropHighlight_EnchantJewel2.SetTexture("L2UI_NewTex.ItemEnchantWnd.EnchantSlotEffect1_64");
		ProbTxt.SetText("");		
	}

	function EndState()
	{
		DropHighlight_EnchantJewel2.SetTexture("L2UI_NewTex.ItemEnchantWnd.EnchantSlotEffect2_64");		
	}

	private function StateFuncOnCclickCancelBtn()
	{
		m_hOwnerWnd.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);		
	}

}

state stateAllReady
{
	function BeginState()
	{
		Debug(" ** State All Ready");
		GetWindowHandle("ItemJewelEnchantSubWnd").ShowWindow();
		SetUIControlNumberInputSteper();
		bPausedAuto = false;
		StateTxtInstructionTxt();
		StateTxtWarningTxt();
		SetateTxtProbTxt();
		SetResultEffectType();		
	}

	function EndState()
	{
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");
		numberInputStepper._SetDisable(true);		
	}

	private function StateFuncOnCclickEnchantBtn()
	{
		// End:0x0D
		if(! BRequesteEnd())
		{
			return;
		}
		// End:0x1F
		if(_IsAutoMode())
		{
			ShowDialog_Wnd();			
		}
		else
		{
			SetState(STATE_PROCESS);
			PlayEffectProgress();
		}		
	}

	private function StateFuncOnCclickCancelBtn()
	{
		m_hOwnerWnd.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);		
	}

}

state stateProcess
{
	function BeginState()
	{
		DisableTransformAutosNCheckBox();
		Debug(" ** State Process");
		StateTxtWarningTxt();
		StateTxtInstructionTxt();
		m_hItemEnchantWndEnchantProgress.SetProgressTime(GetProgressTIme());
		m_hItemEnchantWndEnchantProgress.Start();
		// End:0x73
		if(_IsAutoMode())
		{
			ItemJewelEnchantSubWndScript.m_hOwnerWnd.HideWindow();			
		}
		SetResultEffectType();		
	}

	function EndState()
	{
		EnableTransformAutosNCheckBox();
		m_hItemEnchantWndEnchantProgress.Stop();
		m_hItemEnchantWndEnchantProgress.SetPos(0);
		m_hItemEnchantWndEnchantProgress.Reset();
		uiTimerObj._Stop();
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");		
	}

	function StateFuncWarningTxt()
	{
		WarningTxt.SetText("");		
	}

	private function StateFuncOnCclickCancelBtn()
	{
		// End:0x0D
		if(! BRequesteEnd())
		{
			return;
		}
		SetState(STATE_ALLREADY);
		ItemJewelEnchantSubWndScript.m_hOwnerWnd.ShowWindow();
		PlayEffectStandBy();		
	}

}

state StateResult
{
	function BeginState()
	{
		local CombinationItemUIData o_data;
		local ItemInfo resultJewelItemInfo;

		DisableTransformAutosNCheckBox();
		bPausedAuto = false;
		EnchantJewel1.HideWindow();
		EnchantJewel1BackTex.HideWindow();
		dropResult_AniTex1.HideWindow();
		EnchantJewel2.HideWindow();
		EnchantJewel2BackTex.HideWindow();
		dropResult_AniTex2.HideWindow();
		// End:0x119
		if(_IsAutoMode())
		{
			EnchantedItemSlot.GetItem(0, resultJewelItemInfo);
			// End:0x10E
			if(GetResult(resultJewelItemInfo))
			{
				API_GetCombinationItemDataCurrent(o_data);
				// End:0x10E
				if(o_data.Level == (numberInputStepper._getEditNum() - 1))
				{
					InitBtn.EnableWindow();
					getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13726));
					CancelBtn.SetNameText(GetSystemString(646));
					autoProcessStepType = AUTOPROCESS_STEP_TYPE.resultBylevel/*8*/;
					return;
				}
			}
			autoProcessStepType = AUTOPROCESS_STEP_TYPE.non/*0*/;			
		}
		else
		{
			Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg4");
			CancelBtn.SetNameText(GetSystemString(646));
		}		
	}

	function EndState()
	{
		EnableTransformAutosNCheckBox();
		EnchantedItemSlotDelete();
		EnchantJewel1.ShowWindow();
		EnchantJewel2.ShowWindow();
		// End:0x46
		if(! _IsAutoMode())
		{
			ProbTxt.SetText("");
		}
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");		
	}

	private function StateFuncOnCclickCancelBtn()
	{
		// End:0x36
		if((autoProcessStepType == AUTOPROCESS_STEP_TYPE.resultBylevel/*8*/) || ! _IsAutoMode())
		{
			m_hOwnerWnd.HideWindow();
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			return;
		}
		bPausedAuto = true;
		CancelBtn.SetNameText(GetSystemString(14173));
		CancelBtn.DisableWindow();		
	}

}

state stateAutoResult
{
	function BeginState()
	{
		DisableTransformAutosNCheckBox();
		autoProcessStepType = AUTOPROCESS_STEP_TYPE.non/*0*/;
		uiTimerObj._Pause();
		EnchantJewel1.HideWindow();
		EnchantJewel2.HideWindow();
		CheckBtnsOnResult();
		StateTxtInstructionTxt();
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13726));
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg4");		
	}

	function EndState()
	{
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");
		GetTextBoxHandle(numberInputStepper.m_hOwnerWnd.m_WindowNameWithFullPath $ ".PlusText_txt").ShowWindow();
		GetEditBoxHandle(numberInputStepper.m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemCount_EditBox").ShowWindow();
		EnableTransformAutosNCheckBox();
		EnchantedItemSlot.HideWindow();
		EnchantedJewelBackTex.HideWindow();
		ProbTxt.SetText("");		
	}

	private function StateFuncOnCclickCancelBtn()
	{
		m_hOwnerWnd.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);		
	}

}

defaultproperties
{
}
