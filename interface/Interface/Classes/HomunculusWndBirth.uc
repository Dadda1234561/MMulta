class HomunculusWndBirth extends UICommonAPI
	dependson(L2UITween);

const LISTOPENED = 3;
const DIALOGID_START = 0;
const TIME_CREATESTART = 3000;
const TIMEID_CREATESTART = 9;
const TIMER_COOL_REFRESH = 1000;
const TIMEID_COOL = 2;
const TIME_REFRESH = 5000;
const TIMEID_DELAY = 1;

enum type_State 
{
	non,
	ing,
	done
};

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var StatusBarHandle HPBar;
var TextBoxHandle txtSP;
var StatusBarHandle VPBar;
var StatusBarHandle Stat0;
var StatusBarHandle Stat1;
var StatusBarHandle Stat2;
var StatusBarHandle Stat3;
var EffectViewportWndHandle EffectViewport;
var ButtonHandle btn0;
var ButtonHandle btn1;
var ButtonHandle btn2;
var ButtonHandle btn3;
var ButtonHandle btnMain0;
var ButtonHandle btnMain1;
var HomunculusAPI.HomunCreateData currHmunCreateData;
var int MaxVitality;
var int CurrentHP;
var int CurrentSP;
var int CurrentVP;
var INT64 currentExpiredTime;
var int currentEffectStep;
var int CurrentState;
var bool insertedRequest;
var WindowHandle resultWnd;
var CharacterViewportWindowHandle m_ObjectViewport;
var TextBoxHandle txtResult0;
var EffectViewportWndHandle EffectViewportResult;
var TextureHandle birthCircle_tex;
var AnimTextureHandle birthCircleInput_anitex;
var int myHP;
var INT64 mySP;
var int myVP;
var bool isGachaState;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndMainList homunculusWndMainListScript;
var HomunculusWndGacha homunculusWndGachaScript;
var L2UITween l2uiTweenScript;
var int curTweenID;

function HandleGameInit()
{
	// End:0x16
	if(! HomunculusWndScript.ChkSerVer())
	{
		return;
	}
	currHmunCreateData = HomunculusWndScript.API_GetHomunCreateData();
	SetTooltip();
}

function SetTooltip()
{
	local string tmpMsg, Msg;
	local CustomTooltip t;

	tmpMsg = GetSystemMessage(13211);
	Msg = MakeFullSystemMsg(tmpMsg,MakeCostString(string(currHmunCreateData.HpVolume)));
	btn0.SetTooltipCustomType(MakeTooltipSimpleText(Msg));
	Msg = MakeFullSystemMsg(tmpMsg, MakeCostString(string(currHmunCreateData.SpVolume)));
	btn1.SetTooltipCustomType(MakeTooltipSimpleText(Msg));
	Msg = MakeFullSystemMsg(tmpMsg, GetSystemString(13398));
	btn2.SetTooltipCustomType(MakeTooltipSimpleText(Msg));
	util.setCustomTooltip(t);
	util.ToopTipMinWidth(300);
	util.ToopTipInsertText(GetSystemString(13345));
	btn3.SetTooltipCustomType(util.getCustomToolTip());
	util.setCustomTooltip(t);
	util.ToopTipMinWidth(200);
	util.ToopTipInsertText(GetSystemString(13548));
	GetButtonHandle(m_WindowName $ ".Help_Btn").SetTooltipCustomType(util.getCustomToolTip());
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	util = L2Util(GetScript("L2Util"));
	HPBar = GetStatusBarHandle(m_WindowName $ ".HPBar");
	txtSP = GetTextBoxHandle(m_WindowName $ ".txtSP");
	VPBar = GetStatusBarHandle(m_WindowName $ ".VPBar");
	Stat0 = GetStatusBarHandle(m_WindowName $ ".Stat0");
	Stat1 = GetStatusBarHandle(m_WindowName $ ".Stat1");
	Stat2 = GetStatusBarHandle(m_WindowName $ ".Stat2");
	Stat3 = GetStatusBarHandle(m_WindowName $ ".Stat3");
	EffectViewport = GetEffectViewportWndHandle(m_WindowName $ ".EffectViewport");
	btn0 = GetButtonHandle(m_WindowName $ ".btn0");
	btn1 = GetButtonHandle(m_WindowName $ ".btn1");
	btn2 = GetButtonHandle(m_WindowName $ ".btn2");
	btn3 = GetButtonHandle(m_WindowName $ ".btn3");
	btnMain0 = GetButtonHandle(m_WindowName $ ".btnMain0");
	btnMain1 = GetButtonHandle(m_WindowName $ ".btnMain1");
	resultWnd = GetWindowHandle(m_WindowName $ ".resultWnd");
	m_ObjectViewport = GetCharacterViewportWindowHandle(m_WindowName $ ".resultWnd.ObjectViewport");
	m_ObjectViewport.SetUISound(true);
	txtResult0 = GetTextBoxHandle(m_WindowName $ ".resultWnd.txtResult0");
	EffectViewportResult = GetEffectViewportWndHandle(m_WindowName $ ".resultWnd.EffectViewportResult");
	birthCircle_tex = GetTextureHandle(m_WindowName $ ".birthCircle_tex");
	birthCircleInput_anitex = GetAnimTextureHandle(m_WindowName $ ".birthCircleInput_anitex");
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndMainListScript = HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList"));
	homunculusWndGachaScript = HomunculusWndGacha(GetScript("HomunculusWnd.HomunculusWndGacha"));
	l2uiTweenScript = L2UITween(GetScript("L2UITween"));
	MaxVitality = GetMaxVitality();
	SetTooltip();
	curTweenID = -1;
}

function OnRegisterEvent ()
{
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
	RegisterEvent(EV_UpdateMyHP);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_ShowHomunculusList);
	RegisterEvent(EV_ShowHomunculusBirthInfo);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_CREATE_START_RESULT);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_INSERT_RESULT);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_SUMMON_RESULT);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_HPSPVP);
}

function OnLoad ()
{
	Initialize();
}

function OnEvent (int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_AdenaInvenCount:
			if ( Me.IsShowWindow() )
			{
				HandleAdenaCount();
			}
			break;
		case EV_DialogOK:
			HandleDialogOK(True);
			break;
		case EV_DialogCancel:
			HandleDialogOK(False);
			break;
		case EV_UpdateMyHP:
		case EV_UpdateUserInfo:
			if ( Me.IsShowWindow() )
			{
				SetMyStat();
			}
			break;
		case EV_GamingStateEnter:
			if ( HomunculusWndScript.ChkSerVer() )
			{
				HandleGameInit();
			}
			break;
		case EV_ShowHomunculusList:
			HandleListItems();
			break;
		case EV_ShowHomunculusBirthInfo:
			Handle_EV_ShowHomunculusBirthInfo(param);
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_CREATE_START_RESULT:
			Handle_S_EX_HOMUNCULUS_CREATE_START_RESULT();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_INSERT_RESULT:
			Handle_S_EX_HOMUNCULUS_INSERT_RESULT();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_SUMMON_RESULT:
			Handle_S_EX_HOMUNCULUS_SUMMON_RESULT();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_HPSPVP:
			Handle_S_EX_HOMUNCULUS_HPSPVP();
			break;
	}
}

function OnCallUCFunction (string funcName, string param)
{
	switch (funcName)
	{
		case l2uiTweenScript.TWEENEND:
			Tweenkle(int(param));
			break;
	}
}

function OnTimer (int TimerID)
{
	switch (TimerID)
	{
		case TIMEID_DELAY:
			Me.KillTimer(TIMEID_DELAY);
			HandleCanBtns();
			break;
		case TIMEID_COOL:
			HandleTime();
			break;
		case TIMEID_CREATESTART:
			TweenStop();
			birthCircle_tex.SetAlpha(0);
			Me.KillTimer(TIMEID_CREATESTART);
			break;
	}
}

function OnClickButton (string Name)
{
	switch(Name)
	{
		case "btn0":
			API_C_EX_HOMUNCULUS_INSERT(0);
			btn0.DisableWindow();
			break;
		case "btn1":
			API_C_EX_HOMUNCULUS_INSERT(1);
			btn1.DisableWindow();
			break;
		case "btn2":
			API_C_EX_HOMUNCULUS_INSERT(2);
			btn2.DisableWindow();
			break;
		case "btnMain0":
			HandleClickBtnMain0();
			break;
		case "btnMain1":
			HomunculusWndScript.API_C_EX_HOMUNCULUS_SUMMON();
			break;
		case "btnConfirm":
			HandleConfirm();
			break;
		case "swapBtn":
			GetWindowHandle("HomunculusWndProbability").HideWindow();
			HandleSwapCacha();
			// End:0xD3
			break;
		case "Probability_Btn":
			HomunculusWndProbability(GetScript("HomunculusWndProbability")).API_C_EX_REQ_HOMUNCULUS_PROB_LIST(0);
			// End:0x144
			break;
	}
}

function API_C_EX_HOMUNCULUS_INSERT (int Type)
{
	insertedRequest = true;
	HomunculusWndScript.API_C_EX_HOMUNCULUS_INSERT(Type);
	Me.SetTimer(TIMEID_DELAY,TIME_REFRESH);
}

function Show()
{
	// End:0x12
	if(isGachaState)
	{
		SetShowGacha();		
	}
	else
	{
		SetShowBirth();
	}
}

function SetShowGacha()
{
	homunculusWndGachaScript.Show();
	Me.HideWindow();
	SetEffectByPer(-1.0f);
}

function SetShowBirth()
{
	HomunculusWndScript.API_C_EX_SHOW_HOMUNCULUS_INFO(0);
	homunculusWndGachaScript.Hide();
	Me.ShowWindow();
	Me.SetFocus();
	SetMyStat();
	HandleAdenaCount();
}

function Hide()
{
	Me.HideWindow();
	SetEffectByPer(-1.0);
	homunculusWndGachaScript.Hide();
}

function HandleTime()
{
	currentExpiredTime = currentExpiredTime - 1;
	// End:0x2D
	if(! CanChargeTime())
	{
		Me.KillTimer(TIMEID_COOL);
	}
	Stat3.SetPoint(currHmunCreateData.CostTime - currentExpiredTime,currHmunCreateData.CostTime);
	HandleCurrPercent();
	HandleCanBtns();
}

function HandleConfirm()
{
	resultWnd.HideWindow();
	HomunculusWndScript.SetState(HomunculusWndScript.type_State.Main);
}

function HandleClickBtnMain0()
{
	local string Msg;

	Msg = MakeFullSystemMsg(GetSystemMessage(13209), MakeCostStringINT64(currHmunCreateData.CostAdena));
	// End:0x66
	if(CurrentState == 0)
	{
		TweenStart();
		class'UICommonAPI'.static.DialogSetID(DIALOGID_START);
		class'UICommonAPI'.static.DialogShow(DialogModalType_Modalless,DialogType_OKCancel,Msg,string(self));
	}
}

function Handle_EV_ShowHomunculusBirthInfo (string param)
{
	local int Type;

	ParseInt(param,"type",Type);
	ParseInt(param,"CurrentHP",CurrentHP);
	ParseInt(param,"CurrentSP",CurrentSP);
	ParseInt(param,"CurrentVP",CurrentVP);
	if ( CurrentState == 0 )
	{
		currentExpiredTime = currHmunCreateData.CostTime;
	} else {
		currentExpiredTime = HomunculusWndScript.API_GetRemainBirthSeconds();
	}
	SetState(Type);
	Stat0.SetPoint(CurrentHP,currHmunCreateData.HpCount);
	Stat1.SetPoint(CurrentSP,currHmunCreateData.SpCount);
	Stat2.SetPoint(CurrentVP,currHmunCreateData.VpCount);
	Stat3.SetPoint(currHmunCreateData.CostTime - currentExpiredTime,currHmunCreateData.CostTime);
	Me.KillTimer(TIMEID_COOL);
	if ( CanChargeTime() )
	{
		Me.SetTimer(TIMEID_COOL,TIMER_COOL_REFRESH);
	}
	HandleCurrPercent();
	HandleCanBtns();
}

function Handle_S_EX_HOMUNCULUS_CREATE_START_RESULT ()
{
	local UIPacket._S_EX_HOMUNCULUS_CREATE_START_RESULT packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_HOMUNCULUS_CREATE_START_RESULT(packet) )
	{
		return;
	}
	Me.KillTimer(TIMEID_CREATESTART);
	// End:0x3F
	if(packet.Type == 1)
	{		
	}
	else
	{
		AddSystemMessage(packet.nID);
		TweenStop();
	}
}

function Handle_S_EX_HOMUNCULUS_INSERT_RESULT ()
{
	local UIPacket._S_EX_HOMUNCULUS_INSERT_RESULT packet;

	insertedRequest = False;
	if ( !Class'UIPacket'.static.Decode_S_EX_HOMUNCULUS_INSERT_RESULT(packet) )
	{
		return;
	}
	AddSystemMessage(packet.nID);
	if ( packet.Type == 0 )
	{
		return;
	} else {
		birthCircleInput_anitex.Stop();
		birthCircleInput_anitex.Play();
		Me.KillTimer(TIMEID_DELAY);
		HandleCanBtns();
	}
}

function Handle_S_EX_HOMUNCULUS_SUMMON_RESULT ()
{
	local UIPacket._S_EX_HOMUNCULUS_SUMMON_RESULT packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_HOMUNCULUS_SUMMON_RESULT(packet) )
	{
		return;
	}
	AddSystemMessage(packet.nID);
	// End:0x3E
	if(packet.Type == 0)
	{		
	}
	else
	{
		resultWnd.ShowWindow();
	}
}

function Handle_S_EX_HOMUNCULUS_HPSPVP ()
{
	local UIPacket._S_EX_HOMUNCULUS_HPSPVP packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_HOMUNCULUS_HPSPVP(packet) )
	{
		return;
	}
	myHP = packet.nHP;
	mySP = packet.nSP;
	myVP = packet.nVP;
	SetMyStatusBars();
}

function HandleAdenaCount ()
{
	local CustomTooltip t;
	local string Msg;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(10);
	Msg = MakeFullSystemMsg(GetSystemMessage(13210),MakeCostStringINT64(currHmunCreateData.CostAdena));
	if(currHmunCreateData.CostAdena > GetAdena())
	{
		util.ToopTipInsertText(Msg,True,False,util.ETooltipTextType.COLOR_RED);
	} else {
		util.ToopTipInsertText(Msg, true, false);
	}
	HandlebtnMain0();
	btnMain0.SetTooltipCustomType(util.getCustomToolTip());
}

function HandleListItems ()
{
	local int i;
	local array<HomunculusAPI.HomunculusData> homunculusDatas;

	if ( !Me.IsShowWindow() )
	{
		return;
	}
	homunculusDatas = HomunculusWndScript.API_GetHomunculusDatas();
	HandlebtnMain0();

	for (i = 0;i < homunculusDatas.Length; i++ )
	{
		if(homunculusDatas[i].IsNew)
		{
			SetHomunculusData(homunculusDatas[i]);
			return;
		}
	}
}

function HandlebtnMain0 ()
{
	if(currHmunCreateData.CostAdena > GetAdena())
	{
		btnMain0.DisableWindow();
	}
	else
	{
		if(homunculusWndMainListScript.GetEmptySlot() == -1)
		{
			btnMain0.DisableWindow();
		} else {
			btnMain0.EnableWindow();
		}
	}
}

function SetHomunculusData (HomunculusAPI.HomunculusData Data)
{
	local HomunculusAPI.HomunculusNpcData npcData;

	npcData = HomunculusWndScript.GetHomunculusNpcData(Data.Id);
	SetViewPortSetting(Data.Id);
	SetViewPort(npcData.NpcID);
	SetInfo(npcData.NpcID, Data.Type, Data.Level);
	resultWnd.ShowWindow();
	EffectViewportResult.SpawnEffect("LineageEffect2.ui_upgrade_succ");
}

function SetGrade (int Type)
{
	switch (Type)
	{
		case 0:
			m_ObjectViewport.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.Homun_birthResultBG_01");
			break;
		case 1:
			m_ObjectViewport.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.Homun_birthResultBG_02");
			break;
		case 2:
			m_ObjectViewport.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.Homun_birthResultBG_03");
			break;
	}
}

function HandleCurrPercent ()
{
	local float currPer;

	if ( CurrentState == 0 )
	{
		SetEffectByPer(-1.0);
		return;
	}
	currPer = CurrentHP / currHmunCreateData.HpCount;
	currPer += CurrentSP / currHmunCreateData.SpCount;
	currPer += CurrentVP / currHmunCreateData.VpCount;
	currPer += currHmunCreateData.CostTime - currentExpiredTime / currHmunCreateData.CostTime;
	currPer /= 4;
	SetEffectByPer(currPer);
}

function SetEffect (string EffectName, optional int dist)
{
	EffectViewport.SetCameraDistance(dist);
	EffectViewport.ShowWindow();
	EffectViewport.SpawnEffect(EffectName);
}

function SetEffectByPer (float currPer)
{
	local int newEffectStep;

	if ( currPer == -1 )
	{
		newEffectStep = 0;
	}
	else if ( currPer <= 0.25 )
	{
		newEffectStep = 1;
	}
	else if ( currPer <= 0.5 )
	{
		newEffectStep = 2;
	}
	else if ( currPer <= 0.75 )
	{
		newEffectStep = 3;
	}
	else if ( currPer <= 1 )
	{
		newEffectStep = 4;
	}
	else
	{
		newEffectStep = 0;
	}

	if ( currentEffectStep == newEffectStep )
	{
		return;
	}
	currentEffectStep = newEffectStep;
	switch (currentEffectStep)
	{
		case 0:
			SetEffect("",0);
			break;
		case 1:
			SetEffect("LineageEffect_br.br_e_lamp_deco_d",240);
			break;
		case 2:
			SetEffect("LineageEffect_br.br_e_lamp_deco_d",192);
			break;
		case 3:
			SetEffect("LineageEffect_br.br_e_lamp_deco_d",146);
			break;
		case 4:
			SetEffect("LineageEffect_br.br_e_lamp_deco_d",100);
			break;
	}
}

function TweenStart ()
{
	Me.SetTimer(TIMEID_CREATESTART,TIME_CREATESTART);
	birthCircle_tex.SetAlpha(0);
	TweenAdd(240,0,3000,l2uiTweenScript.easeType.OUT_BOUNCE);
	//TweenAdd(240,0,3000,4);
}

function TweenHide ()
{
	birthCircle_tex.SetAlpha(240);
	TweenAdd(-100,1,2000,l2uiTweenScript.easeType.IN_STRONG);
	//TweenAdd(-100,1,2000,0);
}

function TweenShow ()
{
	birthCircle_tex.SetAlpha(140);
	TweenAdd(100,2,2000,l2uiTweenScript.easeType.OUT_STRONG);
	//TweenAdd(100,2,2000,1);
}

function Tweenkle (int Id)
{
	switch (Id)
	{
		case 0:
			TweenHide();
			break;
		case 1:
			TweenShow();
			break;
		case 2:
			TweenHide();
			break;
	}
}

function SetMyStat ()
{
	local UserInfo uInfo;

	if ( GetPlayerInfo(uInfo) )
	{
		myHP = uInfo.nCurHP;
		mySP = uInfo.nSP;
		myVP = uInfo.nVitality;
		SetMyStatusBars();
	}
}

function SetMyStatusBars ()
{
	local UserInfo uInfo;

	if ( GetPlayerInfo(uInfo) )
	{
		HPBar.SetPoint(myHP,uInfo.nMaxHP);
		txtSP.SetText(string(mySP));
		VPBar.SetPoint(myVP, MaxVitality);
		if(!insertedRequest)
		{
			HandleCanBtns();
		}
	}
}

function HandleCanBtns ()
{
	if ( CanChargeHP() )
	{
		btn0.EnableWindow();
	} else {
		btn0.DisableWindow();
	}
	if ( CanChargeSP() )
	{
		btn1.EnableWindow();
	} else {
		btn1.DisableWindow();
	}
	if ( CanChargeVP() )
	{
		btn2.EnableWindow();
	} else {
		btn2.DisableWindow();
	}
	if ( CanChargeTime() )
	{
		btn3.EnableWindow();
	} else {
		btn3.DisableWindow();
	}
}

function SetInfo(int NpcID, int Type, int Level)
{
	local string NpcName;

	NpcName = class'UIDATA_NPC'.static.GetNPCName(NpcID);
	txtResult0.SetText(GetSystemString(88) $ "." $ string(Level) @ GetGrade(Type) @ NpcName);
	SetGrade(Type);
}

function string GetGrade (int Type)
{
	switch (Type)
	{
		case 0:
			return GetSystemString(441);
			break;
		case 1:
			return GetSystemString(3290);
			break;
		case 2:
			return GetSystemString(13336);
			break;
	}
	return "";
}

function SetViewPort (int NpcID)
{
	m_ObjectViewport.SetSpawnDuration(0.1);
	m_ObjectViewport.SetNPCInfo(NpcID);
	m_ObjectViewport.SpawnNPC();
	m_ObjectViewport.PlayAnimation(HomunculusWndScript.TYPE_ANIM.birth);
}

function SetViewPortSetting (int Id)
{
	local float tmpScale;
	local int OffsetY;

	switch (Id)
	{
		case 0:
			tmpScale = 0.5;
			OffsetY = -1;
			Debug("SetViewPortSetting" @ string(tmpScale) @ string(OffsetY));
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
			tmpScale = 1.12;
			OffsetY = -1;
			break;
		// End:0xF0
		case 16:
		// End:0xF5
		case 17:
		// End:0x113
		case 18:
			tmpScale = 1.40f;
			OffsetY = -3;
			// End:0x1B2
			break;
		// End:0x118
		case 19:
		// End:0x11D
		case 20:
		// End:0x13B
		case 21:
			tmpScale = 1.60f;
			OffsetY = -1;
			// End:0x1B2
			break;
		// End:0x140
		case 22:
		// End:0x145
		case 23:
		// End:0x163
		case 24:
			tmpScale = 1.50f;
			OffsetY = -5;
			// End:0x1B2
			break;
		// End:0x168
		case 25:
		// End:0x16D
		case 26:
		// End:0x187
		case 27:
			tmpScale = 1.20f;
			OffsetY = 0;
			// End:0x1B2
			break;
		// End:0x18C
		case 28:
		// End:0x191
		case 29:
		// End:0x1AF
		case 30:
			tmpScale = 1.20f;
			OffsetY = -1;
			// End:0x1B2
			break;
	}
	m_ObjectViewport.SetCharacterScale(tmpScale);
	m_ObjectViewport.SetCharacterOffsetY(OffsetY);
}

function HandleDialogOK (bool bOK)
{
	if ( !DialogIsMine() )
	{
		return;
	}
	switch (DialogGetID())
	{
		case DIALOGID_START:
			if ( bOK )
			{
				HomunculusWndScript.API_C_EX_HOMUNCULUS_CREATE_START();
			}
			break;
	}
}

function TweenAdd (int TargetAlpha, int Id, int Duration, L2UITween.easeType Type)
//function TweenAdd (int TargetAlpha, int Id, int Duration, int Type)
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = "HomunculusWnd." $ m_WindowName;
	tweenObjectData.Id = Id;
	tweenObjectData.Target = birthCircle_tex;
	tweenObjectData.Duration = Duration;
	tweenObjectData.Alpha = TargetAlpha;
	tweenObjectData.ease = Type;
	TweenStop();
	l2uiTweenScript.AddTweenObject(tweenObjectData);
	curTweenID = Id;
}

function TweenStop ()
{
	if ( curTweenID != -1 )
	{
		l2uiTweenScript.StopTween("HomunculusWnd." $ m_WindowName,curTweenID);
	}
	curTweenID = -1;
}

function SetState (int State)
{
	CurrentState = State;
	switch (CurrentState)
	{
		case 0:
			TweenStop();
			birthCircle_tex.HideWindow();
			Me.KillTimer(TIMEID_COOL);
			btnMain0.ShowWindow();
			btnMain1.HideWindow();
			HandleCanBtns();
			resultWnd.HideWindow();
			HomunculusWndScript.HideNotice(0);
			break;
		case 1:
			birthCircle_tex.ShowWindow();
			if ( curTweenID == -1 )
			{
				TweenShow();
			}
			btnMain0.HideWindow();
			btnMain1.ShowWindow();
			btnMain1.DisableWindow();
			HandleCanBtns();
			resultWnd.HideWindow();
			HomunculusWndScript.HideNotice(0);
			break;
		case 2:
			TweenStop();
			birthCircle_tex.ShowWindow();
			btnMain0.HideWindow();
			btnMain1.ShowWindow();
			btnMain1.EnableWindow();
			HandleCanBtns();
			resultWnd.HideWindow();
			HomunculusWndScript.SetNotice(0);
			break;
	}
}

function HandleSwapCacha()
{
	isGachaState = ! isGachaState;
	Show();
}

function SetGachaState()
{
	isGachaState = true;
	Show();
}

function SetBirthState()
{
	isGachaState = false;
	Show();
}

function bool GetIsMaxHP ()
{
	return CurrentHP == currHmunCreateData.HpCount;
}

function bool GetIsMaxSP ()
{
	return CurrentSP == currHmunCreateData.SpCount;
}

function bool GetIsMaxVP ()
{
	return CurrentVP == currHmunCreateData.VpCount;
}

function bool GetIsMaxTime ()
{
	return currentExpiredTime == 0;
}

function bool CanChargeHP ()
{
	if ( CurrentState != 1 )
	{
		return False;
	}
	if ( GetIsMaxHP() )
	{
		return False;
	}
	return currHmunCreateData.HpVolume <= myHP;
}

function bool CanChargeSP ()
{
	if ( CurrentState != 1 )
	{
		return False;
	}
	if ( GetIsMaxSP() )
	{
		return False;
	}
	return currHmunCreateData.SpVolume <= mySP;
}

function bool CanChargeVP ()
{
	if ( CurrentState != 1 )
	{
		return False;
	}
	if ( GetIsMaxVP() )
	{
		return False;
	}
	return currHmunCreateData.VpVolume <= myVP;
}

function bool CanChargeTime ()
{
	if ( CurrentState != 1 )
	{
		return False;
	}
	if ( GetIsMaxTime() )
	{
		return False;
	}
	return currentExpiredTime <= currHmunCreateData.CostTime;
}

function bool BeProgress()
{
	return CurrentState != 0;
}

defaultproperties
{
}
