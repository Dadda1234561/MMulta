/*
 * UIConstants
 *  
 *  @desc : Interface uc �ڵ峻������ ���� struct, const, enum �� ��Ƶδ� ��.
 *
 */

class UIConstants extends UIScript;

//��� ���ϴµ� �ؼ� �ּ� ó��
//const MAX_USER_LEVEL                   = 99;

const DEBUG_SPLIT_STR = "|::::|";

// ��Ƽ��Ʈ
const ARTIFACTTYE_NORMAL = 4398046511104;
const ARTIFACTTYE_TYPE1 = 18014398509481984;
const ARTIFACTTYE_TYPE2 = 144115188075855872;
const ARTIFACTTYE_TYPE3 = 1152921504606846976;
const USE_XML_TELEPORT_UI = true;
const USE_XML_BOTTOM_BAR_UI = true;

enum MULTISELLSHOWTYPE 
{
	Normal,
	MaterialType,
	GOODSEXCHANGE,
	ENCHANTSCROLL,
	ITEMEXCHANGE
};

enum CrystalType
{
//	CRT_INVALID = -1,
	CRT_NONE,
	CRT_D,
	CRT_C,
	CRT_B,
	CRT_A,
	CRT_S,
	CRT_S80,
	CRT_S84,
	CRT_R,
	CRT_R95,
	CRT_R99,
	CRT_R110,
	CRT_EVENT
};

enum HuntingZoneType
{
	DOMINION,                     //0
	FIELD_HUNTING_ZONE_SOLO,      //1
	FIELD_HUNTING_ZONE_PARTY,     //2
	INSTANCE_ZONE_SOLO,           //3
	INSTANCE_ZONE_PARTY,          //4
	Agit,                         //5
	VILLAGE,                      //6
	etc,                          //7
	CASTLE,                       //8
	FORTRESS,                     //9
	FIELD_HUNTING_ZONE_PARTYWITH_SOLO,//10
	FIELD_HUNTING_ZONE_OUT_OF_USE,//11
	INSTANCE_ZONE_UNION, // 12
	Max
};

// �ʿ��� ����� ���� ���� Ÿ��
enum MapServerInfoType
{
	SIEGEWARFARE,                           // ������
	SIEGEWARFARE_DIMENSION,                 // ���� ������
	RAID_DIMENSION,                         // ���� ���̵�
	CURSEDWEAPON_MAGICAL,                   // ���� �ڸ�ü
	CURSEDWEAPON_BLOOD,                     // ���� �ڸ�ü
	AUCTION,                                // ���
	DEFENSEWARFARE,                         // ũ������ ���� ���ձ��� �����
	CURSEDWEAPON_MAGICAL_TreasureBox,       // ���� �ڸ�ü�� ��������
	CURSEDWEAPON_BLOOD_TreasureBox,         // ���� ��ī�������� ��������
	Max
};

struct MenuButtonSlotStruct
{
	var int CategoryIndex;
	var int buttonIndex;
	var string tooltipKey;
	var string SpecialParam;
	var string MenuName;
	var string buttonText;
	var Color buttonTextColor;
	var int nSequence;
	var int nBGTextureIndex;
};

struct MultiSellInfo
{
	var int MultiSellInfoID;
	var int MultiSellType;
	var INT64 NeededItemNum;
	var ItemInfo ResultItemInfo;
	var array<ItemInfo> OutputItemInfoList;
	var array<ItemInfo> InputItemInfoList;
};


// �� ���� ����
struct MapServerInfo
{
	// ���� ��� ���ΰ�?
	var bool bUse;

	// �� ���ʿ� ��Ÿ���� ��ư, �ؽ��� ����
	var string normalTex;
	var string pushedTex;
	var string highlightTex;

	// ���� ���� Ÿ��
	var int nServerInfoType;

	// ����, ����
	var string ToolTipString;
	var string descString;

	// �ʿ� �Ҷ� ���
	var string szReserved;

	// ��� ���� ��ư �̸�
	var string buttonName;

	// ����Ŀ�� ���϶���Ʈ �ؽ��ĸ� ����ϱ� ���� ��ǥ ������ ��������..
	var int nRegionID;

	var int nData;

	// Ŭ�� �� �̵� ��ġ
	//var Vector clickedLoc;
	var array<Vector> clickedLocArray;
	var int clickedLocClickCount;
};

struct RaidUIData
{
	var string raidMonsterName;
	var string raidDesc;

	var int nRaidMonsterID;
	var int nRaidMonsterLevel;
	var int nRaidMonsterZone;
	var string RaidMonsterZoneName;
	var string sortingKey;

	var int nMinLevel;
	var int nMaxLevel;
	var int Id;
	var Vector nWorldLoc;
};

// ����, ����, ���ݼ��� ��ų ���⿡�� ����ϴ� Ÿ��
struct SkillTrainInfo
{
	var string strIconName;
	var string strName;
	var string strEnchantName;
	var int Id;
	var int Level;
	var int SubLevel;
	var int requiredLevel;
	var INT64 spConsume;
};


// - ��ȥ�� ����
// �ش� api�� ���ؼ� ����, bool GetEnsoulStoneUIInfo( ItemID Id, out string EnsoulStoneUIInfo )
struct EnsoulStoneUIInfo
{
	var int slotType;
	var int ExtractionItemID;     // ��ȥ�� ���� ���� ������ �̸�(���̺꿡�� ���)
	var array<int> OptionId_Array;
};


// - ��ȥ �ɼ� ID�� �ɼ� ����
// �ش� api�� ���ؼ� ����, bool GetEnsoulOptionUIInfo( int optionId, out string optionInfo )
struct EnsoulOptionUIInfo
{
	var int OptionID;
	var int OptionStep;
	var int OptionType;
	var string Name;
	var string Desc;
	var string Icontex;
	var string IconPanelTex;
	var int ExtractionItemID;  // ������(��ȥ����) ����� ��Ե� ������ ID�Դϴ�. �� ���� 0�̸� ���� �Ұ��Դϴ�.- �ؿ� 2016-1-14�߰�
};


// - ��ȥ ������ ����
struct EnsoulFeeUIInfo
{
	var int nID;
	var INT64 ItemCount;
};


struct TextureStruct
{
	var string AnchorWindowName;
	var string texturePath;
	var string RelativePoint;
	var string AnchorPoint;
	var int textureOffsetX;
	var int textureOffsetY;
	var int textureW;
	var int textureH;
};

static function TextureStruct getTextureInfo(string texturePath, string AnchorWindowName, string RelativePoint, string AnchorPoint, int textureOffsetX, int textureOffsetY, int textureW, int textureH)
{
	local TextureStruct TS;

	TS.texturePath = texturePath;
	TS.AnchorWindowName = AnchorWindowName;
	TS.RelativePoint = RelativePoint;
	TS.AnchorPoint = AnchorPoint;
	TS.textureOffsetX = textureOffsetX;
	TS.textureOffsetY = textureOffsetY;
	TS.textureW = textureW;
	TS.textureH = textureH;
	return TS;
}

// ��ȥ�� ���� :EnsoulStoneUIInfo 
function GetEnsoulStoneUIInfo(ItemInfo eItemInfo, ItemID IdInfo, out EnsoulStoneUIInfo eStoneInfo)
{
	local string EnsoulStoneUIInfoParam;
	local int numOfOption, OptionID, i;
	local string parseStr;

	class'UIDATA_ENSOUL'.static.GetEnsoulStoneInfo(IdInfo, EnsoulStoneUIInfoParam);
	ParseInt(EnsoulStoneUIInfoParam, "SlotType", eStoneInfo.slotType);
	ParseInt(EnsoulStoneUIInfoParam, "ExtractionItemID", eStoneInfo.ExtractionItemID);
	Debug("EnsoulStoneUIInfoParam" @ EnsoulStoneUIInfoParam);
	Debug("eItemInfo.SlotBitType" @ string(eItemInfo.SlotBitType));
	// End:0xFF
	if(eItemInfo.ItemType == EItemType.ITEM_WEAPON)
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfWeaponOption", numOfOption);
		parseStr = "WeaponOptionId_";		
	}
	else if(eItemInfo.SlotBitType == 2048)
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfLegsOption", numOfOption);
		parseStr = "LegsOptionId_";			
	}
	else if(eItemInfo.SlotBitType == 4096)
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfFeetOption", numOfOption);
		parseStr = "FeetOptionId_";				
	}
	else if(eItemInfo.SlotBitType == 64)
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfHeadOption", numOfOption);
		parseStr = "HeadOptionId_";					
	}
	else if(eItemInfo.SlotBitType == 512)
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfGlovesOption", numOfOption);
		parseStr = "GlovesOptionId_";						
	}
	else if(eItemInfo.SlotBitType == 32768)
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfOnepieceOption", numOfOption);
		parseStr = "OnepieceOptionId_";							
	}
	else if(eItemInfo.SlotBitType == 1024)
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfChestOption", numOfOption);
		parseStr = "ChestOptionId_";								
	}
	else if(eItemInfo.SlotBitType == 16 || eItemInfo.SlotBitType == 32 || eItemInfo.SlotBitType == 48)
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfFingerOption", numOfOption);
		parseStr = "FingerOptionId_";
	}
	else if(eItemInfo.SlotBitType == 2 || eItemInfo.SlotBitType == 4 || eItemInfo.SlotBitType == 6)
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfEarOption", numOfOption);
		parseStr = "EarOptionId_";										
	}
	else if(eItemInfo.SlotBitType == 8)
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfNeckOption", numOfOption);
		parseStr = "NeckOptionId_";
	}
	else if((eItemInfo.SlotBitType == 256) && IsSigilArmor(eItemInfo.Id) == false)
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfShieldOption", numOfOption);
		parseStr = "ShieldOptionId_";
	}
	else if((eItemInfo.SlotBitType == 256) && IsSigilArmor(eItemInfo.Id))
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfSigilOption", numOfOption);
		parseStr = "SigilOptionId_";
	}

	Debug("numOfOption" @ string(numOfOption));

	// End:0x5C7 [Loop If]
	for(i = 0; i < numOfOption; i++)
	{
		ParseInt(EnsoulStoneUIInfoParam, parseStr $ string(i), OptionID);
		Debug("parseStr" @ parseStr $ string(i));
		Debug("optionId" @ string(OptionID));
		eStoneInfo.OptionId_Array.Length = eStoneInfo.OptionId_Array.Length + 1;
		eStoneInfo.OptionId_Array[eStoneInfo.OptionId_Array.Length - 1] = OptionID;
	}
}

// ��ȥ �ɼ� ���� :EnsoulOptionUIInfo
function GetEnsoulOptionUIInfo(int nEnsoulOptionID, out EnsoulOptionUIInfo eOptionInfo)
{
	local string ensoulOptioEachParam;

	// End:0x148
	if(nEnsoulOptionID > 0)
	{
		// ��ȥ �ɼ� ���� ���
		class'UIDATA_ENSOUL'.static.GetEnsoulOptionInfo(nEnsoulOptionID, ensoulOptioEachParam);
		Debug("EnsoulStoneUIInfoParam" @ ensoulOptioEachParam);
		ParseInt(ensoulOptioEachParam, "OptionType", eOptionInfo.OptionType);
		ParseInt(ensoulOptioEachParam, "OptionStep", eOptionInfo.OptionStep);
		ParseString(ensoulOptioEachParam, "OptionName", eOptionInfo.Name);
		ParseString(ensoulOptioEachParam, "OptionDesc", eOptionInfo.Desc);
		ParseString(ensoulOptioEachParam, "IconTex", eOptionInfo.Icontex);
		ParseString(ensoulOptioEachParam, "IconPanelTex", eOptionInfo.IconPanelTex);

		// �ؿ� 2016-1-14 �߰� (������)
		ParseInt(ensoulOptioEachParam, "ExtractionItemID", eOptionInfo.ExtractionItemID);

		eOptionInfo.OptionID = nEnsoulOptionID;
	}
	else
	{
		Debug("Error : GetEnsoulOptionUIInfo  ->  ensoulID is wrong");
	}
}

// ��ȥ ���ݰ� �ʿ� ������ �� ����
function GetEnsoulFeeUIInfo(ItemInfo eInfo, ItemInfo stoneItemInfo, bool bIsRefee, int slotType, int SlotIndex, out EnsoulFeeUIInfo feeInfo)
{
	local string ensoulFeeInfoParam;

	// End:0x3D
	class'UIDATA_ENSOUL'.static.GetEnsoulFeeInfoByItemId(stoneItemInfo.Id.ClassID, bIsRefee, SlotIndex, ensoulFeeInfoParam);
	Debug("GetEnsoulFeeInfoByItemId" @ string(eInfo.Id.ClassID) @ string(bIsRefee) @ string(SlotIndex));
	Debug("EnsoulStoneUIInfoParam:" @ ensoulFeeInfoParam);
	ParseInt(ensoulFeeInfoParam, "ItemID", feeInfo.nID);
	ParseINT64(ensoulFeeInfoParam, "ItemCount", feeInfo.ItemCount);
}

function bool IsUseRenewalSkillWnd()
{
	return IsAdenServer();	
}

function bool IsUseSkillCastingSpeedStat()
{
	return IsAdenServer();	
}

defaultproperties
{
}
