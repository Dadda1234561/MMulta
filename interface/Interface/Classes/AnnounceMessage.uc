class AnnounceMessage extends GFxUIScript;

//�÷��� �ɼ� ��ǥ
const FLASH_XPOS = 0;
const FLASH_YPOS = 260;

function OnRegisterEvent()
{
	RegisterGFxEvent(EV_ChatMessage);
}

function OnLoad()
{
	RegisterState("AnnounceMessage", "GamingState");
	SetAnchor("", EAnchorPointType.ANCHORPOINT_TopCenter, EAnchorPointType.ANCHORPOINT_TopCenter, FLASH_XPOS, FLASH_YPOS);
	SetAlwaysFullAlpha(true);
	SetHavingFocus(false);
	SetMsgPassThrough(true);
}

defaultproperties
{
}
