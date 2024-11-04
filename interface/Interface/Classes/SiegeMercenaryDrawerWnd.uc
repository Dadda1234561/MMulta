//================================================================================
// SiegeMercenaryDrawerWnd.
//================================================================================

class SiegeMercenaryDrawerWnd extends UICommonAPI;

enum TYPE_TABORDER
{
    Attacker,
    DEFENDER
};

const TIMER_ENTRYREFRESH = 5000;
const TIME_REFRESH = 5000;
const TIME_ID = 1;
const TIMER_ENTRYID = 2;

var string m_WindowName;
var WindowHandle Me;
var RichListCtrlHandle SiegeMercenaryEntry_List;
var TextureHandle SiegeMercenaryMark_Tex;
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
var TextBoxHandle EntryNum01_Txt;
var bool IsMe;
var int m_PlayerClanID;
var int currentClanID;
var array<int> castleIDs;

function Initialize()
{
    Me = GetWindowHandle(m_WindowName);
    SiegeMercenaryEntry_List = GetRichListCtrlHandle(m_WindowName $ ".SiegeMercenaryEntry_List");
    SiegeMercenaryTabCtrl = GetTabHandle(m_WindowName $ ".SiegeMercenaryTabCtrl");
    SiegeMercenaryMark_Tex = GetTextureHandle(m_WindowName $ ".SiegeMercenaryMark_Tex");
    SiegeMercenaryPledgeName_Txt = GetTextBoxHandle(m_WindowName $ ".SiegeMercenaryPledgeName_Txt");
    SiegeMercenaryUserName = GetTextBoxHandle(m_WindowName $ ".SiegeMercenaryUserName");
    EntryNum01_Txt = GetTextBoxHandle(m_WindowName $ ".EntryNum01_Txt");
    SiegeMercenaryEntryNum01_Txt = GetTextBoxHandle(m_WindowName $ ".SiegeMercenaryEntryNum01_Txt");
    SiegeMercenaryEntryNum02_Txt = GetTextBoxHandle(m_WindowName $ ".SiegeMercenaryEntryNum02_Txt");
    SiegeMercenaryEntry_Btn = GetButtonHandle(m_WindowName $ ".SiegeMercenaryEntry_Btn");
    SiegeMercenaryRefresh_Btn = GetButtonHandle(m_WindowName $ ".SiegeMercenaryRefresh_Btn");
    SiegeMercenaryPledge_Tex = GetTextureHandle(m_WindowName $ ".SiegeMercenaryPledge_Tex");
    SiegeMercenaryPledgeCrest_Tex
        = GetTextureHandle(m_WindowName $ ".SiegeMercenaryPledgeCrest_Tex");
    SiegeMercenaryConfirmWnd = GetWindowHandle(m_WindowName $ ".SiegeMercenaryConfirmWnd");
    txtSiegeMercenaryConfirmDesc_Txt = GetTextBoxHandle(
        m_WindowName $ ".SiegeMercenaryConfirmWnd.SiegeMercenaryConfirmDesc_Txt");
    SiegeMercenaryEntryNum02_Txt.SetText("/100");
}

function OnTimer(int TimerID)
{
    switch (TimerID)
    {
        case TIME_ID:
            Me.KillTimer(TimerID);
            SiegeMercenaryRefresh_Btn.EnableWindow();
            break;
        case TIMER_ENTRYID:
            Me.KillTimer(TimerID);
            SiegeMercenaryEntry_Btn.EnableWindow();
        default:
    }
}

function OnRegisterEvent()
{
    RegisterEvent(EV_PledgeMercenaryMemberListStart);
    RegisterEvent(EV_PledgeMercenaryMemberListItem);
    RegisterEvent(EV_PledgeMercenaryMemberListEnd);
    RegisterEvent(EV_PledgeMercenaryMemberJoin);
}

function OnLoad()
{
    Initialize();
    SetClosingOnESC();
}

function OnEvent(int Event_ID, string param)
{
    Debug("OnEvent" @string(Event_ID) @param);
    switch (Event_ID)
    {
        case EV_PledgeMercenaryMemberListStart:
            HandleMercenaryMemberListStart(param);
            break;
        case EV_PledgeMercenaryMemberListItem:
            HandleMercenaryMemberList(param);
            break;
        case EV_PledgeMercenaryMemberListEnd:
            HandleMercenaryMemberListEnd(param);
            break;
        case EV_PledgeMercenaryMemberJoin:
            HandlePledgeMercenaryMemberJoin(param);
            break;
        default:
    }
}

function OnShow()
{
    Me.SetFocus();
    SiegeMercenaryConfirmWnd.HideWindow();
}

function OnClickButton(string strID)
{
    switch (strID)
    {
        case "SiegeMercenaryClose_Btn":
            Me.HideWindow();
            break;
        case "SiegeMercenaryRefresh_Btn":
            HandleOnClickRefresh();
            break;
        case "SiegeMercenaryEntry_Btn":
            HandleOnCLickEntryBtn();
            break;
        case "SiegeMercenaryConfirmOk_Btn":
            HandleOnCLickConfirmBtn();
            break;
        case "SiegeMercenaryConfirmCancle_Btn":
            SiegeMercenaryConfirmWnd.HideWindow();
            break;
        default:
    }
}

function HandleMercenaryMemberListStart(string param)
{
    IsMe = False;
    SiegeMercenaryEntry_List.DeleteAllItem();
}

function HandleMercenaryMemberList(string param)
{
    local int IsMeInt;
    local int IsOnline;
    local string Name;
    local string ClassType;
    local int ClassID;
    local Color TextColor;
    local RichListCtrlRowData rowData;

    ParseInt(param, "IsMe", IsMeInt);
    ParseInt(param, "IsOnline", IsOnline);
    ParseString(param, "Name", Name);
    ParseInt(param, "ClassID", ClassID);
    rowData.cellDataList.Length = 2;
    if (IsMeInt > 0)
    {
        IsMe = True;
        TextColor = GetColor(255, 204, 0, 255);
    }
    else
    {
        if (IsOnline > 0)
        {
            TextColor = GetColor(221, 221, 221, 255);
        }
        else
        {
            TextColor = GetColor(128, 128, 128, 255);
        }
    }
    rowData.cellDataList[0].HiddenStringForSorting = Name;
    addRichListCtrlString(rowData.cellDataList[0].drawitems, Name, TextColor, False, 0, 0);
    if (IsOnline > 0)
    {
        TextColor = GetColor(187, 170, 187, 255);
    }
    else
    {
        TextColor = GetColor(128, 128, 128, 255);
    }
    ClassType = GetClassType(ClassID);
    rowData.cellDataList[1].HiddenStringForSorting = ClassType;
    addRichListCtrlString(rowData.cellDataList[1].drawitems, ClassType, TextColor, False, 0, 0);
    SiegeMercenaryEntry_List.InsertRecord(rowData);
}

function HandleMercenaryMemberListEnd(string param)
{
    SiegeMercenaryEntryNum01_Txt.SetText(string(SiegeMercenaryEntry_List.GetRecordCount()));
    if (IsMe)
    {
        SiegeMercenaryEntry_Btn.SetButtonName(13104);
    }
    else
    {
        SiegeMercenaryEntry_Btn.SetButtonName(13103);
    }
}

function HandlePledgeMercenaryMemberJoin(string param)
{
    local int Result;

    ParseInt(param, "Result", Result);
    if (Result > 0)
    {
        API_RequestPledgeMercenaryMemberList(currentClanID);
    }
}

function MakeCastleIds(string castleIDsStr)
{
    local array<string> castleIDsStrs;
    local int i;
    local TextureHandle castleMark;

    Split(castleIDsStr, "/", castleIDsStrs);

    for (i = 0;i < getInstanceUIData().CASTLE_NUM_TOTAL;i++)
    {
        GetTextureCatleIcon(i).HideWindow();
    }
    castleIDs.Length = castleIDsStrs.Length;
   
    for ( i = 0;i < castleIDsStrs.Length;i++)
    {
        castleIDs[i] = int(castleIDsStrs[i]);
        castleMark = GetTextureCatleIcon(i);
        castleMark.ShowWindow();
        castleMark.SetTexture(getInstanceL2Util().GetCastleMinIconName(castleIDs[i]));
        castleMark.SetTooltipText(GetCastleName(castleIDs[i]));
    }
}

function SetSiegeMercenary(string castleIDsStr, int Type, int clanID, string ClanName, string PledgeMasterName, int MercenaryReward)
{
    local Texture texPledge;
    local Texture texAlliance;
    local bool bPledge;
    local bool bAlliance;

    MakeCastleIds(castleIDsStr);
    currentClanID = clanID;
    API_RequestPledgeMercenaryMemberList(currentClanID);
    bPledge = Class 'UIDATA_CLAN'.static.GetCrestTexture(clanID, texPledge);
    bAlliance = Class 'UIDATA_CLAN'.static.GetAllianceCrestTexture(clanID, texAlliance);
    SiegeMercenaryPledge_Tex.SetTexture("");
    SiegeMercenaryPledgeCrest_Tex.SetTexture("");
    if (bPledge)
    {
        SiegeMercenaryPledge_Tex.SetTextureWithObject(texPledge);
        if (bAlliance)
        {
            SiegeMercenaryPledgeCrest_Tex.SetTextureWithObject(texAlliance);
        }
    }
    switch (Type)
    {
        case 0:
            SiegeMercenaryMark_Tex.SetTexture("L2UI_CT1.Icon.ICON_DF_SIEGE_SWORD");
            break;
        case 1:
            SiegeMercenaryMark_Tex.SetTexture("L2UI_CT1.Icon.ICON_DF_SIEGE_SHIELD");
            break;
        default:
    }
    SiegeMercenaryPledgeName_Txt.SetText(ClanName);
    SiegeMercenaryUserName.SetText(PledgeMasterName);
    EntryNum01_Txt.SetText(string(MercenaryReward) $ "%");
    API_RequestPledgeMercenaryMemberList(clanID);
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

function TextureHandle GetTextureCatleIcon(int Index)
{
    return GetTextureHandle(
        m_WindowName $ ".SiegeMercenaryConfirmWnd.SiegeMercenaryEntryCastle_Tex" $ string(Index));
}

function HandleOnClickRefresh()
{
    SiegeMercenaryRefresh_Btn.DisableWindow();
    Me.SetTimer(TIME_ID, TIME_REFRESH);
    API_RequestPledgeMercenaryMemberList(currentClanID);
}

function HandleOnCLickEntryBtn()
{
    if (IsMe)
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
    local int Type;
    local UserInfo Info;

    if (IsMe)
    {
        Type = 0;
    }
    else
    {
        Type = 1;
    }
    Me.SetTimer(TIMER_ENTRYID, TIMER_ENTRYREFRESH);
    SiegeMercenaryEntry_Btn.DisableWindow();
    if (GetPlayerInfo(Info))
    {
        API_RequestPledgeMercenaryMemberJoin(GetCastleID(), Type, Info.nID, currentClanID);
    }
    SiegeMercenaryConfirmWnd.HideWindow();
}

function API_RequestPledgeMercenaryMemberList(int PledgeId)
{
    Debug("API_RequestPledgeMercenaryMemberList" @string(castleIDs[0]) @string(PledgeId));
    Class 'SiegeAPI'.static.RequestPledgeMercenaryMemberList(castleIDs[0], PledgeId);
}

function API_RequestPledgeMercenaryMemberJoin(int castleID, int Type, int UserID, int PledgeId)
{
    Debug("API_RequestPledgeMercenaryMemberList" @string(castleIDs[0]) @string(Type) @string(UserID)
            @string(PledgeId));
    Class 'SiegeAPI'.static.RequestPledgeMercenaryMemberJoin(castleIDs[0], Type, UserID, PledgeId);
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(IFST_WINDOW_CLOSE);
    Class 'UIAPI_WINDOW'.static.HideWindow("SiegeMercenaryDrawerWnd");
}

defaultproperties
{
     m_WindowName="SiegeMercenaryDrawerWnd"
}
