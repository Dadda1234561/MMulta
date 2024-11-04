class EventBalthus extends L2UIGFxScriptNoneContainer;
var int currentScreenWidth, currentScreenHeight;

var bool saveShow;

//플래쉬 옵셋 좌표
const FLASH_XPOS = -190;
const FLASH_YPOS = 0;

var SideBar SideBarScript;
var bool bRunning;
var string tooltipZeroLine;
var string tooltipOneLine;
var string tooltipTwoLine;

function OnRegisterEvent()
{
	registerGfxEvent(EV_EventBalthusState);
	registerGfxEvent(EV_EventBalthusJackpotUser);
	registerGfxEvent(EV_EventBalthusDisable);
	registerGfxEvent( EV_Restart );

	RegisterGFxEventForLoaded(EV_ResolutionChanged);

	RegisterEvent(EV_EventBalthusJackpotUser);

	RegisterEvent( EV_StateChanged );
	RegisterEvent( EV_Restart );
}

function OnLoad()
{		
	SetSaveWnd(True,True);

	//SetClosingOnESC();

	SetHavingFocus( false );
	registerState( "EventBalthus", "GamingState" );
	
	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0,0);
	
	SideBarScript = SideBar(GetScript("SideBar"));
	tooltipTwoLine = "";
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_EventKalieWnd);	//GetRewardItem()
}

function OnShow()
{
	saveShow = true;
	SideBarScript.ToggleByWindowName("EventBalthus",True);
}

function OnHide ()
{
	SideBarScript.ToggleByWindowName("EventBalthus",False);
}

function OnEvent(int Event_ID, string param)
{
	if( Event_ID == EV_StateChanged )
	{
		if (param == "GAMINGSTATE")
		{
			if( saveShow == true )
			{
				SetShowWindow();
			}
		}
	}
	else if (Event_ID == EV_Restart)
	{
		if( saveShow )
		{
			saveShow = false;
		}
	}
	else if (Event_ID == EV_EventBalthusJackpotUser)
		Debug("EV_EventBalthusJackpotUser---->" @ param);
}

function OnCallUCFunction (string functionName, string param)
{
	switch (functionName)
	{
		case "closeEventBalthus":
			Debug("OnCallUcFunction -- closeEventBalthus ~ ");
			SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_EVENTBALTHUS, false);
			Class'UIAPI_WINDOW'.static.HideWindow("EventBalthus");
			break;
		case "openEventBalthus":
			Debug("OnCallUcFunction -- openEventBalthus ~ ");
			SideBarScript.SetWindowShowHideByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_EVENTBALTHUS, true);
			Class'UIAPI_WINDOW'.static.ShowWindow("EventBalthus");
			break;
		case "SetIconEnabled":
			if ( bool(param) )
				tooltipOneLine = GetSystemString(3869);
			else
				tooltipOneLine = GetSystemString(3870);
			break;
		case "Running":
			bRunning = bool(param);
			if (  !bool(param) )
				tooltipTwoLine = GetSystemMessage(4395);
			HandleGuageSetColor(bRunning);
			break;
		case "CurrentState":
			tooltipZeroLine = param $ GetSystemString(2980);
			break;
		case "progress":
			SideBarScript.SetPointByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_EVENTBALTHUS, 100 - int(param), 100);
			break;
		case "Round":
			if ( bRunning )
				tooltipTwoLine = param $ GetSystemString(670);
			break;
	}
	setTooltipSideBar();
}

function setTooltipSideBar ()
{
	if ( tooltipTwoLine != "" )
		SideBarScript.setMakegfxWindowTooltip(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_EVENTBALTHUS, tooltipZeroLine @ tooltipOneLine @ "\n" $ tooltipTwoLine);
	else
		SideBarScript.setMakegfxWindowTooltip(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_EVENTBALTHUS, GetSystemString(3870));
}

function HandleGuageSetColor (bool bRunning)
{
	local StatusRoundHandle guage;
	local Color tmpColor;

	if ( bRunning )
		tmpColor = GetColor(148,148,148,255);
	else
		tmpColor = GetColor(227,149,57,255);

	guage = SideBarScript.GetStatusBarByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_EVENT_EVENTBALTHUS);
	guage.SetGaugeColor(guage.StatusBarSplitType.SBST_ForeCenter,tmpColor);
}

function Color GetColor (int R, int G, int B, int A)
{
	local Color tColor;

	tColor.R = R;
	tColor.G = G;
	tColor.B = B;
	tColor.A = A;

	return tColor;
}

/**
 * ShowWindow 창이 열려 있을때 다시 열지 않기.
 */
function SetShowWindow()
{
	// End:0x12
	if(IsShowWindow() == false)
	{
		ShowWindow();
	}
}

defaultproperties
{
}
