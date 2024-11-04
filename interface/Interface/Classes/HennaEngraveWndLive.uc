class HennaEngraveWndLive extends UICommonAPI;

const FEEITEMID = 80762;
var string m_WindowName;

var ItemWindowHandle EngraveEffectItemSlot ; 

var array<TextureHandle> EffectIconDisables ;

var array<TextureHandle> EffectSkillDisables ;
//var TextureHandle DefendIcon;
//var TextureHandle MagicDefendIcon;
//var TextureHandle AttackIcon;

var StatusBarHandle EngraveEffectUnableStatus;
var StatusBarHandle EngraveEffectStatus;

var TextBoxHandle NumberText;

var array<ItemWindowHandle> itemIcons;

var array<TextureHandle> EffectSkillSlotDisables;
//var ItemWindowHandle DefendSkill;
//var ItemWindowHandle MagicDefendSkill;
//var ItemWindowHandle AttackSkill;

var itemInfo feeItem ;

var int nSubClass;

function OnRegisterEvent()
{
	RegisterEvent( EV_UpdateUserInfo );
	RegisterEvent( EV_InventoryUpdateItem );
	RegisterEvent( EV_InventoryAddItem );
	RegisterEvent( EV_UpdateHennaInfo );
	RegisterEvent( EV_Restart );
	RegisterEvent( EV_GamingStateEnter );
	
}

function OnClickItem( string strID, int index )
{
	//local ItemID  id ;
	//local itemInfo InvenItemInfo;
	
	// id.classID = FEEITEMID ;

	// InventoryWnd ( GetScript ( "InventoryWnd" )).getInventoryItemInfo(id, InvenItemInfo, true) ;	

	// Debug ( "OnClickItem" @ strID @ index @ feeItem.ID.classID @ feeItem.ID.ServerID ) ;
	switch ( strID ) 
	{
		case "EngraveEffectItemSlot" : 
			RequestUseItem( feeItem.ID ) ;
		break;
	}
	
	// UseItem( EngraveEffectItemSlot, index );
}

function OnLoad()
{
	SetClosingOnESC();

	OnRegisterEvent();

	EngraveEffectItemSlot = GetItemWindowHandle ( m_WindowName $ ".EngraveEffectItemSlot" ) ;

	EffectIconDisables.Length = 3;                              
	EffectIconDisables[0] = GetTextureHandle ( m_WindowName $ ".DefendIconDisable" ) ;
	EffectIconDisables[1] = GetTextureHandle ( m_WindowName $ ".MagicDefendIconDisable" )  ;
	EffectIconDisables[2] = GetTextureHandle ( m_WindowName $ ".AttackIconDisable" ) ;

	GetTextureHandle ( m_WindowName $ ".DefendIcon" ).SetTooltipCustomType( MakeTooltipSimpleText(GetSystemString(3989)) );
	GetTextureHandle ( m_WindowName $ ".MagicDefendIcon" ).SetTooltipCustomType( MakeTooltipSimpleText(GetSystemString(3990)) );
	GetTextureHandle ( m_WindowName $ ".AttackIcon" ).SetTooltipCustomType( MakeTooltipSimpleText(GetSystemString(3991)) );

	//DefendIcon = GetTextureHandle ( m_WindowName $ ".DefendIcon" ) ;
	//MagicDefendIcon = GetTextureHandle ( m_WindowName $ ".MagicDefendIcon" ) ;
	//AttackIcon = GetTextureHandle ( m_WindowName $ ".AttackIcon" ) ;

	EngraveEffectUnableStatus = GetStatusBarHandle ( m_WindowName $ ".EngraveEffectUnableStatus" ) ;
	EngraveEffectStatus = GetStatusBarHandle ( m_WindowName $ ".EngraveEffectStatus" ) ;

	NumberText = GetTextBoxHandle ( m_WindowName $ ".NumberText" ) ;

	itemIcons.Length = 3; 
	itemIcons[0] = GetItemWindowHandle ( m_WindowName $ ".DefendSkill" ) ;
	itemIcons[1] = GetItemWindowHandle ( m_WindowName $ ".MagicDefendSkill" ) ;
	itemIcons[2] = GetItemWindowHandle ( m_WindowName $ ".AttackSkill" ) ;

	EffectSkillDisables.Length = 3; 

	EffectSkillDisables[0] = GetTextureHandle ( m_WindowName $ ".DefendSkillDisable" ) ;
	EffectSkillDisables[1] = GetTextureHandle ( m_WindowName $ ".MagicDefendSkillDisable" ) ;
	EffectSkillDisables[2] = GetTextureHandle ( m_WindowName $ ".AttackSkillDisable" ) ;


	EffectSkillSlotDisables.Length = 3; 
	EffectSkillSlotDisables[0] = GetTextureHandle ( m_WindowName $ ".DefendSkillSlotDisable" ) ;//
	EffectSkillSlotDisables[1] = GetTextureHandle ( m_WindowName $ ".MagicDefendSkillSlotDisable" ) ;
	EffectSkillSlotDisables[2] = GetTextureHandle ( m_WindowName $ ".AttackSkillSlotDisable" ) ;

	EffectSkillSlotDisables[0].SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage ( 5278 ) ) );
	EffectSkillSlotDisables[1].SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage ( 5278 ) ) );
	EffectSkillSlotDisables[2].SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage ( 5278 ) ) );
	//DefendSkill = GetItemWindowHandle ( m_WindowName $ ".DefendSkill" ) ;
	//MagicDefendSkill = GetItemWindowHandle ( m_WindowName $ ".MagicDefendSkill" ) ;
	//AttackSkill = GetItemWindowHandle ( m_WindowName $ ".AttackSkill" ) ;
}

function OnShow()
{
	// ���¿� ���� ������ �����ְ� �����ݴϴ�.
	SetUserInfo();
	SetGageByHennCount ();
	SetSkills();
	GetWindowHandle( m_WindowName ).SetFocus();
}

function OnEvent(int Event_ID, string param)
{	
	// Debug  ( "Event_ID" @ Event_ID);
	switch(Event_ID)
	{
		case EV_GamingStateEnter  :
			SetFeeItem();
		break;
		case EV_UpdateUserInfo :
			SetUserInfo () ;
			SetGageByHennCount();
			SetSkills();
		break;
		case EV_InventoryAddItem : 
		case EV_InventoryUpdateItem :
			if ( GetWindowHandle("HennaEngraveWndLive").IsShowWindow() )
				handleinventoryUpdateResult(param);
		break;
		case EV_UpdateHennaInfo :
		case EV_InventoryAddHennaInfo : 
			SetSkills();
		break;
		case EV_Restart : 
			//NumberText.SetText ( "" ) ;
			// feeItem.bDisabled = 1;
			SetFeeItem ();
			// EngraveEffectItemSlot.SetItem ( 0, feeItem ) ;
		break;
	}
}

function handleinventoryUpdateResult( string param ) 
{	
	local itemInfo updatedItemInfo;	
	local string type;

	//ParseItemID(param, itemID);
	ParamToItemInfo( param, updatedItemInfo );
	ParseString( param, "type", type );
//	Debug ( "handleinventoryUpdateResult" @ type @  updatedItemInfo.ID.classID @ FEEITEMID );
	if ( updatedItemInfo.ID.classID == FEEITEMID )
	{
		if ( type == "delete")  updatedItemInfo.itemNum = 0 ;
		feeItem = updatedItemInfo ;
		NumberText.SetText ( MakeCostString ( String ( feeItem.itemNum ))) ;
		
		if ( feeItem.itemNum == 0 ) 
			feeItem.bDisabled = 1;
		else 
			feeItem.bDisabled = updatedItemInfo.bDisabled;

		EngraveEffectItemSlot.SetItem ( 0, feeItem ) ;
	}
}

function SetFeeItem () 
{
	local array<ItemInfo> infos;
	local itemInfo info ;	

	class'UIDATA_INVENTORY'.static.FindItemByClassID ( FEEITEMID , infos ) ;	
	
	// EngraveEffectItemSlot.DisableWindow();
	if ( infos.Length > 0 ) 
	{
		info = infos[0] ;
		feeItem.bDisabled = 0 ;
		NumberText.SetText ( MakeCostString ( String ( info.itemNum ))) ;	
	}
	else 
	{
		info = GetItemInfoByClassID ( FEEITEMID );
		info.bDisabled = 1;
		// ������ disable ó�� �ϰ�... Ŭ�� ���ϰ� ���� 
		NumberText.SetText("0");

	}

//	Debug ( "SetFeeItem" @  info.name ) ;

	EngraveEffectItemSlot.AddItem(info);
}

function SetUserInfo ()
{
	local userInfo info;
	local int maxDyeChargeAmount;

	if ( !IsShowWindow ( m_WindowName ) ) return;

	GetPlayerInfo( info ) ;

	maxDyeChargeAmount = class'UIDATA_HENNA'.static.GetMaxDyeChargeAmount ();
	
	Debug ( "SetUserInfo" @ info.nDyeChargeAmount @ maxDyeChargeAmount );

	EngraveEffectUnableStatus.SetPoint ( info.nDyeChargeAmount, maxDyeChargeAmount ) ;
	EngraveEffectStatus.SetPoint ( info.nDyeChargeAmount, maxDyeChargeAmount ) ;
}

function SetGageByHennCount  ()
{
	local int i, HennaInfoCount ; 

	if ( !IsShowWindow ( m_WindowName )  ) return;

	HennaInfoCount = class'HennaAPI'.static.GetHennaInfoCount();
	
	if ( HennaInfoCount == 0 ) 
		EngraveEffectUnableStatus.ShowWindow();
	else
		EngraveEffectUnableStatus.HideWindow();	

	for ( i = 0 ; i < HennaInfoCount ; i ++ ) 
	{
		EffectSkillDisables[i].HideWindow();
		EffectIconDisables[i].HideWindow();
	}

	for ( i = i ; i < 3 ; i ++ ) 
	{
		EffectSkillDisables[i].ShowWindow();
		EffectIconDisables[i].ShowWindow();
	}
}

function SetSkills ()
{
	local int i ; 
	local userInfo info;
	local ItemInfo DyeEffectSkillItemInfo ;
	local Skillinfo DyeEffectSkillInfo;

	if ( !IsShowWindow ( m_WindowName )  ) return;

	GetPlayerInfo( info ) ;

	// Ŭ���� ���� �ÿ��� ���� �Ѵ�.  �� �ٸ� ����� ���� ����.
	//if ( nSubClass == info.nSubClass ) return;
	//else 
	//{
		nSubClass = info.nSubClass;
	//}

	for ( i = 0 ; i < 3 ; i ++ ) 
	{	
		itemIcons[i].Clear();

		class'UIDATA_HENNA'.static.GetDyeEffectSkillInfo( nSubClass, i + 1 , DyeEffectSkillInfo ) ;

//		Debug ( "SetSkills" @ DyeEffectSkillInfo.SkillName ) ;

		if ( DyeEffectSkillInfo.SkillName == "" ) 
		{
			EffectSkillSlotDisables[i].ShowWindow();
			EffectSkillDisables[i].ShowWindow();
			EffectIconDisables[i].ShowWindow();
		}
		else 
			EffectSkillSlotDisables[i].HideWindow();
		
		
		DyeEffectSkillItemInfo.Id.ClassID = DyeEffectSkillInfo.SkillID;
		DyeEffectSkillItemInfo.Name = DyeEffectSkillInfo.SkillName;
		DyeEffectSkillItemInfo.Level = DyeEffectSkillInfo.SkillLevel;
		DyeEffectSkillItemInfo.SubLevel = DyeEffectSkillInfo.SkillSubLevel;
		DyeEffectSkillItemInfo.IconName = DyeEffectSkillInfo.TexName;
		DyeEffectSkillItemInfo.IconPanel = DyeEffectSkillInfo.IconPanel;
		DyeEffectSkillItemInfo.Description = DyeEffectSkillInfo.SkillDesc;
		DyeEffectSkillItemInfo.AdditionalName = DyeEffectSkillInfo.EnchantName;
		itemIcons[i].AddItem(DyeEffectSkillItemInfo);
	}
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
     m_WindowName="HennaEngraveWndLive"
}
