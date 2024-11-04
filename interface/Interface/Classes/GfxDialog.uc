//------------------------------------------------------------------------------------------------------------------------
//
// ����        : gfxDialog  ( ������ ���� ���̾�α� (Ŀ���� ��) ) - SCALEFORM UI - 
//
// linkage ���̾�α� ��� :
// 4�� ���� - ���� �Խ� ���̾�α� : AwakeNoticeDialog   
//------------------------------------------------------------------------------------------------------------------------
class GfxDialog extends L2UIGFxScript;

const DIALOG_ID_JOINOTP = 100001;
const DIALOG_ID_NOTICE = 100002;

var UserInfo currentUserInfo;
var QuestTreeWnd QuestTreeWndScript;

var bool isDualMoviePlay;

//�ε� �Ϸ� �� invoke�� �Ķ��Ÿ�� ���� �� ���� getUCproperity �� �ް� ó�� ��.
var int _classID;
var string _linkageName;
var string _userName;

var DialogBox ucDialogScript;

function OnRegisterEvent()
{
	RegisterEvent(EV_Restart);

	//htmlDialog �� ó�� 
	RegisterEvent(EV_LoginFailFlash);
	RegisterEvent(EV_DialogOK);
}

function OnLoad()
{
	RegisterState(getCurrentWindowName(string(self)), "GamingState");
	QuestTreeWndScript = QuestTreeWnd(GetScript("QuestTreeWnd"));
	SetAlwaysOnTop(true);
	SetClosingOnESC( );	

	ucDialogScript = DialogBox(GetScript("DialogBox"));
}

function OnFlashLoaded()
{
	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0, 0);
}

function OnShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);
}

function OnHide()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

// const EV_CallToChangeClass = 5470;
/** OnEvent */
function OnEvent(int Event_ID, string param)
{
	//Debug("onEvent"@ Event_ID @ param);
	if( Event_ID == EV_LoginFailFlash )
	{
		// UC ���̾�α� ����
		showUCDialogBox(param);
	}
	else if (Event_ID == EV_Restart)
	{
		HideWindow();
	}
	else if (Event_ID == EV_DialogOK)
	{
		dialogOK_Handler();
	}
}

function dialogOK_Handler()
{
	// End:0x1B
	if(!(ucDialogScript.GetTarget() == string(self)))
	{
		return;
	}

	switch(ucDialogScript.GetID())
	{
		case DIALOG_ID_JOINOTP :
			OpenGivenURL( GetSystemString( 3911 ) );
			// End:0x57
			if(IsUseTokenLogin())
			{
				ExecQuit();				
			}
			else
			{
				GotoLogin();
			}
			// End:0x82
			break;
	}
}

function showUCDialogBox(string param)
{
	local int nErrorSystemMessageID, dialogID;
	local EDialogType dialogStyle;
	local string dialogBoxMsg, parseType;

	ParseString(param, "Type", parseType);
	
	if (parseType == "d")
	{
		ParseInt(param, "ErrorID", nErrorSystemMessageID);

		dialogBoxMsg = GetSystemMessage(nErrorSystemMessageID);

		// OTP �������� ����
		if (nErrorSystemMessageID == 5073)
		{
			dialogID = DIALOG_ID_JOINOTP;

			if ( IsUseTokenLogin() )
			{
				dialogStyle = DialogType_OK;
				ucDialogScript.SetEnterAction(EEnterOK);
			}
			else
				dialogStyle = DialogType_OKCancel;

			// ��ư �ؽ�Ʈ ����, �����ϱ�
			ucDialogScript.SetButtonName(3910);
		}
		else
		{
			dialogID = DIALOG_ID_NOTICE;
			dialogStyle = DialogType_OK;
		}
	}
	else
	{
		dialogID = DIALOG_ID_NOTICE;

		ParseString(param, "ErrorMsg", dialogBoxMsg);
		dialogStyle = DialogType_OK;
	}

	ucDialogScript.ShowDialog(DialogModalType_Modal, dialogStyle, dialogBoxMsg, string(Self), 450, 225, true );
	ucDialogScript.SetID( dialogID );
	// Debug("dialogBoxMsg" @ dialogBoxMsg);
}

/** showGfxDialog */
function showGfxDialog(string linkageName, string type, string param  )
{
	local int classID;
	//LogIn ���̾�α� ���� �޽���.
	//local string ErrorMsg;

	local int eventID;

	local   array<GFxValue> args;
	local   GFxValue invokeResult;	

	_linkageName = type;
	
	//Debug ( "showGfxDialog" @ linkageName @ type );
	if (type != "AwakeNoticeDialog")
	{	
		//ShowWindow ���� SetModal �� �Ǿ� ��.
		SetModal( true );
	}
	else 
	{
		SetModal( false );
	}

	// LogInDialog �� �ƴ� ��� GfxDialog ȣ��
	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);
	CreateObject(args[1]);

	if ( type == "DualPayDialogStep1")
	{			
		GetPlayerInfo(currentUserInfo);

		ParseInt(param, "Class", classID);

		_classID = classID;
		_userName = currentUserInfo.name;

		eventID = 1 ;				
		
		args[1].SetMemberString("userName", currentUserInfo.name);
		args[1].SetMemberString(linkageName, type);
		args[1].SetMemberInt("classID", classID);

		ShowWindow();
	}
	else if ( type == "DualPayDialogStep2")
	{	
		
		GetPlayerInfo(currentUserInfo);
		
		eventID = 1 ;			
//		args[1].SetMemberString("userName", currentUserInfo.name);
		args[1].SetMemberString(linkageName, type);
//		args[1].SetMemberInt("class", classID);

		ShowWindow();
	}
	else if (type == "AwakeNoticeDialog")
	{	
		if (!  GetPlayerInfo(currentUserInfo) ) 
		{
			DeallocGFxValue(invokeResult);
			DeallocGFxValues(args);

			return ;
		}
		
		if (QuestTreeWndScript.isQuestIDSearch(10338) || (currentUserInfo.nClassID <= 147 && currentUserInfo.nClassID >= 139) )
		{
			
			HideWindow();
			DeallocGFxValue(invokeResult);
			DeallocGFxValues(args);

			return;
		}
		else
		{			
			ParseInt(param, "Class", classID);

			_classID = classID;
			
			eventID = 1;
			
			args[1].SetMemberString( linkageName , type);
			args[1].SetMemberInt("classID", classID);	

			//Debug( "showGfxDialog" @ type @linkageName @ classID );

			ShowWindow();
		}
	}

	// LogInDialog �� XML ���̾��
	args[0].SetInt( eventID );
	Invoke("onEvent", args, invokeResult);
		
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);

}

function OnCallUCLogic( int logicID, string param )
{
	local string dialogName;
	
	//Debug("OnCallUCLogic" @ logicID @ param);
	// ���� ���̾�α� �̸� "name=AwakeNoticeDialog"  �� �⺻ �Ķ���ͷ� �Ѵ�.
	// ���� ���̾�α� �̸� "name=Login"  �� �⺻ �Ķ���ͷ� �Ѵ�.
	ParseString(param, "Name",  dialogName);

	// ���� ���̾�α׸� ok �ߴٸ�..
	switch (dialogName)
	{
		case "AwakeNoticeDialog" :  AwakeNoticeDialogHandler(logicID, param);	break;		
		case "DualPayDialogStep1":  DualPayDialogStep1(logicID, param);     	break;
		case "DualPayDialogStep2":  DualPayDialogStep2(logicID, param);     	break;	
	}		

	// ���� �̷������� �ϸ� �ȵ� -_-+
	//Ȩ������ ��ũ
	if( logicID == 3 )
	{
		OpenL2Home();
	}
}

/**
 * ��� ������ Ǯ ��ũ�� ���� ��
 **/
function DualPayDialogStep1( int logicID, string param )
{	
	isDualMoviePlay = true;	
	//Debug("Ǯ ��ũ�� ���� ��" @ isDualMoviePlay );
	RequestShowVisionmovie();
}

function onMovieEnd()
{	
	//Debug("onMovieEnd" @ isDualMoviePlay );
	if (  isDualMoviePlay )
	{
		isDualMoviePlay = false;
		showGfxDialog( "dialogLinkageName", "DualPayDialogStep2" , "");
	}
}

/**
 * ��� Ȩ������ ���� Ȥ�� �ݱ� 
 **/
function DualPayDialogStep2( int logicID, string param )
{
	local InventoryWnd Script;

	if ( logicID == 1 ) 
	{
		OpenGivenURL( GetSystemString( 3120 ) );
		//OpenL2Home();
	}
	
	Script = InventoryWnd(GetScript("InventoryWnd"));
	Script.SaveInventoryOrder();
	ExecQuit();
}

/**
 * �����ϴ� ������ �̵� �����ִ� ���̾�α� 
 **/
function AwakeNoticeDialogHandler ( int logicID, string param )
{
	local string  strParam;
	local int     classID;

	GetPlayerInfo(currentUserInfo);
	// ���� ���� ����Ʈ ID , 10338 ����� : ������ �̺��� ��û
	// �� ���� �Ѵٸ�.. �ƹ��͵� ���Ѵ�.
	// Class=139 ����..8��.4�� ���� , ���� ���¶��..
	if (QuestTreeWndScript.isQuestIDSearch(10338) || (currentUserInfo.nClassID <= 147 && currentUserInfo.nClassID >= 139) )
	{
		// empty
		// Debug("���� �˶� �ݺ� ���! " @ param);	
	}
	else
	{
		 if ( logicID == 1 )
		{
			//Debug("RequestCallToChangeClass ȣ��! �� Ÿ��! " @ param);			
			RequestCallToChangeClass( );

		}
		else if (logicID == 2)
		{
			ParseInt(param, "Class", classID);
			ParamAdd(strParam, "Class", String(classID) );
			ParamAdd(strParam, "Immediate", String(0) );
			ParamAdd(strParam, "UserType", String(1));

			ExecuteEvent( EV_CallToChangeClass, strParam ); 
			//Debug("���� �˶� �ݺ�" @ param);	
		}
	}
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	local array<GFxValue> args;

	local GFxValue invokeResult;

	AllocGFxValues(args, 1);
	AllocGFxValue(invokeResult);
	
	Invoke("onReceivedCloseUI", args, invokeResult);

	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
}

defaultproperties
{
}
