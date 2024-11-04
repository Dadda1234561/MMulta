//------------------------------------------------------------------------------------------------------------------------
//
// ����        : DamageText  ( �������ؽ�Ʈ) - SCALEFORM UI - 
//
//------------------------------------------------------------------------------------------------------------------------
class DamageText extends GFxUIScript;

const FLASH_WIDTH  = 800;
const FLASH_HEIGHT = 600;

var int currentScreenWidth, currentScreenHeight;

enum EDamageTextType
{
	NOMAKE,                 // ������ 
	NormalAttack,           // �⺻ ����
	ConsecutiveAttack,      // ���� ���� (���� ������, ��Ʈ ������)
	Critical,               // ũ��Ƽ��
	OverHit,                // ������Ʈ
	RecoverHP,              // ȸ�� HP
	RecoverMP,              // ȸ�� MP
	GetSP,                  // SP �ޱ� 
	GetExp,                 // ����ġ �ޱ�
	MagicDefiance,          // ���� ���� 
	ShieldGuard,            // ���� ����
	Dodge,                  // ȸ��
	Immune,                 // �鿪
	SkillHit,               // ��ų ��Ʈ
	Etc                     // ��Ÿ
};

function OnRegisterEvent()
{
	// ������ �ؽ�Ʈ ����, ��ǥ ������Ʈ 
	RegisterEvent(EV_DamageTextCreate);
	RegisterEvent(EV_DamageTextUpdate);

	// �ý��� �޼����� ��ŷ�ϱ� ���� �̺�Ʈ
	// RegisterEvent(EV_SystemMessage);		
}

function OnLoad()
{
	registerState( "DamageText", "GamingState" );
	// class'UIAPI_WINDOW'.static.SetAnchor( "", "DamageText", "TopLeft", "BottomLeft", 0, 0 );
	SetAnchor("", EAnchorPointType.ANCHORPOINT_TopLeft, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0);
}

function OnShow()
{
	// Debug("DamageText!!!! onShow");
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_DamageText);
	SetAlwaysFullAlpha(true);
	IgnoreUIEvent(true);
}

function OnHide()
{
}

function OnCallUCLogic( int logicID, string param )
{
}

// 5370
// clipName=�׽�Ʈ111 unitType=1 valueType=1 value=500000 x=400 y=400 
// clipName=�׽�Ʈ111 unitType=2 bCritical=1 valueType=1 value=500000 x=400 y=400 
// clipName=�׽�Ʈ111 unitType=2 bCritical=0 valueType=1 value=500000 x=400 y=400  
// clipName=�׽�Ʈ111 unitType=2 bImmune bCritical=0 value=500000 x=400 y=400  
//

function OnEvent(int Event_ID, string param)
{		
	local string clipName;

	local int    unitType;	
	local int    xLoc, yLoc;

	local int    valueType, value, bCritical, bOverHit, 
				 bMagicDefense, bShieldDefense, bMiss, bContinuousAttack, bImmune, bSkillHit;

	local array<GFxValue> args;

	local GFxValue invokeResult;

	//  ���� npc �Ǵ� ĳ���� ���̵�
	local int nID;
	
	// debug("ConsecutiveAttack: " @ EDamageTextType.ConsecutiveAttack);

	// ���� �ػ󵵸� ��´�.
	GetCurrentResolution (currentScreenWidth, currentScreenHeight);	

	// ������ �ؽ�Ʈ ����
	if ( Event_ID == EV_DamageTextCreate)
	{	
		// Debug(" �ý��� �޼��� EV DamageText" @ Event_ID);
		// Debug(" Param : " @ param);

		ShowWindow();		
		
		// �ش� �ؽ�Ʈ�� �ν��Ͻ� ���� 
		// ParseString(param, "clipName"   , clipName);
		ParseInt(param, "clipName"   , nID);
		clipName = string(nID);


		//1 pc, 2 npc(target), 3 pet	// �ذ�
		ParseInt(param, "unitType"   , unitType);

		ParseInt(param, "valueType"        , valueType);
		ParseInt(param, "value"            , value);
		ParseInt(param, "bCritical"        , bCritical);
		ParseInt(param, "bOverHit"         , bOverHit);
		ParseInt(param, "bMagicDefense"    , bMagicDefense);
		ParseInt(param, "bShieldDefense"   , bShieldDefense);
		ParseInt(param, "bMiss"            , bMiss);
		ParseInt(param, "bContinuousAttack", bContinuousAttack);
		
		// �鿪 
		ParseInt(param, "bImmune"          , bImmune);

		// ��ų��Ʈ (�ѹ��� �������� ������.. ���������� �ٴٴٴٴ� ������ �� Ÿ�ݶ� ���� hit�� �ߵ��� �ϴ°�)
		ParseInt(param, "bSkillHit", bSkillHit);


		// �߻� ��ų x, y ��ǥ
		ParseInt(param, "x"         , xLoc);
		ParseInt(param, "y"         , yLoc);

		// ���ǿ� ���� ���� ��� 
		conditionalDamageText(clipName, unitType, xLoc, yLoc, 
							  valueType, value, bCritical, bOverHit, bMagicDefense, bShieldDefense, bMiss, bContinuousAttack, bImmune, bSkillHit);

		// Debug("Damage Text param: " @ param);

	}
	else if  ( Event_ID == EV_DamageTextUpdate )	
	{
		// Debug(" �ý��� ������Ʈ EV DamageText" @ Event_ID);
		// Debug(" Param : " @ param);
		// case 2 : updateMotion(data.clipName, data.x, data.y); break; 
		ShowWindow();
		// �ش� ������ �ؽ�Ʈ�� �ν��Ͻ� ����, 3d�󿡼� ������Ʈ�� �̵� ������ ���� �Ǵ� x, y ��ǥ ������Ʈ�� ����..
		// 
		// ParseString(param, "clipName"   , clipName);
		ParseInt(param, "clipName"   , nID);
		
		clipName = string(nID);

		// ��ǥ ������Ʈ
		ParseInt(param, "x"  , xLoc);
		ParseInt(param, "y"  , yLoc);

		// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
		AllocGFxValues(args, 2);		
		AllocGFxValue(invokeResult);

		// ������ �ؽ�Ʈ ����, �̺�Ʈ ��ȣ 1��
		args[0].SetInt(2);
			
		CreateObject(args[1]);
					
		args[1].SetMemberString("clipName", clipName);

		// args[1].SetMemberInt    ("x", xLoc - ((currentScreenWidth - FLASH_WIDTH) / 2));
		// args[1].SetMemberInt    ("y", yLoc - ((currentScreenHeight - FLASH_HEIGHT) / 2));

		args[1].SetMemberInt    ("x", xLoc);
		args[1].SetMemberInt    ("y", yLoc);

		Invoke("_root.onEvent", args, invokeResult);

		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);
	}
}

/*
// �ؽ�Ʈ Ÿ�� (���ϰ�)
// ǥ�� Ÿ��, �Ϲݰ���, ����, ������Ʈ ����..
// 1:�Ϲ� ����//�ذ�, 2:���� ����(��Ʈ ������), 3:ũ��Ƽ��//�ذ�, 4:������Ʈ, 5:HPȸ��, 6:MPȸ��
// 7:SP ����,   8:Exp ����ġ ����, 9:���� ���, 10:���� ���// �ذ�, 11:ȸ��, 12:�鿪, 13:��ų ��Ʈ
// �������� �������� � Ÿ���� �ؽ�Ʈ�� ���� �� �������� �����Ѵ�.
*/
function makeDamageText(string clipName, int unitType, int textType, int xLoc, int yLoc, string messageStr)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	if (textType != -1)
	{
		// �÷��� Ÿ�� ����Ÿ �ν��Ͻ� ����
		AllocGFxValues(args, 2);		
		AllocGFxValue(invokeResult);

		// ������ �ؽ�Ʈ ����, �̺�Ʈ ��ȣ 1��
		args[0].SetInt(1);
			
		CreateObject(args[1]);
					
		args[1].SetMemberString("clipName", clipName);
		args[1].SetMemberInt   ("unitType", unitType);
		args[1].SetMemberInt   ("textType", textType);

		args[1].SetMemberInt    ("x", xLoc);
		args[1].SetMemberInt    ("y", yLoc);

		args[1].SetMemberString("messageStr", messageStr);

		Invoke("_root.onEvent", args, invokeResult);

		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);
	}
}

// ���ǿ� ���� ������ ���
//
// ǥ�� Ÿ��, �Ϲݰ���, ����, ������Ʈ ����..
// 1:�Ϲ� ����//�ذ�, 2:���� ����(��Ʈ ������), 3:ũ��Ƽ��//�ذ�, 4:������Ʈ, 5:HPȸ��, 6:MPȸ��
// 7:SP ����,   8:Exp ����ġ ����, 9:���� ����, 10:���� ���// �ذ�, 11:ȸ��, 12:�鿪
function conditionalDamageText(string clipName, int unitType, int xLoc, int yLoc, 
							   int valueType, int value, int bCritical, int bOverHit, int bMagicDefense, 
							   int bShieldDefense, int bMiss, int bContinuousAttack, int bImmune, int bSkillHit)
{
	local int damageTextType;

	damageTextType = -1;

	// ValueType  
	// 0:None, �ƹ��͵� ����, 1:sp, 2:exp, 3:hp, 4:mp

	// hp , + �Ǹ� ȸ��, - �Ǹ� ���� ���� 
	if (valueType == 3)
	{		
		if (value >= 0)
		{
			// ȸ�� 
			damageTextType = EDamageTextType.RecoverHP; // 5
		}
		else
		{
			// �Ϲ� ����
			damageTextType = EDamageTextType.NormalAttack; // 1
		}	
		
		// ȸ��, ������ ���� ���� ���
		if (value != 0) makeDamageText(clipName, unitType, damageTextType, xLoc, yLoc, string(value));
	}
	// mp ȸ��
	else if (valueType == 4)
	{
		damageTextType = EDamageTextType.RecoverMP; // 6;
	}
	// sp ����
	else if (valueType == 1)
	{
		damageTextType = EDamageTextType.GetSP; // 7
	}
	// exp ����
	else if (valueType == 2)
	{
		damageTextType = EDamageTextType.GetExp;  // 8			
	}

	// 0���� ū ���� ��� �;� ���� ���, hp ���� ������ ������ ��� �����ϱ� ����
	if (value > 0 && valueType != 3) makeDamageText(clipName, unitType, damageTextType, xLoc, yLoc, string(value) );


	// ���� �ؽ�Ʈ ó��

	// �������
	if (bContinuousAttack == 1)
	{
		damageTextType = EDamageTextType.ConsecutiveAttack;
		makeDamageText(clipName, unitType, damageTextType, xLoc, yLoc, string(value) );
	}
	// ������Ʈ
	if (bOverHit == 1)
	{
		damageTextType = EDamageTextType.OverHit;
		makeDamageText(clipName, unitType, damageTextType, xLoc, yLoc, string(value) );
	}
	// ũ��Ƽ��
	if (bCritical == 1)
	{
		damageTextType = EDamageTextType.Critical;
		makeDamageText(clipName, unitType, damageTextType, xLoc, yLoc, string(value) );
	}
	// ���� ����
	if (bMagicDefense == 1)
	{
		damageTextType = EDamageTextType.MagicDefiance; // 9;
		makeDamageText(clipName, unitType, damageTextType, xLoc, yLoc, string(value) );
	}
	// ���� ���
	if (bShieldDefense == 1)
	{
		damageTextType = EDamageTextType.ShieldGuard; // 10;
		makeDamageText(clipName, unitType, damageTextType, xLoc, yLoc, string(value) );
	}
	// ȸ��
	if (bMiss == 1)
	{
		damageTextType = EDamageTextType.Dodge; // 11		
		makeDamageText(clipName, unitType, damageTextType, xLoc, yLoc, string(value) );
	}
	// �鿪 
	if (bImmune == 1)
	{
		damageTextType = EDamageTextType.Immune; // 12
		makeDamageText(clipName, unitType, damageTextType, xLoc, yLoc, string(value) );
	}
	// ��Ʈ (���ӱ� Ÿ��)
	if (bSkillHit != 0)
	{
		damageTextType = EDamageTextType.SkillHit; // 13
		makeDamageText(clipName, unitType, damageTextType, xLoc, yLoc, string(value) );
	}

}

defaultproperties
{
}
