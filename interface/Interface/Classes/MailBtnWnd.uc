class MailBtnWnd extends UICommonAPI;

/**
 * 알림아이콘 통합으로 사용되지 않음.
 */

var ButtonHandle btnItemPop;
var int buttonType;

function OnRegisterEvent()
{}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	buttonType = 0;
	Initialize();
}

function Initialize()
{
	if(CREATE_ON_DEMAND==0)
	{
		btnItemPop = ButtonHandle(GetHandle("MailBtnWnd.btnMail"));
	}
	else
	{
		btnItemPop = GetButtonHandle("MailBtnWnd.btnMail");
	}

	btnItemPop.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(3064)));	// 툴팁. 
}

function OnEvent(int Event_ID, string param)
{
	local int iEffectNumber;

	ParseInt(param, "IdxMail", iEffectNumber);
	switch(Event_ID)
	{
		case EV_ArriveNewMail :
			ShowWindowWithFocus("MailBtnWnd");
			class'UIAPI_EFFECTBUTTON'.static.BeginEffect("MailBtnWnd.btnMail", iEffectNumber);
			buttonType = 1;
			// End:0xBC
			break;
		case EV_Notice_Post_Arrived:
			ShowWindowWithFocus("MailBtnWnd");
			class'UIAPI_EFFECTBUTTON'.static.BeginEffect("MailBtnWnd.btnMail", iEffectNumber);
			buttonType = 2;
			break;
	}
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		// End:0x3A
		case "btnMail":
			HideWindow("MailBtnWnd");
			// End:0x37
			if(buttonType == 2)
			{
				RequestRequestReceivedPostList();
			}
			// End:0x3D
			break;
	}
}

defaultproperties
{
}
