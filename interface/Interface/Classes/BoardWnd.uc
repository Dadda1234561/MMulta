class BoardWnd extends UIScript;

var bool	m_bShow;
var bool	m_bBtnLock;
var string 	m_Command[8];

var HtmlHandle	m_hBoardWndHtmlViewer;

var TabHandle	m_hBoardWndTabCtrl;

function OnRegisterEvent()
{
	RegisterEvent( EV_ShowBBS );
	RegisterEvent( EV_ShowBoardPacket );
}

function OnLoad()
{
	SetClosingOnESC();

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();


	m_hBoardWndHtmlViewer=GetHtmlHandle("BoardWnd.HtmlViewer");
	m_hBoardWndTabCtrl=GetTabHandle("BoardWnd.TabCtrl");
	m_bShow = false;
	m_bBtnLock = false;
}

function OnShow()
{
	m_bShow = true;
}

function OnHide()
{
	m_bShow = false;
	//class'UIAPI_WINDOW'.static.SetFocus("ChatWnd");	//LDW 2011.09.05 ttp 28561 ó��
}

function OnEvent(int Event_ID, string param)
{
	//Debug("OnEvent" @ param) ;
	if (Event_ID == EV_ShowBBS)
	{
		HandleShowBBS(param);
	}
	else if (Event_ID == EV_ShowBoardPacket)
	{
		HandleShowBoardPacket(param);
	}
}

function OnClickButton( string strID )
{	
	//Debug( "-->" @ strID );


	switch( strID )
	{
	case "btnBookmark":
		OnClickBookmark();
		break;
	}
	// End:0x74
	if(Left(strID, 7) == "TabCtrl")
	{
		strID = Mid(strID, 7);
		// End:0x74
		if(! class'UIAPI_WINDOW'.static.IsMinimizedWindow("BoardWnd"))
		{
			ShowBBSTab(int(strID));
		}
	}
}

//�ʱ�ȭ
function Clear()
{
	
}

function HandleShowBBS(string param)
{
	local int Index;
	local int Init;
	
	ParseInt(param, "Index", Index);
	ParseInt(param, "Init", Init);
	
	//�ʱ���·� ���°�? (SystemMenu�κ���)	
	if ( m_bShow )
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		class'UIAPI_WINDOW'.static.HideWindow("BoardWnd");
		return;
	}

	if (Init>0)
	{
		if (!m_hBoardWndHtmlViewer.IsPageLock())
		{
			m_hBoardWndHtmlViewer.SetPageLock(true);
			m_hBoardWndTabCtrl.SetTopOrder(0, false);
			m_hBoardWndHtmlViewer.Clear();
			RequestBBSBoard();
		}		
	//���߿� HandleShowBoardPacket���� ShowWindow�� �Ѵ�.
	}
	else
	{
		if ( Index == 8 )
		{
			m_hBoardWndTabCtrl.SetTopOrder(0, false);
		}
		else m_hBoardWndTabCtrl.SetTopOrder(Index, false);
		m_hBoardWndHtmlViewer.Clear();
		ShowBBSTab(Index);
	}
}

function HandleShowBoardPacket(string param)
{
	local int idx;
	local int OK;
	local string Address;
	
	ParseInt(param, "OK", OK);
	if (OK<1)
	{
		class'UIAPI_WINDOW'.static.HideWindow("BoardWnd");
		return;
	}
	
	//Clear
	for (idx=0; idx<8; idx++)
		m_Command[idx] = "";
	
	ParseString(param, "Command1", m_Command[0]);
	ParseString(param, "Command2", m_Command[1]);
	ParseString(param, "Command3", m_Command[2]);
	ParseString(param, "Command4", m_Command[3]);
	ParseString(param, "Command5", m_Command[4]);
	ParseString(param, "Command6", m_Command[5]);
	ParseString(param, "Command7", m_Command[6]);
	ParseString(param, "Command8", m_Command[7]);
	m_bBtnLock = false;
	
	ParseString(param, "Address", Address);
	m_hBoardWndHtmlViewer.SetHtmlBuffData(Address);
	if (!m_bShow)
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		class'UIAPI_WINDOW'.static.ShowWindow("BoardWnd");
		class'UIAPI_WINDOW'.static.SetFocus("BoardWnd");
	}
}

function ShowBBSTab(int Index)
{
	local string strBypass;
	local EControlReturnType Ret;
	
	switch( Index )
	{
	//ó������
	case 0:
		strBypass = "bypass _bbshome"; //В начало
		break; 
	//���ã��
	case 1:
		strBypass = "bypass _bbsgetfav"; // Избранное
		break;
	//Ȩ������ ��ũ(10.1.11 ������ ����)
	case 2:
		strBypass = "bypass _bbslink"; // Сайт игры
		break;
	////������ũ  2015-09-21 ����
	//case 3:
	//	strBypass = "bypass _bbsloc";
	//	break;

	//���͸�ũ
	case 3:
		strBypass = "bypass _bbsclan"; //Клан
		break;
	//�޸�
	case 4:
		strBypass = "bypass _bbsmemo"; // Памятка
		break;
	//����
	case 5:
		strBypass = "bypass _maillist_0_1_0_"; //Почта
		break; 
	//ģ������
	case 6:
		strBypass = "bypass _friendlist_0_"; 
		break;
	//�Խ���/���� ���ϱ� - ���� �޴�, ����ġ �ٿ��� Ȯ�� ��.
	case 8:
		switch ( GetReleaseMode() ) 
		{
			case RM_DEV :
			//���߸�
				strBypass = "bypass _bbslist_1023_1";
				break;
			//RC
			case RM_RC : 		
				strBypass = "bypass _bbslist_8_1";
				break;		
			//test
			case RM_TEST : 
				strBypass = "bypass _bbslist_44_1";
				break;
			//���̺�
			case RM_LIVE :
				strBypass = "bypass _bbslist_20_1";
				break;
		}
	}

	Debug("strBypass" @ strBypass);
	
	if (Len(strBypass)>0)
	{
		Ret = m_hBoardWndHtmlViewer.ControllerExecution(strBypass);
		if (Ret == CRTT_CONTROL_USE)
		{
			m_bBtnLock = true;
		}
	}	
}


function OnClickBookmark()
{
	local EControlReturnType Ret;
	
	if (Len(m_Command[7])>0 && !m_bBtnLock)
	{
		Ret = m_hBoardWndHtmlViewer.ControllerExecution(m_Command[7]);
		if (Ret == CRTT_CONTROL_USE)
		{
			m_bBtnLock = true;
		}
	}
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "BoardWnd" ).HideWindow();
}

defaultproperties
{
}
