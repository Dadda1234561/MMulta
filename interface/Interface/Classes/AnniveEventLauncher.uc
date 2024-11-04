class AnniveEventLauncher extends L2UIGFxScript;

var private bool bInEvent;

static function AnniveEventLauncher Inst()
{
	return AnniveEventLauncher(GetScript("AnniveEventLauncher"));
}

event OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
}

event OnLoad()
{
	SetContainerHUD(WINDOWTYPE_NOBG_NODRAG, 0);
	AddState("GAMINGSTATE");
	NotUseESC();
	SetHUD();
	SetHavingFocus(false);
}

event OnEvent(int eID, string param)
{
	Show();
}

function _Show()
{
	bInEvent = true;
	Show();
}

private function Show()
{
	// End:0x1A
	if(GetGameStateName() != "GAMINGSTATE")
	{
		return;
	}
	// End:0x27
	if(! bInEvent)
	{
		return;
	}
	// End:0x32
	if(IsPlayerOnWorldRaidServer())
	{
		return;
	}
	ShowWindow(getCurrentWindowName(string(self)));
}

defaultproperties
{
}
