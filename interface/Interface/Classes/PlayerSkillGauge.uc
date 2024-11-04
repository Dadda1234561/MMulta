//------------------------------------------------------------------------------------------------------------------------
//
// ����         : PlayerSkillGauge  - SCALEFORM UI
//      Player ��ų ������
//
//------------------------------------------------------------------------------------------------------------------------
class PlayerSkillGauge extends L2UIGFxScript;


const FLASH_XPOS = 0;
const FLASH_YPOS = -250;
//
/*
var array<GFxValue> args;
var GFxValue invokeResult;
*/

function OnRegisterEvent()
{
	//Ÿ���� ��ų ���� ���� �����ִ� Event Test��.
	RegisterGFxEvent(EV_OwnSkillHasLaunched);
	RegisterGFxEvent(EV_OwnSkillHasCanceled);
	RegisterGFxEvent(EV_StateChanged);
}

function OnLoad()
{
	SetContainerHUD(WINDOWTYPE_NONE, 0);

	AddState("GAMINGSTATE");
	AddState("ARENAPICKSTATE");
	AddState("ARENAGAMINGSTATE");
	AddState("ARENABATTLESTATE");

	// �ѱ�, ���߿� �ɼ����� �ϴ°� ������.. ���� �����ϸ� �ѱ�, �ؿ� �������� Ȯ���ϱⰡ ������.
	//if(GetLanguage() != ELanguageType.LANG_Korean) addShortcutExpandLocY = -40;

	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomCenter, EAnchorPointType.ANCHORPOINT_BottomCenter, FLASH_XPOS,FLASH_YPOS);

	setDefaultShow(true);
	setHavingFocus( false );
}

defaultproperties
{
}
