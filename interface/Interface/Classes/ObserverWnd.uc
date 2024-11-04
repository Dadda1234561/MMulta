//-------------------------------------------------------------------------------------------------------------------------------
//
// 공성전 옵저빙 모드
// 중계탑에서 들어감.
// GamingState 에서 작동됨. 별도 스테이트는 아님
//
//-------------------------------------------------------------------------------------------------------------------------------
class ObserverWnd extends UICommonAPI;

var bool m_bObserverMode;

function OnRegisterEvent()
{
	RegisterEvent( EV_ObserverWndShow );
	RegisterEvent( EV_ObserverWndHide );
	RegisterEvent( EV_GamingStateEnter );
}

function OnLoad()
{
	m_bObserverMode = false;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_ObserverWndShow :
			//Debug("show---" @ GetGameStateName());
			m_bObserverMode = true;
			ShowWindow("ObserverWnd");
			// End:0x7A
			break;
		case EV_ObserverWndHide :
			//Debug("hide---" @ GetGameStateName());
			m_bObserverMode = false;
			HideWindow("ObserverWnd");
			// End:0x7A
			break;
		case EV_GamingStateEnter :
			// End:0x74
			if(m_bObserverMode)
			{
				ShowWindow("ObserverWnd");
			}
			break;
	}
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "BtnEnd":
			RequestObserverModeEnd();
			break;
	}
}

defaultproperties
{
}
