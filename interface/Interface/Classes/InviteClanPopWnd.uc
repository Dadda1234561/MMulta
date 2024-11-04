class InviteClanPopWnd extends UICommonAPI;

const SHOW_TYPE_ClanWnd                          = 1;
const SHOW_TYPE_PersonalConnectionsWnd           = 2;
const SHOW_TYPE_PersonalConnectionsWndByUserName = 3;

var string m_userName;
var array<int>	m_knighthoodIndex;

var int showType;

var WindowHandle  Me;

// �θ� �������� ȣ���� ���� ����
var int friendServerID, friendClanType;
var string targetUserName;

function OnRegisterEvent()
{
	registerEvent( EV_GamingStateExit );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	Me = GetWindowHandle("InviteClanPopWnd");


	m_knighthoodIndex.Length = CLAN_KNIGHTHOOD_COUNT;
	m_knighthoodIndex[0] = 0;
	m_knighthoodIndex[1] = 100;
	m_knighthoodIndex[2] = 200;
	m_knighthoodIndex[3] = 1001;
	m_knighthoodIndex[4] = 1002;
	m_knighthoodIndex[5] = 2001;
	m_knighthoodIndex[6] = 2002;
	m_knighthoodIndex[7] = -1;
}

function OnShow()
{
	
}


// ���� â���� �����ʴ�
function showByClanWnd()
{
	Me.ShowWindow();
	showType = SHOW_TYPE_ClanWnd;
	InitializeComboBox();
}

// �θư��� ���� �����ʴ� (��� ���ҵ�.. �Ʒ� �̸����� �߰� �ϴ� �Լ��� �־)
function showByPersonalConnectionsWnd(int serverID)
{
	// Debug("�� ����@");
	Me.ShowWindow();

	showType = SHOW_TYPE_PersonalConnectionsWnd;
	friendServerID = serverID;

	InitializeComboBox();
}

// �θư��� ���� �����ʴ�, ���� �̸��� ���
function showByPersonalConnectionsWndUsingUserName(string userName)
{
	// Debug("�� ����@" @ userName);
	Me.ShowWindow();

	showType = SHOW_TYPE_PersonalConnectionsWndByUserName;
	targetUserName = userName;

	InitializeComboBox();
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
		case EV_GamingStateExit:
			class'UIAPI_WINDOW'.static.HideWindow("InviteClanPopWnd");
			break;
		
		default:
			break;
	}
}

function OnClickButton( string strID )
{
	if( strID == "InviteClandPopOkBtn" )
	{
//		Debug("showType" @ showType);
		if (showType == SHOW_TYPE_PersonalConnectionsWnd)
		{
			AskJoinByPersonalConnectionsWnd();
		}
		else if (showType == SHOW_TYPE_PersonalConnectionsWndByUserName)
		{
			AskJoinByPersonalConnectionsWndByUserName();
		}
		else
		{
			AskJoin();
		}
		class'UIAPI_WINDOW'.static.HideWindow("InviteClanPopWnd");
	}
	else if( strID == "InviteClandPopCancelBtn" )
	{
		class'UIAPI_WINDOW'.static.HideWindow("InviteClanPopWnd");
	}
}

/** ���� â���� �ʴ��� ��� - Ÿ�� ���̽� */
function AskJoin()
{
	local UserInfo user;
	local int	index;
	local int	knighthoodID;

	if( GetTargetInfo( user ) )
	{
		if( user.nID > 0 )
		{
			index = class'UIAPI_COMBOBOX'.static.GetSelectedNum("InviteClanPopWnd.ComboboxInviteClandPopWnd");
			if( index >= 0 )
			{
				knighthoodID = class'UIAPI_COMBOBOX'.static.GetReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", index);

				//debug("AskJoin : id " $ user.nID $ " name " $ user.Name $ " clanType " $ knighthoodID );
				RequestClanAskJoin( user.nID, knighthoodID );
			}
		}
	}
}

/** �θ� �ʿ��� �ʴ��� ��� - ������ ĳ���� ���� ���̵�� �Ÿ� ��� ���� */
function AskJoinByPersonalConnectionsWnd()
{
	// local UserInfo user;
	local int	index;
	local int	knighthoodID;
	
	if (friendServerID > 0)
	{

		index = class'UIAPI_COMBOBOX'.static.GetSelectedNum("InviteClanPopWnd.ComboboxInviteClandPopWnd");
		if( index >= 0 )
		{
			knighthoodID = class'UIAPI_COMBOBOX'.static.GetReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", index);

			//debug("AskJoin : id " $ user.nID $ " name " $ user.Name $ " clanType " $ knighthoodID );
			//Debug("knighthoodID" @knighthoodID);
			RequestClanAskJoin( friendServerID, knighthoodID );
		}
	}
}

/** �θ� �ʿ��� �ʴ��� ��� - ������ ĳ���� ���� ���̵�� �Ÿ� ��� ���� */
function AskJoinByPersonalConnectionsWndByUserName()
{
	// local UserInfo user;
	local int	index;
	local int	knighthoodID;
	
	index = class'UIAPI_COMBOBOX'.static.GetSelectedNum("InviteClanPopWnd.ComboboxInviteClandPopWnd");
	if( index >= 0 )
	{
		knighthoodID = class'UIAPI_COMBOBOX'.static.GetReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", index);
		// �̸� ���� Ŭ���� ���� �ϵ��� �ϴ� �Լ�, Ŭ��: ������ �߰� ����			
		RequestClanAskJoinByName(targetUserName, knighthoodID);
	}
}


function InitializeComboBox()
{
	local int i;
	local ClanWndClassicNew script;
	local int addedCount;
	local string countnum;
	local string countnum2;
	local int cnt1;
	local int cnt2;
	local string m_sName;

	class'UIAPI_COMBOBOX'.static.Clear("InviteClanPopWnd.ComboboxInviteClandPopWnd");
	script = ClanWndClassicNew( GetScript("ClanWndClassicNew") );
	countnum2 = "" $ script.m_myClanType;
	cnt1 = len(countnum2);

	for( i=0 ; i < CLAN_KNIGHTHOOD_COUNT ; ++i )
	{
		countnum = "" $ m_knighthoodIndex[i];
		m_sName = script.m_memberList[i].m_sName;
		//debug(countnum);
		cnt2 = len(countnum);

		//Debug( "InitializeComboBox1:" @ i @ "/" $ script.m_memberList[i].m_sName $ "/" ) ;

		if( m_sName != "" )
		{
			//Debug ( "InitializeComboBox2:" @ i @ "/" $ script.m_memberList[i].m_sName $ "/" );
			if ( m_knighthoodIndex[i] == -1 )
			{
				class'UIAPI_COMBOBOX'.static.AddStringWithReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", m_sName, m_knighthoodIndex[i] );
				++addedCount;
			}
			else if (cnt1 <= cnt2)
			{
				class'UIAPI_COMBOBOX'.static.AddStringWithReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", m_sName, m_knighthoodIndex[i] );
				++addedCount;
			}
		}
	}
	if( addedCount > 0 )
		class'UIAPI_COMBOBOX'.static.SetSelectedNum("InviteClanPopWnd.ComboboxInviteClandPopWnd", 0);		// ���� ó�� �������� ���̵���
}

defaultproperties
{
}
