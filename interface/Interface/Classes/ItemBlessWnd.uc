//================================================================================
// ItemBlessWnd.
//================================================================================

class ItemBlessWnd extends UICommonAPI;

const TIMEPROGRESS= 600;
const TIMEPROGRESSAUTO = 400;
const SHAKEID_ME= 0;
const TWEENID_SLOT2= 1;
const TWEENID_SLOT1= 0;

enum typeState {
	non,
	READY,
	Progress,
	Result
};

var WindowHandle Me;
var string m_WindowName;
var ItemBlessWndSub itemBlessWndSubScript;
var InventoryWnd inventoryWndScript;
var ItemWindowHandle MaterialSlot1_ItemWnd;
var ItemWindowHandle MaterialSlot2_ItemWnd;
var ItemWindowHandle ArtifactItemSlot_ItemWnd;
var TextBoxHandle EnchantNotice_Txt;
var ButtonHandle Enchant_Btn;
var ButtonHandle Enchant_BtnAuto;
var ButtonHandle confirm_Btn;
var WindowHandle MaterialSlot1Wnd;
var WindowHandle MaterialSlot2Wnd;
var Rect Slot1Rect;
var Rect Slot2Rect;
var AnimTextureHandle EnchantProgressAnim;
var ProgressCtrlHandle EnchantProgress;
var TextureHandle MaterialSlot2_DropHighlight_Texure;
var EffectViewportWndHandle EnchantEffectViewport;
var ItemInfo itemInfoTarget;
var bool bSuccess;
var L2UITween l2uiTweenScript;
var TextBoxHandle scrollItemNum;
var CharacterViewportWindowHandle itemPeelEffect;
var bool IsAutoBlessing;
var bool IsAutoBlessStop;
var typeState CurrentState;
var bool bRequestBless;

private function InitViewport()
{
	itemPeelEffect.SetNPCInfo(19671);	
}

function Initialize ()
{
	local Rect RectMe;

	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	l2uiTweenScript = L2UITween(GetScript("L2UITween"));
	itemBlessWndSubScript = ItemBlessWndSub(GetScript("ItemBlessWndSub"));
	MaterialSlot1_ItemWnd = GetItemWindowHandle(m_WindowName $ ".MaterialSlot1Wnd.MaterialSlot1_ItemWnd");
	MaterialSlot2_ItemWnd = GetItemWindowHandle(m_WindowName $ ".MaterialSlot2Wnd.MaterialSlot2_ItemWnd");
	ArtifactItemSlot_ItemWnd = GetItemWindowHandle(m_WindowName $ ".ArtifactItemSlot_ItemWnd");
	MaterialSlot1Wnd = GetWindowHandle(m_WindowName $ ".MaterialSlot1Wnd");
	MaterialSlot2Wnd = GetWindowHandle(m_WindowName $ ".MaterialSlot2Wnd");
	EnchantNotice_Txt = GetTextBoxHandle(m_WindowName $ ".EnchantNotice_Txt");
	scrollItemNum = GetTextBoxHandle(m_WindowName $ ".ScrollItemNum");
	Enchant_Btn = GetButtonHandle(m_WindowName $ ".Enchant_Btn");
	Enchant_BtnAuto = GetButtonHandle(m_WindowName $ ".Enchant_BtnAuto");
	confirm_Btn = GetButtonHandle(m_WindowName $ ".Confirm_Btn");
	EnchantProgressAnim = GetAnimTextureHandle(m_WindowName $ ".EnchantProgressAnim");
	EnchantProgress = GetProgressCtrlHandle(m_WindowName $ ".EnchantProgress");
	MaterialSlot2_DropHighlight_Texure = GetTextureHandle(m_WindowName $ ".MaterialSlot2Wnd.MaterialSlot2_DropHighlight_Texure");
	EnchantEffectViewport = GetEffectViewportWndHandle(m_WindowName $ ".EnchantEffectViewport");
	itemPeelEffect = GetCharacterViewportWindowHandle(m_WindowName $ ".ChEffectViewport");
	RectMe = Me.GetRect();
	Slot1Rect = MaterialSlot1Wnd.GetRect();
	Slot1Rect.nX = Slot1Rect.nX - RectMe.nX;
	Slot1Rect.nY = Slot1Rect.nY - RectMe.nY;
	Slot2Rect = MaterialSlot2Wnd.GetRect();
	Slot2Rect.nX = Slot2Rect.nX - RectMe.nX;
	Slot2Rect.nY = Slot2Rect.nY - RectMe.nY;
	MakeItemListener();
	InitViewport();	
}

event OnRegisterEvent ()
{
	RegisterEvent(EV_CurrentServerTime);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_OPEN_BLESS_OPTION_SCROLL);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_BLESS_OPTION_PUT_ITEM);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_BLESS_OPTION_ENCHANT);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_BLESS_OPTION_CANCEL);
}

event OnEvent (int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_CurrentServerTime:
			bRequestBless = false;
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_OPEN_BLESS_OPTION_SCROLL:
			Handle_S_EX_OPEN_BLESS_OPTION_SCROLL();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_BLESS_OPTION_PUT_ITEM:
			Handle_S_EX_BLESS_OPTION_PUT_ITEM();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_BLESS_OPTION_ENCHANT:
			Handle_S_EX_BLESS_OPTION_ENCHANT();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_BLESS_OPTION_CANCEL:
			Handle_S_EX_BLESS_OPTION_CANCEL();
			break;
	}
}

event OnCallUCFunction (string funcName, string param)
{
	switch (funcName)
	{
		case l2uiTweenScript.TWEENEND:
			if (param == "1")
			{
				// End:0x6C
				if(IsAutoBlessing)
				{
					itemPeelEffect.ShowWindow();
					itemPeelEffect.SpawnEffect("LineageEffect2.ui_openbox");
				}
				API_C_EX_BLESS_OPTION_ENCHANT(GetItemInfo1().Id.ServerID);
			}
			break;
	}
}

event OnLoad ()
{
	SetClosingOnESC();
	Initialize();
}

event OnHide ()
{
	IsAutoBlessing = false;
	IsAutoBlessStop = false;
	API_C_EX_BLESS_OPTION_CANCEL();
	// End:0x4C
	if(DialogIsMine() && class'DialogBox'.static.Inst().m_hOwnerWnd.IsShowWindow())
	{
		DialogHide();
	}
}

event OnDropItem (string strTarget, ItemInfo Info, int X, int Y)
{
	if ( Info.DragSrcName != "ItemBlessWndSubWnd_Item1" )
	{
		return;
	}
	SetItemInfo(Info);
}

function SetItemInfo (ItemInfo iInfo)
{
	itemInfoTarget = iInfo;
	API_C_EX_BLESS_OPTION_PUT_ITEM(iInfo.Id.ServerID);
}

event OnShow ()
{
	if ( IsPlayerOnWorldRaidServer() )
	{
		AddSystemMessage(4047);
		Me.HideWindow();
		return;
	}
	itemPeelEffect.SpawnNPC();
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	SetState(non);
	itemBlessWndSubScript.Me.ShowWindow();
	itemBlessWndSubScript.Refresh();
	Me.SetFocus();
}

event OnClickButton (string Name)
{
	switch (Name)
	{
		case "Enchant_Btn":
			IsAutoBlessing = false;
			HandleNext();
			break;
		case "Enchant_BtnAuto":
			HandleEnchant_BtnAuto();
			break;
		case "Confirm_Btn":
			HandleConfirm();
			break;
	}
}

private function HandleShowDialogAuto()
{
	local ItemInfo iInfo;

	iInfo = GetItemInfo0();
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(13788), iInfo.Name, MakeCostStringINT64(iInfo.ItemNum)), string(self), 340);
	class'DialogBox'.static.Inst().AnchorToOwner(0, 170);
	class'DialogBox'.static.Inst().DelegateOnCancel = DialogResultCancel;
	class'DialogBox'.static.Inst().DelegateOnOK = DialogResultOKAuto;
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	itemBlessWndSubScript.m_hOwnerWnd.HideWindow();	
}

function DialogResultOKAuto()
{
	itemBlessWndSubScript.m_hOwnerWnd.ShowWindow();
	IsAutoBlessing = true;
	scrollItemNum.SetText((GetSystemString(5027) @ ":") @ MakeCostStringINT64(GetItemInfo0().ItemNum));
	scrollItemNum.ShowWindow();
	HandleNext();	
}

function DialogResultCancel()
{
	itemBlessWndSubScript.m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	IsAutoBlessing = false;	
}

private function HandleEnchant_BtnAuto()
{
	Debug("HandleEnchant_BtnAuto" @ string(IsAutoBlessStop) @ string(IsAutoBlessing) @ string(bRequestBless) @ string(CurrentState));
	// End:0x4F
	if(IsAutoBlessStop)
	{
		return;
	}
	// End:0x62
	if(bRequestBless)
	{
		IsAutoBlessStop = true;
		return;
	}
	// End:0x7A
	if(CurrentState == typeState.Result/*3*/)
	{
		HandleNextOnResult();
		return;
	}
	// End:0x94
	if(CurrentState == typeState.Progress/*2*/)
	{
		SetState(typeState.READY);
		return;
	}
	HandleShowDialogAuto();	
}

function API_C_EX_BLESS_OPTION_PUT_ITEM (int sID)
{
	local array<byte> stream;
	local UIPacket._C_EX_BLESS_OPTION_PUT_ITEM packet;

	packet.nPutItemSId = sID;
	if ( !Class'UIPacket'.static.Encode_C_EX_BLESS_OPTION_PUT_ITEM(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_BLESS_OPTION_PUT_ITEM,stream);
}

function API_C_EX_BLESS_OPTION_ENCHANT (int sID)
{
	local array<byte> stream;
	local UIPacket._C_EX_BLESS_OPTION_ENCHANT packet;

	bRequestBless = true;
	packet.nPuItemSId = sID;
	if ( !Class'UIPacket'.static.Encode_C_EX_BLESS_OPTION_ENCHANT(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_BLESS_OPTION_ENCHANT,stream);
}

function API_C_EX_BLESS_OPTION_CANCEL ()
{
	local array<byte> stream;

	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_BLESS_OPTION_CANCEL,stream);
}

function bool API_GetEnchantBlessScrollData(int ClassID, out EnchantBlessScrollUIData o_data)
{
	return class'UIDATA_ITEM'.static.GetEnchantBlessScrollData(ClassID, o_data);	
}

function Handle_S_EX_OPEN_BLESS_OPTION_SCROLL ()
{
	local ItemInfo tItemInfo;
	local UIPacket._S_EX_OPEN_BLESS_OPTION_SCROLL packet;
	local EnchantBlessScrollUIData blessScrollUIData;

	if ( !Class'UIPacket'.static.Decode_S_EX_OPEN_BLESS_OPTION_SCROLL(packet) )
	{
		return;
	}
	if ( FindItem(packet.nScrollItemClassID, tItemInfo))
	{
		// End:0x4F
		if(! API_GetEnchantBlessScrollData(packet.nScrollItemClassID, blessScrollUIData))
		{
			return;
		}
		tItemInfo.bShowCount = true;
		MaterialSlot1_ItemWnd.Clear();
		MaterialSlot1_ItemWnd.AddItem(tItemInfo);
		PlaySound("ItemSound2.smelting.Smelting_dragin");
		GetProbability_Txt().SetText((GetSystemString(13938) $ ":") @ class'L2Util'.static.Inst().CutFloatIntByString(string(blessScrollUIData.Probability)));
		itemBlessWndSubScript.SetGroupIDs(blessScrollUIData.EnchantableGroupIDs);
		Me.ShowWindow();
	}
}

function Handle_S_EX_BLESS_OPTION_PUT_ITEM ()
{
	local ItemInfo emptyInfo;
	local UIPacket._S_EX_BLESS_OPTION_PUT_ITEM packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_BLESS_OPTION_PUT_ITEM(packet) )
	{
		return;
	}
	if ( packet.bResult == 1 )
	{
		MakeShakeWeekMaterialSlot2Wnd();
		MaterialSlot2_ItemWnd.Clear();
		MaterialSlot2_ItemWnd.AddItem(itemInfoTarget);
		PlaySound("ItemSound2.smelting.Smelting_dragin");
		if ( !IsEmptyScroll() )
		{
			SetState(READY);
		}
	}
	itemInfoTarget = emptyInfo;
}

function Handle_S_EX_BLESS_OPTION_ENCHANT ()
{
	local UIPacket._S_EX_BLESS_OPTION_ENCHANT packet;
	local string soundString;

	if ( !Class'UIPacket'.static.Decode_S_EX_BLESS_OPTION_ENCHANT(packet) )
	{
		return;
	}
	bSuccess = packet.cResult == 1;
	bRequestBless = false;
	switch (packet.cResult)
	{
		case 0:
			soundString = "ItemSound3.enchant_fail";
			break;
		case 1:
			soundString = "ItemSound3.enchant_success";
			break;
		case 2:
			AddSystemMessage(13277);
			Me.HideWindow();
			return;
			break;
	}
	PlaySound(soundString);
	SetState(Result);
}

function Handle_S_EX_BLESS_OPTION_CANCEL ()
{
	Me.HideWindow();
}

function HandleNext ()
{
	switch (CurrentState)
	{
		case non:
			SetState(READY);
			break;
		case READY:
			SetState(Progress);
			break;
		case Progress:
			SetState(READY);
			break;
		case Result:
			HandleNextOnResult();
			break;
	}
}

private function HandleNextOnResult()
{
	local ItemInfo itemTarget;
	local ItemInfo itemResult;
	local ItemInfo scrollItem;

	scrollItem = GetItemInfo0();
	itemTarget = GetItemInfo1();
	itemResult = GetItemInfoResult();
	Debug(string(scrollItem.Id.ClassID) @ string(itemTarget.Id.ClassID) @ string(itemResult.Id.ClassID));
	if ( bSuccess )
	{
		SetState(non);
	} else {
		if ( IsEmptyScroll() )
		{
			SetState(non);
		} else {
			SetState(READY);
		}
	}
}

function HandleExit()
{
	Debug("HandleExit" @ string(IsAutoBlessing));
	// End:0x54
	if(DialogIsMine() && class'DialogBox'.static.Inst().m_hOwnerWnd.IsShowWindow())
	{
		DialogHide();
		return;
	}
	// End:0x66
	if(IsAutoBlessing)
	{
		HandleEnchant_BtnAuto();		
	}
	else
	{
		switch(CurrentState)
		{
			// End:0x7D
			case typeState.Progress/*2*/:
				SetState(typeState.READY);
				// End:0x89
				break;
			// End:0xFFFF
			default:
				MeHideWindow();
				// End:0x89
				break;
				break;
		}
	}	
}

function MeHideWindow ()
{
	SetState(non);
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
}

function HandleConfirm ()
{
	confirm_Btn.HideWindow();
	HandleNextOnResult();
}

function bool IsEmptyScroll ()
{
	return GetItemInfo0().ItemNum <= 0;
}

function bool IsEmptyTarget ()
{
	return GetItemInfo1().ItemNum <= 0;
}

function SetState (typeState State)
{
	switch (State)
	{
		case non:
			SetStateNon();
			break;
		case READY:
			SetStateReady();
			break;
		case Progress:
			setStateProgress();
			break;
		case Result:
			SetResult();
			break;
	}
	CurrentState = State;
	itemBlessWndSubScript.SetState();
	SetHighLight();
	SetEnchantNotice();
	SetEnchantBtn();
}

function SetStateNon()
{
	l2uiTweenScript.StopTween(m_WindowName,0);
	l2uiTweenScript.StopTween(m_WindowName,1);
	l2uiTweenScript.StopShake(m_WindowName,0);
	MaterialSlot2_ItemWnd.Clear();
	ArtifactItemSlot_ItemWnd.Clear();
	MaterialSlot1Wnd.ShowWindow();
	MaterialSlot2Wnd.ShowWindow();
	MaterialSlot1Wnd.MoveC(Slot1Rect.nX,Slot1Rect.nY);
	MaterialSlot2Wnd.MoveC(Slot2Rect.nX,Slot2Rect.nY);
	MaterialSlot2Wnd.SetAlpha(255);
	EnchantProgress.Stop();
	EnchantProgress.SetPos(0);
	EnchantProgressAnim.HideWindow();
	EnchantProgressAnim.Stop();
	scrollItemNum.HideWindow();
	IsAutoBlessing = false;	
}

function SetStateReady()
{
	ArtifactItemSlot_ItemWnd.Clear();
	EnchantProgress.SetPos(0);
	EnchantProgress.Reset();
	EnchantProgress.Stop();
	EnchantProgressAnim.HideWindow();
	EnchantProgressAnim.Stop();
	l2uiTweenScript.StopTween(m_WindowName, 0);
	l2uiTweenScript.StopTween(m_WindowName, 1);
	l2uiTweenScript.StopShake(m_WindowName, 0);
	MaterialSlot1Wnd.ShowWindow();
	MaterialSlot2Wnd.ShowWindow();
	MaterialSlot1Wnd.MoveC(Slot1Rect.nX, Slot1Rect.nY);
	MaterialSlot2Wnd.MoveC(Slot2Rect.nX, Slot2Rect.nY);
	scrollItemNum.HideWindow();
	IsAutoBlessing = false;
}

private function setStateProgress()
{
	PlaySound("ItemSound3.enchant_process");
	MaterialSlot2Wnd.SetAlpha(255);
	Debug("SetStateProgress" @ string(IsAutoBlessing));
	EnchantProgressAnim.SetLoopCount(1);
	// End:0x98
	if(IsAutoBlessing)
	{
		EnchantProgress.SetProgressTime(TIMEPROGRESSAUTO - 100);
		EnchantProgressAnim.HideWindow();		
	}
	else
	{
		EnchantProgress.SetProgressTime(TIMEPROGRESS - 100);
		EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Loading_01");
		EnchantProgressAnim.Stop();
		EnchantProgressAnim.Play();
		EnchantProgressAnim.ShowWindow();
	}
	EnchantProgress.Start();
	MakeProgressTween();
}

private function SetRetryEnchantAuto()
{
	l2UITweenScript.StopTween(m_WindowName, 0);
	l2UITweenScript.StopTween(m_WindowName, 1);
	l2UITweenScript.StopShake(m_WindowName, 0);
	MaterialSlot1Wnd.MoveC(Slot1Rect.nX, Slot1Rect.nY);
	MaterialSlot2Wnd.MoveC(Slot2Rect.nX, Slot2Rect.nY);
	EnchantProgress.SetPos(0);
	EnchantProgress.Reset();
	EnchantProgress.Stop();
	EnchantProgress.Start();
	MakeProgressTween();	
}

private function ResetScrollNum()
{
	local ItemInfo scrolliInfo;

	scrolliInfo = GetItemInfo0();
	scrolliInfo.ItemNum = scrolliInfo.ItemNum - 1;
	scrollItemNum.SetText(GetSystemString(5027) @ ":" @ MakeCostStringINT64(scrolliInfo.ItemNum));
	MaterialSlot1_ItemWnd.SetItem(0, scrolliInfo);	
}

function SetResult ()
{
	local ItemInfo resultItem;

	resultItem = GetItemInfo1();
	// End:0x26
	if(IsAutoBlessing || IsAutoBlessStop)
	{
		ResetScrollNum();
	}
	if (bSuccess)
	{
		confirm_Btn.ShowWindow();
		resultItem.IsBlessedItem = true;
		MakeShakeMe();
	}
	else
	{
		// End:0x88
		if((IsAutoBlessing && GetItemInfo0().ItemNum > 0) && ! IsAutoBlessStop)
		{
			SetRetryEnchantAuto();
			return;
		}
	}
	// End:0x9C
	if(GetItemInfo0().ItemNum == 1)
	{
	}
	IsAutoBlessStop = false;
	EnchantProgressAnim.HideWindow();
	ArtifactItemSlot_ItemWnd.Clear();
	ArtifactItemSlot_ItemWnd.AddItem(resultItem);
	MaterialSlot1Wnd.HideWindow();
	MaterialSlot2Wnd.HideWindow();
	playEffectViewPort(bSuccess);
}

function SetEnchantNotice ()
{
	local int stringNum;

	switch (CurrentState)
	{
		case non:
			if ( IsEmptyScroll() )
			{
				stringNum = 13389;
				itemBlessWndSubScript.DescriptionMsgWnd.ShowWindow();
			} else {
				stringNum = 13385;
			}
			break;
		case READY:
			stringNum = 13386;
			break;
		case Progress:
			stringNum = 13386;
			break;
		case Result:
			if ( bSuccess )
			{
				stringNum = 13387;
			}
			else if(IsAutoBlessing)
			{
				stringNum = 14242;
			}
			else
			{
				stringNum = 13388;
			}
			break;
	}
	EnchantNotice_Txt.SetText(GetSystemString(stringNum));
}

function SetEnchantBtn ()
{
	confirm_Btn.HideWindow();
	switch (CurrentState)
	{
		case non:
			Enchant_Btn.DisableWindow();
			Enchant_BtnAuto.DisableWindow();
			Enchant_Btn.SetButtonName(13384);
			Enchant_BtnAuto.SetButtonName(14241);
			break;
		case READY:
			Enchant_Btn.EnableWindow();
			Enchant_BtnAuto.EnableWindow();
			Enchant_Btn.SetButtonName(13384);
			Enchant_BtnAuto.SetButtonName(14241);
			break;
		case Progress:
			// End:0xF2
			if(IsAutoBlessing)
			{
				Enchant_BtnAuto.EnableWindow();
				Enchant_BtnAuto.SetButtonName(141);
				Enchant_Btn.DisableWindow();				
			}
			else
			{
				Enchant_Btn.EnableWindow();
				Enchant_Btn.SetButtonName(141);
				Enchant_BtnAuto.DisableWindow();
			}
			break;
		case Result:
			if ( bSuccess )
			{
				confirm_Btn.ShowWindow();
				Enchant_Btn.DisableWindow();
				Enchant_BtnAuto.DisableWindow();
			}
			else if(IsAutoBlessing)
			{
				Enchant_BtnAuto.EnableWindow();
				Enchant_BtnAuto.SetButtonName(141);
			}
			else
			{
				Enchant_Btn.EnableWindow();
				Enchant_Btn.SetButtonName(3135);
			}
			break;
	}
}

function bool FindItem (int ClassID, out ItemInfo oItemInfo)
{
	local array<ItemInfo> itemInfoArray;

	Class'UIDATA_INVENTORY'.static.FindItemByClassID(ClassID,itemInfoArray);
	itemInfoArray[0].bShowCount = True;
	oItemInfo = itemInfoArray[0];
	return itemInfoArray.Length > 0;
}

function ItemInfo GetItemInfo0 ()
{
	local ItemInfo iInfo;

	MaterialSlot1_ItemWnd.GetItem(0,iInfo);
	return iInfo;
}

function ItemInfo GetItemInfo1 ()
{
	local ItemInfo iInfo;

	MaterialSlot2_ItemWnd.GetItem(0,iInfo);
	return iInfo;
}

function ItemInfo GetItemInfoResult ()
{
	local ItemInfo iInfo;

	ArtifactItemSlot_ItemWnd.GetItem(0,iInfo);
	return iInfo;
}

function TextBoxHandle GetProbability_Txt()
{
	return GetTextBoxHandle(m_hOwnerWnd.GetWindowName() $ "." $ "probability_Txt");	
}

function MakeProgressTween ()
{
	local L2UITween.TweenObject tweenObj0;

	tweenObj0.Owner = m_WindowName;
	tweenObj0.Id = 0;
	tweenObj0.Target = MaterialSlot1Wnd;
	// End:0x48
	if(IsAutoBlessing)
	{
		tweenObj0.Duration = TIMEPROGRESSAUTO;		
	}
	else
	{
		tweenObj0.Duration = TIMEPROGRESS;
	}
	tweenObj0.MoveX = 145.0;
	tweenObj0.ease = l2uiTweenScript.easeType.IN_STRONG;
	l2uiTweenScript.AddTweenObject(tweenObj0);
	tweenObj0.Id = 1;
	tweenObj0.Target = MaterialSlot2Wnd;
	tweenObj0.MoveX =	-tweenObj0.MoveX;
	tweenObj0.ease = l2uiTweenScript.easeType.IN_STRONG;
	l2uiTweenScript.AddTweenObject(tweenObj0);
}

function MakeShakeMe ()
{
	local L2UITween.ShakeObject shakeObj;

	shakeObj.Owner = m_WindowName;
	shakeObj.Target = Me;
	shakeObj.Duration = TIMEPROGRESS;
	shakeObj.shakeSize = 4.0;
	shakeObj.Direction = l2uiTweenScript.directionType.small;
	shakeObj.Id = 0;
	l2uiTweenScript.StartShakeObject(shakeObj);
}

function MakeShakeWeekMaterialSlot2Wnd ()
{
	local L2UITween.TweenObject tweenObj0;

	MaterialSlot2Wnd.SetAlpha(0);
	tweenObj0.Owner = m_WindowName;
	tweenObj0.Id = 19;
	tweenObj0.Target = MaterialSlot2Wnd;
	tweenObj0.Duration = 500.0;
	tweenObj0.Alpha = 255.0;
	tweenObj0.ease = l2uiTweenScript.easeType.OUT_STRONG;
	l2uiTweenScript.AddTweenObject(tweenObj0);
}

function playEffectViewPort (bool bSuccess)
{
	local Vector offset;
	local string effectPath;

	if ( bSuccess )
	{
		EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
		EnchantProgressAnim.SetLoopCount(1);
		EnchantProgressAnim.Stop();
		EnchantProgressAnim.Play();
		EnchantProgressAnim.ShowWindow();
	} else {
		effectPath = "LineageEffect2.ui_upgrade_fail";
		offset.X = 13.0;
		offset.Y = -1.0;
		EnchantEffectViewport.SetScale(0.89999998);
		EnchantEffectViewport.SetCameraDistance(300.0);
		EnchantEffectViewport.SetOffset(offset);
		EnchantEffectViewport.SpawnEffect(effectPath);
	}
}

function SetHighLight ()
{
	if ( IsEmptyTarget() &&	!IsEmptyScroll() )
	{
		MaterialSlot2_DropHighlight_Texure.ShowWindow();
	} else {
		MaterialSlot2_DropHighlight_Texure.HideWindow();
	}
}

function MakeItemListener()
{
	local L2UIInventoryObject iObject;

	iObject = AddItemListener();
	iObject.DelegateOnCompare = CompareScroll;
	iObject.DelegateOnAddItem = UpdateItem;
	iObject.DelegateOnUpdateItem = UpdateItem;
	iObject.DelegateOnDeletedItem = DeletedItem;
}

function bool CompareScroll(optional ItemInfo iInfo, optional int Index)
{
	if(!Me.IsShowWindow())
	{
		return false;
	}
	return iInfo.Id.ClassID == GetItemInfo0().Id.ClassID;
}

function DeletedItem(optional ItemInfo iInfo, optional int Index)
{
	MaterialSlot1_ItemWnd.Clear();
	if ( CurrentState != Result )
	{
		SetState(non);
	}
}

function UpdateItem(optional ItemInfo iInfo, optional int Index)
{
	MaterialSlot1_ItemWnd.Clear();
	iInfo.bShowCount = true;
	MaterialSlot1_ItemWnd.AddItem(iInfo);
}

function AddItem(optional ItemInfo iInfo)
{
	MaterialSlot1_ItemWnd.Clear();
	iInfo.bShowCount = true;
	MaterialSlot1_ItemWnd.AddItem(iInfo);
}

function OnReceivedCloseUI()
{
	HandleExit();
}

defaultproperties
{
}
