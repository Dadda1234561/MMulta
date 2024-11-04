class ClanDrawerWnd extends UICommonAPI;

const DIALOG_AskLossClanWar = 90009;
const DIALOG_AskClanWarCancel = 487;

const c_maxranklimit = 100;
const changelineval1 = 23;

const DISABLE_ALPHA=100;		//�𽺿��̺� ���ٶ��� ����. ��ī���� �𽺿��̺�
const ACADEMY_INDEX=7;		//��ī������ ������ �ε���

var	string	m_state;
var int		m_clanType;
var int		m_clanWarListPage;			// ����
var int		m_currentEditGradeID;
var string	m_currentName;
var string 	m_myName;
var int	m_currentMaster;
//var bool	m_currentmemberselectoffset;
//var int	m_clanType;
var string 	currentMasterName;

var string  currentLossWarClanName; // ���� �й� ���� ��
var string  m_WindowName;
var string  m_ClanPledgeBonusDrawerWndName;

var ListCtrlHandle	m_hClanDrawerWndClan1_AssignApprenticeList;
var ListCtrlHandle  m_hClanDrawerWndClan8_DeclaredListCtrl;
var ListCtrlHandle  m_hClanDrawerWndClan8_GotDeclaredListCtrl;
var ListCtrlHandle	m_hClanDrawerWndClan5_AuthListCtrl;
var ListCtrlHandle  m_hClanDrawerWndClan5_AuthListCtrl2;

var int ClanClickedID;	// ���� Ŭ�� ��ų Ʈ�� �κ��� Ŭ���Ǿ� �ִ��� Ȯ��

//Handle
var WindowHandle Clan3_OrgIcon[CLAN_KNIGHTHOOD_COUNT];
//var ButtonHandle Clan3_OrgButton[CLAN_KNIGHTHOOD_COUNT];
var TextureHandle Clan3_OrgHighLight[CLAN_KNIGHTHOOD_COUNT];

// var TabHandle	m_hClanDrawerWndClanWarTabCtrl;


var FileRegisterWnd fileRegisterWndHandle;
	

function OnRegisterEvent()
{
	registerEvent( EV_ClanAuthGradeList );
	registerEvent( EV_ClanCrestChange );
	registerEvent( EV_ClanAuth );
	registerEvent( EV_ClanAuthMember );
	registerEvent( EV_ClanMemberInfo );
	registerEvent( EV_ClanWarList );
	registerEvent( EV_ClanSkillList );
	registerEvent( EV_ClanSkillListRenew);
	//registerEvent( EV_ClanSkillListAdd );
	registerEvent( EV_GamingStateExit );
	registerEvent( EV_ClanClearWarList );

	registerEvent(EV_DialogOK);
	registerEvent(EV_DialogCancel);
	//~ registerEvent( EV_ClanInfo );
	//~ registerEvent( EV_
}

function OnLoad()
{
	SetClosingOnESC();
	
	InitHandle();
	InitializeGradeComboBox();
	HideAll();
	
	m_clanWarListPage = -1;
	
	ClanClickedID = -1;

	m_hClanDrawerWndClan1_AssignApprenticeList=GetListCtrlHandle(m_WindowName$".Clan1_AssignApprenticeList");
	m_hClanDrawerWndClan8_DeclaredListCtrl=   GetListCtrlHandle(m_WindowName$".Clan8_DeclaredListCtrl");
	m_hClanDrawerWndClan8_GotDeclaredListCtrl=GetListCtrlHandle(m_WindowName$".Clan8_DeclaredListCtrl");
	m_hClanDrawerWndClan5_AuthListCtrl=GetListCtrlHandle(m_WindowName$".Clan5_AuthListCtrl");
	m_hClanDrawerWndClan5_AuthListCtrl2=GetListCtrlHandle(m_WindowName$".Clan5_AuthListCtrl2");

	// m_hClanDrawerWndClanWarTabCtrl=GetTabHandle(m_WindowName$".ClanWarTabCtrl");

	fileRegisterWndHandle = FileRegisterWnd(GetScript("FileRegisterWnd"));

}


function InitHandle()
{
	local int i;


	for( i=0 ; i < CLAN_KNIGHTHOOD_COUNT ; ++i )
	{		
		Clan3_OrgIcon[i] = GetWindowHandle(m_WindowName$".Clan3_OrgIcon" $ (i + 1));
		Clan3_OrgHighLight[i] = GetTextureHandle( m_WindowName$".Clan3_OrgIconWnd" $ (i + 1) $ ".texIconHighlight");	

		if(i == ACADEMY_INDEX)	//��ī���� �� ���
		{
			Clan3_OrgIcon[i].DisableWindow();
			Clan3_OrgIcon[i].SetAlpha(DISABLE_ALPHA);			
		}
		Clan3_OrgHighLight[i].HideWindow();
	}
}

/*
function checkClassicForm() 
{
	local int i;
	Debug( "checkClassicForm");

	if ( UIData( GetScript ("UIData")).getisClassicServer()  )
	{
		//���� ����
		class'UIAPI_WINDOW'.static.hideWindow(m_WindowName$".Clan1_ChangeMemberKHOpen");
		class'UIAPI_WINDOW'.static.hideWindow(m_WindowName$".Clan1_CurrentSelectedApprenticeTitle");
		class'UIAPI_WINDOW'.static.hideWindow(m_WindowName$".Clan1_CurrentSelectedApprentice");
		//class'UIAPI_WINDOW'.static.hideWindow(m_WindowName$".ClanMemberInfoWnd.ClanDivideBg2");
		class'UIAPI_WINDOW'.static.hideWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
		class'UIAPI_WINDOW'.static.hideWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");		

		//���� ���� 
		class'UIAPI_WINDOW'.static.hideWindow(m_WindowName$".Clan3_OrganizationChartText_tree");
		for( i=0 ; i < CLAN_KNIGHTHOOD_COUNT ; ++i )
		{
			Clan3_OrgIcon[i].SetAlwaysFullAlpha(false);
			Clan3_OrgIcon[i].SetAlpha(0);
			Clan3_OrgIcon[i].hideWindow();
			Clan3_OrgHighLight[i].hideWindow();			
		}

		class'UIAPI_WINDOW'.static.hideWindow(m_WindowName$".ClanInfoWnd.clanstructure");		
		

		//setAnc
		//Clan3_OrganizationChartText		
	}	
	else 
	{
		class'UIAPI_WINDOW'.static.showWindow(m_WindowName$".Clan1_ChangeMemberKHOpen");
		class'UIAPI_WINDOW'.static.showWindow(m_WindowName$".Clan1_CurrentSelectedApprenticeTitle");
		class'UIAPI_WINDOW'.static.showWindow(m_WindowName$".Clan1_CurrentSelectedApprentice");
		//class'UIAPI_WINDOW'.static.showWindow(m_WindowName$".ClanMemberInfoWnd.ClanDivideBg2");
		class'UIAPI_WINDOW'.static.showWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
		class'UIAPI_WINDOW'.static.showWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");

		//���� ���� 
		class'UIAPI_WINDOW'.static.showWindow(m_WindowName$".Clan3_OrganizationChartText_tree");
		for( i=0 ; i < CLAN_KNIGHTHOOD_COUNT ; ++i )
		{
			Clan3_OrgIcon[i].SetAlwaysFullAlpha(true);
			//Clan3_OrgIcon[i].SetAlpha(255);
			Clan3_OrgIcon[i].showWindow();
			Clan3_OrgHighLight[i].showWindow();
		}
		class'UIAPI_WINDOW'.static.showWindow(m_WindowName$".ClanInfoWnd.clanstructure");		
	}
}
*/

function OnShow()
{
	local ClanWnd script;
	script = ClanWnd( GetScript("ClanWnd") );

	// �ؿ� ���� ó��
	if(GetWindowHandle(m_ClanPledgeBonusDrawerWndName).IsShowWindow()) GetWindowHandle(m_ClanPledgeBonusDrawerWndName).HideWindow();

	// ���ѿ� ���� ��ư Enable/Diable
	class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_ChangeMemberNameBtn");			// nickname
	class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_ChangeMemberGradeBtn");
	class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
	class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
	class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeBanishBtn");
	
	if( script.m_bClanMaster == 0 )
	{
		if(script.m_bNickName == 0)
		{
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberNameBtn");	
		}				// nickname
		if(script.m_bGrade==0)
		{
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberGradeBtn");
		}
		if(script.m_bManageMaster == 0)
		{
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
		}
		if(script.m_bOustMember == 0)
		{
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeBanishBtn");
		}
	}
	//�������� ���°�� ����öȸ��ư ��Ȱ��
	switchingWarCancelButton();
}

function Clear()
{
	m_state = "";
	m_clanType = -1;
	m_clanWarListPage = -1;
	m_currentEditGradeID = -1;
	m_currentName = "";
}

function SetStateAndShow( string state )
{	
	local int i;
	local string string1;
	local string string2;
	local string string3;
	local string string4;
	//debug( "SetState " $ state );
	m_state = state;

	Debug (  "SetStateAndShow" @ class'UIAPI_WINDOW'.static.IsShowWindow("ClanDrawerWnd") );
	if( !class'UIAPI_WINDOW'.static.IsShowWindow("ClanDrawerWnd") )
	{
		class'UIAPI_WINDOW'.static.ShowWindow("ClanDrawerWnd");
	}
	HideAll();
	if( m_state == "ClanMemberInfoState" )
	{
		//RecallCurrentMemberInfo();
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".ClanMemberInfoWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberNameWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberGradeNameWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_AssignApprenticeWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberKnightHoodWnd");
	}
	else if( m_state == "ClanMemberAuthState" )			// ������ ���� ����. ���⸸ �ǹǷ� ��� üũ �ڽ��� Diable
	{
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".ClanMemberAuthWnd");
		for( i=0 ; i <= 10 ; ++i )	// ������ ���� ����- CT2_Final
		{
			if(i < 10) class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan2_Check10" $ i, true );
			else	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan2_Check1" $ i, true );
		}

		for( i=0; i <= 5 ; ++i )
			class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan2_Check20" $ i, true );

		for( i=0; i <= 8 ; ++i )
			class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan2_Check30" $ i, true );

		//class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".ClanMemberAuthWnd");

	}
	else if( m_state == "ClanInfoState" )		// ���� ����
	{
		InitializeClanInfoWnd();
		class'UIAPI_ITEMWINDOW'.static.Clear( m_WindowName$".ClanSkillWnd" );	//������Ʈ �ϱ� ���� �ϴ� ������������ ����
		class'UIDATA_CLAN'.static.RequestClanSkillList();
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".ClanInfoWnd");
		//InitializeClanInfoWnd();
	}
	else if( m_state == "ClanAuthManageWndState" )	// ���� ���
	{
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".ClanAuthManageWnd");
	}
	else if( m_state == "ClanEmblemManageWndState" )	//���� ����
	{
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".ClanEmblemManageWnd");
		
		string1 = Left(GetSystemMessage(211), changelineval1);
		string2 = Right(GetSystemMessage(211), Len(GetSystemMessage(211))-changelineval1);
		string3 = Left(GetSystemMessage(1478), changelineval1);
		string4 = Right(GetSystemMessage(1478), Len(GetSystemMessage(1478))-changelineval1);
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan7_ManageEmb1Text1", string1);
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan7_ManageEmb1Text2", string2);
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan7_ManageEmb2Text1", string3);
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan7_ManageEmb2Text2", string4);
		
		//class'UIAPI_TEXTURECTRL'.static.SetTextureWithClanCrest( m_WindowName$".ClanCrestTextureCtrl", script.m_clanID );
	}
	else if( m_state == "ClanWarManagementWndState" )	// ���� ����
	{
		// m_hClanDrawerWndClanWarTabCtrl.SetTopOrder(0, true);
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".ClanWarManagementWnd");
	}
	else if( m_state == "ClanAuthEditWndState" )	// ���� ����
	{
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".ClanAuthEditWnd");
	}
	else if( m_state == "ClanHeroWndState" )		//���� ���� �޴� ����
	{
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".ClanHeroWnd");
	}
}

function HideAll()
{
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".ClanMemberInfoWnd");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".ClanMemberAuthWnd");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".ClanInfoWnd");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".ClanPenaltyWnd");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".ClanWarManagementWnd");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".ClanAuthManageWnd");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".ClanAuthEditWnd");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".ClanEmblemManageWnd");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".ClanHeroWnd");
	
}

function OnClickButton( string strID )
{
	local LVDataRecord record;
	local int temp1;
	local int nClanIdx;
	local int i;
	//local int warListIndex;
	local ClanWnd script;
	local Array<string> fileextarr;
	script = ClanWnd( GetScript("ClanWnd") );

	//debug("ClanDrawerWnd::OnClickButton " $ strID );
	if( strID == "Clan1_AskJoinPartyBtn" )				// ���� ����. ��Ƽ �ʴ�
	{
		RequestInviteParty( class'UIAPI_TEXTBOX'.static.GetText(m_WindowName$".Clan1_CurrentSelectedMemberName" ) );
	}
	else if( strID == "Clan1_ChangeMemberNameBtn" )		// ���� ����. ȣĪ ����
	{
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".Clan1_ChangeMemberNameWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberGradeNameWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_AssignApprenticeWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberKnightHoodWnd");
		class'UIAPI_EDITBOX'.static.SetString(m_WindowName$".Clan1_ChangeNameTextEditbox","");
		
	}
	else if( strID == "Clan1_ChangeMemberGradeBtn" )	// ���� ����. ��� ����
	{
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".Clan1_ChangeMemberGradeNameWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberNameWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberKnightHoodWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_AssignApprenticeWnd");
	}
	else if ( strID == "Clan1_ChangeBanishBtn")			// ���� ����. ���� ����
	{
		HideClanWindow();
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberNameWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberGradeNameWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_AssignApprenticeWnd");
		RequestClanExpelMember( m_clanType, class'UIAPI_TEXTBOX'.static.GetText(m_WindowName$".Clan1_CurrentSelectedMemberName" ));
	}
	else if( strID == "Clan1_AssignApprenticeBtn" )		// ���� ����. ���� �Ҵ�.
	{
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".Clan1_AssignApprenticeWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberNameWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberKnightHoodWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberGradeNameWnd");
		InitializeAcademyList();
	}
	// �ű��߰� �߰� ������Ʈ 
	else if( strID == "Clan1_ChangeMemberKHOpen" )		// ���� �Ҽ� ����
	{
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".Clan1_ChangeMemberKnightHoodWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_AssignApprenticeWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberNameWnd");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberGradeNameWnd");
		KnighthoodCombobox();
	}
	
	else if( strID == "Clan1_DeleteApprenticeBtn" )		// ���� ����. ���� ���ֱ�
	{
		RequestClanDeletePupil( class'UIAPI_TEXTBOX'.static.GetText(m_WindowName$".Clan1_CurrentSelectedMemberName" ), class'UIAPI_TEXTBOX'.static.GetText(m_WindowName$".Clan1_CurrentSelectedApprentice" ));
		RecallCurrentMemberInfo();
		//ResetdeleteApprenticeonMainWnd(class'UIAPI_TEXTBOX'.static.GetText(m_WindowName$".Clan1_CurrentSelectedMemberName" ), class'UIAPI_TEXTBOX'.static.GetText(m_WindowName$".Clan1_CurrentSelectedApprentice" ));
	}
	else if( strID == "Clan1_OKBtn" )
	{
		HideClanWindow();
	}
	else if( strID == "Clan1_ChangeNameAssignBtn" )		// [ȣĪ ����] ��ư�� ������ �� ȣĪ �Է�â�� �Բ� ������ [����] ��ư
	{
		//debug("Clan1_ChangeNameAssignBtn");
		RequestClanChangeNickName( class'UIAPI_TEXTBOX'.static.GetText(m_WindowName$".Clan1_CurrentSelectedMemberName" ), 
		class'UIAPI_EDITBOX'.static.GetString(m_WindowName$".Clan1_ChangeNameTextEditbox") ) ;
		class'UIAPI_EDITBOX'.static.SetString(m_WindowName$".Clan1_ChangeNameTextEditbox","");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberNameWnd");	
		//���� ���� ���� �Լ� 
		RecallCurrentMemberInfo();
	}
	else if( strID == "Clan1_ChangeNameDeleteBtn" )		// [ȣĪ ����] ��ư�� ������ ��
	{
		//debug("Clan1_ChangeNameDeleteBtn");
		RequestClanChangeNickName( class'UIAPI_TEXTBOX'.static.GetText(m_WindowName$".Clan1_CurrentSelectedMemberName" ), 
			"" );
		class'UIAPI_EDITBOX'.static.SetString(m_WindowName$".Clan1_ChangeNameTextEditbox", "");
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberNameWnd");	
		//���� ���� ���� �Լ� 
		RecallCurrentMemberInfo();
	}
	
	else if( strId == "Clan1_ChangeMemberGradeAssignBtn" ) // [��� ����] ��ư�� ������ �� ������ [����] ��ư
	{
		//debug("Clan1_ChangeMemberGradeAssignBtn");
		//if (class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName$".Clan1_MemberGradeList") <= 5) 
		if (class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName$".Clan1_MemberGradeList") < 5) 
		{
			RequestClanChangeGrade( class'UIAPI_TEXTBOX'.static.GetText(m_WindowName$".Clan1_CurrentSelectedMemberName" ), 
			class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName$".Clan1_MemberGradeList") + 1);	// grade �� 1���� 9����
		} 
		else 
		{
			//debug("���� ����� ã�Ƽ� �����ϵ���");
			//debug("���� ������ Ŭ�� ������ȣ:" @ m_clanType);
			RequestClanChangeGrade( class'UIAPI_TEXTBOX'.static.GetText(m_WindowName$".Clan1_CurrentSelectedMemberName" ), 
			getCurrentGradebyClanType());		// ���� �Ҽӵ���� ã�Ƽ� ���� �Ѵ�.
		}
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberGradeNameWnd");	
		//���� ���� ���� �Լ� 
		RecallCurrentMemberInfo();
	}
	else if( strID == "Clan1_ApprenticeAssignBtn" )		// [���ڼ���] ��ư ������ �� ������ [����] ��ư
	{
		//debug("Clan1_ApprenticeAssignBtn");
		i = class'UIAPI_LISTCTRL'.static.GetSelectedIndex(m_WindowName$".Clan1_AssignApprenticeList");
		if( i >= 0 && m_currentName != "" )
		{
			m_hClanDrawerWndClan1_AssignApprenticeList.GetRec(i, record);
			RequestClanAssignPupil( m_currentName, record.LVDataList[0].szData );
		}
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_AssignApprenticeWnd");	
		//���� ���� ���� �Լ� 
		//RecallCurrentMemberInfo();
		//ResetAssignApprenticeonMainWnd(m_currentName, record.LVDataList[0].szData);
	}
	
	else if( strID == "Clan1_ChangeMemberKnightHoodBtn" )		//�����ҼӺ��� ���� ��ư
	{
		proc_swapmember();
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberKnightHoodWnd");	
	}
	
	
	else if( strID == "Clan1_Cancel1" )		//ȣĪ����â [���] ��ư
	{
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberNameWnd");	
	}
	else if( strID == "Clan1_Cancel2" )		//�������â [���] ��ư
	{
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberGradeNameWnd");	
	}
	else if( strID == "Clan1_Cancel3" )		//�İ��� [���] ��ư
	{
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_AssignApprenticeWnd");	
	}
	else if( strID == "Clan1_Cancel4" )		//�����ҼӺ��� [���] ��ư
	{
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_ChangeMemberKnightHoodWnd");	
	}
	
	else if( strID == "Clan7_RegEmbBtn" )		// ���� ���� ���
	{
		//RequestClanRegisterCrest();

		// FileRegisterWnd

		
		// m_editHandle.IsShowWindow() 

		if (class'UIAPI_WINDOW'.static.IsShowWindow("FileRegisterWnd") == false)
		{
			fileextarr.Length = 1;
			fileextarr[0] = "bmp";			
			ClearFileRegisterWndFileExt();
			AddFileRegisterWndFileExt(GetSystemString(2811), fileextarr);
			FileRegisterWndShow(FH_PLEDGE_CREST_UPLOAD);
		}
	}
	else if( strID == "Clan7_RmEmbBtn" )		// ���� ���� ����
	{
		RequestClanUnregisterCrest();
	}
	else if( strID == "Clan7_RegEmb2Btn" )		// ���� ���
	{
		
		if (class'UIAPI_WINDOW'.static.IsShowWindow("FileRegisterWnd") == false)
		{
			fileextarr.Length = 2;
			fileextarr[0] = "tga";
			fileextarr[1] = "bmp";
			ClearFileRegisterWndFileExt();
			AddFileRegisterWndFileExt(GetSystemString( 2233 ), fileextarr);
			FileRegisterWndShow(FH_PLEDGE_EMBLEM_UPLOAD);
			//RequestClanRegisterEmblem();
		}
	}
	else if( strID == "Clan7_RmEmb2Btn" )		// ���� ����
	{
		RequestClanUnregisterEmblem();
	}

	else if( strID == "Clan8_CancelWar1Btn" )		// �������� ����öȸ
	{
		//���̾�α� ����.
		class'UICommonAPI'.static.DialogSetID( DIALOG_AskClanWarCancel );
		class'UICommonAPI'.static.DialogSetDefaultCancle(); // ���͸� ġ�ų� Ÿ�Ӿƿ��߻��� cancle�� �Ǵ�
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg( GetSystemMessage(3883), ""), string(Self) );
	}
	else if( strID == "Clan8_DeclareWar1Btn" )		// ���⼭���� �Ǽ��� â�϶�
	{
		HandleDeclareWar();
	}
	else if( strID == "Clan8_CancelWar2Btn" )
	{
		HandleCancelWar2();
	}
	else if( strID == "Clan8_ViewMoreBtn" )			// �Ǽ��� â END
	{
		RequestClanWarList( ++m_clanWarListPage, 1 );
	}
	else if( strID == "Clan8_LoseBtn" )			// �й� ���� â
	{
		HandleDeclareLoseWar();
	}
	
	else if( strID == "Clan2_OKBtn" )
	{
		HideClanWindow();
	}
	else if( strID == "Clan3_OKBtn" )
	{
		HideClanWindow();
	}
	else if( strID == "Clan4_OKBtn" )
	{
		HideClanWindow();
	}
	else if( strID == "Clan5_OKBtn" )		// ��� ����Ʈ
	{
		HideClanWindow();
	}
	else if( strID == "Clan7_OKBtn" )
	{
		HideClanWindow();
	}
	else if( strID == "ClanWar_OKBtn" )
	{
		HideClanWindow();
	}
	else if( strID == "Clan5_ManageBtn")
	{
		EditAuthGrade();
	}
	else if( strID == "Clan5_ManageBtn2")
	{
		EditAuthGrade2();
	}
	else if( strID == "Clan6_ApplyBtn" )		// ���� ���� ����
	{
		ApplyEditGrade();
		SetStateAndShow("ClanAuthManageWndState");
	}
	else if( strID == "Clan6_CancelBtn" )
	{
		SetStateAndShow("ClanAuthManageWndState");
	}
	else if( strID == "ClanWarTabCtrl0" )
	{
		RequestClanWarList( 0, 0 );
	}
	else if( strID == "ClanWarTabCtrl1" )
	{
		RequestClanWarList( m_clanWarListPage, 1 );
	}
	else if( strID == "Clan1_ChangeNameAssignNobBtn" )
	{
		//ExecuteCommandFromAction("selfnickname");
		//ExecuteCommand("/selfnickname " $ class'UIAPI_EDITBOX'.static.GetString(m_WindowName$".Clan1_ChangeNobNameTextEditbox"));
		//debug("nicknamechanged?");
		//debug("Clan1_ChangeNameAssignBtn");
		//debug(script.m_myName);
		RequestClanChangeNickName( script.m_myName, 
		class'UIAPI_EDITBOX'.static.GetString(m_WindowName$".Clan1_ChangeNobNameTextEditbox") ) ;
		class'UIAPI_EDITBOX'.static.SetString(m_WindowName$".Clan1_ChangeNobNameTextEditbox","");
		
	}	
	else if( strID == "Clan1_NobCancel1" )
	{
		HideClanWindow();
	}	
	else if( strID == "Clan1_ChangeNameDeleteNobBtn" )
	{
		RequestClanChangeNickName( script.m_myName, "" );
	}
	else if( Left( strID , 12 ) == "Clan3_OrgIco")
	{
		temp1 = Int( Right (strID , 1));
		if(temp1 == 8) 
		{
			return;	// ��ī���̴� �����Ѵ�. 
		}
		if(temp1 > 0  && temp1 < CLAN_KNIGHTHOOD_COUNT + 2)
		{
			if( (ClanClickedID < 0) || (temp1 != ClanClickedID)  )	// Ŭ���Ȱ� ���ų�, ��� �����Ŷ� �Ʊ� ������ �ٸ� ��
			{
				Clan3_OrgHighLight[temp1-1].ShowWindow();
				if(ClanClickedID != -1)	Clan3_OrgHighLight[ClanClickedID-1].HideWindow();	// �ٸ����� ��������� �Ʊ� ���� ���̶���Ʈ ����
				nClanIdx = GetClanTypeFromIndex( temp1 - 1);
				class'UIAPI_ITEMWINDOW'.static.Clear( m_WindowName$".ClanSkillWnd" );	//������Ʈ �ϱ� ���� �ϴ� ������������ ����
				class'UIDATA_CLAN'.static.RequestClanSkillList();			//��ü ���� ��ų ��û
				class'UIDATA_CLAN'.static.RequestSubClanSkillList(nClanIdx);	// �����δ� ��ų ��û
				ClanClickedID = temp1;
			}		
			else if(temp1 == ClanClickedID)	// ��� �������� �� �������� üũ ����
			{
				Clan3_OrgHighLight[temp1-1].HideWindow();
				class'UIAPI_ITEMWINDOW'.static.Clear( m_WindowName$".ClanSkillWnd" );	//������Ʈ �ϱ� ���� �ϴ� ������������ ����
				class'UIDATA_CLAN'.static.RequestClanSkillList();
				ClanClickedID = -1;
			}
		}
	}
	else if (strID == "Clan8_RefreshBtn")
	{	
		RequestClanWarList( 0, 0 );
	}
}

//function ResetAssignApprenticeonMainWnd(string C_NAME, string C_APP)
//{
//	local MainWnd script;
//	script = MainWnd( GetScript("MainWnd") );
//	script.assignClanMasterAssign(C_NAME, script.m_memberList[ script.GetIndexFromType( m_clanType ) ]);
//	debug("changed:" $ C_NAME);
//	script.assignClanMasterAssign(C_APP, script.m_memberList[ script.GetIndexFromType( CLAN_ACADEMY ) ]);
//	debug("changed:" $ C_APP);
//	script.ClearList();
//	script.AddToList( script.m_memberList[ script.GetIndexFromType( m_clanType ) ] );
//	script.m_currentShowIndex = script.GetIndexFromType( m_clanType );
//}


//function ResetdeleteApprenticeonMainWnd(string C_NAME, string C_APP)
//{
//	local MainWnd script;
//	script = MainWnd( GetScript("MainWnd") );
//	script.deleteClanMasterAssign(C_NAME, script.m_memberList[ script.GetIndexFromType( m_clanType ) ]);
//	debug("changed:" $ C_NAME);
//	script.deleteClanMasterAssign(C_APP, script.m_memberList[ script.GetIndexFromType( CLAN_ACADEMY ) ]);
//	debug("changed:" $ C_APP);
//	script.ClearList();
//	script.AddToList( script.m_memberList[ script.GetIndexFromType( m_clanType ) ] );
//	script.m_currentShowIndex = script.GetIndexFromType( m_clanType );
//}


//���ڵ带 ����Ŭ���ϸ�....
function OnDBClickListCtrlRecord( string ListCtrlID)
{
	local int i;
	local LVDataRecord	record;	
	
	if (ListCtrlID == "Clan5_AuthListCtrl")
	{
		EditAuthGrade();
	}
	if (ListCtrlID == "Clan5_AuthListCtrl2")
	{
		EditAuthGrade2();
	}
	
	if (ListCtrlID == "Clan1_AssignApprenticeList")
	{
		//debug("Clan1_ApprenticeAssignBtn");
		i = class'UIAPI_LISTCTRL'.static.GetSelectedIndex(m_WindowName$".Clan1_AssignApprenticeList");
		if( i >= 0 && m_currentName != "" )
		{
			m_hClanDrawerWndClan1_AssignApprenticeList.GetRec(i, record);
			RequestClanAssignPupil( m_currentName, record.LVDataList[0].szData );
		}
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName$".Clan1_AssignApprenticeWnd");	
		//���� ���� ���� �Լ� 
		//RecallCurrentMemberInfo();
		//ResetAssignApprenticeonMainWnd(m_currentName, record.LVDataList[0].szData);
	}
	
}

// ���� ���� ����â�� �����͸� ����
function RecallCurrentMemberInfo()
{
	local ClanWnd script;
	script = ClanWnd( GetScript("ClanWnd") );
	RequestClanMemberInfo(script.G_CurrentRecord, script.G_CurrentSzData);
	SetStateAndShow("ClanMemberInfoState");
}

// selectall_checkbox_coded by Choonsik 
function OnClickCheckBox(string CheckBoxID)
{
	local string CheckboxNum;
	local string CheckboxName;
	local bool CheckedStat;
	local int i;
	
	CheckboxName = Left(CheckBoxID,12);

	if (CheckboxName == "Clan6_Check1")
	{
		CheckboxNum = Right(CheckBoxID,2);
		if (CheckboxNum == "00")
		{
			CheckedStat = class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan6_Check100");
			
			switch (CheckedStat)
			{
				case true:
				//!��ü üũ�ڽ��� üũ�ϴ� �Լ�
				for( i=0 ; i <= 10 ; ++i )
					{
						if(i < 10)	class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check10" $ i, true );
						else		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check1" $ i, true );						
					}
				break;
				case false:
				for( i=0 ; i <= 10 ; ++i )
					{
						if( i< 10)	class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check10" $ i, false );
						else		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check1" $ i, false );
					}
				break;
			}
		} 
		else
		{
			if (count_all_check("1",10) == true) 
			{
				class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check100", true);
			}
			else
			{
				class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check100", false);
			}
		}
	}
	if (CheckboxName == "Clan6_Check2")
	{
		CheckboxNum = Right(CheckBoxID,2);
		if (CheckboxNum == "00")
		{
			CheckedStat = class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan6_Check200");
			
			switch (CheckedStat)
			{
				case true:
				//!��ü üũ�ڽ��� üũ�ϴ� �Լ�
				for( i=0 ; i <= 5 ; ++i )
					{
						class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check20" $ i, true );
					}
				break;
				case false:
				for( i=0 ; i <= 5 ; ++i )
					{
						class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check20" $ i, false );
					}
				break;
			}
		} 
		else
		{
			if (count_all_check("2",8) == true) 
			{
				class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check200", true);
			}
			else
			{
				class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check200", false);
			}
		}
	}
	if (CheckboxName == "Clan6_Check3")
	{
		CheckboxNum = Right(CheckBoxID,2);
		if (CheckboxNum == "00")
		{
			CheckedStat = class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan6_Check300");
			
			switch (CheckedStat)
			{
								case true:
				//!��ü üũ�ڽ��� üũ�ϴ� �Լ�
				for( i=0 ; i <= 9 ; ++i )
					{

						class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check30" $ i, true );
					}
				break;
				case false:
				for( i=0 ; i <= 9 ; ++i )
					{
						class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check30" $ i, false );
					}
				break;
			}
		} 
		else
		{
			if (count_all_check("3",9) == true) 
			{
				class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check300", true);
			}
			else
			{
				class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check300", false);
			}
		}
	}
}

// check all the checkboxes are turned off coded by oxyzen
function bool count_all_check(string numString, int TotalNum)
{
	local bool checkall;
	local bool currentcheck;
	local int i;
	checkall = false;
	for (i=1; i<=TotalNum; ++i)
	{
		if( i < 10)		{currentcheck = class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan6_Check" $ numString $ "0" $ i);}	//10���� �þ�鼭 �ٲپ���.
		else			{currentcheck = class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan6_Check" $ numString  $ i);}
		if (currentcheck == true)
		{
			checkall = true;
		}
	}
		
	return checkall;
}

//check all the checkboxes are turned off coded by oxyzen
function bool count_all_check2(string numString, int TotalNum)
{
	local bool checkall;
	local bool currentcheck;
	local int i;
	checkall = false;
	for (i=1; i<=TotalNum; ++i)
	{
		if(i < 10)	{currentcheck = class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan2_Check" $ numString $"0" $ i);}		//10���� �þ�鼭 �ٲپ���.
		else		{currentcheck = class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan2_Check" $ numString  $ i);}
		if (currentcheck == true)
		{
			checkall = true;
		}
	}
	return checkall;
}

function OnEvent( int a_EventID, String a_Param )
{
	if (getInstanceL2Util().isClanV2()) return;

	switch( a_EventID )
	{
	case EV_ClanAuthGradeList:
		HandleClanAuthGradeList( a_Param );
		break;
	case EV_ClanWarList:
		HandleClanWarList( a_Param );
		break;
	case EV_ClanCrestChange:
		HandleCrestChange( a_Param );
	case EV_ClanMemberInfo:
		HandleClanMemberInfo( a_Param );
		break;
	//branch120516
	// TTP #55298 - gorillazin 12.07.04.
	case EV_ClanSkillList:
		HandleSkillList( a_Param );
		break;
	case EV_ClanSkillListRenew:
		HandleSkillList( a_Param );
		break;
	//end of branch
	//case EV_ClanSkillListAdd:
	//	HandleSkillListAdd( a_Param );
	//	break;
	case EV_ClanAuth:	// ��޿� ���� ���� ����
		HandleClanAuth( a_Param );
		break;
	case EV_ClanAuthMember:	// ������ ���� ���� ����
		HandleClanAuthMember( a_Param );
		break;
	case EV_GamingStateExit:
		class'UIAPI_WINDOW'.static.HideWindow("ClanDrawerWnd");
		break;
	case EV_ClanClearWarList:
		HandleClearWarList( a_Param );
		break;

	case EV_DialogOK:
		 HandleDialogOK();
		 break;

	case EV_DialogCancel: 
		 break;	
	default:
		break;
	}
}

/** ���̾�α� ok �Ǿ����� ó�� */
function HandleDialogOK ()
{
	local int dialogID;

	if( !DialogIsMine() )
	{
		return;
	}
	
	dialogID = DialogGetID();
	
	//  �й� ������ �Ҳ���. ��� ok�� �Ѱ��
	if( dialogID == DIALOG_AskLossClanWar)
	{
		
		RequestClanWarList(0, 0);			// 0 page
		SetStateAndShow("ClanWarManagementWndState");

		//RequestClanWithdrawWarWithClanName( currentLossWarClanName );
		RequestSurrenderPledgeWar(currentLossWarClanName);
	}
	//  ����öȸ ok��� �� ���
	else if(dialogID == DIALOG_AskClanWarCancel)
	{	
		HandleCancelWar1();
	}
	//����öȸ��ư ��Ȱ������
	switchingWarCancelButton();
}


//	�̺�Ʈ �ڵ鷯
//	�������� �̺�Ʈ�� ó���ϴ� �Լ����� Handle....() ������ �̸��� ����
function HandleClanAuthGradeList( String a_Param )
{
	local int count;
	local int id;
	local int members;
	local int i;
	local LVDataRecord	record;
	local LVData		data;
	
	record.LVDataList.Length = 2;
	class'UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName$".Clan5_AuthListCtrl");
	class'UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName$".Clan5_AuthListCtrl2");

	ParseInt( a_Param, "Count", count );
	for(i=0; i<5; ++i)
	{
		ParseInt( a_Param, "GradeID" $ i, id );
		ParseInt( a_Param, "GradeMemberCount" $ i, members );
		data.szData = GetStringByGradeID( id );
		record.LVDataList[0] = data;
		data.szData = string(members);
		record.LVDataList[1] = data;
		record.nReserved1 = id;
		class'UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName$".Clan5_AuthListCtrl", record );
	}
	for(i=5; i<9; ++i)
	{
		ParseInt( a_Param, "GradeID" $ i, id );
		ParseInt( a_Param, "GradeMemberCount" $ i, members );
		data.szData = GetStringByGradeID( id );
		record.LVDataList[0] = data;
		data.szData = string(members);
		record.LVDataList[1] = data;
		record.nReserved1 = id;
		class'UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName$".Clan5_AuthListCtrl2", record );
	}
	class'UIAPI_LISTCTRL'.static.SetSelectedIndex( m_WindowName$".Clan5_AuthListCtrl", 0 ,true);
	class'UIAPI_LISTCTRL'.static.SetSelectedIndex( m_WindowName$".Clan5_AuthListCtrl2", 0 ,true);
}


// 460
// page=0 clanName="�����" State=2 WarSituation=2 ProgressTimeInSec=44433
// ���� ������ �ٲ� 
function HandleClanWarList( String a_Param )
{	
	local LVDataRecord	record;
	local int page;
	
	// Ŭ�� �̸� 
	local string sClanName;

	//  0, 1, 2, 3 ,4, 5  (����, �Ǽ���, ������, �¸�, �й�, ���º�)
	local int state;

	// 0, 1, 2, 3, 4  (�ſ쿭��, ����, ���, �켼. �ſ�켼) , 5(�ƹ��͵� �ƴ�)
	//local int warSituation;

	// ���� �ð� (��) 
	local int progressTimeInSec;

	local Color colorValue;
	
	// ��ü ���� �ð� ����
	local int totalWarSec;

	// ����
	local int point;
	local int pointDiff;	
	local int leftKillCountOfEnemyToWar;
		
	ParseInt( a_Param, "Page", page );
	ParseString( a_Param, "ClanName", sClanName );
	
	ParseInt( a_Param, "State", state );
	ParseInt( a_Param, "ProgressTimeInSec", progressTimeInSec );

	ParseInt( a_Param, "Point", point);  //  ������ ����
	ParseInt( a_Param, "PointDiff", pointDiff);  //  ������ ����

	ParseInt( a_Param, "LeftKillCountOfEnemyToWar", leftKillCountOfEnemyToWar); // �Ǽ��� �� ������� ���� ���� ���Ϳ� ų Ƚ��

	totalWarSec = (60 * 60 * 24) * 7;


	//ParseInt( a_Param, "WarSituation", warSituation );
	// ���� ���¿� ���� Į�� ����
	/* ���� 220, 220, 220 ���� ����
	if (state == 0) 	
	{
		// ���Ｑ���� 3�Ϸ� ���� 
		totalWarSec = (3 * (60 * 60 * 24));

		// ���
		colorValue.R = 255;
		colorValue.G = 180;
		colorValue.B = 0;
	}
	else if (state == 1) 	
	{
		totalWarSec = (3 * (60 * 60 * 24));
		// �ϴ�
		colorValue.R = 128;
		colorValue.G = 255;
		colorValue.B = 255;
	}
	else if (state == 2) 	
	{
		// ������� 21��..
		totalWarSec = (21 * (60 * 60 * 24));

		// ����
		colorValue.R = 220;
		colorValue.G = 70;
		colorValue.B = 50;
	}
	else if (state == 3) 	
	{
		// ��Ȳ
		colorValue.R = 220;
		colorValue.G = 120;
		colorValue.B = 0;

		// �����Ȳ�� �ƹ��͵� �ȳ�����..
		//warSituation = 5;
	}
	else if (state == 4) 	
	{
		// �Ķ�
		colorValue.R = 110;
		colorValue.G = 140;
		colorValue.B = 170;

		// �����Ȳ�� �ƹ��͵� �ȳ�����..
		//warSituation = 5;
	}
	else if (state == 5) 	
	{
		// ȸ�� (����)
		colorValue.R = 220;
		colorValue.G = 220;
		colorValue.B = 220;

		// �����Ȳ�� �ƹ��͵� �ȳ�����..
		//warSituation = 5;
	}*/



	//  ���� ����(220, 220, 220)
	colorValue.R = 220;
	colorValue.G = 220;
	colorValue.B = 220;

	//  ���� �̸�
	//  record.LVDataList ���� 6�� -> 7���� �Ѱ� �߰�
	record.LVDataList.Length = 7;
	record.LVDataList[0].buseTextColor = True;
	record.LVDataList[0].szData = sClanName;
	record.LVDataList[0].TextColor = colorValue;

	// ���� �Ǽ��� ���..
	record.LVDataList[1].buseTextColor = True;
	record.LVDataList[1].szData = getWarStateString( state );
	record.LVDataList[1].TextColor = colorValue;
	record.LVDataList[1].nReserved1 = state;

	// �ֱ� ����Ʈ ��Ȳ���� ��Ȳ ǥ��
	record.LVDataList[2].nReserved1 = getWarType( point );
	record.LVDataList[2].szData = "";	
	record.LVDataList[2].szTexture = getWarSituationTexture( point );
	record.LVDataList[2].nTextureWidth = 11;
	record.LVDataList[2].nTextureHeight = 11;
 	
	//  ����ǥ��
	record.LVDataList[3].buseTextColor = True;
	record.LVDataList[3].szData = String(point);
	record.LVDataList[3].TextColor = colorValue;	
	record.LVDataList[3].nReserved1 = point;	
	
	//  �ֱ� ���� ����
	record.LVDataList[4].nReserved1 = pointDiff;
	

	//  �� ������ ������� ���� ���� ų Ƚ��
	record.LVDataList[5].nReserved1 = leftKillCountOfEnemyToWar;
	//  ���� �ð�
	record.LVDataList[6].nReserved1 = totalWarSec - progressTimeInSec;
	
	/*
	 *record.LVDataList[2].nReserved1 = warSituation;
	record.LVDataList[2].szData = "";	
	record.LVDataList[2].szTexture = getWarSituationTexture( warSituation );
	record.LVDataList[2].nTextureWidth = 11;
	record.LVDataList[2].nTextureHeight = 11;
 	
	record.LVDataList[3].buseTextColor = True;
	
	
	if(point <= 0)
	{
		record.LVDataList[3].szData = "-";
	}
	else
	{
		
	}*/
	
	

	m_clanWarListPage = page;

	// ���� �ð� �߾� ���� �׽�Ʈ..
	m_hClanDrawerWndClan8_DeclaredListCtrl.SetHeaderAlignment(0, TA_CENTER);
	m_hClanDrawerWndClan8_DeclaredListCtrl.SetHeaderAlignment(1, TA_CENTER);
	m_hClanDrawerWndClan8_DeclaredListCtrl.SetHeaderAlignment(2, TA_CENTER);
	m_hClanDrawerWndClan8_DeclaredListCtrl.SetHeaderAlignment(3, TA_CENTER);
		
	class'UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName$".Clan8_DeclaredListCtrl", record);
	
	//����öȸ��ư ��Ȱ�� ����
	switchingWarCancelButton();
	
	/*
	if( type == 0 || type == 2 )
	{
		// m_hClanDrawerWndClanWarTabCtrl.SetTopOrder(0, true);
		class'UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName$".Clan8_DeclaredListCtrl", record);
	}
	else
	{
		// m_hClanDrawerWndClanWarTabCtrl.SetTopOrder(1, true);
		
		class'UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName$".Clan8_GotDeclaredListCtrl", record);
	}
	
	// ��,���� ���� [���� �ð� ó��] (�Ϸ� ���� ���϶�)
	if (progressTimeInSec <= 0)
	{
		record.LVDataList[3].szData = "-";
	}
	else 
	{
		record.LVDataList[3].szData = getSecToDateStr(totalWarSec - progressTimeInSec, false);	
	}
	
	
	
	*/
	// debug("getWarSituationTexture( warSituation )" @ getWarSituationTexture( warSituation ));
	// 1109 �� 
	// Debug("���� : " @ a_Param);
}

//����öȸ Ȱ��ȭ��Ȱ��ȭ
function switchingWarCancelButton()
{
	local int len;
	len = m_hClanDrawerWndClan8_DeclaredListCtrl.GetRecordCount();
	
	if(len > 0)	
		class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan8_CancelWar1Btn");
	
	else 
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan8_CancelWar1Btn");
}

/**
 *  0, 1, 2 (����, �Ǽ���, ������, �¸�, �й�),4,5 (�¸� , �й�)
 **/
function string getWarStateString( int state )
{
	if( state == 0 )
		return GetSystemString( 2349 );	// ����
	else if( state == 1 ) 
		return GetSystemString( 2350 ); // �Ǽ���
	else if( state == 2 ) 
		return GetSystemString( 340 );  // ������
	else if( state == 3 ) 
		return GetSystemString( 828 );  // �¸�
	else if( state == 4 ) 
		return GetSystemString( 2356 ); // �й�
	else if( state == 5 ) 
		return GetSystemString( 846 ); // ���º�


	/*
	 *
	 ct3 ���� ���� ��. (UI��ȹ: ����, ��������� ��ȹ:Ȳ����)
	else if( state == 2 )
		return GetSystemString( 1367 ); //�ֹ漱��
	*/
	return "Error";
}

/**
 * ���� ���¿� ���� ��Ʈ�� ���� 
 * 0, 1, 2 , 3, 4  (�ſ쿭��, ����, ����, �켼, �ſ찭��)
 **/
function string getWarSituationString(int pointDiff)
{
	local string returnStr;
	
	returnStr = "(";

	switch (getWarType(pointDiff))
	{
		case 0 : returnStr = returnStr $ GetSystemString(2355); break;
		case 1 : returnStr = returnStr $ GetSystemString(2354); break;
		case 2 : returnStr = returnStr $ GetSystemString(2353); break;
		case 3 : returnStr = returnStr $ GetSystemString(2352); break;
		case 4 : returnStr = returnStr $ GetSystemString(2351); break;

	}

	returnStr = returnStr $ ")";

	return returnStr;
}

/**
 * Ÿ������ ȭ��ǥ ������ ǥ��
 **/
function string getWarSituationTexture(int pointDiff)
{
	local string returnStr;

	switch (getWarType(pointDiff))
	{
		case 0 : returnStr = "L2ui_ct1.clan_DF_warlist_arrow5"; break;
		case 1 : returnStr = "L2ui_ct1.clan_DF_warlist_arrow4"; break;
		case 2 : returnStr = "L2ui_ct1.clan_DF_warlist_arrow3"; break;
		case 3 : returnStr = "L2ui_ct1.clan_DF_warlist_arrow2"; break;
		case 4 : returnStr = "L2ui_ct1.clan_DF_warlist_arrow1"; break;
	}

	return returnStr;
}


//  ������ Ÿ�� ����
function int getWarType(int value)
{
	local int num;

	if(value <= -50) { num = 0; }
	else if(value > -50 && value <= -20) { num = 1; }
	else if(value > -20 && value <= 19) { num = 2; }
	else if(value > 19 && value <= 49) { num = 3; }
	else if(value >= 50) { num = 4; }

	return num;
}

function HandleClanMemberInfo( String a_Param )
{
	local string nickName;
	local int gradeID;
	local string organization;
	local string masterName;		// empty if not exists
	local ClanWnd script;
	local string organizationtext;

	script = ClanWnd( GetScript("ClanWnd") );

	ParseInt( a_Param, "ClanType", m_clanType );
	ParseString( a_Param, "Name", m_currentName );
	ParseString( a_Param, "NickName", nickName );
	ParseInt( a_Param, "GradeID", gradeID );
	ParseString( a_Param, "OrderName", organization );
	ParseString( a_Param, "MasterName", MasterName );

	currentMasterName = masterName;
	//debug("d:"$currentMasterName);
	if (masterName == "")
	{
		masterName = GetSystemString(27);
	}
	//oxyzen
	organizationtext = getClanOrderString( m_clanType )@"-"@organization;
	
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan1_CurrentSelectedMemberName", m_currentName );
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan1_CurrentSelectedMemberSName", nickName);
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan1_CurrentSelectedMemberGrade", GetStringByGradeID(gradeID));
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan1_CurrentSelectedMemberOrderName", organizationtext);
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan1_CurrentSelectedApprentice", masterName);
		
	if (script.m_CurrentclanMasterReal == m_currentName)
	{
		if (script.m_currentShowIndex == 0)
		{
			class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan1_CurrentSelectedMemberGrade",GetSystemString(342));
		} 
	}
	

	
	// pledgeType�� ���� "�İ���", "����"�� �ؽ�Ʈ�� �ٲ� �����
	if ( m_clanType == CLAN_ACADEMY )
	{
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan1_CurrentSelectedApprenticeTitle", GetSystemString( 1332 ) );
	}
	else
	{
		class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
		class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
			
					if (currentMasterName != "")
			{
				//Debug("PressDel");
				class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
			}
			else
			{
				//Debug("PressName");
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
				class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
			}

		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan1_CurrentSelectedApprenticeTitle", GetSystemString( 1431 ) );

	}
	
	
	script.resetBtnShowHide();
	CheckandCompareMyNameandDisableThings();
}

//��ȯ ���� â �𽺿��̺� ��Ű�� oxyzen
function CheckandCompareMyNameandDisableThings()
{
	local ClanWnd script;
	local UserInfo userinfo;
	//userinfo = GetUser();
	GetPlayerInfo( userinfo );
	m_myName = userinfo.Name;
	script = ClanWnd( GetScript("ClanWnd") );
	//debug("informme:" $ script.m_bOustMember);
	//�������ϰ�� ��޼�����ư ��Ȱ��ȭ/���������ư Ȱ��ȭ
	if (script.m_bClanMaster > 0)
	{
		class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_ChangeBanishBtn");
		class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_ChangeMemberKHOpen");
			
		if (currentMasterName != "")
		{
			//Debug("PressDel");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
			if (script.G_CurrentAlias == true)
			{
				class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
			}
		}
		else
		{
			//Debug("PressName");
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
		}
	} 
	// ���⼭���ʹ� �����ְ� �ƴҰ��
	else 
	{
		// �켱 ��޼������� �ϰ�...
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberGradeBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeBanishBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberKHOpen");
		Proc_AuthValidation();
		// �ڱ⺸�� ���� ��ȣ�� ����(�������ڴ� �Ųٷ�...) 
		if (script.GetClanTypeFromIndex( script.m_currentShowIndex) < script.m_myClanType)
		{
			//Debug("EditAuth"@ script.GetClanTypeFromIndex( script.m_currentShowIndex) @ script.m_myClanType);
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeBanishBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberGradeBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
			if (m_clanType == CLAN_ACADEMY)
			{
			}
			else
			{
				class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberNameBtn");
			}
		} 
		if (script.m_myClanType > 1)
		{
			if (script.GetClanTypeFromIndex(script.m_currentShowIndex) != 0)
			{
				if (script.m_myClanType - script.GetClanTypeFromIndex( script.m_currentShowIndex) == 1)
				{
					Proc_AuthValidation();
				}                                       
				if (script.m_myClanType - script.GetClanTypeFromIndex( script.m_currentShowIndex) == 1000)
				{
					Proc_AuthValidation();
				}
				if (script.m_myClanType - script.GetClanTypeFromIndex( script.m_currentShowIndex) == 100)
				{
					Proc_AuthValidation();
				}
				if (script.m_myClanType - script.GetClanTypeFromIndex( script.m_currentShowIndex) == 999)
				{
					Proc_AuthValidation();
				} 
				if (script.m_myClanType - script.GetClanTypeFromIndex( script.m_currentShowIndex) == 1001)
				{
					Proc_AuthValidation();
				} 
			}
		}
		if (script.G_CurrentAlias == true)
		{
			//Debug("EditAuth"@ script.GetClanTypeFromIndex( script.m_currentShowIndex) @ script.m_myClanType);
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeBanishBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberNameBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberGradeBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberKHOpen");
		} 
		// �� �������� ������ ���� �� �� ����. - �ٸ� �������� �켱��.
		if (script.m_CurrentclanMasterReal == m_currentName)
		{
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberGradeBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeBanishBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberNameBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberKHOpen");
			
		}
	}
	// �ڱ� ������ �ڱⰡ ���� �� �� ����.	
	if (m_currentName == m_myName)
	{
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberGradeBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeBanishBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberKHOpen");
	}
	//��ī�������Ϳ����Դ� �� ������ ������ ������ �� ����. 
	if (m_clanType == CLAN_ACADEMY)
	{
		//debug("Academy");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberGradeBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
	}
}
//���� ���μ��� �κ�
function Proc_AuthValidation()
{
	local ClanWnd script;
	script = ClanWnd( GetScript("ClanWnd") );
	
	if(script.m_bNickName == 0)
	{
		
		if (script.G_IamHero == true || script.G_IamNobless > 0) 
		{
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_ChangeMemberNameBtn");	
		}
		else 
		{
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberNameBtn");	
		}
	}
	else
	{
		class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_ChangeMemberNameBtn");	
	}
	if(script.m_bGrade==0)
	{
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberGradeBtn");
	}
	else
	{
		class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_ChangeMemberGradeBtn");

	}
	if(script.m_bManageMaster == 0)
	{
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
	}
	else
	{
		if (currentMasterName != "")
		{
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
		}
		else
		{
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_AssignApprenticeBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_DeleteApprenticeBtn");
		}

	}
	if(script.m_bOustMember == 0)
	{
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeBanishBtn");
	}
	else
	{
		class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_ChangeBanishBtn");			
	}
}

function HandleCrestChange( String param )
{
	local ClanWnd script;
	if( m_state == "ClanEmblemManageWndState" )
	{
		script = ClanWnd( GetScript("ClanWnd"));
		class'UIAPI_TEXTURECTRL'.static.SetTextureWithClanCrest( m_WindowName$".ClanCrestTextureCtrl", script.m_clanID );
	}
}

function HandleSkillList( String a_Param )
{
	local int count;
	local int i;
	local int level;
	local int findItemID;
	local string AgitText;
	local ItemID cID;
	
	ParseInt( a_Param, "Count", count );
	//debug("Count : " $ Count);
	for(i=0; i<count ; ++i)
	{
		ParseItemIDWithIndex( a_Param, cID, i );
		ParseInt( a_Param, "SkillLevel_" $ i, level );
		findItemID = class'UIAPI_ITEMWINDOW'.static.FindItem(m_WindowName$".ClanSkillWnd", cID);
		AgitText = class'UIAPI_TEXTBOX'.static.GetText("ClanWnd.ClanAgitText");
		//debug("AgitText : " $ AgitText);
		//debug("findItemID : " $ findItemID);
		//if(findItemID < 0 && InStr(GetSystemString( 27 ) ,AgitText ) < 0 )	//������ ���� ��쿡�� �����ش�. 
		//{
			AddSkill( cID, level );
		//}

		//debug("cID : " $ cID.classID $ " level : " $ level );
	}
}

//function HandleSkillListAdd( String a_Param )
//{
//	local int level;
//	local int i;
//	local int count;
//	local ItemInfo info;
//	local ItemID cID;
//
//	ParseItemID( a_Param, cID );
//	ParseInt( a_Param, "SkillLevel", level );
//
//	count = class'UIAPI_ITEMWINDOW'.static.GetItemNum(m_WindowName$".ClanSkillWnd");
//	for( i=0 ; i < count ; ++i )
//	{
//		class'UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName$".ClanSkillWnd", i, info);
//		if( IsSameClassID( info.ID, cID ) )	/// match found
//			break;
//	}
//	
//	if( i < count )	// match found
//	{
//		ReplaceSkill( i, cID, level );
//	}
//	else
//	{
//		AddSkill( cID, level );
//	}
//}

/**
 *  ���� �й� ����  	// ���� â�϶�
 **/
function HandleDeclareLoseWar()
{
	local LVDataRecord record;
	local int index;
	index = class'UIAPI_LISTCTRL'.static.GetSelectedIndex(m_WindowName$".Clan8_DeclaredListCtrl");

	if( index >= 0 )
	{
		m_hClanDrawerWndClan8_DeclaredListCtrl.GetRec(index, record);
		//debug ("record.LVDataList[0].szData " @record.LVDataList[0].szData );
		// debug("�й� ���� :" @ record.LVDataList[0].szData);

		currentLossWarClanName = record.LVDataList[0].szData;
		DialogSetID( DIALOG_AskLossClanWar );
		
		// �������� �����̶� ���� ���� �й踦 ��û �մϱ�? �� �̷� ��Ʈ..
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg( GetSystemMessage(3409), record.LVDataList[0].szData), string(Self) );			
		
	}
}

/** 
 *  �̹� ������ ���� �Ͽ����� üũ 
 *  �� ���� (���ʿ��� ������ ������ ���)
 *  
 **/
function bool searchClanWarDeclare(string clanName)
{
	local LVDataRecord record;
	local int i, maxRec;
	local bool bCheck;
	//index = class'UIAPI_LISTCTRL'.static.GetSelectedIndex(m_WindowName$".Clan8_DeclaredListCtrl");

	bCheck = false;
	maxRec = m_hClanDrawerWndClan8_DeclaredListCtrl.GetRecordCount();

	for (i = 0; i < maxRec; i++)
	{
		m_hClanDrawerWndClan8_DeclaredListCtrl.GetRec(i, record);
		// debug ("record.LVDataList[0].szData " @record.LVDataList[0].szData );
		// debug("���� :" @ record.LVDataList[0].szData);
		// debug("���� :" @ record.LVDataList[1].szData);
		// debug("���� :" @ record.LVDataList[1].nReserved1);
		
		if (record.LVDataList[0].szData == clanName)
		{
			if (record.LVDataList[1].nReserved1 == 1)
			{
				bCheck = true;
				break;
			}
		}		
		
	}

	return bCheck;
}


function HandleCancelWar1()			// ���� â�϶�
{
	local LVDataRecord record;
	local int index;
	index = class'UIAPI_LISTCTRL'.static.GetSelectedIndex(m_WindowName$".Clan8_DeclaredListCtrl");

	if( index >= 0 )
	{
		m_hClanDrawerWndClan8_DeclaredListCtrl.GetRec(index, record);
		// debug ("record.LVDataList[0].szData " @record.LVDataList[0].szData );
		RequestClanWithdrawWarWithClanName( record.LVDataList[0].szData );
		//debug("HandleCancelWar1 " $ record.LVDataList[0].szData );
		RequestClanWarList(0, 0);			// 0 page
		SetStateAndShow("ClanWarManagementWndState");
	}
}

function HandleDeclareWar()	
{
	local LVDataRecord record;
	local int index;
	index = m_hClanDrawerWndClan8_GotDeclaredListCtrl.GetSelectedIndex();

	if( index >= 0 )
	{
		m_hClanDrawerWndClan8_GotDeclaredListCtrl.GetRec(index, record);
		RequestClanDeclareWarWithClanName( record.LVDataList[0].szData );
		RequestClanWarList( m_clanWarListPage, 1 );
		
	}
}

function HandleCancelWar2()		// �Ǽ��� â�� ��
{
	local LVDataRecord record;
	local int index;
	index = m_hClanDrawerWndClan8_GotDeclaredListCtrl.GetSelectedIndex();

	if( index >= 0 )
	{
		m_hClanDrawerWndClan8_GotDeclaredListCtrl.GetRec(index, record);
		RequestClanWithdrawWarWithClanName( record.LVDataList[0].szData );
		RequestClanWarList( m_clanWarListPage, 1 );
		//m_hClanDrawerWndClanWarTabCtrl.SetTopOrder(1, true);
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".ClanWarManagementWnd");
		
	}
}

function HandleClanAuth( String a_Param )		// ���� ��� ó��
{
	local int gradeID;
	local int command;
	local array<int> powers;
	local int i;
	local int index;

	ParseInt( a_Param, "GradeID", gradeID );
	ParseInt( a_Param, "Command", command );

	powers.Length = 32;
	for( i = 0; i < 32 ; ++i )
	{
		ParseInt( a_Param, "PowerValue" $ i, powers[ i ] );
	}

	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan6_CurrentSelectedRankName", GetStringByGradeID( gradeID ) $ GetSystemString(1376) );

	index = 1;
	for( i=1 ; i <= 10 ; ++i )	// ������ ���� ����
	{			
		if(i < 10) class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check10" $ i, bool( powers[index++] ) );
		else class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check1" $ i, bool( powers[index++] ) );
	}

	for( i=1; i <= 5 ; ++i )
	{
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check20" $ i, bool( powers[index++] ) );
	}

	for( i=1; i <= 8 ; ++i )
	{
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check30" $ i, bool( powers[index++] ) );
	}
	
	if (count_all_check("1", 10) == true)
	{
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check100", true);
	} else {
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check100", false);
	}
	if (count_all_check("2", 5) == true)
	{
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check200", true);
	} else {
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check200", false);
	}
	if (count_all_check("3", 8) == true)
	{
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check300", true);
	} else {
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan6_Check300", false);
	}

	if ( gradeID == CLAN_AUTH_GRADE9)
	{
		//debug("I have done1");
		disableAcademyAuth();
	} 
	else
	{
		resetAcademyAuth();
	}
	
}

function HandleClanAuthMember( String a_Param )	// ���� ����
{
	local ClanWnd script;
	
	local int gradeID;
	local string sName;
	local array<int> powers;
	local int i;
	local int index;
	script = ClanWnd( GetScript("ClanWnd") );

	ParseInt( a_Param, "Grade", gradeID );
	ParseString( a_Param, "Name", sName );

	powers.Length = 32;
	for( i = 0; i < 32 ; ++i )
	{
		ParseInt( a_Param, "PowerValue" $ i, powers[ i ] );
	}

	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan2_CurrentSelectedMemberName", sName @ "-" @ GetStringByGradeID( gradeID ));
	
	index = 1;
	for( i=1 ; i <= 10 ; ++i )	// ������ ���� ���� - CT2_Final
	{
		if(i < 10) class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check10" $ i, bool( powers[index++] ) );
		else class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check1" $ i, bool( powers[index++] ) );
	}

	for( i=1; i <= 5 ; ++i )
	{
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check20" $ i, bool( powers[index++] ) );
	}

	for( i=1; i <= 8 ; ++i )
	{
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check30" $ i, bool( powers[index++] ) );
	}
	
	if (count_all_check2("1", 10) == true)	// ������ ���� ���� - CT2_Final
	{
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check100", true);
	} else {
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check100", false);
	}
	if (count_all_check2("2", 5) == true)
	{
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check200", true);
	} else {
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check200", false);
	}
	if (count_all_check2("3", 8) == true)
	{
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check300", true);
	} else {
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check300", false);
	}

	//�������� �µ����Ͱ� �ڽ��� ������ ��� �ڽ��� ���� ��â�� ��������
	if (script.m_myName == sName)
	{
		//���Ա���
		if (class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan2_Check101") == true)
		{
			script.m_bJoin = 1;
		}
		else
		{
			script.m_bJoin = 0;
		}
		if (class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan2_Check107") == true)
		{
			script.m_bCrest = 1;
		}	
		else
		{
			script.m_bCrest = 0;
		}
		if (class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan2_Check105") == true)
		{
			script.m_bWar = 1;
		}	
		else
		{
			script.m_bWar = 0;
		}
	script.resetBtnShowHide();
	//script.m_bCrest = 1;
	//script.m_bWar = 1;
	//script.m_bGrade = 1;
	//script.m_bManageMaster = 1;
	//script.m_bOustMember =1;
	}
		// ������ ���� ó�� �����ָ� ��� Ʈ�縦 ���� �־� ��.
	if (script.m_CurrentclanMasterReal == sName)
	{
		//�����
		//debug("iamRunning:" @  script.m_CurrentclanMasterName @ sName);
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan2_CurrentSelectedMemberName", sName @ "-" @ GetSystemString(342));
		for( i=0 ; i <= 10 ; ++i )	// ������ ���� ���� - CT2_Final
		{
			if( i < 10)	class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check10" $ i, true );
			else 	class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check1" $ i, true );
		}
	
		for( i=0; i <= 5 ; ++i )
		{
			class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check20" $ i, true );
		}
	
		for( i=0; i <= 8 ; ++i )
		{
			class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName$".Clan2_Check30" $ i, true );
		}
	}
	
}

function HandleClearWarList( String a_Param )
{
	// local int condition;

	class'UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName$".Clan8_DeclaredListCtrl");
	switchingWarCancelButton();
	/*
	if( ParseInt( a_Param, "Condition", condition ) )
	{
		if( condition == 0 )
			
		else
			class'UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName$".Clan8_GotDeclaredListCtrl");
	}
	*/
}

//
//	�̺�Ʈ �ڵ鷯 - END
//


// ����� ������ �׿� �´� �ý��� ��Ʈ���� �����ش�
function string GetStringByGradeID( int gradeID )
{
	local int stringIndex;
	stringIndex = -1;
	
	//~ debug("gradeID" @ gradeID);
	
	if( gradeID == CLAN_AUTH_GRADE1 )
		stringIndex = 1406;
	else if( gradeID == CLAN_AUTH_GRADE2 )
		stringIndex = 1407;
	else if( gradeID == CLAN_AUTH_GRADE3 )
		stringIndex = 1408;
	else if( gradeID == CLAN_AUTH_GRADE4 )
		stringIndex = 1409;
	else if( gradeID == CLAN_AUTH_GRADE5 )
		stringIndex = 1410;
	else if( gradeID == CLAN_AUTH_GRADE6 )
		stringIndex = 1411;
	else if( gradeID == CLAN_AUTH_GRADE7 )
		stringIndex = 1412;
	else if( gradeID == CLAN_AUTH_GRADE8 )
		stringIndex = 1413;
	else if( gradeID == CLAN_AUTH_GRADE9 )
		stringIndex = 1414;

	if( stringIndex != -1 )
		return GetSystemString( stringIndex );
	else 
		return "";

}

// ���� ������ ���ؼ� ��ī���� ���Ϳ����� ������ ����Ʈ ��Ʈ�ѿ� �߰��Ѵ�
function InitializeAcademyList()
{
	local ClanWnd script;
	local int i;
	local LVDataRecord record;
	record.LVDataList.Length = 3;
	script = ClanWnd( GetScript("ClanWnd") );
	InitializeClan1_AssignApprenticeList();
	for( i=0 ; i < script.m_memberList[ script.GetIndexFromType( CLAN_ACADEMY ) ].m_array.Length ; ++i )
	{
		//�İ����� �ִ� ��ī���̿��� �������� �ʴ´�.
		if (  script.m_memberList[ script.GetIndexFromType( CLAN_ACADEMY ) ].m_array[i].bHaveMaster == 0 )	
		{
			record.LVDataList[0].szData = script.m_memberList[ script.GetIndexFromType( CLAN_ACADEMY ) ].m_array[i].sName;
			record.LVDataList[1].szData = string(script.m_memberList[ script.GetIndexFromType( CLAN_ACADEMY ) ].m_array[i].level);
			record.nReserved1 = script.m_memberList[ script.GetIndexFromType( CLAN_ACADEMY ) ].m_array[i].clanType;		// for additional information
			record.LVDataList[2].szData = string( script.m_memberList[ script.GetIndexFromType( CLAN_ACADEMY ) ].m_array[i].classID );
			record.LVDataList[2].szTexture = GetClassRoleIconName(script.m_memberList[ script.GetIndexFromType( CLAN_ACADEMY ) ].m_array[i].classID);
			record.LVDataList[2].nTextureWidth = 11;
			record.LVDataList[2].nTextureHeight = 11;
			class'UIAPI_LISTCTRL'.static.InsertRecord( m_WindowName$".Clan1_AssignApprenticeList", record );
		}
	}
}

function InitializeClan1_AssignApprenticeList()
{
	class'UIAPI_LISTCTRL'.static.DeleteAllItem( m_WindowName$".Clan1_AssignApprenticeList" );
}

// ���� ����â �ʱ�ȭ
function InitializeClanInfoWnd()
{
	local Color Blue;
	local Color Red;
	local Color DarkYellow;
	local ClanWnd script;
	local SkillTrainClanTreeWnd script2;
	local int i;
	local string ClanNameVal;
	local string ClanRankStr;
	local string tooltip;
	local int	clanType;
	
	Blue.R = 126;
	Blue.G = 158;
	Blue.B = 245;
	Red.R = 200;
	Red.G = 50;
	Red.B = 80;
	DarkYellow.R =175;
	DarkYellow.G =152;
	DarkYellow.B =120;
	
	script = ClanWnd( GetScript("ClanWnd") );
	script2 = SkillTrainClanTreeWnd( GetScript("SkillTrainClanTreeWnd") );
	ClanNameVal = script.m_clanNameValue @ GetSystemString(1442);
	
	// ���̶���Ʈ �� ���� �ִٸ� �����ش�. 
	if(ClanClickedID>0 && Clan3_OrgHighLight[ClanClickedID-1].isShowWindow()) Clan3_OrgHighLight[ClanClickedID-1].HideWindow();
	ClanClickedID = -1;	// Ŭ���� ���� ������ �Ѵ�. 
	
	// reset all 
	reset_clan_org();
	
	if (script.m_clanRank == 0)
	{
		ClanRankStr = GetSystemString(1374);
	}
	else if (script.m_clanRank <= c_maxranklimit)
	{
		ClanRankStr = script.m_clanRank @ GetSystemString(1375);
	}
	else 
	{
		ClanRankStr = GetSystemString(1374);
	}
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan3_ClanName", script.m_clanName );
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan3_ClanPoint", ClanNameVal );
	
	if (script.m_clanNameValue == 0)
	{
		class'UIAPI_TEXTBOX'.static.SetTextColor(m_WindowName$".Clan3_ClanPoint", DarkYellow );
	}
	else if (script.m_clanNameValue < 0)
	{
		class'UIAPI_TEXTBOX'.static.SetTextColor(m_WindowName$".Clan3_ClanPoint", Red );
	}
	else if (script.m_clanNameValue > 0)
	{
		class'UIAPI_TEXTBOX'.static.SetTextColor(m_WindowName$".Clan3_ClanPoint", Blue );
	}
	
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan3_ClanRanking", ClanRankStr );

	for( i=0 ; i < CLAN_KNIGHTHOOD_COUNT ; ++i )
	{
		if( script.m_memberList[i].m_sName != "" )
		{
			clanType = script.GetClanTypeFromIndex(i);
			if( clanType == CLAN_MAIN )
			{
				tooltip = script.m_memberList[i].m_sName $ "\\n" $ GetSystemString(342) $ " : " $ script.m_memberList[i].m_sMasterName;
			}
			if( clanType == CLAN_ACADEMY )
			{
				tooltip = script.m_memberList[i].m_sName;
			}
			if( clanType == CLAN_KNIGHT1 || clanType == CLAN_KNIGHT2 )		// ������
			{
				tooltip = script.m_memberList[i].m_sName $ "\\n" $ GetSystemString(1438) $ " : " $ script.m_memberList[i].m_sMasterName;
			}
			if( clanType == CLAN_KNIGHT3 || clanType == CLAN_KNIGHT4 || clanType == CLAN_KNIGHT5 || clanType == CLAN_KNIGHT6 )
			{
				tooltip = script.m_memberList[i].m_sName $ "\\n" $ GetSystemString(1433) $ " : " $ script.m_memberList[i].m_sMasterName;
			}
			if (tooltip != "")
			{
				Clan3_OrgIcon[i].ShowWindow();
				Clan3_OrgIcon[i].EnableWindow();
				Clan3_OrgIcon[i].SetTooltipCustomType(SetTooltip(tooltip));
				script2.Clan_OrgIcon[i].ShowWindow();
				//script2.Clan_OrgIcon[i].EnableWindow();
				script2.Clan_OrgIcon[i].SetTooltipCustomType(SetTooltip(tooltip));
			}
		}
	}
}


function InitializeGradeComboBox()
{
	local int i;
	class'UIAPI_COMBOBOX'.static.Clear(m_WindowName$".Clan1_MemberGradeList");

	for( i = CLAN_AUTH_GRADE1 ; i < CLAN_AUTH_GRADE6; ++i )
	{
		class'UIAPI_COMBOBOX'.static.AddString(m_WindowName$".Clan1_MemberGradeList", GetStringByGradeID( i ) );
	}
	
	class'UIAPI_COMBOBOX'.static.AddString(m_WindowName$".Clan1_MemberGradeList", GetSystemString(1451) );
}

function KnighthoodCombobox()
{
	local ClanWnd script;
	local int i;
	script = ClanWnd( GetScript("ClanWnd") );

	class'UIAPI_COMBOBOX'.static.Clear(m_WindowName$".Clan1_targetknighthoodcombobox");
	class'UIAPI_COMBOBOX'.static.Clear(m_WindowName$".Clan1_targetknighthoodmember");
		
	class'UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName$".Clan1_targetknighthoodcombobox", GetSystemString(1465), 0);
	class'UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName$".Clan1_targetknighthoodmember", GetSystemString(1466), 0);

	class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_targetknighthoodmember");
	class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName$".Clan1_ChangeMemberKnightHoodBtn");

	class'UIAPI_TEXTBOX'.static.SetText( m_WindowName$".Clan1_ChangeMemberKnightHoodTXT1", MakeFullSystemMsg(GetSystemMessage(1906), m_currentName, ""));
	
	for( i=0 ; i < script.CLAN_KNIGHTHOOD_COUNT ; ++i )
	{
		if( script.m_memberList[i].m_sName != "" )
		{
			if (script.GetClanTypeFromIndex(i) != CLAN_ACADEMY)
			{
				class'UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName$".Clan1_targetknighthoodcombobox", script.m_memberList[i].m_sName, i);
			}
		}
	}
	
	class'UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName$".Clan1_targetknighthoodcombobox",0);
	
}


function swapTargetSelect(int clanNo)
{
	local ClanWnd script;
	local int i;
	script = ClanWnd( GetScript("ClanWnd") );

	class'UIAPI_COMBOBOX'.static.Clear(m_WindowName$".Clan1_targetknighthoodmember");
	class'UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName$".Clan1_targetknighthoodmember", GetSystemString(1466), 0);
	class'UIAPI_TEXTBOX'.static.SetText( m_WindowName$".Clan1_ChangeMemberKnightHoodTXT1", MakeFullSystemMsg(GetSystemMessage(1907), m_currentName, ""));
	
	for( i=0 ; i <= script.m_memberList[ clanNo ].m_array.Length ; ++i )
	{
		if ( script.m_memberList[ clanNo ].m_array[i].sName != script.m_CurrentclanMasterReal)
		class'UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName$".Clan1_targetknighthoodmember", script.m_memberList[ clanNo ].m_array[i].sName, script.m_memberList[ clanNo ].m_array[i].clanType);
	}
	class'UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName$".Clan1_targetknighthoodmember",0);
	
}

function proc_swapmember()
{
	
	local int currentindexnew1;
	local int currentindexnew2;
	local string currentstring1; 
	local string currentstring2; 
	local int type;
	local int clantype1;
	//local int clantype2;
	local ClanWnd script;
	script = ClanWnd( GetScript("ClanWnd") );
	
	currentindexnew1 = class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName$".Clan1_targetknighthoodcombobox");
	currentstring1 = class'UIAPI_COMBOBOX'.static.GetString(m_WindowName$".Clan1_targetknighthoodcombobox", currentindexnew1);
	clantype1 = script.GetClanTypeFromIndex(class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName$".Clan1_targetknighthoodcombobox", currentindexnew1));
	
	currentindexnew2 = class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName$".Clan1_targetknighthoodmember");
	currentstring2 = class'UIAPI_COMBOBOX'.static.GetString(m_WindowName$".Clan1_targetknighthoodmember", currentindexnew2);

		
	//debug(currentstring1 @ currentstring2);
	
	if (currentindexnew2 == 0)
	{
		type = 0;
	}
	else 
	{
		type = 1;
	}
	
	if (type == 1)
	{
		//debug("�����ü");
		RequestClanReorganizeMember( 1, m_currentName, clantype1, currentstring2);
	}
	else if (type == 0)
	{
		//debug("����̵��̾�");
		RequestClanReorganizeMember( 0, m_currentName, clantype1, "");
	}
	
	//class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".Clan1_CurrentSelectedMemberOrderName", getClanOrderString( clantype1 ) @ "-" @ currentstring1);
}


function OnComboBoxItemSelected(string strID, int index)
{
	local int selectval;
	if (strID == "Clan1_targetknighthoodcombobox")
	{
		class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_targetknighthoodmember");
		class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName$".Clan1_ChangeMemberKnightHoodBtn");
		selectval = class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName$".Clan1_targetknighthoodcombobox", index);
		swapTargetSelect(selectval);
	}
}

function HideClanWindow()
{
	local ClanWnd script;
	script = ClanWnd( GetScript("ClanWnd") );
	
	//debug ("HideWindow is in Run");
	class'UIAPI_WINDOW'.static.HideWindow("ClanDrawerWnd");
	script.ResetOpeningVariables();
	switchingWarCancelButton();
}

function ApplyEditGrade()	// ���� ���� ����
{
	local array<int> powers;
	local int i;
	local int index;
	powers.Length = 32;
	powers[0]=0;			// first power bit is dummy
	index = 1;
	for( i=1 ; i <= 10 ; ++i )	// ������ ���� ���� ���� - CT2_Final
	{
		if( i < 10)
		{
			if( class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan6_Check10" $ i ) )	powers[index] = 1;
		}
		else
		{
			if( class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan6_Check1" $ i ) )	powers[index] = 1;
		}
		++index;
	}

	for( i=1; i <= 5 ; ++i )
	{
		if( class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan6_Check20" $ i ) )
		{
			//debug ("����Ʈ����" @ m_WindowName$".Clan6_Check20" $ i  );
			powers[index] = 1;
		}
		++index;
	}

	for( i=1; i <= 8 ; ++i )
	{
		if( class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName$".Clan6_Check30" $ i ) )
		{
			//debug ("��/�������" @ m_WindowName$".Clan6_Check30" $ i  );
			powers[index] = 1;
		}
		++index;
	}

		
	RequestEditClanAuth( m_currentEditGradeID, powers );
}

function EditAuthGrade()
{
	local int index;
	local LVDataRecord record;
	index = m_hClanDrawerWndClan5_AuthListCtrl.GetSelectedIndex();
	if( index >= 0 )
	{
		m_hClanDrawerWndClan5_AuthListCtrl.GetRec(index, record);
		RequestClanAuth( int(record.nReserved1) );
		//debug("RequestClanAuth " $ ( record.nReserved1 ) );
		m_currentEditGradeID = int(record.nReserved1);
		SetStateAndShow("ClanAuthEditWndState");
	
	}
	else
	{
		SetStateAndShow("ClanAuthManageWndState");
	}
}

function EditAuthGrade2()
{
	local int index;
	local LVDataRecord record;
	index = m_hClanDrawerWndClan5_AuthListCtrl2.GetSelectedIndex();
	if( index >= 0 )
	{
		m_hClanDrawerWndClan5_AuthListCtrl2.GetRec( index, record);
		RequestClanAuth( int(record.nReserved1) );
		//debug("RequestClanAuth " $ ( record.nReserved1 ) );
		m_currentEditGradeID = int(record.nReserved1);
		SetStateAndShow("ClanAuthEditWndState");
	
	}
	else
	{
		SetStateAndShow("ClanAuthManageWndState");
	}
}

function AddSkill( ItemID cID, int level )
{
	local ItemInfo info;

	info.ID = cID;
	info.Level = level;
	info.Name = class'UIDATA_SKILL'.static.GetName( info.ID, info.Level, info.SubLevel );
	//Ŭ�� ��ų�� subLevel �� 0 ��
	info.IconName = class'UIDATA_SKILL'.static.GetIconName( info.ID, info.Level, info.SubLevel );
	info.Description = class'UIDATA_SKILL'.static.GetDescription( info.ID, info.Level, info.SubLevel  );
	info.AdditionalName = class'UIDATA_SKILL'.static.GetEnchantName( info.ID, info.Level, info.SubLevel );

	class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".ClanSkillWnd", info );
}

function ReplaceSkill( int index, ItemID cID, int level )
{
	local ItemInfo info;

	info.ID = cID;
	info.Level = level;
	info.Name = class'UIDATA_SKILL'.static.GetName( info.ID, info.Level, info.SubLevel );
	info.IconName = class'UIDATA_SKILL'.static.GetIconName( info.ID, info.Level, info.SubLevel );
	info.Description = class'UIDATA_SKILL'.static.GetDescription( info.ID, info.Level, info.SubLevel  );
	info.AdditionalName = class'UIDATA_SKILL'.static.GetEnchantName( info.ID, info.Level, info.SubLevel );

	class'UIAPI_ITEMWINDOW'.static.SetItem( m_WindowName$".ClanSkillWnd", index, info );
}

// oxyzen added ���ͱ��� �̸� ��������
function string getClanOrderString(int gradeID)
{
	local int stringIndex;
	stringIndex = -1;
	if( gradeID == CLAN_MAIN )
		stringIndex = 1399;
	else if( gradeID == CLAN_KNIGHT1 )
		stringIndex = 1400;
	else if( gradeID == CLAN_KNIGHT2 )
		stringIndex = 1401;
	else if( gradeID == CLAN_KNIGHT3 )
		stringIndex = 1402;
	else if( gradeID == CLAN_KNIGHT4 )
		stringIndex = 1403;
	else if( gradeID == CLAN_KNIGHT5 )
		stringIndex = 1404;
	else if( gradeID == CLAN_KNIGHT6 )
		stringIndex = 1405;
	else if( gradeID == CLAN_ACADEMY )
		stringIndex = 1419;

	if( stringIndex != -1 )
		return GetSystemString( stringIndex );
	else 
		return "";

}


// function reset ���� ���� by oxyzen
function reset_clan_org()
{
	local int i;
	for ( i=0; i < CLAN_KNIGHTHOOD_COUNT; ++i)
	{
		Clan3_OrgIcon[i].HideWindow();
		Clan3_OrgIcon[i].DisableWindow();
		Clan3_OrgIcon[i].SetTooltipCustomType(SetTooltip(""));
	}
}


// ��ī�������Ϳ������ ���� ������ �𽺿��̺�
function disableAcademyAuth()
{
	//debug("I have done2");
	//���ͱ���: ���Ͱ���, ȣĪ����, �������, ��������, ��������, ���屭��, ��ް���, �����Ͱ���
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check100", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check101", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check102", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check106", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check104", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check105", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check107", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check108", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check109", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check110", true );

	//����Ʈ����: �߹����, ��ɼ���, �����Ű�
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check200", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check203", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check204", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check205", true );

	//������: �߹����, �������, ���ݰ���, ���������, �뺴����, ��ɼ���
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check300", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check303", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check302", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check305", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check306", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check307", true );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check308", true );
}

// ��į���� ���Ϳ��� ����� �ƴ� ��� �ٽ� �̳��̺� Ȥ�� ����;
function resetAcademyAuth()
{
	//���ͱ���: ���Ͱ���, ȣĪ����, �������, ��������, ��������, ���屭��, ��ް���, �����Ͱ���
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check100", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check101", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check102", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check106", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check104", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check105", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check107", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check108", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check109", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check110", false );
	//����Ʈ����: �߹����, ��ɼ���, �����Ű�
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check200", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check203", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check204", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check205", false );

	//������: �߹����, �������, ���ݰ���, ���������, �뺴����, ��ɼ�?
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check300", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check303", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check302", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check305", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check306", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check307", false );
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName$".Clan6_Check308", false );
}

function int getCurrentGradebyClanType()
{
	local int GradeNum;
	switch(m_clanType)
	{
		case CLAN_MAIN:
		GradeNum = 6;
		break;
		case CLAN_KNIGHT1:
		GradeNum = 7;
		break;
		case CLAN_KNIGHT2:
		GradeNum = 7;
		break;
		case CLAN_KNIGHT3:
		GradeNum = 8;
		break;
		case CLAN_KNIGHT4:
		GradeNum = 8;
		break;
		case CLAN_KNIGHT5:
		GradeNum = 8;
		break;
		case CLAN_KNIGHT6:
		GradeNum = 8;
		break;
		case CLAN_ACADEMY:
		GradeNum = 9;
		break;
	}
	return GradeNum;
}

function CustomTooltip SetTooltip(string Text)
{
	local CustomTooltip Tooltip;
	local DrawItemInfo info;
	
	Tooltip.MinimumWidth = 144;
	Tooltip.DrawList.Length = 1;
	
	info.eType = DIT_TEXT;
	info.t_color.R = 178;
	info.t_color.G = 190;
	info.t_color.B = 207;
	info.t_color.A = 255;
	info.t_strText = Text;
	Tooltip.DrawList[0] = info;

	return Tooltip;
}

function int GetClanTypeFromIndex( int index )
{
	local int type;
	if( index == 0 )
	{
		type = CLAN_MAIN;
	}
	if( index == 1 )
	{
		type = CLAN_KNIGHT1;
	}
	if( index == 2 )
	{
		type = CLAN_KNIGHT2;
	}
	if( index == 3 )
	{
		type = CLAN_KNIGHT3;
	}
	if( index == 4 )
	{
		type = CLAN_KNIGHT4;
	}
	if( index == 5 )
	{
		type = CLAN_KNIGHT5;
	}
	if( index == 6 )
	{
		type = CLAN_KNIGHT6;
	}
	if( index == 7 )
	{
		type = CLAN_ACADEMY;
	}
	return type;
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( m_WindowName ).HideWindow();
}

defaultproperties
{
     m_WindowName="ClanDrawerWnd"
     m_ClanPledgeBonusDrawerWndName="ClanPledgeBonusDrawerWnd"
}
