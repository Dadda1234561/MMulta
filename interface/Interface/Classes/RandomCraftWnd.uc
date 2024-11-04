//================================================================================
// RandomCraftWnd.
//================================================================================

class RandomCraftWnd extends UICommonAPI;

const Dialog_RandomCraft = 1;
const Dialog_Lock = 2;
const Dialog_Refresh = 3;
const TIME_ID = 1100021;
const TIME_DELAY = 70;

var WindowHandle Me;

var WindowHandle Confirm_Wnd;
var WindowHandle ConfirmNeedItemDialogWnd;
var WindowHandle ConfirmAskDialogWnd;
var TextureHandle Exclamation_Tex;
var string m_WindowName;
var ItemWindowHandle Result_ItemWnd;

var WindowHandle Result_WINDOW;
var TextBoxHandle Result_ItemName_text;
var WindowHandle ConfirmCraftCancelDialogWnd;
var TextureHandle RewardSlotDisable_Tex;
var WindowHandle RandomSlotGroup01_Wnd;
var EffectViewportWndHandle Result_EffectViewport;
var EffectViewportWndHandle Cancle_EffectViewport;
var ProgressCtrlHandle RandomCraftWnd_Progress;
var WindowHandle RandomSlotGroupDisable_Wnd;
var TextBoxHandle RandomSlotGroupDisable_Txt;
var TextureHandle RewardRandomItem_Tex;
var ButtonHandle ItemListReflash_Btn;
var ButtonHandle HelpReward_Button;
var ButtonHandle RandomCraft_Btn;
var ItemWindowHandle RewardSlot_ItemWnd;
var TextBoxHandle ItemPointNum_TextBox;
var TextBoxHandle ItemPointGaugeMax_Txt;
var StatusBarHandle ItemPointNum_StatusBar;
var TextBoxHandle Description_Text;
var TextureHandle ItemPointIcon_tex;
var UIControlNeedItemDialog needItemDialogScript;
var UIControlBasicDialog askDialogScript;
var UIPacket._S_EX_CRAFT_RANDOM_INFO Craft_Ramdom_Info_PacketForUpdate;
var int nCurrentlockCount;
var int nCurrentCraftPoint;
var bool bItemWasReady;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_CRAFT_RANDOM_LOCK_SLOT);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_CRAFT_RANDOM_REFRESH);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_CRAFT_RANDOM_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_CRAFT_RANDOM_MAKE);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	initUI();
}

function Initialize()
{
	Me = GetWindowHandle("RandomCraftWnd");
	Confirm_Wnd = GetWindowHandle("RandomCraftWnd.Confirm_Wnd");
	ConfirmNeedItemDialogWnd = GetWindowHandle("RandomCraftWnd.Confirm_Wnd.ConfirmNeedItemDialogWnd");
	ConfirmAskDialogWnd = GetWindowHandle("RandomCraftWnd.Confirm_Wnd.ConfirmAskDialogWnd");
	RandomCraftWnd_Progress = GetProgressCtrlHandle("RandomCraftWnd.ConfirmCraftCancelDialogWnd.RandomCraftWnd_Progress");
	RandomSlotGroupDisable_Wnd = GetWindowHandle("RandomCraftWnd.RandomSlotGroupDisable_Wnd");
	RandomSlotGroupDisable_Txt = GetTextBoxHandle("RandomCraftWnd.RandomSlotGroupDisable_Wnd.RandomSlotGroupDisable_Txt");
	Result_WINDOW = GetWindowHandle("RandomCraftWnd.Confirm_Wnd.Result_WINDOW");
	ConfirmCraftCancelDialogWnd = GetWindowHandle("RandomCraftWnd.Confirm_Wnd.ConfirmCraftCancelDialogWnd");
	Cancle_EffectViewport = GetEffectViewportWndHandle("RandomCraftWnd.Confirm_Wnd.ConfirmCraftCancelDialogWnd.Cancle_EffectViewport");
	Result_EffectViewport = GetEffectViewportWndHandle("RandomCraftWnd.Result_EffectViewport");
	RewardRandomItem_Tex = GetTextureHandle("RandomCraftWnd.Confirm_Wnd.ConfirmCraftCancelDialogWnd.RewardRandomItem_Tex");
	Result_ItemWnd = GetItemWindowHandle("RandomCraftWnd.Confirm_Wnd.Result_WINDOW.Result_ItemWnd");
	RewardSlotDisable_Tex = GetTextureHandle("RandomCraftWnd.RewardSlotDisable_Tex");
	Result_ItemName_text = GetTextBoxHandle("RandomCraftWnd.Confirm_Wnd.Result_WINDOW.Result_ItemName_text");
	Description_Text = GetTextBoxHandle("RandomCraftWnd.Description_Win.Description_text");
	ItemListReflash_Btn = GetButtonHandle("RandomCraftWnd.ItemListReflash_Btn");
	HelpReward_Button = GetButtonHandle("RandomCraftWnd.HelpReward_Button");
	RandomCraft_Btn = GetButtonHandle("RandomCraftWnd.RandomCraft_Btn");
	RewardSlot_ItemWnd = GetItemWindowHandle("RandomCraftWnd.RewardSlot_ItemWnd");
	ItemPointNum_TextBox = GetTextBoxHandle("RandomCraftWnd.ItemPoint_Wnd.ItemPointNum_TextBox");
	ItemPointNum_TextBox = GetTextBoxHandle("RandomCraftWnd.ItemPoint_Wnd.ItemPointNum_TextBox");
	ItemPointGaugeMax_Txt = GetTextBoxHandle("RandomCraftWnd.ItemPoint_Wnd.ItemPointGaugeMax_Txt");
	ItemPointNum_StatusBar = GetStatusBarHandle("RandomCraftWnd.ItemPoint_Wnd.ItemPointNum_StatusBar");
	ItemPointIcon_tex = GetTextureHandle("RandomCraftWnd.ItemPoint_Wnd.ItemPointIcon_tex");
	SetScript_UIControlNeedItemDialog();
	SetScript_UIControlBaseDialog();
	Confirm_Wnd.HideWindow();
	Result_WINDOW.HideWindow();
	ConfirmCraftCancelDialogWnd.HideWindow();
	HelpReward_Button.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13180), 245));
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "RandomCraftChargingWnd");
	API_C_EX_CRAFT_RANDOM_INFO();
	updateStateRefresButton();
	updateDescTextField();
}

function OnHide()
{
	Cancle_EffectViewport.SpawnEffect("");
	Result_EffectViewport.SpawnEffect("");
	hideAllDialog();
	Me.KillTimer(TIME_ID);
}

function initUI()
{
	local int i;

	for(i = 1; i < 6; i++)
	{
		playSlotAnimEffect_RefreshTime(i, false);
		playSlotAnimEffect_GoodItem(i, RandomCraftAnnounceGrade.RCAG_None);
	}
	RandomCraftWnd_Progress.SetProgressTime(1500);
	RandomCraftWnd_Progress.SetPos(0);
	RandomCraftWnd_Progress.Reset();
	RandomSlotGroupDisable_Wnd.HideWindow();
	ItemListReflash_Btn.DisableWindow();
	RandomCraft_Btn.DisableWindow();
	RewardSlotDisable_Tex.HideWindow();
}

function CustomTooltip setLockCustomTooltip(string lockString)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local RandomCraftAPI.ItemAmount needItemAmout;
	local string iconTexture, lockCountStr, lockTitle;
	local ItemInfo Info;
	local int W, h, nMaxLockCount;
	local Color lockColor;

	lockTitle = lockString;

	if(lockString == GetSystemString(1072))
	{
		lockColor = getInstanceL2Util().ColorGray;
	}
	else if(lockString == GetSystemString(13195))
	{
		lockColor = getInstanceL2Util().Yellow;
	}
	else if(lockString == GetSystemString(13176))
	{
		lockColor = getInstanceL2Util().BrightWhite;
	}
	else if(lockString == GetSystemString(13192))
	{
		lockTitle = lockString $ ": " $ GetSystemString(13193);
		lockColor = getInstanceL2Util().Red2;
	}

	drawListArr[drawListArr.Length] = addDrawItemText(lockString, lockColor, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13177), getInstanceL2Util().ColorDesc, "", true, false);
	nMaxLockCount = class'RandomCraftAPI'.static.GetMaxSlotLockCount();

	if(nCurrentlockCount >= nMaxLockCount)
	{
		lockCountStr = GetSystemString(13194) $ ": " $ GetSystemString(27);
	}
	else
	{
		lockCountStr = GetSystemString(13194) $ ": " $ string(nMaxLockCount - nCurrentlockCount) $ " / " $ string(nMaxLockCount);
	}

	if(nCurrentlockCount == nMaxLockCount)
	{
		lockColor = getInstanceL2Util().Red2;
	}
	else
	{
		lockColor = getInstanceL2Util().Green;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(lockCountStr, lockColor, "", true, true);

	if((lockString != GetSystemString(13192)) && nCurrentlockCount != nMaxLockCount)
	{
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText("<" $ GetSystemString(13179) $ ">", getInstanceL2Util().White, "", true, true);
		needItemAmout = class'RandomCraftAPI'.static.GetItemLockCost(nCurrentlockCount);
		iconTexture = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(needItemAmout.ItemClassID));
		Info = GetItemInfoByClassID(needItemAmout.ItemClassID);
		GetTextSizeDefault(Info.Name, W, h);
		drawListArr[drawListArr.Length] = addDrawItemTextureCustom(iconTexture, false, true, 5, 4, 32, 32);
		drawListArr[drawListArr.Length] = addDrawItemText(Info.Name, getInstanceL2Util().ColorDesc, "", false, false, 4, 6);
		drawListArr[drawListArr.Length] = addDrawItemText("x" $ MakeCostStringINT64(needItemAmout.Amount), getInstanceL2Util().ColorYellow,, false, false, -W, h + 4);
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 240;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function SetScript_UIControlNeedItemDialog()
{
	local string m_name;

	m_name = m_WindowName $ ".Confirm_Wnd.ConfirmNeedItemDialogWnd";
	ConfirmNeedItemDialogWnd = GetWindowHandle(m_name);
	ConfirmNeedItemDialogWnd.SetScript("UIControlNeedItemDialog");
	needItemDialogScript = UIControlNeedItemDialog(ConfirmNeedItemDialogWnd.GetScript());
	needItemDialogScript.SetWindow(m_name);
	needItemDialogScript.DelegateOnClickCancleButton = OnClickHideDialog;
	needItemDialogScript.DelegateOnClickOkButton = OnClickOkDialog;
}

function SetScript_UIControlBaseDialog()
{
	local string m_name;

	m_name = m_WindowName $ ".Confirm_Wnd.ConfirmAskDialogWnd";
	ConfirmAskDialogWnd = GetWindowHandle(m_name);
	ConfirmAskDialogWnd.SetScript("UIControlBasicDialog");
	askDialogScript = UIControlBasicDialog(ConfirmAskDialogWnd.GetScript());
	askDialogScript.SetWindow(m_name);
	askDialogScript.DelegateOnClickCancleButton = OnClickHideDialog;
}

function OnClickHideDialog(optional int nDialogKey)
{
	hideAllDialog();
}

function OnClickOkDialog(optional int nDialogKey)
{
	hideAllDialog();
	if(nDialogKey == Dialog_RandomCraft)
	{
		Confirm_Wnd.ShowWindow();
		ConfirmCraftCancelDialogWnd.ShowWindow();
		RandomCraftWnd_Progress.ShowWindow();
		RandomCraftWnd_Progress.SetProgressTime(1500);
		RandomCraftWnd_Progress.SetPos(0);
		RandomCraftWnd_Progress.Reset();
		RandomCraftWnd_Progress.Start();
		Cancle_EffectViewport.SpawnEffect("LineageEffect2.ui_soul_crystal");
		RewardRandomItem_Tex.SetTexture("");
		Me.KillTimer(TIME_ID);
		Me.SetTimer(TIME_ID, TIME_DELAY);
	}
	else if(nDialogKey == Dialog_Lock)
	{
		API_C_EX_CRAFT_RANDOM_LOCK_SLOT(needItemDialogScript.GetReservedInt());
	}
	else if(nDialogKey == Dialog_Refresh)
	{
		API_C_EX_CRAFT_RANDOM_REFRESH();
	}
}

function string getRandomItemName()
{
	local ItemInfo Info;
	local string sTexture;

	GetItemWindowHandle("RandomCraftWnd.RandomSlotGroup0" $ string(Rand(5) + 1) $ "_Wnd.RandomSlot_ItemWnd").GetItem(0, Info);

	if(Info.Id.ClassID > 0)
	{
		sTexture = class'UIDATA_ITEM'.static.GetItemTextureName(Info.Id);
	}
	return sTexture;
}

function playSlotAnimEffect_RefreshTime(int nSlotIndex, bool bShow)
{
	local string ctrlPath;

	ctrlPath = "RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex) $ "_Wnd.ItemListReflash_AniTex";

	if(bShow)
	{
		AnimTexturePlay(GetAnimTextureHandle(ctrlPath), true, 1);
	}
	else
	{
		AnimTextureStop(GetAnimTextureHandle(ctrlPath), true);
	}
}

function playSlotAnimEffect_GoodItem(int nSlotIndex, RandomCraftAnnounceGrade Grade)
{
	local AnimTextureHandle aniTexture;

	aniTexture = GetPlaySlotAnimEffectCtrlTextureBySlotIndex(nSlotIndex);
	if(Grade == RandomCraftAnnounceGrade.RCAG_1)
	{
		aniTexture.ShowWindow();
		AnimTexturePlay(aniTexture, true, 9999999);
	}
	else
	{
		aniTexture.HideWindow();
		AnimTextureStop(aniTexture, true);
	}
}

function string setSlot(int nSlotIndex, int nlockRemainNum, byte bLocked, int nItemClassID, INT64 nItemAmount)
{
	local array<byte> slotSuccessRateArr;
	local TextureHandle lockTexture, LockBtnLocked_Tex;
	local ItemInfo Info;
	local RandomCraftAnnounceGrade Grade;
	local int nMaxLockCount, nMaxItemLockCount;

	lockTexture = GetLockTexBySlotIndex(nSlotIndex);
	LockBtnLocked_Tex = GetLockBtnLockedTexBySlotIndex(nSlotIndex);
	nMaxLockCount = class'RandomCraftAPI'.static.GetMaxSlotLockCount();
	nMaxItemLockCount = class'RandomCraftAPI'.static.GetMaxItemLockCount();
	slotSuccessRateArr = class'RandomCraftAPI'.static.GetSlotsSuccessRate();
	GetTextBoxHandle("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex) $ "_Wnd.Probability_textbox").SetText(string(slotSuccessRateArr[nSlotIndex - 1]) $ "%");
	GetTextBoxHandle("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex) $ "_Wnd.LockNum_textbox").SetText(string(nlockRemainNum) $ "/" $ string(nMaxItemLockCount));
	GetItemWindowHandle("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex) $ "_Wnd.RandomSlot_ItemWnd").Clear();

	if(nItemClassID > 0)
	{
		Info = GetItemInfoByClassID(nItemClassID);

		if(isCollectionItem(Info))
		{
			Info.ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
		}

		if(nItemAmount > 0)
		{
			Info.ItemNum = nItemAmount;
		}
		GetItemWindowHandle("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex) $ "_Wnd.RandomSlot_ItemWnd").AddItem(Info);

		Grade = class'RandomCraftAPI'.static.GetItemAnnounceGrade(Info.Id.ClassID);

		playSlotAnimEffect_GoodItem(nSlotIndex, Grade);
	}
	if(nlockRemainNum <= 0)
	{
		GetTextBoxHandle("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex) $ "_Wnd.LockNum_textbox").SetTextColor(getInstanceL2Util().Red3);
		lockTexture.SetTexture(GetPlaySlotCardBackImageByGrade(Grade) $ "_Disabled");
		LockBtnLocked_Tex.SetTexture("L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Lock_DisUn");
		GetLock_BtnBySlotIndex(nSlotIndex).ShowWindow();
		GetLock_BtnBySlotIndex(nSlotIndex).DisableWindow();
		GetLock_StateBGTexBySlotIndex(nSlotIndex).HideWindow();
	}
	else
	{
		GetTextBoxHandle("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex) $ "_Wnd.LockNum_textbox").SetTextColor(getInstanceL2Util().White);
		if(bLocked > 0)
		{
			lockTexture.SetTexture(GetPlaySlotCardBackImageByGrade(Grade) $ "_Locked");
			GetLock_BtnBySlotIndex(nSlotIndex).HideWindow();
			GetLock_StateBGTexBySlotIndex(nSlotIndex).ShowWindow();
			LockBtnLocked_Tex.SetTexture("L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Lock");
		}
		else
		{
			GetLock_BtnBySlotIndex(nSlotIndex).ShowWindow();
			GetLock_BtnBySlotIndex(nSlotIndex).EnableWindow();
			GetLock_StateBGTexBySlotIndex(nSlotIndex).HideWindow();
			lockTexture.SetTexture(GetPlaySlotCardBackImageByGrade(Grade) $ "_Normal");
		}
	}

	if(nCurrentlockCount == nMaxLockCount)
	{
		GetTextBoxHandle("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex) $ "_Wnd.LockNum_textbox").SetTextColor(getInstanceL2Util().Gray);
	}
}

function OnClickButtonWithHandle(ButtonHandle aButtonHandle)
{
	local string parentname;
	local int idx, lockIndex;

	parentname = aButtonHandle.GetParentWindowName();

	if(Left(parentname, Len("RandomSlotGroup")) == "RandomSlotGroup")
	{
		idx = InStr(parentname, "_Wnd") - 1;
		lockIndex = int(Mid(parentname, idx, 1));

		if(nCurrentlockCount < class'RandomCraftAPI'.static.GetMaxSlotLockCount())
		{
			tryDialogRandomCraft(Dialog_Lock, lockIndex - 1);
		}
		else
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemString(13177));
		}
	}
}

function OnClickButton(string Name)
{
	Debug("OnClickButton: " @ Name);

	switch(Name)
	{
		case "HelpWnd_Btn":
			ExecuteEvent(EV_ShowHelp, "49");
			break;
		case "ResultOK_BTN":
			OnResult_BTNClick();
			break;
		case "ItemListReflash_Btn":
			OnItemListReflash_BtnClick();
			break;
		case "ItemPointCharge_Btn":
			toggleWindow("RandomCraftChargingWnd", true, true);
			break;
		case "RandomCraft_Btn":
			tryDialogRandomCraft(Dialog_RandomCraft);
			break;
		case "CraftCancel_Btn":
			RandomCraftWnd_Progress.Stop();
			hideAllDialog();
			break;
	}
}

function OnTimer(int TimerID)
{
	local string sTexture;

	if(TimerID == TIME_ID)
	{
		sTexture = getRandomItemName();

		if(RewardRandomItem_Tex.GetTextureName() == sTexture)
		{
			sTexture = getRandomItemName();
		}
		RewardRandomItem_Tex.SetTexture(sTexture);
	}
}

function OnProgressTimeUp(string strID)
{
	if(strID == "RandomCraftWnd_Progress")
	{
		hideAllDialog();
		Confirm_Wnd.ShowWindow();
		API_C_EX_CRAFT_RANDOM_MAKE();
	}
}

function ParsePacket_S_EX_CRAFT_INFO(UIPacket._S_EX_CRAFT_INFO packet)
{
	local float fPer;
	local int maxGauge;
	local ItemInfo Info;
	local int currentCharge, maxPoint;
	local RandomCraftAPI.ItemAmount sItemAmout;
	local array<RandomCraftAPI.ItemAmount> RewardItems;

	maxPoint = class'RandomCraftAPI'.static.GetMaxItemPoint();
	maxGauge = class'RandomCraftAPI'.static.GetMaxGaugeValue();
	ItemPointNum_TextBox.SetText("x" $ string(packet.nPoint));
	nCurrentCraftPoint = packet.nPoint;

	if(nCurrentCraftPoint > 0)
	{
		ItemListReflash_Btn.EnableWindow();
	}
	else
	{
		ItemListReflash_Btn.DisableWindow();
	}

	if(packet.nPoint >= maxPoint && packet.nCharge >= maxGauge - 1)
	{
		ItemPointGaugeMax_Txt.SetText("Max");
	}
	else
	{
		currentCharge = int(getInstanceL2Util().Get9999Percent(int64(packet.nCharge), int64(maxGauge)));
		fPer = currentCharge / maxGauge * 100;
		ItemPointGaugeMax_Txt.SetText(getInstanceL2Util().cutFloat(fPer));
	}
	ItemPointNum_StatusBar.SetPoint(int64(packet.nCharge), int64(maxGauge));
	RewardItems = class'RandomCraftAPI'.static.GetRewardItems();

	if(RewardItems.Length > 0)
	{
		sItemAmout = RewardItems[0];
	}
	RewardSlot_ItemWnd.Clear();
	Info = GetItemInfoByClassID(sItemAmout.ItemClassID);
	Info.ItemNum = sItemAmout.Amount;

	if(isCollectionItem(Info))
	{
		Info.ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
	}
	RewardSlot_ItemWnd.AddItem(Info);

	if(packet.bGiveItem > 0)
	{
		RewardSlotDisable_Tex.HideWindow();
		ItemPointIcon_tex.SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon");
	}
	else
	{
		RewardSlotDisable_Tex.ShowWindow();
		ItemPointIcon_tex.SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon_dis");
	}
	updateDescTextField();
}

function ParsePacket_S_EX_CRAFT_RANDOM_INFO(optional bool bUpdate)
{
	local UIPacket._S_EX_CRAFT_RANDOM_INFO packet;
	local int i, nMaxLockCount;
	local string lockString;

	if(bUpdate)
	{
		packet = Craft_Ramdom_Info_PacketForUpdate;
	}
	else
	{
		if(!class'UIPacket'.static.Decode_S_EX_CRAFT_RANDOM_INFO(packet))
		{
			return;
		}
		Craft_Ramdom_Info_PacketForUpdate = packet;
	}
	nMaxLockCount = class'RandomCraftAPI'.static.GetMaxSlotLockCount();
	nCurrentlockCount = 0;
	bItemWasReady = false;

	for(i = 0; i < packet.slotInfoList.Length; i++)
	{
		if((packet.slotInfoList[i].bLocked == 0) && (packet.slotInfoList[i].nLockRemain == 0) && (packet.slotInfoList[i].nItemClassID == 0) && packet.slotInfoList[i].nItemAmount == 0)
		{
		}
		else
		{
			bItemWasReady = true;
		}
		if((packet.slotInfoList[i].bLocked > 0) || (packet.slotInfoList[i].nLockRemain == 0))
		{
			nCurrentlockCount++;
		}
	}

	if(nCurrentlockCount >= nMaxLockCount)
	{
		nCurrentlockCount = nMaxLockCount;
	}

	for(i = 0; i < packet.slotInfoList.Length; i++)
	{
		setSlot(i + 1, packet.slotInfoList[i].nLockRemain, packet.slotInfoList[i].bLocked, packet.slotInfoList[i].nItemClassID, packet.slotInfoList[i].nItemAmount);

		if(packet.slotInfoList[i].nLockRemain <= 0)
		{
			lockString = GetSystemString(1072);
		}
		else if(packet.slotInfoList[i].bLocked > 0)
		{
			lockString = GetSystemString(13195);
		}
		else if(nCurrentlockCount >= nMaxLockCount)
		{
			lockString = GetSystemString(13192);
		}
		else
		{
			lockString = GetSystemString(13176);
		}
		GetLock_StateBGTexBySlotIndex(i + 1).SetTooltipCustomType(setLockCustomTooltip(lockString));
		GetLock_BtnBySlotIndex(i + 1).SetTooltipCustomType(setLockCustomTooltip(lockString));
	}

	if(bItemWasReady)
	{
		RandomSlotGroupDisable_Wnd.HideWindow();
		RandomSlotGroupDisable_Txt.HideWindow();
		RandomCraft_Btn.EnableWindow();
		Description_Text.SetText(GetSystemString(13175));
	}
	else
	{
		RandomSlotGroupDisable_Wnd.ShowWindow();
		RandomSlotGroupDisable_Txt.ShowWindow();
		RandomCraft_Btn.DisableWindow();
		Description_Text.SetText("");
	}
	updateDescTextField();
}

function tryDialogRandomCraft(int nDialogKey, optional int nLockIndex)
{
	local RandomCraftAPI.ItemAmount costItemAmout;
	local array<RandomCraftAPI.ItemAmount> ItemCostArr;
	local int i;

	if(nDialogKey == 1)
	{
		ItemCostArr = class'RandomCraftAPI'.static.GetItemMakingCosts();
	}
	else
	{
		if(nDialogKey == Dialog_Refresh)
		{
			ItemCostArr = class'RandomCraftAPI'.static.GetRestCosts();
		}
		else
		{
			costItemAmout = class'RandomCraftAPI'.static.GetItemLockCost(nCurrentlockCount);
		}
	}

	Confirm_Wnd.ShowWindow();
	Result_WINDOW.HideWindow();
	ConfirmAskDialogWnd.HideWindow();
	ConfirmNeedItemDialogWnd.ShowWindow();
	ConfirmNeedItemDialogWnd.SetFocus();

	if(nDialogKey == Dialog_RandomCraft)
	{
		needItemDialogScript.setInit(GetSystemString(13182), nDialogKey);
	}
	else
	{
		if(nDialogKey == Dialog_Refresh)
		{
			needItemDialogScript.setInit(GetSystemString(13197), nDialogKey);
		}
		else
		{
			needItemDialogScript.setInit(GetSystemString(13181), nDialogKey);
			needItemDialogScript.SetReservedInt(nLockIndex);
		}
	}
	if(ItemCostArr.Length > 0)
	{
		needItemDialogScript.StartNeedItemList();

		for(i = 0; i < ItemCostArr.Length; i++)
		{
			needItemDialogScript.AddNeedItem(ItemCostArr[i].ItemClassID, ItemCostArr[i].Amount);
		}
		needItemDialogScript.EndNeedItemList();
	}
	else
	{
		needItemDialogScript.StartNeedItemList();
		needItemDialogScript.AddNeedItem(costItemAmout.ItemClassID, costItemAmout.Amount);
		needItemDialogScript.EndNeedItemList();
	}
}

function OnResult_BTNClick()
{
	Confirm_Wnd.HideWindow();
	Result_WINDOW.HideWindow();
}

function OnItemListReflash_BtnClick()
{
	tryDialogRandomCraft(Dialog_Refresh);
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_GameStart:
			initUI();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_CRAFT_RANDOM_INFO):
			ParsePacket_S_EX_CRAFT_RANDOM_INFO();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_CRAFT_RANDOM_LOCK_SLOT):
			ParsePacket_S_EX_CRAFT_RANDOM_LOCK_SLOT();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_CRAFT_RANDOM_REFRESH):
			ParsePacket_S_EX_CRAFT_RANDOM_REFRESH();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_CRAFT_RANDOM_MAKE):
			ParsePacket_S_EX_CRAFT_RANDOM_MAKE();
			break;
	}
}

function ParsePacket_S_EX_CRAFT_RANDOM_MAKE()
{
	local UIPacket._S_EX_CRAFT_RANDOM_MAKE packet;
	local ItemInfo Info;

	if(!class'UIPacket'.static.Decode_S_EX_CRAFT_RANDOM_MAKE(packet))
	{
		return;
	}

	if(packet.cResult == 0)
	{
		hideAllDialog();
		Confirm_Wnd.ShowWindow();
		Result_WINDOW.ShowWindow();
		Info = GetItemInfoByClassID(packet.Result.nItemClassID);
		Info.ItemNum = packet.Result.nAmount;
		Info.Enchanted = packet.Result.cEnchanted;

		if(isCollectionItem(Info))
		{
			Info.ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
		}
		Result_ItemWnd.Clear();
		Result_ItemWnd.AddItem(Info);
		Result_ItemName_text.SetText(GetItemNameAll(Info));
		Result_EffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_succ");
		Result_EffectViewport.SetFocus();
	}
	else
	{
		Me.HideWindow();
	}
}

function updateStateRefresButton()
{
	if(nCurrentCraftPoint > 0)
	{
		ItemListReflash_Btn.EnableWindow();
	}
	else
	{
		ItemListReflash_Btn.DisableWindow();
	}
}

function updateDescTextField()
{
	if(ItemListReflash_Btn.IsEnableWindow())
	{
		RandomSlotGroupDisable_Txt.SetText(GetSystemString(13190));
	}
	else
	{
		RandomSlotGroupDisable_Txt.SetText(GetSystemString(13191));
	}
}

function ParsePacket_S_EX_CRAFT_RANDOM_REFRESH()
{
	local UIPacket._S_EX_CRAFT_RANDOM_REFRESH packet;
	local int i;

	if(!class'UIPacket'.static.Decode_S_EX_CRAFT_RANDOM_REFRESH(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_CRAFT_RANDOM_REFRESH : " @ string(packet.cResult));

	if(packet.cResult == 0)
	{
		for(i = 1; i < 6; i++)
		{
			if(GetLockTexBySlotIndex(i).GetTextureName() != "RandomCraftWnd_Slot_Locked")
			{
				playSlotAnimEffect_RefreshTime(i, true);
			}
		}
	}
}

function OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
	switch(a_WindowHandle.GetWindowName())
	{
		case "ItemSlot_AniTex1":
			break;

		default:
			a_WindowHandle.HideWindow();
			break;
	}
}

function API_C_EX_CRAFT_RANDOM_REFRESH()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_CRAFT_RANDOM_REFRESH, stream);
	Debug("----> Api Call : C_EX_CRAFT_RANDOM_REFRESH (제작 목록 갱신)");
}

function API_C_EX_CRAFT_RANDOM_MAKE()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_CRAFT_RANDOM_MAKE, stream);
	Debug("----> Api Call : C_EX_CRAFT_RANDOM_MAKE (랜덤 제작)");
}

function API_C_EX_CRAFT_RANDOM_INFO()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_CRAFT_RANDOM_INFO, stream);
	Debug("----> Api Call : C_EX_CRAFT_RANDOM_INFO (제작 정보)");
}

function API_C_EX_CRAFT_RANDOM_LOCK_SLOT(int nSlot)
{
	local array<byte> stream;
	local UIPacket._C_EX_CRAFT_RANDOM_LOCK_SLOT packet;

	packet.nSlot = nSlot;

	if(!class'UIPacket'.static.Encode_C_EX_CRAFT_RANDOM_LOCK_SLOT(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_CRAFT_RANDOM_LOCK_SLOT, stream);
	Debug("----> Api Call : C_EX_CRAFT_RANDOM_LOCK_SLOT (슬롯 잠그기)" @ string(nSlot));
}

function ParsePacket_S_EX_CRAFT_RANDOM_LOCK_SLOT()
{
	local UIPacket._S_EX_CRAFT_RANDOM_LOCK_SLOT packet;

	if(!class'UIPacket'.static.Decode_S_EX_CRAFT_RANDOM_LOCK_SLOT(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_CRAFT_RANDOM_LOCK_SLOT : " @ string(packet.cResult));
	ParsePacket_S_EX_CRAFT_RANDOM_INFO(true);
}

function hideAllDialog()
{
	Confirm_Wnd.HideWindow();
	ConfirmAskDialogWnd.HideWindow();
	ConfirmNeedItemDialogWnd.HideWindow();
	Result_WINDOW.HideWindow();
	ConfirmCraftCancelDialogWnd.HideWindow();
	Me.KillTimer(TIME_ID);
}

function string GetPlaySlotCardBackImageByGrade(RandomCraftAnnounceGrade Grade)
{
	local string ctrlPath;

	switch(Grade)
	{
		case RCAG_None:
			ctrlPath = "L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Slot00";
			break;
		case RCAG_1:
			ctrlPath = "L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Slot03";
			break;
		case RCAG_2:
			ctrlPath = "L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Slot02";
			break;
		case RCAG_3:
			ctrlPath = "L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Slot01";
			break;

		default:
			ctrlPath = "L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Slot00";
			break;
	}
	return ctrlPath;
}

function TextureHandle GetLock_StateBGTexBySlotIndex(int nSlotIndex)
{
	return GetTextureHandle("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex) $ "_Wnd.Lock_StateBG");
}

function ButtonHandle GetLock_BtnBySlotIndex(int nSlotIndex)
{
	return GetButtonHandle("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex) $ "_Wnd.Lock_Btn");
}

function AnimTextureHandle GetPlaySlotAnimEffectCtrlTextureBySlotIndex(int nSlotIndex)
{
	return GetAnimTextureHandle("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex) $ "_Wnd.ItemSlot_AniTex1");
}

function TextureHandle GetLockTexBySlotIndex(int nSlotIndex)
{
	return GetTextureHandle("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex) $ "_Wnd.RandomSlot_Lock_Tex");
}

function TextureHandle GetLockBtnLockedTexBySlotIndex(int nSlotIndex)
{
	return GetTextureHandle("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex) $ "_Wnd.LockBtnLocked_Tex");
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);

	if(Confirm_Wnd.IsShowWindow())
	{
		hideAllDialog();
	}
	else
	{
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
}

defaultproperties
{
	m_WindowName="RandomCraftWnd"
}
