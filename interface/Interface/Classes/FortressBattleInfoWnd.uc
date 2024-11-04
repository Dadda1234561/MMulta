//================================================================================
// FortressBattleInfoWnd.
//================================================================================

class FortressBattleInfoWnd extends UICommonAPI;

const TELEPORT_ID= 432;
var string m_WindowName;
var WindowHandle Me;
var WindowHandle FortressBattleInfoPopupWnd;
var TextBoxHandle Txt_TeleportInfo;

function Initialize()
{
	Me = GetWindowHandle(m_WindowName);
	FortressBattleInfoPopupWnd = GetWindowHandle(m_WindowName $ ".FortressBattleInfoPopupWnd");
	Txt_TeleportInfo = GetTextBoxHandle(m_WindowName $ ".FortressBattleInfoPopupWnd.DescriptionTextBox");
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
}

function OnShow()
{
	FortressBattleInfoPopupWnd.HideWindow();
}

function OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "OkButton":
			FortressBattleInfoPopupWnd.HideWindow();
			Class'TeleportListAPI'.static.RequestTeleport(TELEPORT_ID);
			Me.HideWindow();
			break;
		case "CancleButton":
			FortressBattleInfoPopupWnd.HideWindow();
			break;
		case "Teleport_Btn":
			FortressBattleInfoPopupWnd.ShowWindow();
			SetTeleportInfo();
			break;
	}
}

function SetTeleportInfo()
{
	Txt_TeleportInfo.SetText(MakeFullSystemMsg(GetSystemMessage(13166),MakeCostStringINT64(getInstanceUIData().GetTeleportPriceByID(TELEPORT_ID))));
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if ( FortressBattleInfoPopupWnd.IsShowWindow() )
		FortressBattleInfoPopupWnd.HideWindow();
	else
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
     m_WindowName="FortressBattleInfoWnd"
}
