class RankingWnd_Clan extends UICommonAPI;

const TIMER_ID = 1001115;
const REFRESH_DELAY = 600;

var WindowHandle Me;
var WindowHandle DisableWnd;
var TextureHandle ClanIcon_Tex;
var TextBoxHandle ClanNameText;
var TextBoxHandle levelText;
var TextBoxHandle ClassText;
var TextBoxHandle NameText;
var ButtonHandle RankingHelpButton;
var TextBoxHandle RankingText;
var TextureHandle ClanMarkClassic;
var TextureHandle ClanMark;
var TextureHandle RankingArrow;
var TextBoxHandle RankingEqualityText;
var TextBoxHandle MyRankingText;
var TextureHandle RankingBg;
var TextBoxHandle ClanExpText;
var TextBoxHandle MyClanExpText;
var WindowHandle RankingTabAllWnd;
var TextBoxHandle ClanTitleText;
var ButtonHandle Top150Button;
var ButtonHandle MyClanRankingButton;
var ButtonHandle refreshButton;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var RichListCtrlHandle RankingTab_RichList;
var DetailStatusWnd DetailStatusWndScript;
var int nRankingScope;
var UIEventManager.RankingScope currentRankingScope;
var bool bIAmRanker;
var int myRankingInList;
var UserInfo myInfo;
var bool isFirstInit;

function OnLoad()
{
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle("RankingWnd_Clan");
	DisableWnd = GetWindowHandle("RankingWnd_Clan.DisableWnd");
	ClanIcon_Tex = GetTextureHandle("RankingWnd_Clan.ClanIcon_Tex");
	ClanMark = GetTextureHandle("RankingWnd_Clan.ClanMark");
	ClanMarkClassic = GetTextureHandle("RankingWnd_Clan.ClanMarkClassic");
	ClanNameText = GetTextBoxHandle("RankingWnd_Clan.ClanNameText");
	levelText = GetTextBoxHandle("RankingWnd_Clan.LevelText");
	ClassText = GetTextBoxHandle("RankingWnd_Clan.ClassText");
	NameText = GetTextBoxHandle("RankingWnd_Clan.NameText");
	RankingHelpButton = GetButtonHandle("RankingWnd_Clan.RankingHelpButton");
	RankingText = GetTextBoxHandle("RankingWnd_Clan.RankingText");
	RankingArrow = GetTextureHandle("RankingWnd_Clan.RankingArrow");
	RankingEqualityText = GetTextBoxHandle("RankingWnd_Clan.RankingEqualityText");
	MyRankingText = GetTextBoxHandle("RankingWnd_Clan.MyRankingText");
	ClanExpText = GetTextBoxHandle("RankingWnd_Clan.ClanExpText");
	MyClanExpText = GetTextBoxHandle("RankingWnd_Clan.MyClanExpText");
	RankingTabAllWnd = GetWindowHandle("RankingWnd_Clan.RankingTabAllWnd");
	ClanTitleText = GetTextBoxHandle("RankingWnd_Clan.RankingTabAllWnd.ClanTitleText");
	Top150Button = GetButtonHandle("RankingWnd_Clan.RankingTabAllWnd.Top150Button");
	MyClanRankingButton = GetButtonHandle("RankingWnd_Clan.RankingTabAllWnd.MyClanRankingButton");
	refreshButton = GetButtonHandle("RankingWnd_Clan.RankingTabAllWnd.RefreshButton");
	DisableWndList = GetWindowHandle("RankingWnd_Clan.RankingTabAllWnd.DisableWndList");
	List_Empty = GetTextBoxHandle("RankingWnd_Clan.RankingTabAllWnd.DisableWndList.List_Empty");
	RankingTab_RichList = GetRichListCtrlHandle("RankingWnd_Clan.RankingTabAllWnd.RankingTab_RichList");
	RankingTab_RichList.SetSelectedSelTooltip(false);
	RankingTab_RichList.SetAppearTooltipAtMouseX(true);
	RankingTab_RichList.SetUseStripeBackTexture(false);
	DetailStatusWndScript = DetailStatusWnd(GetScript("DetailStatusWnd"));
}

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_RANKING_MY_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_RANKING_LIST);
}

event OnShow()
{
	// End:0x25
	if(GetWindowHandle("RankingWnd").IsShowWindow())
	{
		OnRefreshButtonClick();
	}
}

event OnHide()
{
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x18
		case 9750:
			initUI();
			break;
		case 40:
			isFirstInit = false;
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_PLEDGE_RANKING_MY_INFO):
			ParsePacket_S_EX_PLEDGE_RANKING_MY_INFO();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_PLEDGE_RANKING_LIST):
			ParsePacket_S_EX_PLEDGE_RANKING_LIST();
			break;
	}
}

function ParsePacket_S_EX_PLEDGE_RANKING_MY_INFO()
{
	local UIPacket._S_EX_PLEDGE_RANKING_MY_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PLEDGE_RANKING_MY_INFO(packet))
	{
		return;
	}
	uDebug(((" -->  Decode_S_EX_PLEDGE_RANKING_MY_INFO :  " @ string(packet.nRank)) @ string(packet.nPrevRank)) @ string(packet.nPledgeExp));
	// End:0x9E
	if(packet.nPrevRank == 0)
	{
		packet.nPrevRank = packet.nRank;
	}
	// End:0x158
	if((packet.nPrevRank - packet.nRank) > 0)
	{
		RankingArrow.ShowWindow();
		RankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowUp");
		RankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nPrevRank - packet.nRank)));
		RankingEqualityText.SetTextColor(GetColor(230, 101, 101, 255));		
	}
	else
	{
		// End:0x213
		if((packet.nPrevRank - packet.nRank) < 0)
		{
			RankingArrow.ShowWindow();
			RankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowDown");
			RankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nPrevRank - packet.nRank)));
			RankingEqualityText.SetTextColor(GetColor(0, 170, 255, 255));			
		}
		else
		{
			RankingEqualityText.SetText("-");
			RankingEqualityText.SetTextColor(GetColor(153, 153, 153, 255));
			RankingArrow.HideWindow();
		}
	}
	// End:0x276
	if(packet.nPledgeExp == 0)
	{
		MyClanExpText.SetText("-");		
	}
	else
	{
		MyClanExpText.SetText(MakeCostString(string(packet.nPledgeExp)));
	}
	// End:0x2BC
	if(packet.nRank == 0)
	{
		MyRankingText.SetText("-");		
	}
	else
	{
		MyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRank)));
	}
}

function ParsePacket_S_EX_PLEDGE_RANKING_LIST()
{
	local UIPacket._S_EX_PLEDGE_RANKING_LIST packet;
	local int i, nChangeRank;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PLEDGE_RANKING_LIST(packet))
	{
		return;
	}
	uDebug(" -->  Decode_S_EX_PLEDGE_RANKING_LIST :  " @ string(packet.cRankingScope));
	uDebug("packet.rankingList.length : " @ string(packet.rankingList.Length));
	RankingTab_RichList.DeleteAllItem();
	bIAmRanker = false;
	myRankingInList = 0;
	nRankingScope = packet.cRankingScope;

	for(i = 0; i < packet.rankingList.Length; i++)
	{
		// End:0xFC
		if(packet.rankingList[i].nPrevRank == 0)
		{
			nChangeRank = 0;			
		}
		else
		{
			nChangeRank = packet.rankingList[i].nPrevRank - packet.rankingList[i].nRank;
		}
		// End:0x175
		if(packet.rankingList[i].sPledgeName == (GetClanName(myInfo.nClanID)))
		{
			bIAmRanker = true;
			myRankingInList = RankingTab_RichList.GetRecordCount();
		}
		AddRankingSystemListItem(packet.rankingList[i].nRank, nChangeRank, packet.rankingList[i].nPrevRank, packet.rankingList[i].sPledgeName, packet.rankingList[i].nPledgeLevel, packet.rankingList[i].sPledgeMasterName, packet.rankingList[i].nPledgeMasterLevel, packet.rankingList[i].nPledgeMemberCount, packet.rankingList[i].nPledgeExp);
	}
	rankingListEndHandler();
}

function AddRankingSystemListItem(int nRanking, int nChangeRank, int nPrevRank, string sPledgeName, int nPledgeLevel, string sPledgeMasterName, int nPledgeMasterLevel, int nPledgeMemberCount, int nPledgeExp)
{
	local RichListCtrlRowData RowData;
	local string texStr, levelStr;
	local Color applyColor;
	local int nH, nW, nAddY, nAddX;
	local PledgeLevelData pledgeLevelDataStru;

	RowData.cellDataList.Length = 5;
	// End:0x105
	if((nRanking <= 3) && nRanking > 0)
	{
		// End:0x5F
		if(nRanking == 1)
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_1st";			
		}
		else
		{
			// End:0x98
			if(nRanking == 2)
			{
				texStr = "L2UI_ct1.RankingWnd.RankingWnd_2nd";				
			}
			else
			{
				// End:0xCE
				if(nRanking == 3)
				{
					texStr = "L2UI_ct1.RankingWnd.RankingWnd_3rd";
				}
			}
		}
		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, texStr, 38, 33, 10, 5);
		nAddY = 12;
		nAddX = 6;		
	}
	else
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, string(nRanking), GTColor().Tallow, false, 20, 10);
		nAddY = 4;
		nAddX = 10;
	}
	// End:0x1AD
	if((nRankingScope == 0) && (nPrevRank > 150) || nPrevRank == 0)
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, "NEW", GTColor().Lime, false, nAddX, nAddY - 4);		
	}
	else
	{
		// End:0x23A
		if(nChangeRank > 0)
		{
			addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowUp", 8, 8, 6, nAddY);
			addRichListCtrlString(RowData.cellDataList[0].drawitems, string(nChangeRank), GTColor().Froly, false, 2, -4);			
		}
		else
		{
			// End:0x27F
			if(nChangeRank == 0)
			{
				addRichListCtrlString(RowData.cellDataList[0].drawitems, "-", GetColor(153, 153, 153, 255), false, nAddX, nAddY - 4);				
			}
			else
			{
				addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowDown", 8, 8, 6, nAddY);
				addRichListCtrlString(RowData.cellDataList[0].drawitems, string(nChangeRank), GTColor().DeepSkyBlue, false, 2, -4);
			}
		}
	}
	// End:0x331
	if(nRanking <= 3 && nRanking > 0)
	{
		applyColor = GTColor().Frangipani;		
	}
	else
	{
		applyColor = GTColor().Silver;
	}
	levelStr = ("(Lv." $ string(nPledgeLevel)) $ ")";
	GetTextSizeDefault(sPledgeName, nW, nH);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, sPledgeName, applyColor, false, 4, -2);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, levelStr, applyColor, false, - nW, 15);
	levelStr = ("(Lv." $ string(nPledgeMasterLevel)) $ ")";
	GetTextSizeDefault(sPledgeMasterName, nW, nH);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, sPledgeMasterName, applyColor, false, 4, -2);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, levelStr, applyColor, false, - nW, 15);
	GetPledgeLevelData(nPledgeLevel, pledgeLevelDataStru);
	addRichListCtrlString(RowData.cellDataList[3].drawitems, (string(nPledgeMemberCount) $ "/") $ string(pledgeLevelDataStru.NumGeneral), applyColor, false, 0, 0);
	addRichListCtrlString(RowData.cellDataList[4].drawitems, MakeCostString(string(nPledgeExp)), applyColor, false, 0, 0);
	// End:0x516
	if(sPledgeName == (GetClanName(myInfo.nClanID)))
	{
		RowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";		
	}
	else
	{
		RowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
	}
	RowData.OverlayTexU = 734;
	RowData.OverlayTexV = 45;
	RankingTab_RichList.InsertRecord(RowData);
}

function initUI()
{
	setLikeRadioButton("Top150Button");
	SetCusomTooltipHelpButton();
	RankingEqualityText.SetText("");
	RankingArrow.HideWindow();
	MyClanExpText.SetText("");
	MyRankingText.SetText("");
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Top150Button":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "MyClanRankingButton":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "RefreshButton":
			OnRefreshButtonClick();
			break;
	}
}

function OnRefreshButtonClick()
{
	API_C_EX_PLEDGE_RANKING_MY_INFO();
	API_C_EX_PLEDGE_RANKING_LIST();
	setMyInfo();
	setDisableWnd();
}

function setMyInfo()
{
	local Texture PledgeCrestTexture;
	local bool bPledgeCrestTexture;
	local int nClass, nLevel;

	GetPlayerInfo(myInfo);
	// End:0x4B
	if(getInstanceUIData().getIsLiveServer())
	{
		nClass = DetailStatusWndScript.getMainClassID();
		nLevel = DetailStatusWndScript.getMainLevel();		
	}
	else
	{
		nClass = myInfo.nSubClass;
		nLevel = myInfo.nLevel;
	}
	levelText.SetText("Lv." $ string(nLevel));
	ClassText.SetText(GetClassType(nClass));
	// End:0xD4
	if(myInfo.nClanID > 0)
	{
		ClanNameText.SetText(GetClanName(myInfo.nClanID));		
	}
	else
	{
		ClanNameText.SetText(GetSystemString(431));
	}
	NameText.SetText(myInfo.Name);
	bPledgeCrestTexture = class'UIDATA_CLAN'.static.GetCrestTexture(myInfo.nClanID, PledgeCrestTexture);
	// End:0x15B
	if(getInstanceUIData().getIsLiveServer())
	{
		ClanMarkClassic.HideWindow();
		// End:0x17D
		if(bPledgeCrestTexture)
		{
			ClanMark.ShowWindow();
			ClanMark.SetTextureWithObject(PledgeCrestTexture);			
		}
		else
		{
			ClanMark.HideWindow();
		}		
	}
	else
	{
		ClanMark.HideWindow();
		// End:0x1CD
		if(bPledgeCrestTexture)
		{
			ClanMarkClassic.ShowWindow();
			ClanMarkClassic.SetTextureWithObject(PledgeCrestTexture);			
		}
		else
		{
			ClanMarkClassic.HideWindow();
		}
	}
	// End:0x17E
	if(isFirstInit == false)
	{
		isFirstInit = true;
	}
}

function rankingListEndHandler()
{
	local int nStartRow;

	// End:0x77
	if(RankingTab_RichList.GetRecordCount() > 0)
	{
		DisableWndList.HideWindow();
		// End:0x74
		if(bIAmRanker)
		{
			nStartRow = myRankingInList - 3;
			// End:0x74
			if(nStartRow > 0)
			{
				// End:0x74
				if(RankingTab_RichList.GetRecordCount() > nStartRow)
				{
					RankingTab_RichList.SetStartRow(nStartRow);
				}
			}
		}		
	}
	else
	{
		DisableWndList.ShowWindow();
		List_Empty.SetText(GetSystemString(13023));
	}
	RankingTab_RichList.SetFocus();
}

function SetCusomTooltipHelpButton()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13691), GTColor().ColorDesc, "", true, true);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	RankingHelpButton.SetTooltipCustomType(mCustomTooltip);
}

function setLikeRadioButton(string buttonName)
{
	// End:0x126
	if(buttonName == "Top150Button")
	{
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		MyClanRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = RankingScope.TopN;		
	}
	else
	{
		// End:0x250
		if(buttonName == "MyClanRankingButton")
		{
			MyClanRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
			Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
			currentRankingScope = RankingScope.AroundMe;
		}
	}
}

function OnTimer(int TimeID)
{
	// End:0x15
	if(TimeID == 1001115)
	{
		hideDisableWnd();
	}
}

function setDisableWnd()
{
	DisableWnd.ShowWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(true);
	Me.SetTimer(1001115, 600);
}

function hideDisableWnd()
{
	DisableWnd.HideWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(false);
	Me.KillTimer(1001115);
}

function API_C_EX_PLEDGE_RANKING_MY_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_RANKING_MY_INFO packet;

	packet.cDummy = 0;
	// End:0x2C
	if(! class'UIPacket'.static.Encode_C_EX_PLEDGE_RANKING_MY_INFO(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PLEDGE_RANKING_MY_INFO, stream);
	uDebug("----> Api Call : C_EX_PLEDGE_RANKING_MY_INFO");
}

function API_C_EX_PLEDGE_RANKING_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_RANKING_LIST packet;

	packet.cRankingScope = currentRankingScope;
	// End:0x32
	if(! class'UIPacket'.static.Encode_C_EX_PLEDGE_RANKING_LIST(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PLEDGE_RANKING_LIST, stream);
	uDebug("----> Api Call : C_EX_PLEDGE_RANKING_LIST" @ string(currentRankingScope));
}

defaultproperties
{
}
