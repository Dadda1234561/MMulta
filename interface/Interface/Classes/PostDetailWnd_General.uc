class PostDetailWnd_General extends UICommonAPI;


var WindowHandle Me;
var WindowHandle SafetyTrade;

var TextboxHandle Title_SenderID;
var TextboxHandle SenderID;
var TextboxHandle PostType;
var TextboxHandle PostTitle;
var TextListBoxHandle PostContents;  
var TextboxHandle WeightText;
var TextBoxHandle Wintitle_tex;

var ButtonHandle SendCancelBtn;
var ButtonHandle ReceiveBtn;
var ButtonHandle ReturnBtn;
var ButtonHandle ReplyBtn;
//���� ����(10.03.19)
var ButtonHandle AddBtn;

var ItemWindowHandle AccompanyItem;

var int trade;		//�����ŷ�, �Ϲݿ���
var int returnd;	//�ݼۿ���
var int mailID;
var int totalWeight;//��  ����
var int returnable, sentbysystem;

//var int IsPeaceZone;

const DIALOG_RETURN_POST = 1111;
//branch110706 �ΰ��Ӽ�
const DIALOG_NOTIFY_SEND_CANCLE_PRIMESHOP = 2222;
//end of branch

function OnRegisterEvent()
{
	registerEvent(EV_ReplyReceivedPostStart); 
	registerEvent(EV_ReplyReceivedPostAddItem);
	registerEvent(EV_ReplyReceivedPostEnd);

	registerEvent(EV_ReplySentPostStart); 
	registerEvent(EV_ReplySentPostAddItem);
	registerEvent(EV_ReplySentPostEnd);
	registerEvent(EV_DialogOK);
}

function OnLoad()
{	
	SetClosingOnESC();

	InitializeCOD();

	Me.HideWindow();

//	ResetUI();
	totalWeight = 0;
}

function OnShow()
{
	local Rect rectMov;

	if(SafetyTrade.IsShowWindow())
	{
		rectMov = SafetyTrade.GetRect();
		Me.MoveTo(rectMov.nX, rectMov.nY);
		SafetyTrade.HideWindow();
	}
}

function InitializeCOD()
{
	Me = GetWindowHandle("PostDetailWnd_General.PostDetailWnd_General");
	SafetyTrade = GetWindowHandle("PostDetailWnd_SafetyTrade");
	Title_SenderID = GetTextBoxHandle("PostDetailWnd_General.Title_SenderID");
	SenderID = GetTextBoxHandle("PostDetailWnd_General.SenderID");
	PostType = GetTextBoxHandle("PostDetailWnd_General.PostType");
	PostTitle = GetTextBoxHandle("PostDetailWnd_General.PostTitle");
	PostContents = GetTextListBoxHandle("PostDetailWnd_General.PostContents");
	WeightText = GetTextBoxHandle("PostDetailWnd_General.WeightText");
	SendCancelBtn = GetButtonHandle("PostDetailWnd_General.SendCancelBtn");
	ReceiveBtn = GetButtonHandle("PostDetailWnd_General.ReceiveBtn");
	ReturnBtn = GetButtonHandle("PostDetailWnd_General.ReternBtn");
	ReplyBtn = GetButtonHandle("PostDetailWnd_General.ReplyBtn");
	AddBtn = GetButtonHandle("PostDetailWnd_General.AddBtn");
	AccompanyItem = GetItemWindowHandle("PostDetailWnd_General.AccompanyItem");
	Wintitle_tex = GetTextBoxHandle("PostDetailWnd_General.Wintitle_tex");
}


function OnEvent(int Event_ID, String Param)
{
	switch(Event_ID)
	{
	case EV_ReplyReceivedPostStart:
		OnEVReplyReceivedPostStart(Param);
		break;
	case EV_ReplyReceivedPostAddItem:
		OnEVReplyReceivedPostAddItem(Param);
		break;
	case EV_ReplyReceivedPostEnd:
		OnEVReplyReceivedPostEnd(Param);
		break;
	case EV_ReplySentPostStart:
		OnEVReplySentPostStart(Param);
		break;
	case EV_ReplySentPostAddItem:
		OnEVReplySentPostAddItem(Param);
		break;
	case EV_ReplySentPostEnd:
		OnEVReplySentPostEnd(Param);
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	}
}


function OnEVReplyReceivedPostStart(String Param)
{
	ClearAll();
	ParseInt(param, "trade", trade);
	ParseInt(param, "Returnd", returnd);  // �ݼ۵� �����ΰ�(1), �ƴѰ�(0)	

	if(returnd == 1 || trade == 0)//�ݼ۵Ȱ���̰ų�, �Ϲݿ����ϰ��
	{
		if(returnd == 1)
			Wintitle_tex.SetText("[" $ GetSystemString(2090)$ "]" @ GetSystemString(2075));
		else
			Wintitle_tex.SetText(GetSystemString(2075)@ "-" @ GetSystemString(2071));

		ReceiveBtn.HideWindow();
		ReturnBtn.ShowWindow();
		SendCancelBtn.HideWindow();
//		ReturnBtn.ShowWindow();			//���� �Ȱ��Ƽ� ����.

		Me.ShowWindow();
		Me.SetFocus();
	}

	totalWeight =0;
	
}

function OnEVReplyReceivedPostAddItem(String Param)
{
	local ItemInfo info;

	if(returnd == 1 || trade == 0)//�Ϲݿ����̸�
	{
		ParamToItemInfo(param, info);
		AccompanyItem.AddItem(info);

		totalWeight += info.Weight * int(info.ItemNum);
	}
}

function string addComma(bool bComma, string Text)
{
	// End:0x15
	if(bComma)
	{
		return ", " $ Text;
	}
	return Text;
}

function OnEVReplyReceivedPostEnd(String Param)
{
	local string SenderName, title, contents;
	local INT64 tradeMoney;
	local string fixedtitle;
	local int SendId, contentSystemMsgID, classID, enchant;
	local string NPCName;
	local int titleSystemMsgId;

	local int valueFire, valueWater, 
			  valueWind, valueEarth, 
			  valueHoly, valueUnholy;
	
	local bool isAttribute; // �Ӽ��� �Ѱ��� �ֳ� 

	local string attStr;

	local ItemID   cItemID;
	local ItemInfo cItemInfo;

	Title_SenderID.SetText(GetSystemString(2078));
	
	if(returnd == 1 || trade == 0)
	{
		ParseInt(param,    "MailID", mailID);  
		ParseString(param, "SenderName"         , SenderName);	        // ���� ���
		ParseInt(param   , "SenderId"           , SendId);	            // ���� ��� ID
		ParseString(param, "Title"              , title);			    // ����
		ParseInt(param   , "TitleSystemMsgId"   , titleSystemMsgId);    // ����ID
		ParseString(param, "Content"            , contents);		    // ����
		ParseInt(param   , "ContentSystemMsgID" , contentSystemMsgID);  // ����ID
		ParseInt(param   , "ClassID"            , classID);             // �������� Ŭ����ID
		ParseInt(param   , "Enchant"            , enchant);             // �������� ��æƮ �� 
		  
		ParseINT64(param, "TradeMoney", tradeMoney);    // û�����
		ParseInt(param, "ReturnAble"  , returnable);    // ����Ҽ��ֳ�(1), ����(0)
		ParseInt(param, "Sentbysystem", sentbysystem);  // �ý����� ���������ΰ�(1), �ƴѰ�(0)
		
		ParseInt(param, "attrFire"  , valueFire);  // �Ӽ�(��, ��, �ٶ�, ��, �ż�, ����)
		ParseInt(param, "attrWater" , valueWater);
		ParseInt(param, "attrWind"  , valueWind);
		ParseInt(param, "attrEarth" , valueEarth);
		ParseInt(param, "attrHoly"  , valueHoly);
		ParseInt(param, "attrUnholy", valueUnholy);

		// "�Ϲݿ���" -> 2071 
		if(sentbysystem == 7)//��������
		{
			PostType.SetText(GetSystemString(5080));
		}
		else
		{
			PostType.SetText(GetSystemString(2071)); //�Ϲݿ���
		}
		
		////////////////////////
		// -- ���� ��� --
		////////////////////////
		// �Ǹ� ����(4,5)�� ��� 
		// 4: �Ⱓ�� ����Ǽ� ���ƿ�����..
		// 5: �ȷȴٴ� ������ �ö�..
		if(sentbysystem == 4 || sentbysystem == 5)
		{
			// ����Ͻ� ��ǰ�� ��� �Ⱓ�� ����Ǿ����ϴ�. -> 3492
			// ����Ͻ� ��ǰ�� �ǸŵǾ����ϴ�. -> 3490
			title = GetSystemMessage(titleSystemMsgId);
		}

		// debug("post:" @ Param);
		
		// �ʹ� ������ ��� ������ ...
		fixedtitle = DivideStringWithWidth(title, 380);
		if(fixedtitle != title)
		{
			fixedtitle =  fixedtitle $ "...";
		}
		
		PostTitle.SetText(fixedtitle);

		// Debug("::" @contents);
		
		isAttribute = false;

		////////////////////////
		// -- ���� ��� --
		////////////////////////
		// �Ǹ� ����(4,5)�� ��� 
		// 4: �Ⱓ�� ����Ǽ� ���ƿ�����..
		// 5: �ȷȴٴ� ������ �ö�..
		if(sentbysystem == 4)
		{
			// ����Ͻ� ��ǰ�� ��� �Ⱓ�� ����Ǿ����ϴ�. 
			contents = GetSystemMessage(contentSystemMsgID);
		}
		else if(sentbysystem == 5)
		{
			// ������ ���� ��� 
			cItemID.ClassID = classID; 
			class'UIDATA_ITEM'.static.GetItemInfo(cItemID, cItemInfo);

			if(cItemInfo.ItemType == EItemType.ITEM_WEAPON)
			{
				// Debug("����" @ cItemInfo.ItemType);
				
				// ��æƮ ��ġ +
				if(enchant > 0)contents = "+" $ string(enchant)$ " " $ contents;
				
				// 1596 �Ӽ�  -> "(�Ӽ�: " ���Ĵ� �Ʒ� ���ǿ� ����..
				contents = contents $ "(" $ GetSystemString(1596)$ ": ";
				// Debug("::" @contents);

				if(valueFire > 0)
				{
					attStr = attStr $ addComma(isAttribute, GetSystemString(1622)$ valueFire);
					//attStr = attStr $ GetSystemString(1622)$ valueFire $ " ";					
					isAttribute = true;
				}
				if(valueWater > 0)
				{					
					attStr = attStr $  addComma(isAttribute, GetSystemString(1623)$ valueWater);
					isAttribute = true;
				}
				if(valueWind > 0)
				{
					attStr = attStr $ addComma(isAttribute, GetSystemString(1624)$ valueWind);
					isAttribute = true;
				}
				if(valueEarth > 0)
				{
					attStr = attStr $ addComma(isAttribute, GetSystemString(1625)$ valueEarth);
					isAttribute = true;
				}
				if(valueHoly > 0)
				{
					attStr = attStr $ addComma(isAttribute, GetSystemString(1626)$ valueHoly);
					isAttribute = true;
				}
				if(valueUnholy > 0)
				{
					attStr = attStr $  addComma(isAttribute, GetSystemString(1627)$ valueUnholy);
					isAttribute = true;
				}

				// �Ӽ��� ���� ��� 
				if(valueFire + valueWater + valueWind + valueEarth + valueHoly + valueUnholy <= 0)
				{
					//(�Ӽ�: ����),GetSystemString(27)= "����"
					attStr = attStr $ GetSystemString(27);
				}

				contents = contents $ attStr $ ")";

				// .. �� �ǸŵǾ����ϴ�.
				contents = MakeFullSystemMsg(GetSystemMessage(contentSystemMsgID), contents);
				// Debug("::" @contents);
			}
			else if(cItemInfo.ItemType == EItemType.ITEM_ARMOR)
			{
				// Debug("��  " @ contents);
				// ��æƮ ��ġ +
				if(enchant > 0)contents = "+" $ string(enchant)$ " " $ contents;

				// 1596 �Ӽ�  -> "(�Ӽ�: " ���Ĵ� �Ʒ� ���ǿ� ����..
				contents = contents $ "(" $ GetSystemString(1596)$ ": ";
				// Debug("::" @contents);

				// ���� �Ӽ��� ���� ��� , �ݴ� �Ӽ� ��Ʈ���� ����̶�� ������.. ������ ���� �״�� ��� ���൵ �ɵ�..				
				if(valueFire > 0)
				{
					attStr = attStr $ addComma(isAttribute, MakeFullSystemMsg(GetSystemMessage(2215), GetSystemString(1622)$ " ")$ valueFire);
					isAttribute = true;
				}
				if(valueWater > 0)
				{
					attStr = attStr $ addComma(isAttribute, MakeFullSystemMsg(GetSystemMessage(2215), GetSystemString(1623)$ " ")$ valueWater);
					isAttribute = true;
				}
				if(valueWind > 0)
				{
					attStr = attStr $ addComma(isAttribute, MakeFullSystemMsg(GetSystemMessage(2215), GetSystemString(1624)$ " ")$ valueWind);
					isAttribute = true;
				}
				if(valueEarth > 0)
				{
					attStr = attStr $ addComma(isAttribute, MakeFullSystemMsg(GetSystemMessage(2215), GetSystemString(1625)$ " ")$ valueEarth);
					isAttribute = true;
				}
				if(valueHoly > 0)
				{
					attStr = attStr $ addComma(isAttribute, MakeFullSystemMsg(GetSystemMessage(2215), GetSystemString(1626)$ " ")$ valueHoly);
					isAttribute = true;
				}
				if(valueUnholy > 0)
				{
					attStr = attStr $ addComma(isAttribute, MakeFullSystemMsg(GetSystemMessage(2215), GetSystemString(1627)$ " ")$ valueUnholy);
					isAttribute = true;
				}

				// �Ӽ��� ���� ��� 
				if(valueFire + valueWater + valueWind + valueEarth + valueHoly + valueUnholy <= 0)
				{
					//(�Ӽ�: ����),GetSystemString(27)= "����"
					attStr = attStr $ GetSystemString(27);
				}

				contents = contents $ attStr $ ")";

				// Debug(attStr);
				// .. �� �ǸŵǾ����ϴ�.
				
				contents = MakeFullSystemMsg(GetSystemMessage(contentSystemMsgID), contents);
				// Debug("::" @contents);
			}
			else
			{
				// Debug("�Ϲ� " @ contents);
				contents = MakeFullSystemMsg(GetSystemMessage(contentSystemMsgID), contents);		
			}
		}

		// ���� ���� 
		PostContents.AddString(contents,GetChatColorByType(0));
		// �ؽ�Ʈ ����Ʈ �ڽ�, ��ũ�� ���� ���� �ʱ�ȭ 
		PostContents.SetTextListBoxScrollPosition(0);

		if(AccompanyItem.GetItemNum()!= 0)
		{
			// End:0x930
			if(! ReceiveBtn.IsShowWindow())
			{
				ReceiveBtn.ShowWindow();
			}
		}

		if(returnable == 1)
		{
			if(ReceiveBtn.IsShowWindow())
			{
				ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomRight", -1, -4);
			}
			ReturnBtn.ShowWindow();
		}
		else
		{
			if(ReceiveBtn.IsShowWindow())
			{
				ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomCenter", 0, -4);
			}

			ReturnBtn.HideWindow();
		}

		// Debug("sentbysystem" @ sentbysystem);

		//#ifndef CT26P2_0825
		//		if(sentbysystem == 1)//�ý����� ���������̸�
		//		{
		//			if(returnd == 1)
		//				SenderID.SetText(GetSystemString(2073));
		//			else
		//				SenderID.SetText(GetSystemString(2211));
		//
		//			if(ReceiveBtn.IsShowwindow())
		//			{
		//				ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomCenter", 0, -4);
		//			}
		//			ReturnBtn.HideWindow();
		//		}
		//		else
		//		{
		//			SenderID.SetText(SenderName);
		//		}
		//
		//		if(sentbysystem == 1)
		//		{
		//			ReplyBtn.HideWindow();
		//		}
		//		else
		//		{
		//			ReplyBtn.EnableWindow();
		//			ReplyBtn.ShowWindow();
		//		}
		//#endif 
		//#ifdef CT26P2_0825
		
		//************************************************************
		//*  ���� �߽��� ���� ó�� 
		//************************************************************
		
		// 1: �ý����� ���� ����
		if(sentbysystem == 1)
		{
			if(returnd == 1)
				SenderID.SetText("[" $ GetSystemString(2090)$ "]" @ GetSystemString(2073));
			else
				SenderID.SetText(GetSystemString(2211));			
		}
		// NPC ���� �°��
		else if(sentbysystem ==2)	
		{
			NPCName=class'UIDATA_NPC'.static.GetNPCName(SendId);
			if(Len(NPCName)>0)
				SenderID.SetText(NPCName);
		}
		// �˷��׸���
		else if(sentbysystem == 3)
		{
			SenderID.SetText(GetSystemString(2316)); 
		}
		// �ǸŴ��� 4���� ������� ��ǰ, 5���� �ǸŵǾ�����
		else if(sentbysystem == 4 || sentbysystem == 5)
		{
			SenderID.SetText(GetSystemString(class'consignmentSaleAPI'.static.GetCommissionSellerID()));
		}
		// ���丵���� ����ϴ� ��ȣ 
		else if(sentbysystem == 6)
		{			
			SendId = class'UIDATA_NPC'.static.GetMentoringNPCId();
			if(SendId > 0)
			{
				NPCName = class'UIDATA_NPC'.static.GetNPCName(SendId);
				if(Len(NPCName)>0)
					SenderID.SetText(NPCName);
			}
			else 
			{
				Debug("Error : 'SendId' is wrong" @ SendId);
			}

		}
		// �Ϲ� ���� �� ��� 
		else
		{
			SenderID.SetText(SenderName);
		}

		// �����, ��ư�� ���� , ���� ó�� 
		if(sentbysystem == 1 || sentbysystem == 3 || sentbysystem == 5 || sentbysystem == 6)// 3: BirthDay Mail , 5�� �ǸŴ���, 6�� ���丵
		{
			if(ReceiveBtn.IsShowWindow())
			{
				ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomCenter", 0, -4);
			}
			ReturnBtn.HideWindow();
			ReplyBtn.HideWindow();
		}
		else
		{
			ReplyBtn.EnableWindow();
			ReplyBtn.ShowWindow();
		}
		
		if(AccompanyItem.GetItemNum()== 0)
		{
			// End:0xD16
			if(ReceiveBtn.IsShowWindow())
			{
				ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomCenter", 0, -4);
			}
			ReturnBtn.HideWindow();
		}
		
		if(sentbysystem == 9)
		{
			AddBtn.DisableWindow();
		}
		else
		{
			AddBtn.EnableWindow();
		}

		WeightText.SetText(string(totalWeight));
	}
}

function OnEVReplySentPostStart(String Param)
{
	ClearAll();
	ParseInt(param, "trade", trade);
	ParseInt(param, "Sentbysystem", sentbysystem);
	if(trade == 0)//�Ϲݿ����̸�
	{
		Wintitle_tex.SetText(GetSystemString(2076)@ "-" @ GetSystemString(2071));
		ReceiveBtn.Hidewindow();
		ReturnBtn.HideWindow();
		SendCancelBtn.ShowWindow();
		ReplyBtn.HideWindow();
		//ReturnBtn.Showwindow();
		Me.ShowWindow();
		Me.SetFocus();
	}
	if(sentbysystem == 7)//�ΰ��Ӽ� �����ϱ�� �޴����߰��� ������
	{
		AddBtn.HideWindow();
	}
	else
	{
		AddBtn.Showwindow();
	}
}

function OnEVReplySentPostAddItem(String Param)
{
	local ItemInfo info;
	
	if(trade == 0)//�Ϲݿ����̸�
	{
		ParamToItemInfo(param, info);
		AccompanyItem.AddItem(info);

		Debug("OnEVReplySentPostAddItem" @ Param);
	}
}

function OnEVReplySentPostEnd(string Param)
{
	local string ReceiverName, title, contents;
	local INT64 tradeMoney;
	local int notOpend;
	local string fixedtitle;

	ParseInt(param, "Sentbysystem", sentbysystem);  // �ý����� ���������ΰ�(1), �ƴѰ�(0)
	
	if(trade == 0)
	{
		ParseInt(param, "MailID", mailID);				// ���� ���̵�
		ParseString(param, "ReceiverName", ReceiverName);	// ���� ���
		ParseString(param, "Title", title);				// ����
		ParseString(param, "Content", contents);		// ����
		ParseINT64(param, "TradeMoney", tradeMoney);	// û�����
		ParseInt(param, "NotOpend", notOpend);  // ����Ҽ��ֳ�(1), ����(0)
		ParseInt(param, "Sentbysystem", sentbysystem);  // �ý����� ���������ΰ�(1), �ƴѰ�(0)

		if(sentbysystem == 7)//��������
		{
			PostType.SetText(GetSystemString(5080));
		}
		else
		{
			PostType.SetText(GetSystemString(2071)); //�Ϲݿ���
		}
		
		fixedtitle = DivideStringWithWidth(title, 380);
		if(fixedtitle != title)
		{
			fixedtitle = fixedtitle $ "...";
		}
		PostTitle.SetText(fixedtitle);


		Title_SenderID.SetText(GetSystemString(2087));
		PostContents.AddString(contents, GetChatColorByType(0));
		PostContents.SetTextListBoxScrollPosition(0);
		SenderID.SetText(ReceiverName);
		// End:0x1F1
		if(AccompanyItem.GetItemNum()!= 0)
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
	PostType.SetText(GetSystemString(2071));
	PostTitle.SetText("");
	PostContents.Clear();
	WeightText.SetText("0");
	ReceiveBtn.HideWindow();
	ReturnBtn.HideWindow();
	SendCancelBtn.HideWindow();
	AccompanyItem.Clear();

}

function OnClickButton(string a_ButtonID)
{
	switch(a_ButtonID)
	{
		// End:0x33
		case "ReceiveBtn":
			RequestReceivePost(mailID);
			Me.HideWindow();
			// End:0x126
			break;
		// End:0x92
		case "ReternBtn":
			if(returnd == 1 || trade == 0 && returnable == 1)
			{
				DialogHide();
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(3063), string(Self));
				DialogSetID(DIALOG_RETURN_POST);
			}
			// End:0x126
			break;
		// End:0xF9
		case "SendCancelBtn":
			//branch110706 �ΰ��Ӽ�
			if(sentbysystem == 7)// �ΰ��Ӽ����� �� ������ ����Ҷ�
			{
				DialogHide();
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(6066), string(Self));
				DialogSetID(DIALOG_NOTIFY_SEND_CANCLE_PRIMESHOP);
			}
			else
			{
				RequestCancelSentPost(mailID);
				Me.HideWindow();
			}
			// End:0x126
			break;
		// End:0x10F
		case "ReplyBtn":
			HandleReplyBtn();
			// End:0x126
			break;
		// End:0x123
		case "AddBtn":
			HandleAddBtn();
			// End:0x126
			break;
	}
}
function HandleDialogOK()
{
	local int id;
	if(DialogIsMine())
	{
		id = DialogGetID();

	
		if(id == DIALOG_RETURN_POST)
		{
			RequestRejectPost(mailID);
			Me.HideWindow();
		}
		//branch110706 �ΰ��Ӽ�
		else if(id == DIALOG_NOTIFY_SEND_CANCLE_PRIMESHOP)
		{
			RequestCancelSentPost(mailID);
			Me.HideWindow();
		}
		//end of branch
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
//���� ����(10.03.19)
function HandleAddBtn()
{
	class'PostWndAPI'.static.RequestAddingPostFriend(SenderID.GetText());
}


/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	class'UIAPI_WINDOW'.static.HideWindow("PostDetailWnd_General");
}

defaultproperties
{
}
