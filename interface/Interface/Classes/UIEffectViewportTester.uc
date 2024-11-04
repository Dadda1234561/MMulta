class UIEffectViewportTester extends UICommonAPI;

var EditBoxHandle NCEditBox0;
var EffectViewportWndHandle EffectViewport;
var L2UITween l2uiTweenScript;
var L2UITimerObject timeObject;
var array<string> Effects;
var bool _isInit;

event OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
}

event OnLoad()
{
	SetClosingOnESC();
	NCEditBox0 = GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NCEditBox0");
	EffectViewport = GetEffectViewportWndHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".effectViewport");
	l2uiTweenScript = L2UITween(GetScript("l2UITween"));
	class'UIListNoteWnd'.static.Inst().delegateOnDBClick = SetParam;
	SetEffects();
}

function string getParam()
{
	local string param;

	param = "";
	ParamAdd(param, "effect", NCEditBox0.GetString());
	ParamAdd(param, "scale", GetEditorString("Scale"));
	ParamAdd(param, "distance", GetEditorString("Distance"));
	ParamAdd(param, "pitch", GetEditorString("Pitch"));
	ParamAdd(param, "yaw", GetEditorString("Yaw"));
	ParamAdd(param, "X", GetEditorString("OffSetX"));
	ParamAdd(param, "Y", GetEditorString("OffSetY"));
	ParamAdd(param, "Z", GetEditorString("OffSetZ"));
	ParamAdd(param, "W", GetEditorString("Width"));
	ParamAdd(param, "H", GetEditorString("Height"));
	ParamAdd(param, "T", GetEditorString("Timer"));
	return param;
}

function SetParam(string param)
{
	local int tmpNum;
	local string EffectName;
	local float tmpFloat;

	ParseString(param, "effect", EffectName);
	NCEditBox0.SetString(EffectName);
	ParseFloat(param, "scale", tmpFloat);
	SetFValue("scale", tmpFloat);
	ParseInt(param, "distance", tmpNum);
	SetValue("distance", tmpNum);
	ParseInt(param, "pitch", tmpNum);
	SetValue("Pitch", tmpNum);
	ParseInt(param, "yaw", tmpNum);
	SetValue("Yaw", tmpNum);
	ParseInt(param, "X", tmpNum);
	SetValue("OffsetX", tmpNum);
	ParseInt(param, "Y", tmpNum);
	SetValue("OffsetY", tmpNum);
	ParseInt(param, "Z", tmpNum);
	SetValue("OffsetZ", tmpNum);
	ParseInt(param, "W", tmpNum);
	SetValue("Width", tmpNum);
	ParseInt(param, "H", tmpNum);
	SetValue("Height", tmpNum);
	ParseInt(param, "T", tmpNum);
	SetValue("Timer", tmpNum);
	SetAllCurTick();
	Start();
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		// End:0x0F
		case EV_GamingStateEnter:
			// End:0x15
			break;
		// End:0xFFFF
		default:
			// End:0x15
			break;
	}
}

event OnClickButtonWithHandle(ButtonHandle wh)
{
	local Rect rectWnd;

	switch(wh.GetWindowName())
	{
		// End:0x53
		case "defaultList":
			rectWnd = wh.GetRect();
			ShowContextMenu(rectWnd.nX, rectWnd.nY);
			// End:0x56
			break;
	}
}

event OnClickButton(string strBtn)
{
	switch(strBtn)
	{
		// End:0x20
		case "ButtonStart":
			Start();
			// End:0xC8
			break;
		// End:0x3C
		case "ButtonOnScreen":
			HandleOnClickButtonOnScreen();
			// End:0xC8
			break;
		// End:0x52
		case "ResetBtn":
			Reset();
			// End:0xC8
			break;
		// End:0xC5
		case "SaveBtn":
			class'UIListNoteWnd'.static.Inst().delegateGetParam = getParam;
			class'UIListNoteWnd'.static.Inst()._SetString(NCEditBox0.GetString());
			class'UIListNoteWnd'.static.Inst()._Show(m_hOwnerWnd);
			// End:0xC8
			break;
		// End:0xFFFF
		default:
			break;
	}
}

event OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local float fTick;

	switch(strID)
	{
		// End:0xA1
		case "SliderCtrlScale":
			fTick = float(iCurrentTick) / float(100);
			// End:0x46
			if(fTick == 0)
			{
				fTick = 0.010f;
			}
			EffectViewport.SetScale(fTick);
			SetFValueString(strID, fTick);
			// End:0x9E
			if(GetWindowHandle("OnscreenEffectViewPortWnd").IsShowWindow())
			{
				EffectViewUpdate();
			}
			// End:0x376
			break;
		// End:0x115
		case "SliderCtrlDistance":
			EffectViewport.SetCameraDistance(float(iCurrentTick));
			SetValueString(strID, iCurrentTick);
			// End:0x112
			if(GetWindowHandle("OnscreenEffectViewPortWnd").IsShowWindow())
			{
				EffectViewUpdate();
			}
			// End:0x376
			break;
		// End:0x184
		case "SliderCtrlPitch":
			EffectViewport.SetCameraPitch(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			// End:0x181
			if(GetWindowHandle("OnscreenEffectViewPortWnd").IsShowWindow())
			{
				EffectViewUpdate();
			}
			// End:0x376
			break;
		// End:0x1F1
		case "SliderCtrlYaw":
			EffectViewport.SetCameraYaw(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			// End:0x1EE
			if(GetWindowHandle("OnscreenEffectViewPortWnd").IsShowWindow())
			{
				EffectViewUpdate();
			}
			// End:0x376
			break;
		// End:0x207
		case "SliderCtrlOffSetX":
		// End:0x21D
		case "SliderCtrlOffSetY":
		// End:0x299
		case "SliderCtrlOffSetZ":
			iCurrentTick = iCurrentTick - 50;
			SetOffset(strID, iCurrentTick);
			SetValueString(strID, iCurrentTick);
			// End:0x296
			if(GetWindowHandle("OnscreenEffectViewPortWnd").IsShowWindow())
			{
				EffectViewUpdate();
			}
			// End:0x376
			break;
		// End:0x2AD
		case "SliderCtrlWidth":
		// End:0x303
		case "SliderCtrlHeight":
			SetValueString(strID, iCurrentTick);
			EffectViewport.SetWindowSize(int(GetEditorString("Width")), int(GetEditorString("Height")));
			// End:0x376
			break;
		// End:0x373
		case "SliderCtrlTimer":
			SetValueString(strID, iCurrentTick);
			timeObject._time = iCurrentTick;
			// End:0x361
			if(timeObject._time == 0)
			{
				timeObject._Stop();				
			}
			else
			{
				timeObject._Reset();
			}
			// End:0x376
			break;
	}
}

event OnCompleteEditBox(string strID)
{
	local SliderCtrlHandle slider;
	local int Value;

	switch(strID)
	{
		// End:0x1E
		case "txtICurTickOffSetX":
		// End:0x35
		case "txtICurTickOffSetY":
		// End:0x85
		case "txtICurTickOffSetZ":
			Value = int(GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ strID).GetString()) + 50;
			// End:0x10F
			break;
		// End:0xD7
		case "txtIcurTickScale":
			Value = int(float(GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ strID).GetString()) * float(100));
			// End:0x10F
			break;
		// End:0xFFFF
		default:
			Value = int(GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ strID).GetString());
			// End:0x10F
			break;
			break;
	}
	slider = GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrl" $ Right(strID, Len(strID) - 11));
	slider.SetCurrentTick(Value);
}

event OnShow()
{
	// End:0x5A
	if(! _isInit)
	{
		timeObject = class'L2UITimer'.static.Inst()._AddNewTimerObject(int(GetEditorString("Timer")), -1);
		timeObject._DelegateOnTime = OnTimeFunc;
		_isInit = true;
	}
}

event OnHide()
{
	timeObject._Stop();
}

function SetEffects()
{
	local int i;

	Effects[++ i] = "LineageEffect2.ui_screen_message_flow";
	Effects[++ i] = "LineageEffect2.ui_screen_message02_flow";
	Effects[++ i] = "LineageEffect2.ui_screen_message03_flow";
	Effects[++ i] = "LineageEffect.br_e_u014_turkey_atk4b";
	Effects[++ i] = "LineageEffect2.ui_upgrade_succ";
	Effects[++ i] = "LineageEffect_br.br_e_firebox_fire_b";
	Effects[++ i] = "LineageEffect2.ui_star_circle";
	Effects[++ i] = "LineageEffect_br.br_e_lamp_deco_d";
	Effects[++ i] = "LineageEffect.d_ar_attractcubic_ta";
	Effects[++ i] = "LineageEffect2.ui_spirit_lvup";
	Effects[++ i] = "LineageEffect2.bg_astatine_portal";
	Effects[++ i] = "LineageEffect.d_firework_a";
	Effects[++ i] = "LineageEffect.d_firework_b";
	Effects[++ i] = "LineageEffect2.ui_spirit_extract";
	Effects[++ i] = "LineageEffect2.ui_upgrade_fail";
	Effects[++ i] = "LineageEffect2.ave_white_trans_deco";
	Effects[++ i] = "LineageEffect2.ui_yellow_smoke";
	Effects[++ i] = "LineageEffect2.ui_soul_crystal";
	Effects[++ i] = "LineageEffect.br_e_u095_flower_shower";
	Effects[++ i] = "LineageEffect2.y_kn_summon_cubic_fire_body";
	Effects[++ i] = "LineageEffect.d_chainheal_ta";
	Effects[++ i] = "LineageEffect2.white_black_1_dice";
	Effects[++ i] = "LineageEffect2.yellow_black_1_dice";
	Effects[++ i] = "LineageEffect2.white_red_1_dice";
}

function Start()
{
	m_hOwnerWnd.SetFocus();
	// End:0x3B
	if(timeObject._time == 0)
	{
		timeObject._Stop();
		SpawnEffect();		
	}
	else
	{
		SpawnEffect();
		timeObject._Play();
	}
	MakeClip();	
}

function SpawnEffect()
{
	EffectViewport.SpawnEffect(NCEditBox0.GetString());
}

function OnTimeFunc(int Count)
{
	SpawnEffect();
}

function ShowContextMenu(int X, int Y)
{
	local int i;
	local UIControlContextMenu ContextMenu;

	ContextMenu = class'UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;

	// End:0x78 [Loop If]
	for(i = 0; i < Effects.Length; i++)
	{
		ContextMenu.MenuNew(Effects[i], i);
	}
	ContextMenu.Show(X, Y, string(self));
}

function HandleOnClickContextMenu(int Index)
{
	NCEditBox0.SetString(class'UIControlContextMenu'.static.GetInstance().menuObjects[Index].Name);
	class'UIListNoteWnd'.static.Inst()._SetString(class'UIControlContextMenu'.static.GetInstance().menuObjects[Index].Name);
}

function HandleOnClickButtonOnScreen()
{
	EffectViewUpdate();	
}

function EffectViewUpdate()
{
	local OnScreenMessage1Wnd onScreenMessage1WndSrc;
	local string param, TextValue;
	local int Duration, Animation, FontType, BackgroundType, ColorR, ColorG,
		ColorB;

	local bool bUseNpcZoom;
	local int MsgNo, lineNum;
	local ButtonHandle btn;
	local string textScript;

	onScreenMessage1WndSrc = OnScreenMessage1Wnd(GetScript("OnScreenMessage1Wnd"));
	btn = GetMeButton("ButtonOnScreen");
	lineNum = btn.GetButtonValue() + 1;
	// End:0x6D
	if(lineNum > 3)
	{
		lineNum = 1;
	}
	btn.SetButtonValue(lineNum);
	Debug(string(btn.GetButtonValue()) @ string(lineNum));
	param = "";
	ParamAdd(param, "scale", string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlScale").GetCurrentTick() / 100));
	ParamAdd(param, "distance", string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlDistance").GetCurrentTick()));
	ParamAdd(param, "x", string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetX").GetCurrentTick() - 50));
	ParamAdd(param, "y", string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetY").GetCurrentTick() - 50));
	ParamAdd(param, "effect", NCEditBox0.GetString());
	ParamAdd(param, "yaw", string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlYaw").GetCurrentTick()));
	ParamAdd(param, "pitch", string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlPitch").GetCurrentTick()));
	ParamAdd(param, "width", string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlWidth").GetCurrentTick()));
	ParamAdd(param, "height", string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlHeight").GetCurrentTick()));
	TextValue = param;
	textScript = TextValue;
	switch(lineNum)
	{
		// End:0x32B
		case 1:
			// End:0x3C1
			break;
		// End:0x389
		case 2:
			TextValue = TextValue $ Chr(10) $ "Chr(10) 은 앞 들여 쓰기가 됩니다. # Chr(35) 는 가운데 정렬입니다.";
			// End:0x3C1
			break;
		// End:0x3BE
		case 3:
			TextValue = TextValue $ "# ↓ # Ctrl + V 로 붙여 쓰세요";
			// End:0x3C1
			break;
		// End:0xFFFF
		default:
			break;
	}
	btn.SetNameText("OnScreenEffectViewPort" @ string(lineNum));
	FontType = 0;
	ColorR = 255;
	ColorG = 255;
	ColorB = 255;
	bUseNpcZoom = true;
	onScreenMessage1WndSrc.ShowMsg(10, TextValue, Duration, Animation, FontType, BackgroundType, ColorR, ColorG, ColorB, bUseNpcZoom, MsgNo);
	Debug(param);
	onScreenMessage1WndSrc.setParamEffectViewPlay("OnScreenMessage10Wnd", param);
	MakeEffectMessgeClip();	
}

private function MakeEffectMessgeClip()
{
	local string param;

	param = "scale=" $ string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlScale").GetCurrentTick() / 100);
	param = param @ "distance=" $ string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlDistance").GetCurrentTick());
	param = param @ "x=" $ string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetX").GetCurrentTick() - 50);
	param = param @ "y=" $ string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetY").GetCurrentTick() - 50);
	param = param @ "effect=" $ NCEditBox0.GetString();
	param = param @ "yaw=" $ string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlYaw").GetCurrentTick());
	param = param @ "pitch=" $ string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlPitch").GetCurrentTick());
	param = param @ "width=" $ string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlWidth").GetCurrentTick());
	param = param @ "height=" $ string(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlHeight").GetCurrentTick());
	ClipboardCopy(Chr(34) $ param $ Chr(34));
	getInstanceL2Util().showGfxScreenMessage("EffectMessage param copyed. → Ctrl + V");	
}

private function MakeClip()
{
	local string cord;

	//cord =   ;
	cord = "effectViewport.SpawnEffect( " $ NCEditBox0.GetString() $ ");" $ Chr(10) $ "effectViewport.SetScale(" $ GetEditorString("Scale") $ ");" $ Chr(10) $ "effectViewport.SetCameraDistance(" $ GetEditorString("Distance") $ ");" $ Chr(10) $ "effectViewport.SetCameraPitch(" $ GetEditorString("Pitch") $ ");" $ Chr(10) $ "effectViewport.SetCameraYaw(" $ GetEditorString("Yaw") $ ");" $ Chr(10) $ "effectViewport.SetOffset( vec.x=" $ GetEditorString("OffSetX") $ " vec.y=" $ GetEditorString("OffsetY") $ " vec.z=" $ GetEditorString("OffsetZ") $ ");";
	ClipboardCopy(cord);
	getInstanceL2Util().showGfxScreenMessage("Effect script copyed. → Ctrl + V");	
}

function Reset()
{
	NCEditBox0.SetString("LineageEffect2.ui_star_circle");
	OnModifyCurrentTickSliderCtrl("SliderCtrlScale", 100);
	OnModifyCurrentTickSliderCtrl("SliderCtrlDistance", 200);
	OnModifyCurrentTickSliderCtrl("SliderCtrlPitch", 0);
	OnModifyCurrentTickSliderCtrl("SliderCtrlYaw", 0);
	OnModifyCurrentTickSliderCtrl("SliderCtrlOffSetX", 50);
	OnModifyCurrentTickSliderCtrl("SliderCtrlOffSetY", 50);
	OnModifyCurrentTickSliderCtrl("SliderCtrlOffSetZ", 50);
	OnModifyCurrentTickSliderCtrl("SliderCtrlWidth", 600);
	OnModifyCurrentTickSliderCtrl("SliderCtrlHeight", 600);
	OnModifyCurrentTickSliderCtrl("SliderCtrlTimer", 0);
	SetAllCurTick();
}

function SetAllCurTick()
{
	OnCompleteEditBox("txtICurTickScale");
	OnCompleteEditBox("txtICurTickDistance");
	OnCompleteEditBox("txtICurTickPitch");
	OnCompleteEditBox("txtICurTickYaw");
	OnCompleteEditBox("txtICurTickOffSetX");
	OnCompleteEditBox("txtICurTickOffSetY");
	OnCompleteEditBox("txtICurTickOffSetZ");
	OnCompleteEditBox("txtICurTickOffSetX");
	OnCompleteEditBox("txtICurTickWidth");
	OnCompleteEditBox("txtICurTickHeight");
	OnCompleteEditBox("txtICurTickTimer");
}

function SetValueString(string strID, int Value)
{
	SetValue(Right(strID, Len(strID) - 10), Value);
}

function SetValue(string typeString, int Value)
{
	GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick" $ typeString).SetString(string(Value));
}

function SetFValueString(string strID, float Value)
{
	SetFValue(Right(strID, Len(strID) - 10), Value);
}

function SetFValue(string typeString, float Value)
{
	GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick" $ typeString).SetString(string(Value));
}

function string GetValueString(string strID)
{
	return GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick" $ Right(strID, Len(strID) - 10)).GetString();
}

function string GetEditorString(string typeString)
{
	return GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick" $ typeString).GetString();
}

function SetOffset(string strID, int Value)
{
	local Vector vec;

	vec = GetCurrentOffset();
	switch(strID)
	{
		// End:0x3F
		case "txtICurTickOffSetX":
			vec.X = float(Value);
			// End:0x9A
			break;
		// End:0x6B
		case "txtICurTickOffSetY":
			vec.Y = float(Value);
			// End:0x9A
			break;
		// End:0x97
		case "txtICurTickOffSetZ":
			vec.Z = float(Value);
			// End:0x9A
			break;
		// End:0xFFFF
		default:
			break;
	}
	EffectViewport.SetOffset(vec);
}

function Vector GetCurrentOffset()
{
	local Vector offset;

	offset.X = float(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetX").GetCurrentTick() - 50);
	offset.Y = float(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetY").GetCurrentTick() - 50);
	offset.Z = float(GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetZ").GetCurrentTick() - 50);
	return offset;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
}

defaultproperties
{
}
