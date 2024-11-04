//------------------------------------------------------------------------------------------------------------------------
//
// ����         : Credit  ( ũ���� ) - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class Credit extends L2UIGFxScript;

const FLASH_WIDTH  = 800;
const FLASH_HEIGHT = 600;

var int currentScreenWidth, currentScreenHeight;

function OnRegisterEvent()
{
	RegisterGFxEventForLoaded (EV_ResolutionChanged);
	RegisterGFxEvent(EV_CreditXMLString);  // param ���� ��. 
	RegisterEvent(EV_StateChanged);
}

function OnLoad()
{	
	registerState("Credit", "CreditState" );
	setDefaultShow(true);
}

function OnShow ()
{
}

function OnEvent (int Event_ID, string param)
{
	if ( Event_ID == EV_StateChanged )
	{
		switch (param)
		{
			case "CREDITSTATE":
				SetTimer(101,100);
				break;
		}
	}
}

function OnTimer (int TimeID)
{
	if ( TimeID == 101 )
	{
		SetFocus("Credit");
		KillTimer(101);
		Debug("OnTimer : Set Focus Credit");
	}
}

function OnFlashLoaded()
{
	SetAnchor("", EAnchorPointType.ANCHORPOINT_TopLeft, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0 );	
}

function onCallUCFunction( string functionName, string param )
{
	//local string strParam;
	// Debug("sampe's onCallUCFunction" @ functionName @ param);
	//switch ( functionName ) 
	//{
	//	case "OpenHelpHTML" :
	//		ParamAdd(strParam, "FilePath", "..\\L2text\\"$param);
	//		ExecuteEvent(EV_ShowHelp, strParam);
	//	break;
		
	//}
}


function OnCallUCLogic( int logicID, string param )
{
	if (logicID == 1)
	{
		if (param == "exit")
		{
			// ����
			EndCredit();
		}
	}
}

defaultproperties
{
}
