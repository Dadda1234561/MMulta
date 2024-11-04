class AutoTargetRangeSettingsWnd extends UICommonAPI;

const MIN_SHORT_RANGE = 30;
const MAX_SHORT_RANGE = 1399;

const DEFAULT_SHORT_RANGE = 600;
const DEFAULT_LONG_RANGE = 1400;

const MIN_LONG_RANGE = 1400;
const MAX_LONG_RANGE = 9999;

var WindowHandle Me;
var ButtonHandle CloseButton;
var ButtonHandle ShortRangeBtn;
var ButtonHandle LongRangeBtn;

var EditBoxHandle ShortRangeEditBox;
var EditBoxHandle LongRangeEditBox;

var TextBoxHandle Short_Title_TextBox;
var TextBoxHandle Long_Title_TextBox;

var AutomaticPlay automaticPlayScr;
var AutoUseItemWnd AutoUseWnd;
var bool isInit;

var int iShowWindow;
var int iShortRadius;
var int iLongRadius;

// is window open

/**
*  OnRegisterEvent
**/
function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_StateChanged);	
	RegisterEvent(EV_ResolutionChanged);	
}
 
/**
*  OnLoad
**/ 
function OnLoad()
{
	Initialize();
}

/**
*  OnShow
**/ 
function OnShow()
{
	ResetWindowPosition();
}

function RestoreSettings()
{
	local int nShort;
	local int nLong;

	if ( !GetINIInt("AutoUseItemWnd", "nShortRadius", nShort, "AutoPlaySettings.ini") )
	{
		iShortRadius = DEFAULT_SHORT_RANGE;
		SetINIInt("AutoUseItemWnd", "nShortRadius", iShortRadius, "AutoPlaySettings.ini");
	}

	if ( !GetINIInt("AutoUseItemWnd", "nLongRadius", nLong, "AutoPlaySettings.ini") )
	{
		iLongRadius = DEFAULT_LONG_RANGE;
		SetINIInt("AutoUseItemWnd", "nLongRadius", iLongRadius, "AutoPlaySettings.ini");
	}
	
	
	GetINIInt("AutoUseItemWnd", "nShortRadius", iLongRadius, "windowsInfo.ini");
	GetINIInt("AutoUseItemWnd", "nLongRadius", iShortRadius, "windowsInfo.ini");
	GetINIInt("AutoUseItemWnd", "iShowWindow", iShowWindow, "windowsInfo.ini");

	// Validate
	if (iLongRadius < MIN_LONG_RANGE || iLongRadius > MAX_LONG_RANGE)
	{
		iLongRadius = DEFAULT_LONG_RANGE;
		SetINIInt("AutoUseItemWnd", "nLongRadius", iLongRadius, "AutoPlaySettings.ini");
	}
	if (iShortRadius < MIN_SHORT_RANGE || iShortRadius > MAX_SHORT_RANGE)
	{
		iShortRadius = DEFAULT_SHORT_RANGE;
		SetINIInt("AutoUseItemWnd", "nShortRadius", iShortRadius, "AutoPlaySettings.ini");
	}


}

function Initialize()
{
	local string ownerFullPath;

	ownerFullPath = "AutoTargetRangeSettingsWnd";
    
	Me = GetWindowHandle(ownerFullPath);
	Me.HideWindow();
	CloseButton = GetButtonHandle(ownerFullPath$".CloseButton");
	ShortRangeBtn = GetButtonHandle(ownerFullPath$".ShortRangeBtn");
	LongRangeBtn = GetButtonHandle(ownerFullPath$".LongRangeBtn");
	ShortRangeEditBox = GetEditBoxHandle(ownerFullPath$".ShortRangeEditBox");
	LongRangeEditBox = GetEditBoxHandle(ownerFullPath$".LongRangeEditBox");
	Short_Title_TextBox = GetTextBoxHandle(ownerFullPath$".Short_Title_TextBox");
	Long_Title_TextBox = GetTextBoxHandle(ownerFullPath$".Long_Title_TextBox");

	RestoreSettings();
	ResetWindowPosition();
	RefreshWindowState();

	ShortRangeEditBox.SetString(string(iShortRadius));
	LongRangeEditBox.SetString(string(iLongRadius));

	AutoUseWnd = class'AutoUseItemWnd'.static.Inst();
}


function ResetWindowPosition()
{
	Me.SetAnchor("AutoUseItemWnd", "BottomLeft", "BottomLeft", -216, -2); // это моё зрение
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_Restart:
			RefreshWindowState();
			break;
		case EV_ResolutionChanged:
			ResetWindowPosition();
			break;
	}
}

function SaveWindowState(bool newState)
{
	iShowWindow = boolToNum(newState);
	SetINIInt("AutoUseItemWnd", "bIsShowRangeWnd", iShowWindow, "AutoPlaySettings.ini");
	RefreshWindowState();
	SaveINI("AutoPlaySettings.ini");
}

function ToggleWindowState()
{
	local bool currStateBool;
	currStateBool = iShowWindow == 1;
	iShowWindow = boolToNum(!currStateBool);
	SetINIInt("AutoUseItemWnd", "bIsShowRangeWnd", iShowWindow, "AutoPlaySettings.ini");
	RefreshWindowState();
	SaveINI("AutoPlaySettings.ini");
}

function RefreshWindowState()
{
	if ( iShowWindow == 1 )
	{
		if(GetGameStateName()!="GAMINGSTATE")
			return;
			
		Me.ShowWindow();
	}
	else
	{
		Me.HideWindow();
	}
}

function handle_ShortRangeBtnClick()
{
	local int iRange;

	// empty
	if ( ShortRangeEditBox.GetString() == "" )
	{
		iShortRadius = DEFAULT_SHORT_RANGE;
		SetINIInt("AutoUseItemWnd", "nShortRadius", iShortRadius, "AutoPlaySettings.ini");
		ShortRangeEditBox.SetString(string(iShortRadius));
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(7495));
		RequestBypassToServer("multimperia?autoplaySettings range1 "$iShortRadius);
		return;
	}

	// validate
	iRange = int(ShortRangeEditBox.GetString());
	if ( iRange < MIN_SHORT_RANGE )
	{
		iRange = MIN_SHORT_RANGE;
	}
	else if (iRange > MAX_SHORT_RANGE)
	{
		iRange = MAX_SHORT_RANGE;
	}

	if (iShortRadius != iRange)
	{
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(7493), string(iRange)));
	}

	iShortRadius = iRange;

	// save short range
	SetINIInt("AutoUseItemWnd", "nShortRadius", iRange, "AutoPlaySettings.ini");
	ShortRangeEditBox.SetString(string(iRange));
	RequestBypassToServer("multimperia?autoplaySettings range1 "$iRange);
	SaveINI("AutoPlaySettings.ini");
}

function handle_LongRangeBtnClick()
{
	local int iRange;

	// empty
	if ( LongRangeEditBox.GetString() == "" ) {
		iLongRadius = DEFAULT_LONG_RANGE;
		SetINIInt("AutoUseItemWnd", "nLongRadius", iLongRadius, "AutoPlaySettings.ini");
		LongRangeEditBox.SetString(string(iLongRadius));
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(7495));
		RequestBypassToServer("multimperia?autoplaySettings range2 "$iLongRadius);
		return;
	}

	iRange = int(LongRangeEditBox.getString());
	if ( iRange < MIN_LONG_RANGE ) {
		iRange = MIN_LONG_RANGE;
	}
	else if (iRange > MAX_LONG_RANGE) {
		iRange = MAX_LONG_RANGE;
	}

	if (iLongRadius != iRange) {
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg( GetSystemMessage(7494), string(iRange)));
	}

	iLongRadius = iRange;
	SetINIInt("AutoUseItemWnd", "nLongRadius", iRange, "AutoPlaySettings.ini");
	LongRangeEditBox.SetString(string(iRange));
	RequestBypassToServer("multimperia?autoplaySettings range2 "$iRange);
	SaveINI("AutoPlaySettings.ini");
}

function OnClickButton(string name)
{
	switch(name)
	{
		case "ShortRangeBtn":
			handle_ShortRangeBtnClick();
			break;
		case "LongRangeBtn":
			handle_LongRangeBtnClick();
			break;
	}
}