class OnscreenEffectViewPortWnd extends UICommonAPI;

var WindowHandle Me;
var EffectViewportWndHandle EffectViewport;
var TextBoxHandle ScreenTextBox;
var TextBoxHandle ScreenSubTextBox;
var ItemWindowHandle itemWnd;
var TextureHandle Texture1;
var string wndname;
var private L2UITimerObject timerHide;
var L2UITween l2UITweenScript;

static function OnscreenEffectViewPortWnd Inst()
{
	return OnscreenEffectViewPortWnd(GetScript("OnscreenEffectViewPortWnd"));
}

event OnLoad()
{
	Initialize();
}

function Initialize()
{
	wndname = "OnscreenEffectViewPortWnd";
	Me = GetWindowHandle(wndname);
	EffectViewport = GetEffectViewportWndHandle(wndname $ ".EffectViewport");
	ScreenTextBox = GetTextBoxHandle(wndname $ ".ScreenTextBox");
	ScreenSubTextBox = GetTextBoxHandle(wndname $ ".ScreenSubTextBox");
	itemWnd = GetItemWindowHandle(wndname $ ".ItemWnd");
	Texture1 = GetTextureHandle(wndname $ ".texture1");
	l2UITweenScript = L2UITween(GetScript("l2UITween"));
	InitTimers();
}

function InitTimers()
{
	timerHide = class'L2UITimer'.static.Inst()._AddNewTimerObject();
	timerHide._DelegateOnStart = OnTimerHideStart;
	timerHide._DelegateOnEnd = OnTimerHideEnd;
}

function _playEffectView(float fScale, float fCameraDistance, string effetPath, optional int nPitch, optional int nYaw, optional int X, optional int Y, optional int Z, optional int nMSec, optional int nMSecFadeOut)
{
	local Vector offset;

	offset.X = float(X);
	offset.Y = float(Y);
	offset.Z = float(Z);
	timerHide._Stop();
	Me.ShowWindow();
	Me.SetAlpha(255);
	ScreenTextBox.HideWindow();
	ScreenTextBox.SetText("");
	Texture1.HideWindow();
	Texture1.ClearAnchor();
	itemWnd.HideWindow();
	itemWnd.Clear();
	GetEffectViewportWndHandle(wndname $ ".EffectViewport").ShowWindow();
	GetEffectViewportWndHandle(wndname $ ".EffectViewport").SpawnEffect("");
	GetEffectViewportWndHandle(wndname $ ".EffectViewport").SetScale(fScale);
	GetEffectViewportWndHandle(wndname $ ".EffectViewport").SetCameraPitch(nPitch);
	GetEffectViewportWndHandle(wndname $ ".EffectViewport").SetCameraYaw(nYaw);
	GetEffectViewportWndHandle(wndname $ ".EffectViewport").SetCameraDistance(fCameraDistance);
	GetEffectViewportWndHandle(wndname $ ".EffectViewport").SetOffset(offset);
	GetEffectViewportWndHandle(wndname $ ".EffectViewport").SpawnEffect(effetPath);
	// End:0x263
	if(nMSec != 0)
	{
		timerHide._delay = nMSec;
		timerHide._time = nMSecFadeOut;
		timerHide._Play();
	}
}

function _playEffectViewWithText(float fScale, float fCameraDistance, string effetPath, optional int nPitch, optional int nYaw, optional int X, optional int Y, optional int Z, optional int nMSec, optional int nMSecFadeOut, optional string Text, optional Color TextColor, optional ItemInfo Info, optional int motionType, optional bool showItemName)
{
	local int itemNameType;
	local Color itemNameColor;

	_playEffectView(fScale, fCameraDistance, effetPath, nPitch, nYaw, X, Y, Z, nMSec, nMSecFadeOut);
	ScreenTextBox.ShowWindow();
	ScreenTextBox.SetText(Text);
	ScreenTextBox.SetTextColor(TextColor);
	// End:0xA7
	if(Info.Id.ClassID > 0)
	{
		itemWnd.ShowWindow();
		itemWnd.AddItem(Info);
		if(showItemName == true)
		{
			ScreenSubTextBox.SetText(Info.Name);
			itemNameType = class'UIDATA_ITEM'.static.GetItemNameClass(Info.Id);
			switch(itemNameType)
			{
				// End:0x10D
				case 0:
					itemNameColor = GetColor(137, 137, 137, 255);
					break;
				// End:0x128
				case 1:
					itemNameColor = GetColor(230, 230, 230, 255);
					break;
				case 2:
					itemNameColor = GetColor(255, 251, 4, 255);
					break;
				case 3:
					itemNameColor = GetColor(240, 68, 68, 255);
					break;
				case 4:
					itemNameColor = GetColor(33, 164, 255, 255);
					break;
				// End:0x197
				case 5:
					itemNameColor = GetColor(255, 0, 255, 255);
					break;
			}
			ScreenSubTextBox.SetTextColor(itemNameColor);
		}
	}
	ScreenTextBox.SetAnchor("OnscreenEffectViewPortWnd", "TopCenter", "", 0, 450);
	l2UITweenScript.StopTween(wndname, 1);
	l2UITweenScript.StopTween(wndname, 2);
	l2UITweenScript.StopTween(wndname, 3);
	l2UITweenScript.StopTween(wndname, 4);
	switch(motionType)
	{
		// End:0x2E3
		case 1:
			ScreenTextBox.ClearAnchor();
			l2UITweenScript.Add("OnscreenEffectViewPortWnd.ScreenTextBox", wndname, 1, 1, 1.0f, 0.0f, -300.0f, 0.0f, 0.0f, 0.0f, 0.0f);
			l2UITweenScript.Add("OnscreenEffectViewPortWnd.ScreenTextBox", wndname, 2, 1, 1000.0f, 0.0f, 300.0f, 0.0f, 0.0f, 0.0f, 1.0f);
			l2UITweenScript.Add("OnscreenEffectViewPortWnd.ScreenTextBox", wndname, 3, 1, 2000.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1001.0f);
			l2UITweenScript.Add("OnscreenEffectViewPortWnd.ScreenTextBox", wndname, 4, 1, 1000.0f, 0.0f, 250.0f, 0.0f, 0.0f, 0.0f, 3001.0f);
			// End:0x49E
			break;
		// End:0x3BF
		case 2:
			ScreenTextBox.ClearAnchor();
			l2UITweenScript.Add("OnscreenEffectViewPortWnd.ScreenTextBox", wndname, 1, 1, 1.0f, 0.0f, 0.0f, 100.0f, 0.0f, 0.0f, 0.0f);
			l2UITweenScript.Add("OnscreenEffectViewPortWnd.ScreenTextBox", wndname, 2, 1, 1000.0f, 0.0f, 0.0f, -100.0f, 0.0f, 0.0f, 1.0f);
			// End:0x49E
			break;
		// End:0x49B
		case 3:
			ScreenTextBox.ClearAnchor();
			l2UITweenScript.Add("OnscreenEffectViewPortWnd.ScreenTextBox", wndname, 1, 1, 1.0f, 0.0f, 0.0f, -100.0f, 0.0f, 0.0f, 0.0f);
			l2UITweenScript.Add("OnscreenEffectViewPortWnd.ScreenTextBox", wndname, 2, 1, 1000.0f, 0.0f, 0.0f, 100.0f, 0.0f, 0.0f, 1.0f);
			// End:0x49E
			break;
	}
}

function _playEffectViewWithText_Texture(TextureStruct TS, float fScale, float fCameraDistance, string effetPath, optional int nPitch, optional int nYaw, optional int X, optional int Y, optional int Z, optional int nMSec, optional int nMSecFadeOut, optional string Text, optional Color TextColor, optional ItemInfo Info, optional int motionType)
{
	_playEffectViewWithText(fScale, fCameraDistance, effetPath, nPitch, nYaw, X, Y, Z, nMSec, nMSecFadeOut, Text, TextColor, Info, motionType);
	Texture1.ShowWindow();
	Texture1.SetTexture(TS.texturePath);
	Texture1.SetAnchor(TS.AnchorWindowName, TS.RelativePoint, TS.AnchorPoint, TS.textureOffsetX, TS.textureOffsetY);
	Texture1.SetWindowSize(TS.textureW, TS.textureH);
}

function _hideEffectView()
{
	Me.HideWindow();
	Me.SetAlpha(255);
	GetEffectViewportWndHandle(wndname $ ".EffectViewport").HideWindow();
	GetEffectViewportWndHandle(wndname $ ".EffectViewport").SpawnEffect("");
	ScreenTextBox.SetText("");
}

private function OnTimerHideStart()
{
	Me.SetAlpha(255);
	Me.SetAlpha(0, float(timerHide._time) / 1000);
}

private function OnTimerHideEnd()
{
	_hideEffectView();
}

defaultproperties
{
}
