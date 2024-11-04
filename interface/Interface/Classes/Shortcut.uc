class Shortcut extends UICommonAPI;

const CHAT_WINDOW_NORMAL = 0;
const CHAT_WINDOW_TRADE = 1;
const CHAT_WINDOW_PARTY = 2;
const CHAT_WINDOW_CLAN = 3;
const CHAT_WINDOW_ALLY = 4;
const CHAT_WINDOW_COUNT = 5;
const CHAT_WINDOW_SYSTEM = 5;		// �ý��� �޽��� â

const DIALOGID_Gohome = 44420;

var bool m_chatstateok;

event OnRegisterEvent()
{
	RegisterEvent(EV_ShortcutCommand);
	RegisterEvent(EV_StateChanged);
	RegisterEvent(EV_ShowWindow);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case EV_ShortcutCommand:
			HandleShortcutCommand(a_Param);
			break;
		case EV_StateChanged:
			HandleStateChange(a_Param);
			break;
		case EV_ShowWindow:
			HandleShortcutKeyEvent(a_Param);
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
	}
}

private function OptionMuteModeChange()
{
	local int currentMODE;

	currentMODE = GetOptionInt("Audio", "MODE");
	// End:0x2F
	if(currentMODE == 2)
	{
		currentMODE = 0;		
	}
	else
	{
		currentMODE++;
	}
	SetOptionInt("Audio", "MODE", currentMODE);
	Debug("Shorcut OptionMuteModeChanged");
	OptionWnd(GetScript("OptionWnd"))._InitAudioOption();	
}

function HandleShortcutKeyEvent(string a_Param)
{
	local string wndname;
	local OptionWnd o_script;
	local TargetStatusWnd t_script;
	local ShortcutWnd s_script;

	ParseString(a_Param, "Name", wndname);
	o_script = OptionWnd(GetScript("OptionWnd"));
	t_script = TargetStatusWnd(GetScript("TargetStatusWnd"));
	s_script = ShortcutWnd(GetScript("ShortcutWnd"));

	switch(wndname)
	{
		// End:0xD4
		case "GMWnd":
		// End:0xE2
		case "GMClanWnd":
		// End:0xF8
		case "GMDetailStatusWnd":
		// End:0x10B
		case "GMInventoryWnd":
		// End:0x11F
		case "GMMagicSkillWnd":
		// End:0x12E
		case "GMQuestWnd":
		// End:0x141
		case "GMWarehouseWnd":
		// End:0x150
		case "GMSnoopWnd":
		// End:0x172
		case "GMPetitionWnd":
			// End:0x16F
			if(! IsBuilderPC())
			{
				return;
			}
			// End:0x175
			break;
	}

	switch(wndname)
	{
		case "InventoryWnd":
			ExecuteEvent(EV_InventoryToggleWindow);	
			break;
		case "MacroWnd":
			ExecuteEvent(EV_MacroShowListWnd);
			break;
		case "PartyMatchWnd":
			HandlePartyMatchingOnOff();
			break;
		case "BoardWnd":
			if (GetWindowHandle("BoardWnd").isShowWindow())
				GetWindowHandle("BoardWnd").HideWindow();
			else 
				ExecuteEvent(EV_ShowBBS);
			
			break;
		case "MinimapWnd":
			RequestOpenMinimap();
			break;
		
		case "HelpHtmlWnd":
			HandleShowHelpHtmlWnd();
			break;
		
		case "FN_HideDropItemSilhauette":
			if (GetOptionBool("ScreenInfo", "HideDropItem"))
			{
				SetOptionBool("ScreenInfo", "HideDropItem", false);
			}
			else
			{
				SetOptionBool("ScreenInfo", "HideDropItem", true);
			}
			o_script.InitScreenInfoOption();
			break;
		case "FN_SendTargetedCharacterMessage":
			// End:0x29B
			if(t_script.g_NameStr == "")
			{				
			}
			else
			{
				SetChatMessage("\"" $ t_script.g_NameStr $ " ");
			}
			break;
			//
		case "FN_MuteAllAudio":
			OptionMuteModeChange();
			break;
		case "FN_SHORTCUTEXPAND":
			s_script.OnClickExpandShortcutButton();
			break;
		case "FN_UILocReset":
			o_script.SetDefaultPositionByClick();
			break;
		case "SystemMenuWnd":
			break;
		//�޴� ����������Ͽ� �߰�.
		//������
		case "Post":
			HandleShowPostBoxWnd();
			break;		
		//����Ű ����â
		case "ShortcutAssign":
			HandleShowShortcutAssignWnd();
			break;
		//�ν��Ͻ���
		case "InstancedZone":
			// End:0x3D0
			if(class'UIAPI_WINDOW'.static.IsShowWindow("InstancedZoneHistoryWnd"))
			{
				class'UIAPI_WINDOW'.static.HideWindow("InstancedZoneHistoryWnd");				
			}
			else
			{
				RequestInzoneWaitingTime();
			}
			break;
		//������ ��ȭ
		case "Rec":
			HandleShowMovieCaptureWnd();
			break;
		//���÷��� ��ȭ
		case "Replayrec":
			DoAction(class'UICommonAPI'.static.GetItemID(55));
			break;
		//��ǰ�κ��丮
		case "Productinven":
			HandleShowProductInventory();
			break;
		//�ǸŻ���
		case "ShopSell":
			// End:0x48F
			if(class'UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWnd"))
			{
				PrivateShopWnd(GetScript("PrivateShopWnd")).OnClickButton("StopButton");				
			}
			else
			{
				DoAction(class'UICommonAPI'.static.GetItemID(10));
			}
			break;
		//���Ż���
		case "ShopBuy":
			// End:0x50B
			if(class'UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWnd"))
			{
				PrivateShopWnd(GetScript("PrivateShopWnd")).OnClickButton("StopButton");				
			}
			else
			{
				DoAction(class'UICommonAPI'.static.GetItemID(28));
			}
			break;
		//�ϰ��ǸŻ���
		case "ShopSellAll":
			// End:0x58B
			if(class'UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWnd"))
			{
				PrivateShopWnd(GetScript("PrivateShopWnd")).OnClickButton("StopButton");				
			}
			else
			{
				DoAction(class'UICommonAPI'.static.GetItemID(61));
			}
			break;
		//�����˻�
		case "ShopSearch":
			DoAction(class'UICommonAPI'.static.GetItemID(57));
			break;
		//����
		case "Petition":
			HandleShowPetitionBegin();
			break;
		//Ȩ������
		case "Homepage":
			linkHomepage();
			break;
		//PC�� ����Ʈ
		case "PcRoom":
			HandleToggleShowPCCafeEventWnd();
			break;
		default:
			WindowOpenOrClose(WNDName);
		break;
	}
}


/* ****************************************************
 * ������ ���� �ݱ� 
 **************************************************** */

// ���� Ÿ�Կ� ���� ������ �̸� �ޱ�
function string getWindowNameByServerType(string wndname)
{
	// End:0x29
	if(wndname == "ChatMessage")
	{
		wndname = "ChatWnd";		
	}

	// Ŭ���� ������
	else if (getInstanceUIData().getisClassicServer())
	{
		wndname = getClassicWindowName(wndname);
		// End:0x80
		if(wndname == "ClanWndClassic")
		{
			wndname = "ClanWndClassicNew";
		}
	}

	return wndname;
}

// Ŭ���� ������� ���� ������� �ִ� ������� ���
function string getClassicWindowName (string WNDName)
{
	switch (WNDName)
	{
		case "ClanWnd":
		case "DetailStatusWnd":
			return WNDName $ "Classic";
		// End:0x5D
		case "QuestTreeWnd":
			// End:0x5D
			if(IsAdenServer())
			{
				return "QuestWnd";
			}
	}
	return WNDName;
}


// ���� �ޱ�
function getSoundTypeByWndName (string WndName, out EInterfaceSoundType openSound, out EInterfaceSoundType closeSound) 
{
	switch  (WNDName) //���� ����
	{	
	case "MagicSkillWnd":
		openSound = IFST_MAPWND_OPEN;
		closeSound = IFST_MAPWND_CLOSE;
		break;
	case "ActionWnd":
	case "DetailStatusWnd":
	case "DetailStatusWndClassic":
		openSound =  IFST_WINDOW_OPEN;
		closeSound = IFST_WINDOW_CLOSE;
		break;	
	default :
		openSound = IFST_STATUSWND_OPEN;
		closeSound = IFST_STATUSWND_CLOSE;
		break;
	}
}

function WindowOpenOrClose(string WNDName)
{
	local EInterfaceSoundType openSound, closeSound;	

	local WindowHandle WNDNameHandle;
	local int tempVars;	
	//local int nUsePledgeV2Live, nUsePledgeV2Classic;
	WndName = getWindowNameByServerType (WndName);
	WNDNameHandle = GetWindowHandle (WndName) ;

	getSoundTypeByWndName(WndName, openSound, closeSound) ;	
	//Debug ("WindowOpenOrClose" @ WndName);
	switch (WNDName) 
	{
		case "TeleportMapWnd":
			// End:0xE1
			if(USE_XML_TELEPORT_UI)
			{
				if (Class'UIAPI_WINDOW'.static.IsShowWindow("TeleportWnd"))
				{
					Class'UIAPI_WINDOW'.static.HideWindow("TeleportWnd");
				}
				else
				{
				// End:0xAE
					if(class'UIDATA_PLAYER'.static.IsInDethrone())
					{
						getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
						return;
					}
					class'UIAPI_WINDOW'.static.ShowWindow("TeleportWnd");
				}
			}
			else
			{
				// End:0x10F
				if(class'UIAPI_WINDOW'.static.IsShowWindow(wndname))
				{
					class'UIAPI_WINDOW'.static.HideWindow(wndname);					
				}
				else
				{
					// End:0x13E
					if(class'UIDATA_PLAYER'.static.IsInDethrone())
					{
						getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
						return;
					}
					TeleportMapWnd(GetScript("TeleportMapWnd")).Rq_C_EX_TELEPORT_UI();
				}
			}
			break;
		case "RadarMapWnd" :
			toggleWindow(wndname);
			break;
		// �Ʒ��� ���ھ� ���� 
		// ����Ű�� �ٲ��, release �� ���� �ʰ� �Ǵ� �̽��� ����			
		//case "ArenaScoreBoardWnd":						
			//CallGFxFunction("ArenaScoreBoardWnd", "show", "");
			//break;

		//case "ArenaScoreBoardWndShow":
		//	CallGFxFunction("ArenaScoreBoardWnd", "show", "");
		//	break;
		//case "ArenaScoreBoardWndHide":
		//	CallGFxFunction("ArenaScoreBoardWnd", "hide", "");
		//	break;
		case "OptionWnd":
			toggleShowOptionWnd();
			break;
		// ä��â�� �پ� �ִ� ����� äƮ �ڽ� ó��
		case "ChatWnd":		
			if(WNDNameHandle.IsShowWindow())
			{
				callGFxFunction("WorldChatBox","ToggleShowWnd", "hide");
				WNDNameHandle.HideWindow();
				PlayConsoleSound(closeSound);
			}
			else
			{
				GetINIBool("global", "UseWorldChatSpeaker", tempVars, "chatfilter.ini");		
				if(bool(tempVars))
				{
					callGFxFunction("WorldChatBox","ToggleShowWnd", "show");
				}

				WNDNameHandle.ShowWindow();
				WNDNameHandle.SetFocus();
				PlayConsoleSound(openSound);
			}		
			break;

		case "ClanWnd":
		case "ClanWndClassicNew":
			// End:0x331
			if(IsPlayerOnWorldRaidServer() && ! IsAdenServer())
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
				return;
			}
			// End:0x38C
			if(getInstanceUIData().getIsClassicServer())
			{
				//GetINIBool ("Localize", "UsePledgeV2Classic", nUsePledgeV2Classic, "L2.ini");

				// ���� ������ UI ���
				if (getInstanceL2Util().isClanV2())
					toggleWindow("ClanGfxWnd", true, true);
				else
					toggleWindow("ClanWndClassicNew", true, true);
			}
			else
			{
				// ���̺�
				//GetINIBool ("Localize", "UsePledgeV2Live", nUsePledgeV2Live, "L2.ini");

				// ���� ������ UI ���
				//if (nUsePledgeV2Live > 0)
				//	toggleWindow("ClanGfxWnd", true, true);
				//else
				//	toggleWindow("ClanWnd", true, true);

				if(getInstanceL2Util().isClanV2())
				{
					toggleWindow("ClanGfxWnd", true, true);
				}
				else
				{
					toggleWindow("ClanWnd", true, true);
				}
			}

			break;
		case "MagicSKillWnd":
			// End:0x409
			if(IsUseRenewalSkillWnd())
			{
				// End:0x3E2
				if(class'UIAPI_WINDOW'.static.IsShowWindow("SkillWnd"))
				{
					class'UIAPI_WINDOW'.static.HideWindow("SkillWnd");
					PlayConsoleSound(closeSound);					
				}
				else
				{
					class'UIAPI_WINDOW'.static.ShowWindow("SkillWnd");
					PlayConsoleSound(openSound);
				}				
			}
			else
			{
				// End:0x438
				if(WNDNameHandle.IsShowWindow())
				{
					WNDNameHandle.HideWindow();
					PlayConsoleSound(closeSound);					
				}
				else
				{
					WNDNameHandle.ShowWindow();
					WNDNameHandle.SetFocus();
					PlayConsoleSound(openSound);
				}
			}
			// End:0x4C2
			break;
		// �⺻ showhide
		Default :
			if(WNDNameHandle.IsShowWindow())
			{
				WNDNameHandle.HideWindow();
				PlayConsoleSound(closeSound);
			}
			else
			{
				WNDNameHandle.ShowWindow();
				WNDNameHandle.SetFocus();
				PlayConsoleSound(openSound);
			}
			break;
	}
}

function toggleShowOptionWnd()
{
	local OptionWnd win;
	win = OptionWnd(GetScript("OptionWnd"));
	win.ToggleOpenMeWnd(false); //�ɼ�â�� ����
}

/**
 * ����Ű â ����
 */
function HandleShowShortcutAssignWnd()
{
	local OptionWnd win;	
	win = OptionWnd(GetScript("OptionWnd"));
	win.ToggleOpenMeWnd(true);  //���� â���� ���� 
}

function HandleToggleShowQuestWNd()
{
	local WindowHandle win;

	// End:0x22
	if(IsAdenServer())
	{
		win = GetWindowHandle("QuestWnd");
	}
	else
	{
		win = GetWindowHandle("QuestTreeWnd");
	}
	Debug("HandleToggleShowQuestWNd " @ win.GetWindowName());
	// End:0x92
	if(win.IsShowWindow())
	{
		win.HideWindow();		
	}
	else
	{
		RequestRequestReceivedPostList();
	}	
}

// ���� ���ɾ ���� â�� ���߰� �����ִ� �Լ� PC�� ����Ʈ
function HandleToggleShowPCCafeEventWnd()
{
}

/**
 * ������ ��ȭ â ����
 */
function HandleShowMovieCaptureWnd()
{
	local bool tmpBool;
	local WindowHandle win;	
	local WindowHandle win1;	

	win = GetWindowHandle("MovieCaptureWnd_Expand");
	win1 = GetWindowHandle("MovieCaptureWnd");

	tmpBool =IsNowMovieCapturing();

	//���� �ǰ� �ִٸ�
	if(tmpBool)
	{
		win.HideWindow();
		//Ȯ�� â�� ���� ���ٸ�
		if (win.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win.HideWindow();
		}
		else 
		{			
			PlayConsoleSound(IFST_WINDOW_OPEN);
			win.ShowWindow();
			win.SetFocus();
		}
	} 
	//�ƴ϶�� �Ϲ� â ���� �ݱ�
	else 
	{
		if (win1.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win1.HideWindow();
		} 
		else
		{	
			PlayConsoleSound(IFST_WINDOW_OPEN);
			win1.ShowWindow();
			win1.SetFocus();

		}
	}	
}

/**
 * ���� â ����
 */
function HandleShowPetitionBegin()
{
	local WindowHandle win;	
	local WindowHandle win1;	
	local WindowHandle win2;	
	local PetitionMethod useNewPetition;

	win = GetWindowHandle("NewUserPetitionWnd");
	win1 = GetWindowHandle("UserPetitionWnd");
	win2 = GetWindowHandle("WebPetitionWnd");

	useNewPetition = GetPetitionMethod();

	if(useNewPetition == PetitionMethod_New)
	{
		if(win.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			RequestShowPetitionAsMethod();
		}
	}
	else if(useNewPetition == PetitionMethod_Default)
	{
		if (win1.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win1.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			win1.ShowWindow();
			win1.SetFocus();
		}
	}
	else if(useNewPetition == PetitionMethod_Web)
	{
		if (win2.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win2.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			RequestShowPetitionAsMethod();
		}
	}
}

/**
 * Ȩ������ ����
 */
function linkHomePage()
{
	class'UICommonAPI'.static.DialogSetID(DIALOGID_Gohome);
	class'UICommonAPI'.static.DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(3208), string(Self));
}

//Ȩ������ ��ũ(10.1.18 ������ �߰�)
function HandleDialogOK()
{	
	if(! class'UICommonAPI'.static.DialogIsOwnedBy(string(Self)))
		return;

	switch(class'UICommonAPI'.static.DialogGetID())
	{
	case DIALOGID_Gohome:
		OpenL2Home();
		break;
	}
}

//��ǰ �κ��丮 ����
function HandleShowProductInventory()
{
	local WindowHandle win;	
	local WindowHandle win1;	
	local L2Util util;
	
	win = GetWindowHandle("ProductInventoryWnd");
	win1 = GetWindowHandle("ShopWnd");
	util = L2Util(GetScript("L2Util"));	

	//�������� �ݱ�
	if(win.isShowWindow())
	{
		PlayConsoleSound(IFST_INVENWND_CLOSE);
		win.HideWindow();
	}
	//�ƴϸ� ����
	else 
	{	
		util.ItemRelationWindowHide("ProductInventoryWnd");

		if(!win1.IsShowWindow())
		{
			PlayConsoleSound(IFST_INVENWND_OPEN);
			win.ShowWindow();
			win.SetFocus();
		}
	}
}

/**
 * ������ ����
 */
function HandleShowPostBoxWnd()
{
	local WindowHandle win;
	win = GetWindowHandle("PostBoxWnd");
	
	if(win.IsShowWindow())
	{
		win.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		RequestRequestReceivedPostList();
	}
}

Function ClosePartyMatchingWnd()
{
	local WindowHandle TaskWnd;
	local PartyMatchWnd p_script;
	p_script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	
	if(CREATE_ON_DEMAND==0)
		TaskWnd = GetHandle("PartyMatchWnd");
	else
		TaskWnd = GetWindowHandle("PartyMatchWnd");

	TaskWnd.HideWindow();
	p_script.OnSendPacketWhenHiding();
}

function HandleShowBBS ()
{
	local string param;

	//if (GetWindowHandle("IngameWebWnd").IsShowWindow())
	//{
	//	GetWindowHandle("IngameWebWnd").HideWindow();
	//	return;
	//}
	param = "";
	ParamAdd(param,"Category","bbs");
	ExecuteEvent(EV_InGameWebWnd_Info,param);
}

function HandleShowHelpHtmlWnd()
{
	local AgeWnd script1;	// ���ǥ�� ��ũ��Ʈ ��������

	//class'HelpWnd'.static.ShowHelp();
	script1 = AgeWnd(GetScript("AgeWnd"));
	// End:0x4C
	if(script1.bBlock == false)
	{
		script1.startAge();
	}
}

function HandlePartyMatchingOnOff()
{
	local WindowHandle PartyMatchRoomWnd;
	local windowHandle PartyMatchWnd;
	local PartyMatchRoomWnd p2_script;
	local L2Util util;

	if (getInstanceUIData().getIsArenaServer()) 
	{
		util = L2Util(GetScript("L2Util"));	
		util.showGfxScreenMessage ( GetSystemMessage (5517)) ;
	}

	PartyMatchWnd = GetWindowHandle("PartyMatchWnd");
	PartyMatchRoomWnd = GetWindowHandle("PartyMatchRoomWnd"); 
	
	
	//class'UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd")
	p2_script = PartyMatchRoomWnd(GetScript("PartyMatchRoomWnd"));

	if(PartyMatchWnd.IsShowWindow())
	{
		ClosePartyMatchingWnd();
	}
	else
	{
		if (PartyMatchRoomWnd.IsShowWindow())
		{					
			PartyMatchRoomWnd.HideWindow();	
			//p2_script.ExitPartyRoom();		
			
			p2_script.OnSendPacketWhenHiding();
			PartyMatchWnd.SetTimer(1991, 500);			
		}
		else
		{	
			class'PartyMatchAPI'.static.RequestOpenPartyMatch();			
		}
	}
}

function OnTimer(int TimerID)
{
	if(TimerID == 1991)
	{		
		ClosePartyMatchingWnd();	
		class'UIAPI_WINDOW'.static.KillUITimer("ShortcutTab",1991); 		
	}
}

function HandleShortcutCommand(String a_Param)
{
	local String Command;
	
	if(ParseString(a_Param, "Command", Command))
	{
		switch(Command)
		{
			case "CloseAllWindow":		// alt + w
				HandleCloseAllWindow();
				break;
			case "ShowChatWindow":		// alt + j
			
				HandleShowChatWindow();
				//if (m_chatstateok == true)
				//{
				//	HandleShowChatWindow();
				//}
				break;
			case "SetPrevChatType":		// alt + page up	
			HandleSetPrevChatType();
			break;
			case "SetNextChatType":		// alt + page down
			HandleSetNextChatType();
			break;
			case "shortcutreset":
			class'ShortcutAPI'.static.RestoreDefault();
			break;
			case "shortcutsave":
			class'ShortcutAPI'.static.Save();
			break;
			case "shortcutload":
			class'ShortcutAPI'.static.RequestList();
			break;
			case "test":
			HandleShortcutTest();
			break;
			case "printshortcut":
			HandlePrintShortcut();
			break;

			case "getPrevTarget" :if (getInstanceUIData().getIsArenaServer()) ExecuteCommand("/targetPrev") ; break;
			case "getNextTarget" :if (getInstanceUIData().getIsArenaServer()) ExecuteCommand("/targetNext") ; break;
			case "useRunSkill" : if (getInstanceUIData().getIsArenaServer()) setUseSkill (18651)  ;break;		
			case "useBaseRecallSkill" : if (getInstanceUIData().getIsArenaServer()) setUseSkill (18652) ; break;

			case "AutoPlay":
				if (getInstanceUIData().getIsLiveServer())
				{
					AutoUseItemWnd(GetScript("AutoUseItemWnd")).OnClickButton("AutoTargetAll_BTN");
				}
				else
				{
					YetiQuickSlotWnd(GetScript("YetiQuickSlotWnd")).OnAutoHunt_All_BtnClick();
				}
			break;
			// End:0x2A8
			case "HideAllWindow":
				//Debug("HandleShortcutCommand" @ a_Param) ;
				HandleHideAllWindow();
		}
	}
}

function setUseSkill (int skillID) 
{
	local itemID skillItemID;
	skillItemID.ClassID = skillID;
	Debug ("setUseSkill" @ skillItemID.ClassID) ;
	UseSkill(skillItemID, int(EShortCutItemType.SCIT_SKILL));
}


function HandleHideAllWindow()
{

}

function HandlePrintShortcut()
{
	local Array<ShortcutCommandItem> commandlist;
	local Array<string> grouplist;
	local int i;
	class'ShortcutAPI'.static.GetGroupList(groupList);
	for(i = 0 ; i < grouplist.Length ; ++i)
	{
		//debug("Group : " $ grouplist[i]);
		commandlist.Length = 0;
		class'ShortcutAPI'.static.GetGroupCommandList(grouplist[i], commandlist);
		//for(j=0 ; j < commandlist.Length ; ++j)
			//debug("key : " $ commandlist[j].Key $ ", subkey1 : " $ commandlist[j].subkey1 $ ", subkey2 : " $ commandlist[j].subkey2 $ ", action : " $ commandlist[j].sAction $ ", command : " $ commandlist[j].sCommand $ ", id : " $ commandlist[j].id);
	}
	grouplist.Length = 0;
	class'ShortcutAPI'.static.GetActiveGroupList(grouplist);
	for(i=0 ; i<grouplist.Length ; ++i)
	{
		//debug("ActiveGroup : " $ grouplist[i]);
	}
}

function HandleForceShowChatWindow (bool bOpen)
{
	local WindowHandle Handle;
	local int tempVars;

	Handle = GetWindowHandle("ChatWnd");
	if (bOpen)
	{
		Handle.ShowWindow();
		GetINIBool("global","SystemMsgWnd",tempVars,"chatfilter.ini");
		if (bool(tempVars))
		{
			if (getInstanceUIData().getIsLiveServer())
			{
				Class'UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");
			}
		}
	}
	else
	{
		Handle.HideWindow();
		GetINIBool("global","SystemMsgWnd",tempVars,"chatfilter.ini");
		if (!bool(tempVars))
		{
			Class'UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
		}
	}
}

//~ function HandleShortcutTest()
//~ {
	//~ local ShortcutCommandItem item;
	//~ local array<ShortcutCommandItem> items;
	//~ local int i;
	//~ item.sCommand = "ZoomIn";
	//~ item.key = "MouseWheelUp";
	//~ item.subkey1 = "";
	//~ item.subkey2 = "";
	//~ item.sState = "GamingState";
	//~ if(class'ShortcutAPI'.static.AssignShortcut(item))
		//~ Log("ShortcutAssign Success ZoomIn");
	//~ item.sCommand = "ZoomOut";
	//~ item.key = "MouseWheelDown";
	//~ item.subkey1 = "";
	//~ item.subkey2 = "";
	//~ item.sState = "GamingState";
	//~ if(class'ShortcutAPI'.static.AssignShortcut(item))
		//~ Log("ShortcutAssign Success ZoomOut");
	//~ item.sCommand = "TurnBack";
	//~ item.key = "MiddleMouse";
	//~ item.subkey1 = "";
	//~ item.subkey2 = "";
	//~ item.sState = "GamingState";
	//~ if(class'ShortcutAPI'.static.AssignShortcut(item))
		//~ Log("ShortcutAssign Success TurnBack");

	//~ item.sCommand = "ShowInventoryWindow";
	//~ item.key = "i";
	//~ item.subkey1 = "alt";
	//~ item.subkey2 = "";
	//~ item.sState = "GamingState";
	//~ if(class'ShortcutAPI'.static.AssignShortcut(item))
		//~ Log("ShortcutAssign Success TurnBack ShowInventoryWindow");

	//~ item.sCommand = "PKKey";
	//~ item.key = "Ctrl";
	//~ item.subkey1 = "";
	//~ item.subkey2 = "";
	//~ item.sState = "";
	//~ item.sCategory = "";
	//~ if(class'ShortcutAPI'.static.AssignSpecialKey(item))
		//~ Log("SpecialKeyAssign Success PKKey");

	//~ class'ShortcutAPI'.static.GetCommandItems(items);
	//~ for(i=0 ; i<items.Length ; ++i)
	//~ {
		//~ Log("Shortcut " $ i $ ": key(" $ items[i].key $ "), subkey1(" $ items[i].subkey1 $ "), subkey2(" $ items[i].subkey2 $ "), command(" $ items[i].sCommand $ "), state(" $ items[i].sState $ "), category(" $ items[i].sCategory $ ")");
	//~ }
//~ }

function HandleShortcutTest()
{
}

/*
 * rollback chatmessage > chatWnd 2012.11.01
 */
function HandleShowChatWindow()		// alt + j
{
	local WindowHandle handle;
	local int tempVars;

	handle = GetWindowHandle("ChatWnd");
	
	if(handle.IsShowWindow())
	{
		handle.HideWindow();
		GetINIBool("global", "SystemMsgWnd", tempVars, "chatfilter.ini");
		
		if(!bool(tempVars))
		{
			class'UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
		}
			
	}
	else
	{
		handle.ShowWindow();
		GetINIBool("global", "SystemMsgWnd", tempVars, "chatfilter.ini");
		
		if(bool(tempVars))
		{
			if (getInstanceUIData().getIsLiveServer())
				class'UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");
		}
	}

	/* chatMessage ��

	local WindowHandle handle;

	if(CREATE_ON_DEMAND==0)
		handle = GetHandle("ChatMessage");
	else
		handle = GetWindowHandle("ChatMessage");
	
	if(handle.IsShowWindow())
	{
		handle.HideWindow();
			
	}
	else
	{
		handle.ShowWindow();
	}
	*/
}



function HandleSetPrevChatType()		// alt + page up
{	
	/*
	 *rollback chatmessage > chatWnd
	 
	callGFxFunction("ChatMessage","setRemoteTabSelect", "true");
	*/
	
	local ChatWnd chatWndScript;			// ä�� ������ Ŭ����
	
	chatWndScript = ChatWnd(GetScript("ChatWnd"));	// ��ũ��Ʈ�� �����´�.
	
	//debug("chatWndScript.m_chatType" $ chatWndScript.m_chatType);
	switch (chatWndScript.m_chatType.UI)	
	{
		case CHAT_WINDOW_NORMAL:
			////chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_NORMAL);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_TRADE);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_PARTY);
			////chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_CLAN);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_ALLY);
			chatWndScript.ChatTabCtrl.SetTopOrder(4, true);
			chatWndScript.HandleTabClick("ChatTabCtrl4");
			break;
		case CHAT_WINDOW_TRADE:
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_NORMAL);
			////chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_TRADE);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_PARTY);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_CLAN);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_ALLY);
			chatWndScript.ChatTabCtrl.SetTopOrder(0, true);
			chatWndScript.HandleTabClick("ChatTabCtrl0");
			break;
		case CHAT_WINDOW_PARTY:
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_NORMAL);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_TRADE);
			////chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_PARTY);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_CLAN);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_ALLY);
			chatWndScript.ChatTabCtrl.SetTopOrder(1, true);
			chatWndScript.HandleTabClick("ChatTabCtrl1");
			break;
		case CHAT_WINDOW_CLAN:
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_NORMAL);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_TRADE);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_PARTY);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_CLAN);
			////chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_ALLY);
			chatWndScript.ChatTabCtrl.SetTopOrder(2, true);
			chatWndScript.HandleTabClick("ChatTabCtrl2");
			break;
		case CHAT_WINDOW_ALLY:
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_NORMAL);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_TRADE);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_PARTY);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_CLAN);
			////chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_ALLY);
			chatWndScript.ChatTabCtrl.SetTopOrder(3, true);
			chatWndScript.HandleTabClick("ChatTabCtrl3");
			break;		
	}
}

function HandleSetNextChatType()		// alt + page down
{
	/*
	 *rollback chatmessage > chatWnd
	 
	callGFxFunction("ChatMessage","setRemoteTabSelect", "false");
	*/

	local ChatWnd chatWndScript;			// ä�� ������ Ŭ����
	
	chatWndScript = ChatWnd(GetScript("ChatWnd"));	// ��ũ��Ʈ�� �����´�.
	
	//debug("chatWndScript.m_chatType" $ chatWndScript.m_chatType);
	switch (chatWndScript.m_chatType.UI)	
	{
		case CHAT_WINDOW_NORMAL:
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_NORMAL);
			////chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_TRADE);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_PARTY);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_CLAN);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_ALLY);
			chatWndScript.ChatTabCtrl.SetTopOrder(1, true);
			chatWndScript.HandleTabClick("ChatTabCtrl1");
			break;
		case CHAT_WINDOW_TRADE:
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_NORMAL);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_TRADE);
			////chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_PARTY);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_CLAN);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_ALLY);
			chatWndScript.ChatTabCtrl.SetTopOrder(2, true);
			chatWndScript.HandleTabClick("ChatTabCtrl2");
			break;
		case CHAT_WINDOW_PARTY:
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_NORMAL);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_TRADE);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_PARTY);
			////chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_CLAN);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_ALLY);
			chatWndScript.ChatTabCtrl.SetTopOrder(3, true);
			chatWndScript.HandleTabClick("ChatTabCtrl3");
			break;
		case CHAT_WINDOW_CLAN:
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_NORMAL);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_TRADE);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_PARTY);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_CLAN);
			////chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_ALLY);
			chatWndScript.ChatTabCtrl.SetTopOrder(4, true);
			chatWndScript.HandleTabClick("ChatTabCtrl4");
			break;
		case CHAT_WINDOW_ALLY:
			////chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_NORMAL);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_TRADE);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_PARTY);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_CLAN);
			//chatWndScript.ChatTabCtrl.MergeTab(CHAT_WINDOW_ALLY);
			chatWndScript.ChatTabCtrl.SetTopOrder(0, true);
			chatWndScript.HandleTabClick("ChatTabCtrl0");
			break;		
	}
}

// alt + w
function HandleCloseAllWindow()
{
	local WindowHandle handle;
	local int i;
	local array<string> WndList;
	local array<string> GFxWndList;
	
	local PrivateShopWnd PrivateShopWndScript;
	local ItemAutoPeelWnd ItemAutoPeelScript;

	/*
	 *2012.12.12 �����Ǹ� â�� alt W�� ���� �� ���� �߻�
	 */
	PrivateShopWndScript = PrivateShopWnd(GetScript("PrivateShopWnd"));
	PrivateShopWndScript.RequestQuit();

	ItemAutoPeelScript = ItemAutoPeelWnd(GetScript("ItemAutoPeelWnd"));
	ItemAutoPeelScript.CloseWindow();
	// End:0xE1
	if(class'UIDATA_PLAYER'.static.IsInDethrone() == false)
	{
		class'RecipeAPI'.static.RequestRecipeShopManageQuit();
		Debug("--> RequestRecipeShopManageQuit");
		class'EnchantAPI'.static.RequestExCancelEnchantItem();
		Debug("--> RequestExCancelEnchantItem");
	}
	WndList[WndList.Length] = "ActionWnd";
	WndList[WndList.Length] = "AttributeEnchantWnd";
	WndList[WndList.Length] = "AttributeRemoveWnd";
	WndList[WndList.Length] = "BoardWnd";
	WndList[WndList.Length] = "CalculatorWnd";
	WndList[WndList.Length] = getWindowNameByServerType ("ClanWnd");
	WndList[WndList.Length] = "ConsoleWnd";
	WndList[WndList.Length] = "CouponEventWnd";
	WndList[WndList.Length] = "DeliverWnd";
	WndList[WndList.Length] = "SelectDeliverWnd";
	WndList[WndList.Length] = getWindowNameByServerType ("DetailStatusWnd");
	WndList[WndList.Length] = "MailBtnWnd";
	WndList[WndList.Length] = "HelpHtmlWnd";
	WndList[WndList.Length] = "HelpWnd";
	WndList[WndList.Length] = "HennaInfoWnd";
	WndList[WndList.Length] = "HennaListWnd";

	WndList[WndList.Length] = "HennaInfoWndLive";
	WndList[WndList.Length] = "HennaListWndLive";
	WndList[WndList.Length] = "HennaEngraveWndLive";

	WndList[WndList.Length] = "HeroTowerWnd";
	WndList[WndList.Length] = "HeroTowerWndWorld";
	WndList[WndList.Length] = "InventoryWnd";
	WndList[WndList.Length] = "ItemEnchantWnd";
	WndList[WndList.Length] = "XMasSealWnd";
	WndList[WndList.Length] = "MacroEditWnd";
	WndList[WndList.Length] = "MacroListWnd";
	WndList[WndList.Length] = "MagicSkillWnd";
	//WndList[WndList.Length] = "MainWnd";
	WndList[WndList.Length] = "ManorCropInfoChangeWnd";
	WndList[WndList.Length] = "ManorCropInfoSettingWnd";
	WndList[WndList.Length] = "ManorCropSellChangeWnd";
	WndList[WndList.Length] = "ManorCropSellWnd";
	//WndList[WndList.Length] = "ManorInfo_Crop";
	//WndList[WndList.Length] = "ManorInfo_Default";
	//WndList[WndList.Length] = "ManorInfo_Seed";
	WndList[WndList.Length] = "ManorInfoWnd";
	WndList[WndList.Length] = "ManorSeedInfoChangeWnd";
	WndList[WndList.Length] = "ManorSeedInfoSettingWnd";
	WndList[WndList.Length] = "ManorShopWnd";
	//WndList[WndList.Length] = "MinimapWnd";
	//WndList[WndList.Length] = "MinimapWnd_Expand";
	//WndList[WndList.Length] = "MoviePlayerWnd";
	WndList[WndList.Length] = "MultiSellWnd";
	WndList[WndList.Length] = "OptionWnd";
	WndList[WndList.Length] = "PetitionFeedBackWnd";
	WndList[WndList.Length] = "PetitionWnd";
	WndList[WndList.Length] = "UserPetitionWnd";
	WndList[WndList.Length] = "PetWnd";
	WndList[WndList.Length] = "PetWndClassic";
	WndList[WndList.Length] = "PrivateShopWnd";
	WndList[WndList.Length] = "QuestListWnd";
	WndList[WndList.Length] = "QuestTreeWnd";	
	WndList[WndList.Length] = "RecipeBookWnd";
	WndList[WndList.Length] = "RecipeBuyListWnd";
	WndList[WndList.Length] = "RecipeBuyManufactureWnd";
	WndList[WndList.Length] = "RecipeManufactureWnd";
	WndList[WndList.Length] = "RecipeShopWnd";
	WndList[WndList.Length] = "RecipeTreeWnd";
	WndList[WndList.Length] = "RefineryWnd";
	WndList[WndList.Length] = "ReplayListWnd";
	WndList[WndList.Length] = "ReplayLogoWnd";
	//WndList[WndList.Length] = "ScenePlayerWnd";
	WndList[WndList.Length] = "ShopWnd";
	WndList[WndList.Length] = "SiegeInfoWnd";
	//WndList[WndList.Length] = "SkillEnchantInfoWnd";
	//WndList[WndList.Length] = "SkillEnchantWnd";
	//WndList[WndList.Length] = "SSQMainBoard";
	//WndList[WndList.Length] = "SSQMainBoard_SSQMainEventWnd";
	//WndList[WndList.Length] = "SSQMainBoard_SSQSealStatusWnd";
	//WndList[WndList.Length] = "SSQMainBoard_SSQStatusWnd";
	WndList[WndList.Length] = "SummonedWnd";
	//WndList[WndList.Length] = "SystemMenuWnd";
	WndList[WndList.Length] = "TownMapWnd";
	WndList[WndList.Length] = "TradeWnd";
	WndList[WndList.Length] = "SkillTrainClanTreeWnd";
	//WndList[WndList.Length] = "SkillTrainInfoSubWndEnchant";
	//WndList[WndList.Length] = "SkillTrainInfoSubWndNormal";
	WndList[WndList.Length] = "SkillTrainInfoWnd";
	WndList[WndList.Length] = "SkillTrainListWnd";
	WndList[WndList.Length] = "TutorialViewerWnd";
	WndList[WndList.Length] = "unrefineryWnd";
	WndList[WndList.Length] = "WarehouseWnd";

	//��Ƽ ��Ī
	WndList[WndList.Length] = "PartyMatchWnd";
	//�θ�
	WndList[WndList.Length] = "PersonalConnectionsWnd";
	
	//2012.12.17 â ��� �߰� 
	WndList[WndList.Length] = "NPCDialogWnd";
	WndList[WndList.Length] = "PostBoxWnd";
	WndList[WndList.Length] = "NewUserPetitionWnd";
	WndList[WndList.Length] = "ProductInventoryWnd";
	WndList[WndList.Length] = "GiftInventoryWnd";
	//2013.01.03 â ��� �߰� > ��� �� ������ �ʴ� â ��� �Դϴ�.
	WndList[WndList.Length] = "AuctionWnd";
	WndList[WndList.Length] = "BlockCurWnd";
	WndList[WndList.Length] = "BlockEnterWnd";
	WndList[WndList.Length] = "CleftEnterWnd";
	WndList[WndList.Length] = "CleftCurWnd";
	WndList[WndList.Length] = "ColorNickNameWnd";
	WndList[WndList.Length] = "DominionWarInfoWnd";
	WndList[WndList.Length] = "FileRegisterWnd";
	WndList[WndList.Length] = "KillPointRankWnd";
	WndList[WndList.Length] = "MagicskillGuideWnd";
	WndList[WndList.Length] = "miniGame1Wnd";
	WndList[WndList.Length] = "NewPetitionWnd";
	//�ؿ� ��� ���� Ȯ�� �ʿ�
	WndList[WndList.Length] = "PetitionFeedBackWnd";
	WndList[WndList.Length] = "PostWriteWnd";
	WndList[WndList.Length] = "PremiumItemGetWnd";
	WndList[WndList.Length] = "PVPDetailedWnd";
	WndList[WndList.Length] = "QuesthtmlWnd";
	WndList[WndList.Length] = "SeedShopWnd";
	WndList[WndList.Length] = "SellingAgencyWnd";
	WndList[WndList.Length] = "TeleportBookMarkWnd";
	WndList[WndList.Length] = "WebPetitionWnd";
	//2013.08.22 ���Ӱ���â �߰�
	WndList[WndList.Length] = "IngameNoticeWnd";
	//2013.09.09 �꿤 ��þ â �߰�
	WndList[WndList.Length] = "ItemJewelEnchantWnd";
	//���� �̿� ���� ������
	WndList[WndList.Length] = "PlayerAgeWnd";
		// path to awaken 
	if (GetLanguage() != 0)
		WndList[WndList.Length] = "BR_PathWnd";
	// ������ ����
	WndList[WndList.Length] = "ToDoListWnd";
	// ������ ���� ����
	WndList[WndList.Length] = "ToDoListClanWnd";
	//�κ��丮 ���� ������
	WndList[WndList.Length] = "InventoryViewer";
	// ��ȥ 
	WndList[WndList.Length] = "EnsoulWnd";
	WndList[WndList.Length] = "AttendCheckWnd";
	WndList[WndList.Length] = "SiegeReportWnd";
	WndList[WndList.Length] = "AgitDecoWnd";
	WndList[WndList.Length] = "MonsterArenaResultWnd";
	WndList[WndList.Length] = "MacroPresetWnd";
	WndList[WndList.Length] = "IngameWebWnd";
	WndList[WndList.Length] = "MonsterBookDetailedInfo";
	WndList[WndList.Length] = "PrivateShopWndHistory";
	WndList[WndList.Length] = "ItemLockWnd";
	WndList[WndList.Length] = "OlympiadWnd";
	WndList[WndList.Length] = "OlympiadRandomChallengeWnd";
	WndList[WndList.Length] = "RestartMenuWndReportDamage";
	WndList[WndList.Length] = "RestartMenuWndReportLostItem";
	WndList[WndList.Length] = "TimeZoneWnd";
	WndList[WndList.Length] = "RankingWnd";
	WndList[WndList.Length] = "AutoPotionSubWnd";
	WndList[WndList.Length] = "AutoShotItemWnd";
	WndList[WndList.Length] = "AutoUseItemInventory";
	WndList[WndList.Length] = "SiegeCastleInfoWnd";
	WndList[WndList.Length] = "SiegeWnd";
	WndList[WndList.Length] = "SiegeMercenaryWnd";
	WndList[WndList.Length] = "SiegeInfoMCWWnd";
	WndList[WndList.Length] = "EventletterCollectorWnd";
	WndList[WndList.Length] = "RandomCraftChargingWnd";
	WndList[WndList.Length] = "RandomCraftWnd";
	WndList[WndList.Length] = "MenuEntireWnd";
	WndList[WndList.Length] = "FortressBattleInfoWnd";
	WndList[WndList.Length] = "LocationShareWnd";
	WndList[WndList.Length] = "MoveLocationWnd";
	WndList[WndList.Length] = "MarbleGameWnd";
	WndList[WndList.Length] = "HomunculusWnd";
	WndList[WndList.Length] = "PetExtractWnd";
	WndList[WndList.Length] = "UIControlContextMenu";
	WndList[WndList.Length] = "RestoreLostPropertyWnd";
	WndList[WndList.Length] = "SuppressWnd";
	WndList[WndList.Length] = "SuppressDrawWnd";
	WndList[WndList.Length] = "BlackCouponWnd";
	WndList[WndList.Length] = "InfoFightWndClassic";
	WndList[WndList.Length] = "ClanShopWndClassic";
	WndList[WndList.Length] = "DethroneCharacterCreatewnd";
	WndList[WndList.Length] = "DethroneWnd";
	WndList[WndList.Length] = "DethroneResultWnd";
	WndList[WndList.Length] = "ColorNickNameWndClassic";
	WndList[WndList.Length] = "PrivateShopFindWnd";
	WndList[WndList.Length] = "HennaEnchantWnd";
	WndList[WndList.Length] = "HennaMenuWnd";
	WndList[WndList.Length] = "WorldSiegeBoardWnd";
	WndList[WndList.Length] = "WorldSiegeInfoMCWWnd";
	WndList[WndList.Length] = "WorldSiegeMercenaryWnd";
	WndList[WndList.Length] = "WorldSiegeRankingWnd";
	WndList[WndList.Length] = "WorldSiegeWnd";
	WndList[WndList.Length] = "HennaDyeEnchantWnd";
	WndList[WndList.Length] = "ItemMultiEnchantWnd";
	WndList[WndList.Length] = "WorldExchangeRegiWnd";
	WndList[WndList.Length] = "WorldExchangeBuyWnd";
	WndList[WndList.Length] = "HeroBookWnd";
	WndList[WndList.Length] = "HeroBookCraftChargingWnd";
	WndList[WndList.Length] = "TeleportWnd";
	WndList[WndList.Length] = "MultiSellItemExchangeWnd";
	WndList[WndList.Length] = "AbilityUIWnd";
	WndList[WndList.Length] = "RevengeWnd";
	WndList[WndList.Length] = "QuestAcceptableListWnd";
	WndList[WndList.Length] = "DethroneFireStateWnd";
	WndList[WndList.Length] = "DethroneFireEnchantWnd";
	if(IsUseRenewalSkillWnd())
	{
		WndList[WndList.Length] = "SkillWnd";
		WndList[WndList.Length] = "SkillSpExtractWnd";
		WndList[WndList.Length] = "SkillEnchantWnd";
	}
	if(IsAdenServer())
	{
		WndList[WndList.Length] = "MagicLampWnd";
	}
	WndList[WndList.Length] = "QuestWnd";
	//WndList[79]="ShortcutAssignWnd"; //�ɼǰ� ���� 2012.3.27
	
	for (i=0;i<WndList.Length; ++i)
	{			
		handle = GetWindowHandle(WndList[i]);
		if (WndList[i] == "");
		if(handle.IsShowWindow())
        {
			// End:0x1537
			if(handle.GetWindowName() == "RefineryWnd")
			{
				RefineryWnd(GetScript("RefineryWnd")).OnClickButton("exitbutton");
				// [Explicit Continue]
				continue;
			}
			handle.HideWindow();
        }
	}
	
	//2012.12.17 Gfx â ��� �߰� 
	GFxWndList[GFxWndList.Length] = "ClanSearch";
	GFxWndList[GFxWndList.Length] = "InstancedZoneHistoryWnd";
	GFxWndList[GFxWndList.Length] = "OptionWnd";
	GFxWndList[GFxWndList.Length] = "CardExchange";
	GFxWndList[GFxWndList.Length] = "CardExchangeB";
	GFxWndList[GFxWndList.Length] = "CardExchangeC";
	GFxWndList[GFxWndList.Length] = "AdenaDistributionWnd";
	GFxWndList[GFxWndList.Length] = "AlchemyMixCubeWnd";
	GFxWndList[GFxWndList.Length] = "AlchemyOpener";
	GFxWndList[GFxWndList.Length] = "AlchemyItemConversionWnd";
	GFxWndList[GFxWndList.Length] = "FactionWnd";
	GFxWndList[GFxWndList.Length] = "VipInfoWnd";
	GFxWndList[GFxWndList.Length] = "IngameShopWnd";
	GFxWndList[GFxWndList.Length] = "LuckyGame";
	GFxWndList[GFxWndList.Length] = "MonsterBookWnd";
	GFxWndList[GFxWndList.Length] = "MiniMapGFxWnd";
	GFxWndList[GFxWndList.Length] = "EventInfoWnd";
	GFxWndList[GFxWndList.Length] = "CardDrawEventWnd";
	GFxWndList[GFxWndList.Length] = "ArenaRankingWnd";
	GFxWndList[GFxWndList.Length] = "ClanRaidsWnd";
	GFxWndList[GFxWndList.Length] = "ClanGfxWnd";
	GFxWndList[GFxWndList.Length] = "ElementalSpiritWnd";
	GFxWndList[GFxWndList.Length] = "JobChangeWnd";
	GFxWndList[GFxWndList.Length] = "RankingHistoryWnd";
	GFxWndList[GFxWndList.Length] = "MiniMapGfxWnd";
	GFxWndList[GFxWndList.Length] = "ShopLcoinWnd";
	GFxWndList[GFxWndList.Length] = "ShopLcoinCraftWnd";

	for (i=0 ; i< GFxWndList.length ; i++)
	{
		if (class'UIAPI_WINDOW'.static.IsShowWindow (GFxWndList[i]))
		{
			if ( GFxWndList[i]  == "AdenaDistributionWnd")
			{
				//�Ƶ��� �й� â�� ���� ���� ���� �� alt + W�� ��� �ϰ� �Ǹ�, 
				CallGFxFunction("AdenaDistributionWnd", "RequestDivideAdenaCancel", "");
			}
			class'UIAPI_WINDOW'.static.HideWindow(GFxWndList[i]);
		}
	}
}

function HandleStateChange(String state)
{
	local FlightShipCtrlWnd scriptShip;
	local FlightTransformCtrlWnd scriptTrans;
	//local	MainMenu	                scriptMain;		

	scriptShip = FlightShipCtrlWnd(GetScript("FlightShipCtrlWnd"));
	scriptTrans = FlightTransformCtrlWnd(GetScript("FlightTransformCtrlWnd"));
	//scriptMain = MainMenu (GetScript("MainMenu"));
	
	if(state == "GAMINGSTATE")
	{	
		if(GetChatFilterBool("Global", "EnterChatting")) // GetOptionBool("Game", "EnterChatting"));
		{
			class'ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
		}
		
		// ���� ���̴� �ε������� �߰�
		if(scriptShip.isNowActiveFlightShipShortcut) 	// ������ ���� �����		
		{
			if( GetChatFilterBool ("Global", "EnterChatting"))	{class'ShortcutAPI'.static.DeactivateGroup("TempStateShortcut");}
			class'ShortcutAPI'.static.ActivateGroup("FlightStateShortcut");
			//scriptMain.changeEnterChat("FlightStateShortcut");
		}
		else if (scriptTrans.isNowActiveFlightTransShortcut) // ���� ����ü �����
		{
			
			if( GetChatFilterBool ("Global", "EnterChatting"))	{class'ShortcutAPI'.static.DeactivateGroup("TempStateShortcut");}
			class'ShortcutAPI'.static.ActivateGroup("FlightTransformShortcut");
			//scriptMain.changeEnterChat("FlightTransformShortcut");
		}		
	}
}

defaultproperties
{
}
