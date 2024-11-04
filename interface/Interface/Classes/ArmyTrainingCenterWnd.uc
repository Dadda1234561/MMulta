class ArmyTrainingCenterWnd extends GFxUIScript;

const TIMER_ID_Sec=10012;
const TIMER_ID_Min=10013;
const TIMER_DELAY=60000;

var int nRemainSecondTime;

function OnRegisterEvent()
{
	RegisterEvent( EV_StateChanged );	
	RegisterEvent( EV_TrainingRoomStart_SecondInfo );  //branch EP1.0 2014-6-2 luciper3 - �Ʒü� �ʴ������� ���߱�����..
	RegisterGFxEvent( EV_TrainingRoomStart );
	RegisterGFxEvent( EV_UpdateUserInfo );
}

function OnLoad()
{	
	registerState( "ArmyTrainingCenterWnd", "TRAININGROOMSTATE" );
	// ��� �����̳ʿ� ���� ���� ����
	SetContainer( "ContainerWindow" );
	//setDefaultShow(true);
	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0 , 0);
}

function OnEvent(int Event_ID, string param)
{
	if(Event_ID == EV_StateChanged)
	{	
		if (param != "TRAININGROOMSTATE")
		{
			callGFxFunction( "ArmyTrainingCenterWnd", "StateOut", "");
			HideWindow();
			KillTimer( TIMER_ID_Sec );
			KillTimer( TIMER_ID_Min );
		}
		else
		{
			callGFxFunction( "ArmyTrainingCenterWnd", "StateIn", "");
			//SetTimer(TIMER_ID,TIMER_DELAY);
		}
	}
	//branch EP1.0 2014-6-2 luciper3 - �Ʒü� �ʴ������� ���߱�����..
	if( Event_ID == EV_TrainingRoomStart_SecondInfo )
	{
		ParseInt( param, "MaxTime", nRemainSecondTime );
		//log("======================================= Time Info : "$nRemainSecondTime$" === Remain Sec : "$(nRemainSecondTime % 60));
		if( nRemainSecondTime > 0 )
		{
			nRemainSecondTime = nRemainSecondTime % 60;
			if( nRemainSecondTime > 0 )
				SetTimer(TIMER_ID_Sec, (nRemainSecondTime*1000));
			else
				SetTimer(TIMER_ID_Min, TIMER_DELAY);
		}
	}
	//end of branch
}

function OnTimer(int TimerID)
{
	if( TimerID == TIMER_ID_Sec || TimerID == TIMER_ID_Min )
	{
		callGFxFunction( "ArmyTrainingCenterWnd", "TimerUpdate", "");

		if( TimerID == TIMER_ID_Sec )
		{
			KillTimer(TIMER_ID_Sec);
			SetTimer(TIMER_ID_Min, TIMER_DELAY);
		}
	}
}

function ClearTimer(int TimerID)
{
	if(TimerID == TIMER_ID_Sec)
	{
		KillTimer( TIMER_ID_Sec );
	}
	else if( TimerID == TIMER_ID_Min )
	{
		KillTimer( TIMER_ID_Min );
	}
}

function onCallUCFunction( string functionName, string param )
{	
	switch ( functionName ) 
	{
		case "":
			//ParamAdd(strParam, "FilePath", "..\\L2text\\"$param);
			//ExecuteEvent(EV_ShowHelp, strParam);
		break;
		
	}
}

defaultproperties
{
}
