/***
 *  
 *  ���ͽ� �̺�Ʈ UI �������� �Ͽ�
 *  �ϴ� �ּ� ó��, ���� ������ ��� �ȵǴ� ���� Ȯ�� �Ǹ�, UC�� SWF�� ���� �ϸ� �ɵ�.
 * 
 * */

class EventKalie extends GFxUIScript;
var int currentScreenWidth, currentScreenHeight;

var bool saveShow;


//�÷��� �ɼ� ��ǥ
const FLASH_XPOS = -190;
const FLASH_YPOS = 0;

function setScreenResolution()
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	GetCurrentResolution(currentScreenWidth, currentScreenHeight);

	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);

	args[0].SetInt(currentScreenWidth);
	args[1].SetInt(currentScreenHeight);

	// Debug("currentScreenWidth" @ currentScreenWidth);
	// Debug("currentScreenHeight" @ currentScreenHeight);
	Invoke("setCurrentResolution", args, invokeResult);

	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
}

function OnEvent(int Event_ID, string param)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	if( Event_ID == EV_StateChanged )
	{
		if (param == "GAMINGSTATE")
		{
			if( saveShow == true )
			{
				SetShowWindow();
			}
		}
		else if(param == "CHARACTERSELECTSTATE")
		{
			
		}
	}
	else if (Event_ID == EV_Restart)
	{
		if( saveShow )
		{
			AllocGFxValues(args, 2);
			AllocGFxValue(invokeResult);
			args[0].SetInt(EV_EventBalthusDisable);
			CreateObject(args[1]);

			Invoke("onEvent", args, invokeResult);
			DeallocGFxValue(invokeResult);
			DeallocGFxValues(args);
			saveShow = false;
		}
	}
}

/**
 * ShowWindow â�� ���� ������ �ٽ� ���� �ʱ�.
 */
function SetShowWindow()
{
	if(IsShowWindow() == false)
	{
		ShowWindow();
	}
}

event OnMouseOut(WindowHandle W)
{
	dispatchEventToFlash_String(0, "");
	//������ ���콺 ��ġ�� 0,0����.
	//ForceToMoveMousePos( 0, 0 );
}

event OnMouseOver(WindowHandle W)
{
	dispatchEventToFlash_String(1, "");
}

function dispatchEventToFlash_String(int Event_ID, string argString)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);
	args[0].SetInt(Event_ID);
	CreateObject(args[1]);

//	Debug("argString"@argString);
	args[1].SetMemberString("string", argString );

	Invoke("onEvent", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
}

defaultproperties
{
}
