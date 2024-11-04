class OlympiadTargetWnd extends UICommonAPI;

const MAX_OLYMPIAD_USER_NUM = 3;

var WindowHandle Me;

var WindowHandle		m_TargetWnd[MAX_OLYMPIAD_USER_NUM];
var BarHandle			m_BarCP[MAX_OLYMPIAD_USER_NUM];
var BarHandle			m_BarHP[MAX_OLYMPIAD_USER_NUM];
var NameCtrlHandle		m_PlayerName[MAX_OLYMPIAD_USER_NUM];
var StatusIconHandle	StatusIcon[MAX_OLYMPIAD_USER_NUM];

var int		m_PlayerNum;

var int		m_ID[MAX_OLYMPIAD_USER_NUM];
var string		m_Name[MAX_OLYMPIAD_USER_NUM];
var int		m_ClassID[MAX_OLYMPIAD_USER_NUM];
var int		m_MaxHP[MAX_OLYMPIAD_USER_NUM];
var int		m_CurHP[MAX_OLYMPIAD_USER_NUM];
var int		m_MaxCP[MAX_OLYMPIAD_USER_NUM];
var int		m_CurCP[MAX_OLYMPIAD_USER_NUM];
var int		m_TotalCount;
var int		m_TeamCount;
var string	m_WindowName;

function OnRegisterEvent()
{
	RegisterEvent( EV_OlympiadTargetShow );
	RegisterEvent( EV_OlympiadUserInfo );
	RegisterEvent( EV_OlympiadMatchEnd );
	RegisterEvent( EV_OlympiadBuffInfo );
}

function OnLoad ()
{
	local int i;

	Me = GetWindowHandle(m_WindowName);
	for (i = 0; i < MAX_OLYMPIAD_USER_NUM; i++)
	{
		m_TargetWnd[i] = GetWindowHandle(m_WindowName $ ".TargetWnd" $ i);
		m_BarCP[i] = GetBarHandle(m_WindowName $ ".TargetWnd" $ i $ ".barcp");
		m_BarHP[i] = GetBarHandle(m_WindowName $ ".TargetWnd" $ i $ ".barhp");
		m_PlayerName[i] = GetNameCtrlHandle(m_WindowName $ ".TargetWnd" $ i $ ".PlayerName");
		StatusIcon[i] = GetStatusIconHandle(m_WindowName $ ".TargetWnd" $ i $ ".BuffWnd");
	}
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_OlympiadTargetShow)
	{
		Clear();
//		debug("플레이어NUM" $m_PlayerNum);
		//플레이어NUM
		Parseint(param, "PlayerNum", m_PlayerNum);
		
	}
	else if (Event_ID == EV_OlympiadUserInfo)
	{
	//	debug("여기넘어오니??");
		HandleUserInfo(param);
		UpdateStatus();
	}
	else if (Event_ID == EV_OlympiadMatchEnd)
	{
		Clear();
		HideAllWindow();
	}
	else if ( Event_ID == EV_OlympiadBuffInfo )
	{
		Debug("EV_OlympiadBuffInfo-->" @ param);
		HandleBuffInfo(param);
	}
}

function OnEnterState( name a_CurrentStateName )
{
	Clear();
}

//초기화
function Clear()
{
	local int i;
	m_PlayerNum = 0;
	
	for (i =0; i < MAX_OLYMPIAD_USER_NUM; i++)
	{
		m_ID[i] = 0;
		m_Name[i] = "";
		m_ClassID[i] = 0;
		m_MaxHP[i] = 0;
		m_CurHP[i] = 0;
		m_MaxCP[i] = 0;
		m_CurCP[i] = 0;
	}
	
	UpdateStatus();
	HideAllWindow();


}

//UserInfo설정
function HandleUserInfo(string param)
{
	local int IsPlayer;
	local int PlayerNum;
	local int i;
	local int m_UserInfoIdx;
	local int MyTeamNum;
	
	//debug("param : " $ param);
	
	//Observer모드에서의 플레이어 정보 패킷이면 패스


	ParseInt(param, "IsPlayer", IsPlayer);

	
	if (IsPlayer != 0)
	{
//		debug("짠짠짠1"$IsPlayer);
		return;
	}
	ParseInt(param, "TotalCount", m_TotalCount); //플레이어 숫자
	ParseInt(param, "MyTeamNum", MyTeamNum);	 // 현재 나의 팀 번호

	m_TeamCount = 0;
	m_UserInfoIdx = 0;
	for (i = 0; i < m_TotalCount; i++)
	{		
		//표시하고자 하는 타겟의 PlayerNum이 아니면 패스
		ParseInt(param, "PlayerNum_" $ string(i), PlayerNum);
		if (PlayerNum != m_PlayerNum)
			continue;

		m_TeamCount++;

		ParseInt(param, "ID_" $ string (i), m_ID[m_UserInfoIdx]);
		ParseString(param, "Name_" $ string (i), m_Name[m_UserInfoIdx]);
		ParseInt(param, "ClassID_" $ string (i), m_ClassID[m_UserInfoIdx]);
		ParseInt(param, "MaxHP_" $ string (i), m_MaxHP[m_UserInfoIdx]);
		ParseInt(param, "CurHP_" $ string (i), m_CurHP[m_UserInfoIdx]);
		ParseInt(param, "MaxCP_" $ string (i), m_MaxCP[m_UserInfoIdx]);
		ParseInt(param, "CurCP_" $ string (i), m_CurCP[m_UserInfoIdx]);
//		debug("ID"$m_ID[m_UserInfoIdx]$	"Name"$m_Name[m_UserInfoIdx]$ "ClassID"$m_ClassID[m_UserInfoIdx]$ "MaxHP"$m_MaxHP[m_UserInfoIdx]$ "CurHP"$m_CurHP[m_UserInfoIdx]$ "MaxCP"$m_MaxCP[m_UserInfoIdx]$ "CurCP"$m_CurCP[m_UserInfoIdx]);

		m_UserInfoIdx++;
	}
	ShowWindowCtrl(m_TeamCount);

}

//Update Info
function UpdateStatus()
{
	//이름
	local int i;
	for (i =0; i < m_TeamCount; i++)
	{
	//	m_Name[i].SetText(m_Name[i]);
		m_PlayerName[i].SetName(m_Name[i], NCT_Normal,TA_Center);
//		class'UIAPI_TEXTBOX'.static.SetText( "OlympiadTargetWnd.txtName", m_Name[i]);
		
		//CP
		if (m_MaxCP[i]>0)
		{
			m_BarCP[i].SetValue (m_MaxCP[i] , m_CurCP[i]);
		}
		else
		{
			m_BarCP[i].SetValue ( 0 , 0);
		}
		
		// HP
		if (m_MaxHP[i]>0)
		{
			m_BarHP[i].SetValue (m_MaxHP[i] , m_CurHP[i]);
		}
		else
		{
			m_BarHP[i].SetValue ( 0 , 0);
		}
	}
		
	/*
	//CP
	if (m_MaxCP>0)
	{
		class'UIAPI_WINDOW'.static.SetWindowSize( "OlympiadTargetWnd.texCP", 150 * m_CurCP / m_MaxCP, 6);
	}
	else
	{
		class'UIAPI_WINDOW'.static.SetWindowSize( "OlympiadTargetWnd.texCP", 0, 6);
	}
	
	//HP
	if (m_MaxHP>0)
	{
		class'UIAPI_WINDOW'.static.SetWindowSize( "OlympiadTargetWnd.texHP", 150 * m_CurHP / m_MaxHP, 6);
	}
	else
	{
		class'UIAPI_WINDOW'.static.SetWindowSize( "OlympiadTargetWnd.texHP", 0, 6);
	}
	*/
}

function HandleBuffInfo (string param)
{
	local int Id;
	local int i;
	local int j;
	local int Max;
	local int CurRow;
	local StatusIconInfo Info;
	local int numOfBuff;
	local Rect rectWnd;
	local Rect mainWnd;

	ParseInt(param,"PlayerID",Id);
	i = findID(Id);
	Debug("HandleBuffInfo-->ID--->i--->" @ string(i));
	if ( i != -1 )
	{
		mainWnd = m_TargetWnd[i].GetRect();
		StatusIcon[i].MoveTo(mainWnd.nX - 7,mainWnd.nY + 5);
		StatusIcon[i].Clear();
		CurRow = -1;
		ParseInt(param,"Max",Max);
		numOfBuff = 0;
		
		for ( j = 0;j < Max; j++ )
		{
			ParseItemIDWithIndex(param,Info.Id,j);
			ParseInt(param,"SkillLevel_" $ string(j),Info.Level);
			ParseInt(param,"SkillSubLevel_" $ string(j),Info.SubLevel);
			if ( GetDebuffType(Info.Id,Info.Level,Info.SubLevel) != 0 )
			{
				if ( IsIconHide(Info.Id,Info.Level,Info.SubLevel) )
					continue;
				if ( Class'UIDATA_SKILL'.static.IsToppingSkill(Info.Id,Info.Level,Info.SubLevel) )
					continue;
				if ( numOfBuff % 12 == 0 )
				{
					StatusIcon[i].AddRow();
					CurRow++;
				}
				ParseInt(param,"RemainTime_" $ string(j),Info.RemainTime);
				ParseInt(param,"SpellerID_" $ string(j),Info.SpellerID);
				ParseString(param,"Name_" $ string(j),Info.Name);
				ParseString(param,"IconName_" $ string(j),Info.IconName);
				ParseString(param,"IconPanel_" $ string(i),Info.IconPanel);
				ParseString(param,"Description_" $ string(j),Info.Description);
				Info.Size = 16;
				Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
				Info.bShow = True;
				Info.bHideRemainTime = True;
				StatusIcon[i].AddCol(CurRow,Info);
				numOfBuff++;
			}
		}
		rectWnd = StatusIcon[i].GetRect();
		StatusIcon[i].MoveTo(rectWnd.nX - rectWnd.nWidth,rectWnd.nY);
	}
}

function int findID (int Id)
{
	local int i;

	for ( i = 0;i < m_TeamCount; i++ )
	{
		if ( Id == m_id[i] )
			return i;
	}
	return -1;
}

function ShowWindowCtrl(int count)
{
	local int i;
	local Rect entireRect;
	entireRect = me.GetRect();

	me.showwindow();
	if (count == 1)
	{
		m_TargetWnd[0].showwindow();
		m_BarCP[0].showwindow();
		m_BarHP[0].showwindow();
		m_PlayerName[0].showwindow();
		for (i =1; i < MAX_OLYMPIAD_USER_NUM; i++)
		{	
			m_TargetWnd[i].hidewindow();
			m_BarCP[i].hidewindow();
			m_BarHP[i].hidewindow();
			m_PlayerName[i].hidewindow();
		}
		//창사이즈 수정2010.06.08
		me.SetWindowSize( entireRect.nWidth, 46 );
	}
	else
	{					
		for (i =0; i < count; i++)
		{	
			m_TargetWnd[i].showwindow();
			m_BarCP[i].showwindow();
			m_BarHP[i].showwindow();
			m_PlayerName[i].showwindow();
		}
	}
	if(count > 1)
	{
		//창사이즈 수정2010.06.08
		me.SetWindowSize( entireRect.nWidth, Count * 50 );
	}
}
function HideAllWindow()
{
	local int i;
	me.hidewindow();
	for (i =0; i < MAX_OLYMPIAD_USER_NUM; i++)
	{	
		m_TargetWnd[i].hidewindow();
		m_BarCP[i].hidewindow();
		m_BarHP[i].hidewindow();
		m_PlayerName[i].hidewindow();
	}
}

defaultproperties
{
     m_WindowName="OlympiadTargetWnd"
}
