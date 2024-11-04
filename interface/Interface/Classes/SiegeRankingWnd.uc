class SiegeRankingWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var ButtonHandle btnClose;
var TextBoxHandle Descriptext;
var array<string> arrRankData;
var bool bFlag;
var RichListCtrlHandle Ranking_RichList;

function Initialize()
{
	Me = GetWindowHandle(m_WindowName);
	btnClose = GetButtonHandle(m_WindowName $ ".SiegeMercenaryClose_Btn");
	Ranking_RichList = GetRichListCtrlHandle(m_WindowName $ ".Ranking_RichList");
	Descriptext = GetTextBoxHandle(m_WindowName $ ".Descriptext");
	Ranking_RichList.SetAppearTooltipAtMouseX(true);
	Ranking_RichList.SetSelectedSelTooltip(false);
	bFlag = false;	
}

function OnRegisterEvent()
{
	RegisterEvent(EV_MCW_CastleSiegeAttackerListStart);
	RegisterEvent(EV_MCW_CastleSiegeAttackerListItem);
	RegisterEvent(EV_MCW_CastleSiegeAttackerListEnd);
	RegisterEvent(EV_MCW_CastleSiegeDefenderListStart);
	RegisterEvent(EV_MCW_CastleSiegeDefenderListItem);
	RegisterEvent(EV_MCW_CastleSiegeDefenderListEnd);	
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();	
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x21
		case EV_MCW_CastleSiegeAttackerListStart:
			// End:0x1E
			if(bFlag)
			{
				HandleSiegeInfoAttackerStart();
			}
			// End:0x92
			break;
		// End:0x40
		case EV_MCW_CastleSiegeAttackerListItem:
			// End:0x3D
			if(bFlag)
			{
				HandleSiegeInfoAttackerList(param);
			}
			// End:0x92
			break;
		// End:0x4B
		case EV_MCW_CastleSiegeAttackerListEnd:
			// End:0x92
			break;
		// End:0x56
		case EV_MCW_CastleSiegeDefenderListStart:
			// End:0x92
			break;
		// End:0x75
		case EV_MCW_CastleSiegeDefenderListItem:
			// End:0x72
			if(bFlag)
			{
				HandleSiegeInfoDefenderList(param);
			}
			// End:0x92
			break;
		// End:0x8F
		case EV_MCW_CastleSiegeDefenderListEnd:
			// End:0x8C
			if(bFlag)
			{
				HandleSiegeInfoDefenderEnd();
			}
			// End:0x92
			break;
	}	
}

function HandleSiegeInfoAttackerStart()
{
	arrRankData.Remove(0, arrRankData.Length);
	Ranking_RichList.DeleteAllItem();
	Descriptext.ShowWindow();	
}

function HandleSiegeInfoAttackerList(string param)
{
	local int point;

	ParseInt(param, "CurrentPledgeSiegePoint", point);
	// End:0x56
	if(point > 0)
	{
		arrRankData.Insert(arrRankData.Length, 1);
		arrRankData[arrRankData.Length - 1] = param;
	}	
}

function HandleSiegeInfoAttackerEnd();

function HandleSiegeInfoDefenderStart();

function HandleSiegeInfoDefenderList(string param)
{
	local int point;

	ParseInt(param, "CurrentPledgeSiegePoint", point);
	// End:0x56
	if(point > 0)
	{
		arrRankData.Insert(arrRankData.Length, 1);
		arrRankData[arrRankData.Length - 1] = param;
	}	
}

function HandleSiegeInfoDefenderEnd()
{
	local int i, TOTALLEN;
	local string PledgeName;
	local int nCurrentPledgeSiegePoint;

	TOTALLEN = 3;
	arrRankData.Sort(SortByNumberDelegate);
	// End:0x31
	if(arrRankData.Length == 0)
	{
		Descriptext.ShowWindow();		
	}
	else
	{
		Descriptext.HideWindow();
		// End:0x59
		if(arrRankData.Length < 3)
		{
			TOTALLEN = arrRankData.Length;
		}

		// End:0xE2 [Loop If]
		for(i = 0; i < TOTALLEN; i++)
		{
			ParseString(arrRankData[i], "PledgeName", PledgeName);
			ParseInt(arrRankData[i], "CurrentPledgeSiegePoint", nCurrentPledgeSiegePoint);
			addRichListItemAmount(i + 1, PledgeName, nCurrentPledgeSiegePoint);
		}
	}
	bFlag = false;	
}

delegate int SortByNumberDelegate(string aParam, string bparam)
{
	local int aPoint, bPoint;

	ParseInt(aParam, "CurrentPledgeSiegePoint", aPoint);
	ParseInt(bparam, "CurrentPledgeSiegePoint", bPoint);
	// End:0x67
	if(aPoint < bPoint)
	{
		return -1;
	}
	return 0;	
}

function addRichListItemAmount(int Rank, string PledgeName, int sc)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 3;
	Record.nReserved1 = Rank;
	addRichListCtrlString(Record.cellDataList[0].drawitems, string(Rank), GTColor().BWhite, false, 0, 0);
	addRichListCtrlString(Record.cellDataList[1].drawitems, PledgeName, GTColor().BWhite, false, 0, 0);
	addRichListCtrlString(Record.cellDataList[2].drawitems, MakeFullSystemMsg(GetSystemMessage(13712), string(sc)), GTColor().BWhite, false, 0, 0);
	Ranking_RichList.InsertRecord(Record);	
}

function OnClickButton(string btnName)
{
	switch(btnName)
	{
		// End:0x59
		case "SiegeMercenaryClose_Btn":
			// End:0x47
			if(Me.IsShowWindow())
			{
				Me.HideWindow();				
			}
			else
			{
				Me.ShowWindow();
			}
			// End:0x5C
			break;
	}	
}

function int GetCastleID()
{
	local SiegeWnd siegeWndScript;

	siegeWndScript = SiegeWnd(GetScript("SiegeWnd"));
	return siegeWndScript.castleIDs[siegeWndScript.SelectedIndex];	
}

function OnShow()
{
	API_RequestMCWCastleSiegeAttackerList(GetCastleID());
	API_RequestMCWCastleSiegeDefenderList(GetCastleID());
	bFlag = true;	
}

function API_RequestMCWCastleSiegeAttackerList(int tmpCastleID)
{
	// End:0x1F
	if(tmpCastleID > 0)
	{
		class'SiegeAPI'.static.RequestMCWCastleSiegeAttackerList(tmpCastleID);
	}	
}

function API_RequestMCWCastleSiegeDefenderList(int tmpCastleID)
{
	// End:0x1F
	if(tmpCastleID > 0)
	{
		class'SiegeAPI'.static.RequestMCWCastleSiegeDefenderList(tmpCastleID);
	}	
}

defaultproperties
{
     m_WindowName="SiegeRankingWnd"
}
