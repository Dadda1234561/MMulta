//================================================================================
// OlympiadRandomChallengeWnd.
//================================================================================

class OlympiadRandomChallengeWnd extends UICommonAPI;

const TIMER_CLICK2 = 99900;
const TIMER_CLICK = 99906;
const TIMER_DELAYC = 3000;

enum GameRuleType
{
	GRT_TEAM,
	GRT_CLASSLESS,
	GRT_CLASS,
	GRT_MAX
};

var WindowHandle Me;
var WindowHandle DisableWnd;
var WindowHandle MyScore_LastWeek_DisableWnd;
var TextBoxHandle MyScoreTitle_Text;
var TextBoxHandle MyScoreWeekTitle_Text;
var TextBoxHandle MyClass_Text;
var TextBoxHandle MyScore_Text;
var TextBoxHandle WinTitle_Text;
var TextBoxHandle WinNumber_Text;
var TextBoxHandle MyScore_LastWeek_Title_Text;
var TextBoxHandle MyClass_lastWeek_Text;
var TextBoxHandle Grade_lastWeek_Text;
var TextBoxHandle AllRankingTitle_lastWeek_Text;
var TextBoxHandle AllRanking_lastWeek_Text;
var TextBoxHandle AllClassRankingTitle_lastWeek_Text;
var TextBoxHandle AllClassRanking_lastWeek_Text;
var TextBoxHandle ServerClassRankingTitle_lastWeek_Text;
var TextBoxHandle ServerClassRanking_lastWeek_Text;
var TextBoxHandle ScoreTitle_lastWeek_Text;
var TextBoxHandle Score_lastWeek_Text;
var TextBoxHandle WinTitle_lastWeek_Text;
var TextBoxHandle Win_lastWeek_Text;
var TextBoxHandle LostTitle_lastWeek_Text;
var TextBoxHandle Lost_lastWeek_Text;
var TextBoxHandle Time_text;
var TextBoxHandle State_text;
var TextureHandle StateICON_Texture;
var TextBoxHandle StandbyStatus_text;
var TextBoxHandle GamesNumber_text;
var ButtonHandle ApplyCancel_Btn;
var ButtonHandle Refresh_Btn;
var bool SaveOpen;
var int Registered;
var int IsPeaceZone;
var int bOpen;

function OnRegisterEvent()
{
	RegisterEvent(EV_OlympiadInfo);
	RegisterEvent(EV_OlympiadRecord);
	RegisterEvent(EV_SetRadarZoneCode);
	RegisterEvent(EV_OlympiadMatchMakingResult);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function OnShow()
{
	if (GetWindowHandle("OlympiadWnd").IsShowWindow())
	{
		GetWindowHandle("OlympiadWnd").HideWindow();
	}
}

function Initialize()
{
	Me = GetWindowHandle("OlympiadRandomChallengeWnd");
	DisableWnd = GetWindowHandle("OlympiadRandomChallengeWnd.DisableWnd");
	MyScore_LastWeek_DisableWnd = GetWindowHandle("OlympiadRandomChallengeWnd.MyScore_LastWeek_DisableWnd");
	MyScoreTitle_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.MyScoreTitle_Text");
	MyScoreWeekTitle_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.MyScoreWeekTitle_Text");
	MyClass_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.MyClass_Text");
	MyScore_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.MyScore_Text");
	WinTitle_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.WinTitle_Text");
	WinNumber_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.WinNumber_Text");
	MyScore_LastWeek_Title_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.MyScore_LastWeek_Title_Text");
	MyClass_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.MyClass_lastWeek_Text");
	Grade_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.Grade_lastWeek_Text");
	AllRankingTitle_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.AllRankingTitle_lastWeek_Text");
	AllRanking_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.AllRanking_lastWeek_Text");
	AllClassRankingTitle_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.AllClassRankingTitle_lastWeek_Text");
	AllClassRanking_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.AllClassRanking_lastWeek_Text");
	ServerClassRankingTitle_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.ServerClassRankingTitle_lastWeek_Text");
	ServerClassRanking_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.ServerClassRanking_lastWeek_Text");
	ScoreTitle_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.ScoreTitle_lastWeek_Text");
	Score_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.Score_lastWeek_Text");
	WinTitle_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.WinTitle_lastWeek_Text");
	Win_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.Win_lastWeek_Text");
	LostTitle_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.LostTitle_lastWeek_Text");
	Lost_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.Lost_lastWeek_Text");
	Time_text = GetTextBoxHandle("OlympiadRandomChallengeWnd.OlympiadMonth_text");
	State_text = GetTextBoxHandle("OlympiadRandomChallengeWnd.OlympiadState_text");
	GamesNumber_text = GetTextBoxHandle("OlympiadRandomChallengeWnd.OlympiadGamesNumber_text");
	StateICON_Texture = GetTextureHandle("OlympiadRandomChallengeWnd.OlympiadStateICON_Texture");
	ApplyCancel_Btn = GetButtonHandle("OlympiadRandomChallengeWnd.ApplyCancel_Btn");
	Refresh_Btn = GetButtonHandle("OlympiadRandomChallengeWnd.Refresh_Btn");
	StateICON_Texture.SetTexture("L2UI_CT1.OlympiadWnd.OffICON");
	Time_text.SetText("");
}

function OnClickButton(string Name)
{
	switch (Name)
	{
		// End:0x24
		case "ApplyCancel_Btn":
			OnApplyCancel_BtnClick();
			// End:0xAA
			break;
		// End:0x4A
		case "WindowHelp_BTN":
			ExecuteEvent(EV_ShowHelp, "118");
			break;
		// End:0x66
		case "AllRanking_Btn":
			OnAllRanking_BtnClick();
			// End:0xAA
			break;
		// End:0xA7
		case "Refresh_Btn":
			Me.SetTimer(TIMER_CLICK,TIMER_DELAYC);
			Refresh_Btn.DisableWindow();
			OnRefresh_BtnClick();
			break;
	}
}

function OnRefresh_BtnClick ()
{
	local array<byte> stream;
	local UIPacket._C_EX_OLYMPIAD_UI packet;

	packet.cGameRuleType = 0;
	if (  !Class'UIPacket'.static.Encode_C_EX_OLYMPIAD_UI(stream,packet) )
		return;
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_OLYMPIAD_UI,stream);
}

function OnApplyCancel_BtnClick()
{
	Me.SetTimer(TIMER_CLICK2, TIMER_DELAYC);
	ApplyCancel_Btn.DisableWindow();
	if (Registered > 0)
	{
		API_C_EX_OLYMPIAD_MATCH_MAKING_CANCEL();
	}
	else
	{
		API_C_EX_OLYMPIAD_MATCH_MAKING();
	}
}

function OnAllRanking_BtnClick ()
{
	RankingWnd(GetScript("RankingWnd")).ShowRankging();
}

function OnTimer (int TimerID)
{
	if ( TimerID == TIMER_CLICK )
	{
		Refresh_Btn.EnableWindow();
		Me.KillTimer(TimerID);
	}
	else if ( TimerID == TIMER_CLICK2 )
    {
		ApplyCancel_Btn.EnableWindow();
		Me.KillTimer(TimerID);
    }
}

function API_C_EX_OLYMPIAD_MATCH_MAKING()
{
	local array<byte> stream;
	local UIPacket._C_EX_OLYMPIAD_MATCH_MAKING packet;

	packet.cGameRuleType = GameRuleType.GRT_TEAM;
	if (!Class'UIPacket'.static.Encode_C_EX_OLYMPIAD_MATCH_MAKING(stream, packet))
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_OLYMPIAD_MATCH_MAKING, stream);
	Debug("-> API_C_EX_OLYMPIAD_MATCH_MAKING");
}

function API_C_EX_OLYMPIAD_MATCH_MAKING_CANCEL()
{
	local array<byte> stream;
	local UIPacket._C_EX_OLYMPIAD_MATCH_MAKING_CANCEL packet;

	packet.cGameRuleType = GameRuleType.GRT_TEAM;
	if (!Class'UIPacket'.static.Encode_C_EX_OLYMPIAD_MATCH_MAKING_CANCEL(stream, packet))
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_OLYMPIAD_MATCH_MAKING_CANCEL, stream);
	Debug("-> API_C_EX_OLYMPIAD_MATCH_MAKING_CANCEL");
}

function bool isRandomChallenge(string param)
{
	local int nGameRuleType;

	ParseInt(param, "GameRuleType", nGameRuleType);
	if (nGameRuleType == GameRuleType.GRT_TEAM)
	{
		return True;
	}
	return False;
}

function OnEvent(int a_EventID, string param)
{
	switch (a_EventID)
	{
		case EV_OlympiadInfo:
			SaveData(param);
			break;
		case EV_OlympiadRecord:
			if (!isRandomChallenge(param))
			{
				return;
			}
			HandleOlympiadRecord(param);
			break;
		case EV_SetRadarZoneCode:
			SetRadarZoneCode(param);
			break;
		case EV_OlympiadMatchMakingResult:
			if (!isRandomChallenge(param))
			{
				return;
			}
			SwapApplyCancelButtonState(param);
			break;
		default:
	}
}

function HandleOlympiadRecord (string param)
{
	local int i;
	local int nMatchCount;
	local UserInfo Info;
	local string ClassName;
	local int nPrevClassType;
	local int nPrevGrade;
	local int nPoint;
	local int nWinCount;
	local float nPrevRank;
	local float nPrevRankCount;
	local float nPrevClassRank;
	local float nPrevClassRankCount;
	local float nPrevClassRankByServer;
	local float nPrevClassRankByServerCount;
	local int nPrevPoint;
	local int nPrevWinCount;
	local int nPrevLoseCount;
	local int Season;
	local DetailStatusWnd Detail;

	ParseInt(param,"Season",Season);
	Time_text.SetText(string(Season) $ GetSystemString(934));
	ParseInt(param,"MatchCount",nMatchCount);
	GamesNumber_text.SetText(string(nMatchCount) $ "/5");
	ParseInt(param,"Point",nPoint);
	ParseInt(param,"WinCount",nWinCount);

	if ( GetMyUserInfo(Info) )
	{
		Detail = DetailStatusWnd(GetScript("DetailStatusWnd"));
		
		for ( i = 0;i < Detail.subjobInfoArray.Length; i++ )
		{
			if ( Detail.subjobInfoArray[i].Type == 0 )
			{
				ClassName = GetClassType(Detail.subjobInfoArray[i].ClassID);
			}
		}
		if ( Info.nNobless == 0 && !getInstanceUIData().getIsClassicServer() )
		{
			DisableWnd.ShowWindow();
		}
		else
		{
			DisableWnd.HideWindow();
		}
	}
	MyClass_Text.SetText(ClassName);
	MyScore_Text.SetText(string(nPoint) $ GetSystemString(1442));
	WinNumber_Text.SetText(string(nWinCount) $ GetSystemString(3844));
	ParseInt(param, "PrevClassType", nPrevClassType);
	ParseInt(param, "PrevGrade", nPrevGrade);
	ParseFloat(param, "PrevRank", nPrevRank);
	ParseFloat(param, "PrevRankCount", nPrevRankCount);
	ParseFloat(param, "PrevClassRank", nPrevClassRank);
	ParseFloat(param, "PrevClassRankCount", nPrevClassRankCount);
	ParseFloat(param, "PrevClassRankByServer", nPrevClassRankByServer);
	ParseFloat(param, "PrevClassRankByServerCount", nPrevClassRankByServerCount);
	ParseInt(param, "PrevPoint", nPrevPoint);
	ParseInt(param, "PrevWinCount", nPrevWinCount);
	ParseInt(param, "PrevLoseCount", nPrevLoseCount);
	if(nPrevRank == 0)
	{
		MyScore_LastWeek_DisableWnd.ShowWindow();
	}
	else
	{
		MyScore_LastWeek_DisableWnd.HideWindow();
		MyClass_lastWeek_Text.SetText(GetClassType(nPrevClassType));
		if ( getInstanceUIData().getIsClassicServer() )
		{
			Grade_lastWeek_Text.SetText(GetSystemString(1797));
		}
		else
		{
			Grade_lastWeek_Text.SetText(string(nPrevGrade) $ GetSystemString(1328));
		}
		AllRanking_lastWeek_Text.SetText(string(int(nPrevRank)) $ GetSystemString(1375) $ "(" $ stringPer(nPrevRank,nPrevRankCount) $ "%)");
		AllClassRanking_lastWeek_Text.SetText(string(int(nPrevClassRank)) $ GetSystemString(1375) $ "(" $ stringPer(nPrevClassRank,nPrevClassRankCount) $ "%)");
		ServerClassRanking_lastWeek_Text.SetText(string(int(nPrevClassRankByServer))$ GetSystemString(1375)$ "(" $ stringPer(nPrevClassRankByServer,nPrevClassRankByServerCount) $ "%)");
		Score_lastWeek_Text.SetText(string(nPrevPoint) $ GetSystemString(1442));
		Win_lastWeek_Text.SetText(string(nPrevWinCount) $ GetSystemString(3844));
		Lost_lastWeek_Text.SetText(string(nPrevLoseCount) $ GetSystemString(3854));
	}
	SwapApplyCancelButtonState(param);
	if ( bOpen <= 0 )
	{
		ApplyCancel_Btn.DisableWindow();
	}
	else
	{
		ApplyCancel_Btn.EnableWindow();
	}
	Me.ShowWindow();
	Me.SetFocus();
}

function SaveData(string param)
{
	ParseInt(param, "Open", bOpen);
	// End:0x3A
	if(! isRandomChallenge(param) && bOpen == 1)
	{
		bOpen = 0;
	}
	// End:0xC0
	if(bOpen == 0)
	{
		SaveOpen = false;
		StateICON_Texture.SetTexture("L2UI_CT1.OlympiadWnd.OffICON");
		StandbyStatus_text.SetText(GetSystemString(13211));
		State_text.SetText(GetSystemString(13210));
		ApplyCancel_Btn.DisableWindow();
	}
	else
	{
		SaveOpen = true;
		StateICON_Texture.SetTexture("L2UI_CT1.OlympiadWnd.ONICON");
		StandbyStatus_text.SetText("");
		State_text.SetText(GetSystemString(13209));
		ApplyCancel_Btn.EnableWindow();
	}
}

function SetRadarZoneCode(string param)
{
	local int zonetype;

	ParseInt(param, "ZoneCode", zonetype);
	// End:0x3C
	if(getInstanceUIData().IsPeaceZoneType(zonetype))
	{
		IsPeaceZone = 1;
	}
	else
	{
		IsPeaceZone = 0;
	}
}

function SwapApplyCancelButtonState(string param)
{
	ParseInt(param, "Registered", Registered);
	SwapApplyCancelButtonText();
}

function SwapApplyCancelButtonText()
{
	if (Registered > 0)
	{
		ApplyCancel_Btn.SetButtonName(3088);
	}
	else
	{
		ApplyCancel_Btn.SetButtonName(2277);
	}
}

function bool GetMyUserInfo (out UserInfo a_MyUserInfo)
{
	return GetPlayerInfo(a_MyUserInfo);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
