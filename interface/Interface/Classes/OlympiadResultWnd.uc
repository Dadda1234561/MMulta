//------------------------------------------------------------------------------------------------------------------------
//
// 제목       : 올림피아드 결과창
// 특징       : 리스트 컨트롤, 클래식
// 빌드       : 캐릭터 A, B, 필요
	//변경 레벨 70
	//클래스 88
	
	//olympiad set_match_day 5 1 2 3 4 5
	//olympiad min_match_count 2
	//olympiad start_match_time 10 00
	//생성 1031688


//------------------------------------------------------------------------------------------------------------------------
class OlympiadResultWnd extends UICommonAPI;

// 창 닫히는 시간 타이머
const TIMER_ID = 148;
const TIMER_DELAY = 20000;

enum OLYMPIAD_PACKET_TYPE
{
	GO_GAME_LIST,
	GO_GAME_RESULT,
	GO_GAME_RESULT_V2,
	GO_GAME_RESULT_TEAM,
	GO_MAX
};

struct ResultDataStruct
{
	var string pcName;
	var int TeamColor;
	var int ClassName;
	var string ClanName;
	var int clanID;
	var int totalDamage;
	var int currentPoint;
	var int GetPoint;
	var string resultString;
	var int OlympiadPacketType;
};

struct WinnerDataStruct
{
	var string winnerName;
	var int TeamColor;
	var int winMemberNum;
	var int loseMemberNum;
};

// 윈도우 공통
var string m_WindowName;
var WindowHandle Me;

// 리치 리스트
var RichListCtrlHandle ListCtrl;

function OnRegisterEvent()
{
	RegisterEvent(EV_ReceiveOlympiadResult);
}

function OnLoad()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	SetClosingOnESC();
	ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".OlympiadArenaList_ListCtrl");
	ListCtrl.SetUseHorizontalScrollBar(true);
	ListCtrl.SetColumnMinimumWidth(true);

	HandleResultDraw();
}

function OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		// End:0xA5
		case EV_ReceiveOlympiadResult: //5081
			Debug("my EV_ReceiveOlympiadResult:" @ string(Event_ID) @ a_Param);
			ListCtrl.DeleteAllItem();
			GetTextBoxHandle(m_WindowName $ ".resultTxt_textbox").SetText(GetSystemString(846));
			HandleResultLists(a_Param);
			Me.ShowWindow();
			// End:0xA8
			break;
	}
}

function OnShow()
{
	Me.SetTimer(TIMER_ID, TIMER_DELAY);
}

function OnHide()
{
	HandleResultDraw();
	Me.KillTimer(TIMER_ID);
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case TIMER_ID:
			Me.HideWindow();
			// End:0x21
			break;
	}
}

function OnClickButton(string strID)
{
	Me.HideWindow();
}

function HandleResultLists(string a_Param)
{
	local ResultDataStruct resultData;
	local WinnerDataStruct winnerData;
	local int i, nOlympiadPacketType;

	ParseString(a_Param, "winnerName", winnerData.winnerName);
	ParseInt(a_Param, "teamColor", winnerData.TeamColor);
	ParseInt(a_Param, "winMemberNum", winnerData.winMemberNum);
	ParseInt(a_Param, "loseMemberNum", winnerData.loseMemberNum);
	ParseInt(a_Param, "OlympiadPacketType", nOlympiadPacketType);
	resultData.OlympiadPacketType = nOlympiadPacketType;
	Debug("HandleResultLists a_param" @ a_Param);
	ListCtrl.SetColumnString(4, 2293);

	for (i = 0; i < winnerData.winMemberNum; i++)
	{
		ParseString(a_Param, "winPcName" $ string(i), resultData.pcName);
		ParseInt(a_Param, "winTeamColor" $ string(i), resultData.TeamColor);
		ParseString(a_Param, "winClanName" $ string(i), resultData.ClanName);
		ParseInt(a_Param, "winClanID" $ string(i), resultData.clanID);
		ParseInt(a_Param, "winClassName" $ string(i), resultData.ClassName);
		ParseInt(a_Param, "winTotalDamage" $ string(i), resultData.totalDamage);
		ParseInt(a_Param, "winCurrentPoint" $ string(i), resultData.currentPoint);
		ParseInt(a_Param, "winGetPoint" $ string(i), resultData.GetPoint);

		// End:0x2D6
		if(winnerData.winnerName == "")
		{
			resultData.resultString = GetSystemString(846);
		}
		else
		{
			resultData.resultString = GetSystemString(828);
		}

		// End:0x31B
		if(winnerData.TeamColor == resultData.TeamColor)
		{
			HandleResultIsVictory(winnerData,nOlympiadPacketType == OLYMPIAD_PACKET_TYPE.GO_GAME_RESULT_TEAM);
		}

		HandleResultList(resultData);
	}

	for (i = 0; i < winnerData.loseMemberNum; i++)
	{
		ParseString(a_Param, "losePcName" $ string(i), resultData.pcName);
		ParseInt(a_Param, "loseTeamColor" $ string(i), resultData.TeamColor);
		ParseString(a_Param, "loseClanName" $ string(i), resultData.ClanName);
		ParseInt(a_Param, "loseClanID" $ string(i), resultData.clanID);
		ParseInt(a_Param, "loseClassName" $ string(i), resultData.ClassName);
		ParseInt(a_Param, "loseTotalDamage" $ string(i), resultData.totalDamage);
		ParseInt(a_Param, "loseCurrentPoint" $ string(i), resultData.currentPoint);
		ParseInt(a_Param, "loseGetPoint" $ string(i), resultData.GetPoint);
		// End:0x4DA
		if(winnerData.winnerName == "")
		{
			resultData.resultString = GetSystemString(846);			
		}
		else
		{
			resultData.resultString = GetSystemString(2356);
		}

		// End:0x51F
		if(winnerData.TeamColor == resultData.TeamColor)
		{
			HandleResultIsVictory(winnerData,nOlympiadPacketType == OLYMPIAD_PACKET_TYPE.GO_GAME_RESULT_TEAM);
		}
		HandleResultList(resultData);
	}
}

function HandleResultList(ResultDataStruct resultData)
{
	local RichListCtrlRowData RowData;
	local Color TeamColor;
	local string pointString;
	local Texture PledgeCrestTexture, PledgeAllianceCrestTexture;
	local int clanTexturesNum;

	if (resultData.OlympiadPacketType == OLYMPIAD_PACKET_TYPE.GO_GAME_RESULT_TEAM)
	{
		TeamColor = Get3vs3OlympiadTeamColor(resultData.TeamColor);		
	}
	else
	{
		TeamColor = GetOlympiadTeamColor(resultData.TeamColor);
	}
	RowData.cellDataList.Length = 5;
	RowData.cellDataList[0].szData = resultData.pcName;

	/***********************************************************  pcName  ******************************************************************/
	RowData.cellDataList[0].drawitems.Length = 1;
	RowData.cellDataList[0].drawitems[0].eType = LCDIT_TEXT;
	RowData.cellDataList[0].drawitems[0].strInfo.strData = resultData.pcName;
	RowData.cellDataList[0].drawitems[0].strInfo.strColor = TeamColor;
	RowData.cellDataList[0].drawitems[0].strInfo.bStrNewLine = false;

	/***********************************************************  클래스 정보 ******************************************************************/
	RowData.cellDataList[1].drawitems.Length = 1;
	RowData.cellDataList[1].drawitems[0].eType = LCDIT_TEXT;
	RowData.cellDataList[1].drawitems[0].strInfo.strData = GetClassType(resultData.ClassName);
	RowData.cellDataList[1].drawitems[0].strInfo.strColor = TeamColor;
	RowData.cellDataList[1].drawitems[0].strInfo.bStrNewLine = false;

	/***********************************************************  혈맹 정보  ******************************************************************/	
	RowData.cellDataList[2].drawitems.Length = 3;
	clanTexturesNum = 0;
	// 동맹 먼저 ( 작다  ) 
	// bPledgeAllianceCrestTextureLoaded = ;
	if(class'UIDATA_CLAN'.static.GetAllianceCrestTexture(resultData.clanID, PledgeAllianceCrestTexture))
	{
		RowData.cellDataList[2].drawitems[clanTexturesNum].eType = LCDIT_TEXTURE;
		RowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.sTex = string(PledgeAllianceCrestTexture) ;// "img://a" $ resultData.bloodAllianceName;
		RowData.cellDataList[2].drawitems[clanTexturesNum].nPosX = 0;
		RowData.cellDataList[2].drawitems[clanTexturesNum].nPosY = 0;
		RowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.Width = 14;
		RowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.Height = 14;
		RowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.UL = 14;
		RowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.VL = 14;
		clanTexturesNum++ ;
	}
	// 그다음 혈맹 
	// bPledgeCrestTextureLoaded = ;
	if(class'UIDATA_CLAN'.static.GetCrestTexture(resultData.clanID, PledgeCrestTexture))
	{
		RowData.cellDataList[2].drawitems[clanTexturesNum].eType = LCDIT_TEXTURE;
		RowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.sTex = string(PledgeCrestTexture); //"img://p" $ resultData.bloodAllianceImage;	
		RowData.cellDataList[2].drawitems[clanTexturesNum].nPosX = 0;
		RowData.cellDataList[2].drawitems[clanTexturesNum].nPosY = 0;
		RowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.Width = 14;
		RowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.Height = 14;
		RowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.UL = 14;
		RowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.VL = 14;
		clanTexturesNum++ ;
	}
	RowData.cellDataList[2].drawitems[clanTexturesNum].eType = LCDIT_TEXT;
	RowData.cellDataList[2].drawitems[clanTexturesNum].strInfo.strData = resultData.ClanName;
	RowData.cellDataList[2].drawitems[clanTexturesNum].strInfo.strColor = TeamColor;
	RowData.cellDataList[2].drawitems[clanTexturesNum].strInfo.bStrNewLine = false;

	/***********************************************************  총 데미지  ******************************************************************/
	RowData.cellDataList[3].drawitems.Length = 1;
	RowData.cellDataList[3].drawitems[0].eType = LCDIT_TEXT;
	RowData.cellDataList[3].drawitems[0].strInfo.strData = string(resultData.totalDamage);
	RowData.cellDataList[3].drawitems[0].strInfo.strColor = TeamColor;
	RowData.cellDataList[3].drawitems[0].strInfo.bStrNewLine = false;
	RowData.cellDataList[4].drawitems.Length = 2;
	// End:0x5DA
	if(resultData.GetPoint > 0)
	{
		pointString = string(resultData.currentPoint) $ "[+" $ string(resultData.GetPoint) $ "]";		
	}
	else
	{
		pointString = string(resultData.currentPoint) $ "[" $ string(resultData.GetPoint) $ "]";
	}
	RowData.cellDataList[4].szData = pointString;
	RowData.cellDataList[4].drawitems[1].eType = LCDIT_TEXT;
	RowData.cellDataList[4].drawitems[1].strInfo.strData = pointString;
	RowData.cellDataList[4].drawitems[1].strInfo.strColor = TeamColor;
	RowData.cellDataList[4].drawitems[1].strInfo.bStrNewLine = False;
	RowData.cellDataList[4].drawitems[1].nPosX = 16;
	/***********************************************************  얻은 포인트  ******************************************************************/
	// End:0x6D3
	if(resultData.OlympiadPacketType == 3)
	{		
	}
	else
	{
		RowData.cellDataList[4].drawitems[0].eType = LCDIT_TEXTURE;
	}
	// End:0x747
	if(resultData.GetPoint > 0)
	{
		RowData.cellDataList[4].drawitems[0].texInfo.sTex = "L2UI_CT1.Clan.clan_DF_warlist_arrow2";		
	}
	else if(resultData.GetPoint < 0)
	{
		RowData.cellDataList[4].drawitems[0].texInfo.sTex = "L2UI_CT1.Clan.clan_DF_warlist_arrow4";
	}

	RowData.cellDataList[4].drawitems[0].nPosX = 0;
	RowData.cellDataList[4].drawitems[0].nPosY = 0;
	RowData.cellDataList[4].drawitems[0].texInfo.Width = 14;
	RowData.cellDataList[4].drawitems[0].texInfo.Height = 14;
	RowData.cellDataList[4].drawitems[0].texInfo.UL = 14;
	RowData.cellDataList[4].drawitems[0].texInfo.VL = 14;
	ListCtrl.InsertRecord(RowData);	
}

function HandleResultDraw()
{
	local HtmlHandle resultText;
	local string resultString, htmlAdd;
	local Rect rectWnd;

	resultText = GetHtmlHandle(m_WindowName $ ".resultTxt_textbox");
	resultString = GetSystemString(846);
	resultString = htmlAddText(resultString, "hs16", "DCDCDC");

	rectWnd = resultText.GetRect();
	htmlAdd = htmlAddTableTD(resultString, "center", "center", rectWnd.nWidth, 0, "", true);
	htmlSetTableTR(htmlAdd);
	htmlAdd = "<table width=" $ rectWnd.nWidth $ " height=" $ rectWnd.nHeight $ ">" $ htmlAdd $  "</table>";
	resultText.LoadHtmlFromString(htmlSetHtmlStart(htmlAdd));
}

function HandleResultIsVictory(WinnerDataStruct winnerData, bool bTeam3vs3)
{
	local HtmlHandle resultText;
	local string resultString1, resultString2, htmlAdd, colorStr;
	local Rect rectWnd;

	resultText = GetHtmlHandle(m_WindowName $ ".resultTxt_textbox");

	if(winnerData.winnerName == "")
	{
		return;
	}

	resultString1 = winnerData.winnerName;
	// End:0xA1
	if(bTeam3vs3)
	{
		resultString2 = GetSystemString(13236);
		switch(winnerData.TeamColor)
		{
			case 1:
				colorStr = "66AAEE";
				break;
			case 2:
				colorStr = "EE7777";
				break;
		}
	}
	else
	{
		resultString2 = GetSystemString(828);
		switch (winnerData.TeamColor)
		{
			case 1:
				colorStr = "EE7777";
				break;
			case 2:
				colorStr = "66AAEE";
				break;
		}
	}
	resultString1 = htmlAddText(resultString1, "hs16", colorStr);
	resultString2 = htmlAddText(resultString2, "hs16", "DCDCDC");
	
	rectWnd = resultText.GetRect();

	// align 들이 TD 자체의 정렬이며, 
	// TD 안의 텍스트 필드의 정렬을 의미 하는 것이 아니므로, 
	// > height를 0으로 맞춘다.
	// > 혹은 TD 내부에 정렬을 설정 한다. 
	htmlAdd = htmlAddTableTD(resultString1 @ resultString2, "center", "center", rectWnd.nWidth, 0, "", true);
	htmlSetTableTR(htmlAdd);
	htmlAdd = "<table width=" $ rectWnd.nWidth $ " height=" $ rectWnd.nHeight $ ">" $ htmlAdd $  "</table>";
	resultText.LoadHtmlFromString(htmlSetHtmlStart(htmlAdd));
}

/**************************************************************************
 * Util
 **************************************************************************/

function Color GetOlympiadTeamColor (int TeamColor)
{
	switch (TeamColor)
	{
		// End:0x1D
		case 1:
			return GetColor(238, 119, 119, 255);
			// End:0x49
			break;
		// End:0x34
		case 2:
			return GetColor(102, 170, 238, 255);
			// End:0x49
			break;
		// End:0xFFFF
		default:
			return GetColor(102, 170, 238, 255);
			// End:0x49
			break;
	}
	return GetColor(220, 220, 220, 255);
}

function Color Get3vs3OlympiadTeamColor(int TeamColor)
{
	switch(TeamColor)
	{
		// End:0x1D
		case 1:
			return GetColor(102, 170, 238, 255);
			break;
		case 2:
			return GetColor(238, 119, 119, 255);
			break;
		// End:0xFFFF
		default:
			return GetColor(102, 170, 238, 255);
			break;
	}
	return GetColor(220, 220, 220, 255);
}



/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
}
