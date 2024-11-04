class UIControlGroupButtons extends UICommonAPI;

var array<ButtonHandle> buttonGroup;
var string ForeTexture;
var string backTexture;
var string highlightTexture;
var int currentTabIndex;
var bool bUseLongButtonTextTooltip;
var bool bUseOverlapClickPrevention;
var ButtonHandle currentSelectedButtonHandle;
var UIMapStringObject mapBtnTexObj;
var string _reservedString;
var int _reservedInt;
var INT64 _reservedInt64;

delegate DelegateOnClickButton(string parentWindowName, string strName, int currentTabIndex)
{
}

function _SetStartInfo(string pForeTexture, string pBackTexture, string pHighlightTexture, optional bool pBUseLongButtonTextTooltip)
{
	ForeTexture = pForeTexture;
	backTexture = pBackTexture;
	highlightTexture = pHighlightTexture;
	bUseLongButtonTextTooltip = pBUseLongButtonTextTooltip;
	mapBtnTexObj = new class'UIMapStringObject';
	_clearAll();
}

function _setUseOverlapClickPrevention(bool bFlag)
{
	bUseOverlapClickPrevention = bFlag;	
}

function _addButtonController(ButtonHandle btn, optional string buttonText, optional int buttonValue)
{
	// End:0x40
	if(buttonText != "")
	{
		btn.SetNameText(buttonText);
		// End:0x3D
		if(bUseLongButtonTextTooltip)
		{
			btn.SetTooltipText(buttonText);
		}		
	}
	else
	{
		// End:0x67
		if(bUseLongButtonTextTooltip)
		{
			btn.SetTooltipText(btn.GetButtonName());
		}
	}
	setCheckLongButtonTextTooltip(btn);
	btn.SetButtonValue(buttonValue);
	buttonGroup[buttonGroup.Length] = btn;
	_setButtonTextureByName(btn.GetWindowName(), ForeTexture, backTexture, highlightTexture);
}

function setCheckLongButtonTextTooltip(ButtonHandle btn)
{
	local Rect R;
	local int W, h;

	// End:0x0D
	if(! bUseLongButtonTextTooltip)
	{
		return;
	}
	R = btn.GetRect();
	GetTextSizeDefault(btn.GetTooltipText(), W, h);
	// End:0xCC
	if(R.nWidth < W + 4)
	{
		btn.SetNameText(makeShortStringByPixel(btn.GetTooltipText(), R.nWidth - 16, "..."));
		btn.SetTooltipType("text");
		btn.SetTooltipCustomType(MakeTooltipSimpleText(btn.GetTooltipText()));		
	}
	else
	{
		btn.SetNameText(btn.GetTooltipText());
		btn.SetTooltipType("");
	}
}

function _clearAll()
{
	local ButtonHandle tempButtonHandle;

	currentTabIndex = -1;
	buttonGroup.Length = 0;
	bUseLongButtonTextTooltip = false;
	bUseOverlapClickPrevention = false;
	currentSelectedButtonHandle = tempButtonHandle;
	_reservedString = "";
	_reservedInt = 0;
	_reservedInt64 = 0;
	mapBtnTexObj.RemoveAll();
}

function _setButtonTexture(int buttonIndex, string pForeTexture, string pBackTexture, string pHighlightTexture)
{
	local string strParam;

	buttonGroup[buttonIndex].SetTexture(pForeTexture, pBackTexture, pHighlightTexture);
	ParamAdd(strParam, "ForeTexture", pForeTexture);
	ParamAdd(strParam, "BackTexture", pBackTexture);
	ParamAdd(strParam, "HighlightTexture", pHighlightTexture);
	mapBtnTexObj.Add(string(buttonIndex), strParam);
}

function _setButtonTextureByName(string buttonHandleName, string pForeTexture, string pBackTexture, string pHighlightTexture)
{
	local string strParam;
	local int i;

	// End:0xDE [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		// End:0xD4
		if(buttonGroup[i].GetWindowName() == buttonHandleName)
		{
			buttonGroup[i].SetTexture(pForeTexture, pBackTexture, pHighlightTexture);
			ParamAdd(strParam, "ForeTexture", pForeTexture);
			ParamAdd(strParam, "BackTexture", pBackTexture);
			ParamAdd(strParam, "HighlightTexture", pHighlightTexture);
			mapBtnTexObj.Add(string(i), strParam);
			// [Explicit Break]
			break;
		}
	}
}

function _setButtonText(int buttonIndex, string buttonText)
{
	buttonGroup[buttonIndex].SetNameText(buttonText);
	buttonGroup[buttonIndex].SetTooltipText(buttonText);
	setCheckLongButtonTextTooltip(buttonGroup[buttonIndex]);
}

function _setButtonTextByName(string buttonHandleName, string buttonText)
{
	local int i;

	// End:0x88 [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		// End:0x7E
		if(buttonGroup[i].GetWindowName() == buttonHandleName)
		{
			buttonGroup[i].SetNameText(buttonText);
			buttonGroup[i].SetTooltipText(buttonText);
			setCheckLongButtonTextTooltip(buttonGroup[i]);
			// [Explicit Break]
			break;
		}
	}
}

function _HideAllButtons()
{
	local int i;

	// End:0x36 [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		buttonGroup[i].HideWindow();
	}
}

function _setShowButtonNum(optional int showButtonNum)
{
	local int i;

	// End:0x0D
	if(showButtonNum <= 0)
	{
		return;
	}
	_HideAllButtons();

	// End:0x78 [Loop If]
	for(i = 0; i < showButtonNum; i++)
	{
		buttonGroup[i].ShowWindow();
	}
}

function _selectButton(string buttonHandleName, optional bool doNotRunDelegateOnClick)
{
	local int i;
	local string strParam, pForeTexture, pBackTexture, pHighlightTexture;

	// End:0x167 [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		// End:0xB3
		if(mapBtnTexObj.HasKey(string(i)))
		{
			strParam = "";
			strParam = mapBtnTexObj.Find(string(i));
			ParseString(strParam, "ForeTexture", pForeTexture);
			ParseString(strParam, "BackTexture", pBackTexture);
			ParseString(strParam, "HighlightTexture", pHighlightTexture);			
		}
		else
		{
			pHighlightTexture = highlightTexture;
			pBackTexture = backTexture;
			pHighlightTexture = highlightTexture;
		}
		// End:0x125
		if(buttonGroup[i].GetWindowName() == buttonHandleName)
		{
			buttonGroup[i].SetTexture(pBackTexture, pBackTexture, pBackTexture);
			currentTabIndex = i;
			// [Explicit Continue]
			continue;
		}
		// End:0x15A
		if(hasButtonGroupButtonName(buttonHandleName))
		{
			buttonGroup[i].SetTexture(pForeTexture, pBackTexture, pHighlightTexture);
			// [Explicit Continue]
			continue;
		}
		// [Explicit Continue]
		continue;
	}
	// End:0x1A8
	if(doNotRunDelegateOnClick == false && hasButtonGroupButtonName(buttonHandleName))
	{
		DelegateOnClickButton(buttonGroup[0].GetParentWindowName(), buttonHandleName, currentTabIndex);
	}
}

function _selectButtonHandle(ButtonHandle ButtonHandle, optional bool doNotRunDelegateOnClick)
{
	local int i;
	local string strParam, pForeTexture, pBackTexture, pHighlightTexture;

	if(bUseOverlapClickPrevention)
	{
		if(currentSelectedButtonHandle == ButtonHandle)
		{
			return;
		}
	}
	currentSelectedButtonHandle = ButtonHandle;
	for(i = 0; i < buttonGroup.Length; i++)
	{
		// End:0xB3
		if(mapBtnTexObj.HasKey(string(i)))
		{
			strParam = "";
			strParam = mapBtnTexObj.Find(string(i));
			ParseString(strParam, "ForeTexture", pForeTexture);
			ParseString(strParam, "BackTexture", pBackTexture);
			ParseString(strParam, "HighlightTexture", pHighlightTexture);			
		}
		else
		{
			pHighlightTexture = highlightTexture;
			pBackTexture = backTexture;
			pHighlightTexture = highlightTexture;
		}
		// End:0x11B
		if(buttonGroup[i] == ButtonHandle)
		{
			buttonGroup[i].SetTexture(pBackTexture, pBackTexture, pBackTexture);
			currentTabIndex = i;
			// [Explicit Continue]
			continue;
		}
		// End:0x150
		if(hasButtonGroupButtonHandle(ButtonHandle))
		{
			buttonGroup[i].SetTexture(pForeTexture, pBackTexture, pHighlightTexture);
			// [Explicit Continue]
			continue;
		}
		// [Explicit Continue]
		continue;
	}
	// End:0x1A6
	if(doNotRunDelegateOnClick == false && hasButtonGroupButtonHandle(ButtonHandle))
	{
		DelegateOnClickButton(ButtonHandle.GetParentWindowName(), ButtonHandle.GetWindowName(), currentTabIndex);
	}
}

function bool hasButtonGroupButtonHandle(ButtonHandle ButtonHandle)
{
	local int i;

	// End:0x38 [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		// End:0x2E
		if(buttonGroup[i] == ButtonHandle)
		{
			return true;
		}
	}
	return false;
}

function bool hasButtonGroupButtonName(string buttonHandleName)
{
	local int i;

	// End:0x42 [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		// End:0x38
		if(buttonGroup[i].GetWindowName() == buttonHandleName)
		{
			return true;
		}
	}
	return false;
}

function _setTopOrder(int tabNum, optional bool doNotRunDelegateOnClick)
{
	_selectButtonHandle(buttonGroup[tabNum], doNotRunDelegateOnClick);
	currentTabIndex = tabNum;
}

function _setButtonValue(int i, int Value)
{
	buttonGroup[i].SetButtonValue(Value);
}

function _setButtonValueByName(string buttonHandleName, int Value)
{
	local int i;

	// End:0x5D [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		// End:0x53
		if(buttonGroup[i].GetWindowName() == buttonHandleName)
		{
			buttonGroup[i].SetButtonValue(Value);
			// [Explicit Break]
			break;
		}
	}
}

function int _FindButtonIndexByValue(int Value)
{
	local int i;

	// End:0x46 [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		// End:0x3C
		if(buttonGroup[i].GetButtonValue() == Value)
		{
			return i;
		}
	}
	return -1;	
}

function int _getButtonValue(int i)
{
	return buttonGroup[i].GetButtonValue();
}

function int _getButtonValueByName(string buttonHandleName)
{
	local int i;

	// End:0x56 [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		// End:0x4C
		if(buttonGroup[i].GetWindowName() == buttonHandleName)
		{
			return buttonGroup[i].GetButtonValue();
		}
	}
	return -1;
}

function int _getSelectedButtonValue()
{
	return _getButtonValue(_getSelectButtonIndex());
}

function ButtonHandle _getButtonHandle(int i)
{
	return buttonGroup[i];
}

function _setTextureLoc(int buttonIndex, TextureHandle Tex, int addX, int addY, optional string alignXStr)
{
	local Rect R;
	local int alignX;

	R = _getButtonHandle(buttonIndex).GetRect();
	// End:0x55
	if(alignXStr == "right")
	{
		alignX = R.nWidth - Tex.GetRect().nWidth;
	}
	else if(alignXStr == "center")
	{
		alignX = (R.nWidth / 2) - (Tex.GetRect().nWidth / 2);
	}
	else
	{
		alignX = 0;
	}
	Tex.ClearAnchor();
	Tex.MoveTo((R.nX + addX) + alignX, R.nY + addY);
}

function _setTextureLocByName(string buttonHandleName, TextureHandle Tex, int addX, int addY, optional string alignXStr)
{
	local Rect R;
	local int alignX;

	R = _getButtonHandleByName(buttonHandleName).GetRect();
	// End:0x55
	if(alignXStr == "right")
	{
		alignX = R.nWidth - Tex.GetRect().nWidth;		
	}
	else if(alignXStr == "center")
	{
		alignX = (R.nWidth / 2) - (Tex.GetRect().nWidth / 2);			
	}
	else
	{
		alignX = 0;
	}
	Tex.ClearAnchor();
	Tex.MoveTo((R.nX + addX) + alignX, R.nY + addY);
}

function ButtonHandle _getButtonHandleByName(string buttonHandleName)
{
	local int i;

	// End:0x4C [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		// End:0x42
		if(buttonGroup[i].GetWindowName() == buttonHandleName)
		{
			return buttonGroup[i];
		}
	}
	return none;
}

function int _getSelectButtonIndex()
{
	return currentTabIndex;
}

function string _getSelectButtonName()
{
	// End:0x12
	if(currentTabIndex == -1)
	{
		return "";
	}
	return buttonGroup[currentTabIndex].GetWindowName();
}

function _SetDisable(int tabNum)
{
	buttonGroup[tabNum].DisableWindow();
}

function _SetEnable(int tabNum)
{
	buttonGroup[tabNum].EnableWindow();
}

function _setDisableByName(string buttonHandleName)
{
	local int i;

	// End:0x58 [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		// End:0x4E
		if(buttonGroup[i].GetWindowName() == buttonHandleName)
		{
			buttonGroup[i].DisableWindow();
		}
	}
}

function _setEnableByName(string buttonHandleName)
{
	local int i;

	// End:0x58 [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		// End:0x4E
		if(buttonGroup[i].GetWindowName() == buttonHandleName)
		{
			buttonGroup[i].EnableWindow();
			// [Explicit Break]
			break;
		}
	}
}

function _setDisableAll()
{
	local int i;

	// End:0x36 [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		buttonGroup[i].DisableWindow();
	}
}

function _setEnableAll()
{
	local int i;

	// End:0x36 [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		buttonGroup[i].EnableWindow();
	}
}

function int _getShowButtonNum()
{
	local int i, Num;

	// End:0x40 [Loop If]
	for(i = 0; i < buttonGroup.Length; i++)
	{
		// End:0x36
		if(buttonGroup[i].IsShowWindow())
		{
			Num++;
		}
	}
	return Num;
}

function _setAutoWidth(int nTotalWidth, int nGap)
{
	local int nWidth;

	nWidth = (nTotalWidth - (nGap * ((_getShowButtonNum()) - 1))) / (_getShowButtonNum());
	autoWidthCalculate(nTotalWidth, nWidth, nGap);
}

function autoWidthCalculate(int nTotalWidth, int nWidth, int nGap)
{
	local int i, addGap, total;
	local Rect R;

	total = _getShowButtonNum();

	// End:0x132 [Loop If]
	for(i = 0; i < total; i++)
	{
		// End:0x52
		if(i == 0)
		{
			R = buttonGroup[i].GetRect();
			addGap = 0;			
		}
		else if(i == total - 1)
		{
			addGap = (nGap * i) + (nWidth * i);
			nWidth = nTotalWidth - (nWidth * (total - 1));				
		}
		else
		{
			addGap = (nGap * i) + (nWidth * i);
		}
		buttonGroup[i].SetWindowSize(nWidth, R.nHeight);
		buttonGroup[i].MoveTo(R.nX + addGap, R.nY);
		setCheckLongButtonTextTooltip(buttonGroup[i]);
	}
}

function _fixedWidth(int nWidth, int nGap)
{
	local int i, addGap;
	local Rect R;

	// End:0xD6 [Loop If]
	for(i = 0; i < _getShowButtonNum(); i++)
	{
		// End:0x47
		if(i == 0)
		{
			R = buttonGroup[i].GetRect();
			addGap = 0;			
		}
		else
		{
			addGap = (nGap * i) + (nWidth * i);
		}
		buttonGroup[i].SetWindowSize(nWidth, R.nHeight);
		buttonGroup[i].MoveTo(R.nX + addGap, R.nY);
		setCheckLongButtonTextTooltip(buttonGroup[i]);
	}
}

function _setButtonHeight(int nHeight)
{
	local int i;
	local Rect R;

	// End:0x6B [Loop If]
	for(i = 0; i < _getShowButtonNum(); i++)
	{
		// End:0x3D
		if(i == 0)
		{
			R = buttonGroup[i].GetRect();
		}
		buttonGroup[i].SetWindowSize(R.nWidth, nHeight);
	}
}

defaultproperties
{
}
