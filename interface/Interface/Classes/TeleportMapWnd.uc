//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : 텔레포트 맵 (2018.10) - SCALEFORM UI
// 
// 전 서버 공통
// http://l2-redmine/redmine/issues/7123
//
//------------------------------------------------------------------------------------------------------------------------
class TeleportMapWnd extends L2UIGFxScript;

var int _priceRacio;

function OnRegisterEvent()
{
	// Etc
	RegisterGFxEvent( EV_Test_2);
	RegisterGFxEvent(EV_TeleportFreeLevel); // 10231
	RegisterEvent(EV_TeleportMapWndShow); // 20200
	RegisterGFxEvent(EV_GFX_TeleportFavoritesList); // 11450
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_TELEPORT_UI);
}

function OnLoad()
{
	SetSaveWnd(True,False);

	AddState("GAMINGSTATE");
	SetContainerWindow(WINDOWTYPE_DECO_NORMAL, 687); //텔레포트
}

function OnFlashLoaded()
{
	//RegisterDelegateHandler(EDelegateHandlerType.EDHandler_TeleportList);
}

function OnShow()
{
}

function OnEvent(int Event_ID, string param)
{
	// End:0x0F
	if(class'UIConstants'.const.USE_XML_TELEPORT_UI)
	{
		return;
	}
	switch(Event_ID)
	{
		// End:0x27
		case EV_TeleportMapWndShow:
			Rq_C_EX_TELEPORT_UI();
			// End:0x4B
			break;
		// End:0x48
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_TELEPORT_UI:
			Rs_S_EX_TELEPORT_UI();
			// End:0x4B
			break;
	}	
}

function Rs_S_EX_TELEPORT_UI()
{
	local UIPacket._S_EX_TELEPORT_UI packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_TELEPORT_UI(packet))
	{
		return;
	}
	_priceRacio = packet.nPriceRatio;
	class'UIAPI_WINDOW'.static.ShowWindow("TeleportMapWnd");	
}

function Rq_C_EX_TELEPORT_UI()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_TELEPORT_UI, stream);	
}

defaultproperties
{
}
