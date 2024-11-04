//================================================================================
// UIDevTestWnd.
//================================================================================

class UIDevTestWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var SliderCtrlHandle TestSliderCtrl;
var ProgressCtrlHandle Progress1;
var ProgressCtrlHandle Progress2;
var ProgressCtrlHandle Progress3;
var StatusBarHandle HPStatusBar;
var StatusBarHandle MPStatusBar;
var StatusRoundHandle HPStatusRound;
var StatusRoundHandle MPStatusRound;
var TextBoxHandle SlideText;
var EditBoxHandle SdEditBox;
var TreeHandle CTreeCtrl;
var float shakeSize;
var float Dir;
var int shakeTimeID;
var int repeatCount;
var int CurrentCount;
var int posX;
var int posY;
var UIControlGroupButtons groupButtons;
var UIControlGroupButtonAssets UIControlGroupButtonAsset1;

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("UIDevTestWnd");
	TestSliderCtrl = GetSliderCtrlHandle("UIDevTestWnd.TestSliderCtrl");
	Progress1 = GetProgressCtrlHandle("UIDevTestWnd.Progress1");
	Progress2 = GetProgressCtrlHandle("UIDevTestWnd.Progress2");
	Progress3 = GetProgressCtrlHandle("UIDevTestWnd.Progress3");
	HPStatusBar = GetStatusBarHandle("UIDevTestWnd.HPStatusBar");
	MPStatusBar = GetStatusBarHandle("UIDevTestWnd.MPStatusBar");
	HPStatusRound = GetStatusRoundHandle("UIDevTestWnd.HPStatusRound");
	MPStatusRound = GetStatusRoundHandle("UIDevTestWnd.MPStatusRound");
	SlideText = GetTextBoxHandle("UIDevTestWnd.SlideText");
	SdEditBox = GetEditBoxHandle("UIDevTestWnd.SdEditBox");
	CTreeCtrl = GetTreeHandle("UIDevTestWnd.testTreeCtrl");
	GetWindowHandle("UIDevTestWnd.UIControlGroupButtonAsset1").SetScript("UIControlGroupButtonAssets");
	UIControlGroupButtonAsset1 = UIControlGroupButtonAssets(GetWindowHandle("UIDevTestWnd.UIControlGroupButtonAsset1").GetScript());
	UIControlGroupButtonAsset1._SetWindow("UIDevTestWnd.UIControlGroupButtonAsset1");
	UIControlGroupButtonAsset1._SetStartInfo("", "", "", true);
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(0, "전체");
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(1, "2번");
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(2, "3번");
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(3, "4번");
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setShowButtonNum(4);
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setAutoWidth(700, 2);
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setTextureLoc(0, GetTextureHandle("UIDevTestWnd.Texture32"), 0, 4, "left");
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._reservedString = "test1";
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_ct1.Button.Auction_Button_DF", "L2UI_ct1.Button.Auction_Button_DF", "L2UI_ct1.Button.Auction_Button_over");
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonTexture(3, "L2UI_ct1.Button.Auction_Button_DF", "L2UI_ct1.Button.Auction_Button_DF", "L2UI_ct1.Button.Auction_Button_over");
	UIControlGroupButtonAsset1._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButton;
}

function DelegateOnClickButton(string parentWndName, string strName, int Index)
{
	Debug("strName" @ parentWndName);
	Debug("strName" @ strName);
	Debug("index" @ string(Index));
	// End:0x5E
	if(Index == 3)
	{
		ShowContextMenu(620, 470);
	}
}

function ShowContextMenu(int X, int Y)
{
	local UIControlContextMenu ContextMenu;

	ContextMenu = class'UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.List_ListCtrl.ClearTooltip();
	ContextMenu.MenuNew(GetSystemString(1446), 1, GTColor().Yellow);
	ContextMenu.MenuAddIcon("L2UI_EPIC.ClanWnd.ClanWnd_Icon_penalty");
	ContextMenu.MenuNew(GetSystemString(3507), 2, GTColor().VIOLET02);
	ContextMenu.MenuAddIcon("L2UI_EPIC.ClanWnd.ClanWnd_Icon_Benefit");
	ContextMenu.MenuNew("테스트3", 3, GTColor().Red2);
	ContextMenu.MenuNew("테스트4", 3, GTColor().Blue);
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	ContextMenu.DelegateOnHide = HandleOnHideContextMenu;
	ContextMenu.Show(X - 5, Y - 5, string(self));
}

function HandleOnClickContextMenu(int Index)
{
	Debug("index " $ string(Index));
}

function HandleOnHideContextMenu()
{
	Debug("OnHideContextMenu");
}

function OnRegisterEvent()
{
	RegisterEvent(EV_Test_5);
}

function OnShow()
{
	Progress1.SetProgressTime(TestSliderCtrl.GetTotalTickCount());
	Progress2.SetProgressTime(TestSliderCtrl.GetTotalTickCount());
	Progress3.SetProgressTime(TestSliderCtrl.GetTotalTickCount());
	SlideText.SetText(string(TestSliderCtrl.GetCurrentTick()) $ "/" $ string(TestSliderCtrl.GetTotalTickCount() - 1));
	SdEditBox.SetFocus();
	SdEditBox.SetString(string(TestSliderCtrl.GetCurrentTick()));
	SdEditBox.AllSelect();
	TestSliderCtrl.SetCurrentTick(int(SdEditBox.GetString()));
	setTree();
	groupButtons = new class'UIControlGroupButtons';
	groupButtons._SetStartInfo("L2UI_ct1.RankingWnd.RankingWnd_SubTabButton", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd.RankingWnd_SubTabButton_Over", true);
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton1"), "오우44444444411111", 100);
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton2"));
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton3"));
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton4"));
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton5"));
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton6"));
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton7"), "", 700);
	groupButtons._setButtonValue(4, 400);
	groupButtons.DelegateOnClickButton = groupButtonOnClickButton;
	groupButtons._setButtonText(2, "3번째다1234");
	groupButtons._setButtonText(3, "4번째다12");
	groupButtons._setButtonTextByName("selectButton7", "7번");
	groupButtons._setShowButtonNum();
	groupButtons._setAutoWidth(500, 10);
	groupButtons._setTopOrder(2);
}

function groupButtonOnClickButton(string parentWndName, string buttonName, int currentTabIndex)
{
	// End:0x6D
	if(groupButtons._getButtonValueByName(buttonName) != -1)
	{
		Debug(((("groupButtonOnClickButton" @ parentWndName) @ buttonName) @ string(currentTabIndex)) @ string(groupButtons._getButtonValueByName(buttonName)));
	}
}

function setTree()
{}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case EV_Test_5:
			break;
	}
}

function OnClickButton(string a_ButtonID)
{
	groupButtons._selectButton(a_ButtonID);
	switch(a_ButtonID)
	{
		// End:0x72
		case "test1Btn":
			groupButtons._setShowButtonNum(7);
			groupButtons._setAutoWidth(300, 2);
			groupButtons._setButtonHeight(25);
			groupButtons._setEnableAll();
			// End:0x2F3
			break;
		// End:0x118
		case "test2Btn":
			groupButtons._setShowButtonNum(2);
			groupButtons._setButtonText(0, "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			groupButtons._setButtonText(1, "bbbbbbbbbb");
			groupButtons._setButtonHeight(50);
			groupButtons._setAutoWidth(500, 10);
			groupButtons._SetDisable(1);
			// End:0x2F3
			break;
		// End:0x201
		case "test3Btn":
			groupButtons._setShowButtonNum(4);
			groupButtons._setButtonText(0, "아아아아아아아아아아아아아아");
			groupButtons._setButtonText(1, "이이이이이이이이이이이");
			groupButtons._setButtonText(2, "우우우우우우");
			groupButtons._setButtonText(3, "에에에에에");
			groupButtons._setButtonHeight(25);
			groupButtons._setAutoWidth(500, 4);
			groupButtons._setEnableAll();
			// End:0x2F3
			break;
		// End:0x2F0
		case "test4Btn":
			groupButtons._setShowButtonNum(7);
			groupButtons._setButtonText(0, "1번");
			groupButtons._setButtonText(1, "2번");
			groupButtons._setButtonText(2, "3번");
			groupButtons._setButtonText(3, "4번");
			groupButtons._setButtonText(4, "5번");
			groupButtons._setButtonText(5, "6번");
			groupButtons._setButtonText(6, "7번");
			groupButtons._setButtonHeight(40);
			groupButtons._setAutoWidth(800, 2);
			groupButtons._setEnableAll();
			// End:0x2F3
			// End:0xF6
			break;
	}
}

function SwitchTexture()
{
	local INT64 MaxValue, CurValue;
	local string t_hp, t_mp;
	local Color c_hp, c_mp;
	local StatusBaseHandle Handle;

	Handle = HPStatusBar.GetSelfScript();
	c_hp = HPStatusBar.GetGaugeColor(Handle.StatusBarSplitType.SBST_Trailer);
	c_mp = MPStatusBar.GetGaugeColor(Handle.StatusBarSplitType.SBST_Trailer);
	HPStatusBar.SetGaugeColor(Handle.StatusBarSplitType.SBST_Trailer, c_mp);
	MPStatusBar.SetGaugeColor(Handle.StatusBarSplitType.SBST_Trailer, c_hp);
	c_hp = HPStatusRound.GetGaugeColor(Handle.StatusBarSplitType.SBST_BackCenter);
	c_mp = MPStatusRound.GetGaugeColor(Handle.StatusBarSplitType.SBST_BackCenter);
	HPStatusRound.SetGaugeColor(Handle.StatusBarSplitType.SBST_BackCenter, c_mp);
	MPStatusRound.SetGaugeColor(Handle.StatusBarSplitType.SBST_BackCenter, c_hp);
	t_hp = HPStatusRound.GetGaugeTexture(Handle.StatusBarSplitType.SBST_RegenRight);
	t_mp = MPStatusRound.GetGaugeTexture(Handle.StatusBarSplitType.SBST_RegenRight);
	HPStatusRound.SetGaugeTexture(Handle.StatusBarSplitType.SBST_RegenRight, t_mp);
	MPStatusRound.SetGaugeTexture(Handle.StatusBarSplitType.SBST_RegenRight, t_hp);
	HPStatusRound.GetPoint(CurValue, MaxValue);
}

function BFO()
{
	local ButtonHandle ButtonHandle1;

	ButtonHandle1 = GetButtonHandle("UIDevTestWnd.test1Btn");
	ButtonHandle1.SetFocus();
	ButtonHandle1.BringToFrontOf("test2Btn");
	class'UIAPI_WINDOW'.static.BringToFrontOf("UIDevTestWnd.test2Btn", "test1Btn");
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local int ivalue;

	switch(strID)
	{
		// End:0x147
		case "TestSliderCtrl":
			ivalue = TestSliderCtrl.GetCurrentTick();
			SlideText.SetText(string(ivalue) $ "/" $ string(TestSliderCtrl.GetTotalTickCount() - 1));
			Progress1.SetPos(ivalue);
			Progress2.SetPos(ivalue);
			Progress3.SetPos(ivalue);
			HPStatusBar.SetPoint(ivalue, TestSliderCtrl.GetTotalTickCount() - 1);
			MPStatusBar.SetPoint(ivalue, TestSliderCtrl.GetTotalTickCount() - 1);
			HPStatusRound.SetPoint(ivalue, TestSliderCtrl.GetTotalTickCount() - 1);
			MPStatusRound.SetPoint(ivalue, TestSliderCtrl.GetTotalTickCount() - 1);
			circleMove(ivalue, 20.0f);
			break;
	}
}

function circleMove(int tickNum, float Radius)
{
	local float X, Y, Angle;

	Angle = (360.0f / float(1000)) * float(tickNum);
	X = Radius * Sin((3.140f * Angle) / float(180));
	Y = - Radius * Cos((3.140f * Angle) / float(180));
	X = (((35.0f + X) + float(GetMeStatusRound("MPStatusRound").GetRect().nX)) - float(GetMeStatusRound("MPStatusRound").GetRect().nWidth / 2)) + float(GetMeStatusRound("Texture20").GetRect().nWidth / 2);
	Y = (((35.0f + Y) + float(GetMeStatusRound("MPStatusRound").GetRect().nY)) - float(GetMeStatusRound("MPStatusRound").GetRect().nHeight / 2)) + float(GetMeStatusRound("Texture20").GetRect().nHeight / 2);
	GetMeTexture("Texture20").MoveTo(int(X), int(Y));	
}

function OnCallUCFunction(string func, string param)
{
	Debug("-Func" @ func);
	Debug("-param" @ param);
	switch(func)
	{
		// End:0x45
		case "tween":
			FuncTween(param);
			break;
	}
}

function FuncTween(string param)
{
	local int X, Y, Width, Height;
	local string Target;
	local Rect Rect;

	ParseInt(param, "x", X);
	ParseInt(param, "x", Y);
	ParseInt(param, "width", Width);
	ParseInt(param, "height", Height);
	ParseString(param, "target", Target);
	GetWindowHandle(Target).Move(X, Y);
	Debug("와왕" @ GetWindowHandle(Target).GetWindowName());
	if((Width > 0) || (Height > 0))
	{
		Rect = GetWindowHandle(Target).GetRect();
		// End:0xFD
		if(Width <= 0)
		{
			Width = Rect.nWidth;
		}
		// End:0x118
		if(Height <= 0)
		{
			Height = Rect.nHeight;
		}
		GetWindowHandle(Target).SetWindowSize(Width, Height);
	}
}

function OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	local string mainKey;

	// End:0xA8
	if(SdEditBox.IsFocused())
	{
		mainKey = class'InputAPI'.static.GetKeyString(nKey);
		// End:0xA8
		if(mainKey == "ENTER")
		{
			TestSliderCtrl.SetCurrentTick(int(SdEditBox.GetString()));
			// End:0xA8
			if(int(SdEditBox.GetString()) > (TestSliderCtrl.GetTotalTickCount() - 1))
			{
				SdEditBox.SetString(string(TestSliderCtrl.GetTotalTickCount() - 1));
			}
		}
	}
}

function OnHide ()
{
}

function StartShake(int nShakeSize, int nRepeatCount, int mSec, int TimeID)
{
	posX = Me.GetRect().nX;
	posY = Me.GetRect().nY;
	Dir = 1.0;
	shakeSize = nShakeSize;
	repeatCount = nRepeatCount;
	shakeTimeID = TimeID;
	CurrentCount = 0;
	Me.SetTimer(shakeTimeID, mSec);
}

function OnTimer(int TimerID)
{
	OnTimerForShake(TimerID);
}

function OnTimerForShake(int TimerID)
{
	// End:0x5B
	if(TimerID == shakeTimeID)
	{
		// End:0x27
		if(repeatCount > CurrentCount)
		{
			Shake();
		}
		else
		{
			Me.KillTimer(shakeTimeID);
			Me.MoveC(posX, posY);
		}
		CurrentCount++;
	}
}

function Shake()
{
	local float X, Y, dampening;

	Dir *= -1;
	dampening = (repeatCount - CurrentCount) / repeatCount * 10;
	X = posX + appRound(Rand(int(shakeSize * Dir * dampening / 10)));
	Y = posY + appRound(Rand(int(shakeSize * Dir * dampening / 10)));
	Me.MoveC(int(X),int(Y));
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
