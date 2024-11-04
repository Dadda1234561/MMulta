class UIControlSliderWithValue extends UICommonAPI;

var SliderCtrlHandle mainSlider;
var TextBoxHandle TitleTextBox;
var EditBoxHandle valueEditBox;
var int _minValue;
var int _maxValue;
var int _value;

delegate DelegateOnValueChanged(UIControlSliderWithValue Owner)
{
}

function Init(WindowHandle Owner)
{
	local string ownerFullPath;

	ownerFullPath = Owner.m_WindowNameWithFullPath;
	mainSlider = GetSliderCtrlHandle(ownerFullPath $ ".mainSlider");
	TitleTextBox = GetTextBoxHandle(ownerFullPath $ ".titleTextBox");
	valueEditBox = GetEditBoxHandle(ownerFullPath $ ".valueEditBox");
	_SetValueText(_GetValue());
}

event OnModifyCurrentTickSliderCtrl(string strID, int CurrentValue)
{
	local int validValue;

	// End:0x49
	if(strID == "mainSlider")
	{
		validValue = CurrentValue + _minValue;
		_value = validValue;
		_SetValueText(validValue);
		DelegateOnValueChanged(self);
	}
}

event OnCompleteEditBox(string strID)
{
	local int Value;

	// End:0x3A
	if(strID == "valueEditBox")
	{
		Value = int(valueEditBox.GetString());
		_SetValue(Value);
	}
}

function _SetTitle(string Title)
{
	TitleTextBox.SetText(Title);
}

function string _GetTitle()
{
	return TitleTextBox.GetText();
}

function _SetValue(int Value)
{
	local int sliderCurrentTick;

	_value = Value;
	sliderCurrentTick = Value - _minValue;
	mainSlider.SetCurrentTick(sliderCurrentTick);
}

function _SetValueTextEditable(bool isEditable)
{
	valueEditBox.SetEditable(isEditable);
}

function _SetValueText(int Value)
{
	valueEditBox.SetString(string(Value));
}

function int _GetValue()
{
	return _value;
}

function _SetMinMaxValue(int MinValue, int MaxValue)
{
	_minValue = MinValue;
	_maxValue = MaxValue;
	mainSlider.SetTotalTickCount((MaxValue - MinValue) + 1);
}

function int _GetMinValue()
{
	return _minValue;
}

function int _GetMaxValue()
{
	return _maxValue;
}

defaultproperties
{
}
