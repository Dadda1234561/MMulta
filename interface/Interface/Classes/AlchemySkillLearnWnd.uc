class AlchemySkillLearnWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// CONSTc
//////////////////////////////////////////////////////////////////////////////

const SKILLTYPE_ALCHEMYSKILL = 140;

const OFFSET_X_ICON_TEXTURE=0;
const OFFSET_Y_ICON_TEXTURE=4;
const OFFSET_Y_SECONDLINE = -14;

const OFFSET_Y_MPCONSUME=3;
const OFFSET_Y_CASTRANGE=0;
const OFFSET_Y_SP=120;

const WINDOW_W = 304;
const WINDOW_H_MAX = 510;
const WINDOW_H_MIN = 276;

var int m_iType;
var int m_iID;
var int m_iLevel;
var int m_iSubLevel;

var WindowHandle Me;
var AlchemySkillWnd alchemySkillWndScript;

var String m_WindowName;

var Color colorItemName;

//**��ų ���� ����(���)

//��ų ������
var TextureHandle texIcon;
//��Ƽ��/�нú� ������
var TextureHandle iconActive;

var TextureHandle IconPanel;

//��ų �̸�
var TextBoxHandle txtName;
//txtLevel
var TextBoxHandle txtLevel;
//�Ҹ�MP ��ġ
var TextBoxHandle txtMP;
//�����ð� ��ġ
var TextBoxHandle txtUseTime;
//����ð� ��ġ
var TextBoxHandle txtReuseTime;

//��ų ����
//var TextBoxHandle txtDescription;
var TreeHandle SkillTrainInfoTree;

//ĳ����Lv ��ġ
var TextBoxHandle txtNeedChaLv;
//�ʿ�SP ��ġ
var TextBoxHandle txtNeedSP;
//�ʿ������[sysstring="2380"]
var TextBoxHandle txtNeedItemString;
//�ʿ������ �̸�
var NameCtrlHandle txtNeedItemName;

//��� Ŭ������
//SystemString(2969) : ��� Ŭ���� Lv
var TextBoxHandle txtNeedDualLvString;
//�߰� �ݷ�
var TextBoxHandle txtColoneDualLv;
//ĳ���� ��� Ŭ���� v ��ġ
var TextBoxHandle txtNeedDualLv;

//�Ҹ�MP ������
var TextureHandle iconMP;
//�����ð� ������
var TextureHandle iconUse;
//���� ������
var TextureHandle iconReuse;

//var TextureHandle spBg;

var WindowHandle PrevSkillListBox;

var WindowHandle PrevSkillListNone;


var string TREENAME;


//��ų ����� ����
var L2Util util;

//getSkillRequestLevel


function OnRegisterEvent()
{
	RegisterEvent( EV_SkillTrainInfoWndShow );
	// RegisterEvent( EV_SkillTrainInfoWndHide );
	RegisterEvent( EV_SkillTrainInfoWndAddExtendInfo );
	
	// RegisterEvent( EV_SkillLearningDetailInfo );
}

function OnLoad()
{
//	if(CREATE_ON_DEMAND==0)
	SetClosingOnESC();

	OnRegisterEvent();

	Me = GetWindowHandle( "AlchemySkillLearnWnd" );

	texIcon = GetTextureHandle( "AlchemySkillLearnWnd.texIcon" );
	iconActive = GetTextureHandle( "AlchemySkillLearnWnd.iconActive" );
	IconPanel = GetTextureHandle( "AlchemySkillLearnWnd.IconPanel" );

	txtName = GetTextBoxHandle ( "AlchemySkillLearnWnd.txtName" );
	txtLevel = GetTextBoxHandle ( "AlchemySkillLearnWnd.txtLevel" );
	txtMP = GetTextBoxHandle ( "AlchemySkillLearnWnd.txtMP" );
	txtUseTime = GetTextBoxHandle ( "AlchemySkillLearnWnd.txtUseTime" );
	txtReuseTime = GetTextBoxHandle ( "AlchemySkillLearnWnd.txtReuseTime" );
	//txtDescription = GetTextBoxHandle ( "AlchemySkillLearnWnd.txtDescription" );
	txtNeedChaLv = GetTextBoxHandle ( "AlchemySkillLearnWnd.txtNeedChaLv" );
	txtNeedSP = GetTextBoxHandle ( "AlchemySkillLearnWnd.txtNeedSP" );
	txtNeedItemString = GetTextBoxHandle ( "AlchemySkillLearnWnd.txtNeedItemString" );
	txtNeedItemName = GetNameCtrlHandle ( "AlchemySkillLearnWnd.txtNeedItemName" );

	txtNeedDualLvString = GetTextBoxHandle ( "AlchemySkillLearnWnd.txtNeedDualLvString" );
	txtColoneDualLv = GetTextBoxHandle ( "AlchemySkillLearnWnd.txtColoneDualLv" );
	txtNeedDualLv = GetTextBoxHandle ( "AlchemySkillLearnWnd.txtNeedDualLv" );

	iconMP = GetTextureHandle( "AlchemySkillLearnWnd.iconMP" );
	iconUse = GetTextureHandle( "AlchemySkillLearnWnd.iconUse" );
	iconReuse = GetTextureHandle( "AlchemySkillLearnWnd.iconReuse" );
	
	//spBg = GetTextureHandle( "AlchemySkillLearnWnd.spBg" );

	PrevSkillListBox = GetWindowHandle( "AlchemySkillLearnWnd.PrevSkillListBox" );
	PrevSkillListNone = GetWindowHandle( "AlchemySkillLearnWnd.PrevSkillListNone" );

	util = L2Util(GetScript("L2Util"));	
	alchemySkillWndScript = AlchemySkillWnd(GetScript("AlchemySkillWnd"));	

	txtNeedDualLv.HideWindow();
	txtNeedDualLvString.HideWindow();
	txtColoneDualLv.HideWindow();

	txtMP.HideWindow();
	txtUseTime.HideWindow();
	txtUseTime.HideWindow();
	txtReuseTime.HideWindow();

	iconMP.HideWindow();
	iconUse.HideWindow();
	iconReuse.HideWindow();

	iconActive.HideWindow();

	colorItemName.R = 175;
	colorItemName.G = 152;
	colorItemName.B = 120;
}

function OnClickButton( string strBtnID )
{
	switch(strBtnID)
	{
		case "btnLearn" :
			 OnLearn();
			 HideWindow("AlchemySkillLearnWnd");
			 break;

		case "btnGoBackList" :
			 HideWindow("AlchemySkillLearnWnd");
			 //ShowWindowWithFocus("SkillTrainListWnd");
			 break;
	}
}

function OnLearn()
{
// �ӽ� - lancelot 2007. 3. 26.
	//local int type;
	//type=-1;
	
	//switch(m_iType)
	//{
	//case ESTT_NORMAL :
	//case ESTT_FISHING :
	//case ESTT_CLAN :
	//case ESTT_TRANSFORM :
	//case 5:
	//		// �����⽺ų
	//case 6:
	//		//ä����ų

	/*
		Debug("RequestAcquireSkill");
		Debug("m_iID" @ m_iID);
		Debug("m_iLevel" @ m_iLevel);
		Debug("m_iType" @ m_iType);
*/

		RequestAcquireSkill(m_iID, m_iLevel, m_iSubLevel, m_iType);

		//case ESTT_SUB_CLAN:
		//RequestAcquireSkillSubClan(m_iID, m_iLevel, m_iType, 0);			// ���� 4��° ���ڷ� ���� ������ �ε����� ���� ��. -lpislhy
		//break;
	//default:
	//	break;
	//}
}

function OnHide()
{
	// local MagicSkillWnd sc;

	m_iType = -1;

	//sc = AlchemySkillWnd( GetScript( "AlchemySkillWnd" ) );
	//sc.closeTreeNode();
}


function OnEvent(int Event_ID, string param)
{
	local string strIconName;
	local string strName;
	local INT64 iNumOfItem;

	local int iType;
	local int iID;
	local int iLevel;
	local int iSubLevel;
	
	switch(Event_ID)
	{
		case EV_SkillTrainInfoWndShow :
			 // Debug("-EV_SkillTrainInfoWndShow" @ param);
			 ParseInt(param, "Type", iType);

			 if(iType == SKILLTYPE_ALCHEMYSKILL) 
			 {
				ParseInt(param, "iID", iID);
				ParseInt(param, "iLevel", iLevel);
				ParseInt(param, "iSubLevel", iSubLevel);

				m_iType  = iType;
				m_iID    = iID;
				m_iLevel = iLevel;
				m_iSubLevel = iSubLevel;
				
				Me.ShowWindow();
				Me.SetFocus();

				SkillLearningDetailInfo(param);

				if (!GetWindowHandle("AlchemySkillWnd").IsShowWindow())
				{
					Me.HideWindow();
				}
			 }
			 break;

		case EV_SkillTrainInfoWndAddExtendInfo :
			 //  Debug("EV_SkillTrainInfoWndAddExtendInfo" @ param);			 				
			 // Debug("m_iType" @ m_iType);
			 if(m_iType == SKILLTYPE_ALCHEMYSKILL) 
			 {
				 ParseString(param, "strIconName", strIconName); 
				 ParseString(param, "strName", strName);
				 ParseINT64(param, "iNumOfItem", iNumOfItem);
				
				 AddSkillTrainInfoExtend(strIconName, strName, iNumOfItem);
				 
				 // ��ũ���� ���ؼ� ��Ŀ�� �̵�
				 GetWindowHandle("AlchemySkillWnd").SetFocus();
			 }
			 break;

		case EV_SkillTrainInfoWndHide :
			// Debug("EV_SkillTrainInfoWndHide" @ param);
			//if(m_iType == SKILLTYPE_ALCHEMYSKILL) 
			//{
			//	if(IsShowWindow("AlchemySkillLearnWnd"))
			//		HideWindow("AlchemySkillLearnWnd");
			//}
			break;
	}
}



function AddSkillTrainInfo(string strIconName, string strName, int iID, int iLevel, string strOperateType, int iMPConsume, int iCastRange, string strDescription, int iSPConsume, INT64 iEXPConsume, string strEnchantName, string strEnchantDesc, int iPercent)
{
	// ������ ������
	class'UIAPI_TEXTURECTRL'.static.SetTexture("AlchemySkillLearnWnd.SkillTrainTreeWnd_List1.texIcon", strIconName);
	// ��ų�̸�
	class'UIAPI_TEXTBOX'.static.SetText("AlchemySkillLearnWnd.SkillTrainTreeWnd_List1.txtName", strName);

	// level ����
	class'UIAPI_TEXTBOX'.static.SetInt("AlchemySkillLearnWnd.SkillTrainTreeWnd_List1.txtLevel", iLevel);
	// �۵�Ÿ��
	// class'UIAPI_TEXTBOX'.static.SetText("AlchemySkillLearnWnd.SkillTrainTreeWnd_List1.txtOperateType", strOperateType);
	// �Ҹ�MP
	class'UIAPI_TEXTBOX'.static.SetInt("AlchemySkillLearnWnd.SkillTrainTreeWnd_List1.txtMP", iMPConsume);
	// ��ų���� 
	//class'UIAPI_TEXTBOX'.static.SetText("AlchemySkillLearnWnd.SubWndNormal.txtDescription", strDescription);

	//switch(m_iType)
	//{
	//case ESTT_CLAN :			// ���ͽ�ų�϶��� �ʿ� ���͸�ġ
	//case ESTT_SUB_CLAN:
	//	class'UIAPI_TEXTBOX'.static.SetText("AlchemySkillLearnWnd.SubWndNormal.txtNeedSPString", GetSystemString(1437));
	//	break;
	////case ESTT_NORMAL :			// �׳��� �ʿ�SP
	////case ESTT_FISHING :
	//default:
	//	class'UIAPI_TEXTBOX'.static.SetText("AlchemySkillLearnWnd.SubWndNormal.txtNeedSPString", GetSystemString(365));
	//	break;
	//}
	// �ʿ�SP ����
	//class'UIAPI_TEXTBOX'.static.SetInt("AlchemySkillLearnWnd.SubWndNormal.txtNeedSP", iSPConsume);
	
	//if(iCastRange>=0)
	//{
	//	// �����ְ�
	//	ShowWindow("AlchemySkillLearnWnd.txtCastRangeString");
	//	ShowWindow("AlchemySkillLearnWnd.txtColoneCastRange");
	//	ShowWindow("AlchemySkillLearnWnd.txtCastRange");
	//	class'UIAPI_TEXTBOX'.static.SetInt("AlchemySkillLearnWnd.txtCastRange", iCastRange);
	//}
	//else
	//{
	//	// �����ش�
	//	HideWindow("AlchemySkillLearnWnd.txtCastRangeString");
	//	HideWindow("AlchemySkillLearnWnd.txtColoneCastRange");
	//	HideWindow("AlchemySkillLearnWnd.txtCastRange");
	//}
}

function AddSkillTrainInfoExtend(string strIconName, string strName, INT64 iNumOfItem)
{

	// ������ ������
	//class'UIAPI_TEXTURECTRL'.static.SetTexture("AlchemySkillLearnWnd.texNeedItemIcon", strIconName);

	// ��ų�̸�
	//class'UIAPI_TEXTBOX'.static.SetText("AlchemySkillLearnWnd.txtNeedItemName", ConvertNumToText(String(iNUmOfItem)));	

	// �Ƶ����� ��� 
	if (GetSystemString(469) == strName)
	{			
		txtNeedItemName.SetNameWithColor(MakeFullSystemMsg(getSystemMessage(2932), MakeCostStringINT64(iNUmOfItem)), NCT_Normal,TA_Left, colorItemName);
		
		//class'UIAPI_'.static.SetText("AlchemySkillLearnWnd.txtNeedItemName", MakeFullSystemMsg(getSystemMessage(2932), MakeCostStringINT64(iNUmOfItem)));	
	}
	else
	{
		txtNeedItemName.SetNameWithColor(strName @ MakeFullSystemMsg(getSystemMessage(1983), MakeCostStringINT64(iNUmOfItem)), NCT_Normal,TA_Left, colorItemName);
		//class'UIAPI_TEXTBOX'.static.SetText("AlchemySkillLearnWnd.txtNeedItemName",strName @ MakeFullSystemMsg(getSystemMessage(1983), MakeCostStringINT64(iNUmOfItem)));	
	}

	// txtNeedItemString.SetText(strName$" X "$ string(iNUmOfItem));
}

function OnShow()
{
	// HideWindow("AlchemySkillLearnWnd.SubWndEnchant");
	// ShowWindow("AlchemySkillLearnWnd.SubWndNormal");

	// ��ų â�� ���� �ִٸ�.. �ٽ� �ݴ´�.
	if (!GetWindowHandle("AlchemySkillWnd").IsShowWindow())
	{
		Me.HideWindow();
	}
	// �ʿ��� ������ ���� �����ش�
	//HideWindow("AlchemySkillLearnWnd.SubWndNormal.texNeedItemIcon");
	//HideWindow("AlchemySkillLearnWnd.SubWndNormal.txtNeedItemName");
	//~ ShowWindow("AlchemySkillLearnWnd.txtColoneCastRange");	
}


function ShowNeedItems()
{
	// �����۾����ܰ� �̸�
	// ShowWindow("AlchemySkillLearnWnd.SubWndNormal.texNeedItemIcon");
	// ShowWindow("AlchemySkillLearnWnd.SubWndNormal.txtNeedItemName");
}

function SkillLearningDetailInfo( string param )
{
	//
	local SkillInfo skillinfo;
	
	//��ų ���̵�.
	local int ID;
	//��ų ����
	local int Level;

	//��ų ���� ����
	local int SubLevel;

	//�Ҹ� SP
	local INT64 SpConsume;
	//�䱸���� ( �÷��̾��� ���� ������ ���ؼ� ������ �������� �Ǵ��ϸ��)
	local int RequiredLevel;
	//�䱸���� ( �÷��̾��� ��� Ŭ���� ������ �� �Ͽ� �� ���� �������� �Ǵ�.)
	// local int RequiredDualLevel;

	//Player ����
	local UserInfo userinfo;

	//��ų ���̵�.
	local ItemID cID;

	local string strName;
	local string strIconName;
	
	local string strIconPanel;

	ParseInt(param, "iID", ID);
	ParseInt(param, "iLevel", Level);
	ParseInt(param, "iSubLevel", SubLevel);

	ParseInt64(param, "iSPConsume", SpConsume);

	// ���� ������, �䱸 ���� ���
	RequiredLevel = alchemySkillWndScript.getSkillRequestLevel(ID, Level);

	if (RequiredLevel == -1) 
	{
		GetWindowHandle("AlchemySkillLearnWnd").HideWindow();
		return;
	}

	// Debug("RequiredLevel" @ RequiredLevel);

	cID = GetItemID(ID);
	GetSkillInfo( ID , Level, SubLevel, skillInfo );
	GetPlayerInfo( userinfo );

	strName = skillInfo.SkillName;
	strIconPanel = skillinfo.IconPanel;
	strIconName = class'UIDATA_SKILL'.static.GetIconName( cID, Level, SubLevel );
	
	texIcon.SetTexture( strIconName );
	
	// if( TypeCheck( skillinfo ) == true )
	// {
		//Insert Node Item - ������ ������

	// iconActive.SetTexture( "l2ui_ct1.SkillWnd_DF_ListIcon_Active" );
	
	//iconMP.ShowWindow();
	//iconUse.ShowWindow();
	//iconReuse.ShowWindow();

	//��ų �̸�
	// 4���� ������? ��ų (�ֿ� ��ų�̶� ��������� ǥ�� �ϱ� ���ؼ�..)
	
	if (GetAlchemySkillGradeType(ID, Level) == 4)
		txtName.SetTextColor(util.Yellow03);				
	else
		txtName.SetTextColor(util.BrightWhite);
	
	txtName.SetText( strName );

	//��ų ����
	txtLevel.SetText( string( Level ) );

		////��ų MP �Ҹ�
		//txtMP.SetText( string(skillInfo.MpConsume) );
		////��ų ���� �ð�
		//txtUseTime.SetText( util.MakeTimeString( skillInfo.HitTime, skillInfo.CoolTime ) );
		////��ų ���� �ð�
		//txtReuseTime.SetText( util.MakeTimeString( skillInfo.ReuseDelay) );
	//}
	//else
	//{
	//	iconActive.SetTexture( "l2ui_ct1.SkillWnd_DF_ListIcon_Passive" );
		
	//	//iconMP.HideWindow();
	//	//iconUse.HideWindow();
	//	//iconReuse.HideWindow();

	//	//��ų �̸�
	//	txtName.SetText( strName );
	//	//��ų ����
	//	txtLevel.SetText( string( Level ) );

	//	////��ų MP �Ҹ�
	//	//txtMP.SetText( "" );
	//	////��ų ���� �ð�
	//	//txtUseTime.SetText( "" );
	//	////��ų ���� �ð�
	//	//txtReuseTime.SetText( "" );
	//}

	//��ų ����	
	util.TreeClear( TREENAME );
	//Root ��� ����.
	util.TreeInsertRootNode( TREENAME, "root", "" );
	//Insert Node Item - ������ �̸�
	util.TreeInsertTextNodeItem( TREENAME, "root", class'UIDATA_SKILL'.static.GetDescription( cID, Level, 0 ) );

	//ĳ����Lv ��ġ
	txtNeedChaLv.SetText( string( RequiredLevel ) );

	reSizeWindow();

	//------------------------IconPanel------------------------------->	
	if( strIconPanel == "" ) { strIconPanel = ""; }
	IconPanel.SetTexture( strIconPanel );
	//<------------------------------------------------------------------
	// class'UIAPI_TEXTBOX'.static.SetText("AlchemySkillLearnWnd.txtSP", string( userinfo.nSP ) );
}

function reSizeWindow( optional bool b )
{	
	if( b == true )
	{
		// PrevSkillListBox.ShowWindow();
		// PrevSkillListNone.HideWindow();
		//spBg.SetAnchor( "AlchemySkillLearnWnd.SkillTrainTreeWnd_List1", "BottomLeft", "TopLeft", 0, 5 );
		Me.SetWindowSize( WINDOW_W, WINDOW_H_MAX );
		//needBg.SetTextureSize( 287, 72 );
	}
	else
	{
		//PrevSkillListBox.HideWindow();
		//PrevSkillListNone.ShowWindow();
		//spBg.SetAnchor( "AlchemySkillLearnWnd.SkillTrainTreeWnd_List1", "BottomLeft", "TopLeft", 0, 5 );
		Me.SetWindowSize( WINDOW_W, WINDOW_H_MIN );
		//needBg.SetTextureSize( 287, 47 );
	}
}

function bool TypeCheck( SkillInfo info )
{
	return isActiveSkill(Info.IconType);
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( m_WindowName ).HideWindow();
}

defaultproperties
{
     m_WindowName="AlchemySkillLearnWnd"
     treeName="AlchemySkillLearnWnd.SkillTrainInfoTree"
}
