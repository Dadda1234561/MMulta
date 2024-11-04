class UICommonAPI extends UIConstants;

const EV_USER_CharacterSelectionChanged = 50000;

//FileWnd FileHandler TYPE
enum _FileHandler
{
	FH_NONE,
	FH_PLEDGE_CREST_UPLOAD,
	FH_PLEDGE_EMBLEM_UPLOAD,
	FH_ALLIANCE_CREST_UPLOAD,
	FH_WEBBROWSER_FILE_UPLOAD,
	FH_MAX
	// ?ï¿½Ð????Â©ÂµÂµ?Ð¼???ï¿?? ?ï¿½Ð????ï¿?? ?ï¿½Ñ??ï¿???ï¿½ï¿½? ?ï¿½Ð¤Ñ???ï¿?? ?ï¿½Â¤Ð??Â°ï¿?? ?ï¿½Ð??Â»Â¶ï¿?? ?ï¿½Ð»ÂµÂµÑ?ï¿?? Âµ?ï¿½Â¶ï¿½? ?ï¿½ï¿½?Â°?ï¿½Ð?Ð¥???ï¿?? 
};


const ARTIFACTTYE_NORMAL = 4398046511104;
const ARTIFACTTYE_TYPE1  = 18014398509481984;
const ARTIFACTTYE_TYPE2  = 144115188075855872;
const ARTIFACTTYE_TYPE3  = 1152921504606846976;

var bool bDoNotUseDebug;

static function UICommonAPI InstanceUICommonAPI()
{
	return UICommonAPI(GetScript("UICommonAPI"));
}

function DEBUG_EVT_ID_PARAMS(int Event_ID, string param)
{
	local int i;
	local array<string> dbgStr;

	AddSystemMessageString("DEBUG_EVT_ID_PARAMS: "@Event_ID@" Params2:"@param);
	Split(param, " ", dbgStr);
	for ( i = 0; i < dbgStr.Length; i++ )
	{
		AddSystemMessageString("   DEBUG_EVT_ID_PARAMS: "$dbgStr[i]);
	}
}

//?ï¿½Ð????Â©ÂµÂµ?Ð¼?ï¿?? ?ï¿½Ñ??Â©?Ð¨?ï¿??. ?ï¿½ÐªÂµÐ¹Â·Ð??ï¿?? ?ï¿½Ñ??Â¤??Â°ï¿??, 
//FileWnd.uc?ï¿½ï¿½? Upload?ï¿½Ð¤Ñ???ï¿?? ?ï¿½Ñ??Â¤?Ð¨?ï¿?? ?ï¿½Ð???ÂµÐ¾Â·??ï¿?? ?ï¿½Ð??Ð°Âµï¿?? ?ï¿½Ð¤Ñ???ï¿?? ?ï¿½Ñ??Â¤?ï¿?? ?ï¿½Ð¦Ð?ï¿??.
function FileRegisterWndShow(_FileHandler filehandlertype) 
{
	local FileRegisterWnd script;
	script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	script.ShowFileRegisterWnd(filehandlertype);
}

function AddFileRegisterWndFileExt(string Str, array<string> strArray)
{
	local FileRegisterWnd script;

	script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	script.AddFileExt(Str, strArray);
}

function ClearFileRegisterWndFileExt()
{
	local FileRegisterWnd script;

	script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	script.ClearFileExt();
}

//?ï¿½Ð????Â©ÂµÂµ?Ð¼?ï¿?? ?ï¿½Ñ?Â°ï¿???ï¿½Ð¨Ò?ï¿??
function FileRegisterWndHide()
{
	local FileRegisterWnd script;

	script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	script.HideFileRegisterWnd();
}

//
// ?ï¿½Ð©Ð????Â·?Â±Ð§?ï¿?? ?ï¿½Ñ??Â©?Ð¨?ï¿??. strMessage : ?ï¿½Ð¤Ð?ï¿?? ?ï¿½Ñ??Â©?ï¿?? ?ï¿½Ñ??ï¿???ï¿½ï¿½?(?ï¿½â???ï¿½Â¦ÂµÐ¹Ñ?ï¿?? "Â°?ï¿½Ñ???ï¿?? ?ï¿½Ð¤Â·Ð??ï¿?? ?ï¿½Ð¦Ñ???ï¿??")
// ?ï¿½ï¿½Â«?ï¿½ï¿½? Â°?ï¿½Ò?ï¿???ï¿½ï¿½? ?ï¿½Ð©Ð????Â·?Â±Ð§Â°ï¿?? ?ï¿½Ð??ï¿?? ?ï¿½Ð?Â»ï¿?? DialogSetID() Â°Â°?ï¿½ï¿½? ?ï¿½Ð¢Â·Ð??Ð°?ï¿?? ?ï¿½Ð¡Ò?ï¿??.
// 
//  - ?ï¿½Ð©Ð????Â·?Â±ï¿?? Â±Ð²?ï¿½ï¿½? ?ï¿½ï¿½?Â°?? - 
//
// dialogHeight : ?ï¿½Ð©Ð????Â·?Â±ï¿?? ?ï¿½Ñ?Â·ï¿?? Â»Ð·?ï¿½Ð??ï¿??, 0 , -1 Â°Â°?ï¿½ï¿½? 0?ï¿½Ñ??ï¿?? ?ï¿½Ð«Ð?ï¿?? Â°?ï¿½Ð?ï¿?? ?ï¿½Ð¦Ð???ï¿?? Â±Ð²?ï¿½ï¿½? Â»Ð·?ï¿½Ð??Ð¾Â·ï¿?? ?ï¿½Ñ???Âµ??ï¿??.
// bUseHtml : true Â¶?ï¿½Ñ?ï¿??, strMessage ?ï¿½Â»Ñ?Ð»?ï¿?? html ?ï¿½Ð§Â±Ð§Ñ?ï¿?? Â»Ð·?ï¿½ï¿½? ?ï¿½Ð¢Ñ?ï¿?? ?ï¿½Ð¦Â°ï¿½? Âµ?ï¿½Ò?ï¿??. <html><body> .. ?ï¿½ï¿½? ?ï¿½Ð¦Ð?ï¿?? ?ï¿½Ð??ï¿?? ?ï¿½Ñ??ï¿??
// 
// isXMLOKDialogShow : ?ï¿½Ñ??ï¿?? Â»Ð·?ï¿½Ð»Ð???ï¿?? ?ï¿½Ð?Â°ï¿?? ?ï¿½Ð¦Ð?ï¿??, XML ?ï¿½Ð©Ð????Â·?Â±Ð§?ï¿?? ?ï¿½Ñ??Â©?Ð©Â°???Â°ï¿???, Â±Ð²?ï¿½ï¿½? UIÂµÐ¹?ï¿½ï¿½? ?ï¿½Ñ??????ï¿?? Effect UI [?ï¿½ï¿½??ï¿½ï¿½?] ?ï¿½Ñ?Â·ï¿?? ?ï¿½Ð?Â°ï¿?? --
//
// ?ï¿½ï¿½?Â±?ï¿½ï¿½ ?ï¿½ï¿½?ï¿½Ð?????ï¿?? Â°?ï¿½Ð?ï¿???ï¿½ï¿½?, param ?ï¿½ï¿½?Â°?? dialogWeight
static function DialogShow(EDialogModalType modalType, EDialogType dialogType, string strMessage, string strControlName, optional int dialogWeight, optional int dialogHeight, optional bool bUseHtml, optional string customIconTexture)//, optional bool isXMLOKDialogShow)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.ShowDialog(modalType, dialogType, strMessage, strControlName, dialogWeight, dialogHeight, bUseHtml);
	// End:0x6F
	if(customIconTexture != "")
	{
		script.SetIconTexture(customIconTexture);
	}
}

static function DialogSetCancelD(int targetCancelDialogID)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.SetDialogCancelD(targetCancelDialogID);
}

//?ï¿½Ð©Ð????Â·?Â±ï¿?? ?ï¿½ï¿½?ï¿½Ð?ï¿?? ?ï¿½Ð??ï¿?? ?ï¿½Ñ??ï¿??
static function DialogSetButtonName(int indexOK, optional int indexCancel)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.SetButtonName(indexOK, indexCancel);
}

//?ï¿½Ð©Ð????Â·?Â±ï¿?? ?ï¿½ï¿½?ï¿½Ð?ï¿?? Â°?ï¿½Â·Ð?Â»Ð·???ï¿?? ?ï¿½Ñ??ï¿??
static function DialogSetButtonWidthSize(int indexOK, optional int indexCancel)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.SetButtonWidthSize(indexOK, indexCancel);
}

// ?ï¿½Ñ??ï¿?? ?ï¿½Ð?Â°ï¿?? Â°?ï¿½Ò???ï¿?? ?ï¿½Ð©Ð????Â·?Â±ï¿??
static function DialogShowWithResize(EDialogModalType modalType, EDialogType dialogType, string strMessage, int changeWidth, int changeHeight, string strControlName)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.ShowDialog(modalType, dialogType, strMessage, strControlName, changeWidth, changeHeight);
}

// ?ï¿½Ð©Ð????Â·?Â±Ð§?ï¿?? Â°?ï¿½Ð?Ð±?ï¿??. ?ï¿½Ð©Ð????Â·?Â±Ð§Â°ï¿?? Â¶Â° ?ï¿½Ð¦Ò?ï¿?? Â»?ï¿½Ð?????ï¿?? ?ï¿½Ð©Ñ?ï¿?? ?ï¿½Ð©Ð????Â·?Â±Ð§?ï¿?? ?ï¿½Ñ??Â©?Ð¦Â·??ï¿?? DialogHide() ?ï¿½ï¿½? ?ï¿½Ð¥Ð?ï¿?? ?ï¿½Ð??Ð²?Ð¨?ï¿???ï¿½Ð¡Ò?ï¿??.
static function DialogHide()
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.HideDialog();
}

// ?ï¿½Ð©Ð????Â·?Â±Ð§Â°ï¿?? ?ï¿½Ð¾Â¶ï¿½? Âµ?ï¿½Ð?Ð«?ï¿?? ?ï¿½Ð»Ð?Ð¢???ï¿?? default Â°?ï¿½Ð?ï¿?? ?ï¿½Â¤Ð?Ð¨?Ð¦?ï¿?? Â°?ï¿½Ð??Â·ï¿?? 
// ?ï¿½Ð¡â???? Â»Ð·?ï¿½Ð»ÂµÐ?Â°Ð½???ï¿?? ?ï¿½Ð?Â±Ð²?ï¿?? Âµ?ï¿½â???ï¿½Â·ï¿½? Âµ???ï¿½Ñ??ï¿?? ?ï¿½Ð§Ñ???ï¿?? OKÂ·?? ?ï¿½Ð?Â°Ð½?????ï¿?? ?ï¿½Ð????? ?ï¿½Ð©Ð????Â·?Â±ï¿?? Â¶Ð·?ï¿½ï¿½? Â¶Â§ ?ï¿½Â¶Ò?ï¿?? ?ï¿½Ð¢Â·Ð??Ð°?ï¿???ï¿½Ð¡Ò?ï¿??.
static function DialogSetDefaultOK()
{
	local DialogBox script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetDefaultAction(EDefaultOK);
}

//Â±Ð§?ï¿½ï¿½Ð­?ï¿½Ð»Â·ï¿½? cancelÂ·?? ?ï¿½Ð????Ð¡?ï¿??
static function DialogSetDefaultCancle()
{
	local DialogBox script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetDefaultAction(EDefaultCancel);
}

// ?ï¿½Ð????ï¿?? ?ï¿½Â©Ñ???ï¿?? ?ï¿½Ð©Ð????Â·?Â±ï¿?? Âµ?ï¿½Ð?Ð«?ï¿?? ?ï¿½ï¿½Â«?ï¿½ï¿½?
static function DialogSetEnterDoNothing()
{
	local DialogBox script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetEnterAction(EEnterDoNothing);
}

// ?ï¿½Ð????ï¿?? ?ï¿½Â©Ñ???ï¿?? ?ï¿½Ð©Ð????Â·?Â±ï¿?? Âµ?ï¿½Ð?Ð«?ï¿?? Ok
static function DialogSetEnterOK()
{
	local DialogBox script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetEnterAction(EEnterOK);
}

// ?ï¿½Ð????ï¿?? ?ï¿½Â©Ñ???ï¿?? ?ï¿½Ð©Ð????Â·?Â±ï¿?? Âµ?ï¿½Ð?Ð«?ï¿?? Cancel
static function DialogSetEnterCancle()
{
	local DialogBox script;
	script = DialogBox(GetScript("DialogBox"));
	script.SetEnterAction(EEnterCancel);
}

// EV_DialogOK ÂµÐ¾?ï¿½ï¿½? ?ï¿½Ð©Ð????Â·?Â±ï¿?? ?ï¿½Ð????ï¿??Â°?? ?ï¿½Ð¤Ð?ï¿?? Â¶Â§, ?ï¿½ï¿½? ?ï¿½Ð©Ð????Â·?Â±Ð§Â°ï¿?? ?ï¿½ÐªÐ???ï¿?? Â¶Ð·?ï¿½ï¿½? ?ï¿½Ð©Ð????Â·?Â±ï¿?? ?ï¿½Ð????ï¿?? ?ï¿½Ð??Â°?ï¿?? Â¶Â§ ?ï¿½Ð????ï¿??. ?ï¿½Ð??ï¿?? Â¶Ð·?ï¿½ï¿½? ?ï¿½Ð©Ð????Â·?Â±Ð§Â¶??ï¿?? ?ï¿½Ð?Â°Ð¶?ï¿?? ?ï¿½Ð??Ð´Â°ï¿?? ?ï¿½Ñ??ï¿??~
function bool DialogIsMine()
{
	local DialogBox script;

	// Debug("dialog" @ string(Self));
	script = DialogBox(GetScript("DialogBox"));
	// End:0x35
	if(script.GetTarget() == string(self))
	{
		return true;
	}
	return false;
}

// ?ï¿½Ð©Ð????Â·?Â±ï¿??
function bool DialogHasPreviousCancelProcess()
{
	local DialogBox script;

	// Debug("dialog" @ string(Self));
	script = DialogBox(GetScript("DialogBox"));

	return script.HasPreviousCancelProcess();
}

function bool DialogCheckCancelByID(int targetDialogID)
{
	local DialogBox script;

	script = DialogBox(GetScript("dialogbox"));
	return script.CheckCancelDialogID(targetDialogID);
}

// Might be usefull
function _DialogShowHtml(EDialogModalType modalType, EDialogType dialogType, string strMessage, string strControlName, optional int dialogWeight, optional int dialogHeight, optional bool bUseHtml, optional string customIconTexture)
{
	local string htmlStr, iconStr;

	if(customIconTexture == "")
	{
		customIconTexture = "L2UI_ct1.Icon.ICON_DF_Exclamation";
	}
	iconStr = "<img src=\"" $ customIconTexture $ "\" width=32 height=32>";
	htmlStr = "<table><tr><td valign=\"top\">" $ iconStr $ "</td><td valign =\"top\" height=\"80\">" $ strMessage $ "</td></tr></table>";
	DialogShow(modalType, dialogType, htmlStr, strControlName, dialogWeight, dialogHeight, true);	
}

// UICommonAPI?ï¿½ï¿½? Â»?ï¿½Ñ?Ð£??Ð®?ï¿½ï¿½? ?ï¿½Ð??ï¿?? ?ï¿½ï¿½?Â·?ï¿½Ð?????ï¿??ÂµÂµ Â»Ð·?ï¿½Ð»Ð??Â±ï¿?? ?ï¿½Â§Ð?ï¿?? ?ï¿½ï¿½?Â°??. ?ï¿½â??: GFx ?ï¿½Ñ??Â©???ï¿??
static function bool DialogIsOwnedBy(string Owner)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	// End:0x37
	if(script.GetTarget() == Owner)
	{
		return true;
	}
	return false;
}

// ?ï¿½Ð¡Â°Ñ??ï¿?? uc?ï¿½Ð??ï¿?? ?ï¿½Ð©Ð????Â·?Â±Ð§?ï¿?? ?ï¿½Ð¡â???ï¿½Ñ?ï¿?? Â¶Ð·?ï¿½Ð¾Ò?Ð©?ï¿?? ?ï¿½ï¿½? ?ï¿½Ð??Ð´Â°ï¿?? ?ï¿½Ñ?Â°Ðª???ï¿??, ?ï¿½Ð©Ð????Â·?Â±Ð§?ï¿?? ?ï¿½Â©Â·ï¿½? Â»?ï¿½Ð?????ï¿?? ?ï¿½Ò??Ð©?ï¿??, ?ï¿½â???ï¿½ï¿½? ÂµÐ¹?ï¿½ï¿½? ?ï¿½Ñ??ï¿??.uc?ï¿½Ð??ï¿??  ?ï¿½Ñ???????Âµï¿???ï¿½ï¿½? ?ï¿½ï¿½?ï¿½Ò??Âµ?Âµï¿?? ?ï¿½Ð?Â°ï¿??
// ?ï¿½Ñ??ï¿?? ?ï¿½Ð????ï¿?? ?ï¿½Ð¤Â·ï¿½? ?ï¿½ï¿½Ð®?ï¿½ï¿½? Âµ?ï¿½Âµï¿½? Â»Ð·?ï¿½Ð»Ð?Ð¡?Ð©?ï¿??, ?ï¿½Ð©Ð????Â·?Â±ï¿?? ?ï¿½Ð????ï¿??Â°?? ?ï¿½Ð¤Ð?Â»Â¶ï¿?? ?ï¿½ÐªÐ???ï¿?? ?ï¿½Ð¾Â¶ï¿½? ?ï¿½Ð©Ð????Â·?Â±Ð§?ï¿?? Â¶Ð·?ï¿½Ñ??????ï¿?? ?ï¿½ï¿½? ?ï¿½Ð??Ð´Â°ï¿?? ?ï¿½Ð¦Ò?ï¿??.
// ?ï¿½Ð?Â·ï¿?? Â°Ð¶?ï¿½ï¿½? ?ï¿½Ð©Ð????Â·?Â±Ð§?ï¿?? Â¶Ð·?ï¿½ï¿½? Â¶Â§ ?ï¿½Ñ?????Â°ï¿?? ?ï¿½Ð???Â« ?ï¿½Ñ??Ðª?ï¿?? DialogSetID() ?ï¿½ï¿½? ?ï¿½Ð¦Â°ï¿½? ?ï¿½Ð????ï¿?? ?ï¿½Ñ??ï¿?? ?ï¿½Ð??????ï¿?? DialogGetID()?ï¿½ï¿½? ?ï¿½Ð¨Ñ?ï¿?? Â±Ð§?ï¿½ï¿½? ?ï¿½Ð?Â°ï¿?? ?ï¿½ÐªÂµÐµÑ?ï¿?? ?ï¿½Ò??Ð¹Âµ??ï¿??.
static function DialogSetID(int Id)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.setId(Id);
}

// ?ï¿½Ð©Ð???Ð¾Â·?Â±Ð§?ï¿?? ?ï¿½Ð?Âµï¿???ï¿½ï¿½? ?ï¿½ï¿½Ðª?ï¿½Ñ??ï¿?? ?ï¿½Ð¤Â·ï¿½? ?ï¿½Ñ??Ð¤?ï¿?? ?ï¿½Ñ??Â¤?ï¿?? ?ï¿½ï¿½? ?ï¿½ï¿½? ?ï¿½Ð¦Ò?ï¿??. ?ï¿½Ð???Ð­ ?ï¿½ï¿½Â®?ï¿½ÐªÑ?ï¿??, ?ï¿½Ñ??ï¿??, ?ï¿½Ð?????Âµï¿?? ÂµÐ¾, XML ?ï¿½Ð?Â·??Ð´?ï¿?? ?ï¿½ï¿½Â®?ï¿½ï¿½? ?ï¿½Ñ??ï¿??.
static function DialogSetEditType(string strType)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.SetEditType(strType);
}

// ?ï¿½Ð©Ð????Â·?Â±Ð§?ï¿?? ?ï¿½Ð?Âµï¿???ï¿½ï¿½??ï¿½ï¿½Ðª?ï¿½Ñ??ï¿?? ?ï¿½Ð¤Â·Ð?Âµï¿?? ?ï¿½Ñ??ï¿???ï¿½ÂµÐ?ï¿?? ?ï¿½ï¿½Ð®?ï¿½Ð????ï¿??
static function string DialogGetString()
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	return script.GetEditMessage();
}

// ?ï¿½Ð©Ð????Â·?Â±Ð§?ï¿?? ?ï¿½Ð?Âµï¿???ï¿½ï¿½??ï¿½ï¿½Ðª?ï¿½Ñ??ï¿?? ?ï¿½Ñ??ï¿???ï¿½ÂµÐ?ï¿?? ?ï¿½Ð¤Â·Ð??Ð¡?ï¿??
static function DialogSetString(string strInput)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.SetEditMessage(strInput);
}

static function int DialogGetID()
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	return script.GetID();
}

// ParamInt?ï¿½ï¿½? ?ï¿½Ð©Ð????Â·?Â±Ð§?ï¿?? Âµ?ï¿½Ð?Ð«Â°ï¿?? Â°?ï¿½Â·Ð?Âµï¿?? Â»?ï¿½Ñ??ÂµÐ¹?ï¿?? ?ï¿½Ñ??Â¤?ï¿?? ?ï¿½Ð¦Ò??Âµï¿?? ?ï¿½Ð????ï¿??. Progress?ï¿½ï¿½? timeup ?ï¿½Ð?Â°ï¿??, NumberPad?ï¿½Ð??ï¿?? maxÂ°?? ÂµÐ¾.
static function DialogSetParamInt64(INT64 param)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.setParamInt64(param);
}

// ReservedXXX Â°?ï¿½ÂµÐ¹Ð?ï¿?? ?ï¿½Ð©Ð????Â·?Â±Ð§?ï¿?? ?ï¿½Ð¦Ñ?Ð¾???Ð©Â°ï¿?? ?ï¿½Ð©Ð?ï¿?? ?ï¿½Ð??ï¿?? ?ï¿½ï¿½? ?ï¿½ï¿½? ?ï¿½Ð¦Ò?Ð©?ï¿?? ?ï¿½Ð????ï¿?? ParamXXX?ï¿½Ð??ï¿?? ?ï¿½Ð©Ñ???ï¿??.
static function DialogSetReservedInt(int Value)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedInt(Value);
}

static function DialogSetReservedInt2(INT64 Value)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedInt2(Value);
}

static function DialogSetReservedInt3(int Value)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedInt3(Value);
}

static function DialogSetReservedItemID(ItemID Id)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedItemID(Id);
}

static function DialogSetReservedItemInfo(ItemInfo Info)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.SetReservedItemInfo(Info);
}

static function int DialogGetReservedInt()
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedInt();
}

static function INT64 DialogGetReservedInt2()
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedInt2();
}

static function int DialogGetReservedInt3()
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedInt3();
}

static function ItemID DialogGetReservedItemID()
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	return script.GetReservedItemID();
}

static function DialogGetReservedItemInfo(out ItemInfo Info)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.GetReservedItemInfo(Info);
}

static function DialogSetEditBoxMaxLength(int MaxLength)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.SetEditBoxMaxLength(MaxLength);
}

static function DialogSetIconTexture(string iconTextureStr)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.SetIconTexture(iconTextureStr);
}

static function DialogSetIconCustomToolTip(CustomTooltip toolTipInfo)
{
	local DialogBox script;

	script = DialogBox(GetScript("DialogBox"));
	script.SetIconCustomToolTip(toolTipInfo);
}

static function DialogSetInputlimit(INT64 inputLimit)
{
	class'DialogBox'.static.Inst().inputLimit = inputLimit;
}

static function int Split(string strInput, string delim, out array<string> arrToken)
{
	local int arrSize;

	while(InStr(strInput, delim) > 0)
	{
		arrToken.Insert(arrToken.Length, 1);
		arrToken[arrToken.Length - 1] = Left(strInput, InStr(strInput, delim));
		strInput = Mid(strInput, InStr(strInput, delim) + 1);
		arrSize = arrSize + 1;
	}
	arrToken.Insert(arrToken.Length, 1);
	arrToken[arrToken.Length - 1] = strInput;
	arrSize = arrSize + 1;
	return arrSize;
}

function ShowWindow(string a_ControlID)
{
	class'UIAPI_WINDOW'.static.ShowWindow(a_ControlID);
}

/** ?ï¿½Â©ÂµÂµÑ?Ð¼?ï¿??, ?ï¿½ï¿½?Â°Ð½ ?ï¿½ï¿½?Â°Ð½ ?ï¿½Ð??ï¿?? ?ï¿½Ð¤Ñ?ï¿?? */
function toggleWindow(string a_ControlID, optional bool bFocus, optional bool bUseOpenCloseSound)
{
	if(class'UIAPI_WINDOW'.static.IsShowWindow(a_ControlID))
	{
		if(bUseOpenCloseSound)
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
		}
		class'UIAPI_WINDOW'.static.HideWindow(a_ControlID);
	}
	else
	{
		if(bUseOpenCloseSound)
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
		}
		if(class'MinimizeManager'.static.Inst()._IsMin(a_ControlID))
		{
			class'MinimizeManager'.static.Inst()._MaximizeWindow(a_ControlID);			
		}
		else
		{
			class'UIAPI_WINDOW'.static.ShowWindow(a_ControlID);
		}
		if(bFocus)
		{
			class'UIAPI_WINDOW'.static.SetFocus(a_ControlID);
		}
	}
}

function ShowWindowWithFocus(string a_ControlID)
{
	class'UIAPI_WINDOW'.static.ShowWindow(a_ControlID);
	class'UIAPI_WINDOW'.static.SetFocus(a_ControlID);
}
static function string reverseString(coerce string Str)
{
	local string reverseStr;
	local int i;
	for (i = Len(str) - 1; i >= 0; --i)
	{
		reverseStr = reverseStr $ Mid(Str, i, 1);
	}

	return reverseStr;
}

function bool IsOnlyNumber(string Str)
{
	local string M;
	local int i;

	for(i = 0; i < Len(Str); i++)
	{
		M = Mid(Str, i, 1);
		if((Asc(M) > 47) && Asc(M) < 58)
		{
			continue;
		}
		return false;
	}
	return true;	
}

static final function ReplaceText (out string Text, string Replace, string With)
{
	local int i;
	local string Input;

	if ((Text == "") || (Replace == ""))
	{
		return;
	}
	Input = Text;
	Text = "";
	i = InStr(Input, Replace);
	while(i != -1)
	{
		Text = Text $ Left(Input, i) $ With;
		Input = Mid(Input, i + Len(Replace));
		i = InStr(Input, Replace);
	}
	Text = Text $ Input;
}

static function string trim(string S)
{
	local int i;
	if(Len(S) == 0)
	{
		return S;
	}
	i = 0;
	while (Mid(s,i,1) == " " || Mid(s,i,1) == "\t")		//necessary for adding tab
		++i;

	S = Right(S, Len(S)-i);
	
	if(Len(S) == 0)
	{
		return S;
	}

	i = Len(S) - 1;

	while (Mid(S, i, 1) == " " || Mid(S, i, 1) == "\t")	//necessary for adding tab
		--i;

	S = Left(S, i + 1);

	return S;
}

static function string trimParam(string S)
{
	local int i;
	if(Len(S) == 0)
	{
		return S;
	}
	i = 0;
	while(Mid(S, i, 1) == " " || Mid(S, i, 1) == Chr(127))		//necessary for adding tab
	{
		++i;
	}

	S = Right(S, Len(S) - i);
	
	if(Len(S) == 0)
	{
		return S;
	}

	i = Len(S) - 1;

	while(Mid(S, i, 1) == " " || Mid(S, i, 1) == Chr(127))	//necessary for adding tab
	{
		--i;
    }

	S = Left(S, i + 1);

	return S;
}


static function string deleteEnter(string s)
{
	local int i;
	if (Len(s) == 0) return s;
	i = 0;

	// ?ï¿½ÐªÂµï¿½? 13, \n Â°?ï¿½Ð???ï¿??
	while (Mid(s,i,1) == Chr(13) || Mid(s,i,1) == Chr(10))
		++i;

	s = Right(s,Len(s)-i);
	
	if (Len(s) == 0) return s;

	i = Len(s) - 1;

	while (Mid(s,i,1) == Chr(13) || Mid(s,i,1) == Chr(10))
		--i;

	s = Left(s, i + 1);

	return s;
}

static function int InStrFromBack(string s, string t)
{
	local string reverseStr;
	local int i;
	reverseStr = reverseString(s);
	i = InStr(reverseStr, t);

	if (i >= 0)
		return Len(s) - 1 - i;
	else
		return i;
}

static function int InStrFromBack2(string S, string t)
{
	local string reverseStr;
	local int i;

	reverseStr = reverseString(S);
	i = InStr(reverseStr, reverseString(t));
	// End:0x49
	if(i >= 0)
	{
		return (Len(S) - 1) - i;		
	}
	else
	{
		return i;
	}	
}

function HideWindow(string a_ControlID)
{
	class'UIAPI_WINDOW'.static.HideWindow(a_ControlID);
}

function bool IsShowWindow(string a_ControlID)
{
	return class'UIAPI_WINDOW'.static.IsShowWindow(a_ControlID);
}

function ParamToRecord(string param, out LVDataRecord Record)
{
	local int idx, MaxColumn;

	ParseString(param, "szReserved", Record.szReserved);
	ParseINT64(param, "nReserved1", Record.nReserved1);
	ParseINT64(param, "nReserved2", Record.nReserved2);
	ParseINT64(param, "nReserved3", Record.nReserved3);

	ParseInt(param, "MaxColumn", MaxColumn);
	Record.LVDataList.Length = MaxColumn;
	for (idx = 0; idx < MaxColumn; idx++)
	{
		ParseString(param, "szData_" $ idx, Record.LVDataList[idx].szData);
		ParseString(param, "szReserved_" $ idx, Record.LVDataList[idx].szReserved);
		ParseInt(param, "nReserved1_" $ idx, Record.LVDataList[idx].nReserved1);
		ParseInt(param, "nReserved2_" $ idx, Record.LVDataList[idx].nReserved2);
		ParseInt(param, "nReserved3_" $ idx, record.LVDataList[idx].nReserved3);
	}
}

/** 
 *  12.07.05 toopTipWidth ?ï¿½ï¿½?Â°?? - ?ï¿½Ñ???Â°?Â·?Â»Ð·???ï¿?? ?ï¿½Ñ??ï¿??, toopTipWidth ?ï¿½Ñ??Â¤???ï¿?? t_bDrawOneLine true Â°?? false Â·?? ?ï¿½Ñ??Â¤Âµï¿?? 
 */
function CustomTooltip MakeTooltipSimpleText(string Text, optional int toolTipWidth)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info;
	local bool oneline;

	oneline = true;
	// End:0x1B
	if(toolTipWidth > 0)
	{
		oneline = false;
	}
	ToolTip.DrawList.Length = 1;
	ToolTip.MinimumWidth = toolTipWidth;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = oneline;
	Info.t_color.R = 230;
	Info.t_color.G = 230;
	Info.t_color.B = 230;
	Info.t_color.A = 255;
	Info.t_strText = Text;
	ToolTip.DrawList[0] = Info;

	return ToolTip;
}

function CustomTooltip MakeTooltipSimpleColorText(string Text, Color TextColor, optional string FontName, optional int toolTipWidth)
{
	local CustomTooltip ToolTip;

	local bool oneline;

	oneline = true;
	// End:0x1B
	if(toolTipWidth > 0)
	{
		oneline = false;
	}
	ToolTip.MinimumWidth = toolTipWidth;
	ToolTip.DrawList[0] = addDrawItemText(Text, TextColor, FontName, oneline);
	return ToolTip;
}

/** 
   ?ï¿½Ð¦Ð?ï¿?? Â¶?ï¿½Ð?ï¿??, ?ï¿½Ñ????ï¿?? ?ï¿½Ñ??ï¿?? (Â»?ï¿½Ð?????????ï¿?? ?ï¿½Ñ?Âµï¿?? Â°??)
   
   
   ex)
   		SetTooltipCustomType(MakeTooltipMultiText("1 ?ï¿½Ð§Ð???ï¿?? ?ï¿½Ð§Ñ?ï¿??", getInstanceL2Util().Yellow, "HS15",false,
												  "2 ?ï¿½Ð§Ð???ï¿?? ?ï¿½Ð§Ñ?ï¿??", getInstanceL2Util().Yellow, "",true,
												  "3 ?ï¿½Ð§Ð???ï¿?? ?ï¿½Ð§Ñ?ï¿??", getInstanceL2Util().Blue, "HS12",true));
 */
function CustomTooltip MakeTooltipMultiText(string line1text, Color text1Color, optional string font1Name, optional bool bLine1Break, optional string line2text, optional Color text2Color, optional string font2Name, optional bool bLine2Break, optional string line3text, optional Color text3Color, optional string font3Name, optional bool bLine3Break, optional int toolTipWidth)
{
	local CustomTooltip ToolTip;
	local int countLength, textWidth, textHeight, maxTextWidth;

	countLength = 0;

	// End:0x26
	if(font1Name == "")
	{
		font1Name = "GameDefault";
	}
	// End:0x45
	if(font2Name == "")
	{
		font2Name = "GameDefault";
	}
	// End:0x64
	if(font3Name == "")
	{
		font3Name = "GameDefault";
	}
	// End:0xAB
	if(line1text != "")
	{
		countLength++;
		GetTextSize(line1text, font1Name, textWidth, textHeight);
		// End:0xAB
		if(textWidth > maxTextWidth)
		{
			maxTextWidth = textWidth;
		}
	}
	// End:0xF2
	if(line2text != "")
	{
		countLength++;
		GetTextSize(line2text, font2Name, textWidth, textHeight);
		// End:0xF2
		if(textWidth > maxTextWidth)
		{
			maxTextWidth = textWidth;
		}
	}
	// End:0x139
	if(line3text != "")
	{
		countLength++;
		GetTextSize(line3text, font3Name, textWidth, textHeight);
		// End:0x139
		if(textWidth > maxTextWidth)
		{
			maxTextWidth = textWidth;
		}
	}
	ToolTip.DrawList.Length = countLength;
	// End:0x168
	if(toolTipWidth > 0)
	{
		ToolTip.MinimumWidth = toolTipWidth;
	}
	else
	{
		ToolTip.MinimumWidth = maxTextWidth + 1;
	}
	// End:0x1AF
	if(line1text != "")
	{
		ToolTip.DrawList[0] = addDrawItemText(line1text, text1Color, font1Name, bLine1Break);
	}
	// End:0x1E3
	if(line2text != "")
	{
		ToolTip.DrawList[1] = addDrawItemText(line2text, text2Color, font2Name, bLine2Break);
	}
	// End:0x218
	if(line3text != "")
	{
		ToolTip.DrawList[2] = addDrawItemText(line3text, text3Color, font3Name, bLine3Break);
	}
	return ToolTip;
}

function CustomTooltip MakeTooltipMultiTextByArray(array<DrawItemInfo> drawItemInfoArr, optional int toolTipWidth)
{
	local CustomTooltip ToolTip;

	ToolTip.DrawList = drawItemInfoArr;
	// End:0x2B
	if(toolTipWidth > 0)
	{
		ToolTip.MinimumWidth = toolTipWidth;
	}
	return ToolTip;
}


/**
 *  ?ï¿½Ñ??ï¿?? ?ï¿½Ð§Ñ?ï¿?? ?ï¿½ï¿½?Â°?ï¿½Ñ?ï¿??
 **/
function DrawItemInfo addDrawItemText(string Text, Color TextColor, optional string FontName, optional bool bLineBreak, optional bool oneline, optional int OffsetX, optional int OffsetY, optional int MaxWidth)
{
	local DrawItemInfo Info;
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	Info.eType = DIT_TEXT;
	Info.t_color.R = TextColor.R;
	Info.t_color.G = TextColor.G;
	Info.t_color.B = TextColor.B;
	Info.t_color.A = TextColor.A;
	GetItemTextSectionInfos(Text, FullText, TextInfos);
	// End:0xB1
	if(TextInfos.Length > 0)
	{
		Text = FullText;
		Info.t_SectionList = TextInfos;
	}
	Info.t_strText = Text;
	// End:0xA0
	if(MaxWidth > 0)
	{
		Info.t_MaxWidth = MaxWidth;
	}
	Info.t_bDrawOneLine = oneline;
	Info.bLineBreak = bLineBreak;
	Info.nOffSetX = OffsetX;
	Info.nOffSetY = OffsetY;
	// End:0x100
	if(FontName != "")
	{
		Info.t_strFontName = FontName;
	}

	return Info;
}

function DrawItemInfo addDrawItemText_DIAT_Right(string Text, Color TextColor, optional string FontName, optional bool bLineBreak, optional bool oneline, optional int OffsetX, optional int OffsetY, optional int MaxWidth)
{
	local DrawItemInfo Info;
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	Info.eType = DIT_TEXT;
	Info.t_color.R = TextColor.R;
	Info.t_color.G = TextColor.G;
	Info.t_color.B = TextColor.B;
	Info.t_color.A = TextColor.A;
	GetItemTextSectionInfos(Text, FullText, TextInfos);
	// End:0xB1
	if(TextInfos.Length > 0)
	{
		Text = FullText;
		Info.t_SectionList = TextInfos;
	}
	Info.t_strText = Text;
	// End:0xA0
	if(MaxWidth > 0)
	{
		Info.t_MaxWidth = MaxWidth;
	}
	Info.t_bDrawOneLine = oneline;
	Info.bLineBreak = bLineBreak;
	Info.nOffSetX = OffsetX;
	Info.nOffSetY = OffsetY;
	Info.eAlignType = DIAT_RIGHT;
	// End:0x10D
	if(FontName != "")
	{
		Info.t_strFontName = FontName;
	}
	return Info;	
}

function DrawItemInfo addDrawItemText_DIAT_CENTER(string Text, Color TextColor, optional string FontName, optional bool bLineBreak, optional bool oneline, optional int OffsetX, optional int OffsetY, optional int MaxWidth)
{
	local DrawItemInfo Info;
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	Info.eType = DIT_TEXT;
	Info.t_color.R = TextColor.R;
	Info.t_color.G = TextColor.G;
	Info.t_color.B = TextColor.B;
	Info.t_color.A = TextColor.A;
	GetItemTextSectionInfos(Text, FullText, TextInfos);
	// End:0xB1
	if(TextInfos.Length > 0)
	{
		Text = FullText;
		Info.t_SectionList = TextInfos;
	}
	Info.t_strText = Text;
	// End:0xDC
	if(MaxWidth > 0)
	{
		Info.t_MaxWidth = MaxWidth;
	}
	Info.t_bDrawOneLine = oneline;
	Info.bLineBreak = bLineBreak;
	Info.nOffSetX = OffsetX;
	Info.nOffSetY = OffsetY;
	Info.eAlignType = DIAT_CENTER;
	// End:0x149
	if(FontName != "")
	{
		Info.t_strFontName = FontName;
	}
	return Info;	
}

function DrawItemInfo addDrawItemFormatText(string Text, Color TextColor, optional string FontName, optional bool bLineBreak, optional bool oneline, optional int OffsetX, optional int OffsetY)
{
	local DrawItemInfo Info;

	Info.eType = DIT_FORMATTEXT;
	Info.t_color.R = TextColor.R;
	Info.t_color.G = TextColor.G;
	Info.t_color.B = TextColor.B;
	Info.t_color.A = TextColor.A;
	Info.t_strText = Text;
	Info.t_bDrawOneLine = oneline;
	Info.bLineBreak = bLineBreak;
	Info.nOffSetX = OffsetX;
	Info.nOffSetY = OffsetY;
	// End:0xE5
	if(FontName != "")
	{
		Info.t_strFontName = FontName;
	}
	return Info;
}

function DrawItemInfo addDrawItemTexture(string Texture, optional bool OneLine, optional bool bLineBreak, optional int offSetX, optional int offSetY)
{
	local DrawItemInfo Info;
	Info.eType = DIT_TEXTURE;
	Info.t_bDrawOneLine = OneLine;
	Info.bLineBreak = bLineBreak;
	Info.u_nTextureWidth = 16;
	Info.u_nTextureHeight = 16;
	Info.nOffSetX = offSetX;
	Info.nOffSetY = offSetY;
	Info.u_nTextureUWidth = 32;
	Info.u_nTextureUHeight = 32;
	Info.u_strTexture = Texture;
	
	return Info;
}

function DrawItemInfo addDrawItemTextureCustom(string Texture, optional bool OneLine, optional bool bLineBreak, optional int offSetX, optional int offSetY, optional int u_nTextureWidth, optional int u_nTextureHeight, optional int u_nTextureUWidth, optional int u_nTextureUHeight)
{
	local DrawItemInfo Info;
	Info.eType = DIT_TEXTURE;
	Info.t_bDrawOneLine = OneLine;
	Info.bLineBreak = bLineBreak;
	Info.u_nTextureWidth = u_nTextureWidth;
	Info.u_nTextureHeight = u_nTextureHeight;
	Info.nOffSetX = offSetX;
	Info.nOffSetY = offSetY;
	Info.u_nTextureUWidth = u_nTextureUWidth;
	Info.u_nTextureUHeight = u_nTextureUHeight;
	Info.u_strTexture = Texture;
	
	return Info;
}

function addDrawItemGameItem(out array<DrawItemInfo> drawListArr, ItemInfo Info, optional bool userCount, optional Color tColor, optional int posX, optional int posY, optional int u_nTextureWidth, optional int u_nTextureHeight, optional int u_nTextureUWidth, optional int u_nTextureVHeight)
{
	local Color applyColor;

	// End:0x66
	if(tColor.R == 0 && tColor.G == 0 && tColor.B == 0 && tColor.A == 0)
	{
		applyColor = getInstanceL2Util().White;
	}
	// End:0x71
	else
	{
		applyColor = tColor;
	}
	// End:0x93
	if((u_nTextureWidth + u_nTextureHeight) == 0)
	{
		u_nTextureWidth = 32;
		u_nTextureHeight = 32;
	}
	// End:0xB5
	if((u_nTextureUWidth + u_nTextureVHeight) == 0)
	{
		u_nTextureUWidth = 32;
		u_nTextureVHeight = 32;
	}
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom(Info.IconName, true, false, posX, posY, u_nTextureWidth, u_nTextureHeight, u_nTextureUWidth, u_nTextureVHeight);
	// End:0x13E
	if(Info.IconPanel != "")
	{
		drawListArr[drawListArr.Length] = addDrawItemTextureCustom(Info.IconPanel, true, false, - u_nTextureWidth, 0, u_nTextureHeight, u_nTextureHeight, u_nTextureUWidth, u_nTextureVHeight);
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetItemNameAll(Info), applyColor, "", false, true, 4, u_nTextureHeight / 5);
	// End:0x1B1
	if(userCount)
	{
		drawListArr[drawListArr.Length] = addDrawItemText(" x" $ string(Info.ItemNum), applyColor, "", false, true, 0, u_nTextureHeight / 5);
	}
	drawListArr[drawListArr.Length] = addDrawItemBlank(2);
}

function addDrawItemGameItemColorFul(out array<DrawItemInfo> drawListArr, ItemInfo Info, optional bool userCount, optional Color tColor, optional int posX, optional int posY, optional int u_nTextureWidth, optional int u_nTextureHeight, optional int u_nTextureUWidth, optional int u_nTextureVHeight)
{
	local Color applyColor;

	if(tColor.R == 0 && tColor.G == 0 && tColor.B == 0 && tColor.A == 0)
	{
		applyColor = getInstanceL2Util().White;		
	}
	else
	{
		applyColor = tColor;
	}
	if((u_nTextureWidth + u_nTextureHeight) == 0)
	{
		u_nTextureWidth = 32;
		u_nTextureHeight = 32;
	}
	if((u_nTextureUWidth + u_nTextureVHeight) == 0)
	{
		u_nTextureUWidth = 32;
		u_nTextureVHeight = 32;
	}
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom(Info.IconName, true, false, posX, posY, u_nTextureWidth, u_nTextureHeight, u_nTextureUWidth, u_nTextureVHeight);
	if(Info.IconPanel != "")
	{
		drawListArr[drawListArr.Length] = addDrawItemTextureCustom(Info.IconPanel, true, false, - u_nTextureWidth, 0, u_nTextureHeight, u_nTextureHeight, u_nTextureUWidth, u_nTextureVHeight);
	}
	addDrawItemGameItemNameAll(drawListArr, Info, 4, u_nTextureHeight / 5);
	if(userCount)
	{
		drawListArr[drawListArr.Length] = addDrawItemText(" x" $ string(Info.ItemNum), applyColor, "", false, true, 0, u_nTextureHeight / 5);
	}
	drawListArr[drawListArr.Length] = addDrawItemBlank(2);	
}

function addDrawItemGameItemNameAll(out array<DrawItemInfo> drawListArr, ItemInfo item, optional int posX, optional int posY, optional string FontName)
{
	local string ItemName;
	local Color applyColor;
	local int nAddTooltipItemName, posXAdd, posYadd;

	posXAdd = posX;
	posYadd = posY;
	if(item.Enchanted > 0)
	{
		drawListArr[drawListArr.Length] = addDrawItemText("+" $ string(item.Enchanted), GetColor(170, 110, 230, 255), FontName, false, false, posXAdd, posYadd);
		posXAdd = 0;
		posYadd = 0;
	}
	if(item.IsBlessedItem)
	{
		ItemName = GetSystemString(13403) $ " ";
		drawListArr[drawListArr.Length] = addDrawItemText(ItemName, getInstanceL2Util().Blue, FontName, false, false, posXAdd, posYadd);
		posXAdd = 0;
		posYadd = 0;
	}
	if(getInstanceUIData().getIsLiveServer())
	{
		ItemName = class'UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);		
	}
	else
	{
		ItemName = item.Name;
	}
	nAddTooltipItemName = class'UIDATA_ITEM'.static.GetItemNameClass(item.Id);
	switch(nAddTooltipItemName)
	{
		case 0:
			applyColor = GetColor(137, 137, 137, 255);
			break;
		case 1:
			applyColor = GetColor(230, 230, 230, 255);
			break;
		case 2:
			applyColor = GetColor(255, 251, 4, 255);
			break;
		case 3:
			applyColor = GetColor(240, 68, 68, 255);
			break;
		case 4:
			applyColor = GetColor(33, 164, 255, 255);
			break;
		case 5:
			applyColor = GetColor(255, 0, 255, 255);
			break;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(ItemName, applyColor, FontName, false, false, posXAdd, posYadd);
	if(Len(item.AdditionalName) > 0)
	{
		drawListArr[drawListArr.Length] = addDrawItemText(" " $ item.AdditionalName, GetColor(255, 217, 105, 255), FontName, false, false, posXAdd, posYadd);
	}
}

//?ï¿½Ñ?Â°?Â°??ï¿?? TooltipItem?ï¿½ï¿½? ?ï¿½ï¿½?Â°?ï¿½Ð?Ð¡?ï¿??.
function DrawItemInfo addDrawItemBlank(int Height)
{
	local DrawItemInfo Info;

	Info.eType = DIT_BLANK;
	Info.b_nHeight = Height;

	return Info;
}

// ?ï¿½Ñ??ï¿?? DrawList ?ï¿½ï¿½?Â°?ï¿½Ñ?ï¿??  
function addToolTipDrawList(out CustomTooltip cTooltip, DrawItemInfo DrawItemInfoElement)
{
	cTooltip.DrawList[cTooltip.DrawList.Length] = DrawItemInfoElement;
}


// ?ï¿½ï¿½? Â±Ð§?ï¿½ï¿½?Â±Ð², ?ï¿½Ð¦Ñ?ï¿?? Â»Ð·?ï¿½Ð??Ð¾?ï¿?? ?ï¿½Ñ??ï¿?? Â°?ï¿½Ò????ÂµÂµÂ·ï¿?? ?ï¿½Ñ??ï¿??
function DrawItemInfo AddCrossLineForCustomToolTip(optional int minimum_width)
{
	local DrawItemInfo Info;
	Info.eType = DIT_SPLITLINE;
	Info.u_nTextureWidth = minimum_width;
	Info.u_nTextureHeight = 1;
	Info.u_strTexture = "L2ui_ch3.tooltip_line";
	return Info;
}


function setCustomToolTipMinimumWidth (out CustomTooltip m_Tooltip)
{
	m_Tooltip.MinimumWidth = customToolTipGetMaxWidth(m_Tooltip);
	customToolTipLineWidthRefresh(m_Tooltip);
}

function customToolTipLineWidthRefresh(out CustomTooltip m_Tooltip)
{
	local int i;

	for (i = 0; i < m_Tooltip.DrawList.Length; i++)
	{
		if(m_Tooltip.DrawList[i].eType == DIT_SPLITLINE)
		{
			m_Tooltip.DrawList[i].u_nTextureWidth = m_Tooltip.MinimumWidth;
			
		}
	}
}

function int customToolTipGetMaxWidth(CustomTooltip m_Tooltip) 
{
	local int i, Width, Height, MaxWidth, tmpWidth;

	MaxWidth = m_Tooltip.MinimumWidth;

	for (i = 0 ; i < m_Tooltip.DrawList.Length ; i ++)
	{
		//Debug("getMaxWidth" @ i @ m_Tooltip.DrawList[i].eType);
		
		if(m_Tooltip.DrawList[i].eType == DIT_TEXT || m_Tooltip.DrawList[i].eType == DIT_TEXTLINK)
		{
			//?ï¿½ï¿½? ?ï¿½Ð©Ð?ï¿?? Â¶Â§ ?ï¿½ï¿½? ?ï¿½Ð²Â·ï¿½? Â±Ð§ ?ï¿½Ð¬Ñ???ï¿?? ?ï¿½ÐªÂµï¿½? ÂµÐ¹?ï¿½Â©Ñ??Â±ï¿?? Â±Ð²?ï¿½Ð???Â·ï¿?? ?ï¿½Ñ??ï¿?? Âµ??.
			if(m_Tooltip.DrawList[i].t_bDrawOneLine)
			{
				GetTextSizeDefault(m_Tooltip.DrawList[i].t_strText, Width, Height);
				//bLineBreak ?ï¿½Ñ??ï¿?? Âµ?ï¿½Ð?ï¿?? ?ï¿½Ð??ï¿?? Â°Ð¶?ï¿½ï¿½? ?ï¿½Ð©Ð?ï¿?? ?ï¿½Ð©Â·ï¿½? ?ï¿½Ð¡Ñ?Ð¾Â°??ï¿?? ?ï¿½Ð??ï¿??.
				if(! m_Tooltip.DrawList[i].bLineBreak)
				{
					Width = Width + tmpWidth;
				}
				//Debug ("getMaxWidth2" @ Width @  m_Tooltip.DrawList[i].t_strText);
			}			
		}
		else if (m_Tooltip.DrawList[i].eType == DIT_TEXTURE || m_Tooltip.DrawList[i].eType == DIT_SPLITLINE) 
		{
			// End:0x17F
			if(m_Tooltip.DrawList[i].t_bDrawOneLine)
			{
				Width = m_Tooltip.DrawList[i].u_nTextureWidth;
				if(! m_Tooltip.DrawList[i].bLineBreak)
				{
					Width = tmpWidth + Width;
				}
			}
		}

		Width = Width + m_Tooltip.DrawList[i].nOffSetX;

		if (Width > MaxWidth) MaxWidth = Width;

		tmpWidth = Width;
	}

	return MaxWidth;
}


////////////////////////////////////////////////////////////
//Function For ItemID

static function bool IsValidItemID(ItemID Id)
{
	if(Id.ClassID<1 && Id.ServerID<1)
	{
		return false;
	}
	return true;
}

static function ItemID GetItemID(int Id)
{
	local ItemID cID;
	cID.ClassID = Id;
	return cID;
}

static function ItemInfo GetItemInfoByClassID(int Id)
{
	local ItemID cID;
	local ItemInfo Info;

	cID.ClassID = Id;
	class'UIDATA_ITEM'.static.GetItemInfo(cID, Info);
	return Info;
}

function int getItemCountWithEnchanted(int ClassID, int Enchanted)
{
	local array<ItemInfo> Items;
	local int i, ItemCount;

	GetInstanceL2UIInventory().FindItem(GetItemID(ClassID), Items);

	// End:0x62 [Loop If]
	for(i = 0; i < Items.Length; i++)
	{
		// End:0x58
		if(Enchanted == Items[i].Enchanted)
		{
			++ ItemCount;
		}
	}
	return ItemCount;
}

function bool ParseItemID(string param, out ItemID ID)
{
	local bool bRet1;
	local bool bRet2;
	bRet1 = ParseInt(param, "ClassID", Id.ClassID);
	bRet2 = ParseInt(param, "ServerID", ID.ServerID);
	return bRet1 || bRet2;
}

function bool ParseItemIDWithIndex(string param, out ItemID ID, int idx)
{
	local bool bRet1;
	local bool bRet2;
	bRet1 = ParseInt(param, "ClassID_" $ idx, ID.ClassID);
	bRet2 = ParseInt(param, "ServerID_" $ idx, ID.ServerID);
	return bRet1 || bRet2;
}

function ParamAddItemID(out string param, ItemID ID)
{
	if (ID.ClassID>0)
		ParamAdd(param, "ClassID", string(ID.ClassID));
	if (ID.ServerID>0)
		ParamAdd(param, "ServerID", string(ID.ServerID));
}

function ParamAddItemIDWithIndex(out string param, ItemID Id, int idx)
{
	if(Id.ClassID > 0)
	{
		ParamAdd(param, "ClassID_" $ idx, string(Id.ClassID));
	}
	// End:0x75
	if(Id.ServerID > 0)
	{
		ParamAdd(param, "ServerID_" $ idx, string(Id.ServerID));
	}
}

static function ClearItemID(out ItemID Id)
{
	Id.ClassID = -1;
	Id.ServerID = -1;
}

static function bool IsSameItemID(ItemID src, ItemID des)
{
	if(src.ClassID == des.ClassID && src.ServerID == des.ServerID)
	{
		return true;
	}
	return false;
}

static function bool IsSameClassID(ItemID src, ItemID des)
{
	// End:0x1B
	if(src.ClassID == des.ClassID)
	{
		return true;
	}
	return false;
}

static function bool IsSameServerID(ItemID src, ItemID des)
{
	// End:0x1B
	if(src.ServerID == des.ServerID)
	{
		return true;
	}
	return false;
}

static function bool IsAdena(ItemID Id)
{
	// End:0x13
	if(Id.ClassID == 57)
	{
		return true;
	}
	return false;
}

//branch
function string GetPrimeItemSymbolName()
{
	return "BranchSys.ui.primeitem_symbol";
}
//end of branch

/** 
 * 
 * ?ï¿½Â©ÂµÂµÑ?ï¿?? ?ï¿½Ð??Â§?ï¿?? ?ï¿½ï¿½Ð®?ï¿½Ð??ï¿??.
 * 
 * getCurrentWindowName (string(Self)) 
 * 
 **/
static function string getCurrentWindowName(string targetString)
{
	local array<string> ArrayStr;

	Split(targetString, ".", ArrayStr);
	return ArrayStr[1];
}

static function L2Util getInstanceL2Util()
{
	local L2Util script;

	script = L2Util(GetScript("L2Util"));
	return script;
}

static function InventoryViewer getInstanceInventoryViewer()
{
	local InventoryViewer script;

	script = InventoryViewer(GetScript("InventoryViewer"));
	return script;
}

static function UIData getInstanceUIData()
{
	local UIData script;

	script = UIData(GetScript("UIData"));
	return script;
}

static function NoticeWnd getInstanceNoticeWnd()
{
	local NoticeWnd script;

	script = NoticeWnd(GetScript("NoticeWnd"));
	return script;
}

static function ContextMenu getInstanceContextMenu()
{
	local ContextMenu script;

	script = ContextMenu(GetScript("ContextMenu"));
	return script;
}

static function L2UIColor GTColor()
{
	local L2UIColor script;

	script = L2UIColor(GetScript("L2UIColor"));
	return script;
}

// Â·Ð¡ ?ï¿½Ñ??Ð¤??Â·ï¿?? ?ï¿½Ð????ï¿?? ?ï¿½ï¿½?ï¿½Ð???ï¿?? ?ï¿½ï¿½Ð®?ï¿½ï¿½?.
function int getRollIconNum(EClassRoleType rollType)
{
	switch(rollType)
	{
		// ?ï¿½Ð????ï¿?? (?ï¿½ï¿½Ð¶?ï¿½ï¿½?)
		case ECRT_KNIGHT:
			return 3;
		// ?ï¿½Ñ??ï¿???ï¿½ï¿½? (ÂµÐ°?ï¿½Ñ??Ð¢Âµï¿??) 
		case ECRT_WARRIOR:
			return 8;
		// Â·?ï¿½Â±ï¿½?   (?ï¿½ï¿½?Â°??) 
		case ECRT_ROGUE:
			return 1;
		// ?ï¿½Ð??ï¿??   (?ï¿½ï¿½?) 
		case ECRT_ARCHOR:
			return 2;
		// ?ï¿½Â§Ð?ÐªÂµï¿?? (Â°???ï¿½ï¿½? ?ï¿½Ñ????ï¿??) 
		case ECRT_WIZARD:
			return 5;
		// ?ï¿½ï¿½??ï¿½Ð£Ñ?ï¿?? (?ï¿½Ð¢Ð???ï¿??) 
		case ECRT_SUMMONER:
			return 7;
		// ?ï¿½Ñ?Â·ï¿??   (Â±?ï¿½Ð?ï¿?? ?ï¿½Ñ????ï¿??) 
		case ECRT_ENCHANTER:
			return 4;
		// ?ï¿½Ð??Â¦?ï¿?? (?ï¿½Ñ????ï¿?? Â°??)
		case ECRT_SUPPORT:
			return 6;
		// End:0x4E
		case ECRT_SHAMAN:
			return 10;
		// End:0x56
		case ECRT_BARD:
			return 11;
		// ?ï¿½ï¿½??ï¿½Ð¸Â°ï¿½?
		// End:0x5D
		case ECRT_NOVICE:
			return 1;
		// End:0x65
		case ECRT_DEATHKNIGHT:
			return 12;
		// End:0x6D
		case ECRT_HUNTER:
			return 13;
		// End:0xFFFF
		default:
			return 1;
	}
}

// @fixme : GetClassRoleType() ?ï¿½ï¿½? GetClassTransferDegree(classID) ?ï¿½ï¿½? ?ï¿½Ð??Ð»?Ð¨?ï¿?? ?ï¿½Ð?Â±ï¿?? ?ï¿½Ð??ï¿?? Âµ??. #3008 ?ï¿½Ñ?Â°ï¿?? - y2jinc
function string GetClassRoleIconName(int classID)
{
	local int degree;
	local EClassRoleType rollType;

	rollType = GetClassRoleType(classID) ;
	degree = GetClassTransferDegree(classID) ;

	// ?ï¿½ï¿½??ï¿½Ð¸Â°ï¿½?
	if (rollType == EClassRoleType.ECRT_NOVICE)
		degree = 1;
	else if (rollType == EClassRoleType.ECRT_DEATHKNIGHT && degree == 0)
		degree = 1;
	else if (degree  > 4)
		degree = 4;
	return "L2UI_CH3.PartyWnd.party_styleicon" $ degree $ "_" $ getRollIconNum(rollType);
}

// 20 x 20 ?ï¿½Ñ?Â·ï¿?? ?ï¿½ï¿½? ?ï¿½ï¿½? ?ï¿½ï¿½? Â»Ð·?ï¿½Ð??ï¿??
function string GetClassRoleIconNameBig(int classID)
{
	local int degree;
	local EClassRoleType rollType;

	rollType = GetClassRoleType(classID) ;
	degree = GetClassTransferDegree(classID) ;

	// ?ï¿½ï¿½??ï¿½Ð¸Â°ï¿½?
	if(rollType == EClassRoleType.ECRT_NOVICE)
		degree = 1;
	else if(rollType == EClassRoleType.ECRT_DEATHKNIGHT && degree == 0)
		degree = 1;
	else if(degree  > 4)
		degree = 4;

	return "L2UI_CH3.PartyWnd.party_styleicon" $ degree $ "_" $ getRollIconNum (rollType) $ "_Big";
}

// ?ï¿½Ñ??ï¿?? 4?ï¿½ï¿½? ?ï¿½Ñ????ï¿?? ?ï¿½Ð????Ð¬?ï¿?? ÂµÐ¹?ï¿½Ð¾Â°ï¿½? ?ï¿½Ð¦Ð?ï¿??. (?ï¿½Ð?Â·???ï¿½Ð??ï¿?? 4?ï¿½ï¿½? ?ï¿½Ñ??ï¿?? ?ï¿½ï¿½?Â·?ï¿½Ð???ï¿?? Â»Ð·?ï¿½ï¿½?)
// ?ï¿½Ð?Â·???ï¿½ï¿½? ?ï¿½Ñ??ï¿?? ?ï¿½Ñ??ï¿?? ?ï¿½Ð????ï¿?? == 0 ?ï¿½ï¿½? ?ï¿½Ñ??ï¿?? 
// 1?ï¿½ï¿½? ?ï¿½Ñ??ï¿?? ?ï¿½ï¿½??ï¿½Ð¸Â°ï¿½? ?ï¿½Ð????ï¿??ÂµÂµ ?ï¿½ï¿½?Â°?? ?ï¿½Ð´Ð?ï¿?? ?ï¿½ï¿½?. ?ï¿½Ð»Â±ï¿½? Â»?ï¿½Ð?????ï¿?? ?ï¿½Ò????Ð»ÂµÂµÂ¤ï¿??
function string GetClassArenaRoleIconName(int ClassID)
{
	local EClassRoleType rollType;
	//Debug  ("GetClassArenaRoleIconName" @ classID @ GetClassRoleType(classID));
	rollType = GetClassRoleType(ClassID) ;	
	if (rollType == EClassRoleType.ECRT_NOVICE)
	{
		return "L2UI.TheArena.party_styleicon1_1";
	}
	return "L2UI.TheArena.party_styleicon0_" $ getRollIconNum (GetClassRoleType(ClassID)) ;
}

function Color GetNumericColor(string strCommaAdena)
{
	local Color ResultColor;
	local int l, comma_num, i;

	ResultColor.R = 220;
	ResultColor.G = 220;
	ResultColor.B = 220;
	ResultColor.A = 255;	//AlphaÂ°?? O?ï¿½Ð??ï¿?? FontDrawInfo::ColorÂ°?? ?ï¿½ï¿½Ð­?ï¿½ÂµÂµÐ??ï¿?? ?ï¿½Ð????ï¿??.

	l = Len(strCommaAdena);

	for (i = 0; i < l; ++i)
	{
		// End:0x75
		if(Mid(strCommaAdena, i, 1) == ",")
		{
			++comma_num;
		}
	}

	l -= comma_num;

	if(l < 5)
	{
		return ResultColor;
	}

	l = l-5;
	
	switch(l)
	{
		case 0:
			ResultColor.R = 105;
			ResultColor.G = 255;
			ResultColor.B = 255;
			break;
		case 1:
			ResultColor.R = 255;
			ResultColor.G = 128;
			ResultColor.B = 255;
			break;
		case 2:
			ResultColor.R = 255;
			ResultColor.G = 255;
			ResultColor.B = 0;
			break;
		case 3:
			ResultColor.R = 0;
			ResultColor.G = 255;
			ResultColor.B = 0;
			break;
		case 4:
			ResultColor.R = 255;
			ResultColor.G = 140;
			ResultColor.B = 0;
			break;
		case 5:
			ResultColor.R = 0;
			ResultColor.G = 110;
			ResultColor.B = 255;
			break;
		case 6:
			ResultColor.R = 255;
			ResultColor.G = 0;
			ResultColor.B = 0;
			break;
		case 7:
			ResultColor.R = 150;
			ResultColor.G = 110;
			ResultColor.B = 255;
			break;
	}

	return ResultColor;
}

//---------------------------------------------------------------------------------------------------------------
// HTML TAG , Function 
//
// L2 ?ï¿½Ð??ï¿?? ?ï¿½Ñ??????ï¿?? HTML ?ï¿½ï¿½? ?ï¿½Â¦Ð?Ð¡???ï¿?? 
// WIKI ?ï¿½ï¿½? client Html ?ï¿½ï¿½? ?ï¿½ï¿½? ?ï¿½Ñ?Â°ï¿?? ?ï¿½Ð?Â°ï¿?? ?ï¿½Â¦Ð?ï¿?? ?ï¿½ï¿½? Â°??
//---------------------------------------------------------------------------------------------------------------

// m_HtmlViewer.LoadHtmlFromString("<html><body>" $ strMessage $ "</body></html>");

function string htmlSetHtmlStart(string targetHtml)
{
	return "<html><body>" $ targetHtml $ "</body></html>";
}

/**
 *  Ex) htmlAddItemButton(info.ID.ClassID, 32, 32) $ htmlAddText("?ï¿½Ð§Ð???ï¿?? ?ï¿½Ð§Ð???ï¿??!","hs22", "0xFF0000") $ "<br>" $ htmlAddLineImg()
 **/

/** Tag , Item Button ?ï¿½ï¿½?ï¿½Ð?ï¿?? ?ï¿½Ð????ï¿?? ?ï¿½Ð£Ñ???ï¿?? ?ï¿½ï¿½?ï¿½Ð?ï¿?? ?ï¿½Ð§Â±ï¿½? */
function string htmlAddItemButton(int nItemID, int nWidth, int nHeight)
{
	local string itemTexture;
	local string addItemHtml;

	local itemID cItemID;

	cItemID.ClassID = nItemID;
	itemTexture = class'UIDATA_ITEM'.static.GetItemTextureName(cItemID);

	addItemHtml =  "<button width=" $ nWidth $ " height=" $ nHeight $ " itemtooltip=\"" $ nItemID $ "\"" 
					 $ " High=\"" $ itemTexture $ "\"" $ " back=\"" $ itemTexture $ "\"" $ " fore=\"" $ itemTexture $ "\"> ";

	return addItemHtml;
}

/** 
 *  Tag , Button ?ï¿½ï¿½?ï¿½Ð?ï¿?? 
 *  
 *  Ex) htmlAddButton("?ï¿½Ð??ï¿??", "event inven a=123 b=dongland", 0, 0, 15, 15);
 *  
 **/
function string htmlAddButton(string buttonText, string actionParam, optional int nWidth, optional int nHeight, 
							  optional int buttonAddWidth, optional int buttonAddHeight,
							  optional string textStyle, optional string fontName, optional string fontColor, 
							  optional string backTexture, optional string highTexture, optional string foreTexture)
{
	local string resultHtml, addHtml;
	local int textSizeWidth, textSizeHeight;

	// ?ï¿½Ð¨Ð???ï¿?? Â»Ð·?ï¿½Ð??ï¿?? ?ï¿½Ñ?Â±ï¿??
	if (len(fontName) > 0) GetTextSize(buttonText, fontName, textSizeWidth, textSizeHeight);
	else GetTextSize(buttonText, "GameDefault", textSizeWidth, textSizeHeight);

	// ?ï¿½ï¿½?ï¿½Ð?ï¿?? ?ï¿½Â©Â±ï¿½? ?ï¿½ÐªÂµï¿½? ?ï¿½Ñ??ï¿?? ?ï¿½Â©Ñ?ï¿?? 
	if(nWidth  > 0) addHtml = addHtml $ "width="  $ nWidth  $ " ";
	else addHtml = addHtml $ "width="  $ textSizeWidth + buttonAddWidth $ " ";

	if(nHeight > 0) addHtml = addHtml $ "height=" $ nHeight $ " ";
	else addHtml = addHtml $ "height=" $ textSizeHeight + buttonAddHeight $ " ";

	// ?ï¿½Ñ????ï¿??, ?ï¿½Ñ??ï¿??, ?ï¿½ï¿½?Â¶??
	if (len(textStyle) > 0) addHtml = addHtml $ "textstyle=\"" $ textStyle $ "\" ";
	if (len(fontName)  > 0) addHtml = addHtml $ "fontName=\""  $ fontName  $ "\" ";
	if (len(fontColor) > 0) addHtml = addHtml $ "fontColor=\"" $ fontColor $ "\" ";

	// ?ï¿½ï¿½?ï¿½Ð?ï¿?? ?ï¿½Ð¨Ð???ï¿?? 
	if (len(backTexture) > 0) addHtml = addHtml $ "back=\"" $ backTexture $ "\" ";
	else addHtml = addHtml $ "back=\"L2UI_CT1.Button_DF_Down\" ";

	if (len(highTexture) > 0) addHtml = addHtml $ "high=\"" $ highTexture $ "\" ";
	else addHtml = addHtml $ "high=\"L2UI_CT1.Button_DF_Over\" ";

	if (len(foreTexture) > 0) addHtml = addHtml $ "fore=\"" $ foreTexture $ "\" ";
	else addHtml = addHtml $ "fore=\"L2UI_CT1.Button_DF\" ";

	// EV_EVENT_BY_HTML  ?ï¿½Ð????ï¿??Â·?? ?ï¿½ï¿½Ð¯Â»?ï¿½Ð?ï¿?? ?ï¿½Ð????ï¿?? param ?ï¿½Ñ??ï¿??
	if (len(actionParam) > 0) addHtml = addHtml $ "action=\"" $ actionParam $ "\" ";
	
	resultHtml =  "<button value=\"" $ buttonText $ "\" " $ addHtml $ "> ";

	return resultHtml;
}

/** Tag , Image ?ï¿½Ð§Â±ï¿½? ?ï¿½ï¿½?Â°?? */
function string htmlAddImg(string strTexture, int nWidth, int nHeight)
{
	local string addItemHtml;

	addItemHtml = "<img src=\"" $ strTexture $  "\" width=" $ nWidth $ " height=" $ nHeight $ ">";

	return addItemHtml;
}

/** Tag , line ?ï¿½Ð????ï¿½Ð?ï¿?? ?ï¿½ï¿½?Â°?? */
function string htmlAddLineImg(optional int lineWidth)
{
	if (lineWidth > 0)
		return "<img src=\"L2UI.SquareWhite\" width=" $ lineWidth $ " height=1>";

	return "<img src=\"L2UI.SquareWhite\" width=270 height=1>";
}

/** Tag , ?ï¿½Ð¨Ð???ï¿?? font ?ï¿½Ð§Â±ï¿½? ?ï¿½ï¿½?Â°?? , FontDefinition.xml ?ï¿½Ñ?Â°ï¿?? */
function string htmlAddText(string strText, string fontName, optional string fontColor)
{
	local string targetHtml;
	local string addItemHtml;
	
	if (len(fontColor) > 0) addItemHtml = " color=\"" $ fontColor $ "\" ";

	targetHtml = "<font name=\"" $ fontName $ "\"" $ addItemHtml $ ">" $ strText $ "</font>";

	return targetHtml;
}

/** Tag , ?ï¿½Ð¨Ð???ï¿?? ?ï¿½Ð???Â·ï¿?? ?ï¿½ÂµÐ?ï¿?? (?ï¿½Ð¬Ñ?ï¿??) 
 *
 * <a action="url http://lineage2.plaync.com">link text</a>
 * 
 * htmlUrlLinkText("?ï¿½Ð??Ð´???ï¿??", "http://lineage2.plaync.com");
 * 
 **/
function string htmlUrlLinkText(string strText, string url)
{
	local string targetHtml;

	targetHtml = "<a action=\"url " $ url $ "\"" $ ">" $ strText $ "</a>";
	return targetHtml;
}

/**
	border  pixels  table?ï¿½ï¿½? Â°Ð¶Â°Ð¸?ï¿½ï¿½? Â±?ï¿½Â±ï¿½?  
	width  pixels or %  table?ï¿½ï¿½? width  
	height  pixels or %  table?ï¿½ï¿½? height  
	bgcolor  XXXXXX  table background color : rgb(x,x,x)  
	cellpadding  pixels  space between the cell wall and the cell content  
	cellspacing  pixels  space between cells  
	background  image file name  background image  
 **/
function string htmlSetTable(out string targetHtml, int border, int width, int height, string backgroundTexture, int cellPadding, int cellspacing)
{
	if (backgroundTexture == "")
		targetHtml = "<table width=" $ width $ " height=" $ height $ " border=" $ border $ " cellpadding=" $ cellPadding $ " cellspacing=" $ cellspacing $ "\">" $ targetHtml $ "</table>";
	else
		targetHtml = "<table width=" $ width $ " height=" $ height $ " border=" $ border $  " cellpadding=" $ cellPadding $ " cellspacing=" $ cellspacing $ " background=\""$ backgroundTexture $ "\">" $ targetHtml $  "</table>";
	return targetHtml;
}

/** ?ï¿½Ð§Ð???ï¿?? ?ï¿½ï¿½? ?ï¿½ï¿½?Â°?? */
function string htmlSetTableTR(out string targetHtml)
{
	targetHtml = "<tr> " $ targetHtml $ "</tr>";
	return targetHtml;
}

/** ?ï¿½Ð§Ð???ï¿?? ?ï¿½ï¿½? ?ï¿½ï¿½?Â°?? */
function string htmlAddTableTD(string strText, string alignStr, string vAlignStr, int width, int height, optional string backgroundTexture, optional bool bWidthFix)
{
	local string addItemHtml;
	
	if (len(alignStr)  > 0) addItemHtml = " align="  $ alignStr  $ " ";
	if (len(vAlignStr) > 0) addItemHtml = " valign=" $ vAlignStr $ " " $ addItemHtml;

	// Â°Ð½?ï¿½ï¿½? width , ?ï¿½Ñ?Â·??ï¿?? Â±Ð«?ï¿½ÐªÑ?ï¿?? Âµ?ï¿½Â¶Ñ??ï¿?? ?ï¿½ÐªÂµÑ???Â·ï¿?? ?ï¿½Ð??ï¿?? ?ï¿½ï¿½??ï¿½ï¿½?.
	if (bWidthFix)
	{
		if (width  > 0) addItemHtml = " fixwidth=" $ width $ " " $ addItemHtml;
	}
	else
	{
		if (width  > 0) addItemHtml = " width=" $ width $ " " $ addItemHtml;
	}
	if (height > 0) addItemHtml = " height=" $ height $ " " $ addItemHtml;
	
	if(len(backgroundTexture) > 0) addItemHtml = " background=\"" $ backgroundTexture $ "\" " $ addItemHtml;

	return "<td " $ addItemHtml $">" $ strText $ "</td>";
}
/*
   ex) ?ï¿½Ð§Ð???ï¿?? ?ï¿½â???ï¿½ï¿½?

	htmlAdd= "";

	htmlAdd = htmlAddTableTD(htmlAddText("?ï¿½Ð§Ð???ï¿?? ?ï¿½Ð§Ð???ï¿?? ?ï¿½Â©Ñ???ï¿??!","hs15" , "FF0000"), "Left"  , "center", 40, 0, "", true) $
			  htmlAddTableTD(htmlAddText("?ï¿½Ð§Ð???ï¿?? ?ï¿½Ð§Ð???ï¿?? ?ï¿½Â©Ñ???ï¿??!","hs8"  , "00FF00"), "center", "Bottom", 80, 0, "", true) $ 
			  htmlAddTableTD(htmlAddText("?ï¿½Ð??ï¿???ï¿½ï¿½?"               ,"hs9"  , "00FF43"), "Right" , "Top"   , 30, 0, "") $
			  htmlAddTableTD(htmlAddText("?ï¿½Ð«Ñ?ï¿??"                 ,"hs16" , "00FF00"), "center", "Bottom", 80, 0, "");

	htmlSetTableTR(htmlAdd);
	htmlSetTable(htmlAdd, 1, 280, 0, "FF0000", 0,0);
 
*/

//<table width=481 height=337 border=0 cellpadding=0 cellspacing=0>
//---------------------------------------------------------------------------------------------------------------

/** ?ï¿½Ñ????ï¿?? ?ï¿½Ñ??Ð¤?ï¿?? Âµ?ï¿½Ñ?ï¿?? ?ï¿½Ð§Â±ï¿½? ?ï¿½Ñ??ï¿???ï¿½ï¿½? */
function string getQuestTypeString(int nQuestType)
{
	local string returnStr;

	switch (nQuestType)
	{
		case 0:
			returnStr = GetSystemString(1795);
			break; // ?ï¿½Ñ??ï¿??
		case 1:
			returnStr = GetSystemString(7285);
			break; // ?ï¿½Ñ??ï¿??
		case 2:
			returnStr = GetSystemString(7286);
			break; // Â°?ï¿½Ñ?ï¿??
		case 3:
			returnStr = GetSystemString(7287);
			break; // ?ï¿½Ð´Â»Ñ??ï¿??
		case 4:
			returnStr = GetSystemString(7288);
			break; // ?ï¿½ÂµÐ???ï¿??
		case 5:
			returnStr = GetSystemString(7276);
			break; // ?ï¿½ï¿½??ï¿½ï¿½?
		case 6:
			returnStr = GetSystemString(7277);
			break; // ?ï¿½ï¿½??ï¿½ï¿½? 
		case 8:
			returnStr = GetSystemString(7278);
			break; // ?ï¿½ï¿½Ð­?ï¿½â??
		case 7:
			returnStr = GetSystemString(7279);
			break; // ?ï¿½Ð??ï¿??
		case 9:
			returnStr = GetSystemString(7280);
			break; // ?ï¿½Ð??ï¿??
		case 10:
			returnStr = GetSystemString(7281);
			break; // ?ï¿½ï¿½??ï¿½ï¿½?
		case 11:
			returnStr = GetSystemString(7282);
			break; // ?ï¿½Ñ?ÂµÐµÂ·???ï¿½Ð?Âµï¿??
		case 12:
			returnStr = GetSystemString(7283);
			break; // ?ï¿½Ð??ï¿??
		case 13:
			returnStr = GetSystemString(7284);
			break; // Boss

		default:
			returnStr = ""; // ?ï¿½Â¤Ð?ï¿??[Â±Ð²?ï¿½ï¿½?] ?ï¿½Ñ??ï¿?? ?ï¿½Ð¢Ð???ï¿?? ?ï¿½Ð¦Ð?Â»Â±ï¿?? ?ï¿½Ð¨Ñ?ï¿??..
			break;
	}

	return returnStr;
}

function string br()
{
	return "<br>";
}

function string brPixel(int nWidth, optional int nHeight, optional int vspace)
{
	return gfxHtmlAddImg("L2UI_CT1.EmptyBtn", nWidth, nHeight, vspace);
}

function string gfxHtmlAddText(string strText, optional string FontColor, optional string FontSize)
{
	local string targetHtml;
	local string addItemHtml;

	if (Len(FontColor) > 0)
		addItemHtml = addItemHtml $ "color='" $ FontColor $ "' ";

	if (Len(FontSize) > 0)
		addItemHtml = addItemHtml $ "size='" $ FontSize $ "' ";

	targetHtml = "<font " $ addItemHtml $ ">" $ strText $ "</font>";
	return targetHtml;
}


function string gfxHtmlAddImg (string strTexture, int nWidth, int nHeight, optional int vspace)
{
	local string addItemHtml;

	addItemHtml = "<img src='img://" $ strTexture $ "' width='" $ string(nWidth) $ "' height='" $ string(nHeight) $ "'" $ "'";
	if (vspace != 0)
	{
		addItemHtml = addItemHtml $ " align='baseline'";
		addItemHtml = addItemHtml $ " vspace='" $ string(vspace) $ "'";
	}
	addItemHtml = addItemHtml $ ">";
	return addItemHtml;
}

function string gfxHtmlAddItemTexture(int nItemClassID, int nWidth, int nHeight, optional int vspace)
{
	local string addItemHtml, strTexture;

	strTexture = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(nItemClassID));
	addItemHtml = gfxHtmlAddImg(strTexture, nWidth, nHeight, vspace);
	return addItemHtml;
}

/** 
 *  ?ï¿½Â»Ð?Ð©?ï¿?? ... ?ï¿½Ñ?ÂµÐ¹Â±ï¿??
 *  
 *  ex) makeShortString("?ï¿½Ð??Ð·?????ï¿??!?ï¿½Ð???Âµï¿??", 5, "..");  --> ?ï¿½Ð??Ð·?????ï¿??..  ?ï¿½ï¿½Â®?ï¿½ÐªÑ?ï¿?? ?ï¿½ï¿½??ï¿½ï¿½?
 **/
function string makeShortString(string targetString, int maxChar, string dotString)
{
	local string rStr;

	// End:0x2E
	if(Len(targetString) > maxChar)
	{
		rStr =  Mid(targetString, 0, maxChar) $ dotString;
	}
	else
	{
		rStr = targetString;
	}

	return rStr;
}

function textBoxShortStringWithTooltip(TextBoxHandle textBox, optional bool bUseTooltip, optional int addWidth)
{
	local int textWidth, textHeight, wTextWidth, hTextHeight;
	local string Context;

	Context = textBox.GetText();
	textBox.GetWindowSize(wTextWidth, hTextHeight);
	GetTextSize(Context, "GameDefault", textWidth, textHeight);
	// End:0xAF
	if(textWidth > wTextWidth)
	{
		// End:0x91
		if(bUseTooltip)
		{
			textBox.SetTooltipType("text");
			textBox.SetTooltipText(Context);
		}
		Context = makeShortStringByPixel(Context, (wTextWidth - 8) + addWidth, "..");
	}
	textBox.SetText(Context);
}

function textBoxShortStringLazy(TextBoxHandle targetTextField, string targetString, optional string dotString, optional string FontName)
{
	local string repDotString;

	// End:0x16
	if(dotString == "")
	{
		repDotString = "..";
	}
	targetTextField.SetText(makeShortStringByPixel(targetString, targetTextField.GetRect().nWidth - 4, repDotString, FontName));
}

/***
 * ?ï¿½Ð????ï¿?? Â±Ð²?ï¿½Ð¨Ð??Â·ï¿?? ?ï¿½Â»Ð?Ð©?Ð£?ï¿?? ?ï¿½Ð¡Ò?ï¿??.
 **/
function string makeShortStringByPixel(string targetString, int maxPixel, string dotString, optional string fontName)
{
	local string fixedText, tempStr, prevTempStr;
	local int textWidth, textHeight, prevTextWidth;
	local int dotWidth, dotHeight;
	local int i;

	if (fontName == "") fontName = "GameDefault";

	// ... Â»Ð·?ï¿½Ð??ï¿?? 
	GetTextSize(dotString, fontName, dotWidth, dotHeight);
	GetTextSize(targetString, fontName, textWidth, textHeight);

	if(textWidth <= maxPixel)
	{
		fixedText = targetString;		
	}
	else
	{
		fixedText = targetString;
		for (i = 0; i < len(targetString); i++)
		{
			tempStr = Mid(targetString, 0 , i);

			GetTextSize(tempStr, fontName, textWidth, textHeight);

			prevTextWidth = textWidth;
			prevTempStr = tempStr;

			// .. ?ï¿½Ð©Ð?ï¿?? ?ï¿½ï¿½Â®?ï¿½ÐªÑ?ï¿?? ?ï¿½Ñ?ÂµÐ¹Â±ï¿??!
			if (maxPixel < textWidth + dotWidth)
			{
				if (maxPixel > prevTextWidth + dotWidth)
					fixedText = prevTempStr $ dotString;
				else
					fixedText = tempStr $ dotString;
				break;
			}
		}
	}

	// Debug("fixedText" @ fixedText);
	return fixedText;
}

// ?ï¿½ï¿½Ð¹?ï¿½ï¿½? Â°?ï¿½Ð?ï¿?? 0.00 ...Â°?ï¿½Ð??Â·ï¿?? ?ï¿½ï¿½?Âµ?? ÂµÐ¹?ï¿½ï¿½? ?ï¿½Ð??ï¿?? true
function bool isVectorZero(Vector loc)
{
	if (int(loc.X) == 0 && int(loc.Y) == 0 && int(loc.Z) == 0)
	{
		return true;
	}
	else 
	{
		return false;
	}   
}


/**
 * ?ï¿½ï¿½??ï¿½ï¿½?? ID?ï¿½ï¿½? ?ï¿½Ð¦Ð???ï¿?? -> ?ï¿½Ð¨Ò?ï¿?? ?ï¿½Ð??Ð¦??Â°ï¿?? ?ï¿½Ñ?Â°ï¿?? 
 **/
function setTargetByServerID (int serverID) 
{
	local UserInfo userinfo;

	if (serverID != -1)
	{
		if (GetPlayerInfo(userinfo))
		{
			RequestAction(serverID, userinfo.Loc); // -> HandleTargetUpdate()Â·?? ?ï¿½Ð??Ð¾?ï¿??			
		}
	} 
}

/** ?ï¿½Ñ??Ðª?ï¿?? bool Â·?? ?ï¿½Ð??ï¿?? */
function bool numToBool(int bNum)
{
	// End:0x10
	if(bNum > 0)
	{
		return true;		
	}
	else
	{
		return false;
	}
}

/** bool?ï¿½ï¿½? ?ï¿½Ñ??ÐªÂ·ï¿?? ?ï¿½Ð??ï¿?? */
function int boolToNum(bool Num)
{
	// End:0x0E
	if(Num)
	{
		return 1;		
	}
	else
	{
		return 0;
	}
}

/** ?ï¿½ï¿½?Â¶?? ?ï¿½ï¿½? ?ï¿½ï¿½??ï¿½Ð??Ð¡?ï¿??. */
function Color GetColor(int R, int G, int B, int A)
{
	local Color tColor;

	tColor.R = R;
	tColor.G = G;
	tColor.B = B;
	tColor.A = A;
	return tColor;
}

// ?ï¿½Ð??ï¿?? + AdditionalName
function string GetItemNameWithAdditional(ItemInfo info)
{
	local string fullName, addStr;

	//ensoulOptionAllName = GetEnsoulOptionNameAll(info);

	// ?ï¿½Ð??Â¦?ï¿??, ?ï¿½Ð??ï¿??, AdditionalName
	// if(info.Enchanted > 0) fullName = "+"$ String(info.Enchanted);	

	if (Len(fullName) > 0)
	{
		fullName = fullName $ " " $ info.name;
	}
	else
	{
		FullName = info.Name;
	}

	if (len(info.AdditionalName) > 0) addStr = addStr $ " " $ info.AdditionalName;
	//if (len(ensoulOptionAllName) > 0) addStr = addStr $ " " $ ensoulOptionAllName;

	
	fullName = fullName $ addStr;
	
	return fullName;
}

function string GetItemNameAllByClassID(int ClassID)
{
	local ItemInfo iInfo;

	// End:0x27
	if(! class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(ClassID), iInfo))
	{
		return "";
	}
	return GetItemNameAll(iInfo);
}

function string GetItemNameAllBySeverID(int ServerID)
{
	local ItemInfo Info;
	local string itemNameStr;

	class'UIDATA_INVENTORY'.static.FindItem(ServerID, Info);
	itemNameStr = GetItemNameAll(Info);
	return itemNameStr;
}

// Â±Ð²?ï¿½Â»Ð????Â·ï¿?? Â»Ð·?ï¿½Ð»Ð???ï¿?? Â°?ï¿½Ð?Ð»Âµï¿?? ?ï¿½Ð????ï¿?? ?ï¿½Ð??Â§?ï¿?? ?ï¿½ï¿½??ï¿½Ð??Ð¡?ï¿??.
function string GetItemNameAll (ItemInfo item, optional bool bNoUseAdditionalName)
{
	local string FullName;
	local string refineryStr;

	if (item.Enchanted > 0)
	{
		FullName = "+" $ string(item.Enchanted) $ " ";
	}
	if (item.IsBlessedItem)
	{
		FullName = FullName $ GetSystemString(13403) $ " ";
	}
	if (getInstanceUIData().getIsLiveServer())
	{
		refineryStr = class'UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);		
	}
	else
	{
		refineryStr = item.Name;
	}
	// End:0xD2
	if(Len(FullName) > 0)
	{
		FullName = FullName $ refineryStr;		
	}
	else
	{
		FullName = refineryStr;
	}
	// End:0x116
	if(! bNoUseAdditionalName)
	{
		// End:0x116
		if(Len(item.AdditionalName) > 0)
		{
			FullName = FullName $ " " $ item.AdditionalName;
		}
	}
	return FullName;
}

// ?ï¿½ï¿½Â«Â±Ð²?ï¿½ï¿½? ?ï¿½Ñ??Ð»Âµï¿?? ?ï¿½Ñ????ï¿?? ?ï¿½Ð????ï¿?? ?ï¿½Ð??ï¿?? ?ï¿½Ñ????ï¿?? ?ï¿½ï¿½Ð®?ï¿½Ð????ï¿??.
// ?ï¿½Ñ??????ï¿?? Â»Ð·?ï¿½Ð»Ð??Â·?Â°ï¿?? ?ï¿½Ð??ï¿?? ?ï¿½Ñ?Âµï¿??. 
function string GetEnsoulOptionNameAll(ItemInfo weaponInfo)
{
	local EnsoulOptionUIInfo eOptionInfo;
	local int i, n, cnt, OptionID;

	local string allName;

	// ?ï¿½Ñ??ï¿?? ?ï¿½Ð????ï¿?? Â°?ï¿½Ð?ï¿?? (2015-02-09 ?ï¿½ï¿½?Â°??)
	for(i=EIST_NORMAL; i<EIST_MAX; i++)
	{
		cnt = weaponInfo.EnsoulOption[i - EIST_NORMAL].OptionArray.Length;

		for(n=EISI_START; n<EISI_START + cnt; n++)		
		{
			OptionID = weaponInfo.EnsoulOption[i - EIST_NORMAL].OptionArray[n - EISI_START];

			// [?ï¿½Ð¨Ñ?ï¿?? TTP ?ï¿½Ð£Ð?ï¿??] - 
			// ttp71868 ?ï¿½ï¿½??ï¿½ï¿½? ?ï¿½ï¿½? OptionIDÂ°?? 0?ï¿½Ð??Â©Âµï¿?? ?ï¿½Ñ??ï¿?? ?ï¿½Ð??Â§?ï¿?? ?ï¿½ï¿½??ï¿½â??Âµ?ï¿½Â°ï¿½? ?ï¿½Ð????ï¿?? ?ï¿½ï¿½Â®?ï¿½ï¿½? ?ï¿½Ñ??ï¿??. 
			if (OptionID <= 0) continue;

			GetEnsoulOptionUIInfo(OptionID, eOptionInfo);

			if (eOptionInfo.name != "")
			{
				if (allName == "")	
					allName = eOptionInfo.name;     
				else
					allName = allName $ "/" $ eOptionInfo.name;     
			}
		}
	}

	return allName;
}

// ?ï¿½Ñ??ï¿?? ?ï¿½Ð????ï¿?? ?ï¿½Ñ??Ð¤Âµ??ï¿?? ?ï¿½Ð¦Ñ?ï¿???
function bool hasEnsoulOption(ItemInfo weaponInfo)
{
	local EnsoulOptionUIInfo eOptionInfo;
	local int i, n, cnt, OptionID;


	// ?ï¿½Ñ??ï¿?? ?ï¿½Ð????ï¿?? Â°?ï¿½Ð?ï¿?? (2015-02-09 ?ï¿½ï¿½?Â°??)
	for(i=EIST_NORMAL; i<EIST_MAX; i++)
	{
		cnt = weaponInfo.EnsoulOption[i - EIST_NORMAL].OptionArray.Length;

		for(n=EISI_START; n<EISI_START + cnt; n++)		
		{
			OptionID = weaponInfo.EnsoulOption[i - EIST_NORMAL].OptionArray[n - EISI_START];

			// Debug("OptionID--------------------->" @ OptionID);
			GetEnsoulOptionUIInfo(OptionID, eOptionInfo);
			if (eOptionInfo.name != "")
			{
				return true;
			}
		}
	}

	return false;
}

// ?ï¿½Ñ??ï¿?? ?ï¿½Â¤Ñ?ï¿?? param ?ï¿½Ñ???Â·ï¿?? ?ï¿½ï¿½?Â°?? 2015-03-18
function addParamEnsoulOptionInfo(ItemInfo info, out string param)
{
	local int i, n, cnt;
	for(i=EIST_NORMAL; i<EIST_MAX; i++)
	{
		cnt = info.EnsoulOption[i - EIST_NORMAL].OptionArray.Length;

		ParamAdd(param, "EnsoulOptionNum_" $ String(i), String(cnt));

		for(n=EISI_START; n < EISI_START + cnt; n++)
		{
			ParamAdd(param, "EnsoulOptionID_" $ String(i) $ "_" $ string(n) , String(info.EnsoulOption[i - EIST_NORMAL].OptionArray[n - EISI_START]));
		}
	}
}

// addParamEnsoulOptionInfo ?ï¿½ï¿½Ð­?ï¿½ï¿½?, param String ?ï¿½Ð??ï¿?? infoÂ·?? ?ï¿½Â¤Ñ?ï¿?? ?ï¿½ï¿½?Â°??
function addEnsoulInfoToItemInfoByParamString(string param, out ItemInfo info)
{
	local int i, n, cnt, tmpInt;

	for(i=EIST_NORMAL; i<EIST_MAX; i++)
	{
		ParseInt(param, "EnsoulOptionNum_" $ i, cnt);
		info.EnsoulOption[i - EIST_NORMAL].OptionArray.Length = cnt;

		for(n = EISI_START; n < EISI_START + cnt; n++)
		{
			ParseInt(param, "EnsoulOptionID_" $ String(i) $ "_" $ string(n) , tmpInt);
			info.EnsoulOption[i - EIST_NORMAL].OptionArray[n - EISI_START] = tmpInt;
		}
	}
}

// 9999+ Â°Â°?ï¿½ï¿½? ?ï¿½Ð¦Ò?ï¿?? ?ï¿½Ò????ï¿?? ?ï¿½Â§Ð?ï¿?? ?ï¿½Ð¤Ñ?ï¿??
//EnsoulOptionWnd_Charge3_TextBox.SetText("(" $ maxCountLimitString(InvenJamStoneInfo.ItemNum, 9999, "9999+") $ ")");
function string maxCountLimitString(Int64 Count, Int64 maxCount, string returnStr)
{
	local string RValue;

	if (Count > maxCount)
	{
		RValue = returnStr;
	}
	else
	{
		RValue = string(Count);
	}

	return RValue;
}

function string getSecToDateStr(int Sec, bool onlyDayFlag)
{
	// 86400
	// 1109
	local string returnStr;
	local int RemainSec;
	local int m_timeDay;
	local int m_timeHour;
	local int m_timeMin;

	m_timeDay = Sec / 86400;
	RemainSec = int(Sec % 86400);
	m_timeHour = RemainSec / 60 / 60;
	m_timeMin = int(RemainSec / 60 % 60);
	returnStr = "";
	// End:0x83
	if(m_timeDay > 0)
	{
		returnStr = string(m_timeDay) $ GetSystemString(1109);
	}
	// End:0x168
	if(onlyDayFlag == false)
	{
		// End:0xAB
		if(returnStr != "")
		{
			returnStr = returnStr $ "/";
		}
		// End:0xF5
		if(m_timeHour > 0)
		{
			// End:0xDE
			if(m_timeHour < 10)
			{
				returnStr = returnStr $ "0" $ string(m_timeHour);
			}
			else
			{
				returnStr = returnStr $ string(m_timeHour);
			}
		}
		else
		{
			returnStr = returnStr $ "00";
		}
		// End:0x156
		if(m_timeMin > 0)
		{
			// End:0x13A
			if(m_timeMin < 10)
			{
				returnStr = returnStr $ ":0" $ string(m_timeMin);
			}
			else
			{
				returnStr = returnStr $ ":" $ string(m_timeMin);
			}
		}
		else
		{
			returnStr = returnStr $ ":00";
		}
	}
	return returnStr;
}

// ?ï¿½Ð??ï¿?? ?ï¿½Ð¦Ñ?Ð¾?ï¿??, ?ï¿½ï¿½? ~ 1?ï¿½ï¿½? ?ï¿½ï¿½?ï¿½Ñ?ï¿?? Â±Ð¾?ï¿½ï¿½? ?ï¿½Ò??ï¿?? ?ï¿½Ð??ï¿?? ?ï¿½Ð¤Ñ?ï¿??
function string getStringDayAndTime(int tmpTime)
{
	local int tmpDay;
	local int tmpHou;
	local int tmpMin;	
	local string timeStr;
	
	
	local int minToHou;
	local int minToDay;
	
	minToHou = 60;
	minToDay = minToHou * 24;
	
	tmpMin = tmpTime/60; 

	if (tmpMin > minToDay) {//?ï¿½ï¿½? // ?ï¿½Ð?Â°??ï¿??		
		tmpHou = tmpMin/60;
		tmpDay = tmpHou/24;
		tmpHou = tmpHou - tmpDay*24;	
		if (tmpHou != 0){
			timeStr = MakeFullSystemMsg(GetSystemMessage(3503), (String(tmpDay)), string (tmpHou));
		} else {
			timeStr = MakeFullSystemMsg(GetSystemMessage(3418),  (String(tmpDay)));
		}
	} else if (tmpMin > 60) {//?ï¿½Ð?Â°ï¿?? ?ï¿½Ð??ï¿??
		tmpHou = tmpMin/60;
		tmpMin = tmpMin - tmpHou*60;
		if(tmpMin != 0){
			timeStr = MakeFullSystemMsg(GetSystemMessage(3304), string(tmpHou), string (tmpMin));
		} else {
			timeStr = MakeFullSystemMsg(GetSystemMessage(3406), string(tmpHou));
		}
	} 
	else if (tmpTime > 60) { //?ï¿½Ð??ï¿??
		timeStr = MakeFullSystemMsg(GetSystemMessage(3390), string (tmpMin));
	}
	else { // 1?ï¿½ï¿½? ?ï¿½ï¿½?ï¿½Ñ?ï¿??
		timeStr = MakeFullSystemMsg(GetSystemMessage(4360), string (1));
	}

	return timeStr;
}

// ?ï¿½Ð?Â·???ï¿½ï¿½? Â°?ï¿½Â·ï¿½? ?ï¿½Ñ??Ð§???ï¿?? ?ï¿½Ð?Â°ï¿???
function bool isAreaState()
{
	local string stateStr;
	local bool bReturn;

	stateStr = GetGameStateName();

	// End:0x51
	if(stateStr == "ARENAGAMINGSTATE" || stateStr == "ARENABATTLESTATE")
	{
		bReturn = true;
	}
	else
	{
		bReturn = false;
	}
	return bReturn;
}

	//DOMINION,                    //0
	//FIELD_HUNTING_ZONE_SOLO,     //1
	//FIELD_HUNTING_ZONE_PARTY,    //2
	//INSTANCE_ZONE_SOLO,          //3
	//INSTANCE_ZONE_PARTY,         //4
	//AGIT,                        //5
	//VILLAGE,                     //6
	//ETC,                         //7
	//CASTLE,                      //8
	//FORTRESS,                    //9

function string getHuntingZoneTypeString(int nHuntingZoneType)
{
	local string tmpStr;

	if (nHuntingZoneType == 0)      tmpStr = GetSystemString(1312);  //?ï¿½ÂµÐ?ï¿??
	else if (nHuntingZoneType == 1) tmpStr = GetSystemString(3517);  //?ï¿½Ð¦Â·ï¿½? Â»Ð·?ï¿½Ð??ï¿??
	else if (nHuntingZoneType == 2) tmpStr = GetSystemString(3518);  //?ï¿½Ð??ï¿?? Â»Ð·?ï¿½Ð??ï¿??
	else if (nHuntingZoneType == 3) tmpStr = GetSystemString(3542);  //?ï¿½Ð¦Â·ï¿½? ?ï¿½Ð??????ï¿?? ?ï¿½ï¿½?
	else if (nHuntingZoneType == 4) tmpStr = GetSystemString(3543);  //?ï¿½Ð??ï¿?? ?ï¿½Ð??????ï¿?? ?ï¿½ï¿½?
	else if (nHuntingZoneType == 5) tmpStr = GetSystemString(1317);  //?ï¿½Ð????ï¿??
	else if (nHuntingZoneType == 6) tmpStr = GetSystemString(1270);  //?ï¿½Â¶Ð?ï¿??
	else if (nHuntingZoneType == 7) tmpStr = GetSystemString(7299);  //Â±Ð²?ï¿½ï¿½?
	else if (nHuntingZoneType == 8) tmpStr = GetSystemString(3546);  //?ï¿½ï¿½?
	else if (nHuntingZoneType == 9) tmpStr = GetSystemString(3547);  //?ï¿½Ð´Â»ï¿½?
	else if (nHuntingZoneType == 10) tmpStr = GetSystemString(3548); //?ï¿½Ð¦Â·ï¿½?/?ï¿½Ð??ï¿?? Â»Ð·?ï¿½Ð??ï¿??

	return tmpStr;
}

// Â·?ï¿½ï¿½?ï¿½Ð?Âµï¿?? ?ï¿½Ñ??????ï¿?? ?ï¿½ÂµÐ?ï¿?? ?ï¿½Â¤Ñ???ï¿?? ?ï¿½ï¿½??ï¿½ï¿½?. (?ï¿½ï¿½??ï¿½ï¿½? Â°?ï¿½Ò?????ï¿?? ?ï¿½ï¿½?Â¶?? ?ï¿½Ð????ï¿?? Âµ?ï¿½ï¿½Â·?? ?ï¿½ï¿½?Â¶?ï¿½Â°ï¿½? ?ï¿½Ð???Â°ï¿?? ?ï¿½Ð?Â°Ðª?ï¿??)
// ?ï¿½Ð¤Ñ?ï¿?? ?ï¿½Ð??Â§?ï¿?? ?ï¿½ï¿½? ?ï¿½Ð?Â»????Ð©Â°ï¿?? Â»?ï¿½Â°ï¿½? Âµ??..-_-...
function string getRaidZoneName(int search_zoneid)
{
	local string HuntingZoneName; 
	local int i;

	for(i = 0; i < 500 ; i++)
	{
		//debug("conv_zoneName i=" $ i);
		
		if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i))
		{
			// ?ï¿½ÂµÐ???ï¿?? Â°Â°?ï¿½Ð©Ñ?ï¿??..
			if(class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i) == 0)
			{
				if (class'UIDATA_HUNTINGZONE'.static.GetHuntingZone(i) == search_zoneid)
				{
					HuntingZoneName = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i); 
				}
			}
		}	
	}
	return HuntingZoneName;
}

// Âµ?ï¿½Ð????Â°ï¿?? ?ï¿½ï¿½? ?ï¿½Ð¦Ò??Âµï¿?? ?ï¿½Ð»Â·ï¿½? ?ï¿½Ð??Â¤ÂµÂµ?ï¿?? ?ï¿½ï¿½? Â±?ï¿½Ð?Â¶?????ï¿?? ?ï¿½ï¿½??ï¿½ï¿½? Â°?ï¿½Ò?ï¿??
function bool IsValidDataForHuntingZoneUIData(HuntingZoneUIData info)
{
	if(info.strName == "" && 
	   info.nType == 0 &&
	   info.nMinLevel == 0 &&
	   info.nMaxLevel == 0 &&
	   info.nMinLevel == 0 &&
	   info.nSearchZoneID == 0 &&
	   info.nRegionID == 0 &&
	   info.nNpcID == 0) return false;

	return true;
}

// Â·?ï¿½ï¿½?ï¿½ï¿½? ?ï¿½Ñ??ï¿??
function bool tryLevelCheck(int userLevel, int minLevel, int maxLevel)
{
	if(userLevel >= minLevel && userLevel <= maxLevel) 
	{
		return true;
	}

	return false;
}

// ?ï¿½Â¤Ð?ï¿?? Â°?ï¿½Ð?ï¿?? 0?ï¿½Ð?Â°ï¿???
function bool isVectorZeroXYZ(float x, float y, float z)
{
	if (x == 0 && y == 0 && z == 0)
	{
		return true;
	}

	return false;
}


//------------------------------------------------------------------------------------------------
// ?ï¿½ÐµÐ?ï¿?? ?ï¿½ï¿½? Â°?ï¿½Â·ï¿½? ?ï¿½Ð¤Ñ?ï¿??
//------------------------------------------------------------------------------------------------
function int getHuntingZoneIndexByName(string huntingZoneName)
{
	local int i, r;

	r = -1;
	for (i = 0; i < 500; i++)
	{
		if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i))
		{
			if(class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i) == huntingZoneName)
			{
				r = i;
				break;
			}
		}
	}

	return r;
}

// Â·?ï¿½ï¿½?ï¿½Ð?Âµï¿?? ?ï¿½Â¤Ñ?ï¿?? , Â±?ï¿½Ð?Â¶??Â·ï¿?? ?ï¿½ï¿½Ð®Â±Ð²
function RaidUIData getRaidDataByIndex(int Index)
{
	local RaidUIData pRaidUIData;

	// End:0x129
	if(class'UIDATA_RAID'.static.IsValidData(Index))
	{
		pRaidUIData.Id = Index;
		pRaidUIData.nRaidMonsterID = class'UIDATA_RAID'.static.GetRaidMonsterID(Index);
		pRaidUIData.nRaidMonsterLevel = class'UIDATA_RAID'.static.GetRaidMonsterLevel(Index);
		pRaidUIData.nRaidMonsterZone = class'UIDATA_RAID'.static.GetRaidMonsterZone(Index);
		pRaidUIData.raidDesc = class'UIDATA_RAID'.static.GetRaidDescription(Index);
		pRaidUIData.raidMonsterName = class'UIDATA_NPC'.static.GetNPCName(pRaidUIData.nRaidMonsterID);
		pRaidUIData.nWorldLoc = class'UIDATA_RAID'.static.GetRaidLoc(Index);
		pRaidUIData.RaidMonsterZoneName = getRaidZoneName(pRaidUIData.nRaidMonsterZone);
		class'UIDATA_RAID'.static.GetRaidRecommendLevel(Index, pRaidUIData.nMinLevel, pRaidUIData.nMaxLevel);
	}

	return pRaidUIData;
}

function Vector setVector(int x, int y, int z)
{
	local Vector loc;

	loc.x = x;
	loc.y = y;
	loc.z = z;
	return loc;
}

/**
 *  ?ï¿½Ñ??Â·???ï¿???ï¿½ÂµÐ?Â»?ï¿???ï¿½Ð??Ð¡?ï¿??.
 **/
function string getRaceSystemString(int nRace)
{
	local string returnV;

	switch (nRace)
	{
		case 0  : returnV = GetSystemString(2705);   break; // ?ï¿½ï¿½??ï¿½ï¿½?
		case 1  : returnV = GetSystemString(171);   break;  // ?ï¿½Â¤Ð?ï¿??
		case 2  : returnV = GetSystemString(172);   break;  // ?ï¿½Ð©Ð?Â©?Â¤?ï¿??
		case 3  : returnV = GetSystemString(173);   break;  // ?ï¿½Ð??ï¿??
		case 4  : returnV = GetSystemString(174);   break;  // ÂµÐµ?ï¿½Ñ??ï¿??
		case 5  : returnV = GetSystemString(1544);   break;  // ?ï¿½Â«Ñ?Â¶?ï¿??
		case 6  : returnV = GetSystemString(3273);   break;  // ?ï¿½Ð????Ð§???ï¿??
		case 30:
			returnV = GetSystemString(13536);
			// End:0xCC
			break;
		// End:0xFFFF
		default : returnV = "";
	}

	return returnV;
}

/********************************************************************************************
 * ?ï¿½Ð??ï¿?? ?ï¿½Ð¤Ñ?ï¿?? ÂµÐ¹
 * ******************************************************************************************/
// ?ï¿½Ð????Ð¡?ï¿?? ?ï¿½Ð?Â°ï¿??? ?ï¿½Ð????Ð¡?ï¿?? ?ï¿½Â©ÂµÂµÑ?ï¿?? ?ï¿½Ð??ï¿?? Â·Ð¹?ï¿½Ð??ï¿?? ?ï¿½Â©Ñ?ï¿?? 
function bool IsArtifactRuneItem(ItemInfo info)
{
	local int index;
	//Debug ("IsArtifactRuneItem0:" @ String(info.slotBitType) @ "/" @ String(info.slotBitType) == "18014398509481984" @ "/" @  info.slotBitType == 18014398509481984) ;
	//Debug ("IsArtifactRuneItem1:" @info.slotBitType == 18014398509481984) ;
	//Debug ("IsArtifactRuneItem2:" @info.slotBitType == 144115188075855872) ;
	//Debug ("IsArtifactRuneItem3:" @info.slotBitType == 1152921504606846976) ;
	//Debug ("IsArtifactRuneItem4:" @info.slotBitType == 4398046511104) ;

	switch (info.slotBitType) 
	{
		// ?ï¿½Ð????Ð¡?ï¿?? ?ï¿½Ð???Â·ï¿?? 1
		case INT64("18014398509481984"): // ARTIFACTTYE_TYPE1 :
		// ?ï¿½Ð????Ð¡?ï¿?? ?ï¿½Ð???Â·ï¿?? 2
		case INT64("144115188075855872"): // ARTIFACTTYE_TYPE2 :
		// ?ï¿½Ð????Ð¡?ï¿?? ?ï¿½Ð???Â·ï¿?? 3
		case INT64("1152921504606846976"): // ARTIFACTTYE_TYPE3 :
		// ?ï¿½Ð????Ð¡?ï¿?? ?ï¿½Ð???Ð­Â·Ð¹
		case INT64("4398046511104"): // ARTIFACTTYE_NORMAL :
		case 4398046511104:
		case ARTIFACTTYE_NORMAL:
			return true;
		break;
	}


	//Debug ("IsArtifactItem" @ EItemtype(info.ItemType))  ;
	return false;

}

function uDebug(string debugMsg)
{
	local string params;

	ParamAdd(params, "Type", "3");
	ParamAdd(params, "Msg", getCurrentWindowName(string(Self)) $ DEBUG_SPLIT_STR $ debugMsg);
	// bDoNotUseDebug ?ï¿½ï¿½? ?ï¿½Ð???Â«Â°?ï¿½Âµï¿½? ?ï¿½Ð????ï¿?? false, 
	// Âµ???ï¿½ï¿½?ï¿½Â±Ð»Ð?ï¿?? ?ï¿½Ð??ï¿?? UI?ï¿½ï¿½? ?ï¿½Ð???Â·ï¿?? trueÂ·?? ?ï¿½Ð¨Ð?Ð¦?ï¿?? Âµ???ï¿½ï¿½?ï¿½Â±ï¿½? ?ï¿½ï¿½??ï¿½Ñ??ï¿?? ?ï¿½Ð?????Â°ï¿?? ?ï¿½ï¿½?.
	if (IsBuilderPC()) ExecuteEvent(EV_UIDebugMsg, params);
}

// ?ï¿½ï¿½??ï¿½Ñ??ï¿?? ?ï¿½Ð??ï¿??Â·Ð¡?ï¿½ï¿½? ?ï¿½Ð????ï¿?? Â·?ï¿½Âµï¿½? ?ï¿½Â±Â°ï¿½? 
// ex)
// record.LVDataList[0].arrTexture.Length = 3;
// lvTextureAdd(record.LVDataList[0].arrTexture[0], "L2UI_CT1.SkillWnd.SkillWnd_DF_ListIcon_Reuse", 2, 2, 14, 14);
// lvTextureAdd(record.LVDataList[0].arrTexture[1], "L2UI_CT1.ENCHANTNUMBER_SMALL_plus", 5, 12, 6, 8);
function lvTextureAdd(out LVTexture LVTexture, string texPath, int X, int Y, int nWeight, int nHeight, optional int U, optional int V)
{
	LVTexture.X = X;
	LVTexture.Y = Y;
	LVTexture.Width = nWeight;
	LVTexture.Height = nHeight;
	// End:0x5E
	if(U > 0)
	{
		LVTexture.U = U;		
	}
	else
	{
		LVTexture.U = 0;
	}
	// End:0x88
	if(V > 0)
	{
		LVTexture.V = V;		
	}
	else
	{
		LVTexture.V = 0;
	}

	LVTexture.UL = nWeight;
	LVTexture.VL = nHeight;
	LVTexture.objTex = GetTexture(texPath);
	LVTexture.IsFront = true;
}

// ?ï¿½ï¿½??ï¿½Ñ??ï¿?? ?ï¿½Ð??ï¿??Â·Ð¡?ï¿½ï¿½? ?ï¿½Ð??Â¦?ï¿?? ?ï¿½Ñ??ï¿?? ?ï¿½Ò?????Â±ï¿?? 
// "0" ~ "9"  "plus"
//	record.LVDataList[0].arrTexture.Length = 3;
//	lvTextureAddItemEnchantedTexture(14, record.LVDataList[0].arrTexture[0], record.LVDataList[0].arrTexture[1],record.LVDataList[0].arrTexture[2], 100, 7);
function lvTextureAddItemEnchantedTexture(int nEnchanted, out LVTexture lvTexture1, out LVTexture lvTexture2, out LVTexture lvTexture3, int X, int Y)
{
	local string s1, s2;
	local string ss;

	if(nEnchanted > 0)
	{
		lvTextureAdd(lvTexture1, "L2UI_CT1.ENCHANTNUMBER_SMALL_plus", X, Y, 6, 8);
	}
	// End:0x105
	if (nEnchanted > 9)
	{
		ss = string(nEnchanted);
		s1 = Left(ss, 1);
		s2 = Right(ss, 1);
		lvTextureAdd(lvTexture2, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ s1, X + 6, Y, 6, 8);
		lvTextureAdd(lvTexture3, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ s2, X + 12, Y, 6, 8);
	}
	else if (nEnchanted > 0 && nEnchanted < 10)
	{
		lvTextureAdd(lvTexture2, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ String(nEnchanted), X + 6, Y, 6, 8);
	}
}

// ?ï¿½ï¿½??ï¿½ï¿½?, ?ï¿½Ð??Â¦?ï¿?? ?ï¿½Ñ??ï¿?? ?ï¿½Ò??ï¿??
function lvTextureTreeEnchantedTexture(string treeName, string NodeName, int nEnchanted, int X, int Y)
{
	local L2Util util;

	local string s1, s2;
	local string ss;

	util = L2Util(GetScript("L2Util"));
	
	if(nEnchanted > 0)
	{
		util.TreeInsertTextureNodeItem(treeName, NodeName, "L2UI_CT1.ENCHANTNUMBER_SMALL_plus", 6, 8, X, Y);
	}
	if (nEnchanted > 9)
	{
		ss = string(nEnchanted);
		s1 = Left(ss, 1);
		s2 = Right(ss, 1);

		util.TreeInsertTextureNodeItem(treeName, NodeName, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ s1, 6, 8, 0, Y);
		util.TreeInsertTextureNodeItem(treeName, NodeName, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ s2, 6, 8, 0, Y);
	}
	else if (nEnchanted > 0 && nEnchanted < 10)
	{
		util.TreeInsertTextureNodeItem(treeName, NodeName, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ String(nEnchanted), 6, 8, 0, Y);
	}
}

//----------------------------------------------------------------------------------------------------------------------
// ?ï¿½ï¿½??ï¿½ï¿½? ?ï¿½ï¿½??ï¿½Ñ??ï¿?? ?ï¿½Ð??ï¿??Â·Ð¡
//----------------------------------------------------------------------------------------------------------------------


// ?ï¿½Ð¨Ð?????ï¿?? drawItems?ï¿½ï¿½? ?ï¿½ï¿½?Â°??
function addRichListCtrlString(out array<RichListCtrlDrawItem> drawitems, string Text, optional Color TextColor, optional bool bStrNewLine, optional int nPosX, optional int nPosY, optional string FontName)
{
	local int Index;

	// End:0x1F
	if(drawitems.Length > 0)
	{
		drawitems.Length = drawitems.Length + 1;		
	}
	else
	{
		drawitems.Length = 1;
	}

	Index = drawitems.Length - 1;

	// End:0x47
	if(Index <= -1)
	{
		return;
	}

	drawitems[Index].eType = LCDIT_TEXT;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	drawitems[Index].strInfo = getRichListCtrlString(Text, TextColor, bStrNewLine, FontName);
}

// ?ï¿½Ð¨Ð?????ï¿?? drawItems?ï¿½ï¿½? ?ï¿½ï¿½?Â°??
function addRichListCtrlTexture(out array<RichListCtrlDrawItem> drawitems, string texPath, int nWeight, int nHeight, optional int nPosX, optional int nPosY, optional int U, optional int V)
{
	local int Index;

	// End:0x1F
	if(drawitems.Length > 0)
	{
		drawitems.Length = drawitems.Length + 1;		
	}
	else
	{
		drawitems.Length = 1;
	}
	Index = drawitems.Length - 1;
	// End:0x47
	if(Index <= -1)
	{
		return;
	}
	drawitems[Index].eType = LCDIT_TEXTURE;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	drawitems[Index].texInfo = getRichListCtrlTexture(texPath, nWeight, nHeight, U, V);
}

// ?ï¿½Ð????ï¿?? ?ï¿½Ð??Â¦?ï¿?? ?ï¿½Ñ??ï¿?? (?ï¿½ï¿½??ï¿½ï¿½? ?ï¿½ï¿½??ï¿½Ñ??ï¿?? ?ï¿½ï¿½?)
// ex) addRichListCtrlItemEnchantedTexture(RowData.cellDataList[0].drawitems, data.ItemEnchant, -32, 24); 
function addRichListCtrlItemEnchantedTexture(out array<RichListCtrlDrawItem> drawitems, int nEnchanted, int X, int Y)
{
	local string s1, S2, ss;

	// End:0x47
	if(nEnchanted > 0)
	{
		addRichListCtrlTexture(drawitems, "L2UI_CT1.ENCHANTNUMBER_SMALL_plus", 6, 8, X, Y);
	}
	// End:0xE9
	if(nEnchanted > 9)
	{
		ss = string(nEnchanted);
		s1 = Left(ss, 1);
		S2 = Right(ss, 1);
		addRichListCtrlTexture(drawitems, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ s1, 6, 8);
		addRichListCtrlTexture(drawitems, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ S2, 6, 8);
	}
	else if (nEnchanted > 0 && nEnchanted < 10)
	{
		addRichListCtrlTexture(drawitems, "L2UI_CT1.ENCHANTNUMBER_SMALL_" $ string(nEnchanted), 6, 8);
	}
}

function AddRichListCtrlItem(out array<RichListCtrlDrawItem> drawitems, ItemInfo iInfo, optional int nWidth, optional int nHeight, optional int nPosX, optional int nPosY, optional string TooltipTypeString)
{
	local int Index;

	if(drawitems.Length > 0)
	{
		drawitems.Length = drawitems.Length + 1;
	}
	else
	{
		drawitems.Length = 1;
	}
	Index = drawitems.Length - 1;
	// End:0x47
	if(Index <= -1)
	{
		return;
	}
	drawitems[Index].eType = LCDIT_ITEM;
	if(TooltipTypeString == "")
	{
		TooltipTypeString = "InventoryWithIcon";
	}
	drawitems[Index].TooltipTypeString = TooltipTypeString;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	// End:0xD4
	if(nWidth == 0)
	{
		nWidth = 32;
	}
	// End:0xE7
	if(nHeight == 0)
	{
		nHeight = 32;
	}
	drawitems[Index].ItemInfo.Width = nWidth;
	drawitems[Index].ItemInfo.Height = nHeight;
	drawitems[Index].ItemInfo.ItemInfo = iInfo;
}

function AddRichListCtrlSkill(out array<RichListCtrlDrawItem> drawitems, ItemInfo iInfo, optional int nWidth, optional int nHeight, optional int nPosX, optional int nPosY, optional string TooltipTypeString)
{
	local int Index;

	Index = drawitems.Length;
	// End:0x25
	if(TooltipTypeString == "")
	{
		TooltipTypeString = "Skill";
	}
	AddRichListCtrlItem(drawitems, iInfo, nWidth, nHeight, nPosX, nPosY, TooltipTypeString);
	drawitems[Index].eType = LCDIT_SKILL;
}

function AddRichListCtrlSkillBySkillInfo(out array<RichListCtrlDrawItem> drawitems, SkillInfo sInfo, optional int nWidth, optional int nHeight, optional int nPosX, optional int nPosY, optional string TooltipTypeString)
{
	local int Index;
	local ItemInfo iInfo;

	Index = drawitems.Length;
	// End:0x25
	if(TooltipTypeString == "")
	{
		TooltipTypeString = "Skill";
	}
	class'L2Util'.static.GetSkill2ItemInfo(sInfo, iInfo);
	AddRichListCtrlItem(drawitems, iInfo, nWidth, nHeight, nPosX, nPosY, TooltipTypeString);
	drawitems[Index].eType = LCDIT_SKILL;	
}

function AddRichListCtrlStatusInfo(out array<RichListCtrlDrawItem> drawitems, optional int nWidth, optional int nHeight, optional int nPosX, optional int nPosY, optional bool bNewLine, optional float ForeProgress, optional float OverProgress, optional string Text, optional int nSkinType, optional string FontName, optional Color FontColor)
{
	local int Index;

	// End:0x1F
	if(drawitems.Length > 0)
	{
		drawitems.Length = drawitems.Length + 1;		
	}
	else
	{
		drawitems.Length = 1;
	}
	Index = drawitems.Length - 1;
	// End:0x49
	if(nWidth == 0)
	{
		nWidth = 165;
	}
	// End:0x5C
	if(nHeight == 0)
	{
		nHeight = 20;
	}
	drawitems[Index].eType = LCDIT_STATUS;
	drawitems[Index].statusInfo.Width = nWidth;
	drawitems[Index].statusInfo.Height = nHeight;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	drawitems[Index].statusInfo.bNewLine = bNewLine;
	drawitems[Index].statusInfo.TexWidth = 4;
	drawitems[Index].statusInfo.TexHeight = 15;
	// End:0x399
	if(nSkinType == 1)
	{
		drawitems[Index].statusInfo.sBackLeftTex = "L2UI_EPIC.SuppressWnd.Gauge_Grey_Large_Bg_Left";
		drawitems[Index].statusInfo.sBackCenterTex = "L2UI_EPIC.SuppressWnd.Gauge_Grey_Large_Bg_Center";
		drawitems[Index].statusInfo.sBackRightTex = "L2UI_EPIC.SuppressWnd.Gauge_Grey_Large_Bg_Right";
		drawitems[Index].statusInfo.sForeLeftTex = "L2UI_EPIC.SuppressWnd.Gauge_Grey_Large_left";
		drawitems[Index].statusInfo.sForeCenterTex = "L2UI_EPIC.SuppressWnd.Gauge_Grey_Large_center";
		drawitems[Index].statusInfo.sForeRightTex = "L2UI_EPIC.SuppressWnd.Gauge_Grey_Large_right";
		drawitems[Index].statusInfo.sOverLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
		drawitems[Index].statusInfo.sOverCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
		drawitems[Index].statusInfo.sOverRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";		
	}
	else if(nSkinType == 2)
	{
		drawitems[Index].statusInfo.sBackLeftTex = "l2ui_ct1.Gauges.Gauge_DF_Large_HP_bg_Left";
		drawitems[Index].statusInfo.sBackCenterTex = "l2ui_ct1.Gauges.Gauge_DF_Large_HP_bg_Center";
		drawitems[Index].statusInfo.sBackRightTex = "l2ui_ct1.Gauges.Gauge_DF_Large_HP_bg_Right";
		drawitems[Index].statusInfo.sForeLeftTex = "l2ui_ct1.Gauges.gauge_df_large_hp_left";
		drawitems[Index].statusInfo.sForeCenterTex = "l2ui_ct1.Gauges.gauge_df_large_hp_center";
		drawitems[Index].statusInfo.sForeRightTex = "l2ui_ct1.Gauges.gauge_df_large_hp_right";
		drawitems[Index].statusInfo.sOverLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
		drawitems[Index].statusInfo.sOverCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
		drawitems[Index].statusInfo.sOverRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";			
	}
	else if(nSkinType == 3)
	{
		drawitems[Index].statusInfo.sBackLeftTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_Bg_Left";
		drawitems[Index].statusInfo.sBackCenterTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_Bg_Center";
		drawitems[Index].statusInfo.sBackRightTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_Bg_Right";
		drawitems[Index].statusInfo.sForeLeftTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_left";
		drawitems[Index].statusInfo.sForeCenterTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_center";
		drawitems[Index].statusInfo.sForeRightTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_right";
		drawitems[Index].statusInfo.sOverLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
		drawitems[Index].statusInfo.sOverCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
		drawitems[Index].statusInfo.sOverRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";				
	}
	else
	{
		drawitems[Index].statusInfo.sBackLeftTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_Bg_Left";
		drawitems[Index].statusInfo.sBackCenterTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_Bg_Center";
		drawitems[Index].statusInfo.sBackRightTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_Bg_Right";
		drawitems[Index].statusInfo.sForeLeftTex = "L2UI_EPIC.SuppressWnd.Gauge_Red_Large_left";
		drawitems[Index].statusInfo.sForeCenterTex = "L2UI_EPIC.SuppressWnd.Gauge_Red_Large_center";
		drawitems[Index].statusInfo.sForeRightTex = "L2UI_EPIC.SuppressWnd.Gauge_Red_Large_right";
		drawitems[Index].statusInfo.sOverLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
		drawitems[Index].statusInfo.sOverCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
		drawitems[Index].statusInfo.sOverRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";
	}
	// End:0xB24
	if(FontName == "")
	{
		drawitems[Index].statusInfo.FontName = "GameDefault";		
	}
	else
	{
		drawitems[Index].statusInfo.FontName = FontName;
	}
	// End:0xBA1
	if(FontColor.R == 0 && FontColor.G == 0 && FontColor.B == 0)
	{
		drawitems[Index].statusInfo.FontColor = GTColor().White;		
	}
	else
	{
		drawitems[Index].statusInfo.FontColor = FontColor;
	}
	drawitems[Index].statusInfo.ForeProgress = ForeProgress;
	drawitems[Index].statusInfo.OverProgress = OverProgress;
	drawitems[Index].statusInfo.Text = Text;
}

function AddEllipsisString(out array<RichListCtrlDrawItem> drawitems, string Text, int MaxW, optional Color TextColor, optional bool bStrNewLine, optional bool useDot, optional int nPosX, optional int nPosY, optional string FontName)
{
	local int Len, textW, textH;
	local string Str;
	local bool bEllipsised;

	Str = Text;
	bEllipsised = class'L2Util'.static.GetEllipsisString(Str, MaxW - nPosX);
	// End:0x68
	if(useDot)
	{
		addRichListCtrlString(drawitems, Str, TextColor, bStrNewLine, nPosX, nPosY, FontName);		
	}
	else
	{
		addRichListCtrlString(drawitems, Text, TextColor, bStrNewLine, nPosX, nPosY, FontName);
	}
	// End:0x118
	if(bEllipsised)
	{
		GetTextSizeDefault(Str, textW, textH);
		Len = drawitems.Length;
		addRichListCtrlTexture(drawitems, "L2UI_CT1.EmptyBtn", textW, textH, - textW, 0);
		drawitems[Len].nReservedTooltipID = 99999;
		drawitems[Len].TooltipDesc = Text;
	}
}

// LCDIT_TEXT
// ?ï¿½ï¿½??ï¿½ï¿½? ?ï¿½ï¿½??ï¿½Ñ??ï¿?? ?ï¿½Ð??ï¿??Â·Ð¡?ï¿½ï¿½? ?ï¿½Ñ??ï¿???ï¿½ï¿½? ?ï¿½Ð??Ðº?Â§?ï¿?? return 
function StringDrawItem getRichListCtrlString(string Text, optional Color TextColor, optional bool bStrNewLine, optional string FontName)
{
	local StringDrawItem stringDrawItemInfo;

	stringDrawItemInfo.strData = Text;
	stringDrawItemInfo.strColor = TextColor;
	stringDrawItemInfo.bStrNewLine = bStrNewLine;
	// End:0x4E
	if(FontName != "")
	{
		stringDrawItemInfo.FontName = FontName;
	}

	return stringDrawItemInfo;
}

// LCDIT_TEXTURE
// ?ï¿½ï¿½??ï¿½ï¿½? ?ï¿½ï¿½??ï¿½Ñ??ï¿?? ?ï¿½Ð??ï¿??Â·Ð¡?ï¿½ï¿½? ?ï¿½Ð¨Ð???ï¿?? ?ï¿½Ð??Ðº?Â§?ï¿?? return 
function TextureDrawItem getRichListCtrlTexture(string texPath, int nWeight, int nHeight, optional int UL, optional int VL)
{
	local TextureDrawItem textureDrawItemInfo;

	textureDrawItemInfo.Width = nWeight;
	textureDrawItemInfo.Height = nHeight;
	textureDrawItemInfo.UL = UL;
	textureDrawItemInfo.VL = VL;
	textureDrawItemInfo.sTex = texPath;
	return textureDrawItemInfo;
}

function ButtonDrawItem getRichListCtrlButton(string buttonStrID, string normalTexStr, string pushedTexStr, int nWeight, int nHeight, optional int UL, optional int VL)
{
	local ButtonDrawItem btnDrawItemInfo;

	btnDrawItemInfo.normalTex.Width = nWeight;
	btnDrawItemInfo.normalTex.Height = nHeight;
	btnDrawItemInfo.pushedTex.Width = nWeight;
	btnDrawItemInfo.pushedTex.Height = nHeight;
	btnDrawItemInfo.normalTex.UL = UL;
	btnDrawItemInfo.normalTex.VL = VL;
	btnDrawItemInfo.pushedTex.UL = UL;
	btnDrawItemInfo.pushedTex.VL = VL;
	btnDrawItemInfo.strID = buttonStrID;
	btnDrawItemInfo.normalTex.sTex = normalTexStr;
	btnDrawItemInfo.pushedTex.sTex = pushedTexStr;
	return btnDrawItemInfo;
}

function addRichListCtrlButton(out array<RichListCtrlDrawItem> drawitems, string buttonStrID, optional int nPosX, optional int nPosY, optional string normalTex, optional string pushedTex, optional string highlightTex, optional int nWeight, optional int nHeight, optional int U, optional int V, optional int nReservedTooltipID, optional string TooltipDesc)
{
	local int Index;

	// End:0x1F
	if(drawitems.Length > 0)
	{
		drawitems.Length = drawitems.Length + 1;		
	}
	else
	{
		drawitems.Length = 1;
	}
	Index = drawitems.Length - 1;
	// End:0x47
	if(Index <= -1)
	{
		return;
	}

	drawitems[Index].eType = LCDIT_BUTTON;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	drawitems[Index].nReservedTooltipID = nReservedTooltipID;
	drawitems[Index].TooltipDesc = TooltipDesc;
	drawitems[Index].btnInfo.strID = buttonStrID;
	drawitems[Index].btnInfo.normalTex.sTex = normalTex;
	drawitems[Index].btnInfo.normalTex.Width = nWeight;
	drawitems[Index].btnInfo.normalTex.Height = nHeight;
	drawitems[Index].btnInfo.normalTex.UL = U;
	drawitems[Index].btnInfo.normalTex.VL = V;
	drawitems[Index].btnInfo.pushedTex.sTex = pushedTex;
	drawitems[Index].btnInfo.pushedTex.Width = nWeight;
	drawitems[Index].btnInfo.pushedTex.Height = nHeight;
	drawitems[Index].btnInfo.pushedTex.UL = U;
	drawitems[Index].btnInfo.pushedTex.VL = V;
	drawitems[Index].btnInfo.highlightTex.sTex = highlightTex;
	drawitems[Index].btnInfo.highlightTex.Width = nWeight;
	drawitems[Index].btnInfo.highlightTex.Height = nHeight;
	drawitems[Index].btnInfo.highlightTex.UL = U;
	drawitems[Index].btnInfo.highlightTex.VL = V;
}

function modifyRichListCtrlButton(out array<RichListCtrlDrawItem> drawitems, int drawitemIndex, string buttonStrID, optional int nPosX, optional int nPosY, optional string normalTex, optional string pushedTex, optional string highlightTex, optional int nWeight, optional int nHeight, optional int U, optional int V, optional int nReservedTooltipID, optional string TooltipDesc)
{
	local int Index;

	Index = drawitemIndex;
	// End:0x1C
	if(Index <= -1)
	{
		return;
	}
	drawitems[Index].eType = LCDIT_BUTTON;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	drawitems[Index].nReservedTooltipID = nReservedTooltipID;
	drawitems[Index].TooltipDesc = TooltipDesc;
	drawitems[Index].btnInfo.strID = buttonStrID;
	drawitems[Index].btnInfo.normalTex.sTex = normalTex;
	drawitems[Index].btnInfo.normalTex.Width = nWeight;
	drawitems[Index].btnInfo.normalTex.Height = nHeight;
	drawitems[Index].btnInfo.normalTex.UL = U;
	drawitems[Index].btnInfo.normalTex.VL = V;
	drawitems[Index].btnInfo.pushedTex.sTex = pushedTex;
	drawitems[Index].btnInfo.pushedTex.Width = nWeight;
	drawitems[Index].btnInfo.pushedTex.Height = nHeight;
	drawitems[Index].btnInfo.pushedTex.UL = U;
	drawitems[Index].btnInfo.pushedTex.VL = V;
	drawitems[Index].btnInfo.highlightTex.sTex = highlightTex;
	drawitems[Index].btnInfo.highlightTex.Width = nWeight;
	drawitems[Index].btnInfo.highlightTex.Height = nHeight;
	drawitems[Index].btnInfo.highlightTex.UL = U;
	drawitems[Index].btnInfo.highlightTex.VL = V;	
}


// ?ï¿½Ð????ï¿?? ?ï¿½Ñ?Â·ï¿?? ?ï¿½Â«Ñ?Ð¾?ï¿?? ?ï¿½Ñ????Ð¦Â±ï¿??
function setShowItemCount(out ItemInfo Info)
{
	if (!IsStackableItem(info.ConsumeType) || 
		Info.ID.ClassID == 57 ||        // ?ï¿½Ð?Âµ??ï¿??
		Info.ID.ClassID == 80306 ||     // ?ï¿½Ð½Â·Ð?Âµï¿?? ?ï¿½ÐªÐ?ï¿??
		Info.ID.ClassID == 91663)       // ?ï¿½Â¤Ð?Ðª?ï¿??
		Info.bShowCount = false;
	else
	{
		Info.bShowCount = true;
	}
}

/**
 * ?ï¿½ï¿½?ï¿½Ð?Â°?ï¿?? ?ï¿½Ð¨Ð???ï¿???ï¿½ï¿½? ?ï¿½Ð?Â°Ð¶?Ð¡?ï¿??. ?ï¿½Ð?Â¶ï¿?? ?ï¿½Ð????Ð«???ï¿???ï¿½ÂµÐ?ï¿?? ?ï¿½Ð?ÂµÂ¦???ï¿?? ?ï¿½Ð¦Ñ?ï¿?? ?ï¿½Ð¨Ð???ï¿???ï¿½ï¿½? ?ï¿½Â±Ð???Ð¡?ï¿??
 * 
 * @param
 * controlPath   : xml ?ï¿½Ð??ï¿??Â·Ð¡ Â°Ð¶Â·??
 * texturePath   : ?ï¿½Ð??Â°?ï¿?? Âµ?? ?ï¿½Ð¨Ð???ï¿?? Â°Ð¶Â·??
 * playLoopCount : ?ï¿½Ð·Â»Ñ?Âµ??ï¿?? Â·Ð·?ï¿½ï¿½? ?ï¿½Â«Ñ?Ð¾?ï¿?? 
 * 
 * @return
 * void
 * 
 * @example 
 * animTexturePlay("testWnd.montionTexture", "l2_state_l2_...", 1);
 * 
 * */
function AnimTextureLoopPlay(string controlPath, string texturePath, int playLoopCount)
{
	GetAnimTextureHandle(controlPath).SetTexture(texturePath);
	GetAnimTextureHandle(controlPath).ShowWindow();
	GetAnimTextureHandle(controlPath).SetLoopCount(playLoopCount);
	GetAnimTextureHandle(controlPath).Stop();
	GetAnimTextureHandle(controlPath).Play();
}

// ?ï¿½Ð¦Ò?ï¿?? ?ï¿½Ð¨Ð???ï¿?? 
function AnimTextureStop(AnimTextureHandle animTexture, optional bool bHide)
{
	// End:0x18
	if(bHide)
	{
		animTexture.HideWindow();
	}
	animTexture.Stop();
}

function AnimTexturePlay(AnimTextureHandle animTexture, optional bool bShow, optional int playLoopCount)
{
	// End:0x18
	if(bShow)
	{
		animTexture.ShowWindow();
	}
	// End:0x2E
	if(playLoopCount <= 0)
	{
		playLoopCount = 999999;
	}
	animTexture.SetLoopCount(playLoopCount);
	animTexture.Stop();
	animTexture.Play();
}

function string GetRaceString(int nRace)
{
	local string returnV;

	switch(nRace)
	{
		// End:0x1B
		case 0:
			returnV = "human";
			// End:0xB9
			break;
		// End:0x2D
		case 1:
			returnV = "elf";
			// End:0xB9
			break;
		// End:0x44
		case 2:
			returnV = "darkelf";
			// End:0xB9
			break;
		// End:0x57
		case 3:
			returnV = "orc";
			// End:0xB9
			break;
		// End:0x6C
		case 4:
			returnV = "dwarf";
			// End:0xB9
			break;
		// End:0x82
		case 5:
			returnV = "kamael";
			// End:0xB9
			break;
		// End:0x99
		case 6:
			returnV = "Ertheia";
			// End:0xB9
			break;
		// End:0xAE
		case 30:
			returnV = "sylph";
			// End:0xB9
			break;
		// End:0xFFFF
		default:
			returnV = "";
			break;
	}
	return returnV;
}

function INT64 getInventoryItemNumByClassID(int nItemID)
{
	local array<ItemInfo> itemInfoArray;
	local INT64 ItemCount;

	class'UIDATA_INVENTORY'.static.FindItemByClassID(nItemID, itemInfoArray);
	// End:0x5D
	if(itemInfoArray.Length > 0)
	{
		// End:0x4F
		if(IsStackableItem(itemInfoArray[0].ConsumeType))
		{
			ItemCount = itemInfoArray[0].ItemNum;			
		}
		else
		{
			ItemCount = itemInfoArray.Length;
		}
	}
	return ItemCount;
}

function int EV_PacketID(int nServerPacketID)
{
	return EV_ProtocolBegin + nServerPacketID;
}

function int EV_CustomPacketID(int nServerPacketID)
{
	return EV_CustomProtocolBegin + nServerPacketID;
}

function bool hasEnoughItem(int ItemClassID, INT64 Amount)
{
	local INT64 invenItemCount;

	invenItemCount = getInventoryItemNumByClassID(ItemClassID);
	// End:0x23
	if(Amount <= invenItemCount)
	{
		return true;
	}
	return false;
}

static function L2UIInventoryObjectSimple AddItemListenerSimple(int ClassID, optional int ServerID, optional int Index)
{
	local L2UIInventoryObjectSimple iObject;

	iObject = GetInstanceL2UIInventory().NewObjectSimple(ClassID, ServerID, Index);
	return iObject;
}

static function RemObjectSimpleByObject(L2UIInventoryObjectSimple iObject)
{
	GetInstanceL2UIInventory().RemObjectSimpleByObject(iObject);
}

static function RemItemListenerSimple(int ClassID, optional int ServerID)
{
	GetInstanceL2UIInventory().RemObjectSimple(ClassID, ServerID);
}

static function L2UIInventoryObject AddItemListener(optional int Index)
{
	local L2UIInventoryObject iObject;

	iObject = GetInstanceL2UIInventory().NewObject();
	iObject.Index = Index;
	return iObject;
}

static function L2UIInventory GetInstanceL2UIInventory()
{
	return L2UIInventory(GetScript("L2UIInventory"));
}

static function L2UIInventoryObjectFindByCompare GetObjectFindItemByCompare()
{
	return L2UIInventory(GetScript("L2UIInventory")).L2UIInventoryFindByCompare;
}

static function string fillZeroString(int nLen, string sValue)
{
	local int N, i;
	local string rStr;

	N = nLen - Len(sValue);
	for (i = 0;i < N; i++)
	{
		rStr = "0" $ rStr;
	}
	return rStr $ sValue;
}

static function string getColorHexString(Color tColor)
{
	local string colorStr;

	colorStr = fillZeroString(2, decToHex(tColor.R)) $ fillZeroString(2,decToHex(tColor.G)) $ fillZeroString(2, decToHex(tColor.B));
	return colorStr;
}

static function string decToHex(int Value, optional bool bUse0x)
{
	local string returnString, hexStr;
	local int temp1;

	// End:0x78 [Loop If]
	while(Value != 0)
	{
		temp1 = int(Value % 16);
		Value = Value / 16;
		// End:0x52
		if(temp1 < 10)
		{
			returnString = string(temp1) $ returnString;
		}
		else
		{
			hexStr = Chr(temp1 + 55);
			returnString = hexStr $ returnString;
		}
	}
	// End:0x92
	if(bUse0x)
	{
		returnString = "0x" $ returnString;
	}
	return returnString;
}

static function bool isNullWindow(WindowHandle checkWindowHandle)
{
	local WindowHandle nullWindow;

	// End:0x11
	if(checkWindowHandle == nullWindow)
	{
		return true;
	}
	return false;
}

// SkillInfo.IconType, ?ï¿½Ð§Ð???ï¿?? ?ï¿½Ñ??????ï¿??
static function bool isActiveSkill(int IconType)
{
	local bool B;

	switch(IconType)
	{
		//------------------ ?ï¿½Ð§Ð???ï¿??
		// End:0x0B
		case 0:
		// End:0x0F
		case 1:
		// End:0x14
		case 2:
		// End:0x19
		case 3:
		// End:0x1E
		case 4:
		// End:0x23
		case 5:
		// End:0x28
		case 6:	// ?ï¿½Ð´Â±ï¿½? ?ï¿½Ñ??ï¿??
		// End:0x2D
		case 7:
		// End:0x32
		case 9: // ?ï¿½Ð??ï¿?? ?ï¿½Ñ??ï¿??
		// End:0x37
		case 21:
		// End:0x3C
		case 22:
		// End:0x41
		case 23:
		// End:0x46
		case 24:
		// End:0x4B
		case 25:
		// End:0x50
		case 26:
		// End:0x55
		case 27:
		// End:0x5A
		case 28:
		// End:0x5F
		case 29:
		// End:0x64
		case 30:
		// End:0x69
		case 31:
		// End:0x6E
		case 32:
		// End:0x7E
		case 51: // ?ï¿½Ð????ï¿?? ?ï¿½Ñ??ï¿??
			b = true;
			break;
	}

	return B;
}

function string getSkillTypeString(int nSkillIconType)
{
	local string returnV;

	// End:0x285
	if(IsUseRenewalSkillWnd())
	{
		switch(nSkillIconType)
		{
			// End:0x29
			case 21:
				returnV = GetSystemString(1694);
				// End:0x282
				break;
			// End:0x42
			case 22:
				returnV = GetSystemString(1695);
				// End:0x282
				break;
			// End:0x5B
			case 23:
				returnV = GetSystemString(1555);
				// End:0x282
				break;
			// End:0x74
			case 24:
				returnV = GetSystemString(1552);
				// End:0x282
				break;
			// End:0x8D
			case 25:
				returnV = GetSystemString(14377);
				// End:0x282
				break;
			// End:0xA6
			case 26:
				returnV = GetSystemString(13592);
				// End:0x282
				break;
			// End:0xBF
			case 27:
				returnV = GetSystemString(13593);
				// End:0x282
				break;
			// End:0xD8
			case 28:
				returnV = GetSystemString(13594);
				// End:0x282
				break;
			// End:0xF1
			case 29:
				returnV = GetSystemString(14411);
				// End:0x282
				break;
			// End:0x10A
			case 30:
				returnV = GetSystemString(14415);
				// End:0x282
				break;
			// End:0x123
			case 31:
				returnV = GetSystemString(14354);
				// End:0x282
				break;
			// End:0x13C
			case 32:
				returnV = GetSystemString(1703);
				// End:0x282
				break;
			// End:0x155
			case 33:
				returnV = GetSystemString(13596);
				// End:0x282
				break;
			// End:0x16E
			case 34:
				returnV = GetSystemString(14412);
				// End:0x282
				break;
			// End:0x187
			case 35:
				returnV = GetSystemString(14413);
				// End:0x282
				break;
			// End:0x1A0
			case 36:
				returnV = GetSystemString(14391);
				// End:0x282
				break;
			// End:0x1B9
			case 37:
				returnV = GetSystemString(14379);
				// End:0x282
				break;
			// End:0x1D2
			case 38:
				returnV = GetSystemString(14380);
				// End:0x282
				break;
			// End:0x1EB
			case 39:
				returnV = GetSystemString(14381);
				// End:0x282
				break;
			// End:0x204
			case 40:
				returnV = GetSystemString(14382);
				// End:0x282
				break;
			// End:0x21D
			case 41:
				returnV = GetSystemString(14378);
				// End:0x282
				break;
			// End:0x236
			case 42:
				returnV = GetSystemString(14414);
				// End:0x282
				break;
			// End:0x24F
			case 43:
				returnV = GetSystemString(14388);
				// End:0x282
				break;
			// End:0x268
			case 51:
				returnV = GetSystemString(5896);
				// End:0x282
				break;
			// End:0xFFFF
			default:
				returnV = "Error SkillType";
				break;
		}		
	}
	else
	{
		switch(nSkillIconType)
		{
			// End:0x2A4
			case 0:
				returnV = GetSystemString(1694);
				// End:0x628
				break;
			// End:0x2BC
			case 1:
				returnV = GetSystemString(1695);
				// End:0x628
				break;
			// End:0x2D5
			case 2:
				returnV = GetSystemString(1696);
				// End:0x628
				break;
			// End:0x2EE
			case 3:
				returnV = GetSystemString(13597);
				// End:0x628
				break;
			// End:0x307
			case 4:
				returnV = GetSystemString(13598);
				// End:0x628
				break;
			// End:0x320
			case 5:
				returnV = GetSystemString(1699);
				// End:0x628
				break;
			// End:0x339
			case 6:
				returnV = GetSystemString(1700);
				// End:0x628
				break;
			// End:0x352
			case 7:
				returnV = GetSystemString(1698);
				// End:0x628
				break;
			// End:0x36B
			case 9:
				returnV = GetSystemString(1701);
				// End:0x628
				break;
			// End:0x384
			case 11:
				returnV = GetSystemString(1702);
				// End:0x628
				break;
			// End:0x39D
			case 12:
				returnV = GetSystemString(1703);
				// End:0x628
				break;
			// End:0x3B6
			case 13:
				returnV = GetSystemString(1704);
				// End:0x628
				break;
			// End:0x3CF
			case 14:
				returnV = GetSystemString(1705);
				// End:0x628
				break;
			// End:0x3E8
			case 15:
				returnV = GetSystemString(1699);
				// End:0x628
				break;
			// End:0x401
			case 16:
				returnV = GetSystemString(1700);
				// End:0x628
				break;
			// End:0x41A
			case 17:
				returnV = GetSystemString(3877);
				// End:0x628
				break;
			// End:0x433
			case 18:
				returnV = GetSystemString(3897);
				// End:0x628
				break;
			// End:0x44C
			case 21:
				returnV = GetSystemString(1694);
				// End:0x628
				break;
			// End:0x465
			case 22:
				returnV = GetSystemString(1695);
				// End:0x628
				break;
			// End:0x47E
			case 23:
				returnV = GetSystemString(1555);
				// End:0x628
				break;
			// End:0x497
			case 24:
				returnV = GetSystemString(1552);
				// End:0x628
				break;
			// End:0x4B0
			case 25:
				returnV = GetSystemString(13589);
				// End:0x628
				break;
			// End:0x4C9
			case 26:
				returnV = GetSystemString(1553);
				// End:0x628
				break;
			// End:0x4E2
			case 27:
				returnV = GetSystemString(1554);
				// End:0x628
				break;
			// End:0x4FB
			case 28:
				returnV = GetSystemString(13592);
				// End:0x628
				break;
			// End:0x514
			case 29:
				returnV = GetSystemString(13593);
				// End:0x628
				break;
			// End:0x52D
			case 30:
				returnV = GetSystemString(13594);
				// End:0x628
				break;
			// End:0x546
			case 31:
				returnV = GetSystemString(13595);
				// End:0x628
				break;
			// End:0x55F
			case 32:
				returnV = GetSystemString(3897);
				// End:0x628
				break;
			// End:0x578
			case 35:
				returnV = GetSystemString(1703);
				// End:0x628
				break;
			// End:0x591
			case 36:
				returnV = GetSystemString(1702);
				// End:0x628
				break;
			// End:0x5AA
			case 37:
				returnV = GetSystemString(13596);
				// End:0x628
				break;
			// End:0x5C3
			case 38:
				returnV = GetSystemString(13595);
				// End:0x628
				break;
			// End:0x5DC
			case 39:
				returnV = GetSystemString(1700);
				// End:0x628
				break;
			// End:0x5F5
			case 40:
				returnV = GetSystemString(3897);
				// End:0x628
				break;
			// End:0x60E
			case 51:
				returnV = GetSystemString(5896);
				// End:0x628
				break;
			// End:0xFFFF
			default:
				returnV = "Error SkillType";
				break;
		}
	}
	return returnV;	
}

function string getSkillWeaponString(AttackType eAttackType)
{
	local string returnV;

	// End:0x27
	if(getInstanceUIData().getIsClassicServer())
	{
		returnV = getSkillWeaponStringClassic(eAttackType);		
	}
	else
	{
		returnV = getSkillWeaponStringLive(eAttackType);
	}
	return returnV;
}

function string getSkillWeaponStringClassic(AttackType eAttackType)
{
	local string returnV;

	switch(eAttackType)
	{
		// End:0x0C
		case AT_SWORD:
		// End:0x25
		case AT_BUSTER:
			returnV = GetSystemString(13599);
			// End:0x18A
			break;
		// End:0x3E
		case AT_TWOHANDSWORD:
			returnV = GetSystemString(13601);
			// End:0x18A
			break;
		// End:0x43
		case AT_BLUNT:
		// End:0x5C
		case AT_STAFF:
			returnV = GetSystemString(13600);
			// End:0x18A
			break;
		// End:0x61
		case AT_TWOHANDBLUNT:
		// End:0x7A
		case AT_TWOHANDSTAFF:
			returnV = GetSystemString(2527);
			// End:0x18A
			break;
		// End:0x90
		case AT_DAGGER:
			returnV = GetSystemString(45);
			// End:0x18A
			break;
		// End:0xA6
		case AT_POLE:
			returnV = GetSystemString(46);
			// End:0x18A
			break;
		// End:0xBC
		case AT_BOW:
			returnV = GetSystemString(48);
			// End:0x18A
			break;
		// End:0xD5
		case AT_DUAL:
			returnV = GetSystemString(504);
			// End:0x18A
			break;
		// End:0xEE
		case AT_DUALFIST:
			returnV = GetSystemString(2530);
			// End:0x18A
			break;
		// End:0x107
		case AT_FISHINGROD:
			returnV = GetSystemString(3184);
			// End:0x18A
			break;
		// End:0x120
		case AT_RAPIER:
			returnV = GetSystemString(1648);
			// End:0x18A
			break;
		// End:0x139
		case AT_ANCIENTSWORD:
			returnV = GetSystemString(1650);
			// End:0x18A
			break;
		// End:0x152
		case AT_SHOOTER:
			returnV = GetSystemString(13639);
			// End:0x18A
			break;
		// End:0x157
		case AT_DUALBLUNT:
		// End:0x15C
		case AT_DUALDAGGER:
		// End:0x161
		case AT_CROSSBOW:
		// End:0x166
		case AT_TWOHANDCROSSBOW:
		// End:0x16B
		case AT_FIST:
		// End:0x170
		case AT_PISTOL:
		// End:0x175
		case AT_OWNTHING:
		// End:0x17A
		case AT_FLAG:
		// End:0x187
		case AT_ETC:
			returnV = "";
	}
	return returnV;
}

function string getSkillWeaponStringLive(AttackType eAttackType)
{
	local string returnV;

	switch(eAttackType)
	{
		// End:0x0C
		case AT_SWORD:
		// End:0x25
		case AT_BUSTER:
			returnV = GetSystemString(13599);
			// End:0x1AD
			break;
		// End:0x3E
		case AT_TWOHANDSWORD:
			returnV = GetSystemString(13601);
			// End:0x1AD
			break;
		// End:0x43
		case AT_BLUNT:
		// End:0x5C
		case AT_STAFF:
			returnV = GetSystemString(13600);
			// End:0x1AD
			break;
		// End:0x61
		case AT_TWOHANDBLUNT:
		// End:0x7A
		case AT_TWOHANDSTAFF:
			returnV = GetSystemString(2527);
			// End:0x1AD
			break;
		// End:0x90
		case AT_DAGGER:
			returnV = GetSystemString(45);
			// End:0x1AD
			break;
		// End:0xA6
		case AT_POLE:
			returnV = GetSystemString(46);
			// End:0x1AD
			break;
		// End:0xBC
		case AT_BOW:
			returnV = GetSystemString(48);
			// End:0x1AD
			break;
		// End:0xD5
		case AT_DUAL:
			returnV = GetSystemString(504);
			// End:0x1AD
			break;
		// End:0xDA
		case AT_DUALFIST:
		// End:0xF3
		case AT_FIST:
			returnV = GetSystemString(2530);
			// End:0x1AD
			break;
		// End:0x10C
		case AT_FISHINGROD:
			returnV = GetSystemString(3184);
			// End:0x1AD
			break;
		// End:0x125
		case AT_RAPIER:
			returnV = GetSystemString(1648);
			// End:0x1AD
			break;
		// End:0x12A
		case AT_CROSSBOW:
		// End:0x143
		case AT_TWOHANDCROSSBOW:
			returnV = GetSystemString(1649);
			// End:0x1AD
			break;
		// End:0x15C
		case AT_ANCIENTSWORD:
			returnV = GetSystemString(1650);
			// End:0x1AD
			break;
		// End:0x175
		case AT_DUALDAGGER:
			returnV = GetSystemString(1970);
			// End:0x1AD
			break;
		// End:0x18E
		case AT_DUALBLUNT:
			returnV = GetSystemString(2529);
			// End:0x1AD
			break;
		// End:0x193
		case AT_PISTOL:
		// End:0x198
		case AT_OWNTHING:
		// End:0x19D
		case AT_FLAG:
		// End:0x1AA
		case AT_ETC:
			returnV = "";
	}
	return returnV;
}

function string getSkillTraitString(ESkillTraitType skillTraitType)
{
	local string returnV;

	// End:0x27
	if(getInstanceUIData().getIsClassicServer())
	{
		returnV = getSkillTraitStringClassic(skillTraitType);		
	}
	else
	{
		returnV = getSkillTraitStringLive(skillTraitType);
	}
	return returnV;
}

function string getSkillTraitStringClassic(ESkillTraitType skillTraitType)
{
	local string returnV;

	switch(skillTraitType)
	{
		// End:0x20
		case ESkillTrait_Hold:
			returnV = GetSystemString(13606);
			// End:0x10C
			break;
		// End:0x39
		case ESkillTrait_Infection:
			returnV = GetSystemString(13607);
			// End:0x10C
			break;
		// End:0x52
		case ESkillTrait_Sleep:
			returnV = GetSystemString(13608);
			// End:0x10C
			break;
		// End:0x6B
		case ESkillTrait_Shock:
			returnV = GetSystemString(13609);
			// End:0x10C
			break;
		// End:0x84
		case ESkillTrait_Paralyze:
			returnV = GetSystemString(13610);
			// End:0x10C
			break;
		// End:0x9D
		case ESkillTrait_Seal:
			returnV = GetSystemString(13611);
			// End:0x10C
			break;
		// End:0xB6
		case ESkillTrait_Pull:
			returnV = GetSystemString(13612);
			// End:0x10C
			break;
		// End:0xCF
		case ESkillTrait_Silence:
			returnV = GetSystemString(13613);
			// End:0x10C
			break;
		// End:0xE8
		case ESkillTrait_Fear:
			returnV = GetSystemString(13614);
			// End:0x10C
			break;
		// End:0x101
		case ESkillTrait_SlowDown:
			returnV = GetSystemString(13615);
			// End:0x10C
			break;
		// End:0xFFFF
		default:
			returnV = "";
			break;
	}
	return returnV;
}

function string getSkillTraitStringLive(int nMezType)
{
	local string returnV;

	switch(nMezType)
	{
		// End:0x22
		case 11:
			returnV = GetSystemString(13616);
			// End:0x109
			break;
		// End:0x29
		case 12:
		// End:0x30
		case 1:
		// End:0x37
		case 13:
		// End:0x3E
		case 14:
		// End:0x45
		case 15:
		// End:0x4C
		case 16:
		// End:0x67
		case 17:
			returnV = GetSystemString(13617);
			// End:0x109
			break;
		// End:0x6E
		case 18:
		// End:0x89
		case 19:
			returnV = GetSystemString(13618);
			// End:0x109
			break;
		// End:0x90
		case 3:
		// End:0xAB
		case 20:
			returnV = GetSystemString(13619);
			// End:0x109
			break;
		// End:0xB2
		case 21:
		// End:0xB9
		case 22:
		// End:0xC0
		case 23:
		// End:0xC7
		case 24:
		// End:0xCE
		case 4:
		// End:0xD5
		case 5:
		// End:0xDC
		case 25:
		// End:0xE3
		case 26:
		// End:0xFE
		case 7:
			returnV = GetSystemString(13620);
			// End:0x109
			break;
		// End:0xFFFF
		default:
			returnV = "";
			break;
	}
	return returnV;
}

function string getSkillTargetTypeString(ESkillTargetType skillTargetType)
{
	local string returnV;

	switch(skillTargetType)
	{
		// End:0x0C
		case ESkillTarget_Enemy:
		// End:0x25
		case ESkillTarget_EnemyOnly:
		case ESkillTarget_RealEnemyOnly:
			returnV = GetSystemString(13621);
			// End:0x99
			break;
		// End:0x3E
		case ESkillTarget_EnemyNot:
			returnV = GetSystemString(13622);
			// End:0x99
			break;
		// End:0x57
		case ESkillTarget_Self:
			returnV = GetSystemString(436);
			// End:0x99
			break;
		// End:0x70
		case ESkillTarget_Summon:
			returnV = GetSystemString(505);
			// End:0x99
			break;
		// End:0x75
		case ESkillTarget_Target:
		// End:0x8E
		case ESkillTarget_TargetSelf:
			returnV = GetSystemString(13693);
			// End:0x99
			break;
		// End:0xFFFF
		default:
			returnV = "";
			break;
	}
	return returnV;
}

function string getSkillAffectTypeString(ESkillAffectScope skillAffectObject)
{
	local string returnV;

	switch(skillAffectObject)
	{
		// End:0x20
		case ESkillAffect_Single:
			returnV = GetSystemString(13625);
			// End:0x8F
			break;
		// End:0x39
		case ESkillAffect_Party:
			returnV = GetSystemString(440);
			// End:0x8F
			break;
		// End:0x52
		case ESkillAffect_Pledge:
			returnV = GetSystemString(439);
			// End:0x8F
			break;
		// End:0x57
		case ESkillAffect_Fan:
		// End:0x5C
		case ESkillAffect_PointBlank:
		// End:0x61
		case ESkillAffect_RangeSortByDist:
		// End:0x66
		case ESkillAffect_RangeSortByHp:
		// End:0x6B
		case ESkillAffect_Range:
		// End:0x84
		case ESkillAffect_Square:
        case ESkillAffect_Range_sort_by_block_act:
        case ESkillAffect_Fan_with_relation:
        case ESkillAffect_Point_blank_with_relation:
        case ESkillAffect_Range_with_relation:
        case ESkillAffect_Square_with_relation:
			returnV = GetSystemString(13626);
			// End:0x8F
			break;
		// End:0xFFFF
		default:
			returnV = "";
			break;
	}
	return returnV;
}

function string getSkillEquipNameStr(int SkillID, int Level, int SubLevel)
{
	local ESkillConditionEquipType o_EquipType;
	local string returnStr;
	local array<AttackType> o_ArrWeapons;

	class'UIDATA_SKILL'.static.GetMSCondEquipType(SkillID, Level, SubLevel, o_EquipType);
	switch(o_EquipType)
	{
		// End:0x40
		case SCET_SHIELD:
			returnStr = GetSystemString(231);
			// End:0xA6
			break;
		// End:0xA3
		case SCET_WEAPON:
			class'UIDATA_SKILL'.static.GetMSCondWeapons(SkillID, Level, SubLevel, o_ArrWeapons);
			// End:0x8F
			if(getInstanceUIData().getIsClassicServer())
			{
				returnStr = outputFilterAttackTypeClassic(o_ArrWeapons);				
			}
			else
			{
				returnStr = outputFilterAttackTypeLive(o_ArrWeapons);
			}
			// End:0xA6
			break;
	}
	return returnStr;
}

function string outputFilterAttackTypeLive(array<AttackType> ArrWeapons)
{
	local array<int> condition1, condition2, condition3, condition4, condition5, condition6;

	local string returnStr;
	local int i;

	condition1[condition1.Length] = 1;
	condition1[condition1.Length] = 3;
	condition1[condition1.Length] = 2;
	condition1[condition1.Length] = 4;
	condition1[condition1.Length] = 5;
	condition1[condition1.Length] = 6;
	condition1[condition1.Length] = 7;
	condition1[condition1.Length] = 8;
	condition1[condition1.Length] = 9;
	condition1[condition1.Length] = 14;
	condition1[condition1.Length] = 13;
	condition1[condition1.Length] = 20;
	condition1[condition1.Length] = 23;
	condition2[condition2.Length] = 1;
	condition2[condition2.Length] = 3;
	condition2[condition2.Length] = 2;
	condition3[condition3.Length] = 3;
	condition3[condition3.Length] = 5;
	condition4[condition4.Length] = 6;
	condition4[condition4.Length] = 7;
	condition5[condition5.Length] = 10;
	condition5[condition5.Length] = 14;
	condition6[condition6.Length] = 17;
	condition6[condition6.Length] = 22;

	// End:0x1E8 [Loop If]
	for(i = 0; i < ArrWeapons.Length; i++)
	{
		Debug("ArrWeapons" @ string(i) @ ":" @ string(ArrWeapons[i]));
	}
	// End:0x218
	if(compareAttackType(ArrWeapons, condition1))
	{
		returnStr = returnStr $ "/" $ GetSystemString(13602);
	}
	Debug("ëª¨ë?? ê·¼ì?? ë¬´ê¸° ì²´í??" @ returnStr);
	// End:0x26A
	if(compareAttackType(ArrWeapons, condition2))
	{
		returnStr = returnStr $ "/" $ GetSystemString(13603);
	}
	Debug("?ï¿½ï¿½ï¿??ï¿?? ì²´í??" @ returnStr);
	// End:0x2B4
	if(compareAttackType(ArrWeapons, condition3))
	{
		returnStr = returnStr $ "/" $ GetSystemString(13604);
	}
	Debug("?ï¿½ï¿½ê¸°ë? ì²´í??" @ returnStr);
	// End:0x2FE
	if(compareAttackType(ArrWeapons, condition4))
	{
		returnStr = returnStr $ "/" $ GetSystemString(13605);
	}
	Debug("ï¿???ï¿½ï¿½?ï¿½ï¿½ï¿??  ì²´í??" @ returnStr);
	// End:0x34B
	if(compareAttackType(ArrWeapons, condition5))
	{
		returnStr = returnStr $ "/" $ GetSystemString(2530);
	}
	Debug("ê²©í?¬ë¬´ê¸? ì²´í??" @ returnStr);
	// End:0x397
	if(compareAttackType(ArrWeapons, condition6))
	{
		returnStr = returnStr $ "/" $ GetSystemString(1649);
	}
	Debug("?ï¿½ï¿½ï¿?? ì²´í??" @ returnStr);

	// End:0x3F3 [Loop If]
	for(i = 0; i < ArrWeapons.Length; i++)
	{
		returnStr = returnStr $ "/" $ getSkillWeaponString(ArrWeapons[i]);
	}
	// End:0x417
	if(Len(returnStr) > 0)
	{
		returnStr = Right(returnStr, Len(returnStr) - 1);
	}
	return returnStr;
}

function string outputFilterAttackTypeClassic(array<AttackType> ArrWeapons)
{
	local array<int> condition1, condition2, condition3, condition4, condition5, condition6,
		condition7, condition8;

	local string returnStr;
	local int i;

	condition1[condition1.Length] = 1;
	condition1[condition1.Length] = 3;
	condition1[condition1.Length] = 2;
	condition1[condition1.Length] = 4;
	condition1[condition1.Length] = 5;
	condition1[condition1.Length] = 6;
	condition1[condition1.Length] = 7;
	condition1[condition1.Length] = 14;
	condition1[condition1.Length] = 11;
	condition1[condition1.Length] = 18;
	condition1[condition1.Length] = 16;
	condition1[condition1.Length] = 9;
	condition1[condition1.Length] = 8;
	condition1[condition1.Length] = 13;
	condition1[condition1.Length] = 25;
	condition2[condition2.Length] = 4;
	condition2[condition2.Length] = 6;
	condition2[condition2.Length] = 5;
	condition2[condition2.Length] = 7;
	condition3[condition3.Length] = 1;
	condition3[condition3.Length] = 3;
	condition3[condition3.Length] = 2;
	condition4[condition4.Length] = 1;
	condition4[condition4.Length] = 2;
	condition5[condition5.Length] = 1;
	condition5[condition5.Length] = 3;
	condition6[condition6.Length] = 4;
	condition6[condition6.Length] = 6;
	condition7[condition7.Length] = 5;
	condition7[condition7.Length] = 7;
	condition8[condition8.Length] = 2;
	condition8[condition8.Length] = 5;
	condition8[condition8.Length] = 7;
	// End:0x261
	if(compareAttackType(ArrWeapons, condition1))
	{
		returnStr = returnStr $ "/" $ GetSystemString(2520);
	}
	// End:0x28E
	if(compareAttackType(ArrWeapons, condition3))
	{
		returnStr = returnStr $ "/" $ GetSystemString(43);
	}
	// End:0x2BB
	if(compareAttackType(ArrWeapons, condition4))
	{
		returnStr = returnStr $ "/" $ GetSystemString(43);
	}
	// End:0x2EB
	if(compareAttackType(ArrWeapons, condition5))
	{
		returnStr = returnStr $ "/" $ GetSystemString(13599);
	}
	// End:0x318
	if(compareAttackType(ArrWeapons, condition2))
	{
		returnStr = returnStr $ "/" $ GetSystemString(44);
	}
	// End:0x348
	if(compareAttackType(ArrWeapons, condition6))
	{
		returnStr = returnStr $ "/" $ GetSystemString(13600);
	}
	// End:0x38A
	if(compareAttackType(ArrWeapons, condition8))
	{
		returnStr = returnStr $ "/" $ GetSystemString(13601) $ "/" $ GetSystemString(2527);
	}
	// End:0x3BA
	if(compareAttackType(ArrWeapons, condition7))
	{
		returnStr = returnStr $ "/" $ GetSystemString(2527);
	}

	// End:0x3FE [Loop If]
	for(i = 0; i < ArrWeapons.Length; i++)
	{
		returnStr = returnStr $ "/" $ getSkillWeaponString(ArrWeapons[i]);
	}
	// End:0x422
	if(Len(returnStr) > 0)
	{
		returnStr = Right(returnStr, Len(returnStr) - 1);
	}
	return returnStr;
}

function bool compareAttackType(out array<AttackType> ArrWeapons, array<int> checkArray)
{
	local int i, N;
	local bool isSame;

	// End:0x0E
	if(ArrWeapons.Length == 0)
	{
		return false;
	}

	// End:0x8E [Loop If]
	for(N = 0; N < checkArray.Length; N++)
	{
		isSame = false;

		// End:0x76 [Loop If]
		for(i = 0; i < ArrWeapons.Length; i++)
		{
			// End:0x6C
			if(ArrWeapons[i] == checkArray[N])
			{
				isSame = true;
				// [Explicit Break]
				break;
			}
		}
		// End:0x84
		if(! isSame)
		{
			// [Explicit Break]
			break;
		}
	}
	// End:0x9B
	if(! isSame)
	{
		return false;
	}

	// End:0x109 [Loop If]
	for(N = 0; N < checkArray.Length; N++)
	{
		// End:0xFF [Loop If]
		for(i = 0; i < ArrWeapons.Length; i++)
		{
			// End:0xF5
			if(ArrWeapons[i] == checkArray[N])
			{
				ArrWeapons.Remove(i, 1);
				// [Explicit Break]
				break;
			}
		}
	}
	return true;
}

static function float floatMultiply(float P1, float P2)
{
	local int n1, n2, sum;

	n1 = int(P1 * 1000);
	n2 = int(P2 * 1000);
	sum = n1 * n2;
	return sum / 1000000;
}

function CommonDialogSetScript(string uiControlDialogAsset_path, optional string disable_tex_path, optional bool bUseNeedItem)
{
	local WindowHandle popExpandWnd;
	local UIControlDialogAssets popupExpandScript;

	popExpandWnd = GetWindowHandle(uiControlDialogAsset_path);
	popupExpandScript = class'UIControlDialogAssets'.static.InitScript(popExpandWnd);
	popupExpandScript.SetUseNeedItem(bUseNeedItem);
	// End:0x66
	if(disable_tex_path != "")
	{
		popupExpandScript.SetDisableWindow(GetWindowHandle(disable_tex_path));
	}
}

function UIControlDialogAssets CommonDialogGetScript(string uiControlDialogAsset_path)
{
	return UIControlDialogAssets(GetWindowHandle(uiControlDialogAsset_path).GetScript());
}

function CommonDialogShow(string uiControlDialogAsset_path, string dialogDesc, optional bool bHtml, optional int okButtonString, optional int cancelButtonString, optional Color TextColor)
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = CommonDialogGetScript(uiControlDialogAsset_path);
	popupExpandScript.SetDialogDesc(dialogDesc, okButtonString, cancelButtonString, bHtml, TextColor);
	popupExpandScript.Show();
}


function DBG_SendMessageToChat(string message)
{
	local ChatWnd chatWnd;
	local Color mainColor, subColor;

	if (!IsBuilderPC()) {
		return;
	}

	GetChatWindowHandle("ChatWnd.NormalChat").AddStringToChatWindow("DBG: " $ message, GetColor(255, 221, 102, 255), GetColor(255, 221, 102, 255), 0);
}

function DBG_UI_EVENT(string message)
{
	// 9995
}

function DBG_ShowScreenMessage(string message)
{
	local string strParam;

	if (!IsBuilderPC()) {
		return;
	}

	if(Len(message) <= 0)
	{
		return;
	}

	ParamAdd(strParam, "MsgType", string(1));
	ParamAdd(strParam, "WindowType", string(8));
	ParamAdd(strParam, "FontType", string(1));
	ParamAdd(strParam, "BackgroundType", string(0));
	ParamAdd(strParam, "LifeTime", string(5000));
	ParamAdd(strParam, "AnimationType", string(1));
	ParamAdd(strParam, "Msg", message);
	ParamAdd(strParam, "MsgColorR", string(255));
	ParamAdd(strParam, "MsgColorG", string(150));
	ParamAdd(strParam, "MsgColorB", string(149));
	ExecuteEvent(EV_ShowScreenMessage, strParam);
}

function CommonDialogHide(string uiControlDialogAsset_path)
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = CommonDialogGetScript(uiControlDialogAsset_path);
	popupExpandScript.Hide();
}

function EAutoNextTargetMode GetNextTargetModeOption()
{
	// End:0x6D
	if(getInstanceUIData().getIsClassicServer())
	{
		switch(GetOptionInt("CommunIcation", "NextTargetModeClassic"))
		{
			// End:0x48
			case 0:
				return ANTM_DEFAULT;
			// End:0x4F
			case 1:
				return ANTM_HOSTILE_NPC;
			// End:0x57
			case 2:
				return ANTM_HOSTILE_PC;
			// End:0x5F
			case 3:
				return ANTM_FRIENDLY_NPC;
			// End:0x67
			case 4:
				return ANTM_DEFAULT_AND_COUNTER_ATTACK;
		}
	}
	switch(GetOptionInt("CommunIcation", "NextTargetMode"))
	{
		// End:0x9B
		case 0:
			return ANTM_DEFAULT;
		// End:0xA2
		case 1:
			return ANTM_HOSTILE_NPC;
		// End:0xAA
		case 2:
			return ANTM_HOSTILE_PC;
		// End:0xB2
		case 3:
			return ANTM_FRIENDLY_NPC;
		// End:0xFFFF
		default:
			return ANTM_DEFAULT;
	}
}

function bool isCollectionItem(ItemInfo item)
{
	local array<int> collectionidArray;

	GetCollectionIdByItemId(collectionidArray, item.Id.ClassID);
	// End:0x28
	if(collectionidArray.Length > 0)
	{
		return true;
	}
	return false;
}

function string stringPer(float A, float B)
{
	local string Str, returnStr;
	local array<string> arrSplit;

	Str = string(float(appCeil(((A / B) * 100) * 10)) / 10);
	Split(Str, ".", arrSplit);
	returnStr = (arrSplit[0] $ ".") $ Mid(arrSplit[1], 0, 1);
	return returnStr;
}

function string string0100Per(float A)
{
	local string returnStr;

	// End:0x19
	if(A <= 0)
	{
		returnStr = "0";		
	}
	else if(A >= 100)
	{
		returnStr = "100";			
	}
	else
	{
		returnStr = string(A);
	}
	return returnStr;	
}


function string GetServerMarkNameSmall(int WorldID)
{
	local string Tex;

	Tex = GetServerMarkName(WorldID);
	// End:0x39
	if(Tex == "")
	{
		Tex = "L2UI_CT1.EmptyBtn";		
	}
	else
	{
		Tex = "L2UI_EPIC.DethroneWnd.Crest_" $ Tex;
	}
	return Tex;
}

function string GetServerMark(int WorldID)
{
	local string Tex;

	Tex = GetServerMarkName(WorldID);
	// End:0x39
	if(Tex == "")
	{
		Tex = "L2UI_CT1.EmptyBtn";		
	}
	else
	{
		Tex = "L2UI_EPIC.DethroneWnd.Crest_" $ Tex $ "_Green";
	}
	return Tex;
}

function string GetServerMarkNameTarget(int WorldID, bool bEnemy)
{
	local string Tex;

	Tex = GetServerMarkName(WorldID);
	// End:0x70
	if(bEnemy)
	{
		Tex = "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_DethroneServerIcon_" $ Tex $ "_Red";		
	}
	else
	{
		Tex = "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_DethroneServerIcon_" $ Tex $ "_Blue";
	}
	return Tex;
}

static function string getWorldNameToLocalName(string worldName)
{
	local string UserName;
	local array<string> arr;

	Split(worldName, "_", arr);
	// End:0x2F
	if(arr.Length > 1)
	{
		UserName = arr[0];		
	}
	else
	{
		UserName = worldName;
	}
	return UserName;
}

static function string getWorldServerFullName(string worldName)
{
	local string UserName;
	local int serverNo;
	local array<string> arr;

	Split(worldName, "_", arr);
	// End:0x50
	if(arr.Length > 1)
	{
		serverNo = int(arr[1]);
		UserName = arr[0] $ "_" $ getServerNameByWorldID(serverNo);		
	}
	else
	{
		UserName = worldName;
	}
	return UserName;	
}

static function string getServerNameByWorldID(int ServerWorldID)
{
	local ServerInfoUIData sUiData;

	class'UIDataManager'.static.GetServerInfo(ServerWorldID, sUiData);
	return sUiData.ServerName;
}

static function int getServerExtIdByWorldID(int ServerWorldID)
{
	local ServerInfoUIData sUiData;

	class'UIDataManager'.static.GetServerInfo(ServerWorldID, sUiData);
	return sUiData.ServerExtID;
}

function bool isMyServer(int compareServerID)
{
	local UserInfo Info;

	GetPlayerInfo(Info);
	// End:0x21
	if(Info.nWorldID == compareServerID)
	{
		return true;
	}
	return false;
}

function string GetCenterTable(string htm, int W, int h, optional string Align, optional string VAlign)
{
	// End:0x1A
	if(Align == "")
	{
		Align = "Center";
	}
	// End:0x34
	if(VAlign == "")
	{
		VAlign = "Center";
	}
	htm = htmlAddTableTD(htm, Align, VAlign, W, h);
	htmlSetTableTR(htm);
	htmlSetTable(htm, 0, 0, 0, "", 0, 0);
	return htm;
}

function string GetNameHtmlFull(ItemInfo item)
{
	local string HTML, textureHtml;
	local int W;

	// End:0x2B
	if(item.Enchanted > 0)
	{
		HTML = GetEnchantedHtml(item.Enchanted) $ " ";
	}
	// End:0x51
	if(item.IsBlessedItem)
	{
		HTML = HTML $ GetNameHtmlBress() $ " ";
	}
	HTML = HTML $ GetNameHtml(item);
	// End:0x98
	if(Len(item.AdditionalName) > 0)
	{
		HTML = HTML @ GetNameHtmlAddionalName(item.AdditionalName);
	}
	HTML = htmlAddTableTD(HTML, "Center", "center", 0, 22);
	textureHtml = GetNameHtmlGradeIcon(item.CrystalType, W);
	// End:0x11E
	if(textureHtml != "")
	{
		HTML = HTML $ htmlAddTableTD(" " $ textureHtml, "Center", "Center", W + 5, 22, "", true);
	}
	HTML = htmlSetTableTR(HTML);
	return htmlSetTable(HTML, 0, 0, 16, "", 0, 0);
}

function string GetEnchantedHtml(int Enchanted)
{
	return htmlAddText("+" $ string(Enchanted), "GameDefault", "AA6EE6");
}

function string GetNameHtmlBress()
{
	return htmlAddText(GetSystemString(13403), "GameDefault", "7A96AB");
}

function string GetNameHtml(ItemInfo item)
{
	local string ItemName, collorString;

	// End:0x52
	if(class'UIData'.static.Inst().getIsLiveServer())
	{
		ItemName = class'UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);		
	}
	else
	{
		ItemName = item.Name;
	}
	switch(class'UIDATA_ITEM'.static.GetItemNameClass(item.Id))
	{
		// End:0x92
		case 0:
			collorString = "5F5F5F";
			// End:0x102
			break;
		// End:0xA7
		case 1:
			collorString = "FFFFFF";
			// End:0x102
			break;
		// End:0xBD
		case 2:
			collorString = "FFA904";
			// End:0x102
			break;
		// End:0xD3
		case 3:
			collorString = "F04444";
			// End:0x102
			break;
		// End:0xE9
		case 4:
			collorString = "21A4FF";
			// End:0x102
			break;
		// End:0xFF
		case 5:
			collorString = "FF00FF";
			// End:0x102
			break;
	}
	return htmlAddText(ItemName, "GameDefault", collorString);
}

function string GetNameHtmlAddionalName(string AdditionalName)
{
	return htmlAddText(AdditionalName, "GameDefault", getColorHexString(GetColor(255, 217, 105, 255)));
}

function string GetNameHtmlGradeIcon(int nCrystalType, out int W)
{
	local int h;
	local string gradeTextureName;

	gradeTextureName = GetItemGradeTextureName(nCrystalType);
	// End:0x20
	if(gradeTextureName == "")
	{
		return "";
	}
	// End:0x81
	if(nCrystalType == 6 || nCrystalType == 7 || nCrystalType == 9 || nCrystalType == 10 || nCrystalType == 11)
	{
		W = 32;
		h = 16;		
	}
	else
	{
		W = 16;
		h = 16;
	}
	return htmlAddImg(gradeTextureName, W, h);
}

function string cutZeroDecimalStr(string Probability)
{
	local int i;
	local array<string> arrSplit;

	// End:0x95
	if(float(int(Probability)) < float(Probability))
	{
		Split(Probability, ".", arrSplit);

		// End:0x7F [Loop If]
		for(i = Len(arrSplit[1]); i > 0; i--)
		{
			// End:0x75
			if(Mid(arrSplit[1], i - 1, 1) != "0")
			{
				arrSplit[1] = Left(arrSplit[1], i);
				// [Explicit Break]
				break;
			}
		}
		return arrSplit[0] $ "." $ arrSplit[1];
	}
	return string(int(Probability));
}

function string cutZeroDecimalFloat(float Probability)
{
	local int i;
	local array<string> arrSplit;

	// End:0x95
	if(float(int(Probability)) < Probability)
	{
		Split(string(Probability), ".", arrSplit);
		
		// End:0x7F [Loop If]
		for(i = Len(arrSplit[1]); i > 0; i--)
		{
			// End:0x75
			if(Mid(arrSplit[1], i - 1, 1) != "0")
			{
				arrSplit[1] = Left(arrSplit[1], i);
				// [Explicit Break]
				break;
			}
		}
		return (arrSplit[0] $ ".") $ arrSplit[1];
	}
	return string(int(Probability));
}

function INT64 MAX64(INT64 A, INT64 B)
{
	// End:0x16
	if(A > B)
	{
		return A;
	}
	return B;
}

function setWindowTitleByString(string windowTitleStr)
{
	// End:0x6B
	if(GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".FrameHeaderWnd.FrameTitle_txt").m_pTargetWnd == none)
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).SetWindowTitle(windowTitleStr);		
	}
	else
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".FrameHeaderWnd.FrameTitle_txt").SetText(windowTitleStr);
	}	
}

function setWindowTitleBySysStringNum(int windowTitleSysStringNum)
{
	// End:0x71
	if(GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".FrameHeaderWnd.FrameTitle_txt").m_pTargetWnd == none)
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).SetWindowTitle(GetSystemString(windowTitleSysStringNum));		
	}
	else
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".FrameHeaderWnd.FrameTitle_txt").SetText(GetSystemString(windowTitleSysStringNum));
	}	
}

function AnimTextureHandle GetMeAnimTexture(string Path)
{
	return GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function BarHandle GetMeBar(string Path)
{
	return GetBarHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function ButtonHandle GetMeButton(string Path)
{
	return GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function CharacterViewportWindowHandle GetMeCharacterViewportWindow(string Path)
{
	return GetCharacterViewportWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function ChatWindowHandle GetMeChatWindow(string Path)
{
	return GetChatWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function CheckBoxHandle GetMeCheckBox(string Path)
{
	return GetCheckBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function ComboBoxHandle GetMeComboBox(string Path)
{
	return GetComboBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function DrawPanelHandle GetMeDrawPanel(string Path)
{
	return GetDrawPanelHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function EditBoxHandle GetMeEditBox(string Path)
{
	return GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function EffectViewportWndHandle GetMeEffectViewportWnd(string Path)
{
	return GetEffectViewportWndHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function HtmlHandle GetMeHtml(string Path)
{
	return GetHtmlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function ItemWindowHandle GetMeItemWindow(string Path)
{
	return GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function ListBoxHandle GetMeListBox(string Path)
{
	return GetListBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function ListCtrlHandle GetMeListCtrl(string Path)
{
	return GetListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function MinimapCtrlHandle GetMeMinimapCtrl(string Path)
{
	return GetMinimapCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function MultiEditBoxHandle GetMeMultiEditBox(string Path)
{
	return GetMultiEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function NameCtrlHandle GetMeNameCtrl(string Path)
{
	return GetNameCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function ProgressCtrlHandle GetMeProgressCtrl(string Path)
{
	return GetProgressCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function PropertyControllerHandle GetMePropertyController(string Path)
{
	return GetPropertyControllerHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function RadarMapCtrlHandle GetMeRadarMapCtrl(string Path)
{
	return GetRadarMapCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function RadioButtonHandle GetMeRadioButton(string Path)
{
	return GetRadioButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function RichListCtrlHandle GetMeRichListCtrl(string Path)
{
	return GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function SliderCtrlHandle GetMeSliderCtrl(string Path)
{
	return GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function StatusBarHandle GetMeStatusBar(string Path)
{
	return GetStatusBarHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function StatusRoundHandle GetMeStatusRound(string Path)
{
	return GetStatusRoundHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function TabHandle GetMeTab(string Path)
{
	return GetTabHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function TextBoxHandle GetMeTextBox(string Path)
{
	return GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function TextureHandle GetMeTexture(string Path)
{
	return GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function TreeHandle GetMeTree(string Path)
{
	return GetTreeHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function WebBrowserHandle GetMeWebBrowser(string Path)
{
	return GetWebBrowserHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function WindowHandle GetMeWindow(optional string Path)
{
	// End:0x21
	if(Path == "")
	{
		return GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath);
	}
	return GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ Path);	
}

function string selfName(optional string addStringPath)
{
	// End:0x1B
	if(addStringPath == "")
	{
		return m_hOwnerWnd.m_WindowNameWithFullPath;
	}
	return m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ addStringPath;	
}

function closeUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).HideWindow();	
}

function ItemInfo getSkillToItemInfo(SkillInfo rSkilInfo)
{
	local ItemInfo infItem;

	infItem.Id.ClassID = rSkilInfo.SkillID;
	infItem.Level = rSkilInfo.SkillLevel;
	infItem.SubLevel = rSkilInfo.SkillSubLevel;
	infItem.Name = rSkilInfo.SkillName;
	infItem.IconName = rSkilInfo.TexName;
	infItem.IconPanel = rSkilInfo.IconPanel;
	infItem.Description = rSkilInfo.SkillDesc;
	infItem.ShortcutType = 2;
	infItem.ItemType = rSkilInfo.OperateType;
	return infItem;	
}

function SkillInfo GetSkillInfoByValue(int SkillID, int SkillLevel, int SkillSubLevel)
{
	local SkillInfo a_SkillInfo;

	GetSkillInfo(SkillID, SkillLevel, SkillSubLevel, a_SkillInfo);
	return a_SkillInfo;	
}

function int GetTextSizeWidth(string targetString, optional string FontName)
{
	local int nWidth, nHeight;

	// End:0x1F
	if(FontName == "")
	{
		FontName = "GameDefault";
	}
	GetTextSize(targetString, FontName, nWidth, nHeight);
	return nWidth;	
}

function int GetTextSizeHeight(string targetString, optional string FontName)
{
	local int nWidth, nHeight;

	// End:0x1F
	if(FontName == "")
	{
		FontName = "GameDefault";
	}
	GetTextSize(targetString, FontName, nWidth, nHeight);
	return nHeight;	
}

function DrawPanelArray(DrawPanelHandle drawPanel, out array<DrawItemInfo> drawListArr, optional bool bClear)
{
	local int i;

	if(bClear)
	{
		drawPanel.Clear();
	}

	for(i = 0; i < drawListArr.Length; i++)
	{
		drawPanel.InsertDrawItem(drawListArr[i]);
	}	
}

function DrawPanelArrayFixedWidth(DrawPanelHandle drawPanel, out array<DrawItemInfo> drawListArr, optional bool bClear, optional int fixedWidth)
{
	local int i, nH;

	// End:0x18
	if(bClear)
	{
		drawPanel.Clear();
	}
	// End:0x3C
	if(fixedWidth <= 0)
	{
		drawPanel.GetWindowSize(fixedWidth, nH);
	}
	drawPanel.InsertDrawItem(addDrawItemTextureCustom("L2UI_CT1.EmptyBtn", false, true, 0, 0, fixedWidth, 1, 1, 1));
	drawPanel.InsertDrawItem(addDrawItemBlank(0));

	for(i = 0; i < drawListArr.Length; i++)
	{
		drawPanel.InsertDrawItem(drawListArr[i]);
	}	
}

defaultproperties
{
	bDoNotUseDebug = false
}
