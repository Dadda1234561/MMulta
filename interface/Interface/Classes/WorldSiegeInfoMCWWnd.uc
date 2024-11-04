class WorldSiegeInfoMCWWnd extends UICommonAPI;

enum TYPE_TABORDER 
{
	Attacker
};

enum SiegeType 
{
	READY,
	Start,
	End
};

var bool m_IsExistMyClanIDinAttackSide;
var bool m_ISMercenary;
var ListCtrlHandle lstAttackClan;
var TextBoxHandle txtAttackCount;
var ButtonHandle btnAttackApply;
var ButtonHandle btnAttackCancel;

static function WorldSiegeInfoMCWWnd Inst()
{
	return WorldSiegeInfoMCWWnd(GetScript("WorldSiegeInfoMCWWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_WorldCastleWarSiegeAttackerListStart);
	RegisterEvent(EV_WorldCastleWarSiegeAttackerList);
	RegisterEvent(EV_WorldCastleWarSiegeAttackerListEnd);
}

event OnLoad()
{
	SetClosingOnESC();
	lstAttackClan = GetListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeInfoWnd_Party1.lstClan");
	txtAttackCount = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeInfoWnd_Party1.txtCount");
	btnAttackApply = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeInfoWnd_Party1.btnAttackApply");
	btnAttackCancel = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeInfoWnd_Party1.btnAttackCancel");
	UpdateAttackCount();
}

event OnHide()
{
	local WindowHandle worldSiegeWndHandle;

	worldSiegeWndHandle = class'WorldSiegeWnd'.static.Inst().m_hOwnerWnd;
	worldSiegeWndHandle.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "CenterCenter", "CenterCenter", 0, 0);
	worldSiegeWndHandle.ClearAnchor();
	worldSiegeWndHandle.ShowWindow();
	worldSiegeWndHandle.BringToFront();
}

event OnShow()
{
	API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST();
	class'WorldSiegeWnd'.static.Inst().m_hOwnerWnd.HideWindow();
	m_hOwnerWnd.SetAnchor("WorldSiegeWnd", "CenterCenter", "CenterCenter", 0, 0);
	m_hOwnerWnd.ClearAnchor();
	ClearAttackButton();
	m_hOwnerWnd.SetFocus();
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		// End:0x23
		case "btnAttackApply":
			OnAttackApplyClick();
			// End:0x43
			break;
		// End:0x40
		case "btnAttackCancel":
			OnAttackCancelClick();
			// End:0x43
			break;
	}
}

event OnEvent(int Event_ID, string param)
{
	// End:0x3F
	if(! m_hOwnerWnd.IsShowWindow() && ! class'WorldSiegeWnd'.static.Inst().m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	switch(Event_ID)
	{
		// End:0x57
		case EV_WorldCastleWarSiegeAttackerListStart:
			HandleSiegeInfoClanListStart();
			// End:0x92
			break;
		// End:0x6D
		case EV_WorldCastleWarSiegeAttackerList:
			HandleSiegeInfoClanList(param);
			// End:0x92
			break;
		// End:0x7E
		case EV_WorldCastleWarSiegeAttackerListEnd:
			HandleSiegeInfoClanListEnd();
			// End:0x92
			break;
		// End:0x8F
		case EV_DialogOK:
			HandleOK();
			// End:0x92
			break;
	}
}

function HandleOK()
{
	// End:0x21
	if(DialogIsMine())
	{
		switch(DialogGetID())
		{
			// End:0x1E
			case 0:
				API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_JOIN();
				// End:0x21
				break;
			// End:0xFFFF
			default:
				break;
		}
	}
}

function OnAttackApplyClick()
{
	DialogSetID(0);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(667), GetCastleName(GetCastleID()), ""), string(self));
}

function OnAttackCancelClick()
{
	DialogSetID(0);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(669), GetCastleName(GetCastleID()), ""), string(self));
}

function HandleSiegeInfoClanListStart()
{
	lstAttackClan.DeleteAllItem();
	m_IsExistMyClanIDinAttackSide = false;
	m_ISMercenary = false;
	UpdateAttackCount();
	ClearAttackButton();
}

function HandleSiegeInfoClanList(string param)
{
	local int clanID, myClanID;
	local string ClanName;
	local int MercenaryRecruit;
	local LVDataRecord Record;
	local Texture texClan;

	Record.LVDataList.Length = 2;
	ParseInt(param, "ClanID", clanID);
	ParseString(param, "ClanName", ClanName);
	myClanID = GetPlayerClanID();
	// End:0xE1
	if(clanID == myClanID)
	{
		// End:0xD9
		if(clanID == ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_clanID)
		{
			ParseInt(param, "IsMercenaryRecruit", MercenaryRecruit);
			class'WorldSiegeWnd'.static.Inst().SetRecruit(MercenaryRecruit);
			m_IsExistMyClanIDinAttackSide = true;			
		}
		else
		{
			m_ISMercenary = true;
		}
	}
	Record.LVDataList[0].szData = ConvertWorldIDToStr(ClanName);
	// End:0x1EB
	if(class'UIDATA_CLAN'.static.GetCrestTexture(clanID, texClan))
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
	lstAttackClan.InsertRecord(Record);
	UpdateAttackCount();
}

function HandleSiegeInfoClanListEnd()
{
	UpdateAttackButton();
}

function UpdateAttackCount()
{
	txtAttackCount.SetText((GetSystemString(576) $ " : ") $ string(lstAttackClan.GetRecordCount()));
}

function UpdateAttackButton()
{
	// End:0x0B
	if(IsCastleOwner())
	{
		return;
	}
	// End:0x2E
	if(class'NoticeHUD'.static.Inst().worldsiegeState != 0)
	{
		return;
	}
	// End:0x68
	if((ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_bClanMaster == 0) || m_ISMercenary)
	{
		return;
	}
	// End:0x83
	if(m_IsExistMyClanIDinAttackSide)
	{
		btnAttackCancel.ShowWindow();		
	}
	else
	{
		btnAttackApply.ShowWindow();
	}
}

function ClearAttackButton()
{
	btnAttackApply.HideWindow();
	btnAttackCancel.HideWindow();
}

function int GetOwnerPledgeID()
{
	return class'WorldSiegeWnd'.static.Inst().OwnerPledgeID;
}

function int GetPlayerClanID()
{
	local UserInfo infUser;

	// End:0x19
	if(GetPlayerInfo(infUser))
	{
		return infUser.nClanID;
	}
	return -1;
}

function bool IsCastleOwner()
{
	return GetOwnerPledgeID() == GetPlayerClanID();
}

function int GetCastleID()
{
	return class'WorldSiegeWnd'.static.Inst().GetCastleIDSelected();
}

function API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET(int PledgeID)
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET packet;

	packet.nCastleID = GetCastleID();
	packet.nType = 0;
	packet.nIsMercenaryRecruit = 0;
	// End:0x67
	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET(stream, packet))
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET, stream);
	}
}

function API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST packet;

	packet.nCastleID = GetCastleID();
	// End:0x4F
	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST(stream, packet))
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST, stream);
	}
}

function API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_JOIN()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_JOIN packet;

	packet.nCastleID = GetCastleID();
	packet.nAsAttacker = 1;
	// End:0x35
	if(m_IsExistMyClanIDinAttackSide)
	{
		packet.nIsRegister = 0;		
	}
	else
	{
		packet.nIsRegister = 1;
	}
	// End:0x7F
	if(class'UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_JOIN(stream, packet))
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_JOIN, stream);
	}
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
}

defaultproperties
{
}
