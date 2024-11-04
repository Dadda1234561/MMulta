class WorldSiegeLauncherWnd extends UICommonAPI;

static function WorldSiegeLauncherWnd Inst()
{
	return WorldSiegeLauncherWnd(GetScript("WorldSiegeLauncherWnd"));
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		// End:0x91
		case "WorldSiegeLauncher_btn":
			// End:0x6C
			if(class'WorldSiegeRankingWnd'.static.Inst().m_hOwnerWnd.IsShowWindow())
			{
				class'WorldSiegeRankingWnd'.static.Inst().m_hOwnerWnd.HideWindow();				
			}
			else
			{
				class'WorldSiegeRankingWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
			}
			// End:0x11F
			break;
		// End:0x11C
		case "WorldSiegeLauncher2_btn":
			// End:0xF7
			if(class'WorldSiegeBoardWnd'.static.Inst().m_hOwnerWnd.IsShowWindow())
			{
				class'WorldSiegeBoardWnd'.static.Inst().m_hOwnerWnd.HideWindow();				
			}
			else
			{
				class'WorldSiegeBoardWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
			}
			// End:0x11F
			break;
	}
}

defaultproperties
{
}
