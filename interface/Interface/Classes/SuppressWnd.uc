class SuppressWnd extends UICommonAPI;

var WindowHandle Me;
var RichListCtrlHandle SuppressList_ListCtrl;
var TextureHandle SuppressZoneImg_tex;
var TextureHandle SuppressZoneImgEvent_tex;
var TextureHandle SuppressZoneEventIcon_tex;
var TextBoxHandle SuppressZoneTitle_txt;
var ButtonHandle SuppressRefresh_btn;
var ButtonHandle SuppressKey_btn;
var TextBoxHandle SuppressKeyDesc_txt;
var ButtonHandle SuppressTeleport_btn;
var TextBoxHandle SuppressTeleportDesc_txt;
var TextBoxHandle SuppressRankingTitle_txt;
var TextBoxHandle SuppressMyRankingTitle_txt;
var TextBoxHandle SuppressMyPointTitle_txt;
var TextBoxHandle SuppressMyRanking_txt;
var TextBoxHandle SuppressMyPoint_txt;
var RichListCtrlHandle SuppressRankingList_ListCtrl;
var string m_WindowName;
var int clientStartSec;
var int currentTimeSec;
var L2UITime L2UITime;
var int serverStartTime;
var array<SubjugationData> SubjugationDataArray;
var bool bScriptLoaded;
var int currentTeleportID;
var int currentSubjugationID;
var int lastSelectedListIndex;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_SUBJUGATION_LIST);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_SUBJUGATION_RANKING);
	RegisterEvent(EV_CurrentServerTime);
	RegisterEvent(EV_Restart);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	SuppressList_ListCtrl.SetSelectedSelTooltip(false);
	SuppressRankingList_ListCtrl.SetSelectedSelTooltip(false);
	SuppressRankingList_ListCtrl.SetAppearTooltipAtMouseX(true);
	SuppressRankingList_ListCtrl.SetSelectable(false);
	SetPopupScript();
}

function Initialize()
{
	Me = GetWindowHandle("SuppressWnd");
	SuppressList_ListCtrl = GetRichListCtrlHandle("SuppressWnd.SuppressList_ListCtrl");
	SuppressZoneImg_tex = GetTextureHandle("SuppressWnd.SuppressZoneImg_tex");
	SuppressZoneImgEvent_tex = GetTextureHandle("SuppressWnd.SuppressZoneImgEvent_tex");
	SuppressZoneEventIcon_tex = GetTextureHandle("SuppressWnd.SuppressZoneEventIcon_tex");
	SuppressZoneTitle_txt = GetTextBoxHandle("SuppressWnd.SuppressZoneTitle_txt");
	SuppressRefresh_btn = GetButtonHandle("SuppressWnd.SuppressRefresh_btn");
	SuppressKey_btn = GetButtonHandle("SuppressWnd.SuppressKey_btn");
	SuppressKeyDesc_txt = GetTextBoxHandle("SuppressWnd.SuppressKeyDesc_txt");
	SuppressTeleportDesc_txt = GetTextBoxHandle("SuppressWnd.SuppressTeleportDesc_txt");
	SuppressTeleport_btn = GetButtonHandle("SuppressWnd.SuppressTeleport_btn");
	SuppressRankingTitle_txt = GetTextBoxHandle("SuppressWnd.SuppressRankingTitle_txt");
	SuppressMyRankingTitle_txt = GetTextBoxHandle("SuppressWnd.SuppressMyRankingTitle_txt");
	SuppressMyPointTitle_txt = GetTextBoxHandle("SuppressWnd.SuppressMyPointTitle_txt");
	SuppressMyRanking_txt = GetTextBoxHandle("SuppressWnd.SuppressMyRanking_txt");
	SuppressMyPoint_txt = GetTextBoxHandle("SuppressWnd.SuppressMyPoint_txt");
	SuppressRankingList_ListCtrl = GetRichListCtrlHandle("SuppressWnd.SuppressRankingList_ListCtrl");
	lastSelectedListIndex = -1;
}

function OnShow()
{
	if(GetWindowHandle("SuppressDrawWnd").IsShowWindow())
	{
		GetWindowHandle("SuppressDrawWnd").HideWindow();
	}
	setLoadScriptData();
	refreshList();
}

function OnHide()
{
	if(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset").IsShowWindow())
	{
		GetPopupExpandScript().Hide();
	}
}

function refreshList()
{
	addListByScript();
	API_C_EX_SUBJUGATION_LIST();
}

function setLoadScriptData()
{
	if(! bScriptLoaded)
	{
		bScriptLoaded = true;
		GetSubjugationList(SubjugationDataArray);
	}
}

function addListByScript()
{
	local int i;

	SuppressList_ListCtrl.DeleteAllItem();

	for(i = 0; i < SubjugationDataArray.Length; i++)
	{
		addRichListData(true, SubjugationDataArray[i], 0, 0, -1);
	}
	if(lastSelectedListIndex > -1)
	{
		SuppressList_ListCtrl.SetSelectedIndex(lastSelectedListIndex, true);		
	}
	else
	{
		SuppressList_ListCtrl.SetSelectedIndex(0, true);
		OnClickListCtrlRecord("SuppressList_ListCtrl");
	}
}

function SubjugationData getSubjugationDataByID(int Id)
{
	local int i;
	local SubjugationData emptyData;

	for(i = 0; i < SubjugationDataArray.Length; i++)
	{
		if(SubjugationDataArray[i].Id == Id)
		{
			return SubjugationDataArray[i];
		}
	}
	return emptyData;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "SuppressRefresh_btn":
			OnSuppressRefresh_btnClick();
			break;
		case "SuppressKey_btn":
			OnSuppressKey_btnClick();
			break;
		case "SuppressTeleport_btn":
			OnSuppressTeleport_btnClick();
			break;
		case "HelpWnd_Btn":
			ExecuteEvent(1210, "61");
			break;
	}
}

function OnSuppressRefresh_btnClick()
{
	refreshList();
}

function OnSuppressKey_btnClick()
{
	SuppressDrawWnd(GetScript("SuppressDrawWnd")).setScriptData(currentSubjugationID);
	toggleWindow("SuppressDrawWnd", true);
	Me.HideWindow();
}

function OnSuppressTeleport_btnClick()
{
	ShowPopup();
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "SuppressList_ListCtrl":
			OnSuppressKey_btnClick();
			break;
	}	
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(class'UIPacket'.const.S_EX_SUBJUGATION_LIST):
			ParsePacket_S_EX_SUBJUGATION_LIST();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_SUBJUGATION_RANKING):
			ParsePacket_S_EX_SUBJUGATION_RANKING();
			break;
		case EV_CurrentServerTime:
			setCurrentserverTime(param);
			break;
		case EV_Restart:
			bScriptLoaded = false;
			clientStartSec = 0;
			currentTimeSec = 0;
			lastSelectedListIndex = -1;
			break;
	}
}

function setSelectListByID(int Id)
{
	local int i;
	local RichListCtrlRowData TempRowData;

	for(i = 0; i < SuppressList_ListCtrl.GetRecordCount(); i++)
	{
		SuppressList_ListCtrl.GetRec(i, TempRowData);

		if(Id == TempRowData.nReserved1)
		{
			SuppressList_ListCtrl.SetSelectedIndex(i, true);
			break;
		}
	}	
}

function addRichListData(bool bAddList, SubjugationData sjData, int subjugationPoint, int gachaPoint, int nRemainedPeriodicGachaPoint)
{
	local RichListCtrlRowData RowData, TempRowData;
	local string Title;
	local int i, W, h;
	local float statusPercent;
	local bool bIsEvent, bIsCycle, bEnableLevel, bWaitState;
	local int nDisableState;
	local UserInfo UserInfo;
	local Color FontColor;
	local string timeStr;

	RowData.szReserved = sjData.Desc;
	bIsCycle = isInPeroid(sjData.Cycle);
	bIsEvent = isInPeroid(sjData.HotTimes);
	GetPlayerInfo(UserInfo);

	if((sjData.MinLevel <= UserInfo.nLevel) && sjData.MaxLevel >= UserInfo.nLevel)
	{
		bEnableLevel = true;
		FontColor = GTColor().White;		
	}
	else
	{
		FontColor = GTColor().Gray;
	}
	RowData.cellDataList.Length = 3;
	RowData.nReserved1 = sjData.Id;
	RowData.nReserved2 = boolToNum(bIsEvent);

	if(bEnableLevel && bIsCycle)
	{
		RowData.nReserved3 = 1;		
	}
	else
	{
		RowData.nReserved3 = 0;
	}
	RowData.cellDataList[1].szData = sjData.Banner;
	Title = sjData.Name $ " (Lv." $ string(sjData.MinLevel) $ "~" $ string(sjData.MaxLevel) $ ")";
	RowData.cellDataList[0].szData = sjData.Name $ "\\n(Lv." $ string(sjData.MinLevel) $ "~" $ string(sjData.MaxLevel) $ ")";
	addRichListCtrlString(RowData.cellDataList[0].drawitems, Title, FontColor, false, 17, 14, "hs10");

	if(bIsEvent)
	{
		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_EPIC.SuppressWnd.SuppressHotTimeIcon", 61, 19, 2, -2);
		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.EmptyBtn", 61, 19, -61, 0);
		RowData.cellDataList[0].drawitems[RowData.cellDataList[0].drawitems.Length - 1].nReservedTooltipID = 99999;
		RowData.cellDataList[0].drawitems[RowData.cellDataList[0].drawitems.Length - 1].TooltipDesc = GetSystemString(13700);
	}

	if(! bEnableLevel)
	{
		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_EPIC.SuppressWnd.SuppressLockIcon", 18, 24, 2, -2);
		nDisableState = 1;
	}

	if(nRemainedPeriodicGachaPoint >= sjData.MaxPeriodicGachaPoint)
	{
		nDisableState = 1;
	}
	timeStr = GetRemainTimeString(sjData.Cycle);

	if(timeStr == GetSystemString(3526))
	{
		bWaitState = true;
		nDisableState = 1;
	}
	statusPercent = (float(subjugationPoint) / float(sjData.MaxSubjugationPoint)) * 100;

	if(bEnableLevel)
	{
		if(bWaitState)
		{
			statusPercent = 0.0f;
			AddRichListCtrlStatusInfo(RowData.cellDataList[0].drawitems, 312, 15, 15, 6, true, statusPercent, 0.0f, string(statusPercent) $ "%", nDisableState,, FontColor);			
		}
		else
		{
			if(subjugationPoint == 0)
			{
				if(nRemainedPeriodicGachaPoint == 0)
				{
					AddRichListCtrlStatusInfo(RowData.cellDataList[0].drawitems, 312, 15, 15, 6, true, 100.0f, 0.0f, GetSystemString(898), nDisableState,, FontColor);					
				}
				else
				{
					AddRichListCtrlStatusInfo(RowData.cellDataList[0].drawitems, 312, 15, 15, 6, true, statusPercent, 0.0f, GetSystemString(13484), nDisableState,, FontColor);
				}				
			}
			else
			{
				AddRichListCtrlStatusInfo(RowData.cellDataList[0].drawitems, 312, 15, 15, 6, true, statusPercent, 0.0f, string(statusPercent) $ "%", 0,, FontColor);
			}
		}		
	}
	else
	{
		AddRichListCtrlStatusInfo(RowData.cellDataList[0].drawitems, 312, 15, 15, 6, true, statusPercent, 0.0f, GetSystemString(3587), nDisableState,, FontColor);
	}
	RowData.cellDataList[0].nReserved1 = gachaPoint;
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_EPIC.SuppressWnd.SuppressKeyIcon", 36, 41, 0, -20);

	if(gachaPoint > 0)
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, "x" $ string(gachaPoint), GTColor().Yellow, false, 2, 18, "hs10");		
	}
	else
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, "x" $ string(gachaPoint), FontColor, false, 2, 18);
	}
	RowData.cellDataList[2].nReserved1 = sjData.TeleportID;

	if(nRemainedPeriodicGachaPoint == -1)
	{
		nRemainedPeriodicGachaPoint = sjData.MaxPeriodicGachaPoint;
	}
	addRichListCtrlString(RowData.cellDataList[1].drawitems, string(nRemainedPeriodicGachaPoint) $ "/" $ string(sjData.MaxPeriodicGachaPoint), FontColor, false, 0, 10);
	GetTextSize(string(nRemainedPeriodicGachaPoint) $ "/" $ string(sjData.MaxPeriodicGachaPoint), "GameDefault", W, h);
	addRichListCtrlTexture(RowData.cellDataList[1].drawitems, "L2UI_CT1.EmptyBtn", W, 32, - W, -10);
	RowData.cellDataList[1].drawitems[RowData.cellDataList[1].drawitems.Length - 1].nReservedTooltipID = 99999;
	RowData.cellDataList[1].drawitems[RowData.cellDataList[1].drawitems.Length - 1].TooltipDesc = GetSystemString(13698);

	if(bWaitState)
	{
		addRichListCtrlTexture(RowData.cellDataList[2].drawitems, "L2UI_CH3.FishingWnd.fishing_clockicon", 16, 16, 0, 0);
	}
	addRichListCtrlString(RowData.cellDataList[2].drawitems, timeStr, FontColor, false, 0, 2);

	if(bAddList)
	{
		SuppressList_ListCtrl.InsertRecord(RowData);		
	}
	else
	{
		for(i = 0; i < SuppressList_ListCtrl.GetRecordCount(); i++)
		{
			SuppressList_ListCtrl.GetRec(i, TempRowData);

			if(sjData.Id == TempRowData.nReserved1)
			{
				SuppressList_ListCtrl.ModifyRecord(i, RowData);
				break;
			}
		}
	}
}

function API_C_EX_SUBJUGATION_LIST()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SUBJUGATION_LIST, stream);
	Debug("--> C_EX_SUBJUGATION_LIST");
}

function ParsePacket_S_EX_SUBJUGATION_LIST()
{
	local UIPacket._S_EX_SUBJUGATION_LIST packet;
	local int i;

	if(! class'UIPacket'.static.Decode_S_EX_SUBJUGATION_LIST(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_SUBJUGATION_LIST :  ");

	for(i = 0;  i < packet.vInfos.Length; i++)
	{
		Debug("-nID" @ string(packet.vInfos[i].nID));
		Debug("-nPoint" @ string(packet.vInfos[i].nPoint));
		Debug("-nGachaPoint" @ string(packet.vInfos[i].nGachaPoint));
		Debug("-nRemainedPeriodicGachaPoint" @ string(packet.vInfos[i].nRemainedPeriodicGachaPoint));
		addRichListData(false, getSubjugationDataByID(packet.vInfos[i].nID), packet.vInfos[i].nPoint, packet.vInfos[i].nGachaPoint, packet.vInfos[i].nRemainedPeriodicGachaPoint);
	}
	SuppressList_ListCtrl.SetSelectedIndex(SuppressList_ListCtrl.GetSelectedIndex(), true);
	OnClickListCtrlRecord("SuppressList_ListCtrl");
}

function API_C_EX_SUBJUGATION_RANKING(int nID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SUBJUGATION_RANKING packet;

	packet.nID = nID;

	if(! class'UIPacket'.static.Encode_C_EX_SUBJUGATION_RANKING(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SUBJUGATION_RANKING, stream);
}

function ParsePacket_S_EX_SUBJUGATION_RANKING()
{
	local UIPacket._S_EX_SUBJUGATION_RANKING packet;
	local int i;

	if(! class'UIPacket'.static.Decode_S_EX_SUBJUGATION_RANKING(packet))
	{
		return;
	}

	if(packet.nRank == 0)
	{
		SuppressMyRanking_txt.SetText(GetSystemString(27));		
	}
	else
	{
		SuppressMyRanking_txt.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRank)));
	}
	SuppressMyPoint_txt.SetText(MakeCostString(string(packet.nPoint)));
	SuppressRankingList_ListCtrl.DeleteAllItem();
	packet.vRankers.Sort(SortByRankingDelegate);

	for(i = 0; i < packet.vRankers.Length; i++)
	{
		addRichListRanking(packet.vRankers[i].nRank, packet.vRankers[i].sUserName, packet.vRankers[i].nPoint);
	}
}

delegate int SortByRankingDelegate(UIPacket._PkSubjugationRanker a1, UIPacket._PkSubjugationRanker a2)
{
	if(a1.nRank > a2.nRank)
	{
		return -1;
	}
	return 0;
}

function addRichListRanking(int nRanking, string Title, int nPoint)
{
	local RichListCtrlRowData RowData;
	local string texStr;
	local ItemInfo Info;
	local SubjugationData sjData;
	local int i;

	RowData.cellDataList.Length = 3;
	sjData = getSubjugationDataByID(currentSubjugationID);

	if(nRanking == 1)
	{
		texStr = "L2UI_ct1.RankingWnd.RankingWnd_1st";

		for(i = 0; i < sjData.RewardRank1.Length; i++)
		{
			if(i == 0)
			{
				Info = GetItemInfoByClassID(sjData.RewardRank1[i]);
				continue;
			}
			if(i == 1)
			{
				Info.ItemNum = sjData.RewardRank1[i];
			}
		}		
	}
	else if(nRanking == 2)
	{
		texStr = "L2UI_ct1.RankingWnd.RankingWnd_2nd";

		for(i = 0; i < sjData.RewardRank2.Length; i++)
		{
			if(i == 0)
			{
				Info = GetItemInfoByClassID(sjData.RewardRank2[i]);
				continue;
			}
			if(i == 1)
			{
				Info.ItemNum = sjData.RewardRank2[i];
			}
		}			
	}
	else if(nRanking == 3)
	{
		texStr = "L2UI_ct1.RankingWnd.RankingWnd_3rd";

		for(i = 0; i < sjData.RewardRank3.Length; i++)
		{
			if(i == 0)
			{
				Info = GetItemInfoByClassID(sjData.RewardRank3[i]);
				continue;
			}
			if(i == 1)
			{
				Info.ItemNum = sjData.RewardRank3[i];
			}
		}				
	}
	else if(nRanking == 4)
	{
		texStr = "L2UI_EPIC.RankingWnd.RankingWnd_4th";

		for(i = 0; i < sjData.RewardRank4.Length; i++)
		{
			if(i == 0)
			{
				Info = GetItemInfoByClassID(sjData.RewardRank4[i]);
				continue;
			}
			if(i == 1)
			{
				Info.ItemNum = sjData.RewardRank4[i];
			}
		}					
	}
	else if(nRanking == 5)
	{
		texStr = "L2UI_EPIC.RankingWnd.RankingWnd_5th";

		for(i = 0; i < sjData.RewardRank5.Length; i++)
		{
			if(i == 0)
			{
				Info = GetItemInfoByClassID(sjData.RewardRank5[i]);
				continue;
			}
			if(i == 1)
			{
				Info.ItemNum = sjData.RewardRank5[i];
			}
		}
	}

	if(Info.ItemNum > 1)
	{
		Info.bShowCount = true;
	}

	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, texStr, 38, 33, 10, 10);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, Title, GetColor(254, 215, 160, 255), false, 0, 12);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, MakeCostString(string(nPoint)), GTColor().White, true, 0, 0);
	addRichListCtrlTexture(RowData.cellDataList[2].drawitems, "L2UI_EPIC.SuppressWnd.SuppressItem1st_Frame", 36, 36, 0, 12);
	AddRichListCtrlItem(RowData.cellDataList[2].drawitems, Info, 32, 32, -34, 2);
	SuppressRankingList_ListCtrl.InsertRecord(RowData);
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData RowData;

	if(ListCtrlID == "SuppressList_ListCtrl")
	{
		lastSelectedListIndex = SuppressList_ListCtrl.GetSelectedIndex();
		SuppressList_ListCtrl.GetSelectedRec(RowData);
		currentTeleportID = RowData.cellDataList[2].nReserved1;
		setSuppressPage(numToBool(int(RowData.nReserved2)), numToBool(int(RowData.nReserved3)), RowData.cellDataList[0].szData, RowData.cellDataList[0].nReserved1, RowData.cellDataList[1].szData);
		SuppressRankingList_ListCtrl.DeleteAllItem();
		SuppressMyRanking_txt.SetText(GetSystemString(27));
		SuppressMyPoint_txt.SetText("0");
		currentSubjugationID = int(RowData.nReserved1);
		API_C_EX_SUBJUGATION_RANKING(currentSubjugationID);
		setTooltipAtSuppressKey_btn();
	}
}

function setSuppressPage(bool bEvent, bool bEnableState, string titleStr, int gachaPoint, string bgTexStr)
{
	SuppressZoneTitle_txt.SetText(titleStr);
	SuppressKeyDesc_txt.SetText(GetSystemString(13630) $ "\\nx" $ string(gachaPoint));

	if(gachaPoint > 0)
	{
		SuppressKeyDesc_txt.SetTextColor(GTColor().Yellow);		
	}
	else
	{
		SuppressKeyDesc_txt.SetTextColor(GTColor().White);
	}
	if(bEvent)
	{
		SuppressZoneEventIcon_tex.ShowWindow();
		SuppressZoneImgEvent_tex.ShowWindow();		
	}
	else
	{
		SuppressZoneEventIcon_tex.HideWindow();
		SuppressZoneImgEvent_tex.HideWindow();
	}
	if(bgTexStr == "")
	{
		SuppressZoneImg_tex.SetTexture("L2UI_EPIC.SuppressWnd.SuppressItem_Bg");		
	}
	else
	{
		SuppressZoneImg_tex.SetTexture(bgTexStr);
	}
	if(bEnableState)
	{
		SuppressTeleport_btn.EnableWindow();
		SuppressTeleportDesc_txt.SetTextColor(GTColor().White);		
	}
	else
	{
		SuppressTeleport_btn.DisableWindow();
		SuppressTeleportDesc_txt.SetTextColor(GTColor().Gray);
	}
}

function setTooltipAtSuppressKey_btn()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local SubjugationData currentSubjugationData;
	local int i;
	local ItemInfo Info;

	currentSubjugationData = getSubjugationDataByID(currentSubjugationID);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2984), getInstanceL2Util().BrightWhite, "hs14", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);

	for(i = 0; i < (currentSubjugationData.ShowGachaMain.Length / 3); i++)
	{
		Info = GetItemInfoByClassID(currentSubjugationData.ShowGachaMain[i * 3]);
		Info.ItemNum = currentSubjugationData.ShowGachaMain[(i * 3) + 1];
	
		if(Info.ItemNum > 1)
		{
			Info.bShowCount = true;
		}
		addDrawItemGameItem(drawListArr, Info, true, GTColor().Yellow);
	}

	for(i = 0; i < (currentSubjugationData.ShowGachaSub.Length / 3); i++)
	{
		Info = GetItemInfoByClassID(currentSubjugationData.ShowGachaSub[i * 3]);
		Info.ItemNum = currentSubjugationData.ShowGachaSub[(i * 3) + 1];

		if(Info.ItemNum > 1)
		{
			Info.bShowCount = true;
		}
		addDrawItemGameItem(drawListArr, Info, true);
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	SuppressKey_btn.SetTooltipType("text");
	SuppressKey_btn.SetTooltipCustomType(mCustomTooltip);
}

function setCurrentserverTime(string param)
{
	clientStartSec = int(GetAppSeconds());
	ParseInt(param, "ServerTime", serverStartTime);
}

function int changeTimeData(int nTime)
{
	local string timeStr;
	local int Day;

	Day = int(Left(getInstanceL2Util().makeZeroString(5, nTime), 1));
	timeStr = Right(getInstanceL2Util().makeZeroString(5, nTime), 4);

	if(Day == 0)
	{
		Day = 7;
	}
	return int(string(Day) $ timeStr);
}

function int getRemainTimeSec(int RemainTime)
{
	local string timeStr;
	local int Day, Hour, Min, totalSec;

	Day = int(Left(getInstanceL2Util().makeZeroString(5, RemainTime), 1));
	timeStr = Right(getInstanceL2Util().makeZeroString(5, RemainTime), 4);
	Hour = int(Left(timeStr, 2));
	Min = int(Right(timeStr, 2));
	totalSec = ((((Day * 24) * 60) * 60) + ((Hour * 60) * 60)) + (Min * 60);
	return totalSec;
}

function string GetRemainTimeString(array<int> Cycle)
{
	local int i, timeIndex, CurTime, nCurrentTime, nTemp, nStartTime,
		nEndTime;

	GetTimeStruct(int((float(serverStartTime) + (GetAppSeconds())) - float(clientStartSec)), L2UITime);
	CurTime = (L2UITime.nHour * 100) + L2UITime.nMin;
	nCurrentTime = int(string(L2UITime.nWeekDay) $ getInstanceL2Util().makeZeroString(4, CurTime));
	Debug("1 nCurrentTime" @ string(nCurrentTime));
	nCurrentTime = changeTimeData(nCurrentTime);
	Debug("2 nCurrentTime" @ string(nCurrentTime));
	timeIndex = -1;

	for(i = 0; i < (Cycle.Length / 2); i++)
	{
		nStartTime = changeTimeData(Cycle[i * 2]);
		nEndTime = changeTimeData(Cycle[(i * 2) + 1]);
		nTemp = nStartTime - nEndTime;
		Debug("Cycle" @ string(Cycle[i]));
		Debug("시작 시간 " @ string(nStartTime));
		Debug("nCurrentTime" @ string(nCurrentTime));
		Debug("끝 시간 " @ string(nEndTime));

		if(nTemp <= -1)
		{
			if((nStartTime <= nCurrentTime) && nEndTime >= nCurrentTime)
			{
				timeIndex = i;
				break;
			}
		}
	}
	Debug("timeIndex" @ string(timeIndex));

	if(timeIndex > -1)
	{
		nTemp = (getRemainTimeSec(nEndTime)) - (getRemainTimeSec(nCurrentTime));
		Debug("남은 시간" @ string(nTemp) @ string(nTemp) @ (getTimeStringBySec(getRemainTimeSec(nTemp))));
		return getTimeStringBySec(nTemp);
	}
	return GetSystemString(3526);
}

function bool isInPeroid(array<int> Cycle)
{
	local int i, nStartTime, nEndTime, CurTime, nCurrentTime, nTemp;

	GetTimeStruct(int((float(serverStartTime) + (GetAppSeconds())) - float(clientStartSec)), L2UITime);
	CurTime = (L2UITime.nHour * 100) + L2UITime.nMin;
	nCurrentTime = int(string(L2UITime.nWeekDay) $ getInstanceL2Util().makeZeroString(4, CurTime));
	nCurrentTime = changeTimeData(nCurrentTime);

	for(i = 0; i < (Cycle.Length / 2); i++)
	{
		nStartTime = changeTimeData(Cycle[i * 2]);
		nEndTime = changeTimeData(Cycle[(i * 2) + 1]);
		nTemp = nStartTime - nEndTime;

		if(nTemp <= -1)
		{
			if((nStartTime <= nCurrentTime) && nEndTime >= nCurrentTime)
			{
				return true;
			}
		}
	}
	return false;
}

function bool IsInPeroidWithRemainTime(array<int> Cycle, out int RemainTime)
{
	local int i, nStartTime, nEndTime, CurTime, nCurrentTime, nTemp;

	GetTimeStruct(int((float(serverStartTime) + (GetAppSeconds())) - float(clientStartSec)), L2UITime);
	CurTime = (L2UITime.nHour * 100) + L2UITime.nMin;
	nCurrentTime = int(string(L2UITime.nWeekDay) $ getInstanceL2Util().makeZeroString(4, CurTime));
	nCurrentTime = changeTimeData(nCurrentTime);

	for(i = 0; i < (Cycle.Length / 2); i++)
	{
		nStartTime = changeTimeData(Cycle[i * 2]);
		nEndTime = changeTimeData(Cycle[(i * 2) + 1]);
		nTemp = nStartTime - nEndTime;

		if(nTemp <= -1)
		{
			if((nStartTime <= nCurrentTime) && nEndTime >= nCurrentTime)
			{
				RemainTime = (TimeStringToSec(nEndTime)) - (TimeStringToSec(nCurrentTime));
				return true;
				continue;
			}
			if(nCurrentTime < nStartTime)
			{
				RemainTime = (TimeStringToSec(nStartTime)) - (TimeStringToSec(nCurrentTime));
				return false;
			}
		}
	}
	if(Cycle.Length > 0)
	{
		RemainTime = (TimeStringToSec((changeTimeData(Cycle[0])) + 70000)) - (TimeStringToSec(nCurrentTime));
	}
	return false;
}

function int TimeStringToSec(int Time)
{
	local int D, h, M;
	local string remainTimeString;

	remainTimeString = getInstanceL2Util().makeZeroString(5, Time);
	D = int(Left(remainTimeString, 1));
	h = int(Right(Left(remainTimeString, 3), 2));
	M = int(Right(remainTimeString, 2));
	return (((D * 24) * 360) + (h * 360)) + (M * 60);
}

function string getTimeStringBySec(int Sec)
{
	local int timeTemp, timeTemp0, timeTemp1;
	local string returnStr;

	returnStr = "";
	timeTemp = ((Sec / 60) / 60) / 24;
	timeTemp0 = (Sec / 60) / 60;
	timeTemp1 = Sec / 60;

	if(timeTemp > 0)
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(4466), string(timeTemp), string(int(float((Sec / 60) / 60) % float(24))), string(int(float(Sec / 60) % float(60))));		
	}
	else
	{
		if(timeTemp0 > 0)
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp0), string(int(float(Sec / 60) % float(60))));			
		}
		else
		{
			if(timeTemp1 > 0)
			{
				returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));				
			}
			else
			{
				returnStr = MakeFullSystemMsg(GetSystemMessage(4360), string(1));
			}
		}
	}
	return returnStr;
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	return UIControlDialogAssets(poopExpandWnd.GetScript());
}

function SetPopupScript()
{
	local WindowHandle poopExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle DisableWnd;

	poopExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	popupExpandScript = class'UIControlDialogAssets'.static.InitScript(poopExpandWnd);
	DisableWnd = GetWindowHandle(m_WindowName $ ".disable_tex");
	popupExpandScript.SetDisableWindow(DisableWnd);
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop(m_WindowName $ ".disable_tex", false);
}

function ShowPopup()
{
	local UIControlDialogAssets popupExpandScript;
	local TeleportListAPI.TeleportListData listData;

	popupExpandScript = GetPopupExpandScript();
	listData = getInstanceUIData().GetTeleportListDataByID(currentTeleportID);
	popupExpandScript.SetDialogDesc(GetSystemMessage(5239) $ "\\n\\n" $ "(" $ listData.Name $ ")");
	popupExpandScript.SetUseNeedItem(true);
	popupExpandScript.StartNeedItemList(1);
	popupExpandScript.AddNeedItemClassID(57, getInstanceUIData().GetTeleportPriceByID(currentTeleportID));
	popupExpandScript.SetItemNum(1);
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = onClickTeleport;
	popupExpandScript.DelegateOnCancel = onClickCancelDialog;
}

function onClickCancelDialog()
{
	GetPopupExpandScript().Hide();
}

function onClickTeleport()
{
	class'TeleportListAPI'.static.RequestTeleport(currentTeleportID);
	GetPopupExpandScript().Hide();
	GetWindowHandle(m_WindowName).HideWindow();
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);

	if(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset").IsShowWindow())
	{
		GetPopupExpandScript().Hide();		
	}
	else
	{
		GetWindowHandle(m_WindowName).HideWindow();
	}
}

defaultproperties
{
     m_WindowName="SuppressWnd"
}
