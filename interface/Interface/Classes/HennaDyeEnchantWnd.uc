class HennaDyeEnchantWnd extends UICommonAPI;

const STATE_BEGIN = 'begin';
const STATE_SELECT = 'select';
const STATE_PROGRESS = 'progress';
const STATE_RESULTSUCCESS = 'resultSuccess';
const STATE_RESULTFAIL = 'resultFail';

var EffectViewportWndHandle Result_EffectViewport;
var AnimTextureHandle ResultSlotani_Tex;
var TextBoxHandle InstructionTxt;
var ButtonHandle EnchantBtn;
var ButtonHandle CloseBtn;
var ItemWindowHandle EnchantJewel1;
var ProgressCtrlHandle EnchantProgress;
var array<UIControlGroupButtonHighlighting> highlightings;
var UIControlNeedItemList needItemListNormalScr;
var int Selected;
var L2UITween l2UITweenScript;

static function HennaDyeEnchantWnd Inst()
{
	return HennaDyeEnchantWnd(GetScript("HennaDyeEnchantWnd"));
}

function Initialize()
{
	Result_EffectViewport = GetEffectViewportWndHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_EffectViewport");
	ResultSlotani_Tex = GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultSlotani_Tex");
	InstructionTxt = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".InstructionTxt");
	EnchantBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantBtn");
	CloseBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CloseBtn");
	EnchantJewel1 = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantJewel1");
	EnchantProgress = GetProgressCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantProgress");
	EnchantProgress.SetProgressTime(700);
	InitHennaGrouBtns();
	InitNeedItemList();
	Selected = -1;
}

function InitHennaGrouBtns()
{
	local int i;
	local UIControlGroupButtonHighlighting scr;


	// End:0xEA [Loop If]
	for(i = 1; i <= class'InventoryWnd'.const.TAB_LENGTH; i++)
	{
		scr = class'UIControlGroupButtonHighlighting'.static.InitScript(GetDyeSlot(i));
		scr._SetBtnTexture("L2UI_CT1.Button.emptyBtn", "L2UI_NewTex.Button.Slot_Over", "L2UI_NewTex.Button.Slot_Down");
		scr._AddWindow(GetSlotItemWindow(i));
		scr.DelegateOnLButtonUp = HandleDelegateOnLButtonUp;
		highlightings[i] = scr;
	}
}

function InitNeedItemList()
{
	needItemListNormalScr = class'UIControlNeedItemList'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItemWnd"), 2);
	needItemListNormalScr.DelegateOnUpdateItem = HandleOnUpdateItemNormal;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_COMPOSE);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_LIST);
	RegisterEvent(EV_StateChanged);
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x28
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_COMPOSE:
			Handle_S_EX_NEW_HENNA_COMPOSE();
			// End:0x7D
			break;
		// End:0x49
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_LIST:
			Handle_S_EX_NEW_HENNA_LIST();
			// End:0x7D
			break;
		// End:0x7A
		case EV_StateChanged:
			// End:0x77
			if(param != "GAMINGSTATE")
			{
				m_hOwnerWnd.HideWindow();
			}
			// End:0x7D
			break;
	}
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x1D
		case "CloseBtn":
			OnCloseBtnClick();
			// End:0x75
			break;
		// End:0x35
		case "EnchantBtn":
			OnEnchantBtnClick();
			// End:0x75
			break;
		// End:0x72
		case "OpenBtn":
			class'ItemJewelEnchantWnd'.static.Inst().ToggleShowWindow(class'ItemJewelEnchantWnd'.static.Inst().EnchantType.dye);
			// End:0x75
			break;
	}
}

event OnShow()
{
	GotoState(STATE_BEGIN);
}

event OnHide()
{
	GotoState(STATE_SELECT);
	ShowMennaMenuWnd();
}

function ShowMennaMenuWnd()
{
	local Rect rectWnd;

	// End:0xE0
	if(! GetWindowHandle("ItemJewelEnchantWnd").IsShowWindow())
	{
		rectWnd = GetWindowHandle("HennaMenuWnd").GetRect();
		getInstanceL2Util().syncWindowLoc(m_hOwnerWnd.m_WindowNameWithFullPath, "HennaMenuWnd", (m_hOwnerWnd.GetRect().nWidth - rectWnd.nWidth) / 2, (m_hOwnerWnd.GetRect().nHeight - rectWnd.nHeight) / 2);
		GetWindowHandle("HennaMenuWnd").ShowWindow();
	}
}

event OnProgressTimeUp(string strID)
{
	switch(strID)
	{
		// End:0x24
		case "EnchantProgress":
			API_C_EX_NEW_HENNA_COMPOSE();
			// End:0x27
			break;
	}
}

function SetUnSelect(int Index)
{
	EnchantJewel1.Clear();
	GetSlotSlectTex(Index).HideWindow();
	ResultSlotani_Tex.Stop();
	ResultSlotani_Tex.HideWindow();
	EnchantBtn.DisableWindow();
	Selected = -1;
	InstructionTxt.SetTextColor(GetColor(187, 187, 187, 255));
	InstructionTxt.SetText(GetSystemString(13827));
	needItemListNormalScr.CleariObjects();
}

function SetSelect(int Index)
{
	local ItemInfo iInfo;

	// End:0x17
	if(! GetItemInfoAtIndex(Index, iInfo))
	{
		return;
	}
	Selected = Index;
	GetSlotSlectTex(Index).ShowWindow();
	SetSelectedEnchantInfo();
	SetSelectedProb();
	PlayAnimationItemChanged();
}

function SetSelectedEnchantInfo()
{
	local ItemInfo iInfo;
	local DyeCombinationUIData o_data;

	// End:0x17
	if(! GetItemInfoAtIndex(Selected, iInfo))
	{
		return;
	}
	Debug("선택 된 건 " @ string(Selected));
	EnchantJewel1.Clear();
	EnchantJewel1.AddItem(iInfo);
	// End:0x77
	if(! GetCombinationData(iInfo.Id.ClassID, o_data))
	{
		return;
	}
	class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(o_data.SlotTwoItemID), iInfo);
	needItemListNormalScr.CleariObjects();
	needItemListNormalScr.AddNeedItemClassID(iInfo.Id.ClassID, 1);
	needItemListNormalScr.AddNeedItemClassID(57, o_data.Commission);
	needItemListNormalScr.SetBuyNum(1);
}

function SetSelectedProb()
{
	local ItemInfo iInfo;
	local int HennaID;
	local DyeCombinationUIData o_data;

	// End:0x4E
	if(! GetItemInfoAtIndex(Selected, iInfo))
	{
		InstructionTxt.SetTextColor(GetColor(187, 187, 187, 255));
		InstructionTxt.SetText(GetSystemString(13827));
		return;
	}
	HennaID = iInfo.Id.ClassID;
	// End:0xA8
	if(! CheckSelectedHennaLevel())
	{
		InstructionTxt.SetTextColor(GetColor(187, 187, 187, 255));
		InstructionTxt.SetText(GetSystemString(13908));		
	}
	else
	{
		// End:0x10C
		if(GetCombinationData(HennaID, o_data))
		{
			InstructionTxt.SetText((GetSystemString(642) @ ":") @ class'L2Util'.static.Inst().CutFloatIntByString(class'L2Util'.static.Inst().CutFloatDecimalPlaces(o_data.Prob, 4, true)));
			InstructionTxt.SetTextColor(GetColor(255, 172, 0, 255));			
		}
		else
		{
			InstructionTxt.SetTextColor(class'L2Util'.static.Inst().Red2);
			InstructionTxt.SetText(GetSystemString(13912));
		}
	}
}

function bool CheckSelectedHennaLevel()
{
	local ItemInfo iInfo;
	local int hennaLevel, HennaID;

	// End:0x17
	if(! GetItemInfoAtIndex(Selected, iInfo))
	{
		return false;
	}
	HennaID = iInfo.Id.ClassID;
	class'UIDATA_HENNA'.static.GetHennaDyeItemLevel(HennaID, hennaLevel);
	return hennaLevel < HennaMenuWnd(GetScript("HennaMenuWnd")).getDyePotentialLastLevel();
}

function bool GetCombinationData(int HennaID, out DyeCombinationUIData o_data)
{
	local int hennaItemClassID;

	class'UIDATA_HENNA'.static.GetHennaDyeItemClassID(HennaID, hennaItemClassID);
	return class'UIDATA_HENNA'.static.GetDyeCombinationData(hennaItemClassID, o_data);
}

function PlayAnimationItemChanged()
{
	ResultSlotani_Tex.ShowWindow();
	ResultSlotani_Tex.SetLoopCount(1);
	ResultSlotani_Tex.Play();
}

function Handle_S_EX_NEW_HENNA_COMPOSE()
{
	local UIPacket._S_EX_NEW_HENNA_COMPOSE composeResultPacket;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_NEW_HENNA_COMPOSE(composeResultPacket))
	{
		return;
	}
	// End:0x2D
	if(composeResultPacket.nResultHennaID < 0)
	{
		return;
	}
	// End:0x43
	if(composeResultPacket.nResultItemID != -1)
	{
		return;
	}
	// End:0x5D
	if(composeResultPacket.cSuccess == 1)
	{
		GotoState(STATE_RESULTSUCCESS);		
	}
	else if(composeResultPacket.cSuccess == 0)
	{
		GotoState(STATE_RESULTFAIL);
	}
	HennaMenuWnd(GetScript("HennaMenuWnd")).API_C_EX_NEW_HENNA_LIST();
}

function Handle_S_EX_NEW_HENNA_LIST()
{
	local int i, HennaID, hennaLevel;
	local UIPacket._S_EX_NEW_HENNA_LIST henna_list_packet;
	local ItemInfo iInfo;
	local InventoryWnd scr;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_NEW_HENNA_LIST(henna_list_packet))
	{
		return;
	}

	// End:0x56 [Loop If]
	for(i = 1; i <= class'InventoryWnd'.const.TAB_LENGTH; i++)
	{
		GetSlotItemWindow(i).Clear();
	}
	scr = InventoryWnd(GetScript("inventoryWnd"));

	// End:0x203 [Loop If]
	for(i = 0; i < henna_list_packet.hennaInfoList.Length; i++)
	{
		HennaID = henna_list_packet.hennaInfoList[i].nHennaID;
		// End:0xC8
		if(! class'UIDATA_HENNA'.static.GetItemCheck(HennaID))
		{
			// [Explicit Continue]
			continue;
		}
		class'UIDATA_HENNA'.static.GetHennaDyeItemLevel(HennaID, hennaLevel);
		iInfo.Name = class'UIDATA_HENNA'.static.GetItemNameS(HennaID) @ class'UIDATA_HENNA'.static.GetDescriptionS(HennaID);
		iInfo.AdditionalName = MakeFullSystemMsg(GetSystemMessage(5203), string(hennaLevel));
		iInfo.Id.ClassID = HennaID;
		// End:0x1B0
		if(henna_list_packet.hennaInfoList[i].nActiveStep > 0)
		{
			iInfo.Description = scr.GetHennaPotenString(henna_list_packet.hennaInfoList[i].nPotenID, henna_list_packet.hennaInfoList[i].nActiveStep);			
		}
		else
		{
			iInfo.Description = "";
		}
		iInfo.IconName = class'UIDATA_HENNA'.static.GetIconTexS(HennaID);
		GetSlotItemWindow(i + 1).AddItem(iInfo);
	}
	// End:0x218
	if(Selected > -1)
	{
		SetSelectedEnchantInfo();
	}
}

function OnCloseBtnClick()
{
	switch(GetStateName())
	{
		// End:0x17
		case STATE_PROGRESS:
			GotoState(STATE_SELECT);
			// End:0x2C
			break;
		// End:0xFFFF
		default:
			m_hOwnerWnd.HideWindow();
			// End:0x2C
			break;
	}
}

function OnEnchantBtnClick()
{
	switch(GetStateName())
	{
		// End:0x17
		case STATE_BEGIN:
			GotoState(STATE_SELECT);
			// End:0x62
			break;
		// End:0x29
		case STATE_SELECT:
			GotoState(STATE_PROGRESS);
			// End:0x62
			break;
		// End:0x3B
		case STATE_PROGRESS:
			GotoState(STATE_SELECT);
			// End:0x62
			break;
		// End:0x4D
		case STATE_RESULTSUCCESS:
			GotoState(STATE_SELECT);
			// End:0x62
			break;
		// End:0x5F
		case STATE_RESULTFAIL:
			GotoState(STATE_SELECT);
			// End:0x62
			break;
	}
}

function HandleDelegateOnLButtonUp(WindowHandle wnd, int X, int Y)
{
	// End:0x0F
	if(GetStateName() != STATE_SELECT)
	{
		return;
	}
	SetUnSelect(Selected);
	SetSelect(GetIndex(wnd));
}

function HandleOnUpdateItemNormal()
{
	// End:0x0F
	if(GetStateName() != 'Select')
	{
		return;
	}
	// End:0x4F
	if(needItemListNormalScr.GetCanBuy() && Selected > -1 && CheckSelectedHennaLevel())
	{
		EnchantBtn.EnableWindow();		
	}
	else
	{
		EnchantBtn.DisableWindow();
	}
}

function API_C_EX_NEW_HENNA_COMPOSE()
{
	local int ClassID;
	local array<ItemInfo> iInfos;
	local array<byte> stream;
	local UIPacket._C_EX_NEW_HENNA_COMPOSE packet;

	// End:0x1C
	if(! needItemListNormalScr.GetItemClassID(0, ClassID))
	{
		return;
	}
	class'UIDATA_INVENTORY'.static.FindItemByClassID(ClassID, iInfos);
	packet.nSlotOneIndex = Selected;
	packet.nSlotOneItemID = -1;
	packet.nSlotTwoItemID = iInfos[0].Id.ServerID;
	// End:0x91
	if(! class'UIPacket'.static.Encode_C_EX_NEW_HENNA_COMPOSE(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_NEW_HENNA_COMPOSE, stream);
}

function bool GetItemInfoAtIndex(int Index, out ItemInfo iInfo)
{
	local ItemWindowHandle iWnd;

	iWnd = GetSlotItemWindow(Index);
	// End:0x27
	if(iWnd.m_pTargetWnd == none)
	{
		return false;
	}
	return iWnd.GetItem(0, iInfo);
}

function int GetIndex(WindowHandle wnd)
{
	local int i;

	// End:0x55 [Loop If]
	for(i = 1; i <= class'InventoryWnd'.const.TAB_LENGTH; i++)
	{
		// End:0x4B
		if(wnd.GetParentWindowName() == GetDyeSlot(i).GetWindowName())
		{
			return i;
		}
	}
	return -1;
}

function DisableDyeSlots()
{
	local int i;

	// End:0x50 [Loop If]
	for(i = 1; i <= class'InventoryWnd'.const.TAB_LENGTH; i++)
	{
		GetDyeSlot(i).DisableWindow();
		highlightings[i]._SetDisable();
	}
}

function EnableDyeSlots()
{
	local int i;

	// End:0x50 [Loop If]
	for(i = 1; i <= class'InventoryWnd'.const.TAB_LENGTH; i++)
	{
		GetDyeSlot(i).EnableWindow();
		highlightings[i]._SetEnable();
	}
}

function WindowHandle GetDyeSlot(int Index)
{
	return GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DyeSlotWnd0" $ string(Index) $ "_wnd");
}

function WindowHandle GetSlotSlectTex(int Index)
{
	return GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DyeSlotWnd0" $ string(Index) $ "_wnd.SlotSelect_tex");
}

function ItemWindowHandle GetSlotItemWindow(int Index)
{
	return GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DyeSlotWnd0" $ string(Index) $ "_wnd.Henna_ItemWnd");
}

function OnReceivedCloseUI()
{
	switch(GetStateName())
	{
		// End:0x17
		case STATE_PROGRESS:
			GotoState(STATE_SELECT);
			// End:0x34
			break;
		// End:0xFFFF
		default:
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			m_hOwnerWnd.HideWindow();
			// End:0x34
			break;
	}
}

auto state Begin
{
	function BeginState()
	{
		local int i;

		class'L2Util'.static.Inst().ItemRelationWindowHide(m_hOwnerWnd.m_WindowNameWithFullPath);
		m_hOwnerWnd.SetFocus();
		Result_EffectViewport.SpawnEffect("");
		InstructionTxt.SetText("");
		EnchantBtn.DisableWindow();

		// End:0x98 [Loop If]
		for(i = 1; i <= class'InventoryWnd'.const.TAB_LENGTH; i++)
		{
			SetUnSelect(i);
		}
		GotoState(STATE_SELECT);
	}

	function EndState()
	{
		EnchantBtn.DisableWindow();
	}
}

state Select
{
	function BeginState()
	{
		EnchantBtn.SetButtonName(2066);
		EnchantProgress.SetPos(0);
		EnchantProgress.Reset();
		InstructionTxt.SetText(GetSystemString(13827));
		EnableDyeSlots();
		SetSelectedProb();
		HandleOnUpdateItemNormal();
	}

	function EndState()
	{
		InstructionTxt.SetTextColor(GetColor(187, 187, 187, 255));
		DisableDyeSlots();
		GetDyeSlot(Selected).EnableWindow();
	}

}

state Progress
{
	function BeginState()
	{
		PlaySound("ItemSound3.enchant_process");
		CloseBtn.SetButtonName(1342);
		EnchantBtn.DisableWindow();
		EnchantProgress.SetPos(0);
		EnchantProgress.Reset();
		EnchantProgress.Start();
		InstructionTxt.SetText(GetSystemString(13893));
		Result_EffectViewport.SpawnEffect("LineageEffect2.ui_spirit_extract");
	}

	function EndState()
	{
		EnchantProgress.Stop();
		Result_EffectViewport.SpawnEffect("");
		CloseBtn.SetButtonName(646);
	}
}

state resultSuccess
{
	function BeginState()
	{
		Result_EffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_succ");
		InstructionTxt.SetText(GetSystemString(13894));
		EnchantBtn.SetButtonName(1337);
		EnchantBtn.EnableWindow();
		PlaySound("ItemSound3.enchant_success");
		PlayAnimationItemChanged();
	}

	function EndState()
	{}
}

state resultFail
{
	function BeginState()
	{
		Result_EffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_fail");
		InstructionTxt.SetText(GetSystemString(13895));
		EnchantBtn.SetButtonName(1337);
		EnchantBtn.EnableWindow();
		PlaySound("ItemSound3.enchant_fail");
	}

	function EndState()
	{}
}

defaultproperties
{
}
