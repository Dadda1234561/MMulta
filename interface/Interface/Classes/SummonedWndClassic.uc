/************************************************************************************************************************
 * 
 * ���� ��ȯ ��Ʈ�� ������ 
 * 
 ************************************************************************************************************************/
class SummonedWndClassic extends UICommonAPI;

var WindowHandle Me;
var WindowHandle SummonedWnd_Status;
var TextBoxHandle txtLvHead;
var TextBoxHandle txtLvName;
var TextBoxHandle txtHeadFight;
var TextBoxHandle txtHeadPhysicalAttack;
var TextBoxHandle txtHeadPhysicalDefense;
var TextBoxHandle txtHeadHitRate;
var TextBoxHandle txtHeadPhysicalAvoid;
var TextBoxHandle txtHeadCriticalRate;
var TextBoxHandle txtHeadPhysicalAttackSpeed;
var TextBoxHandle txtHeadMovingSpeed;
var TextBoxHandle txtHeadSoulShot;
var TextBoxHandle txtHeadMagicalAttack;
var TextBoxHandle txtHeadMagicDefense;
var TextBoxHandle txtHeadMagicHit;
var TextBoxHandle txtHeadMagicAvoid;
var TextBoxHandle txtHeadMagicCritical;
var TextBoxHandle txtHeadMagicCastingSpeed;
var TextBoxHandle txtHeadSoulShotCosume1;
var TextBoxHandle txtHeadSoulShotCosume2;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtMagicHit;
var TextBoxHandle txtMagicAvoid;
var TextBoxHandle txtMagicCritical;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtSoulShotCosume1;
var TextBoxHandle txtSoulShotCosume2;
var TextureHandle BackTex1;
var TextureHandle BackTex2;
var TextureHandle BackTex3;
var TextureHandle DividerLine;
var TextureHandle DividerLine2;
var TextureHandle SummonedFace;
var TextureHandle SummonedSlotOutline;
var WindowHandle SummonedWnd_Action;
var WindowHandle SummonedWnd_Action1;
var ItemWindowHandle SummonedActionWnd_Before;
var TextureHandle BackTexAction1_Before;

var WindowHandle SummonedWnd_Action2;
var TextBoxHandle txtHeadDirect;
var TextBoxHandle txtHeadPolicy;
var TextBoxHandle txtHeadSkill;
var ItemWindowHandle SummonedActionWnd;
var ItemWindowHandle SummonedActionWnd2;
var ItemWindowHandle SummonedActionWnd3;
var TextureHandle BackTexAction1;
var TextureHandle BackTexAction2;
var TextureHandle BackTexAction3;

var StatusBarHandle barHP;
var StatusBarHandle barMP;

//var ButtonHandle btnBar;

var TabHandle TabCtrl;
var TextureHandle TabLineTop;
var TextureHandle tabBg1;


//var int usedSummonPoint;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Struct 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ��ȯ�� UI �� ���Ժ� ���� 1~4
struct summonedSlot
{
	var string  name;      // �̸�
	var int		serverID;  // ���� ���̵�
	var int		classID;   // Ŭ���� ID (��Ȱ)
	var int		level;     // ����
};


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ���� ����
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var L2Util           util;

var int summonServerID;

// 4�� ���� �����ΰ�?
var bool bAwakeStateFlag;

//��ȯ�� �ִ� ��
const summonMaxNum = 4;
const summonpintMinPoint = 2;

//���� �Ǿ� �ִ� ���� ��ȣ.
var int selectedSlotIndex;

// ��ȯ�� ���� 1~4 ���� ������
var int summonedServerID;
//var summonedSlot summonedSlotArray[summonMaxNum];

var int currentSummonPolicy;//��ȯ ���� ���� ��å, 0:���

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////.0.0
// �ʱ�ȭ ���� 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnRegisterEvent()
{
	RegisterEvent( EV_UpdateSummonInfo );
	RegisterEvent( EV_SummonedWndShow );
	RegisterEvent( EV_SummonedStatusClose );
	
	RegisterEvent( EV_ActionListNew );
	RegisterEvent( EV_ActionSummonedCommonListStart );
	RegisterEvent( EV_ActionSummonedCommonList );

	RegisterEvent( EV_SummonedStatusRemainTime);//�ڲ� 1120 �̺�Ʈ�� ����ͼ�.....

	//RegisterEvent( EV_SummonedStatusSpelledList );
	
	RegisterEvent( EV_LanguageChanged );

	RegisterEvent( EV_BR_Die_EnableNPC );

	RegisterEvent( EV_Restart );

	RegisterEvent( EV_TargetUpdate );

	RegisterEvent( EV_ActionSummonedAllSkillListStart );

	RegisterEvent( EV_ActionSummonedAllSkillList );

	RegisterEvent( EV_SummonedDelete );

	RegisterEvent( EV_UpdateHP ); //hp ������ ���� ��� 

	RegisterEvent( EV_UpdateMP ); //mp ������ ���� ��� 

	
}

function OnEvent(int Event_ID, string param)
{
	local int serverID;
	local int CurrentHP;
	local int CurrentMP;
	local int slotIndex;
	
	if(DebugConditions(Event_ID)){
		//Debug("��ȯ�� â EventID: " @ Event_ID @  param);
//		Debug("param            : " @ param);
	}
	
	//if (Event_ID == EV_SummonedStatusSpelledList ){ // 1110. ���� ����
	//	ParseInt( param, "ServerID", serverID );
		//Debug("EV_SummonedStatusSpelledList EventID" @ param);
		//Debug("serverID  -> " @ serverID);
		//if (serverID != 0)
		//{
		//	HandleSummonInfoUpdate(serverID);
		//}
	//}

	if (Event_ID == EV_TargetUpdate ){ //980
		HandleTargetUpdate();
	}
	else if (Event_ID == EV_BR_Die_EnableNPC) //ldw 9140 �̷ο�� �׾��� ��. 
	{
		

	}else if (Event_ID == EV_ActionSummonedAllSkillListStart)  //ldw 1351 -> ���� ��ų ��û ���� �̺�Ʈ.
	{
		//Debug("EV_ActionSummonedAllSkillListStart P:" @ param);
	}

	else if (Event_ID == EV_ActionSummonedCommonListStart)//ldw 1340 ���� ��ų���� �̺�Ʈ
	{
//		Debug("EV_ActionSummonedCommonListStart" @ param);
		// ��ü �׼� �� ������ ������ ��Ҹ� �����Ѵ�.
		//ClearActionWnd();
	}
	else if (Event_ID == EV_ActionSummonedAllSkillList)  //ldw 1352 -> ��ȯ�� ���� ��ų
	{
		//Debug("EV_ActionSummonedAllSkillList" @ param);
		HandleActionSummonedList(param);
	}
	else if (Event_ID == EV_ActionSummonedCommonList)//ldw 1350
	{
		//Debug("EV_ActionSummonedCommonList" @ param);
		HandleActionSummonedList(param);
	}
	else if (Event_ID == EV_UpdateSummonInfo )//ldw 251
	{
		//ttp60822 ���� �����
		if(GetGameStateName()!="GAMINGSTATE")
			return;

		ParseInt( param, "ServerID", serverID );
		//Debug("EV_UpdateSummonInfo EventID" @ param);	
		if (serverID != 0)
		{
			HandleSummonInfoUpdate(serverID);		
		}
	}
	else if (Event_ID == EV_UpdateHP ) 
	{	
		ParseInt( param, "ServerID", serverID );
		ParseInt( param, "CurrentHP", CurrentHP );
		//Debug("EV_UpdateHP EventID" @ param);	
		if (serverID != 0)
		{			
			if ( summonedServerID != serverID ) return;
			setStatusBarHP( slotIndex, CurrentHP, serverID);
			
		}
	}
	else if (Event_ID == EV_UpdateMP )
	{
		ParseInt( param, "ServerID", serverID );
		ParseInt( param, "CurrentMP", CurrentMP );
		//Debug("EV_UpdateMP EventID" @ param);
		if (serverID != 0)
		{
			if ( summonedServerID != serverID ) return;
			setStatusBarMP( slotIndex, CurrentMP, serverID);
		}	
	}
	else if (Event_ID == EV_SummonedStatusRemainTime )//ldw 1120
	{
		//Debug("EV_SummonedStatusRemainTime"); ��ȯ �ð�
	}

	else if (Event_ID == EV_SummonedStatusClose ) //ldw 1131 ��ȯ����
	{
		 HandleSummonedStatusClose();//â���� ��.
	}
	else if (Event_ID == EV_SummonedWndShow)//ldw 1090 ��ȯ���� ���� Ŭ�� ���� ��, �̺�Ʈ ���� ��.
	{
//		Debug("EV_SummonedWndShow");
		//ParseInt( param, "serverID", summonServerID );
		HandleSummonShow();
		
	}
	else if ( Event_ID == EV_LanguageChanged )
	{
		// HandleLanguageChanged();
	}
	else if( Event_ID == EV_ActionListNew )//ldw 1311 �� ó�� �߻�......�Ķ��Ÿ ����. ������ ���� �ϱ� ���� �̺�Ʈ�� �޾���.
	{		
//		Debug("EV_ActionListNew EventID" @ param);	//param ����.
	}
	else if (Event_ID == EV_Restart)
	{
		 reStart();
	}	
	else if (Event_ID == EV_SummonedDelete ){ //1132 ��ü ���� ��
		HandleSummonedDelete(param);
	}
}

function OnLoad()
{
	SetClosingOnESC();	

	// util �ʱ�ȭ 
	util = L2Util(GetScript("L2Util"));
	Initialize();

	//usedSummonPoint = 0;
	currentSummonPolicy = -1;

	/*
	for( i = 1 ; i <= summonMaxNum ; i ++ ) 
	{
		GetTextureHandle( "SummonedWndClassic.SummonedSlotOutline" $ i ).HideWindow();
		GetBarHandle( "SummonedWndClassic.barHP_" $ i ).HideWindow();
		GetBarHandle( "SummonedWndClassic.barMP_" $ i ).HideWindow();
	}
*/

	txtHeadSoulShotCosume1.SetText(GetSystemString(404));// 404 ����ź �Ҹ�	
	txtHeadSoulShotCosume2.SetText(GetSystemString(496));// 496 ����ź �Ҹ�
}

function Initialize()
{
	Me = GetWindowHandle( "SummonedWndClassic" );
	SummonedWnd_Status = GetWindowHandle( "SummonedWndClassic.SummonedWnd_Status" );
	txtLvHead = GetTextBoxHandle( "SummonedWndClassic.txtLvHead" );
	txtLvName = GetTextBoxHandle( "SummonedWndClassic.txtLvName");
	txtHeadFight = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadFight" );
	txtHeadPhysicalAttack = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadPhysicalAttack" );
	txtHeadPhysicalDefense = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadPhysicalDefense" );
	txtHeadHitRate = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadHitRate" );
	txtHeadPhysicalAvoid = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadPhysicalAvoid" );
	txtHeadCriticalRate = GetTextBoxHandle( "SummonedWndClassic.1.txtHeadCriticalRate" );
	txtHeadPhysicalAttackSpeed = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadPhysicalAttackSpeed" );
	txtHeadMovingSpeed = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadMovingSpeed" );
	txtHeadSoulShot = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadSoulShot" );
	txtHeadMagicalAttack = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadMagicalAttack" );
	txtHeadMagicDefense = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadMagicDefense" );
	txtHeadMagicHit = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadMagicHit" );
	txtHeadMagicAvoid = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadMagicAvoid" );
	txtHeadMagicCritical = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadMagicCritical" );
	txtHeadMagicCastingSpeed = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadMagicCastingSpeed" );
	txtHeadSoulShotCosume1 = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadSoulShotCosume1" );
	txtHeadSoulShotCosume2 = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHeadSoulShotCosume2" );
	txtPhysicalAttack = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtPhysicalAttack" );
	txtPhysicalDefense = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtPhysicalDefense" );
	txtHitRate = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtHitRate" );
	txtPhysicalAvoid = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtPhysicalAvoid" );
	txtCriticalRate = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtCriticalRate" );
	txtPhysicalAttackSpeed = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtPhysicalAttackSpeed" );
	txtMovingSpeed = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtMovingSpeed" );
	txtMagicalAttack = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtMagicalAttack" );
	txtMagicDefense = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtMagicDefense" );
	txtMagicHit = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtMagicHit" );
	txtMagicAvoid = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtMagicAvoid" );
	txtMagicCritical = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtMagicCritical" );
	txtMagicCastingSpeed = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtMagicCastingSpeed" );
	txtSoulShotCosume1 = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtSoulShotCosume1" );
	txtSoulShotCosume2 = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Status.txtSoulShotCosume2" );
	BackTex1 = GetTextureHandle( "SummonedWndClassic.SummonedWnd_Status.BackTex1" );
	BackTex2 = GetTextureHandle( "SummonedWndClassic.SummonedWnd_Status.BackTex2" );
	BackTex3 = GetTextureHandle( "SummonedWndClassic.SummonedWnd_Status.BackTex3" );
	DividerLine = GetTextureHandle( "SummonedWndClassic.SummonedWnd_Status.DividerLine" );
	DividerLine2 = GetTextureHandle( "SummonedWndClassic.SummonedWnd_Status.DividerLine2" );
	SummonedFace = GetTextureHandle( "SummonedWndClassic.SummonedFace" );
	SummonedSlotOutline = GetTextureHandle( "SummonedWndClassic.SummonedWnd_Status.SummonedSlotOutline" );
	SummonedWnd_Action = GetWindowHandle( "SummonedWndClassic.SummonedWnd_Action" );
	SummonedWnd_Action1 = GetWindowHandle( "SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action1" );
	
	BackTexAction1_Before = GetTextureHandle( "SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action1.BackTexAction1_Before" );
	SummonedWnd_Action2 = GetWindowHandle( "SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2" );
	txtHeadDirect = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.txtHeadDirect" );
	txtHeadPolicy = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.txtHeadPolicy" );
	txtHeadSkill = GetTextBoxHandle( "SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.txtHeadSkill" );

	SummonedActionWnd_Before = GetItemWindowHandle( "SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action1.SummonedActionWnd_Before" );
	SummonedActionWnd  = GetItemWindowHandle( "SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd" );
	SummonedActionWnd2 = GetItemWindowHandle( "SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd2" );
	SummonedActionWnd3 = GetItemWindowHandle( "SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd3" );

	BackTexAction1 = GetTextureHandle( "SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction1" );
	BackTexAction2 = GetTextureHandle( "SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction2" );
	BackTexAction3 = GetTextureHandle( "SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction3" );
	barHP = GetStatusBarHandle( "SummonedWndClassic.barHP" );
	barMP = GetStatusBarHandle( "SummonedWndClassic.barMP" );	

	
	//btnBar = GetButtonHandle( "SummonedWndClassic.btnBar" );

	TabCtrl = GetTabHandle( "SummonedWndClassic.TabCtrl" );
	TabLineTop = GetTextureHandle( "SummonedWndClassic.TabLineTop" );
	tabBg1 = GetTextureHandle( "SummonedWndClassic.tabBg1" );

	bAwakeStateFlag = false;
	initSlot();
}

/***
 * ��ȯ�� ���� ���� ������ �ʱ�ȭ �Ѵ�.
 * 
 **/ 
function initSlot()
{
	barHP.SetPoint(0,0);
	barMP.SetPoint(0,0);	
}


function OnShow()
{
	// ���� �׼� ����Ʈ�� ��û �Ѵ�.
	// class'ActionAPI'.static.RequestSummonedCommonActionList(summonServerID);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// �̺�Ʈ -> �ش� �̺�Ʈ ó�� �ڵ鷯
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function Bool DebugConditions(int Event_ID){//ldw ����׹ް� ���� ���� �̺�Ʈ��
	local Array<int> conditoins;
	local int i;

	conditoins[0]=EV_SummonedStatusRemainTime;
	conditoins[1]=EV_ActionSummonedCommonList;

	for(i=0 ;i < conditoins.Length ; i++){		
		if(conditoins[i] == Event_ID){
			return false;
		}
	}
	return true;
}




function reStart(){
	summonedServerID = -1;
}

//�׼�Ŭ��
function OnClickItem( string strID, int index )
{
	local ItemInfo infItem;
//	Debug ("OnClickItem:"$strID $ ", " $ index) ;
	if(index>-1){
		switch (strID){
		case "SummonedActionWnd_Before" :
			if (SummonedActionWnd_Before.GetItem(index, infItem))
				DoAction(infItem.ID);
			break;
		case "SummonedActionWnd" :
			if (SummonedActionWnd.GetItem(index, infItem))			
				DoAction(infItem.ID);
			break;
		case "SummonedActionWnd2" ://�̰� �����
			if (SummonedActionWnd2.GetItem(index, infItem)){
				Debug("index" @ index);
				Debug("currentSummonPolicy" @ currentSummonPolicy);

				//SummonedActionWnd2.SetToggle(index, true);
				//SummonedActionWnd2.SetToggle(currentSummonPolicy, false);
				if ( index != currentSummonPolicy ){
					SummonedActionWnd2.SetToggleEffect(index, true);
					SummonedActionWnd2.SetToggleEffect(currentSummonPolicy, false);

					currentSummonPolicy = index;
					DoAction(infItem.ID);	
				}

			}
			break;
		case "SummonedActionWnd3" :
			if (SummonedActionWnd3.GetItem(index, infItem))	
				DoAction(infItem.ID);
			break;
		}	
		
	}


//////////////////////////////////////////////////
	/*if (strID == "ActionBasicItem" && index>-1)
	{
		if (!class'UIAPI_ITEMWINDOW'.static.GetItem("ActionWnd.ActionBasicItem", index, infItem))
			return;

		class'UIAPI_ITEMWINDOW'.static.SetItem( "ActionWnd.ActionBasicItem", index, infItem );
	}
	else if (strID == "ActionPartyItem" && index>-1)
	{
		if (!class'UIAPI_ITEMWINDOW'.static.GetItem("ActionWnd.ActionPartyItem", index, infItem))
			return;
	}
	else if (strID == "ActionMarkItem" && index>-1)
	{
		if (!class'UIAPI_ITEMWINDOW'.static.GetItem("ActionWnd.ActionMarkItem", index, infItem))
			return;
	}
	else if (strID == "ActionSocialItem" && index>-1)
	{
		if (!class'UIAPI_ITEMWINDOW'.static.GetItem("ActionWnd.ActionSocialItem", index, infItem))
			return;
	}
	

	DoAction(infItem.ID);*/



}

/**
 * ��ȯ���� ���� �� �� -> �ش� ��ȯ���� Ÿ������ ����, �� ����.
 **/
function HandleTargetUpdate(){
	//local SummonInfo info;
	//GetSummonInfo(info);	
	local int serverID ;	
	serverID  = class'UIDATA_TARGET'.static.GetTargetID() ;

	if ( summonedServerID == serverID ) 
	{
		setInformation(serverID);
//		setbtnBarSelection(serverID);
	}
}


/**
 * UI ��ư�� ������ �� -> �ش� ��ȯ���� Ÿ������ ����
 **/
function setTargetSummon () // Ÿ���� ���� ���� �ϴ� �Ͱ� ��ġ�� ��.
{
	local UserInfo userinfo;
	

	if (summonedServerID != -1)
	{
		if (GetPlayerInfo(userinfo))
		{			
//			Debug("Ŭ�� Ÿ��====> "@summonedSlotArray[num].serverID);
			RequestAction(summonedServerID, userinfo.Loc);//HandleTargetUpdate()�� �̾���			
			//setInformation(serverID);
			//setbtnBarSelection(serverID);
		}	
	} 
	//return userinfo.nID;
}

function HandleSummonedStatusClose(){
	local int usedSummonPoint;
	local int SummonablePoint;

	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
//	Debug("��ȯ����");	
	deleteSlot();
	GetSummonPoint(usedSummonPoint, SummonablePoint);
	ClearActionWnd();
	setInformation(-1);
//	setbtnBarSelection(-1);
	currentSummonPolicy = -1;
}


/**
 *  ��ȯ�� â�� ���� �ش�. 1~3�� �� 4�� ������ ������ ���´� �ణ �ٸ���. 
 *  (���������� �Ӽ��� �����Ͽ� ����� �ٸ��� ���ش�)
 **/
function HandleSummonShow()
{
//	Debug("HandleSummonShow");
	// ���� 
	PlayConsoleSound(IFST_WINDOW_OPEN);
	
	//class'ActionAPI'.static.RequestSummonedCommonActionList(summonServerID); // ���� ��ȯ ���� ��. ��û �ؾ� ��.  -> EV_ActionSummonedCommonList ȣ��	
	// ���� , ��Ŀ�� ���	

	if ( getInstanceUIData().getIsClassicServer() ) 
	{
		Me.ShowWindow();
		Me.SetFocus();
	}
}

/**
 *  ��ȯ�� 
 **/

function HandleSummonedDelete (string param){
	local int serverID;
	ParseInt(param, "serverID", serverID);
	if (bAwakeStateFlag)
	{ // 4�� ���� ������ ��ȯ������ �ذ� ��. 4�� ���� ���Ĵ� 3�� ���� ��ų ������ ���� �� �� �ٽ� ����.		
		if( summonedServerID == serverID )// ����  �� �ִ� ������ �ִٸ� �ش� ������ ������ ���� ��. ��ȯ ������ ó�� ��
		{	
			SummonedActionWnd3.Clear();// ���� �׼��� ����� �ٽ� �޾ƾ� ��.
			deleteSlot();
		}		
	}
}


//���� �ؾ�...
function deleteSlot(){
	//���� ���� ���� ó�� ��....
	
	//btnBar.ClearTooltip();	
	summonedServerID = -1;	
	//GetBarHandle( "SummonedWndClassic.barHP_1" ).HideWindow();
	//GetBarHandle( "SummonedWndClassic.barMP_1" ).HideWindow();
}


function HandleSummonInfoUpdate(int serverID)
{		
	local int       HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;

	local int       ClassID;

	local string	Name;
	local int		Level;

	//local int       SummonablePoint;//ldw 
	//local int       usedSummonPoint;	
	
	local SummonInfo info;

	// ��ź ǥ�� ī��Ʈ
	// ���� ���� ���� index
	//local int slotIndex;	

	//local TextureHandle SummonedFace;

		if (GetSummonInfo(serverID, info))
		{
			ClassID = info.nClassID;
			Name  = info.Name;
			Level = info.nLevel;
			HP    = info.nCurHP;
			MaxHP = info.nMaxHP;
			MP    = info.nCurMP;
			MaxMP = info.nMaxMP;
			
			//branch 110824
			if( ClassID <= 0 ) return; //class�� 0���� �Ѿ�ö��� �־ �������� �ȳ��� 

			summonedServerID = serverID;			
				
			/*enum ETextureCtrlType
			*{
			*    TCT_Stretch             =0,
			*    TCT_Normal              =1,
			*    TCT_Tile                =2,
			*    TCT_Draggable           =3,
			*    TCT_Control             =4,
			*    TCT_Mask                =5,
			};
			*/
			
			//SummonedFace.SetTexture("icon.skill11256");
			SummonedFace.SetTexture( class'UIDATA_NPC'.static.GetNPCIconName(ClassID) );
			SummonedFace.SetTextureSize(32,32);
			//GetBarHandle( "SummonedWndClassic.barHP_1").ShowWindow();
			//GetBarHandle( "SummonedWndClassic.barMP_1").ShowWindow();
//				Debug("ClassID = "$ClassID);

			summonedServerID = serverID;	

			class'ActionAPI'.static.RequestSummonedCommonActionList(serverID);// ->  ���� ��ų 1340 �̺�Ʈ �߻� -> 1350 �̺�Ʈ �Ķ��Ÿ�� ��ų�� ����. ��ȯ�� ������ �޶� �� �� ����
			class'ActionAPI'.static.RequestSummonedAllSkillActionList();//->         ���� ��ų 1351 �̺�Ʈ �߻� -> 1352 �̺�Ʈ �Ķ��Ÿ�� ��ų�� ����. ��ȯ�� ������ �޶� �� �� ����			
			
			setInformation(serverID); //
//			setbtnBarSelection(serverID); //������ ó��				
			
			barHP.SetPoint(HP, MaxHP);
			barMP.SetPoint(MP, MaxMP);  
			//btnBar.SetTooltipCustomType(setHpMpToolTips(  Level, Name,  MaxHP, HP, MaxMP, MP));	
	}	
}

function setStatusBarHP(int slotIndex, int curHP , int serverID) 
{	
	local SummonInfo info;
	local string	Name;
	local int		Level;
	local int		MaxHP;	
	local int		MP;	
	local int		MaxMP;	

	if (GetSummonInfo(serverID, info))
	{		
		MaxHP = info.nMaxHP;
		MaxMP = info.nMaxMP;
		MP = info.nCurMP;
		Name  = info.Name;
		Level = info.nLevel;
		
		barHP.SetPoint(curHP, MaxHP);
		barMP.SetPoint(MP, MaxMP);  
		//btnBar.SetTooltipCustomType(setHpMpToolTips(  Level, Name,  MaxHP, curHP, MaxMP, MP));	
	}
}

function setStatusBarMP(int slotIndex, int curMP, int serverID ) 
{
	local SummonInfo info;
	local string	Name;
	local int		Level;
	local int		MaxHP;	
	local int		HP;	
	local int		MaxMP;	

	if (GetSummonInfo(serverID, info))
	{		
		MaxHP = info.nMaxHP;
		MaxMP = info.nMaxMP;
		HP = info.nCurHP;
		Name  = info.Name;
		Level = info.nLevel;

		barHP.SetPoint(HP, MaxHP);
		barMP.SetPoint(curMP, MaxMP);  
		//btnBar.SetTooltipCustomType(setHpMpToolTips(  Level, Name,  MaxHP, HP, MaxMP, curMP));	
	}
}



/*

function setbtnBarSelection(int serverID)
{ 
	//������ ó�� ����.
	local ButtonHandle btnBAr;
	local string btnString_None;
	local string btnString_Over;
	local string btnString_Down;
	local int slotIndex;
	local int i;
	
	btnString_None="L2UI_ct1.Summoned.Summoned_DF_SelectBtn";
	btnString_Over="L2UI_ct1.Summoned.Summoned_DF_SelectBtn_Over";
	btnString_Down="L2UI_ct1.Summoned.Summoned_DF_SelectBtn_Down";	
	
	selectedSlotIndex = -1;
	for( i = 1; i <= summonMaxNum ; i++){
		btnBAr = GetButtonHandle("SummonedWndClassic.btnBar_" $ i);
		btnBAr.SetTexture(btnString_None, btnString_Down,btnString_Over);
	}
	if(serverID > 0 ){
		slotIndex = GetIsSummonedSlotIndex(serverID);
		btnBAr = GetButtonHandle("SummonedWndClassic.btnBar_" $ (slotIndex + 1));		
		btnString_None="L2UI_ct1.Summoned.Summoned_DF_SelectBtn_Down";		
		btnBAr.SetTexture(btnString_None, btnString_Down,btnString_Over);
		selectedSlotIndex = slotIndex;
	}	
}
*/


/*
function int GetIsSummonedSlotIndex(int serverID){
// �ش� �������̵� �̹� ���Կ� �ִٸ� �ش� ���� ��ȣ�� ����
	local int i;
	for(i=0 ; i < summonMaxNum ; i++){
		if (summonedSlotArray[i].serverID == serverID) 
		{			
			return i; //������ ����.	
		}
	}
	return -1; //������ ����.
}*/



/**
 *  ��ü �׼� ������ ������ ���� 
 **/
function ClearActionWnd()
{
	SummonedActionWnd.Clear();
	SummonedActionWnd2.Clear();
	SummonedActionWnd3.Clear();

	SummonedActionWnd_Before.Clear();
}

/**
 *  ��ȯ�� �׼� �����츦 ä��� 
 *  
 **/
function HandleActionSummonedList(string param)
{
	local UserInfo userinfo;
	
	local int tmpID;
	local int Tmp;
	local EActionCategory Type;
	local string strActionName;
	local string strIconName;
	local string strDescription;
	local string strCommand;
	
	local ItemInfo	infItem;

	local int usedSummonPoint;
	local int SummonablePoint;
	
	ParseItemID(param, infItem.ID);

	//infItem.ID �޴� â�� ��ų�� ���� ��� �߰� �Ʒ� �κ�

	ParseInt(param, "Type", Tmp);
	ParseString(param, "Name", strActionName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "Description", strDescription);
	ParseString(param, "Command", strCommand);
	

//	Debug("hAction:" @ param);

	infItem.Name = strActionName;
	infItem.IconName = strIconName;
	infItem.Description = strDescription;
	infItem.ShortcutType = int(EShortCutItemType.SCIT_ACTION);
	infItem.MacroCommand = strCommand;
	infItem.ReuseDelayShareGroupID = -1;
	
	GetPlayerInfo( userinfo );

	
	
	GetSummonPoint(usedSummonPoint, SummonablePoint);

	//if (GetClassTransferDegree(userinfo.Class) > 3 )//ldw ��ȯ���� ��ȯ ����Ʈ�� ���ص� �߰� -> || SummonedPoint  ,SummonablePoint 
	
	if (usedSummonPoint>0){
		//Debug("���ο� 4�� ���� ��ȯ��");
		SummonedWnd_Action2.ShowWindow();
		SummonedWnd_Action1.HideWindow();
		bAwakeStateFlag = true;
	} else
	{
		//Debug("������ 1~3�� ���� ��ȯ�� ");
		SummonedWnd_Action1.ShowWindow();
		SummonedWnd_Action2.HideWindow();
		bAwakeStateFlag = false;
	}
	
	// Type enum
	//
	//enum EActionCategory
	//{

		//0  ACTION_NONE,
		//1  ACTION_BASIC,
		//2  ACTION_PARTY,
		//3  ACTION_TACTICALSIGN,
		//4  ACTION_SOCIAL,
		//5  ACTION_PET,
		//6  ACTION_SUMMON,  //���� ��
		//7  ACTION_SUMMON_DIRECT,  //�⺻ ���
		//8  ACTION_SUMMON_AI, //�ΰ� ����
		//9  ACTION_SUMMON_REACT, //������
		//10 ACTION_SUMMON_SKILL, //��ų
	//};	

			
	Type = EActionCategory(Tmp);
	
	// 1~3��, �Ѹ��� ��ȯ
	
	
	
	if (bAwakeStateFlag == false)
	{		
		tmpID = SummonedActionWnd_Before.FindItem(infItem.ID);
		if (Type==ACTION_SUMMON)
		{		
			if( tmpID < 0 ){
				//Debug("step 2:"$  Type $ ", " $ infItem.MacroCommand);
				SummonedActionWnd_Before.AddItem(infItem);
			}
		}
	}
	// ���� ����, 1~4���� ��ȯ
	else
	{
		//Debug("����");
	    if (Type==ACTION_SUMMON_DIRECT) //type = 7
		{
			// ���
			//Debug("type:"$string(Type));		
			tmpID = SummonedActionWnd.FindItem(infItem.ID);
			if( tmpID < 0 ) {   SummonedActionWnd.AddItem(infItem);
				//Debug(Type $ "�� " $ tmpID);//��ų�� ���� ��
			}
		}
		else if (Type==ACTION_SUMMON_AI)
		{
			// ��ħ
			//Debug("type:"$string(Type));		
			tmpID =	SummonedActionWnd2.FindItem(infItem.ID);
			if( tmpID < 0 ) SummonedActionWnd2.AddItem(infItem);
			if(currentSummonPolicy == -1){//ù ��ħ �ʱ�ȭ �������� �� �ε� ��ħ��.
				if(SummonedActionWnd2.GetItem(0, infItem)){
					currentSummonPolicy = 0;
					SummonedActionWnd2.SetToggleEffect(currentSummonPolicy, true);
					//SummonedActionWnd2.SetToggle(currentSummonPolicy, true);
					//Debug(Type $ "�� " $ tmpID);//��ų�� ���� ��
				}
			}
		}
		else if (Type==ACTION_SUMMON_SKILL)
		{   
			//��ų
			//Debug("type:"$string(Type));		
			tmpID =	SummonedActionWnd3.FindItem(infItem.ID);
			if( tmpID < 0 ) {   SummonedActionWnd3.AddItem(infItem);
				//Debug(Type $ "�� " $ tmpID);//��ų�� ���� ��
			}
		}
	}
}


/*function bool skillConditionCheck(int tmpID, string tmpCommand){
	if( tmpID < 0 )
		//if(tmpCommand != "/(null)")
			return true;
	else Debug("tmpID:"$tmpID $ ", tmpCommand:" $ tmpCommand );
	return false;
}*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Ŭ�� �̺�Ʈ
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnClickButton( string Name )
{
//	Debug("OnClickButton: " @ Name);

	switch( Name )
	{
		case "btnBar":
			// ��� ���ϴ� ��.
			setTargetSummon();			
			break;
			/*
		case "btnBar_2":
			setTargetSummon(1);
			
			break;
		case "btnBar_3":
			setTargetSummon(2);
			
			break;
		case "btnBar_4":
			setTargetSummon(3);			
			break;
*/
	}
}

function setInformation(int serverID){
	local string	Name;	
	local int		Level;
	local int       ClassID;
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

	local int       MagicalHitRate;
	local int       MagicalAvoid;
	local int       MagicalCritical;

	// ��ź ǥ�� ī��Ʈ 
	//local int cosumeCount;
	local SummonInfo info;
	
	if (GetSummonInfo(serverID, info))
	{		
		Name  = info.Name;
		Level = info.nLevel;

		ClassID             = info.nClassID;
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

		//cosumeCount = 1;
		/*
		ing(   SummonablePoint    ) );*/
		//�� �� ���� ��

		SummonedFace.SetTexture( class'UIDATA_NPC'.static.GetNPCIconName(ClassID) );
		SummonedFace.SetTextureSize(32,32);

		txtLvName.SetText(Level $ " " $ Name);
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
		txtMagicHit.SetText(string(MagicalHitRate));
		txtMagicAvoid.SetText(string(MagicalAvoid));
		txtMagicCritical.SetText(string(MagicalCritical));			
		//if (SoulShotCosume > 0)
		//{
			//GetTextBoxHandle("SummonedWndClassic.txtHeadSoulShotCosume1").SetText(GetSystemString(404));// 404 ����ź �Ҹ�
		txtSoulShotCosume1.SetText(String(SoulShotCosume));
			/*
			GetTextBoxHandle("SummonedWndClassic.txtHeadSoulShotCosume" $ string(cosumeCount)).SetText(GetSystemString(404));// 404 ����ź �Ҹ�
			GetTextBoxHandle("SummonedWndClassic.txtSoulShotCosume" $ string(cosumeCount)).SetText(String(SoulShotCosume));
			cosumeCount++;*/
		//}
		
		//if (SpiritShotConsume > 0){
			//GetTextBoxHandle("SummonedWndClassic.txtHeadSoulShotCosume2").SetText(GetSystemString(496));// 496 ����ź �Ҹ�
		txtSoulShotCosume2.SetText(String(SpiritShotConsume));			
			//cosumeCount++;
		//}

	} else {
		//cosumeCount = 1;
		SoulShotCosume = 0;
		SpiritShotConsume = 0;

		txtLvName.SetText("");
		txtPhysicalAttack.SetText("");
		txtPhysicalDefense.SetText("");
		txtHitRate.SetText("");
		txtCriticalRate.SetText("");
		txtPhysicalAttackSpeed.SetText("");
		txtMagicalAttack.SetText("");
		txtMagicDefense.SetText("");
		txtPhysicalAvoid.SetText("");
		txtMovingSpeed.SetText("");
		txtMagicCastingSpeed.SetText("");		
		//if (SoulShotCosume > 0)
		//{
			//GetTextBoxHandle("SummonedWndClassic.txtHeadSoulShotCosume1" ).SetText(GetSystemString(404));// 404 ����ź �Ҹ�
		txtSoulShotCosume1.SetText(String(SoulShotCosume));
			//cosumeCount++;
		//}		
		//if (SpiritShotConsume > 0){
			//GetTextBoxHandle("SummonedWndClassic.txtHeadSoulShotCosume2" ).SetText(GetSystemString(496));// 496 ����ź �Ҹ�
		txtSoulShotCosume2.SetText(String(SpiritShotConsume));			
			//cosumeCount++;
		//}
	}
}



/**
 *  ���� hp, mp ���̵��� 
 **/
function CustomTooltip setHpMpToolTips (int Level, string Name, int maxHP, int currentHP, int maxMP, int currentMP)
{
	local CustomTooltip m_Tooltip;
	
	m_Tooltip.DrawList.Length = 8;
	
	m_Tooltip.DrawList[0].t_bDrawOneLine = true;
	m_Tooltip.DrawList[0].eType = DIT_TEXT;
	m_Tooltip.DrawList[0].t_strText = "Lv ";		

	m_Tooltip.DrawList[1].t_bDrawOneLine = true;
	m_Tooltip.DrawList[1].eType = DIT_TEXT;//level
	m_Tooltip.DrawList[1].t_color.R = 175;
	m_Tooltip.DrawList[1].t_color.G = 152;
	m_Tooltip.DrawList[1].t_color.B = 120;
	m_Tooltip.DrawList[1].t_color.A = 255;
	m_Tooltip.DrawList[1].t_strText = String(level) $ " " $ name;//name
	
	m_Tooltip.DrawList[2].t_bDrawOneLine = true;
	m_Tooltip.DrawList[2].eType = DIT_TEXT;
	m_Tooltip.DrawList[2].bLineBreak = true;	
	m_Tooltip.DrawList[2].t_strText = "HP: ";	
	
	m_Tooltip.DrawList[3].t_bDrawOneLine = true;
	m_Tooltip.DrawList[3].eType = DIT_TEXT;
	m_Tooltip.DrawList[3].t_color.R = 175;
	m_Tooltip.DrawList[3].t_color.G = 152;
	m_Tooltip.DrawList[3].t_color.B = 120;
	m_Tooltip.DrawList[3].t_color.A = 255;
	
	m_Tooltip.DrawList[3].t_strText = String(currentHP);//h
	
	m_Tooltip.DrawList[4].t_bDrawOneLine = true; //�� �ٷ� ���� ��.
	m_Tooltip.DrawList[4].eType = DIT_TEXT;	
	m_Tooltip.DrawList[4].t_strText = " / " $ maxHP $ "  ";		
	
	m_Tooltip.DrawList[5].eType = DIT_TEXT;
	m_Tooltip.DrawList[5].bLineBreak = true;
	m_Tooltip.DrawList[5].t_strText = "MP: ";

	m_Tooltip.DrawList[6].t_bDrawOneLine = true;
	m_Tooltip.DrawList[6].eType = DIT_TEXT;	
	m_Tooltip.DrawList[6].t_color.R = 175;
	m_Tooltip.DrawList[6].t_color.G = 152;
	m_Tooltip.DrawList[6].t_color.B = 120;
	m_Tooltip.DrawList[6].t_color.A = 255;
	m_Tooltip.DrawList[6].t_strText = String(currentMP);


	m_Tooltip.DrawList[7].t_bDrawOneLine = true;
	m_Tooltip.DrawList[7].eType = DIT_TEXT;
	m_Tooltip.DrawList[7].t_strText = " / " $ maxMP;//mp	

	return m_Tooltip;
}


/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "SummonedWndClassic" ).HideWindow();
}

defaultproperties
{
}
