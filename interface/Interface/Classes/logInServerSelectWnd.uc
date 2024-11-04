class logInServerSelectWnd extends UICommonAPI;

const MAX_SERVER_LIST = 100;
const DIALOG_PolicyCheck = 12500;

struct ServerData
{
	var int Priority;
	var int buttonIndex;
	var int newServerButtonIndex;
	var int Id;
	var string Name;
	var string State;
	var Color stateColor;
	var int charCnt;
	var int AgeLimit;
	var int IsRelaxServer;
	var int IsTestServer;
	var int IsBroadServer;
	var int IsCreateRestrictServer;
	var int IsEventServer;
	var int IsFreeServer;
	var int IsNewServer;
	var int IsForbiddenServer;
	var int IsWorldRaidServer;
	var int IsClassicServer;
	var int IsArenaServer;
	var int IsBloodyServer;
	var int IsAdenServer;
	var int IsPVPServer;
	var string AgeLimitTexName;
};

var WindowHandle Me;
var WindowHandle List_ScrollArea;
var WindowHandle ServerListWnd;
var TabHandle Server_1Tab;
var TabHandle Server_2Tab;
var TabHandle Server_3Tab;
var array<ServerData> serverData_Array;
var int currentSelectedServerDataArrayIndex;
var int nAdenServerCount;
var int nTalkingIslandServerCount;
var int nLiveServerCount;
var int currentNewServerCount;
var string tabButtonText1;
var string tabButtonText2;
var string tabButtonText3;
var TextureHandle LobbyCopyright;
var string JpPolicyString;

function OnRegisterEvent()
{
	RegisterEvent(EV_ServerListStart);
	RegisterEvent(EV_ServerList);
	RegisterEvent(EV_ServerListEnd);
	RegisterEvent(EV_DialogOK);
}

event OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	local string mainKey;

	mainKey = class'InputAPI'.static.GetKeyString(nKey);
	Debug("MainKey" @ mainKey);

	if(nKey == IK_Enter)
	{
		if(currentSelectedServerDataArrayIndex > -1)
		{
			connectServer(currentSelectedServerDataArrayIndex);
		}		
	}
	else if(nKey == IK_Escape)
	{
		if(ServerListWnd.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			OnClose_BtnClick();
		}
		else
		{
			OnserverSelect_BTNClick();
		}
	}
}

function OnLoad()
{
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle("logInServerSelectWnd");
	ServerListWnd = GetWindowHandle("logInServerSelectWnd.ServerListWnd");
	List_ScrollArea = GetWindowHandle("logInServerSelectWnd.ServerListWnd.List_Wnd.List_ScrollArea");
	Server_1Tab = GetTabHandle("logInServerSelectWnd.ServerListWnd.Server_1Tab");
	Server_2Tab = GetTabHandle("logInServerSelectWnd.ServerListWnd.Server_2Tab");
	Server_3Tab = GetTabHandle("logInServerSelectWnd.ServerListWnd.Server_3Tab");
	LobbyCopyright = GetTextureHandle("logInServerSelectWnd.LobbyCopyright_tex");
	LobbyCopyright.HideWindow();
	JpPolicyString = "";
}

function OnLButtonDown(WindowHandle btnHandle, int X, int Y)
{
	local int buttonIndex, numCount, arrayIndex;

	if(Left(btnHandle.GetParentWindowName(), Len("ServerSelectAsset")) == "ServerSelectAsset")
	{
		numCount = Len(btnHandle.GetParentWindowName()) - Len("ServerSelectAsset");
		buttonIndex = int(Right(btnHandle.GetParentWindowName(), numCount));
		arrayIndex = getServerDataIndexByButtonIndex(buttonIndex);

		if(arrayIndex > -1)
		{
			Debug(serverData_Array[arrayIndex].Name @ string(serverData_Array[arrayIndex].Id));
			currentSelectedServerDataArrayIndex = arrayIndex;
			setConnectServerInfo();
			OnClose_BtnClick();
		}
	}
	else if(Left(btnHandle.GetParentWindowName(), Len("NewBTN0")) == "NewBTN0")
	{
		buttonIndex = int(Right(btnHandle.GetParentWindowName(), 1));
		arrayIndex = getServerDataIndexByNewServerButtonIndex(buttonIndex);

		if(arrayIndex > -1)
		{
			currentSelectedServerDataArrayIndex = arrayIndex;
			setConnectServerInfo();
			OnClose_BtnClick();
		}
	}
}

function setConnectServerInfo()
{
	GetTextBoxHandle("logInServerSelectWnd.LastServerNAME_txt").SetAlpha(50);
	GetTextBoxHandle("logInServerSelectWnd.LastServerNAME_txt").SetText(serverData_Array[currentSelectedServerDataArrayIndex].Name);
	GetTextBoxHandle("logInServerSelectWnd.LastServerType_txt").SetText(getCurrentSelectedServerTypeString());
	GetTextBoxHandle("logInServerSelectWnd.LastServerCondition_txt").SetText(serverData_Array[currentSelectedServerDataArrayIndex].State);

	if(serverData_Array[currentSelectedServerDataArrayIndex].State == GetSystemString(456))
	{
		GetTextBoxHandle("logInServerSelectWnd.LastServerCondition_txt").SetTextColor(GetColor(85, 85, 85, 255));		
	}
	else
	{
		GetTextBoxHandle("logInServerSelectWnd.LastServerCondition_txt").SetTextColor(serverData_Array[currentSelectedServerDataArrayIndex].stateColor);
	}
	GetTextBoxHandle("logInServerSelectWnd.LastServerNAME_txt").SetAlpha(255, 0.40f);
}

function string getCurrentSelectedServerTypeString()
{
	local string rStr;

	if(serverData_Array[currentSelectedServerDataArrayIndex].IsClassicServer == 1)
	{
		rStr = GetSystemString(13036);
	}
	else
	{
		rStr = GetSystemString(13037);
	}
	return rStr;
}

function OnClickButton(string Name)
{
	Debug("Name" @ Name);

	switch(Name)
	{
		case "serverSelect_BTN":
			OnserverSelect_BTNClick();
			break;
		case "Close_btn":
			OnClose_BtnClick();
			break;
		case "ServerSelectOK_btn":
			if(GetLanguage() == LANG_Japanese)
			{
				JpPolicyString = JapanPolicyCheck();

				if(Len(JpPolicyString) > 0)
				{
					DialogSetID(DIALOG_PolicyCheck);
					DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage(6890), string(self));
				}
				else
				{
					connectServer(currentSelectedServerDataArrayIndex);
				}
			}
			else
			{
				connectServer(currentSelectedServerDataArrayIndex);
			}
			break;
		case "ServerSelectCancel_btn":
			GotoLogin();
			break;
		case "Server_1Tab0":
			initServerList();
			selectshowServerList(tabButtonText1);
			break;
		case "Server_2Tab0":
			initServerList();
			selectshowServerList(tabButtonText1);
			break;
		case "Server_2Tab1":
			initServerList();
			selectshowServerList(tabButtonText2);
			break;
		case "Server_3Tab0":
			initServerList();
			selectshowServerList(tabButtonText1);
			break;
		case "Server_3Tab1":
			initServerList();
			selectshowServerList(tabButtonText2);
			break;
		case "Server_3Tab2":
			initServerList();
			selectshowServerList(tabButtonText3);
			break;
	}
}

function selectshowServerList(string tabButtonText)
{
	if(tabButtonText == GetSystemString(888))
	{
		showServerList(1, 1, false);
	}
	else if(tabButtonText == GetSystemString(3924))
	{
		showServerList(1, 0, false);
	}
	else if(tabButtonText == GetSystemString(3923))
	{
		showServerList(0, 0, false);
	}
	else if(tabButtonText == GetSystemString(2731))
	{
		showServerList(0, 0, false, true);
	}
	else if(tabButtonText == GetSystemString(13036))
	{
		showServerList(1, 0, true, false);
	}
	else if(tabButtonText == GetSystemString(13037))
	{
		showServerList(0, 0, false, false);
	}
}

function SetCurrentSelectedServerTab()
{
	if(Server_1Tab.IsShowWindow())
	{
		Server_1Tab.SetTopOrder(0, false);
		OnClickButton("Server_1Tab0");
	}
	else if(Server_2Tab.IsShowWindow())
	{
		if(isKr())
		{
			if(serverData_Array[currentSelectedServerDataArrayIndex].IsClassicServer == 1)
			{
				Server_2Tab.SetTopOrder(0, false);
				OnClickButton("Server_2Tab0");
			}
			else
			{
				Server_2Tab.SetTopOrder(1, false);
				OnClickButton("Server_2Tab1");
			}
		}
		else
		{
			if(nAdenServerCount == 0 && nTalkingIslandServerCount > 0 && nLiveServerCount > 0)
			{
				if(serverData_Array[currentSelectedServerDataArrayIndex].IsClassicServer == 0)
				{
					Server_2Tab.SetTopOrder(0, false);
					OnClickButton("Server_2Tab0");
				}
				else
				{
					Server_2Tab.SetTopOrder(1, false);
					OnClickButton("Server_2Tab1");
				}
			}
			else if(nAdenServerCount > 0 && nTalkingIslandServerCount == 0 && nLiveServerCount > 0)
			{
				if(serverData_Array[currentSelectedServerDataArrayIndex].IsAdenServer == 1)
				{
					Server_2Tab.SetTopOrder(0, false);
					OnClickButton("Server_2Tab0");
				}
				else
				{
					Server_2Tab.SetTopOrder(1, false);
					OnClickButton("Server_2Tab1");
				}
			}
			else if(nAdenServerCount > 0 && nTalkingIslandServerCount > 0 && nLiveServerCount == 0)
			{
				if(serverData_Array[currentSelectedServerDataArrayIndex].IsAdenServer == 1)
				{
					Server_2Tab.SetTopOrder(0, false);
					OnClickButton("Server_2Tab0");
				}
				else
				{
					Server_2Tab.SetTopOrder(1, false);
					OnClickButton("Server_2Tab1");
				}
			}
		}
	}
	else if(Server_3Tab.IsShowWindow())
	{
		if(serverData_Array[currentSelectedServerDataArrayIndex].IsAdenServer == 1)
		{
			Server_3Tab.SetTopOrder(0, false);
			OnClickButton("Server_3Tab0");
		}
		else if(serverData_Array[currentSelectedServerDataArrayIndex].IsClassicServer == 0)
		{
			Server_3Tab.SetTopOrder(1, false);
			OnClickButton("Server_3Tab1");
		}
		else if(serverData_Array[currentSelectedServerDataArrayIndex].IsClassicServer == 1 && serverData_Array[currentSelectedServerDataArrayIndex].IsAdenServer == 0)
		{
			Server_3Tab.SetTopOrder(2, false);
			OnClickButton("Server_3Tab2");
		}
	}
}

function OnserverSelect_BTNClick()
{
	if(ServerListWnd.IsShowWindow())
	{
		OnClose_BtnClick();
	}
	else
	{
		GetButtonHandle("logInServerSelectWnd.ServerSelectOK_btn").HideWindow();
		GetButtonHandle("logInServerSelectWnd.ServerSelectCancel_btn").HideWindow();
		ServerListWnd.ShowWindow();
		SetCurrentSelectedServerTab();
		ServerListWnd.SetFocus();
	}
}

function OnClose_BtnClick()
{
	ServerListWnd.HideWindow();
	GetButtonHandle("logInServerSelectWnd.ServerSelectOK_btn").ShowWindow();
	GetButtonHandle("logInServerSelectWnd.ServerSelectCancel_btn").ShowWindow();
}

function OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		case EV_ServerListStart:
			ServerListStart(a_Param);
			break;
		case EV_ServerList:
			handleServerList(a_Param);
			break;
		case EV_ServerListEnd:
			ServerListEnd(a_Param);
			break;
		case EV_DialogOK:
			if(DialogIsMine() && DialogGetID() == DIALOG_PolicyCheck)
			{
				OpenWebSite(JpPolicyString);
				ExecQuit();
			}
			break;
	}
}

function ServerListStart(string a_Param)
{
	OnClose_BtnClick();
	currentSelectedServerDataArrayIndex = -1;
	currentNewServerCount = 0;
	nAdenServerCount = 0;
	nTalkingIslandServerCount = 0;
	nLiveServerCount = 0;
	serverData_Array.Remove(0, serverData_Array.Length);
}

function handleServerList(string a_Param)
{
	local int IsWorldRaidServer, R, G, B, ExtID;

	local string Name;

	Debug("handleServerList : " @ a_Param);
	ParseInt(a_Param, "IsWorldRaidServer", IsWorldRaidServer);

	if(IsWorldRaidServer == 1)
	{
		return;
	}
	serverData_Array.Insert(serverData_Array.Length, 1);
	ParseInt(a_Param, "ID", serverData_Array[serverData_Array.Length - 1].Id);
	ParseInt(a_Param, "ExtID", ExtID);

	if(ExtID != 0)
	{
		ParseString(a_Param, "Name", Name);
		serverData_Array[serverData_Array.Length - 1].Name = "[" $ getInstanceUIData().Int2Str(ExtID) $ "]" @ Name;
	}
	else
	{
		ParseString(a_Param, "Name", serverData_Array[serverData_Array.Length - 1].Name);
	}
	ParseString(a_Param, "State", serverData_Array[serverData_Array.Length - 1].State);
	ParseInt(a_Param, "StateColorR", R);
	ParseInt(a_Param, "StateColorG", G);
	ParseInt(a_Param, "StateColorB", B);
	serverData_Array[serverData_Array.Length - 1].stateColor.R = R;
	serverData_Array[serverData_Array.Length - 1].stateColor.G = G;
	serverData_Array[serverData_Array.Length - 1].stateColor.B = B;
	serverData_Array[serverData_Array.Length - 1].stateColor.A = 255;
	ParseInt(a_Param, "CharCnt", serverData_Array[serverData_Array.Length - 1].charCnt);
	ParseInt(a_Param, "AgeLimit", serverData_Array[serverData_Array.Length - 1].AgeLimit);
	ParseInt(a_Param, "IsRelaxServer", serverData_Array[serverData_Array.Length - 1].IsRelaxServer);
	ParseInt(a_Param, "IsTestServer", serverData_Array[serverData_Array.Length - 1].IsTestServer);
	ParseInt(a_Param, "IsBroadServer", serverData_Array[serverData_Array.Length - 1].IsBloodyServer);
	ParseInt(a_Param, "IsCreateRestrictServer", serverData_Array[serverData_Array.Length - 1].IsCreateRestrictServer);
	ParseInt(a_Param, "IsEventServer", serverData_Array[serverData_Array.Length - 1].IsEventServer);
	ParseInt(a_Param, "IsFreeServer", serverData_Array[serverData_Array.Length - 1].IsFreeServer);
	ParseInt(a_Param, "IsNewServer", serverData_Array[serverData_Array.Length - 1].IsNewServer);
	ParseInt(a_Param, "IsForbiddenServer", serverData_Array[serverData_Array.Length - 1].IsForbiddenServer);
	ParseInt(a_Param, "IsWorldRaidServer", serverData_Array[serverData_Array.Length - 1].IsWorldRaidServer);
	ParseInt(a_Param, "IsClassicServer", serverData_Array[serverData_Array.Length - 1].IsClassicServer);
	ParseInt(a_Param, "IsArenaServer", serverData_Array[serverData_Array.Length - 1].IsArenaServer);
	ParseInt(a_Param, "IsBloodyServer", serverData_Array[serverData_Array.Length - 1].IsBloodyServer);
	ParseInt(a_Param, "IsAdenServer", serverData_Array[serverData_Array.Length - 1].IsAdenServer);
	ParseInt(a_Param, "IsPVPServer", serverData_Array[serverData_Array.Length - 1].IsPVPServer);
	ParseInt(a_Param, "Priority", serverData_Array[serverData_Array.Length - 1].Priority);
	ParseString(a_Param, "AgeLimitTexName", serverData_Array[serverData_Array.Length - 1].AgeLimitTexName);

	if(serverData_Array[serverData_Array.Length - 1].IsAdenServer == 1)
	{
		nAdenServerCount++;
	}
	if(serverData_Array[serverData_Array.Length - 1].IsClassicServer == 1 && serverData_Array[serverData_Array.Length - 1].IsAdenServer == 0)
	{
		nTalkingIslandServerCount++;
	}
	if(serverData_Array[serverData_Array.Length - 1].IsClassicServer == 0)
	{
		nLiveServerCount++;
	}
	serverData_Array[serverData_Array.Length - 1].buttonIndex = -1;
	serverData_Array[serverData_Array.Length - 1].newServerButtonIndex = -1;

	if(serverData_Array[serverData_Array.Length - 1].IsNewServer == 1)
	{
		currentNewServerCount++;
		setNewServerBtn(currentNewServerCount, serverData_Array.Length - 1);
		serverData_Array[serverData_Array.Length - 1].newServerButtonIndex = currentNewServerCount;
	}
	if(serverData_Array.Length - 1 == 0)
	{
		if(GetReleaseMode() != RM_DEV)
		{
			serverData_Array[serverData_Array.Length - 1].Priority = 1;
		}
		currentSelectedServerDataArrayIndex = 0;
		setConnectServerInfo();
	}
}

function ServerListEnd(string a_Param)
{
	Debug("ServerListEnd " @ a_Param);
	setNewServerGroupWindowResize(currentNewServerCount);
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop("logInServerSelectWnd", true);
	serverData_Array.Sort(OnSortServerList);
	setTabShowState();
	Me.ShowWindow();
	Me.SetFocus();
}

function setTabShowState()
{
	Debug("nAdenServerCount" @ string(nAdenServerCount));
	Debug("nTalkingIslandServerCount" @ string(nTalkingIslandServerCount));
	Debug("nLiveServerCount" @ string(nLiveServerCount));

	if(isKr() && GetReleaseMode() == RM_TEST)
	{
		Server_1Tab.ShowWindow();
		Server_2Tab.HideWindow();
		Server_3Tab.HideWindow();
		tabButtonText1 = GetSystemString(2731);
		Server_1Tab.SetButtonName(0, tabButtonText1);
	}
	else if(isKr())
	{
		Server_1Tab.HideWindow();
		Server_2Tab.ShowWindow();
		Server_3Tab.HideWindow();
		tabButtonText1 = GetSystemString(13036);
		tabButtonText2 = GetSystemString(13037);
		Server_2Tab.SetButtonName(0, tabButtonText1);
		Server_2Tab.SetButtonName(1, tabButtonText2);
	}
	else
	{
		Server_1Tab.HideWindow();
		Server_2Tab.HideWindow();
		Server_3Tab.HideWindow();

		if(nAdenServerCount > 0 && nTalkingIslandServerCount == 0 && nLiveServerCount == 0)
		{
			Server_1Tab.ShowWindow();
			tabButtonText1 = GetSystemString(888);
			Server_1Tab.SetButtonName(0, tabButtonText1);
		}
		else if(nAdenServerCount == 0 && nTalkingIslandServerCount > 0 && nLiveServerCount == 0)
		{
			Server_1Tab.ShowWindow();
			tabButtonText1 = GetSystemString(3924);
			Server_1Tab.SetButtonName(0, tabButtonText1);
		}
		else if(nAdenServerCount == 0 && nTalkingIslandServerCount == 0 && nLiveServerCount > 0)
		{
			Server_1Tab.ShowWindow();
			tabButtonText1 = GetSystemString(3923);
			Server_1Tab.SetButtonName(0, tabButtonText1);
		}
		else if(nAdenServerCount == 0 && nTalkingIslandServerCount > 0 && nLiveServerCount > 0)
		{
			Server_2Tab.ShowWindow();
			tabButtonText1 = GetSystemString(3923);
			tabButtonText2 = GetSystemString(3924);
			Server_2Tab.SetButtonName(0, tabButtonText1);
			Server_2Tab.SetButtonName(1, tabButtonText2);
		}
		else if(nAdenServerCount > 0 && nTalkingIslandServerCount == 0 && nLiveServerCount > 0)
		{
			Server_2Tab.ShowWindow();
			tabButtonText1 = GetSystemString(888);
			tabButtonText2 = GetSystemString(3923);
			Server_2Tab.SetButtonName(0, tabButtonText1);
			Server_2Tab.SetButtonName(1, tabButtonText2);
		}
		else if(nAdenServerCount > 0 && nTalkingIslandServerCount > 0 && nLiveServerCount == 0)
		{
			Server_2Tab.ShowWindow();
			tabButtonText1 = GetSystemString(888);
			tabButtonText2 = GetSystemString(3924);
			Server_2Tab.SetButtonName(0, tabButtonText1);
			Server_2Tab.SetButtonName(1, tabButtonText2);
		}
		else if(nAdenServerCount > 0 && nTalkingIslandServerCount > 0 && nLiveServerCount > 0)
		{
			Server_3Tab.ShowWindow();
			tabButtonText1 = GetSystemString(888);
			tabButtonText2 = GetSystemString(3923);
			tabButtonText3 = GetSystemString(3924);
			Server_3Tab.SetButtonName(0, tabButtonText1);
			Server_3Tab.SetButtonName(1, tabButtonText2);
			Server_3Tab.SetButtonName(2, tabButtonText3);
		}
	}
}

delegate int OnSortServerList(ServerData A, ServerData B)
{
	if(A.Priority > B.Priority)
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function initServerList()
{
	local int i;

	GetWindowHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea").SetScrollHeight(0);
	GetWindowHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea").SetScrollPosition(0);

	for(i = 0; i < MAX_SERVER_LIST; i++)
	{
		GetWindowHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(i)).HideWindow();
		GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(i) $ ".NEWRibbon_tex").HideWindow();
		GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(i) $ ".ServerDisable_tex").HideWindow();
		GetTextBoxHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(i) $ ".ServerName_Txt").SetText("");
		GetTextBoxHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(i) $ ".CharacterNum_txt").SetText("");
	}
}

function int getServerDataIndexByButtonIndex(int buttonIndex)
{
	local int i;

	for(i = 0; i < serverData_Array.Length; i++)
	{
		if(serverData_Array[i].buttonIndex == buttonIndex)
		{
			return i;
		}
	}
	return -1;
}

function int getServerDataIndexByNewServerButtonIndex(int newServerButtonIndex)
{
	local int i;

	for(i = 0; i < serverData_Array.Length; i++)
	{
		if(serverData_Array[i].newServerButtonIndex == newServerButtonIndex)
		{
			return i;
		}
	}
	return -1;
}

function showServerList(int IsClassicServer, int IsAdenServer, optional bool bAllClassic, optional bool testServer)
{
	local int i, Index, W, h, posX, posY, selectedH;

	for(i = 0; i < serverData_Array.Length; i++)
	{
		serverData_Array[i].buttonIndex = -1;

		if(testServer == false)
		{
			if(IsClassicServer == 1)
			{
				if(serverData_Array[i].IsClassicServer == 0)
				{
					// [Explicit Continue]
					continue;
				}
				if(bAllClassic == false)
				{
					if(IsAdenServer == 1)
					{
						if(serverData_Array[i].IsAdenServer == 0)
						{
							// [Explicit Continue]
							continue;
						}
					}
					else
					{
						if(IsAdenServer == 0)
						{
							if(serverData_Array[i].IsAdenServer == 1)
							{
								// [Explicit Continue]
								continue;
							}
						}
					}
				}
			}
			else
			{
				if(serverData_Array[i].IsClassicServer == 1)
				{
					// [Explicit Continue]
					continue;
				}
			}
		}
		if(W == 4)
		{
			W = 0;
			h++;
		}
		posX = (251 + 0) * W;
		posY = (98 + 0) * h;
		W++;
		GetWindowHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)).ShowWindow();
		GetWindowHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)).MoveC(posX, posY);
		serverData_Array[i].buttonIndex = Index;
		GetTextBoxHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerName_Txt").SetText(serverData_Array[i].Name);
		GetTextBoxHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".CharacterNum_txt").SetText(string(serverData_Array[i].charCnt));
		GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerCondition_tex").SetColorModify(serverData_Array[i].stateColor);

		if(serverData_Array[i].State == GetSystemString(456))
		{
			GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerDisable_tex").ShowWindow();
			GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerCondition_tex").SetColorModify(GetColor(85, 85, 85, 255));
		}
		if(serverData_Array[i].IsNewServer == 1)
		{
			GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".NEWRibbon_tex").ShowWindow();
		}
		if(serverData_Array[i].IsPVPServer == 1)
		{
			GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".NonPVP_tex").ShowWindow();
			GetTextBoxHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerDesc_txt").ShowWindow();
			GetTextBoxHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerDesc_txt").SetText(GetSystemString(14229));
		}
		else if(serverData_Array[i].IsPVPServer == 2)
		{
			GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".NonPVP_tex").ShowWindow();
			GetTextBoxHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerDesc_txt").ShowWindow();
			GetTextBoxHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerDesc_txt").SetText(GetSystemString(14292));
		}
		else
		{
			GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".NonPVP_tex").HideWindow();
			GetTextBoxHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerDesc_txt").HideWindow();
		}
		if(serverData_Array[i].IsClassicServer == 1)
		{
			GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".CharacterICON_tex").SetTexture("L2UI_NewTex.logInServerSelectWnd.CharacterIcon_L2Aden");
			GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".NEWRibbon_tex").SetTexture("L2UI_NewTex.logInServerSelectWnd.ribbonNEW_L2Aden");
		}
		else
		{
			GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".CharacterICON_tex").SetTexture("L2UI_NewTex.logInServerSelectWnd.CharacterIcon_L2");
			GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".NEWRibbon_tex").SetTexture("L2UI_NewTex.logInServerSelectWnd.ribbonNEW_L2");
		}
		if(serverData_Array[i].IsClassicServer == 1)
		{
			if(currentSelectedServerDataArrayIndex == i)
			{
				GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerListBG_tex").SetAlpha(50);
				GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerListBG_tex").SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGL2Aden_Select");
				GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerListBG_tex").SetAlpha(255, 0.41f);
				selectedH = h;
			}
			else
			{
				GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerListBG_tex").SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGL2Aden");
			}
		}
		else
		{
			if(currentSelectedServerDataArrayIndex == i)
			{
				GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerListBG_tex").SetAlpha(50);
				GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerListBG_tex").SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGL2_Select");
				GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerListBG_tex").SetAlpha(255, 0.41f);
				selectedH = h;
			}
			else
			{
				GetTextureHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index) $ ".ServerListBG_tex").SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGL2");
			}
		}
		Index++;
	}
	GetWindowHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea").SetScrollHeight(98 * (h + 1));

	if(selectedH > 3)
	{
		GetWindowHandle("logInServerSelectWnd.List_Wnd.List_ScrollArea").SetScrollPosition(98 * (selectedH - 3));
	}
}

function setNewServerGroupWindowResize(int newServerCount)
{
	if(newServerCount > 0)
	{
		GetTextBoxHandle("logInServerSelectWnd.NewserverDiscription_txt").ShowWindow();
		GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd").ShowWindow();
		GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN01").HideWindow();
		GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN02").HideWindow();
		GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN03").HideWindow();
		GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN04").HideWindow();
		GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN05").HideWindow();

		if(newServerCount > 5)
		{
			newServerCount = 5;
		}
		switch(newServerCount)
		{
			case 5:
				GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN05").ShowWindow();
			case 4:
				GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN04").ShowWindow();
			case 3:
				GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN03").ShowWindow();
			case 2:
				GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN02").ShowWindow();
			case 1:
				GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN01").ShowWindow();
			default:
				GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd").SetWindowSize((234 + 2) * newServerCount, 42);
				break;
		}
	}
	GetTextBoxHandle("logInServerSelectWnd.NewserverDiscription_txt").HideWindow();
	GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd").HideWindow();
}

function setNewServerBtn(int Index, int serverDataIndex)
{
	if(Index > 5)
	{
		Debug(("- 경고!!!!! setNewServerBtn Index값이 너무 큰 값이 들어 왔습니다. " @ string(Index)) @ string(serverDataIndex));
		return;
	}
	GetTextBoxHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index) $ ".ServerName_txt").SetText(serverData_Array[serverDataIndex].Name);

	if(serverData_Array[serverDataIndex].State == GetSystemString(456))
	{
		GetTextureHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index) $ ".ServerCondition_tex").SetColorModify(GetColor(85, 85, 85, 255));
		GetTextureHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index) $ ".NewServerDisable_tex").ShowWindow();
	}
	else
	{
		GetTextureHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index) $ ".ServerCondition_tex").SetColorModify(serverData_Array[serverDataIndex].stateColor);
		GetTextureHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index) $ ".NewServerDisable_tex").HideWindow();
	}
	if(serverData_Array[serverDataIndex].IsNewServer == 1)
	{
		GetTextureHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index) $ ".NEWRibbon_tex").ShowWindow();
	}
	if(serverData_Array[serverDataIndex].IsClassicServer == 1)
	{
		GetTextureHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index) $ ".NEWRibbon_tex").SetTexture("L2UI_NewTex.logInServerSelectWnd.ribbonNEW_L2Aden");
		GetButtonHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index) $ ".newserverBTN").SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2Aden", "L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2Aden_Down", "L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2Aden_Over");
	}
	else
	{
		GetTextureHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index) $ ".NEWRibbon_tex").SetTexture("L2UI_NewTex.logInServerSelectWnd.ribbonNEW_L2");
		GetButtonHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index) $ ".newserverBTN").SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2", "L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2_Down", "L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2_Over");
	}
}

function FindAge(int ServerID)
{
	local int i, intAge;
	local string strParam;

	for(i = 0; i < serverData_Array.Length; i++)
	{
		if(ServerID == serverData_Array[i].Id)
		{
			if(serverData_Array[i].AgeLimit == 15)
			{
				intAge = 0;
			}
			else if(serverData_Array[i].AgeLimit == 18)
			{
				intAge = 1;
			}
			else
			{
				intAge = 1;
			}
			ParamAdd(strParam, "ServerAgeLimit", string(intAge));
			ParamAdd(strParam, "GlobalVersion", string(getLanguageNum()));
			ExecuteEvent(EV_ServerAgeLimitChange, strParam);
		}
	}
}

function connectServer(int arrayIndex)
{
	OnClose_BtnClick();
	FindAge(serverData_Array[arrayIndex].Id);
	RequestLoginServer(serverData_Array[arrayIndex].Id);
}

function int getLanguageNum()
{
	local ELanguageType Language;

	Language = GetLanguage();
	return Language;
}

function bool isKr()
{
	return GetLanguage() == LANG_Korean;
}

defaultproperties
{
}
