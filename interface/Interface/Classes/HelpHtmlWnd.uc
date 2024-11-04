class HelpHtmlWnd extends UICommonAPI;

var bool m_bShow;
var string m_WindowName;
var HtmlHandle m_hHelpHtmlWndHtmlViewer;

function OnRegisterEvent()
{
	RegisterEvent(EV_ShowHelp);
	RegisterEvent(EV_LoadHelpHtml);
}

function OnLoad()
{
	SetClosingOnESC();
	RegisterState("HelpHtmlWnd", "GamingState");
	RegisterState("HelpHtmlWnd", "LoginState");
	m_hHelpHtmlWndHtmlViewer = GetHtmlHandle("HelpHtmlWnd.HtmlViewer");
	m_bShow = false;
}

function OnShow()
{
	m_bShow = true;
}

function OnHide()
{
	m_bShow = false;
}

function OnEvent(int Event_ID, String param)
{
	// ���� ���� �� ���� 
	local string strPath;

	ParseString(param, "FilePath", strPath);

	if(GetGameStateName() != "SERVERLISTSTATE") //return;
	{
		// ���� ���� ������Ʈ�� �ƴ϶��, Ŭ���Ŀ����� �̺�Ʈ�� �޴´�.
		//if(! getInstanceUIData().getIsClassicServer())
		if(strPath != (GetLocalizedL2TextPathNameUC() $ "ev_eventcollector001.htm") && strPath != (GetLocalizedL2TextPathNameUC() $ "g_attendance_help001.htm") && strPath != (GetLocalizedL2TextPathNameUC() $ "g_l2pass_help.htm") && !getInstanceUIData().getIsClassicServer())
		{
			return;
		}
	}

	if(Event_ID == EV_ShowHelp)
	{
		HandleShowHelp(param);
	}
	else if(Event_ID == EV_LoadHelpHtml)
	{
		HandleLoadHelpHtml(param);
	}
}

function HandleShowHelp(string param)
{
	local string strPath;

	if(m_bShow)
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		class'UIAPI_WINDOW'.static.HideWindow("HelpHtmlWnd");
	}
	else
	{
		ParseString(param, "FilePath", strPath);

//		Debug ( "HandleShowHelp" @ strPath ) ;
		if(Len(strPath) > 0)
		{
			//���� ������ ���򸻿��� ���� ����â�� �������� ���� ������ �߰�.
			if(strPath == (GetLocalizedL2TextPathNameUC() $ "server_help.htm"))
			{
				class'UIAPI_WINDOW'.static.SetAlwaysOnTop("HelpHtmlWnd", true);
			}
			else
			{
				class'UIAPI_WINDOW'.static.SetAlwaysOnTop("HelpHtmlWnd", false);
			}

			m_hHelpHtmlWndHtmlViewer.LoadHtml(strPath);
			PlayConsoleSound(IFST_WINDOW_OPEN);
			class'UIAPI_WINDOW'.static.ShowWindow("HelpHtmlWnd");
			class'UIAPI_WINDOW'.static.SetFocus("HelpHtmlWnd");
		}
	}
}

function exShowHelp(string strPath)
{
	if(class'UIAPI_WINDOW'.static.IsShowWindow("HelpHtmlWnd"))
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		class'UIAPI_WINDOW'.static.HideWindow("HelpHtmlWnd");
	}
	else
	{
		if(Len(strPath) > 0)
		{
			m_hHelpHtmlWndHtmlViewer.LoadHtml(strPath);
			PlayConsoleSound(IFST_WINDOW_OPEN);
			class'UIAPI_WINDOW'.static.ShowWindow("HelpHtmlWnd");
			class'UIAPI_WINDOW'.static.SetFocus("HelpHtmlWnd");
		}
	}
}

function HandleLoadHelpHtml(string param)
{
	local string strHtml;

	ParseString(param, "HtmlString", strHtml);

	if(Len(strHtml) > 0)
	{
		m_hHelpHtmlWndHtmlViewer.LoadHtmlFromString(strHtml);
	}
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
	m_WindowName="HelpHtmlWnd"
}
