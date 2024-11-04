class HomunculusWndGacha extends UICommonAPI;

const TIMEID_CREATESTART = 9;
const TIME_CREATESTART = 3000;
const CARD_MAX = 4;

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var ButtonHandle btnMain0;
var TextureHandle Select_tex;
var EffectViewportWndHandle EffectViewport;
var WindowHandle resultWnd;
var CharacterViewportWindowHandle m_ObjectViewport;
var TextBoxHandle txtResult0;
var EffectViewportWndHandle EffectViewportResult;
var TextureHandle birthCircle_tex;
var AnimTextureHandle birthCircleInput_anitex;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndMainList homunculusWndMainListScript;
var L2UITween l2uiTweenScript;
var array<UIControlNeedItemList> needItemLists;
var array<HomunculusAPI.HomunListUIInfo> homunListUIInfos;
var int curTweenID;
var int SelectedIndex;
var int LastIdx;
var bool isRequested;
var array<L2UIInventoryObject> iObjects;

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	util = L2Util(GetScript("L2Util"));
	EffectViewport = GetEffectViewportWndHandle(m_WindowName $ ".EffectViewport");
	resultWnd = GetWindowHandle(m_WindowName $ ".resultWnd");
	m_ObjectViewport = GetCharacterViewportWindowHandle(m_WindowName $ ".resultWnd.ObjectViewport");
	m_ObjectViewport.SetUISound(true);
	txtResult0 = GetTextBoxHandle(m_WindowName $ ".resultWnd.txtResult0");
	EffectViewportResult = GetEffectViewportWndHandle(m_WindowName $ ".resultWnd.EffectViewportResult");
	birthCircle_tex = GetTextureHandle(m_WindowName $ ".birthCircle_tex");
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndMainListScript = HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList"));
	l2uiTweenScript = L2UITween(GetScript("L2UITween"));
	btnMain0 = GetButtonHandle(m_WindowName $ ".btnMain0");
	Select_tex = GetTextureHandle(m_WindowName $ ".SelectedSlot_Tex");
	birthCircleInput_anitex = GetAnimTextureHandle(m_WindowName $ ".birthCircleInput_anitex");
	SetTooltip();
	SelectedIndex = -1;
	curTweenID = -1;
}

function HandleGameInit()
{
	local int i;
	local RichListCtrlHandle rich;

	homunListUIInfos = API_GetHomunculusGatchaList();

	// End:0xE3 [Loop If]
	for(i = 0; i < homunListUIInfos.Length; i++)
	{
		SetCard(i);
		rich = GetRichListCtrl(i);
		SetAdenaPee(rich, homunListUIInfos[i].Fee);
		iObjects[i] = AddItemListener(i);
		iObjects[i].DelegateOnCompare = CompareFunc;
		iObjects[i].DelegateOnAddItem = HandleItemListner;
		iObjects[i].DelegateOnUpdateItem = HandleItemListner;
		iObjects[i].DelegateOnDeletedItem = HandleItemListner;
	}

	// End:0x119 [Loop If]
	for(i = i; i < CARD_MAX; i++)
	{
		GetCardWnd(i).HideWindow();
	}
	SetDeselect();
}

function SetAdenaPee(RichListCtrlHandle rich, INT64 pee)
{
	local int Len;

	Len = needItemLists.Length;
	GetWindowHandle((GetCardWndPath(Len)) $ ".NeedItemRichListCtrlScript").SetScript("UIControlNeedItemList");
	needItemLists[Len] = UIControlNeedItemList(GetWindowHandle((GetCardWndPath(Len)) $ ".NeedItemRichListCtrlScript").GetScript());
	needItemLists[Len].SetRichListControler(rich);
	needItemLists[Len].StartNeedItemList(1);
	needItemLists[Len].SetFormType(needItemLists[Len].FORM_TYPE.nameSide);
	needItemLists[Len].AddNeedItemClassID(57, pee);
	needItemLists[Len].DelegateOnUpdateItem = None;
	needItemLists[Len].SetBuyNum(1);
}

function SetTooltip()
{
	local CustomTooltip t;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(200);
	util.ToopTipInsertText(GetSystemString(13548));
	GetButtonHandle(m_WindowName $ ".Help_Btn").SetTooltipCustomType(util.getCustomToolTip());
}

event OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_SUMMON_HOMUNCULUS_COUPON_RESULT);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_SHOW_HOMUNCULUS_COUPON_UI);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DELETE_HOMUNCLUS_DATA_RESULT);
	RegisterEvent(EV_GamingStateEnter);
}

event OnLoad()
{
	Initialize();
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_SHOW_HOMUNCULUS_COUPON_UI:
			Handle_S_EX_SHOW_HOMUNCULUS_COUPON_UI();
			// End:0x8D
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_SUMMON_HOMUNCULUS_COUPON_RESULT:
			Handle_S_EX_SUMMON_HOMUNCULUS_COUPON_RESULT();
			// End:0x8D
			break;
		// End:0x6A
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_DELETE_HOMUNCLUS_DATA_RESULT:
			Handle_S_EX_DELETE_HOMUNCLUS_DATA_RESULT();
			break;
		case EV_GamingStateEnter:
			// End:0x87
			if(HomunculusWndScript.ChkSerVer())
			{
				HandleGameInit();
			}
			// End:0x8D
			break;
	}
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local ItemInfo Info;

	Debug(a_ButtonHandle.GetParentWindowName());
	Debug(a_ButtonHandle.GetWindowName());
	// End:0x242
	if(a_ButtonHandle.GetWindowName() == "Probability_Btn")
	{
		// End:0xCC
		if(a_ButtonHandle.GetParentWindowName() == "ItemSlot_Wnd00")
		{
			GetTexturehandleCraftSlot(0).GetItem(0, Info);
			HomunculusWndProbability(GetScript("HomunculusWndProbability")).API_C_EX_REQ_HOMUNCULUS_PROB_LIST(1, Info.Id.ClassID);			
		}
		else if(a_ButtonHandle.GetParentWindowName() == "ItemSlot_Wnd01")
		{
			GetTexturehandleCraftSlot(1).GetItem(0, Info);
			HomunculusWndProbability(GetScript("HomunculusWndProbability")).API_C_EX_REQ_HOMUNCULUS_PROB_LIST(1, Info.Id.ClassID);				
		}
		else if(a_ButtonHandle.GetParentWindowName() == "ItemSlot_Wnd02")
		{
			GetTexturehandleCraftSlot(2).GetItem(0, Info);
			HomunculusWndProbability(GetScript("HomunculusWndProbability")).API_C_EX_REQ_HOMUNCULUS_PROB_LIST(1, Info.Id.ClassID);					
		}
		else if(a_ButtonHandle.GetParentWindowName() == "ItemSlot_Wnd03")
		{
			GetTexturehandleCraftSlot(3).GetItem(0, Info);
			HomunculusWndProbability(GetScript("HomunculusWndProbability")).API_C_EX_REQ_HOMUNCULUS_PROB_LIST(1, Info.Id.ClassID);
		}
	}
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x2E
		case "swapBtn":
			GetWindowHandle("HomunculusWndProbability").HideWindow();
			HomunculusWndScript.homunculusWndBirthScript.HandleSwapCacha();
			// End:0x76
			break;
		// End:0x44
		case "btnMain0":
			ShowPopup();
			// End:0x76
			break;
		// End:0x5C
		case "btnConfirm":
			HandleConfirm();
			// End:0x76
			break;
		// End:0x73
		case "btnDelete":
			ShowDeletePopoup();
			// End:0x76
			break;
		// End:0xFFFF
		default:
			break;
	}
}

event OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		// End:0x2D
		case l2uiTweenScript.TWEENEND:
			Tweenkle(int(param));
			// End:0x30
			break;
	}
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	Debug("OnSetFocus" @ a_WindowHandle.GetWindowName() @ string(bFocused));
	// End:0x15A
	if(bFocused)
	{
		switch(a_WindowHandle.GetWindowName())
		{
			// End:0x39
			case "ItemSlot_Wnd00":
				SetSelect(0);
				return;
			case "ItemSlot_Wnd01":
				SetSelect(1);
				return;
			case "ItemSlot_Wnd02":
				SetSelect(2);
				return;
			case "ItemSlot_Wnd03":
				SetSelect(3);
				return;
		}
		switch(a_WindowHandle.GetParentWindowName())
		{
			case "ItemSlot_Wnd00":
				SetSelect(0);
				return;
			case "ItemSlot_Wnd01":
				SetSelect(1);
				return;
			case "ItemSlot_Wnd02":
				SetSelect(2);
				return;
			case "ItemSlot_Wnd03":
				SetSelect(3);
				return;
		}
	}
}

event OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
	switch(a_WindowHandle)
	{
		// End:0x52
		case birthCircleInput_anitex:
			// End:0x4F
			if((HomunculusWndScript.Me.IsShowWindow() && Me.IsShowWindow()) && isRequested)
			{
				SummonRequest();
			}
			// End:0x55
			break;
	}
}

event OnHide()
{
	SetOnHide();
	isRequested = false;
}

function Show()
{
	local int i;

	// End:0x2C [Loop If]
	for(i = 0; i < homunListUIInfos.Length; i++)
	{
		SetCard(i);
	}
	Me.ShowWindow();
	Me.SetFocus();
	resultWnd.HideWindow();
	SetEffect("LineageEffect_br.br_e_lamp_deco_d", 50);
	TweenShow();
}

function Hide()
{
	Me.HideWindow();
}

function SetOnHide()
{
	birthCircleInput_anitex.Stop();
	SetDeselect();
	isRequested = false;
	SetEffect("", 50);
}

function SetPostion()
{
	Select_tex.SetAlpha(0);
	// End:0x21
	if(SelectedIndex == -1)
	{
		return;
	}
	Select_tex.SetAnchor(GetCardWndPath(SelectedIndex), "CenterCenter", "CenterCenter", 2, 2);
	Select_tex.SetAlpha(255, 0.50f);
	Select_tex.ShowWindow();
}

function HandleConfirm()
{
	resultWnd.HideWindow();
	ChkCanBuy();
}

function SetHomunculusData(HomunculusAPI.HomunculusData Data)
{
	local HomunculusAPI.HomunculusNpcData npcData;

	npcData = HomunculusWndScript.GetHomunculusNpcData(Data.Id);
	SetViewPortSetting(Data.Id);
	SetViewPort(npcData.NpcID);
	SetInfo(npcData.NpcID, Data.Type, Data.Level);
	resultWnd.ShowWindow();
	EffectViewportResult.SpawnEffect("LineageEffect2.ui_upgrade_succ");
}

function Handle_S_EX_SHOW_HOMUNCULUS_COUPON_UI()
{
	local UIPacket._S_EX_SHOW_HOMUNCULUS_COUPON_UI packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_SHOW_HOMUNCULUS_COUPON_UI(packet))
	{
		return;
	}
	// End:0x75
	if(HomunculusWndScript.Me.IsShowWindow())
	{
		// End:0x75
		if(HomunculusWndScript.homunculusWndBirthScript.isGachaState)
		{
			// End:0x75
			if(HomunculusWndScript.currState == HomunculusWndScript.type_State.birth)
			{
				return;
			}
		}
	}
	HomunculusWndScript.Me.ShowWindow();
	HomunculusWndScript.homunculusWndBirthScript.SetGachaState();
	HomunculusWndScript.SetState(HomunculusWndScript.type_State.birth);
}

function Handle_S_EX_SUMMON_HOMUNCULUS_COUPON_RESULT()
{
	local UIPacket._S_EX_SUMMON_HOMUNCULUS_COUPON_RESULT packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_SUMMON_HOMUNCULUS_COUPON_RESULT(packet))
	{
		return;
	}
	// End:0x47
	if(packet.Type == 1)
	{
		LastIdx = packet.nIdx;
		HandleShowResult();
		ChkCanBuy();
	}
	isRequested = false;
}

function Handle_S_EX_DELETE_HOMUNCLUS_DATA_RESULT()
{
	Debug("Handle_S_EX_DELETE_HOMUNCLUS_DATA_RESULT" @ string(Me.IsShowWindow()));
	// End:0x5B
	if(Me.IsShowWindow())
	{
		ChkCanBuy();
	}
}

function HandleShowResult()
{
	local int i;
	local array<HomunculusAPI.HomunculusData> homunculusDatas;

	// End:0x16
	if(! Me.IsShowWindow())
	{
		return;
	}
	homunculusDatas = HomunculusWndScript.API_GetHomunculusDatas();

	// End:0x79 [Loop If]
	for(i = 0; i < homunculusDatas.Length; i++)
	{
		if(homunculusDatas[i].idx == LastIdx)
		{
			SetHomunculusData(homunculusDatas[i]);
			return;
		}
	}
}

function SetInfo(int NpcID, int Type, int Level)
{
	local string NpcName;

	NpcName = class'UIDATA_NPC'.static.GetNPCName(NpcID);
	txtResult0.SetText((((GetSystemString(88) $ ".") $ string(Level)) @ (GetGrade(Type))) @ NpcName);
	SetGrade(Type);
}

function SetGrade(int Type)
{
	switch(Type)
	{
		case 0:
			m_ObjectViewport.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.Homun_birthResultBG_01");
			break;
		case 1:
			m_ObjectViewport.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.Homun_birthResultBG_02");
			break;
		case 2:
			m_ObjectViewport.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.Homun_birthResultBG_03");
			break;
	}
}

function PlayRequestAnimation()
{
	local UIControlDialogAssets popupExpandScript;

	SetEffect("LineageEffect.d_ar_attractcubic_ta", 125);
	birthCircleInput_anitex.Stop();
	birthCircleInput_anitex.Play();
	isRequested = true;
	popupExpandScript = HomunculusWndScript.GetPopupExpandScript();
	popupExpandScript.Hide();
	btnMain0.DisableWindow();
}

function SummonRequest()
{
	SetEffect("LineageEffect_br.br_e_lamp_deco_d", 50);
	API_C_EX_SUMMON_HOMUNCULUS_COUPON(homunListUIInfos[SelectedIndex].CostItem.Id);
}

function HandleItemListner(optional ItemInfo iInfo, optional int Index)
{
	// End:0x1F
	if(! HomunculusWndScript.Me.IsShowWindow())
	{
		return;
	}
	SetCard(Index);
	ChkCanBuy();
}

function bool CompareFunc(ItemInfo iInfo, int Index)
{
	return homunListUIInfos[Index].CostItem.Id == iInfo.Id.ClassID;
}

function TweenStart()
{
	Me.SetTimer(9, 3000);
	birthCircle_tex.SetAlpha(0);
	TweenAdd(240, 0, 3000, l2uiTweenScript.easeType.OUT_BOUNCE);
}

function TweenHide()
{
	birthCircle_tex.SetAlpha(240);
	TweenAdd(-100, 1, 2000, l2uiTweenScript.easeType.IN_STRONG);
}

function TweenShow()
{
	birthCircle_tex.SetAlpha(140);
	TweenAdd(100, 2, 2000, l2uiTweenScript.easeType.OUT_STRONG);
}

function Tweenkle(int Id)
{
	switch(Id)
	{
		// End:0x14
		case 0:
			TweenHide();
			// End:0x32
			break;
		// End:0x21
		case 1:
			TweenShow();
			// End:0x32
			break;
		// End:0x2F
		case 2:
			TweenHide();
			// End:0x32
			break;
	}
}

function SetEffect(string EffectName, optional int dist)
{
	EffectViewport.SetCameraDistance(float(dist));
	EffectViewport.ShowWindow();
	EffectViewport.SpawnEffect(EffectName);
}

function ShowPopup()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = HomunculusWndScript.GetPopupExpandScript();
	popupExpandScript.SetDialogDesc(GetSystemString(13558));
	popupExpandScript.SetUseNeedItem(true);
	popupExpandScript.StartNeedItemList(2);
	popupExpandScript.AddNeedItemClassID(homunListUIInfos[SelectedIndex].CostItem.Id, homunListUIInfos[SelectedIndex].CostItem.Amount);
	popupExpandScript.AddNeedItemClassID(57, homunListUIInfos[SelectedIndex].Fee);
	popupExpandScript.SetItemNum(1);
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = PlayRequestAnimation;
}

function ShowDeletePopoup()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = HomunculusWndScript.GetPopupExpandScript();
	popupExpandScript.SetUseBuyItem(false);
	popupExpandScript.SetUseNeedItem(false);
	popupExpandScript.SetUseNumberInput(false);
	popupExpandScript.SetDialogDesc(GetSystemString(13377));
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = DeleteRequest;
}

function DeleteRequest()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = HomunculusWndScript.GetPopupExpandScript();
	popupExpandScript.Hide();
	HomunculusWndScript.API_C_EX_DELETE_HOMUNCULUS_DATA(LastIdx);
	resultWnd.HideWindow();
}

function SetSelect(int Index)
{
	SelectedIndex = Index;
	ChkCanBuy();
	SetPostion();
}

function SetDeselect()
{
	SelectedIndex = -1;
	btnMain0.DisableWindow();
	Select_tex.HideWindow();
}

function array<HomunculusAPI.HomunListUIInfo> API_GetHomunculusGatchaList()
{
	return class'HomunculusAPI'.static.GetHomunculusGatchaList();
}

function API_C_EX_SUMMON_HOMUNCULUS_COUPON(int nItemID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SUMMON_HOMUNCULUS_COUPON packet;

	packet.nItemID = nItemID;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_SUMMON_HOMUNCULUS_COUPON(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SUMMON_HOMUNCULUS_COUPON, stream);
	SetSelect(SelectedIndex);
}

function string GetGrade(int Type)
{
	switch(Type)
	{
		// End:0x1A
		case 0:
			return GetSystemString(441);
			// End:0x44
			break;
		// End:0x2D
		case 1:
			return GetSystemString(3290);
			// End:0x44
			break;
		// End:0x41
		case 2:
			return GetSystemString(13336);
			// End:0x44
			break;
	}
	return "";
}

function SetViewPort(int NpcID)
{
	m_ObjectViewport.SetSpawnDuration(0.10f);
	m_ObjectViewport.SetNPCInfo(NpcID);
	m_ObjectViewport.SpawnNPC();
	m_ObjectViewport.PlayAnimation(HomunculusWndScript.type_State.non);
}

function SetViewPortSetting(int Id)
{
	local float tmpScale;
	local int OffsetY;

	switch(Id)
	{
		case 0:
			tmpScale = 0.50f;
			OffsetY = -1;
			break;
		case 1:
		case 2:
		case 3:
			tmpScale = 1.20f;
			OffsetY = -11;
			// End:0x1B2
			break;
		case 4:
		case 5:
		case 6:
			tmpScale = 1.50f;
			OffsetY = -1;
			break;
		case 7:
		case 8:
		case 9:
			tmpScale = 0.90f;
			OffsetY = -1;
			break;
		case 10:
		case 11:
		case 12:
			tmpScale = 1.70f;
			OffsetY = -8;
			break;
		case 13:
		case 14:
		case 15:
			tmpScale = 1.10f;
			OffsetY = -1;
			// End:0x1B2
			break;
		case 16:
		case 17:
		case 18:
			tmpScale = 1.40f;
			OffsetY = -3;
			break;
		case 19:
		case 20:
		case 21:
			tmpScale = 1.60f;
			OffsetY = -1;
			break;
		case 22:
		case 23:
		case 24:
			tmpScale = 1.50f;
			OffsetY = -5;
			break;
		case 25:
		case 26:
		case 27:
			tmpScale = 1.20f;
			OffsetY = 0;
			break;
		case 28:
		case 29:
		case 30:
			tmpScale = 1.20f;
			OffsetY = -1;
			break;
	}
	m_ObjectViewport.SetCharacterScale(tmpScale);
	m_ObjectViewport.SetCharacterOffsetY(OffsetY);
}

function bool GetCanBuy()
{
	local array<ItemInfo> iInfos;

	// End:0x11
	if(SelectedIndex == -1)
	{
		return false;
	}
	class'UIDATA_INVENTORY'.static.FindItemByClassID(homunListUIInfos[SelectedIndex].CostItem.Id, iInfos);
	// End:0x48
	if(iInfos.Length == 0)
	{
		return false;
	}
	return ((iInfos[0].ItemNum >= homunListUIInfos[SelectedIndex].CostItem.Amount) && needItemLists[SelectedIndex].GetCanBuy()) && homunculusWndMainListScript.GetEmptySlot() != -1;
}

function ChkCanBuy()
{
	if(GetCanBuy() && ! isRequested)
	{
		btnMain0.EnableWindow();		
	}
	else
	{
		btnMain0.DisableWindow();
	}
}

function string GetGradeTextureByRank(int ProductRank)
{
	switch(ProductRank)
	{
		// End:0x39
		case 0:
			return "L2UI_EPIC.HomunCulusWnd.GachaCardBG_Gray";
			// End:0xD6
			break;
		// End:0x6C
		case 1:
			return "L2UI_EPIC.HomunCulusWnd.GachaCardBG_Green";
			// End:0xD6
			break;
		// End:0x9E
		case 2:
			return "L2UI_EPIC.HomunCulusWnd.GachaCardBG_Red";
			// End:0xD6
			break;
		// End:0xD3
		case 3:
			return "L2UI_EPIC.HomunCulusWnd.GachaCardBG_Yellow";
			// End:0xD6
			break;
		// End:0xFFFF
		default:
			break;
	}
	return "";
}

function TextureHandle GetTexturehandleGradeBG(int Num)
{
	return GetTextureHandle(GetCardWndPath(Num) $ ".Grade_Tex");
}

function WindowHandle GetCardWnd(int Num)
{
	return GetWindowHandle(GetCardWndPath(Num));
}

function ItemWindowHandle GetTexturehandleCraftSlot(int Num)
{
	return GetItemWindowHandle((GetCardWndPath(Num)) $ ".BMItem_ItemWnd");
}

function TextureHandle GetTextureRibbon(int Num)
{
	return GetTextureHandle((GetCardWndPath(Num)) $ ".Ribbon_Tex");
}

function TextBoxHandle GetTextBoxhandleBMItemMYNum(int Num)
{
	return GetTextBoxHandle((GetCardWndPath(Num)) $ ".BMItemNumber_Txt");
}

function TextBoxHandle GetTextItemName(int Num)
{
	return GetTextBoxHandle((GetCardWndPath(Num)) $ ".BMItemName_Txt");
}

function RichListCtrlHandle GetRichListCtrl(int Num)
{
	return GetRichListCtrlHandle(GetCardWndPath(Num) $ ".NeedItemRichListCtrl");
}

function string GetCardWndPath(int Num)
{
	return "HomunculusWnd." $ m_WindowName $ ".ItemSlot_Wnd0" $ string(Num);
}

function SetCard(int i)
{
	local ItemInfo iInfo;
	local array<ItemInfo> iInfos;
	local string tmpName;
	local Rect rectWnd;
	local INT64 myCardNum;

	GetCardWnd(i).ShowWindow();
	iInfo = GetItemInfoByClassID(homunListUIInfos[i].CostItem.Id);
	GetTexturehandleCraftSlot(i).ShowWindow();
	GetTexturehandleCraftSlot(i).Clear();
	GetTexturehandleCraftSlot(i).AddItem(iInfo);
	rectWnd = GetTextItemName(i).GetRect();
	tmpName = GetEllipsisString(iInfo.Name, rectWnd.nWidth, "x" $ string(homunListUIInfos[i].CostItem.Amount));
	GetTextItemName(i).SetText(tmpName);
	GetTexturehandleGradeBG(i).SetTexture(GetGradeTextureByRank(homunListUIInfos[i].Grade));
	class'UIDATA_INVENTORY'.static.FindItemByClassID(homunListUIInfos[i].CostItem.Id, iInfos);
	// End:0x157
	if(iInfos.Length == 0)
	{
		myCardNum = 0;		
	}
	else
	{
		myCardNum = iInfos[0].ItemNum;
	}
	GetTextBoxhandleBMItemMYNum(i).SetText(("(" $ string(myCardNum)) $ ")");
	// End:0x1D6
	if(myCardNum >= homunListUIInfos[i].CostItem.Amount)
	{
		GetTextBoxhandleBMItemMYNum(i).SetTextColor(getInstanceL2Util().BLUE01);		
	}
	else
	{
		GetTextBoxhandleBMItemMYNum(i).SetTextColor(getInstanceL2Util().Red);
	}
	// End:0x251
	if(homunListUIInfos[i].Event > 0)
	{
		GetTextureRibbon(i).SetTexture("L2UI_EPIC.HomunCulusWnd.Img_EventRibbon");		
	}
	else
	{
		GetTextureRibbon(i).HideWindow();
	}
}

function TweenAdd(int TargetAlpha, int Id, int Duration, L2UITween.easeType Type)
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = "HomunculusWnd." $ m_WindowName;
	tweenObjectData.Id = Id;
	tweenObjectData.Target = birthCircle_tex;
	tweenObjectData.Duration = float(Duration);
	tweenObjectData.Alpha = float(TargetAlpha);
	tweenObjectData.ease = Type;
	TweenStop();
	l2uiTweenScript.AddTweenObject(tweenObjectData);
	curTweenID = Id;
}

function TweenStop()
{
	// End:0x3A
	if(curTweenID != -1)
	{
		l2uiTweenScript.StopTween("HomunculusWnd." $ m_WindowName, curTweenID);
	}
	curTweenID = -1;
}

function string GetEllipsisString(string Str, int MaxWidth, string numString)
{
	local string fixedString;
	local int nWidth, nHeight, textWidth, numStringWidth, numStringHeight;

	GetTextSizeDefault(numString, numStringWidth, numStringHeight);
	textWidth = MaxWidth;
	GetTextSizeDefault(Str $ "...", nWidth, nHeight);
	// End:0x63
	if((nWidth + numStringWidth) + 4 < textWidth)
	{
		return Str @ numString;
	}
	fixedString = DivideStringWithWidth(Str, (textWidth - numStringWidth) - 4);
	// End:0xA5
	if(fixedString != Str)
	{
		fixedString = fixedString $ "...";
	}
	return fixedString @ numString;
}

defaultproperties
{
}
