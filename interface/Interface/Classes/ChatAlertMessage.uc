class ChatAlertMessage extends GFxUIScript;

//�÷��� �ɼ� ��ǥ
const FLASH_XPOS = 0;
const FLASH_YPOS = -137;

function OnRegisterEvent()
{
	RegisterGFxEvent(EV_ChatMessage);
}

function OnLoad()
{
	registerState("ChatAlertMessage", "GamingState");
	//SetFixedPositionRate( 0.5f, 0.59f );
	//��ġ ���
	//SetAnchor( "", EAnchorPointType.ANCHORPOINT_TopCenter, EAnchorPointType.ANCHORPOINT_TopCenter, FLASH_XPOS, FLASH_YPOS);
	SetAnchor( "", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_BottomRight, FLASH_XPOS, FLASH_YPOS );
	//������ ����
	SetAlwaysFullAlpha(true);
	//��Ŀ�� ���� ����
	SetHavingFocus(false);
	//Ŭ�� ���� ����.
	SetMsgPassThrough(true);
}

defaultproperties
{
}
