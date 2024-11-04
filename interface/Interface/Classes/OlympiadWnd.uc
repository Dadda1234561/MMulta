class OlympiadWnd extends UICommonAPI;

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
var TextBoxHandle OlympiadMonth_text;
var TextBoxHandle OlympiadState_text;
var TextureHandle OlympiadStateICON_Texture;
var TextBoxHandle OlympiadGames_text;
var TextBoxHandle OlympiadGamesNumber_text;
var TextBoxHandle StandbyStatus_text;
var ButtonHandle Watch_Button;
var ButtonHandle Help01_Button;
var TextureHandle GroupboxBG01_Texture;
var TextureHandle GroupboxBG01noLine_Texture;
var TextureHandle GroupboxBG01Divider_shadow_Texture;
var TextureHandle GroupboxBG01Deco_Texture;
var TextBoxHandle MyScoreTitle_Text;
var TextBoxHandle MyScoreWeekTitle_Text;
var TextBoxHandle MyClass_Text;
var TextBoxHandle MyScore_Text;
var TextBoxHandle WinTitle_Text;
var TextBoxHandle WinNumber_Text;
var TextureHandle GroupboxBG02_Texture;
var TextureHandle GroupboxBG02_2_Texture;
var TextureHandle GroupboxBG02Divider_shadow_Texture;
var TextureHandle GroupboxBG02Divider_Texture;
var TextureHandle GroupboxBG02SectionLight_Texture;
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
var ButtonHandle Help02_Button;
var TextureHandle GroupboxBG03_Texture;
var TextureHandle GroupboxBG03_2_Texture;
var TextureHandle GroupboxBG03Divider_shadow_Texture;
var TextureHandle GroupboxBG03Divider_Texture;
var TextureHandle GroupboxBG03SectionLight_Texture;
var TextureHandle GroupboxBG03Divider_Ver_Texture;
var ButtonHandle Refresh_Btn;
var ButtonHandle AllRanking_Btn;
var ButtonHandle WindowHelp_Btn;
var ButtonHandle ApplyCancel_Btn;

var bool SaveOpen;

var int Registered;

//현재 지역 PeaceZone인가
var int IsPeaceZone;
	
var int bOpen;

//목록 갱신용 타이머 ID
const TIMER_CLICK       = 99903;
//관전하기 갱신용 타이머 ID
const TIMER_CLICK1      = 99905;
const TIMER_CLICK2		= 99907;

//목록 갱신용 타이머 딜레이 3초
const TIMER_DELAYC      = 3000;

function OnLoad()
{
	SetClosingOnESC(); 
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle("OlympiadWnd");
	DisableWnd = GetWindowHandle("OlympiadWnd.DisableWnd");
	MyScore_LastWeek_DisableWnd = GetWindowHandle("OlympiadWnd.MyScore_LastWeek_DisableWnd");
	OlympiadMonth_text = GetTextBoxHandle("OlympiadWnd.OlympiadMonth_text");
	OlympiadState_text = GetTextBoxHandle("OlympiadWnd.OlympiadState_text");
	OlympiadStateICON_Texture = GetTextureHandle("OlympiadWnd.OlympiadStateICON_Texture");
	OlympiadGames_text = GetTextBoxHandle("OlympiadWnd.OlympiadGames_text");
	OlympiadGamesNumber_text = GetTextBoxHandle("OlympiadWnd.OlympiadGamesNumber_text");
	StandbyStatus_text = GetTextBoxHandle("OlympiadWnd.StandbyStatus_text");
	Watch_Button = GetButtonHandle("OlympiadWnd.Watch_Button");
	Help01_Button = GetButtonHandle("OlympiadWnd.Help01_Button");
	GroupboxBG01_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG01_Texture");
	GroupboxBG01noLine_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG01noLine_Texture");
	GroupboxBG01Divider_shadow_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG01Divider_shadow_Texture");
	GroupboxBG01Deco_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG01Deco_Texture");
	MyScoreTitle_Text = GetTextBoxHandle("OlympiadWnd.MyScoreTitle_Text");
	MyScoreWeekTitle_Text = GetTextBoxHandle("OlympiadWnd.MyScoreWeekTitle_Text");
	MyClass_Text = GetTextBoxHandle("OlympiadWnd.MyClass_Text");
	MyScore_Text = GetTextBoxHandle("OlympiadWnd.MyScore_Text");
	WinTitle_Text = GetTextBoxHandle("OlympiadWnd.WinTitle_Text");
	WinNumber_Text = GetTextBoxHandle("OlympiadWnd.WinNumber_Text");
	GroupboxBG02_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG02_Texture");
	GroupboxBG02_2_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG02_2_Texture");
	GroupboxBG02Divider_shadow_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG02Divider_shadow_Texture");
	GroupboxBG02Divider_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG02Divider_Texture");
	GroupboxBG02SectionLight_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG02SectionLight_Texture");
	MyScore_LastWeek_Title_Text = GetTextBoxHandle("OlympiadWnd.MyScore_LastWeek_Title_Text");
	MyClass_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.MyClass_lastWeek_Text");
	Grade_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.Grade_lastWeek_Text");
	AllRankingTitle_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.AllRankingTitle_lastWeek_Text");
	AllRanking_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.AllRanking_lastWeek_Text");
	AllClassRankingTitle_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.AllClassRankingTitle_lastWeek_Text");
	AllClassRanking_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.AllClassRanking_lastWeek_Text");
	ServerClassRankingTitle_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.ServerClassRankingTitle_lastWeek_Text");
	ServerClassRanking_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.ServerClassRanking_lastWeek_Text");
	ScoreTitle_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.ScoreTitle_lastWeek_Text");
	Score_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.Score_lastWeek_Text");
	WinTitle_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.WinTitle_lastWeek_Text");
	Win_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.Win_lastWeek_Text");
	LostTitle_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.LostTitle_lastWeek_Text");
	Lost_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.Lost_lastWeek_Text");
	Help02_Button = GetButtonHandle("OlympiadWnd.Help02_Button");
	GroupboxBG03_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG03_Texture");
	GroupboxBG03_2_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG03_2_Texture");
	GroupboxBG03Divider_shadow_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG03Divider_shadow_Texture");
	GroupboxBG03Divider_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG03Divider_Texture");
	GroupboxBG03SectionLight_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG03SectionLight_Texture");
	GroupboxBG03Divider_Ver_Texture = GetTextureHandle("OlympiadWnd.GroupboxBG03Divider_Ver_Texture");
	Refresh_Btn = GetButtonHandle("OlympiadWnd.Refresh_Btn");
	AllRanking_Btn = GetButtonHandle("OlympiadWnd.AllRanking_Btn");
	WindowHelp_Btn = GetButtonHandle("OlympiadWnd.WindowHelp_Btn");
	ApplyCancel_Btn = GetButtonHandle("OlympiadWnd.ApplyCancel_Btn");
}

function OnRegisterEvent()
{
	RegisterEvent( EV_OlympiadInfo );
	RegisterEvent( EV_OlympiadRecord );
	RegisterEvent( EV_SetRadarZoneCode );
	RegisterEvent( EV_OlympiadMatchMakingResult );
}

function Load()
{
	Help01_Button.SetTooltipCustomType(getCustomToolTip(GetSystemString(3839)));
	Help02_Button.SetTooltipCustomType(getCustomToolTip(GetSystemString(3840)));
}

function OnShow()
{
	// End:0x3E
	if(class'UIDATA_PLAYER'.static.IsInPrison())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13773));
		Me.HideWindow();
		return;
	}
	if ( GetWindowHandle("OlympiadRandomChallengeWnd").IsShowWindow() )
		GetWindowHandle("OlympiadRandomChallengeWnd").HideWindow();
	Me.SetFocus();
	HandleApplyCancel_Btn();
}

function bool isRandomChallenge (string param)
{
	local int nGameRuleType;

	ParseInt(param,"GameRuleType",nGameRuleType);
	if ( nGameRuleType == GameRuleType.GRT_TEAM )
	{
		return True;
	}
	return False;
}

function OnEvent(int a_EventID, String param)
{	
	local int zonetype;
	//Debug( "olympiadWnd" @ a_EventID @ param );
	switch( a_EventID )
	{
		case EV_OlympiadInfo:
			SaveData(param);
			break;
		case EV_OlympiadRecord:
			Debug("EV_OlympiadRecord" @ param);
			if ( isRandomChallenge(param) )
				return;
			HandleOlympiadRecord(param);
			break;
		case EV_SetRadarZoneCode:
			ParseInt( param, "ZoneCode", zonetype );		
			// End:0xA4
			if(getInstanceUIData().IsPeaceZoneType(zonetype))
			{
				IsPeaceZone = 1;
			}
			else
			{
				IsPeaceZone = 0;
			}
			break;
		case EV_OlympiadMatchMakingResult:
			// End:0xBA
			if(isRandomChallenge(param))
			{
				return;
			}
			SwapApplyCancelButtonState(param);
			break;
	}
}


function SaveData( string param )
{
	ParseInt(param,"Open",bOpen);
	if ( isRandomChallenge(param) && bOpen == 1 )
		bOpen = 0;

	if( bOpen == 0 )
	{
		SaveOpen=false;
		OlympiadStateICON_Texture.SetTexture( "L2UI_CT1.OlympiadWnd.OffICON");
		Debug("L2UI_CT1.OlympiadWnd.OffICON");
		Watch_Button.HideWindow();

		StandbyStatus_text.ShowWindow();
		//월드 올림피아드 경기는 매주 금, 토, 일 오후 10시부터 12까지 진행됩니다.
		StandbyStatus_text.SetText(GetSystemString(3849));
		//올림피아드 준비 중
		OlympiadState_text.SetText(GetSystemString(3836));
		ApplyCancel_Btn.DisableWindow();
	}
	else
	{
		SaveOpen = true;
		OlympiadStateICON_Texture.SetTexture( "L2UI_CT1.OlympiadWnd.ONICON");
		//Debug("L2UI_CT1.OlympiadWnd.ONICON");
		StandbyStatus_text.HideWindow();

		Watch_Button.ShowWindow();
		//올림피아드 진행 중
		OlympiadState_text.SetText(GetSystemString(3835));
		ApplyCancel_Btn.EnableWindow();
	}
}

function bool GetMyUserInfo( out UserInfo a_MyUserInfo )
{
	return GetPlayerInfo( a_MyUserInfo );
}

function HandleOlympiadRecord( string param )
{
	local int i;
	local UserInfo	info;
	local string ClassName;

	local int SeasonYear,SeasonMonth;


	local int nMatchCount;

	local int nPoint;
	local int nWinCount;

	local int nPrevClassType;
	local int nPrevGrade;

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

	local DetailStatusWnd detail;

	ParseInt(param,"MatchCount",nMatchCount);
	if ( getInstanceUIData().getIsClassicServer() )
	{
		ParseInt(param,"Season",Season);
		OlympiadMonth_text.SetText(string(Season) $ GetSystemString(934));
		OlympiadGamesNumber_text.SetText(string(nMatchCount) $ "/5");
		SwapApplyCancelButtonState(param);
		if ( (nMatchCount == 0) || (bOpen <= 0) )
			ApplyCancel_Btn.DisableWindow();
		else
			ApplyCancel_Btn.EnableWindow();
	}
	else
	{
		ParseInt(param,"SeasonYear",SeasonYear);
		ParseInt(param,"SeasonMonth",SeasonMonth);
		OlympiadMonth_text.SetText(string(SeasonYear) $ GetSystemString(3847) @ string(SeasonMonth) $ GetSystemString(3848));
		OlympiadGamesNumber_text.SetText(string(nMatchCount) $ "/25");
	}

	if ( nMatchCount <= 0 )
		OlympiadGamesNumber_text.SetTextColor(getInstanceL2Util().DarkGray);
	else
		OlympiadGamesNumber_text.SetTextColor(GetColor(187,170,136,255));

	if (GetMyUserInfo(info))
	{		
		detail = DetailStatusWnd(GetScript("DetailStatusWnd"));

		for ( i = 0 ; i < detail.subjobInfoArray.length ; i ++ )
		{
			If (detail.subjobInfoArray[i].type == 0 )
			{
				ClassName = GetClassType(detail.subjobInfoArray[i].ClassID);
			}
		}		

		//NoBless 확인
		if ( (Info.nNobless == 0) &&  !getInstanceUIData().getIsClassicServer() )
		{
			DisableWnd.ShowWindow();
		}
		else
		{
			DisableWnd.HideWindow();
		}
	}

	/**이번주기 전적 ------------------------------------------------*/
	ParseInt(param, "Point", nPoint);
	ParseInt(param, "WinCount", nWinCount);

	//클래스
	MyClass_Text.SetText(ClassName);
	//포인트	
	MyScore_Text.setText(String(nPoint) $ GetSystemString(1442));
	//승리 카운트	
	WinNumber_Text.setText(String(nWinCount) $ GetSystemString(3844));
	/**이번 주기 전적 ------------------------------------------------ END*/

	

	/**지난 주기 전적 ------------------------------------------------*/
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

	/*
	nPrevRank = 1;
	nPrevRankCount = 998;
	
	nPrevClassRank = 11;
	nPrevClassRankCount = 998;

	nPrevClassRankByServer = 111;
	nPrevClassRankByServerCount = 998;
	*/

	if( nPrevRank == 0)
	{
		MyScore_LastWeek_DisableWnd.ShowWindow();
	}
	else
	{
		MyScore_LastWeek_DisableWnd.HideWindow();
		//지난 주기 클래스	
		MyClass_lastWeek_Text.SetText(GetClassType(nPrevClassType));
		//지난 주기 등급	
		if(getInstanceUIData().getIsClassicServer())
		{
			Grade_lastWeek_Text.SetText(GetSystemString(1797));
		}
		else
		{
			Grade_lastWeek_Text.SetText(string(nPrevGrade) $ GetSystemString(1328));
		}
		//지난 주기 순위	
		AllRanking_lastWeek_Text.SetText(string(int(nPrevRank))$GetSystemString(1375)$"("$stringPer(nPrevRank,nPrevRankCount)$"%)");
		//지난 주기 전체 클래스 순위		
		AllClassRanking_lastWeek_Text.SetText(string(int(nPrevClassRank))$GetSystemString(1375)$"("$stringPer(nPrevClassRank,nPrevClassRankCount)$"%)");
		//지난 주기 서버 클래스 순위		
		ServerClassRanking_lastWeek_Text.SetText(string(int(nPrevClassRankByServer))$GetSystemString(1375)$"("$stringPer(nPrevClassRankByServer,nPrevClassRankByServerCount)$"%)");
		//지난 주기 점수		
		Score_lastWeek_Text.SetText(string(nPrevPoint)$GetSystemString(1442));
		//지난 주기 승리		
		Win_lastWeek_Text.SetText(string(nPrevWinCount)$GetSystemString(3844));
		//지난 주기 패배		
		Lost_lastWeek_Text.SetText(string(nPrevLoseCount)$GetSystemString(3854));
	}
	//지난 주기 전적 ------------------------------------------------ END
	//Debug( string( float( appCeil ( 1.2675125347681253 ) ) ) );

	Me.ShowWindow();
}

function SwapApplyCancelButtonState(string param)
{
	ParseInt(param, "Registered", Registered);
	SwapApplyCancelButtonText();
}

function SwapApplyCancelButtonText ()
{
	// End:0x22
	if(Registered > 0)
	{
		ApplyCancel_Btn.SetButtonName(3088);		
	}
	else
	{
		ApplyCancel_Btn.SetButtonName(2277);
	}
}

/**
 * 시간 타이머 && 목록 갱신 타이머 이벤트
 ***/
function OnTimer(int TimerID) 
{
	//목록갱신 버튼 활성화
	if( TimerID == TIMER_CLICK )
	{
		Refresh_Btn.EnableWindow();
		Me.KillTimer( TIMER_CLICK );
	}
	else if(TimerID == TIMER_CLICK1 )
	{
		Watch_Button.EnableWindow();
		Me.KillTimer( TIMER_CLICK1 );
	}
	else  if ( TimerID == TIMER_CLICK2 )
	{
		ApplyCancel_Btn.EnableWindow();
		Me.KillTimer(TimerID);
	}
}

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "Watch_Button":
			//관전하기 버튼 타이머 시작
			Me.SetTimer( TIMER_CLICK1, TIMER_DELAYC );
			//버튼 비활성
			Watch_Button.DisableWindow();
			OnWatch_ButtonClick();
			break;
		case "Help01_Button":
			OnWindowHelp_BtnClick();
			break;
		case "Help02_Button":
			OnWindowHelp_BtnClick();
			break;
		case "Refresh_Btn":
			//목록 갱신용 타이머 시작
			Me.SetTimer( TIMER_CLICK, TIMER_DELAYC );
			//버튼 비활성
			Refresh_Btn.DisableWindow();
			OnRefresh_BtnClick();
			break;
		case "AllRanking_Btn":
			OnAllRanking_BtnClick();
			break;
		case "WindowHelp_Btn":
			OnWindowHelp_BtnClick();
			break;
		case "ApplyCancel_Btn":
			OnApplyCancel_ButtonClick();
			break;
	}
}

function OnApplyCancel_ButtonClick()
{
	Me.SetTimer(TIMER_CLICK2, 3000);
	ApplyCancel_Btn.DisableWindow();
	// End:0x45
	if(Registered > 0)
	{
		class'OlympiadAPI'.static.RequestExOlympiadMatchMakingCancel();
	}
	else
	{
		class'OlympiadAPI'.static.RequestExOlympiadMatchMaking();
	}
}

function OnWatch_ButtonClick()
{
	// End:0x14
	if(IsPeaceZone == 1)
	{
		OlympiadArenaListWndOpen();
	}
	else
	{
		AddSystemMessage(5183);
	}

}

function OlympiadArenaListWndOpen()
{
	class'OlympiadAPI'.static.RequestOlympiadMatchList();
}

function OnWindowHelp_BtnClick()
{
	local string strParam;

	if ( getInstanceUIData().getIsClassicServer() )
	{
		ParamAdd(strParam,"FilePath", GetLocalizedL2TextPathNameUC() $ "olympiad_operator001h.htm");
		ExecuteEvent(EV_ShowHelp, strParam);
	}
	else
	{
		ExecuteEvent(EV_ShowHelp, "114");
	}
}

function OnRefresh_BtnClick()
{
	RequestOlympiadRecord();
}

function OnAllRanking_BtnClick()
{
	//Category=ranking_world_olympiad 
	RankingWnd(GetScript("RankingWnd")).ShowRankging();
}

function HandleAllRanking_Btn()
{
	// End:0x25
	if(getInstanceUIData().getIsClassicServer())
	{
		AllRanking_Btn.DisableWindow();		
	}
	else
	{
		AllRanking_Btn.EnableWindow();
	}
}

function HandleApplyCancel_Btn()
{
	// End:0x25
	if(getInstanceUIData().getIsClassicServer())
	{
		ApplyCancel_Btn.ShowWindow();		
	}
	else
	{
		ApplyCancel_Btn.HideWindow();
	}
}

function CustomTooltip getCustomToolTip(string Text)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info;

	ToolTip.MinimumWidth = 144;
	ToolTip.DrawList.Length = 1;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	Info.t_color.R = 178;
	Info.t_color.G = 190;
	Info.t_color.B = 207;
	Info.t_color.A = 255;
	Info.t_strText = Text;
	ToolTip.DrawList[0] = Info;

	return ToolTip;
}

/**
 * 윈도우ESC 키로닫기처리
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
