class RefineryWnd extends UICommonAPI;

const TIME_Confirm = 500;
const TIMEID_Confirm = 90;
const DWAFT_ID = 19673;
const SHAKEID_ME = 101;
const Adena = 57;
const TIMEPROGRESS = 1000;
const TWEENID_SLOT2 = 2;
const TWEENID_SLOT1 = 1;
enum type_State
{
	stone, // 0
	Target, // 1
	READY, // 2
	ing, // 3
	Result // 4
};

struct NewOptionResultInfo
{
	var bool isConfirm;
	var int targetItemSId;
	var int newItemOption1;
	var int newItemOption2;
};

struct FeeEventInfo
{
	var bool isEventOn;
	var int itemCountPercent;
	var int FeeAdenaPercent;
};

var WindowHandle Me;
var string m_WindowName;
var ItemInfo RefineItemInfo;
var ItemInfo RefinerItemInfo;
var ItemInfo GemstoneItemInfo;
var ItemInfo RefinedITemInfo;
var WindowHandle m_DragBox1;
var WindowHandle m_DragBox2;
var WindowHandle m_DragBoxResult;
var WindowHandle m_ResultAnimation1;
var WindowHandle m_ResultAnimation2;
var WindowHandle m_ResultAnimation3;
var WindowHandle m_ResultAnimation4;
var AnimTextureHandle m_RefineAnim;
var AnimTextureHandle m_ResultAnim1;
var AnimTextureHandle m_ResultAnim2;
var AnimTextureHandle m_ResultAnim3;
var AnimTextureHandle m_ResultAnim4;
var ButtonHandle m_RefineryBtn;
var ButtonHandle btnReset;
var ItemWindowHandle m_DragboxItem1;
var ItemWindowHandle m_DragBoxItem2;
var ItemWindowHandle m_ResultBoxItem;
var TextBoxHandle m_InstructionText;
var TextBoxHandle txtOptions;
var TextureHandle optionGradeTexture;
var ItemWindowHandle ItemList;
var WindowHandle ItemListWindow;
var CharacterViewportWindowHandle m_ObjectViewport;
var array<UIControlNeedItem> UIControlNeedItemScripts;
var ProgressCtrlHandle m_hRefineryWndRefineryProgress;
var WindowHandle newOptionsWnd;
var WindowHandle optionBlindWnd;
var WindowHandle newOptionBlindWnd;
var WindowHandle newDisableWnd;
var ButtonHandle newOptionBtn;
var ButtonHandle closeWndBtn;
var TextBoxHandle newTxtOptions;
var TextureHandle newOptionGradeTex;
var TextureHandle preOptionCheckTex;
var AnimTextureHandle newOptionApplyAnimTex;
var type_State CurrentState;
var L2UITween l2UITweenScript;
var L2UIInventoryObjectSimple iObject;
var RefineryWndOption RefineryWndOptionScript;
var NewOptionResultInfo newResultInfo;
var FeeEventInfo eventInfo;
var bool bHideAndInventoryShow;

var bool bActive;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_SHOW_VARIATION_MAKE_WINDOW);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PUT_INTENSIVE_RESULT_FOR_VARIATION_MAKE);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_VARIATION_RESULT);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_APPLY_VARIATION_OPTION));
}

function InitHandleListItems()
{
	local int i;
	local string WindowName;

	
	for (i = 0;i < 2;i++)
	{
		WindowName = m_WindowName $ ".NeedItem" $ string(i);
		GetWindowHandle(WindowName).SetScript("UIControlNeedItem");
		UIControlNeedItemScripts[i] = UIControlNeedItem(GetWindowHandle(WindowName).GetScript());
		UIControlNeedItemScripts[i].Init(WindowName);
		UIControlNeedItemScripts[i].DelegateItemUpdate = PeeItemUpdated;
	}
}

function InitHandleCOD()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	InitHandleListItems();
	m_DragBox1 = GetWindowHandle(m_WindowName $ ".ItemDragBox1Wnd");
	m_DragBox2 = GetWindowHandle(m_WindowName $ ".ItemDragBox2Wnd");
	m_DragBoxResult = GetWindowHandle(m_WindowName $ ".ItemDragBoxResultWnd");
	m_ResultAnimation1 = GetWindowHandle(m_WindowName $ ".RefineResultAnimation01");
	m_ResultAnimation2 = GetWindowHandle(m_WindowName $ ".RefineResultAnimation02");
	m_ResultAnimation3 = GetWindowHandle(m_WindowName $ ".RefineResultAnimation03");
	m_ResultAnimation4 = GetWindowHandle(m_WindowName $ ".RefineResultAnimation04");
	m_RefineAnim = GetAnimTextureHandle(m_WindowName $ ".RefineLoadingAnimation.RefineLoadingAnim");
	m_ResultAnim1 = GetAnimTextureHandle(m_WindowName $ ".RefineResultAnimation01.RefineResult1");
	m_ResultAnim2 = GetAnimTextureHandle(m_WindowName $ ".RefineResultAnimation02.RefineResult2");
	m_ResultAnim3 = GetAnimTextureHandle(m_WindowName $ ".RefineResultAnimation03.RefineResult3");
	m_ResultAnim4 = GetAnimTextureHandle(m_WindowName $ ".RefineResultAnimation04.RefineResult4");
	m_DragboxItem1 = GetItemWindowHandle(m_WindowName $ ".ItemDragBox1Wnd.ItemDragBox");
	m_DragBoxItem2 = GetItemWindowHandle(m_WindowName $ ".ItemDragBox2Wnd.ItemDragBox");
	m_ResultBoxItem = GetItemWindowHandle(m_WindowName $ ".ItemDragBoxResultWnd.ItemRefined");
	btnReset = GetButtonHandle(m_WindowName $ ".btnReset");
	m_RefineryBtn = GetButtonHandle(m_WindowName $ ".btnRefine");
	m_InstructionText = GetTextBoxHandle(m_WindowName $ ".txtInstruction");
	ItemListWindow = GetWindowHandle(m_WindowName $ ".ItemListWindow");
	ItemList = GetItemWindowHandle(m_WindowName $ ".ItemListWindow.ItemList");
	l2UITweenScript = L2UITween(GetScript("l2UITween"));
	RefineryWndOptionScript = RefineryWndOption(GetScript("RefineryWndOption"));
	m_hRefineryWndRefineryProgress = GetProgressCtrlHandle(m_WindowName $ ".RefineryProgress");
	txtOptions = GetTextBoxHandle(m_WindowName $ ".txtOptions");
	optionGradeTexture = GetTextureHandle(m_WindowName $ ".optionGradeTexture");
	m_ObjectViewport = GetCharacterViewportWindowHandle(m_WindowName $ ".ObjectViewport");
	m_ObjectViewport.SetUISound(true);
	m_RefineAnim.SetLoopCount(1);
	m_ResultAnim1.SetLoopCount(1);
	m_ResultAnim2.SetLoopCount(1);
	m_ResultAnim3.SetLoopCount(1);
	m_ResultAnim4.SetLoopCount(1);
	m_hRefineryWndRefineryProgress.SetProgressTime(TIMEPROGRESS - 100);
	// End:0x6A9
	if(IsSupportedResultChoice())
	{
		newOptionsWnd = GetWindowHandle(m_WindowName $ ".NewOptions_wnd");
		optionBlindWnd = GetWindowHandle(m_WindowName $ ".OptionGradeBlind_wnd");
		newOptionBlindWnd = GetWindowHandle(newOptionsWnd.m_WindowNameWithFullPath $ ".NewOptionGradeBlind_wnd");
		newDisableWnd = GetWindowHandle(m_WindowName $ ".DisableWnd");
		newOptionBtn = GetButtonHandle(newOptionsWnd.m_WindowNameWithFullPath $ ".NewOption_btn");
		closeWndBtn = GetButtonHandle(m_WindowName $ ".exitbutton");
		newTxtOptions = GetTextBoxHandle(newOptionsWnd.m_WindowNameWithFullPath $ ".txtOptions");
		newOptionGradeTex = GetTextureHandle(newOptionsWnd.m_WindowNameWithFullPath $ ".NewOptionGradeTexture");
		newOptionApplyAnimTex = GetAnimTextureHandle(m_WindowName $ ".OptionRgstr_Ani");
		preOptionCheckTex = GetTextureHandle(m_WindowName $ ".CheckTexture");
	}
}

function OnLoad()
{
	SetClosingOnESC();
	InitHandleCOD();
	bActive = true;
}

function SwapVersion(bool b)
{
	if(b)
	{
		GetWindowHandle("RefineryAutomaticWnd").ShowWindow();
		GetWindowHandle("RefineryWnd").HideWindow();	
		bActive = false;
	}
	else
	{
		GetWindowHandle("RefineryAutomaticWnd").HideWindow();
		GetWindowHandle("RefineryWnd").ShowWindow();
	}
}

function OnEvent(int a_EventID, string a_Param)
{
	if(!bActive)
		return;	
	switch (a_EventID)
	{
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_SHOW_VARIATION_MAKE_WINDOW:
			Decode_S_EX_SHOW_VARIATION_MAKE_WINDOW(a_Param);
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_PUT_INTENSIVE_RESULT_FOR_VARIATION_MAKE:
			Decode_S_EX_PUT_INTENSIVE_RESULT_FOR_VARIATION_MAKE(a_Param);
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_VARIATION_RESULT:
			Decode_S_EX_VARIATION_RESULT(a_Param);
			break;
		// End:0x99
		case EV_PacketID(class'UIPacket'.const.S_EX_APPLY_VARIATION_OPTION):
			Rs_S_EX_APPLY_VARIATION_OPTION();
			// End:0x9C
			break;
	}
}

function OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	if (a_itemInfo.ShortcutType == 4)
	{
		return;
	}
	switch (a_itemInfo.DragSrcName)
	{
		case "ItemList":
			HandleOnDropItem(a_itemInfo);
			break;
	}
}

function OnRClickItem(string strID, int Index)
{
	switch (strID)
	{
		case "ItemList":
			OnDBClickItem(strID, Index);
			break;
	}
}

function OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo iInfo;

	switch (ControlName)
	{
		case "ItemList":
			ItemList.GetItem(Index, iInfo);
			if (iInfo.Id.ClassID > 0)
			{
				HandleOnDropItem(iInfo);
			}
			break;
	}
}

function OnHide()
{
	ResetAnims();
	RemObjectSimpleByObject(iObject);
	// End:0x40
	if(IsSupportedResultChoice())
	{
		// End:0x29
		if(DialogIsMine())
		{
			DialogHide();
		}
		SetNewResultInfo(false, 0, 0, 0);
		PlayNewOptionApplyEffect(false);
		Rq_C_EX_VARIATION_CLOSE_UI();
	}
	ResetRefineryEventInfo();	
}

function OnShow()
{
	bHideAndInventoryShow = false;
	Me.SetFocus();
	SetDwaft();
	SetState(stone);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	Class 'UIAPI_WINDOW'.static.HideWindow("PetWnd");
	iObject = AddItemListenerSimple(0);
	iObject.DelegateOnUpdateItem = HandleUpdateItemStone;
	// End:0x9D
	if(IsSupportedResultChoice())
	{
		SetDialogModal(false);
		SetNewResultInfo(false, 0, 0, 0);
		PlayNewOptionApplyEffect(false);
		Rq_C_EX_VARIATION_OPEN_UI();
	}
}

function OnClickButton(string strID)
{
	switch (strID)
	{
		case "btnRefine":
			HandleClickBtnRefine();
			break;
		case "btnClose":
			OnClickbtnClose();
			break;
		case "btnReset":
			if(IsSupportedResultChoice())
			{
				NewResultCheckAndReset();				
			}
			else
			{
				//SetState(collectionState.non/*0*/);
				SetState(stone);
			}
			break;
		case "btnOptions":
			RefineryWndOptionScript.Toggle();
			break;
		case "NewOption_btn":
			OnNewOptionBtnClicked();
			break;
		case "exitbutton":
			NewResultCheckAndCloseWnd();
			break;
		case "SwapVersionBtn":
			SwapVersion(true);
			break;				
	}
}

function OnTimer(int TimerID)
{
	switch (TimerID)
	{
		case TIMEID_Confirm:
			Me.KillTimer(TIMEID_Confirm);
			if (CurrentState == Result)
			{
				// End:0x51
				if(IsSupportedResultChoice())
				{
					// End:0x4E
					if(canBuy())
					{
						m_RefineryBtn.EnableWindow();
					}					
				}
				else
				{
					m_RefineryBtn.EnableWindow();
				}
			}
			break;
	}
}

function OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
	switch (a_WindowHandle)
	{
		case m_ResultAnim1:
			m_ResultAnimation1.HideWindow();
			break;
		case m_ResultAnim2:
			m_ResultAnimation2.HideWindow();
			break;
		case m_ResultAnim3:
			m_ResultAnimation3.HideWindow();
			break;
		case m_ResultAnim4:
			m_ResultAnimation4.HideWindow();
			break;
		case newOptionApplyAnimTex:
			newOptionApplyAnimTex.HideWindow();
			// End:0x8C
			break;
	}
}

function OnProgressTimeUp(string strID)
{
	switch (strID)
	{
		case "RefineryProgress":
			RequestRefine();
			break;
	}
}

function HandleOnDropItem(ItemInfo iInfo)
{
	switch (CurrentState)
	{
		case stone:
			AddItemStone(iInfo);
			break;
		case Target:
			AddItemTarget(iInfo);
			break;
	}
}

function AddItemStone(ItemInfo iInfo)
{
	PlaySound("ItemSound2.smelting.Smelting_dragin");
	iInfo.bShowCount = True;
	m_DragboxItem1.AddItem(iInfo);
	SetState(Target);
	MakeTweenAlpha(m_DragBox1, 1);
	iObject.setId(iInfo.Id);
}

function AddItemTarget(ItemInfo iInfo)
{
	PlaySound("ItemSound2.smelting.Smelting_dragin");
	m_DragBoxItem2.AddItem(iInfo);
	AddRefineryText();
	SetPeeItems();
	SetState(READY);
	MakeTweenAlpha(m_DragBox2, 2);
	SetOptionList();
	SetNewResultInfo(false, 0, 0, 0);
	UpdateStateNewResult();
}

function SetPeeItems()
{
	local ItemInfo itemInfoStone;
	local ItemInfo itemInfoTarget;
	local int FeeItemID;
	local int FeeItemCount;
	local int CancelFee;
	local INT64 feeAdenaCount;

	// End:0x12
	if(! GetItemInfoStone(itemInfoStone))
	{
		return;
	}
	// End:0x24
	if(! GetItemInfoTarget(itemInfoTarget))
	{
		return;
	}
	// End:0x7E
	if(eventInfo.isEventOn == true)
	{
		class'RefineryAPI'.static.GetRefineryFee(itemInfoStone.Id.ClassID, eventInfo.itemCountPercent, eventInfo.FeeAdenaPercent, FeeItemID, FeeItemCount, feeAdenaCount, CancelFee);		
	}
	else
	{
		class'RefineryAPI'.static.GetRefineryFee(itemInfoStone.Id.ClassID, 100, 100, FeeItemID, FeeItemCount, feeAdenaCount, CancelFee);
	}
	if ((FeeItemID == 0) || (FeeItemCount == 0))
	{
		UIControlNeedItemScripts[0].setId(GetItemID(Adena));
		UIControlNeedItemScripts[0].SetNumNeed(feeAdenaCount);
		UIControlNeedItemScripts[1].Me.HideWindow();
	}
	else
	{
		UIControlNeedItemScripts[0].setId(GetItemID(FeeItemID));
		UIControlNeedItemScripts[0].SetNumNeed(FeeItemCount);
		UIControlNeedItemScripts[1].Me.ShowWindow();
		UIControlNeedItemScripts[1].setId(GetItemID(Adena));
		UIControlNeedItemScripts[1].SetNumNeed(feeAdenaCount);
	}
}

function SetStones()
{
	local int i;
	local int Len;
	local array<ItemInfo> iInfos;

	ItemList.Clear();
	Len = API_GetTargetItemListFromInven(iInfos);
	
	for (i = 0;i < Len;i++)
	{
		ItemList.AddItem(iInfos[i]);
	}
}

function SetTargetItems()
{
	local int i;
	local int Len;
	local array<ItemInfo> iInfos;
	local ItemInfo itemInfoStone;

	ItemList.Clear();
	if (!GetItemInfoStone(itemInfoStone))
	{
		return;
	}
	Len = API_GetItemListFromInven(itemInfoStone.Id.ClassID, iInfos);

	for (i = 0;i < Len;i++)
	{
		ItemList.AddItem(iInfos[i]);
	}
}

function int API_GetItemListFromInven(int stoneClassID, out array<ItemInfo> iItems)
{
	return Class 'RefineryAPI'.static.GetItemListFromInven(stoneClassID, iItems);
}

function int API_GetTargetItemListFromInven(out array<ItemInfo> iItems)
{
	return Class 'RefineryAPI'.static.GetTargetItemListFromInven(iItems);
}

function Rq_C_EX_TRY_TO_MAKE_VARIATION(int targetItemServerId, int intensiveItemServerId, bool isEventOn)
{
	local array<byte> stream;
	local UIPacket._C_EX_TRY_TO_MAKE_VARIATION packet;

	packet.nItemServerId = targetItemServerId;
	packet.nIntensiveItemServerID = intensiveItemServerId;
	packet.bIsVariationEventOn = byte(isEventOn);
	// End:0x53
	if(! class'UIPacket'.static.Encode_C_EX_TRY_TO_MAKE_VARIATION(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_TRY_TO_MAKE_VARIATION, stream);	
}

function Rq_C_EX_VARIATION_OPEN_UI()
{
	local array<byte> stream;
	local UIPacket._C_EX_VARIATION_OPEN_UI packet;

	// End:0x0D
	if(! IsSupportedResultChoice())
	{
		return;
	}
	// End:0x2D
	if(! class'UIPacket'.static.Encode_C_EX_VARIATION_OPEN_UI(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_VARIATION_OPEN_UI, stream);
}

function Rq_C_EX_VARIATION_CLOSE_UI()
{
	local array<byte> stream;
	local UIPacket._C_EX_VARIATION_CLOSE_UI packet;

	// End:0x0D
	if(! IsSupportedResultChoice())
	{
		return;
	}
	// End:0x2D
	if(! class'UIPacket'.static.Encode_C_EX_VARIATION_CLOSE_UI(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_VARIATION_CLOSE_UI, stream);
}

function Rq_C_EX_APPLY_VARIATION_OPTION(int variationItemSId, int itemOption1, int itemOption2)
{
	local array<byte> stream;
	local UIPacket._C_EX_APPLY_VARIATION_OPTION packet;

	// End:0x0D
	if(! IsSupportedResultChoice())
	{
		return;
	}
	packet.nVariationItemSID = variationItemSId;
	packet.nItemOption1 = itemOption1;
	packet.nItemOption2 = itemOption2;
	// End:0x5D
	if(! class'UIPacket'.static.Encode_C_EX_APPLY_VARIATION_OPTION(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_APPLY_VARIATION_OPTION, stream);
}

function Decode_S_EX_SHOW_VARIATION_MAKE_WINDOW(string a_Param)
{
	local UIPacket._S_EX_SHOW_VARIATION_MAKE_WINDOW packet;

	// End:0x24
	if(Me.IsShowWindow())
	{
		Me.HideWindow();		
	}
	else
	{
		// End:0x7D
		if(class'UIPacket'.static.Decode_S_EX_SHOW_VARIATION_MAKE_WINDOW(packet))
		{
			eventInfo.isEventOn = bool(packet.bIsVariationEventOn);
			eventInfo.itemCountPercent = packet.nGemStoneCountPercent;
			eventInfo.FeeAdenaPercent = packet.nFeeAdenaPercent;
		}
		Me.ShowWindow();
	}
}

function Decode_S_EX_PUT_INTENSIVE_RESULT_FOR_VARIATION_MAKE(string a_Param)
{
	local int targetItemServerId;
	local int TargetItemClassID;
	local int insertResult;

	Class'UIPacket'.static.DecodeInt(targetItemServerId);
	Class'UIPacket'.static.DecodeInt(TargetItemClassID);
	Class'UIPacket'.static.DecodeInt(insertResult);
	Handle_S_EX_PUT_INTENSIVE_RESULT_FOR_VARIATION_MAKE(targetItemServerId, TargetItemClassID, insertResult);
}

function Decode_S_EX_VARIATION_RESULT(string a_Param)
{
	local int Option1;
	local int Option2;
	local INT64 GemStoneCount;
	local INT64 NecessaryGemStoneCount;
	local int RefineResult;

	Class 'UIPacket'.static.DecodeInt(Option1);
	Class 'UIPacket'.static.DecodeInt(Option2);
	Class 'UIPacket'.static.DecodeInt64(GemStoneCount);
	Class 'UIPacket'.static.DecodeInt64(NecessaryGemStoneCount);
	Class 'UIPacket'.static.DecodeInt(RefineResult);
	Handle_S_EX_VARIATION_RESULT(Option1, Option2, RefineResult);
}

function Handle_S_EX_PUT_INTENSIVE_RESULT_FOR_VARIATION_MAKE(int targetItemServerId, int TargetItemClassID, int insertResult)
{
	local ItemInfo targetItem;

	Class'UIDATA_INVENTORY'.static.FindItem(targetItemServerId, targetItem);
	AddItemStone(targetItem);
}

function Handle_S_EX_VARIATION_RESULT(int Option1, int Option2, int RefineResult)
{
	local ItemInfo iInfo;

	switch (RefineResult)
	{
		case 1:
			SetState(Result);
			if (GetItemInfoTarget(iInfo))
			{
				// End:0xA7
				if(IsSupportedResultChoice())
				{
					SetNewResultInfo(false, iInfo.Id.ServerID, Option1, Option2);
					// End:0x9E
					if((iInfo.RefineryOp1 == 0) && iInfo.RefineryOp1 == 0)
					{
						newOptionBtn.SetEnable(false);
						Rq_C_EX_APPLY_VARIATION_OPTION(iInfo.Id.ServerID, Option1, Option2);						
					}
					else
					{
						UpdateStateNewResult();
					}					
				}
				else
				{
					iInfo.RefineryOp1 = Option1;
					iInfo.RefineryOp2 = Option2;
				}
				m_ResultBoxItem.ShowWindow();
				m_ResultBoxItem.Clear();
				m_ResultBoxItem.AddItem(iInfo);
				m_DragBoxItem2.Clear();
				m_DragBoxItem2.AddItem(iInfo);
				AddRefineryText();
			}
			// End:0x13E
			if(! IsSupportedResultChoice())
			{
				PlayResultQualityAnimation(GetOptionQuality(Option2));
			}
			break;
		case 0:
			SetHideWindow();
			break;
	}
}

function Rs_S_EX_APPLY_VARIATION_OPTION()
{
	local UIPacket._S_EX_APPLY_VARIATION_OPTION packet;
	local bool IsSuccess;
	local ItemInfo iInfo;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_APPLY_VARIATION_OPTION(packet))
	{
		return;
	}
	IsSuccess = bool(packet.bResult);
	// End:0x121
	if(IsSuccess == true)
	{
		// End:0x11E
		if(GetItemInfoTarget(iInfo))
		{
			SetNewResultInfo(true, packet.nVariationItemSID, 0, 0);
			iInfo.RefineryOp1 = packet.nItemOption1;
			iInfo.RefineryOp2 = packet.nItemOption2;
			m_ResultBoxItem.ShowWindow();
			m_ResultBoxItem.Clear();
			m_ResultBoxItem.AddItem(iInfo);
			m_DragBoxItem2.Clear();
			m_DragBoxItem2.AddItem(iInfo);
			UpdateStateNewResult();
			AddRefineryText();
			PlayNewOptionApplyEffect(true);
			PlayResultQualityAnimation(GetOptionQuality(packet.nItemOption2));
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13659));
		}		
	}
	else
	{
		Debug("S_EX_APPLY_VARIATION_OPTION FAIL");
		newOptionBtn.SetEnable(true);
	}
}

function SetState(type_State State)
{
	CurrentState = State;
	ResetAnims();
	switch (State)
	{
		case stone:
			SetStateStone();
			break;
		case Target:
			SetStateTarget();
			break;
		case READY:
			SetStateReady();
			break;
		case ing:
			SetStateIng();
			break;
		case Result:
			SetStateResult();
			break;
	}
	SetHighLightsEmpty();
	SetButtonSetting();
	SetInstructionText();
}

function SetStateStone()
{
	SetStones();
	m_DragBoxResult.HideWindow();
	ItemListWindow.ShowWindow();
	m_DragboxItem1.Clear();
	iObject.setId();
	m_DragBoxItem2.Clear();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	ClearRefineryText();
	ClearNewRefineryText();
	SetNewResultInfo(false, 0, 0, 0);
	DelOptionList();
}

function SetStateTarget()
{
	SetTargetItems();
	m_DragBoxResult.HideWindow();
	ItemListWindow.ShowWindow();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	DelOptionList();
}

function SetStateReady()
{
	m_DragBoxResult.HideWindow();
	ItemListWindow.HideWindow();
	m_hRefineryWndRefineryProgress.Stop();
	m_hRefineryWndRefineryProgress.Reset();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	SetNewResultInfo(false, 0, 0, 0);
	UpdateStateNewResult();
	bHideAndInventoryShow = false;	
}

function SetStateIng()
{
	MakeProgressTween();
	m_DragBoxResult.HideWindow();
	ItemListWindow.HideWindow();
	m_RefineAnim.ShowWindow();
	m_RefineAnim.Stop();
	m_RefineAnim.Play();
	m_hRefineryWndRefineryProgress.Stop();
	m_hRefineryWndRefineryProgress.Reset();
	m_hRefineryWndRefineryProgress.Start();
	PlaySound("Itemsound2.smelting.smelting_loding");
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	DwarfPlayAnimation();
}

function SetStateResult()
{
	MakeShakeTween();
	m_DragBoxResult.ShowWindow();
	ItemListWindow.HideWindow();
	m_DragBox1.HideWindow();
	m_DragBox2.HideWindow();
}

function UpdateStateNewResult()
{
	local string strDesc1, strDesc2, strDesc3, descAll;
	local int ColorR, ColorG, ColorB, Quality, RefineryOp1, RefineryOp2;

	local ItemInfo item;

	// End:0x0D
	if(! IsSupportedResultChoice())
	{
		return;
	}
	// End:0x1F
	if(! GetItemInfoTarget(item))
	{
		return;
	}
	RefineryOp1 = newResultInfo.newItemOption1;
	RefineryOp2 = newResultInfo.newItemOption2;
	descAll = "";
	// End:0x27D
	if((RefineryOp1 != 0) || RefineryOp2 != 0)
	{
		// End:0xBB
		if(RefineryOp2 != 0)
		{
			Quality = GetOptionQuality(RefineryOp2);
			SetNewQuality(Quality);
			ToolTip(GetScript("Tooltip")).GetRefineryColor(Quality, ColorR, ColorG, ColorB);			
		}
		// End:0x18D
		if(RefineryOp1 != 0)
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			// End:0x18D
			if(class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(RefineryOp1, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		// End:0x206
		if(RefineryOp2 != 0)
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			// End:0x206
			if(class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(RefineryOp2, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		newTxtOptions.SetTextColor(GTColor().White);
		newTxtOptions.SetText(descAll);
		// End:0x25B
		if(descAll != "")
		{
			newOptionGradeTex.ShowWindow();
		}
		newOptionBtn.SetEnable(true);
		newOptionBlindWnd.HideWindow();		
	}
	else
	{
		newOptionBtn.SetEnable(false);
		newOptionBlindWnd.ShowWindow();
		ClearNewRefineryText();
		newOptionGradeTex.HideWindow();
	}
}

function PlayNewOptionApplyEffect(bool isPlay)
{
	// End:0x0D
	if(! IsSupportedResultChoice())
	{
		return;
	}
	// End:0x56
	if(isPlay)
	{
		newOptionApplyAnimTex.Stop();
		newOptionApplyAnimTex.SetLoopCount(1);
		newOptionApplyAnimTex.ShowWindow();
		newOptionApplyAnimTex.Play();		
	}
	else
	{
		newOptionApplyAnimTex.Stop();
		newOptionApplyAnimTex.HideWindow();
	}
}

function SetDialogModal(bool isModal)
{
	// End:0x0D
	if(! IsSupportedResultChoice())
	{
		return;
	}
	// End:0x2B
	if(isModal == true)
	{
		newDisableWnd.ShowWindow();		
	}
	else
	{
		newDisableWnd.HideWindow();
	}
}

function SetNewResultInfo(bool confirmed, int itemSId, int newOption1, int newOption2)
{
	newResultInfo.isConfirm = confirmed;
	newResultInfo.targetItemSId = itemSId;
	newResultInfo.newItemOption1 = newOption1;
	newResultInfo.newItemOption2 = newOption2;
}

function ShowResultChoiceDialog()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(14060), string(self));
	class'DialogBox'.static.Inst().AnchorToOwner(0, 0);
	class'DialogBox'.static.Inst().DelegateOnOK = OnResultChoiceDialogConfirm;
	class'DialogBox'.static.Inst().DelegateOnCancel = OnDialogHide;
	class'DialogBox'.static.Inst().DelegateOnHide = OnDialogHide;
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	SetDialogModal(true);
}

function ShowCloseWndDialog()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(14061), string(self));
	class'DialogBox'.static.Inst().AnchorToOwner(0, 0);
	class'DialogBox'.static.Inst().DelegateOnOK = OnCloseWndDialogConfirm;
	class'DialogBox'.static.Inst().DelegateOnCancel = OnDialogHide;
	class'DialogBox'.static.Inst().DelegateOnHide = OnDialogHide;
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	SetDialogModal(true);
}

function ShowResetRefineryDialog()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(14061), string(self));
	class'DialogBox'.static.Inst().AnchorToOwner(0, 0);
	class'DialogBox'.static.Inst().DelegateOnOK = OnResetRefieryDialogConfirm;
	class'DialogBox'.static.Inst().DelegateOnCancel = OnDialogHide;
	class'DialogBox'.static.Inst().DelegateOnHide = OnDialogHide;
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	SetDialogModal(true);
}

function bool isPossableInventoryShow()
{
	// End:0x60
	if(((getInstanceUIData().getIsLiveServer() && Me.IsShowWindow()) && newResultInfo.isConfirm == false) && (newResultInfo.newItemOption1 != 0) || newResultInfo.newItemOption2 != 0)
	{
		return false;
	}
	return true;	
}

function setHideAndInventoryShow(bool bFlag)
{
	bHideAndInventoryShow = bFlag;	
}

function NewResultCheckAndCloseWnd()
{
	// End:0x3E
	if((newResultInfo.isConfirm == false) && (newResultInfo.newItemOption1 != 0) || newResultInfo.newItemOption2 != 0)
	{
		ShowCloseWndDialog();		
	}
	else
	{
		SetHideWindow();
	}
}

function NewResultCheckAndReset()
{
	// End:0x3E
	if((newResultInfo.isConfirm == false) && (newResultInfo.newItemOption1 != 0) || newResultInfo.newItemOption2 != 0)
	{
		ShowResetRefineryDialog();		
	}
	else
	{
		//SetState(collectionState.non/*0*/);
		SetState(stone);
	}
}

function SetInstructionText()
{
	local int numMsg;

	switch (CurrentState)
	{
		case stone:
			numMsg = 1958;
			break;
		case Target:
			numMsg = 1957;
			break;
		case READY:
			numMsg = 1984;
			break;
		case ing:
			numMsg = 13276;
			break;
		case Result:
			numMsg = 1962;
			break;
	}
	m_InstructionText.SetText(GetSystemMessage(numMsg));
}

function SetButtonSetting()
{
	Me.KillTimer(TIMEID_Confirm);
	switch (CurrentState)
	{
		case stone:
			btnReset.DisableWindow();
			m_RefineryBtn.DisableWindow();
			m_RefineryBtn.SetButtonName(1477);
			break;
		case Target:
			btnReset.EnableWindow();
			m_RefineryBtn.DisableWindow();
			m_RefineryBtn.SetButtonName(1477);
			break;
		case READY:
			btnReset.EnableWindow();
			if (canBuy())
			{
				m_RefineryBtn.EnableWindow();
			}
			else
			{
				m_RefineryBtn.DisableWindow();
			}
			m_RefineryBtn.SetButtonName(1477);
			break;
		case ing:
			btnReset.DisableWindow();
			m_RefineryBtn.EnableWindow();
			m_RefineryBtn.SetButtonName(141);
			break;
		case Result:
			btnReset.EnableWindow();
			m_RefineryBtn.DisableWindow();
			Me.SetTimer(TIMEID_Confirm, TIME_Confirm);
			m_RefineryBtn.SetButtonName(3135);
			break;
	}
}

function SetHighLightsEmpty()
{
	local int i;

	for (i = 1;i < 3;i++)
	{
		if (GetItemWindowHandleByIndex(i).GetItemNum() > 0)
		{
			GetHighLightSelectedByIndex(i).ShowWindow();
		}
		else
		{
			GetHighLightSelectedByIndex(i).HideWindow();
		}
		GetHighLightByIndex(i).HideWindow();
	}
	switch (CurrentState)
	{
		case stone:
			GetHighLightByIndex(TWEENID_SLOT1).ShowWindow();
			break;
		case Target:
			GetHighLightByIndex(TWEENID_SLOT2).ShowWindow();
			break;
	}
}

function RequestRefine()
{
	local ItemInfo itemInfoStone;
	local ItemInfo itemInfoTarget;

	if (!GetItemInfoStone(itemInfoStone))
	{
		return;
	}
	if (!GetItemInfoTarget(itemInfoTarget))
	{
		return;
	}
	m_RefineryBtn.DisableWindow();
	Rq_C_EX_TRY_TO_MAKE_VARIATION(itemInfoTarget.Id.ServerID, itemInfoStone.Id.ServerID, eventInfo.isEventOn);	
}

function HandleClickBtnRefine()
{
	local ItemInfo iInfoStone;

	switch (CurrentState)
	{
		case READY:
			SetState(ing);
			break;
		case ing:
			SetCancel();
			break;
		case Result:
			if (!GetItemInfoStone(iInfoStone))
			{
				SetState(stone);
			}
			if (iInfoStone.ItemNum == 0)
			{
				SetState(stone);
			}
			else
			{
				SetState(READY);
			}
			break;
	}
}

function OnClickbtnClose()
{
	SetHideWindow();
}

function SetHideWindow()
{
	Me.HideWindow();
	PlaySound("Itemsound2.smelting.smelting_dragout");
	// End:0x4F
	if(bHideAndInventoryShow)
	{
		ExecuteEvent(EV_InventoryToggleWindow);
	}	
}

function SetCancel()
{
	SetDwaft();
	SetState(READY);
}

event OnNewOptionBtnClicked()
{
	ShowResultChoiceDialog();
}

event OnResultChoiceDialogConfirm()
{
	// End:0x69
	if(newResultInfo.isConfirm == false && newResultInfo.newItemOption1 != 0 || newResultInfo.newItemOption2 != 0)
	{
		newOptionBtn.SetEnable(false);
		Rq_C_EX_APPLY_VARIATION_OPTION(newResultInfo.targetItemSId, newResultInfo.newItemOption1, newResultInfo.newItemOption2);
	}
}

event OnCloseWndDialogConfirm()
{
	SetHideWindow();
}

event OnResetRefieryDialogConfirm()
{
	//SetState(collectionState.non/*0*/);
	SetState(stone);
}

event OnDialogHide()
{
	SetDialogModal(false);
}

function ClearRefineryText()
{
	SetQuality(-1);
	txtOptions.SetText("");
}

function ClearNewRefineryText()
{
	if(! IsSupportedResultChoice())
	{
		return;
	}
	SetNewQuality(-1);
	newTxtOptions.SetText("");
}

function AddRefineryText()
{
	local string strDesc1;
	local string strDesc2;
	local string strDesc3;
	local string descAll;
	local int ColorR;
	local int ColorG;
	local int ColorB;
	local int Quality;
	local ItemInfo item;

	if (!GetItemInfoTarget(item))
	{
		return;
	}
	descAll = "";
	if ((item.RefineryOp1 != 0) || (item.RefineryOp2 != 0))
	{
		if (item.SlotBitType == 8192)
		{
			Quality = GetOptionQuality(item.RefineryOp1);
			SetQuality(Quality);
			ToolTip(GetScript("Tooltip")).GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		}
		else if(item.RefineryOp2 != 0)
		{
			Quality = GetOptionQuality(item.RefineryOp2);
			SetQuality(Quality);
			ToolTip(GetScript("Tooltip")).GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		}
		if (item.RefineryOp1 != 0)
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if (Class 'UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp1, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		if (item.RefineryOp2 != 0)
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if (Class 'UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp2, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		if (item.SlotBitType == 8192)
		{
			Quality = GetOptionQuality(item.RefineryOp2);
			SetQuality(Quality);
			ToolTip(GetScript("Tooltip")).GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		}
		txtOptions.SetTextColor(GTColor().White);
		txtOptions.SetText(descAll);
		if (descAll != "")
		{
			optionGradeTexture.ShowWindow();
		}
		// End:0x304
		if(IsSupportedResultChoice())
		{
			// End:0x304
			if(descAll != "")
			{
				preOptionCheckTex.ShowWindow();
				optionBlindWnd.HideWindow();
			}
		}
	}
	else
	{
		optionGradeTexture.HideWindow();
		// End:0x33D
		if(IsSupportedResultChoice())
		{
			preOptionCheckTex.HideWindow();
			optionBlindWnd.ShowWindow();
		}
	}
}

function SetQuality(int Quality)
{
	optionGradeTexture.SetTexture(GetGradeTextureByQuality(Quality));
	if (Quality <= 0)
	{
		optionGradeTexture.HideWindow();
	}
	else
	{
		optionGradeTexture.ShowWindow();
	}
}

function SetNewQuality(int Quality)
{
	// End:0x0D
	if(! IsSupportedResultChoice())
	{
		return;
	}
	newOptionGradeTex.SetTexture(GetGradeTextureByQuality(Quality));
	// End:0x44
	if(Quality <= 0)
	{
		newOptionGradeTex.HideWindow();		
	}
	else
	{
		newOptionGradeTex.ShowWindow();
	}
}

function string GetGradeTextureByQuality(int Quality)
{
	switch (Quality)
	{
		case 1:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Yellow";
			break;
		case 2:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Blue";
			break;
		case 3:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_purple";
			break;
		case 4:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Red";
			break;
		default:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Red";
			break;
	}
}

function ResetAnims()
{
	l2UITweenScript.StopTween(m_WindowName, 1);
	l2UITweenScript.StopTween(m_WindowName, 2);
	l2UITweenScript.StopShake(m_WindowName, SHAKEID_ME);
	m_DragBox1.ShowWindow();
	m_DragBox1.SetAnchor(m_WindowName $ ".MainBg", "CenterCenter", "CenterCenter", -78, 0);
	m_DragBox1.ClearAnchor();
	m_DragBox1.SetAlpha(255);
	m_DragBox2.ShowWindow();
	m_DragBox2.SetAnchor(m_WindowName $ ".MainBg", "CenterCenter", "CenterCenter", 78, 0);
	m_DragBox2.ClearAnchor();
	m_DragBox2.SetAlpha(255);
	m_RefineAnim.HideWindow();
	m_RefineAnim.Stop();
	m_hRefineryWndRefineryProgress.SetPos(0);
	m_hRefineryWndRefineryProgress.Stop();
	m_ResultBoxItem.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	m_ResultAnimation4.HideWindow();
}

function MakeProgressTween()
{
	local L2UITween.TweenObject tweenObj0;

	ResetAnims();
	tweenObj0.Owner = m_WindowName;
	tweenObj0.Id = 1;
	tweenObj0.Target = m_DragBox1;
	tweenObj0.Duration = 1000.0;
	tweenObj0.MoveX = 78.0;
	tweenObj0.ease = l2UITweenScript.easeType.IN_STRONG;
	l2UITweenScript.AddTweenObject(tweenObj0);
	tweenObj0.Id = 2;
	tweenObj0.Target = m_DragBox2;
	tweenObj0.MoveX = -tweenObj0.MoveX;
	tweenObj0.ease = l2UITweenScript.easeType.IN_STRONG;
	l2UITweenScript.AddTweenObject(tweenObj0);
}

function MakeTweenAlpha(WindowHandle targetWindow, int tweenID)
{
	local L2UITween.TweenObject tweenObj0;

	targetWindow.SetAlpha(0);
	tweenObj0.Owner = m_WindowName;
	tweenObj0.Id = tweenID;
	tweenObj0.Target = targetWindow;
	tweenObj0.Duration = 500.0;
	tweenObj0.Alpha = 255.0;
	tweenObj0.ease = l2UITweenScript.easeType.OUT_STRONG;
	l2UITweenScript.AddTweenObject(tweenObj0);
}

function MakeShakeTween()
{
	local L2UITween.ShakeObject shakeObj;

	shakeObj.Owner = m_WindowName;
	shakeObj.Target = Me;
	shakeObj.Duration = 500.0;
	shakeObj.shakeSize = 4.0;
	shakeObj.Direction = l2UITweenScript.directionType.small;
	shakeObj.Id = SHAKEID_ME;
	l2UITweenScript.StartShakeObject(shakeObj);
}

function PlayResultQualityAnimation(int Grade)
{
	switch (Grade)
	{
		case 1:
			m_ResultAnimation1.ShowWindow();
			PlaySound("ItemSound2.smelting.smelting_finalB");
			m_ResultAnim1.Stop();
			m_ResultAnim1.Play();
			break;
		case 2:
			m_ResultAnimation2.ShowWindow();
			PlaySound("ItemSound2.smelting.smelting_finalC");
			m_ResultAnim2.Stop();
			m_ResultAnim2.Play();
			break;
		case 3:
			m_ResultAnimation3.ShowWindow();
			PlaySound("ItemSound2.smelting.smelting_finalD");
			m_ResultAnim3.Stop();
			m_ResultAnim3.Play();
			break;
		case 4:
			m_ResultAnimation4.ShowWindow();
			PlaySound("ItemSound2.smelting.smelting_finalD");
			m_ResultAnim4.Stop();
			m_ResultAnim4.Play();
			break;
	}
}

function SetDwaft()
{
	m_ObjectViewport.SetNPCInfo(DWAFT_ID);
	m_ObjectViewport.ShowNPC(0.1);
	m_ObjectViewport.SpawnNPC();
	m_ObjectViewport.ShowWindow();
}

function DwarfPlayAnimation()
{
	local int randNum;

	randNum = Rand(10);
	if (randNum < 2)
	{
		m_ObjectViewport.PlayAnimation(2);
	}
	else
	{
		m_ObjectViewport.PlayAnimation(1);
	}
}

function bool GetItemInfoStone(out ItemInfo iInfo)
{
	return GetItemInfoByIndex(TWEENID_SLOT1, iInfo);
}

function bool GetItemInfoTarget(out ItemInfo iInfo)
{
	return GetItemInfoByIndex(TWEENID_SLOT2, iInfo);
}

function bool GetItemInfoByIndex(int Index, out ItemInfo iInfo)
{
	return GetItemWindowHandleByIndex(Index).GetItem(0, iInfo);
}

function int GetOptionQuality(int OptionID)
{
	local int Quality;

	Quality = class'UIDATA_REFINERYOPTION'.static.GetQuality(OptionID);
	// End:0x2F
	if(0 >= Quality)
	{
		Quality = 1;		
	}
	else if(4 < Quality)
	{
		Quality = 4;
	}
	return Quality;
}

function ResetRefineryEventInfo()
{
	eventInfo.isEventOn = false;
	eventInfo.itemCountPercent = 100;
	eventInfo.FeeAdenaPercent = 100;	
}

function ItemWindowHandle GetItemWindowHandleByIndex(int Index)
{
	return GetItemWindowHandle(m_WindowName $ ".ItemDragBox" $ string(Index) $ "Wnd.ItemDragBox");
}

function WindowHandle GetHighLightByIndex(int Index)
{
	return GetWindowHandle(m_WindowName $ ".ItemDragBox" $ string(Index) $ "Wnd.DropHighlight");
}

function WindowHandle GetHighLightSelectedByIndex(int Index)
{
	return GetWindowHandle(m_WindowName $ ".ItemDragBox" $ string(Index) $ "Wnd.SelectedItemHighlight");
}

function HandleUpdateItemStone(optional array<ItemInfo> iInfo, optional int Index)
{
	local ItemInfo iInfoStone;

	iInfoStone = iInfo[0];
	m_DragboxItem1.Clear();
	if (iInfoStone.ItemNum == 0)
	{
		switch (CurrentState)
		{
			case Result:
				iObject.setId();
				break;
			default:
				SetState(stone);
				break;
		}
	}
	else
	{
		iInfoStone.bShowCount = True;
		m_DragboxItem1.AddItem(iInfoStone);
	}
}

function PeeItemUpdated(UIControlNeedItem script)
{
	switch (CurrentState)
	{
		case ing:
			if (!canBuy())
			{
				SetState(READY);
			}
			break;
		default:
			SetButtonSetting();
			break;
	}
}

function bool canBuy()
{
	return UIControlNeedItemScripts[0].canBuy() && UIControlNeedItemScripts[1].canBuy();
}

function bool IsSupportedResultChoice()
{
	
	return true;
	// End:0x15
	if(getInstanceUIData().getIsLiveServer())
	{
		return true;
	}
	return false;
}

function bool IsNewResultNotConfirm()
{
	// End:0x56
	if(IsSupportedResultChoice() && Me.IsShowWindow() && newResultInfo.isConfirm == false && (newResultInfo.newItemOption1 != 0) || newResultInfo.newItemOption2 != 0)
	{
		return true;
	}
	return false;	
}

function AddDesc(string Desc, out string descAll)
{
	if (Desc == "")
	{
		return;
	}
	if (descAll != "")
	{
		descAll = descAll $ "\\n" $ Desc;
	}
	else
	{
		descAll = Desc;
	}
}

function DelOptionList()
{
	RefineryWndOptionScript.DelIds();
}

function SetOptionList()
{
	local ItemInfo iInfoStone;
	local ItemInfo iInfoTarget;

	if (!GetItemInfoStone(iInfoStone))
	{
		DelOptionList();
		return;
	}
	if (!GetItemInfoTarget(iInfoTarget))
	{
		DelOptionList();
		return;
	}
	RefineryWndOptionScript.SetIDs(iInfoStone.Id.ClassID, iInfoTarget.Id.ClassID);
}

function OnReceivedCloseUI()
{
	if (CurrentState == ing)
	{
		SetCancel();
	}
	else
	{
		// End:0x2B
		if(IsSupportedResultChoice())
		{
			NewResultCheckAndCloseWnd();			
		}
		else
		{
			SetHideWindow();
		}
	}
}

defaultproperties
{
}
