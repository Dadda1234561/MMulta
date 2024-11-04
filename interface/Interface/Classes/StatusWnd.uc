class StatusWnd extends UICommonAPI;

const	TIMER_ID1	=	1310;	
const 	TIMER_DELAY1	=	500;	
const	TIMER_ID2	= 	1311;
const	TIMER_DELAY2	=	20000;

//branch
const	TIMER_PREM1	= 1312;
const	TIMER_PREM_DELAY1	= 600;
const	TIMER_PREM2	= 1313;
const	TIMER_PREM_DELAY2	= 30000;
//end of branch

const 	ANIMMINALPHA	=	39;
const 	ANIMMAXALPHA	=	197;
//~ const	ANIMSPEED		=	15;
const	ANIMSPEEDFLOAT	=	0.40f;

var int m_UserID;
var bool m_bReceivedUserInfo;
var int GlobalAlpha;
var bool GlobalAlphaBool; 
var bool AnimTexKill;


//var bool isVPApplyChecked;//И°·ВАМ Аыїл µЗ°н АЦґВ єОєРА» ГјЕ© ЗЯґВ °Ў?
var bool isAfterStatusNormaEvent; // №цЗБ АМєҐЖ® АМИД И°·В ёЮЅГБц Гв·ВАО°Ў.
var bool isVPApply;//И°·ВАМ Аыїл µЗ°н АЦґВ°Ў? 

//var int m_Vitality; //ldw БЦј® Гіё®

var WindowHandle Me;
var StatusBarHandle CPBar;
var StatusBarHandle HPBar;
var StatusBarHandle MPBar;

//var StatusBarHandle EXPBar;//ldw
var NameCtrlHandle UserName;
var TextBoxHandle StatusWnd_LevelTextBox;
//var TextureHandle VitalityTex;//ldw БЦј® Гіё®
//var TextureHandle LifeForceAnimTex_Left;//ldw БЦј®
//var TextureHandle LifeForceAnimTex_Center;//ldw БЦј®
//var TextureHandle LifeForceAnimTex_Right;//ldw БЦј®
//var WindowHandle Statustooltipwnd;//20130611 xml їЎј­ »иБ¦ 
//var BarHandle VpDetailBar;					// И°·В ЖЫјѕЖ®ё¦ ЗҐЅГЗШБЦґВ °ФАМБц ГЯ°Ў by innowind 2008ів CT2_Final //ldw БЦј® Гіё®
var StatusBarHandle VpDetailBar;




var BarHandle barFATIGUE;
//~ var ButtonHandle LifeForceBtn;

var string m_WindowName;
var StatusBarHandle DPBar;
var StatusBarHandle BPBar;
const ULTIMATE_SKILL_POINT_BOUNDARY_LEVEL1 = 500;
const ULTIMATE_SKILL_POINT_BOUNDARY_LEVEL2 = 1000;
const ULTIMATE_SKILL_POINT_BOUNDARY_LEVEL3 = 1500;

//const WINDOW_MIN_SIZE_HEIGHT = 66;//ldw БЦј®
//const WINDOW_MAX_SIZE_HEIGHT = 84;//ldw БЦј®
const WINDOW_MIN_SIZE_HEIGHT = 82;//ldw И°·В °ФАМБц·О јцДЎё¦ 18 ґГёІ
const WINDOW_MAX_SIZE_HEIGHT = 102;//ldw И°·В °ФАМБц·О јцДЎё¦ 18 ґГёІ

const WINDOW_CLASSIC_SIZE_HEIGHT = 68;//Е¬·ЎЅД ј­№цїл VP ѕшґВ јцДЎ


const TIMER_BAR = 1410;
const TIMER_BAR_DELAY = 400;

//var int VitalityPer20;//ldw БЦј® Гіё®
var int MaxVitality; //ldw
//const MaxVitalityTime = 20;//ldw 20ЅГ°Ј БЦј® Гіё®
//И°·В єёіКЅє ГЯ°Ў 2015.05
var int nVitalityExtraBonus;
var int nVitalityBonus;
var int nVitalityItemMaxRestoreCount ;

//АЪµї ЖДЖј ЅГЅєЕЫ №цЖ°
//var ButtonHandle AutoPartyMatchingBtn;
//АЪµї ЖДЖј ЅГЅєЕЫ ѕЖАМДЬ
//var TextureHandle AutoPartyMatchingIcon;

var L2Util util;//bluesun ЕшЖБ Б¦ѕо їл

//branch ЗБё®№МѕцАЇАъ
var bool AnimTexKillPremium;
var int m_CurPremiumState;
var bool m_AlphaIncrese;
//end of branch

//branch
var WindowHandle LevelBoxTexPremium;
//end of branch

var WindowHandle StatusWnd_LevelTextBox_back;
var TextBoxHandle StatusWnd_LevelTextBoxAfter100;

var WindowHandle LevelWindowUnder100;
var WindowHandle LevelWindowAfter100;

var WindowHandle LevelBoxTexPremium100;
var TextureHandle StatusGaugeBg;
var TextureHandle CombatIcon_Tex;
var AnimTextureHandle CombatIcon_ON_ani;
var int nCombatOnOff;
var bool bFirstUpdate;
var INT64 MyMaxDP;
var INT64 MyMaxBP;

function OnRegisterEvent()
{
	RegisterEvent(EV_RegenStatus);
	
	//Level°ъ ExpґВ UserInfoЖРЕ¶Аё·О Гіё®ЗСґЩ.
	RegisterEvent(EV_UpdateUserInfo);
	
	//JYLee, АЗ№МѕшґВ ЗФјцИЈГвА» ё·±в А§ЗШ status Б¤єёё¦ і» Б¤єёїН ґЩёҐ ДіёЇЕНАЗ Б¤єё·О єРё®
	RegisterEvent(EV_UpdateMyHP);
	RegisterEvent(EV_UpdateMyMaxHP);
	RegisterEvent(EV_UpdateMyMP);
	RegisterEvent(EV_UpdateMyMaxMP);
	RegisterEvent(EV_UpdateMyCP);
	RegisterEvent(EV_UpdateMyMaxCP);
	RegisterEvent(EV_UpdateMyDP);
	RegisterEvent(EV_UpdateMyMaxDP);
	RegisterEvent(EV_UpdateMyBP); // 247
	RegisterEvent(EV_UpdateMyMaxBP); // 248
	//branch
	// F2P ј­єсЅє И°·В °іј± - gorillazin
	RegisterEvent(EV_VitalityEffectInfo);
	//end of branch

	//branch
	RegisterEvent(EV_BR_PREMIUM_STATE);
	//end of branch

	
	RegisterEvent(EV_NeedResetUIData);


	// И°·В ГЯ°Ў єёіКЅє ЗҐЅГё¦ №цЗБ АМИД єёї©БЦ±в А§ЗШ АМєҐЖ® µо·П
	RegisterEvent(EV_AbnormalStatusNormalItem);
	RegisterEvent(EV_ToggleCombatMode);
	RegisterEvent(EV_Restart);

}





//АМєҐЖ® µо·П
function OnLoad()
{
	//local UserInfo userinfo;//ldw АУЅГ
	//local int Vitality;	//ldw АУЅГ
	//Vitality = userinfo.nVitality;//ldw АУЅГ

	InitHandleCOD();

	bFirstUpdate = false;

	GlobalAlpha = 0;
	GlobalAlphaBool = true;
//	m_Vitality = 6; //ldw БЦј® Гіё®
	//VpDetailBar.SetValue(0, 0); //ldw БЦј® Гіё®
	
	InitAnimation();
	MaxVitality = GetMaxVitality();
	//branch
	LevelBoxTexPremium.HideWindow();
	LevelBoxTexPremium100.HideWindow();
	nCombatOnOff = 0;
	CombatIcon_Tex.SetTooltipCustomType(combatTooltip());

	//end of branch
}

function OnShow()
{
	toggleCombatMode("");
	// End:0x5B
	if(getInstanceUIData().getIsLiveServer())
	{
		GetWindowHandle("StatusWnd").ShowWindow();
		GetWindowHandle("StatusWndClassic").HideWindow();
	}
	else
	{
		bFirstUpdate = false;
		GetWindowHandle("StatusWnd").HideWindow();
		GetWindowHandle("StatusWndClassic").ShowWindow();
	}
}

function InitHandleCOD()
{
	Me = GetWindowHandle(m_WindowName);
	CPBar = GetStatusBarHandle(m_WindowName $ "." $ "CPBar");
	HPBar = GetStatusBarHandle(m_WindowName $ "." $ "HPBar");
	MPBar = GetStatusBarHandle(m_WindowName $ "." $ "MPBar");
	// End:0xA9
	if(m_WindowName == "StatusWndClassic")
	{
		DPBar = GetStatusBarHandle(m_WindowName $ "." $ "DPBar");
	}
	// End:0xE4
	if(m_WindowName == "StatusWndClassic")
	{
		BPBar = GetStatusBarHandle(m_WindowName $ "." $ "BPBar");
	}
	// End:0x127
	if(m_WindowName == "StatusWndClassic")
	{
		StatusGaugeBg = GetTextureHandle(m_WindowName $ "." $ "StatusGaugeBg");
	}
	// End:0x11B
	if(m_WindowName == "StatusWnd")
	{
		UserName = GetNameCtrlHandle(m_WindowName $ "." $ "UserName");
	}
	CombatIcon_Tex = GetTextureHandle(m_WindowName $ "." $ "CombatIcon_Tex");
	CombatIcon_ON_ani = GetAnimTextureHandle(m_WindowName $ "." $ "CombatIcon_ON_ani");
	StatusWnd_LevelTextBox = GetTextBoxHandle(m_WindowName $ "." $ "StatusWnd_LevelTextBox");
	StatusWnd_LevelTextBox_back = GetWindowHandle(m_WindowName $ "." $ "StatusWnd_LevelTextBox_back");
	LevelWindowUnder100 = GetWindowHandle(m_WindowName $ "." $ "StatusWnd_LevelTextBox_back");
	// End:0x389
	if(m_WindowName == "StatusWnd")
	{
		LevelBoxTexPremium = GetWindowHandle(m_WindowName $ "." $ "StatusWnd_LevelTextBox_back.WndLevelBackPremium");
		VpDetailBar = GetStatusBarHandle(m_WindowName $ "." $ "VpDetailBar");
		LevelWindowAfter100 = GetWindowHandle(m_WindowName $ "." $ "StatusWnd_LevelTextBox_back_lv100");
		StatusWnd_LevelTextBoxAfter100 = GetTextBoxHandle(m_WindowName $ "." $ "StatusWnd_LevelTextBox_back_lv100.StatusWnd_LevelTextBox");
		LevelBoxTexPremium100 = GetWindowHandle(m_WindowName $ "." $ "StatusWnd_LevelTextBox_back_lv100.WndLevelBackPremium_Lv100");
	}
}

function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID2)
	{
		AnimTexKill = true;
	}

	if(TimerID == TIMER_BAR)
	{
		Me.KillTimer(TIMER_BAR);
	}
	
	//branch
	if(TimerID == TIMER_PREM1)
	{
		if(m_AlphaIncrese)
		{
			if(getInstanceUIData().getIsLiveServer())
			{
				LevelBoxTexPremium.SetAlpha(ANIMMAXALPHA, ANIMSPEEDFLOAT);
				LevelBoxTexPremium100.SetAlpha(ANIMMAXALPHA, ANIMSPEEDFLOAT);
			}
			m_AlphaIncrese = false;
		}
		else if(!m_AlphaIncrese)
		{
			if(AnimTexKillPremium)
			{
				Me.KillTimer(TIMER_PREM1);
				Me.KillTimer(TIMER_PREM2);
				if(getInstanceUIData().getIsLiveServer())
				{
					LevelBoxTexPremium.SetAlpha(255, 1f);
					LevelBoxTexPremium100.SetAlpha(255, 1f);
				}
			}
			else
			{
				if(getInstanceUIData().getIsLiveServer())
				{
					LevelBoxTexPremium.SetAlpha(ANIMMINALPHA, ANIMSPEEDFLOAT);
					LevelBoxTexPremium100.SetAlpha(ANIMMINALPHA, ANIMSPEEDFLOAT);
				}
			}
			m_AlphaIncrese = true;
		}
	}
	if(TimerID == TIMER_PREM2)
	{
		AnimTexKillPremium = true;
		//debug("on timer TIMER_PREM2");
	}
	//end of branch
}

function PlayAnimation()
{
	Me.KillTimer(TIMER_ID1);
	Me.KillTimer(TIMER_ID2);
	AnimTexKill = false;
	Me.SetTimer(TIMER_ID1,TIMER_DELAY1);
	Me.SetTimer(TIMER_ID2,TIMER_DELAY2);
}

function InitAnimation()
{
	Me.KillTimer(TIMER_ID1);
	Me.KillTimer(TIMER_ID2);
	//branch
	Me.KillTimer(TIMER_PREM1);
	Me.KillTimer(TIMER_PREM2);

	if(getInstanceUIData().getIsLiveServer())
	{
		LevelBoxTexPremium.SetAlpha(1);
		LevelBoxTexPremium100.SetAlpha(ANIMMINALPHA, ANIMSPEEDFLOAT);
	}
	//end of branch
}

function OnEnterState(name a_CurrentStateName)
{

	//isVPApplyChecked = false;
	m_bReceivedUserInfo = false;
	isAfterStatusNormaEvent = false;
	//UpdateUserInfo(); //
	
}

function UpdateUserGauge(int Type)
{
	local UserInfo userinfo;

	if(GetPlayerInfo(userinfo))
	{
		m_UserID = userinfo.nID;
		
		switch(Type)
		{
			case 0:
				HPBar.SetPoint(userinfo.nCurHP, userinfo.nMaxHP);
				// End:0xB3
				break;
			case 1:
				MPBar.SetPoint(userinfo.nCurMP, userinfo.nMaxMP);
				// End:0xB3
				break;
			case 2:
				CPBar.SetPoint(userinfo.nCurCP, userinfo.nMaxCP);
				// End:0xB3
				break;
		}
	}
}

function UpdateUserInfo()
{
	local UserInfo UserInfo;
	local int vitality;

	if(GetPlayerInfo(UserInfo))
	{
		m_UserID = UserInfo.nID;
		vitality = UserInfo.nVitality;
		CPBar.SetPoint(UserInfo.nCurCP,UserInfo.nMaxCP);
		HPBar.SetPoint(UserInfo.nCurHP,UserInfo.nMaxHP);
		MPBar.SetPoint(UserInfo.nCurMP,UserInfo.nMaxMP);
		if(getInstanceUIData().getIsLiveServer())
		{
			VpDetailBar.SetPoint(vitality,MaxVitality);
		}
		if(getInstanceUIData().getIsLiveServer())
		{
			UserName.SetName(UserInfo.Name, NCT_Normal, TA_Left);
			// End:0x160
			if(nCombatOnOff > 0)
			{
				UserName.SetNameWithColor(UserInfo.Name, NCT_Normal, TA_Left,getInstanceL2Util().PKNameColor);
				UserName.SetWindowSizeRel(1.0,1.0,-75,-162);
			}
			else
			{
				UserName.SetNameWithColor(UserInfo.Name, NCT_Normal, TA_Left,getInstanceL2Util().White);
				UserName.SetWindowSizeRel(1.0,1.0,-50,-162);
			}
			StatusWnd_LevelTextBoxAfter100.SetInt(UserInfo.nLevel);
		}
		// End:0x238
		if(class'UIDATA_USER'.static.IsPrologueGrowType(UserInfo.nSubClass) && ! getInstanceUIData().getIsArenaServer())
		{
			// End:0x222
			if(GetLanguage() == LANG_Korean)
			{
				StatusWnd_LevelTextBox.SetText("∞");
			}
			else
			{
				StatusWnd_LevelTextBox.SetText("--");
			}
		}
		else
		{
			StatusWnd_LevelTextBox.SetInt(UserInfo.nLevel);
		}
		// End:0x323
		if(getInstanceUIData().getIsLiveServer())
		{
			// End:0x2D5
			if(UserInfo.nLevel > 99)
			{
				UserName.SetAnchor("StatusWnd", "TopLeft", "TopLeft", 53, 8);
				LevelWindowUnder100.HideWindow();
				LevelWindowAfter100.ShowWindow();
				StatusWnd_LevelTextBox_back.HideWindow();
			}
			else
			{
				UserName.SetAnchor("StatusWnd", "TopLeft", "TopLeft", 45, 8);
				LevelWindowUnder100.ShowWindow();
				LevelWindowAfter100.HideWindow();
			}
		}
		UpdateVp(vitality);
		// End:0x34C
		if(getInstanceUIData().getIsClassicServer())
		{
			setMoveBarForDP_BP_Bar(UserInfo);
		}
	}
}

function setMoveBarForDP_BP_Bar(UserInfo Info)
{
	local Rect rectWnd;

	// End:0x0B
	if(bFirstUpdate)
	{
		return;
	}
	// End:0x2DD
	if(getInstanceUIData().getIsClassicServer())
	{
		bFirstUpdate = true;
		rectWnd = Me.GetRect();
		// End:0x13E
		if(getInstanceL2Util().getPlayerType(Info.nSubClass, Info.Race) == "deathKnight")
		{			
			CPBar.MoveTo(rectWnd.nX + 62, rectWnd.nY + 3);
			HPBar.SetWindowSizeRel(1.0, 0.0, -75, 16);
			HPBar.MoveTo(rectWnd.nX + 62, rectWnd.nY + 9);
			MPBar.SetWindowSizeRel(1.0, 0.0, -75, 16);
			MPBar.MoveTo(rectWnd.nX + 62, rectWnd.nY + 26);
			DPBar.SetWindowSizeRel(1.0, 0.0, -75, 15);
			DPBar.MoveTo(rectWnd.nX + 62, rectWnd.nY + 43);
			DPBar.ShowWindow();
			BPBar.HideWindow();
			StatusGaugeBg.SetTexture("L2UI_NewTex.StatusWnd.StatusGaugeBg02");
		}
		else if(getInstanceL2Util().getPlayerType(Info.nSubClass, Info.Race) == "vanguard")
		{			
			CPBar.MoveTo(rectWnd.nX + 62, rectWnd.nY + 3);
			HPBar.SetWindowSizeRel(1.0, 0.0, -75, 16);
			HPBar.MoveTo(rectWnd.nX + 62, rectWnd.nY + 9);
			MPBar.SetWindowSizeRel(1.0, 0.0, -75, 16);
			MPBar.MoveTo(rectWnd.nX + 62, rectWnd.nY + 26);
			BPBar.SetWindowSizeRel(1.0, 0.0, -75, 15);
			BPBar.MoveTo(rectWnd.nX + 62, rectWnd.nY + 43);
			BPBar.ShowWindow();
			DPBar.HideWindow();
			StatusGaugeBg.SetTexture("L2UI_NewTex.StatusWnd.StatusGaugeBg02");	
		}
		else
		{
			CPBar.MoveTo(rectWnd.nX + 62, rectWnd.nY + 3);
			HPBar.SetWindowSizeRel(1.0, 0.0, -75, 24);
			HPBar.MoveTo(rectWnd.nX + 62, rectWnd.nY + 9);
			MPBar.SetWindowSizeRel(1.0, 0.0, -75, 24);
			MPBar.MoveTo(rectWnd.nX + 62, rectWnd.nY + 34);
			DPBar.HideWindow();
			BPBar.HideWindow();
			StatusGaugeBg.SetTexture("L2UI_NewTex.StatusWnd.StatusGaugeBg01");
		}
	}
}

function setDefaultPosistionOnShow()
{
	CPBar.ClearPoint();
	HPBar.ClearPoint();
	MPBar.ClearPoint();
	// End:0x4F
	if(getInstanceUIData().getIsClassicServer())
	{
		DPBar.ClearPoint();
	}
}

//branch
// F2P ј­єсЅє И°·В °іј± - gorillazin
function UpdateVp(int vitality)
{
	// End:0x6C
	if(getInstanceUIData().getIsLiveServer())
	{
		if((vitality < 1807)&&(vitality > 0))
		{
			VpDetailBar.SetPoint(1807,MaxVitality);
		}
		else
		{
			VpDetailBar.SetPoint(vitality,MaxVitality);
		}
	}
}

//Гў Е¬ёЇЗЯА»¶§ Её°ЩµЗ±в
function OnLButtonDown(WindowHandle a_WindowHandle, int X,int Y)
{
	local Rect rectWnd;

	switch(a_WindowHandle)
	{
		// End:0x0F
		case CPBar:
		// End:0x17
		case HPBar:
		// End:0x1F
		case MPBar:
		// End:0x27
		case DPBar:
		// End:0x2F
		case UserName:
		// End:0x37
		case StatusWnd_LevelTextBox:
		// End:0x93
		case VpDetailBar:
			rectWnd = a_WindowHandle.GetRect();
			if(X > rectWnd.nX && X < rectWnd.nX + rectWnd.nWidth)
			{
				RequestSelfTarget();
			}
			break;
		case Me:
			rectWnd = Me.GetRect();
			if(X > rectWnd.nX + 13 && X < rectWnd.nX + rectWnd.nWidth -10)
			{
				RequestSelfTarget();
			}
		break;
	}
}

function OnEvent(int a_EventID, string a_Param)
{
	// End:0x23
	if(getInstanceUIData().getIsLiveServer())
	{
		EachServerEvent(a_EventID, a_Param);
	}
}

function EachServerEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		// End:0x15
		case EV_GamingStateExit:
			InitAnimation();
			// End:0x1B9
			break;
		// End:0x23
		case EV_UpdateUserInfo:
			UpdateUserInfo();
			// End:0x1B9
			break;
		// End:0x37
		case EV_UpdateMyHP:
			HandleUpdateGauge(a_Param, 0);
			// End:0x1B9
			break;
		// End:0x4B
		case EV_UpdateMyMaxHP:
			HandleUpdateGauge(a_Param, 0);
			// End:0x1B9
			break;
		// End:0x5F
		case EV_UpdateMyMP:
			HandleUpdateGauge(a_Param, 1);
			// End:0x1B9
			break;
		// End:0x73
		case EV_UpdateMyMaxMP:
			HandleUpdateGauge(a_Param, 1);
			// End:0x1B9
			break;
		// End:0x88
		case EV_UpdateMyCP:
			HandleUpdateGauge(a_Param, 2);
			// End:0x1B9
			break;
		// End:0x9D
		case EV_UpdateMyMaxCP:
			HandleUpdateGauge(a_Param, 2);
			// End:0x1B9
			break;
		// End:0xB2
		case EV_UpdateMyDP:
			HandleUpdateGauge(a_Param, 3);
			// End:0x1B9
			break;
		// End:0xC5
		case EV_UpdateMyMaxDP:
			ParseMaxDp(a_Param);
			// End:0x1B9
			break;
		case EV_UpdateMyBP:
			HandleUpdateGauge(a_Param, 4);
			// End:0x1EA
			break;
		// End:0xED
		case EV_UpdateMyMaxBP:
			ParseMaxBp(a_Param);
			// End:0x1EA
			break;
		// End:0x100
		// End:0xD8
		case EV_RegenStatus:
			HandleRegenStatus(a_Param);
			// End:0x1B9
			break;
		// End:0x103
		case EV_VitalityEffectInfo:
			// End:0x100
			if(! getInstanceUIData().getIsClassicServer())
			{
				HandleVitalityEffectInfo(a_Param);
			}
			// End:0x1B9
			break;
		// End:0x119
		case EV_BR_PREMIUM_STATE:
			HandlePremiumState(a_Param);
			// End:0x1B9
			break;
		// End:0x135
		case EV_NeedResetUIData:
			// End:0x132
			if(! checkArenaForm())
			{
				checkClassicForm();
			}
			// End:0x1B9
			break;
		// End:0x16E
		case EV_AbnormalStatusNormalItem:
			// End:0x16B
			if(! getInstanceUIData().getIsClassicServer())
			{
				// End:0x16B
				if(! isAfterStatusNormaEvent)
				{
					isAfterStatusNormaEvent = true;
					showSystemMsg();
				}
			}
			// End:0x1B9
			break;
		// End:0x185
		case EV_ToggleCombatMode:
			toggleCombatMode(a_Param, true);
			// End:0x1B9
			break;
		// End:0x1B3
		case EV_Restart:
			setDefaultPosistionOnShow();
			bFirstUpdate = false;
			nCombatOnOff = 0;
			MyMaxDP = 0;
			MyMaxBP = 0;
			toggleCombatMode("");
			// End:0x1B9
			break;
		// End:0xFFFF
		default:
			break;
	}
}

function ParseMaxDp(string param)
{
	local int ServerID;

	ParseInt(param, "ServerID", ServerID);
	// End:0x42
	if(m_UserID == ServerID)
	{
		ParseINT64(param, "MyMaxDP", MyMaxDP);
	}
}

function ParseMaxBp(string param)
{
	local int ServerID;

	ParseInt(param, "ServerID", ServerID);
	// End:0x42
	if(m_UserID == ServerID)
	{
		ParseINT64(param, "MyMaxBP", MyMaxBP);
	}
}

function toggleCombatMode(string paramStr, optional bool bUseGfxScreenMessage)
{
	local UserInfo UserInfo;

	ParseInt(paramStr,"OnOff",nCombatOnOff);
	GetPlayerInfo(UserInfo);
	if(nCombatOnOff > 0)
	{
		CombatIcon_Tex.ShowWindow();
		AnimTexturePlay(CombatIcon_ON_ani, true, 1);
		// End:0xAE
		if(getInstanceUIData().getIsLiveServer())
		{
			UserName.SetNameWithColor(UserInfo.Name, NCT_Normal, TA_Left, getInstanceL2Util().PKNameColor);
			UserName.SetWindowSizeRel(1.0,1.0,-75,-162);
		}
		else
		{
			// End:0x114
			if(m_WindowName == "StatusWndClassic")
			{
				GetTextureHandle(m_WindowName $ "." $ "StatusWnd_LevelTextBox_back.CombatIcon_ON_BG").ShowWindow();
			}
		}
		// End:0x138
		if(bUseGfxScreenMessage)
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13032));
		}
	}
	else
	{
		CombatIcon_Tex.HideWindow();
		AnimTextureStop(CombatIcon_ON_ani, true);
		// End:0x1BB
		if(getInstanceUIData().getIsLiveServer())
		{
			UserName.SetNameWithColor(UserInfo.Name, NCT_Normal, TA_Left, getInstanceL2Util().White);
			UserName.SetWindowSizeRel(1.0, 1.0, -50, -162);
		}
		else
		{
			// End:0x221
			if(m_WindowName == "StatusWndClassic")
			{
				GetTextureHandle(m_WindowName $ "." $ "StatusWnd_LevelTextBox_back.CombatIcon_ON_BG").HideWindow();
			}
		}
		// End:0x245
		if(bUseGfxScreenMessage)
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13033));
		}
	}
}

function CustomTooltip combatTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13078), getInstanceL2Util().PKNameColor,"", true, true);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	return mCustomTooltip;
}

function bool checkArenaForm()
{
	local int w;
	local int h;
	local Rect rectWnd;

	Me.GetWindowSize(w, h);

	if(getInstanceUIData().getIsArenaServer())
	{
		rectWnd = Me.GetRect();
		VpDetailBar.HideWindow();
		CPBar.HideWindow();
		HPBar.MoveTo(rectWnd.nX + 19, rectWnd.nY + 27);
		MPBar.MoveTo(rectWnd.nX + 19, rectWnd.nY + 40);
		Me.SetWindowSize(w, WINDOW_CLASSIC_SIZE_HEIGHT - 12);
		return true;
	}
	return false;
}

function checkClassicForm()
{}

// И°·В јцДЎёё ѕчµҐАМЖ®
function HandleVitalityPointInfo(string param)
{
	local int nVitality;
	
	ParseInt(param, "Vitality", nVitality);
	
	UpdateVp(nVitality);	// И°·В °ФАМБцё¦ ѕчµҐАМЖ® ЗСґЩ.
}

//°ФАМБцёё ѕчµҐАМЖ®
function HandleUpdateGauge(string param, int Type)
{
	local int ServerID;
	local INT64 MyCurrentDP, MyCurrentBP;

	// End:0x19
	if(! m_bReceivedUserInfo)
	{
		m_bReceivedUserInfo = true;
		UpdateUserInfo();
	}
	ParseInt(param, "ServerID", ServerID);
	// End:0xED
	if(m_UserID == ServerID)
	{
		UpdateUserGauge(Type);
		// End:0x9D
		if(Type == 3)
		{
			ParseINT64(param, "MyCurrentDP", MyCurrentDP);
			// End:0x9D
			if(MyMaxDP > 0)
			{
				DPBar.SetPoint(MyCurrentDP, MyMaxDP);
			}
		}
		// End:0xED
		if(Type == 4)
		{
			ParseINT64(param, "MyCurrentBP", MyCurrentBP);
			// End:0xED
			if(MyMaxBP > 0)
			{
				BPBar.SetPoint(MyCurrentBP, MyMaxBP);
			}
		}
	}
}

//АьГјБ¤єё ѕчµҐАМЖ®
function HandleUpdateInfo(string param)
{
	local int ServerID;
	ParseInt(param, "ServerID", ServerID);

	//ѕЖБч UserїЎ ґлЗС Б¤єёё¦ №ЮБцёшЗЯґЩёй, №«Б¶°З Updateё¦ ЅЗЅГЗСґЩ.
	if(m_UserID == ServerID || !m_bReceivedUserInfo)
	{
		m_bReceivedUserInfo = true;
		UpdateUserInfo();
	}
}

function HandleRegenStatus(String a_Param)
{
	local int type;
	local int duration;
	local int ticks;
	local float amount;

	ParseInt(a_Param, "Type", type);

	//typeАМ 1АП °жїм : HP ё®БЁ»уЕВё¦ єёї©БЬ =>ЗцАз 1ёё ј­№цїЎј­ єёі»БЬ
	if(type==1)
	{
		ParseInt(a_Param, "Duration", duration);
		ParseInt(a_Param, "Ticks", ticks);
		ParseFloat(a_Param, "Amount", amount);
		HPBar.SetRegenInfo(duration,ticks,amount);
	}
}

//branch
function PlayAnimationPrem()
{
	Me.KillTimer(TIMER_PREM1);
	Me.KillTimer(TIMER_PREM2);	
	AnimTexKillPremium = false;
	Me.SetTimer(TIMER_PREM1,TIMER_PREM_DELAY1);
	Me.SetTimer(TIMER_PREM2,TIMER_PREM_DELAY2);
	m_AlphaIncrese = true;
}
//end of branch


//branch
function HandlePremiumState(string a_Param)
{
	local int premiumstate;

	ParseInt(a_Param, "PREMIUMSTATE", premiumstate);
	// End:0x2F
	if(m_CurPremiumState == premiumstate)
	{
		return;
	}
	m_CurPremiumState = premiumstate;
	// End:0x7F
	if(m_CurPremiumState == 1)
	{
		if(getInstanceUIData().getIsLiveServer())
		{
			LevelBoxTexPremium.ShowWindow();
			LevelBoxTexPremium100.ShowWindow();
			PlayAnimationPrem();
		}
	}
	else
	{
		if(getInstanceUIData().getIsLiveServer())
		{
			LevelBoxTexPremium.HideWindow();
			LevelBoxTexPremium100.HideWindow();
		}
		InitAnimation();
	}
}
//end of branch

//branch
// F2P ј­єсЅє И°·В °іј± - gorillazin
function HandleVitalityEffectInfo(string param)
{	
	local CustomTooltip T;
	local int nVitality, nVitalityItemRestoreCount;	
	
	//local string sMessage;

	local string sBonusString;
	local string sExtraBonusString;

	ParseInt(param, "vitalityPoint", nVitality);
	ParseInt(param, "vitalityBonus", nVitalityBonus);
	ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
	ParseInt(param, "maxRestoreCount", nVitalityItemMaxRestoreCount);

	// И°·В ГЯ°Ў єёіКЅє ЗҐЅГ 2015.05
	ParseInt(param, "vitalityExtraBonus", nVitalityExtraBonus);
	
	//Debug("" @ nVitalityExtraBonus  @ isVPApplyChecked);

	sBonusString = nVitalityBonus $ "%";
	if(nVitalityExtraBonus > 0)
	{
		sExtraBonusString = "(+" $ nVitalityExtraBonus $ "%)";
	}	

	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(T);

	// И°·В єёіКЅє:
	util.ToopTipInsertText(GetSystemString(2494), true, false);
	
	// И°·ВАМ 0 АО °жїм №МАыїл ЗҐЅГ
	if(nVitality <= 0)
	{		
		util.ToopTipInsertText(GetSystemString(2496), true, false, util.ETooltipTextType.COLOR_GRAY);
		util.ToopTipInsertText(GetSystemMessage(13112),True,True);
	}
	// И°·В 0 АМ»уАО °жїм 
	else
	{
		util.ToopTipInsertText(sBonusString, true, false);	
		//util.ToopTipInsertText(sExtraBonusString, true, false, util.ETooltipTextType.COLOR_GREEN);
		util.ToopTipInsertText(sExtraBonusString, true, false, util.ETooltipTextType.COLOR_YELLOW03);		
		util.ToopTipInsertText(" " $ GetSystemString(2495)$ ". " , true, false);
		util.ToopTipInsertText(GetSystemMessage(13111),True,True);
	}

	VpDetailBar.SetTooltipCustomType(util.getCustomToolTip());

	// И°·В Аыїл, №МАыїлАМ єЇ°ж µЗґВ °жїмїЎ ЅГЅєЕЫ ёЮЅГБц Гв·В 	
	if((isVPApply && nVitality == 0)||(!isVPApply && nVitality  > 0))showSystemMsg();	
}

// ёЗ ГіАЅ °ФАУїЎ µйѕо°¬А» ¶§ И°·В °ь·Г ёЮЅГБцё¦ Гв·В ЗФ.
// И°·В Аыїл, №МАыїлАМ єЇ°ж µЗґВ °жїмїЎ ЅГЅєЕЫ ёЮЅГБц Гв·В 
function showSystemMsg()
{
	local string sBonusString;
	local string sExtraBonusString;

	local string sSysMsgParamString;
	local UserInfo userinfo;
	local int nVitality;
	local string sMessage;

	if(!GetPlayerInfo(userinfo))return;
	
	nVitality = userinfo.nVitality ;

	sBonusString = nVitalityBonus $ "%";
	if(nVitalityExtraBonus > 0)
	{
		sExtraBonusString = "(+" $ nVitalityExtraBonus $ "%)";
	}
	
	// ГЯ°Ў єёіКЅє Б¤»у ЗҐЅГё¦ А§ЗШ
	// №цЗБё¦ ґЩ №Ю°н іЄёй, И°·В °ь·Г ёЮЅГБцё¦ Гв·В ЗТ јц АЦµµ·П ЗФ.
	if(isAfterStatusNormaEvent)
	{
		isVPApply = nVitality > 0;
		// И°·В ЖчАОЖ®°Ў 0єёґЩ Е« °жїм Аыїл »уЕВ
		if(isVPApply)
		{
			//AddSystemMessage(3525);
			ParamAdd(sSysMsgParamString, "Type", string(int(ESystemMsgParamType.SMPT_STRING)));
			ParamAdd(sSysMsgParamString, "param1", sBonusString$sExtraBonusString);
			AddSystemMessageParam(sSysMsgParamString);
			sSysMsgParamString = "";
			ParamAdd(sSysMsgParamString, "Type", string(int(ESystemMsgParamType.SMPT_NUMBER)));
			ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemMaxRestoreCount));
			AddSystemMessageParam(sSysMsgParamString);
			sMessage = EndSystemMessageParam(6067, true);
			// End:0x130
			if(! getInstanceUIData().getIsClassicServer())
			{
				AddSystemMessageString(sMessage);
			}
			isVPApply = true;
		}
		// №МАыїл »уЕВ
		else 
		{
			//AddSystemMessage(3526);
			ParamAdd(sSysMsgParamString, "Type", string(int(ESystemMsgParamType.SMPT_NUMBER)));
			ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemMaxRestoreCount));
			AddSystemMessageParam(sSysMsgParamString);
			sMessage = EndSystemMessageParam(6068, true);
			AddSystemMessageString(sMessage);
			isVPApply = false;
		}
	}
}

//
//end of branch
// ё¶їмЅє їАёҐВК №цЖ° Е¬ёЇ
function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local int targetID;
	local string userNameStr;
	local UserInfo targetUserInfo;

	rectWnd = Me.GetRect();

	//Её°ЩID ѕтѕоїА±в
	targetID = m_UserID;
	// End:0x10E
	if(targetID > 0)
	{
		// End:0x10E
		if(X > rectWnd.nX && X < rectWnd.nX + rectWnd.nWidth)
		{
			// End:0x10E
			if(Y > rectWnd.nY && Y < rectWnd.nY + rectWnd.nHeight)
			{
				// ДБЕШЅєЖ® ёЮґє ±ёјєА» А§ЗС Б¤єё save
				userNameStr = class'UIDATA_USER'.static.GetUserName(targetID);
				// End:0x10E
				if(userNameStr != "")
				{
					// End:0xCB
					if(GetTargetInfo(targetUserInfo))
					{
						// empty
					}
					// End:0xEA
					if(targetUserInfo.nID != targetID)
					{
						setTargetByServerID(targetID);
					}
					getInstanceContextMenu().execContextEvent(userNameStr, targetID, X, Y);
				}
			}
		}
	}
}

defaultproperties
{
     m_WindowName="StatusWnd"
}
