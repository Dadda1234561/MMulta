// ���� ������ ��¡ �Ͽ� Html ��� �� ������ ���� ��� ����
/*
	htmlStr = htmlStr $"<br1>" $ htmlAddText("1�Ͼ߿� ������ ��¼�� ��¼��sdfsadlkfjasdflkjasdlkfjasdlkfjaslkfjasfasfsdafasdfsafasdfdasasfsadfasdfasdfsad", "hs9", "F0FF43")$ "<br1>" $
				  htmlAddText("2�Ͼ߿� ������ ��¼�� ��¼��", "hs9", "F0FF43")$ htmlUrlLinkText("��������","http://70.2.1.96/wiki/moin.cgi/clienthtml")$ 
				  htmlUrlLinkText("��������abcde","70.2.1.96/wiki/moin.cgi/clienthtml")$ 
				  "<br>test1234 <a action=\"url http://lineage2.plaync.com\"> link text</a><br>" $
				  "<br><a link=\"..\L2text\pet_help_suggest.htm\">�ڷ�</a><br>" $
				  htmlAddButton("����", "url www.naver.com", 0, 0, 15, 15)$
				  htmlAddButton("����", "url http://www.naver.com", 0, 0, 15, 15);


	//htmlStr = "<br1><font name='hs9' color='FFDF4C'>�����ϻ��</font> <font name=\"hs9\" color='00DF4C'>ũ�к�Ʈ</font>�� ���� �޾Ҵ�. ������ ���߷°� ���ݷ����� �׵��� ������ ������ �־��� Ư��, �׵��� ������ ���� �ӵ��� ������ �����ϱ� ���� �׵��� ������ �ȽĿ� ��� �ߴ�.";

	htmlStr = "<font name=\"hs9\" color=\"FFDF4C\">�����ϻ��</font>";

	DialogHide();
	DialogSetID(123456);	
	
	DialogShow(DialogModalType_Modalless,DialogType_Warning, htmlStr $ "<br>" $ htmlAddLineImg(), string(Self), 400, 300, true);
*/

/*------------------------------------------------------------------------------------------------------------------------------------------------------------
  - Ư�� ���� 
   ���α׷��ú� ���̾�α� �ڽ��� ��� ���� dialogID�� target ���� ���� ��Ű��, ���α׷��ú� ���̾�αװ� ���� ���϶� �ٸ� ���̾�α� â�� ������
   �ش� ���̾�α� �ڽ��� ĵ���� ���ִ� �κ��� �߰� �ߴ�.

	���� TTP(p4 �����丮)2014.10.2
	[qa�ʿ�]ttp66530, 66531 ��ȯ, ����, ��Ƽ�ʴ�, Ŀ�� �׼�, ��Ƽ ������ ���� ����, ���� üĿ ��ǥ�� �ش� TTP�� ������ ������ �ִ� ���� �����߽��ϴ�.
	UI, XML �� ���۵� ���̾�α� ����� UI�� ���� �ִ� ���¿��� ����ŸƮ�� �ݱ� �� �ٸ� XML ���̾�α� �ڽ��� ������ ������ �ִ� ���̾�α� �ڽ���
	������鼭, ���� �� �̶�� ���¸� ��Ұ� �ȵǴ� ���� �Դϴ�.

	���� XML�� ���۵� ����ٰ� �޸� ���̾�α� ��ü�� ���ؼ� ������ �߽��ϴ�. 
------------------------------------------------------------------------------------------------------------------------------------------------------------*/
class DialogBox extends UICommonAPI;

const INPUT_DEFAULT_MAXLENGTH = 64;


//���� ����(2010.03.03)
// 12.07.23 ��ü���� �����Ҽ� �ְ� ���� 
var int input_numberpad_maxLength; //= 14;
var WindowHandle m_dialogHandle;
var WindowHandle m_dialogBody;
var WindowHandle m_WeightPad;
var WindowHandle m_WorldExchangePad;
var WindowHandle m_NumberPad;
var ButtonHandle m_okHandle;
var ButtonHandle m_cancelHandle;
var ButtonHandle m_centerHandle;
var EditBoxHandle m_editHandle;
var TextBoxHandle m_textHandle;
var TextureHandle m_exclamationImage;
var HtmlHandle m_HtmlViewer;
var ProgressCtrlHandle m_hDialogBoxDialogProgress;
var DialogDefaultAction m_defaultAction; // Which action to take, when "Enter" key is pressed.
var DialogEnterAction m_enterAction;
var EDialogType m_type;
//var UIScript m_hostWndScript;

var string m_strTargetScript;
var string m_strEditMessage;
var int m_id;
//var bool m_bInUse;
var INT64 m_paramInt;
var int m_reservedInt;
var INT64 m_reservedInt2;
var int m_reservedInt3;
var ItemID m_reservedItemID;
var ItemInfo m_reservedItemInfo;
var string m_reservedString;
var int m_editMaxLength; // editbox�� maxLength�� ������ �ش�(��ȸ��). �� ���̾�α׸� ���� xml���� ������ �⺻���� ���ư�. -1�� �ƴ϶�� ���� ���õ� ���̴�.
var int m_editMaxLength_prev; // ���� ���̸� ����� �ֱ� ���� ����.
var int buttonWidth_prev; // ���� ��ư ���� ������
var int buttonHeight_prev; // ���� ��ư ���� ������
var int NumberPad_DefaultValue;
var int64 NumberPad_Value;

var bool m_bGlobalIME; //branch121212

// ���� ���̾�α� ������
var Rect defaultBodyRect;


// ���̾�α׿��� ĳ���� ���α׷����ٰ� �ִٸ� �ش� ID�� �����ؼ�, ok, cancel �Ҷ� �ʱ�ȭ
// ���� tryCancelDialogID�� -1 ���� ũ�ٸ� �ʱ�ȭ
var int tryCancelDialogID;
var int saveCancelDialogID;
var INT64 inputLimit;

//public
//		only public functions should be exposed to other scripts.
//		Functions in DialogBox.uc should not be used directly by other scripts. They should use them through UICommonAPI.
//
delegate DelegateOnOK()
{}

delegate DelegateOnCancel()
{}

delegate DelegateOnHide()
{}

static function DialogBox Inst()
{
	return DialogBox(GetScript("DialogBox"));
}

function SetDialogCancelD(int targetCancelDialogID)
{
	saveCancelDialogID = targetCancelDialogID;
}

// bUseHtml �� true �� �ϸ� message�� htmlViewer ������ ���� �ֵ��� ó�� �Ѵ�.
function ShowDialog(EDialogModalType modalType, EDialogType style, string message, string target, optional int widthSizeChangeValue, optional int heightSizeChangeValue, optional bool bUseHtml)
{
	local ELanguageType Language;	 //branch121212

	inputLimit = -1;
	DelegateOnOK = None;
	DelegateOnCancel = None;
	// ��ȹ�� : �̽��� 
	// OpenGivenURL(Url);	
	if(IsHardCodingSystemMessage(message))
	{
		// ��λ��� html �� ���̵��� ���� 
		bUseHtml = true;
		heightSizeChangeValue = 186;
	}

	//if(m_bInUse)
	//{
	//	debug("Error!! DialogBox in Use");
	//	return;
	//}
	if(modalType == DialogModalType_Modal)
	{
		m_dialogHandle.SetModal(true);
	}
	else if(modalType == DialogModalType_Modalless)
	{
		m_dialogHandle.SetModal(false);
	}

	if(tryCancelDialogID > -1)
	{
		HandleCancel();
	}

	// ���α׷��ú�� ���̾�α� �ڽ��� ���Ŷ��.. ����
	//if(style == DialogType_Progress)
	//{		
	//}
	
	// �̰� �ϴ� �ּ�
	if(saveCancelDialogID > -1)
	{
		tryCancelDialogID = saveCancelDialogID;
		saveCancelDialogID = -1;
	}

	//bProgressBarWorking = false;
	m_dialogHandle.ShowWindow();
	SetWindowStyle(style);

	//// HTML �̸� bUseHtml , true, �ƴϸ� �Ϲ� �ؽ�Ʈ 
	//SetMessage(message , bUseHtml);
	DelegateOnHide = None;
	m_dialogHandle.SetFocus();

	if(m_editHandle.IsShowWindow())
	{
		m_editHandle.SetString("");
		m_editHandle.SetFocus();

		if(m_editMaxLength != -1)
		{
			m_editMaxLength_prev = m_editHandle.GetMaxLength();
			m_editHandle.SetMaxLength(m_editMaxLength);
		}
		else
		{
			m_editHandle.SetMaxLength(INPUT_DEFAULT_MAXLENGTH);
		}
	}

	m_strTargetScript = target;

	if((widthSizeChangeValue == 0) && heightSizeChangeValue == 0)
	{		
	}
	else if(widthSizeChangeValue > 0 && heightSizeChangeValue > 0)
	{
		m_dialogHandle.SetWindowSize(widthSizeChangeValue, heightSizeChangeValue);
		m_dialogBody.SetWindowSize(widthSizeChangeValue, heightSizeChangeValue);
	}
	else if(widthSizeChangeValue > 0)
	{
		m_dialogHandle.SetWindowSize(widthSizeChangeValue, defaultBodyRect.nHeight);
		m_dialogBody.SetWindowSize(widthSizeChangeValue, defaultBodyRect.nHeight);
	}
	else if(heightSizeChangeValue > 0)
	{
		m_dialogHandle.SetWindowSize(defaultBodyRect.nWidth, heightSizeChangeValue);
		m_dialogBody.SetWindowSize(defaultBodyRect.nWidth, heightSizeChangeValue);
	}
	// HTML �̸� bUseHtml , true, �ƴϸ� �Ϲ� �ؽ�Ʈ 
	SetMessage(message, bUseHtml);

	//branch121212
	m_bGlobalIME = false;
	Language = GetLanguage();

	if(Language == LANG_Japanese || Language == LANG_Taiwan)
	{
		m_bGlobalIME = true;
	}
}

// ���� ĵ���� �� ���� �ִٸ�..
function bool HasPreviousCancelProcess()
{
	return tryCancelDialogID > -1;
}

function bool CheckCancelDialogID(int taregetDialogID)
{
	return tryCancelDialogID > -1 && tryCancelDialogID == taregetDialogID;
}

function CenterToOwner(optional int OffsetX, optional int OffsetY)
{
	local Rect rectWnd;
	local int dialogW, dialogH;
	local WindowHandle Owner;

	Owner = GetWindowHandle(getCurrentWindowName(GetTarget()));
	rectWnd = Owner.GetRect();
	m_dialogHandle.GetWindowSize(dialogW, dialogH);
	m_dialogHandle.ClearAnchor();
	m_dialogHandle.MoveTo((rectWnd.nX + ((rectWnd.nWidth - dialogW) / 2)) + OffsetX, (rectWnd.nY + ((rectWnd.nHeight - dialogH) / 2)) + OffsetY);
}

function AnchorToOwner(optional int OffsetX, optional int OffsetY)
{
	m_dialogHandle.SetAnchor(getCurrentWindowName(GetTarget()), "CenterCenter", "CenterCenter", OffsetX, OffsetY);
}

function HideDialog()
{
	//Debug("HideDialog");
	
	/*
	if(m_bInUse){
	//  ����Ʈ �� ����
		if(m_type == DialogType_Progress)
			DoDefaultAction();
	}
	*/	
	if(tryCancelDialogID > -1)
	{
		HandleCancel();
	}
	NumberPad_DefaultValue = 0;
	SetInputNumberpadMaxLenght(15);
	SetButtonName(1337, 1342);
	m_dialogHandle.HideWindow();
	Initialize();

	// ���̾�α� �ؽ��� ������ �ʱ�ȭ, �̹��� �ʱ�ȭ, ���� �ʱ�ȭ
	SetIconTexture("");
	m_exclamationImage.ShowWindow();
}

function SetDefaultAction(DialogDefaultAction defaultAction)
{
	//debug("DialogBox SetDefaultAction " $ defaultAction);
//	if(m_bInUse)return;
	m_defaultAction = defaultAction;
}

function SetEnterAction(DialogEnterAction enterAction)
{
	m_enterAction = enterAction;
}

function string GetTarget()
{
	//debug("Dialog::GetTarget()returns: " $ m_strTargetScript);
	return m_strTargetScript;
}

//function string GetBeforeTarget()
//{
//	//debug("Dialog::GetTarget()returns: " $ m_strTargetScript);
//	return beforeStrTargetScript;
//}

function string GetEditMessage()
{
	//debug("Dialog::GetEditMessage()returns: " $ m_strEditMessage);
	return m_strEditMessage;
}

function SetEditMessage(string strMsg)
{
	//if(m_bInUse)return;
	m_editHandle.SetString(strMsg);
}

function int GetID()
{
	return m_id;
}

function SetID(int id)
{
	//debug("DialogBox SetID " $ id);
	//if(m_bInUse)return;

	// ���� ���̾�α� ID�� ���(����� ��ҵ ����� �뵵)
	//beforeDialogID = m_id;
	m_id = id;
}

//function int GetBeforeID()
//{
//	return beforeDialogID;
//}

function SetEditType(string strType)
{
//	if(m_bInUse)return;
	m_editHandle.SetEditType(strType);
}

function SetParamInt64(INT64 param)
{
	//if(m_bInUse)return;
	m_paramInt = param;
}

function SetReservedInt(int value)
{
//	if(m_bInUse)return;
	m_reservedInt = value;
	//debug("DialogBox SetReservedInt to " $ value);
}

function SetReservedInt2(INT64 value)
{
	//if(m_bInUse)return;
	m_reservedInt2 = value;
	//debug("DialogBox SetReservedInt2 to " $ value);
}

function SetReservedInt3(int value)
{
//	if(m_bInUse)return;
	m_reservedInt3 = value;
	//debug("DialogBox SetReservedInt to " $ value);
}

function SetReservedItemID(ItemID ID)
{
	//if(m_bInUse)return;
	m_reservedItemID = ID;
}

function SetReservedItemInfo(ItemInfo info)
{
//	if(m_bInUse)return;
	m_reservedItemInfo = info;
}

function SetReservedString(string str)
{
//	if(m_bInUse)return;
	m_reservedString = str;
}

function string GetReservedString()
{
	//if(m_bInUse)return;
	return m_reservedString;
}

function INT64 GetReservedParamInt64()
{
	//if(m_bInUse)return;
	return m_paramInt;
}

function int GetReservedInt()
{
	return m_reservedInt;
}

function INT64 GetReservedInt2()
{
	return m_reservedInt2;
}

function int GetReservedInt3()
{
	return m_reservedInt3;
}

function ItemID GetReservedItemID()
{
	return m_reservedItemID;
}

function GetReservedItemInfo(out ItemInfo info)
{
	info = m_reservedItemInfo;
}

function SetEditBoxMaxLength(int maxLength)
{
	//if(m_bInUse)return;
	if(maxLength >= 0)
		m_editMaxLength = maxLength;
}

function SetNumberPadDefaultValue(int value)
{
	NumberPad_DefaultValue = value;
}

/**
 *  ���ο� ���̾�α� ������ �ؽ��ĸ� ���� ��Ų��.
 **/
function SetIconTexture(string texturePath)
{
	if(texturePath == "")
	{
		m_exclamationImage.SetTexture("L2UI_ct1.Icon.ICON_DF_Exclamation"); // �⺻ �ؽ��� "!" ǥ��
		m_exclamationImage.ClearTooltip();
	}
	else
	{
		m_exclamationImage.SetTexture(texturePath); // ����� Ŀ���� ������
	}
}

/**
 *  ���ο� ���̾�α� Ŀ���� ������ ������ ���� ��Ų��.
 *  
 *  ex) DialogSetIconCustomToolTip(getInstanceL2Util().getItemToolTip(info.ID.classID));
 *  
 **/
function SetIconCustomToolTip(customToolTip toolTipInfo)
{
	m_exclamationImage.SetTooltipType("text");
	m_exclamationImage.SetTooltipCustomType(toolTipInfo);
}

function HideAll()
{
//	debug("HideAll");
	m_editHandle.HideWindow();
	m_okHandle.HideWindow();
	m_cancelHandle.HideWindow();
	m_centerHandle.HideWindow();
	m_WeightPad.HideWindow();
	m_WorldExchangePad.HideWindow();
	m_NumberPad.HideWindow();
	class'UIAPI_WINDOW'.static.HideWindow("DialogBox.DialogProgress");
	SetIconTexture("");
}

function bool IsProgressBarWorking()
{
	return tryCancelDialogID > -1;
}

function SetMessage(string strMessage, optional bool bUseHtml)
{
	if(bUseHtml)
	{
		m_exclamationImage.HideWindow();
		m_HtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(strMessage));
		m_HtmlViewer.ShowWindow();
		class'UIAPI_TEXTBOX'.static.SetText("DialogBox.DialogText", "");
	}
	else
	{
		m_exclamationImage.ShowWindow();
		m_HtmlViewer.HideWindow();
		m_HtmlViewer.LoadHtmlFromString("");
		class'UIAPI_TEXTBOX'.static.SetText("DialogBox.DialogText", strMessage);
	}
	//class'UIAPI_TEXTBOX'.static.
}

/*
 * ��ư �̸� ����, int indexCancel  - > optional int indexCancel �� ����
 */
function SetButtonName(int indexOK, optional int indexCancel)
{
	m_okHandle.SetButtonName(indexOK);
	m_centerHandle.SetButtonName(indexOK);

	if(indexCancel != 0)
	{
		m_cancelHandle.SetButtonName(indexCancel);
	}
}

/*
 * ��ư ���λ����� ���� ??
 */
function SetButtonWidthSize(int indexOK, optional int indexCancel)
{
	m_okHandle.GetWindowSize(buttonWidth_prev, buttonHeight_prev);
	m_okHandle.SetWindowSize(indexOK, buttonHeight_prev);
	m_centerHandle.SetWindowSize(indexOK, buttonHeight_prev);

	if(indexCancel != 0)
	{
		m_cancelHandle.SetWindowSize(indexCancel, buttonHeight_prev);
	}
}

function HandleOK()
{
	if(m_editHandle.IsShowWindow())
	{
		m_strEditMessage = m_editHandle.GetString();
	}
	else
	{
		m_strEditMessage = "";
	}
	tryCancelDialogID = -1;

	//���̾�α׸� �������� ���� ���ؼ��� Clear�� �������� �̺�Ʈ�� �� �������� ������.
	m_dialogHandle.HideWindow();
	//m_bInUse = false;
//	ExecuteEvent(EV_DialogOK);
	ExecuteEvent(EV_DialogOK, Mid(m_strTargetScript, InStr(m_strTargetScript, ".") + 1));	// FixedHandleDialogOKEvent_moonhj 2012. 10. 16

	//if(bProgressBarWorking)bProgressBarWorking = false;
//	if(m_hostWndScript == None)
//		ExecuteEvent(EV_DialogOK);
//	else
//		m_hostWndScript.OnEvent(EV_DialogOK,"");

	//Debug(" HandleOK "  @ m_bInUse);
	DelegateOnOK();
}

function HandleCancel()
{
	m_dialogHandle.HideWindow();
	//m_bInUse = false;

	ExecuteEvent(EV_DialogCancel);

	//bProgressBarWorking = false;

	tryCancelDialogID = -1;
//	if(m_hostWndScript == None)
//		ExecuteEvent(EV_DialogCancel);
//	else
//		m_hostWndScript.OnEvent(EV_DialogCancel,"");
	DelegateOnCancel();
}

// 12.07.23 ���� �����Ҽ� �ְ� 
function SetInputNumberpadMaxLenght(int Len)
{
	input_numberpad_maxLength = Len;
}

private function Initialize()
{
	m_strTargetScript = "";
	SetEditType("normal");
	m_paramInt = 0;
	m_reservedInt = 0;
	m_reservedInt2 = 0;
	m_editMaxLength = -1;
	SetDefaultAction(EDefaultNone);
	SetEnterAction(EEnterNone);
	inputLimit = -1;
}

event OnLoad()
{
	SetInputNumberpadMaxLenght(15);
	SetClosingOnESC();

	//DialogReadingText = TextBoxHandle(GetHandle("DialogBox.DialogReadingText"));
	//m_dialogEdit = EditBoxHandle(GetHandle("DialogBox.DialogBoxEdit"));
	m_dialogHandle = GetWindowHandle("DialogBox");
	m_dialogBody = GetWindowHandle("DialogBox.DialogBody");
	m_okHandle = GetButtonHandle("DialogBox.OKButton");
	m_cancelHandle = GetButtonHandle("DialogBox.CancelButton");
	m_centerHandle = GetButtonHandle("DialogBox.CenterOKButton");
	m_editHandle = GetEditBoxHandle("DialogBox.DialogBoxEdit");
	m_textHandle = GetTextBoxHandle("DialogBox.DialogReadingText");
	m_WeightPad = GetWindowHandle("DialogBox.WeightPad");
	m_NumberPad = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NumberPad");
	m_WorldExchangePad = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WorldExchangePad");
	// ���̾�α� ������
	m_exclamationImage = GetTextureHandle("DialogBox.DialogBody.ExclamationImage");

	// �ű� �߰��� html Ÿ�Կ�
	m_HtmlViewer = GetHtmlHandle("DialogBox.DialogBody.HtmlViewer");

	m_hDialogBoxDialogProgress = GetProgressCtrlHandle("DialogBox.DialogProgress");

	Initialize();
	SetButtonName(1337, 1342);
	SetMessage("Message uninitialized");

	// �⺻ xml���� body ������ �����س���
	defaultBodyRect = m_dialogBody.GetRect();

	NumberPad_DefaultValue = 0;
	tryCancelDialogID = -1;
	
    // ��ư ������ �⺻���� ����
	if(buttonWidth_prev != 0)
	{
		m_okHandle.SetWindowSize(buttonWidth_prev, buttonHeight_prev);
		m_centerHandle.SetWindowSize(buttonWidth_prev, buttonHeight_prev);
		m_cancelHandle.SetWindowSize(buttonWidth_prev, buttonHeight_prev);
	}
	GetButtonHandle("DialogBox.WeightPad.optBtn0").SetNameText(MakeFullSystemMsg(GetSystemMessage(3408), "50%"));
	GetButtonHandle("DialogBox.WeightPad.optBtn1").SetNameText(MakeFullSystemMsg(GetSystemMessage(3408), "66.6%"));
	GetButtonHandle("DialogBox.WeightPad.optBtn2").SetNameText(MakeFullSystemMsg(GetSystemMessage(3408), "80%"));
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "OKButton":
		case "CenterOKButton":
			HandleOK();
			break;
		case "CancelButton":
			HandleCancel();
			break;
		case "num0":
		case "num1":
		case "num2":
		case "num3":
		case "num4":
		case "num5":
		case "num6":
		case "num7":
		case "num8":
		case "num9":
		case "numAll":
		case "numBS":
		case "numC":
			HandleNumberClick(strID);
			break;
		case "optBtn0":
		case "optBtn1":
		case "optBtn2":
		case "optBtn3":
		case "optBtn4":
			HandleUserOptionBtn(strID);
			break;
	}
}

event OnHide()
{
	if(m_type == DialogType_Progress)
		m_hDialogBoxDialogProgress.Stop();

	SetEditType("normal");
	//debug("����Ʈ�޽��� ���� " @ class'UIAPI_EDITBOX'.static.GetString("DialogBox.DialogBoxEdit"));
	SetEditMessage("");
	//debug("����Ʈ�޽��� ���� " @ class'UIAPI_EDITBOX'.static.GetString("DialogBox.DialogBoxEdit"));

	// EditBox�� maxLength�� ���� ��� ��������.
	if(m_editMaxLength != -1)
	{
		m_editMaxLength = -1;
		m_editHandle.SetMaxLength(m_editMaxLength_prev);
	}

	//m_bInUse = false;

	m_editHandle.Clear();
	NumberPad_DefaultValue = 0;
	SetButtonName(1337, 1342);

	// �⺻������
	SetInputNumberpadMaxLenght(15);
	DelegateOnHide();
	m_paramInt = 0;
}

event OnChangeEditBox(String strID)
{
	local string strInput, strComma;
	local Color TextColor;
	local int dotWidth, dotHeight;
	local string zeroText;

	if(strID == "DialogBoxEdit")
	{
		if(m_type == DialogType_NumberPadAdena)
		{
			//���� ����(2010.03.03)
			m_textHandle.SetText("");
			strInput = m_editHandle.GetString();

			if(Len(strInput) > 0)
			{
				if(inputLimit > -1 && inputLimit < int64(strInput))
				{
					strInput = string(inputLimit);
					m_editHandle.SetString(MakeCostString(strInput));
				}
				if(NumberPad_DefaultValue != 0)
				{
					strInput = String(NumberPad_Value * NumberPad_DefaultValue); // �⺻���� ������ 2012.02.22
				}
				m_textHandle.SetText(ConvertNumToTextNoAdena(string(int64(strInput) * class'WorldExchangeBuyWnd'.static.Inst().ADENA_MIN)));
				strComma = MakeCostString(string(int64(strInput) * class'WorldExchangeBuyWnd'.static.Inst().ADENA_MIN));

				//Set Numeric Color
				TextColor = GetNumericColor(strComma);
				m_editHandle.SetFontColor(TextColor);

				if(int(strInput) > 0)
				{
					// End:0x18C
					if(getInstanceUIData().getIsLiveServer())
					{
						zeroText = ",000,000";						
					}
					else if(class'WorldExchangeBuyWnd'.static.Inst()._IsNewServer())
					{
						zeroText = ",000,000";
						GetButtonHandle("DialogBox.WorldExchangePad.optBtn0").SetNameText("+" $ GetSystemString(7235));							
					}
					else
					{
						zeroText = "0,000,000";
						GetButtonHandle("DialogBox.WorldExchangePad.optBtn0").SetNameText(GetSystemString(14194));
					}
					GetTextSize(strInput, "__SystemEditBoxFont", dotWidth, dotHeight);
					GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WorldExchangePad.zeroesTxt").SetText(zeroText);
					GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WorldExchangePad.zeroesTxt").SetAnchor("DialogBox.DialogBody.DialogBoxEdit", "CenterLeft", "CenterLeft", dotWidth + 4, 0);
					GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WorldExchangePad.zeroesTxt").ShowWindow();
					GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WorldExchangePad.zeroesTxt").SetFontColor(TextColor);					
				}
				else
				{
					GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WorldExchangePad.zeroesTxt").HideWindow();
				}
			}
			else
			{
				GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WorldExchangePad.zeroesTxt").HideWindow();
			}
		}
		else if(m_type == EDialogType.DialogType_NumberPad/*6*/ || m_type == EDialogType.DialogType_NumberPad2/*8*/)
		{
			m_textHandle.SetText("");
			strInput = m_editHandle.GetString();

			if(Len(strInput) > 0)
			{
				if(inputLimit > -1 && inputLimit < int64(strInput))
				{
					strInput = string(inputLimit);
					m_editHandle.SetString(MakeCostString(strInput));
				}
				//Set Comma String
				strComma = MakeCostString(strInput);

				if(NumberPad_DefaultValue != 0)
				{
					strInput = string(NumberPad_Value * NumberPad_DefaultValue);
				}
				m_textHandle.SetText(ConvertNumToTextNoAdena(strInput));

				//Set Numeric Color
				TextColor = GetNumericColor(strComma);
				m_editHandle.SetFontColor(TextColor);
			}
		}
		else
		{
			TextColor = GetNumericColor(MakeCostString("1"));
			m_editHandle.SetFontColor(TextColor);
		}
	}
}

event OnEnterState(name a_CurrentStateName)
{
	// ������� ���ö� ���̾�α״� ok, cancel�� �ȵǰ� �׳� ���̵尡 �ȴ�. �׷��� ������ �߻��ϴµ�..
	// ������� ������ ��� �ö� ĵ���� ���ִ� ����ۿ��� ���� ����.
	if(tryCancelDialogID > -1)
	{
		HideDialog();
	}
}

// �Է�â�̳����ִ°��
// ���̾�α׾ƹ������̳�Ŭ����������Ŀ������������
event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if(m_editHandle.IsShowWindow() == false)
	{
		return;
	}
	if(a_WindowHandle != none && m_editHandle.IsFocused() == false)
	{
		m_editHandle.SetFocus();
	}
}

event OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	// �⺻ ����Ű ó��  ,  ���̾�α� ó�� 
	//Debug("dilogBox" @ a_WindowHandle.name);//== GetWindowHandle("W24HzWnd"));
	if(nKey == IK_Enter)
	{
		if(!ChkIDEnterKey())
		{
			DoEnterAction();
		}
	}
}

// ���̾�α��� �ð��� ������
event OnProgressTimeUp(string strID)
{
	// End:0x20
	if(strID == "DialogProgress")
	{
		DoDefaultAction();
	}
}

/**
 *  ��� ���� �ϵ� �ڵ� : ��� ��ȹ�� �̽��� 
 *  
 *  ���Ŀ� html �ױ׸� �˻��ؼ�, �ڵ����� html�������, text �ʵ� ���� ���� �ϴ� �͵� ��������..
 *  ����� ���� �� ������ �ϴ� �ϵ� �ڵ����� ó�� 
 *  
 **/ 
private function bool IsHardCodingSystemMessage(string message)
{
	local array<string> ArrayStr;
	local string targetString;
	local int i;

	// ���� ������ ��ȣ
	// 41878
	//	~
	// 41913

	// �߱� ���� �ϵ��ڵ��̶� �ּ�ó��
	// ����� xx ��λ� ���� �͵�..
	// targetString = "7447,7448,7449,7450";

	Split(targetString, ",", ArrayStr);

	for(i = 0; i < ArrayStr.Length; i++)
	{
		// Debug("GetSystemMessage(int(arrayStr[i]))" @ int(arrayStr[i]));
		if(GetSystemMessage(int(arrayStr[i]))== message)
		{
			return true;
		}
	}

	return false;
}

private function SetWindowStyle(EDialogType style)
{
	local Rect numpadRect;

	HideAll();
	m_dialogHandle.SetWindowSize(defaultBodyRect.nWidth, defaultBodyRect.nHeight);
	m_dialogBody.SetWindowSize(defaultBodyRect.nWidth, defaultBodyRect.nHeight);

	m_type = style;

	switch(style)
	{
		case DialogType_OKCancel:
			m_okHandle.ShowWindow();
			m_cancelHandle.ShowWindow();
			break;
		case DialogType_OK:
			m_centerHandle.ShowWindow();
			break;
		case DialogType_OKCancelInput:		// two Button(ok, cancel), and a EditBox
			m_editHandle.ShowWindow();
			m_textHandle.SetText("");
			m_okHandle.ShowWindow();
			m_cancelHandle.ShowWindow();
			break;
		case DialogType_OKInput:			// one Button(ok), and a EditBox
			m_editHandle.ShowWindow();
			m_textHandle.SetText("");
			m_centerHandle.ShowWindow();
			break;
		case DialogType_Warning:
			m_okHandle.ShowWindow();
			m_cancelHandle.ShowWindow();
			break;
		case DialogType_Notice:
			m_centerHandle.ShowWindow();
			break;
		case DialogType_NumberPad:
			m_editHandle.ShowWindow();
			m_textHandle.SetText("");
			m_okHandle.ShowWindow();
			m_cancelHandle.ShowWindow();
			m_NumberPad.ShowWindow();
			numpadRect = m_NumberPad.GetRect();
			m_dialogHandle.SetWindowSize(defaultBodyRect.nWidth + numpadRect.nWidth, defaultBodyRect.nHeight);
			SetEditType("number");
			break;
		case DialogType_Progress:
			m_okHandle.ShowWindow();
			m_cancelHandle.ShowWindow();
			ShowWindow("DialogBox.DialogProgress");

			if(m_paramInt == 0)
			{
				//debug("DialogBox Error!! DialogType_Progress needs parameter");
			}
			else
			{
				m_hDialogBoxDialogProgress.SetProgressTime(int(m_paramInt));
				m_hDialogBoxDialogProgress.Reset();
				m_hDialogBoxDialogProgress.Start();

				// ���α׷����ٰ� �۾� ���� �ߴٰ� ��� �ߴٰ�, �߰��� ���̾�αװ� ��ü �ɶ� ���� ��� ó���� �����ؾ��Ѵ�.
				//bProgressBarWorking = true;
			}
			break;
		case DialogType_NumberPad2:
			m_WeightPad.ShowWindow();
			m_editHandle.ShowWindow();
			m_textHandle.SetText("");
			m_okHandle.ShowWindow();
			m_cancelHandle.ShowWindow();
			m_NumberPad.ShowWindow();
			numpadRect = m_NumberPad.GetRect();
			m_dialogHandle.SetWindowSize(defaultBodyRect.nWidth + numpadRect.nWidth, 207);
			SetEditType("number");
			SetDialogWeightBtns();
			break;
		case EDialogType.DialogType_NumberPadAdena/*9*/:
			m_textHandle.SetText("");
			m_okHandle.ShowWindow();
			m_WorldExchangePad.ShowWindow();
			m_editHandle.ShowWindow();
			m_cancelHandle.ShowWindow();
			m_NumberPad.ShowWindow();
			numpadRect = m_NumberPad.GetRect();
			m_dialogHandle.SetWindowSize(defaultBodyRect.nWidth + numpadRect.nWidth, 207);
			SetEditType("number");
			SetDialogWeightBtns();
			break;
	}

	if(style == DialogType_Progress)
	{
		m_dialogHandle.SetAnchor("", "BottomCenter", "BottomCenter", 0, 0);
	}
	else
	{
		m_dialogHandle.SetAnchor("", "CenterCenter", "CenterCenter", 0, 0);
	}
}

private function HandleNumberClick(string strID)
{
	local int i;
	local string sumStr, sumStrWithoutComma;

	switch(strID)
	{
		case "num0":
			//���� ����(2010.03.03)
			if(m_editHandle.GetString() != "")
			{
				m_editHandle.AddString("0");
			}
			break;
		case "num1":
			m_editHandle.AddString("1");
			break;
		case "num2":
			m_editHandle.AddString("2");
			break;
		case "num3":
			m_editHandle.AddString("3");
			break;
		case "num4":
			m_editHandle.AddString("4");
			break;
		case "num5":
			m_editHandle.AddString("5");
			break;
		case "num6":
			m_editHandle.AddString("6");
			break;
		case "num7":
			m_editHandle.AddString("7");
			break;
		case "num8":
			m_editHandle.AddString("8");
			break;
		case "num9":
			m_editHandle.AddString("9");
			break;
		case "numAll":
			if(m_paramInt >= 0)
			{
				if(inputLimit > -1 && inputLimit < m_paramInt)
				{
					m_editHandle.SetString(string(inputLimit));					
				}
				else
				{
					m_editHandle.SetString(string(m_paramInt));
				}
				sumStr = "";

				// , �� ī��Ʈ�� ����.
				for(i = 0; i < m_editMaxLength; i++)
				{
					if ((i % 4 == 3) && (i != 0))
					{
						sumStr = "," $ sumStr;
					}
					else
					{
						sumStr = "9" $ sumStr;
						sumStrWithoutComma = "9" $ sumStrWithoutComma;
					}
				}
				if(sumStr != "")
				{
					// debug("�� ����?-->" @ sumStr);
					if(int(sumStrWithoutComma) < m_paramInt)
					{
						// debug("�� ����?" @ sumStr);
						m_editHandle.SetString(sumStrWithoutComma);
					}
				}
			}
			break;
		case "numBS":
			m_editHandle.SimulateBackspace();
			break;
		case "numC":
			//���� ����(2010.03.03)
			m_editHandle.SetString("");
			break;

		default:
			break;
	}
}

private function DoDefaultAction()
{
	//debug("DialogBox DoDefaultAction");
	switch(m_defaultAction)
	{
		case EDefaultOK:
			HandleOK();
			break;
		case EDefaultCancel:
			HandleCancel();
			break;
		case EDefaultNone:
			HandleCancel();
			break;
		default:
			break;
	}

	SetDefaultAction(EDefaultNone);			// ���̾�α׸� ��� �� ���� ���̾�α��� ����Ʈ �׼��� ������ ���� �ʾƾ� �ϹǷ� �ѹ� �ϰ����� �ʱ�ȭ �� �ش�.
}

private function DoEnterAction()
{
	switch(m_enterAction)
	{
		case EEnterOK:
			HandleOK();
			break;
		case EEnterCancel:
			HandleCancel();
			break;
		case EEnterDoNothing:
			break;
		case EEnterNone:
			DoDefaultAction();
			break;
		default:
			break;
	}
}

private function SetDialogWeightBtns()
{
	if((GetCanNumByLimitWeight(50.0f)) > 0)
	{
		GetButtonHandle("DialogBox.WeightPad.optBtn0").EnableWindow();		
	}
	else
	{
		GetButtonHandle("DialogBox.WeightPad.optBtn0").DisableWindow();
	}
	if((GetCanNumByLimitWeight(66.590f)) > 0)
	{
		GetButtonHandle("DialogBox.WeightPad.optBtn1").EnableWindow();		
	}
	else
	{
		GetButtonHandle("DialogBox.WeightPad.optBtn1").DisableWindow();
	}
	if(GetCanNumByLimitWeight(80.0f) > 0)
	{
		GetButtonHandle("DialogBox.WeightPad.optBtn2").EnableWindow();		
	}
	else
	{
		GetButtonHandle("DialogBox.WeightPad.optBtn2").DisableWindow();
	}
}

private function float GetCanCarryWeight(float limitPercent)
{
	local UserInfo uInfo;
	local float limitWeight;

	// End:0x16
	if(!GetPlayerInfo(uInfo))
	{
		return -1.0f;
	}
	limitWeight = (float(uInfo.nCarryWeight) * limitPercent) / float(100);
	return (limitWeight - float(uInfo.nCarringWeight)) - float(m_reservedInt);
}

private function int GetCanNumByLimitWeight(float limitPercent)
{
	local float canCarryWeight, canNumbyLimit;

	canCarryWeight = GetCanCarryWeight(limitPercent);
	canNumbyLimit = canCarryWeight / float(m_reservedItemInfo.Weight);

	if(canNumbyLimit > float(int(canNumbyLimit)))
	{
		return int(canCarryWeight / float(m_reservedItemInfo.Weight));
	}
	return int(canCarryWeight / float(m_reservedItemInfo.Weight) - 1);
}

private function HandleUserOptionBtn(string btnName)
{
	local int Option;

	Option = int(Right(btnName, 1));
	switch(m_type)
	{
		case EDialogType.DialogType_NumberPadAdena/*9*/:
			HandleUserOptionAdena(Option);
			break;
		case EDialogType.DialogType_NumberPad2/*8*/:
			HandleUserOptionWeight(Option);
			break;
	}
}

private function HandleUserOptionWeight(int Option)
{
	local int canNumbyLimit;

	switch(Option)
	{
		case 0:
			canNumbyLimit = GetCanNumByLimitWeight(50.0f);
			break;
		case 1:
			canNumbyLimit = GetCanNumByLimitWeight(66.590f);
			break;
		case 2:
			canNumbyLimit = GetCanNumByLimitWeight(80.0f);
			break;
	}
	m_editHandle.SetString(string(canNumbyLimit));
}

private function HandleUserOptionAdena(int Option)
{
	local INT64 Num;

	Num = int64(m_editHandle.GetString());
	switch(Option)
	{
		case 0:
			Num = 1;
			break;
		case 1:
			Num = 5;
			break;
		case 2:
			Num = 10;
			break;
		case 3:
			Num = 50;
			break;
		case 4:
			Num = 100;
			break;
	}
	Num = Min64(int64(m_editHandle.GetString()) + Num, class'WorldExchangeBuyWnd'.static.Inst().ADENA_MAX);
	m_editHandle.SetString(string(Num));
}

private function bool ChkIDEnterKey()//����Ű ���� ���ܻ��� �ϵ��ڵ� ��Ÿ �ʿ��� ���� ���� ���� �ϵ� �ڵ��� ���⿡ �߰� �Ͻø� �˴ϴ�.
{
	local bool isshowcand;	 //branch121212
	/*
	switch(DialogGetID()){
	case 2424://2011.05027 �߰� ������ ��û | W24HzWnd �� DIALOGID_Install24hz
		return true;	
	case 2425://2011.05031 ��� �߰� | W24HzWnd �� DIALOGID_FullWindow
		return true; 
	case 323://TradeWnd �� DIALOG_ID_TRADE_REQUEST
			return true;
	}
	*/
	//branch121212
	if(m_bGlobalIME)
	{
		// End:0x38
		if(m_editHandle.IsShowWindow())
		{
			isshowcand = m_editHandle.IsShowCandidateBox();
			return isshowcand;
		}
	}

	//end of branch
	return false;
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
event OnReceivedCloseUI()
{
	//Debug("�ݱ� �õ� ");
	// Ŭ���̾�Ʈ �� ���̾�α� �ڽ��鵵 �ְ� ���� �߸� ���� ������ �����Ƿ� esc ���� ���ϵ��� �Ѵ�.
	if(m_type != DialogType_Progress)
	{
		HandleCancel();
	}
}

defaultproperties
{
}
