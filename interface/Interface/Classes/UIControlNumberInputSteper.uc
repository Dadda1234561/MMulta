class UIControlNumberInputSteper extends UIConstants;

var ButtonHandle plus1Button;
var ButtonHandle plus5Button;
var ButtonHandle plus10Button;
var ButtonHandle UpButton;
var ButtonHandle DownButton;
var EditBoxHandle ItemCount_EditBox;
var int maxEditNum;
var int minEditNum;
var int plus1ButtonValue;
var int plus5ButtonValue;
var int plus10ButtonValue;
var bool _bDisable;

delegate DelegateOnButtonClick(string strBtn, int addValue)
{}

delegate DelegateOnChangeEditBox(UIControlNumberInputSteper mySelf)
{}

delegate DelegateESCKey()
{}

static function UIControlNumberInputSteper InitScript(WindowHandle wnd)
{
	local UIControlNumberInputSteper scr;

	wnd.SetScript("UIControlNumberInputSteper");
	scr = UIControlNumberInputSteper(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	Init();
}

function Init()
{
	plus1Button = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".plus1Button");
	plus5Button = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".plus5Button");
	plus10Button = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".plus10Button");
	UpButton = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".upButton");
	DownButton = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".downButton");
	ItemCount_EditBox = GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemCount_EditBox");
	ItemCount_EditBox.DisableWindow();
	_setAddButtons(1, 5, 10);
}

event OnClickButton(string strBtn)
{
	local int addValue;

	switch(strBtn)
	{
		// End:0x30
		case "plus1Button":
			calculationEdit(plus1ButtonValue);
			addValue = plus1ButtonValue;
			// End:0xCC
			break;
		// End:0x59
		case "plus5Button":
			calculationEdit(plus5ButtonValue);
			addValue = plus5ButtonValue;
			// End:0xCC
			break;
		// End:0x83
		case "plus10Button":
			calculationEdit(plus10ButtonValue);
			addValue = plus10ButtonValue;
			// End:0xCC
			break;
		// End:0xAB
		case "downButton":
			calculationEdit(-1);
			addValue = -1;
			// End:0xCC
			break;
		// End:0xC9
		case "upButton":
			calculationEdit(1);
			addValue = 1;
			// End:0xCC
			break;
		// End:0xFFFF
		default:
			break;
	}
	DelegateOnButtonClick(strBtn, addValue);
}

function calculationEdit(int addNum)
{
	local int sum;

	sum = Min(maxEditNum, Max(minEditNum, int(ItemCount_EditBox.GetString()) + addNum));
	ItemCount_EditBox.SetString(string(sum));
	checkMinMax();
}

event OnCompleteEditBox(string strID)
{
	checkMinMax();
}

event OnChangeEditBox(string strID)
{
	DelegateOnChangeEditBox(self);
	checkButtonState();
}

function checkMinMax()
{
	local int editNum;

	editNum = int(ItemCount_EditBox.GetString());
	// End:0x3F
	if(maxEditNum < editNum)
	{
		ItemCount_EditBox.SetString(string(maxEditNum));		
	}
	else
	{
		// End:0x7C
		if((minEditNum > editNum) || ItemCount_EditBox.GetString() == "")
		{
			ItemCount_EditBox.SetString(string(minEditNum));
		}
	}
	// End:0xC3
	if(Len(ItemCount_EditBox.GetString()) > 1)
	{
		// End:0xC3
		if(Left(ItemCount_EditBox.GetString(), 1) == "0")
		{
			ItemCount_EditBox.SetString(string(editNum));
		}
	}
}

function checkButtonState()
{
	local int buttonValue;

	buttonValue = int(ItemCount_EditBox.GetString());
	// End:0x38
	if(buttonValue <= minEditNum)
	{
		DownButton.DisableWindow();		
	}
	else
	{
		DownButton.EnableWindow();
	}
	// End:0x68
	if(buttonValue >= maxEditNum)
	{
		UpButton.DisableWindow();		
	}
	else
	{
		UpButton.EnableWindow();
	}
	// End:0xC9
	if(plus1ButtonValue > 0)
	{
		// End:0xB7
		if(buttonValue >= maxEditNum)
		{
			// End:0xB4
			if(plus1Button.m_pTargetWnd != none)
			{
				plus1Button.DisableWindow();
			}			
		}
		else
		{
			plus1Button.EnableWindow();
		}		
	}
	else
	{
		// End:0xEA
		if(buttonValue <= minEditNum)
		{
			plus1Button.DisableWindow();			
		}
		else
		{
			plus1Button.EnableWindow();
		}
	}
	// End:0x137
	if(plus5ButtonValue > 0)
	{
		// End:0x125
		if(buttonValue >= maxEditNum)
		{
			plus5Button.DisableWindow();			
		}
		else
		{
			plus5Button.EnableWindow();
		}		
	}
	else
	{
		// End:0x158
		if(buttonValue <= minEditNum)
		{
			plus5Button.DisableWindow();			
		}
		else
		{
			plus5Button.EnableWindow();
		}
	}
	// End:0x1A5
	if(plus10ButtonValue > 0)
	{
		// End:0x193
		if(buttonValue >= maxEditNum)
		{
			plus10Button.DisableWindow();			
		}
		else
		{
			plus10Button.EnableWindow();
		}		
	}
	else
	{
		// End:0x1C6
		if(buttonValue <= minEditNum)
		{
			plus10Button.DisableWindow();			
		}
		else
		{
			plus10Button.EnableWindow();
		}
	}
}

event OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	local string mainKey;

	mainKey = class'InputAPI'.static.GetKeyString(nKey);
	switch(mainKey)
	{
		case "ESCAPE":
			DelegateESCKey();
			break;
		case "0":
		case "1":
		case "2":
		case "3":
		case "4":
		case "5":
		case "6":
		case "7":
		case "8":
		case "9":
		case "NUMPAD0":
		case "NUMPAD1":
		case "NUMPAD2":
		case "NUMPAD3":
		case "NUMPAD4":
		case "NUMPAD5":
		case "NUMPAD6":
		case "NUMPAD7":
		case "NUMPAD8":
		case "NUMPAD9":
			checkMinMax();
			break;
	}
}

function _setMaxLength(int nMax)
{
	ItemCount_EditBox.SetMaxLength(nMax);
}

function _setRangeMinMaxNum(int minNum, int maxNum)
{
	local int Value;

	Value = int(ItemCount_EditBox.GetString());
	minEditNum = minNum;
	maxEditNum = maxNum;
	_setMaxLength(Len(string(maxNum)));
	ItemCount_EditBox.SetString(string(Min(Value, maxNum)));
	checkButtonState();
}

function _setEditNum(int Num)
{
	ItemCount_EditBox.SetString(string(Num));
	checkMinMax();
	checkButtonState();
}

function int _getEditNum()
{
	local int Value;

	Value = int(ItemCount_EditBox.GetString());
	return Value;
}

function _setAddButtons(int plus1, int plus5, int plus10)
{
	plus1ButtonValue = plus1;
	plus5ButtonValue = plus5;
	plus10ButtonValue = plus10;
	// End:0x4A
	if(plus1 > 0)
	{
		plus1Button.SetNameText("+" $ string(plus1));		
	}
	else
	{
		plus1Button.SetNameText(string(plus1));
	}
	// End:0x89
	if(plus5 > 0)
	{
		plus5Button.SetNameText("+" $ string(plus5));		
	}
	else
	{
		plus5Button.SetNameText(string(plus5));
	}
	// End:0xC8
	if(plus10 > 0)
	{
		plus10Button.SetNameText("+" $ string(plus10));		
	}
	else
	{
		plus10Button.SetNameText(string(plus10));
	}
}

function _SetDisable(bool bDisable)
{
	_bDisable = bDisable;
	// End:0x82
	if(bDisable)
	{
		plus1Button.DisableWindow();
		plus5Button.DisableWindow();
		plus10Button.DisableWindow();
		UpButton.DisableWindow();
		DownButton.DisableWindow();
		ItemCount_EditBox.ReleaseFocus();
		ItemCount_EditBox.DisableWindow();		
	}
	else
	{
		checkButtonState();
		ItemCount_EditBox.EnableWindow();
	}
}

defaultproperties
{
}
