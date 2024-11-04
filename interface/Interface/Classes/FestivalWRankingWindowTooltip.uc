//================================================================================
// FestivalWRankingWindowTooltip.
// emu-dev.ru
//================================================================================
class FestivalWRankingWindowTooltip extends UICommonAPI;

var WindowHandle Me;
var string m_WindowName;
var FestivalWRankingWnd festivalWRankingWndScript;
var TextureHandle GiftBox_Tex;

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	festivalWRankingWndScript = FestivalWRankingWnd(GetScript("festivalWRankingWnd"));
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
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		Me.HideWindow();
	}
	else
	{
		SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), true);
		festivalWRankingWndScript.Rq_C_EX_WRANKING_FESTIVAL_MY_RECEIVED_BONUS();
	}
}

event OnHide()
{
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), false);
}

event OnClickButton(string Name)
{
	local WindowHandle m_FestivalWRankingWnd;

	m_FestivalWRankingWnd = GetWindowHandle("FestivalWRankingWnd");
	switch(Name)
	{
		case "Join_Btn":
			if(m_FestivalWRankingWnd.IsShowWindow())
			{
				m_FestivalWRankingWnd.HideWindow();
			}
			else
			{
				m_FestivalWRankingWnd.ShowWindow();
				m_FestivalWRankingWnd.SetFocus();
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
	local string rankingBoxPath, tooltipUserName;
	local TextBoxHandle nameTextBox;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	rankingBoxPath = GetRankingRewardBoxPathByRankingGroup(RankingGroup);
	rewardItemWindow = GetItemWindowHandle(rankingBoxPath $ ".Item_ItemWnd");
	iInfo.bDisabled = 0;

	if(!rewardItemWindow.SetItem(0, iInfo))
	{
		rewardItemWindow.AddItem(iInfo);
	}
	tooltipUserName = UserName;
	nameTextBox = GetTextBoxHandle(rankingBoxPath $ ".ItemName_Txt");
	nameTextBox.SetTooltipType("Text");
	nameTextBox.SetTooltipString(tooltipUserName);
	util.GetEllipsisString(UserName, 150);
	nameTextBox.SetText(UserName);
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
