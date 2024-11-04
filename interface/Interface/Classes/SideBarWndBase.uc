class SideBarWndBase extends UICommonAPI;

var SideBar SideBarScript;

function InitSideBarWndDefaultOnLoad()
{
	SetClosingOnESC();
	SideBarScript = SideBar(GetScript("SideBar"));
}

function HandleOnClickClose(string a_ButtonID)
{
	// End:0x42
	if(a_ButtonID == "Close_Btn")
	{
		m_hOwnerWnd.HideWindow();
		SideBarScript.SaveVOption(m_hOwnerWnd.m_WindowNameWithFullPath, false);
	}
}

function HandleOnShow()
{
	ToggleSideBarItem();
}

function HandleOnHide()
{
	ToggleSideBarItem();
}

event OnLoad()
{
	InitSideBarWndDefaultOnLoad();
}

event OnShow()
{
	HandleOnShow();
}

event OnHide()
{
	ToggleSideBarItem();
}

function ToggleSideBarItem()
{
	SideBarScript.ToggleByWindowName(m_hOwnerWnd.m_WindowNameWithFullPath, m_hOwnerWnd.IsShowWindow());
}

defaultproperties
{
}
