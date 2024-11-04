//================================================================================
// FestivaRankingWindowTooltip.
// emu-dev.ru
//================================================================================
class FestivaRankingWindowTooltip extends UICommonAPI;

var WindowHandle Me;
var string m_WindowName;
var FestivalRankingWnd festivalRankingWndScript;
var TextureHandle GiftBox_Tex;

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	festivalRankingWndScript = FestivalRankingWnd(GetScript("festivalRankingWnd"));
	GiftBox_Tex = GetTextureHandle(m_WindowName $ ".FestivalInner_Wnd.GiftBox_Tex");
	GiftBox_Tex.HideWindow();
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

event OnShow()
{
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), true);
	festivalRankingWndScript.C_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS();
}

event OnHide()
{
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), false);
}

event OnClickButton(string Name)
{
	local WindowHandle m_FestivalRankingWnd;

	m_FestivalRankingWnd = GetWindowHandle("FestivalRankingWnd");
	switch(Name)
	{
		case "Join_Btn":
			if(m_FestivalRankingWnd.IsShowWindow())
			{
				m_FestivalRankingWnd.HideWindow();
			}
			else
			{
				m_FestivalRankingWnd.ShowWindow();
				m_FestivalRankingWnd.SetFocus();
			}
			break;
	}
}

function SetTimeText(string timeString)
{
	GetTextBoxHandle(m_WindowName $ ".FestivalInner_Wnd.TimeNumber_Txt").SetText(timeString);
}

function SetTimerState(string timerTextureName)
{
	GetTextureHandle(m_WindowName $ ".FestivalInner_Wnd.FestivalProgressIcon_Tex").SetTexture(timerTextureName);
}

function SetRankingRewardInfoBig(int RankingGroup, string UserName, INT64 Amount, ItemInfo iInfo)
{
	local ItemWindowHandle rewardItemWindow;
	local string rankingBoxPath;

	rankingBoxPath = GetRankingRewardBoxPathByRankingGroup(RankingGroup);
	rewardItemWindow = GetItemWindowHandle(rankingBoxPath $ ".Item_ItemWnd");
	rewardItemWindow.Clear();
	rewardItemWindow.AddItem(iInfo);
	GetTextBoxHandle(rankingBoxPath $ ".ItemName_Txt").SetText(UserName);
	GetTextBoxHandle(rankingBoxPath $ ".ItemNumber_Txt").SetText(MakeCostString(string(Amount)));
}

function SetGiftBox(bool bShow)
{
	if(bShow)
	{
		GiftBox_Tex.ShowWindow();
	}
	else
	{
		GiftBox_Tex.HideWindow();
	}
}

function string GetRankingRewardBoxPathByRankingGroup(int RankingGroup)
{
	return m_WindowName $ ".FestivalInner_Wnd.itemGroup_Wnd0" $ string(RankingGroup - 1);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
}

defaultproperties
{
}
