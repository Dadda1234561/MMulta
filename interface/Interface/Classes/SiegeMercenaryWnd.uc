//================================================================================
// SiegeMercenaryWnd.
//================================================================================

class SiegeMercenaryWnd extends UICommonAPI;

enum TYPE_TABORDER
{
    Attacker,
    DEFENDER
};

const TIME_REFRESH = 3000;
const TIMER_ID = 1;

var string m_WindowName;
var WindowHandle Me;
var RichListCtrlHandle SiegeMercenarySword_List;
var RichListCtrlHandle SiegeMercenaryShield_List;
var TextBoxHandle SiegeMercenaryRecruitNum_Txt;
var TabHandle SiegeMercenaryTabCtrl;
var int m_PlayerClanID;
var int currentPledgeID;
var int castleID;

function Initialize()
{
    Me = GetWindowHandle(m_WindowName);
    SiegeMercenarySword_List = GetRichListCtrlHandle(m_WindowName $ ".SiegeMercenarySword_List");
    SiegeMercenaryShield_List = GetRichListCtrlHandle(m_WindowName $ ".SiegeMercenaryShield_List");
    SiegeMercenaryRecruitNum_Txt = GetTextBoxHandle(m_WindowName $ ".SiegeMercenaryRecruitNum_Txt");
    SiegeMercenaryTabCtrl = GetTabHandle(m_WindowName $ ".SiegeMercenaryTabCtrl");
}

function OnRegisterEvent()
{
    RegisterEvent(EV_MCW_CastleSiegeAttackerListStart);
    RegisterEvent(EV_MCW_CastleSiegeAttackerListItem);
    RegisterEvent(EV_MCW_CastleSiegeAttackerListEnd);
    RegisterEvent(EV_MCW_CastleSiegeDefenderListStart);
    RegisterEvent(EV_MCW_CastleSiegeDefenderListItem);
    RegisterEvent(EV_MCW_CastleSiegeDefenderListEnd);
    RegisterEvent(EV_PledgeMercenaryMemberJoin);
}

function OnLoad()
{
    Initialize();
    SetClosingOnESC();
}

function OnEvent(int Event_ID, string param)
{
    if (!Me.IsShowWindow())
    {
        return;
    }
    Debug("OnEvent SiegeMercenaryWnd" @string(Event_ID) @param);
    switch (Event_ID)
    {
        case EV_MCW_CastleSiegeAttackerListStart:
            HandleSiegeInfoClanListStart(param, 0);
            break;
        case EV_MCW_CastleSiegeAttackerListItem:
            HandleSiegeInfoClanList(param, 0);
            break;
        case EV_MCW_CastleSiegeAttackerListEnd:
            HandleSiegeInfoClanListEnd(param, 0);
            break;
        case EV_MCW_CastleSiegeDefenderListStart:
            HandleSiegeInfoClanListStart(param, 1);
            break;
        case EV_MCW_CastleSiegeDefenderListItem:
            HandleSiegeInfoClanList(param, 1);
            break;
        case EV_MCW_CastleSiegeDefenderListEnd:
            HandleSiegeInfoClanListEnd(param, 1);
            break;
        case EV_PledgeMercenaryMemberJoin:
            HandlePledgeMercenaryMemberJoin(param);
            break;
    }
}

function OnShow()
{
    SiegeMercenaryTabCtrl.SetTopOrder(0, True);
    RequestMCWCastleSiegeAttackerListAll();
    Me.SetFocus();
    Class 'UIAPI_WINDOW'.static.HideWindow("SiegeWnd");
    Me.SetAnchor("SiegeWnd", "CenterCenter", "CenterCenter", 0, 0);
    Me.ClearAnchor();
}

function OnHide()
{
    Class 'UIAPI_WINDOW'.static.HideWindow("SiegeMercenaryDrawerWnd");
}

function OnClickButton(string strID)
{
    Debug("OnDefenseCancelClick" @strID);
    switch (strID)
    {
        case "SiegeMercenaryTabCtrl0":
            if (!SiegeMercenaryTabCtrl.IsEnableWindow())
            {
                return;
            }
            OnTabCtrl0Click();
            SiegeMercenaryTabCtrl.DisableWindow();
            Me.SetTimer(TIMER_ID, TIME_REFRESH);
            break;
        case "SiegeMercenaryTabCtrl1":
            if (!SiegeMercenaryTabCtrl.IsEnableWindow())
            {
                return;
            }
            OnTabCtrl1Click();
            SiegeMercenaryTabCtrl.DisableWindow();
            Me.SetTimer(TIMER_ID, TIME_REFRESH);
            break;
        default:
    }
}

function OnTimer(int TimerID)
{
    switch (TimerID)
    {
        case TIMER_ID:
            SiegeMercenaryTabCtrl.EnableWindow();
            break;
    }
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    OnDBClickListCtrlRecord(ListCtrlID);
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    local int idx;
    local RichListCtrlRowData rowData;
    local RichListCtrlHandle currentRichListCtrl;
    local string ClanName;
    local string PledgeMasterName;
    local string castleIDs;

    currentRichListCtrl = GetCurrentRichListCtrl();
    idx = currentRichListCtrl.GetSelectedIndex();
    currentRichListCtrl.GetRec(idx, rowData);
    ParseString(rowData.szReserved, "clanName", ClanName);
    ParseString(rowData.szReserved, "PledgeMasterName", PledgeMasterName);
    ParseString(rowData.szReserved, "castleIDs", castleIDs);
	SiegeMercenaryDrawerWnd(GetScript("SiegeMercenaryDrawerWnd")).SetSiegeMercenary(castleIDs, SiegeMercenaryTabCtrl.GetTopIndex(), int(RowData.nReserved1), ClanName, PledgeMasterName, int(RowData.cellDataList[1].szData));
	class'UIAPI_WINDOW'.static.ShowWindow("SiegeMercenaryDrawerWnd");
}

function HandleSiegeInfoClanListStart(string param, int Type)
{
    ParseInt(param, "castleID", castleID);
}

function string MakeSiegeListString(int Index, int Type)
{
    local RichListCtrlRowData Record;
    local string castleIDs;

    if (Index == -1)
    {
        return string(castleID);
    }
    SiegeMercenarySword_List.GetRec(Index, Record);
    if (Type == 0)
    {
        SiegeMercenarySword_List.GetRec(Index, Record);
    }
    else
    {
        if (Type == 1)
        {
            SiegeMercenaryShield_List.GetRec(Index, Record);
        }
    }
    ParseString(Record.szReserved, "castleIDs", castleIDs);
    castleIDs = castleIDs $ "/" $ string(castleID);
    return castleIDs;
}

function HandleSiegeInfoClanList(string param, int Type)
{
    local int Index;
    local int clanID;
    local string ClanName;
    local string PledgeMasterName;
    local RichListCtrlRowData rowData;
    local int MercenaryRecruit;
    local int MercenaryMemberCount;
    local int MercenaryReward;

    ParseInt(param, "MercenaryRecruit", MercenaryRecruit);
    if (MercenaryRecruit < 1)
    {
        return;
    }
    ParseInt(param, "PledgeID", clanID);
    Index = FindRowIndexByClanID(clanID);
    ParseString(param, "PledgeName", ClanName);
    ParseString(param, "PledgeMasterName", PledgeMasterName);
    ParseInt(param, "MercenaryMemberCount", MercenaryMemberCount);
    ParseInt(param, "MercenaryReward", MercenaryReward);
    rowData = MakeRowData(MakeSiegeListString(Index, Type), clanID, ClanName, PledgeMasterName,
        MercenaryRecruit, MercenaryMemberCount, MercenaryReward);
    if (Index == -1)
    {
        if (Type == 0)
        {
            SiegeMercenarySword_List.InsertRecord(rowData);
        }
        else
        {
            if (Type == 1)
            {
                SiegeMercenaryShield_List.InsertRecord(rowData);
            }
        }
    }
    else
    {
        if (Type == 0)
        {
            SiegeMercenarySword_List.ModifyRecord(Index, rowData);
        }
        else
        {
            if (Type == 1)
            {
                SiegeMercenaryShield_List.ModifyRecord(Index, rowData);
            }
        }
    }
}

function HandleSiegeInfoClanListEnd(string param, int Type)
{
    if (Type == 0)
    {
        SiegeMercenaryRecruitNum_Txt.SetText(string(SiegeMercenarySword_List.GetRecordCount()));
    }
    else
    {
        SiegeMercenaryRecruitNum_Txt.SetText(string(SiegeMercenaryShield_List.GetRecordCount()));
    }
}

function HandlePledgeMercenaryMemberJoin(string param)
{
    local int Result;

    ParseInt(param, "Result", Result);
    if (Result > 0)
    {
        switch (SiegeMercenaryTabCtrl.GetTopIndex())
        {
            case 0:
                RequestMCWCastleSiegeAttackerListAll();
                break;
            case 1:
                RequestMCWCastleSiegeDefenderListAll();
                break;
            default:
        }
        RequestMCWCastleSiegeAttackerListAll();
    }
    else
    {
    }
}

function RichListCtrlRowData MakeRowData(string castleIDs, int clanID, string ClanName,
    string PledgeMasterName, int MercenaryRecruit, int MercenaryMemberCount, int MercenaryReward)
{
    local RichListCtrlRowData rowData;
    local string szReserved;
    local Color clanNameColor;
    local int gabX;
    local int gabY;
    local int clanTexturesNum;
    local Texture PledgeAllianceCrestTexture;
    local Texture PledgeCrestTexture;

    rowData.cellDataList.Length = 3;
    rowData.nReserved1 = clanID;
    rowData.nReserved2 = MercenaryRecruit;
    szReserved = "";
    Debug("  ----  castleIds " @castleIDs);
    ParamAdd(szReserved, "clanName", ClanName);
    ParamAdd(szReserved, "PledgeMasterName", PledgeMasterName);
    ParamAdd(szReserved, "castleIDs", castleIDs);
    rowData.szReserved = szReserved;
    Debug("MakeRowData" @ClanName @PledgeMasterName);
    if ((m_PlayerClanID > 0) && (clanID == m_PlayerClanID))
    {
        addRichListCtrlTexture(rowData.cellDataList[0].drawitems,
            "L2UI_CT1.SiegeReportWnd.SiegeReport_Flag", 16, 16, 0, 0);
        clanNameColor = GetColor(255, 204, 0, 255);
        gabX = 0;
        gabY = 2;
    }
    else
    {
        clanNameColor = GetColor(211, 211, 211, 255);
        gabX = 16;
    }
    clanTexturesNum = rowData.cellDataList[0].drawitems.Length;
    if (Class 'UIDATA_CLAN'.static.GetAllianceCrestTexture(clanID, PledgeAllianceCrestTexture))
    {
        rowData.cellDataList[0].drawitems.Length = clanTexturesNum + 1;
        rowData.cellDataList[0].drawitems[clanTexturesNum].eType = LCDIT_TEXTURE;
        rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.sTex = string(PledgeAllianceCrestTexture);
        rowData.cellDataList[0].drawitems[clanTexturesNum].nPosX = gabX;
        rowData.cellDataList[0].drawitems[clanTexturesNum].nPosY = gabY;
        rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.Width = 8;
        rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.Height = 12;
        rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.V = 4;
        rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.UL = 8;
        rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.VL = 12;
        gabX = 0;
        gabY = 0;
        clanTexturesNum++;
    }
    if (Class 'UIDATA_CLAN'.static.GetCrestTexture(clanID, PledgeCrestTexture))
    {
        rowData.cellDataList[0].drawitems.Length = clanTexturesNum + 1;
        rowData.cellDataList[0].drawitems[clanTexturesNum].eType = LCDIT_TEXTURE;
        rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.sTex = string(PledgeCrestTexture);
        rowData.cellDataList[0].drawitems[clanTexturesNum].nPosX = gabX;
        rowData.cellDataList[0].drawitems[clanTexturesNum].nPosY = gabY;
        rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.Width = 24;
        rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.Height = 12;
        rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.V = 4;
        rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.UL = 24;
        rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.VL = 12;
        gabX = 0;
    }
    addRichListCtrlString(
        rowData.cellDataList[0].drawitems, ClanName, clanNameColor, False, gabX, 0);
    rowData.cellDataList[0].HiddenStringForSorting = ClanName;
    rowData.cellDataList[1].szData = string(MercenaryReward);
    addRichListCtrlString(rowData.cellDataList[1].drawitems, string(MercenaryReward) $ "%",
        GetColor(211, 211, 211, 255), False, 20, 0);
    rowData.cellDataList[1].HiddenStringForSorting = num2Str(100 - MercenaryReward);
    Debug("MakeRowData" @ClanName @string(MercenaryMemberCount));
    addRichListCtrlString(
        rowData.cellDataList[2].drawitems, "/100", GetColor(211, 211, 211, 255), False, 20, 0);
    addRichListCtrlString(rowData.cellDataList[2].drawitems, string(MercenaryMemberCount),
        GetColor(187, 170, 136, 255), False, 0, 0);
    rowData.cellDataList[2].HiddenStringForSorting = num2Str(MercenaryMemberCount);
    return rowData;
}

function int FindRowIndexByClanID(int clanID)
{
	local int i;
	local RichListCtrlHandle currentRichListCtrl;
	local RichListCtrlRowData rowData;

	currentRichListCtrl = GetCurrentRichListCtrl();
	for (i = 0; i < currentRichListCtrl.GetRecordCount(); i++)
	{
		currentRichListCtrl.GetRec(i, rowData);
		if(int(rowData.nReserved1) == clanID)
			return i;
	}
	return -1;
}

function int GetCastleID()
{
    local SiegeWnd siegeWndScript;

    siegeWndScript = SiegeWnd(GetScript("SiegeWnd"));
    return siegeWndScript.castleIDs[siegeWndScript.SelectedIndex];
}

function Color GetColor(int R, int G, int B, int A)
{
    local Color tColor;

    tColor.R = R;
    tColor.G = G;
    tColor.B = B;
    tColor.A = A;
    return tColor;
}

function OnTabCtrl0Click()
{
    RequestMCWCastleSiegeAttackerListAll();
}

function OnTabCtrl1Click()
{
    RequestMCWCastleSiegeDefenderListAll();
}

function RichListCtrlHandle GetCurrentRichListCtrl()
{
    switch (SiegeMercenaryTabCtrl.GetTopIndex())
    {
        case 0:
            return SiegeMercenarySword_List;
            break;
        case 1:
            return SiegeMercenaryShield_List;
            break;
        default:
            return SiegeMercenarySword_List;
            break;
    }
}

function API_RequestMCWCastleSiegeAttackerList(int castleID)
{
    Debug("API_RequestMCWCastleSiegeAttackerList" @string(castleID));
    if (castleID > 0)
    {
        Class 'SiegeAPI'.static.RequestMCWCastleSiegeAttackerList(castleID);
    }
}

function API_RequestMCWCastleSiegeDefenderList(int castleID)
{
    Debug("API_RequestMCWCastleSiegeDefenderList" @string(castleID));
    if (castleID > 0)
    {
        Class 'SiegeAPI'.static.RequestMCWCastleSiegeDefenderList(castleID);
    }
}

function GetPledgeID()
{
    local UserInfo infUser;

    currentPledgeID = -1;
    m_PlayerClanID = 0;
    if (GetPlayerInfo(infUser))
    {
        m_PlayerClanID = infUser.nClanID;
    }
}

function RequestMCWCastleSiegeAttackerListAll()
{
    local int i;
    local array<int> castleIDs;

    castleIDs = GetCastleIds();
    GetPledgeID();
    SiegeMercenarySword_List.DeleteAllItem();

    for (i = 0; i < castleIDs.Length; i++)
    {
        API_RequestMCWCastleSiegeAttackerList(castleIDs[i]);
    }
}

function RequestMCWCastleSiegeDefenderListAll()
{
    local int i;
    local array<int> castleIDs;

    castleIDs = GetCastleIds();
    GetPledgeID();
    SiegeMercenaryShield_List.DeleteAllItem();

    for (i = 0; i < castleIDs.Length; i++)
    {
        API_RequestMCWCastleSiegeDefenderList(castleIDs[i]);
    }
}

function array<int> GetCastleIds()
{
    return SiegeWnd(GetScript("SiegeWnd")).castleIDs;
}

function string num2Str(int Num)
{
    if (Num < 10)
    {
        return "00" $ string(Num);
    }
    if (Num < 100)
    {
        return "0" $ string(Num);
    }
    return string(Num);
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(IFST_WINDOW_CLOSE);
    Me.HideWindow();
}

defaultproperties
{
     m_WindowName="SiegeMercenaryWnd"
}
