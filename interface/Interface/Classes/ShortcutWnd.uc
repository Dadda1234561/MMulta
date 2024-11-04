class ShortcutWnd extends UICommonAPI;

const MAX_ShortcutPerPage = 12;
const MAX_ShortcutPerPage2 = 24;
const MAX_ShortcutPerPage3 = 36;
const MAX_ShortcutPerPage4 = 48;
const MAX_ShortcutPerPage5 = 60;
const MAX_ShortcutPerPage6 = 72;
const MAX_ShortcutPerPage7 = 84;
const MAX_ShortcutPerPage8 = 96;

enum EJoyShortcut
{
	JOYSHORTCUT_Left,
	JOYSHORTCUT_Center,
	JOYSHORTCUT_Right
};

var int MAX_Page;
var int MAX_ShortcutExtend;
var int m_extendBounsSlot;
var WindowHandle Me;
var int CurrentShortcutPage;
var int CurrentShortcutPage2;
var int CurrentShortcutPage3;
var int CurrentShortcutPage4;
var int CurrentShortcutPage5;
var int CurrentShortcutPage6;
var int CurrentShortcutPage7;
var int CurrentShortcutPage8;
var int CurrentShortcutPageExtend;
var bool m_IsLocked;
var bool m_IsVertical;
var bool m_IsJoypad;
var bool m_IsJoypadExpand;
var bool m_IsJoypadOn;
var int m_Expand;
var bool m_IsShortcutExpand;
var string m_ShortcutWndName;
var string m_ShortcutWndExtendName;
var AutoShotItemWnd AutoShotItemWndScript;

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_ShortcutUpdate);
	RegisterEvent(EV_ShortcutPageUpdate);
	RegisterEvent(EV_ShortcutJoypad);
	RegisterEvent(EV_ShortcutClear);
	RegisterEvent(EV_JoypadLButtonDown);
	RegisterEvent(EV_JoypadLButtonUp);
	RegisterEvent(EV_JoypadRButtonDown);
	RegisterEvent(EV_JoypadRButtonUp);
	RegisterEvent(EV_ShortcutCommandSlot);
	RegisterEvent(EV_ShortcutKeyAssignChanged);
	RegisterEvent(EV_SetEnterChatting);
	RegisterEvent(EV_UnSetEnterChatting);
	RegisterEvent(EV_EquipItemTooltipClear);
}

function OnShow()
{
	LoadINIValues();
	// End:0x18
	if(m_IsLocked)
	{
		Lock();		
	}
	else
	{
		UNLOCK();
	}
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_1");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_1");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_2");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_2");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_3");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_3");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_4");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_4");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_5");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_5");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_6");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_6");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_7");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_7");
	SettingShortCut();
	// End:0x359
	if(getInstanceUIData().getIsClassicServer())
	{
		GetButtonHandle("ShortcutWnd.ShortcutWndVertical.ReduceButton").HideWindow();
		GetButtonHandle("ShortcutWnd.ShortcutWndHorizontal.ReduceButton").HideWindow();
		GetButtonHandle("ShortcutWnd.ShortcutWndVertical.ExpandButton").ShowWindow();
		GetButtonHandle("ShortcutWnd.ShortcutWndHorizontal.ExpandButton").ShowWindow();
		// End:0x2E8
		if(MAX_ShortcutExtend <= m_Expand)
		{
			m_Expand = MAX_ShortcutExtend - 1;
		}
		ExpandByNum(m_Expand);
		// End:0x356
		if(m_extendBounsSlot > 0)
		{
			GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").ShowWindow();
		}
		else
		{
			GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").HideWindow();
		}
	}
	else
	{
		// End:0x376
		if(MAX_ShortcutExtend <= m_Expand)
		{
			m_Expand = MAX_ShortcutExtend - 1;
		}
		GetButtonHandle("ShortcutWnd.ShortcutWndVertical.ExpandButton").ShowWindow();
		GetButtonHandle("ShortcutWnd.ShortcutWndHorizontal.ExpandButton").ShowWindow();
		ExpandByNum(m_Expand);
		// End:0x43D
		if(m_extendBounsSlot > 0)
		{
			GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").ShowWindow();
		}
		else
		{
			GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").HideWindow();
		}
	}
	SetVertical(m_IsVertical);
}

function LoadINIValues()
{
	local int tmpInt;

	GetINIInt("ShortcutWnd", "e", m_Expand, "WindowsInfo.ini");
	GetINIInt("ShortcutWnd", "m", m_extendBounsSlot, "WindowsInfo.ini");
	GetINIBool("ShortcutWnd", "l", tmpInt, "windowsInfo.ini");
	m_IsLocked = GetOptionBool("Game", "IsLockShortcutWnd");
	// End:0xBD
	if(bool(tmpInt))
	{
		OnMaxBtn();		
	}
	else
	{
		OnMinBtn();
	}
	GetINIInt("ShortcutWnd", "v", tmpInt, "WindowsInfo.ini");
	m_IsVertical = bool(tmpInt);
}

function OnLoad()
{
	local bool bMinTooltip;
	local ToolTip script;
	local int minTooltip;

	// End:0x15
	if(getInstanceUIData().getIsArenaServer())
	{
		return;
	}
	m_ShortcutWndExtendName = "ShortcutWnd_Extend";
	Me = GetWindowHandle("ShortcutWnd");
	AutoShotItemWndScript = AutoShotItemWnd(GetScript("AutoShotItemWnd"));
	LoadINIValues();
	InitShortPageNum();
	GetINIBool("ShortcutWnd", "l", minTooltip, "windowsInfo.ini");
	bMinTooltip = bool(minTooltip);
	script = ToolTip(GetScript("Tooltip"));
	script.setBoolSelect(! bMinTooltip);
	// End:0x1C5
	if(bMinTooltip)
	{
		HideWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn");
		ShowWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn");
		HideWindow("ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn");
		ShowWindow("ShortcutWnd.ShortcutWndVertical.TooltipMinBtn");		
	}
	else
	{
		ShowWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn");
		HideWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn");
		ShowWindow("ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn");
		HideWindow("ShortcutWnd.ShortcutWndVertical.TooltipMinBtn");
	}
}

function OnDefaultPosition()
{
	// End:0x15
	if(getInstanceUIData().getIsArenaServer())
	{
		return;
	}
	// End:0x46
	if(GetOptionInt("Game", "LayoutDF") == 1)
	{
		m_Expand = MAX_ShortcutExtend - 1;
		SetVertical(false);
	}
	ArrangeWnd();
	ExpandWnd();
	ExtendShortcutDefaultPostion();
}

function ExtendShortcutDefaultPostion()
{
	GetWindowHandle("ShortcutWnd." $ m_ShortcutWndExtendName).SetAnchor("", "BottomCenter", "TopLeft", 280, -220);
	GetWindowHandle("ShortcutWnd." $ m_ShortcutWndExtendName).ClearAnchor();
}

function OnEnterState(name a_CurrentStateName)
{
	// End:0x15
	if(getInstanceUIData().getIsArenaServer())
	{
		return;
	}
	ArrangeWnd();
	ExpandWnd();
}

function OnExitState(name a_CurrentStateName)
{
	// End:0x15
	if(a_CurrentStateName == 'LoadingState')
	{
		InitShortPageNum();
	}
}

function SettingShortCut()
{
	GetButtonHandle("ShortcutWnd.ShortcutWndHorizontal.BounsExtendSlotBtn").ShowWindow();
	GetButtonHandle("ShortcutWnd.ShortcutWndVertical.BounsExtendSlotBtn").ShowWindow();
	MAX_ShortcutExtend = 8;

	MAX_Page = 20;
}

function OnEvent(int a_EventID, string a_Param)
{
	// End:0x15
	if(getInstanceUIData().getIsArenaServer())
	{
		return;
	}
	switch(a_EventID)
	{
		// End:0x2D
		case EV_GameStart:
			SettingShortCut();
			// End:0x126
			break;
		// End:0x40
		case EV_ShortcutCommandSlot:
			ExecuteShortcutCommandBySlot(a_Param);
			// End:0x126
			break;
		// End:0x56
		case EV_ShortcutPageUpdate:
			HandleShortcutPageUpdate(a_Param);
			// End:0x126
			break;
		// End:0x6C
		case EV_ShortcutJoypad:
			HandleShortcutJoypad(a_Param);
			// End:0x126
			break;
		// End:0x82
		case EV_JoypadLButtonDown:
			HandleJoypadLButtonDown(a_Param);
			// End:0x126
			break;
		// End:0x98
		case EV_JoypadLButtonUp:
			HandleJoypadLButtonUp(a_Param);
			// End:0x126
			break;
		// End:0xAE
		case EV_JoypadRButtonDown:
			HandleJoypadRButtonDown(a_Param);
			// End:0x126
			break;
		// End:0xC4
		case EV_JoypadRButtonUp:
			HandleJoypadRButtonUp(a_Param);
			// End:0x126
			break;
		// End:0xDA
		case EV_ShortcutUpdate:
			HandleShortcutUpdate(a_Param);
			// End:0x126
			break;
		// End:0xF7
		case EV_ShortcutClear:
			HandleShortcutClear();
			ArrangeWnd();
			ExpandWnd();
			// End:0x126
			break;
		// End:0xFF
		case EV_ShortcutKeyAssignChanged:
		// End:0x107
		case EV_SetEnterChatting:
		// End:0x10F
		case EV_UnSetEnterChatting:
		// End:0x123
		case EV_EquipItemTooltipClear:
			ClearAllShortcutItemTooltip();
			// End:0x126
			break;
	}
}

function ClearAllShortcutItemTooltip()
{
	Me.ClearAllChildShortcutItemTooltip();
}

function InitShortPageNum()
{
	CurrentShortcutPage = 0;
	CurrentShortcutPage2 = 1;
	CurrentShortcutPage3 = 2;
	CurrentShortcutPage4 = 3;
	CurrentShortcutPage5 = 4;
	CurrentShortcutPage6 = 5;
	CurrentShortcutPage7 = 6;
	CurrentShortcutPage8 = 7;
}

function HandleShortcutPageUpdate(string param)
{
	local int i, nShortcutID, ShortcutPage;

	// End:0x100
	if(ParseInt(param, "ShortcutPage", ShortcutPage))
	{
		// End:0x3F
		if((0 > ShortcutPage) || MAX_Page <= ShortcutPage)
		{
			return;
		}
		CurrentShortcutPage = ShortcutPage;
		class'UIAPI_TEXTBOX'.static.SetText(("ShortcutWnd." $ m_ShortcutWndName) $ ".PageNumTextBox", string(CurrentShortcutPage + 1));
		nShortcutID = CurrentShortcutPage * MAX_ShortcutPerPage;

		// End:0x100 [Loop If]
		for(i = 0; i < MAX_ShortcutPerPage; i++)
		{
			class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndName $ ".Shortcut" $ (i + 1), nShortcutID);
			++ nShortcutID;
		}
	}
}

function HandleShortcutUpdate(string param)
{
	local int nShortcutID, nShortcutNum;

	ParseInt(param, "ShortcutID", nShortcutID);
	nShortcutNum = int(nShortcutID % MAX_ShortcutPerPage) + 1;
	// End:0x86
	if(IsShortcutIDInCurPage(CurrentShortcutPage, nShortcutID))
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndName $ ".Shortcut" $ string(nShortcutNum), nShortcutID);
	}
	// End:0xDA
	if(IsShortcutIDInCurPage(CurrentShortcutPage2, nShortcutID))
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndName $ "_1.Shortcut" $ string(nShortcutNum), nShortcutID);
	}
	// End:0x12E
	if(IsShortcutIDInCurPage(CurrentShortcutPage3, nShortcutID))
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndName $ "_2.Shortcut" $ string(nShortcutNum), nShortcutID);
	}
	// End:0x182
	if(IsShortcutIDInCurPage(CurrentShortcutPage4, nShortcutID))
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndName $ "_3.Shortcut" $ string(nShortcutNum), nShortcutID);
	}
	// End:0x1D6
	if(IsShortcutIDInCurPage(CurrentShortcutPage5, nShortcutID))
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndName $ "_4.Shortcut" $ string(nShortcutNum), nShortcutID);
	}
	// End:0x228
	if(IsShortcutIDInCurPage(CurrentShortcutPageExtend, nShortcutID))
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndExtendName $ ".Shortcut" $ string(nShortcutNum), nShortcutID);
	}
}

function HandleShortcutClear()
{
	local int i;

	// End:0x2E6 [Loop If]
	for(i = 0; i < MAX_ShortcutPerPage; i++)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndVertical.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndVertical_1.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndVertical_2.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndVertical_3.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndVertical_4.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndVertical_5.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndVertical_6.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndVertical_7.Shortcut" $ string(i + 1));
		
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndHorizontal.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndHorizontal_1.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndHorizontal_2.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndHorizontal_3.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndHorizontal_4.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndHorizontal_5.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndHorizontal_6.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndHorizontal_7.Shortcut" $ string(i + 1));
		
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWnd_Extend.Shortcut" $ string(i + 1));
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndJoypadExpand.Shortcut" $ string(i + 1));
	}

	// End:0x346 [Loop If]
	for(i = 0; i < 4; i++)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndJoypad.Shortcut" $ string(i + 1));
	}
}

function OnClickButton(string a_strID)
{
	switch(a_strID)
	{
		// End:0x1C
		case "PrevBtn":
			OnPrevBtn();
			// End:0x215
			break;
		// End:0x31
		case "NextBtn":
			OnNextBtn();
			// End:0x215
			break;
		// End:0x47
		case "PrevBtn2":
			OnPrevBtn2();
			// End:0x215
			break;
		// End:0x5D
		case "NextBtn2":
			OnNextBtn2();
			// End:0x215
			break;
		// End:0x73
		case "PrevBtn3":
			OnPrevBtn3();
			// End:0x215
			break;
		// End:0x89
		case "NextBtn3":
			OnNextBtn3();
			// End:0x215
			break;
		// End:0x9F
		case "PrevBtn4":
			OnPrevBtn4();
			// End:0x215
			break;
		// End:0xBA
		case "PrevBtnExtend":
			OnPrevBtnExtend();
			// End:0x215
			break;
		// End:0xD0
		case "NextBtn4":
			OnNextBtn4();
			// End:0x215
			break;
		// End:0xEB
		case "NextBtnExtend":
			OnNextBtnExtend();
			// End:0x215
			break;
		// End:0x101
		case "PrevBtn5":
			OnPrevBtn5();
			// End:0x215
			break;
		// End:0x117
		case "NextBtn5":
			OnNextBtn5();
			// End:0x215
			break;
		case "PrevBtn6":
			OnPrevBtn6();
			// End:0x215
			break;
		// End:0x117
		case "NextBtn6":
			OnNextBtn6();
			// End:0x215
			break;
		case "PrevBtn7":
			OnPrevBtn7();
			// End:0x215
			break;
		// End:0x117
		case "NextBtn7":
			OnNextBtn7();
			// End:0x215
			break;
		case "PrevBtn8":
			OnPrevBtn8();
			// End:0x215
			break;
		// End:0x117
		case "NextBtn8":
			OnNextBtn8();
			// End:0x215
			break;
		// End:0x12C
		case "LockBtn":
			OnClickLockBtn();
			// End:0x215
			break;
		// End:0x143
		case "UnlockBtn":
			OnClickUnlockBtn();
			// End:0x215
			break;
		// End:0x15A
		case "RotateBtn":
			OnRotateBtn();
			// End:0x215
			break;
		// End:0x171
		case "JoypadBtn":
			OnJoypadBtn();
			// End:0x215
			break;
		// End:0x188
		case "ExpandBtn":
			OnExpandBtn();
			// End:0x215
			break;
		// End:0x1A2
		case "ExpandButton":
			OnClickExpandShortcutButton();
			// End:0x215
			break;
		// End:0x1BC
		case "ReduceButton":
			OnClickExpandShortcutButton();
			// End:0x215
			break;
		// End:0x1D7
		case "TooltipMinBtn":
			OnMinBtn();
			// End:0x215
			break;
		// End:0x1F2
		case "TooltipMaxBtn":
			OnMaxBtn();
			// End:0x215
			break;
		// End:0x212
		case "BounsExtendSlotBtn":
			OnBounsExtendSlotBtn();
			// End:0x215
			break;
		// End:0xFFFF
		default:
			break;
	}
}

function OnBounsExtendSlotBtn()
{
	// End:0x8E
	if(GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").IsShowWindow())
	{
		GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").HideWindow();
		SetINIInt("ShortcutWnd", "m", 0, "WindowsInfo.ini");		
	}
	else
	{
		GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").ShowWindow();
		SetINIInt("ShortcutWnd", "m", 1, "WindowsInfo.ini");
	}
}

function OnMinBtn()
{
	local ToolTip script;

	HandleShortcutClear();
	ArrangeWnd();
	ExpandWnd();
	script = ToolTip(GetScript("Tooltip"));
	script.setBoolSelect(true);
	ShowWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn");
	HideWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn");
	ShowWindow("ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn");
	HideWindow("ShortcutWnd.ShortcutWndVertical.TooltipMinBtn");
	SetINIBool("ShortcutWnd", "l", false, "windowsInfo.ini");
}

function OnMaxBtn()
{
	local ToolTip script;

	HandleShortcutClear();
	ArrangeWnd();
	ExpandWnd();
	script = ToolTip(GetScript("Tooltip"));
	script.setBoolSelect(false);
	ShowWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn");
	HideWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn");
	ShowWindow("ShortcutWnd.ShortcutWndVertical.TooltipMinBtn");
	HideWindow("ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn");
	SetINIBool("ShortcutWnd", "l", true, "windowsInfo.ini");
}

function OnPrevBtn()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage - 1;
	// End:0x27
	if(0 > nNewPage)
	{
		nNewPage = MAX_Page - 1;
	}
	SetCurPage(nNewPage);
}

function OnPrevBtn2()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage2 - 1;
	// End:0x27
	if(0 > nNewPage)
	{
		nNewPage = MAX_Page - 1;
	}
	SetCurPage2(nNewPage);
}

function OnPrevBtn3()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage3 - 1;
	// End:0x27
	if(0 > nNewPage)
	{
		nNewPage = MAX_Page - 1;
	}
	SetCurPage3(nNewPage);
}

function OnPrevBtn4()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage4 - 1;
	// End:0x27
	if(0 > nNewPage)
	{
		nNewPage = MAX_Page - 1;
	}
	SetCurPage4(nNewPage);
}

function OnPrevBtnExtend()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPageExtend - 1;
	// End:0x27
	if(0 > nNewPage)
	{
		nNewPage = MAX_Page - 1;
	}
	SetCurPageExtend(nNewPage);
	SetOptionInt("ShortCutWnd", "Page", nNewPage);
	RefreshIni("Option.ini");
}

function OnNextBtnExtend()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPageExtend + 1;
	// End:0x24
	if(MAX_Page <= nNewPage)
	{
		nNewPage = 0;
	}
	SetCurPageExtend(nNewPage);
	SetOptionInt("ShortCutWnd", "Page", nNewPage);
	RefreshIni("Option.ini");
}

function OnNextBtn()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage + 1;
	// End:0x24
	if(MAX_Page <= nNewPage)
	{
		nNewPage = 0;
	}
	SetCurPage(nNewPage);
}

function OnNextBtn2()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage2 + 1;
	// End:0x24
	if(MAX_Page <= nNewPage)
	{
		nNewPage = 0;
	}
	SetCurPage2(nNewPage);
}

function OnNextBtn3()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage3 + 1;
	// End:0x24
	if(MAX_Page <= nNewPage)
	{
		nNewPage = 0;
	}
	SetCurPage3(nNewPage);
}

function OnNextBtn4()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage4 + 1;
	// End:0x24
	if(MAX_Page <= nNewPage)
	{
		nNewPage = 0;
	}
	SetCurPage4(nNewPage);
}

function OnPrevBtn5()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage5 - 1;
	// End:0x27
	if(0 > nNewPage)
	{
		nNewPage = MAX_Page - 1;
	}
	SetCurPage5(nNewPage);
}

function OnPrevBtn6()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage6 - 1;
	// End:0x27
	if(0 > nNewPage)
	{
		nNewPage = MAX_Page - 1;
	}
	SetCurPage6(nNewPage);
}

function OnPrevBtn7()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage7 - 1;
	// End:0x27
	if(0 > nNewPage)
	{
		nNewPage = MAX_Page - 1;
	}
	SetCurPage7(nNewPage);
}

function OnPrevBtn8()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage8 - 1;
	// End:0x27
	if(0 > nNewPage)
	{
		nNewPage = MAX_Page - 1;
	}
	SetCurPage8(nNewPage);
}

function OnNextBtn5()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage5 + 1;
	// End:0x24
	if(MAX_Page <= nNewPage)
	{
		nNewPage = 0;
	}
	SetCurPage5(nNewPage);
}

function OnNextBtn6()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage6 + 1;
	// End:0x24
	if(MAX_Page <= nNewPage)
	{
		nNewPage = 0;
	}
	SetCurPage6(nNewPage);
}


function OnNextBtn7()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage7 + 1;
	// End:0x24
	if(MAX_Page <= nNewPage)
	{
		nNewPage = 0;
	}
	SetCurPage7(nNewPage);
}

function OnNextBtn8()
{
	local int nNewPage;

	nNewPage = CurrentShortcutPage8 + 1;
	// End:0x24
	if(MAX_Page <= nNewPage)
	{
		nNewPage = 0;
	}
	SetCurPage8(nNewPage);
}

function OnClickLockBtn()
{
	UNLOCK();
}

function OnClickUnlockBtn()
{
	Lock();
}

function OnRotateBtn()
{
	SetVertical(! m_IsVertical);
	// End:0x128
	if(m_IsVertical)
	{
		class'UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndVertical", "ShortcutWnd.ShortcutWndHorizontal", "BottomRight", "BottomRight", 0, 0);
		class'UIAPI_WINDOW'.static.ClearAnchor("ShortcutWnd.ShortcutWndVertical");
		class'UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndHorizontal", "ShortcutWnd.ShortcutWndVertical", "BottomRight", "BottomRight", 0, 0);		
	}
	else
	{
		class'UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndHorizontal", "ShortcutWnd.ShortcutWndVertical", "BottomRight", "BottomRight", 0, 0);
		class'UIAPI_WINDOW'.static.ClearAnchor("ShortcutWnd.ShortcutWndHorizontal");
		class'UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndVertical", "ShortcutWnd.ShortcutWndHorizontal", "BottomRight", "BottomRight", 0, 0);
	}
	ExpandByNum(m_Expand);
	class'UIAPI_WINDOW'.static.SetFocus("ShortcutWnd." $ m_ShortcutWndName);
	AutoShotItemWndScript.ExHideSubWnd();
}

function OnJoypadBtn()
{
	SetJoypad(! m_IsJoypad);
	class'UIAPI_WINDOW'.static.SetFocus("ShortcutWnd." $ m_ShortcutWndName);
}

function OnExpandBtn()
{
	SetJoypadExpand(! m_IsJoypadExpand);
	class'UIAPI_WINDOW'.static.SetFocus("ShortcutWnd." $ m_ShortcutWndName);
}

function SetCurPage(int a_nCurPage)
{
	// End:0x1E
	if(0 > a_nCurPage || MAX_Page <= a_nCurPage)
	{
		return;
	}
	class'ShortcutWndAPI'.static.SetShortcutPage(a_nCurPage);
}

function SetCurPage2(int a_nCurPage)
{
	local int i, nShortcutID;

	// End:0x1E
	if(0 > a_nCurPage || MAX_Page <= a_nCurPage)
	{
		return;
	}
	CurrentShortcutPage2 = a_nCurPage;
	class'UIAPI_TEXTBOX'.static.SetText("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1" $ ".PageNumTextBox", string(CurrentShortcutPage2 + 1));
	nShortcutID = CurrentShortcutPage2 * MAX_ShortcutPerPage;

	// End:0x103 [Loop If]
	for(i = 0; i < MAX_ShortcutPerPage; i++)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1" $ ".Shortcut" $ (i + 1), nShortcutID);
		nShortcutID++;
	}
}

function SetCurPage3(int a_nCurPage)
{
	local int i, nShortcutID;

	// End:0x1E
	if(0 > a_nCurPage || MAX_Page <= a_nCurPage)
	{
		return;
	}
	CurrentShortcutPage3 = a_nCurPage;
	class'UIAPI_TEXTBOX'.static.SetText("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1." $ m_ShortcutWndName $ "_2" $ ".PageNumTextBox", string(CurrentShortcutPage3 + 1));
	nShortcutID = CurrentShortcutPage3 * MAX_ShortcutPerPage;

	// End:0x11F [Loop If]
	for(i = 0; i < MAX_ShortcutPerPage; i++)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1." $ m_ShortcutWndName $ "_2" $ ".Shortcut" $ (i + 1), nShortcutID);
		++ nShortcutID;
	}
}

function SetCurPage4(int a_nCurPage)
{
	local int i, nShortcutID;

	// End:0x1E
	if(0 > a_nCurPage || MAX_Page <= a_nCurPage)
	{
		return;
	}
	CurrentShortcutPage4 = a_nCurPage;
	class'UIAPI_TEXTBOX'.static.SetText("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1." $ m_ShortcutWndName $ "_3" $ ".PageNumTextBox", string(CurrentShortcutPage4 + 1));
	nShortcutID = CurrentShortcutPage4 * MAX_ShortcutPerPage;

	// End:0x11F [Loop If]
	for(i = 0; i < MAX_ShortcutPerPage; i++)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1." $ m_ShortcutWndName $ "_3" $ ".Shortcut" $ (i + 1), nShortcutID);
		nShortcutID++;
	}
}

function SetCurPage5(int a_nCurPage)
{
	local int i, nShortcutID;

	// End:0x1E
	if(0 > a_nCurPage || MAX_Page <= a_nCurPage)
	{
		return;
	}
	CurrentShortcutPage5 = a_nCurPage;
	class'UIAPI_TEXTBOX'.static.SetText("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1." $ m_ShortcutWndName $ "_4" $ ".PageNumTextBox", string(CurrentShortcutPage5 + 1));
	nShortcutID = CurrentShortcutPage5 * MAX_ShortcutPerPage;

	// End:0x11F [Loop If]
	for(i = 0; i < MAX_ShortcutPerPage; i++)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1." $ m_ShortcutWndName $ "_4" $ ".Shortcut" $ (i + 1), nShortcutID);
		++ nShortcutID;
	}
}

function SetCurPage6(int a_nCurPage)
{
	local int i, nShortcutID;

	// End:0x1E
	if(0 > a_nCurPage || MAX_Page <= a_nCurPage)
	{
		return;
	}
	CurrentShortcutPage6 = a_nCurPage;
	class'UIAPI_TEXTBOX'.static.SetText("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1." $ m_ShortcutWndName $ "_5" $ ".PageNumTextBox", string(CurrentShortcutPage6 + 1));
	nShortcutID = CurrentShortcutPage6 * MAX_ShortcutPerPage;

	// End:0x11F [Loop If]
	for(i = 0; i < MAX_ShortcutPerPage; i++)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1." $ m_ShortcutWndName $ "_5" $ ".Shortcut" $ (i + 1), nShortcutID);
		++ nShortcutID;
	}
}

function SetCurPage7(int a_nCurPage)
{
	local int i, nShortcutID;

	// End:0x1E
	if(0 > a_nCurPage || MAX_Page <= a_nCurPage)
	{
		return;
	}
	CurrentShortcutPage7 = a_nCurPage;
	class'UIAPI_TEXTBOX'.static.SetText("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1." $ m_ShortcutWndName $ "_6" $ ".PageNumTextBox", string(CurrentShortcutPage7 + 1));
	nShortcutID = CurrentShortcutPage7 * MAX_ShortcutPerPage;

	// End:0x11F [Loop If]
	for(i = 0; i < MAX_ShortcutPerPage; i++)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1." $ m_ShortcutWndName $ "_6" $ ".Shortcut" $ (i + 1), nShortcutID);
		++ nShortcutID;
	}
}

function SetCurPage8(int a_nCurPage)
{
	local int i, nShortcutID;

	// End:0x1E
	if(0 > a_nCurPage || MAX_Page <= a_nCurPage)
	{
		return;
	}
	CurrentShortcutPage8 = a_nCurPage;
	class'UIAPI_TEXTBOX'.static.SetText("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1." $ m_ShortcutWndName $ "_7" $ ".PageNumTextBox", string(CurrentShortcutPage8 + 1));
	nShortcutID = CurrentShortcutPage8 * MAX_ShortcutPerPage;

	// End:0x11F [Loop If]
	for(i = 0; i < MAX_ShortcutPerPage; i++)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_1." $ m_ShortcutWndName $ "_7" $ ".Shortcut" $ (i + 1), nShortcutID);
		++ nShortcutID;
	}
}

function SetCurPageExtend(int a_nCurPage)
{
	local int i, nShortcutID;

	// End:0x1E
	if(0 > a_nCurPage || MAX_Page <= a_nCurPage)
	{
		return;
	}
	CurrentShortcutPageExtend = a_nCurPage;
	class'UIAPI_TEXTBOX'.static.SetText(("ShortcutWnd." $ m_ShortcutWndExtendName) $ ".PageNumTextBox", string(CurrentShortcutPageExtend + 1));
	nShortcutID = CurrentShortcutPageExtend * MAX_ShortcutPerPage;

	// End:0xDF [Loop If]
	for(i = 0; i < MAX_ShortcutPerPage; i++)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd." $ m_ShortcutWndExtendName $ ".Shortcut" $ string(i + 1), nShortcutID);
		++ nShortcutID;
	}
}

function bool IsShortcutIDInCurPage(int pageNum, int a_nShortcutID)
{
	// End:0x15
	if(pageNum * MAX_ShortcutPerPage > a_nShortcutID)
	{
		return false;
	}
	// End:0x2D
	if((pageNum + 1) * MAX_ShortcutPerPage <= a_nShortcutID)
	{
		return false;
	}
	return true;
}

function Lock()
{
	m_IsLocked = true;
	SetOptionBool("Game", "IsLockShortcutWnd", true);
	ShowWindow("ShortcutWnd." $ m_ShortcutWndName $ ".LockBtn");
	HideWindow("ShortcutWnd." $ m_ShortcutWndName $ ".UnlockBtn");
}

function UNLOCK()
{
	m_IsLocked = false;
	SetOptionBool("Game", "IsLockShortcutWnd", false);
	ShowWindow("ShortcutWnd." $ m_ShortcutWndName $ ".UnlockBtn");
	HideWindow("ShortcutWnd." $ m_ShortcutWndName $ ".LockBtn");
}

function SetVertical(bool a_IsVertical)
{
	m_IsVertical = a_IsVertical;
	SetINIInt("ShortcutWnd", "v", int(m_IsVertical), "WindowsInfo.ini");
	ArrangeWnd();
	ExpandWnd();
}

function ArrangeWnd()
{
	local Rect WindowRect;

	// End:0x140
	if(m_IsJoypad)
	{
		HideWindow("ShortcutWnd.ShortcutWndVertical");
		HideWindow("ShortcutWnd.ShortcutWndHorizontal");
		// End:0xD4
		if(m_IsJoypadExpand)
		{
			HideWindow("ShortcutWnd.ShortcutWndJoypad");
			ShowWindow("ShortcutWnd.ShortcutWndJoypadExpand");
			m_ShortcutWndName = "ShortcutWndJoypadExpand";			
		}
		else
		{
			HideWindow("ShortcutWnd.ShortcutWndJoypadExpand");
			ShowWindow("ShortcutWnd.ShortcutWndJoypad");
			m_ShortcutWndName = "ShortcutWndJoypad";
		}		
	}
	else
	{
		HideWindow("ShortcutWnd.ShortcutWndJoypadExpand");
		HideWindow("ShortcutWnd.ShortcutWndJoypad");
		// End:0x288
		if(m_IsVertical)
		{
			m_ShortcutWndName = "ShortcutWndVertical";
			WindowRect = class'UIAPI_WINDOW'.static.GetRect("ShortcutWnd.ShortcutWndVertical");
			// End:0x235
			if(WindowRect.nY < 0)
			{
				class'UIAPI_WINDOW'.static.MoveTo("ShortcutWnd.ShortcutWndVertical", WindowRect.nX, 0);
			}
			HideWindow("ShortcutWnd.ShortcutWndHorizontal");
			ShowWindow("ShortcutWnd.ShortcutWndVertical");			
		}
		else
		{
			m_ShortcutWndName = "ShortcutWndHorizontal";
			WindowRect = class'UIAPI_WINDOW'.static.GetRect("ShortcutWnd.ShortcutWndHorizontal");
			// End:0x32A
			if(WindowRect.nX < 0)
			{
				class'UIAPI_WINDOW'.static.MoveTo("ShortcutWnd.ShortcutWndHorizontal", 0, WindowRect.nY);
			}
			HideWindow("ShortcutWnd.ShortcutWndVertical");
			ShowWindow("ShortcutWnd.ShortcutWndHorizontal");
		}
		// End:0x3AF
		if(m_IsJoypadOn)
		{
			ShowWindow("ShortcutWnd." $ m_ShortcutWndName $ ".JoypadBtn");			
		}
		else
		{
			HideWindow("ShortcutWnd." $ m_ShortcutWndName $ ".JoypadBtn");
		}
	}
	// End:0x3EA
	if(m_IsLocked)
	{
		Lock();		
	}
	else
	{
		UNLOCK();
	}
	SetCurPage(CurrentShortcutPage);
	SetCurPage2(CurrentShortcutPage2);
	SetCurPage3(CurrentShortcutPage3);
	SetCurPage4(CurrentShortcutPage4);
	SetCurPage5(CurrentShortcutPage5);
	SetCurPage6(CurrentShortcutPage6);
	SetCurPage7(CurrentShortcutPage7);
	SetCurPage8(CurrentShortcutPage8);
	//SetCurPageExtend(CurrentShortcutPageExtend);
	if(GetOptionInt("ShortCutWnd", "Page") > 0)
		SetCurPageExtend(GetOptionInt("ShortCutWnd", "Page"));
	else
		SetCurPageExtend(CurrentShortcutPageExtend);
	m_IsShortcutExpand = m_Expand != (MAX_ShortcutExtend - 1);
	HandleExpandButton();
}

function ExpandWnd()
{
	// End:0x21
	if(m_Expand > 0)
	{
		m_IsShortcutExpand = false;
		ExpandByNum(m_Expand);		
	}
	else
	{
		m_IsShortcutExpand = true;
		Reduce();
	}
}

function ExpandByNum(int expandNum)
{
	m_IsShortcutExpand = true;
	m_Expand = expandNum;
	switch(expandNum)
	{
		case 7:
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_7");
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_7");
		case 6:
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_6");
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_6");
		case 5:
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_5");
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_5");
		case 4:
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_4");
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_4");
		case 3:
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_3");
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_3");
		case 2:
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_2");
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_2");
		case 1:
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_1");
			class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_1");
			break;
		default:
			break;
	}
	SetINIInt("ShortcutWnd", "e", m_Expand, "WindowsInfo.ini");
	HandleExpandButton();
	AutoShotItemWndScript.windowPositionAutoMove();
	AutoShotItemWndScript.checkSlotShowState();
}

function Reduce()
{
	m_IsShortcutExpand = true;
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_1");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_2");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_1");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_2");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_3");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_3");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_4");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_4");	
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_5");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_5");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_6");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_6");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_7");
	class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_7");
	m_Expand = 0;
	SetINIInt("ShortcutWnd", "e", m_Expand, "WindowsInfo.ini");
	HandleExpandButton();
	AutoShotItemWndScript.windowPositionAutoMove();
	AutoShotItemWndScript.checkSlotShowState();
}

function OnClickExpandShortcutButton()
{
	// End:0x1B
	if(m_Expand == (MAX_ShortcutExtend - 1))
	{
		Reduce();		
	}
	else
	{
		ExpandByNum(m_Expand + 1);
	}
}

/* function ExecuteShortcutCommandBySlot(string param)
{
	local int Slot;

	ParseInt(param, "Slot", Slot);
	// End:0x134
	if(Me.IsShowWindow())
	{
		// End:0x63
		if(Slot >= 0 && Slot < MAX_ShortcutPerPage)
		{
			class'ShortcutWndAPI'.static.ExecuteShortcutBySlot((CurrentShortcutPage * 12) + Slot);			
		}
		else
		{
			// End:0xA7
			if(Slot >= MAX_ShortcutPerPage && Slot < MAX_ShortcutPerPage * 2)
			{
				class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(CurrentShortcutPage2 * MAX_ShortcutPerPage + Slot - MAX_ShortcutPerPage);				
			}
			else
			{
				// End:0xEF
				if(Slot >= (MAX_ShortcutPerPage * 2) && Slot < MAX_ShortcutPerPage * 3)
				{
					class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(CurrentShortcutPage3 * MAX_ShortcutPerPage + Slot - MAX_ShortcutPerPage2);					
				}
				else
				{
					// End:0x134
					if(Slot >= MAX_ShortcutPerPage * 3 && Slot < (MAX_ShortcutPerPage * 4))
					{
						class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(CurrentShortcutPage4 * MAX_ShortcutPerPage + Slot - MAX_ShortcutPerPage3);
					}
				}
			}
		}
	}
}
 */
 
function ExecuteShortcutCommandBySlot(string param)
{
	local int slot;
	ParseInt(param, "Slot", slot);

	if(Me.isShowwindow())		// ?? ??? ?? ????? ??.
	{	
		if( slot >=0 && slot < MAX_ShortcutPerPage )			// bottom
		{
			class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(CurrentShortcutPage*MAX_ShortcutPerPage + slot);
		}
		else if( slot >= MAX_ShortcutPerPage && slot < MAX_ShortcutPerPage*2 )		// middle
		{
			//debug ("?????2");
			class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(CurrentShortcutPage2*MAX_ShortcutPerPage + slot - MAX_ShortcutPerPage);
		}
		else if( slot >= MAX_ShortcutPerPage*2 && slot < MAX_ShortcutPerPage*3 )		// last
		{
			//debug ("?????3");
			class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(CurrentShortcutPage3*MAX_ShortcutPerPage + slot - MAX_ShortcutPerPage2);
		}
		else if( slot >= MAX_ShortcutPerPage*3 && slot < MAX_ShortcutPerPage*4 )		// last
		{
			//debug ("?????4");
			class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(CurrentShortcutPage4*MAX_ShortcutPerPage + slot - MAX_ShortcutPerPage3);
		}
		else if( slot >= MAX_ShortcutPerPage*4 && slot < MAX_ShortcutPerPage*5 )		// last
		{
			//debug ("?????5");
			class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(CurrentShortcutPage5*MAX_ShortcutPerPage + slot - MAX_ShortcutPerPage4);
		}
		else if( slot >= MAX_ShortcutPerPage*5 && slot < MAX_ShortcutPerPage*6 )		// last
		{
			//debug ("?????6");
			class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(CurrentShortcutPage6*MAX_ShortcutPerPage + slot - MAX_ShortcutPerPage5);
		}
		else if( slot >= MAX_ShortcutPerPage*6 && slot < MAX_ShortcutPerPage*7 )		// last
		{
			//debug ("?????7");
			class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(CurrentShortcutPage7*MAX_ShortcutPerPage + slot - MAX_ShortcutPerPage6);
		}
		else if( slot >= MAX_ShortcutPerPage*7 && slot < MAX_ShortcutPerPage*8 )		// last
		{
			//debug ("?????8");
			class'ShortcutWndAPI'.static.ExecuteShortcutBySlot(CurrentShortcutPage8*MAX_ShortcutPerPage + slot - MAX_ShortcutPerPage7);
		}
	}
}

function HandleExpandButton()
{
	// End:0x0B
	if(IsAdenServer())
	{
		return;
	}
	// End:0x6F
	if(m_IsShortcutExpand)
	{
		ShowWindow("ShortcutWnd." $ m_ShortcutWndName $ ".ExpandButton");
		HideWindow("ShortcutWnd." $ m_ShortcutWndName $ ".ReduceButton");		
	}
	else
	{
		HideWindow("ShortcutWnd." $ m_ShortcutWndName $ ".ExpandButton");
		ShowWindow("ShortcutWnd." $ m_ShortcutWndName $ ".ReduceButton");
	}
}

function bool IsVertical()
{
	return m_IsVertical;
}

// ���� Ȯ�彽�� ���� 0~4
function int getExpandNum()
{
	return m_Expand;
}

// �ڵ� ��ź ��ġ ���� TT#72738
function AutoShotPositionAutoMove()
{
	AutoShotItemWndScript.windowPositionAutoMove();
	AutoShotItemWndScript.checkSlotShowState();
}

function SetJoypad(bool a_IsJoypad)
{
	m_IsJoypad = a_IsJoypad;
	ArrangeWnd();
}

function SetJoypadExpand(bool a_IsJoypadExpand)
{
	m_IsJoypadExpand = a_IsJoypadExpand;
	// End:0xB4
	if(m_IsJoypadExpand)
	{
		class'UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypadExpand", "ShortcutWnd.ShortcutWndJoypad", "TopLeft", "TopLeft", 0, 0);
		class'UIAPI_WINDOW'.static.ClearAnchor("ShortcutWnd.ShortcutWndJoypadExpand");		
	}
	else
	{
		class'UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypad", "ShortcutWnd.ShortcutWndJoypadExpand", "TopLeft", "TopLeft", 0, 0);
		class'UIAPI_WINDOW'.static.ClearAnchor("ShortcutWnd.ShortcutWndJoypad");
	}
	ArrangeWnd();
}

function HandleShortcutJoypad(string a_Param)
{
	local int OnOff;

	// End:0xAF
	if(ParseInt(a_Param, "OnOff", OnOff))
	{
		// End:0x66
		if(1 == OnOff)
		{
			m_IsJoypadOn = true;
			// End:0x63
			if(Len(m_ShortcutWndName) > 0)
			{
				ShowWindow("ShortcutWnd." $ m_ShortcutWndName $ ".JoypadBtn");
			}			
		}
		else
		{
			// End:0xAF
			if(0 == OnOff)
			{
				m_IsJoypadOn = false;
				// End:0xAF
				if(Len(m_ShortcutWndName) > 0)
				{
					HideWindow("ShortcutWnd." $ m_ShortcutWndName $ ".JoypadBtn");
				}
			}
		}
	}
}

function HandleJoypadLButtonUp(string a_Param)
{
	SetJoypadShortcut(JOYSHORTCUT_Center);
}

function HandleJoypadLButtonDown(string a_Param)
{
	SetJoypadShortcut(JOYSHORTCUT_Left);
}

function HandleJoypadRButtonUp(string a_Param)
{
	SetJoypadShortcut(JOYSHORTCUT_Center);
}

function HandleJoypadRButtonDown(string a_Param)
{
	SetJoypadShortcut(JOYSHORTCUT_Right);
}

function SetJoypadShortcut(EJoyShortcut a_JoyShortcut)
{
	local int i, nShortcutID;

	switch(a_JoyShortcut)
	{
		// End:0x238
		case JOYSHORTCUT_Left:
			class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "L2UI_CH3.ShortcutWnd.joypad2_back_over1");
			class'UIAPI_TEXTURECTRL'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "ShortcutWnd.ShortcutWndJoypadExpand", "TopLeft", "TopLeft", 28, 0);
			class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadLButtonTex", "L2UI_ch3.Joypad.joypad_L_HOLD");
			class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadRButtonTex", "L2UI_ch3.Joypad.joypad_R");
			nShortcutID = CurrentShortcutPage * MAX_ShortcutPerPage + 4;

			// End:0x235 [Loop If]
			for(i = 0; i < 4; i++)
			{
				class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd.ShortcutWndJoypad.Shortcut" $ string(i + 1), nShortcutID);
				++ nShortcutID;
			}
			// End:0x697
			break;
		// End:0x460
		case JOYSHORTCUT_Center:
			class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "L2UI_CH3.ShortcutWnd.joypad2_back_over2");
			class'UIAPI_TEXTURECTRL'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "ShortcutWnd.ShortcutWndJoypadExpand", "TopLeft", "TopLeft", 158, 0);
			class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadLButtonTex", "L2UI_ch3.Joypad.joypad_L");
			class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadRButtonTex", "L2UI_ch3.Joypad.joypad_R");
			nShortcutID = CurrentShortcutPage * MAX_ShortcutPerPage;

			// End:0x45D [Loop If]
			for(i = 0; i < 4; i++)
			{
				class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd.ShortcutWndJoypad.Shortcut" $ string(i + 1), nShortcutID);
				++ nShortcutID;
			}
			// End:0x697
			break;
		// End:0x694
		case JOYSHORTCUT_Right/*2*/:
			class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "L2UI_CH3.ShortcutWnd.joypad2_back_over3");
			class'UIAPI_TEXTURECTRL'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "ShortcutWnd.ShortcutWndJoypadExpand", "TopLeft", "TopLeft", 288, 0);
			class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadLButtonTex", "L2UI_ch3.Joypad.joypad_L");
			class'UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadRButtonTex", "L2UI_ch3.Joypad.joypad_R_HOLD");
			nShortcutID = CurrentShortcutPage * MAX_ShortcutPerPage + 8;

			// End:0x691 [Loop If]
			for(i = 0; i < 4; i++)
			{
				class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd.ShortcutWndJoypad.Shortcut" $ string(i + 1), nShortcutID);
				++ nShortcutID;
			}
			// End:0x697
			break;
	}
}

defaultproperties
{
     MAX_Page=10
     MAX_ShortcutExtend=3
}
