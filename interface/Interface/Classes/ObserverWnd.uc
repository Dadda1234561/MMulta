//-------------------------------------------------------------------------------------------------------------------------------
//
// ������ ������ ���
// �߰�ž���� ��.
// GamingState ���� �۵���. ���� ������Ʈ�� �ƴ�
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
