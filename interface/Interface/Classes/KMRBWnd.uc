class KMRBWnd extends UICommonAPI;

const StartTimerID = 1234;
const FadeTimerID = 1235;

var TextureHandle ageLimitDscrp_Tex;
var TextureHandle ageLimit_Tex;
var WindowHandle Me;

function OnRegisterEvent()
{
	RegisterEvent(2900);
}

function OnLoad()
{
	Me = GetWindowHandle("KMRBWnd");
	ageLimitDscrp_Tex = GetTextureHandle("KMRBWnd.ageLimitDscrp_Tex");
}

function OnEvent(int a_EventID, string a_Param)
{
	// End:0x15
	if(a_EventID == 2900)
	{
		CheckResolution();
	}
}

function StartLoginStateFunc()
{
	Me.KillTimer(StartTimerID);
	StartLoginState();
}

event OnShow()
{
	CheckResolution();
	Me.KillTimer(StartTimerID);
	Me.KillTimer(FadeTimerID);
	Me.SetTimer(StartTimerID, 4000);
	Me.SetTimer(FadeTimerID, 3000);
	Me.SetFocus();
	Me.SetAlpha(255);
}

event OnTimer(int TimerID)
{
	// End:0x18
	if(TimerID == StartTimerID)
	{
		StartLoginStateFunc();		
	}
	else if(TimerID == FadeTimerID)
	{
		Me.SetAlpha(0, 1.0f);
		Me.KillTimer(FadeTimerID);
	}
}

function CheckResolution()
{
	local int CurrentMaxWidth, CurrentMaxHeight;

	GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
	ageLimitDscrp_Tex.SetAnchor("KMRBWnd", "CenterCenter", "CenterCenter", 0, 0);
	ageLimitDscrp_Tex.SetWindowSizeRel43(1.0f, 1.0f, 0, 0);
}

function float GetAbs(float Num)
{
	// End:0x15
	if(Num < 0)
	{
		return - Num;
	}
	return Num;
}

defaultproperties
{
}
