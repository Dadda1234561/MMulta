class TeleportWndMap extends UICommonAPI;

const MAP_2D_WIDTH = 164;
const MAP_3D_WIDTH = 32768;
const ADEN_BOUNDARY_LEFT_MAP_OFFSET = 5;
const ADEN_BOUNDARY_TOP_MAP_OFFSET = 8;
const GRACIA_BOUNDARY_LEFT_MAP_OFFSET = -10;
const GRACIA_BOUNDARY_TOP_MAP_OFFSET = -8;
const TELEPORT_MAP_SCALE = 0.166;
const MAP_ICON_OFFSET_X = 12;
const MAP_ICON_OFFSET_Y = 23;
const TIMER_ID_PLAYER_POSITION = 1;
const TIMER_PLAYER_POSITION = 1000;
const MAX_TOWN_NUM = 30;
const MAX_DOMINION_NUM = 50;

var float adenBoundryLeftLocX;
var float adenBoundryTopLocY;
var float graciaBoundryLeftLocX;
var float graciaBoundryTopLocY;
var float worldMapScale;
var int currentTooltipTeleportID;
var WindowHandle Me;
var WindowHandle mapTooltip;
var TextureHandle mapTex;
var TextureHandle mapTooltipCostTex;
var AnimTextureHandle playerPosAnimTex;
var AnimTextureHandle townIconAnimTex;
var AnimTextureHandle townAreaAnimTex;
var AnimTextureHandle dominionIconAnimTex;
var AnimTextureHandle dominionAreaAnimTex;
var TextBoxHandle currentZoneTextBox;
var TextBoxHandle mapTooltipNameTextBox;
var TextBoxHandle mapTooltipCostTextBox;
var array<ButtonHandle> townMapIcons;
var array<ButtonHandle> dominionMapIcons;

static function TeleportWndMap Inst()
{
	return TeleportWndMap(GetScript("TeleportWnd.TeleportWndMap"));	
}

function Initialize()
{
	adenBoundryLeftLocX = -ADEN_BOUNDARY_LEFT_MAP_OFFSET * MAP_3D_WIDTH;
	adenBoundryTopLocY = -ADEN_BOUNDARY_TOP_MAP_OFFSET * MAP_3D_WIDTH;
	graciaBoundryLeftLocX = GRACIA_BOUNDARY_LEFT_MAP_OFFSET * MAP_3D_WIDTH;
	graciaBoundryTopLocY = GRACIA_BOUNDARY_TOP_MAP_OFFSET * MAP_3D_WIDTH;
	worldMapScale = MAP_2D_WIDTH / MAP_3D_WIDTH;
	initControls();	
}

function initControls()
{
	local string ownerFullPath;
	local int i;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	mapTooltip = GetWindowHandle(ownerFullPath $ ".Map_ToolTip");
	mapTooltipNameTextBox = GetTextBoxHandle(mapTooltip.m_WindowNameWithFullPath $ ".Tooltip_txt");
	mapTooltipCostTextBox = GetTextBoxHandle(mapTooltip.m_WindowNameWithFullPath $ ".adena_txt");
	mapTooltipCostTex = GetTextureHandle(mapTooltip.m_WindowNameWithFullPath $ ".adena_tex");
	playerPosAnimTex = GetAnimTextureHandle(ownerFullPath $ ".Icon_MyPosition_Ani");
	townIconAnimTex = GetAnimTextureHandle(ownerFullPath $ ".Map_TownIcon_Ani");
	dominionIconAnimTex = GetAnimTextureHandle(ownerFullPath $ ".HuntingIcon_Ani");
	townAreaAnimTex = GetAnimTextureHandle(ownerFullPath $ ".Icon_TownZone_Ani");
	dominionAreaAnimTex = GetAnimTextureHandle(ownerFullPath $ ".Icon_HuntuingZone_Ani");
	currentZoneTextBox = GetTextBoxHandle(ownerFullPath $ ".MyLocation_txt");
	// End:0x223
	if(getInstanceUIData().getIsClassicServer())
	{
		GetTextureHandle(ownerFullPath $ ".ServerMapLoad_Classic_tex").ShowWindow();
		GetTextureHandle(ownerFullPath $ ".ServerMapLoad_Live_tex").HideWindow();		
	}
	else
	{
		GetTextureHandle(ownerFullPath $ ".ServerMapLoad_Classic_tex").HideWindow();
		GetTextureHandle(ownerFullPath $ ".ServerMapLoad_Live_tex").ShowWindow();
	}
	townMapIcons.Length = 0;
	dominionMapIcons.Length = 0;

	// End:0x2D8 [Loop If]
	for(i = 0; i < MAX_TOWN_NUM; i++)
	{
		AddMapIconControl(townMapIcons, "Icon_TownZone_", i, Me);
	}

	// End:0x31E [Loop If]
	for(i = 0; i < MAX_DOMINION_NUM; i++)
	{
		AddMapIconControl(dominionMapIcons, "Icon_HuntuingZone_", i, Me);
	}
	mapTooltip.HideWindow();	
}

function AddMapIconControl(out array<ButtonHandle> componentList, string componentName, int Index, WindowHandle Owner)
{
	local ButtonHandle targetButtonHandle;

	targetButtonHandle = GetButtonHandle(Owner.m_WindowNameWithFullPath $ "." $ componentName $ string(Index));
	componentList[componentList.Length] = targetButtonHandle;	
}

function ShowMapIconTooltip(int TeleportID)
{
	local ButtonHandle targetIconBtn;
	local TeleportWnd.TeleportInfo TeleportInfo;
	local Rect tooltipRect;
	local bool isFoundIconBtn, isDominionIcon;
	local int i, textWidth, textHeight, costSize;
	local string CostText;

	// End:0x11
	if(currentTooltipTeleportID == TeleportID)
	{
		return;
	}

	// End:0x7B [Loop If]
	for(i = 0; i < townMapIcons.Length; i++)
	{
		targetIconBtn = townMapIcons[i];
		// End:0x71
		if(targetIconBtn.IsShowWindow() && targetIconBtn.GetButtonValue() == TeleportID)
		{
			isFoundIconBtn = true;
			// [Explicit Break]
			break;
		}
	}
	// End:0xF9
	if(isFoundIconBtn == false)
	{
		// End:0xF9 [Loop If]
		for(i = 0; i < dominionMapIcons.Length; i++)
		{
			targetIconBtn = dominionMapIcons[i];
			// End:0xEF
			if(targetIconBtn.IsShowWindow() && targetIconBtn.GetButtonValue() == TeleportID)
			{
				isFoundIconBtn = true;
				isDominionIcon = true;
				// [Explicit Break]
				break;
			}
		}
	}
	// End:0x10D
	if(isFoundIconBtn == false)
	{
		HideMapIconTooltip();
		return;
	}
	TeleportInfo = class'TeleportWnd'.static.Inst().GetTeleportInfo(TeleportID);
	tooltipRect = mapTooltip.GetRect();
	CostText = MakeCostStringINT64(class'TeleportWnd'.static.Inst().GetTeleportCost(TeleportInfo.Price[0].Amount, TeleportInfo.UsableLevel, TeleportInfo.UsableTransferDegree));
	GetTextSizeDefault(TeleportInfo.Name, textWidth, textHeight);
	GetTextSizeDefault(CostText, costSize, textHeight);
	mapTooltipNameTextBox.SetText(TeleportInfo.Name);
	mapTooltipCostTextBox.SetText(CostText);
	costSize += 40;
	// End:0x243
	if(TeleportInfo.Price[0].Id == 57)
	{
		mapTooltipCostTex.SetTexture("L2UI_CT1.Icon.Icon_DF_Common_Adena");		
	}
	else
	{
		mapTooltipCostTex.SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
	}
	mapTooltip.SetWindowSize(Max(textWidth + 16, costSize), MAX_DOMINION_NUM);
	mapTooltip.MoveTo(targetIconBtn.GetRect().nX + 13, targetIconBtn.GetRect().nY - 35);
	// End:0x338
	if(isDominionIcon)
	{
		dominionIconAnimTex.MoveTo(targetIconBtn.GetRect().nX - 2, targetIconBtn.GetRect().nY - 2);
		dominionIconAnimTex.ShowWindow();
	}
	currentTooltipTeleportID = TeleportID;
	mapTooltip.ShowWindow();	
}

function HideMapIconTooltip()
{
	currentTooltipTeleportID = -1;
	dominionIconAnimTex.HideWindow();
	mapTooltip.HideWindow();	
}

function UpdateTownZoneIcons()
{
	local array<TeleportWnd.TeleportTownInfo> townInfoList;
	local TeleportWnd.TeleportInfo tempTeleportInfo;
	local int i;
	local Vector iconLoc;
	local ButtonHandle townIconBtn;

	townInfoList = class'TeleportWnd'.static.Inst().GetTeleportTownList();

	// End:0x118 [Loop If]
	for(i = 0; i < townMapIcons.Length; i++)
	{
		townIconBtn = townMapIcons[i];
		// End:0xEB
		if(i < townInfoList.Length)
		{
			tempTeleportInfo = townInfoList[i].townInfo;
			iconLoc = GetMinimapPosFromWorldLoc(townIconBtn, setVector(tempTeleportInfo.locX, tempTeleportInfo.locY, 0));
			townIconBtn.MoveC(int(iconLoc.X), int(iconLoc.Y));
			townIconBtn.SetButtonValue(tempTeleportInfo.Id);
			townIconBtn.ShowWindow();
			// [Explicit Continue]
			continue;
		}
		townIconBtn.SetButtonValue(-1);
		townIconBtn.HideWindow();
	}	
}

function UpdateDominionZoneIcons()
{
	local TeleportWnd.TeleportTownInfo townInfo;
	local TeleportWnd.TeleportInfo tempTeleportInfo;
	local int i, selectedTownId, selectedDominionTeleportId;
	local Vector iconLoc;
	local ButtonHandle dominionIconBtn;

	selectedTownId = class'TeleportWnd'.static.Inst().GetSelectedTownID();
	selectedDominionTeleportId = class'TeleportWnd'.static.Inst().GetSelectedDominionTeleportID();
	// End:0x148
	if(selectedTownId >= 0)
	{
		townInfo = class'TeleportWnd'.static.Inst().GetTownInfo(selectedTownId);
		iconLoc = GetMinimapPosFromWorldLoc(townAreaAnimTex, setVector(townInfo.townInfo.locX, townInfo.townInfo.locY, 0));
		townAreaAnimTex.MoveC(int(iconLoc.X), int(iconLoc.Y));
		iconLoc = GetMinimapPosFromWorldLoc(townIconAnimTex, setVector(townInfo.townInfo.locX, townInfo.townInfo.locY, 0));
		townIconAnimTex.MoveC(int(iconLoc.X), int(iconLoc.Y));
		townAreaAnimTex.ShowWindow();
		townIconAnimTex.ShowWindow();		
	}
	else
	{
		townAreaAnimTex.HideWindow();
		townIconAnimTex.HideWindow();
	}
	dominionAreaAnimTex.HideWindow();

	// End:0x303 [Loop If]
	for(i = 0; i < dominionMapIcons.Length; i++)
	{
		dominionIconBtn = dominionMapIcons[i];
		// End:0x2D6
		if((selectedTownId >= 0) && i < townInfo.dominions.Length)
		{
			tempTeleportInfo = townInfo.dominions[i];
			iconLoc = GetMinimapPosFromWorldLoc(dominionIconBtn, setVector(tempTeleportInfo.locX, tempTeleportInfo.locY, 0));
			dominionIconBtn.MoveC(int(iconLoc.X), int(iconLoc.Y));
			dominionIconBtn.SetButtonValue(tempTeleportInfo.Id);
			dominionIconBtn.ShowWindow();
			// End:0x2D3
			if(selectedDominionTeleportId >= 0 && tempTeleportInfo.Id == selectedDominionTeleportId)
			{
				iconLoc = GetMinimapPosFromWorldLoc(dominionAreaAnimTex, setVector(tempTeleportInfo.locX, tempTeleportInfo.locY, 0));
				dominionAreaAnimTex.MoveC(int(iconLoc.X), int(iconLoc.Y));
				dominionAreaAnimTex.ShowWindow();
			}
			// [Explicit Continue]
			continue;
		}
		dominionIconBtn.SetButtonValue(-1);
		dominionIconBtn.HideWindow();
	}	
}

function UpdateCurrentZoneInfo()
{
	local string zoneName;
	local int zoneID;
	local UserInfo UserInfo;
	local Vector playerMapLoc, validPlayerMapLoc;
	local int locX, locY, locZ;

	zoneName = GetCurrentZoneName();
	zoneID = GetCurrentZoneID();
	GetPlayerInfo(UserInfo);
	locX = int(UserInfo.Loc.X);
	locY = int(UserInfo.Loc.Y);
	locZ = int(UserInfo.Loc.Z);
	validPlayerMapLoc = class'TeleportListAPI'.static.ModifyExceptionLocation(locX, locY, locZ);
	playerMapLoc = GetMinimapPosFromWorldLoc(playerPosAnimTex, setVector(int(validPlayerMapLoc.X), int(validPlayerMapLoc.Y), 0));
	playerPosAnimTex.MoveC(int(playerMapLoc.X), int(playerMapLoc.Y));
	currentZoneTextBox.SetText(zoneName);	
}

function Vector GetMinimapPosFromWorldLoc(WindowHandle targetWnd, Vector worldLoc)
{
	local Vector taregetPosition;

	// End:0x83
	if(worldLoc.X > adenBoundryLeftLocX)
	{
		taregetPosition.X = ((((worldLoc.X - adenBoundryLeftLocX) * worldMapScale) * TELEPORT_MAP_SCALE) - ADEN_BOUNDARY_TOP_MAP_OFFSET) + MAP_ICON_OFFSET_X;
		taregetPosition.Y = ((((worldLoc.Y - adenBoundryTopLocY) * worldMapScale) * TELEPORT_MAP_SCALE) - ADEN_BOUNDARY_TOP_MAP_OFFSET) + MAP_ICON_OFFSET_Y;		
	}
	else
	{
		taregetPosition.X = (((worldLoc.X - graciaBoundryLeftLocX) * worldMapScale) * TELEPORT_MAP_SCALE) + MAP_ICON_OFFSET_X;
		taregetPosition.Y = (((worldLoc.Y - graciaBoundryTopLocY) * worldMapScale) * TELEPORT_MAP_SCALE) + MAP_ICON_OFFSET_Y;
	}
	taregetPosition.X -= (float(targetWnd.GetRect().nWidth) * 0.50f);
	taregetPosition.Y -= (float(targetWnd.GetRect().nHeight) * 0.50f);
	return taregetPosition;	
}

function PlayMapIconAnimation()
{
	playerPosAnimTex.SetLoopCount(999999);
	townIconAnimTex.SetLoopCount(999999);
	townAreaAnimTex.SetLoopCount(999999);
	dominionIconAnimTex.SetLoopCount(999999);
	dominionAreaAnimTex.SetLoopCount(999999);
	playerPosAnimTex.Play();
	townIconAnimTex.Play();
	townAreaAnimTex.Play();
	dominionIconAnimTex.Play();
	dominionAreaAnimTex.Play();	
}

function StopMapIconAnimation()
{
	playerPosAnimTex.Stop();
	townIconAnimTex.Stop();
	townAreaAnimTex.Stop();
	dominionIconAnimTex.Stop();
	dominionAreaAnimTex.Stop();	
}

function StartPlayerPositionTimer()
{
	KillPlayerPositionTimer();
	Me.SetTimer(TIMER_ID_PLAYER_POSITION, TIMER_PLAYER_POSITION);	
}

function KillPlayerPositionTimer()
{
	Me.KillTimer(TIMER_ID_PLAYER_POSITION);	
}

event OnLoad()
{
	Initialize();	
}

event OnShow()
{
	HideMapIconTooltip();
	UpdateCurrentZoneInfo();	
}

event OnTimer(int TimerID)
{
	// End:0x3C
	if(TimerID == TIMER_ID_PLAYER_POSITION)
	{
		UpdateCurrentZoneInfo();
		// End:0x3C
		if(class'TeleportWnd'.static.Inst().Me.IsShowWindow())
		{
			StartPlayerPositionTimer();
		}
	}	
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x37
		case "MyLocation_Btn":
			class'TeleportWnd'.static.Inst().SetCurrentZoneListSelected(true);
			// End:0x3A
			break;
	}	
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local int buttonValue;

	buttonValue = a_ButtonHandle.GetButtonValue();
	// End:0x40
	if(buttonValue > 0)
	{
		class'TeleportWnd'.static.Inst().ShowTeleportDialog(buttonValue);
	}	
}

event OnMouseOver(WindowHandle WindowHandle)
{
	local int buttonValue;

	// End:0x1B
	if(ButtonHandle(WindowHandle).m_pTargetWnd == none)
	{
		return;
	}
	buttonValue = ButtonHandle(WindowHandle).GetButtonValue();
	// End:0x4B
	if(buttonValue > 0)
	{
		ShowMapIconTooltip(buttonValue);
	}	
}

event OnMouseOut(WindowHandle WindowHandle)
{
	HideMapIconTooltip();	
}

defaultproperties
{
}
