class BeautyShop extends GFxUIScript;
var int currentScreenWidth, currentScreenHeight;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

function OnRegisterEvent()
{
	registerGfxEvent(EV_OpenBeautyshopWindow);
	registerGfxEvent(EV_ReceiveBeautyItemList);
	registerGfxEvent(EV_SendUserAdenaAndCoin);
	registerGfxEvent(EV_CurrentUserStyle);
	registerGfxEvent(EV_IsSuccessBuyingStyle);
	registerGfxEvent(EV_OpenBeautyshopResetWindow);
	registerGfxEvent(EV_EndSocialAction);
	registerGfxEvent(EV_OldUserStyle);
	registerGfxEvent(EV_ExitBeautyshop);
	RegisterGFxEventForLoaded(EV_ResolutionChanged);
	registerGfxEvent(EV_PurchaseItemList);  //��Ƽ�� �����ߴ� ������ ����Ʈ �߰� �̺�Ʈ
	//registerEvent(EV_OpenBeautyshopResetWindow);
	//registerEvent(EV_OpenBeautyshopWindow);
}

function OnLoad()
{
	registerState( "BeautyShop", "BeautyShopState" );
	SetAnchor("", EAnchorPointType.ANCHORPOINT_TopLeft, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0);
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_BeautyshopWnd);
}

defaultproperties
{
}
