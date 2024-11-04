//================================================================================
// SiegeInfoMCWWnd.
//================================================================================

class SiegeInfoMCWWnd extends UICommonAPI;

const TIME_REFRESH = 3000;
const TIMER_ID = 1;
enum SiegeType
{
	READY,
	Start,
	End
};

enum TYPE_TABORDER
{
	Attacker,
	DEFENDER
};

var bool m_bShow;
var int m_PlayerClanID;
var bool m_IsCastleOwner;
var bool m_IsExistMyClanIDinAttackSide;
var bool m_IsExistMyClanIDinDefenseSide;
var int m_AcceptedClan;
var int m_WaitingClan;
var int m_DialogClanID;
var WindowHandle m_wndTop;
var TabHandle TabCtrl;
var int castleID;
var ListCtrlHandle lstAttackClan;
var TextBoxHandle txtAttackCount;
var ButtonHandle btnAttackApply;
var ButtonHandle btnAttackCancel;
var ListCtrlHandle lstDefenseClan;
var TextBoxHandle txtDefenseCount;
var ButtonHandle btnDefenseApply;
var ButtonHandle btnDefenseCancel;
var ButtonHandle btnDefenseReject;
var ButtonHandle btnDefenseConfirm;
var TextureHandle tabLineBgTail;
var bool m_ISMercenary;

function OnRegisterEvent()
{
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_MCW_CastleSiegeAttackerListStart);
	RegisterEvent(EV_MCW_CastleSiegeAttackerListItem);
	RegisterEvent(EV_MCW_CastleSiegeAttackerListEnd);
	RegisterEvent(EV_MCW_CastleSiegeDefenderListStart);
	RegisterEvent(EV_MCW_CastleSiegeDefenderListItem);
	RegisterEvent(EV_MCW_CastleSiegeDefenderListEnd);
}

function OnLoad()
{
	SetClosingOnESC();
	m_bShow = False;
	m_AcceptedClan = 0;
	m_WaitingClan = 0;
	m_wndTop = GetWindowHandle("SiegeInfoMCWWnd");
	TabCtrl = GetTabHandle("SiegeInfoMCWWnd.TabCtrl");
	lstAttackClan = GetListCtrlHandle("SiegeInfoMCWWnd.SiegeInfoWnd_Party1.lstClan");
	txtAttackCount = GetTextBoxHandle("SiegeInfoMCWWnd.SiegeInfoWnd_Party1.txtCount");
	btnAttackApply = GetButtonHandle("SiegeInfoMCWWnd.SiegeInfoWnd_Party1.btnAttackApply");
	btnAttackCancel = GetButtonHandle("SiegeInfoMCWWnd.SiegeInfoWnd_Party1.btnAttackCancel");
	lstDefenseClan = GetListCtrlHandle("SiegeInfoMCWWnd.SiegeInfoWnd_Party2.lstClan");
	txtDefenseCount = GetTextBoxHandle("SiegeInfoMCWWnd.SiegeInfoWnd_Party2.txtCount");
	btnDefenseApply = GetButtonHandle("SiegeInfoMCWWnd.SiegeInfoWnd_Party2.btnDefenseApply");
	btnDefenseCancel = GetButtonHandle("SiegeInfoMCWWnd.SiegeInfoWnd_Party2.btnDefenseCancel");
	btnDefenseReject = GetButtonHandle("SiegeInfoMCWWnd.SiegeInfoWnd_Party2.btnDefenseReject");
	btnDefenseConfirm = GetButtonHandle("SiegeInfoMCWWnd.SiegeInfoWnd_Party2.btnDefenseConfirm");
	tabLineBgTail = GetTextureHandle("SiegeInfoMCWWnd.tabLineBgTail");
	UpdateAttackCount();
	UpdateDefenseCount();
}

function OnShow()
{
	clearInfo();
	API_RequestMCWCastleSiegeAttackerList(GetCastleID());
	m_bShow = True;
	Class 'UIAPI_WINDOW'.static.HideWindow("SiegeWnd");
	m_wndTop.SetAnchor("SiegeWnd", "CenterCenter", "CenterCenter", 0, 0);
	m_wndTop.ClearAnchor();
}

function OnHide()
{
	m_bShow = False;
}

function OnEvent(int Event_ID, string param)
{
	Debug("SiegeInfoMCWWnd OnEvent" @string(Event_ID) @param);
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
		case EV_DialogOK:
			HandleOK();
			break;
		default:
	}
}

function HandleOK()
{
	if (DialogIsMine())
	{
		if (DialogGetID() == 1)
		{
			Class 'SiegeAPI'.static.RequestJoinCastleSiege(GetCastleID(), 1, 1);
		}
		else
		{
			if (DialogGetID() == 2)
			{
				Class 'SiegeAPI'.static.RequestJoinCastleSiege(GetCastleID(), 1, 0);
			}
			else
			{
				if (DialogGetID() == 3)
				{
					Class 'SiegeAPI'.static.RequestJoinCastleSiege(GetCastleID(), 0, 1);
				}
				else
				{
					if (DialogGetID() == 4)
					{
						Class 'SiegeAPI'.static.RequestJoinCastleSiege(GetCastleID(), 0, 0);
					}
					else
					{
						if (DialogGetID() == 5)
						{
							if (m_DialogClanID > 0)
							{
								Class 'SiegeAPI'.static.RequestConfirmCastleSiegeWaitingList(
									GetCastleID(), m_DialogClanID, 0);
								m_DialogClanID = 0;
							}
						}
						else
						{
							if (DialogGetID() == 6)
							{
								if (m_DialogClanID > 0)
								{
									Class 'SiegeAPI'.static.RequestConfirmCastleSiegeWaitingList(
										GetCastleID(), m_DialogClanID, 1);
									m_DialogClanID = 0;
								}
							}
						}
					}
				}
			}
		}
	}
}

function clearInfo()
{
	m_IsCastleOwner = False;
	TabCtrl.SetTopOrder(0, True);
}

function OnClickButton(string strID)
{
	Debug("OnDefenseCancelClick" @GetCastleName(GetCastleID()));
	switch (strID)
	{
		case "btnAttackApply":
			OnAttackApplyClick();
			break;
		case "btnAttackCancel":
			OnAttackCancelClick();
			break;
		case "btnDefenseApply":
			OnDefenseApplyClick();
			break;
		case "btnDefenseCancel":
			OnDefenseCancelClick();
			break;
		case "btnDefenseReject":
			OnDefenseRejectClick();
			break;
		case "btnDefenseConfirm":
			OnDefenseConfirmClick();
			break;
		case "TabCtrl0":
			OnTabCtrl0Click();
			break;
		case "TabCtrl1":
			OnTabCtrl1Click();
			break;
		default:
	}
}

function OnAttackApplyClick()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(667), GetCastleName(GetCastleID()), ""),
		string(self));
	DialogSetID(1);
}

function OnAttackCancelClick()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(669), GetCastleName(GetCastleID()), ""),
		string(self));
	DialogSetID(2);
}

function OnDefenseApplyClick()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(668), GetCastleName(GetCastleID()), ""),
		string(self));
	DialogSetID(3);
}

function OnDefenseCancelClick()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(669), GetCastleName(GetCastleID()), ""),
		string(self));
	DialogSetID(4);
}

function OnDefenseRejectClick()
{
	local int idx, clanID;
	local string ClanName;
	local int Status;
	local ECastleSiegeDefenderType DefenderType;
	local LVDataRecord Record;

	idx = lstDefenseClan.GetSelectedIndex();
	if(idx > -1)
	{
		lstDefenseClan.GetRec(idx, Record);
		clanID = int(Record.nReserved1);
		Status = int(Record.nReserved2);
		DefenderType = ECastleSiegeDefenderType(Status);
		if(clanID > 0)
		{
			if(DefenderType == ECastleSiegeDefenderType.CSDT_WAITING_CONFIRM || DefenderType == ECastleSiegeDefenderType.CSDT_APPROVED)
			{
				ClanName = class'UIDATA_CLAN'.static.GetName(clanID);
				m_DialogClanID = clanID;
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(670), ClanName, ""), string(self));
				DialogSetID(5);
			}
		}
	}
}

function OnDefenseConfirmClick()
{
	local int idx, clanID;
	local string ClanName;
	local int Status;
	local ECastleSiegeDefenderType DefenderType;
	local LVDataRecord Record;

	idx = lstDefenseClan.GetSelectedIndex();
	if(idx > -1)
	{
		lstDefenseClan.GetRec(idx, Record);
		clanID = int(Record.nReserved1);
		Status = int(Record.nReserved2);
		DefenderType = ECastleSiegeDefenderType(Status);
		if(clanID > 0)
		{
			if(DefenderType == ECastleSiegeDefenderType.CSDT_WAITING_CONFIRM)
			{
				ClanName = class'UIDATA_CLAN'.static.GetName(clanID);
				m_DialogClanID = clanID;
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(671), ClanName, ""), string(self));
				DialogSetID(6);
			}
		}
	}
}

function OnTabCtrl0Click()
{
	Debug("OnTabCtrl0Click");
	if (!TabCtrl.IsEnableWindow())
	{
		return;
	}
	ClearAttackButton();
	API_RequestMCWCastleSiegeAttackerList(GetCastleID());
	TabCtrl.DisableWindow();
	m_wndTop.SetTimer(TIMER_ID, TIME_REFRESH);
}

function OnTabCtrl1Click()
{
	Debug("OnTabCtrl1Click");
	if (!TabCtrl.IsEnableWindow())
	{
		return;
	}
	ClearDefenseButton();
	API_RequestMCWCastleSiegeDefenderList(GetCastleID());
	TabCtrl.DisableWindow();
	m_wndTop.SetTimer(TIMER_ID, TIME_REFRESH);
}

function OnTimer(int TimerID)
{
	switch (TimerID)
	{
		case TIMER_ID:
			m_wndTop.KillTimer(TimerID);
			TabCtrl.EnableWindow();
			break;
		default:
	}
}

function HandleSiegeInfoClanListStart(string param, int Type)
{
	local UserInfo infUser;
	local int IsOwner;

	// End:0x49
	if(ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_clanID != m_PlayerClanID && m_PlayerClanID != 0)
	{
		m_ISMercenary = true;		
	}
	else
	{
		m_ISMercenary = false;
	}
	ParseInt(param, "CastleID", castleID);
	if (castleID != GetCastleID())
	{
		return;
	}
	m_PlayerClanID = 0;
	if (GetPlayerInfo(infUser))
	{
		m_PlayerClanID = infUser.nClanID;
	}
	ParseInt(param, "IsOwner", IsOwner);
	if (IsOwner == 1)
	{
		m_IsCastleOwner = True;
	}
	if (Type == 0)
	{
		lstAttackClan.DeleteAllItem();
		m_IsExistMyClanIDinAttackSide = False;
		UpdateAttackCount();
		ClearAttackButton();
	}
	else
	{
		if (Type == 1)
		{
			lstDefenseClan.DeleteAllItem();
			m_IsExistMyClanIDinDefenseSide = False;
			m_AcceptedClan = 0;
			m_WaitingClan = 0;
			UpdateDefenseCount();
			ClearDefenseButton();
		}
	}
}

function DebugClanID()
{
	local UserInfo infUser;

	if (GetPlayerInfo(infUser))
	{
		m_PlayerClanID = infUser.nClanID;
	}
}

function HandleSiegeInfoClanList(string param, int Type)
{
	local int clanID;
	local string ClanName;
	local string allianceName;
	local int allianceID;
	local int MercenaryRecruit;
	local int Status;
	local ECastleSiegeDefenderType DefenderType;
	local LVDataRecord Record;
	local Texture texClan;
	local Texture texAlliance;

	Record.LVDataList.Length = 2;
	ParseInt(param, "PledgeID", clanID);
	ParseString(param, "PledgeName", ClanName);
	ParseInt(param, "AllianceID", allianceID);
	ParseString(param, "AllianceName", allianceName);
	if (clanID < 1)
	{
		return;
	}
	if ((m_PlayerClanID > 0) && (clanID == m_PlayerClanID))
	{
		ParseInt(param, "MercenaryRecruit", MercenaryRecruit);
		SiegeWnd(GetScript("SiegeWnd")).SetRecruit(castleID, MercenaryRecruit);
	}
	if (castleID != GetCastleID())
	{
		return;
	}
	if (Type == 0)
	{
		if ((m_PlayerClanID > 0) && (clanID == m_PlayerClanID)
			&& (ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_clanID == m_PlayerClanID))
		{
			m_IsExistMyClanIDinAttackSide = True;
		}
		Record.LVDataList[0].szData = ClanName;
		if (Class 'UIDATA_CLAN'.static.GetCrestTexture(clanID, texClan))
		{
			Record.LVDataList[0].arrTexture.Length = 1;
			Record.LVDataList[0].arrTexture[0].objTex = texClan;
			Record.LVDataList[0].arrTexture[0].X = 0;
			Record.LVDataList[0].arrTexture[0].Y = 0;
			Record.LVDataList[0].arrTexture[0].Width = 24;
			Record.LVDataList[0].arrTexture[0].Height = 12;
			Record.LVDataList[0].arrTexture[0].U = 0;
			Record.LVDataList[0].arrTexture[0].V = 4;
		}
		Record.LVDataList[1].szData = allianceName;
		if (allianceID > 0)
		{
			if (Class 'UIDATA_CLAN'.static.GetAllianceCrestTexture(clanID, texAlliance))
			{
				Record.LVDataList[1].arrTexture.Length = 1;
				Record.LVDataList[1].arrTexture[0].objTex = texAlliance;
				Record.LVDataList[1].arrTexture[0].X = 0;
				Record.LVDataList[1].arrTexture[0].Y = 0;
				Record.LVDataList[1].arrTexture[0].Width = 8;
				Record.LVDataList[1].arrTexture[0].Height = 12;
				Record.LVDataList[1].arrTexture[0].U = 0;
				Record.LVDataList[1].arrTexture[0].V = 4;
			}
		}
		lstAttackClan.InsertRecord(Record);
		UpdateAttackCount();
	}
	else
	{
		if (Type == 1)
		{
			ParseInt(param, "Status", Status);
			if ((m_PlayerClanID > 0) && (clanID == m_PlayerClanID)
				&& (ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_clanID == m_PlayerClanID))
			{
				m_IsExistMyClanIDinDefenseSide = True;
			}
			Record.nReserved1 = clanID;
			Record.nReserved2 = Status;
			Record.LVDataList[0].szData = ClanName;
			if (Class 'UIDATA_CLAN'.static.GetCrestTexture(clanID, texClan))
			{
				Record.LVDataList[0].arrTexture.Length = 1;
				Record.LVDataList[0].arrTexture[0].objTex = texClan;
				Record.LVDataList[0].arrTexture[0].X = 0;
				Record.LVDataList[0].arrTexture[0].Y = 0;
				Record.LVDataList[0].arrTexture[0].Width = 24;
				Record.LVDataList[0].arrTexture[0].Height = 12;
				Record.LVDataList[0].arrTexture[0].U = 0;
				Record.LVDataList[0].arrTexture[0].V = 4;
			}
			DefenderType = ECastleSiegeDefenderType(Status);
			switch (DefenderType)
			{
				case CSDT_CASTLE_OWNER:
					Record.LVDataList[1].szData = GetSystemString(588);
					m_AcceptedClan++;
					break;
				case CSDT_WAITING_CONFIRM:
					Record.LVDataList[1].szData = GetSystemString(568);
					m_WaitingClan++;
					break;
				case CSDT_APPROVED:
					Record.LVDataList[1].szData = GetSystemString(567);
					m_AcceptedClan++;
					break;
				case CSDT_REJECTED:
					Record.LVDataList[1].szData = GetSystemString(579);
					break;
				default:
			}
			lstDefenseClan.InsertRecord(Record);
			UpdateDefenseCount();
		}
	}
}

function HandleSiegeInfoClanListEnd(string param, int Type)
{
	if (castleID != GetCastleID())
	{
		return;
	}
	if (Type == 0)
	{
		UpdateAttackButton();
	}
	else
	{
		if (Type == 1)
		{
			UpdateDefenseButton();
		}
	}
}

function UpdateAttackCount()
{
	txtAttackCount.SetText(GetSystemString(576) $ " : " $ string(lstAttackClan.GetRecordCount()));
}

function UpdateDefenseCount()
{
	txtDefenseCount.SetText(GetSystemString(577) $ "/" $ GetSystemString(578) $
		" : " $ string(m_AcceptedClan) $ "/" $ string(m_WaitingClan));
}

function UpdateAttackButton()
{
	if (!m_IsCastleOwner)
	{
		Debug("UpdateAttackButton:" @ string(ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_bClanMaster) @ string(m_ISMercenary) @ string(m_IsExistMyClanIDinDefenseSide));
		// End:0x9F
		if((ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_bClanMaster == 0) || m_ISMercenary)
		{
			return;
		}
		if (m_IsExistMyClanIDinAttackSide)
		{
			if (NoticeHUD(GetScript("NoticeHUD")).SiegeState == 0)
			{
				btnAttackCancel.ShowWindow();
			}
		}
		else
		{
			if (NoticeHUD(GetScript("NoticeHUD")).SiegeState == 0)
			{
				btnAttackApply.ShowWindow();
			}
		}
	}
}

function UpdateDefenseButton()
{
	if (!m_IsCastleOwner)
	{
		Debug("UpdateDefenseButton:" @ string(ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_bClanMaster) @ string(m_ISMercenary) @ string(btnDefenseApply.IsShowWindow()));
		// End:0xA9
		if((ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_bClanMaster == 0) || m_ISMercenary)
		{
			return;
		}
		// End:0xEC
		if (m_IsExistMyClanIDinDefenseSide)
		{
			if (NoticeHUD(GetScript("NoticeHUD")).SiegeState == 0)
			{
				btnDefenseCancel.ShowWindow();
			}
		}
		else
		{
			if (NoticeHUD(GetScript("NoticeHUD")).SiegeState == 0)
			{
				btnDefenseApply.ShowWindow();
			}
		}
	}
	else
	{
		if (NoticeHUD(GetScript("NoticeHUD")).SiegeState == 0)
		{
			btnDefenseReject.ShowWindow();
			btnDefenseConfirm.ShowWindow();
		}
	}
}

function ClearAttackButton()
{
	btnAttackApply.HideWindow();
	btnAttackCancel.HideWindow();
}

function ClearDefenseButton()
{
	btnDefenseApply.HideWindow();
	btnDefenseCancel.HideWindow();
	btnDefenseReject.HideWindow();
	btnDefenseConfirm.HideWindow();
}

function int GetCastleID()
{
	local SiegeWnd siegeWndScript;

	siegeWndScript = SiegeWnd(GetScript("SiegeWnd"));
	return siegeWndScript.castleIDs[siegeWndScript.SelectedIndex];
}

function API_RequestMCWCastleSiegeAttackerList(int tmpCastleID)
{
	if (tmpCastleID > 0)
	{
		Class 'SiegeAPI'.static.RequestMCWCastleSiegeAttackerList(tmpCastleID);
	}
}

function API_RequestMCWCastleSiegeDefenderList(int tmpCastleID)
{
	if (tmpCastleID > 0)
	{
		Class 'SiegeAPI'.static.RequestMCWCastleSiegeDefenderList(tmpCastleID);
	}
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	OnHide();
	Class 'UIAPI_WINDOW'.static.HideWindow("SiegeInfoMCWWnd");
}

defaultproperties
{
}
