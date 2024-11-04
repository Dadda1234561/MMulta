class MinimizeManager extends UICommonAPI;

const TweenTime = 700;

var private array<string> ownerWwindowNames;
var private array<string> ownerWindowNamesShowByOwner;

static function MinimizeManager Inst()
{
	return MinimizeManager(GetScript("MinimizeManager"));	
}

private function SetListShowByOwner()
{
	_AddOwnerWindowNameShowByOwer("QuestProgressWnd");	
}

event OnLoad()
{
	SetWndNameList();	
}

event OnShow()
{
	m_hOwnerWnd.EnableTick();	
}

event OnHide()
{
	HideAlarms();	
}

event OnTick()
{
	SetListShowByOwner();
	ApplyMinSizes();
	m_hOwnerWnd.DisableTick();	
}

event OnTimer(int TimerID)
{
	m_hOwnerWnd.KillTimer(TimerID);
	GetWindowHandle(ownerWwindowNames[TimerID] $ "Min").HideWindow();	
}

event OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		// End:0x28
		case "MinimizeWindow":
			_MinimizeWindow(param);
			// End:0x2B
			break;
	}	
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	_MaximizeWindow(UtilDelMin(a_ButtonHandle.GetParentWindowHandle().GetParentWindowName()));	
}

function _MinimizeWindow(string wName, optional bool bImmediately)
{
	local int i;
	local float TweenTime;
	local array<WindowHandle> childLists;

	// End:0x89
	if(wName == "QuestProgressWnd")
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ wName $ "Min").SetAnchor("QuestProgressWnd.btnMinimize", "CenterCenter", "CenterCenter", 0, 0);
	}
	SetINIInt(wName, "m", 1, "WindowsInfo.ini");
	class'UIAPI_WINDOW'.static.HideWindow(wName);
	class'UIAPI_WINDOW'.static.ShowWindow(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ wName $ "Min");
	// End:0x111
	if(! bImmediately)
	{
		Pull(wName);
		TweenTime = 0.0f;		
	}
	else
	{
		TweenTime = TweenTime / 1000;
	}
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ wName $ "Min").GetChildWindowList(childLists);
	GetScript(wName).OnCallUCFunction(m_hOwnerWnd.m_WindowNameWithFullPath, "onMin");

	// End:0x1C2 [Loop If]
	for(i = 0; i < childLists.Length; i++)
	{
		childLists[i].SetAlpha(255, TweenTime);
	}	
}

function _MaximizeWindow(string wName)
{
	local int i;
	local array<WindowHandle> childLists;

	SetINIInt(wName, "m", 0, "WindowsInfo.ini");
	_HideAlarm(wName);
	class'UIAPI_WINDOW'.static.ShowWindow(wName);
	Push(wName);
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ wName $ "Min").GetChildWindowList(childLists);
	GetScript(wName).OnCallUCFunction(m_hOwnerWnd.m_WindowNameWithFullPath, "onMax");

	// End:0xEF [Loop If]
	for(i = 0; i < childLists.Length; i++)
	{
		childLists[i].SetAlpha(0, TweenTime / 1000);
	}	
}

function _ShowWindow(string wName)
{
	// End:0x1D
	if(_IsMin(wName))
	{
		_MinimizeWindow(wName, true);		
	}
	else
	{
		_MaximizeWindow(wName);
	}	
}

function _HideWindow(string wName)
{
	class'UIAPI_WINDOW'.static.HideWindow(wName);
	class'UIAPI_WINDOW'.static.HideWindow(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ wName $ "Min");
	_HideAlarm(wName);	
}

function _ShowAlarm(string wName)
{
	class'UIAPI_WINDOW'.static.ShowWindow(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ wName $ "Min.MinContents.texAlarm");	
}

function _HideAlarm(string wName)
{
	class'UIAPI_WINDOW'.static.HideWindow(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ wName $ "Min.MinContents.texAlarm");	
}

function bool _IsMin(string wName)
{
	local int minState;

	// End:0x30
	if(GetINIInt(wName, "m", minState, "WindowsInfo.ini"))
	{
		return minState == 1;
	}
	return false;	
}

function _AddOwnerWindowNameShowByOwer(string wName)
{
	ownerWindowNamesShowByOwner[ownerWindowNamesShowByOwner.Length] = wName;	
}

function _SetToolTIp(string wName, string ToolTip)
{
	Debug("_SetToolTIp : " @ wName @ ToolTip @ m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ wName $ "Min.MinContents.MinBtn");
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ wName $ "Min.MinContents.MinBtn").SetTooltipCustomType(MakeTooltipSimpleText(ToolTip));	
}

private function HideAlarms()
{
	local int i;

	// End:0x32 [Loop If]
	for(i = 0; i < ownerWwindowNames.Length; i++)
	{
		_HideAlarm(ownerWwindowNames[i]);
	}	
}

private function int IndexAtOwnerWindowNamesShowByOwner(string wName)
{
	local int i;

	// End:0x3C [Loop If]
	for(i = 0; i < ownerWindowNamesShowByOwner.Length; i++)
	{
		// End:0x32
		if(ownerWindowNamesShowByOwner[i] == wName)
		{
			return i;
		}
	}
	return -1;	
}

private function SetWndNameList()
{
	local int i;
	local array<WindowHandle> wndLists;

	m_hOwnerWnd.GetChildWindowList(wndLists);

	// End:0x80 [Loop If]
	for(i = 0; i < wndLists.Length; i++)
	{
		// End:0x76
		if(Right(wndLists[i].GetWindowName(), 3) == "Min")
		{
			ownerWwindowNames[ownerWwindowNames.Length] = UtilDelMin(wndLists[i].GetWindowName());
		}
	}	
}

private function ApplyMinSizes()
{
	local int i;

	// End:0x62 [Loop If]
	for(i = 0; i < ownerWwindowNames.Length; i++)
	{
		// End:0x58
		if(_IsMin(ownerWwindowNames[i]))
		{
			// End:0x58
			if((IndexAtOwnerWindowNamesShowByOwner(ownerWwindowNames[i])) == -1)
			{
				_MinimizeWindow(ownerWwindowNames[i], true);
			}
		}
	}	
}

private function Pull(string wName)
{
	local int X, Y;
	local Rect btnMinRect, minRect;
	local string btnMinName;
	local WindowHandle wBtnMin;
	local L2UITween.TweenObject tObject;

	m_hOwnerWnd.KillTimer(GetIndexByName(wName));
	GetClientCursorPos(X, Y);
	btnMinName = m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ wName $ "Min";
	class'L2UITween'.static.Inst().StopTween(btnMinName, 0);
	wBtnMin = GetWindowHandle(btnMinName $ ".MinContents");
	minRect = GetWindowHandle(btnMinName).GetRect();
	btnMinRect = wBtnMin.GetRect();
	wBtnMin.MoveC((minRect.nWidth - btnMinRect.nWidth) / 2, (minRect.nHeight - btnMinRect.nHeight) / 2);
	wBtnMin.Move(((X - (btnMinRect.nWidth / 2)) - minRect.nX) / 50, ((Y - (btnMinRect.nHeight / 2)) - minRect.nY) / 50);
	btnMinRect = wBtnMin.GetRect();
	wBtnMin.SetAlpha(0);
	tObject.Alpha = 255.0f;
	tObject.Duration = 300.0f;
	tObject.ease = class'L2UITween'.static.Inst().easeType.OUT_BOUNCE;
	tObject.MoveX = float((minRect.nX - btnMinRect.nX) + ((minRect.nWidth - btnMinRect.nWidth) / 2));
	tObject.MoveY = float((minRect.nY - btnMinRect.nY) + ((minRect.nHeight - btnMinRect.nHeight) / 2));
	tObject.Target = wBtnMin;
	tObject.Owner = btnMinName;
	class'L2UITween'.static.Inst().AddTweenObject(tObject);	
}

private function Push(string wName)
{
	local Rect btnMinRect, targetRect;
	local string btnMinName;
	local WindowHandle wBtnMin, tWnd;
	local L2UITween.TweenObject tObject;

	btnMinName = m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ wName $ "Min";
	class'L2UITween'.static.Inst().StopTween(btnMinName, 0);
	wBtnMin = GetWindowHandle(btnMinName $ ".MinContents");
	tWnd = GetWindowHandle(wName);
	// End:0x133
	if(tWnd.m_pTargetWnd == none)
	{
		GetINIInt(wName, "x", targetRect.nX, "WindowsInfo.ini");
		GetINIInt(wName, "y", targetRect.nY, "WindowsInfo.ini");
		GetINIInt(wName, "w", targetRect.nWidth, "WindowsInfo.ini");
		GetINIInt(wName, "h", targetRect.nHeight, "WindowsInfo.ini");		
	}
	else
	{
		targetRect = tWnd.GetRect();
	}
	btnMinRect = wBtnMin.GetRect();
	tObject.Alpha = -255.0f;
	tObject.Duration = 300.0f;
	tObject.ease = class'L2UITween'.static.Inst().easeType.OUT_STRONG;
	tObject.MoveX = float((targetRect.nX - btnMinRect.nX) + ((targetRect.nWidth - btnMinRect.nWidth) / 2)) / float(20);
	tObject.MoveY = float((targetRect.nY - btnMinRect.nY) + ((targetRect.nHeight - btnMinRect.nHeight) / 2)) / float(20);
	tObject.Target = wBtnMin;
	tObject.Owner = btnMinName;
	class'L2UITween'.static.Inst().AddTweenObject(tObject);
	m_hOwnerWnd.SetTimer(GetIndexByName(wName), TweenTime);	
}

private function string UtilDelMin(string wName)
{
	return Left(wName, Len(wName) - 3);	
}

private function int GetIndexByName(string wName)
{
	local int i;

	// End:0x3C [Loop If]
	for(i = 0; i < ownerWwindowNames.Length; i++)
	{
		// End:0x32
		if(ownerWwindowNames[i] == wName)
		{
			return i;
		}
	}
	return -1;	
}

defaultproperties
{
}
