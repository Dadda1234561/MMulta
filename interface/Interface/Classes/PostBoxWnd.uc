class PostBoxWnd extends UICommonAPI;

const MAIL_PER_PAGE = 8;
const MAX_PAGE_NUM = 3;

const RECEIVED_WINDOW_TAB = 0;
const SENT_WINDOW_TAB = 1;

const DIALOG_DELETE_SELECTED_RECEIVED_MAIL = 1111;
const DIALOG_NO_DETECTED_DELETE_RECEIVED_MAIL = 2222;
const DIALOG_DELETE_SELECTED_SENT_MAIL = 3333;
const DIALOG_NO_DETECTED_DELETE_SENT_MAIL = 4444;
const DIALOG_CONFIRM_TRADE_POST = 5555;

struct ReceivedPostMSG
{
	var int mailID;
	var string title;
	var string senderName;
	var int trade;	//��������
	var int notOpend;
	var int returnAble;
	var int withItem;
	var int returnd;
	var int sentBySystem;
	var float diffTime;		//����ð� - ��������ð�
	var int CheckBoxState;
};

struct SentPostMSG
{
	var int mailID;
	var string title;
	var string receivername;
	var int trade;
	var int notOpend;
	var int returnable;
	var int withItem;
	var int sentBySystem;
	var float diffTime;
	var int CheckBoxState;
};


var WindowHandle Me;
var WindowHandle ReceivePost;
var WindowHandle SendPost;
var WindowHandle PostWriteWnd;
var WindowHandle PostDetailWnd_General;
var WindowHandle PostDetailWnd_SafetyTrade;

var TabHandle TabCtrl;

var TextureHandle TexTabBg;
var TextureHandle TexTabBgLine;
var TextureHandle groupbox;
var TextureHandle ReceiveGroupLine;
var TextureHandle ReceiveSafetyTradeIcon;
var TextureHandle ReceiveAccompanyIcon;
var TextureHandle ReceivePostListDeco;
var TextureHandle SendGroupLine;
var TextureHandle SendSafetyTradeIcon;
var TextureHandle SendAccompanyIcon;
var TextureHandle SendPostListDeco;
var TextBoxHandle ReceiveListNumber;
var TextBoxHandle SendListNumber;
var ButtonHandle ReceiveListPrevBtn;
var ButtonHandle ReceiveListNextBtn;
var ButtonHandle ReceiveDelBtn;
var ButtonHandle PostSendBtn;
var ButtonHandle SendListPrevBtn;
var ButtonHandle SendListNextBtn;
var ButtonHandle SendDelBtn;
var ButtonHandle PaymentPostSendBtn;
var ListCtrlHandle ReceivedPostList;
var ListCtrlHandle SentPostList;
var CheckBoxHandle ReceivePostCheck_all;
var CheckBoxHandle ReceivePostCheck[MAIL_PER_PAGE];
var CheckBoxHandle SendPostCheck_all;
var CheckBoxHandle SendPostCheck[MAIL_PER_PAGE];
var array<ReceivedPostMSG> receivedInfoList;
var array<SentPostMSG> sentInfoList;
var int ReceivedPageNum; //�� ������ ��
var int SentPageNum;

var int curReceivedPage; //���� �������� �����ֳ�
var int curSentPage;
var int ReceivedPageFullCheckState[MAX_PAGE_NUM]; //Ǯ üũ ���¸� �����ϴ� 
var int SentPageFullCheckState[MAX_PAGE_NUM];

var int ZoneType;

var string m_WindowName;
var int checkState[MAIL_PER_PAGE];
var Color notReadPostColor;
var Color readPostColor;
var Color tradePostColor;
var Color tradereadPostColor;

//var int IsPeaceZone;		//���� ���� PeaceZone�ΰ�

function OnRegisterEvent()
{
	RegisterEvent(EV_Notice_Post_Arrived); //�̺�Ʈ ���
	RegisterEvent(EV_StartReceivedPostList);
	RegisterEvent(EV_AddReceivedPostList);
	RegisterEvent(EV_EndReceivedPostList);
//	RegisterEvent(EV_ReplyReceivedPost);
	RegisterEvent(EV_StartSentPostList); //�̺�Ʈ ���
	RegisterEvent(EV_AddSentPostList);
	RegisterEvent(EV_EndSentPostList);
	RegisterEvent(EV_DialogOK);
//	RegisterEvent(EV_ReplySentPost);

	RegisterEvent(EV_DeleteReceivedPost);
	RegisterEvent(EV_OpenStateReceivedPost);
	RegisterEvent(EV_ReceivedStateReceivedPost);
	RegisterEvent(EV_DeleteSentPost);
	RegisterEvent(EV_OpenStateSentPost);
	RegisterEvent(EV_ReceivedStateSentPost);

	RegisterEvent(EV_ReceiveFriendList);
	RegisterEvent(EV_ConfirmAddingPostFriend);
	RegisterEvent(EV_ReceivePostFriendList);
}

function OnLoad()
{
	SetClosingOnESC();
	InitializeCOD();
	Me.HideWindow();
	notReadPostColor.R = 220;
	notReadPostColor.G = 220;
	notReadPostColor.B = 220;
	readPostColor.R = 130;
	readPostColor.G = 130;
	readPostColor.B = 130;

	tradePostColor.R = 255;
	tradePostColor.G = 114;
	tradePostColor.B = 0;
	tradereadPostColor.R = 145;
	tradereadPostColor.G = 84;
	tradereadPostColor.B = 35;
}

function InitializeCOD()
{
	local int i;

	Me = GetWindowHandle(m_WindowName);
	ReceivePost = GetWindowHandle(m_WindowName $ ".ReceivePost");
	SendPost = GetWindowHandle(m_WindowName $ ".SendPost");
	PostWriteWnd = GetWindowHandle("PostWriteWnd");
	PostDetailWnd_General = GetWindowHandle("PostDetailWnd_General");
	PostDetailWnd_SafetyTrade = GetWindowHandle("PostDetailWnd_SafetyTrade");

	ReceiveListNumber = GetTextBoxHandle(m_WindowName $ ".ReceiveListNumber");
	SendListNumber = GetTextBoxHandle(m_WindowName $ ".SendListNumber");
	ReceivedPostList = GetListCtrlHandle(m_WindowName $ ".ReceivePostList");
	SentPostList = GetListCtrlHandle(m_WindowName $ ".SendPostList");
	TabCtrl = GetTabHandle(m_WindowName $ ".TabCtrl");
	TexTabBg = GetTextureHandle(m_WindowName $ ".TexTabBg");
	TexTabBgLine = GetTextureHandle(m_WindowName $ ".TexTabBgLine");
	groupbox = GetTextureHandle(m_WindowName $ ".groupbox");
	ReceiveGroupLine = GetTextureHandle(m_WindowName $ ".ReceiveGroupLine");
	ReceiveSafetyTradeIcon = GetTextureHandle(m_WindowName $ ".ReceiveSafetyTradeIcon");
	ReceiveAccompanyIcon = GetTextureHandle(m_WindowName $ ".ReceiveAccompanyIcon");
	ReceivePostListDeco = GetTextureHandle(m_WindowName $ ".ReceivePostListDeco");
	SendGroupLine = GetTextureHandle(m_WindowName $ ".SendGroupLine");
	SendSafetyTradeIcon = GetTextureHandle(m_WindowName $ ".SendSafetyTradeIcon");
	SendAccompanyIcon = GetTextureHandle(m_WindowName $ ".SendAccompanyIcon");
	SendPostListDeco = GetTextureHandle(m_WindowName $ ".SendPostListDeco");
	ReceivePostCheck_all = GetCheckBoxHandle(m_WindowName $ ".ReceivePostCheck_all");
	for(i = 0; i < MAIL_PER_PAGE; i++)
	{
		ReceivePostCheck[i] = GetCheckBoxHandle(m_WindowName $ ".ReceivePostCheck_" $ string(i));
	}
	

	SendPostCheck_all=GetCheckBoxHandle(m_WindowName $ ".SendPostCheck_all");
	for(i = 0; i < MAIL_PER_PAGE; i++)
	{
		SendPostCheck[i]=GetCheckBoxHandle(m_WindowName $ ".SendPostCheck_"$string(i));
	}
	ReceiveListPrevBtn = GetButtonHandle(m_WindowName $ ".ReceiveListPrevBtn");
	ReceiveListNextBtn = GetButtonHandle(m_WindowName $ ".ReceiveListNextBtn");
	ReceiveDelBtn = GetButtonHandle(m_WindowName $ ".ReceiveDelBtn");
	PostSendBtn = GetButtonHandle(m_WindowName $ ".PostSendBtn");
	PaymentPostSendBtn = GetButtonHandle(m_WindowName $ ".PaymentPostSendBtn");
	SendListPrevBtn = GetButtonHandle(m_WindowName $ ".SendListPrevBtn");
	SendListNextBtn = GetButtonHandle(m_WindowName $ ".SendListNextBtn");
	SendDelBtn = GetButtonHandle(m_WindowName $ ".SendDelBtn");
}

function OnShow()
{ 
	// ������ �����츦 ������ �ݱ� ��� 
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)));
	getInstanceL2Util().checkIsPrologueGrowType(string(self));

	//if(PostWriteWnd.IsShowwindow())
	//	PostWriteWnd.HideWindow();
	//if(PostDetailWnd_General.IsShowWindow())
	//	PostDetailWnd_General.HideWindow();
	//if(PostDetailWnd_SafetyTrade.IsShowWindow())
	//	PostDetailWnd_SafetyTrade.HideWindow();
}

function OnEvent(int Event_ID, String Param)
{
	//local int zonetype;
	switch(Event_ID)
	{
	case EV_Notice_Post_Arrived :
		break;
	case EV_StartReceivedPostList: 
		OnEVStartReceivedPostList(param);
		break;
	case EV_AddReceivedPostList:
		OnEVAddReceivedPostList(param);
		break;
	case EV_EndReceivedPostList:
		OnEVEndReceivedPostList();
		break;

	case EV_StartSentPostList:
		OnEVStartSentPostList(param);
		break;
	case EV_AddSentPostList:
		OnEVAddSentPostList(param);
		break;
	case EV_EndSentPostList:
		OnEVEndSentPostList();
		break;
	case EV_DialogOK:
		OnEVDialogOk();
		break;

	case EV_DeleteReceivedPost:
		OnDeleteReceivedPost(param);
		break;
	case EV_OpenStateReceivedPost:
		OnOpenStateReceivedPost(param);
		break;
	case EV_ReceivedStateReceivedPost:
		OnReceivedStateReceivedPost(param);
		break;
	case EV_DeleteSentPost:
		OnDeleteSentPost(param);
		break;
	case EV_OpenStateSentPost:
		OnOpenStateSentPost(param);
		break;
	case EV_ReceivedStateSentPost:
		OnReceivedStateSentPost(param);
		break;
	case EV_ReceiveFriendList:
		break;
	case EV_ConfirmAddingPostFriend:
		break;
	case EV_ReceivePostFriendList:
		break;
	}
}
function int GetReceivedPostMailIndex(int mailID)
{
	local int i;
	for(i = 0; i < receivedInfoList.Length; i++)
	{
		// End:0x37
		if(receivedInfoList[i].mailID == mailID)
		{
			return i;
		}
	}
	return -1;
}

function int GetSentPostMailIndex(int mailID)
{
	local int i;
	for(i = 0; i < sentInfoList.Length; i++)
	{
		if(sentInfoList[i].mailID == mailID)
			return i;
	}
	return -1;
}

function OnDeleteReceivedPost(string param)
{
	local int mailID;
	local int mailIndex;
	ParseInt(param, "mailID", mailID);

	mailIndex = GetReceivedPostMailIndex(mailID);
	if(mailIndex >= 0)
	{
		receivedInfoList.Remove(mailIndex, 1);
		if(TabCtrl.GetTopIndex()== 0)
		{
			ReSetReceivedPostCurPage();
			ShowReceivedList(curReceivedPage);
		}
	}

}
	
function OnOpenStateReceivedPost(string param)
{
	local int mailID;
	local int mailIndex;
	ParseInt(param, "mailID", mailID);

	mailIndex = GetReceivedPostMailIndex(mailID);
	if(mailIndex >= 0)
	{
		receivedInfoList[mailIndex].notOpend = 0;
		if(TabCtrl.GetTopIndex()== 0)
		{
			ShowReceivedList(curReceivedPage);
		}
	}

}	
function OnReceivedStateReceivedPost(string param)
{
	local int mailID;
	local int mailIndex;
	ParseInt(param, "mailID", mailID);

	mailIndex = GetReceivedPostMailIndex(mailID);
	if(mailIndex >= 0)
	{
		receivedInfoList[mailIndex].withItem = 0;
		if(TabCtrl.GetTopIndex()== 0)
		{
			ShowReceivedList(curReceivedPage);
		}
	}
}	
function OnDeleteSentPost(string param)
{
	local int mailID;
	local int mailIndex;
	ParseInt(param, "mailID", mailID);

	mailIndex = GetSentPostMailIndex(mailID);
	if(mailIndex >= 0)
	{
		sentInfoList.Remove(mailIndex, 1);
		if(TabCtrl.GetTopIndex()== 1)
		{
			ReSetSentPostCurPage();
			ShowSentList(curSentPage);
		}
	}

}	
function OnOpenStateSentPost(string param)
{
	local int mailID;
	local int mailIndex;
	ParseInt(param, "mailID", mailID);

	mailIndex = GetSentPostMailIndex(mailID);
	if(mailIndex >= 0)
	{
		sentInfoList[mailIndex].notOpend = 0;
		if(TabCtrl.GetTopIndex()== 1)
		{
			ShowSentList(curSentPage);
		}
	}

}
function OnReceivedStateSentPost(string param)
{
	local int mailID;
	local int mailIndex;
	
	ParseInt(param, "mailID", mailID);

	mailIndex = GetSentPostMailIndex(mailID);
	if(mailIndex >= 0)
	{
		sentInfoList[mailIndex].withItem = 0;
		if(TabCtrl.GetTopIndex()== 1)
		{
			ShowSentList(curSentPage);
		}
	}
}

function OnEVStartReceivedPostList(string param)
{	
	// local WindowHandle m_inventoryWnd;
	local int ReceivedMailCount;

	ClearReceivedInfo();
	ParseInt(param, "ReceivedMailCount", ReceivedMailCount);
	ReceivedInfoList.Length = 0;	
	Me.ShowWindow();
	Me.Setfocus();
	TabCtrl.SetTopOrder(0,true);

	//if(CREATE_ON_DEMAND==0)
	//	m_inventoryWnd = GetHandle("InventoryWnd");	//�κ��丮�� ������ �ڵ��� ���´�.
	//else
	//	m_inventoryWnd = GetWindowHandle("InventoryWnd");	//�κ��丮�� ������ �ڵ��� ���´�.


	//if(m_inventoryWnd.IsShowWindow())			//�κ��丮 â�� ���������� �ݾ��ش�. 
	//{
	//	m_inventoryWnd.HideWindow();
	//}

}
function OnEVAddReceivedPostList(string param)
{
	local int mailID, Trade, notOpend, returnd, returnable, withItem, sentbysystem;
	local float diffTime;
	local string title, senderName;
	local ReceivedPostMSG receivedMSG;

	ParseInt(param, "MailID", mailID);	// �������̵�
	ParseString(param, "Title", title);	// ����
	ParseString(param, "SenderName", senderName); //���� ����� �̸�
	ParseInt(param, "Trade", Trade); // �����ŷ�(1)�ΰ� �ƴѰ�(0)
	ParseInt(param, "NotOpend", notOpend); // �ѹ��� �������� ���� �����ΰ�(1)
	
	ParseInt(param, "ReturnAble", returnable); // �ݼ��� �� �ֳ�(1), ����(0)
	ParseInt(param, "WithItem", withItem); // �������� �ֳ�(1), ����(0)
	ParseInt(param, "Returnd", returnd);  // �ݼ۵� �����ΰ�(1), �ƴѰ�(0)
	ParseInt(param, "SentBySystem", sentbysystem);// �ý����� ���������ΰ�(1), �ƴѰ�(0)
	ParseFloat(param, "DiffTime", diffTime);

	receivedMSG.mailID = mailID;
	receivedMSG.Title = Title;
	receivedMSG.senderName = senderName;
	receivedMSG.trade = Trade;
	receivedMSG.notOpend = notOpend;
	receivedMSG.returnAble = returnable;
	receivedMSG.withItem = withItem;
	receivedMSG.returnd = returnd;
	receivedMSG.sentBySystem = sentbysystem;
	receivedMSG.diffTime = diffTime;
	receivedMSG.CheckBoxState = 0;

	receivedInfoList.insert(receivedInfoList.Length,1);
	receivedInfoList[receivedInfoList.Length - 1] = receivedMSG;
}

function reverseReceivedPostListArray()
{
	local array<ReceivedPostMSG> ArrayItem;
	local int index;
	local int i;

	index = receivedInfoList.Length;
	
	for(i = index - 1 ; i >= 0 ; i--)
	{
		//debug("�迭 �ݺ�0>>>"@receivedInfoList[i].title);

		ArrayItem.Insert(ArrayItem.Length,1);
		ArrayItem[ArrayItem.Length - 1] = receivedInfoList[i];
	}

	receivedInfoList = ArrayItem;
}

function OnEVEndReceivedPostList()
{
	reverseReceivedPostListArray();

	ResetReceivedPostPageNum();
	curReceivedPage = 0;
	ShowReceivedList(curReceivedPage);
}
// ���� ���� �������� ���� �缳�����ִ� �Լ�
function ResetReceivedPostPageNum()
{
	ReceivedPageNum = receivedInfoList.Length / MAIL_PER_PAGE;
	if(receivedInfoList.Length % MAIL_PER_PAGE != 0)
	{
		ReceivedPageNum++;		
	}
}

// ���� �޼����� ���� �޼�����  �缳�� ���ִ� �Լ�
function ReSetReceivedPostCurPage()
{
	ResetReceivedPostPageNum();
	if(ReceivedPageNum <= curReceivedPage)
	{
		curReceivedPage = ReceivedPageNum - 1;
	}
	// End:0x35
	if(curReceivedPage < 0)
	{
		curReceivedPage = 0;
	}
	//debug("ReSetReceivedPostCurPage"@ReceivedPageNum@curReceivedPage);

}

function OnEVStartSentPostList(string param)
{
	local int SentMailCount;
	local WindowHandle m_inventoryWnd;
	if(CREATE_ON_DEMAND==0)
		m_inventoryWnd = GetHandle("InventoryWnd");	//�κ��丮�� ������ �ڵ��� ���´�.
	else
		m_inventoryWnd = GetWindowHandle("InventoryWnd");	//�κ��丮�� ������ �ڵ��� ���´�.

	ClearSentInfo();
	ParseInt(param, "SentMailCount", SentMailCount);
	sentInfoList.Length = 0;	
	Me.ShowWindow();
	TabCtrl.SetTopOrder(1,true);
	if(m_inventoryWnd.IsShowWindow())			//�κ��丮 â�� ���������� �ݾ��ش�. 
	{
		m_inventoryWnd.HideWindow();
	}
}

function OnEVAddSentPostList(string param)
{
	local int mailID, Trade, notOpend, returnable, sentbysystem, withItem;
	local float diffTime;
	local string title, receiverName;
	local SentPostMSG sentMsg;
	ParseInt(param, "MailID", mailID);	// �������̵�
	ParseString(param, "Title", title);	// ����
	ParseString(param,"ReceiverName",receiverName); //���� ����� �̸�

	ParseInt(param, "Trade", Trade); // �����ŷ�(1)�ΰ� �ƴѰ�(0)
	ParseInt(param, "NotOpend", notOpend); // �ѹ��� �������� ���� �����ΰ�(1)������ �����ΰ�(0)
	ParseInt(param, "ReturnAble", returnable); // �ݼ��� �� �ֳ�(1), ����(0)
	ParseInt(param, "WithItem", withItem); // �������� �ֳ�(1), ����(0)
	ParseInt(param, "SentBySystem", sentbysystem);// �ý����� ���������ΰ�(1), �ƴѰ�(0)
	ParseFloat(param, "DiffTime", diffTime);

	sentMsg.mailID = mailID;
	sentMsg.title = title;
	sentMsg.receiverName = receiverName;
	sentMsg.trade = Trade;
	sentMsg.notOpend = notOpend;
	sentMsg.returnAble = returnable;
	sentMsg.withItem = withItem;
	sentMsg.sentBySystem = sentBySystem;
	sentMsg.diffTime = diffTime;
	sentMsg.CheckBoxState = 0;

	sentInfoList.Insert(sentInfoList.Length, 1);
	sentInfoList[sentInfoList.Length - 1] = sentMsg;
}

function reverseSendPostListArray()
{
	local array<SentPostMSG> ArrayItem;
	local int index;
	local int i;

	index = sentInfoList.Length;
	
	for(i = index - 1 ; i >= 0 ; i--)
	{
		//debug("�迭 �ݺ�22>>>"@sentInfoList[i].title);

		ArrayItem.Insert(ArrayItem.Length,1);
		ArrayItem[ArrayItem.Length - 1] = sentInfoList[i];
	}

	sentInfoList = ArrayItem;
}

function OnEVEndSentPostList()
{
	reverseSendPostListArray();

	SentPageNum = sentInfoList.Length / MAIL_PER_PAGE;
	if(sentInfoList.Length % MAIL_PER_PAGE != 0)
	{
		SentPageNum++;
		
	}
	curSentPage = 0;
	ShowSentList(curSentPage);
}
// ���� ���� �������� ���� �缳�����ִ� �Լ�
function ResetSentPostPageNum()
{
	SentPageNum = sentInfoList.Length / MAIL_PER_PAGE;
	if(sentInfoList.Length % MAIL_PER_PAGE != 0)
	{
		SentPageNum++;		
	}
}
// ���� �޼����� ���� �޼�����  �缳�� ���ִ� �Լ�
function ReSetSentPostCurPage()
{
	ResetSentPostPageNum();
	if(SentPageNum <= curSentPage)
		curSentPage = SentPageNum - 1;
	if(curSentPage < 0)
		curSentPage = 0;

}

function OnEVDialogOk()
{
	local int id;
	local int reserved;
	if(DialogIsMine())
	{
		id = DialogGetID();

		if(id == DIALOG_DELETE_SELECTED_RECEIVED_MAIL)
		{
			DeleteSelectedReceivedMail();
			ClearReceivedCheckBox();				
			SetAllReceivedCheckBox(curReceivedPage);
		}
		else if(id == DIALOG_DELETE_SELECTED_SENT_MAIL)
		{
			
			DeleteSelectedSentMail();
			ClearSentCheckBox();
			SetAllSentCheckBox(curSentPage);
		}
		else if(id == DIALOG_CONFIRM_TRADE_POST)
		{
			reserved = DialogGetReservedInt();
			RequestRequestReceivedPost(reserved);	//ȣ��...
		}
	}
}

function ClearReceivedCheckBox()
{
	local int i;
	ReceivePostCheck_all.SetCheck(false);
	for(i = 0; i < MAIL_PER_PAGE; i++)
	{
		ReceivePostCheck[i].SetCheck(false);
	}
	Debug("�ޱ���ʱ�ȭ�޹�");
}
function ClearSentCheckBox()
{
	local int i;

	SendPostCheck_all.SetCheck(false);
	for(i = 0; i < MAIL_PER_PAGE; i++)
	{
		SendPostCheck[i].SetCheck(false);
	}	

	Debug("�������ʱ�ȭ�޹�");
}

function OnClickButton(String a_ButtonID)
{
	local PostWriteWnd script;
	switch(a_ButtonID)
	{
		case "TabCtrl0":
			ClearReceivedCheckBox();	
			ClearSentCheckBox();
			ShowReceivedList(curReceivedPage, true);			
			RequestRequestReceivedPostList();
			break;
		case "TabCtrl1":
			
			ClearSentCheckBox();
			ClearReceivedCheckBox();
			ShowSentList(curReceivedPage, true);			
			RequestRequestSentPostList();
			break;
		case "ReceiveListPrevBtn":
			ReceivedListPrevBtn();
			break;
		case "ReceiveListNextBtn":
			ReceivedListNextBtn();
			break;
		case "SendListPrevBtn":
			SentListPrevBtn();
			break;
		case "SendListNextBtn":
			SentListNextBtn();
			break;
		case "PostSendBtn":
			if(!GetWindowHandle("PostWriteWnd").IsShowwindow())
			{
				script = PostWriteWnd(GetScript("PostWriteWnd"));
				RequestPostItemList();
				script.ClearAll();	
				GetWindowHandle("PostWriteWnd").ShowWindow();
				GetWindowHandle("PostWriteWnd").Setfocus();				
			}
			break;
		case "PaymentPostSendBtn" :
			if(!GetWindowHandle("PostWriteWnd").IsShowwindow())
			{
				script = PostWriteWnd(GetScript("PostWriteWnd"));
				RequestPostItemList();
				script.ClearAll();	
				GetWindowHandle("PostWriteWnd").ShowWindow();
				GetWindowHandle("PostWriteWnd").Setfocus();				
				// ��� û���� ����
				script.EnableSafetyAdena();
			}
			break;

		case "ReceiveDelBtn":
			ViewReceiveDelDialog();
			break;
		case "SendDelBtn":
			ViewSendDelDialog();
			break;
	}
}
function ViewReceiveDelDialog()
{
	local int i;
	local int deleteMSGNum;
	deleteMSGNum = 0;
	for(i = 0; i < receivedInfoList.Length; i++)
	{
		if(receivedInfoList[i].CheckBoxState == 1)
		{
			deleteMSGNum++;
		}
	}
	if(deleteMSGNum > 0)
	{
		DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
		DialogShow(DialogModalType_Modalless,DialogType_OKCancel, GetSystemMessage(3014), string(Self));		
		DialogSetID(DIALOG_DELETE_SELECTED_RECEIVED_MAIL);
	}
	else
	{
		DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
		DialogShow(DialogModalType_Modalless,DialogType_Notice, GetSystemMessage(3015), string(Self));		
		DialogSetID(DIALOG_NO_DETECTED_DELETE_RECEIVED_MAIL);
	}
}
function ViewSendDelDialog()
{
	local int i;
	local int deleteMSGNum;
	deleteMSGNum = 0;
	for(i = 0; i < sentInfoList.Length; i++)
	{
		if(sentInfoList[i].CheckBoxState == 1)
		{
			deleteMSGNum++;
		}
	}

	if(deleteMSGNum > 0)
	{
		DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
		DialogShow(DialogModalType_Modalless,DialogType_OKCancel, GetSystemMessage(3014), string(Self));		
		DialogSetID(DIALOG_DELETE_SELECTED_SENT_MAIL);
	}
	else
	{
		DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
		DialogShow(DialogModalType_Modalless,DialogType_Notice, GetSystemMessage(3015), string(Self));
		DialogSetID(DIALOG_NO_DETECTED_DELETE_SENT_MAIL);
	}
}

function DeleteSelectedReceivedMail()
{

	local int i;
	local array<int> deleteReceivedList;
	local int deleteMSGNum;
	deleteMSGNum = 0;
	for(i = 0; i < receivedInfoList.Length; i++)
	{
		if(receivedInfoList[i].CheckBoxState == 1)
		{
			deleteReceivedList.Insert(deleteReceivedList.Length, 1);
			deleteReceivedList[deleteReceivedList.Length - 1] = receivedInfoList[i].mailID;
			deleteMSGNum++;
		}
	}
	if(deleteMSGNum > 0)
		RequestDeleteReceivedPost(deleteReceivedList);
	
}
function DeleteSelectedSentMail()
{
	local int i;
	local array<int> deleteSentList;
	local int deleteMSGNum;
	deleteMSGNum = 0;
	for(i = 0; i < sentInfoList.Length; i++)
	{
		if(sentInfoList[i].CheckBoxState == 1)
		{
			deleteSentList.Insert(deleteSentList.Length, 1);
			deleteSentList[deleteSentList.Length - 1] = sentInfoList[i].mailID;
			deleteMSGNum++;
		}
	}
	if(deleteMSGNum > 0)
		RequestDeleteSentPost(deleteSentList);
}
function ReceivedListPrevBtn()
{
	local bool changed;

	changed= true;
	curReceivedPage--;
	if(curReceivedPage < 0)
	{
		curReceivedPage = 0;
		changed = false;
	}
	// End:0x3D
	if(changed)
	{
		ShowReceivedList(curReceivedPage);
	}
}

function ReceivedListNextBtn()
{
	local bool changed;
	changed = true;
	curReceivedPage++;
	if(curReceivedPage >= ReceivedPageNum)
	{
		curReceivedPage = curReceivedPage - 1;
		changed = false;
	}

	if(changed)
	{
		ShowReceivedList(curReceivedPage);
	}
}

function SentListPrevBtn()
{
	local bool changed;
	changed = true;
	curSentPage--;
	if(curSentPage < 0)
	{
		curSentPage = 0;
		changed = false;
	}
	if(changed)
	{
		ShowSentList(curSentPage);
	}
}
function SentListNextBtn()
{
	local bool changed;
	changed = true;
	curSentPage++;
	if(curSentPage >= SentPageNum)
	{
		curSentPage = curSentPage - 1;
		changed = false;
	}
	if(changed)
	{
		ShowSentList(curSentPage);
	}
}
function ShowReceiveListNumber()
{
	if(ReceivedPageNum > 0)
	{
		ReceiveListNumber.SetText(string(curReceivedPage + 1)$"/"$string(ReceivedPageNum));
	}
	else
	{
		ReceiveListNumber.SetText("0/0");
	}
}
function ShowSendListNumber()
{
	if(SentPageNum > 0)
	{
		SendListNumber.SetText(string(curSentPage + 1)$"/"$string(SentPageNum));
	}
	else
	{
		SendListNumber.SetText("0/0");
	}
}

function Color GetTextColorByType(int notOpened, int TRADE)
{
	if(notOpened == 0 && TRADE == 0)
		return readPostColor;
	else if(notOpened == 1 && TRADE == 0)
		return notReadPostColor;
	else if(notOpened == 0 && TRADE == 1)
		return tradereadPostColor;
	else if(notOpened == 1 && TRADE == 1)
		return tradePostColor;
}

function ShowReceivedList(int Page, optional bool exceptionCheckBoxRefresh)
{
	local int i,j;
	local LVData Data[5];
	local LVDataRecord Record;
	local int start, end;
	local Color tmpColor;

	ReceivedPostList.showwindow();
	SentPostList.hidewindow();
	ReceivedPostList.DeleteAllItem();
	if(Page >= 0 && Page < ReceivedPageNum)
	{
		if(Page == ReceivedPageNum - 1)//������ ���������
		{
			start = Page * MAIL_PER_PAGE;
			end =  start +(receivedInfoList.Length % MAIL_PER_PAGE);
			if(receivedInfoList.Length % MAIL_PER_PAGE == 0)
			{
				end += MAIL_PER_PAGE;
			}
		}
		else
		{
			start = Page * MAIL_PER_PAGE;
			end =  start + MAIL_PER_PAGE;
		}
		Record.LVDataList.Length = 5;

		for(i = start; i < end; i++)
		{
			Data[0].szData = "";
			Data[0].nReserved1 = receivedInfoList[i].mailID; //mailID �Ѱ���
			Data[0].nReserved2 = receivedInfoList[i].trade;	//�����ŷ� ���ε� �Ѱ���.
			Data[0].nReserved3 = receivedInfoList[i].returnd;

			Data[1].nTextureWidth = 18;
			Data[1].nTextureHeight = 12;
   			
	
			if(receivedInfoList[i].notOpend == 0)
			{
				//branch110706 �ΰ��Ӽ� ���� �������߰�
				if(receivedInfoList[i].sentBySystem == 7) // �ΰ��Ӽ� ������
				{	
					Data[1].szData="";
					Data[1].szTexture = "BranchSys3.Icon.primeshop_gift_confirmed";					
				}
				//end of branch
				else if(receivedInfoList[i].Trade == 1 && receivedInfoList[i].withItem == 1)
				{
					Data[1].szData="";
					Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_SafetyTrade_Accompany_confirmed";
					if(receivedInfoList[i].returnd == 1)//�ݼ۵� ������ ���� �����ŷ� ǥ�ø� ������
					{
						Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_Accompany_confirmed";
					}
				}
				else if(receivedInfoList[i].Trade == 1 && receivedInfoList[i].withItem == 0)
				{
					Data[1].szData="";
					Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_SafetyTrade_confirmed";
					if(receivedInfoList[i].returnd == 1)//�ݼ۵� ������ ���� �����ŷ� ǥ�ø� ������
					{
						Data[1].szTexture = "L2UI_CT1.Misc_DF_Blank";
					}
				}
				else if(receivedInfoList[i].Trade == 0 && receivedInfoList[i].withItem == 1)
				{	
					Data[1].szData="";
					Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_Accompany_confirmed";
				}

				else
				{
					Data[1].szData="";
					Data[1].szTexture = "L2UI_CT1.Misc_DF_Blank";
				}
			}
			else
			{
				//branch110706 �ΰ��Ӽ� ���� �������߰�
				if(receivedInfoList[i].sentBySystem == 7) // �ΰ��Ӽ� ������
				{	
					Data[1].szData="";
					Data[1].szTexture = "BranchSys3.Icon.primeshop_gift";					
				}
				//end of branch
				else if(receivedInfoList[i].Trade == 1 && receivedInfoList[i].withItem == 1)
				{				
					Data[1].szData="";
					Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_SafetyTrade_Accompany";
					if(receivedInfoList[i].returnd == 1)//�ݼ۵� ������ ���� �����ŷ� ǥ�ø� ������
					{
						Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_Accompany";
					}
				}
				else if(receivedInfoList[i].Trade == 1 && receivedInfoList[i].withItem == 0)
				{
					Data[1].szData="";
					Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_SafetyTrade";
					if(receivedInfoList[i].returnd == 1)//�ݼ۵� ������ ���� �����ŷ� ǥ�ø� ������
					{
						Data[1].szTexture = "L2UI_CT1.Misc_DF_Blank";
					}
				}
				else if(receivedInfoList[i].Trade == 0 && receivedInfoList[i].withItem == 1)
				{	
					Data[1].szData="";
					Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_Accompany";
				}

				else
				{
					Data[1].szData="";
					Data[1].szTexture = "L2UI_CT1.Misc_DF_Blank";
				}
			}

			Data[2].buseTextColor = true;
			Data[3].buseTextColor = true;
			Data[4].buseTextColor = true;

			tmpColor = GetTextColorByType(receivedInfoList[i].notOpend,receivedInfoList[i].TRADE);

			Data[2].TextColor = tmpColor;
			Data[3].TextColor = tmpColor;
			Data[4].TextColor = tmpColor;

			if(receivedInfoList[i].sentBySystem == 1 && receivedInfoList[i].returnd == 1)
			{				
				Data[2].szData = "[" $ GetSystemString(2090)$ "]" @ GetSystemString(2073);
			}
			else if(receivedInfoList[i].sentBySystem == 1 && receivedInfoList[i].returnd == 0)
			{
				Data[2].szData = GetSystemString(2211);
			}
			else
			{
				Data[2].szData = receivedInfoList[i].senderName;
			}
			Data[3].szData = receivedInfoList[i].title;
			Data[4].szData = ConvertTimeToString(receivedInfoList[i].diffTime);
			for(j = 0; j < 5; j++)
			{
				Record.LVDataList[j] = Data[j];
			}
			ReceivedPostList.InsertRecord(Record);
		}
	}
	// End:0x8E8
	if(exceptionCheckBoxRefresh == false)
	{
		ViewReceivedCheckBox(Page);
	}
	ShowReceiveListNumber();
}

function ShowSentList(int Page, optional bool exceptionCheckBoxRefresh)
{
	local int i, j;
	local LVData Data[5];
	local LVDataRecord Record;
	local int start, end;
	local Color tmpColor;

	ReceivedPostList.hidewindow();
	SentPostList.showwindow();
	SentPostList.DeleteAllItem();
	if(Page >= 0 && Page < SentPageNum)
	{
		if(Page == SentPageNum - 1)
		{
			start = Page  * MAIL_PER_PAGE;
			end =  start + (sentInfoList.Length % MAIL_PER_PAGE);
			if(sentInfoList.Length % MAIL_PER_PAGE == 0)
			{
				end += MAIL_PER_PAGE;
			}
		}
		else
		{
			start = Page * MAIL_PER_PAGE;
			end =  start + MAIL_PER_PAGE;
		}
		Record.LVDataList.Length = 5;

		for(i = start; i < end; i++)
		{
		//	Data[0].buseTextureColor = true;

			Data[0].szData = "";
			Data[0].nReserved1 = sentInfoList[i].mailID; //mailID �Ѱ���

			Data[1].nTextureWidth = 18;
			Data[1].nTextureHeight = 12;
			
			//branch110706 �ΰ��Ӽ� ���� �������߰�
			if(sentInfoList[i].sentBySystem == 7) // �ΰ��Ӽ� ������
			{	
				Data[1].szData="";
				Data[1].szTexture = "BranchSys3.Icon.primeshop_gift";					
			}
			//end of branch
			else if(sentInfoList[i].Trade == 1 && sentInfoList[i].withItem == 1)
			{
				Data[1].szData="";
				Data[1].szTexture = "L2UI_CT1.PostWnd_DF_Icon_SafetyTrade_Accompany";
			}
			else if(sentInfoList[i].Trade == 1&& sentInfoList[i].withItem == 0)
			{
				Data[1].szData="";
				Data[1].szTexture = "L2UI_CT1.PostWnd_DF_Icon_SafetyTrade";
			}
			else if(sentInfoList[i].Trade == 0 && sentInfoList[i].withItem == 1)
			{
				Data[1].szData="";
				Data[1].szTexture = "L2UI_CT1.PostWnd_DF_Icon_Accompany";
			}		
			else
			{
				Data[1].szData="";
				Data[1].szTexture = "L2UI_CT1.Misc_DF_Blank";
			}
			/*
			if(sentInfoList[i].notOpend == 0)
			{
				Data[2].buseTextColor = True;
				Data[3].buseTextColor = True;
				Data[4].buseTextColor = True;
				Data[2].TextColor = readPostColor;
				Data[3].TextColor = readPostColor;
				Data[4].TextColor = readPostColor;
			}
			*/
			Data[2].bUseTextColor = True;
			Data[3].bUseTextColor = True;
			Data[4].bUseTextColor = True;

			tmpColor = GetTextColorByType(sentInfoList[i].notOpend,sentInfoList[i].TRADE);

			Data[2].TextColor = tmpColor;
			Data[3].TextColor = tmpColor;
			Data[4].TextColor = tmpColor;
			Data[2].szData = sentInfoList[i].ReceiverName;
			Data[3].szData = sentInfoList[i].title;
			Data[4].szData = ConvertTimeToString(sentInfoList[i].diffTime);
			for(j =0; j < 5; j++)
			{
				Record.LVDataList[j] = Data[j];
			}
			SentPostList.InsertRecord(Record);
		}
	}
	// End:0x489
	if(exceptionCheckBoxRefresh == false)
	{
		ViewSentCheckBox(Page);
	}
	ShowSendListNumber();
}
function bool GetReceivedSelectedListCtrlItem(out LVDataRecord record)
{
	local int index;
	index = ReceivedPostList.GetSelectedIndex();
	if(index >= 0)
	{
//		if(receivedInfoList[index].withItem == 1 && ZoneType != 12)
//			return false;

		ReceivedPostList.GetRec(index, record);
		return true;
	}
	return false;
}

function bool GetSentSelectedListCtrlItem(out LVDataRecord record)
{
	local int index;
	index = SentPostList.GetSelectedIndex();
	if(index >= 0)
	{
		SentPostList.GetRec(index, record);
		return true;
	}
	return false;
}


function OnDBClickListCtrlRecord(string ListCtrlID)
{
//	local ClanDrawerWnd script;
	local LVDataRecord record;

	record.LVDataList.Length = 5;

	if(ListCtrlID == "ReceivePostList")
	{
	
		if(GetReceivedSelectedListCtrlItem(record))
		{
			if(record.LVDataList[0].nReserved2 == 1)		//���� �����ŷ����
			{
				DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
				DialogSetReservedInt(record.LVDataList[0].nReserved1); //������̵� �Ѱ���
				if(Record.LVDataList[0].nReserved3 == 1)
					DialogShow(DialogModalType_Modalless,DialogType_OKCancel,GetSystemMessage(13193),string(self));
				else
					DialogShow(DialogModalType_Modalless,DialogType_OKCancel,GetSystemMessage(3087),string(self));
				DialogSetID(DIALOG_CONFIRM_TRADE_POST);
			}
			else		//�׷����ʴٸ� �ٷ�ȣ��
			{
				RequestRequestReceivedPost(record.LVDataList[0].nReserved1); //������ ������ ���Ͼ��̵�� ȣ��
			}
			
		}		
	}
	else if(ListCtrlID == "SendPostList")
	{
		if(GetSentSelectedListCtrlItem(record))
		{
			RequestRequestSentPost(record.LVDataList[0].nReserved1); //������ ������ ���Ͼ��̵�� ȣ��
		}
	}
}

function ClearReceivedInfo()
{
	local int i;
	receivedInfoList.length = 0;
	curReceivedPage = 0;
	ReceivePostCheck_all.SetCheck(false);
	for(i = 0; i < MAIL_PER_PAGE; i++)
	{
		ReceivePostCheck[i].SetCheck(false);
	}
	for(i = 0; i < MAX_PAGE_NUM; i++)
	{
		ReceivedPageFullCheckState[i] = 0; 
	}

}
function ClearSentInfo()
{
	local int i;

	sentInfoList.Length = 0;
	curSentPage = 0;

	SendPostCheck_all.SetCheck(false);
	for(i = 0; i < MAIL_PER_PAGE; i++)
	{
		SendPostCheck[i].SetCheck(false);
	}

	for(i = 0; i < MAX_PAGE_NUM; i++)
	{
		SentPageFullCheckState[i] = 0; 
	}

}

function SetReceivedCheckBox(int curPage, String strID)
{
	local int checkboxid;
	local int infoindex;
	local bool disCheck;

	checkboxid = int(Right(strID,1));

	infoindex = curPage * MAIL_PER_PAGE + checkboxid;
//	ViewReceivedCheckBox(curPage);	//���� �������� üũ�ڽ� ���� �ʱ⼳��
	//���� üũ�ϰ� ���� üũ�ڽ� ����
	if(ReceivePostCheck[checkboxid].IsChecked()) // üũ�� ���¶��
	{
		receivedInfoList[infoindex].CheckBoxState = 1;		
	}
	else
	{
		receivedInfoList[infoindex].CheckBoxState = 0;
		disCheck = true;
	}
	ViewReceivedCheckBox(curPage);


	Debug("disCheck" @ disCheck);

	if(disCheck)
	{
		ReceivePostCheck_all.SetCheck(false);
		ReceivedPageFullCheckState[curPage] = 0;
	}
}
function SetSentCheckBox(int curPage, String strID)
{
	local int checkboxid;
	local int infoindex;
	local bool disCheck;

	checkboxid = int(Right(strID, 1));

	infoindex = curPage * MAIL_PER_PAGE + checkboxid;
//	ViewSentCheckBox(curPage);	//���� �������� üũ�ڽ� ���� �ʱ⼳��
	//���� üũ�ϰ� ���� üũ�ڽ� ����
	if(SendPostCheck[checkboxid].IsChecked()) // üũ�� ���¶��
	{
		sentInfoList[infoindex].CheckBoxState = 1;		
	}
	else
	{
		sentInfoList[infoindex].CheckBoxState = 0;
		disCheck = true;
	}
	ViewSentCheckBox(curPage);

	if(disCheck)
	{
		SendPostCheck_all.SetCheck(false);
		SentPageFullCheckState[curPage] = 0;
	}
}

function ViewReceivedCheckBox(int curPage)
{
	local int i;
	local int j;
	local int diableBoxCount;
	local int start,end;

	j = 0;
	diableBoxCount  = 0;
	
	start = curPage * MAIL_PER_PAGE;
	end =(curPage + 1)* MAIL_PER_PAGE;

	
	for(i = 0; i < MAIL_PER_PAGE; i++)
	{
		ReceivePostCheck[i].HideWindow();
	}

	if(end > receivedInfoList.Length)
	{
		diableBoxCount = end - receivedInfoList.Length;
		end = receivedInfoList.Length;
	}


	for(i = start; i < end; i++)
	{
		if(receivedInfoList[i].withItem == 0 && receivedInfoList[i].notOpend == 0)		//�������� ���� �ѹ��̻� ��� ���� 
		{
			ReceivePostCheck[j].ShowWindow();	

			if(receivedInfoList[i].CheckBoxState == 1)
			{
				ReceivePostCheck[j].setCheck(true);
			}
			else
			{
				ReceivePostCheck[j].setCheck(false);
			}
		}		
		j++;
	}
	if(ReceivedPageFullCheckState[curPage] == 1)
	{
		ReceivePostCheck_all.setcheck(true);
	}
	else
	{
		ReceivePostCheck_all.setcheck(false);
	}
}

function ViewSentCheckBox(int curPage)
{
	local int i;
	local int j;
	local int diableBoxCount;
	local int start,end;

	j = 0;
	diableBoxCount  = 0;	
	start = curPage * MAIL_PER_PAGE;
	end =(curPage + 1)* MAIL_PER_PAGE;
	

	
	for(i = 0; i < MAIL_PER_PAGE; i++)
	{
		SendPostCheck[i].HideWindow();
	}

	if(end > sentInfoList.Length)
	{
		diableBoxCount = end - sentInfoList.Length;
		end = sentInfoList.Length;
	}

	for(i = start; i < end; i++)
	{
		if(sentInfoList[i].withItem == 0)		// �ѹ��̻� ��� ����
		{
			SendPostCheck[j].ShowWindow();	

			if(sentInfoList[i].CheckBoxState == 1)
			{
				SendPostCheck[j].setCheck(true);
			}
			else
			{
				SendPostCheck[j].setCheck(false);
			}
		}		
		j++;
	}

	if(SentPageFullCheckState[curPage] == 1)
	{
		sendPostCheck_all.setcheck(true);
	}
	else
	{
		sendPostCheck_all.setcheck(false);
	}
}

function OnClickCheckBox(String strID)
{
	if(strID == "ReceivePostCheck_all")
	{
		SetAllReceivedCheckBox(curReceivedPage);
	}
	else if(strID == "SendPostCheck_all")
	{
		SetAllSentCheckBox(curSentPage);
	}
	else if(InStr(strID, "ReceivePostCheck_")> - 1)
	{
		SetReceivedCheckBox(curReceivedPage, strID);
	}
	else if(InStr(strID, "SendPostCheck_")> - 1)
	{
		SetSentCheckBox(curSentPage, strID);
	}

}

function SetAllReceivedCheckBox(int curpage)
{
	local int i;
	local int j;
	local int diableBoxCount;
	local int start,end;

	j = 0;
	diableBoxCount = 0;
	start = curPage * MAIL_PER_PAGE;
	end =(curPage + 1)* MAIL_PER_PAGE;

	

	if(end > receivedInfoList.Length)
	{
		diableBoxCount = end - receivedInfoList.Length;
		end = receivedInfoList.Length;
	}

	
	if(ReceivePostCheck_all.IsChecked()) // üũ�� ���¶��
	{
		ReceivedPageFullCheckState[curPage] = 1;
	}
	else
	{
		ReceivedPageFullCheckState[curPage] = 0;
	}

	for(i = start; i < end; i++)
	{
		if(receivedInfoList[i].withItem == 0 && receivedInfoList[i].notOpend == 0)		// �������� ������
		{

			if(ReceivePostCheck_all.IsChecked())
			{
				receivedInfoList[i].CheckBoxState = 1;
		//		ReceivePostCheck_all.setCheck(false);
			}
			else
			{
				receivedInfoList[i].CheckBoxState = 0;
		//		ReceivePostCheck_all.setCheck(true);
			}
		}
		j++;
	}
	ViewReceivedCheckBox(curpage);

}

function SetAllSentCheckBox(int curpage)
{
	local int i;
	local int j;
	local int diableBoxCount;
	local int start,end;

	j = 0;
	diableBoxCount  = 0;	
	start = curPage * MAIL_PER_PAGE;
	end =(curPage + 1)* MAIL_PER_PAGE;
	

	if(end > sentInfoList.Length)
	{
		diableBoxCount = end - sentInfoList.Length;
		end = sentInfoList.Length;
	}


	if(SendPostCheck_all.IsChecked()) // üũ�� ���¶��
	{
		SentPageFullCheckState[curPage] = 1;
	}
	else
	{
		SentPageFullCheckState[curPage] = 0;
	}

	for(i = start; i < end; i++)
	{
		if(sentInfoList[i].withItem == 0)		// �������� ������
		{
			if(SendPostCheck_all.IsChecked())
			{
				sentInfoList[i].CheckBoxState = 1;
			}
			else
			{
				sentInfoList[i].CheckBoxState = 0;
			}
		}
		j++;
	}
	ViewSentCheckBox(curpage);
}


/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_WindowName="PostBoxWnd"
}
