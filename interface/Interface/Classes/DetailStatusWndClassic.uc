//================================================================================
// DetailStatusWndClassic.
// emu-dev.ru
//================================================================================

class DetailStatusWndClassic extends UICommonAPI
	dependson(StatBonusWndClassic)
	dependson(ElementalSpiritWnd);

const DIALOG_DetailStatusWnd = 90005;
const NSTATUS_SMALLBARSIZE = 85;
const NSTATUS_BARHEIGHT = 12;

const ElixirItemID = 94314;

struct SubjobInfo
{
	var int Id;
	var int ClassID;
	var int Level;
	var int Type;
};

var string m_Statsinfo_UsePoint_Win;
var string m_WindowName;
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

var TextBoxHandle txtCriminalRate;
var TextBoxHandle txtSociality_PVP;
var TextBoxHandle txtSociality_PK;
var TextBoxHandle txtBonusVote;
var TextBoxHandle txtRaidPoint;
var TextureHandle texPledgeCrest;
var TextureHandle VitalityTex;

var ButtonHandle SpExtractOpenBtn;

var AnimTextureHandle APActive;

var int MaxVitality; //ldw

var int nCanUseAP; //ldw

var L2Util util;//bluesun ���� ���� ��

var TextBoxHandle txtDisapprove;

//------------------------------
//    Ŭ�����������
//------------------------------
// �����̴�����Ŭ����, ����Ʈ
var AnimTextureHandle ClassChangeLightBig;

// ����Ŭ�����ؽ���
// ����: l2ui_ct1.PlayerStatusWnd_ClassBgMain_Big (����)
// ����: l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big  (û��)
var TextureHandle ClassBgMain_Big;

// Ŭ������ũ�ؽ���
var TextureHandle ClassMarkBig;

// Ŭ���� �Ӽ�(����) �ý��� 2017-05-2

// �Ӽ� ���� ǥ��
var ButtonHandle BtnElementalInfo;

// �Ӽ�, �ڹ��� �̹���
var TextureHandle Element_Lock1;
var TextureHandle Element_Lock2;
var TextureHandle Element_Lock3;
var TextureHandle Element_Lock4;

// ��ư
var TextBoxHandle txtFireDefence;
var TextBoxHandle txtWaterDefence;
var TextBoxHandle txtWindDefence;
var TextBoxHandle txtEarthDefence;
var TextBoxHandle txtFireAttack;
var TextBoxHandle txtWaterAttack;
var TextBoxHandle txtWindAttack;
var TextBoxHandle txtEarthAttack;

//------------------------------
//     Ŭ���������ư
//------------------------------
//var AnimTextureHandle ClassChangeLightSmall1, ClassChangeLightSmall2, ClassChangeLightSmall3;

// Ŭ��������ؽ���1,2,3
//var TextureHandle ClassBgMain_Small1, ClassBgMain_Small2, ClassBgMain_Small3;

// Ŭ������ũ
//var TextureHandle ClassMarkSmall1, ClassMarkSmall2, ClassMarkSmall3;

// ���, ����Ŭ���������ư
//var ButtonHandle ClassFrameBtn1, ClassFrameBtn2, ClassFrameBtn3;

// ��������
var array<SubjobInfo> subjobInfoArray;
var SubjobInfo beforeSubjobInfo;

// ����Ȱ��ȭ�Ǿ��ִ�Ŭ����
var int currentSubjobClassNum;

// ���� ��� Ŭ���� �������� �ִ°�?
var bool isDualClass;
var int Race;

// �ӽ÷� ��� Ŭ���� , ������ ������ �����ؼ� â�� ������ ���� ���� �Ҷ� ����Ѵ�.
// var string  saveUpdateSubjobInfoParam;

// ���������� ���� ������, ��� ���� �̺�Ʈ �� ����
// var int updateSubjobLastEvent;
/*
History: UObject::ProcessEvent <-(DamageText Transient.DamageText, Function Interface.DamageText.OnEvent) <- 
GFxUIManager::ExecuteUIEvent <- ID:580, param:Index=361 Param1=1209048809 Param2=1209050262 <- ExecuteUIEvent
<- NSystemMessageManager::EndSystemMessageParam <- NConsoleWnd::EndSystemMessageParam <- SystemMessagePacket <- 
UNetworkHandler::Tick <- Function Name=SystemMessagePa <- UGameEngine::Tick <- UpdateWorld <- MainLoop
 **/

var int statusCanPlus;
var int statusMax;
var int statusPlusedCurrent;
var ButtonHandle UsePoint_Apply_BTN;
var ButtonHandle UsePoint_Cancel_BTN;
var ButtonHandle UsePoint_Reset_BTN;
var TextBoxHandle Statsinfo_UsePoint_text;
var WindowHandle StatConfirmResetWnd;
var WindowHandle StatConfirmApplyWnd;
var WindowHandle ConfirmWnd;
var RichListCtrlHandle ResetCharge_ListCtrl;
var TextBoxHandle NumPoint_text;
var array<int> statusPlused;
var ButtonHandle Reset_Btn;
var ButtonHandle FightInfo_BTN;

var ElementalSpiritWnd ElementalSpiritWndScript;
var TextBoxHandle ElixirPoint_txt;

/**
 * OnRegisterEvent
 **/
function OnRegisterEvent()
{
	//Level��Exp��UserInfo��Ŷ����ó���Ѵ�.
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_UpdateHennaInfo);

	//JYLee, �ǹ̾��� �Լ�ȣ���� ���� ���� status ������ �� ������ �ٸ� ĳ������ ������ �и�
	RegisterEvent(EV_UpdateMyHP);
	RegisterEvent(EV_UpdateMyMaxHP);
	RegisterEvent(EV_UpdateMyMP);
	RegisterEvent(EV_UpdateMyMaxMP);
	RegisterEvent(EV_UpdateMyCP);
	RegisterEvent(EV_UpdateMyMaxCP);

	// Ȱ�¾�����Ʈ
	RegisterEvent(EV_VitalityPointInfo);

	// ���̾�α�(����Ŭ��������Ȯ�ο�)
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);

	//���Ŭ�����׼���Ŭ��������Ʈ
	RegisterEvent(EV_NotifySubjob);
	// CurrentSubjobClassID=3 Count=3 SubjobID_1 SubjobClassID_1=44 SubjobLevel_1=55 SubjobType_1
	RegisterEvent(EV_CreatedSubjob);
	RegisterEvent(EV_ChangedSubjob);

	RegisterEvent(EV_Restart);

// CurrentSubjobClassID=117 Count=3 SubjobID_1=1 SubjobClassID_1=3 SubjobLevel_1=55 SubjobType_1=0 SubjobID_2=1 SubjobClassID_2=73 SubjobLevel_2=55 SubjobType_2=1 SubjobID_3=1 SubjobClassID_3=131 SubjobLevel_3=55 SubjobType_3=2
	// ���Ŭ�����׼���Ŭ��������Ʈ
	// const EV_NotifySubjob = 5310;
	// const EV_CreatedSubjob = 5311;
	// const EV_ChangedSubjob = 5312;
	// ���׷��帶�������װ���
	// ��ȸ������Ʈ234 1
	// ��ȸ������Ʈ235 1
	// �����߰�

	//branch
	// F2P ���� Ȱ�� ���� - gorillazin
	RegisterEvent(EV_VitalityEffectInfo);
	//
	//end of branch
	
	//branch120703
	RegisterEvent(EV_ToggleDetailStatusWnd);

	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_SetMaxCount);
}

function OnLoad()
{
	SetClosingOnESC();

	InitializeCOD();

	Me.EnableWindow();

	// Ŭ���������ư��Ȱ��ȭ
	//initClassChangeButton(false);
	MaxVitality = GetMaxVitality();//ldw
	nCanUseAP = 0;
	texExp.SetDecimalPlace(4);
}

/*
function getCanUseAP(string param)
{
	local int GotAP, UsedAP;

	parseInt(param ,"UsedAP", UsedAP) ;
	parseInt(param ,"GotAP", GotAP) ;

	nCanUseAP = GotAP - UsedAP;
}	
*/

/**
 * Ŭ���������ư��Ȱ��ȭ
 **/ 

//classic//
/*
function initClassChangeButton(bool visibleFlag)
{
	local int i;

	// ��ư��Ȱ��ȭ
	for(i = 1; i < 4; i++)
	{
		// ��ư��Ȱ��, �ڹ��躸�̵��ϼ���
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
*/

function InitializeCOD()
{
	isDualClass = false;

	Me = GetWindowHandle("DetailStatusWndClassic");
	ClassBgMain_Big = GetTextureHandle(m_WindowName $ ".ClassBgMain_Big");
	// Ŭ��������������ؽ���
	//ClassChangeLightBig    = GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig");
	//ClassChangeLightSmall1 = GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall1");
	//ClassChangeLightSmall2 = GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall2");
	//ClassChangeLightSmall3 = GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall3");

	// Ŭ�����������ؽ���
	//ClassBgMain_Big    = GetTextureHandle(m_WindowName $ ".ClassBgMain_Big");
	//ClassBgMain_Small1 = GetTextureHandle(m_WindowName $ ".ClassBgMain_Small1");
	//ClassBgMain_Small2 = GetTextureHandle(m_WindowName $ ".ClassBgMain_Small2");
	//ClassBgMain_Small3 = GetTextureHandle(m_WindowName $ ".ClassBgMain_Small3");

	// Ŭ���������ư	
	//ClassFrameBtn1 = GetButtonHandle(m_WindowName $ ".ClassFrameBtn1");
	//ClassFrameBtn2 = GetButtonHandle(m_WindowName $ ".ClassFrameBtn2");
	//ClassFrameBtn3 = GetButtonHandle(m_WindowName $ ".ClassFrameBtn3");

	// Ŭ�������渶ũ
	ClassMarkBig = GetTextureHandle(m_WindowName $ ".ClassMarkBig");
	//ClassMarkSmall1 = GetTextureHandle(m_WindowName $ ".ClassMarkSmall1");
	//ClassMarkSmall2 = GetTextureHandle(m_WindowName $ ".ClassMarkSmall2");
	//ClassMarkSmall3 = GetTextureHandle(m_WindowName $ ".ClassMarkSmall3");

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

	txtCriminalRate = GetTextBoxHandle(m_WindowName $ ".txtCriminalRate");
	//txtPVP = GetTextBoxHandle(m_WindowName $ ".txtPVP");
	txtSociality_PVP = GetTextBoxHandle(m_WindowName $ ".txtSociality_PVP");
	txtSociality_PK = GetTextBoxHandle(m_WindowName $ ".txtSociality_PK");
	txtBonusVote = GetTextBoxHandle(m_WindowName $ ".txtRemainSulffrage");
	txtDisapprove = GetTextBoxHandle(m_WindowName $ ".txtDisapprove");
	txtRaidPoint = GetTextBoxHandle(m_WindowName $ ".txtRaidPoint");
	//texHero = GetTextureHandle(m_WindowName $ ".texHero");
	texPledgeCrest = GetTextureHandle(m_WindowName $ ".texPledgeCrest");
	VitalityTex = GetTextureHandle(m_WindowName $ ".LifeForceTex");

	//txtLUC = GetTextBoxHandle(m_WindowName $ ".txtLUC");
	//txtCHA = GetTextBoxHandle(m_WindowName $ ".txtCHA");

	//texVP = GetStatusBarHandle(m_WindowName $ ".texVP");//ldw //branch121212
	SpExtractOpenBtn = GetButtonHandle(m_WindowName $ ".SPExtract_Btn");

	APActive = GetAnimTextureHandle(m_WindowName $ ".APActive");

	FightInfo_BTN = GetButtonHandle(m_WindowName $ ".FightInfo_BTN");
	BtnElementalInfo = GetButtonHandle(m_WindowName $ ".btnElementalInfo");
	BtnElementalInfo.DisableWindow();
	txtFireDefence = GetTextBoxHandle(m_WindowName $ ".txtFireDefence");
	txtWaterDefence = GetTextBoxHandle(m_WindowName $ ".txtWaterDefence");
	txtWindDefence = GetTextBoxHandle(m_WindowName $ ".txtWindDefence");
	txtEarthDefence = GetTextBoxHandle(m_WindowName $ ".txtEarthDefence");
	txtFireAttack = GetTextBoxHandle(m_WindowName $ ".txtFireAttack");
	txtWaterAttack = GetTextBoxHandle(m_WindowName $ ".txtWaterAttack");
	txtWindAttack = GetTextBoxHandle(m_WindowName $ ".txtWindAttack");
	txtEarthAttack = GetTextBoxHandle(m_WindowName $ ".txtEarthAttack");
	Element_Lock1 = GetTextureHandle(m_WindowName $ ".Element_Lock1");
	Element_Lock2 = GetTextureHandle(m_WindowName $ ".Element_Lock2");
	Element_Lock3 = GetTextureHandle(m_WindowName $ ".Element_Lock3");
	Element_Lock4 = GetTextureHandle(m_WindowName $ ".Element_Lock4");
	Element_Lock1.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(5169)));
	Element_Lock2.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(5169)));
	Element_Lock3.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(5169)));
	Element_Lock4.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(5169)));

	ElixirPoint_txt = GetTextBoxHandle(m_WindowName $ ".Statsinfo_Elixir_Win.ElixirPoint_txt");
	//------------------------------------------------------------------------------------------------------------------------------

	

	
	//AbilityOpen.SetAnchor("", EAnchorPointType.ANCHORPOINT_Top, EAnchorPointType.ANCHORPOINT_CenterCenter, 0 , 0);
	//------------------------------------------------------------------------------------------------------------------------------

	UsePoint_Apply_BTN = GetButtonHandle(m_Statsinfo_UsePoint_Win $ ".UsePoint_Apply_BTN");
	UsePoint_Cancel_BTN = GetButtonHandle(m_Statsinfo_UsePoint_Win $ ".UsePoint_Cancel_BTN");
	UsePoint_Reset_BTN = GetButtonHandle(m_Statsinfo_UsePoint_Win $ ".UsePoint_Reset_BTN");
	Statsinfo_UsePoint_text = GetTextBoxHandle(m_Statsinfo_UsePoint_Win $ ".Statsinfo_UsePoint_text");
	StatConfirmResetWnd = GetWindowHandle(m_WindowName $ ".ConfirmWnd.ResetWnd");
	StatConfirmApplyWnd = GetWindowHandle(m_WindowName $ ".ConfirmWnd.ApplyWnd");
	ConfirmWnd = GetWindowHandle(m_WindowName $ ".ConfirmWnd");
	StatConfirmResetWnd.HideWindow();
	StatConfirmApplyWnd.HideWindow();
	ConfirmWnd.HideWindow();
	ResetCharge_ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".ConfirmWnd.ResetWnd.ResetCharge_ListCtrl");
	NumPoint_text = GetTextBoxHandle(m_WindowName $ ".ConfirmWnd.ResetWnd.NumPoint_text");
	GetTextBoxHandle(m_WindowName $ ".ConfirmWnd.ResetWnd.ResetPoint_text").SetText(GetSystemString(13118) $ "/" $ GetSystemString(3155));
	Reset_Btn = GetButtonHandle(m_WindowName $ ".ConfirmWnd.ResetWnd.Reset_BTN");
	ElementalSpiritWndScript = ElementalSpiritWnd(GetScript("ElementalSpiritWnd"));

	if(!IsAdenServer())
	{
		FightInfo_BTN.HideWindow();
	}
}

//branch
// F2P ���� Ȱ�� ���� - gorillazin
/*
function UpdateVp(int Vitality)//ldw ����
{
	if(Vitality < 2205 && Vitality > 0){ // �ִ� 140000 �� ��� 1806 ���� ����â�� ������ ���� vp�� ���� ���δٴ� ���� ������ ���� ���� ó�� , statusbarWnd, lobbyMenuWnd ���� ���� ó�� �Ǿ��� ldw 2011.02.23
		texVP.SetPoint(2205, MaxVitality);		

	} else {
		texVP.SetPoint(Vitality, MaxVitality);		
	}	
}
*/
// �� function�� �ʿ� ���� �κ� �ּ� ó��
//end of branch


function OnEnterState(name a_CurrentStateName)
{
	HandleUpdateUserInfo();
}

function OnShow()
{
	if(IsUseRenewalSkillWnd())
	{
		SpExtractOpenBtn.ShowWindow();		
	}
	else
	{
		SpExtractOpenBtn.HideWindow();
	}
	SetElixirInfo();
	HandleUpdateUserInfo();
	//RequestElementalSpiritInfo();
	InitStatusInfo();
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
		HandleUpdateStatusGauge(param, 1);
	}
	else if(Event_ID == EV_UpdateMyMaxMP)
	{
		HandleUpdateStatusGauge(param, 1);
	}
	else if(Event_ID == EV_UpdateMyCP)
	{
		HandleUpdateStatusGauge(param, 2);
	}
	else if(Event_ID == EV_UpdateMyMaxCP)
	{
		HandleUpdateStatusGauge(param, 2);
	}
	else if(Event_ID == EV_ToggleDetailStatusWnd)
	{
		HandleToggle();
	}
	//classic//
	/*
	else if(Event_ID == EV_VitalityPointInfo)	// Ȱ������������Ʈ
	{
		HandleVitalityPointInfo(param);
	}
*/
	// ó�� ���� ������ ����
	else if(Event_ID == EV_NotifySubjob)
	{
		//Debug("-------------------------------");
		//Debug("EV_NotifySubjob:" @ param);
		// updateSubjobLastEvent = Event_ID;
		updateSubjobInfo(param, Event_ID);
	}
	// �Ʒ����� ���� �� ������ ������ ���� EV_CreatedSubjob �̺�Ʈ ��ü �ּ� ���� - ���� TT 75064
	else if(Event_ID == EV_CreatedSubjob)
	{
		// ���� �� ������ ������ ���� �Ʒ� �Լ��� ���� ��
		updateSubjobInfo(param, Event_ID);

		/*
		 * Show �̺�Ʈ�� ���� ���� �ʵ��� ��.
		if(Me.IsShowWindow() == false)
		{
			Me.ShowWindow();
			Me.SetFocus();
		}
		ExecuteEvent(EV_NPCDialogWndHide);
		*/
	}
	// ���� ������ �ٲ� �� ����
	else if(Event_ID == EV_ChangedSubjob)
	{
		// updateSubjobLastEvent = Event_ID;
//		Debug("EV_ChangedSubjob" @ param);
		updateSubjobInfo(param, Event_ID);
		ExecuteEvent(EV_NPCDialogWndHide);
	}
	else if(Event_ID == EV_DialogOK)
	{
		HandleDialogOK();
	}
	else if(Event_ID == EV_DialogCancel)
	{
		if(DialogIsMine())
		{
			Me.EnableWindow();
		}
	}
	//~ else if(Event_ID == EV_ShowWindow)
	//~ {
		//~ if(param == DetailStatusWnd)
		//~ {
			//~ ToggleOpenCharInfoWnd();
		//~ }
	//~ }

	//branch
	// F2P ���� Ȱ�� ���� - gorillazin
	else if(Event_ID == EV_VitalityEffectInfo)
	{
		HandleVitalityEffectInfo(param);
	}
	else if(Event_ID == EV_AdenaInvenCount || Event_ID == EV_SetMaxCount)
	{
		if(StatConfirmResetWnd.IsShowWindow())
		{
			HandleItemUpdate();
		}
	}
	else if(Event_ID == EV_Restart)
	{
		_LockElement();
	}

	//// �Ӽ� ���� ����
	//else if(Event_ID == EV_ElementalSpiritInfo)
	//{
	//	setElementalSpiritInfo(param);
	//}

	//
	//end of branch
}

//function setElementalSpiritInfo(string param)
//{

//	Debug("----------------------------");
//	Debug("���� ����" @ param);
//}


//function hideAlchemyWindow( string winName ) 
//{	
//	if(class'UIAPI_WINDOW'.static.IsShowWindow(winName))
//	{
//		class'UIAPI_WINDOW'.static.HideWindow(winName);
//	}
//}

function _LockElement()
{
	Element_Lock1.ShowWindow();
	Element_Lock2.ShowWindow();
	Element_Lock3.ShowWindow();
	Element_Lock4.ShowWindow();
	BtnElementalInfo.DisableWindow();
}

function _UnLockElement()
{
	Element_Lock1.HideWindow();
	Element_Lock2.HideWindow();
	Element_Lock3.HideWindow();
	Element_Lock4.HideWindow();
	BtnElementalInfo.EnableWindow();
}

/**
 *  ���ʵ����¼�����, �������������޾Ʊ���Ѵ�.
 **/
//classic ������ ���� job�� ������, ���� ������ �𸣴� ����.//
function updateSubjobInfo(string param, int Event_ID)
{
	local int Count, i, CurrentSubjobClassID;

	local UserInfo myUserInfo;

	local bool bFlag;

	local SubjobInfo tempSubjobInfo;

	// ����
	//local int  race;

	isDualClass = false;

	//hideAlchemyWindow("AlchemyItemConversionWnd");			
	//hideAlchemyWindow("AlchemyMixCubeWnd");

	// saveUpdateSubjobInfoParam = param;

	//GetMyUserInfo(myUserInfo);
	GetPlayerInfo(myUserInfo);

//	debug("���� Ŭ���� : " @ GetClassType(myUserInfo.nSubClass));
//	debug("������������: " @ GetClassTransferDegree(myUserInfo.nSubClass));

	// �ش������������Ϲ޴´�.
	ParseInt(param, "Count", Count);

	// ��������Ŭ�������̵�
	ParseInt(param, "currentSubjobClassID", CurrentSubjobClassID);

//	debug("������������->: " @ GetClassTransferDegree(CurrentSubjobClassID));
	//Debug("����classID ->: " @ CurrentSubjobClassID);
	// ����
	if(subjobInfoArray.Length > 0)
	{
		subjobInfoArray.Remove(0, subjobInfoArray.Length);
	}

	bFlag = false;

	ParseInt(param, "Race", Race);

//	debug("���� race:" @ Race);
	//debug("�����̸� :" @ getRacestring(Race));

	// �����⸮��Ʈ���޴´�.(0����, ������1,2,3(�ִ�))
	for(i = 0; i < Count; i++)
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

		// ��� Ŭ������ �ϳ��� �ִٸ�..
		if(subjobInfoArray[i].Type == 1)
		{
			isDualClass = true;
		//	Debug("����� �ִ�! ");
		}
	}
	for(i = 0; i < Count; i++)
	{
		if(CurrentSubjobClassID == subjobInfoArray[i].ClassID)
		{
//			Debug("���� subjobInfoArray[i].ClassID" @ subjobInfoArray[i].ClassID);
			//			currentSubjobClassNum = i;

			// ���α�ü
			tempSubjobInfo = subjobInfoArray[i];
			subjobInfoArray[i] = subjobInfoArray[0];
			subjobInfoArray[0] = tempSubjobInfo;

			currentSubjobClassNum = 0;
			break;
		}
	}

//	debug("subjobInfoArray ::::: " @ subjobInfoArray.Length);

	// ���� Ŭ������ �ִٸ�.. ��ư���� ���̵��� �ʱ�ȭ
	//if(count > 0) initClassChangeButton(true);
	//else initClassChangeButton(false);

	// ��������������Ʈ
	//  1,2,3 �������ü�����. ����ĳ����1 + ����(���) 3��= ��4��
	for(i = 1; i < Count; i++)
	{
		if(i < Count)
		{
			// Debug("-------------" @ i);
//			Debug("subjobInfoArray[i].ClassID" @ subjobInfoArray[i].ClassID);
			//---- 3����ư������Ʈ-----
			// Debug("��ư��ġ������" @ subjobInfoArray[i].ClassID);

			// �����ǻ��¿Ͱ������̿��ٸ�.. �����̴�����Ʈ
			if(beforeSubjobInfo.ClassID == subjobInfoArray[i].ClassID)
				 bFlag = true;
			else
				 bFlag = false;

			// Debug("����, ���ΰ˻� subjobInfoArray[i].Type : " @subjobInfoArray[i].Type);
			// debug("GetClassTransferDegree(myUserInfo.nSubClass)"@ GetClassTransferDegree(myUserInfo.nSubClass));
			// debug("���� race:" @ myUserInfo.Race);
			// debug("�����̸� :" @ getRacestring(myUserInfo.Race));

			/* XML �� ���� �Ⱦ��� �־ �ּ�ó��
			// ����:0, ���:1 ����:2
			// ����: û��
			if(subjobInfoArray[i].Type == 2)
			{
				if(GetClassTransferDegree(subjobInfoArray[i].ClassID) > 1)
					setclasstexture(i, "l2ui_ct1.playerstatuswnd_ClassBgSub_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[i].ClassID $ "_Small", bFlag);
				else 
					setclasstexture(i, "l2ui_ct1.playerstatuswnd_ClassBgSub_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRacestring(race) $ "_Small", bFlag);
			}			
			// ��� : �Ķ�
			else if(subjobInfoArray[i].Type == 1)
			{	
				if(GetClassTransferDegree(subjobInfoArray[i].ClassID) > 1)
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[i].ClassID $ "_Small", bFlag);
				else
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRacestring(race) $ "_Small", bFlag);
			}
			//���� :����
			else if(subjobInfoArray[i].Type == 0)
			{
				if(GetClassTransferDegree(subjobInfoArray[i].ClassID) > 1)
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[i].ClassID $ "_Small", bFlag);
				else
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Small", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ getRacestring(race) $ "_Small", bFlag);
			}

			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).EnableWindow();
			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).ShowWindow();

			// Debug("��ư " @ m_WindowName $ ".ClassFrameBtn" $ i);
			// GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i + 1).ShowWindow();

			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).SetTexture("L2UI_ct1.PlayerStatusWnd_ClassFrameBtn",
																			 "L2UI_ct1.PlayerStatusWnd_ClassFrameBtn_down",
																			 "L2UI_ct1.PlayerStatusWnd_ClassFrameBtn_over");

			GetButtonHandle(m_WindowName $ ".ClassFrameBtn" $ i).SetTooltipCustomType(subjobButtonToolTips(i));
			GetTextureHandle(m_WindowName $ ".ClassSlotBlank" $ i).HideWindow();
			*/
		}
	}

	// ---- ūŬ�����̹���������Ʈ-----
	// 2�������̻��̶��..

	// 3�� ���� �̻��� ĳ���Ͱ� �ְ� , ���� �� 1�� �̻� �ִٸ�, ������ Ŭ���� �������� ����
	//if(GetClassTransferDegree(myUserInfo.nSubClass) > 1 && count > 1)

	// debug("myUserInfo.nSubClass >: " @ myUserInfo.nSubClass);
	// debug("GetClassTransferDegree(myUserInfo.nSubClass) >: " @ GetClassTransferDegree(myUserInfo.nSubClass));


	// ����:0, ���:1 ����:2
	// 4�� ���� �� ĳ���Ͷ��..
	if(GetClassTransferDegree(subjobInfoArray[currentSubjobClassNum].ClassID) > 0)
	{
		// ��ü�Ȼ��¶������Ʈ���
		if(EV_ChangedSubjob == Event_ID)
			bFlag = true;
		else
			bFlag = false;

		// debug("����ֵ�:" @ subjobInfoArray[currentSubjobClassNum].Type);
		// �����û��
		if(subjobInfoArray[currentSubjobClassNum].Type == 2)
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[currentSubjobClassNum].ClassID $ "_Big", bFlag);
		}
		// ���,����������0: ����, 1 ���
		else if(subjobInfoArray[currentSubjobClassNum].Type == 1)
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Big", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[currentSubjobClassNum].ClassID $ "_Big", bFlag);
		}
		else if(subjobInfoArray[currentSubjobClassNum].Type == 0)
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Big", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ subjobInfoArray[currentSubjobClassNum].ClassID $ "_Big", bFlag);
		}
	}
	else
	{
		// �����û��
		if(subjobInfoArray[currentSubjobClassNum].Type == 2)
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(Race) $ "_Big", false);
		}
		// ���,����������0: ����, 1 ���
		else if(subjobInfoArray[currentSubjobClassNum].Type == 1)
		{
			// �������� ����.. 1�� ������ ���� ������ ������
			//initClassChangeButton(false);
			// ���������ɺ��̹���
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Big", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(Race) $ "_Big", false);
		}
		else if(subjobInfoArray[currentSubjobClassNum].Type == 0)
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Big", "l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(Race) $ "_Big", false);
		}

		// UserInfo(
		// �����ؾ���race
		// Debug("������---::" @ myUserInfo.race);
		
		//GetRaceTicketstring(int Blessed);
	}

	beforeSubjobInfo = subjobInfoArray[currentSubjobClassNum];

	// Type : 0 ����, 1 ���. 2 ����
	// debug("myUserInfo.Class : " @ GetClassRoleName(classID)) ;
	
		//native final function string GetClassStr(int ClassID); 
	// CurrentSubjobClassID=3 Count=3 SubjobID_1=1 SubjobClassID_1=117 SubjobLevel_1=55 SubjobType_1=0 SubjobID_2=1 SubjobClassID_2=73 SubjobLevel_2=55 SubjobType_2=1 SubjobID_3=1 SubjobClassID_3=131 SubjobLevel_3=55 SubjobType_3=2
	// CurrentSubjobClassID=3 Count=3 SubjobID_1=1 SubjobClassID_1=117 SubjobLevel_1=55 SubjobType_1=1 SubjobID_2=1 SubjobClassID_2=73 SubjobLevel_2=55 SubjobType_2=1 SubjobID_3=1 SubjobClassID_3=131 SubjobLevel_3=55 SubjobType_3=1 
	// CurrentSubjobClassID=3 Count=1 SubjobID_1=1 SubjobClassID_1=134 SubjobLevel_1=55 SubjobType_1=1
}


/** ���̾�α׹ڽ�OK Ŭ����*/
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
				// subjobInfoArray[dialogValue].Type  // 0����, 1���, 2����
				case 0:
				case 1:
				case 2:
				case 3:
					ExecuteEvent(EV_NPCDialogWndHide);
					// Debug("subjobInfoArray[dialogValue].Type  "  @ subjobInfoArray[dialogValue].Type);
					// ����, ����̶��..
					if(subjobInfoArray[dialogValue].Type == 0)
					{
						// ��ų ��ȣ�� 
						infItem.ID.ClassID = 1566;

						//infItem.ID.ServerID = 1566;
						// ����Ŭ�����κ���
						// Debug("���� ��ų���" @ infItem.ID.ClassID);
						UseSkill(infItem.ID, int(EShortCutItemType.SCIT_SKILL));
						// ExecuteCommand("//use_skill 1566 1");
					}
					else
					{
						// ��� �̶��.. ó��
						if(subjobInfoArray[dialogValue].Type == 1)
						{
							// ���� ����
							// empty
						}

						// 1567, 1568, 1569 �����Ƿ�.. ���꽽��1,2,3 ����
						infItem.ID.ClassID = 1567 + (dialogValue - 1);
						//infItem.ID.ServerID = 1568 +(dialogValue - 1);

						// Debug("��ų���" @ infItem.ID.ClassID);
						UseSkill(infItem.ID, int(EShortCutItemType.SCIT_SKILL));
						// ExecuteCommand("//use_skill " $ string(infItem.ID.ClassID) $ " 1");
					}

				default:
					// ���潺ų���
					Me.EnableWindow();
					break;
			}
		}
	}
}

/**
 * ���̾�α׹ڽ�(����Ŭ�����κ�����������´��̾�α�)
 * 0..1..2 
 **/
function askDialogBox(int currentClickSubjobNum)
{
	local WindowHandle m_dialogWnd;

	m_dialogWnd = GetWindowHandle("DialogBox");

	if(!m_dialogWnd.IsShowWindow())
	{
		// ����Ŭ������Ŭ���Ѽ���Ŭ�����������ʴٸ�.. �����������.
		if(subjobInfoArray[0].ClassID != subjobInfoArray[currentClickSubjobNum].ClassID)
		{
			DialogSetID(DIALOG_DetailStatusWnd);

			DialogSetReservedInt(currentClickSubjobNum);

			// ����Ŭ����, �Һ긵��, ����ҿ�����Ŀ, �κ����Ͻðڽ��ϱ�?   �̷���
			Me.DisableWindow();
			DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(3280), "<" $ GetClassType(subjobInfoArray[0].ClassID) $ "> " $ getSubjobTypeStr(subjobInfoArray[0].Type) $ "", "<" $ GetClassType(subjobInfoArray[currentClickSubjobNum].ClassID) $ "> " $ getSubjobTypeStr(subjobInfoArray[currentClickSubjobNum].Type) $ ""), string(self));
		}
	}
}

/***
 *  ���缭���⽺Ʈ�������Ϲ޴´�.
 **/
function string getSubjobTypeStr(int nType)
{
	local string tempStr;

	// 0 ����, 1 ���(����¸�������ó��-����̶�¿��¾���������) , 2 ����
	switch(nType)
	{
		case 0 : tempStr = GetSystemstring(2340); break; // ����Ŭ����
		case 1 : tempStr = GetSystemstring(2737); break; // ���Ŭ����
		case 2 : tempStr = GetSystemstring(2339); break; // ����Ŭ����
	}
	return tempStr;
}

/**
 * OnClickButton
 **/
function OnClickButton(string strID)
{
	// debug("strID : " $ strID);

	switch(strID)
	{
		case "btnElementalInfo":
			if(class'UIAPI_WINDOW'.static.IsShowWindow("elementalSpiritWnd"))
			{
				class'UIAPI_WINDOW'.static.HideWindow("elementalSpiritWnd");
			}
			else
			{
				ElementalSpiritWnd(GetScript("ElementalSpiritWnd"))._API_RequestElementalSpiritInfo(true);
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
		case "UsePoint_Apply_BTN":
			StatConfirmApplyWnd.ShowWindow();
			ConfirmWnd.ShowWindow();
			ConfirmWnd.SetFocus();
			break;
		case "UsePoint_Reset_BTN":
			HandleShowResetWindow();
			break;
		case "UsePoint_Cancel_BTN":
			HandleOnCliCKUsePointCancel();
			break;
		case "Cancel_BTN":
			StatConfirmApplyWnd.HideWindow();
			StatConfirmResetWnd.HideWindow();
			ConfirmWnd.HideWindow();
			break;
		case "Apply_BTN":
			API_C_EX_SET_STATUS_BONUS();
			HandleOnCliCKUsePointCancel();
			StatConfirmApplyWnd.HideWindow();
			ConfirmWnd.HideWindow();
			break;
		case "Reset_BTN":
			API_C_EX_RESET_STATUS_BONUS();
			HandleOnCliCKUsePointCancel();
			StatConfirmResetWnd.HideWindow();
			ConfirmWnd.HideWindow();
			break;
		case "FightInfo_BTN":
			if(class'UIAPI_WINDOW'.static.IsShowWindow("InfoFightWndClassic"))
			{
				class'UIAPI_WINDOW'.static.HideWindow("InfoFightWndClassic");				
			}
			else
			{
				class'UIAPI_WINDOW'.static.ShowWindow("InfoFightWndClassic");
				class'UIAPI_WINDOW'.static.SetFocus("InfoFightWndClassic");
			}
			break;
		case "SPExtract_Btn":
			toggleWindow("SkillSpExtractWnd", true, true);
			break;
/*
		case "ClassFrameBtn1" : if(GetButtonHandle(m_WindowName $ ".ClassFrameBtn1").IsEnableWindow() && subjobInfoArray.Length > 1) 
								{ ExecuteEvent(EV_NPCDialogWndHide); effectAniTexture(1); askDialogBox(1); } break;
		case "ClassFrameBtn2" : if(GetButtonHandle(m_WindowName $ ".ClassFrameBtn2").IsEnableWindow() && subjobInfoArray.Length > 2) 
								{ ExecuteEvent(EV_NPCDialogWndHide); effectAniTexture(2); askDialogBox(2); } break;
		case "ClassFrameBtn3" : if(GetButtonHandle(m_WindowName $ ".ClassFrameBtn3").IsEnableWindow() && subjobInfoArray.Length > 3) 
								{ ExecuteEvent(EV_NPCDialogWndHide); effectAniTexture(3); askDialogBox(3); } break;
*/
	}
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	switch(a_ButtonHandle.GetWindowName())
	{
		case "Statsinfo_PointPlusNum_BTN":
			HandleOnClickPlusBtn(int(Right(a_ButtonHandle.GetParentWindowName(), 1)));
			break;
		case "Statsinfo_PointMinusNum_BTN":
			HandleOnClickMinusBtn(int(Right(a_ButtonHandle.GetParentWindowName(), 1)));
			break;
	}
}

/**
 *  ��ư�ִ�����Ʈ(1 ~ 3 ����ưȿ��) 
 **/
function effectAniTexture(int TargetType)
{
	GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall" $ TargetType).SetTexture("l2ui_ct1.PlayerStatusWnd_ClassChangeLightSmall_00");
	GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall" $ TargetType).ShowWindow();
	GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall" $ TargetType).SetLoopCount(1);
	GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall" $ TargetType).Stop();
	GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall" $ TargetType).Play();
}

/**
 * setClassTexture 
 * 
 * Ŭ���������, �ؽ��ı�ü, ��������ũ�ؽ���, ��¦�Ÿ���ȿ�������ٰ�����..
 **/
function setClassTexture(int TargetType, string bgTexture, string markTextureStr, bool effectFlag)
{
	if(TargetType == 0)
	{
		// ū����Ŭ����(����Ŭ����)

		// ���
		ClassBgMain_Big.SetTexture(bgTexture);
		// debug("bgTexture" @ bgTexture);

		// ��ũ����
		//debug("markTextureStr : " @ markTextureStr);
		ClassMarkBig.SetTexture(markTextureStr);
		// ClassMarkBig.HideWindow();

		// �����̴�ȿ�������ֱ�
		if(effectFlag == true)
		{
			GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").SetTexture("l2ui_ct1.PlayerStatusWnd_ClassChangeLightBig_00");
			GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").ShowWindow();
			GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").SetLoopCount(1);
			GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").Stop();
			GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").Play();
		}
	}

	/* XML �� ���� �Ⱦ��� �־ �ּ�ó��
	else
	{
		// ���
		GetTextureHandle(m_WindowName $ ".ClassBgMain_Small" $ targetType).SetTexture(bgTexture);
		
		// GetTextureHandle(m_WindowName $ ".ClassBgMain_Small" $ targetType).SetAlpha(255);
		// Debug("���bgTexture " @ bgTexture);

		// ��ũ����
		GetTextureHandle(m_WindowName $ ".ClassMarkSmall" $ targetType).SetTexture(markTextureStr);
		GetTextureHandle(m_WindowName $ ".ClassMarkSmall" $ targetType).ShowWindow();
		

		// �����̴�ȿ�������ֱ�
		//GetTextureHandle(m_WindowName $ ".ClassChangeLightSmall" $ targetType).SetTexture("");		

		if(effectFlag == true)
		{			
			effectAniTexture(targetType);
		}
	}
	*/
}

function HandleToggle()
{
	if(!getInstanceUIData().getIsClassicServer())
	{
		return;
	}
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

//��������������Ʈ
function HandleUpdateStatusGauge(string param, int Type)
{
	local int ServerID;

	if(m_hOwnerWnd.IsShowWindow())	// lpislhy
	{
		ParseInt(param, "ServerID", ServerID);

		if(m_UserID == ServerID)
		{
			HandleUpdateUserGauge(Type);
		}
	}
}

//�÷��̾��ǹ�������ó��
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

	//�űԽ��� ī������ ��Ű
	ParseInt(param, "LUCnow", m_HennaInfo.LUCnow);
	ParseInt(param, "LUCchange", m_HennaInfo.LUCchange);

	ParseInt(param, "CHAnow", m_HennaInfo.CHAnow);
	ParseInt(param, "CHAchange", m_HennaInfo.CHAchange);
}

function bool GetMyUserInfo(out UserInfo a_MyUserInfo)
{
	return GetPlayerInfo(a_MyUserInfo);
}

function string GetMovingSpeed(UserInfo a_UserInfo)
{
	local float MovingSpeed;
	local EMoveType MoveType;
	local EEnvType EnvType;

	// Moving Speed
	MoveType = class'UIDATA_PLAYER'.static.GetPlayerMoveType();
	EnvType = class'UIDATA_PLAYER'.static.GetPlayerEnvironment();

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
	return string(appRound(MovingSpeed));
}

function float GetMyExpRate()
{
	return class'UIDATA_PLAYER'.static.GetPlayerEXPRate() * 100.0f;
}

//�÷��̾����������ó��
function HandleUpdateUserGauge(int Type)
{
	local int CurValue;
	local int MaxValue;
	local int Vitality;
	local UserInfo Info;

	if(GetMyUserInfo(Info))
	{
		Vitality = Info.nVitality;
		m_UserID = Info.nID;

		switch(Type)
		{
			case 0:
				CurValue = Info.nCurHP;
				MaxValue = Info.nMaxHP;
				UpdateHPBar(CurValue, MaxValue);
				break;
			case 1:
				CurValue = Info.nCurMP;
				MaxValue = Info.nMaxMP;
				UpdateMPBar(CurValue, MaxValue);
				break;
			case 2:
				CurValue = Info.nCurCP;
				MaxValue = Info.nMaxCP;
				UpdateCPBar(CurValue, MaxValue);
				break;

//		UpdateVp(Vitality);
		}
	}
}

//�÷��̾�����ó��
function HandleUpdateUserInfo()
{
	if(m_hOwnerWnd.IsShowWindow())	// lpislhy
	{
		UpdateInterface();
	}
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
	local int SubClassID;
	local string ClassName;
	local string UserRank;
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

	local int		PhysicalAttack;
	local int		PhysicalDefense;
	local int		HitRate;
	local int		CriticalRate;
	local int		PhysicalAttackSpeed;
	local int		MagicalAttack;
	local int		MagicDefense;
	local int		PhysicalAvoid;
	local string	MovingSpeed;
	local int		MagicCastingSpeed;

	local int		CriminalRate;
	local int		iNameColorRate;
	local string	strCriminalRate;
	local int		DualCount;
	local int		PKCount;
	//local int		PvPPoint;
	
	local int		VoteCount;
	local int		BonusCount;
	local int		NegativeVoteCount;
	local int		Notoriety;

	local int       RaidPoint;

	local int nMagicAvoid, nMagicHitRate, nMagicCriticalRate;

	//���Ű��õ�����
	//local int nTransformID;
	local int activatedElixirPoint;
	
	local UserInfo	info;
	
	//Ȱ��
	//local int Vitality;
	
	//�ʱ�ȭ
	texPledgeCrest.SetTexture("");

	rectWnd = m_hOwnerWnd.GetRect();

	if(GetMyUserInfo(Info))
	{
		StatesByUserInfoUpdate(Info);
		HandleOnChangeState();

		// ClassChangeLightBig.SetTexture("");
		// ClassChangeLightSmall1.SetTexture("");
		// ClassChangeLightSmall2.SetTexture("");
		//ClassChangeLightSmall3.SetTexture(""); 
		// Debug("info race"  @ Info.race);

		m_UserID = Info.nID;
		Name = Info.Name;
		NickName = Info.strNickName;
		SubClassID = Info.nSubClass;
		ClassName = GetClassType(SubClassID);
		SP = Info.nSP;
		Level = Info.nLevel;
		UserRank = GetUserRankString(Info.nUserRank);
		HP = Info.nCurHP;
		MaxHP = Info.nMaxHP;
		MP = Info.nCurMP;
		MaxMP = Info.nMaxMP;
		CP = Info.nCurCP;
		MaxCP = Info.nMaxCP;
		PledgeID = Info.nClanID;
		NickNameColor = Info.NicknameColor;
		PhysicalAttack = Info.nPhysicalAttack;
		PhysicalDefense = Info.nPhysicalDefense;
		HitRate = Info.nHitRate;
		CriticalRate = Info.nCriticalRate;

		if(IsUseSkillCastingSpeedStat())
		{
			PhysicalAttackSpeed = Info.nPhysicalSkillCastingSpeed;
		}
		else
		{
			PhysicalAttackSpeed = Info.nPhysicalAttackSpeed;
		}
		MagicalAttack = Info.nMagicalAttack;
		MagicDefense = Info.nMagicDefense;
		PhysicalAvoid = Info.nPhysicalAvoid;
		MagicCastingSpeed = Info.nMagicCastingSpeed;
		MovingSpeed = GetMovingSpeed(Info);
		CriminalRate = Info.nCriminalRate;
		DualCount = Info.nDualCount;
		PKCount = Info.nPKCount;
		VoteCount = Info.nVoteCount;
		BonusCount = Info.nBonusCount;
		NegativeVoteCount = Info.nNegativeVoteCount;
		Notoriety = Info.nNotoriety;

		RaidPoint = Info.RaidPoint;

		//Vitality = info.nVitality;
		
		// �ű� �߰�  2010.10.11 CT3 ���� ���� ����
		nMagicAvoid = Info.nMagicAvoid;
		nMagicHitRate = Info.nMagicHitRate;
		nMagicCriticalRate = Info.nMagicCriticalRate;
		activatedElixirPoint = Info.nActivatedElixirPoint;
	}
	if(CriminalRate > 0)
	{
		iNameColorRate = Min(100 + (CriminalRate / 100), 255);
		NameColor.R = 0;
		NameColor.G = iNameColorRate;
		NameColor.B = 0;
		NameColor.A = 255;

		if(CriminalRate > 999999)
		{
			strCriminalRate = string(999999) $ " (+)";
		}
		else
		{
			strCriminalRate = string(CriminalRate);
		}
	}
	else if(CriminalRate < 0)
	{
		iNameColorRate = Min(100 + (-CriminalRate / 100), 255);
		NameColor.R = iNameColorRate;
		NameColor.G = 0;
		NameColor.B = 0;
		NameColor.A = 255;

		if(CriminalRate <- 999999)
		{
			strCriminalRate = string(-999999) $ " (+)";
		}
		else
		{
			strCriminalRate = string(CriminalRate);
		}
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

	if(Len(NickName) > 0)
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
				GetTextSizeDefault(NickName, Width2, Height2);
			}
		}
		txtName1.SetFormatString(NickName);
		txtName1.SetTextColor(NickNameColor);
		txtName2.SetText(Name);
		txtName2.SetTextColor(NameColor);
		txtName2.MoveTo(rectWnd.nX + 15 + Width2 + 47, rectWnd.nY + 41); //~ debug("��..:rectWnd: " @ rectWnd.nY );
	}
	else
	{
		txtName1.SetText(Name);
		txtName1.SetTextColor(NameColor);
		txtName2.SetText("");
	}

	txtLvName.SetText("" $ Level);
	txtClassName.SetText(ClassName);
	// Debug("=====:: ClassName " @ ClassName);
	txtRank.SetText(UserRank);

	txtSP.SetText(string(SP));

	//����
	if(PledgeID > 0)
	{
		//�ؽ���
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

	// �����̹������ִٸ�..
	if(bPledgeCrestTexture)
	{
		texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);
		txtPledge.MoveTo(rectWnd.nX + 118, rectWnd.nY + 59); //����
	}
	else
	{
		// �����̹��������ٸ�..
		txtPledge.MoveTo(rectWnd.nX + 86, rectWnd.nY + 59);
	}

	nMagicAvoid = Info.nMagicAvoid;
	nMagicHitRate = Info.nMagicHitRate;
	nMagicCriticalRate = Info.nMagicCriticalRate;
	GetTextBoxHandle(m_WindowName $ ".txtMagicAvoid").SetText(string(nMagicAvoid));
	GetTextBoxHandle(m_WindowName $ ".txtMagicHit").SetText(string(nMagicHitRate));
	GetTextBoxHandle(m_WindowName $ ".txtMagicCritical").SetText(string(nMagicCriticalRate));
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

	if(int(strCriminalRate) < 0)
	{
		txtCriminalRate.SetTextColor(NameColor);		
	}
	else
	{
		txtCriminalRate.SetTextColor(GetColor(200, 200, 200, 255));
	}
	txtCriminalRate.SetText(strCriminalRate);
	//txtPVP.SetText(string(PvPPoint));
	txtSociality_PVP.SetText(string(DualCount));

	if(PKCount > 0)
	{
		txtSociality_PK.SetTextColor(GetColor(255, 102, 102, 255));		
	}
	else
	{
		txtSociality_PK.SetTextColor(GetColor(200, 200, 200, 255));
	}
	txtSociality_PK.SetText(string(PKCount));
	txtBonusVote.SetText(string(BonusCount) $ " / " $ string(VoteCount));
	txtRaidPoint.SetText(string(RaidPoint));

	UpdateHPBar(HP, MaxHP);
	UpdateMPBar(MP, MaxMP);
	UpdateCPBar(CP, MaxCP);
	UpdateEXPBar(Info.fExpPercentRate);

	txtFireDefence.SetText(string(Info.nFireDefend));
	txtWaterDefence.SetText(string(Info.nWaterDefend));
	txtWindDefence.SetText(string(Info.nWindDefend));
	txtEarthDefence.SetText(string(Info.nEarthDefend));
	txtFireAttack.SetText(string(Info.nFireAttack));
	txtWaterAttack.SetText(string(Info.nWaterAttack));
	txtWindAttack.SetText(string(Info.nWindAttack));
	txtEarthAttack.SetText(string(Info.nEarthAttack));
	txtDisapprove.SetText(string(Notoriety) $ " / " $ string(NegativeVoteCount));
	ElixirPoint_txt.SetText(string(activatedElixirPoint) $ "/" $ string(API_GetMaxElixir()));
}

//HP�ٰ���
function UpdateHPBar(int Value, int MaxValue)
{
	texHP.SetPoint(Value, MaxValue);
}

//MP�ٰ���
function UpdateMPBar(int Value, int MaxValue)
{
	texMP.SetPoint(Value, MaxValue);
}

//EXP�ٰ���
function UpdateEXPBar(float ExpPercent)
{
	texEXP.SetPointExpPercentRate(ExpPercent);
}

//CP�ٰ���
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

//branch
// F2P ���� Ȱ�� ���� - gorillazin
function HandleVitalityEffectInfo(string param)
{
	local CustomTooltip T;
	local string tmpStr;
	local string sSysMsgParamString;
	local int nVitality;
	local int nVitalityBonus;
	local int nVitalityItemRestoreCount;

	ParseInt(param, "vitalityPoint", nVitality);
	ParseInt(param, "vitalityBonus", nVitalityBonus);
	ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
	// maxRestoreCount �� ���� ������ �� UI������ ������� �ʽ��ϴ�.

	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(T);
	util.ToopTipInsertText(GetSystemString(2494), true, false);

	//Ȱ���� 0�� ���, Ȱ���� 20�� ��� �� �� ���� ���� ��.
	if(nVitality <= 0)
	{
		tmpStr = GetSystemString(2496);
		util.ToopTipInsertText(tmpStr, true, false, util.ETooltipTextType.COLOR_GRAY);

		tmpStr = ", ";
		util.ToopTipInsertText(tmpStr, true, false);
		sSysMsgParamString = "";
		tmpStr = "";
		ParamAdd(sSysMsgParamString, "Type", string(int(ESystemMsgParamType.SMPT_NUMBER)));
		ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemRestoreCount));
		AddSystemMessageParam(sSysMsgParamString);
		tmpStr = EndSystemMessageParam(6073, true);

		util.ToopTipInsertText(tmpStr, true, false);
	}
	else
	{
		sSysMsgParamString = "";
		tmpStr = "";
		ParamAdd(sSysMsgParamString, "Type", string(int(ESystemMsgParamType.SMPT_NUMBER)));
		ParamAdd(sSysMsgParamString, "param1", string(nVitalityBonus));
		AddSystemMessageParam(sSysMsgParamString);
		tmpStr = EndSystemMessageParam(6072, true);
		util.ToopTipInsertText(tmpStr, true, false);

		tmpStr = " ";
		util.ToopTipInsertText(tmpStr, true, false);

		tmpStr = "";
		sSysMsgParamString = "";
		ParamAdd(sSysMsgParamString, "Type", string(int(ESystemMsgParamType.SMPT_NUMBER)));
		ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemRestoreCount));
		AddSystemMessageParam(sSysMsgParamString);
		tmpStr = EndSystemMessageParam(6073, true);

		util.ToopTipInsertText(tmpStr, true, false);
	}

	//texVP.SetTooltipCustomType(util.getCustomToolTip());//bluesun Ŀ���͸����� ����
}
//
//end of branch

function InitStatusInfo()
{
	local int i;
	local UserInfo uInfo;

	if(!GetPlayerInfo(uInfo))
	{
		return;
	}
	statusPlused.Length = 6;
	StatConfirmApplyWnd.HideWindow();
	StatConfirmResetWnd.HideWindow();
	ConfirmWnd.HideWindow();

	for(i = 0;i < 6; i++)
	{
		GetPlusWindowByIndex(i).HideWindow();
		GetTxtBoxHandlePlusByIndex(i).SetText("0");
		GetTxtBoxHandlePlusByIndex(i).SetTextColor(GetColor(150, 150, 150, 255));
		statusPlused[i] = 0;
	}
	StatesByUserInfoUpdate(uInfo);
	CheckStatusButtomBtns(false);
}

function StatesByUserInfoUpdate(UserInfo uInfo)
{
	local int i;

	statusCanPlus = uInfo.nTotalBonus - GetTotalBonusAdded(uInfo) - GetAllStatusPlused();
	statusMax = uInfo.nTotalBonus;

	for(i = 0;i < 6; i++)
	{
		GetTxtBoxHandleBasicByIndex(i).SetText(string(GetStatusStatByIndex(i, uInfo)));

		if(GetStatusBonusByType(i, uInfo) > 0)
		{
			GetTextureHandleAddedByIndex(i).ShowWindow();
		} else {
			GetTextureHandleAddedByIndex(i).HideWindow();
		}
	}
	CheckStatusResetButton(uInfo);
	SetCanUsePointText();
	CheckStatusPlusButtons();
	CheckStatusMinusButtons();
	GetWindowHandle(GetStatusPlusPathByIndex(0)).SetTooltipCustomType(MakeStatusCustomTooltip(GetSystemString(3366), 0, uInfo));
	GetWindowHandle(GetStatusPlusPathByIndex(2)).SetTooltipCustomType(MakeStatusCustomTooltip(GetSystemString(3368), 2, uInfo));
	GetWindowHandle(GetStatusPlusPathByIndex(4)).SetTooltipCustomType(MakeStatusCustomTooltip(GetSystemString(3370), 4, uInfo));
	GetWindowHandle(GetStatusPlusPathByIndex(1)).SetTooltipCustomType(MakeStatusCustomTooltip(GetSystemString(3367), 1, uInfo));
	GetWindowHandle(GetStatusPlusPathByIndex(3)).SetTooltipCustomType(MakeStatusCustomTooltip(GetSystemString(3369), 3, uInfo));
	GetWindowHandle(GetStatusPlusPathByIndex(5)).SetTooltipCustomType(MakeStatusCustomTooltip(GetSystemString(3371), 5, uInfo));
	StatBonusWndClassic(GetScript("StatBonusWndClassic")).ResetData();
}

function CustomTooltip MakeStatusCustomTooltip(string Title, int Type, UserInfo uInfo)
{
	local CustomTooltip m_Tooltip;
	local int basicStatus;
	local int hennaItemSkillStatus;
	local int bonusStatus;
	local int currentindex;

	basicStatus = GetStatusStatByIndex(Type, uInfo);
	hennaItemSkillStatus = GetStatusHennaSkillItemBonusByType(Type, uInfo);
	bonusStatus = GetStatusBonusByType(Type, uInfo);
	m_Tooltip.DrawList.Length = 3;
	m_Tooltip.MinimumWidth = 214;
	m_Tooltip.DrawList[0].eType = DIT_TEXT;
	m_Tooltip.DrawList[0].t_color.R = 200;
	m_Tooltip.DrawList[0].t_color.G = 200;
	m_Tooltip.DrawList[0].t_color.B = 200;
	m_Tooltip.DrawList[0].t_color.A = 255;
	m_Tooltip.DrawList[0].t_strText = Title;
	m_Tooltip.DrawList[1].bLineBreak = true;
	m_Tooltip.DrawList[1].eType = DIT_TEXT;
	m_Tooltip.DrawList[1].t_color.R = 153;
	m_Tooltip.DrawList[1].t_color.G = 153;
	m_Tooltip.DrawList[1].t_color.B = 153;
	m_Tooltip.DrawList[1].t_color.A = 255;
	m_Tooltip.DrawList[1].t_strText = GetSystemString(103) @ ": ";
	m_Tooltip.DrawList[2].eType = DIT_TEXT;
	m_Tooltip.DrawList[2].t_color.R = 187;
	m_Tooltip.DrawList[2].t_color.G = 170;
	m_Tooltip.DrawList[2].t_color.B = 136;
	m_Tooltip.DrawList[2].t_color.A = 255;
	m_Tooltip.DrawList[2].t_strText = string(basicStatus - bonusStatus - hennaItemSkillStatus);
	currentindex = m_Tooltip.DrawList.Length;

	if(hennaItemSkillStatus != 0)
	{
		m_Tooltip.DrawList.Length = m_Tooltip.DrawList.Length + 2;
		m_Tooltip.DrawList[currentindex].bLineBreak = true;
		m_Tooltip.DrawList[currentindex].eType = DIT_TEXT;
		m_Tooltip.DrawList[currentindex].t_color.R = 153;
		m_Tooltip.DrawList[currentindex].t_color.G = 153;
		m_Tooltip.DrawList[currentindex].t_color.B = 153;
		m_Tooltip.DrawList[currentindex].t_color.A = 255;
		m_Tooltip.DrawList[currentindex].t_strText = GetSystemString(13165) $ " : ";
		currentindex = currentindex + 1;
		m_Tooltip.DrawList[currentindex].eType = DIT_TEXT;
		m_Tooltip.DrawList[currentindex].t_color.R = 187;
		m_Tooltip.DrawList[currentindex].t_color.G = 170;
		m_Tooltip.DrawList[currentindex].t_color.B = 136;
		m_Tooltip.DrawList[currentindex].t_color.A = 255;
		m_Tooltip.DrawList[currentindex].t_strText = string(hennaItemSkillStatus);
		currentindex = currentindex + 1;
	}
	if(bonusStatus > 0)
	{
		m_Tooltip.DrawList.Length = m_Tooltip.DrawList.Length + 2;
		m_Tooltip.DrawList[currentindex].bLineBreak = true;
		m_Tooltip.DrawList[currentindex].eType = DIT_TEXT;
		m_Tooltip.DrawList[currentindex].t_color.R = 153;
		m_Tooltip.DrawList[currentindex].t_color.G = 153;
		m_Tooltip.DrawList[currentindex].t_color.B = 153;
		m_Tooltip.DrawList[currentindex].t_color.A = 255;
		m_Tooltip.DrawList[currentindex].t_strText = GetSystemString(13117) @ ": ";
		currentindex = currentindex + 1;
		m_Tooltip.DrawList[currentindex].eType = DIT_TEXT;
		m_Tooltip.DrawList[currentindex].t_color.R = 187;
		m_Tooltip.DrawList[currentindex].t_color.G = 170;
		m_Tooltip.DrawList[currentindex].t_color.B = 136;
		m_Tooltip.DrawList[currentindex].t_color.A = 255;
		m_Tooltip.DrawList[currentindex].t_strText = string(bonusStatus);
	}
	return m_Tooltip;
}

function CheckStatusResetButton(UserInfo uInfo)
{
	if(GetTotalBonusAdded(uInfo) > 0)
	{
		UsePoint_Reset_BTN.EnableWindow();
	} else {
		UsePoint_Reset_BTN.DisableWindow();
	}
}

function bool GetIsPlused()
{
	local int i;

	for(i = 0;i < 6; i++)
	{
		if(statusPlused[i] > 0)
		{
			return true;
		}
	}
	return false;
}

function int GetAllStatusPlused()
{
	local int i;
	local int allplused;

	for(i = 0;i < 6; i++)
	{
		allplused = allplused + statusPlused[i];
	}
	return allplused;
}

function SetCanUsePointText()
{
	local int statusCanPlusUInt;

	statusCanPlusUInt = statusCanPlus;

	if(statusCanPlusUInt < 0)
	{
		statusCanPlusUInt = 0;
	}
	Statsinfo_UsePoint_text.SetText(string(statusCanPlusUInt) $ "/" $ string(statusMax));
}

function HandleOnCliCKUsePointCancel()
{
	local int i;

	statusCanPlus = statusCanPlus + GetAllStatusPlused();

	for(i = 0;i < 6; i++)
	{
		HandleUsePointCancelByType(i);
	}
	CheckStatusButtomBtns(false);
	SetCanUsePointText();
}

function HandleUsePointCancelByType(int Type)
{
	GetPlusWindowByIndex(Type).HideWindow();
	GetTxtBoxHandlePlusByIndex(Type).SetText("0");
	GetTxtBoxHandlePlusByIndex(Type).SetTextColor(GetColor(150, 150, 150, 255));
	statusPlused[Type] = 0;
	GetStatusPlusBtnByIndex(Type).EnableWindow();
	GetStatusMinusBtnByIndex(Type).DisableWindow();
	StatBonusWndClassic(GetScript("StatBonusWndClassic")).HandleOnChangedStatusType(Type);
}

function HandleShowResetWindow()
{
	HandleItemUpdate();
	StatConfirmResetWnd.ShowWindow();
	ConfirmWnd.ShowWindow();
	ConfirmWnd.SetFocus();
	getInstanceL2Util().ItemRelationWindowHide("DetailStatusWndClassic.ConfirmWnd");
}

function HandleItemUpdate()
{
	local UserInfo uInfo;
	local array<RequestItem> arrStatBonusResetUIData;
	local int i;

	arrStatBonusResetUIData = API_GetStatBonusResetData();

	if(!GetPlayerInfo(uInfo))
	{
		return;
	}
	ResetCharge_ListCtrl.DeleteAllItem();
	Reset_Btn.EnableWindow();

	for(i = 0;i < arrStatBonusResetUIData.Length; i++)
	{
		ResetCharge_ListCtrl.InsertRecord(MakeRowDataStatusResetNeedItem(arrStatBonusResetUIData[i].Id, arrStatBonusResetUIData[i].Amount));
	}
	NumPoint_text.SetText(string(GetTotalBonusAdded(uInfo)) $ "/" $ string(uInfo.nTotalBonus));
}

function RichListCtrlRowData MakeRowDataStatusResetNeedItem(int ClassID, INT64 Amount)
{
	local RichListCtrlRowData RowData;
	local Color itemNumColor;
	local ItemID cID;
	local InventoryWnd inventoryWndScript;
	local INT64 ItemCount;

	RowData.cellDataList.Length = 1;
	cID.ClassID = ClassID;
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, class'UIDATA_ITEM'.static.GetItemTextureName(cID), 32, 32, -34, 1);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, class'UIDATA_ITEM'.static.GetItemName(cID), util.BrightWhite, false, 5, 0);
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	ItemCount = inventoryWndScript.getItemCountByClassID(ClassID);

	if(ItemCount < Amount)
	{
		Reset_Btn.DisableWindow();
		itemNumColor = GetColor(255, 0, 0, 255);
	} else {
		itemNumColor = GetColor(0, 176, 255, 255);
	}

	addRichListCtrlString(RowData.cellDataList[0].drawitems, "x" $ MakeCostStringINT64(Amount), util.White, true, 40, 5);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, " (" $ MakeCostStringINT64(ItemCount) $ ")", itemNumColor, false);
	return RowData;
}

function HandleOnClickMinusBtn(int Type)
{
	if(statusPlused[Type] == 0)
	{
		return;
	}
	statusPlused[Type] = statusPlused[Type] - 1;
	statusCanPlus++;

	if(statusPlused[Type] == 0)
	{
		HandleUsePointCancelByType(Type);
		CheckStatusButtomBtns(GetAllStatusPlused() > 0);
	} else {
		GetTxtBoxHandleAddedByIndex(Type).SetText("/" $ string(GetStatusPlused(int(GetTxtBoxHandleBasicByIndex(Type).GetText()) + statusPlused[Type])));
		GetTxtBoxHandlePlusByIndex(Type).SetText("+" $ string(statusPlused[Type]));
	}
	CheckStatusPlusButtons();
	SetCanUsePointText();
	StatBonusWndClassic(GetScript("StatBonusWndClassic")).HandleOnChangedStatusType(Type);
}

function HandleOnClickPlusBtn(int Type)
{
	statusPlused[Type] = statusPlused[Type] + 1;
	GetTxtBoxHandleAddedByIndex(Type).SetText("/" $ string(GetStatusPlused(int(GetTxtBoxHandleBasicByIndex(Type).GetText()) + statusPlused[Type])));
	GetPlusWindowByIndex(Type).ShowWindow();
	statusCanPlus--;
	SetCanUsePointText();
	GetTxtBoxHandlePlusByIndex(Type).SetText("+" $ string(statusPlused[Type]));
	GetTxtBoxHandlePlusByIndex(Type).SetTextColor(GetColor(255, 228, 0, 255));
	CheckStatusPlusButtons();
	GetStatusMinusBtnByIndex(Type).EnableWindow();
	CheckStatusButtomBtns(true);
	StatBonusWndClassic(GetScript("StatBonusWndClassic")).HandleOnChangedStatusType(Type);
}

function HandleOnChangeState()
{
	local int i;

	for(i = 0; i < statusPlused.Length; i++)
	{
		if(GetPlusWindowByIndex(i).IsShowWindow())
		{
			GetTxtBoxHandleAddedByIndex(i).SetText("/" $ string(GetStatusPlused(int(GetTxtBoxHandleBasicByIndex(i).GetText()) + statusPlused[i])));
		}
	}
}

function int GetStatusPlused(int plusedNum)
{
	if(plusedNum > 200)
	{
		return 200;
	}
	return plusedNum;
}

function CheckStatusPlusButtons()
{
	local int i;

	if(statusCanPlus > 0)
	{
		for(i = 0;i < 6; i++)
		{
			GetStatusPlusBtnByIndex(i).EnableWindow();
		}
	} else {
		for(i = 0;i < 6; i++)
		{
			GetStatusPlusBtnByIndex(i).DisableWindow();
		}
	}
}

function CheckStatusMinusButtons()
{
	local int i;

	for(i = 0;i < 6; i++)
	{
		if(statusPlused[i] > 0)
		{
			GetStatusMinusBtnByIndex(i).EnableWindow();
		} else {
			GetStatusMinusBtnByIndex(i).DisableWindow();
		}
	}
}

function CheckStatusButtomBtns(bool isPlused)
{
	if(isPlused)
	{
		UsePoint_Apply_BTN.ShowWindow();
		UsePoint_Cancel_BTN.ShowWindow();
		UsePoint_Reset_BTN.HideWindow();
	}
	else
	{
		UsePoint_Apply_BTN.HideWindow();
		UsePoint_Cancel_BTN.HideWindow();
		UsePoint_Reset_BTN.ShowWindow();
	}
}

function SetElixirInfo()
{
	local ItemInfo iInfo;

	iInfo = GetItemInfoByClassID(ElixirItemID);
	GetItemWindowHandle(m_WindowName $ ".Statsinfo_Elixir_Win.ElixirItem").AddItem(iInfo);
	GetTextBoxHandle(m_WindowName $ ".Statsinfo_Elixir_Win.ElixirTitle_txt").SetText(iInfo.Name);
}

function TextBoxHandle GetTxtBoxHandleBasicByIndex(int Index)
{
	return GetTextBoxHandle(GetStatusPlusPathByIndex(Index) $ ".Statsinfo_Num_text");
}

function TextBoxHandle GetTxtBoxHandleAddedByIndex(int Index)
{
	return GetTextBoxHandle(GetStatusPlusPathByIndex(Index) $ ".STR_PreviewNum_Wnd" $ ".Statsinfo_PreviewNum_text");
}

function WindowHandle GetPlusWindowByIndex(int Index)
{
	return GetWindowHandle(GetStatusPlusPathByIndex(Index) $ ".STR_PreviewNum_Wnd");
}

function TextureHandle GetTextureHandleAddedByIndex(int Index)
{
	return GetTextureHandle(GetStatusPlusPathByIndex(Index) $ ".Statsinfo_IconPointPanel_tex");
}

function TextBoxHandle GetTxtBoxHandlePlusByIndex(int Index)
{
	return GetTextBoxHandle(GetStatusPlusPathByIndex(Index) $ ".Statsinfo_PointPlusNum_Text");
}

function ButtonHandle GetStatusPlusBtnByIndex(int Index)
{
	return GetButtonHandle(GetStatusPlusPathByIndex(Index) $ ".Statsinfo_PointPlusNum_BTN");
}

function ButtonHandle GetStatusMinusBtnByIndex(int Index)
{
	return GetButtonHandle(GetStatusPlusPathByIndex(Index) $ ".Statsinfo_PointMinusNum_BTN");
}

function string GetStatusPlusPathByIndex(int Index)
{
	return m_Statsinfo_UsePoint_Win $ ".Win0" $ string(Index);
}

/**
 * Ŀ��������(������Ŭ������ȯ��ư�����)
 **/
function CustomTooltip subjobButtonToolTips(int TargetType)
{
	local CustomTooltip m_Tooltip;
	local int subjobSlotStringNum;

	// Debug("TargetType tool " @ TargetType);

	// ����Ŭ����������ϴ��ڸ��Դϴ�.. �����ȳ���Ʈ..
	if(TargetType == -1)
	{
		m_Tooltip.DrawList.Length = 1;
		m_Tooltip.MinimumWidth = 210;//160->183px �� ������
		m_Tooltip.DrawList[0].eType = DIT_TEXT;
		m_Tooltip.DrawList[0].t_color.R = 220;
		m_Tooltip.DrawList[0].t_color.G = 220;
		m_Tooltip.DrawList[0].t_color.B = 220;
		m_Tooltip.DrawList[0].t_color.A = 255;

		//�Ƹ����̾��� ��� ���� �ؽ�Ʈ�� �ٸ�
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

		if(GetLanguage() == 8 || GetLanguage() == 9)
		{
			m_Tooltip.MinimumWidth = 260;			
		}
		else
		{
			m_Tooltip.MinimumWidth = 214;
		}
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

		// Debug("GetClassType(subjobInfoArray[TargetType].ClassID)" @ subjobInfoArray[targetType].ClassID);
		// Debug("GetClassType(subjobInfoArray[TargetType] �̸�:)" @ GetClassType(subjobInfoArray[targetType].ClassID));

		// ����:0, ���:1 ����:2
		// ����Ŭ�������..
		if(subjobInfoArray[TargetType].Type == 2)
		{
			// "����"
			m_Tooltip.DrawList[2].t_strText = " (" $ GetSystemString(2341) $ ")";			
		}
		else if(subjobInfoArray[TargetType].Type == 1)
		{
			// "���"
			m_Tooltip.DrawList[2].t_strText = " (" $ GetSystemString(2739) $ ")";
		}
		else
		{
			m_Tooltip.DrawList[2].t_strText = " (" $ GetSystemString(2738) $ ")";
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
		// ������..
		// 80�������ĸ���Ŭ�����μ����Ҽ��ֽ��ϴ�. �޼���������
		m_Tooltip.DrawList[4].eType = DIT_TEXT;

		// ��� Ŭ������ �ϳ��� ���� ���
		// 80���� ���� ����Ŭ������ ������ �� �ֽ��ϴ� 
		// ��� ������ �����ش�. 
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

function array<RequestItem> API_GetStatBonusResetData()
{
	local array<RequestItem> arrStatBonusResetUIData;
	local UserInfo uInfo;

	if(!GetPlayerInfo(uInfo))
	{
		return arrStatBonusResetUIData;
	}
	GetStatBonusResetData(GetTotalBonusAdded(uInfo), arrStatBonusResetUIData);
	return arrStatBonusResetUIData;
}

function int API_GetMaxElixir()
{
	return GetMaxElixir();
}

function API_C_EX_SET_STATUS_BONUS()
{
	local array<byte> stream;
	local UIPacket._C_EX_SET_STATUS_BONUS packet;
	local UserInfo uInfo;

	if(!GetPlayerInfo(uInfo))
	{
		return;
	}
	packet.additionalStatBonus.nStrBonus = statusPlused[0];
	packet.additionalStatBonus.nDexBonus = statusPlused[2];
	packet.additionalStatBonus.nConBonus = statusPlused[4];
	packet.additionalStatBonus.nIntBonus = statusPlused[1];
	packet.additionalStatBonus.nWitBonus = statusPlused[3];
	packet.additionalStatBonus.nMenBonus = statusPlused[5];

	if(!class'UIPacket'.static.Encode_C_EX_SET_STATUS_BONUS(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SET_STATUS_BONUS, stream);
}

function API_C_EX_RESET_STATUS_BONUS()
{
	local array<byte> stream;
	local UIPacket._C_EX_RESET_STATUS_BONUS packet;

	if(!class'UIPacket'.static.Encode_C_EX_RESET_STATUS_BONUS(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_RESET_STATUS_BONUS, stream);
}

function int GetStatusStatByIndex(int Index, UserInfo uInfo)
{
	switch(Index)
	{
		case 0:
			return uInfo.nStr;
		case 1:
			return uInfo.nInt;
		case 2:
			return uInfo.nDex;
		case 3:
			return uInfo.nWit;
		case 4:
			return uInfo.nCon;
		case 5:
			return uInfo.nMen;
	}
	return -1;
}

function int GetStatusBonusByType(int Type, UserInfo uInfo)
{
	switch(Type)
	{
		case 0:
			return uInfo.nStrBonus;
		case 1:
			return uInfo.nIntBonus;
		case 2:
			return uInfo.nDexBonus;
		case 3:
			return uInfo.nWitBonus;
		case 4:
			return uInfo.nConBonus;
		case 5:
			return uInfo.nMenBonus;
	}
	return -1;
}

function int GetStatusHennaSkillItemBonusByType(int Type, UserInfo uInfo)
{
	switch(Type)
	{
		case 0:
			return uInfo.nStrAdditional;
		case 1:
			return uInfo.nIntAdditional;
		case 2:
			return uInfo.nDexAdditional;
		case 3:
			return uInfo.nWitAdditional;
		case 4:
			return uInfo.nConAdditional;
		case 5:
			return uInfo.nMenAdditional;
	}
	return -1;
}

function int GetTotalBonusAdded(UserInfo uInfo)
{
	local int i;
	local int total;

	for(i = 0; i < 6 ;i++)
	{
		total = total + GetStatusBonusByType(i, uInfo);
	}
	return total;
}

function _ElementalActive(int Index)
{
	local string spiritName;
	local Color Color;

	switch(Index)
	{
		case 0:
			spiritName = "Fire";
			Color = GetColor(255, 68, 68, 255);
			break;
		case 1:
			spiritName = "Water";
			Color = GetColor(0, 153, 255, 255);
			break;
		case 2:
			spiritName = "Wind";
			Color = GetColor(153, 255, 153, 255);
			break;
		case 3:
			spiritName = "Earth";
			Color = GetColor(255, 255, 153, 255);
			break;
	}
	GetTextureHandle(spiritName $ "ActiveTexture").ShowWindow();
	GetTextBoxHandle("txtHead" $ spiritName $ "Title").SetTextColor(Color);
}

function _ElementalDeActive(int Index)
{
	local string spiritName;

	switch(Index)
	{
		case 0:
			spiritName = "Fire";
			break;
		case 1:
			spiritName = "Water";
			break;
		case 2:
			spiritName = "Wind";
			break;
		case 3:
			spiritName = "Earth";
			break;
	}
	GetTextureHandle(spiritName $ "ActiveTexture").HideWindow();
	GetTextBoxHandle("txtHead" $ spiritName $ "Title").SetTextColor(GetColor(200, 200, 200, 255));
}

/**
 * ������ESC Ű�δݱ�ó��
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);

	if(ConfirmWnd.IsShowWindow())
	{
		ConfirmWnd.HideWindow();
	}
	else
	{
		GetWindowHandle(m_WindowName).HideWindow();
	}
}

defaultproperties
{
	m_WindowName="DetailStatusWndClassic"
	m_Statsinfo_UsePoint_Win="DetailStatusWndClassic.Statsinfo_UsePoint_Win"
}
