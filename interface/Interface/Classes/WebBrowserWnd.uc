class WebBrowserWnd extends UICommonAPI;

var string m_WindowName;

var WindowHandle		m_hWebBrowserWnd;
var WebBrowserHandle	m_hBrowserViewer;

var string				m_callBackFunction;

function OnRegisterEvent()
{
	RegisterEvent(EV_WebBrowser_ShowFileRegisterWnd);
//	RegisterEvent(EV_WebBrowser_FinishedLoading); �׽�Ʈ�ڵ� ����
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_hWebBrowserWnd=GetHandle(m_WindowName);
		m_hBrowserViewer=WebBrowserHandle(GetHandle(m_WindowName$".WebBrowser"));
	}
	else
	{
		m_hWebBrowserWnd=GetWindowHandle(m_WindowName);
		m_hBrowserViewer=GetWebBrowserHandle(m_WindowName$".WebBrowser");
	}
}

function OnShow()
{
	m_hBrowserViewer.ShowWindow();
}

function OnHide()
{
	m_hBrowserViewer.HideWindow();
}

function ShowFileRegisterWnd(String param)
{
	ParseString( param, "CallBack", m_callBackFunction );
	
	FileRegisterWndShow(FH_WEBBROWSER_FILE_UPLOAD);
}

function UploadFileFullPath(string path)
{
	local string command;
	
	command = m_callBackFunction$"('" $ path $ "')";

	m_hBrowserViewer.ExecuteJavaScript(command);
	
	// hide file register window
	FileRegisterWndHide();
}

/* �׽�Ʈ�ڵ� ����, ExecuteJavaScriptWithStringResult ���� �θ��� Javascript �Լ��� ������ 1�ʰ� �������� �߻���
function FinishedLoading(String param)
{
	local string url;
	local string result;

	ParseString( param, "url", url );

	if( url == m_hBrowserViewer.GetUrl() )
	{
		m_hBrowserViewer.ExecuteJavaScriptWithStringResult("getTest()", result);
	}
}
*/

function OnEvent(int Event_ID, String param)
{
	switch(Event_ID)
	{
	case EV_WebBrowser_ShowFileRegisterWnd:
		ShowFileRegisterWnd(param);
		break;
/* �׽�Ʈ�ڵ� ����
	case EV_WebBrowser_FinishedLoading:
		FinishedLoading(param);
		break;
*/
	}
}

defaultproperties
{
     m_WindowName="WebBrowserWnd"
}
