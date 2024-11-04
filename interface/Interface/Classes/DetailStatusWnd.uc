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

var L2Util util;//bluesun ?•ÑˆĞ–Ğ? ?‘Â¦Ñ•Ğ? ?—Ğ?



//------------------------------
//    ?•Â?Â·?Ğ…Ñ”Ñ”Ğ‡Â°Ğ¶Ñ‘Ğ??Ğ?
//------------------------------
// Â±?„Ñ”ÑĞĞœÒ‘Ğ’Ğ—Ñ†ĞĞ·Ğ•Â?Â·?Ğ…Ñ?, ?ĞœĞ–ĞµĞ–Â?
var AnimTextureHandle ClassChangeLightBig;

// ?—Ñ†ĞĞ·Ğ•Â?Â·?Ğ…Ñ”Ğ•Ğ¨Ğ…Ñ”Ğ“Ğ?
// ?‘Ğ??Ğ?: l2ui_ct1.PlayerStatusWnd_ClassBgMain_Big(Â»?Â°Â?)
// ?˜Â??”Ğ?: l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big (?“Â»Â»Ñ?)
var TextureHandle ClassBgMain_Big;

// ?•Â?Â·?Ğ…Ñ”Ñ‘Â¶Ğ•Â©Ğ•Ğ¨Ğ…Ñ”Ğ“Ğ?
var TextureHandle ClassMarkBig;

//------------------------------
//     ?•Â?Â·?Ğ…Ñ”Ñ”Ğ‡Â°Ğ¶â„–?†Ğ–Â?
//------------------------------
var AnimTextureHandle ClassChangeLightSmall1;

// ?•Â?Â·?Ğ…Ñ”â„–Ğ¸Â°Ğ¶?•Ğ¨Ğ…Ñ”Ğ“Ğ?1,2,3
var TextureHandle ClassBgMain_Small1;

// ?•Â?Â·?Ğ…Ñ”Ñ‘Â¶Ğ•Â?
var TextureHandle ClassMarkSmall1;

// ÂµĞ°?•Ñ?, ?˜Â??”ĞºĞ•Â?Â·?Ğ…Ñ”Ñ”Ğ‡Â°Ğ¶â„–?†Ğ–Â?
var ButtonHandle ClassFrameBtn1;

// ?˜Â·ĞĞ²Ğ‘Â¤Ñ”Ñ?
var array<SubjobInfo> subjobInfoArray;
var SubjobInfo beforeSubjobInfo;

// ?—Ñ†ĞĞ·Ğ˜Â°Ñ˜Ñ”Ğ˜Â?Âµ?—Ñ•Ğ¾ĞĞ¦Ò‘Ğ’Ğ•Â?Â·?Ğ…Ñ?
var int currentSubjobClassNum;

// ?—Ñ†ĞĞ? ÂµĞ°?•Ñ? ?•Â?Â·?Ğ…Ñ? ?˜Â??”ĞºĞĞ²ĞĞ? ?Ğ¦Ò‘Ğ’Â°Ğ??
var bool    isDualClass;

// ?Ğ£Ğ…Ğ“Â·Ğ? ÂµĞ°?•Ñ? ?•Â?Â·?Ğ…Ñ? , ?˜Â??”ĞºĞĞ? ?‘Â¤Ñ”Ñ‘Ñ‘Â? ?ÑŠĞĞµĞ—Ğ¨Ñ˜Â? ?“ÑĞĞ? ?—Â??‘Â±Â¶Â? ?‘Â¶Ò‘Ğ? Â°Â»?…Ğ? ?—Ğ¢Â¶Â? Â»Ğ·?—Ğ»Ğ—Ğ¡Ò‘Ğ?.
// var string  saveUpdateSubjobInfoParam;

// ?‘Â¶Ğ‘Ñ†Ñ‘Â·ĞÑ‘Â·Ğ? ?„–Ğ®?Ñ? ?˜Â??”ĞºĞĞ?, ÂµĞ°?•Ñ? Â°?ŒÂ·Ğ? ?ĞœÑ”ÒĞ–Â? Â°?? ?ÑŠĞĞ?
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
	//LevelÂ°?ŠExp?‘Ğ’UserInfo?–Ğ Ğ•Â¶ĞÑ‘Â·ĞĞ“Ñ–Ñ‘Â??—Ğ¡Ò‘Ğ?.
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_UpdateHennaInfo);
	
	//JYLee, ?Ğ—â„–?œÑ•ÑˆÒ‘Ğ? ?—Ğ¤Ñ˜Ñ†Ğ˜ĞˆĞ“Ğ²ĞÂ? ?‘Â·Â±Ğ? ?Â§Ğ—Ğ? status ?‘Â¤Ñ”Ñ‘Ñ‘Â? ?–Â? ?‘Â¤Ñ”Ñ‘Ñ—Ğ? ?‘Ğ©Ñ‘Ò? ?”Ñ–Ñ‘Ğ‡Ğ•ĞĞĞ? ?‘Â¤Ñ”Ñ‘Â·Ğ? ?”Ğ Ñ‘Â?
	RegisterEvent(EV_UpdateMyHP);
	RegisterEvent(EV_UpdateMyMaxHP);
	RegisterEvent(EV_UpdateMyMP);
	RegisterEvent(EV_UpdateMyMaxMP);
	RegisterEvent(EV_UpdateMyCP);
	RegisterEvent(EV_UpdateMyMaxCP);

	// ?˜Â°Â·Ğ’Ñ•Ñ‡ÂµÒĞĞœĞ–Â?
	RegisterEvent(EV_VitalityPointInfo);	

	// ?‘Ğ©ĞĞœÑ•ÑƒÂ·ĞÂ±Ğ?(?˜Â??”ĞºĞ•Â?Â·?Ğ…Ñ”Ñ”Ğ‡Â°Ğ¶Ğ˜Â??ĞÑ—Ğ?)
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);

	//ÂµĞ°?•ÑƒĞ•Â?Â·?Ğ…Ñ”â„–Ğ§?˜Â??”ĞºĞ•Â?Â·?Ğ…Ñ”Ñ‘Â??…Ñ”Ğ–Â?
	RegisterEvent(EV_NotifySubjob);
	// CurrentSubjobClassID=3 Count=3 SubjobID_1 SubjobClassID_1=44 SubjobLevel_1=55 SubjobType_1
	RegisterEvent(EV_CreatedSubjob);
	RegisterEvent(EV_ChangedSubjob);

// CurrentSubjobClassID=117 Count=3 SubjobID_1=1 SubjobClassID_1=3 SubjobLevel_1=55 SubjobType_1=0 SubjobID_2=1 SubjobClassID_2=73 SubjobLevel_2=55 SubjobType_2=1 SubjobID_3=1 SubjobClassID_3=131 SubjobLevel_3=55 SubjobType_3=2
	// ÂµĞ°?•ÑƒĞ•Â?Â·?Ğ…Ñ”â„–Ğ§?˜Â??”ĞºĞ•Â?Â·?Ğ…Ñ”Ñ‘Â??…Ñ”Ğ–Â?
	// const EV_NotifySubjob = 5310;
	// const EV_CreatedSubjob = 5311;
	// const EV_ChangedSubjob = 5312;
	// Â±Ğ¶ÂµĞµÂ±Ğ§Â·?ˆÂµĞµÑ‘Â¶Ğ…Ñ”Ğ•ĞĞ—Ğ¡Ğ•Ğ§Â°ĞÑ˜Â?
	// ?ĞŸĞ˜Ñ‘Ñ˜Ñ”Ğ”Ñ‰Ğ…Ñ”Ğ–Â?234 1
	// ?ĞŸĞ˜Ñ‘Ñ˜Ñ”Ğ”Ñ‰Ğ…Ñ”Ğ–Â?235 1
	// ?˜Â??”ĞºĞ“Ğ?Â°??

	//branch
	// F2P ?˜Â??”ÑĞ…Ñ? ?˜Â°Â·Ğ? Â°?–Ñ˜Â? - gorillazin
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

	// ?•Â?Â·?Ğ…Ñ”Ñ”Ğ‡Â°Ğ¶â„–?†Ğ–Â°Ñ”ÑĞ˜Â°Ñ˜Ñ”Ğ˜Â?
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

	T.MinimumWidth = 125; // 125 Â·?? ?˜Ñ†Ğ‘Â¤Ğ—Ğ¨Ñ•Ğ??—Ğ?

	util = L2Util(GetScript("L2Util"));//bluesun ?”Ñ—Ğ…Ñ”Ğ•ĞÑ‘Â¶ĞĞœĞ‘Ğ? ?•ÑˆĞ–Ğ? 
	util.setCustomTooltip(T);//bluesun ?”Ñ—Ğ…Ñ”Ğ•ĞÑ‘Â¶ĞĞœĞ‘Ğ? ?•ÑˆĞ–Ğ?	
	
	

//	Debug("handleAbilityBtnTooltip1");
	//?„–?†Ğ–Â? ?˜Â°Ñ˜Ñ?		
	//?•Ğ¾Ñ”Ñ„Ñ‘Â??–Ñ? ?–Ñ‡ĞĞœĞ–Â? : ?‘Ğ? ?–Ñ‡ĞĞĞ–Â? Â¶?ƒÒ‘Ğ? ?‘Ğ??…Ğ“Ğ‘Ñ? 		
	tmpTooltipString = MakeFullSystemMsg(GetSystemMessage(4194), String(nCanUseAP));
	util.ToopTipInsertText(tmpTooltipString , false, false);
	AbilityOpen.SetTooltipCustomType(util.getCustomToolTip());//bluesun ?”Ñ—Ğ…Ñ”Ğ•ĞÑ‘Â¶ĞĞœĞ‘Ğ? ?•ÑˆĞ–Ğ?
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
	
	util = L2Util(GetScript("L2Util"));//bluesun ?”Ñ—Ğ…Ñ”Ğ•ĞÑ‘Â¶ĞĞœĞ‘Ğ? ?•ÑˆĞ–Ğ? 
	util.setCustomTooltip(T);//bluesun ?”Ñ—Ğ…Ñ”Ğ•ĞÑ‘Â¶ĞĞœĞ‘Ğ? ?•ÑˆĞ–Ğ?

	APActive.HideWindow();

	if(enable)
	{
		//?„–?†Ğ–Â? ?˜Â°Ñ˜Ñ?
		GetTextureHandle(m_WindowName $ ".abilityIconSlotBlank").HideWindow();
		AbilityOpen.ShowWindow();
		//?•Ğ¾Ñ”Ñ„Ñ‘Â??–Ñ? ?–Ñ‡ĞĞœĞ–Â? : ?‘Ğ? ?–Ñ‡ĞĞĞ–Â? Â¶?ƒÒ‘Ğ? ?‘Ğ??…Ğ“Ğ‘Ñ?
		tmpTooltipString = MakeFullSystemMsg(GetSystemMessage(4194),string(nCanUseAP));		

		//Debug(tmpTooltipString @ nCanUseAP) ;
		if(nCanUseAP > 0) 
		{
			APActive.ShowWindow();
			APActive.SetLoopCount(999);
			APActive.Play();
		}
		
//Debug("?•Ğ¾Ñ”Ñ„Ñ‘Â??–Ñ? ?–Ñ‡ĞĞĞ–Â? Â»Ğ·?—Ğ? Â°?Ò‘Ğ? ?—Ğ? ?‘Â¶Â°Ğ—Ñ—Ğ? ÂµÂµ?‘Ğ? ?—Ğ??Ğ? Â±?„Ñ”ÑĞĞ? Â°??");
		util.ToopTipInsertText(tmpTooltipString , false, false);
		AbilityOpen.SetTooltipCustomType(util.getCustomToolTip());
	}
	else 
	{	
		AbilityOpen.HideWindow();
		GetTextureHandle(m_WindowName $ ".abilityIconSlotBlank").ShowWindow();
		//99Â·?„–?”Â? ?ĞœÂ»Ñ?, ?–Ğ»Ñ”Ğ½Â·â„–?…Ñ”ĞĞ? Â¶Â§..............?„–?„–?„–?„– ?—ĞŸĞ…Ğ? ?˜Ñ? ?Ğ¦Ğ…ĞÒ‘ĞŸÒ‘Ğ?.... Â¶?ƒÒ‘Ğ? ?‘Ğ??…Ğ“Ğ‘Ñ? 
		tmpTooltipString = GetSystemMessage(4195);
		util.ToopTipInsertText(tmpTooltipString , false, false);
		GetTextureHandle(m_WindowName $ ".abilityIconSlotBlank").SetTooltipCustomType(util.getCustomToolTip());
	}
}

/**
 * ?•Â?Â·?Ğ…Ñ”Ñ”Ğ‡Â°Ğ¶â„–?†Ğ–Â°Ñ”ÑĞ˜Â°Ñ˜Ñ”Ğ˜Â?
 **/ 
function initClassChangeButton(bool visibleFlag)
{
	local int i;

	// ?„–?†Ğ–Â°Ñ”ÑĞ˜Â°Ñ˜Ñ”Ğ˜Â?
	for(i = 1; i < 2; i++)
	{
		// ?„–?†Ğ–Â°Ñ”ÑĞ˜Â°Ñ˜Ñ?, ?Ğªâ„–Â°?˜Ğ¸Ñ”Ñ‘ĞĞœÂµÂµÂ·ĞŸÑ˜Ñ˜Ğ–Ğ?
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

	// ?•Â?Â·?Ğ…Ñ”Ñ”Ğ‡Â°Ğ¶Â±Ñ„Ñ”ÑĞĞœĞ•Ğ¨Ğ…Ñ”Ğ“Ğ?
	ClassChangeLightBig = GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig");
	ClassChangeLightSmall1 = GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall1");

	// ?•Â?Â·?Ğ…Ñ”Ñ”Ğ‡Â°Ğ¶â„–Ğ¸Â°Ğ¶?•Ğ¨Ğ…Ñ”Ğ“Ğ?
	ClassBgMain_Big = GetTextureHandle(m_WindowName $ ".ClassBgMain_Big");
	ClassBgMain_Small1 = GetTextureHandle(m_WindowName $ ".ClassBgMain_Small1");

	// ?•Â?Â·?Ğ…Ñ”Ñ”Ğ‡Â°Ğ¶â„–?†Ğ–Â?	
	ClassFrameBtn1 = GetButtonHandle(m_WindowName $ ".ClassFrameBtn1");

	// ?•Â?Â·?Ğ…Ñ”Ñ”Ğ‡Â°Ğ¶Ñ‘Â¶Ğ•Â?
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
// F2P ?˜Â??”ÑĞ…Ñ? ?˜Â°Â·Ğ? Â°?–Ñ˜Â? - gorillazin
function UpdateVp(int vitality)//ldw ?˜Ñ†Ğ‘Â?
{
	// End:0x3C
	if(vitality < 2205 && vitality > 0)
	{
		// ?“Ğ¦Ò‘Ğ? 140000 ?Ğ? Â°Ğ¶?—Ğ? 1806 ?”ĞĞ•Ğ? ?…Ñ”Ğ•Ğ˜Ğ“ÑÑ—Ğ? ?‘Â«Â±Ğ??Ğ? ?•ÑˆÑ•Ğ? vpÂ°?? ?•ÑˆÑ•Ğ? ?”Ñ‘ĞĞÒ‘Ğ©Ò‘Ğ? ?˜Ñ†Ğ‘Â? ?–Â»Ñ—Ğ»ĞÂ? ?Â§Ğ—Ğ? ?—â„–?—Ğ? ?“Ñ–Ñ‘Â? , statusbarWnd, lobbyMenuWnd ?—ĞÂµÂ? Â°Â°?Ğ? ?“Ñ–Ñ‘Â? Âµ?—Ñ•ÑŠĞĞ? ldw 2011.02.23
		texVP.SetPoint(2205, MaxVitality);
	}
	else
	{
		texVP.SetPoint(vitality, MaxVitality);
	}
}

// ?Ğ? function?Ğ? ?—ĞšÑ—Ğ? ?•ÑˆÒ‘Ğ? ?”ĞÑ”Ğ? ?‘Ğ¦Ñ˜Â? ?“Ñ–Ñ‘Â?
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
	else if(Event_ID == EV_VitalityPointInfo)	// ?˜Â°Â·Ğ’Ğ‘Â¤Ñ”Ñ‘Ñ•Ñ‡ÂµÒĞĞœĞ–Â?
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
		
		// ?•Ğ–Â·â„–?–Ğ? ?Ğ? Â°Ğ¶?—Ğ? ?ĞªÂµÑ? ?—Â?Â±Ğ² Â±Ğ²?‘Ğ™ĞÂ? Â»Ğ·?—Ğ? ?—ĞŸĞ‘Ñ? ?•ĞšÒ‘Ğ’Ò‘Ğ?.
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
	// F2P ?˜Â??”ÑĞ…Ñ? ?˜Â°Â·Ğ? Â°?–Ñ˜Â? - gorillazin
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
 *  ?“Ğ¦Ğ“ĞšÂµĞ¹Ñ•Ğ¾Ñ—ĞÒ‘Ğ’Ñ˜Â??”ĞºĞĞ?, ÂµĞ°?•ÑƒÂµĞ¾ĞĞ—Ğ‘Â¤Ñ”Ñ‘Ñ‘Â¦â„–Ğ®?•Ğ–Â±Ğ²Â·ĞŸĞ—Ğ¡Ò‘Ğ?.
 **/
function updateSubjobInfo(string param, int Event_ID)
{	
	local int count, i;

	local UserInfo myUserInfo;

	local bool bFlag;

	local SubjobInfo tempSubjobInfo;

	// ?‘Ñ•Ğ‘Â?
	//local int  race;

	isDualClass = false;

	hideAlchemyWindow("AlchemyItemConversionWnd");			
	hideAlchemyWindow("AlchemyMixCubeWnd");

	// saveUpdateSubjobInfoParam = param;

	//GetMyUserInfo(myUserInfo);
	GetPlayerInfo(myUserInfo);


//	debug("?—Ñ†ĞĞ? ?•Â?Â·?Ğ…Ñ? : " @ GetClassType(myUserInfo.nSubClass));
//	debug("?—Ñ†ĞĞ·ĞÑŒĞ‘Ñ‡Â»ÑƒĞ•Ğ?: " @ GetClassTransferDegree(myUserInfo.nSubClass));

	// ?—Ğ¨Ò‘Ğ·Ğ‘Ñ‡Ñ•Ñ‡Ñ˜Ñ†Ñ‘Â¦Ñ‘Â??•ĞŸâ„–Ğ®?‘Ğ’Ò‘Ğ?.
	ParseInt(param, "Count"  , count);
	
	// ?—Ñ†ĞĞ·Ğ‘Ğ??ĞĞ•Â?Â·?Ğ…Ñ”Ñ•Ğ–ĞĞœÂµÑ?
	ParseInt(param, "currentSubjobClassID", CurrentSubjobClassID);

//	debug("?—Ñ†ĞĞ·ĞÑŒĞ‘Ñ‡Â»ÑƒĞ•Ğ?->: " @ GetClassTransferDegree(CurrentSubjobClassID));
	//Debug("?—Ñ†ĞĞ·classID ->: " @ CurrentSubjobClassID);
	// Â»Ğ¸?‘Â?
	if(subjobInfoArray.Length > 0)
	{
		subjobInfoArray.Remove(0, subjobInfoArray.Length);
	}

	bFlag = false;
		

	
	ParseInt(param, "Race", race);

//	debug("?‘Ñ•Ğ‘Â? race:" @ Race);
	//debug("?‘Ñ•Ğ‘Â·ĞĞœÑ‘Â? :" @ getRaceString(Race));

	// ?˜Â??”ĞºĞĞ²Ñ‘Â??…Ñ”Ğ–Â??‘Â¦â„–Ğ®?‘Ğ’Ò‘Ğ?.(0?‘Ğ??Ğ?, ?˜Â??”ĞºÂµĞ°Ñ•ÑƒÂ°Ñ?1,2,3(?“Ğ¦Ò‘Ğ?))
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

		// ÂµĞ°?•Ñ? ?•Â?Â·?Ğ…Ñ”Â°Ğ? ?—ĞŸÑ–Ğ„Â¶ÑƒÂµÂ? ?Ğ¦Ò‘Ğ©Ñ‘Ğ?..
		if(subjobInfoArray[i].Type == 1) 
		{ 
			isDualClass = true; 
		//	Debug("ÂµĞ°?•ÑƒĞĞ? ?Ğ¦Ò‘Ğ?! ");
		}
	}
	for(i = 0; i < count; i++)
	{
		if(CurrentSubjobClassID == subjobInfoArray[i].ClassID)
		{
//			Debug("Â°Â°?‘Ğ? subjobInfoArray[i].ClassID" @ subjobInfoArray[i].ClassID);
			//			currentSubjobClassNum = i;

			// ?˜Â?Â·?Â±Ñ–Ğ“Ñ?
			tempSubjobInfo = subjobInfoArray[i];
			subjobInfoArray[i] = subjobInfoArray[0];
			subjobInfoArray[0] = tempSubjobInfo;

			currentSubjobClassNum = 0;
			break;
		}
	}

//	debug("subjobInfoArray ::::: " @ subjobInfoArray.Length);

	// ?˜Â??”Ğ? ?•Â?Â·?Ğ…Ñ”Â°Ğ? ?Ğ¦Ò‘Ğ©Ñ‘Ğ?.. ?„–?†Ğ–Â°ÂµĞ¹ĞĞ? ?”Ñ‘ĞĞœÂµÂµÂ·Ğ? ?“ĞšÂ±Ğ²Ğ˜Â?
	if(count > 0) initClassChangeButton(true);
	else initClassChangeButton(false);

	// ?‘Ñ‡Ñ•Ñ‡Ğ‘Â¤Ñ”Ñ‘Ñ•Ñ‡ÂµÒĞĞœĞ–Â?
	//  1,2,3 Â±Ğ¾?‘Ñ†ÂµĞ¹Ñ•Ğ¾Ñ—Ğ“Ñ˜Ñ†ĞĞ¦ĞĞ?. ?—Ñ†ĞĞ·Ğ”Ñ–Ñ‘Ğ‡Ğ•Ğ?1 + ?˜Â??„–??(ÂµĞ°?•Ñ?) 3Â°??= ?“Ğ?4Â°??
	for(i = 1; i < count; i++)
	{
		if(i < count)
		{
			// Debug("-------------" @ i);
//			Debug("subjobInfoArray[i].ClassID" @ subjobInfoArray[i].ClassID);
			//---- 3?‘Ñ•â„–?†Ğ–Â°Ñ•Ñ‡ÂµÒĞĞœĞ–Â?-----
			// Debug("?„–?†Ğ–Â°â„–Ğ¸?”ĞĞĞ«ĞÑ”Â°Ğ?" @ subjobInfoArray[i].ClassID);

			// ?ĞœĞÑŒĞĞ—Â»ÑƒĞ•Ğ’Ñ—ĞÂ°Â°ĞÑ”Â°ĞĞĞœÑ—Ò‘Ò‘Ğ©Ñ‘Ğ?.. Â±?„Ñ”ÑĞĞœÒ‘Ğ’ĞĞœĞ–Ğ¡Ğ–Â?
			if(beforeSubjobInfo.ClassID == subjobInfoArray[i].ClassID) bFlag = true;
			else bFlag = false;

			// Debug("?˜Â??”Ğ?, ?‘Ğ??ĞÂ°Ğ›Â»Ğ? subjobInfoArray[i].Type : " @subjobInfoArray[i].Type);
			// debug("GetClassTransferDegree(myUserInfo.nSubClass)"@ GetClassTransferDegree(myUserInfo.nSubClass));
			// debug("?‘Ñ•Ğ‘Â? race:" @ myUserInfo.Race);
			// debug("?‘Ñ•Ğ‘Â·ĞĞœÑ‘Â? :" @ getRaceString(myUserInfo.Race));

			// ?‘Ğ??Ğ?:0, ÂµĞ°?•Ñ?:1 ?˜Â??”Ğ?:2

			// ?˜Â??”Ğ?: ?“Â»Â»Ñ?
			if(subjobInfoArray[i].Type == 2)
			{
				if(GetClassTransferDegree(subjobInfoArray[i].ClassID) >= 1)
					setclasstexture(i, "l2ui_ct1.playerstatuswnd_ClassBgSub_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[i].ClassID $ "_Small", bFlag);
				else 
					setclasstexture(i, "l2ui_ct1.playerstatuswnd_ClassBgSub_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(race) $ "_Small", bFlag);
			}			
			// ÂµĞ°?•Ñ? : ?–Ğ”Â¶Ñ?
			else if(subjobInfoArray[i].Type == 1)
			{	
				if(GetClassTransferDegree(subjobInfoArray[i].ClassID) >= 1)
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[i].ClassID $ "_Small", bFlag);
				else
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(race) $ "_Small", bFlag);
			}
			//?‘Ğ??Ğ? :Â»?Â°Â?
			else if(subjobInfoArray[i].Type == 0)
			{
				if(GetClassTransferDegree(subjobInfoArray[i].ClassID) >= 1)
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[i].ClassID $ "_Small", bFlag);
				else
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(race) $ "_Small", bFlag);
			}

			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).EnableWindow();
			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).ShowWindow();

			// Debug("?„–?†Ğ–Â? " @ m_WindowName $ ".ClassFrameBtn" $ i);
			// GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i + 1).ShowWindow();

			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).SetTexture("L2UI_ct1.PlayerStatusWnd_ClassFrameBtn",
																			 "L2UI_ct1.PlayerStatusWnd_ClassFrameBtn_down",
																			 "L2UI_ct1.PlayerStatusWnd_ClassFrameBtn_over");

			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).SetTooltipCustomType(subjobButtonToolTips(i));
			GetTextureHandle(m_WindowName $ ".ClassSlotBlank" $ i).HideWindow();
		}
		//?•Ğ–Ñ‘Ğ? ?•Ğ§ĞĞœÑ•Ğ? ?‘Ñ•Ğ‘Â·ĞĞ? ?•Ğ–Ò‘Ğ? Â°Ğ¶?—Ğ¼Ñ—ĞÑ‘Ñ? ?”Ñ‘Ñ—Â? ?‘Ğ¨Ò‘Ğ?.
		else if(race != 6) 
		{
			
			// Debug("------?Ğªâ„–Â°?˜Ğ? -------" @ i);
			// ?„–?†Ğ–Â°Ñ”ÑĞ˜Â°Ñ˜Ñ?, ?Ğªâ„–Â°?˜Ğ¸Ñ”Ñ‘ĞĞœÂµÂµÂ·ĞŸÑ˜Ñ˜Ğ–Ğ?
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

	// ---- ?•Â«Ğ•Â?Â·?Ğ…Ñ”ĞĞœâ„–?œĞ‘Ñ†Ñ•Ñ‡ÂµÒĞĞœĞ–Â?-----
	// 2?’Ñ‡ĞÑŒĞ‘Ñ‡ĞĞœÂ»ÑƒĞĞœÂ¶ÑƒÑ‘Ğ?..

	// 3?’Ñ? ?ÑŒĞ‘Ñ? ?ĞœÂ»ÑƒĞ—Ğ? ?”Ñ–Ñ‘Ğ‡Ğ•ĞÂ°Ğ? ?Ğ¦Â°Ğ? , ?˜Â??”Ğ? ?Ğ? 1Â°?? ?ĞœÂ»Ñ? ?Ğ¦Ò‘Ğ©Ñ‘Ğ?, ?‘Ñ†Ğ‘Â¤Ğ—Ğ? ?•Â?Â·?Ğ…Ñ? ?•Ğ–ĞĞœĞ”Ğ??Â? ?Ñ‹Ñ—Ğ?
	//if(GetClassTransferDegree(myUserInfo.nSubClass) > 1 && count > 1)

	// debug("myUserInfo.nSubClass >: " @ myUserInfo.nSubClass);
	// debug("GetClassTransferDegree(myUserInfo.nSubClass) >: " @ GetClassTransferDegree(myUserInfo.nSubClass));

	// ?‘Ğ??Ğ?:0, ÂµĞ°?•Ñ?:1 ?˜Â??”Ğ?:2
	// 4?’Ñ? ?ÑŒĞ‘Ñ? Âµ?? ?”Ñ–Ñ‘Ğ‡Ğ•ĞÂ¶ÑƒÑ‘Ğ?..
//	Debug("subjobInfoArray[currentSubjobClassNum].ClassID" @ subjobInfoArray[currentSubjobClassNum].ClassID);
	if(GetClassTransferDegree(subjobInfoArray[currentSubjobClassNum].ClassID) >= 1)
	{
		// Â±?–Ğ“Ñ˜ÂµĞ˜Â»ÑƒĞ•Ğ’Â¶ÑƒÑ‘Ğ¹ĞĞœĞ–Ğ¡Ğ–Â??“Ğ²Â·Ğ?
		if(EV_ChangedSubjob == Event_ID) bFlag = true;
		else bFlag = false;

		// debug("?˜Â??”ĞºÑ•Ğ¦ÂµĞ?:" @ subjobInfoArray[currentSubjobClassNum].Type);
		// ?˜Â??”ĞºÑ‘Ğ¹Ğ“Â»Â»Ñ?
		if(subjobInfoArray[currentSubjobClassNum].Type == 2)
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big", 
							   "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[currentSubjobClassNum].ClassID $ "_Big", bFlag);
			
		}
		// ÂµĞ°?•Ñ?,?‘Ğ??ĞĞÑ”Â»ĞÂ°Â?0: ?‘Ğ??Ğ?, 1 ÂµĞ°?•Ñ?
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
		// ?˜Â??”ĞºÑ‘Ğ¹Ğ“Â»Â»Ñ?
		if(subjobInfoArray[currentSubjobClassNum].Type == 2)
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big", 
							   "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(race) $ "_Big", false);
			
		}
		// ÂµĞ°?•Ñ?,?‘Ğ??ĞĞÑ”Â»ĞÂ°Â?0: ?‘Ğ??Ğ?, 1 ÂµĞ°?•Ñ?
		else if(subjobInfoArray[currentSubjobClassNum].Type == 1)
		{			
				
			// ?˜Â??”ĞºĞĞ²ĞÂ? ?•Ğ˜Ğ—Ğ?.. 1?’Ñ? ?ÑŒĞ‘Ñ‡ÂµÂ? ?•Ğ˜Ğ—Ğ? ?Ğ‡ĞÑŠĞĞ? ?•Ğ–ĞĞœĞ”Ğ?
			//initClassChangeButton(false);
			// Â°?Ğ‘Ñ•Ğ‘Â·Ñ”Â°Ğ…Ğ™Ñ”Ñ˜ĞĞœâ„–?œĞ‘Ñ?
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Big", 
							   "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(race) $ "_Big", false);		
		}
		else if(subjobInfoArray[currentSubjobClassNum].Type == 0)
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Big", 
							   "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRaceString(race) $ "_Big", false);		

		}
		
		// UserInfo(
		// ?˜Ñ†Ğ‘Â¤Ğ—Ğ¨Ñ•Ğ??—Ğ¤race
		// Debug("?‘Ñ•Ğ‘Â·Ñ”Â?---::" @ myUserInfo.race);
		
		//GetRaceTicketString(int Blessed);
	}

	beforeSubjobInfo = subjobInfoArray[currentSubjobClassNum];

	// Type : 0 ?‘Ğ??Ğ?, 1 ÂµĞ°?•Ñ?. 2 ?˜Â??”Ğ?
	// debug("myUserInfo.Class : " @ GetClassRoleName(classID));
	
		//native final function string GetClassRoleName(classID) ;
	// CurrentSubjobClassID=3 Count=3 SubjobID_1=1 SubjobClassID_1=117 SubjobLevel_1=55 SubjobType_1=0 SubjobID_2=1 SubjobClassID_2=73 SubjobLevel_2=55 SubjobType_2=1 SubjobID_3=1 SubjobClassID_3=131 SubjobLevel_3=55 SubjobType_3=2
	// CurrentSubjobClassID=3 Count=3 SubjobID_1=1 SubjobClassID_1=117 SubjobLevel_1=55 SubjobType_1=1 SubjobID_2=1 SubjobClassID_2=73 SubjobLevel_2=55 SubjobType_2=1 SubjobID_3=1 SubjobClassID_3=131 SubjobLevel_3=55 SubjobType_3=1 
	// CurrentSubjobClassID=3 Count=1 SubjobID_1=1 SubjobClassID_1=134 SubjobLevel_1=55 SubjobType_1=1
}

/** ?‘Ğ©ĞĞœÑ•ÑƒÂ·ĞÂ±Ğ§â„–Ğª?…Ñ”OK ?•Â¬Ñ‘Ğ‡Ğ…Ğ?*/
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
				// subjobInfoArray[dialogValue].Type  // 0?‘Ğ??Ğ?, 1ÂµĞ°?•Ñ?, 2?˜Â??”Ğ?
				case 0 : 
				case 1 : 
				case 2 : 
				case 3 :
						ExecuteEvent(EV_NPCDialogWndHide);
						// Debug("subjobInfoArray[dialogValue].Type  "  @ subjobInfoArray[dialogValue].Type);
						// ?‘Ğ??Ğ?, ÂµĞ°?•ÑƒĞĞœÂ¶ÑƒÑ‘Ğ?..
						if(subjobInfoArray[dialogValue].Type == 0)
						{
							// ?…Ñ”Ğ•Ñ? ?„–?ˆĞ˜ĞˆĞĞ? 
							infItem.ID.ClassID = 1566;

							//infItem.ID.ServerID = 1566;
							// ?‘Ğ??ĞĞ•Â?Â·?Ğ…Ñ”Â·ĞÑ”Ğ‡Â°Ğ?
							// Debug("?‘Ğ??Ğ? ?…Ñ”Ğ•Ñ–Â»Ğ·Ñ—Ğ?" @ infItem.ID.ClassID);
							UseSkill(infItem.ID, int(EShortCutItemType.SCIT_SKILL));
							// ExecuteCommand("//use_skill 1566 1");
						}
						else
						{
							// ÂµĞ°?•Ñ? ?ĞœÂ¶ÑƒÑ‘Ğ?.. ?“Ñ–Ñ‘Â?
							if(subjobInfoArray[dialogValue].Type == 1) 
							{
								// ?—Ñ†ĞĞ? ?•ÑˆĞĞ?
								// empty
							}

							// 1567, 1568, 1569 ?˜ÑˆÑ˜Â?Âµ?—Â·Ğ?.. ?˜Â??”ĞºĞ…Ğ…Â·Ğ?1,2,3 ?”Ğ‡Â°Ğ?
							//infItem.ID.ClassID = 1567 +(dialogValue - 1);
							infItem.ID.ClassID = 1567;
							//infItem.ID.ServerID = 1568 +(dialogValue - 1);

							// Debug("?…Ñ”Ğ•Ñ–Â»Ğ·Ñ—Ğ?" @ infItem.ID.ClassID);
							UseSkill(infItem.ID, int(EShortCutItemType.SCIT_SKILL));
							// ExecuteCommand("//use_skill " $ String(infItem.ID.ClassID) $ " 1");
						}
			}

			// ?”Ğ‡Â°Ğ¶Ğ…Ñ”Ğ•Ñ–Â»Ğ·Ñ—Ğ?
			Me.EnableWindow();
		}
	}
}

/**
 * ?‘Ğ©ĞĞœÑ•ÑƒÂ·ĞÂ±Ğ§â„–Ğª?…Ñ?(?˜Â??”ĞºĞ•Â?Â·?Ğ…Ñ”Â·ĞÑ”Ğ‡Ğ…Ğ•Ğ—Ğ¢Ğ‘Ñ†â„–Â°?•Ğ¾Ñ”Ñ‘Ò‘Ğ’Ò‘Ğ©ĞĞœÑ•ÑƒÂ·ĞÂ±Ğ?)
 * 0..1..2 
 **/
function askDialogBox(int currentClickSubjobNum)
{
	local WindowHandle m_dialogWnd;	
	m_dialogWnd = GetWindowHandle("DialogBox");
	if(!m_dialogWnd.IsShowWindow())
	{
		// ?—Ñ†ĞĞ·Ğ•Â?Â·?Ğ…Ñ”Ñ—ĞĞ•Â¬Ñ‘Ğ‡Ğ—Ğ¡Ñ˜Â??”ĞºĞ•Â?Â·?Ğ…Ñ”Â°ĞÂ°Â°Ğ‘Ñ†Ñ•ĞšÒ‘Ğ©Ñ‘Ğ?.. ?”Ğ‡Ğ…Ğ•ĞÂ»â„–Â°?•Ğ¾Ñ”Â»Ò‘Ğ?.
		if(subjobInfoArray[0].ClassID != subjobInfoArray[currentClickSubjobNum].ClassID)
		{
			DialogSetID(DIALOG_DetailStatusWnd);

			DialogSetReservedInt(currentClickSubjobNum);

			// ?‘Ğ??ĞĞ•Â?Â·?Ğ…Ñ?, ÂµĞ¢?”ĞºÑ‘ÂµÂ°Ğ?, ?˜Â??”ĞºÑ˜Ğ¢Ñ—Ğ¿Ğ•Ğ§ĞĞœĞ”Ñ?, Â·?Ñ”Ğ‡Â°Ğ¶Ğ—ĞŸĞ…Ğ“Â°ĞªĞ…ĞÒ‘ĞŸÂ±Ğ??   ?ĞœÂ·Â±Ğ…Ğ?
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
 *  ?—Ñ†ĞĞ·Ñ˜Â??”ĞºĞĞ²Ğ…Ñ”Ğ–Â??‘ÂµĞÂ»Ñ‘Â??•ĞŸâ„–Ğ®?‘Ğ’Ò‘Ğ?.
 **/
function string getSubjobTypeStr(int nType)
{	
	local string tempStr;
	
	// 0 ?‘Ğ??Ğ?, 1 ÂµĞ°?•Ñ?(?—Ñ†ĞĞ·Ò‘Ğ’Ñ‘Ğ??ĞĞÑ‘Â·ĞĞ“Ñ–Ñ‘Â?-ÂµĞ°?•ÑƒĞĞœÂ¶ÑƒÒ‘Ğ’Ñ—Ğ»Ñ•Ğ¾Ò‘Ğ’Ñ•Ğ–Ğ‘Ñ‡Â»Ğ·Ñ—Ğ»Ñ•Ğ˜Ğ—Ğ?) , 2 ?˜Â??”Ğ?
	switch(nType)
	{
		case 0 : tempStr = GetSystemString(2340); break; // ?‘Ğ??ĞĞ•Â?Â·?Ğ…Ñ?
		case 1 : tempStr = GetSystemString(2737); break; // ÂµĞ°?•ÑƒĞ•Â?Â·?Ğ…Ñ?
		case 2 : tempStr = GetSystemString(2339); break; // ?˜Â??”ĞºĞ•Â?Â·?Ğ…Ñ?
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
			// ?’Ñ‡Ñ—Ñ? ?ĞœÂµÑ? ?˜Ğ? 
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
 *  ?„–?†Ğ–Â°Ñ•Ğ¦Ò‘ĞŸĞĞœĞ–Ğ¡Ğ–Â?(1 ~ 3 ?„–?ˆâ„–?†Ğ–Â°Ğ˜Ñ—Â°Ñ?) 
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
 * ?•Â?Â·?Ğ…Ñ”Ñ”Ğ‡Â°Ğ¶Ğ…Ğ?, ?•Ğ¨Ğ…Ñ”Ğ“Ğ”Â±Ñ–Ğ“Ñ?, ?‘Ñ•Ğ‘Â·Ñ”Â°Ñ‘Â¶Ğ•Â©Ğ•Ğ¨Ğ…Ñ”Ğ“Ğ?, ?”ÑĞ’Â¦Â°Ğ•Ñ‘Â??‘Ğ’Ğ˜Ñ—Â°ÑŠÑ”Ñ‘Ñ—Â©Ğ‘Ğ©Â°ĞĞĞĞ‘Ñ?..
 **/
function setClassTexture(int targetType, string bgTexture, string markTextureStr, bool effectFlag)
{
	if(targetType == 0)
	{

		// ?•Â«Ñ‘Ğ??ĞĞ•Â?Â·?Ğ…Ñ?(?—Ñ†ĞĞ·Ğ•Â?Â·?Ğ…Ñ?)

		// ?„–Ğ¸Â°Ğ¶
		ClassBgMain_Big.SetTexture(bgTexture);
		// debug("bgTexture" @ bgTexture);

		// ?‘Â¶Ğ•Â©Ñ”Ğ‡Â°Ğ?
		//debug("markTextureStr : " @ markTextureStr);
		ClassMarkBig.SetTexture(markTextureStr);
		// ClassMarkBig.HideWindow();

		// Â±?„Ñ”ÑĞĞœÒ‘Ğ’Ğ˜Ñ—Â°ÑŠÑ”Ñ‘Ñ—Â©Ğ‘Ğ¦Â±Ğ?
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
		// ?„–Ğ¸Â°Ğ¶
		GetTextureHandle(m_WindowName $ ".ClassBgMain_Small" $ targetType).SetTexture(bgTexture);
		
		// GetTextureHandle(m_WindowName $ ".ClassBgMain_Small" $ targetType).SetAlpha(255);
		// Debug("?„–Ğ¸Â°Ğ¶bgTexture " @ bgTexture);

		// ?‘Â¶Ğ•Â©Ñ”Ğ‡Â°Ğ?
		GetTextureHandle(m_WindowName $ ".ClassMarkSmall" $ targetType).SetTexture(markTextureStr);
		GetTextureHandle(m_WindowName $ ".ClassMarkSmall" $ targetType).ShowWindow();
		

		// Â±?„Ñ”ÑĞĞœÒ‘Ğ’Ğ˜Ñ—Â°ÑŠÑ”Ñ‘Ñ—Â©Ğ‘Ğ¦Â±Ğ?
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

//Â°Ğ¤?ĞœĞ‘Ñ†Ñ‘Ñ‘Ñ•Ñ‡ÂµÒĞĞœĞ–Â?
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

//?—Ğ“Â·â„–?ĞœÑ•Ğ¾ĞĞ—â„–Â®?•Ğ·Ğ‘Â¤Ñ”Ñ‘Ğ“Ñ–Ñ‘Â?
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

	//?…Ğ•Â±Ğ¤Ğ…Ñ”Ğ•Ğ? ?”Â«Ñ‘Â??…Ñ”Ñ‘Â? Â·Â°?•Â?
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

//?—Ğ“Â·â„–?ĞœÑ•Ğ¾Â°Ğ¤ĞĞœĞ‘Ñ†Ğ‘Â¤Ñ”Ñ‘Ğ“Ñ–Ñ‘Â?
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

//?—Ğ“Â·â„–?ĞœÑ•Ğ¾Ğ‘Â¤Ñ”Ñ‘Ğ“Ñ–Ñ‘Â?
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
	//?…Ğ•Â±Ğ¤Ğ…Ñ”Ğ•Ğ? ?”Â«Ñ‘Â??…Ñ”Ñ‘Â? Â·Â°?•Â?
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

	// ?˜Ğ£Ñ˜Ñ”Ñ˜Ñ†Ğ”Ğ?
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
	
	//?”Ğ‡Ğ…Ğ•Â°ÑŒÂ·Ğ“ÂµÒĞĞœĞ•Ğ?
	//local int nTransformID;
	local bool m_bPawnChanged;

	local UserInfo	info;
	
	//?˜Â°Â·Ğ?
	local int vitality;
	
	//?“ĞšÂ±Ğ²Ğ˜Â?
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
		//?…Ğ•Â±Ğ¤Ğ…Ñ”Ğ•Ğ? ?”Â«Ñ‘Â??…Ñ”Ñ‘Â?, Â·Â°?•Â?
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
		//?˜Ğ£Ñ˜Ñ”Ğ‘Â¤Ñ”Ñ‘Ñ˜Ñ˜Ğ–Ğ?
		AttrAttackType = info.AttrAttackType;
		//debug("?˜Ğ£Ñ˜Ñ”Ğ•Ñ‘ĞĞ¤â„–?ˆĞ˜Ğ?" @ info.AttrAttackType);
		AttrAttackValue= info.AttrAttackValue;
		AttrDefenseValFire = info.AttrDefenseValFire;
		AttrDefenseValWater = info.AttrDefenseValWater;
		AttrDefenseValWind = info.AttrDefenseValWind;
		AttrDefenseValEarth = info.AttrDefenseValEarth;
		AttrDefenseValHoly = info.AttrDefenseValHoly;
		AttrDefenseValUnholy = info.AttrDefenseValUnholy;
		//?”Ğ‡Ğ…Ğ•Ğ‘Â¤Ñ”Ñ‘Ñ˜Ñ˜Ğ–Ğ?
		//nTransformID = info.nTransformID;
		m_bPawnChanged = info.m_bPawnChanged;
		// ?…Ğ•Â±Ğ? ?“Ğ?Â°??  2010.10.11 CT3 ?…Ñ”Ğ•Ğ? ?‘Â¤Ñ”Ñ? Â°?–Ñ˜Â?
		nMagicAvoid = info.nMagicAvoid; 
		nMagicHitRate = info.nMagicHitRate; 
		nMagicCriticalRate = info.nMagicCriticalRate; 
		// debug("nMagicAvoid:"@ nMagicAvoid);
		// debug("nMagicHitRate:"@ nMagicHitRate);
		// debug("nMagicCriticalRate:"@ nMagicCriticalRate);

		//~ debug("?˜Ğ£Ñ˜Ñ”Ğ‘Â¤Ñ”Ñ?: " @ AttrAttackType);
		//~ debug("?˜Ğ£Ñ˜Ñ”Ğ‘Â¤Ñ”Ñ?: " @  AttrAttackValue);
		//~ debug("?˜Ğ£Ñ˜Ñ”Ğ‘Â¤Ñ”Ñ?: " @  AttrDefenseValFire);
		//~ debug("?˜Ğ£Ñ˜Ñ”Ğ‘Â¤Ñ”Ñ?: " @  AttrDefenseValWater);
		//~ debug("?˜Ğ£Ñ˜Ñ”Ğ‘Â¤Ñ”Ñ?: " @  AttrDefenseValWind);
		//~ debug("?˜Ğ£Ñ˜Ñ”Ğ‘Â¤Ñ”Ñ?: " @ AttrDefenseValEarth);
		//~ debug("?˜Ğ£Ñ˜Ñ”Ğ‘Â¤Ñ”Ñ?: " @ AttrDefenseValHoly);
		//~ debug("?˜Ğ£Ñ˜Ñ”Ğ‘Â¤Ñ”Ñ?: " @ AttrDefenseValUnholy);
		
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
		
		//debug("?˜Â°Â·Ğ’ÂµÂ?:" @ Vitality);
		UpdateVp(vitality);
		
		//?•Ğ–Ñ‘ĞˆĞ•Ğ§ĞĞœÑ•Ğ? ?‘Ñ•Ğ‘Â·ĞĞ? Â°Ğ¶?—Ğ? 
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
			//~ debug("?Ğ?..:rectWnd: " @ rectWnd.nY);
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
			txtLvName.SetText("?Ğ?");
		}
		else 
		{
			txtLvName.SetText("--");
		}
	}
	else txtLvName.SetText("" $ Level);

	txtClassName.SetText(ClassName);
	// Debug("=====:: ClassName " @ ClassName);
	// ?‘Ñ†ĞÂ? Â°?–Ñ˜Â? ?Ğ«Ñ•Ñ? Â¶?ƒĞĞœÑ”ĞºÑ—ĞÑ˜Â??‘Ğ? ?‘Ñ†ĞÂ§Â°Ğ? ?”Ñ‘ĞĞœĞ‘Ñ? ?•ĞšÒ‘Ğ’Ò‘Ğ?.
	//txtRank.SetText(UserRank);
	txtSP.SetText(string(SP));
	
	//?—Ñ‡Ñ‘Ğ?
	if(PledgeID>0)
	{
		//?•Ğ¨Ğ…Ñ”Ğ“Ğ?
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

	// ?—Ñ‡Ñ‘ĞĞĞœâ„–?œĞ‘Ñ†Â°ĞĞĞ¦Ò‘Ğ©Ñ‘Ğ?..
	if(bPledgeCrestTexture)
	{
		texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);
		txtPledge.MoveTo(rectWnd.nX + 110 , rectWnd.nY + 57);
		//?˜Ñ†Ğ‘Â?
	}
	else
	{
		// ?—Ñ‡Ñ‘ĞĞĞœâ„–?œĞ‘Ñ†Â°ĞÑ•ÑˆÒ‘Ğ©Ñ‘Ğ?..
		txtPledge.MoveTo(rectWnd.nX + 86, rectWnd.nY + 57);
	}
	
	//?—ÂµÑ—Ñ?,?–Ğ»Ñ”Ğ½Â·â„–?…Ñ?
		
	if(bHero)
	{
		HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_heroicon";
	}
	//?–Ğ»Ñ”Ğ½Â·â„–?…Ñ? ver EP2.0 6.25 ?„–?†Ğ‘Ğ‡Ñ—Ğ? ?“Ğ?Â°??
	else if(nNobless == 1)
	{
		HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_nobleicon";
	}
	//?•Ğ–Ñ–ĞšĞ…Ñ? ver EP2.0 6.25 ?„–?†Ğ‘Ğ‡Ñ—Ğ? ?“Ğ?Â°??
	else if(nNobless == 2)
	{
		//Debug("?–Ğ»Ñ”Ğ½Â·â„–?…Ñ? 2 Â·?ÂµĞ? ?—Ğ?");
		HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_nobleicon2";
	}
	//Debug(HeroTexture @ nNobless);
	texHero.SetTexture(HeroTexture);
	
	//Â»?ƒÑ˜Ñ˜Ğ‘Â¤Ñ”Ñ?
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

	//?…Ğ•Â±Ğ¤Ğ…Ñ”Ğ•Ğ? Â·Â°?•Â?
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

	//?…Ğ•Â±Ğ¤Ğ…Ñ”Ğ•Ğ? ?”Â«Ñ‘Â??…Ñ”Ñ‘Â?
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
	
	// ?˜Ğ£Ñ˜Ñ”ÂµÒĞĞœĞ•ĞÑ˜Ñ˜Ğ–Ğ?
	txtAttrAttackType.SetText(""$ AttrAttackTypeTxt);
	txtAttrAttackValue.SetText(""$ AttrAttackValue);
	txtAttrDefenseValFire.SetText(""$ AttrDefenseValFire);
	txtAttrDefenseValWater.SetText(""$ AttrDefenseValWater); 
	txtAttrDefenseValWind.SetText(""$ AttrDefenseValWind);
	txtAttrDefenseValEarth.SetText(""$ AttrDefenseValEarth);
	txtAttrDefenseValHoly.SetText(""$ AttrDefenseValHoly);
	txtAttrDefenseValUnholy.SetText(""$ AttrDefenseValUnholy);
	
	// ?”Ğ‡Ğ…Ğ•Ğ‘Â¤Ñ”Ñ‘Ñ˜Ñ˜Ğ–Ğ?
	if(m_bPawnChanged) 
	{
		//~ iGender = info.nSex;
		//~ TransformedID = class'UIDATA_TRANSFORM'.static.GetNpcID(nTransformID, iGender);
		//~ debug("?”Ğ‡Ğ…Ğ•Ñ•Ğ–ĞĞœÂµÑ?"@ TransformedID);
		//~ TransformedName = class'UIDATA_NPC'.static.GetNPCName(TransformedID);
		//~ txtLvName.SetText(Level $ " " $ TransformedName);
		//~ RunTransformManage();
	}
	else
	{
		RunUnTransformManage();
	}

	//6.25 ?•Ğ–Ñ–ĞšĞ…Ñ? ?“Ğ?Â°??
	//GD4.0 05 85?ĞœÂ»Ñ? 1Â·?•Ñ•Ñ? ?…Ğ? AP Â»Ğ·?—Ğ? Â°?Ò‘Ğ?
	
	handleAbilityBtn(Level >= 85, info.nRemainAbilityPoint);
}


//HP?„–Ğ©Â°Â»?…Ğ?
function UpdateHPBar(int Value, int MaxValue)
{
	texHP.SetPoint(Value, MaxValue);
}

//MP?„–Ğ©Â°Â»?…Ğ?
function UpdateMPBar(int Value, int MaxValue)
{
	texMP.SetPoint(Value, MaxValue);
}

//EXP?„–Ğ©Â°Â»?…Ğ?
function UpdateEXPBar(float ExpPercent)
{
	texEXP.SetPointExpPercentRate(ExpPercent);
}

//CP?„–Ğ©Â°Â»?…Ğ?
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

function HandleVitalityPointInfo(string param) // ?˜Â°Â·Ğ’Ñ˜Ñ†Ğ”ĞÑ‘Ñ‘Ñ•Ñ‡ÂµÒĞĞœĞ–Â?
{
	local int nVitality;

	ParseInt(param, "Vitality", nVitality);

	UpdateVp(nVitality); // ?˜Â°Â·Ğ’Â°Ğ¤ĞĞœĞ‘Ñ†Ñ‘Â¦Ñ•Ñ‡ÂµÒĞĞœĞ–Â??—Ğ¡Ò‘Ğ?.
}

//branch
// F2P ?˜Â??”ÑĞ…Ñ? ?˜Â°Â·Ğ? Â°?–Ñ˜Â? - gorillazin
function HandleVitalityEffectInfo(string param)
{
	local CustomTooltip t;
	local int nVitality, nVitalityBonus, nVitalityItemRestoreCount, nVitalityExtraBonus;
	local string sBonusString, sExtraBonusString;

	ParseInt(param, "vitalityPoint", nVitality);
	ParseInt(param, "vitalityBonus", nVitalityBonus);
	ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
	// maxRestoreCount ?—Ğ? ?‘Ğ»Ğ—Ğ? ?–Â»Ñ—Ğ»ĞÑ? ?Ğ? UI?—ĞÑ˜Â??‘Ğ? Â»Ğ·?—Ğ»Ğ—ĞŸĞ‘Ñ? ?•ĞšĞ…ĞÒ‘ĞŸÒ‘Ğ?.

	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);
	util.ToopTipInsertText(GetSystemString(2494), true, false);

	// ?˜Â°Â·Ğ? BM ?“Ğ?Â°?? 2015.05
	ParseInt(param, "vitalityExtraBonus", nVitalityExtraBonus);

	sBonusString = nVitalityBonus $ "%";
	// End:0xFF
	if(nVitalityExtraBonus > 0)
	{
		sExtraBonusString = "(+" $ nVitalityExtraBonus $ "%)";
	}

	//Debug("?˜Â°Â·Ğ? Â°?–Ñ˜Â? HandleVitalityEffectInfo "  @ nVitality @ nVitalityBonus @ nVitalityItemRestoreCount @ nVitalityItemMaxRestoreCount @ nVitalityExtraBonus);

	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);

	// ?˜Â°Â·Ğ? ?”Ñ‘Ñ–ĞšĞ…Ñ?:
	util.ToopTipInsertText(GetSystemString(2494), true, false);
	// ?˜Â°Â·Ğ’ĞĞ? 0 ?Ğ? Â°Ğ¶?—Ğ? ?„–?œĞÑ‹Ñ—Ğ? ?—ÒĞ…Ğ?
	// End:0x199
	if(nVitality <= 0)
	{
		util.ToopTipInsertText(GetSystemString(2496), true, false, util.ETooltipTextType.COLOR_GRAY);
		util.ToopTipInsertText(GetSystemMessage(13112), true, true);		
	}
	// ?˜Â°Â·Ğ? 0 ?ĞœÂ»ÑƒĞĞ? Â°Ğ¶?—Ğ? 
	else
	{
		util.ToopTipInsertText(sBonusString, true, false);
		util.ToopTipInsertText(sExtraBonusString, true, false, util.ETooltipTextType.COLOR_YELLOW03);
		util.ToopTipInsertText(" " $ GetSystemString(2495) $ ". ", true, false);
		util.ToopTipInsertText(GetSystemMessage(13111),true,true);
	}
	texVP.SetTooltipCustomType(util.getCustomToolTip());//bluesun ?”Ñ—Ğ…Ñ”Ğ•ĞÑ‘Â¶ĞĞœĞ‘Ğ? ?•ÑˆĞ–Ğ?
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
 * ?”Ñ—Ğ…Ñ”Ğ•Ğ¢Ğ•ÑˆĞ–Ğ?(?˜Â??”ĞºĞĞ²Ğ•Â?Â·?Ğ…Ñ”Ñ”Ğ‡Ğ˜Ğ‡â„–?†Ğ–Â°Ñ—ĞÂ»Ğ·Ñ—Ğ?)
 **/
function CustomTooltip subjobButtonToolTips(int TargetType)
{
	local CustomTooltip m_Tooltip;
	
	local int subjobSlotStringNum;
	// Debug("targetType tool " @ targetType);

	// ?˜Â??”ĞºĞ•Â?Â·?Ğ…Ñ”Ñ‘Â¦ÂµĞ¾Â·ĞŸĞ—ĞŸÒ‘Ğ’ĞĞªÑ‘Â??Ğ¤Ò‘ĞŸÒ‘Ğ?.. Â°Â°?Ñ”Ñ•Ğ˜Ñ–Â»Ñ‘Ğ—Ğ–Â?..
	if(TargetType == -1)
	{
		m_Tooltip.DrawList.Length = 1;
		m_Tooltip.MinimumWidth = 210;//160->183px Â·?? ?˜Ñ†Ğ‘Â¤ÂµĞ?
		m_Tooltip.DrawList[0].eType = DIT_TEXT;
		m_Tooltip.DrawList[0].t_color.R = 220;
		m_Tooltip.DrawList[0].t_color.G = 220;
		m_Tooltip.DrawList[0].t_color.B = 220;
		m_Tooltip.DrawList[0].t_color.A = 255;

		//?•Ğ–Ñ‘ĞˆĞ•Ğ§ĞĞœÑ•Ğ¾ĞĞ? Â°Ğ¶?—Ğ? ?•ÑˆĞ–Ğ? ?•Ğ¨Ğ…Ñ”Ğ–Â?Â°?? ?‘Ğ©Ñ‘Â?
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
		// Debug("GetClassType(subjobInfoArray[targetType] ?ĞœÑ‘Â?:)" @ GetClassType(subjobInfoArray[targetType].ClassID));

		// ?‘Ğ??Ğ?:0, ÂµĞ°?•Ñ?:1 ?˜Â??”Ğ?:2
		// ?˜Â??”ĞºĞ•Â?Â·?Ğ…Ñ”Â¶ÑƒÑ‘Ğ?..
		if(subjobInfoArray[TargetType].Type == 2)
		{
			// "?˜Â??”Ğ?" 
			m_Tooltip.DrawList[2].t_strText = "(" $ GetSystemString(2341) $ ")";			
		}
		else if(subjobInfoArray[targetType].Type == 1)
		{
			// "ÂµĞ°?•Ñ?" 
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
		// ?˜Â??”ĞºÂ¶ÑƒÑ‘Ğ?..
		// 80Â·?„–?”Â§ĞĞœĞ˜Ğ”Ñ‘Ğ??ĞĞ•Â?Â·?Ğ…Ñ”Â·ĞÑ˜Ñ”ĞĞµĞ—Ğ¢Ñ˜Ñ†ĞĞ¦Ğ…ĞÒ‘ĞŸÒ‘Ğ?. ?‘Ğ??˜Ñ˜Ğ‘Ñ†Ñ”Ñ‘Ñ—Â©Ğ‘Ğ?
		m_Tooltip.DrawList[4].eType = DIT_TEXT;

		// ÂµĞ°?•Ñ? ?•Â?Â·?Ğ…Ñ”Â°Ğ? ?—ĞŸÑ–Ğ„ÂµÂ? ?•ÑˆÒ‘Ğ? Â°Ğ¶?—Ğ?
		// 80Â·?„–?”Â? ?ĞœĞ˜Ğ? ?‘Ğ??ĞĞ•Â?Â·?Ğ…Ñ”Â·Ğ? ?˜Ñ”ĞĞµĞ—Ğ? ?˜Ñ? ?Ğ¦Ğ…ĞÒ‘ĞŸÒ‘Ğ? 
		// Â¶?ƒÒ‘Ğ? ?•ÑˆĞ–Ğ‘ĞÂ? ?”Ñ‘Ñ—Â©Ğ‘Ğ¨Ò‘Ğ?. 
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
	Debug("Error: DetailStatusWnd getMainLevel?˜ ê°’ì´ ?˜ëª»ë˜?—ˆ?Šµ?‹ˆ?‹¤. -1 ");
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
	Debug("Error: DetailStatusWnd getMainClassID?˜ ê°’ì´ ?˜ëª»ë˜?—ˆ?Šµ?‹ˆ?‹¤. -1 ");
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
 * ?Â©ÂµÂµÑ—Ğ¼ESC ?•Â°Â·ĞÒ‘Ğ?Â±Ğ²?“Ñ–Ñ‘Â?
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
