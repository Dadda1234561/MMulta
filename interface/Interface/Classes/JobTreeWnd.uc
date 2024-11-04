//------------------------------------------------------------------------------------------------------------------------
//
// Б¦ёс         : АьБч°иєёµµ - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class JobTreeWnd extends L2UIGFxScript;

var int targetCurrentSubjobClassID;
var bool isTargetNpc;

event OnRegisterEvent()
{
	RegisterEvent(EV_TargetUpdate);
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		// End:0x18
		case EV_TargetUpdate:
			OnTargetUpdate();
			// End:0x1B
			break;
	}
}

event OnLoad()
{
	AddState("GAMINGSTATE");
	SetContainerWindow(WINDOWTYPE_DECO_NORMAL, 2704);
}

event OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		// End:0x2A
		case "ucExecuteCommand":
			ucExecuteCommand(param);
			// End:0x2D
			break;
	}
}

private function OnTargetUpdate()
{
	// End:0x19
	if(! IsShowWindow("JobTreeWnd"))
	{
		return;
	}
	SetTargetCurrentSubjobClassID();
	CallGFxFunction("JobTreeWnd", "changeTargetClassID", "");
}

function SetTargetCurrentSubjobClassID()
{
	local UserInfo Info;

	// End:0x12
	if(! GetTargetInfo(Info))
	{
		return;
	}
	isTargetNpc = Info.bNpc;
	// End:0x40
	if(isTargetNpc)
	{
		targetCurrentSubjobClassID = Info.nClassID;		
	}
	else
	{
		targetCurrentSubjobClassID = Info.nSubClass;
	}
}

function ucExecuteCommand(string param)
{
	// End:0x0E
	if(param == "")
	{
		return;
	}
	ExecuteCommand(param);
}

defaultproperties
{
}
