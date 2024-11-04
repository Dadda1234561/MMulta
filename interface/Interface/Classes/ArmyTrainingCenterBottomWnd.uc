class ArmyTrainingCenterBottomWnd extends GFxUIScript;

const DIALOG_ASK_TRAINING_OUT = 66666;

function OnRegisterEvent()
{	
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
	RegisterEvent( EV_StateChanged );
}

function OnLoad()
{
	registerState( "ArmyTrainingCenterBottomWnd", "TRAININGROOMSTATE" );
	// ��� �����̳ʿ� ���� ���� ����
	SetContainer( "ContainerWindow" );
	setDefaultShow(true);
	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0 );
}

function OnEvent(int Event_ID, string param)
{
	if(Event_ID == EV_DialogOK)
	{
		HandleDialogOK();
	}
	else if(Event_ID == EV_DialogCancel)
	{
		//HandleDialogCancel();
	}
	else if(Event_ID == EV_StateChanged)
	{
		if (param == "TRAININGROOMSTATE")
		{
			ShowWindow();
		}
		else
		{
			HideWindow();
		}
	}
}
/*
function HandleDialogCancel()
{
	local int id;
	local DialogBox script;
	script = DialogBox(GetScript("DialogBox"));
	id = script.GetID();

	if( script.GetTarget() == string(Self) )
	{
		if (id == DIALOG_ASK_TRAINING_OUT)
		{
			script.HandleCancel();
		}
	}
}
*/
function HandleDialogOK()
{
	local int id;

	local DialogBox script;
	local ArmyTrainingCenterWnd armyScript;

	script = DialogBox(GetScript("DialogBox"));
	armyScript = ArmyTrainingCenterWnd(GetScript("ArmyTrainingCenterWnd"));
	id = script.GetID();

	if( script.GetTarget() == string(Self) )
	{
		if (id == DIALOG_ASK_TRAINING_OUT)
		{	
			//�Ʒ� ��� ��û
			callGFxFunction( "ArmyTrainingCenterBottomWnd", "TrainingRoomOut", "");
			//callGFxFunction( "ArmyTrainingCenterWnd", "TrainingRoomOut", "");
			armyScript.ClearTimer(10012);
			armyScript.ClearTimer(10013);
		}
	}
} 

function onCallUCFunction( string functionName, string param )
{
	local DialogBox script;
	script = DialogBox(GetScript("DialogBox"));
	switch ( functionName ) 
	{
		case "ShowDialogTrainingOut" :
			
			//���̾�α� ���� 
			script.SetID( DIALOG_ASK_TRAINING_OUT );
			script.ShowDialog(DialogModalType_Modal, DialogType_OKCancel, GetSystemString(5155), string(self) );

			//DialogSetID( DIALOG_ASK_TRAINING_OUT);
			// ServerID
			//DialogSetReservedItemID( info.ID );						
			//�Ʒü� ��ҽ�û�� �Ͻðڽ��ϱ�? ��Ʈ��
			//DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4142), string(Self) );
		break;
		case "GameQuit":
			ExecuteEvent(EV_OpenDialogQuit);
		break;
		case "GameRestart":
			ExecuteEvent(EV_OpenDialogRestart);
		break;
	}
}

defaultproperties
{
}
