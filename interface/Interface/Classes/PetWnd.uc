class PetWnd extends UICommonAPI;

const PET_EQUIPPEDTEXTURE_NAME = "l2ui_ch3.PetWnd.petitem_click";

const DIALOG_PETNAME		= 1111;				// ���̸�����
const DIALOG_GIVEITEMTOPET	= 2222;				// �κ����� ���κ����� ������ �ű��

const NPET_SMALLBARSIZE = 85;
const NPET_LARGEBARSIZE = 206;
const NPET_BARHEIGHT = 12;
//~ const PET_EVOLUTIONIZED_ID = 16025;
const PET_EVOLUTIONIZED_ID = 1210114602;

var string      m_WindowName;
var int			m_PetID;
var bool		m_bShowNameBtn;
var string		m_LastInputPetName;
var int 		EvolutionizedAction;

var WindowHandle Me;
var StatusBarHandle texPetHP;
var StatusBarHandle texPetMP;
var StatusBarHandle texPetExp;
var StatusBarHandle texPetFatigue;
var ButtonHandle btnName;
//var TextBoxHandle txtPetHP;
//var TextBoxHandle txtPetMP;
var TextBoxHandle txtPetSP;
//var TextBoxHandle txtPetExp;
//var TextBoxHandle txtFatigue;
var TextBoxHandle txtLvName;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtSoulShotCosume;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtSpiritShotConsume;

var TextBoxHandle txtMagicHit;
var TextBoxHandle txtMagicAvoid;
var TextBoxHandle txtMagicCritical;

var ItemWindowHandle PetActionWnd;
var ItemWindowHandle PetInvenWnd;

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_UpdatePetInfo );
	RegisterEvent( EV_PetWndShow );
	RegisterEvent( EV_PetWndShowNameBtn );
	RegisterEvent( EV_PetWndRegPetNameFailed );
	RegisterEvent( EV_PetStatusClose );
	
	RegisterEvent( EV_ActionListNew );
	RegisterEvent( EV_ActionPetListStart );
	RegisterEvent( EV_ActionPetList );
	
	RegisterEvent( EV_PetInventoryItemStart );
	RegisterEvent( EV_PetInventoryItemList );
	RegisterEvent( EV_PetInventoryItemUpdate );
	
	RegisterEvent( EV_LanguageChanged );
	RegisterEvent( EV_UpdateHP ); //hp ������ ���� ��� 
	RegisterEvent( EV_UpdateMP ); //mp ������ ���� ��� 
}

function OnLoad()
{
	SetClosingOnESC();
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();

	m_bShowNameBtn = true;
	EvolutionizedAction = 0;
}

function InitHandle()
{
	Me = GetHandle( "PetWnd" );
	btnName = ButtonHandle ( GetHandle( "PetWnd.btnName" ) );
	texPetHP = StatusBarHandle ( GetHandle( "PetWnd.texPetHP" ) );
	texPetMP = StatusBarHandle ( GetHandle( "PetWnd.texPetMP" ) );
	texPetExp = StatusBarHandle ( GetHandle( "PetWnd.texPetExp" ) );
	texPetFatigue = StatusBarHandle ( GetHandle( "PetWnd.texPetFatigue" ) );
	//txtPetHP = TextBoxHandle ( GetHandle( "PetWnd.txtPetHP" ) );
	//txtPetMP = TextBoxHandle ( GetHandle( "PetWnd.txtPetMP" ) );
	txtPetSP = TextBoxHandle ( GetHandle( "PetWnd.txtPetSP" ) );
	//txtPetExp = TextBoxHandle ( GetHandle( "PetWnd.txtPetExp" ) );
	//txtFatigue = TextBoxHandle ( GetHandle( "PetWnd.txtFatigue" ) );
	txtLvName = TextBoxHandle ( GetHandle( "PetWnd.txtLvName" ) );
	txtPhysicalAttack = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtPhysicalAttack" ) );
	txtPhysicalDefense = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtPhysicalDefense" ) );
	txtHitRate = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtHitRate" ) );
	txtCriticalRate = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtCriticalRate" ) );
	txtPhysicalAttackSpeed = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtPhysicalAttackSpeed" ) );
	txtSoulShotCosume = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtSoulShotCosume" ) );
	txtMagicalAttack = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtMagicalAttack" ) );
	txtMagicDefense = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtMagicDefense" ) );
	txtPhysicalAvoid = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtPhysicalAvoid" ) );
	txtMovingSpeed = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtMovingSpeed" ) );
	txtMagicCastingSpeed = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtMagicCastingSpeed" ) );
	txtSpiritShotConsume = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtSpiritShotConsume" ) );

	txtMagicHit = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtMagicHit" ) );
	txtMagicAvoid = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtPhysicalAvoid" ) );
	txtMagicCritical = TextBoxHandle ( GetHandle( "PetWnd.PetWnd_Status.txtMagicCritical" ) );

	PetActionWnd = ItemWindowHandle ( GetHandle( "PetWnd.PetWnd_Action.PetActionWnd" ) );
	PetInvenWnd = ItemWindowHandle ( GetHandle( "PetWnd.PetWnd_Inventory.PetInvenWnd" ) );
}

function InitHandleCOD()
{
	Me = GetWindowHandle( "PetWnd" );
	btnName = GetButtonHandle ( "PetWnd.btnName" );
	texPetHP = GetStatusBarHandle( "PetWnd.texPetHP" );
	texPetMP = GetStatusBarHandle( "PetWnd.texPetMP" );
	texPetExp = GetStatusBarHandle( "PetWnd.texPetExp" );
	texPetFatigue = GetStatusBarHandle( "PetWnd.texPetFatigue" );
	txtPetSP = GetTextBoxHandle( "PetWnd.txtPetSP" );
	txtLvName = GetTextBoxHandle( "PetWnd.txtLvName" );
	txtPhysicalAttack = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtPhysicalAttack" );
	txtPhysicalDefense = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtPhysicalDefense" );
	txtHitRate = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtHitRate" );
	txtCriticalRate = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtCriticalRate" );
	txtPhysicalAttackSpeed = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtPhysicalAttackSpeed" );
	txtSoulShotCosume = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtSoulShotCosume" );
	txtMagicalAttack = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtMagicalAttack" );
	txtMagicDefense = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtMagicDefense" );
	txtPhysicalAvoid = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtPhysicalAvoid" );
	txtMovingSpeed = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtMovingSpeed" );
	txtMagicCastingSpeed = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtMagicCastingSpeed" );
	txtSpiritShotConsume = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtSpiritShotConsume" );

	txtMagicHit = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtMagicHit" ) ;
	txtMagicAvoid = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtMagicAvoid" ) ;
	txtMagicCritical = GetTextBoxHandle( "PetWnd.PetWnd_Status.txtMagicCritical" ) ;

	PetActionWnd = GetItemWindowHandle ( "PetWnd.PetWnd_Action.PetActionWnd" );
	PetInvenWnd = GetItemWindowHandle ( "PetWnd.PetWnd_Inventory.PetInvenWnd" );


}

function OnShow()
{
	class'PetAPI'.static.RequestPetInventoryItemList();
	class'ActionAPI'.static.RequestPetActionList();

	// TT 74585, 74586
	class'UIAPI_WINDOW'.static.HideWindow( "RefineryWnd");
}

function OnDropItem( String strTarget, ItemInfo info, int x, int y )
{
	local InventoryWnd script;
	script = InventoryWnd( GetScript("InventoryWnd") );	

	if( strTarget == "PetInvenWnd" && script.getInventoryItemWndName(info.DragSrcName) == true)
	{
		if( IsStackableItem(info.ConsumeType) && info.ItemNum > 1 )			// Multiple item?
		{
			if( info.AllItemCount > 0 )				// ���� �̵�?
			{
				class'PetAPI'.static.RequestGiveItemToPet(info.ID, info.AllItemCount);
			}
			else
			{
				DialogSetID(DIALOG_GIVEITEMTOPET);
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogSetParamInt64(info.ItemNum);
				DialogSetDefaultOK();
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), info.Name ), string(Self) );
			}
		}
		else																// Single item?
		{
			class'PetAPI'.static.RequestGiveItemToPet(info.ID, 1);
		}
	}
}

function HandleLanguageChanged()
{
	class'PetAPI'.static.RequestPetInventoryItemList();
	class'ActionAPI'.static.RequestPetActionList();
}

function OnHide()
{
	if(DialogIsMine())
	{
		DialogHide();
	}
}

function OnEvent(int Event_ID, string param)
{
	if ( !getInstanceUIData().getIsLiveServer() )
	{
		return;
	}
	if (Event_ID == EV_UpdatePetInfo)
	{
		//~ debug("������ ������Ʈ �̺�Ʈ�� ����");
		HandlePetInfoUpdate();
	}

	else if (Event_ID == EV_UpdateHP)
	{
		UpdatePetHP(param);
	}

	else if (Event_ID == EV_UpdateMP)
	{
		UpdatePetMP(param);
	}

	else if (Event_ID == EV_PetStatusClose)
	{
		HandlePetStatusClose();
	}
	else if (Event_ID == EV_PetWndShow)
	{
		HandlePetInfoUpdate();
		HandlePetShow();
	}
	else if (Event_ID == EV_PetWndShowNameBtn)
	{
		HandlePetShowNameBtn(param);
	}
	else if (Event_ID == EV_PetWndRegPetNameFailed)
	{
		HandleRegPetName(param);
	}
	else if (Event_ID == EV_DialogOK)
	{
		HandleDialogOK();
	}
	else if (Event_ID == EV_ActionPetListStart)
	{
		//~ debug("�׼��׸��� �����.:");
		HandleActionPetListStart();
	}
	else if (Event_ID == EV_ActionPetList)
	{
		HandleActionPetList(param);
	}
	else if (Event_ID == EV_PetInventoryItemStart)
	{
		HandlePetInventoryItemStart();
	}
	else if (Event_ID == EV_PetInventoryItemList)
	{
		HandlePetInventoryItemList(param);
	}
	else if (Event_ID == EV_PetInventoryItemUpdate)
	{
		HandlePetInventoryItemUpdate(param);
	}
	else if (Event_ID == EV_LanguageChanged)
	{
		HandleLanguageChanged();
	}
	else if( Event_ID == EV_ActionListNew )
	{
		class'ActionAPI'.static.RequestPetActionList();
	}

}

function HandleDialogOK()
{
	local int ID;
	local ItemID sID;
	local INT64 Number;
	
	if( DialogIsMine() )
	{
		ID = DialogGetID();
		sID = DialogGetReservedItemID();
		Number = INT64(DialogGetString());
		
		if( id == DIALOG_PETNAME )
		{
			m_LastInputPetName = DialogGetString();
			RequestChangePetName(m_LastInputPetName);	//��� ����� EV_PetWndRegNameXXX�� ����´�.
		}
		else if( id == DIALOG_GIVEITEMTOPET )
		{
			class'PetAPI'.static.RequestGiveItemToPet(sID, Number);
		}
	}
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnName":
		OnNameClick();
		break;
	}
}

function OnNameClick()
{
	DialogSetID(DIALOG_PETNAME);
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modalless,DialogType_OKCancelInput, GetSystemMessage(535), string(Self));
}

//�׼��� Ŭ��
function OnClickItem( string strID, int index )
{
	local ItemInfo infItem;
	
	if (strID == "PetActionWnd" && index>-1)
	{
		if (PetActionWnd.GetItem(index, infItem))
			DoAction(infItem.ID);
	}
}

//�κ� �������� ���
function OnDBClickItem( String strID, int index )
{
	local ItemInfo infItem;
	
	if (strID == "PetInvenWnd" && index>-1)
	{
		if (PetInvenWnd.GetItem(index, infItem))
			class'PetAPI'.static.RequestPetUseItem(infItem.ID);
	}
}
function OnRClickItem( String strID, int index )
{
	local ItemInfo infItem;
	
	if (strID == "PetInvenWnd" && index>-1)
	{
		if (PetInvenWnd.GetItem(index, infItem))
			class'PetAPI'.static.RequestPetUseItem(infItem.ID);
	}
}

//�ʱ�ȭ
function Clear()
{
	txtLvName.SetText("");
	//txtPetHP.SetText("0/0");
	//txtPetMP.SetText("0/0");
	txtPetSP.SetText("0");
	//txtPetExp.SetText("0%");
	//txtFatigue.SetText("0%");
		
	texPetHP.SetPoint(0, 0);
	texPetMP.SetPoint(0, 0);
	texPetExp.SetPointPercent(0, 0, 0);
	texPetFatigue.SetPointPercent(0, 0, 0);
}
function ClearActionWnd()
{
	PetActionWnd.Clear();
}
function ClearInvenWnd()
{
	PetInvenWnd.Clear();
}

//���̸� ��� ��� ó��
function HandleRegPetName(string param)
{
	local int MsgNo;
	
	ParseInt(param, "ErrMsgNo", MsgNo);
		
	AddSystemMessage(MsgNo);
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modalless,DialogType_OKCancelInput, GetSystemMessage(535), string(Self));
	
	//���̸��� ���ѱ��ڼ��� �ʰ��Ͽ��� ����, ���� �Է��� �̸��� �ٽ� ����Ѵ�.
	if (MsgNo==80)
	{
		DialogSetString(m_LastInputPetName);
	}
}

//���̸� ��ư ó��
function HandlePetShowNameBtn(string param)
{
	local int ShowFlag;
	ParseInt(param, "Show", ShowFlag);
	
	if (ShowFlag==1)
	{
		SetVisibleNameBtn(true);
	}
	else
	{
		SetVisibleNameBtn(false);
	}
}

function SetVisibleNameBtn(bool bShow)
{
	if (bShow)
	{
		btnName.ShowWindow();
	}
	else
	{
		btnName.HideWindow();
	}
	m_bShowNameBtn = bShow;
}

//����ó��
function HandlePetStatusClose()
{
	Me.HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//mp ������Ʈ
function UpdatePetMP(string param)
{
	local int       serverID;
	local int		CurrentMP;
	local int		MP;
	local int		MaxMP;
	local PetInfo	info;

	ParseInt( param, "ServerID", serverID );
	ParseInt( param, "CurrentMP", CurrentMP );
	
	if (GetPetInfo(info))
	{
		if (serverID == info.nServerID)
		{
			MP = CurrentMP;
			MaxMP = info.nMaxMP;
			texPetMP.SetPoint(MP , MaxMP);	
		}
	}
}

//hp ������Ʈ
function UpdatePetHP(string param)
{
	local int       serverID;
	local int		CurrentHP;
	local int		HP;
	local int		MaxHP;
	local PetInfo	info;

	ParseInt( param, "ServerID", serverID );
	ParseInt( param, "CurrentHP", CurrentHP );
	
	if (GetPetInfo(info))
	{
		if (serverID == info.nServerID)
		{
			HP = CurrentHP;
			MaxHP = info.nMaxHP;
			texPetHP.SetPoint(HP , MaxHP);	
		}
	}
}

//��Info��Ŷ ó��
function HandlePetInfoUpdate()
{	
	local string	Name;
	local int		HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;
	local int		Fatigue;
	local int		MaxFatigue;
	local INT64		SP;
	local int		Level;
	//local float		fExpRate;
	//local float		fTmp;
	local int		PhysicalAttack;
	local int		PhysicalDefense;
	local int		HitRate;
	local int		CriticalRate;
	local int		PhysicalAttackSpeed;
	local int		MagicalAttack;
	local int		MagicDefense;
	local int		PhysicalAvoid;
	local int		MovingSpeed;
	local int		MagicCastingSpeed;
	local int		SoulShotCosume;
	local int		SpiritShotConsume;
	local int 		nEvolutionID;
	
	local int       MagicalHitRate;
	local int 	    MagicalAvoid;
	local int 	    MagicalCritical;

	local INT64       nCurExp;
	local INT64       nMinExp;
	local INT64       nMaxExp;
	
	local PetInfo	info;

	if( !Me.IsShowWindow() )
		return;
	
	if (GetPetInfo(info))
	{
		//Debug("GetPetInfo(info)" @ GetPetInfo(info));
		//PetOrSummoned =>  Pet :2    summon :1
		if( info.PetOrSummoned != 2 ){
			return;
		}

		m_PetID = info.nServerID;
		Name = info.Name;
		SP = info.nSP;
		Level = info.nLevel;
		HP = info.nCurHP;
		MaxHP = info.nMaxHP;
		MP = info.nCurMP;
		MaxMP = info.nMaxMP;
		Fatigue = info.nFatigue;
		MaxFatigue = info.nMaxFatigue;


		// 2010.7.13 
		// ����ġ ��հ�		
		//fExpRate = class'UIDATA_PET'.static.GetPetEXPRate(m_PetID); //2011 5 18 hardcom ��� ���� �ʴ� �� �� �Լ� ����� �ٿ�		
		//fExpRate = float ((info.nCurExp / info.nMaxExp) * 100.0f);	
		
		nCurExp = info.nCurExp;
		nMinExp = info.nMinExp;
		nMaxExp = info.nMaxExp;		

		nEvolutionID = info.nEvolutionID;
			
		//�� �� ����
		PhysicalAttack		= info.nPhysicalAttack;
		PhysicalDefense		= info.nPhysicalDefense;
		HitRate				= info.nHitRate;
		CriticalRate		= info.nCriticalRate;
		if(IsUseSkillCastingSpeedStat())
		{
			PhysicalAttackSpeed = info.nPhysicalSkillCastingSpeed;			
		}
		else
		{
			PhysicalAttackSpeed = info.nPhysicalAttackSpeed;
		}
		MagicalAttack		= info.nMagicalAttack;
		MagicDefense		= info.nMagicDefense;
		PhysicalAvoid		= info.nPhysicalAvoid;
		MovingSpeed			= info.nMovingSpeed;
		MagicCastingSpeed	= info.nMagicCastingSpeed;
		SoulShotCosume		= info.nSoulShotCosume;
		SpiritShotConsume	= info.nSpiritShotConsume;

		MagicalHitRate      = info.nMagicalHitRate;
		MagicalAvoid        = info.nMagicalAvoid;
		MagicalCritical     = info.nMagicalCritical;

	}
	
	txtLvName.SetText(Level $ " " $ Name);
	//txtPetHP.SetText(HP $ "/" $ MaxHP);
	//txtPetMP.SetText(MP $ "/" $ MaxMP);
	txtPetSP.SetText(string(SP));
	//txtPetExp.SetText(fExpRate $ "%");
	
	//�� �� ���� ��
	txtPhysicalAttack.SetText(string(PhysicalAttack));
	txtPhysicalDefense.SetText(string(PhysicalDefense));
	txtHitRate.SetText(string(HitRate));
	txtCriticalRate.SetText(string(CriticalRate));
	txtPhysicalAttackSpeed.SetText(string(PhysicalAttackSpeed));
	txtMagicalAttack.SetText(string(MagicalAttack));
	txtMagicDefense.SetText(string(MagicDefense));
	txtPhysicalAvoid.SetText(string(PhysicalAvoid));
	txtMovingSpeed.SetText(string(MovingSpeed));
	txtMagicCastingSpeed.SetText(string(MagicCastingSpeed));
	txtSoulShotCosume.SetText(string(SoulShotCosume));
	txtSpiritShotConsume.SetText(string(SpiritShotConsume));

	txtMagicHit.SetText(string(MagicalHitRate));
	txtMagicAvoid.SetText(string(MagicalAvoid));
	txtMagicCritical.SetText(string(MagicalCritical));
	
	//fTmp = 100.0f * float(Fatigue) / float(MaxFatigue);
	//txtFatigue.SetText(fTmp $ "%");
	
	//debug ("������  PEt HP1"@ HP);
	//debug ("������  PEt HP2"@ MaxHP);
	texPetHP.SetPoint(HP , MaxHP);	
	texPetMP.SetPoint(MP , MaxMP);
	//fTmp = 100.0f * fExpRate;	
	 
	texPetExp.SetPointPercent(nCurExp , nMinExp, nMaxExp); //hardcom 20110518 ���� 
	texPetFatigue.SetPointPercent(Fatigue, 0, MaxFatigue);
	
	//��ȭ�� �꿡 ���� Ư�� �׼� ó��
	EvolutionizedAction = nEvolutionID;
	//~ debug("��ȭ���̵�:"@ EvolutionizedAction @ nEvolutionID);
	
}

//��â�� ǥ��
function HandlePetShow()
{
	Clear();
	PlayConsoleSound(IFST_WINDOW_OPEN);
	Me.ShowWindow();
	Me.SetFocus();
	//~ debug("������ �̺�Ʈ�� ���Ƿ� ������");
	HandlePetInfoUpdate();
	
	//�̸���ư
	SetVisibleNameBtn(m_bShowNameBtn);
}

///////////////////////////////////////////////////////////////////////////////////////
// �׼� ������ ó��
///////////////////////////////////////////////////////////////////////////////////////
function HandleActionPetListStart()
{
	HandlePetInfoUpdate();
	ClearActionWnd();
}

function HandleActionPetList(string param)
{
	local int Tmp;
	local EActionCategory Type;
	local string strActionName;
	local string strIconName;
	local string strDescription;
	local string strCommand;
	local int intClassID;
	
	local ItemInfo	infItem;
	
	ParseItemID(param, infItem.ID);
	ParseInt(param, "Type", Tmp);
	ParseString(param, "Name", strActionName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "Description", strDescription);
	ParseString(param, "Command", strCommand);
	ParseInt(param, "ClassID", intClassID);
	
	infItem.Name = strActionName;
	infItem.IconName = strIconName;
	infItem.Description = strDescription;
	infItem.ShortcutType = int(EShortCutItemType.SCIT_ACTION);
	infItem.MacroCommand = strCommand;
	
	//~ ClearActionWnd();
	
	//ItemWnd�� �߰�
	Type = EActionCategory(Tmp);

	//���� ������ �׼� �߰� ��� 
	if (Type==ACTION_PET)
	{
		switch (EvolutionizedAction)
		{
			case 2:
				if (intClassID == 1044)
				{
					//~ debug("�ɷ���3");
				}
				else
				{
					PetActionWnd.AddItem(infItem);
				}
				break;
			case 1:
				if (intClassID == 1042 || intClassID == 1044)
				{
					//~ debug("�ɷ���2");
				}
				else
				{
					PetActionWnd.AddItem(infItem);
				}
				break;
			case 0:
				if (intClassID == 1042 || intClassID == 1043 || intClassID == 1044 || intClassID == 1045 || intClassID == 1046)
				{
					//~ debug("�ɷ���1");
				}
				else
				{
					PetActionWnd.AddItem(infItem);
				}
				break;
			case 3:
				PetActionWnd.AddItem(infItem);
				break;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////
// �κ� ������ ó��
///////////////////////////////////////////////////////////////////////////////////////
function HandlePetInventoryItemStart()
{
	ClearInvenWnd();
}

function HandlePetInventoryItemList(string param)
{
	local ItemInfo	infItem;
	
	ParamToItemInfo(param, infItem);
	
	if (infItem.bEquipped)
		infItem.ForeTexture = PET_EQUIPPEDTEXTURE_NAME;
	
	PetInvenWnd.AddItem(infItem);
}

function HandlePetInventoryItemUpdate(string param)
{
	local ItemInfo	infItem;
	local int		Tmp;
	local int		Index;
	local EInventoryUpdateType WorkType;
	
	ParamToItemInfo(param, infItem);
	ParseInt(param, "WorkType", Tmp);
	WorkType = EInventoryUpdateType(Tmp);
	
	//Check ClassID
	if (!IsValidItemID(infItem.ID))
		return;
		
	if (infItem.bEquipped)
		infItem.ForeTexture = PET_EQUIPPEDTEXTURE_NAME;
		
	switch( WorkType )
	{
	case IVUT_ADD:
		PetInvenWnd.AddItem(infItem);
		break;
	case IVUT_UPDATE:
		//Find Item
		Index = PetInvenWnd.FindItem(infItem.ID);
		if (Index<0)
			return;
		PetInvenWnd.SetItem(Index, infItem);
		break;
	case IVUT_DELETE:
		//Find Item
		Index = PetInvenWnd.FindItem(infItem.ID);
		if (Index<0)
			return;
		PetInvenWnd.DeleteItem(Index);
		break;
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
     m_WindowName="PetWnd"
}
