class DethroneTab03_OccupyStatus extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var ButtonHandle Help_btn;
var RichListCtrlHandle Tab_RichList;
var TextureHandle ListBg_tex;
var ButtonHandle ReFresh_btn;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var UIControlGroupButtonAssets UIControlGroupButtonAsset;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO);
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
	Help_btn = GetButtonHandle(m_WindowName $ ".Help_btn");
	Tab_RichList = GetRichListCtrlHandle(m_WindowName $ ".Tab_RichList");
	ListBg_tex = GetTextureHandle(m_WindowName $ ".ListBg_tex");
	ReFresh_btn = GetButtonHandle(m_WindowName $ ".Refresh_btn");
	DisableWndList = GetWindowHandle(m_WindowName $ ".DisableWndList");
	List_Empty = GetTextBoxHandle(m_WindowName $ ".DisableWndList.List_Empty");
	Tab_RichList.SetTooltipType("SimpleRichListTooltip");
	Tab_RichList.SetSelectedSelTooltip(false);
	Tab_RichList.SetAppearTooltipAtMouseX(true);
}

function Load()
{
	initGroupButton();
}

function initGroupButton()
{
	UIControlGroupButtonAsset = class'UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle(m_WindowName $ ".UIControlGroupButtonAsset"));
	UIControlGroupButtonAsset._SetStartInfo("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", true);
	UIControlGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButton;
	UIControlGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(13756));
	UIControlGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(1622));
	UIControlGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(2);
	UIControlGroupButtonAsset._GetGroupButtonsInstance()._setAutoWidth(300, 4);
	UIControlGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0, true);	
}

function DelegateOnClickButton(string parentWndName, string strName, int Index)
{
	Debug("-----메인 탭-------");
	Debug("strName" @ parentWndName);
	Debug("strName" @ strName);
	Debug("index" @ string(Index));
	OnReFresh_btnClick();	
}

event OnShow()
{
	Debug("Onshow " @ m_WindowName);
	if(GetWindowHandle("DethroneWnd").IsShowWindow())
	{
		OnRefresh_btnClick();
		Debug("어떤 버튼이 눌러져 있나?" @ string(UIControlGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex()));
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Help_btn":
			OnHelp_btnClick();
			break;
		case "Refresh_btn":
			OnRefresh_btnClick();
			break;
	}
}

function OnHelp_btnClick()
{
	//class'HelpWnd'.static.ShowHelp(63, 4);
}

function OnRefresh_btnClick()
{
	API_C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO();
	DethroneWnd(GetScript("DethroneWnd")).setDisableWnd();
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x12
		case EV_GameStart:
			// End:0x35
			break;
		// End:0x32
		case EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO):
			ParsePacket_S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO();
			// End:0x35
			break;
	}
}

function ParsePacket_S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO()
{
	local UIPacket._S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO packet;
	local int i, M;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO : " @ string(packet.occupationInfoList.Length));
	Debug("cCategory: " @ string(packet.cCategory));
	Tab_RichList.DeleteAllItem();

	// End:0x178 [Loop If]
	for(i = 0; i < packet.occupationInfoList.Length; i++)
	{
		AddTitleListItem(true, GetDethroneDistrictName(packet.occupationInfoList[i].nDistrictID), packet.cCategory);
		AddTitleListItem(false, getServerNameByWorldID(packet.occupationInfoList[i].nOccupyingWorldID), packet.cCategory);

		for(M = 0; M < packet.occupationInfoList[i].pointInfoList.Length; M++)
		{
			AddOccupationStateListItem(packet.occupationInfoList[i].pointInfoList[M].nRank, packet.occupationInfoList[i].pointInfoList[M].nWorldID, packet.occupationInfoList[i].pointInfoList[M].nPoint);
		}
	}
	Tab_RichList.SetFocus();
}

function AddTitleListItem(bool bTitle, string Str, int cCategory)
{
	local Color applyColor;
	local RichListCtrlRowData RowData;

	RowData.cellDataList.Length = 1;
	// End:0x87
	if(bTitle)
	{
		if(cCategory == 0)
		{
			RowData.sOverlayTex = "L2UI_EPIC.DethroneWnd.List_HeaderBg_Blue";			
		}
		else
		{
			RowData.sOverlayTex = "L2UI_EPIC.DethroneWnd.List_HeaderBg_Red";
		}
		RowData.sOverlayTex = "L2UI_EPIC.DethroneWnd.List_HeaderBg_Blue";
		applyColor = GTColor().BrightWhite;
		addRichListCtrlString(RowData.cellDataList[0].drawitems, Str, applyColor, false, 0, 0);		
	}
	else
	{
		RowData.sOverlayTex = "L2UI_EPIC.DethroneWnd.List_HeaderBg_Brown";
		applyColor = GTColor().WhiteSmoke;
		addRichListCtrlString(RowData.cellDataList[0].drawitems, GetSystemString(13787) $ " : ", GTColor().Gold, false, 0, 0);
		addRichListCtrlString(RowData.cellDataList[0].drawitems, Str, applyColor, false, 0, 0);
	}
	RowData.OverlayTexU = 635;
	RowData.OverlayTexV = 32;
	Tab_RichList.InsertRecord(RowData);
}

function AddOccupationStateListItem(int nServerNo, int ServerID, INT64 areaPoint)
{
	local RichListCtrlRowData RowData;
	local Color applyColor;
	local bool bMe;
	local string rankStr;
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
	rankStr = string(nServerNo);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, rankStr, applyColor, false, 0, 10);
	class'UIDataManager'.static.GetServerInfo(ServerID, ServerInfo);
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, GetServerMarkNameSmall(ServerID), 30, 30, 100, -8);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, ServerInfo.ServerName, applyColor, false, 0, 8);
	addRichListCtrlButton(RowData.cellDataList[1].drawitems, "ReceipBtn", 0, 0, "L2UI_EPIC.DethroneWnd.DethroneZonePointIcon", "L2UI_EPIC.DethroneWnd.DethroneZonePointIcon", "L2UI_EPIC.DethroneWnd.DethroneZonePointIcon", 20, 21, 20, 21, 1, GetSystemString(13740));
	addRichListCtrlString(RowData.cellDataList[1].drawitems, MakeCostString(string(areaPoint)), applyColor, false, 26, 5);
	RowData.cellDataList[0].szData = rankStr;
	RowData.cellDataList[1].szData = string(areaPoint);
	Tab_RichList.InsertRecord(RowData);
}

function API_C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO packet;

	packet.cCategory = UIControlGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex();
	// End:0x44
	if(! class'UIPacket'.static.Encode_C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO, stream);
	Debug("----> Api Call : C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO " @ string(UIControlGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex()));
}

defaultproperties
{
}
