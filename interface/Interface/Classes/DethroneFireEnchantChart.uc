class DethroneFireEnchantChart extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle GoFireStateButton;
var ButtonHandle RefreshButton;
var DethroneFireEnchantWnd DethroneFireEnchantWndScript;
var DethroneFireEnchantDetailStats DethroneFireEnchantDetailStatsScript;
var DethroneFireEnchantProcess DethroneFireEnchantProcessScript;
var CharacterViewportWindowHandle EffectViewportChart;
var TextureHandle AddEffect03_tex;
var TextureHandle AddEffect05_tex;
var TextureHandle AddEffect07_tex;
var TextBoxHandle AddEffect03_txt;
var TextBoxHandle AddEffect05_txt;
var TextBoxHandle AddEffect07_txt;
var AnimTextureHandle AddEffectLv03_tex;
var AnimTextureHandle AddEffectLv05_tex;
var UIControlGroupButtons groupButtons;
var int nSetEffectLevel;

function OnRegisterEvent();

function OnLoad()
{
	Initialize();
	Load();	
}

function Initialize()
{
	Me = GetWindowHandle("DethroneFireEnchantChart");
	GoFireStateButton = GetButtonHandle("DethroneFireEnchantChart.GoFireStateButton");
	RefreshButton = GetButtonHandle("DethroneFireEnchantChart.RefreshButton");
	EffectViewportChart = GetCharacterViewportWindowHandle("DethroneFireEnchantChart.EffectViewportChart");
	AddEffect03_tex = GetTextureHandle("DethroneFireEnchantChart.AddEffect03_tex");
	AddEffect05_tex = GetTextureHandle("DethroneFireEnchantChart.AddEffect05_tex");
	AddEffect07_tex = GetTextureHandle("DethroneFireEnchantChart.AddEffect07_tex");
	AddEffect03_txt = GetTextBoxHandle("DethroneFireEnchantChart.AddEffect03_txt");
	AddEffect05_txt = GetTextBoxHandle("DethroneFireEnchantChart.AddEffect05_txt");
	AddEffect07_txt = GetTextBoxHandle("DethroneFireEnchantChart.AddEffect07_txt");
	AddEffectLv03_tex = GetAnimTextureHandle("DethroneFireEnchantChart.AddEffectLv03_tex");
	AddEffectLv05_tex = GetAnimTextureHandle("DethroneFireEnchantChart.AddEffectLv05_tex");	
}

function refresh()
{
	Debug("차트 갱신");
	GoFireStateButton.SetTooltipCustomType(getFireHelpTooltip());
	GetButtonHandle("DethroneFireEnchantChart.Item0.MainBtn").SetTooltipCustomType(getTypeButtonTooltip(0));
	GetButtonHandle("DethroneFireEnchantChart.Item1.MainBtn").SetTooltipCustomType(getTypeButtonTooltip(1));
	GetButtonHandle("DethroneFireEnchantChart.Item2.MainBtn").SetTooltipCustomType(getTypeButtonTooltip(2));
	GetButtonHandle("DethroneFireEnchantChart.Item3.MainBtn").SetTooltipCustomType(getTypeButtonTooltip(3));
	GetButtonHandle("DethroneFireEnchantChart.Item4.MainBtn").SetTooltipCustomType(getTypeButtonTooltip(4));
	setCircleBar(0);
	setCircleBar(1);
	setCircleBar(2);
	setCircleBar(3);
	setCircleBar(4);
	setEffectLevelView();
}

function setEffectLevelView()
{
	nSetEffectLevel = DethroneFireEnchantWndScript.getSetEffectLevel();
	if(nSetEffectLevel >= 3)
	{
		AddEffect03_tex.SetTexture("L2UI_EPIC.DethroneWnd.DethroneFireEnchant_AddEffect_03");
		AddEffect03_txt.SetTextColor(GTColor().Yellow2);		
	}
	else
	{
		AddEffect03_tex.SetTexture("L2UI_EPIC.DethroneWnd.DethroneFireEnchant_AddEffect_Disable");
		AddEffect03_txt.SetTextColor(GTColor().Gray);
	}
	if(nSetEffectLevel >= 6)
	{
		AddEffect05_tex.SetTexture("L2UI_EPIC.DethroneWnd.DethroneFireEnchant_AddEffect_05");
		AddEffect05_txt.SetTextColor(GTColor().Yellow2);		
	}
	else
	{
		AddEffect05_tex.SetTexture("L2UI_EPIC.DethroneWnd.DethroneFireEnchant_AddEffect_Disable");
		AddEffect05_txt.SetTextColor(GTColor().Gray);
	}
	if(nSetEffectLevel >= 10)
	{
		AddEffect07_tex.SetTexture("L2UI_EPIC.DethroneWnd.DethroneFireEnchant_AddEffect_07");
		AddEffect07_txt.SetTextColor(GTColor().Yellow2);		
	}
	else
	{
		AddEffect07_tex.SetTexture("L2UI_EPIC.DethroneWnd.DethroneFireEnchant_AddEffect_Disable");
		AddEffect07_txt.SetTextColor(GTColor().Gray);
	}
	AddEffectLv03_tex.HideWindow();
	AddEffectLv05_tex.HideWindow();
	switch(nSetEffectLevel)
	{
		case 0:
		case 1:
		case 2:
			break;
		case 3:
		case 4:
		case 5:
			AddEffectLv03_tex.SetColorModify(GetColor(255, 255, 255, 255));
			AnimTexturePlay(AddEffectLv03_tex, true, 9999999);
			break;
		case 6:
		case 7:
		case 8:
		case 9:
			AddEffectLv05_tex.SetColorModify(GetColor(255, 215, 0, 255));
			AnimTexturePlay(AddEffectLv05_tex, true, 9999999);
			break;
		case 10:
			AddEffectLv03_tex.SetColorModify(GetColor(255, 145, 0, 255));
			AddEffectLv05_tex.SetColorModify(GetColor(255, 145, 0, 255));
			AnimTexturePlay(AddEffectLv03_tex, true, 9999999);
			AnimTexturePlay(AddEffectLv05_tex, true, 9999999);
			break;
	}	
}

function SetTopOrder(int cType)
{
	groupButtons._setTopOrder(cType);	
}

function setCircleBar(int cType)
{
	local UIPacket._EAOF_Element OpenUI_PacketElement;
	local FireAbilityLevelupInfoUIData levelUPData;
	local float per;

	OpenUI_PacketElement = DethroneFireEnchantWndScript.getPacketDataElement(cType);
	levelUPData = DethroneFireEnchantWndScript.getUIDataByLevel(cType, OpenUI_PacketElement.nLevel);
	GetStatusRoundHandle("DethroneFireEnchantChart.Item" $ string(cType) $ ".MainStatus").SetPoint(OpenUI_PacketElement.nEXP, levelUPData.Exp);
	GetTextBoxHandle("DethroneFireEnchantChart.Item" $ string(cType) $ ".Level_txt").SetText("Lv" $ string(OpenUI_PacketElement.nLevel));
	GetTextBoxHandle("DethroneFireEnchantChart.Item" $ string(cType) $ ".Per_txt").SetText(string((float(OpenUI_PacketElement.nEXP) / float(levelUPData.Exp)) * float(100)));	
	per = float(ConvertFloatToString((float(OpenUI_PacketElement.nEXP) / float(levelUPData.Exp)) * 100, 2, false));
	GetTextBoxHandle("DethroneFireEnchantChart.Item" $ string(cType) $ ".Per_txt").SetText(string0100Per(per) $ "%");
	GetItemWindowHandle("DethroneFireEnchantChart.Item" $ string(cType) $ ".Icon_Item").Clear();
	GetItemWindowHandle("DethroneFireEnchantChart.Item" $ string(cType) $ ".Icon_Item").AddItem(getCTypeIconItemInfo(cType));
}

function int getSelectedCType()
{
	return groupButtons._getSelectButtonIndex();	
}

function Load()
{
	DethroneFireEnchantWndScript = DethroneFireEnchantWnd(GetScript("DethroneFireEnchantWnd"));
	DethroneFireEnchantDetailStatsScript = DethroneFireEnchantDetailStats(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantDetailStats"));
	DethroneFireEnchantProcessScript = DethroneFireEnchantProcess(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantProcess"));
	groupButtons = new class'UIControlGroupButtons';
	groupButtons._SetStartInfo("L2UI_EPIC.DethroneWnd.DethroneFireEnchant_Slot_Normal", "L2UI_EPIC.DethroneWnd.DethroneFireEnchant_Slot_Selected", "L2UI_EPIC.DethroneWnd.DethroneFireEnchant_Slot_Over");
	groupButtons._addButtonController(GetButtonHandle("DethroneFireEnchantChart.Item0.MainBtn"));
	groupButtons._addButtonController(GetButtonHandle("DethroneFireEnchantChart.Item1.MainBtn"));
	groupButtons._addButtonController(GetButtonHandle("DethroneFireEnchantChart.Item2.MainBtn"));
	groupButtons._addButtonController(GetButtonHandle("DethroneFireEnchantChart.Item3.MainBtn"));
	groupButtons._addButtonController(GetButtonHandle("DethroneFireEnchantChart.Item4.MainBtn"));
	groupButtons.DelegateOnClickButton = groupButtonOnClickButton;
	groupButtons._setShowButtonNum();
	groupButtons._setUseOverlapClickPrevention(true);
	GetTextBoxHandle("DethroneFireEnchantChart.Item0.TitleType_txt").SetText(GetSystemString(14320));
	GetTextBoxHandle("DethroneFireEnchantChart.Item1.TitleType_txt").SetText(GetSystemString(14323));
	GetTextBoxHandle("DethroneFireEnchantChart.Item2.TitleType_txt").SetText(GetSystemString(14324));
	GetTextBoxHandle("DethroneFireEnchantChart.Item3.TitleType_txt").SetText(GetSystemString(14322));
	GetTextBoxHandle("DethroneFireEnchantChart.Item4.TitleType_txt").SetText(GetSystemString(14321));	
}

function CustomTooltip getTypeButtonTooltip(int cType)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local int i;
	local UIPacket._EAOF_Element OpenUI_PacketElement;
	local FireAbilityLevelupInfoUIData levelUPData;

	OpenUI_PacketElement = DethroneFireEnchantWndScript.getPacketDataElement(cType);
	levelUPData = DethroneFireEnchantWndScript.getUIDataByLevel(cType, OpenUI_PacketElement.nLevel);
	// End:0x106
	if(levelUPData.SkillEffect.Length > 0)
	{
		// End:0xF6 [Loop If]
		for(i = 0; i < levelUPData.SkillEffect.Length / 2; i++)
		{
			drawListArr[drawListArr.Length] = addDrawItemText(levelUPData.SkillEffect[i * 2] $ "  ", GTColor().White, "", true, true);
			drawListArr[drawListArr.Length] = addDrawItemText_DIAT_Right(levelUPData.SkillEffect[(i * 2) + 1], GTColor().ColorDesc, "", false, true);
		}
		mCustomTooltip.MinimumWidth = 200;		
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14327), GTColor().White, "", true, true);
		mCustomTooltip.MinimumWidth = 100;
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;	
}

function CustomTooltip getFireHelpTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14329), GTColor().Yellow2, "", false, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14330), GTColor().White, "", true, false);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 250;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;	
}

function groupButtonOnClickButton(string parentWndName, string buttonName, int currentTabIndex)
{
	// End:0x120
	if(groupButtons._getButtonValueByName(buttonName) != -1)
	{
		Debug("groupButtonOnClickButton" @ parentWndName @ buttonName @ string(currentTabIndex) @ string(groupButtons._getButtonValueByName(buttonName)));
		// End:0xEC
		if(GetWindowHandle("DethroneFireEnchantWnd.DethroneFireEnchantDetailStats").IsShowWindow())
		{
			Debug("기본효과, 추가 효과 폼 갱신");
			DethroneFireEnchantDetailStatsScript.refresh();			
		}
		else
		{
			Debug("인챈트 폼 갱신");
			DethroneFireEnchantProcessScript.deleteRewardItems();
			DethroneFireEnchantProcessScript.refresh();
			DethroneFireEnchantProcessScript.initCheckBox();
		}
	}	
}

function OnClickButtonWithHandle(ButtonHandle a_btn)
{
	groupButtons._selectButtonHandle(a_btn);	
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x26
		case "GoFireStateButton":
			OnGoFireStateButtonClick();
			// End:0x29
			break;
		case "RefreshButton":
			RefreshButtonButtonClick();
			break;
	}	
}

function RefreshButtonButtonClick()
{
	getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13841));
	DethroneFireEnchantWnd(GetScript("DethroneFireEnchantWnd")).API_C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI();	
}

function OnGoFireStateButtonClick()
{
	// End:0x52
	if(GetWindowHandle("DethroneFireStateWnd").IsShowWindow())
	{
		GetWindowHandle("DethroneFireStateWnd").HideWindow();		
	}
	else
	{
		DethroneFireEnchantWndScript.API_C_EX_HOLY_FIRE_OPEN_UI();
	}	
}

function enableAll(bool bEnable)
{
	// End:0x3E
	if(bEnable)
	{
		groupButtons._setEnableAll();
		RefreshButton.EnableWindow();
		Debug("EnableWindow");		
	}
	else
	{
		groupButtons._setDisableAll();
		RefreshButton.DisableWindow();
		Debug("DisableWindow");
	}	
}

function Shake(bool bShake)
{
	// End:0x95
	if(bShake)
	{
		L2UITween(GetScript("l2UITween")).StartShake("DethroneFireEnchantWnd.DethroneFireEnchantChart.Item" $ string(getSelectedCType()), 4, 600, L2UITween(GetScript("l2UITween")).directionType.small, 0, 1010101);		
	}
	else
	{
		L2UITween(GetScript("l2UITween")).StopShake("DethroneFireEnchantWnd.DethroneFireEnchantChart.Item" $ string(getSelectedCType()), 1010101);
	}	
}

function ItemInfo getCTypeIconItemInfo(int cType)
{
	local ItemInfo Info;

	switch(cType)
	{
		case 0:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_source_1";
			// End:0x126
			break;
		case 1:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_life_1";
			// End:0x126
			break;
		case 2:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_combat_1";
			// End:0x126
			break;
		case 3:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_totem_1";
			// End:0x126
			break;
		case 4:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_piece_1";
			// End:0x126
			break;
	}
	return Info;	
}

defaultproperties
{
}
