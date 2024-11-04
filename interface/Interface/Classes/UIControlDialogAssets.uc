class UIControlDialogAssets extends UICommonAPI;

const HBuyItemWnd = 50;
const HInputWnd = 40;

var string m_WindowName;
var WindowHandle Me;
var int nDialogID;
var string m_WindowNameText;
var WindowHandle textWnd;
var TextBoxHandle DescriptionTextBox;
var HtmlHandle DescriptionHtmlCtrl;
var string m_WindowNameBuy;
var WindowHandle buyWnd;
var UIControlNeedItemList buyItemScript;
var RichListCtrlHandle BuyItemRichListCtrl;
var string m_WindowNameNeedItem;
var WindowHandle needItemWnd;
var UIControlNeedItemList needItemScript;
var RichListCtrlHandle NeedItemRichListCtrl;
var string m_WindowNameNeedInput;
var WindowHandle inputItemWnd;
var UIControlNumberInput inputItemScript;
var WindowHandle DisableWnd;
var ButtonHandle OKButton;
var ButtonHandle CancleButton;
var TextureHandle m_BgTexture;
var TextureHandle Exclamation_Tex;
var bool _initBuyItem;
var bool _initNeedItem;
var bool _initInputColtroled;

delegate DelegateOnClickBuy()
{

}

delegate DelegateOnCancel()
{

}

delegate DelegateOnItemCountEdited(INT64 changedNum)
{

}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x21
		case "OkButton":
			DelegateOnClickBuy();
			// End:0x42
			break;
		// End:0x3F
		case "CancleButton":
			DelegateOnCancel();
			// End:0x42
			break;
	}
}

static function UIControlDialogAssets InitScript(WindowHandle wnd)
{
	local UIControlDialogAssets scr;

	wnd.SetScript("UIControlDialogAssets");
	scr = UIControlDialogAssets(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	SetWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
}

private function SetWindow(string WindowName)
{
	m_WindowName = WindowName;
	Me = GetWindowHandle(m_WindowName);
	m_WindowNameText = WindowName $ ".TextWnd";
	DescriptionTextBox = GetTextBoxHandle(m_WindowNameText $ ".DescriptionTextBox");
	DescriptionHtmlCtrl = GetHtmlHandle(m_WindowNameText $ ".DescriptionHtmlCtrl");
	textWnd = GetWindowHandle(m_WindowNameText);
	textWnd.ShowWindow();
	m_WindowNameBuy = WindowName $ ".BuyWnd";
	BuyItemRichListCtrl = GetRichListCtrlHandle(m_WindowNameBuy $ ".BuyItemRichListCtrl");
	buyWnd = GetWindowHandle(m_WindowNameBuy);
	m_WindowNameNeedItem = WindowName $ ".NeedItemWnd";
	NeedItemRichListCtrl = GetRichListCtrlHandle(m_WindowNameNeedItem $ ".NeedItemRichListCtrl");
	needItemWnd = GetWindowHandle(m_WindowNameNeedItem);
	m_WindowNameNeedInput = WindowName $ ".inputItemWnd";
	inputItemWnd = GetWindowHandle(m_WindowNameNeedInput);
	OKButton = GetButtonHandle(m_WindowName $ ".OkButton");
	CancleButton = GetButtonHandle(m_WindowName $ ".CancleButton");
	m_BgTexture = GetTextureHandle(m_WindowNameText $ ".bgTexture_Tex");
	Exclamation_Tex = GetTextureHandle(m_WindowNameText $ ".Exclamation_Tex");
	HideDesriptionBGDeco();
	SetUseBuyItem(false);
	SetUseNeedItem(false);
	SetUseNumberInput(false);
}

private function InitBuyItem()
{
	// End:0x0B
	if(_initBuyItem)
	{
		return;
	}
	_initBuyItem = true;
	GetWindowHandle(m_WindowNameBuy).SetScript("UIControlNeedItemList");
	buyItemScript = UIControlNeedItemList(GetWindowHandle(m_WindowNameBuy).GetScript());
	buyItemScript.SetRichListControler(BuyItemRichListCtrl);
	buyItemScript.SetHideMyNum(true);
	buyItemScript.StartNeedItemList(1);
}

private function InitNeedItem()
{
	// End:0x0B
	if(_initNeedItem)
	{
		return;
	}
	_initNeedItem = true;
	GetWindowHandle(m_WindowNameNeedItem).SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(GetWindowHandle(m_WindowNameNeedItem).GetScript());
	needItemScript.SetRichListControler(NeedItemRichListCtrl);
	needItemScript.DelegateOnUpdateItem = OnChangeNeedItem;
}

private function InitInputControl()
{
	// End:0x0B
	if(_initInputColtroled)
	{
		return;
	}
	_initInputColtroled = true;
	inputItemScript = class'UIControlNumberInput'.static.InitScript(inputItemWnd);
	inputItemScript.DelegateGetCountCanBuy = MaxNumCanBuy;
	inputItemScript.DelegateOnClickBuy = OnClickBuy;
	inputItemScript.DelegateOnItemCountEdited = OnItemCountChanged;
	inputItemScript.Buy_Btn = GetButtonHandle(m_WindowName $ ".OkButton");
}

function SetUseBuyItem(bool bUse)
{
	// End:0x21
	if(bUse)
	{
		buyWnd.ShowWindow();
		InitBuyItem();
	}
	else
	{
		buyWnd.HideWindow();
	}
}

function SetUseNeedItem(bool bUse)
{
	// End:0x21
	if(bUse)
	{
		needItemWnd.ShowWindow();
		InitNeedItem();
	}
	else
	{
		GetButtonHandle(m_WindowName $ ".OkButton").EnableWindow();
		needItemWnd.HideWindow();
	}
}

function SetUseNumberInput(bool bUse)
{
	// End:0x21
	if(bUse)
	{
		inputItemWnd.ShowWindow();
		InitInputControl();
	}
	else
	{
		inputItemWnd.HideWindow();
	}
}

function SetDisableWindow(WindowHandle win)
{
	DisableWnd = win;
	DisableWnd.HideWindow();
}

function SetDialogDesc(string Desc, optional int nOkButtonSystemString, optional int nCancelButtonSystemString, optional bool bUseHtml, optional Color TextColor)
{
	// End:0x51
	if(TextColor.R == 0 && TextColor.G == 0 && TextColor.B == 0 && TextColor.A == 0)
	{
	}
	else
	{
		DescriptionTextBox.SetTextColor(TextColor);
	}
	// End:0x84
	if(nOkButtonSystemString > 0)
	{
		OKButton.SetButtonName(nOkButtonSystemString);
	}
	// End:0xA3
	if(nCancelButtonSystemString > 0)
	{
		CancleButton.SetButtonName(nCancelButtonSystemString);
	}
	// End:0xE7
	if(bUseHtml)
	{
		DescriptionTextBox.HideWindow();
		DescriptionHtmlCtrl.ShowWindow();
		DescriptionHtmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(Desc));
	}
	else
	{
		DescriptionTextBox.ShowWindow();
		DescriptionTextBox.SetText(Desc);
		DescriptionHtmlCtrl.HideWindow();
	}
}

function SetItemNum(int Num)
{
	Num = Max(1, Num);
	buyItemScript.SetBuyNum(Num);
	needItemScript.SetBuyNum(Num);
	inputItemScript.SetCount(1);
}

function StartNeedItemList(int rowNum)
{
	needItemScript.StartNeedItemList(rowNum);
}

function AddNeedItemClassID(int ClassID, INT64 Num)
{
	needItemScript.AddNeedItemClassID(ClassID, Num);
}

function AddNeedPoint(string Name, string TextureName, INT64 needAmount, INT64 currentAmount)
{
	needItemScript.AddNeedPoint(Name, TextureName, needAmount, currentAmount);
}

function SetBuyItemClassID(int ClassID, int Num)
{
	buyItemScript.AddNeedItemClassID(ClassID, Num);
}

function SetBuyItemInfo(ItemInfo iInfo, INT64 needAmount, INT64 currAmount)
{
	buyItemScript.AddNeeItemInfo(iInfo, needAmount, currAmount);	
}

function ShowDesriptionBGDeco()
{
	m_BgTexture.ShowWindow();
	SetDescriptionTextSize();
}

function HideDesriptionBGDeco()
{
	m_BgTexture.HideWindow();
	SetDescriptionTextSize();
}

function ShowDescriptonIcon()
{
	Exclamation_Tex.ShowWindow();
	SetDescriptionTextSize();
}

function HideDescriptonIcon()
{
	Exclamation_Tex.HideWindow();
	SetDescriptionTextSize();
}

function SetDescriptonIconTexture(string TextureName)
{
	Exclamation_Tex.SetTexture(TextureName);
}

function bool IsShowDecoBG()
{
	return m_BgTexture.IsShowWindow();
}

function bool IsShowDescriptionIcon()
{
	return Exclamation_Tex.IsShowWindow();
}

function SetDialogID(int nDialogID_NUM)
{
	nDialogID = nDialogID_NUM;
}

function int GetDialogID()
{
	return nDialogID;
}

function Show()
{
	local WindowHandle emptyWnd;

	// End:0x2D
	if(DisableWnd != emptyWnd)
	{
		DisableWnd.ShowWindow();
		DisableWnd.SetFocus();
	}
	Me.ShowWindow();
	Me.SetFocus();
	SetWindowHeight();
}

function Hide()
{
	local WindowHandle emptyWnd;

	buyItemScript.CleariObjects();
	needItemScript.CleariObjects();
	Me.HideWindow();
	// End:0x4B
	if(DisableWnd != emptyWnd)
	{
		DisableWnd.HideWindow();
	}
}

function INT64 MaxNumCanBuy()
{
	// End:0x1C
	if(! needItemWnd.IsShowWindow())
	{
		return inputItemScript.const.MAXITEMNUM;
	}
	return needItemScript.GetMaxNumCanBuy();
}

function OnClickBuy()
{
	DelegateOnClickBuy();
}

function OnItemCountChanged(INT64 ItemCount)
{
	DelegateOnItemCountEdited(ItemCount);
	ItemCount = MAX64(1, ItemCount);
	buyItemScript.SetBuyNum(ItemCount);
	needItemScript.SetBuyNum(ItemCount);
	DelegateOnItemCountEdited(ItemCount);
}

function OnChangeNeedItem()
{
	// End:0x24
	if(inputItemWnd.IsShowWindow())
	{
		inputItemScript.SetControlerBtns();
	}
	else
	{
		// End:0x82
		if((MaxNumCanBuy()) > 0)
		{
			// End:0x5D
			if(inputItemScript.GetCount() == 0)
			{
				inputItemScript.SetCount(1);
			}
			GetButtonHandle(m_WindowName $ ".OkButton").EnableWindow();
		}
		else
		{
			GetButtonHandle(m_WindowName $ ".OkButton").DisableWindow();
		}
	}
}

private function SetDescriptionTextSize()
{
	local Rect rectWnd;

	rectWnd = textWnd.GetRect();
	// End:0xC3
	if(IsShowDescriptionIcon())
	{
		DescriptionTextBox.SetWindowSizeRel(1.0f, 0.0f, -40, rectWnd.nHeight);
		DescriptionHtmlCtrl.SetWindowSizeRel(1.0f, 0.0f, -40, rectWnd.nHeight);
		DescriptionTextBox.SetAnchor(m_WindowNameText, "TopLeft", "TopLeft", 40, 0);
		DescriptionHtmlCtrl.SetAnchor(m_WindowNameText, "TopLeft", "TopLeft", 40, 0);		
	}
	else if(IsShowDecoBG())
	{
		DescriptionTextBox.SetWindowSizeRel(1.0f, 0.0f, -16, rectWnd.nHeight);
		DescriptionHtmlCtrl.SetWindowSizeRel(1.0f, 0.0f, -16, rectWnd.nHeight);
		DescriptionTextBox.SetAnchor(m_WindowNameText, "TopLeft", "TopLeft", 8, 0);
		DescriptionHtmlCtrl.SetAnchor(m_WindowNameText, "TopLeft", "TopLeft", 8, 0);			
	}
	else
	{
		DescriptionTextBox.SetWindowSizeRel(1.0f, 0.0f, 0, rectWnd.nHeight);
		DescriptionHtmlCtrl.SetWindowSizeRel(1.0f, 0.0f, 0, rectWnd.nHeight);
		DescriptionTextBox.SetAnchor(m_WindowNameText, "TopLeft", "TopLeft", 0, 0);
		DescriptionHtmlCtrl.SetAnchor(m_WindowNameText, "TopLeft", "TopLeft", 0, 0);
	}
}

private function SetWindowHeight()
{
	local Rect rectWnd, rectMyWnd;

	rectWnd = textWnd.GetRect();
	SetDescriptionTextSize();
	textWnd.SetWindowSizeRel(1.0f, 0.0f, -30, rectWnd.nHeight);
	// End:0x78
	if(buyWnd.IsShowWindow())
	{
		buyWnd.SetWindowSizeRel(1.0f, 0.0f, -30, 45);
	}
	else
	{
		buyWnd.SetWindowSizeRel(1.0f, 0.0f, -30, 0);
	}
	// End:0xE1
	if(needItemWnd.IsShowWindow())
	{
		needItemWnd.SetWindowSizeRel(1, 0, -30, (needItemScript.GetRowNum() * HInputWnd) + 31);
	}
	else
	{
		needItemWnd.SetWindowSizeRel(1, 0, -30, 0);
	}
	// End:0x135
	if(inputItemWnd.IsShowWindow())
	{
		inputItemWnd.SetWindowSizeRel(1, 0, -30, 58);
	}
	else
	{
		inputItemWnd.SetWindowSizeRel(1, 0, -30, 0);
	}
	rectWnd = OKButton.GetRect();
	rectMyWnd = Me.GetRect();
	Me.SetWindowSize(rectMyWnd.nWidth, ((rectWnd.nY - rectMyWnd.nY) + rectWnd.nHeight) + 6);
}

defaultproperties
{
}
