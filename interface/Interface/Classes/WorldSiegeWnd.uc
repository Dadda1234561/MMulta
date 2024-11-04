class WorldSiegeWnd extends UICommonAPI;

const TIMER_BTNRECURIT = 1;
const TIMER_BTNRECURITREFRESH = 3000;
const DIALOGID_EXIT = 0;

enum TYPE_CONFIRM 
{
	RECRUIT,
	Teleport,
	OBSERVER
};

enum TYPE_TELEPORT 
{
	Left,
	MIDDLE,
	Right
};

enum WorldSiegeStateType 
{
	READY,
	Start,
	End
};

var int typeConfirm;
var int typeTeleport;
var bool IsSiegeMember;
var bool IsOnTimer;
var TextureHandle texturePledge;
var TextureHandle texturePledgeCrest;
var TextBoxHandle txtCastleName;
var TextBoxHandle txtSiegeState;
var TextBoxHandle txtPledgeName;
var TextBoxHandle txtPledgeMasterName;
var TextBoxHandle txtSiegeMercenaryConfirmDesc_Txt;
var WindowHandle SiegeMercenaryConfirmWnd;
var ButtonHandle btnRecruit;
var TextBoxHandle txtRecruit;
var int OwnerPledgeID;
var string OwnerPledgeName;
var string OwnerPledgeMasterName;
var int SiegeState;
var bool IsMercenaryRecruit;
var array<int> joinedCastleIDs;
var array<int> castleIDs;
var int SelectedIndex;

static function WorldSiegeWnd Inst()
{
	return WorldSiegeWnd(GetScript("WorldSiegeWnd"));
}

function Initialize()
{
	texturePledge = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WndCastleInfo.texturePledge");
	texturePledgeCrest = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WndCastleInfo.texturePledgeCrest");
	txtCastleName = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WndCastleInfo.txtCastleName");
	txtSiegeState = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WndCastleInfo.txtSiegeState");
	txtPledgeName = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WndCastleInfo.txtPledgeName");
	txtPledgeMasterName = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WndCastleInfo.txtPledgeMasterName");
	btnRecruit = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WndCastleInfo.btnRecruit");
	txtRecruit = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WndCastleInfo.txtRecruit");
	SiegeMercenaryConfirmWnd = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WndCastleInfo.SiegeMercenaryConfirmWnd");
	txtSiegeMercenaryConfirmDesc_Txt = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WndCastleInfo.SiegeMercenaryConfirmWnd.SiegeMercenaryConfirmDesc_Txt");
}

event OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO);
	RegisterEvent(EV_ObserverWndShow);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_StateChanged);
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
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO:
			Handle_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO();
			break;
		case EV_ObserverWndShow:
			m_hOwnerWnd.HideWindow();
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
		case EV_StateChanged:
			if(param != "GAMINGSTATE")
			{
				m_hOwnerWnd.HideWindow();
			}
			break;
	}
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "btnTeleportLeft":
			HandleBtnClickHelpTeleport(0);
			break;
		case "btnTeleportCenter":
			HandleBtnClickHelpTeleport(1);
			break;
		case "btnTeleportRight":
			HandleBtnClickHelpTeleport(2);
			break;
		case "btnAttend":
			GetWindowHandle("WorldSiegeInfoMCWWnd").ShowWindow();
			GetWindowHandle("WorldSiegeInfoMCWWnd").BringToFront();
			break;
		case "btnRecruit":
			HandleBtnClickRecruit();
			break;
		case "btnVolunteer":
			if(class'UIAPI_WINDOW'.static.IsShowWindow("WorldSiegeMercenaryWnd"))
			{
				class'UIAPI_WINDOW'.static.HideWindow("WorldSiegeMercenaryWnd");				
			}
			else
			{
				class'UIAPI_WINDOW'.static.ShowWindow("WorldSiegeMercenaryWnd");
			}
			break;
		case "SiegeMercenaryConfirmOK_Btn":
			HandleOK();
			SiegeMercenaryConfirmWnd.HideWindow();
			break;
		case "SiegeMercenaryConfirmCancle_Btn":
			SiegeMercenaryConfirmWnd.HideWindow();
			break;
		case "WindowHelp_BTN":
			HandleBtnClickHelp();
			break;
		case "btnObserver":
			HandleBtnClickObserver();
			break;
		case "btnExit":
			HandleOnClickBtnExit();
			break;
	}
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case TIMER_BTNRECURIT:
			IsOnTimer = false;
			m_hOwnerWnd.KillTimer(TimerID);
			SetbtnRecruitEnable();
			break;
	}
}

event OnShow()
{
	local WorldSiegeInfoMCWWnd worldSiegeInfoMCWWndScript;

	worldSiegeInfoMCWWndScript = class'WorldSiegeInfoMCWWnd'.static.Inst();
	SetbtnRecruitDisable();
	txtRecruit.SetText(GetSystemString(13058));
	joinedCastleIDs.Length = 0;
	SiegeMercenaryConfirmWnd.HideWindow();
	class'UIAPI_WINDOW'.static.HideWindow("WorldSiegeMercenaryWnd");
	worldSiegeInfoMCWWndScript.m_hOwnerWnd.HideWindow();
	IsSiegeMember = false;
	worldSiegeInfoMCWWndScript.API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST();
	m_hOwnerWnd.SetFocus();
}

function HandleOK()
{
	switch(typeConfirm)
	{
		case 0:
			if(IsMercenaryRecruit)
			{
				API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET(0);				
			}
			else
			{
				API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET(1);
			}
			m_hOwnerWnd.SetTimer(TIMER_BTNRECURIT, TIMER_BTNRECURITREFRESH);
			IsOnTimer = true;
			SetbtnRecruitDisable();
			break;
		case 1:
			API_C_EX_WORLDCASTLEWAR_TELEPORT(GetCurrentTeleportID());
			break;
		case 2:
			API_C_EX_WORLDCASTLEWAR_OBSERVER_START();
			break;
	}
}

function int GetCurrentTeleportID()
{
	switch(typeTeleport)
	{
		case 0:
			return GetTeleportIDL();
		case 1:
			return GetTeleportIDMiddle();
		case 2:
			return GetTeleportIDR();

		default:
			return -1;
	}
}

function int GetTeleportIDL()
{
	switch(castleIDs[SelectedIndex])
	{
		case 3:
			return 421;
		case 5:
			return 464;
		case 7:
			return 427;
	}
}

function int GetTeleportIDMiddle()
{
	switch(castleIDs[SelectedIndex])
	{
		case 3:
			return 420;
		case 5:
			return 463;
		case 7:
			return 426;
	}
}

function int GetTeleportIDR()
{
	switch(castleIDs[SelectedIndex])
	{
		case 3:
			return 419;
		case 5:
			return 462;
		case 7:
			return 425;
	}
}

function HandleBtnClickHelp()
{
	local string strParam;

	if(getInstanceUIData().getIsClassicServer())
	{
		ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "siege_help_world001.htm");
		ExecuteEvent(EV_ShowHelp, strParam);		
	}
	else
	{
		ExecuteEvent(EV_ShowHelp, "155");
	}
}

function HandleBtnClickRecruit()
{
	typeConfirm = 0;
	SetConfirm();
}

function HandleBtnClickHelpTeleport(int Type)
{
	typeConfirm = 1;
	typeTeleport = Type;
	SetConfirm();
}

function HandleBtnClickObserver()
{
	typeConfirm = 2;
	SetConfirm();
}

function SetbtnRecruitEnable()
{
	local UserInfo infUser;

	GetPlayerInfo(infUser);

	if(IsOnTimer)
	{
		return;
	}
	if(! IsSiegeMember)
	{
		return;
	}
	if(ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_bClanMaster == 0)
	{
		return;
	}
	if(ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_clanID != infUser.nClanID)
	{
		return;
	}
	txtRecruit.SetTextColor(GetColor(230, 217, 190, 255));
	btnRecruit.EnableWindow();
}

function SetbtnRecruitDisable()
{
	txtRecruit.SetTextColor(GetColor(120, 120, 120, 255));
	btnRecruit.DisableWindow();
}

function SetRecruit(int MercenaryRecruit)
{
	IsMercenaryRecruit = MercenaryRecruit > 0;
	IsSiegeMember = true;
	joinedCastleIDs.Length = joinedCastleIDs.Length + 1;
	joinedCastleIDs[joinedCastleIDs.Length - 1] = GetCastleIDSelected();
	SetbtnRecruitEnable();

	if(IsMercenaryRecruit)
	{
		txtRecruit.SetText(GetSystemString(13059));		
	}
	else
	{
		txtRecruit.SetText(GetSystemString(13058));
	}
}

function SetConfirm()
{
	switch(typeConfirm)
	{
		case 0:
			if(IsMercenaryRecruit)
			{
				txtSiegeMercenaryConfirmDesc_Txt.SetText(GetSystemString(13065));				
			}
			else
			{
				txtSiegeMercenaryConfirmDesc_Txt.SetText(GetSystemString(13064));
			}
			break;
		case 1:
			SetTeleportInfo();
			break;
		case 2:
			txtSiegeMercenaryConfirmDesc_Txt.SetText(GetSystemMessage(13091));
			break;
	}
	SiegeMercenaryConfirmWnd.ShowWindow();
	SiegeMercenaryConfirmWnd.SetFocus();
}

function string GetTeleportPositionName()
{
	switch(typeTeleport)
	{
		case 0:
			return GetSystemString(13051);
			break;
		case 1:
			return GetSystemString(13053);
			break;
		case 2:
			return GetSystemString(13052);
			break;
	}
}

function SetTeleportInfo()
{
	txtSiegeMercenaryConfirmDesc_Txt.SetText((MakeFullSystemMsg(GetSystemMessage(13166), MakeCostStringINT64(getInstanceUIData().GetTeleportPriceByID(GetCurrentTeleportID()))) $ "\\n\\n(" $ GetCastleName(castleIDs[SelectedIndex]) @ (GetTeleportPositionName())) $ ")");
}

function string GetMainTextureByClastleID(int castleID)
{
	switch(castleID)
	{
		case 3:
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleImg_Giran";
		case 5:
			return "L2UI_ct1.SiegeWnd.L2UI_CT1.SiegeWnd.SiegeWnd_MainImg";
		case 7:
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleImg_Godard";
		default:
			return "L2UI_ct1.SiegeWnd.L2UI_CT1.SiegeWnd.SiegeWnd_MainImg";
	}
}

function HandleOnClickBtnExit()
{
	DialogSetID(0);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13200), string(self));
}

function HandleDialogOK()
{
	if(! DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case 0:
			API_C_EX_WORLDCASTLEWAR_RETURN_TO_ORIGIN_PEER();
			break;
	}
}

function Handle_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO()
{
	local int castleID;
	local Texture PledgeCrestTexture, PledgeAllianceCrestTexture;
	local UIPacket._S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO packet;

	if(! class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO(packet))
	{
		return;
	}
	castleID = packet.nCastleID;
	OwnerPledgeID = packet.nCastleOwnerPledgeSID;
	OwnerPledgeName = packet.wstrCastleOwnerPledgeName;
	OwnerPledgeMasterName = packet.wstrCastleOwnerPledgeMasterName;
	SiegeState = packet.nSiegeState;
	API_AddPledgeInfo(packet.nCastleOwnerPledgeSID, packet.nCastleOwnerPledgeCrestDBID);
	txtCastleName.SetText(GetCastleName(castleID));
	texturePledge.SetTexture("");
	texturePledgeCrest.SetTexture("");

	if(class'UIDATA_CLAN'.static.GetCrestTexture(OwnerPledgeID, PledgeCrestTexture))
	{
		texturePledge.SetTextureWithObject(PledgeCrestTexture);
	}
	if(class'UIDATA_CLAN'.static.GetAllianceCrestTexture(OwnerPledgeID, PledgeAllianceCrestTexture))
	{
		texturePledgeCrest.SetTextureWithObject(PledgeAllianceCrestTexture);
	}
	GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WndCastleInfo.textureMainImg").SetTexture(GetMainTextureByClastleID(castleID));
	switch(SiegeState)
	{
		case 0:
			txtSiegeState.SetText(GetSystemString(13048));
			break;
		case 1:
			txtSiegeState.SetText(GetSystemString(13049));
			break;
		case 2:
			txtSiegeState.SetText(GetSystemString(13050));
			m_hOwnerWnd.HideWindow();
			break;

		default:
			break;
	}
	txtPledgeName.SetText(OwnerPledgeName);
	txtPledgeMasterName.SetText(OwnerPledgeMasterName);
	m_hOwnerWnd.ShowWindow();
}

function SetWorldCastleSiegeHUDInfo(int castleID, int State)
{
	if(! m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	if(SiegeState == 2)
	{
		m_hOwnerWnd.HideWindow();
		return;
	}
	if(castleIDs[SelectedIndex] != castleID)
	{
		return;
	}
	if(State == SiegeState)
	{
		return;
	}
	API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO();
}

function int GetCastleIDSelected()
{
	if(castleIDs.Length > 0 && SelectedIndex > -1)
	{
		return castleIDs[SelectedIndex];
	}
	return 5;
}

function API_C_EX_WORLDCASTLEWAR_TELEPORT(int TeleportID)
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_TELEPORT packet;

	packet.nTeleportID = TeleportID;

	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_TELEPORT(stream, packet))
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_TELEPORT, stream);
	}
}

function API_C_EX_WORLDCASTLEWAR_OBSERVER_START()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_OBSERVER_START packet;

	packet.nCastleID = GetCastleIDSelected();

	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_OBSERVER_START(stream, packet))
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_OBSERVER_START, stream);
	}
}

function API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO packet;

	packet.nCastleID = GetCastleIDSelected();
	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO(stream, packet))
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO, stream);
	}
}

function API_C_EX_WORLDCASTLEWAR_RETURN_TO_ORIGIN_PEER()
{
	local UserInfo UserInfo;
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_RETURN_TO_ORIGIN_PEER packet;

	GetPlayerInfo(UserInfo);
	packet.nUserSID = UserInfo.nID;
	packet.nCastleID = GetCastleIDSelected();

	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_RETURN_TO_ORIGIN_PEER(stream, packet))
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_RETURN_TO_ORIGIN_PEER, stream);
	}
}

function API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET(int recruitType)
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET packet;

	packet.nType = recruitType;
	packet.nIsMercenaryRecruit = recruitType;
	packet.nCastleID = GetCastleIDSelected();

	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET(stream, packet))
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET, stream);
	}
}

function API_AddPledgeInfo(int PledgeID, int PledgeCrestID)
{
	AddPledgeInfo(PledgeID, PledgeCrestID);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);

	if(SiegeMercenaryConfirmWnd.IsShowWindow())
	{
		SiegeMercenaryConfirmWnd.HideWindow();		
	}
	else
	{
		m_hOwnerWnd.HideWindow();
	}
}

function BuildiSet()
{
	local L2UITime l2UITimeStruct;
	local string worldSiegeStartCommand, worldSiegeEndCommand;
	local int StartTime, EndTime;

	StartTime = 10;
	EndTime = 10;

	if(! IsBuilderPC())
	{
		return;
	}
	if(IsPlayerOnWorldRaidServer())
	{
		l2UITimeStruct = class'UIData'.static.Inst().GetCurrentRealLocalTime();
		worldSiegeStartCommand = "//set_siege aden_castle" @ string(l2UITimeStruct.nYear) @ class'UIData'.static.Inst().Int2Str(l2UITimeStruct.nMonth) @ class'UIData'.static.Inst().Int2Str(l2UITimeStruct.nDay) @ class'UIData'.static.Inst().Int2Str(l2UITimeStruct.nHour) @ class'UIData'.static.Inst().Int2Str(l2UITimeStruct.nMin + StartTime);
		worldSiegeEndCommand = "//set_siege_end aden_castle" @ string(l2UITimeStruct.nYear) @ class'UIData'.static.Inst().Int2Str(l2UITimeStruct.nMonth) @ class'UIData'.static.Inst().Int2Str(l2UITimeStruct.nDay) @ class'UIData'.static.Inst().Int2Str(l2UITimeStruct.nHour) @ class'UIData'.static.Inst().Int2Str(l2UITimeStruct.nMin + EndTime);
		ClipboardCopy(worldSiegeStartCommand);		
	}
	else
	{
		ClipboardCopy("//goto_raid 62");
	}
}

defaultproperties
{
}
