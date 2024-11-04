class HennaInfoWndLive extends UICommonAPI;

// ���� ���� �������� ����
const HENNA_EQUIP=1;		// ��������
const HENNA_UNEQUIP=2;		// ���������

var int m_iState;
var int m_iHennaID;

var int64 needCount;
var bool bEnoughItemnum;
var string m_WindowName;

var WindowHandle HennaInfoWndEquip;
var WindowHandle HennaInfoWndUnEquip;

var TextBoxHandle HennaJobText;
var ItemWindowHandle HennaSlot1;
var ItemWindowHandle HennaSlot2;
var ItemWindowHandle HennaSlot3;

var ItemWindowHandle HennaSkillSlot1;
var ItemWindowHandle HennaSkillSlot2;
var ItemWindowHandle HennaSkillSlot3;

var TextureHandle   HennaArrow1;
var TextureHandle   HennaArrow2;
var TextureHandle   HennaArrow3;

var TextureHandle   HennaSkillSelelct1;
var TextureHandle   HennaSkillSelelct2;
var TextureHandle   HennaSkillSelelct3;

var array<TextureHandle> EffectSkillSlotDisables;

var int nSubClass;
var UIControlNeedItem needItemScript;

event OnRegisterEvent()
{
	RegisterEvent( EV_HennaInfoWndShowHideEquip);
	RegisterEvent( EV_HennaInfoWndShowHideUnEquip);
	RegisterEvent( EV_NeedResetUIData);
	RegisterEvent( EV_UpdateUserInfo );
}

event OnLoad()
{
	SetClosingOnESC();

	OnRegisterEvent();

	GetTextBoxHandle( m_WindowName$".HennaInfoWndUnEquip.txtSTRString").SetTooltipCustomType( MakeTooltipSimpleText( GetSystemString(3366), 154 ) );
	GetTextBoxHandle( m_WindowName$".HennaInfoWndUnEquip.txtDEXString").SetTooltipCustomType( MakeTooltipSimpleText( GetSystemString(3368), 154 ) );
	GetTextBoxHandle( m_WindowName$".HennaInfoWndUnEquip.txtCONString").SetTooltipCustomType( MakeTooltipSimpleText( GetSystemString(3370), 154 ) );
	GetTextBoxHandle( m_WindowName$".HennaInfoWndUnEquip.txtINTString").SetTooltipCustomType( MakeTooltipSimpleText( GetSystemString(3367), 154 ) );

	GetTextBoxHandle( m_WindowName$".HennaInfoWndUnEquip.txtWITString").SetTooltipCustomType( MakeTooltipSimpleText( GetSystemString(3369), 154 ) );
	GetTextBoxHandle( m_WindowName$".HennaInfoWndUnEquip.txtMENString").SetTooltipCustomType( MakeTooltipSimpleText( GetSystemString(3371), 154 ) );
	GetTextBoxHandle( m_WindowName$".HennaInfoWndUnEquip.txtLUCString").SetTooltipCustomType( MakeTooltipSimpleText( GetSystemString(3372), 154 ) );
	GetTextBoxHandle( m_WindowName$".HennaInfoWndUnEquip.txtCHAString").SetTooltipCustomType( MakeTooltipSimpleText( GetSystemString(3373), 154 ) );

	HennaInfoWndEquip = GetWindowHandle ( m_WindowName$".HennaInfoWndEquip" );
	HennaInfoWndUnEquip = GetWindowHandle ( m_WindowName$".HennaInfoWndUnEquip" );

	EffectSkillSlotDisables.Length = 3; 
	EffectSkillSlotDisables[0] = GetTextureHandle ( m_WindowName $ ".HennaInfoWndEquip.DefendSkillSlotDisable" ) ;
	EffectSkillSlotDisables[1] = GetTextureHandle ( m_WindowName $ ".HennaInfoWndEquip.MagicDefendSkillSlotDisable" ) ;
	EffectSkillSlotDisables[2] = GetTextureHandle ( m_WindowName $ ".HennaInfoWndEquip.AttackSkillSlotDisable" ) ;

	EffectSkillSlotDisables[0].SetTooltipCustomType(  MakeTooltipSimpleText( GetSystemMessage ( 5278 )) );
	EffectSkillSlotDisables[1].SetTooltipCustomType(  MakeTooltipSimpleText( GetSystemMessage ( 5278 )) );
	EffectSkillSlotDisables[2].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(5278)));
	InitNeetItemScript();
}

event OnClickButton( string strID )
{
	class'UIAPI_WINDOW'.static.HideWindow( m_WindowName );

	switch( strID )
	{
		case "btnPrev" :
			if(m_iState==HENNA_EQUIP)
				RequestHennaItemList();
			else if(m_iState==HENNA_UNEQUIP)
				RequestHennaUnEquipList();

			GetWindowHandle( m_WindowName ).SetAnchor( "HennaListWndLive" , "TopLeft", "TopLeft", 0, 0);
			break;
		case "btnOK" :
			if(m_iState==HENNA_EQUIP)
			{
				// Debug ( "����� " @ m_iHennaID ) ;
				RequestHennaEquip(m_iHennaID);
			}
			else if(m_iState==HENNA_UNEQUIP)
			{
				RequestHennaUnEquip(m_iHennaID);
			}
		break;
	}
}

event OnShow()
{
	// ���¿� ���� ������ �����ְ� �����ݴϴ�
	if(m_iState==HENNA_EQUIP)
	{
		SetFormEquip ();		
	}
	else if(m_iState==HENNA_UNEQUIP)
	{
		SetFormUnEQUIP();
	}
	else
	{
		//debug("�������� �̻��̻�~~");
	}	
}

event OnEvent(int Event_ID, string param)
{
	if ( !getInstanceUIData().getIsClassicServer() ) return;

	switch(Event_ID)
	{
	case EV_HennaInfoWndShowHideEquip :
		m_iState=HENNA_EQUIP;		// ���¸� "��������"�� �ٲߴϴ�.
		ShowHennaInfoWnd(param);
		break;
	case EV_HennaInfoWndShowHideUnEquip :
		m_iState=HENNA_UNEQUIP;		// ���¸� "���������"�� �ٲߴϴ�.
		ShowHennaInfoWnd(param);
		break;
	case EV_NeedResetUIData :       // ���¸� LUC, CHA�� ���� Ư���� ���� ���̰ų� ������ �ʰ� �մϴ�.
		
		if ( !getInstanceUIData().getIsClassicServer() ) 
		{
			class'UIAPI_WINDOW'.static.HideWindow( m_WindowName$".txtLUCString");
			class'UIAPI_WINDOW'.static.HideWindow( m_WindowName$".txtLUCBefore");
			class'UIAPI_WINDOW'.static.HideWindow( m_WindowName$".txtLUCArrow");
			class'UIAPI_WINDOW'.static.HideWindow( m_WindowName$".txtLUCAfter");
			class'UIAPI_WINDOW'.static.HideWindow( m_WindowName$".txtCHAString");
			class'UIAPI_WINDOW'.static.HideWindow( m_WindowName$".txtCHABefore");
			class'UIAPI_WINDOW'.static.HideWindow( m_WindowName$".txtCHAArrow");
			class'UIAPI_WINDOW'.static.HideWindow( m_WindowName$".txtCHAAfter");		
		}
		else 
		{
			class'UIAPI_WINDOW'.static.ShowWindow( m_WindowName$".txtLUCString");
			class'UIAPI_WINDOW'.static.ShowWindow( m_WindowName$".txtLUCBefore");
			class'UIAPI_WINDOW'.static.ShowWindow( m_WindowName$".txtLUCArrow");
			class'UIAPI_WINDOW'.static.ShowWindow( m_WindowName$".txtLUCAfter");
			class'UIAPI_WINDOW'.static.ShowWindow( m_WindowName$".txtCHAString");
			class'UIAPI_WINDOW'.static.ShowWindow( m_WindowName$".txtCHABefore");
			class'UIAPI_WINDOW'.static.ShowWindow( m_WindowName$".txtCHAArrow");
			class'UIAPI_WINDOW'.static.ShowWindow( m_WindowName$".txtCHAAfter");		
		}
		break;
		case EV_UpdateUserInfo : 
			SetSkills();
		break;
	}
}

function SetSkills ()
{
	local userInfo info;

	if ( !IsShowWindow ( m_WindowName )  ) return;

	GetPlayerInfo( info ) ;

	// Ŭ���� ���� �ÿ��� ���� �Ѵ�. 
	if ( nSubClass == info.nSubClass ) return;
	else 
	{
		nSubClass = info.nSubClass;
	}
		
	UpdateHennaInfo ();
}

function SetFormEquip()
{
	local userInfo info;
	// Ÿ��Ʋ - ��������
	setWindowTitleByString(GetSystemString(651));
	HennaInfoWndEquip.ShowWindow() ;
	HennaInfoWndUnEquip.HideWindow() ;
	GetPlayerInfo( info ) ;
	GetTextBoxHandle (  m_WindowName$".HennaInfoWndEquip.HennaJobText" ).SetText ( GetClassType(info.nSubClass) ) ;

	UpdateHennaInfo();
}

function SetFormUnEQUIP()
{
	// Ÿ��Ʋ - ���������
	setWindowTitleByString(GetSystemString(652));
	UpdateRemoveSkillInfo();
	HennaInfoWndEquip.HideWindow() ;
	HennaInfoWndUnEquip.ShowWindow() ;
}

function ShowHennaInfoWnd(string param)
{
	local string orignalString;
	local int textWidth, textHeight;

	local INT64 iAdena;
	local string strDyeName;			// ����
	local string strDyeIconName;
	local int iHennaID;
	local int iClassID;
	local INT64 iNum;
	local INT64 iFee;

	local string strTattooName;			// ����
	local string strTattooAddName;		// ����
	local string strTattooIconName;

	local int iINTnow;
	local int iINTchange;
	local int iSTRnow;
	local int iSTRchange;
	local int iCONnow;
	local int iCONchange;
	local int iMENnow;
	local int iMENchange;
	local int iDEXnow;
	local int iDEXchange;
	local int iWITnow;
	local int iWITchange;

	//�űԽ��� ��Ű, ī������
	local int iLUCnow;
	local int iLUCchange;
	local int iCHAnow;
	local int iCHAchange;

	// Debug ( "ShowHennaInfoWnd" @ param ) ;

	ParseINT64(param,   "Adena", iAdena);						// �Ƶ���
	ParseString(param,  "DyeIconName", strDyeIconName);		// ���� Icon �̸�
	ParseString(param,  "DyeName", strDyeName);				// �����̸�
	ParseInt(param,     "HennaID", iHennaID);				 
	ParseInt(param,     "ClassID", iClassID);
	ParseINT64(param,   "NumOfItem", iNum);
	ParseINT64(param,   "Fee", iFee);

	ParseString(param, "TattooIconName", strTattooIconName);	// ����������̸�
	ParseString(param, "TattooName", strTattooName);		// �����̸�
	ParseString(param, "TattooAddName", strTattooAddName);	// �������� - ��ġ�����ؽ�Ʈ 

	ParseInt(param, "INTnow", iINTnow);
	ParseInt(param, "INTchange", iINTchange);
	ParseInt(param, "STRnow", iSTRnow);
	ParseInt(param, "STRchange", iSTRchange);
	ParseInt(param, "CONnow", iCONnow);
	ParseInt(param, "CONchange", iCONchange);
	ParseInt(param, "MENnow", iMENnow);
	ParseInt(param, "MENchange", iMENchange);
	ParseInt(param, "DEXnow", iDEXnow);
	ParseInt(param, "DEXchange", iDEXchange);
	ParseInt(param, "WITnow", iWITnow);
	ParseInt(param, "WITchange", iWITchange);
	
	//�űԽ��� ��Ű, ī������
	ParseInt(param, "LUCnow", iLUCnow);
	ParseInt(param, "LUCchange", iLUCchange);
	ParseInt(param, "CHAnow", iCHAnow);
	ParseInt(param, "CHAchange", iCHAchange);


	m_iHennaID=iHennaID;		// ������ ����ų� �����Ҷ� �ʿ��ϹǷ� ID�� �����صӴϴ�

	if(m_iState==HENNA_EQUIP)
	{
		// ����
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".txtDyeInfo", GetSystemString(638)); // "��������"
		class'UIAPI_TEXTURECTRL'.static.SetTexture(m_WindowName$".textureDyeIconName", strDyeIconName);	// ���� Icon
		orignalString = strDyeName;
		// End:0x37B
		if(class'L2Util'.static.GetEllipsisString(strDyeName, 315))
		{
			GetTextBoxHandle(m_WindowName $ ".HennaInfoWndEquip.txtDyeName").SetTooltipString(orignalString);			
		}
		else
		{
			GetTextBoxHandle(m_WindowName $ ".HennaInfoWndEquip.txtDyeName").SetTooltipString("");
		}
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".HennaInfoWndEquip.txtDyeName", strDyeName);
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".txtNeedItemString", GetSystemString(2380) $ " : ");
		bEnoughItemnum = iNum >= needCount;
		// End:0x481
		if(! bEnoughItemnum)
		{
			class'UIAPI_TEXTBOX'.static.SetTextColor(m_WindowName $ ".txtCurrentItemNum", GetColor(255, 0, 0, 255));			
		}
		else
		{
			class'UIAPI_TEXTBOX'.static.SetTextColor(m_WindowName $ ".txtCurrentItemNum", GetColor(0, 176, 255, 255));
		}
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".txtCurrentItemNum", string(iNum));
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".txtNeedItemNum", "/" $ string(needCount));
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".txtTattooInfo", GetSystemString(639));
		class'UIAPI_TEXTURECTRL'.static.SetTexture(m_WindowName $ ".textureTattooIconName", strTattooIconName);
		orignalString = strTattooName;
		// End:0x5E8
		if(class'L2Util'.static.GetEllipsisString(strTattooName, 315))
		{
			GetTextBoxHandle(m_WindowName $ ".HennaInfoWndEquip.txtTattooName").SetTooltipString(orignalString);			
		}
		else
		{
			GetTextBoxHandle(m_WindowName $ ".HennaInfoWndEquip.txtTattooName").SetTooltipString("");
		}
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".txtTattooName", strTattooName);
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".txtTattooAddName", strTattooAddName);	
	}
	else if(m_iState==HENNA_UNEQUIP)
	{
		// ����
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".txtTattooInfoUnEquip", GetSystemString(639));
		class'UIAPI_TEXTURECTRL'.static.SetTexture(m_WindowName $ ".textureTattooIconNameUnEquip", strTattooIconName);
		orignalString = GetSystemString(652) $ ":" $ strTattooName;
		// End:0x780
		if(class'L2Util'.static.GetEllipsisString(orignalString, 315))
		{
				GetTextBoxHandle(m_WindowName $ ".HennaInfoWndUnEquip.txtTattooNameUnEquip").SetTooltipString(strTattooName);				
		}
		else
		{
				GetTextBoxHandle(m_WindowName $ ".HennaInfoWndUnEquip.txtTattooNameUnEquip").SetTooltipString("");
		}
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".HennaInfoWndUnEquip.txtTattooNameUnEquip", orignalString);
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".txtTattooAddNameUnEquip", strTattooAddName);
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".txtDyeInfoUnEquip", GetSystemString(638));
		class'UIAPI_TEXTURECTRL'.static.SetTexture(m_WindowName $ ".textureDyeIconNameUnEquip", strDyeIconName);
		orignalString = strDyeName;
		GetTextSizeDefault("x" $ string(iNum), textWidth, textHeight);
		// End:0x93C
		if(class'L2Util'.static.GetEllipsisString(strDyeName, 315 - textWidth))
		{
			GetTextBoxHandle(m_WindowName $ ".HennaInfoWndUnEquip.txtDyeNameUnEquip").SetTooltipString(orignalString);				
		}
		else
		{
			GetTextBoxHandle(m_WindowName $ ".HennaInfoWndUnEquip.txtDyeNameUnEquip").SetTooltipString("");
		}
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".HennaInfoWndUnEquip.txtDyeNameUnEquip", strDyeName $ "x" $ string(iNum));
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".txtNeedItemString", "");
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".txtCurrentItemNum", "");
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".txtNeedItemNum", "");
	}


	// ��ġ��ȭ
	updateNeedItem(iFee);
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtSTRBefore", iSTRnow); // STR ����
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtSTRAfter", iSTRchange); // STR ��ȭ��
	ColorOnChange(iSTRnow, iSTRchange, "txtSTRAfter");
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtDEXBefore", iDEXnow); // DEX ����
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtDEXAfter", iDEXchange); // DEX ��ȭ��
	ColorOnChange(iDEXnow, iDEXchange, "txtDEXAfter");
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtCONBefore", iCONnow); // CON ����
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtCONAfter", iCONchange); // CON ��ȭ��
	ColorOnChange(iCONnow, iCONchange, "txtCONAfter");
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtINTBefore", iINTnow); // INT ����
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtINTAfter", iINTchange); // INT ��ȭ��
	ColorOnChange(iINTnow, iINTchange, "txtINTAfter");
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtWITBefore", iWITnow); // WIT ����
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtWITAfter", iWITchange); // WIT ��ȭ��
	ColorOnChange(iWITnow, iWITchange, "txtWITAfter");
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtMENBefore", iMENnow); // MEN ����
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtMENAfter", iMENchange); // MEN ��ȭ��
	ColorOnChange(iMENnow, iMENchange, "txtMENAfter");
	//�űԽ��� ��Ű, ī������
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtLUCBefore", iLUCnow); // LUC ����
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtLUCAfter", iLUCchange); // LUC ��ȭ��
	ColorOnChange(iLUCnow, iLUCchange, "txtLUCAfter");
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtCHABefore", iCHAnow); // CHA ����
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".txtCHAAfter", iCHAchange); // CHA ��ȭ��
	ColorOnChange(iCHAnow, iCHAchange, "txtCHAAfter");
	//�Ƶ���(,)
	class'UIAPI_WINDOW'.static.HideWindow("HennaListWndLive");
	class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName);
	class'UIAPI_WINDOW'.static.SetFocus(m_WindowName);
	GetWindowHandle("HennaListWndLive").SetAnchor(m_WindowName, "TopLeft", "TopLeft", 0, 0);
}

private function ColorOnChange(int before, int after, string textname)
{
	// End:0x41
	if(before != after)
	{
		class'UIAPI_TEXTBOX'.static.SetTextColor(m_WindowName $ "." $ textname, getInstanceL2Util().Yellow);		
	}
	else
	{
		class'UIAPI_TEXTBOX'.static.SetTextColor(m_WindowName $ "." $ textname, GetColor(176, 155, 121, 255));
	}	
}

private function updateNeedItem(INT64 needNum)
{
	needItemScript.SetNumNeed(needNum);
	DelegateNeedItemOnUpdateItem(needItemScript);	
}

private function InitNeetItemScript()
{
	local WindowHandle needItemWnd;

	needItemWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem");
	needItemWnd.SetScript("UIControlNeedItem");
	needItemScript = UIControlNeedItem(needItemWnd.GetScript());
	needItemScript.Init(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem");
	needItemScript.setId(GetItemID(57));
	needItemScript.DelegateItemUpdate = DelegateNeedItemOnUpdateItem;	
}

private function DelegateNeedItemOnUpdateItem(UIControlNeedItem script)
{
	// End:0x56
	if(script.canBuy() && bEnoughItemnum || m_iState == 2)
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnOK").EnableWindow();		
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnOK").DisableWindow();
	}	
}

function UpdateRemoveSkillInfo () 
{
	local ItemInfo DyeEffectSkillItemInfo ;
	local Skillinfo DyeEffectSkillInfo ;
	local int HennaInfoCount ;
	local UserInfo PlayerInfo;

	if( GetPlayerInfo( PlayerInfo ) )
	{
		HennaInfoCount = class'HennaAPI'.static.GetHennaInfoCount();

// 		Debug ( "UpdateRemoveSkillInfo" @  HennaInfoCount ) ;
		class'UIDATA_HENNA'.static.GetDyeEffectSkillInfo(PlayerInfo.nSubClass, HennaInfoCount , DyeEffectSkillInfo ) ;

		DyeEffectSkillItemInfo.ID.classID = DyeEffectSkillInfo.SkillID;
		DyeEffectSkillItemInfo.Name = DyeEffectSkillInfo.SkillName;
		DyeEffectSkillItemInfo.Level = DyeEffectSkillInfo.SkillLevel ;
		DyeEffectSkillItemInfo.SubLevel = DyeEffectSkillInfo.SkillSubLevel;
		DyeEffectSkillItemInfo.IconName = DyeEffectSkillInfo.TexName;
		DyeEffectSkillItemInfo.IconPanel = DyeEffectSkillInfo.IconPanel;
		DyeEffectSkillItemInfo.Description = DyeEffectSkillInfo.SkillDesc;
		DyeEffectSkillItemInfo.AdditionalName = DyeEffectSkillInfo.EnchantName;	

		GetItemWindowHandle ( m_WindowName $".HennaInfoWndUnEquip.HennaDeleteSlot").Clear();
		GetItemWindowHandle ( m_WindowName $".HennaInfoWndUnEquip.HennaDeleteSlot").AddItem( DyeEffectSkillItemInfo ) ;
	}
}

// ���� ���� ���� �� ��ų ���� ǥ�� 
function UpdateHennaInfo()
{
	local int i;
	local int HennaInfoCount;
	local int HennaID;
	local int IsActive;
	local ItemInfo HennaItemInfo, DyeEffectSkillItemInfo ;
	local Skillinfo DyeEffectSkillInfo;
	local UserInfo PlayerInfo;
	local int ClassStep;
	local bool hennacheck; //branch121212	

	

	if( GetPlayerInfo( PlayerInfo ) )
	{
		ClassStep = GetClassStep( PlayerInfo.nSubClass );
		//debug("ClassStep: " @ ClassStep);
		switch( ClassStep )
		{
			case 1:
			case 2:
			case 3:
			case 4:
			case 5:
				    ///m_hHennaItemWindow.SetRow( ClassStep );
				    break;

			default:
				    // m_hHennaItemWindow.SetRow( 0 );
				    break;
		}
	}

	// m_hHennaItemWindow.Clear();

	HennaInfoCount = class'HennaAPI'.static.GetHennaInfoCount();
	
	if( HennaInfoCount > ClassStep )
		HennaInfoCount = ClassStep;

	for ( i = 1 ; i <= 3 ; i ++ ) 
	{
		GetTextureHandle ( m_WindowName $".HennaSkillSelelct" $  i ).HideWindow(); 		
		GetItemWindowHandle ( m_WindowName $ ".HennaInfoWndEquip.HennaSkillSlot" $ i ).Clear();
		GetItemWindowHandle ( m_WindowName $ ".HennaInfoWndEquip.HennaSlot" $ i ).Clear();
		EffectSkillSlotDisables[i-1].ShowWindow();
			// m_hHennaItemWindow.AddItem( HennaItemInfo );			
	}
		

	// Debug ( "UpdateHennaInfo" @  HennaInfoCount ) ;


	for( i = 1; i <= HennaInfoCount ; ++i )
	{
		if( class'HennaAPI'.static.GetHennaInfo( i -1 , HennaID, IsActive ) )
		{	
			class'UIDATA_HENNA'.static.GetDyeEffectSkillInfo(PlayerInfo.nSubClass, i , DyeEffectSkillInfo ) ;

			DyeEffectSkillItemInfo.ID.classID = DyeEffectSkillInfo.SkillID;
			DyeEffectSkillItemInfo.Name = DyeEffectSkillInfo.SkillName;
			DyeEffectSkillItemInfo.Level = DyeEffectSkillInfo.SkillLevel ;
			DyeEffectSkillItemInfo.SubLevel = DyeEffectSkillInfo.SkillSubLevel;
			DyeEffectSkillItemInfo.IconName = DyeEffectSkillInfo.TexName;
			DyeEffectSkillItemInfo.IconPanel = DyeEffectSkillInfo.IconPanel;
			DyeEffectSkillItemInfo.Description = DyeEffectSkillInfo.SkillDesc;
			DyeEffectSkillItemInfo.AdditionalName = DyeEffectSkillInfo.EnchantName;	

			GetItemWindowHandle ( m_WindowName $ ".HennaInfoWndEquip.HennaSkillSlot" $ i ).AddItem( DyeEffectSkillItemInfo ) ;

			hennacheck = class'UIDATA_HENNA'.static.GetItemCheck(HennaID);

			if( hennacheck )
			{
				HennaItemInfo.Name = class'UIDATA_HENNA'.static.GetItemNameS( HennaID );
				HennaItemInfo.Description = class'UIDATA_HENNA'.static.GetDescriptionS( HennaID );
				HennaItemInfo.IconName = class'UIDATA_HENNA'.static.GetIconTexS( HennaID );
			}

			if( 0 == IsActive )
				HennaItemInfo.bDisabled = 1;
			else
				HennaItemInfo.bDisabled = 0;


			if ( DyeEffectSkillInfo.SkillName != "" && HennaItemInfo.bDisabled == 0) 
				EffectSkillSlotDisables[i-1].HideWindow();

			GetItemWindowHandle (  m_WindowName $ ".HennaInfoWndEquip.HennaSlot" $ i  ).AddItem( HennaItemInfo ) ;
		}
	}

	if ( HennaInfoCount < 3 ) 
	{	
		class'UIDATA_HENNA'.static.GetDyeEffectSkillInfo(PlayerInfo.nSubClass, i  , DyeEffectSkillInfo ) ;

		DyeEffectSkillItemInfo.ID.classID = DyeEffectSkillInfo.SkillID;
		DyeEffectSkillItemInfo.Name = DyeEffectSkillInfo.SkillName;
		DyeEffectSkillItemInfo.Level = DyeEffectSkillInfo.SkillLevel ;
		DyeEffectSkillItemInfo.SubLevel = DyeEffectSkillInfo.SkillSubLevel;
		DyeEffectSkillItemInfo.IconName = DyeEffectSkillInfo.TexName;
		DyeEffectSkillItemInfo.IconPanel = DyeEffectSkillInfo.IconPanel;
		DyeEffectSkillItemInfo.Description = DyeEffectSkillInfo.SkillDesc;
		DyeEffectSkillItemInfo.AdditionalName = DyeEffectSkillInfo.EnchantName;	

		GetItemWindowHandle ( m_WindowName $ ".HennaInfoWndEquip.HennaSkillSlot" $ i ).AddItem( DyeEffectSkillItemInfo ) ;

		HennaItemInfo.Name = class'UIDATA_HENNA'.static.GetItemNameS( m_iHennaID );
		HennaItemInfo.Description = class'UIDATA_HENNA'.static.GetDescriptionS( m_iHennaID );
		HennaItemInfo.IconName = class'UIDATA_HENNA'.static.GetIconTexS( m_iHennaID );
		HennaItemInfo.bDisabled = 0;

		GetItemWindowHandle (  m_WindowName $ ".HennaInfoWndEquip.HennaSlot" $ i  ).AddItem( HennaItemInfo ) ;

		GetTextureHandle ( m_WindowName $".HennaSkillSelelct" $ i ).ShowWindow();
		
		if ( DyeEffectSkillInfo.SkillName != "" ) 
			EffectSkillSlotDisables[i-1].HideWindow();
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
     m_WindowName="HennaInfoWndLive"
}
