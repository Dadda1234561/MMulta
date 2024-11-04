class WorldSiegeRankingWnd extends UICommonAPI;

const TIMER_RANKING_ID = 10;
const TIMER_RANKING_TIME = 30000;

var RichListCtrlHandle Ranking_RichList;
var TextBoxHandle WorldSiegeDate_Text;
var TextBoxHandle CastleName_Text;
var TextBoxHandle SiegeInfo_Text;
var TextBoxHandle Myclan_Text;
var TextBoxHandle MyclanRankingEquality_Text;
var TextBoxHandle MyWorldSiegeName_Text;
var TextBoxHandle MyWorldSiegeRankingText;
var TextBoxHandle MyclanRankingDisable_Text;
var TextBoxHandle MyWorldSiegeRankingDisable_Text;
var TextBoxHandle MyWorldSiegeRankingEquality_Text;
var TextBoxHandle MyclanRankingText;
var TextBoxHandle WorldSiegeDate02_Text;
var TabHandle Ranking_Tab;
var array<UIPacket._WorldCastleWar_RankingInfo> lstPledgeRankingList;
var array<UIPacket._WorldCastleWar_RankingInfo> lstPersonalRankingList;
var bool bRnkingCooltime;
var int myPledgeRank;
var int myRank;

static function WorldSiegeRankingWnd Inst()
{
	return WorldSiegeRankingWnd(GetScript("WorldSiegeRankingWnd"));
}

function Init()
{
	Ranking_RichList = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.Ranking_RichList");
	WorldSiegeDate_Text = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.WorldSiegeDate_Text");
	CastleName_Text = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.CastleName_Text");
	SiegeInfo_Text = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.WorldSiegeDate_Text");
	Myclan_Text = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.Myclan_Text");
	MyclanRankingEquality_Text = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyclanRankingEquality_Text");
	MyWorldSiegeName_Text = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyWorldSiegeName_Text");
	MyWorldSiegeRankingText = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyWorldSiegeRankingText");
	MyWorldSiegeRankingEquality_Text = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyWorldSiegeRankingEquality_Text");
	MyclanRankingText = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyclanRankingText");
	WorldSiegeDate02_Text = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.WorldSiegeDate02_Text");
	Ranking_Tab = GetTabHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_Tab");
	SiegeInfo_Text.SetText(GetSystemString(13050));
	MyclanRankingDisable_Text = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyclanRankingDisable_Text");
	MyWorldSiegeRankingDisable_Text = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyWorldSiegeRankingDisable_Text");
	Ranking_RichList.SetSelectable(false);
}

event OnTimer(int Id)
{
	switch(Id)
	{
		// End:0x2B
		case TIMER_RANKING_ID:
			m_hOwnerWnd.KillTimer(Id);
			bRnkingCooltime = false;
			// End:0x2E
			break;
	}
}

event OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO);
	RegisterEvent(40);
}

event OnLoad()
{
	SetClosingOnESC();
	Init();
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x28
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO:
			Handle_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO();
			// End:0x7B
			break;
		// End:0x49
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO:
			Handle_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO();
			// End:0x7B
			break;
		// End:0x6A
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO:
			Handle_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO();
			// End:0x7B
			break;
		// End:0x78
		case EV_Restart:
			Handle_Restart();
			// End:0x7B
			break;
	}
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		// End:0x36
		case "Ranking_Tab0":
			Ranking_RichList.SetColumnString(1, 580);
			makeList();
			// End:0x68
			break;
		// End:0x65
		case "Ranking_Tab1":
			Ranking_RichList.SetColumnString(1, 393);
			makeList();
			// End:0x68
			break;
	}
}

event OnShow()
{
	API_RequestRankingInfo();
	m_hOwnerWnd.SetFocus();
}

function Handle_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO packet;
	local L2UITime L2UITime;

	// End:0x5D
	if(! class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO(packet))
	{
		return;
	}
	// End:0x74
	if(! ChkCastleID(packet.nCastleID))
	{
		return;
	}
	GetTimeStruct(packet.nNextSiegeTime, L2UITime);
	WorldSiegeDate02_Text.SetText(GetSystemString(13888) $ "\\n" $ string(L2UITime.nYear) $ "." $ string(L2UITime.nMonth) $ "." $ string(L2UITime.nDay) @ "[" $ class'UIData'.static.Inst().Int2Str(L2UITime.nHour) $ ":" $ class'UIData'.static.Inst().Int2Str(L2UITime.nMin) $ "]");
}

function Handle_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO(packet))
	{
		return;
	}
	// End:0x32
	if(! ChkCastleID(packet.nCastleID))
	{
		return;
	}
	lstPledgeRankingList = packet.lstPledgeRankingList;
	lstPersonalRankingList = packet.lstPersonalRankingList;
	WorldSiegeDate_Text.SetText(GetSystemString(3701));
	CastleName_Text.SetText(GetCastleName(packet.nCastleID));
	Debug("Handle_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO stp :" @ GetCastleName(packet.nCastleID) @ string(packet.lstPledgeRankingList.Length) @ string(packet.lstPersonalRankingList.Length));
	makeList();
	setResult(true);
}

function Handle_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO packet;
	local UserInfo uInfo;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO(packet))
	{
		return;
	}
	// End:0x32
	if(! ChkCastleID(packet.nCastleID))
	{
		return;
	}
	lstPledgeRankingList = packet.lstPledgeRankingList;
	lstPersonalRankingList = packet.lstPersonalRankingList;
	CastleName_Text.SetText(GetCastleName(packet.nCastleID));
	Debug("Handle_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO stp :" @ GetCastleName(packet.nCastleID) @ string(class'NoticeHUD'.static.Inst().worldsiegeState) @ string(packet.lstPledgeRankingList.Length) @ string(packet.lstPersonalRankingList.Length));
	makeList();
	// End:0x258
	if(class'NoticeHUD'.static.Inst().worldsiegeState == class'NoticeHUD'.static.Inst().WorldSiegeStateType.Start)
	{
		WorldSiegeDate_Text.SetText(GetSystemString(3700));
		// End:0x1A2
		if(GetPlayerInfo(uInfo))
		{
			Myclan_Text.SetText(class'UIDATA_CLAN'.static.GetName(uInfo.nClanID));
			MyWorldSiegeName_Text.SetText(uInfo.Name);
		}
		myPledgeRank = packet.nMyPledgeRank;
		myRank = packet.nMyRank;
		MyclanRankingText.SetText(string(myPledgeRank));
		MyclanRankingEquality_Text.SetText(MakeCostString(string(packet.nMyPledgeSiegePoint)));
		MyWorldSiegeRankingEquality_Text.SetText(string(myRank));
		MyWorldSiegeRankingText.SetText(MakeCostString(string(packet.nMySiegePoint)));
		MyclanRankingDisable_Text.HideWindow();
		MyWorldSiegeRankingDisable_Text.HideWindow();
		setResult(false);		
	}
	else
	{
		WorldSiegeDate_Text.SetText(GetSystemString(3701));
		setResult(true);
	}
}

function Handle_Restart()
{
	Ranking_RichList.DeleteAllItem();
	SiegeInfo_Text.SetText(GetSystemString(13050));
	bRnkingCooltime = false;
	m_hOwnerWnd.KillTimer(TIMER_RANKING_ID);
}

function setResult(bool bResult)
{
	// End:0x92
	if(bResult)
	{
		MyclanRankingDisable_Text.HideWindow();
		MyWorldSiegeRankingDisable_Text.HideWindow();
		Myclan_Text.SetText("-");
		MyWorldSiegeName_Text.SetText("-");
		MyclanRankingText.SetText("");
		MyclanRankingEquality_Text.SetText("");
		MyWorldSiegeRankingEquality_Text.SetText("");
		MyWorldSiegeRankingText.SetText("");		
	}
	else
	{
		MyclanRankingDisable_Text.HideWindow();
		MyWorldSiegeRankingDisable_Text.HideWindow();
		WorldSiegeDate02_Text.SetText("");
	}
}

function DelegateGroupButtonOnClickButton(string parentWndName, string strName, int Index)
{
	makeList();
}

function API_C_EX_WORLDCASTLEWAR_CASTLE_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_CASTLE_INFO packet;

	packet.nCastleID = GetCastleID();
	// End:0x91
	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_CASTLE_INFO(stream, packet))
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_CASTLE_INFO, stream);
		Debug("API_C_EX_WORLDCASTLEWAR_CASTLE_INFO 요청 합 " @ string(packet.nCastleID));
	}
}

function API_C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO packet;

	packet.nCastleID = GetCastleID();
	// End:0xA1
	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO(stream, packet))
	{
		Debug("Encode_C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO : " @ string(packet.nCastleID));
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO, stream);
	}
}

function API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO packet;

	Debug("Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO : " @ string(GetCastleID()));
	packet.nCastleID = GetCastleID();
	// End:0xE5
	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO(stream, packet))
	{
		Debug("Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO : " @ string(packet.nCastleID));
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO, stream);
	}
}

function array<UIPacket._WorldCastleWar_RankingInfo> MakeTestList()
{
	local int i;
	local array<UIPacket._WorldCastleWar_RankingInfo> currentRankingList;

	currentRankingList.Length = 100;

	// End:0xB8 [Loop If]
	for(i = 0; i < 100; i++)
	{
		currentRankingList[i].nRank = i + 1;
		// End:0x72
		if(Ranking_Tab.GetTopIndex() == 0)
		{
			currentRankingList[i].sName = "혈맹 name" @ string(i);			
		}
		else
		{
			currentRankingList[i].sName = "name" @ string(i);
		}
		currentRankingList[i].nSiegePoint = i * 100;
	}
	myPledgeRank = 1;
	myRank = 100;
	return currentRankingList;
}

function makeList()
{
	local int i, currentRank;
	local RichListCtrlRowData RowData;
	local array<UIPacket._WorldCastleWar_RankingInfo> currentRankingList;

	switch(Ranking_Tab.GetTopIndex())
	{
		// End:0x2E
		case 0:
			currentRankingList = lstPledgeRankingList;
			currentRank = myPledgeRank;
			// End:0x4E
			break;
		// End:0x4B
		case 1:
			currentRankingList = lstPersonalRankingList;
			currentRank = myRank;
			// End:0x4E
			break;
	}
	Ranking_RichList.DeleteAllItem();

	// End:0xB0 [Loop If]
	for(i = 0; i < currentRankingList.Length; i++)
	{
		// End:0xA6
		if(MakeRowData(currentRankingList[i], currentRank, RowData))
		{
			Ranking_RichList.InsertRecord(RowData);
		}
	}
}

function bool MakeRowData(UIPacket._WorldCastleWar_RankingInfo rankingInfo, int currentRank, out RichListCtrlRowData RowData)
{
	local Color C;

	RowData.cellDataList.Length = 3;
	RowData.cellDataList[0].drawitems.Length = 0;
	RowData.cellDataList[1].drawitems.Length = 0;
	RowData.cellDataList[2].drawitems.Length = 0;
	RowData.cellDataList[0].szData = string(rankingInfo.nRank);
	RowData.cellDataList[1].szData = ConvertWorldIDToStr(rankingInfo.sName);
	RowData.cellDataList[2].szData = string(rankingInfo.nSiegePoint);
	C = getInstanceL2Util().BrightWhite;
	// End:0xFE
	if(rankingInfo.nRank < 6)
	{
		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, GetRankingImg(rankingInfo.nRank), 38, 33);		
	}
	else
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, RowData.cellDataList[0].szData, C, false, 14);
	}
	addRichListCtrlString(RowData.cellDataList[1].drawitems, RowData.cellDataList[1].szData, C);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, MakeCostString(RowData.cellDataList[2].szData), C);
	return true;
}

function string GetRankingImg(int Ranking)
{
	switch(Ranking)
	{
		// End:0x30
		case 1:
			return "L2UI_CT1.RankingWnd.RankingWnd_1st";
		// End:0x5A
		case 2:
			return "L2UI_CT1.RankingWnd.RankingWnd_2nd";
		// End:0x84
		case 3:
			return "L2UI_CT1.RankingWnd.RankingWnd_3rd";
		// End:0xB0
		case 4:
			return "L2UI_EPIC.SuppressWnd.RankingWnd_4th";
		// End:0xDC
		case 5:
			return "L2UI_EPIC.SuppressWnd.RankingWnd_5th";
		// End:0xFFFF
		default:
			return "L2UI_CT1.EmptyBtn";
	}
}

function API_RequestRankingInfo()
{
	// End:0x0B
	if(bRnkingCooltime)
	{
		return;
	}
	bRnkingCooltime = true;
	m_hOwnerWnd.SetTimer(TIMER_RANKING_ID, TIMER_RANKING_TIME);
	// End:0x41
	if(IsPlayerOnWorldRaidServer())
	{
		API_C_EX_WORLDCASTLEWAR_CASTLE_INFO();
		API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO();		
	}
	else
	{
		API_C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO();
	}
}

function int GetCastleID()
{
	local int castleID;

	castleID = class'WorldSiegeWnd'.static.Inst().GetCastleIDSelected();
	// End:0x32
	if(castleID < 1)
	{
		castleID = 5;
	}
	return castleID;
}

function bool ChkCastleID(int castleID)
{
	return castleID == GetCastleID();
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
}

defaultproperties
{
}
