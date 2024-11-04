class UIButtonTestWnd extends UICommonAPI;

var float Angle;
var DrawPanelHandle drawPanel1;
var DrawPanelHandle drawPanel2;

function OnRegisterEvent()
{}

function OnLoad()
{
	SetClosingOnESC();
	drawPanel1 = GetDrawPanelHandle("UIButtonTestWnd.drawPanel1");
	drawPanel2 = GetDrawPanelHandle("UIButtonTestWnd.ScrollArea.itemRenderer.drawPanel2");
}

event OnShow()
{
	local int i;

	// End:0x64 [Loop If]
	for(i = 1; i < 11; i++)
	{
		GetButtonHandle("UIButtonTestWnd.test" $ string(i) $ "Button").MoveC((i - 1) * 105, 30);
	}

	// End:0xCA [Loop If]
	for(i = 11; i < 21; i++)
	{
		GetButtonHandle("UIButtonTestWnd.test" $ string(i) $ "Button").MoveC((i - 11) * 105, 80);
	}

	// End:0x130 [Loop If]
	for(i =21; i < 31; i++)
	{
		GetButtonHandle("UIButtonTestWnd.test" $ string(i) $ "Button").MoveC((i - 21) * 105, 130);
	}
	initControl();
	drawPanel();
	setScrollDrawPanel2();
}

function drawPanel()
{
	local int nX, nY;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.BottomBar.SuppressHotTime", false, false, 0, 0, 10, 11, 10, 11);
	drawListArr[drawListArr.Length] = addDrawItemText("우주의 기운을 받아서 출력을 해라! 이야야야야", getInstanceL2Util().Yellow, "", false, true, 10);
	drawListArr[drawListArr.Length] = addDrawItemText("red! 빨강", getInstanceL2Util().Red, "", false, true, 10);
	drawListArr[drawListArr.Length] = addDrawItemText("blue! 파랑", getInstanceL2Util().Blue, "", true, false, 10);
	drawListArr[drawListArr.Length] = addDrawItemText("설명은 생략한다! 주절 주절주절 주절주절 주절주절 주절주절 주절주절 주절", getInstanceL2Util().ColorDesc, "", true, false);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	addDrawItemGameItem(drawListArr, GetItemInfoByClassID(1), true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(100);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText_DIAT_Right("설명은 생략한다!", getInstanceL2Util().White, "hs13", true);
	drawPanel1.Clear();
	DrawPanelArray(drawPanel1, drawListArr);
	drawPanel1.PreCheckPanelSize(nX, nY);
	Debug("nW" @ string(nX));
	Debug("nH" @ string(nY));
	drawPanel1.SetWindowSize(nX, nY);	
}

function setScrollDrawPanel2()
{
	local int nX, nY;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText("타이틀타이틀타이틀타이틀타이틀1234567890123456789", getInstanceL2Util().Yellow, "", false, false);
	drawListArr[drawListArr.Length] = addDrawItemText("red! 빨강", getInstanceL2Util().Red, "", true, false, 10);
	drawListArr[drawListArr.Length] = addDrawItemText("blue! 파랑", getInstanceL2Util().Blue, "", true, true, 10);
	drawListArr[drawListArr.Length] = addDrawItemText("설명은 생략한다! 123456789012345\\n6789012345678901234567890", getInstanceL2Util().ColorDesc, "", true, false);
	drawListArr[drawListArr.Length] = addDrawItemText("우주의 기운을 받아서 출력을 해라! 이야야야야dafsffffsadfasfasdfdsafdsafdsafdsafdasfdsafdsfdsafdfsdaggdf", getInstanceL2Util().Yellow, "", true, false, 10);
	drawListArr[drawListArr.Length] = addDrawItemText("blue! 파랑", getInstanceL2Util().Blue, "", true, false, 10);
	drawListArr[drawListArr.Length] = addDrawItemText("폰트 칼라를 적용해 본다.<font color=\"FFBB00\">추가 타격</font> 이게 잘되는지 보자.1 2 3 4 5 6 7 8 9 0", getInstanceL2Util().ColorDesc, "", true, false);
	drawListArr[drawListArr.Length] = addDrawItemText("blue! 파랑", getInstanceL2Util().Blue, "", true, false, 10);
	drawListArr[drawListArr.Length] = addDrawItemText("설명은 생략한다! 주절 주절주절 주절주절 주절주절 주절주절 주절주절 주절 끝", getInstanceL2Util().ColorDesc, "", true, false);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	addDrawItemGameItem(drawListArr, GetItemInfoByClassID(1), false);
	addDrawItemGameItem(drawListArr, GetItemInfoByClassID(2), false);
	addDrawItemGameItem(drawListArr, GetItemInfoByClassID(3), false);
	addDrawItemGameItemColorFul(drawListArr, GetItemInfoByClassID(4), true);
	addDrawItemGameItemColorFul(drawListArr, GetItemInfoByClassID(11094), true);
	addDrawItemGameItemColorFul(drawListArr, GetItemInfoByClassID(11095), false);
	addDrawItemGameItemNameAll(drawListArr, GetItemInfoByClassID(11087), 0, 0, "hs13");
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(100);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText_DIAT_CENTER("중앙 정렬 한줄의 짧은건 되고", GTColor().Blue, "hs12");
	drawListArr[drawListArr.Length] = addDrawItemBlank(1);
	drawListArr[drawListArr.Length] = addDrawItemText_DIAT_CENTER("중앙 정렬 입니다. 이걸 설명하려고 이렇게 써 넣습니다. 중앙 정렬이 잘되나 보려구요. 긴걸 넣으면 안되네요.", GTColor().Red, "hs12");
	drawListArr[drawListArr.Length] = addDrawItemBlank(1);
	drawListArr[drawListArr.Length] = addDrawItemText("끝 입니다", GTColor().Yellow, "hs13");
	DrawPanelArrayFixedWidth(drawPanel2, drawListArr, true);
	drawPanel2.PreCheckPanelSize(nX, nY);
	GetWindowHandle("UIButtonTestWnd.ScrollArea.itemRenderer").SetWindowSize(254, nY);
	drawPanel2.SetWindowSize(254, nY);
	GetWindowHandle("UIButtonTestWnd.ScrollArea").SetScrollHeight(nY);
	GetWindowHandle("UIButtonTestWnd.ScrollArea").SetScrollUnit(10, true);	
}

event OnEvent(int Event_ID, string param)
{}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x20
		case "test1Button":
			Ontest1ButtonClick();
			// End:0x30D
			break;
		// End:0x39
		case "test2Button":
			Ontest2ButtonClick();
			// End:0x30D
			break;
		// End:0x52
		case "test3Button":
			Ontest3ButtonClick();
			// End:0x30D
			break;
		// End:0x6B
		case "test4Button":
			Ontest4ButtonClick();
			// End:0x30D
			break;
		// End:0x84
		case "test5Button":
			Ontest5ButtonClick();
			// End:0x30D
			break;
		// End:0x9D
		case "test6Button":
			Ontest6ButtonClick();
			// End:0x30D
			break;
		// End:0xB6
		case "test7Button":
			Ontest7ButtonClick();
			// End:0x30D
			break;
		// End:0xCF
		case "test8Button":
			Ontest8ButtonClick();
			// End:0x30D
			break;
		// End:0xE8
		case "test9Button":
			Ontest9ButtonClick();
			// End:0x30D
			break;
		// End:0x102
		case "test10Button":
			Ontest10ButtonClick();
			// End:0x30D
			break;
		// End:0x11C
		case "test11Button":
			Ontest11ButtonClick();
			// End:0x30D
			break;
		// End:0x136
		case "test12Button":
			Ontest12ButtonClick();
			// End:0x30D
			break;
		// End:0x150
		case "test13Button":
			Ontest13ButtonClick();
			// End:0x30D
			break;
		// End:0x16A
		case "test14Button":
			Ontest14ButtonClick();
			// End:0x30D
			break;
		// End:0x184
		case "test15Button":
			Ontest15ButtonClick();
			// End:0x30D
			break;
		// End:0x19E
		case "test16Button":
			Ontest16ButtonClick();
			// End:0x30D
			break;
		// End:0x1B8
		case "test17Button":
			Ontest17ButtonClick();
			// End:0x30D
			break;
		// End:0x1D2
		case "test18Button":
			Ontest18ButtonClick();
			// End:0x30D
			break;
		// End:0x1EC
		case "test19Button":
			Ontest19ButtonClick();
			// End:0x30D
			break;
		// End:0x206
		case "test20Button":
			Ontest20ButtonClick();
			// End:0x30D
			break;
		// End:0x220
		case "test21Button":
			Ontest21ButtonClick();
			// End:0x30D
			break;
		// End:0x23A
		case "test22Button":
			Ontest22ButtonClick();
			// End:0x30D
			break;
		// End:0x254
		case "test23Button":
			Ontest23ButtonClick();
			// End:0x30D
			break;
		// End:0x26E
		case "test24Button":
			Ontest24ButtonClick();
			// End:0x30D
			break;
		// End:0x288
		case "test25Button":
			Ontest25ButtonClick();
			// End:0x30D
			break;
		// End:0x2A2
		case "test26Button":
			Ontest26ButtonClick();
			// End:0x30D
			break;
		// End:0x2BC
		case "test27Button":
			Ontest27ButtonClick();
			// End:0x30D
			break;
		// End:0x2D6
		case "test28Button":
			Ontest28ButtonClick();
			// End:0x30D
			break;
		// End:0x2F0
		case "test29Button":
			Ontest29ButtonClick();
			// End:0x30D
			break;
		// End:0x30A
		case "test30Button":
			Ontest30ButtonClick();
			// End:0x30D
			break;
	}
}

function Ontest1ButtonClick()
{
	class'OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText(1.0f, 1999.0f, "LineageEffect2.ui_screen_message_flow", 0, 0, 0, -7, 0, 3000, 500, "야야야야야야야야\\n safsafsadfasfdsadafssddasfdafsdfas", GTColor().White);
}

function Ontest2ButtonClick()
{
	class'OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText(1.0f, 500.0f, "LineageEffect2.ui_screen_message02_flow", 0, 0, 0, -3, 0, 3000, 500, "축하합니다. 성공입니다!", GTColor().Yellow, GetItemInfoByClassID(1));
}

function Ontest3ButtonClick()
{
	class'OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText_Texture(getTextureInfo("L2UI_EPIC.subjugation_silent_valley", "OnscreenEffectViewPortWnd.ScreenTextBox", "TopCenter", "TopCenter", 0, -60, 387, 180), 1.0f, 500.0f, "LineageEffect2.ui_screen_message03_flow", 0, 0, 0, -3, 0, 3000, 1000, "위험한 영역 입니다.", GTColor().Red);
}

function Ontest4ButtonClick()
{
	class'OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText_Texture(getTextureInfo("L2UI_CT1.OnScreenMessageWnd.OnScreenMessageWnd_DF_Win10_siege", "OnscreenEffectViewPortWnd.ScreenTextBox", "TopCenter", "TopCenter", 0, -29, 425, 90), 1.0f, 500.0f, "LineageEffect2.ui_upgrade_succ", 0, 0, 0, 2, 0, 3000, 1000, "축하합니다. 성공입니다.", GTColor().Yellow, GetItemInfoByClassID(93864));
}

function Ontest5ButtonClick()
{
	class'OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText_Texture(getTextureInfo("L2UI_CT1.OnScreenMessageWnd.OnScreenMessageWnd_DF_Win10_siege", "OnscreenEffectViewPortWnd.ScreenTextBox", "TopCenter", "TopCenter", 0, -29, 425, 90), 1.0f, 1500.0f, "LineageEffect2.ui_screen_message_flow", 0, 0, 0, -7, 0, 3000, 1000, "축하합니다!. 레어 아이템 획득!", GTColor().Yellow, GetItemInfoByClassID(93864), 1);	
}

function Ontest6ButtonClick()
{
	class'OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText_Texture(getTextureInfo("L2UI_CT1.OnScreenMessageWnd.OnScreenMessageWnd_DF_Win10_siege", "OnscreenEffectViewPortWnd.ScreenTextBox", "TopCenter", "TopCenter", 0, -29, 425, 90), 1.0f, 500.0f, "LineageEffect_br.br_e_lamp_deco_d", 0, 0, 0, -3, 0, 3000, 1000, "AP필드 작동!", GTColor().Green,, 2);	
}

function Ontest7ButtonClick()
{
	class'OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText_Texture(getTextureInfo("L2UI_CT1.OnScreenMessageWnd.OnScreenMessageWnd_DF_Win10_siege", "OnscreenEffectViewPortWnd.ScreenTextBox", "TopCenter", "TopCenter", 0, -29, 425, 90), 1.0f, 500.0f, "LineageEffect.d_chainheal_ta", 0, 0, 0, -3, 0, 3000, 1000, "황금의 아이템 획득!", GTColor().Yellow03,, 3);	
}

function Ontest8ButtonClick()
{
	class'OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText_Texture(getTextureInfo("L2UI_EPIC.CollectionSystemWnd.KeyItemcol_A_00", "OnscreenEffectViewPortWnd.ScreenTextBox", "TopCenter", "TopCenter", 0, -200, 233, 523), 1.0f, 500.0f, "LineageEffect2.y_kn_summon_cubic_fire_body", 0, 0, 0, -3, 0, 3000, 1000, "처치 성공 아이템 획득!", GTColor().White,, 2);	
}

function Ontest9ButtonClick()
{}

function Ontest10ButtonClick()
{}

function Ontest11ButtonClick()
{}

function Ontest12ButtonClick()
{}

function Ontest13ButtonClick()
{}

function Ontest14ButtonClick()
{}

function Ontest15ButtonClick()
{}

function Ontest16ButtonClick()
{}

function Ontest17ButtonClick()
{}

function Ontest18ButtonClick()
{}

function Ontest19ButtonClick()
{}

function Ontest20ButtonClick()
{}

function Ontest21ButtonClick()
{}

function Ontest22ButtonClick()
{}

function Ontest23ButtonClick()
{}

function Ontest24ButtonClick()
{}

function Ontest25ButtonClick()
{}

function Ontest26ButtonClick()
{}

function Ontest27ButtonClick()
{}

function Ontest28ButtonClick()
{}

function Ontest29ButtonClick()
{}

function Ontest30ButtonClick()
{}

function initControl()
{
	local UIControlNumberInputSteper scr;

	scr = class'UIControlNumberInputSteper'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NumberInputSteper"));
	scr.DelegateOnButtonClick = DelegateOnButtonClick;
	scr.DelegateOnChangeEditBox = DelegateOnChangeEditBox;
	scr.DelegateESCKey = DelegateESCKey;
	scr._setRangeMinMaxNum(1, 50);
	scr._setAddButtons(1, 5, 10);
	scr._setEditNum(1);
}

function DelegateESCKey()
{
	OnReceivedCloseUI();
}

function DelegateOnButtonClick(string Str, int addValue)
{
	Debug("str:" @ Str @ string(addValue));
}

function DelegateOnChangeEditBox(UIControlNumberInputSteper scr)
{
	Debug("_getEditNum" @ string(scr._getEditNum()));
}

event OnKeyDown(WindowHandle a_WindowHandle, EInputKey nKey)
{
	local string mainKey;

	// End:0x295
	if(GetMeWindow().IsShowWindow())
	{
		mainKey = class'InputAPI'.static.GetKeyString(nKey);
		// End:0x295
		if(mainKey == "ENTER")
		{
			Debug(ConvertFloatToString(10.567890f, 1, true));
			Debug(ConvertFloatToString(10.567890f, 1, false));
			Debug(ConvertFloatToString(10.547890f, 4, false));
			Debug(ConvertFloatToString(10.547890f, 4, true));
			GetMeTextBox("resultTextBox").SetText(string(float(GetMeEditBox("s1EditBox").GetString())) $ "  #  " $ string(float(GetMeEditBox("s2EditBox").GetString())) $ "\\n\\n" $ "곱하기:" @ string(float(GetMeEditBox("s1EditBox").GetString()) * float(GetMeEditBox("s2EditBox").GetString())) $ "\\n" $ "나누기:" @ string(float(GetMeEditBox("s1EditBox").GetString()) / float(GetMeEditBox("s2EditBox").GetString())) $ "\\n" $ "나머지:" @ string(float(GetMeEditBox("s1EditBox").GetString()) % float(GetMeEditBox("s2EditBox").GetString())) $ "\\n" $ "더하기:" @ string(float(GetMeEditBox("s1EditBox").GetString()) + float(GetMeEditBox("s2EditBox").GetString())) $ "\\n" $ "빼기  :" @ string(float(GetMeEditBox("s1EditBox").GetString()) - float(GetMeEditBox("s2EditBox").GetString())) $ "\\n" $ "");
		}
	}
}

function OnReceivedCloseUI()
{
	m_hOwnerWnd.HideWindow();
}

defaultproperties
{
}
