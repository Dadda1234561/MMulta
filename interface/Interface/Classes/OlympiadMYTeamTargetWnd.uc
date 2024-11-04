//================================================================================
// OlympiadMYTeamTargetWnd.
//================================================================================

class OlympiadMYTeamTargetWnd extends OlympiadTargetWnd;

function OnLoad ()
{
	local int i;

	Me = GetWindowHandle(m_WindowName);
	
	for( i = 0; i < 3; i++ )
	{
		m_TargetWnd[i] = GetWindowHandle(m_WindowName $ ".TargetWnd" $ string(i));
		m_BarCP[i] = GetBarHandle(m_WindowName $ ".TargetWnd" $ string(i) $ ".barcp");
		m_BarHP[i] = GetBarHandle(m_WindowName $ ".TargetWnd" $ string(i) $ ".barhp");
		m_PlayerName[i] = GetNameCtrlHandle(m_WindowName $ ".TargetWnd" $ string(i) $ ".PlayerName");
		StatusIcon[i] = GetStatusIconHandle(m_WindowName $ ".TargetWnd" $ string(i) $ ".BuffWnd");
	}
}

function HandleUserInfo (string param)
{
	local int IsPlayer;
	local int PlayerNum;
	local int i;
	local int m_UserInfoIdx;
	local int MyTeamNum;
	local UserInfo myInfo;

	ParseInt(param,"IsPlayer",IsPlayer);
	ParseInt(param,"TotalCount",m_TotalCount);
	ParseInt(param,"MyTeamNum",MyTeamNum);
	GetPlayerInfo(myInfo);
	if ( IsPlayer != 0 )
	{
		return;
	}
	if ( m_TotalCount <= 2 )
	{
		return;
	}
	m_TeamCount = 0;
	m_UserInfoIdx = 0;
	
	for ( i = 0;i < m_TotalCount;i++ )
	{
		ParseInt(param,"PlayerNum_" $ string(i),PlayerNum);
		if ( PlayerNum == MyTeamNum )
		{
			m_TeamCount++;
		}
		else
		{
			continue;
		}
		ParseInt(param,"ID_" $ string(i),m_id[m_UserInfoIdx]);
		ParseString(param,"Name_" $ string(i),m_name[m_UserInfoIdx]);
		if ( myInfo.Name == m_name[m_UserInfoIdx] )
		{
			continue;
		}
		ParseInt(param,"ClassID_" $ string(i),m_ClassID[m_UserInfoIdx]);
		ParseInt(param,"MaxHP_" $ string(i),m_MaxHP[m_UserInfoIdx]);
		ParseInt(param,"CurHP_" $ string(i),m_CurHP[m_UserInfoIdx]);
		ParseInt(param,"MaxCP_" $ string(i),m_MaxCP[m_UserInfoIdx]);
		ParseInt(param,"CurCP_" $ string(i),m_CurCP[m_UserInfoIdx]);
		m_UserInfoIdx++;
	}
	if ( m_TeamCount - 1 <= 0 )
	{
		Me.HideWindow();
	} else {
		ShowWindowCtrl(m_TeamCount - 1);
	}
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

	ParseInt(param,"PlayerID",Id);
	i = findID(Id);
	if ( i != -1 )
	{
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
				{
					continue;
				}
				if ( Class'UIDATA_SKILL'.static.IsToppingSkill(Info.Id,Info.Level,Info.SubLevel) )
				{
					continue;
				}
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
	}
}

function UpdateStatus ()
{
	local int i;

	for ( i = 0;i < m_TeamCount;i++ )
	{
		m_PlayerName[i].SetName(m_name[i],NCT_Normal,TA_Center);
		m_PlayerName[i].SetNameWithColor(m_name[i],NCT_Normal,TA_Center,getInstanceL2Util().Yellow);
		if ( m_MaxCP[i] > 0 )
		{
			m_BarCP[i].SetValue(m_MaxCP[i],m_CurCP[i]);
		} else {
			m_BarCP[i].SetValue(0,0);
		}
		if ( m_MaxHP[i] > 0 )
		{
			m_BarHP[i].SetValue(m_MaxHP[i],m_CurHP[i]);
		} else {
			m_BarHP[i].SetValue(0,0);
		}
	}
}

defaultproperties
{
	m_WindowName="OlympiadMYTeamTargetWnd"
}
