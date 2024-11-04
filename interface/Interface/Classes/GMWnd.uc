class GMWnd extends UICommonAPI;

// Sets Timer Value
//const TIMER_ID=777; 
//const TIMER_DELAY=1000; 


const DIALOGID_Recall = 0;
const DIALOGID_SendHome = 1;

var private Color m_WhiteColor;
var private EditBoxHandle m_hEditBox;
var private WindowHandle m_hGMwnd;
var private WindowHandle m_hGMDetailStatusWnd;
var private WindowHandle m_hGMInventoryWnd;
var private WindowHandle m_hGMMagicSkillWnd;
var private WindowHandle m_hGMQuestWnd;
var private WindowHandle m_hGMWarehouseWnd;
var private WindowHandle m_hGMClanWnd;
//diff_elsacred_s
var private WindowHandle m_hGMFindTreeWnd;
var private WindowHandle m_dialogWnd;
var private ComboBoxHandle m_hCbClassName;
var private ComboBoxHandle Race_ComboBox;
var private ComboBoxHandle Sex_ComboBox;
//diff_elsacred_e
var private int m_targetID;
var private int m_TargetClass;

private function InitHandle()
{
	m_hGMwnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath);
	m_hEditBox = GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EditBox");
	m_hGMDetailStatusWnd = GetWindowHandle("GMDetailStatusWnd");
	m_hGMInventoryWnd = GetWindowHandle("GMInventoryWnd");
	m_hGMMagicSkillWnd = GetWindowHandle("GMMagicSkillWnd");
	m_hGMQuestWnd = GetWindowHandle("GMQuestWnd");
	m_hGMWarehouseWnd = GetWindowHandle("GMWarehouseWnd");
	m_hGMClanWnd = GetWindowHandle("GMClanWnd");

	m_hGMFindTreeWnd = GetWindowHandle("GMFindTreeWnd");
	m_dialogWnd = GetWindowHandle("DialogBox");
	m_hCbClassName = GetComboBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".cbClassName");
	InitRaceCombobox();
	InitSexCombobox();
}

private function InitRaceCombobox()
{
	Race_ComboBox = GetComboBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Race_ComboBox");
	Race_ComboBox.AddStringWithReserved(GetSystemString(2705) @ GetSystemString(175), 0);
	Race_ComboBox.AddStringWithReserved(GetSystemString(2705) @ GetSystemString(176), 10);
	Race_ComboBox.AddStringWithReserved(GetSystemString(171) @ GetSystemString(175), 18);
	Race_ComboBox.AddStringWithReserved(GetSystemString(171) @ GetSystemString(176), 25);
	Race_ComboBox.AddStringWithReserved(GetSystemString(172) @ GetSystemString(175), 31);
	Race_ComboBox.AddStringWithReserved(GetSystemString(172) @ GetSystemString(176), 38);
	Race_ComboBox.AddStringWithReserved(GetSystemString(173) @ GetSystemString(175), 44);
	Race_ComboBox.AddStringWithReserved(GetSystemString(173) @ GetSystemString(176), 49);
	Race_ComboBox.AddStringWithReserved(GetSystemString(174), 53);
	// End:0x278
	if(getInstanceUIData().getIsClassicServer())
	{
		Race_ComboBox.AddStringWithReserved(GetSystemString(1544), 192);
		Race_ComboBox.AddStringWithReserved(GetSystemString(13536), 208);
		Race_ComboBox.AddStringWithReserved("-----------------------", -1);
		Race_ComboBox.AddStringWithReserved(GetSystemString(2705) @ GetSystemString(13221), 196);
		Race_ComboBox.AddStringWithReserved(GetSystemString(171) @ GetSystemString(13221), 200);
		Race_ComboBox.AddStringWithReserved(GetSystemString(172) @ GetSystemString(13221), 204);
		Race_ComboBox.AddStringWithReserved(GetSystemString(173) @ GetSystemString(14043), 217);		
	}
	else
	{
		Race_ComboBox.AddStringWithReserved(GetSystemString(1561), 123);
		Race_ComboBox.AddStringWithReserved(GetSystemString(1562), 124);
		Race_ComboBox.AddStringWithReserved(GetSystemString(3273) @ GetSystemString(175), 182);
		Race_ComboBox.AddStringWithReserved(GetSystemString(3273) @ GetSystemString(176), 183);
		Race_ComboBox.AddStringWithReserved("-----------------------", -1);
		Race_ComboBox.AddStringWithReserved(GetSystemString(13221), 212);
	}
}

private function InitSexCombobox()
{
	Sex_ComboBox = GetComboBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Sex_ComboBox");
	Sex_ComboBox.SYS_AddStringWithReserved(177, 0);
	Sex_ComboBox.SYS_AddStringWithReserved(178, 1);
}

event OnRegisterEvent()
{
	RegisterEvent( EV_ShowGMWnd );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
	RegisterEvent( EV_TargetUpdate );
}

event OnLoad()
{
	SetClosingOnESC();
	InitHandle();

	m_WhiteColor.R = 220;
	m_WhiteColor.G = 220;
	m_WhiteColor.B = 220;
	m_WhiteColor.A = 255;
	m_targetID = 0;
}

event OnTick()
{
	local UserInfo uInfo;

	// End:0x26
	if(! GetUserInfo(m_targetID, uInfo))
	{
		m_hOwnerWnd.DisableTick();
		return;
	}
	// End:0x5F
	if(m_TargetClass != uInfo.nSubClass)
	{
		m_TargetClass = uInfo.nSubClass;
		SetClassTypeComboBox();
		m_hOwnerWnd.DisableTick();
	}	
}

event OnComboBoxItemSelected(string strID, int IndexID)
{
	switch(strID)
	{
		// End:0x27
		case "Race_ComboBox":
			SetRace(IndexID);
			// End:0x67
			break;
		// End:0x46
		case "Sex_ComboBox":
			SetSex(IndexID);
			// End:0x67
			break;
		// End:0x64
		case "cbClassName":
			SetClass(IndexID);
			// End:0x67
			break;
		// End:0xFFFF
		default:
			break;
	}	
}

event OnEvent(int a_EventID, String a_Param)
{
	switch(a_EventID)
	{
		case EV_ShowGMWnd:
			HandleShowGMWnd();
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
		case EV_DialogCancel:
			HandleDialogCancel();
			break;
		case EV_TargetUpdate:
			HandleTargetUpdate();
			break;
	}
}

event OnHide()
{
	class'ChatWnd'.static.Inst()._HandleHideDevTool();	
}

event OnShow()
{
	HandleTargetUpdate();
	checkVisibleLockButton();
	class'ChatWnd'.static.Inst()._HandleShowDevTool();
}

event OnClickButton(String a_ButtonID)
{
	switch(a_ButtonID)
	{
		case "MsgSearchButton":
			onClickMsgSearchButton();
			break;

		case "TeleButton":
			OnClickTeleButton();
			break;
		case "MoveButton":
			OnClickMoveButton();
			break;
		case "RecallButton":
			OnClickRecallButton();
			break;
		case "DetailStatusButton":
			OnClickDetailStatusButton();
			break;
		case "InventoryButton":
			OnClickInventoryButton();
			break;
		case "MagicSkillButton":
			OnClickMagicSkillButton();
			break;
		case "InfoButton":
			OnClickInfoButton();
			break;
		case "StoreButton":
			OnClickStoreButton();
			break;
		case "ClanButton":
			OnClickClanButton();
			break;
		case "PetitionButton":
			OnClickPetitionButton();
			break;
		case "SendHomeButton":
			OnClickSendHomeButton();
			break;
		case "NPCListButton":
			OnClickNPCListButton();
			break;
		case "ItemListButton":
			OnClickItemListButton();
			break;
		case "SkillListButton":
			OnClickSkillListButton();
			break;
		case "ForcePetitionButton":
			OnClickForcePetitionButton();
			break;
		case "ChangeServerButton":
			OnClickChangeServerButton();
			break;
		case "UIButton":
			OnClickUIButton();
			break;
		case "QuestListButton":
			OnClickQuestListButton();
			break;
		case "TargettingButton":
			OnClickTargetButton();
			break;
		case "ClassChangeButton":
			OnClickClassChangeButton();
			break;
		case "LockBtn" :
		case "UnLockBtn" :
			OnClickLockButton();
			break;

		case "questSearchToolButton" :
			LoadWindowClick("UIQuestToolWnd");
			break;

		case "bcToolBtn":
			LoadWindowClick("UICommandWnd");
			break;
		case "debugButton":
			toggleWindow("DebugWnd", true, false);
			break;
		case "builderCmdButton":
			LoadWindowClick("BuilderCmdWnd");
			// End:0x37D
			break;
		// End:0x37A
		case "yebisCmdButton":
			LoadWindowClick("YebisCmdWnd");
			// End:0x37D
			break;
		// End:0xFFFF
	}
}

private function SetClassTypeComboBox()
{
	local int classNameSysString;
	local int i;
	local array<int> EnableClassIndexList;
	local int len;
	local int classIndex;
	local userinfo targetInfo;
	local int myClassIndex;

	m_hCbClassName.Clear();
	// End:0x21
	if(! GetTargetInfo(TargetInfo))
	{
		return;
	}
	if(targetInfo.bNPC)
		return;

	class'UIDataManager'.static.GetEnableClassIndexList(targetInfo.Class, EnableClassIndexList);
	len=EnableClassIndexList.Length;
	for(i=0; i<len; ++i)
	{
		classIndex=EnableClassIndexList[i];
		// debug("АОµ¦Ѕє:"$classIndex);
		classNameSysString=class'UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(classIndex);
		m_hCbClassName.SYS_AddStringWithReserved(classNameSysString, classIndex);

		if(targetInfo.nSubClass==classindex)
			myClassIndex=i;
	}

	// Бц±Э ј±ЕГµИ ѕЦАЗ Е¬·ЎЅєё¦ ДЮєё№ЪЅєїЎ ј±ЕГЗШБЭґПґЩ.
	m_hCbClassName.SetSelectedNum(myClassIndex);
}

private function SetRace(int IndexID)
{
	// End:0x0D
	if(m_targetID < 1)
	{
		return;
	}
	switch(Race_ComboBox.GetReserved(IndexID))
	{
		// End:0x45
		case 0:
			ExecuteCommand("//setparam race 0 0");
			// End:0x408
			break;
		// End:0x68
		case 10:
			ExecuteCommand("//setparam race 0 1");
			// End:0x408
			break;
		// End:0x8B
		case 18:
			ExecuteCommand("//setparam race 1 0");
			// End:0x408
			break;
		// End:0xAE
		case 25:
			ExecuteCommand("//setparam race 1 1");
			// End:0x408
			break;
		// End:0xD1
		case 31:
			ExecuteCommand("//setparam race 2 0");
			// End:0x408
			break;
		// End:0xF4
		case 38:
			ExecuteCommand("//setparam race 2 1");
			// End:0x408
			break;
		// End:0x117
		case 44:
			ExecuteCommand("//setparam race 3 0");
			// End:0x408
			break;
		// End:0x13A
		case 49:
			ExecuteCommand("//setparam race 3 1");
			// End:0x408
			break;
		// End:0x15D
		case 53:
			ExecuteCommand("//setparam race 4 0");
			// End:0x408
			break;
		// End:0x17D
		case 192:
			ExecuteCommand("//setparam race 5 0");
		// End:0x1A0
		case 123:
			ExecuteCommand("//setparam race 5 0");
			// End:0x408
			break;
		// End:0x1C6
		case 124:
			ExecuteCommand("//setparam race 5 1");
			// End:0x408
			break;
			// End:0x408
			break;
		// End:0x1E9
		case 182:
			ExecuteCommand("//setparam race 6 0");
			// End:0x408
			break;
		// End:0x20C
		case 183:
			ExecuteCommand("//setparam race 6 1");
			// End:0x408
			break;
		// End:0x230
		case 208:
			ExecuteCommand("//setparam race 30 1");
			// End:0x408
			break;
		// End:0x235
		case 196:
		// End:0x2A9
		case 212:
			ExecuteCommand("//setparam race 0 0");
			ExecuteCommand("//setclass" @ string(Race_ComboBox.GetReserved(IndexID)));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");
			// End:0x408
			break;
		// End:0x31D
		case 200:
			ExecuteCommand("//setparam race 1 0");
			ExecuteCommand("//setclass" @ string(Race_ComboBox.GetReserved(IndexID)));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");
			// End:0x408
			break;
		// End:0x391
		case 204:
			ExecuteCommand("//setparam race 2 0");
			ExecuteCommand("//setclass" @ string(Race_ComboBox.GetReserved(IndexID)));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");
			// End:0x408
			break;
		// End:0x405
		case 217:
			ExecuteCommand("//setparam race 3 0");
			ExecuteCommand("//setclass" @ string(Race_ComboBox.GetReserved(IndexID)));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");
			// End:0x408
			break;
		// End:0xFFFF
		default:
			break;
	}
	InvalidateClass();
}

private function SetSex(int IndexID)
{
	// End:0x0D
	if(m_targetID < 1)
	{
		return;
	}
	ExecuteCommand("//setparam sex" @ string(Sex_ComboBox.GetReserved(IndexID)));
	InvalidateClass();
}

private function SetClass(int IndexID)
{
	local int classIndex;

	classIndex = m_hCbClassName.GetReserved(IndexID);
	// End:0x41
	if(classIndex >= 0)
	{
		ExecuteCommand("//setclass " @ string(classIndex));
	}
}

private function SetSelectTargetRaceComboBox()
{
	local UserInfo uInfo;
	local int j;

	// End:0x12
	if(! GetTargetInfo(uInfo))
	{
		return;
	}

	// End:0x75 [Loop If]
	for(j = 0; j < Race_ComboBox.GetNumOfItems(); j++)
	{
		// End:0x6B
		if(uInfo.Class == Race_ComboBox.GetReserved(j))
		{
			Race_ComboBox.SetSelectedNum(j);
			return;
		}
	}	
}

private function SetSelectTaargetSexComboBox()
{
	local UserInfo uInfo;

	// End:0x12
	if(! GetTargetInfo(uInfo))
	{
		return;
	}
	Sex_ComboBox.SetSelectedNum(uInfo.nSex);
}

private function InvalidateClass()
{
	local UserInfo uInfo;

	m_TargetClass = -1;
	// End:0x1D
	if(! GetTargetInfo(uInfo))
	{
		return;
	}
	m_TargetClass = uInfo.nSubClass;
	m_hOwnerWnd.EnableTick();
}

private function HandleDialogOK()
{
	if(!DialogIsMine())
		return;

	switch(DialogGetID())
	{
		case DIALOGID_Recall:
			Recall();
			break;
		case DIALOGID_SendHome:
			SendHome();
			break;
	}
}

private function HandleDialogCancel()
{
	if(!DialogIsMine())
		return;
}

private function Recall()
{
	local String EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if(EditBoxString != "")
	{
		ExecuteCommand("//recall" @ EditBoxString);
	}	
}

private function SendHome()
{
	local String EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if(EditBoxString != "")
		ExecuteCommand("//sendhome" @ EditBoxString);
}

//Её°Щ Б¤єё ѕчµҐАМЖ® Гіё®	-- АФ·ВГўїЎ АМё§А» іЦѕоБЦ±в
private function HandleTargetUpdate()
{
	local int m_nowTargetID;
	local UserInfo info;

	// End:0x16
	if(! m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	//Её°ЩID ѕтѕоїА±в
	m_nowTargetID = class'UIDATA_TARGET'.static.GetTargetID();

	if(m_nowTargetID == m_TargetID) 	// ЗС№ш ЅєЖ®ёµА» ѕтѕоїВ АыАМ АЦАёёй ё®ЕП.
	{
		//m_TargetID = 0;	// АМАьАЗ Её°ЩѕЖАМµрё¦ ГК±вИ­
		return;
	}
	
	if (m_nowTargetID<1)	// ѕЖАМµр°Ў ѕшАёёй ±ЧіЙ ё®ЕП.
	{
		m_TargetID = 0;	// АМАьАЗ Её°ЩѕЖАМµрё¦ ГК±вИ­

		if(m_hEditBox.IsEnableWindow())	m_hEditBox.SetString("");
		return;
	}

	GetTargetInfo(info);	// ѕЖАМµр°Ў АЦА» °жїмїЎґВ Б¤єёё¦ ѕтѕоїВґЩ. 

	if((m_nowTargetID>0 ) && (info.bNpc == false))	//NPCАП°жїмїЎґВ јВЖГЗШБЦБц ѕКґВґЩ. 
	{
		if(m_hEditBox.IsEnableWindow())
			m_hEditBox.SetString(info.Name);
	}

	m_TargetID = m_nowTargetID;	// АМАьАЗ Её°ЩѕЖАМµрё¦ АъАеЗШµРґЩ. 	
	SetSelectTargetRaceComboBox();
	SetSelectTaargetSexComboBox();
	SetClassTypeComboBox();
}

private function HandleShowGMWnd()
{
	if(m_hOwnerWnd.IsShowWindow())
		m_hOwnerWnd.HideWindow();
	else
	{
		m_hOwnerWnd.ShowWindow();
		m_hGMwnd.SetFocus(); // єёАП¶§ ЖчДїЅєё¦ GMГўїЎ ёВГдґПґЩ.
		//class'UIAPI_WINDOW'.static.SetFocus(m_hGMwnd);
	}
}

private function onClickMsgSearchButton()
{
	toggleWindow("UISysMsgToolWnd", true);
}

private function OnClickTeleButton()
{
	local String EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if(EditBoxString != "")
		ExecuteCommand("//teleportto" @ EditBoxString);
}

private function OnClickMoveButton()
{
	ExecuteCommand("//instant_move");
}

private function OnClickRecallButton()
{
	DialogSetID(DIALOGID_Recall);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(1220), string(Self) );
}

private function OnClickDetailStatusButton()
{
	local String EditBoxString;
	local GMDetailStatusWnd GMDetailStatusWndScript;

	EditBoxString = m_hEditBox.GetString();
	if(EditBoxString != "")
	{
		GMDetailStatusWndScript = GMDetailStatusWnd(m_hGMDetailStatusWnd.GetScript());
		GMDetailStatusWndScript.ShowStatus(EditBoxString);
	}
	else
		AddSystemMessage(364);
}

private function OnClickInventoryButton()
{
	local String EditBoxString;
	local GMInventoryWnd GMInventoryWndScript;

	EditBoxString = m_hEditBox.GetString();
	if(EditBoxString != "")
	{
		GMInventoryWndScript = GMInventoryWnd(m_hGMInventoryWnd.GetScript());
		GMInventoryWndScript.ShowInventory(EditBoxString);
	}
	else
		AddSystemMessage(364);
}

private function OnClickMagicSkillButton()
{
	local String EditBoxString;
	local GMMagicSkillWnd GMMagicSkillWndScript;

	EditBoxString = m_hEditBox.GetString();
	GMMagicSkillWndScript = GMMagicSkillWnd(m_hGMMagicSkillWnd.GetScript());
	GMMagicSkillWndScript.ShowMagicSkill(EditBoxString);	
}

private function OnClickInfoButton()
{
	local String EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if(EditBoxString != "")
		ExecuteCommand("//debug" @ EditBoxString);
}

private function OnClickStoreButton()
{
	local String EditBoxString;
	local GMWarehouseWnd GMWarehouseWndScript;

	//debug("GMstore");
	EditBoxString = m_hEditBox.GetString();
	if(EditBoxString != "")
	{
		GMWarehouseWndScript = GMWarehouseWnd(m_hGMWarehouseWnd.GetScript());
		GMWarehouseWndScript.ShowWarehouse(EditBoxString);
	}
	else
		AddSystemMessage(364);
}

private function OnClickClanButton()
{
	local String EditBoxString;
	local GMClanWnd GMClanWndScript;

	EditBoxString = m_hEditBox.GetString();
	GMClanWndScript = GMClanWnd(m_hGMClanWnd.GetScript());
	GMClanWndScript.ShowClan(EditBoxString);
}

private function OnClickPetitionButton()
{
	local String EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if(EditBoxString != "")
		ExecuteCommand("//add_peti_chat" @ EditBoxString);
}

private function OnClickSendHomeButton()
{
	DialogSetID(DIALOGID_SendHome);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage( 1221 ), string(Self) );
}

function OnClickNPCListButton()
{
	local String EditBoxString;

//diff_elsacred_s
	local GMFindTreeWnd m_GMFindTreeWnd;
//diff_elsacred_e

	EditBoxString = m_hEditBox.GetString();
	//if( EditBoxString == "" )
	//	return;
//diff_elsacred_s
	//if( EditBoxString != "" )
	//{
		m_GMFindTreeWnd = GMFindTreeWnd ( m_hGMFindTreeWnd.GetScript() );
		m_GMFindTreeWnd.ShowList(EditBoxString, m_GMFindTreeWnd.EListType.LISTTYPE_NPC);
	//}
}

private function OnClickItemListButton()
{
	local String EditBoxString;
//diff_elsacred_s
	local GMFindTreeWnd m_GMFindTreeWnd;
//diff_elsacred_e
	EditBoxString = m_hEditBox.GetString();
	//if( EditBoxString == "" )
	//	return;
	
//diff_elsacred_s
	//if( EditBoxString != "" )
	//{
		m_GMFindTreeWnd= GMFindTreeWnd ( m_hGMFindTreeWnd.GetScript());
		m_GMFindTreeWnd.ShowList(EditBoxString, m_GMFindTreeWnd.EListType.LISTTYPE_ITEM);
		//m_GMFindTreeWnd.ShowItemList(EditBoxString);			
	//}

//diff_elsacred_e
}

private function OnClickSkillListButton()
{
	local String EditBoxString;
//diff_elsacred_s
	local GMFindTreeWnd m_GMFindTreeWnd;
//diff_elsacred_e	
	EditBoxString = m_hEditBox.GetString();
	//if( EditBoxString == "" )
	//	return;
//diff_elsacred_s
	//if( EditBoxString != "" )
	//{
	m_GMFindTreeWnd= GMFindTreeWnd ( m_hGMFindTreeWnd.GetScript());
	m_GMFindTreeWnd.ShowList(EditBoxString, m_GMFindTreeWnd.EListType.LISTTYPE_SKILL);
		//m_GMFindTreeWnd.ShowSkillList(EditBoxString);	
	//}
//diff_elsacred_e
}

private function OnClickForcePetitionButton()
{
	local String EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
		ExecuteCommand( "//force_peti" @ EditBoxString @ GetSystemMessage( 1528 ) );
}

private function OnClickChangeServerButton()
{
	local String EditBoxString;
	local UserInfo PlayerInfo;

	EditBoxString = m_hEditBox.GetString();

	if( EditBoxString == "" )
		return;

	if( !GetPlayerInfo( PlayerInfo ) )
		return;

	class'GMAPI'.static.BeginGMChangeServer( int( EditBoxString ), PlayerInfo.Loc );
}

private function OnClickUIButton()
{
	local WindowHandle UIToolWnd;

	UIToolWnd = GetWindowHandle("UIToolWnd");
	// End:0x3B
	if(UIToolWnd.IsShowWindow())
	{
		UIToolWnd.HideWindow();		
	}
	else
	{
		UIToolWnd.ShowWindow();
	}
	UIToolWnd.SetFocus();	
}

private function OnClickQuestListButton()
{
	local String EditBoxString;
//diff_elsacred_s
	local GMFindTreeWnd m_GMFindTreeWnd;
//diff_elsacred_e	
	EditBoxString = m_hEditBox.GetString();
	//if( EditBoxString == "" )
	//	return;
//diff_elsacred_s
	//if( EditBoxString != "" )
	//{
		m_GMFindTreeWnd = GMFindTreeWnd ( m_hGMFindTreeWnd.GetScript());
		m_GMFindTreeWnd.ShowList(EditBoxString, m_GMFindTreeWnd.EListType.LISTTYPE_QUEST);
		//m_GMFindTreeWnd.ShowQuestList(EditBoxString);	
	//}
//diff_elsacred_e LISTTYPE_CLASS

}

private function LoadWindowClick(string windowName)
{
	local WindowHandle NewWindow;

	NewWindow = GetWindowHandle(windowName);
	NewWindow.ShowWindow();
	NewWindow.SetFocus();
}

// ЕШЅєЖ® їЎµрЕН Аб±Э
private function OnClickLockButton()
{
	if(m_hEditBox.IsEnableWindow())
		m_hEditBox.DisableWindow();
	else 
		m_hEditBox.EnableWindow();

	checkVisibleLockButton();
}


// ЕШЅєЖ® їЎµрЕН Аб±Э
private function checkVisibleLockButton()
{	
	if(m_hEditBox.IsEnableWindow())
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".UnlockBtn").ShowWindow();
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".LockBtn").HideWindow();	
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".UnlockBtn").HideWindow();
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".LockBtn").ShowWindow();
	}
}
// Её°ЩЖГ 
private function OnClickTargetButton()
{
	local String EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
		ExecuteCommand( "/target" @ EditBoxString );
}

// Е¬·ЎЅє єЇ°ж
private function OnClickClassChangeButton()
{
	local String EditBoxString;
	local GMFindTreeWnd m_GMFindTreeWnd;
	EditBoxString = m_hEditBox.GetString();
	m_GMFindTreeWnd = GMFindTreeWnd ( m_hGMFindTreeWnd.GetScript());
	m_GMFindTreeWnd.ShowList(EditBoxString, m_GMFindTreeWnd.EListType.LISTTYPE_CLASS);
}

private function OnClickFindListButton()
{
	local String EditBoxString;
	local GMFindTreeWnd m_GMFindTreeWnd;	
	
	EditBoxString = m_hEditBox.GetString();	
	
	m_GMFindTreeWnd = GMFindTreeWnd ( m_hGMFindTreeWnd.GetScript());	
	m_GMFindTreeWnd = GMFindTreeWnd ( GetScript("GMFindTreeWnd"));	
	
	
	m_GMFindTreeWnd.ShowList(EditBoxString, m_GMFindTreeWnd.EListType.LISTTYPE_ITEM);
}

/**
 * А©µµїм ESC Е°·О ґЭ±в Гіё® 
 * "Esc" Key
 ***/
event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).HideWindow();
}

defaultproperties
{
}
