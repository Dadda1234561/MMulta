class ChatWnd extends UICommonAPI;

const CHANNEL_ID_NORMAL = 0;
const CHANNEL_ID_TRADE = 1;
const CHANNEL_ID_PARTY = 2;
const CHANNEL_ID_CLAN = 3;
const CHANNEL_ID_ALLY = 4;
const CHANNEL_ID_HERO = 5;
const CHANNEL_ID_PARTYMASTER = 6;
const CHANNEL_ID_SHOUT = 7;
const CHANNEL_ID_WORLD = 8;
const CHANNEL_ID_INRAIDSERVER = 9;
const CHANNEL_ID_SYSTEM = 10; // �ý��� �޽��� â
const CHANNEL_ID_COUNT = 10;
//~ const CHAT_WINDOW_
const CHAT_WINDOW_TAB_NORMAL = 0;
const CHAT_WINDOW_TAB_1 = 1;
const CHAT_WINDOW_TAB_2 = 2;
const CHAT_WINDOW_TAB_3 = 3;
const CHAT_WINDOW_TAB_LEN = 4; // �� ����
const CHAT_WINDOW_TAB_SYSTEM = 5;
const DIALOGID_GoWeb = 1234510;
const CHAT_UNION_MAX = 35; // ����ä�� OnScreenMessage ���ٿ� �ִ�� �� �� �ִ� ���� ��(�۷ι���)
const VALIDATEFLAG_ALARM_KEYWORD = 1;
const VALIDATEFLAG_ALARM_CHAT = 2;
const OPTION_ALARM_INDEX_SPT_TELL = 11;
const OPTION_ALARM_INDEX_SPT_WORLD = 12;
const OPTION_ALARM_INDEX_SPT_PLEDGE = 13;
const OPTION_ALARM_INDEX_SPT_ALLIANCE = 14;
const OPTION_ALARM_INDEX_SPT_INTER_PARTYMASTER_CHAT = 15;
const ALARM_INDEX_SPT_TELL = 12;
const ALARM_INDEX_SPT_WORLD = 13;
const ALARM_INDEX_SPT_PLEDGE = 14;
const ALARM_INDEX_SPT_ALLIANCE = 15;
const ALARM_INDEX_SPT_INTER_PARTYMASTER_CHAT = 16;
const FADE_IN_SPEED = 0.2f;
const FADE_OUT_SPEED = 0.7f;
const CONTEXT_ID_ADD_FRIEND = 0;
const CONTEXT_ID_ADD_PARTY = 1;
const CONTEXT_ID_ADD_BLOCK = 2;
const TIMER_ID_PARTYMATCH = 1992;
const TIMER_TIME_PARTYMATCH = 500;
const TIMER_ID_CHANTTINGFADEOUTDELAY = 2022;
const TIMER_TIME_CHANTTINGFADEOUTDELAY = 5000;
const CHATEDITBOXOffSetX = 52;
const CHATWNDMINWIDTH = 399;
const CHATWNDMINHEIGHT = 130;
const CHATWNDMINHEIGHTSPLIT = 73;
const TABCTROLY = -26;

/*
	CHAT_NORMAL			 =0,
	CHAT_SHOUT			  =1,
	CHAT_TELL			   =2,
	CHAT_PARTY			  =3,
	CHAT_CLAN			   =4,
	CHAT_SYSTEM			 =5,
	CHAT_USER_PET		   =6,
	CHAT_GM_PET			 =7,
	CHAT_MARKET			 =8,
	CHAT_ALLIANCE		   =9,
	CHAT_ANNOUNCE		   =10,
	CHAT_CUSTOM			 =11,
	CHAT_L2_FRIEND		  =12,
	CHAT_MSN_CHAT		   =13,
	CHAT_PARTY_ROOM_CHAT	=14,
	CHAT_COMMANDER_CHAT	 =15,
	CHAT_INTER_PARTYMASTER_CHAT=16,
	CHAT_HERO			   =17,
	CHAT_CRITICAL_ANNOUNCE  =18,
	CHAT_SCREEN_ANNOUNCE	=19,
	CHAT_DOMINIONWAR		=20,
	CHAT_MPCC_ROOM		  =21,
	CHAT_NPC_NORMAL		 =22,
	CHAT_NPC_SHOUT		  =23,
	CHAT_FRIEND_ANNOUNCE	=24,
	CHAT_WORLD			  =25,
	CHAT_MAX				=26,
*/
struct ChatFilterInfo
{
	var int bDice;
	var int bGetitems;
	var int bSystem;
	var int bChat;
	var int bDamage;
	var int bNormal;
	var int bShout;
	var int bClan;
	var int bParty;
	var int bTrade;
	var int bWhisper;
	var int bAlly;
	var int bWorldUnion;
	var int bUseitem;
	var int bHero;
	var int bUnion;
	var int bBattle;
	var int bNoNpcMessage;
	var int bWorldChat;
};

//Global Setting
var int m_bUseSystemMsgWnd;
var int m_bSystemMsgWnd;
var int m_bDamageOption;
var int m_bDiceOption;
var int m_bUseSystemItem;
//var int	m_NoUnionCommanderMessage;
var int m_NoNpcMessage;				// NPC ��� ���͸� - 2010.9.8 winkey
var int m_bWorldChat;				// ����ä��
var int m_bWorldChatSpeaker;		// ����ä�� ����Ŀ ���
var int m_bOnlyUseSystemMsgWnd;	 // �ý��� �޽��� â������ ���
var int m_bUseAlpha;
var int m_EditBoxHeight;

var int m_UseChatSymbol;

var int m_KeywordFilterSound;
var int m_KeywordFilterActivate;

var int m_ChatResizeOnOff;  //ä�� ������ ���� �ﰢ�� ���� ����

var string m_Keyword0;
var string m_Keyword1;
var string m_Keyword2;
var string m_Keyword3;
var array<ChatFilterInfo> m_filterInfo;
var array<string> m_sectionName;
//~ var int m_chatType;

struct native constructive ChatUIType
{
	var int Id;
	var int UI;
};

struct chatTabInfo
{
	var int channelID;
	var ChatWindowHandle ChatWnd;
	var WindowHandle tabButton;
	var ButtonHandle newMessageBtn;
	var ButtonHandle channelBtn;
	var ButtonHandle tabMergeBtn;
	var bool isSplit;
	var bool bShowNewMessageBtn;
};

var ChatUIType m_chatType;

//(10.1.28 ������ �߰�)
//Link �̺�Ʈ const ��.
//Url �� ����.
var string Url;
var string Text;

//Handle List
var ChatWindowHandle SystemMsg;
var array<chatTabInfo> chatTabInfos;
var WindowHandle UpScrollButton;
var WindowHandle DownScrollButton;
var WindowHandle SliderScrollButton;
//~ var ChekboxHandle OutEditBox
var TabHandle ChatTabCtrl;
var EditBoxHandle ChatEditBox;

var WindowHandle m_hChatWnd;
var WindowHandle m_hSystemMsgWnd;

var WindowHandle m_hChatFontsizeWnd;
var private TextureHandle m_ChatWndBg;
var private ButtonHandle m_ChatMinBtn;
var private ButtonHandle m_ChatMaxBtn;
var private TextureHandle m_ChatMaxBtnAlarm;
var private ButtonHandle m_ChatFilterBtn;
var private WindowHandle dragTabNormal;
var string lastClickChatTabName;
var private bool IsMouseOver;
var private bool isMinSize;
var private bool bPrefixChanged;
var private int validateFlag;
var private int bitFlagAlarmKewWord;
var private int bitFlagAlarmChat;
var private bool bShowSystemMessage;

static function ChatWnd Inst()
{
	return ChatWnd(GetScript("ChatWnd"));
}

function setInit()
{
	InitFilterInfo();
//	InitGlobalSetting();

	SetChatFilterBool("Global", "EnterChatting", GetChatFilterBool("Global", "EnterChatting"));
}

private function InitHandleCOD()
{
	m_hChatWnd = GetWindowHandle("ChatWnd");
	chatTabInfos.Length = CHAT_WINDOW_TAB_LEN;
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd = GetChatWindowHandle("ChatWnd.NormalChat");
	chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd = GetChatWindowHandle("ChatWnd.TradeChat");
	chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd = GetChatWindowHandle("ChatWnd.PartyChat");
	chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd = GetChatWindowHandle("ChatWnd.ClanChat");
	SystemMsg = GetChatWindowHandle("SystemMsgWnd.SystemMsgList");
	ChatTabCtrl = GetTabHandle("ChatWnd.ChatTabCtrl");
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].tabButton = GetWindowHandle("ChatWnd.ChatTabCtrl.TabButton0");
	chatTabInfos[CHAT_WINDOW_TAB_1].tabButton = GetWindowHandle("ChatWnd.ChatTabCtrl.TabButton1");
	chatTabInfos[CHAT_WINDOW_TAB_2].tabButton = GetWindowHandle("ChatWnd.ChatTabCtrl.TabButton2");
	chatTabInfos[CHAT_WINDOW_TAB_3].tabButton = GetWindowHandle("ChatWnd.ChatTabCtrl.TabButton3");
	dragTabNormal = m_hOwnerWnd.GetResizeFrame();
	m_ChatWndBg = GetTextureHandle("ChatWnd.ChatWndBg");
	ChatEditBox = GetEditBoxHandle("ChatWnd.ChatEditBox");
	m_hChatFontsizeWnd = GetWindowHandle("ChatFontsizeWnd"); // ��Ʈ ���� �ɼ�
	m_ChatMinBtn = GetButtonHandle("ChatWnd.ChatMinBtn");
	m_ChatMaxBtn = GetButtonHandle("ChatWnd.ChatMaxBtn");
	m_ChatMaxBtn.HideWindow();
	m_ChatMaxBtnAlarm = GetTextureHandle("ChatWnd.ChatMaxBtnAlarm");
	m_ChatMaxBtnAlarm.HideWindow();
	m_ChatFilterBtn = GetButtonHandle("ChatWnd.ChatFilterBtn");
	chatTabInfos[CHAT_WINDOW_TAB_1].channelBtn = GetButtonHandle("ChatWnd.ChnnelTradeBtn");
	chatTabInfos[CHAT_WINDOW_TAB_2].channelBtn = GetButtonHandle("ChatWnd.ChnnelPartyBtn");
	chatTabInfos[CHAT_WINDOW_TAB_3].channelBtn = GetButtonHandle("ChatWnd.ChnnelClanBtn");
	chatTabInfos[CHAT_WINDOW_TAB_1].tabMergeBtn = GetButtonHandle("ChatWnd.TabMergeTradeBtn");
	chatTabInfos[CHAT_WINDOW_TAB_2].tabMergeBtn = GetButtonHandle("ChatWnd.TabMergePartyBtn");
	chatTabInfos[CHAT_WINDOW_TAB_3].tabMergeBtn = GetButtonHandle("ChatWnd.TabMergeClanBtn");
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].newMessageBtn = GetButtonHandle("ChatWnd.NewMessageBtn");
	chatTabInfos[CHAT_WINDOW_TAB_1].newMessageBtn = GetButtonHandle("ChatWnd.NewMessageBtnTrade");
	chatTabInfos[CHAT_WINDOW_TAB_2].newMessageBtn = GetButtonHandle("ChatWnd.NewMessageBtnParty");
	chatTabInfos[CHAT_WINDOW_TAB_3].newMessageBtn = GetButtonHandle("ChatWnd.NewMessageBtnClan");
	chatTabInfos[CHAT_WINDOW_TAB_1].tabMergeBtn.HideWindow();
	chatTabInfos[CHAT_WINDOW_TAB_2].tabMergeBtn.HideWindow();
	chatTabInfos[CHAT_WINDOW_TAB_3].tabMergeBtn.HideWindow();
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].newMessageBtn.HideWindow();
	chatTabInfos[CHAT_WINDOW_TAB_1].newMessageBtn.HideWindow();
	chatTabInfos[CHAT_WINDOW_TAB_2].newMessageBtn.HideWindow();
	chatTabInfos[CHAT_WINDOW_TAB_3].newMessageBtn.HideWindow();
	m_hChatWnd.EnableDynamicAlpha(true);
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.EnableDynamicAlpha(true);
	chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd.EnableDynamicAlpha(true);
	chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd.EnableDynamicAlpha(true);
	chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.EnableDynamicAlpha(true);
	AnchorTabs();
	SystemMsg.EnableDynamicAlpha(true);
	m_hSystemMsgWnd = GetWindowHandle("SystemMsgWnd");
	GetChatWindowHandle("ChatWnd.ClanChat").HideWindow();
}

private function AnchorTabs()
{
	chatTabInfos[CHAT_WINDOW_TAB_1].tabButton.SetAnchor(chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd.m_WindowNameWithFullPath, "Topeft", "TopLeft", 101, TABCTROLY);
	chatTabInfos[CHAT_WINDOW_TAB_1].channelBtn.SetAnchor(chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd.m_WindowNameWithFullPath, "Topeft", "TopLeft", 102, TABCTROLY + 1);
	chatTabInfos[CHAT_WINDOW_TAB_2].tabButton.SetAnchor(chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd.m_WindowNameWithFullPath, "Topeft", "TopLeft", 200, TABCTROLY);
	chatTabInfos[CHAT_WINDOW_TAB_2].channelBtn.SetAnchor(chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd.m_WindowNameWithFullPath, "Topeft", "TopLeft", 201, TABCTROLY + 1);
	chatTabInfos[CHAT_WINDOW_TAB_3].tabButton.SetAnchor(chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.m_WindowNameWithFullPath, "Topeft", "TopLeft", 299, TABCTROLY);
	chatTabInfos[CHAT_WINDOW_TAB_3].channelBtn.SetAnchor(chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.m_WindowNameWithFullPath, "Topeft", "TopLeft", 300, TABCTROLY + 1);
}

private function InitScrollBarPosition()
{
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.SetScrollBarPosition(0, 0, 15);
	chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd.SetScrollBarPosition(0, 0, 15);
	chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd.SetScrollBarPosition(0, 0, 15);
	chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.SetScrollBarPosition(0, 0, 15);
}

event OnRegisterEvent()
{
	RegisterEvent(EV_ChatMessage);
	RegisterEvent(EV_ChatWndSetString);
	RegisterEvent(EV_ChatWndSetFocus);
	//msn ���� ������� 13.01.23 ������Ʈ  ���� ���� �ʴϴ�.
	//RegisterEvent(EV_ChatWndMsnStatus);
	RegisterEvent(EV_ChatWndMacroCommand);
	//TextLink
	RegisterEvent(EV_TextLinkLButtonClick);
	RegisterEvent(EV_TextLinkRButtonClick);
	RegisterEvent(EV_ChatIconClick);
	RegisterEvent(EV_GamingStateEnter);
	//����â, ä�� url��ũ �̺�Ʈ(10.1.28 ������ �߰�)
	//registerEvent(EV_UrlLinkClick); // L2UTil �� �ߺ���.
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
	RegisterEvent(EV_ChatWndOnResize);
	RegisterEvent(EV_ResolutionChanged);
	RegisterEvent(EV_NeedResetUIData);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_RequestInvitePartyAction);
	RegisterEvent(EV_OptionHasApplied);
}

event OnLoad()
{
	m_filterInfo.Length = CHANNEL_ID_COUNT + 1;		// ������ ���̴� ���� CHANNEL_ID_COUNT ��ŭ������ CheckFilter�� �� �� �����ϰ� ¥������ CHANNEL_ID_SYSTEM �� ���̸� �Ѱ� �� �Ҵ��Ѵ�.
	m_EditBoxHeight = 26;
	m_sectionName.Length = CHANNEL_ID_COUNT;				// chatfilter.ini������ �׸�
	m_sectionName[0] = "entire_tab";
	m_sectionName[1] = "pledge_tab";
	m_sectionName[2] = "party_tab";
	m_sectionName[3] = "market_tab";
	m_sectionName[4] = "ally_tab";
	m_sectionName[5] = "hero_tab";
	m_sectionName[6] = "union_tab";
	m_sectionName[7] = "shout_tab";
	m_sectionName[8] = "worldChat_tab";
	m_sectionName[9] = "worldUnion_tab";
	//~ m_sectionName[CHANNEL_ID_ALLY] = "ally_tab";
	//~ m_sectionName[CHANNEL_ID_ALLY] = "ally_tab";
	//~ m_sectionName[CHANNEL_ID_ALLY] = "ally_tab";
	//~ m_sectionName[CHANNEL_ID_ALLY] = "ally_tab";
	
	// xml ���� GaimingState�� ����� �ְ� ���⼭ �߰��� OlympiadObserverState���� ����� �ش�.
	RegisterState("ChatWnd", "OlympiadObserverState");
	RegisterState("ChatWnd", "TRAININGROOMSTATE");

	InitHandleCOD();

	InitFilterInfo();
	//InitGlobalSetting();
	InitScrollBarPosition();

	//Enable TextLink
	ChatEditBox.SetEnableTextLink(true);
	ChatEditBox.SetAsChatEditBox();
	m_chatType.UI = 0;
	m_chatType.Id = -1;
	chatTabInfos[1].isSplit = false;
	chatTabInfos[2].isSplit = false;
	chatTabInfos[3].isSplit = false;
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMessageToggleBtn").HideWindow();
	//OnMouseOver(m_hOwnerWnd);
}

event OnDefaultPosition()
{
	ChatTabCtrl.MergeTab(CHANNEL_ID_TRADE);
	ChatTabCtrl.MergeTab(CHANNEL_ID_PARTY);
	ChatTabCtrl.MergeTab(CHANNEL_ID_CLAN);
	ChatTabCtrl.SetTopOrder(0, true);

	if(isMinSize)
	{
		chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.HideWindow();
	}
	HandleTabClick("ChatTabCtrl0");

	if(! IsMouseOver)
	{
		chatTabInfos[CHAT_WINDOW_TAB_1].tabButton.SetAlpha(0, FADE_OUT_SPEED);
		chatTabInfos[CHAT_WINDOW_TAB_2].tabButton.SetAlpha(0, FADE_OUT_SPEED);
		chatTabInfos[CHAT_WINDOW_TAB_3].tabButton.SetAlpha(0, FADE_OUT_SPEED);
	}
}

event OnSetFocus(WindowHandle a_WindowHandle, bool IsFocused)
{
	if(IsMouseOver)
	{
		return;
	}
	if(IsFocused)
	{
		return;
	}
	if(a_WindowHandle == ChatEditBox)
	{
		SetAlphaTimer();
	}
}

event OnChangeEditBox(string strID)
{
	if(bPrefixChanged)
	{
		return;
	}
	if(isMinSize)
	{
		_Swap2Max();
	}
	_Swap2FullAlphaNormal();
}

event OnCompleteEditBox(string strID)
{
	local string strInput;
	local SayPacketType SayType;
	//local int useEnterChatting;

	if(strID == "ChatEditBox")
	{
		strInput = ChatEditBox.GetString();

		if(Len(strInput) < 1)
		{
			return;
		}

		SayType = GetChatTypeByTabIndex(m_chatType.UI);
		ProcessChatMessage(strInput, SayType, false);
		ChatEditBox.SetString("");

		//ä�ñ�ȣ
		m_UseChatSymbol = int(GetChatFilterBool("Global", "OldChatting"));

		if(bool(m_UseChatSymbol) == true)
		{
			//�Ϲ����� �ƴ� ���, Prefix�� �ٿ��ش�.
			if(m_chatType.Id != 0)
			{
				if(SayType != SayPacketType.SPT_NORMAL)
				{
					ChatEditBox.AddString(GetChatPrefix(SayType));
				}
			}
		}

		//����ä��
		if(GetChatFilterBool("Global", "EnterChatting"))
		{
			ChatEditBox.ReleaseFocus();
		}
		else
		{
			ChatEditBox.SetFocus();
		}
	}
	if(! IsMouseOver)
	{
		SetAlphaTimer();
	}
}

private function SetAlphaTimer()
{
	m_hOwnerWnd.KillTimer(TIMER_ID_CHANTTINGFADEOUTDELAY);
	m_hOwnerWnd.SetTimer(TIMER_ID_CHANTTINGFADEOUTDELAY, TIMER_TIME_CHANTTINGFADEOUTDELAY);
}

event OnShow()
{
	local int FontSize, sizeW, sizeH;
	local int tempVal;
	local string isSavedString, sizeParam, isShowSystemMsgWndParam;
	//local ChatFilterWnd script;

	local int CurrentMaxWidth, CurrentMaxHeight;

	local bool isSavedChatSize;

	// �ѹ��� �ε� �ȵ� ��� .............................. �� ù �ε� ���� ���� �� �� ���� ���� �κ�
	GetINIString("global", "DefaultSaveOption", isSavedString, "chatfilter.ini");

	if(isSavedString == "true")
	{
		if(! GetINIBool("worldUnion_tab", "worldUnion", tempVal, "chatfilter.ini"))
		{
			SetDefaultFilterValueWorldUnion();
			SaveChatFilterOption();
		}
		LoadINIFilterSetting();
	}
	else
	{
		// End:0xDF
		if(getInstanceUIData().getIsClassicServer())
		{
			SetINIInt("global", "ChatFontSizeSaved", 1, "chatfilter.ini");			
		}
		else
		{
			SetINIInt("global", "ChatFontSizeSaved", 0, "chatfilter.ini");
		}
		isSavedString = "true";
		SetINIString("global", "DefaultSaveOption", isSavedString, "chatfilter.ini");
		SetDefaultFilterValue();
		SetDefaultFilterValueWorldUnion();
		SaveChatFilterOption();
	}

	if(getInstanceUIData().getIsLiveServer())
	{
		GetINIBool("global", "SystemMsgWnd", m_bUseSystemMsgWnd, "chatfilter.ini");

		if(bool(m_bUseSystemMsgWnd))
		{
			m_hSystemMsgWnd.ShowWindow();
		}
		else
		{
			m_hSystemMsgWnd.HideWindow();
		}
	}
	else
	{
		m_hSystemMsgWnd.HideWindow();
	}

	ParamAdd(isShowSystemMsgWndParam, "visible", string(m_bUseSystemMsgWnd));
	//����ϴ� �����϶���
	if(GetINIBool("global", "UseWorldChatSpeaker", tempVal, "chatfilter.ini"))
	{
		CallGFxFunction("worldChatBox", "IsShowSystemMsgWnd", isShowSystemMsgWndParam);
	}

	CallGFxFunction("UserAlertMessage", "IsShowSystemMsgWnd", isShowSystemMsgWndParam);

	// ê ���������� ��ư ǥ�� ����
	//���� ������ �⺻���� ǥ�����ش�
	if(GetINIBool("global", "ChatResizing", tempVal, "chatfilter.ini"))
	{
		m_ChatResizeOnOff = tempVal;

		if(bool(m_ChatResizeOnOff))
		{
			EnableChatWndResizing(false);
		}
		else
		{
			EnableChatWndResizing(true);
		}
	}
	else
	{
		EnableChatWndResizing(true);
	}

	/////////////////////////////////////

	_SetAllcurrentAssignedChatTypeID();
	//ä��â �ҷ��ö� ����ƴ� ��Ʈũ�⸦ �ҷ��´�	
	GetINIInt("global", "ChatFontSizeSaved", FontSize, "chatfilter.ini");
	_SetChangeFont(FontSize);

	GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
	//ä��â ũ�� ���� �ػ� ���� �� ä��â�� ȭ�� �ۿ� �ִ� ���

	isSavedChatSize = GetINIInt("global", "ChatSizeWidth", sizeW, "chatfilter.ini");
	isSavedChatSize = GetINIInt("global", "ChatSizeHeight", sizeH, "chatfilter.ini") && isSavedChatSize;

	//Debug("onShow" @ isSavedChat @ sizeW @ CurrentMaxWidth);
	if(sizeW < CHATWNDMINWIDTH)
	{
		sizeW = CHATWNDMINWIDTH;
	}

	if(sizeH < CHATWNDMINHEIGHT)
	{
		sizeH = CHATWNDMINHEIGHT;
	}

	if(isSavedChatSize && sizeW <= CurrentMaxWidth && sizeH <= CurrentMaxHeight -15)
	{
		m_hChatWnd.SetWindowSize(sizeW, sizeH);
		ChatEditBox.SetWindowSize(sizeW - CHATEDITBOXOffSetX, m_EditBoxHeight);
		ParamAdd(sizeParam, "w", string(sizeW));
		ParamAdd(sizeParam, "h", string(sizeH + 35));
		CallGFxFunction("UserAlertMessage", "ReceiveChatWndSize", sizeParam);
		CallGFxFunction("worldChatBox", "ReceiveChatWndSize", sizeParam);
	}
	else
	{
		m_hChatWnd.SetWindowSize(CHATWNDMINWIDTH, CHATWNDMINHEIGHT);
		m_hChatWnd.SetResizeFrameOffset(CHATWNDMINWIDTH, CHATWNDMINHEIGHT);
		SetINIInt("global", "ChatSizeWidth", CHATWNDMINWIDTH, "chatfilter.ini");
		SetINIInt("global", "ChatSizeHeight", CHATWNDMINHEIGHT, "chatfilter.ini");
		ParamAdd(sizeParam, "w", string(CHATWNDMINWIDTH));
		ParamAdd(sizeParam, "h", string(CHATWNDMINHEIGHT + 35));
		CallGFxFunction("UserAlertMessage", "ReceiveChatWndSize", sizeParam);
		CallGFxFunction("worldChatBox", "ReceiveChatWndSize", sizeParam);
	}
	m_hChatWnd.SetResizeFrameOffset(CHATWNDMINWIDTH, CHATWNDMINHEIGHT);
	setInit();
	HandleOptionHasAppled();
	InitScrollBarPosition();
}

event OnRClickButton(string strID)
{
	switch(strID)
	{
		case "ChatTabCtrl0":
		case "ChatTabCtrl1":
		case "ChatTabCtrl2":
		case "ChatTabCtrl3":
		case "ChatTabCtrl4":
			HandleTabClick(strID);
			break;
	}
}

event OnClickButton(String strID)
{
	switch(strID)
	{
		case "ChatTabCtrl0":
		case "ChatTabCtrl1":
		case "ChatTabCtrl2":
		case "ChatTabCtrl3":
			HandleTabClick(strID);
			break;
		case "ChatFilterBtn":
			CallGFxFunction("OptionWnd", "showChattingOption", "");
			break;
		case "ChatMinBtn":
			_Swap2Min();
			break;
		case "ChatMaxBtn":
			_Swap2Max();
			break;
		case "TabMergeTradeBtn":
			ChatTabCtrl.MergeTab(CHAT_WINDOW_TAB_1);
			break;
		case "TabMergePartyBtn":
			ChatTabCtrl.MergeTab(CHAT_WINDOW_TAB_2);
			break;
		case "TabMergeClanBtn":
			ChatTabCtrl.MergeTab(CHAT_WINDOW_TAB_3);
			break;
		case "NewMessageBtn":
			HideNewMessageBtn(0);
			chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.SetScrollPosition(chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.GetScrollHeight());
			break;
		case "newMessageBtnTrade":
			HideNewMessageBtn(1);
			chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd.SetScrollPosition(chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd.GetScrollHeight());
			break;
		case "newMessageBtnParty":
			HideNewMessageBtn(2);
			chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd.SetScrollPosition(chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd.GetScrollHeight());
			break;
		case "newMessageBtnClan":
			HideNewMessageBtn(3);
			chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.SetScrollPosition(chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.GetScrollHeight());
			break;
		case "SystemMessageToggleBtn":
			HandleToggleSystemMessage();
			break;
	}
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle.GetWindowName())
	{
		case "ChnnelTradeBtn":
			ShowContextMenuChannel(CHANNEL_ID_TRADE, a_WindowHandle);
			break;
		case "ChnnelPartyBtn":
			ShowContextMenuChannel(CHANNEL_ID_PARTY, a_WindowHandle);
			break;
		case "ChnnelClanBtn":
			ShowContextMenuChannel(CHANNEL_ID_CLAN, a_WindowHandle);
			break;
	}
}

private function ShowContextMenuChannel(int chatType, WindowHandle a_WindowHandle)
{
	local UIControlContextMenu ContextMenu;
	local int currentchannelID;

	ContextMenu = class'UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	ContextMenu.DelegateOnHide = HandleOnHideContextMenu;
	GetINIInt("global", "TabIndex" $ string(chatType), currentchannelID, "chatfilter.ini");
	ContextMenu.MenuNew(GetSystemStringByChatType(CHANNEL_ID_TRADE), 1, GetContextMenuColor(currentchannelID, CHANNEL_ID_TRADE));
	ContextMenu.MenuNew(GetSystemStringByChatType(CHANNEL_ID_PARTY), 2, GetContextMenuColor(currentchannelID, CHANNEL_ID_PARTY));
	ContextMenu.MenuNew(GetSystemStringByChatType(CHANNEL_ID_CLAN), 3, GetContextMenuColor(currentchannelID, CHANNEL_ID_CLAN));
	ContextMenu.MenuNew(GetSystemStringByChatType(CHANNEL_ID_ALLY), 4, GetContextMenuColor(currentchannelID, CHANNEL_ID_ALLY));
	ContextMenu.MenuNew(GetSystemStringByChatType(CHANNEL_ID_HERO), 5, GetContextMenuColor(currentchannelID, CHANNEL_ID_HERO));
	ContextMenu.MenuNew(GetSystemStringByChatType(CHANNEL_ID_PARTYMASTER), 6, GetContextMenuColor(currentchannelID, CHANNEL_ID_PARTYMASTER));
	ContextMenu.MenuNew(GetSystemStringByChatType(CHANNEL_ID_SHOUT), 7, GetContextMenuColor(currentchannelID, CHANNEL_ID_SHOUT));
	ContextMenu.MenuNew(GetSystemStringByChatType(CHANNEL_ID_WORLD), 8, GetContextMenuColor(currentchannelID, CHANNEL_ID_WORLD));

	if(IsAdenServer())
	{
		ContextMenu.MenuNew(GetSystemStringByChatType(CHANNEL_ID_INRAIDSERVER), 9, GetContextMenuColor(currentchannelID, CHANNEL_ID_INRAIDSERVER));
	}
	ContextMenu._SetReservedInt(chatType);
	ContextMenu._ShowTo(a_WindowHandle, string(self));
}

private function Color GetContextMenuColor(int currentchannelID, int channelID)
{
	if(currentchannelID == channelID)
	{
		return getInstanceL2Util().Yellow;
	}
	return getInstanceL2Util().White;
}

private function HandleOnHideContextMenu()
{
	_Swap2AlphaNormal();
}

private function HandleOnClickContextMenu(int channelID)
{
	local int i, tabindex;

	tabindex = class'UIControlContextMenu'.static.GetInstance()._GetReservedInt();

	for(i = 1; i < 4; i++)
	{
		// End:0x44
		if(i == tabindex)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x7C
		if(chatTabInfos[i].channelID == channelID)
		{
			ChangeTabChannel(i, chatTabInfos[tabindex].channelID);
			// [Explicit Break]
			break;
		}
	}

	ChangeTabChannel(tabindex, channelID);

	if(class'UIAPI_WINDOW'.static.IsShowWindow("OptionWnd"))
	{
		CallGFxFunction("OptionWnd", "channelChanged", "");
	}
	ChangePrefix(tabindex, channelID);
}

private function Clear()
{
	ChatEditBox.Clear();
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.Clear();
	chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd.Clear();
	chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd.Clear();
	chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.Clear();
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case TIMER_ID_PARTYMATCH:
			ClosePartyMatchingWnd();
			m_hChatWnd.KillTimer(TIMER_ID_PARTYMATCH);
			break;
		case TIMER_ID_CHANTTINGFADEOUTDELAY:
			_Swap2AlphaNormal();
			class'SystemMsgWnd'.static.Inst()._Swap2Alpha();
			break;
	}
}

event OnTabSplit(string sTabButton)
{
	local int tabindex;

	switch(sTabButton)
	{
		case "ChatTabCtrl0":
			return;
	}

	tabindex = int(Right(sTabButton, 1));
	HandleTabClick(sTabButton);
	chatTabInfos[tabindex].tabButton.SetAlpha(255, FADE_IN_SPEED);
	chatTabInfos[tabindex].isSplit = true;
	chatTabInfos[tabindex].tabMergeBtn.ShowWindow();
	ChatTabCtrl.SetTopOrder(tabindex, true);
	CheckOnChangeStateMessageBtn(tabindex);

	if(tabindex != 0 && tabindex < chatTabInfos.Length)
	{
		chatTabInfos[tabindex].ChatWnd.Move(0, 0);
		chatTabInfos[tabindex].ChatWnd.SetWindowSizeRel(-1.0f, -1.0f, 0, 0);
		chatTabInfos[tabindex].ChatWnd.SetResizeFrameOffset(CHATWNDMINWIDTH, CHATWNDMINHEIGHTSPLIT);
		chatTabInfos[tabindex].ChatWnd.SetSettledWnd(true);
		chatTabInfos[tabindex].ChatWnd.EnableTexture(true);
	}
	AnchorTabs();
}

event OnTabMerge(string sTabButton)
{
	local int tabindex;
	local Rect rectWnd;

	switch(sTabButton)
	{
		case "ChatTabCtrl0":
			return;
	};

	tabindex = int(Right(sTabButton, 1));
	chatTabInfos[tabindex].isSplit = false;
	chatTabInfos[tabindex].tabMergeBtn.HideWindow();
	CheckOnChangeStateMessageBtn(tabindex);

	if(tabindex != 0 && tabindex < chatTabInfos.Length)
	{
		rectWnd = chatTabInfos[0].ChatWnd.GetRect();
		chatTabInfos[tabindex].ChatWnd.MoveTo(rectWnd.nX, rectWnd.nY);
		chatTabInfos[tabindex].ChatWnd.SetWindowSizeRel(1.0f, 1.0f, 0, -27);
		chatTabInfos[tabindex].ChatWnd.SetSettledWnd(false);
		chatTabInfos[tabindex].ChatWnd.EnableTexture(false);

		if(IsMouseOver)
		{
			chatTabInfos[tabindex].tabButton.SetAlpha(255);
			chatTabInfos[tabindex].channelBtn.SetAlpha(255);					
		}
		else
		{
			chatTabInfos[tabindex].tabButton.SetAlpha(0);
			chatTabInfos[tabindex].channelBtn.SetAlpha(0);
		}
	}

	if(isMinSize)
	{
		_Swap2Min();
	}
	AnchorTabs();
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_ChatMessage:
			HandleChatMessage(param);
			break;
		case EV_ChatWndSetFocus:
			HandleSetFocus();
			break;
		case EV_ChatWndSetString:
			HandleSetString(param);
			break;
		case EV_ChatWndMacroCommand:
			HandleChatWndMacroCommand(param);
			break;
		case EV_TextLinkLButtonClick:
			HandleTextLinkLButtonClick(param);
			break;
		case EV_TextLinkRButtonClick:
			HandleTextLinkRButtonClick(param);
			break;
		case EV_ChatIconClick:
			HandleChatIconClick(param);
			break;
		case EV_DominionWarChannelSet:
			HandleDominionWarChannelSet(param);
			break;
		case EV_GamingStateEnter:
			// ������ ���õǾ��� ä������ ����
			if(lastClickChatTabName != "")
			{
				ChatTabCtrl.SetTopOrder(int(Right(lastClickChatTabName, 1)), true);
				HandleTabClick(lastClickChatTabName);

				if(isMinSize)
				{
					_Swap2Min();
				}
			}
			break;
		case EV_Restart:
		case EV_NeedResetUIData:
			handleOnRestart();
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
		case EV_DialogCancel:
			break;
		case EV_ChatWndOnResize:
			UpdateSize(param);
			break;
		case EV_ResolutionChanged:
			UpdateResolution();
			break;
		case EV_GameStart:
			Clear();
			break;
		case EV_RequestInvitePartyAction:
			API_C_EX_REQUEST_INVITE_PARTY(param);
			break;
		case EV_OptionHasApplied:
			HandleOptionHasAppled();
			CheckChatSetIME();
			break;
	}
}

private function CheckChatSetIME()
{
	if(! GetChatFilterBool("Global", "EnterChatting"))
	{
		ChatEditBox.SetIME();
	}
}

event OnMouseOver(WindowHandle W)
{
	local int tabindex;

	IsMouseOver = true;

	tabindex = GetTabIndexWithWindowHandle(W);

	if(tabindex != -1)
	{
		_Swap2FullAlpha(tabindex);
		return;
	}
	if(isMinSize)
	{
		return;
	}

	_Swap2FullAlphaNormal();
	class'SystemMsgWnd'.static.Inst()._Swap2FullAlpha();
}

private function int GetTabIndexWithWindowHandle(WindowHandle W)
{
	local int i;

	for(i = 1; i < chatTabInfos.Length; i++)
	{
		// End:0x87
		if(chatTabInfos[i].isSplit)
		{
			switch(W)
			{
				case chatTabInfos[i].ChatWnd:
				case chatTabInfos[i].tabButton:
				case chatTabInfos[i].channelBtn:
				case chatTabInfos[i].newMessageBtn:
					return i;
			}
		}
		return -1;
	}
}

event OnMouseOut(WindowHandle W)
{
	IsMouseOver = false;

	if(ChatEditBox.IsFocused())
	{
		return;
	}
	switch(GetTabIndexWithWindowHandle(W))
	{
		case 1:
			_Swap2Alpha(1);
			return;
		case 2:
			_Swap2Alpha(2);
			return;
		case 3:
			_Swap2Alpha(3);
			return;
	}

	_Swap2AlphaNormal();
	class'SystemMsgWnd'.static.Inst()._Swap2Alpha();
}

function _Swap2FullAlpha(int tabindex)
{
	chatTabInfos[tabindex].ChatWnd.SetAlpha(255, FADE_IN_SPEED);
	chatTabInfos[tabindex].tabButton.SetAlpha(255, FADE_IN_SPEED);
	chatTabInfos[tabindex].channelBtn.SetAlpha(255, FADE_IN_SPEED);
	chatTabInfos[tabindex].newMessageBtn.SetAlpha(255, FADE_IN_SPEED);
}

function _Swap2Alpha(int tabindex)
{
	if(m_bUseAlpha == 1)
	{
		chatTabInfos[tabindex].ChatWnd.SetAlpha(0, FADE_OUT_SPEED);
	}
	chatTabInfos[tabindex].channelBtn.SetAlpha(0, FADE_OUT_SPEED);
	chatTabInfos[tabindex].tabButton.SetAlpha(0, FADE_OUT_SPEED);
}

function _Swap2FullAlphaNormal()
{
	m_hOwnerWnd.KillTimer(TIMER_ID_CHANTTINGFADEOUTDELAY);
	m_ChatMinBtn.SetAlpha(255, FADE_IN_SPEED);
	m_ChatFilterBtn.SetAlpha(255, FADE_IN_SPEED);
	ChatEditBox.SetAlpha(255, FADE_IN_SPEED);
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].tabButton.SetAlpha(255, FADE_IN_SPEED);
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.SetAlpha(255, FADE_IN_SPEED);
	SystemMsg.SetAlpha(255, FADE_IN_SPEED);
	chatTabInfos[CHAT_WINDOW_TAB_1].tabMergeBtn.SetAlpha(255, FADE_IN_SPEED);
	chatTabInfos[CHAT_WINDOW_TAB_2].tabMergeBtn.SetAlpha(255, FADE_IN_SPEED);
	chatTabInfos[CHAT_WINDOW_TAB_3].tabMergeBtn.SetAlpha(255, FADE_IN_SPEED);
	dragTabNormal.SetAlpha(255, FADE_IN_SPEED);
	m_ChatWndBg.SetAlpha(255, FADE_IN_SPEED);

	if(! chatTabInfos[CHAT_WINDOW_TAB_1].isSplit)
	{
		_Swap2FullAlpha(CHAT_WINDOW_TAB_1);
	}
	if(! chatTabInfos[CHAT_WINDOW_TAB_2].isSplit)
	{
		_Swap2FullAlpha(CHAT_WINDOW_TAB_2);
	}
	if(! chatTabInfos[CHAT_WINDOW_TAB_3].isSplit)
	{
		_Swap2FullAlpha(CHAT_WINDOW_TAB_3);
	}
}

function _Swap2AlphaNormal()
{
	local UIControlContextMenu ContextMenu;

	m_hOwnerWnd.KillTimer(TIMER_ID_CHANTTINGFADEOUTDELAY);
	ContextMenu = class'UIControlContextMenu'.static.GetInstance();

	if(ContextMenu.IsMine(string(self)))
	{
		if(ContextMenu.m_hOwnerWnd.IsShowWindow())
		{
			return;
		}
	}
	m_ChatMinBtn.SetAlpha(0, FADE_OUT_SPEED);
	m_ChatFilterBtn.SetAlpha(0, FADE_OUT_SPEED);
	ChatEditBox.SetAlpha(0, FADE_OUT_SPEED);
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].tabButton.SetAlpha(0, FADE_OUT_SPEED);
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.SetAlpha(0, FADE_OUT_SPEED);
	SystemMsg.SetAlpha(0, FADE_OUT_SPEED);
	chatTabInfos[CHAT_WINDOW_TAB_1].tabMergeBtn.SetAlpha(0, FADE_OUT_SPEED);
	chatTabInfos[CHAT_WINDOW_TAB_2].tabMergeBtn.SetAlpha(0, FADE_OUT_SPEED);
	chatTabInfos[CHAT_WINDOW_TAB_3].tabMergeBtn.SetAlpha(0, FADE_OUT_SPEED);
	dragTabNormal.SetAlpha(0, FADE_OUT_SPEED);

	if(m_bUseAlpha == 1)
	{
		m_ChatWndBg.SetAlpha(0, FADE_OUT_SPEED);
	}
	if(! chatTabInfos[CHAT_WINDOW_TAB_1].isSplit)
	{
		_Swap2Alpha(CHAT_WINDOW_TAB_1);
	}
	if(! chatTabInfos[CHAT_WINDOW_TAB_2].isSplit)
	{
		_Swap2Alpha(CHAT_WINDOW_TAB_2);
	}
	if(! chatTabInfos[CHAT_WINDOW_TAB_3].isSplit)
	{
		_Swap2Alpha(CHAT_WINDOW_TAB_3);
	}
}

private function ChangePrefix(int tabindex, int channelID)
{
	local string strInput, strPrefix;

	if(! GetChatFilterBool("Global", "OldChatting"))
	{
		return;
	}
	if(m_chatType.UI != tabindex)
	{
		return;
	}
	strInput = ChatEditBox.GetString();
	IsPrefix(strInput);

	if(tabindex != 0)
	{
		strPrefix = GetChatPrefix(GetChatTypeByTabIndex(tabindex));

		if(strPrefix != "~")
		{
			strInput = strPrefix $ strInput;
		}
	}
	bPrefixChanged = true;
	ChatEditBox.SetString(strInput);
	bPrefixChanged = false;
}

private function bool IsPrefix(out string strInput)
{
	local string strPrefix;
	local int StrLen;

	StrLen = Len(strInput);
	strPrefix = Left(strInput, 1);

	if(IsSameChatPrefix(SPT_MARKET, strPrefix) 
		|| IsSameChatPrefix(SPT_PARTY, strPrefix)
		|| IsSameChatPrefix(SPT_PLEDGE, strPrefix)
		|| IsSameChatPrefix(SPT_ALLIANCE, strPrefix)
		|| IsSameChatPrefix(SPT_HERO, strPrefix)
		|| IsSameChatPrefix(SPT_INTER_PARTYMASTER_CHAT, strPrefix)
		|| IsSameChatPrefix(SPT_SHOUT, strPrefix)
		|| IsSameChatPrefix(SPT_WORLD, strPrefix)
		|| IsSameChatPrefix(SPT_DOMINIONWAR, strPrefix)
		|| IsSameChatPrefix(SPT_WORLD_INRAIDSERVER, strPrefix))
	{
		strInput = Right(strInput, StrLen - 1);
		return true;
	}
	return false;
}

function HandleTabClick(string strID)
{
	m_chatType.UI = ChatTabCtrl.GetTopIndex();
	m_chatType.Id = chatTabInfos[m_chatType.UI].channelID;
	lastClickChatTabName = strID;
	ChangePrefix(m_chatType.UI, m_chatType.Id);
	CheckOnChangeStateMessageBtn(CHAT_WINDOW_TAB_NORMAL);
	CheckOnChangeStateMessageBtn(CHAT_WINDOW_TAB_1);
	CheckOnChangeStateMessageBtn(CHAT_WINDOW_TAB_2);
	CheckOnChangeStateMessageBtn(CHAT_WINDOW_TAB_3);
}

function bool CheckFilter(SayPacketType SayType, int channelID, ESystemMsgType systemType) // systemType�� CHAT_SYSTEM�� ��츸 �Ѱ��ָ�ȴ�
{
	// Debug("---CheckFilter channelID: " @ channelID);
	//if((SayType == SPT_NPC_NORMAL || SayType == SPT_NPC_SHOUT))
	//{
		// Debug(" SayType!!! " @ string(SayType)); 
		// Debug(" channelID!!! " @ channelID);
		// Debug(" ��ȭ��!!! " @ m_filterInfo[channelID].bNoNpcMessage);
	//}

	if(!(channelID >= 0 && channelID < CHANNEL_ID_COUNT) && channelID != CHANNEL_ID_SYSTEM)
	{
		return false;
	}
	switch(SayType)
	{
		case SPT_MARKET:
			return m_filterInfo[channelID].bTrade != 0;
		case SPT_NORMAL:
			return m_filterInfo[channelID].bNormal != 0;
		case SPT_PLEDGE:
		case SPT_CASTLEWAR_PLEDGE_COMMAND_MSG:
			return m_filterInfo[channelID].bClan != 0;
		case SPT_PARTY:
			return m_filterInfo[channelID].bParty != 0;
		case SPT_SHOUT:
			return m_filterInfo[channelID].bShout != 0;
		case SPT_TELL:
			return m_filterInfo[channelID].bWhisper != 0;
		case SPT_ALLIANCE:
			return m_filterInfo[channelID].bAlly != 0;
		case SPT_WORLD_INRAIDSERVER:
			return m_filterInfo[channelID].bWorldUnion != 0;
		case SPT_HERO:
			return channelID != CHANNEL_ID_SYSTEM;
		case SPT_DOMINIONWAR:
			return m_filterInfo[channelID].bBattle != 0;
		case SPT_INTER_PARTYMASTER_CHAT:
		case SPT_COMMANDER_CHAT:
			return m_filterInfo[channelID].bUnion != 0;
		case SPT_NPC_NORMAL:
		case SPT_NPC_SHOUT:
			return m_filterInfo[channelID].bNoNpcMessage != 0;
		case SPT_WORLD:
			return (m_filterInfo[channelID].bWorldChat != 0) && channelID != CHANNEL_ID_SYSTEM;
		case SPT_ANNOUNCE:
		case SPT_CRITICAL_ANNOUNCE:
		case SPT_GM_PET:
		case SPT_FRIEND_ANNOUNCE:
			return true;
		case SPT_SYSTEM:
			break;

		default:
			return false;
	}

	if(channelID == CHANNEL_ID_SYSTEM)
	{
		switch(systemType)
		{
			case SYSTEM_SERVER:
			case SYSTEM_PETITION:
				return true;
			case SYSTEM_BATTLE:
			case SYSTEM_NONE:
				return bool(m_bSystemMsgWnd);
			case SYSTEM_DAMAGETEXT:
				return bool(m_bSystemMsgWnd) || bool(m_bDamageOption);
			case SYSTEM_DAMAGE:
				return bool(m_bDamageOption);
			case SYSTEM_USEITEMS:
				return bool(m_bUseSystemItem);
			case SYSTEM_GETITEMS:
				if(IsBuilderPC())
				{
					if(bShowSystemMessage)
					{
						return true;
					}
				}
				return ! getInstanceUIData().getIsClassicServer();
			case SYSTEM_DICE:
				if(IsBuilderPC())
				{
					if(bShowSystemMessage)
					{
						return true;
					}
				}
				return ! getInstanceUIData().getIsClassicServer() && bool(m_bDiceOption);

			case SYSTEM_ESSENTIAL:
				return true;
		}
	}

	if(! bool(m_bOnlyUseSystemMsgWnd) || getInstanceUIData().getIsClassicServer())
	{
		switch(systemType)
		{
			case SYSTEM_SERVER:
			case SYSTEM_PETITION:
				return true;
			case SYSTEM_BATTLE:
			case SYSTEM_NONE:
				if(IsBuilderPC())
				{
					if(bShowSystemMessage)
					{
						return true;
					}
				}
				if(getInstanceUIData().getIsClassicServer())
				{
					return false;
				}
				return m_filterInfo[channelID].bSystem != 0;
			case SYSTEM_DAMAGETEXT:
				if(IsBuilderPC())
				{
					if(bShowSystemMessage)
					{
						return true;
					}
				}
				if(getInstanceUIData().getIsClassicServer())
				{
					return false;
				}
				return (m_filterInfo[channelID].bSystem != 0) || m_filterInfo[channelID].bDamage != 0;
			case SYSTEM_DAMAGE:
				if(IsBuilderPC())
				{
					if(bShowSystemMessage)
					{
						return true;
					}
				}
				if(getInstanceUIData().getIsClassicServer())
				{
					return false;
				}
				return m_filterInfo[channelID].bDamage != 0;
			case SYSTEM_USEITEMS:
				if(IsBuilderPC())
				{
					if(bShowSystemMessage)
					{
						return true;
					}
				}
				if(getInstanceUIData().getIsClassicServer())
				{
					return false;
				}
				return m_filterInfo[channelID].bUseitem != 0;
			case SYSTEM_GETITEMS:
				return m_filterInfo[channelID].bGetitems != 0;
			case SYSTEM_DICE:
				return m_filterInfo[channelID].bDice != 0;
			case SYSTEM_ESSENTIAL:
			case SYSTEM_CLIENT_DEBUG_MSG:
				return true;
		}
	}

	return false;
}

// init with chatfilter.ini
function InitFilterInfo()
{
	local int i;
	local int tempVal;
	local string tempstring;

	SetDefaultFilterValue();

	for(i=0; i < CHANNEL_ID_COUNT ; ++i)
	{
		if(GetINIBool(m_sectionName[i], "dice", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bDice = tempVal;
		}
		else
		{
			SetINIBool(m_sectionName[i], "dice", bool(m_filterInfo[i].bDice), "chatfilter.ini");
		}

		if(GetINIBool(m_sectionName[i], "getitems", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bGetitems = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "system", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bSystem = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "chat", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bChat = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "normal", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bNormal = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "shout", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bShout = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "pledge", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bClan = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "party", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bParty = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "market", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bTrade = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "tell", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bWhisper = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "damage", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bDamage = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "ally", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bAlly = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "worldUnion", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bWorldUnion = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "useitems", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bUseitem = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "hero", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bHero = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "union", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bUnion = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "battle", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bBattle = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "nonpcmessage", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bNoNpcMessage = tempVal;
		}

		//����ä�� �߰�
		if(GetINIBool(m_sectionName[i], "worldChat", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bWorldChat = tempVal;
		}
	}

	// ������ �߸��� INI�� ���� �������� ���� �⺻ ���� �׻� �����Ѵ�. 
	SetDefaultFilterOn();

	m_UseChatSymbol = int(GetChatFilterBool("Global", "OldChatting"));
	//m_UseChatSymbol = int(GetOptionBool("CommunIcation", "OldChatting"));
	
	//���� ä�� ����Ŀ
	if(GetINIBool("global", "UseWorldChatSpeaker", tempVal, "chatfilter.ini"))
	{
		m_bWorldChatSpeaker = tempVal;
	}

	//Global Setting
	//if(GetINIBool("global", "command", tempVal, "chatfilter.ini"))
	//	m_NoUnionCommanderMessage = tempVal;

	//if(GetINIBool("global", "npc", tempVal, "chatfilter.ini"))	// NPC ��� ���͸� - 2010.9.8 winkey
	//	m_NoNpcMessage = tempVal;

	if(GetINIBool("global", "keywordsound", tempVal, "chatfilter.ini"))
	{
		m_KeywordFilterSound = tempVal;
	}
	if(GetINIBool("global", "keywordactivate", tempVal, "chatfilter.ini"))
	{
		m_KeywordFilterActivate = tempVal;
	}
	if(GetINIString("global", "Keyword0", tempstring, "chatfilter.ini"))
	{
		m_Keyword0 = tempstring;
	}
	if(GetINIString("global", "Keyword1", tempstring, "chatfilter.ini"))
	{
		m_Keyword1 = tempstring;
	}
	if(GetINIString("global", "Keyword2", tempstring, "chatfilter.ini"))
	{
		m_Keyword2 = tempstring;
	}
	if(GetINIString("global", "Keyword3", tempstring, "chatfilter.ini"))
	{
		m_Keyword3 = tempstring;
	}
	if(getInstanceUIData().getIsLiveServer())
	{
		GetINIBool("global", "SystemMsgWnd", tempVal, "chatfilter.ini");
		m_bUseSystemMsgWnd = tempVal;
	}
	else
	{
		m_bUseSystemMsgWnd = 0;
	}
	if(GetINIBool("global", "UseSystemMsg", tempVal, "chatfilter.ini"))
	{
		m_bSystemMsgWnd = tempVal;
	}
	if(GetINIBool("global", "SystemMsgWndDamage", tempVal, "chatfilter.ini"))
	{
		m_bDamageOption = tempVal;
	}
	if(GetINIBool("global", "SystemMsgWndDice", tempVal, "chatfilter.ini"))
	{
		m_bDiceOption = tempVal;
	}
	if(GetINIBool("global", "SystemMsgWndExpendableItem", tempVal, "chatfilter.ini"))
	{
		m_bUseSystemItem = tempVal;
	}
	if(GetINIBool("global", "OnlyUseSystemMsgWnd", tempVal, "chatfilter.ini"))
	{
		m_bOnlyUseSystemMsgWnd = tempVal;
	}
}

function SetDefaultFilterValue()
{
	local int bSystemNDamage;

	if(getInstanceUIData().getIsLiveServer())
	{
		bSystemNDamage = 1;
	}
	else
	{
		bSystemNDamage = 0;
	}
	m_filterInfo[0].bDice = 1;
	m_filterInfo[0].bGetitems = 1;
	m_filterInfo[0].bSystem = bSystemNDamage;
	m_filterInfo[0].bChat = 1;
	m_filterInfo[0].bNormal = 1;
	m_filterInfo[0].bShout = 1;
	m_filterInfo[0].bClan = 1;
	m_filterInfo[0].bParty = 1;
	m_filterInfo[0].bTrade = 1;
	m_filterInfo[0].bWhisper = 1;
	m_filterInfo[0].bDamage = bSystemNDamage;
	m_filterInfo[0].bAlly = 1;
	m_filterInfo[0].bUseitem = 0;
	m_filterInfo[0].bHero = 0;
	m_filterInfo[0].bUnion = 1;
	m_filterInfo[0].bBattle = 1;
	m_filterInfo[0].bNoNpcMessage = 0;
	m_filterInfo[0].bWorldChat = 1;

	m_filterInfo[1].bDice = 1;
	m_filterInfo[1].bGetitems = 1;
	m_filterInfo[1].bSystem = bSystemNDamage;
	m_filterInfo[1].bChat = 1;
	m_filterInfo[1].bNormal = 0;
	m_filterInfo[1].bShout = 1;
	m_filterInfo[1].bClan = 0;
	m_filterInfo[1].bParty = 0;
	m_filterInfo[1].bTrade = 1;
	m_filterInfo[1].bWhisper = 1;
	m_filterInfo[1].bDamage = bSystemNDamage;
	m_filterInfo[1].bAlly = 0;
	m_filterInfo[1].bUseitem = 0;
	m_filterInfo[1].bHero = 0;
	m_filterInfo[1].bUnion = 1;
	m_filterInfo[1].bBattle = 0;
	m_filterInfo[1].bNoNpcMessage = 0;
	m_filterInfo[1].bWorldChat = 0;

	m_filterInfo[2].bDice = 1;
	m_filterInfo[2].bGetitems = 1;
	m_filterInfo[2].bSystem = bSystemNDamage;
	m_filterInfo[2].bChat = 1;
	m_filterInfo[2].bNormal = 0;
	m_filterInfo[2].bShout = 1;
	m_filterInfo[2].bClan = 0;
	m_filterInfo[2].bParty = 1;
	m_filterInfo[2].bTrade = 0;
	m_filterInfo[2].bWhisper = 1;
	m_filterInfo[2].bDamage = bSystemNDamage;
	m_filterInfo[2].bAlly = 0;
	m_filterInfo[2].bUseitem = 0;
	m_filterInfo[2].bHero = 0;
	m_filterInfo[2].bUnion = 1;
	m_filterInfo[2].bBattle = 0;
	m_filterInfo[2].bNoNpcMessage = 0;
	m_filterInfo[2].bWorldChat = 0;

	m_filterInfo[3].bDice = 1;
	m_filterInfo[3].bGetitems = 1;
	m_filterInfo[3].bSystem = bSystemNDamage;
	m_filterInfo[3].bChat = 1;
	m_filterInfo[3].bNormal = 0;
	m_filterInfo[3].bShout = 1;
	m_filterInfo[3].bClan = 1;
	m_filterInfo[3].bParty = 0;
	m_filterInfo[3].bTrade = 0;
	m_filterInfo[3].bWhisper = 1;
	m_filterInfo[3].bDamage = bSystemNDamage;
	m_filterInfo[3].bAlly = 0;
	m_filterInfo[3].bUseitem = 0;
	m_filterInfo[3].bHero = 0;
	m_filterInfo[3].bUnion = 1;
	m_filterInfo[3].bBattle = 0;
	m_filterInfo[3].bNoNpcMessage = 0;
	m_filterInfo[3].bWorldChat = 0;

	m_filterInfo[4].bDice = 1;
	m_filterInfo[4].bGetitems = 1;
	m_filterInfo[4].bSystem = bSystemNDamage;
	m_filterInfo[4].bChat = 1;
	m_filterInfo[4].bNormal = 0;
	m_filterInfo[4].bShout = 1;
	m_filterInfo[4].bClan = 0;
	m_filterInfo[4].bParty = 0;
	m_filterInfo[4].bTrade = 0;
	m_filterInfo[4].bWhisper = 1;
	m_filterInfo[4].bDamage = bSystemNDamage;
	m_filterInfo[4].bAlly = 1;
	m_filterInfo[4].bUseitem = 0;
	m_filterInfo[4].bHero = 0;
	m_filterInfo[4].bUnion = 1;
	m_filterInfo[4].bBattle = 0;
	m_filterInfo[4].bNoNpcMessage = 0;
	m_filterInfo[4].bWorldChat = 0;

	m_filterInfo[5].bDice = 1;
	m_filterInfo[5].bGetitems = 1;
	m_filterInfo[5].bSystem = bSystemNDamage;
	m_filterInfo[5].bChat = 0;
	m_filterInfo[5].bNormal = 0;
	m_filterInfo[5].bShout = 1;
	m_filterInfo[5].bClan = 0;
	m_filterInfo[5].bParty = 0;
	m_filterInfo[5].bTrade = 0;
	m_filterInfo[5].bWhisper = 1;
	m_filterInfo[5].bDamage = bSystemNDamage;
	m_filterInfo[5].bAlly = 0;
	m_filterInfo[5].bUseitem = 0;
	m_filterInfo[5].bHero = 1;
	m_filterInfo[5].bUnion = 1;
	m_filterInfo[5].bBattle = 0;
	m_filterInfo[5].bNoNpcMessage = 0;
	m_filterInfo[5].bWorldChat = 0;

	m_filterInfo[6].bDice = 1;
	m_filterInfo[6].bGetitems = 1;
	m_filterInfo[6].bSystem = bSystemNDamage;
	m_filterInfo[6].bChat = 0;
	m_filterInfo[6].bNormal = 0;
	m_filterInfo[6].bShout = 1;
	m_filterInfo[6].bClan = 0;
	m_filterInfo[6].bParty = 0;
	m_filterInfo[6].bTrade = 0;
	m_filterInfo[6].bWhisper = 1;
	m_filterInfo[6].bDamage = bSystemNDamage;
	m_filterInfo[6].bAlly = 0;
	m_filterInfo[6].bUseitem = 0;
	m_filterInfo[6].bHero = 0;
	m_filterInfo[6].bUnion = 1;
	m_filterInfo[6].bBattle = 0;
	m_filterInfo[6].bNoNpcMessage = 0;
	m_filterInfo[6].bWorldChat = 0;

	m_filterInfo[7].bDice = 1;
	m_filterInfo[7].bGetitems = 1;
	m_filterInfo[7].bSystem = bSystemNDamage;
	m_filterInfo[7].bChat = 0;
	m_filterInfo[7].bNormal = 0;
	m_filterInfo[7].bShout = 1;
	m_filterInfo[7].bClan = 0;
	m_filterInfo[7].bParty = 0;
	m_filterInfo[7].bTrade = 0;
	m_filterInfo[7].bWhisper = 1;
	m_filterInfo[7].bDamage = bSystemNDamage;
	m_filterInfo[7].bAlly = 0;
	m_filterInfo[7].bUseitem = 0;
	m_filterInfo[7].bHero = 0;
	m_filterInfo[7].bUnion = 1;
	m_filterInfo[7].bBattle = 0;
	m_filterInfo[7].bNoNpcMessage = 0;
	m_filterInfo[7].bWorldChat = 0;

	m_filterInfo[8].bDice = 1;
	m_filterInfo[8].bGetitems = 1;
	m_filterInfo[8].bSystem = bSystemNDamage;
	m_filterInfo[8].bChat = 0;
	m_filterInfo[8].bNormal = 0;
	m_filterInfo[8].bShout = 1;
	m_filterInfo[8].bClan = 0;
	m_filterInfo[8].bParty = 0;
	m_filterInfo[8].bTrade = 0;
	m_filterInfo[8].bWhisper = 1;
	m_filterInfo[8].bDamage = bSystemNDamage;
	m_filterInfo[8].bAlly = 0;
	m_filterInfo[8].bUseitem = 0;
	m_filterInfo[8].bHero = 0;
	m_filterInfo[8].bUnion = 1;
	m_filterInfo[8].bBattle = 0;
	m_filterInfo[8].bNoNpcMessage = 0;
	m_filterInfo[8].bWorldChat = 1;

	//���� �������� �ʴ� ���� ����
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bGetitems = 1;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bSystem = bSystemNDamage;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bChat = 1;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bNormal = 0;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bShout = 0;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bClan = 0;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bParty = 0;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bTrade = 0;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bWhisper = 0;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bDamage = bSystemNDamage;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bAlly = 0;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bUseItem = 0;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bHero = 0;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bUnion = 0;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bNoNpcMessage = 0;
	//m_filterInfo[ CHANNEL_ID_SYSTEM ].bWorldChat = 1;
	
	//Global Setting
	m_bWorldChatSpeaker = 1;
	m_bUseSystemMsgWnd = 1;
	m_bSystemMsgWnd = 1;
	m_bDamageOption = 1;
	m_bDiceOption = 0;
	m_bUseSystemItem = 1;
	//m_NoUnionCommanderMessage = 1;
	m_NoNpcMessage = 0; // NPC ��� ���͸� - 2010.9.8 winkey
	m_KeywordFilterSound = 0;
	m_KeywordFilterActivate = 0;
	m_UseChatSymbol = 1;
	m_ChatResizeOnOff = 0;
	m_Keyword0 = "";
	m_Keyword1 = "";
	m_Keyword2 = "";
	m_Keyword3 = "";
	m_bOnlyUseSystemMsgWnd = 1;
}

//�޺��ڽ��� �ʱ�ȭ < �߰� ��>
function SetDefaultFilterValueWorldUnion()
{
	local int bSystemNDamage;

	if(getInstanceUIData().getIsLiveServer())
	{
		bSystemNDamage = 1;		
	}
	else
	{
		bSystemNDamage = 0;
	}
	m_filterInfo[9].bDice = 1;
	m_filterInfo[9].bGetitems = 1;
	m_filterInfo[9].bSystem = 0;
	m_filterInfo[9].bChat = 0;
	m_filterInfo[9].bNormal = 0;
	m_filterInfo[9].bShout = 0;
	m_filterInfo[9].bClan = 0;
	m_filterInfo[9].bParty = 0;
	m_filterInfo[9].bTrade = 0;
	m_filterInfo[9].bWhisper = 0;
	m_filterInfo[9].bDamage = bSystemNDamage;
	m_filterInfo[9].bAlly = 0;
	m_filterInfo[9].bWorldUnion = 1;
	m_filterInfo[9].bUseitem = 0;
	m_filterInfo[9].bHero = 1;
	m_filterInfo[9].bUnion = 0;
	m_filterInfo[9].bBattle = 0;
	m_filterInfo[9].bNoNpcMessage = 0;
	m_filterInfo[9].bWorldChat = 0;
	m_filterInfo[0].bWorldUnion = 1;
	m_filterInfo[1].bWorldUnion = 1;
	m_filterInfo[2].bWorldUnion = 1;
	m_filterInfo[3].bWorldUnion = 1;
	m_filterInfo[4].bWorldUnion = 1;
	m_filterInfo[5].bWorldUnion = 1;
	m_filterInfo[6].bWorldUnion = 1;
	m_filterInfo[7].bWorldUnion = 1;
	m_filterInfo[8].bWorldUnion = 1;
}

private function HandlePartyMatchWnd()
{
	local WindowHandle TaskWnd;
	local PartyMatchRoomWnd p2_script;

	p2_script = PartyMatchRoomWnd(GetScript("PartyMatchRoomWnd"));
	TaskWnd = GetWindowHandle("PartyMatchWnd");

	if(TaskWnd.IsShowWindow())
	{
		ClosePartyMatchingWnd();
	}
	else
	{
		TaskWnd = GetWindowHandle("PartyMatchRoomWnd");

		if(TaskWnd.IsShowWindow())
		{
			TaskWnd.HideWindow();
			TaskWnd = GetWindowHandle("PartyMatchWnd");
			p2_script.OnSendPacketWhenHiding();
			TaskWnd = GetWindowHandle("ChatWnd");
			TaskWnd.SetTimer(TIMER_ID_PARTYMATCH, TIMER_TIME_PARTYMATCH);
		}
		else
		{
			TaskWnd = GetWindowHandle("PartyMatchWnd");
			//~ TaskWnd.ShowWindow();
			class'PartyMatchAPI'.static.RequestOpenPartyMatch();
			//~ ExecuteCommand("/partymatching");
		}
	}
	//~ ExecuteCommand("/partymatch");
}

private function ClosePartyMatchingWnd()
{
	local WindowHandle TaskWnd;
	local PartyMatchWnd p_script;

	p_script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	TaskWnd = GetWindowHandle("PartyMatchWnd");
	TaskWnd.HideWindow();
	p_script.OnSendPacketWhenHiding();
}

private function HandleChatmessage(string param)
{
	local int nTmp;
	local SayPacketType SayType;
	local ESystemMsgType systemType;
	local string Text;
	local string origText;
	local string userIDString;
	local Color Color, subColor;
	local SystemMsgData SysMsgData;
	local int SysMsgIndex;
	local int relationType;
	local int targetLevel;
	local int SharedPositionID, keyWordfoundNum, addedChatNum;

	//~ debug(param);
	ParseInt(param, "Type", nTmp);
	SayType = SayPacketType(nTmp);

	ParseString(param, "Msg", origText);
	ParseInt(param, "SharedPositionID", SharedPositionID);

	//Debug("param:"@param);
	//Debug("origText:" @ origText);

	// ������ �� ��ǿ� �ý��� �޼����� ä�� â�� ��� ���� �ʴ´�.
	if(LEFT(origText, 12) == "+hidden_msg+")
	{
		return;
	}

	// �ý��� �޽����϶��� ��ũ��Ʈ�� ������ ��� - lancelot 2008. 8. 18.
	if(SayType == SPT_SYSTEM)
	{
		ParseInt(param, "SysMsgIndex", SysMsgIndex);

		if(SysMsgIndex == -1)
		{
			Color = GetChatColorByType(SayType); // �ý��� �޽����� 5
			subColor = GetChatSubColorByType(SayType);
		}
		// ǥ�� ���� ���ƾ� �� �ý��� �޽��� 
		// ex 1. �ư��ÿ� ���� ��ų ���� �� ��ȯ �ȵ� �޽���
		else if(SysMsgIndex == 4700)
		{
			return;
		}
		else
		{
			GetSystemMsgInfo(SysMsgIndex, SysMsgData);
			Color = SysMsgData.FontColor;
		}

		ParseInt(param, "SysType", nTmp);
		systemType = ESystemMsgType(nTmp);

		// Ŭ���̾�Ʈ ����� �޼��� - lancelot 2010. 8. 2.
		if(systemType == SYSTEM_CLIENT_DEBUG_MSG)
		{
			Color.R = 62;
			Color.G = 239;
			Color.B = 10;
		}
	}
	else
	{
		Color = GetChatColorByType(SayType);
		subColor = GetChatSubColorByType(SayType);
		systemType = SYSTEM_NONE;
	}

	Text = origText;

	//�ӼӸ��� �� �� UserAlertMessage UI�� �޽����� ������.
	if(SayType == SPT_TELL)
	{
		ParseString(Text, "Title", userIDString);
		ParseInt(param, "Relation", relationType);
		ParseInt(param, "Level", TargetLevel);

		if(Right(Left(userIDString, 2), 1) != "-")
		{
			//callGFxFunction("UserAlertMessage", "UserRelationType", string(relationType));
			CallGFxFunction("UserAlertMessage", "WhisperMessage", "Title=" $ userIDString $ " RelationType=" $ string(relationType) $ " Level=" $ string(TargetLevel));
		}
		ShowmChatMaxBtnAlarm();
	}

	keyWordfoundNum = ChatNotificationFilter(Text, origText, m_Keyword0, m_Keyword1, m_Keyword2, m_Keyword3);
	AddStringToChatWindow(SayType, CHAT_WINDOW_TAB_NORMAL, systemType, Text, Color, subColor, SharedPositionID, addedChatNum);
	AddStringToChatWindow(SayType, CHAT_WINDOW_TAB_1, systemType, Text, Color, subColor, SharedPositionID, addedChatNum);
	AddStringToChatWindow(SayType, CHAT_WINDOW_TAB_2, systemType, Text, Color, subColor, SharedPositionID, addedChatNum);
	AddStringToChatWindow(SayType, CHAT_WINDOW_TAB_3, systemType, Text, Color, subColor, SharedPositionID, addedChatNum);

	if(CheckFilter(SayType, CHANNEL_ID_COUNT, systemType))
	{
		GetChatWindow(CHANNEL_ID_HERO).AddStringToChatWindow(Text, Color, subColor, SharedPositionID);
		CheckNewMessage(CHANNEL_ID_HERO);

		if(m_hSystemMsgWnd.IsShowWindow())
		{
			addedChatNum++;
		}
	}

	//Union Commander Message ���ջ�ɰ� �޽���
	if(SayType == SPT_COMMANDER_CHAT)//&& m_NoUnionCommanderMessage != 0)
	{
		ParseString(param, "FilteredMsg", origText);
		ShowScreenMessage(origText, 0);
		addedChatNum++;
	}
	if(SayType == SPT_SCREEN_ANNOUNCE)
	{
		Color.R = 0;
		Color.G = 255;
		Color.B = 255;

		chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.AddStringToChatWindow(Text, Color, subColor, SharedPositionID);
		chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd.AddStringToChatWindow(Text, Color, subColor, SharedPositionID);
		chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd.AddStringToChatWindow(Text, Color, subColor, SharedPositionID);
		chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.AddStringToChatWindow(Text, Color, subColor, SharedPositionID);
		addedChatNum++;
	}

	// �Ʒ��� ä�� ������
	if(SayType == SPT_CASTLEWAR_PLEDGE_COMMAND_MSG)
	{
		ShowGfxChattingMessage(param, Color);
	}
	if(addedChatNum > 0 && keyWordfoundNum > 0)
	{
		ShowmChatMaxBtnAlarm();

		if(m_KeywordFilterActivate == 1)
		{
			SetAlarmMaskKeyWord(origText);
		}
	}
}

private function ShowmChatMaxBtnAlarm()
{
	if(isMinSize)
	{
		m_ChatMaxBtnAlarm.ShowWindow();
	}
}

//ä�� â ���̵� â ������ ���� ��� �ּ�ȭ ��Ŵ
private function UpdateResolution()
{
	local int CurrentMaxWidth, CurrentMaxHeight, CurrentChatWidth, CurrentChatHeight, CurrentEditBoxWidth, CurrentEditBoxHeight;

	local bool isFixedW, isFixedH;

	GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
	m_hChatWnd.GetWindowSize(CurrentChatWidth, CurrentChatHeight);
	isFixedW = CurrentChatWidth > CurrentMaxWidth;
	isFixedH = CurrentChatHeight > (CurrentMaxHeight - 15);

	if(isFixedW || isFixedH)
	{
		m_hChatWnd.SetWindowSize(399, 130);
		m_hChatWnd.SetResizeFrameOffset(399, 130);
		ChatEditBox.GetWindowSize(CurrentEditBoxWidth, CurrentEditBoxHeight);
		ChatEditBox.SetWindowSize(399 - 52, CurrentEditBoxHeight);
		SetINIInt("global", "ChatSizeWidth", 399, "chatfilter.ini");
		SetINIInt("global", "ChatSizeHeight", 130, "chatfilter.ini");
		OnDefaultPosition();
	}
}

private function UpdateSize(string param)
{
	local int W, h, resizeWidth, resizeHeight;
	local string wName, sizeParam;

	ParseInt(param, "Width", resizeWidth);
	ParseInt(param, "Height", resizeHeight);
	ParseString(param, "WindowName", wName);
	ChatEditBox.GetWindowSize(W, h);
	ChatEditBox.SetWindowSize(resizeWidth - CHATEDITBOXOffSetX, h);
	ParamAdd(sizeParam, "w", string(resizeWidth));
	ParamAdd(sizeParam, "h", string(resizeHeight + 35));
	CallGFxFunction("UserAlertMessage", "ReceiveChatWndSize", sizeParam);
	CallGFxFunction("worldChatBox", "ReceiveChatWndSize", sizeParam);

	if(wName == "ChatWnd")
	{
		SetINIInt("global", "ChatSizeWidth", resizeWidth, "chatfilter.ini");
		SetINIInt("global", "ChatSizeHeight", resizeHeight, "chatfilter.ini");
	}
}

private function handleOnRestart()
{
	lastClickChatTabName = "";
	ChatTabCtrl.SetTopOrder(0, true);
	HandleTabClick("ChatTabCtrl0");
	ChatEditBox.ClearHistory();
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.Clear();
	chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd.Clear();
	chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd.Clear();
	chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.Clear();
	chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.Clear();
	SystemMsg.Clear();
}

//Ȩ������ ��ũ(10.1.28 ������ �߰�)
private function HandleDialogOK()
{
	if(!DialogIsMine())
	{
		return;
	}

	switch(DialogGetID())
	{
		case DIALOGID_GoWeb:
			OpenGivenURL(Url);
			break;
	}
}

//��ũ��Ŀ�ǵ��� ����, UC�� ChatType�� �°� ����Ǿ���Ѵ�.
private function HandleChatWndMacroCommand(string param)
{
	local string Command;
	local SayPacketType SayType;

	if(!ParseString(param, "Command", Command))
	{
		return;
	}

	SayType = GetChatTypeByTabIndex(m_chatType.UI);
	ProcessChatMessage(Command, SayType, false);
}

private function HandleSetString(string a_Param)
{
	local int IsAppend;
	local string tmpString;

	IsAppend = 0;
	ParseInt(a_Param, "IsAppend", IsAppend);

	if(ParseString(a_Param, "String", tmpString))
	{
		if(IsAppend > 0)
			ChatEditBox.AddString(tmpString);
		else
			ChatEditBox.SetString(tmpString);
	}
}

private function HandleSetFocus()
{
	if(ChatEditBox.IsFocused())
	{		
	}
	else
	{
		_Swap2FullAlphaNormal();

		if(isMinSize)
		{
			_Swap2Max();
		}
		class'SystemMsgWnd'.static.Inst()._Swap2FullAlpha();

		ChatEditBox.SetFocus();
	}
}

private function SayPacketType GetChatTypeByTabIndex(int Index)
{
	local SayPacketType SayType;
	//~ SayType = CHAT_NORMAL;

	switch(chatTabInfos[Index].channelID)
	{
	//~ case CHANNEL_ID_NORMAL:
		//~ SayType = CHAT_NORMAL;
		//~ break;
	//~ case CHANNEL_ID_TRADE:
		//~ SayType = CHAT_MARKET;
		//~ break;
	//~ case CHANNEL_ID_PARTY:
		//~ SayType = CHAT_PARTY;
		//~ break;
	//~ case CHANNEL_ID_CLAN:
		//~ SayType = CHAT_CLAN;
		//~ break;
	//~ case CHANNEL_ID_ALLY:
		//~ SayType = CHAT_ALLIANCE;
		//~ break;
	//~ case CHANNEL_ID_ALLY:
		//~ SayType = CHAT_ALLIANCE;
		//~ break;
	//~ case CHANNEL_ID_ALLY:
		//~ SayType = CHAT_ALLIANCE;
		//~ break;
	//~ case CHANNEL_ID_ALLY:
		//~ SayType = CHAT_ALLIANCE;
		//~ break;
	//~ case CHANNEL_ID_ALLY:
		//~ SayType = CHAT_ALLIANCE;
		//~ break;
		case 0:
			SayType = SPT_NORMAL;
			break;
		case 1:
			SayType = SPT_MARKET;
			break;
		case 2:
			SayType = SPT_PARTY;
			break;
		case 3:
			SayType = SPT_PLEDGE;
			break;
		case 4:
			SayType = SPT_ALLIANCE;
			break;
		case 5:
			SayType = SPT_HERO;
			break;
		case 6:
			SayType = SPT_INTER_PARTYMASTER_CHAT;
			break;
		case 7:
			SayType = SPT_SHOUT;
			break;
		case 8:
			SayType = SPT_WORLD;
			break;
		case 9:
			SayType = SPT_WORLD_INRAIDSERVER;
			break;

		default:
			break;
	}
	return SayType;
}

private function HandleChatIconClick(string param)
{
	local int Type;
	local string Title;
	local UserInfo uInfo;

	ParseInt(param, "Type", Type);

	if(byte(Type) != 3)
	{
		return;
	}
	if(! GetPlayerInfo(uInfo))
	{
		return;
	}
	ParseString(param, "Title", Title);

	if(Left(Title, 2) == "->")
	{
		Title = Mid(Title, 2);
	}
	if(uInfo.Name == Title)
	{
		return;
	}
	ShowContextMenuIcon(Title);
}

//TextLink
function HandleTextLinkRButtonClick(string param)
{
	local string ChatMsg, UserName;
	local int posX, posY, UserID;
	local UserInfo UserInfo;

	Debug("��Ŭ��Param" @ param);

	ParseInt(param, "PosX", posX);
	ParseInt(param, "PosY", posY);
	ParseInt(param, "ID", UserID);

	ParseString(param, "ChatMsg", ChatMsg);
	ParseString(param, "Title", UserName);

	GetPlayerInfo(UserInfo);

	// ������ �ƴ� ��츸 �۵�(Ÿ��)
	if(UserInfo.Name != UserName)
	{
		if(UserName != "")	getInstanceContextMenu().execContextEvent(UserName, UserID, posX, posY, getInstanceContextMenu().SPECIALTYPE_CHAT_ADDBLOCK, ChatMsg);
	}
}

private function HandleTextLinkLButtonClick(string param)
{
	local int Type;
	local string Title;
	local UserInfo uInfo;

	ParseInt(param, "Type", Type);
	ParseString(param, "Title", Title);

	if(byte(Type) != 3)
	{
		return;
	}
	if(Left(Title, 2) == "->")
	{
		Title = Mid(Title, 2);
	}
	if(! GetPlayerInfo(uInfo))
	{
		return;
	}
	if(uInfo.Name == Title)
	{
		return;
	}
	SetChatMessage("\"" $ Title $ " ");
}

private function ShowContextMenuIcon(string UserName)
{
	local UIControlContextMenu ContextMenu;
	local int X, Y;

	ContextMenu = class'UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenuIcon;
	ContextMenu.DelegateOnHide = HandleOnHideContextMenu;

	if(! getInstanceUIData().IsFriend(UserName))
	{
		ContextMenu.MenuNew(GetSystemString(3227), 0);
	}
	if(! getInstanceUIData()._IsParty(UserName))
	{
		ContextMenu.MenuNew(GetSystemString(396), 1);
	}
	if(! getInstanceUIData()._IsBlocked(UserName))
	{
		ContextMenu.MenuNew(GetSystemString(993), 2);
	}
	ContextMenu._SetReservedString(UserName);
	API_GetClientCursorPos(X, Y);
	ContextMenu.Show(X, Y, string(self));
}

private function HandleOnClickContextMenuIcon(int Index)
{
	local string UserName;

	UserName = class'UIControlContextMenu'.static.GetInstance()._GetReservedString();
	switch(Index)
	{
		case 0:
			class'PersonalConnectionAPI'.static.RequestAddFriend(UserName);
			break;
		case 1:
			API_RequestInviteParty(UserName);
			break;
		case 2:
			API_RequestAddBlock(UserName);
			break;
	}
}

private function API_RequestAddBlock(string UserName)
{
	Debug("API_RequestAddBlock" @ UserName @ ConvertWorldStrToID(UserName));
	class'PersonalConnectionAPI'.static.RequestAddBlock(ConvertWorldStrToID(UserName));
}

private function API_RequestInviteParty(string UserName)
{
	RequestInviteParty(UserName);
}

private function HandleDominionWarChannelSet(string param)
{
	local int DominionWarChannelSet;

	ParseInt(param, "DominionWarChannelSet", DominionWarChannelSet);

	if(DominionWarChannelSet == 1)
	{
		AddSystemMessage(2445);
	}
	else
	{
		AddSystemMessage(2446);
	}
}

function _Swap2Min()
{
	m_ChatMinBtn.HideWindow();
	m_ChatMaxBtn.ShowWindow();
	m_ChatFilterBtn.HideWindow();
	ChatEditBox.HideWindow();
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].tabButton.HideWindow();
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.HideWindow();
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].newMessageBtn.HideWindow();
	chatTabInfos[CHAT_WINDOW_TAB_1].tabMergeBtn.HideWindow();
	chatTabInfos[CHAT_WINDOW_TAB_2].tabMergeBtn.HideWindow();
	chatTabInfos[CHAT_WINDOW_TAB_3].tabMergeBtn.HideWindow();
	m_ChatWndBg.HideWindow();
	dragTabNormal.HideWindow();

	if(! chatTabInfos[CHAT_WINDOW_TAB_1].isSplit)
	{
		chatTabInfos[CHAT_WINDOW_TAB_1].channelBtn.HideWindow();
		chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd.HideWindow();
		chatTabInfos[CHAT_WINDOW_TAB_1].tabButton.HideWindow();
		chatTabInfos[CHAT_WINDOW_TAB_1].newMessageBtn.HideWindow();
	}
	if(! chatTabInfos[CHAT_WINDOW_TAB_2].isSplit)
	{
		chatTabInfos[CHAT_WINDOW_TAB_2].channelBtn.HideWindow();
		chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd.HideWindow();
		chatTabInfos[CHAT_WINDOW_TAB_2].tabButton.HideWindow();
		chatTabInfos[CHAT_WINDOW_TAB_2].newMessageBtn.HideWindow();
	}
	if(! chatTabInfos[CHAT_WINDOW_TAB_3].isSplit)
	{
		chatTabInfos[CHAT_WINDOW_TAB_3].channelBtn.HideWindow();
		chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.HideWindow();
		chatTabInfos[CHAT_WINDOW_TAB_3].tabButton.HideWindow();
		chatTabInfos[CHAT_WINDOW_TAB_3].newMessageBtn.HideWindow();
	}
	isMinSize = true;
}

function _Swap2Max()
{
	m_ChatMinBtn.ShowWindow();
	m_ChatMaxBtn.HideWindow();
	m_ChatFilterBtn.ShowWindow();
	ChatEditBox.ShowWindow();
	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].tabButton.ShowWindow();
	chatTabInfos[CHAT_WINDOW_TAB_1].tabButton.ShowWindow();
	chatTabInfos[CHAT_WINDOW_TAB_2].tabButton.ShowWindow();
	chatTabInfos[CHAT_WINDOW_TAB_3].tabButton.ShowWindow();
	chatTabInfos[CHAT_WINDOW_TAB_1].channelBtn.ShowWindow();
	chatTabInfos[CHAT_WINDOW_TAB_2].channelBtn.ShowWindow();
	chatTabInfos[CHAT_WINDOW_TAB_3].channelBtn.ShowWindow();
	m_ChatMaxBtnAlarm.HideWindow();
	dragTabNormal.ShowWindow();
	m_ChatWndBg.ShowWindow();

	switch(m_chatType.UI)
	{
		case 0:
			chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.ShowWindow();
			break;
		case 1:
			if(chatTabInfos[CHAT_WINDOW_TAB_1].isSplit)
			{
				chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.ShowWindow();				
			}
			else
			{
				chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd.ShowWindow();
			}
			break;
		case 2:
			if(chatTabInfos[CHAT_WINDOW_TAB_2].isSplit)
			{
				chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.ShowWindow();				
			}
			else
			{
				chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd.ShowWindow();
			}
			break;
		case 3:
			if(chatTabInfos[CHAT_WINDOW_TAB_3].isSplit)
			{
				chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.ShowWindow();				
			}
			else
			{
				chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.ShowWindow();
			}
			break;
	}
	if(chatTabInfos[CHAT_WINDOW_TAB_1].isSplit)
	{
		chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd.ShowWindow();
		chatTabInfos[CHAT_WINDOW_TAB_1].tabMergeBtn.ShowWindow();
	}
	if(chatTabInfos[CHAT_WINDOW_TAB_2].isSplit)
	{
		chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd.ShowWindow();
		chatTabInfos[CHAT_WINDOW_TAB_2].tabMergeBtn.ShowWindow();
	}
	if(chatTabInfos[CHAT_WINDOW_TAB_3].isSplit)
	{
		chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.ShowWindow();
		chatTabInfos[CHAT_WINDOW_TAB_3].tabMergeBtn.ShowWindow();
	}
	CheckOnChangeStateMessageBtn(0 + 1);
	CheckOnChangeStateMessageBtn(1 + 1);
	CheckOnChangeStateMessageBtn(2 + 1);
	CheckOnChangeStateMessageBtn(3 + 1);
	isMinSize = false;

	if(IsMouseOver)
	{
		_Swap2FullAlphaNormal();
		_Swap2FullAlpha(CHAT_WINDOW_TAB_1);
		_Swap2FullAlpha(CHAT_WINDOW_TAB_2);
		_Swap2FullAlpha(CHAT_WINDOW_TAB_3);
	}
	// End:0x331
	if(bool(m_ChatResizeOnOff))
	{
		EnableChatWndResizing(false);		
	}
	else
	{
		EnableChatWndResizing(true);
	}
}

private function HandleOptionHasAppled()
{
	GetINIBool("global", "UseAlpha", m_bUseAlpha, "chatfilter.ini");
	// End:0x56
	if(IsMouseOver)
	{
		_Swap2FullAlphaNormal();
		_Swap2FullAlpha(CHAT_WINDOW_TAB_1);
		_Swap2FullAlpha(CHAT_WINDOW_TAB_2);
		_Swap2FullAlpha(CHAT_WINDOW_TAB_3);		
	}
	else
	{
		_Swap2AlphaNormal();
		_Swap2Alpha(CHAT_WINDOW_TAB_1);
		_Swap2Alpha(CHAT_WINDOW_TAB_2);
		_Swap2Alpha(CHAT_WINDOW_TAB_3);
	}
}

function _SetChangeFont(int FontType)
{
	local string FontName;

	switch(FontType)
	{
		case 0:
			FontName = "chatFontSize10";
			break;
		case 1:
			FontName = "chatFontSize11";
			break;
		case 2:
			FontName = "chatFontSize12";
			break;

		default:
			FontName = "chatFontSize10";
			break;
	}

	chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd.SetFontIDByName(FontName);
	chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd.SetFontIDByName(FontName);
	chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd.SetFontIDByName(FontName);
	chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd.SetFontIDByName(FontName);
	SystemMsg.SetFontIDByName(FontName);
}

private function SetDefaultFilterOn()
{
	m_filterInfo[CHANNEL_ID_TRADE].bTrade = 1;
	m_filterInfo[CHANNEL_ID_PARTY].bParty = 1;
	m_filterInfo[CHANNEL_ID_CLAN].bClan = 1;
	m_filterInfo[CHANNEL_ID_ALLY].bAlly = 1;
}

private function ChangeTabChannel(int tabindex, int channelID)
{
	local string channelName;
	local LocationShareWnd LocationShareWndScript;

	LocationShareWndScript = LocationShareWnd(GetScript("LocationShareWnd"));
	channelName = GetSystemStringByChatType(channelID);
	switch(channelID)
	{
		case CHANNEL_ID_TRADE:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName(tabindex + 1, channelName);
			break;
		case CHANNEL_ID_PARTY:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName(tabindex + 1, channelName);
			   
			break;
		case CHANNEL_ID_CLAN:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName(tabindex + 1, channelName);
			break;
		case CHANNEL_ID_ALLY:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName(tabindex + 1, channelName);
			break;
		case CHANNEL_ID_HERO:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName(tabindex + 1, channelName);
			break;
		case CHANNEL_ID_PARTYMASTER:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName(tabindex + 1, channelName);
			break;
		case CHANNEL_ID_SHOUT:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName(tabindex + 1, channelName);
			break;
		case CHANNEL_ID_WORLD:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName(tabindex + 1, channelName);
			break;
		case CHANNEL_ID_INRAIDSERVER:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName(tabindex + 1, channelName);
			break;
	}
	//~ SetINIInt("global", "TabIndex1", ChannelIndex, "chatfilter.ini");
	chatTabInfos[tabindex].channelID = channelID;
	SetCurrentAssignedChatType2Ini(channelID, tabindex);
}

function SetCurrentAssignedChatType2Ini(int channelID, int chatType)
{
	SetINIInt("global", "TabIndex" $ string(chatType), channelID, "chatfilter.ini");
}

function _SetAllcurrentAssignedChatTypeID()
{
	local int i, tabindex, channelID;

	SetINIInt("global", "TabIndex0", 0, "chatfilter.ini");

	for(i = 0; i < 4; i++)
	{
		channelID = i;
		chatTabInfos[i].channelID = channelID;
	}

	for(tabindex = 1; tabindex < 4; tabindex++)
	{
		if(GetINIInt("global", "TabIndex" $ string(tabindex), channelID, "chatfilter.ini") && channelID > 0)
		{
			chatTabInfos[tabindex].channelID = channelID;
			ChangeTabChannel(tabindex, channelID);
			continue;
		}
		channelID = GetDefaultChannelID(tabindex);

		if(channelID == -1)
		{
			continue;
		}
		SetINIInt("global", "TabIndex" $ string(tabindex), channelID, "chatfilter.ini");
		ChangeTabChannel(tabindex, channelID);
	}
}

private function int GetDefaultChannelID(int tabindex)
{
	if(getInstanceUIData().getIsClassicServer())
	{
		switch(tabindex)
		{
			case CHAT_WINDOW_TAB_1:
				return CHANNEL_ID_WORLD;
			case CHAT_WINDOW_TAB_2:
				return CHANNEL_ID_PARTY;
			case CHAT_WINDOW_TAB_3:
				return CHANNEL_ID_CLAN;
		}
	}
	switch(tabindex)
	{
		case CHAT_WINDOW_TAB_1:
			return CHANNEL_ID_PARTY;
		case CHAT_WINDOW_TAB_2:
			return CHANNEL_ID_CLAN;
		case CHAT_WINDOW_TAB_3:
			return CHANNEL_ID_ALLY;
	}
	return -1;
}

function int GetCurrentChatTypeID(int chatTypeUI)
{
	return chatTabInfos[chatTypeUI].channelID;
}

function SetChatEditBox(string txt)
{
	ChatEditBox.SetString(txt);
	ChatEditBox.SetFocus();
}

function SaveChatFilterOption()
{
	local int i;

	for(i = 0; i < m_sectionName.Length; i++)
	{
		SetINIBool(m_sectionName[i], "dice", bool(m_filterInfo[i].bDice), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "getitems", bool(m_filterInfo[i].bGetitems), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "system", bool(m_filterInfo[i].bSystem), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "damage", bool(m_filterInfo[i].bDamage), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "useitems", bool(m_filterInfo[i].bUseitem), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "chat", bool(m_filterInfo[i].bChat), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "normal", bool(m_filterInfo[i].bNormal), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "party", bool(m_filterInfo[i].bParty), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "shout", bool(m_filterInfo[i].bShout), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "market", bool(m_filterInfo[i].bTrade), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "pledge", bool(m_filterInfo[i].bClan), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "tell", bool(m_filterInfo[i].bWhisper), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "ally", bool(m_filterInfo[i].bAlly), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "worldUnion", bool(m_filterInfo[i].bWorldUnion), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "hero", bool(m_filterInfo[i].bHero), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "union", bool(m_filterInfo[i].bUnion), "chatfilter.ini");
		//SetINIBool(script.m_sectionName[i],"battle", bool(script.m_filterInfo[i].bBattle), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "nonpcmessage", bool(m_filterInfo[i].bNoNpcMessage), "chatfilter.ini");
		//���� ä�� �߰�
		SetINIBool(m_sectionName[i], "worldChat", bool(m_filterInfo[i].bWorldChat), "chatfilter.ini");
	}

	SetINIBool("global", "OldChatting", bool(m_UseChatSymbol), "chatfilter.ini");//int(GetOptionBool("CommunIcation", "OldChatting"));

	//SetINIBool("global", "command", bool(m_NoUnionCommanderMessage), "chatfilter.ini");

	SetINIBool("global", "keywordsound", bool(m_KeywordFilterSound), "chatfilter.ini");
	SetINIBool("global", "keywordactivate", bool(m_KeywordFilterActivate), "chatfilter.ini");
	SetINIBool("global", "ChatResizing", bool(m_ChatResizeOnOff), "chatfilter.ini");
	SetINIBool("global", "SystemMsgWnd", bool(m_bUseSystemMsgWnd), "chatfilter.ini");
	SetINIBool("global", "OnlyUseSystemMsgWnd", bool(m_bOnlyUseSystemMsgWnd), "chatfilter.ini");
	SetINIBool("global", "UseSystemMsg", bool(m_bSystemMsgWnd), "chatfilter.ini");
	// ������ - DamageBox
	SetINIBool("global", "SystemMsgWndDamage", bool(m_bDamageOption), "chatfilter.ini");
	SetINIBool("global", "SystemMsgWndDice", bool(m_bDiceOption), "chatfilter.ini");
	// �Ҹ𼺾����ۻ�� - ItemBox
	SetINIBool("global", "SystemMsgWndExpendableItem", bool(m_bUseSystemItem), "chatfilter.ini");
	// ���� ä�� ����Ŀ
	SetINIBool("global", "UseWorldChatSpeaker", bool(m_bWorldChatSpeaker), "chatfilter.ini");
	SetINIString("global", "Keyword0", m_Keyword0, "chatfilter.ini");
	SetINIString("global", "Keyword1", m_Keyword1, "chatfilter.ini");
	SetINIString("global", "Keyword2", m_Keyword2, "chatfilter.ini");
	SetINIString("global", "Keyword3", m_Keyword3, "chatfilter.ini");

	if(bool(m_ChatResizeOnOff))
	{
		EnableChatWndResizing(false);
	}
	else
	{
		EnableChatWndResizing(true);
	}
}

// ini���� �⺻���� �׳� �о��
function LoadINIFilterSetting()
{
	local int tempVal, i, resultNum;
	//local string str;

	for(i = 0; i < m_sectionName.Length; i++)
	{
		//getini �� ���� �����;ߵ�
		GetINIBool(m_sectionName[i], "dice", tempVal, "chatfilter.ini");
		m_filterInfo[i].bDice = tempVal;

		GetINIBool(m_sectionName[i], "getitems", tempVal, "chatfilter.ini");
		m_filterInfo[i].bGetitems = tempVal;
		GetINIBool(m_sectionName[i], "system", tempVal, "chatfilter.ini");
		m_filterInfo[i].bSystem = tempVal;
		GetINIBool(m_sectionName[i], "useitems", tempVal, "chatfilter.ini");
		m_filterInfo[i].bUseitem = tempVal;
		GetINIBool(m_sectionName[i], "damage", tempVal, "chatfilter.ini");
		m_filterInfo[i].bDamage = tempVal;
		GetINIBool(m_sectionName[i], "chat", tempVal, "chatfilter.ini");
		m_filterInfo[i].bChat = tempVal;
		GetINIBool(m_sectionName[i], "normal", tempVal, "chatfilter.ini");
		m_filterInfo[i].bNormal = tempVal;
		GetINIBool(m_sectionName[i], "party", tempVal, "chatfilter.ini");
		m_filterInfo[i].bParty = tempVal;
		GetINIBool(m_sectionName[i], "shout", tempVal, "chatfilter.ini");
		m_filterInfo[i].bShout = tempVal;
		GetINIBool(m_sectionName[i], "market", tempVal, "chatfilter.ini");
		m_filterInfo[i].bTrade = tempVal;
		GetINIBool(m_sectionName[i], "pledge", tempVal, "chatfilter.ini");
		m_filterInfo[i].bClan = tempVal;
		GetINIBool(m_sectionName[i], "tell", tempVal, "chatfilter.ini");
		m_filterInfo[i].bWhisper = tempVal;
		GetINIBool(m_sectionName[i], "ally", tempVal, "chatfilter.ini");
		m_filterInfo[i].bAlly = tempVal;
		GetINIBool(m_sectionName[i], "worldUnion", tempVal, "chatfilter.ini");
		m_filterInfo[i].bWorldUnion = tempVal;
		GetINIBool(m_sectionName[i], "hero", tempVal, "chatfilter.ini");
		m_filterInfo[i].bHero = tempVal;
		GetINIBool(m_sectionName[i], "union", tempVal, "chatfilter.ini");
		m_filterInfo[i].bUnion = tempVal;
		GetINIBool(m_sectionName[i], "nonpcmessage", tempVal, "chatfilter.ini");
		m_filterInfo[i].bNoNpcMessage = tempVal;
		GetINIBool(m_sectionName[i], "worldChat", tempVal, "chatfilter.ini");
		m_filterInfo[i].bWorldChat = tempVal;
	}
	m_UseChatSymbol = int(GetChatFilterBool("Global", "OldChatting"));//int(GetOptionBool("CommunIcation", "OldChatting"));
	//GetINIBool("global", "command", resultNum, "chatfilter.ini");
	//m_NoUnionCommanderMessage = resultNum;

	GetINIBool("global", "keywordsound", resultNum, "chatfilter.ini");
	m_KeywordFilterSound = resultNum;

	GetINIBool("global", "keywordactivate", resultNum, "chatfilter.ini");
	m_KeywordFilterActivate = resultNum;

	GetINIBool("global", "ChatResizing", resultNum, "chatfilter.ini");
	m_ChatResizeOnOff = resultNum;

	if(getInstanceUIData().getIsLiveServer())
	{
		GetINIBool("global", "SystemMsgWnd", resultNum, "chatfilter.ini");
		m_bUseSystemMsgWnd = resultNum;
	}
	else
	{
		m_bUseSystemMsgWnd = 0;
	}
	GetINIBool("global", "OnlyUseSystemMsgWnd", resultNum, "chatfilter.ini");
	m_bOnlyUseSystemMsgWnd = resultNum;

	GetINIBool("global", "UseSystemMsg", resultNum, "chatfilter.ini");
	m_bSystemMsgWnd = resultNum;

	// ������ - DamageBox
	GetINIBool("global", "SystemMsgWndDamage", resultNum, "chatfilter.ini");
	m_bDamageOption = resultNum;
	GetINIBool("global", "SystemMsgWndDice", resultNum, "chatfilter.ini");
	m_bDiceOption = resultNum;
	// �Ҹ𼺾����ۻ�� - ItemBox
	GetINIBool("global", "SystemMsgWndExpendableItem", resultNum, "chatfilter.ini");
	m_bUseSystemItem = resultNum;

	// ���� ä�� ����Ŀ
	GetINIBool("global", "UseWorldChatSpeaker", resultNum, "chatfilter.ini");
	m_bWorldChatSpeaker = resultNum;

	GetINIString("global", "Keyword0", m_Keyword0, "chatfilter.ini");
	GetINIString("global", "Keyword1", m_Keyword1, "chatfilter.ini");
	GetINIString("global", "Keyword2", m_Keyword2, "chatfilter.ini");
	GetINIString("global", "Keyword3", m_Keyword3, "chatfilter.ini");
}

function string GetSystemStringByChatType(int chatType)
{
	switch(chatType)
	{
		case CHANNEL_ID_NORMAL:
			return GetSystemString(441);
		case CHANNEL_ID_TRADE:
			return GetSystemString(355);
		case CHANNEL_ID_PARTY:
			return GetSystemString(188);
		case CHANNEL_ID_CLAN:
			return GetSystemString(128);
		case CHANNEL_ID_ALLY:
			return GetSystemString(559);
		case CHANNEL_ID_HERO:
			return GetSystemString(1961);
		case CHANNEL_ID_PARTYMASTER:
			return GetSystemString(1962);
		case CHANNEL_ID_SHOUT:
			return GetSystemString(1963);
		case CHANNEL_ID_WORLD:
			return GetSystemString(3234);
		case CHANNEL_ID_INRAIDSERVER:
			return GetSystemString(14108);
	}
	return "";
}

function SayPacketType GetChatTypeByType(int nType)
{
	local SayPacketType SayType;

	switch(nType)
	{
		case 0:
			SayType = SayPacketType.SPT_NORMAL;
			break;
		case 1:
			SayType = SayPacketType.SPT_MARKET;
			break;
		case 2:
			SayType = SayPacketType.SPT_PARTY;
			break;
		case 3:
			SayType = SayPacketType.SPT_PLEDGE;
			break;
		case 4:
			SayType = SayPacketType.SPT_ALLIANCE;
			break;
		case 5:
			SayType = SayPacketType.SPT_HERO;
			break;
		case 6:
			SayType = SayPacketType.SPT_INTER_PARTYMASTER_CHAT;
			break;
		case 7:
			SayType = SayPacketType.SPT_SHOUT;
			break;
		case 8:
			SayType = SayPacketType.SPT_WORLD;
			break;
		case 9:
			SayType = SPT_WORLD_INRAIDSERVER;
			break;
	}
	return SayType;
}

private function string InsertSHARPText(string Msg)
{
	local string MsgTemp, MsgTemp2;
	local int MaxLength, i, maxSharpNum;

	MaxLength = Len(Msg);
	maxSharpNum = 0;

	while(MaxLength > CHAT_UNION_MAX * (maxSharpNum + 1))
	{
		maxSharpNum++;
	}

	for(i = 0; i < maxSharpNum; i++)
	{
		MaxLength = Len(Msg);
		MsgTemp = Left(Msg, CHAT_UNION_MAX * (i+1) + i);//# ���ڰ� �ϳ��� �þ�Ƿ� i�� ���� ��, 
		MsgTemp2 = Right(Msg, MaxLength - (CHAT_UNION_MAX * (i+1) + i)); //# ���ڰ� �ϳ��� �þ�Ƿ�... ��
		Msg = MsgTemp $ "#" $ MsgTemp2;
		//Debug("InsertSHARPText"$i @ maxlength @ CHAT_UNION_MAX * i @  "MsgTemp2:"$MsgTemp2);
	}

	return Msg;
}

private function ShowScreenMessage(string Msg, int FontType)
{
	local string strParam;

	if(Len(Msg) <= 0)
	{
		return;
	}
	Msg = InsertSHARPText(Msg);
	ParamAdd(strParam, "MsgType", string(1));
	ParamAdd(strParam, "WindowType", string(8));
	ParamAdd(strParam, "FontType", string(FontType));
	ParamAdd(strParam, "BackgroundType", string(0));
	ParamAdd(strParam, "LifeTime", string(5000));
	ParamAdd(strParam, "AnimationType", string(1));
	ParamAdd(strParam, "Msg", Msg);
	ParamAdd(strParam, "MsgColorR", string(255));
	ParamAdd(strParam, "MsgColorG", string(150));
	ParamAdd(strParam, "MsgColorB", string(149));
	ExecuteEvent(EV_ShowScreenMessage, strParam);
}

private function ShowGfxChattingMessage(string param, Color m_color)
{
	local string FilteredMsg;
	local int Color;

	ParseString(param, "FilteredMsg", FilteredMsg);
	Color = getInstanceL2Util().ColorToInt(m_color);
	param = "";
	ParamAdd(param, "Msg", FilteredMsg);
	ParamAdd(param, "type", string(getInstanceL2Util().EGfxScreenMsgType.MSGType_Chatting));
	ParamAdd(param, "textColor", string(Color));
	CallGFxFunction("GfxScreenMessage", "showMessage", param);
}

private function ChatWindowHandle GetChatWindow(int tabindex)
{
	switch(tabindex)
	{
		case CHANNEL_ID_NORMAL:
			return chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd;
		case CHANNEL_ID_TRADE:
			return chatTabInfos[CHAT_WINDOW_TAB_1].ChatWnd;
		case CHANNEL_ID_PARTY:
			return chatTabInfos[CHAT_WINDOW_TAB_2].ChatWnd;
		case CHANNEL_ID_CLAN:
			return chatTabInfos[CHAT_WINDOW_TAB_3].ChatWnd;
		case CHANNEL_ID_HERO:
			return SystemMsg;
	}
	return chatTabInfos[CHAT_WINDOW_TAB_NORMAL].ChatWnd;
}

function AddStringToChatWindow(SayPacketType SayType, int tabindex, ESystemMsgType systemType, string Text, Color mainColor, Color subColor, int SharedPositionID, optional out int addedChatNum)
{
	if(CheckFilter(SayType, chatTabInfos[tabindex].channelID, systemType))
	{
		GetChatWindow(tabindex).AddStringToChatWindow(Text, mainColor, subColor, SharedPositionID);
		CheckNewMessage(tabindex);

		if(GetChatWindow(tabindex).IsShowWindow())
		{
			SetAlarmMaskChat(SayType);
			addedChatNum++;			
		}
		else
		{
			if(isMinSize)
			{
				if(m_chatType.UI == tabindex)
				{
					SetAlarmMaskChat(SayType);
					addedChatNum++;					
				}
				else
				{
					switch(tabindex)
					{
						case CHAT_WINDOW_TAB_NORMAL:
							if(m_chatType.UI == 1 && chatTabInfos[CHAT_WINDOW_TAB_1].isSplit || m_chatType.UI == 2 && chatTabInfos[CHAT_WINDOW_TAB_2].isSplit || m_chatType.UI == 3 && chatTabInfos[CHAT_WINDOW_TAB_3].isSplit)
							{
								SetAlarmMaskChat(SayType);
								addedChatNum++;
							}
							break;
						case CHAT_WINDOW_TAB_1:
							if(chatTabInfos[CHAT_WINDOW_TAB_1].isSplit)
							{
								SetAlarmMaskChat(SayType);
								addedChatNum++;
							}
							break;
						case CHAT_WINDOW_TAB_2:
							if(chatTabInfos[CHAT_WINDOW_TAB_2].isSplit)
							{
								SetAlarmMaskChat(SayType);
								addedChatNum++;
							}
							break;
						case CHAT_WINDOW_TAB_3:
							if(chatTabInfos[CHAT_WINDOW_TAB_3].isSplit)
							{
								SetAlarmMaskChat(SayType);
								addedChatNum++;
							}
					}
				}
			}
		}
	}
}

event OnScrollMove(string strID, int pos)
{
	local int tabindex;

	tabindex = GetTabIndexByName(strID);

	if(tabindex == -1)
	{
		return;
	}
	if(! chatTabInfos[tabindex].bShowNewMessageBtn)
	{
		return;
	}
	if(GetChatWindow(tabindex).GetScrollPosition() != GetChatWindow(tabindex).GetScrollHeight())
	{
		return;
	}
	HideNewMessageBtn(tabindex);
}

private function int GetTabIndexByName(string chatWndName)
{
	local int i;

	for(i = 0; i < chatTabInfos.Length; i++)
	{
		if(chatTabInfos[i].ChatWnd.GetWindowName() == chatWndName)
		{
			return i;
		}
	}
	return -1;
}

private function CheckNewMessage(int tabindex)
{
	if(GetChatWindow(tabindex).GetScrollHeight() < 0)
	{
		return;
	}
	if(GetChatWindow(tabindex).GetScrollPosition() == GetChatWindow(tabindex).GetScrollHeight())
	{
		return;
	}
	ShowNewMessageBtn(tabindex);
}

private function ShowNewMessageBtn(int tabindex)
{
	if(tabindex == CHAT_WINDOW_TAB_SYSTEM)
	{
		class'SystemMsgWnd'.static.Inst()._ShowNewMessageBtn();
		return;
	}
	chatTabInfos[tabindex].bShowNewMessageBtn = true;

	if(chatTabInfos[tabindex].ChatWnd.IsShowWindow() || chatTabInfos[tabindex].isSplit)
	{
		chatTabInfos[tabindex].newMessageBtn.ShowWindow();
	}
}

private function CheckOnChangeStateMessageBtn(int tabindex)
{
	// End:0x81
	if(chatTabInfos[tabindex].bShowNewMessageBtn)
	{
		// End:0x64
		if(chatTabInfos[tabindex].ChatWnd.IsShowWindow() || chatTabInfos[tabindex].isSplit)
		{
			chatTabInfos[tabindex].newMessageBtn.ShowWindow();			
		}
		else
		{
			chatTabInfos[tabindex].newMessageBtn.HideWindow();
		}		
	}
	else
	{
		chatTabInfos[tabindex].newMessageBtn.HideWindow();
	}
}

private function HideNewMessageBtn(int tabindex)
{
	chatTabInfos[tabindex].bShowNewMessageBtn = false;
	chatTabInfos[tabindex].newMessageBtn.HideWindow();
	chatTabInfos[tabindex].ChatWnd.SetFocus();
}

private function PlayNotifySoundsKeyWord()
{
	if((bitFlagAlarmKewWord & VALIDATEFLAG_ALARM_KEYWORD) > 0)
	{
		API_PlayNotifySound(0);
	}
	if((bitFlagAlarmKewWord & VALIDATEFLAG_ALARM_CHAT) > 0)
	{
		API_PlayNotifySound(VALIDATEFLAG_ALARM_KEYWORD);
	}
	if((bitFlagAlarmKewWord & 4) > 0)
	{
		API_PlayNotifySound(VALIDATEFLAG_ALARM_CHAT);
	}
	if((bitFlagAlarmKewWord & 8) > 0)
	{
		API_PlayNotifySound(3);
	}
}

private function PlayNotifySoundsChat()
{
	if((bitFlagAlarmChat & ExpInt(VALIDATEFLAG_ALARM_CHAT, OPTION_ALARM_INDEX_SPT_TELL)) > 0)
	{
		API_PlayIndexedNotifySound(ALARM_INDEX_SPT_TELL);
	}
	if((bitFlagAlarmChat & ExpInt(VALIDATEFLAG_ALARM_CHAT, OPTION_ALARM_INDEX_SPT_WORLD)) > 0)
	{
		API_PlayIndexedNotifySound(ALARM_INDEX_SPT_WORLD);
	}
	if((bitFlagAlarmChat & ExpInt(VALIDATEFLAG_ALARM_CHAT, OPTION_ALARM_INDEX_SPT_PLEDGE)) > 0)
	{
		API_PlayIndexedNotifySound(ALARM_INDEX_SPT_PLEDGE);
	}
	if((bitFlagAlarmChat & ExpInt(VALIDATEFLAG_ALARM_CHAT, OPTION_ALARM_INDEX_SPT_ALLIANCE)) > 0)
	{
		API_PlayIndexedNotifySound(ALARM_INDEX_SPT_ALLIANCE);
	}
	if((bitFlagAlarmChat & ExpInt(VALIDATEFLAG_ALARM_CHAT, OPTION_ALARM_INDEX_SPT_INTER_PARTYMASTER_CHAT)) > 0)
	{
		API_PlayIndexedNotifySound(ALARM_INDEX_SPT_INTER_PARTYMASTER_CHAT);
	}
}

private function int SetAlarmMaskKeyWord(string origText)
{
	local int i, alarmType;
	local OptionWnd optionWndScript;
	local string Title, Message;
	local array<string> textes;

	ParseString(origText, "title", Title);
	Split(origText, ":", textes);
	Message = Title $ ":" $ textes[0];

	for(i = 0; i < (textes.Length - 1); i++)
	{
		Message = Message $ ":" $ textes[i + 1];
	}

	if(m_KeywordFilterSound != 1)
	{
		return alarmType;
	}
	optionWndScript = OptionWnd(GetScript("OptionWnd"));

	if(InStr(Message, m_Keyword0) > 0)
	{
		ValidateNotifyKeyword(optionWndScript._GetKewordAlarmType(0));
	}
	if(InStr(Message, m_Keyword1) > 0)
	{
		ValidateNotifyKeyword(optionWndScript._GetKewordAlarmType(1));
	}
	if(InStr(Message, m_Keyword2) > 0)
	{
		ValidateNotifyKeyword(optionWndScript._GetKewordAlarmType(2));
	}
	if(InStr(Message, m_Keyword3) > 0)
	{
		ValidateNotifyKeyword(optionWndScript._GetKewordAlarmType(3));
	}
}

private function SetAlarmMaskChat(SayPacketType SayType)
{
	local int NOTIFYMUTEFLAG, Index;

	switch(SayType)
	{
		case SPT_TELL:
			Index = OPTION_ALARM_INDEX_SPT_TELL;
			break;
		case SayPacketType.SPT_WORLD:
			Index = OPTION_ALARM_INDEX_SPT_WORLD;
			break;
		case SayPacketType.SPT_PLEDGE:
			Index = OPTION_ALARM_INDEX_SPT_PLEDGE;
			break;
		case SayPacketType.SPT_ALLIANCE:
			Index = OPTION_ALARM_INDEX_SPT_ALLIANCE;
			break;
		case SayPacketType.SPT_INTER_PARTYMASTER_CHAT:
			Index = OPTION_ALARM_INDEX_SPT_INTER_PARTYMASTER_CHAT;
			break;
	}
	NOTIFYMUTEFLAG = GetOptionInt("Audio", "NOTIFYMUTEFLAG");

	if((NOTIFYMUTEFLAG & ExpInt(VALIDATEFLAG_ALARM_CHAT, Index)) == 0)
	{
		ValidateNotifyChat(Index);
	}
}

private function API_GetClientCursorPos(out int X, out int Y)
{
	GetClientCursorPos(X, Y);
}

function API_C_EX_REQUEST_INVITE_PARTY(string param)
{
	local int cReqType;
	local array<byte> stream;
	local UIPacket._C_EX_REQUEST_INVITE_PARTY packet;

	ParseInt(param, "ReqType", cReqType);
	packet.cReqType = cReqType;
	packet.cSayType = GetChatTypeByTabIndex(m_chatType.UI);

	if(! class'UIPacket'.static.Encode_C_EX_REQUEST_INVITE_PARTY(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_REQUEST_INVITE_PARTY, stream);
}

private function API_PlayNotifySound(int alarmType)
{
	class'AudioAPI'.static.PlayNotifySound("ItemSound3.Sys_Chat_Keyword");
}

private function API_PlayIndexedNotifySound(int Index)
{
	if(Index == -1)
	{
		return;
	}
	class'AudioAPI'.static.PlayIndexedNotifySound("", Index, false);
}

event OnTick()
{
	m_hOwnerWnd.DisableTick();

	if((validateFlag & VALIDATEFLAG_ALARM_KEYWORD) > 0)
	{
		PlayNotifySoundsKeyWord();
	}
	if((validateFlag & VALIDATEFLAG_ALARM_CHAT) > 0)
	{
		PlayNotifySoundsChat();
	}

	validateFlag = 0;
}

private function ValidateNotifyKeyword(int Index)
{
	// End:0x11
	if(Index == -1)
	{
		return;
	}
	Validate(VALIDATEFLAG_ALARM_KEYWORD);
	bitFlagAlarmKewWord = bitFlagAlarmKewWord | ExpInt(VALIDATEFLAG_ALARM_CHAT, Index);
}

private function ValidateNotifyChat(int Index)
{
	// End:0x11
	if(Index == -1)
	{
		return;
	}
	Validate(VALIDATEFLAG_ALARM_CHAT);
	bitFlagAlarmChat = bitFlagAlarmChat | ExpInt(VALIDATEFLAG_ALARM_CHAT, Index);
}


private function Validate(int flag)
{
	validateFlag = validateFlag | flag;
	m_hOwnerWnd.EnableTick();
}

function _HandleShowDevTool()
{
	if(! IsBuilderPC())
	{
		return;
	}
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMessageToggleBtn").ShowWindow();
}

function _HandleHideDevTool()
{
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMessageToggleBtn").HideWindow();
}

private function HandleToggleSystemMessage()
{
	bShowSystemMessage = !bShowSystemMessage;

	if(bShowSystemMessage)
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMessageToggleBtn").SetButtonName(228);		
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMessageToggleBtn").SetButtonName(227);
	}
}

	//CHAT_NORMAL,
	//CHAT_SHOUT,		// '!'
	//CHAT_TELL,		// '\'
	//CHAT_PARTY,		// '#'
	//CHAT_CLAN,		// '@'
	//CHAT_SYSTEM,		// ''
	//CHAT_USER_PET,	// '&'
	//CHAT_GM_PET,		// '*'
	//CHAT_MARKET,		// '+'
	//CHAT_ALLIANCE,	// '%'	
	//CHAT_ANNOUNCE,	// ''
	//CHAT_CUSTOM,		// ''
	//CHAT_L2_FRIEND,	// ''
	//CHAT_MSN_CHAT,	// ''
	//CHAT_PARTY_ROOM_CHAT,	// ''		14
	//CHAT_COMMANDER_CHAT,				// 15
	//CHAT_INTER_PARTYMASTER_CHAT,
	//CHAT_HERO,
	//CHAT_CRITICAL_ANNOUNCE,
	//CHAT_SCREEN_ANNOUNCE,
	//CHAT_DOMINIONWAR,					// 20
	//CHAT_MPCC_ROOM,
	//CHAT_NPC_NORMAL,		// NPC ��� ���͸� - 2010.9.8 winkey
	//CHAT_NPC_SHOUT,
	//CHAT_FRIEND_ANNOUNCE,
	//CHAT_WORLD,

defaultproperties
{
}
