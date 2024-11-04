class UIControlTextInput extends UICommonAPI;

var EditBoxHandle inputTextBox;
var TextBoxHandle defaultTextBox;
var TextureHandle enableTex;
var TextureHandle disableTex;
var TextureHandle edtiableTex;
var ButtonHandle clearBtn;
var int _max;
var string _defaultString;
var string _string;
var bool _bDisable;
var bool _bEdtiable;
var private bool bFocused;
var L2UITimerObject timerObject;

function string GetString()
{
	return inputTextBox.GetString();
}

function SetString(string Str, optional bool bFormatString)
{
	_string = Str;
	// End:0x2B
	if(bFormatString)
	{
		inputTextBox.SetFormatString(Str);		
	}
	else
	{
		inputTextBox.SetString(Str);
	}
	CheckDefaultString();
}

function AddEmojiIcon(int nEmojiIconIndex)
{
	inputTextBox.AddEmojiIcon(nEmojiIconIndex);
	_string = inputTextBox.GetString();
	CheckDefaultString();
}

function Clear()
{
	SetString("");
}

function SetHighLight(bool isHighlight)
{
	inputTextBox.SetHighLight(isHighlight);
}

function AllSelect()
{
	// End:0x27
	if(IsEdtiable())
	{
		inputTextBox.AllSelect();
		inputTextBox.SetFocus();
	}
}

function Focus()
{
	// End:0x18
	if(IsEdtiable())
	{
		inputTextBox.SetFocus();
	}
}

function bool IsEmpty()
{
	return inputTextBox.IsEmpty();
}

function SetDefaultString(string Str)
{
	defaultTextBox.SetText(Str);
	CheckDefaultString();
}

function SetMaxLength(int Max)
{
	inputTextBox.SetMaxLength(Max);
}

function SetDisable(bool bDisable)
{
	_bDisable = bDisable;
	// End:0x64
	if(bDisable)
	{
		disableTex.ShowWindow();
		enableTex.HideWindow();
		inputTextBox.ReleaseFocus();
		inputTextBox.DisableWindow();
		clearBtn.DisableWindow();		
	}
	else
	{
		disableTex.HideWindow();
		SetEdtiable(_bEdtiable);
	}
}

function SetEdtiable(bool bEdtiable)
{
	_bEdtiable = bEdtiable;
	// End:0x18
	if(_bDisable)
	{
		return;
	}
	// End:0x60
	if(bEdtiable)
	{
		inputTextBox.EnableWindow();
		enableTex.ShowWindow();
		edtiableTex.HideWindow();
		clearBtn.EnableWindow();		
	}
	else
	{
		enableTex.HideWindow();
		edtiableTex.ShowWindow();
		inputTextBox.ReleaseFocus();
		inputTextBox.DisableWindow();
		clearBtn.DisableWindow();
	}
}

function bool IsEdtiable()
{
	return _bEdtiable && ! _bDisable;
}

function UseClearBtn(bool bUse)
{
	local Rect wndRect;

	wndRect = m_hOwnerWnd.GetRect();

	// End:0x3A
	if(bUse)
	{
		clearBtn.ShowWindow();
		inputTextBox.SetWindowSize(wndRect.nWidth, wndRect.nHeight - 16);
	}
	else
	{
		clearBtn.HideWindow();
		inputTextBox.SetWindowSize(wndRect.nWidth, wndRect.nHeight);
	}
}

delegate DelegateOnChangeEdited(string Text)
{}

delegate DelegateOnCompleteEditBox(string Text)
{}

delegate DelegateESCKey()
{}

delegate DelegateOnClear()
{}

static function UIControlTextInput InitScript(WindowHandle wnd)
{
	local UIControlTextInput scr;

	wnd.SetScript("UIControlTextInput");
	scr = UIControlTextInput(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	inputTextBox = GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".inputTextBox");
	defaultTextBox = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".defaultTextBox");
	enableTex = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".enableTex");
	disableTex = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".disableTex");
	edtiableTex = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".edtiableTex");
	clearBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".clearBtn");
	_bEdtiable = false;
	SetDisable(false);
	m_hOwnerWnd.ShowWindow();
	timerObject = class'L2UITimer'.static.Inst()._AddNewTimerObject(100, -1);
	timerObject._DelegateOnTime = OnTimerTester;
}

function OnTimerTester(int Time)
{
	// End:0x5F
	if(m_hOwnerWnd.GetTopFrameWnd().IsShowWindow())
	{
		Debug("OnTimerTester" @ m_hOwnerWnd.GetTopFrameWnd().GetWindowName() @ string(inputTextBox.IsFocused()));
	}	
}

event OnChangeEditBox(string strID)
{
	switch(strID)
	{
		// End:0x31
		case "inputTextBox":
			DelegateOnChangeEdited(GetString());
			CheckDefaultString();
			// End:0x34
			break;
		// End:0xFFFF
		default:
			break;
	}
}

event OnCompleteEditBox(string strID)
{
	DelegateOnCompleteEditBox(GetString());
}

event OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	local string mainKey;

	mainKey = class'InputAPI'.static.GetKeyString(nKey);
	switch(mainKey)
	{
		// End:0x65
		case "ESCAPE":
			DelegateESCKey();
			// End:0x53
			if(GetString() != _string)
			{
				SetString(_string);
				return;
			}
			inputTextBox.ReleaseFocus();
			// End:0x68
			break;
		// End:0xFFFF
		default:
			break;
	}
}

event OnClickButton(string strID)
{
	// End:0x0D
	if(! IsEdtiable())
	{
		return;
	}
	Clear();
	inputTextBox.SetFocus();
	DelegateOnClear();
}

event OnSetFocus(WindowHandle a_WindowHandle, bool focused)
{
	// End:0x22
	if(focused)
	{
		m_hOwnerWnd.GetTopFrameWnd().BringToFront();
	}
	// End:0x3E
	if(a_WindowHandle == inputTextBox)
	{
		bFocused = focused;
	}
	CheckDefaultString();
}

private function CheckDefaultString()
{
	if(bFocused)
	{
		defaultTextBox.HideWindow();		
	}
	else if((IsEmpty()) == true)
	{
		defaultTextBox.ShowWindow();		
	}
	else
	{
		defaultTextBox.HideWindow();
	}
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();	
}

function _Show()
{
	m_hOwnerWnd.ShowWindow();	
}

defaultproperties
{
}
