class UIHtmlTestEditor extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle refreshButton;
var ButtonHandle ClearButton;
var HtmlHandle HtmlViewer;
var string currentFocusString;

function OnRegisterEvent()
{}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	setWindowTitleByString("UIHtmlTestEditor");
}

function Initialize()
{
	Me = GetWindowHandle("UIHtmlTestEditor");
	refreshButton = GetButtonHandle("UIHtmlTestEditor.refreshButton");
	ClearButton = GetButtonHandle("UIHtmlTestEditor.clearButton");
	HtmlViewer = GetHtmlHandle("UIHtmlTestEditor.htmlViewer");
}

function OnShow()
{
	GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox01").SetFocus();
}

function Load()
{}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x22
		case "refreshButton":
			OnRefreshButtonClick();
			// End:0x3F6
			break;
		// End:0x3B
		case "clearButton":
			OnclearButtonClick();
			// End:0x3F6
			break;
		// End:0x53
		case "copyButton":
			OnCopyButtonClick();
			// End:0x3F6
			break;
		// End:0x69
		case "UpButton":
			onUpButtonClick();
			// End:0x3F6
			break;
		// End:0x81
		case "DownButton":
			onDownButtonClick();
			// End:0x3F6
			break;
		// End:0x13F
		case "btnButton":
			GetEditBoxHandle("UIHtmlTestEditor." $ currentFocusString).AddString("<button value=\"test\" width=100 height=25 High=\"L2UI_CT1.Button_DF_Over\" back=\"L2UI_CT1.Button_DF_Down\" fore=\"L2UI_CT1.Button_DF\">");
			// End:0x3F6
			break;
		// End:0x1AD
		case "imgButton":
			GetEditBoxHandle("UIHtmlTestEditor." $ currentFocusString).AddString("<img src=\"Icon.Item_Normal06\" width=32 height=32>");
			// End:0x3F6
			break;
		// End:0x225
		case "fontColorButton":
			GetEditBoxHandle("UIHtmlTestEditor." $ currentFocusString).AddString("<font name=\"GameDefault\" color=\"FFFFFF\"> test </font>");
			// End:0x3F6
			break;
		// End:0x2B8
		case "tableButton":
			GetEditBoxHandle("UIHtmlTestEditor." $ currentFocusString).AddString("<table width=0 height=0 border=1 cellpadding=0 cellspacing=1 background=\"\"> </table>");
			// End:0x3F6
			break;
		// End:0x2FE
		case "trButton":
			GetEditBoxHandle("UIHtmlTestEditor." $ currentFocusString).AddString("<tr> </tr>");
			// End:0x3F6
			break;
		// End:0x371
		case "tdButton":
			GetEditBoxHandle("UIHtmlTestEditor." $ currentFocusString).AddString("<td fixwidth=0 width=0 height=0 background=\"\">test</td>");
			// End:0x3F6
			break;
		// End:0x3B1
		case "brButton":
			GetEditBoxHandle("UIHtmlTestEditor." $ currentFocusString).AddString("<br>");
			// End:0x3F6
			break;
		// End:0x3F3
		case "br1Button":
			GetEditBoxHandle("UIHtmlTestEditor." $ currentFocusString).AddString("<br1>");
			// End:0x3F6
			break;
		// End:0xFFFF
		default:
			break;
	}
}

function OnRefreshButtonClick()
{
	local int i;
	local string Str;

	// End:0x77 [Loop If]
	for(i = 1; i <= 20; i++)
	{
		Str = Str $ GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, i)).GetString();
	}
	HtmlViewer.LoadHtmlFromString("<html>" $ Str $ "</html>");
}

function OnclearButtonClick()
{
	local int i;

	// End:0x6C [Loop If]
	for(i = 1; i <= 20; i++)
	{
		GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, i)).SetString("");
	}
	GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox01").SetFocus();
}

function OnCopyButtonClick()
{
	local int i;
	local string Str, tmp;

	// End:0x94 [Loop If]
	for(i = 1; i <= 20; i++)
	{
		tmp = GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, i)).GetString();
		// End:0x8A
		if(tmp != "")
		{
			Str = (Str $ tmp) $ Chr(13);
		}
	}
	ClipboardCopy("<html>" $ Chr(13) $ Str $ "</html>");
	getInstanceL2Util().showGfxScreenMessage("Complete ClipboardCopy!");
}

function onUpButtonClick()
{
	local int Num;
	local string temp1, temp2;

	Num = int(Right(currentFocusString, 2));
	temp1 = GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, Num)).GetString();
	Num--;
	// End:0x88
	if(Num < 1)
	{
		Num = 1;
		temp2 = "";		
	}
	else
	{
		temp2 = GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, Num)).GetString();
	}
	GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, Num)).SetString(temp1);
	GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, Num + 1)).SetString(temp2);
	GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, Num)).SetFocus();
}

function onDownButtonClick()
{
	local int Num;
	local string temp1, temp2;

	Num = int(Right(currentFocusString, 2));
	temp1 = GetEditBoxHandle(("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, Num)).GetString();
	Num++;
	// End:0x8A
	if(Num > 20)
	{
		Num = 20;
		temp2 = "";		
	}
	else
	{
		temp2 = GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, Num)).GetString();
	}
	GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, Num)).SetString(temp1);
	GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, Num - 1)).SetString(temp2);
	GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, Num)).SetFocus();
}

event OnKeyDown(WindowHandle a_WindowHandle, EInputKey nKey)
{
	local string mainKey, tempStr1;
	local int Num, i;

	// End:0x27D
	if(Me.IsShowWindow())
	{
		mainKey = class'InputAPI'.static.GetKeyString(nKey);
		// End:0x16C
		if(mainKey == "ENTER")
		{
			Num = int(Right(currentFocusString, 2));

			// End:0x169 [Loop If]
			for(i = 20; i > Num; i--)
			{
				tempStr1 = GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, i - 1)).GetString();
				GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, i - 1)).SetString("");
				GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, i)).SetString(tempStr1);
			}			
		}
		else if(mainKey == "DOWN")
		{
			Num = int(Right(currentFocusString, 2));
			Num++;
			// End:0x1A8
			if(Num > 20)
			{
				Num = 20;
			}
			GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, Num)).SetFocus();				
		}
		else if(mainKey == "UP")
		{
			Num = int(Right(currentFocusString, 2));
			Num--;
			// End:0x230
			if(Num < 1)
			{
				Num = 1;
			}
			GetEditBoxHandle("UIHtmlTestEditor." $ "lineEditBox" $ getInstanceL2Util().makeZeroString(2, Num)).SetFocus();
		}
	}
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	// End:0x3A
	if(Left(a_WindowHandle.GetWindowName(), 11) == "lineEditBox")
	{
		currentFocusString = a_WindowHandle.GetWindowName();
	}
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
