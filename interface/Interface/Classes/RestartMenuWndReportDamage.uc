/***
 *   ���� ����Ʈ (����, ����ŸƮ â), ���� ������ ��� ���� â
 **/
class RestartMenuWndReportDamage extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;

var RichListCtrlHandle ItemListCtrl;
var ButtonHandle   closeBtn;

var L2Util util;


var String lastParam ;


struct DieInfoDamageData 
{
	var AttackerTypeEnum  AttackerType;
	var string AttackerName;
	var string PledgeName;
	var int SkillClassID;
	var int64 Damage;
	var DamageTypeEnum DamageType;
};

function OnRegisterEvent()
{
	RegisterEvent(EV_DieInfoBegin  );
	RegisterEvent(EV_DieInfoEnd  );
	// RegisterEvent(EV_DieInfoDropItem  );
	RegisterEvent(EV_DieInfoDamage  );
}

function OnEvent ( int eventID, string param ) 
{

	// Debug ( "OnEvent" @ eventID @ param ) ;
	switch ( eventID ) 
	{
		case EV_DieInfoBegin :
			handleDieInfoBegin();
			break;
		case EV_DieInfoDamage : 
			handleDieInfoDamage( param );
			break;		
		//case EV_DieInfoDropItem : 
		//	handleDieInfoDropitem ( param );
		//	break;
		case EV_DieInfoEnd : 
			handleDieInfoEnd();
			break;
	}
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

// OnClickButton
function OnClickButton( string Name )
{
	switch( Name )
	{
		case "minCloseButton" :
		case "CloseBtn":
			 Me.HideWindow();
			 break;
	}
}


function handleDieInfoBegin ()
{
	ItemListCtrl.DeleteAllItem();
}

function string GetSkillIconNameByDamageType ( DamageTypeEnum damageType ) 
{
	switch ( damageType ) 
	{
		// �Ϲ� 
		case DamageTypeEnum.DAMAGE_NORMAL  : 
		case DamageTypeEnum.DAMAGE_CHRONO :
		case DamageTypeEnum.DAMAGE_FIST  : 
			return "Icon.action_i.action003" ;
		break;
		// ����
		case DamageTypeEnum.DAMAGE_HEIGHT  : 
			return "L2UI_CT1.Icon.restart_FallDeath_ICON" ;
		break;
		// �� ������
		case DamageTypeEnum.DAMAGE_WATER  : 
			return "L2UI_CT1.Icon.restart_drownDeath_ICON" ;
		break;
		// ������ ��
		case DamageTypeEnum.DAMAGE_AREA  : 	
			return "Icon.skill_i.skill11032";
		break;
		// ������
		case DamageTypeEnum.DAMAGE_POISON  : 
			return "Icon.skill_i.skill6435" ;
		break;
		// ���� ������
		case DamageTypeEnum.DAMAGE_TRANSFER  : 
			return "Icon.skill_i.skill1262" ; 
		break;
		// �ݻ� ������ 
		case DamageTypeEnum.DAMAGE_SHIELD  : 
			return "Icon.skill_i.skill0086" ;
		break;
		// ��ų
		case DamageTypeEnum.DAMAGE_SKILL  : 
		case DamageTypeEnum.DAMAGE_OVER_HIT  : 
		case DamageTypeEnum.DAMAGE_SUICIDE_SKILL  : 
		// ��Ÿ 
		case DamageTypeEnum.DAMAGE_SUICIDE  : 
		case DamageTypeEnum.DAMAGE_CURSED_WEAPON_EXPIRED  : 
		case DamageTypeEnum.DAMAGE_EVENT  : 
		case DamageTypeEnum.DAMAGE_END  :		
		default: 
			return "L2UI_CT1.Icon.restart_etcDeath_ICON" ;
			break;
	}
	return "Icon.action_i.action003" ;
}

function int GetSkillStringByDamageType (DamageTypeEnum DamageType) 
{
	switch ( damageType ) 
	{
		// �Ϲ� 
		case DamageTypeEnum.DAMAGE_NORMAL  : 
		case DamageTypeEnum.DAMAGE_CHRONO :
		case DamageTypeEnum.DAMAGE_FIST  : 
			return 3998 ;
		break;
		// ����
		case DamageTypeEnum.DAMAGE_HEIGHT  : 
			return 3999 ;
		break;
		// �� ������
		case DamageTypeEnum.DAMAGE_WATER  : 
			return 4000 ; 
		break;
		// ������ ��
		case DamageTypeEnum.DAMAGE_AREA  : 	
			return 13001;
		break;
		// ������
		case DamageTypeEnum.DAMAGE_POISON  : 
			return 13002 ;
		break;
		// ���� ������
		case DamageTypeEnum.DAMAGE_TRANSFER  : 
			return 13003 ; 
		break;
		// �ݻ� ������ 
		case DamageTypeEnum.DAMAGE_SHIELD  : 
			return 13004 ;
		break;
		// ��ų
		case DamageTypeEnum.DAMAGE_SKILL  : 
		case DamageTypeEnum.DAMAGE_OVER_HIT  : 
		case DamageTypeEnum.DAMAGE_SUICIDE_SKILL  : 
		// ��Ÿ 
		case DamageTypeEnum.DAMAGE_SUICIDE  : 
		case DamageTypeEnum.DAMAGE_CURSED_WEAPON_EXPIRED  : 
		case DamageTypeEnum.DAMAGE_EVENT  : 
		case DamageTypeEnum.DAMAGE_END  :		
		default: 
			return 13005 ;
			break;
	}
	return 13005 ;
}

function handleDieInfoDamage ( string param , optional bool isLast ) 
{	
	local RichListCtrlRowData RowData;
	local DieInfoDamageData data ;
	local SkillInfo skillInfo;	
	local string skillIconName;	
	local string skillName;
	local string damage;	

	RowData.cellDataList.Length = 3;
	
	data = GetDieInfoDamage ( param ) ;
	
	

	if (GetSkillInfo( data.SkillClassID, 1, 0, skillInfo )) 
	{	
		// ���� ��ų ��κ� �ӽ� ��ų �������� �� �ִ� ���� ���� 
		if ( data.AttackerType == ATTACKER_NPC )
			skillIconName = "L2UI_CT1.Icon.restart_MonsterDeath_ICON";
		else 
			skillIconName = skillInfo.TexName;
		skillName = skillInfo.SkillName;
	}
	else 
	{
		skillIconName = GetSkillIconNameByDamageType ( data.DamageType );
		skillName = GetSystemString ( GetSkillStringByDamageType ( data.DamageType ) );
	}

	// Debug ("handleDieInfoDamage" @ skillIconName @ skillName );

	// ��ų ������
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36,36, 0, 0);	
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, skillIconName, 32,32, -34, 2 );	

	addRichListCtrlString( RowData.cellDataList[0].drawitems, skillName, util.BrightWhite ,false,5,8);	

	// ������
	damage = MakeCostString ( String ( data.Damage) );

	// ������ �������� 255, 153, 153, ���� �������� �⺻ ���
	if ( isLast ) 
		addRichListCtrlString( RowData.cellDataList[1].drawitems, damage, GetColor( 255, 153, 153, 255 )  ,false,0,0);
	else 
		addRichListCtrlString( RowData.cellDataList[1].drawitems, damage, util.BrightWhite  ,false,0,0);

	switch ( data.AttackerType ) 
	{
		case ATTACKER_NONE : 
			addRichListCtrlString( RowData.cellDataList[1].drawitems, data.AttackerName, util.White ,true ,0,0);
			break;
		// pc �� ���� ������ ǥ�� �Ѵ�.
		case ATTACKER_PC : 			

			addRichListCtrlString( RowData.cellDataList[1].drawitems, data.AttackerName, GetColor (238, 170, 34, 255  ) ,true ,0,5);

			if ( data.PledgeName != "" ) 
				addRichListCtrlString( RowData.cellDataList[1].drawitems, "("$data.PledgeName$")" , GetColor( 180, 180, 180, 255 ) ,false, 3, 0) ;
			else  
				addRichListCtrlString( RowData.cellDataList[1].drawitems, "("$GetSystemString( 431 )$")" , GetColor( 180, 180, 180, 255 ) ,false, 3, 0) ;

			addRichListCtrlTexture(RowData.cellDataList[2].drawitems, "L2UI_CT1.Icon.Restart_PCDamageICON", 16,16, 0, 0);

			break;
		case ATTACKER_NPC : 
			addRichListCtrlString( RowData.cellDataList[1].drawitems, data.AttackerName, util.White ,true ,0,0);
			break;
		default :	
			addRichListCtrlString( RowData.cellDataList[1].drawitems, data.AttackerName, util.White ,true ,0,0);
			break;
	}
	
	// Debug ("handleDieInfoDamage end" @ data.PledgeName @ damage );
	
	// ������ ���ڵ� ó�� 
	if ( isLast ) 
	{
		addRichListCtrlTexture(RowData.cellDataList[2].drawitems, "L2UI_CT1.Icon.Restart_DeathDamageICON", 16,16, 0, 0);
		ItemListCtrl.ModifyRecord ( itemListCtrl.getRecordCount() - 1 ,  RowData ) ;
		lastParam = "";
	}
	else 
	{
		ItemListCtrl.InsertRecord(RowData);
		lastParam = param;
	}

	
}

function handleDieInfoEnd (  ) 
{
	handleDieInfoDamage( lastParam, true) ;
	
	// Debug ( "handleDieInfoEnd" @ ItemListCtrl.GetRecordCount() - 1 );
	ItemListCtrl.SetSelectedIndex (ItemListCtrl.GetRecordCount() - 1 , true ) ;
	ItemListCtrl.InitListCtrl ();
	//ItemListCtrl.SetScrollPosition( ItemListCtrl.GetRecordCount() - 1) ;
}


function Initialize()
{
	Me           = GetWindowHandle( m_WindowName );
	ItemListCtrl = GetRichListCtrlHandle( m_WindowName$".RestartmenuWndReport_ListCtrl" );
	closeBtn     = GetButtonHandle( m_WindowName$".CloseBtn" );

	util                = L2Util(GetScript("L2Util"));
//	inventoryWndScript  = inventoryWnd(GetScript("inventoryWnd"));
//	QuitReportWndScript = QuitReportWnd(GetScript("QuitReportWnd"));

	ItemListCtrl.SetSelectedSelTooltip(FALSE);	
	ItemListCtrl.SetAppearTooltipAtMouseX(true);
}


/** Į�� �� �����Ѵ�. */
function Color GetColor (int r, int g, int b, int a  )
{
	local Color tColor;
	tColor.R = r;
	tColor.G = g;
	tColor.B = b;	
	tColor.A = a;	

	return tColor;
}

function DieInfoDamageData GetDieInfoDamage ( string param ) 
{
	local DieInfoDamageData data ;
	local int tmpInt;

	parseint (param , "AttackerType", tmpInt ) ;
	data.AttackerType = AttackerTypeEnum(tmpInt);
	parseString (param , "AttackerName", data.AttackerName ) ;
	parseString (param , "PledgeName", data.PledgeName ) ;
	parseint (param , "SkillClassID", data.SkillClassID ) ;
	parseint64 (param , "Damage",  data.Damage ) ;
	parseint (param , "DamageType",  tmpInt ) ;
	data.DamageType = DamageTypeEnum ( tmpInt );

	return data;
}


/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();
}

defaultproperties
{
     m_WindowName="RestartMenuWndReportDamage"
}
