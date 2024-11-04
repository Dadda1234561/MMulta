class UIControlGroupButtonAssets extends UICommonAPI;

const TimeID = 1234567;

var int delayButtonTime;
var bool bOnDelayTime;
var string m_WindowName;
var WindowHandle Me;
var UIControlGroupButtons groupButtons;
var string textureNormal;
var string textureDown;
var string textureOver;
var bool bUseLongButtonTextTooltip;
var array<TextureHandle> dotTextureGroup;

delegate DelegateOnDelayTime(bool bOnDelayTime)
{
}

static function UIControlGroupButtonAssets _InitScript(WindowHandle wnd)
{
	local UIControlGroupButtonAssets scr;

	wnd.SetScript("UIControlGroupButtonAssets");
	scr = UIControlGroupButtonAssets(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	_SetWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
}

function _SetWindow(string WindowName)
{
	m_WindowName = WindowName;
	Me = GetWindowHandle(m_WindowName);
	groupButtons = new class'UIControlGroupButtons';
}

function _SetStartInfo(optional string pTextureNormal, optional string pTextureDown, optional string pTextureOver, optional bool pBUseLongButtonTextTooltip, optional bool bDoNotUseAutoButtonHeight)
{
	local int i;
	local Rect R;

	// End:0x42
	if(pTextureNormal == "")
	{
		textureNormal = "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton";		
	}
	else
	{
		textureNormal = pTextureNormal;
	}
	// End:0x94
	if(pTextureDown == "")
	{
		textureDown = "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Down";		
	}
	else
	{
		textureDown = pTextureDown;
	}
	// End:0xE6
	if(pTextureOver == "")
	{
		textureOver = "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Over";		
	}
	else
	{
		textureOver = pTextureOver;
	}
	bUseLongButtonTextTooltip = pBUseLongButtonTextTooltip;
	groupButtons._SetStartInfo(textureNormal, textureDown, textureOver, bUseLongButtonTextTooltip);

	// End:0x1AE [Loop If]
	for(i = 0; GetButtonHandle(m_WindowName $ ".__selectButton" $ i).m_pTargetWnd != none; i++)
	{
		groupButtons._addButtonController(GetButtonHandle(m_WindowName $ ".__selectButton" $ string(i)));
		GetTextureHandle(m_WindowName $ ".__Condition_tex" $ string(i)).HideWindow();
		dotTextureGroup[dotTextureGroup.Length] = GetTextureHandle(m_WindowName $ ".__Condition_tex" $ string(i));
	}
	// End:0x1E7
	if(! bDoNotUseAutoButtonHeight)
	{
		R = Me.GetRect();
		groupButtons._setButtonHeight(R.nHeight);
	}
	GetTextureHandle(m_WindowName $ ".disable_tex").HideWindow();
}

function UIControlGroupButtons _GetGroupButtonsInstance()
{
	return groupButtons;
}

function _setDelayTime(int DelayTime)
{
	delayButtonTime = DelayTime;
	bOnDelayTime = false;
}

function _clearDelayTime()
{
	delayButtonTime = 0;
	bOnDelayTime = false;
}

function OnTimer(int TimerID)
{
	// End:0x39
	if(TimerID == TimeID)
	{
		Me.KillTimer(TimeID);
		_SetEnable();
		DelegateOnDelayTime(bOnDelayTime);
	}
}

event OnClickButton(string Name)
{
	// End:0x6D
	if(Left(Name, Len("__selectButton")) == "__selectButton")
	{
		// End:0x6D
		if(groupButtons._getSelectButtonName() != Name)
		{
			// End:0x6D
			if(bOnDelayTime == false)
			{
				groupButtons._selectButton(Name);
				_tryDelayClick();
			}
		}
	}
}

function _tryDelayClick()
{
	// End:0x4E
	if(delayButtonTime > 0)
	{
		Me.KillTimer(TimeID);
		Me.SetTimer(TimeID, delayButtonTime);
		_SetDisable();
		DelegateOnDelayTime(bOnDelayTime);
	}
}

function _SetDisable()
{
	GetTextureHandle(m_WindowName $ ".disable_tex").SetWindowSize(Me.GetRect().nWidth, Me.GetRect().nHeight);
	GetTextureHandle(m_WindowName $ ".disable_tex").ShowWindow();
	bOnDelayTime = true;
}

function _SetEnable()
{
	GetTextureHandle(m_WindowName $ ".disable_tex").HideWindow();
	bOnDelayTime = false;
}

function _DotTextureAllShow(bool bShow)
{
	local int i;

	// End:0x57 [Loop If]
	for(i = 0; i < dotTextureGroup.Length; i++)
	{
		// End:0x38
		if(bShow)
		{
			dotTextureGroup[i].ShowWindow();
			// [Explicit Continue]
			continue;
		}
		dotTextureGroup[i].HideWindow();
	}	
}

function _DotTextureShow(int buttonIndex, bool bShow, optional int dotX, optional int dotY, optional string alignXStr)
{
	// End:0xB6
	if(dotTextureGroup.Length > buttonIndex)
	{
		// End:0xA1
		if(bShow)
		{
			// End:0x2F
			if(dotX == 0)
			{
				dotX = -4;
			}
			// End:0x42
			if(dotY == 0)
			{
				dotY = 4;
			}
			// End:0x5B
			if(alignXStr == "")
			{
				alignXStr = "right";
			}
			groupButtons._setTextureLoc(buttonIndex, dotTextureGroup[buttonIndex], dotX, dotY, alignXStr);
			dotTextureGroup[buttonIndex].ShowWindow();			
		}
		else
		{
			dotTextureGroup[buttonIndex].HideWindow();
		}
	}	
}

function _DotTextureColorModify(int buttonIndex, Color dotColor)
{
	// End:0x2A
	if(dotTextureGroup.Length > buttonIndex)
	{
		dotTextureGroup[buttonIndex].SetColorModify(dotColor);
	}	
}

function _DotTextureChangeTexture(int buttonIndex, string texPath)
{
	// End:0x2A
	if(dotTextureGroup.Length > buttonIndex)
	{
		dotTextureGroup[buttonIndex].SetTexture(texPath);
	}	
}

defaultproperties
{
}
