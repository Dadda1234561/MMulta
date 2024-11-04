class TargetStatusWnd extends UICommonAPI
	dependson(TargetStatusBuff2Wnd)
	dependson(TargetStatusBuff1Wnd);

const TimerValue1 = 1351;
const TimerValue2 = 6346;
const TimerValue3 = 4858;
const TimerValue4 = 7337;
const TimerValue5 = 3474;
const TimerValue6 = 5269;
const TimerValue7 = 5270; // ??���� 1��ꬡ�� ??��? ?������?��.
const TimerValue8 = 5271; // ??���� 2��ꬡ�� ??��? ?������?��.
const TimerValue9 = 5272; // ��??? ?������?��.
const CONTRACT_HEIGHT = 52;
const EXPAND_HEIGHT = 86;
const CONTRACT_CLASSIC_HEIGHT = 58;
const EXPAND_CLASSIC_HEIGHT = 102;
const ALLIANCECREST_HEIGHT = 67;
const ALLIANCECREST_CLASSIC_HEIGHT = 72;
const BUFF_SIZE_BIG = 24;
const BUFF_SIZE_SMALL = 16;

enum WARMARKTYPE
{
	TYPE_WarMarkNone,
	TYPE_Dominion,
	TYPE_DominionPenalty,
	TYPE_BlueAttackLeader,
	TYPE_BlueAttackLeaderPenalty,
	TYPE_BlueSword,
	TYPE_BlueSwordPenalty,
	TYPE_BlueLeader,
	TYPE_BlueLeaderPenalty,
	TYPE_BlueShield,
	TYPE_BlueShieldPenalty,
	TYPE_RedAttackLeader,
	TYPE_RedAttackLeaderPenalty,
	TYPE_RedSword,
	TYPE_RedSwordPenalty,
	TYPE_RedLeader,
	TYPE_RedLeaderPenalty,
	TYPE_RedShield,
	TYPE_RedShieldPenalty,
	TYPE_DecalreWarBothSide,
	TYPE_DecalreWarOneSide,
	TYPE_UserWatcher,
	TYPE_DecalreWarBothSide_UserWatcher,
	TYPE_DecalreWarOneSide_UserWatcher
};

struct CustomTargetInfo
{
	var int nTargetId;
	var int nFlags;
	var int nTargetCP;
};

var bool m_bExpand;

var int m_TargetLevel;
var int m_targetID;
var bool m_rotated;
var bool m_bShow;
var string g_NameStr;
var Vector targetLoc;	//???°Щ??? ??§???¤???
var WindowHandle Me1;
var WindowHandle Me2;
var WindowHandle Me;
var StatusBarHandle barMP;
var StatusBarHandle barHP;
var TextBoxHandle txtPledgeAllianceName;
var TextBoxHandle txtGearScorePoints;
var TextureHandle texPledgeAllianceCrest;
var TextBoxHandle txtAlliance;
var TextBoxHandle txtGearScore;
var TextBoxHandle txtPledgeName;
var TextureHandle texPledgeCrest;
var TextBoxHandle txtPledge;
var NameCtrlHandle RankName;
var NameCtrlHandle UserName;
var ButtonHandle btnClose;
var TreeHandle NpcInfo;
var ButtonHandle btnExpand;
var ButtonHandle btnContract;
var WindowHandle TargetStatusBuff1Wnd;
var WindowHandle TargetStatusBuff2Wnd;

var WindowHandle BuffWnd;

//????°?? ?????????? ??л??? ????????
var ButtonHandle btnBuffMoreView1;
var ButtonHandle btnBuffMoreView2;

//????°?? µ???????????? y?????? °??
var int yPosView2;

//???????? ?????? ???? StatusIconHandle
var StatusIconHandle StatusIcons;

//°?? ???????? ??¤????? ??Ц??? ???и????
var array<StatusIconInfo> arrMyBuff;
var array<StatusIconInfo> arrOtherBuff;
var array<StatusIconInfo> arrMyDebuff;
var array<StatusIconInfo> arrOtherDebuff;

//???????? ¶??????? ??«?о???
var int lineCount;

var string strSelectTarget;

var ProgressCtrlHandle barSkillProgress1;
var NameCtrlHandle skillProgressName1;

var TextureHandle barSkillProgressEff1_Left;
var TextureHandle barSkillProgressEff1_Center;
var TextureHandle barSkillProgressEff1_Right;

var ProgressCtrlHandle barSkillProgress2;
var NameCtrlHandle skillProgressName2;

var TextureHandle barSkillProgressEff2_Left;
var TextureHandle barSkillProgressEff2_Center;
var TextureHandle barSkillProgressEff2_Right;
var TextureHandle texMark;

var bool bIsShowBackup;
var int m_TargetIDBackup;

var string m_WindowName;

var TextureHandle SiegeMark;
var TextureHandle DeathTexture;

var CustomTargetInfo customInfo;


function OnRegisterEvent()
{
	RegisterEvent(EV_TargetUpdate);
	RegisterEvent(EV_TargetHideWindow);
	RegisterEvent(EV_UpdateHP);
	RegisterEvent(EV_UpdateMP);
	RegisterEvent(EV_UpdateMaxHP);
	RegisterEvent(EV_UpdateMaxMP);
	RegisterEvent(EV_UpdateMyHP);
	RegisterEvent(EV_UpdateMyMP);
	RegisterEvent(EV_UpdateMyMaxHP);
	RegisterEvent(EV_UpdateMyMaxMP);
	RegisterEvent(EV_ReceiveTargetLevelDiff);

	//??±???(???????? ???????? ??¤????? ????»?Ц??? Event)
	RegisterEvent(EV_TargetSpelledList);
	//???°Щ??? ?????? ?????? ??¤??? ????»?Ц??? Event
	RegisterEvent(EV_TargetSkillInfo);
	//???°Щ??? ?????? ?????? ??л??? ??¤??? ????»?Ц??? Event
	RegisterEvent(EV_TargetSkillCancel);

	// ???°Щ??? ??в??? »????????? 
	RegisterEvent(EV_GamingStateExit);

	// °Ф??У»???°?? ???°жµ???? Show ?????????±в?§??? ????°?? 
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_GamingStatePreExit);

	RegisterEvent(EV_Restart);

	RegisterEvent(EV_UpdateWarMark);
	RegisterEvent(EV_UpdateTargetDead);
	RegisterEvent(EV_CustomPacketID(class'UICustomPacket'.const.S_EX_C_TARGET_STATUS));
}

function OnLoad()
{
	local bool nOption;

	SetClosingOnESC();
	InitializeCOD();
	OnShowProcess();
	Load();
	nOption = GetOptionBool("ScreenInfo", "StrangeStateBox");
	StateBoxShow(nOption);
}

function InitializeCOD()
{
	Me = GetWindowHandle(m_WindowName);
	barMP = GetStatusBarHandle(m_WindowName $ ".barMP");
	barHP = GetStatusBarHandle(m_WindowName $ ".barHP");
	txtPledgeAllianceName = GetTextBoxHandle(m_WindowName $ ".txtPledgeAllianceName");
	texPledgeAllianceCrest = GetTextureHandle(m_WindowName $ ".texPledgeAllianceCrest");
	txtAlliance = GetTextBoxHandle(m_WindowName $ ".txtAlliance");
	txtPledgeName = GetTextBoxHandle(m_WindowName $ ".txtPledgeName");
	texPledgeCrest = GetTextureHandle(m_WindowName $ ".texPledgeCrest");
	txtPledge = GetTextBoxHandle(m_WindowName $ ".txtPledge");
	RankName = GetNameCtrlHandle(m_WindowName $ ".RankName");
	UserName = GetNameCtrlHandle(m_WindowName $ ".UserName");
	btnClose = GetButtonHandle(m_WindowName $ ".btnClose");
	txtGearScore = GetTextBoxHandle(m_WindowName $ ".txtGearScore");
	txtGearScorePoints = GetTextBoxHandle(m_WindowName $ ".txtGearScorePoints"); // ��ڬ٬լ֬�
	txtGearScorePoints.setText("-");

	NpcInfo = GetTreeHandle(m_WindowName $ ".NpcInfo");
	Me1 = GetWindowHandle(m_WindowName);

	btnExpand = GetButtonHandle(m_WindowName $ ".btnExpand");
	btnContract = GetButtonHandle(m_WindowName $ ".btnContract");

	//??±???
	BuffWnd = GetWindowHandle(m_WindowName $ ".BuffWnd");
	TargetStatusBuff1Wnd = GetWindowHandle("TargetStatusBuff1Wnd");
	TargetStatusBuff2Wnd = GetWindowHandle("TargetStatusBuff2Wnd");
	StatusIcons = GetStatusIconHandle(m_WindowName $ ".BuffWnd.StatusIcons");
	btnBuffMoreView1 = GetButtonHandle(m_WindowName $ ".BuffWnd.btnBuffMoreView1");
	btnBuffMoreView2 = GetButtonHandle(m_WindowName $ ".BuffWnd.btnBuffMoreView2");

	barSkillProgress1 = GetProgressCtrlHandle(m_WindowName $ ".SkillProgressWnd1.barSkillProgress1");
	skillProgressName1 = GetNameCtrlHandle(m_WindowName $ ".SkillProgressWnd1.SkillProgressName1");

	barSkillProgressEff1_Left = GetTextureHandle(m_WindowName $ ".SkillProgressWnd1.barSkillProgressEff1_Left");
	barSkillProgressEff1_Center = GetTextureHandle(m_WindowName $ ".SkillProgressWnd1.barSkillProgressEff1_Center");
	barSkillProgressEff1_Right = GetTextureHandle(m_WindowName $ ".SkillProgressWnd1.barSkillProgressEff1_Right");

	barSkillProgress2 = GetProgressCtrlHandle(m_WindowName $ ".SkillProgressWnd2.barSkillProgress2");
	skillProgressName2 = GetNameCtrlHandle(m_WindowName $ ".SkillProgressWnd2.SkillProgressName2");

	barSkillProgressEff2_Left = GetTextureHandle(m_WindowName $ ".SkillProgressWnd2.barSkillProgressEff2_Left");
	barSkillProgressEff2_Center = GetTextureHandle(m_WindowName $ ".SkillProgressWnd2.barSkillProgressEff2_Center");
	barSkillProgressEff2_Right = GetTextureHandle(m_WindowName $ ".SkillProgressWnd2.barSkillProgressEff2_Right");

	texMark = GetTextureHandle(m_WindowName $ ".texMark");

	SiegeMark = GetTextureHandle(m_WindowName $ ".SiegeMark");
	DeathTexture = GetTextureHandle(m_WindowName $ ".DeathTexture");
}

function Load()
{
	g_NameStr = "";
	m_bShow = false;
	m_targetID = -1;
	m_rotated = false;

	skillBarVisible(false, 1);
	showBuffMoreBtn(false, 1);
	skillBarVisible(false, 2);
	showBuffMoreBtn(false, 2);

	yPosView2 = 0;
	strSelectTarget = "Friendly";
}

function OnShowProcess()
{
}

function OnRotate1()
{
	Me2.SetAlpha(0);
	Me2.ShowWindow();
	Me.SetTimer(TimerValue1, 150);
}

function OnRotate2()
{
	Me1.SetAlpha(0);
	Me1.ShowWindow();
	Me.SetTimer(TimerValue2, 150);
}

function OnRotateClose()
{
	if(GetGameStateName() != "SPECIALCAMERASTATE")
	{
		Me1.SetAlpha(0);
		Me1.ShowWindow();
		Me.SetTimer(TimerValue5, 150);
	}
}

function OnRotateReset()
{
	Me1.ShowWindow();
	Me2.HideWindow();
	Me1.SetAlpha(255);
	Me2.SetAlpha(0);
	m_rotated = false;
	HandleTargetUpdate();
}

function OnTimer(int TimerID)
{
	if(TimerID == TimerValue1)
	{
		Me.KillTimer(TimerValue1);
		Me2.SetAlpha(255, 0.4f);
		Me1.SetAlpha(0);
		Me.SetTimer(TimerValue3, 300);
	}
	if(TimerID == TimerValue3)
	{
		Me.KillTimer(TimerValue3);
		Me1.HideWindow();
		m_rotated = true;
	}
	if(TimerID == TimerValue2)
	{
		Me.KillTimer(TimerValue2);
		Me1.SetAlpha(255, 0.4f);
		Me2.SetAlpha(0);
		Me.SetTimer(TimerValue4, 300);
	}
	if(TimerID == TimerValue4)
	{
		Me.KillTimer(TimerValue4);
		Me2.HideWindow();
		m_rotated = false;
	}
	if(TimerID == TimerValue5)
	{
		Me.KillTimer(TimerValue5);
		Me1.SetAlpha(255, 0.4f);
		Me2.SetAlpha(0);
		Me.SetTimer(TimerValue6, 300);
	}
	if(TimerID == TimerValue6)
	{
		Me.KillTimer(TimerValue6);
		Me2.HideWindow();
		Me1.HideWindow();
		m_rotated = false;
	}
	if(TimerID == TimerValue7)
	{
		Me.KillTimer(TimerValue7);
		skillBarVisible(false, 1);
	}
	if(TimerID == TimerValue8)
	{
		Me.KillTimer(TimerValue8);
		skillBarVisible(false, 2);
	}
	if(TimerID == TimerValue9)
	{
		Me.KillTimer(TimerValue9);
		skillBarVisible(false, 1);
		skillBarVisible(false, 2);
	}
}

function OnShow()
{
	m_bShow = true;
}

function OnHide()
{
	m_bShow = false;
	g_NameStr = "";
	m_targetID = 0;
}

function EachSeverEnterState(name a_CurrentStateName)
{
	local int tmpInt;

	GetINIInt(m_WindowName, "e", tmpInt, "WindowsInfo.ini");
	m_bExpand = bool(tmpInt);
	SetExpandMode(m_bExpand, true);
}

function OnEnterState(name a_CurrentStateName)
{
	if(getInstanceUIData().getIsLiveServer())
	{
		EachSeverEnterState(a_CurrentStateName);
	}
}

function OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().getIsLiveServer())
	{
		EachServerEvent(Event_ID, param);
	}
}

function EachServerEvent(int Event_ID, string param)
{
	if(Event_ID == EV_TargetUpdate)
	{
		if(m_rotated)
		{
			OnRotateReset();
		}
		else
		{
			HandleTargetUpdate();
		}

		// ?????? UI???? ???????°?? ?????? »????????? ESC??°??? ??©??? °ж????, ?????????? ??Щ??? ???°Щ??? ??в°??
		// ???????°?? ??Ш??? UI???? ?????????? ???µµ·?? ??С???. 
		// ±Ч·????? esc ??°·?? ????·?? ??Ц??? UI???? ???????? ???? ??Цµµ·?? ???±?? ??§?Ш???????.
		// ?????? ??¤????? ???®???? ???Я»??.. api ·?? ??Ш??? ??Тµ??.
		/*
		if(!Me.IsShowWindow())
		{
			Me.ShowWindow();
			Me.SetFocus();
			Me.HideWindow();
		}
		*/
	}
	else if(Event_ID == EV_TargetHideWindow)
	{
		HandleTargetHideWindow();
	}
	else if(Event_ID == EV_ReceiveTargetLevelDiff)
	{
		HandleReceiveTargetLevelDiff(param);
	}
	else if(Event_ID == EV_UpdateHP || Event_ID == EV_UpdateMyHP)
	{
		HandleUpdateGauge(param, 0);
	}
	else if(Event_ID == EV_UpdateMaxHP || Event_ID == EV_UpdateMyMaxHP)
	{
		HandleUpdateGauge(param, 0);
	}
	else if(Event_ID == EV_UpdateMP || Event_ID == EV_UpdateMyMP)
	{
		HandleUpdateGauge(param, 1);
	}
	else if(Event_ID == EV_UpdateMaxMP || Event_ID == EV_UpdateMyMaxMP)
	{
		HandleUpdateGauge(param, 1);
	}
	else if(Event_ID == EV_TargetSpelledList)
	{
		HandleTargetSpelledList(param);
	}
	else if(Event_ID == EV_TargetSkillInfo)
	{
		HandleTargetSkillInfo(param);
	}
	else if(Event_ID == EV_TargetSkillCancel)
	{
		HandleSkillCancel();
	}
	else if(Event_ID == EV_GamingStateExit)
	{
		RequestTargetCancel();
	}
	else if(Event_ID == EV_GamingStateEnter)
	{
		if(bIsShowBackup)
		{
			if(m_TargetIDBackup > 0)
			{
				RequestTargetUser(m_TargetIDBackup);
			}
		}
	}
	else if(Event_ID == EV_GamingStatePreExit)
	{
		bIsShowBackup = Me.IsShowWindow();
		m_TargetIDBackup = m_targetID;
	}
	else if(Event_ID == EV_Restart)
	{
		bIsShowBackup = false;
		m_TargetIDBackup = -1;
	}
	else if(Event_ID == EV_UpdateWarMark)
	{
		HandleUpdateWarMark(param);
	}
	else if(Event_ID == EV_UpdateTargetDead)
	{
		HandleUpdateTargetDead(param);
	}
	else if(Event_ID == EV_CustomPacketID(class'UICustomPacket'.const.S_EX_C_TARGET_STATUS))
	{
		Rs_S_EX_C_TARGET_STATUS(param);
	}
}

function Rs_S_EX_C_TARGET_STATUS(string param)
{
	local int nGearScore;
	local int nTargetId;

	ParseInt(param, "nTargetId", nTargetId);
	ParseInt(param, "nGearScore", nGearScore);

	customInfo.nTargetCP = nGearScore;
	txtGearScorePoints.setTextColor(getInstanceL2Util().ColorGold);
	if (customInfo.nTargetCP <= 0)
		txtGearScorePoints.setText("-");
	else
		txtGearScorePoints.setText(string(nGearScore));
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local int targetID;
	local string UserName;
	local UserInfo myInfo;

	rectWnd = Me.GetRect();
	targetID = class'UIDATA_TARGET'.static.GetTargetID();

	if(targetID > 0)
	{
		GetPlayerInfo(myInfo);
		if(X > rectWnd.nX && X < rectWnd.nX + rectWnd.nWidth)
		{
			if(Y > rectWnd.nY && Y < rectWnd.nY + rectWnd.nHeight)
			{
				UserName = class'UIDATA_USER'.static.GetUserName(targetID);
				if(UserName != "")
				{
					getInstanceContextMenu().execContextEvent(UserName, targetID, X, Y);
				}
			}
		}
	}
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnClose":
			OnCloseButton();
			break;
		case "RotateButton1":
			OnRotate1();
			break;
		case "RotateButton2":
			OnRotate2();
			break;
		case "btnExpand":
			SetExpandMode(false, true);
			break;
		case "btnContract":
			SetExpandMode(true, true);
			break;
	}
}

function API_C_EX_C_ITEM_ENCHANT_LIMIT(int objectId, int action)
{
	local array<byte> stream;
	local UICustomPacket._C_EX_C_TARGET_ACTION packet;
	
	packet.nObjectId = objectId;
	packet.cAction = action;
	
	if(! class'UICustomPacket'.static.Encode_C_EX_C_TARGET_ACTION(stream, packet))
	{
		return;
	}
	class'UICustomPacket'.static.RequestUICustomPacket(class'UICustomPacket'.const.C_EX_C_TARGET_ACTION, stream);
	Debug("----> Api Call : _C_EX_C_TARGET_ACTION");	
}

//???·??
function OnCloseButton()
{
	RequestTargetCancel();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

function HandleTargetHideWindow()
{
	if(m_rotated)
	{
		OnRotateClose();
	}
	else
	{
		Me.HideWindow();
	}
}

//HP,MP ???µ??????
function HandleUpdateGauge(string param, int Type)
{
	local int ServerID;

	if(m_bShow)
	{
		ParseInt(param, "ServerID", ServerID);

		if(m_targetID == ServerID)
		{
			HandleTargetUpdateGauge(Type);
		}
	}
}

//???°Щ°???? ·??????? ??????
function HandleReceiveTargetLevelDiff(string param)
{
	ParseInt(param, "LevelDiff", m_TargetLevel);
	HandleTargetUpdate();
}

//???°?? ??¤??? ???µ?????? ??????(HP, MP)
function HandleTargetUpdateGauge(int Type)
{
	local UserInfo Info;
	local int targetID;

	//???°ЩID ????о??±??
	targetID = class'UIDATA_TARGET'.static.GetTargetID();

	if(targetID < 1)
	{
		if(m_rotated)
		{
			OnRotateClose();
		}
		else
		{
			Me.HideWindow();
		}
		return;
	}
	m_targetID = targetID;
	GetTargetInfo(Info);
	switch(Type)
	{
		case 0:
			UpdateHPBar(Info.nCurHP, Info.nMaxHP);
			break;
		case 1:
			UpdateMPBar(Info.nCurMP, Info.nMaxMP);
			break;
	}
}


function ToggleGearScore(bool bEnabled)
{
	if (bEnabled)
	{
		txtGearScore.ShowWindow();
		if (customInfo.nTargetCP <= 0)
			txtGearScorePoints.setText("-");
		else
			txtGearScorePoints.setText(string(customInfo.nTargetCP));
		txtGearScorePoints.ShowWindow();
	}
	else
	{
		txtGearScore.HideWindow();
		txtGearScorePoints.setText("");
		txtGearScorePoints.HideWindow();
	}
}

//???°?? ??¤??? ???µ?????? ??????
function HandleTargetUpdate(optional bool bExpand)
{
	local Rect rectWnd;
	local string strTmp;

	local int TargetID;
	local int PlayerID;
	local int PetID;
	local int ClanType;
	local int ClanNameValue;

	//???°?? ??У??? ??¤???
	local bool bIsServerObject;
	local bool bIsHPShowableNPC;	//°?????????+
	local bool bIsVehicle;

	local string Name;
	local string NameRank;
	local color TargetNameColor;

	//ServerObject
	local int ServerObjectNameID;
	local Actor.EL2ObjectType ServerObjectType;

	//Vehicle
	local Vehicle VehicleActor;
	local string DriverName;

	//HP,MP
	local bool		bShowHPBar;
	local bool		bShowMPBar;
	
	//?????? ??¤???
	local bool		bShowPledgeInfo;
	local bool		bShowPledgeTex;
	local bool		bShowPledgeAllianceTex;
	local string	PledgeName;
	local string	PledgeAllianceName;
	local string	GearScorePoints;
	local texture	PledgeCrestTexture;
	local texture	PledgeAllianceCrestTexture;
	local color PledgeNameColor;
	local color PledgeAllianceNameColor;
	local color GearScoreColor;

	//NPC??????
	local bool		 bShowNpcInfo;
	local array<int> arrNpcInfo;

	//»??·??оTarget???°???
	local bool		IsTargetChanged;

	local bool		WantHideName;

	local UserInfo	Info;
	local PetInfo   petInfo;
	local UserInfo	myInfo;

	local color WhiteColor;	//  ????б»???? ??????.

	// µ?????????,???????????? µ????? ??§??? ????¤??? Rect
	local Rect textRect;

	local string warMarkTextureName;

	WhiteColor.R = 0;
	WhiteColor.G = 0;
	WhiteColor.B = 0;

	//???°ЩID ????о??±??
	TargetID = class'UIDATA_TARGET'.static.GetTargetID();

	// Debug("???°?? °»???? " @ TargetID);

	if(TargetID < 1)
	{
		if(m_rotated)
		{
			OnRotateClose();
		}
		else
		{
			Me.HideWindow();
		}
		return;
	}

	//???°Щ??? ???Щ??о????°???
	if(m_targetID != TargetID)
	{
		IsTargetChanged = true;

		if(!bExpand)
		{
			DeathTexture.HideWindow();
			SiegeMark.HideWindow();
		}
	}
	m_targetID = TargetID;

	GetTargetInfo(Info);
	GetUserInfo(targetID, myInfo);

	// Hide gear score info
	ToggleGearScore(false);

	//????°??µ?? ??»???.
	if(Info.TacticSign == 0)
	{
		texMark.HideWindow();
	}
	else
	{
		texMark.ShowWindow();
		texMark.SetTexture("l2ui_Ct1.TargetStatusWnd_DF_mark_0" $ string(Info.TacticSign));
	}

	WantHideName = Info.WantHideName;

	//???±в???
	rectWnd = Me.GetRect();
	PledgeName = GetSystemString(431);
	PledgeAllianceName = GetSystemString(591);
	GearScorePoints = GetSystemString(431);
	PledgeNameColor.R = 128;
	PledgeNameColor.G = 128;
	PledgeNameColor.B = 128;
	PledgeAllianceNameColor.R = 128;
	PledgeAllianceNameColor.G = 128;
	PledgeAllianceNameColor.B = 128;
	GearScoreColor.R = 128;
	GearScoreColor.G = 128;
	GearScoreColor.B = 128;


	//???°?? ?????? »??±??
	TargetNameColor = GetTargetNameColor(m_TargetLevel);
	bIsServerObject = class'UIDATA_TARGET'.static.IsServerObject();
	bIsVehicle = class'UIDATA_TARGET'.static.IsVehicle();
	txtGearScorePoints.setTextColor(getInstanceL2Util().ColorGold);

	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//StaticObject(door µоµо)
	if(bIsServerObject)
	{
		ServerObjectType = class'UIDATA_STATICOBJECT'.static.GetServerObjectType(m_targetID);

		if(ServerObjectType == EL2_AIRSHIPKEY)
		{
			Name = GetSystemString(1966);	//??¶??? ????
			NameRank = "";
		}
		else if(ServerObjectType == EL2_STATUE)
		{
			Name = class'UIDATA_STATICOBJECT'.static.GetServerObjectName(m_targetID);
			NameRank = "";
		}
		else
		{
			ServerObjectNameID = class'UIDATA_STATICOBJECT'.static.GetServerObjectNameID(m_targetID);

			if(ServerObjectNameID > 0)
			{
				Name = class'UIDATA_STATICOBJECT'.static.GetStaticObjectName(ServerObjectNameID);
				NameRank = "";
			}
		}

		UserName.SetName(Name, NCT_Normal, TA_Center);
		//~ NameTxt.SetName(Name, NCT_Normal, TA_Center);
		RankName.SetName(NameRank, NCT_Normal, TA_Center);

		//HP??????
		if(ServerObjectType == EL2_DOOR)
		{
			if(class'UIDATA_STATICOBJECT'.static.GetStaticObjectShowHP(m_targetID))
			{
				bShowHPBar = true;
				UpdateHPBar(class'UIDATA_STATICOBJECT'.static.GetServerObjectHP(m_targetID), class'UIDATA_STATICOBJECT'.static.GetServerObjectMaxHP(m_targetID));
			}
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//??»°???°???
	else if(bIsVehicle)
	{
		//????а??? ???°Щ??? ?????? ???·??С???, ttmayrin 2009.7.7
		HandleTargetHideWindow();
		return;

		//TO DO : ???и??????, ?????????? SYSSTRING¶????? ?????????????? ????о????? °????·?? ??????.
		UserName.SetName("AirShip", NCT_Normal, TA_Center);

		VehicleActor = Vehicle(class'UIDATA_TARGET'.static.GetTargetActor());

		if(VehicleActor != None)
		{
			//??±??? ??????
			if(VehicleActor.DriverID > 0)
			{
				DriverName = class'UIDATA_USER'.static.GetUserName(VehicleActor.DriverID);
			}
			if(Len(DriverName) < 1)
			{
				DriverName = GetSystemString(1967);	// ??¶??»?? ??????
			}
			RankName.SetName(DriverName, NCT_Normal, TA_Center);

			//Fuel
			//VehicleActor.MaxFuel
			//VehicleActor.CurFuel
			
			//HP
			//VehicleActor.MaxHP
			//VehicleActor.CurHP
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//???°ЩID???? ??Ц??µ?? ????§??? ????????Щ???, ??Ц?????Ц??? ??????в????·?? °?????
	else if(Len(Info.Name) < 1)
	{
		Name = class'UIDATA_PARTY'.static.GetMemberVirtualName(m_targetID);

		if(Name == "")
		{
			Name = class'UIDATA_PARTY'.static.GetMemberName(m_targetID);
		}
		NameRank = "";
		//debug("m_targetID" $ m_targetID $ ", Info.Name : " $ Info.Name $ ", Name : " $ Name);
		UserName.SetName(Name, NCT_Normal, TA_Center);
		//~ NameTxt.SetName(Name, NCT_Normal,TA_Center);
		RankName.SetName(NameRank, NCT_Normal, TA_Center);

		//?????? ????°??
		if(class'UIDATA_PARTY'.static.GetMemberTacticalSign(m_targetID) == 0)
		{
			texMark.HideWindow();

			if(getInstanceUIData().getIsClassicServer())
			{
				UserName.SetWindowSizeRel(1.0, 0.0, -43, 14);
				UserName.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 30, 8);
			}
			else
			{
				UserName.SetWindowSizeRel(1.0, 0.0, -33, 14);
				UserName.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 18, 8);
			}
		}
		else
		{
			texMark.ShowWindow();
			texMark.SetTexture("l2ui_Ct1.TargetStatusWnd_DF_mark_0" $ string(class'UIDATA_PARTY'.static.GetMemberTacticalSign(m_targetID) - 1));
			UserName.SetWindowSizeRel(1.0f, 0, -54, 14);
			UserName.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 36, 8);
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Npc or Pc ???? °ж????
	else
	{
		PlayerID = class'UIDATA_PLAYER'.static.GetPlayerID();
		// 2010.7.13
		GetPetInfo(petInfo);
		PetID = Info.nID; // class'UIDATA_PET'.static.GetPetID();

		bIsHPShowableNPC = class'UIDATA_TARGET'.static.IsHPShowableNPC();

		//if((Info.bNpc && !Info.bPet && Info.bCanBeAttacked)||	//?????°ж???
		if((Info.bNpc && !Info.bPet && bIsHPShowableNPC)||	//?????°ж???
			(PlayerID>0 && m_targetID == PlayerID)||		//?????°ж???
			(Info.bNpc && Info.bPet && m_targetID == PetID)||	//??к??°ж???
			(Info.bNpc && bIsHPShowableNPC)	)		//°?????????
		{
			//?????Э ?????????? ??Ч»?? ???»???·?? ???????? ???? ????д°?? ??Ц??? ?????????? °ж????
			if(IsAllWhiteID(Info.nClassID))
			{
				Name = Info.Name;
				NameRank = "";
				//debug("m_targetID" $ m_targetID $ ", Info.Name : " $ Info.Name $ ", Name : " $ Name);
				UserName.SetName(Name, NCT_Normal, TA_Center);
				//~ NameTxt.SetName(Name, NCT_Normal,TA_Center);
				RankName.SetName(NameRank, NCT_Normal, TA_Center);
					
				//HP??????
				if(!(IsNoBarID(Info.nClassID)))
				{
					bShowHPBar = true;
					UpdateHPBar(Info.nCurHP, Info.nMaxHP);
				}
			}
			else
			{
				Name = Info.Name;
				NameRank = "";
				UserName.SetNameWithColor(Name, NCT_Normal, TA_Center, TargetNameColor);
				//~ NameTxt.SetNameWithColor(Name, NCT_Normal, TA_Center, TargetNameColor);
				RankName.SetName(NameRank, NCT_Normal, TA_Center);
				
				//HP??????
				//branch gd35_0828
				// ??л??? ?????? ??Ц????? - gorillazin 13.10.15.
				if(Info.nMaxHP > 0)
				{
					bShowHPBar = true;
					UpdateHPBar(Info.nCurHP, Info.nMaxHP);
				}
				//end of branch

				//MP??????
				//if(!(Info.bNpc && !Info.bPet && Info.bCanBeAttacked))
				if(!Info.bNpc && !Info.bPet)
				{
					//branch gd35_0828
					// ??л??? ?????? ??Ц????? - gorillazin 13.10.15.
					if(Info.nMaxMP > 0)
					{
						bShowMPBar = true;
						UpdateMPBar(Info.nCurMP, Info.nMaxMP);
					}
					//end of branch
				}
			}
			if(getInstanceUIData().getIsLiveServer() && class'UIDATA_PLAYER'.static.IsInDethrone())
			{
				GetPlayerInfo(myInfo);

				if(myInfo.nWorldID == Info.nWorldID)
				{
					warMarkTextureName = "";
				}
				else
				{
					if(class'UIDATA_USER'.static.IsDethroneComrade(Info.nID))
					{
						warMarkTextureName = GetServerMarkNameTarget(Info.nWorldID, false);									
					}
					else
					{
						if(class'UIDATA_USER'.static.IsDethroneEnemy(Info.nID))
						{
							warMarkTextureName = GetServerMarkNameTarget(Info.nWorldID, true);
						}
					}
				}
				Debug("?????��?? ???�? " @ (GetServerMarkNameTarget(Info.nWorldID, true)));
				Debug("nWorldID" @ string(Info.nWorldID));
				Debug("warMarkTextureName" @ warMarkTextureName);
				Debug("class'UIDATA_USER'.static.IsDethroneComrade(info.nWorldID)" @ string(class'UIDATA_USER'.static.IsDethroneComrade(Info.nWorldID)));
				if(warMarkTextureName == "")
				{
					SiegeMark.HideWindow();
				}
				else
				{
					SiegeMark.SetTexture(warMarkTextureName);
					SiegeMark.ShowWindow();
				}
			}
		}
		//Npc or Other Pc
		else
		{
			Name = Info.Name;

			if(WantHideName)
			{
				RankName.HideWindow();
			}
			if(Info.bNpc)
			{
				NameRank = "";
				g_NameStr = "";
				ToggleGearScore(false);
			}
			else
			{
				// ?????? ????°?????
				if(getInstanceUIData().getIsLiveServer())NameRank = "";
				else NameRank = GetUserRankString(Info.nUserRank);

				g_NameStr = Name;

				if(getInstanceUIData().getIsLiveServer() && class'UIDATA_PLAYER'.static.IsInDethrone())
				{
					GetPlayerInfo(myInfo);

					if(myInfo.nWorldID == Info.nWorldID)
					{
						warMarkTextureName = "";
					}
					else
					{
						if(class'UIDATA_USER'.static.IsDethroneComrade(Info.nID))
						{
							warMarkTextureName = GetServerMarkNameTarget(Info.nWorldID, false);
						}
						else
						{
							if(class'UIDATA_USER'.static.IsDethroneEnemy(Info.nID))
							{
								warMarkTextureName = GetServerMarkNameTarget(Info.nWorldID, true);
							}
						}
					}
					Debug("?????��?? ???�? " @ (GetServerMarkNameTarget(Info.nWorldID, true)));
					Debug("nWorldID" @ string(Info.nWorldID));
					Debug("warMarkTextureName" @ warMarkTextureName);
					Debug("class'UIDATA_USER'.static.IsDethroneComrade(info.nWorldID)" @ string(class'UIDATA_USER'.static.IsDethroneComrade(Info.nWorldID)));

					if(warMarkTextureName == "")
					{
						SiegeMark.HideWindow();
					}
					else
					{
						SiegeMark.SetTexture(warMarkTextureName);
						SiegeMark.ShowWindow();
					}
				}
			}
			UserName.SetName(Name, NCT_Normal, TA_Center);
			//~ NameTxt.SetName(Name, NCT_Normal, TA_Center);
			RankName.SetName(NameRank, NCT_Normal, TA_Center);
		}

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/// ????°?? ??¤??? ??????
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if(m_bExpand)
		{
			if(Info.bNpc && 0 >= Info.nMasterID)
			{
				if(class'UIDATA_NPC'.static.GetNpcProperty(Info.nClassID, arrNpcInfo))
				{
					bShowNpcInfo = true;

					//??????????????·С???? Npc???????????? ????°??
					//???°Щ??? ???Щ??о???»¶§??? ??¤????? °»????С???. ???±Ч·?? HP???? °»???µ?? ¶§ ±????Ъ°?????
					if(IsTargetChanged)
					{
						UpdateNpcInfoTree(arrNpcInfo);
					}
				}
			}
			else
			{
				ToggleGearScore(true);

				bShowPledgeInfo = true;
				if (targetID == myInfo.nID)
				{
					GearScorePoints = string(myInfo.nActivatedElixirPoint);
				}
				else
				{
					GearScorePoints = string(Info.nNotoriety);
				}
				GearScoreColor = getInstanceL2Util().ColorGold;
				if(Info.nClanID > 0)
				{
					PledgeName = class'UIDATA_CLAN'.static.GetName(Info.nClanID);
					PledgeNameColor.R = 176;
					PledgeNameColor.G = 152;
					PledgeNameColor.B = 121;

					if(PledgeName != "" && class'UIDATA_USER'.static.GetClanType(m_targetID, ClanType) && class'UIDATA_CLAN'.static.GetNameValue(Info.nClanID, ClanNameValue))
					{
						if(ClanType == CLAN_ACADEMY)
						{
							PledgeNameColor.R = 209;
							PledgeNameColor.G = 167;
							PledgeNameColor.B = 2;
						}
						else if(ClanNameValue > 0)
						{
							PledgeNameColor.R = 0;
							PledgeNameColor.G = 130;
							PledgeNameColor.B = 255;
						}
						else if(ClanNameValue < 0)
						{
							PledgeNameColor.R = 255;
							PledgeNameColor.G = 0;
							PledgeNameColor.B = 0;
						}
					}

					//?????? ??Ш????? ????о??±??
					if(class'UIDATA_CLAN'.static.GetCrestTexture(Info.nClanID, PledgeCrestTexture))
					{
						bShowPledgeTex = true;
						texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);
					}
					else
					{
						bShowPledgeTex = false;
					}
					
					//µ????????? ???Ч ??¶???
					strTmp = class'UIDATA_CLAN'.static.GetAllianceName(Info.nClanID);

					if(Len(strTmp) > 0)
					{
						//µ????? ?????? »??±??
						PledgeAllianceName = strTmp;
						PledgeAllianceNameColor.R = 176;
						PledgeAllianceNameColor.G = 155;
						PledgeAllianceNameColor.B = 121;
						
						//µ????? ??Ш????? ????о??±??
						if(class'UIDATA_CLAN'.static.GetAllianceCrestTexture(Info.nClanID, PledgeAllianceCrestTexture))
						{
							bShowPledgeAllianceTex = true;
							texPledgeAllianceCrest.SetTextureWithObject(PledgeAllianceCrestTexture);
						}
						else
						{
							bShowPledgeAllianceTex = false;
						}
					}
				}
			}
		}
		else
		{
			ToggleGearScore(false);
		}
	}
	if((!Me.IsShowWindow() && GetGameStateName() != "SPECIALCAMERASTATE") && GetGameStateName() != "COLLECTIONSTATE")
	{
		Me.ShowWindow();
		Me.BringToFront();
		SetExpandMode(m_bExpand, false);
	}
	if(ContextMenu(GetScript("ContextMenu")).getContextEventInfo().Id > 0)
	{
		ContextMenu(GetScript("ContextMenu")).makeContextMenu();
		ContextMenu(GetScript("ContextMenu")).clearInfo();
	}
	if(bShowHPBar && GetGameStateName() != "SPECIALCAMERASTATE")
	{
		barHP.ShowWindow();
	}
	else
	{
		barHP.HideWindow();
	}
	if(bShowMPBar && GetGameStateName() != "SPECIALCAMERASTATE")
	{
		barMP.ShowWindow();
	}
	else
	{
		barMP.HideWindow();
	}
	if(Info.nClanID < 0)
	{
		bShowPledgeInfo = false;
	}

	if(bShowPledgeInfo)
	{
		if(!WantHideName && GetGameStateName() != "SPECIALCAMERASTATE")
		{
			txtPledge.ShowWindow();
			txtAlliance.ShowWindow();
			txtPledgeName.ShowWindow();
			txtPledgeAllianceName.ShowWindow();
			txtPledgeName.SetText(PledgeName);
			txtPledgeAllianceName.SetText(PledgeAllianceName);
			txtPledgeName.SetTextColor(PledgeNameColor);
			txtPledgeAllianceName.SetTextColor(PledgeAllianceNameColor);
			textRect = txtPledge.GetRect();

			if(bShowPledgeTex)
			{
				texPledgeCrest.ShowWindow();

				if(getInstanceUIData().getIsLiveServer())
				{
					texPledgeCrest.MoveTo(textRect.nX + textRect.nWidth + 3, rectWnd.nY + 52 + 1);
				}
				else
				{
					texPledgeCrest.MoveTo(textRect.nX + textRect.nWidth + 4, textRect.nY + 1);
				}

				// 18????, ?????????????? 16 * 12,  2?????? ??¤µ?? °??°?????? ????Ш??? 18.
				if(getInstanceUIData().getIsLiveServer())
				{
					txtPledgeName.MoveTo(textRect.nX + textRect.nWidth + 20, rectWnd.nY + 52);
				}
				else
				{
					txtPledgeName.MoveTo(textRect.nX + textRect.nWidth + 33, textRect.nY);
				}
			}
			else
			{
				texPledgeCrest.HideWindow();
				if(getInstanceUIData().getIsLiveServer())
				{
					txtPledgeName.MoveTo(textRect.nX + textRect.nWidth + 2, rectWnd.nY + 52);
				}
				else
				{
					txtPledgeName.MoveTo(textRect.nX + textRect.nWidth + 6, textRect.nY);
				}
			}

			// txtAlliance ???? µ????? ??Ш?????, ¶???§?лµ??
			textRect = txtAlliance.GetRect();

			// µ?????, µ?????????????, µ???????
			if(bShowPledgeAllianceTex)
			{
				texPledgeAllianceCrest.ShowWindow();

				if(getInstanceUIData().getIsLiveServer())
				{
					texPledgeAllianceCrest.MoveTo(textRect.nX + textRect.nWidth + 3, rectWnd.nY + 67);

					// 10????, µ????????????? 8 * 12,  2?????? ??¤µ?? °??°?????? ????Ш??? 10.
					txtPledgeAllianceName.MoveTo(textRect.nX + textRect.nWidth + 12, rectWnd.nY + 67);
				}
				else
				{
					txtPledgeAllianceName.MoveTo(textRect.nX + textRect.nWidth + 10, rectWnd.nY + 72);
				}
			}
			else
			{
				texPledgeAllianceCrest.HideWindow();
				if(getInstanceUIData().getIsLiveServer())
				{
					txtPledgeAllianceName.MoveTo(textRect.nX + textRect.nWidth + 2, rectWnd.nY + 67);
				}
				else
				{
					txtPledgeAllianceName.MoveTo(textRect.nX + textRect.nWidth + 6, textRect.nY);
				}
			}
		}
		else
		{
			txtPledge.HideWindow();
			txtAlliance.HideWindow();
			txtGearScore.HideWindow();
			txtGearScorePoints.HideWindow();
			txtPledgeName.HideWindow();
			txtPledgeAllianceName.HideWindow();
			texPledgeCrest.HideWindow();
			texPledgeAllianceCrest.HideWindow();
		}
	}
	else
	{
		txtPledge.HideWindow();
		txtAlliance.HideWindow();
		txtGearScore.HideWindow();
		txtGearScorePoints.HideWindow();
		txtPledgeName.HideWindow();
		txtPledgeAllianceName.HideWindow();
		texPledgeCrest.HideWindow();
		texPledgeAllianceCrest.HideWindow();
	}
	if(bShowNpcInfo && GetGameStateName() != "SPECIALCAMERASTATE")
	{
		ToggleGearScore(false);
		NpcInfo.ShowWindow();
		NpcInfo.ShowScrollBar(false);
	}
	else
	{
		ToggleGearScore(m_bExpand);
		NpcInfo.HideWindow();
	}
	RepositionNamePosition();
}

function HandleUpdateWarMark(string param)
{
	local int TargetWarMark;
	local string warMarkTextureName;

	if(class'UIDATA_PLAYER'.static.IsInDethrone())
	{
		return;
	}
	ParseInt(param, "TargetWarMark", TargetWarMark);
	warMarkTextureName = GetWarMarkTargetTextureByWarMarkType(WARMARKTYPE(TargetWarMark));

	if(warMarkTextureName == "")
	{
		SiegeMark.HideWindow();
	}
	else
	{
		SiegeMark.SetTexture(warMarkTextureName);
		SiegeMark.ShowWindow();
	}

	RepositionNamePosition();
}

function HandleUpdateTargetDead(string param)
{
	local int TargetDead, targetID;

	ParseInt(param, "TargetDead", TargetDead);
	ParseInt(param, "TargetID", targetID);

	if(getInstanceUIData().getIsLiveServer())
	{
		switch(TargetDead)
		{
			case 0:
				DeathTexture.HideWindow();
				break;
			case 1:
				DeathTexture.ShowWindow();
				break;
		}
	}
}

function RepositionNamePosition()
{
	local int sizeRe, anchorX;

	sizeRe = -33;
	anchorX = 18;

	if(texMark.IsShowWindow() && SiegeMark.IsShowWindow())
	{
		sizeRe = -80;
		anchorX = 62;

		if(getInstanceUIData().getIsClassicServer())
		{
			SiegeMark.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 52, 5);
		}
		else
		{
			SiegeMark.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 44, 5);
		}
	}
	else if(texMark.IsShowWindow())
	{
		sizeRe = -54;
		anchorX = 36;
	}
	else
	{
		if(SiegeMark.IsShowWindow())
		{
			sizeRe = -54;
			anchorX = 36;

			if(getInstanceUIData().getIsClassicServer())
			{
				SiegeMark.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 29, 5);
			}
			else
			{
				SiegeMark.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 21, 5);
			}
		}
	}

	if(getInstanceUIData().getIsClassicServer())
	{
		UserName.SetWindowSizeRel(1.0, 0.0, -73, 14);
		UserName.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 30, 8);
	}
	else
	{
		UserName.SetWindowSizeRel(1.0, 0.0, sizeRe, 14);
		UserName.SetAnchor(m_WindowName, "TopLeft", "TopLeft", anchorX, 8);
	}
}

//Expand»??????? µ????? ??©·?°???? ??????

// ???°Щ°???? ·??????? ???????? µ????? »??»?? °?? ????о??±??
function Color GetTargetNameColor(int TargetLevelDiff)
{
	local Color OutColor;

	OutColor.A = 255;

	if(getInstanceUIData().getIsClassicServer())
	{
		if(TargetLevelDiff <= -15)
		{
			OutColor.R = 255;
			OutColor.G = 0;
			OutColor.B = 0;
		}
		else if(TargetLevelDiff > -15 && TargetLevelDiff <= -10)
		{
			OutColor.R = 255;
			OutColor.G = 145;
			OutColor.B = 145;				
		}
		else if(TargetLevelDiff > -10 && TargetLevelDiff <= -5)
		{
			OutColor.R = 250;
			OutColor.G = 254;
			OutColor.B = 145;
		}
		else if(TargetLevelDiff > -5 && TargetLevelDiff <= 14)
		{
			OutColor.R = 230;
			OutColor.G = 230;
			OutColor.B = 230;
		}
		else if(TargetLevelDiff > 14)
		{
			OutColor.R = 30;
			OutColor.G = 100;
			OutColor.B = 200;
		}
	}
	else if(TargetLevelDiff <= -11)
	{
		OutColor.R = 255;
		OutColor.G = 0;
		OutColor.B = 0;
	}
	else if((TargetLevelDiff > -11) && TargetLevelDiff <= -6)
	{
		OutColor.R = 255;
		OutColor.G = 145;
		OutColor.B = 145;
	}
	else if((TargetLevelDiff > -6) && TargetLevelDiff <= -3)
	{
		OutColor.R = 250;
		OutColor.G = 254;
		OutColor.B = 145;
	}
	else if((TargetLevelDiff > -3) && TargetLevelDiff <= 2)
	{
		OutColor.R = 230;
		OutColor.G = 230;
		OutColor.B = 230;
	}
	else if(TargetLevelDiff > 2 && TargetLevelDiff <= 5)
	{
		OutColor.R = 162;
		OutColor.G = 255;
		OutColor.B = 171;
	}
	else if(TargetLevelDiff > 5 && TargetLevelDiff <= 10)
	{
		OutColor.R = 162;
		OutColor.G = 168;
		OutColor.B = 252;
	}
	else if(TargetLevelDiff > 10)
	{
		OutColor.R = 30;
		OutColor.G = 100;
		OutColor.B = 200;
	}
	return OutColor;
}

function SetExpandMode(bool bExpand, bool bUseTargetUpdate)
{
	local int nWndWidth, nWndHeight;	// ??©µµ??? »з?????? ???Ю±в ??????

	Me.GetWindowSize(nWndWidth, nWndHeight);

	m_bExpand = bExpand;

	if (!m_bExpand)
	{
		if (txtGearScore.IsShowWindow())
		{
			txtGearScore.HideWindow();
		}

		if (txtGearScorePoints.IsShowWindow())
		{
			txtGearScorePoints.HideWindow();
		}
	}

	// TargetStatusWnd.uc???? ????·?? ???«???? ???Э???? ????вµ???? ??Ф??? ·????? ??????
	// Game Bug #1935 http://wallis-devsub/redmine/issues/1935
	if(bUseTargetUpdate)
	{
		m_targetID = -1;
		HandleTargetUpdate(true);
	}
	if(bExpand)
	{
		btnExpand.ShowWindow();
		btnContract.HideWindow();

		if(getInstanceUIData().getIsLiveServer())
		{
			Me.SetWindowSize(nWndWidth, EXPAND_CLASSIC_HEIGHT); // TODO: (sharp) This was changed from EXPAND_HEIGHT to EXPAND_CLASSIC_HEIGHT to fit GearScorePoints
		}
		else
		{
			Me.SetWindowSize(nWndWidth, EXPAND_CLASSIC_HEIGHT);
		}

		barSkillProgressEff1_Center.SetWindowSizeRel(1, 0.40, -35, 0);
		barSkillProgressEff2_Center.SetWindowSizeRel(1, 0.40, -35, 0);
	}
	else
	{
		btnExpand.HideWindow();
		btnContract.ShowWindow();

		if(getInstanceUIData().getIsLiveServer())
		{
			Me.SetWindowSize(nWndWidth, CONTRACT_HEIGHT);
		}
		else
		{
			Me.SetWindowSize(nWndWidth,CONTRACT_CLASSIC_HEIGHT);
		}

		barSkillProgressEff1_Center.SetWindowSizeRel(1, 0.70, -35, 0);
		barSkillProgressEff2_Center.SetWindowSizeRel(1, 0.70, -35, 0);
	}
	SetINIInt(m_WindowName, "e", boolToNum(bExpand), "WindowsInfo.ini");
}

//HP???Щ °»????
function UpdateHPBar(int HP, int MaxHP)
{
	//branch gd35_0828
	// ??л??? ?????? ??Ц????? - gorillazin 13.10.15.
	if(MaxHP > 0)
	{
		barHP.SetPoint(HP, MaxHP);
	}
	else
	{
		barHP.HideWindow();
	}
	//end of branch
}

//MP???Щ °»????
function UpdateMPBar(int MP, int MaxMP)
{
	//branch gd35_0828
	// ??л??? ?????? ??Ц????? - gorillazin 13.10.15.
	if(MaxMP > 0)
	{
		barMP.SetPoint(MP, MaxMP);
	}
	else
	{
		barMP.HideWindow();
	}
	//end of branch
}

//??????????????·С???? Npc???????????? ????°??
function UpdateNpcInfoTree(array<int> arrNpcInfo)
{
	local int i;
	local int SkillID;
	local int SkillLevel;
	local int CharInfoNumMaxOneLine;

	local string				strNodeName;
	local XMLTreeNodeInfo		infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo		infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;

	CharInfoNumMaxOneLine = 10;

	//???±в???
	NpcInfo.Clear();

	txtGearScore.HideWindow();
	txtGearScorePoints.HideWindow();

	//·з???? ????°??
	infNode.strName = "root";
	strNodeName = NpcInfo.InsertNode("", infNode);

	if(Len(strNodeName) < 1)
	{
		//~ debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}

	for(i=0; i<arrNpcInfo.Length; i+=2)
	{
		SkillID = arrNpcInfo[i];
		SkillLevel = arrNpcInfo[i+1];

		//////////////////////////////////////////////////////////////////////////////////////////////////////
		//Insert Node
		infNode = infNodeClear;
		infNode.nOffSetX = ((i/2) % CharInfoNumMaxOneLine) * 18;

		if((i/2) % CharInfoNumMaxOneLine == 0)
		{
			if(i > 0)
			{
				infNode.nOffSetY = 3;
			}
			else
			{
				infNode.nOffSetY = 0;
			}
		}
		else
		{
			infNode.nOffSetY = -15;
		}

		infNode.strName = "" $ i/2;
		infNode.bShowButton = 0;
		//Tooltip
		infNode.ToolTip = SetNpcInfoTooltip(SkillID, SkillLevel);
		strNodeName = NpcInfo.InsertNode("root", infNode);

		if(Len(strNodeName) < 1)
		{
			Log("ERROR: Can't insert node. Name: " $ infNode.strName);
			return;
		}
		//Node Tooltip Clear
		infNode.ToolTip.DrawList.Remove(0, infNode.ToolTip.DrawList.Length);

		//////////////////////////////////////////////////////////////////////////////////////////////////////
		//Insert NodeItem
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.u_nTextureWidth = 15;
		infNodeItem.u_nTextureHeight = 15;
		infNodeItem.u_nTextureUWidth = 32;
		infNodeItem.u_nTextureUHeight = 32;
		// !???®???? ??Ц????? ????????
		infNodeItem.u_strTexture = class'UIDATA_SKILL'.static.GetIconName(GetItemID(SkillID), SkillLevel, 0);
		NpcInfo.InsertNodeItem(strNodeName, infNodeItem);
	}
}

function CustomTooltip SetNpcInfoTooltip(int ID, int Level)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info;
	local DrawItemInfo infoClear;
	local ItemInfo Item;
	local ItemID cID;

	cID = GetItemID(ID);

	Item.Name = class'UIDATA_SKILL'.static.GetName(cID, Level, 0);
	Item.Description = class'UIDATA_SKILL'.static.GetDescription(cID, Level, 0);

	ToolTip.DrawList.Length = 1;

	//??????
	Info = infoClear;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	Info.t_strText = Item.Name;
	ToolTip.DrawList[0] = Info;

	//??????
	if(Len(Item.Description) > 0)
	{
		ToolTip.MinimumWidth = 144;
		ToolTip.DrawList.Length = 2;
		Info = infoClear;
		Info.eType = DIT_TEXT;
		Info.nOffSetY = 6;
		Info.bLineBreak = true;
		Info.t_color.R = 178;
		Info.t_color.G = 190;
		Info.t_color.B = 207;
		Info.t_color.A = 255;
		Info.t_strText = Item.Description;
		ToolTip.DrawList[1] = Info;
	}
	return ToolTip;
}

//??Ч»?? ???»???·?? ???????? ???? ?????????? ????©????? ??Ф???
function bool IsAllWhiteID(int m_targetID)
{
	local bool bIsAllWhiteName;

	bIsAllWhiteName = false;

	switch(m_targetID)
	{
		case 12775:	//???Ъ
		case 12776:
		case 12778:
		case 12779:
		case 13016:
		case 13017:
		case 13031:
		case 13032:
		case 13033:
		case 13034:
		case 13035:
		case 13036:
		case 13098:
		case 13120:
		case 13121:
		case 13122:
		case 13123:
		case 13124:
		case 13271:
		case 13272:
		case 13273:
		case 13274:
		case 13275:
		case 13276:
		case 13277:
		case 13278:
		case 13187:
		case 13188:
		case 13189:
		case 13190:
		case 13191:
		case 13192:
		case 13286:
		case 13287:
		case 13288:
		case 13289:
		case 13290:
		case 13291:
		case 13292:
		case 13342:
		case 13343:
		case 13344:
		case 13345:
		case 13346:
		case 13347:
		case 13348:
		case 13349:
		case 13400:
		case 13401:
		case 13402:
		case 13404:
		case 13405:
		case 13406:
		case 26089:
		case 13419:
		case 13420:
		case 13421:
		case 13422:
		case 26091:
		case 26248:
		case 13551:
		case 13552:
		case 34499:
		case 24330:
		case 24332:
		case 24331:
		case 24333:
		case 24366:
		case 24367:
		case 24368:
		case 24369:
		case 24370:
		case 24371:
		case 18371:
		case 18372:
		case 18389:
		case 18407:
		case 18394:
		case 18395:
		case 18396:
		case 18397:
		case 34168:
		case 34170:
		case 34167:
		case 18458:
		case 18459:
		case 34143:
		case 34144:
		case 34145:
		case 18440:
		case 18441:
		case 26458:
		case 13608:
		case 13609:
		case 13610:
		case 18583:
		case 18584:
		case 18585:
		case 18586:
		case 18587:
		case 18588:
		case 18589:
		case 18590:
		case 18591:
		case 18592:
		case 18593:
		case 18594:
		case 18595:
		case 18598:
		case 18599:
		case 18600:
		case 18601:
		case 18602:
		case 29398:
			bIsAllWhiteName = true;
			break;
	}
	if(GetServerType() == 1)// live
	{
		switch(m_targetID)
		{
			case 8696:
			case 8697:
			case 8699:
			case 8700:
			case 8701:
			case 8702:
				bIsAllWhiteName = true;
				break;
		}
	}
	else if(GetServerType() == 2)//classic
	{
		switch(m_targetID)
		{
			case 9051:
			case 9052:
			case 9054:
			case 9055:
			case 9056:
			case 9057:
				bIsAllWhiteName = true;
				break;
		}
	}

	return bIsAllWhiteName;
}

//HP ???Щµµ ?????????? ???µ???? ???????????? ????©????? ??Ф???
function bool IsNoBarID(int m_targetID)
{
	local bool bIsNoBarName;

	bIsNoBarName = false;

	switch(m_targetID)
	{
		case 13036:	//????±Э???»з??? ?????°»?????
		case 13098:	//?????°???±?? ?????°»?????
			bIsNoBarName = true;
			break;
	}
	return bIsNoBarName;
}

//???°?? ???????? »?????
function HandleTargetSpelledList(string param)
{
	local int i;
	local int Max;
	local int b;
	local int TargetID;

	local StatusIconInfo Info;

	ClearAll();

	ParseInt(param, "ID", TargetID);
	ParseInt(param, "Max", Max);

	//Debug(">>>>>>>"$string(TargetID)$string(StatusIcons)$string(Max));
	
	for(i = 0 ; i < Max ; i++)
	{
		//Skill ClassID
		ParseInt(param, "ClassID_" $ i, Info.ID.ClassID);
		ParseInt(param, "Level_" $ i, Info.Level);
		ParseInt(param, "SubLevel_" $ i, Info.SubLevel);

		if(IsIconHide(Info.Id, Info.Level, Info.SubLevel))
		{
			continue;
		}

		// ??д??? ?????????? °ж???? add ?????? ??????.
		if(class'UIDATA_SKILL'.static.IsToppingSkill(Info.ID, Info.Level, Info.SubLevel))
		{
			continue;
		}

		ParseInt(param, "Sec_" $ i, Info.RemainTime);
		ParseInt(param, "OwnerShip_" $ i, b);

		Info.Name = class'UIDATA_SKILL'.static.GetName(Info.ID, Info.Level, Info.SubLevel);
		Info.IconName = class'UIDATA_SKILL'.static.GetIconName(Info.ID, Info.Level, Info.SubLevel);
		Info.Description = class'UIDATA_SKILL'.static.GetDescription(Info.ID, Info.Level, Info.SubLevel);
		Info.IconPanel = class'UIDATA_SKILL'.static.GetIconPanel(Info.ID, Info.Level, Info.SubLevel);

		if(b == 0)
		{
			Info.bOwnerShip = false;
		}
		else
		{
			Info.bOwnerShip = true;
		}

		Info = SelectTexture(Info);
	}

	MyBuffDraw();
	OtherBuffDraw();
	MyDebuffDraw();
	OtherDebuffDraw();
	moveBuffWndMoreView2();
}

//?????????? ¶????? ????°???????»?? 1??????°·?? ±Ч·?????.(1???????? ¶?????, ??Ъ????? ????????)
function MyBuffDraw()
{
	local int i;
	local int length;
	local array<StatusIconInfo> temp;
	local TargetStatusBuff1Wnd script;

	script = TargetStatusBuff1Wnd(GetScript("TargetStatusBuff1Wnd"));
	script.ResetBuffIcon();

	length = arrMyBuff.Length;

	if(length > 0 && length < 9)
	{
		//????°?? ?????????? ??л??? ???????? »з¶?????.
		showBuffMoreBtn(false, 1);

		StatusIcons.AddRow();

		for(i = 0 ; i < length ; i++)
		{
			StatusIcons.AddCol(lineCount, arrMyBuff[i]);
		}

		lineCount++;
	}
	else if(length >= 9)
	{
		//????°?? ?????????? ??л??? ???????? ????????.
		showBuffMoreBtn(true, 1);

		StatusIcons.AddRow();

		for(i = 0 ; i < length ; i++)
		{
			if(i > length - 9)
			{
				StatusIcons.AddCol(lineCount, arrMyBuff[i]);
			}
			else
			{
				temp.Insert(temp.Length, 1);
				temp[temp.Length - 1] = arrMyBuff[i];
			}
		}
		script.showBuff(temp);
		lineCount++;
	}
}

//?????????? ¶????? ????°???????»?? 2??????°·?? ±Ч·?????.(2???????? ¶?????, ???????? ????????)
function OtherBuffDraw()
{
	local int i;

	if(arrOtherBuff.Length > 0)
	{
		StatusIcons.AddRow();

		for(i = 0; i < arrOtherBuff.Length; i++)
		{
			if(i > arrOtherBuff.Length - 13)
			{
				arrOtherBuff[i].bHideRemainTime = true;
				StatusIcons.AddCol(lineCount, arrOtherBuff[i]);
			}
			//debug(string(i)$">>>"$string(arrOtherBuff[i].Level)$"__"$string(arrOtherBuff[i].RemainTime)$"__"$arrOtherBuff[i].Name$"__"$arrOtherBuff[i].IconName$"__"$arrOtherBuff[i].Description$"__ i="$string(i)); 
		}
		lineCount++;
	}
}

//?????????? ¶????? ????°???????»?? 3??????°·?? ±Ч·?????.(3???????? ¶?????, ??Ъ????? µ??????????)
function MyDebuffDraw()
{
	local int i;
	local int length;
	local array<StatusIconInfo> temp;
	local TargetStatusBuff2Wnd script;

	script = TargetStatusBuff2Wnd(GetScript("TargetStatusBuff2Wnd"));
	script.ResetBuffIcon();

	length = arrMyDebuff.Length;

	if(length > 0 && length < 9)
	{
		//????°?? ?????????? ??л??? ???????? »з¶?????.
		showBuffMoreBtn(false, 2);

		StatusIcons.AddRow();

		for(i = 0; i < length; i++)
		{
			StatusIcons.AddCol(lineCount, arrMyDebuff[i]);
			//test??Ъµ??..
			//temp.Insert(temp.Length, 1);
			//temp[temp.Length -1 ] = arrMyDebuff[i];
			//debug(string(i)$">>>"$string(arrMyDebuff[i].Level)$"__"$string(arrMyDebuff[i].RemainTime)$"__"$arrMyDebuff[i].Name$"__"$arrMyDebuff[i].IconName$"__"$arrMyDebuff[i].Description$"__ i="$string(i)); 
		}

		//test??Ъµ??..
		//script.showBuff(temp);

		lineCount++;
	}
	else if(length >= 9)
	{
		//????°?? ?????????? ??л??? ???????? ????????.
		showBuffMoreBtn(true, 2);

		StatusIcons.AddRow();

		for(i = 0; i < length; i++)
		{
			if(i > length - 9)
			{
				StatusIcons.AddCol(lineCount, arrMyDebuff[i]);
					continue;
			}

			temp.Insert(temp.Length, 1);
			temp[temp.Length - 1] = arrMyDebuff[i];
		}
		script.showBuff(temp);
		lineCount++;
	}
}

//?????????? ¶????? ????°???????»?? 4??????°·?? ±Ч·?????.(4???????? ¶?????, ???????? µ??????????)
function OtherDebuffDraw()
{
	local int i;
	local int num;

	num = 0;

	if(arrOtherDebuff.Length > 0)
	{
		StatusIcons.AddRow();

		for(i = 0; i < arrOtherDebuff.Length; i++)
		{
			if(i > arrOtherDebuff.Length - 25)
			{
				if(num == 12)
				{
					StatusIcons.AddRow();
					lineCount++;
				}
				num++;
				arrOtherDebuff[i].bHideRemainTime = true;
				StatusIcons.AddCol(lineCount, arrOtherDebuff[i]);
			}
			//debug(string(i)$">>>"$string(arrOtherDebuff[i].Level)$"__"$string(arrOtherDebuff[i].RemainTime)$"__"$arrOtherDebuff[i].Name$"__"$arrOtherDebuff[i].IconName$"__"$arrOtherDebuff[i].Description$"__ i="$string(i)); 
		}
		lineCount++;
	}
}

//???????? °??·?? ???±в???
function ClearAll()
{
	lineCount = 0;

	showBuffMoreBtn(false, 1);
	showBuffMoreBtn(false, 2);

	ResetArray();
	ResetBuffIcon();
}

//???и???? ???±в???
function ResetArray()
{
	arrMyBuff.Remove(0, arrMyBuff.Length);
	arrOtherBuff.Remove(0, arrOtherBuff.Length);
	arrMyDebuff.Remove(0, arrMyDebuff.Length);
	arrOtherDebuff.Remove(0, arrOtherDebuff.Length);
}

//???????? ???????? All Clear
function ResetBuffIcon()
{
	StatusIcons.Clear();
}

//StatusIconInfo Setting(??©±??, Back ??Ш????? ??±???, ???и???????? insert)
function StatusIconInfo SelectTexture(StatusIconInfo Info)
{
	//???????? ????©???.
	Info.bShow = true;

	//µ???????????? ??л??? StatusIconInfo??¤??? ??Ф·??
	if(GetDebuffType(Info.ID, Info.Level, Info.SubLevel) != 0)
	{
		//??Ъ????? µ?????????? ???¶??.
		if(Info.bOwnerShip)
		{
			Info.Size = BUFF_SIZE_BIG;
			Info.BackTex = "L2UI_CT1.Buff.DeBuffFrame_24";
			arrMyDebuff.Insert(arrMyDebuff.Length, 1);
			arrMyDebuff[arrMyDebuff.Length - 1] = Info;
		}
		//???????? µ?????????? ???¶??.
		else
		{
			Info.Size = BUFF_SIZE_SMALL;
			Info.BackTex = "L2UI_CT1.Buff.DeBuffFrame_16";
			arrOtherDebuff.Insert(arrOtherDebuff.Length, 1);
			arrOtherDebuff[arrOtherDebuff.Length - 1] = Info;
		}
	}
	//???Яµ?? ???????? ??л??? StatusIconInfo??¤??? ??Ф·??
	else if(GetIndexByIsMagic(Info) == 5)
	{
		//??Ъ????? ???Яµ?? ?????? ???¶??.
		if(Info.bOwnerShip)
		{
			Info.Size = BUFF_SIZE_BIG;
			Info.BackTex = "L2UI_CT1.Buff.BuffFrame_24_3";
			arrMyBuff.Insert(arrMyBuff.Length, 1);
			arrMyBuff[arrMyBuff.Length - 1] = Info;
		}
		//???????? ???Яµ?? ?????? ???¶??.
		else
		{
			Info.Size = BUFF_SIZE_SMALL;
			Info.BackTex = "L2UI_CT1.Buff.BuffFrame_16_3";
			arrOtherBuff.Insert(arrOtherBuff.Length, 1);
			arrOtherBuff[arrOtherBuff.Length - 1] = Info;
		}
	}
	//??Ы?н??? ???????? ??л??? StatusIconInfo??¤??? ??Ф·??
	else if(GetIndexByIsMagic(Info) == 3)
	{
		//??Ъ????? ??Ы?н??? ?????? ???¶??.
		if(Info.bOwnerShip)
		{
			Info.Size = BUFF_SIZE_BIG;
			Info.BackTex = "L2UI_CT1.Buff.BuffFrame_24_2";
			arrMyBuff.Insert(arrMyBuff.Length, 1);
			arrMyBuff[arrMyBuff.Length - 1] = Info;
		}
		//???????? ??Ы?н??? ?????? ???¶??.
		else
		{
			Info.Size = BUFF_SIZE_SMALL;
			Info.BackTex = "L2UI_CT1.Buff.BuffFrame_16_2";
			arrOtherBuff.Insert(arrOtherBuff.Length, 1);
			arrOtherBuff[arrOtherBuff.Length - 1] = Info;
		}
	}
	//?????????? ??л??? StatusIconInfo??¤??? ??Ф·??
	else
	{
		//??Ъ????? ???????? ???¶??.
		if(Info.bOwnerShip)
		{
			Info.Size = BUFF_SIZE_BIG;
			Info.BackTex = "L2UI_CT1.Buff.BuffFrame_24_1";
			arrMyBuff.Insert(arrMyBuff.Length, 1);
			arrMyBuff[arrMyBuff.Length - 1] = Info;
		}
		//???????? ???????? ???¶??.
		else
		{
			Info.Size = BUFF_SIZE_SMALL;
			Info.BackTex = "L2UI_CT1.Buff.BuffFrame_16_1";
			arrOtherBuff.Insert(arrOtherBuff.Length, 1);
			arrOtherBuff[arrOtherBuff.Length - 1] = Info;
		}
	}

	return Info;
}

//????°?? ?????????? ??л??? ??????°??? show/hide
function showBuffMoreBtn(bool b, int n)
{
	if(b == true)
	{
		GetButtonHandle(m_WindowName $ ".BuffWnd.btnBuffMoreView" $ n).ShowWindow();
	}
	else
	{
		GetButtonHandle(m_WindowName $ ".BuffWnd.btnBuffMoreView" $ n).HideWindow();
	}
}

//????°?? µ?????????? ?????????? µ????? ??§??? ???µ??
function moveBuffWndMoreView2()
{
	if(arrMyBuff.Length > 0)
	{
		yPosView2 = 26;
	}
	else
	{
		yPosView2 = 0;
	}

	if(arrOtherBuff.Length > 0)
	{
		yPosView2 = yPosView2 + 18;
	}
	btnBuffMoreView2.MoveTo(BuffWnd.GetRect().nX, BuffWnd.GetRect().nY + yPosView2);
}

//????°?? ?????????? ??л??? ??????°??? ??¶?м??? ?????????? ???? ????????.
event OnMouseOver(WindowHandle w)
{
	if(btnBuffMoreView1 == w)
	{
		TargetStatusBuff1Wnd.ShowWindow();
	}
	else if(btnBuffMoreView2 == w)
	{
		TargetStatusBuff2Wnd.ShowWindow();
	}
}

//????°?? ?????????? ??л??? ??????°??? ??¶?м??? ???????? ???? »з¶?????.
event OnMouseOut(WindowHandle w)
{
	if(btnBuffMoreView1 == w)
	{
		TargetStatusBuff1Wnd.HideWindow();
	}
	else if(btnBuffMoreView2 == w)
	{
		TargetStatusBuff2Wnd.HideWindow();
	}
}

//???°?? ?????? ?????? EV ???Ю????
function HandleTargetSkillInfo(string param)
{
	local int bIsHostile;
	local int bUseSlot1;
	local float fTotalTimeSlot1;
	local float fElapsedTimeSlot1;
	local string SkillNameSlot1;
	local int Resistcast1;

	local int bUseSlot2;
	local float fTotalTimeSlot2;
	local float fElapsedTimeSlot2;
	local string SkillNameSlot2;
	local int Resistcast2;

	local Color White;
	local Color Red;

	Red.R = 255;
	Red.G = 0;
	Red.B = 0;
	Red.A = 255;

	White.R = 230;
	White.G = 230;
	White.B = 230;
	White.A = 255;

	// ????л???, ??м??????? ??л??? ±?????
	ParseInt(param, "bIsHostile", bIsHostile);

	if(bIsHostile == 0)
	{
		strSelectTarget = "Friendly";
	}
	else
	{
		strSelectTarget = "Enemy";
	}

	ParseInt(param, "bUseSlot1", bUseSlot1);
	ParseFloat(param, "fTotalTimeSlot1", fTotalTimeSlot1);
	ParseFloat(param, "fElapsedTimeSlot1", fElapsedTimeSlot1);
	ParseString(param, "SkillNameSlot1", SkillNameSlot1);
	ParseInt(param, "ResistCast1", ResistCast1);

	ParseInt(param, "bUseSlot2", bUseSlot2);
	ParseFloat(param, "fTotalTimeSlot2", fTotalTimeSlot2);
	ParseFloat(param, "fElapsedTimeSlot2", fElapsedTimeSlot2);
	ParseString(param, "SkillNameSlot2", SkillNameSlot2);
	ParseInt(param, "ResistCast2", ResistCast2);

	//Debug(string(GetOptionBool("ScreenInfo", "SkillCastingBox")));

	if(GetOptionBool("ScreenInfo", "SkillCastingBox") == false)
	{
		return;
	}
	if(bUseSlot1 != 0)
	{
		//???°???? ??¶??????? ???? °ж???? ??¦???
		if(fTotalTimeSlot1 > 0)
		{
			Me.KillTimer(TimerValue7);
			Me.KillTimer(TimerValue9); //??????У??? ??Ч????? ????????, HandleSkillCancel ???????? ??µ??????? 1???? µЪ ????µз °????? ???±в??? ????°????·?? 
			SetTextureBar("Progress", 1);
			SetEffectTexture("Progress", 1);
			showSkillSlot(fTotalTimeSlot1, fElapsedTimeSlot1, 1);
			//??л??? ??Т??? ?????? ?????? »??°?»???·??.
			if(ResistCast1 == 1)
			{
				skillProgressName1.SetNameWithColor(SkillNameSlot1, NCT_Normal, TA_Center, Red);
			}
			else
			{
				skillProgressName1.SetNameWithColor(SkillNameSlot1, NCT_Normal, TA_Center, White);
			}
		}
	}
	else
	{
		skillBarVisible(false, 1);
		barSkillProgress1.Reset();
	}

	if(bUseSlot2 != 0)
	{
		//???°???? ??¶??????? ???? °ж???? ??¦???
		if(fTotalTimeSlot1 > 0)
		{
			Me.KillTimer(TimerValue8);
			Me.KillTimer(TimerValue9); //??????У??? ??Ч????? ????????, HandleSkillCancel ???????? ??µ??????? 1???? µЪ ????µз °????? ???±в??? ????°????·?? 
			SetTextureBar("Progress", 2);
			SetEffectTexture("Progress", 2);
			showSkillSlot(fTotalTimeSlot2, fElapsedTimeSlot2, 2);
			//??л??? ??Т??? ?????? ?????? »??°?»???·??.
			if(ResistCast2 == 1)
			{
				skillProgressName2.SetNameWithColor(SkillNameSlot2, NCT_Normal, TA_Center, Red);
			}
			else
			{
				skillProgressName2.SetNameWithColor(SkillNameSlot2, NCT_Normal, TA_Center, White);
			}
		}
	}
	else
	{
		skillBarVisible(false, 2);
		barSkillProgress2.Reset();
	}
	//Debug(string(bIsHostile)$"&&"$string(fTotalTimeSlot1)$"&&"$string(fElapsedTimeSlot1));
}

//???·Ф??? ?????? ??????.
function showSkillSlot(float total, float elapsed, int slot)
{
	skillBarVisible(true, slot);

	GetProgressCtrlHandle(m_WindowName $".SkillProgressWnd" $ slot $ "." $ "barSkillProgress"$slot).Stop();
	GetProgressCtrlHandle(m_WindowName $".SkillProgressWnd" $ slot $ "." $ "barSkillProgress"$slot).Reset();
	GetProgressCtrlHandle(m_WindowName $".SkillProgressWnd" $ slot $ "." $ "barSkillProgress"$slot).SetProgressTime(int(total));
	GetProgressCtrlHandle(m_WindowName $".SkillProgressWnd" $ slot $ "." $ "barSkillProgress"$slot).SetPos(int(total - elapsed));
	GetProgressCtrlHandle(m_WindowName $".SkillProgressWnd" $ slot $ "." $ "barSkillProgress"$slot).Start();	
}

function OnProgressTimeUp(string strID)
{
	if(strID == "barSkillProgress1")
	{
		SetTextureBar("Success", 1);
		SetEffectTexture("Success", 1);
		Me.SetTimer(TimerValue7, 1000);
	}
	else if(strID == "barSkillProgress2")
	{
		SetTextureBar("Success", 2);
		SetEffectTexture("Success", 2);
		Me.SetTimer(TimerValue8, 1000);
	}
}

/** ??????????????л?Тµ?°ж???*/
function HandleSkillCancel()
{
	SetTextureBar("Failed", 1);
	SetEffectTexture("Failed", 1);
	barSkillProgress1.Stop();
	SetTextureBar("Failed", 2);
	SetEffectTexture("Failed", 2);
	barSkillProgress2.Stop();
	Me.SetTimer(TimerValue9, 1000);
}

/** ?????????°?·??д?Т?¦????°н??????µµ·?????? */
function skillBarVisible(bool flag, int slot)
{
	//Debug("skillBarVisible" @ flag @ slot);
	if(flag == true)
	{
		GetNameCtrlHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $ "skillProgressName" $ slot).ShowWindow();
		GetProgressCtrlHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $ "barSkillProgress" $ slot).ShowWindow();
		GetTextureHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $ "barSkillProgressEff" $ slot $ "_Left").ShowWindow();
		GetTextureHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $ "barSkillProgressEff" $ slot $ "_Center").ShowWindow();
		GetTextureHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $ "barSkillProgressEff" $ slot $ "_Right").ShowWindow();
	}
	else
	{
		if(slot == 1)
		{
			barSkillProgress1.Reset();
		}
		else
		{
			barSkillProgress2.Reset();
			//HideWindow(m_WindowName $ ".SkillProgressWnd2");	
		}

		GetNameCtrlHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $ "skillProgressName" $ slot).HideWindow();
		GetProgressCtrlHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $ "barSkillProgress" $ slot).HideWindow();
		GetProgressCtrlHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $ "barSkillProgress" $ slot).Reset();
		GetTextureHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $ "barSkillProgressEff"$ slot $ "_Left").HideWindow();
		GetTextureHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $ "barSkillProgressEff"$ slot $ "_Center").HideWindow();
		GetTextureHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $ "barSkillProgressEff"$ slot $ "_Right").HideWindow();
	}
}

/**
 *   ?????? ?????? ??????·С???Щ , ??Ш????? ???°?? , 3°????? »??????? µ??¶?? ??Ш??????? ???°?? ??С???.(????л??? ??л»??)
 *   Success, progress, Failed
 **/
function SetTextureBar(string stateString, int slot)
{
	GetProgressCtrlHandle(m_WindowName $".SkillProgressWnd" $ slot $ "." $"barSkillProgress"$slot).SetBackTex("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget $ "_" $ stateString $ "_Bg_Left", "L2UI_ct1.SkillOperate_DF_" $ strSelectTarget $ "_" $ stateString $ "_Bg_Center", "L2UI_ct1.SkillOperate_DF_" $ strSelectTarget $ "_" $ stateString $ "_Bg_Right");
	GetProgressCtrlHandle(m_WindowName $".SkillProgressWnd" $ slot $ "." $"barSkillProgress"$slot).SetBarTex("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget $ "_" $ stateString $ "_Gage_Left", "L2UI_ct1.SkillOperate_DF_" $ strSelectTarget $ "_" $ stateString $ "_Gage_Center", "L2UI_ct1.SkillOperate_DF_" $ strSelectTarget $ "_" $ stateString $ "_Gage_Right");
}


/**  
 *   ?????? ?????? ????С??? ??Ш????? ???°?? , 3°????? »??????? µ??¶?? ??Ш??????? ???°?? ??С???. 
 *   Success, progress, Failed
 **/
function SetEffectTexture(string stateString, int slot)
{
	GetTextureHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $"barSkillProgressEff" $ slot $"_Left").SetTexture("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget $ "_" $ stateString  $ "_Eff_Left");
	GetTextureHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $"barSkillProgressEff" $ slot $"_Center").SetTexture("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget $ "_" $ stateString  $ "_Eff_Center");
	GetTextureHandle(m_WindowName $ ".SkillProgressWnd" $ slot $ "." $"barSkillProgressEff" $ slot $"_Right").SetTexture("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget $ "_" $ stateString  $ "_Eff_Right");
}

/**
 * ???????? ???°Щ??? ???»?»???? ?????? on/off
 */
function StateBoxShow(bool b)
{
	if(b == true)
	{
		BuffWnd.ShowWindow();
	}
	else
	{
		BuffWnd.HideWindow();
	}
}

function int GetTargetID()
{
	return m_targetID;
}

function string GetWarMarkTargetTextureByWarMarkType(WARMARKTYPE Type)
{
	switch(Type)
	{
		case WARMARKTYPE.TYPE_BlueAttackLeader:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Blueflagleader";
			break;
		case WARMARKTYPE.TYPE_BlueAttackLeaderPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Blueflagleader_penalty";
			break;
		case WARMARKTYPE.TYPE_BlueSword:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Bluesword";
			break;
		case WARMARKTYPE.TYPE_BlueSwordPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Bluesword_penalty";
			break;
		case WARMARKTYPE.TYPE_BlueLeader:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_BluecrownLeader";
			break;
		case WARMARKTYPE.TYPE_BlueLeaderPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_BluecrownLeader_Penalty";
			break;
		case WARMARKTYPE.TYPE_BlueShield:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Blueshield";
			break;
		case WARMARKTYPE.TYPE_BlueShieldPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Blueshield_penalty";
			break;
		case WARMARKTYPE.TYPE_RedAttackLeader:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Redflagleader";
			break;
		case WARMARKTYPE.TYPE_RedAttackLeaderPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Redflagleader_penalty";
			break;
		case WARMARKTYPE.TYPE_RedSword:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Redsword";
			break;
		case WARMARKTYPE.TYPE_RedSwordPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Redsword_penalty";
			break;
		case WARMARKTYPE.TYPE_RedLeader:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_RedcrownLeader";
			break;
		case WARMARKTYPE.TYPE_RedLeaderPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_RedcrownLeader_Penalty";
			break;
		case WARMARKTYPE.TYPE_RedShield:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Redshield";
			break;
		case WARMARKTYPE.TYPE_RedShieldPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Redshield_penalty";
			break;
		case WARMARKTYPE.TYPE_DecalreWarBothSide:
			if(getInstanceUIData().getIsLiveServer())
			{
				return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Bothside";				
			}
			else
			{
				return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_BothsideClassic";
			}
			break;
		case WARMARKTYPE.TYPE_DecalreWarOneSide:
			if(getInstanceUIData().getIsLiveServer())
			{
				return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Oneside";				
			}
			else
			{
				return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_OnesideClassic";
			}
			break;
		case WARMARKTYPE.TYPE_UserWatcher:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_observation";
			break;
		case WARMARKTYPE.TYPE_DecalreWarOneSide_UserWatcher:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_observOneside";
			break;
		case WARMARKTYPE.TYPE_DecalreWarBothSide_UserWatcher:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_observBothside";
			break;
	}
	return "";
}

function int GetIndexByIsMagic(StatusIconInfo Info)
{
	local SkillInfo SkillInfo;

	if(!GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, SkillInfo))
	{
		return -1;
	}
	return SkillInfo.IsMagic;
}

/**
 * ??©µµ??? ESC ??°·?? ????±в ?????? 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	// PlayConsoleSound(IFST_WINDOW_CLOSE);
	OnCloseButton();
}

static function Color GetCPColor(int nCPCount)
{
	local Color nColor;

	if(nCPCount < 500)
	{
		nColor.R = byte(255);
		nColor.G = byte(255);
		nColor.B = byte(255);
		nColor.A = byte(255);
	}
	else if(nCPCount < 1000)
	{
		nColor.R = 0;
		nColor.G = byte(255);
		nColor.B = 0;
		nColor.A = byte(255);
	}
	else if(nCPCount < 1500)
	{
		nColor.R = 0;
		nColor.G = byte(255);
		nColor.B = byte(255);
		nColor.A = byte(255);
	}
	else if(nCPCount < 2000)
	{
		nColor.R = byte(255);
		nColor.G = byte(255);
		nColor.B = 0;
		nColor.A = byte(255);
	}
	else if(nCPCount < 3000)
	{
		nColor.R = byte(255);
		nColor.G = 170;
		nColor.B = 0;
		nColor.A = byte(255);
	}
	else if(nCPCount < 4000)
	{
		nColor.R = byte(255);
		nColor.G = 0;
		nColor.B = 0;
		nColor.A = byte(255);
	}
	else if(nCPCount >= 4000)
	{
		nColor.R = byte(255);
		nColor.G = 0;
		nColor.B = byte(255);
		nColor.A = byte(255);
	}
	return nColor;
}


defaultproperties
{
	m_WindowName="TargetStatusWnd"
}
