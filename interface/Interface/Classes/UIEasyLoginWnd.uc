/*****************************************************************************************************************************
   ���� : System���� UIDEV.ini �� �����, �Ʒ��� ���� ������ �߰��� �ϸ� �۵� �Ѵ�.
 - ���߸������� �۵� �ϵ��� �Ѵ� - 

[EASYLOGIN]
use=1
id1=ui1@a.a
pw1=aaaa1111
id2=ui2@a.a
pw2=aaaa1111
id3=ui3@a.a

use=1 �� �ϸ� ���߸����� �۵� �ϵ��� ���� �ϴ� �� 
������ ���� ���̵�, ��ȣ�� �־� �ΰ�.. �ִ� 50�� ���� ���� ����.


lastLoginIndex ������ �α����� ���̵� ��ġ�� ��� ��Ų��. 

Ctrl �� ������ �α������� ��
 
 ****************************************************************************************************************************/
class UIEasyLoginWnd extends UICommonAPI;

const TIMER_ID_CHANGETEXT    = 10234599;
const TIMER_ID               = 10234510;

var WindowHandle Me;
var ListCtrlHandle idList;
var ButtonHandle loginButton, addButton, delButton, managerButton;
var TextBoxHandle descTxt;
var EditBoxHandle idEditBox, pwEditBox, serverEditBox, charEditBox;
var string lastKeyValue;
var bool isEditMode;

function OnRegisterEvent()
{
	RegisterEvent( EV_LoginBegin );
}

function OnLoad()
{
	registerState( "LogIn", "LoginState" );	

	SetClosingOnESC();
	Initialize();
}

function OnShow()
{
	local ELanguageType Language;	

	Me.KillTimer(TIMER_ID_CHANGETEXT);
	Me.SetTimer(TIMER_ID_CHANGETEXT, 4000);

	Me.KillTimer(TIMER_ID);
	Me.SetTimer(TIMER_ID, 100);

	Language = GetLanguage();

	if( Language == LANG_Korean)
		descTxt.SetText("���� �α��� ��!");

	Me.SetFocus();
}

function AddList (string id, string pw, string server, string character)
{
	local LVDataRecord record;
	
	record.LVDataList.Length = 3;
	record.LVDataList[0].szData = id;
	record.LVDataList[0].szReserved = pw;
	
	record.LVDataList[1].szData = server;
	record.LVDataList[2].szData = character;

	// ����Ʈ�� �߰� 
	idList.InsertRecord(record);
}

function GetSelectedRecord()
{
	local LVDataRecord record;
	
	idList.GetSelectedRec(record);

	idEditBox.SetString(record.LVDataList[0].szData);
	pwEditBox.SetString(record.LVDataList[0].szReserved);
	serverEditBox.SetString(record.LVDataList[1].szData);
	charEditBox.SetString(record.LVDataList[2].szData);
}

function OnEvent(int Event_ID, string param)
{	
	if( Event_ID == EV_LoginBegin )
	{
		// ���߸��� �۵� �ϵ���..
		switch ( GetReleaseMode() ) 
		{
			case RM_DEV :
			if( Me.IsShowWindow() == false )
			{
				checkAndShowEasyLogin();
			}
		}
	}
}

function Initialize()
{
	Me = GetWindowHandle( "UIEasyLoginWnd" );
	idList = GetListCtrlHandle( "UIEasyLoginWnd.idList" );

	loginButton = GetButtonHandle("UIEasyLoginWnd.loginButton");
	addButton = GetButtonHandle("UIEasyLoginWnd.addButton");
	delButton     = GetButtonHandle("UIEasyLoginWnd.delButton");
	managerButton = GetButtonHandle("UIEasyLoginWnd.managerButton");

	descTxt = GetTextBoxHandle("UIEasyLoginWnd.descTxt");

	idEditBox = GetEditBoxHandle("UIEasyLoginWnd.idEditBox");
	pwEditBox = GetEditBoxHandle("UIEasyLoginWnd.pwEditBox");
	serverEditBox = GetEditBoxHandle("UIEasyLoginWnd.serverEditBox");
	charEditBox = GetEditBoxHandle("UIEasyLoginWnd.charEditBox");
	setWindowTitleByString("UITools - EasyLogin");
}

function OnHide()
{
	Me.KillTimer(TIMER_ID_CHANGETEXT);
	Me.KillTimer(TIMER_ID);
}

function OnTimer(int TimerID)
{
	local ELanguageType Language;	

	if (TimerID == TIMER_ID_CHANGETEXT)
	{
		Language = GetLanguage();

		if( Language == LANG_Korean)
		{	
			switch(Rand(8))
			{
				case  1 : descTxt.SetText("- ������2 System������ UIDEV.ini ���Ͽ���, [EASYLOGIN] �׸��� ���� �����Ͽ��� �ȴϴ�."); break;
				case  2 : descTxt.SetText("- ���׳� ��û�� ������ dongland@ncsoft.com ���� �����ּ���."); break;
				case  3 : descTxt.SetText("- dongland���� Donation �ϼŵ� �˴ϴ�. -_-"); break;
				case  4 : descTxt.SetText("- (-_-)/~~~~�� ���� �ѱ� ���������� ���Դϴ�~ "); break;
				case  5 : descTxt.SetText("- �α��ΰ� ��ȣ�� �Ź� �ֱ� ���� ���� �α��� ���Դϴ�."); break;
				case  6 : descTxt.SetText("- �ִ� 50���� ���̵� ��ȣ�� ���� �� �� �ֽ��ϴ�."); break;
				case  7 : descTxt.SetText("- Server�� Char(ĳ���� ����)�� ���ڷ� �Է� �ؾ� �˴ϴ�."); break;
				default : descTxt.SetText("- �߰� ����� �� �ʿ��ϸ� �˷��ּ���. "); break;
			}
		}
	}
	else if( TimerID == TIMER_ID)
	{
		if(IsKeyDown(IK_Home) || IsKeyDown(EInputKey.IK_RightMouse))
		{
			OnLoginButtonClickHandler();
		}
	}
}

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "loginButton":
			  OnLoginButtonClickHandler();
			  break;

		case "addButton":
			  OnAddButtonClickHandler();
			  break;

		case "delButton":
			  OnDelButtonClickHandler();
			  break;

		case "managerButton":			  
			  OnManagerButtonClickHandler();
			  break;

	    case "gmToolBtn":
		     ShowWindowWithFocus("GMWnd");
			 break;

	    case "uiEditBtn":
			 ExecuteCommand( "///ui");
			 break;

	}
}

function OnAddButtonClickHandler()
{
	local int nMax;
	
	if (idEditBox.GetString() != "" && pwEditBox.GetString() != "")
	{
		nMax = idList.GetRecordCount();
		SetINIString("EASYLOGIN", "id"  $ nMax + 1, idEditBox.GetString() , "UIDEV.ini");
		SetINIString("EASYLOGIN", "pw"  $ nMax + 1, pwEditBox.GetString() , "UIDEV.ini");
		SetINIString("EASYLOGIN", "server"  $ nMax + 1, serverEditBox.GetString() , "UIDEV.ini");
		SetINIString("EASYLOGIN", "char"  $ nMax + 1, charEditBox.GetString() , "UIDEV.ini");

		AddList(idEditBox.GetString(), pwEditBox.GetString(), serverEditBox.GetString(), charEditBox.GetString());
	}
}

function OnDelButtonClickHandler()
{
	local int idx;
	local string id, pw, server, character;
	local int i;
	local string oldid;

	local LVDataRecord	record;	

	idx = idList.GetSelectedIndex();
	 
	if (idx > -1) 
	{
		idList.DeleteRecord(idx);
		SetINIString("EASYLOGIN", "id"  $ idx + 1, "" , "UIDEV.ini");
		SetINIString("EASYLOGIN", "pw"  $ idx + 1, "" , "UIDEV.ini");
		SetINIString("EASYLOGIN", "server"  $ idx + 1, "" , "UIDEV.ini");
		SetINIString("EASYLOGIN", "char"  $ idx + 1, "" , "UIDEV.ini");

		// ini �� �����Ͽ� �����ϱ� 
		for (i = 1; i < 51; i++)
		{
			if (idList.GetRecordCount() >= i)
			{
				idList.GetRec(i - 1, record);
				id = record.LVDataList[0].szData;
				pw = record.LVDataList[0].szReserved;
				server = record.LVDataList[1].szData;
				character = record.LVDataList[2].szData;
			}
			else
			{
				id = "";
				pw = "";
				server = "";
				character = "";
			}

			if(id == "")
				GetINIString("EASYLOGIN", "id" $ i, oldid, "UIDEV.ini");
				
			if(id != "" || oldid != "")
			{
				SetINIString("EASYLOGIN", "id" $ i, id, "UIDEV.ini");
				SetINIString("EASYLOGIN", "pw" $ i, pw, "UIDEV.ini");
				SetINIString("EASYLOGIN", "server" $ i, server, "UIDEV.ini");
				SetINIString("EASYLOGIN", "char" $ i, character, "UIDEV.ini");
			}
		}
	}
}

// �Ŵ��� ��ư�� ������ ������ ���� �ø��� ���̰� �Ͽ�, ���̵�, ��ȣ�� �ִ� ���� ������ �Ⱥ����� �Ѵ�.
function OnManagerButtonClickHandler(optional bool bUseBasicUI)
{
	local int w, h;

	Me.GetWindowSize(w, h);

	if (w > 400 || bUseBasicUI)
	{
		Me.SetWindowSize(240, 375);

		descTxt.HideWindow();
		addButton.HideWindow();
		delButton.HideWindow();		
		idEditBox.HideWindow();
		pwEditBox.HideWindow();
		serverEditBox.HideWindow();
		charEditBox.HideWindow();

		GetTextBoxHandle("UIEasyLoginWnd.addTxt").HideWindow();		
		GetTextBoxHandle("UIEasyLoginWnd.idTxt").HideWindow();
		GetTextBoxHandle("UIEasyLoginWnd.pwTxt").HideWindow();
		GetTextBoxHandle("UIEasyLoginWnd.serverTxt").HideWindow();
		GetTextBoxHandle("UIEasyLoginWnd.charTxt").HideWindow();
		GetTextBoxHandle("UIEasyLoginWnd.delTxt").HideWindow();
		GetTextBoxHandle("UIEasyLoginWnd.descTxt").HideWindow();

		GetTextureHandle("UIEasyLoginWnd.ListBG1").HideWindow();
		
		isEditMode = false;
	}
	else 
	{
		Me.SetWindowSize(580, 375);

		descTxt.ShowWindow();
		addButton.ShowWindow();
		delButton.ShowWindow();		
		idEditBox.ShowWindow();
		pwEditBox.ShowWindow();
		serverEditBox.ShowWindow();
		charEditBox.ShowWindow();

		GetTextBoxHandle("UIEasyLoginWnd.addTxt").ShowWindow();		
		GetTextBoxHandle("UIEasyLoginWnd.idTxt").ShowWindow();
		GetTextBoxHandle("UIEasyLoginWnd.pwTxt").ShowWindow();
		GetTextBoxHandle("UIEasyLoginWnd.serverTxt").ShowWindow();
		GetTextBoxHandle("UIEasyLoginWnd.charTxt").ShowWindow();
		GetTextBoxHandle("UIEasyLoginWnd.delTxt").ShowWindow();		
		GetTextBoxHandle("UIEasyLoginWnd.descTxt").ShowWindow();
		
		GetTextureHandle("UIEasyLoginWnd.ListBG1").ShowWindow();
		
		isEditMode = true;
	}
}

//���ڵ带 ����Ŭ���ϸ�....
function OnDBClickListCtrlRecord( string ListCtrlID )
{
	switch(ListCtrlID)
	{
		case "idList" :
			if(isEditMode)
				GetSelectedRecord();
			else
				OnLoginButtonClickHandler();
			 break;
	}
}

// �α��ν� �ش� UI�� ������ �� �������� ���Ѵ�.
function setUseEasyLogin(bool flag)
{
	SetINIString("EASYLOGIN", "use", String(boolToNum(flag)) , "UIDEV.ini");
}

// �α��ν� �ش� UI�� ������ �� �������� ���Ѵ�.
function bool getUseEasyLogin()
{
	local string stringValue;
	GetINIString("EASYLOGIN", "use", stringValue, "UIDEV.ini");

	return numToBool(int(stringValue));
}

// �α��� �õ�
function OnLoginButtonClickHandler()
{
	local LVDataRecord	record;	
	local int serverNum;
	local int characterNum;
	
	idList.GetSelectedRec( record );

	if (record.LVDataList[0].szData != "")
	{
		LogIn(GetScript("LogIn")).onCallUCFunction("setLogin", 
 													"ID=" $ record.LVDataList[0].szData $ " " $
 													"pass=" $ record.LVDataList[0].szReserved);

		// �α����� �׸��� �ε����� ���� 
		SetINIString("EASYLOGIN", "lastLoginIndex", String(idList.GetSelectedIndex()) , "UIDEV.ini");
		
		// ������ ĳ���� �ڵ� �α���
		if(record.LVDataList[1].szData != "")
		{
			serverNum = int(record.LVDataList[1].szData);

			if (record.LVDataList[2].szData != "")
				characterNum = int(record.LVDataList[2].szData);
			else
				characterNum = -1;

			AutoLogin(serverNum, characterNum);
		}
	}
}

function checkAndShowEasyLogin()
{
	local string stringValue;
	GetINIString("EASYLOGIN", "use", stringValue, "UIDEV.ini");

	if (int(stringValue) > 0)
	{		
		OnManagerButtonClickHandler(true);
		Me.ShowWindow();
		loadListByINI();
	}
}

function loadListByINI()
{
	local string id, pw, server, character, listIndex;
	local int i;

	
	idList.DeleteAllItem();
	for (i = 1; i < 51; i++)
	{
		id = "";
		pw = "";
		server = "";
		character = "";
		GetINIString("EASYLOGIN", "id" $ i, id, "UIDEV.ini");
		GetINIString("EASYLOGIN", "pw" $ i, pw, "UIDEV.ini");
		GetINIString("EASYLOGIN", "server" $ i, server, "UIDEV.ini");
		GetINIString("EASYLOGIN", "char" $ i, character, "UIDEV.ini");

		if (id != "")
			AddList(id, pw, server, character);
	}

	// �������� �α����� �׸����� ����Ʈ ����
	GetINIString("EASYLOGIN", "lastLoginIndex", listIndex , "UIDEV.ini");
	idList.SetSelectedIndex(int(listIndex), true);

}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();
}

defaultproperties
{
}
