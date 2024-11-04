//================================================================================
// GMDetailStatusWndClassic.
// emu-dev.ru
//================================================================================

class GMDetailStatusWndClassic extends DetailStatusWndClassic;

var string temp1;
var bool bShow;
var UserInfo m_ObservingUserInfo;

function OnRegisterEvent()
{
	RegisterEvent(EV_GMObservingUserInfoUpdateClassic);
	RegisterEvent(EV_GMVitalityEffectInfo);
	RegisterEvent(EV_GMUpdateHennaInfo);
}

function OnLoad()
{
	temp1 = "Water/Air/Ground";
	InitializeCOD();
	Me.EnableWindow();
	MaxVitality = GetMaxVitality();
	bShow = false;
}

function OnShow()
{
	InitStatusInfo();
}

function OnHide()
{
}

function OnEnterState(name a_CurrentStateName)
{
}

function ShowStatus(string a_Param)
{
	if(a_Param == "")
	{
		return;
	}
	if(bShow)
	{
		m_hOwnerWnd.HideWindow();
		bShow = false;
	}
	else
	{
		class'GMAPI'.static.RequestGMCommand(GMCOMMAND_StatusInfo, a_Param);
		bShow = true;
	}
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case EV_GMObservingUserInfoUpdateClassic:
			if(HandleGMObservingUserInfoUpdate())
			{
				m_hOwnerWnd.ShowWindow();
				m_hOwnerWnd.SetFocus();
			}
			break;
		case EV_GMVitalityEffectInfo:
			HandleVitalityEffectInfo(a_Param);
			break;
		case EV_GMUpdateHennaInfo:
			HandleGMUpdateHennaInfo(a_Param);
			break;
	}
}

function bool HandleGMObservingUserInfoUpdate()
{
	local UserInfo ObservingUserInfo;

	if(class'GMAPI'.static.GetObservingUserInfo(ObservingUserInfo))
	{
		HandleUpdateUserInfo();
		return true;
	}
	else
	{
		return false;
	}
}

function HandleGMUpdateHennaInfo(string a_Param)
{
	HandleUpdateHennaInfo(a_Param);
	HandleGMObservingUserInfoUpdate();
}

function bool GetMyUserInfo(out UserInfo a_MyUserInfo)
{
	local bool Result;

	Result = class'GMAPI'.static.GetObservingUserInfo(m_ObservingUserInfo);

	if(Result)
	{
		a_MyUserInfo = m_ObservingUserInfo;
		return true;
	}
	else
	{
		return false;
	}
}

function string GetMovingSpeed(UserInfo a_UserInfo)
{
	local int WaterMaxSpeed, WaterMinSpeed, AirMaxSpeed, AirMinSpeed, GroundMaxSpeed, GroundMinSpeed;

	local string MovingSpeed;

	WaterMaxSpeed = float(a_UserInfo.nWaterMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
	WaterMinSpeed = float(a_UserInfo.nWaterMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
	AirMaxSpeed = float(a_UserInfo.nAirMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
	AirMinSpeed = float(a_UserInfo.nAirMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
	GroundMaxSpeed = float(a_UserInfo.nGroundMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
	GroundMinSpeed = float(a_UserInfo.nGroundMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
	MovingSpeed = string(WaterMaxSpeed) $ "," $ string(WaterMinSpeed);
	MovingSpeed = MovingSpeed $ "/" $ string(AirMaxSpeed) $ "," $ string(AirMinSpeed);
	MovingSpeed = MovingSpeed $ "/" $ string(GroundMaxSpeed) $ "," $ string(GroundMinSpeed);
	return MovingSpeed;
}

function float GetMyExpRate()
{
	return m_ObservingUserInfo.fExpPercentRate * 100.0;
}

defaultproperties
{
	m_WindowName="GMDetailStatusWndClassic"
	m_Statsinfo_UsePoint_Win="GMDetailStatusWndClassic.Statsinfo_UsePoint_Win"
}