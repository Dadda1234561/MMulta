class BottomBar extends UICommonAPI;

const TIMER_ID_SUPPRESS = 1;
const ITEM_ID_A_COIN = 97145;
const ITEM_ID_GIRAN_COIN = 92314;

enum EBottomBarBtnType 
{
	TypeNone,
	PostBox,
	Clan,
	Party,
	PcCafePoint,
	LCoinShop,
	adena,
	Inventory,
	Suppress,
	MagicLamp,
	RandomCraft,
	LCoinCraft,
	VitaminManager,
	DualInventory
};

enum EExpBoostType 
{
	ExpBoostNone,
	ExpBoostVital,
	ExpBoostBuff,
	ExpBoostPassive,
	ExpBoostMax
};

struct BottomBarInfo
{
	var UIPacket._S_EX_USER_BOOST_STAT expBoostInfos[4];
	var float expPercentRate;
	var int unreadMailCnt;
	var bool isClanMember;
	var int clanMemberCnt;
	var INT64 bloodyCoinCnt;
	var INT64 adenaCnt;
	var INT64 aCoinCnt;
	var INT64 giranCoinCnt;
	var int PcCafePoint;
	var int invenCnt;
	var int invenMaxCnt;
	var int suppressId;
	var int suppressKeyCnt;
	var bool isSuppressMaxKey;
	var bool isSuppressHotTime;
	var string suppressName;
	var int suppressPoint;
	var int suppressMaxPoint;
	var bool isMagicLampOpen;
	var int magicLampCnt;
	var int magicLampExp;
	var int magicLampMaxExp;
	var bool isAlreadyMagicLampAlarm;
	var int randomCraftPoint;
	var int randomCraftCharge;
	var int carringWeight;
	var int carryWeight;
	var bool isPartyOnState;
	var bool isPartyAlarm;
	var bool isPartyWndMinimized;
};

struct BottomBarBtnInfo
{
	var EBottomBarBtnType Type;
	var WindowHandle btnWnd;
	var Rect defaultRect;
};

var array<BottomBarBtnInfo> _bottomBarBtns;
var array<EBottomBarBtnType> _availableBtnGroup;
var BottomBarInfo _bottomBarInfo;
var WindowHandle Me;
var ButtonHandle expBoostBtn;
var StatusBarHandle expStatusBar;
var WindowHandle expInfoWnd;
var TextBoxHandle expTextBox;
var TextBoxHandle expBoostTextBox;
var TextureHandle expBoostOnTex;
var TextureHandle expBoostOffTex;

static function BottomBar Inst()
{
	return BottomBar(GetScript("BottomBar"));	
}

function Initialize()
{
	InitControls();	
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle btnContainerWnd;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	InitAvailableBtnGroupInfo();
	Me = GetWindowHandle(ownerFullPath);
	expStatusBar = GetStatusBarHandle(ownerFullPath $ ".ExpStatusBar");
	expStatusBar.SetDrawPoint(false);
	btnContainerWnd = GetWindowHandle(ownerFullPath $ ".btnContainer");
	expInfoWnd = GetWindowHandle(ownerFullPath $ ".ExpInfoWnd");
	expTextBox = GetTextBoxHandle(ownerFullPath $ ".ExpInfoWnd.ExpPercentWnd.ExpPercent_txt");
	expBoostTextBox = GetTextBoxHandle(ownerFullPath $ ".ExpInfoWnd.ExpBoostingWnd.ExpBoosting_txt");
	expBoostBtn = GetButtonHandle(ownerFullPath $ ".ExpInfoWnd.ExpBoostingWnd.ExpBoostingBg");
	expBoostOnTex = GetTextureHandle(ownerFullPath $ ".ExpInfoWnd.ExpBoostingWnd.BoostingArrowOn_tex");
	expBoostOffTex = GetTextureHandle(ownerFullPath $ ".ExpInfoWnd.ExpBoostingWnd.BoostingArrowOff_tex");
	_bottomBarBtns.Length = 0;
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "postBoxBtnWnd", EBottomBarBtnType.PostBox/*1*/);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "clanBtnWnd", EBottomBarBtnType.Clan/*2*/);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "partyBtnWnd", EBottomBarBtnType.Party/*3*/);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "suppressBtnWnd", EBottomBarBtnType.Suppress/*8*/);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "magicLampBtnWnd", EBottomBarBtnType.MagicLamp/*9*/);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "randomCraftBtnWnd", EBottomBarBtnType.RandomCraft/*10*/);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "LCoinCraftBtnWnd", EBottomBarBtnType.LCoinCraft/*11*/);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "vitaminManagerBtnWnd", EBottomBarBtnType.VitaminManager/*12*/);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "pcCafePointBtnWnd", EBottomBarBtnType.PcCafePoint/*4*/);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "LCoinShopBtnWnd", EBottomBarBtnType.LCoinShop/*5*/);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "adenaBtnWnd", EBottomBarBtnType.adena/*6*/);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "inventoryBtnWnd", EBottomBarBtnType.Inventory/*7*/);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "dualInventoryBtnWnd", EBottomBarBtnType.DualInventory/*13*/);
	InitShowBtns();	
}

function InitAvailableBtnGroupInfo()
{
	_availableBtnGroup.Length = 0;
	// End:0xB7
	if(getInstanceUIData().getIsClassicServer())
	{
		_availableBtnGroup[_availableBtnGroup.Length] = Clan;
		_availableBtnGroup[_availableBtnGroup.Length] = Suppress;
		// End:0x51
		if(IsAdenServer())
		{
			_availableBtnGroup[_availableBtnGroup.Length] = MagicLamp;
		}
		_availableBtnGroup[_availableBtnGroup.Length] = RandomCraft;
		_availableBtnGroup[_availableBtnGroup.Length] = LCoinCraft;
		// End:0x87
		if(IsShowPcCafe())
		{
			_availableBtnGroup[_availableBtnGroup.Length] = PcCafePoint;
		}
		_availableBtnGroup[_availableBtnGroup.Length] = LCoinShop;
		_availableBtnGroup[_availableBtnGroup.Length] = adena;
		_availableBtnGroup[_availableBtnGroup.Length] = DualInventory;		
	}
	else
	{
		_availableBtnGroup[_availableBtnGroup.Length] = PostBox;
		_availableBtnGroup[_availableBtnGroup.Length] = Clan;
		_availableBtnGroup[_availableBtnGroup.Length] = Party;
		_availableBtnGroup[_availableBtnGroup.Length] = RandomCraft;
		// End:0xFC
		if(IsShowPcCafe())
		{
			_availableBtnGroup[_availableBtnGroup.Length] = PcCafePoint;
		}
		_availableBtnGroup[_availableBtnGroup.Length] = LCoinShop;
		_availableBtnGroup[_availableBtnGroup.Length] = adena;
		_availableBtnGroup[_availableBtnGroup.Length] = Inventory;
	}	
}

function AddBottomBarBtnControls(out array<BottomBarBtnInfo> OutArray, string ownerPath, string targetWndName, EBottomBarBtnType Type)
{
	local BottomBarBtnInfo btnInfo;
	local WindowHandle btnWnd;

	btnWnd = GetWindowHandle(ownerPath $ "." $ targetWndName);
	// End:0x7D
	if(btnWnd.m_pTargetWnd != none)
	{
		btnInfo.btnWnd = btnWnd;
		btnInfo.Type = Type;
		btnInfo.defaultRect = btnWnd.GetRect();
		OutArray[OutArray.Length] = btnInfo;
	}	
}

function InitShowBtns()
{
	local int i;
	local BottomBarBtnInfo btnInfo;

	// End:0xC6 [Loop If]
	for(i = 0; i < _bottomBarBtns.Length; i++)
	{
		btnInfo = _bottomBarBtns[i];
		// End:0x84
		if(IsAvailableBtnType(btnInfo.Type))
		{
			btnInfo.btnWnd.ShowWindow();
			btnInfo.btnWnd.SetWindowSize(btnInfo.defaultRect.nWidth, btnInfo.defaultRect.nHeight);
			// [Explicit Continue]
			continue;
		}
		btnInfo.btnWnd.SetWindowSize(0, btnInfo.defaultRect.nHeight);
		btnInfo.btnWnd.HideWindow();
	}	
}

function RegistAndShowBtn(EBottomBarBtnType Type)
{
	local BottomBarBtnInfo btnInfo;

	btnInfo = GetBottomBarBtnInfo(Type);
	// End:0x43
	if((btnInfo.Type == 0) || btnInfo.btnWnd.m_pTargetWnd == none)
	{
		return;
	}
	// End:0xB4
	if(IsAvailableBtnType(Type))
	{
		if(btnInfo.btnWnd.IsShowWindow() == false)
		{
			btnInfo.btnWnd.ShowWindow();
			btnInfo.btnWnd.SetWindowSize(btnInfo.defaultRect.nWidth, btnInfo.defaultRect.nHeight);
		}		
	}
	else
	{
		_availableBtnGroup[_availableBtnGroup.Length] = Type;
		btnInfo.btnWnd.SetWindowSize(btnInfo.defaultRect.nWidth, btnInfo.defaultRect.nHeight);
		btnInfo.btnWnd.ShowWindow();
	}	
}

function UnregistAndHideBtn(EBottomBarBtnType Type)
{
	local BottomBarBtnInfo btnInfo;

	btnInfo = GetBottomBarBtnInfo(Type);
	// End:0x43
	if((btnInfo.Type == 0) || btnInfo.btnWnd.m_pTargetWnd == none)
	{
		return;
	}
	// End:0xDF
	if(IsAvailableBtnType(Type) || btnInfo.btnWnd.IsShowWindow() == true)
	{
		btnInfo.btnWnd.SetWindowSize(0, btnInfo.defaultRect.nHeight);
		btnInfo.btnWnd.HideWindow();
	}	
}

function ResetInfo()
{
	local BottomBarInfo defaultInfo;

	_bottomBarInfo = defaultInfo;	
}

function WindowHandle GetBottomBarBtnWnd(EBottomBarBtnType Type)
{
	local int i;
	local WindowHandle btnWnd;
	local BottomBarBtnInfo btnInfo;

	// End:0x5D [Loop If]
	for(i = 0; i < _bottomBarBtns.Length; i++)
	{
		btnInfo = _bottomBarBtns[i];
		// End:0x53
		if(btnInfo.Type == Type)
		{
			btnWnd = btnInfo.btnWnd;
			// [Explicit Break]
			break;
		}
	}
	return btnWnd;	
}

function BottomBarBtnInfo GetBottomBarBtnInfo(EBottomBarBtnType Type)
{
	local int i;
	local BottomBarBtnInfo btnInfo;

	// End:0x53 [Loop If]
	for(i = 0; i < _bottomBarBtns.Length; i++)
	{
		// End:0x49
		if(_bottomBarBtns[i].Type == Type)
		{
			btnInfo = _bottomBarBtns[i];
			// [Explicit Break]
			break;
		}
	}
	return btnInfo;	
}

function int GetBottomBarBtnsIndex(EBottomBarBtnType Type)
{
	local int i;

	// End:0x45 [Loop If]
	for(i = 0; i < _bottomBarBtns.Length; i++)
	{
		// End:0x3B
		if(_bottomBarBtns[i].Type == Type)
		{
			return i;
		}
	}
	return -1;	
}

function string GetExpBoostString(EExpBoostType Type)
{
	switch(Type)
	{
		// End:0x18
		case EExpBoostType.ExpBoostVital/*1*/:
			return GetSystemString(13143);
		// End:0x29
		case EExpBoostType.ExpBoostPassive/*3*/:
			return GetSystemString(13145);
		// End:0x3A
		case EExpBoostType.ExpBoostBuff/*2*/:
			return GetSystemString(13144);
	}
}

function bool IsShowPcCafe()
{
	local int isPcCafe;

	// End:0x16
	if(GetLanguage() == LANG_Korean)
	{
		return true;		
	}
	else
	{
		GetINIBool("Localize", "UsePCBangPoint", isPcCafe, "L2.ini");
		return bool(isPcCafe);
	}	
}

function bool IsAvailableBtnType(EBottomBarBtnType Type)
{
	local int i;

	// End:0x3C [Loop If]
	for(i = 0; i < _availableBtnGroup.Length; i++)
	{
		// End:0x32
		if(_availableBtnGroup[i] == Type)
		{
			return true;
		}
	}
	return false;	
}

function bool IsInPeroidWithRemainTime(array<int> Cycle, out int RemainTime)
{
	return SuppressWnd(GetScript("SuppressWnd")).IsInPeroidWithRemainTime(Cycle, RemainTime);	
}

function bool GetCurrentSubjugationData(int Id, out SubjugationData outsubjugationData)
{
	local int i;
	local array<SubjugationData> subjugationDatas;

	GetSubjugationList(subjugationDatas);

	// End:0x59 [Loop If]
	for(i = 0; i < subjugationDatas.Length; i++)
	{
		// End:0x4F
		if(subjugationDatas[i].Id == Id)
		{
			outsubjugationData = subjugationDatas[i];
			return true;
		}
	}
	return false;	
}

function SetSuppressEvent()
{
	local int RemainTime;
	local SubjugationData mySubjugationDatas;

	Me.KillTimer(TIMER_ID_SUPPRESS);
	// End:0x3A
	if(! GetCurrentSubjugationData(_bottomBarInfo.suppressId, mySubjugationDatas))
	{
		_bottomBarInfo.isSuppressHotTime = false;		
	}
	else
	{
		_bottomBarInfo.isSuppressHotTime = IsInPeroidWithRemainTime(mySubjugationDatas.HotTimes, RemainTime);
	}
	// End:0x82
	if(RemainTime > 0)
	{
		Me.SetTimer(TIMER_ID_SUPPRESS, RemainTime * 1000);
	}
	UpdateSuppressControls();	
}

function PlayMagicLampAlarmSound()
{
	local int notifySoundIndex;

	notifySoundIndex = 6;
	// End:0x3F
	if((GetOptionInt("Audio", "NOTIFYMUTEFLAG") & ExpInt(2, notifySoundIndex - 1)) != 0)
	{
		return;
	}
	class'AudioAPI'.static.PlayIndexedNotifySound("13791", notifySoundIndex, true);	
}

function UpdateExpStatusControls()
{
	expStatusBar.SetPointExpPercentRate(_bottomBarInfo.expPercentRate);	
}

function UpdateExpInfoControls()
{
	local string expPercentStr;

	expPercentStr = ConvertFloatToString(_bottomBarInfo.expPercentRate * float(100), 4, false);
	expTextBox.SetText(expPercentStr $ "%");	
}

function UpdateExpBoostInfoControls()
{
	local int i, totalCount, totalPercent;
	local UIPacket._S_EX_USER_BOOST_STAT expBoostInfo;
	local array<DrawItemInfo> drawListArr;
	local L2Util util;

	util = getInstanceL2Util();

	// End:0x94 [Loop If]
	for(i = 1; i < 4; i++)
	{
		expBoostInfo = _bottomBarInfo.expBoostInfos[i];
		// End:0x8A
		if(expBoostInfo.Count > 0 && expBoostInfo.Percent > 0)
		{
			totalCount = totalCount + expBoostInfo.Count;
			totalPercent = totalPercent + expBoostInfo.Percent;
		}
	}
	expBoostTextBox.SetText(string(totalPercent) $ "%");
	// End:0x118
	if(totalPercent > 0)
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13141), string(totalPercent)), util.Yellow, "", false, true);
		expBoostOnTex.ShowWindow();
		expBoostOffTex.HideWindow();		
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemMessage(13142), util.White, "", false, true);
		expBoostOnTex.HideWindow();
		expBoostOffTex.ShowWindow();
	}
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	expBoostInfo = _bottomBarInfo.expBoostInfos[1];
	// End:0x21B
	if(expBoostInfo.Count > 0)
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13143), string(expBoostInfo.Percent), string(expBoostInfo.Count)), util.Yellow, "", true, true);
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13143), string(expBoostInfo.Percent), string(expBoostInfo.Count)), util.Gray, "", true, true);
	}
	expBoostInfo = _bottomBarInfo.expBoostInfos[2];
	// End:0x2DF
	if(expBoostInfo.Count > 0)
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13145), string(expBoostInfo.Percent), string(expBoostInfo.Count)), util.Yellow, "", true, true);		
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13145), string(expBoostInfo.Percent), string(expBoostInfo.Count)), util.Gray, "", true, true);
	}
	expBoostInfo = _bottomBarInfo.expBoostInfos[3];
	// End:0x3A3
	if(expBoostInfo.Count > 0)
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13144), string(expBoostInfo.Percent), string(expBoostInfo.Count)), util.Yellow, "", true, true);		
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13144), string(expBoostInfo.Percent), string(expBoostInfo.Count)), util.Gray, "", true, true);
	}
	expBoostBtn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));	
}

function UpdatePostBoxControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;

	wnd = GetBottomBarBtnWnd(EBottomBarBtnType.PostBox/*1*/);
	// End:0x3B
	if(wnd.m_pTargetWnd == none || wnd.IsShowWindow() == false)
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("PostBoxBtn_txt"));
	textBox.SetText(string(_bottomBarInfo.unreadMailCnt));	
}

function UpdateClanControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local TextureHandle Icontex;

	wnd = GetBottomBarBtnWnd(EBottomBarBtnType.Clan/*2*/);
	// End:0x3B
	if((wnd.m_pTargetWnd == none) || wnd.IsShowWindow() == false)
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("ClanBtn_txt"));
	Icontex = TextureHandle(wnd.GetChildWindow("ClanBtn_tex"));
	// End:0xED
	if(_bottomBarInfo.isClanMember == true)
	{
		Icontex.SetTexture("L2UI_NewTex.Bottombar.BottomBar_Clan");
		textBox.SetText(string(_bottomBarInfo.clanMemberCnt));		
	}
	else
	{
		Icontex.SetTexture("L2UI_NewTex.BottomBar.BottomBar_ClanSearch");
		textBox.SetText(GetSystemString(314));
	}	
}

function UpdatePartyControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local TextureHandle normalTex, alarmTex;

	wnd = GetBottomBarBtnWnd(EBottomBarBtnType.Party/*3*/);
	// End:0x3B
	if((wnd.m_pTargetWnd == none) || wnd.IsShowWindow() == false)
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("PartyBtn_txt"));
	normalTex = TextureHandle(wnd.GetChildWindow("PartyBtn_tex"));
	alarmTex = TextureHandle(wnd.GetChildWindow("PartyMatching_tex"));
	// End:0xEA
	if(_bottomBarInfo.isPartyAlarm == true)
	{
		normalTex.HideWindow();
		alarmTex.ShowWindow();		
	}
	else
	{
		normalTex.ShowWindow();
		alarmTex.HideWindow();
	}
	// End:0x12F
	if(_bottomBarInfo.isPartyOnState == true)
	{
		textBox.SetText("ON");		
	}
	else
	{
		textBox.SetText("OFF");
	}	
}

function SetPartyOnOffState(bool isShow, bool isMinimized)
{
	local bool isOn;

	isOn = isShow;
	// End:0x34
	if((isShow == false) && _bottomBarInfo.isPartyWndMinimized == true)
	{
		isOn = true;
	}
	_bottomBarInfo.isPartyWndMinimized = isMinimized;
	// End:0x74
	if(_bottomBarInfo.isPartyOnState != isOn)
	{
		_bottomBarInfo.isPartyOnState = isOn;
		UpdatePartyControls();
	}	
}

function SetPartyAlarmOn(bool isAlarm)
{
	// End:0x2E
	if(_bottomBarInfo.isPartyAlarm != isAlarm)
	{
		_bottomBarInfo.isPartyAlarm = isAlarm;
		UpdatePartyControls();
	}	
}

function UpdatePcCafePointControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;

	wnd = GetBottomBarBtnWnd(EBottomBarBtnType.PcCafePoint/*4*/);
	// End:0x3B
	if((wnd.m_pTargetWnd == none) || wnd.IsShowWindow() == false)
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("PcCafePointBtn_txt"));
	textBox.SetText(MakeCostString(string(_bottomBarInfo.PcCafePoint)));	
}

function UpdateLCoinShopControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local ButtonHandle btn;
	local array<DrawItemInfo> drawListArr;
	local ItemInfo ItemInfo;
	local TextureHandle Icontex;

	wnd = GetBottomBarBtnWnd(EBottomBarBtnType.LCoinShop/*5*/);
	// End:0x3B
	if(wnd.m_pTargetWnd == none || wnd.IsShowWindow() == false)
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("LCoinShopBtn_txt"));
	btn = ButtonHandle(wnd.GetChildWindow("LCoinShopBtn"));
	Icontex = TextureHandle(wnd.GetChildWindow("LCoinShopBtn_tex"));
	textBox.SetText(MakeCostString(string(_bottomBarInfo.bloodyCoinCnt)));
	// End:0x2A8
	if(getInstanceUIData().getIsClassicServer())
	{
		Icontex.SetTexture("L2UI_NewTex.BottomBar.BottomBar_Lcoin");
		ItemInfo = GetItemInfoByClassID(ITEM_ID_GIRAN_COIN);
		// End:0x1C3
		if(IsAdenServer())
		{
			drawListArr[drawListArr.Length] = addDrawItemText(MakeCostString(string(_bottomBarInfo.aCoinCnt)) @ GetSystemString(13441), getInstanceL2Util().White, "", true, true);
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
			drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		}
		drawListArr[drawListArr.Length] = addDrawItemText(MakeCostString(string(_bottomBarInfo.giranCoinCnt)) @ ItemInfo.Name, getInstanceL2Util().White, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(MakeCostString(string(_bottomBarInfo.bloodyCoinCnt)) @ GetSystemString(3931), getInstanceL2Util().White, "", true, true);
		btn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));		
	}
	else
	{
		Icontex.SetTexture("L2UI_NewTex.BottomBar.BottomBar_EinhasadCoin");
		btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13535)));
	}	
}

function UpdateAdenaControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local ButtonHandle btn;
	local array<DrawItemInfo> drawListArr;
	local float weightPer;

	wnd = GetBottomBarBtnWnd(EBottomBarBtnType.adena/*6*/);
	// End:0x3B
	if(wnd.m_pTargetWnd == none || wnd.IsShowWindow() == false)
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("AdenaBtn_txt"));
	btn = ButtonHandle(wnd.GetChildWindow("AdenaBtn"));
	// End:0x29E
	if(getInstanceUIData().getIsClassicServer())
	{
		weightPer = (float(_bottomBarInfo.carringWeight) / float(_bottomBarInfo.carryWeight)) * 100;
		// End:0x10E
		if(_bottomBarInfo.adenaCnt != 0)
		{
			drawListArr[drawListArr.Length] = addDrawItemText(ConvertNumToText(string(_bottomBarInfo.adenaCnt)), getInstanceL2Util().White, "", true, true);			
		}
		else
		{
			drawListArr[drawListArr.Length] = addDrawItemText(string(_bottomBarInfo.adenaCnt) @ GetSystemString(469), getInstanceL2Util().White, "", true, true);
		}
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3070) @ string(_bottomBarInfo.invenCnt) $ "/" $ string(_bottomBarInfo.invenMaxCnt), getInstanceL2Util().White, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(52) @ ConvertFloatToString(weightPer, 2, false) $ "%", getInstanceL2Util().White, "", true, true);
		btn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
		textBox.SetText(MakeCostString(string(_bottomBarInfo.adenaCnt)));		
	}
	else
	{
		// End:0x2EB
		if(GetOptionBool("ExpBarOption", "bIsShowAdenaInfo"))
		{
			textBox.SetText(MakeCostString(string(_bottomBarInfo.adenaCnt)));			
		}
		else
		{
			textBox.SetText(GetSystemString(3121));
		}
		btn.SetTooltipCustomType(MakeTooltipSimpleText(ConvertNumToText(string(_bottomBarInfo.adenaCnt))));
	}	
}

function UpdateInventoryControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;

	wnd = GetBottomBarBtnWnd(EBottomBarBtnType.Inventory/*7*/);
	// End:0x3B
	if((wnd.m_pTargetWnd == none) || wnd.IsShowWindow() == false)
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("InventoryBtn_txt"));
	textBox.SetText(string(_bottomBarInfo.invenCnt) $ "/" $ string(_bottomBarInfo.invenMaxCnt));	
}

function UpdateSuppressControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local string keyCntStr;
	local ButtonHandle btn;
	local TextureHandle Icontex;
	local array<DrawItemInfo> drawListArr;
	local int titleGapX;
	local float expPer;

	wnd = GetBottomBarBtnWnd(EBottomBarBtnType.Suppress/*8*/);
	// End:0x3B
	if((wnd.m_pTargetWnd == none) || wnd.IsShowWindow() == false)
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("SuppressBtn_txt"));
	btn = ButtonHandle(wnd.GetChildWindow("SuppressBtn"));
	Icontex = TextureHandle(wnd.GetChildWindow("SuppressBtn_tex"));
	keyCntStr = "x" $ string(_bottomBarInfo.suppressKeyCnt);
	textBox.SetText(keyCntStr);
	// End:0x14F
	if(_bottomBarInfo.suppressId <= 1)
	{
		btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13627)));
		Icontex.SetTexture("L2UI_NewTex.BottomBar.BottomBar_Suppress");		
	}
	else
	{
		// End:0x1EA
		if(_bottomBarInfo.isSuppressHotTime)
		{
			drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.BottomBar.SuppressHotTime", false, false, 0, 0, 10, 11, 10, 11);
			titleGapX = 4;
			Icontex.SetTexture("L2UI_NewTex.BottomBar.BottomBar_SuppressHot");			
		}
		else
		{
			Icontex.SetTexture("L2UI_NewTex.BottomBar.BottomBar_Suppress");
		}
		drawListArr[drawListArr.Length] = addDrawItemText(_bottomBarInfo.suppressName, getInstanceL2Util().Yellow, "", false, true, titleGapX);
		drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13634)) @ keyCntStr, getInstanceL2Util().White, "", true, true);
		// End:0x2E0
		if(_bottomBarInfo.isSuppressMaxKey)
		{
			drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(3451), getInstanceL2Util().White, "", true, true);			
		}
		else
		{
			expPer = (float(_bottomBarInfo.suppressPoint) / float(_bottomBarInfo.suppressMaxPoint)) * float(100);
			drawListArr[drawListArr.Length] = addDrawItemText((" - " $ getInstanceL2Util().cutFloat(expPer)) @ GetSystemString(13635), getInstanceL2Util().White, "", true, true);
		}
		btn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	}	
}

function UpdateMagicLampContols()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local ButtonHandle btn;
	local float expPer;
	local int maxCnt;
	local UserInfo myUserInfo;
	local string cntStr;
	local TextureHandle alarmTex;

	wnd = GetBottomBarBtnWnd(EBottomBarBtnType.MagicLamp/*9*/);
	// End:0x3B
	if((wnd.m_pTargetWnd == none) || wnd.IsShowWindow() == false)
	{
		return;
	}
	// End:0x4D
	if(! GetPlayerInfo(myUserInfo))
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("MagicLampBtn_txt"));
	btn = ButtonHandle(wnd.GetChildWindow("MagicLampBtn"));
	alarmTex = TextureHandle(wnd.GetChildWindow("MagicLampAlarm_tex"));
	maxCnt = GetMagicLampMaxCharge(myUserInfo.nLevel);
	expPer = (float(_bottomBarInfo.magicLampExp) / float(_bottomBarInfo.magicLampMaxExp)) * 100;
	cntStr = string(_bottomBarInfo.magicLampCnt) $ "/" $ string(maxCnt);
	textBox.SetText(cntStr);
	if(_bottomBarInfo.magicLampCnt >= maxCnt)
	{
		alarmTex.ShowWindow();
		textBox.SetTextColor(GetColor(255, 221, 102, 255));		
	}
	else
	{
		alarmTex.HideWindow();
		textBox.SetTextColor(GetColor(235, 235, 235, 255));
	}
	if(_bottomBarInfo.magicLampCnt == maxCnt)
	{
		// End:0x149
		if(_bottomBarInfo.isAlreadyMagicLampAlarm == false)
		{
			_bottomBarInfo.isAlreadyMagicLampAlarm = true;
			PlayMagicLampAlarmSound();
		}		
	}
	else
	{
		_bottomBarInfo.isAlreadyMagicLampAlarm = false;
	}
	btn.SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(3937) @ cntStr, getInstanceL2Util().White, "", true, ConvertFloatToString(expPer, 2, false) $ "%", getInstanceL2Util().Yellow, "", true,,,,, 120));	
}

function UpdateRandomCraftControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local ButtonHandle btn;
	local float MaxPoint, fPer;
	local int maxGauge, currentCharge;
	local string pointStr, gaugeStr;

	wnd = GetBottomBarBtnWnd(EBottomBarBtnType.RandomCraft/*10*/);
	// End:0x3B
	if((wnd.m_pTargetWnd == none) || wnd.IsShowWindow() == false)
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("RandomCraftBtn_txt"));
	btn = ButtonHandle(wnd.GetChildWindow("RandomCraftBtn"));
	MaxPoint = float(class'RandomCraftAPI'.static.GetMaxItemPoint());
	maxGauge = class'RandomCraftAPI'.static.GetMaxGaugeValue();
	pointStr = "x" $ string(_bottomBarInfo.randomCraftPoint);
	currentCharge = int(getInstanceL2Util().Get9999Percent(_bottomBarInfo.randomCraftCharge, maxGauge));
	fPer = (float(currentCharge) / float(maxGauge)) * float(100);
	gaugeStr = ConvertFloatToString(fPer, 2, false) $ "%";
	textBox.SetText(pointStr);
	btn.SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(13159) @ pointStr, getInstanceL2Util().White, "", true, gaugeStr, getInstanceL2Util().Yellow, "", true));	
}

function UpdateLCoinCraftControls();

function UpdateVitaminManagerControls();


function UpdateUIControls()
{
	UpdateExpStatusControls();
	UpdateExpStatusControls();
	UpdateExpInfoControls();
	UpdateExpBoostInfoControls();
	UpdatePostBoxControls();
	UpdateClanControls();
	UpdatePartyControls();
	UpdatePcCafePointControls();
	UpdateLCoinShopControls();
	UpdateAdenaControls();
	UpdateInventoryControls();
	UpdateSuppressControls();
	UpdateMagicLampContols();
	UpdateRandomCraftControls();
	UpdateLCoinCraftControls();
	UpdateVitaminManagerControls();
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x1F
		case "PostBoxBtn":
			OnPostBoxBtnClicked();
			// End:0x17E
			break;
		// End:0x34
		case "ClanBtn":
			OnClanBtnClicked();
			// End:0x17E
			break;
		// End:0x4A
		case "PartyBtn":
			OnPartyBtnClicked();
			// End:0x17E
			break;
		// End:0x64
		case "LCoinShopBtn":
			OnLCoinShopBtnClicked();
			// End:0x17E
			break;
		// End:0x80
		case "PcCafePointBtn":
			OnPcCafePointBtnClicked();
			// End:0x17E
			break;
		// End:0x96
		case "AdenaBtn":
			OnAdenaBtnClicked();
			// End:0x17E
			break;
		// End:0xB0
		case "InventoryBtn":
			OnInventoryBtnClicked();
			// End:0x17E
			break;
		// End:0xC9
		case "SuppressBtn":
			OnSuppressBtnClicked();
			// End:0x17E
			break;
		// End:0xE3
		case "MagicLampBtn":
			OnMagicLampBtnClicked();
			// End:0x17E
			break;
		// End:0xFF
		case "RandomCraftBtn":
			OnRandomCraftBtnClicked();
			// End:0x17E
			break;
		// End:0x123
		case "RandomCraftChargingBtn":
			OnRandomCraftChargingBtnClicked();
			// End:0x17E
			break;
		// End:0x13E
		case "LCoinCraftBtn":
			OnLCoinCraftBtnClicked();
			// End:0x17E
			break;
		// End:0x15D
		case "VitaminManagerBtn":
			OnVitaminManagerBtnClicked();
			// End:0x17E
			break;
		// End:0x17B
		case "DualInventoryBtn":
			OnDualInventoryBtnClicked();
			// End:0x17E
			break;
	}	
}

event OnPostBoxBtnClicked()
{
	local WindowHandle win;

	win = GetWindowHandle("PostBoxWnd");
	// End:0x44
	if(win.IsShowWindow())
	{
		win.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);		
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		RequestRequestReceivedPostList();
	}	
}

event OnClanBtnClicked()
{
	// End:0xAA
	if(_bottomBarInfo.isClanMember == true)
	{
		// End:0x6C
		if(getInstanceUIData().getIsClassicServer())
		{
			// End:0x4E
			if(getInstanceL2Util().isClanV2())
			{
				toggleWindow("ClanGfxWnd", true, true);				
			}
			else
			{
				toggleWindow("ClanWndClassicNew", true, true);
			}			
		}
		else
		{
			// End:0x96
			if(getInstanceL2Util().isClanV2())
			{
				toggleWindow("ClanGfxWnd", true, true);				
			}
			else
			{
				toggleWindow("ClanWnd", true, true);
			}
		}		
	}
	else
	{
		toggleWindow("ClanSearch", true, true);
	}	
}

event OnPartyBtnClicked()
{
	_bottomBarInfo.isPartyAlarm = false;
	class'PartyMatchAPI'.static.RequestOpenPartyMatch();
}

event OnLCoinShopBtnClicked()
{
	toggleWindow("ShopLcoinWnd", true, true);	
}

event OnPcCafePointBtnClicked()
{
	// End:0x21
	if(getInstanceL2Util().getIsPrologueGrowType())
	{
		AddSystemMessage(4533);		
	}
	else
	{
		// End:0x63
		if(GetWindowHandle("NPCDialogWnd").IsShowWindow())
		{
			GetWindowHandle("NPCDialogWnd").HideWindow();			
		}
		else
		{
			RequestOpenWndWithoutNPC(OPEN_PCCAFE_HTML);
		}
	}	
}

event OnAdenaBtnClicked()
{
	local bool isShowAdenaOption;

	// End:0x2C
	if(getInstanceUIData().getIsClassicServer())
	{
		toggleWindow("InventoryWnd", true, true);		
	}
	else
	{
		isShowAdenaOption = GetOptionBool("ExpBarOption", "bIsShowAdenaInfo");
		SetOptionBool("ExpBarOption", "bIsShowAdenaInfo", ! isShowAdenaOption);
		UpdateAdenaControls();
	}	
}

event OnInventoryBtnClicked()
{
	toggleWindow("InventoryWnd", true, true);	
}

event OnSuppressBtnClicked()
{
	toggleWindow("SuppressWnd", true, true);
	SuppressWnd(GetScript("SuppressWnd")).setSelectListByID(_bottomBarInfo.suppressId);
}

event OnMagicLampBtnClicked()
{
	toggleWindow("MagicLampWnd", true, true);	
}

event OnRandomCraftBtnClicked()
{
	toggleWindow("RandomCraftWnd", true, true);	
}

event OnRandomCraftChargingBtnClicked()
{
	toggleWindow("RandomCraftChargingWnd", true, true);	
}

event OnLCoinCraftBtnClicked()
{
	toggleWindow("ShopLCoinCraftWnd", true, true);	
}

event OnVitaminManagerBtnClicked()
{
	// End:0x4C
	if(GetWindowHandle("PremiumManagerWnd").IsShowWindow())
	{
		GetWindowHandle("PremiumManagerWnd").HideWindow();		
	}
	else
	{
		RequestOpenWndWithoutNPC(OPEN_PREMIUM_MANAGER);
	}	
}

event OnDualInventoryBtnClicked()
{
	ExecuteEvent(EV_RequestDualInventorySwap, "");	
}

event OnLoad()
{
	Initialize();	
}

event OnRegisterEvent()
{
	// End:0x09
	if(USE_XML_BOTTOM_BAR_UI == false)
	{
		return;
	}
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_PledgeCount);
	RegisterEvent(EV_UnReadMailCount);
	RegisterEvent(EV_ClanDeleteAllMember);
	RegisterEvent(EV_ClanInfo);
	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_SetMaxCount);
	RegisterEvent(EV_BloodyCoinCount);
	RegisterEvent(EV_PCCafePointInfo);
	RegisterEvent(EV_MagicLamp_ExpInfo);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_USER_BOOST_STAT));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_SUBJUGATION_SIDEBAR));	
}

event OnEvent(int Event_ID, string param)
{
	// End:0x09
	if(USE_XML_BOTTOM_BAR_UI == false)
	{
		return;
	}
	switch(Event_ID)
	{
		// End:0x1E
		case EV_UpdateUserInfo:
			Nt_EV_UpdateUserInfo();
			// End:0x135
			break;
		// End:0x34
		case EV_PledgeCount:
			Nt_EV_PledgeCount(param);
			// End:0x135
			break;
		// End:0x4A
		case EV_UnReadMailCount:
			Nt_EV_UnReadMailCount(param);
			// End:0x135
			break;
		// End:0x60
		case EV_ClanDeleteAllMember:
			Nt_EV_ClanDeleteAllMember(param);
			// End:0x135
			break;
		// End:0x76
		case EV_ClanInfo:
			Nt_EV_EV_ClanInfo(param);
			// End:0x135
			break;
		// End:0x8C
		case EV_BloodyCoinCount:
			Nt_EV_BloodyCoinCount(param);
			// End:0x135
			break;
		// End:0xA2
		case EV_PCCafePointInfo:
			Nt_EV_PCCafePointInfo(param);
			// End:0x135
			break;
		// End:0xB8
		case EV_AdenaInvenCount:
			Nt_EV_AdenaInvenCount(param);
			// End:0x135
			break;
		// End:0xCE
		case EV_SetMaxCount:
			Nt_EV_SetMaxCount(param);
			// End:0x135
			break;
		// End:0xE4
		case EV_MagicLamp_ExpInfo:
			Nt_EV_MagicLamp_ExpInfo(param);
			// End:0x135
			break;
		// End:0x104
		case EV_PacketID(class'UIPacket'.const.S_EX_USER_BOOST_STAT):
			Nt_S_EX_USER_BOOST_STAT();
			// End:0x135
			break;
		// End:0x124
		case EV_PacketID(class'UIPacket'.const.S_EX_SUBJUGATION_SIDEBAR):
			Nt_S_EX_SUBJUGATION_SIDEBAR();
			// End:0x135
			break;
		// End:0x132
		case EV_Restart:
			ResetInfo();
			// End:0x135
			break;
	}	
}

event OnTimer(int TimerID)
{
	// End:0x11
	if(TimerID == TIMER_ID_SUPPRESS)
	{
		SetSuppressEvent();
	}	
}

event OnShow()
{
	// End:0x18
	if(USE_XML_BOTTOM_BAR_UI == false)
	{
		Me.HideWindow();
		return;
	}
	UpdateUIControls();	
}

function Nt_EV_UpdateUserInfo()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	// End:0x45
	if(_bottomBarInfo.expPercentRate != UserInfo.fExpPercentRate)
	{
		_bottomBarInfo.expPercentRate = UserInfo.fExpPercentRate;
		UpdateExpStatusControls();
		UpdateExpInfoControls();
	}
	// End:0xA9
	if((_bottomBarInfo.carringWeight != UserInfo.nCarringWeight) || _bottomBarInfo.carryWeight != UserInfo.nCarryWeight)
	{
		_bottomBarInfo.carringWeight = UserInfo.nCarringWeight;
		_bottomBarInfo.carryWeight = UserInfo.nCarryWeight;
		UpdateAdenaControls();
	}
	// End:0xE8
	if(_bottomBarInfo.isMagicLampOpen == true)
	{
		// End:0xE8
		if(getInstanceUIData().isLevelUP() || getInstanceUIData().IsLevelDown())
		{
			UpdateMagicLampContols();
		}
	}	
}

function Nt_EV_PledgeCount(string param)
{
	local int clanMemberCnt;

	ParseInt(param, "PledgeCount", clanMemberCnt);
	_bottomBarInfo.clanMemberCnt = clanMemberCnt;
	// End:0x45
	if(clanMemberCnt > 0)
	{
		_bottomBarInfo.isClanMember = true;
	}
	UpdateClanControls();	
}

function Nt_EV_UnReadMailCount(string param)
{
	local int unreadMailCnt;

	ParseInt(param, "UnReadMailCount", unreadMailCnt);
	_bottomBarInfo.unreadMailCnt = unreadMailCnt;
	UpdatePostBoxControls();	
}

function Nt_EV_ClanDeleteAllMember(string param)
{
	_bottomBarInfo.isClanMember = false;
	UpdateClanControls();	
}

function Nt_EV_EV_ClanInfo(string param)
{
	_bottomBarInfo.isClanMember = true;
	UpdateClanControls();	
}

function Nt_EV_BloodyCoinCount(string param)
{
	local INT64 bloodyCoinCnt;

	ParseINT64(param, "CoinCount", bloodyCoinCnt);
	_bottomBarInfo.bloodyCoinCnt = bloodyCoinCnt;
	UpdateLCoinShopControls();	
}

function Nt_EV_PCCafePointInfo(string param)
{
	local int PcCafePoint, Show;

	ParseInt(param, "TotalPoint", PcCafePoint);
	ParseInt(param, "Show", Show);
	// End:0x4D
	if(Show > 0)
	{
		_bottomBarInfo.PcCafePoint = PcCafePoint;
	}
	UpdatePcCafePointControls();	
}

function Nt_EV_AdenaInvenCount(string param)
{
	local int invenCnt;
	local INT64 adenaCnt, aCoinCnt, giranCoinCnt;
	local bool needUpdateLCoinShopBtn;

	ParseInt(param, "InvenCount", invenCnt);
	// End:0x5F
	if(_bottomBarInfo.invenCnt != invenCnt)
	{
		_bottomBarInfo.invenCnt = invenCnt;
		UpdateInventoryControls();
		// End:0x5F
		if(getInstanceUIData().getIsClassicServer())
		{
			UpdateAdenaControls();
		}
	}
	adenaCnt = GetAdena();
	// End:0x96
	if(_bottomBarInfo.adenaCnt != adenaCnt)
	{
		_bottomBarInfo.adenaCnt = adenaCnt;
		UpdateAdenaControls();
	}
	// End:0x13A
	if(getInstanceUIData().getIsClassicServer())
	{
		giranCoinCnt = GetInventoryItemCount(GetItemID(ITEM_ID_GIRAN_COIN));
		// End:0xED
		if(_bottomBarInfo.giranCoinCnt != giranCoinCnt)
		{
			_bottomBarInfo.giranCoinCnt = giranCoinCnt;
			needUpdateLCoinShopBtn = true;
		}
		// End:0x13A
		if(IsAdenServer())
		{
			aCoinCnt = GetInventoryItemCount(GetItemID(ITEM_ID_A_COIN));
			// End:0x13A
			if(_bottomBarInfo.aCoinCnt != aCoinCnt)
			{
				_bottomBarInfo.aCoinCnt = aCoinCnt;
				needUpdateLCoinShopBtn = true;
			}
		}
	}
	// End:0x14C
	if(needUpdateLCoinShopBtn == true)
	{
		UpdateLCoinShopControls();
	}	
}

function Nt_EV_SetMaxCount(string param)
{
	local int invenMaxCnt;

	ParseInt(param, "Inventory", invenMaxCnt);
	// End:0x4B
	if(_bottomBarInfo.invenMaxCnt != invenMaxCnt)
	{
		_bottomBarInfo.invenMaxCnt = invenMaxCnt;
		UpdateInventoryControls();
		UpdateAdenaControls();
	}	
}

function Nt_EV_MagicLamp_ExpInfo(string param)
{
	local int magicLampCnt, magicLampExp, magicLampMaxExp, isMagicLampOpen;

	ParseInt(param, "Count", magicLampCnt);
	ParseInt(param, "CurrExp", magicLampExp);
	ParseInt(param, "MaxExp", magicLampMaxExp);
	ParseInt(param, "IsOpen", isMagicLampOpen);
	_bottomBarInfo.magicLampCnt = magicLampCnt;
	_bottomBarInfo.magicLampExp = magicLampExp;
	_bottomBarInfo.magicLampMaxExp = magicLampMaxExp;
	_bottomBarInfo.isMagicLampOpen = bool(isMagicLampOpen);
	// End:0xBF
	if(isMagicLampOpen == 1)
	{
		RegistAndShowBtn(EBottomBarBtnType.MagicLamp/*9*/);
		UpdateMagicLampContols();		
	}
	else
	{
		UnregistAndHideBtn(EBottomBarBtnType.MagicLamp/*9*/);
	}	
}

function Nt_S_EX_USER_BOOST_STAT()
{
	local UIPacket._S_EX_USER_BOOST_STAT packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_USER_BOOST_STAT(packet))
	{
		return;
	}
	// End:0x49
	if(packet.Type < 4)
	{
		_bottomBarInfo.expBoostInfos[packet.Type] = packet;
	}
	UpdateExpBoostInfoControls();	
}

function Nt_S_EX_SUBJUGATION_SIDEBAR()
{
	local SubjugationData mySubjugationDatas;
	local UIPacket._S_EX_SUBJUGATION_SIDEBAR packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_SUBJUGATION_SIDEBAR(packet))
	{
		return;
	}
	_bottomBarInfo.suppressId = packet.nID;
	// End:0x57
	if(! GetCurrentSubjugationData(packet.nID, mySubjugationDatas))
	{
		_bottomBarInfo.isSuppressHotTime = false;
	}
	_bottomBarInfo.isSuppressMaxKey = packet.nGachaPoint >= mySubjugationDatas.MaxPeriodicGachaPoint;
	_bottomBarInfo.suppressName = mySubjugationDatas.Name;
	_bottomBarInfo.suppressKeyCnt = packet.nGachaPoint;
	_bottomBarInfo.suppressPoint = packet.nPoint;
	_bottomBarInfo.suppressMaxPoint = mySubjugationDatas.MaxSubjugationPoint;
	SetSuppressEvent();	
}

function Nt_S_EX_CRAFT_INFO(UIPacket._S_EX_CRAFT_INFO packet)
{
	// End:0x09
	if(USE_XML_BOTTOM_BAR_UI == false)
	{
		return;
	}
	_bottomBarInfo.randomCraftPoint = packet.nPoint;
	_bottomBarInfo.randomCraftCharge = packet.nCharge;
	UpdateRandomCraftControls();	
}

defaultproperties
{
}
