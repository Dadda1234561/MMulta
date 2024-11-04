//================================================================================
// QuestBtnWnd.
// emu-dev.ru
//================================================================================
class QuestBtnWnd extends UICommonAPI;

var bool m_bArriveShowQuest;
var int m_iEffectNumber;

function OnRegisterEvent()
{
}

function OnLoad()
{
	if(CREATE_ON_DEMAND == 0)
	{
		OnRegisterEvent();
	}
}

function OnEvent(int Event_ID, string param)
{
	ParseInt(param, "QuestID", m_iEffectNumber);

	switch(Event_ID)
	{
		case EV_ArriveShowQuest:
			ShowWindowWithFocus("QuestBtnWnd");
			class'UIAPI_WINDOW'.static.ShowWindow("QuestBtnWnd.btnQuest");
			class'UIAPI_EFFECTBUTTON'.static.BeginEffect("QuestBtnWnd.btnQuest", m_iEffectNumber);
			m_bArriveShowQuest = true;
			break;
	}
}

function OnEnterState(name a_CurrentStateName)
{
	m_bArriveShowQuest = false;
	m_iEffectNumber = 0;
}

function OnExitState(name a_CurrentStateName)
{
	if(m_bArriveShowQuest && a_CurrentStateName == 'NpcZoomCameraState')
	{
		ShowWindowWithFocus("QuestBtnWnd");
		class'UIAPI_WINDOW'.static.ShowWindow("QuestBtnWnd.btnQuest");
	}
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnQuest":
			HideWindow("QuestBtnWnd");
			m_bArriveShowQuest = false;
			break;
	}
}

defaultproperties
{
}
