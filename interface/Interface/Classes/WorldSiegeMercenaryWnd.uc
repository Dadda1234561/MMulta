class WorldSiegeMercenaryWnd extends UICommonAPI;

var RichListCtrlHandle SiegeMercenarySword_List;
var RichListCtrlHandle SiegeMercenaryShield_List;
var TextBoxHandle SiegeMercenaryRecruitNum_Txt;
var int m_PlayerClanID;
var int currentPledgeID;

static function WorldSiegeMercenaryWnd Inst()
{
	return WorldSiegeMercenaryWnd(GetScript("WorldSiegeMercenaryWnd"));
}

function Initialize()
{
	SiegeMercenarySword_List = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenarySword_List");
	SiegeMercenaryRecruitNum_Txt = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryRecruitNum_Txt");
}

event OnRegisterEvent()
{
	RegisterEvent(EV_WorldCastleWarSiegeAttackerListStart);
	RegisterEvent(EV_WorldCastleWarSiegeAttackerList);
	RegisterEvent(EV_WorldCastleWarSiegeAttackerListEnd);
}

event OnLoad()
{
	Initialize();
	SetClosingOnESC();
}

event OnEvent(int Event_ID, string param)
{
	// End:0x16
	if(! m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	switch(Event_ID)
	{
		// End:0x2E
		case EV_WorldCastleWarSiegeAttackerListStart:
			Handle_EV_WorldCastleWarSiegeAttackerListStart();
			// End:0x5D
			break;
		// End:0x44
		case EV_WorldCastleWarSiegeAttackerList:
			Handle_EV_WorldCastleWarSiegeAttackerList(param);
			// End:0x5D
			break;
		// End:0x5A
		case EV_WorldCastleWarSiegeAttackerListEnd:
			Handle_EV_WorldCastleWarSiegeAttackerListEnd(param);
			// End:0x5D
			break;
	}
}

event OnShow()
{
	m_hOwnerWnd.SetFocus();
	class'UIAPI_WINDOW'.static.HideWindow("WorldSiegeWnd");
	m_hOwnerWnd.SetAnchor("WorldSiegeWnd", "CenterCenter", "CenterCenter", 0, 0);
	m_hOwnerWnd.ClearAnchor();
	class'WorldSiegeInfoMCWWnd'.static.Inst().API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST();
	m_hOwnerWnd.SetFocus();
}

event OnHide()
{
	local WindowHandle worldSiegeWndHandle;

	worldSiegeWndHandle = class'WorldSiegeWnd'.static.Inst().m_hOwnerWnd;
	worldSiegeWndHandle.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "CenterCenter", "CenterCenter", 0, 0);
	worldSiegeWndHandle.ClearAnchor();
	worldSiegeWndHandle.ShowWindow();
	worldSiegeWndHandle.BringToFront();
	class'UIAPI_WINDOW'.static.HideWindow("WorldSiegeMercenaryDrawerWnd");
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	OnDBClickListCtrlRecord(ListCtrlID);
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	local int idx;
	local RichListCtrlRowData RowData;
	local string ClanName, PledgeMasterName;

	idx = SiegeMercenarySword_List.GetSelectedIndex();
	SiegeMercenarySword_List.GetRec(idx, RowData);
	ParseString(RowData.szReserved, "clanName", ClanName);
	ParseString(RowData.szReserved, "PledgeMasterName", PledgeMasterName);
	class'WorldSiegeMercenaryDrawerWnd'.static.Inst().SetSiegeMercenary(int(RowData.nReserved1), ClanName, ConvertWorldIDToStr(PledgeMasterName));
}

function Handle_EV_WorldCastleWarSiegeAttackerListStart()
{
	SiegeMercenarySword_List.DeleteAllItem();
}

function ModifyJoinType(int joinType, int clanID)
{
	local int Index, MercenaryMemberCount;
	local RichListCtrlRowData RowData;

	Index = FindRowIndexByClanID(clanID);
	// End:0x3B
	if(Index == -1)
	{
		class'WorldSiegeInfoMCWWnd'.static.Inst().API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST();
		return;
	}
	SiegeMercenarySword_List.GetRec(Index, RowData);
	MercenaryMemberCount = int(RowData.cellDataList[1].HiddenStringForSorting);
	// End:0x82
	if(joinType == 0)
	{
		MercenaryMemberCount--;		
	}
	else
	{
		MercenaryMemberCount++;
	}
	RowData.cellDataList[1].drawitems[1].strInfo.strData = string(MercenaryMemberCount);
	RowData.cellDataList[1].HiddenStringForSorting = num2Str(MercenaryMemberCount);
	SiegeMercenarySword_List.ModifyRecord(Index, RowData);
}

function ModifyMercenaryMemberCount(int MercenaryMemberCount, int clanID)
{
	local int Index;
	local RichListCtrlRowData RowData;

	Index = FindRowIndexByClanID(clanID);
	// End:0x3B
	if(Index == -1)
	{
		class'WorldSiegeInfoMCWWnd'.static.Inst().API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST();
		return;
	}
	SiegeMercenarySword_List.GetRec(Index, RowData);
	RowData.cellDataList[1].drawitems[1].strInfo.strData = string(MercenaryMemberCount);
	RowData.cellDataList[1].HiddenStringForSorting = num2Str(MercenaryMemberCount);
	SiegeMercenarySword_List.ModifyRecord(Index, RowData);
}

function SetMercenaryRecruited(int clanID, string ClanName, string PledgeMasterName, int MercenaryRecruit, int MercenaryMemberCount)
{
	local int Index;
	local RichListCtrlRowData RowData;

	RowData = MakeRowData(clanID, ConvertWorldIDToStr(ClanName), ConvertWorldIDToStr(PledgeMasterName), MercenaryRecruit, MercenaryMemberCount);
	Index = FindRowIndexByClanID(clanID);
	// End:0x68
	if(Index == -1)
	{
		SiegeMercenarySword_List.InsertRecord(RowData);		
	}
	else
	{
		SiegeMercenarySword_List.ModifyRecord(Index, RowData);
	}
}

function Handle_EV_WorldCastleWarSiegeAttackerList(string param)
{
	local int clanID;
	local string ClanName, PledgeMasterName;
	local int MercenaryRecruit, MercenaryMemberCount;

	ParseInt(param, "IsMercenaryRecruit", MercenaryRecruit);
	// End:0x31
	if(MercenaryRecruit < 1)
	{
		return;
	}
	ParseInt(param, "ClanID", clanID);
	ParseString(param, "ClanName", ClanName);
	ParseString(param, "ClanMasterName", PledgeMasterName);
	ParseInt(param, "CurrentMercenaryMemberCount", MercenaryMemberCount);
	SetMercenaryRecruited(clanID, ClanName, PledgeMasterName, MercenaryRecruit, MercenaryMemberCount);
}

function Handle_EV_WorldCastleWarSiegeAttackerListEnd(string param)
{
	SiegeMercenaryRecruitNum_Txt.SetText(string(SiegeMercenarySword_List.GetRecordCount()));
}

function RichListCtrlRowData MakeRowData(int clanID, string ClanName, string PledgeMasterName, int MercenaryRecruit, int MercenaryMemberCount)
{
	local RichListCtrlRowData RowData;
	local string szReserved;
	local Color clanNameColor;
	local int gabX, gabY, clanTexturesNum;
	local Texture PledgeAllianceCrestTexture, PledgeCrestTexture;

	RowData.cellDataList.Length = 3;
	RowData.nReserved1 = clanID;
	RowData.nReserved2 = MercenaryRecruit;
	szReserved = "";
	ParamAdd(szReserved, "clanName", ClanName);
	ParamAdd(szReserved, "PledgeMasterName", PledgeMasterName);
	RowData.szReserved = szReserved;
	// End:0x10E
	if(m_PlayerClanID > 0 && clanID == m_PlayerClanID)
	{
		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.SiegeReportWnd.SiegeReport_Flag", 16, 16, 0, 0);
		clanNameColor = GetColor(255, 204, 0, 255);
		gabX = 0;
		gabY = 2;		
	}
	else
	{
		clanNameColor = GetColor(211, 211, 211, 255);
		gabX = 16;
	}
	clanTexturesNum = RowData.cellDataList[0].drawitems.Length;
	// End:0x2F7
	if(class'UIDATA_CLAN'.static.GetAllianceCrestTexture(clanID, PledgeAllianceCrestTexture))
	{
		RowData.cellDataList[0].drawitems.Length = clanTexturesNum + 1;
		RowData.cellDataList[0].drawitems[clanTexturesNum].eType = LCDIT_TEXTURE;
		RowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.sTex = string(PledgeAllianceCrestTexture);
		RowData.cellDataList[0].drawitems[clanTexturesNum].nPosX = gabX;
		RowData.cellDataList[0].drawitems[clanTexturesNum].nPosY = gabY;
		RowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.Width = 8;
		RowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.Height = 12;
		RowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.V = 4;
		RowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.UL = 8;
		RowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.VL = 12;
		gabX = 0;
		gabY = 0;
		clanTexturesNum++;
	}
	// End:0x49E
	if(class'UIDATA_CLAN'.static.GetCrestTexture(clanID, PledgeCrestTexture))
	{
		RowData.cellDataList[0].drawitems.Length = clanTexturesNum + 1;
		RowData.cellDataList[0].drawitems[clanTexturesNum].eType = LCDIT_TEXTURE;
		RowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.sTex = string(PledgeCrestTexture);
		RowData.cellDataList[0].drawitems[clanTexturesNum].nPosX = gabX;
		RowData.cellDataList[0].drawitems[clanTexturesNum].nPosY = gabY;
		RowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.Width = 24;
		RowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.Height = 12;
		RowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.V = 4;
		RowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.UL = 24;
		RowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.VL = 12;
		gabX = 0;
	}
	addRichListCtrlString(RowData.cellDataList[0].drawitems, ClanName, clanNameColor, false, gabX, 0);
	RowData.cellDataList[0].HiddenStringForSorting = ClanName;
	addRichListCtrlString(RowData.cellDataList[1].drawitems, "/100", GetColor(211, 211, 211, 255), false, 20, 0);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, string(MercenaryMemberCount), GetColor(187, 170, 136, 255), false, 0, 0);
	RowData.cellDataList[1].HiddenStringForSorting = num2Str(MercenaryMemberCount);
	return RowData;
}

function int FindRowIndexByClanID(int clanID)
{
	local int i;
	local RichListCtrlRowData RowData;

	// End:0x5F [Loop If]
	for(i = 0; i < SiegeMercenarySword_List.GetRecordCount(); i++)
	{
		SiegeMercenarySword_List.GetRec(i, RowData);
		// End:0x55
		if(int(RowData.nReserved1) == clanID)
		{
			return i;
		}
	}
	return -1;
}

function int GetCastleID()
{
	return class'WorldSiegeWnd'.static.Inst().GetCastleIDSelected();
}

function string num2Str(int Num)
{
	// End:0x1A
	if(Num < 10)
	{
		return "00" $ string(Num);
	}
	// End:0x33
	if(Num < 100)
	{
		return "0" $ string(Num);
	}
	return string(Num);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
}

defaultproperties
{
}
