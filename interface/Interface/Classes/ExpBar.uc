class ExpBar extends L2UIGFxScript;

struct _S_EX_USER_BOOST_STAT
{
	var int Type;
	var int Count;
	var int Percent;
};

function OnRegisterEvent()
{
	// End:0x0F
	if(class'UIConstants'.const.USE_XML_BOTTOM_BAR_UI)
	{
		return;
	}
	RegisterGFxEvent(EV_UpdateUserInfo);
	RegisterGFxEvent(EV_GameStart);
	RegisterGFxEvent(EV_Restart);
	RegisterGFxEvent(EV_UnReadMailCount);
	RegisterGFxEvent(EV_PledgeCount);
	RegisterGFxEvent(EV_AdenaInvenCount);
	RegisterGFxEvent(EV_SetMaxCount);
	RegisterGFxEvent(EV_ClanInfo);
	RegisterGFxEvent(EV_GFX_ClanInfo);
	RegisterGFxEvent(EV_ClanDeleteAllMember);
	RegisterGFxEvent(EV_GFX_ClanDeleteAllMember);
	RegisterGFxEvent(EV_NeedResetUIData);
	RegisterGFxEvent(EV_BloodyCoinCount);
	RegisterGFxEvent(EV_PCCafePointInfo);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_USER_BOOST_STAT);
	RegisterGFxEvent(EV_NextTargetModeChange);
	RegisterGFxEvent(EV_OptionHasApplied);
}

function OnEvent(int Event_ID, string param)
{
	// End:0x0F
	if(class'UIConstants'.const.USE_XML_BOTTOM_BAR_UI)
	{
		return;
	}
	switch(Event_ID)
	{
		// End:0x12
		case EV_GameStart:
			// End:0x35
			break;
		// End:0x32
		case EV_PacketID(class'UIPacket'.const.S_EX_USER_BOOST_STAT):
			ParsePacket_S_EX_USER_BOOST_STAT();
			// End:0x35
			break;
	}
}

function ParsePacket_S_EX_USER_BOOST_STAT()
{
	local UIPacket._S_EX_USER_BOOST_STAT packet;
	local string strParam;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_USER_BOOST_STAT(packet))
	{
		return;
	}
	ParamAdd(strParam, "type", string(packet.Type));
	ParamAdd(strParam, "count", string(packet.Count));
	ParamAdd(strParam, "percent", string(packet.Percent));
	CallGFxFunction("ExpBar", "S_EX_USER_BOOST_STAT", strParam);
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		// End:0x1A
		case "LCoin":
			HandleToggleShowShopDailyWnd();
			// End:0x47
			break;
		case "PcCafe":
			HandleToggleShowPCCafeCommuniWnd();
			// End:0x47
			break;
		// End:0x44
		case "einhasad":
			HandleToggleShowShopDailyWnd();
			// End:0x47
			break;
	}
}

function HandleToggleShowPCCafeCommuniWnd()
{
	// End:0x21
	if(getInstanceL2Util().getIsPrologueGrowType())
	{
		AddSystemMessage(4533);
	}
	else
	{
		// End:0x63
		if(GetWindowHandle("NPCDialogWnd").IsShowWindow())
		{
			GetWindowHandle("NPCDialogWnd").HideWindow();
		}
		else
		{
			RequestOpenWndWithoutNPC(OPEN_PCCAFE_HTML);
		}
	}
}

function HandleToggleShowShopDailyWnd()
{
	getInstanceL2Util().toggleWindow("ShopLcoinWnd", true, true);
}

function OnLoad()
{
	// End:0x0F
	if(class'UIConstants'.const.USE_XML_BOTTOM_BAR_UI)
	{
		return;
	}
	AddState("GAMINGSTATE");
	AddState("ARENAGAMINGSTATE");
	AddState("ARENABATTLESTATE");
	AddState("ARENAPICKSTATE");
	SetContainerHUD(WINDOWTYPE_NONE, 0);
	SetDefaultShow(true);
	SetHavingFocus(false);
	SetHUD();
	//SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0);
}

defaultproperties
{
}
