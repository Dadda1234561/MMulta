class ConsoleWnd extends UICommonAPI;

const DLG_ID_RESTART = 0;
const DLG_ID_QUIT = 1;
const DIG_ID_ASK_COUPLEACTION = 1112;
const TIMER_ID_POSTION = 1001110;

var WindowHandle m_hSystemMenuWnd;
var WindowHandle Me;
var DialogBox dScript;

function OnRegisterEvent()
{
	//RegisterEvent( EV_OpenDialogQuit );
	//RegisterEvent( EV_OpenDialogRestart );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );


	RegisterEvent ( EV_ShowAskCoupleActionDialog );
	RegisterEvent ( EV_CommandAddAllianceCrestFile );

	// ���͹����� �� ���� �ϸ� �ش� �̺�Ʈ �߻� 
	

	// couple action - lancelot 2009. 10. 14.
	// const EV_ShowAskCoupleActionDialog			= 4900;
	// const EV_CoupleActionFailedTargetIsNone		= 4910;
	// const EV_CoupleActionFailedIlligalTarget		= 4920;
	
	RegisterEvent(EV_Test_1);
	RegisterEvent(EV_Test_2);
	RegisterEvent(EV_Test_3);
	RegisterEvent(EV_Test_4);
}

/** On Load */
function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	//if(CREATE_ON_DEMAND==0)
	//	m_hSystemMenuWnd=GetHandle("SystemMenuWnd");
	//else
	//	m_hSystemMenuWnd=GetWindowHandle("SystemMenuWnd");

	Me = GetWindowHandle("ConsoleWnd");
	dScript = DialogBox(GetScript("DialogBox"));
}

function firstRunSetDefaultPosition ()
{
	SetINIInt("ScreenSize","f",1,"WindowsInfo.ini");
	SetDefaultPosition();
	Debug("---------- SetDefaultPosition ---------------");
}

function OnTimer (int TimerID)
{
	if ( TimerID == TIMER_ID_POSTION )
	{
		firstRunSetDefaultPosition();
		Me.KillTimer(TIMER_ID_POSTION);
	}
}

/** On Event */
function OnEvent(int Event_ID, String param)
{
	local string htm;
	local int nFirstRun;

	switch(Event_ID)
	{
		//case EV_OpenDialogRestart :
		//	dScript.HideDialog();
		//	dScript.SetID( DLG_ID_RESTART );
		//	dScript.ShowDialog(DialogModalType_Modal, DialogType_Warning, GetSystemMessage(126), string(Self) );			
		//	//DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
		//	//DialogShow(DialogModalType_Modal, DialogType_Warning, GetSystemMessage(126), string(Self));
		//	//DialogSetID( DLG_ID_RESTART );
		//	break;
		
		//case EV_OpenDialogQuit :
		//	dScript.HideDialog();
		//	dScript.SetID(DLG_ID_QUIT);
		//	dScript.ShowDialog(DialogModalType_Modal,DialogType_Warning, GetSystemMessage(125), string(Self));			
		//	//DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
		//	//DialogShow(DialogModalType_Modal,DialogType_Warning, GetSystemMessage(125), string(Self));
		//	//DialogSetID(DLG_ID_QUIT);
		//	break;
		case EV_GameStart:
			GetINIInt("ScreenSize","f",nFirstRun,"WindowsInfo.ini");
			if ( nFirstRun == 0 )
				Me.SetTimer(TIMER_ID_POSTION,1500);
			break;
		case EV_Test_1:
			SetINIInt("PartyWndClassic","e",1,"WindowsInfo.ini");
			SetINIInt("PartyWnd","e",1,"WindowsInfo.ini");
			break;
		case EV_Test_2:
			StartCredit();
			break;
		case EV_Test_3:
			htm = gfxHtmlAddText("����A�� ����AIAU : ","#FFEE33","22") $ gfxHtmlAddItemTexture(1,32,32,-5) $ brPixel(5) $ gfxHtmlAddItemTexture(2,24,24,-5) $ gfxHtmlAddText("Ca��iA�� AaA����I������a!","#00FF00","25") $ br() $ gfxHtmlAddItemTexture(352,32,32,-4) $ gfxHtmlAddText("���ҩ�y��cAC ����A��:","#FF0F20","22") $ gfxHtmlAddText("��i��cAI","#CC2F3F","24");
			htm = getInstanceL2Util().htmlSetHtmlStart(htm);
			Debug("htm" @ htm);
			getInstanceL2Util().showGfxScreenMessage(htm);
			break;
		case EV_Test_4:
			getInstanceL2Util().showGfxScreenMessage(param);
			break;

		case EV_DialogOK :
			HandleDlgOk();
			break;
		
		// 2009.10.17 , Ŀ�� �׼� �߰� 
		case EV_ShowAskCoupleActionDialog :
			// debug("====> �ߵ� : Ŀ�� �׼� " @ param);
			HandleCoupleActionAskStart(param);
			break;

		case EV_CommandAddAllianceCrestFile :
			HandleUploadAllianceCrestFile();
			break;


		case EV_DialogCancel :
			HandleDialogCancel();
			break;
	}
}

/** ���̾�α� OK  */
function HandleDlgOk()
{
	//local InventoryWnd Script;
	//Script = InventoryWnd(GetScript("InventoryWnd"));
	if (!DialogIsMine())
		return;

	switch(DialogGetID())
	{

		//case DLG_ID_RESTART :
		//	//����ŸƮ�� ��������� �������. 
		//	m_hSystemMenuWnd.HideWindow();
		//	Script.SaveInventoryOrder();
		//	ExecRestart();
		//	break;

		//case DLG_ID_QUIT :
		//	Script.SaveInventoryOrder();
		//	ExecQuit();
		//	break;
		
			
		case DIG_ID_ASK_COUPLEACTION:
			// Ŀ�� �׼��� ���� �ߴٸ�!
			// debug("=======================Ŀ�þ׼�========================================");
			// debug("==> DialogGetReservedInt() " @ DialogGetReservedInt());
			// debug("==> DialogGetReservedInt3() " @ DialogGetReservedInt3());		
			// debug("==> Answer " @ 1);		

			// Ȯ��, ��� �� ���� 
			dScript.SetButtonName( 1337, 1342 );
			AnswerCoupleAction(DialogGetReservedInt(), 1, DialogGetReservedInt3());
			break;
	}
}

/** Ŀ�� �׼��� ���� ���θ� ���� ���� */
function HandleCoupleActionAskStart( string param )
{
	local bool bOption;
	
	local int pActionID;
	local int pRequestUserID;

	local string userName;
	local string actionStr;

	bOption = GetOptionBool( "Communication", "IsCoupleAction" );
	
	//ParseInt( param, "SocialAnimID", pSocialAnimID );
	//ParseInt( param, "requestUserID", pRequestUserID );

	ParseInt( param, "ActionID", pActionID );
	ParseInt( param, "requestUserID", pRequestUserID );

	// Debug("=====> " @ bOption);

	if (bOption == true)
	{
		// ���� Ŀ�� �׼� ������ �źε� �����Դϴ�. 
		// RequestDuelAnswerStart( type, int(bOption), 0 );
		// AddSystemMessage(3122);
		// debug("=====> ���� Ŀ�þ׼� �ɼ��� �ź� ���� ");

		// Ŀ�� �׼��� �ź� �����̹Ƿ� �ڵ����� �ź� �ȴ�.
		//AnswerCoupleAction(DialogGetReservedInt(), -1, DialogGetReservedInt3());
		AnswerCoupleAction(pActionID, -1, pRequestUserID);
	}
	else	
	{
		// ���̾�α� â�� ���� ������ Ŀ�� �׼� �۵� ����.
		if ( IsShowWindow("DialogBox"))
		{
			//AnswerCoupleAction(DialogGetReservedInt(), 0, DialogGetReservedInt3());
			AnswerCoupleAction(pActionID, 0, pRequestUserID);
			return;
		}

		// ���� �̸��� ��´�
		userName = class'UIDATA_USER'.static.GetUserName(pRequestUserID);

		DialogSetID( DIG_ID_ASK_COUPLEACTION );
		DialogSetCancelD(DIG_ID_ASK_COUPLEACTION);

		DialogSetReservedInt( pActionID );
		DialogSetReservedInt3( pRequestUserID );

		DialogSetParamInt64( 10*1000 );			
		
		// ���̾� �α� �ڽ����� ��, �ƴϿ� �� �������� �Ѵ�.
		dScript.SetButtonName( 184, 185 );
		class'ActionAPI'.static.GetActionNameBySocialIndex(pActionID, actionStr);

		// $c1 ���� %s1 ��û�� �����Ͻðڽ��ϱ�?  -���->��޸����� �ٲ�-
		DialogShow(DialogModalType_Modalless, DialogType_Progress, MakeFullSystemMsg( GetSystemMessage(3118), userName, actionStr), string(Self) );
	}
}

/** Ŀ�� �׼��� �ź� �ߴٸ�!  */
function HandleDialogCancel()
{
	local bool bOption;

	// Ȯ��, ��� �� ���� 
	dScript.SetButtonName( 1337, 1342 );

	if(DialogIsMine())
	{
		if(DialogCheckCancelByID(DIG_ID_ASK_COUPLEACTION))
		{
			bOption = GetOptionBool( "Communication", "IsCoupleAction" );

			 debug("=====================Ŀ�þ׼�========================================");
			 debug("==> DialogGetReservedInt() " @ DialogGetReservedInt());
			 debug("==> DialogGetReservedInt3() " @ DialogGetReservedInt3());
			 debug("==> Answer " @ 0);
			
			AnswerCoupleAction(DialogGetReservedInt(), 0, DialogGetReservedInt3());
		}
	}
}


/** ���͹����� , ���� ���� â�� �߰� �����Ͽ� ���ε� �ϴ� �κ�  */
function HandleUploadAllianceCrestFile()
{
	local Array<string> fileextarr;

	if (class'UIAPI_WINDOW'.static.IsShowWindow("FileRegisterWnd") == false)
	{

		// ���͹����� 8 * 12 ũ���� 256 Į�� Bmp ���ϸ� ����� �� �ֽ��ϴ�.
		AddSystemMessage(3143);

		// ���� ���ε� 
		fileextarr.Length = 1;
		fileextarr[0] = "bmp";
		ClearFileRegisterWndFileExt();

		// 2811 : ��Ʈ�� �̹���
		AddFileRegisterWndFileExt(GetSystemString(2811), fileextarr);

		// ���� ������ ���� ���� ������ ����
		FileRegisterWndShow(FH_ALLIANCE_CREST_UPLOAD);
	}
}

defaultproperties
{
}