//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : 인게임샾 - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class InGameShopWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
	registerGfxEvent(EV_VipProductItemStart);
	registerGfxEvent(EV_VipProductItem);
	registerGfxEvent(EV_VipProductItemEnd);
	registerGfxEvent(EV_VipInfo);
	registerGfxEvent(EV_BR_CashShopNewIconAnim);
	registerGfxEvent(EV_BR_RESULT_BUY_PRODUCT);
	registerGfxEvent(EV_VipLuckyGameInfo);
	registerGfxEvent(EV_BR_SETGAMEPOINT);
	RegisterGFxEventForLoaded(EV_InventoryUpdateItem);
}

function OnLoad()
{
	AddState( "GAMINGSTATE" );
	SetContainerWindow(WINDOWTYPE_DECO_NORMAL, 5001);
}

defaultproperties
{
}
