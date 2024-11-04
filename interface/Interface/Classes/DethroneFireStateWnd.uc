class DethroneFireStateWnd extends UICommonAPI;

const TIMER_ID_ELAPSED_TIME = 1;
const TIMER_ELAPSED_DELAY_TIME = 1000;
const TILE_LIST_COLUMN = 4;
const TILE_LIST_ROW = 1;
const ITEM_ID_PERSONAL_POINT = 82499;
const ITEM_ID_SERVER_POINT = 82659;
const ITEM_ID_PRIMAL_FIRE_POINT = 82609;

var array<UIPacket._HolyFire> _infos;
var int _uiElapsedTimeCount;
var WindowHandle Me;
var WindowHandle ScrollAreaWnd;
var WindowHandle disableWnd;
var WindowHandle UIControlDialogAsset;
var array<DethroneFireStateItemObject> rendererObjectList;
var UIControlTilelist scrollTileList;

function Initialize()
{
	InitControls();
	scrollTileList._SetTileListItemNumTotal(TILE_LIST_COLUMN);	
}

function InitControls()
{
	local int i;
	local WindowHandle itemRendererWnd;
	local DethroneFireStateItemObject itemObject;

	Me = GetWindowHandle("DethroneFireStateWnd");
	ScrollAreaWnd = GetWindowHandle("DethroneFireStateWnd.ScrollAreaWnd");
	scrollTileList = class'UIControlTilelist'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd"), TILE_LIST_COLUMN, TILE_LIST_ROW, true);
	scrollTileList.DelegateOnItemRenderer = HandleDelegateOnItemRenderer;
	scrollTileList._SetUsePage(true);
	rendererObjectList.Length = 0;
	// End:0x12F [Loop If]
	for(i = 0; i < 4; i++)
	{
		itemRendererWnd = GetWindowHandle(scrollTileList._GetRendererPath(i));
		itemObject = new class'DethroneFireStateItemObject';
		itemObject.Init(itemRendererWnd);
		rendererObjectList[rendererObjectList.Length] = itemObject;
	}	
}

function ResetInfo()
{
	local int i;

	_infos.Length = 0;
	_uiElapsedTimeCount = 0;

	// End:0x45 [Loop If]
	for(i = 0; i < rendererObjectList.Length; i++)
	{
		rendererObjectList[i].ResetInfo();
	}	
}

function StartElapsedTimer()
{
	KillElapsedTimer();
	Me.SetTimer(TIMER_ID_ELAPSED_TIME, TIMER_ELAPSED_DELAY_TIME);	
}

function KillElapsedTimer()
{
	Me.KillTimer(TIMER_ID_ELAPSED_TIME);	
}

function HandleDelegateOnItemRenderer(string itemRendererID, int rendererIndex, int Position)
{
	local DethroneFireStateItemObject rendererObject;

	rendererObject = rendererObjectList[rendererIndex];
	// End:0x5B
	if(Position < _infos.Length)
	{
		rendererObject.SetInfo(_infos[Position], _uiElapsedTimeCount);
		rendererObject.Me.ShowWindow();		
	}
	else
	{
		rendererObject.ResetInfo();
		rendererObject.Me.HideWindow();
	}	
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		// End:0x2E
		case "WindowHelp_BTN":
			//class'HelpWnd'.static.ShowHelp(63, 6);
			// End:0x31
			break;
	}	
}

function Rq_C_EX_HOLY_FIRE_OPEN_UI()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_HOLY_FIRE_OPEN_UI, stream);	
}

function Rs_S_EX_HOLY_FIRE_OPEN_UI()
{
	local UIPacket._S_EX_HOLY_FIRE_OPEN_UI packet;
	local UIPacket._ItemInfo itemStruct;
	local int i;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_HOLY_FIRE_OPEN_UI(packet))
	{
		return;
	}
	scrollTileList._SetTileListItemNumTotal(packet.infos.Length);

	// End:0x394 [Loop If]
	for(i = 0; i < packet.infos.Length; i++)
	{
		// End:0x289
		if(packet.infos[i].nRewardPersonalPoint > 0)
		{
			itemStruct.nItemClassID = ITEM_ID_PERSONAL_POINT;
			itemStruct.nAmount = packet.infos[i].nRewardPersonalPoint;
			packet.infos[i].rewards[packet.infos[i].rewards.Length] = itemStruct;
		}
		// End:0x30B
		if(packet.infos[i].nRewardServerPoint > 0)
		{
			itemStruct.nItemClassID = ITEM_ID_SERVER_POINT;
			itemStruct.nAmount = packet.infos[i].nRewardServerPoint;
			packet.infos[i].rewards[packet.infos[i].rewards.Length] = itemStruct;
		}
		// End:0x38A
		if(packet.infos[i].nRewardPrimalFirePoint > 0)
		{
			itemStruct.nItemClassID = ITEM_ID_PRIMAL_FIRE_POINT;
			itemStruct.nAmount = packet.infos[i].nRewardPrimalFirePoint;
			packet.infos[i].rewards[packet.infos[i].rewards.Length] = itemStruct;
		}
	}
	_uiElapsedTimeCount = 0;
	StartElapsedTimer();
	_infos = packet.infos;
	scrollTileList._Refresh();
	// End:0x3EC
	if(Me.IsShowWindow() == false)
	{
		Me.ShowWindow();
		Me.SetFocus();
	}	
}

function Nt_S_EX_HOLY_FIRE_NOTIFY()
{
	Debug("Rs_S_EX_HOLY_FIRE_NOTIFY");
	// End:0x38
	if(Me.IsShowWindow())
	{
		Rq_C_EX_HOLY_FIRE_OPEN_UI();
	}	
}

function OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_HOLY_FIRE_OPEN_UI));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_HOLY_FIRE_NOTIFY));	
}

function OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_HOLY_FIRE_OPEN_UI):
			Rs_S_EX_HOLY_FIRE_OPEN_UI();
			// End:0x4A
			break;
		// End:0x47
		case EV_PacketID(class'UIPacket'.const.S_EX_HOLY_FIRE_NOTIFY):
			Nt_S_EX_HOLY_FIRE_NOTIFY();
			// End:0x4A
			break;
	}	
}

event OnHide()
{
	ResetInfo();
	KillElapsedTimer();	
}

event OnTimer(int TimerID)
{
	// End:0x21
	if(TimerID == TIMER_ID_ELAPSED_TIME)
	{
		_uiElapsedTimeCount++;
		scrollTileList._Refresh();
	}	
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();	
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("DethroneFireStateWnd").HideWindow();	
}

defaultproperties
{
}
