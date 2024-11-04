//------------------------------------------------------------------------------------------------------------------------
//
// ����         : AlterSkill  ( �ߵ� ��ų ) - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class AlterSkill extends L2UIGFxScript;

const FLASH_WIDTH  = 800;
const FLASH_HEIGHT = 600;

var int currentScreenWidth, currentScreenHeight;

function OnRegisterEvent()
{
	// registerEvent(EV_ReceiveOlympiadGameList);
	registerEvent(EV_StateChanged);
	registerEvent(EV_ActivateAlterSkill);
	registerGFxEvent(EV_ActivateAlterSkill);
	registerGFxEvent(EV_InActivateAlterSkill);
	registerGFxEvent(EV_UseActiveAlterSkill);
	registerGFxEvent(EV_Restart);

	// ������ ��ų ���̱� �ݱ�
	registerGFxEvent(EV_ArenaBattleOccupyShowSkill);
	registerGFxEvent(EV_ArenaBattleOccupyHideSkill);


	
	

	// Debug("AlterSkill  OnRegisterEvent =============> ");	
}

function OnLoad()
{
	registerState( "AlterSkill", "GamingState" );	
	//	SetAlwaysFullAlpha( true );

	SetContainerHUD( WINDOWTYPE_NONE, 0);
	AddState("GAMINGSTATE");
	AddState("ARENABATTLESTATE");
	//AddState("ARENAGAMINGSTATE");

	//�����ϸ� ó�� ���� �������� ���� ��	
	SetDefaultShow(true);

	SetHavingFocus( false );
	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0,0);//116, -3);
}

function OnShow()
{
	// Debug("AlterSkill!!!! onShow");
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_UseSkill);
}

function OnHide()
{
}

function OnCallUCLogic( int logicID, string param )
{
	// SetNextFocus();
	// ������, ��Ŀ�� �Ѱ��ֱ� 
	if (logicID == 1)
	{
		SetNextFocus();
		HideWindow();
	}
}

// skillID=1 level=1 time=5 altFlag=1 ctrlFlag=1 shiftFlag=0 totalCoolTime=10 remainCoolTime=10 mainKey=a
// 5130
function OnEvent(int Event_ID, string param)
{
	// local int xLoc, yLoc;
	/*
	local int skillID;

	// ���� ������ ��ų ���̵�
	// local int originalSkillID;
	local int skillLevel;
	local int sec;

	local int totalCoolTime;
	local int remainCoolTime;

	
	local int altFlag;
	local int ctrlFlag;
	local int shiftFlag;


	local string mainKey;

	local array<GFxValue> args;

	local GFxValue invokeResult;


	// ��ų �ؽ��� ��Ʈ���� �ޱ� ���� itemID
	local ItemID itemID;
*/

	local string mainKey;

	// �ػ� 
	// local int CurrentMaxWidth; 
	// local int CurrentMaxHeight;
	// end

	// Debug("Show AlterSkill" @ Event_ID);
	// Debug(" param : " @ param);

	if ( Event_ID == EV_ActivateAlterSkill )
	{
		ParseString(param, "mainKey"   , mainKey);

		callGfxFunction ( "AlterSkill", "setShowShortKey", string(mainKey!="") ) ;

		// ���� �ػ󵵸� ��´�.
		// GetCurrentResolution (CurrentMaxWidth, CurrentMaxHeight);	

		/*
		ShowWindow();


		/////////// 
		// ���� ���� ��ų�� ���� �Ҽ��� ������ ���� �õ�..

		// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
		AllocGFxValues(args, 2);		
		AllocGFxValue(invokeResult);

		// �ߵ� ��ų ���� : �̺�Ʈ ��ȣ 3��
		args[0].SetInt(3);
		CreateObject(args[1]);

		Invoke("_root.onEvent", args, invokeResult);

		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);

		/////////////////

		// ��ų ����
		ParseInt(param,"skillID"        , skillID);
		// ParseInt(param,"originalSkillID", originalSkillID);
		ParseInt(param,"level"          , skillLevel);
		ParseInt(param,"time"           , sec);

		// ����Ű 
		ParseInt(param, "altFlag"   , altFlag);
		ParseInt(param, "ctrlFlag"  , shiftFlag);
		ParseInt(param, "shiftFlag" , shiftFlag);

		// ��ų ���� ���� �ð� (��)
		ParseInt(param, "totalCoolTime"  , totalCoolTime);
		ParseInt(param, "remainCoolTime" , remainCoolTime);

		ParseString(param, "mainKey"   , mainKey);

		// ��ų ���̵� ���� ����
		itemID.ClassID = skillID;
		itemID.ServerID = 0;

		// ��ų ������ ��� (���� ������� �ʱ�� ����)
		// IconName = class'UIDATA_SKILL'.static.GetIconName( itemID, skillLevel );

		// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
		AllocGFxValues(args, 2);		
		AllocGFxValue(invokeResult);

		// �ߵ� ��ų ���� : �̺�Ʈ ��ȣ 1��
		args[0].SetInt(1);
		
		CreateObject(args[1]);
				
		// ������ Ÿ��, 1�� ��, 2�� �ָ� 
		// ���ʿ��� �ϵ� �ڵ��� �ؾ� ��..
		args[1].SetMemberInt("iconType", 1);

		// ȭ�鿡 ������ ��
		args[1].SetMemberInt("sec", sec);

		// ��ų ���� ���� �ð� (��)
		args[1].SetMemberInt("totalCoolTime" , totalCoolTime);
		args[1].SetMemberInt("remainCoolTime", remainCoolTime);
	
		// ��ų ���̵�
		args[1].SetMemberInt("skillID"        , skillID);
		// args[1].SetMemberInt("originalSkillID", originalSkillID);

		// ����Ű
		args[1].SetMemberBool("altFlag"   , bflag(altFlag));
		args[1].SetMemberBool("ctrlFlag"  , bflag(ctrlFlag));
		args[1].SetMemberBool("shiftFlag" , bflag(shiftFlag));
		args[1].SetMemberString("mainKey" , mainKey);
		
		
		// ���� �ػ󵵸� ��´�.
		GetCurrentResolution (currentScreenWidth, currentScreenHeight);	

		// ȭ�� ��ġ
		// ���� 60% , ���� �߾�
		//args[1].SetMemberInt("x"  , (FLASH_WIDTH  / 1.66));
		//args[1].SetMemberInt("y"  , (FLASH_HEIGHT / 2) );
		
		// args[1].SetMemberInt("x"  , (FLASH_WIDTH / 100) * 70);
		// args[1].SetMemberInt("y"  , (FLASH_HEIGHT / 100) * 60);

		// args[1].SetMemberInt("x"  ,(currentScreenWidth / 100) * 60);
		// args[1].SetMemberInt("y"  ,(currentScreenHeight / 100) * 50);

		Invoke("_root.onEvent", args, invokeResult);

		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);

	}
	// ���� ���
	else if ( Event_ID == EV_InActivateAlterSkill )
	{
		// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
		AllocGFxValues(args, 2);		
		AllocGFxValue(invokeResult);

		// �ߵ� ��ų ���� : �̺�Ʈ ��ȣ 3��
		args[0].SetInt(3);
		CreateObject(args[1]);

		Invoke("_root.onEvent", args, invokeResult);

		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);
	}
	// ��ų�� ���������� ���� �Ǿ��ٸ� ���� �� Ÿ�� (��ų ���� ���� �ð�)�� �޾Ƽ� ������.	
	else if ( Event_ID == EV_UseActiveAlterSkill )
	{

		// ��ų id
		// ParseInt(param,"skillID"     , skillID);
		// ��ų �� Ÿ��
		ParseInt(param,"totalCoolTime" , totalCoolTime);
		// ���� ���� ���� ��ų �� Ÿ��
		ParseInt(param,"remainCoolTime", remainCoolTime);

		// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
		AllocGFxValues(args, 2);		
		AllocGFxValue(invokeResult);

		// ���� �ߵ����� ��ų�� ���������� ����ߴٸ� ���� ������ ǥ�� : �̺�Ʈ ��ȣ 4��
		// ȭ��� �ߵ� ��ų�� ���� �ִ� ��Ȳ���� ���..
		args[0].SetInt(4);
		CreateObject(args[1]);

		args[1].SetMemberInt("totalCoolTime"  , totalCoolTime);
		args[1].SetMemberInt("remainCoolTime"  , remainCoolTime);

		Invoke("_root.onEvent", args, invokeResult);

		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);
		// Debug("EV_UseActiveAlterSkill �̺�Ʈ�� ���� �Դ�! :" @ param);
*/
	}	
	else if ( Event_ID == EV_StateChanged ) 
	{
		if ( param == "ARENAGAMINGSTATE" ) 
		{
			HideWindow();
		}
	}

}

/**
 * ���ڸ� ������ true, false �� ���� �ϰ� �Ѵ�.
 **/
function bool bflag(int nflag)
{
	if (nflag > 0) return true;
	else return false;
}


/**
 * ��ų ��ȣ�� �Է� �ϸ� �ߵ� ��ų �������� ����
 * ���� ��� ���� ����..
 **/
function int getSkillIconType(int skill_id)
{

	local int returnV;

	returnV = 1;

	switch (skill_id)
	{
		// �� 
		case   0 :
		case   1 :
		case   2 :returnV = 1;
		break;

		// �ָ�
		case   3 :
		case   4 :
		case   5 : returnV = 2;
		break;

		default :

	}	

	return returnV;
}

defaultproperties
{
}
