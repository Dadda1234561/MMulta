class DethroneWnd extends UICommonAPI;

const TIMER_ID = 1001113;
const REFRESH_DELAY = 600;

var string m_WindowName;
var WindowHandle Me;
var WindowHandle MyinfoGroup_wnd;
var TextureHandle ClassBgMain_Big;
var TextureHandle ClassMark_tex;
var TextureHandle ClassLight;
var TextureHandle ClassChangeLightBig;
var ButtonHandle Help_btn;
var TextBoxHandle LvHead_text;
var TextBoxHandle Lv_text;
var TextBoxHandle ClassName_text;
var TextBoxHandle PCName_text;
var TextBoxHandle AttackNum_text;
var TextBoxHandle LifeNum_text;
var TextBoxHandle AttackTitle_text;
var TextBoxHandle LifeTitle_text;
var TextBoxHandle MyRanking_text;
var TextBoxHandle MyRankingNum_text;
var TextBoxHandle MyDethronePointNum_text;
var TextBoxHandle MyRankingTitle_text;
var TextBoxHandle MyDethronePointTitle_text;
var ButtonHandle prvMyRankingInfo_btn;
var TextureHandle MyRankingBG_tex;
var TextBoxHandle MyServerRanking_text;
var TextBoxHandle MyServerDethronePointNum_text;
var TextureHandle MyServerMark_tex;
var TextBoxHandle MyServerRankingTitle_text;
var TextureHandle MyServerRankingBG_tex;
var WindowHandle prvDethroneResultGroup_wnd;
var TextureHandle prvServerMark_tex;
var TextureHandle prvRulerServerMark_tex;
var TextBoxHandle prvRulerName_text;
var TextBoxHandle ServerName_text;
var TextBoxHandle prvWinRulerTitle_text;
var TextBoxHandle prvWinServerTitle_text;
var WindowHandle NowDethroneResultGroup_wnd;
var TextureHandle OnOffIcon_tex;
var TextBoxHandle WinServerName_text;
var TextureHandle NowRulerServerMark_tex;
var TextBoxHandle NowRulerName_text;
var TextureHandle OccupyServerMark_tex;
var TextBoxHandle OccupyName_text;
var TextBoxHandle OccupyPointNum_text;
var TextBoxHandle RulerTitle_text;
var TextBoxHandle OccupyTitle_text;
var TextBoxHandle WinServerTitle_text;
var TabHandle Dethrone_Tab;
var WindowHandle TabInsideWindowDisableWnd;
var WindowHandle DethroneTab_Container;
var ButtonHandle MainRefresh_Button;
var ButtonHandle MainEnter_Button;
var ButtonHandle MainReward_Button;
var UserInfo myInfo;
var DetailStatusWnd DetailStatusWndScript;
var string DialogAsset_path;
var string dethroneSeverPCName;
var UIControlBasicDialog askDialogScript;
var bool isDethroneBOpen;

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	DialogAsset_path = "DethroneWnd" $ ".UIControlDialogAsset";
	MyinfoGroup_wnd = GetWindowHandle(m_WindowName $ ".MyinfoGroup_wnd");
	ClassBgMain_Big = GetTextureHandle(m_WindowName $ ".MyinfoGroup_wnd.ClassBgMain_Big");
	ClassMark_tex = GetTextureHandle(m_WindowName $ ".MyinfoGroup_wnd.ClassMark_tex");
	ClassLight = GetTextureHandle(m_WindowName $ ".MyinfoGroup_wnd.ClassLight");
	ClassChangeLightBig = GetTextureHandle(m_WindowName $ ".MyinfoGroup_wnd.ClassChangeLightBig");
	Help_btn = GetButtonHandle(m_WindowName $ ".MyinfoGroup_wnd.Help_btn");
	LvHead_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.LvHead_text");
	Lv_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.Lv_text");
	ClassName_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.ClassName_text");
	PCName_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.PCName_text");
	AttackNum_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.AttackNum_text");
	LifeNum_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.LifeNum_text");
	AttackTitle_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.AttackTitle_text");
	LifeTitle_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.LifeTitle_text");
	MyRanking_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.MyRanking_text");
	MyRankingNum_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.MyRankingNum_text");
	MyDethronePointNum_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.MyDethronePointNum_text");
	MyRankingTitle_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.MyRankingTitle_text");
	MyDethronePointTitle_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.MyDethronePointTitle_text");
	prvMyRankingInfo_btn = GetButtonHandle(m_WindowName $ ".MyinfoGroup_wnd.prvMyRankingInfo_btn");
	MyRankingBG_tex = GetTextureHandle(m_WindowName $ ".MyinfoGroup_wnd.MyRankingBG_tex");
	MyServerRanking_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.MyServerRanking_text");
	MyServerDethronePointNum_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.MyServerDethronePointNum_text");
	MyServerMark_tex = GetTextureHandle(m_WindowName $ ".MyinfoGroup_wnd.MyServerMark_tex");
	MyServerRankingTitle_text = GetTextBoxHandle(m_WindowName $ ".MyinfoGroup_wnd.MyServerRankingTitle_text");
	MyServerRankingBG_tex = GetTextureHandle(m_WindowName $ ".MyinfoGroup_wnd.MyServerRankingBG_tex");
	prvDethroneResultGroup_wnd = GetWindowHandle(m_WindowName $ ".prvDethroneResultGroup_wnd");
	prvServerMark_tex = GetTextureHandle(m_WindowName $ ".prvDethroneResultGroup_wnd.prvServerMark_tex");
	prvRulerServerMark_tex = GetTextureHandle(m_WindowName $ ".prvDethroneResultGroup_wnd.prvRulerServerMark_tex");
	prvRulerName_text = GetTextBoxHandle(m_WindowName $ ".prvDethroneResultGroup_wnd.prvRulerName_text");
	ServerName_text = GetTextBoxHandle(m_WindowName $ ".prvDethroneResultGroup_wnd.ServerName_text");
	prvWinRulerTitle_text = GetTextBoxHandle(m_WindowName $ ".prvDethroneResultGroup_wnd.prvWinRulerTitle_text");
	prvWinServerTitle_text = GetTextBoxHandle(m_WindowName $ ".prvDethroneResultGroup_wnd.prvWinServerTitle_text");
	NowDethroneResultGroup_wnd = GetWindowHandle(m_WindowName $ ".NowDethroneResultGroup_wnd");
	OnOffIcon_tex = GetTextureHandle(m_WindowName $ ".NowDethroneResultGroup_wnd.OnOffIcon_tex");
	WinServerName_text = GetTextBoxHandle(m_WindowName $ ".NowDethroneResultGroup_wnd.WinServerName_text");
	NowRulerServerMark_tex = GetTextureHandle(m_WindowName $ ".NowDethroneResultGroup_wnd.NowRulerServerMark_tex");
	NowRulerName_text = GetTextBoxHandle(m_WindowName $ ".NowDethroneResultGroup_wnd.NowRulerName_text");
	OccupyServerMark_tex = GetTextureHandle(m_WindowName $ ".NowDethroneResultGroup_wnd.OccupyServerMark_tex");
	OccupyName_text = GetTextBoxHandle(m_WindowName $ ".NowDethroneResultGroup_wnd.OccupyName_text");
	OccupyPointNum_text = GetTextBoxHandle(m_WindowName $ ".NowDethroneResultGroup_wnd.OccupyPointNum_text");
	RulerTitle_text = GetTextBoxHandle(m_WindowName $ ".NowDethroneResultGroup_wnd.RulerTitle_text");
	OccupyTitle_text = GetTextBoxHandle(m_WindowName $ ".NowDethroneResultGroup_wnd.OccupyTitle_text");
	WinServerTitle_text = GetTextBoxHandle(m_WindowName $ ".NowDethroneResultGroup_wnd.WinServerTitle_text");
	Dethrone_Tab = GetTabHandle(m_WindowName $ ".Dethrone_Tab");
	TabInsideWindowDisableWnd = GetWindowHandle(m_WindowName $ ".TabInsideWindowDisableWnd");
	DethroneTab_Container = GetWindowHandle(m_WindowName $ ".DethroneTab_Container");
	MainRefresh_Button = GetButtonHandle(m_WindowName $ ".MainRefresh_Button");
	MainEnter_Button = GetButtonHandle(m_WindowName $ ".MainEnter_Button");
	MainReward_Button = GetButtonHandle(m_WindowName $ ".MainReward_Button");
	DetailStatusWndScript = DetailStatusWnd(GetScript("DetailStatusWnd"));
	GetButtonHandle(m_WindowName $ ".MainShop_Button").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14313), 250));
}

function Load()
{
	CommonDialogSetScript(DialogAsset_path, m_WindowName $ ".DisableDialog_tex", true);
	CommonDialogGetScript(DialogAsset_path).DelegateOnCancel = OnClickDialogCancel;
	CommonDialogGetScript(DialogAsset_path).DelegateOnClickBuy = OnClickDialogOk;
	CommonDialogGetScript(DialogAsset_path).SetDisableWindow(GetTextureHandle(m_WindowName $ ".DisableDialog_tex"));
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop(m_WindowName $ ".DisableDialog_tex", false);
	SetScript_UIControlBaseDialog();
}

function SetScript_UIControlBaseDialog()
{
	GetWindowHandle("DethroneWnd.ConfirmWnd").SetScript("UIControlBasicDialog");
	askDialogScript = UIControlBasicDialog(GetWindowHandle("DethroneWnd.ConfirmWnd").GetScript());
	askDialogScript.SetWindow("DethroneWnd.ConfirmWnd");
	askDialogScript.DelegateOnClickCancleButton = OnClickHideDialog;
	askDialogScript.DelegateOnClickOkButton = OnClickOkDialog;
	GetWindowHandle("DethroneWnd.ConfirmWnd").HideWindow();
}

function OnClickHideDialog(optional int nDialogKey)
{
	GetTextureHandle(m_WindowName $ ".DisableDialog_tex").HideWindow();
	GetWindowHandle("DethroneWnd.ConfirmWnd").HideWindow();
}

function OnClickOkDialog(optional int nDialogKey)
{
	// End:0x2D
	if(class'UIDATA_PLAYER'.static.IsInDethrone())
	{
		API_C_EX_DETHRONE_LEAVE();
		OnClickHideDialog();
		Me.HideWindow();
	}
}

function OnClickDialogOk()
{
	Debug("CommonDialogGetScript(DialogAsset_path).getDialogID()" @ string(CommonDialogGetScript(DialogAsset_path).GetDialogID()));
	// End:0xB1
	if(CommonDialogGetScript(DialogAsset_path).GetDialogID() == 1)
	{
		DethroneTab02_ServerStatus(GetScript("DethroneWnd.DethroneTab02_ServerStatus")).API_C_EX_DETHRONE_CONNECT_CASTLE();		
	}
	else if(CommonDialogGetScript(DialogAsset_path).GetDialogID() == 2)
	{
		DethroneTab02_ServerStatus(GetScript("DethroneWnd.DethroneTab02_ServerStatus")).API_C_EX_DETHRONE_DISCONNECT_CASTLE();
	}
	else if(class'UIDATA_PLAYER'.static.IsInDethrone())
	{
		API_C_EX_DETHRONE_LEAVE();
		Me.HideWindow();
	}
	CommonDialogHide(DialogAsset_path);
}

function OnClickDialogCancel()
{
	CommonDialogHide(DialogAsset_path);
}

function gotoTabMission()
{
	Dethrone_Tab.SetTopOrder(3, true);
	Debug("탭 이동");
}

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_SEASON_INFO);
}

function OnShow()
{
	// End:0x3E
	if(class'UIDATA_PLAYER'.static.IsInPrison())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13773));
		Me.HideWindow();
		return;
	}
	// End:0x73
	if(IsPlayerOnOlympiad())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		Me.HideWindow();
		return;
	}
	setDisableWnd();
	API_C_EX_DETHRONE_INFO();
	setMyInfo();
	switch(Dethrone_Tab.GetTopIndex())
	{
		// End:0x97
		case 0:
			DethroneTab01_Ranking(GetScript("DethroneWnd.DethroneTab01_Ranking")).ShowProcess();
			// End:0x163
			break;
		// End:0xDB
		case 1:
			DethroneTab02_ServerStatus(GetScript("DethroneWnd.DethroneTab02_ServerStatus")).OnShow();
			// End:0x163
			break;
		// End:0x120
		case 2:
			DethroneTab03_OccupyStatus(GetScript("DethroneWnd.DethroneTab03_OccupyStatus")).OnShow();
			// End:0x163
			break;
		// End:0x160
		case 3:
			DethroneTab04_Mission(GetScript("DethroneWnd.DethroneTab04_Mission")).OnShow();
			// End:0x163
			break;
	}
	// End:0x186
	if(GetWindowHandle(DialogAsset_path).IsShowWindow())
	{
		CommonDialogHide(DialogAsset_path);
	}
	// End:0x1B7
	if(GetWindowHandle("DethroneWnd.ConfirmWnd").IsShowWindow())
	{
		OnClickHideDialog();
	}
	Debug("class'UIDATA_PLAYER'.static.IsInDethrone()" @ string(class'UIDATA_PLAYER'.static.IsInDethrone()));
	Debug("IsPlayerOnWorldRaidServer()" @ string(IsPlayerOnWorldRaidServer()));
	// End:0x308
	if(class'UIDATA_PLAYER'.static.IsInDethrone())
	{
		MainEnter_Button.SetTexture("L2UI_EPIC.DethroneWnd.Dethrone_ReturnBtn", "L2UI_EPIC.DethroneWnd.Dethrone_ReturnBtn_D", "L2UI_EPIC.DethroneWnd.Dethrone_ReturnBtn_O");
		MainEnter_Button.SetButtonName(13735);
		MainEnter_Button.SetTooltipType("text");
		MainEnter_Button.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13783), 200));
	}
	else
	{
		MainEnter_Button.SetTexture("L2UI_EPIC.DethroneWnd.Dethrone_EntranceBtn", "L2UI_EPIC.DethroneWnd.Dethrone_EntranceBtn_D", "L2UI_EPIC.DethroneWnd.Dethrone_EntranceBtn_O");
		MainEnter_Button.SetButtonName(13734);
		MainEnter_Button.ClearTooltip();
	}
}

function OnClickButton(string Name)
{
	Debug("Name" @ Name);
	switch(Name)
	{
		case "Help_btn":
			//class'HelpWnd'.static.ShowHelp(63, 1);
			break;
		case "MainRefresh_Button":
			API_C_EX_DETHRONE_INFO();
			break;
		case "MainEnter_Button":
			// End:0x146
			if(class'UIDATA_PLAYER'.static.IsInDethrone())
			{
				askDialogScript.setInit(GetSystemString(13784));
				GetTextureHandle(m_WindowName $ ".DisableDialog_tex").ShowWindow();
				GetTextureHandle(m_WindowName $ ".DisableDialog_tex").SetFocus();
				GetWindowHandle("DethroneWnd.ConfirmWnd").ShowWindow();
				GetWindowHandle("DethroneWnd.ConfirmWnd").SetFocus();				
			}
			else
			{
				// End:0x1C2
				if(myInfo.nLevel >= 110)
				{
					Me.HideWindow();
					toggleWindow("DethroneCharacterCreateWnd", true, true);
					getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "DethroneCharacterCreateWnd");					
				}
				else
				{
					getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13452));
				}
			}
			// End:0x29B
			break;
		case "MainReward_Button":
			toggleWindow("DethroneResultWnd", true, true);
			// End:0x29B
			break;
		case "prvReward_Button":
			toggleWindow("DethroneResultWnd", true, true);
			// End:0x29B
			break;
		case "Dethrone_Tab0":
		case "Dethrone_Tab1":
		case "Dethrone_Tab2":
		case "Dethrone_Tab3":
			setDisableWnd();
			break;
		case "MainEnchant_Button":
			if(GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow())
			{
				GetWindowHandle("DethroneFireEnchantWnd").HideWindow();				
			}
			else
			{
				DethroneFireEnchantWnd(GetScript("DethroneFireEnchantWnd")).API_C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI();
			}
			// End:0x368
			break;
		// End:0x365
		case "MainShop_Button":
			toggleWindow("DethroneShopWnd", true, true);
			break;
	}
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x1E
		case 9750:
			initControl();
			setDisableWnd();
			// End:0x5E
			break;
		// End:0x3B
		case EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_INFO):
			ParsePacket_S_EX_DETHRONE_INFO();
		// End:0x5B
		case EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_SEASON_INFO):
			ParsePacket_S_EX_DETHRONE_SEASON_INFO();
			// End:0x5E
			break;
	}
}

function ParsePacket_S_EX_DETHRONE_INFO()
{
	local UIPacket._S_EX_DETHRONE_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_INFO(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_DETHRONE_INFO :  " @ packet.sName @ string(packet.nAttackPoint) @ string(packet.nLife) @ string(packet.nRank) @ string(packet.nTotalRankers) @ string(packet.nPersonalDethronePoint) @ string(packet.nPrevRank) @ string(packet.nPrevTotalRankers) @ string(packet.nPrevDethronePoint) @ string(packet.nServerRank) @ string(packet.nServerDethronePoint) @ string(packet.nConquerorWorldID) @ packet.sConquerorName @ string(packet.nOccupyingServerWorldID) @ string(packet.nTopRankerWorldID) @ packet.sTopRankerName @ string(packet.nTopServerWorldID) @ string(packet.nTopServerDethronePoint));
	dethroneSeverPCName = packet.sName;
	setMyInfo();
	AttackNum_text.SetText(string(packet.nAttackPoint));
	LifeNum_text.SetText(string(packet.nLife));
	MyDethronePointNum_text.SetText(MakeCostString(string(packet.nPersonalDethronePoint)));
	MyRanking_text.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRank)));
	MyRankingNum_text.SetText(("(" $ (stringPer(float(packet.nRank), float(packet.nTotalRankers)))) $ "%)");
	SetCusomTooltipAtPrvMyRankingInfo_btn(((MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nPrevRank)) $ "(") $ (stringPer(float(packet.nPrevRank), float(packet.nPrevTotalRankers)))) $ "%)", packet.nPrevDethronePoint);
	MyServerRanking_text.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nServerRank)));
	MyServerDethronePointNum_text.SetText(MakeCostString(string(packet.nServerDethronePoint)));
	prvRulerName_text.SetText(packet.sConquerorName);
	prvRulerServerMark_tex.SetTexture(GetServerMarkNameSmall(packet.nConquerorWorldID));
	// End:0x35D
	if(packet.sConquerorName != "")
	{
		prvRulerName_text.SetTooltipType("text");
		prvRulerName_text.SetTooltipText(getServerNameByWorldID(packet.nConquerorWorldID) $ "_" $ getInstanceL2Util().makeZeroString(2, getServerExtIdByWorldID(packet.nConquerorWorldID)));		
	}
	else
	{
		prvRulerName_text.ClearTooltip();
		prvRulerName_text.SetTooltipText("");
	}
	// End:0x3FD
	if(getServerNameByWorldID(packet.nOccupyingServerWorldID) != "")
	{
		ServerName_text.SetText(getServerNameByWorldID(packet.nOccupyingServerWorldID) $ "_" $ getInstanceL2Util().makeZeroString(2, getServerExtIdByWorldID(packet.nOccupyingServerWorldID)));
		prvServerMark_tex.SetTexture(GetServerMark(packet.nOccupyingServerWorldID));
	}
	NowRulerServerMark_tex.SetTexture(GetServerMarkNameSmall(packet.nTopRankerWorldID));
	NowRulerName_text.SetText(packet.sTopRankerName);
	// End:0x4A8
	if(packet.sTopRankerName != "")
	{
		NowRulerName_text.SetTooltipType("text");
		NowRulerName_text.SetTooltipText(getServerNameByWorldID(packet.nTopRankerWorldID) $ "_" $ getInstanceL2Util().makeZeroString(2, getServerExtIdByWorldID(packet.nTopRankerWorldID)));		
	}
	else
	{
		NowRulerName_text.ClearTooltip();
		NowRulerName_text.SetTooltipText("");
	}
	// End:0x548
	if((getServerNameByWorldID(packet.nTopServerWorldID)) != "")
	{
		OccupyServerMark_tex.SetTexture(GetServerMarkNameSmall(packet.nTopServerWorldID));
		OccupyName_text.SetText(getServerNameByWorldID(packet.nTopServerWorldID) $ "_" $ getInstanceL2Util().makeZeroString(2, getServerExtIdByWorldID(packet.nTopServerWorldID)));
	}
	OccupyPointNum_text.SetText(MakeCostString(string(packet.nTopServerDethronePoint)));
}

function initControl()
{
	AttackNum_text.SetText("");
	LifeNum_text.SetText("");
	MyDethronePointNum_text.SetText("");
	MyRanking_text.SetText("");
	MyRankingNum_text.SetText("");
	MyServerRanking_text.SetText("");
	MyServerDethronePointNum_text.SetText("");
	ServerName_text.SetText("");
	prvRulerServerMark_tex.SetTexture("");
	prvRulerName_text.SetText("");
	NowRulerServerMark_tex.SetTexture("");
	prvServerMark_tex.SetTexture("");
	NowRulerName_text.SetText("");
	OccupyServerMark_tex.SetTexture("");
	OccupyName_text.SetText("");
	OccupyPointNum_text.SetText("");
}

function ParsePacket_S_EX_DETHRONE_SEASON_INFO()
{
	local UIPacket._S_EX_DETHRONE_SEASON_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_SEASON_INFO(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_DETHRONE_INFO :  " @ string(packet.bOpen) @ string(packet.nSeasonYear) @ string(packet.nSeasonMonth));
	isDethroneBOpen = numToBool(packet.bOpen);
	if(packet.bOpen > 0)
	{
		OnOffIcon_tex.SetTexture("L2UI_CT1.OlympiadWnd.ONICON");		
	}
	else
	{
		OnOffIcon_tex.SetTexture("L2UI_CT1.OlympiadWnd.OffICON");
	}
	WinServerName_text.SetText(MakeFullSystemMsg(GetSystemMessage(13433), string(packet.nSeasonYear), string(packet.nSeasonMonth)));
}

function bool isDethroneOpen()
{
	return isDethroneBOpen;	
}

function setMyInfo()
{
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
	Lv_text.SetText(string(nLevel));
	ClassName_text.SetText(GetClassType(nClass));
	// End:0xC3
	if(dethroneSeverPCName == "")
	{
		PCName_text.SetText(myInfo.Name);		
	}
	else
	{
		PCName_text.SetText(dethroneSeverPCName $ "_" $ getInstanceL2Util().makeZeroString(2, getServerExtIdByWorldID(myInfo.nWorldID)));
	}
	MyServerMark_tex.SetTexture(GetServerMarkNameSmall(myInfo.nWorldID));
	MyServerRankingTitle_text.SetText(getServerNameByWorldID(myInfo.nWorldID) $ "_" $ getInstanceL2Util().makeZeroString(2, getServerExtIdByWorldID(myInfo.nWorldID)));
	// End:0x1C4
	if(GetClassTransferDegree(nClass) >= 1)
	{
		ClassMark_tex.SetTexture("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(nClass) $ "_Big");		
	}
	else
	{
		ClassMark_tex.SetTexture("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(myInfo.Race) $ "_Big");
	}
}

function setDisableWnd()
{
	Dethrone_Tab.DisableWindow();
	TabInsideWindowDisableWnd.ShowWindow();
	Me.SetTimer(TIMER_ID, REFRESH_DELAY);
}

function hideDisableWnd()
{
	Dethrone_Tab.EnableWindow();
	TabInsideWindowDisableWnd.HideWindow();
	Me.KillTimer(TIMER_ID);
}

function OnTimer(int TimeID)
{
	// End:0x15
	if(TimeID == TIMER_ID)
	{
		hideDisableWnd();
	}
}

function AskDialogDethroneConnect()
{
	local int nDialogID, i;
	local array<RequestItem> needItemArray;

	nDialogID = 1;
	GetDethroneConnectCost(needItemArray);
	CommonDialogGetScript(DialogAsset_path).SetUseNeedItem(true);
	CommonDialogGetScript(DialogAsset_path).StartNeedItemList(needItemArray.Length);

	// End:0xAE [Loop If]
	for(i = 0; i < needItemArray.Length; i++)
	{
		CommonDialogGetScript(DialogAsset_path).AddNeedItemClassID(needItemArray[i].Id, needItemArray[i].Amount);
	}
	CommonDialogGetScript(DialogAsset_path).SetItemNum(1);
	CommonDialogGetScript(DialogAsset_path).SetDialogID(nDialogID);
	CommonDialogGetScript(DialogAsset_path).ShowDesriptionBGDeco();
	CommonDialogGetScript(DialogAsset_path).HideDescriptonIcon();
	CommonDialogShow(DialogAsset_path, connectImgHtml(), true);
}

function AskDialogDethronedisConnect()
{
	local int nDialogID;

	nDialogID = 2;
	CommonDialogGetScript(DialogAsset_path).SetUseNeedItem(false);
	CommonDialogGetScript(DialogAsset_path).SetDialogID(nDialogID);
	CommonDialogGetScript(DialogAsset_path).ShowDesriptionBGDeco();
	CommonDialogGetScript(DialogAsset_path).HideDescriptonIcon();
	CommonDialogShow(DialogAsset_path, disconnectImgHtml(), true);
	GetButtonHandle(DialogAsset_path $ ".OkButton").EnableWindow();
}

function AskDialogDethroneLeave()
{
	local int nDialogID;

	nDialogID = 3;
	CommonDialogGetScript(DialogAsset_path).SetUseNeedItem(false);
	CommonDialogGetScript(DialogAsset_path).SetDialogID(nDialogID);
	CommonDialogGetScript(DialogAsset_path).HideDesriptionBGDeco();
	CommonDialogGetScript(DialogAsset_path).ShowDescriptonIcon();
	CommonDialogShow(DialogAsset_path, GetSystemString(13784));
}

function string connectImgHtml()
{
	local string htmlAdd;

	htmlAdd = htmlAddTableTD("<br>" $ htmlAddImg("L2UI_EPIC.HtmlWnd.HtmlWnd_DethroneEnter_IMG", 321, 228) $ htmlAddText(GetSystemString(13770), "GameDefault", "c8c8c8"), "Center", "Center", 0, 0, "", false);
	htmlSetTableTR(htmlAdd);
	htmlSetTable(htmlAdd, 0, 340, 0, "", 0, 0);
	return htmlAdd;
}

function string disconnectImgHtml()
{
	local string htmlAdd;

	htmlAdd = htmlAddTableTD("<br>" $ htmlAddImg("L2UI_EPIC.HtmlWnd.HtmlWnd_DethroneEnter_IMG", 321, 228) $ htmlAddText(GetSystemString(13771), "GameDefault", "c8c8c8"), "Center", "Center", 0, 0, "", false);
	htmlSetTableTR(htmlAdd);
	htmlSetTable(htmlAdd, 0, 340, 0, "", 0, 0);
	return htmlAdd;
}

function SetCusomTooltipAtPrvMyRankingInfo_btn(string rankingString, INT64 pDethronePoint)
{
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3701), getInstanceL2Util().Yellow, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1320) $ " : " $ rankingString, getInstanceL2Util().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13739) $ " : " $ MakeCostString(string(pDethronePoint)), getInstanceL2Util().White, "", true, true);
	prvMyRankingInfo_btn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function API_C_EX_DETHRONE_INFO()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_INFO, stream);
	Debug("----> Api Call : C_EX_DETHRONE_INFO");
}

function API_C_EX_DETHRONE_LEAVE()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_LEAVE, stream);
	Debug("----> Api Call : C_EX_DETHRONE_LEAVE");
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	// End:0x2E
	if(GetWindowHandle(DialogAsset_path).IsShowWindow())
	{
		CommonDialogHide(DialogAsset_path);		
	}
	else if(GetWindowHandle("DethroneWnd.ConfirmWnd").IsShowWindow())
	{
		OnClickHideDialog();	
	}
	else
	{
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
}

defaultproperties
{
}
