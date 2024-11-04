class ViewPortWndEffect extends ViewPortWndBase;

function OnLoad()
{
	super.OnLoad();

	m_ObjectViewport.SetNPCInfo( EFFECT_MONSTER_ID ) ;
	m_ObjectViewport.SetUISound( true ) ;

	registerState( getCurrentWindowName (string(Self)), "ARENAGAMINGSTATE" );
	registerState( getCurrentWindowName (string(Self)), "ARENABATTLESTATE" );
	registerState( getCurrentWindowName (string(Self)), "GAMINGSTATE" );
}

function OnRegisterEvent()
{
	RegisterEvent( EV_StateChanged );	
}

function OnEvent ( int eventID , String param ) 
{
	switch ( eventID ) 
	{
		case EV_StateChanged :
			switch ( param ) 
			{
				case "ARENAGAMINGSTATE" :
				case "ARENABATTLESTATE" :
				case "GAMINGSTATE" :
					//m_ObjectViewport.ShowNPC( 0.01f );
					m_ObjectViewport.SpawnNPC();
					break;
			}
	}	
}

/***********************************************************************************************
 * etc 
 * *********************************************************************************************/

//defaultproperties
//{
//	m_WindowName = "ViewPortWndEffect";
//}

defaultproperties
{
}
