//------------------------------------------------------------------------------------------------------------------------
//
// ����          : ������ ��, �ø��ǾƵ� ��� ���� ����, Ÿ�̸�
//

//      ���帶�� : http://wallis-devsub/redmine/issues/5317
//------------------------------------------------------------------------------------------------------------------------
class OlympiadScoreBoardHUD extends L2UIGFxScript;

function OnRegisterEvent()
{	

	RegisterGFxEvent( EV_OlympiadMatchInfo); // 11022

	RegisterEvent( EV_StateChanged);
	RegisterEvent( EV_OlympiadMatchEnd);
}

function OnLoad()
{	
	AddState("GAMINGSTATE");

	SetContainerHUD(WINDOWTYPE_NONE, 0);    
	SetDefaultShow(true);	
	SetHavingFocus( false );	
	setHUD();
}

function OnFlashLoaded()
{		
	IgnoreUIEvent(true);
	SetAnchor("", EAnchorPointType.ANCHORPOINT_TopCenter, EAnchorPointType.ANCHORPOINT_TopCenter, 0 , 0);	
}


function onEvent ( int id, string param) 
{	
	switch ( id ) 
	{
		// ������Ʈ ���� �� open �� �־� as ������ ��.
		case EV_StateChanged : 
		//	Debug("EV_StateChanged : " @ param);
			if( param == "ARENABATTLESTATE" || param == "ARENAOBSERVERSTATE" ) ShowWindow ( getCurrentWindowName(string(Self)) );
			else hideWindow ( getCurrentWindowName(string(Self)) );
		break;
		case EV_OlympiadMatchEnd:
			hideWindow ( getCurrentWindowName(string(Self)));
		break;
	}
}

defaultproperties
{
}
