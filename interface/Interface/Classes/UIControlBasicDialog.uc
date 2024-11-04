//================================================================================
// UIControlBasicDialog.
//================================================================================

class UIControlBasicDialog extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var ButtonHandle OKButton;
var ButtonHandle CancleButton;
var HtmlHandle DescriptionHtmlCtrl;
var TextBoxHandle DescriptionTextBox;
var WindowHandle DisableWindow;
var L2Util util;
var int nDialogKey;
var INT64 m_reservedInt64;
var INT64 m_reservedInt64_1;
var INT64 m_reservedInt64_2;
var INT64 m_reservedInt64_3;
var INT64 m_reservedInt64_4;
var int m_reservedInt;
var int m_reservedInt2;
var int m_reservedInt3;
var ItemID m_reservedItemID;
var ItemInfo m_reservedItemInfo;
var string m_reservedString;

delegate DelegateOnClickCancleButton (optional int nDialogKey);

delegate DelegateOnClickOkButton (optional int nDialogKey);

function SetWindow(string WindowName, optional string DisableWindowName)
{
	util = L2Util(GetScript("L2Util"));
	m_WindowName = WindowName;
	if(DisableWindowName != "")
	{
		DisableWindow = GetWindowHandle(DisableWindowName);
	}
	Me = GetWindowHandle(m_WindowName);
	OKButton = GetButtonHandle(m_WindowName $ ".OkButton");
	CancleButton = GetButtonHandle(m_WindowName $ ".CancleButton");
	DescriptionTextBox = GetTextBoxHandle(m_WindowName $ ".DescriptionTextBox");
	DescriptionHtmlCtrl = GetHtmlHandle(m_WindowName $ ".DescriptionHtmlCtrl");
}

function setDialogKey(int pDialogKey)
{
	nDialogKey = pDialogKey;
}

function int getDialogKey()
{
	return nDialogKey;
}

function setInit(string Desc, optional int nDialogKey, optional int nOkButtonSystemString, optional int nCancelButtonSystemString, optional bool bUseHtml, optional Color TextColor)
{
	setDialogKey(nDialogKey);
	if ( (TextColor.R == 0) && (TextColor.G == 0) && (TextColor.B == 0) && (TextColor.A == 0) )
	{
	}
	else
	{
		DescriptionTextBox.SetTextColor(TextColor);
	}
	// End:0x8F
	if(nOkButtonSystemString > 0)
	{
		OKButton.SetButtonName(nOkButtonSystemString);
	}
	// End:0xAE
	if(nCancelButtonSystemString > 0)
	{
		CancleButton.SetButtonName(nCancelButtonSystemString);
	}
	Debug("bUsehtml" @ string(bUseHtml));
	// End:0x126
	if(bUseHtml)
	{
		DescriptionTextBox.HideWindow();
		DescriptionHtmlCtrl.ShowWindow();
		DescriptionHtmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(Desc));
		Debug("html:" @ htmlSetHtmlStart(Desc));
	}
	else
	{
		DescriptionTextBox.ShowWindow();
		DescriptionTextBox.SetText(Desc);
		DescriptionHtmlCtrl.HideWindow();
	}
}

function Show()
{
	// End:0x1F
	if(!isNullWindow(DisableWindow))
	{
		DisableWindow.ShowWindow();
	}
	Me.ShowWindow();
	Me.SetFocus();
}

function Hide()
{
	if(!isNullWindow(DisableWindow))
	{
		DisableWindow.HideWindow();
	}
	Me.HideWindow();
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "OkButton":
			OnClickOKButton();
			break;
		case "CancleButton":
			OnClickCancleButton();
			break;
	}
}

function OnClickOKButton()
{
	DelegateOnClickOkButton(nDialogKey);
}

function OnClickCancleButton()
{
	Me.HideWindow();
	DelegateOnClickCancleButton(nDialogKey);
}

function SetReservedInt64(INT64 param)
{
	m_reservedInt64 = param;
}

function SetReservedInt64_1(INT64 param)
{
	m_reservedInt64_1 = param;
}

function SetReservedInt64_2(INT64 param)
{
	m_reservedInt64_2 = param;
}

function SetReservedInt64_3(INT64 param)
{
	m_reservedInt64_3 = param;
}

function SetReservedInt64_4(INT64 param)
{
	m_reservedInt64_4 = param;
}

function SetReservedInt(int Value)
{
	m_reservedInt = Value;
}

function SetReservedInt2(int Value)
{
	m_reservedInt2 = Value;
}

function SetReservedInt3(int Value)
{
	m_reservedInt3 = Value;
}

function SetReservedItemID(ItemID Id)
{
	m_reservedItemID = Id;
}

function SetReservedItemInfo(ItemInfo Info)
{
	m_reservedItemInfo = Info;
}

function SetReservedString(string Str)
{
	m_reservedString = Str;
}

function string GetReservedString()
{
	return m_reservedString;
}

function int GetReservedInt()
{
	return m_reservedInt;
}

function int GetReservedInt2()
{
	return m_reservedInt2;
}

function int GetReservedInt3()
{
	return m_reservedInt3;
}

function INT64 GetReservedInt64()
{
	return m_reservedInt64;
}

function INT64 GetReservedInt64_1()
{
	return m_reservedInt64_1;
}

function INT64 GetReservedInt64_2()
{
	return m_reservedInt64_2;
}

function INT64 GetReservedInt64_3()
{
	return m_reservedInt64_3;
}

function INT64 GetReservedInt64_4()
{
	return m_reservedInt64_4;
}

function ItemID GetReservedItemID()
{
	return m_reservedItemID;
}

function GetReservedItemInfo(out ItemInfo Info)
{
	Info = m_reservedItemInfo;
}

defaultproperties
{
}
