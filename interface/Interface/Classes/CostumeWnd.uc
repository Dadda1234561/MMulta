//================================================================================
// QuestBtnWnd.
// emu-dev.ru
//================================================================================
class CostumeWnd extends L2UIGFxScriptNoneContainer;

function OnRegisterEvent()
{
	RegisterGFxEvent(EV_CostumeUseItem);
	RegisterGFxEvent(EV_CostumeChooseItem);
	RegisterGFxEvent(EV_CostumeList);
	RegisterGFxEvent(EV_CostumeEvolution);
	RegisterGFxEvent(EV_CostumeExtract);
	RegisterGFxEvent(EV_CostumeLock);
	RegisterGFxEvent(EV_CostumeShortCutList);
	RegisterGFxEvent(EV_CostumeFullList);
	RegisterGFxEvent(EV_CostumeCollectSkillActive);
	RegisterGFxEvent(EV_AdenaInvenCount);
	RegisterGFxEvent(EV_Restart);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	AddState("GAMINGSTATE");
	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0, 0);
}

function OnShow()
{
	if(class'UIAPI_WINDOW'.static.IsShowWindow("CardDrawEventWnd"))
	{
		class'UIAPI_WINDOW'.static.HideWindow("CardDrawEventWnd");
	}
	if(class'UIAPI_WINDOW'.static.IsShowWindow("ItemUpgrade"))
	{
		class'UIAPI_WINDOW'.static.HideWindow("ItemUpgrade");
	}
	super.OnShow();
	L2Util(GetScript("L2Util")).ItemRelationWindowHide(getCurrentWindowName(string(self)));
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_Costume);
	RegisterDelegateHandler(EDHandler_Container);
	RegisterDelegateHandler(EDHandler_Default);
	RegisterDelegateHandler(EDHandler_GameData);
	RegisterDelegateHandler(EDHandler_Option);
	RegisterDelegateHandler(EDHandler_UseSkill);
}

function OnCallUCFunction(string functionName, string param)
{
}

defaultproperties
{
}
