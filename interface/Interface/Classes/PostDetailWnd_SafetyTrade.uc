class PostDetailWnd_SafetyTrade extends UICommonAPI;

const DIALOG_RECEIVE_TRADE_POST = 1111;
const DIALOG_RETURN_POST = 2222;

var WindowHandle Me;
var WindowHandle General;

var TextBoxHandle Title_SenderID;
var TextBoxHandle SenderID;
var TextBoxHandle PostType;
var TextBoxHandle PostTitle;
var TextListBoxHandle PostContents;
var TextBoxHandle WeightText;
var TextBoxHandle SafetyTradeAdenaText;
var INT64 ReceivedTradeAdena;
var ButtonHandle ReceiveBtn;
var ButtonHandle ReturnBtn;
var ButtonHandle SendCancelBtn;
var ButtonHandle ReplyBtn;
var ButtonHandle AddBtn;
var int trade;		//안전거래, 일반우편
var int returnd;	//반송된메일여부
var int mailID;
var int totalWeight; //총  무게
var int returnable, sentbysystem;

var PostDetailWnd_SafetyTradeListWnd PostDetailWnd_SafetyTradeListWndScript;
var TextBoxHandle Wintitle_tex;

//var int IsPeaceZone;

var Color impactcolor;

function OnRegisterEvent()
{
	RegisterEvent(EV_ReplyReceivedPostStart);
	RegisterEvent(EV_ReplyReceivedPostAddItem);
	RegisterEvent(EV_ReplyReceivedPostEnd);
	RegisterEvent(EV_ReplySentPostStart);
	RegisterEvent(EV_ReplySentPostAddItem);
	RegisterEvent(EV_ReplySentPostEnd);
	RegisterEvent(EV_DialogOK);
}

function OnLoad()
{
	SetClosingOnESC();
	InitializeCOD();
	Me.HideWindow();
	totalWeight = 0;
	impactcolor.R = 255;
	impactcolor.G = 114;
	impactcolor.B = 0;
}

function OnShow()
{
	local Rect rectMov;

	// End:0x59
	if(General.IsShowWindow())
	{
		rectMov = General.GetRect();
		Me.MoveTo(rectMov.nX, rectMov.nY);
		General.HideWindow();
	}
	PostDetailWnd_SafetyTradeListWndScript.HandleShow();
}

function OnHide()
{
	PostDetailWnd_SafetyTradeListWndScript.HandleHide();
}

function InitializeCOD()
{
	Me = GetWindowHandle("PostDetailWnd_SafetyTrade");
	General = GetWindowHandle("PostDetailWnd_General");
	Title_SenderID = GetTextBoxHandle("PostDetailWnd_SafetyTrade.Title_SenderID");
	SenderID = GetTextBoxHandle("PostDetailWnd_SafetyTrade.SenderID");
	PostType = GetTextBoxHandle("PostDetailWnd_SafetyTrade.PostType");
	PostTitle = GetTextBoxHandle("PostDetailWnd_SafetyTrade.PostTitle");
	PostContents = GetTextListBoxHandle("PostDetailWnd_SafetyTrade.PostContents");
	WeightText = GetTextBoxHandle("PostDetailWnd_SafetyTrade.WeightText");
	SafetyTradeAdenaText = GetTextBoxHandle("PostDetailWnd_SafetyTrade.SafetyTradeAdenaText");
	ReceiveBtn = GetButtonHandle("PostDetailWnd_SafetyTradeListWnd.ReceiveBtn");
	ReturnBtn = GetButtonHandle("PostDetailWnd_SafetyTradeListWnd.ReturnBtn");
	SendCancelBtn = GetButtonHandle("PostDetailWnd_SafetyTradeListWnd.SendCancelBtn");
	ReplyBtn = GetButtonHandle("PostDetailWnd_SafetyTrade.ReplyBtn");
	//선준 수정(10.03.19)
	AddBtn = GetButtonHandle("PostDetailWnd_SafetyTrade.AddBtn");
	PostDetailWnd_SafetyTradeListWndScript = PostDetailWnd_SafetyTradeListWnd(GetScript("PostDetailWnd_SafetyTradeListWnd"));
	Wintitle_tex = GetTextBoxHandle("PostDetailWnd_SafetyTrade.Wintitle_tex");
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x1D
		case EV_ReplyReceivedPostStart:
			OnEVReplyReceivedPostStart(param);
			break;
		// End:0x33
		case EV_ReplyReceivedPostAddItem:
			OnEVReplyReceivedPostAddItem(param);
			break;
		case EV_ReplyReceivedPostEnd:
			OnEVReplyReceivedPostEnd(param);
			break;
		case EV_ReplySentPostStart:
			OnEVReplySentPostStart(param);
			break;
		case EV_ReplySentPostAddItem:
			OnEVReplySentPostAddItem(param);
			break;
		case EV_ReplySentPostEnd:
			OnEVReplySentPostEnd(param);
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
	}
}

function OnEVReplyReceivedPostStart(string param)
{
	ClearAll();
	ParseInt(param, "trade", trade);
	ParseInt(param, "Returnd", returnd);  // 반송된 메일인가(1), 아닌가(0)
	// End:0xC5
	if(returnd == 0 && trade == 1)//반송된 메일이 아니고, 안전거래인경우
	{
		Wintitle_tex.SetText(GetSystemString(2075)@ "-" @ GetSystemString(2072));
		ReceiveBtn.HideWindow();
		ReturnBtn.HideWindow();
		SendCancelBtn.HideWindow();
		Me.ShowWindow();
		Me.SetFocus();
	}
	totalWeight = 0;
}

function OnEVReplyReceivedPostAddItem(string param)
{
	// End:0x3B
	if(returnd == 0 && TRADE == 1)//반송된 메일이 아니고, 안전거래인경우
	{
		PostDetailWnd_SafetyTradeListWndScript.AddItem(param);
		ReceiveBtn.ShowWindow();
	}
}

function HandleButtonsOnRecived()
{
	// End:0x1A
	if(returnAble == 1)
	{
		ReturnBtn.ShowWindow();
	}
	// End:0x41
	if(PostDetailWnd_SafetyTradeListWndScript.GetItemListCount() == 0)
	{
		ReturnBtn.HideWindow();
	}
	else
	{
		ReceiveBtn.ShowWindow();
	}
	switch(sentBySystem)
	{
		// End:0x7C
		case 1:
			ReturnBtn.HideWindow();
			ReplyBtn.HideWindow();
			// End:0xA8
			break;
		// End:0x93
		case 2:
			ReplyBtn.ShowWindow();
			// End:0xA8
			break;
		// End:0xFFFF
		default:
			ReplyBtn.ShowWindow();
			// End:0xA8
			break;
	}
}

function OnEVReplyReceivedPostEnd(String Param)
{
	local string SenderName, title, contents;
//	local INT64 tradeMoney;	
	local string fixedtitle;
	local INT SendID;
	local string NPCName;
	local CustomTooltip cTooltip;

	if(returnd == 0 && trade == 1)//반송된 메일이 아니고, 안전거래인경우
	{
		ParseInt(param, "MailID", mailID);
		ParseString(param, "SenderName", SenderName); // 보낸 사람
		ParseInt(param, "SenderId", SendId); // 보낸 사람
		ParseString(param, "Title", title); // 제목
		ParseString(param, "Content", contents); // 내용
		ParseINT64(param, "TradeMoney", ReceivedTradeAdena); // 청구비용
		ParseInt(param, "ReturnAble", returnable); // 취소할수있나(1), 없나(0)
		ParseInt(param, "Sentbysystem", sentbysystem); // 시스템이 보낸메일인가(1), 아닌가(0)
		PostType.SetTextColor(impactcolor);
		PostType.SetText(GetSystemString(2072));
		fixedtitle = DivideStringWithWidth(title, 380);
		// End:0x151
		if(fixedtitle != title)
		{
			fixedtitle = fixedtitle $ "...";
		}
		PostTitle.SetText(fixedtitle);
		PostContents.AddString(contents, GetChatColorByType(0));
		PostContents.SetTextListBoxScrollPosition(0);
		Title_SenderID.SetText(GetSystemString(2078));
		SafetyTradeAdenaText.SetTextColor(impactcolor);
		SafetyTradeAdenaText.SetText(MakeCostString(string(ReceivedTradeAdena)));

		// 아데나 읽어 주는 툴팁 추가
		addToolTipDrawList(cTooltip, addDrawItemText(ConvertNumToTextNoAdena(String(ReceivedTradeAdena))$ " " $ GetSystemString(469), getInstanceL2Util().White , "", false));
		SafetyTradeAdenaText.SetTooltipCustomType(cTooltip);

		switch(sentBySystem)
		{
			// End:0x297
			case 1:
				// End:0x27A
				if(returnd == 1)
				{
					SenderID.SetText((("[" $ GetSystemString(2090)) $ "]") @ GetSystemString(2073));
				}
				else
				{
					SenderID.SetText(GetSystemString(2211));
				}
				// End:0x30B
				break;
			// End:0x2F1
			case 2:
				NpcName = class'UIDATA_NPC'.static.GetNPCName(SendId);
				// End:0x2DA
				if(Len(NpcName) > 0)
				{
					SenderID.SetText(NpcName);
				}
				else
				{
					SenderID.SetText(senderName);
				}
				// End:0x30B
				break;
			// End:0xFFFF
			default:
				SenderID.SetText(senderName);
				break;
		}
		HandleButtonsOnRecived();
		WeightText.SetText(string(totalWeight));
	}
}

function OnEVReplySentPostStart(String Param)
{
	ClearAll();
	ParseInt(param, "trade", trade);

	if(trade == 1)
	{
		Wintitle_tex.SetText(GetSystemString(2076)@ "-" @ GetSystemString(2072));
		ReceiveBtn.HideWindow();
		ReturnBtn.HideWindow();
		SendCancelBtn.HideWindow();
		Me.ShowWindow();
		Me.SetFocus();
	}
}

function OnEVReplySentPostAddItem(string param)
{
	// End:0x1F
	if(TRADE == 1)
	{
		PostDetailWnd_SafetyTradeListWndScript.AddItem(param);
	}
}

function OnEVReplySentPostEnd(String Param)
{
	local string ReceiverName, title, contents;
	local INT64 tradeMoney;
	local int notOpend;
	local string fixedtitle;
	local CustomTooltip cTooltip;

	// End:0x262
	if(trade == 1)
	{
		ParseInt(param, "MailID", mailID); // 메일 아이디
		ParseString(param, "ReceiverName", ReceiverName); // 받을 사람
		ParseString(param, "Title", title); // 제목
		ParseString(param, "Content", contents); // 내용
		ParseINT64(param, "TradeMoney", tradeMoney); // 청구비용
		ParseInt(param, "NotOpend", notOpend); // 취소할수있나(1), 없나(0)
		PostType.SetTextColor(impactcolor);
		PostType.SetText(GetSystemString(2072));
		fixedtitle = DivideStringWithWidth(title, 380);
		if(fixedtitle != title)
		{
			fixedtitle =  fixedtitle $ "...";
		}
		PostTitle.SetText(fixedtitle);
		Title_SenderID.SetText(GetSystemString(2087));
		PostContents.AddString(contents, GetChatColorByType(0));
		PostContents.SetTextListBoxScrollPosition(0);
		SenderID.SetText(ReceiverName);
		ReceiveBtn.HideWindow();
		ReturnBtn.HideWindow();
		ReplyBtn.HideWindow();
		SafetyTradeAdenaText.SetTextColor(impactcolor);
		SafetyTradeAdenaText.SetText(MakeCostString(string(tradeMoney)));
		addToolTipDrawList(cTooltip, addDrawItemText((ConvertNumToTextNoAdena(string(tradeMoney))$ " ")$ GetSystemString(469), getInstanceL2Util().White, "", false));
		SafetyTradeAdenaText.SetTooltipCustomType(cTooltip);

		if(PostDetailWnd_SafetyTradeListWndScript.GetItemListCount() != 0)
		{
			SendCancelBtn.ShowWindow();
		}
		else
		{
			SendCancelBtn.HideWindow();
		}
	}
}

function ClearAll()
{
	SenderID.SetText("");
	PostType.SetTextColor(impactcolor);
	PostType.SetText(GetSystemString(2072));
	PostTitle.SetText("");
	PostContents.Clear();
	WeightText.SetText("0");
	SafetyTradeAdenaText.SetTextColor(impactcolor);
	SafetyTradeAdenaText.SetText("0");
	SafetyTradeAdenaText.ClearTooltip();
	ReceiveBtn.HideWindow();
	ReturnBtn.HideWindow();
	SendCancelBtn.HideWindow();
	PostDetailWnd_SafetyTradeListWndScript.Clear();
}

function OnClickButton(String a_ButtonID)
{

	switch(a_ButtonID)
	{
	case "ReceiveBtn":		
		if(returnd == 0 && trade == 1)
		{
			DialogHide();
			DialogShow(DialogModalType_Modalless,DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3086), SenderID.GetText(), ConvertNumToText(string(ReceivedTradeAdena))), string(Self));
			DialogSetID(DIALOG_RECEIVE_TRADE_POST);
		}
		else
		{
			RequestReceivePost(mailID);
			Me.HideWindow();
		}	
		break;
	case "ReturnBtn":
		if(returnd == 0 && trade == 1 && returnable == 1)
		{
			DialogHide();
			DialogShow(DialogModalType_Modalless,DialogType_OKCancel, GetSystemMessage(3069), string(Self));
			DialogSetID(DIALOG_RETURN_POST);			
		}
		break;
	case "SendCancelBtn":
		RequestCancelSentPost(mailID);
		Me.HideWindow();
		break;
	case "ReplyBtn":
		HandleReplyBtn();
		break;
	//선준 수정(10.03.19)
	case "AddBtn":
		HandleAddBtn();
		break;
	}
}
function HandleDialogOK()
{
	local int Id;

	// End:0x6A
	if(DialogIsMine())
	{
		Id = DialogGetID();
		// End:0x41
		if(Id == DIALOG_RECEIVE_TRADE_POST)
		{
			RequestReceivePost(mailID);
			Me.HideWindow();
		}
		else if(Id == DIALOG_RETURN_POST)
		{
			RequestRejectPost(mailID);
			Me.HideWindow();
		}
	}
}

function HandleReplyBtn()
{
	local PostWriteWnd script;
	local string Title;

	// End:0x81
	if(returnd != 1)
	{
		RequestPostItemList();
		script = PostWriteWnd(GetScript("PostWriteWnd"));
		Me.HideWindow();
		Title = "[Re]" $ PostTitle.GetText();
		script.SetPostWriteWnd(SenderID.GetText(), Title, "");
	}
}

//선준 수정(10.03.19)
function HandleAddBtn()
{
	class'PostWndAPI'.static.RequestAddingPostFriend(SenderID.GetText());
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("PostDetailWnd_SafetyTrade").HideWindow();
}

defaultproperties
{
}
