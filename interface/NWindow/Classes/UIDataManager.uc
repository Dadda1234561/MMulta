class UIDataManager extends UIEventManager
	native;

cpptext
{
	#include "UIDataManager.h"
}

// Export UUIDataManager::execGetClassnameSysstringIndexByClassIndex(FFrame&, void* const)
native static final function int GetClassnameSysstringIndexByClassIndex(int Index);

// Export UUIDataManager::execGetEnableClassIndexList(FFrame&, void* const)
native static final function GetEnableClassIndexList(int MyIndex, out array<int> EnableClassIndexList);

// Export UUIDataManager::execGetClassTypeMaxCount(FFrame&, void* const)
native static final function int GetClassTypeMaxCount();

// Export UUIDataManager::execGetSysStringMaxCount(FFrame&, void* const)
native static final function int GetSysStringMaxCount();

// Export UUIDataManager::execGetSystemMsgMaxCount(FFrame&, void* const)
native static final function int GetSystemMsgMaxCount();

// Export UUIDataManager::execGetMaxServerCount(FFrame&, void* const)
native static final function int GetMaxServerCount();

// Export UUIDataManager::execGetServerInfo(FFrame&, void* const)
native static final function bool GetServerInfo(int ServerWorldID, out ServerInfoUIData ServerInfo);

// Export UUIDataManager::execGetServerList(FFrame&, void* const)
native static final function GetServerList(out array<ServerInfoUIData> ServerList);

// Export UUIDataManager::execGetRootClassID(FFrame&, void* const)
native static final function int GetRootClassID(int LeafClassID);

// Export UUIDataManager::execGetOlympiadGroupServerList(FFrame&, void* const)
native static final function GetOlympiadGroupServerList(out array<ServerInfoUIData> ServerList);

// Export UUIDataManager::execGetAbilityItem(FFrame&, void* const)
native static final function bool GetAbilityItem(int Type, int Row, int Column, out AbilityItemUIData abilityItemData);

// Export UUIDataManager::execGetDethroneShopDataList(FFrame&, void* const)
native static final function bool GetDethroneShopDataList(out array<DethroneShopUIData> ShopDataList);

// Export UUIDataManager::execGetFireAbilityData(FFrame&, void* const)
native static final function bool GetFireAbilityData(EFireAbilityType FAType, out FireAbilityUIData Data);

// Export UUIDataManager::execGetFireAbilityComboEffectData(FFrame&, void* const)
native static final function bool GetFireAbilityComboEffectData(out array<FireAbilityComboEffectUIData> DataList);

defaultproperties
{
}
