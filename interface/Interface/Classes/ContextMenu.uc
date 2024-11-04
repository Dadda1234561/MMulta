/**
 *   ContextMenu ��Ŭ�� �޴�
 *   
 *   Ư���� ��������, ������ Ŭ���� �ϸ� Ÿ���� �⵵�� �ϴ� ��� ������
 *   Ÿ��UI�� �����ؼ� �۾��� �Ǿ���
 **/

class ContextMenu extends L2UIGFxScript;

const SPECIALTYPE_CHAT_ADDBLOCK = 1;
// ����
const ACHIEVEMENT          = 1;		
// ���λ��� - �Ǹ�
const PRIVATESHOP_SELL     = 2;
// ���λ��� - �ϰ��Ǹ�
const PRIVATESHOP_ALLSELL  = 3;		
// ���λ��� - ����
const PRIVATESHOP_BUY      = 4;
// ���� �ݱ�
const PRIVATESHOP_CLOSE    = 5;		
// ���� ���� 
const TRANSFORM_CANCEL     = 6;
// �ν��Ͻ� �� �̷�
const INSTANCEZONE_HISTORY = 7;
// ��ý�Ʈ
const ASSIST               = 8;		
// �ӼӸ�
const WHISPER              = 9;		
// ���� �ʴ�
const INVITE_CLAN          = 10;		
// ģ�� �ʴ� ��û
const INVITE_FRIEND        = 11;
// ��Ƽ �ʴ� 
const INVITE_PARTY         = 12;
		
// ¡ǥ
const TARGET_TOKEN1 = 13;
const TARGET_TOKEN2 = 14;
const TARGET_TOKEN3 = 15;
const TARGET_TOKEN4 = 16;

// �� ž��
const PET_ACTION_RIDE            = 17;
// �� �̵���� ��ȯ
const PET_ACTION_CHANGE_MOVEMODE = 18;
// �� ������
const PET_ACTION_RETURN          = 19;
// ���� ����
const SUMMON_DISPOSITION_PASSIVE = 20;
// ��� ����
const SUMMON_DISPOSITION_DEFENSE = 21;
// ��ȯ ����
const SUMMON_RETURN              = 25;

// ������ (Ż��)
const GETOFF                     = 22;
// ��ȯ
const TRADE                      = 23;
// Ÿ��Ʋ
const TITLE                      = 24;
// ����
const LINE                       = 10000;		

// ��Ƽ (��ü, Ż��, �߹�, ��Ƽ�� ����)
const PARTY_BREAK_UP             = 26;
const PARTY_LEAVE                = 27;
const PARTY_BANISH               = 28;
const PARTY_LEADER_CHANGE        = 29;

// �Ϲ� ���� 
const MANUFACTURE_COMMON = 30;

// ����� ����
const MANUFACTURE_DWARF = 31;		

// ž���� ���� ����
const TRANSFORM_RIDE_CANCEL = 32;

// ��Ŭ�� �޴� �̺�Ʈ ����
struct ContextMenuInfo
{
	var string Name;
	var int ID;
	var int X;
	var int Y;	
};

// UI
var InviteClanPopWnd InviteClanPopWndScript;
var TargetStatusWnd  TargetStatusWndScript;
var PrivateShopWnd   PrivateShopWndScript;
var SummonedWnd      SummonedWndScript;

// struct
var ContextMenuInfo m_contextMenuInfo;

/**
 *  OnRegisterEvent
 **/
function OnRegisterEvent()
{	
	RegisterGFxEvent(EV_ContextMenu);

	RegisterEvent(EV_Restart);
}

/**
 *  OnEvent
 **/
function OnEvent(int Event_ID, string param)
{
//	Debug(" param : " @ param);

	
	if (Event_ID == EV_Restart )
	{
		//Debug("EV_Restart");
		clearInfo();
	}
}

/**
 *  OnLoad
 **/
function OnLoad()
{	
	registerState("ContextMenu", "GamingState" );
	SetHavingFocus(false);	
	SetAnchor("", EAnchorPointType.ANCHORPOINT_TopLeft, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0 );	
	setDefaultShow(true);

	// UC Script
	PrivateShopWndScript   = PrivateShopWnd(GetScript("PrivateShopWnd"));
	InviteClanPopWndScript = InviteClanPopWnd(GetScript("InviteClanPopWnd"));
	SummonedWndScript      = SummonedWnd(GetScript("SummonedWnd"));
	TargetStatusWndScript  = TargetStatusWnd(GetScript("TargetStatusWnd"));
}

/**
 *  OnFlashLoaded
 **/
function OnFlashLoaded()
{
	SetRenderOnTop(true);
}

/**
 *  OnHide
 **/
function OnHide()
{
	clearInfo();
	SetHavingFocus(false);
}

/**
 *  �� Ŭ�� �޴� �̺�Ʈ ���� �߻� Event
 **/
function execContextEvent(string creatureName, int CreatureID, int locX, int locY, optional int specialType, optional string etcParam)
{
    local string strParam;

    ParamAdd(strParam, "ID", string(CreatureID));
    ParamAdd(strParam, "Name", creatureName);
    ParamAdd(strParam, "X", string(locX));
    ParamAdd(strParam, "Y", string(locY));
    ParamAdd(strParam, "SpecialType", string(specialType));
    ParamAdd(strParam, "EtcParam", etcParam);
	//Debug("EV_ContextMenu : " @ strParam);
    ExecuteEvent(EV_ContextMenu, strParam);
	//Debug("EV_ContextMenu : " @ strParam);
}

/**
 *  SWF -> UC ����
 **/
function onCallUCFunction( string functionName, string param )
{
	switch ( functionName )
	{
		case "processCommand" :
			//nCanUseAP = int(param);
			processCommand(param);
			break;

		case "contextMenuEventInfo" :
			saveInfo(param);			
			break;

		//case "closeContextMenu" :
		//	if (GetWindowHandle("TargetStatusWnd").IsShowWindow()) 
		//	{
		//		// Debug("Ÿ������ ��Ŀ�� �ֱ� ");
		//		GetWindowHandle("TargetStatusWnd").SetFocus();
		//	}

		//	break;

	}
}

/**
 *  ���ؽ�Ʈ �̺�Ʈ ���� ����
 **/
function saveInfo(string param)
{
	// Debug("���� ����" @ param);
	ParseString (param, "Name", m_contextMenuInfo.Name );
	ParseInt (param, "ID", m_contextMenuInfo.ID );	
	ParseInt (param, "X", m_contextMenuInfo.X );
	ParseInt (param, "Y", m_contextMenuInfo.Y );
	

	// Debug("���� m_contextMenuInfo.Name" @ m_contextMenuInfo.Name);
}

/**
 *  ���ؽ�Ʈ �̺�Ʈ ���� �ʱ�ȭ
 **/
function clearInfo()
{
	// Debug("���� Ŭ����");
	m_contextMenuInfo.Name = "";
	m_contextMenuInfo.ID = 0;
	m_contextMenuInfo.X = 0;
	m_contextMenuInfo.Y = 0;	
}

/**
 * ���� ������ ���ؽ�Ʈ �޴� �̺�Ʈ�� ������ ����
 **/ 
function ContextMenuInfo getContextEventInfo()
{
	return m_contextMenuInfo;
}

/**
 *  ������ ���ؽ�Ʈ �޴��� ������ �޴��� �����Ѵ�.
 **/
function makeContextMenu()
{
	if (m_contextMenuInfo.ID > 0)
	{
		// Debug("m_contextMenuInfo.Name" @ m_contextMenuInfo.Name);

		execContextEvent(m_contextMenuInfo.Name, m_contextMenuInfo.ID, m_contextMenuInfo.X, m_contextMenuInfo.Y);
	}
}

/**
 *  ���ؽ�Ʈ ��� ���� 
 **/
function processCommand(string param)
{
	local int menuItemType, targetID;
	local string userName;
	local UserInfo targetUserInfo;
	local ItemInfo skillInfo;
//	Debug("UC ���� ��ư" @ param);

	// �߸��� targetID ���.. ����.
	// if (targetID <= 0) return;

	ParseInt (param, "menuItemType", menuItemType );
	ParseInt (param, "ID", targetID );	
	ParseString (param, "Name", userName );
	Debug("targetID" @ string(targetID));
	Debug("userName" @ UserName);

	switch (menuItemType)
	{

		case ACHIEVEMENT :   // ����, �� (���� ���Ե��� ����)
			 break;

		case PRIVATESHOP_SELL :   
			 ExecuteCommandFromAction("vendor");
			 break;

		case PRIVATESHOP_ALLSELL :   
			 ExecuteCommandFromAction("packagevendor");
			 break;

		case PRIVATESHOP_BUY :   
			 ExecuteCommandFromAction("buy");			 
			 break;

		case PRIVATESHOP_CLOSE : 			 
			 //PrivateShopWndScript.OnClickButton("StopButton");
			 PrivateShopWndScript.contextMenuQuit();
			 break;

		case TRANSFORM_RIDE_CANCEL : // (ž����) ��������
			 // ��ų ���̵� (���� ����)
			 skillInfo.ID.ClassID = 9210;
			 skillInfo.ID.ServerID = 0;
			 UseSkill(skillInfo.ID, int(EShortCutItemType.SCIT_SKILL));
			 break;

		case TRANSFORM_CANCEL :   
			 // ��ų ���̵� (���� ����)
			 skillInfo.ID.ClassID = 619;
			 skillInfo.ID.ServerID = 0;
			 
			 UseSkill(skillInfo.ID, int(EShortCutItemType.SCIT_SKILL));
			 break;

		case INSTANCEZONE_HISTORY :   
			 RequestInzoneWaitingTime();
			 break;

		case ASSIST :			 
			 GetUserInfo(targetID, targetUserInfo);

//			 Debug("targetUserInfox" @ targetUserInfo.Loc.x);
			 //Debug("targetUserInfoy" @ targetUserInfo.Loc.y);

			 RequestAssist(targetID, targetUserInfo.loc);  

			 break;

		case WHISPER :
			 whisperToUser(userName);
			 break;

		case INVITE_CLAN :
			// Ŭ����
			 if ( getInstanceUIData().getisClassicServer() )
			{
				RequestClanAskJoinByName(UserName,0);
			}
			else
			{
				// ���̺�
				//GetINIBool ( "Localize", "UsePledgeV2Live", nUsePledgeV2Live, "L2.ini" );

				// ���� ������ UI ���
				if (getInstanceL2Util().isClanV2())
				{
					RequestClanAskJoin(targetID, 0);
					// RequestClanAskJoinByName(userName, 0);
				}
				else
				{
					//targetID �־� ��� �� ���� ����.
					InviteClanPopWndScript.showByPersonalConnectionsWndUsingUserName(userName);
				}
			 }

			 break;

		case INVITE_FRIEND : 
			 class'PersonalConnectionAPI'.static.RequestAddFriend(userName);						
			 break;

		case INVITE_PARTY :  
//			 Debug("userName" @ userName);
			 //RequestInviteParty(userName);
			 //- ����, ���˶����� TargetID�� ����, 2018-12-04
			 RequestInvitePartyByTargetID(targetID);
			 
			 break;

		case TARGET_TOKEN1 :   
			 ExecuteCommandFromAction("tacticalsign1");
			 break;

		case TARGET_TOKEN2 :   
			 ExecuteCommandFromAction("tacticalsign2");
			 break;

		case TARGET_TOKEN3 :   
			 ExecuteCommandFromAction("tacticalsign3");
			 break;

		case TARGET_TOKEN4 :   
			 ExecuteCommandFromAction("tacticalsign4");
			 break;

		case PET_ACTION_RIDE :  
			 ExecuteCommandFromAction("mountdismount");
			 break;

		case PET_ACTION_CHANGE_MOVEMODE :  
			 ExecuteCommandFromAction("pethold"); 
			 break;

		case PET_ACTION_RETURN :  
			 ExecuteCommandFromAction("petrevert"); 			 
//			 Debug("petrevert");
			 break;

		case SUMMON_DISPOSITION_PASSIVE :   
			 //SummonedWndScript.OnClickItem("SummonedActionWnd2", 0);
			 DoAction( class'UICommonAPI'.static.GetItemID(1104) ); // ����
			 break;

		case SUMMON_DISPOSITION_DEFENSE : 
			 // SummonedWndScript.OnClickItem("SummonedActionWnd2", 1);
			 DoAction( class'UICommonAPI'.static.GetItemID(1103) ); // ���
			 break;

		case SUMMON_RETURN :   
//			 Debug("unsummon");
			 ExecuteCommandFromAction("unsummon"); 
			 break;

		case TRADE :   
			 ExecuteCommandFromAction("trade"); 
			 break;

		case GETOFF :   
			 ExecuteCommandFromAction("mountdismount"); 
			 break;

		case PARTY_BREAK_UP :   
			 // ���� ������ �ȵǾ� ����, �߱� ���� �Ǿ� ����;
			 // ExecuteCommandFromAction("partybreakup");
			 break;

		case PARTY_LEAVE :   
			 ExecuteCommandFromAction("partyleave"); 
			 break;

		case PARTY_BANISH :   
			 ExecuteCommandFromAction("partydismiss"); 
			 break;

		case PARTY_LEADER_CHANGE :
			 ExecuteCommandFromAction("leaderchange"); 
			 break;

		case MANUFACTURE_COMMON :   
			 ExecuteCommandFromAction("manufacture2"); 
			 break;

		case MANUFACTURE_DWARF :   			 
			 ExecuteCommandFromAction("manufacture"); 
			 break;
	}
}

//�ӼӸ��ϱ�
function whisperToUser(string userName)
{
	local ChatWnd chatWndScript;
	if (userName != "")
	{
		//callGFxFunction("ChatMessage", "sendWhisper", userName);
		//Ŭ���� �ӼӸ� Ȯ��
		chatWndScript = ChatWnd(GetScript("ChatWnd"));
		chatWndScript.SetChatEditBox("\"" $ userName $ " ");
	}
}

/**
 *  �� Ŭ�� �޴��� ���� �ֳ�?
 **/
function bool isShowContextMenu()
{
	local bool bShow;
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 1);
	args[0].setbool(false);

	AllocGFxValue(invokeResult);
		
	Invoke("_root.isShowContextMenu", args, invokeResult);
	bShow = invokeResult.GetBool();

	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);

	return bShow;
}

/**
 *  OnFocus
 *  ��Ŀ���� ������ �� Ŭ�� �޴� ���� �ϵ��� �Ǿ� ����
 **/
function OnFocus(bool bFlag, bool bTransparency)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;
	// local UserInfo userInfo;

	//if (GetTargetInfo(userInfo))
	//{
	//	Debug("Ÿ���� �ִ� ����");
	//}
	//else
	//{
	//	Debug("Ÿ���� ���� ����");
	//}

	AllocGFxValues(args, 2);	
	args[0].setbool(bflag);
	args[1].setbool(bTransparency);
	AllocGFxValue(invokeResult);

	Invoke("_root.onFocus", args, invokeResult);

	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);


	if (!bFlag) SetHavingFocus(false);
}

defaultproperties
{
}
