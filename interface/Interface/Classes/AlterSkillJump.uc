//------------------------------------------------------------------------------------------------------------------------
//
// ����        : AlterSkillJump   - SCALEFORM UI - 
//
//------------------------------------------------------------------------------------------------------------------------
class AlterSkillJump extends L2UIGFxScript;

function OnRegisterEvent()
{
	registerGfxEvent(EV_NotifyFlyMoveStart);
}

function OnLoad()
{
	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 106, 46 );

	AddState("GAMINGSTATE");	
	AddState( "ARENABATTLESTATE" );
	AddState( "ARENAGAMINGSTATE" );	
	SetContainerHUD(WINDOWTYPE_NONE, 0);	
	
	SetAlwaysFullAlpha( true );
	SetHavingFocus( false );
}

function onCallUCFunction( string functionName, string param )
{
	//Debug("flyMove ���� �϶�� ���! " @ functionName );

	switch (functionName)
	{
		// ���� �϶�� ���!
		case "flyMove" :
			RequestFlyMoveStart();			
		break;
	}
}

/**
 * ���ڸ� ������ true, false �� ���� �ϰ� �Ѵ�.
 **/
function bool bflag(int nflag)
{
	if (nflag > 0) return true;
	else return false;
}

defaultproperties
{
}
