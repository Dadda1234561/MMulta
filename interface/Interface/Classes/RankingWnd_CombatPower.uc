//================================================================================
// RankingWnd_CombatPower.
//================================================================================

class RankingWnd_CombatPower extends UICommonAPI;

const TIMER_ID = 1001116;
const REFRESH_DELAY = 600;

var WindowHandle Me;
var WindowHandle DisableWnd;
var TextureHandle RaceMark;
var TextureHandle RankingFlag;
var TextureHandle ClanMarkClassic;
var TextureHandle ClanMark;
var TextureHandle ClanBg;
var TextBoxHandle ClanNameText;
var TextBoxHandle levelText;
var TextBoxHandle ClassText;
var TextBoxHandle NameText;
var ButtonHandle RankingHelpButton;
var TextBoxHandle ServerRankingText;
var TextureHandle ServerRankingArrow;
var TextBoxHandle ServerRankingEqualityText;
var TextBoxHandle ServerMyRankingText;
var TextureHandle ServerRankingBg;
var TextBoxHandle PvpPointText;
var TextBoxHandle PvpMyPointText;
var TextureHandle PvpPointBg;
var TextBoxHandle PvpScoreText;
var HtmlHandle PvpMyScoreKillText;
var HtmlHandle PvpMyScoreDeathText;
var TextureHandle PvpScoreBg;
var TextureHandle RankingTrophy;
var TextureHandle RankingPattern;
var TextureHandle RankingBg1;
var WindowHandle RankingTabAllWnd;
var ButtonHandle Top150Button;
var ButtonHandle MyRankingButton;
var ButtonHandle ShowLastWeekButton;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var WindowHandle RaceComboboxWnd;
var TextBoxHandle RaceCategoryText;
var ComboBoxHandle RaceCategoryCombobox;
var TextureHandle ServerRichListFrame;
var RichListCtrlHandle RankingTab_RichList;
var TextureHandle RankingBg2;
var TabHandle TabCtrl2;
var TextureHandle TabLineBg2;
var TextureHandle TabBg2;
var DetailStatusWnd DetailStatusWndScript;
var string m_WindowName;
var int nRanking;
var UserInfo myInfo;
var int nRankingGroup;
var int nRankingScope;
var RankingScope currentRankingScope;
var RankingGroup currentRankingGroup;
var bool bIAmRanker;
var int myRankingInList;
var bool isFirstInit;
var bool bCurrentSeason;

function OnRegisterEvent ()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PVP_RANKING_MY_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PVP_RANKING_LIST);
}

function OnLoad ()
{
	Initialize();
}

function Initialize ()
{
	m_WindowName = getCurrentWindowName(string(self));
	DetailStatusWndScript = DetailStatusWnd(GetScript("DetailStatusWnd"));
	Me = GetWindowHandle("RankingWnd_CombatPower");
	DisableWnd = GetWindowHandle(m_WindowName $ ".DisableWnd");
	RaceMark = GetTextureHandle(m_WindowName $ ".RaceMark");
	RankingFlag = GetTextureHandle(m_WindowName $ ".RankingFlag");
	ClanMark = GetTextureHandle(m_WindowName $ ".ClanMark");
	ClanMarkClassic = GetTextureHandle(m_WindowName $ ".ClanMarkClassic");
	ClanBg = GetTextureHandle(m_WindowName $ ".ClanBg");
	ClanNameText = GetTextBoxHandle(m_WindowName $ ".ClanNameText");
	levelText = GetTextBoxHandle(m_WindowName $ ".LevelText");
	ClassText = GetTextBoxHandle(m_WindowName $ ".ClassText");
	NameText = GetTextBoxHandle(m_WindowName $ ".NameText");
	RankingHelpButton = GetButtonHandle(m_WindowName $ ".RankingHelpButton");
	ServerRankingText = GetTextBoxHandle(m_WindowName $ ".ServerRankingText");
	ServerRankingArrow = GetTextureHandle(m_WindowName $ ".ServerRankingArrow");
	ServerRankingEqualityText = GetTextBoxHandle(m_WindowName $ ".ServerRankingEqualityText");
	ServerMyRankingText = GetTextBoxHandle(m_WindowName $ ".ServerMyRankingText");
	ServerRankingBg = GetTextureHandle(m_WindowName $ ".ServerRankingBg");
	PvpPointText = GetTextBoxHandle(m_WindowName $ ".PvpPointText");
	PvpMyPointText = GetTextBoxHandle(m_WindowName $ ".PvpMyPointText");
	PvpPointBg = GetTextureHandle(m_WindowName $ ".PvpPointBg");
	PvpScoreText = GetTextBoxHandle(m_WindowName $ ".PvpScoreText");
	// PvpMyScoreKillText = GetHtmlHandle(m_WindowName $ ".PvpMyScoreKillText");
	// PvpMyScoreDeathText = GetHtmlHandle(m_WindowName $ ".PvpMyScoreDeathText");
	PvpScoreBg = GetTextureHandle(m_WindowName $ ".PvpScoreBg");
	RankingTrophy = GetTextureHandle(m_WindowName $ ".RankingTrophy");
	RankingPattern = GetTextureHandle(m_WindowName $ ".RankingPattern");
	RankingBg1 = GetTextureHandle(m_WindowName $ ".RankingBg1");
	RankingTabAllWnd = GetWindowHandle(m_WindowName $ ".RankingTabAllWnd");
	Top150Button = GetButtonHandle(m_WindowName $ ".RankingTabAllWnd.Top150Button");
	MyRankingButton = GetButtonHandle(m_WindowName $ ".RankingTabAllWnd.MyRankingButton");
	ShowLastWeekButton = GetButtonHandle(m_WindowName $ ".RankingTabAllWnd.ShowLastWeekButton");
	DisableWndList = GetWindowHandle(m_WindowName $ ".RankingTabAllWnd.DisableWndList");
	List_Empty = GetTextBoxHandle(m_WindowName $ ".RankingTabAllWnd.DisableWndList.List_Empty");
	RaceComboboxWnd = GetWindowHandle(m_WindowName $ ".RankingTabAllWnd.RaceComboboxWnd");
	RaceCategoryText = GetTextBoxHandle(m_WindowName $ ".RankingTabAllWnd.RaceComboboxWnd.RaceCategoryText");
	RaceCategoryCombobox = GetComboBoxHandle(m_WindowName $ ".RankingTabAllWnd.RaceComboboxWnd.RaceCategoryCombobox");
	ServerRichListFrame = GetTextureHandle(m_WindowName $ ".RankingTabAllWnd.ServerRichListFrame");
	RankingTab_RichList = GetRichListCtrlHandle(m_WindowName $ ".RankingTabAllWnd.RankingTab_RichList");
	RankingBg2 = GetTextureHandle(m_WindowName $ ".RankingTabAllWnd.RankingBg2");
	TabCtrl2 = GetTabHandle(m_WindowName $ ".RankingTabAllWnd.TabCtrl2");
	TabLineBg2 = GetTextureHandle(m_WindowName $ ".RankingTabAllWnd.TabLineBg2");
	TabBg2 = GetTextureHandle(m_WindowName $ ".RankingTabAllWnd.TabBg2");
	RankingTab_RichList.SetSelectedSelTooltip(false);
	RankingTab_RichList.SetAppearTooltipAtMouseX(true);
	RankingTab_RichList.SetUseStripeBackTexture(false);
	RankingTab_RichList.SetTooltipType("RankingCombatPower");
	SetCusomTooltipAtHelpBtn();
}

function OnShow()
{
	// End:0x34
	if(GetWindowHandle("RankingWnd").IsShowWindow())
	{
		DisableWndList.HideWindow();
		OnRefreshButtonClick();
	}
}

function OnHide ()
{
}

function OnTimer (int TimeID)
{
	if ( TimeID == TIMER_ID )
	{
		hideDisableWnd();
	}
}

function OnComboBoxItemSelected (string strID, int Index)
{
	OnRefreshButtonClick();
}

function initRaceCombo ()
{
	local int i;

	RaceCategoryCombobox.Clear();
	if ( getInstanceUIData().getIsLiveServer() )
	{
		
		for ( i = 0;i < 7;i++ )
		{
			RaceCategoryCombobox.AddString(getRaceSystemString(i));
		}
	}
	else
	{
		for ( i = 0;i < 6;i++ )
		{
			RaceCategoryCombobox.AddString(getRaceSystemString(i));
		}
		// End:0xB3
		if(IsAdenServer())
		{
			RaceCategoryCombobox.AddString(getRaceSystemString(30));
		}
	}
}

function OnRClickButton (string Name)
{
	switch (Name)
	{
		case "TabCtrl20":
		case "TabCtrl21":
		case "TabCtrl22":
		case "TabCtrl23":
		setTabState(Name);
		OnRefreshButtonClick();
		break;
	}
}

function setTabState (string TabName)
{
	switch (TabName)
	{
		case "TabCtrl20":
			SettingButton(Top150Button, true, 13016);
			SettingButton(MyRankingButton, true, 13017);
			RaceComboboxWnd.HideWindow();
			currentRankingGroup = RankingGroup.ServerGroup;
			break;
		case "TabCtrl21":
			SettingButton(Top150Button,true, 3972);
			SettingButton(MyRankingButton,true, 3975);
			currentRankingGroup = RankingGroup.RaceGroup;
			break;
		case "TabCtrl22":
			SettingButton(Top150Button,False);
			SettingButton(MyRankingButton,False);
			RaceComboboxWnd.HideWindow();
			currentRankingGroup = RankingGroup.Pledge;
			break;
		case "TabCtrl23":
			SettingButton(Top150Button,False);
			SettingButton(MyRankingButton,False);
			RaceComboboxWnd.HideWindow();
			currentRankingGroup = RankingGroup.Friends;
		break;
	}
}

function setLikeRadioButton (string buttonName)
{
	if ( buttonName == "Top150Button" )
	{
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down","l2ui_ct1.RankingWnd_SubTabButton_Over","l2ui_ct1.RankingWnd_SubTabButton_Down");
		MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton","l2ui_ct1.RankingWnd_SubTabButton_Over","l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = TopN;
	} else {
		if ( buttonName == "MyRankingButton" )
		{
			MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down","l2ui_ct1.RankingWnd_SubTabButton_Over","l2ui_ct1.RankingWnd_SubTabButton_Down");
			Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton","l2ui_ct1.RankingWnd_SubTabButton_Over","l2ui_ct1.RankingWnd_SubTabButton_Over");
			currentRankingScope = AroundMe;
		}
	}
}

function SettingButton (ButtonHandle btn, bool bShow, optional int nSystemString)
{
	if ( bShow )
	{
		btn.ShowWindow();
		btn.SetNameText(GetSystemString(nSystemString));
	} else {
		btn.HideWindow();
	}
}

function OnRefreshButtonClick ()
{
	checkVisibleCombo();
	API_C_EX_PVP_RANKING_MY_INFO();
	API_C_EX_PVP_RANKING_LIST();
	setMyInfo();
	setDisableWnd();
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "RankingHelpButton":
			break;
		case "Top150Button":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "MyRankingButton":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "ShowLastWeekButton":
			bCurrentSeason =	!bCurrentSeason;
			setToggleSeasonButton();
			OnRefreshButtonClick();
			break;
		case "TabCtrl20":
		case "TabCtrl21":
		case "TabCtrl22":
		case "TabCtrl23":
			setTabState(Name);
			OnRefreshButtonClick();
			break;
	}
}

function InitData ()
{
	isFirstInit = false;
	bCurrentSeason = true;
	setToggleSeasonButton();
	setTabState("TabCtrl20");
	setLikeRadioButton("Top150Button");	
}

function OnEvent (int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_GameStart:
			InitData();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_PVP_RANKING_MY_INFO):
			ParsePacket_S_EX_PVP_RANKING_MY_INFO();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_PVP_RANKING_LIST):
			ParsePacket_S_EX_PVP_RANKING_LIST();
			break;
		case EV_Restart:
			break;
	}
}

function ParsePacket_S_EX_PVP_RANKING_MY_INFO ()
{
	local UIPacket._S_EX_PVP_RANKING_MY_INFO packet;
	local string htmlAdd;
	local string myRankTxt;
	local int nChangeRank;

	if ( !Class'UIPacket'.static.Decode_S_EX_PVP_RANKING_MY_INFO(packet) )
	{
		return;
	}
    if (packet.cType == 0)
    {
        return;
    }
	uDebug(" -->  Decode_S_EX_PVP_RANKING_MY_INFO :  " @ string(packet.nPVPPoint) @ string(packet.nRank) @ string(packet.nPrevRank) @ string(packet.nKillCount) @ string(packet.nDieCount));
	// End:0xAC
	if(packet.nPrevRank == 0)
	{
		nChangeRank = 0;		
	}
	else
	{
		nChangeRank = packet.nPrevRank - packet.nRank;
	}
	// End:0x161
	if(nChangeRank > 0)
	{
		ServerRankingArrow.ShowWindow();
		ServerRankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowUp");
		ServerRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nChangeRank)));
		ServerRankingEqualityText.SetTextColor(getInstanceL2Util().Red);		
	}
	else
	{
		// End:0x1FC
		if(nChangeRank < 0)
		{
			ServerRankingArrow.ShowWindow();
			ServerRankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowDown");
			ServerRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nChangeRank)));
			ServerRankingEqualityText.SetTextColor(getInstanceL2Util().Blue);			
		}
		else
		{
			ServerRankingEqualityText.SetText("-");
			ServerRankingEqualityText.SetTextColor(getInstanceL2Util().Gray);
			ServerRankingArrow.HideWindow();
		}
	}
	PvpMyPointText.SetText(MakeCostStringINT64(packet.nPVPPoint));
	// htmlAdd = htmlAdd $ (htmlAddText(GetSystemString(2240) $ ": ", "", getColorHexString(GTColor().Blue)));
	// htmlAdd = htmlAdd $ (htmlAddText(string(packet.nKillCount), "", getColorHexString(GTColor().White)));
	// PvpMyScoreKillText.LoadHtmlFromString(htmlSetHtmlStart(htmlAdd));
	// htmlAdd = "";
	// htmlAdd = htmlAdd $ (htmlAddText(GetSystemString(13412) $ ": ", "", getColorHexString(GTColor().Red)));
	// htmlAdd = htmlAdd $ (htmlAddText(string(packet.nDieCount), "", getColorHexString(GTColor().White)));
	// PvpMyScoreDeathText.LoadHtmlFromString(htmlSetHtmlStart(htmlAdd));
	if(packet.nRank == 0)
	{
		ServerMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));		
	}
	else
	{
		ServerMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRank)));
	}
}

function ParsePacket_S_EX_PVP_RANKING_LIST ()
{
	local UIPacket._S_EX_PVP_RANKING_LIST packet;
	local int i;
	local int nChangeRank;
	local int nRankingGroupTm;
	local int nRankingScopeTm;
	local string PledgeName;

	if ( !Class'UIPacket'.static.Decode_S_EX_PVP_RANKING_LIST(packet) )
	{
		return;
	}
	if ( isSameEventWithCurrentState(currentRankingGroup,currentRankingScope,packet.cRankingGroup,packet.cRankingScope) )
	{
		RankingTab_RichList.DeleteAllItem();
		bIAmRanker = False;
		myRankingInList = 0;
		nRankingGroup = nRankingGroupTm;
		nRankingScope = nRankingScopeTm;
	}
	
	for (i = 0; i < packet.rankInfoList.Length;i++ )
	{
		uDebug("packet.rankInfoList[i].sCharName" @ packet.rankInfoList[i].sCharName);
		uDebug("packet.rankInfoList[i].nRank" @ string(packet.rankInfoList[i].nRank));
		uDebug("packet.rankInfoList[i].nPrevRank" @ string(packet.rankInfoList[i].nPrevRank));
		if ( (1 == nRankingGroup) || (0 == nRankingGroup) )
		{
			if ( packet.rankInfoList[i].nPrevRank == 0 )
			{
				nChangeRank = 0;
			} else {
				nChangeRank = packet.rankInfoList[i].nPrevRank - packet.rankInfoList[i].nRank;
			}
		} else {
			nChangeRank = 0;
		}
		uDebug("nChangeRank" @ string(nChangeRank));
		if(packet.rankInfoList[i].sCharName == myInfo.Name)
		{
			bIAmRanker = True;
			myRankingInList = RankingTab_RichList.GetRecordCount();
		}
		if ( packet.rankInfoList[i].sPledgeName == "" )
		{
			PledgeName = GetSystemString(431);
		} else {
			PledgeName = packet.rankInfoList[i].sPledgeName;
		}
		AddRankingSystemListItem(packet.rankInfoList[i].nRank,nChangeRank,packet.rankInfoList[i].nPrevRank, getWorldServerFullName(packet.rankInfoList[i].sCharName), "Lv." $ string(packet.rankInfoList[i].nLevel),packet.rankInfoList[i].nClass, getWorldServerFullName(PledgeName), packet.rankInfoList[i].nRace,packet.rankInfoList[i].nPVPPoint,packet.rankInfoList[i].nKillCount,packet.rankInfoList[i].nDieCount);
	}
	rankingListEndHandler();
}

function AddRankingSystemListItem (int nRanking, int nChangeRank, int nPrevRank, string PlayerName, string levelStr, int nClassID, string ClanName, int nRace, INT64 pvpScore, int nKillCount, int nDieCount)
{
	local RichListCtrlRowData rowData;
	local string texStr;
	local string tmStr;
	local Color applyColor;
	local int nH;
	local int nW;
	local int tH;
	local int tW;
	local int nAddY;
	local int nAddX;
	local bool bisAllReward;

	rowData.cellDataList.Length = 5;
	bisAllReward = True;
	if ( (nRanking <= 3) && (nRanking > 0) )
	{
		if ( nRanking == 1 )
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_1st";
		} else {
			if ( nRanking == 2 )
			{
				texStr = "L2UI_ct1.RankingWnd.RankingWnd_2nd";
			} else {
				if ( nRanking == 3 )
				{
					texStr = "L2UI_ct1.RankingWnd.RankingWnd_3rd";
				}
			}
		}
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems,texStr,38,33,10,5);
		if ( bisAllReward )
		{
			applyColor = GTColor().Frangipani;
		} else {
			applyColor = GTColor().Charcoal;
		}
		nAddY = 12;
		nAddX = 6;
	} else {
		addRichListCtrlString(rowData.cellDataList[0].drawitems,string(nRanking),GTColor().Tallow,False,20,10);
		if ( bisAllReward )
		{
			applyColor = GTColor().WhiteSmoke;
		} else {
			applyColor = GTColor().Charcoal;
		}
		nAddY = 4;
		nAddX = 10;
	}
	rowData.cellDataList[0].szData = PlayerName;
	rowData.cellDataList[1].szData = levelStr;
	rowData.cellDataList[2].szData = GetClassType(nClassID);
	rowData.cellDataList[3].szData = ClanName;
	rowData.cellDataList[4].szData = getRaceSystemString(nRace);
	rowData.nReserved1 = nKillCount;
	rowData.nReserved2 = nDieCount;
	rowData.nReserved3 = pvpScore;
	levelStr = "(" $ levelStr $ ")";
	if ( (nRankingGroup == 0) && (nRankingScope == 0) && ((nPrevRank > 150) || (nPrevRank == 0)) || (nRankingGroup == 1) && (nRankingScope == 0) && ((nPrevRank > 100) || (nPrevRank == 0)) )
	{
		addRichListCtrlString(rowData.cellDataList[0].drawitems,"NEW",GTColor().Lime,False,nAddX,nAddY - 4);
	} else {
		if ( nRankingScope == 1 )
		{
			nChangeRank = 0;
		}
		if ( nChangeRank > 0 )
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems,"L2UI_CT1.RankingWnd.RankingWnd_ArrowUp",8,8,6,nAddY);
			addRichListCtrlString(rowData.cellDataList[0].drawitems,string(nChangeRank),GTColor().Froly,False,2,-4);
		} else {
			if ( nChangeRank == 0 )
			{
				addRichListCtrlString(rowData.cellDataList[0].drawitems,"-",GetColor(153,153,153,255),False,nAddX,nAddY - 4);
			} else {
				addRichListCtrlTexture(rowData.cellDataList[0].drawitems,"L2UI_CT1.RankingWnd.RankingWnd_ArrowDown",8,8,6,nAddY);
				addRichListCtrlString(rowData.cellDataList[0].drawitems,string(nChangeRank),GTColor().DeepSkyBlue,False,2,-4);
			}
		}
	}
	GetTextSizeDefault(PlayerName @ levelStr, nW, nH);
	if ( nW > 208 )
	{
		GetTextSizeDefault(levelStr,tW,tH);
		tmStr = makeShortStringByPixel(PlayerName $ " ",208 - tW,"..");
		addRichListCtrlString(rowData.cellDataList[1].drawitems,tmStr @ levelStr,applyColor,False,4,-4);
		GetTextSizeDefault(tmStr @ levelStr,nW,nH);
	} else {
		addRichListCtrlString(rowData.cellDataList[1].drawitems, PlayerName @ levelStr, applyColor, false, 4, -4);
	}
	if ( bisAllReward )
	{
		applyColor = GTColor().Silver;
	} else {
		applyColor = GTColor().Charcoal;
	}
	addRichListCtrlString(rowData.cellDataList[1].drawitems,getRaceSystemString(nRace),applyColor,False, -nW,15);
	if (GetClassTransferDegree(nClassID) >= 1)
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems,"l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(nClassID) $ "_Big",31,42,28,0);
	} else {
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems,"l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(nRace) $ "_Big",31,42,28,0);
	}
	if ( (nRanking <= 3) && (nRanking > 0) )
	{
		if ( bisAllReward )
		{
			GTColor().Frangipani;
		} else {
			applyColor = GTColor().Charcoal;
		}
	} else {
		if ( bisAllReward )
		{
			applyColor = GTColor().Silver;
		} else {
			applyColor = GTColor().Charcoal;
		}
	}
	addRichListCtrlString(rowData.cellDataList[3].drawitems,ClanName,applyColor,False,5,0);
	addRichListCtrlString(rowData.cellDataList[4].drawitems,MakeCostStringINT64(pvpScore),applyColor,False,0,0);
	nAddY = 8;
	if(bisAllReward)
	{
		if(myInfo.Name == PlayerName)
		{
			rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";
		} else {
			rowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
		}
		rowData.OverlayTexU = 734;
		rowData.OverlayTexV = 45;
	} else {
		if(myInfo.Name == PlayerName)
		{
			rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyDisableRankBg";
		} else {
			rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_DisableRankBg";
		}
		rowData.OverlayTexU = 734;
		rowData.OverlayTexV = 45;
	}
	RankingTab_RichList.InsertRecord(rowData);
}

function bool isSameEventWithCurrentState (int nRankingGroup, int nRankingScope, int nCurrentRankingGroup, int nCurrentRankingScope)
{
	switch (nRankingGroup)
	{
		case 0:
		case 1:
		if ( (nRankingGroup == nCurrentRankingGroup) && (nRankingScope == nCurrentRankingScope) )
		{
			return True;
		}
		break;
		case 2:
		case 3:
		if ( nRankingGroup == nCurrentRankingGroup )
		{
			return True;
		}
		break;
	}
	return False;
}

function rankingListEndHandler ()
{
	local int nStartRow;

	if ( RankingTab_RichList.GetRecordCount() > 0 )
	{
		DisableWndList.HideWindow();
		if ( bIAmRanker )
		{
			nStartRow = myRankingInList - 3;
			if ( nStartRow > 0 )
			{
				if ( RankingTab_RichList.GetRecordCount() > nStartRow )
				{
					RankingTab_RichList.SetStartRow(nStartRow);
				}
			}
		}
	} 
	else 
	{
		DisableWndList.ShowWindow();
		switch (currentRankingGroup)
		{
			case ServerGroup:
				List_Empty.SetText(GetSystemString(13023));
				break;
			case RaceGroup:
				List_Empty.SetText(GetSystemString(13023));
				break;
			case Pledge:
				List_Empty.SetText(GetSystemString(13023));
				break;
			case Friends:
				List_Empty.SetText(GetSystemString(13023));
				break;
		}
	}
	RankingTab_RichList.SetFocus();
}

function SetCusomTooltipAtHelpBtn ()
{
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(13019),getInstanceL2Util().White,"", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(13021),getInstanceL2Util().White,"", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(13426),getInstanceL2Util().White,"", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(13427),getInstanceL2Util().White,"", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(13499),getInstanceL2Util().White,"", true, true);
	RankingHelpButton.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function checkVisibleCombo ()
{
	if ( currentRankingGroup == RaceGroup )
	{
		if ( currentRankingScope == TopN )
		{
			RaceComboboxWnd.ShowWindow();
		} else {
			RaceComboboxWnd.HideWindow();
		}
	} else {
		RaceComboboxWnd.HideWindow();
	}
}

function setMyInfo()
{
	local Texture PledgeCrestTexture;
	local bool bPledgeCrestTexture;
	local int nClass;
	local int nLevel;

	GetPlayerInfo(myInfo);
	if ( getInstanceUIData().getIsLiveServer() )
	{
		nClass = DetailStatusWndScript.getMainClassID();
		nLevel = DetailStatusWndScript.getMainLevel();
	} else {
		nClass = myInfo.nSubClass;
		nLevel = myInfo.nLevel;
	}
	levelText.SetText("Rb." $ string(nLevel));
	ClassText.SetText(GetClassType(nClass));
	if ( myInfo.nClanID > 0 )
	{
		ClanNameText.SetText(GetClanName(myInfo.nClanID));
	} else {
		ClanNameText.SetText(GetSystemString(431));
	}
	NameText.SetText(myInfo.Name);
	bPledgeCrestTexture = Class'UIDATA_CLAN'.static.GetCrestTexture(myInfo.nClanID,PledgeCrestTexture);
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
	RaceMark.SetTexture("l2ui_ct1.RankingWnd.RankingWnd_RaceMark_" $ getRaceString(myInfo.Race));
	if(isFirstInit == false)
	{
		InitData();
		initRaceCombo();
		isFirstInit = true;
		if(myInfo.Race == 30)
		{
			RaceCategoryCombobox.SetSelectedNum(6);			
		}
		else
		{
			RaceCategoryCombobox.SetSelectedNum(myInfo.Race);
		}
	}
}

function setToggleSeasonButton ()
{
	if ( bCurrentSeason )
	{
		ShowLastWeekButton.SetTexture("L2UI_ct1.Button.Button_DF","L2UI_ct1.Button.Button_DF_Click","L2UI_ct1.Button.Button_DF_Over");
		ShowLastWeekButton.SetButtonName(3707);
	} else {
		ShowLastWeekButton.SetTexture("L2UI_ct1.Button.Button_DF","L2UI_ct1.Button.Button_DF_Click","L2UI_ct1.Button.Button_DF_Over");
		ShowLastWeekButton.SetButtonName(3706);
	}
}

function setDisableWnd ()
{
	DisableWnd.ShowWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(true);
	Me.SetTimer(TIMER_ID,REFRESH_DELAY);
}

function hideDisableWnd ()
{
	DisableWnd.HideWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(false);
	Me.KillTimer(TIMER_ID);
}

function API_C_EX_PVP_RANKING_LIST ()
{
	local array<byte> stream;
	local UIPacket._C_EX_PVP_RANKING_LIST packet;

    packet.cType = 1;
	packet.cRankingGroup = currentRankingGroup;
	packet.cRankingScope = currentRankingScope;
	packet.bCurrentSeason = byte(bCurrentSeason);
    packet.nRace = RaceCategoryCombobox.GetSelectedNum();
	
	if(! Class'UIPacket'.static.Encode_C_EX_PVP_RANKING_LIST(stream,packet))
	{
		return;
	}

	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PVP_RANKING_LIST,stream);
	uDebug("----> Api Call : C_EX_OLYMPIAD_RANKING_INFO" @ string(currentRankingGroup) @ string(currentRankingScope) @ string(bCurrentSeason) @ string(packet.nRace));
}

function API_C_EX_PVP_RANKING_MY_INFO ()
{
	local array<byte> stream;
	local UIPacket._C_EX_PVP_RANKING_MY_INFO packet;
    
    packet.cType = 1; // Combat Power

	if(! Class'UIPacket'.static.Encode_C_EX_PVP_RANKING_MY_INFO(stream,packet))
    {
        return;
    }

	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PVP_RANKING_MY_INFO,stream);
	uDebug("----> Api Call : API_C_EX_PVP_RANKING_MY_INFO" @ string(packet.cType));
}

defaultproperties
{
}
