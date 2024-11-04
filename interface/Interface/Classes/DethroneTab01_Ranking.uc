class DethroneTab01_Ranking extends UICommonAPI;

const TIMER_ID = 1001112;
const REFRESH_DELAY = 600;

var string m_WindowName;
var WindowHandle Me;
var ButtonHandle Top150Button;
var ButtonHandle MyRankingButton;
var ButtonHandle prvResultButton;
var TextureHandle ServerRichListFrame;
var RichListCtrlHandle Tab_RichList;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var RankingScope currentRankingScope;
var bool bCurrentSeason;
var bool bIAmRanker;
var int myRankingInList;
var UserInfo myInfo;

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_RANKING_INFO);
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	Top150Button = GetButtonHandle(m_WindowName $ ".Top150Button");
	MyRankingButton = GetButtonHandle(m_WindowName $ ".MyRankingButton");
	prvResultButton = GetButtonHandle(m_WindowName $ ".prvResultButton");
	ServerRichListFrame = GetTextureHandle(m_WindowName $ ".ServerRichListFrame");
	Tab_RichList = GetRichListCtrlHandle(m_WindowName $ ".Tab_RichList");
	DisableWndList = GetWindowHandle(m_WindowName $ ".DisableWndList");
	List_Empty = GetTextBoxHandle(m_WindowName $ ".DisableWndList.List_Empty");
}

function Load()
{
	bCurrentSeason = false;
}

function OnShow()
{
	Debug("-Onshow " @ string(GetWindowHandle("DethroneWnd").IsShowWindow()));
	// End:0x57
	if(GetWindowHandle("DethroneWnd").IsShowWindow())
	{
		ShowProcess();
	}
}

function ShowProcess()
{
	GetPlayerInfo(myInfo);
	OnRefreshButtonClick();
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x2C
		case "Top150Button":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			// End:0x89
			break;
		// End:0x54
		case "MyRankingButton":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			// End:0x89
			break;
		// End:0x86
		case "prvResultButton":
			bCurrentSeason = ! bCurrentSeason;
			setToggleSeasonButton();
			OnRefreshButtonClick();
			// End:0x89
			break;
	}
}

function OnRefreshButtonClick()
{
	API_C_EX_DETHRONE_RANKING_INFO();
	DethroneWnd(GetScript("DethroneWnd")).setDisableWnd();
}

function setLikeRadioButton(string buttonName)
{
	// End:0x126
	if(buttonName == "Top150Button")
	{
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = TopN;
	}
	else if(buttonName == "MyRankingButton")
	{
		MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = AroundMe;
	}
}

function string sliceName(string nameStr)
{
	local array<string> ArrayStr;

	Split(nameStr, "_", ArrayStr);
	return ArrayStr[0];
}

function AddRankingSystemListItem(int nRanking, int nTotalUser, int nServerID, string PlayerName, string severName, INT64 dethronePoint)
{
	local RichListCtrlRowData RowData;
	local Color applyColor;
	local bool bMe;
	local string percentStr, rankStr;
	local int tW, tH, mW, mH;

	RowData.cellDataList.Length = 4;
	Debug("myInfo.Name" @ myInfo.Name);
	applyColor = GTColor().White;
	// End:0xE9
	if(isMyServer(nServerID) && PlayerName == sliceName(DethroneWnd(GetScript("DethroneWnd")).PCName_text.GetText()))
	{
		bMe = true;
		RowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";
		bIAmRanker = true;
		myRankingInList = Tab_RichList.GetRecordCount();		
	}
	else
	{
		RowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
	}
	RowData.OverlayTexU = 734;
	RowData.OverlayTexV = 45;
	rankStr = string(nRanking);
	GetTextSizeDefault(rankStr, tW, tH);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, rankStr, applyColor, false, - tW / 2, 0);
	percentStr = (stringPer(float(nRanking), float(nTotalUser))) $ "%";
	percentStr = (stringPer(float(nRanking), float(nTotalUser))) $ "%";
	percentStr = ("(" $ percentStr) $ ")";
	GetTextSizeDefault(percentStr, mW, mH);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, percentStr, applyColor, false, - tW - (mW / 4), tH + 2);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, (severName $ "_") $ getInstanceL2Util().makeZeroString(2, getServerExtIdByWorldID(nServerID)), applyColor, false, 0, 0);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, PlayerName, applyColor, false, 0, 0);
	addRichListCtrlString(RowData.cellDataList[3].drawitems, MakeCostString(string(dethronePoint)), applyColor, false, 5, 0);
	RowData.cellDataList[0].szData = rankStr;
	RowData.cellDataList[1].szData = severName;
	RowData.cellDataList[2].szData = PlayerName;
	RowData.cellDataList[3].szData = string(dethronePoint);
	Tab_RichList.InsertRecord(RowData);
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x34
		case EV_GameStart:
			bCurrentSeason = true;
			setLikeRadioButton("Top150Button");
			setToggleSeasonButton();
			// End:0x57
			break;
		// End:0x54
		case EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_RANKING_INFO):
			ParsePacket_S_EX_DETHRONE_RANKING_INFO();
			// End:0x57
			break;
	}
}

function ParsePacket_S_EX_DETHRONE_RANKING_INFO()
{
	local UIPacket._S_EX_DETHRONE_RANKING_INFO packet;
	local int i;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_RANKING_INFO(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_DETHRONE_RANKING_INFO :  " @ string(packet.cRankingScope));
	Debug("packet.rankInfoList.length : " @ string(packet.rankInfoList.Length));
	Tab_RichList.DeleteAllItem();
	bIAmRanker = false;
	myRankingInList = 0;

	// End:0x153 [Loop If]
	for(i = 0; i < packet.rankInfoList.Length; i++)
	{
		AddRankingSystemListItem(packet.rankInfoList[i].nRank, packet.nTotalRankers, packet.rankInfoList[i].nWorldID, packet.rankInfoList[i].sName, getServerNameByWorldID(packet.rankInfoList[i].nWorldID), packet.rankInfoList[i].nDethronePoint);
	}
	rankingListEndHandler();
}

function rankingListEndHandler()
{
	local int nStartRow;

	// End:0x77
	if(Tab_RichList.GetRecordCount() > 0)
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
				if(Tab_RichList.GetRecordCount() > nStartRow)
				{
					Tab_RichList.SetStartRow(nStartRow);
				}
			}
		}		
	}
	else
	{
		DisableWndList.ShowWindow();
		List_Empty.SetText(GetSystemString(13023));
	}
	Tab_RichList.SetFocus();
}

function setToggleSeasonButton()
{
	// End:0x20
	if(bCurrentSeason)
	{
		prvResultButton.SetButtonName(3707);		
	}
	else
	{
		prvResultButton.SetButtonName(3706);
	}
}

function API_C_EX_DETHRONE_RANKING_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_RANKING_INFO packet;

	packet.bCurrentSeason = byte(bCurrentSeason);
	packet.cRankingScope = currentRankingScope;
	// End:0x45
	if(! class'UIPacket'.static.Encode_C_EX_DETHRONE_RANKING_INFO(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_RANKING_INFO, stream);
	Debug("----> Api Call : C_EX_DETHRONE_RANKING_INFO " @ string(packet.cRankingScope) @ string(packet.bCurrentSeason));
}

defaultproperties
{
}
