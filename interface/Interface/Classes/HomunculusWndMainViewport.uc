class HomunculusWndMainViewport extends UICommonAPI;

const TIMER_ID_ANIMATION = 19;
const TIMER_DELAY = 20000;
const TIMER_ID_CLICK = 2;
const TIMER_DELAY_CLICK = 200;
const MONSTERID_DEACTIVE = 19652;
const TIMER_ID_COMMUNION = 3;
const DIALOG_ID_DELETE = 17;

var WindowHandle Me;
var string m_WindowName;
var bool isDown;
var CharacterViewportWindowHandle m_ObjectViewport;
var ButtonHandle btn0;
var ButtonHandle btn1;
var TextBoxHandle text0;
var TextBoxHandle text1;
var AnimTextureHandle texCommunion;
var StatusBarHandle ExpBar;
var bool isCommunion;
var int requestedCommunionIdx;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndMainList homunculusWndMainListScript;
var int spawnedIndex;
var int idx;
var int Level;

function ClearAll()
{
	spawnedIndex = -1;
	text0.SetText("");
	ExpBar.SetPoint(0,100);
	texCommunion.Stop();
	texCommunion.HideWindow();
	btn1.DisableWindow();
	SetGrade(-1);
	SetViewPortSetting(0);
	SetViewPort(MONSTERID_DEACTIVE);
	idx = -1;
	Level = 1;
}

function HandleGameInit ()
{
	if ( !HomunculusWndScript.ChkSerVer() )
	{
		return;
	}
	ClearAll();
}

function Initialize ()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	text0 = GetTextBoxHandle(m_WindowName $ ".text0");
	text1 = GetTextBoxHandle(m_WindowName $ ".text1");
	btn0 = GetButtonHandle(m_WindowName $ ".btn0");
	btn1 = GetButtonHandle(m_WindowName $ ".btn1");
	ExpBar = GetStatusBarHandle(m_WindowName $ ".EXPBar");
	texCommunion = GetAnimTextureHandle(m_WindowName $ ".texCommunion");
	m_ObjectViewport = GetCharacterViewportWindowHandle(m_WindowName $ ".ObjectViewport");
	m_ObjectViewport.SetDragRotationRate(200);
	m_ObjectViewport.SetSpawnDuration(0.2);
	m_ObjectViewport.SetUISound(true);
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndMainListScript = HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList"));
}

function OnRegisterEvent ()
{
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_ACTIVATE_HOMUNCULUS_RESULT);
}

function OnLoad ()
{
	Initialize();
}

function OnEvent (int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_DialogOK:
			HandleDialogOK(True);
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_ACTIVATE_HOMUNCULUS_RESULT:
			Handle_S_EX_ACTIVATE_HOMUNCULUS_RESULT();
			break;
		case EV_GamingStateEnter:
			HandleGameInit();
			break;
	}
}

event OnLButtonDown (WindowHandle a_WindowHandle, int X, int Y)
{
	if ( a_WindowHandle == m_ObjectViewport )
	{
		Me.SetTimer(TIMER_ID_CLICK,TIMER_DELAY_CLICK);
		isDown = True;
	}
}

event OnLButtonUp (WindowHandle a_WindowHandle, int X, int Y)
{
	if ( a_WindowHandle == m_ObjectViewport )
	{
		if ( isDown )
		{
			PlayRandAnimation();
			Me.SetTimer(TIMER_ID_ANIMATION,TIMER_DELAY);
		}
	}
	Me.KillTimer(TIMER_ID_CLICK);
	isDown = False;
}

function OnTimer (int TimerID)
{
	switch (TimerID)
	{
		case TIMER_ID_CLICK:
			Me.KillTimer(TIMER_ID_CLICK);
			isDown = False;
			break;
	}
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "btn0":
			ChangeActivate();
			break;
		case "btn1":
			DialogSetID(DIALOG_ID_DELETE);
			DialogShow(DialogModalType_Modalless,DialogType_OKCancel,GetSystemString(13377),string(self));
			break;
	}
}

function Show ()
{
	Me.ShowWindow();
	Me.SetFocus();
}

function Hide ()
{
	Me.HideWindow();
}

function ChangeActivate ()
{
	requestedCommunionIdx = GetCurrHomunculusData().idx;
	HomunculusWndScript.API_C_EX_REQUEST_ACTIVATE_HOMUNCULUS(requestedCommunionIdx, ! GetCurrHomunculusData().Activate);
}

function PlayRandAnimation ()
{
	local int aniType;

	aniType = Rand(2);
	m_ObjectViewport.PlayAnimation(aniType);
}

function SetGrade (int Type)
{
	switch (Type)
	{
		case 0:
			text1.SetText(HomunculusWndScript.GetGradeString(Type));
			m_ObjectViewport.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.Homun_NPCBackTex01");
			break;
		case 1:
			text1.SetText(HomunculusWndScript.GetGradeString(Type));
			m_ObjectViewport.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.Homun_NPCBackTex02");
			break;
		case 2:
			text1.SetText(HomunculusWndScript.GetGradeString(Type));
			m_ObjectViewport.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.Homun_NPCBackTex03");
			break;
		default:
			text1.SetText(HomunculusWndScript.GetGradeString(Type));
			m_ObjectViewport.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.Homun_NPCBackTex01");
			break;
	}
}

function SetNoneHomunculus ()
{
	text1.SetText(GetSystemString(13397));
}

function SetViewPort (int NpcID)
{
	if ( NpcID == spawnedIndex )
	{
		return;
	}
	spawnedIndex = NpcID;
	m_ObjectViewport.SetNPCInfo(NpcID);
	m_ObjectViewport.SpawnNPC();
	PlayRandAnimation();
}

function _SetDispawnOnHide()
{
	m_ObjectViewport.SetNPCInfo(-1);
	m_ObjectViewport.SpawnNPC();
}

function _SetSpawnOnShow()
{
	m_ObjectViewport.SetNPCInfo(spawnedIndex);
	m_ObjectViewport.SpawnNPC();
}

function SetViewPortSetting (int Id)
{
	local float tmpScale;
	local int OffsetY;
	local int OffsetX;
	local int Distance;

	Distance = 250;
	OffsetX = 0;
	switch (Id)
	{
		case 0:
			Distance = 120;
			tmpScale = 1.0;
			OffsetY = 1;
			break;
		case 1:
		case 2:
		case 3:
			tmpScale = 1.25;
			OffsetY = -11;
			break;
		case 4:
		case 5:
		case 6:
			tmpScale = 1.5;
			OffsetY = -1;
			break;
		case 7:
		case 8:
		case 9:
			tmpScale = 0.89999998;
			OffsetY = -1;
			break;
		case 10:
		case 11:
		case 12:
			tmpScale = 1.75;
			OffsetY = -8;
			break;
		case 13:
		case 14:
		case 15:
			tmpScale = 1.10;
			OffsetY = -1;
			break;
		case 16:
		case 17:
		case 18:
			tmpScale = 1.40;
			OffsetY = -3;
			break;
		case 19:
		case 20:
		case 21:
			tmpScale = 1.60;
			OffsetY = -1;
			break;
		case 22:
		case 23:
		case 24:
			tmpScale = 1.50;
			OffsetY = -5;
			break;
		case 25:
		case 26:
		case 27:
			tmpScale = 1.20f;
			OffsetY = 0;
			break;
		case 28:
		case 29:
		case 30:
			tmpScale = 1.20;
			OffsetY = -1;
			break;
	}
	m_ObjectViewport.SetCharacterScale(tmpScale);
	m_ObjectViewport.SetCharacterOffsetY(OffsetY);
	m_ObjectViewport.SetCharacterOffsetX(OffsetX);
	m_ObjectViewport.SetCameraDistance(Distance);
}

function SetInfo (int NpcID)
{
	local string NpcName;
	local HomunculusAPI.HomunculusNpcLevelData npcLevelData;
	local int prevExp;
	local int currExp;

	NpcName = Class'UIDATA_NPC'.static.GetNPCName(NpcID);
	npcLevelData = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id, GetCurrHomunculusData().Level);
	if ( GetCurrHomunculusData().Level == 1 )
	{
		prevExp = 0;
	} else {
		prevExp = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id,GetCurrHomunculusData().Level - 1).MaxExp;
	}
	currExp = npcLevelData.MaxExp - prevExp;
	ExpBar.SetPointExpPercentRate((GetCurrHomunculusData().Exp - prevExp) / currExp);
	ExpBar.ShowWindow();
	text0.SetText(GetSystemString(88) $ "." $ string(GetCurrHomunculusData().Level) @ NpcName);
}

function SetActive (bool IsActive)
{
	if ( IsActive )
	{
		btn0.SetButtonName(13363);
		texCommunion.Stop();
		texCommunion.SetLoopCount(99999);
		texCommunion.Play();
		texCommunion.ShowWindow();
	} else {
		btn0.SetButtonName(13362);
		texCommunion.Stop();
		texCommunion.HideWindow();
	}
}

function SetChangeHomunculusData ()
{
	local HomunculusAPI.HomunculusNpcData npcData;

	CheckLevelUP();
	idx = GetCurrHomunculusData().idx;
	npcData = HomunculusWndScript.GetHomunculusNpcData(GetCurrHomunculusData().Id);
	SetGrade(GetCurrHomunculusData().Type);
	SetViewPortSetting(GetCurrHomunculusData().Id);
	SetViewPort(npcData.NpcID);
	SetInfo(npcData.NpcID);
	SetActive(GetCurrHomunculusData().Activate);
	btn0.EnableWindow();
	btn1.EnableWindow();
}

function CheckLevelUP ()
{
	if ( GetCurrHomunculusData().idx == idx )
	{
		if ( Level < GetCurrHomunculusData().Level )
		{
			AddSystemMessage(13239);
			m_ObjectViewport.SpawnEffect("LineageEffect2.ui_spirit_lvup");
			m_ObjectViewport.PlayAnimation(HomunculusWndScript.TYPE_ANIM.levelup);
		}
	}
	Level = GetCurrHomunculusData().Level;
}

function Handle_S_EX_ACTIVATE_HOMUNCULUS_RESULT ()
{
	local UIPacket._S_EX_ACTIVATE_HOMUNCULUS_RESULT packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_ACTIVATE_HOMUNCULUS_RESULT(packet) )
	{
		return;
	}
	if ( packet.Type == 1 )
	{
		homunculusWndMainListScript.SetActiveIdx(bool(packet.bActivate),requestedCommunionIdx);
		SetActive(bool(packet.bActivate));
	} else {
		AddSystemMessage(packet.nID);
	}
	requestedCommunionIdx = -1;
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData ()
{
	return HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList")).GetCurrHomunculusData();
}

function HandleDialogOK (bool bOK)
{
	if ( !DialogIsMine() )
	{
		return;
	}
	switch (DialogGetID())
	{
		case DIALOG_ID_DELETE:
			if ( bOK )
			{
				HomunculusWndScript.API_C_EX_DELETE_HOMUNCULUS_DATA(GetCurrHomunculusData().idx);
			}
			break;
	}
}

defaultproperties
{
}
