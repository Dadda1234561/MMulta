//class DetailStatusWnd extends UIScript;
class DetailStatusWnd extends UICommonAPI 
	dependson(StatBonusWndClassic);

const DIALOG_DetailStatusWnd = 90005;
const NSTATUS_SMALLBARSIZE = 85;
const NSTATUS_BARHEIGHT = 12;

struct SubjobInfo
{
	var int Id;
	var int ClassID;
	var int Level;
	var int Type;
};

var String m_WindowName;
var int m_UserID;
var HennaInfo m_HennaInfo;
//var UserInfo currentUserInfo;

var WindowHandle Me;

//Handle
var TextBoxHandle txtClassName;
var TextBoxHandle txtSP;
var TextBoxHandle txtName1;
var TextBoxHandle txtName2;
var TextBoxHandle txtHeadPledge;
var TextBoxHandle txtPledge;
var TextBoxHandle txtLvHead;
var TextBoxHandle txtLvName;
var TextBoxHandle txtHeadRank;
var TextBoxHandle txtRank;
var StatusBarHandle texHP;
var StatusBarHandle texMP;
var StatusBarHandle texExp;
var StatusBarHandle texCP;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtGmMoving;
var TextBoxHandle txtHeadMovingSpeed;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtHeadMagicCastingSpeed;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtSTR;
var TextBoxHandle txtDEX;
var TextBoxHandle txtCON;
var TextBoxHandle txtINT;
var TextBoxHandle txtWIT;
var TextBoxHandle txtMEN;
var TextBoxHandle txtCriminalRate;
var TextBoxHandle txtItemScore;
var TextBoxHandle txtPVP;
var TextBoxHandle txtSociality;
var TextBoxHandle txtBonusVote;
var TextBoxHandle txtRaidPoint;
var TextureHandle texHero;
var TextureHandle texPledgeCrest;
var TextureHandle VitalityTex;
var TextBoxHandle txtLUC;
var TextBoxHandle txtCHA;

var TextBoxHandle txtAttrAttackType;
var TextBoxHandle txtAttrAttackValue;
var TextBoxHandle txtAttrDefenseValFire;
var TextBoxHandle txtAttrDefenseValWater;
var TextBoxHandle txtAttrDefenseValWind;
var TextBoxHandle txtAttrDefenseValEarth;
var TextBoxHandle txtAttrDefenseValHoly;
var TextBoxHandle txtAttrDefenseValUnholy;

var TextBoxHandle txtHeadSTR;
var TextBoxHandle txtHeadDEX;
var TextBoxHandle txtHeadCON;
var TextBoxHandle txtHeadINT;
var TextBoxHandle txtHeadWIT;
var TextBoxHandle txtHeadMEN;

var TextBoxHandle txtHeadLUC;
var TextBoxHandle txtHeadCHA;

var ButtonHandle AbilityOpen;

var StatusBarHandle texVP;//ldw

var AnimTextureHandle APActive;

var int MaxVitality; //ldw

//var int nCanUseAP; //ldw

var L2Util util;//bluesun ?�шЖ�? ?�¦ѕ�? ?��?



//------------------------------
//    ?��?·?�ЅєєЇ°жё�??��?
//------------------------------
// ±?�єэАМґВЗцАзЕ�?·?�Ѕ�?, ?�МЖеЖ�?
var AnimTextureHandle ClassChangeLightBig;

// ?�цАзЕ�?·?�ЅєЕШЅєГ�?
// ?��??��?: l2ui_ct1.PlayerStatusWnd_ClassBgMain_Big(»?�°�?)
// ?��??��?: l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big (?�»»�?)
var TextureHandle ClassBgMain_Big;

// ?��?·?�Ѕєё¶Е©ЕШЅєГ�?
var TextureHandle ClassMarkBig;

//------------------------------
//     ?��?·?�ЅєєЇ°ж№?�Ж�?
//------------------------------
var AnimTextureHandle ClassChangeLightSmall1;

// ?��?·?�Ѕє№и°ж?�ШЅєГ�?1,2,3
var TextureHandle ClassBgMain_Small1;

// ?��?·?�Ѕєё¶Е�?
var TextureHandle ClassMarkSmall1;

// µа?��?, ?��??�кЕ�?·?�ЅєєЇ°ж№?�Ж�?
var ButtonHandle ClassFrameBtn1;

// ?�·АвБ¤є�?
var array<SubjobInfo> subjobInfoArray;
var SubjobInfo beforeSubjobInfo;

// ?�цАзИ°јєИ�?µ?�ѕоАЦґВЕ�?·?�Ѕ�?
var int currentSubjobClassNum;

// ?�цА�? µа?��? ?��?·?�Ѕ�? ?��??�кАвА�? ?�ЦґВ°�??
var bool    isDualClass;

// ?�УЅГ·�? µа?��? ?��?·?�Ѕ�? , ?��??�кА�? ?�¤єёё�? ?�ъАеЗШј�? ?�ўА�? ?��??�±¶�? ?�¶ґ�? °»?��? ?�Т¶�? »з?�лЗСґ�?.
// var string  saveUpdateSubjobInfoParam;

// ?�¶Бцё·Аё·�? ?��Ю?��? ?��??�кА�?, µа?��? °?�·�? ?�МєҐЖ�? °?? ?�ъА�?
// var int updateSubjobLastEvent;
/*
History: UObject::ProcessEvent <-(DamageText Transient.DamageText, Function Interface.DamageText.OnEvent) <- 
GFxUIManager::ExecuteUIEvent <- ID:580, param:Index=361 Param1=1209048809 Param2=1209050262 <- ExecuteUIEvent
<- NSystemMessageManager::EndSystemMessageParam <- NConsoleWnd::EndSystemMessageParam <- SystemMessagePacket <- 
UNetworkHandler::Tick <- Function Name=SystemMessagePa <- UGameEngine::Tick <- UpdateWorld <- MainLoop
 **/

var int race;

var int CurrentSubjobClassID;

/**
 * OnRegisterEvent
 **/
function OnRegisterEvent()
{
	//Level°?�Exp?�ВUserInfo?�РЕ¶Аё·ОГіё�??�Сґ�?.
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_UpdateHennaInfo);
	
	//JYLee, ?�З№?�ѕшґ�? ?�ФјцИЈГвА�? ?�·±�? ?�§З�? status ?�¤єёё�? ?��? ?�¤єёї�? ?�Щё�? ?�іёЇЕНА�? ?�¤єё·�? ?�Рё�?
	RegisterEvent(EV_UpdateMyHP);
	RegisterEvent(EV_UpdateMyMaxHP);
	RegisterEvent(EV_UpdateMyMP);
	RegisterEvent(EV_UpdateMyMaxMP);
	RegisterEvent(EV_UpdateMyCP);
	RegisterEvent(EV_UpdateMyMaxCP);

	// ?�°·ВѕчµҐАМЖ�?
	RegisterEvent(EV_VitalityPointInfo);	

	// ?�ЩАМѕу·О±�?(?��??�кЕ�?·?�ЅєєЇ°жИ�??�Ої�?)
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);

	//µа?�уЕ�?·?�Ѕє№Ч?��??�кЕ�?·?�Ѕєё�??�єЖ�?
	RegisterEvent(EV_NotifySubjob);
	// CurrentSubjobClassID=3 Count=3 SubjobID_1 SubjobClassID_1=44 SubjobLevel_1=55 SubjobType_1
	RegisterEvent(EV_CreatedSubjob);
	RegisterEvent(EV_ChangedSubjob);

// CurrentSubjobClassID=117 Count=3 SubjobID_1=1 SubjobClassID_1=3 SubjobLevel_1=55 SubjobType_1=0 SubjobID_2=1 SubjobClassID_2=73 SubjobLevel_2=55 SubjobType_2=1 SubjobID_3=1 SubjobClassID_3=131 SubjobLevel_3=55 SubjobType_3=2
	// µа?�уЕ�?·?�Ѕє№Ч?��??�кЕ�?·?�Ѕєё�??�єЖ�?
	// const EV_NotifySubjob = 5310;
	// const EV_CreatedSubjob = 5311;
	// const EV_ChangedSubjob = 5312;
	// ±жµе±Ч·?�µеё¶ЅєЕНЗСЕЧ°Ўј�?
	// ?�ПИёјєДщЅєЖ�?234 1
	// ?�ПИёјєДщЅєЖ�?235 1
	// ?��??�кГ�?°??

	//branch
	// F2P ?��??�сЅ�? ?�°·�? °?�ј�? - gorillazin
	RegisterEvent(EV_VitalityEffectInfo);	
	//
	//end of branch
	
	//branch120703
	RegisterEvent(EV_ToggleDetailStatusWnd);
	RegisterEvent(EV_TutorialShowID);
}

function OnLoad()
{
	SetClosingOnESC();
	
	InitializeCOD();

	Me.EnableWindow();

	// ?��?·?�ЅєєЇ°ж№?�Ж°єсИ°јєИ�?
	initClassChangeButton(false);
	MaxVitality = GetMaxVitality();//ldw
	txtHeadRank.HideWindow();
	txtRank.HideWindow();

	texExp.SetDecimalPlace(4);
}

/*
function onCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "UpdateUseAP" :
			nCanUseAP = int(param);
			handleAbilityBtnTooltip();
		break;
	}
}


function handleAbilityBtnTooltip()
{
	local CustomTooltip T;
	local string tmpTooltipString;	

	T.MinimumWidth = 125; // 125 ·?? ?�цБ¤ЗШѕ�??��?

	util = L2Util(GetScript("L2Util"));//bluesun ?�їЅєЕНё¶АМБ�? ?�шЖ�? 
	util.setCustomTooltip(T);//bluesun ?�їЅєЕНё¶АМБ�? ?�шЖ�?	
	
	

//	Debug("handleAbilityBtnTooltip1");
	//?��?�Ж�? ?�°ј�?		
	//?�оєфё�??��? ?�чАМЖ�? : ?��? ?�чАОЖ�? ¶?�ґ�? ?��??�ГБ�? 		
	tmpTooltipString = MakeFullSystemMsg(GetSystemMessage(4194), String(nCanUseAP));
	util.ToopTipInsertText(tmpTooltipString , false, false);
	AbilityOpen.SetTooltipCustomType(util.getCustomToolTip());//bluesun ?�їЅєЕНё¶АМБ�? ?�шЖ�?
}
*/

function handleAbilityBtn(bool enable, int nCanUseAP)
{
	local CustomTooltip T;
	local string tmpTooltipString;	
	
	if(enable)
	{
		T.MinimumWidth = 125;
	}
	else
	{
		T.MinimumWidth = 180;
	}
	
	util = L2Util(GetScript("L2Util"));//bluesun ?�їЅєЕНё¶АМБ�? ?�шЖ�? 
	util.setCustomTooltip(T);//bluesun ?�їЅєЕНё¶АМБ�? ?�шЖ�?

	APActive.HideWindow();

	if(enable)
	{
		//?��?�Ж�? ?�°ј�?
		GetTextureHandle(m_WindowName $ ".abilityIconSlotBlank").HideWindow();
		AbilityOpen.ShowWindow();
		//?�оєфё�??��? ?�чАМЖ�? : ?��? ?�чАОЖ�? ¶?�ґ�? ?��??�ГБ�?
		tmpTooltipString = MakeFullSystemMsg(GetSystemMessage(4194),string(nCanUseAP));		

		//Debug(tmpTooltipString @ nCanUseAP) ;
		if(nCanUseAP > 0) 
		{
			APActive.ShowWindow();
			APActive.SetLoopCount(999);
			APActive.Play();
		}
		
//Debug("?�оєфё�??��? ?�чАОЖ�? »з?��? °?�ґ�? ?��? ?�¶°Зї�? µµ?��? ?��??��? ±?�єэА�? °??");
		util.ToopTipInsertText(tmpTooltipString , false, false);
		AbilityOpen.SetTooltipCustomType(util.getCustomToolTip());
	}
	else 
	{	
		AbilityOpen.HideWindow();
		GetTextureHandle(m_WindowName $ ".abilityIconSlotBlank").ShowWindow();
		//99·?��?��? ?�М»�?, ?�лєн·№?�єА�? ¶§..............?��?��?��?�� ?�ПЅ�? ?��? ?�ЦЅАґПґ�?.... ¶?�ґ�? ?��??�ГБ�? 
		tmpTooltipString = GetSystemMessage(4195);
		util.ToopTipInsertText(tmpTooltipString , false, false);
		GetTextureHandle(m_WindowName $ ".abilityIconSlotBlank").SetTooltipCustomType(util.getCustomToolTip());
	}
}

/**
 * ?��?·?�ЅєєЇ°ж№?�Ж°єсИ°јєИ�?
 **/ 
function initClassChangeButton(bool visibleFlag)
{
	local int i;

	// ?��?�Ж°єсИ°јєИ�?
	for(i = 1; i < 2; i++)
	{
		// ?��?�Ж°єсИ°ј�?, ?�Ъ№°?�иєёАМµµ·ПјјЖ�?
		setClassTexture(i, "", "", false);
		
		GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).DisableWindow();
		GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).SetTexture("L2UI_ct1.Misc_DF_Blank",
																		  "L2UI_ct1.Misc_DF_Blank",
																		  "L2UI_ct1.Misc_DF_Blank");

		GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).SetTooltipCustomType(subjobButtonToolTips(-1));

		if(visibleFlag)
		{

			// GetTextureHandle(m_WindowName $ ".ClassSlotBlank" $ i).ShowWindow();
			// GetTextureHandle(m_WindowName $ ".ClassFrameBtn" $ i).ShowWindow();

		}
		else 
		{   
			// GetTextureHandle(m_WindowName $ ".ClassSlotBlank" $ i).HideWindow();
			// GetTextureHandle(m_WindowName $ ".ClassFrameBtn" $ i).HideWindow();			
		}
	}
}

function InitializeCOD()
{
	Me = GetWindowHandle("DetailStatusWnd");

	// ?��?·?�ЅєєЇ°ж±фєэАМЕШЅєГ�?
	ClassChangeLightBig = GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig");
	ClassChangeLightSmall1 = GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall1");

	// ?��?·?�ЅєєЇ°ж№и°ж?�ШЅєГ�?
	ClassBgMain_Big = GetTextureHandle(m_WindowName $ ".ClassBgMain_Big");
	ClassBgMain_Small1 = GetTextureHandle(m_WindowName $ ".ClassBgMain_Small1");

	// ?��?·?�ЅєєЇ°ж№?�Ж�?	
	ClassFrameBtn1 = GetButtonHandle(m_WindowName $ ".ClassFrameBtn1");

	// ?��?·?�ЅєєЇ°жё¶Е�?
	ClassMarkBig = GetTextureHandle(m_WindowName $ ".ClassMarkBig");
	ClassMarkSmall1 = GetTextureHandle(m_WindowName $ ".ClassMarkSmall1");
	txtClassName = GetTextBoxHandle(m_WindowName $ ".txtClassName");
	txtSP = GetTextBoxHandle(m_WindowName $ ".txtSP");
	txtName1 = GetTextBoxHandle(m_WindowName $ ".txtName1");
	txtName2 = GetTextBoxHandle(m_WindowName $ ".txtName2");
	txtHeadPledge = GetTextBoxHandle(m_WindowName $ ".txtHeadPledge");
	txtPledge = GetTextBoxHandle(m_WindowName $ ".txtPledge");
	txtLvHead = GetTextBoxHandle(m_WindowName $ ".txtLvHead");
	txtLvName = GetTextBoxHandle(m_WindowName $ ".txtLvName");
	txtHeadRank = GetTextBoxHandle(m_WindowName $ ".txtHeadRank");
	txtRank = GetTextBoxHandle(m_WindowName $ ".txtRank");
	texHP = GetStatusBarHandle(m_WindowName $ ".texHP");
	texMP = GetStatusBarHandle(m_WindowName $ ".texMP");
	texExp = GetStatusBarHandle(m_WindowName $ ".texExp");
	texCP = GetStatusBarHandle(m_WindowName $ ".texCP");
	txtPhysicalAttack = GetTextBoxHandle(m_WindowName $ ".txtPhysicalAttack");
	txtPhysicalDefense = GetTextBoxHandle(m_WindowName $ ".txtPhysicalDefense");
	txtHitRate = GetTextBoxHandle(m_WindowName $ ".txtHitRate");
	txtCriticalRate = GetTextBoxHandle(m_WindowName $ ".txtCriticalRate");
	txtPhysicalAttackSpeed = GetTextBoxHandle(m_WindowName $ ".txtPhysicalAttackSpeed");
	txtMagicalAttack = GetTextBoxHandle(m_WindowName $ ".txtMagicalAttack");
	txtMagicDefense = GetTextBoxHandle(m_WindowName $ ".txtMagicDefense");
	txtPhysicalAvoid = GetTextBoxHandle(m_WindowName $ ".txtPhysicalAvoid");
	txtGmMoving = GetTextBoxHandle(m_WindowName $ ".txtGmMoving");
	txtMovingSpeed = GetTextBoxHandle(m_WindowName $ ".txtMovingSpeed");
	txtMagicCastingSpeed = GetTextBoxHandle(m_WindowName $ ".txtMagicCastingSpeed");
	txtHeadMovingSpeed = GetTextBoxHandle(m_WindowName $ ".txtHeadMovingSpeed");
	txtHeadMagicCastingSpeed = GetTextBoxHandle(m_WindowName $ ".txtHeadMagicCastingSpeed");
	txtSTR = GetTextBoxHandle(m_WindowName $ ".txtSTR");
	txtDEX = GetTextBoxHandle(m_WindowName $ ".txtDEX");
	txtCON = GetTextBoxHandle(m_WindowName $ ".txtCON");
	txtINT = GetTextBoxHandle(m_WindowName $ ".txtINT");
	txtWIT = GetTextBoxHandle(m_WindowName $ ".txtWIT");
	txtMEN = GetTextBoxHandle(m_WindowName $ ".txtMEN");
	txtCriminalRate = GetTextBoxHandle(m_WindowName $ ".txtCriminalRate");
	txtItemScore = GetTextBoxHandle(m_WindowName $ ".txtItemScore");
	txtItemScore.SetText("0");
	txtPVP = GetTextBoxHandle(m_WindowName $ ".txtPVP");
	txtSociality = GetTextBoxHandle(m_WindowName $ ".txtSociality");
	txtBonusVote = GetTextBoxHandle(m_WindowName $ ".txtRemainSulffrage");
	txtRaidPoint = GetTextBoxHandle(m_WindowName $ ".txtRaidPoint");
	texHero = GetTextureHandle(m_WindowName $ ".texHero");
	texPledgeCrest = GetTextureHandle(m_WindowName $ ".texPledgeCrest");
	txtAttrAttackType = GetTextBoxHandle(m_WindowName $ ".txtAttrAttackType");
	txtAttrAttackValue = GetTextBoxHandle(m_WindowName $ ".txtAttrAttackValue");
	txtAttrDefenseValFire = GetTextBoxHandle(m_WindowName $ ".txtAttrDefenseValFire");
	txtAttrDefenseValWater = GetTextBoxHandle(m_WindowName $ ".txtAttrDefenseValWater");
	txtAttrDefenseValWind = GetTextBoxHandle(m_WindowName $ ".txtAttrDefenseValWind");
	txtAttrDefenseValEarth = GetTextBoxHandle(m_WindowName $ ".txtAttrDefenseValEarth");
	txtAttrDefenseValHoly = GetTextBoxHandle(m_WindowName $ ".txtAttrDefenseValHoly");
	txtAttrDefenseValUnholy = GetTextBoxHandle(m_WindowName $ ".txtAttrDefenseValUnholy");
	VitalityTex = GetTextureHandle(m_WindowName $ ".LifeForceTex");
	txtLUC = GetTextBoxHandle(m_WindowName $ ".txtLUC");
	txtCHA = GetTextBoxHandle(m_WindowName $ ".txtCHA");
	texVP = GetStatusBarHandle(m_WindowName $ ".texVP");//ldw //branch121212
	AbilityOpen = GetButtonHandle(m_WindowName $ ".AbilityOpen");//ldw
	txtHeadSTR = GetTextBoxHandle("DetailStatusWnd.txtHeadSTR");
	txtHeadDEX = GetTextBoxHandle("DetailStatusWnd.txtHeadDEX");
	txtHeadCON = GetTextBoxHandle("DetailStatusWnd.txtHeadCON");
	txtHeadINT = GetTextBoxHandle("DetailStatusWnd.txtHeadINT");
	txtHeadWIT = GetTextBoxHandle("DetailStatusWnd.txtHeadWIT");
	txtHeadMEN = GetTextBoxHandle("DetailStatusWnd.txtHeadMEN");
	txtHeadLUC = GetTextBoxHandle("DetailStatusWnd.txtHeadLUC");
	txtHeadCHA = GetTextBoxHandle("DetailStatusWnd.txtHeadCHA");
	txtHeadSTR.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3366), 154));
	txtHeadDEX.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3368), 154));
	txtHeadCON.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3370), 154));
	txtHeadINT.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3367), 154));
	txtHeadWIT.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3369), 154));
	txtHeadMEN.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3371), 154));
	txtHeadLUC.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3372), 154));
	txtHeadCHA.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3373), 154));
	APActive = GetAnimTextureHandle("DetailStatusWnd.APActive");
	isDualClass = false;
}

//branch
// F2P ?��??�сЅ�? ?�°·�? °?�ј�? - gorillazin
function UpdateVp(int vitality)//ldw ?�цБ�?
{
	// End:0x3C
	if(vitality < 2205 && vitality > 0)
	{
		// ?�Цґ�? 140000 ?��? °ж?��? 1806 ?�ОЕ�? ?�єЕИГўї�? ?�«±�??��? ?�шѕ�? vp°?? ?�шѕ�? ?�ёАОґЩґ�? ?�цБ�? ?�»їлА�? ?�§З�? ?�№?��? ?�іё�? , statusbarWnd, lobbyMenuWnd ?�Ўµ�? °°?��? ?�іё�? µ?�ѕъА�? ldw 2011.02.23
		texVP.SetPoint(2205, MaxVitality);
	}
	else
	{
		texVP.SetPoint(vitality, MaxVitality);
	}
}

// ?��? function?��? ?�Кї�? ?�шґ�? ?�Оє�? ?�Цј�? ?�іё�?
//end of branch
function OnEnterState(name a_CurrentStateName)
{
	HandleUpdateUserInfo();
}

function OnShow()
{
	HandleUpdateUserInfo();
}

function OnEvent(int Event_ID, string param)
{
	if(Event_ID == EV_UpdateUserInfo)
	{
		HandleUpdateUserInfo();		
	}
	else if(Event_ID == EV_UpdateHennaInfo)
	{
		HandleUpdateHennaInfo(param);
	}
	else if(Event_ID == EV_UpdateMyHP)
	{
		HandleUpdateStatusGauge(param, 0);
	}
	else if(Event_ID == EV_UpdateMyMaxHP)
	{
		HandleUpdateStatusGauge(param, 0);
	}
	else if(Event_ID == EV_UpdateMyMP)
	{
		HandleUpdateStatusGauge(param,1);
	}
	else if(Event_ID == EV_UpdateMyMaxMP)
	{
		HandleUpdateStatusGauge(param,1);
	}
	else if(Event_ID == EV_UpdateMyCP)
	{
		HandleUpdateStatusGauge(param,2);
	}
	else if(Event_ID == EV_UpdateMyMaxCP)
	{
		HandleUpdateStatusGauge(param,2);
	}
	else if(Event_ID == EV_ToggleDetailStatusWnd)
	{
		HandleToggle();
	}
	else if(Event_ID == EV_VitalityPointInfo)	// ?�°·ВБ¤єёѕчµҐАМЖ�?
	{
		HandleVitalityPointInfo(param);
	}
	else if(Event_ID == EV_NotifySubjob)
	{
		//Debug("-------------------------------");
		//Debug("EV_NotifySubjob:" @ param);
		// updateSubjobLastEvent = Event_ID;
		updateSubjobInfo(param, Event_ID);	

	}
	else if(Event_ID == EV_CreatedSubjob)
	{		
		updateSubjobInfo(param, Event_ID);
		
		// ?�Ж·№?��? ?��? °ж?��? ?�Ъµ�? ?��?±в ±в?�ЙА�? »з?��? ?�ПБ�? ?�КґВґ�?.
		if(Me.IsShowWindow() == false && !getInstanceUIData().getIsArenaServer())
		{
			Me.ShowWindow();
			Me.SetFocus();
		}
		ExecuteEvent(EV_NPCDialogWndHide);
	}
	else if(Event_ID == EV_ChangedSubjob)
	{
		// updateSubjobLastEvent = Event_ID;
		//Debug("EV_ChangedSubjob" @ param);
		updateSubjobInfo(param, Event_ID);
		ExecuteEvent(EV_NPCDialogWndHide);
	}

	else if	(Event_ID == EV_DialogOK)
	{
		HandleDialogOK();
	}
	else if	(Event_ID == EV_DialogCancel)
	{
		Me.EnableWindow();
		// Me.EnableWindow();
	}
	//~ else if(Event_ID == EV_ShowWindow)
	//~ {
		//~ if(param == DetailStatusWnd)
		//~ {
			//~ ToggleOpenCharInfoWnd();
		//~ }
	//~ }

	//branch
	// F2P ?��??�сЅ�? ?�°·�? °?�ј�? - gorillazin
	else if(Event_ID == EV_VitalityEffectInfo)
	{
		HandleVitalityEffectInfo(param);
	}
	else if(Event_ID == EV_TutorialShowID)
	{
		HandleItemScore(param);
	}
	//
	//end of branch
}

function hideAlchemyWindow(string winName) 
{	
	if(class'UIAPI_WINDOW'.static.IsShowWindow(winName))
	{
		class'UIAPI_WINDOW'.static.HideWindow(winName);
	}	
}

/**
 *  ?�ЦГКµйѕоїАґВј�??�кА�?, µа?�уµоАЗБ¤єёё¦№Ю?�Ж±в·ПЗСґ�?.
 **/
function updateSubjobInfo(string param, int Event_ID)
{	
	local int count, i;

	local UserInfo myUserInfo;

	local bool bFlag;

	local SubjobInfo tempSubjobInfo;

	// ?�ѕБ�?
	//local int  race;

	isDualClass = false;

	hideAlchemyWindow("AlchemyItemConversionWnd");			
	hideAlchemyWindow("AlchemyMixCubeWnd");

	// saveUpdateSubjobInfoParam = param;

	//GetMyUserInfo(myUserInfo);
	GetPlayerInfo(myUserInfo);


//	debug("?�цА�? ?��?·?�Ѕ�? : " @ GetClassType(myUserInfo.nSubClass));
//	debug("?�цАзАьБч»уЕ�?: " @ GetClassTransferDegree(myUserInfo.nSubClass));

	// ?�ШґзБчѕчјцё¦ё�??�П№Ю?�Вґ�?.
	ParseInt(param, "Count"  , count);
	
	// ?�цАзБ�??�ОЕ�?·?�ЅєѕЖАМµ�?
	ParseInt(param, "currentSubjobClassID", CurrentSubjobClassID);

//	debug("?�цАзАьБч»уЕ�?->: " @ GetClassTransferDegree(CurrentSubjobClassID));
	//Debug("?�цАзclassID ->: " @ CurrentSubjobClassID);
	// »и?��?
	if(subjobInfoArray.Length > 0)
	{
		subjobInfoArray.Remove(0, subjobInfoArray.Length);
	}

	bFlag = false;
		

	
	ParseInt(param, "Race", race);

//	debug("?�ѕБ�? race:" @ Race);
	//debug("?�ѕБ·АМё�? :" @ getRaceString(Race));

	// ?��??�кАвё�??�єЖ�??�¦№Ю?�Вґ�?.(0?��??��?, ?��??�кµаѕу°�?1,2,3(?�Цґ�?))
	for(i = 0; i < count; i++)
	{
		subjobInfoArray.Insert(subjobInfoArray.Length, 1);

		ParseInt(param, "SubjobClassID_" $ i, subjobInfoArray[i].ClassID);
		ParseInt(param, "SubjobID_"      $ i, subjobInfoArray[i].Id);
		ParseInt(param, "SubjobLevel_"   $ i, subjobInfoArray[i].Level);
		ParseInt(param, "SubjobType_"    $ i, subjobInfoArray[i].Type);

		// Debug("subjobInfoArray[i].ClassID" @ subjobInfoArray[i].ClassID);
		// Debug("subjobInfoArray[i].Id" @ subjobInfoArray[i].Id);
		// Debug("subjobInfoArray[i].Level" @ subjobInfoArray[i].Level);
		// Debug("subjobInfoArray[i].Type" @ subjobInfoArray[i].Type);

		// µа?��? ?��?·?�Ѕє°�? ?�ПіЄ¶уµ�? ?�ЦґЩё�?..
		if(subjobInfoArray[i].Type == 1) 
		{ 
			isDualClass = true; 
		//	Debug("µа?�уА�? ?�Цґ�?! ");
		}
	}
	for(i = 0; i < count; i++)
	{
		if(CurrentSubjobClassID == subjobInfoArray[i].ClassID)
		{
//			Debug("°°?��? subjobInfoArray[i].ClassID" @ subjobInfoArray[i].ClassID);
			//			currentSubjobClassNum = i;

			// ?��?·?�±іГ�?
			tempSubjobInfo = subjobInfoArray[i];
			subjobInfoArray[i] = subjobInfoArray[0];
			subjobInfoArray[0] = tempSubjobInfo;

			currentSubjobClassNum = 0;
			break;
		}
	}

//	debug("subjobInfoArray ::::: " @ subjobInfoArray.Length);

	// ?��??��? ?��?·?�Ѕє°�? ?�ЦґЩё�?.. ?��?�Ж°µйА�? ?�ёАМµµ·�? ?�К±вИ�?
	if(count > 0) initClassChangeButton(true);
	else initClassChangeButton(false);

	// ?�чѕчБ¤єёѕчµҐАМЖ�?
	//  1,2,3 ±о?�цµйѕоїГјцАЦА�?. ?�цАзДіёЇЕ�?1 + ?��??��??(µа?��?) 3°??= ?��?4°??
	for(i = 1; i < count; i++)
	{
		if(i < count)
		{
			// Debug("-------------" @ i);
//			Debug("subjobInfoArray[i].ClassID" @ subjobInfoArray[i].ClassID);
			//---- 3?�ѕ№?�Ж°ѕчµҐАМЖ�?-----
			// Debug("?��?�Ж°№и?�ЎАЫАє°�?" @ subjobInfoArray[i].ClassID);

			// ?�МАьАЗ»уЕВїН°°Ає°НАМїґґЩё�?.. ±?�єэАМґВАМЖСЖ�?
			if(beforeSubjobInfo.ClassID == subjobInfoArray[i].ClassID) bFlag = true;
			else bFlag = false;

			// Debug("?��??��?, ?��??�О°Л»�? subjobInfoArray[i].Type : " @subjobInfoArray[i].Type);
			// debug("GetClassTransferDegree(myUserInfo.nSubClass)"@ GetClassTransferDegree(myUserInfo.nSubClass));
			// debug("?�ѕБ�? race:" @ myUserInfo.Race);
			// debug("?�ѕБ·АМё�? :" @ getRaceString(myUserInfo.Race));

			// ?��??��?:0, µа?��?:1 ?��??��?:2

			// ?��??��?: ?�»»�?
			if(subjobInfoArray[i].Type == 2)
			{
				if(GetClassTransferDegree(subjobInfoArray[i].ClassID) >= 1)
					setclasstexture(i, "l2ui_ct1.playerstatuswnd_ClassBgSub_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[i].ClassID $ "_Small", bFlag);
				else 
					setclasstexture(i, "l2ui_ct1.playerstatuswnd_ClassBgSub_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(race) $ "_Small", bFlag);
			}			
			// µа?��? : ?�Д¶�?
			else if(subjobInfoArray[i].Type == 1)
			{	
				if(GetClassTransferDegree(subjobInfoArray[i].ClassID) >= 1)
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[i].ClassID $ "_Small", bFlag);
				else
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(race) $ "_Small", bFlag);
			}
			//?��??��? :»?�°�?
			else if(subjobInfoArray[i].Type == 0)
			{
				if(GetClassTransferDegree(subjobInfoArray[i].ClassID) >= 1)
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[i].ClassID $ "_Small", bFlag);
				else
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(race) $ "_Small", bFlag);
			}

			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).EnableWindow();
			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).ShowWindow();

			// Debug("?��?�Ж�? " @ m_WindowName $ ".ClassFrameBtn" $ i);
			// GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i + 1).ShowWindow();

			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).SetTexture("L2UI_ct1.PlayerStatusWnd_ClassFrameBtn",
																			 "L2UI_ct1.PlayerStatusWnd_ClassFrameBtn_down",
																			 "L2UI_ct1.PlayerStatusWnd_ClassFrameBtn_over");

			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).SetTooltipCustomType(subjobButtonToolTips(i));
			GetTextureHandle(m_WindowName $ ".ClassSlotBlank" $ i).HideWindow();
		}
		//?�Жё�? ?�ЧАМѕ�? ?�ѕБ·А�? ?�Жґ�? °ж?�мїЎё�? ?�ёї�? ?�Шґ�?.
		else if(race != 6) 
		{
			
			// Debug("------?�Ъ№°?��? -------" @ i);
			// ?��?�Ж°єсИ°ј�?, ?�Ъ№°?�иєёАМµµ·ПјјЖ�?
			setClassTexture(i, "", "", false);
			// GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i + 1).HideWindow();
			
			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).DisableWindow();
			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).SetTexture("L2UI_ct1.Misc_DF_Blank",
																			  "L2UI_ct1.Misc_DF_Blank",
																			  "L2UI_ct1.Misc_DF_Blank");

			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).SetTooltipCustomType(subjobButtonToolTips(-1));			

			GetTextureHandle(m_WindowName $ ".ClassSlotBlank" $ i).ShowWindow();
		}
	}

	// ---- ?�«Е�?·?�ЅєАМ№?�БцѕчµҐАМЖ�?-----
	// 2?�чАьБчАМ»уАМ¶уё�?..

	// 3?��? ?�ьБ�? ?�М»уЗ�? ?�іёЇЕН°�? ?�Ц°�? , ?��??��? ?��? 1°?? ?�М»�? ?�ЦґЩё�?, ?�цБ¤З�? ?��?·?�Ѕ�? ?�ЖАМД�??��? ?�ыї�?
	//if(GetClassTransferDegree(myUserInfo.nSubClass) > 1 && count > 1)

	// debug("myUserInfo.nSubClass >: " @ myUserInfo.nSubClass);
	// debug("GetClassTransferDegree(myUserInfo.nSubClass) >: " @ GetClassTransferDegree(myUserInfo.nSubClass));

	// ?��??��?:0, µа?��?:1 ?��??��?:2
	// 4?��? ?�ьБ�? µ?? ?�іёЇЕН¶уё�?..
//	Debug("subjobInfoArray[currentSubjobClassNum].ClassID" @ subjobInfoArray[currentSubjobClassNum].ClassID);
	if(GetClassTransferDegree(subjobInfoArray[currentSubjobClassNum].ClassID) >= 1)
	{
		// ±?�ГјµИ»уЕВ¶уёйАМЖСЖ�??�в·�?
		if(EV_ChangedSubjob == Event_ID) bFlag = true;
		else bFlag = false;

		// debug("?��??�кѕЦµ�?:" @ subjobInfoArray[currentSubjobClassNum].Type);
		// ?��??�кёйГ»»�?
		if(subjobInfoArray[currentSubjobClassNum].Type == 2)
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big", 
							   "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[currentSubjobClassNum].ClassID $ "_Big", bFlag);
			
		}
		// µа?��?,?��??�ОАє»Ў°�?0: ?��??��?, 1 µа?��?
		else if(subjobInfoArray[currentSubjobClassNum].Type == 1)
		{			
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Big", 
							   "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[currentSubjobClassNum].ClassID $ "_Big", bFlag);
			
		}
		else if(subjobInfoArray[currentSubjobClassNum].Type == 0)
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Big", 
							   "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[currentSubjobClassNum].ClassID $ "_Big", bFlag);

		}

	}
	else
	{
		// ?��??�кёйГ»»�?
		if(subjobInfoArray[currentSubjobClassNum].Type == 2)
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big", 
							   "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(race) $ "_Big", false);
			
		}
		// µа?��?,?��??�ОАє»Ў°�?0: ?��??��?, 1 µа?��?
		else if(subjobInfoArray[currentSubjobClassNum].Type == 1)
		{			
				
			// ?��??�кАвА�? ?�ИЗ�?.. 1?��? ?�ьБчµ�? ?�ИЗ�? ?�ЇАъА�? ?�ЖАМД�?
			//initClassChangeButton(false);
			// °?�БѕБ·є°ЅЙєјАМ№?�Б�?
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Big", 
							   "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(race) $ "_Big", false);		
		}
		else if(subjobInfoArray[currentSubjobClassNum].Type == 0)
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Big", 
							   "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(race) $ "_Big", false);		

		}
		
		// UserInfo(
		// ?�цБ¤ЗШѕ�??�Фrace
		// Debug("?�ѕБ·є�?---::" @ myUserInfo.race);
		
		//GetRaceTicketString(int Blessed);
	}

	beforeSubjobInfo = subjobInfoArray[currentSubjobClassNum];

	// Type : 0 ?��??��?, 1 µа?��?. 2 ?��??��?
	// debug("myUserInfo.Class : " @ GetClassRoleName(classID));
	
		//native final function string GetClassRoleName(classID) ;
	// CurrentSubjobClassID=3 Count=3 SubjobID_1=1 SubjobClassID_1=117 SubjobLevel_1=55 SubjobType_1=0 SubjobID_2=1 SubjobClassID_2=73 SubjobLevel_2=55 SubjobType_2=1 SubjobID_3=1 SubjobClassID_3=131 SubjobLevel_3=55 SubjobType_3=2
	// CurrentSubjobClassID=3 Count=3 SubjobID_1=1 SubjobClassID_1=117 SubjobLevel_1=55 SubjobType_1=1 SubjobID_2=1 SubjobClassID_2=73 SubjobLevel_2=55 SubjobType_2=1 SubjobID_3=1 SubjobClassID_3=131 SubjobLevel_3=55 SubjobType_3=1 
	// CurrentSubjobClassID=3 Count=1 SubjobID_1=1 SubjobClassID_1=134 SubjobLevel_1=55 SubjobType_1=1
}

/** ?�ЩАМѕу·О±Ч№Ъ?�єOK ?�¬ёЇЅ�?*/
function HandleDialogOK()
{
	local int dialogValue;
	local ItemInfo infItem;

	
	if(DialogIsMine())
	{
		if(DialogGetID() == DIALOG_DetailStatusWnd)
		{
			dialogValue = DialogGetReservedInt();
			switch(dialogValue)
			{
				// subjobInfoArray[dialogValue].Type  // 0?��??��?, 1µа?��?, 2?��??��?
				case 0 : 
				case 1 : 
				case 2 : 
				case 3 :
						ExecuteEvent(EV_NPCDialogWndHide);
						// Debug("subjobInfoArray[dialogValue].Type  "  @ subjobInfoArray[dialogValue].Type);
						// ?��??��?, µа?�уАМ¶уё�?..
						if(subjobInfoArray[dialogValue].Type == 0)
						{
							// ?�єЕ�? ?��?�ИЈА�? 
							infItem.ID.ClassID = 1566;

							//infItem.ID.ServerID = 1566;
							// ?��??�ОЕ�?·?�Ѕє·ОєЇ°�?
							// Debug("?��??��? ?�єЕі»зї�?" @ infItem.ID.ClassID);
							UseSkill(infItem.ID, int(EShortCutItemType.SCIT_SKILL));
							// ExecuteCommand("//use_skill 1566 1");
						}
						else
						{
							// µа?��? ?�М¶уё�?.. ?�іё�?
							if(subjobInfoArray[dialogValue].Type == 1) 
							{
								// ?�цА�? ?�шА�?
								// empty
							}

							// 1567, 1568, 1569 ?�шј�?µ?�·�?.. ?��??�кЅЅ·�?1,2,3 ?�Ї°�?
							//infItem.ID.ClassID = 1567 +(dialogValue - 1);
							infItem.ID.ClassID = 1567;
							//infItem.ID.ServerID = 1568 +(dialogValue - 1);

							// Debug("?�єЕі»зї�?" @ infItem.ID.ClassID);
							UseSkill(infItem.ID, int(EShortCutItemType.SCIT_SKILL));
							// ExecuteCommand("//use_skill " $ String(infItem.ID.ClassID) $ " 1");
						}
			}

			// ?�Ї°жЅєЕі»зї�?
			Me.EnableWindow();
		}
	}
}

/**
 * ?�ЩАМѕу·О±Ч№Ъ?��?(?��??�кЕ�?·?�Ѕє·ОєЇЅЕЗТБц№°?�оєёґВґЩАМѕу·О±�?)
 * 0..1..2 
 **/
function askDialogBox(int currentClickSubjobNum)
{
	local WindowHandle m_dialogWnd;	
	m_dialogWnd = GetWindowHandle("DialogBox");
	if(!m_dialogWnd.IsShowWindow())
	{
		// ?�цАзЕ�?·?�ЅєїНЕ¬ёЇЗСј�??�кЕ�?·?�Ѕє°Ў°°БцѕКґЩё�?.. ?�ЇЅЕА»№°?�оє»ґ�?.
		if(subjobInfoArray[0].ClassID != subjobInfoArray[currentClickSubjobNum].ClassID)
		{
			DialogSetID(DIALOG_DetailStatusWnd);

			DialogSetReservedInt(currentClickSubjobNum);

			// ?��??�ОЕ�?·?�Ѕ�?, µТ?�кёµ°�?, ?��??�кјТїпЕЧАМД�?, ·?�єЇ°жЗПЅГ°ЪЅАґП±�??   ?�М·±Ѕ�?
			Me.DisableWindow();
			DialogSetCancelD(DIALOG_DetailStatusWnd);
			DialogShow(DialogModalType_Modalless, DialogType_Warning, 
						MakeFullSystemMsg(GetSystemMessage(3280), 
										   "<" $ GetClassType(subjobInfoArray[0].ClassID) $ "> " $ getSubjobTypeStr(subjobInfoArray[0].Type) $ "", 
										   "<" $ GetClassType(subjobInfoArray[currentClickSubjobNum].ClassID) $ "> "$ getSubjobTypeStr(subjobInfoArray[currentClickSubjobNum].Type) $ ""),
										   string(Self));
		}
	}
}


/***
 *  ?�цАзј�??�кАвЅєЖ�??�µА»ё�??�П№Ю?�Вґ�?.
 **/
function string getSubjobTypeStr(int nType)
{	
	local string tempStr;
	
	// 0 ?��??��?, 1 µа?��?(?�цАзґВё�??�ОАё·ОГіё�?-µа?�уАМ¶уґВїлѕоґВѕЖБч»зїлѕИЗ�?) , 2 ?��??��?
	switch(nType)
	{
		case 0 : tempStr = GetSystemString(2340); break; // ?��??�ОЕ�?·?�Ѕ�?
		case 1 : tempStr = GetSystemString(2737); break; // µа?�уЕ�?·?�Ѕ�?
		case 2 : tempStr = GetSystemString(2339); break; // ?��??�кЕ�?·?�Ѕ�?
	}

	return tempStr;
}

/**
 * OnClickButton
 **/
function OnClickButton(string strID)
{
	debug("strID : " $ strID);
	switch(strID)
	{
		case "AbilityOpen":
			// ?�чї�? ?�Мµ�? ?��? 
			if(IsPlayerOnWorldRaidServer()) 
			{
				 getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
				 return;
			}
			if(class'UIAPI_WINDOW'.static.IsShowWindow("AbilityUIWnd"))
			{
				class'UIAPI_WINDOW'.static.HideWindow("AbilityUIWnd");
			}
			else
			{
				toggleWindow("AbilityUIWnd", true, true);
			}
			break;
		case "StatBonusInfo_BTN":
			if(class'UIAPI_WINDOW'.static.IsShowWindow("StatBonusWndClassic"))
			{
				class'UIAPI_WINDOW'.static.HideWindow("StatBonusWndClassic");
			}
			else
			{
				class'UIAPI_WINDOW'.static.ShowWindow("StatBonusWndClassic");
				class'UIAPI_WINDOW'.static.SetFocus("StatBonusWndClassic");
			}
			break;
		case "ClassFrameBtn1" : 
		if(GetButtonHandle(m_WindowName $ ".ClassFrameBtn1").IsEnableWindow() && subjobInfoArray.Length > 1) 
			{ 
				ExecuteEvent(EV_NPCDialogWndHide); effectAniTexture(1); askDialogBox(1); 
			} 
			break;
	}

	 
}

/**
 *  ?��?�Ж°ѕЦґПАМЖСЖ�?(1 ~ 3 ?��?�№?�Ж°Иї°�?) 
 **/
function effectAniTexture(int targetType)
{
	GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall" $ targetType).SetTexture("l2ui_ct1.PlayerStatusWnd_ClassChangeLightSmall_00");
	GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall" $ targetType).ShowWindow();
	GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall" $ targetType).SetLoopCount(1);
	GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall" $ targetType).Stop();
	GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall" $ targetType).Play();
}

/**
 * setClassTexture 
 * 
 * ?��?·?�ЅєєЇ°жЅ�?, ?�ШЅєГД±іГ�?, ?�ѕБ·є°ё¶Е©ЕШЅєГ�?, ?�юВ¦°Её�??�ВИї°ъєёї©БЩ°НАОБ�?..
 **/
function setClassTexture(int targetType, string bgTexture, string markTextureStr, bool effectFlag)
{
	if(targetType == 0)
	{

		// ?�«ё�??�ОЕ�?·?�Ѕ�?(?�цАзЕ�?·?�Ѕ�?)

		// ?��и°ж
		ClassBgMain_Big.SetTexture(bgTexture);
		// debug("bgTexture" @ bgTexture);

		// ?�¶Е©єЇ°�?
		//debug("markTextureStr : " @ markTextureStr);
		ClassMarkBig.SetTexture(markTextureStr);
		// ClassMarkBig.HideWindow();

		// ±?�єэАМґВИї°ъєёї©БЦ±�?
		if(effectFlag == true)
		{			
			GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").SetTexture("l2ui_ct1.PlayerStatusWnd_ClassChangeLightBig_00");
			GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").ShowWindow();
			GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").SetLoopCount(1);
			GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").Stop();
			GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").Play();
		}
	}
	else
	{
		// ?��и°ж
		GetTextureHandle(m_WindowName $ ".ClassBgMain_Small" $ targetType).SetTexture(bgTexture);
		
		// GetTextureHandle(m_WindowName $ ".ClassBgMain_Small" $ targetType).SetAlpha(255);
		// Debug("?��и°жbgTexture " @ bgTexture);

		// ?�¶Е©єЇ°�?
		GetTextureHandle(m_WindowName $ ".ClassMarkSmall" $ targetType).SetTexture(markTextureStr);
		GetTextureHandle(m_WindowName $ ".ClassMarkSmall" $ targetType).ShowWindow();
		

		// ±?�єэАМґВИї°ъєёї©БЦ±�?
		//GetTextureHandle(m_WindowName $ ".ClassChangeLightSmall" $ targetType).SetTexture("");		

		if(effectFlag == true)
		{			
			effectAniTexture(targetType);
		}
	}
}


function HandleToggle()
{
	if(getInstanceUIData().getIsClassicServer()) return;
	if(m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.HideWindow();
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
		m_hOwnerWnd.SetFocus();
	}
}

//~ function ToggleOpenCharInfoWnd()
//~ {
	//~ if(DetailStatusWnd.IsShowWindow() == true)
	//~ {
		//~ HideWindow("DetailStatusWnd");
		//~ PlaySound("InterfaceSound.charstat_close_01");
	//~ }
	//~ else
	//~ {
		//~ ShowWindowWithFocus("DetailStatusWnd");
		//~ PlaySound("InterfaceSound.charstat_open_01");			
	//~ }
//~ }

//°Ф?�МБцёёѕчµҐАМЖ�?
function HandleUpdateStatusGauge(string param, int Type)
{
	local int ServerID;
	
	if(m_hOwnerWnd.IsShowWindow())	// lpislhy
	{
		ParseInt(param, "ServerID", ServerID);
		if(m_UserID == ServerID)
			HandleUpdateUserGauge(Type);
	}
}

//?�Г·№?�МѕоАЗ№®?�зБ¤єёГіё�?
function HandleUpdateHennaInfo(string param)
{
	ParseInt(param, "HennaID", m_HennaInfo.HennaID);
	ParseInt(param, "ClassID", m_HennaInfo.ClassID);
	ParseInt(param, "Num", m_HennaInfo.Num);
	ParseInt(param, "Fee", m_HennaInfo.Fee);
	ParseInt(param, "CanUse", m_HennaInfo.CanUse);
	ParseInt(param, "INTnow", m_HennaInfo.INTnow);
	ParseInt(param, "INTchange", m_HennaInfo.INTchange);
	ParseInt(param, "STRnow", m_HennaInfo.STRnow);
	ParseInt(param, "STRchange", m_HennaInfo.STRchange);
	ParseInt(param, "CONnow", m_HennaInfo.CONnow);
	ParseInt(param, "CONchange", m_HennaInfo.CONchange);
	ParseInt(param, "MENnow", m_HennaInfo.MENnow);
	ParseInt(param, "MENchange", m_HennaInfo.MENchange);
	ParseInt(param, "DEXnow", m_HennaInfo.DEXnow);
	ParseInt(param, "DEXchange", m_HennaInfo.DEXchange);
	ParseInt(param, "WITnow", m_HennaInfo.WITnow);
	ParseInt(param, "WITchange", m_HennaInfo.WITchange);

	//?�Е±ФЅєЕ�? ?�«ё�??�єё�? ·°?��?
	ParseInt(param, "LUCnow", m_HennaInfo.LUCnow);
	ParseInt(param, "LUCchange", m_HennaInfo.LUCchange);

	ParseInt(param, "CHAnow", m_HennaInfo.CHAnow);
	ParseInt(param, "CHAchange", m_HennaInfo.CHAchange);
}

function bool GetMyUserInfo(out UserInfo a_MyUserInfo)
{
	return GetPlayerInfo(a_MyUserInfo);
}

function String GetMovingSpeed(UserInfo a_UserInfo)
{
	local float MovingSpeed;
	local EMoveType	MoveType;
	local EEnvType	EnvType;

	// Moving Speed
	MoveType			= class'UIDATA_PLAYER'.static.GetPlayerMoveType();
	EnvType				= class'UIDATA_PLAYER'.static.GetPlayerEnvironment();

	// debug("MovingSpeed : STEP 1" $a_UserInfo.fNonAttackSpeedModifier);
	if(MoveType == MVT_FAST)
	{
		MovingSpeed = float(a_UserInfo.nGroundMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
		// debug("MovingSpeed : STEP 2" $a_UserInfo.nGroundMaxSpeed);
		switch(EnvType)
		{
		case ET_UNDERWATER:
			MovingSpeed = float(a_UserInfo.nWaterMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
			// debug("MovingSpeed : STEP 3"$a_UserInfo.nWaterMaxSpeed);
			break;
		case ET_AIR:
			MovingSpeed = float(a_UserInfo.nAirMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
			// debug("MovingSpeed : STEP 4" $a_UserInfo.nAirMaxSpeed $"  " $a_UserInfo.fNonAttackSpeedModifier);
			break;
		}
	}
	else if(MoveType == MVT_SLOW)
	{
		MovingSpeed = float(a_UserInfo.nGroundMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
		// debug("MovingSpeed : STEP 5");
		switch(EnvType)
		{
		case ET_UNDERWATER:
			MovingSpeed = float(a_UserInfo.nWaterMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
			// debug("MovingSpeed : STEP 6" $a_UserInfo.nWaterMinSpeed);
			break;
		case ET_AIR:
			MovingSpeed = float(a_UserInfo.nAirMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
			// debug("MovingSpeed : STEP 7" $a_UserInfo.nAirMinSpeed);
			break;
		}
	}
	//debug("MovingSpeed : STEP 8 : " $ MovingSpeed);
	return String(int(MovingSpeed));
}

function float GetMyExpRate()
{
	return class'UIDATA_PLAYER'.static.GetPlayerEXPRate() * 100.0f;
}

//?�Г·№?�Мѕо°ФАМБцБ¤єёГіё�?
function HandleUpdateUserGauge(int Type)
{
	local int CurValue;
	local int MaxValue;
	local int vitality;
	local UserInfo Info;

	
	if(GetMyUserInfo(Info))
	{
		vitality = Info.nVitality;
		m_UserID = Info.nID;
		
		switch(Type)
		{
		case 0:
				CurValue = Info.nCurHP;
				MaxValue = Info.nMaxHP;
				UpdateHPBar(CurValue, MaxValue);
				// End:0xE9
				break;
		case 1:
				CurValue = Info.nCurMP;
				MaxValue = Info.nMaxMP;
				UpdateMPBar(CurValue, MaxValue);
				// End:0xE9
				break;
		case 2:
				CurValue = Info.nCurCP;
				MaxValue = Info.nMaxCP;
				UpdateCPBar(CurValue, MaxValue);
				// End:0xE9
				break;
				UpdateVp(vitality);
		}
	}
}

//?�Г·№?�МѕоБ¤єёГіё�?
function HandleUpdateUserInfo()
{
	// End:0x18
	if(m_hOwnerWnd.IsShowWindow())
	{
		UpdateInterface();
	}
}


function setSubjobSlot(bool isEr)
{

}

function UpdateInterface()
{
	local Rect rectWnd;
	local int Width1;
	local int Height1;
	local int Width2;
	local int Height2;
	
	local string	Name;
	local string	NickName;
	local color	NameColor;
	local color	NickNameColor;
	local int		SubClassID;
	local string	ClassName;
	local string	UserRank;
	local int		HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;
	local int		CP;
	local int		MaxCP;
	local INT64		SP;
	local int		Level;
	//local float		fExpRate;
	
	local int		PledgeID;
	local string	PledgeName;
	local texture	PledgeCrestTexture;
	local bool		bPledgeCrestTexture;
	local color	PledgeNameColor;
	
	local string	HeroTexture;
	local bool		bHero;
	local int		nNobless;
	
	local int		nSTR;
	local int		nDEX;
	local int		nCON;
	local int		nINT;
	local int		nWIT;
	local int		nMEN;
	local string	strTmp;
	//?�Е±ФЅєЕ�? ?�«ё�??�єё�? ·°?��?
	local int		nLUC;
	local int		nCHA;
	
	local int		PhysicalAttack;
	local int		PhysicalDefense;
	local int		HitRate;
	local int		CriticalRate;
	local int		PhysicalAttackSpeed;
	local int		MagicalAttack;
	local int		MagicDefense;
	local int		PhysicalAvoid;
	local String	MovingSpeed;
	local int		MagicCastingSpeed;

	local int		CriminalRate;
	local int		iNameColorRate;
	local string	strCriminalRate;
	local int		DualCount;
	local int		PKCount;
	local int		PvPPoint;
	
	local int		VoteCount;
	local int		BonusCount;
	local int		NegativeVoteCount;
	local int		Notoriety;

	local int       RaidPoint;

	// ?�УјєјцД�?
	local int AttrAttackType;
	local int AttrAttackValue;
	local int AttrDefenseValFire;
	local int AttrDefenseValWater;
	local int AttrDefenseValWind;
	local int AttrDefenseValEarth;
	local int AttrDefenseValHoly;
	local int AttrDefenseValUnholy;
	local string AttrAttackTypeTxt;

	local int nMagicAvoid, nMagicHitRate, nMagicCriticalRate;
	
	//?�ЇЅЕ°ь·ГµҐАМЕ�?
	//local int nTransformID;
	local bool m_bPawnChanged;

	local UserInfo	info;
	
	//?�°·�?
	local int vitality;
	
	//?�К±вИ�?
	texPledgeCrest.SetTexture("");
	
	rectWnd = m_hOwnerWnd.GetRect();

	// End:0x4B6
	if(GetMyUserInfo(Info))
	{	
		StatesByUserInfoUpdate();
		// ClassChangeLightBig.SetTexture("");
		// ClassChangeLightSmall1.SetTexture("");
		// ClassChangeLightSmall2.SetTexture("");
		//ClassChangeLightSmall3.SetTexture(""); 
		// Debug("info race"  @ info.race);
		
		// Debug("nVitalityt" @ info.nVitality) ;
		// Debug("nDyeChargeAmount" @ info.nDyeChargeAmount) ;
		m_UserID = info.nID;
		Name = info.Name;
		NickName = info.strNickName;
		SubClassID = info.nSubClass;
		ClassName = GetClassType(SubClassID);
		SP = info.nSP;
		Level = info.nLevel;
		UserRank = GetUserRankString(info.nUserRank);
		HP = info.nCurHP;
		MaxHP = info.nMaxHP;
		MP = info.nCurMP;
		MaxMP = info.nMaxMP;
		CP = info.nCurCP;
		MaxCP = info.nMaxCP;
		PledgeID = info.nClanID;
		bHero = info.bHero;
		nNobless = info.nNobless;
		NickNameColor = info.NicknameColor;
		nSTR = info.nStr;
		nDEX = info.nDex;
		nCON = info.nCon;
		nINT = info.nInt;
		nWIT = info.nWit;
		nMEN = info.nMen;
		//?�Е±ФЅєЕ�? ?�«ё�??�єё�?, ·°?��?
		nLUC = info.nLuc;
		nCHA = info.nCha;
		PhysicalAttack = info.nPhysicalAttack;
		PhysicalDefense = info.nPhysicalDefense;
		HitRate = info.nHitRate;
		CriticalRate = info.nCriticalRate;
		if(IsUseSkillCastingSpeedStat())
		{
			PhysicalAttackSpeed = info.nPhysicalSkillCastingSpeed;			
		}
		else
		{
			PhysicalAttackSpeed = info.nPhysicalAttackSpeed;
		}
		MagicalAttack = info.nMagicalAttack;
		MagicDefense = info.nMagicDefense;
		PhysicalAvoid = info.nPhysicalAvoid;
		MagicCastingSpeed = info.nMagicCastingSpeed;
		MovingSpeed = GetMovingSpeed(info);
		CriminalRate = info.nCriminalRate;
		DualCount = info.nDualCount;
		PKCount = info.nPKCount;
		PvPPoint = info.PvPPoint;
		VoteCount = info.nVoteCount;
		BonusCount = info.nBonusCount;
		NegativeVoteCount = info.nNegativeVoteCount;
		Notoriety = info.nNotoriety;
		RaidPoint = info.RaidPoint;
		vitality = info.nVitality;
		//?�УјєБ¤єёјјЖ�?
		AttrAttackType = info.AttrAttackType;
		//debug("?�УјєЕёАФ№?�И�?" @ info.AttrAttackType);
		AttrAttackValue= info.AttrAttackValue;
		AttrDefenseValFire = info.AttrDefenseValFire;
		AttrDefenseValWater = info.AttrDefenseValWater;
		AttrDefenseValWind = info.AttrDefenseValWind;
		AttrDefenseValEarth = info.AttrDefenseValEarth;
		AttrDefenseValHoly = info.AttrDefenseValHoly;
		AttrDefenseValUnholy = info.AttrDefenseValUnholy;
		//?�ЇЅЕБ¤єёјјЖ�?
		//nTransformID = info.nTransformID;
		m_bPawnChanged = info.m_bPawnChanged;
		// ?�Е±�? ?��?°??  2010.10.11 CT3 ?�єЕ�? ?�¤є�? °?�ј�?
		nMagicAvoid = info.nMagicAvoid; 
		nMagicHitRate = info.nMagicHitRate; 
		nMagicCriticalRate = info.nMagicCriticalRate; 
		// debug("nMagicAvoid:"@ nMagicAvoid);
		// debug("nMagicHitRate:"@ nMagicHitRate);
		// debug("nMagicCriticalRate:"@ nMagicCriticalRate);

		//~ debug("?�УјєБ¤є�?: " @ AttrAttackType);
		//~ debug("?�УјєБ¤є�?: " @  AttrAttackValue);
		//~ debug("?�УјєБ¤є�?: " @  AttrDefenseValFire);
		//~ debug("?�УјєБ¤є�?: " @  AttrDefenseValWater);
		//~ debug("?�УјєБ¤є�?: " @  AttrDefenseValWind);
		//~ debug("?�УјєБ¤є�?: " @ AttrDefenseValEarth);
		//~ debug("?�УјєБ¤є�?: " @ AttrDefenseValHoly);
		//~ debug("?�УјєБ¤є�?: " @ AttrDefenseValUnholy);
		
		switch(AttrAttackType)
		{
			case -2:
				AttrAttackTypeTxt = GetSystemString(27);
				break;
			case 0:
				AttrAttackTypeTxt = GetSystemString(1630);
				break;
			case 1:
				AttrAttackTypeTxt = GetSystemString(1631);
				break;
			case 2:
				AttrAttackTypeTxt = GetSystemString(1632);
				break;
			case 3:
				AttrAttackTypeTxt = GetSystemString(1633);
				break;
			case 4:
				AttrAttackTypeTxt = GetSystemString(1634);
				break;
			case 5:
				AttrAttackTypeTxt = GetSystemString(1635);
				break;
		}
		
		//debug("?�°·Вµ�?:" @ Vitality);
		UpdateVp(vitality);
		
		//?�ЖёЈЕЧАМѕ�? ?�ѕБ·А�? °ж?��? 
		setSubjobSlot(info.Race == 6) ;

	}
	
	// Change by JoeyPark
	if(CriminalRate > 0)
	{
		iNameColorRate = Min((100 +(CriminalRate / 100)), 255);
		NameColor.R = 0;
		NameColor.G = iNameColorRate;
		NameColor.B = 0;
		NameColor.A = 255;
		
		if(CriminalRate>999999)
			strCriminalRate = string(999999) $ "(+)";	
		else			
			strCriminalRate = string(CriminalRate);		
	}
	else if(CriminalRate < 0)
	{
		iNameColorRate = Min((100 +(-CriminalRate / 100)), 255);		
		NameColor.R = iNameColorRate;
		NameColor.G = 0;
		NameColor.B = 0;
		NameColor.A = 255;

		if(CriminalRate<-999999)
			strCriminalRate = string(-999999) $ "(+)";	
		else			
			strCriminalRate = string(CriminalRate);	
		
	}
	else // if CriminalRate == 0
	{
		NameColor.R = 230;
		NameColor.G = 230;
		NameColor.B = 230;
		NameColor.A = 255;
		strCriminalRate = "" $ CriminalRate;
	}
	// End Change	
	
	if(Len(NickName)>0)
	{
		GetTextSizeDefault(Name, Width1, Height1);
		GetTextSizeDefault(NickName, Width2, Height2);
		if(Width1 + Width2 > 220)
		{
			if(Width1 > 109)
			{
				Name = Left(Name, 8);
				GetTextSizeDefault(Name, Width1, Height1);
			}
			if(Width2 > 109)
			{
				NickName = Left(NickName, 8);
				GetTextSizeDefault(NickName, Width2, Height2);
			}
		}
		txtName1.SetFormatString(NickName);
		txtName1.SetTextColor(NickNameColor);
		txtName2.SetText(Name);
		txtName2.SetTextColor(NameColor);
		txtName2.MoveTo(rectWnd.nX + 15 + Width2 + 47, rectWnd.nY +41);
			//~ debug("?��?..:rectWnd: " @ rectWnd.nY);
	}
	else
	{
		txtName1.SetText(Name);
		txtName1.SetTextColor(NameColor);
		txtName2.SetText("");
	}
	
	if(getInstanceL2Util().getIsPrologueGrowType(SubClassID)) 
	{
		if(GetLanguage() == LANG_Korean)
		{
			txtLvName.SetText("?��?");
		}
		else 
		{
			txtLvName.SetText("--");
		}
	}
	else txtLvName.SetText("" $ Level);

	txtClassName.SetText(ClassName);
	// Debug("=====:: ClassName " @ ClassName);
	// ?�цА�? °?�ј�? ?�Ыѕ�? ¶?�АМєкїЎј�??��? ?�цА§°�? ?�ёАМБ�? ?�КґВґ�?.
	//txtRank.SetText(UserRank);
	txtSP.SetText(string(SP));
	
	//?�чё�?
	if(PledgeID>0)
	{
		//?�ШЅєГ�?
		bPledgeCrestTexture = class'UIDATA_CLAN'.static.GetCrestTexture(PledgeID, PledgeCrestTexture);
		PledgeName = class'UIDATA_CLAN'.static.GetName(PledgeID);
		PledgeNameColor.R = 176;
		PledgeNameColor.G = 155;
		PledgeNameColor.B = 121;
		PledgeNameColor.A = 255;
	}
	else
	{
		PledgeName = GetSystemString(431);
		PledgeNameColor.R = 230;
		PledgeNameColor.G = 230;
		PledgeNameColor.B = 230;
		PledgeNameColor.A = 255;
	}
	txtPledge.SetText(PledgeName);
	txtPledge.SetTextColor(PledgeNameColor);

	// ?�чёНАМ№?�Бц°ЎАЦґЩё�?..
	if(bPledgeCrestTexture)
	{
		texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);
		txtPledge.MoveTo(rectWnd.nX + 110 , rectWnd.nY + 57);
		//?�цБ�?
	}
	else
	{
		// ?�чёНАМ№?�Бц°ЎѕшґЩё�?..
		txtPledge.MoveTo(rectWnd.nX + 86, rectWnd.nY + 57);
	}
	
	//?�µї�?,?�лєн·№?��?
		
	if(bHero)
	{
		HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_heroicon";
	}
	//?�лєн·№?��? ver EP2.0 6.25 ?��?�БЇї�? ?��?°??
	else if(nNobless == 1)
	{
		HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_nobleicon";
	}
	//?�ЖіКЅ�? ver EP2.0 6.25 ?��?�БЇї�? ?��?°??
	else if(nNobless == 2)
	{
		//Debug("?�лєн·№?��? 2 ·?�µ�? ?��?");
		HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_nobleicon2";
	}
	//Debug(HeroTexture @ nNobless);
	texHero.SetTexture(HeroTexture);
	
	//»?�јјБ¤є�?
	if(m_HennaInfo.STRchange > 0)
	{
		strTmp = nSTR $ "(+" $ m_HennaInfo.STRchange $ ")";
	}
	else if(m_HennaInfo.STRchange < 0)
	{
		strTmp = nSTR $ "(" $ m_HennaInfo.STRchange $ ")";
	}
	else
	{
		strTmp = string(nSTR);
	}
	txtSTR.SetText(strTmp);
	
	if(m_HennaInfo.DEXchange > 0)
	{
		strTmp = nDEX $ "(+" $ m_HennaInfo.DEXchange $ ")";
	}
	else if(m_HennaInfo.DEXchange < 0)
	{
		strTmp = nDEX $ "(" $ m_HennaInfo.DEXchange $ ")";
	}
	else
	{
		strTmp = string(nDEX);
	}
	txtDEX.SetText(strTmp);
	
	if(m_HennaInfo.CONchange > 0)
	{
		strTmp = nCON $ "(+" $ m_HennaInfo.CONchange $ ")";
	}
	else if(m_HennaInfo.CONchange < 0)
	{
		strTmp = nCON $ "(" $ m_HennaInfo.CONchange $ ")";
	}
	else
	{
		strTmp = string(nCON);
	}
	txtCON.SetText(strTmp);
	
	if(m_HennaInfo.INTchange > 0)
	{
		strTmp = nINT $ "(+" $ m_HennaInfo.INTchange $ ")";
	}
	else if(m_HennaInfo.INTchange < 0)
	{
		strTmp = nINT $ "(" $ m_HennaInfo.INTchange $ ")";
	}
	else
	{
		strTmp = string(nINT);
	}
	txtINT.SetText(strTmp);
	
	if(m_HennaInfo.WITchange > 0)
	{
		strTmp = nWIT $ "(+" $ m_HennaInfo.WITchange $ ")";
	}
	else if(m_HennaInfo.WITchange < 0)
	{
		strTmp = nWIT $ "(" $ m_HennaInfo.WITchange $ ")";
	}
	else
	{
		strTmp = string(nWIT);
	}
	txtWIT.SetText(strTmp);
	
	if(m_HennaInfo.MENchange > 0)
	{
		strTmp = nMEN $ "(+" $ m_HennaInfo.MENchange $ ")";
	}
	else if(m_HennaInfo.MENchange < 0)
	{
		strTmp = nMEN $ "(" $ m_HennaInfo.MENchange $ ")";
	}
	else
	{
		strTmp = string(nMEN);
	}
	txtMEN.SetText(strTmp);

	//?�Е±ФЅєЕ�? ·°?��?
	if(m_HennaInfo.LUCchange > 0)
	{
		strTmp = nLUC $ "(+" $ m_HennaInfo.LUCchange $ ")";
	}
	else if(m_HennaInfo.LUCchange < 0)
	{
		strTmp = nLUC $ "(" $ m_HennaInfo.LUCchange $ ")";
	}
	else
	{
		strTmp = string(nLUC);
	}
	txtLUC.SetText(strTmp);

	//?�Е±ФЅєЕ�? ?�«ё�??�єё�?
	if(m_HennaInfo.CHAchange > 0)
	{
		strTmp = nCHA $ "(+" $ m_HennaInfo.CHAchange $ ")";
	}
	else if(m_HennaInfo.CHAchange < 0)
	{
		strTmp = nCHA $ "(" $ m_HennaInfo.CHAchange $ ")";
	}
	else
	{
		strTmp = string(nCHA);
	}
	txtCHA.SetText(strTmp);


	nMagicAvoid = info.nMagicAvoid;
	nMagicHitRate = info.nMagicHitRate; 
	nMagicCriticalRate = info.nMagicCriticalRate; 

	GetTextBoxHandle(m_WindowName $ ".txtMagicAvoid").SetText(String(nMagicAvoid));
	GetTextBoxHandle(m_WindowName $ ".txtMagicHit").SetText(String(nMagicHitRate));
	GetTextBoxHandle(m_WindowName $ ".txtMagicCritical").SetText(String(nMagicCriticalRate));

	// debug("nMagicAvoid:"@ nMagicAvoid);
	// debug("nMagicHitRate:"@ nMagicHitRate);
	// debug("nMagicCriticalRate:"@ nMagicCriticalRate);

	
	
	txtPhysicalAttack.SetText(string(PhysicalAttack));
	txtPhysicalDefense.SetText(string(PhysicalDefense));
	txtHitRate.SetText(string(HitRate));
	txtCriticalRate.SetText(string(CriticalRate));
	txtPhysicalAttackSpeed.SetText(string(PhysicalAttackSpeed));
	txtMagicalAttack.SetText(string(MagicalAttack));
	txtMagicDefense.SetText(string(MagicDefense));
	txtPhysicalAvoid.SetText(string(PhysicalAvoid));
	txtMovingSpeed.SetText(MovingSpeed);
	txtMagicCastingSpeed.SetText(string(MagicCastingSpeed));
	
	txtCriminalRate.SetText(strCriminalRate);
	txtPVP.SetText(string(PvPPoint));
	txtSociality.SetText(DualCount $ " / " $ PKCount);
	txtBonusVote.SetText(string(BonusCount) $ " / " $ string(VoteCount));
	txtRaidPoint.SetText(string(RaidPoint));
	
	UpdateHPBar(HP, MaxHP);
	UpdateMPBar(MP, MaxMP);
	UpdateCPBar(CP, MaxCP);
	UpdateEXPBar(info.fExpPercentRate);
	//UpdateEXPBar(int(fExpRate), 100);
	
	// ?�УјєµҐАМЕНјјЖ�?
	txtAttrAttackType.SetText(""$ AttrAttackTypeTxt);
	txtAttrAttackValue.SetText(""$ AttrAttackValue);
	txtAttrDefenseValFire.SetText(""$ AttrDefenseValFire);
	txtAttrDefenseValWater.SetText(""$ AttrDefenseValWater); 
	txtAttrDefenseValWind.SetText(""$ AttrDefenseValWind);
	txtAttrDefenseValEarth.SetText(""$ AttrDefenseValEarth);
	txtAttrDefenseValHoly.SetText(""$ AttrDefenseValHoly);
	txtAttrDefenseValUnholy.SetText(""$ AttrDefenseValUnholy);
	
	// ?�ЇЅЕБ¤єёјјЖ�?
	if(m_bPawnChanged) 
	{
		//~ iGender = info.nSex;
		//~ TransformedID = class'UIDATA_TRANSFORM'.static.GetNpcID(nTransformID, iGender);
		//~ debug("?�ЇЅЕѕЖАМµ�?"@ TransformedID);
		//~ TransformedName = class'UIDATA_NPC'.static.GetNPCName(TransformedID);
		//~ txtLvName.SetText(Level $ " " $ TransformedName);
		//~ RunTransformManage();
	}
	else
	{
		RunUnTransformManage();
	}

	//6.25 ?�ЖіКЅ�? ?��?°??
	//GD4.0 05 85?�М»�? 1·?�ѕ�? ?��? AP »з?��? °?�ґ�?
	
	handleAbilityBtn(Level >= 85, info.nRemainAbilityPoint);
}


//HP?��Щ°»?��?
function UpdateHPBar(int Value, int MaxValue)
{
	texHP.SetPoint(Value, MaxValue);
}

//MP?��Щ°»?��?
function UpdateMPBar(int Value, int MaxValue)
{
	texMP.SetPoint(Value, MaxValue);
}

//EXP?��Щ°»?��?
function UpdateEXPBar(float ExpPercent)
{
	texEXP.SetPointExpPercentRate(ExpPercent);
}

//CP?��Щ°»?��?
function UpdateCPBar(int Value, int MaxValue)
{
	texCP.SetPoint(Value, MaxValue);
}

function ToggleOpenCharInfoWnd()
{
	switch(m_hOwnerWnd.IsShowWindow())
	{
		case true:
			m_hOwnerWnd.HideWindow();
			PlaySound("InterfaceSound.charstat_close_01");
			break;
		case false:
			m_hOwnerWnd.ShowWindow();
			m_hOwnerWnd.SetFocus();
			PlaySound("InterfaceSound.charstat_open_01");
			break;
	}
}

function HandleVitalityPointInfo(string param) // ?�°·ВјцДЎёёѕчµҐАМЖ�?
{
	local int nVitality;

	ParseInt(param, "Vitality", nVitality);

	UpdateVp(nVitality); // ?�°·В°ФАМБцё¦ѕчµҐАМЖ�??�Сґ�?.
}

//branch
// F2P ?��??�сЅ�? ?�°·�? °?�ј�? - gorillazin
function HandleVitalityEffectInfo(string param)
{
	local CustomTooltip t;
	local int nVitality, nVitalityBonus, nVitalityItemRestoreCount, nVitalityExtraBonus;
	local string sBonusString, sExtraBonusString;

	ParseInt(param, "vitalityPoint", nVitality);
	ParseInt(param, "vitalityBonus", nVitalityBonus);
	ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
	// maxRestoreCount ?��? ?�лЗ�? ?�»їлА�? ?��? UI?�Ўј�??��? »з?�лЗПБ�? ?�КЅАґПґ�?.

	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);
	util.ToopTipInsertText(GetSystemString(2494), true, false);

	// ?�°·�? BM ?��?°?? 2015.05
	ParseInt(param, "vitalityExtraBonus", nVitalityExtraBonus);

	sBonusString = nVitalityBonus $ "%";
	// End:0xFF
	if(nVitalityExtraBonus > 0)
	{
		sExtraBonusString = "(+" $ nVitalityExtraBonus $ "%)";
	}

	//Debug("?�°·�? °?�ј�? HandleVitalityEffectInfo "  @ nVitality @ nVitalityBonus @ nVitalityItemRestoreCount @ nVitalityItemMaxRestoreCount @ nVitalityExtraBonus);

	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);

	// ?�°·�? ?�ёіКЅ�?:
	util.ToopTipInsertText(GetSystemString(2494), true, false);
	// ?�°·ВА�? 0 ?��? °ж?��? ?��?�Аыї�? ?�ҐЅ�?
	// End:0x199
	if(nVitality <= 0)
	{
		util.ToopTipInsertText(GetSystemString(2496), true, false, util.ETooltipTextType.COLOR_GRAY);
		util.ToopTipInsertText(GetSystemMessage(13112), true, true);		
	}
	// ?�°·�? 0 ?�М»уА�? °ж?��? 
	else
	{
		util.ToopTipInsertText(sBonusString, true, false);
		util.ToopTipInsertText(sExtraBonusString, true, false, util.ETooltipTextType.COLOR_YELLOW03);
		util.ToopTipInsertText(" " $ GetSystemString(2495) $ ". ", true, false);
		util.ToopTipInsertText(GetSystemMessage(13111),true,true);
	}
	texVP.SetTooltipCustomType(util.getCustomToolTip());//bluesun ?�їЅєЕНё¶АМБ�? ?�шЖ�?
}
//
//end of branch

function StatesByUserInfoUpdate()
{
	StatBonusWndClassic(GetScript("StatBonusWndClassic")).ResetData();
}

function RunTransformManage()
{
	
}

function RunUnTransformManage()
{
	
}

/**
 * ?�їЅєЕТЕшЖ�?(?��??�кАвЕ�?·?�ЅєєЇИЇ№?�Ж°їЎ»зї�?)
 **/
function CustomTooltip subjobButtonToolTips(int TargetType)
{
	local CustomTooltip m_Tooltip;
	
	local int subjobSlotStringNum;
	// Debug("targetType tool " @ targetType);

	// ?��??�кЕ�?·?�Ѕєё¦µо·ПЗПґВАЪё�??�ФґПґ�?.. °°?�єѕИі»ёЗЖ�?..
	if(TargetType == -1)
	{
		m_Tooltip.DrawList.Length = 1;
		m_Tooltip.MinimumWidth = 210;//160->183px ·?? ?�цБ¤µ�?
		m_Tooltip.DrawList[0].eType = DIT_TEXT;
		m_Tooltip.DrawList[0].t_color.R = 220;
		m_Tooltip.DrawList[0].t_color.G = 220;
		m_Tooltip.DrawList[0].t_color.B = 220;
		m_Tooltip.DrawList[0].t_color.A = 255;

		//?�ЖёЈЕЧАМѕоА�? °ж?��? ?�шЖ�? ?�ШЅєЖ�?°?? ?�Щё�?
		subjobSlotStringNum = 2342;

		if(Race == 6)
		{
			subjobSlotStringNum = 3315;
		}

		m_Tooltip.DrawList[0].t_strText = GetSystemString(subjobSlotStringNum);
	}
	else
	{
		m_Tooltip.DrawList.Length = 5;
		m_Tooltip.MinimumWidth = 214;
		m_Tooltip.DrawList[0].eType = DIT_TEXT;
		m_Tooltip.DrawList[0].t_color.R = 200;
		m_Tooltip.DrawList[0].t_color.G = 200;
		m_Tooltip.DrawList[0].t_color.B = 200;
		m_Tooltip.DrawList[0].t_color.A = 255;
		m_Tooltip.DrawList[0].t_strText = "Lv";

		m_Tooltip.DrawList[1].eType = DIT_TEXT;
		m_Tooltip.DrawList[1].t_color.R = 175;
		m_Tooltip.DrawList[1].t_color.G = 152;
		m_Tooltip.DrawList[1].t_color.B = 120;
		m_Tooltip.DrawList[1].t_color.A = 255;
		m_Tooltip.DrawList[1].t_strText = subjobInfoArray[TargetType].Level @ GetClassType(subjobInfoArray[TargetType].ClassID);

    	m_Tooltip.DrawList[2].eType = DIT_TEXT;
		m_Tooltip.DrawList[2].t_color.R = 200;
		m_Tooltip.DrawList[2].t_color.G = 200;
		m_Tooltip.DrawList[2].t_color.B = 200;
		m_Tooltip.DrawList[2].t_color.A = 255;

		// Debug("GetClassType(subjobInfoArray[targetType].ClassID)" @ subjobInfoArray[targetType].ClassID);
		// Debug("GetClassType(subjobInfoArray[targetType] ?�Мё�?:)" @ GetClassType(subjobInfoArray[targetType].ClassID));

		// ?��??��?:0, µа?��?:1 ?��??��?:2
		// ?��??�кЕ�?·?�Ѕє¶уё�?..
		if(subjobInfoArray[TargetType].Type == 2)
		{
			// "?��??��?" 
			m_Tooltip.DrawList[2].t_strText = "(" $ GetSystemString(2341) $ ")";			
		}
		else if(subjobInfoArray[targetType].Type == 1)
		{
			// "µа?��?" 
			m_Tooltip.DrawList[2].t_strText = "(" $ GetSystemString(2739) $ ")";			
		}
		else
		{
			m_Tooltip.DrawList[2].t_strText = "(" $ GetSystemString(2738) $ ")";
		}	
		//m_Tooltip.DrawList[2].t_bDrawOneLine = true;
		//m_Tooltip.DrawList[2].bLineBreak = true;

		m_Tooltip.DrawList[3].eType = DIT_TEXT;

		// m_Tooltip.DrawList[3].nOffSetY = 2;
		m_Tooltip.DrawList[3].bLineBreak = true;
		m_Tooltip.DrawList[3].t_color.R = 220;
		m_Tooltip.DrawList[3].t_color.G = 220;
		m_Tooltip.DrawList[3].t_color.B = 220;
		m_Tooltip.DrawList[3].t_color.A = 255;

		m_Tooltip.DrawList[3].t_strText = GetSystemString(2343);
		// ?��??�к¶уё�?..
		// 80·?��?�§АМИДё�??�ОЕ�?·?�Ѕє·ОјєАеЗТјцАЦЅАґПґ�?. ?��??�јБцєёї©Б�?
		m_Tooltip.DrawList[4].eType = DIT_TEXT;

		// µа?��? ?��?·?�Ѕє°�? ?�ПіЄµ�? ?�шґ�? °ж?��?
		// 80·?��?��? ?�МИ�? ?��??�ОЕ�?·?�Ѕє·�? ?�єАеЗ�? ?��? ?�ЦЅАґПґ�? 
		// ¶?�ґ�? ?�шЖБА�? ?�ёї©БШґ�?. 
		if(subjobInfoArray[TargetType].Type == 2 && isDualClass == false)
		{
			m_Tooltip.DrawList[4].bLineBreak = true;
			m_Tooltip.DrawList[4].t_color.R = 110;
			m_Tooltip.DrawList[4].t_color.G = 140;
			m_Tooltip.DrawList[4].t_color.B = 170;
			m_Tooltip.DrawList[4].t_color.A = 255;
			m_Tooltip.DrawList[4].t_strText = GetSystemString(2344);
		}
		else
		{
			m_Tooltip.DrawList[4].t_strText = "";
		}
	}

	return m_Tooltip;
}

function int getMainLevel()
{
	local int i;
	local UserInfo Info;

	if(subjobInfoArray.Length > 1)
	{
		for(i = 0;i < subjobInfoArray.Length;i++)
		{
			if(subjobInfoArray[i].Type == 0)
			{
				if(CurrentSubjobClassID == subjobInfoArray[i].ClassID)
				{
					GetPlayerInfo(Info);
					return Info.nLevel;
				}
				else
					return subjobInfoArray[i].Level;
			}
		}
	}
	else
	{
		GetPlayerInfo(Info);
		return Info.nLevel;
	}
	Debug("Error: DetailStatusWnd getMainLevel?�� 값이 ?��못되?��?��?��?��. -1 ");
	return -1;
}

function int getMainClassID()
{
	local int i;
	local UserInfo Info;

	if(subjobInfoArray.Length > 1)
	{
		for(i = 0;i < subjobInfoArray.Length;i++)
		{
			if(subjobInfoArray[i].Type == 0)
				return subjobInfoArray[i].ClassID;
		}
	}
	else
	{
		GetPlayerInfo(Info);
		return Info.nSubClass;
	}
	Debug("Error: DetailStatusWnd getMainClassID?�� 값이 ?��못되?��?��?��?��. -1 ");
	return -1;
}

private function HandleItemScore(string event)
{
	local int nScore;

	ParseInt(event, "ID", nScore);
	if (nScore <= 0)
	{
		txtItemScore.SetText(string(nScore * -1));
	}
}

/**
 * ?�©µµїмESC ?�°·Оґ�?±в?�іё�?
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}



defaultproperties
{
     m_WindowName="DetailStatusWnd"
}
