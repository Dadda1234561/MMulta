class PrisonWnd extends UICommonAPI;

const MIN_PRISON_TYPE = 1;
const MAX_PRISON_TYPE = 3;

var WindowHandle Me;
var WindowHandle modalWnd;
var WindowHandle prisonDisableWnd;
var WindowHandle itemInfoWnd;
var TextureHandle prisonBGTex;
var ButtonHandle prisonPrevBtn;
var ButtonHandle prisonNextBtn;
var ButtonHandle donationBtn;
var TextBoxHandle prisonNameTextBox;
var TextBoxHandle prisonDescTextBox;
var TextBoxHandle remainTimeTextBox;
var TextBoxHandle currentCntTextBox;
var TextBoxHandle maxCntTextBox;
var TextBoxHandle cntDivisionTextBox;
var ItemWindowHandle itemWnd;
var UIControlDialogAssets donationDialog;
var array<WindowHandle> tabBtnWnds;
var int _currentPrisonType;

static function PrisonWnd Inst()
{
	return PrisonWnd(GetScript("PrisonWnd"));	
}

function Initialize()
{
	initControls();	
}

function initControls()
{
	local string ownerFullPath;
	local WindowHandle mainContainer;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	mainContainer = GetWindowHandle(ownerFullPath $ ".MainPrison");
	prisonBGTex = GetTextureHandle(mainContainer.m_WindowNameWithFullPath $ ".MainPrisonBG");
	prisonPrevBtn = GetButtonHandle(mainContainer.m_WindowNameWithFullPath $ ".MainArrowLeft_btn");
	prisonNextBtn = GetButtonHandle(mainContainer.m_WindowNameWithFullPath $ ".MainArrowRight_btn");
	prisonNameTextBox = GetTextBoxHandle(mainContainer.m_WindowNameWithFullPath $ ".MainPrisonName");
	prisonDescTextBox = GetTextBoxHandle(mainContainer.m_WindowNameWithFullPath $ ".MainPrisonStory_txt");
	remainTimeTextBox = GetTextBoxHandle(mainContainer.m_WindowNameWithFullPath $ ".PrisonTimer");
	currentCntTextBox = GetTextBoxHandle(mainContainer.m_WindowNameWithFullPath $ ".PrisonWorkRemain_txt");
	itemInfoWnd = GetWindowHandle(mainContainer.m_WindowNameWithFullPath $ ".CollectItem_Wnd");
	maxCntTextBox = GetTextBoxHandle(itemInfoWnd.m_WindowNameWithFullPath $ ".PrisonWorkGoal_txt");
	cntDivisionTextBox = GetTextBoxHandle(itemInfoWnd.m_WindowNameWithFullPath $ ".PrisonWorkSlash_txt");
	itemWnd = GetItemWindowHandle(itemInfoWnd.m_WindowNameWithFullPath $ ".CollectItem");
	donationBtn = GetButtonHandle(ownerFullPath $ ".Donation_btn");
	prisonDisableWnd = GetWindowHandle(mainContainer.m_WindowNameWithFullPath $ ".MainDisableWnd");
	modalWnd = GetWindowHandle(ownerFullPath $ ".WindowDisable_Wnd");
	donationDialog = class'UIControlDialogAssets'.static.InitScript(GetWindowHandle(modalWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset"));
	donationDialog.SetDisableWindow(modalWnd);
	tabBtnWnds.Length = 0;
	tabBtnWnds[tabBtnWnds.Length] = GetItemWindowHandle(mainContainer.m_WindowNameWithFullPath $ ".Prison1");
	tabBtnWnds[tabBtnWnds.Length] = GetItemWindowHandle(mainContainer.m_WindowNameWithFullPath $ ".Prison2");
	tabBtnWnds[tabBtnWnds.Length] = GetItemWindowHandle(mainContainer.m_WindowNameWithFullPath $ ".Prison3");	
}

function UpdateUIContols()
{
	UpdatePrisonPanelControls();
	UpdatePrisonRemainTimeControl();
	UpdatePrisonNeedItemControl();	
}

function UpdatePrisonPanelControls()
{
	local PrisonUIData prisonData;
	local PrisonNoticeHUD.PrisonUIInfo inPrisonInfo;
	local int RemainTime, currentItemCnt, maxItemCnt, ItemID;
	local ItemInfo ItemInfo;
	local Color currentCntColor;

	// End:0x17
	if(Me.IsShowWindow() == false)
	{
		return;
	}
	// End:0x32
	if(_currentPrisonType <= 0 || _currentPrisonType > 3)
	{
		return;
	}
	GetPrisonData(_currentPrisonType, prisonData);
	inPrisonInfo = class'PrisonNoticeHUD'.static.Inst().GetInPrisonInfo();
	prisonNameTextBox.SetText(GetSystemString(class'PrisonNoticeHUD'.static.Inst().GetPrisonTitleStringId(prisonData.PrisonType)));
	prisonDescTextBox.SetText(GetSystemString(GetPrisonDescStringId(prisonData.PrisonType)));
	prisonBGTex.SetTexture(GetPrisonBGTextureName(prisonData.PrisonType));
	maxItemCnt = int(prisonData.NeedItem.Amount);
	ItemID = prisonData.NeedItem.Id;
	// End:0x125
	if(ItemID != 0)
	{
		ItemInfo = GetItemInfoByClassID(ItemID);
	}
	// End:0x180
	if(prisonData.PrisonType == inPrisonInfo.PrisonType)
	{
		RemainTime = inPrisonInfo.uiRemainTime;
		currentItemCnt = inPrisonInfo.currentItemCnt;
		donationBtn.SetEnable(true);
		prisonDisableWnd.HideWindow();		
	}
	else
	{
		RemainTime = prisonData.HoldingMinute * 60;
		currentItemCnt = 0;
		donationBtn.SetEnable(false);
		prisonDisableWnd.ShowWindow();
	}
	remainTimeTextBox.SetText(class'PrisonNoticeHUD'.static.Inst().GetRemainTimeText(RemainTime));
	// End:0x220
	if(maxItemCnt == 0 || ItemID == 0)
	{
		itemWnd.Clear();
		itemInfoWnd.HideWindow();		
	}
	else
	{
		// End:0x24E
		if(! itemWnd.SetItem(0, ItemInfo))
		{
			itemWnd.AddItem(ItemInfo);
		}
		currentCntTextBox.SetText(string(currentItemCnt));
		maxCntTextBox.SetText(string(maxItemCnt));
		itemInfoWnd.ShowWindow();
		// End:0x2AF
		if(currentItemCnt >= maxItemCnt)
		{
			currentCntColor = GetColor(238, 170, 34, 255);			
		}
		else
		{
			currentCntColor = GetColor(221, 221, 221, 255);
		}
		currentCntTextBox.SetTextColor(currentCntColor);
	}	
}

function UpdateTabButtonControls()
{
	local PrisonNoticeHUD.PrisonUIInfo inPrisonInfo;
	local PrisonUIData prisonData;
	local int i, targetPrisonType;
	local TextureHandle tempSelectTex, tempInPrisonTex;
	local CustomTooltip toolTipInfo;
	local array<DrawItemInfo> drawListArr;
	local string adenaString;
	local ItemInfo tooltipItemInfo;
	local int W, h;

	// End:0x17
	if(Me.IsShowWindow() == false)
	{
		return;
	}
	// End:0x32
	if((_currentPrisonType <= 0) || _currentPrisonType > 3)
	{
		return;
	}
	GetPrisonData(_currentPrisonType, prisonData);
	inPrisonInfo = class'PrisonNoticeHUD'.static.Inst().GetInPrisonInfo();

	// End:0x156 [Loop If]
	for(i = 0; i <= tabBtnWnds.Length; i++)
	{
		targetPrisonType = i + 1;
		tempSelectTex = GetTextureHandle(tabBtnWnds[i].m_WindowNameWithFullPath $ ".PrisonSelect");
		tempInPrisonTex = GetTextureHandle(tabBtnWnds[i].m_WindowNameWithFullPath $ ".PrisonPanel");
		// End:0x10D
		if(inPrisonInfo.PrisonType == targetPrisonType)
		{
			tempInPrisonTex.ShowWindow();			
		}
		else
		{
			tempInPrisonTex.HideWindow();
		}
		// End:0x13D
		if(_currentPrisonType == targetPrisonType)
		{
			tempSelectTex.ShowWindow();
			// [Explicit Continue]
			continue;
		}
		tempSelectTex.HideWindow();
	}
	tooltipItemInfo = GetItemInfoByClassID(57);
	GetTextSizeDefault(tooltipItemInfo.Name, W, h);
	adenaString = "x" $ MakeCostStringINT64(prisonData.DonationAdena);
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom(tooltipItemInfo.IconName, false, true, 5, 4, 32, 32);
	drawListArr[drawListArr.Length] = addDrawItemText(tooltipItemInfo.Name, getInstanceL2Util().ColorDesc, "", false, false, 4, 6);
	drawListArr[drawListArr.Length] = addDrawItemText("x" $ MakeCostStringINT64(prisonData.DonationAdena), getInstanceL2Util().White, "", false, false, - W, h + 6);
	toolTipInfo = MakeTooltipMultiTextByArray(drawListArr);
	GetTextSizeDefault(adenaString, W, h);
	toolTipInfo.MinimumWidth = W + 50;
	donationBtn.SetTooltipCustomType(toolTipInfo);	
}

function UpdatePrisonRemainTimeControl();

function UpdatePrisonNeedItemControl();

function ShowDonationDialog()
{
	local PrisonNoticeHUD.PrisonUIInfo inPrisonInfo;

	inPrisonInfo = class'PrisonNoticeHUD'.static.Inst().GetInPrisonInfo();
	// End:0x4C
	if((inPrisonInfo.PrisonType != _currentPrisonType) || inPrisonInfo.prisonData.DonationAdena == 0)
	{
		return;
	}
	donationDialog.SetUseNeedItem(true);
	donationDialog.StartNeedItemList(1);
	donationDialog.SetDialogDesc(GetSystemMessage(13765));
	donationDialog.AddNeedItemClassID(57, inPrisonInfo.prisonData.DonationAdena);
	donationDialog.SetItemNum(1);
	donationDialog.Show();
	donationDialog.DelegateOnClickBuy = OnDonationDialogConfirm;
	donationDialog.DelegateOnCancel = OnDonationDialogCancel;	
}

function OpenPrisonWnd()
{
	_currentPrisonType = class'PrisonNoticeHUD'.static.Inst().GetInPrisonType();
	// End:0x3C
	if(_currentPrisonType == 0)
	{
		Me.HideWindow();		
	}
	else
	{
		Me.ShowWindow();
	}	
}

function ClosePrisonWnd()
{
	Me.HideWindow();	
}

function ToggleOpenPrisonWnd()
{
	// End:0x1B
	if(Me.IsShowWindow())
	{
		ClosePrisonWnd();		
	}
	else
	{
		OpenPrisonWnd();
	}	
}

function ShowDonationSuccessDialog()
{
	DialogShow(DialogModalType_Modalless, DialogType_OK, GetSystemMessage(13766), string(self));	
}

function SetCurrentPrisonType(int PrisonType)
{
	_currentPrisonType = PrisonType;
	UpdateTabButtonControls();
	UpdateUIContols();	
}

function string GetPrisonBGTextureName(int PrisonType)
{
	switch(PrisonType)
	{
		// End:0x39
		case 1:
			return "L2UI_NewTex.CursedVillageWnd.PrisonMainBG01";
		// End:0x6C
		case 2:
			return "L2UI_NewTex.CursedVillageWnd.PrisonMainBG02";
		// End:0x9F
		case 3:
			return "L2UI_NewTex.CursedVillageWnd.PrisonMainBG03";
	}
	return "";
}

function int GetPrisonDescStringId(int PrisonType)
{
	switch(PrisonType)
	{
		// End:0x11
		case 1:
			return 14216;
		// End:0x1C
		case 2:
			return 14217;
		// End:0x27
		case 3:
			return 14218;
	}
	return 0;
}

function Rq_C_EX_PRISON_USER_DONATION()
{
	local array<byte> stream;
	local UIPacket._C_EX_PRISON_USER_DONATION packet;

	// End:0x20
	if(! class'UIPacket'.static.Encode_C_EX_PRISON_USER_DONATION(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PRISON_USER_DONATION, stream);	
}

function Rs_S_EX_PRISON_USER_DONATION()
{
	local UIPacket._S_EX_PRISON_USER_DONATION packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PRISON_USER_DONATION(packet))
	{
		return;
	}
	ClosePrisonWnd();
	// End:0x39
	if(bool(packet.bSuccess))
	{
		ShowDonationSuccessDialog();		
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13774));
	}	
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_PRISON_USER_DONATION));	
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_PRISON_USER_DONATION):
			Rs_S_EX_PRISON_USER_DONATION();
			// End:0x2A
			break;
	}	
}

event OnClickButton(string buttonStr)
{
	switch(buttonStr)
	{
		// End:0x26
		case "PrisonNomal_Btn1":
			SetCurrentPrisonType(1);
			// End:0xFF
			break;
		// End:0x46
		case "PrisonNomal_Btn2":
			SetCurrentPrisonType(2);
			// End:0xFF
			break;
		// End:0x66
		case "PrisonNomal_Btn3":
			SetCurrentPrisonType(3);
			// End:0xFF
			break;
		// End:0x86
		case "MainArrowLeft_btn":
			OnNavigateBtnClicked(false);
			// End:0xFF
			break;
		// End:0xA7
		case "MainArrowRight_btn":
			OnNavigateBtnClicked(true);
			// End:0xFF
			break;
		// End:0xC1
		case "Donation_btn":
			ShowDonationDialog();
			// End:0xFF
			break;
		// End:0xD8
		case "Close_btn":
			ClosePrisonWnd();
			// End:0xFF
			break;
		// End:0xFC
		case "HelpWnd_Btn":
			//class'HelpWnd'.static.ShowHelp(65);
			// End:0xFF
			break;
	}
}

event OnNavigateBtnClicked(bool isNext)
{
	local int targetPrisonType;

	targetPrisonType = _currentPrisonType;
	// End:0x31
	if(isNext)
	{
		targetPrisonType++;
		// End:0x2E
		if(targetPrisonType > 3)
		{
			targetPrisonType = 1;
		}		
	}
	else
	{
		targetPrisonType--;
		// End:0x4B
		if(targetPrisonType < 1)
		{
			targetPrisonType = 3;
		}
	}
	SetCurrentPrisonType(targetPrisonType);	
}

event OnDonationDialogConfirm()
{
	Rq_C_EX_PRISON_USER_DONATION();
	donationDialog.Hide();	
}

event OnDonationDialogCancel()
{
	donationDialog.Hide();	
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();	
}

event OnShow()
{
	UpdateUIContols();
	UpdateTabButtonControls();
	Me.SetFocus();	
}

event OnReceivedCloseUI()
{
	// End:0x2D
	if(donationDialog.Me.IsShowWindow())
	{
		donationDialog.Hide();		
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}	
}

defaultproperties
{
}
