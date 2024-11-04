//================================================================================
// HomunculusAPI.
//================================================================================

class HomunculusAPI extends UIEventManager
	native;

struct HomunCreateData
{
	var INT64 CostAdena;
	var int HpCount;
	var int HpVolume;
	var int SpCount;
	var INT64 SpVolume;
	var int VpCount;
	var int VpVolume;
	var int CostTime;
};

struct HomunEnchantData
{
	var int PointMax;
	var int PointNeedExp;
	var int PointResetMax;
	var int BonusMax;
	var int BonusNeedVp;
	var int BonusResetMax;
	var int EnchantExpPoint;
	var int CommunionNeedEnchantPoint;
	var int CommunionNeedSpPoint;
};

struct HomunEnchantResetData
{
	var int ItemID;
	var int NeededNum;
};

struct HomunculusData
{
	var int idx;
	var int Id;
	var int Type;
	var bool Activate;
	var int SkillID[6];
	var int SkillLevel[6];
	var int Level;
	var int Exp;
	var int Hp;
	var int Attack;
	var int Defence;
	var int Critical;
	var bool IsNew;
};

struct HomunculusNpcData
{
	var int Id;
	var int NpcID;
	var string ImgName;
};

struct HomunculusNpcLevelData
{
	var int Id;
	var int Level;
	var int MaxExp;
	var int MaxHP;
	var int MaxAtk;
	var int MaxDef;
	var int MaxCri;
	var int OptionSkillId[3];
	var int OptionSkillLevel[3];
};

struct HomunListUIInfo
{
	var RequestItem CostItem;
	var INT64 Fee;
	var int Grade;
	var int Event;
};

// Export UHomunculusAPI::execIsHomunReady(FFrame&, void* const)
native static function bool IsHomunReady();

// Export UHomunculusAPI::execGetHomunCreateData(FFrame&, void* const)
native static function HomunCreateData GetHomunCreateData();

// Export UHomunculusAPI::execGetRemainBirthSeconds(FFrame&, void* const)
native static function INT64 GetRemainBirthSeconds();

// Export UHomunculusAPI::execGetHomunEnchantData(FFrame&, void* const)
native static function HomunEnchantData GetHomunEnchantData();

// Export UHomunculusAPI::execGetPointResetItem(FFrame&, void* const)
native static function HomunEnchantResetData GetPointResetItem();

// Export UHomunculusAPI::execGetBonusResetItem(FFrame&, void* const)
native static function HomunEnchantResetData GetBonusResetItem();

// Export UHomunculusAPI::execGetHomunculusDatas(FFrame&, void* const)
native static function array<HomunculusData> GetHomunculusDatas();

// Export UHomunculusAPI::execGetHomunculusNpcData(FFrame&, void* const)
native static function HomunculusNpcData GetHomunculusNpcData(int Id);

// Export UHomunculusAPI::execGetHomunculusNpcLevelData(FFrame&, void* const)
native static function HomunculusNpcLevelData GetHomunculusNpcLevelData(int Id, int Level);

// Export UHomunculusAPI::execGetMaxHomunculusNpcLevelData(FFrame&, void* const)
native static function HomunculusNpcLevelData GetMaxHomunculusNpcLevelData(int Id);

// Export UHomunculusAPI::execGetHomunculusGatchaList(FFrame&, void* const)
native static function array<HomunListUIInfo> GetHomunculusGatchaList();

// Export UHomunculusAPI::execGetHomunculusSlotActivateCost(FFrame&, void* const)
native static function array<RequestItem> GetHomunculusSlotActivateCost(int Slot);

defaultproperties
{
}
