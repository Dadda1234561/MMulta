class L2PassWnd extends UICommonAPI
	dependson(L2PassAdvanceListDrawer);

const SHOW_STEP_PER_PAGE = 10;
const SHOW_STEP_MINIMUM_PAGE = 1;
const HUNT_PREMIUM_BUY_ITEM_ID = 72303;
const ADVANCE_PREMIUM_BUY_ITEM_ID = 72285;
const HUNT_PREMIUM_BUY_ITEM_ID_LIVE_SERVER = 60304;
const ADVANCE_PREMIUM_BUY_ITEM_ID_LIVE_SERVER = 60305;
const SAYHAS_BTN_ON_TEXTURE = "L2UI_ct1.OlympiadWnd.ONICON";
const SAYHAS_BTN_OFF_TEXTURE = "L2UI_ct1.OlympiadWnd.OFFICON";
const TIMER_ID_SAYHAS = 1;
const TIMER_ID_BTN_DELAY = 2;
const TIMER_DELAY_SAYHAS = 60000;
const TIMER_DELAY_BTN_DISABLE = 1000;
const tabGroupOffsetX = 22;

var L2PassData.L2PassSayhasSupportInfo _sayhasSupportInfo;
var L2PassData.L2PassInfo _huntPassInfo;
var L2PassData.L2PassInfo _advancePassInfo;
var L2PassData _l2PassData;
var bool _isAvailableReward;
var array<int> _advanceCondIndex;
var bool _isFirstPacket;
var bool _advanceLastRewardReceived;
var int _sayhasTimerCount;
var bool _isWaitingBtnDelay;
var bool _isConfirmTypePurchaseDialog;
var WindowHandle Me;
var string m_WindowName;
var WindowHandle disableWnd;
var WindowHandle totalRewardInfoWnd;
var WindowHandle sayhasInfoTooltipWnd;
var WindowHandle advancePassDetailInfoWnd;
var WindowHandle premiumPurchaseDialogWnd;
var UIControlGroupButtonAssets tabGroupButton;
var UIControlDialogAssets premiumPurchaseDialog;
var EffectViewportWndHandle resultEffect;
var WindowHandle huntPassContainer;
var WindowHandle advancePassContainer;
var WindowHandle sayhasSupportContainer;
var WindowHandle passInfoContainer;
var UIControlPageNavi pageNaviControl;
var ButtonHandle sayhasSupportOnOffBtn;
var ButtonHandle sayhasSupportInfoBtn;
var ButtonHandle premiumPurchaseBtn;
var ButtonHandle getRewardBtn;
var ButtonHandle refreshBtn;
var ButtonHandle totalRewardInfoBtn;
var ItemWindowHandle advanceFinalRewardItem;
var L2PassRewardListWnd totalRewardInfoWndScript;
var L2PassAdvanceListDrawer advancePassDetailInfoWndScript;
var ButtonHandle huntStepPrevBtn;
var ButtonHandle huntStepNextBtn;
var ButtonHandle advanceStepPrevBtn;
var ButtonHandle advanceStepNextBtn;
var AnimTextureHandle sayhasIconEffectAnimTexture;
var SideBar SideBarScript;
var TextureHandle tabAlarmIcon0;
var TextureHandle tabAlarmIcon1;
var array<L2PassWndStepComponent> huntStepNormalComponents;
var array<L2PassWndStepComponent> huntStepPremiumComponents;
var array<L2PassWndStepComponent> advanceStepComponents;
var array<L2PassWndProgressComponent> huntStepProgressComponents;
var array<L2PassWndProgressComponent> advanceStepProgressComponents;
var L2PassData.EL2PassType _selectedPassType;

function Initialize()
{
	InitControls();
	InitData();
}

function InitControls()
{
	local int i;
	local WindowHandle tabGroupButtonWindow, pageNaviControlWindow;

	_isWaitingBtnDelay = false;
	_isConfirmTypePurchaseDialog = false;
	Me = GetWindowHandle(m_WindowName);
	_l2PassData = new class'L2PassData';
	SideBarScript = SideBar(GetScript("SideBar"));
	tabGroupButtonWindow = GetWindowHandle(m_WindowName $ ".UIControlGroupButtonAsset");
	tabGroupButton = class'UIControlGroupButtonAssets'.static._InitScript(tabGroupButtonWindow);
	tabGroupButton._SetStartInfo("L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Unselected_Over", true);
	tabGroupButton._GetGroupButtonsInstance().__DelegateOnClickButton__Delegate = OnTabGroupBtnClicked;
	tabAlarmIcon0 = GetTextureHandle(m_WindowName $ ".Tab_Icon01");
	tabAlarmIcon1 = GetTextureHandle(m_WindowName $ ".Tab_Icon02");
	disableWnd = GetWindowHandle(m_WindowName $ ".Disable_Wnd");
	premiumPurchaseDialogWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	premiumPurchaseDialog = class'UIControlDialogAssets'.static.InitScript(premiumPurchaseDialogWnd);
	premiumPurchaseDialog.InitWnd(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset"));
	premiumPurchaseDialog.SetDisableWindow(disableWnd);
	premiumPurchaseDialog.__DelegateOnCancel__Delegate = OnPremiumPurchasePopupCancel;
	premiumPurchaseDialog.__DelegateOnClickBuy__Delegate = OnPremiumPurchasePopupConfirm;
	advancePassDetailInfoWnd = GetWindowHandle("L2PassAdvanceListDrawer");
	advancePassDetailInfoWndScript = L2PassAdvanceListDrawer(advancePassDetailInfoWnd.GetScript());
	totalRewardInfoWnd = GetWindowHandle(disableWnd.m_WindowNameWithFullPath $ ".L2PassRewardListWnd");
	totalRewardInfoWnd.SetScript("L2PassRewardListWnd");
	totalRewardInfoWndScript = L2PassRewardListWnd(totalRewardInfoWnd.GetScript());
	totalRewardInfoWndScript.Init(totalRewardInfoWnd, self);
	huntPassContainer = GetWindowHandle(m_WindowName $ ".HuntPassTab_Wnd");
	advancePassContainer = GetWindowHandle(m_WindowName $ ".AdvancePassTab_Wnd");
	passInfoContainer = GetWindowHandle(m_WindowName $ ".PassInfo_wnd");
	sayhasSupportContainer = GetWindowHandle(m_WindowName $ ".SayhasSupport_Wnd");
	sayhasInfoTooltipWnd = GetWindowHandle(m_WindowName $ ".SayhasInfoTooltipWnd");
	advanceFinalRewardItem = GetItemWindowHandle(huntPassContainer.m_WindowNameWithFullPath $ ".AdvanceRewardItem_ItemWnd");
	resultEffect = GetEffectViewportWndHandle(m_WindowName $ ".Result_EffectViewport");
	sayhasSupportOnOffBtn = GetButtonHandle(sayhasSupportContainer.m_WindowNameWithFullPath $ ".SayhasONOFF_BTN");
	sayhasSupportInfoBtn = GetButtonHandle(sayhasSupportContainer.m_WindowNameWithFullPath $ ".TimeHelp_btn");
	premiumPurchaseBtn = GetButtonHandle(m_WindowName $ ".PremiumActive_BTN");
	getRewardBtn = GetButtonHandle(m_WindowName $ ".GetReward_BTN");
	refreshBtn = GetButtonHandle(m_WindowName $ ".Refresh_Btn");
	totalRewardInfoBtn = GetButtonHandle(m_WindowName $ ".RewardList_Btn");
	pageNaviControlWindow = GetWindowHandle(m_WindowName $ ".PageNaviControl");
	pageNaviControlWindow.SetScript("UIControlPageNavi");
	pageNaviControl = UIControlPageNavi(pageNaviControlWindow.GetScript());
	pageNaviControl.Init(m_WindowName $ ".PageNaviControl");
	pageNaviControl.__DelegeOnChangePage__Delegate = OnPageNaviChanged;
	pageNaviControl.__DelegateOnClickButton__Delegate = OnPageNaviClicked;
	sayhasIconEffectAnimTexture = GetAnimTextureHandle(sayhasInfoTooltipWnd.m_WindowNameWithFullPath $ ".SayhasIconEffect_animTex");
	huntStepPrevBtn = GetButtonHandle(huntPassContainer.m_WindowNameWithFullPath $ ".ControlNaviHunt_PrevBtn");
	huntStepNextBtn = GetButtonHandle(huntPassContainer.m_WindowNameWithFullPath $ ".ControlNaviHunt_NextBtn");
	advanceStepPrevBtn = GetButtonHandle(advancePassContainer.m_WindowNameWithFullPath $ ".ControlNaviAdvance_PrevBtn");
	advanceStepNextBtn = GetButtonHandle(advancePassContainer.m_WindowNameWithFullPath $ ".ControlNaviAdvance_NextBtn");
	huntStepNormalComponents.Length = 0;
	huntStepPremiumComponents.Length = 0;
	advanceStepComponents.Length = 0;
	huntStepProgressComponents.Length = 0;
	advanceStepProgressComponents.Length = 0;

	for(i = 0; i < SHOW_STEP_PER_PAGE; i++)
	{
		AddStepComponent(huntStepNormalComponents, "Section0", i, huntPassContainer);
		AddStepComponent(huntStepPremiumComponents, "P_Section0", i, huntPassContainer);
		AddProgressComponent(huntStepProgressComponents, "Gauge_Section0", i, huntPassContainer);
		AddStepComponent(advanceStepComponents, "AV_Section0", i, advancePassContainer);
		AddProgressComponent(advanceStepProgressComponents, "Gauge_Section0", i, advancePassContainer);
	}
	ShowEffectResult(false);
}

function InitData()
{
	_isFirstPacket = true;
	_advanceLastRewardReceived = false;
	_huntPassInfo.PassType = _l2PassData.EL2PassType.Hunt;
	_advancePassInfo.PassType = _l2PassData.EL2PassType.Advance;
	_huntPassInfo.maxStep = GetL2PassMaxCount(_l2PassData.EL2PassStepState.NotInProgress);
	_advancePassInfo.maxStep = GetL2PassMaxCount(_l2PassData.EL2PassStepState.InProgress);
	_huntPassInfo.maxMissionCnt = GetL2PassRewardStepMaxCount(_l2PassData.EL2PassStepState.NotInProgress);
	_advancePassInfo.maxMissionCnt = GetL2PassRewardStepMaxCount(_l2PassData.EL2PassStepState.InProgress);
	_huntPassInfo.maxStepPage = Max(appCeil(float(_huntPassInfo.maxStep) / SHOW_STEP_PER_PAGE), 1);
	_advancePassInfo.maxStepPage = Max(appCeil(float(_advancePassInfo.maxStep) / SHOW_STEP_PER_PAGE), 1);
	_huntPassInfo.freeStepNum = _huntPassInfo.maxStep;
	_huntPassInfo.premiumStepNum = _huntPassInfo.maxStep;
	_advancePassInfo.freeStepNum = GetL2PassAdvanceFreeCount();
	_advancePassInfo.premiumStepNum = _advancePassInfo.maxStep - _advancePassInfo.freeStepNum;
	_huntPassInfo.currentStepPage = 1;
	_advancePassInfo.currentStepPage = 1;
	_sayhasSupportInfo.maxTIme = GetL2PassHuntingMaxTime() * 60;
	UpdateHuntPassStepInfo();
	UpdateAdvancePassStepInfo();
	UpdateUIControls();
}

function AddStepComponent(out array<L2PassWndStepComponent> componentList, string componentName, int Index, WindowHandle Owner)
{
	local WindowHandle targetWindowHandle;
	local L2PassWndStepComponent targetControl;

	targetWindowHandle = GetWindowHandle(Owner.m_WindowNameWithFullPath $ "." $ componentName $ string(Index));
	targetWindowHandle.SetScript("L2PassWndStepComponent");
	targetControl = L2PassWndStepComponent(targetWindowHandle.GetScript());
	targetControl.Init(targetWindowHandle);
	targetControl.__DelegateOnStepClicked__Delegate = OnStepClicked;
	componentList[componentList.Length] = targetControl;
}

function AddProgressComponent(out array<L2PassWndProgressComponent> componentList, string componentName, int Index, WindowHandle Owner)
{
	local WindowHandle targetWindowHandle;
	local L2PassWndProgressComponent targetControl;

	targetWindowHandle = GetWindowHandle(Owner.m_WindowNameWithFullPath $ "." $ componentName $ string(Index));
	targetWindowHandle.SetScript("L2PassWndProgressComponent");
	targetControl = L2PassWndProgressComponent(targetWindowHandle.GetScript());
	targetControl.Init(targetWindowHandle);
	componentList[componentList.Length] = targetControl;
}

function UpdateTabGroupRewardAlarm()
{
	local bool huntPassAlarm, advancePassAlarm;

	tabAlarmIcon0.HideWindow();
	tabAlarmIcon1.HideWindow();

	if(_huntPassInfo.isOn == true && _huntPassInfo.notReceivedRewardNum > 0)
	{
		huntPassAlarm = true;
	}
	if(_advancePassInfo.isOn == true && _advancePassInfo.notReceivedRewardNum > 0)
	{
		advancePassAlarm = true;
	}
	if(huntPassAlarm == true)
	{
		if(_advancePassInfo.isOn == true)
		{
			tabAlarmIcon0.ShowWindow();
		} else {
			tabAlarmIcon1.ShowWindow();
		}
	}
	if(advancePassAlarm == true)
	{
		tabAlarmIcon1.ShowWindow();
	}
}

function SetPassStepPage(L2PassData.EL2PassType Type)
{
	if(Type == _l2PassData.EL2PassType.Hunt)
	{
		if(_huntPassInfo.isOn == true)
		{
			_selectedPassType = Type;
		} else {
			return;
		}
	}
	else if(Type == _l2PassData.EL2PassType.Advance)
	{
		if(_advancePassInfo.isOn == true)
		{
			_selectedPassType = Type;
		} else {
			return;
		}
	}
	SetPassInfoDefaultCurrentStepPage(_selectedPassType);

	if(_selectedPassType == _l2PassData.EL2PassType.Hunt)
	{
		UpdateHuntPassStepInfo();
		huntPassContainer.ShowWindow();
		advancePassContainer.HideWindow();
		ShowAdvancePassDetailInfoWnd(false);
	}
	else if(_selectedPassType == _l2PassData.EL2PassType.Advance)
	{
		UpdateAdvancePassStepInfo();
		huntPassContainer.HideWindow();
		advancePassContainer.ShowWindow();
	}
	UpdateUIControls();
}

function SetPageNaviMaxPage(int maxPage)
{
	pageNaviControl.SetTotalPage(maxPage);
}

function SetPageNaviCurrentPage(int Page)
{
	pageNaviControl.Go(Page);
}

function _ShowDisalbeWnd(bool isShow)
{
	if(isShow == true)
	{
		disableWnd.ShowWindow();
	} else {
		disableWnd.HideWindow();
	}
}

function ShowEffectResult(bool isShow)
{
	if(Me.IsShowWindow() == false)
	{
		return;
	}
	if(_selectedPassType != _l2PassData.EL2PassType.Advance)
	{
		return;
	}
	if(isShow == true)
	{
		resultEffect.ShowWindow();
		resultEffect.SetScale(1.910f);
		resultEffect.SetCameraDistance(572.0f);
		resultEffect.SetCameraPitch(0);
		resultEffect.SetCameraYaw(0);
		resultEffect.SpawnEffect("LineageEffect2.ui_upgrade_succ");
	} else {
		resultEffect.HideWindow();
	}
}

function ShowPremiumPurchaseDialog(bool isShow, L2PassData.EL2PassType PassType, optional bool isConfirmType)
{
	local int descItemId, costItemID, costItemCnt;
	local ItemInfo descItemInfo;
	local string itemNameHtmlStr, itemDescHtmlStr, timeInfoHtmlStr, passEndTimeStr;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));

	if(isShow == false)
	{
		premiumPurchaseDialog.Hide();
		_isConfirmTypePurchaseDialog = false;
		return;
	}
	_isConfirmTypePurchaseDialog = isConfirmType;

	if(_selectedPassType == _l2PassData.EL2PassType.Hunt)
	{
		if(getInstanceUIData().getIsLiveServer())
		{
			descItemId = HUNT_PREMIUM_BUY_ITEM_ID_LIVE_SERVER;
		} else {
			descItemId = HUNT_PREMIUM_BUY_ITEM_ID;
		}
		passEndTimeStr = GetPassEndTimeText(_huntPassInfo.LeftTime);
	}
	else if(_selectedPassType == _l2PassData.EL2PassType.Advance)
	{
		if(getInstanceUIData().getIsLiveServer())
		{
			descItemId = ADVANCE_PREMIUM_BUY_ITEM_ID_LIVE_SERVER;
		} else {
			descItemId = ADVANCE_PREMIUM_BUY_ITEM_ID;
		}
		passEndTimeStr = GetPassEndTimeText(_advancePassInfo.LeftTime);
	}
	GetL2PassPremiumPassCost(_selectedPassType, costItemID, costItemCnt);
	premiumPurchaseDialog.SetUseBuyItem(false);
	premiumPurchaseDialog.SetUseNumberInput(false);
	descItemInfo = GetItemInfoByClassID(descItemId);
	premiumPurchaseDialog.SetDescriptonIconTexture(descItemInfo.IconName);
	itemNameHtmlStr = "<br><font color=\"E6DCBE\" name=chatFontSize11>" $ descItemInfo.Name $ "</font>";
	itemDescHtmlStr = "<br><font color=\"" $ getColorHexString(util.Blue) $ "\">" $ descItemInfo.Description $ "</font>";

	if(GetLanguage() == LANG_Russia || GetLanguage() == LANG_Euro || GetLanguage() == LANG_English)
	{
		timeInfoHtmlStr = "<br><font color=\"" $ getColorHexString(util.White) $ "\">" $ "(" $ GetSystemString(5977) @ ":" @ passEndTimeStr $ ")" $ "</font>";
	} else {
		timeInfoHtmlStr = "<br><font color=\"" $ getColorHexString(util.White) $ "\">" $ "(" $ GetSystemString(5977) @ ":" @ passEndTimeStr @ GetSystemString(5976) $ ")" $ "</font>";
	}
	if(_isConfirmTypePurchaseDialog == true)
	{
		premiumPurchaseDialog.SetUseNeedItem(false);
		premiumPurchaseDialog.SetDialogDesc(itemNameHtmlStr $ timeInfoHtmlStr $ itemDescHtmlStr $ "</font><br><font color=\"EEAA22\">" $ GetSystemMessage(4569) $ "</font>", 5962, 0, true);
	} else {
		premiumPurchaseDialog.SetUseNeedItem(true);
		premiumPurchaseDialog.SetDialogDesc(itemNameHtmlStr $ timeInfoHtmlStr $ itemDescHtmlStr, 5962, 0, true);
	}
	premiumPurchaseDialog.StartNeedItemList(1);
	premiumPurchaseDialog.AddNeedItemClassID(costItemID, int64(costItemCnt));
	premiumPurchaseDialog.SetItemNum(1);
	premiumPurchaseDialog.Show();
}

function ShowSayhasInfoTooltip(bool isShow)
{
	if(isShow == false || _huntPassInfo.isOn == false)
	{
		sayhasInfoTooltipWnd.HideWindow();
	} else {
		sayhasInfoTooltipWnd.ShowWindow();
	}
}

function ShowTotalRewardInfoDialog(bool isShow, L2PassData.EL2PassType PassType)
{
	local L2PassData.L2PassInfo passInfo;

	passInfo = GetPassInfo(_selectedPassType);

	if(isShow == true)
	{
		totalRewardInfoWndScript._SetTotalRewardInfo(passInfo.PassType, passInfo.rewardStep, passInfo.premiumRewardStep, passInfo.isPremiumActivated);
		totalRewardInfoWndScript._ScrollToStart();
		totalRewardInfoWnd.ShowWindow();
	} else {
		totalRewardInfoWnd.HideWindow();
	}
}

function ShowAdvancePassDetailInfoWnd(bool isShow)
{
	if(isShow == false || _selectedPassType != _l2PassData.EL2PassType.Advance)
	{
		advancePassDetailInfoWnd.HideWindow();
	} else {
		advancePassDetailInfoWndScript._SetAdvanceItemInfo(_advanceCondIndex);
		advancePassDetailInfoWnd.ShowWindow();
	}
}

function UpdatePassTabGroupButton()
{
	local int Index, i, windowSizeWidth, windowSizeHeight;
	local array<L2PassData.EL2PassType> availablePassList;
	local bool validSelectedTab;

	Index = 0;
	Me.GetWindowSize(windowSizeWidth, windowSizeHeight);

	if(_huntPassInfo.isOn == true)
	{
		tabGroupButton._GetGroupButtonsInstance()._setButtonText(Index, GetSystemString(5944));
		tabGroupButton._GetGroupButtonsInstance()._setButtonValue(Index, _l2PassData.EL2PassType.Hunt);
		availablePassList[Index] = _l2PassData.EL2PassType.Hunt;
		Index++;
	}
	if(_advancePassInfo.isOn == true)
	{
		tabGroupButton._GetGroupButtonsInstance()._setButtonText(Index, GetSystemString(5945));
		tabGroupButton._GetGroupButtonsInstance()._setButtonValue(Index, _l2PassData.EL2PassType.Advance);
		availablePassList[Index] = _l2PassData.EL2PassType.Advance;
		Index++;
	}
	tabGroupButton._GetGroupButtonsInstance()._setShowButtonNum(Index);
	tabGroupButton._GetGroupButtonsInstance()._setAutoWidth(windowSizeWidth - tabGroupOffsetX, 0);

	if(availablePassList.Length > 0)
	{
		validSelectedTab = false;

		for(i = 0; i < availablePassList.Length; i++)
		{
			if(_selectedPassType == availablePassList[i])
			{
				validSelectedTab = true;
				break;
			}
		}
		if(validSelectedTab == false)
		{
			tabGroupButton._GetGroupButtonsInstance()._setTopOrder(0);
			SetPassStepPage(availablePassList[0]);
		}
	}
	UpdateTabGroupRewardAlarm();
}

function UpdateHuntPassControls()
{
	local int i, infoLength;

	infoLength = _huntPassInfo.stepInfos.Length;

	for(i = 0; i < SHOW_STEP_PER_PAGE; i++)
	{
		if(i < _huntPassInfo.stepInfos.Length)
		{
			huntStepNormalComponents[i]._SetStepInfo(_huntPassInfo.stepInfos[i]);
			huntStepPremiumComponents[i]._SetStepInfo(_huntPassInfo.premiumStepInfos[i]);
			huntStepProgressComponents[i]._SetProgressInfo(_huntPassInfo.stepInfos[i]);
			continue;
		}
		huntStepNormalComponents[i]._SetDisable(true);
		huntStepPremiumComponents[i]._SetDisable(true);
		huntStepProgressComponents[i]._SetDisable(true);
	}
	SetPageNaviMaxPage(_huntPassInfo.maxStepPage);
	SetPageNaviCurrentPage(_huntPassInfo.currentStepPage);

	if(_huntPassInfo.maxStepPage == 1)
	{
		huntStepPrevBtn.SetEnable(false);
		huntStepNextBtn.SetEnable(false);
	}
	else if(_huntPassInfo.currentStepPage == _huntPassInfo.maxStepPage)
	{
		huntStepPrevBtn.SetEnable(true);
		huntStepNextBtn.SetEnable(false);
	}
	else if(_huntPassInfo.currentStepPage == 1)
	{
		huntStepPrevBtn.SetEnable(false);
		huntStepNextBtn.SetEnable(true);
	} else {
		huntStepPrevBtn.SetEnable(true);
		huntStepNextBtn.SetEnable(true);
	}
}

function UpdateAdvancePassControls()
{
	local int i, infoLength;
	local ItemInfo RewardItemInfo;

	infoLength = _advancePassInfo.stepInfos.Length;

	for(i = 0; i < SHOW_STEP_PER_PAGE; i++)
	{
		if(i < _advancePassInfo.stepInfos.Length)
		{
			advanceStepComponents[i]._SetStepInfo(_advancePassInfo.stepInfos[i]);
			advanceStepProgressComponents[i]._SetProgressInfo(_advancePassInfo.stepInfos[i]);
			continue;
		}
		advanceStepComponents[i]._SetDisable(true);
		advanceStepProgressComponents[i]._SetDisable(true);
	}
	SetPageNaviMaxPage(_advancePassInfo.maxStepPage);
	SetPageNaviCurrentPage(_advancePassInfo.currentStepPage);

	if(_advancePassInfo.maxStepPage == 1)
	{
		advanceStepPrevBtn.SetEnable(false);
		advanceStepNextBtn.SetEnable(false);
	}
	else if(_advancePassInfo.currentStepPage == _advancePassInfo.maxStepPage)
	{
		advanceStepPrevBtn.SetEnable(true);
		advanceStepNextBtn.SetEnable(false);
	}
	else if(_advancePassInfo.currentStepPage == 1)
	{
		advanceStepPrevBtn.SetEnable(false);
		advanceStepNextBtn.SetEnable(true);
	} else {
		advanceStepPrevBtn.SetEnable(true);
		advanceStepNextBtn.SetEnable(true);
	}
	RewardItemInfo = GetItemInfoByClassID(GetL2PassLastItem(_l2PassData.EL2PassType.Advance, true));
	advanceFinalRewardItem.Clear();
	advanceFinalRewardItem.AddItem(RewardItemInfo);
}

function UpdateSayhasSupportControls()
{
	local TextBoxHandle leftTimeTextBox, maxTimeTextBox, usedTimeTextBox, earnedTimeTextBox;
	local bool isOn;
	local TextureHandle onBtnTexture, sayhasIconTexture, tooltipSayhasIcon, tooltipSayhasLiveIcon;
	local string containerFullPath, tooltipFullPath;
	local int LeftTime, earnedTime, usedTime, timerTime;

	timerTime = _sayhasTimerCount * 60;
	earnedTime = _sayhasSupportInfo.earnedTime;
	usedTime = _sayhasSupportInfo.usedTime + timerTime;
	LeftTime = earnedTime - usedTime;

	if(_huntPassInfo.isOn == false)
	{
		sayhasSupportContainer.HideWindow();
		ShowSayhasInfoTooltip(false);
		return;
	}
	containerFullPath = sayhasSupportContainer.m_WindowNameWithFullPath;
	tooltipFullPath = sayhasInfoTooltipWnd.m_WindowNameWithFullPath;
	onBtnTexture = GetTextureHandle(containerFullPath $ ".SayhasStateIcon_Texture");
	sayhasIconTexture = GetTextureHandle(containerFullPath $ ".SayhasIcon_texture");

	if(getInstanceUIData().getIsLiveServer())
	{
		sayhasIconTexture.SetTexture("L2UI_NewTex.SideBar.SideBar_VPGreenIcon");
	} else {
		sayhasIconTexture.SetTexture("L2UI_NewTex.SideBar.SideBar_VPIcon");
	}
	isOn = _sayhasSupportInfo.isOn;

	if(isOn == true)
	{
		if(onBtnTexture.GetTextureName() == "L2UI_ct1.OlympiadWnd.ONICON")
		{
		}
		else
		{
			onBtnTexture.SetTexture("L2UI_ct1.OlympiadWnd.ONICON");
		}		
	}
	else
	{
		onBtnTexture.SetTexture("L2UI_ct1.OlympiadWnd.OFFICON");
	}
	maxTimeTextBox = GetTextBoxHandle(tooltipFullPath $ ".MaxTime_text");
	leftTimeTextBox = GetTextBoxHandle(containerFullPath $ ".SayhasTime_text");
	earnedTimeTextBox = GetTextBoxHandle(tooltipFullPath $ ".MyGetTime_text");
	usedTimeTextBox = GetTextBoxHandle(tooltipFullPath $ ".MyUseTime_text");
	tooltipSayhasIcon = GetTextureHandle(tooltipFullPath $ ".ICON_texture");
	tooltipSayhasLiveIcon = GetTextureHandle(tooltipFullPath $ ".ICONLive_texture");
	maxTimeTextBox.SetText(GetSayhasTimeText(_sayhasSupportInfo.maxTIme));
	leftTimeTextBox.SetText(GetSayhasTimeText(LeftTime));
	earnedTimeTextBox.SetText(GetSayhasTimeText(earnedTime));
	usedTimeTextBox.SetText(GetSayhasTimeText(usedTime));

	if(getInstanceUIData().getIsLiveServer())
	{
		tooltipSayhasIcon.HideWindow();
		tooltipSayhasLiveIcon.ShowWindow();
	} else {
		tooltipSayhasIcon.ShowWindow();
		tooltipSayhasLiveIcon.HideWindow();
	}
	sayhasSupportContainer.ShowWindow();
}

function UpdatePremiumBtnControls()
{
	local bool isPremiumActivated;
	local int costItemID, costItemCnt;

	GetL2PassPremiumPassCost(_selectedPassType, costItemID, costItemCnt);

	if(costItemID == 0 && costItemCnt == 0)
	{
		premiumPurchaseBtn.HideWindow();
	} else {
		premiumPurchaseBtn.ShowWindow();
	}
	isPremiumActivated = GetPassInfo(_selectedPassType).isPremiumActivated;

	if(isPremiumActivated == true)
	{
		premiumPurchaseBtn.SetNameText(GetSystemString(5951));
		premiumPurchaseBtn.SetEnable(false);
	} else {
		premiumPurchaseBtn.SetNameText(GetSystemString(5950));
		premiumPurchaseBtn.SetEnable(true);
	}
}

function UpdateGetAllBtnControls()
{
	local int notReceivedRewardNum;

	notReceivedRewardNum = GetPassInfo(_selectedPassType).notReceivedRewardNum;

	if(notReceivedRewardNum > 0)
	{
		getRewardBtn.SetEnable(true);
	} else {
		getRewardBtn.SetEnable(false);
	}
}

function UpdatePassInfoControls()
{
	local TextBoxHandle passTitleBox, passEndTimeTextBox, passInfoTitleBox, maxStepTitleBox, currentStepTitleBox, maxStepValueBox, currentStepValueBox, passEndTimeUntilTextBox;

	local string containerFullPath;
	local ButtonHandle helpBtn;
	local int maxStepValue, currentStepValue;

	containerFullPath = passInfoContainer.m_WindowNameWithFullPath;
	passTitleBox = GetTextBoxHandle(m_WindowName $ ".HuntPassTimeTitle_text");
	passEndTimeTextBox = GetTextBoxHandle(m_WindowName $ ".SeasonTime_text");
	passEndTimeUntilTextBox = GetTextBoxHandle(m_WindowName $ ".SeasonUntil_text");
	passInfoTitleBox = GetTextBoxHandle(containerFullPath $ ".PassInfoTitle_text");
	maxStepTitleBox = GetTextBoxHandle(containerFullPath $ ".AllPassNumTitle_text");
	currentStepTitleBox = GetTextBoxHandle(containerFullPath $ ".MyPassNumTitle_text");
	maxStepValueBox = GetTextBoxHandle(containerFullPath $ ".AllPassNum_text");
	currentStepValueBox = GetTextBoxHandle(containerFullPath $ ".MyPassNum_text");
	helpBtn = GetButtonHandle(containerFullPath $ ".Help_btn");

	if(_selectedPassType == _l2PassData.EL2PassType.Hunt)
	{
		maxStepValue = _huntPassInfo.maxStep * _huntPassInfo.maxMissionCnt;
		currentStepValue = Min(_huntPassInfo.currentStep * _huntPassInfo.maxMissionCnt + _huntPassInfo.currentMissionCnt, maxStepValue);

		if(GetLanguage() == LANG_Russia || GetLanguage() == LANG_Euro || GetLanguage() == LANG_English)
		{
			passEndTimeTextBox.SetText(GetSystemString(5976) $ " : ");
			passEndTimeUntilTextBox.SetText(GetPassEndTimeText(_huntPassInfo.LeftTime));
		} else {
			passEndTimeTextBox.SetText(GetPassEndTimeText(_huntPassInfo.LeftTime));
		}
		passTitleBox.SetText(GetSystemString(5944));
		passInfoTitleBox.SetText(GetSystemString(5946));
		maxStepTitleBox.SetText(GetSystemString(5947));
		currentStepTitleBox.SetText(GetSystemString(5948));
		maxStepValueBox.SetText(MakeCostString(string(maxStepValue)));
		currentStepValueBox.SetText(MakeCostString(string(currentStepValue)));
		helpBtn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(5971)));
	}
	else if(_selectedPassType == _l2PassData.EL2PassType.Advance)
	{
		maxStepValue = _advancePassInfo.maxStep * _advancePassInfo.maxMissionCnt;
		currentStepValue = Min((_advancePassInfo.currentStep * _advancePassInfo.maxMissionCnt) + _advancePassInfo.currentMissionCnt, maxStepValue);

		if(GetLanguage() == LANG_Russia || GetLanguage() == LANG_Euro || GetLanguage() == LANG_English)
		{
			passEndTimeTextBox.SetText(GetSystemString(5976) $ " : ");
			passEndTimeUntilTextBox.SetText(GetPassEndTimeText(_huntPassInfo.LeftTime));
		} else {
			passEndTimeTextBox.SetText(GetPassEndTimeText(_advancePassInfo.LeftTime));
		}
		passTitleBox.SetText(GetSystemString(5945));
		passInfoTitleBox.SetText(GetSystemString(5952));
		maxStepTitleBox.SetText(GetSystemString(5953));
		currentStepTitleBox.SetText(GetSystemString(5954));
		maxStepValueBox.SetText(MakeCostString(string(maxStepValue)));
		currentStepValueBox.SetText(MakeCostString(string(currentStepValue)));
		helpBtn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(5974)));
	}
}

function UpdateUIControls()
{
	if(Me.IsShowWindow() == false)
	{
		return;
	}
	UpdatePassTabGroupButton();

	if(_selectedPassType == _l2PassData.EL2PassType.Hunt)
	{
		UpdateHuntPassControls();
	}
	else if(_selectedPassType == _l2PassData.EL2PassType.Advance)
	{
		UpdateAdvancePassControls();
	}
	UpdateGetAllBtnControls();
	UpdateSayhasSupportControls();
	UpdatePremiumBtnControls();
	UpdatePassInfoControls();
}

function UpdateHuntPassStepInfo()
{
	local int startIndex, endIndex, i;
	local array<L2PassRewardData> rewardDataList;
	local L2PassRewardData rewardData;

	startIndex = ((_huntPassInfo.currentStepPage - 1) * SHOW_STEP_PER_PAGE) + 1;
	endIndex = Min(_huntPassInfo.maxStep, (startIndex + SHOW_STEP_PER_PAGE) - 1);
	_huntPassInfo.stepInfos.Length = 0;
	_huntPassInfo.premiumStepInfos.Length = 0;
	GetL2PassReward(_l2PassData.EL2PassType.Hunt, startIndex, endIndex, rewardDataList);
	_huntPassInfo.notReceivedRewardNum = _huntPassInfo.currentStep - _huntPassInfo.rewardStep;

	if(_huntPassInfo.isPremiumActivated == true)
	{
		_huntPassInfo.notReceivedRewardNum += (_huntPassInfo.currentStep - _huntPassInfo.premiumRewardStep);
	}

	for(i = 0; i < rewardDataList.Length; i++)
	{
		rewardData = rewardDataList[i];
		_huntPassInfo.stepInfos[i] = MakeStepInfo(rewardData.RewardIndex, _l2PassData.EL2PassType.Hunt, false, _huntPassInfo.isPremiumActivated, rewardData.FreeRewardType, rewardData.FreeRewardItemID, rewardData.FreeRewardItemCnt, _huntPassInfo.rewardStep, _huntPassInfo.currentStep, _huntPassInfo.currentMissionCnt, _huntPassInfo.maxMissionCnt);
		_huntPassInfo.premiumStepInfos[i] = MakeStepInfo(rewardData.RewardIndex, _l2PassData.EL2PassType.Hunt, true, _huntPassInfo.isPremiumActivated, rewardData.PaidRewardType, rewardData.PaidRewardItemID, rewardData.PaidRewardItemCnt, _huntPassInfo.premiumRewardStep, _huntPassInfo.currentStep, _huntPassInfo.currentMissionCnt, _huntPassInfo.maxMissionCnt);
	}
}

function UpdateAdvancePassStepInfo()
{
	local int startIndex, endIndex, i;
	local array<L2PassRewardData> rewardDataList;
	local L2PassRewardData rewardData;
	local bool isPremiumStep;
	local int rewardItemType, RewardItemID, rewardItemCnt;

	startIndex = ((_advancePassInfo.currentStepPage - 1) * 10) + 1;
	endIndex = Min(_advancePassInfo.maxStep, (startIndex + 10) - 1);
	_advancePassInfo.stepInfos.Length = 0;
	_advancePassInfo.premiumStepInfos.Length = 0;
	GetL2PassReward(_l2PassData.EL2PassType.Advance, startIndex, endIndex, rewardDataList);
	_advancePassInfo.notReceivedRewardNum = Min(_advancePassInfo.currentStep, _advancePassInfo.freeStepNum) - _advancePassInfo.rewardStep;

	if(_advancePassInfo.isPremiumActivated == true)
	{
		if(_advancePassInfo.freeStepNum < _advancePassInfo.currentStep)
		{
			_advancePassInfo.notReceivedRewardNum += ((_advancePassInfo.currentStep - _advancePassInfo.freeStepNum) - _advancePassInfo.premiumRewardStep);
		}
	}
	if(_huntPassInfo.isPremiumActivated == true)
	{
		_huntPassInfo.notReceivedRewardNum += (_huntPassInfo.currentStep - _huntPassInfo.premiumRewardStep);
	}

	for(i = 0; i < rewardDataList.Length; i++)
	{
		rewardData = rewardDataList[i];

		if(rewardData.PaidRewardItemCnt > 0)
		{
			isPremiumStep = true;
		}
		if(isPremiumStep == true)
		{
			rewardItemType = rewardData.PaidRewardType;
			RewardItemID = rewardData.PaidRewardItemID;
			rewardItemCnt = rewardData.PaidRewardItemCnt;
		} else {
			rewardItemType = rewardData.FreeRewardType;
			RewardItemID = rewardData.FreeRewardItemID;
			rewardItemCnt = rewardData.FreeRewardItemCnt;
		}
		_advancePassInfo.stepInfos[i] = MakeStepInfo(rewardData.RewardIndex, _l2PassData.EL2PassType.Advance, isPremiumStep, _advancePassInfo.isPremiumActivated, rewardItemType, RewardItemID, rewardItemCnt, _advancePassInfo.rewardStep + _advancePassInfo.premiumRewardStep, _advancePassInfo.currentStep, _advancePassInfo.currentMissionCnt, _advancePassInfo.maxMissionCnt);
	}
}

function L2PassData.L2PassStepInfo MakeStepInfo(int Index, L2PassData.EL2PassType PassType, bool IsPremium, bool isPremiumActivated, int rewardType, int RewardItemID, int rewardItemCnt, int rewardStep, int currentStep, int currentMissionCnt, int missionMaxCnt)
{
	local L2PassData.L2PassStepInfo stepInfo;

	stepInfo.Index = Index;
	stepInfo.isPremiumActivated = isPremiumActivated;
	stepInfo.isPremiumStep = IsPremium;
	stepInfo.missionMaxCnt = missionMaxCnt;
	stepInfo.PassType = PassType;
	stepInfo.rewardType = rewardType;
	stepInfo.RewardItemID = RewardItemID;
	stepInfo.rewardItemCnt = rewardItemCnt;
	stepInfo.stepState = GetStepState(Index, rewardStep, currentStep);

	if(stepInfo.stepState == _l2PassData.EL2PassStepState.InProgress)
	{
		stepInfo.missionCnt = currentMissionCnt;
	}
	else if(stepInfo.stepState == _l2PassData.EL2PassStepState.NotInProgress)
	{
		stepInfo.missionCnt = 0;
	} else {
		stepInfo.missionCnt = missionMaxCnt;
	}
	return stepInfo;
}

function SetPassInfoDefaultCurrentStepPage(L2PassData.EL2PassType PassType)
{
	if(PassType == _l2PassData.EL2PassType.Hunt)
	{
		_huntPassInfo.currentStepPage = Max(appCeil(float(_huntPassInfo.currentStep + 1) / SHOW_STEP_PER_PAGE), 1);

		if(_huntPassInfo.currentStepPage > _huntPassInfo.maxStepPage)
		{
			_huntPassInfo.currentStepPage = _huntPassInfo.maxStepPage;
		}
	}
	else if(PassType == _l2PassData.EL2PassType.Advance)
	{
		_advancePassInfo.currentStepPage = Max(appCeil(float(_advancePassInfo.currentStep + 1) / SHOW_STEP_PER_PAGE), 1);

		if(_advancePassInfo.currentStepPage > _advancePassInfo.maxStepPage)
		{
			_advancePassInfo.currentStepPage = _advancePassInfo.maxStepPage;
		}
	}
}

function string GetSayhasTimeText(int Time)
{
	local L2Util util;

	util = L2Util(GetScript("L2Util"));

	if(Time <= 0)
	{
		return "-";
	}
	else if(Time < 60)
	{
		return MakeFullSystemMsg(GetSystemMessage(4360), string(1));
	} else {
		return util.getTimeStringBySec(Time, true, true);
	}
}

function string GetPassEndTimeText(int EndTime)
{
	local L2UITime uiTime;
	local string TimeText;

	GetTimeStruct(EndTime, uiTime);

	if(GetLanguage() == LANG_Russia || GetLanguage() == LANG_Euro)
	{
		TimeText = string(uiTime.nDay) @ "/" @ string(uiTime.nMonth) @ "/" @ string(uiTime.nYear);
	}
	else if(GetLanguage() == LANG_English)
	{
		TimeText = string(uiTime.nMonth) @ "/" @ string(uiTime.nDay) @ "/" @ string(uiTime.nYear);
	} else {
		TimeText = string(uiTime.nYear) $ GetSystemString(3847) @ string(uiTime.nMonth) $ GetSystemString(3848) @ string(uiTime.nDay) $ GetSystemString(1109);
	}
	return TimeText;
}

function L2PassData.EL2PassStepState GetStepState(int Index, int rewardStep, int currentStep)
{
	local int validCurrentStep;

	validCurrentStep = currentStep + 1;

	if(validCurrentStep == Index)
	{
		return _l2PassData.EL2PassStepState.InProgress;
	}
	else if(validCurrentStep < Index)
	{
		return _l2PassData.EL2PassStepState.NotInProgress;
	}
	if(validCurrentStep > Index)
	{
		if(rewardStep > (Index - 1))
		{
			return _l2PassData.EL2PassStepState.CompleteRewarded;
		}
		else if(rewardStep == Index - 1)
		{
			return _l2PassData.EL2PassStepState.CompleteRewardReady;
		} else {
			return _l2PassData.EL2PassStepState.CompleteNotRewardStep;
		}
	}
}

function L2PassData.L2PassInfo GetPassInfo(L2PassData.EL2PassType PassType)
{
	local L2PassData.L2PassInfo emptyInfo;

	if(PassType == _l2PassData.EL2PassType.Hunt)
	{
		return _huntPassInfo;
	}
	else if(PassType == _l2PassData.EL2PassType.Advance)
	{
		return _advancePassInfo;
	}
	return emptyInfo;
}

function bool CheckValidPassSceneState(L2PassData.EL2PassType PassType)
{
	if(_selectedPassType != PassType)
	{
		return false;
	}
	if(PassType == _l2PassData.EL2PassType.Hunt)
	{
		if(_huntPassInfo.isOn == false)
		{
			return false;
		}
		if(huntPassContainer.IsShowWindow() == false)
		{
			return false;
		}
	}
	else if(PassType == _l2PassData.EL2PassType.Advance)
	{
		if(_advancePassInfo.isOn == false)
		{
			return false;
		}
		if(advancePassContainer.IsShowWindow() == false)
		{
			return false;
		}
	}
	return true;
}

function SetSideBarMenu(bool isOn, bool isAlarm)
{
	local int sidebarTypeIndex;

	if(getInstanceUIData().getIsLiveServer())
	{
		sidebarTypeIndex = SideBarScript.SIDEBAR_WINDOWS.TYPE_L2PASS_LIVE;
	} else {
		sidebarTypeIndex = SideBarScript.SIDEBAR_WINDOWS.TYPE_L2PASS;
	}

	if(isOn == true)
	{
		SideBarScript.SetWindowShowHideByIndex(sidebarTypeIndex, true);

		if(isAlarm == true)
		{
			SideBarScript.SetAlarmOnOff(sidebarTypeIndex, true);
		} else {
			SideBarScript.SetAlarmOnOff(sidebarTypeIndex, false);
		}
	} else {
		SideBarScript.SetWindowShowHideByIndex(sidebarTypeIndex, false);
	}
}

function StartSyhasTimer()
{
	KIllSyhasTimer();
	Me.SetTimer(TIMER_ID_SAYHAS, TIMER_DELAY_SAYHAS);
}

function KIllSyhasTimer()
{
	Me.KillTimer(TIMER_ID_SAYHAS);
	_sayhasTimerCount = 0;
}

function StartBtnDelayTimer()
{
	_isWaitingBtnDelay = true;
	Me.SetTimer(TIMER_ID_BTN_DELAY, TIMER_DELAY_BTN_DISABLE);
}

function KillBtnDelayTimer()
{
	Me.KillTimer(TIMER_ID_BTN_DELAY);
	_isWaitingBtnDelay = false;
}

function StopAllAnimations()
{
	local int i;

	sayhasIconEffectAnimTexture.Stop();

	for(i = 0; i < huntStepNormalComponents.Length; i++)
	{
		huntStepNormalComponents[i]._StopAllAnimations();
	}

	for(i = 0; i < huntStepPremiumComponents.Length; i++)
	{
		huntStepPremiumComponents[i]._StopAllAnimations();
	}

	for(i = 0; i < advanceStepComponents.Length; i++)
	{
		advanceStepComponents[i]._StopAllAnimations();
	}
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

event OnShow()
{
	UpdateUIControls();
	tabGroupButton._GetGroupButtonsInstance()._setTopOrder(0);
	ShowSayhasInfoTooltip(false);
	ShowPremiumPurchaseDialog(false, _l2PassData.EL2PassType.Max);
	ShowAdvancePassDetailInfoWnd(false);
	ShowTotalRewardInfoDialog(false, _l2PassData.EL2PassType.Max);
	KillBtnDelayTimer();
	SideBarScript.ToggleByWindowName(m_WindowName, true);
	Rq_C_EX_L2PASS_INFO(_l2PassData.EL2PassType.Hunt);
	Rq_C_EX_L2PASS_INFO(_l2PassData.EL2PassType.Advance);
}

event OnHide()
{
	SideBarScript.ToggleByWindowName(m_WindowName, false);
	KIllSyhasTimer();
	KillBtnDelayTimer();
	StopAllAnimations();
}

event OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID_SAYHAS)
	{
		_sayhasTimerCount++;
		UpdateSayhasSupportControls();
	}
	else if(TimerID == TIMER_ID_BTN_DELAY)
	{
		KillBtnDelayTimer();
	}
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_L2PASS_SIMPLE_INFO));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_L2PASS_INFO));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_SAYHAS_SUPPORT_INFO));
	RegisterEvent(EV_GotoWorldRaidServer);
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(class'UIPacket'.const.S_EX_L2PASS_SIMPLE_INFO):
			Nt_S_EX_L2PASS_SIMPLE_INFO();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_L2PASS_INFO):
			Rs_S_EX_L2PASS_INFO();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_SAYHAS_SUPPORT_INFO):
			Rs_S_EX_SAYHAS_SUPPORT_INFO();
			break;
		case EV_GotoWorldRaidServer:
			SetSideBarMenu(false, false);
			break;
	}
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "SayhasONOFF_BTN":
			OnSayhasOnOffBtnClicked();
			break;
		case "TimeHelp_btn":
			OnSayhasTooltipBtnClicked();
			break;
		case "AdvanceItmeList_BTN":
			OnAdvancePassInfoClicked();
			break;
		case "PremiumActive_BTN":
			OnPremiumPurchaseBtnClicked();
			break;
		case "GetReward_BTN":
			OnGetAllBtnClicked();
			break;
		case "Refresh_Btn":
			OnRefreshBtnClicked();
			break;
		case "RewardList_Btn":
			OnTotalRewardInfoBtnClicked();
			break;
		case "AdvanceItmeList_BTN":
			OnAdvancePassInfoClicked();
			break;
		case "ControlNaviHunt_PrevBtn":
			OnPassPageStepperClicked(_l2PassData.EL2PassType.Hunt, false);
			break;
		case "ControlNaviHunt_NextBtn":
			OnPassPageStepperClicked(_l2PassData.EL2PassType.Hunt, true);
			break;
		case "ControlNaviAdvance_PrevBtn":
			OnPassPageStepperClicked(_l2PassData.EL2PassType.Advance, false);
			break;
		case "ControlNaviAdvance_NextBtn":
			OnPassPageStepperClicked(_l2PassData.EL2PassType.Advance, true);
			break;
		case "FrameHelp_BTN":
			OnL2PassHelpBtnClicked();
			break;
	}
}

event OnSayhasOnOffBtnClicked()
{
	if(_huntPassInfo.isOn == true && _isWaitingBtnDelay == false)
	{
		StartBtnDelayTimer();
		Rq_C_EX_SAYHAS_SUPPORT_TOGGLE(!_sayhasSupportInfo.isOn);
	}
}

event OnSayhasTooltipBtnClicked()
{
	ShowSayhasInfoTooltip(!sayhasInfoTooltipWnd.IsShowWindow());
}

event OnPremiumPurchaseBtnClicked()
{
	if(_selectedPassType == _l2PassData.EL2PassType.Hunt)
	{
		if(_huntPassInfo.isPremiumActivated == false)
		{
			ShowPremiumPurchaseDialog(true, _l2PassData.EL2PassType.Hunt, false);
		}
	}
	else if(_selectedPassType == _l2PassData.EL2PassType.Advance)
	{
		if(_advancePassInfo.isPremiumActivated == false)
		{
			ShowPremiumPurchaseDialog(true, _l2PassData.EL2PassType.Advance, false);
		}
	}
}

event OnGetAllBtnClicked()
{
	if(_isWaitingBtnDelay == true)
	{
		return;
	}
	StartBtnDelayTimer();
	Rq_C_EX_L2PASS_REQUEST_REWARD_ALL(_selectedPassType);
}

event OnRefreshBtnClicked()
{
	Rq_C_EX_L2PASS_INFO(_l2PassData.EL2PassType.Hunt);
	Rq_C_EX_L2PASS_INFO(_l2PassData.EL2PassType.Advance);
}

event OnTotalRewardInfoBtnClicked()
{
	ShowTotalRewardInfoDialog(true, _selectedPassType);
}

event OnAdvancePassInfoClicked()
{
	ShowAdvancePassDetailInfoWnd(!advancePassDetailInfoWnd.IsShowWindow());
}

event OnPremiumPurchasePopupCancel()
{
	ShowPremiumPurchaseDialog(false, _l2PassData.EL2PassType.Max);
}

event OnPremiumPurchasePopupConfirm()
{
	if(_isWaitingBtnDelay == true)
	{
		return;
	}
	if(_isConfirmTypePurchaseDialog == true)
	{
		StartBtnDelayTimer();
		Rq_C_EX_L2PASS_BUY_PREMIUM(_selectedPassType);
		ShowPremiumPurchaseDialog(false, _l2PassData.EL2PassType.Max);
	} else {
		ShowPremiumPurchaseDialog(true, _selectedPassType, true);
	}
}

event OnTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	ShowSayhasInfoTooltip(false);
	SetPassStepPage(EL2PassType(Index));
}

event OnStepClicked(L2PassWndStepComponent Owner)
{
	if(Owner._stepState == _l2PassData.EL2PassStepState.CompleteRewardReady)
	{
		if(Owner._isPremiumStep == true && Owner._isPremiumActivated == false)
		{
			return;
		}
		if(CheckValidPassSceneState(Owner._passType))
		{
			if(_isWaitingBtnDelay == true)
			{
				return;
			}
			StartBtnDelayTimer();
			Rq_C_EX_L2PASS_REQUEST_REWARD(Owner._passType, Owner._isPremiumStep);
		}
	}
}

event OnPageNaviChanged(int Page)
{
	if(_selectedPassType == _l2PassData.EL2PassType.Hunt)
	{
		_huntPassInfo.currentStepPage = Page;
		UpdateHuntPassStepInfo();
	}
	else if(_selectedPassType == _l2PassData.EL2PassType.Advance)
	{
		_advancePassInfo.currentStepPage = Page;
		UpdateAdvancePassStepInfo();
	}
	UpdateUIControls();
}

event OnPageNaviClicked(string buttonName)
{
}

event OnPassPageStepperClicked(L2PassData.EL2PassType PassType, bool isNext)
{
	local int targetPage;

	targetPage = GetPassInfo(PassType).currentStepPage;

	if(isNext == true)
	{
		targetPage++;
	} else {
		targetPage--;
	}
	if(PassType == _l2PassData.EL2PassType.Hunt)
	{
		_huntPassInfo.currentStepPage = targetPage;
		UpdateHuntPassStepInfo();
	}
	else if(PassType == _l2PassData.EL2PassType.Advance)
	{
		_advancePassInfo.currentStepPage = targetPage;
		UpdateAdvancePassStepInfo();
	}
	UpdateUIControls();
}

event OnL2PassHelpBtnClicked()
{
	local string strParam;

	ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "g_l2pass_help.htm");
	ExecuteEvent(EV_ShowHelp, strParam);
}

function Rq_C_EX_L2PASS_INFO(L2PassData.EL2PassType PassType)
{
	local array<byte> stream;
	local UIPacket._C_EX_L2PASS_INFO packet;

	if(GetPassInfo(PassType).isOn == false)
	{
		return;
	}
	packet.cPassType = PassType;

	if(!class'UIPacket'.static.Encode_C_EX_L2PASS_INFO(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_L2PASS_INFO, stream);
}

function Rq_C_EX_L2PASS_REQUEST_REWARD(L2PassData.EL2PassType PassType, bool IsPremium)
{
	local array<byte> stream;
	local UIPacket._C_EX_L2PASS_REQUEST_REWARD packet;

	if(GetPassInfo(PassType).isOn == false)
	{
		return;
	}
	packet.cPassType = PassType;
	packet.bPremium = byte(IsPremium);

	if(!class'UIPacket'.static.Encode_C_EX_L2PASS_REQUEST_REWARD(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_L2PASS_REQUEST_REWARD, stream);
}

function Rq_C_EX_L2PASS_REQUEST_REWARD_ALL(L2PassData.EL2PassType PassType)
{
	local array<byte> stream;
	local UIPacket._C_EX_L2PASS_REQUEST_REWARD_ALL packet;

	if(GetPassInfo(PassType).isOn == false)
	{
		return;
	}
	packet.cPassType = PassType;

	if(!class'UIPacket'.static.Encode_C_EX_L2PASS_REQUEST_REWARD_ALL(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_L2PASS_REQUEST_REWARD_ALL, stream);
}

function Rq_C_EX_L2PASS_BUY_PREMIUM(L2PassData.EL2PassType PassType)
{
	local array<byte> stream;
	local UIPacket._C_EX_L2PASS_BUY_PREMIUM packet;

	if(GetPassInfo(PassType).isPremiumActivated == true)
	{
		return;
	}
	packet.cPassType = PassType;

	if(!class'UIPacket'.static.Encode_C_EX_L2PASS_BUY_PREMIUM(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_L2PASS_BUY_PREMIUM, stream);
}

function Rq_C_EX_SAYHAS_SUPPORT_TOGGLE(bool isOn)
{
	local array<byte> stream;
	local UIPacket._C_EX_SAYHAS_SUPPORT_TOGGLE packet;

	packet.bIsOn = byte(isOn);

	if(!class'UIPacket'.static.Encode_C_EX_SAYHAS_SUPPORT_TOGGLE(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SAYHAS_SUPPORT_TOGGLE, stream);
}

function Nt_S_EX_L2PASS_SIMPLE_INFO()
{
	local UIPacket._S_EX_L2PASS_SIMPLE_INFO packet;
	local int i;
	local bool isOn;
	local UIPacket._PkL2PassInfo passInfo;

	if(!class'UIPacket'.static.Decode_S_EX_L2PASS_SIMPLE_INFO(packet))
	{
		return;
	}
	_isAvailableReward = bool(packet.bAvailableReward);
	_advanceCondIndex = packet.condIndex;
	isOn = false;

	for(i = 0; i < packet.passInfos.Length; i++)
	{
		passInfo = packet.passInfos[i];

		if(bool(passInfo.bIsOn) == true)
		{
			isOn = true;
		}
		if(passInfo.cPassType == _l2PassData.EL2PassType.Hunt)
		{
			_huntPassInfo.isOn = bool(passInfo.bIsOn);
			UpdateHuntPassStepInfo();
			continue;
		}
		if(passInfo.cPassType == _l2PassData.EL2PassType.Advance)
		{
			_advancePassInfo.isOn = bool(passInfo.bIsOn);
			UpdateAdvancePassStepInfo();
		}
	}
	SetSideBarMenu(isOn, bool(packet.bAvailableReward));
	UpdateUIControls();
}

function Rs_S_EX_L2PASS_INFO()
{
	local UIPacket._S_EX_L2PASS_INFO packet;

	if(!class'UIPacket'.static.Decode_S_EX_L2PASS_INFO(packet))
	{
		return;
	}
	if(packet.cPassType == _l2PassData.EL2PassType.Hunt)
	{
		_huntPassInfo.isPremiumActivated = bool(packet.bIsPremium);
		_huntPassInfo.currentMissionCnt = packet.nCurCount;
		_huntPassInfo.LeftTime = packet.nLeftTime;
		_huntPassInfo.premiumRewardStep = packet.nPremiumRewardStep;
		_huntPassInfo.rewardStep = packet.nRewardStep;
		_huntPassInfo.currentStep = packet.nCurStep;
		UpdateHuntPassStepInfo();
	}
	else if(packet.cPassType == _l2PassData.EL2PassType.Advance)
	{
		_advancePassInfo.isPremiumActivated = bool(packet.bIsPremium);
		_advancePassInfo.currentMissionCnt = packet.nCurCount;
		_advancePassInfo.LeftTime = packet.nLeftTime;
		_advancePassInfo.premiumRewardStep = packet.nPremiumRewardStep;
		_advancePassInfo.rewardStep = packet.nRewardStep;
		_advancePassInfo.currentStep = packet.nCurStep;

		if(_isFirstPacket == true)
		{
			if(_advancePassInfo.maxStep == _advancePassInfo.rewardStep + _advancePassInfo.premiumRewardStep)
			{
				_advanceLastRewardReceived = true;
			} else {
				_advanceLastRewardReceived = false;
			}
		}
		else if(_advanceLastRewardReceived == false)
		{
			if(_advancePassInfo.maxStep == _advancePassInfo.rewardStep + _advancePassInfo.premiumRewardStep)
			{
				_advanceLastRewardReceived = true;
				ShowEffectResult(true);
			}
		}
		UpdateAdvancePassStepInfo();
	}

	UpdateUIControls();

	if(_isFirstPacket == true)
	{
		SetPassInfoDefaultCurrentStepPage(_selectedPassType);
	}
	_isFirstPacket = false;
}

function Rs_S_EX_SAYHAS_SUPPORT_INFO()
{
	local UIPacket._S_EX_SAYHAS_SUPPORT_INFO packet;
	local bool earnedTimeChanged;

	earnedTimeChanged = false;

	if(!class'UIPacket'.static.Decode_S_EX_SAYHAS_SUPPORT_INFO(packet))
	{
		return;
	}
	if(_sayhasSupportInfo.earnedTime < packet.nTimeEarned)
	{
		earnedTimeChanged = true;
	}
	_sayhasSupportInfo.isOn = bool(packet.bIsOn);
	_sayhasSupportInfo.earnedTime = packet.nTimeEarned;
	_sayhasSupportInfo.usedTime = packet.nTimeUsed;

	if(Me.IsShowWindow() == true)
	{
		if(_sayhasSupportInfo.isOn == true)
		{
			StartSyhasTimer();
		} else {
			KIllSyhasTimer();
		}
		if(earnedTimeChanged == true)
		{
			sayhasIconEffectAnimTexture.Stop();
			sayhasIconEffectAnimTexture.SetLoopCount(1);
			sayhasIconEffectAnimTexture.Play();
		}
		UpdateSayhasSupportControls();
	}
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);

	if(totalRewardInfoWnd.IsShowWindow() == true)
	{
		totalRewardInfoWnd.HideWindow();
	}
	else if(premiumPurchaseDialogWnd.IsShowWindow() == true)
	{
		premiumPurchaseDialog.Hide();
	} else {
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
}

defaultproperties
{
	m_WindowName="L2PassWnd"
}