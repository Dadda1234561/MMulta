class MultaWikiWnd extends L2UIGFxScript;

var WindowHandle Me;
var string m_WindowName;


function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle(m_WindowName);
}

function OnEvent(int Event_ID, string param)
{
	AddSystemMessageString(Event_ID@param);
	if( Event_ID == EV_Test_7 )
	{
		SceneClipView(GetScript("SceneClipView")).customPlayUsm(224, 44, 894, 620, 1, 4, "unique_01b.usm", SceneClipView(GetScript("SceneClipView")).const.MOVIEID_GACHA_URSR, m_WindowName);
	}
}

defaultproperties
{
	m_WindowName="MultaWikiWnd"
}