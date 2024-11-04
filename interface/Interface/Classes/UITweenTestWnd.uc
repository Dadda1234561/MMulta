class UITweenTestWnd extends UICommonAPI;

enum ETweenParamType 
{
	Tween,
	Shake,
	Twinkle
};

var WindowHandle Me;
var string m_WindowName;
var TextureHandle texture0;
var TextureHandle Texture1;
var EditBoxHandle tweenParamEditBox;
var ComboBoxHandle tweenTypeComboBox;
var WindowHandle tweenParamPanel;
var WindowHandle shakeParamPanel;
var L2UITween l2UITweenScript;
var ComboBoxHandle tweenEaseTypeComboBox;
var ComboBoxHandle shakeDirectionComboBox;
var UIControlSliderWithValue tweenDurationSlider;
var UIControlSliderWithValue tweenAlphaSlider;
var UIControlSliderWithValue tweenSizeXSlider;
var UIControlSliderWithValue tweenSizeYSlider;
var UIControlSliderWithValue tweenMoveXSlider;
var UIControlSliderWithValue tweenMoveYSlider;
var UIControlSliderWithValue tweenDelaySlider;
var UIControlSliderWithValue shakeDurationSlider;
var UIControlSliderWithValue shakeSizeSlider;
var UIControlSliderWithValue shakeDelaySlider;

event OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
}

event OnLoad()
{
	Me = GetWindowHandle(m_WindowName);
	tweenParamPanel = GetWindowHandle(m_WindowName $ ".tweenParamPanel");
	shakeParamPanel = GetWindowHandle(m_WindowName $ ".shakeParamPanel");
	texture0 = GetTextureHandle(m_WindowName $ ".texture0");
	Texture1 = GetTextureHandle(m_WindowName $ ".texture1");
	tweenParamEditBox = GetEditBoxHandle(m_WindowName $ ".tweenParamEditBox");
	tweenTypeComboBox = GetComboBoxHandle(m_WindowName $ ".tweenTypeComboBox");
	l2UITweenScript = class'L2UITween'.static.Inst();
	SetClosingOnESC();
	GetTextBoxHandle(m_WindowName $ ".TweenHelpTextBox").SetText("[EASE] 0:IN_STRONG, 1:OUT_STRONG, 2:INOUT_STRONG, 3:IN_BOUNCE, 4:OUT_BOUNCE, 5:INOUT_BOUNCE, 6:IN_ELASTIC, 7:OUT_ELASTIC, 8:INOUT_ELASTIC\\n" $ "[TYPE] shake, tween [Alpha] 0~255, [DURATION] 1000이 1초 ");
	GetEditBoxHandle(m_WindowName $ ".texture1EditBox").SetString("w=100 h=100 texture=L2UI_ct1.Button.Button_DF_Calculator_Long_Over");
	GetEditBoxHandle(m_WindowName $ ".texture2EditBox").SetString("w=100 h=100 texture=L2UI_ct1.Button.Button_DF_Calculator_Long_Over");
	InitTweenParamControls();
	ResetParams();
	ResetTextures();
}

function OnShow()
{
	ResetTextures();
}

function InitTweenParamControls()
{
	local int i;

	tweenTypeComboBox.AddStringWithReserved(GetTweenName(ETweenParamType.Tween/*0*/), 0);
	tweenTypeComboBox.AddStringWithReserved(GetTweenName(ETweenParamType.Shake/*1*/), 1);
	tweenTypeComboBox.AddStringWithReserved(GetTweenName(ETweenParamType.Twinkle/*2*/), 2);
	InitSliderControl(tweenDurationSlider, "tweenDurationSlider", "duration", 0, 20000, 1000, tweenParamPanel);
	InitSliderControl(tweenAlphaSlider, "tweenAlphaSlider", "alpha", -255, 255, 100, tweenParamPanel);
	InitSliderControl(tweenSizeXSlider, "tweenSizeXSlider", "sizeX", -1000, 1000, 100, tweenParamPanel);
	InitSliderControl(tweenSizeYSlider, "tweenSizeYSlider", "sizeY", -1000, 1000, 100, tweenParamPanel);
	InitSliderControl(tweenMoveXSlider, "tweenMoveXSlider", "moveX", -1000, 1000, 0, tweenParamPanel);
	InitSliderControl(tweenMoveYSlider, "tweenMoveYSlider", "moveY", -1000, 1000, 0, tweenParamPanel);
	InitSliderControl(tweenDelaySlider, "tweenDelaySlider", "delay", 0, 10000, 0, tweenParamPanel);
	tweenEaseTypeComboBox = GetComboBoxHandle(tweenParamPanel.m_WindowNameWithFullPath $ ".tweenEaseTypeComboBox");

	// End:0x224 [Loop If]
	for(i = 0; i < (l2UITweenScript.easeType.EASENONE + 1); i++)
	{
		tweenEaseTypeComboBox.AddString(string(GetEnum(enum'easeType', i)));
	}
	InitSliderControl(shakeDurationSlider, "shakeDurationSlider", "duration", 0, 20000, 1000, shakeParamPanel);
	InitSliderControl(shakeSizeSlider, "shakeSizeSlider", "shakeSize", 1, 1000, 40, shakeParamPanel);
	InitSliderControl(shakeDelaySlider, "shakeDelaySlider", "delay", 0, 10000, 0, shakeParamPanel);
	shakeDirectionComboBox = GetComboBoxHandle(tweenParamPanel.m_WindowNameWithFullPath $ ".shakeDirectionComboBox");

	// End:0x343 [Loop If]
	for(i = 0; i < (l2UITweenScript.easeType.OUT_STRONG + 1); i++)
	{
		shakeDirectionComboBox.AddString(string(GetEnum(enum'directionType', i)));
	}
}

function InitSliderControl(out UIControlSliderWithValue Control, string ControlName, string titleText, int MinValue, int MaxValue, int defaultValue, WindowHandle Owner)
{
	local WindowHandle targetWindowHandle;

	targetWindowHandle = GetWindowHandle(Owner.m_WindowNameWithFullPath $ "." $ ControlName);
	targetWindowHandle.SetScript("UIControlSliderWithValue");
	Control = UIControlSliderWithValue(targetWindowHandle.GetScript());
	Control.Init(targetWindowHandle);
	Control._SetMinMaxValue(MinValue, MaxValue);
	Control._SetValue(defaultValue);
	Control._SetTitle(titleText);
	Control.DelegateOnValueChanged = OnSliderValueChanged;
}

event OnComboBoxItemSelected(string strID, int Index)
{
	switch(strID)
	{
		// End:0x33
		case "tweenTypeComboBox":
			SetTweenParamTypePanel(ETweenParamType(Index));
			UpdateTweenParamString();
			// End:0x7D
			break;
		// End:0x56
		case "tweenEaseTypeComboBox":
			UpdateTweenParamString();
			// End:0x7D
			break;
		// End:0x7A
		case "shakeDirectionComboBox":
			UpdateTweenParamString();
			// End:0x7D
			break;
	}
}

event OnSliderValueChanged(UIControlSliderWithValue slider)
{
	UpdateTweenParamString();
}

event OnCallUCFunction(string functionName, string param)
{
	Debug("OnCallUCFunction CompleteTween" @ param);
	switch (functionName)
	{
		case l2UITweenScript.TWEENEND:
			getInstanceL2Util().showGfxScreenMessage("모션 완료" @ param);
			// End:0x72
			break;
	}
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x2F
		case "ButtonStart":
			MaketweenObjectFormString(tweenParamEditBox.GetString());
			// End:0x124
			break;
		// End:0x48
		case "ButtonReset":
			ResetTextures();
			// End:0x124
			break;
		// End:0x66
		case "ButtonResetParam":
			ResetParams();
			// End:0x124
			break;
		// End:0x87
		case "ButtonUpdateTexture":
			UpdateTexture();
			// End:0x124
			break;
		// End:0x121
		case "SaveList":
			class'UIListNoteWnd'.static.Inst().delegateGetParam = getParam;
			class'UIListNoteWnd'.static.Inst()._SetString(GetTweenName(ETweenParamType(tweenTypeComboBox.GetSelectedNum())));
			class'UIListNoteWnd'.static.Inst()._Show(m_hOwnerWnd);
			class'UIListNoteWnd'.static.Inst().delegateOnDBClick = SetParam;
			// End:0x124
			break;
	}
}

function string getParam()
{
	local string param;

	param = GetParamsStringFromControlValue();
	ParamAdd(param, "textureValues", GetEditBoxHandle(m_WindowName $ ".texture1EditBox").GetString());
	Debug("GetParam" @ param);
	return param;
}

function SetParam(string param)
{
	local string texturetext;

	MaketweenObjectFormString(param);
	ParseString(param, "textureValues", texturetext);
	GetEditBoxHandle(m_WindowName $ ".texture1EditBox").SetString(texturetext);
	UpdateTexture();
	Debug("SetParam" @ texturetext);
}

function UpdateTexture()
{
	local string s1, S2, sText1, sText2;
	local int h1, w1, h2, w2, uw1, uh1,
		uw2, uh2;

	s1 = GetEditBoxHandle(m_WindowName $ ".texture1EditBox").GetString();
	S2 = GetEditBoxHandle(m_WindowName $ ".texture2EditBox").GetString();
	// End:0x120
	if(s1 == "")
	{
		sText1 = "L2UI_ct1.Button.Button_DF_Calculator_Long_Over";
		w1 = 100;
		h1 = 100;
		GetEditBoxHandle(m_WindowName $ ".texture1EditBox").SetString("w=100 h=100 texture=L2UI_ct1.Button.Button_DF_Calculator_Long_Over");		
	}
	else
	{
		ParseString(s1, "texture", sText1);
		ParseInt(s1, "h", h1);
		ParseInt(s1, "w", w1);
		ParseInt(s1, "u", uw1);
		ParseInt(s1, "v", uh1);
	}
	// End:0x247
	if(S2 == "")
	{
		sText2 = "L2UI_ct1.Button.Button_DF_Calculator_Long_Over";
		w2 = 100;
		h2 = 100;
		GetEditBoxHandle(m_WindowName $ ".texture2EditBox").SetString("w=100 h=100 texture=L2UI_ct1.Button.Button_DF_Calculator_Long_Over");		
	}
	else
	{
		ParseString(S2, "texture", sText2);
		ParseInt(S2, "H", h2);
		ParseInt(S2, "W", w2);
		ParseInt(S2, "u", uw2);
		ParseInt(S2, "v", uh2);
	}
	GetEditBoxHandle(m_WindowName $ ".texture2EditBox");
	texture0.SetTexture(sText1);
	texture0.SetWindowSize(w1, h1);
	texture0.SetTextureSize(uw1, uh1);
	Texture1.SetTexture(sText2);
	Texture1.SetWindowSize(w2, h2);
	Texture1.SetTextureSize(uw2, uh2);
}

event OnEvent(int a_EventID, string a_Param)
{
	switch (a_EventID)
	{
		case EV_GamingStateEnter:
			// End:0x15
			break;
	}
}

function SetTweenParamTypePanel(UITweenTestWnd.ETweenParamType Type)
{
	// End:0x31
	if(Type == ETweenParamType.Tween/*0*/)
	{
		tweenParamPanel.ShowWindow();
		shakeParamPanel.HideWindow();		
	}
	else if(Type == ETweenParamType.Shake/*1*/)
	{
		shakeParamPanel.ShowWindow();
		tweenParamPanel.HideWindow();
	}
	else if(Type == ETweenParamType.Twinkle/*2*/)
	{
		tweenParamPanel.ShowWindow();
		shakeParamPanel.HideWindow();
	}
}

private function MakeScriptTween(L2UITween.TweenObject tweenObj)
{
	local string cord;

	cord = "local L2UITween.TweenObject tweenObj;" $ Chr(10) $ Chr(10) $ "tweenObj.target = GetWindowHandle( " $ Chr(34) $ "!대상 텍스쳐 경로?" $ Chr(34) $ ");" $ Chr(10) $ "tweenObj.ease = easeType(" $ string(tweenObj.ease) $ ");" $ Chr(10) $ "tweenObj.duration =" @ Chr(34) $ string(tweenObj.Duration) $ Chr(34) $ ";" $ Chr(10) $ "tweenObj.alpha =" @ Chr(34) $ string(tweenObj.Alpha) $ Chr(34) $ ";" $ Chr(10) $ "tweenObj.moveX =" @ Chr(34) $ string(tweenObj.MoveX) $ Chr(34) $ ";" $ Chr(10) $ "tweenObj.moveY =" @ Chr(34) $ string(tweenObj.MoveY) $ Chr(34) $ ";" $ Chr(10) $ "tweenObj.sizeX =" @ Chr(34) $ string(tweenObj.SizeX) $ Chr(34) $ ";" $ Chr(10) $ "tweenObj.sizeY =" @ Chr(34) $ string(tweenObj.SizeY) $ Chr(34) $ ";" $ Chr(10) $ "tweenObj.delay =" @ Chr(34) $ string(tweenObj.Delay) $ Chr(34) $ ";" $ Chr(10) $ "class'L2UITween'.static.Inst().AddTweenObject(tweenObj);";
	ClipboardCopy(cord);
	getInstanceL2Util().showGfxScreenMessage("Tween script copyed. → Ctrl + V");	
}

private function MakeScriptShake(L2UITween.ShakeObject shakeObj)
{
	local string cord;

	cord = "local L2UITween.ShakeObject shakeObj;" $ Chr(10) $ Chr(10) $ "shakeObj.target = GetWindowHandle( " $ Chr(34) $ "!대상 텍스쳐 경로?" $ Chr(34) $ ");" $ Chr(10) $ "shakeObj.direction = directionType(" $ string(shakeObj.Direction) $ ");" $ Chr(10) $ "shakeObj.shakeSize =" @ Chr(34) $ string(shakeObj.shakeSize) $ Chr(34) $ ";" $ Chr(10) $ "shakeObj.duration =" @ Chr(34) $ string(shakeObj.Duration) $ Chr(34) $ ";" $ Chr(10) $ "shakeObj.delay =" @ Chr(34) $ string(shakeObj.Delay) $ Chr(34) $ ";" $ Chr(10) $ "class'L2UITween'.static.Inst().StartShakeObject(shakeObj);";
	ClipboardCopy(cord);
	getInstanceL2Util().showGfxScreenMessage("Shake script copyed. → Ctrl + V");	
}

function MaketweenObjectFormString(string param)
{
	local L2UITween.TweenObject tweenObj;
	local L2UITween.ShakeObject shakeObj;
	local L2UITweenTwinkleObject twinkleObject;
	local string targetString;
	local int easeTypenum;
	local string Type;
	local int Dir;

	ParseString(param, "target", targetString);
	ParseString(param, "type", Type);
	switch(Type)
	{
		case "tween":
			tweenObj.Owner = m_WindowName;
			tweenObj.Target = GetWindowHandle(targetString);
			ParseInt(param, "ease", easeTypenum);
			tweenObj.ease = easeType(easeTypenum);
			ParseFloat(param, "duration", tweenObj.Duration);
			ParseFloat(param, "alpha", tweenObj.Alpha);
			ParseFloat(param, "moveX", tweenObj.MoveX);
			ParseFloat(param, "moveY", tweenObj.MoveY);
			ParseFloat(param, "sizeX", tweenObj.SizeX);
			ParseFloat(param, "sizeY", tweenObj.SizeY);
			ParseFloat(param, "delay", tweenObj.Delay);
			class'L2UITween'.static.Inst().AddTweenObject(tweenObj);
			SetTweenParamControls(tweenObj);
			MakeScriptTween(tweenObj);
			// End:0x3DD
			break;
		// End:0x26A
		case "shake":
			shakeObj.Target = GetWindowHandle(targetString);
			ParseFloat(param, "shakeSize", shakeObj.shakeSize);
			ParseFloat(param, "duration", shakeObj.Duration);
			ParseFloat(param, "delay", shakeObj.Delay);
			ParseInt(param, "direction", Dir);
			shakeObj.Direction = directionType(Dir);
			class'L2UITween'.static.Inst().StartShakeObject(shakeObj);
			SetShakeParamControls(shakeObj);
			MakeScriptShake(shakeObj);
			// End:0x3DD
			break;
		// End:0x3DA
		case "Twinkle":
			twinkleObject = new class'L2UITweenTwinkleObject';
			ParseFloat(param, "alpha", twinkleObject.gab);
			ParseFloat(param, "duration", twinkleObject.Duration);
			ParseFloat(param, "moveX", twinkleObject.twinkleNum);
			ParseFloat(param, "moveY", twinkleObject.Position);
			ParseInt(param, "sizeX", twinkleObject.minAlpha);
			ParseInt(param, "sizeY", twinkleObject.maxAlpha);
			SetTwinkleParamControls(twinkleObject);
			class'L2UITween'.static.Inst()._AddTweenTwinlkle(GetWindowHandle(targetString), twinkleObject.twinkleNum / float(10), twinkleObject.Position / float(10), twinkleObject.Duration, twinkleObject.minAlpha, twinkleObject.maxAlpha, twinkleObject.gab);
			// End:0x3DD
			break;
	}
}

function string GetParamsStringFromControlValue()
{
	local string params;
	local UITweenTestWnd.ETweenParamType tweenType;

	tweenType = ETweenParamType(tweenTypeComboBox.GetSelectedNum());
	ParamAdd(params, "target", "UITweenTestWnd.texture0");
	ParamAdd(params, "type", string(GetEnum(enum'ETweenParamType', tweenTypeComboBox.GetSelectedNum())));
	// End:0x1D2
	if(tweenType == ETweenParamType.Tween/*0*/)
	{
		ParamAdd(params, tweenDurationSlider._GetTitle(), string(tweenDurationSlider._GetValue()));
		ParamAdd(params, tweenAlphaSlider._GetTitle(), string(tweenAlphaSlider._GetValue()));
		ParamAdd(params, tweenSizeXSlider._GetTitle(), string(tweenSizeXSlider._GetValue()));
		ParamAdd(params, tweenSizeYSlider._GetTitle(), string(tweenSizeYSlider._GetValue()));
		ParamAdd(params, tweenMoveXSlider._GetTitle(), string(tweenMoveXSlider._GetValue()));
		ParamAdd(params, tweenMoveYSlider._GetTitle(), string(tweenMoveYSlider._GetValue()));
		ParamAdd(params, tweenDelaySlider._GetTitle(), string(tweenDelaySlider._GetValue()));
		ParamAdd(params, "ease", string(tweenEaseTypeComboBox.GetSelectedNum()));		
	}
	else if(tweenType == ETweenParamType.Shake/*1*/)
	{
		ParamAdd(params, shakeDurationSlider._GetTitle(), string(shakeDurationSlider._GetValue()));
		ParamAdd(params, shakeSizeSlider._GetTitle(), string(shakeSizeSlider._GetValue()));
		ParamAdd(params, shakeDelaySlider._GetTitle(), string(shakeDelaySlider._GetValue()));
		ParamAdd(params, "direction", string(shakeDirectionComboBox.GetSelectedNum()));
	}
	else if(tweenType == ETweenParamType.Twinkle/*2*/)
	{
		ParamAdd(params, tweenDurationSlider._GetTitle(), string(tweenDurationSlider._GetValue()));
		ParamAdd(params, tweenAlphaSlider._GetTitle(), string(tweenAlphaSlider._GetValue()));
		ParamAdd(params, tweenAlphaSlider._GetTitle(), string(tweenAlphaSlider._GetValue()));
		ParamAdd(params, tweenMoveXSlider._GetTitle(), string(tweenMoveXSlider._GetValue()));
		ParamAdd(params, tweenMoveYSlider._GetTitle(), string(tweenMoveYSlider._GetValue()));
		ParamAdd(params, tweenSizeXSlider._GetTitle(), string(tweenSizeXSlider._GetValue()));
		ParamAdd(params, tweenSizeYSlider._GetTitle(), string(tweenSizeYSlider._GetValue()));
		ParamAdd(params, tweenDelaySlider._GetTitle(), string(tweenDelaySlider._GetValue()));
	}
	return params;
}

function ResetTextures()
{
	texture0.SetAlpha(255);
	texture0.SetWindowSize(100, 100);
	texture0.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 100, 100);
	texture0.ClearAnchor();
	Texture1.SetAlpha(255);
	Texture1.SetWindowSize(100, 100);
	Texture1.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 400, 100);
	Texture1.ClearAnchor();
}

function ResetParams()
{
	local L2UITween.TweenObject defaultTweenObj;

	defaultTweenObj.Duration = 1000.0f;
	defaultTweenObj.Alpha = 100.0f;
	defaultTweenObj.MoveX = 100.0f;
	defaultTweenObj.MoveY = -50.0f;
	defaultTweenObj.SizeX = 100.0f;
	defaultTweenObj.SizeY = 100.0f;
	defaultTweenObj.Delay = 0.0f;
	defaultTweenObj.ease = l2UITweenScript.easeType.OUT_BOUNCE;
	SetTweenParamControls(defaultTweenObj);
}

function SetTweenParamControls(L2UITween.TweenObject tweenObj)
{
	tweenTypeComboBox.SetSelectedNum(0);
	SetTweenParamTypePanel(ETweenParamType.Tween/*0*/);
	tweenEaseTypeComboBox.SetSelectedNum(tweenObj.ease);
	tweenDurationSlider._SetValue(int(tweenObj.Duration));
	tweenAlphaSlider._SetValue(int(tweenObj.Alpha));
	tweenSizeXSlider._SetValue(int(tweenObj.SizeX));
	tweenSizeYSlider._SetValue(int(tweenObj.SizeY));
	tweenMoveXSlider._SetValue(int(tweenObj.MoveX));
	tweenMoveYSlider._SetValue(int(tweenObj.MoveY));
	tweenDelaySlider._SetValue(int(tweenObj.Delay));
}

function SetShakeParamControls(L2UITween.ShakeObject shakeObj)
{
	tweenTypeComboBox.SetSelectedNum(1);
	SetTweenParamTypePanel(ETweenParamType.Shake/*1*/);
	shakeDirectionComboBox.SetSelectedNum(shakeObj.Direction);
	shakeDurationSlider._SetValue(int(shakeObj.Duration));
	shakeSizeSlider._SetValue(int(shakeObj.shakeSize));
	shakeDelaySlider._SetValue(int(shakeObj.Delay));
}

function SetTwinkleParamControls(L2UITweenTwinkleObject twinkleObj)
{
	tweenTypeComboBox.SetSelectedNum(2);
	SetTweenParamTypePanel(ETweenParamType.Twinkle/*2*/);
	tweenDurationSlider._SetValue(int(twinkleObj.Duration));
	tweenAlphaSlider._SetValue(int(twinkleObj.gab));
	tweenSizeXSlider._SetValue(twinkleObj.minAlpha);
	tweenSizeYSlider._SetValue(twinkleObj.maxAlpha);
	tweenMoveXSlider._SetValue(int(twinkleObj.twinkleNum));
	tweenMoveYSlider._SetValue(int(twinkleObj.Position));
	tweenDelaySlider._SetValue(int(twinkleObj.Delay));	
}

function UpdateTweenParamString()
{
	tweenParamEditBox.SetString(GetParamsStringFromControlValue());
}

function SetValueString(string strID, int Value)
{
	SetValue(Right(strID, Len(strID) - 10), Value);
}

function SetValue(string typeString, int Value)
{
	GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick" $ typeString).SetString(string(Value));
}

function string GetTweenName(UITweenTestWnd.ETweenParamType Index)
{
	switch(Index)
	{
		// End:0x14
		case ETweenParamType.Shake/*1*/:
			return "Shake";
		// End:0x21
		case ETweenParamType.Tween/*0*/:
			return "Tween";
		// End:0x30
		case ETweenParamType.Twinkle/*2*/:
			return "Twinkle";
	}
	return "";
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_WindowName="UITweenTestWnd"
}
