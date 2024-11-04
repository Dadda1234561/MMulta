//================================================================================
// RankingWnd_Character.
//================================================================================

class RankingWnd_Character extends UICommonAPI;

const TIMER_ID = 1001110;
const REFRESH_DELAY = 600;
const TIMEID_NPC_DELAY = 1000101011;
const NpcSpawnDialogID = 11122;

var WindowHandle Me;
var WindowHandle DisableWnd;
var WindowHandle DisableWndList;
var WindowHandle ClassComboboxWnd;
var ComboBoxHandle ClassCharacterCombobox;
var TextBoxHandle List_Empty;
var TextureHandle RaceMark;
var TextureHandle ClanMark;
var TextureHandle ClanMarkClassic;
var TextBoxHandle ClanNameText;
var TextBoxHandle levelText;
var TextBoxHandle ClassText;
var TextBoxHandle NameText;
var TextBoxHandle ServerRankingText;
var ButtonHandle RankingHelpButton;
var TextureHandle ClassRankingArrow;
var TextBoxHandle ClassRankingEqualityText;
var TextBoxHandle ClassMyRankingText;
var TextBoxHandle RaceRankingText;
var TextureHandle ServerRankingArrow;
var TextBoxHandle ServerRankingEqualityText;
var TextBoxHandle ServerMyRankingText;
var TextureHandle RaceRankingArrow;
var TextBoxHandle RaceRankingEqualityText;
var TextBoxHandle RaceMyRankingText;
var ButtonHandle DetailInformationButton;
var WindowHandle RankingTabAllWnd;
var ButtonHandle Top150Button;
var ButtonHandle MyRankingButton;
var ButtonHandle refreshButton;
var WindowHandle RaceComboboxWnd;
var TextBoxHandle RaceCategoryText;
var ComboBoxHandle RaceCategoryCombobox;
var RichListCtrlHandle RankingTab_RichList;
var TextureHandle RankingBg2;
var TabHandle TabCtrl2;
var TextureHandle RankingRewardICON_Ani;
var ButtonHandle RankingRewardICON_Btn;
var ButtonHandle RankingRewardMenberCheck_Btn;
var WindowHandle LiveRankingWnd;
var int nRanking;
var UserInfo myInfo;
var int nRankingGroup;
var int nRankingScope;
var RankingScope currentRankingScope;
var RankingGroup currentRankingGroup;
var bool bIAmRanker;
var int myRankingInList;
var bool isFirstInit;
var DetailStatusWnd DetailStatusWndScript;

var string m_WindowName;
var int npcSpawnTime;
var bool bFirstShow;

function OnRegisterEvent()
{
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_MyRankingDetailInfo);
	RegisterEvent(EV_CharacterRankingListBegin);
	RegisterEvent(EV_CharacterRankingInfo);
	RegisterEvent(EV_CharacterRankingListEnd);
	
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_CHAR_BUFFZONE_NPC_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION);

}

function OnLoad()
{
	Initialize();
}

function Initialize()
{
	isFirstInit = false;
	m_WindowName = getCurrentWindowName(string(self));
	DetailStatusWndScript = DetailStatusWnd(GetScript("DetailStatusWnd"));
	Me = GetWindowHandle(m_WindowName);
	DisableWnd = GetWindowHandle(m_WindowName $ ".DisableWnd");
	DisableWndList = GetWindowHandle(m_WindowName $ ".DisableWndList");
	ClassComboboxWnd = GetWindowHandle(m_WindowName $ ".ClassComboboxWnd");
	ClassCharacterCombobox = GetComboBoxHandle(m_WindowName $ ".ClassComboboxWnd.ClassCharacterCombobox");
	List_Empty = GetTextBoxHandle(m_WindowName $ ".DisableWndList.List_Empty");
	RaceMark = GetTextureHandle(m_WindowName $ ".RaceMark");
	ClanMark = GetTextureHandle(m_WindowName $ ".ClanMark");
	ClanMarkClassic = GetTextureHandle(m_WindowName $ ".ClanMarkClassic");
	ClanNameText = GetTextBoxHandle(m_WindowName $ ".ClanNameText");
	levelText = GetTextBoxHandle(m_WindowName $ ".LevelText");
	ClassText = GetTextBoxHandle(m_WindowName $ ".ClassText");
	NameText = GetTextBoxHandle(m_WindowName $ ".NameText");
	ServerRankingText = GetTextBoxHandle(m_WindowName $ ".ServerRankingText");
	RankingHelpButton = GetButtonHandle(m_WindowName $ ".RankingHelpButton");
	ServerRankingArrow = GetTextureHandle(m_WindowName $ ".ServerRankingArrow");
	ServerRankingEqualityText = GetTextBoxHandle(m_WindowName $ ".ServerRankingEqualityText");
	ServerMyRankingText = GetTextBoxHandle(m_WindowName $ ".ServerMyRankingText");
	RaceRankingText = GetTextBoxHandle(m_WindowName $ ".RaceRankingText");
	RaceRankingArrow = GetTextureHandle(m_WindowName $ ".RaceRankingArrow");
	RaceRankingEqualityText = GetTextBoxHandle(m_WindowName $ ".RaceRankingEqualityText");
	RaceMyRankingText = GetTextBoxHandle(m_WindowName $ ".RaceMyRankingText");
	ClassRankingArrow = GetTextureHandle(m_WindowName $ ".LiveRankingWnd.ClassRankingArrow");
	ClassRankingEqualityText = GetTextBoxHandle(m_WindowName $ ".LiveRankingWnd.ClassRankingEqualityText");
	ClassMyRankingText = GetTextBoxHandle(m_WindowName $ ".LiveRankingWnd.ClassMyRankingText");
	DetailInformationButton = GetButtonHandle(m_WindowName $ ".DetailInformationButton");
	RankingTabAllWnd = GetWindowHandle(m_WindowName $ ".RankingTabAllWnd");
	Top150Button = GetButtonHandle(m_WindowName $ ".RankingTabAllWnd.Top150Button");
	MyRankingButton = GetButtonHandle(m_WindowName $ ".RankingTabAllWnd.MyRankingButton");
	refreshButton = GetButtonHandle(m_WindowName $ ".RankingTabAllWnd.RefreshButton");
	RaceComboboxWnd = GetWindowHandle(m_WindowName $ ".RankingTabAllWnd.RaceComboboxWnd");
	RaceCategoryText = GetTextBoxHandle(m_WindowName $ ".RankingTabAllWnd.RaceComboboxWnd.RaceCategoryText");
	RaceCategoryCombobox = GetComboBoxHandle(m_WindowName $ ".RankingTabAllWnd.RaceComboboxWnd.RaceCategoryCombobox");
	RankingTab_RichList = GetRichListCtrlHandle(m_WindowName $ ".RankingTabAllWnd.RankingTab_RichList");
	RankingBg2 = GetTextureHandle(m_WindowName $ ".RankingTabAllWnd.RankingBg2");
	GetTabHandle(m_WindowName $ ".RankingTabAllWnd.TabCtrl2_Classic").HideWindow();
	GetTabHandle(m_WindowName $ ".RankingTabAllWnd.TabCtrl2_Live").HideWindow();
	TabCtrl2 = GetTabHandle(m_WindowName $ ".RankingTabAllWnd.TabCtrl2_Classic");
	RankingTab_RichList.SetSelectedSelTooltip(false);
	RankingTab_RichList.SetAppearTooltipAtMouseX(true);
	RankingTab_RichList.SetUseStripeBackTexture(false);
	RankingTab_RichList.SetTooltipType("RankingReward");
	RankingRewardICON_Ani = GetTextureHandle(m_WindowName $ ".RankingRewardICON_Ani");
	RankingRewardICON_Btn = GetButtonHandle(m_WindowName $ ".RankingRewardICON_Btn");
	RankingRewardICON_Btn.SetTooltipType("text");
	RankingRewardMenberCheck_Btn = GetButtonHandle(m_WindowName $ ".RankingRewardMenberCheck_Btn");
	RankingRewardMenberCheck_Btn.HideWindow();
	LiveRankingWnd = GetWindowHandle(m_WindowName $ ".LiveRankingWnd");
	initUI();
}

function OnShow()
{
	// End:0x5B
	if(GetWindowHandle("RankingWnd").IsShowWindow())
	{
		DisableWndList.HideWindow();
		SetCusomTooltipAtHelpBtn();
		OnRefreshButtonClick();
		RankingRewardICON_Btn.SetTooltipCustomType(MakeTooltipSimpleText(krTooltip()));
		initFirstShow();
	}
}

function initFirstShow()
{
	// End:0x39B
	if(! bFirstShow)
	{
		// End:0x210
		if(getInstanceUIData().getIsLiveServer())
		{
			LiveRankingWnd.ShowWindow();
			ClassComboboxWnd.ShowWindow();
			ServerRankingArrow = GetTextureHandle(m_WindowName $ ".LiveRankingWnd.ServerRankingArrow");
			ServerRankingEqualityText = GetTextBoxHandle(m_WindowName $ ".LiveRankingWnd.ServerRankingEqualityText");
			ServerMyRankingText = GetTextBoxHandle(m_WindowName $ ".LiveRankingWnd.ServerMyRankingText");
			RaceRankingText = GetTextBoxHandle(m_WindowName $ ".LiveRankingWnd.RaceRankingText");
			RaceRankingArrow = GetTextureHandle(m_WindowName $ ".LiveRankingWnd.RaceRankingArrow");
			RaceRankingEqualityText = GetTextBoxHandle(m_WindowName $ ".LiveRankingWnd.RaceRankingEqualityText");
			RaceMyRankingText = GetTextBoxHandle(m_WindowName $ ".LiveRankingWnd.RaceMyRankingText");
			TabCtrl2 = GetTabHandle(m_WindowName $ ".RankingTabAllWnd.TabCtrl2_Live");
			TabCtrl2.ShowWindow();
			initComboBox_ClassID();
		}
		else
		{
			LiveRankingWnd.ShowWindow();
			ClassComboboxWnd.ShowWindow();
			ServerRankingArrow = GetTextureHandle(m_WindowName $ ".LiveRankingWnd.ServerRankingArrow");
			ServerRankingEqualityText = GetTextBoxHandle(m_WindowName $ ".LiveRankingWnd.ServerRankingEqualityText");
			ServerMyRankingText = GetTextBoxHandle(m_WindowName $ ".LiveRankingWnd.ServerMyRankingText");
			RaceRankingText = GetTextBoxHandle(m_WindowName $ ".LiveRankingWnd.RaceRankingText");
			RaceRankingArrow = GetTextureHandle(m_WindowName $ ".LiveRankingWnd.RaceRankingArrow");
			RaceRankingEqualityText = GetTextBoxHandle(m_WindowName $ ".LiveRankingWnd.RaceRankingEqualityText");
			RaceMyRankingText = GetTextBoxHandle(m_WindowName $ ".LiveRankingWnd.RaceMyRankingText");
			TabCtrl2 = GetTabHandle(m_WindowName $ ".RankingTabAllWnd.TabCtrl2_Classic");
			TabCtrl2.ShowWindow();
			initComboBox_ClassID();
		}
		bFirstShow = true;
	}
}

function string krTooltip()
{
	// End:0x41
	if(GetLanguage() == LANG_Korean)
	{
		return "			  " $ GetSystemString(13459) $ "			  ";
	}
	return GetSystemString(13459);
}

function OnHide()
{
}

function OnTimer(int TimeID)
{
	if (TimeID == TIMER_ID)
	{
		hideDisableWnd();
	}
	else if ( TimeID == TIMEID_NPC_DELAY )
	{
		npcSpawnTime = npcSpawnTime - 1;
		refreshNpcSpawnTooltip();
	}
}

function OnComboBoxItemSelected(string strID, int Index)
{
	OnRefreshButtonClick();
}

function AddRankingSystemListItem (int nRanking, int nChangeRank, int nRewardServerRank, int nRewardRaceRank, int nRewardClassRank, string PlayerName, string levelStr, int nClassID, string ClanName, int nRace, string ServerName)
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
	local int nAddY2;
	local int rewardGrade;
	local int SkillID;
	local int i;
	local bool bisAllReward;

	rowData.cellDataList.Length = 5;
	rewardGrade = GetRankingGrade(RANKTYPE_Character, ServerGroup, nRewardServerRank);
	if ((rewardGrade <= 3) && (rewardGrade > 0))
	{
		bisAllReward = True;
	}
	if ((currentRankingGroup == RankingGroup.Pledge) || (currentRankingGroup == RankingGroup.Friends) || (nRankingScope == RankingScope.AroundMe))
	{
		bisAllReward = True;
	}
	if ((nRanking <= 3) && (nRanking > 0))
	{
		if (nRanking == 1)
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_1st";
		}
		else if (nRanking == 2)
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_2nd";
		}
		else if (nRanking == 3)
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_3rd";
		}
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, texStr, 38, 33, 10, 5);
		if (bisAllReward)
		{
			applyColor = GetColor(254, 215, 160, 255);
		}
		else
		{
			applyColor = GetColor(70, 70, 70, 255);
		}
		nAddY = 12;
		nAddX = 6;
	}
	else
	{
		addRichListCtrlString(rowData.cellDataList[0].drawitems, string(nRanking), GetColor(170, 153, 119, 255), False, 20, 10);
		if (bisAllReward)
		{
			applyColor = GetColor(240, 240, 240, 255);
		}
		else
		{
			applyColor = GetColor(70, 70, 70, 255);
		}
		nAddY = 4;
		nAddX = 10;
	}
	RowData.cellDataList[0].szData = PlayerName $ ServerName;
	rowData.cellDataList[1].szData = levelStr;
	rowData.cellDataList[2].szData = GetClassType(nClassID);
	// End:0x2A0
	if(ClanName == GetSystemString(431))
	{
		RowData.cellDataList[3].szData = ClanName;		
	}
	else
	{
		RowData.cellDataList[3].szData = ClanName $ ServerName;
	}
	rowData.cellDataList[4].szData = getRaceSystemString(nRace);
	levelStr = "(" $ levelStr $ ")";
	if (getInstanceUIData().getIsLiveServer() && (nRankingGroup == RankingGroup.ServerGroup) && (nRankingScope == RankingScope.TopN) && ((nRewardServerRank > 150) || (nRewardServerRank == 0)) && (nRanking <= 150) || (nRankingGroup == RankingGroup.RaceGroup) && (nRankingScope == RankingScope.TopN) && ((nRewardRaceRank > 100) || (nRewardRaceRank == 0)) && (nRanking <= 100) || (nRankingGroup == RankingGroup.ClassRankingGroup) && (nRankingScope == RankingScope.TopN) && ((nRewardClassRank > 100) || (nRewardClassRank == RankingScope.TopN)) && (nRanking <= 100) )
	{
		addRichListCtrlString(rowData.cellDataList[0].drawitems, "NEW", GetColor(0, 255, 0, 255), False, nAddX, nAddY - 4);
	}
	else if(((getInstanceUIData().getIsClassicServer() && (((nRankingGroup == 0) && nRankingScope == 0) && (nRewardServerRank > 100) || nRewardServerRank == 0) && nRanking <= 100) || (((nRankingGroup == 1) && nRankingScope == 0) && (nRewardRaceRank > 10) || nRewardRaceRank == 0) && nRanking <= 10) || (((nRankingGroup == 4) && nRankingScope == 0) && (nRewardClassRank > 100) || nRewardClassRank == 0) && nRanking <= 100)
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, "NEW", GetColor(0, 255, 0, 255), false, nAddX, nAddY - 4);			
	}
	else
	{
		if ( nRankingScope == RankingScope.AroundMe && (nRewardServerRank == 0 || nRewardRaceRank == 0 || nRewardClassRank == 0))
		{
			nChangeRank = 0;
		}
		if (nChangeRank > 0)
		{
			addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowUp", 8, 8, 6, nAddY);
			addRichListCtrlString(RowData.cellDataList[0].drawitems, string(nChangeRank), GetColor(230, 101, 101, 255), false, 2, -4);
		}
		else
		{
			if (nChangeRank == 0)
			{
				addRichListCtrlString(rowData.cellDataList[0].drawitems, "-", GetColor(153, 153, 153, 255), False, nAddX, nAddY - 4);
			}
			else
			{
				addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowDown", 8, 8, 6, nAddY);
				addRichListCtrlString(rowData.cellDataList[0].drawitems, string(nChangeRank), GetColor(0, 170, 255, 255), False, 2, -4);
			}
		}
	}
	GetTextSizeDefault(PlayerName $ ServerName @ levelStr, nW, nH);
	if (nW > 208)
	{
		GetTextSizeDefault(levelStr, tW, tH);
		tmStr = makeShortStringByPixel(PlayerName $ " ", 208 - tW, "..");
		addRichListCtrlString(rowData.cellDataList[1].drawitems, tmStr $ ServerName @ levelStr, applyColor, False, 4, -4);
		GetTextSizeDefault(tmStr @levelStr, nW, nH);
	}
	else
	{
		addRichListCtrlString(rowData.cellDataList[1].drawitems, (PlayerName $ ServerName) @ levelStr, applyColor, False, 4, -4);
	}
	if (bisAllReward)
	{
		applyColor = GetColor(182, 182, 182, 255);
	}
	else
	{
		applyColor = GetColor(70, 70, 70, 255);
	}
	addRichListCtrlString(rowData.cellDataList[1].drawitems, getRaceSystemString(nRace), applyColor, true, 3, 2);
	if (GetClassTransferDegree(nClassID) >= 1)
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(nClassID) $ "_Big", 31, 42, 28, 0);
	}
	else
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(nRace) $ "_Big", 31, 42, 28, 0);
	}
	if ((nRanking <= 3) && (nRanking > 0))
	{
		if (bisAllReward)
		{
			GetColor(254, 215, 160, 255);
		}
		else
		{
			applyColor = GetColor(70, 70, 70, 255);
		}
	}
	else
	{
		if (bisAllReward)
		{
			applyColor = GetColor(182, 182, 182, 255);
		}
		else
		{
			applyColor = GetColor(70, 70, 70, 255);
		}
	}
	// End:0x86C
	if(ClanName == GetSystemString(431))
	{
		addRichListCtrlString(RowData.cellDataList[3].drawitems, ClanName, applyColor, false, 5, 0);		
	}
	else
	{
		addRichListCtrlString(RowData.cellDataList[3].drawitems, ClanName $ ServerName, applyColor, false, 5, 0);
	}
	nAddY = 8;
	nAddY2 = 1;
	// End:0x8E3
	if(IsAdenServer() && IsPlayerOnWorldRaidServer())
	{
		addRichListCtrlString(RowData.cellDataList[4].drawitems, "-", applyColor, false, 5, 0);		
	}
	else
	{
	    for (i = 1; i <= 3; i++)
	    {
			SkillID = GetRankingRewardSkillID(RankingType.RANKTYPE_Character, RankingGroup.ServerGroup, i);
			//AddSystemMessageString("skill id for" @ SkillID);
			addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 6, nAddY);
			addRichListCtrlTexture(rowData.cellDataList[4].drawitems, getSkillTex(SkillID), 32, 32, -34, nAddY2);
			rowData.cellDataList[4].drawitems[rowData.cellDataList[4].drawitems.Length - 1].nReservedTooltipID = SkillID;
			nAddY = -1;
			nAddY2 = 1;
			if (isRewardGrade(rewardGrade, i))
			{
				rowData.cellDataList[4].drawitems[rowData.cellDataList[4].drawitems.Length - 1].TooltipDesc = "on";
			}
			else
			{
				rowData.cellDataList[4].drawitems[rowData.cellDataList[4].drawitems.Length - 1].TooltipDesc = "off";
				addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_DisableSlotOpa70", 32, 32, -32, 0);
			}
	    }
		SkillID = GetRankingRewardSkillID(RankingType.RANKTYPE_Character, RankingGroup.RaceGroup, 1);
		//AddSystemMessageString("skill id" @ SkillID);
		rewardGrade = GetRankingGrade(RANKTYPE_Character, RaceGroup, nRewardRaceRank);
		addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 26, 26, 18, 6);
		addRichListCtrlTexture(rowData.cellDataList[4].drawitems, getSkillTex(SkillID), 24, 24, -24, 1, 32, 32);
		rowData.cellDataList[4].drawitems[rowData.cellDataList[4].drawitems.Length - 1].nReservedTooltipID = SkillID;
	    if (rewardGrade >= 1)
	    {
			rowData.cellDataList[4].drawitems[rowData.cellDataList[4].drawitems.Length - 1].TooltipDesc = "on";
	    }
	    else
	    {
			rowData.cellDataList[4].drawitems[rowData.cellDataList[4].drawitems.Length - 1].TooltipDesc = "off";
			addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_DisableSlotOpa70", 26, 26, -25, -1);
	    }
	}
	
	if(true) //getInstanceUIData().getIsLiveServer())
	{
		SkillID = GetRankingRewardSkillID(RankingType.RANKTYPE_Character,RankingGroup.ClassRankingGroup,1);
		//AddSystemMessageString("getIsLiveServer" @ SkillID);

		rewardGrade = GetRankingGrade(RANKTYPE_Character,ClassRankingGroup,nRewardClassRank);
		addRichListCtrlTexture(rowData.cellDataList[4].drawitems,"L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2",26,26,,-1);
		addRichListCtrlTexture(rowData.cellDataList[4].drawitems,getSkillTex(SkillID),24,24,-24,1,32,32);
		rowData.cellDataList[4].drawitems[rowData.cellDataList[4].drawitems.Length - 1].nReservedTooltipID = SkillID;
		if ( rewardGrade >= 1 )
		{
			rowData.cellDataList[4].drawitems[rowData.cellDataList[4].drawitems.Length - 1].TooltipDesc = "on";
		}
		else
		{
			rowData.cellDataList[4].drawitems[rowData.cellDataList[4].drawitems.Length - 1].TooltipDesc = "off";
			addRichListCtrlTexture(rowData.cellDataList[4].drawitems,"L2UI_CT1.RankingWnd.RankingWnd_DisableSlotOpa70",26,26,-25,-1);
		}
  }
	
	if (bisAllReward)
	{
		if(getWorldNameToLocalName(myInfo.Name) == PlayerName)
		{
			rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";
		}
		else
		{
			rowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
		}
		rowData.OverlayTexU = 734;
		rowData.OverlayTexV = 45;
	}
	else
	{
		if(getWorldNameToLocalName(myInfo.Name) == PlayerName)
		{
			rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyDisableRankBg";
		}
		else
		{
			rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_DisableRankBg";
		}
		rowData.OverlayTexU = 734;
		rowData.OverlayTexV = 45;
	}
	RankingTab_RichList.InsertRecord(rowData);
}

function bool isRewardGrade(int rewardGrade, int rewardNum)
{
	if ((rewardGrade == 1) && ((rewardNum == 1) || (rewardNum == 2) || (rewardNum == 3)))
	{
		return True;
	}
	else if ((rewardGrade == 2) && ((rewardNum == 1) || (rewardNum == 2)))
	{
		return True;
	}
	else if ((rewardGrade == 3) && (rewardNum == 1))
	{
		return True;
	}
	return False;
}

function checkVisibleCombo()
{
	if (currentRankingGroup == RaceGroup)
	{
		if (currentRankingScope == RankingScope.TopN)
		{
			RaceComboboxWnd.ShowWindow();
			ClassComboboxWnd.HideWindow();
		}
		else
		{
			RaceComboboxWnd.HideWindow();
			ClassComboboxWnd.HideWindow();
		}
	}
	else
	{
		if ( currentRankingGroup == ClassRankingGroup )
		{
			if ( currentRankingScope == RankingScope.TopN )
			{
				RaceComboboxWnd.HideWindow();
				ClassComboboxWnd.ShowWindow();
			}
			else
			{
				RaceComboboxWnd.HideWindow();
				ClassComboboxWnd.HideWindow();
			}
		}
		else
		{
			RaceComboboxWnd.HideWindow();
			ClassComboboxWnd.HideWindow();
		}
	}
}

function OnRClickButton(string Name)
{
	switch (Name)
	{
		case "TabCtrl2_Classic0":
		case "TabCtrl2_Classic1":
		case "TabCtrl2_Classic2":
		case "TabCtrl2_Classic3":
		case "TabCtrl2_Classic4":
		case "TabCtrl2_Live0":
		case "TabCtrl2_Live1":
		case "TabCtrl2_Live2":
		case "TabCtrl2_Live3":
		case "TabCtrl2_Live4":
		setTabState(Name);
			OnRefreshButtonClick();
			break;
		default:
	}
}

function OnClickButton(string Name)
{
	switch (Name)
	{
		case "DetailInformationButton":
			OnDetailInformationButtonClick();
			break;
		case "RankingRewardICON_Btn":
			ShowNpcShowAskDialog();
			break;
		case "Top150Button":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "MyRankingButton":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "RefreshButton":
			OnRefreshButtonClick();
			break;
		case "TabCtrl2_Classic0":
		case "TabCtrl2_Classic1":
		case "TabCtrl2_Classic2":
		case "TabCtrl2_Classic3":
		case "TabCtrl2_Classic4":
		case "TabCtrl2_Live0":
		case "TabCtrl2_Live1":
		case "TabCtrl2_Live2":
		case "TabCtrl2_Live3":
		case "TabCtrl2_Live4":
			setTabState(Name);
			OnRefreshButtonClick();
			break;
	}
}

function ShowNpcShowAskDialog ()
{
	if ( npcSpawnTime > 0 )
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13307));
	}
	else
	{
		Class'UICommonAPI'.static.DialogSetID(NpcSpawnDialogID);
		DialogShow(DialogModalType_Modalless,DialogType_OKCancel,MakeFullSystemMsg(GetSystemMessage(13308),""),string(self));
	}
}

function setTabState(string TabName)
{
	if (getInstanceUIData().getIsLiveServer())
	{
		ReplaceText(TabName, "_Live", "");
		uDebug(TabName);
		switch (TabName)
		{
			case "TabCtrl20":
				SettingButton(Top150Button, True, 13016);
				SettingButton(MyRankingButton, True, 3975);
				RaceComboboxWnd.HideWindow();
				currentRankingGroup = ServerGroup;
				break;
			case "TabCtrl21":
				SettingButton(Top150Button, True, 3972);
				SettingButton(MyRankingButton, True, 3975);
				currentRankingGroup = RaceGroup;
				break;
			case "TabCtrl22":
				SettingButton(Top150Button, True, 3972);
				SettingButton(MyRankingButton, True, 3975);
				currentRankingGroup = ClassRankingGroup;
				break;
			case "TabCtrl23":
				SettingButton(Top150Button, False);
				SettingButton(MyRankingButton, False);
				RaceComboboxWnd.HideWindow();
				currentRankingGroup = Pledge;
				break;
			case "TabCtrl24":
				SettingButton(Top150Button, False);
				SettingButton(MyRankingButton, False);
				RaceComboboxWnd.HideWindow();
				currentRankingGroup = Friends;
				break;
		}
	}
	else
	{
		ReplaceText(TabName, "_Classic", "");
		uDebug(TabName);
		switch (TabName)
		{
			case "TabCtrl20":
				SettingButton(Top150Button, True, 3972);
				SettingButton(MyRankingButton, false);
				RaceComboboxWnd.HideWindow();
				currentRankingGroup = ServerGroup;
				break;
			case "TabCtrl21":
				SettingButton(Top150Button, True, 14293);
				SettingButton(MyRankingButton, false);
				currentRankingGroup = RaceGroup;
				break;
			case "TabCtrl22":
				SettingButton(Top150Button, True, 14293);
				SettingButton(MyRankingButton, false);
				currentRankingGroup = ClassRankingGroup;
				break;
			case "TabCtrl23":
				SettingButton(Top150Button, false);
				SettingButton(MyRankingButton, false);
				RaceComboboxWnd.HideWindow();
				currentRankingGroup = Pledge;
				break;
			case "TabCtrl24":
				SettingButton(Top150Button, false);
				SettingButton(MyRankingButton, false);
				RaceComboboxWnd.HideWindow();
				currentRankingGroup = Friends;
				break;
		}
	}
}

function setLikeRadioButton(string buttonName)
{
	if (buttonName == "Top150Button")
	{
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = RankingScope.TopN;
	}
	else
	{
		if (buttonName == "MyRankingButton")
		{
			MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
			Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
			currentRankingScope = RankingScope.AroundMe;
		}
	}
}

function settingButton(ButtonHandle btn, bool bShow, optional int nSystemString)
{
	if (bShow)
	{
		btn.ShowWindow();
		btn.SetNameText(GetSystemString(nSystemString));
	}
	else
	{
		btn.HideWindow();
	}
}

function OnDetailInformationButtonClick()
{
	checkShowRankingHistoryWnd();
}

function checkShowRankingHistoryWnd()
{
	if (Class 'UIAPI_WINDOW'.static.IsShowWindow("RankingHistoryWnd"))
	{
		Class 'UIAPI_WINDOW'.static.HideWindow("RankingHistoryWnd");
	}
	else
	{
		RequestMyRankingHistory();
	}
}

function OnRefreshButtonClick()
{
	local int nComboIndex, nRace;

	checkVisibleCombo();
	RequestRankingCharInfo();
	setMyInfo();
	nComboIndex = ClassCharacterCombobox.GetSelectedNum();
	// End:0x69
	if(IsAdenServer())
	{
		// End:0x51
		if(RaceCategoryCombobox.GetSelectedNum() == 6)
		{
			nRace = 30;			
		}
		else
		{
			nRace = RaceCategoryCombobox.GetSelectedNum();
		}		
	}
	else
	{
		nRace = RaceCategoryCombobox.GetSelectedNum();
	}
	RequestRankingCharRankers(currentRankingGroup,currentRankingScope, nRace, ClassCharacterCombobox.GetReserved(nComboIndex));
	setDisableWnd();
}

function OnEvent(int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_MyRankingDetailInfo:
			MyRankingDetailInfoHandler(param);
			break;
		case EV_CharacterRankingListBegin:
			characterRankingListBeginHandler(param);
			break;
		case EV_CharacterRankingInfo:
			if (isSameEventWithCurrentState(currentRankingGroup, currentRankingScope, nRankingGroup, nRankingScope))
			{
				addListByCharacterRankingInfo(param);
			}
			break;
		case EV_CharacterRankingListEnd:
			if (isSameEventWithCurrentState(currentRankingGroup, currentRankingScope, nRankingGroup, nRankingScope))
			{
				characterRankingListEndHandler(param);
			}
			break;
		
		case EV_PacketID(class'UIPacket'.const.S_EX_RANKING_CHAR_BUFFZONE_NPC_INFO):
			ParsePacket_S_EX_RANKING_CHAR_BUFFZONE_NPC_INFO();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION):
			ParsePacket_S_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION();
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
		case EV_DialogCancel:
			break;
		case EV_Restart:
			initUI();
			break;
		default:
	}
}

function HandleDialogOK ()
{
	local int dialogID;

	if (  !DialogIsMine() )
	{
		return;
	}
	dialogID = DialogGetID();
	if ( dialogID == NpcSpawnDialogID )
	{
		API_C_EX_RANKING_CHAR_SPAWN_BUFFZONE_NPC();
	}
}

function initUI()
{
	local int i;

	bFirstShow = False;
	npcSpawnTime = 0;
	Me.KillTimer(TIMEID_NPC_DELAY);

	RankingTab_RichList.DeleteAllItem();
	TabCtrl2.SetTopOrder(0, False);
	setTabState("TabCtrl20");
	setLikeRadioButton("Top150Button");
	RaceRankingEqualityText.SetText("");
	ServerRankingEqualityText.SetText("");
	ServerMyRankingText.SetText("");
	RaceMyRankingText.SetText("");
	RankingRewardMenberCheck_Btn.HideWindow();
	isFirstInit = False;
	hideDisableWnd();
	RaceCategoryCombobox.Clear();
	if (getInstanceUIData().getIsLiveServer())
	{
		for (i = 0; i < 7; i++)
		{
			RaceCategoryCombobox.AddString(getRaceSystemString(i));
		}
	}
	else
	{
		for (i = 0; i < 6; i++)
		{
			RaceCategoryCombobox.AddString(getRaceSystemString(i));
		}
		// End:0x17C
		if(IsAdenServer())
		{
			RaceCategoryCombobox.AddString(getRaceSystemString(30));
		}
	}
	RankingRewardICON_Ani.HideWindow();
	RankingRewardICON_Btn.HideWindow();
}

function int myClassID()
{
	local int nClass;

	if (getInstanceUIData().getIsLiveServer())
	{
		nClass = DetailStatusWndScript.getMainClassID();
	}
	else
	{
		nClass = myInfo.nSubClass;
	}
	return nClass;
}

function initComboBox_ClassID()
{
	local int classIndex;
	local int Max;
	local int nClassSystemString;
	local int nMyClassID;
	local int nOriginalClassID;
	local int selectIndex;
	local string fullNameString;
	local bool bSelect;

	nMyClassID = myClassID();
	Max = class'UIDataManager'.static.GetClassTypeMaxCount();
	ClassCharacterCombobox.Clear();
	bSelect = false;
	
	for (classIndex = 0; classIndex < Max; classIndex++)
	{
		nClassSystemString = class'UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(classIndex);
		fullNameString = GetSystemString(nClassSystemString);
		nOriginalClassID = -1;
		// End:0x299
		if(fullNameString != "")
		{
			// End:0x130
			if(getInstanceUIData().getIsClassicServer())
			{
				// End:0x12D
				if(GetClassTransferDegree(classIndex) > 2)
				{
					nOriginalClassID = class'UIDataManager'.static.GetRootClassID(classIndex);
					// End:0x12D
					if(nOriginalClassID > -1)
					{
						// End:0x114
						if(IsDeathKnightClass(nOriginalClassID))
						{
							// End:0x111
							if(classIndex == 199)
							{
								ClassCharacterCombobox.AddStringWithReserved(fullNameString, classIndex);
							}
						}
						else
						{
							ClassCharacterCombobox.AddStringWithReserved(fullNameString, classIndex);
						}
					}
				}
			}
			else
			{
				// End:0x232
				if(GetClassTransferDegree(classIndex) == 3)
				{
					nOriginalClassID = class'UIDataManager'.static.GetRootClassID(classIndex);
					// End:0x232
					if(nOriginalClassID > -1)
					{
						// End:0x232
						if(classIndex != 216)
						{
							ClassCharacterCombobox.AddStringWithReserved(fullNameString, classIndex);
							// End:0x232
							if(classIndex == 151)
							{
								// End:0x1C8
								if(nMyClassID == 151)
								{
									selectIndex = ClassCharacterCombobox.GetNumOfItems() - 1;
									bSelect = true;
								}
								nClassSystemString = class'UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(216);
								fullNameString = GetSystemString(nClassSystemString);
								ClassCharacterCombobox.AddStringWithReserved(fullNameString, 216);
								// End:0x232
								if(nMyClassID == 216)
								{
									selectIndex = ClassCharacterCombobox.GetNumOfItems() - 1;
									bSelect = true;
								}
							}
						}
					}
				}
			}
			// End:0x299
			if(classIndex != 151 && classIndex != 216)
			{
				// End:0x299
				if(nOriginalClassID > -1 && nMyClassID > 0 && nMyClassID == classIndex)
				{
					selectIndex = ClassCharacterCombobox.GetNumOfItems() - 1;
					bSelect = true;
				}
			}
		}
	}
	// End:0x2C2
	if(bSelect == false)
	{
		ClassCharacterCombobox.SetSelectedNum(0);
	}
	else
	{
		ClassCharacterCombobox.SetSelectedNum(selectIndex);
	}
	uDebug("?��?�� ?��?�� 초기?�� ");
}

function MyRankingDetailInfoHandler(string param)
{
	local int nServerRank;
	local int nRaceRank;
	local int nClassRank;
	local int nServerRank_Snapshot;
	local int nRaceRank_Snapshot;
	local int nClassRank_Snapshot;

	uDebug("MyRankingDetailInfoHandler" @ param);
	ParseInt(param, "ServerRank", nServerRank);
	ParseInt(param, "RaceRank", nRaceRank);
	ParseInt(param, "RewardServerRank", nServerRank_Snapshot);
	ParseInt(param, "RewardRaceRank", nRaceRank_Snapshot);
	ParseInt(param,"ClassRank",nClassRank);
	ParseInt(param,"RewardClassRank",nClassRank_Snapshot);
	if (nServerRank_Snapshot == 0)
	{
		nServerRank_Snapshot = nServerRank;
	}
	if (nRaceRank_Snapshot == 0)
	{
		nRaceRank_Snapshot = nRaceRank;
	}
	if ( nClassRank_Snapshot == 0 )
	{
		nClassRank_Snapshot = nClassRank;
	}
	if (nServerRank_Snapshot - nServerRank > 0)
	{
		ServerRankingArrow.ShowWindow();
		ServerRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowUp");
		ServerRankingEqualityText.SetTextColor(GetColor(230, 101, 101, 255));
		ServerRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nServerRank_Snapshot - nServerRank)));
	}
	else
	{
		if (nServerRank_Snapshot - nServerRank < 0)
		{
			ServerRankingArrow.ShowWindow();
			ServerRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowDown");
			ServerRankingEqualityText.SetTextColor(GetColor(0, 170, 255, 255));
			ServerRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nServerRank_Snapshot - nServerRank)));
		}
		else
		{
			ServerRankingArrow.HideWindow();
			ServerRankingEqualityText.SetTextColor(GetColor(153, 153, 153, 255));
			ServerRankingEqualityText.SetText("-");
		}
	}
	if (nRaceRank_Snapshot - nRaceRank > 0)
	{
		RaceRankingArrow.ShowWindow();
		RaceRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowUp");
		RaceRankingEqualityText.SetTextColor(GetColor(230, 101, 101, 255));
		RaceRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nRaceRank_Snapshot - nRaceRank)));
	}
	else
	{
		if (nRaceRank_Snapshot - nRaceRank < 0)
		{
			RaceRankingArrow.ShowWindow();
			RaceRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowDown");
			RaceRankingEqualityText.SetTextColor(GetColor(0, 170, 255, 255));
			RaceRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nRaceRank_Snapshot - nRaceRank)));
		}
		else
		{
			RaceRankingArrow.HideWindow();
			RaceRankingEqualityText.SetTextColor(GetColor(153, 153, 153, 255));
			RaceRankingEqualityText.SetText("-");
		}
	}
	
	if(true)
	{
		if (nClassRank_Snapshot - nClassRank > 0)
		{
			ClassRankingArrow.ShowWindow();
			ClassRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowUp");
			ClassRankingEqualityText.SetTextColor(GetColor(230, 101, 101, 255));
			ClassRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nClassRank_Snapshot - nClassRank)));
		}
		else
		{
			if (nClassRank_Snapshot - nClassRank < 0)
			{
				ClassRankingArrow.ShowWindow();
				ClassRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowDown");
				ClassRankingEqualityText.SetTextColor(GetColor(0, 170, 255, 255));
				ClassRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nClassRank_Snapshot - nClassRank)));
			}
			else
			{
				ClassRankingArrow.HideWindow();
				ClassRankingEqualityText.SetTextColor(GetColor(153, 153, 153, 255));
				ClassRankingEqualityText.SetText("-");
			}
		}
	}
	
	
	if (nServerRank == 0)
	{
		ServerMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));
	}
	else
	{
		ServerMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nServerRank)));
	}
	if (nRaceRank == 0)
	{
		RaceMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));
	}
	else
	{
		RaceMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nRaceRank)));
	}
	
	if (nClassRank == 0)
	{
		ClassMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));
	}
	else
	{
		ClassMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nClassRank)));
	}

	if (getInstanceUIData().getIsClassicServer())
	{
		// End:0x6E2
		if(IsAdenServer() && IsPlayerOnWorldRaidServer())
		{
			RankingRewardICON_Ani.HideWindow();
			RankingRewardICON_Btn.HideWindow();
			Me.KillTimer(TIMEID_NPC_DELAY);
			return;
		}
		// End:0x73F
		if (nServerRank_Snapshot == 1 && npcSpawnTime <= -1)
		{
			RankingRewardMenberCheck_Btn.HideWindow();
			RankingRewardICON_Ani.ShowWindow();
			RankingRewardICON_Btn.ShowWindow();
			Me.KillTimer(TIMEID_NPC_DELAY);
		}
		// End:0x78D
		if (nServerRank_Snapshot != 1)
		{
			RankingRewardICON_Ani.HideWindow();
			RankingRewardICON_Btn.HideWindow();
			Me.KillTimer(TIMEID_NPC_DELAY);
			npcSpawnTime = -1;
			API_C_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION();
		}
	}
	else
	{
		// End:0x7C3
		if (nClassRank == 0)
		{
			ClassMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));
		}
		else
		{
			ClassMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nClassRank)));
		}
	}
}

function bool isSameEventWithCurrentState(int nRankingGroup, int nRankingScope, int nCurrentRankingGroup, int nCurrentRankingScope)
{
	switch (nRankingGroup)
	{
		case RankingGroup.ServerGroup:
		case RankingGroup.RaceGroup:
		case RankingGroup.Friends:
			if ((nRankingGroup == nCurrentRankingGroup) && (nRankingScope == nCurrentRankingScope))
			{
				return True;
			}
			break;
		case RankingGroup.RaceGroup:
		case RankingGroup.Pledge:
			if (nRankingGroup == nCurrentRankingGroup)
			{
				return True;
			}
			break;
	}
	return False;
}

function characterRankingListBeginHandler(string param)
{
	local int nRace;
	local int nRankingGroupTm;
	local int nRankingScopeTm;
	local int nClass;

	ParseInt(param, "Race", nRace);
	ParseInt(param, "RankingGroup", nRankingGroupTm);
	ParseInt(param, "RankingScope", nRankingScopeTm);
	ParseInt(param,"Class",nClass);
	if (isSameEventWithCurrentState(currentRankingGroup, currentRankingScope, nRankingGroupTm, nRankingScopeTm))
	{
		RankingTab_RichList.DeleteAllItem();
		bIAmRanker = false;
		myRankingInList = 0;
		nRankingGroup = nRankingGroupTm;
		nRankingScope = nRankingScopeTm;
	}
}

function characterRankingListEndHandler(string param)
{
	local int nStartRow;

	if (RankingTab_RichList.GetRecordCount() > 0)
	{
		DisableWndList.HideWindow();
		if (bIAmRanker)
		{
			nStartRow = myRankingInList - 3;
			if (nStartRow > 0)
			{
				if (RankingTab_RichList.GetRecordCount() > nStartRow)
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
			case RankingGroup.Pledge:
				List_Empty.SetText(GetSystemString(13023));
				break;
			case RankingGroup.ClassRankingGroup:
				List_Empty.SetText(GetSystemString(13023));
				break;
			case RankingGroup.Friends:
				List_Empty.SetText(GetSystemString(13023));
				break;
			default:
		}
	}
	RankingTab_RichList.SetFocus();
}

function addListByCharacterRankingInfo(string param)
{
	local string UserName;
	local string PledgeName;
	local int nClass;
	local int nRank;
	local int nRace;
	local int nLevel;
	local int nRewardRaceRank;
	local int nRewardServerRank;
	local int nChangeRank;
	local int nRewardClassRank, nWorldID;
	
	local string ServerName;

	ParseString(param, "UserName", UserName);
	ParseString(param, "PledgeName", PledgeName);
	ParseInt(param, "Class", nClass);
	ParseInt(param, "Race", nRace);
	ParseInt(param, "Level", nLevel);
	ParseInt(param, "Rank", nRank);
	ParseInt(param, "RewardRaceRank", nRewardRaceRank);
	ParseInt(param, "RewardServerRank", nRewardServerRank);
	ParseInt(param,"RewardClassRank",nRewardClassRank);
	// End:0x120
	if(IsAdenServer() && IsPlayerOnWorldRaidServer())
	{
		ParseInt(param, "WorldID", nWorldID);
	}
	if(UserName == getWorldNameToLocalName(myInfo.Name))
	{
		bIAmRanker = True;
		myRankingInList = RankingTab_RichList.GetRecordCount();
	}
	uDebug("::--> addListByCharacterRankingInfo:" @ param);
	if (PledgeName == "")
	{
		PledgeName = GetSystemString(431);
	}

	if (nRankingGroup == 1)
	{
		if (nRewardRaceRank == 0)
		{
			nChangeRank = 0;
		}
		else
		{
			nChangeRank = nRewardRaceRank - nRank;
		}
	}
	else if (nRankingGroup == 0)
	{
		if (nRewardServerRank == 0)
		{
			nChangeRank = 0;
		}
		else
		{
			nChangeRank = nRewardServerRank - nRank;
		}
		nChangeRank = nRewardServerRank - nRank;
	}
	else if ( nRankingGroup == 4 )
	{
		if ( nRewardClassRank == 0 )
		{
			nChangeRank = 0;
		}
		else
		{
			nChangeRank = nRewardClassRank - nRank;
		}
		nChangeRank = nRewardClassRank - nRank;
	}
	else
	{
		nChangeRank = 0;
	}
	// End:0x2A1
	if(nWorldID > 0)
	{
		ServerName = "_" $ getServerNameByWorldID(nWorldID);
	}
	AddRankingSystemListItem(nRank, nChangeRank, nRewardServerRank, nRewardRaceRank, nRewardClassRank, UserName, string(nLevel)@"Rb.", nClass, PledgeName, nRace, ServerName);
}

function setMyInfo()
{
	local Texture PledgeCrestTexture;
	local bool bPledgeCrestTexture;
	local int nClass;
	local int nLevel;

	GetPlayerInfo(myInfo);
	if (getInstanceUIData().getIsLiveServer())
	{
		nClass = DetailStatusWndScript.getMainClassID();
		nLevel = DetailStatusWndScript.getMainLevel();
	}
	else
	{
		nClass = myInfo.nSubClass;
		nLevel = myInfo.nLevel;
	}
	levelText.SetText(string(nLevel)@"Rb.");
	ClassText.SetText(GetClassType(nClass));
	if (myInfo.nClanID > 0)
	{
		ClanNameText.SetText(GetClanName(myInfo.nClanID));
	}
	else
	{
		ClanNameText.SetText(GetSystemString(431));
	}
	NameText.SetText(myInfo.Name);
	bPledgeCrestTexture = Class 'UIDATA_CLAN'.static.GetCrestTexture(myInfo.nClanID, PledgeCrestTexture);
	if(getInstanceUIData().getIsLiveServer())
	{
		ClanMarkClassic.HideWindow();
		if (bPledgeCrestTexture)
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
	if (isFirstInit == False)
	{
		isFirstInit = True;
		// End:0x1EE
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

function SetCusomTooltipAtHelpBtn()
{
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(13018), getInstanceL2Util().White, "", True, True);
	if (getInstanceUIData().getIsLiveServer())
	{
		drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(13040), getInstanceL2Util().White, "", True, True);
	}
	drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(13019), getInstanceL2Util().White, "", True, True);
	if (getInstanceUIData().getIsClassicServer())
	{
		drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(13021), getInstanceL2Util().White, "", True, True);
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(" - " $ GetSystemString(13020), getInstanceL2Util().White, "", True, True);
	}
	RankingHelpButton.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function string getSkillTex(int SkillID)
{
	return Class 'UIDATA_SKILL'.static.GetIconName(GetItemID(SkillID), 1, 0);
}

function setDisableWnd()
{
	DisableWnd.ShowWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(True);
	Me.SetTimer(TIMER_ID, REFRESH_DELAY);
}

function hideDisableWnd()
{
	DisableWnd.HideWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(False);
	Me.KillTimer(TIMER_ID);
}

function API_C_EX_RANKING_CHAR_SPAWN_BUFFZONE_NPC()
{
    local array<byte> stream;

	// End:0x17
	if(IsAdenServer() && IsPlayerOnWorldRaidServer())
	{		
	}
	else
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_RANKING_CHAR_SPAWN_BUFFZONE_NPC, stream);
		uDebug("----> Api Call : API_C_EX_RANKING_CHAR_SPAWN_BUFFZONE_NPC");
	}
}

function API_C_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION()
{
    local array<byte> stream;

	// End:0x17
	if(IsAdenServer() && IsPlayerOnWorldRaidServer())
	{		
	}
	else
	{
		class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION, stream);
		uDebug("----> Api Call : API_C_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION");
	}
}

function ParsePacket_S_EX_RANKING_CHAR_BUFFZONE_NPC_INFO()
{
    local UIPacket._S_EX_RANKING_CHAR_BUFFZONE_NPC_INFO packet;

    if (!Class'UIPacket'.static.Decode_S_EX_RANKING_CHAR_BUFFZONE_NPC_INFO(packet))
    {
        return;
    }
    uDebug("??? ?? ?? " @string(packet.nRemainedCooltime));
    npcSpawnTime = packet.nRemainedCooltime;
    Me.KillTimer(TIMEID_NPC_DELAY);
    if (npcSpawnTime > 0)
    {
        Me.SetTimer(TIMEID_NPC_DELAY, 1000);
    }
    refreshNpcSpawnTooltip();
}

function ParsePacket_S_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION()
{
    local UIPacket._S_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION packet;
    local Vector vec;

    if (!Class'UIPacket'.static.Decode_S_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION(packet))
    {
        return;
    }
    vec.X = packet.nPosX;
    vec.Y = packet.nPosY;
    vec.Z = packet.nPosZ;
    if (packet.bIsInWorld > 0)
    {
		RankingRewardMenberCheck_Btn.ShowWindow();
		RankingRewardMenberCheck_Btn.SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(13459), GTColor().Yellow, "HS11", False, GetZoneNameWithLocation(vec), GTColor().White, "", True));
		RankingRewardMenberCheck_Btn.EnableWindow();
    }
    else
    {
        RankingRewardMenberCheck_Btn.ShowWindow();
        RankingRewardMenberCheck_Btn.SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(13459), GTColor().White, "HS11", False, GetSystemString(13472), GTColor().Gray, "", True));
        RankingRewardMenberCheck_Btn.DisableWindow();
    }
    uDebug("npc ?? ??  " @string(packet.bIsInWorld) @GetZoneNameWithLocation(vec));
}

function refreshNpcSpawnTooltip()
{
    if (npcSpawnTime > 0)
    {
        RankingRewardICON_Ani.HideWindow();
        RankingRewardICON_Btn.ShowWindow();
        RankingRewardMenberCheck_Btn.HideWindow();
        RankingRewardICON_Btn.SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(13460), getInstanceL2Util().Yellow, "HS11", False, GetSystemString(1108) $ " : " $ getInstanceL2Util().getTimeStringBySec(npcSpawnTime, True, True), getInstanceL2Util().Yellow, "", True));
        RankingRewardICON_Btn.SetTexture("L2UI_Epic.RankingWnd.RankingBuffIconDisable_n", "L2UI_Epic.RankingWnd.RankingBuffIconDisable_d", "L2UI_Epic.RankingWnd.RankingBuffIconDisable_o");
    }
    else
    {
        RankingRewardICON_Ani.ShowWindow();
        RankingRewardICON_Btn.ShowWindow();
        RankingRewardMenberCheck_Btn.HideWindow();
        RankingRewardICON_Btn.SetTooltipCustomType(MakeTooltipSimpleText(krTooltip()));
        RankingRewardICON_Btn.SetTexture("L2UI_Epic.RankingWnd.RankingBuffIcon_n", "L2UI_Epic.RankingWnd.RankingBuffIcon_d", "L2UI_Epic.RankingWnd.RankingBuffIcon_o");
    }
}

defaultproperties
{
}
