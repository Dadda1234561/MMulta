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

//**스킬 정보 관련(상단)

//스킬 아이콘
var TextureHandle texIcon;
//액티브/패시브 아이콘
var TextureHandle iconActive;

var TextureHandle IconPanel;

//스킬 이름
var TextBoxHandle txtName;
//txtLevel
var TextBoxHandle txtLevel;
//소모MP 수치
var TextBoxHandle txtMP;
//시전시간 수치
var TextBoxHandle txtUseTime;
//재사용시간 수치
var TextBoxHandle txtReuseTime;

//스킬 설명
//var TextBoxHandle txtDescription;
var HtmlHandle SkillTrainInfoHtml;

//캐릭터Lv 수치
var TextBoxHandle txtNeedChaLv;
//필요SP 수치
var TextBoxHandle txtNeedSP;
//필요아이템[sysstring="2380"]
var TextBoxHandle txtNeedItemString;
//필요아이템 이름
var TextBoxHandle txtNeedItemName;

//듀얼 클래스용
//SystemString(2969) : 듀얼 클래스 Lv
var TextBoxHandle txtNeedDualLvString;
//중간 콜론
var TextBoxHandle txtColoneDualLv;
//캐릭터 듀얼 클래스 v 수치
var TextBoxHandle txtNeedDualLv;


//소모MP 아이콘
var TextureHandle iconMP;
//시전시간 아이콘
var TextureHandle iconUse;
//재사용 아이콘
var TextureHandle iconReuse;



var TextureHandle spBg;

var WindowHandle PrevSkillListBox;

var WindowHandle PrevSkillListNone;


var MagicSkillWnd MagicSkillWndScript;

//스킬 배우기용 변수
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
// 임시 - lancelot 2007. 3. 26.
	//local int type;
	//type=-1;
	
	//switch(m_iType)
	//{
	//case ESTT_NORMAL :
	//case ESTT_FISHING :
	//case ESTT_CLAN :
	//case ESTT_TRANSFORM :
	//case 5:
	//		// 서브잡스킬
	//case 6:
	//		//채집스킬
		RequestAcquireSkill(m_iID, m_iLevel, m_iSubLevel, m_iType);
		//case ESTT_SUB_CLAN:
		//RequestAcquireSkillSubClan(m_iID, m_iLevel, m_iType, 0);			// 여기 4번째 인자로 하위 혈맹의 인덱스를 넣을 것. -lpislhy
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
	
		if(m_iType == ESTT_SUB_CLAN) return;		// 하위부대 스킬이면 무시
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
		if(m_iType == ESTT_SUB_CLAN) return;		// 하위부대 스킬이면 무시
		ParseString(param, "strIconName", strIconName); 
		ParseString(param, "strName", strName);
		ParseINT64(param, "iNumOfItem", iNumOfItem);
		
		AddSkillTrainInfoExtend(strIconName, strName, iNumOfItem);
		ShowNeedItems();
		break;

	case EV_SkillTrainInfoWndHide :
		if(m_iType == ESTT_SUB_CLAN) return;		// 하위부대 스킬이면 무시
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



// 스킬 트레이닝 윈도우 초기화 시킴
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

	class'UIAPI_WINDOW'.static.SetWindowTitle("SkillTrainInfoWnd", iWindowTitle);					// 윈도 타이틀 변경
	//SetBackTex("L2UI_CH3.SkillTrainWnd.SkillTrain2");									// 9등분할을 적용하면서 삭제
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtSPString", GetSystemString(iSPIdx));	// SP or 혈맹명성치 글씨
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtSP", iPlayerSP);						// SP or 혈맹명성치

	ShowWindowWithFocus("SkillTrainInfoWnd");
}

function AddSkillTrainInfo(string strIconName, string strName, int iID, int iLevel, string strOperateType, int iMPConsume, int iCastRange, string strDescription, int iSPConsume, INT64 iEXPConsume, string strEnchantName, string strEnchantDesc, int iPercent)
{
	// 아이템 아이콘
	class'UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.texIcon", strIconName);
	// 스킬이름
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtName", strName);

	// level 숫자
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtLevel", iLevel);
	// 작동타입
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtOperateType", strOperateType);
	// 소모MP
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtMP", iMPConsume);
	// 스킬설명 
	//class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtDescription", strDescription);

	switch(m_iType)
	{
	case ESTT_CLAN :			// 혈맹스킬일때는 필요 혈맹명성치
	case ESTT_SUB_CLAN:
		class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString", GetSystemString(1437));
		break;
	//case ESTT_NORMAL :			// 그냥은 필요SP
	//case ESTT_FISHING :
	default:
		class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString", GetSystemString(365));
		break;
	}
	// 필요SP 숫자
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.SubWndNormal.txtNeedSP", iSPConsume);
	
	if(iCastRange>=0)
	{
		// 보여주고
		ShowWindow("SkillTrainInfoWnd.txtCastRangeString");
		ShowWindow("SkillTrainInfoWnd.txtColoneCastRange");
		ShowWindow("SkillTrainInfoWnd.txtCastRange");
		class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtCastRange", iCastRange);
	}
	else
	{
		// 숨겨준다
		HideWindow("SkillTrainInfoWnd.txtCastRangeString");
		HideWindow("SkillTrainInfoWnd.txtColoneCastRange");
		HideWindow("SkillTrainInfoWnd.txtCastRange");
	}
}

function AddSkillTrainInfoExtend(string strIconName, string strName, INT64 iNumOfItem)
{
	// 아이템 아이콘
	class'UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon", strIconName);
	// 스킬이름
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName", strName$" X "$ string(iNUmOfItem));
}*/

function OnShow()
{

	HideWindow("SkillTrainInfoWnd.SubWndEnchant");
	ShowWindow("SkillTrainInfoWnd.SubWndNormal");

	// 스킬 창이 닫혀 있다면.. 다시 닫는다.
	if (!GetWindowHandle("MagicSkillWnd").IsShowWindow() || !MagicSkillWndScript.isSkillLearnTab())
	{
		Me.HideWindow();
	}
	// 필요한 아이템 정보 숨겨준다
	//HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
	//HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
	//~ ShowWindow("SkillTrainInfoWnd.txtColoneCastRange");	
}

/*
function ShowNeedItems()
{
	// 아이템아이콘과 이름
	ShowWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
	ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
}*/

function SkillLearningDetailInfo( string param )
{
	//
	local SkillInfo skillinfo;
	
	//스킬 아이디.
	local int ID;
	//스킬 레벨
	local int Level;
	local int SubLevel;
	//소모 SP
	local INT64 SpConsume;
	//요구레벨 ( 플레이어의 현재 레벨과 비교해서 못배우는 것인지를 판단하면됨)
	local int RequiredLevel;
	//요구레벨 ( 플레이어의 듀얼 클래스 레벨과 비교 하여 못 배우는 것인지를 판단.)
	local int RequiredDualLevel;

	//Player 정보
	local UserInfo userinfo;

	//스킬 아이디.
	local ItemID cID;

	//스킬에 필요한 아이템 갯수 
	local int RequiredItemTotalCnt;
	//ItemID (위에 총 갯수만큼 반복) 
	local int requiredItemID;
	//Item 필요갯수 (위에 총 갯수만큼 반복) 
	local INT64 requiredItemCnt;

	//스킬에 필요한 선행 스킬 갯수 
	local int RequiredSkillCnt;
	//필요 Skill의 ID (위에 총 갯수만큼 반복) 
	local int requiredSkillID;
	//필요 Skill의 level (위에 총 갯수만큼 반복) 
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
		//Insert Node Item - 아이템 아이콘

		iconActive.SetTexture( "l2ui_ct1.SkillWnd_DF_ListIcon_Active" );
		
		iconMP.ShowWindow();
		iconUse.ShowWindow();
		iconReuse.ShowWindow();

		//스킬 이름
		txtName.SetText( strName );
		//스킬 레벨
		txtLevel.SetText( string( Level ) );
		//스킬 MP 소모량
		txtMP.SetText( string(skillInfo.MpConsume) );
		//스킬 시전 시간
		txtUseTime.SetText( util.MakeTimeString( skillInfo.HitTime, skillInfo.CoolTime ) );
		//스킬 재사용 시간
		txtReuseTime.SetText( util.MakeTimeString( skillInfo.ReuseDelay) );
	}
	else
	{
		iconActive.SetTexture( "l2ui_ct1.SkillWnd_DF_ListIcon_Passive" );
		
		iconMP.HideWindow();
		iconUse.HideWindow();
		iconReuse.HideWindow();

		//스킬 이름
		txtName.SetText( strName );
		//스킬 레벨
		txtLevel.SetText( string( Level ) );
		//스킬 MP 소모량
		txtMP.SetText( "" );
		//스킬 시전 시간
		txtUseTime.SetText( "" );
		//스킬 재사용 시간
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

	//캐릭터Lv 수치
	txtNeedChaLv.SetText( string( RequiredLevel ) );

	//캐릭터 듀얼 Lv 수치
	//듀얼클래스 레벨
	if( RequiredDualLevel > 0 )
	{
		txtNeedDualLvString.ShowWindow();
		txtColoneDualLv.ShowWindow();
		txtNeedDualLv.ShowWindow();
		//듀얼 클래스 Lv
		txtNeedDualLv.SetText( string(RequiredDualLevel) );
	}
	else
	{
		txtNeedDualLvString.HideWindow();
		txtColoneDualLv.HideWindow();
		txtNeedDualLv.HideWindow();
	}


	//필요 SP
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
			
			// 삭제될 스킬 리스트 표시 - 20120518 정우균 -
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
 * 윈도우 ESC 키로 닫기 처리 
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
