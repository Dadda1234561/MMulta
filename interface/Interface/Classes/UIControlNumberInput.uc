class UIControlNumberInput extends UICommonAPI;

const DIALOG_ASK_PRICE = 10111;
const MAXITEMNUM = 99999;
const MAXITEMNUMSELL = 9999999999;

var string m_WindowName;
var WindowHandle Me;
var EditBoxHandle ItemCount_EditBox;
var ButtonHandle Reset_Btn;
var ButtonHandle Buy_Btn;
var ButtonHandle MultiSell_Up_Button;
var ButtonHandle MultiSell_Down_Button;
var ButtonHandle MultiSell_Input_Button;
var ButtonHandle MultiSell_Max_Button;
var private INT64 _minCountCanBuy;
var private bool is_force_disable;
var private bool is_Editor_disable;
var private bool bUseCalculator;
var private INT64 plusbasicunit;

delegate INT64 DelegateGetCountCanBuy();

delegate CustomTooltip DelegateGetBtnTooltip();

delegate DelegateESCKey();

delegate DelegateOnClickBuy();

delegate DelegateOnItemCountEdited (INT64 changedNum);

delegate DelegateOnCancel();

delegate DelegateOnClickInput();

delegate DelegateOnOverInput();

static function UIControlNumberInput InitScript(WindowHandle wnd)
{
	local UIControlNumberInput scr;

	wnd.SetScript("UIControlNumberInput");
	scr = UIControlNumberInput(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	Init(m_hOwnerWnd.m_WindowNameWithFullPath);
}

function Init(string WindowName)
{
	m_WindowName = WindowName;
	Me = GetWindowHandle(m_WindowName);
	ItemCount_EditBox = GetEditBoxHandle(m_WindowName $ ".ItemCount_EditBox");
	Reset_Btn = GetButtonHandle(m_WindowName $ ".Reset_Btn");
	Buy_Btn = GetButtonHandle(m_WindowName $ ".Buy_Btn");
	MultiSell_Up_Button = GetButtonHandle(m_WindowName $ ".MultiSell_Up_Button");
	MultiSell_Down_Button = GetButtonHandle(m_WindowName $ ".MultiSell_Down_Button");
	MultiSell_Max_Button = GetButtonHandle(m_WindowName $ ".MultiSell_Max_Button");
	MultiSell_Input_Button = GetButtonHandle(m_WindowName $ ".MultiSell_Input_Button");
	// End:0x14C
	if(MultiSell_Input_Button.m_pTargetWnd != none)
	{
		MultiSell_Input_Button.HideWindow();
	}
	is_force_disable = false;
	_minCountCanBuy = 1;
	plusbasicunit = 1;	
}

event OnChangeEditBox(string strID)
{
	switch(strID)
	{
		// End:0x3D
		case "ItemCount_EditBox":
			CheckZero();
			SetCount(int64(ItemCount_EditBox.GetString()));
			// End:0x40
			break;
	}
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x2B
		case "MultiSell_Input_Button":
			OnPriceEditBtnHandler();
			// End:0xEE
			break;
		// End:0x4C
		case "MultiSell_Up_Button":
			OnMultiSell_Up_ButtonClick();
			// End:0xEE
			break;
		// End:0x6F
		case "MultiSell_Down_Button":
			OnMultiSell_Down_ButtonClick();
			// End:0xEE
			break;
		// End:0x8B
		case "Reset_Btn":
			SetCount(_minCountCanBuy);
			// End:0xEE
			break;
		// End:0xA4
		case "Buy_Btn":
			DelegateOnClickBuy();
			// End:0xEE
			break;
		// End:0xCF
		case "MultiSell_Max_Button":
			SetCount(6056184808285929474);
			// End:0xEE
			break;
		// End:0xEB
		case "Cancel_Btn":
			DelegateOnCancel();
			// End:0xEE
			break;
	}
}

event OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	local string mainKey;

	mainKey = class'InputAPI'.static.GetKeyString(nKey);
	// End:0x36
	if("ESCAPE" == mainKey)
	{
		DelegateESCKey();
	}
}

function CheckZero()
{
	local string EditBoxString;

	EditBoxString = ItemCount_EditBox.GetString();
	if((Left(EditBoxString, 1) == "0") && Len(EditBoxString) > 1)
	{
		ItemCount_EditBox.SetString(Right(EditBoxString, Len(EditBoxString) - 1));
	}
}

function SetCount(INT64 Num)
{
	// End:0x1F
	if((DelegateGetCountCanBuy()) < Num)
	{
		DelegateOnOverInput();
	}
	Num = Min64(DelegateGetCountCanBuy(), Num);
	// End:0x6C
	if(Num != int64(ItemCount_EditBox.GetString()))
	{
		ItemCount_EditBox.SetString(string(Num));
	}
	DelegateOnItemCountEdited(Num);
	SetControlerBtns();
	SetBuyBtnTooltip();
}

function INT64 GetCount()
{
	return int64(ItemCount_EditBox.GetString());
}

function OnPriceEditBtnHandler()
{
	DelegateOnClickInput();
}

function OnMultiSell_Up_ButtonClick()
{
	SetCount(int64(ItemCount_EditBox.GetString()) + plusbasicunit);
}

function OnMultiSell_Down_ButtonClick()
{
	SetCount(int64(ItemCount_EditBox.GetString()) - plusbasicunit);
}

function SetBuyBtnTooltip()
{
	// End:0x2D
	if(Buy_Btn.m_pTargetWnd != none)
	{
		Buy_Btn.SetTooltipCustomType(DelegateGetBtnTooltip());
	}
}

function SetControlerBtns()
{
	local INT64 Count, canBuyCount;

	// End:0x81
	if(is_force_disable == true)
	{
		// End:0x2F
		if(MultiSell_Input_Button.m_pTargetWnd != none)
		{
			MultiSell_Input_Button.DisableWindow();
		}
		// End:0x52
		if(MultiSell_Max_Button.m_pTargetWnd != none)
		{
			MultiSell_Max_Button.DisableWindow();
		}
		MultiSell_Up_Button.DisableWindow();
		MultiSell_Down_Button.DisableWindow();
		ItemCount_EditBox.DisableWindow();
		return;
	}
	canBuyCount = DelegateGetCountCanBuy();
	Count = int64(ItemCount_EditBox.GetString());
	// End:0xFF
	if(Reset_Btn.m_pTargetWnd != none)
	{
		// End:0xF0
		if(Count != _minCountCanBuy && canBuyCount >= _minCountCanBuy)
		{
			Reset_Btn.EnableWindow();			
		}
		else
		{
			Reset_Btn.DisableWindow();
		}
	}
	// End:0x156
	if(MultiSell_Max_Button.m_pTargetWnd != none)
	{
		// End:0x147
		if((Count < canBuyCount) && canBuyCount >= _minCountCanBuy)
		{
			MultiSell_Max_Button.EnableWindow();			
		}
		else
		{
			MultiSell_Max_Button.DisableWindow();
		}
	}
	// End:0x178
	if(canBuyCount <= _minCountCanBuy)
	{
		ItemCount_EditBox.DisableWindow();		
	}
	else
	{
		// End:0x192
		if(! is_Editor_disable)
		{
			ItemCount_EditBox.EnableWindow();
		}
	}
	// End:0x1CC
	if(MultiSell_Input_Button.m_pTargetWnd != none)
	{
		// End:0x1BD
		if(canBuyCount <= _minCountCanBuy)
		{
			MultiSell_Input_Button.DisableWindow();			
		}
		else
		{
			MultiSell_Input_Button.EnableWindow();
		}
	}
	// End:0x1EE
	if(canBuyCount <= Count)
	{
		MultiSell_Up_Button.DisableWindow();		
	}
	else
	{
		MultiSell_Up_Button.EnableWindow();
	}
	// End:0x21F
	if(Count <= _minCountCanBuy)
	{
		MultiSell_Down_Button.DisableWindow();		
	}
	else
	{
		MultiSell_Down_Button.EnableWindow();
	}
	// End:0x273
	if(Buy_Btn.m_pTargetWnd != none)
	{
		// End:0x264
		if(Count >= _minCountCanBuy)
		{
			Buy_Btn.EnableWindow();			
		}
		else
		{
			Buy_Btn.DisableWindow();
		}
	}
}

function _SetPlusBasicUnit(INT64 Unit)
{
	plusbasicunit = Unit;
}

function _SetForceDisable(bool isForceDisable)
{
	is_force_disable = isForceDisable;
	SetControlerBtns();
}

function bool _GetForceDisable()
{
	return is_force_disable;	
}

function _SetEditBoxDisable(bool IsDisable)
{
	local INT64 canBuyCount;

	is_Editor_disable = IsDisable;
	canBuyCount = DelegateGetCountCanBuy();
	// End:0x55
	if(canBuyCount <= _minCountCanBuy || is_force_disable || is_Editor_disable)
	{
		ItemCount_EditBox.DisableWindow();		
	}
	else
	{
		ItemCount_EditBox.EnableWindow();
	}	
}

function bool _GetEditBoxDisable()
{
	return is_Editor_disable;	
}

function _SetEditBoxFontColor(Color Color)
{
	ItemCount_EditBox.SetFontColor(Color);
}

function _SetUseCaculator(bool bUse)
{
	bUseCalculator = bUse;
	// End:0x23
	if(MultiSell_Input_Button.m_pTargetWnd == none)
	{
		return;
	}
	// End:0x3E
	if(bUseCalculator)
	{
		MultiSell_Input_Button.ShowWindow();		
	}
	else
	{
		MultiSell_Input_Button.HideWindow();
	}
}

function _SetMinCountCanBuy(INT64 minCOunt)
{
	_minCountCanBuy = minCOunt;
}

defaultproperties
{
}
