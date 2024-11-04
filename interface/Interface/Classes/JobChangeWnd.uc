//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : 전직계보도 - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class JobChangeWnd extends L2UIGFxScript;

var int InitClassID;
var int CurrentSubjobClassID;
var int targetCurrentSubjobClassID;

function OnRegisterEvent()
{	
	// 5310
	//RegisterGFxEvent(EV_NotifySubjob );
	//RegisterGFxEvent(EV_CreatedSubjob);
	//RegisterGFxEvent(EV_ChangedSubjob);
	RegisterEvent(EV_NotifySubjob );
	RegisterEvent(EV_CreatedSubjob);
	RegisterEvent(EV_ChangedSubjob);
	// registerEvent( EV_TargetUpdate );
}

function onEvent(int a_EventID, String a_Param)
{
	local NoticeWnd m_NoticeWnd ; 

	switch (a_EventID)
	{
		// 알림닫기 -> 전직닫기 -> 전직가능성 request() ;
		case EV_NotifySubjob :
		case EV_CreatedSubjob :
		case EV_ChangedSubjob :
			m_NoticeWnd = NoticeWnd(GetScript ( "NoticeWnd" ));
			m_NoticeWnd.removeNoticeButton(	m_NoticeWnd.ENoticeType.TYPE_CHANGE_CLASS );
			// End:0x95
			if(! IsPlayerOnWorldRaidServer())
			{
				CallGFxFunction("JobChangeWnd", "RequestClassChangeVerifying", "");
			}
			break;
	}
}

function OnLoad()
{
	AddState( "GAMINGSTATE" );
	SetContainerWindow(WINDOWTYPE_DECO_NORMAL, 1795);
	// SetDefaultShow ( true ) ;
}

defaultproperties
{
}
