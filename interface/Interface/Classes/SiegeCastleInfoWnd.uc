//================================================================================
// SiegeCastleInfoWnd.
//================================================================================

class SiegeCastleInfoWnd extends UICommonAPI;

const MAX_Page = 3;

struct EVMCW_CastleInfoStruct
{
	var int castleID;
	var int OwnerPledgeID;
	var string OwnerPledgeName;
	var string OwnerPledgeMasterName;
	var int TaxRate;
	var INT64 CurrentIncome;
	var INT64 TotalIncome;
	var int NextSiegeTime;
};

var string m_WindowName;
var WindowHandle Me;
var TextBoxHandle txtTaxNumber;
var TextBoxHandle txtTaxNextWeek;
var TextBoxHandle txtSiegeCalendarYearNumber;
var TextBoxHandle txtSiegeCalendarMonthNumber;
var TextBoxHandle txtSiegeCalendarDayNumber;
var TextBoxHandle txtWaitingTime;
var TextBoxHandle txtProgressTime;
var int currentTabNum;
var array<int> castleIDs;

function SetcastleIDs()
{
	castleIDs.Length = 2;
	castleIDs[0] = 3;
	castleIDs[1] = 7;
}

function Initialize()
{
	SetcastleIDs();
	Me = GetWindowHandle(m_WindowName);
	txtSiegeCalendarYearNumber = GetTextBoxHandle(m_WindowName $ ".txtSiegeCalendarYearNumber");
	txtSiegeCalendarMonthNumber = GetTextBoxHandle(m_WindowName $ ".txtSiegeCalendarMonthNumber");
	txtSiegeCalendarDayNumber = GetTextBoxHandle(m_WindowName $ ".txtSiegeCalendarDayNumber");
	txtWaitingTime = GetTextBoxHandle(m_WindowName $ ".txtWaitingTime");
	txtProgressTime = GetTextBoxHandle(m_WindowName $ ".txtProgressTime");
}

function OnRegisterEvent()
{
	RegisterEvent(EV_MCW_CastleInfo);
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
		case EV_MCW_CastleInfo:
			HandleEVMCW_CastleInfo(param);
			break;
		default:
	}
}

function OnShow()
{
	if(ObserverWnd(GetScript("ObserverWnd")).m_bObserverMode)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(781));
		Me.HideWindow();
		return;
	}
	Me.SetFocus();
	ClearDayInfo();
	HideWindowHandleAll();
	RequestMCWCastleInfo_All();
}

function HideWindowHandleAll()
{
	local int i;

	currentTabNum = 0;
	
	for (i = 0 ;i < MAX_Page; i++)
	{
		GetCastleWindowHandleByTabNum(i).HideWindow();
	}
}

function ClearDayInfo()
{
	txtSiegeCalendarYearNumber.SetText("-");
	txtSiegeCalendarMonthNumber.SetText("-");
	txtSiegeCalendarDayNumber.SetText("-");
	txtWaitingTime.SetText(GetSystemString(3979));
	txtProgressTime.SetText(GetSystemString(3979));
}

function RequestMCWCastleInfo_All()
{
	local int i;

	
	for (i = 0;i < castleIDs.Length;i++)
	{
		Class 'SiegeAPI'.static.RequestMCWCastleInfo(castleIDs[i]);
	}
}

function HandleEVMCW_CastleInfo(string param)
{
	local int tabNum;
	local L2UITime L2UITime;
	local EVMCW_CastleInfoStruct MCW_CastleInfo;
	local TextureHandle textureCastleEmblem;
	local TextBoxHandle txtCastleName;
	local TextBoxHandle txtPledgeName;
	local TextBoxHandle txtPledgeMasterName;

	if(! Me.IsShowWindow())
	{
		return;
	}
	ParseInt(param, "NextSiegeTime", MCW_CastleInfo.NextSiegeTime);
	if(MCW_CastleInfo.NextSiegeTime == 0)
	{
		return;
	}
	tabNum = currentTabNum;
	currentTabNum++;
	ParseInt(param, "CastleID", MCW_CastleInfo.castleID);
	GetCastleWindowHandleByTabNum(tabNum).ShowWindow();
	ParseInt(param, "OwnerPledgeID", MCW_CastleInfo.OwnerPledgeID);
	ParseString(param, "OwnerPledgeName", MCW_CastleInfo.OwnerPledgeName);
	ParseString(param, "OwnerPledgeMasterName", MCW_CastleInfo.OwnerPledgeMasterName);
	ParseInt(param, "TaxRate", MCW_CastleInfo.TaxRate);
	ParseINT64(param, "CurrentIncome", MCW_CastleInfo.CurrentIncome);
	ParseINT64(param, "TotalIncome", MCW_CastleInfo.TotalIncome);
	GetTimeStruct(MCW_CastleInfo.NextSiegeTime, L2UITime);
	textureCastleEmblem = GetTextureHandle(m_WindowName $ "." $ GetCastleInfoWndNameByTabNum(tabNum) $ ".textureCastleEmblem");
	txtCastleName = GetTextBoxHandle(m_WindowName $ "." $ GetCastleInfoWndNameByTabNum(tabNum) $ ".txtCastleName");
	txtPledgeName = GetTextBoxHandle(m_WindowName $ "." $ GetCastleInfoWndNameByTabNum(tabNum) $ ".txtPledgeName");
	txtPledgeMasterName = GetTextBoxHandle(m_WindowName $ "." $ GetCastleInfoWndNameByTabNum(tabNum) $ ".txtPledgeMasterName");
	txtTaxNumber = GetTextBoxHandle(m_WindowName $ "." $ GetCastleInfoWndNameByTabNum(tabNum) $ ".txtTaxNumber");
	txtTaxNextWeek = GetTextBoxHandle(m_WindowName $ "." $ GetCastleInfoWndNameByTabNum(tabNum) $ ".txtTaxNextWeek");
	textureCastleEmblem.SetTexture(GetCurrentCastleEmblem(MCW_CastleInfo.castleID));
	SetClanEmblem(MCW_CastleInfo.OwnerPledgeID, tabNum);
	txtCastleName.SetText(GetCastleName(MCW_CastleInfo.castleID));
	txtPledgeName.SetText(MCW_CastleInfo.OwnerPledgeName);
	txtPledgeMasterName.SetText(MCW_CastleInfo.OwnerPledgeMasterName);
	txtTaxNumber.SetText(string(MCW_CastleInfo.TaxRate));
	txtTaxNextWeek.SetText(MakeCostStringINT64(MCW_CastleInfo.CurrentIncome));
	txtSiegeCalendarYearNumber.SetText(string(L2UITime.nYear));
	txtSiegeCalendarMonthNumber.SetText(Int2Str(L2UITime.nMonth));
	txtSiegeCalendarDayNumber.SetText(Int2Str(L2UITime.nDay));
	SetWaitintTime(L2UITime.nHour, L2UITime.nMin, L2UITime.nSec);
	SetProgressTime(L2UITime.nHour, L2UITime.nMin, L2UITime.nSec);
}

function SetWaitintTime(int NextSiegeHour, int NextSiegeMin, int NextSiegeSec)
{
	txtWaitingTime.SetText(Int2Str(NextSiegeHour - 2) $ ":" $ Int2Str(NextSiegeMin) $ "~" $ Int2Str(NextSiegeHour) $ ":" $ Int2Str(NextSiegeMin));
}

function SetProgressTime(int NextSiegeHour, int NextSiegeMin, int NextSiegeSec)
{
	txtProgressTime.SetText(Int2Str(NextSiegeHour) $ ":" $ Int2Str(NextSiegeMin) $ "~" $ Int2Str(NextSiegeHour + 1) $ ":" $ Int2Str(NextSiegeMin));
}

function string GetCurrentCastleEmblem(int castleID)
{
	switch (castleID)
	{
		case 3:
			return "L2UI_ct1.SiegeWnd.SiegeWnd_SiegeCastleInfo_Flag_Giran";
			break;
		case 7:
			return "L2UI_ct1.SiegeWnd.SiegeWnd_SiegeCastleInfo_Flag_Godard";
			break;
		default:
	}
}

function SetClanEmblem(int PledgeId, int tabNum)
{
	local Texture PledgeCrestTexture;
	local Texture PledgeAllianceCrestTexture;
	local bool bPledge;
	local bool bAlliance;
	local TextureHandle texturePledge;
	local TextureHandle texturePledgeCrest;

	texturePledge = GetTextureHandle(m_WindowName $ "." $ GetCastleInfoWndNameByTabNum(tabNum) $ ".texturePledge");
	texturePledgeCrest = GetTextureHandle(m_WindowName $ "." $ GetCastleInfoWndNameByTabNum(tabNum) $ ".texturePledgeCrest");
	bPledge = Class 'UIDATA_CLAN'.static.GetCrestTexture(PledgeId, PledgeCrestTexture);
	bAlliance = Class 'UIDATA_CLAN'.static.GetAllianceCrestTexture(PledgeId, PledgeAllianceCrestTexture);
	texturePledge.SetTexture("");
	texturePledgeCrest.SetTexture("");
	if (bPledge)
	{
		texturePledge.SetTextureWithObject(PledgeCrestTexture);
	}
	if (bAlliance)
	{
		texturePledgeCrest.SetTextureWithObject(PledgeAllianceCrestTexture);
	}
}

function int GetCastleID()
{
	return 3;
}

function int GetTabNumByCastleID(int castleID)
{
	local int i;

	for (i = 0;i < castleIDs.Length;i++)
	{
		if (castleIDs[i] == castleID)
		{
			return i;
		}
	}
}

function string Int2Str(int Num)
{
	if (Num < 10)
	{
		return "0" $ string(Num);
	}
	return string(Num);
}

function string GetCastleInfoWndNameByTabNum(int tabNum)
{
	return "SiegeCastleInfoWnd_Tab0" $ string(tabNum + 1);
}

function WindowHandle GetCastleWindowHandleByTabNum(int tabNum)
{
	return GetWindowHandle(m_WindowName $ "." $ GetCastleInfoWndNameByTabNum(tabNum));
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Class 'UIAPI_WINDOW'.static.HideWindow("SiegeCastleInfoWnd");
}

defaultproperties
{
     m_WindowName="SiegeCastleInfoWnd"
}
