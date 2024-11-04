class SkillLearnWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// CONSTc
//////////////////////////////////////////////////////////////////////////////

const DIALOGID_SkillLearn = 3864;

const OFFSET_X_ICON_TEXTURE=0;
const OFFSET_Y_ICON_TEXTURE=4;
const OFFSET_Y_SECONDLINE = -14;

const OFFSET_Y_MPCONSUME=3;
const OFFSET_Y_CASTRANGE=0;
const OFFSET_Y_SP=120;

const WINDOW_W = 300;
const WINDOW_H_MIN = 441;
const WINDOW_H_MAX = 547;

var int m_iType;
var int m_iID;
var int m_iLevel;
var int m_iSubLevel;

var WindowHandle Me;

var String m_WindowName;

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
var HtmlHandle SkillTrainInfoHtml;

//ĳ����Lv ��ġ
var TextBoxHandle txtNeedChaLv;
//�ʿ�SP ��ġ
var TextBoxHandle txtNeedSP;
//�ʿ������[sysstring="2380"]
var TextBoxHandle txtNeedItemString;
//�ʿ������ �̸�
var TextBoxHandle txtNeedItemName;

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



var TextureHandle spBg;

var WindowHandle PrevSkillListBox;

var WindowHandle PrevSkillListNone;


var MagicSkillWnd MagicSkillWndScript;

//��ų ����� ����
var L2Util util;

var string LearnNeedItemName;
var INT64 LearnNeedItemNum;
var INT64 LearnSpConsume;
var string LearnNeedItemString;

function OnRegisterEvent()
{
	//RegisterEvent( EV_SkillTrainInfoWndShow );
	//RegisterEvent( EV_SkillTrainInfoWndHide );
	//RegisterEvent( EV_SkillTrainInfoWndAddExtendInfo );
	RegisterEvent( EV_SkillLearningDetailInfo );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
}

function OnLoad()
{
//	if(CREATE_ON_DEMAND==0)
	SetClosingOnESC();

	OnRegisterEvent();

	Me = GetWindowHandle( "SkillLearnWnd" );

	texIcon = GetTextureHandle( "SkillLearnWnd.texIcon" );
	iconActive = GetTextureHandle( "SkillLearnWnd.iconActive" );
	IconPanel = GetTextureHandle( "SkillLearnWnd.IconPanel" );

	txtName = GetTextBoxHandle ( "SkillLearnWnd.txtName" );
	txtLevel = GetTextBoxHandle ( "SkillLearnWnd.txtLevel" );
	txtMP = GetTextBoxHandle ( "SkillLearnWnd.txtMP" );
	txtUseTime = GetTextBoxHandle ( "SkillLearnWnd.txtUseTime" );
	txtReuseTime = GetTextBoxHandle ( "SkillLearnWnd.txtReuseTime" );
	//txtDescription = GetTextBoxHandle ( "SkillLearnWnd.txtDescription" );
	txtNeedChaLv = GetTextBoxHandle ( "SkillLearnWnd.txtNeedChaLv" );
	txtNeedSP = GetTextBoxHandle ( "SkillLearnWnd.txtNeedSP" );
	txtNeedItemString = GetTextBoxHandle ( "SkillLearnWnd.txtNeedItemString" );
	txtNeedItemName = GetTextBoxHandle ( "SkillLearnWnd.txtNeedItemName" );

	txtNeedDualLvString = GetTextBoxHandle ( "SkillLearnWnd.txtNeedDualLvString" );
	txtColoneDualLv = GetTextBoxHandle ( "SkillLearnWnd.txtColoneDualLv" );
	txtNeedDualLv = GetTextBoxHandle ( "SkillLearnWnd.txtNeedDualLv" );

	iconMP = GetTextureHandle( "SkillLearnWnd.iconMP" );
	iconUse = GetTextureHandle( "SkillLearnWnd.iconUse" );
	iconReuse = GetTextureHandle( "SkillLearnWnd.iconReuse" );
	
	spBg = GetTextureHandle( "SkillLearnWnd.spBg" );

	PrevSkillListBox = GetWindowHandle( "SkillLearnWnd.PrevSkillListBox" );
	PrevSkillListNone = GetWindowHandle( "SkillLearnWnd.PrevSkillListNone" );
	SkillTrainInfoHtml = GetHtmlHandle("SkillLearnWnd.SkillTrainInfoHtml");
	util = L2Util(GetScript("L2Util"));	
	MagicSkillWndScript = MagicSkillWnd( GetScript( "MagicSkillWnd" ) );
}

function OnClickButton( string strBtnID )
{
	switch(strBtnID)
	{
	case "btnLearn" :
		ShowDialogLearn();
		break;
	case "btnGoBackList" :
		HideWindow("SkillLearnWnd");
		//ShowWindowWithFocus("SkillTrainListWnd");
		break;
	}
}

function ShowDialogLearn()
{
	local string htmlAdd;

	if(LearnNeedItemNum != 0)
	{
		DialogSetID(DIALOGID_SkillLearn);
		htmlAdd = htmlAddTableTD(htmlAddImg("L2UI_ct1.Icon.ICON_DF_Exclamation", 32, 32), "Left", "Top", 0, 0, "", true) $ htmlAddTableTD(htmlAddImg("L2UI_CT1.EmptyBtn", 4, 32), "Left", "Center", 0, 0, "", true) $ htmlAddTableTD(htmlAddText(GetSystemString(365) $ " : ", "GameDefault", "c8c8c8") $ htmlAddText(string(LearnSpConsume) $ "<br1>", "GameDefault", "AF9878") $ htmlAddText(GetSystemString(2380) $ " : ", "GameDefault", "c8c8c8") $ htmlAddText(LearnNeedItemString $ "<br1>", "GameDefault", "AF9878"), "Left", "Top", 0, 0, "", false);
		htmlSetTableTR(htmlAdd);
		htmlSetTable(htmlAdd, 0, 340, 0, "", 0, 0);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, htmlAdd, string(self), 382, 160, true);
	}
	else
	{
		OnLearn();
	}
}

function OnLearn()
{
	HideWindow("SkillLearnWnd");
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
	local MagicSkillWnd sc;

	sc = MagicSkillWnd( GetScript( "MagicSkillWnd" ) );
	sc.closeTreeNode();
	// End:0x52
	if(DialogIsMine())
	{
		class'UIAPI_WINDOW'.static.HideWindow("DialogBox");
	}
}


function OnEvent(int Event_ID, string param)
{
	/*
	local int iType;

	local string strIconName;
	local string strName;
	local int iID;
	local int iLevel;
	local int iSPConsume;
	local INT64 iEXPConsume;

	local string strDescription;
	local string strOperateType;

	local int iMPConsume;
	local int iCastRange;
	local INT64 iNumOfItem;

	local string strEnchantName;
	local string strEnchantDesc;

	local int iPercent;*/


	switch(Event_ID)
	{
		/*
	case EV_SkillTrainInfoWndShow :
		ParseInt(param, "Type", iType);
		m_iType=iType;
	
		if(m_iType == ESTT_SUB_CLAN) return;		// �����δ� ��ų�̸� ����
		ParseString(param, "strIconName", strIconName); 
		ParseString(param, "strName", strName);
		ParseInt(param, "iID", iID);
		ParseInt(param, "iLevel", iLevel);
		ParseString(param, "strOperateType", strOperateType);
		ParseInt(param, "iMPConsume", iMPConsume);
		ParseInt(param, "iCastRange", iCastRange);
		ParseInt(param, "iSPConsume", iSPConsume);
		ParseString(param, "strDescription", strDescription);
		ParseInt64(param, "iEXPConsume", iEXPConsume);
		ParseString(param, "strEnchantName", strEnchantName);
		ParseString(param, "strEnchantDesc", strEnchantDesc);
		ParseInt(param, "iPercent", iPercent);

		m_iType=iType;
		m_iID=iID;
		m_iLevel=iLevel;

		ShowSkillTrainInfoWnd();
		AddSkillTrainInfo(strIconName, strName, iID, iLevel, strOperateType, iMPConsume, iCastRange, strDescription, iSPConsume, iEXPConsume, strEnchantName, strEnchantDesc, iPercent);
		break;

	case EV_SkillTrainInfoWndAddExtendInfo :
		if(m_iType == ESTT_SUB_CLAN) return;		// �����δ� ��ų�̸� ����
		ParseString(param, "strIconName", strIconName); 
		ParseString(param, "strName", strName);
		ParseINT64(param, "iNumOfItem", iNumOfItem);
		
		AddSkillTrainInfoExtend(strIconName, strName, iNumOfItem);
		ShowNeedItems();
		break;

	case EV_SkillTrainInfoWndHide :
		if(m_iType == ESTT_SUB_CLAN) return;		// �����δ� ��ų�̸� ����
		if(IsShowWindow("SkillTrainInfoWnd"))
			HideWindow("SkillTrainInfoWnd");
		break;
*/
	case EV_SkillLearningDetailInfo :
		Me.ShowWindow();
		//Me.SetFocus();
		SkillLearningDetailInfo(param);
		break;
		
	case EV_DialogOK:
		HandleDialogOK();
		break;
	case EV_DialogCancel:
		HandleDialogCancel();
		break;
	}
}



// ��ų Ʈ���̴� ������ �ʱ�ȭ ��Ŵ
/*
function ShowSkillTrainInfoWnd()
{
	local int iWindowTitle;
	local int iSPIdx;

	local UserInfo infoPlayer;
	local int iPlayerSP;
	local INT64 iPlayerEXP;

	GetPlayerInfo(infoPlayer);

	switch(m_iType)
	{
	case ESTT_CLAN :
	case ESTT_SUB_CLAN:
		iWindowTitle=1436;
		iSPIdx=1372;
		iPlayerSP=GetClanNameValue(infoPlayer.nClanID);
		break;
	//case ESTT_NORMAL :
	//case ESTT_FISHING :
	default:
		iWindowTitle=477;
		iSPIdx=92;
		iPlayerSP=infoPlayer.nSP;
		iPlayerEXP=infoPlayer.nCurExp;
		break;
	}

	class'UIAPI_WINDOW'.static.SetWindowTitle("SkillTrainInfoWnd", iWindowTitle);					// ���� Ÿ��Ʋ ����
	//SetBackTex("L2UI_CH3.SkillTrainWnd.SkillTrain2");									// 9������� �����ϸ鼭 ����
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtSPString", GetSystemString(iSPIdx));	// SP or ���͸�ġ �۾�
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtSP", iPlayerSP);						// SP or ���͸�ġ

	ShowWindowWithFocus("SkillTrainInfoWnd");
}

function AddSkillTrainInfo(string strIconName, string strName, int iID, int iLevel, string strOperateType, int iMPConsume, int iCastRange, string strDescription, int iSPConsume, INT64 iEXPConsume, string strEnchantName, string strEnchantDesc, int iPercent)
{
	// ������ ������
	class'UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.texIcon", strIconName);
	// ��ų�̸�
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtName", strName);

	// level ����
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtLevel", iLevel);
	// �۵�Ÿ��
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtOperateType", strOperateType);
	// �Ҹ�MP
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtMP", iMPConsume);
	// ��ų���� 
	//class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtDescription", strDescription);

	switch(m_iType)
	{
	case ESTT_CLAN :			// ���ͽ�ų�϶��� �ʿ� ���͸�ġ
	case ESTT_SUB_CLAN:
		class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString", GetSystemString(1437));
		break;
	//case ESTT_NORMAL :			// �׳��� �ʿ�SP
	//case ESTT_FISHING :
	default:
		class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString", GetSystemString(365));
		break;
	}
	// �ʿ�SP ����
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.SubWndNormal.txtNeedSP", iSPConsume);
	
	if(iCastRange>=0)
	{
		// �����ְ�
		ShowWindow("SkillTrainInfoWnd.txtCastRangeString");
		ShowWindow("SkillTrainInfoWnd.txtColoneCastRange");
		ShowWindow("SkillTrainInfoWnd.txtCastRange");
		class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtCastRange", iCastRange);
	}
	else
	{
		// �����ش�
		HideWindow("SkillTrainInfoWnd.txtCastRangeString");
		HideWindow("SkillTrainInfoWnd.txtColoneCastRange");
		HideWindow("SkillTrainInfoWnd.txtCastRange");
	}
}

function AddSkillTrainInfoExtend(string strIconName, string strName, INT64 iNumOfItem)
{
	// ������ ������
	class'UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon", strIconName);
	// ��ų�̸�
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName", strName$" X "$ string(iNUmOfItem));
}*/

function OnShow()
{

	HideWindow("SkillTrainInfoWnd.SubWndEnchant");
	ShowWindow("SkillTrainInfoWnd.SubWndNormal");

	// ��ų â�� ���� �ִٸ�.. �ٽ� �ݴ´�.
	if (!GetWindowHandle("MagicSkillWnd").IsShowWindow() || !MagicSkillWndScript.isSkillLearnTab())
	{
		Me.HideWindow();
	}
	// �ʿ��� ������ ���� �����ش�
	//HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
	//HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
	//~ ShowWindow("SkillTrainInfoWnd.txtColoneCastRange");	
}

/*
function ShowNeedItems()
{
	// �����۾����ܰ� �̸�
	ShowWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
	ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
}*/

function SkillLearningDetailInfo( string param )
{
	//
	local SkillInfo skillinfo;
	
	//��ų ���̵�.
	local int ID;
	//��ų ����
	local int Level;
	local int SubLevel;
	//�Ҹ� SP
	local INT64 SpConsume;
	//�䱸���� ( �÷��̾��� ���� ������ ���ؼ� ������ �������� �Ǵ��ϸ��)
	local int RequiredLevel;
	//�䱸���� ( �÷��̾��� ��� Ŭ���� ������ �� �Ͽ� �� ���� �������� �Ǵ�.)
	local int RequiredDualLevel;

	//Player ����
	local UserInfo userinfo;

	//��ų ���̵�.
	local ItemID cID;

	//��ų�� �ʿ��� ������ ���� 
	local int RequiredItemTotalCnt;
	//ItemID (���� �� ������ŭ �ݺ�) 
	local int requiredItemID;
	//Item �ʿ䰹�� (���� �� ������ŭ �ݺ�) 
	local INT64 requiredItemCnt;

	//��ų�� �ʿ��� ���� ��ų ���� 
	local int RequiredSkillCnt;
	//�ʿ� Skill�� ID (���� �� ������ŭ �ݺ�) 
	local int requiredSkillID;
	//�ʿ� Skill�� level (���� �� ������ŭ �ݺ�) 
	local int requiredSkillLevel;

	local ItemID requiredID;

	local int i;

	local string strName;
	local string strIconName;
	
	//<-------------IconPanel-----------------------
	local string strIconPanel;
	local string strHtm;
	local string skillDescription;

	ParseInt(param, "ID", ID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "SubLevel", SubLevel);
	ParseInt64(param, "SpConsume", SpConsume);
	ParseINT64(param,"SpConsume",LearnSpConsume);

	ParseInt(param, "RequiredLevel", RequiredLevel);
	ParseInt(param, "RequiredDualLevel", RequiredDualLevel);

	ParseInt(param, "RequiredItemTotalCnt", RequiredItemTotalCnt);
	ParseInt(param, "RequiredSkillCnt", RequiredSkillCnt);

	cID = GetItemID(ID);
	GetSkillInfo( ID , Level, SubLevel, skillInfo );
	GetPlayerInfo( userinfo );

	strName = skillInfo.SkillName;
	strIconPanel = skillinfo.IconPanel;
	strIconName = class'UIDATA_SKILL'.static.GetIconName( cID, Level, 0 );
	
	texIcon.SetTexture( strIconName );
	
	if( TypeCheck( skillinfo ) == true )
	{
		//Insert Node Item - ������ ������

		iconActive.SetTexture( "l2ui_ct1.SkillWnd_DF_ListIcon_Active" );
		
		iconMP.ShowWindow();
		iconUse.ShowWindow();
		iconReuse.ShowWindow();

		//��ų �̸�
		txtName.SetText( strName );
		//��ų ����
		txtLevel.SetText( string( Level ) );
		//��ų MP �Ҹ�
		txtMP.SetText( string(skillInfo.MpConsume) );
		//��ų ���� �ð�
		txtUseTime.SetText( util.MakeTimeString( skillInfo.HitTime, skillInfo.CoolTime ) );
		//��ų ���� �ð�
		txtReuseTime.SetText( util.MakeTimeString( skillInfo.ReuseDelay) );
	}
	else
	{
		iconActive.SetTexture( "l2ui_ct1.SkillWnd_DF_ListIcon_Passive" );
		
		iconMP.HideWindow();
		iconUse.HideWindow();
		iconReuse.HideWindow();

		//��ų �̸�
		txtName.SetText( strName );
		//��ų ����
		txtLevel.SetText( string( Level ) );
		//��ų MP �Ҹ�
		txtMP.SetText( "" );
		//��ų ���� �ð�
		txtUseTime.SetText( "" );
		//��ų ���� �ð�
		txtReuseTime.SetText( "" );
	}

	skillDescription = class'UIDATA_SKILL'.static.GetDescription(cID, Level, 0);
	skillDescription = Substitute(skillDescription, "<", "&lt;", false);
	skillDescription = Substitute(skillDescription, ">", "&gt;", false);
	skillDescription = Substitute(skillDescription, "&lt;font", "<font", false);
	skillDescription = Substitute(skillDescription, "\"&gt;", "\">", false);
	skillDescription = Substitute(skillDescription, "&lt;/font&gt;", "</font>", false);
	skillDescription = Substitute(skillDescription, "\\n\\n", "<br>", false);
	skillDescription = Substitute(skillDescription, "\\n", "<br1>", false);
	strHtm = "";
	SkillTrainInfoHtml.LoadHtmlFromString(htmlSetHtmlStart(strHtm $ htmlAddText(skillDescription, "GameDefault", "afb9cd")));
	GetWindowHandle("MagicSkillWnd").SetFocus();

	//ĳ����Lv ��ġ
	txtNeedChaLv.SetText( string( RequiredLevel ) );

	//ĳ���� ��� Lv ��ġ
	//���Ŭ���� ����
	if( RequiredDualLevel > 0 )
	{
		txtNeedDualLvString.ShowWindow();
		txtColoneDualLv.ShowWindow();
		txtNeedDualLv.ShowWindow();
		//��� Ŭ���� Lv
		txtNeedDualLv.SetText( string(RequiredDualLevel) );
	}
	else
	{
		txtNeedDualLvString.HideWindow();
		txtColoneDualLv.HideWindow();
		txtNeedDualLv.HideWindow();
	}


	//�ʿ� SP
	txtNeedSP.SetText( string(SpConsume) );
	txtNeedItemName.SetText("");
	LearnNeedItemString = "";
	if( RequiredItemTotalCnt > 0 )
	{
		for(  i = 1 ; i <= RequiredItemTotalCnt ; i++ )
		{
			Parseint( param, "requiredItemID"$i, requiredItemID );
			ParseInt64( param, "requiredItemCnt"$i, requiredItemCnt);
			LearnNeedItemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(requiredItemID));
			LearnNeedItemNum = requiredItemCnt;
			txtNeedItemName.SetText(txtNeedItemName.GetText() $ LearnNeedItemName $ " x" $ MakeCostStringINT64(LearnNeedItemNum) $ "\\n");
			LearnNeedItemString = LearnNeedItemString $ LearnNeedItemName $ " x" $ MakeCostStringINT64(LearnNeedItemNum) $ "<br1>";
		}   
		//txtNeedItemName.SetText( string( RequiredItemTotalCnt ) );
	}
	else
	{
		LearnNeedItemNum = 0;
		txtNeedItemName.SetText( GetSystemString(27) );
	}	

	if( RequiredSkillCnt > 0 )
	{
		reSizeWindow(true);
		showLearningSkill(RequiredSkillCnt);

		for( i = 1 ; i <= RequiredSkillCnt ; i++ )
		{
			ParseInt(param, "requiredSkillID"$i, requiredSkillID);
			ParseInt(param, "requiredSkillLevel"$i, requiredSkillLevel);
			
			requiredID = GetItemID( requiredSkillID );
			
			// ������ ��ų ����Ʈ ǥ�� - 20120518 ����� -
			GetTextureHandle( "texPrevSkillIcon"$ i ).SetTexture( class'UIDATA_SKILL'.static.GetIconName( requiredID, requiredSkillLevel, 0 ) );
			GetTextureHandle( "texPrevSkillIcon"$ i ).SetTextureSize(32, 32);

			if( class'UIDATA_SKILL'.static.SkillIsNewOrUp(requiredID) == 0 )
			{
				//util.ToopTipInsertTexture( "l2ui_ct1.ItemWindow_IconDisable" , , , -16);
			    GetTextBoxHandle( "txtPrevName"$ i ).SetText( class'UIDATA_SKILL'.static.GetName( requiredID, requiredSkillLevel, 0 ) );
				GetTextBoxHandle( "txtPrevLevel"$ i ).SetText( string(requiredSkillLevel) );
				GetTextureHandle( "texPrevSkillIconUp"$ i ).ShowWindow();
			}
			else
			{
				GetTextBoxHandle( "txtPrevName"$ i ).SetText( class'UIDATA_SKILL'.static.GetName( requiredID, requiredSkillLevel, 0 ) );
				GetTextBoxHandle( "txtPrevLevel"$ i ).SetText( string(requiredSkillLevel) );
				GetTextureHandle( "texPrevSkillIconUp"$ i ).HideWindow();
			}
		}
	}
	else
	{
		reSizeWindow();
	}
	m_iType=0;
	m_iID=ID;
	m_iLevel=Level;
	m_iSubLevel=SubLevel;

	//------------------------IconPanel------------------------------->	
	if( strIconPanel == "" ) { strIconPanel = ""; }
	IconPanel.SetTexture( strIconPanel );
	//<------------------------------------------------------------------
	class'UIAPI_TEXTBOX'.static.SetText("SkillLearnWnd.txtSP", string( userinfo.nSP ) );
}

function string addHtmContent(string Title, string Context)
{
	local string htm;

	htm = htmlAddText(Title $ " : ", "GameDefault", "afb9cd") $ htmlAddText(Context, "GameDefault", "af0900") $ "<br1>";
	return htm;
}

function reSizeWindow( optional bool b )
{	
	if( b == true )
	{
		PrevSkillListBox.ShowWindow();
		PrevSkillListNone.HideWindow();
		spBg.SetAnchor( "SkillLearnWnd.PrevSkillListBox", "BottomLeft", "TopLeft", 0, 5 );
		Me.SetWindowSize( WINDOW_W, WINDOW_H_MAX );
		//needBg.SetTextureSize( 287, 72 );
	}
	else
	{
		PrevSkillListBox.HideWindow();
		PrevSkillListNone.ShowWindow();
		spBg.SetAnchor( "SkillLearnWnd.PrevSkillListNone", "BottomLeft", "TopLeft", 0, 5 );
		Me.SetWindowSize( WINDOW_W, WINDOW_H_MIN );
		//needBg.SetTextureSize( 287, 47 );
	}
}

function showLearningSkill( int count )
{
	local int i;

	for( i = 1 ; i <= 5 ; i++ )
	{
		if( i <= count )
		{
			GetWindowHandle( "PrevSkillList"$i ).ShowWindow();
		}
		else
		{
			GetWindowHandle( "PrevSkillList"$i ).HideWindow();
		}
	}
}

function bool TypeCheck( SkillInfo info )
{
	return isActiveSkill(Info.IconType);
}

function HandleDialogCancel()
{
}

function HandleDialogOK()
{
	local int Id;

	if ( !Class'UICommonAPI'.static.DialogIsOwnedBy(string(self)) )
		return;

	Id = Class'UICommonAPI'.static.DialogGetID();
	if ( Id == DIALOGID_SkillLearn )
		OnLearn();
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
     m_WindowName="SkillLearnWnd"
}
