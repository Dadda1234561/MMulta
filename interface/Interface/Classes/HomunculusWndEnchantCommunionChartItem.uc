class HomunculusWndEnchantCommunionChartItem extends UICommonAPI;

enum type_State {
	Lock,
	Normal,
	Selected
};

var WindowHandle Me;
var string m_WindowName;
var int Index;
var ButtonHandle MainBtnChart;
var StatusRoundHandle MainStatus;
var TextureHandle texDisable;
var TextBoxHandle text0;
var int skillIDClssID;
var int SkillLevel;
var int currEnchantLv;
var L2Util util;
var HomunculusWndEnchantCommunionChart homunculusWndEnchantCommunionChartScript;
var type_State currState;

function Initialize ()
{
	util = L2Util(GetScript("L2Util"));
	MainStatus = GetStatusRoundHandle(m_WindowName $ ".MainStatus");
	MainBtnChart = GetButtonHandle(m_WindowName $ ".MainBtnChart");
	texDisable = GetTextureHandle(m_WindowName $ ".texDisable");
	text0 = GetTextBoxHandle(m_WindowName $ ".text0");
	text0.SetText(string(Index + 1));
	homunculusWndEnchantCommunionChartScript = HomunculusWndEnchantCommunionChart(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionChart"));
}

function Init (string WindowName)
{
	m_WindowName = WindowName;
	Me = GetWindowHandle(m_WindowName);
	Index = int(Right(m_WindowName,1));
	Initialize();
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "MainBtnChart":
			homunculusWndEnchantCommunionChartScript.HandleChartItemClicked(Index);
			break;
	}
}

function SetSkill (int ClassID, int currSkillLevel, int currEnchantLv)
{
	local bool isActivated;

	Debug("SetSkill :" @ string(ClassID) @ string(SkillLevel) @ string(currEnchantLv));
	isActivated = currEnchantLv > 0;
	skillIDClssID = ClassID;
	SkillLevel = currSkillLevel;
	currEnchantLv = currEnchantLv;
	if ( isActivated )
	{
		MainStatus.SetPoint(currEnchantLv,homunculusWndEnchantCommunionChartScript.LevelMax);
	} else {
		MainStatus.SetPoint(0,homunculusWndEnchantCommunionChartScript.LevelMax);
	}
	SetTooltip(isActivated);
}

function SetTooltip (bool isActivated)
{
	local ItemID Id;
	local array<string> descs;
	local string Desc;
	local CustomTooltip t;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(10);
	Id.ClassID = skillIDClssID;
	if ( isActivated )
	{
		Desc = Class'UIDATA_SKILL'.static.GetDescription(Id,SkillLevel,0);
		Debug("SetTooltip" @ Desc @ string(skillIDClssID) @ string(SkillLevel));
		Split(Desc,"^",descs);
		util.ToopTipInsertText(descs[0] $ ":" @ descs[1],True,True);
		MainBtnChart.SetTooltipCustomType(util.getCustomToolTip());
	}
	else
	{
		Desc = Class'UIDATA_SKILL'.static.GetDescription(Id,SkillLevel,0);
		Split(Desc,"^",descs);
		if ( currState == Lock )
		{
			util.ToopTipInsertColorText(descs[0] $ ":" @ GetSystemString(3809) $ descs[1],True,True,util.Gray);
			texDisable.SetTooltipCustomType(util.getCustomToolTip());
		} else {
			util.ToopTipInsertColorText(descs[0] $ ":" @ GetSystemString(3809) $ descs[1],True,True);
			MainBtnChart.SetTooltipCustomType(util.getCustomToolTip());
		}
	}
}

function ClearAll ()
{
	texDisable.SetTooltipCustomType(MakeTooltipSimpleText(""));
}

function SetState (type_State toState)
{
	currState = toState;
	Debug("SetState" @ string(toState) @ string(Index));
	switch (currState)
	{
		case Lock:
			MainBtnChart.HideWindow();
			texDisable.ShowWindow();
			text0.SetTextColor(getInstanceL2Util().Gray);
			break;
		case Normal:
			MainBtnChart.ShowWindow();
			MainBtnChart.EnableWindow();
			texDisable.HideWindow();
			text0.SetTextColor(GetColor(170,153,119,255));
			break;
		case Selected:
			MainBtnChart.ShowWindow();
			MainBtnChart.DisableWindow();
			texDisable.HideWindow();
			text0.SetTextColor(GetColor(170,153,119,255));
			break;
	}
}

defaultproperties
{
}
