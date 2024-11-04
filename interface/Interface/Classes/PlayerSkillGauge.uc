//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : PlayerSkillGauge  - SCALEFORM UI
//      Player 스킬 게이지
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
	//타겟의 스킬 시전 정보 보내주는 Event Test용.
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

	// 한국, 나중에 옵션으로 하는게 좋을듯.. 언어로 세팅하면 한글, 해외 버전에서 확인하기가 불편함.
	//if(GetLanguage() != ELanguageType.LANG_Korean) addShortcutExpandLocY = -40;

	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomCenter, EAnchorPointType.ANCHORPOINT_BottomCenter, FLASH_XPOS,FLASH_YPOS);

	setDefaultShow(true);
	setHavingFocus( false );
}

defaultproperties
{
}
