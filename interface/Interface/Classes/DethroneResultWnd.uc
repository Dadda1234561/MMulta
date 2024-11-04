class DethroneResultWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle Result_wnd;
var TextBoxHandle OccupyName_txt;
var TextureHandle NowRulerServerMark_tex;
var TextBoxHandle OccupyTitle_txt;
var TextureHandle OccupyBG_tex;
var RichListCtrlHandle PointResult_RichList;
var TextBoxHandle PointResultTitle_txt;
var TextureHandle PointResultListBG_tex;
var TextureHandle PointResultBG_tex;
var TextBoxHandle AdenaTotalNuM_txt;
var TextBoxHandle ServerRewardNum_txt;
var TextBoxHandle AdenaTotalTitle_txt;
var TextBoxHandle ServerRewardTitle_txt;
var TextureHandle AdenaTotalBG_tex;
var TextBoxHandle ResultDscrp_txt;
var TextureHandle ResultDscrpBG_tex;
var WindowHandle Reward_wnd;
var ButtonHandle Reward_Btn;
var TextBoxHandle My_Ranking_txt;
var RichListCtrlHandle MyReward_ItemRichListCtrl;
var TextureHandle MyRewardItemRichListCtrlBG_tex;
var TextBoxHandle Server_Ranking_txt;
var RichListCtrlHandle ServerReward_ItemRichListCtrl;
var TextureHandle ServerRewardItemRichListCtrlBG_tex;
var TextBoxHandle My_RankingTitle_txt;
var TextBoxHandle Server_RankingTitle_txt;
var TextBoxHandle My_RewardTitle_txt;
var TextBoxHandle Server_RewardTitle_txt;
var TextureHandle My_RewardBG_tex;
var TextureHandle Server_RewardBG_tex;
var UIControlNeedItemList myRewardNeedItemList;
var UIControlNeedItemList serverRewardNeedItemList;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_PREV_SEASON_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_GET_REWARD);
	RegisterEvent(EV_GameStart);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle("DethroneResultWnd");
	Result_wnd = GetWindowHandle("DethroneResultWnd.Result_wnd");
	OccupyName_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.OccupyName_txt");
	NowRulerServerMark_tex = GetTextureHandle("DethroneResultWnd.Result_wnd.NowRulerServerMark_tex");
	OccupyTitle_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.OccupyTitle_txt");
	OccupyBG_tex = GetTextureHandle("DethroneResultWnd.Result_wnd.OccupyBG_tex");
	PointResult_RichList = GetRichListCtrlHandle("DethroneResultWnd.Result_wnd.PointResult_RichList");
	PointResultTitle_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.PointResultTitle_txt");
	PointResultListBG_tex = GetTextureHandle("DethroneResultWnd.Result_wnd.PointResultListBG_tex");
	PointResultBG_tex = GetTextureHandle("DethroneResultWnd.Result_wnd.PointResultBG_tex");
	AdenaTotalNuM_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.AdenaTotalNuM_txt");
	ServerRewardNum_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.ServerRewardNum_txt");
	AdenaTotalTitle_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.AdenaTotalTitle_txt");
	ServerRewardTitle_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.ServerRewardTitle_txt");
	AdenaTotalBG_tex = GetTextureHandle("DethroneResultWnd.Result_wnd.AdenaTotalBG_tex");
	ResultDscrp_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.ResultDscrp_txt");
	ResultDscrpBG_tex = GetTextureHandle("DethroneResultWnd.Result_wnd.ResultDscrpBG_tex");
	Reward_wnd = GetWindowHandle("DethroneResultWnd.Reward_wnd");
	Reward_Btn = GetButtonHandle("DethroneResultWnd.Reward_wnd.Reward_Btn");
	My_Ranking_txt = GetTextBoxHandle("DethroneResultWnd.Reward_wnd.My_Ranking_txt");
	MyReward_ItemRichListCtrl = GetRichListCtrlHandle("DethroneResultWnd.Reward_wnd.MyReward_ItemRichListCtrl");
	MyRewardItemRichListCtrlBG_tex = GetTextureHandle("DethroneResultWnd.Reward_wnd.MyRewardItemRichListCtrlBG_tex");
	Server_Ranking_txt = GetTextBoxHandle("DethroneResultWnd.Reward_wnd.Server_Ranking_txt");
	ServerReward_ItemRichListCtrl = GetRichListCtrlHandle("DethroneResultWnd.Reward_wnd.ServerReward_ItemRichListCtrl");
	ServerRewardItemRichListCtrlBG_tex = GetTextureHandle("DethroneResultWnd.Reward_wnd.ServerRewardItemRichListCtrlBG_tex");
	My_RankingTitle_txt = GetTextBoxHandle("DethroneResultWnd.Reward_wnd.My_RankingTitle_txt");
	Server_RankingTitle_txt = GetTextBoxHandle("DethroneResultWnd.Reward_wnd.Server_RankingTitle_txt");
	My_RewardTitle_txt = GetTextBoxHandle("DethroneResultWnd.Reward_wnd.My_RewardTitle_txt");
	Server_RewardTitle_txt = GetTextBoxHandle("DethroneResultWnd.Reward_wnd.Server_RewardTitle_txt");
	My_RewardBG_tex = GetTextureHandle("DethroneResultWnd.Reward_wnd.My_RewardBG_tex");
	Server_RewardBG_tex = GetTextureHandle("DethroneResultWnd.Reward_wnd.Server_RewardBG_tex");
	PointResult_RichList.SetSelectedSelTooltip(false);
	PointResult_RichList.SetAppearTooltipAtMouseX(true);
	PointResult_RichList.SetSelectable(false);
	Reward_Btn.SetTooltipType("text");
	Reward_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13790), 270));
}

function Load()
{
	myRewardNeedItemList = new class'UIControlNeedItemList';
	myRewardNeedItemList.DelegateOnUpdateItem = DelegateOnUpdateItem;
	myRewardNeedItemList.SetRichListControler(MyReward_ItemRichListCtrl);
	serverRewardNeedItemList = new class'UIControlNeedItemList';
	serverRewardNeedItemList.DelegateOnUpdateItem = DelegateOnUpdateItem;
	serverRewardNeedItemList.SetRichListControler(ServerReward_ItemRichListCtrl);
}

function OnShow()
{
	API_C_EX_DETHRONE_PREV_SEASON_INFO();
}

function DelegateOnUpdateItem()
{}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x18
		case EV_GameStart:
			initControl();
			// End:0x5B
			break;
		// End:0x38
		case EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_PREV_SEASON_INFO):
			ParsePacket_S_EX_DETHRONE_PREV_SEASON_INFO();
			// End:0x5B
			break;
		// End:0x58
		case EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_GET_REWARD):
			ParsePacket_S_EX_DETHRONE_GET_REWARD();
			// End:0x5B
			break;
	}
}

function initControl()
{
	PointResult_RichList.DeleteAllItem();
	NowRulerServerMark_tex.SetTexture("");
	OccupyName_txt.SetText("");
	AdenaTotalNuM_txt.SetText("");
	ServerRewardNum_txt.SetText("");
	My_Ranking_txt.SetText("");
	Server_Ranking_txt.SetText("");
	MyReward_ItemRichListCtrl.DeleteAllItem();
	ServerReward_ItemRichListCtrl.DeleteAllItem();
	Reward_Btn.DisableWindow();
}

function ParsePacket_S_EX_DETHRONE_GET_REWARD()
{
	local UIPacket._S_EX_DETHRONE_GET_REWARD packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_GET_REWARD(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_DETHRONE_GET_REWARD : " @ string(packet.nResult));
	// End:0x83
	if(packet.nResult > 0)
	{
		Reward_Btn.DisableWindow();
		AddSystemMessage(5276);
	}
	API_C_EX_DETHRONE_PREV_SEASON_INFO();
}

function ParsePacket_S_EX_DETHRONE_PREV_SEASON_INFO()
{
	local UIPacket._S_EX_DETHRONE_PREV_SEASON_INFO packet;
	local int i;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_PREV_SEASON_INFO(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_DETHRONE_PREV_SEASON_INFO : ");
	PointResult_RichList.DeleteAllItem();
	Debug("packet.pointList.length" @ string(packet.pointList.Length));

	// End:0x164 [Loop If]
	for(i = 0; i < packet.pointList.Length; i++)
	{
		Debug("packet.pointList[i].nWorldID" @ string(packet.pointList[i].nWorldID));
		Debug("packet.pointList[i].nPoint" @ string(packet.pointList[i].nPoint));
		AddDethronePointStateListItem(i + 1, packet.pointList[i].nWorldID, packet.pointList[i].nPoint);
	}
	NowRulerServerMark_tex.SetTexture(GetServerMarkNameSmall(packet.nOccupyingWorldID));
	OccupyName_txt.SetText(packet.sConquerorName);
	AdenaTotalNuM_txt.SetText(MakeCostString(string(packet.nTotalSoulBead)));
	ServerRewardNum_txt.SetText(MakeCostString(string(packet.nOccupyingServerReward)));
	// End:0x22A
	if(packet.nRank == 0)
	{
		My_Ranking_txt.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));
		Server_Ranking_txt.SetText(" - ");		
	}
	else
	{
		My_Ranking_txt.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRank)) $ " " $ stringPer(packet.nRank, packet.nTotalRankers) $ "%" $ ")");
		Server_Ranking_txt.SetText(getServerNameByWorldID(packet.nOccupyingWorldID));
	}
	// End:0x2F8
	if(packet.personalRewardList.Length == 0)
	{
		GetTextBoxHandle("DethroneResultWnd.Result_wnd.MyNonReward_text").ShowWindow();		
	}
	else
	{
		GetTextBoxHandle("DethroneResultWnd.Result_wnd.MyNonReward_text").HideWindow();
	}
	// End:0x38E
	if(packet.serverRewardList.Length == 0)
	{
		GetTextBoxHandle("DethroneResultWnd.Result_wnd.ServerNonReward_text").ShowWindow();		
	}
	else
	{
		GetTextBoxHandle("DethroneResultWnd.Result_wnd.ServerNonReward_text").HideWindow();
	}
	myRewardNeedItemList.StartNeedItemList(2);
	myRewardNeedItemList.SetHideMyNum(true);

	// End:0x4A4 [Loop If]
	for(i = 0; i < packet.personalRewardList.Length; i++)
	{
		myRewardNeedItemList.AddNeedItemClassID(packet.personalRewardList[i].nItemClassID, packet.personalRewardList[i].nAmount);
		Debug("1 id-> " @ string(packet.personalRewardList[i].nItemClassID));
		Debug("1 count-> " @ string(packet.personalRewardList[i].nAmount));
	}
	myRewardNeedItemList.SetBuyNum(1);
	serverRewardNeedItemList.StartNeedItemList(2);
	serverRewardNeedItemList.SetHideMyNum(true);

	// End:0x589 [Loop If]
	for(i = 0; i < packet.serverRewardList.Length; i++)
	{
		Debug("2 id-> " @ string(packet.serverRewardList[i].nItemClassID));
		Debug("2 count-> " @ string(packet.serverRewardList[i].nAmount));
		serverRewardNeedItemList.AddNeedItemClassID(packet.serverRewardList[i].nItemClassID, packet.serverRewardList[i].nAmount);
	}
	serverRewardNeedItemList.SetBuyNum(1);
	Debug("packet.bHasReward " @ string(packet.bHasReward));
	// End:0x5FD
	if(packet.bHasReward > 0 && ! class'UIDATA_PLAYER'.static.IsInDethrone())
	{
		Reward_Btn.EnableWindow();		
	}
	else
	{
		Reward_Btn.DisableWindow();
	}
}

function AddDethronePointStateListItem(int nRank, int ServerID, INT64 dethronePoint)
{
	local RichListCtrlRowData RowData;
	local Color applyColor;
	local bool bMe;
	local ServerInfoUIData ServerInfo;

	RowData.cellDataList.Length = 2;
	bMe = isMyServer(ServerID);
	// End:0x41
	if(bMe)
	{
		applyColor = GTColor().Yellow;		
	}
	else
	{
		applyColor = GTColor().White;
	}
	class'UIDataManager'.static.GetServerInfo(ServerID, ServerInfo);
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, GetServerMarkNameSmall(ServerID), 30, 30);
	// End:0x112
	if(nRank == 1)
	{
		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_EPIC.ClanWnd.ClanWnd_MasterIcon", 21, 19, 0, 4);
		addRichListCtrlString(RowData.cellDataList[0].drawitems, ServerInfo.ServerName, applyColor, false, 2, 4);		
	}
	else
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, ServerInfo.ServerName, applyColor, false, 0, 8);
	}
	addRichListCtrlString(RowData.cellDataList[1].drawitems, MakeCostString(string(dethronePoint)), applyColor, false, 5, 0);
	RowData.cellDataList[0].szData = ServerInfo.ServerName;
	RowData.cellDataList[1].szData = string(dethronePoint);
	RowData.cellDataList[0].drawitems[RowData.cellDataList[0].drawitems.Length - 1].nReservedTooltipID = 99999;
	RowData.cellDataList[0].drawitems[RowData.cellDataList[0].drawitems.Length - 1].TooltipDesc = GetSystemString(13700);
	RowData.szReserved = ServerInfo.ServerName;
	PointResult_RichList.InsertRecord(RowData);
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x1F
		case "Reward_Btn":
			OnReward_BtnClick();
			// End:0x3F
			break;
		// End:0x3C
		case "ok_Btn":
			Me.HideWindow();
			// End:0x3F
			break;
	}
}

function OnReward_BtnClick()
{
	API_C_EX_DETHRONE_GET_REWARD();
}

function API_C_EX_DETHRONE_PREV_SEASON_INFO()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_PREV_SEASON_INFO, stream);
	Debug("----> Api Call : C_EX_DETHRONE_PREV_SEASON_INFO ");
}

function API_C_EX_DETHRONE_GET_REWARD()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_GET_REWARD, stream);
	Debug("----> Api Call : C_EX_DETHRONE_GET_REWARD ");
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
