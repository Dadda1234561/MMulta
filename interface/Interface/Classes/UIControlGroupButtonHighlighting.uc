class UIControlGroupButtonHighlighting extends UIConstants;

var string btnTextureNormal;
var string btnTextureOver;
var string btnTextureDown;
var ButtonHandle groupBaseBtn;
var array<WindowHandle> windows;
var bool disalbed;

delegate DelegateOnButtonClick(string strBtn)
{
}

delegate DelegateOnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
}

delegate DelegateOnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
}

static function UIControlGroupButtonHighlighting InitScript(WindowHandle wnd)
{
	local UIControlGroupButtonHighlighting scr;

	wnd.SetScript("UIControlGroupButtonHighlighting");
	scr = UIControlGroupButtonHighlighting(wnd.GetScript());
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
	groupBaseBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".GroupBaseBtn");
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	// End:0x0B
	if(disalbed)
	{
		return;
	}
	// End:0x59
	if(a_WindowHandle.GetWindowName() != groupBaseBtn.GetWindowName())
	{
		// End:0x59
		if(! IsKeyDown(IK_LeftMouse))
		{
			groupBaseBtn.SetTexture(btnTextureOver, btnTextureDown, btnTextureNormal);
		}
	}
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	// End:0x0B
	if(disalbed)
	{
		return;
	}
	// End:0x36
	if(! IsKeyDown(IK_LeftMouse))
	{
		groupBaseBtn.SetTexture(btnTextureNormal, btnTextureDown, btnTextureOver);
	}
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	// End:0x0B
	if(disalbed)
	{
		return;
	}
	// End:0x1F
	if(groupBaseBtn.IsMouseOver())
	{
		return;
	}
	groupBaseBtn.SetTexture(btnTextureDown, btnTextureDown, btnTextureNormal);
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	// End:0x0B
	if(disalbed)
	{
		return;
	}
	// End:0x3E
	if(groupBaseBtn.IsMouseOver())
	{
		groupBaseBtn.SetTexture(btnTextureNormal, btnTextureDown, btnTextureOver);		
	}
	else
	{
		// End:0x72
		if(_IsOver(X, Y))
		{
			groupBaseBtn.SetTexture(btnTextureOver, btnTextureDown, btnTextureNormal);			
		}
		else
		{
			groupBaseBtn.SetTexture(btnTextureNormal, btnTextureDown, btnTextureOver);
		}
	}
	DelegateOnLButtonUp(a_WindowHandle, X, Y);
}

event OnClickButton(string strBtn)
{
	// End:0x0B
	if(disalbed)
	{
		return;
	}
	DelegateOnButtonClick(strBtn);
}

event OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	DelegateOnSelectItemWithHandle(a_hItemWindow, a_Index);
}

function _SetGroupBaseButton(ButtonHandle baseBtn)
{
	groupBaseBtn = baseBtn;
}

function _AddWindow(WindowHandle childBtn)
{
	windows[windows.Length] = childBtn;
}

function _SetBtnTexture(string Normal, optional string Over, optional string Down)
{
	btnTextureNormal = Normal;
	btnTextureOver = Over;
	btnTextureDown = Down;
}

function bool _IsOver(int X, int Y)
{
	local int i;

	// End:0x14
	if(groupBaseBtn.IsMouseOver())
	{
		return true;
	}

	// End:0x55 [Loop If]
	for(i = 0; i < windows.Length; i++)
	{
		// End:0x4B
		if(IsOverWnd(windows[i], X, Y))
		{
			return true;
		}
	}
	return false;
}

function _SetDisable()
{
	disalbed = true;
	groupBaseBtn.SetTexture(btnTextureNormal, btnTextureDown, btnTextureOver);
}

function _SetEnable()
{
	disalbed = false;
}

function bool IsOverWnd(WindowHandle wnd, int X, int Y)
{
	local Rect wndRect;

	wndRect = wnd.GetRect();
	// End:0x2B
	if(X < wndRect.nX)
	{
		return false;
	}
	// End:0x41
	if(Y < wndRect.nY)
	{
		return false;
	}
	// End:0x63
	if(X > (wndRect.nX + wndRect.nWidth))
	{
		return false;
	}
	// End:0x85
	if(Y > (wndRect.nY + wndRect.nHeight))
	{
		return false;
	}
	return true;
}

defaultproperties
{
}
