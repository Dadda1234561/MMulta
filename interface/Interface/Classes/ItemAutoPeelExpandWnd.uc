class ItemAutoPeelExpandWnd extends UICommonAPI
	dependson(ItemAutoPeelWnd);

const TIMER_ID_BTN_DELAY = 1;
const TIMER_DELAY_BTN_DISABLE = 500;
const LIST_ICON_SIZE = 32;
const LIST_TEXT_OFFSET = 4;
const MIN_PEEL_COUNT = 1;

var bool _isWaitingBtnDelay;
var WindowHandle Me;
var ButtonHandle autoPeelBtn;
var ButtonHandle resetBtn;
var ButtonHandle CloseBtn;
var ButtonHandle minimizeBtn;
var ButtonHandle setCountBtn;
var RichListCtrlHandle rareItemRichList;
var RichListCtrlHandle normalItemRichList;
var WindowHandle highGradeListBlockWnd;
var WindowHandle rareResultContainer;
var WindowHandle normalResultContainer;
var WindowHandle rareBlockWnd;
var WindowHandle rareBlockDescWnd;
var WindowHandle normalBlockDescWnd;
var WindowHandle DisableWnd;
var TextBoxHandle itemNameTextBox;
var UIControlNumberInput numberInput;

static function ItemAutoPeelExpandWnd Inst()
{
	return ItemAutoPeelExpandWnd(GetScript("ItemAutoPeelExpandWnd"));
}

function Initialize()
{
	initControls();
	_isWaitingBtnDelay = false;
}

function initControls()
{
	local string ownerFullPath;

	_isWaitingBtnDelay = false;
	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	autoPeelBtn = GetButtonHandle(ownerFullPath $ ".BoxOpen_Btn");
	resetBtn = GetButtonHandle(ownerFullPath $ ".PeelReset_Btn");
	minimizeBtn = GetButtonHandle(ownerFullPath $ ".Min_BTN");
	CloseBtn = GetButtonHandle(ownerFullPath $ ".WndClose_BTN");
	setCountBtn = GetButtonHandle(ownerFullPath $ ".MultiSell_Input_Button_2");
	itemNameTextBox = GetTextBoxHandle(ownerFullPath $ ".ItemName_txt");
	rareResultContainer = GetWindowHandle(ownerFullPath $ ".RareResultItem_wnd");
	normalResultContainer = GetWindowHandle(ownerFullPath $ ".NormalResultItem_wnd");
	DisableWnd = GetWindowHandle(ownerFullPath $ ".DisableWnd");
	rareBlockWnd = GetWindowHandle(rareResultContainer.m_WindowNameWithFullPath $ ".BlindScreen_tex");
	rareBlockDescWnd = GetWindowHandle(rareResultContainer.m_WindowNameWithFullPath $ ".DescriptionMsgWnd");
	normalBlockDescWnd = GetWindowHandle(normalResultContainer.m_WindowNameWithFullPath $ ".DescriptionMsgWnd");
	rareItemRichList = GetRichListCtrlHandle(rareResultContainer.m_WindowNameWithFullPath $ ".Item_ListCtrl");
	normalItemRichList = GetRichListCtrlHandle(normalResultContainer.m_WindowNameWithFullPath $ ".Item_ListCtrl");
	numberInput = class'UIControlNumberInput'.static.InitScript(GetWindowHandle(ownerFullPath $ ".UIControlNumberInput"));
	numberInput.DelegateGetCountCanBuy = GetMaxNumCanPeel;
	numberInput.DelegateOnItemCountEdited = OnItemPeelCountChanged;
	rareItemRichList.SetSelectedSelTooltip(false);
	normalItemRichList.SetSelectedSelTooltip(false);
	rareItemRichList.SetSelectable(false);
	normalItemRichList.SetSelectable(false);
	rareItemRichList.SetAppearTooltipAtMouseX(true);
	normalItemRichList.SetAppearTooltipAtMouseX(true);
}

function UpdateTargetItemControls()
{
	local ItemAutoPeelWnd.ItemAutoPeelInfo Info;

	Info = class'ItemAutoPeelWnd'.static.Inst().GetItemAutoPeelInfo();
	itemNameTextBox.SetText(Info.targetItemName);
}

function UpdateResultItemControls()
{
	local ItemAutoPeelWnd.ItemAutoPeelInfo Info;

	Info = class'ItemAutoPeelWnd'.static.Inst().GetItemAutoPeelInfo();
	// End:0x58
	if(Info.normalItemInfos.Length > 0)
	{
		normalBlockDescWnd.HideWindow();
		UpdateResultItemRichListControl(normalItemRichList, Info.normalItemInfos, false);		
	}
	else
	{
		normalBlockDescWnd.ShowWindow();
		normalItemRichList.DeleteAllItem();
	}
	// End:0xBE
	if(Info.rareItemInfos.Length > 0)
	{
		rareBlockWnd.HideWindow();
		rareBlockDescWnd.HideWindow();
		UpdateResultItemRichListControl(rareItemRichList, Info.rareItemInfos, true);		
	}
	else
	{
		rareBlockWnd.ShowWindow();
		rareBlockDescWnd.ShowWindow();
		rareItemRichList.DeleteAllItem();
	}
}

function UpdateResultItemRichListControl(RichListCtrlHandle targetControl, array<UIPacket._AutoPeelResultItem> infos, bool isRare)
{
	local int i, recordCnt;
	local bool needModify;
	local RichListCtrlRowData oldRowData, newRowData;
	local Color NameColor, cntColor;
	local ItemInfo resultItemInfo;
	local string toolTipParam;
	local L2Util util;
	local UIPacket._AutoPeelResultItem resultInfo;

	util = L2Util(GetScript("L2Util"));
	// End:0x4D
	if(isRare)
	{
		NameColor = util.White;
		cntColor = util.Yellow03;		
	}
	else
	{
		NameColor = util.ColorGold;
		cntColor = util.White;
	}
	recordCnt = targetControl.GetRecordCount();
	newRowData.cellDataList.Length = 1;

	// End:0x38A [Loop If]
	for(i = 0; i < infos.Length; i++)
	{
		resultInfo = infos[i];
		// End:0x1D6
		if(i < recordCnt)
		{
			targetControl.GetRec(i, oldRowData);
			// End:0x1CE
			if(oldRowData.nReserved1 == resultInfo.nItemClassID)
			{
				// End:0x123
				if(oldRowData.nReserved2 == resultInfo.nAmount)
				{
					// [Explicit Continue]
					continue;					
				}
				else
				{
					// End:0x164
					if(isRare)
					{
						oldRowData.sOverlayTex = GetAnounceBGTextureName(resultInfo.AnnounceLevel);
						oldRowData.OverlayTexU = 256;
						oldRowData.OverlayTexV = 32;
					}
					oldRowData.nReserved2 = resultInfo.nAmount;
					oldRowData.cellDataList[0].drawitems[2].strInfo.strData = "x" $ MakeCostString(string(resultInfo.nAmount));
					targetControl.ModifyRecord(i, oldRowData);
					// [Explicit Continue]
					continue;
				}				
			}
			else
			{
				needModify = true;
			}
		}
		newRowData.cellDataList[0].drawitems.Length = 0;
		resultItemInfo = GetItemInfoByClassID(resultInfo.nItemClassID);
		util.GetEllipsisString(resultItemInfo.Name, 210);
		ItemInfoToParam(resultItemInfo, toolTipParam);
		newRowData.szReserved = toolTipParam;
		newRowData.nReserved1 = resultInfo.nItemClassID;
		newRowData.nReserved2 = resultInfo.nAmount;
		newRowData.ForceRefreshTooltip = true;
		// End:0x2B5
		if(isRare)
		{
			newRowData.sOverlayTex = GetAnounceBGTextureName(resultInfo.AnnounceLevel);
			newRowData.OverlayTexU = 256;
			newRowData.OverlayTexV = 32;
		}
		AddRichListCtrlItem(newRowData.cellDataList[0].drawitems, resultItemInfo);
		addRichListCtrlString(newRowData.cellDataList[0].drawitems, resultItemInfo.Name, NameColor, false, 4, 4 - 2);
		addRichListCtrlString(newRowData.cellDataList[0].drawitems, "x" $ MakeCostString(string(resultInfo.nAmount)), cntColor, true, 32 + 4, 4);
		// End:0x36C
		if(needModify == true)
		{
			needModify = false;
			targetControl.ModifyRecord(i, newRowData);
			// [Explicit Continue]
			continue;
		}
		targetControl.InsertRecord(newRowData);
	}
}

function UpdateButtonControls()
{
	local ItemAutoPeelWnd.ItemAutoPeelInfo Info;
	local L2Util util;
	local bool countBtnEnabled, autoPeelBtnEnabled;

	Info = class'ItemAutoPeelWnd'.static.Inst().GetItemAutoPeelInfo();
	util = getInstanceL2Util();
	autoPeelBtn.SetTexture("L2UI_NewTex.Button.Button29_DF", "Button29_Down", "L2UI_NewTex.Button.Button29_Over");
	// End:0x1C8
	if(Info.targetItemSId != 0)
	{
		// End:0x1A1
		if(Info.isPeeling == true)
		{
			// End:0xE4
			if(Info.isPause == true)
			{
				autoPeelBtn.SetButtonName(1731);
				autoPeelBtnEnabled = true;
				countBtnEnabled = false;				
			}
			else
			{
				autoPeelBtn.SetTexture("L2UI_NewTex.ButtonEffect.BTNEnchant_Over_0001", "L2UI_NewTex.ButtonEffect.BTNEnchant_Normal", "L2UI_NewTex.ButtonEffect.BTNEnchant_Normal");
				autoPeelBtn.SetButtonName(14042);
				autoPeelBtnEnabled = true;
				countBtnEnabled = false;
			}			
		}
		else
		{
			autoPeelBtn.SetButtonName(14041);
			autoPeelBtnEnabled = true;
			countBtnEnabled = true;
		}		
	}
	else
	{
		autoPeelBtn.SetButtonName(14041);
		autoPeelBtnEnabled = false;
		countBtnEnabled = false;
	}
	autoPeelBtn.SetEnable(autoPeelBtnEnabled);
	resetBtn.SetEnable(countBtnEnabled);
	setCountBtn.SetEnable(countBtnEnabled);
	numberInput._SetForceDisable(! countBtnEnabled);
	// End:0x26B
	if(countBtnEnabled)
	{
		numberInput._SetEditBoxFontColor(util.White);		
	}
	else
	{
		numberInput._SetEditBoxFontColor(util.Gray);
	}
}

function UpdateNumberInputControls()
{
	local ItemAutoPeelWnd.ItemAutoPeelInfo Info;

	Info = class'ItemAutoPeelWnd'.static.Inst().GetItemAutoPeelInfo();
	// End:0x49
	if(Info.isPeeling == false)
	{
		numberInput.SetCount(Info.totalPeelCnt);
	}
}

function UpdateUIControls()
{
	UpdateTargetItemControls();
	UpdateResultItemControls();
	UpdateButtonControls();
	UpdateNumberInputControls();
}

function ShowDisableWnd(bool isShow)
{
	// End:0x1B
	if(isShow)
	{
		DisableWnd.ShowWindow();		
	}
	else
	{
		DisableWnd.HideWindow();
	}
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

function string GetAnounceBGTextureName(int anounceLevel)
{
	local int rareAnounceLevel, validAnounceLevel;

	rareAnounceLevel = class'ItemAutoPeelWnd'.const.RARE_ANOUNCE_LEVEL;
	validAnounceLevel = Min(anounceLevel, rareAnounceLevel + 2);
	switch(validAnounceLevel)
	{
		// End:0x6B
		case rareAnounceLevel:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelListBG_Lv4";
		// End:0xAB
		case rareAnounceLevel + 1:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelListBG_Lv5";
		// End:0xEC
		case rareAnounceLevel + 2:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelListBG_Lv6";
		// End:0xFFFF
		default:
			return "";
	}
}

function INT64 GetMaxNumCanPeel()
{
	return class'ItemAutoPeelWnd'.static.Inst().GetTargetItemNum();
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x20
		case "BoxOpen_Btn":
			OnItemAutoPeelBtnClicked();
			// End:0x93
			break;
		// End:0x3B
		case "PeelReset_Btn":
			OnResetBtnClicked();
			// End:0x93
			break;
		// End:0x55
		case "WndClose_BTN":
			OnCloseBtnClicked();
			// End:0x93
			break;
		// End:0x6A
		case "Min_BTN":
			OnMinimizeBtnClicked();
			// End:0x93
			break;
		// End:0x90
		case "MultiSell_Input_Button_2":
			OnSetCountBtnClicked();
			// End:0x93
			break;
	}
}

event OnTimer(int TimerID)
{
	// End:0x11
	if(TimerID == TIMER_ID_BTN_DELAY)
	{
		KillBtnDelayTimer();
	}
}

event OnSetFocus(WindowHandle a_WindowHandle, bool IsFocused)
{
	// End:0x2B
	if(IsFocused)
	{
		class'ItemAutoPeelWnd'.static.Inst().m_hOwnerWnd.BringToFront();
	}
}

event OnItemAutoPeelBtnClicked()
{
	local ItemAutoPeelWnd.ItemAutoPeelInfo Info;

	// End:0x0E
	if(_isWaitingBtnDelay == true)
	{
		return;
	}
	Info = class'ItemAutoPeelWnd'.static.Inst().GetItemAutoPeelInfo();
	StartBtnDelayTimer();
	// End:0xB6
	if(Info.targetItemSId != 0)
	{
		// End:0x9D
		if(Info.isPeeling == true)
		{
			// End:0x81
			if(Info.isPause == true)
			{
				class'ItemAutoPeelWnd'.static.Inst().StartItemAutoPeel();				
			}
			else
			{
				class'ItemAutoPeelWnd'.static.Inst().PauseItemAutoPeel();
			}			
		}
		else
		{
			class'ItemAutoPeelWnd'.static.Inst().StartItemAutoPeel();
		}
	}
}

event OnItemPeelCountChanged(INT64 ItemCount)
{
	class'ItemAutoPeelWnd'.static.Inst().SetTargetTotalPeelCnt(ItemCount);
}

event OnResetBtnClicked()
{
	// End:0x0E
	if(_isWaitingBtnDelay == true)
	{
		return;
	}
	StartBtnDelayTimer();
	class'ItemAutoPeelWnd'.static.Inst().ResetTargetItem();
}

event OnSetCountBtnClicked()
{
	class'ItemAutoPeelWnd'.static.Inst().ShowItemCountDialog();
}

event OnCloseBtnClicked()
{
	class'ItemAutoPeelWnd'.static.Inst().CloseWindow();
}

event OnMinimizeBtnClicked()
{
	class'ItemAutoPeelWnd'.static.Inst().SetExpand(false);
}

event OnReceivedCloseUI()
{
	class'ItemAutoPeelWnd'.static.Inst().CloseWindow();
}

defaultproperties
{
}
