class PetStatusWnd extends UICommonAPI;

const NSTATUSICON_MAXCOL = 12;

var int MAX_BUFF_ICONTYPE;  // �����ְ��� �ϴ� ���� ������ Ÿ�� ����
var string m_WindowName;
var bool m_bBuff;
var bool m_bShow;
var int m_PetID;
var int m_CurBf;
var bool m_bPetload;
var WindowHandle Me;
var StatusBarHandle barFATIGUE;
var StatusBarHandle barMP;
var StatusBarHandle barHP;
var NameCtrlHandle PetName;
var ButtonHandle btnBuff;
var WindowHandle BackTex;
//~ var StatusIconHandle StatusIcon;
var StatusIconHandle m_StatusIconBuff;
var StatusIconHandle m_StatusIconDeBuff;
var StatusIconHandle m_StatusIconSongDance;
var StatusIconHandle m_StatusIconItem;
var StatusIconHandle m_StatusIconTriggerSkill;
var StatusIconHandle BufIcon;
var StatusIconHandle DebufIcon;
var StatusIconHandle SongDanceIcon;
var StatusIconHandle TriggerSkillIcon;
var StatusIconHandle ItemIcon;
var TextureHandle m_IsDead;


function OnRegisterEvent()
{
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_UpdatePetInfo);
	RegisterEvent(EV_ShowBuffIcon);
	// RegisterEvent(EV_StateChanged);
	RegisterEvent(EV_PetStatusShow);
	RegisterEvent(EV_PetStatusSpelledList);

	RegisterEvent(EV_PetStatusClose);
	RegisterEvent(EV_UpdateHP); //hp ������ ���� ��� 
	RegisterEvent(EV_UpdateMP); //mp ������ ���� ��� 

	RegisterEvent(EV_PetStatusSpelledListDelete); //1052
	RegisterEvent(EV_PetStatusSpelledListInsert); //1053	

	RegisterEvent(EV_TargetUpdate); //1053	
}

function OnLoad()
{
	InitializeCOD();
	Load();
}

function InitializeCOD()
{
	BufIcon = GetStatusIconHandle(m_WindowName $ ".StatusIconBuff");
	DebufIcon = GetStatusIconHandle(m_WindowName $ ".StatusIconDeBuff");
	SongDanceIcon = GetStatusIconHandle(m_WindowName $ ".StatusIconSongDance");
	ItemIcon = GetStatusIconHandle(m_WindowName $ ".StatusIconItem");
	TriggerSkillIcon = GetStatusIconHandle(m_WindowName $ ".StatusIconTriggerSkill");
	Me = GetWindowHandle(m_WindowName);
	barFATIGUE = GetStatusBarHandle(m_WindowName $ ".barFATIGUE");
	barMP = GetStatusBarHandle(m_WindowName $ ".barMP");
	barHP = GetStatusBarHandle(m_WindowName $ ".barHP");
	PetName = GetNameCtrlHandle(m_WindowName $ ".PetName");
	btnBuff = GetButtonHandle(m_WindowName $ ".btnBuff");
	BackTex = GetWindowHandle(m_WindowName $ ".BackTex");
	m_IsDead = GetTextureHandle(m_WindowName $ ".BackTex.IsDeadTexture");
	m_StatusIconBuff = GetStatusIconHandle(m_WindowName $ ".StatusIconBuff");
	m_StatusIconDeBuff = GetStatusIconHandle(m_WindowName $ ".StatusIconDeBuff");
	m_StatusIconSongDance = GetStatusIconHandle(m_WindowName $ ".StatusIconSongDance");
	m_StatusIconItem = GetStatusIconHandle(m_WindowName $ ".StatusIconItem");
	m_StatusIconTriggerSkill = GetStatusIconHandle(m_WindowName $ ".StatusIconTriggerSkill");
	m_IsDead.HideWindow();
}

function Load()
{
	m_CurBf = 1;
	m_bPetload = false;
	SetBuffButtonTooltip();
	m_bShow = false;
	m_bBuff = false;
}

function OnShow()
{
	// local int IsPetOrSummoned;
	local PetInfo petInfo;

	//PetID = class'UIDATA_PET'.static.GetPetID();
	GetPetInfo(petInfo);

	//IsPetOrSummoned = class'UIDATA_PET'.static.GetIsPetOrSummoned();

	//if (petInfo.nID < 0 || IsPetOrSummoned!=2)
	if (petInfo.nServerID < 0)
	{
		Me.HideWindow();
	}
	else
	{
		m_bShow = true;
	}
}

function OnHide()
{
	m_bShow = false;
}

function OnEnterState(name a_CurrentStateName)
{
	if(getInstanceUIData().getIsLiveServer())
	{
		EachServerEnterState(a_CurrentStateName);
	}
}

function EachServerEnterState(name a_CurrentStateName)
{
	if(m_bPetload)
	{
		Me.ShowWindow();
	}
	m_bBuff = false;

	GetINIInt(m_WindowName, "a", m_CurBf, "WindowsInfo.ini");
	
	if(m_CurBf > MAX_BUFF_ICONTYPE)
	{
		m_CurBf = 0;
		SetINIInt(m_WindowName, "a", m_CurBf, "WindowsInfo.ini");
	}

	SetBuffButtonTooltip();
	UpdateBuff();
}

function OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().getIsLiveServer())
	{
		EachServerEvent(Event_ID, param);
	}
}

function EachServerEvent(int Event_ID, string param)
{
	if(Event_ID == EV_UpdatePetInfo)
	{
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

	// ����̰� ��ģ�ǵ�.. �̷��� �ϸ� �ȵȴ�. ����ŸƮ�ÿ� �ʱ�ȭ�� �ϸ� �Ǵ°�..�̻��� ���� �ؼ�
	// 63938 ���� TTP �߻�..-_-..

	//������Ʈ �ٲ� ��
	//ttp 63598 ���� //kick ���� ƨ������ EV_PetStatusClose �̺�Ʈ�� ���� ��������
	//������ m_bPetload �� false �� �ٲ���
	//�׷��� ���� �� ����â�� ������ ����
	//else if(Event_ID == EV_StateChanged)
	//{
	//	Debug("�� " @ param);
	//	if( param != "ReplayState")
	//	{
	//		m_bPetload = false;
	//	}
	//}

	else if (Event_ID == EV_PetStatusClose)
	{
		HandlePetStatusClose();
		m_bPetload = false;
	}
	else if (Event_ID == EV_PetStatusShow)
	{
		if(GetGameStateName()!="GAMINGSTATE")
			return;
	
		HandlePetStatusShow();
		m_bPetload = true;
	}
	else if (Event_ID == EV_ShowBuffIcon)
	{
		HandleShowBuffIcon(param);
	}
	else if (Event_ID == EV_PetStatusSpelledList) //1050
	{
		HandlePetStatusSpelledList(param);
		//Debug( "Event : " $ Event_ID @ param);
	}
	else if (Event_ID == EV_PetStatusSpelledListDelete) //1053
	{
		HandlePetStatusSpelledListDelete(param);
		//Debug( "Event : " $ Event_ID @ param);
	}
	else if (Event_ID == EV_PetStatusSpelledListInsert) //1052
	{
		HandlePetStatusSpelledListInsert(param);
		//Debug( "Event : " $ Event_ID @ param);
	}
	else if (Event_ID == EV_TargetUpdate)
	{
		HandleCheckTarget();
	}
	// 63598 ttp
	else if (Event_ID == EV_Restart)
	{
		m_bPetload = false;
		m_IsDead.HideWindow();
	}
}

// Ÿ���� ���� ��Ƽ���̸� ���� ���� ��ȭ�� �ش�.
function HandleCheckTarget()
{
	local bool bItsME;

	if(class'UIDATA_TARGET'.static.GetTargetID() == m_PetID && m_PetID > 0) bItsME = true;
	
	if ( getInstanceUIData().getIsLiveServer() )
	{
		if ( bItsME )
			Me.SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Over");
		else
			Me.SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg");
	}
	else
	{
		if ( bItsME )
			BackTex.SetBackTexture("L2UI_NewTex.PartyWndBG_OverClassic");
		else
			BackTex.SetBackTexture("L2UI_NewTex.Windows.PartyWndBG");
	}
}


function ClearTargetHighLight ()
{
	if ( getInstanceUIData().getIsLiveServer() )
		Me.SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg");
	else
		BackTex.SetBackTexture("L2UI_NewTex.Windows.PartyWndBG");
}


//�ʱ�ȭ
function Clear()
{
	m_StatusIconBuff.Clear();
	m_StatusIconDeBuff.Clear();
	m_StatusIconSongDance.Clear();
	m_StatusIconItem.Clear();
	m_StatusIconTriggerSkill.Clear();

	PetName.SetName("", NCT_Normal, TA_Left);
	barHP.SetPoint(0, 0);
	barMP.SetPoint(0, 0);
	barFATIGUE.SetPoint(0, 0);
	ClearTargetHighLight();
	Me.HideWindow();
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
			barMP.SetPoint(MP,maxMP);
		}
	}
}

//hp ������Ʈ
function UpdatePetHP(string param)
{
	local int serverID;
	local int CurrentHP;
	local int HP;
	local int MaxHP;
	local PetInfo info;

	ParseInt(param, "ServerID", serverID);
	ParseInt(param, "CurrentHP", CurrentHP);
	
	if(GetPetInfo(info))
	{
		if(serverID == info.nServerID)
		{
			HP = CurrentHP;
			MaxHP = info.nMaxHP;			
			barHP.SetPoint(HP,MaxHP);

			if (m_PetID >= 0)
			{
				if ( CurrentHP <= 0 ) m_IsDead.ShowWindow();
				else m_IsDead.hideWindow();
			}
		}
	}
}

//��Info��Ŷ ó��
function HandlePetInfoUpdate()
{
	local string Name;
	local int  HP;
	local int  MaxHP;
	local int  MP;
	local int  MaxMP;
	local int  Fatigue;
	local int  MaxFatigue;
	local PetInfo info;

	m_PetID = 0;
	if (GetPetInfo(info))
	{
		m_PetID = info.nServerID;
		Name = info.Name;
		HP = info.nCurHP;
		MP = info.nCurMP;
		Fatigue = info.nFatigue;
		MaxHP = info.nMaxHP;
		MaxMP = info.nMaxMP;
		MaxFatigue = info.nMaxFatigue;

		if (m_PetID >= 0)
		{
			if (HP <= 0) m_IsDead.ShowWindow();
			else m_IsDead.HideWindow();
		}
	}

	PetName.SetName(Name, NCT_Normal,TA_Left);
	barHP.SetPoint(HP,MaxHP);
	barMP.SetPoint(MP,maxMP);
	barFATIGUE.SetPoint(Fatigue,MaxFatigue);}

//��â�� ǥ��
function HandlePetStatusShow()
{
	Clear();
	Me.ShowWindow();
	Me.SetFocus();

	Debug("�� ui���� " );
}

//���� ��������Ʈ����
function HandlePetStatusSpelledList(string param)
{
	local int i;
	local int ID;
	local int Max;

	local int BuffCnt;
	local int BuffCurRow;

	local int DeBuffCnt;
	local int DeBuffCurRow;

	local int SongDanceCnt;
	local int SongDanceCurRow;

	
	local int TriggerSkillCnt;
	local int TriggerSkillCurRow;
	
	local int ItemCnt;
	local int ItemCurRow;

	local StatusIconInfo info;	

	DeBuffCurRow = -1;
	BuffCurRow = -1;
	SongDanceCurRow = -1;
	ItemCurRow = -1;
	TriggerSkillCurRow = -1;

	ParseInt(param, "ID", ID);	
	if (ID<1 || m_PetID != ID) // �� ���� ������������ Ȯ���ϰ�, �ƴϸ� �ݻ� 
	{
		return;
	}

	m_StatusIconBuff.Clear();
	m_StatusIconDeBuff.Clear();
	m_StatusIconSongDance.Clear();
	m_StatusIconItem.Clear();
	m_StatusIconTriggerSkill.Clear();

	//info �ʱ�ȭ
	info.Size = 16;
	info.bShow = true; 

	ParseInt(param, "Max", Max);
	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "Level_" $ i, info.Level);
		ParseInt(param, "SubLevel_" $ i, info.SubLevel);
		if ( IsIconHide(Info.Id,Info.Level,Info.SubLevel) )
		{			
			continue ;
		}
		// ���� ������ ��� add ���� ����.
		if ( class'UIDATA_SKILL'.static.IsToppingSkill( info.ID, info.Level, info.SubLevel) ) 
		{			
			continue ;
		}

		ParseInt(param, "Sec_" $ i, info.RemainTime);

		//ttp 60079
		ParseInt(param, "SpellerID_" $ i, info.SpellerID);
		
		if (IsValidItemID(info.ID))
		{			
			info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, info.Level, info.SubLevel);
			Info.IconPanel = Class'UIDATA_SKILL'.static.GetIconPanel(Info.Id,Info.Level,Info.SubLevel);
			info.bHideRemainTime = true;

			if (GetDebuffType( info.ID, info.Level, info.SubLevel) != 0 )
			{
				if (DeBuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					DeBuffCurRow++;				 
					m_StatusIconDeBuff.AddRow();				 
				}
				m_StatusIconDeBuff.AddCol(DeBuffCurRow, info);
				DeBuffCnt++;
			}
			else if ( GetIndexByIsMagic(Info) == 3 )
			{
				if (SongDanceCnt%NSTATUSICON_MAXCOL == 0)
				{					
					SongDanceCurRow++;					
					m_StatusIconSongDance.AddRow();					
				}	
				m_StatusIconSongDance.AddCol(SongDanceCurRow, info);
				SongDanceCnt++;
			}
			else if ( GetIndexByIsMagic(Info) == 4 )
			{
				if ( ItemCnt % NSTATUSICON_MAXCOL == 0 )
				{
					ItemCurRow++;
					m_StatusIconItem.AddRow();
				}
				m_StatusIconItem.AddCol(ItemCurRow,Info);
				ItemCnt++;
			}
			else if ( GetIndexByIsMagic(Info) == 5 )
			{
				if ( TriggerSkillCnt % NSTATUSICON_MAXCOL == 0 ) 
				{
					TriggerSkillCurRow++;					
					m_StatusIconTriggerSkill.AddRow();
				}
				m_StatusIconTriggerSkill.AddCol(TriggerSkillCurRow, info);
				TriggerSkillCnt++;
			}
			else
			{				
//				Debug( "BuffCnt" @ BuffCnt @ BuffCnt%NSTATUSICON_MAXCOL );
				if (BuffCnt%NSTATUSICON_MAXCOL == 0)
				{					
					
					BuffCurRow++;
					m_StatusIconBuff.AddRow();
//					Debug("addRow");
				}			
				m_StatusIconBuff.AddCol(BuffCurRow, info);
//				Debug("addCol");
				BuffCnt++;
			}
		}
	}	
	UpdateBuff();
}


//��������Ʈ����
function HandlePetStatusSpelledListDelete(string param)
{
	local int i;	
	local int ID;
	local int Max;	
	local StatusIconInfo info;		

	ParseInt(param, "ID", ID);	

	if (ID<1 || m_PetID != ID) // �� ���� ������������ Ȯ���ϰ�, �ƴϸ� �ݻ� 
	{
		return;
	}
		
	ParseInt(param, "Max", Max);

	for (i=0; i<Max; i++)
	{
		//���� ������ �˱� ���� ID, Level
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "Level_" $ i, info.Level );
		ParseInt(param, "SubLevel_" $ i, info.SubLevel );

		ParseInt(param, "SpellerID_" $ i, info.SpellerID );
		//ParseInt(param, "classID_" $ i, classID);//�����ؾ� �� Ŭ���� ID
		
		if (IsValidItemID(info.ID))
		{	
			//������̸� 
			if (GetDebuffType( info.ID, info.Level, info.SubLevel) != 0 )
			{	
				deleteBuff( m_StatusIconDeBuff, info.Level, info.ID.ClassID, info.SpellerID);
			}
			//�۴���
			else if ( GetIndexByIsMagic(Info) == 3 )
			{	
				deleteBuff( m_StatusIconSongDance, info.Level, info.ID.ClassID, info.SpellerID);
			}
			else if ( GetIndexByIsMagic(Info) == 4 )
			{
				deleteBuff(m_StatusIconItem,Info.Level,Info.Id.ClassID,Info.SpellerID);
			}
			//IsTriggerSkill
			else if ( GetIndexByIsMagic(Info) == 5 )
			{								
				 deleteBuff( m_StatusIconTriggerSkill, info.Level, info.ID.ClassID, info.SpellerID);
			}
			//�Ϲ� ���� 
			else
			{	
				deleteBuff( m_StatusIconBuff, info.Level, info.ID.ClassID, info.SpellerID);
			}
		}
	}	

	UpdateBuff();
}


//���� ������ ������ ã�� ���� �ϴ� �Լ�
function deleteBuff( StatusIconHandle tmpStatusIcon , int level, int classID, int spellerID )
{
	local int row;	
	local int col;
	local StatusIconInfo info;	

	for ( row = 0 ; row < tmpStatusIcon.GetRowCount(); row++ )
	{
		for ( col = 0 ; col < tmpStatusIcon.GetColCount(row) ; col++)
		{
			tmpStatusIcon.GetItem(row, col, info );			
			if ( info.ID.classID == classID && info.level ==  level && info.SpellerID == spellerID)
			{
				tmpStatusIcon.DelItem( row, col );
				refreshPostion( tmpStatusIcon , row );
				return;
			}
		}
	}
}
//������ �� �� �̻� �� ��� ������ �� ĭ�� ���� �ִ� �Լ�
function refreshPostion ( StatusIconHandle tmpStatusIcon , int deletedRow  )
{
	local int row;
	local StatusIconInfo info;	

	for ( row = deletedRow ; row < tmpStatusIcon.GetRowCount() -1 ; row ++ )
	{
		tmpStatusIcon.GetItem (row + 1 ,   0,  info );//���� �ٿ� �ִ� �� �� �� ���� ���� ���� ���� 
		tmpStatusIcon.addCol( row, info);// �� �������� ������ �ٿ� ä�� ���� ����
		tmpStatusIcon.DelItem( row + 1, 0 ); // �����.
	}
}



//��������Ʈ�߰�
function HandlePetStatusSpelledListInsert(string param)
{
	local int i;		
	local int ID;
	local int Max;

	local StatusIconInfo info;
	local StatusIconHandle tmpStatusIcon;

	ParseInt(param, "ID", ID);

	
	if (ID<1 || m_PetID != ID) // �� ���� ������������ Ȯ���ϰ�, �ƴϸ� �ݻ� 
	{
		return;
	}
		
	info.Size = 16;
	info.bShow = true;
	
	//Max=1 ID=1209091781 ClassID_0=77 Level_0=2 Sec_0=1200
	ParseInt(param, "Max", Max);
	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "Level_" $ i, info.Level);
		ParseInt(param, "SubLevel_" $ i, info.SubLevel);
		ParseInt(param, "Sec_" $ i, info.RemainTime);
		if ( IsIconHide(Info.Id,Info.Level,Info.SubLevel) )
		{			
			continue ;
		}

		// ���� ������ ��� add ���� ����.
		if ( class'UIDATA_SKILL'.static.IsToppingSkill( info.ID, info.Level, info.SubLevel) ) 
		{			
			continue ;
		}

		//ttp 60079
		ParseInt(param, "SpellerID_" $ i, info.SpellerID);

		info.bHideRemainTime = true;

		if (IsValidItemID(info.ID))
		{				
			info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, info.Level, info.SubLevel);
			Info.IconPanel = Class'UIDATA_SKILL'.static.GetIconPanel(Info.Id,Info.Level,Info.SubLevel);
			info.bHideRemainTime = true;
			//������̸� 
			if (GetDebuffType( info.ID, info.Level, info.SubLevel) != 0 )
			{				
				tmpStatusIcon = m_StatusIconDeBuff;								
			}
			//�۴���
			else if ( GetIndexByIsMagic(Info) == 3 )
			{					
				tmpStatusIcon = m_StatusIconSongDance;
			}
			else if ( GetIndexByIsMagic(Info) == 4 )
			{
				tmpStatusIcon = m_StatusIconItem;
			}
			//IsTriggerSkill
			else if ( GetIndexByIsMagic(Info) == 5 )
			{				
				 tmpStatusIcon = m_StatusIconTriggerSkill;
			}
			//�Ϲ� ���� 
			else
			{	
				tmpStatusIcon = m_StatusIconBuff;
			}
			//�߰� �κ�				
			if ( tmpStatusIcon.GetRowCount() == 0 || tmpStatusIcon.GetColCount( tmpStatusIcon.GetRowCount() -1 ) % NSTATUSICON_MAXCOL == 0 )
			{				
				tmpStatusIcon.AddRow();
			}
			tmpStatusIcon.AddCol( tmpStatusIcon.GetRowCount() -1 , info);
		}
	}

	UpdateBuff();
}

//���������� ǥ��
function HandleShowBuffIcon(string param)
{
	local int nShow;
	ParseInt(param, "Show", nShow);
	if (nShow==1)
	{
		//~ UpdateBuff(true);
		UpdateBuff();
	}
	else
	{
		//~ UpdateBuff(false);
		UpdateBuff();
	}
}


// ��������� ǥ��,  �۴��� , ���� 3������带 ��ȯ�Ѵ�.
function UpdateBuff()
{
	//�Ϲ�/�����
	if (m_CurBf == 1)
	{
		// ���� , ����� ���� �ش�.
		m_StatusIconBuff.ShowWindow();
		m_StatusIconDeBuff.ShowWindow();
		m_StatusIconSongDance.HideWindow();
		m_StatusIconItem.HideWindow();
		m_StatusIconTriggerSkill.HideWindow();
	}
	// �۴���
	else if (m_CurBf == 2)
	{
		m_StatusIconBuff.HideWindow();
		m_StatusIconDeBuff.HideWindow();
		m_StatusIconSongDance.ShowWindow();
		m_StatusIconItem.HideWindow();
		m_StatusIconTriggerSkill.HideWindow();
	}
	// Ư�� �̻���� 
	else if(m_CurBf == 3)
	{
		m_StatusIconBuff.HideWindow();
		m_StatusIconDeBuff.HideWindow();
		m_StatusIconSongDance.HideWindow();
		m_StatusIconItem.ShowWindow();
		m_StatusIconTriggerSkill.HideWindow();
	}
	else if ( m_CurBf == 4 )
	{
		m_StatusIconBuff.HideWindow();
		m_StatusIconDeBuff.HideWindow();
		m_StatusIconSongDance.HideWindow();
		m_StatusIconItem.HideWindow();
		m_StatusIconTriggerSkill.ShowWindow();
	}
	else
	{
		m_StatusIconBuff.HideWindow();
		m_StatusIconDeBuff.HideWindow();
		m_StatusIconSongDance.HideWindow();
		m_StatusIconItem.HideWindow();
		m_StatusIconTriggerSkill.HideWindow(); 
	}
 //m_bBuff = bShow;
}


function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect rectWnd;
	local UserInfo userinfo;

//	Debug ("OnLButtonDown");
	rectWnd = Me.GetRect();	
	if (X > rectWnd.nX + 13 && X < rectWnd.nX + rectWnd.nWidth -10)
	{
		if (GetPlayerInfo(userinfo))
		{
			RequestAction(m_PetID, userinfo.Loc);
		}
	}
}

function OnClickButton( string strID )
{
	switch( strID )
	{
		case "btnBuff":
			OnBuffButton();
			break;
	}
}

// ������ư�� ������ ��� ����Ǵ� �Լ�
function OnBuffButton()
{
	m_CurBf = m_CurBf + 1;

	//3���� ��尡 ��ȯ�ȴ�.
	if (m_CurBf > MAX_BUFF_ICONTYPE)
	{
		m_CurBf = 0;
	}

	SetINIInt(m_WindowName, "a", m_CurBf, "WindowsInfo.ini");
	SetBuffButtonTooltip();
	UpdateBuff();
}


// ���� ������ �����Ѵ�.
function SetBuffButtonTooltip()
{
	local Color b1, b2, b3;//, b4;//, b0;
	local Array<DrawItemInfo> drawListArr;
	local int buttonIndex;

	b1 = getInstanceL2Util().Gray;
	b2 = getInstanceL2Util().Gray;
	b3 = getInstanceL2Util().Gray;
	//b4 = getInstanceL2Util().Gray;
	//b0 = getInstanceL2Util().Gray;
	//Debug("m_CurBf" @ m_CurBf);

	// Debug("m_CurBf" @ m_CurBf);

	if (m_CurBf == 0)
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbutton_off", 
						   "L2ui_CH3.PartyWnd.party_buffbutton_off", 
						   "L2ui_CH3.PartyWnd.party_buffbutton_off");
	}
	else
	{
		// �ι�° �̹����� �پ� �Ѱ� �Ϸ���.. (����� ���⸦ ��ġ�鼭..)
		if (m_CurBf > 1) buttonIndex = m_CurBf + 1;
		else buttonIndex = m_CurBf;

		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbutton_" $ buttonIndex, 
						   "L2ui_CH3.PartyWnd.party_buffbutton_" $ buttonIndex, 
						   "L2ui_CH3.PartyWnd.party_buffbutton_" $ buttonIndex);
	}

	switch (m_CurBf)
	{
		case 0:	
			//b0 = getInstanceL2Util().Yellow;
			break;

		case 1:	
			b1 = getInstanceL2Util().Yellow;
			break;

		case 2:
			b2 = getInstanceL2Util().Yellow;
			break;

		case 3:
			b3 = getInstanceL2Util().Yellow;
			break;

		//case 4:
		//	b4 = getInstanceL2Util().Yellow;
		//	break;
	}
	//drawListArr.Length = 5;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1496) $ "/" $ GetSystemString(1497), b1, "", true, true); //���� ����/ ����� ����
	//drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1497), b2, "", true, true); 
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1741), b2, "", true, true); // �ó���/��/���� ����
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2307), b3, "", true, true); // Ư�� �̻���� ����
	btnBuff.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function OnClickItem( string strID, int index )
{
	local int row;
	local int col;
	local StatusIconInfo info;
	local SkillInfo skillInfo;		// ��ų ����. ������ų���� Ȯ���ؾ� �ϴϱ�
	local StatusIconHandle  StatusIcon;

//	Debug("item Click");
	col = index / 10;
	row = index - (col * 10);

	if(InStr(strID, "StatusIconBuff") > -1)
	{
		StatusIcon = BufIcon;
	}
	if(InStr(strID, "StatusIconDeBuff") > -1)
	{
		StatusIcon = DebufIcon;
	}
	if(InStr(strID, "StatusIconSongDance") > -1)
	{
		StatusIcon = SongDanceIcon;
	}
	if(InStr(strID, "StatusIconItem") > -1)
	{
		StatusIcon = ItemIcon;
	}
	if(InStr(strID, "StatusIconTriggerSkill") > -1)
	{
		StatusIcon = TriggerSkillIcon;
	}


	StatusIcon.GetItem(row, col, info);
	
	// ID�� ������ ��ų�� ������ ���´�. ������ �й�
	if( !GetSkillInfo( info.ID.ClassID, info.Level , info.SubLevel, skillInfo ) )
	{
		//debug("ERROR - no skill info!!");
		return;
	}	
	
	if ( InStr( strID ,"StatusIconBuff" ) > -1 ||  InStr( strID ,"StatusIconDeBuff" ) > -1 ||  InStr( strID ,"StatusIconSongDance" ) > -1 || InStr( strID ,"StatusIconTriggerSkill" ) > -1 || InStr(strID,"StatusIconItem") > -1 )
	{
		if (skillInfo.Debuff == 0 && skillInfo.OperateType == 1)
		{	
			//Summon������ Update �̺�Ʈ�� info.ServerID�� ServerID�� ������ �δµ� Pet������ �׷� ó���� ����.
			RequestDispel(m_PetID, info.ID, info.Level, info.SubLevel);	
		}					//���� ��� ��û
		else												
		{	
			AddSystemMessage(2318);	
		}	//��ȭ ��ų�� ��쿡�� ���� ��Ұ� �����մϴ�. 
	}

}

// ���콺 ������ ��ư Ŭ��
function OnRButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect      rectWnd;
	local int		TargetID;	
	local string    userName;
	local UserInfo  targetUserInfo;

	rectWnd = Me.GetRect();
	
	//Ÿ��ID ������
	TargetID = m_PetID;

	if (TargetID > 0)
	{		
		if (X > rectWnd.nX && X < rectWnd.nX + rectWnd.nWidth) 
		{
			if (Y > rectWnd.nY && Y < rectWnd.nY + rectWnd.nHeight) 
			{
				// ���ؽ�Ʈ �޴� ������ ���� ���� save
				userName = class'UIDATA_USER'.static.GetUserName(TargetID);

				if (userName != "")	
				{
					if (GetTargetInfo(targetUserInfo))
					{
						// Debug("Ÿ���� �ִ� ����");
					}

					// �̹� Ÿ���� ������ �ʾҴٸ�..
					if (targetUserInfo.nID != TargetID) setTargetByServerID(TargetID);

					getInstanceContextMenu().execContextEvent(userName, TargetID, X, Y);
				}
			}
		}
	}
}

function int GetIndexByIsMagic(StatusIconInfo Info)
{
	local SkillInfo SkillInfo;

	if(! GetSkillInfo(Info.Id.ClassID,Info.Level,Info.SubLevel,SkillInfo))
	{
		return -1;
	}
	return SkillInfo.IsMagic;
}

defaultproperties
{
     MAX_BUFF_ICONTYPE=3
     m_WindowName="PetStatusWnd"
}
