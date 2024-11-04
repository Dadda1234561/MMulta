/************************************************************************************************************************
 * 
 * ���� ��ȯ ���� â 2�� ���� 
 * (�ִ� 4���� ���� ���η� �������� �Ѵ�)
 * 
 ************************************************************************************************************************/
class SummonedStatusWnd extends UICommonAPI;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  XML UI 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

const SUMMON_MAXCOUNT    = 4;  // �ִ� ��ȯ �� �� �ִ� ���� 
var int MAX_BUFF_ICONTYPE;  // �����ְ��� �ϴ� ���� ������ Ÿ�� ����

var WindowHandle Me;
var ButtonHandle btnBuff;
var WindowHandle SummonedStatusWnd1;
var WindowHandle SummonedStatusWnd2;
var WindowHandle SummonedStatusWnd3;
var WindowHandle SummonedStatusWnd4;

var NameCtrlHandle PetName;
var TextureHandle ClassIconSummon;
//var ButtonHandle btnBar;


var StatusIconHandle m_StatusIconBuff[SUMMON_MAXCOUNT];
var StatusIconHandle m_StatusIconDebuff[SUMMON_MAXCOUNT];
var StatusIconHandle m_StatusIconSongDance[SUMMON_MAXCOUNT];
var StatusIconHandle m_StatusIconTriggerSkill[SUMMON_MAXCOUNT];
var StatusIconHandle m_StatusIconItem[SUMMON_MAXCOUNT];

var int		m_TargetID, m_LastChangeColor;

var TextureHandle		m_IsDead[SUMMON_MAXCOUNT];


var string m_WindowName;
var StatusBarHandle barHP_1;
var StatusBarHandle barMP_1;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ���� ����
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var L2Util           util;
var int StatusWnd_SIZE_HEIGHT;
const NSTATUSICON_MAXCOL = 12;//���� ����

var int summonedServerID[SUMMON_MAXCOUNT];
//var string summonedBuff[SUMMON_MAXCOUNT];

var int m_CurBf ;

var bool m_IsSummonedStatusShowEvent;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// �ʱ�ȭ ���� 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnRegisterEvent()
{	
	RegisterEvent( EV_SummonedStatusShow );// ����â ������ (��ȯ)
	RegisterEvent( EV_SummonedStatusClose );// ��ȯ����
	RegisterEvent( EV_UpdateSummonInfo );// ��ȯ�� ���� ����
	RegisterEvent( EV_SummonedStatusSpelledList );// ��ȯ�� ���� ���� ����
	RegisterEvent( EV_SummonedStatusSpelledListDelete );// ��ȯ�� ���� ���� ����
	RegisterEvent( EV_SummonedStatusSpelledListInsert );// ��ȯ�� ���� ���� ����

	RegisterEvent( EV_SummonedDelete ); //��ȯ���� ����� ���
	RegisterEvent( EV_Restart ); //��ȯ���� ����� ���


	RegisterEvent( EV_UpdateHP ); //hp ������ ���� ��� 
	RegisterEvent( EV_UpdateMP ); //mp ������ ���� ��� 

	RegisterEvent( EV_TargetUpdate ); // Ÿ��, ���� �ؽ��ĸ� ���� �ֱ� ����
}

function OnLoad()
{
	// util �ʱ�ȭ 
	util = L2Util(GetScript("L2Util"));
	m_IsSummonedStatusShowEvent = false;

	Initialize();
	// End:0x45
	if(getInstanceUIData().getIsClassicServer())
	{
		StatusWnd_SIZE_HEIGHT = 54;
	}
	else
	{
		StatusWnd_SIZE_HEIGHT = 50;
	}	
}

function Initialize ()
{
	local int i;

	Me = GetWindowHandle(m_WindowName);
	btnBuff = GetButtonHandle(m_WindowName $ ".btnBuff");
	SummonedStatusWnd1 = GetWindowHandle(m_WindowName $ ".SummonedStatusWnd1");
	SummonedStatusWnd2 = GetWindowHandle(m_WindowName $ ".SummonedStatusWnd2");
	SummonedStatusWnd3 = GetWindowHandle(m_WindowName $ ".SummonedStatusWnd3");
	SummonedStatusWnd4 = GetWindowHandle(m_WindowName $ ".SummonedStatusWnd4");
	PetName = GetNameCtrlHandle(m_WindowName $ ".SummonedStatusWnd1.PetName");
	ClassIconSummon = GetTextureHandle(m_WindowName $ ".SummonedStatusWnd1.ClassIconSummon");
	barHP_1 = GetStatusBarHandle(m_WindowName $ ".SummonedStatusWnd1.barHP_1");
	barMP_1 = GetStatusBarHandle(m_WindowName $ ".SummonedStatusWnd1.barMP_1");

	for ( i = 0 ; i < SUMMON_MAXCOUNT ; i++ )
	{
		m_StatusIconBuff[i] = GetStatusIconHandle(m_WindowName $ ".SummonedStatusWnd" $ string(i + 1) $ ".StatusIconBuff" $ string(i + 1));
		m_StatusIconDeBuff[i] = GetStatusIconHandle(m_WindowName $ ".SummonedStatusWnd" $ string(i + 1) $ ".StatusIconDebuff" $ string(i + 1));
		m_StatusIconSongDance[i] = GetStatusIconHandle(m_WindowName $ ".SummonedStatusWnd" $ string(i + 1) $ ".StatusIconSongDance" $ string(i + 1));
		m_StatusIconItem[i] = GetStatusIconHandle(m_WindowName $ ".SummonedStatusWnd" $ string(i + 1) $ ".StatusIconItem" $ string(i + 1));
		m_StatusIconTriggerSkill[i] = GetStatusIconHandle(m_WindowName $ ".SummonedStatusWnd" $ string(i + 1) $ ".StatusIconTriggerSkill" $ string(i + 1));
		m_IsDead[i] = GetTextureHandle(m_WindowName $ ".SummonedStatusWnd" $ string(i + 1) $ ".IsDeadTexture");
	}
	initIsDeadTexture();
	clearBar();
	m_CurBf = 1;
	m_LastChangeColor = -1;
	m_targetID = -1;
	SetBuffButtonTooltip();
}

function OnEnterState (name a_CurrentStateName)
{
	if ( getInstanceUIData().getIsLiveServer() )
		EachServerEnterState(a_CurrentStateName);
}

function EachServerEnterState (name a_CurrentStateName)
{
	if(m_IsSummonedStatusShowEvent)
	{
		if (summonedServerID[0] != -1)
			Me.ShowWindow();
	}
	GetINIInt(m_WindowName,"a",m_CurBf,"WindowsInfo.ini");

	if (m_CurBf > MAX_BUFF_ICONTYPE)
	{
		m_CurBf = 0;
		SetINIInt(m_WindowName,"a",m_CurBf,"WindowsInfo.ini");
	}


	SetBuffButtonTooltip();
	UpdateBuff(0);
	UpdateBuff(1);
	UpdateBuff(2);
	UpdateBuff(3);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// �̺�Ʈ -> �ش� �̺�Ʈ ó�� �ڵ鷯
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnEvent (int Event_ID, string param)
{
	if ( getInstanceUIData().getIsLiveServer() )
	{
		EachServerEvent(Event_ID,param);
	}
}

function EachServerEvent (int Event_ID, string param)
{
	local int serverID;
	local int CurrentHP;
	local int CurrentMP;
	local int slotIndex;

	
	if (Event_ID == EV_UpdateHP ) //1100;
	{	
		ParseInt( param, "ServerID", serverID );
		ParseInt( param, "CurrentHP", CurrentHP );
		//Debug("EV_UpdateHP EventID" @ param);	
		if (serverID != 0)
		{
			slotIndex = GetIsSummonedSlotIndex( serverID ) ;//���� ������ �ֳ� Ȯ��.
			if ( slotIndex == -1 ) return ;

			setStatusBarHP( slotIndex, CurrentHP);
			
		}
		//Debug("OnEvent EV_UpdateHP");
	}
	else 

	if (Event_ID == EV_UpdateMP ) //1100;
	{
		ParseInt( param, "ServerID", serverID );
		ParseInt( param, "CurrentMP", CurrentMP );
		//Debug("EV_UpdateMP EventID" @ param);
		if (serverID != 0)
		{
			slotIndex = GetIsSummonedSlotIndex( serverID ) ;//���� ������ �ֳ� Ȯ��.
			if ( slotIndex == -1 ) return ;		

			setStatusBarMP( slotIndex, CurrentMP);
		}
		//Debug("OnEvent EV_UpdateMP");
	}
	else 
	
	if (Event_ID == EV_SummonedStatusShow) //1100;
	{	
		//Debug("OnEvent EV_SummonedStatusShow");
		if(GetGameStateName()!="GAMINGSTATE")
			return;

		HandleSummonedStatusShow();
	} 
	else if (Event_ID == EV_SummonedStatusClose) //ldw 1131 ��ȯ����
	{		
		HandleSummonedStatusClose();
	}
	else if (Event_ID == EV_UpdateSummonInfo )//ldw 251
	{		
		if(GetGameStateName()!="GAMINGSTATE")
			return;

		ParseInt( param, "ServerID", serverID );
		
		if (serverID != 0)
		{
			HandleSummonInfoUpdate(serverID);		
		}
	}
	else if (Event_ID == EV_SummonedStatusSpelledList ){ // 1110. ���� ����		
		HandleSummonedStatusSpelledList(param);
		//Debug("EV_SummonedStatusSpelledList");
	//	Debug( "Event : " $ Event_ID @ param);
	}	
	else if (Event_ID == EV_SummonedStatusSpelledListDelete ){ // 1110. ���� ����		
		HandleSummonedStatusSpelledListDelete(param);
		//Debug("EV_SummonedStatusSpelledList");
	//	Debug( "Event : " $ Event_ID @ param);
	}	
	else if (Event_ID == EV_SummonedStatusSpelledListInsert ){ // 1110. ���� ����		
		HandleSummonedStatusSpelledListInsert(param);
		//Debug("EV_SummonedStatusSpelledList");
		//Debug( "Event : " $ Event_ID @ param);
	}	
	else if (Event_ID == EV_SummonedDelete ){ //1132 ��ü ���� ��	
		HandleSummonedDelete(param);
		//Debug("EV_SummonedDelete");
		//Debug( "Event : " $ param);
	}
	else if (Event_ID == EV_Restart){
		reStart();
	}
	else if (Event_ID == EV_TargetUpdate){
		HandleCheckTarget();
	}
	
}

// Ÿ���� ���� ��Ƽ���̸� ���� ���� ��ȭ�� �ش�.
function HandleCheckTarget()
{
	local int idx;

	idx = -1;
	m_targetID = class'UIDATA_TARGET'.static.GetTargetID();
	if ( m_targetID > 0 )
		idx = GetIsSummonedSlotIndex(m_targetID);

	if ( getInstanceUIData().getIsLiveServer() )
	{
		// ������ ���� �ٲ��ذ� ������ �ٽ� ���� ����
		if ( m_LastChangeColor != -1 )
		{
			GetWindowHandle(m_WindowName $ ".SummonedStatusWnd" $ string(m_LastChangeColor + 1)).SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg");
			m_targetID = -1;
			m_LastChangeColor = -1;
		}

		if ( idx != -1 )
		{
			m_LastChangeColor = idx;
			GetWindowHandle(m_WindowName $ ".SummonedStatusWnd" $ string(idx + 1)).SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Over");
		}
	}
	else if ( m_LastChangeColor != -1 )
    {
		GetWindowHandle(m_WindowName $ ".SummonedStatusWnd" $ string(m_LastChangeColor + 1)).SetBackTexture("L2UI_NewTex.Windows.PartyWndBG");
		m_targetID = -1;
		m_LastChangeColor = -1;
    }

    if ( idx != -1 )
    {
		m_LastChangeColor = idx;
		GetWindowHandle(m_WindowName $ ".SummonedStatusWnd" $ string(idx + 1)).SetBackTexture("L2UI_NewTex.PartyWndBG_OverClassic");
    }
}

////ID�� ���° ǥ�õǴ� ��Ƽ������ ���Ѵ�
//function int FindSummonID(int ID)
//{
//	local int idx;

//	for (idx=0; idx < SUMMON_MAXCOUNT; idx++)
//	{
//		if (summonedServerID[idx] == ID)
//		{
//			return idx;
//		}
//	}

//	return -1;
//}


function reStart(){
	local int i;
	for(i=0 ; i < SUMMON_MAXCOUNT ; i++){
		summonedServerID[i] = -1;
	}
	initIsDeadTexture();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Ŭ�� �̺�Ʈ
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnClickButtonWithHandle( ButtonHandle a_ButtonHandle )
{
	local string btnName;

	btnName = a_ButtonHandle.GetWindowName();

	//Debug("OnClickButtonWithHandle : "$btnName);

	switch (btnName)
	{

		/*case "btnBar":
			setTargetSummon(a_ButtonHandle);
			break;*/
		case "btnBuff":
			OnBuffButton();
			break;	
	}
}

function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect rectWnd;
	local UserInfo userinfo;
	local int serverID;
	local int num;
	local string WindowName;
	local WindowHandle hParent;
	
	rectWnd = Me.GetRect();	
	if (X > rectWnd.nX + 14 && X < rectWnd.nX + rectWnd.nWidth -20)//�������� ��ȯ ��ư�� ������ �� ���� ������ �ʵ��� ��
	{
		WindowName = a_WindowHandle.GetWindowName();
		if ( WindowName != "")
		{
			if( left(WindowName,Len(m_WindowName)) != m_WindowName )
			{
				hParent = a_WindowHandle.GetParentWindowHandle();
				WindowName = hParent.GetWindowName();					
			}
			num = Int(Right(WindowName, 1)) - 1 ;
			serverID = summonedServerID[num];

			if (serverID != -1)
			{				
				if (GetPlayerInfo(userinfo))
				{					
					RequestAction(serverID, userinfo.Loc);
				}	

				// Debug("OnLButtonDown");

			} 	
		}
	}
}

function OnClickButton( string Name)
{
	// End:0x25
	if(Name == "btnSummonWndClassic")
	{
		ToggleSummonedClassic();
	}
}

function ToggleSummonedClassic()
{
	local WindowHandle summonedWndClassicWnd;

	summonedWndClassicWnd = GetWindowHandle("SummonedWndClassic");
	// End:0x44
	if(summonedWndClassicWnd.IsShowWindow())
	{
		summonedWndClassicWnd.HideWindow();		
	}
	else
	{
		summonedWndClassicWnd.ShowWindow();
		summonedWndClassicWnd.SetFocus();
	}
}

function HandleSummonedDelete (string param){
	
	local int serverID;
	local int curreSlotIndex;
	local int firstSlotIndex;	

	ParseInt(param, "serverID", serverID);
	curreSlotIndex = GetIsSummonedSlotIndex( serverID ) ;//���� ������ �ֳ� Ȯ��.
	//debug("HandleSummonedDelete curreSlotIndex" @ curreSlotIndex);

	if( curreSlotIndex >-1 ){// ���� ������ �ִٸ�
		firstSlotIndex = getSummonedSlotIndex();	 //ù �� ���� ����
		//Debug ("HandleSummonedDelete firstSlotIndex" @ firstSlotIndex );
		if(firstSlotIndex > 1){// �� ������ 1���� ũ�ٸ� (1 ���ϴ� ��ȯ ������ �ذ�)
			delStatus( curreSlotIndex, firstSlotIndex); // ���� �� �ű��
			reSizeWindow(firstSlotIndex - 1 );//������ ũ�� ����
		} else { summonedServerID[curreSlotIndex] = -1;//��ư ���� ������ ����;
		}
	}	
	
	/*for ( i = 0 ; i < SUMMON_MAXCOUNT ; i++ ) {
		Debug ("summonedServerID" @ summonedServerID[i]);
	}*/

}



function HandleSummonedStatusClose()
{	
	m_IsSummonedStatusShowEvent = false;
	m_TargetID	 = -1;
	m_LastChangeColor = -1;
	clearBar();
	Me.HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	initIsDeadTexture();
}

function initIsDeadTexture()
{
	local int i;
	for (i= 0 ; i < SUMMON_MAXCOUNT ; i++ )
	{
		m_IsDead[i].hideWindow();
	}
}

function HandleSummonedStatusShow()
{
	m_IsSummonedStatusShowEvent = true;
	Me.ShowWindow();
}

function int GetIsSummonedSlotIndex(int ServerID){ //���� ���� �Ƶ� �ִ� ��ȣ�� ����
	local int i;
	for (i= 0 ; i < SUMMON_MAXCOUNT ; i++ )
		if(summonedServerID[i] == ServerID){
			return i;
		}	
	return -1;
}

function int getSummonedSlotIndex(){ // ù ��° �� ���� ��ȣ�� ����
	local int i;
	for (i = 0 ; i < SUMMON_MAXCOUNT ; i++ ){
		if( summonedServerID[i] == -1 ){	
			return i;
		}
	}
	return SUMMON_MAXCOUNT;// �� ���� ��� ������ ��ȣ��.
}

function clearBar(){
	local int i;
	for (i = 0 ; i < SUMMON_MAXCOUNT ; i++ )
	{
	    GetWindowHandle(m_WindowName $ ".SummonedStatusWnd" $ (i + 1)).HideWindow();
		summonedServerID[i] = -1;
		//summonedBuff[i] = "";
	}
}

//////////////////////////////////////////////////////////////////���� ///////////////////////////////////////////////////////////////////////



//��ȯ���� ���� ����Ʈ ����
function HandleSummonedStatusSpelledList(string param)
{
	//~ local int i;
	//~ local int Max, ID;

	local int curreSlotIndex; //���� ����// �߰� 

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

	/*
	local StatusIconHandle	m_StatusIconBuff;
	local StatusIconHandle	m_StatusIconDeBuff;
	local StatusIconHandle	m_StatusIconSongDance;
	local StatusIconHandle	m_StatusIconTriggerSkill;
*/
	local StatusIconInfo info;
//	local int       tmpNum ;
	ParseInt( param, "ID", ID);

	curreSlotIndex = GetIsSummonedSlotIndex( ID );//�߰�

//	summonedBuff[curreSlotIndex] = param;

	//~ CurRow = -1;

	DeBuffCurRow = -1;//�� ������ �ι�° �� ���� ����
	BuffCurRow = -1;
	SongDanceCurRow = -1;
	ItemCurRow = -1;
	TriggerSkillCurRow = -1;

	ParseInt(param, "ID", ID);
	info.ServerID = ID;
	
	if (curreSlotIndex < 0 ) // �� ���� ������������ Ȯ���ϰ�, �ƴϸ� �ݻ� 
	{
		return;
	}	

	/*
	tmpNum = curreSlotIndex + 1;
	m_StatusIconBuff = GetStatusIconHandle( "SummonedStatusWnd.SummonedStatusWnd" $ tmpNum $ ".StatusIconBuff" $ tmpNum );
	m_StatusIconDeBuff = GetStatusIconHandle( "SummonedStatusWnd.SummonedStatusWnd" $ tmpNum $ ".StatusIconDebuff" $ tmpNum );
	m_StatusIconSongDance = GetStatusIconHandle( "SummonedStatusWnd.SummonedStatusWnd" $ tmpNum $ ".StatusIconSongDance" $ tmpNum );
	m_StatusIconTriggerSkill = GetStatusIconHandle( "SummonedStatusWnd.SummonedStatusWnd" $ tmpNum $ ".StatusIconTriggerSkill" $ tmpNum );
*/	
	m_StatusIconBuff[curreSlotIndex].Clear();
	m_StatusIconDeBuff[curreSlotIndex].Clear();
	m_StatusIconSongDance[curreSlotIndex].Clear();
	m_StatusIconItem[curreSlotIndex].Clear();
	m_StatusIconTriggerSkill[curreSlotIndex].Clear();

	//info �ʱ�ȭ
	info.Size = 16;
	info.bShow = true; 

	ParseInt(param, "Max", Max);

	//Debug("Max" @ Max);

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

		ParseInt(param, "SpellerID_" $ i, info.SpellerID);

		if (IsValidItemID(info.ID))
		{		
			
			info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, info.Level, info.SubLevel);
			info.IconPanel = class'UIDATA_SKILL'.static.GetIconPanel(info.Id,info.Level,info.SubLevel);
			info.bHideRemainTime = true;

			if (GetDebuffType( info.ID, info.Level, info.SubLevel) != 0 )
			{
				//if (DeBuffCnt < NSTATUSICON_MAXCOL ){
					if (DeBuffCnt == 0)
					{
					  DeBuffCurRow ++;					  
					  m_StatusIconDeBuff[curreSlotIndex].AddRow();					  
					}
					m_StatusIconDeBuff[curreSlotIndex].AddCol(DeBuffCurRow, info);
					DeBuffCnt++;
				//}
			}
			else if ( GetIndexByIsMagic(Info) == 3 )
			{
				if ( SongDanceCnt == 0 )
				{
					SongDanceCurRow++;
					m_StatusIconSongDance[curreSlotIndex].AddRow();
				}
				m_StatusIconSongDance[curreSlotIndex].AddCol(SongDanceCurRow,Info);
				SongDanceCnt++;
			}
			else if ( GetIndexByIsMagic(Info) == 4 )
			{
				if ( ItemCnt == 0 )
				{
					ItemCurRow++;
					m_StatusIconItem[curreSlotIndex].AddRow();
				}
				m_StatusIconItem[curreSlotIndex].AddCol(ItemCurRow,Info);
				ItemCnt++;
			}
			else if ( GetIndexByIsMagic(Info) == 5 )
			{
				if ( TriggerSkillCnt == 0 )
				{
					TriggerSkillCurRow++;
					m_StatusIconTriggerSkill[curreSlotIndex].AddRow();
				}
				m_StatusIconTriggerSkill[curreSlotIndex].AddCol(TriggerSkillCurRow,Info);
				TriggerSkillCnt++;
			}
			else
			{
				if ( BuffCnt % NSTATUSICON_MAXCOL == 0 )
				{
					BuffCurRow++;
					m_StatusIconBuff[curreSlotIndex].AddRow();
				}
				m_StatusIconBuff[curreSlotIndex].AddCol(BuffCurRow,Info);
				BuffCnt++;
			}
		}
	}
	UpdateBuff(curreSlotIndex);	
}

//��������Ʈ����
function HandleSummonedStatusSpelledListDelete(string param)
{
	local int i;	
	local int ID;
	local int Max;		
	local StatusIconInfo info;	
	local int curreSlotIndex; //���� ����// �߰� 

	ParseInt(param, "ID", ID);

	curreSlotIndex = GetIsSummonedSlotIndex( ID );//�߰�

//	summonedBuff[curreSlotIndex] = param;

	if (curreSlotIndex < 0 ) // �� ���� ������������ Ȯ���ϰ�, �ƴϸ� �ݻ� 
	{
		return;
	}
	info.ServerID = ID;		
	ParseInt(param, "Max", Max);

	for (i=0; i<Max; i++)
	{
		//���� ������ �˱� ���� ID, Level
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "Level_" $ i, info.Level);
		ParseInt(param, "SubLevel_" $ i, info.SubLevel);

		ParseInt(param, "SpellerID_" $ i, info.SpellerID);
		
		if (IsValidItemID(info.ID))
		{	
			//������̸� 
			if (GetDebuffType( info.ID, info.Level, info.SubLevel ) != 0 )
			{
				deleteBuff( m_StatusIconDeBuff[curreSlotIndex], info.Level, info.ID.ClassID, info.SpellerID );											
			}
			//�۴�
			else if ( GetIndexByIsMagic(Info) == 3 )
			{	
				deleteBuff( m_StatusIconSongDance[curreSlotIndex], info.Level, info.ID.ClassID, info.SpellerID );
			}
			//IsTriggerSkill
			else if ( GetIndexByIsMagic(Info) == 4 )
			{		
				deleteBuff(m_StatusIconItem[curreSlotIndex],Info.Level,Info.Id.ClassID,Info.SpellerID);
			}
			else if ( GetIndexByIsMagic(Info) == 5 )
            {
				deleteBuff(m_StatusIconTriggerSkill[curreSlotIndex],Info.Level,Info.Id.ClassID,Info.SpellerID);
            }
			else
			{
				deleteBuff(m_StatusIconBuff[curreSlotIndex],Info.Level,Info.Id.ClassID,Info.SpellerID);
            }	
		}
	}
	UpdateBuff( curreSlotIndex );
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


function copySpelledList(int fromIndex, int toIndex )
{	
	local int row;
	local int col;	
	local StatusIconInfo info;
	
	m_StatusIconDeBuff[toIndex].clear();
	for ( row = 0; row < m_StatusIconDeBuff[fromIndex].GetRowCount() ; row++ )
	{
		m_StatusIconDeBuff[toIndex].addRow();
		for ( col = 0 ; col < m_StatusIconDeBuff[fromIndex].GetColCount(row); col++ )
		{
			m_StatusIconDeBuff[fromIndex].GetItem(row, col, info);
			m_StatusIconDeBuff[toIndex].AddCol(row, info);
		}
	}

	m_StatusIconSongDance[toIndex].clear();
	for ( row = 0; row < m_StatusIconSongDance[fromIndex].GetRowCount() ; row++ )
	{
		m_StatusIconSongDance[toIndex].addRow();
		for ( col = 0 ; col < m_StatusIconSongDance[fromIndex].GetColCount(row); col++ )
		{
			m_StatusIconSongDance[fromIndex].GetItem(row, col, info);
			m_StatusIconSongDance[toIndex].AddCol(row, info);
		}
	}
	
	m_StatusIconItem[toIndex].Clear();
	
	for ( Row = 0;Row < m_StatusIconItem[fromIndex].GetRowCount();Row++ )
	{
		m_StatusIconItem[toIndex].AddRow();
		
		for ( Col = 0;Col < m_StatusIconItem[fromIndex].GetColCount(Row);Col++ )
		{
			m_StatusIconItem[fromIndex].GetItem(Row,Col,Info);
			m_StatusIconItem[toIndex].AddCol(Row,Info);
		}
	}

	m_StatusIconTriggerSkill[toIndex].clear();
	for ( row = 0; row < m_StatusIconTriggerSkill[fromIndex].GetRowCount() ; row++ )
	{
		m_StatusIconTriggerSkill[toIndex].addRow();
		for ( col = 0 ; col < m_StatusIconTriggerSkill[fromIndex].GetColCount(row); col++ )
		{
			m_StatusIconTriggerSkill[fromIndex].GetItem(row, col, info);
			m_StatusIconTriggerSkill[toIndex].AddCol(row, info);
		}
	}

	m_StatusIconBuff[toIndex].clear();
	for ( row = 0; row < m_StatusIconBuff[fromIndex].GetRowCount() ; row++ )
	{
		m_StatusIconBuff[toIndex].addRow();
		for ( col = 0 ; col < m_StatusIconBuff[fromIndex].GetColCount(row); col++ )
		{
			m_StatusIconBuff[fromIndex].GetItem(row, col, info);
			m_StatusIconBuff[toIndex].AddCol(row, info);
		}
	}
}

//��������Ʈ�߰�
function HandleSummonedStatusSpelledListInsert(string param)
{
	local int i;		
	local int ID;
	local int Max;

	local StatusIconInfo info;
	local StatusIconHandle tmpStatusIcon;

	local int curreSlotIndex; //���� ����// �߰� 

	

	ParseInt(param, "ID", ID);

	curreSlotIndex = GetIsSummonedSlotIndex( ID );//�߰�

//	summonedBuff[curreSlotIndex] = param;
	
	if (curreSlotIndex < 0 ) // �� ���� ������������ Ȯ���ϰ�, �ƴϸ� �ݻ� 
	{
		return;
	}	

	info.ServerID = ID;		
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

		ParseInt(param, "SpellerID_" $ i, info.SpellerID);


		info.bHideRemainTime = true;

		if (IsValidItemID(info.ID))
		{	
			info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, info.Level, info.SubLevel);
			info.IconPanel = class'UIDATA_SKILL'.static.GetIconPanel(info.Id,info.Level,info.SubLevel);

			//������̸� 
			if (GetDebuffType( info.ID, info.Level, info.SubLevel) != 0 )
			{
				tmpStatusIcon = m_StatusIconDeBuff[curreSlotIndex];								
			}
			//�۴�
			else if ( GetIndexByIsMagic(Info) == 3 )
			{	
				tmpStatusIcon = m_StatusIconSongDance[curreSlotIndex];
			}
			else if ( GetIndexByIsMagic(Info) == 4 )
			{
				tmpStatusIcon = m_StatusIconItem[curreSlotIndex];
			}
			else if ( GetIndexByIsMagic(Info) == 5 )
			{
				tmpStatusIcon = m_StatusIconTriggerSkill[curreSlotIndex];
			}
			else
			{
				tmpStatusIcon = m_StatusIconBuff[curreSlotIndex];
			}
			//�߰� �κ�				
			if ( tmpStatusIcon.GetRowCount() == 0 || tmpStatusIcon.GetColCount( tmpStatusIcon.GetRowCount() -1 ) % NSTATUSICON_MAXCOL == 0 )
			{				
				tmpStatusIcon.AddRow();
			}
			tmpStatusIcon.AddCol( tmpStatusIcon.GetRowCount() -1 , info);
		}
	}

	UpdateBuff( curreSlotIndex );
}

// ��������� ǥ��,  �۴� , ���� ,�ߵ� ��ų 4������带 ��ȯ�Ѵ�.
function UpdateBuff(int curreSlotIndex)
{
	/*
	local StatusIconHandle	m_StatusIconBuff;
	local StatusIconHandle	m_StatusIconDeBuff;
	local StatusIconHandle	m_StatusIconSongDance;
	local StatusIconHandle	m_StatusIconTriggerSkill;
	local int               tmpNum ;
	
	tmpNum = curreSlotIndex + 1;
	m_StatusIconBuff = GetStatusIconHandle( "SummonedStatusWnd.SummonedStatusWnd" $ tmpNum $ ".StatusIconBuff" $ tmpNum );
	m_StatusIconDeBuff = GetStatusIconHandle( "SummonedStatusWnd.SummonedStatusWnd" $ tmpNum $ ".StatusIconDebuff" $ tmpNum  );
	m_StatusIconSongDance = GetStatusIconHandle( "SummonedStatusWnd.SummonedStatusWnd" $ tmpNum $ ".StatusIconSongDance" $ tmpNum );
	m_StatusIconTriggerSkill = GetStatusIconHandle( "SummonedStatusWnd.SummonedStatusWnd" $ tmpNum $ ".StatusIconTriggerSkill" $ tmpNum );
*/
	// �Ϲ� ����/�����
	if (m_CurBf == 1)
	{
		// ���� , ����� ���� �ش�.
		m_StatusIconBuff[curreSlotIndex].ShowWindow(); 
		m_StatusIconDeBuff[curreSlotIndex].ShowWindow(); 
		m_StatusIconSongDance[curreSlotIndex].HideWindow();
		m_StatusIconItem[curreSlotIndex].HideWindow();
		m_StatusIconTriggerSkill[curreSlotIndex].HideWindow(); 
	}
	// �۴�
	else if (m_CurBf == 2)
	{
		m_StatusIconBuff[curreSlotIndex].HideWindow(); 
		m_StatusIconDeBuff[curreSlotIndex].HideWindow(); 
		m_StatusIconSongDance[curreSlotIndex].ShowWindow();
		m_StatusIconItem[curreSlotIndex].HideWindow();
		m_StatusIconTriggerSkill[curreSlotIndex].HideWindow();
	}
	// Ư�� �̻���� 
	else if ( m_CurBf == 3 )
	{
		m_StatusIconBuff[curreSlotIndex].HideWindow(); 
		m_StatusIconDeBuff[curreSlotIndex].HideWindow(); 
		m_StatusIconSongDance[curreSlotIndex].HideWindow();
		m_StatusIconItem[curreSlotIndex].ShowWindow();
		m_StatusIconTriggerSkill[curreSlotIndex].HideWindow();
	}
	else if ( m_CurBf == 4 )
	{
		m_StatusIconBuff[curreSlotIndex].HideWindow();
		m_StatusIconDeBuff[curreSlotIndex].HideWindow();
		m_StatusIconSongDance[curreSlotIndex].HideWindow();
		m_StatusIconItem[curreSlotIndex].HideWindow();
		m_StatusIconTriggerSkill[curreSlotIndex].ShowWindow();
	}
	else
	{
		m_StatusIconBuff[curreSlotIndex].HideWindow();
		m_StatusIconDeBuff[curreSlotIndex].HideWindow();
		m_StatusIconSongDance[curreSlotIndex].HideWindow();
		m_StatusIconItem[curreSlotIndex].HideWindow();
		m_StatusIconTriggerSkill[curreSlotIndex].HideWindow();
	}
 //m_bBuff = bShow;
}



//���������� ǥ��
function HandleShowBuffIcon(string param)
{
	local int nShow;
	ParseInt(param, "Show", nShow);
	if (nShow==1)
	{
		//~ UpdateBuff(true);
		UpdateBuff(0);
		UpdateBuff(1);
		UpdateBuff(2);
		UpdateBuff(3);
	}
	else
	{
		//~ UpdateBuff(false);
		UpdateBuff(0);
		UpdateBuff(1);
		UpdateBuff(2);
		UpdateBuff(3);

	}
}

/*function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect rectWnd;
	local UserInfo userinfo;

	rectWnd = Me.GetRect();
	if (X > rectWnd.nX + 13 && X < rectWnd.nX + rectWnd.nWidth -10)
	{
		if (GetPlayerInfo(userinfo))
		{
			RequestAction(m_PetID, userinfo.Loc);
		}
	}
}*/

//function OnBuffButton()
//{
//	//Debug("OnBuffButton");
//	m_CurBf = m_CurBf + 1;

//	// 2009.10.01 ����: ������ ����, �����, �̻���� ����, ��/�� 4���� ����. 
//	// (����/�����) �̻���� ����, ��/�� ����, �̻���� ����
//	// 3���� ��尡 ��ȯ�ȴ�.
//	if (m_CurBf > 3)
//	{
//		m_CurBf = 0;
//	}
	
//	SetINIInt ( "SummonedStatusWnd", "a", m_CurBf, "WindowsInfo.ini") ;
//	SetBuffButtonTooltip();
//	UpdateBuff(0);
//	UpdateBuff(1);
//	UpdateBuff(2);
//	UpdateBuff(3);
//}

// ������ư�� ������ ��� ����Ǵ� �Լ�
function OnBuffButton()
{
	m_CurBf = m_CurBf + 1;

	//3���� ��尡 ��ȯ�ȴ�.
	if (m_CurBf > MAX_BUFF_ICONTYPE)
	{
		m_CurBf = 0;
	}

	SetINIInt(m_WindowName,"a",m_CurBf,"WindowsInfo.ini");

	SetBuffButtonTooltip();
	UpdateBuff(0);
	UpdateBuff(1);
	UpdateBuff(2);
	UpdateBuff(3);
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
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1741), b2, "", true, true); // �ó���/��/�� ����
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2307), b3, "", true, true); // Ư�� �̻���� ����
	btnBuff.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}


//// ���� ������ �����Ѵ�.
//function SetBuffButtonTooltip()
//{
//	local int idx;

//	 //stringID=1496 string=[��������] 
//	 //stringID=1497 string=[���������] 
//	 //stringID=1498 string=[�̻���� ����] 
//	 //stringID=1741 string=[��/�� ����] 
//	 switch (m_CurBf)
//	 {
//		case 0: idx = 2221; // 1496;  // ��������� ���� -> �̻���� ���� 2221 
//			break;
//		//case 1: idx = 1497; break; // ���� �ȴ�. 
//		case 1: idx = 1741;
//			break;
//		case 2: idx = 2307;
//			break;
//		// ���Ŀ� �ٲ���� ��.
//		case 3: idx = 1498;
//			break;
//	}
//	btnBuff.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(idx)));
//}


////////////////////////////////////////////////////////////���� ��//////////////////////////////////////////////////////////////////////////


function HandleSummonInfoUpdate(int serverID) // ���� ����
{			
	local SummonInfo info;
	local int slotIndex; //����	

	if (GetSummonInfo(serverID, info)){
		slotIndex = GetIsSummonedSlotIndex( serverID ) ;//���� ������ �ֳ� Ȯ��.
		if ( slotIndex == -1 ) { //���� ������ ������ ���� ����
			slotIndex = getSummonedSlotIndex();	 //ù �� ���� ����
			inputStatus(slotIndex, serverID);
			reSizeWindow(slotIndex + 1);//ũ��

			//m_IsDead[slotIndex].hideWindow();
		}
		setStatusBar(slotIndex);
	}			
}


/*
function HandleSummonInfoUpdate(int serverID) // ���� ���� ����
{		
	local int		HP;	
	local SummonInfo info;

	local int curreSlotIndex; //���� ����
	local int firstSlotIndex; //ù �� ����
	if (GetSummonInfo(serverID, info)){

		HP    = info.nCurHP;
		curreSlotIndex = GetIsSummonedSlotIndex( serverID ) ;//���� ������ �ֳ� Ȯ��.
		firstSlotIndex = getSummonedSlotIndex();	 //ù �� ���� ����
			
		if ( curreSlotIndex > -1) //���� ������ �ִ� ���
		{
			setStatusBar(curreSlotIndex);//��� 0�� �Ǵ� �� ������.
			if( HP == 0 ) // HP �� 0�� ���
			{
				if(firstSlotIndex > 1){
					delStatus( curreSlotIndex, firstSlotIndex);
					reSizeWindow(firstSlotIndex - 1 );//�۰�
				}
			}
		} 
		else if(firstSlotIndex > -1 ) //�� ������ �ִ� ���
		{
			if( HP > 0 ) // HP �� 0�� ���
			{ 
				inputStatus(firstSlotIndex, serverID);
				reSizeWindow(firstSlotIndex + 1);//ũ��
				setStatusBar(firstSlotIndex);
			}
		}
	}			
}
*/

function delStatus(int slotIndex, int firstSlotIndex ){
	local int i;
	//local int j;
	//j=0;
	//Debug("step" $ (j++));
	for ( i = slotIndex  ; i < firstSlotIndex - 1  ; i++){
		//Debug( slotIndex $ " to " $ firstSlotIndex);
		summonedServerID[i] = summonedServerID[i+1];
		//summonedBuff[i] = summonedBuff[i+1];//���� �ű��

		copySpelledList( i+1 , i);
		//Debug("step" $ (j++) $ i);
		setStatusBar(i);
		//HandleSummonedStatusSpelledList(summonedBuff[i]);
		
		//Debug("step" $ (j++) $ i );
	}
	//Debug("step" $ (j++));
	GetWindowHandle(m_WindowName $ ".SummonedStatusWnd" $ string(firstSlotIndex)).HideWindow();
	//Debug("step" $ (j++));
	summonedServerID[firstSlotIndex-1] = -1;
	//summonedBuff[firstSlotIndex-1] = "";
	//clearBuff(firstSlotIndex-1);
	//Debug("step" $ (j++));
}

/*function clearBuff(int slotIndex){
	
	local StatusIconHandle	m_StatusIconBuff;
	local StatusIconHandle	m_StatusIconDeBuff;
	local StatusIconHandle	m_StatusIconSongDance;
	local StatusIconHandle	m_StatusIconTriggerSkill;
	m_StatusIconBuff = GetStatusIconHandle( "SummonedStatusWnd.SummonedStatusWnd" $ slotIndex + 1 $ ".StatusIconBuff" );
	m_StatusIconDeBuff = GetStatusIconHandle( "SummonedStatusWnd.SummonedStatusWnd" $ slotIndex + 1 $ ".StatusIconDebuff" );
	m_StatusIconSongDance = GetStatusIconHandle( "SummonedStatusWnd.SummonedStatusWnd" $ slotIndex + 1 $ ".StatusIconSongDance" );
	m_StatusIconTriggerSkill = GetStatusIconHandle( "SummonedStatusWnd.SummonedStatusWnd" $ slotIndex + 1 $ ".StatusIconTriggerSkill" );
	m_StatusIconBuff.Clear();
	m_StatusIconDeBuff.Clear();
	m_StatusIconSongDance.Clear();
	m_StatusIconTriggerSkill.Clear();
}*/

function reSizeWindow(int firstSlotIndex){
	local int w;
	local int h;	
	local int h2;	
	
	//rectWnd = Me.GetRect();
	//w = rectWnd.nWidth;
	h2 = MeHeight(firstSlotIndex);
	Me.GetWindowSize( w , h );//wide�� ������ ��� ��.
	Me.SetWindowSize( w, h2 );
	// End:0x6F
	if(getInstanceUIData().getIsClassicServer())
	{
		Me.SetResizeFrameSize(14, h2);		
	}
	else
	{
		Me.SetResizeFrameSize(10, h2);
	}
}
function int MeHeight(int slotIndex){
	return StatusWnd_SIZE_HEIGHT*(slotIndex);
}

function inputStatus(int slotIndex, int serverID){
	summonedServerID[slotIndex] = serverID;	
	GetWindowHandle(m_WindowName $ ".SummonedStatusWnd" $ string(SlotIndex + 1)).ShowWindow();
}

function setStatusBar(int slotIndex)
{
	local int serverID;	
	local SummonInfo info;

	local int		HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;
	local string    name;

	serverID = summonedServerID[slotIndex];

	if (GetSummonInfo(serverID, info))
	{
		HP    = info.nCurHP;
		MaxHP = info.nMaxHP;
		MP    = info.nCurMP;
		MaxMP = info.nMaxMP;
		name  = info.Name;// $ (slotIndex+1);

		GetNameCtrlHandle(m_WindowName $ ".SummonedStatusWnd" $ string(SlotIndex + 1) $ ".PetName").SetName(Name,NCT_Normal,TA_Left);
		GetStatusBarHandle(m_WindowName $ ".SummonedStatusWnd" $ string(SlotIndex + 1) $ ".barHP_1").SetPoint(HP,MaxHP);
		GetStatusBarHandle(m_WindowName $ ".SummonedStatusWnd" $ string(SlotIndex + 1) $ ".barMP_1").SetPoint(MP,maxMP);
 
		if (HP <= 0)
		{
			m_IsDead[slotIndex].ShowWindow();
		}
		else
		{
			m_IsDead[slotIndex].HideWindow();
		}		
	}
}

function setStatusBarHP(int slotIndex, int curHP ) 
{
	local int serverID;	
	local SummonInfo info;
	local int		MaxHP;	

	serverID = summonedServerID[slotIndex];

	if (GetSummonInfo(serverID, info))
	{		
		MaxHP = info.nMaxHP;
		GetStatusBarHandle(m_WindowName $ ".SummonedStatusWnd" $ m_WindowName $ string(SlotIndex + 1) $ ".barHP_1").SetPoint(CurHP,MaxHP);
 
		if (curHP <= 0)
		{
			m_IsDead[slotIndex].ShowWindow();
		}
		else
		{
			m_IsDead[slotIndex].HideWindow();
		}		
	}
}

function setStatusBarMP(int slotIndex, int curMP ) 
{
	local int serverID;	
	local SummonInfo info;
	local int		MaxMP;	

	serverID = summonedServerID[slotIndex];

	if (GetSummonInfo(serverID, info)){		
		MaxMP = info.nMaxMP;
		GetStatusBarHandle(m_WindowName $ ".SummonedStatusWnd" $ string(SlotIndex + 1) $ ".barMP_1").SetPoint(curMP,maxMP);
	}
}


function OnClickItem( string strID, int index )
{	
	local int row;
	local int col;
	local StatusIconInfo info;
	local SkillInfo skillInfo;		// ��ų ����. ������ų���� Ȯ���ؾ� �ϴϱ�
	local StatusIconHandle  StatusIcon;
	local string  tmpNum;
	//local string  tmpWindowName;

	col = index / 10;
	row = index - (col * 10);
	
	tmpNum = Right (strID , 1);
	
	StatusIcon = GetStatusIconHandle(m_WindowName $ ".SummonedStatusWnd" $ tmpNum $ "." $ strID);
 
	StatusIcon.GetItem(row, col, info);
	
	// ID�� ������ ��ų�� ������ ���´�. ������ �й�
	if( !GetSkillInfo( info.ID.ClassID, info.Level ,info.SubLevel, skillInfo ) )
	{
		//debug("ERROR - no skill info!!");
		return;
	}
	
	if ( InStr( strID ,"StatusIconBuff" $ tmpNum ) > -1 ||  InStr( strID ,"StatusIconDeBuff" $ tmpNum ) > -1 ||  InStr( strID ,"StatusIconSongDance" $ tmpNum) > -1 || InStr( strID ,"StatusIconTriggerSkill" $ tmpNum ) > -1) 
	{
		if (skillInfo.Debuff == 0 && skillInfo.OperateType == 1) 		
		{	
			RequestDispel(info.ServerID, info.ID, info.Level, info.SubLevel);	
		}					//���� ��� ��û
		else
		{	
			AddSystemMessage(2318);
		}	//��ȭ ��ų�� ��쿡�� ���� ��Ұ� �����մϴ�. 
	}

	//Debug("OnClickItem..");
}

// ���콺 ������ ��ư Ŭ��
function OnRButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect      rectWnd;
	local string    userName;

	local UserInfo targetUserInfo;
	local int serverID;
	local int num;
	local string WindowName;
	local WindowHandle hParent;
	
	rectWnd = Me.GetRect();	

	if (X > rectWnd.nX && X < rectWnd.nX + rectWnd.nWidth) 
	{
		if (Y > rectWnd.nY && Y < rectWnd.nY + rectWnd.nHeight) 
		{
			WindowName = a_WindowHandle.GetWindowName();
			if ( WindowName != "")
			{			
				if ( left(WindowName,Len(m_WindowName)) != m_WindowName )
				{								
					hParent = a_WindowHandle.GetParentWindowHandle();
					WindowName = hParent.GetWindowName();					
				}
				num = Int(Right(WindowName, 1)) - 1 ;
				serverID = summonedServerID[num];
			}
			if (serverID > 0)
			{	
				// ���ؽ�Ʈ �޴� ������ ���� ���� save
				userName = class'UIDATA_USER'.static.GetUserName(serverID);

				if (userName != "")	
				{
					if (GetTargetInfo(targetUserInfo))
					{
						// Debug("Ÿ���� �ִ� ����");
					}
					if (targetUserInfo.nID != serverID) setTargetByServerID(serverID);
					getInstanceContextMenu().execContextEvent(userName, serverID, X, Y);				
				}

				//Debug("�� Ŭ�� " @ userName);
			}
		}
	}	
}

function int GetIndexByIsMagic (StatusIconInfo Info)
{
	local SkillInfo SkillInfo;

	if (  !GetSkillInfo(Info.Id.ClassID,Info.Level,Info.SubLevel,SkillInfo) )
	{
		return -1;
	}
	return SkillInfo.IsMagic;
}

defaultproperties
{
     MAX_BUFF_ICONTYPE=3
     m_WindowName="SummonedStatusWnd"
}
