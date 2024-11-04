class CollectionSystemProgressComponent extends UICommonAPI;

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var ButtonHandle Rhombus_BTN;
var TextBoxHandle CompletedNum_txt;
var TextBoxHandle TotalNum_txt;
var StatusRoundHandle Rhombus_gauge;

delegate DelegateOnButtonClick()
{}

function Initialize()
{
	util = L2Util(GetScript("L2Util"));
	CompletedNum_txt = GetTextBoxHandle(m_WindowName $ ".CompletedNum_txt");
	TotalNum_txt = GetTextBoxHandle(m_WindowName $ ".TotalNum_txt");
	class'UIAPI_WINDOW'.static.SetAnchor(m_WindowName $ ".TotalNum_txt", m_WindowName $ ".CompletedNum_txt", "BottomRight", "BottomLeft", 2, 0);
	Rhombus_BTN = GetButtonHandle(m_WindowName $ ".Rhombus_BTN");
	Rhombus_gauge = GetStatusRoundHandle(m_WindowName $ ".Rhombus_gauge");
}

function Init(string WindowName)
{
	m_WindowName = WindowName;
	Me = GetWindowHandle(m_WindowName);
	Initialize();
	SetPoint(100, 100);
}

function SetPoint(int Min, int Max)
{
	Rhombus_gauge.SetPoint(Min, Max);
	CompletedNum_txt.SetText(string(Min));
	TotalNum_txt.SetText("/" $ string(Max));
	Rhombus_BTN.SetNameText(string(int((float(Min) / float(Max)) * float(100))) $ "%");
}

function SetEnable()
{
	Rhombus_BTN.EnableWindow();
}

function SetDisable()
{
	Rhombus_BTN.DisableWindow();
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "Rhombus_BTN":
			DelegateOnButtonClick();
			break;
	}
}

defaultproperties
{
}
