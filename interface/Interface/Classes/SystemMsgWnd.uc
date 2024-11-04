class SystemMsgWnd extends UICommonAPI;

var private WindowHandle m_hChatWnd;
var private TextureHandle m_ChatWndBg;
var private int m_bUseAlpha;
var private bool IsMouseOver;

static function SystemMsgWnd Inst()
{
	return SystemMsgWnd(GetScript("ChatWnd.SystemMsgWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_ChatWndOnResize);
	RegisterEvent(EV_ResolutionChanged);
	RegisterEvent(EV_OptionHasApplied);
}

event OnLoad()
{
	m_hOwnerWnd.EnableDynamicAlpha(true);
	m_hChatWnd = GetWindowHandle("ChatWnd");
	m_ChatWndBg = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ChatWndBg");
	GetChatWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMsgList").SetScrollBarPosition(15, 0, 15);
}

event OnEvent(int a_EventID, string a_Param)
{
	local int tempVal;

	switch(a_EventID)
	{
		case EV_GamingStateEnter:
			//게임에 다시 들어왔을 때 창을 열지 말지 결정함
			GetINIBool("global", "SystemMsgWnd", tempVal, "chatfilter.ini");
			//if(class'UIAPI_CHECKBOX'.static.IsChecked( "ChatFilterWnd.ChattingFilterGroup.UseSystemMsgBox" ))

			if(getInstanceUIData().getIsLiveServer())
			{
				if(tempVal != 0)
				{
					class'UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");
				}
				else
				{
					class'UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
				}
			}
			else
			{
				class'UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
			}
		/*
			if( GetINIBool( "global", "SystemMsgWnd", tempVars, "chatfilter.ini" ))
			{
				//debug("SystemMsgWndtest Show");
				class'UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");
			}
			else
			{
				//debug("SystemMsgWndtest Hide");
				class'UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
			}
*/
			break;
		case EV_ChatWndOnResize:
			ReSize(a_Param);
			break;
		case EV_ResolutionChanged:
			UpdateResolution();
			break;
		case EV_OptionHasApplied:
			HandleOptionHasAppled();
			break;

		default:
			break;
	}
}

event OnMouseOver(WindowHandle W)
{
	IsMouseOver = true;
	class'ChatWnd'.static.Inst()._Swap2FullAlphaNormal();
	_Swap2FullAlpha();
}

event OnMouseOut(WindowHandle W)
{
	IsMouseOver = false;
	class'ChatWnd'.static.Inst()._Swap2AlphaNormal();
	_Swap2Alpha();
}

event OnShow()
{
	local int W, h, tempVal, sizeW;
	local string showWndParam;

	//사이즈 기억
	m_hOwnerWnd.GetWindowSize(W, h);
	// End:0x6A
	if(GetINIInt("global", "ChatSizeWidth", sizeW, "chatfilter.ini"))
	{
		m_hOwnerWnd.SetWindowSize(sizeW, h);		
	}
	else
	{
		m_hOwnerWnd.SetWindowSize(W, h);
	}
	m_hOwnerWnd.SetResizeFrameOffset(348, h);
	ChangeAnchorEffectButton("SystemMsgWnd"); // lancelot 2006. 7. 10.
	ParamAdd(showWndParam, "visible", string(1));
	/*
	 * worldChatBox 에 전용창 사용여부 보냄
	 */
	if(GetINIBool("global", "UseWorldChatSpeaker", tempVal, "chatfilter.ini"))
	{
		CallGFxFunction("worldChatBox", "IsShowSystemMsgWnd", showWndParam);
	}
	CallGFxFunction("UserAlertMessage", "IsShowSystemMsgWnd", showWndParam);
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NewMessageBtn").HideWindow();
	GetINIBool("global", "UseAlpha", m_bUseAlpha, "chatfilter.ini");
	_Swap2FullAlpha();
}

event OnHide()
{
	local string showWndParam;
	//debug("SystemMsgWndtest OnHide");
	//채팅창 기능 개선으로 필터 윈도우의 앵커를 설정하는 기능은 없어짐
	//class'UIAPI_WINDOW'.static.SetAnchor( "ChatFilterWnd", "ChatWnd", "TopLeft", "BottomLeft", 0, -5 );
	ChangeAnchorEffectButton("ChatWnd");		// lancelot 2006. 7. 10.

	ParamAdd(showWndParam, "visible", string(0));
	CallGFxFunction("worldChatBox", "IsShowSystemMsgWnd", showWndParam);
	CallGFxFunction("UserAlertMessage", "IsShowSystemMsgWnd", showWndParam);
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		// End:0x22
		case "NewMessageBtn":
			HandleNewMessageBtn();
			// End:0x25
			break;
	}
}

private function UpdateResolution()
{
	local int CurrentMaxWidth, CurrentMaxHeight, CurrentChatWidth, CurrentChatHeight;

	GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);

	m_hChatWnd.GetWindowSize(CurrentChatWidth, CurrentChatHeight);

	if(CurrentChatWidth > CurrentMaxWidth || CurrentChatHeight > CurrentMaxHeight - 15)
	{
		m_hOwnerWnd.GetWindowSize(CurrentChatWidth, CurrentChatHeight);
		m_hOwnerWnd.SetWindowSize(348, CurrentChatHeight);
	}
}

private function ReSize(string param)
{
	local int W;
	local int resizeWidth;
	local int h;

	ParseInt(param, "Width", resizeWidth);

	m_hOwnerWnd.GetWindowSize(W, h);
	m_hOwnerWnd.SetWindowSize(resizeWidth, h);
}

private function ChangeAnchorEffectButton(string strID)
{
	//debug("ChangeAnchorEffectButton");
	class'UIAPI_WINDOW'.static.SetAnchor("TutorialBtnWnd", strID, "TopLeft", "BottomLeft", 5, -5);
	class'UIAPI_WINDOW'.static.SetAnchor("MailBtnWnd", strID, "TopLeft", "BottomLeft", 79, -5);
	//class'UIAPI_WINDOW'.static.SetAnchor("PremiumItemBtnWnd", strID, "TopLeft", "BottomLeft", 5, -37 );
	class'UIAPI_WINDOW'.static.SetAnchor("BirthdayAlarmBtn", strID, "TopLeft", "BottomLeft", 42, -37);
	//class'UIAPI_WINDOW'.static.SetAnchor( "AuctionBtnWnd", strID, "TopLeft", "BottomLeft", 79, -37 );
	//class'UIAPI_WINDOW'.static.SetAnchor( "AuctionBtnWnd", strID, "TopLeft", "BottomLeft", 5, -37 );
	//class'UIAPI_WINDOW'.static.SetAnchor( "SystemTutorialBtnWnd", strID, "TopLeft", "BottomLeft", 5, -37 );		
}

function _Swap2FullAlpha()
{
	m_ChatWndBg.SetAlpha(255, class'ChatWnd'.const.FADE_IN_SPEED);
}

function _Swap2Alpha()
{
	if(m_bUseAlpha == 1)
	{
		m_ChatWndBg.SetAlpha(0, class'ChatWnd'.const.FADE_OUT_SPEED);
	}
}

private function HandleOptionHasAppled()
{
	GetINIBool("global", "UseAlpha", m_bUseAlpha, "chatfilter.ini");
	// End:0x3F
	if(IsMouseOver)
	{
		_Swap2FullAlpha();		
	}
	else
	{
		_Swap2Alpha();
	}
}

function _ShowNewMessageBtn()
{
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NewMessageBtn").ShowWindow();
}

function HandleNewMessageBtn()
{
	GetChatWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMsgList").SetScrollPosition(GetChatWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMsgList").GetScrollHeight());
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NewMessageBtn").HideWindow();
}

defaultproperties
{
}
