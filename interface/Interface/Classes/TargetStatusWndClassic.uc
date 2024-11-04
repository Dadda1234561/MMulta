//================================================================================
// TargetStatusWndClassic.
//================================================================================

class TargetStatusWndClassic extends TargetStatusWnd;

function OnEvent(int a_EventID, string a_Param)
{
	// End:0x23
	if(getInstanceUIData().getIsClassicServer())
	{
		EachServerEvent(a_EventID, a_Param);
	}
}

function OnEnterState(name a_CurrentStateName)
{
	// End:0x1E
	if(getInstanceUIData().getIsClassicServer())
	{
		EachSeverEnterState(a_CurrentStateName);
	}
}

defaultproperties
{
     m_WindowName="TargetStatusWndClassic"
}
