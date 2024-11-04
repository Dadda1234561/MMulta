class DethroneTab02_ServerStatus extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var WindowHandle DethronePointStatus_wnd;
var TextBoxHandle PointStatusTitle_text;
var RichListCtrlHandle Tab01_RichList;
var RichListCtrlHandle Tab02_RichList;
var ButtonHandle connectDethroneToggle_btn;
var TextureHandle DisableDialog_tex;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var UserInfo myInfo;
var bool bAdenCastleOwner;
var bool bConnectingDethrone;

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_SERVER_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_CONNECT_CASTLE);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_DISCONNECT_CASTLE);
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
	DethronePointStatus_wnd = GetWindowHandle(m_WindowName $ ".DethronePointStatus_wnd");
	PointStatusTitle_text = GetTextBoxHandle(m_WindowName $ ".DethronePointStatus_wnd.PointStatusTitle_text");
	Tab01_RichList = GetRichListCtrlHandle(m_WindowName $ ".DethronePointStatus_wnd.Tab01_RichList");
	Tab02_RichList = GetRichListCtrlHandle(m_WindowName $ ".DethroneAdenaStatus_wnd.Tab02_RichList");
	connectDethroneToggle_btn = GetButtonHandle(m_WindowName $ ".DethroneAdenaStatus_wnd.connectDethroneToggle_btn");
	DisableDialog_tex = GetTextureHandle(m_WindowName $ ".DisableDialog_tex");
	DisableWndList = GetWindowHandle(m_WindowName $ ".DisableWndList");
	List_Empty = GetTextBoxHandle(m_WindowName $ ".DisableWndList.List_Empty");
	connectDethroneToggle_btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13915), 250));
}

function Load()
{}

event OnShow()
{
	Debug("- Onshow " @ m_WindowName);
	// End:0x49
	if(GetWindowHandle("DethroneWnd").IsShowWindow())
	{
		GetPlayerInfo(myInfo);
		API_C_EX_DETHRONE_SERVER_INFO();
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x9F
		case "connectDethroneToggle_btn":
			// End:0x81
			if(bAdenCastleOwner)
			{
				// End:0x5C
				if(bConnectingDethrone)
				{
					DethroneWnd(GetScript("DethroneWnd")).AskDialogDethronedisConnect();					
				}
				else
				{
					DethroneWnd(GetScript("DethroneWnd")).AskDialogDethroneConnect();
				}				
			}
			else
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13431));
			}
			// End:0xEA
			break;
		// End:0xC3
		case "Help1_btn":
			//class'HelpWnd'.static.ShowHelp(63, 2);
			// End:0xEA
			break;
		// End:0xE7
		case "Help2_btn":
			//class'HelpWnd'.static.ShowHelp(63, 3);
			// End:0xEA
			break;
	}
}

function OnEvent(int Event_ID, string param)
{
	local int customPacketId;
	local int nTargetId;
	local int nGearScore;
	
	switch(Event_ID)
	{
		case EV_GameStart:
			bAdenCastleOwner = false;
			connectDethroneToggle_btn.SetButtonName(13749);
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_SERVER_INFO):
			//ParsePacket_S_EX_DETHRONE_SERVER_INFO();
			// CUSTOM PACKET's support
			if(! class'UIPacket'.static.DecodeChar(customPacketId))
			{
				return;
			}
			if (!class'UIPacket'.static.DecodeInt(nTargetId))
			{
				return;
			}
			if (!class'UIPacket'.static.DecodeInt(nGearScore))
			{
				return;
			}

			ParamAdd(param, "nTargetId", string(nTargetId));
			ParamAdd(param, "nGearScore", string(nGearScore));

			ExecuteEvent(EV_CustomPacketID(customPacketId), param);
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_CONNECT_CASTLE):
			ParsePacket_S_EX_DETHRONE_CONNECT_CASTLE();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_DISCONNECT_CASTLE):
			ParsePacket_S_EX_DETHRONE_DISCONNECT_CASTLE();
			break;
	}
}

function ParsePacket_S_EX_DETHRONE_CONNECT_CASTLE()
{
	local UIPacket._S_EX_DETHRONE_CONNECT_CASTLE packet;

	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_CONNECT_CASTLE(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_DETHRONE_CONNECT_CASTLE :  " @ string(packet.nResult));
	API_C_EX_DETHRONE_SERVER_INFO();
	if(packet.nResult > 0)
	{
		AddSystemMessage(13429);		
	}
	else if(packet.nResult == 0)
	{
		AddSystemMessage(4334);			
	}
	else if(packet.nResult == -1)
	{
		AddSystemMessage(13431);				
	}
	else if(packet.nResult == -2)
	{
		AddSystemMessage(13052);
	}
}

function ParsePacket_S_EX_DETHRONE_DISCONNECT_CASTLE()
{
	local UIPacket._S_EX_DETHRONE_DISCONNECT_CASTLE packet;

	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_DISCONNECT_CASTLE(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_DETHRONE_DISCONNECT_CASTLE :  " @ string(packet.nResult));
	API_C_EX_DETHRONE_SERVER_INFO();
	if(packet.nResult > 0)
	{
		AddSystemMessage(13430);		
	}
	else if(packet.nResult == 0)
	{
			AddSystemMessage(4334);			
	}
	else if(packet.nResult == -1)
	{
		AddSystemMessage(13431);				
	}
	else if(packet.nResult == -2)
	{
		AddSystemMessage(13052);
	}
}

delegate int SortPointInfoListDelegate(UIPacket._PkDethronePointInfo a1, UIPacket._PkDethronePointInfo a2)
{
	if(a1.nRank > a2.nRank)
	{
		return -1;
	}
	return 0;
}

delegate int SortSoulBeadInfoListDelegate(UIPacket._PkDethroneSoulBeadInfo a1, UIPacket._PkDethroneSoulBeadInfo a2)
{
	local ServerInfoUIData serverInfo1, serverInfo2;

	if(a1.nRank > a2.nRank)
	{
		return -1;
	}
	if(a1.nRank == a2.nRank)
	{
		class'UIDataManager'.static.GetServerInfo(a1.nWorldID, serverInfo1);
		class'UIDataManager'.static.GetServerInfo(a2.nWorldID, serverInfo2);
		if(serverInfo1.ServerName > serverInfo2.ServerName)
		{
			return -1;
		}		
	}
	else
	{
		return 0;
	}
}

// function ParsePacket_S_EX_DETHRONE_SERVER_INFO()
// {
// 	local int i, N;
// 	local UIPacket._S_EX_DETHRONE_SERVER_INFO packet;
// 	local bool bConnect;

// 	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_SERVER_INFO(packet))
// 	{
// 		return;
// 	}
// 	Debug(" -->  Decode__S_EX_DETHRONE_SERVER_INFO :  " @ string(packet.pointInfoList.Length) @ string(packet.soulBeadInfoList.Length) @ string(packet.connectionList.Length) @ string(packet.bAdenCastleOwner) @ string(packet.nDethroneWorldID));
// 	Tab01_RichList.DeleteAllItem();
// 	packet.pointInfoList.Sort(SortPointInfoListDelegate);
// 	packet.soulBeadInfoList.Sort(SortSoulBeadInfoListDelegate);

// 	for(i = 0; i < packet.pointInfoList.Length; i++)
// 	{
// 		AddDethronePointStateListItem(packet.pointInfoList[i].nRank, packet.pointInfoList[i].nWorldID, packet.pointInfoList[i].nPoint);
// 	}
// 	bConnectingDethrone = false;
// 	Tab02_RichList.DeleteAllItem();

// 	for(i = 0; i < packet.soulBeadInfoList.Length; i++)
// 	{
// 		Debug((("packet.connectionList[i]" @ string(i)) @ string(packet.connectionList[i])) @ string(packet.soulBeadInfoList[i].nWorldID));
// 		bConnect = false;

// 		for(N = 0; N < packet.connectionList.Length; N++)
// 		{
// 			if(packet.connectionList[N] == packet.soulBeadInfoList[i].nWorldID)
// 			{
// 				if(packet.bAdenCastleOwner > 0 && packet.soulBeadInfoList[i].nWorldID == myInfo.nWorldID)
// 				{
// 					bConnectingDethrone = true;
// 				}
// 				bConnect = true;
// 				// [Explicit Break]
// 				break;
// 			}
// 		}
// 		AddSoulMarbleStateListItem(packet.soulBeadInfoList[i].nRank, packet.soulBeadInfoList[i].nWorldID, bConnect, packet.soulBeadInfoList[i].nSoulBead, packet.nDethroneWorldID);
// 	}
// 	bAdenCastleOwner = numToBool(packet.bAdenCastleOwner);
// 	if(bAdenCastleOwner && ! class'UIDATA_PLAYER'.static.IsInDethrone())
// 	{
// 		connectDethroneToggle_btn.EnableWindow();		
// 	}
// 	else
// 	{
// 		connectDethroneToggle_btn.DisableWindow();
// 	}
// 	if(bConnectingDethrone)
// 	{
// 		connectDethroneToggle_btn.SetButtonName(13769);		
// 	}
// 	else
// 	{
// 		connectDethroneToggle_btn.SetButtonName(13749);
// 	}
// }

function AddDethronePointStateListItem(int nRanking, int ServerID, INT64 dethronePoint)
{
	local RichListCtrlRowData RowData;
	local Color applyColor;
	local bool bMe;
	local string rankStr;
	local ServerInfoUIData ServerInfo;

	RowData.cellDataList.Length = 3;
	bMe = isMyServer(ServerID);
	if(bMe)
	{
		applyColor = GTColor().Yellow;		
	}
	else
	{
		applyColor = GTColor().White;
	}
	rankStr = string(nRanking);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, rankStr, applyColor, false, 0, 0);
	class'UIDataManager'.static.GetServerInfo(ServerID, ServerInfo);
	addRichListCtrlTexture(RowData.cellDataList[1].drawitems, GetServerMarkNameSmall(ServerID), 30, 30);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, ServerInfo.ServerName, applyColor, false, 0, 8);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, MakeCostString(string(dethronePoint)), applyColor, false, 5, 0);
	RowData.cellDataList[0].szData = rankStr;
	RowData.cellDataList[1].szData = ServerInfo.ServerName;
	RowData.cellDataList[2].szData = string(dethronePoint);
	Tab01_RichList.InsertRecord(RowData);
}

function AddSoulMarbleStateListItem(int nRanking, int ServerID, bool bConnect, INT64 dethronePoint, int nDethroneWorldID)
{
	local RichListCtrlRowData RowData;
	local Color applyColor;
	local bool bMe;
	local string rankStr;
	local ServerInfoUIData ServerInfo;

	RowData.cellDataList.Length = 4;
	bMe = isMyServer(ServerID);
	if(bMe)
	{
		applyColor = GTColor().Yellow;		
	}
	else
	{
		applyColor = GTColor().White;
	}
	rankStr = string(nRanking);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, rankStr, applyColor, false, 0, 0);
	class'UIDataManager'.static.GetServerInfo(ServerID, ServerInfo);
	addRichListCtrlTexture(RowData.cellDataList[1].drawitems, GetServerMarkNameSmall(ServerID), 30, 30);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, ServerInfo.ServerName, applyColor, false, 0, 8);
	// End:0x122
	if(ServerID == nDethroneWorldID)
	{
		addRichListCtrlString(RowData.cellDataList[2].drawitems, "-", applyColor);		
	}
	else
	{
		if(bConnect)
		{
			addRichListCtrlTexture(RowData.cellDataList[2].drawitems, "L2UI_CT1.OlympiadWnd.ONICON", 40, 15);			
		}
		else
		{
			addRichListCtrlTexture(RowData.cellDataList[2].drawitems, "L2UI_CT1.OlympiadWnd.OFFICON", 40, 15);
		}
	}
	addRichListCtrlString(RowData.cellDataList[3].drawitems, MakeCostStringINT64(dethronePoint), applyColor, false, 5, 0);
	RowData.cellDataList[0].szData = rankStr;
	RowData.cellDataList[1].szData = ServerInfo.ServerName;
	RowData.cellDataList[2].szData = string(bConnect);
	RowData.cellDataList[3].szData = string(dethronePoint);
	Tab02_RichList.InsertRecord(RowData);
}

function API_C_EX_DETHRONE_SERVER_INFO()
{
	local array<byte> stream;

	//class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_SERVER_INFO, stream);
	Debug("----> Api Call : C_EX_DETHRONE_SERVER_INFO ");
}

function API_C_EX_DETHRONE_CONNECT_CASTLE()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_CONNECT_CASTLE, stream);
	Debug("----> Api Call : C_EX_DETHRONE_CONNECT_CASTLE ");
}

function API_C_EX_DETHRONE_DISCONNECT_CASTLE()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_DISCONNECT_CASTLE, stream);
	Debug("----> Api Call : C_EX_DETHRONE_DISCONNECT_CASTLE ");
}

defaultproperties
{
}
