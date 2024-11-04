class WorldSiegeBoardWnd extends UICommonAPI;

const MAP_SCALE = 0.0312;
const MAX_HERO = 5;
const MAX_GOLEM = 3;
const MAX_DOOR = 3;
const MAX_Occupation = 20;
const TIMER_MYPOS_ID = 0;
const TIMER_MYPOS_TIME = 500;
const TIMER_HUD_INFO_ID = 1;
const TIMER_HUD_INFO_TIME = 3000;
const TIMER_HEROWEAPON_DELETE_ID = 2;
const TIMER_HEROWEAPON_DELETE_TIME = 12000;

var string m_WindowName;
var WindowHandle Me;
var TextBoxHandle Time_txt;
var TextureHandle Icon_PC;
var TextureHandle Map_tex;
var Vector startLoc;
var UIMapInt64Object mapObjOccupy;
var UIMapInt64Object mapObjHeroWeapon;
var UIMapInt64Object mapObjHeroWeaponUser;
var UIMapInt64Object mapObjGolem;
var bool bHUDInfoReq;
var array<WorldSiegeBoardOcptnObject> worldSiegeBoardOcptnObjects;

static function WorldSiegeBoardWnd Inst()
{
	return WorldSiegeBoardWnd(GetScript("WorldSiegeBoardWnd"));
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	Icon_PC = GetTextureHandle(m_WindowName $ ".WorldSegeMapWnd.Icon_PC");
	Time_txt = GetTextBoxHandle(m_WindowName $ ".Time_txt");
	Map_tex = GetTextureHandle(m_WindowName $ ".WorldSegeMapWnd.Map_tex");
	startLoc.X = 139712.0f;
	startLoc.Y = -400.0f;
	InitWorldSiegeBoardOcptnObjects();
	mapObjOccupy = new class'UIMapInt64Object';
	mapObjHeroWeapon = new class'UIMapInt64Object';
	mapObjHeroWeaponUser = new class'UIMapInt64Object';
	mapObjGolem = new class'UIMapInt64Object';
}

function InitWorldSiegeBoardOcptnObjects()
{
	local int i;

	// End:0xDF [Loop If]
	for(i = 0; GetWindowHandle(m_WindowName $ ".WorldSegeMapWnd.Icon_ocptnObjectWnd" $ Int2Str(i)).m_pTargetWnd != none; i++)
	{
		worldSiegeBoardOcptnObjects[i] = class'WorldSiegeBoardOcptnObject'.static.InitScript(GetWindowHandle(m_WindowName $ ".WorldSegeMapWnd.Icon_ocptnObjectWnd" $ Int2Str(i)), i);
		worldSiegeBoardOcptnObjects[i].GotoState(class'WorldSiegeBoardOcptnObject'.const.STATE_DESPAWN);
	}
}

function SetDoorIcons()
{
	local int i;
	local array<WorldCastleWarMapData> o_npcInfos;

	API_GetWorldCastleWarMapInfo(WCWMNT_Door, o_npcInfos);

	// End:0x64 [Loop If]
	for(i = 0; i < o_npcInfos.Length; i++)
	{
		//Debug("SetDOorIcons" @ string(o_npcInfos[i].Location));
		MoveIcon(GetDoorIcon(i), o_npcInfos[i].Location);
		GetDoorIcon(i).ShowWindow();
	}
}

event OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_OCCUPY_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_USER);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_SIEGE_GOLEM_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO);
	RegisterEvent(EV_GameStart);
}

event OnLoad()
{
	Initialize();
	SetClosingOnESC();
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x1E
		case EV_GameStart:
			EndWorldSiege();
			SetDoorIcons();
			// End:0xE7
			break;
		// End:0x3F
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_OCCUPY_INFO:
			Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_OCCUPY_INFO();
			// End:0xE7
			break;
		// End:0x60
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_INFO:
			Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_INFO();
			// End:0xE7
			break;
		// End:0x81
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_USER:
			Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_USER();
			// End:0xE7
			break;
		// End:0xA2
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_SIEGE_GOLEM_INFO:
			Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_SIEGE_GOLEM_INFO();
			// End:0xE7
			break;
		// End:0xC3
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO:
			Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO();
			// End:0xE7
			break;
		// End:0xE4
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO:
			Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO();
			// End:0xE7
			break;
	}
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		// End:0x2D
		case TIMER_MYPOS_ID:
			MoveIcon(Icon_PC, GetPlayerPosition(), 500.0f / 1000);
			// End:0x75
			break;
		// End:0x50
		case TIMER_HUD_INFO_ID:
			bHUDInfoReq = false;
			m_hOwnerWnd.KillTimer(TimerID);
			// End:0x75
			break;
		// End:0x72
		case TIMER_HEROWEAPON_DELETE_ID:
			DeleteHeroWeapons();
			m_hOwnerWnd.KillTimer(TimerID);
			// End:0x75
			break;
	}
}

event OnShow()
{
	MoveIcon(Icon_PC, GetPlayerPosition(), 0.0f);
	Me.SetTimer(TIMER_MYPOS_ID, TIMER_MYPOS_TIME);
	m_hOwnerWnd.SetFocus();
	API_C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO();
}

event OnHide()
{
	Me.KillTimer(TIMER_MYPOS_ID);
}

function Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_OCCUPY_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_OCCUPY_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_OCCUPY_INFO(packet))
	{
		return;
	}
	// End:0x32
	if(! ChkCastleID(packet.nCastleID))
	{
		return;
	}
	Debug("packet.lstWorldCastleWar_MainBattleOccupyInfoList:" @ string(packet.lstWorldCastleWar_MainBattleOccupyInfoList.Length));
	SetOccupyInfos(packet.lstWorldCastleWar_MainBattleOccupyInfoList);
}

function SetOccupyInfos(array<UIPacket._WorldCastleWar_MainBattleOccupyInfo> occupyInfos)
{
	local int i, Index, Key;
	local UIPacket._WorldCastleWar_MainBattleOccupyInfo occupyInfo;

	// End:0x28A [Loop If]
	for(i = 0; i < occupyInfos.Length; i++)
	{
		occupyInfo = occupyInfos[i];
		Key = occupyInfo.nOccupyNPCSID;
		Index = int(mapObjOccupy.Find(Key));
		Debug("SetOccupyInfos Start" @ string(occupyInfo.nOccypyNPCState) @ string(Index) @ string(mapObjOccupy.Size()) @ string(occupyInfo.nOccupyNPCClassID));
		// End:0xE2
		if(occupyInfo.nOccypyNPCState == 0)
		{
			// End:0xCC
			if(Index == -1)
			{
				// [Explicit Continue]
				continue;
			}
			mapObjOccupy.Remove(Key);
		}
		// End:0x208
		if(Index == -1)
		{
			Index = DespawnOccupiedDespawnStateOccupy(PositionToVector(occupyInfo.nOccypyNPCLocation));
			// End:0x1BE
			if(Index != -1)
			{
				Debug("겹치는 위치 입니다. 해당 위치에 있었던 점령체는 지워 버립니다." @ string(worldSiegeBoardOcptnObjects[Index].sID));
				mapObjOccupy.Remove(worldSiegeBoardOcptnObjects[Index].sID);
				worldSiegeBoardOcptnObjects[Index].GotoState(class'WorldSiegeBoardOcptnObject'.const.STATE_DESPAWN);
			}
			// End:0x1D9
			if(Index == -1)
			{
				Index = FindDespawnOccupy();
			}
			// End:0x1EB
			if(Index == -1)
			{
				// [Explicit Continue]
				continue;
			}
			mapObjOccupy.Add(Key, Index);
		}
		Debug("SetOccupyInfos :" @ string(occupyInfo.nOccypyNPCState) @ string(Index) @ "/" @ string(Key));
		worldSiegeBoardOcptnObjects[Index]._SetMainBattleOccupyInfo(occupyInfo);
		MoveIcon(GetOccpyIcon(Index), PositionToVector(occupyInfo.nOccypyNPCLocation));
	}
}

function int DespawnOccupiedDespawnStateOccupy(Vector worldLoc)
{
	local int i, dist;
	local Vector Loc;

	// End:0x108 [Loop If]
	for(i = 0; i < worldSiegeBoardOcptnObjects.Length; i++)
	{
		Loc = worldSiegeBoardOcptnObjects[i].Loc;
		dist = int(Sqrt(float(int(Loc.X - worldLoc.X) ^ int(2 + (Loc.Y - worldLoc.Y)) ^ int(2 + (Loc.Z - worldLoc.Z)) ^ 2)));
		Debug("거리 재기 " @ string(dist));
		// End:0xFE
		if((dist < 5) && dist > -5)
		{
			Debug((("가까움 :" @ string(i)) @ "/") @ string(dist));
			return i;
		}
	}
	return -1;
}

function int FindDespawnOccupy()
{
	local int i;

	// End:0x4C [Loop If]
	for(i = 0; i < worldSiegeBoardOcptnObjects.Length; i++)
	{
		// End:0x42
		if(worldSiegeBoardOcptnObjects[i].GetStateName() == class'WorldSiegeBoardOcptnObject'.const.STATE_DESPAWN)
		{
			return i;
		}
	}
	return -1;
}

function Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_INFO(packet))
	{
		return;
	}
	// End:0x32
	if(! ChkCastleID(packet.nCastleID))
	{
		return;
	}
	Debug("packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList:" @ string(packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList.Length));
	SetHeroWeaponInfos(packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList);
}

function SetHeroWeaponInfos(array<UIPacket._WorldCastleWar_MainBattleHeroWeaponInfo> heroWeaponIfnos, optional bool isAll)
{
	local int i, Key, Index;
	local UIPacket._WorldCastleWar_MainBattleHeroWeaponInfo heroWeaponInfo;
	local Vector Loc;

	// End:0x1E
	if(isAll)
	{
		HideAllHeroIcons();
		mapObjHeroWeapon.RemoveAll();
	}

	// End:0x191 [Loop If]
	for(i = 0; i < heroWeaponIfnos.Length; i++)
	{
		heroWeaponInfo = heroWeaponIfnos[i];
		Key = heroWeaponInfo.nHeroWeaponNPCSID;
		Index = int(mapObjHeroWeapon.Find(Key));
		// End:0xAE
		if(heroWeaponInfo.nHeroWeaponNPCState == 0)
		{
			// End:0x96
			if(Index == -1)
			{
				// [Explicit Continue]
				continue;
			}
			GetHeroIcon(Index).HideWindow();
			// [Explicit Continue]
			continue;
		}
		Index = FindDespawnHeroWeapon();
		// End:0xEC
		if(Index == -1)
		{
			Debug("영웅 무기 리스트가 다 참");
			// [Explicit Continue]
			continue;
		}
		mapObjHeroWeapon.Add(Key, Index);
		GetHeroIcon(Index).ShowWindow();
		Loc = PositionToVector(heroWeaponInfo.nHeroWeaponNPCLocation);
		MoveIcon(GetHeroIcon(Index), Loc);
		// End:0x187
		if(! isAll)
		{
			GetHeroIcon(Index).SetAlpha(0);
			GetHeroIcon(Index).SetAlpha(255, 0.50f);
		}
	}
}

function int FindDespawnHeroWeapon()
{
	local int i;

	// End:0x3D [Loop If]
	for(i = 0; i < 5; i++)
	{
		// End:0x33
		if(! GetHeroIcon(i).IsShowWindow())
		{
			return i;
		}
	}
	return -1;
}

function Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_USER()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_USER packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_USER(packet))
	{
		return;
	}
	// End:0x32
	if(! ChkCastleID(packet.nCastleID))
	{
		return;
	}
	// End:0xBB
	if(packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList.Length > 0)
	{
		m_hOwnerWnd.KillTimer(TIMER_HEROWEAPON_DELETE_ID);
		m_hOwnerWnd.SetTimer(TIMER_HEROWEAPON_DELETE_ID, TIMER_HEROWEAPON_DELETE_TIME);
		Debug("packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList:" @ string(packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList.Length));
	}
	SetHeroWeaponUserInfos(packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList);
}

function SetHeroWeaponUserInfos(array<UIPacket._WorldCastleWar_MainBattleHeroWeaponUserInfo> heroWeaponUserInfos)
{
	local int i, Key, Index, Len;
	local UIPacket._WorldCastleWar_MainBattleHeroWeaponUserInfo heroWeaponUserInfo;
	local Vector Loc;
	local UIMapInt64Object usedKey;

	usedKey = new class'UIMapInt64Object';

	// End:0x16C [Loop If]
	for(i = 0; i < heroWeaponUserInfos.Length; i++)
	{
		heroWeaponUserInfo = heroWeaponUserInfos[i];
		Loc = PositionToVector(heroWeaponUserInfo.nHeroWeaponUserLocation);
		Key = heroWeaponUserInfo.nHeroWeaponUserSID;
		Index = int(mapObjHeroWeaponUser.Find(Key));
		// End:0xD3
		if(Index > -1)
		{
			mapObjHeroWeaponUser.Remove(Key);
			MoveIcon(GetHeroPCIcon(Index), Loc, 1.0f);
			GetHeroPCIcon(Index).ShowWindow();			
		}
		else
		{
			Index = GetEmptyHeroWeaponIndex();
			// End:0x11A
			if(Index == -1)
			{
				Debug("히어로 웨폰 아이콘들 전부 사용 중");
				// [Explicit Continue]
				continue;
			}
			MoveIcon(GetHeroPCIcon(Index), Loc);
			ShowHeroPCIcon(Index, heroWeaponUserInfo.sHeroWeaponUserName);
		}
		usedKey.Add(Key, Index);
	}
	Len = mapObjHeroWeaponUser.Size();

	// End:0x1E4 [Loop If]
	for(i = 0; i < Len; i++)
	{
		Index = int(mapObjHeroWeaponUser.dataArray[0].Data);
		GetHeroPCIcon(Index).HideWindow();
		mapObjHeroWeaponUser.dataArray.Remove(0, 1);
	}

	// End:0x26D [Loop If]
	for(i = 0; i < usedKey.Size(); i++)
	{
		Key = int(usedKey.dataArray[i].Key);
		Index = int(usedKey.dataArray[i].Data);
		mapObjHeroWeaponUser.Add(Key, Index);
	}
}

function DeleteHeroWeapons()
{
	local array<UIPacket._WorldCastleWar_MainBattleHeroWeaponUserInfo> heroWeaponUserInfos;

	SetHeroWeaponUserInfos(heroWeaponUserInfos);
}

function ShowHeroPCIcon(int Index, string tooltipStr)
{
	GetHeroPCIcon(Index).SetTooltipCustomType(MakeTooltipSimpleText(tooltipStr));
	GetHeroPCIcon(Index).SetAlpha(0);
	GetHeroPCIcon(Index).ShowWindow();
	GetHeroPCIcon(Index).SetAlpha(255, 0.50f);
}

function int GetEmptyHeroWeaponIndex()
{
	local int i;

	// End:0x3D [Loop If]
	for(i = 0; i < 5; i++)
	{
		// End:0x33
		if(! GetHeroPCIcon(i).IsShowWindow())
		{
			return i;
		}
	}
	return -1;
}

function Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_SIEGE_GOLEM_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_SIEGE_GOLEM_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_SIEGE_GOLEM_INFO(packet))
	{
		return;
	}
	// End:0x32
	if(! ChkCastleID(packet.nCastleID))
	{
		return;
	}
	Debug("packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList:" @ string(packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList.Length));
	SetSiegeGolemInfos(packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList);
}

function SetSiegeGolemInfos(array<UIPacket._WorldCastleWar_MainBattleSiegeGolemInfo> siegeGolemInfos, optional bool isAll)
{
	local int i, Key, Index;
	local UIPacket._WorldCastleWar_MainBattleSiegeGolemInfo siegeGolemInfo;
	local Vector Loc;

	// End:0x1E
	if(isAll)
	{
		HideAllNPCIcons();
		mapObjGolem.RemoveAll();
	}

	// End:0x1AD [Loop If]
	for(i = 0; i < siegeGolemInfos.Length; i++)
	{
		siegeGolemInfo = siegeGolemInfos[i];
		Key = siegeGolemInfo.nSiegeGolemNPCSID;
		Index = int(mapObjGolem.Find(Key));
		Debug(string(i) @ "골렘 상태 " @ string(siegeGolemInfo.nSiegeGolemNPCState));
		// End:0xD7
		if(siegeGolemInfo.nSiegeGolemNPCState == 0)
		{
			// End:0xBF
			if(Index == -1)
			{
				// [Explicit Continue]
				continue;
			}
			GetGolemIcon(Index).HideWindow();
			// [Explicit Continue]
			continue;
		}
		Index = FindGolemDespawn();
		// End:0x108
		if(Index == -1)
		{
			Debug("골렘이 꽉참");
			// [Explicit Continue]
			continue;
		}
		mapObjGolem.Add(Key, Index);
		Loc = PositionToVector(siegeGolemInfo.nSiegeGolemNPCLocation);
		MoveIcon(GetGolemIcon(Index), Loc);
		GetGolemIcon(Index).ShowWindow();
		// End:0x1A3
		if(! isAll)
		{
			GetGolemIcon(Index).SetAlpha(0);
			GetGolemIcon(Index).SetAlpha(255, 0.50f);
		}
	}
}

function int FindGolemDespawn()
{
	local int i;

	// End:0x3D [Loop If]
	for(i = 0; i < 3; i++)
	{
		// End:0x33
		if(! GetGolemIcon(i).IsShowWindow())
		{
			return i;
		}
	}
	return -1;
}

function Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO packet;

	Debug("Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO");
	// End:0x58
	if(! class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO(packet))
	{
		return;
	}
	// End:0x6F
	if(! ChkCastleID(packet.nCastleID))
	{
		return;
	}
	Debug("packet.lstWorldCastleWar_MainBattleDoorInfoList:" @ string(packet.lstWorldCastleWar_MainBattleDoorInfoList.Length));
	SetDoorInfos(packet.lstWorldCastleWar_MainBattleDoorInfoList);
}

function SetDoorInfos(array<UIPacket._WorldCastleWar_MainBattleDoorInfo> doorInfos)
{
	local int i, j, DoorState;
	local array<WorldCastleWarMapData> o_npcInfos;

	API_GetWorldCastleWarMapInfo(WCWMNT_Door, o_npcInfos);
	Debug("SetDoorInfos" @ string(o_npcInfos.Length));

	// End:0x359 [Loop If]
	for(i = 0; i < o_npcInfos.Length; i++)
	{
		DoorState = -1;

		// End:0xF5 [Loop If]
		for(j = 0; j < doorInfos.Length; j++)
		{
			// End:0xEB
			if(o_npcInfos[i].ClassID == doorInfos[j].nDoorStaticObjectID)
			{
				Debug(("같은 ID 찾음 문 상태는 - " @ string(doorInfos[j].nDoorState)) @ string(o_npcInfos[i].ClassID));
				DoorState = doorInfos[j].nDoorState;
				// [Explicit Break]
				break;
			}
		}
		// End:0x10A
		if(DoorState == -1)
		{
			// [Explicit Continue]
			continue;			
		}
		else if(DoorState == 1)
		{
			Debug(GetDoorIcon(i).GetTextureName() @ "/" @ "L2UI_EPIC.WorldSiegeWnd.WorldSiegeWnd_CastleGateBroken_Normal");
			// End:0x221
			if("WorldSiegeWnd_CastleGateBroken_Normal" != GetDoorIcon(i).GetTextureName())
			{
				GetDoorIcon(i).SetAlpha(0);
				GetDoorIcon(i).SetTexture("L2UI_EPIC.WorldSiegeWnd.WorldSiegeWnd_CastleGateBroken_Normal");
			}
		}
		else
		{
			Debug(GetDoorIcon(i).GetTextureName() @ "/" @ "L2UI_EPIC.WorldSiegeWnd.WorldSiegeWnd_CastleGate_Normal");
			// End:0x31E
			if("WorldSiegeWnd_CastleGate_Normal" != GetDoorIcon(i).GetTextureName())
			{
				GetDoorIcon(i).SetAlpha(0);
				GetDoorIcon(i).SetTexture("L2UI_EPIC.WorldSiegeWnd.WorldSiegeWnd_CastleGate_Normal");
			}
		}
		GetDoorIcon(i).ShowWindow();
		GetDoorIcon(i).SetAlpha(255, 0.50f);
	}
}

function Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO packet;

	Debug("Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO");
	// End:0x57
	if(! class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO(packet))
	{
		return;
	}
	// End:0x6E
	if(! ChkCastleID(packet.nCastleID))
	{
		return;
	}
	Debug("HUD_INFO ---------------------------------------- start");
	Debug("HUD_INFO 점 령 체 - " @ string(packet.lstWorldCastleWar_MainBattleOccupyInfoList.Length));
	Debug("HUD_INFO 영웅무기 - " @ string(packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList.Length));
	Debug("HUD_INFO 영    웅 - " @ string(packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList.Length));
	Debug("HUD_INFO 골    렘 - " @ string(packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList.Length));
	Debug("HUD_INFO 성    벽 - " @ string(packet.lstWorldCastleWar_MainBattleDoorInfoList.Length));
	Debug("HUD_INFO ---------------------------------------- end");
	SetOccupyInfos(packet.lstWorldCastleWar_MainBattleOccupyInfoList);
	SetHeroWeaponInfos(packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList, true);
	SetHeroWeaponUserInfos(packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList);
	SetSiegeGolemInfos(packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList, true);
	SetDoorInfos(packet.lstWorldCastleWar_MainBattleDoorInfoList);
}

function EndWorldSiege()
{
	m_hOwnerWnd.HideWindow();
	HideAllOccupation();
	HideAllHeroIcons();
	HIdeAllHeroIconPCs();
	HideAllNPCIcons();
	HideAllGateIcons();
	mapObjOccupy.RemoveAll();
	mapObjHeroWeapon.RemoveAll();
	mapObjHeroWeaponUser.RemoveAll();
	mapObjGolem.RemoveAll();
}

function HideAllHeroIcons()
{
	local int i;

	// End:0x32 [Loop If]
	for(i = 0; i < 5; i++)
	{
		GetHeroIcon(i).HideWindow();
	}
}

function HIdeAllHeroIconPCs()
{
	local int i;

	// End:0x32 [Loop If]
	for(i = 0; i < 5; i++)
	{
		GetHeroPCIcon(i).HideWindow();
	}
}

function HideAllNPCIcons()
{
	local int i;

	// End:0x32 [Loop If]
	for(i = 0; i < 3; i++)
	{
		GetGolemIcon(i).HideWindow();
	}
}

function HideAllGateIcons()
{
	local int i;

	// End:0x32 [Loop If]
	for(i = 0; i < 3; i++)
	{
		GetDoorIcon(i).HideWindow();
	}
}

function HideAllOccupation()
{
	local int i;

	// End:0x55 [Loop If]
	for(i = 0; i < worldSiegeBoardOcptnObjects.Length; i++)
	{
		worldSiegeBoardOcptnObjects[i].GotoState(class'WorldSiegeBoardOcptnObject'.const.STATE_DESPAWN);
		worldSiegeBoardOcptnObjects[i].SendHideOccupyInfoRadar();
	}
}

function WindowHandle GetOccpyIcon(int Index)
{
	return GetWindowHandle(m_WindowName $ ".WorldSegeMapWnd.Icon_ocptnObjectWnd" $ (Int2Str(Index)));
}

function TextureHandle GetHeroIcon(int Index)
{
	return GetTextureHandle(m_WindowName $ ".WorldSegeMapWnd.Icon_Hero" $ (Int2Str(Index)));
}

function TextureHandle GetHeroPCIcon(int Index)
{
	return GetTextureHandle(m_WindowName $ ".WorldSegeMapWnd.Icon_HeroPC" $ (Int2Str(Index)));
}

function TextureHandle GetGolemIcon(int Index)
{
	return GetTextureHandle(m_WindowName $ ".WorldSegeMapWnd.Icon_NPC" $ (Int2Str(Index)));
}

function TextureHandle GetDoorIcon(int Index)
{
	return GetTextureHandle(m_WindowName $ ".WorldSegeMapWnd.Icon_CastleGate0" $ (Int2Str(Index)));
}

function MoveIcon(WindowHandle Icon, Vector worldLoc, optional float Second)
{
	local Vector mapPoint;
	local Rect rectMap, rectIcon;

	rectMap = Map_tex.GetRect();
	rectIcon = Icon.GetRect();
	mapPoint = GetMinimapPosFromWorldLoc(worldLoc);
	Icon.Move(int(mapPoint.X - float((rectIcon.nX - rectMap.nX) + (rectIcon.nWidth / 2))), int(mapPoint.Y - float((rectIcon.nY - rectMap.nY) + (rectIcon.nHeight / 2))), Second);
}

function HandlePos(string param)
{
	local Vector Loc;

	Loc = ParseVector(param);
	Loc = GetPlayerPosition();
	GetMinimapPosFromWorldLoc(Loc);
}

function SetIconPos(TextureHandle Icon, Vector Loc)
{
	local Vector mapPos;

	mapPos = GetMinimapPosFromWorldLoc(Loc);
	Icon.MoveTo(int(mapPos.X), int(mapPos.Y));
}

function API_C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO packet;

	// End:0x0B
	if(bHUDInfoReq)
	{
		return;
	}
	bHUDInfoReq = true;
	m_hOwnerWnd.SetTimer(TIMER_HUD_INFO_ID, TIMER_HUD_INFO_TIME);
	packet.nCastleID = GetCastleID();
	// End:0x77
	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO(stream, packet))
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO, stream);
	}
}

function API_GetWorldCastleWarMapInfo(EWorldCastleWarMapNPCType a_npcType, out array<WorldCastleWarMapData> o_npcInfo)
{
	GetWorldCastleWarMapInfo(a_npcType, o_npcInfo);
}

function Vector PositionToVector(UIPacket._Position pos)
{
	local Vector wolrdPoint;

	wolrdPoint.X = float(pos.X);
	wolrdPoint.Y = float(pos.Y);
	wolrdPoint.Z = float(pos.Z);
	return wolrdPoint;
}

function bool IsSameVector(Vector vec0, Vector vec1)
{
	return vec0 == vec1;
}

function bool ChkCastleID(int castleID)
{
	return castleID == (GetCastleID());
}

function int GetCastleID()
{
	return class'WorldSiegeWnd'.static.Inst().GetCastleIDSelected();
}

function Vector GetMinimapPosFromWorldLoc(Vector wlorldLoc)
{
	local Vector mapPosition;

	mapPosition.X = (wlorldLoc.X - startLoc.X) * MAP_SCALE;
	mapPosition.Y = (wlorldLoc.Y - startLoc.Y) * MAP_SCALE;
	return mapPosition;
}

function Vector ParseVector(string param)
{
	local Vector Loc;
	local int X, Y, Z;

	ParseInt(param, "x", X);
	ParseInt(param, "y", Y);
	ParseInt(param, "z", Z);
	Loc.X = X;
	Loc.Y = Y;
	Loc.Z = Z;
	return Loc;
}

function string Int2Str(int i)
{
	// End:0x19
	if(i < 10)
	{
		return "0" $ string(i);
	}
	return string(i);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
}

defaultproperties
{
}
