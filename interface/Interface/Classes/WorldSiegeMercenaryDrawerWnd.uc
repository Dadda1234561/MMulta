class WorldSiegeMercenaryDrawerWnd extends UICommonAPI;

const TIME_ID = 1;
const TIME_REFRESH = 5000;
const TIMER_ENTRYID = 2;
const TIMER_ENTRYREFRESH = 5000;

var RichListCtrlHandle SiegeMercenaryEntry_List;
var TextBoxHandle SiegeMercenaryPledgeName_Txt;
var TextBoxHandle SiegeMercenaryUserName;
var TextBoxHandle SiegeMercenaryEntryNum01_Txt;
var TextBoxHandle SiegeMercenaryEntryNum02_Txt;
var TabHandle SiegeMercenaryTabCtrl;
var ButtonHandle SiegeMercenaryEntry_Btn;
var ButtonHandle SiegeMercenaryRefresh_Btn;
var TextureHandle SiegeMercenaryPledge_Tex;
var TextureHandle SiegeMercenaryPledgeCrest_Tex;
var WindowHandle SiegeMercenaryConfirmWnd;
var TextBoxHandle txtSiegeMercenaryConfirmDesc_Txt;
var TextBoxHandle SiegeMercenaryEntryCastle_Txt;
var bool IsMe;
var int m_PlayerClanID;
var int currentClanID;

static function WorldSiegeMercenaryDrawerWnd Inst()
{
	return WorldSiegeMercenaryDrawerWnd(GetScript("WorldSiegeMercenaryDrawerWnd"));
}

function Initialize()
{
	SiegeMercenaryEntry_List = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryEntry_List");
	SiegeMercenaryPledgeName_Txt = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryPledgeName_Txt");
	SiegeMercenaryUserName = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryUserName");
	SiegeMercenaryEntryNum01_Txt = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryEntryNum01_Txt");
	SiegeMercenaryEntryNum02_Txt = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryEntryNum02_Txt");
	SiegeMercenaryEntry_Btn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryEntry_Btn");
	SiegeMercenaryRefresh_Btn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryRefresh_Btn");
	SiegeMercenaryPledge_Tex = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryPledge_Tex");
	SiegeMercenaryPledgeCrest_Tex = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryPledgeCrest_Tex");
	SiegeMercenaryConfirmWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryConfirmWnd");
	txtSiegeMercenaryConfirmDesc_Txt = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryConfirmWnd.SiegeMercenaryConfirmDesc_Txt");
	SiegeMercenaryEntryCastle_Txt = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryEntryCastle_Txt");
	SiegeMercenaryEntryNum02_Txt.SetText("/100");
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		// End:0x31
		case 1:
			m_hOwnerWnd.KillTimer(TimerID);
			SiegeMercenaryRefresh_Btn.EnableWindow();
			// End:0x5C
			break;
		// End:0x59
		case 2:
			m_hOwnerWnd.KillTimer(TimerID);
			SiegeMercenaryEntry_Btn.EnableWindow();
	}
}

event OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN);
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
		// End:0x28
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST:
			Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST();
			// End:0x4C
			break;
		// End:0x49
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN:
			Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN();
			// End:0x4C
			break;
	}
}

event OnShow()
{
	m_hOwnerWnd.SetFocus();
	SiegeMercenaryConfirmWnd.HideWindow();
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		// End:0x35
		case "SiegeMercenaryClose_Btn":
			m_hOwnerWnd.HideWindow();
			// End:0xE3
			break;
		// End:0x5C
		case "SiegeMercenaryRefresh_Btn":
			HandleOnClickRefresh();
			// End:0xE3
			break;
		// End:0x81
		case "SiegeMercenaryEntry_Btn":
			HandleOnCLickEntryBtn();
			// End:0xE3
			break;
		// End:0xAA
		case "SiegeMercenaryConfirmOk_Btn":
			HandleOnCLickConfirmBtn();
			// End:0xE3
			break;
		// End:0xE0
		case "SiegeMercenaryConfirmCancle_Btn":
			SiegeMercenaryConfirmWnd.HideWindow();
			// End:0xE3
			break;
	}
}

function SetSiegeMercenary(int clanID, string ClanName, string PledgeMasterName)
{
	local Texture texPledge, texAlliance;
	local bool bPledge, bAlliance;

	currentClanID = clanID;
	API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST();
	bPledge = class'UIDATA_CLAN'.static.GetCrestTexture(clanID, texPledge);
	bAlliance = class'UIDATA_CLAN'.static.GetAllianceCrestTexture(clanID, texAlliance);
	SiegeMercenaryPledge_Tex.SetTexture("");
	SiegeMercenaryPledgeCrest_Tex.SetTexture("");
	SiegeMercenaryEntryCastle_Txt.SetText((GetSystemString(13203) @ ":") @ (GetCastleName(GetCastleID())));
	// End:0xDA
	if(bPledge)
	{
		SiegeMercenaryPledge_Tex.SetTextureWithObject(texPledge);
		// End:0xDA
		if(bAlliance)
		{
			SiegeMercenaryPledgeCrest_Tex.SetTextureWithObject(texAlliance);
		}
	}
	SiegeMercenaryPledgeName_Txt.SetText(ClanName);
	SiegeMercenaryUserName.SetText(PledgeMasterName);
	MakeCastleMark();
	m_hOwnerWnd.ShowWindow();
}

function MakeCastleMark()
{
	local TextureHandle castleMark;

	castleMark = GetTextureCatleIcon(0);
	castleMark.ShowWindow();
	castleMark.SetTexture(getInstanceL2Util().GetCastleMinIconName(GetCastleID()));
	castleMark.SetTooltipText(GetCastleName(GetCastleID()));
}

function Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST()
{
	local int i;
	local UIPacket._S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST packet;

	Debug("Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST");
	// End:0x5A
	if(! class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST(packet))
	{
		return;
	}
	// End:0x71
	if(packet.nCastleID != (GetCastleID()))
	{
		return;
	}
	// End:0x87
	if(packet.nPledgeSId != currentClanID)
	{
		return;
	}
	IsMe = false;
	SiegeMercenaryEntry_List.DeleteAllItem();

	// End:0xE9 [Loop If]
	for(i = 0; i < packet.lstWorldCastleWarMercenaryMemberList.Length; i++)
	{
		SiegeMercenaryEntry_List.InsertRecord(MakeData(packet.lstWorldCastleWarMercenaryMemberList[i]));
	}
	Debug("Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST -- end");
	SiegeMercenaryEntryNum01_Txt.SetText(string(SiegeMercenaryEntry_List.GetRecordCount()));
	// End:0x16F
	if(IsMe)
	{
		SiegeMercenaryEntry_Btn.SetButtonName(13104);		
	}
	else
	{
		SiegeMercenaryEntry_Btn.SetButtonName(13103);
	}
	class'WorldSiegeMercenaryWnd'.static.Inst().ModifyMercenaryMemberCount(SiegeMercenaryEntry_List.GetRecordCount(), packet.nPledgeSId);
}

function Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN()
{
	local UserInfo uInfo;
	local UIPacket._S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN packet;

	Debug("Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN step 0 - 0" @ string(packet.nResult) @ string(packet.nMercenaryPledgeSID));
	// End:0x78
	if(! GetPlayerInfo(uInfo))
	{
		return;
	}
	// End:0x93
	if(! class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN(packet))
	{
		return;
	}
	// End:0xA5
	if(packet.nResult == 0)
	{
		return;
	}
	// End:0xBB
	if(packet.nMercenaryPledgeSID != currentClanID)
	{
		return;
	}
	API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST();
}

function API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST packet;

	packet.nCastleID = GetCastleID();
	packet.nPledgeSId = currentClanID;
	// End:0x5F
	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST(stream, packet))
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST, stream);
	}
}

function API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN()
{
	local UserInfo uInfo;
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN packet;

	// End:0x12
	if(! GetPlayerInfo(uInfo))
	{
		return;
	}
	packet.nUserSID = uInfo.nID;
	Debug("API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN -- start");
	// End:0x84
	if(IsMe)
	{
		packet.nType = 0;		
	}
	else
	{
		packet.nType = 1;
	}
	packet.nCastleID = GetCastleID();
	packet.nMercenaryPledgeSID = currentClanID;
	Debug("API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN step 0" @ string(packet.nUserSID) @ string(packet.nType) @ string(packet.nCastleID) @ string(packet.nMercenaryPledgeSID));
	// End:0x16A
	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN(stream, packet))
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN, stream);
	}
}

function RichListCtrlRowData MakeData(UIPacket._WorldCastleWar_MercenaryMemberInfo memberInfo)
{
	local Color TextColor;
	local RichListCtrlRowData RowData;
	local string ClassType;

	RowData.cellDataList.Length = 2;
	if(memberInfo.nIsMyInfo == 1)
	{
		IsMe = true;
		TextColor = GetColor(255, 204, 0, 255);		
	}
	else if(memberInfo.nIsOnline == 1)
	{
		TextColor = GetColor(221, 221, 221, 255);			
	}
	else
	{
		TextColor = GetColor(128, 128, 128, 255);
	}
	RowData.cellDataList[0].HiddenStringForSorting = ConvertWorldIDToStr(memberInfo.wstrMercenaryName);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, ConvertWorldIDToStr(memberInfo.wstrMercenaryName), TextColor, false, 0, 0);
	// End:0x10D
	if(memberInfo.nIsOnline == 1)
	{
		TextColor = GetColor(187, 170, 187, 255);		
	}
	else
	{
		TextColor = GetColor(128, 128, 128, 255);
	}
	ClassType = GetClassType(memberInfo.nClassType);
	RowData.cellDataList[1].HiddenStringForSorting = ClassType;
	addRichListCtrlString(RowData.cellDataList[1].drawitems, ClassType, TextColor, false, 0, 0);
	return RowData;
}

function int GetCastleID()
{
	return class'WorldSiegeWnd'.static.Inst().GetCastleIDSelected();
}

function TextureHandle GetTextureCatleIcon(int Index)
{
	return GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryConfirmWnd.SiegeMercenaryEntryCastle_Tex") $ string(Index));
}

function HandleOnClickRefresh()
{
	SiegeMercenaryRefresh_Btn.DisableWindow();
	m_hOwnerWnd.SetTimer(TIME_ID, TIME_REFRESH);
	API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST();
}

function HandleOnCLickEntryBtn()
{
	// End:0x26
	if(IsMe)
	{
		txtSiegeMercenaryConfirmDesc_Txt.SetText(GetSystemString(13065));		
	}
	else
	{
		txtSiegeMercenaryConfirmDesc_Txt.SetText(GetSystemString(13066));
	}
	SiegeMercenaryConfirmWnd.ShowWindow();
}

function HandleOnCLickConfirmBtn()
{
	m_hOwnerWnd.SetTimer(TIMER_ENTRYID, TIMER_ENTRYREFRESH);
	SiegeMercenaryEntry_Btn.DisableWindow();
	API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN();
	SiegeMercenaryConfirmWnd.HideWindow();
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
}

defaultproperties
{
}
