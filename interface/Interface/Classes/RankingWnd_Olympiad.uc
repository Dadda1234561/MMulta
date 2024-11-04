//================================================================================
// RankingWnd_Olympiad.
//================================================================================

class RankingWnd_Olympiad extends UICommonAPI;

enum OlympiadRankingType
{
	ORT_RANKING,
	ORT_CLASSRANKING,
	ORT_CLASSRANKINGBYSERVER
};

enum OlympiadMatchResultType 
{
	OMRT_WIN,
	OMRT_LOSE,
	OMRT_DRAW
};

struct _S_EX_DECO_NPC_SET
{
	var int cResult;
	var int nAgitCID;
	var int cSlot;
	var int nDecoCID;
	var int nExpire;
};

struct ServerOlympiadHeroInfo
{
	var int nWorldID;
	var int nClassRoleType;
	var array<UIPacket._OlympiadHeroInfo> heroInfoArray;
};

var WindowHandle Me;
var WindowHandle DisableWnd;
var TextureHandle RaceMark;
var TextureHandle RankingFlag;
var TextureHandle ClanMark;
var TextureHandle ClanMarkClassic;
var TextureHandle ClanBg;
var TextBoxHandle ClanNameText;
var TextBoxHandle levelText;
var TextBoxHandle ClassText;
var TextBoxHandle NameText;
var TextBoxHandle SesonText;
var ButtonHandle RankingHelpButton;
var TextureHandle OlympiadRankingArrow;
var TextBoxHandle OlympiadRankingEqualityText;
var TextBoxHandle OlympiadMyRankingText;
var TextBoxHandle OlympiadPointText;
var TextBoxHandle OlympiadCountText;
var TextBoxHandle LegendHeroTitleText;
var TextBoxHandle LegendNumText;
var TextBoxHandle LastSesonTitleText;
var TextBoxHandle LastSesonRankingText;
var TextBoxHandle ScoreTitleText;
var TextBoxHandle EnemyName01Text;
var TextBoxHandle EnemyName02Text;
var TextBoxHandle EnemyName03Text;
var TextureHandle EnemyClass01Icon;
var TextureHandle EnemyClass02Icon;
var TextureHandle EnemyClass03Icon;
var ButtonHandle refreshButton;
var TextureHandle RankingTrophy;
var TextureHandle RankingPattern;
var TextureHandle RankingBg1;
var WindowHandle RankingTab01Wnd;
var ButtonHandle Top100Button;
var ButtonHandle MyRankingButton;
var ButtonHandle SeasonToggleButton;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var WindowHandle ServerJobComboboxWnd;
var TextBoxHandle ServerCategoryText;
var ComboBoxHandle ServerCategoryCombobox;
var TextBoxHandle ClassCategoryText;
var ComboBoxHandle ClassCategoryCombobox;
var RichListCtrlHandle RankingTab01_RichList;
var WindowHandle RankingTab02Wnd;
var RichListCtrlHandle RankingTab02_RichList;
var TabHandle TabCtrl2;
var DetailStatusWnd DetailStatusWndScript;
var UserInfo myInfo;
var bool isFirstInit;
var RankingScope currentRankingScope;
var RankingGroup currentRankingGroup;
var OlympiadRankingType currentOlympiadRankingType;
var bool currentPastSeason;
var int currentClassID;
var int currentWorldID;
var int nTotalUser;
var bool bInitComboControl;
var array<ServerOlympiadHeroInfo> eachServerHeroArray;
var array<ServerOlympiadHeroInfo> eachJobTypeHeroArray;

const REFRESH_DELAY = 600;
const TIMER_ID = 1001111;

var string m_WindowName;

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_OLYMPIAD_MY_RANKING_INFO));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_OLYMPIAD_RANKING_INFO));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_OLYMPIAD_HERO_AND_LEGEND_INFO));
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	DetailStatusWndScript = DetailStatusWnd(GetScript("DetailStatusWnd"));
	Me = GetWindowHandle(m_WindowName);
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
	SesonText = GetTextBoxHandle(m_WindowName $ ".SesonText");
	RankingHelpButton = GetButtonHandle(m_WindowName $ ".RankingHelpButton");
	OlympiadRankingArrow = GetTextureHandle(m_WindowName $ ".OlympiadRankingArrow");
	OlympiadRankingEqualityText = GetTextBoxHandle(m_WindowName $ ".OlympiadRankingEqualityText");
	OlympiadMyRankingText = GetTextBoxHandle(m_WindowName $ ".OlympiadMyRankingText");
	OlympiadPointText = GetTextBoxHandle(m_WindowName $ ".OlympiadPointText");
	OlympiadCountText = GetTextBoxHandle(m_WindowName $ ".OlympiadCountText");
	LegendHeroTitleText = GetTextBoxHandle(m_WindowName $ ".LegendHeroTitleText");
	LegendNumText = GetTextBoxHandle(m_WindowName $ ".LegendNumText");
	LastSesonTitleText = GetTextBoxHandle(m_WindowName $ ".LastSesonTitleText");
	LastSesonRankingText = GetTextBoxHandle(m_WindowName $ ".LastSesonRankingText");
	ScoreTitleText = GetTextBoxHandle(m_WindowName $ ".ScoreTitleText");
	EnemyName01Text = GetTextBoxHandle(m_WindowName $ ".EnemyName01Text");
	EnemyName02Text = GetTextBoxHandle(m_WindowName $ ".EnemyName02Text");
	EnemyName03Text = GetTextBoxHandle(m_WindowName $ ".EnemyName03Text");
	EnemyClass01Icon = GetTextureHandle(m_WindowName $ ".EnemyClass01Icon");
	EnemyClass02Icon = GetTextureHandle(m_WindowName $ ".EnemyClass02Icon");
	EnemyClass03Icon = GetTextureHandle(m_WindowName $ ".EnemyClass03Icon");
	refreshButton = GetButtonHandle(m_WindowName $ ".RefreshButton");
	RankingTrophy = GetTextureHandle(m_WindowName $ ".RankingTrophy");
	RankingPattern = GetTextureHandle(m_WindowName $ ".RankingPattern");
	RankingBg1 = GetTextureHandle(m_WindowName $ ".RankingBg1");
	RankingTab01Wnd = GetWindowHandle(m_WindowName $ ".RankingTab01Wnd");
	Top100Button = GetButtonHandle(m_WindowName $ ".RankingTab01Wnd.Top100Button");
	MyRankingButton = GetButtonHandle(m_WindowName $ ".RankingTab01Wnd.MyRankingButton");
	SeasonToggleButton = GetButtonHandle(m_WindowName $ ".RankingTab01Wnd.SeasonToggleButton");
	DisableWndList = GetWindowHandle(m_WindowName $ ".RankingTab01Wnd.DisableWndList");
	List_Empty = GetTextBoxHandle(m_WindowName $ ".RankingTab01Wnd.DisableWndList.List_Empty");
	ServerJobComboboxWnd = GetWindowHandle(m_WindowName $ ".RankingTab01Wnd.ServerJobComboboxWnd");
	ServerCategoryText = GetTextBoxHandle(m_WindowName $ ".RankingTab01Wnd.ServerJobComboboxWnd.ServerCategoryText");
	ServerCategoryCombobox = GetComboBoxHandle(m_WindowName $ ".RankingTab01Wnd.ServerJobComboboxWnd.ServerCategoryCombobox");
	ClassCategoryText = GetTextBoxHandle(m_WindowName $ ".RankingTab01Wnd.ServerJobComboboxWnd.ClassCategoryText");
	ClassCategoryCombobox = GetComboBoxHandle(m_WindowName $ ".RankingTab01Wnd.ServerJobComboboxWnd.ClassCategoryCombobox");
	RankingTab01_RichList = GetRichListCtrlHandle(m_WindowName $ ".RankingTab01Wnd.RankingTab01_RichList");
	RankingTab02Wnd = GetWindowHandle(m_WindowName $ ".RankingTab02Wnd");
	RankingTab02_RichList = GetRichListCtrlHandle(m_WindowName $ ".RankingTab02Wnd.RankingTab02_RichList");
	TabCtrl2 = GetTabHandle(m_WindowName $ ".TabCtrl2");
	RankingTab01_RichList.SetUseStripeBackTexture(false);
	RankingTab02_RichList.SetUseStripeBackTexture(false);
	RankingTab01_RichList.SetSelectedSelTooltip(false);
	RankingTab01_RichList.SetAppearTooltipAtMouseX(true);
	RankingTab01_RichList.SetTooltipType("RankingOlympiad");
	RankingTab02_RichList.SetSelectedSelTooltip(false);
	RankingTab02_RichList.SetAppearTooltipAtMouseX(true);
	RankingTab02_RichList.SetTooltipType("RankingOlympiad");
}

function Load()
{
}

function OnShow()
{
	// End:0x6E
	if(GetWindowHandle("RankingWnd").IsShowWindow())
	{
		GetPlayerInfo(myInfo);
		// End:0x4A
		if(bInitComboControl == false)
		{
			initComboBox_ClassID();
			initComboBox_ServerList();
			bInitComboControl = true;
		}
		RankingTab01_RichList.DeleteAllItem();
		RankingTab02_RichList.DeleteAllItem();
		OnRefreshButtonClick();
	}
}

function OnHide()
{
}

function initUI()
{
	// End:0x19
	if(eachServerHeroArray.Length > 0)
	{
		eachServerHeroArray.Remove(0, eachServerHeroArray.Length);
	}
	// End:0x32
	if(eachJobTypeHeroArray.Length > 0)
	{
		eachJobTypeHeroArray.Remove(0, eachJobTypeHeroArray.Length);
	}
	initUIElements();
	SetCusomTooltipAtHelpBtn();
	DisableWnd.HideWindow();
	Me.KillTimer(TIMER_ID);
	if (getInstanceUIData().getIsClassicServer())
	{
		RankingTab01_RichList.SetColumnString(6, 13150);
		TabCtrl2.SetButtonName(2, GetSystemString(13148));
	}
	else
	{
		RankingTab01_RichList.SetColumnString(6, 13149);
		TabCtrl2.SetButtonName(2, GetSystemString(13147));
	}
	TabCtrl2.SetTopOrder(0, false);
	setTabState("TabCtrl20");
	setLikeRadioButton("Top100Button");
	currentPastSeason = true;
	setToggleSeasonButton();
}

function initUIElements()
{
	OlympiadRankingArrow.HideWindow();
	OlympiadRankingEqualityText.SetText("");
	SesonText.SetText("");
	ClassText.SetText("");
	ClanNameText.SetText("");
	NameText.SetText("");
	LegendNumText.SetText("");
	LastSesonRankingText.SetText("");
	OlympiadPointText.SetText("");
	OlympiadCountText.SetText("");
	OlympiadMyRankingText.SetText("");
	EnemyName01Text.SetText("");
	EnemyName02Text.SetText("");
	EnemyName03Text.SetText("");
	EnemyClass01Icon.HideWindow();
	EnemyClass02Icon.HideWindow();
	EnemyClass03Icon.HideWindow();
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
	Max = Class 'UIDataManager'.static.GetClassTypeMaxCount();
	ClassCategoryCombobox.Clear();

	for (classIndex = 0; classIndex < Max; classIndex++)
	{
		nClassSystemString = Class 'UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(classIndex);
		fullNameString = GetSystemString(nClassSystemString);
		nOriginalClassID = -1;
		if (fullNameString != "")
		{
			if (getInstanceUIData().getIsClassicServer())
			{
				if (GetClassTransferDegree(classIndex) > 2)
				{
					nOriginalClassID = Class 'UIDataManager'.static.GetRootClassID(classIndex);
					if (nOriginalClassID > -1)
					{
						if (IsDeathKnightClass(nOriginalClassID))
						{
							if (classIndex == 199)
							{
								ClassCategoryCombobox.AddStringWithReserved(fullNameString, classIndex);
							}
						}
						else if(IsAssassinClass(nOriginalClassID))
						{
							if(classIndex == 224)
							{
								ClassCategoryCombobox.AddStringWithReserved(fullNameString, classIndex);
							}
						}
						else
						{
							ClassCategoryCombobox.AddStringWithReserved(fullNameString, classIndex);
						}
					}
				}
			}
			else
			{
				// End:0x22A
				if(GetClassTransferDegree(classIndex) > 3)
				{
					nOriginalClassID = class'UIDataManager'.static.GetRootClassID(classIndex);
					// End:0x22A
					if(nOriginalClassID > -1)
					{
						// End:0x22A
						if(classIndex != 216)
						{
							ClassCategoryCombobox.AddStringWithReserved(fullNameString, classIndex);
							// End:0x22A
							if(classIndex == 151)
							{
								// End:0x1C0
								if(nMyClassID == 151)
								{
									selectIndex = ClassCategoryCombobox.GetNumOfItems() - 1;
									bSelect = true;
								}
								nClassSystemString = class'UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(216);
								fullNameString = GetSystemString(nClassSystemString);
								ClassCategoryCombobox.AddStringWithReserved(fullNameString, 216);
								// End:0x22A
								if(nMyClassID == 216)
								{
									selectIndex = ClassCategoryCombobox.GetNumOfItems() - 1;
									bSelect = true;
								}
							}
						}
					}
				}
			}
			// End:0x291
			if(classIndex != 151 && classIndex != 216)
			{
				// End:0x291
				if(nOriginalClassID > -1 && nMyClassID > 0 && nMyClassID == classIndex)
				{
					selectIndex = ClassCategoryCombobox.GetNumOfItems() - 1;
					bSelect = true;
				}
			}
		}
	}
	if (bSelect == false)
	{
		ClassCategoryCombobox.SetSelectedNum(0);
		currentClassID = ClassCategoryCombobox.GetReserved(0);
	}
	else
	{
		ClassCategoryCombobox.SetSelectedNum(selectIndex);
		currentClassID = ClassCategoryCombobox.GetReserved(selectIndex);
	}
}

function initComboBox_ServerList()
{
	local int i;
	local array<ServerInfoUIData> serverListArr;

	Class 'UIDataManager'.static.GetOlympiadGroupServerList(serverListArr);
	ServerCategoryCombobox.Clear();
	ServerCategoryCombobox.AddStringWithReserved(GetSystemString(1046), 0);

	for (i = 0; i < serverListArr.Length; i++)
	{
		uDebug("--------------------------------------------------------------------------");
		uDebug(string(serverListArr[i].ServerID) @ "(ServerID), " @ serverListArr[i].ServerName);
		uDebug("- IsClassicServer " @string(serverListArr[i].IsClassicServer));
		uDebug("- IsAdenServer" @string(serverListArr[i].IsAdenServer));
		uDebug("- IsBroadCastServer" @string(serverListArr[i].IsBroadCastServer));
		uDebug("- IsBloodyServer" @string(serverListArr[i].IsBloodyServer));
		uDebug("- IsTestServer" @string(serverListArr[i].IsTestServer));
		uDebug("- IsWorldRaidServer" @string(serverListArr[i].IsWorldRaidServer));
		if (serverListArr[i].IsWorldRaidServer)
		{
			continue;
		}
		if (serverListArr[i].IsBroadCastServer)
		{
			continue;
		}
		ServerCategoryCombobox.AddStringWithReserved(serverListArr[i].ServerName, serverListArr[i].ServerID);
	}
	if (ServerCategoryCombobox.GetNumOfItems() > 0)
	{
		ServerCategoryCombobox.SetSelectedNum(0);
		currentWorldID = ServerCategoryCombobox.GetReserved(0);
	}
}

function OnTimer(int TimeID)
{
	if (TimeID == TIMER_ID)
	{
		hideDisableWnd();
	}
}

function SetCusomTooltipAtHelpBtn()
{
	RankingHelpButton.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(13142), getInstanceL2Util().White, "", 250));
}

function OnComboBoxItemSelected(string strID, int Index)
{
	// End:0x44
	if(strID == "ClassCategoryCombobox")
	{
		currentClassID = ClassCategoryCombobox.GetReserved(Index);
		OnRefreshButtonClick();
	}
	else
	{
		// End:0x86
		if(strID == "ServerCategoryCombobox")
		{
			currentWorldID = ServerCategoryCombobox.GetReserved(Index);
			OnRefreshButtonClick();
		}
	}
}

function refresh()
{
	API_C_EX_OLYMPIAD_MY_RANKING_INFO();
	if (TabCtrl2.GetTopIndex() == 0)
	{
		currentOlympiadRankingType = ORT_RANKING;
		API_C_EX_OLYMPIAD_RANKING_INFO(currentOlympiadRankingType, currentRankingScope, currentPastSeason, currentClassID, currentWorldID);
	}
	else
	{
		if (TabCtrl2.GetTopIndex() == 1)
		{
			if (ServerCategoryCombobox.GetSelectedNum() == 0)
			{
				currentOlympiadRankingType = ORT_CLASSRANKING;
			}
			else
			{
				currentOlympiadRankingType = ORT_CLASSRANKINGBYSERVER;
			}
			API_C_EX_OLYMPIAD_RANKING_INFO(currentOlympiadRankingType, currentRankingScope, currentPastSeason, currentClassID, currentWorldID);
		}
		else
		{
			API_C_EX_OLYMPIAD_HERO_AND_LEGEND_INFO();
		}
	}
}

function OnClickButton(string Name)
{
	switch (Name)
	{
		case "RankingHelpButton":
			break;
		case "RefreshButton":
			OnRefreshButtonClick();
			break;
		case "Top100Button":
			setLikeRadioButton("Top100Button");
			OnRefreshButtonClick();
			break;
		case "MyRankingButton":
			setLikeRadioButton("MyRankingButton");
			OnRefreshButtonClick();
			break;
		case "SeasonToggleButton":
			OnSeasonToggleButtonClick();
			OnRefreshButtonClick();
			break;
		case "TabCtrl20":
		case "TabCtrl21":
		case "TabCtrl22":
			setTabState(Name);
			OnRefreshButtonClick();
			break;
	}
}

function setTabState(string TabName)
{
	if (TabName == "TabCtrl20")
	{
		Top100Button.SetNameText(GetSystemString(3972));
		RankingTab01Wnd.ShowWindow();
		RankingTab02Wnd.HideWindow();
		ServerCategoryCombobox.HideWindow();
		ClassCategoryCombobox.HideWindow();
		ServerCategoryText.HideWindow();
		ClassCategoryText.HideWindow();
	}
	else
	{
		if (TabName == "TabCtrl21")
		{
			Top100Button.SetNameText(GetSystemString(13156));
			RankingTab01Wnd.ShowWindow();
			RankingTab02Wnd.HideWindow();
			if (currentRankingScope == RankingScope.TopN)
			{
				ServerCategoryText.ShowWindow();
				ClassCategoryText.ShowWindow();
				ServerCategoryCombobox.ShowWindow();
				ClassCategoryCombobox.ShowWindow();
			}
			else
			{
				ServerCategoryText.HideWindow();
				ClassCategoryText.HideWindow();
				ServerCategoryCombobox.HideWindow();
				ClassCategoryCombobox.HideWindow();
			}
		}
		else
		{
			if (TabName == "TabCtrl22")
			{
				RankingTab01Wnd.HideWindow();
				RankingTab02Wnd.ShowWindow();
			}
		}
	}
}

function OnRefreshButtonClick()
{
	RankingTab01_RichList.DeleteAllItem();
	RankingTab02_RichList.DeleteAllItem();
	setDisableWnd();
	Refresh();
}

function OnSeasonToggleButtonClick()
{
	uDebug("OnSeasonToggleButtonClick" @string(currentPastSeason));
	currentPastSeason = !currentPastSeason;
	setToggleSeasonButton();
}

function OnEvent(int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_GameStart:
			bInitComboControl = False;
			initUI();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_OLYMPIAD_MY_RANKING_INFO):
			ParsePacket_OLYMPIAD_MY_RANKING_INFO();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_OLYMPIAD_RANKING_INFO):
			ParsePacket_OLYMPIAD_RANKING_INFO();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_OLYMPIAD_HERO_AND_LEGEND_INFO):
			ParsePacket_OLYMPIAD_HERO_AND_LEGEND_INFO();
			break;
		case EV_Restart:
			initUI();
			break;
		default:
	}
}

function AddRankingSystemListItem(UIPacket._OlympiadRankInfo rankInfo)
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
	local int nChangeRankStrAddX;
	local int nChangeRank;
	local string levelStr;
	local string percentStr;
	local string changeRankStr;
	local string ClassName;
	local ServerInfoUIData ServerInfo;
	local bool bUseRankingTexture;

	rowData.cellDataList.Length = 7;
	rowData.nReserved2 = rankInfo.nLevel;
	if ((rankInfo.nRank <= 3) && (rankInfo.nRank > 0))
	{
		if (rankInfo.nRank == 1)
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_1st";
		}
		else
		{
			if (rankInfo.nRank == 2)
			{
				texStr = "L2UI_ct1.RankingWnd.RankingWnd_2nd";
			}
			else
			{
				if (rankInfo.nRank == 3)
				{
					texStr = "L2UI_ct1.RankingWnd.RankingWnd_3rd";
				}
			}
		}
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, texStr, 38, 33, 5, 5);
		bUseRankingTexture = True;
		nAddX = 10;
		nAddY = 6;
		nChangeRankStrAddX = 6;
	}
	else
	{
		GetTextSizeDefault(string(rankInfo.nRank), tW, tH);
		addRichListCtrlString(rowData.cellDataList[0].drawitems, string(rankInfo.nRank), getInstanceL2Util().White, False, 23 - tW / 2, 12);
		nAddX = 14;
		nAddY = -4;
		nChangeRankStrAddX = 2;
	}
	rowData.cellDataList[0].szData = string(rankInfo.nRank);
	rowData.cellDataList[2].szData = rankInfo.sCharName;
	rowData.cellDataList[3].szData = rankInfo.sPledgeName;
	if (rankInfo.nPrevRank == 0)
	{
		nChangeRank = 0;
	}
	else
	{
		nChangeRank = rankInfo.nPrevRank - rankInfo.nRank;
	}
	if ((currentRankingScope == RankingScope.AroundMe) && (rankInfo.nPrevRank == 0))
	{
		nChangeRank = 0;
	}
	if ((currentOlympiadRankingType == ORT_RANKING) && (currentRankingScope != RankingScope.AroundMe) && (rankInfo.nPrevRank > 100) && (rankInfo.nRank <= 100) || (currentOlympiadRankingType != ORT_RANKING) && (currentRankingScope != RankingScope.AroundMe) && (rankInfo.nPrevRank > 50) && (rankInfo.nRank <= 50))
	{
		changeRankStr = "NEW";
		addRichListCtrlString(rowData.cellDataList[0].drawitems, changeRankStr, GetColor(0, 255, 0, 255), False, nAddX + nChangeRankStrAddX, nAddY - 4);
		nChangeRankStrAddX = 0;
		nChangeRankStrAddX = nChangeRankStrAddX + 8;
	}
	else
	{
		if (nChangeRank > 0)
		{
			changeRankStr = string(nChangeRank);
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowUp", 8, 8, nAddX, nAddY);
			addRichListCtrlString(rowData.cellDataList[0].drawitems, changeRankStr, GetColor(230, 101, 101, 255), False, 2, -4);
			nAddX = nAddX + 5;
		}
		else
		{
			if (nChangeRank == 0)
			{
				changeRankStr = "-";
				addRichListCtrlString(rowData.cellDataList[0].drawitems, changeRankStr, GetColor(153, 153, 153, 255), False, nAddX + nChangeRankStrAddX, nAddY - 4);
				nChangeRankStrAddX = 0;
				nChangeRankStrAddX = nChangeRankStrAddX + 8;
			}
			else
			{
				changeRankStr = string(nChangeRank);
				addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowDown", 8, 8, nAddX, nAddY);
				addRichListCtrlString(rowData.cellDataList[0].drawitems, changeRankStr, GetColor(0, 170, 255, 255), False, 2, -4);
				nAddX = nAddX + 5;
			}
		}
	}
	GetTextSizeDefault(changeRankStr, tW, tH);
	percentStr = stringPer(rankInfo.nRank, nTotalUser) $ "%";
	if (bUseRankingTexture)
	{
		addRichListCtrlString(rowData.cellDataList[0].drawitems, "(" $ percentStr $ ")", GetColor(170, 153, 119, 255), False, -tW - nAddX, 14);
	}
	else
	{
		addRichListCtrlString(rowData.cellDataList[0].drawitems, "(" $ percentStr $ ")", GetColor(170, 153, 119, 255), False, -tW - 14 + nChangeRankStrAddX, 18);
	}
	if (Class 'UIDataManager'.static.GetServerInfo(rankInfo.nWorldID, ServerInfo))
	{
		rowData.cellDataList[1].szData = ServerInfo.ServerName;
		addRichListCtrlString(rowData.cellDataList[1].drawitems, ServerInfo.ServerName, GetColor(170, 153, 119, 255), False, 0, 0);
	}
	levelStr = "(Lv." $ string(rankInfo.nLevel) $ ")";
	GetTextSizeDefault(rankInfo.sCharName @ levelStr, nW, nH);
	applyColor = GetColor(182, 182, 182, 255);
	if (nW > 208)
	{
		GetTextSizeDefault(levelStr, tW, tH);
		tmStr = makeShortStringByPixel(rankInfo.sCharName $ " ", 208 - tW, "..");
		addRichListCtrlString(rowData.cellDataList[2].drawitems, tmStr @ levelStr, applyColor, false, 4, -4);
		GetTextSizeDefault(tmStr @levelStr, nW, nH);
	}
	else
	{
		addRichListCtrlString(rowData.cellDataList[2].drawitems, rankInfo.sCharName @ levelStr, applyColor, False, 4, -4);
	}
	ClassName = GetClassType(rankInfo.nClassID);
	rowData.szReserved = ClassName;
	addRichListCtrlString(rowData.cellDataList[2].drawitems, ClassName, applyColor, False, -nW, 15);
	if (rankInfo.sPledgeName == "")
	{
		addRichListCtrlString(rowData.cellDataList[3].drawitems, GetSystemString(431), applyColor, False, 5, 0);
	}
	else
	{
		addRichListCtrlString(rowData.cellDataList[3].drawitems, rankInfo.sPledgeName, applyColor, False, 5, 0);
		GetTextSizeDefault(rankInfo.sPledgeName, nW, nH);
		addRichListCtrlString(rowData.cellDataList[3].drawitems, "(Lv." $ string(rankInfo.nPledgeLevel) $ ")", applyColor, False, -nW, 15);
	}
	addRichListCtrlString(rowData.cellDataList[4].drawitems, string(rankInfo.nWinCount) $ "/" $ string(rankInfo.nLoseCount), applyColor, False, 5, 0);
	rowData.cellDataList[4].szData = string(rankInfo.nWinCount) $ "/" $ string(rankInfo.nLoseCount);
	addRichListCtrlString(rowData.cellDataList[5].drawitems, MakeCostString(string(rankInfo.nOlympiadPoint)), applyColor, False, 5, 0);
	if (getInstanceUIData().getIsClassicServer())
	{
		addRichListCtrlString(rowData.cellDataList[6].drawitems, string(rankInfo.nHeroCount), applyColor, False, 5, 0);
	}
	else
	{
		addRichListCtrlString(rowData.cellDataList[6].drawitems, string(rankInfo.nLegendCount) $ "/" $ string(rankInfo.nHeroCount), applyColor, False, 20, 0);
	}
	if ( myInfo.Name == rankInfo.sCharName && myInfo.nWorldID == rankInfo.nWorldID )
	{
		rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";
	}
	else
	{
		rowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
	}
	rowData.OverlayTexU = 734;
	rowData.OverlayTexV = 45;
	rowData.nReserved1 = 1003;
	RankingTab01_RichList.InsertRecord(rowData);
}

function addList_LegendTitle()
{
	local RichListCtrlRowData rowData;
	local string texStr;

	rowData.cellDataList.Length = 2;
	rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_LegendHeroHeaderBg";
	texStr = GetSystemString(13152);
	addRichListCtrlString(rowData.cellDataList[0].drawitems, texStr, GetColor(255, 221, 102, 255), False, 15, 0, "hs14");
	addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_ch3.LoginWnd.aboutotpicon", 15, 15, 10, 0);
	addRichListCtrlString(rowData.cellDataList[1].drawitems, GetSystemString(13153), GetColor(254, 215, 160, 255), False, 8, 1);
	rowData.nReserved1 = 1001;
	rowData.szReserved = GetSystemString(13154);
	rowData.OverlayTexU = 734;
	rowData.OverlayTexV = 45;
	RankingTab02_RichList.InsertRecord(rowData);
}

function addList_HeroCountTitle()
{
	local RichListCtrlRowData rowData;
	local ServerInfoUIData ServerInfo;
	local string texStr;
	local string serverStr;
	local int i;
	local int textStrSizeX;
	local int nH;

	rowData.cellDataList.Length = 2;
	rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_LegendHeroHeaderBg";
	addRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(13144), GetColor(255, 221, 102, 255), False, 15, 0, "hs14");
	addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_ch3.LoginWnd.aboutotpicon", 15, 15, 10, 0);
	addRichListCtrlString(rowData.cellDataList[1].drawitems, GetSystemString(13163), GetColor(170, 153, 119, 255), False, 8, 1);
	rowData.OverlayTexU = 734;
	rowData.OverlayTexV = 70;
	GetTextSizeDefault(texStr, textStrSizeX, nH);

	for (i = 0; i < eachServerHeroArray.Length; i++)
	{
		if (Class 'UIDataManager'.static.GetServerInfo(eachServerHeroArray[i].nWorldID, ServerInfo))
		{
			serverStr = serverStr $ ServerInfo.ServerName @string(eachServerHeroArray[i].heroInfoArray.Length) $ GetSystemString(1013);
			if (i + 1 < eachServerHeroArray.Length)
			{
				serverStr = serverStr $ ", ";
			}
		}
	}
	rowData.nReserved1 = 1000;
	rowData.szReserved = serverStr;
	RankingTab02_RichList.InsertRecord(rowData);
}

function addListBG_ClassRole(int nClassRoleType)
{
	local RichListCtrlRowData rowData;
	local string texStr;

	rowData.cellDataList.Length = 1;
	rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_ClassHeaderBg";
	texStr = GetClassRoleNameByRole(nClassRoleType);
	addRichListCtrlString(rowData.cellDataList[0].drawitems, texStr, GetColor(170, 153, 119, 255), False, 15, 0, "hs11");
	rowData.OverlayTexU = 734;
	rowData.OverlayTexV = 70;
	RankingTab02_RichList.InsertRecord(rowData);
}

function AddLegendHeroListItem(UIPacket._OlympiadHeroInfo heroInfo, optional bool bLegend)
{
	local RichListCtrlRowData rowData;
	local ServerInfoUIData ServerInfo;
	local string heroPhotoTexture;
	local string texStr;
	local string tmStr;
	local string levelStr;
	local Color applyColor;
	local int nW, nH, tW, tH;

	rowData.cellDataList.Length = 6;
	heroPhotoTexture = getSD_CharacterTexture(heroInfo.nRace, heroInfo.nClassID, heroInfo.nSex);
	uDebug("AddLegendHeroListItem : " @string(heroInfo.nRace) @string(heroInfo.nClassID) @string(heroInfo.nSex));
	uDebug("heroInfo.sCharName  : " @heroInfo.sCharName);
	uDebug("����,���� SD �ؽ��� : " @heroPhotoTexture);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, heroPhotoTexture, 58, 58, 5, 14);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_ct1.RankingWnd.RankingWnd_LegendHeroStar", 28, 28, 6, 15);
	texStr = string(heroInfo.nCount) $ GetSystemString(3295);
	addRichListCtrlString(rowData.cellDataList[0].drawitems, texStr, getInstanceL2Util().Yellow, False, 0, 6, "gameDefault10");
	levelStr = "(Lv." $ string(heroInfo.nLevel) $ ")";
	GetTextSizeDefault(heroInfo.sCharName @ levelStr, nW, nH);
	if (bLegend)
	{
		applyColor = GetColor(254, 215, 160, 255);
		rowData.cellDataList[0].szData = GetSystemString(13152) $ " : " $ heroInfo.sCharName;
	}
	else
	{
		applyColor = getInstanceL2Util().BWhite;
		rowData.cellDataList[0].szData = GetSystemString(13144) $ " : " $ heroInfo.sCharName;
	}
	if (nW > 200)
	{
		GetTextSizeDefault(levelStr, tW, tH);
		tmStr = makeShortStringByPixel(heroInfo.sCharName, 180 - tW, "..");
		addRichListCtrlString(rowData.cellDataList[1].drawitems, tmStr @ levelStr, applyColor, false, 4, -4);
		GetTextSizeDefault(tmStr @levelStr, nW, nH);
	}
	else
	{
		addRichListCtrlString(rowData.cellDataList[1].drawitems, heroInfo.sCharName @ levelStr, applyColor, False, 4, -4);
		GetTextSizeDefault(heroInfo.sCharName @ levelStr, nW, nH);
	}
	applyColor = GetColor(182, 182, 182, 255);
	texStr = GetClassType(heroInfo.nClassID);
	uDebug("���� Ŭ���� Ÿ�� " @string(heroInfo.nClassID) @texStr);
	addRichListCtrlString(rowData.cellDataList[1].drawitems, makeShortStringByPixel(texStr, 200, ".."), applyColor, False, -nW, 15);
	rowData.cellDataList[1].szData = texStr;
	if (Class 'UIDataManager'.static.GetServerInfo(heroInfo.nWorldID, ServerInfo))
	{
		if (ServerInfo.ServerID == GetServerNo())
		{
			rowData.cellDataList[2].szData = ServerInfo.ServerName;
			addRichListCtrlString(rowData.cellDataList[2].drawitems, makeShortStringByPixel(ServerInfo.ServerName, 72, ".."), GetColor(170, 153, 119, 255), False, 0, -4);
			GetTextSizeDefault(makeShortStringByPixel(ServerInfo.ServerName, 72, ".."), tW, tH);
			addRichListCtrlString(rowData.cellDataList[2].drawitems, "(" $ GetSystemString(13155) $ ")", GetColor(136, 255, 255, 255), False, -tW, 15);
		}
		else
		{
			rowData.cellDataList[2].szData = ServerInfo.ServerName;
			addRichListCtrlString(rowData.cellDataList[2].drawitems, makeShortStringByPixel(ServerInfo.ServerName, 72, ".."), GetColor(170, 153, 119, 255), False, 0, 0);
		}
	}
	if (heroInfo.sPledgeName == "")
	{
		addRichListCtrlString(rowData.cellDataList[3].drawitems, GetSystemString(431), applyColor, False, 5, 0);
	}
	else
	{
		if (bLegend)
		{
			applyColor = GetColor(254, 215, 160, 255);
		}
		else
		{
			applyColor = GetColor(182, 182, 182, 255);
		}
		addRichListCtrlString(rowData.cellDataList[3].drawitems, makeShortStringByPixel(heroInfo.sPledgeName, 122, ".."), applyColor, False, 5, -4);
		GetTextSizeDefault(heroInfo.sPledgeName, nW, nH);
		addRichListCtrlString(rowData.cellDataList[3].drawitems, "(Lv." $ string(heroInfo.nPledgeLevel) $ ")", applyColor, False, -nW, 15);
	}
	rowData.cellDataList[3].szData = heroInfo.sPledgeName;
	applyColor = GetColor(182, 182, 182, 255);
	addRichListCtrlString(rowData.cellDataList[4].drawitems, string(heroInfo.nWinCount) $ GetSystemString(3844) $ "/" $ string(heroInfo.nLoseCount) $ GetSystemString(3859), applyColor, False, 0, 0);
	rowData.cellDataList[4].szData = string(heroInfo.nWinCount) $ "/" $ string(heroInfo.nLoseCount);
	addRichListCtrlString(rowData.cellDataList[5].drawitems, MakeCostString(string(heroInfo.nOlympiadPoint)) $ GetSystemString(1442), applyColor, False, 20, 0);
	rowData.nReserved1 = 1002;
	RankingTab02_RichList.InsertRecord(rowData);
}

function addEachJobTypeHeroArray(out array<ServerOlympiadHeroInfo> heroInfoArray, UIPacket._OlympiadHeroInfo heroInfo)
{
	local int i;
	local int nRoleType;
	local ServerOlympiadHeroInfo newServerOlympiadHeroInfo;

	for (i = 0; i < heroInfoArray.Length; i++)
	{
		nRoleType = GetClassRoleType(heroInfo.nClassID);
		if (heroInfoArray[i].nClassRoleType == nRoleType)
		{
			heroInfoArray[i].heroInfoArray[heroInfoArray[i].heroInfoArray.Length] = heroInfo;
			return;
		}
	}
	nRoleType = GetClassRoleType(heroInfo.nClassID);
	newServerOlympiadHeroInfo.nClassRoleType = nRoleType;
	newServerOlympiadHeroInfo.heroInfoArray[newServerOlympiadHeroInfo.heroInfoArray.Length] = heroInfo;
	heroInfoArray[heroInfoArray.Length] = newServerOlympiadHeroInfo;
}

function addEachServerHeroCountArray(out array<ServerOlympiadHeroInfo> heroInfoArray, UIPacket._OlympiadHeroInfo heroInfo)
{
	local int i;
	local ServerOlympiadHeroInfo newServerOlympiadHeroInfo;

	for (i = 0; i < heroInfoArray.Length; i++)
	{
		if (heroInfoArray[i].nWorldID == heroInfo.nWorldID)
		{
			heroInfoArray[i].heroInfoArray[heroInfoArray[i].heroInfoArray.Length] = heroInfo;
			return;
		}
	}
	newServerOlympiadHeroInfo.nWorldID = heroInfo.nWorldID;
	newServerOlympiadHeroInfo.heroInfoArray[newServerOlympiadHeroInfo.heroInfoArray.Length] = heroInfo;
	heroInfoArray[heroInfoArray.Length] = newServerOlympiadHeroInfo;
}

function ParsePacket_OLYMPIAD_HERO_AND_LEGEND_INFO()
{
	local UIPacket._S_EX_OLYMPIAD_HERO_AND_LEGEND_INFO packet;
	local int i;
	local int N;

	if (!Class 'UIPacket'.static.Decode_S_EX_OLYMPIAD_HERO_AND_LEGEND_INFO(packet))
	{
		return;
	}
	if (packet.legendInfo.sCharName != "")
	{
		addList_LegendTitle();
		AddLegendHeroListItem(packet.legendInfo, True);
	}
	eachServerHeroArray.Remove(0, eachServerHeroArray.Length);
	eachJobTypeHeroArray.Remove(0, eachJobTypeHeroArray.Length);

	for (i = 0; i < packet.heroInfoList.Length; i++)
	{
		addEachServerHeroCountArray(eachServerHeroArray, packet.heroInfoList[i]);
		addEachJobTypeHeroArray(eachJobTypeHeroArray, packet.heroInfoList[i]);
	}
	if (packet.heroInfoList.Length > 0)
	{
		addList_HeroCountTitle();
	}

	for (i = 0; i < eachJobTypeHeroArray.Length; i++)
	{
		if (eachJobTypeHeroArray[i].heroInfoArray.Length > 0)
		{
			addListBG_ClassRole(eachJobTypeHeroArray[i].nClassRoleType);
		}

		for (N = 0; N < eachJobTypeHeroArray[i].heroInfoArray.Length; N++)
		{
			AddLegendHeroListItem(eachJobTypeHeroArray[i].heroInfoArray[N]);
		}
	}
	if (RankingTab02_RichList.GetRecordCount() > 0)
	{
		RankingTab02_RichList.SetFocus();
	}
}

function string getSD_CharacterTexture(int nRace, int nClassID, int nSex)
{
	local string sexStr;

	// End:0x17
	if(nSex > 0)
	{
		sexStr = "W";
	}
	else
	{
		sexStr = "M";
	}
	// End:0x35
	if(nRace == 6)
	{
		sexStr = "W";
	}
	// End:0x5B
	if(IsDeathKnightClass(class'UIDataManager'.static.GetRootClassID(nClassID)))
	{
		sexStr = "M";
	}
	// End:0x81
	if(IsDeathFighterClass(class'UIDataManager'.static.GetRootClassID(nClassID)))
	{
		sexStr = "M";
	}
	return "L2UI_CT1.RankingWnd.RankingWnd_FaceIcon_" $ getRaceString(nRace) $ "_" $ getInstanceL2Util().getPlayerType(nClassID, nRace) $ "_" $ sexStr;
}

function ParsePacket_OLYMPIAD_RANKING_INFO()
{
	local UIPacket._S_EX_OLYMPIAD_RANKING_INFO packet;
	local int i;
	local int nStartRow;
	local int nMyRanking;
	local bool bIAmRanker;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_OLYMPIAD_RANKING_INFO(packet))
	{
		return;
	}
	GetPlayerInfo(myInfo);
	nTotalUser = packet.nTotalUser;

	for (i = 0; i < packet.rankInfoList.Length; i++)
	{
		AddRankingSystemListItem(packet.rankInfoList[i]);
		// End:0xAF
		if(packet.rankInfoList[i].sCharName == myInfo.Name && myInfo.nWorldID == packet.rankInfoList[i].nWorldID)
		{
			bIAmRanker = true;
			nMyRanking = packet.rankInfoList[i].nRank;
		}
	}
	if (packet.rankInfoList.Length <= 0)
	{
		DisableWndList.ShowWindow();
	}
	else
	{
		DisableWndList.HideWindow();
		if (bIAmRanker)
		{
			nStartRow = nMyRanking - 3;
			if (nStartRow > 0)
			{
				if (RankingTab01_RichList.GetRecordCount() > nStartRow)
				{
					RankingTab01_RichList.SetStartRow(nStartRow);
				}
			}
		}
	}
	RankingTab01_RichList.SetFocus();
}

function ParsePacket_OLYMPIAD_MY_RANKING_INFO()
{
	local UIPacket._S_EX_OLYMPIAD_MY_RANKING_INFO packet;
	local Texture PledgeCrestTexture;
	local bool bPledgeCrestTexture;
	local int nClass;
	local int nLevel;
	local int i;
	local int nChangeRank;

	if (!Class 'UIPacket'.static.Decode_S_EX_OLYMPIAD_MY_RANKING_INFO(packet))
	{
		return;
	}
	uDebug(" -->  Decode_S_EX_OLYMPIAD_MY_RANKING_INFO :  " @string(packet.nRank) @string(packet.nWinCount) @string(packet.nLoseCount));
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
	levelText.SetText("Lv." $ string(nLevel));
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
		// End:0x198
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
		// End:0x1E8
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
	}
	if (packet.nPrevRank == 0)
	{
		nChangeRank = 0;
	}
	else
	{
		nChangeRank = packet.nPrevRank - packet.nRank;
	}
	if (getInstanceUIData().getIsClassicServer())
	{
		SesonText.SetText(string(packet.nSeason) $ GetSystemString(934));
	}
	else
	{
		SesonText.SetText(string(packet.nSeasonYear) $ GetSystemString(3847) @string(packet.nSeasonMonth) $ GetSystemString(3848));
	}
	if (nChangeRank > 0)
	{
		OlympiadRankingArrow.ShowWindow();
		OlympiadRankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowUp");
		OlympiadRankingEqualityText.SetText(string(nChangeRank));
	}
	else
	{
		if (nChangeRank < 0)
		{
			OlympiadRankingArrow.ShowWindow();
			OlympiadRankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowDown");
			OlympiadRankingEqualityText.SetText(string(nChangeRank));
		}
		else
		{
			OlympiadRankingEqualityText.SetText("-");
			OlympiadRankingArrow.HideWindow();
		}
	}
	OlympiadMyRankingText.SetText(string(packet.nRank) $ GetSystemString(1375));
	OlympiadPointText.SetText(MakeCostString(string(packet.nOlympiadPoint)) $ GetSystemString(1442));
	OlympiadCountText.SetText(string(packet.nWinCount) $ GetSystemString(3844) @ "/ " @ string(packet.nLoseCount) $ GetSystemString(3854));
	LegendNumText.SetText(string(packet.nLegendCount) $ GetSystemString(3295) @ "/ " $ string(packet.nHeroCount) $ GetSystemString(3295));
	LastSesonRankingText.SetText(MakeCostString(string(packet.nPrevOlympiadPoint)) $ GetSystemString(1442) $ " " $ string(packet.nPrevRank) $ GetSystemString(1375) $ ",  " $ string(packet.nPrevWinCount) $ GetSystemString(3844) @ "/" @ string(packet.nPrevLoseCount) $ GetSystemString(3854));
 	EnemyName01Text.SetText("");
	EnemyName02Text.SetText("");
	EnemyName03Text.SetText("");
	EnemyClass01Icon.HideWindow();
	EnemyClass02Icon.HideWindow();
	EnemyClass03Icon.HideWindow();

	for (i = 0; i < 3; i++)
	{
		if (packet.recentMatches.Length <= 0)
		{
			GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").SetTextColor(getInstanceL2Util().Gray);
			GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").SetText(GetSystemString(1454));
			GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").ClearTooltip();
		}
		else
		{
			if ((packet.recentMatches.Length > i) && (packet.recentMatches[i].sCharName != ""))
			{
				GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").SetTooltipType("Text");
				if (packet.recentMatches[i].cResult == 0)
				{
					GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").SetTextColor(GetColor(230,101,101,255));
					GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").SetTooltipText(GetSystemString(3844));
				}
				else
				{
					if (packet.recentMatches[i].cResult == 1)
					{
						GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").SetTextColor(GetColor(0,170,255,255));
						GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").SetTooltipText(GetSystemString(3854));
					}
					else
					{
						GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").SetTextColor(GetColor(182,182,182,255));
						GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").SetTooltipText(GetSystemString(13146));
					}
				}
				GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").SetText("Lv." $ string(packet.recentMatches[i].nLevel) @ packet.recentMatches[i].sCharName);
				GetTextureHandle(m_WindowName $ ".EnemyClass0" $ string(i + 1) $ "Icon").ShowWindow();
				GetTextureHandle(m_WindowName $ ".EnemyClass0" $ string(i + 1) $ "Icon").SetTexture("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(packet.recentMatches[i].nClassID) $ "_Small");
				GetTextureHandle(m_WindowName $ ".EnemyClass0" $ string(i + 1) $ "Icon").SetTooltipType("Text");
				GetTextureHandle(m_WindowName $ ".EnemyClass0" $ string(i + 1) $ "Icon").SetTooltipText(GetClassType(packet.recentMatches[i].nClassID));
			}
			else
			{
				GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").SetTextColor(getInstanceL2Util().Gray);
				GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").SetText(GetSystemString(1454));
				GetTextBoxHandle(m_WindowName $ ".EnemyName0" $ string(i + 1) $ "Text").ClearTooltip();
			}
		}
	}
}

function setLikeRadioButton(string buttonName)
{
	if (buttonName == "Top100Button")
	{
		Top100Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = RankingScope.TopN;
		if (TabCtrl2.GetTopIndex() == 1)
		{
			ServerCategoryText.ShowWindow();
			ClassCategoryText.ShowWindow();
			ServerCategoryCombobox.ShowWindow();
			ClassCategoryCombobox.ShowWindow();
		}
	}
	else
	{
		if (buttonName == "MyRankingButton")
		{
			MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
			Top100Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
			currentRankingScope = RankingScope.AroundMe;
			if (TabCtrl2.GetTopIndex() == 1)
			{
				ServerCategoryText.HideWindow();
				ClassCategoryText.HideWindow();
				ServerCategoryCombobox.HideWindow();
				ClassCategoryCombobox.HideWindow();
			}
		}
	}
}

function setToggleSeasonButton()
{
	if (currentPastSeason)
	{
		SeasonToggleButton.SetTexture("L2UI_ct1.Button.Button_DF", "L2UI_ct1.Button.Button_DF_Click", "L2UI_ct1.Button.Button_DF_Over");
		SeasonToggleButton.SetButtonName(3707);
	}
	else
	{
		SeasonToggleButton.SetTexture("L2UI_ct1.Button.Button_DF", "L2UI_ct1.Button.Button_DF_Click", "L2UI_ct1.Button.Button_DF_Over");
		SeasonToggleButton.SetButtonName(3706);
	}
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

function API_C_EX_OLYMPIAD_RANKING_INFO(OlympiadRankingType cRankingType, RankingScope cRankingScope, bool bCurrentSeason, int nClassID, int nWorldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_OLYMPIAD_RANKING_INFO packet;

	packet.cRankingType = cRankingType;
	packet.cRankingScope = cRankingScope;
	packet.bCurrentSeason = byte(bCurrentSeason);
	if ((cRankingType == OlympiadRankingType.ORT_RANKING || (cRankingType == OlympiadRankingType.ORT_CLASSRANKING)) && (cRankingScope == RankingScope.AroundMe))
	{
		packet.nWorldID = GetServerNo();
		packet.nClassID = myClassID();
	}
	else
	{
		packet.nClassID = nClassID;
		packet.nWorldID = nWorldID;
	}
	if (!Class 'UIPacket'.static.Encode_C_EX_OLYMPIAD_RANKING_INFO(stream, packet))
	{
		return;
	}
	Class 'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_OLYMPIAD_RANKING_INFO, stream);
	uDebug("----> Api Call : C_EX_OLYMPIAD_RANKING_INFO" @string(cRankingType) @string(cRankingScope) @string(bCurrentSeason) @string(nClassID) @string(nWorldID));
}

function API_C_EX_OLYMPIAD_MY_RANKING_INFO()
{
	local array<byte> stream;

	Class 'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_OLYMPIAD_MY_RANKING_INFO, stream);
	uDebug("----> Api Call : C_EX_OLYMPIAD_MY_RANKING_INFO");
}

function API_C_EX_OLYMPIAD_HERO_AND_LEGEND_INFO()
{
	local array<byte> stream;

	Class 'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_OLYMPIAD_HERO_AND_LEGEND_INFO, stream);
	uDebug("----> Api Call : C_EX_OLYMPIAD_HERO_AND_LEGEND_INFO");
}

defaultproperties
{
}
