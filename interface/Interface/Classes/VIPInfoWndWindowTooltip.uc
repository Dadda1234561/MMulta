class VIPInfoWndWindowTooltip extends UICommonAPI;

const GAB_MINE_W= 3;
const GAB_VIPS_W= 20;
const VIP_MAX_GRADE= 10;

var string m_WindowName;
var WindowHandle Me;
var SideBar SideBarScript;
var StatusBarHandle VIPBar;
var WindowHandle VIPs;
var TextBoxHandle VIPText;
var WindowHandle Mine;
var bool isMax;
var int barWidth;

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	SideBarScript = SideBar(GetScript("SideBar"));
	VIPBar = GetStatusBarHandle(m_WindowName $ ".VIPBar");
	VIPs = GetWindowHandle(m_WindowName $ ".VIPs");
	VIPText = GetTextBoxHandle(m_WindowName $ ".VIPs.VIPText");
	Mine = GetWindowHandle(m_WindowName $ ".Mine");
}

function OnRegisterEvent()
{
	RegisterEvent(EV_VipInfo);
}

function OnLoad()
{
	Initialize();
}

function OnShow()
{
	HandleOnShow();
}

function OnHide()
{
	HandleOnHide();
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_VipInfo:
			HandleEV_VipInfo(param);
			break;
	}
}

function HandleEV_VipInfo(string param)
{
	local int CurrVipLevel;
	local int CurrVipPoint;
	local int NextVipPoint;
	local int DisappearPoint;
	local int PrevVipLevel;
	local int DisappearNextPoint;
	local int afterDisappearPoint;
	local int totalPoint;
	local int barW;

	ParseInt(param,"CurrVipLevel",CurrVipLevel);
	ParseInt(param,"CurrVipPoint",CurrVipPoint);
	ParseInt(param,"NextVipPoint",NextVipPoint);
	ParseInt(param,"DisappearPoint",DisappearPoint);
	ParseInt(param,"PrevVipLevel",PrevVipLevel);
	ParseInt(param,"DisappearNextPoint",DisappearNextPoint);
	isMax = CurrVipLevel == VIP_MAX_GRADE;
	if ( isMax )
	{
		totalPoint = CurrVipPoint;
	} else {
		totalPoint = NextVipPoint;
	}
	VIPBar.SetPoint(int64(CurrVipPoint), int64(totalPoint));
	SetStartX();
	barW = GetBarWidth();
	if ( CurrVipLevel == 0 )
	{
		VIPs.HideWindow();
	}
	else
	{
		VIPs.ShowWindow();
	}
	VIPText.SetText(GetSystemString(5819) @ string(PrevVipLevel));
	VIPs.Move(barW / totalPoint * DisappearNextPoint - GAB_VIPS_W,0);
	if ( DisappearPoint == 0 )
	{
		Mine.HideWindow();
	}
	else
	{
		Mine.ShowWindow();
	}
	afterDisappearPoint = CurrVipPoint - DisappearPoint;
	if(afterDisappearPoint < 0)
	{
		afterDisappearPoint = 0;
	}
	Mine.Move(barW / totalPoint * afterDisappearPoint - GAB_MINE_W,0);
	Debug("HandleEV_VipInfo" @ string(barW) @ string(totalPoint) @ string(afterDisappearPoint) @ string(barW / totalPoint * afterDisappearPoint));
}

function SetStartX()
{
	local Rect barRect;
	local Rect mineRect;
	local Rect vipsRect;

	barRect = VIPBar.GetRect();
	vipsRect = VIPs.GetRect();
	mineRect = Mine.GetRect();
	VIPs.MoveTo(barRect.nX - GAB_VIPS_W,vipsRect.nY);
	Mine.MoveTo(barRect.nX - GAB_MINE_W,mineRect.nY);
}

function string GetVipTexturePath(int Level)
{
	return "L2UI_NewTex.SideBar.SideBar_BRVIPIcon" $ string(Level);
}

function HandleOnShow()
{
}

function HandleOnHide()
{
}

function int GetBarWidth()
{
	local Rect barRect;

	barRect = VIPBar.GetRect();
	return barRect.nWidth;
}

defaultproperties
{
}
