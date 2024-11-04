class TutorialViewerWnd extends UICommonAPI;

var HtmlHandle m_hTutorialViewerWndHtmlTutorialViewer;

function OnRegisterEvent()
{
	RegisterEvent( EV_TutorialViewerWndShow );
	RegisterEvent( EV_TutorialViewerWndHide );
}

function OnLoad()
{
	SetClosingOnESC();

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	m_hTutorialViewerWndHtmlTutorialViewer=GetHtmlHandle("TutorialViewerWnd.HtmlTutorialViewer");
}

function onShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);
}

function string getTitleString(string HtmlString)
{
	local int N;
	local string Str;

	N = InStr(HtmlString, "</title>");
	Str = Left(HtmlString, N);
	Str = Mid(Str, InStr(Str, "<title>") + Len("<title>"), Len(Str));
	return Str;	
}

function OnEvent( int Event_ID, string param )
{
	local string HtmlString;
	// ldw local Rect rect;
	local int ViewerType;

	//local int HtmlHeight;

	switch( Event_ID )
	{
	case EV_TutorialViewerWndShow :
		ParseString(param, "HtmlString", HtmlString);
		ParseInt(param, "ViewerType", ViewerType);
		//Debug("Ʃ�丮�� �̺�Ʈ ���̱�");
		if(ViewerType == 1){
			m_hTutorialViewerWndHtmlTutorialViewer.SetWindowTitle(GetSystemString(448));
			m_hTutorialViewerWndHtmlTutorialViewer.LoadHtmlFromString(HtmlString);
			// ldw rect=class'UIAPI_WINDOW'.static.GetRect("TutorialViewerWnd");
			// ldw HtmlHeight=m_hTutorialViewerWndHtmlTutorialViewer.GetFrameMaxHeight();

	//		debug("rect.nX:"$rect.nX$", rect.nY:"$rect.nY$", rect.nWidth:"$rect.nWidth$", rect.nHeight:"$rect.nHeight$", Height:"$HtmlHeight);

			/*
			if(HtmlHeight < 256) 
				HtmlHeight = 256;
			else if(HtmlHeight > 680-8) // �̼�ġ�� ���� �ҽ��� �״�� �����°� - lancelot 2006. 9. 26
				HtmlHeight = 680-8;
			*/
			
			/* ldw 
			if(HtmlHeight < 328) 
				HtmlHeight = 328;
			else if(HtmlHeight > 680-8) // ��Ų ���� ������ ���� - innowind 2007. 6. 22
				HtmlHeight = 680-8;

			rect.nHeight=HtmlHeight+30+8;		// +26�� Frame ���̿� ��� �ؽ��� ���̸� ���Ѱ�.  +8�� Html �� �Ʒ��κ��� ���� ������ ������ �־ ���Ƿ� ����ġ�� �־��ذ�
*/

	//		debug("rect.nX:"$rect.nX$", rect.nY:"$rect.nY$", rect.nWidth:"$rect.nWidth$", rect.nHeight:"$rect.nHeight$", Height:"$HtmlHeight);
			//class'UIAPI_WINDOW'.static.SetWindowSize("TutorialViewerWnd.texTutorialViewerBack2", rect.nWidth, rect.nHeight-32-9);
			//class'UIAPI_WINDOW'.static.MoveTo("TutorialViewerWnd.texTutorialViewerBack3", rect.nX, rect.nY+rect.nHeight-9);

			//class'UIAPI_WINDOW'.static.SetWindowSize("TutorialViewerWnd.HtmlTutorialViewer", rect.nWidth-15, rect.nHeight-32-9);
			
			/* ldw
			class'UIAPI_WINDOW'.static.SetWindowSize("TutorialViewerWnd", rect.nWidth, rect.nHeight);
			class'UIAPI_WINDOW'.static.SetWindowSize("TutorialViewerWnd.HtmlBg", rect.nWidth - 10, rect.nHeight -30 - 12);
			class'UIAPI_WINDOW'.static.SetWindowSize("TutorialViewerWnd.HtmlTutorialViewer", rect.nWidth-20, rect.nHeight-30-20);	// -innowind 2007.6.22
			*/
			ShowWindowWithFocus("TutorialViewerWnd");

		}
		break;
	case EV_TutorialViewerWndHide :
		HideWindow("TutorialViewerWnd");
		break;
	}
}



/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "TutorialViewerWnd" ).HideWindow();
}

defaultproperties
{
}
