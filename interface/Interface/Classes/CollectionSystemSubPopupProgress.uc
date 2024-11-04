class CollectionSystemSubPopupProgress extends UICommonAPI;

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var CollectionSystem collectionSystemScript;
var RichListCtrlHandle List_ListCtrl;
var TextBoxHandle ANum00_txt;
var TextBoxHandle ANum01_txt;
var TextBoxHandle ANum02_txt;
var TextBoxHandle BNum00_txt;
var TextBoxHandle BNum01_txt;
var CollectionSystemProgressComponent ProgressCollectionComplete_wndScript;
var CollectionSystemProgressComponent ProgressItemComplete_wndScript;
var array<CollectionSystemProgressComponent> collectionSystemProgressComponents;

function InitProgressComponents()
{
	local string _progressWindowName;

	_progressWindowName = m_WindowName $ ".ProgressCollectionComplete_wnd";
	GetWindowHandle(_progressWindowName).SetScript("CollectionSystemProgressComponent");
	ProgressCollectionComplete_wndScript = CollectionSystemProgressComponent(GetWindowHandle(_progressWindowName).GetScript());
	ProgressCollectionComplete_wndScript.Init(_progressWindowName);
	_progressWindowName = m_WindowName $ ".ProgressItemComplete_wnd";
	GetWindowHandle(_progressWindowName).SetScript("CollectionSystemProgressComponent");
	ProgressItemComplete_wndScript = CollectionSystemProgressComponent(GetWindowHandle(_progressWindowName).GetScript());
	ProgressItemComplete_wndScript.Init(_progressWindowName);
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	util = L2Util(GetScript("L2Util"));
	collectionSystemScript = CollectionSystem(GetScript("CollectionSystem"));
	List_ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".List_ListCtrl");
	List_ListCtrl.SetTooltipType("CollectionSystemOptionListTooltip");
	ANum00_txt = GetTextBoxHandle(m_WindowName $ ".PopupProgressContents.ANum00_txt");
	ANum01_txt = GetTextBoxHandle(m_WindowName $ ".PopupProgressContents.ANum01_txt");
	ANum02_txt = GetTextBoxHandle(m_WindowName $ ".PopupProgressContents.ANum02_txt");
	BNum00_txt = GetTextBoxHandle(m_WindowName $ ".PopupProgressContents.BNum00_txt");
	BNum01_txt = GetTextBoxHandle(m_WindowName $ ".PopupProgressContents.BNum01_txt");
	InitProgressComponents();
	ProgressCollectionComplete_wndScript.SetPoint(100, 100);
	ProgressItemComplete_wndScript.SetPoint(100, 100);
	SetProgressCollection(100, 100, 0);
	SetProgressItem(100, 100);
	List_ListCtrl.SetSelectable(false);
	List_ListCtrl.SetSelectedSelTooltip(false);
	List_ListCtrl.SetUseStripeBackTexture(false);
	List_ListCtrl.SetAppearTooltipAtMouseX(true);
}

function SetProgressCollection(int numTotal, int numCompleted, int numProgress)
{
	local int numNotGo;

	numNotGo = (numTotal - numProgress) - numCompleted;
	ANum00_txt.SetText(((string(numNotGo) @ "(") $ string(int((float(numNotGo) / float(numTotal)) * float(100)))) $ "%)");
	ANum01_txt.SetText(((string(numProgress) @ "(") $ string(int((float(numProgress) / float(numTotal)) * float(100)))) $ "%)");
	ANum02_txt.SetText(((string(numCompleted) @ "(") $ string(int((float(numCompleted) / float(numTotal)) * float(100)))) $ "%)");
	ProgressCollectionComplete_wndScript.SetPoint(numCompleted, numTotal);
}

function SetProgressItem(int numTotal, int numCompleted)
{
	local int numNotGo;

	numNotGo = numTotal - numCompleted;
	BNum00_txt.SetText(((string(numNotGo) @ "(") $ string(int((float(numNotGo) / float(numTotal)) * float(100)))) $ "%)");
	BNum01_txt.SetText(((string(numCompleted) @ "(") $ string(int((float(numCompleted) / float(numTotal)) * float(100)))) $ "%)");
	ProgressItemComplete_wndScript.SetPoint(numCompleted, numTotal);
}

event OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_Restart);
}

event OnLoad()
{
	Initialize();
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_GamingStateEnter:
			if(ChkSerVer())
			{
				HandleGameInit();
			}
			break;
		// End:0x2F
		case EV_Restart:
			if(ChkSerVer())
			{
			}
			break;
	}
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "Close_Btn":
			switch(collectionSystemScript.CurrentState)
			{
				case collectionSystemScript.collectionState.subProgress:
					collectionSystemScript.SetState(collectionSystemScript.collectionState.Sub);
					break;
				case collectionSystemScript.collectionState.mainProgress:
					collectionSystemScript.SetState(collectionSystemScript.collectionState.stand);
					break;
			}
			break;
	}
}

event OnShow()
{
	collectionSystemScript.C_EX_COLLECTION_SUMMARY();
}

function HandleGameInit()
{
	if(GetGameStateName() != "GAMINGSTATE")
	{
		return;
	}
}

function SetCollectionOptions()
{
	local int i, j;
	local array<CollectionOption> Options;
	local array<int> collectionIds;
	local CollectionData cdata;

	List_ListCtrl.DeleteAllItem();
	collectionSystemScript.API_GetCollectionOption(Options);

	for(i = 0; i < Options.Length; i++)
	{
		InsertList(Options[i], 0);
	}
	collectionSystemScript.API_GetCompletePeriodCollection(collectionIds);

	for(i = 0; i < collectionIds.Length; i++)
	{
		collectionSystemScript.API_GetCollectionData(collectionIds[i], cdata);

		for(j = 0; j < cdata.Option_filter.Length; j++)
		{
			InsertList(cdata.Option_filter[j], collectionIds[i], cdata.Period);
		}
	}
}

function InsertList(CollectionOption Option, int collectionid, optional int Period)
{
	local RichListCtrlRowData Record;

	Record = makeRecord(Option, collectionid, Period);
	List_ListCtrl.InsertRecord(Record);
}

function RichListCtrlRowData makeRecord(CollectionOption Option, int collectionid, int Period)
{
	local RichListCtrlRowData Record;

	Record.nReserved1 = collectionid;
	Record.cellDataList.Length = 2;
	Record.cellDataList[0].szData = Option.Name;
	// End:0xA7
	if(Period > 0)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_ct1.DailyMissionWnd.DailyMissionWnd_IconTime", 11, 11);
		Record.nReserved2 = Period;
	}
	addRichListCtrlString(Record.cellDataList[0].drawitems, Record.cellDataList[0].szData, util.White);
	// End:0x148
	if(Option.diff)
	{
		// End:0x125
		if(Option.Value > 0)
		{
			Record.cellDataList[1].szData = "+" $ string(int(Option.Value));			
		}
		else
		{
			Record.cellDataList[1].szData = string(int(Option.Value));
		}		
	}
	else
	{
		// End:0x18F
		if(Option.Value > 0)
		{
			Record.cellDataList[1].szData = "+" $ getInstanceL2Util().CutFloatDecimalPlaces(Option.Value, 1);			
		}
		else if(Option.Value < 0)
		{
			Record.cellDataList[1].szData = "-" $ getInstanceL2Util().CutFloatDecimalPlaces(- Option.Value, 1);
		}
	}
	addRichListCtrlString(Record.cellDataList[1].drawitems, Record.cellDataList[1].szData, util.Yellow, false);
	return Record;
}

function bool ChkSerVer()
{
	return getInstanceUIData().getIsLiveServer();
}

defaultproperties
{
}
