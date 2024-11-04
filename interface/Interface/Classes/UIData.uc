/**
 *   UI ����Ÿ ���� 
 *   
 *   �߱� ������ ������ ��� �ϴ� UI ���� ����Ÿ ����, 
 *   ��κ� ���� �ϰ� �ѱ����� �߰� �� �ʿ䰡 ������ �߰� �ϱ�..
 *   
 **/
class UIData extends UICommonAPI;

// �ػ�
var int currentScreenWidth;
var int currentScreenHeight;
//var bool isClassicServer;

var string roleTypeStr;
var string classDescription;

// ������ üũ�� ���� ������
var userinfo prevUserInfo, currUserInfo;

// �� ��Ƽâ�� ���� �ִ� �ִ� ��Ƽ���� ��.
const               NEW_PARTY_MAXCOUNT = 7;
var int             MAXLV ;
const               MAXLV2DISPLAY = 199;


const HUNTINGZONE_MAXCOUNT = 500;
const RAID_MAXCOUNT = 2000;
const RAID_MIN = 0;

const RAID_BLOODY_MAXCOUNT = 2500;
const RAID_BLOODY_MIN = 1001;

//��Ȱ �� �ִ� ����
const ROLETYPEMAX = 9;
const ROLETYPEMAX_ADEN = 13;

/************************************************** �Ʒ��� * ************************************************/
// ������ ���� ID
const TRANSFORMID_DRAGONSLAYER = 11;
const TRANSFORMID_DRAGON = 10;

// NEW 245
const CASTLE_NUM_TOTAL = 2;
const PEACE_ZONE_TYPE = 11;

// �����ϰ� �ִ� �Ƶ��� ����
var Int64 adenaCount;

// pc�� ����Ʈ
var int   pcCafePoint;
var bool bIsPcCafe;

// ���� ����Ʈ
var int clanNameValue;
var int craftPoint;
var INT64 nVitalityPoint;
var INT64 nSP;
// getUCProperty �� ���� ���� �������� ���� �ӽ� ��
var int tmpDataInt;
var string tmpDataString;
var bool tmpDataBoolean;
var string preState;
var int teleportFreeLevel;
var int clientStartSec;
var int serverStartTime;
var int serverTimeZone;
var int clientTimeZone;
var int daylightSeconds;
var private L2UITimerObject timer24Object;

static function UIData Inst()
{
	return UIData(GetScript("UIData"));
}

event OnLoad()
{
	// �ػ� ����
	updateCurrentResolution();
	MAXLV = GetMaxLevel();
	SetBuilderPC();
	timer24Object = class'L2UITimer'.static.Inst()._AddNewTimerObject(((1000 * 60) * 60) * 24, -1);
	timer24Object._DelegateOnTime = DelegateOnTime24;
}

private function DelegateOnTime24(int t)
{
	API_SendWindowsInfo();
	Debug(" ------- �ð� ����." @ string(t) @ string(timer24Object._curCount) @ string(timer24Object._time));	
}

event OnRegisterEvent()
{
	RegisterEvent(EV_ResolutionChanged);
	RegisterEvent(EV_NeedResetUIData);

	RegisterEvent(EV_PCCafePointInfo);	
	RegisterEvent(EV_ClanInfo);	
	RegisterEvent(EV_PreUpdateUserInfo);	

	RegisterEvent(EV_NotifyBeforeStateChanged);

	// NEW 245
	RegisterEvent(EV_CurrentServerTime);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_CRAFT_INFO));
	RegisterEvent(EV_RESTART);
	RegisterEvent(EV_TeleportFreeLevel);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_SetMaxCount);
}

/** onEvent */
event OnEvent(int Event_ID, string param)
{
	local UserInfo UserInfo;

	switch(Event_ID)
	{
		// End:0x18
		case EV_ResolutionChanged:
			updateCurrentResolution();
			// End:0x1A4
			break;
		// End:0x3D
		case EV_NeedResetUIData:
			MAXLV = GetMaxLevel();
			clanNameValue = 0;
			pcCafePoint = 0;
			// End:0x1A4
			break;
		// End:0x53
		case EV_PCCafePointInfo:
			pcCafePointInfoHandler(param);
			// End:0x1A4
			break;
		// End:0x69
		case EV_ClanInfo:
			updateClanInfoHandler(param);
			// End:0x1A4
			break;
		// End:0x77
		case EV_PreUpdateUserInfo:
			swapPrevUserInfo();
			// End:0x1A4
			break;
		// End:0x8D
		case EV_NotifyBeforeStateChanged:
			preState = param;
			// End:0x1A4
			break;
		// End:0x143
		case EV_CurrentServerTime:
			ParseInt(param, "ServerTime", serverStartTime);
			ParseInt(param, "ServerTimeZone", serverTimeZone);
			ParseInt(param, "ClientTimeZone", clientTimeZone);
			ParseInt(param, "DaylightSeconds", daylightSeconds);
			clientStartSec = int(GetAppSeconds());
			if(GetReleaseMode() == RM_DEV)
			{
				Debug("���� ���� ���� ");
				API_SendWindowsInfo();
				timer24Object._Reset();
			}
			// End:0x1A4
			break;
		// End:0x163
		case EV_PacketID(class'UIPacket'.const.S_EX_CRAFT_INFO):
			ParsePacket_S_EX_CRAFT_INFO();
			// End:0x1A4
			break;
		// End:0x191
		case EV_TeleportFreeLevel:
			ParseInt(param, "TeleportFreeLevel", teleportFreeLevel);
			// End:0x1A4
			break;
		// End:0x1A1
		case EV_Restart:
			bIsPcCafe = false;
			if(GetReleaseMode() == RM_DEV)
			{
				timer24Object._Stop();
			}
			break;
		// End:0x1B2
		case EV_SetMaxCount:
			SaveBuilderPCDatas();
			// End:0x1B5
			break;
		case EV_UpdateUserInfo:
			// End:0x1D7
			if(GetPlayerInfo(UserInfo))
			{
				nVitalityPoint = UserInfo.nVitality;
				nSP = UserInfo.nSP;
			}
			// End:0x1DD
			break;
	}
}

event OnCallUCFunction(string Id, string param)
{
	switch(Id)
	{
		// End:0x2F
		case "setRoleType":
			tmpDataInt = GetClassRoleType(int(param));
			// End:0xBB
			break;
		// End:0x52
		case "setRoleTypeStr":
			setRoleTypeStr(int(param));
			// End:0xBB
			break;
		// End:0x80
		case "GetClassDescription":
			classDescription = GetClassDescription(int(param));
			// End:0xBB
			break;
		// End:0x9C
		case "setUCData":
			tmpDataString = param;
			// End:0xBB
			break;
		// End:0xB8
		case "getUCData":
			getData(param);
			// End:0xBB
			break;
	}
}

function SaveBuilderPCDatas()
{
	// End:0x120
	if(IsBuilderPC())
	{
		SetINIInt("UIData", "serverStartTime", serverStartTime, "UIDEV.ini");
		SetINIInt("UIData", "serverTimeZone", serverTimeZone, "UIDEV.ini");
		SetINIInt("UIData", "clientTimeZone", clientTimeZone, "UIDEV.ini");
		SetINIInt("UIData", "daylightSeconds", daylightSeconds, "UIDEV.ini");
		SetINIInt("UIData", "clientStartSec", clientStartSec, "UIDEV.ini");
		GetINIInt("UIData", "serverStartTime", serverStartTime, "UIDEV.ini");
	}
}

function SetBuilderPC()
{
	// End:0x0D
	if(! IsBuilderPC())
	{
		return;
	}
	GetINIInt("UIData", "serverStartTime", serverStartTime, "UIDEV.ini");
	GetINIInt("UIData", "serverTimeZone", serverTimeZone, "UIDEV.ini");
	GetINIInt("UIData", "clientTimeZone", clientTimeZone, "UIDEV.ini");
	GetINIInt("UIData", "daylightSeconds", daylightSeconds, "UIDEV.ini");
	GetINIInt("UIData", "clientStartSec", clientStartSec, "UIDEV.ini");
	resetUIData();
}

// UI ���� UIRebuild �� ���� �ʱ�ȭ������ ��� 
// �߰� �� �� ������ ��� �߰� �ؾ���.
function resetUIData()
{
	ExecuteEvent(EV_NeedResetUIData, "");
	ExecuteEvent(EV_ResolutionChanged, "");
	ExecuteEvent(EV_GameStart, "");

	// �κ� ����Ʈ
	RequestItemList();

	// Ŭ���ĸ�.. ���̺�� �������� api
	if(getIsClassicServer())
		class'UIDATA_CLAN'.static.RequestClanInfo();
}

//  script ���� �ν��ϴ� ���� int ���� �̹Ƿ�, 999999999999�� ���� ��� int �� ��ȯ �ȴ�.
function INT64 getMaxAdena()
{
	return int64("999999999999"); // 9999�� ��
}

// NEW/EDIT 245
function L2UITime GetCurrentRealLocalTime()
{
	local L2UITime currentRealLocalTimeStruct;

	GetTimeStruct(GetCurrentRealLocalTimeSec(), currentRealLocalTimeStruct);
	return currentRealLocalTimeStruct;
}

function int GetCurrentRealLocalTimeSec()
{
	return (((serverStartTime + (GameConnectTimeSec())) - clientTimeZone) + serverTimeZone) - daylightSeconds;	
}

function int GameConnectTimeSec()
{
	return int(GetAppSeconds()- clientStartSec);
}

function string gameConnectTimeString()
{
	return MakeTimeStr(GameConnectTimeSec());
}

function string getCurrentRealLocalTimeString()
{
	local L2UITime timeStruct;

	GetTimeStruct(GetCurrentRealLocalTimeSec(), timeStruct);
	return getMakeTimeString(timeStruct);
}

function string getCurrentServerTimeString()
{
	local L2UITime timeStruct;

	GetTimeStruct(int((float(serverStartTime) + (GetAppSeconds())) - float(clientStartSec)), timeStruct);
	return getMakeTimeString(timeStruct);
}

function string getMakeTimeString(L2UITime timeStruct)
{
	local string Str;

	Str = timeStruct.nYear $ "/" $ Int2Str(timeStruct.nMonth) $ "/" $ Int2Str(timeStruct.nDay) $ " " $ Int2Str(timeStruct.nHour) $ ":" $ Int2Str(timeStruct.nMin);
	return Str;
}

function string getMakeTimeStringDHM(L2UITime timeStruct)
{
	local string Str;

	if(timeStruct.nDay > 0)
		Str = MakeFullSystemMsg(GetSystemMessage(7393),string(timeStruct.nDay))$ ", ";

	if(timeStruct.nHour > 0)
		Str = Str $ MakeFullSystemMsg(GetSystemMessage(2204),string(timeStruct.nHour))$ ", ";

	if((timeStruct.nDay == 0)&&(timeStruct.nHour == 0)&&(timeStruct.nMin == 0))
		Str = Str $ MakeFullSystemMsg(GetSystemMessage(4360),"1");
	else
		Str = Str $ MakeFullSystemMsg(GetSystemMessage(7395),string(timeStruct.nMin));

	return Str;
}

function bool getIsPcCafe()
{
	return bIsPcCafe;
}

//� ������ �Ǵ� ���߿� �ѹ��� �ٲ� �� �ֵ��� 
function bool getIsLiveServer()
{
	return GetServerType() == 1;
}

//� ������ �Ǵ� ���߿� �ѹ��� �ٲ� �� �ֵ��� 
function bool getIsClassicServer()
{
	// isClassicServer �� ���� �Ǿ� GetServer �� ��ü 
	return GetServerType() == 2;
}

//� ������ �Ǵ� ���߿� �ѹ��� �ٲ� �� �ֵ��� 
function bool getIsArenaServer()
{
	return GetServerType() == 3;
}

// �������� �ƴ��� �ľ��ϴ� �Լ� 
function bool isPawnChanged()
{
	// End:0x1B
	if(prevUserInfo.nID != currUserInfo.nID)
	{
		return false;
	}
	return prevUserInfo.m_bPawnChanged != currUserInfo.m_bPawnChanged;
}

// Ż �� 
function bool isMount()
{
	// End:0x1B
	if(prevUserInfo.nID != currUserInfo.nID)
	{
		return false;
	}
	// End:0x2B
	if(currUserInfo.m_bPawnChanged)
	{
		return false;
	}
	return(prevUserInfo.nTransformID == 0 && currUserInfo.nTransformID > 0);
}

// ������ ���
function bool isDismoust()
{
	// End:0x1B
	if(prevUserInfo.nID != currUserInfo.nID)
	{
		return false;
	}
	// End:0x2B
	if(currUserInfo.m_bPawnChanged)
	{
		return false;
	}
	return (prevUserInfo.nTransformID > 0) && currUserInfo.nTransformID == 0;
}

// ���������� �ƴ��� �ľ��ϴ� �Լ�.
function bool isLevelUP()
{
	// End:0x1B
	if(prevUserInfo.nID != currUserInfo.nID)
	{
		return false;
	}
	return prevUserInfo.nLevel < currUserInfo.nLevel;
}

function bool IsLevelDown()
{
	// End:0x1B
	if(prevUserInfo.nID != currUserInfo.nID)
	{
		return false;
	}
	return prevUserInfo.nLevel > currUserInfo.nLevel;
}

function bool _IsParty(string Name)
{
	// End:0x15
	if(getIsClassicServer())
	{
		return isPartyClassic(Name);
	}
	return isPartyLive(Name);	
}

private function bool isPartyClassic(string Name)
{
	local int i;
	local PartyWndClassic partyWndClassicScript;

	partyWndClassicScript = PartyWndClassic(GetScript("partyWndClassic"));
	Debug("Ŭ���� �� �� ���� ��????" @ string(partyWndClassicScript.const.MAX_ArrayNum));

	// End:0xA1 [Loop If]
	for(i = 0; i < partyWndClassicScript.const.MAX_ArrayNum; i++)
	{
		// End:0x97
		if(partyWndClassicScript.m_PlayerName[i].GetName() == Name)
		{
			return true;
		}
	}
	return false;	
}

private function bool isPartyLive(string Name)
{
	local int i;
	local PartyWnd partywndscript;

	partywndscript = PartyWnd(GetScript("partywnd"));
	Debug("���̺� �� �� ���� ��????" @ string(partywndscript.const.MAX_ArrayNum));

	// End:0x9A [Loop If]
	for(i = 0; i < partywndscript.const.MAX_ArrayNum; i++)
	{
		// End:0x90
		if(partywndscript.m_PlayerName[i].GetName() == Name)
		{
			return true;
		}
	}
	return false;	
}

// ģ�� ���� 
function bool isFriend(string Name)
{
	local PersonalConnectionsWnd personalConnectionsWndScript;
	local L2Util l2utilScript;

	personalConnectionsWndScript = PersonalConnectionsWnd(GetScript("PersonalConnectionsWnd"));
	l2utilScript = L2Util(GetScript("L2Util"));
	return l2utilScript.ctrlListSearchByName(personalConnectionsWndScript.FriendList, Name) != -1;
}

function bool _IsBlocked(string Name)
{
	local PersonalConnectionsWnd personalConnectionsWndScript;
	local L2Util l2utilScript;

	personalConnectionsWndScript = PersonalConnectionsWnd(GetScript("PersonalConnectionsWnd"));
	l2utilScript = L2Util(GetScript("L2Util"));
	return l2utilScript.ctrlListSearchByName(personalConnectionsWndScript.BlockList, Name) != -1;	
}

function int getMyNobless()
{
	local UserInfo Info;

	// End:0x16
	if(! GetPlayerInfo(Info))
	{
		return -1;
	}
	return Info.nNobless;
}

function bool getbHero()
{
	local UserInfo Info;

	// End:0x12
	if(! GetPlayerInfo(Info))
	{
		return false;
	}
	return Info.bHero;
}

function bool IsTeleportFreeLevel()
{
	local UserInfo uInfo;

	// End:0x12
	if(! GetPlayerInfo(uInfo))
	{
		return false;
	}

	return uInfo.nLevel <= teleportFreeLevel;
}

function INT64 GetTeleportPriceByID(int Id)
{
	local TeleportListAPI.TeleportListData listData;

	if(IsTeleportFreeLevel())
		return 0;

	listData = Class'TeleportListAPI'.static.GetFirstTeleportListData();

	while("" != listData.Name)
	{
		if(listData.Id == Id)
		{
			return listData.Price[0].Amount;
		}

		listData = Class'TeleportListAPI'.static.GetNextTeleportListData();
	}
	return -1;
}

function string GetTeleportPlaceNameByID(int Id)
{
	local TeleportListAPI.TeleportListData listData;

	listData = class'TeleportListAPI'.static.GetFirstTeleportListData();

	// End:0x5D [Loop If]
	while("" != listData.Name)
	{
		// End:0x45
		if(listData.Id == Id)
		{
			return listData.Name;
		}
		listData = class'TeleportListAPI'.static.GetNextTeleportListData();
	}
	return "";
}

function int GetTeleportIDByXYZ(int X, int Y, int Z, optional bool bOnlyTown)
{
	local TeleportListAPI.TeleportListData listData;
	local Vector Loc;
	local string locZoneName;

	Loc.X = float(X);
	Loc.Y = float(Y);
	Loc.Z = float(Z);
	locZoneName = GetZoneNameWithLocation(Loc);
	listData = class'TeleportListAPI'.static.GetFirstTeleportListData();

	// End:0xF2 [Loop If]
	while("" != listData.Name)
	{
		// End:0xBB
		if(bOnlyTown)
		{
			// End:0xB8
			if(listData.Priority == 1 || listData.Priority == 2)
			{
				// End:0xB8
				if(listData.Name == locZoneName)
				{
					return listData.Id;
				}
			}			
		}
		else if(listData.Name == locZoneName)
		{
			return listData.Id;
		}
		listData = class'TeleportListAPI'.static.GetNextTeleportListData();
	}
	return -1;
}

function TeleportListAPI.TeleportListData GetTeleportListDataByID(int Id)
{
	local TeleportListAPI.TeleportListData listData, emptyData;

	listData = class'TeleportListAPI'.static.GetFirstTeleportListData();

	// End:0x58 [Loop If]
	while("" != listData.Name)
	{
		// End:0x40
		if(listData.Id == Id)
		{
			return listData;
		}
		listData = class'TeleportListAPI'.static.GetNextTeleportListData();
	}
	return emptyData;
}

function ParsePacket_S_EX_CRAFT_INFO()
{
	local UIPacket._S_EX_CRAFT_INFO packet;

	if( !Class'UIPacket'.static.Decode_S_EX_CRAFT_INFO(packet))
	{
		return;
	}

	setCurrentCraftPoint(packet.nPoint);
	RandomCraftChargingWnd(GetScript("RandomCraftChargingWnd")).ParsePacket_S_EX_CRAFT_INFO(packet);
	RandomCraftWnd(GetScript("RandomCraftWnd")).ParsePacket_S_EX_CRAFT_INFO(packet);
	BottomBar(GetScript("BottomBar")).Nt_S_EX_CRAFT_INFO(packet);	
}

// ���� ���� ������ ���� ���� ������ ��ü �ϴ� �Լ�
function swapPrevUserInfo()
{
	prevUserInfo = currUserInfo;
	GetPlayerInfo(currUserInfo);
}

function updateClanInfoHandler(string param)
{
	ParseInt(param, "ClanNameValue", clanNameValue);   // ��������Ʈ
}

function pcCafePointInfoHandler(string param)
{
	local int nShow;

	ParseInt(param, "TotalPoint", pcCafePoint);
	ParseInt(param, "Show", nShow);
	bIsPcCafe = true;
}

function setCurrentClanNameValue(int point)
{
	clanNameValue = point;
}

function int getCurrentClanNameValue()
{
	return clanNameValue;
}

function INT64 getCurrentVitalityPoint()
{
	return nVitalityPoint;	
}

function INT64 getCurrentSP()
{
	return nSP;	
}

function setCurrentVitalityPoint(int point)
{
	nVitalityPoint = point;	
}

function setPcCafePoint(int point)
{
	pcCafePoint = point;
}

function int getCurrentPcCafePoint()
{
	return pcCafePoint;
}

function setCurrentCraftPoint(int point)
{
	craftPoint = point;
}

function int getCurrentCraftPoint()
{
	return craftPoint;
}

/** �ػ� */
function updateCurrentResolution()
{
	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
}

function int getScreenWidth()
{
	// ���� ����� �ȳ־��� �����ΰɷ� ���� �ϰ� ������Ʈ 
	// End:0x11
	if(currentScreenWidth <= 0)
	{
		updateCurrentResolution();
	}

	return currentScreenWidth;
}

function int getScreenHeight()
{
	// ���� ����� �ȳ־��� �����ΰɷ� ���� �ϰ� ������Ʈ 
	// End:0x11
	if(currentScreenWidth <= 0)
	{
		updateCurrentResolution();
	}

	return currentScreenHeight;
}

function setRoleTypeStr(int ClassID)
{
	roleTypeStr = GetClassRoleName(ClassID);
}

function getData(string DataName)
{
	switch(DataName)
	{
		// End:0x28
		case "GameStateName":
			tmpDataString = GetGameStateName();
			// End:0x2CF
			break;
		// End:0x44
		case "nNobless":
			tmpDataInt = getMyNobless();
			// End:0x2CF
			break;
		// End:0x5E
		case "bHero":
			tmpDataBoolean = getbHero();
			// End:0x2CF
			break;
		// End:0x85
		case "roleIconName":
			tmpDataString = GetClassRoleIconName(int(tmpDataString));
			// End:0x2CF
			break;
		// End:0xAF
		case "roleBigIconName":
			tmpDataString = GetClassRoleIconNameBig(int(tmpDataString));
			// End:0x2CF
			break;
		// End:0xDB
		case "arenaRoleIconName":
			tmpDataString = GetClassArenaRoleIconName(int(tmpDataString));
			// End:0x2CF
			break;
		// End:0x10D
		case "ClassRoleNameByRole":
			tmpDataString = GetClassRoleNameByRole(EClassRoleType(int(tmpDataString)));
			// End:0x2CF
			break;
		// End:0x13C
		case "GetUserName":
			tmpDataString = class'UIDATA_USER'.static.GetUserName(int(tmpDataString));
			// End:0x2CF
			break;
		// End:0x16D
		case "GetPartyMemberLocationWithID":
			setGetPartyMemberLocationWithID(int(tmpDataString));
			// End:0x2CF
			break;
		// End:0x19F
		case "GetItemNameAllBySeverID":
			tmpDataString = GetItemNameAllBySeverID(int(tmpDataString));
			// End:0x2CF
			break;
		// End:0x1D1
		case "GetItemGradeTextureName":
			tmpDataString = GetItemGradeTextureName(int(tmpDataString));
			// End:0x2CF
			break;
		// End:0x1F6
		case "GetIsFriend":
			tmpDataBoolean = isFriend(tmpDataString);
			// End:0x2CF
			break;
		// End:0x21F
		case "GetUIUserPremiumLevel":
			tmpDataInt = GetUIUserPremiumLevel();
			// End:0x2CF
			break;
		// End:0x246
		case "GetServerTimeString":
			tmpDataString = getCurrentServerTimeString();
			// End:0x2CF
			break;
		// End:0x26C
		case "GetLocalTimeString":
			tmpDataString = getCurrentRealLocalTimeString();
			// End:0x2CF
			break;
		// End:0x2A0
		case "IsStackableItemByClassID":
			tmpDataBoolean = IsStackableItemByClassID(int(tmpDataString));
			// End:0x2CF
			break;
		// End:0x2CC
		case "GetAdditionalName":
			tmpDataString = GetAdditionalName(int(tmpDataString));
			// End:0x2CF
			break;
	}
}

function bool IsStackableItemByClassID(int ClassID)
{
	local ItemInfo Info;

	Info = GetItemInfoByClassID(ClassID);
	// End:0x26
	if(IsStackableItem(Info.ConsumeType))
	{
		return true;
	}
	return false;
}

function string GetAdditionalName(int ClassID)
{
	local ItemInfo Info;

	Info = GetItemInfoByClassID(ClassID);
	return Info.AdditionalName;
}

// �ٷ� ��Ƽ�� ���� ���� ���� ���� ���� �� ����. 
function setGetPartyMemberLocationWithID(int a_PartyMemberSID)
{
	local Vector a_Location;

	// End:0x6B
	if(GetPartyMemberLocationWithID(int(tmpDataString), a_Location))
	{
		tmpDataString = "";
		ParamAdd(tmpDataString, "x", string(a_Location.X));
		ParamAdd(tmpDataString, "y", string(a_Location.Y));
		ParamAdd(tmpDataString, "z", string(a_Location.Z));
	}
}

function string Int2Str(int Num)
{
	// End:0x19
	if(Num < 10)
	{
		return "0" $ string(Num);
	}
	return string(Num);
}

function bool IsPeaceZoneType(int zonetype)
{
	return zonetype == 11;
}

private function API_SendWindowsInfo()
{
	SendWindowsInfo();	
}

defaultproperties
{
}
