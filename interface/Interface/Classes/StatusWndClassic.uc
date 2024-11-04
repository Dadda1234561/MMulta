//================================================================================
// StatusWndClassic.
//================================================================================

class StatusWndClassic extends StatusWnd;

event OnLoad()
{
	InitHandleCOD();
	bFirstUpdate = false;
	GlobalAlpha = 0;
	GlobalAlphaBool = true;
	InitAnimation();
	MaxVitality = GetMaxVitality();
	nCombatOnOff = 0;
	CombatIcon_Tex.SetTooltipCustomType(combatTooltip());	
}

event OnEvent(int a_EventID, string a_Param)
{
	// End:0x23
	if(getInstanceUIData().getIsClassicServer())
	{
		EachServerEvent(a_EventID, a_Param);
	}
}

defaultproperties
{
     m_WindowName="StatusWndClassic"
}
