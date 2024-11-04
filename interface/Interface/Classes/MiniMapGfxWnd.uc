class MiniMapGfxWnd extends L2UIGFxScript;

var string tmpCurrentTelCost;

event OnRegisterEvent()
{
	RegisterGFxEventForLoaded(EV_Restart);
	RegisterGFxEventForLoaded(EV_MinimapChangeZone);
	RegisterGFxEvent(EV_ShowMinimap);
	RegisterGFxEvent(EV_BeginShowZoneTitleWnd);
	RegisterGFxEvent(EV_MinimapChangeZone);
	RegisterGFxEvent(EV_MinimapUpdateGameTime);
	RegisterGFxEvent(EV_PartyAddParty);
	RegisterGFxEvent(EV_PartyUpdateParty);
	RegisterGFxEvent(EV_PartyDeleteParty);
	RegisterGFxEvent(EV_PartyDeleteAllParty);
	RegisterGFxEvent(EV_StateChanged);
	RegisterGFxEvent(EV_AddCastleInfo);
	RegisterGFxEvent(EV_AddFortressInfo);
	RegisterGFxEvent(EV_AddAgitSiegeInfo);
	RegisterGFxEvent(EV_ShowSeedMapInfo);
	RegisterGFxEvent(EV_RaidServerInfo);
	RegisterGFxEvent(EV_ItemAuctionStatus);
	RegisterGFxEvent(EV_MinimapTreasureBoxLocation);
	RegisterGFxEvent(EV_MinimapCursedWeaponLocation);
	RegisterGFxEvent(EV_RaidBossSpawnInfo);
	RegisterGFxEvent(EV_InzoneWaitingInfo);
	RegisterGFxEvent(EV_FactionInfo);
	RegisterGFxEvent(EV_PvpbookKillerLocation);
	RegisterGFxEvent(EV_RenderDeviceRecreated);
	RegisterGFxEvent(EV_PkPenaltyInfoList);
	RegisterEvent(EV_ArriveShowQuest);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_RAID_TELEPORT_INFO);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterGFxEvent(EV_Test_8);
}

event OnLoad()
{
	SetSaveWnd(true, true);
	AddState("GAMINGSTATE");
	AddState("PAWNVIEWERSTATE");
	SetContainerWindow(WINDOWTYPE_NOBG_NODRAG, 447);
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_ArriveShowQuest:
			HandleArriveShowQuest(param);
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_RAID_TELEPORT_INFO):
			ParsePacket_S_EX_RAID_TELEPORT_INFO();
			break;
		case EV_UpdateUserInfo:
			HandleUpdateUserInfo();
			break;
	}
}

function HandleArriveShowQuest(string param)
{
	local int Level, RecentlyAddedQuestID;
	local string strParam, strTargetName;
	local Vector vTargetPos;

	ParseInt(param, "QuestID", RecentlyAddedQuestID);
	ParseInt(param, "QuestLevel", Level);

	if((RecentlyAddedQuestID > 0) && (Level > 0))
	{
		strTargetName = class'UIDATA_QUEST'.static.GetTargetName(RecentlyAddedQuestID, Level);
		vTargetPos = class'UIDATA_QUEST'.static.GetTargetLoc(RecentlyAddedQuestID, Level);
		ParamAdd(strParam, "X", string(vTargetPos.X));
		ParamAdd(strParam, "Y", string(vTargetPos.Y));
		ParamAdd(strParam, "Z", string(vTargetPos.Z));
		ParamAdd(strParam, "targetName", strTargetName);
		ParamAdd(strParam, "QuestID", string(RecentlyAddedQuestID));
		ParamAdd(strParam, "QuestLevel", string(Level));
		ParamAdd(strParam, "questName", class'UIDATA_QUEST'.static.GetQuestName(RecentlyAddedQuestID, Level));
		CallGFxFunction("MiniMapGfxWnd", "showQuestTargetInfo", strParam);
	}
}

event OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "ucExecuteCommand":
			if(param != "")
			{
				ExecuteCommand(param);
			}
			break;
		case "C_EX_RAID_TELEPORT_INFO":
			API_C_EX_RAID_TELEPORT_INFO();
			break;
		case "C_EX_TELEPORT_TO_RAID_POSITION":
			API_C_EX_TELEPORT_TO_RAID_POSITION(int(param));
			break;
		case "MinimapGfxWnd show popup":
			HandleShowTeleportPopup(param);
			break;
	}
}

event OnShow()
{
	
}

function ParsePacket_S_EX_RAID_TELEPORT_INFO()
{
	local UIPacket._S_EX_RAID_TELEPORT_INFO packet;

	if(!class'UIPacket'.static.Decode_S_EX_RAID_TELEPORT_INFO(packet))
	{
		return;
	}
	CallGFxFunction("MiniMapGfxWnd", "S_EX_RAID_TELEPORT_INFO", string(packet.nUsedFreeCount));
}

function API_C_EX_RAID_TELEPORT_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_RAID_TELEPORT_INFO packet;

	if(!class'UIPacket'.static.Encode_C_EX_RAID_TELEPORT_INFO(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_RAID_TELEPORT_INFO, stream);
}

function API_C_EX_TELEPORT_TO_RAID_POSITION(int nRaidID)
{
	local array<byte> stream;
	local UIPacket._C_EX_TELEPORT_TO_RAID_POSITION packet;

	packet.nRaidID = nRaidID;

	if(!class'UIPacket'.static.Encode_C_EX_TELEPORT_TO_RAID_POSITION(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_TELEPORT_TO_RAID_POSITION, stream);
}

function HandleUpdateUserInfo()
{
	if(getInstanceUIData().isLevelUP() || getInstanceUIData().IsLevelDown())
	{
		CallGFxFunction("MiniMapGfxWnd", "LevelChanged", "");
	}
}

function HandleShowTeleportPopup(string param)
{
	local array<string> priceInfo;

	// End:0x39
	if(class'UIDATA_PLAYER'.static.IsInPrison())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13773));
		tmpCurrentTelCost = "-1";
		return;
	}
	Split(param, "|", priceInfo);
	tmpCurrentTelCost = string(class'TeleportWnd'.static.Inst().GetTeleportCost(int64(priceInfo[0]), int(priceInfo[1]), int(priceInfo[2])));
}

defaultproperties
{
}
