class HomunculusWndEnchantCommunionDice extends UICommonAPI;

const TIMEID_DICE= 1;
const TIME_DICE= 500;
const DICEMAX= 3;

var WindowHandle Me;
var string m_WindowName;
var TextBoxHandle textResult;
var TextBoxHandle text0;
var TextBoxHandle textDesc;
var StatusRoundHandle MainStatus;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndEnchantCommunionInfo homunculusWndEnchantCommunionInfoScript;
var L2UITween l2uiTweenScript;
var array<HomunculusWndEnchantCommunionDiceItem> diceScripts;
var int MDice;
var int HDice;
var int SDice;
var int diceNum;
var int completedDiceNum;
var int resultEnchant;
var ButtonHandle btnContinue;
var ButtonHandle btnConfirm;
var WindowHandle resultWnd;

function Initialize ()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	resultWnd = GetWindowHandle(m_WindowName $ ".resultWnd");
	text0 = GetTextBoxHandle(m_WindowName $ ".resultWnd.text0");
	MainStatus = GetStatusRoundHandle(m_WindowName $ ".resultWnd.MainStatus");
	textResult = GetTextBoxHandle(m_WindowName $ ".resultWnd.textResult");
	textDesc = GetTextBoxHandle(m_WindowName $ ".resultWnd.textDesc");
	btnContinue = GetButtonHandle(m_WindowName $ ".btnContinue");
	btnConfirm = GetButtonHandle(m_WindowName $ ".btnConfirm");
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndEnchantCommunionInfoScript = HomunculusWndEnchantCommunionInfo(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionInfo"));
	l2uiTweenScript = L2UITween(GetScript("L2UITween"));
	InitHandleDiceItems();
}

function InitHandleDiceItems ()
{
	local int i;

	for ( i = 0;i < DICEMAX;i++ )
	{
		GetWindowHandle(m_WindowName $ ".Dice" $ string(i)).SetScript("HomunculusWndEnchantCommunionDiceItem");
		diceScripts[i] = HomunculusWndEnchantCommunionDiceItem(GetWindowHandle(m_WindowName $ ".Dice" $ string(i)).GetScript());
		diceScripts[i].Init(m_WindowName $ ".Dice" $ string(i));
	}
}

function OnRegisterEvent ()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_RESET_HOMUNCULUS_SKILL_RESULT);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_ENCHANT_HOMUNCULUS_SKILL_RESULT);
}

function OnLoad ()
{
	Initialize();
}

function OnEvent (int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_RESET_HOMUNCULUS_SKILL_RESULT:
			Handle_S_EX_RESET_HOMUNCULUS_SKILL_RESULT();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_ENCHANT_HOMUNCULUS_SKILL_RESULT:
			Handle_S_EX_ENCHANT_HOMUNCULUS_SKILL_RESULT();
			break;
	}
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "btnConfirm":
			HomunculusWndScript.SetState(HomunculusWndScript.type_State.Communion);
			HomunculusWndScript.API_C_EX_SHOW_HOMUNCULUS_INFO(1);
			break;
		case "btnContinue":
			HomunculusWndScript.API_C_EX_ENCHANT_HOMUNCULUS_SKILL(1,GetCurrHomunculusData().idx,GetCurrIndex() + 1);
			break;
	}
}

function OnTimer (int TimerID)
{
	switch (TimerID)
	{
		case TIMEID_DICE:
			diceScripts[diceNum].Dice();
			diceNum++;
			if ( diceNum == DICEMAX )
			{
				Me.KillTimer(TimerID);
			}
			break;
	}
}

function Show ()
{
	resultEnchant = GetCurrHomunculusData().SkillLevel[GetCurrIndex() + 1];
	SetInfo();
	Me.ShowWindow();
	Me.SetFocus();
	HomunculusWndScript.API_C_EX_ENCHANT_HOMUNCULUS_SKILL(1,GetCurrHomunculusData().idx,GetCurrIndex() + 1);
	text0.SetText(string(GetCurrIndex() + 1));
}

function Hide ()
{
	Me.HideWindow();
}

function bool CheckBtnContinue ()
{
	if ( homunculusWndEnchantCommunionInfoScript.currentEnchantPoint < homunculusWndEnchantCommunionInfoScript.currHomunEnchantData.CommunionNeedEnchantPoint )
	{
		return False;
	}
	if ( homunculusWndEnchantCommunionInfoScript.mySP < homunculusWndEnchantCommunionInfoScript.currHomunEnchantData.CommunionNeedSpPoint )
	{
		return False;
	}
	if ( resultEnchant >= 3 )
	{
		return False;
	}
	return True;
}

function Dice ()
{
	local int i;

	diceNum = 0;
	completedDiceNum = 0;
	btnConfirm.DisableWindow();
	btnContinue.DisableWindow();
	diceScripts[0].Clear();
	diceScripts[0].SetTargetNum(SDice);
	diceScripts[1].Clear();
	diceScripts[1].SetTargetNum(HDice);
	diceScripts[2].Clear();
	diceScripts[2].SetTargetNum(MDice);
	
	for ( i = 1;i < DICEMAX;i++ )
	{
		if ( SDice == diceScripts[i].diceTarget0 )
		{
			diceScripts[0].isDiceSame = True;
			diceScripts[i].isDiceSame = True;
		}
	}
	diceScripts[diceNum].Dice();
	diceNum++;
	Me.SetTimer(TIMEID_DICE,TIME_DICE);
	resultWnd.HideWindow();
}

function SetResultEnchant ()
{
	resultWnd.ShowWindow();
	AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(13219),string(resultEnchant)));
}

function ClearAll ()
{
	local int i;

	for ( i = 0;i < DICEMAX;i++ )
	{
		diceScripts[i].Clear();
	}
}

function Handle_S_EX_RESET_HOMUNCULUS_SKILL_RESULT ()
{
	local UIPacket._S_EX_RESET_HOMUNCULUS_SKILL_RESULT packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_RESET_HOMUNCULUS_SKILL_RESULT(packet) )
	{
		return;
	}
	if ( packet.Type == 1 )
	{
		ClearAll();
	}
}

function Handle_S_EX_ENCHANT_HOMUNCULUS_SKILL_RESULT()
{
	local UIPacket._S_EX_ENCHANT_HOMUNCULUS_SKILL_RESULT packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_ENCHANT_HOMUNCULUS_SKILL_RESULT(packet) )
	{
		return;
	}
	if(packet.Type == 0)
	{
		AddSystemMessage(packet.nID);
		return;
	}
	else
	{
		ClearAll();
		resultEnchant = packet.Type;
	}
	MDice = packet.MDice;
	HDice = packet.HDice;
	SDice = packet.SDice;
	HomunculusWndScript.API_C_EX_SHOW_HOMUNCULUS_INFO(2);
	Dice();
}

function CompletedDice()
{
	completedDiceNum++;
	if ( completedDiceNum == DICEMAX )
	{
		diceScripts[0].ShowSame();
		diceScripts[1].ShowSame();
		diceScripts[2].ShowSame();
		if(CheckBtnContinue())
		{
			btnContinue.EnableWindow();
		}
		btnConfirm.EnableWindow();
		SetResultEnchant();
		SetInfo();
	}
}

function SetInfo()
{
	MainStatus.SetPoint(resultEnchant, 3);
	textDesc.SetText(GetSkillName());
	textResult.SetText(MakeFullSystemMsg(GetSystemMessage(13219), string(resultEnchant)));
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData ()
{
	return HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList")).GetCurrHomunculusData();
}

function int GetCurrIndex()
{
	return HomunculusWndEnchantCommunionChart(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionChart")).currentSelectedIndex;
}

function string GetSkillName()
{
	local array<string> descs;
	local string Desc;
	local ItemID Id;
	local int Index;

	Index = GetCurrIndex() + 1;
	Id.ClassID = GetCurrHomunculusData().SkillID[Index];
	Desc = Class'UIDATA_SKILL'.static.GetDescription(Id,resultEnchant,0);
	Debug("GetSkillName" @ string(Id.ClassID) @ Desc @ string(GetCurrIndex() + 1));
	if ( Desc == "" )
	{
		return "";
	}
	Split(Desc, "^", descs);
	return descs[0] @ descs[1];
}

defaultproperties
{
}
