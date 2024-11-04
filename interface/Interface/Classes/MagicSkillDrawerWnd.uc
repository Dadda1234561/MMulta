class MagicSkillDrawerWnd extends UICommonAPI;

const MIN_ENCHANT_LEVEL = 1;
const MAX_ENCHANT_LEVEL = 30;
const SKILL_ENCHANT_NUM = 6;
const ENCHANT_TYPE_NUM = 3;         // ��þƮ Ÿ�� ��

//����Ʈ ����
const ENCHANT_START = -1;
const ENCHANT_NORMAL = 0;			// ���� ��æƮ
const ENCHANT_SAFETY = 1;			// ������Ƽ ��æƮ
const ENCHANT_UNTRAIN = 2;			// ��æƮ ��Ʈ����
const ENCHANT_ROUTE_CHANGE = 3;		// ��æƮ ��Ʈ ü����
const ENCHANT_PASS_TICKET = 4;		// ��æƮ ��Ʈ ü����

const ENCHANT_MATERIAL_NUM = 3;		// ����� ��
//const ARROW_NUM = 9;				// ������ ���̿� ���� �ؽ��� ����

const DIALOGID_ResearchClick = 0;

const ENCHANT_TYPE_UINT = 1000;

var Color White;

var String m_WindowName;
var WindowHandle Me;
var WindowHandle MagicskillGuideWnd;
var TextureHandle ResearchSkill;
//var TextureHandle SelectSkill;
//��ų ��ȭ ȭ��ǥ ������ ��
//var TextureHandle ResearchSkillArrow_Right;
//var TextureHandle ResearchSkillArrow_Left;
//var TextureHandle ResearchSkillArrow_Down;
//var TextureHandle ResearchSkillArrow_Up;
var ItemWindowHandle ResearchSkillIcon;
var TextureHandle ResearchSkillIconSlotBg;
var TextBoxHandle ResearchSkillTitle;
var NameCtrlHandle ResearchSkillName;
//��ų ��ȭ �̸��� ǥ�� �ϴ� �κ�
//var TextBoxHandle ResearchSkillRoot;
var TextBoxHandle ResearchSkillDesc;
var TextBoxHandle ResearchSkillLv;
//��ų ��ȭ ���� �ܰ踦 ǥ�� �ϴ� �κ�
//var TextBoxHandle ResearchSkillRootLv;
var ItemWindowHandle ExpectationSkillIcon;
var TextureHandle ExpectationSkillIconSlotBg;
var TextBoxHandle ExpectationSkillTitle;

//��ų ��ȭ �� ǥ�� �ߴ� �̸� �κ�
//var NameCtrlHandle ExpectationSkillName;

var TextBoxHandle ExpectationSkillRoot;
var TextBoxHandle ExpectationSkillDesc;
//��ų ��ȭ �� ǥ�� �ߴ� ��ų ���� �̸�
//var TextBoxHandle ExpectationSkillLv;
//var TextBoxHandle ExpectationSkillRootLv;
var TextBoxHandle SucessProbablity;

var ItemWindowHandle ResearchRootIcon[SKILL_ENCHANT_NUM];
var ButtonHandle ResearchRootBTN[SKILL_ENCHANT_NUM];
var TextBoxHandle ResearchRootText[ SKILL_ENCHANT_NUM ];
var TextBoxHandle ResearchRootText2[ SKILL_ENCHANT_NUM ];

//var ButtonHandle ResearchRoot_2[SKILL_ENCHANT_NUM];
//var ButtonHandle ResearchRoot_3[SKILL_ENCHANT_NUM];

var int	ResearchRootID[SKILL_ENCHANT_NUM];
var int ResearchRootSubLevel[SKILL_ENCHANT_NUM];
//var int ResearchRootLevel[SKILL_ENCHANT_NUM];
var string ResearchRootSkillIconName[SKILL_ENCHANT_NUM];
var string ResearchRootSkillName[SKILL_ENCHANT_NUM];



var TextBoxHandle ResearchRootTitle;
var TextureHandle ResearchRootSlotBg;
//var CheckBoxHandle normEnchant;
//var CheckBoxHandle SafeEnchant;
//var CheckBoxHandle PassEnchant;
var CheckBoxHandle enchatTypeRadioBtn[ ENCHANT_TYPE_NUM ];
var TextBoxHandle EnchantMaterialTitle;

var TextBoxHandle EnchantMaterialName;
var TextBoxHandle EnchantMaterialInfo[ENCHANT_MATERIAL_NUM];

//������ ������ ���� ���� 
var TextBoxHandle EnchantMaterialInfo2;
var ItemWindowHandle EnchantMaterialIcon;
var TextureHandle EnchantMaterialIconBg;
var TextBoxHandle ResearchGuideTitle;
var TextBoxHandle ResearchGuideDesc;
var CharacterViewportWindowHandle ObjectViewport;
var ButtonHandle btnGuide;
var ButtonHandle btnResearch;
var ButtonHandle btnClose;
var TextureHandle ResearchSkillBg;
var TextureHandle ExpectationSkillBg;
var TextureHandle ResearchRootBg;
var TextureHandle ResearchMaterialIconBg;
var TextureHandle ResearchGuideBg;
var TextBoxHandle txtMySpStr;
var TextBoxHandle txtMySp;
var TextureHandle MyAdenaIcon;
var TextBoxHandle txtMyAdenaStr;
var TextBoxHandle txtMyAdena;
var AnimTextureHandle EnchantProgressAnim;
var int curEnchantType;
var int EnchantState;	 //���� ���� ���� ��æƮ ��� ����

var TextureHandle ResearchRoot_Select_1_0Y;
var TextureHandle ResearchRoot_Select_1_0B;

var int enableTrain;

var TextureHandle ResearchSkillSelectbox;
var TextureHandle ResearchRootSelectbox;

// ���� ������ ��ų ����
var int curSkillID; 
var int curLevel;
var int curSubLevel;
// ���� ���� ��æƮ,��Ʈ,��Ʈ���� �ϰ���� ��ų�� ����
var int curWantedSkillID;
var int curWantedSubLevel;

//���� ��ȭ ����� �ε��� 
var int curIndex;

var int64 needSPConsume;
var int64 needAdena;

//������ ���߿� show ��Ű�� reqe
var bool isHiding;


function setMagicSkillItemsType( bool isOn )
{
	local MagicSkillWnd script_a;
	local int i;

	script_a = MagicSkillWnd(GetScript("MagicSkillWnd"));

	//Debug ( "setMagicSkillItemsType"  @ isOn);
	for ( i = 0 ; i <  script_a.Skill_GROUP_COUNT ; i++ )
	{		
		if (isOn)
		{
			script_a.m_Item[i].SetIconDrawType(ITEMWND_IconDraw_NoConditionalEffect);
		}
		else 
		{
			script_a.m_Item[i].SetIconDrawType(ITEMWND_IconDraw_Default); ///�̰� �ȵǳ�.
		}
	}
}

function OnLoad()
{
	White.R = 250;
	White.G = 250;
	White.B = 250;
	White.A = 255;

	Initialize();
}


function OnRegisterEvent()
{
	// End:0x0B
	if(IsUseRenewalSkillWnd())
	{
		return;
	}
	RegisterEvent( EV_SkillEnchantInfoWndShow );
	RegisterEvent( EV_SkillEnchantInfoWndAddSkill );
//	RegisterEvent( EV_SkillEnchantInfoWndHide );
	RegisterEvent( EV_SkillEnchantInfoWndAddExtendInfo );
	RegisterEvent( EV_SkillEnchantResult );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );


	//SP ���� �� 
	RegisterEvent( EV_UpdateUserInfo );		
	RegisterEvent( EV_InventoryUpdateItem );	

	RegisterEvent( EV_InventoryItemListEnd );	
	
}


function Initialize()
{
	local int i;
	Me = GetWindowHandle( m_WindowName );
	MagicskillGuideWnd = GetWindowHandle( "MagicskillGuideWnd");
	ResearchSkill = GetTextureHandle (   m_WindowName$".ResearchSkill"  );

	ResearchSkillIcon = GetItemWindowHandle (   m_WindowName$".ResearchSkillWnd.ResearchSkillIcon"  );
	ResearchSkillIconSlotBg = GetTextureHandle (   m_WindowName$".ResearchSkillWnd.ResearchSkillIconSlotBg"  );
	ResearchSkillTitle = GetTextBoxHandle (   m_WindowName$".ResearchSkillWnd.ResearchSkillTitle"  );
	ResearchSkillName = GetNameCtrlHandle (   m_WindowName$".ResearchSkillWnd.ResearchSkillName"  );

	ResearchSkillDesc = GetTextBoxHandle (   m_WindowName$".ResearchSkillWnd.ResearchSkillDesc"  );
	ResearchSkillLv = GetTextBoxHandle(   m_WindowName$".ResearchSkillWnd.ResearchSkillLv"  );

	ExpectationSkillIcon = GetItemWindowHandle (   m_WindowName$".ResearchSkillWnd.ExpectationSkillIcon"  );
	ExpectationSkillIconSlotBg = GetTextureHandle (   m_WindowName$".ResearchSkillWnd.ExpectationSkillIconSlotBg"  );
	ExpectationSkillTitle = GetTextBoxHandle (   m_WindowName$".ResearchSkillWnd.ExpectationSkillTitle"  );	
	ExpectationSkillRoot = GetTextBoxHandle (   m_WindowName$".ResearchSkillWnd.ExpectationSkillRoot"  );
	ExpectationSkillDesc = GetTextBoxHandle (   m_WindowName$".ResearchSkillWnd.ExpectationSkillDesc"  );
	SucessProbablity = GetTextBoxHandle (   m_WindowName$".ResearchSkillWnd.SucessProbablity"  );
	
	for (i =0; i < SKILL_ENCHANT_NUM; i++)
	{
		ResearchRootIcon[i] = GetItemWindowHandle ( m_WindowName$".ResearchRootIcon_"$string(i));
		ResearchRootBTN[i] = GetButtonHandle(m_WindowName$".ResearchRootBTN"$string(i));
		ResearchRootText[i] = GetTextBoxHandle(m_WindowName$".ResearchRootText"$string(i));
		ResearchRootText2[i] = GetTextBoxHandle(m_WindowName$".ResearchRootText"$string(i)$"_1");
	}

	ResearchRoot_Select_1_0Y =  GetTextureHandle(m_WindowName$".ResearchRoot_Select_1_0Y");
	ResearchRoot_Select_1_0B =  GetTextureHandle(m_WindowName$".ResearchRoot_Select_1_0B");

	ResearchRootTitle = GetTextBoxHandle (   m_WindowName$".ResearchRootTitle"  );
	ResearchRootSlotBg = GetTextureHandle (   m_WindowName$".ResearchRootSlotBg"  );

	enchatTypeRadioBtn[0] = GetCheckBoxHandle (   m_WindowName$".NormalEnchant"  );
	enchatTypeRadioBtn[1] = GetCheckBoxHandle (   m_WindowName$".SafeEnchant"  );
	enchatTypeRadioBtn[2] = GetCheckBoxHandle (   m_WindowName$".PassEnchant"  );	

	EnchantMaterialTitle = GetTextBoxHandle (   m_WindowName$".EnchantMaterialTitle"  );

	for (i = 0; i < ENCHANT_MATERIAL_NUM; i++)
	{		
		EnchantMaterialInfo[i] = GetTextBoxHandle (   m_WindowName$".EnchantMaterialInfo_"$string(i) );
	}

	EnchantMaterialName = GetTextBoxHandle (   m_WindowName$".EnchantMaterialName_0" );
	EnchantMaterialIcon = GetItemWindowHandle (   m_WindowName$".EnchantMaterialIcon_0" );
	EnchantMaterialIconBg = GetTextureHandle (   m_WindowName$".EnchantMaterialIconBg_0"  );

	EnchantMaterialInfo2 = GetTextBoxHandle ( m_WindowName$".EnchantMaterialInfo2");
	
	ResearchGuideTitle = GetTextBoxHandle ( m_WindowName$".ResearchGuideTitle"  );
	ResearchGuideDesc = GetTextBoxHandle ( m_WindowName$".ResearchGuideDesc"  );
	ObjectViewport = GetCharacterViewportWindowHandle (   m_WindowName$".ObjectViewport"  );
	btnGuide = GetButtonHandle (   m_WindowName$".btnGuide"  );
	btnResearch = GetButtonHandle (   m_WindowName$".btnResearch"  );
	btnClose = GetButtonHandle (   m_WindowName$".btnClose"  );
	ResearchSkillBg = GetTextureHandle (   m_WindowName$".ResearchSkillBg"  );
	ExpectationSkillBg = GetTextureHandle (   m_WindowName$".ExpectationSkillBg"  );
	ResearchRootBg = GetTextureHandle (   m_WindowName$".ResearchRootBg"  );
	ResearchMaterialIconBg = GetTextureHandle (   m_WindowName$".ResearchMaterialIconBg"  );
	ResearchGuideBg = GetTextureHandle (   m_WindowName$".ResearchGuideBg"  );
	txtMySpStr = GetTextBoxHandle (   m_WindowName$".txtMySpStr"  );
	txtMySp = GetTextBoxHandle (   m_WindowName$".txtMySp"  );
	txtMyAdenaStr = GetTextBoxHandle (   m_WindowName$".txtMyAdenaStr"  );
	txtMyAdena = GetTextBoxHandle (   m_WindowName$".txtMyAdena"  );
	MyAdenaIcon = GetTextureHandle (   m_WindowName$".MyAdenaIcon"  );
	EnchantProgressAnim = GetAnimTextureHandle (  m_WindowName$".EnchantProgressAnim"  );

	ResearchSkillSelectbox = GetTextureHandle ( m_WindowName$".ResearchSkillWnd.ResearchSkillSelectbox");
	ResearchRootSelectbox = GetTextureHandle ( m_WindowName$".ResearchRootSelectbox");

	EnchantProgressAnim.hidewindow();

	setRadioTooltip ( enchatTypeRadioBtn[0], 3357 );
	setRadioTooltip ( enchatTypeRadioBtn[1], 3358 );
	setRadioTooltip ( enchatTypeRadioBtn[2], 3359 );
}

function setRadioTooltip ( CheckBoxHandle radioBtn, int strNum)
{
	local CustomTooltip T;

	local L2Util util;
	
	T.MinimumWidth = 125; // 125 �� �����ؾ���

	util = L2Util(GetScript("L2Util"));//bluesun Ŀ���͸����� ���� 

	util.setCustomTooltip( T );

	util.ToopTipMinWidth( 220 );		
	
	util.ToopTipInsertText( GetSystemString (strNum), false, true, util.ETooltipTextType.COLOR_DEFAULT, 0, 0 );	

	radioBtn.SetTooltipCustomType ( util.getCustomToolTip() );	
}

function OnDrawerShowFinished()
{
	isHiding = false;
	setMagicSkillItemsType(true);
}

function OnClickButton( string Name )
{
	local int		rootID;	

	if ( InStr( Name ,"ResearchRootBTN") > -1 )
	{
		rootID = int(Right(Name, 1));		
		OnResearchRootBTNClick(rootID);
	}

	switch( Name )
	{
	
	case "btnGuide":
		OnbtnGuideClick();
		break;
	case "btnResearch":
		OnbtnResearchClick( );
		break;
	case "btnClose":
		OnbtnCloseClick( );
		break;
	}
}

/*
 *��ư���� ����� ��ư ó�� ����ϰ� ��.
 */
function byRadioButton(string strID)
{
	local int checkNum ;

	checkNum = -1;
	switch (strID) 
	{	
		case "NormalEnchant" :	
			EnchantState = ENCHANT_NORMAL;
			checkNum = 0;			
		break;
		case "SafeEnchant":
			EnchantState = ENCHANT_SAFETY;
			checkNum = 1;			
		break;
		case "PassEnchant":
			EnchantState = ENCHANT_PASS_TICKET;
			checkNum = 2;			
		break;
		
	}		

	enchatTypeRadioBtn[0].SetCheck ( false ) ;
	enchatTypeRadioBtn[1].SetCheck ( false ) ;
	enchatTypeRadioBtn[2].SetCheck ( false ) ;
//	Debug ( "byRadioButton"  @ checkNum  @ strID @ EnchantState );

	if ( checkNum != -1 ) enchatTypeRadioBtn[checkNum].SetCheck( true ) ;
}

/*
 *äũ �� ���¿� ���� text ������ ��ü
 */
function setTextByEnchantType()
{
	local string  btnResearchLabel;     //��ư �̸� ��ȭ
	local string  GuideDesc;            //��� ���� ��ȭ
	
	btnResearch.EnableWindow();
	if (enchatTypeRadioBtn[2].IsChecked())
	{			
		btnResearchLabel = GetSystemString( 3112 );
		GuideDesc = GetSystemString( 3111 );
	}
	//�ູ ����
	else if (enchatTypeRadioBtn[1].IsChecked())
	{	
		btnResearchLabel = GetSystemString(2069);
		GuideDesc =	GetSystemString(2050);	
	}	
	//���� Ÿ�԰� �����ϰ��� �ϴ� Ÿ���� ������ �Ϲ�	
	else if ( enchatTypeRadioBtn[0].IsChecked() )
	//curSubLevel /ENCHANT_TYPE_UINT == curWantedSubLevel / ENCHANT_TYPE_UINT || curSubLevel == 0) 
	{			
		btnResearchLabel = GetSystemString(2070) ;
		GuideDesc =	GetSystemString(2051);		
	}
	//�ִ� ������ ��� 
	else if ( enableTrain == 0 && curSubLevel /ENCHANT_TYPE_UINT == curWantedSubLevel / ENCHANT_TYPE_UINT)  
	{		
		btnResearchLabel = GetSystemString (2070);
		GuideDesc =	GetSystemString(3354);
		btnResearch.DisableWindow();
	}	
	//��Ʈ ü���� �� ��� 
	else 
	{
		btnResearchLabel = GetSystemString( 2068 ) ;
		GuideDesc =	GetSystemString(2052);
	}

	btnResearch.SetNameText( btnResearchLabel );
	ResearchGuideDesc.SetText( GuideDesc );
	//RequestExEnchantSkillInfoDetail( EnchantState, curWantedSkillID, curLevel, curWantedSubLevel);			
}



function OnClickCheckBox( String strID)
{
	byRadioButton( strID );
	//setTextByEnchantType();	
	//���� �������� �ϴ� ��? 
	RequestExEnchantSkillInfoDetail( EnchantState, curWantedSkillID, curLevel, curWantedSubLevel);
}

//�� ��ư Ŭ�� �� ���¿� ���� ���� ��ư ��ȭ 
function setRadioBtnsByEnchantStep( ) 
{
	/*
	"NormalEnchant"
	"PassEnchant"			
	"SafeEnchant"*/				
	
	local bool canUseBtns;

	//�ΰ��� ���� �߻� 
	//1 ���� ���� �Ǿ� �ִ� ��þƮ Ÿ���� ��� ���� �ȵ�.
	//2 �ִ� ������ ���ó�� ���� ��� ���� �ݿ��� �ȵ�.

	//�Ѵ� ENCHANT_START �� ��� �߻� �˴ϴ�.
	
	//�ƹ��͵� Ŭ�� ���� �ʾҴ� ��� 
	//1. ���� �� ��ȭ ����� �ִ� ������ ��� ��� ��Ȱ ��ȭ ó�� �ؾ� ��.
	if ( EnchantState == ENCHANT_START && enableTrain == 1  ) 
	{
		//����� ��ư�� üũ �Ǿ� �ִ� ���� ���� ��� 
		//������ ����� �ƴ϶� ���ǿ� ���� �ٸ��� �ؾ� ��.		
		if ( enchatTypeRadioBtn[1].IsChecked() )
		{
			byRadioButton ( "SafeEnchant");
		}
		else if ( enchatTypeRadioBtn[2].IsChecked() ) 
		{
			byRadioButton ( "PassEnchant");
		}
		else byRadioButton ( "NormalEnchant" );			
		canUseBtns = true;
	}
	//��ư ���� ��   //�ִ� ���� �� ����� �ִ� ������ ���		
	else if ( enableTrain == 0 && curSubLevel/ENCHANT_TYPE_UINT == curWantedSubLevel/ENCHANT_TYPE_UINT)
	{		
		EnchantState = ENCHANT_NORMAL;
		byRadioButton ("");
		
	}
	//��ư ���� ��   //���� �� ��Ȱ��ȭ  
	else if ( curSubLevel/ENCHANT_TYPE_UINT != curWantedSubLevel/ENCHANT_TYPE_UINT && curSubLevel > 0) 
	{		
		byRadioButton ("");	
		EnchantState = ENCHANT_ROUTE_CHANGE;
	}
	//�� �� ��� ��� 
	else 
	{		
		if ( EnchantState == ENCHANT_ROUTE_CHANGE ) 
		{			
			byRadioButton ( "NormalEnchant" );
		}	
		canUseBtns = true;
	}

	if ( canUseBtns ) 
	{
		enchatTypeRadioBtn[0].EnableWindow();
		enchatTypeRadioBtn[1].EnableWindow();
		enchatTypeRadioBtn[2].EnableWindow();
	}
	else 
	{
		enchatTypeRadioBtn[0].DisableWindow();
		enchatTypeRadioBtn[1].DisableWindow();
		enchatTypeRadioBtn[2].DisableWindow();
	}
}


function OnResearchRootBTNClick(int index)
{
	local int infoid;
	local int infoSublevel;
	
	//�ݺ� Ŭ�� �� ��� ����
//	Debug ( "OnResearchRootBTNClick1" @ curEnchantType @ ResearchRootSubLevel[index]);
	if ( curEnchantType == ResearchRootSubLevel[index]/ENCHANT_TYPE_UINT ) return;
	
	//Debug (  "OnResearchRootBTNClick"@curSubLevel/ENCHANT_TYPE_UINT  @  ResearchRootSubLevel[index]/ENCHANT_TYPE_UINT  @  curSubLevel );
	//��� ���϶���Ʈ�� �Ķ� ���϶���Ʈ�� ���� �� �ֵ��� ����	
	if ( curSubLevel/ENCHANT_TYPE_UINT == ResearchRootSubLevel[index]/ENCHANT_TYPE_UINT || curSubLevel == 0  ) 
	{
		ResearchRoot_Select_1_0Y.HideWindow();
	} 
	else 
	{
		ResearchRoot_Select_1_0Y.ShowWindow();
	}	

	ResearchRoot_Select_1_0B.ClearAnchor();
	ResearchRoot_Select_1_0B.SetAnchor( "MagicSkillDrawerWnd.ResearchRootBTN"$index, "TopLeft", "TopLeft", 0, 0 );
	ResearchRoot_Select_1_0B.ShowWindow();		
		
	infoSublevel = ResearchRootSubLevel[index];		
	infoid = ResearchRootID[index];
	//infoLevel = ResearchLevel[index];
	//curWnatedLevel = infoLevel;
	curWantedSkillID = infoid;
	curWantedSubLevel = infoSublevel;	
		
	//��ų �� Ÿ���� �ٸ��鼭, curSubLevel�� 0���� ū ���
	//Debug ( "ENCHANT_ROUTE_CHANGE Ÿ���ΰ�?" @ curSubLevel/ENCHANT_TYPE_UINT @  ResearchRootSubLevel[index]/ENCHANT_TYPE_UINT @ curSubLevel );
	/*
	if ( curSubLevel/ENCHANT_TYPE_UINT != ResearchRootSubLevel[index]/ENCHANT_TYPE_UINT  && curSubLevel > 0 ) 
	{		
		//EnchantState = ENCHANT_ROUTE_CHANGE;		
		btnResearch.SetNameText(GetSystemString(2068));								
	}*/

	//Debug ( "OnResearchRootBTNClick" @ EnchantState@curWantedSkillID@curWantedSubLevel );
	
	SucessProbablity.SetText("");
	SucessProbablity.HideWindow();
	
	//SetAdenaSpInfo();	

	setRadioBtnsByEnchantStep();

	//setTextByEnchantType();	

	RequestExEnchantSkillInfoDetail(EnchantState, curWantedSkillID, curLevel, curWantedSubLevel);

/*
	if ( enableTrain == 0 ) 
	{
		//�ִ� ������ ��� 
		if ( curSubLevel/ENCHANT_TYPE_UINT == ResearchRootSubLevel[index]/ENCHANT_TYPE_UINT ) 
		{	
			btnResearch.DisableWindow();			
		}
		else 
		{
			btnResearch.EnableWindow();
		}
	}
	else 
	{
		btnResearch.EnableWindow();
	}
*/
}

function OnbtnGuideClick()
{
	if (MagicskillGuideWnd.IsShowWindow())
	{
		MagicskillGuideWnd.HideWindow();		
	}
	else 
	{
		MagicskillGuideWnd.ShowWindow();
		MagicskillGuideWnd.SetFocus();
	}
}

function OnbtnResearchClick()
{		
	DialogSetID( DIALOGID_ResearchClick);
	DialogShow(DialogModalType_Modal, DialogType_OKCancel, GetSystemString( 2054 ), string(Self) );	

	//SetAdenaSpInfo();	
}

function OnbtnCloseClick()
{
	local MagicSkillWnd script_a;

	script_a = MagicSkillWnd(GetScript("MagicSkillWnd"));

	script_a.RequestSkillList();	

	me.HideWindow();
	isHiding = true;
	setMagicSkillItemsType(false);
//	HideAgathion();	
	SkillInfoClear();

}

function OnEvent(int Event_ID, String param)
{	
	//Debug ("onEvent" @ Event_ID @ param );
	switch (Event_ID)
	{
		case EV_SkillEnchantInfoWndShow:                    //2064
			
			OnEVSkillEnchantInfoWndShow(param);
			break;			
		case EV_SkillEnchantInfoWndAddSkill:                //2065
			OnEVSkillEnchantInfoWndAddSkill(param);
			break;
	//	case EV_SkillEnchantInfoWndHide:
	//		OnEVSkillEnchantInfoWndHide(param);
	//		break;
		case EV_SkillEnchantInfoWndAddExtendInfo:           //2067
			OnEVSkillEnchantInfoWndAddExtendInfo(param);			
			break;
		case EV_SkillEnchantResult:                         //4600
			OnEVSkillEnchantResult(param);			
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
		case EV_DialogCancel:
			HandleDialogCancel();
			break;
		case EV_UpdateUserInfo :
			if (! Me.IsShowWindow() ) return;
			SetSpInfo();
			break;		
		case EV_InventoryUpdateItem:    //2610	
		case EV_InventoryItemListEnd:
			if (! Me.IsShowWindow() ) return;
			SetAdenaInfo( string ( GetAdena() ));
			break;
	}
}

function SetSpInfo()
{	
	txtMySp.SetText(MakeCostString( string(GetUserSP()) ));
	txtMySp.SetTooltipString( ConvertNumToTextNoAdena(string(GetUserSP())) );

	if (  needSPConsume > GetUserSP() ) 		
	{		
		ResearchGuideDesc.SetText( GetSystemString ( 3361 ) );
		btnResearch.DisableWindow();
	}
}


function SetAdenaInfo( string adena)
{	//GetAdena() ���� ������ �޾�����, ���� ,sp �� ������Ʈ �Ǳ� ���� �̺�Ʈ�� ������ ��찡 �־ ����		
	txtMyAdena.SetText(MakeCostString( adena ));
	txtMyAdena.SetText(MakeCostString( adena ));
	txtMyAdena.SetTooltipString( ConvertNumToText( adena) );
	txtMyAdenaStr.SetText(GetSystemString(469));

	if (  needAdena > int64 (adena) ) 		
	{		
		ResearchGuideDesc.SetText( GetSystemString ( 3361 ) );
		btnResearch.DisableWindow();
	}	
}

function HandleDialogOK()
{
	if( !DialogIsMine() )
		return;

	switch( DialogGetID() )
	{
		case DIALOGID_ResearchClick:	
			//if ( EnchantState != -1 @  curWantedSkillID @ curLevel @  curWantedSubLevel
			//Debug ( "HandleDialogOK" @ EnchantState @  curWantedSkillID @ curLevel @  curWantedSubLevel );
			btnResearch.DisableWindow();
			RequestExEnchantSkill(EnchantState, curWantedSkillID, curLevel, curWantedSubLevel);			
		break;
	}
	//m_hVpAgathion.PlayAnimation(2);
}

function HandleDialogCancel()
{
	if( !DialogIsMine() )
		return;
}

function OnEVSkillEnchantInfoWndShow(string param)
{
	local int Count;
	local int SkillID;
	local int CurSkillLevel;
	local int CurSkillSubLevel;
	local ItemInfo info;

	//�������� EnableTrain ���� 1 �� ��� ��
	ParseInt(Param, "EnableTrain", EnableTrain);
	//ParseInt(Param, "EnableUntrain", EnableUntrain);
	ParseInt(Param, "Count", Count);
	ParseInt(Param, "SkillID", SkillID);
	ParseInt(Param, "CurSkillLevel", CurSkillLevel);
	ParseInt(Param, "CurSkillSubLevel", CurSkillSubLevel);	
	
	info.ID.ClassID = curSkillID;
	info.Level = CurSkillLevel;
	info.SubLevel = CurSkillSubLevel;

	//��ų â�� ���� ��� ó������ ����.
	//Debug( "OnEVSkillEnchantInfoWndShow" @ isHiding ) ;
	if ( IsShowWindow( "MagicSkillWnd") && !isHiding) 
	{		
		Me.ShowWindow();		
	}
	
	SkillInfoClear();
	
	SetCurSkillInfo(info);

	//SetAdenaSpInfo();

	curSkillID = SkillID; 
	curLevel = CurSkillLevel;
	curSubLevel = CurSkillSubLevel;

	if ( enableTrain == 0 )
	{		
		ResearchGuideDesc.SetText("");
		ResearchGuideDesc.SetText(GetSystemString(2041));
		//ResearchGuideDesc.SetText("��ų ��ȭ�� �Ұ����� ��ų�Դϴ�..");

		//SetAdenaSpInfo();
		SucessProbablity.Hidewindow();
	}

	ResearchGuideDesc.SetText(GetSystemString(2043)); //"��ȭ ����� �����ϼ���. $ �ູ���� ��ų ��ȭ, �Һ��� ������ ��ų ��ȭ�� �Ʒ����� �� �� �� ������ �ּ���.
	
	Me.Setfocus();		
}

function onShow () 
{
	//���� �� sp, �Ƶ��� ���� ��������
	SetAdenaSpInfo () ;	
}

function SetAdenaSpInfo () 
{
	SetSpInfo();
	SetAdenaInfo( string ( GetAdena() ));
}

/*
function setHidingFlag( bool flag ) 
{
	//���� â�� �����ִ� ���¿��� �÷��׸� true�� ���� �Ϸ� �Ѵٸ� �÷��׸� flase�� �ٲ� ��.
	if ( !Me.IsShowWindow() ) 
	{
		if ( flag ) flag = false;
	}

	isHiding = flag;
}
*/



function OnDrawerHideFinished ()
{
	isHiding = false;	
	//setMagicSkillItemsType(false);
	OnTextureAnimEnd (EnchantProgressAnim  );
	if( DialogIsMine() )
	{
		class'UIAPI_WINDOW'.static.HideWindow("DialogBox");
	}
}
function onHide ()
{	
	if( DialogIsMine() )
	{
		class'UIAPI_WINDOW'.static.HideWindow("DialogBox");
	}
	
}

function SkillInfoClear() //������ ��ų ������ �� ����� ���
{
	local int i;
	
	ResearchSkillIcon.clear();
	ResearchSkillName.SetNameWithColor("",NCT_Normal,TA_Left, White);
	ResearchSkillDesc.SetText("");
	ResearchSkillLv.SetText("");
	
	ExpectationSkillIcon.clear();	
	ExpectationSkillRoot.SetText("");
	ExpectationSkillDesc.SetText("");
	SucessProbablity.SetText("");
	ResearchRoot_Select_1_0Y.HideWindow();
	ResearchRoot_Select_1_0B.HideWindow();

	for (i = 0; i < SKILL_ENCHANT_NUM; i++)
	{
		ResearchRootIcon[i].Clear();
		ResearchRootBTN[i].DisableWindow();
		ResearchRootText[i].SetText("");
		ResearchRootText2[i].SetText("");
		ResearchRootBTN[i].SetTooltipCustomType(MakeTooltipSimpleText(""));
	}	
	
	EnchantMaterialName.SetText("");
	EnchantMaterialIcon.clear();	
	
	for (i = 0; i < ENCHANT_MATERIAL_NUM; i++)
	{		
		EnchantMaterialInfo[i].SetText("");		
	}	
	
	EnchantMaterialInfo2.SetText("");

	ResearchRoot_Select_1_0B.HideWindow();
	ResearchGuideDesc.SetText(GetSystemString(2048)$"\\n"$GetSystemString(2049));  //"��ų ������ �����ϰڽ��ϴ�.\n-���� �����ϰ��� �ϴ� ��ų�� ���� �� ��ų�� �Ű� �ּ���."�ý��� �޽����� �ٲ�� ��
	
	btnResearch.SetNameText(GetSystemString(2070));
	btnResearch.DisableWindow();
	//SetAdenaSpInfo();

	//txtMySp.SetText("");
	enchatTypeRadioBtn[0].disableWindow();
	enchatTypeRadioBtn[1].disableWindow();
	enchatTypeRadioBtn[2].disableWindow();	
	curSkillID = 0; 
	curLevel = 0;
	curSubLevel = 0;
	curWantedSkillID = 0;
	curWantedSubLevel = 0;
	curIndex = -1;

	EnchantState = ENCHANT_START;
	curEnchantType = -1;

	ResearchRootSelectbox.HideWindow();
	ResearchSkillSelectbox.ShowWindow();	
}

function string getEnchantSkillName (  itemID itemID, int iLevel, int iSubLevel) 
{
	local string enchantSkillName ;
	local int iLength ;
	enchantSkillName = class'UIDATA_SKILL'.static.GetEnchantName( itemID, iLevel,  iSubLevel/ENCHANT_TYPE_UINT  * ENCHANT_TYPE_UINT +1 );	

	//+1�� �� ����
	iLength=Len(enchantSkillName)-3;

	if(iLength>0)
	{
		enchantSkillName=Right(enchantSkillName, iLength);		
	}

	return enchantSkillName;
}


function setBTNTooltip (  int index, ItemID itemID, int iLevel, int iSubLevel) 
{
	local CustomTooltip T;

	local L2Util util;
	local string strSkillName;

	local SkillInfo skillinfo;
	local string changeTitle;
	
	T.MinimumWidth = 125; // 125 �� �����ؾ���

	util = L2Util(GetScript("L2Util"));//bluesun Ŀ���͸����� ���� 

	util.setCustomTooltip( T );
	util.ToopTipMinWidth( 200 );

	if ( curSubLevel > 0 ) 
	{
		GetSkillInfo(curSkillID, curLevel, curSubLevel, skillInfo);
		strSkillName = class'UIDATA_SKILL'.static.GetEnchantName( itemID, curLevel, curSubLevel );
		util.ToopTipInsertText( GetSystemString (3352) , false, true, util.ETooltipTextType.COLOR_YELLOW, 0, 0 );
		util.ToopTipInsertText( strSkillName, false, true, util.ETooltipTextType.COLOR_DEFAULT, 0, 6 );
		util.ToopTipInsertText( skillInfo.EnchantDesc, false, true, util.ETooltipTextType.COLOR_DEFAULT, 0, 0 );

		util.TooltipInsertItemBlank( 6 );
		util.TooltipInsertItemLine();
		util.TooltipInsertItemBlank( 3 );
	}	
	
	//Ÿ�Ե� ���� ���� ���� ������ ���� ���
	if ( curSubLevel == iSubLevel  ) 
	{
		//3356 ���̻� ��ȭ�� ���� �� �� �����ϴ�.
		util.ToopTipInsertText( GetSystemString ( 3356 ), false, true, util.ETooltipTextType.COLOR_DEFAULT, 0, 0 );	
	}
	else 
	{
		//Ÿ���� ���� ��� ���� ���� ������ 0�� ��� ( ó�� ���� ���
		if ( iSubLevel/ENCHANT_TYPE_UINT == curSubLevel /ENCHANT_TYPE_UINT || curSubLevel == 0 )
		{
			//��ȭ ��
			changeTitle = GetSystemString ( 3353 ) ;
		}else 
		{
			//���� ��
			changeTitle = GetSystemString ( 3360 ) ;
		}
		GetSkillInfo(curSkillID, curLevel, iSubLevel, skillInfo);
		strSkillName = class'UIDATA_SKILL'.static.GetEnchantName( itemID, iLevel, iSubLevel );
		util.ToopTipInsertText( changeTitle , false, true, util.ETooltipTextType.COLOR_BLUE, 0, 0 );
		util.ToopTipInsertText( strSkillName, false, true, util.ETooltipTextType.COLOR_DEFAULT, 0, 0 );	
		util.ToopTipInsertText( skillInfo.EnchantDesc, false, true, util.ETooltipTextType.COLOR_DEFAULT, 0, 0 );
	}
	
		
	ResearchRootBTN[index].SetTooltipCustomType(util.getCustomToolTip());
}


function OnEVSkillEnchantInfoWndAddSkill(string param)
{
	local int iID;
	local ItemID itemID;
	local int iLevel;
	local int iSubLevel;
	local string strSkillIconName;
	local string strSkillName;	
	local iteminfo info;
	local int index;


	ParseInt(Param, "iID", iID);
	ParseInt(Param, "iLevel", iLevel);
	ParseInt(Param, "iSubLevel", iSubLevel);
	ParseString(Param, "strSkillIconName", strSkillIconName);
	ParseString(Param, "strSkillName",strSkillName);
	
	//Debug ( "OnEVSkillEnchantInfoWndAddSkill" @ curSubLevel @ param ) ;
	itemID.classID = iID;
	strSkillIconName = class'UIDATA_SKILL'.static.GetEnchantIcon( itemID, iLevel, iSubLevel );
	strSkillName = class'UIDATA_SKILL'.static.GetEnchantName( itemID, iLevel,iSubLevel );
	
	curIndex ++ ;

	//Debug ( "iSubLevel" @ iSubLevel);
	//���� �ִ� ��ġ�� ������ ���� �� ��.
	if ( curIndex >= SKILL_ENCHANT_NUM ) return;

	index = curIndex ;//iSubLevel / ENCHANT_TYPE_UINT - 1;

//	debug(strSkillIconName @ strSkillName @ iID @ "iLevel:"$iLevel@"index:"$index @"iSubLevel:"$iSubLevel);	

	ResearchRootID[index] = iID;
	
	ResearchRootSubLevel[index] = iSubLevel;
//	ResearchRootLevel[index] = iLevel;
	
	ResearchRootSkillIconName[index] = "l2ui_ct1.SkillWnd_DF_Icon_Enchant_"$strSkillIconName;      //������ ���� �ʹ� �� ��ų ��æƮ �������� �������� �����ܸ��� UC���� ����
	ResearchRootSkillName[index] = strSkillName;
	
	info.iconName = ResearchRootSkillIconName[index];//"l2ui_ct1.SkillWnd_DF_Icon_Enchant_"$strSkillIconName; 
																   //��ų �������� ��æƮ ���������� ����
	ResearchRootIcon[index].Clear();
	ResearchRootIcon[index].AddItem( info );
	
	ResearchRootText[index].SetText (makeShortStringByPixel (getEnchantSkillName ( itemID ,iLevel , iSubLevel ), 144, ".." ));
	//ResearchRootText[index].SetText (makeShortStringByPixel ("asdfasdfasdfasdfasdfasdfasdfasdfasdfasdf", 144, ".." ));
	
	SucessProbablity.Hidewindow();		
	
	setBTNTooltip (index, itemID, iLevel, iSubLevel);
	//Debug ( curSubLevel == iSubLevel );
	//Debug ("addCkill" @ curSubLevel/ENCHANT_TYPE_UINT  @  ResearchRootSubLevel[index]/ENCHANT_TYPE_UINT  );
	if ( curSubLevel/ENCHANT_TYPE_UINT == iSubLevel/ENCHANT_TYPE_UINT )
	{			
		//ResearchRootBTN[index].DisableWindow();
		ResearchRoot_Select_1_0Y.ClearAnchor();
		ResearchRoot_Select_1_0Y.SetAnchor( "MagicSkillDrawerWnd.ResearchRootBTN"$index, "TopLeft", "TopLeft", 0, 0);
		ResearchRoot_Select_1_0Y.ShowWindow();

		ResearchRootText[index].SetAnchor ( "MagicSkillDrawerWnd.ResearchRootBTN"$index, "TopLeft", "TopLeft", 44, 7 );
		ResearchRootText2[index].SetText ( "("$GetSystemString ( 3351 )$")" );

		//if ( enableTrain != 0 ) 
		OnResearchRootBTNClick(index);
	} 
	else 
	{
		ResearchRootText[index].SetAnchor ( "MagicSkillDrawerWnd.ResearchRootBTN"$index, "TopLeft", "TopLeft", 44, 16 );
	}

	ResearchRootBTN[index].EnableWindow();
}

function OnTextureAnimEnd( AnimTextureHandle a_WindowHandle )
{
	EnchantProgressAnim.HideWindow();
	EnchantProgressAnim.Stop();
	EnchantProgressAnim.HideWindow();
	switch ( a_WindowHandle )
	{
		case EnchantProgressAnim:
			break;
	}
}

function OnEVSkillEnchantResult(string param)
{
	local int iSuccess;
	
	ParseInt(param, "success", iSuccess);
	
	//	debug("success:"$iSuccess);
	if (iSuccess == 1)
	{
//				m_hVpAgathion.PlayAnimation(2);
		EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
		EnchantProgressAnim.ShowWindow();
		EnchantProgressAnim.SetLoopCount( 1 );
		EnchantProgressAnim.Stop();
		EnchantProgressAnim.SetTimes(0.8);
		EnchantProgressAnim.Play();

		// �Ʒ��� ������ ����
		if ( getInstanceUIData().getIsArenaServer() ) 
			PlaySound ( "ItemSound3.arena_skill_powerup" );
		else 
			Playsound("ItemSound3.enchant_success");

		ResearchGuideDesc.SetText(GetSystemString(2054)$"\\n"$GetSystemString(2055));		//"��ų ��æƮ�� �����Ͽ����ϴ�.\n-��æƮ ��ų�� Lv�� ��� �Ͽ����ϴ�."
	}
	else
	{
//		m_hVpAgathion.PlayAnimation(2);
		EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
		EnchantProgressAnim.ShowWindow();
		EnchantProgressAnim.SetLoopCount( 1 );
		EnchantProgressAnim.Stop();
		EnchantProgressAnim.Play();
		Playsound("ItemSound3.enchant_fail");

		ResearchGuideDesc.SetText(GetSystemString(2062)$"\\n"$GetSystemString(2063));		//"��ų ��æƮ�� �����Ͽ����ϴ�.\n-��æƮ ��ų�� �������� ��ų�� �ʱ�ȭ �˴ϴ�.."

	}
}


function OnEVSkillEnchantInfoWndAddExtendInfo(string param)
{
	local int SkillID;
	local int Level;
	local int SubLevel;
	local INT64 SPConsume;
	local int Percent;
	local int itemclassid[2];
	local string strItemIconName[2];
	local string strItemName[2];
	local string strSkillIconName;
	local string strSkillName;

	local int ItemSort;
	local int ItemNum[2];
	local int i;
	local int adenaID;	//�Ƶ���
	local int haguinID;	//�ϰ����Ǻ����� ID
	local int haguinItemID ; //�ϰ����Ǻ����� ID

	//Debug ( "OnEVSkillEnchantInfoWndAddExtendInfo" @ EnchantState);
	if ( EnchantState == ENCHANT_START ) return;

	ResearchRootSelectbox.HideWindow();
	
	ParseInt(Param, "SkillID", SkillID);
	ParseInt(Param, "Level", Level);
	ParseInt(Param, "SubLevel", SubLevel);
	ParseInt(Param, "Percent", Percent);	
	Parseint(Param, "ItemSort", ItemSort);

	for(i = 0; i < ItemSort; i++ )
	{
		ParseInt(Param, "ItemClassID_"$i, itemclassid[i]);
		ParseString(Param, "strItemIconName_"$i,strItemIconName[i]  );
		ParseString(Param, "strItemName_"$i,strItemName[i]);
		ParseInt(Param, "ItemNum_"$i, ItemNum[i]);
	}
	
	if (itemclassid[0] == 57)
	{
		adenaID = 0;
		haguinID = 1;
	}
	else
	{
		adenaID = 1;
		haguinID = 0;
	}
	
	haguinItemID = itemclassid[haguinID];

	ParseString(Param, "strSkillIconName",strSkillIconName);
	ParseString(Param, "strSkillName",strSkillName);
	ParseInt64(Param, "SPConsume", SPConsume);
	
	SetAfterSkillInfo( EnchantState, SkillID, Level, SubLevel, strSkillIconName, strSkillName );
	
//	Debug ( "OnEVSkillEnchantInfoWndAddExtendInfo" @  haguinID @ adenaID @ SPConsume @ Percent @ EnchantState);
	
	setTextByEnchantType();

	//��þƮ �ִ� ������ ���  ��� ���� ����
	if ( curSubLevel == SubLevel )
	{
		EnchantMaterialName.SetText("");
		EnchantMaterialIcon.clear();
		
		for (i = 0; i < ENCHANT_MATERIAL_NUM; i++)
		{		
			EnchantMaterialInfo[i].SetText("");		
		}	
		EnchantMaterialInfo2.SetText("");
	}
	
	else SetEnchantConsumeInfo ( haguinItemID,  ItemNum[haguinID],  strItemIconName[adenaID],  strItemName[adenaID],  ItemNum[adenaID], SPConsume, Percent, EnchantState);	
}


// ��ų ���� �� ��ų�� ����
function SetCurSkillInfo (ItemInfo info)
{
	local SkillInfo skillinfo;
	
	curSkillID = info.ID.ClassID; 
	curLevel = info.Level;
	curSubLevel = info.SubLevel;

	GetSkillInfo(curSkillID, curLevel, curSubLevel, skillInfo);
	info.Name = skillInfo.SkillName;
	info.Level = skillInfo.SkillLevel;

	info.SubLevel = skillInfo.SkillSubLevel;
	
	info.IconName = class'UIDATA_SKILL'.static.GetIconName( info.ID , info.Level, info.SubLevel );
	info.Description = skillInfo.SkillDesc;
	info.AdditionalName = skillInfo.EnchantName;
	info.IconPanel = skillInfo.IconPanel;
	info.ShortcutType = int(EShortCutItemType.SCIT_SKILL);
	//skillinfo.EnchantSkillLevel = class'UIDATA_SKILL'.static.GetEnchantSkillLevel( info.ID, info.Level );
	
	//i = GetSystemString(88)@skillInfo.EnchantSkillLevel;	// ��æƮ ��ų�� �������� ��ų�� Lv�� ǥ��
	//j = 		// �������� ��ų�� Lv�� ǥ��	

	ResearchSkillLv.SetText(GetSystemString(88)@skillInfo.SkillLevel);
	
	ResearchSkillName.SetNameWithColor(makeShortStringByPixel (skillInfo.SkillName, 154, ".." ),NCT_Normal,TA_Left, White);
	//ResearchSkillName.SetNameWithColor(makeShortStringByPixel ("asdfasdfasdfasdfasdfasdfasdfasdfasdf", 154, ".." ),NCT_Normal,TA_Left, White);
	//curEnchantType = info.SubLevel / ENCHANT_TYPE_UINT;

	//Debug ( "SetCurSkillInfo curEnchantType" @ curEnchantType );
	
	if ( info.SubLevel == 0)
	{			
		ResearchSkillDesc.SetText(GetSystemString(2040));		//"��æƮ ���� ���� �������� ��ų"		
	} 
	else 
	{		
		ResearchSkillDesc.SetText(GetSystemString(2207)); //"������ ��ȭ ��ų"			
	}

	ResearchSkillIcon.clear( );
	ResearchSkillIcon.AddItem( info );
	//SetAdenaSpInfo();
	ResearchSkillSelectbox.HideWindow();
	ResearchRootSelectbox.ShowWindow();
}

// ��ų ���� �� ��ų ����

function SetAfterSkillInfo (int EnchantState, int SkillID, int Level, int SubLevel, string strSkillIconName, string strSkillName )
{
	local SkillInfo skillinfo;
	local Iteminfo info;
	//local string i; 
	//local string j;	
	
	info.ID.classID = SkillID;
	info.Level = Level;
	info.SubLevel = SubLevel;
	info.IconName = "l2ui_ct1.SkillWnd_DF_Icon_Enchant_"$ class'UIDATA_SKILL'.static.GetEnchantIcon( info.ID, Level, SubLevel );//strSkillIconName;
	Info.Name = class'UIDATA_SKILL'.static.GetEnchantName( info.ID, Level, SubLevel );//strSkillIconName;strSkillName;	

	//Debug ( "skillName2"@ info.IconName @ info.Name  @ info.ID.classID @ Level @ SubLevel);

	GetSkillInfo(SkillID, Level, SubLevel, skillInfo);	
	
	//i = GetSystemString(88)@skillInfo.EnchantSkillLevel;	// ��æƮ ��ų�� �������� ��ų�� Lv�� ǥ��
	//j = GetSystemString(88)@skillInfo.SkillLevel;			// �������� ��ų�� Lv�� ǥ��

	ExpectationSkillIcon.clear();	
	ExpectationSkillIcon.Additem( info);

	ExpectationSkillRoot.SetText(makeShortStringByPixel (skillinfo.EnchantName, 154, ".." ));	
	//ExpectationSkillRoot.SetText(makeShortStringByPixel ("asdfasdfasdfasdfasdfasdfasdfasdfasdfasdf", 154, ".." ));

	//���̻� ���� �� �� ���� ��� 
	if ( curSubLevel ==  SubLevel ) 
	{
		ExpectationSkillDesc.SetText(GetSystemString(3356));
	}
	else 
	{
		ExpectationSkillDesc.SetText(skillinfo.EnchantDesc);
	}
//	ExpectationSkillRootLv.SetText("");

	curEnchantType = SubLevel/ENCHANT_TYPE_UINT;
	//Debug ( "SetAfterSkillInfo" @ curEnchantType );

	//Debug ( "SetAfterSkillInfo curEnchantType" @ curEnchantType );

	if ( EnchantState == ENCHANT_ROUTE_CHANGE)
	{	
		if ( curLevel == curWantedSubLevel ) ExpectationSkillDesc.SetText(GetSystemString(2210)); //������ ��ȭ ���. �ٸ� ��� �����ϼ���.
	}	
}

/*
 *�Ҹ� �Ǵ� ������ ����
 */

function SetEnchantConsumeInfo (int haguinClassID, int codexNum, string adenaIconName, string adenaName, int adenaNum, INT64 SPConsume, int Percent, int EnchantState)
{
	local ItemID	haguinID;
	local Iteminfo info_a; //�ϰ���
	local Iteminfo info_b; //�Ƶ���
	local ItemInfo Info_c; //SP
	local int i;

	local Color EnchantMaterialInfo2Color;

	local ItemWindowHandle InventoryItem;	

	local iteminfo SupportInfo;

	//Debug ( "SetEnchantConsumeInfo"@ haguinClassID @ codexNum @  adenaIconName @ adenaName @  adenaNum @  SPConsume@  Percent@ EnchantState );

	haguinID.ClassID = haguinClassID;
	class'UIDATA_ITEM'.static.GetItemInfo(haguinID, info_a );

	InventoryItem = GetItemWindowHandle( "InventoryWnd.InventoryItem");

	InventoryItem.GetItem(InventoryItem.FindItem( haguinID ), SupportInfo);
	//debug ( "SetEnchantConsumeInfo" @ SupportInfo.itemNum );

	info_b.IconName = adenaIconName;
	Info_b.Name = adenaName;

	Info_c.IconName = "icon.etc_i.etc_sp_point_i00";
	Info_c.Name = "SP";
	//SetEnchantConsumeInfo ( strItemIconName[0], strItemName[0],  ItemNum[0],  strItemIconName[1],  strItemName[1],  ItemNum[1], SPConsume, Percent, EnchantState);		
	
	if ( EnchantState == ENCHANT_NORMAL )
	{	
		//������ ������ ǥ��		
		EnchantMaterialName.SetText(makeShortStringByPixel (info_a.Name, 158, ".." ));		
		//EnchantMaterialName.SetText(makeShortStringByPixel ("asdfasdfasdfasdfasdfasdfasdfasdfasdfasdf", 160, ".." ));		
		EnchantMaterialInfo[0].SetText(GetSystemString(1514) @ string(codexNum) ) ;
		EnchantMaterialInfo2.SetText ("("$ SupportInfo.itemNum $")");
		EnchantMaterialIcon.Clear();
		EnchantMaterialIcon.Additem(info_a);

		
		//�Ƶ��� ǥ��		
		EnchantMaterialInfo[2].SetText(MakeCostString(string(adenaNum)));

		//SP ǥ��		
		EnchantMaterialInfo[1].SetText(MakeCostString(string(SPConsume)));		

		//����Ȯ�� ǥ��
		SucessProbablity.ShowWindow();
		SucessProbablity.SetText("");
		SucessProbablity.SetText(GetSystemString(642)@string(Percent)@GetSystemString(2042));

		//SetAdenaSpInfo();


	} else if ( EnchantState == ENCHANT_SAFETY )
		//ldw �߰�
	{	
		//������ ������ ǥ��
		EnchantMaterialName.SetText(makeShortStringByPixel (info_a.Name, 158, ".." ));
		EnchantMaterialInfo[0].SetText(GetSystemString(1514)@string(codexNum));
		EnchantMaterialInfo2.SetText ("("$ SupportInfo.itemNum $")");
		EnchantMaterialIcon.Clear();
		EnchantMaterialIcon.Additem(info_a);

		//SP ǥ��		
		EnchantMaterialInfo[1].SetText(MakeCostString(string(SPConsume)));		
		
		//�Ƶ��� ǥ��		
		EnchantMaterialInfo[2].SetText(MakeCostString(string(adenaNum)));		

		//����Ȯ�� ǥ��
		SucessProbablity.ShowWindow();
		SucessProbablity.SetText("");
		SucessProbablity.SetText(GetSystemString(642)@string(Percent)@GetSystemString(2042));			

		//SetAdenaSpInfo();		

	} 
	//���� �޾Ƽ� �ϰ� �Ǹ� ENCHANT_SAFETY �� ���� 
	else if ( EnchantState == ENCHANT_PASS_TICKET)
	{
		//������ ������ ǥ��
		EnchantMaterialName.SetText(makeShortStringByPixel (info_a.Name, 158, ".." ));
		EnchantMaterialInfo[0].SetText(GetSystemString(1514)@string(codexNum));
		EnchantMaterialInfo2.SetText ("("$ SupportInfo.itemNum $")");
		EnchantMaterialIcon.Clear();
		EnchantMaterialIcon.Additem(info_a);			

		//SP ǥ��		
		EnchantMaterialInfo[1].SetText(MakeCostString(string( SPConsume )));		

		//�Ƶ��� ǥ��		
		EnchantMaterialInfo[2].SetText(MakeCostString(string( adenaNum )));		

		//����Ȯ�� ǥ��
		SucessProbablity.ShowWindow();
		SucessProbablity.SetText("");
		SucessProbablity.SetText(GetSystemString(642)@string(Percent)@GetSystemString(2042));

		//SetAdenaSpInfo();
	}else if ( EnchantState == ENCHANT_ROUTE_CHANGE)
	{
		if (curLevel == curWantedSubLevel )
		{
			for (i = 0; i < ENCHANT_MATERIAL_NUM; i++)
			{
				
				EnchantMaterialInfo[i].SetText("");
				
			}
			EnchantMaterialName.SetText("");
			EnchantMaterialInfo2.SetText ("");
			EnchantMaterialIcon.clear();

		} else
		{
			//������ ������ ǥ��
			EnchantMaterialName.SetText(makeShortStringByPixel (info_a.Name, 158, ".." ));
			EnchantMaterialInfo[0].SetText(GetSystemString(1514)@string(codexNum));
			EnchantMaterialInfo2.SetText ("("$ SupportInfo.itemNum $")");
			EnchantMaterialIcon.Clear();
			EnchantMaterialIcon.Additem(info_a);

			//SP ǥ��
			EnchantMaterialInfo[1].SetText(MakeCostString(string(SPConsume)));

			//�Ƶ��� ǥ��
			EnchantMaterialInfo[2].SetText(MakeCostString(string(adenaNum)));

			SucessProbablity.SetText("");
			SucessProbablity.HideWindow();

			//SetAdenaSpInfo();
		}
	}

	if ( SupportInfo.itemNum < codexNum ) 
	{
		//����
		EnchantMaterialInfo2Color.R = 255;
		EnchantMaterialInfo2Color.G = 111;
		EnchantMaterialInfo2Color.B = 111;
	}
	else 
	{
		//���
		EnchantMaterialInfo2Color.R = 111;
		EnchantMaterialInfo2Color.G = 111;
		EnchantMaterialInfo2Color.B = 255;		
	}

	EnchantMaterialInfo2.setTextColor ( EnchantMaterialInfo2Color );

	//������ ������ ���� �� ��� 

	//Debug ("�������� ���� �Ѱ�?" @ SupportInfo.itemNum @ codexNum @ SPConsume @ GetUserSP() @ adenaNum @ GetAdena() );
	if ( SupportInfo.itemNum < codexNum || SPConsume > GetUserSP() || adenaNum > GetAdena() ) 		
	{		
		ResearchGuideDesc.SetText( GetSystemString ( 3361 ) );
		btnResearch.DisableWindow();
	}	

	needSPConsume =  SPConsume;
	needAdena = adenaNum;
}


function INT64 GetuserSP()
{

	local UserInfo infoPlayer;
	local INT64 iPlayerSP;

	GetPlayerInfo(infoPlayer);
	iPlayerSP = infoPlayer.nSP;

	return iPlayerSP;
}

function handleSetCurrentSkill ( ItemInfo a_ItemInfo )
{	
	//�̹� �� ����� �ٽ� ���� �ʴ´�.
	if ( a_ItemInfo.ID.ClassID == curSkillID && curLevel == a_ItemInfo.Level ) return;

	if ( a_ItemInfo.bDisabled > 0 )
	{
		SkillInfoClear();
		//SetAdenaSpInfo();
		ResearchGuideDesc.SetText(GetSystemString(2041));
		AddSystemMessage(3070);
	}
	//������ �մ� ���̶�� â�� ���� �ʴ´�.
	else 
	{
		SkillInfoClear();	
		byRadioButton ( "" ) ;
		RequestExEnchantSkillInfo(a_ItemInfo.ID.ClassID, a_ItemInfo.Level, a_ItemInfo.SubLevel ); 
		SetCurSkillInfo(a_ItemInfo);
		//SetAdenaSpInfo();
	}
}

function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
	local string dragsrcName;
	//local MagicSkillWnd script_a;	

	//script_a = MagicSkillWnd(GetScript("MagicSkillWnd"));
	
	RequestSkillList();
	dragsrcName = Left(a_ItemInfo.DragSrcName,10);

	if ((dragsrcName== "PSkillItem" || dragsrcName == "ASkillItem") )
	{
		handleSetCurrentSkill ( a_ItemInfo );
	}
}

defaultproperties
{
     m_WindowName="MagicSkillDrawerWnd"
}
