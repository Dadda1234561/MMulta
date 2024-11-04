//================================================================================
// NoticeHUD.
// emu-dev.ru
//================================================================================

class NoticeHUD extends UICommonAPI
	dependson(DethroneCharacterCreatewnd)
	dependson(WorldSiegeBoardWnd)
	dependson(WorldSiegeLauncherWnd)
	dependson(WorldSiegeRankingWnd)
	dependson(SiegeWnd)
	dependson(TimeZoneSubWnd)
	dependson(QuitReportInstantZoneWnd);

const WINDOW_W_MIN = 2;
const WINDOW_W_GAP = 2;
const TIMER_OLYMPIADNOTICE = 1;
const TIMER_TIMEZONENOTICE = 2;
const TIMER_SIEGENOTICE = 3;
const TIMER_FORTRESS_NOTICE = 4;
const TIMER_WORLDSIEGENOTICE = 5;
const TIMER_WROLDSIEGEOUT = 6;
const TIMER_BALROGWARNOTICE = 7;
const TIMER_FRESH_COOLTIME = 1000;
const MINLEVEL_WORLDSIEGE = 76;
const DIALOG_WORLDSIEGEIN = 0;
const DIALOG_WORLDSIEGEOUT = 1;
const DIALOG_TIMEZONEEXIT = 2;

enum SiegeType
{
	READY,
	Start,
	End
};

enum WorldSiegeStateType
{
	READY,
	Start,
	End,
	WORLD
};

enum FortressType
{
	READY,
	Start,
	End
};

enum BALROGWAR_State
{
	BWS_NONE,
	BWS_PREPARE,
	BWS_PROGRESS,
	BWS_REWARD,
	BWS_END
};

enum BALROGWAR_ProgressStep
{
	BWPS_NONE,
	BWPS_START,
	BWPS_MIDBOSS1,
	BWPS_MIDBOSS2,
	BWPS_FINALBOSS,
	BWPS_FINALBOSS_SPECIAL
};

var string m_OlympiadNoticeWndName;
var string m_TimeZoneNoticeWndName;
var string m_SiegeNoticeWnd;
var string m_FortressBattleNoticeWndName;
var string m_WorldSiegeNoticeWnd;
var string m_DethroneNoticeWnd;
var string m_BalrogNoticeWnd;
var WindowHandle OlympiadNoticeWnd;
var AnimTextureHandle OlympiadNoticeAnim;
var AnimTextureHandle OlympiadNoticeRegistedTexture;
var ButtonHandle OlympiadNoticeBtn;
var TextBoxHandle OlympiadNoticeText;
var int OlympiadNoticeRemainSec;
var int OlympiadNoticeRegistered;
var int GameRuleType;
var WindowHandle TimeZoneNoticeWnd;
var AnimTextureHandle TimeZoneNoticeAnim_Tex;
var ButtonHandle TimeZoneNoticePlus_Btn;
var TextBoxHandle TimeZoneNoticeTime_Txt;
var int TimeZoneCurrentFieldID;
var int TimeZoneRemainTimeSec;
var ButtonHandle TimeZoneNoticeExit_Btn;
var ButtonHandle TimeZoneNoticeExitLabel_Btn;
var WindowHandle siegeNoticeWnd;
var TextBoxHandle siegeText;
var TextBoxHandle siegeNoticeText;
var ButtonHandle siegeBtn;
var int siegeRemainTime;
var array<int> siegeCastleIDs;
var int SiegeState;
var AnimTextureHandle siegeResult_AniTex;
var TextureHandle siegePlusIcon;
var array<int> PreAlarms;
var array<int> Alarms;
var WindowHandle DethroneNoticeWnd;
var AnimTextureHandle DethroneNoticeAnim_Tex;
var ButtonHandle DethroneNotice_Btn;
var bool isInitedDethrone;
var WindowHandle worldsiegeNoticeWnd;
var TextBoxHandle worldSiegeText;
var TextBoxHandle worldSiegeNoticeText;
var int worldsiegeRemainTime;
var array<int> worldsiegeCastleIDs;
var int worldsiegeState;
var int worldSiegeRemainTimeInout;
var bool IsInWorldSiege;
var ButtonHandle worldSiegeOngoing_Btn;
var ButtonHandle WorldSiegeWaiting_Btn;
var bool isWorldSiegeInOuttime;
var WindowHandle FortressBattleNoticeWnd;
var TextBoxHandle FortressBattleText;
var TextBoxHandle FortressBattleNoticeText;
var ButtonHandle FortressBattleBtn;
var int FortressBattleRemainTime;
var WindowHandle BalrogNoticeWnd;
var TextBoxHandle BalrogReadyText;
var TextBoxHandle BalrogReadyNoticeText;
var ButtonHandle BalrogReadyBtn;
var int BalrogWarRemainTime;
var array<WindowHandle> allWindow;
var bool isShowInfoWnd;

static function NoticeHUD Inst()
{
	return NoticeHUD(GetScript("NoticeHud"));
}

function OnLoad()
{
	OlympiadNoticeWnd = GetWindowHandle(m_OlympiadNoticeWndName);
	OlympiadNoticeAnim = GetAnimTextureHandle(m_OlympiadNoticeWndName $ ".OlympiadNoticeAnim");
	OlympiadNoticeBtn = GetButtonHandle(m_OlympiadNoticeWndName $ ".OlympiadNoticeBtn");
	OlympiadNoticeText = GetTextBoxHandle(m_OlympiadNoticeWndName $ ".OlympiadNoticeText");
	OlympiadNoticeRegistedTexture = GetAnimTextureHandle(m_OlympiadNoticeWndName $ ".OlympiadNoticeRegistedTexture");
	TimeZoneNoticeWnd = GetWindowHandle(m_TimeZoneNoticeWndName);
	TimeZoneNoticeAnim_Tex = GetAnimTextureHandle(m_TimeZoneNoticeWndName $ ".TimeZoneNoticeAnim_Tex");
	TimeZoneNoticePlus_Btn = GetButtonHandle(m_TimeZoneNoticeWndName $ ".TimeZoneNoticePlus_Btn");
	TimeZoneNoticeTime_Txt = GetTextBoxHandle(m_TimeZoneNoticeWndName $ ".TimeZoneNoticeTime_Txt");
	TimeZoneNoticeExit_Btn = GetButtonHandle(m_TimeZoneNoticeWndName $ ".TimeZoneNoticeExit_Btn");
	TimeZoneNoticeExitLabel_Btn = GetButtonHandle(m_TimeZoneNoticeWndName $ ".TimeZoneNoticeExitLabel_Btn");
	siegeNoticeWnd = GetWindowHandle(m_SiegeNoticeWnd);
	siegeText = GetTextBoxHandle(m_SiegeNoticeWnd $ ".siegeText");
	siegeNoticeText = GetTextBoxHandle(m_SiegeNoticeWnd $ ".SiegeNoticeText");
	siegeBtn = GetButtonHandle(m_SiegeNoticeWnd $ ".siegeBtn");
	siegeResult_AniTex = GetAnimTextureHandle(m_SiegeNoticeWnd $ ".Result_AniTex");
	siegePlusIcon = GetTextureHandle(m_SiegeNoticeWnd $ ".PlusIcon");
	siegeResult_AniTex.HideWindow();
	siegeResult_AniTex.Stop();
	DethroneNoticeWnd = GetWindowHandle(m_DethroneNoticeWnd);
	DethroneNoticeAnim_Tex = GetAnimTextureHandle(m_DethroneNoticeWnd $ ".DethroneNoticeAnim_Tex");
	DethroneNotice_Btn = GetButtonHandle(m_DethroneNoticeWnd $ ".DethroneNotice_Btn");
	worldsiegeNoticeWnd = GetWindowHandle(m_WorldSiegeNoticeWnd);
	worldSiegeText = GetTextBoxHandle(m_WorldSiegeNoticeWnd $ ".worldSiegeText");
	worldSiegeNoticeText = GetTextBoxHandle(m_WorldSiegeNoticeWnd $ ".worldSiegeNoticeText");
	worldSiegeOngoing_Btn = GetButtonHandle(m_WorldSiegeNoticeWnd $ ".worldSiegeOngoing_Btn");
	WorldSiegeWaiting_Btn = GetButtonHandle(m_WorldSiegeNoticeWnd $ ".WorldSiegeWaiting_Btn");
	FortressBattleNoticeWnd = GetWindowHandle(m_FortressBattleNoticeWndName);
	FortressBattleText = GetTextBoxHandle(m_FortressBattleNoticeWndName $ ".FortressBattleText");
	FortressBattleNoticeText = GetTextBoxHandle(m_FortressBattleNoticeWndName $ ".FortressBattleNoticeText");
	FortressBattleBtn = GetButtonHandle(m_FortressBattleNoticeWndName $ ".FortressBattleBtn");
	BalrogNoticeWnd = GetWindowHandle(m_BalrogNoticeWnd);
	BalrogReadyText = GetTextBoxHandle(m_BalrogNoticeWnd $ ".BalrogReadyText");
	BalrogReadyNoticeText = GetTextBoxHandle(m_BalrogNoticeWnd $ ".BalrogReadyNoticeText");
	BalrogReadyBtn = GetButtonHandle(m_BalrogNoticeWnd $ ".BalrogReadyBtn");
	setWindowOrder();

	if(IsAdenServer())
	{
		GetSiegePointAlarms(PreAlarms, Alarms);
	}
}

function OnRegisterEvent()
{
	RegisterEvent(EV_OlympiadMatchMakingResult);
	RegisterEvent(EV_TimeRestrictFieldUserAlarm);
	RegisterEvent(EV_TimeRestrictFieldChargeResult);
	RegisterEvent(EV_TimeRestrictFieldUserAlarm);
	RegisterEvent(EV_TimeRestrictFieldEnterResult);
	RegisterEvent(EV_TimeRestrictFieldExit);
	RegisterEvent(EV_MCW_CastleSiegeHUDInfo);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_ADEN_FORTRESS_SIEGE_HUD_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_SEASON_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_HUD_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_BALROGWAR_HUD);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_StateChanged);
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case EV_DialogOK:
			HandleDialogOK();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO:
			if(IsPlayerOnWorldRaidServer())
			{
				return;
			}
			HandleEvent_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_HUD_INFO:
			HandleEvent_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_HUD_INFO();
			break;
		case EV_OlympiadMatchMakingResult:
		case EV_OlympiadRecord:
			HandleOlympiadMatchMakingResult(a_Param);
			break;
		case EV_TimeRestrictFieldChargeResult:
			HandleTimeRestrictFieldChargeResult(a_Param);
			break;
		case EV_TimeRestrictFieldUserAlarm:
			HandleTimeRestrictFieldUserAlarm(a_Param);
			break;
		case EV_TimeRestrictFieldEnterResult:
			HandleTimeRestrictFieldEnterResult(a_Param);
			break;
		case EV_TimeRestrictFieldExit:
			HandleTimeRestrictFieldExit(a_Param);
			break;
		case EV_MCW_CastleSiegeHUDInfo:
			HandleMCW_CastleSiegeHUDInfo(a_Param);
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_ADEN_FORTRESS_SIEGE_HUD_INFO:
			Handle_S_EX_ADEN_FORTRESS_SIEGE_HUD_INFO();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_SEASON_INFO:
			Handle_S_EX_DETHRONE_SEASON_INFO();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_BALROGWAR_HUD:
			Handle_S_EX_BALROGWAR_HUD();
			break;
		case EV_Restart:
			isWorldSiegeInOuttime = false;
			isInitedDethrone = false;
			TimeZoneCurrentFieldID = -1;
			HandleAllHide();
			break;
		case EV_StateChanged:
			HandleStageChange();
			break;
	}
}

event OnTextureAnimEnd(AnimTextureHandle a_AnimTextureHandle)
{
	switch(a_AnimTextureHandle)
	{
		case siegeResult_AniTex:
			siegeResult_AniTex.HideWindow();
			break;
	}	
}

function OnClickButton(string a_ButtonID)
{
	switch(a_ButtonID)
	{
		case "OlympiadNoticeBtn":
			HandleOnClickOlympiadBtn();
			break;
		case "TimeZoneNotice_Btn":
			HandleOnClickTimeZoneNotice_Btn();
			break;
		case "TimeZoneNoticePlus_Btn":
			HandleOnClickTimeZoneNoticePlus_Btn();
			break;
		case "TimeZoneNoticeExit_Btn":
			HandleOnClickTimeZoneNoticeExit_Btn();
			break;
		case "TimeZoneNoticeExitLabel_Btn":
			HandleOnClickTimeZoneNoticeExit_Btn();
			break;
		case "SiegeBtn":
			HandleOnClickSiegeBtn();
			break;
		case "FortressBattleBtn":
			HandleOnClickFortressBtn();
			break;
		case "DethroneNotice_Btn":
			HandleOnClickDethroneNoticeBtn();
			break;
		case "worldSiegeOngoing_Btn":
			HandleOnClickworldSiegeOngoing_Btn();
			break;
		case "WorldSiegeWaiting_Btn":
			HandleOnClickWorldSiegeWaiting_Btn();
			break;
		case "BalrogReadyBtn":
			HandleOnClickBalrogReadyBtn();
			break;
	}
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case TIMER_OLYMPIADNOTICE:
			HandleOlympiadNoticeRemainSec();
			break;
		case TIMER_TIMEZONENOTICE:
			TimeZoneRemainTimeSec = TimeZoneRemainTimeSec - 1;
			HandleTimeZoneNoticeRemainMin();
			break;
		case TIMER_SIEGENOTICE:
			siegeRemainTime = siegeRemainTime - 1;
			HandleTimeSiegeRemain();
			break;
		case TIMER_FORTRESS_NOTICE:
			FortressBattleRemainTime = FortressBattleRemainTime - 1;
			HandleTimeFortressRemain();
			break;
		case TIMER_WORLDSIEGENOTICE:
			worldsiegeRemainTime--;
			HandleTimeWorldSiegeRemain();
			break;
		case TIMER_WROLDSIEGEOUT:
			worldSiegeRemainTimeInout--;
			HandleTimeEndWorldSiegeInoutTime();
			break;
		case TIMER_BALROGWARNOTICE:
			BalrogWarRemainTime--;
			HandleTimeBalrogWarRemain();
			break;
	}
}

function KillAllTimer()
{
	OlympiadNoticeWnd.KillTimer(TIMER_OLYMPIADNOTICE);
	TimeZoneNoticeWnd.KillTimer(TIMER_TIMEZONENOTICE);
	siegeNoticeWnd.KillTimer(TIMER_SIEGENOTICE);
	FortressBattleNoticeWnd.KillTimer(TIMER_FORTRESS_NOTICE);
	worldsiegeNoticeWnd.KillTimer(TIMER_WORLDSIEGENOTICE);
	worldsiegeNoticeWnd.KillTimer(TIMER_WROLDSIEGEOUT);
	BalrogNoticeWnd.KillTimer(TIMER_BALROGWARNOTICE);
}

function HandleDialogOK()
{
	if(!DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case DIALOG_WORLDSIEGEIN:
			API_C_EX_WORLDCASTLEWAR_MOVE_TO_HOST();
			break;
		case DIALOG_WORLDSIEGEOUT:
			class'WorldSiegeWnd'.static.Inst().API_C_EX_WORLDCASTLEWAR_RETURN_TO_ORIGIN_PEER();
			break;
		case DIALOG_TIMEZONEEXIT:
			Rq_C_EX_TIME_RESTRICT_FIELD_USER_LEAVE();
			break;
	}
}

function HandleOlympiadNotice(string param)
{
	local int Open;

	OlympiadNoticeWnd.KillTimer(TIMER_OLYMPIADNOTICE);
	ParseInt(param, "RemainSec", OlympiadNoticeRemainSec);
	ParseInt(param, "Open", Open);
	ParseInt(param, "GameRuleType", GameRuleType);

	if(Open > 0)
	{
		if(GameRuleType == 0)
		{
			OlympiadNoticeBtn.SetTexture("L2UI_ct1.RandomChallengeWnd.RandomChallengeWnd_BlueButton", "L2UI_ct1.RandomChallengeWnd.RandomChallengeWnd_BlueButton_Down", "L2UI_ct1.RandomChallengeWnd.RandomChallengeWnd_BlueButton_Over");
		}
		else
		{
			OlympiadNoticeBtn.SetTexture("L2UI_ct1.OlympiadWnd.OlympiadWnd_OlympiadButton", "L2UI_ct1.OlympiadWnd.OlympiadWnd_OlympiadButton_Down", "L2UI_ct1.OlympiadWnd.OlympiadWnd_OlympiadButton_Over");
		}
		OlympiadNoticeAnim.Stop();
		OlympiadNoticeAnim.SetLoopCount(1);
		OlympiadNoticeAnim.Play();
		HandleOlympiadNoticeRemainSec();
		OlympiadNoticeWnd.SetTimer(TIMER_OLYMPIADNOTICE, TIMER_FRESH_COOLTIME);
		setWindowShow(OlympiadNoticeWnd);
	}
	else
	{
		SetWindowHide(OlympiadNoticeWnd);
	}
}

function HandleOlympiadMatchMakingResult(string param)
{
	ParseInt(param, "Registered", OlympiadNoticeRegistered);
	ChangeOlympiadJoinState();
}

function ChangeOlympiadJoinState()
{
	if(OlympiadNoticeRegistered > 0)
	{
		OlympiadNoticeRegistedTexture.Stop();
		OlympiadNoticeRegistedTexture.SetLoopCount(99999);
		OlympiadNoticeRegistedTexture.Play();
	}
	else
	{
		OlympiadNoticeRegistedTexture.Stop();
	}
}

function HandleOlympiadNoticeRemainSec()
{
	OlympiadNoticeRemainSec--;

	if(OlympiadNoticeRemainSec < 0)
	{
		OlympiadNoticeWnd.KillTimer(TIMER_OLYMPIADNOTICE);
		SetWindowHide(OlympiadNoticeWnd);
		return;
	}
	OlympiadNoticeText.SetText(GetTimeStringMS(OlympiadNoticeRemainSec));
}

function HandleOnClickOlympiadBtn()
{
	local array<byte> stream;
	local UIPacket._C_EX_OLYMPIAD_UI packet;

	if(GameRuleType == 0)
	{
		packet.cGameRuleType = GameRuleType;

		if(!class'UIPacket'.static.Encode_C_EX_OLYMPIAD_UI(stream, packet))
		{
			return;
		}
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_OLYMPIAD_UI, stream);
	}
	else
	{
		if(class'UIAPI_WINDOW'.static.IsShowWindow("OlympiadWnd"))
		{
			class'UIAPI_WINDOW'.static.HideWindow("OlympiadWnd");
		}
		else
		{
			RequestOlympiadRecord();
		}
	}
}

function HandleTimeRestrictFieldChargeResult(string param)
{
	local int FieldId;

	ParseInt(param, "FieldID", FieldId);

	if(FieldId != TimeZoneCurrentFieldID)
	{
		return;
	}
	ParseInt(param, "RemainTime", TimeZoneRemainTimeSec);
	HandleTimeZoneNoticeRemainMin();
	TimeZoneNoticeAnim_Tex.Stop();
	TimeZoneNoticeAnim_Tex.SetLoopCount(1);
	TimeZoneNoticeAnim_Tex.Play();
}

function HandleTimeRestrictFieldUserAlarm(string param)
{
	ParseInt(param, "RemainTime", TimeZoneRemainTimeSec);
	HandleTimeZoneNoticeRemainMin();
	TimeZoneNoticeAnim_Tex.Stop();
	TimeZoneNoticeAnim_Tex.SetLoopCount(1);
	TimeZoneNoticeAnim_Tex.Play();
}

function HandleTimeRestrictFieldEnterResult(string param)
{
	local int EnterSuccess, EnterTimeStamp;
	local TimeRestrictFieldUIData fieldUIData;

	ParseInt(param, "bEnterSuccess", EnterSuccess);
	ParseInt(param, "RemainTime", TimeZoneRemainTimeSec);
	ParseInt(param, "EnterTimeStamp", EnterTimeStamp);

	if(EnterSuccess == 1)
	{
		ParseInt(param, "FieldID", TimeZoneCurrentFieldID);
		GetTimeRestrictFieldInfo(TimeZoneCurrentFieldID, fieldUIData);

		if(fieldUIData.Type == "timezone")
		{
			HandleTimeZoneNoticeRemainMin();

			if(IsTimeZoneUILabelType())
			{
				TimeZoneNoticeExit_Btn.HideWindow();
				TimeZoneNoticeExitLabel_Btn.ShowWindow();
				TimeZoneNoticePlus_Btn.HideWindow();				
			}
			else
			{
				TimeZoneNoticeExit_Btn.ShowWindow();
				TimeZoneNoticeExitLabel_Btn.HideWindow();
				TimeZoneNoticePlus_Btn.ShowWindow();
			}
			setWindowShow(TimeZoneNoticeWnd);
			TimeZoneNoticeWnd.SetTimer(TIMER_TIMEZONENOTICE, TIMER_FRESH_COOLTIME);
		}
		QuitReportInstantZoneWnd(GetScript("QuitReportInstantZoneWnd")).InfoGainStart();
	}
	else
	{
		SetWindowHide(TimeZoneNoticeWnd);
	}
}

function int getTimeZoneCurrentFieldID()
{
	return TimeZoneCurrentFieldID;	
}

function HandleTimeRestrictFieldExit(string param)
{
	local int FieldId;

	ParseInt(param, "FieldID", FieldId);

	if(TimeZoneCurrentFieldID == FieldId)
	{
		TimeZoneNoticeWnd.KillTimer(TIMER_TIMEZONENOTICE);
		SetWindowHide(TimeZoneNoticeWnd);
		QuitReportInstantZoneWnd(GetScript("QuitReportInstantZoneWnd")).InfoGainResult();
		TimeZoneCurrentFieldID = -1;
	}
}

function HandleOnClickTimeZoneNotice_Btn()
{
	if(class'UIAPI_WINDOW'.static.IsShowWindow("TimeZoneWnd"))
	{
		class'UIAPI_WINDOW'.static.HideWindow("TimeZoneWnd");
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow("TimeZoneWnd");
	}
}

function HandleOnClickTimeZoneNoticePlus_Btn()
{
	if(class'UIAPI_WINDOW'.static.IsShowWindow("TimeZoneSubWnd"))
	{
		class'UIAPI_WINDOW'.static.HideWindow("TimeZoneSubWnd");
	}
	else
	{
		TimeZoneSubWnd(GetScript("TimeZoneSubWnd")).SetShowSubWindow(TimeZoneCurrentFieldID, TimeZoneNoticePlus_Btn);
	}
}

function HandleOnClickTimeZoneNoticeExit_Btn()
{
	ShowTimeZoneExitDialog();	
}

function HandleTimeZoneNoticeRemainMin()
{
	if(TimeZoneRemainTimeSec < 60)
	{
		TimeZoneNoticeTime_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(3408), MakeMin(60)));
	}
	else
	{
		TimeZoneNoticeTime_Txt.SetText(MakeMin(TimeZoneRemainTimeSec));
	}
}

function InputCastleIDs(int castleID)
{
	if(! siegeNoticeWnd.IsShowWindow())
	{
		siegeCastleIDs.Length = 0;
		SiegeWnd(GetScript("SiegeWnd")).castleIDs.Length = 0;
	}
	if(GetCastleIndexByCastleID(castleID) != -1)
	{
		return;
	}
	SiegeWnd(GetScript("SiegeWnd")).TabAdd(siegeCastleIDs.Length, castleID);
	siegeCastleIDs.Length = siegeCastleIDs.Length + 1;
	siegeCastleIDs[siegeCastleIDs.Length - 1] = castleID;
}

function delCastleIDs(int Index)
{
	if(Index == -1)
	{
		return;
	}
	siegeCastleIDs.Remove(Index, 1);
	SiegeWnd(GetScript("SiegeWnd")).TabDel(Index);

	if(siegeCastleIDs.Length == 0)
	{
		SetWindowHide(siegeNoticeWnd);
		siegeNoticeWnd.KillTimer(TIMER_SIEGENOTICE);
	}
}

function int GetCastleIndexByCastleID(int castleID)
{
	local int i;

	for(i = 0; i < siegeCastleIDs.Length; i++)
	{
		if(siegeCastleIDs[i] == castleID)
		{
			return i;
		}
	}
	return -1;
}

function HandleMCW_CastleSiegeHUDInfo(string param)
{
	local int siegeCastleID;

	if(IsPlayerOnWorldRaidServer())
	{
		return;
	}
	ParseInt(param, "SiegeState", SiegeState);
	ParseInt(param, "CastleID", siegeCastleID);

	switch(SiegeState)
	{
		case 0:
			siegeText.SetTextColor(GetColor(255, 255, 255, 255));
			siegeNoticeText.SetTextColor(GetColor(255, 255, 255, 255));
			siegeNoticeWnd.KillTimer(TIMER_SIEGENOTICE);
			break;
		case 1:
			siegeText.SetTextColor(GetColor(255, 119, 0, 255));
			siegeNoticeText.SetTextColor(GetColor(255, 153, 0, 255));
			siegeNoticeWnd.KillTimer(TIMER_SIEGENOTICE);
			break;
		case 2:
			delCastleIDs(GetCastleIndexByCastleID(siegeCastleID));
			return;
			break;
	}
	InputCastleIDs(siegeCastleID);
	siegePlusIcon.HideWindow();
	setWindowShow(siegeNoticeWnd);
	ParseInt(param, "RemainTime", siegeRemainTime);
	siegeNoticeWnd.SetTimer(TIMER_SIEGENOTICE, TIMER_FRESH_COOLTIME);

	switch(SiegeState)
	{
		case 0:
			siegeText.SetText(GetSystemString(13048));
			siegeBtn.SetTexture("L2UI_ct1.SiegeWnd_SiegeWaitingButton", "L2UI_ct1.SiegeWnd_SiegeWaitingButton_Over", "L2UI_ct1.SiegeWnd_SiegeWaitingButton_Down");
			break;
		case 1:
			siegeText.SetText(GetSystemString(13049));
			siegeBtn.SetTexture("L2UI_ct1.SiegeWnd_SiegeProgressButton", "L2UI_ct1.SiegeWnd_SiegeProgressButton_Over", "L2UI_ct1.SiegeWnd_SiegeProgressButton_Down");
			break;
	}
}

function HandleOnClickSiegeBtn()
{
	if(GetWindowHandle("SiegeWnd").IsShowWindow())
	{
		GetWindowHandle("SiegeWnd").HideWindow();
	}
	else if (siegeCastleIDs.Length > 0)
	{
		SiegeWnd(GetScript("SiegeWnd")).TabSetSelectedIndex(0);
	}
}

function HandleTimeSiegeRemain()
{
	if(siegeRemainTime < 0)
	{
		siegeNoticeWnd.KillTimer(TIMER_SIEGENOTICE);
		SetWindowHide(siegeNoticeWnd);
		return;
	}
	if(SiegeState == 1 && IsAdenServer() == true)
	{
		setAlarms(siegeRemainTime);
	}
	siegeNoticeText.SetText(GetTimeStringMS(siegeRemainTime));
}

function setAlarms(int Time)
{
	local int i;
	local bool bper;

	bper = false;

	for(i = 0; i < PreAlarms.Length; i++)
	{
		if(Time <= PreAlarms[i] && Time > Alarms[i])
		{
			bper = true;
		}
		if(Time == Alarms[i])
		{
			siegeResult_AniTex.ShowWindow();
			siegeResult_AniTex.Stop();
			siegeResult_AniTex.SetLoopCount(1);
			siegeResult_AniTex.Play();
		}
	}

	if(bper)
	{
		siegePlusIcon.ShowWindow();
		siegeNoticeText.SetTextColor(GetColor(0, 255, 0, 255));		
	}
	else
	{
		siegePlusIcon.HideWindow();
		siegeNoticeText.SetTextColor(GetColor(220, 220, 220, 255));
	}
}

function InputWorldCastleIDs(int castleID)
{
	if(!worldsiegeNoticeWnd.IsShowWindow())
	{
		worldsiegeCastleIDs.Length = 0;
		WorldSiegeWnd(GetScript("WorldSiegeWnd")).castleIDs.Length = 0;
	}
	if(GetWorldCastleIndexByCastleID(castleID) != -1)
	{
		return;
	}
	worldsiegeCastleIDs[worldsiegeCastleIDs.Length] = castleID;
	WorldSiegeWnd(GetScript("WorldSiegeWnd")).castleIDs = worldsiegeCastleIDs;
}

function DelWorldCastleIDs(int Index)
{
	if(Index == -1)
	{
		return;
	}
	worldsiegeCastleIDs.Remove(Index, 1);

	if(worldsiegeCastleIDs.Length == 0 && ! isWorldSiegeInOuttime)
	{
		SetWindowHide(worldsiegeNoticeWnd);
		worldsiegeNoticeWnd.KillTimer(5);
	}
}

function int GetWorldCastleIndexByCastleID(int castleID)
{
	local int i;

	for(i = 0; i < worldsiegeCastleIDs.Length; i++)
	{
		if(worldsiegeCastleIDs[i] == castleID)
		{
			return i;
		}
	}
	return -1;
}

function SetWorldSiegeEnd(int SiegeState)
{
	if(worldsiegeState != 1)
	{
		worldsiegeState = SiegeState;
		return;
	}
	if(!IsInWorldSiege)
	{
		return;
	}
	worldsiegeState = SiegeState;
	GetWindowHandle("WorldSiegeWnd").HideWindow();
	GetWindowHandle("WorldSiegeRankingWnd").HideWindow();
	GetWindowHandle("WorldSiegeInfoMCWWnd").HideWindow();
	GetWindowHandle("WorldSiegeMercenaryWnd").HideWindow();
	worldSiegeRemainTimeInout = 1800;
	HandleTimeEndWorldSiegeInoutTime();
	worldSiegeText.SetText(GetSystemString(13048));
	worldSiegeText.SetTextColor(GetColor(255, 255, 255, 255));
	worldSiegeNoticeText.SetTextColor(GetColor(255, 255, 255, 255));
	worldSiegeText.SetText(GetSystemString(153));
	worldsiegeNoticeWnd.KillTimer(5);
	worldsiegeNoticeWnd.SetTimer(6, 1000);
	isWorldSiegeInOuttime = true;
	setWindowShow(worldsiegeNoticeWnd);
}

function SetWorldCastleSiegeHUDInfo(int castleID, int SiegeState, int nowTime, int RemainTime)
{
	switch(SiegeState)
	{
		case 0:
			if((nowTime == 0) && RemainTime == 0)
			{
				DelWorldCastleIDs(GetWorldCastleIndexByCastleID(castleID));
				return;
			}
			worldSiegeText.SetText(GetSystemString(13048));
			worldSiegeText.SetTextColor(GetColor(255, 255, 255, 255));
			worldSiegeNoticeText.SetTextColor(GetColor(255, 255, 255, 255));
			break;
		case 1:
			worldSiegeText.SetText(GetSystemString(13049));
			worldSiegeText.SetTextColor(GetColor(255, 119, 0, 255));
			worldSiegeNoticeText.SetTextColor(GetColor(255, 153, 0, 255));
			break;
		case 2:
			worldSiegeText.SetText(GetSystemString(13050));
			DelWorldCastleIDs(GetWorldCastleIndexByCastleID(castleID));
			SetWorldSiegeEnd(SiegeState);
			break;
	}
	worldsiegeState = SiegeState;

	if(2 == worldsiegeState)
	{
		return;
	}
	class'WorldSiegeRankingWnd'.static.Inst().SiegeInfo_Text.SetText(worldSiegeText.GetText());
	InputWorldCastleIDs(castleID);
	setWindowShow(worldsiegeNoticeWnd);
	worldsiegeRemainTime = Max(0, (nowTime + RemainTime) - class'UIData'.static.Inst().GetCurrentRealLocalTimeSec());
	HandleTimeWorldSiegeRemain();
	worldsiegeNoticeWnd.KillTimer(5);
	worldsiegeNoticeWnd.SetTimer(5, 1000);
	WorldSiegeWnd(GetScript("WorldSiegeWnd")).SetWorldCastleSiegeHUDInfo(castleID, SiegeState);
}

function HandleOnClickworldSiegeOngoing_Btn()
{
	if(GetWindowHandle("WorldSiegeWnd").IsShowWindow())
	{
		GetWindowHandle("WorldSiegeWnd").HideWindow();		
	}
	else
	{
		if(isWorldSiegeInOuttime)
		{
			class'UICommonAPI'.static.DialogSetID(1);
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13200), string(self));			
		}
		else
		{
			WorldSiegeWnd(GetScript("WorldSiegeWnd")).API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO();
		}
	}
}

function HandleOnClickWorldSiegeWaiting_Btn()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);

	if(UserInfo.nLevel < 76)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13578));		
	}
	else
	{
		class'UICommonAPI'.static.DialogSetID(0);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(13864), string(self));
	}
}

function HandleTimeBalrogWarRemain()
{
	if(BalrogWarRemainTime <= 0)
	{
		BalrogNoticeWnd.KillTimer(7);
		SetWindowHide(BalrogNoticeWnd);
	}
	BalrogReadyNoticeText.SetText(GetTimeStringMS(BalrogWarRemainTime));
}

function HandleTimeWorldSiegeRemain()
{
	if(worldsiegeRemainTime <= 0)
	{
		worldsiegeNoticeWnd.KillTimer(5);

		if(!isWorldSiegeInOuttime)
		{
			SetWindowHide(worldsiegeNoticeWnd);
		}
		return;
	}
	worldSiegeNoticeText.SetText(GetTimeStringMS(worldsiegeRemainTime));
	class'WorldSiegeBoardWnd'.static.Inst().Time_txt.SetText(worldSiegeNoticeText.GetText());
}

function HandleTimeEndWorldSiegeInoutTime()
{
	if(worldSiegeRemainTimeInout <= 0)
	{
		worldsiegeNoticeWnd.KillTimer(6);
		SetWindowHide(worldsiegeNoticeWnd);
		isWorldSiegeInOuttime = false;
		return;
	}
	worldSiegeNoticeText.SetText(GetTimeStringMS(worldSiegeRemainTimeInout));
}

function bool IsInWorldSiegeStarted()
{
	return IsInWorldSiege && worldsiegeState == 1;
}

function HandleEvent_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_HUD_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_HUD_INFO packet;

	if(!class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_HUD_INFO(packet))
	{
		return;
	}
	switch(packet.nSiegeState)
	{
		case 1:
			if(IsInWorldSiege)
			{
				class'WorldSiegeBoardWnd'.static.Inst().API_C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO();
			}
			class'WorldSiegeLauncherWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
			break;
		default:
			class'WorldSiegeLauncherWnd'.static.Inst().m_hOwnerWnd.HideWindow();
			class'WorldSiegeBoardWnd'.static.Inst().EndWorldSiege();
			break;
	}
	IsInWorldSiege = true;
	SetWorldCastleSiegeHUDInfo(packet.nCastleID, packet.nSiegeState, packet.nNowTime, packet.nRemainTime);
	worldSiegeOngoing_Btn.ShowWindow();
	WorldSiegeWaiting_Btn.HideWindow();
}

function HandleEvent_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO packet;

	if(!class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO(packet))
	{
		return;
	}
	IsInWorldSiege = false;
	SetWorldCastleSiegeHUDInfo(packet.nCastleID, packet.nSiegeState, packet.nNowTime, packet.nRemainTime);
	worldSiegeOngoing_Btn.HideWindow();
	WorldSiegeWaiting_Btn.ShowWindow();
	class'WorldSiegeBoardWnd'.static.Inst().EndWorldSiege();
	class'WorldSiegeLauncherWnd'.static.Inst().m_hOwnerWnd.HideWindow();
}

function Handle_S_EX_BALROGWAR_HUD()
{
	local UIPacket._S_EX_BALROGWAR_HUD packet;
	local string BalrogText;

	if(!class'UIPacket'.static.Decode_S_EX_BALROGWAR_HUD(packet))
	{
		return;
	}
	if(packet.nState == 1)
	{
		BalrogText = GetSystemString(13989);
	}
	else if(packet.nState == 2)
	{
		BalrogText = GetSystemString(13990);
	}
	else if(packet.nState == 3)
	{
		BalrogText = GetSystemString(13991);
	}
	else if(packet.nState == 4)
	{
		BalrogNoticeWnd.KillTimer(7);
		SetWindowHide(BalrogNoticeWnd);
	}
	if(GetLanguage() == LANG_Russia || GetLanguage() == LANG_Euro)
	{
		BalrogReadyText.SetTooltipType("text");
		BalrogReadyText.SetTooltipText(BalrogText);
		BalrogText = GetEllipsisString(BalrogText, 50);
	}
	BalrogReadyText.SetText(BalrogText);

	if(packet.nProgressStep == 0)
	{
		setBalrogProgress(0);
	}
	else if(packet.nProgressStep == 1)
	{
		setBalrogProgress(1);			
	}
	else if(packet.nProgressStep == 2)
	{
		setBalrogProgress(2);
	}
	else if(packet.nProgressStep == 3)
	{
		setBalrogProgress(3);					
	}
	else if(packet.nProgressStep == 4)
	{
		setBalrogProgress(4);						
	}
	else if(packet.nProgressStep == 5)
	{
		setBalrogProgress(4, true);
	}
	if(packet.nState != 4)
	{
		BalrogWarRemainTime = packet.nLeftTime;
		BalrogNoticeWnd.KillTimer(7);
		BalrogNoticeWnd.SetTimer(7, 1000);
		setWindowShow(BalrogNoticeWnd);
	}
}

function setBalrogProgress(int nStep, optional bool bRed)
{
	if(bRed)
	{
		GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_Red");
		GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_Red");
		GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_Red");
		GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_Red");		
	}
	else
	{
		GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_on");
		GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_on");
		GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_on");
		GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_on");
	}
	switch(nStep)
	{
		case 0:
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex").HideWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex").HideWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex").HideWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex").HideWindow();
			break;
		case 1:
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex").ShowWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex").HideWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex").HideWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex").HideWindow();
			break;
		case 2:
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex").ShowWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex").ShowWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex").HideWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex").HideWindow();
			break;
		case 3:
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex").ShowWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex").ShowWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex").ShowWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex").HideWindow();
			break;
		case 4:
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex").ShowWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex").ShowWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex").ShowWindow();
			GetTextureHandle("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex").ShowWindow();
			break;
	}
}

function HandleOnClickBalrogReadyBtn()
{
	if(GetWindowHandle("BalrogWnd").IsShowWindow())
	{
		GetWindowHandle("BalrogWnd").HideWindow();		
	}
	else
	{
		GetWindowHandle("BalrogWnd").ShowWindow();
	}
}

function Handle_S_EX_DETHRONE_SEASON_INFO()
{
	local UIPacket._S_EX_DETHRONE_SEASON_INFO packet;

	if(!class'UIPacket'.static.Decode_S_EX_DETHRONE_SEASON_INFO(packet))
	{
		return;
	}
	if(packet.bOpen == 1)
	{
		DethroneNoticeAnim_Tex.Stop();
		DethroneNoticeAnim_Tex.SetLoopCount(1);
		DethroneNoticeAnim_Tex.Play();
		setWindowShow(DethroneNoticeWnd);

		if(!class'UIDATA_PLAYER'.static.IsInDethrone())
		{
			AddSystemMessage(13424);
		}		
	}
	else
	{
		SetWindowHide(DethroneNoticeWnd);

		if(isInitedDethrone)
		{
			AddSystemMessage(13425);
		}
	}
	if(!isInitedDethrone)
	{
		isInitedDethrone = true;
	}
	DethroneCharacterCreatewnd(GetScript("DethroneCharacterCreatewnd")).SetBOpen(packet.bOpen);
}

function HandleOnClickDethroneNoticeBtn()
{
	if(GetWindowHandle("DethroneWnd").IsShowWindow())
	{
		GetWindowHandle("DethroneWnd").HideWindow();		
	}
	else
	{
		GetWindowHandle("DethroneWnd").ShowWindow();
	}
}

function Handle_S_EX_ADEN_FORTRESS_SIEGE_HUD_INFO()
{
	local UIPacket._S_EX_ADEN_FORTRESS_SIEGE_HUD_INFO packet;

	if(!class'UIPacket'.static.Decode_S_EX_ADEN_FORTRESS_SIEGE_HUD_INFO(packet))
	{
		return;
	}
	switch(packet.nSiegeState)
	{
		case 0:
			FortressBattleText.SetText(GetSystemString(13237));
			setWindowShow(FortressBattleNoticeWnd);
			FortressBattleBtn.SetTexture("L2UI_EPIC.FortressBattleInfoWnd_FortressWaitingButton", "L2UI_EPIC.FortressBattleInfoWnd_FortressWaitingButton_Over", "L2UI_EPIC.FortressBattleInfoWnd_FortressWaitingButton_Down");
			break;
		case 1:
			FortressBattleText.SetText(GetSystemString(13238));
			setWindowShow(FortressBattleNoticeWnd);
			FortressBattleBtn.SetTexture("L2UI_EPIC.FortressBattleInfoWnd.FortressBattleInfoWnd_FortressProgressButton", "L2UI_EPIC.FortressBattleInfoWnd.FortressBattleInfoWnd_FortressProgressButton_Over", "L2UI_EPIC.FortressBattleInfoWnd.FortressBattleInfoWnd_FortressProgressButton_Down");
			break;
		case 2:
			SetWindowHide(FortressBattleNoticeWnd);
			GetWindowHandle("FortressBattleInfoWnd").HideWindow();
			break;
	}
	FortressBattleRemainTime = packet.nRemainTime;
	FortressBattleNoticeWnd.KillTimer(TIMER_FORTRESS_NOTICE);
	FortressBattleNoticeWnd.SetTimer(TIMER_FORTRESS_NOTICE, TIMER_FRESH_COOLTIME);
}

function HandleOnClickFortressBtn()
{
	if(GetWindowHandle("FortressBattleInfoWnd").IsShowWindow())
	{
		GetWindowHandle("FortressBattleInfoWnd").HideWindow();
	}
	else
	{
		GetWindowHandle("FortressBattleInfoWnd").ShowWindow();
	}
}

function HandleTimeFortressRemain()
{
	if(FortressBattleRemainTime < 0)
	{
		FortressBattleNoticeWnd.KillTimer(TIMER_FORTRESS_NOTICE);
		SetWindowHide(FortressBattleNoticeWnd);
		return;
	}
	FortressBattleNoticeText.SetText(GetTimeStringMS(FortressBattleRemainTime));
}

function API_RequestMCWCastleSiegeInfo(int castleID)
{
	class'SiegeAPI'.static.RequestMCWCastleSiegeInfo(castleID);
}

function API_C_EX_WORLDCASTLEWAR_MOVE_TO_HOST()
{
	local UserInfo UserInfo;
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_MOVE_TO_HOST packet;

	GetPlayerInfo(UserInfo);
	packet.nUserSID = UserInfo.nID;
	packet.nCastleID = 5;

	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_MOVE_TO_HOST(stream, packet))
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_MOVE_TO_HOST, stream);
	}
}

function Rq_C_EX_TIME_RESTRICT_FIELD_USER_LEAVE()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_TIME_RESTRICT_FIELD_USER_LEAVE, stream);
}

function setWindowShow(WindowHandle tmpWnd)
{
	setWindowShowHide(tmpWnd, true);
}

function SetWindowHide(WindowHandle tmpWnd)
{
	setWindowShowHide(tmpWnd, false);
}

function ShowTimeZoneExitDialog()
{
	local string Desc;

	if(class'UIAPI_WINDOW'.static.IsShowWindow("TimeZoneWnd"))
	{
		class'UIAPI_WINDOW'.static.HideWindow("TimeZoneWnd");
	}
	Desc = GetSystemMessage(13704);
	class'UICommonAPI'.static.DialogSetID(2);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, Desc, string(self));	
}

function bool IsTimeZoneUILabelType()
{
	if(getInstanceUIData().getIsClassicServer())
	{
		return true;
	}
	return false;	
}

function HandleAllHide()
{
	local int i;

	for(i = 0; i < allWindow.Length; i++)
	{
		SetWindowHide(allWindow[i]);
	}
}

function setWindowShowHide(WindowHandle tmpWnd, optional bool isShow)
{
	local int nWndWidth, nWndHeight, i, nWndWMax, nMoveX;

	local Rect rectWnd;

	if(isShow == tmpWnd.IsShowWindow())
	{
		return;
	}
	if(isShow)
	{
		tmpWnd.ShowWindow();
	}
	else
	{
		tmpWnd.HideWindow();
	}
	rectWnd = m_hOwnerWnd.GetRect();
	isShowInfoWnd = false;

	for(i = 0; i < allWindow.Length; i++)
	{
		if(allWindow[i].IsShowWindow())
		{
			allWindow[i].GetWindowSize(nWndWidth, nWndHeight);
			allWindow[i].MoveTo(rectWnd.nX + nWndWMax, rectWnd.nY);
			nWndWMax = nWndWMax + nWndWidth;
			isShowInfoWnd = true;
		}
	}
	if(isShowInfoWnd && checkState())
	{
		m_hOwnerWnd.ShowWindow();
	}
	else
	{
		m_hOwnerWnd.HideWindow();
	}
	nMoveX = WINDOW_W_MIN + nWndWMax - rectWnd.nWidth;
	m_hOwnerWnd.MoveTo(rectWnd.nX - nMoveX, rectWnd.nY);
	m_hOwnerWnd.SetWindowSize(WINDOW_W_MIN + nWndWMax, rectWnd.nHeight);
}

function HandleStageChange()
{
	if(checkState())
	{
		if(isShowInfoWnd)
		{
			m_hOwnerWnd.ShowWindow();
		}		
	}
	else
	{
		m_hOwnerWnd.HideWindow();

		if(GetGameStateName() != "COLLECTIONSTATE")
		{
			KillAllTimer();
		}
	}
}

function bool checkState()
{
	return GetGameStateName() == "GAMINGSTATE";
}

function string MakeMin(int Sec)
{
	return MakeFullSystemMsg(GetSystemMessage(3390), string(Sec / 60));
}

function string GetTimeStringMS(int Second)
{
	local int Min, Sec;

	Min = Second / 60;
	Sec = int(Second % 60);
	return Int2Str(Min) $ ":" $ Int2Str(Sec);
}

function string Int2Str(int Num)
{
	if(Num < 10)
	{
		return "0" $ string(Num);
	}
	return string(Num);
}

function string GetEllipsisString(string Str, int MaxWidth)
{
	local string fixedString;
	local int nWidth, nHeight, textWidth;

	textWidth = MaxWidth;
	GetTextSizeDefault(Str $ "...", nWidth, nHeight);

	if(nWidth < textWidth)
	{
		return Str;
	}
	fixedString = DivideStringWithWidth(Str, textWidth);

	if(fixedString != Str)
	{
		fixedString = fixedString $ "...";
	}
	return fixedString;
}

function Color GetColor(int R, int G, int B, int A)
{
	local Color tColor;

	tColor.R = R;
	tColor.G = G;
	tColor.B = B;
	tColor.A = A;
	return tColor;
}

function setWindowOrder()
{
	allWindow[allWindow.Length] = OlympiadNoticeWnd;
	allWindow[allWindow.Length] = TimeZoneNoticeWnd;
	allWindow[allWindow.Length] = siegeNoticeWnd;
	allWindow[allWindow.Length] = FortressBattleNoticeWnd;
	allWindow[allWindow.Length] = DethroneNoticeWnd;
	allWindow[allWindow.Length] = worldsiegeNoticeWnd;
	allWindow[allWindow.Length] = BalrogNoticeWnd;
}

defaultproperties
{
	m_OlympiadNoticeWndName="NoticeHUD.OlympiadNoticeWnd"
	m_TimeZoneNoticeWndName="NoticeHUD.TimeZoneNoticeWnd"
	m_SiegeNoticeWnd="NoticeHUD.SiegeNoticeWnd"
	m_FortressBattleNoticeWndName="NoticeHUD.FortressBattleNoticeWnd"
	m_WorldSiegeNoticeWnd="NoticeHUD.WorldSiegeNoticeWnd"
	m_DethroneNoticeWnd="NoticeHUD.DethroneNoticeWnd"
	m_BalrogNoticeWnd="NoticeHUD.BalrogNoticeWnd"
}
