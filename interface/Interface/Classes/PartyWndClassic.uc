class PartyWndClassic extends PartyWnd;

function OnEvent (int Event_ID, string param)
{
	if ( getInstanceUIData().getIsClassicServer() )
	{
		EachServerEvent(Event_ID,param);
	}
}

function OnEnterState (name a_CurrentStateName)
{
	if ( getInstanceUIData().getIsClassicServer() )
	{
		EachServerEnterState(a_CurrentStateName);
	}
}

function SetBuffButtonTooltip ()
{
	local Color b1;
	local Color b2;
	local Color b3;
	local Color b4;
	local Color b5;
	local Color b6;
	local array<DrawItemInfo> drawListArr;

	b1 = getInstanceL2Util().Gray;
	b2 = getInstanceL2Util().Gray;
	b3 = getInstanceL2Util().Gray;
	b4 = getInstanceL2Util().Gray;
	b5 = getInstanceL2Util().Gray;
	b6 = getInstanceL2Util().Gray;
	if ( m_CurBf == 0 )
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbuttonClassic_6","L2ui_CH3.PartyWnd.party_buffbuttonClassic_6","L2ui_CH3.PartyWnd.party_buffbuttonClassic_6");
	}
	else
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbuttonClassic_" $ string(m_CurBf),"L2ui_CH3.PartyWnd.party_buffbuttonClassic_" $ string(m_CurBf),"L2ui_CH3.PartyWnd.party_buffbuttonClassic_" $ string(m_CurBf));
	}
	switch (m_CurBf)
	{
		case 0:
			b6 = getInstanceL2Util().Yellow;
			break;
		case 1:
			b1 = getInstanceL2Util().Yellow;
			break;
		case 2:
			b2 = getInstanceL2Util().Yellow;
			break;
		case 3:
			b3 = getInstanceL2Util().Yellow;
			break;
		case 4:
			b4 = getInstanceL2Util().Yellow;
			break;
		case 5:
			b5 = getInstanceL2Util().Yellow;
			break;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1496), b1, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1497), b2, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1741), b3, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13440), b4, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2307), b5, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(228), b6, "", true, true);
	btnBuff.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function UpdateBuff ()
{
	local int idx;

	if ( m_CurBf == 1 )
	{
		for ( idx = 0;idx < 10; idx++ )
		{
			m_StatusIconBuff[idx].ShowWindow();
			m_PetStatusIconBuff[idx].ShowWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
		}
	}
	else if ( m_CurBf == 2 )
	{
		for ( idx = 0;idx < 10; idx++ )
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].ShowWindow();
			m_PetStatusIconDeBuff[idx].ShowWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
		}
	}
	else if ( m_CurBf == 3 )
	{
		for ( idx = 0;idx < 10; idx++ )
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].ShowWindow();
			m_PetStatusIconSongDance[idx].ShowWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
		}
	}
	else if ( m_CurBf == 4 )
	{
		for ( idx = 0;idx < 10; idx++ )
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconItem[idx].ShowWindow();
			m_PetStatusIconItem[idx].ShowWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
		}
	}
	else if ( m_CurBf == 5 )
	{
		for ( idx = 0;idx < 10; idx++ )
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].ShowWindow();
			m_PetStatusIconTriggerSkill[idx].ShowWindow();
		}
	}
	else
	{
		for ( idx = 0;idx < 10; idx++ )
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
		}
	}
}

defaultproperties
{
	DEFAULT_NPARTYSTATUS_HEIGHT=61
	DEFAULT_NPARTYPETSTATUS_HEIGHT=25
	DEFAULT_STATUS_GAP=0
	m_WindowName="PartyWndClassic"
	MAX_BUFF_ICONTYPE=5
}
