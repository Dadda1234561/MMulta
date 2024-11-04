class DualInventorySwapBtn extends UICommonAPI;

const commandName = "Swapset";
const GroupName = "GamingStateShortcut";

var private int clickedX;
var private int clickedY;

event OnLoad()
{
	_RefreshTooltip();
	OptionWnd(GetScript("OptionWnd")).DelegateOnChangeShortcut = _RefreshTooltip;	
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	GetClientCursorPos(clickedX, clickedY);	
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x21
		case "SwapRetryBtn":
			HandleOnCLickSwapRetry();
			// End:0x24
			break;
	}	
}

event OnShow()
{
	_RefreshTooltip();	
}

function _RefreshTooltip()
{
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SwapRetryBtn").SetTooltipType("text");
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SwapRetryBtn").SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(14281), getInstanceL2Util().White, "", true, GetSwapRetryShortcutString(), getInstanceL2Util().White, "", true));	
}

private function string GetSwapRetryShortcutString()
{
	local ShortcutCommandItem commandItem;
	local OptionWnd optionWndScript;
	local string strShort;

	class'ShortcutAPI'.static.GetAssignedKeyFromCommand("GamingStateShortcut", "Swapset", commandItem);
	strShort = strShort $ "<" $ GetSystemString(1523) $ ": ";
	optionWndScript = OptionWnd(GetScript("OptionWnd"));
	// End:0xAD
	if(commandItem.subkey1 != "")
	{
		strShort = strShort $ optionWndScript.GetUserReadableKeyName(commandItem.subkey1) $ "+";
	}
	// End:0xE9
	if(commandItem.subkey2 != "")
	{
		strShort = strShort $ optionWndScript.GetUserReadableKeyName(commandItem.subkey2) $ "+";
	}
	// End:0x125
	if(commandItem.Key != "")
	{
		strShort = strShort $ optionWndScript.GetUserReadableKeyName(commandItem.Key) $ ">";
	}
	return strShort;	
}

private function HandleOnCLickSwapRetry()
{
	local int _clickedX, _clickedY, gabX, gabY;

	GetClientCursorPos(_clickedX, _clickedY);
	gabX = clickedX - _clickedX;
	gabY = clickedY - _clickedY;
	// End:0x5D
	if(Sqrt(float((gabX * gabX) + (gabY * gabY))) > 3)
	{
		return;
	}
}

defaultproperties
{
}
