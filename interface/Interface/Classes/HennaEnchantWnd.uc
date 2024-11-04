class HennaEnchantWnd extends UICommonAPI;

const TIME_ID = 1010101;
const TIME_BAR_ID = 1010102;
const STEP_MAX = 20;

var WindowHandle Me;
var EffectViewportWndHandle WndBG_EffectViewport;
var WindowHandle EnchantStatus_wnd;
var TextBoxHandle MyEnchantNum_text;
var TextureHandle Mark_tex;
var TextBoxHandle HennaID_txt;
var TextBoxHandle HennaLV_txt;
var TextBoxHandle EffectNameSelect_txt;
var ButtonHandle EffectNameSelect_BTN;
var TextBoxHandle EffectNameSelectNum_txt;
var TextBoxHandle MyEnchant_PrvLv_txt;
var TextBoxHandle MyEnchant_NextLv_txt;
var StatusBarHandle MyEnchant_statusbar;
var TextBoxHandle StatusNumber_txt;
var ButtonHandle Enchant_Btn;
var RichListCtrlHandle NeedItemRichListCtrl;
var TextBoxHandle EnchantCountTitle_txt;
var TextBoxHandle EnchantCount_txt;
var WindowHandle NeedItemSelectDialog_wnd;
var RichListCtrlHandle NeedItemSelect_ListCtrl;
var ButtonHandle ProbabilityTootip_Btn;
var UIControlPageNavi pageNavi;
var UIControlNeedItemList needItemList;
var UIControlNeedItemList needItemDialogList;
var UIControlNeedItemList selectNeedItemList;
var UIControlGroupButtons groupButtons;
var UIPacket._S_EX_NEW_HENNA_LIST henna_list_packet;
var string m_WindowName;
var HennaMenuWnd HennaMenuWndScript;
var int timeResultCount;
var int nLastRandomNum;
var int currentSelectSlot;
var DyePotentialFeeUIData dyePotentialFeeData;
var array<DyePotentialUIData> potentialDataArray;
var int barAniStep;
var int barAniCount;
var string currentEffectPath;
var array<int> currentActiveSteps;
var int selectNeedItemClassID;
var int selectNeedItemIndex;
var array<DyePotentialUpgradeItemInfo> saveNeedUpgradeItemInfos;

static function HennaEnchantWnd Inst()
{
	return HennaEnchantWnd(GetScript("HennaEnchantWnd"));	
}

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_LIST);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_POTEN_ENCHANT);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_POTEN_SELECT);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_GameStart);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	WndBG_EffectViewport = GetEffectViewportWndHandle(m_WindowName $ ".WndBG_EffectViewport");
	EnchantStatus_wnd = GetWindowHandle(m_WindowName $ ".EnchantStatus_wnd");
	MyEnchantNum_text = GetTextBoxHandle(m_WindowName $ ".MyEnchantNum_text");
	Mark_tex = GetTextureHandle(m_WindowName $ ".EnchantStatus_wnd.Mark_tex");
	HennaID_txt = GetTextBoxHandle(m_WindowName $ ".EnchantStatus_wnd.HennaID_txt");
	HennaLV_txt = GetTextBoxHandle(m_WindowName $ ".EnchantStatus_wnd.HennaLV_txt");
	EffectNameSelect_txt = GetTextBoxHandle(m_WindowName $ ".EffectNameSelect_txt");
	EffectNameSelect_BTN = GetButtonHandle(m_WindowName $ ".EffectNameSelect_BTN");
	EffectNameSelectNum_txt = GetTextBoxHandle(m_WindowName $ ".EffectNameSelectNum_txt");
	MyEnchant_PrvLv_txt = GetTextBoxHandle(m_WindowName $ ".MyEnchant_PrvLv_txt");
	MyEnchant_NextLv_txt = GetTextBoxHandle(m_WindowName $ ".MyEnchant_NextLv_txt");
	MyEnchant_statusbar = GetStatusBarHandle(m_WindowName $ ".MyEnchant_statusbar");
	StatusNumber_txt = GetTextBoxHandle(m_WindowName $ ".StatusNumber_txt");
	Enchant_Btn = GetButtonHandle(m_WindowName $ ".Enchant_BTN");
	NeedItemRichListCtrl = GetRichListCtrlHandle(m_WindowName $ ".NeedItemRichListCtrl");
	EnchantCountTitle_txt = GetTextBoxHandle(m_WindowName $ ".EnchantCountTitle_txt");
	EnchantCount_txt = GetTextBoxHandle(m_WindowName $ ".EnchantCount_txt");
	NeedItemSelectDialog_wnd = GetWindowHandle(m_WindowName $ ".NeedItemSelectDialog_wnd");
	NeedItemSelect_ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl");
	ProbabilityTootip_Btn = GetButtonHandle(m_WindowName $ ".ProbabilityTootip_Btn");
	HennaMenuWndScript = HennaMenuWnd(GetScript("HennaMenuWnd"));
	GetWindowHandle(m_WindowName $ ".EnchantDialog_wnd").HideWindow();
	MyEnchant_PrvLv_txt.SetText("");
	MyEnchant_NextLv_txt.SetText("");
	initUIControlGroupButtons();
	initUIControlNeedItemList();
	InitPageNavi();
	GetTextBoxHandle(m_WindowName $ ".ColorYellow_Txt").SetTooltipType("text");
	GetTextBoxHandle(m_WindowName $ ".ColorBrown_Txt").SetTooltipType("text");
	GetTextBoxHandle(m_WindowName $ ".ColorBlue_Txt").SetTooltipType("text");
	GetTextBoxHandle(m_WindowName $ ".ColorYellow_Txt").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13920), 250));
	GetTextBoxHandle(m_WindowName $ ".ColorBrown_Txt").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13921), 250));
	GetTextBoxHandle(m_WindowName $ ".ColorBlue_Txt").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13922), 250));
}

private function SetCurrentActiveSteps()
{
	local int i, Page, dyeItemlevel, nLastAdd;

	// End:0x11F [Loop If]
	for(Page = 0; Page < henna_list_packet.hennaInfoList.Length; Page++)
	{
		class'UIDATA_HENNA'.static.GetHennaDyeItemLevel(henna_list_packet.hennaInfoList[Page].nHennaID, dyeItemlevel);
		// End:0xAB
		if(henna_list_packet.hennaInfoList[Page].nEnchantStep == STEP_MAX)
		{
			// End:0xAB
			if(henna_list_packet.hennaInfoList[Page].nEnchantExp >= HennaMenuWndScript.getDyePotentialExp(henna_list_packet.hennaInfoList[Page].nEnchantStep).Exp)
			{
				nLastAdd = 1;
			}
		}
		currentActiveSteps[Page] = 0;

		// End:0x115 [Loop If]
		for(i = 0; i < (henna_list_packet.hennaInfoList[Page].nEnchantStep - 1) + nLastAdd; i++)
		{
			// End:0x10B
			if(dyeItemlevel > i)
			{
				currentActiveSteps[Page] = i + 1;
			}
		}
	}	
}

function showStep(int Page)
{
	local int i, dyeItemlevel, currentStepMaxExp, slotExp, currentSlotExp;

	local StatusBaseHandle Handle;
	local int nLastAdd;

	Handle = MyEnchant_statusbar.GetSelfScript();
	class'UIDATA_HENNA'.static.GetHennaDyeItemLevel(henna_list_packet.hennaInfoList[currentSelectSlot].nHennaID, dyeItemlevel);
	currentSlotExp = HennaMenuWndScript.getDyePotentialAccrueExp(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep - 1) + henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp;
	slotExp = HennaMenuWndScript.getDyePotentialAccrueExp(dyeItemlevel);

	// End:0x279 [Loop If]
	for(i = 1; i <= STEP_MAX; i++)
	{
		GetWindowHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i)).HideWindow();
		GetStatusRoundHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i) $ ".EnchantApply_StatusRound").ClearPoint();
		GetTextureHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i) $ ".HennaStepOpen_tex").HideWindow();
		GetTextureHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i) $ ".DyeBenefit_tex").HideWindow();
		GetWindowHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i)).SetTooltipType("text");
		GetWindowHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i)).SetTooltipCustomType(getMainSlotCustomTooltip(i));
	}

	// End:0x2E2 [Loop If]
	for(i = (Page - 1) * 10 + 1; i <= Page * 10; i++)
	{
		GetWindowHandle((m_WindowName $ ".EnchantStep_Wnd.Step") $ string(i)).ShowWindow();
	}
	// End:0x348
	if(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep == STEP_MAX)
	{
		// End:0x348
		if(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp >= HennaMenuWndScript.getDyePotentialExp(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep).Exp)
		{
			nLastAdd = 1;
		}
	}
	currentActiveSteps[currentSelectSlot] = 0;

	// End:0x539 [Loop If]
	for(i = 0; i < ((henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep - 1) + nLastAdd); i++)
	{
		// End:0x45F
		if(dyeItemlevel > i)
		{
			GetStatusRoundHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i + 1) $ ".EnchantApply_StatusRound").SetGaugeColor(Handle.StatusBarSplitType.SBST_BackCenter, GTColor().Yellow);
			GetTextureHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i + 1) $ ".DyeBenefit_tex").ShowWindow();
			currentActiveSteps[currentSelectSlot] = i + 1;		
		}
		else
		{
			GetStatusRoundHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i + 1) $ ".EnchantApply_StatusRound").SetGaugeColor(Handle.StatusBarSplitType.SBST_BackCenter, GTColor().Orange);
		}
		GetStatusRoundHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i + 1) $ ".EnchantApply_StatusRound").SetPoint(1, 1);
	}
	i = i - nLastAdd;
	currentStepMaxExp = HennaMenuWndScript.getDyePotentialExp(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep).Exp;
	// End:0x5FF
	if(currentSlotExp > slotExp)
	{
		GetStatusRoundHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i + 1) $ ".EnchantApply_StatusRound").SetGaugeColor(Handle.StatusBarSplitType.SBST_BackCenter, GTColor().Orange);		
	}
	else
	{
		GetStatusRoundHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i + 1) $ ".EnchantApply_StatusRound").SetGaugeColor(Handle.StatusBarSplitType.SBST_BackCenter, GTColor().Yellow);
	}
	GetStatusRoundHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i + 1) $ ".EnchantApply_StatusRound").SetPoint(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp, currentStepMaxExp);

	// End:0x757 [Loop If]
	for(i = 0; i < dyeItemlevel; i++)
	{
		GetTextureHandle(m_WindowName $ ".EnchantStep_Wnd.Step" $ string(i + 1) $ ".HennaStepOpen_tex").ShowWindow();
	}
}

function initUIControlGroupButtons()
{
	groupButtons = new class'UIControlGroupButtons';
	groupButtons._SetStartInfo("L2UI_EPIC.HennaClassicWnd.CategoryBgBtn", "L2UI_EPIC.HennaClassicWnd.CategoryBgBtn_Down", "L2UI_EPIC.HennaClassicWnd.CategoryBgBtn_Over", false);
	groupButtons._addButtonController(GetButtonHandle(m_WindowName $ ".Category01_wnd.Category_BTN"));
	groupButtons._addButtonController(GetButtonHandle(m_WindowName $ ".Category02_wnd.Category_BTN"));
	groupButtons._addButtonController(GetButtonHandle(m_WindowName $ ".Category03_wnd.Category_BTN"));
	groupButtons._addButtonController(GetButtonHandle(m_WindowName $ ".Category04_wnd.Category_BTN"));
	groupButtons.DelegateOnClickButton = groupButtonOnClickButton;
	GetButtonHandle(m_WindowName $ ".Category01_wnd.Category_BTN").SetTooltipType("text");
	GetButtonHandle(m_WindowName $ ".Category02_wnd.Category_BTN").SetTooltipType("text");
	GetButtonHandle(m_WindowName $ ".Category03_wnd.Category_BTN").SetTooltipType("text");
	GetButtonHandle(m_WindowName $ ".Category04_wnd.Category_BTN").SetTooltipType("text");
}

function initUIControlNeedItemList()
{
	NeedItemList = new class'UIControlNeedItemList';
	NeedItemList.SetRichListControler(GetRichListCtrlHandle(m_WindowName $ ".NeedItemRichListCtrl"));
	NeedItemList.StartNeedItemList(1);
	NeedItemList.SetHideMyNum(true);
	needItemDialogList = new class'UIControlNeedItemList';
	needItemDialogList.SetRichListControler(GetRichListCtrlHandle(m_WindowName $ ".EnchantDialog_wnd.Dialog_NeedItemRichListCtrl"));
	needItemDialogList.StartNeedItemList(1);
	selectNeedItemList = new class'UIControlNeedItemList';
	selectNeedItemList.SetRichListControler(GetRichListCtrlHandle(m_WindowName $ ".NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl"));
	selectNeedItemList.StartNeedItemList(2);
	NeedItemSelect_ListCtrl.SetSelectable(true);
}

function InitPageNavi()
{
	local WindowHandle PageNaviControl;

	PageNaviControl = GetWindowHandle(m_WindowName $ ".PageNavi_Control");
	PageNaviControl.SetScript("UIControlPageNavi");
	pageNavi = UIControlPageNavi(PageNaviControl.GetScript());
	pageNavi.Init(m_WindowName $ ".PageNavi_Control");
	pageNavi.DelegeOnChangePage = pageChanged;
}

function pageChanged(int Page)
{
	showStep(Page);
	GetTextureHandle(m_WindowName $ ".EnchantStep_Wnd.PageLine01_tex").HideWindow();
	GetTextureHandle(m_WindowName $ ".EnchantStep_Wnd.PageLine02_tex").HideWindow();
	GetTextureHandle(m_WindowName $ ".EnchantStep_Wnd.PageLine0" $ string(Page) $ "_tex").ShowWindow();
}

function groupButtonOnClickButton(string parentWindowName, string strName, int i)
{
	local DyePotentialUIData dyePotentialData;
	local int dyeItemClassID, dyeItemlevel;
	local ItemInfo dyeItemInfo;
	local string dyeItemName, cutStr;
	local SkillInfo SkillInfo;
	local int currentStepMaxExp;
	local string emblemTex;
	local int nShowPageNum, currentSlotExp, slotExp;
	local string beforeBarStr;
	local StatusBaseHandle Handle;
	local string ItemNameS, AdditionalName;

	Handle = MyEnchant_statusbar.GetSelfScript();
	Debug("groupButtonOnClickButton" @ parentWindowName @ strName @ string(i));
	currentSelectSlot = i;
	emblemTex = class'UIDATA_HENNA'.static.GetHennaEmblemTex(henna_list_packet.hennaInfoList[i].nHennaID);
	// End:0xFD
	if(emblemTex != "")
	{
		GetTextureHandle(m_WindowName $ ".EnchantStatus_wnd.Mark_tex").ShowWindow();
		GetTextureHandle(m_WindowName $ ".EnchantStatus_wnd.Mark_tex").SetTexture(emblemTex);		
	}
	else
	{
		GetTextureHandle(m_WindowName $ ".EnchantStatus_wnd.Mark_tex").HideWindow();
	}
	MyEnchantNum_text.SetText(MakeFullSystemMsg(GetSystemMessage(5203), string(HennaMenuWndScript.getDyePotentialLastLevel())));
	class'UIDATA_HENNA'.static.GetHennaDyeItemClassID(henna_list_packet.hennaInfoList[i].nHennaID, dyeItemClassID);
	dyeItemInfo = GetItemInfoByClassID(dyeItemClassID);
	class'UIDATA_HENNA'.static.GetHennaDyeItemLevel(henna_list_packet.hennaInfoList[i].nHennaID, dyeItemlevel);
	class'UIDATA_HENNA'.static.GetDyePotentialData(henna_list_packet.hennaInfoList[i].nPotenID, dyePotentialData);
	// End:0x467
	if(dyeItemInfo.Name != "")
	{
		ItemNameS = class'UIDATA_HENNA'.static.GetItemNameS(henna_list_packet.hennaInfoList[i].nHennaID);
		dyeItemName = Left(ItemNameS, InStr(ItemNameS, "<"));
		cutStr = Mid(ItemNameS, InStr(ItemNameS, "<"), Len(ItemNameS));
		GetTextBoxHandle(m_WindowName $ ".EnchantStatus_wnd.HennaID_txt").SetText(dyeItemName);
		GetTextBoxHandle(m_WindowName $ ".EnchantStatus_wnd.HennaStat_txt").SetText(cutStr);
		textBoxShortStringWithTooltip(GetTextBoxHandle(m_WindowName $ ".EnchantStatus_wnd.HennaStat_txt"), true);
		GetTextBoxHandle(m_WindowName $ ".EnchantStatus_wnd.HennaLV_txt").SetText(MakeFullSystemMsg(GetSystemMessage(5203), string(dyeItemlevel)));
		AdditionalName = class'UIDATA_HENNA'.static.GetAddtionNameS(henna_list_packet.hennaInfoList[i].nHennaID);
		GetButtonHandle(m_WindowName $ ".EnchantStatus_wnd.HennaStatDetail_Btn").SetTooltipType("text");
		GetButtonHandle(m_WindowName $ ".EnchantStatus_wnd.HennaStatDetail_Btn").SetTooltipCustomType(MakeTooltipSimpleText(AdditionalName));
		GetButtonHandle(m_WindowName $ ".EnchantStatus_wnd.HennaStatDetail_Btn").ShowWindow();
		Debug("AdditionalName" @ AdditionalName);		
	}
	else
	{
		GetButtonHandle(m_WindowName $ ".EnchantStatus_wnd.HennaStatDetail_Btn").ClearTooltip();
		GetButtonHandle(m_WindowName $ ".EnchantStatus_wnd.HennaStatDetail_Btn").HideWindow();
		GetTextBoxHandle(m_WindowName $ ".EnchantStatus_wnd.HennaID_txt").SetText("");
		GetTextBoxHandle(m_WindowName $ ".EnchantStatus_wnd.HennaStat_txt").SetText("");
		textBoxShortStringWithTooltip(GetTextBoxHandle(m_WindowName $ ".EnchantStatus_wnd.HennaStat_txt"), true);
		GetTextBoxHandle(m_WindowName $ ".EnchantStatus_wnd.HennaLV_txt").SetText("");
	}
	// End:0x912
	if(henna_list_packet.hennaInfoList[i].nPotenID > 0)
	{
		// End:0x6EC
		if(dyeItemlevel == 0)
		{
			GetTextBoxHandle(m_WindowName $ ".EffectNameSelect_txt").SetTextColor(GTColor().Gray);
			GetTextBoxHandle(m_WindowName $ ".EffectNameSelectNum_txt").SetTextColor(GTColor().Gray);
			GetTextBoxHandle(m_WindowName $ ".EffectNameSelect_txt").SetText(dyePotentialData.EffectName);
			GetTextBoxHandle(m_WindowName $ ".EffectNameSelectNum_txt").SetText(("(" $ GetSystemString(13886)) $ ")");			
		}
		else
		{
			// End:0x825
			if(henna_list_packet.hennaInfoList[i].nActiveStep > 0)
			{
				GetTextBoxHandle(m_WindowName $ ".EffectNameSelect_txt").SetTextColor(GTColor().Yellow);
				GetTextBoxHandle(m_WindowName $ ".EffectNameSelectNum_txt").SetTextColor(GTColor().Yellow);
				GetSkillInfo(dyePotentialData.SkillID, henna_list_packet.hennaInfoList[i].nActiveStep, 0, SkillInfo);
				GetTextBoxHandle(m_WindowName $ ".EffectNameSelect_txt").SetText(dyePotentialData.EffectName);
				GetTextBoxHandle(m_WindowName $ ".EffectNameSelectNum_txt").SetText(SkillInfo.SkillDesc);				
			}
			else
			{
				GetTextBoxHandle(m_WindowName $ ".EffectNameSelect_txt").SetTextColor(GTColor().White);
				GetTextBoxHandle(m_WindowName $ ".EffectNameSelectNum_txt").SetTextColor(GTColor().White);
				GetTextBoxHandle(m_WindowName $ ".EffectNameSelect_txt").SetText(dyePotentialData.EffectName);
				GetTextBoxHandle(m_WindowName $ ".EffectNameSelectNum_txt").SetText("+0");
			}
		}		
	}
	else
	{
		GetTextBoxHandle(m_WindowName $ ".EffectNameSelect_txt").SetTextColor(GTColor().White);
		GetTextBoxHandle(m_WindowName $ ".EffectNameSelectNum_txt").SetTextColor(GTColor().White);
		GetTextBoxHandle(m_WindowName $ ".EffectNameSelect_txt").SetText(GetSystemString(13887));
		GetTextBoxHandle(m_WindowName $ ".EffectNameSelectNum_txt").SetText("");
	}
	MyEnchant_PrvLv_txt.SetText(MakeFullSystemMsg(GetSystemMessage(5203), string(henna_list_packet.hennaInfoList[i].nEnchantStep - 1)));
	beforeBarStr = MyEnchant_NextLv_txt.GetText();
	// End:0xAAD
	if(henna_list_packet.hennaInfoList[i].nEnchantStep < HennaMenuWndScript.getDyePotentialLastLevel())
	{
		MyEnchant_NextLv_txt.SetText(MakeFullSystemMsg(GetSystemMessage(5203), string(henna_list_packet.hennaInfoList[i].nEnchantStep)));		
	}
	else
	{
		MyEnchant_NextLv_txt.SetText("Max");
	}
	// End:0xBBF
	if(parentWindowName == "resultOK")
	{
		// End:0xBBF
		if(beforeBarStr != MyEnchant_NextLv_txt.GetText() && beforeBarStr != "")
		{
			L2UITween(GetScript("l2UITween")).StartShake(m_WindowName $ ".MyEnchant_PrvLv_txt", 6, 1000, L2UITween(GetScript("l2UITween")).directionType.small, 0);
			L2UITween(GetScript("l2UITween")).StartShake(m_WindowName $ ".MyEnchant_NextLv_txt", 6, 1000, L2UITween(GetScript("l2UITween")).directionType.small, 0);
		}
	}
	currentStepMaxExp = HennaMenuWndScript.getDyePotentialExp(henna_list_packet.hennaInfoList[i].nEnchantStep).Exp;
	MyEnchant_statusbar.SetPoint(henna_list_packet.hennaInfoList[i].nEnchantExp, currentStepMaxExp);
	StatusNumber_txt.SetText(string(henna_list_packet.hennaInfoList[i].nEnchantExp) $ "/" $ string(currentStepMaxExp));
	Enchant_Btn.EnableWindow();
	currentSlotExp = HennaMenuWndScript.getDyePotentialAccrueExp(henna_list_packet.hennaInfoList[i].nEnchantStep - 1) + henna_list_packet.hennaInfoList[i].nEnchantExp;
	slotExp = HennaMenuWndScript.getDyePotentialAccrueExp(dyeItemlevel);
	GetTextBoxHandle(m_WindowName $ ".MYDyeNum_txt").SetText(string(currentSlotExp) $ "/" $ string(HennaMenuWndScript.getDyePotentialTotalExp()));
	dyePotentialFeeData = getFeeDataProcess();
	ProbabilityTootip_Btn.SetTooltipType("text");
	ProbabilityTootip_Btn.SetTooltipCustomType(getTooltipCustomSuccessPercent());
	// End:0x101D
	if(isPrivateSlotEnchantState())
	{
		EnchantCountTitle_txt.SetText(MakeFullSystemMsg(GetSystemMessage(13752), string(i + 1)));
		EnchantCountTitle_txt.SetTextColor(GTColor().Green3);		
	}
	else
	{
		EnchantCountTitle_txt.SetText(GetSystemString(14205));
		EnchantCountTitle_txt.SetTextColor(GTColor().White);
	}
	// End:0x10B2
	if((henna_list_packet.nDailyCount == 0) && dyePotentialFeeData.DailyCount == 0)
	{
		EnchantCount_txt.SetText(GetSystemString(858));
		EnchantCount_txt.SetTextColor(GTColor().Yellow);		
	}
	else
	{
		GetMeButton("EnchantbtnHelp").SetTooltipCustomType(getTooltipCustomQuestionMark());
		// End:0x1177
		if(isPrivateSlotEnchantState())
		{
			// End:0x111D
			if(henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount == 0)
			{
				EnchantCount_txt.SetTextColor(GTColor().Red);				
			}
			else
			{
				EnchantCount_txt.SetTextColor(GTColor().Yellow);
			}
			EnchantCount_txt.SetText(string(henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount) $ "/" $ string(dyePotentialFeeData.DailyCount));			
		}
		else
		{
			// End:0x11A8
			if(henna_list_packet.nDailyCount == 0)
			{
				EnchantCount_txt.SetTextColor(GTColor().Red);				
			}
			else
			{
				EnchantCount_txt.SetTextColor(GTColor().Yellow);
			}
			EnchantCount_txt.SetText(string(henna_list_packet.nDailyCount) $ "/" $ string(dyePotentialFeeData.DailyCount));
		}
	}
	Debug("dyePotentialFeeData.UpgradeItemInfos.length : " @ string(dyePotentialFeeData.UpgradeItemInfos.Length));
	// End:0x13A6
	if(dyePotentialFeeData.UpgradeItemInfos.Length == 1)
	{
		NeedItemList.CleariObjects();
		NeedItemList.CleariObjects();
		NeedItemList.AddNeedItemClassID(dyePotentialFeeData.UpgradeItemInfos[0].ItemClassID, dyePotentialFeeData.UpgradeItemInfos[0].ItemCount);
		NeedItemList.SetBuyNum(1);
		needItemDialogList.CleariObjects();
		needItemDialogList.AddNeedItemClassID(dyePotentialFeeData.UpgradeItemInfos[0].ItemClassID, dyePotentialFeeData.UpgradeItemInfos[0].ItemCount);
		needItemDialogList.SetBuyNum(1);
		selectNeedItemClassID = dyePotentialFeeData.UpgradeItemInfos[0].ItemClassID;
		saveNeedUpgradeItemInfos = dyePotentialFeeData.UpgradeItemInfos;
		Enchant_Btn.EnableWindow();
		GetWindowHandle(m_WindowName $ ".NeedItemSelect_wnd").HideWindow();
		GetButtonHandle(m_WindowName $ ".NeedItemSelectArrow_btn").HideWindow();
		NeedItemSelectDialog_wnd.HideWindow();		
	}
	else
	{
		Debug("saveNeedUpgradeItemInfos[0].ItemClassID" @ string(saveNeedUpgradeItemInfos[0].ItemClassID));
		Debug("saveNeedUpgradeItemInfos[1].ItemClassID" @ string(saveNeedUpgradeItemInfos[1].ItemClassID));
		Debug("dyePotentialFeeData.UpgradeItemInfos[0].ItemClassID" @ string(dyePotentialFeeData.UpgradeItemInfos[0].ItemClassID));
		Debug("dyePotentialFeeData.UpgradeItemInfos[1].ItemClassID" @ string(dyePotentialFeeData.UpgradeItemInfos[1].ItemClassID));
		selectNeedItemList.CleariObjects();
		selectNeedItemList.AddNeedItemClassID(dyePotentialFeeData.UpgradeItemInfos[0].ItemClassID, dyePotentialFeeData.UpgradeItemInfos[0].ItemCount);
		selectNeedItemList.AddNeedItemClassID(dyePotentialFeeData.UpgradeItemInfos[1].ItemClassID, dyePotentialFeeData.UpgradeItemInfos[1].ItemCount);
		selectNeedItemList.SetBuyNum(1);
		// End:0x1591
		if(isPrivateSlotEnchantState() && parentWindowName != "resultOK")
		{
			saveNeedUpgradeItemInfos[0].ItemClassID = 0;
			saveNeedUpgradeItemInfos[1].ItemClassID = 0;
			selectNeedItemIndex = -1;
		}
		// End:0x1498
		if(saveNeedUpgradeItemInfos[0].ItemClassID == dyePotentialFeeData.UpgradeItemInfos[0].ItemClassID && saveNeedUpgradeItemInfos[1].ItemClassID == dyePotentialFeeData.UpgradeItemInfos[1].ItemClassID)
		{
			NeedItemSelectDialog_wnd.HideWindow();
			GetWindowHandle(m_WindowName $ ".NeedItemSelect_wnd").HideWindow();
			Enchant_Btn.EnableWindow();			
		}
		else
		{
			NeedItemSelectDialog_wnd.ShowWindow();
			GetWindowHandle(m_WindowName $ ".NeedItemSelect_wnd").ShowWindow();
			Enchant_Btn.DisableWindow();
			NeedItemList.CleariObjects();
			needItemDialogList.CleariObjects();
			selectNeedItemClassID = -1;
			selectNeedItemIndex = -1;
		}
		// End:0x16D8
		if(selectNeedItemIndex > -1)
		{
			NeedItemSelect_ListCtrl.SetSelectedIndex(selectNeedItemIndex, false);
			Enchant_Btn.EnableWindow();			
		}
		else
		{
			NeedItemSelectDialog_wnd.ShowWindow();
			GetWindowHandle(m_WindowName $ ".NeedItemSelect_wnd").ShowWindow();
			Enchant_Btn.DisableWindow();
		}
		saveNeedUpgradeItemInfos = dyePotentialFeeData.UpgradeItemInfos;
		GetButtonHandle(m_WindowName $ ".NeedItemSelectArrow_btn").ShowWindow();
	}
	// End:0x18B3
	if(currentSlotExp > slotExp)
	{
		// End:0x182F
		if(currentSlotExp >= HennaMenuWndScript.getDyePotentialTotalExp())
		{
			Enchant_Btn.DisableWindow();
			StatusNumber_txt.SetText("MAX");
			MyEnchant_statusbar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeLeft, GetColor(75, 45, 35, 255));
			MyEnchant_statusbar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeCenter, GetColor(75, 45, 35, 255));
			MyEnchant_statusbar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeRight, GetColor(75, 45, 35, 255));			
		}
		else
		{
			MyEnchant_statusbar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeLeft, GTColor().Orange);
			MyEnchant_statusbar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeCenter, GTColor().Orange);
			MyEnchant_statusbar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeRight, GTColor().Orange);
		}		
	}
	else
	{
		// End:0x1970
		if(currentSlotExp == HennaMenuWndScript.getDyePotentialTotalExp())
		{
			MyEnchant_statusbar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeLeft, GetColor(115, 160, 45, 255));
			MyEnchant_statusbar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeCenter, GetColor(115, 160, 45, 255));
			MyEnchant_statusbar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeRight, GetColor(115, 160, 45, 255));
			Enchant_Btn.DisableWindow();
			StatusNumber_txt.SetText("MAX");			
		}
		else
		{
			MyEnchant_statusbar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeLeft, GetColor(236, 178, 63, 255));
			MyEnchant_statusbar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeCenter, GetColor(236, 178, 63, 255));
			MyEnchant_statusbar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeRight, GetColor(236, 178, 63, 255));
		}
	}
	pageNavi.SetTotalPage(((HennaMenuWndScript.getDyePotentialLastLevel() - 1) / 10) + 1);
	// End:0x1A59
	if(henna_list_packet.hennaInfoList[i].nEnchantExp > 0)
	{
		nShowPageNum = ((henna_list_packet.hennaInfoList[i].nEnchantStep - 1) / 10) + 1;		
	}
	else
	{
		nShowPageNum = ((henna_list_packet.hennaInfoList[i].nEnchantStep - 2) / 10) + 1;
	}
	pageNavi.Go(nShowPageNum);
	pageChanged(nShowPageNum);
}

function DyePotentialFeeUIData getFeeDataProcess()
{
	return getFeeData(henna_list_packet.nDailyStep, henna_list_packet.nDailyCount, currentSelectSlot + 1, henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep - 1, henna_list_packet.hennaInfoList[currentSelectSlot].nDailyStep);
}

function DyePotentialFeeUIData getFeeData(int nPublicDailyStep, int nPublicDailyCount, int nSlot, int DyePotentialLevel, int nSlotDailyStep)
{
	local DyePotentialFeeUIData rDyePotentialFeeData;

	// End:0x3E
	if((nPublicDailyCount == 0) && nSlotDailyStep != 0)
	{
		class'UIDATA_HENNA'.static.GetDyePotentialFeeDataBySlot(nSlot, DyePotentialLevel, nSlotDailyStep, rDyePotentialFeeData);		
	}
	else
	{
		class'UIDATA_HENNA'.static.GetDyePotentialFeeData(nPublicDailyStep, rDyePotentialFeeData);
	}
	return rDyePotentialFeeData;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	// End:0x72
	if(GetWindowHandle(m_WindowName $ ".EnchantDialog_wnd").IsShowWindow())
	{
		GetWindowHandle(m_WindowName $ ".EnchantDialog_wnd").HideWindow();
	}
	setLeftSlotButtonRefresh();
	WndBG_EffectViewport.SpawnEffect("LineageEffect2.ave_white_trans_deco");
}

function OnHide()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "HennaMenuWnd");
	WndBG_EffectViewport.SpawnEffect("");
}

event OnClickListCtrlRecord(string strID)
{
	local DyePotentialFeeUIData dyePotentialFeeData;

	dyePotentialFeeData = getFeeDataProcess();
	Debug("strID" @ strID @ string(NeedItemSelect_ListCtrl.GetSelectedIndex()));
	selectNeedItemIndex = NeedItemSelect_ListCtrl.GetSelectedIndex();
	NeedItemList.CleariObjects();
	NeedItemList.AddNeedItemClassID(dyePotentialFeeData.UpgradeItemInfos[selectNeedItemIndex].ItemClassID, dyePotentialFeeData.UpgradeItemInfos[selectNeedItemIndex].ItemCount);
	NeedItemList.SetBuyNum(1);
	needItemDialogList.CleariObjects();
	needItemDialogList.AddNeedItemClassID(dyePotentialFeeData.UpgradeItemInfos[selectNeedItemIndex].ItemClassID, dyePotentialFeeData.UpgradeItemInfos[selectNeedItemIndex].ItemCount);
	needItemDialogList.SetBuyNum(1);
	selectNeedItemClassID = dyePotentialFeeData.UpgradeItemInfos[selectNeedItemIndex].ItemClassID;
	NeedItemSelectDialog_wnd.HideWindow();
	getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13658), GetItemNameAll(GetItemInfoByClassID(selectNeedItemClassID))));
	// End:0x184
	if(StatusNumber_txt.GetText() != "MAX")
	{
		Enchant_Btn.EnableWindow();
	}
	GetWindowHandle(m_WindowName $ ".NeedItemSelect_wnd").HideWindow();
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	groupButtons._selectButtonHandle(a_ButtonHandle);
}

function CloseUI()
{
	Me.HideWindow();
}

event OnClickButton(string Name)
{
	Debug("OnClickButton" @ Name);
	switch(Name)
	{
		// End:0x3B
		case "Main_BTN":
			Me.HideWindow();
			toggleWindow("HennaMenuWnd", true);
			// End:0x18C
			break;
		// End:0x54
		case "Enchant_BTN":
			OnEnchant_BtnClick();
			// End:0x18C
			break;
		// End:0x8E
		case "HelpWnd_Btn":
			Debug("ShowHelp -> 69");
			//class'HelpWnd'.static.ShowHelp(69);
			// End:0x18C
			break;
		// End:0xAA
		case "HennaClose_BTN":
			CloseUI();
			// End:0x18C
			break;
		// End:0xC8
		case "EnchantCheck_btn":
			OnEnchantCheck_btnClick();
			// End:0x18C
			break;
		// End:0xE6
		case "EnchantApply_btn":
			OnEnchantApply_btnClick();
			// End:0x18C
			break;
		// End:0x105
		case "EnchantCancel_btn":
			OnEnchantCancel_btnClick();
			// End:0x18C
			break;
		// End:0x12A
		case "NeedItemSelectArrow_btn":
			onToggleSelectNeedItem();
			// End:0x18C
			break;
		case "ProbabilityTootip_Btn":
		// End:0x189
		case "EnchantbtnHelp":
			//class'HelpWnd'.static.ShowHelp(69, 4);
			// End:0x18C
			break;
	}
}

function onToggleSelectNeedItem()
{
	// End:0x24
	if(NeedItemSelectDialog_wnd.IsShowWindow())
	{
		NeedItemSelectDialog_wnd.HideWindow();		
	}
	else
	{
		NeedItemSelectDialog_wnd.ShowWindow();
	}
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle)
	{
		// End:0x22
		case EffectNameSelect_BTN:
			_ShowContextMenu(currentSelectSlot, X, Y);
			break;
	}
}

function _ShowContextMenu(int nCurrentSelectSlot, int X, int Y)
{
	local UIControlContextMenu ContextMenu;
	local int i, SelectedIndex;
	local array<string> effectNames;

	currentSelectSlot = nCurrentSelectSlot;
	class'UIDATA_HENNA'.static.GetDyePotentialDataList(nCurrentSelectSlot + 1, potentialDataArray);
	_GetEffectStrings(nCurrentSelectSlot, effectNames, SelectedIndex);
	ContextMenu = class'UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;

	// End:0x329 [Loop If]
	for(i = 0; i < effectNames.Length; i++)
	{
		// End:0xE0
		if(SelectedIndex == i)
		{
			ContextMenu.MenuNew(effectNames[i] $ " <" $ GetSystemString(218) $ ">", i, GTColor().Yellow);
			// [Explicit Continue]
			continue;
		}
		ContextMenu.MenuNew(effectNames[i], i, GTColor().White);
	}
	ContextMenu.Show(X, Y, string(self));
}

function _GetEffectStrings(int SlotIndex, out array<string> effectNames, out int selectedNum)
{
	local int i;
	local SkillInfo SkillInfo, currentSkillInfo;
	local string effectNumStr;
	local DyePotentialUIData dyePotentialData;
	local array<DyePotentialUIData> _potentialDataArray;

	class'UIDATA_HENNA'.static.GetDyePotentialDataList(SlotIndex + 1, _potentialDataArray);
	selectedNum = -1;

	for(i = 0; i < _potentialDataArray.Length; i++)
	{
		class'UIDATA_HENNA'.static.GetDyePotentialData(henna_list_packet.hennaInfoList[SlotIndex].nPotenID, dyePotentialData);
		GetSkillInfo(_potentialDataArray[i].SkillID, currentActiveSteps[SlotIndex], 0, currentSkillInfo);
		// End:0xB2
		if(currentActiveSteps[SlotIndex] > 0)
		{
			effectNumStr = currentSkillInfo.SkillDesc;			
		}
		else
		{
			effectNumStr = "+0";
		}
		GetSkillInfo(_potentialDataArray[i].SkillID, _potentialDataArray[i].MaxSkillLevel, 0, SkillInfo);
		// End:0x112
		if(dyePotentialData.EffectName == _potentialDataArray[i].EffectName)
		{
			selectedNum = i;
		}
		effectNames[effectNames.Length] = (_potentialDataArray[i].EffectName @ effectNumStr $ " / Max:") @ SkillInfo.SkillDesc;
	}	
}

function HandleOnClickContextMenu(int Index)
{
	API_C_EX_NEW_HENNA_POTEN_SELECT(currentSelectSlot + 1, potentialDataArray[Index].DyePotentialID);
}

function OnEnchant_BtnClick()
{
	local DyePotentialFeeUIData dyePotentialFeeData;
	local string emblemTex;

	Me.KillTimer(TIME_ID);
	Me.KillTimer(TIME_BAR_ID);
	barAniStep = 0;
	barAniCount = 0;
	playEffect("");
	GetStatusRoundHandle(m_WindowName $ ".EnchantDialog_wnd.LV_StatusRound").ShowWindow();
	GetStatusRoundHandle(m_WindowName $ ".EnchantDialog_wnd.Enchant_StatusRound").ShowWindow();
	GetStatusRoundHandle(m_WindowName $ ".EnchantDialog_wnd.EnchantApply_StatusRound").ShowWindow();
	GetStatusRoundHandle(m_WindowName $ ".EnchantDialog_wnd.LV_StatusRound").SetPoint(0, 100);
	GetStatusRoundHandle(m_WindowName $ ".EnchantDialog_wnd.Enchant_StatusRound").SetPoint(0, 100);
	GetStatusRoundHandle(m_WindowName $ ".EnchantDialog_wnd.EnchantApply_StatusRound").SetPoint(0, 100);
	GetButtonHandle(m_WindowName $ ".EnchantDialog_wnd.EnchantCheck_btn").HideWindow();
	GetButtonHandle(m_WindowName $ ".EnchantDialog_wnd.EnchantApply_btn").ShowWindow();
	GetButtonHandle(m_WindowName $ ".EnchantDialog_wnd.EnchantCancel_btn").ShowWindow();
	GetWindowHandle(m_WindowName $ ".EnchantDialog_wnd.Result_wnd").HideWindow();
	GetWindowHandle(m_WindowName $ ".EnchantDialog_wnd").ShowWindow();
	GetWindowHandle(m_WindowName $ ".EnchantDialog_wnd").SetFocus();
	GetTextureHandle(m_WindowName $ ".EnchantDialog_wnd.DiceSwap00").HideWindow();
	GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogDscrp_txt").SetText(GetSystemString(13824));
	emblemTex = class'UIDATA_HENNA'.static.GetHennaEmblemTex(henna_list_packet.hennaInfoList[currentSelectSlot].nHennaID);
	GetTextureHandle(m_WindowName $ ".EnchantDialog_wnd.Mark_tex").SetTexture(emblemTex);
	GetTextureHandle(m_WindowName $ ".EnchantDialog_wnd.Mark_tex").ShowWindow();
	dyePotentialFeeData = getFeeDataProcess();
	Debug("henna_list_packet.nDailyStep" @ string(henna_list_packet.nDailyStep));
	// End:0x64F
	if(isPrivateSlotEnchantState())
	{
		GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogEnchantCountTitle_txt").SetText(MakeFullSystemMsg(GetSystemMessage(13752), string(currentSelectSlot + 1)));
		GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogEnchantCountTitle_txt").SetTextColor(GTColor().Green3);
		// End:0x58F
		if(henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount > 0)
		{
			GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogEnchantCount_txt").SetTextColor(GTColor().Yellow);			
		}
		else
		{
			GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogEnchantCount_txt").SetTextColor(GTColor().Red);
		}
		GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogEnchantCount_txt").SetText(string(henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount) $ "/" $ string(dyePotentialFeeData.DailyCount));		
	}
	else
	{
		GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogEnchantCountTitle_txt").SetText(GetSystemString(14205));
		GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogEnchantCountTitle_txt").SetTextColor(GTColor().BrightWhite);
		// End:0x7BA
		if((henna_list_packet.nDailyCount == 0) && dyePotentialFeeData.DailyCount == 0)
		{
			GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogEnchantCount_txt").SetText(GetSystemString(858));
			GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogEnchantCount_txt").SetTextColor(GTColor().Yellow);			
		}
		else
		{
			GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogEnchantCount_txt").SetText(string(henna_list_packet.nDailyCount) $ "/" $ string(dyePotentialFeeData.DailyCount));
			// End:0x87F
			if(henna_list_packet.nDailyCount > 0)
			{
				GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogEnchantCount_txt").SetTextColor(GTColor().Yellow);				
			}
			else
			{
				GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogEnchantCount_txt").SetTextColor(GTColor().Red);
			}
		}
	}
	// End:0xA3C
	if(henna_list_packet.nDailyCount == 0 && henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount == 0 || (henna_list_packet.nDailyCount == 0) && henna_list_packet.hennaInfoList[currentSelectSlot].nDailyStep == 0)
	{
		GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DailyEnchantInfo01_Txt").ShowWindow();
		GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DailyEnchantInfo02_Txt").ShowWindow();
		GetRichListCtrlHandle(m_WindowName $ ".EnchantDialog_wnd.Dialog_NeedItemRichListCtrl").HideWindow();
		GetTextureHandle(m_WindowName $ ".EnchantDialog_wnd.DialogNeedItmeBG01_tex").HideWindow();		
	}
	else
	{
		GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DailyEnchantInfo01_Txt").HideWindow();
		GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DailyEnchantInfo02_Txt").HideWindow();
		GetRichListCtrlHandle(m_WindowName $ ".EnchantDialog_wnd.Dialog_NeedItemRichListCtrl").ShowWindow();
		GetTextureHandle(m_WindowName $ ".EnchantDialog_wnd.DialogNeedItmeBG01_tex").ShowWindow();
	}
	// End:0xBDB
	if(needItemDialogList.GetCanBuy() && (henna_list_packet.nDailyCount > 0 || henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount > 0) || dyePotentialFeeData.DailyCount == 0)
	{
		GetButtonHandle(m_WindowName $ ".EnchantDialog_wnd.EnchantApply_btn").EnableWindow();		
	}
	else
	{
		GetButtonHandle(m_WindowName $ ".EnchantDialog_wnd.EnchantApply_btn").DisableWindow();
	}
}

function OnEnchantApply_btnClick()
{
	GetButtonHandle(m_WindowName $ ".EnchantDialog_wnd.EnchantApply_btn").DisableWindow();
	GetTextureHandle(m_WindowName $ ".EnchantDialog_wnd.DiceSwap00").ShowWindow();
	GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogDscrp_txt").SetText(GetSystemString(13823));
	GetRichListCtrlHandle(m_WindowName $ ".EnchantDialog_wnd.Dialog_NeedItemRichListCtrl").HideWindow();
	GetTextureHandle(m_WindowName $ ".EnchantDialog_wnd.DialogNeedItmeBG01_tex").HideWindow();
	GetTextureHandle(m_WindowName $ ".EnchantDialog_wnd.Mark_tex").HideWindow();
	timeResultCount = 0;
	Me.SetTimer(TIME_ID, 100);
	Me.SetTimer(TIME_BAR_ID, 10);
	playEffect("LineageEffect2.ave_white_trans_deco");
	PlaySound("InterfaceSound.MagicLamp_Start");
}

function playEffect(string effectPath)
{
	currentEffectPath = effectPath;
	GetEffectViewportWndHandle(m_WindowName $ ".Result_EffectViewport").SpawnEffect(effectPath);
}

function OnTimer(int TimerID)
{
	local int R;

	// End:0xD2
	if(TimerID == TIME_ID)
	{
		timeResultCount++;
		R = getRandomRange();
		// End:0x3D
		if(nLastRandomNum == R)
		{
			R = getRandomRange();
		}
		GetTextureHandle(m_WindowName $ ".EnchantDialog_wnd.DiceSwap00").SetTexture("L2UI_NewTex.etc.Hn_Num" $ string(R));
		nLastRandomNum = R;
		// End:0xD2
		if(timeResultCount > 3)
		{
			API_C_EX_NEW_HENNA_POTEN_ENCHANT(currentSelectSlot + 1, selectNeedItemClassID);
			Me.KillTimer(TimerID);
		}
	}
	// End:0x1B1
	if(TimerID == TIME_BAR_ID)
	{
		barAniCount = barAniCount + 1;
		GetStatusRoundHandle(m_WindowName $ ".EnchantDialog_wnd.EnchantApply_StatusRound").SetPoint(barAniCount, STEP_MAX);
		GetStatusRoundHandle(m_WindowName $ ".EnchantDialog_wnd.LV_StatusRound").SetPoint(barAniCount, STEP_MAX);
		// End:0x1B1
		if(barAniCount >= STEP_MAX)
		{
			barAniStep = 0;
			barAniCount = 0;
			Me.KillTimer(TimerID);
		}
	}
}

function int getRandomRange()
{
	local int R, Len;

	Len = dyePotentialFeeData.EnchantExps.Length;
	R = Rand(Len);
	return dyePotentialFeeData.EnchantExps[R].Exp;
}

function OnEnchantCheck_btnClick()
{
	OnEnchantCancel_btnClick();
	setLeftSlotButtonRefresh();
	groupButtonOnClickButton("resultOK", "", currentSelectSlot);
}

function OnEnchantCancel_btnClick()
{
	GetWindowHandle(m_WindowName $ ".EnchantDialog_wnd").HideWindow();
	GetTextureHandle(m_WindowName $ ".EnchantDialog_wnd.DiceSwap00").HideWindow();
	// End:0x98
	if(currentEffectPath == "LineageEffect2.ave_white_trans_deco")
	{
		playEffect("");
	}
	Me.KillTimer(TIME_ID);
	Me.KillTimer(TIME_BAR_ID);
}

function OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		// End:0x28
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_LIST:
			ParsePacket_S_EX_NEW_HENNA_LIST();
			// End:0x97
			break;
		// End:0x49
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_POTEN_ENCHANT:
			ParsePacket_S_EX_NEW_HENNA_POTEN_ENCHANT();
			// End:0x97
			break;
		// End:0x6A
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_POTEN_SELECT:
			ParsePacket_S_EX_NEW_HENNA_POTEN_SELECT();
			// End:0xBD
			break;
		// End:0x6F
		case EV_Restart:
		// End:0xBA
		case EV_GameStart:
			MyEnchant_PrvLv_txt.SetText("");
			MyEnchant_NextLv_txt.SetText("");
			selectNeedItemClassID = -1;
			selectNeedItemIndex = -1;
			saveNeedUpgradeItemInfos.Length = 0;
			// End:0xBD
			break;
	}
}

function ParsePacket_S_EX_NEW_HENNA_POTEN_SELECT()
{
	local UIPacket._S_EX_NEW_HENNA_POTEN_SELECT packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_NEW_HENNA_POTEN_SELECT(packet))
	{
		return;
	}
	Debug("---> S_EX_NEW_HENNA_POTEN_SELECT" @ string(packet.cSlotID) @ string(packet.nPotenID) @ string(packet.nActiveStep) @ string(packet.cSuccess));
	// End:0xFB
	if(packet.cSuccess > 0)
	{
		henna_list_packet.hennaInfoList[currentSelectSlot].nPotenID = packet.nPotenID;
		henna_list_packet.hennaInfoList[currentSelectSlot].nActiveStep = packet.nActiveStep;
		setLeftSlotButtonRefresh();
		groupButtonOnClickButton("", "", currentSelectSlot);
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13453));
	}
	InventoryWnd(GetScript("InventoryWnd"))._Handle_S_EX_NEW_HENNA_POTEN_SELECT(packet);
}

function ParsePacket_S_EX_NEW_HENNA_POTEN_ENCHANT()
{
	local UIPacket._S_EX_NEW_HENNA_POTEN_ENCHANT packet;
	local int resultExp, currentStepMaxExp, tempExp;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_NEW_HENNA_POTEN_ENCHANT(packet))
	{
		return;
	}
	Debug("---> S_EX_NEW_HENNA_POTEN_ENCHANT" @ string(packet.cSlotID) @ string(packet.nActiveStep) @ string(packet.nEnchantStep) @ string(packet.nEnchantExp) @ string(packet.nDailyStep) @ string(packet.nDailyCount) @ string(packet.cSuccess));
	Me.KillTimer(TIME_ID);
	Me.KillTimer(TIME_BAR_ID);
	currentActiveSteps.Length = henna_list_packet.hennaInfoList.Length;
	// End:0x11C
	if(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep == packet.nEnchantStep)
	{
		resultExp = packet.nEnchantExp - henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp;		
	}
	else
	{
		currentStepMaxExp = HennaMenuWndScript.getDyePotentialExp(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep).Exp;
		tempExp = currentStepMaxExp - henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp;
		resultExp = tempExp + packet.nEnchantExp;
		InventoryWnd(GetScript("InventoryWnd"))._ResetbRequestHennaOnShow();
	}
	Debug("resultExp" @ string(resultExp));
	henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep = packet.nEnchantStep;
	henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp = packet.nEnchantExp;
	henna_list_packet.hennaInfoList[currentSelectSlot].nActiveStep = packet.nActiveStep;
	henna_list_packet.hennaInfoList[currentSelectSlot].nDailyStep = packet.nSlotDailyStep;
	henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount = packet.nSlotDailyCount;
	henna_list_packet.nDailyStep = packet.nDailyStep;
	henna_list_packet.nDailyCount = packet.nDailyCount;
	GetStatusRoundHandle(m_WindowName $ ".EnchantDialog_wnd.LV_StatusRound").HideWindow();
	GetStatusRoundHandle(m_WindowName $ ".EnchantDialog_wnd.Enchant_StatusRound").HideWindow();
	GetStatusRoundHandle(m_WindowName $ ".EnchantDialog_wnd.EnchantApply_StatusRound").HideWindow();
	GetWindowHandle(m_WindowName $ ".EnchantDialog_wnd.Result_wnd").ShowWindow();
	GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.Result_wnd.ResultValueEffect_txt").SetText((GetSystemString(13822) $ "+") $ string(resultExp));
	GetTextureHandle(m_WindowName $ ".EnchantDialog_wnd.DiceSwap00").SetTexture("L2UI_NewTex.etc.Hn_Num" $ string(resultExp));
	GetButtonHandle(m_WindowName $ ".EnchantDialog_wnd.EnchantCheck_btn").ShowWindow();
	GetButtonHandle(m_WindowName $ ".EnchantDialog_wnd.EnchantApply_btn").HideWindow();
	GetButtonHandle(m_WindowName $ ".EnchantDialog_wnd.EnchantCancel_btn").HideWindow();
	GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.DialogDscrp_txt").SetText("");
	// End:0x6DF
	if(packet.cSuccess > 0)
	{
		// End:0x57D
		if(resultExp <= 0)
		{
			GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.Result_wnd.ResultValue_txt").SetText(GetSystemString(13821));
			playEffect("LineageEffect2.ui_upgrade_fail");
			PlaySound("ItemSound3.enchant_fail");			
		}
		else
		{
			// End:0x643
			if(dyePotentialFeeData.EnchantExps[dyePotentialFeeData.EnchantExps.Length - 1].Exp == resultExp)
			{
				GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.Result_wnd.ResultValue_txt").SetText(GetSystemString(13819));
				playEffect("LineageEffect.d_firework_b");
				PlaySound("ItemSound2.C3_Firework_explosion");				
			}
			else
			{
				GetTextBoxHandle(m_WindowName $ ".EnchantDialog_wnd.Result_wnd.ResultValue_txt").SetText(GetSystemString(13820));
				playEffect("LineageEffect2.ui_upgrade_succ");
				PlaySound("ItemSound3.enchant_success");
			}
		}		
	}
	else
	{
		OnEnchantCheck_btnClick();
		Me.HideWindow();
	}
}

function ParsePacket_S_EX_NEW_HENNA_LIST()
{
	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_NEW_HENNA_LIST(henna_list_packet))
	{
		return;
	}
	SetCurrentActiveSteps();
	InventoryWnd(GetScript("InventoryWnd"))._Handle_S_EX_NEW_HENNA_LIST(henna_list_packet);
}

function CustomTooltip getTooltipCustomQuestionMark()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	// End:0x3D
	if(isPrivateSlotEnchantState())
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14207), getInstanceL2Util().BrightWhite, "", true, false);		
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14206), getInstanceL2Util().BrightWhite, "", true, false);
	}
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13916), getInstanceL2Util().BrightWhite, "", true, false);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 200;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;	
}

function CustomTooltip getMainSlotCustomTooltip(int Level)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local SkillInfo SkillInfo;
	local DyePotentialUIData dyePotentialData;

	class'UIDATA_HENNA'.static.GetDyePotentialData(henna_list_packet.hennaInfoList[currentSelectSlot].nPotenID, dyePotentialData);
	GetSkillInfo(dyePotentialData.SkillID, Level, 0, SkillInfo);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13889) @ string(HennaMenuWndScript.getDyePotentialAccrueExp(Level)), getInstanceL2Util().Green, "", true, true);
	// End:0x1EE
	if(Len(SkillInfo.SkillDesc) > 0)
	{
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		// End:0x177
		if(henna_list_packet.hennaInfoList[currentSelectSlot].nActiveStep >= Level)
		{
			drawListArr[drawListArr.Length] = addDrawItemText("<" $ GetSystemString(13491) $ ">", getInstanceL2Util().Yellow, "", true, true);
			drawListArr[drawListArr.Length] = addDrawItemText(dyePotentialData.EffectName @ SkillInfo.SkillDesc, getInstanceL2Util().Yellow, "", true, true);			
		}
		else
		{
			drawListArr[drawListArr.Length] = addDrawItemText("<" $ GetSystemString(13491) $ ">", getInstanceL2Util().Gray, "", true, true);
			drawListArr[drawListArr.Length] = addDrawItemText(dyePotentialData.EffectName @ SkillInfo.SkillDesc, getInstanceL2Util().Gray, "", true, true);
		}
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function CustomTooltip GetPotentialButtonCustomTooltip(int SlotNum, string dyeItemInfoName, string EffectName, string effectNum, int dyeItemlevel)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13751), string(SlotNum)), getInstanceL2Util().BrightWhite, "hs12", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	// End:0xA3
	if(dyeItemInfoName != "")
	{
		drawListArr[drawListArr.Length] = addDrawItemText(dyeItemInfoName, getInstanceL2Util().BrightWhite, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	}
	// End:0xEC
	if(dyeItemlevel > 0)
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(5203), string(dyeItemlevel)), getInstanceL2Util().BrightWhite, "", true, true);
	}
	// End:0x13F
	if(EffectName != "")
	{
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(EffectName @ effectNum, getInstanceL2Util().BrightWhite, "", true, true);
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 50;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function CustomTooltip getTooltipCustomSuccessPercent()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local int Len, i;
	local string expStr;

	dyePotentialFeeData = getFeeDataProcess();
	Len = dyePotentialFeeData.EnchantExps.Length;
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13909), getInstanceL2Util().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);

	// End:0x1A9 [Loop If]
	for(i = i; i < Len; i++)
	{
		// End:0xF4
		if(dyePotentialFeeData.EnchantExps[i].Exp == 0)
		{
			expStr = string(dyePotentialFeeData.EnchantExps[i].Exp);			
		}
		else
		{
			expStr = "+" $ string(dyePotentialFeeData.EnchantExps[i].Exp);
		}
		drawListArr[drawListArr.Length] = addDrawItemText(expStr $ " : ", getInstanceL2Util().BrightWhite, "", true, false);
		drawListArr[drawListArr.Length] = addDrawItemText(string(dyePotentialFeeData.EnchantExps[i].Prob) $ "%", getInstanceL2Util().Yellow, "", false, false);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	}
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13916), getInstanceL2Util().BrightWhite, "", true, false);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function bool isPrivateSlotEnchantState()
{
	local DyePotentialFeeUIData rDyePotentialFeeData;

	rDyePotentialFeeData = getFeeDataProcess();
	// End:0x4D
	if((henna_list_packet.nDailyCount == 0 && henna_list_packet.hennaInfoList[currentSelectSlot].nDailyStep != 0) && rDyePotentialFeeData.DailyCount != 0)
	{
		return true;
	}
	return false;	
}

function setLeftSlotButtonRefresh()
{
	local DyePotentialUIData dyePotentialData;
	local int i, dyeItemlevel;
	local ItemInfo dyeItemInfo;
	local int dyeItemClassID;
	local SkillInfo SkillInfo;
	local string hennaIconName, effectNameStr, effectNumStr, dyeItemInfoName;

	// End:0x48D [Loop If]
	for(i = 0; i < henna_list_packet.hennaInfoList.Length; i++)
	{
		hennaIconName = class'UIDATA_HENNA'.static.GetIconTexS(henna_list_packet.hennaInfoList[i].nHennaID);
		GetTextureHandle(m_WindowName $ ".Category0" $ string(i + 1) $ "_wnd.Mark_tex").ShowWindow();
		GetTextureHandle(m_WindowName $ ".Category0" $ string(i + 1) $ "_wnd.Mark_tex").SetTexture(hennaIconName);
		// End:0x16C
		if(henna_list_packet.hennaInfoList[i].cActive > 0)
		{
			GetTextureHandle(((m_WindowName $ ".Category0") $ string(i + 1)) $ "_wnd.Empty_Tex").SetTexture("L2UI_EPIC.HennaClassicWnd.imprintDeco_Small2");
			groupButtons._SetEnable(i);			
		}
		else
		{
			GetTextureHandle(((m_WindowName $ ".Category0") $ string(i + 1)) $ "_wnd.Empty_Tex").SetTexture("L2UI_EPIC.HennaClassicWnd.imprintDeco_Lock");
			groupButtons._SetDisable(i);
		}
		setCircleBarRefresh(i, GetStatusRoundHandle(((m_WindowName $ ".Category0") $ string(i + 1)) $ "_wnd.LV_StatusRound"), GetStatusRoundHandle(((m_WindowName $ ".Category0") $ string(i + 1)) $ "_wnd.Enchant_StatusRound"), GetStatusRoundHandle(((m_WindowName $ ".Category0") $ string(i + 1)) $ "_wnd.EnchantApply_StatusRound"));
		// End:0x34C
		if(henna_list_packet.hennaInfoList[i].nHennaID > 0)
		{
			class'UIDATA_HENNA'.static.GetHennaDyeItemClassID(henna_list_packet.hennaInfoList[i].nHennaID, dyeItemClassID);
			dyeItemInfo = GetItemInfoByClassID(dyeItemClassID);
			class'UIDATA_HENNA'.static.GetHennaDyeItemLevel(henna_list_packet.hennaInfoList[i].nHennaID, dyeItemlevel);
			dyeItemInfoName = dyeItemInfo.Name;			
		}
		else
		{
			dyeItemInfoName = "";
			dyeItemlevel = 0;
		}
		// End:0x415
		if(henna_list_packet.hennaInfoList[i].nPotenID > 0)
		{
			class'UIDATA_HENNA'.static.GetDyePotentialData(henna_list_packet.hennaInfoList[i].nPotenID, dyePotentialData);
			effectNameStr = dyePotentialData.EffectName;
			GetSkillInfo(dyePotentialData.SkillID, henna_list_packet.hennaInfoList[i].nActiveStep, 0, SkillInfo);
			// End:0x408
			if(henna_list_packet.hennaInfoList[i].nActiveStep > 0)
			{
				effectNumStr = SkillInfo.SkillDesc;				
			}
			else
			{
				effectNumStr = "+0";
			}			
		}
		else
		{
			effectNameStr = "";
			effectNumStr = "";
		}
		GetButtonHandle(m_WindowName $ ".Category0" $ string(i + 1) $ "_wnd.Category_BTN").SetTooltipCustomType(GetPotentialButtonCustomTooltip(i + 1, dyeItemInfoName, effectNameStr, effectNumStr, dyeItemlevel));
	}
}

function setCircleBarRefresh(int i, StatusRoundHandle LV_StatusRound, StatusRoundHandle Enchant_StatusRound, StatusRoundHandle EnchantApply_StatusRound)
{
	local int dyeItemlevel, slotExp, currentSlotExp;

	class'UIDATA_HENNA'.static.GetHennaDyeItemLevel(henna_list_packet.hennaInfoList[i].nHennaID, dyeItemlevel);
	LV_StatusRound.SetPoint(HennaMenuWndScript.getDyePotentialAccrueExp(dyeItemlevel), HennaMenuWndScript.getDyePotentialTotalExp());
	currentSlotExp = HennaMenuWndScript.getDyePotentialAccrueExp(henna_list_packet.hennaInfoList[i].nEnchantStep - 1) + henna_list_packet.hennaInfoList[i].nEnchantExp;
	slotExp = HennaMenuWndScript.getDyePotentialAccrueExp(dyeItemlevel);
	// End:0xF6
	if(currentSlotExp > slotExp)
	{
		EnchantApply_StatusRound.SetPoint(slotExp, HennaMenuWndScript.getDyePotentialTotalExp());		
	}
	else
	{
		EnchantApply_StatusRound.SetPoint(currentSlotExp, HennaMenuWndScript.getDyePotentialTotalExp());
	}
	Enchant_StatusRound.SetPoint(currentSlotExp, HennaMenuWndScript.getDyePotentialTotalExp());
}

function API_C_EX_NEW_HENNA_POTEN_SELECT(int nSlotID, int nPotenID)
{
	local array<byte> stream;
	local UIPacket._C_EX_NEW_HENNA_POTEN_SELECT packet;

	packet.cSlotID = nSlotID;
	packet.nPotenID = nPotenID;
	// End:0x40
	if(! class'UIPacket'.static.Encode_C_EX_NEW_HENNA_POTEN_SELECT(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_NEW_HENNA_POTEN_SELECT, stream);
	Debug("Api Call -----> C_EX_NEW_HENNA_POTEN_SELECT" @ string(packet.cSlotID) @ string(packet.nPotenID));
}

function API_C_EX_NEW_HENNA_POTEN_ENCHANT(int nSlotID, int costItemID)
{
	local array<byte> stream;
	local UIPacket._C_EX_NEW_HENNA_POTEN_ENCHANT packet;

	packet.cSlotID = nSlotID;
	packet.costItemID = costItemID;
	// End:0x40
	if(! class'UIPacket'.static.Encode_C_EX_NEW_HENNA_POTEN_ENCHANT(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_NEW_HENNA_POTEN_ENCHANT, stream);
	Debug("Api Call -----> C_EX_NEW_HENNA_POTEN_ENCHANT" @ string(packet.cSlotID) @ string(packet.costItemID));
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	// End:0x3F
	if(GetWindowHandle(m_WindowName $ ".EnchantDialog_wnd").IsShowWindow())
	{
		OnEnchantCheck_btnClick();		
	}
	else
	{
		CloseUI();
	}
}

defaultproperties
{
}
