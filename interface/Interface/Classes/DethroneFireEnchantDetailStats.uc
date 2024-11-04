class DethroneFireEnchantDetailStats extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle BasicEffectHelp_btn;
var ButtonHandle AddEffectHelp_btn;
var ButtonHandle GoEnchantButton;
var TextBoxHandle SelectTypeWithLv_text;
var TextBoxHandle StatusBar_Text;
var RichListCtrlHandle BasicEffect_RichList;
var RichListCtrlHandle AddEffect_RichList;
var StatusBarHandle Proficiency_StatusBar;
var TextBoxHandle Title3_text;
var DethroneFireEnchantWnd DethroneFireEnchantWndScript;
var DethroneFireEnchantChart DethroneFireEnchantChartScript;
var DethroneFireEnchantProcess DethroneFireEnchantProcessScript;
var WindowHandle Description1MsgWnd;
var WindowHandle Description2MsgWnd;
var UIPacket._EAOF_Element elementData;

function OnRegisterEvent();

function OnLoad()
{
	Initialize();	
}

function OnShow();

function Initialize()
{
	DethroneFireEnchantWndScript = DethroneFireEnchantWnd(GetScript("DethroneFireEnchantWnd"));
	DethroneFireEnchantChartScript = DethroneFireEnchantChart(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantChart"));
	DethroneFireEnchantProcessScript = DethroneFireEnchantProcess(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantProcess"));
	Me = GetWindowHandle("DethroneFireEnchantDetailStats");
	BasicEffectHelp_btn = GetButtonHandle("DethroneFireEnchantDetailStats.BasicEffectHelp_btn");
	AddEffectHelp_btn = GetButtonHandle("DethroneFireEnchantDetailStats.AddEffectHelp_btn");
	GoEnchantButton = GetButtonHandle("DethroneFireEnchantDetailStats.GoEnchantButton");
	SelectTypeWithLv_text = GetTextBoxHandle("DethroneFireEnchantDetailStats.SelectTypeWithLv_text");
	StatusBar_Text = GetTextBoxHandle("DethroneFireEnchantDetailStats.StatusBar_Text");
	Proficiency_StatusBar = GetStatusBarHandle("DethroneFireEnchantDetailStats.Proficiency_StatusBar");
	BasicEffect_RichList = GetRichListCtrlHandle("DethroneFireEnchantDetailStats.BasicEffect_RichList");
	AddEffect_RichList = GetRichListCtrlHandle("DethroneFireEnchantDetailStats.AddEffect_RichList");
	Description1MsgWnd = GetWindowHandle("DethroneFireEnchantDetailStats.Description1MsgWnd");
	Description2MsgWnd = GetWindowHandle("DethroneFireEnchantDetailStats.Description2MsgWnd");
	Title3_text = GetTextBoxHandle("DethroneFireEnchantDetailStats.Title3_text");
	BasicEffect_RichList.SetSelectable(false);
	BasicEffect_RichList.SetUseStripeBackTexture(false);
	BasicEffect_RichList.SetAppearTooltipAtMouseX(true);
	BasicEffect_RichList.SetSelectedSelTooltip(false);
	AddEffect_RichList.SetSelectable(false);
	AddEffect_RichList.SetUseStripeBackTexture(false);
	AddEffect_RichList.SetAppearTooltipAtMouseX(true);
	AddEffect_RichList.SetSelectedSelTooltip(false);	
}

function CustomTooltip getBasicEffectTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local UIPacket._EAOF_Element OpenUI_PacketElement;
	local FireAbilityLevelupInfoUIData levelUPData;
	local int i, nMaxLevel;

	OpenUI_PacketElement = DethroneFireEnchantWndScript.getSelectedPacketDataElement();
	nMaxLevel = DethroneFireEnchantWndScript.getSeletedUIData().MaxLevel;
	mCustomTooltip.MinimumWidth = 200;
	// End:0x1B0
	if(nMaxLevel > OpenUI_PacketElement.nLevel)
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13808), string(OpenUI_PacketElement.nLevel + 1)), GTColor().Yellow, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		levelUPData = DethroneFireEnchantWndScript.getSelectedUIDataByLevel(OpenUI_PacketElement.nLevel + 1);
		// End:0x1AD
		if(levelUPData.SkillEffect.Length > 0)
		{
			// End:0x1AD [Loop If]
			for(i = 0; i < levelUPData.SkillEffect.Length / 2; i++)
			{
				drawListArr[drawListArr.Length] = addDrawItemText(levelUPData.SkillEffect[i * 2] $ "  ", GTColor().White, "", true, true);
				drawListArr[drawListArr.Length] = addDrawItemText_DIAT_Right(levelUPData.SkillEffect[(i * 2) + 1], GTColor().ColorDesc, "", false, true);
			}
		}
		levelUPData = DethroneFireEnchantWndScript.getSelectedUIDataByLevel(nMaxLevel);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13842), string(nMaxLevel)), GTColor().Yellow, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		if(levelUPData.SkillEffect.Length > 0)
		{
			for(i = 0; i < (levelUPData.SkillEffect.Length / 2); i++)
			{
				drawListArr[drawListArr.Length] = addDrawItemText(levelUPData.SkillEffect[i * 2] $ "  ", GTColor().White, "", true, true);
				drawListArr[drawListArr.Length] = addDrawItemText_DIAT_Right(levelUPData.SkillEffect[(i * 2) + 1], GTColor().ColorDesc, "", false, true);
			}
		}		
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14331), GTColor().Yellow, "", true, true);
		mCustomTooltip.MinimumWidth = 100;
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;	
}

function CustomTooltip getAddEffectTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local int i, N;
	local array<FireAbilityComboEffectUIData> effectUIData;

	effectUIData = DethroneFireEnchantWndScript.getEffectUIData();

	// End:0x1AA [Loop If]
	for(i = 0; i < effectUIData.Length; i++)
	{
		// End:0x74
		if(i != 0)
		{
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
			drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		}
		drawListArr[drawListArr.Length] = addDrawItemText(effectUIData[i].Title, GTColor().Yellow, "", true, false);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);

		// End:0x1A0 [Loop If]
		for(N = 0; N < effectUIData[i].DescriptionList.Length / 2; N++)
		{
			drawListArr[drawListArr.Length] = addDrawItemText(effectUIData[i].DescriptionList[N * 2] $ "  ", GTColor().White, "", true, true);
			drawListArr[drawListArr.Length] = addDrawItemText_DIAT_Right(effectUIData[i].DescriptionList[(N * 2) + 1], GTColor().ColorDesc, "", false, true);
		}
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 200;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;	
}

function CustomTooltip getEnchantNeedItemTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local ItemInfo mInfo;
	local FireAbilityLevelupInfoUIData levelUPData;
	local int i;

	elementData = DethroneFireEnchantWndScript.getSelectedPacketDataElement();
	levelUPData = DethroneFireEnchantWndScript.getSelectedUIDataByLevel(elementData.nLevel);
	// End:0x85
	if(DethroneFireEnchantChartScript.groupButtons._getSelectButtonIndex() == 0)
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14398), GTColor().Yellow, "", true);		
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14332), GTColor().Yellow, "", true);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);

		// End:0x181 [Loop If]
		for(i = 0; i < levelUPData.ExpUpCostItem.Length; i++)
		{
			mInfo = GetItemInfoByClassID(levelUPData.ExpUpCostItem[i].ItemClassID);
			mInfo.ItemNum = levelUPData.ExpUpCostItem[i].ItemAmount;
			addDrawItemGameItem(drawListArr, mInfo, true);
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		}
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 200;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;	
}

function refresh()
{
	Debug("기본 효과, 추가 효과 폼, refresh" @ string(DethroneFireEnchantChartScript.getSelectedCType()));
	elementData = DethroneFireEnchantWndScript.getPacketDataElement(DethroneFireEnchantChartScript.getSelectedCType());
	Debug("elementData.nLevel" @ string(elementData.nLevel));
	Debug("elementData.nExp" @ string(elementData.nEXP));
	Debug("elementData.nInitCount" @ string(elementData.nInitCount));
	Debug("elementData.nExpUpCount" @ string(elementData.nExpUpCount));
	Title3_text.SetText(GetSystemString(14319) @ "lv." $ string(DethroneFireEnchantWndScript.getSetEffectLevel()));
	BasicEffectHelp_btn.SetTooltipCustomType(getBasicEffectTooltip());
	AddEffectHelp_btn.SetTooltipCustomType(getAddEffectTooltip());
	GoEnchantButton.SetTooltipCustomType(getEnchantNeedItemTooltip());
	setBasicEffectRichlist();
	setAddEffectRichlist();
	setBar();	
}

function string GetFireTypeString(int Type)
{
	local string RValue;

	switch(Type)
	{
		case 0:
			RValue = GetSystemString(14320);
			break;
		case 1:
			RValue = GetSystemString(14323);
			break;
		case 2:
			RValue = GetSystemString(14324);
			break;
		case 3:
			RValue = GetSystemString(14322);
			break;
		case 4:
			RValue = GetSystemString(14321);
			break;
	}
	return RValue;	
}

function setBar()
{
	local UIPacket._EAOF_Element OpenUI_PacketElement;
	local FireAbilityLevelupInfoUIData levelUPData;
	local float per;

	OpenUI_PacketElement = DethroneFireEnchantWndScript.getSelectedPacketDataElement();
	SelectTypeWithLv_text.SetText(DethroneFireEnchantProcessScript.getCTypeTitleSting(DethroneFireEnchantChartScript.getSelectedCType()) @ "Lv." $ string(OpenUI_PacketElement.nLevel));
	levelUPData = DethroneFireEnchantWndScript.getSelectedUIDataByLevel(OpenUI_PacketElement.nLevel);
	Proficiency_StatusBar.SetPoint(OpenUI_PacketElement.nEXP, levelUPData.Exp);
	per = float(ConvertFloatToString((float(OpenUI_PacketElement.nEXP) / float(levelUPData.Exp)) * float(100), 2, false));
	StatusBar_Text.SetText(string0100Per(per) $ "/100");
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x28
		case "BasicEffectHelp_btn":
			OnBasicEffectHelp_btnClick();
			// End:0x67
			break;
		// End:0x47
		case "AddEffectHelp_btn":
			OnAddEffectHelp_btnClick();
			// End:0x67
			break;
		// End:0x64
		case "GoEnchantButton":
			OnGoEnchantButtonClick();
			// End:0x67
			break;
	}	
}

function OnBasicEffectHelp_btnClick();

function OnAddEffectHelp_btnClick();

function OnGoEnchantButtonClick()
{
	GetWindowHandle("DethroneFireEnchantProcess").ShowWindow();
	Me.HideWindow();
	DethroneFireEnchantProcessScript.refresh();	
}

function setBasicEffectRichlist()
{
	local UIPacket._EAOF_Element OpenUI_PacketElement;
	local FireAbilityLevelupInfoUIData levelUPData;
	local int i;

	OpenUI_PacketElement = DethroneFireEnchantWndScript.getSelectedPacketDataElement();
	levelUPData = DethroneFireEnchantWndScript.getSelectedUIDataByLevel(OpenUI_PacketElement.nLevel);
	BasicEffect_RichList.DeleteAllItem();
	// End:0xBA
	if(levelUPData.SkillEffect.Length > 0)
	{
		// End:0xBA [Loop If]
		for(i = 0; i < levelUPData.SkillEffect.Length / 2; i++)
		{
			BasicEffect_RichList.InsertRecord(makeRecord(levelUPData.SkillEffect[i * 2], levelUPData.SkillEffect[(i * 2) + 1]));
		}
	}
	// End:0xE1
	if(BasicEffect_RichList.GetRecordCount() == 0)
	{
		Description1MsgWnd.ShowWindow();		
	}
	else
	{
		Description1MsgWnd.HideWindow();
	}	
}

function setAddEffectRichlist()
{
	local int nSetEffectLevel, i, N, M;
	local array<FireAbilityComboEffectUIData> effectUIData;
	local RichListCtrlRowData Record;
	local bool bModify;

	nSetEffectLevel = DethroneFireEnchantWndScript.getSetEffectLevel();
	effectUIData = DethroneFireEnchantWndScript.getEffectUIData();
	AddEffect_RichList.DeleteAllItem();

	// End:0xF0 [Loop If]
	for(i = 0; i < effectUIData.Length; i++)
	{
		// End:0xE6
		if(nSetEffectLevel >= effectUIData[i].Level)
		{
			// End:0xE6 [Loop If]
			for(N = 0; N < (effectUIData[i].DescriptionList.Length / 2); N++)
			{
				bModify = false;

				for(M = 0; M < AddEffect_RichList.GetRecordCount(); M++)
				{
					AddEffect_RichList.GetRec(M, Record);
					if(effectUIData[i].DescriptionList[N * 2] == Record.szReserved)
					{
						AddEffect_RichList.ModifyRecord(M, makeRecord(effectUIData[i].DescriptionList[N * 2], effectUIData[i].DescriptionList[(N * 2) + 1]));
						bModify = true;
						break;
					}
				}
				// End:0x20F
				if(bModify == false)
				{
					AddEffect_RichList.InsertRecord(makeRecord(effectUIData[i].DescriptionList[N * 2], effectUIData[i].DescriptionList[(N * 2) + 1]));
					Debug("MakeRecord(effectUIData[i].DescriptionList[(n * 2)]" @ effectUIData[i].DescriptionList[N * 2]);
				}
			}
		}
	}
	// End:0x117
	if(AddEffect_RichList.GetRecordCount() == 0)
	{
		Description2MsgWnd.ShowWindow();		
	}
	else
	{
		Description2MsgWnd.HideWindow();
	}	
}

function RichListCtrlRowData makeRecord(string titleString, string numString)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 2;
	Record.szReserved = titleString;
	addRichListCtrlString(Record.cellDataList[0].drawitems, titleString, GTColor().White, false);
	addRichListCtrlString(Record.cellDataList[1].drawitems, numString, GTColor().ColorDesc, false, 20);
	return Record;	
}

defaultproperties
{
}
