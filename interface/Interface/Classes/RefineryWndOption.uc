class RefineryWndOption extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var WindowHandle RefineryWndProbability;
var RichListCtrlHandle List_ListCtrl;
var RichListCtrlHandle ProbabilityList_ListCtrl;
var TextBoxHandle txtInstruction;
var ButtonHandle DetailInfo_BTN;

function OnLoad()
{
	Initialize();
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	List_ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".List_ListCtrl");
	txtInstruction = GetTextBoxHandle(m_WindowName $ ".txtInstruction");
	RefineryWndProbability = GetWindowHandle(m_WindowName $ ".RefineryWndProbability");
	ProbabilityList_ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".ProbabilityList_ListCtrl");
	DetailInfo_BTN = GetButtonHandle(m_WindowName $ ".DetailInfo_BTN");
	List_ListCtrl.SetSelectable(false);
	List_ListCtrl.SetAppearTooltipAtMouseX(true);
	List_ListCtrl.SetSelectedSelTooltip(false);
	ProbabilityList_ListCtrl.SetSelectable(false);
	ProbabilityList_ListCtrl.SetAppearTooltipAtMouseX(true);
	ProbabilityList_ListCtrl.SetSelectedSelTooltip(false);
	toggleProbability(false);
}

function toggleProbability(bool bProbability)
{
	// End:0x53
	if(bProbability)
	{
		RefineryWndProbability.ShowWindow();
		List_ListCtrl.HideWindow();
		txtInstruction.HideWindow();
		DetailInfo_BTN.SetButtonName(13959);
		updateProbabilityList();		
	}
	else
	{
		RefineryWndProbability.HideWindow();
		List_ListCtrl.ShowWindow();
		DetailInfo_BTN.SetButtonName(13960);
		// End:0xAC
		if(List_ListCtrl.GetRecordCount() > 0)
		{
			txtInstruction.HideWindow();			
		}
		else
		{
			txtInstruction.ShowWindow();
		}
	}
}

function updateProbabilityList()
{
	local ItemInfo stoneInfo, TargetInfo;
	local array<VariationProbUIData> Variation1, Variation2;
	local int i, N;
	local string oDesc1, oDesc2, oDesc3, descAll, probabilityStr;

	RefineryWnd(GetScript("RefineryWnd")).GetItemInfoStone(stoneInfo);
	RefineryWnd(GetScript("RefineryWnd")).GetItemInfoTarget(TargetInfo);
	Variation1.Length = 0;
	Variation2.Length = 0;
	class'RefineryAPI'.static.GetOptionProbability(stoneInfo.Id.ClassID, TargetInfo.Id.ClassID, Variation1, Variation2);
	ProbabilityList_ListCtrl.DeleteAllItem();
	// End:0x22A
	if(Variation1.Length > 0)
	{
		// End:0x22A [Loop If]
		for(i = 0; i < Variation1.Length; i++)
		{
			// End:0xF9
			if(i == 0)
			{
				ProbabilityList_ListCtrl.InsertRecord(makeTitleListItem("1" $ GetSystemString(397), ""));
			}

			// End:0x220 [Loop If]
			for(N = 0; N < Variation1[i].Options.Length; N++)
			{
				class'RefineryAPI'.static.GetOptionDescByOptionID(Variation1[i].Options[N].OptionID, oDesc1, oDesc2, oDesc3);
				// End:0x16B
				if(oDesc1 != "")
				{
					descAll = oDesc1;
				}
				// End:0x18E
				if(oDesc2 != "")
				{
					descAll = descAll $ "," $ oDesc2;
				}
				// End:0x1B1
				if(oDesc3 != "")
				{
					descAll = descAll $ "," $ oDesc3;
				}
				descAll = Substitute(descAll, "\\n", " ", false);
				probabilityStr = getInstanceL2Util().CutFloatIntByString(Variation1[i].Options[N].Probablity);
				ProbabilityList_ListCtrl.InsertRecord(makeRecordProbability(descAll, probabilityStr));
			}
		}
	}
	// End:0x3B2
	if(Variation2.Length > 0)
	{
		// End:0x3B2 [Loop If]
		for(i = 0; i < Variation2.Length; i++)
		{
			// End:0x27F
			if(i == 0)
			{
				ProbabilityList_ListCtrl.InsertRecord(makeTitleListItem("2" $ GetSystemString(397), ""));
			}

			// End:0x3A8 [Loop If]
			for(N = 0; N < Variation2[i].Options.Length; N++)
			{
				class'RefineryAPI'.static.GetOptionDescByOptionID(Variation2[i].Options[N].OptionID, oDesc1, oDesc2, oDesc3);
				// End:0x2F1
				if(oDesc1 != "")
				{
					descAll = oDesc1;
				}
				// End:0x315
				if(oDesc2 != "")
				{
					descAll = (descAll $ ", ") $ oDesc2;
				}
				// End:0x339
				if(oDesc3 != "")
				{
					descAll = (descAll $ ", ") $ oDesc3;
				}
				descAll = Substitute(descAll, "\\n", " ", false);
				probabilityStr = getInstanceL2Util().CutFloatIntByString(Variation2[i].Options[N].Probablity);
				ProbabilityList_ListCtrl.InsertRecord(makeRecordProbability(descAll, probabilityStr));
			}
		}
	}
}

function RichListCtrlRowData makeRecordProbability(string Text, string percentStr)
{
	local RichListCtrlRowData RowData;
	local string textShort;

	textShort = Text;
	RowData.cellDataList.Length = 2;
	textShort = makeShortStringByPixel(Text, 210, "..");
	// End:0x4F
	if(textShort != Text)
	{
		RowData.szReserved = Text;
	}
	addRichListCtrlString(RowData.cellDataList[0].drawitems, textShort, GTColor().White, false, 0, 0);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, percentStr, GTColor().White, false, 20, 0);
	return RowData;
}

function RichListCtrlRowData makeTitleListItem(string Str, string percentStr)
{
	local Color applyColor;
	local RichListCtrlRowData RowData;

	RowData.cellDataList.Length = 2;
	RowData.sOverlayTex = "L2UI_EPIC.DethroneWnd.List_HeaderBg_Blue";
	applyColor = GTColor().BrightWhite;
	addRichListCtrlString(RowData.cellDataList[0].drawitems, Str, applyColor, false, 0, 0);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, percentStr, GTColor().White, false, 20, 0);
	RowData.OverlayTexU = 635;
	RowData.OverlayTexV = 26;
	return RowData;
}

function DelIds()
{
	List_ListCtrl.DeleteAllItem();
	txtInstruction.ShowWindow();
	toggleProbability(false);
}

function SetIDs(int stoneClassID, int targetClassID)
{
	local array<string> Options, optionsDetail;
	local int i;

	API_GetOptionDesc(stoneClassID, targetClassID, Options);

	// End:0x52 [Loop If]
	for(i = 0; i < Options.Length; i++)
	{
		Debug("SetList" @ Options[i]);
	}
	List_ListCtrl.DeleteAllItem();

	// End:0xC3 [Loop If]
	for(i = 0; i < Options.Length; i++)
	{
		optionsDetail.Length = 0;
		Split(Options[i], "n", optionsDetail);
		// End:0xB9
		if(optionsDetail.Length > 0)
		{
			setList(optionsDetail, i + 1);
		}
	}
}

function setList(array<string> Options, int Quality)
{
	local int i;

	// End:0x97 [Loop If]
	for(i = 0; i < Options.Length; i++)
	{
		// End:0x56
		if(Right(Options[i], 1) == "\\")
		{
			Options[i] = Left(Options[i], Len(Options[i]) - 1);
		}
		// End:0x8D
		if(Options[i] != "")
		{
			List_ListCtrl.InsertRecord(makeRecord(Options[i], Quality));
		}
	}
	// End:0xB3
	if(RefineryWndProbability.IsShowWindow())
	{
		toggleProbability(false);		
	}
	else
	{
		toggleProbability(true);
	}
}

function Toggle()
{
	// End:0x24
	if(Me.IsShowWindow())
	{
		Me.HideWindow();
	}
	else
	{
		Me.ShowWindow();
		Me.SetFocus();
	}
}

event OnClickButton(string strID)
{
	Debug("OnClickButton" @ strID);
	// End:0x59
	if(strID == "DetailInfo_BTN")
	{
		// End:0x52
		if(RefineryWndProbability.IsShowWindow())
		{
			toggleProbability(false);			
		}
		else
		{
			toggleProbability(true);
		}
	}
}

function RichListCtrlRowData makeRecord(string Option, int Quality)
{
	local RichListCtrlRowData Record;
	local Color tmpTextColor;
	local string optionResult;
	local int R, G, B;

	Record.cellDataList.Length = 1;
	ToolTip(GetScript("Tooltip")).GetRefineryColor(Quality, R, G, B);
	tmpTextColor = GetColor(R, G, B, 255);
	optionResult = makeShortStringByPixel(Option, 320, "..");
	// End:0x92
	if(optionResult != Option)
	{
		Record.szReserved = Option;
	}
	addRichListCtrlString(Record.cellDataList[0].drawitems, optionResult, tmpTextColor, false);
	return Record;
}

function bool API_GetOptionDesc(int TargetItemClassID, int targetClassID, out array<string> Options)
{
	local string str1, str2, str3, str4;
	local bool optionExist;

	optionExist = class'RefineryAPI'.static.GetOptionDesc(TargetItemClassID, targetClassID, str1, str2, str3, str4);
	Options[0] = str1;
	Options[1] = str2;
	Options[2] = str3;
	Options[3] = str4;
	return optionExist;
}

defaultproperties
{
}
