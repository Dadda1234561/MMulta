//================================================================================
// SummonedStatusWndClassic.
//================================================================================

class SummonedStatusWndClassic extends SummonedStatusWnd;

function OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().getIsClassicServer())
	{
		EachServerEvent(Event_ID, param);
	}
}

function OnEnterState(name a_CurrentStateName)
{
	if(getInstanceUIData().getIsClassicServer())
	{
		EachServerEnterState(a_CurrentStateName);
	}
}

function SetBuffButtonTooltip()
{
	local Color b1;
	local Color b2;
	local Color b3;
	local Color b4;
	local array<DrawItemInfo> drawListArr;

	b1 = getInstanceL2Util().Gray;
	b2 = getInstanceL2Util().Gray;
	b3 = getInstanceL2Util().Gray;
	b4 = getInstanceL2Util().Gray;

	if(m_CurBf == 0)
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbutton_off", "L2ui_CH3.PartyWnd.party_buffbutton_off", "L2ui_CH3.PartyWnd.party_buffbutton_off");
	}
	else
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf), "L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf), "L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf));
	}
	switch(m_CurBf)
	{
		case 0:
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
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1496) $ "/" $ GetSystemString(1497),b1,"",True,True);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1741),b2,"",True,True);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13440),b3,"",True,True);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2307),b4,"",True,True);
	btnBuff.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y);

defaultproperties
{
     MAX_BUFF_ICONTYPE=4
     m_WindowName="SummonedStatusWndClassic"
}
