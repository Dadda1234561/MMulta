class HomunculusWndEnchantCommunionChart extends UICommonAPI;

const EFFECT_MONSTER_ID= 19671;
const LevelMax= 3;
const CHARTITEMMAX= 5;

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var array<HomunculusWndEnchantCommunionChartItem> chartItems;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndEnchantCommunionInfo homunculusWndEnchantCommunionInfoScript;
var CharacterViewportWindowHandle EffectViewportChart;
var int currentSelectedIndex;
var bool Spawned;

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	util = L2Util(GetScript("L2Util"));
	EffectViewportChart = GetCharacterViewportWindowHandle(m_WindowName $ ".EffectViewportChart");
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndEnchantCommunionInfoScript = HomunculusWndEnchantCommunionInfo(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionInfo"));
	InitHandleChartItems();
	EffectViewportChart.SetNPCInfo(EFFECT_MONSTER_ID);
}

function OnLoad()
{
	Initialize();
}

function HandleChartItemClicked(int Index)
{
	switch(chartItems[Index].currState)
	{
		case chartItems[Index].type_State.Normal:
			SetSelect(Index);
			break;
	}
}

function SetSelect(int Index)
{
	if ( currentSelectedIndex != -1 )
	{
		chartItems[currentSelectedIndex].SetState(chartItems[currentSelectedIndex].type_State.Normal);
	}
	chartItems[Index].SetState(chartItems[Index].type_State.Selected);
	currentSelectedIndex = Index;
	homunculusWndEnchantCommunionInfoScript.SetSelect(Index);
}

function Show()
{
	Me.ShowWindow();
	Me.SetFocus();
}

function Hide()
{
	Me.HideWindow();
	currentSelectedIndex = -1;
}

function InitHandleChartItems()
{
	local int i;

	for ( i = 0;i < CHARTITEMMAX;i++ )
	{
		GetWindowHandle(m_WindowName $ ".Item" $ string(i)).SetScript("HomunculusWndEnchantCommunionChartItem");
		chartItems[i] = HomunculusWndEnchantCommunionChartItem(GetWindowHandle(m_WindowName $ ".Item" $ string(i)).GetScript());
		chartItems[i].Init(m_WindowName $ ".Item" $ string(i));
	}
	currentSelectedIndex = -1;
}

function SetEffectByPer(int Level)
{
	local int dist;

	if ( !Spawned )
	{
		EffectViewportChart.SpawnNPC();
		EffectViewportChart.SpawnEffect("LineageEffect_br.br_e_lamp_deco_d");
		EffectViewportChart.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.HomunCom_EnchantBG");
		Spawned = true;
	}
	if ( Level > 0 )
	{
		EffectViewportChart.ShowWindow();
	}
	switch(Level)
	{
		case 0:
			EffectViewportChart.HideWindow();
			break;
		case 1:
			dist = 300;
			break;
		case 2:
			dist = 250;
			break;
		case 3:
			dist = 200;
			break;
		case 4:
			dist = 150;
			break;
		case 5:
			dist = 100;
			break;
		case 6:
			dist = 50;
			break;
	}
	EffectViewportChart.SetCameraDistance(dist);
}

function ClearAll()
{
	local int i;

	for ( i = i;i < CHARTITEMMAX;i++ )
	{
		chartItems[i].ClearAll();
		chartItems[i].SetState(chartItems[i].type_State.Lock);
	}
	currentSelectedIndex = -1;
	SetEffectByPer(0);
}

function SetChangeHomunculusData()
{
	local int i;
	local int SkillID;
	local int SkillLevel;
	local int currEnchantLv;
	local HomunculusAPI.HomunculusNpcLevelData npcLevelData;

	for ( i = 0;i < GetCurrHomunculusData().Level;i++ )
	{
		if ( currentSelectedIndex != i )
		{
			chartItems[i].SetState(chartItems[i].type_State.Normal);
		} else {
			SetSelect(i);
		}
		npcLevelData = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id,i + 1);
		currEnchantLv = GetCurrHomunculusData().SkillLevel[i + 1];
		if ( currEnchantLv == 0 )
		{
			SkillLevel = npcLevelData.OptionSkillLevel[2];
			SkillID = npcLevelData.OptionSkillId[2];
		} else {
			SkillLevel = currEnchantLv;
			SkillID = GetCurrHomunculusData().SkillID[i + 1];
		}
		chartItems[i].SetSkill(SkillID,SkillLevel,currEnchantLv);
	}
	for ( i = i;i < CHARTITEMMAX;i++ )
	{
		chartItems[i].SetState(chartItems[i].type_State.Lock);
		npcLevelData = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id,i + 1);
		SkillLevel = npcLevelData.OptionSkillLevel[2];
		SkillID = npcLevelData.OptionSkillId[2];
		chartItems[i].SetSkill(SkillID,SkillLevel,0);
	}
	SetEffectByPer(GetCurrHomunculusData().Level);
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData ()
{
	return HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList")).GetCurrHomunculusData();
}

defaultproperties
{
}
