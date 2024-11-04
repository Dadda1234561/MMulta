class ActionWnd extends UICommonAPI;

var bool m_bShow;
var WindowHandle Me;
var WindowHandle tabContainerWnd;
var WindowHandle actionContainerWnd;

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	tabContainerWnd = GetWindowHandle(ownerFullPath $ ".Tab_Wnd");
	actionContainerWnd = GetWindowHandle(ownerFullPath $ ".ActionItem_Wnd");	
}

function OnRegisterEvent()
{
	RegisterEvent(EV_ActionListNew);
	RegisterEvent(EV_ActionListStart);
	RegisterEvent(EV_ActionList);
	RegisterEvent(EV_LanguageChanged);
	RegisterEvent(EV_NeedResetUIData);
}

function OnLoad()
{
	SetClosingOnESC();

	if(CREATE_ON_DEMAND==0)
	{
		OnRegisterEvent();
	}
	m_bShow = false;
	//ItemWnd의 스크롤바 Hide
	InitControls();
	HideScrollBar();
}

function OnShow()
{
	class'ActionAPI'.static.RequestActionList();
	m_bShow = true;
	// End:0x98
	if(IsUseRenewalSkillWnd() == true)
	{
		Me.SetWindowTitle(GetSystemString(127));
		tabContainerWnd.HideWindow();
		actionContainerWnd.SetAnchor("ActionWnd", "TopLeft", "TopLeft", 0, 46);
		//Me.SetWindowSize(300, 584 - 140);		
	}
	else
	{
		Me.SetWindowTitle(GetSystemString(14230));
		tabContainerWnd.ShowWindow();
		actionContainerWnd.SetAnchor("ActionWnd", "TopLeft", "TopLeft", 0, 85);
		GetWindowHandle("MagicSkillWnd").HideWindow();
		getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "MagicSkillWnd");
		GetWindowHandle("ActionWnd").SetFocus();
	}	
}

function OnHide()
{
	m_bShow = false;
	// End:0x3C
	if(IsUseRenewalSkillWnd() == false)
	{
		getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "MagicSkillWnd");
	}
}

function OnEvent(int Event_ID, String param)
{
	//debug("debug@" @ Event_ID);
	if (Event_ID == EV_ActionListStart)
	{
		//debug("ActionListStart:" );
		HandleActionListStart();
	}
	else if (Event_ID == EV_ActionList)
	{
		//debug("EV_ActionList:" @ param);
		HandleActionList(param);
	}
	else if (Event_ID == EV_LanguageChanged)
	{
		//debug("EV_LanguageChanged:");
		HandleLanguageChanged();
	}
	else if( Event_ID == EV_ActionListNew )
	{
		//debug("EV_ActionListNew");
		HandleActionListNew();
	}
	else if( Event_ID == EV_NeedResetUIData )
	{
		//debug("EV_ActionListNew");
		checkClassicForm();
	}	
}

function checkClassicForm () 
{
	local int containerPosY;
	local WindowHandle Me;
	local TextBoxHandle txtMark;	
	local TextureHandle SlotMark_01;
	local TextureHandle SlotMark_02;
	local ItemWindowHandle ActionMarkItem;

	local TextBoxHandle txtSocial;	
	local TextureHandle SlotSocial_01;
	local TextureHandle SlotSocial_02;		
	local ItemWindowHandle ActionSocialItem;

	containerPosY = 85;
	txtSocial = GetTextBoxHandle(actionContainerWnd.m_WindowNameWithFullPath $ ".txtSocial");
	SlotSocial_01 = GetTextureHandle(actionContainerWnd.m_WindowNameWithFullPath $ ".SlotSocial_01");
	SlotSocial_02 = GetTextureHandle(actionContainerWnd.m_WindowNameWithFullPath $ ".SlotSocial_02");
	ActionSocialItem = GetItemWindowHandle(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionSocialItem");
	txtMark = GetTextBoxHandle(actionContainerWnd.m_WindowNameWithFullPath $ ".txtMark");
	SlotMark_01 = GetTextureHandle(actionContainerWnd.m_WindowNameWithFullPath $ ".SlotMark_01");
	SlotMark_02 = GetTextureHandle(actionContainerWnd.m_WindowNameWithFullPath $ ".SlotMark_02");
	ActionMarkItem = GetItemWindowHandle(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionMarkItem");

	//if(getInstanceUIData().getIsClassicServer()) // 해외는 아덴서버가 징표를 사용하지 않는다. (국내 아덴과 동일설정)
	//{
	//	SlotMark_01.HideWindow();
	//	SlotMark_02.HideWindow();
	//	txtMark.HideWindow();
	//	ActionMarkItem.HideWindow();
	//	txtSocial.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 15, 353 - containerPosY);
	//	SlotSocial_01.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 6, 371 - containerPosY);
	//	SlotSocial_02.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 258, 371 - containerPosY);
	//	ActionSocialItem.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 7, 371 - containerPosY);
	//	Me.SetWindowSize(300, 575);
	//}
	//else
	//{
		SlotMark_01.ShowWindow();
		SlotMark_02.ShowWindow();
		txtMark.ShowWindow();
		ActionMarkItem.ShowWindow();
		txtSocial.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 15, 445 - containerPosY);
		SlotSocial_01.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 6, 463 - containerPosY);
		SlotSocial_02.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 258, 463 - containerPosY);
		ActionSocialItem.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 7, 463 - containerPosY);
		Me.SetWindowSize(300, 540);
	//}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "WindowHelp_BTN":
			ExecuteEvent(EV_ShowHelp, "6");
			break;
		case "SkillTap_Btn":
			GetWindowHandle("MagicSkillWnd").ShowWindow();
			break;
	}
}

//액션의 클릭
function OnClickItem( string strID, int index )
{
	local ItemInfo 	infItem;
	
	if (strID == "ActionBasicItem" && index>-1)
	{
		if(! class'UIAPI_ITEMWINDOW'.static.GetItem(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionBasicItem", Index, infItem))
			return;

		class'UIAPI_ITEMWINDOW'.static.SetItem(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionBasicItem", Index, infItem);
	}
	else if (strID == "ActionPartyItem" && index>-1)
	{
		//Debug(string(index));
		if(! class'UIAPI_ITEMWINDOW'.static.GetItem(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionPartyItem", Index, infItem))
			return;

		//월래 자동 파티 매칭용 하드 코딩.
		/*
		if( index == 7 )
		{
			//debug( string(infItem.IconIndex) );
			if (infItem.IconIndex == 0)
			{
				class'UIAPI_ITEMWINDOW'.static.SetIconIndex( "ActionWnd.ActionPartyItem", index, 1);
				//class'UIAPI_ITEMWINDOW'.static.SetToggleEffect("ActionWnd.ActionPartyItem", index, true);
			}
			else if ( infItem.IconIndex == 1)
			{
				class'UIAPI_ITEMWINDOW'.static.SetIconIndex( "ActionWnd.ActionPartyItem", index, 0);
				//class'UIAPI_ITEMWINDOW'.static.SetToggleEffect("ActionWnd.ActionPartyItem", index, false);
			}
		}*/
	}
	else if (strID == "ActionMarkItem" && index>-1)
	{
		if(! class'UIAPI_ITEMWINDOW'.static.GetItem(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionMarkItem", Index, infItem))
			return;
	}
	else if (strID == "ActionSocialItem" && index>-1)
	{
		if(! class'UIAPI_ITEMWINDOW'.static.GetItem(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionSocialItem", Index, infItem))
			return;
	}
	

	DoAction(infItem.ID);

	
}

function HideScrollBar()
{
	class'UIAPI_ITEMWINDOW'.static.ShowScrollBar(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionBasicItem", false);
	class'UIAPI_ITEMWINDOW'.static.ShowScrollBar(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionPartyItem", false);
	class'UIAPI_ITEMWINDOW'.static.ShowScrollBar(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionMarkItem", false);
	class'UIAPI_ITEMWINDOW'.static.ShowScrollBar(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionSocialItem", false);	
}

function HandleLanguageChanged()
{
	class'ActionAPI'.static.RequestActionList();
}

function HandleActionListStart()
{
	Clear();
}

function Clear()
{
	class'UIAPI_ITEMWINDOW'.static.Clear(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionBasicItem");
	class'UIAPI_ITEMWINDOW'.static.Clear(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionPartyItem");
	class'UIAPI_ITEMWINDOW'.static.Clear(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionMarkItem");
	class'UIAPI_ITEMWINDOW'.static.Clear(actionContainerWnd.m_WindowNameWithFullPath $ ".ActionSocialItem");	
}

function HandleActionList(string param)
{
	local string WndName;
	
	local int Tmp;
	local EActionCategory Type;
	local string strActionName;
	local string strIconName;
	local string strIconNameEx1;
	local string strDescription;
	local string strCommand;
	
	local ItemInfo	infItem;
	
	ParseItemID(param, infItem.ID);
	ParseInt(param, "Type", Tmp);
	ParseString(param, "Name", strActionName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "IconNameEx1", strIconNameEx1);
	ParseString(param, "Description", strDescription);
	ParseString(param, "Command", strCommand);

	infItem.Name = strActionName;
	infItem.IconName = strIconName;
	infItem.IconNameEx1 = strIconNameEx1;
	infItem.Description = strDescription;
	infItem.ShortcutType = int(EShortCutItemType.SCIT_ACTION);
	infItem.MacroCommand = strCommand;
	
	//ItemWnd에 추가
	Type = EActionCategory(Tmp);
	if (Type==ACTION_BASIC)
	{
		WndName = "ActionBasicItem";
	}
	else if (Type==ACTION_PARTY)
	{
		WndName = "ActionPartyItem";
	}
	else if (Type==ACTION_TACTICALSIGN)
	{
		WndName = "ActionMarkItem";
	}
	else if (Type==ACTION_SOCIAL)
	{
		WndName = "ActionSocialItem";
	}
	else
	{
		return;
	}
	class'UIAPI_ITEMWINDOW'.static.AddItem(actionContainerWnd.m_WindowNameWithFullPath $ "." $ wndname, infItem);
}

function HandleActionListNew()		// Request new data
{
	class'ActionAPI'.static.RequestActionList();
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "ActionWnd" ).HideWindow();
}

defaultproperties
{
}
