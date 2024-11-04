class ClanSearch extends L2UIGFxScript;

var int clanID;

function OnRegisterEvent()
{
	//����� ����Ʈ �ޱ�  9620
	RegisterGFxEvent( EV_PledgeDraftListStart );
	//����� ����Ʈ ������ 9621
	RegisterGFxEvent( EV_PledgeDraftListItem );
	//���� ����ڸ���Ʈ 9600
	RegisterGFxEvent( EV_PledgeWaitingListStart );
	//���� ����ڸ���Ʈ 9601
	RegisterGFxEvent( EV_PledgeWaitingListItem );

	//�˻���� 
	RegisterGFxEvent( EV_PledgeRecruitBoardStart );
	//�˻���������� 9581
	RegisterGFxEvent( EV_PledgeRecruitBoardItem );
	//����������û��� 9590
	RegisterGFxEvent( EV_PledgeRecruitBoardDetail );
	//���� ���� �ޱ� 9582
	RegisterGFxEvent( EV_PledgeRecruitInfo );
	//���� ���� �ޱ� 9583
	RegisterGFxEvent( EV_PledgeRecruitInfoItem );
	//���� ��û �޸� �ޱ� 9610
	RegisterGFxEvent( EV_PledgeWaitingUser );
	//���� ��û ��ȸ 9591
	RegisterGFxEvent( EV_PledgeWaitingListApplied );
	//���� ��û ���� ��ȸ 9640
	RegisterGFxEvent( EV_PledgeRecruitApplyInfo );

	//Ŭ������ 340
	RegisterGFxEvent( EV_ClanMyAuth );
	RegisterGFxEvent( EV_GFX_ClanMyAuth ); //               = 10520;

	//���� �̸���.. ���� 430
	RegisterGFxEvent( EV_ClanMemberInfo );
	RegisterGFxEvent( EV_GFX_ClanMemberInfoUpdate ); //     = 10510;

	//�����ӽ� ��������
	RegisterGFxEvent( EV_Restart );

	// ���� ���� ���θ� ����.
	//RegisterGFxEvent( EV_PledgeSigninForOpenJoiningMethod );

	// ���� Ż �� �� ������ �̺�Ʈ �� 420
	RegisterGFxEvent( EV_ClanDeleteAllMember );
	RegisterGFxEvent( EV_GFX_ClanDeleteAllMember ); //      = 10470;
}

function onShow() 
{
	getInstanceL2Util().checkIsPrologueGrowType ( string(self) );
}

function OnLoad()
{	
	SetSaveWnd(True,False);
	//registerState( "ClanSearch", "GamingState" );	
	// ��� �����̳ʿ� ���� ���� ����
	//SetContainer( "ContainerWindow" );
	SetContainerWindow(WINDOWTYPE_DECO_NORMAL, 3068);
	AddState("GAMINGSTATE");
	AddState("ARENAGAMINGSTATE");
	
	//setDefaultShow(true);
}

function onCallUCFunction( string functionName, string param )
{
	//Debug("sampe's onCallUCFunction" @ functionName @ param);
	switch ( functionName ) 
	{
		case "getClanID" :
			getClanID();
		break;
		case "sendPost":
			sendPost(param);
		break;
		case "whisperToUser":
			whisperToUser(param);
		break;
		case "askJoin":
			askJoin(param);
		break;
		
	}
}

//Ŭ�����̵� �������
function getClanID() 
{
	local UserInfo userinfo;
	//local string names;

	if( GetPlayerInfo( userinfo ) )
	{	
		//names = userinfo.Name;
		clanID = userinfo.nClanID;
		//callGFxFunction( "ClanSearch", "getClanID", clanID);
		//callGFxFunction( "ClanSearch", "getClanID", "ClanID="$clanID@"Name="$names@"");
	}
}

//���� �߼�
function sendPost(string userName)
{
	local PostBoxWnd postBoxWndScript;
	local PostWriteWnd postWriteWndScript;

	if (userName != "")
	{
		// ���� â�� ���� �ش� �̸��� �ְ� ������ ������ �Ѵ�.
		postBoxWndScript = PostBoxWnd(GetScript("PostBoxWnd"));	
		postWriteWndScript = PostWriteWnd(GetScript("PostWriteWnd"));	

		postBoxWndScript.OnClickButton("PostSendBtn");
		postWriteWndScript.toWrite(userName);
	}	
}

//�ӼӸ��ϱ�
function whisperToUser(string userName)
{
	local ChatWnd chatWndScript;
	if (userName != "")
	{
		//callGFxFunction("ChatMessage", "sendWhisper", userName);
		//Ŭ���� �ӼӸ� Ȯ��
		chatWndScript = ChatWnd(GetScript("ChatWnd"));
		chatWndScript.SetChatEditBox("\"" $ userName $ " ");
	}
}
function askJoin(string userID)
{
	local int nID;
	local InviteClanPopWnd InviteClanPopWndScript;
	nID = int(userID);

	if( nID > 0 )
	{
		if ( getInstanceUIData().getIsClassicServer() ) 
		{	
			ClanWndClassicNew(GetScript("ClanWndClassicNew")).askJoin();
		}
		else 
		{
			InviteClanPopWndScript = InviteClanPopWnd( GetScript("InviteClanPopWnd" ) );
			InviteClanPopWndScript.showByClanWnd();
		}
	}
}

defaultproperties
{
}
