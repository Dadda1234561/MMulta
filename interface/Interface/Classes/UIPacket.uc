class UIPacket extends UIProtocol
	Export;

struct _C_EX_DECO_NPC_SET
{
	var int nAgitCID;
	var int cSlot;
	var int nDecoCID;
};

struct _S_PLEDGE_CREST
{
	var int pledgeSID;
	var int pledgeCrestDBID;
	var int bitmapSize;
	var array<byte> Bitmap;
};

struct _S_ALLIANCE_CREST
{
	var int allianceCrestDBID;
	var int requestPledgeSID;
	var int bitmapSize;
	var array<byte> Bitmap;
};

struct _S_EX_DECO_NPC_SET
{
	var int cResult;
	var int nAgitCID;
	var int cSlot;
	var int nDecoCID;
	var int nExpire;
};

struct _C_EX_DECO_NPC_INFO
{
	var int nAgitCID;
};

struct _DecoNpcInfo
{
	var int cSlot;
	var int nDecoCID;
	var int nExpire;
};

struct _S_EX_DECO_NPC_INFO
{
	var int nAgitCID;
	var array<_DecoNpcInfo> vDecoNpcs;
	var int nResidenceGrade;
	var array<int> vResidenceDomains;
};

struct _C_EX_FACTION_INFO
{
	var int nUserID;
	var int nRequestType;
};

struct _FactionInfo
{
	var int nFactionType;
	var int nFactionLevel;
	var int cIsLevelLimited;
	var float fFactionRate;
};

struct _S_EX_FACTION_INFO
{
	var int nUserID;
	var int nRequestType;
	var array<_FactionInfo> lFactionInfoList;
};

struct _S_EX_BALTHUS_EVENT
{
	var int nCurrentState;
	var int nProgress;
	var int nCurrentRewardItem;
	var int nRewardTokenCount;
	var int nCurrentTokenCount;
	var int nParticipated;
	var byte bRunning;
	var int nTime;
};

struct _S_EX_FIELD_EVENT_STEP
{
	var int nStep;
	var int nRemainSec;
	var int nGoalPoint;
};

struct _S_EX_FIELD_EVENT_POINT
{
	var int nPoint;
};

struct _S_EX_FIELD_EVENT_EFFECT
{
	var int nType;
};

struct _C_EX_RAID_BOSS_SPAWN_INFO
{
	var array<int> vRaidNpcIds;
};

struct _RaidBossSpawnInfo
{
	var int nNpcID;
	var int nStatus;
	var int nDeadDateTime;
};

struct _S_EX_RAID_BOSS_SPAWN_INFO
{
	var int nBossRespawnFactor;
	var array<_RaidBossSpawnInfo> vRaidSpawnNpcInfos;
};

struct _S_EX_RAID_SERVER_INFO
{
	var int cDimensionRaid;
	var int cDimensionCastleSiege;
};

struct _AgitSiegeInfo
{
	var int nAgitId;
	var int nSiegeDate;
	var string wstrOwnerPledgeName;
	var string wstrOwnerPledgeMasterName;
	var int cAgitType;
	var int cSiegeState;
};

struct _S_EX_SHOW_AGIT_SIEGE_INFO
{
	var array<_AgitSiegeInfo> vAgitInfos;
};

struct _S_EX_ITEM_AUCTION_STATUS
{
	var int nPosX;
	var int nPosY;
	var int nPosZ;
	var int nInzoneId;
	var int cAuctionStatus;
};

struct _S_EX_ITEM_AUCTION_UPDATED_BIDDING_INFO
{
	var INT64 nCurrentPrice;
};

struct _S_EX_PRIVATE_STORE_BUYING_RESULT
{
	var int nItemSid;
	var INT64 nAmount;
	var string charName;
};

struct _S_EX_PRIVATE_STORE_SELLING_RESULT
{
	var int nItemSid;
	var INT64 nAmount;
	var string charName;
};

struct _C_EX_MATCHGROUP_ASK
{
	var string TargetUserName;
};

struct _C_EX_MATCHGROUP_ANSWER
{
	var int answer;
};

struct _C_EX_MATCHGROUP_OUST
{
	var string TargetUserName;
};

struct _C_EX_MATCHGROUP_CHANGE_MASTER
{
	var string TargetUserName;
};

struct _C_EX_UPGRADE_SYSTEM_REQUEST
{
	var int nItemSid;
	var int nUpgradeSystemID;
};

struct _C_EX_UPGRADE_SYSTEM_NORMAL_REQUEST
{
	var int nItemSid;
	var int nType;
	var int nUpgradeSystemID;
};

struct _MatchGroupMemberInfo
{
	var int memberSid;
	var string charName;
};

struct _S_EX_MATCHGROUP
{
	var int matchGroupSid;
	var int masterSid;
	var array<_MatchGroupMemberInfo> members;
};

struct _S_EX_MATCHGROUP_ASK
{
	var string requesterUserName;
};

struct _S_EX_ARENA_SHOW_ENEMY_PARTY_LOCATION
{
	var int Duration;
};

struct _S_EX_SHOW_UPGRADE_SYSTEM
{
	var int nFlag;
	var int nCommissionRatio;
	var array<int> vMaterialItemId;
	var array<int> vMaterialRatio;
};

struct _S_EX_UPGRADE_SYSTEM_RESULT
{
	var int nResult;
	var int nID;
};

struct _S_EX_SHOW_UPGRADE_SYSTEM_NORMAL
{
	var int nFlag;
	var int nType;
	var int nCommissionRatio;
	var array<int> vMaterialItemId;
	var array<int> vMaterialRatio;
};

struct _UpgradeSystemNormalResultItem
{
	var int itemServerID;
	var int ItemClassID;
	var int itemEnchant;
	var int ItemCount;
};

struct _S_EX_UPGRADE_SYSTEM_NORMAL_RESULT
{
	var int nResult;
	var int nID;
	var int nIsUpgradeSuccess;
	var array<_UpgradeSystemNormalResultItem> resultItemList;
	var int nIsBonus;
	var array<_UpgradeSystemNormalResultItem> bonusItemList;
};

struct _ItemInfo
{
	var int nItemClassID;
	var INT64 nAmount;
};

struct _ArenaResultStat
{
	var string charName;
	var int killCount;
	var int deathCount;
	var int maxMultiKillCount;
	var int npckillCount;
	var int adenaEarned;
	var int damageToUser;
	var int pvpDamageTaken;
	var int damageToNpc;
	var int pveDamageTaken;
	var int healing;
};

struct _S_EX_BATTLE_RESULT_ARENA
{
	var int Result;
	var int oldRatingPoint;
	var int newRatingPoint;
	var array<_ItemInfo> rewardList;
	var array<_ArenaResultStat> statList;
};

struct _RankInfo
{
	var string charName;
	var int ratingPoint;
};

struct _S_EX_ARENA_RANK_ALL
{
	var array<_RankInfo> rankList;
};

struct _S_EX_ARENA_MYRANK
{
	var int Rank;
	var int ratingPoint;
};

struct _C_EX_PLEDGE_CONTRIBUTION_RANK
{
	var byte bCurrent;
};

struct _PkPledgeContributionRankInfo
{
	var int nRank;
	var string szName;
	var int nPledgeType;
	var int nPeriod;
	var int nTotal;
};

struct _S_EX_PLEDGE_CONTRIBUTION_RANK
{
	var byte bCurrent;
	var array<_PkPledgeContributionRankInfo> vMembers;
};

struct _C_EX_PLEDGE_CONTRIBUTION_INFO
{
	var int cReserved;
};

struct _S_EX_PLEDGE_CONTRIBUTION_INFO
{
	var int nPeriod;
	var int nTotal;
	var int nTotalForNextReward;
	var int nItemClassID;
	var int nAmount;
	var int nNameValue;
};

struct _C_EX_PLEDGE_CONTRIBUTION_REWARD
{
	var int nType;
};

struct _S_EX_PLEDGE_CONTRIBUTION_REWARD
{
	var int nResult;
};

struct _S_EX_PLEDGE_RAID_INFO
{
	var byte bIsCurrent_;
	var string szPledgeName_;
	var int nRank_;
	var int nTier_;
	var INT64 nPoint_;
	var int nRewardReason_;
	var int nSeason_;
	var int hStartTimeYear_;
	var int hStartTimeMonth_;
	var int hStartTimeDay_;
	var int hEndTimeYear_;
	var int hEndTimeMonth_;
	var int hEndTimeDay_;
};

struct _PkPledgeRaidRankInfo
{
	var int nWorldId_;
	var string szPledgeName_;
	var int nRank_;
	var INT64 nPoint_;
};

struct _S_EX_PLEDGE_RAID_RANK
{
	var byte bIsCurrent_;
	var array<_PkPledgeRaidRankInfo> vList_;
};

struct _C_EX_PLEDGE_LEVEL_UP
{
	var int cReserved;
};

struct _S_EX_PLEDGE_LEVEL_UP
{
	var int nResult;
};

struct _S_EX_PLEDGE_SHOW_INFO_UPDATE
{
	var int nPledgeSId;
	var int nNextLevelNameValue;
	var int nMaster;
	var int nElite;
};

struct _C_EX_PLEDGE_MISSION_REWARD
{
	var int nMissionId_;
};

struct _PkPledgeMissionInfo
{
	var int nMissionId_;
	var int nCount_;
	var int nState_;
};

struct _S_EX_PLEDGE_MISSION_INFO
{
	var array<_PkPledgeMissionInfo> vList_;
};

struct _S_EX_PLEDGE_MISSION_REWARD_COUNT
{
	var int nCount_;
	var int nMaxCount_;
};

struct _C_EX_PLEDGE_MASTERY_INFO
{
	var int cReserved;
};

struct _PkPledgeMasteryInfo
{
	var int nID;
	var int nPoint;
	var int nStatus;
};

struct _S_EX_PLEDGE_MASTERY_INFO
{
	var int nTotalPoint;
	var int nMaxPoint;
	var array<_PkPledgeMasteryInfo> vMasteries;
};

struct _C_EX_PLEDGE_MASTERY_SET
{
	var int nID;
};

struct _S_EX_PLEDGE_MASTERY_SET
{
	var int nResult;
};

struct _C_EX_PLEDGE_MASTERY_RESET
{
	var int cReserved;
};

struct _S_EX_PLEDGE_MASTERY_RESET
{
	var int nResult;
};

struct _C_EX_PLEDGE_SKILL_INFO
{
	var int nSkillID;
	var int nSkillLevel;
};

struct _S_EX_PLEDGE_SKILL_INFO
{
	var int nSkillID;
	var int nSkillLevel;
	var int nRemainSecond;
	var int nStatus;
};

struct _C_EX_PLEDGE_SKILL_ACTIVATE
{
	var int nSkillID;
	var int nSkillLevel;
};

struct _S_EX_PLEDGE_SKILL_ACTIVATE
{
	var int nResult;
};

struct _C_EX_PLEDGE_ITEM_LIST
{
	var int cReserved;
};

struct _C_EX_PLEDGE_ITEM_ACTIVATE
{
	var int nItemClassID;
};

struct _S_EX_PLEDGE_ITEM_ACTIVATE
{
	var int nResult;
};

struct _C_EX_PLEDGE_ANNOUNCE
{
	var int cReserved;
};

struct _S_EX_PLEDGE_ANNOUNCE
{
	var string content;
	var byte bShow;
};

struct _C_EX_PLEDGE_ANNOUNCE_SET
{
	var string content;
	var byte bShow;
};

struct _S_EX_PLEDGE_ANNOUNCE_SET
{
	var byte bSuccess;
};

struct _C_EX_PLEDGE_ITEM_INFO
{
	var int nItemClassID;
};

struct _C_EX_PLEDGE_ITEM_BUY
{
	var int nItemClassID;
	var int nItemAmount;
};

struct _S_EX_PLEDGE_ITEM_BUY
{
	var int nResult;
};

struct _C_EX_REQUEST_LOCKED_ITEM
{
	var int nTargetItemId;
};

struct _C_EX_REQUEST_UNLOCKED_ITEM
{
	var int nTargetItemId;
};

struct _C_EX_LOCKED_ITEM_CANCEL
{
	var int dummy;
};

struct _C_EX_UNLOCKED_ITEM_CANCEL
{
	var int dummy;
};

struct _S_EX_CHOOSE_LOCKED_ITEM
{
	var int nScrollItemClassID;
};

struct _S_EX_LOCKED_RESULT
{
	var int Lock;
	var int Result;
};

struct _S_EX_OLYMPIAD_INFO
{
	var byte bOpen;
	var int nRemainTime;
	var int cGameRuleType;
};

struct _S_EX_OLYMPIAD_RECORD
{
	var int nPoint;
	var int nWinCount;
	var int nLoseCount;
	var int nMatchCount;
	var int nPrevClassType;
	var int nPrevRank;
	var int nPrevRankCount;
	var int nPrevClassRank;
	var int nPrevClassRankCount;
	var int nPrevClassRankByServer;
	var int nPrevClassRankByServerCount;
	var int nPrevPoint;
	var int nPrevWinCount;
	var int nPrevLoseCount;
	var int nPrevGrade;
	var int nSeasonYear;
	var int nSeasonMonth;
	var byte bMatchOpen;
	var int nSeason;
	var byte bRegistered;
	var int cGameRuleType;
};

struct _S_EX_OLYMPIAD_MATCH_INFO
{
	var string szTeam1Name;
	var int nTeam1WinCount;
	var string szTeam2Name;
	var int nTeam2WinCount;
	var int nCurrentSet;
	var int nRemainSecond;
};

struct _S_EX_ITEM_ANNOUNCE
{
	var int cType;
	var string sUserName;
	var int nItemClassID;
	var int cEnchantCount;
	var int nFromItemClassID;
};

struct _S_EX_COMPLETED_DAILY_QUEST_LIST
{
	var array<int> vQuestIds;
};

struct _S_EX_COMPLETED_DAILY_QUEST
{
	var int QuestID;
};

struct _C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST
{
	var int cShopIndex;
};

struct _C_EX_PURCHASE_LIMIT_SHOP_ITEM_BUY
{
	var int cShopIndex;
	var int nSlotNum;
	var int nItemAmount;
	var int nSuccessionItemSID;
	var int nMaterialItemSID;
};

struct _PLShopItemData
{
	var int nSlotNum;
	var int nItemClassID;
	var int cResetType;
	var int sConditionLevel;
	var int nMaxItemAmount;
	var int nCostItemId[3];
	var INT64 nCostItemAmount[3];
	var INT64 nCostItemSaleAmount[3];
	var float fCostSaleRate[3];
	var int nRemainItemAmount;
	var int cSellCategory;
	var int cEventType;
	var int nEventRemainSec;
	var int nSaleRemainSec;
};

struct _S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST
{
	var int cShopIndex;
	var array<_PLShopItemData> vItemList;
	var int nActiveGachaShopIndex;
};

struct _PLShopResultData
{
	var int cIndex;
	var int nItemClassID;
	var int nCount;
};

struct _S_EX_PURCHASE_LIMIT_SHOP_ITEM_BUY
{
	var int cResult;
	var int cShopIndex;
	var int nSlotNum;
	var array<_PLShopResultData> resultInfoList;
	var int nRemainItemAmount;
};

struct _S_EX_BLOODY_COIN_COUNT
{
	var INT64 nCount;
};

struct _C_EX_OPEN_HTML
{
	var int cHTMLType;
};

struct _C_EX_REQUEST_TELEPORT
{
	var int nID;
};

struct _C_EX_COSTUME_USE_ITEM
{
	var int nItemServerId;
};

struct _C_EX_COSTUME_LIST
{
	var int nType;
};

struct _C_EX_COSTUME_COLLECTION_SKILL_ACTIVE
{
	var int nCostumeCollectionId;
};

struct _tCostumeAmount
{
	var int nCostumeId;
	var INT64 nAmount;
};

struct _C_EX_COSTUME_EVOLUTION
{
	var array<_tCostumeAmount> vTarget;
	var array<_tCostumeAmount> vMaterial;
};

struct _C_EX_COSTUME_EXTRACT
{
	var _tCostumeAmount tExtract;
};

struct _C_EX_COSTUME_LOCK
{
	var int nCostumeId;
	var int nLockState;
};

struct _tCostumeShortcutInfoStruct
{
	var int nPage;
	var int nSlotIndex;
	var int nCostumeId;
	var byte bAutomaticUse;
};

struct _C_EX_COSTUME_CHANGE_SHORTCUT
{
	var array<_tCostumeShortcutInfoStruct> vChangeList;
};

struct _S_EX_COSTUME_USE_ITEM
{
	var byte bIsSuccess;
	var int nCostumeId;
};

struct _S_EX_CHOOSE_COSTUME_ITEM
{
	var int nItemClassID;
};

struct _tCostumeInfoStruct
{
	var int nCostumeId;
	var INT64 nAmount;
	var int nLockState;
	var int nChangedType;
};

struct _S_EX_SEND_COSTUME_LIST
{
	var array<_tCostumeInfoStruct> vCostumeList;
};

struct _S_EX_SEND_COSTUME_LIST_FULL
{
	var array<_tCostumeInfoStruct> vCostumeList;
	var array<_tCostumeShortcutInfoStruct> vShortcutList;
	var int nCostumeCollectionId;
	var int nCostumeCollectionReuseCooltime;
};

struct _S_EX_COSTUME_COLLECTION_SKILL_ACTIVE
{
	var int nCostumeCollectionId;
	var int nCostumeCollectionReuseCooltime;
};

struct _S_EX_COSTUME_EVOLUTION
{
	var byte bResult;
	var array<_tCostumeAmount> vTarget;
	var array<_tCostumeAmount> vResult;
};

struct _S_EX_COSTUME_EXTRACT
{
	var byte bResult;
	var int nExtractCostumeId;
	var INT64 nExtractCostumeAmount;
	var int nResultItemClassId;
	var INT64 nResultAmount;
	var INT64 nTotalAmount;
};

struct _S_EX_COSTUME_LOCK
{
	var byte bResult;
	var int nCostumeId;
	var int nLockState;
};

struct _S_EX_COSTUME_SHORTCUT_LIST
{
	var byte bResult;
	var array<_tCostumeShortcutInfoStruct> vList;
};

struct _S_EX_MAGICLAMP_EXP_INFO
{
	var int nIsOpen;
	var int nMaxMagicLampExp;
	var int nMagicLampExp;
	var int nMagicLampCount;
};

struct _C_EX_MAGICLAMP_GAME_INFO
{
	var int cGameMode;
};

struct _CostItemData
{
	var int nItemClassID;
	var INT64 nItemAmountPerGame;
	var INT64 nItemAmount;
};

struct _S_EX_MAGICLAMP_GAME_INFO
{
	var int nMagicLampGameMaxCCount;
	var int nMagicLampGameCCount;
	var int nMagicLampCountPerGame;
	var int nMagicLampCount;
	var int cGameMode;
	var array<_CostItemData> costItemList;
};

struct _C_EX_MAGICLAMP_GAME_START
{
	var int nMagicLampGameCCount;
	var int cGameMode;
};

struct _MagicLampGameResultData
{
	var int cGradeNum;
	var int nRewardCount;
	var INT64 nEXP;
	var INT64 nSP;
};

struct _S_EX_MAGICLAMP_GAME_RESULT
{
	var array<_MagicLampGameResultData> magicLampGameResult;
};

struct _C_EX_ACTIVATE_AUTO_SHORTCUT
{
	var int nRoomNumber;
	var byte bActivate;
};

struct _S_EX_ACTIVATE_AUTO_SHORTCUT
{
	var int nRoomNumber;
	var byte bActivate;
};

struct _CursedTreasureBoxInfo
{
	var int nClassID;
	var int nPosX;
	var int nPosY;
	var int nPosZ;
};

struct _S_EX_ACTIVATED_CURSED_TREASURE_BOX_LOCATION
{
	var array<_CursedTreasureBoxInfo> treasureBoxInfoList;
};

struct _C_EX_PAYBACK_LIST
{
	var int cEventIDType;
};

struct _PaybackRewardItem
{
	var int nClassID;
	var int nAmount;
};

struct _PaybackRewardSet
{
	var array<_PaybackRewardItem> vItemList;
	var int cSetIndex;
	var int nRequirement;
	var int cReceived;
};

struct _S_EX_PAYBACK_LIST
{
	var array<_PaybackRewardSet> vRewardSet;
	var int cEventIDType;
	var int nEndDatetime;
	var int nConsumedItemclassID;
	var int nUserConsumption;
};

struct _C_EX_PAYBACK_GIVE_REWARD
{
	var int cEventIDType;
	var int nSetIndex;
};

struct _S_EX_PAYBACK_GIVE_REWARD
{
	var int cResult;
	var int cEventIDType;
	var int nSetIndex;
};

struct _S_EX_PAYBACK_UI_LAUNCHER
{
	var byte bActivate;
};

struct _AutoPlaySetting
{
	var byte bAutoPlay;
	var byte bPickUp;
	var int nNextTargetMode;
	var byte bIsNearTarget;
	var int nUsableHPPotionPercent;
	var int nUsableHPPetPotionPercent;
	var byte bOnMannerMode;
	var int cMacroIndex;
};

struct _C_EX_AUTOPLAY_SETTING
{
	var _AutoPlaySetting setting;
};

struct _S_EX_AUTOPLAY_SETTING
{
	var _AutoPlaySetting setting;
};

struct _S_EX_AUTOPLAY_DO_MACRO
{
	var int nMacroNumber;
};

struct _S_EX_OLYMPIAD_MATCH_MAKING_RESULT
{
	var byte bRegistered;
	var int cGameRuleType;
};

struct _C_EX_GACHA_SHOP_GACHA_GROUP
{
	var int nGachaShopId;
};

struct _C_EX_GACHA_SHOP_GACHA_ITEM
{
	var int nGachaShopId;
	var int nGachaGroupId;
};

struct _S_EX_GACHA_SHOP_INFO
{
	var int nGachaShopId;
	var int nRemainTime;
	var int nBeforeGachaShopId;
	var int nBeforeGachaGroupId;
};

struct _S_EX_GACHA_SHOP_GACHA_GROUP
{
	var int cResult;
	var int nGachaShopId;
	var int nGachaGroupId;
};

struct _GachaShopItemData
{
	var int nItemClassID;
	var int nItemAmount;
};

struct _S_EX_GACHA_SHOP_GACHA_ITEM
{
	var int cResult;
	var int nGachaShopId;
	var int nGachaGroupId;
	var array<_GachaShopItemData> vItemList;
};

struct _C_EX_TIME_RESTRICT_FIELD_USER_ENTER
{
	var int nFieldID;
};

struct _FieldRequiredItem
{
	var int nItemClassID;
	var INT64 nItemAmount;
};

struct _TimeRestrictedFieldInfo
{
	var array<_FieldRequiredItem> vRequiredItems;
	var int nResetCycle;
	var int nFieldID;
	var int nMinLevel;
	var int nMaxLevel;
	var int nRemainTimeBase;
	var int nRemainTime;
	var int nRemainTimeMax;
	var int nRemainRefillTime;
	var int nRefillTimeMax;
	var byte bFieldActivated;
	var byte bUserBound;
	var byte bCanReEnter;
	var byte bIsInZonePCCafeUserOnly;
	var byte bIsPCCafeUser;
	var byte bWorldInZone;
	var byte bCanUseEntranceTicket;
	var int nEntranceCount;
};

struct _S_EX_TIME_RESTRICT_FIELD_LIST
{
	var array<_TimeRestrictedFieldInfo> vFieldInfos;
};

struct _S_EX_TIME_RESTRICT_FIELD_USER_ENTER
{
	var byte bEnterSuccess;
	var int nFieldID;
	var int nEnterTimeStamp;
	var int nRemainTime;
};

struct _S_EX_TIME_RESTRICT_FIELD_USER_CHARGE_RESULT
{
	var int nFieldID;
	var int nResultRemainTime;
	var int nResultRefillTime;
	var int nResultChargeTime;
};

struct _S_EX_TIME_RESTRICT_FIELD_USER_ALARM
{
	var int nFieldID;
	var int nRemainTime;
};

struct _S_EX_TIME_RESTRICT_FIELD_USER_EXIT
{
	var int nFieldID;
};

struct _S_EX_TIME_RESTRICT_FIELD_SERVER_GROUP
{
	var array<int> vWorldIDList;
};

struct _C_EX_RANKING_CHAR_INFO
{
	var int dummy;
};

struct _S_EX_RANKING_CHAR_INFO
{
	var int nServerRank;
	var int nRaceRank;
	var int nServerRank_Snapshot;
	var int nRaceRank_Snapshot;
	var int nClassRank;
	var int nClassRank_Snapshot;
};

struct _C_EX_RANKING_CHAR_HISTORY
{
	var int dummy;
};

struct _PkUserRank
{
	var int nDatetime;
	var int nRank;
	var INT64 nEXP;
};

struct _S_EX_RANKING_CHAR_HISTORY
{
	var array<_PkUserRank> vHistory;
};

struct _C_EX_RANKING_CHAR_RANKERS
{
	var int cRankingGroup;
	var int cRankingScope;
	var int nRace;
	var int nClass;
};

struct _PkRankerData
{
	var string sUserName;
	var string sPledgeName;
	var int nWorldID;
	var int nLevel;
	var int nClass;
	var int nRace;
	var int nRank;
	var int nServerRank_Snapshot;
	var int nRaceRank_Snapshot;
	var int nClassRank_Snapshot;
};

struct _S_EX_RANKING_CHAR_RANKERS
{
	var int cRankingGroup;
	var int cRankingScope;
	var int nRace;
	var int nClass;
	var array<_PkRankerData> vRankers;
};

struct _S_EX_RANKING_CHAR_BUFFZONE_NPC_INFO
{
	var int nRemainedCooltime;
};

struct _S_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION
{
	var byte bIsInWorld;
	var int nPosX;
	var int nPosY;
	var int nPosZ;
};

struct _C_EX_MERCENARY_CASTLEWAR_CASTLE_INFO
{
	var int nCastleID;
};

struct _S_EX_MERCENARY_CASTLEWAR_CASTLE_INFO
{
	var int nCastleID;
	var int nCastleOwnerPledgeSID;
	var int nCastleOwnerPledgeCrestDBID;
	var string wstrCastleOwnerPledgeName;
	var string wstrCastleOwnerPledgeMasterName;
	var int nCastleTaxRate;
	var INT64 nCurrentIncome;
	var INT64 nTotalIncome;
	var int nNextSiegeTime;
};

struct _C_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_INFO
{
	var int nCastleID;
};

struct _S_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_INFO
{
	var int nCastleID;
	var int nCastleOwnerPledgeSID;
	var int nCastleOwnerPledgeCrestDBID;
	var string wstrCastleOwnerPledgeName;
	var string wstrCastleOwnerPledgeMasterName;
	var int nSiegeState;
	var int nNumOfAttackerPledge;
	var int nNumOfDefenderPledge;
};

struct _S_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_HUD_INFO
{
	var int nCastleID;
	var int nSiegeState;
	var int nNowTime;
	var int nRemainTime;
};

struct _C_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST
{
	var int nCastleID;
};

struct _C_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_DEFENDER_LIST
{
	var int nCastleID;
};

struct _C_EX_PLEDGE_MERCENARY_MEMBER_LIST
{
	var int nCastleID;
	var int nPledgeSId;
};

struct _MercenaryMemberInfo
{
	var int nIsMyInfo;
	var int nIsOnline;
	var string wstrMercenaryName;
	var int nClassType;
};

struct _S_EX_PLEDGE_MERCENARY_MEMBER_LIST
{
	var int nCastleID;
	var int nPledgeSId;
	var array<_MercenaryMemberInfo> lMercenaryMemberList;
};

struct _C_EX_PLEDGE_MERCENARY_RECRUIT_INFO_SET
{
	var int nCastleID;
	var int nType;
	var int nIsMercenaryRecruit;
	var INT64 nMercenaryReward;
};

struct _C_EX_PLEDGE_MERCENARY_MEMBER_JOIN
{
	var int nUserSID;
	var int nType;
	var int nCastleID;
	var int nMercenaryPledgeSID;
};

struct _S_EX_PLEDGE_MERCENARY_MEMBER_JOIN
{
	var int nResult;
	var int nType;
	var int nUserSID;
	var int nMercenaryPledgeSID;
};

struct _C_EX_PVPBOOK_LIST
{
	var int cDummy;
};

struct _PkPVPBookKiller
{
	var string sName;
	var string sPledgeName;
	var int nLevel;
	var int nRace;
	var int nClass;
	var int nKillTime;
	var byte bOnline;
};

struct _S_EX_PVPBOOK_LIST
{
	var int nShowKillerCount;
	var int nTeleportCount;
	var array<_PkPVPBookKiller> killers;
};

struct _S_EX_PVPBOOK_NEW_PK
{
	var string sName;
};

struct _C_EX_PVPBOOK_KILLER_LOCATION
{
	var string sName;
};

struct _S_EX_PVPBOOK_KILLER_LOCATION
{
	var string sName;
	var int nX;
	var int nY;
	var int nZ;
};

struct _C_EX_PVPBOOK_TELEPORT_TO_KILLER
{
	var string sName;
};

struct _S_EX_RAID_DROP_ITEM_ANNOUNCE
{
	var string sLastAttackerName;
	var int nNPCClassID;
	var array<int> dropItemClassIds;
};

struct _S_EX_LETTER_COLLECTOR_UI_LAUNCHER
{
	var byte bActivate;
	var int nMinLevel;
};

struct _C_EX_LETTER_COLLECTOR_TAKE_REWARD
{
	var int nSetNo;
};

struct _UserInfo_StatBonus
{
	var int nTotalBonus;
	var int nStrBonus;
	var int nDexBonus;
	var int nConBonus;
	var int nIntBonus;
	var int nWitBonus;
	var int nMenBonus;
};

struct _C_EX_SET_STATUS_BONUS
{
	var _UserInfo_StatBonus additionalStatBonus;
};

struct _C_EX_RESET_STATUS_BONUS
{
	var int cDummy;
};

struct _C_EX_OLYMPIAD_RANKING_INFO
{
	var int cRankingType;
	var int cRankingScope;
	var byte bCurrentSeason;
	var int nClassID;
	var int nWorldID;
};

struct _OlympiadRecentMatch
{
	var string sCharName;
	var int cResult;
	var int nLevel;
	var int nClassID;
};

struct _S_EX_OLYMPIAD_MY_RANKING_INFO
{
	var int nSeasonYear;
	var int nSeasonMonth;
	var int nSeason;
	var int nRank;
	var int nWinCount;
	var int nLoseCount;
	var int nOlympiadPoint;
	var int nPrevRank;
	var int nPrevWinCount;
	var int nPrevLoseCount;
	var int nPrevOlympiadPoint;
	var int nHeroCount;
	var int nLegendCount;
	var array<_OlympiadRecentMatch> recentMatches;
};

struct _OlympiadRankInfo
{
	var string sCharName;
	var string sPledgeName;
	var int nRank;
	var int nPrevRank;
	var int nWorldID;
	var int nLevel;
	var int nClassID;
	var int nPledgeLevel;
	var int nWinCount;
	var int nLoseCount;
	var int nOlympiadPoint;
	var int nHeroCount;
	var int nLegendCount;
};

struct _S_EX_OLYMPIAD_RANKING_INFO
{
	var int cRankingType;
	var int cRankingScope;
	var byte bCurrentSeason;
	var int nClassID;
	var int nWorldID;
	var int nTotalUser;
	var array<_OlympiadRankInfo> rankInfoList;
};

struct _OlympiadHeroInfo
{
	var string sCharName;
	var string sPledgeName;
	var int nWorldID;
	var int nRace;
	var int nSex;
	var int nClassID;
	var int nLevel;
	var int nCount;
	var int nWinCount;
	var int nLoseCount;
	var int nOlympiadPoint;
	var int nPledgeLevel;
};

struct _S_EX_OLYMPIAD_HERO_AND_LEGEND_INFO
{
	var _OlympiadHeroInfo legendInfo;
	var array<_OlympiadHeroInfo> heroInfoList;
};

struct _C_EX_CASTLEWAR_OBSERVER_START
{
	var int nCastleID;
};

struct _C_EX_RAID_TELEPORT_INFO
{
	var int cDummy;
};

struct _S_EX_RAID_TELEPORT_INFO
{
	var int nUsedFreeCount;
};

struct _C_EX_TELEPORT_TO_RAID_POSITION
{
	var int nRaidID;
};

struct _S_EX_CRAFT_INFO
{
	var int nPoint;
	var int nCharge;
	var byte bGiveItem;
};

struct _ItemServerInfo
{
	var int nItemServerId;
	var INT64 nAmount;
};

struct _C_EX_CRAFT_EXTRACT
{
	var array<_ItemServerInfo> Items;
};

struct _S_EX_CRAFT_EXTRACT
{
	var int cResult;
};

struct _C_EX_CRAFT_RANDOM_LOCK_SLOT
{
	var int nSlot;
};

struct _S_EX_CRAFT_RANDOM_LOCK_SLOT
{
	var int cResult;
};

struct _PKUserCraftSlotInfo
{
	var byte bLocked;
	var int nLockRemain;
	var int nItemClassID;
	var INT64 nItemAmount;
};

struct _S_EX_CRAFT_RANDOM_INFO
{
	var array<_PKUserCraftSlotInfo> slotInfoList;
};

struct _S_EX_CRAFT_RANDOM_REFRESH
{
	var int cResult;
};

struct _ItemWithEnchantInfo
{
	var int nItemClassID;
	var INT64 nAmount;
	var int cEnchanted;
};

struct _S_EX_CRAFT_RANDOM_MAKE
{
	var int cResult;
	var _ItemWithEnchantInfo Result;
};

struct _C_EX_MULTI_SELL_LIST
{
	var int nGroupID;
};

struct _C_EX_SAVE_ITEM_ANNOUNCE_SETTING
{
	var byte bAnonymity;
};

struct _S_EX_ITEM_ANNOUNCE_SETTING
{
	var byte bAnonymity;
};

struct _C_EX_OLYMPIAD_MATCH_MAKING
{
	var int cGameRuleType;
};

struct _C_EX_OLYMPIAD_MATCH_MAKING_CANCEL
{
	var int cGameRuleType;
};

struct _C_EX_OLYMPIAD_UI
{
	var int cGameRuleType;
};

struct _S_EX_USER_BOOST_STAT
{
	var int Type;
	var int Count;
	var int Percent;
};

struct _S_EX_ADEN_FORTRESS_SIEGE_HUD_INFO
{
	var int nFortressID;
	var int nSiegeState;
	var int nNowTime;
	var int nRemainTime;
};

struct _PLShopItemDataNew
{
	var int nSlotNum;
	var int nItemClassID;
	var int nCostItemId[5];
	var INT64 nCostItemAmount[5];
	var int sCostItemEnchant[5];
	var int nRemainItemAmount;
	var int nRemainSec;
	var int nRemainServerItemAmount;
	var int sCircleNum;
};

struct _S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW
{
	var int cShopIndex;
	var int cPage;
	var int cMaxPage;
	var array<_PLShopItemDataNew> vItemList;
};

struct _S_EX_VITAL_EX_INFO
{
	var int nVitalLegacyEndTime;
	var int nVitalMiracleEndTime;
	var int nVitalLegacyBonusExp;
	var int nVitalLegacyBonusAdena;
};

struct _S_EX_SHARED_POSITION_SHARING_UI
{
	var INT64 nSharingCostLCoin;
};

struct _C_EX_SHARED_POSITION_TELEPORT_UI
{
	var int nID;
};

struct _Position
{
	var int X;
	var int Y;
	var int Z;
};

struct _S_EX_SHARED_POSITION_TELEPORT_UI
{
	var string sName;
	var int nID;
	var int nRemainedCount;
	var _Position Position;
	var INT64 nTeleportCostLCoin;
};

struct _C_EX_SHARED_POSITION_TELEPORT
{
	var int nID;
};

struct _SlotItemClassID
{
	var int nST_UNDERWEAR;
	var int nST_HEAD;
	var int nST_RHAND;
	var int nST_LHAND;
	var int nST_GLOVES;
	var int nST_CHEST;
	var int nST_LEGS;
	var int nST_FEET;
	var int nST_BACK;
	var int nST_RLHAND;
	var int nST_HAIR;
	var int nST_HAIR2;
};

struct _OptionalNoKey
{
	var int nNormalOptionNo_ST_RHAND;
	var int nNormalOptionNo_ST_LHAND;
	var int nNormalOptionNo_ST_RLHAND;
	var int nRandomOptionNo_ST_RHAND;
	var int nRandomOptionNo_ST_LHAND;
	var int nRandomOptionNo_ST_RLHAND;
};

struct _SlotItemShapeShiftClassID
{
	var int nST_RHAND;
	var int nST_LHAND;
	var int nST_RLHAND;
	var int nST_GLOVES;
	var int nST_CHEST;
	var int nST_LEGS;
	var int nST_FEET;
	var int nST_HAIR;
	var int nST_HAIR2;
};

struct _CachedParameters
{
	var int nID;
	var int hRace;
	var int cSex;
	var int nOriginalClass;
	var _SlotItemClassID slotItemClassID;
	var _OptionalNoKey optionalNoKey;
	var int nMinNewSetItemEchantedEffect;
	var _SlotItemShapeShiftClassID slotItemShapeShiftClassID;
	var int cGuilty;
	var int nCriminalRate;
	var int nMCastingSpeed;
	var int nPCastingSpeed;
	var int nOrgSpeed[8];
	var float fMoveSpeedModifier;
	var float fAttackSpeedModifier;
	var float fCollisionRadius;
	var float fCollisionHeight;
	var int nFace;
	var int nHairShape;
	var int nHairColor;
	var string sNickName;
	var int nPledgeSId;
	var int nPledgeCrestId;
	var int nAllianceID;
	var int nAllianceCrestId;
	var int cStopMode;
	var int cSlow;
	var int cIsCombatMode;
	var int cYongmaType;
	var int nPrivateStore;
	var array<int> cubicClassIds;
	var int cDeosShowPartyWantedMessage;
	var int cEnvironment;
	var int hBonusCount;
	var int nYongmaClass;
	var int nNowClass;
	var int nFootEffect;
	var int cSNEnchant;
	var int cBackEnchant;
	var int cEventMatchTeamID;
	var int nPledgeEmblemId;
	var int cIsNobless;
	var int cHeroType;
	var int cIsFishingState;
	var int nFishingPosX;
	var int nFishingPosY;
	var int nFishingPosZ;
	var int nNameColor;
	var int nDirection;
	var int cSocialClass;
	var int hPledgeType;
	var int nNickNameColor;
	var int nCursedWeaponLevel;
	var int nPledgeNameValue;
	var int nTransformID;
	var int nAgathionID;
	var int nPvPRestrainStatus;
	var int nCP;
	var int nHP;
	var int nBaseHP;
	var int nMP;
	var int nBaseMP;
	var int cBRLectureMark;
	var array<int> abnormalVisualEffect;
	var int cPledgeGameUserFlag;
	var int cHairAccFlag;
	var int cRemainAP;
	var int nCursedWeaponClassId;
	var int nWaitActionId;
	var int nFirstRank;
	var int hNotoriety;
	var int nMainClass;
	var int nCharacterColorIndex;
	var int nWorldID;
};

struct _RealtimeParameters
{
	var int cCreateOrUpdate;
	var int cShowSpawnEvent;
	var int nInformingPosX;
	var int nInformingPosY;
	var int nInformingPosZ;
	var int nVehicleID;
	var string sName;
	var int cIsDead;
	var int cOrcRiderShapeLevel;
	var int nlastDeadStatus;
};

struct _S_EX_CHAR_INFO
{
	var _CachedParameters cachedParameters;
	var _RealtimeParameters realtimeParameters;
};

struct _C_EX_AUTH_RECONNECT
{
	var int nAccountID;
};

struct _S_EX_AUTH_RECONNECT
{
	var int nResult;
	var int nAuthReconnectKey;
};

struct _C_EX_PET_EQUIP_ITEM
{
	var int nItemServerId;
};

struct _C_EX_PET_UNEQUIP_ITEM
{
	var int nItemServerId;
};

struct _C_EX_EVOLVE_PET
{
	var int cDummy;
};

struct _S_EX_HOMUNCULUS_READY
{
	var byte bReady;
};

struct _S_EX_HOMUNCULUS_HPSPVP
{
	var int nHP;
	var INT64 nSP;
	var int nVP;
};

struct _C_EX_ENCHANT_HOMUNCULUS_SKILL
{
	var int Type;
	var int nIdx;
	var int nLevel;
};

struct _S_EX_RESET_HOMUNCULUS_SKILL_RESULT
{
	var int Type;
	var int nID;
	var int nIdx;
	var int nLevel;
};

struct _S_EX_ENCHANT_HOMUNCULUS_SKILL_RESULT
{
	var int Type;
	var int nID;
	var int nIdx;
	var int nLevel;
	var int MDice;
	var int HDice;
	var int SDice;
};

struct _S_EX_HOMUNCULUS_POINT_INFO
{
	var int nEnchantPoint;
	var int nNPCKillPoint;
	var int nInsertNPCKillPoint;
	var int nInitNPCKillPoint;
	var int nVPPoint;
	var int nInsertVPPoint;
	var int nInitVPPoint;
	var int nActivateSlotIndex;
};

struct _C_EX_HOMUNCULUS_ENCHANT_EXP
{
	var int nIdx;
};

struct _S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT
{
	var int Type;
	var int nID;
};

struct _C_EX_HOMUNCULUS_GET_ENCHANT_POINT
{
	var int Type;
};

struct _S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT
{
	var int Type;
	var int nEnchantType;
	var int nID;
};

struct _C_EX_HOMUNCULUS_INIT_POINT
{
	var int Type;
};

struct _S_EX_HOMUNCULUS_INIT_POINT_RESULT
{
	var int Type;
	var int nInitType;
	var int nID;
};

struct _C_EX_SHOW_HOMUNCULUS_INFO
{
	var int Type;
};

struct _S_EX_SHOW_BIRTH_INFO
{
	var int Type;
	var int CurrentHP;
	var int CurrentSP;
	var int CurrentVP;
	var INT64 ExpiredTime;
};

struct _C_EX_HOMUNCULUS_CREATE_START
{
	var int dummy;
};

struct _S_EX_HOMUNCULUS_CREATE_START_RESULT
{
	var int Type;
	var int nID;
};

struct _C_EX_HOMUNCULUS_INSERT
{
	var int Type;
};

struct _S_EX_HOMUNCULUS_INSERT_RESULT
{
	var int Type;
	var int nID;
};

struct _C_EX_HOMUNCULUS_SUMMON
{
	var int dummy;
};

struct _S_EX_HOMUNCULUS_SUMMON_RESULT
{
	var int Type;
	var int nID;
};

struct _C_EX_DELETE_HOMUNCULUS_DATA
{
	var int nIdx;
};

struct _S_EX_DELETE_HOMUNCLUS_DATA_RESULT
{
	var int Type;
	var int nID;
};

struct _C_EX_REQUEST_ACTIVATE_HOMUNCULUS
{
	var int nIdx;
	var byte bActivate;
};

struct _S_EX_ACTIVATE_HOMUNCULUS_RESULT
{
	var int Type;
	var byte bActivate;
	var int nID;
};

struct _C_EX_HOMUNCULUS_ACTIVATE_SLOT
{
	var int SlotIndex;
};

struct _S_EX_HOMUNCULUS_ACTIVATE_SLOT_RESULT
{
	var int Type;
};

struct _HomunculusData
{
	var int nIdx;
	var int nID;
	var int eType;
	var byte bActivate;
	var int m_nSkillID[6];
	var int m_nSkillLevel[6];
	var int m_nLevel;
	var int m_nExp;
	var int m_nHP;
	var int m_nAttack;
	var int m_nDefence;
	var int m_nCritical;
};

struct _S_EX_SHOW_HOMUNCULUS_LIST
{
	var array<_HomunculusData> vHomunDataInfos;
};

struct _S_EX_SHOW_HOMUNCULUS_COUPON_UI
{
	var int dummy;
};

struct _C_EX_SUMMON_HOMUNCULUS_COUPON
{
	var int nItemID;
};

struct _S_EX_SUMMON_HOMUNCULUS_COUPON_RESULT
{
	var int Type;
	var int nIdx;
};

struct _S_EX_TELEPORT_FAVORITES_LIST
{
	var byte bUIOn;
	var array<int> vZoneIDs;
};

struct _C_EX_TELEPORT_FAVORITES_UI_TOGGLE
{
	var byte bOn;
};

struct _C_EX_TELEPORT_FAVORITES_ADD_DEL
{
	var byte bAddOrDel;
	var int nZoneID;
};

struct _C_EX_MABLE_GAME_ROLL_DICE
{
	var int cDiceType;
};

struct _C_EX_MABLE_GAME_POPUP_OK
{
	var int cCellType;
};

struct _C_EX_MABLE_GAME_RESET
{
	var int nResetItemType;
};

struct _MableGameReward
{
	var int nPlayCount;
	var int nItemClassID;
	var INT64 nItemAmount;
};

struct _S_EX_MABLE_GAME_SHOW_PLAYER_STATE
{
	var int nMableGamePlayCount;
	var int nCurrentCellId;
	var int nRemainNormalDiceUseCount;
	var int nMaxNormalDiceUseCount;
	var int cCurrentState;
	var array<_MableGameReward> vFinishRewards;
	var array<_ItemInfo> vResetItems;
};

struct _S_EX_MABLE_GAME_DICE_RESULT
{
	var int nDice;
	var int nResultCellId;
	var int cResultCellType;
	var int nRemainNormalDiceUseCount;
};

struct _S_EX_MABLE_GAME_MOVE
{
	var int nMoveDelta;
	var int nResultCellId;
	var int cResultCellType;
};

struct _S_EX_MABLE_GAME_PRISON
{
	var int nMinDiceForLeavePrison;
	var int nMaxDiceForLeavePrison;
	var int nRemainCount;
};

struct _S_EX_MABLE_GAME_REWARD_ITEM
{
	var int nRewardItemClassId;
	var INT64 nRewardItemAmount;
};

struct _S_EX_MABLE_GAME_SKILL_INFO
{
	var int nSkillID;
	var int nLev;
};

struct _S_EX_MABLE_GAME_MINIGAME
{
	var int nBossType;
	var int nLuckyNumber;
	var int nMyDice;
	var int nBossDice;
	var int cMiniGameResult;
	var byte bLuckyNumber;
	var int nRewardItemClassId;
	var INT64 nRewardItemAmount;
};

struct _S_EX_MABLE_GAME_UI_LAUNCHER
{
	var byte bActivate;
};

struct _PetSkillInfo
{
	var int nSkillID;
	var int nSkillLv;
	var int nReuseDelayGroup;
	var byte bSkillEnchant;
	var byte bSkillLock;
};

struct _S_EX_PET_SKILL_LIST
{
	var byte acquireSkillsByEnterWorldEvent;
	var array<_PetSkillInfo> acquireSkillList;
};

struct _S_EX_OPEN_BLESS_OPTION_SCROLL
{
	var int nScrollItemClassID;
};

struct _C_EX_BLESS_OPTION_PUT_ITEM
{
	var int nPutItemSId;
};

struct _S_EX_BLESS_OPTION_PUT_ITEM
{
	var byte bResult;
};

struct _C_EX_BLESS_OPTION_ENCHANT
{
	var int nPuItemSId;
};

struct _S_EX_BLESS_OPTION_ENCHANT
{
	var int cResult;
};

struct _C_EX_FESTIVAL_BM_INFO
{
	var int cIsOpenWindow;
};

struct _S_EX_FESTIVAL_BM_INFO
{
	var int nTicketItemClassId;
	var INT64 nTicketItemAmount;
	var int nTicketItemAmountPerGame;
};

struct _tFestivalBmInfo
{
	var int cFestivalBmGrade;
	var int nFestivalBmItemClassId;
	var int nFestivalBmItemCount;
	var int nFestivalBmItemMaxCount;
};

struct _S_EX_FESTIVAL_BM_ALL_ITEM_INFO
{
	var int nFestivalBmSeason;
	var array<_tFestivalBmInfo> vFestivalBmAllInfoList;
};

struct _S_EX_FESTIVAL_BM_TOP_ITEM_INFO
{
	var int cIsUseFestivalBm;
	var int nFestivalBmSeason;
	var int nFestivalEndTime;
	var array<_tFestivalBmInfo> vFestivalBmTopInfoList;
};

struct _C_EX_FESTIVAL_BM_GAME
{
	var int nTicketCount;
};

struct _S_EX_FESTIVAL_BM_GAME
{
	var int cFestivalBmGameResult;
	var int nTicketItemClassId;
	var INT64 nTicketItemAmount;
	var int nTicketItemAmountPerGame;
	var int cRewardItemGrade;
	var int nRewardItemClassId;
	var int nRewardItemCount;
};

struct _S_EX_PVP_RANKING_MY_INFO
{
	var byte cType;
	var INT64 nPVPPoint;
	var int nRank;
	var int nPrevRank;
	var int nKillCount;
	var int nDieCount;
};

struct _C_EX_PVP_RANKING_MY_INFO
{
	var byte cType;
};

struct _C_EX_PVP_RANKING_LIST
{
	var byte cType;
	var byte bCurrentSeason;
	var int cRankingGroup;
	var int cRankingScope;
	var int nRace;
};

struct _PKPenaltyUser
{
	var int nUserID;
	var string charName;
	var int nLevel;
	var int nClass;
};

struct _S_EX_PK_PENALTY_LIST
{
	var int tSnapshot;
	var array<_PKPenaltyUser> PKUserList;
};

struct _PKPenaltyUserLocation
{
	var int nUserID;
	var int X;
	var int Y;
	var int Z;
};

struct _S_EX_PK_PENALTY_LIST_ONLY_LOC
{
	var int tSnapshot;
	var array<_PKPenaltyUserLocation> PKUserList;
};

struct _PVPRankingRankInfo
{
	var string sCharName;
	var string sPledgeName;
	var int nLevel;
	var int nRace;
	var int nClass;
	var INT64 nPVPPoint;
	var int nRank;
	var int nPrevRank;
	var int nKillCount;
	var int nDieCount;
};

struct _S_EX_PVP_RANKING_LIST
{
	var byte cType;
	var byte bCurrentSeason;
	var int cRankingGroup;
	var int cRankingScope;
	var int nRace;
	var array<_PVPRankingRankInfo> rankInfoList;
};

struct _C_EX_ACQUIRE_PET_SKILL
{
	var int nSkillID;
	var int nSkillLv;
};

struct _S_EX_PLEDGE_V3_INFO
{
	var int nPledgeExp;
	var int nPledgeRank;
	var string sAnnounceContent;
	var byte bShowAnnounce;
};

struct _C_EX_PLEDGE_ENEMY_INFO_LIST
{
	var int nPledgeSId;
};

struct _L2PledgeEnemyInfo
{
	var int nEnemyPledgeWorldID;
	var int nEnemyPledgeSID;
	var string sEnemyPledgeName;
	var string sEnemyPledgeMasterName;
};

struct _S_EX_PLEDGE_ENEMY_INFO_LIST
{
	var array<_L2PledgeEnemyInfo> L2PledgeEnemyInfoList;
};

struct _C_EX_PLEDGE_ENEMY_REGISTER
{
	var string sEnemyPledgeName;
};

struct _C_EX_PLEDGE_ENEMY_DELETE
{
	var int nEnemyPledgeSID;
};

struct _S_EX_SHOW_PET_EXTRACT_SYSTEM
{
	var int cDummy;
};

struct _S_EX_HIDE_PET_EXTRACT_SYSTEM
{
	var int cDummy;
};

struct _C_EX_TRY_PET_EXTRACT_SYSTEM
{
	var int nPetItemSID;
};

struct _S_EX_RESULT_PET_EXTRACT_SYSTEM
{
	var byte bSuccess;
};

struct _C_EX_PLEDGE_V3_SET_ANNOUNCE
{
	var string sAnnounceContent;
	var byte bShowAnnounce;
};

struct _C_EX_PLEDGE_V3_INFO
{
	var int cDummy;
};

struct _ItemDeletionInfo
{
	var int nItemID;
	var int nDeletionDate;
};

struct _SkillDeletionInfo
{
	var int nSkillID;
	var int nDeletionDate;
};

struct _S_EX_DBJOB_DELETION_INFO
{
	var array<_ItemDeletionInfo> itemDeletionList;
	var array<_SkillDeletionInfo> skillDeletionList;
};

struct _RFRankingInfo
{
	var int nRank;
	var string charName;
	var int nBuyCount;
};

struct _RFRankingRewardInfo
{
	var int nStartRank;
	var int nEndRank;
	var int nRewardItemClassId;
	var INT64 nRewardItemAmount;
};

struct _RFBonusInfo
{
	var int nPoint;
	var int nRewardItemClassId;
	var INT64 nRewardItemAmount;
};

struct _RFBuyItemInfo
{
	var int nBuyId;
	var int nType;
	var byte bSale;
	var int nBuyItemClassId;
	var INT64 nBuyItemAmount;
	var int nCostItemClassID;
	var INT64 nCostItemAmount;
};

struct _S_EX_RANKING_FESTIVAL_SIDEBAR_INFO
{
	var byte bShowEvent;
	var byte bOnEvent;
	var INT64 nEndTime;
	var byte bRequestRanking;
	var int nCostType;
	var array<_RFRankingInfo> rankingInfos;
	var array<_RFRankingRewardInfo> rankingRewardInfos;
	var array<_RFBonusInfo> bonusInfos;
	var array<_RFBuyItemInfo> buyItemInfos;
};

struct _C_EX_RANKING_FESTIVAL_OPEN
{
	var int dummy;
};

struct _C_EX_RANKING_FESTIVAL_BUY
{
	var int nBuyId;
	var int nBuyCount;
};

struct _S_EX_RANKING_FESTIVAL_BUY
{
	var byte bSuccess;
};

struct _C_EX_RANKING_FESTIVAL_BONUS
{
	var array<int> nPoints;
};

struct _S_EX_RANKING_FESTIVAL_BONUS
{
	var byte bSuccess;
	var array<int> nPoints;
	var array<_RFBonusInfo> bonusInfos;
};

struct _C_EX_RANKING_FESTIVAL_RANKING
{
	var int nRankingType;
};

struct _S_EX_RANKING_FESTIVAL_RANKING
{
	var int nRankingType;
	var int nMyRanking;
	var array<_RFRankingInfo> rankingInfos;
};

struct _S_EX_RANKING_FESTIVAL_MYINFO
{
	var int nMyRanking;
	var int nTotalBuyCount;
	var byte bReceiveReward;
};

struct _C_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS
{
	var int dummy;
};

struct _S_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS
{
	var array<int> receivedPoints;
};

struct _C_EX_RANKING_FESTIVAL_REWARD
{
	var int dummy;
};

struct _S_EX_RANKING_FESTIVAL_REWARD
{
	var byte bSuccess;
};

struct _C_EX_REFUND_REQ
{
	var int dpEconomyFromClient;
	var array<int> refunds;
};

struct _C_EX_TIMER_CHECK
{
	var int nType;
	var int nIndex;
};

struct _S_EX_TIMER_CHECK
{
	var int nType;
	var int nIndex;
	var byte bFinished;
	var int nCurrentTime;
	var int nEndTime;
};

struct _C_EX_STEADY_BOX_LOAD
{
	var byte bDummy;
};

struct _C_EX_STEADY_OPEN_SLOT
{
	var int nSlotID;
};

struct _C_EX_STEADY_OPEN_BOX
{
	var int nSlotID;
	var INT64 nAmount;
};

struct _C_EX_STEADY_GET_REWARD
{
	var int nSlotID;
};

struct _SteadyBoxPrice
{
	var int nIndex;
	var int nItemType;
	var INT64 nAmount;
};

struct _S_EX_STEADY_BOX_UI_INIT
{
	var int nConstantMaxPoint;
	var int nEventMaxPoint;
	var int nEventID;
	var int nEventStartTime;
	var int nEventEndTime;
	var array<_SteadyBoxPrice> vPriceBoxOpen;
	var array<_SteadyBoxPrice> vPriceForTime;
	var int nBoxOpenEndTime;
};

struct _SlotInfo
{
	var int nSlotID;
	var int nSlotState;
	var int nBoxType;
};

struct _S_EX_STEADY_ALL_BOX_UPDATE
{
	var int nConstantCurrentPoint;
	var int nEventGoalCurrentPoint;
	var array<_SlotInfo> vMySlotList;
	var int nEndTime;
};

struct _S_EX_STEADY_ONE_BOX_UPDATE
{
	var int nConstantCurrentPoint;
	var int nEventGoalCurrentPoint;
	var _SlotInfo MySlot;
	var int nEndTime;
};

struct _S_EX_STEADY_BOX_REWARD
{
	var int nSlotID;
	var int nItemType;
	var INT64 nAmount;
	var int nEnchant;
};

struct _C_EX_PET_RANKING_MY_INFO
{
	var int nCollarID;
};

struct _S_EX_PET_RANKING_MY_INFO
{
	var string sNickName;
	var int nCollarID;
	var int nNPCClassID;
	var int nIndex;
	var int nLevel;
	var int nRank;
	var int nPrevRank;
	var int nRaceRank;
	var int nPrevRaceRank;
};

struct _C_EX_PET_RANKING_LIST
{
	var int cRankingGroup;
	var int cRankingScope;
	var int nIndex;
	var int nCollarID;
};

struct _PkPetRankingRankerInfo
{
	var string sNickName;
	var string sUserName;
	var string sPledgeName;
	var int nNPCClassID;
	var int nPetIndex;
	var int nPetLevel;
	var int nUserRace;
	var int nUserLevel;
	var int nRank;
	var int nPrevRank;
};

struct _S_EX_PET_RANKING_LIST
{
	var int cRankingGroup;
	var int cRankingScope;
	var int nIndex;
	var int nCollarID;
	var array<_PkPetRankingRankerInfo> rankerInfoList;
};

struct _CollectionItemInfo
{
	var int cSlotIndex;
	var int nItemClassID;
	var int cEnchant;
	var byte bBless;
	var int cBlessCondition;
	var int nAmount;
};

struct _CollectionInfo
{
	var array<_CollectionItemInfo> itemInfoList;
	var int nCollectionID;
};

struct _S_EX_COLLECTION_INFO
{
	var array<_CollectionInfo> regInfoList;
	var array<int> favoriteList;
	var array<int> rewardList;
	var int cCategory;
	var int nTotalCollectionCount;
};

struct _C_EX_COLLECTION_OPEN_UI
{
	var int cDummy;
};

struct _S_EX_COLLECTION_OPEN_UI
{
	var int cDummy;
};

struct _C_EX_COLLECTION_CLOSE_UI
{
	var int cDummy;
};

struct _S_EX_COLLECTION_CLOSE_UI
{
	var int cDummy;
};

struct _C_EX_COLLECTION_LIST
{
	var int cCategory;
};

struct _CollectionPeriodInfo
{
	var int nCollectionID;
	var int nRemainTime;
};

struct _S_EX_COLLECTION_LIST
{
	var int cCategory;
	var array<_CollectionPeriodInfo> periodInfoList;
};

struct _C_EX_COLLECTION_UPDATE_FAVORITE
{
	var byte bRegister;
	var int nCollectionID;
};

struct _S_EX_COLLECTION_UPDATE_FAVORITE
{
	var byte bRegister;
	var int nCollectionID;
};

struct _C_EX_COLLECTION_FAVORITE_LIST
{
	var int cDummy;
};

struct _S_EX_COLLECTION_FAVORITE_LIST
{
	var array<_CollectionPeriodInfo> periodInfoList;
};

struct _C_EX_COLLECTION_SUMMARY
{
	var int cDummy;
};

struct _S_EX_COLLECTION_SUMMARY
{
	var array<_CollectionPeriodInfo> periodInfoList;
};

struct _C_EX_COLLECTION_REGISTER
{
	var int nCollectionID;
	var int nSlotNumber;
	var int nItemSid;
};

struct _S_EX_COLLECTION_REGISTER
{
	var int nCollectionID;
	var byte bSuccess;
	var byte bRecursiveReward;
	var _CollectionItemInfo ItemInfo;
};

struct _S_EX_COLLECTION_COMPLETE
{
	var int nCollectionID;
	var int nRemainTime;
};

struct _C_EX_COLLECTION_RECEIVE_REWARD
{
	var int nCollectionID;
};

struct _S_EX_COLLECTION_RECEIVE_REWARD
{
	var int nCollectionID;
	var byte bSuccess;
};

struct _S_EX_COLLECTION_RESET
{
	var int nCollectionID;
	var array<int> slotList;
};

struct _S_EX_COLLECTION_ACTIVE_EVENT
{
	var array<int> activeEventList;
};

struct _S_EX_COLLECTION_RESET_REWARD
{
	var array<int> resetList;
};

struct _C_EX_PVPBOOK_SHARE_REVENGE_LIST
{
	var int nOwnerUserSID;
};

struct _CLNTPVPBookShareRevengeInfo
{
	var int nShareType;
	var int nKilledTime;
	var int nShowKillerCount;
	var int nTeleportKillerCount;
	var int nSharedTeleportKillerCount;
	var int nKilledUserDBID;
	var string sKilledUserName;
	var string sKilledUserPledgeName;
	var int nKilledUserLevel;
	var int nKilledUserRace;
	var int nKilledUserClass;
	var int nKillUserDBID;
	var string sKillUserName;
	var string sKillUserPledgeName;
	var int nKillUserLevel;
	var int nKillUserRace;
	var int nKillUserClass;
	var int nKillUserOnline;
	var int nKillUserKarma;
	var int nSharedTime;
};

struct _S_EX_PVPBOOK_SHARE_REVENGE_LIST
{
	var int cCurrentPage;
	var int cMaxPage;
	var array<_CLNTPVPBookShareRevengeInfo> RevengeInfo;
};

struct _C_EX_PVPBOOK_SHARE_REVENGE_REQ_SHARE_REVENGEINFO
{
	var string sKilledUserName;
	var string sKillUserName;
	var int nShareType;
};

struct _C_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION
{
	var string sKilledUserName;
	var string sKillUserName;
};

struct _S_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION
{
	var string sKillUserName;
	var int nX;
	var int nY;
	var int nZ;
};

struct _C_EX_PVPBOOK_SHARE_REVENGE_TELEPORT_TO_KILLER
{
	var string sKilledUserName;
	var string sKillUserName;
};

struct _C_EX_PVPBOOK_SHARE_REVENGE_SHARED_TELEPORT_TO_KILLER
{
	var string sKilledUserName;
	var string sKillUserName;
};

struct _S_EX_PVPBOOK_SHARE_REVENGE_NEW_REVENGEINFO
{
	var int nShareType;
	var string sKilledUserName;
	var string sKillUserName;
};

struct _pkUserWatcherTarget
{
	var string sName;
	var int nWorldID;
	var int nLevel;
	var int nClass;
	var byte bLoggedin;
};

struct _S_EX_USER_WATCHER_TARGET_LIST
{
	var array<_pkUserWatcherTarget> targetList;
};

struct _S_EX_USER_WATCHER_TARGET_STATUS
{
	var string sName;
	var int nWorldID;
	var byte bLoggedin;
};

struct _C_EX_USER_WATCHER_ADD
{
	var string sTargetName;
	var int nTargetWorldID;
};

struct _C_EX_USER_WATCHER_DELETE
{
	var string sTargetName;
	var int nTargetWorldID;
};

struct _C_EX_PENALTY_ITEM_LIST
{
	var int nReserved;
};

struct _PkPenaltyItem
{
	var int nItemDBID;
	var int nDropDate;
	var INT64 nRestoreCost;
	var int nRestoreLCoin;
	var array<byte> itemAssemble;
};

struct _S_EX_PENALTY_ITEM_LIST
{
	var array<_PkPenaltyItem> Items;
};

struct _C_EX_PENALTY_ITEM_RESTORE
{
	var int nItemDBID;
	var byte bByAdena;
};

struct _S_EX_PENALTY_ITEM_RESTORE
{
	var int nResult;
};

struct _S_EX_PENALTY_ITEM_DROP
{
	var int X;
	var int Y;
	var int Z;
	var int nItemClassID;
};

struct _S_EX_PENALTY_ITEM_INFO
{
	var int nCount;
	var int nMaxCount;
};

struct _S_EX_MAGIC_SKILL_USE_GROUND
{
	var int nSID;
	var int nSkillID;
	var int nSkillTargetPosX;
	var int nSkillTargetPosY;
	var int nSkillTargetPosZ;
};

struct _S_EX_SUBJUGATION_SIDEBAR
{
	var int nID;
	var int nPoint;
	var int nGachaPoint;
};

struct _PkSubjugationInfo
{
	var int nID;
	var int nPoint;
	var int nGachaPoint;
	var int nRemainedPeriodicGachaPoint;
};

struct _S_EX_SUBJUGATION_LIST
{
	var array<_PkSubjugationInfo> vInfos;
};

struct _C_EX_SUBJUGATION_RANKING
{
	var int nID;
};

struct _PkSubjugationRanker
{
	var string sUserName;
	var int nPoint;
	var int nRank;
};

struct _S_EX_SUBJUGATION_RANKING
{
	var array<_PkSubjugationRanker> vRankers;
	var int nID;
	var int nPoint;
	var int nRank;
};

struct _C_EX_SUBJUGATION_GACHA_UI
{
	var int nID;
};

struct _S_EX_SUBJUGATION_GACHA_UI
{
	var int nGachaPoint;
};

struct _C_EX_SUBJUGATION_GACHA
{
	var int nID;
	var int nCount;
};

struct _PkSubjugationGachaItem
{
	var int nClassID;
	var int nAmount;
};

struct _S_EX_SUBJUGATION_GACHA
{
	var array<_PkSubjugationGachaItem> vItems;
};

struct _PkUserViewInfoParameter
{
	var int Type;
	var int Value;
};

struct _S_EX_USER_VIEW_INFO_PARAMETER
{
	var array<_PkUserViewInfoParameter> Parameters;
};

struct _C_EX_PLEDGE_DONATION_INFO
{
	var int cDummy;
};

struct _S_EX_PLEDGE_DONATION_INFO
{
	var int nRemainCount;
	var byte bNewbie;
};

struct _C_EX_PLEDGE_DONATION_REQUEST
{
	var int cDonationType;
};

struct _S_EX_PLEDGE_DONATION_REQUEST
{
	var int cDonationType;
	var int nResultType;
	var byte bCritical;
	var int nPledgeCoin;
	var int nPledgeExp;
	var _ItemInfo rewardItem;
	var int nRemainCount;
};

struct _C_EX_PLEDGE_CONTRIBUTION_LIST
{
	var int cDummy;
};

struct _PkPledgeContribution
{
	var string sUserName;
	var int nCurrentContribution;
	var int nTotalContribution;
};

struct _S_EX_PLEDGE_CONTRIBUTION_LIST
{
	var array<_PkPledgeContribution> contributionList;
};

struct _C_EX_PLEDGE_RANKING_MY_INFO
{
	var int cDummy;
};

struct _S_EX_PLEDGE_RANKING_MY_INFO
{
	var int nRank;
	var int nPrevRank;
	var int nPledgeExp;
};

struct _C_EX_PLEDGE_RANKING_LIST
{
	var int cRankingScope;
};

struct _PkPledgeRanking
{
	var int nRank;
	var int nPrevRank;
	var string sPledgeName;
	var int nPledgeLevel;
	var string sPledgeMasterName;
	var int nPledgeMasterLevel;
	var int nPledgeMemberCount;
	var int nPledgeExp;
};

struct _S_EX_PLEDGE_RANKING_LIST
{
	var int cRankingScope;
	var array<_PkPledgeRanking> rankingList;
};

struct _S_EX_PLEDGE_COIN_INFO
{
	var int nPledgeCoin;
};

struct _C_EX_ITEM_RESTORE_LIST
{
	var int cCategory;
};

struct _PkItemRestoreNode
{
	var int nBrokenItemClassID;
	var int nFixedItemClassID;
	var int cEnchant;
	var int cOrder;
};

struct _S_EX_ITEM_RESTORE_LIST
{
	var int cCategory;
	var array<_PkItemRestoreNode> Items;
};

struct _C_EX_ITEM_RESTORE
{
	var int nBrokenItemClassID;
	var int cEnchant;
};

struct _S_EX_ITEM_RESTORE
{
	var int cResult;
};

struct _C_EX_DETHRONE_INFO
{
	var int cDummy;
};

struct _C_EX_DETHRONE_RANKING_INFO
{
	var byte bCurrentSeason;
	var int cRankingScope;
};

struct _C_EX_DETHRONE_SERVER_INFO
{
	var int cDummy;
};

struct _C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO
{
	var int cCategory;
};

struct _C_EX_DETHRONE_DAILY_MISSION_INFO
{
	var int cDummy;
};

struct _C_EX_DETHRONE_DAILY_MISSION_GET_REWARD
{
	var int nID;
};

struct _C_EX_DETHRONE_PREV_SEASON_INFO
{
	var int cDummy;
};

struct _C_EX_DETHRONE_GET_REWARD
{
	var int cDummy;
};

struct _C_EX_DETHRONE_ENTER
{
	var int cDummy;
};

struct _C_EX_DETHRONE_LEAVE
{
	var int cDummy;
};

struct _C_EX_DETHRONE_CHECK_NAME
{
	var string sName;
};

struct _C_EX_DETHRONE_CHANGE_NAME
{
	var string sName;
};

struct _C_EX_DETHRONE_CONNECT_CASTLE
{
	var int cDummy;
};

struct _C_EX_DETHRONE_DISCONNECT_CASTLE
{
	var int cDummy;
};

struct _S_EX_DETHRONE_INFO
{
	var string sName;
	var int nAttackPoint;
	var int nLife;
	var int nRank;
	var int nTotalRankers;
	var INT64 nPersonalDethronePoint;
	var int nPrevRank;
	var int nPrevTotalRankers;
	var INT64 nPrevDethronePoint;
	var int nServerRank;
	var INT64 nServerDethronePoint;
	var int nConquerorWorldID;
	var string sConquerorName;
	var int nOccupyingServerWorldID;
	var int nTopRankerWorldID;
	var string sTopRankerName;
	var int nTopServerWorldID;
	var INT64 nTopServerDethronePoint;
};

struct _PkDethroneRankingInfo
{
	var int nRank;
	var int nWorldID;
	var string sName;
	var INT64 nDethronePoint;
};

struct _S_EX_DETHRONE_RANKING_INFO
{
	var byte bCurrentSeason;
	var int cRankingScope;
	var int nTotalRankers;
	var array<_PkDethroneRankingInfo> rankInfoList;
};

struct _PkDethronePointInfo
{
	var int nRank;
	var int nWorldID;
	var INT64 nPoint;
};

struct _PkDethroneSoulBeadInfo
{
	var int nRank;
	var int nWorldID;
	var INT64 nSoulBead;
};

struct _S_EX_DETHRONE_SERVER_INFO
{
	var array<_PkDethronePointInfo> pointInfoList;
	var array<_PkDethroneSoulBeadInfo> soulBeadInfoList;
	var array<int> connectionList;
	var byte bAdenCastleOwner;
	var int nDethroneWorldID;
};

struct _PkDethroneDistrictOccupationInfo
{
	var int nDistrictID;
	var int nOccupyingWorldID;
	var array<_PkDethronePointInfo> pointInfoList;
};

struct _S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO
{
	var int cCategory;
	var array<_PkDethroneDistrictOccupationInfo> occupationInfoList;
};

struct _PkDethroneDailyMissionInfo
{
	var int nID;
	var int nCount;
	var byte bHasReward;
};

struct _S_EX_DETHRONE_DAILY_MISSION_INFO
{
	var array<_PkDethroneDailyMissionInfo> missionInfoList;
};

struct _S_EX_DETHRONE_DAILY_MISSION_GET_REWARD
{
	var int nID;
	var byte bSuccess;
	var INT64 nPersonalDethronePoint;
	var INT64 nServerDethronePoint;
};

struct _S_EX_DETHRONE_DAILY_MISSION_COMPLETE
{
	var int nCompleteMissionCount;
};

struct _PkDethronePoint
{
	var int nWorldID;
	var INT64 nPoint;
};

struct _S_EX_DETHRONE_PREV_SEASON_INFO
{
	var string sConquerorName;
	var int nRank;
	var int nTotalRankers;
	var int nOccupyingWorldID;
	var array<_PkDethronePoint> pointList;
	var INT64 nTotalSoulBead;
	var INT64 nOccupyingServerReward;
	var array<_ItemInfo> personalRewardList;
	var array<_ItemInfo> serverRewardList;
	var byte bHasReward;
};

struct _S_EX_DETHRONE_GET_REWARD
{
	var int nResult;
};

struct _S_EX_DETHRONE_CHECK_NAME
{
	var int nResult;
};

struct _S_EX_DETHRONE_CHANGE_NAME
{
	var byte bSuccess;
	var string sName;
};

struct _S_EX_DETHRONE_CONNECT_CASTLE
{
	var int nResult;
};

struct _S_EX_DETHRONE_DISCONNECT_CASTLE
{
	var int nResult;
};

struct _S_EX_DETHRONE_SEASON_INFO
{
	var int nSeasonYear;
	var int nSeasonMonth;
	var byte bOpen;
};

struct _C_EX_PACKETREADCOUNTPERSECOND
{
	var int packet_num;
	var int packet_count;
	var int packet_num_1;
	var int packet_count_1;
	var int packet_num_2;
	var int packet_count_2;
};

struct _S_EX_SERVERLIMIT_ITEM_ANNOUNCE
{
	var int cType;
	var string sUserName;
	var int nItemClassID;
	var int nGetAmount;
	var int nRemainAmount;
	var int nMaxAmount;
};

struct _S_EX_CHANGE_NICKNAME_COLOR_ICON
{
	var int nItemClassID;
};

struct _C_EX_CHANGE_NICKNAME_COLOR_ICON
{
	var int nItemClassID;
	var int nColorIndex;
	var string sNickName;
};

struct _C_EX_WORLDCASTLEWAR_MOVE_TO_HOST
{
	var int nUserSID;
	var int nCastleID;
};

struct _C_EX_WORLDCASTLEWAR_RETURN_TO_ORIGIN_PEER
{
	var int nUserSID;
	var int nCastleID;
};

struct _C_EX_WORLDCASTLEWAR_CASTLE_INFO
{
	var int nCastleID;
};

struct _S_EX_WORLDCASTLEWAR_CASTLE_INFO
{
	var int nCastleID;
	var int nCastleOwnerPledgeSID;
	var int nCastleOwnerPledgeCrestDBID;
	var string wstrCastleOwnerPledgeName;
	var string wstrCastleOwnerPledgeMasterName;
	var int nNextSiegeTime;
};

struct _C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO
{
	var int nCastleID;
};

struct _S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO
{
	var int nCastleID;
	var int nCastleOwnerPledgeSID;
	var int nCastleOwnerPledgeCrestDBID;
	var string wstrCastleOwnerPledgeName;
	var string wstrCastleOwnerPledgeMasterName;
	var int nSiegeState;
};

struct _S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_HUD_INFO
{
	var int nCastleID;
	var int nSiegeState;
	var int nNowTime;
	var int nRemainTime;
};

struct _C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_JOIN
{
	var int nCastleID;
	var int nAsAttacker;
	var int nIsRegister;
};

struct _C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST
{
	var int nCastleID;
};

struct _C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET
{
	var int nCastleID;
	var int nType;
	var int nIsMercenaryRecruit;
};

struct _C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST
{
	var int nCastleID;
	var int nPledgeSId;
};

struct _WorldCastleWar_MercenaryMemberInfo
{
	var int nIsMyInfo;
	var int nIsOnline;
	var string wstrMercenaryName;
	var int nClassType;
};

struct _S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST
{
	var int nCastleID;
	var int nPledgeSId;
	var array<_WorldCastleWar_MercenaryMemberInfo> lstWorldCastleWarMercenaryMemberList;
};

struct _C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN
{
	var int nUserSID;
	var int nType;
	var int nCastleID;
	var int nMercenaryPledgeSID;
};

struct _S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN
{
	var int nResult;
	var int nType;
	var int nUserSID;
	var int nMercenaryPledgeSID;
};

struct _C_EX_WORLDCASTLEWAR_TELEPORT
{
	var int nTeleportID;
};

struct _C_EX_WORLDCASTLEWAR_OBSERVER_START
{
	var int nCastleID;
};

struct _WorldCastleWar_MainBattleOccupyInfo
{
	var int nOccupyNPCSID;
	var int nOccupyNPCClassID;
	var int nOccypyNPCState;
	var int nOccupiedPledgeSID;
	var _Position nOccypyNPCLocation;
};

struct _S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_OCCUPY_INFO
{
	var int nCastleID;
	var array<_WorldCastleWar_MainBattleOccupyInfo> lstWorldCastleWar_MainBattleOccupyInfoList;
};

struct _WorldCastleWar_MainBattleHeroWeaponInfo
{
	var int nHeroWeaponNPCSID;
	var int nHeroWeaponNPCClassID;
	var int nHeroWeaponNPCState;
	var _Position nHeroWeaponNPCLocation;
};

struct _S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_INFO
{
	var int nCastleID;
	var array<_WorldCastleWar_MainBattleHeroWeaponInfo> lstWorldCastleWar_MainBattleHeroWeaponInfoList;
};

struct _WorldCastleWar_MainBattleHeroWeaponUserInfo
{
	var int nHeroWeaponUserSID;
	var string sHeroWeaponUserName;
	var _Position nHeroWeaponUserLocation;
};

struct _S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_USER
{
	var int nCastleID;
	var array<_WorldCastleWar_MainBattleHeroWeaponUserInfo> lstWorldCastleWar_MainBattleHeroWeaponUserInfoList;
};

struct _WorldCastleWar_MainBattleSiegeGolemInfo
{
	var int nSiegeGolemNPCSID;
	var int nSiegeGolemNPCClassID;
	var int nSiegeGolemNPCState;
	var _Position nSiegeGolemNPCLocation;
};

struct _S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_SIEGE_GOLEM_INFO
{
	var int nCastleID;
	var array<_WorldCastleWar_MainBattleSiegeGolemInfo> lstWorldCastleWar_MainBattleSiegeGolemInfoList;
};

struct _WorldCastleWar_MainBattleDoorInfo
{
	var int nDoorStaticObjectID;
	var int nDoorSID;
	var int nDoorState;
};

struct _S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO
{
	var int nCastleID;
	var array<_WorldCastleWar_MainBattleDoorInfo> lstWorldCastleWar_MainBattleDoorInfoList;
};

struct _C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO
{
	var int nCastleID;
};

struct _S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO
{
	var int nCastleID;
	var array<_WorldCastleWar_MainBattleOccupyInfo> lstWorldCastleWar_MainBattleOccupyInfoList;
	var array<_WorldCastleWar_MainBattleHeroWeaponInfo> lstWorldCastleWar_MainBattleHeroWeaponInfoList;
	var array<_WorldCastleWar_MainBattleHeroWeaponUserInfo> lstWorldCastleWar_MainBattleHeroWeaponUserInfoList;
	var array<_WorldCastleWar_MainBattleSiegeGolemInfo> lstWorldCastleWar_MainBattleSiegeGolemInfoList;
	var array<_WorldCastleWar_MainBattleDoorInfo> lstWorldCastleWar_MainBattleDoorInfoList;
};

struct _S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO
{
	var int nCastleID;
	var int nSiegeState;
	var int nNowTime;
	var int nRemainTime;
	var int nNextSiegeTime;
};

struct _C_EX_PRIVATE_STORE_SEARCH_LIST
{
	var string sSearchWord;
	var int cStoreType;
	var int cItemType;
	var int cItemSubtype;
	var byte bSearchCollection;
};

struct _pkPSSearchItem
{
	var string sUserName;
	var int nUserSID;
	var int cStoreType;
	var INT64 nPrice;
	var int nX;
	var int nY;
	var int nZ;
	var array<byte> itemAssemble;
};

struct _S_EX_PRIVATE_STORE_SEARCH_ITEM
{
	var int cCurrentPage;
	var int cMaxPage;
	var array<_pkPSSearchItem> Items;
};

struct _pkPSSearchHistory
{
	var int nClassID;
	var int cStoreType;
	var int cEnchant;
	var INT64 nPrice;
	var INT64 nAmount;
};

struct _S_EX_PRIVATE_STORE_SEARCH_HISTORY
{
	var int cCurrentPage;
	var int cMaxPage;
	var array<_pkPSSearchHistory> histories;
};

struct _pkPSSearchMostItem
{
	var int nCount;
	var array<byte> itemAssemble;
};

struct _pkPSSearchHighestItem
{
	var INT64 nPrice;
	var array<byte> itemAssemble;
};

struct _S_EX_PRIVATE_STORE_SEARCH_STATISTICS
{
	var array<_pkPSSearchMostItem> mostItems;
	var array<_pkPSSearchHighestItem> highestItems;
};

struct _C_EX_PRIVATE_STORE_BUY_SELL
{
	var int nTargetSid;
};

struct _NewHennaInfo
{
	var int nHennaID;
	var int nPotenID;
	var int cActive;
	var int nEnchantStep;
	var int nEnchantExp;
	var int nActiveStep;
	var int nDailyStep;
	var int nDailyCount;
};

struct _S_EX_NEW_HENNA_LIST
{
	var int nDailyStep;
	var int nDailyCount;
	var array<_NewHennaInfo> hennaInfoList;
};

struct _C_EX_NEW_HENNA_EQUIP
{
	var int cSlotID;
	var int nItemSid;
};

struct _S_EX_NEW_HENNA_EQUIP
{
	var int cSlotID;
	var int nHennaID;
	var int cSuccess;
};

struct _C_EX_NEW_HENNA_UNEQUIP
{
	var int cSlotID;
};

struct _S_EX_NEW_HENNA_UNEQUIP
{
	var int cSlotID;
	var int cSuccess;
};

struct _C_EX_NEW_HENNA_POTEN_SELECT
{
	var int cSlotID;
	var int nPotenID;
};

struct _S_EX_NEW_HENNA_POTEN_SELECT
{
	var int cSlotID;
	var int nPotenID;
	var int nActiveStep;
	var int cSuccess;
};

struct _C_EX_NEW_HENNA_POTEN_ENCHANT
{
	var int cSlotID;
	var int costItemID;
};

struct _S_EX_NEW_HENNA_POTEN_ENCHANT
{
	var int cSlotID;
	var int nEnchantStep;
	var int nEnchantExp;
	var int nDailyStep;
	var int nDailyCount;
	var int nActiveStep;
	var int cSuccess;
	var int nSlotDailyStep;
	var int nSlotDailyCount;
};

struct _C_EX_NEW_HENNA_COMPOSE
{
	var int nSlotOneIndex;
	var int nSlotOneItemID;
	var int nSlotTwoItemID;
};

struct _S_EX_NEW_HENNA_COMPOSE
{
	var int nResultHennaID;
	var int nResultItemID;
	var int cSuccess;
};

struct _C_EX_REQUEST_INVITE_PARTY
{
	var int cReqType;
	var int cSayType;
};

struct _S_EX_REQUEST_INVITE_PARTY
{
	var string sName;
	var int cReqType;
	var int cSayType;
	var int cCharRankGrade;
	var int cPledgeCastleDBID;
	var int cEventEmblemID;
	var int nUserSID;
};

struct _C_EX_ITEM_USABLE_LIST
{
	var int cDummy;
};

struct _S_EX_INIT_GLOBAL_EVENT_UI
{
	var array<int> vEventList;
};

struct _C_EX_SELECT_GLOBAL_EVENT_UI
{
	var int nEventIndex;
};

struct _C_EX_L2PASS_INFO
{
	var int cPassType;
};

struct _C_EX_L2PASS_REQUEST_REWARD
{
	var int cPassType;
	var byte bPremium;
};

struct _C_EX_L2PASS_REQUEST_REWARD_ALL
{
	var int cPassType;
};

struct _C_EX_L2PASS_BUY_PREMIUM
{
	var int cPassType;
};

struct _C_EX_SAYHAS_SUPPORT_TOGGLE
{
	var byte bIsOn;
};

struct _PkL2PassInfo
{
	var int cPassType;
	var byte bIsOn;
};

struct _S_EX_L2PASS_SIMPLE_INFO
{
	var array<_PkL2PassInfo> passInfos;
	var byte bAvailableReward;
	var array<int> condIndex;
};

struct _S_EX_L2PASS_INFO
{
	var int cPassType;
	var int nLeftTime;
	var byte bIsPremium;
	var int nCurCount;
	var int nCurStep;
	var int nRewardStep;
	var int nPremiumRewardStep;
};

struct _S_EX_SAYHAS_SUPPORT_INFO
{
	var byte bIsOn;
	var int nTimeEarned;
	var int nTimeUsed;
};

struct _C_EX_REQ_VIEW_ENCHANT_RESULT
{
	var int cDummy;
};

struct _C_EX_REQ_ENCHANT_FAIL_REWARD_INFO
{
	var int nItemServerId;
};

struct _EnchantRewardItem
{
	var int nItemClassID;
	var int nCount;
};

struct _S_EX_RES_ENCHANT_ITEM_FAIL_REWARD_INFO
{
	var int nItemServerId;
	var int nEnchantChallengePointGroupId;
	var int nEnchantChallengePoint;
	var array<_EnchantRewardItem> vRewardItemList;
};

struct _EnchantProbInfo
{
	var int nItemServerId;
	var int nTotalSuccessProbPermyriad;
	var int nBaseProbPermyriad;
	var int nSupportProbPermyriad;
	var int nItemSkillProbPermyriad;
};

struct _S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST
{
	var array<_EnchantProbInfo> vProbList;
};

struct _EnchantChallengePointInfo
{
	var int nPointGroupId;
	var int nChallengePoint;
	var int nTicketPointOpt1;
	var int nTicketPointOpt2;
	var int nTicketPointOpt3;
	var int nTicketPointOpt4;
	var int nTicketPointOpt5;
	var int nTicketPointOpt6;
};

struct _S_EX_ENCHANT_CHALLENGE_POINT_INFO
{
	var array<_EnchantChallengePointInfo> vCurrentPointInfo;
};

struct _C_EX_SET_ENCHANT_CHALLENGE_POINT
{
	var int nUseType;
	var byte bUseTicket;
};

struct _S_EX_SET_ENCHANT_CHALLENGE_POINT
{
	var byte bResult;
};

struct _C_EX_RESET_ENCHANT_CHALLENGE_POINT
{
	var int cDummy;
};

struct _S_EX_RESET_ENCHANT_CHALLENGE_POINT
{
	var byte bResult;
};

struct _C_EX_REQ_START_MULTI_ENCHANT_SCROLL
{
	var int nScrollItemSid;
};

struct _C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT
{
	var int cDummy;
};

struct _C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL
{
	var int cDummy;
};

struct _C_EX_REQ_CHANGE_MULTI_ENCHANT_SCROLL
{
	var int nScrollItemSid;
};

struct _S_EX_RES_SELECT_MULTI_ENCHANT_SCROLL
{
	var int nScrollItemSid;
	var int nResult;
};

struct _C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST
{
	var array<int> vEnchantItemList;
};

struct _S_EX_RES_SET_MULTI_ENCHANT_ITEM_LIST
{
	var int nResult;
};

struct _C_EX_REQ_MULTI_ENCHANT_ITEM_LIST
{
	var byte bUseLateAnnounce;
	var array<int> vEnchantItemList;
};

struct _EnchantSuccessItem
{
	var int nItemSid;
	var int nFinalEnchanted;
};

struct _EnchantFailItem
{
	var int nItemSid;
	var int nEnchanted;
};

struct _EnchantFailRewardItem
{
	var int nItemClassID;
	var int nItemCount;
};

struct _EnchantFailChallengePointInfo
{
	var int nGroupID;
	var int nChallengePoint;
};

struct _S_EX_RES_MULTI_ENCHANT_ITEM_LIST
{
	var byte bResult;
	var array<_EnchantSuccessItem> vSuccessItemList;
	var array<_EnchantFailItem> vFailedItemList;
	var array<_EnchantFailRewardItem> vFailRewardItemList;
	var array<_EnchantFailChallengePointInfo> vFailChallengePointInfoList;
};

struct _C_EX_WORLDCASTLEWAR_SUPPORT_PLEDGE_FLAG_SET
{
	var int nCastleID;
	var int nType;
	var int nUseSupporterPledgeFlag;
};

struct _C_EX_WORLDCASTLEWAR_SUPPORT_PLEDGE_INFO_SET
{
	var int nCastleID;
	var int nType;
	var int nSupportPledgeSID;
};

struct _C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_ALL_RANKING_INFO
{
	var int nCastleID;
};

struct _WorldCastleWar_SupportPledge_RankingInfo
{
	var int nRank;
	var string sName;
	var INT64 nSiegePoint;
	var INT64 nTotalSiegePoint;
};

struct _S_EX_WORLDCASTLEWAR_HOST_SUPPORT_PLEDGE_RANKING_INFO
{
	var int cPacketIndex;
	var int nTotalCount;
	var int nCastleID;
	var array<_WorldCastleWar_SupportPledge_RankingInfo> lstSupportPledgeRankingInfo;
};

struct _WorldCastleWar_Pledge_RankingInfo
{
	var int nRank;
	var string sName;
	var INT64 nSiegePoint;
	var string sSupportPledgeName;
};

struct _S_EX_WORLDCASTLEWAR_HOST_PLEDGE_RANKING_INFO
{
	var int cPacketIndex;
	var int nTotalCount;
	var int nCastleID;
	var array<_WorldCastleWar_Pledge_RankingInfo> lstPledgeRankingInfo;
};

struct _WorldCastleWar_Personal_RankingInfo
{
	var int nRank;
	var string sName;
	var INT64 nSiegePoint;
};

struct _S_EX_WORLDCASTLEWAR_HOST_PERSONAL_RANKING_INFO
{
	var int cPacketIndex;
	var int nTotalCount;
	var int nCastleID;
	var array<_WorldCastleWar_Personal_RankingInfo> lstPersonalRankingInfo;
};

struct _C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ALL_RANKING_INFO
{
	var int nCastleID;
};

struct _S_EX_WORLDCASTLEWAR_SUPPORT_PLEDGE_RANKING_INFO
{
	var int cPacketIndex;
	var int nTotalCount;
	var int nCastleID;
	var array<_WorldCastleWar_SupportPledge_RankingInfo> lstSupportPledgeRankingInfo;
};

struct _S_EX_WORLDCASTLEWAR_PLEDGE_RANKING_INFO
{
	var int cPacketIndex;
	var int nTotalCount;
	var int nCastleID;
	var int nMyPledgeRank;
	var INT64 nMyPledgeSiegePoint;
	var array<_WorldCastleWar_Pledge_RankingInfo> lstPledgeRankingInfo;
};

struct _S_EX_WORLDCASTLEWAR_PERSONAL_RANKING_INFO
{
	var int cPacketIndex;
	var int nTotalCount;
	var int nCastleID;
	var int nMyRank;
	var INT64 nMySiegePoint;
	var array<_WorldCastleWar_Personal_RankingInfo> lstPersonalRankingInfo;
};

struct _C_EX_REQ_HOMUNCULUS_PROB_LIST
{
	var int nType;
	var int nSlotItemClassId;
};

struct _HomunculusProbData
{
	var int nIndex;
	var int nProbPerMillion;
};

struct _S_EX_HOMUNCULUS_CREATE_PROB_LIST
{
	var array<_HomunculusProbData> lstHomunculusProbList;
};

struct _S_EX_HOMUNCULUS_COUPON_PROB_LIST
{
	var int nSlotItemClassId;
	var array<_HomunculusProbData> lstHomunculusProbList;
};

struct _C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO
{
	var int nCastleID;
};

struct _WorldCastleWar_RankingInfo
{
	var int nRank;
	var string sName;
	var INT64 nSiegePoint;
};

struct _S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO
{
	var int nCastleID;
	var array<_WorldCastleWar_RankingInfo> lstPledgeRankingList;
	var array<_WorldCastleWar_RankingInfo> lstPersonalRankingList;
};

struct _C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO
{
	var int nCastleID;
};

struct _S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO
{
	var int nCastleID;
	var int nMyPledgeRank;
	var INT64 nMyPledgeSiegePoint;
	var int nMyRank;
	var INT64 nMySiegePoint;
	var array<_WorldCastleWar_RankingInfo> lstPledgeRankingList;
	var array<_WorldCastleWar_RankingInfo> lstPersonalRankingList;
};

struct _PkMissionLevelReward
{
	var int nType;
	var int nLevel;
	var int nState;
};

struct _S_EX_MISSION_LEVEL_REWARD_LIST
{
	var array<_PkMissionLevelReward> rewards;
	var int nLevel;
	var int nPointPercent;
	var int nSeasonYear;
	var int nSeasonMonth;
	var int nTotalRewardsAvailable;
	var int nExtraRewardsAvailable;
	var int nRemainSeasonTime;
};

struct _C_EX_MISSION_LEVEL_RECEIVE_REWARD
{
	var int nLevel;
	var int nRewardType;
};

struct _C_EX_BALROGWAR_TELEPORT
{
	var int cDummy;
};

struct _C_EX_BALROGWAR_SHOW_UI
{
	var int cDummy;
};

struct _S_EX_BALROGWAR_SHOW_UI
{
	var int nRank;
	var int nPersonalPoint;
	var INT64 nTotalPoint;
	var int nRewardState;
	var int nRewardItemID;
	var INT64 nRewardAmount;
};

struct _C_EX_BALROGWAR_SHOW_RANKING
{
	var int cDummy;
};

struct _PkBalrogWarRanking
{
	var int nRank;
	var string sName;
	var int nPoint;
};

struct _S_EX_BALROGWAR_SHOW_RANKING
{
	var array<_PkBalrogWarRanking> rankingList;
};

struct _C_EX_BALROGWAR_GET_REWARD
{
	var int cDummy;
};

struct _S_EX_BALROGWAR_GET_REWARD
{
	var byte bSuccess;
};

struct _S_EX_BALROGWAR_HUD
{
	var int nState;
	var int nProgressStep;
	var int nLeftTime;
};

struct _S_EX_BALROGWAR_BOSSINFO
{
	var int nMidBossClassID[5];
	var int nMidBossState[5];
	var int nFinalBossClassID;
	var int nFinalBossState;
};

struct _PkUserRestartLocker
{
	var int nRestartPoint;
	var int nClassID;
	var byte bLocked;
};

struct _S_EX_USER_RESTART_LOCKER_LIST
{
	var byte bExpDown;
	var array<_PkUserRestartLocker> _lockers;
};

struct _C_EX_USER_RESTART_LOCKER_UPDATE
{
	var int nRestartPoint;
	var int nClassID;
	var byte bLocked;
};

struct _S_EX_USER_RESTART_LOCKER_UPDATE
{
	var byte bSuccess;
};

struct _C_EX_WORLD_EXCHANGE_ITEM_LIST
{
	var int nCategory;
	var int cSortType;
	var int nPage;
	var array<int> vItemIDList;
	var int cType;
};

struct _WorldExchangeItemData
{
	var INT64 nWEIndex;
	var INT64 nPrice;
	var int nExpiredTime;
	var int nItemClassID;
	var INT64 nAmount;
	var int nEnchant;
	var int nVariationOpt1;
	var int nVariationOpt2;
	var int nIntensiveItemClassID;
	var int nBaseAttributeAttackType;
	var int nBaseAttributeAttackValue;
	var int nBaseAttributeDefendValue[6];
	var int nShapeShiftingClassId;
	var int nEsoulOption[3];
	var int nBlessOption;
	var int nCurrencyId;
};

struct _S_EX_WORLD_EXCHANGE_ITEM_LIST
{
	var int nCategory;
	var int cSortType;
	var int nPage;
	var array<_WorldExchangeItemData> vItemDataList;
};

struct _C_EX_WORLD_EXCHANGE_REGI_ITEM
{
	var INT64 nPrice;
	var int nItemSid;
	var INT64 nAmount;
	var int nCurrencyId;
};

struct _S_EX_WORLD_EXCHANGE_REGI_ITEM
{
	var int nItemClassID;
	var INT64 nAmount;
	var int cSuccess;
};

struct _C_EX_WORLD_EXCHANGE_BUY_ITEM
{
	var INT64 nWEIndex;
};

struct _S_EX_WORLD_EXCHANGE_BUY_ITEM
{
	var int nItemClassID;
	var INT64 nAmount;
	var int cSuccess;
};

struct _C_EX_WORLD_EXCHANGE_SETTLE_LIST
{
	var int cDummy;
};

struct _S_EX_WORLD_EXCHANGE_SETTLE_LIST
{
	var array<_WorldExchangeItemData> vRegiItemDataList;
	var array<_WorldExchangeItemData> vRecvItemDataList;
	var array<_WorldExchangeItemData> vTimeOutItemDataList;
};

struct _C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT
{
	var INT64 nWEIndex;
};

struct _S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT
{
	var int nItemClassID;
	var INT64 nAmount;
	var int cSuccess;
};

struct _S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM
{
	var int nItemClassID;
	var INT64 nAmount;
};

struct _C_EX_READY_ITEM_AUTO_PEEL
{
	var int nItemSid;
};

struct _S_EX_READY_ITEM_AUTO_PEEL
{
	var byte bResult;
	var int nItemSid;
};

struct _C_EX_STOP_ITEM_AUTO_PEEL
{
	var int cDummy;
};

struct _S_EX_STOP_ITEM_AUTO_PEEL
{
	var byte bResult;
};

struct _C_EX_REQUEST_ITEM_AUTO_PEEL
{
	var int nItemSid;
	var INT64 nTotalPeelCount;
	var INT64 nRemainPeelCount;
};

struct _AutoPeelResultItem
{
	var int nItemClassID;
	var INT64 nAmount;
	var int AnnounceLevel;
};

struct _S_EX_RESULT_ITEM_AUTO_PEEL
{
	var byte bResult;
	var INT64 nTotalPeelCount;
	var INT64 nRemainPeelCount;
	var array<_AutoPeelResultItem> vResultItemList;
};

struct _S_EX_TIME_RESTRICT_FIELD_DIE_LIMT_TIME
{
	var int nDieLimitTime;
};

struct _C_EX_VARIATION_OPEN_UI
{
	var int cDummy;
};

struct _C_EX_VARIATION_CLOSE_UI
{
	var int cDummy;
};

struct _C_EX_APPLY_VARIATION_OPTION
{
	var int nVariationItemSID;
	var int nItemOption1;
	var int nItemOption2;
};

struct _S_EX_APPLY_VARIATION_OPTION
{
	var byte bResult;
	var int nVariationItemSID;
	var int nItemOption1;
	var int nItemOption2;
};

struct _C_EX_REQUEST_AUDIO_LOG_SAVE
{
	var string sZoneName;
	var byte bAudioMuteOn;
	var byte bAudioFocusOn;
	var int cSoundVolume;
	var int cMusicVolume;
	var int cNotifySoundVolume;
	var int cEffectVolume;
	var int cAmbientVolume;
	var int cSystemVoiceVolume;
	var int cNpcVoiceVolume;
	var byte bTutorialVoiceBox;
	var int cDeviceVolume;
};

struct _S_EX_REQUEST_AUDIO_LOG_SAVE
{
	var int cDummy;
};

struct _C_EX_WRANKING_FESTIVAL_INFO
{
	var int dummy;
};

struct _WRFRankingRewardInfo
{
	var int nStartRank;
	var int nEndRank;
	var int nRewardItemClassId;
	var INT64 nRewardItemAmount;
};

struct _WRFBonusInfo
{
	var int nPoint;
	var int nRewardItemClassId;
	var INT64 nRewardItemAmount;
};

struct _WRFBuyItemInfo
{
	var int nBuyId;
	var int nType;
	var byte bSale;
	var int nBuyItemClassId;
	var INT64 nBuyItemAmount;
	var int nCostItemClassID;
	var INT64 nCostItemAmount;
};

struct _WRFBuffInfo
{
	var int nRankId;
	var int nBuffSkillId;
	var int nBuffSkillLv;
	var int nMinBuffLv;
	var int nMaxBuffLv;
};

struct _S_EX_WRANKING_FESTIVAL_INFO
{
	var byte bSuccess;
	var int nCostType;
	var array<_WRFRankingRewardInfo> rankingRewardInfos;
	var array<_WRFBonusInfo> bonusInfos;
	var array<_WRFBuyItemInfo> buyItemInfos;
	var array<_WRFBuffInfo> buffInfos;
};

struct _WRFRankingInfo
{
	var int nRank;
	var int nWorldID;
	var string charName;
	var int nBuyCount;
	var int nAnonymity;
};

struct _S_EX_WRANKING_FESTIVAL_SIDEBAR_INFO
{
	var byte bShowEvent;
	var byte bOnEvent;
	var INT64 nEndSeconds;
	var INT64 nFinishSeconds;
	var array<_WRFRankingInfo> rankingInfos;
};

struct _C_EX_WRANKING_FESTIVAL_OPEN
{
	var int dummy;
};

struct _C_EX_WRANKING_FESTIVAL_BUY
{
	var int nBuyId;
	var int nBuyCount;
};

struct _S_EX_WRANKING_FESTIVAL_BUY
{
	var byte bSuccess;
};

struct _C_EX_WRANKING_FESTIVAL_BONUS
{
	var array<int> nPoints;
};

struct _S_EX_WRANKING_FESTIVAL_BONUS
{
	var byte bSuccess;
	var array<int> nPoints;
};

struct _C_EX_WRANKING_FESTIVAL_RANKING
{
	var int nRankingType;
};

struct _S_EX_WRANKING_FESTIVAL_RANKING
{
	var byte bSuccess;
	var int nRankingType;
	var int nMyRanking;
	var array<_WRFRankingInfo> rankingInfos;
};

struct _S_EX_WRANKING_FESTIVAL_MYINFO
{
	var int nMyRanking;
	var int nTotalBuyCount;
	var byte bReceiveReward;
	var int nCostId;
	var int nCostCount;
};

struct _C_EX_WRANKING_FESTIVAL_MY_RECEIVED_BONUS
{
	var int dummy;
};

struct _S_EX_WRANKING_FESTIVAL_MY_RECEIVED_BONUS
{
	var array<int> receivedPoints;
};

struct _C_EX_WRANKING_FESTIVAL_REWARD
{
	var int dummy;
};

struct _S_EX_WRANKING_FESTIVAL_REWARD
{
	var byte bSuccess;
};

struct _ToolTipParamInfo
{
	var int nID;
	var int nLevel;
	var array<string> nameParams;
	var array<string> descParams;
};

struct _S_EX_TOOLTIP_PARAM
{
	var int nToolTipType;
	var array<_ToolTipParamInfo> ToolTipParamList;
};

struct _SReceivedPost
{
	var int nPostID;
	var string wstrTitle;
	var string wstrSenderName;
	var int nSenderType;
	var int nMessageNo;
	var int nNextJobTime;
	var byte bIsTrade;
	var byte bIsNotOpened;
	var byte bIsReturnable;
	var byte bIsWithItem;
	var byte bIsReturned;
	var int nRecordedId;
};

struct _S_EX_RECEIVED_POST_LIST
{
	var int cMaxPage;
	var int cCurrentPage;
	var int nNow;
	var int nPostFeeBase;
	var int nPostFeePerItemSlot;
	var array<_SReceivedPost> postList;
};

struct _S_EX_TIME_RESTRICT_FIELD_ENTER_INFO
{
	var array<int> vEnterGroupFieldIDList;
	var byte bCanUseEntranceTicket;
	var int nEntranceCount;
};

struct _S_EX_WORLD_EXCHANGE_SETTLE_ALARM
{
	var int nCount;
};

struct _S_EX_SHOW_VARIATION_MAKE_WINDOW
{
	var byte bIsVariationEventOn;
	var int nGemStoneCountPercent;
	var int nFeeAdenaPercent;
};

struct _C_EX_TRY_TO_MAKE_VARIATION
{
	var int nItemServerId;
	var int nIntensiveItemServerID;
	var byte bIsVariationEventOn;
};

struct _S_EX_HERO_BOOK_INFO
{
	var int nPoint;
	var int nLevel;
};

struct _C_EX_HERO_BOOK_CHARGE
{
	var array<_ItemServerInfo> Items;
};

struct _S_EX_HERO_BOOK_CHARGE
{
	var byte bSuccess;
};

struct _S_EX_HERO_BOOK_ENCHANT
{
	var int cResult;
};

struct _S_EX_TELEPORT_UI
{
	var int nPriceRatio;
};

struct _S_EX_GOODS_GIFT_CHANGED_NOTI
{
	var int cDummy;
};

struct _C_EX_GOODS_GIFT_LIST_INFO
{
	var int cDummy;
};

struct _SGiftItem
{
	var int nClassID;
	var int nCount;
};

struct _SGiftInfo
{
	var int nPurchaseId;
	var int nCount;
	var int nIconId;
	var string wstrGiftName;
	var string wstrSenderName;
	var string wstrGiftDesc;
	var int nRemainTimeSec;
	var array<_SGiftItem> ItemList;
};

struct _S_EX_GOODS_GIFT_LIST_INFO
{
	var int cResult;
	var int nTotalPage;
	var int nCurrentPage;
	var array<_SGiftInfo> giftList;
};

struct _C_EX_GOODS_GIFT_ACCEPT
{
	var int nPurchaseId;
};

struct _S_EX_GOODS_GIFT_ACCEPT_RESULT
{
	var byte bSuccess;
	var int nPurchaseId;
};

struct _C_EX_GOODS_GIFT_REFUSE
{
	var int nPurchaseId;
};

struct _S_EX_GOODS_GIFT_REFUSE_RESULT
{
	var byte bSuccess;
	var int nPurchaseId;
};

struct _S_EX_NONPVPSERVER_NOTIFY_ACTIVATEFLAG
{
	var int nPacketType;
	var int nIsActivate;
};

struct _C_EX_WORLD_EXCHANGE_AVERAGE_PRICE
{
	var int nItemID;
};

struct _S_EX_WORLD_EXCHANGE_AVERAGE_PRICE
{
	var int nItemID;
	var INT64 nAveragePrice;
};

struct _S_EX_PRISON_USER_ENTER
{
	var int cDummy;
};

struct _S_EX_PRISON_USER_EXIT
{
	var int cDummy;
};

struct _C_EX_PRISON_USER_INFO
{
	var int cDummy;
};

struct _S_EX_PRISON_USER_INFO
{
	var int cPrisonType;
	var int nItemAmount;
	var int nRemainTime;
};

struct _C_EX_PRISON_USER_DONATION
{
	var int cDummy;
};

struct _S_EX_PRISON_USER_DONATION
{
	var byte bSuccess;
};

struct _C_EX_WORLD_EXCHANGE_TOTAL_LIST
{
	var array<int> vItemIDList;
};

struct _WorldExchangeTotalListData
{
	var int nItemClassID;
	var INT64 nMinPricePerPiece;
	var int nPriceItemId;
	var INT64 nPrice;
	var INT64 nAmount;
};

struct _S_EX_WORLD_EXCHANGE_TOTAL_LIST
{
	var array<_WorldExchangeTotalListData> vItemIDList;
};

struct _S_EX_ITEM_RESTORE_OPEN
{
	var int nItemClassID;
};

struct _C_EX_TRADE_LIMIT_INFO
{
	var int dummy;
};

struct _S_EX_FIELD_DIE_LIMT_TIME
{
	var int nDieLimitTime;
};

struct _S_EX_ELEMENTAL_SPIRIT_ATTACK_TYPE
{
	var int cBitset;
};

struct _C_EX_SET_PLEDGE_CREST_PRESET
{
	var int nType;
	var int nPresetCrestDBID;
};

struct _C_EX_GET_PLEDGE_CREST_PRESET
{
	var int nPledgeSId;
	var int nPresetCrestDBID;
};

struct _S_EX_GET_PLEDGE_CREST_PRESET
{
	var int nResult;
	var int nPledgeSId;
	var int nPresetCrestDBID;
};

struct _DualInventoryDBIDData
{
	var array<int> lSlotDBID;
	var array<int> lHennaPotenID;
};

struct _S_EX_DUAL_INVENTORY_INFO
{
	var int cActiveSlot;
	var byte bSuccess;
	var byte bStableSwapping;
	var _DualInventoryDBIDData stDBData[2];
};

struct _C_EX_DUAL_INVENTORY_SWAP
{
	var int cSwapSlot;
};

struct _C_EX_SP_EXTRACT_INFO
{
	var int nItemID;
};

struct _S_EX_SP_EXTRACT_INFO
{
	var int nItemID;
	var int nExtractCount;
	var INT64 nNeedSP;
	var int nRate;
	var int nCriticalRate;
	var _ItemInfo failedItem;
	var _ItemInfo commissionItem;
	var _ItemInfo criticalItem;
	var int nRemainCount;
	var int nMaxDailyCount;
};

struct _C_EX_SP_EXTRACT_ITEM
{
	var int nItemID;
};

struct _S_EX_SP_EXTRACT_ITEM
{
	var int cResult;
	var byte bCritical;
	var int nItemID;
};

struct _PkAbilitySkill
{
	var int nID;
	var int nLevel;
};

struct _S_EX_ACQUIRE_AP_SKILL_LIST
{
	var byte bSuccess;
	var INT64 nResetSP;
	var int nAP;
	var int nAcquiredAbilityCount;
	var array<_PkAbilitySkill> abilitySkills;
};

struct _PkAbilitySkillsPerType
{
	var array<_PkAbilitySkill> abilitySkills;
};

struct _C_EX_ACQUIRE_POTENTIAL_SKILL
{
	var int nAP;
	var _PkAbilitySkillsPerType abilitySkillsPerType[3];
};

struct _C_EX_QUEST_TELEPORT
{
	var int nID;
};

struct _C_EX_QUEST_ACCEPT
{
	var int nID;
	var byte bAccept;
};

struct _C_EX_QUEST_CANCEL
{
	var int nID;
};

struct _C_EX_QUEST_COMPLETE
{
	var int nID;
};

struct _S_EX_QUEST_DIALOG
{
	var int nID;
	var int cDialogType;
};

struct _S_EX_QUEST_NOTIFICATION
{
	var int nID;
	var int nCount;
	var int cNotifType;
};

struct _PkQuestNotif
{
	var int nID;
	var int nCount;
};

struct _S_EX_QUEST_NOTIFICATION_ALL
{
	var array<_PkQuestNotif> questNotifs;
};

struct _PkQuestInfo
{
	var int nID;
	var int nCount;
	var int cState;
};

struct _S_EX_QUEST_UI
{
	var array<_PkQuestInfo> questInfos;
	var int nProceedingQuestCount;
};

struct _S_EX_QUEST_ACCEPTABLE_LIST
{
	var array<int> questIDs;
};

struct _C_EX_SKILL_ENCHANT_INFO
{
	var int nSkillID;
	var int nLevel;
	var int nSubLevel;
};

struct _S_EX_SKILL_ENCHANT_INFO
{
	var int nSkillID;
	var int nSubLevel;
	var int nEXP;
	var int nMaxExp;
	var int nProbPerHundred;
	var _ItemInfo commissionItem;
};

struct _C_EX_SKILL_ENCHANT_CHARGE
{
	var int nSkillID;
	var int nLevel;
	var int nSubLevel;
	var array<_ItemServerInfo> Items;
};

struct _S_EX_SKILL_ENCHANT_CHARGE
{
	var int nSkillID;
	var int cReault;
};

struct _C_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER
{
	var int nEnterFieldID;
};

struct _S_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER
{
	var int nResult;
	var int nEnteredFieldID;
};

struct _C_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE
{
	var int nLeaveFieldID;
	var int nNextEnterFieldID;
};

struct _S_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE
{
	var int nResult;
	var int nLeaveFieldID;
	var int nNextEnterFieldID;
};

struct _C_EX_DETHRONE_SHOP_OPEN_UI
{
	var int cDummy;
};

struct _C_EX_DETHRONE_SHOP_BUY
{
	var int nID;
	var INT64 nCount;
};

struct _S_EX_DETHRONE_SHOP_BUY
{
	var byte bSuccess;
};

struct _S_EX_DETHRONE_POINT_INFO
{
	var INT64 nPersonalPoint;
};

struct _S_EX_ACQUIRE_SKILL_RESULT
{
	var int nSkillID;
	var int nLevel;
	var int cResult;
	var int nSysMsg;
};

struct _C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI
{
	var int cDummy;
};

struct _EAOF_Element
{
	var int nLevel;
	var int nEXP;
	var int nInitCount;
	var int nExpUpCount;
};

struct _S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI
{
	var int nSetEffectLevel;
	var _EAOF_Element elements[5];
};

struct _C_EX_ENHANCED_ABILITY_OF_FIRE_INIT
{
	var int cType;
};

struct _S_EX_ENHANCED_ABILITY_OF_FIRE_INIT
{
	var int cType;
	var int cResult;
	var int nInitCount;
};

struct _C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP
{
	var int cType;
};

struct _S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP
{
	var int cType;
	var int cResult;
	var int nEXP;
	var int nExpUpCount;
	var array<_ItemInfo> rewards;
};

struct _C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP
{
	var int cType;
};

struct _S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP
{
	var int cType;
	var int cResult;
	var int nLevel;
};

struct _HolyFire
{
	var int cState;
	var int nElapsedTime;
	var int nLifespan;
	var int nRewardPersonalPoint;
	var int nRewardServerPoint;
	var int nRewardPrimalFirePoint;
	var array<_ItemInfo> rewards;
	var int cRewardState;
};

struct _S_EX_HOLY_FIRE_OPEN_UI
{
	var array<_HolyFire> infos;
};

struct _S_EX_HOLY_FIRE_NOTIFY
{
	var int cState;
};

struct _S_EX_PICK_UP_DIST_MODIFY
{
	var int IsPet;
	var int modifiedDistance;
};

struct _S_EX_UNIQUE_GACHA_SIDEBAR_INFO
{
	var int cOnOffFlag;
};

struct _C_EX_UNIQUE_GACHA_OPEN
{
	var int cFullInfo;
	var int cOpenMode;
};

struct _SUniqueGachaBaseItemInfo
{
	var int cRankType;
	var int nItemType;
	var INT64 nAmount;
};

struct _SUniqueGachaItemInfo
{
	var _SUniqueGachaBaseItemInfo sBaseItemInfo;
	var INT64 dProb;
};

struct _SUniqueGachaGameTypeInfo
{
	var int nGameCount;
	var INT64 nCostItemAmount;
};

struct _S_EX_UNIQUE_GACHA_OPEN
{
	var int cOpenMode;
	var int cResult;
	var int nMyCostItemAmount;
	var int nMyConfirmCount;
	var int nRemainSecTime;
	var int cFullInfo;
	var int cShowProb;
	var array<_SUniqueGachaItemInfo> showItems;
	var array<_SUniqueGachaItemInfo> RewardItems;
	var int cCostType;
	var int nCostItemType;
	var array<_SUniqueGachaGameTypeInfo> costAmountInfos;
};

struct _C_EX_UNIQUE_GACHA_GAME
{
	var int nGameCount;
};

struct _S_EX_UNIQUE_GACHA_GAME
{
	var int cResult;
	var int nMyCostItemAmount;
	var int nMyConfirmCount;
	var int cRankType;
	var array<_SUniqueGachaBaseItemInfo> ResultItems;
};

struct _C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST
{
	var int cInvenType;
};

struct _SUniqueGachaInvenItemInfo
{
	var int nItemType;
	var INT64 nAmount;
};

struct _S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST
{
	var int cPage;
	var int cMaxPage;
	var array<_SUniqueGachaInvenItemInfo> myItems;
};

struct _C_EX_UNIQUE_GACHA_INVEN_GET_ITEM
{
	var array<_SUniqueGachaInvenItemInfo> getItems;
};

struct _S_EX_UNIQUE_GACHA_INVEN_GET_ITEM
{
	var int cResult;
};

struct _S_EX_UNIQUE_GACHA_INVEN_ADD_ITEM
{
	var array<_SUniqueGachaInvenItemInfo> addItems;
};

struct _C_EX_UNIQUE_GACHA_HISTORY
{
	var int cInvenType;
};

struct _SUniqueGachaHistoryInfo
{
	var _SUniqueGachaBaseItemInfo itemBaseInfo;
	var int nGetTimeSec;
};

struct _S_EX_UNIQUE_GACHA_HISTORY
{
	var array<_SUniqueGachaHistoryInfo> historyItems;
};

struct _S_EX_ITEM_SCORE
{
	var int nScore;
};

static function bool Encode_C_EX_DECO_NPC_SET(out array<byte> stream, _C_EX_DECO_NPC_SET packet)
{
	if(!EncodeInt(stream, packet.nAgitCID))
	{
		return false;
	}
	if(!EncodeChar(stream, packet.cSlot))
	{
		return false;
	}
	if(!EncodeInt(stream, packet.nDecoCID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_PLEDGE_CREST(out _S_PLEDGE_CREST packet)
{
	local int i, nSize;

	if(!DecodeInt(packet.pledgeSID))
	{
		return false;
	}
	if(!DecodeInt(packet.pledgeCrestDBID))
	{
		return false;
	}
	if(!DecodeInt(packet.bitmapSize))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.Bitmap.Length = nSize;

	for(i = 0; i < packet.Bitmap.Length; i++)
	{
		if(!DecodeByte(packet.Bitmap[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_ALLIANCE_CREST(out _S_ALLIANCE_CREST packet)
{
	local int i, nSize;

	if(!DecodeInt(packet.allianceCrestDBID))
	{
		return false;
	}
	if(!DecodeInt(packet.requestPledgeSID))
	{
		return false;
	}
	if(!DecodeInt(packet.bitmapSize))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.Bitmap.Length = nSize;

	for(i = 0; i < packet.Bitmap.Length; i++)
	{
		if(!DecodeByte(packet.Bitmap[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_DECO_NPC_SET(out _S_EX_DECO_NPC_SET packet)
{
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	if(!DecodeInt(packet.nAgitCID))
	{
		return false;
	}
	if(!DecodeChar(packet.cSlot))
	{
		return false;
	}
	if(!DecodeInt(packet.nDecoCID))
	{
		return false;
	}
	if(!DecodeInt(packet.nExpire))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DECO_NPC_INFO(out array<byte> stream, _C_EX_DECO_NPC_INFO packet)
{
	if(!EncodeInt(stream, packet.nAgitCID))
	{
		return false;
	}
	return true;
}

static function bool Decode_DecoNpcInfo(out _DecoNpcInfo packet)
{
	if(!DecodeChar(packet.cSlot))
	{
		return false;
	}
	if(!DecodeInt(packet.nDecoCID))
	{
		return false;
	}
	if(!DecodeInt(packet.nExpire))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DECO_NPC_INFO(out _S_EX_DECO_NPC_INFO packet)
{
	local int i, nSize;

	if(!DecodeInt(packet.nAgitCID))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vDecoNpcs.Length = nSize;

	for(i = 0; i < packet.vDecoNpcs.Length; i++)
	{
		if(!Decode_DecoNpcInfo(packet.vDecoNpcs[i]))
		{
			return false;
		}
	}
	if(!DecodeChar(packet.nResidenceGrade))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vResidenceDomains.Length = nSize;

	for(i = 0; i < packet.vResidenceDomains.Length; i++)
	{
		if(!DecodeChar(packet.vResidenceDomains[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_FACTION_INFO(out array<byte> stream, _C_EX_FACTION_INFO packet)
{
	if(!EncodeInt(stream, packet.nUserID))
	{
		return false;
	}
	if(!EncodeChar(stream, packet.nRequestType))
	{
		return false;
	}
	return true;
}

static function bool Decode_FactionInfo(out _FactionInfo packet)
{
	if(!DecodeChar(packet.nFactionType))
	{
		return false;
	}
	if(!DecodeChar(packet.nFactionLevel))
	{
		return false;
	}
	if(!DecodeChar(packet.cIsLevelLimited))
	{
		return false;
	}
	if(!DecodeFloat(packet.fFactionRate))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_FACTION_INFO(out _S_EX_FACTION_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nUserID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.nRequestType))
	{
		return false;
	}
	// End:0x40
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lFactionInfoList.Length = nSize;

	for(i = 0; i < packet.lFactionInfoList.Length; i++)
	{
		// End:0x8A
		if(!Decode_FactionInfo(packet.lFactionInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_BALTHUS_EVENT(out _S_EX_BALTHUS_EVENT packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCurrentState))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nProgress))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCurrentRewardItem))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRewardTokenCount))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nCurrentTokenCount))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nParticipated))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeBool(packet.bRunning))
	{
		return false;
	}
	// End:0xB8
	if(!DecodeInt(packet.nTime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_FIELD_EVENT_STEP(out _S_EX_FIELD_EVENT_STEP packet)
{
	// End:0x17
	if(!DecodeInt(packet.nStep))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nRemainSec))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nGoalPoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_FIELD_EVENT_POINT(out _S_EX_FIELD_EVENT_POINT packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_FIELD_EVENT_EFFECT(out _S_EX_FIELD_EVENT_EFFECT packet)
{
	if(!DecodeInt(packet.nType))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_RAID_BOSS_SPAWN_INFO(out array<byte> stream, _C_EX_RAID_BOSS_SPAWN_INFO packet)
{
	local int i;

	if(!EncodeInt(stream, packet.vRaidNpcIds.Length))
	{
		return false;
	}

	for(i = 0; i < packet.vRaidNpcIds.Length; i++)
	{
		if(!EncodeInt(stream, packet.vRaidNpcIds[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_RaidBossSpawnInfo(out _RaidBossSpawnInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nNpcID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nStatus))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nDeadDateTime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RAID_BOSS_SPAWN_INFO(out _S_EX_RAID_BOSS_SPAWN_INFO packet)
{
	local int i, nSize;

	if(!DecodeInt(packet.nBossRespawnFactor))
	{
		return false;
	}

	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vRaidSpawnNpcInfos.Length = nSize;

	for(i = 0; i < packet.vRaidSpawnNpcInfos.Length; i++)
	{
		// End:0x73
		if(!Decode_RaidBossSpawnInfo(packet.vRaidSpawnNpcInfos[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_RAID_SERVER_INFO(out _S_EX_RAID_SERVER_INFO packet)
{
	if(!DecodeChar(packet.cDimensionRaid))
	{
		return false;
	}
	if(!DecodeChar(packet.cDimensionCastleSiege))
	{
		return false;
	}
	return true;
}

static function bool Decode_AgitSiegeInfo(out _AgitSiegeInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nAgitId))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nSiegeDate))
	{
		return false;
	}
	// End:0x46
	if(!DecodeWString(packet.wstrOwnerPledgeName, true))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeWString(packet.wstrOwnerPledgeMasterName, true))
	{
		return false;
	}
	// End:0x75
	if(!DecodeChar(packet.cAgitType))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeChar(packet.cSiegeState))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SHOW_AGIT_SIEGE_INFO(out _S_EX_SHOW_AGIT_SIEGE_INFO packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vAgitInfos.Length = nSize;

	for (i = 0; i < packet.vAgitInfos.Length; i++)
	{
		// End:0x5C
		if(!Decode_AgitSiegeInfo(packet.vAgitInfos[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_ITEM_AUCTION_STATUS(out _S_EX_ITEM_AUCTION_STATUS packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPosX))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPosY))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nPosZ))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nInzoneId))
	{
		return false;
	}
	// End:0x73
	if(!DecodeChar(packet.cAuctionStatus))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ITEM_AUCTION_UPDATED_BIDDING_INFO(out _S_EX_ITEM_AUCTION_UPDATED_BIDDING_INFO packet)
{
	// End:0x17
	if(!DecodeInt64(packet.nCurrentPrice))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PRIVATE_STORE_BUYING_RESULT(out _S_EX_PRIVATE_STORE_BUYING_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemSid))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	// End:0x47
	if(!DecodeWChar_t(packet.charName, 24))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PRIVATE_STORE_SELLING_RESULT(out _S_EX_PRIVATE_STORE_SELLING_RESULT packet)
{
	if(!DecodeInt(packet.nItemSid))
	{
		return false;
	}
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	if(!DecodeWChar_t(packet.charName, 24))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MATCHGROUP_ASK(out array<byte> stream, _C_EX_MATCHGROUP_ASK packet)
{
	if(!EncodeWString(stream, packet.TargetUserName, true))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MATCHGROUP_ANSWER(out array<byte> stream, _C_EX_MATCHGROUP_ANSWER packet)
{
	if(!EncodeChar(stream, packet.answer))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MATCHGROUP_OUST(out array<byte> stream, _C_EX_MATCHGROUP_OUST packet)
{
	if(!EncodeWString(stream, packet.TargetUserName, true))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MATCHGROUP_CHANGE_MASTER(out array<byte> stream, _C_EX_MATCHGROUP_CHANGE_MASTER packet)
{
	if(!EncodeWString(stream, packet.TargetUserName, true))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_UPGRADE_SYSTEM_REQUEST(out array<byte> stream, _C_EX_UPGRADE_SYSTEM_REQUEST packet)
{
	if(!EncodeInt(stream, packet.nItemSid))
	{
		return false;
	}
	if(!EncodeInt(stream, packet.nUpgradeSystemID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_UPGRADE_SYSTEM_NORMAL_REQUEST(out array<byte> stream, _C_EX_UPGRADE_SYSTEM_NORMAL_REQUEST packet)
{
	if(!EncodeInt(stream, packet.nItemSid))
	{
		return false;
	}
	if(!EncodeInt(stream, packet.nType))
	{
		return false;
	}
	if(!EncodeInt(stream, packet.nUpgradeSystemID))
	{
		return false;
	}
	return true;
}

static function bool Decode_MatchGroupMemberInfo(out _MatchGroupMemberInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.memberSid))
	{
		return false;
	}
	// End:0x30
	if(!DecodeWChar_t(packet.charName, 24))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MATCHGROUP(out _S_EX_MATCHGROUP packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.matchGroupSid))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.masterSid))
	{
		return false;
	}
	// End:0x40
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.members.Length = nSize;

	for(i = 0; i < packet.members.Length; i++)
	{
		// End:0x8A
		if(!Decode_MatchGroupMemberInfo(packet.members[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_MATCHGROUP_ASK(out _S_EX_MATCHGROUP_ASK packet)
{
	// End:0x18
	if(!DecodeWString(packet.requesterUserName, true))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ARENA_SHOW_ENEMY_PARTY_LOCATION(out _S_EX_ARENA_SHOW_ENEMY_PARTY_LOCATION packet)
{
	// End:0x17
	if(!DecodeInt(packet.Duration))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SHOW_UPGRADE_SYSTEM(out _S_EX_SHOW_UPGRADE_SYSTEM packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeShort(packet.nFlag))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.nCommissionRatio))
	{
		return false;
	}
	// End:0x40
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vMaterialItemId.Length = nSize;

	for (i = 0; i < packet.vMaterialItemId.Length; i++)
	{
		// End:0x8A
		if(!DecodeInt(packet.vMaterialItemId[i]))
		{
			return false;
		}
	}
	// End:0xA6
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vMaterialRatio.Length = nSize;

	for (i = 0; i < packet.vMaterialRatio.Length; i++)
	{
		// End:0xF0
		if(!DecodeShort(packet.vMaterialRatio[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_UPGRADE_SYSTEM_RESULT(out _S_EX_UPGRADE_SYSTEM_RESULT packet)
{
	// End:0x17
	if(!DecodeShort(packet.nResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SHOW_UPGRADE_SYSTEM_NORMAL(out _S_EX_SHOW_UPGRADE_SYSTEM_NORMAL packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeShort(packet.nFlag))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.nType))
	{
		return false;
	}
	// End:0x45
	if(!DecodeShort(packet.nCommissionRatio))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vMaterialItemId.Length = nSize;

	for (i = 0; i < packet.vMaterialItemId.Length; i++)
	{
		if(!DecodeInt(packet.vMaterialItemId[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vMaterialRatio.Length = nSize;

	for(i = 0; i < packet.vMaterialRatio.Length; i++)
	{
		// End:0x107
		if(!DecodeShort(packet.vMaterialRatio[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_UpgradeSystemNormalResultItem(out _UpgradeSystemNormalResultItem packet)
{
	// End:0x17
	if(!DecodeInt(packet.itemServerID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.ItemClassID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.itemEnchant))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.ItemCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_UPGRADE_SYSTEM_NORMAL_RESULT(out _S_EX_UPGRADE_SYSTEM_NORMAL_RESULT packet)
{
	local int i, nSize;

	if(!DecodeShort(packet.nResult))
	{
		return false;
	}
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	if(!DecodeChar(packet.nIsUpgradeSuccess))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.resultItemList.Length = nSize;

	for(i = 0; i < packet.resultItemList.Length; i++)
	{
		if(!Decode_UpgradeSystemNormalResultItem(packet.resultItemList[i]))
		{
			return false;
		}
	}
	if(!DecodeChar(packet.nIsBonus))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.bonusItemList.Length = nSize;

	for (i = 0; i < packet.bonusItemList.Length; i++)
	{
		if(!Decode_UpgradeSystemNormalResultItem(packet.bonusItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_ItemInfo(out _ItemInfo packet)
{
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_ArenaResultStat(out _ArenaResultStat packet)
{
	// End:0x19
	if(!DecodeWChar_t(packet.charName, 24))
	{
		return false;
	}
	// End:0x30
	if(!DecodeInt(packet.killCount))
	{
		return false;
	}
	// End:0x47
	if(!DecodeInt(packet.deathCount))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeInt(packet.maxMultiKillCount))
	{
		return false;
	}
	// End:0x75
	if(!DecodeInt(packet.npckillCount))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeInt(packet.adenaEarned))
	{
		return false;
	}
	// End:0xA3
	if(!DecodeInt(packet.damageToUser))
	{
		return false;
	}
	// End:0xBA
	if(!DecodeInt(packet.pvpDamageTaken))
	{
		return false;
	}
	// End:0xD1
	if(!DecodeInt(packet.damageToNpc))
	{
		return false;
	}
	// End:0xE8
	if(!DecodeInt(packet.pveDamageTaken))
	{
		return false;
	}
	// End:0xFF
	if(!DecodeInt(packet.healing))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_BATTLE_RESULT_ARENA(out _S_EX_BATTLE_RESULT_ARENA packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.Result))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.oldRatingPoint))
	{
		return false;
	}
	// End:0x45
	if(!DecodeShort(packet.newRatingPoint))
	{
		return false;
	}
	// End:0x57
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rewardList.Length = nSize;

	for (i = 0; i < packet.rewardList.Length; i++)
	{
		if(!Decode_ItemInfo(packet.rewardList[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.statList.Length = nSize;

	for (i = 0; i < packet.statList.Length; i++)
	{
		if(!Decode_ArenaResultStat(packet.statList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_RankInfo(out _RankInfo packet)
{
	// End:0x19
	if(!DecodeWChar_t(packet.charName, 24))
	{
		return false;
	}
	// End:0x30
	if(!DecodeShort(packet.ratingPoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ARENA_RANK_ALL(out _S_EX_ARENA_RANK_ALL packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rankList.Length = nSize;

	// End:0x66 [Loop If]
	for (i = 0; i < packet.rankList.Length; i++)
	{
		// End:0x5C
		if(!Decode_RankInfo(packet.rankList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_ARENA_MYRANK(out _S_EX_ARENA_MYRANK packet)
{
	// End:0x17
	if(!DecodeInt(packet.Rank))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.ratingPoint))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_CONTRIBUTION_RANK(out array<byte> stream, _C_EX_PLEDGE_CONTRIBUTION_RANK packet)
{
	// End:0x1C
	if(!EncodeBool(stream, packet.bCurrent))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkPledgeContributionRankInfo(out _PkPledgeContributionRankInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x30
	if(!DecodeWChar_t(packet.szName, 25))
	{
		return false;
	}
	// End:0x47
	if(!DecodeInt(packet.nPledgeType))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeInt(packet.nPeriod))
	{
		return false;
	}
	// End:0x75
	if(!DecodeInt(packet.nTotal))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_CONTRIBUTION_RANK(out _S_EX_PLEDGE_CONTRIBUTION_RANK packet)
{
	local int i, nSize;

	if(!DecodeBool(packet.bCurrent))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vMembers.Length = nSize;

	for (i = 0; i < packet.vMembers.Length; i++)
	{
		if(!Decode_PkPledgeContributionRankInfo(packet.vMembers[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_CONTRIBUTION_INFO(out array<byte> stream, _C_EX_PLEDGE_CONTRIBUTION_INFO packet)
{
	if(!EncodeChar(stream, packet.cReserved))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_CONTRIBUTION_INFO(out _S_EX_PLEDGE_CONTRIBUTION_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPeriod))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nTotal))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nTotalForNextReward))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nAmount))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nNameValue))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_CONTRIBUTION_REWARD(out array<byte> stream, _C_EX_PLEDGE_CONTRIBUTION_REWARD packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_CONTRIBUTION_REWARD(out _S_EX_PLEDGE_CONTRIBUTION_REWARD packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_RAID_INFO(out _S_EX_PLEDGE_RAID_INFO packet)
{
	// End:0x17
	if(!DecodeBool(packet.bIsCurrent_))
	{
		return false;
	}
	// End:0x30
	if(!DecodeWChar_t(packet.szPledgeName_, 25))
	{
		return false;
	}
	// End:0x47
	if(!DecodeInt(packet.nRank_))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeInt(packet.nTier_))
	{
		return false;
	}
	// End:0x75
	if(!DecodeInt64(packet.nPoint_))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeInt(packet.nRewardReason_))
	{
		return false;
	}
	// End:0xA3
	if(!DecodeInt(packet.nSeason_))
	{
		return false;
	}
	// End:0xBA
	if(!DecodeShort(packet.hStartTimeYear_))
	{
		return false;
	}
	// End:0xD1
	if(!DecodeShort(packet.hStartTimeMonth_))
	{
		return false;
	}
	// End:0xE8
	if(!DecodeShort(packet.hStartTimeDay_))
	{
		return false;
	}
	// End:0xFF
	if(!DecodeShort(packet.hEndTimeYear_))
	{
		return false;
	}
	// End:0x116
	if(!DecodeShort(packet.hEndTimeMonth_))
	{
		return false;
	}
	// End:0x12D
	if(!DecodeShort(packet.hEndTimeDay_))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkPledgeRaidRankInfo(out _PkPledgeRaidRankInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nWorldId_))
	{
		return false;
	}
	// End:0x30
	if(!DecodeWChar_t(packet.szPledgeName_, 25))
	{
		return false;
	}
	// End:0x47
	if(!DecodeInt(packet.nRank_))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeInt64(packet.nPoint_))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_RAID_RANK(out _S_EX_PLEDGE_RAID_RANK packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeBool(packet.bIsCurrent_))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vList_.Length = nSize;

	for (i = 0; i < packet.vList_.Length; i++)
	{
		// End:0x73
		if(!Decode_PkPledgeRaidRankInfo(packet.vList_[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_LEVEL_UP(out array<byte> stream, _C_EX_PLEDGE_LEVEL_UP packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cReserved))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_LEVEL_UP(out _S_EX_PLEDGE_LEVEL_UP packet)
{
	// End:0x17
	if(!DecodeChar(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_SHOW_INFO_UPDATE(out _S_EX_PLEDGE_SHOW_INFO_UPDATE packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPledgeSId))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nNextLevelNameValue))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nMaster))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nElite))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_MISSION_REWARD(out array<byte> stream, _C_EX_PLEDGE_MISSION_REWARD packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nMissionId_))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkPledgeMissionInfo(out _PkPledgeMissionInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nMissionId_))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCount_))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.nState_))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_MISSION_INFO(out _S_EX_PLEDGE_MISSION_INFO packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vList_.Length = nSize;

	for (i = 0; i < packet.vList_.Length; i++)
	{
		if(!Decode_PkPledgeMissionInfo(packet.vList_[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_MISSION_REWARD_COUNT(out _S_EX_PLEDGE_MISSION_REWARD_COUNT packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCount_))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nMaxCount_))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_MASTERY_INFO(out array<byte> stream, _C_EX_PLEDGE_MASTERY_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cReserved))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkPledgeMasteryInfo(out _PkPledgeMasteryInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPoint))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.nStatus))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_MASTERY_INFO(out _S_EX_PLEDGE_MASTERY_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nTotalPoint))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nMaxPoint))
	{
		return false;
	}
	// End:0x40
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vMasteries.Length = nSize;

	// End:0x94 [Loop If]
	for (i = 0; i < packet.vMasteries.Length; i++)
	{
		// End:0x8A
		if(!Decode_PkPledgeMasteryInfo(packet.vMasteries[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_MASTERY_SET(out array<byte> stream, _C_EX_PLEDGE_MASTERY_SET packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_MASTERY_SET(out _S_EX_PLEDGE_MASTERY_SET packet)
{
	// End:0x17
	if(!DecodeChar(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_MASTERY_RESET(out array<byte> stream, _C_EX_PLEDGE_MASTERY_RESET packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cReserved))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_MASTERY_RESET(out _S_EX_PLEDGE_MASTERY_RESET packet)
{
	// End:0x17
	if(!DecodeChar(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_SKILL_INFO(out array<byte> stream, _C_EX_PLEDGE_SKILL_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nSkillID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nSkillLevel))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_SKILL_INFO(out _S_EX_PLEDGE_SKILL_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nSkillID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nSkillLevel))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nRemainSecond))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeChar(packet.nStatus))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_SKILL_ACTIVATE(out array<byte> stream, _C_EX_PLEDGE_SKILL_ACTIVATE packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nSkillID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nSkillLevel))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_SKILL_ACTIVATE(out _S_EX_PLEDGE_SKILL_ACTIVATE packet)
{
	// End:0x17
	if(!DecodeChar(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_ITEM_LIST(out array<byte> stream, _C_EX_PLEDGE_ITEM_LIST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cReserved))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_ITEM_ACTIVATE(out array<byte> stream, _C_EX_PLEDGE_ITEM_ACTIVATE packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemClassID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_ITEM_ACTIVATE(out _S_EX_PLEDGE_ITEM_ACTIVATE packet)
{
	// End:0x17
	if(!DecodeChar(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_ANNOUNCE(out array<byte> stream, _C_EX_PLEDGE_ANNOUNCE packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cReserved))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_ANNOUNCE(out _S_EX_PLEDGE_ANNOUNCE packet)
{
	// End:0x18
	if(!DecodeWString(packet.content, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeBool(packet.bShow))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_ANNOUNCE_SET(out array<byte> stream, _C_EX_PLEDGE_ANNOUNCE_SET packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.content, true))
	{
		return false;
	}
	// End:0x39
	if(!EncodeBool(stream, packet.bShow))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_ANNOUNCE_SET(out _S_EX_PLEDGE_ANNOUNCE_SET packet)
{
	// End:0x17
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_ITEM_INFO(out array<byte> stream, _C_EX_PLEDGE_ITEM_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemClassID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_ITEM_BUY(out array<byte> stream, _C_EX_PLEDGE_ITEM_BUY packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemClassID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_ITEM_BUY(out _S_EX_PLEDGE_ITEM_BUY packet)
{
	// End:0x17
	if(!DecodeChar(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQUEST_LOCKED_ITEM(out array<byte> stream, _C_EX_REQUEST_LOCKED_ITEM packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nTargetItemId))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQUEST_UNLOCKED_ITEM(out array<byte> stream, _C_EX_REQUEST_UNLOCKED_ITEM packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nTargetItemId))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_LOCKED_ITEM_CANCEL(out array<byte> stream, _C_EX_LOCKED_ITEM_CANCEL packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_UNLOCKED_ITEM_CANCEL(out array<byte> stream, _C_EX_UNLOCKED_ITEM_CANCEL packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_CHOOSE_LOCKED_ITEM(out _S_EX_CHOOSE_LOCKED_ITEM packet)
{
	// End:0x17
	if(!DecodeInt(packet.nScrollItemClassID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_LOCKED_RESULT(out _S_EX_LOCKED_RESULT packet)
{
	// End:0x17
	if(!DecodeChar(packet.Lock))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.Result))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_OLYMPIAD_INFO(out _S_EX_OLYMPIAD_INFO packet)
{
	// End:0x17
	if(!DecodeBool(packet.bOpen))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nRemainTime))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cGameRuleType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_OLYMPIAD_RECORD(out _S_EX_OLYMPIAD_RECORD packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPoint))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nWinCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nLoseCount))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nMatchCount))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nPrevClassType))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nPrevRank))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeInt(packet.nPrevRankCount))
	{
		return false;
	}
	// End:0xB8
	if(!DecodeInt(packet.nPrevClassRank))
	{
		return false;
	}
	// End:0xCF
	if(!DecodeInt(packet.nPrevClassRankCount))
	{
		return false;
	}
	// End:0xE6
	if(!DecodeInt(packet.nPrevClassRankByServer))
	{
		return false;
	}
	// End:0xFD
	if(!DecodeInt(packet.nPrevClassRankByServerCount))
	{
		return false;
	}
	// End:0x114
	if(!DecodeInt(packet.nPrevPoint))
	{
		return false;
	}
	// End:0x12B
	if(!DecodeInt(packet.nPrevWinCount))
	{
		return false;
	}
	// End:0x142
	if(!DecodeInt(packet.nPrevLoseCount))
	{
		return false;
	}
	// End:0x159
	if(!DecodeInt(packet.nPrevGrade))
	{
		return false;
	}
	// End:0x170
	if(!DecodeInt(packet.nSeasonYear))
	{
		return false;
	}
	// End:0x187
	if(!DecodeInt(packet.nSeasonMonth))
	{
		return false;
	}
	// End:0x19E
	if(!DecodeBool(packet.bMatchOpen))
	{
		return false;
	}
	// End:0x1B5
	if(!DecodeInt(packet.nSeason))
	{
		return false;
	}
	// End:0x1CC
	if(!DecodeBool(packet.bRegistered))
	{
		return false;
	}
	// End:0x1E3
	if(!DecodeChar(packet.cGameRuleType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_OLYMPIAD_MATCH_INFO(out _S_EX_OLYMPIAD_MATCH_INFO packet)
{
	// End:0x19
	if(!DecodeWChar_t(packet.szTeam1Name, 24))
	{
		return false;
	}
	// End:0x30
	if(!DecodeInt(packet.nTeam1WinCount))
	{
		return false;
	}
	// End:0x49
	if(!DecodeWChar_t(packet.szTeam2Name, 24))
	{
		return false;
	}
	// End:0x60
	if(!DecodeInt(packet.nTeam2WinCount))
	{
		return false;
	}
	// End:0x77
	if(!DecodeInt(packet.nCurrentSet))
	{
		return false;
	}
	// End:0x8E
	if(!DecodeInt(packet.nRemainSecond))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ITEM_ANNOUNCE(out _S_EX_ITEM_ANNOUNCE packet)
{
	// End:0x17
	if(!DecodeChar(packet.cType))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeWString(packet.sUserName, true))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeChar(packet.cEnchantCount))
	{
		return false;
	}
	// End:0x74
	if(!DecodeInt(packet.nFromItemClassID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COMPLETED_DAILY_QUEST_LIST(out _S_EX_COMPLETED_DAILY_QUEST_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vQuestIds.Length = nSize;

	for (i = 0; i < packet.vQuestIds.Length; i++)
	{
		// End:0x5C
		if(!DecodeInt(packet.vQuestIds[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_COMPLETED_DAILY_QUEST(out _S_EX_COMPLETED_DAILY_QUEST packet)
{
	// End:0x17
	if(!DecodeInt(packet.QuestID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST(out array<byte> stream, _C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cShopIndex))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PURCHASE_LIMIT_SHOP_ITEM_BUY(out array<byte> stream, _C_EX_PURCHASE_LIMIT_SHOP_ITEM_BUY packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cShopIndex))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nSlotNum))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nItemAmount))
	{
		return false;
	}
	// End:0x70
	if(!EncodeInt(stream, packet.nSuccessionItemSID))
	{
		return false;
	}
	// End:0x8C
	if(!EncodeInt(stream, packet.nMaterialItemSID))
	{
		return false;
	}
	return true;
}

static function bool Decode_PLShopItemData(out _PLShopItemData packet)
{
	local int i;

	// End:0x17
	if(!DecodeInt(packet.nSlotNum))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cResetType))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeShort(packet.sConditionLevel))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nMaxItemAmount))
	{
		return false;
	}

	for (i = 0; i < 3; i++)
	{
		// End:0xA3
		if(!DecodeInt(packet.nCostItemId[i]))
		{
			return false;
		}
	}

	for (i = 0; i < 3; i++)
	{
		// End:0xDD
		if(!DecodeInt64(packet.nCostItemAmount[i]))
		{
			return false;
		}
	}

	for(i = 0; i < 3; i++)
	{
		// End:0x117
		if(!DecodeInt64(packet.nCostItemSaleAmount[i]))
		{
			return false;
		}
	}

	for(i = 0; i < 3; i++)
	{
		// End:0x151
		if(!DecodeFloat(packet.fCostSaleRate[i]))
		{
			return false;
		}
	}
	// End:0x172
	if(!DecodeInt(packet.nRemainItemAmount))
	{
		return false;
	}
	// End:0x189
	if(!DecodeChar(packet.cSellCategory))
	{
		return false;
	}
	// End:0x1A0
	if(!DecodeChar(packet.cEventType))
	{
		return false;
	}
	// End:0x1B7
	if(!DecodeInt(packet.nEventRemainSec))
	{
		return false;
	}
	// End:0x1CE
	if(!DecodeInt(packet.nSaleRemainSec))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST(out _S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cShopIndex))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vItemList.Length = nSize;

	// End:0x7D [Loop If]
	for (i = 0; i < packet.vItemList.Length; i++)
	{
		// End:0x73
		if(!Decode_PLShopItemData(packet.vItemList[i]))
		{
			return false;
		}
	}
	// End:0x94
	if(!DecodeShort(packet.nActiveGachaShopIndex))
	{
		return false;
	}
	return true;
}

static function bool Decode_PLShopResultData(out _PLShopResultData packet)
{
	// End:0x17
	if(!DecodeChar(packet.cIndex))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PURCHASE_LIMIT_SHOP_ITEM_BUY(out _S_EX_PURCHASE_LIMIT_SHOP_ITEM_BUY packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cShopIndex))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nSlotNum))
	{
		return false;
	}
	// End:0x57
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.resultInfoList.Length = nSize;

	for(i = 0; i < packet.resultInfoList.Length; i++)
	{
		// End:0xA1
		if(!Decode_PLShopResultData(packet.resultInfoList[i]))
		{
			return false;
		}
	}
	// End:0xC2
	if(!DecodeInt(packet.nRemainItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_BLOODY_COIN_COUNT(out _S_EX_BLOODY_COIN_COUNT packet)
{
	// End:0x17
	if(!DecodeInt64(packet.nCount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_OPEN_HTML(out array<byte> stream, _C_EX_OPEN_HTML packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cHTMLType))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQUEST_TELEPORT(out array<byte> stream, _C_EX_REQUEST_TELEPORT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_COSTUME_USE_ITEM(out array<byte> stream, _C_EX_COSTUME_USE_ITEM packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemServerId))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_COSTUME_LIST(out array<byte> stream, _C_EX_COSTUME_LIST packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nType))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_COSTUME_COLLECTION_SKILL_ACTIVE(out array<byte> stream, _C_EX_COSTUME_COLLECTION_SKILL_ACTIVE packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCostumeCollectionId))
	{
		return false;
	}
	return true;
}

static function bool Encode_tCostumeAmount(out array<byte> stream, _tCostumeAmount packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCostumeId))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt64(stream, packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_tCostumeAmount(out _tCostumeAmount packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCostumeId))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_COSTUME_EVOLUTION(out array<byte> stream, _C_EX_COSTUME_EVOLUTION packet)
{
	local int i;

	// End:0x1D
	if(!EncodeInt(stream, packet.vTarget.Length))
	{
		return false;
	}
	i = 0;
	J0x24:

	// End:0x65 [Loop If]
	if(i < packet.vTarget.Length)
	{
		// End:0x5B
		if(!Encode_tCostumeAmount(stream, packet.vTarget[i]))
		{
			return false;
		}
		++ i;
		// [Loop Continue]
		goto J0x24;
	}
	// End:0x82
	if(!EncodeInt(stream, packet.vMaterial.Length))
	{
		return false;
	}
	i = 0;
	J0x89:

	// End:0xCA [Loop If]
	if(i < packet.vMaterial.Length)
	{
		// End:0xC0
		if(!Encode_tCostumeAmount(stream, packet.vMaterial[i]))
		{
			return false;
		}
		++ i;
		// [Loop Continue]
		goto J0x89;
	}
	return true;
}

static function bool Encode_C_EX_COSTUME_EXTRACT(out array<byte> stream, _C_EX_COSTUME_EXTRACT packet)
{
	local int i;

	i = stream.Length;
	// End:0x1F
	if(!EncodeShort(stream, 0))
	{
		return false;
	}
	// End:0x3B
	if(!Encode_tCostumeAmount(stream, packet.tExtract))
	{
		return false;
	}
	// End:0x5F
	if(!SetShort(stream, i, stream.Length - i))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_COSTUME_LOCK(out array<byte> stream, _C_EX_COSTUME_LOCK packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCostumeId))
	{
		return false;
	}
	// End:0x38
	if(!EncodeChar(stream, packet.nLockState))
	{
		return false;
	}
	return true;
}

static function bool Encode_tCostumeShortcutInfoStruct(out array<byte> stream, _tCostumeShortcutInfoStruct packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nPage))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nSlotIndex))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nCostumeId))
	{
		return false;
	}
	// End:0x70
	if(!EncodeBool(stream, packet.bAutomaticUse))
	{
		return false;
	}
	return true;
}

static function bool Decode_tCostumeShortcutInfoStruct(out _tCostumeShortcutInfoStruct packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPage))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nSlotIndex))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCostumeId))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeBool(packet.bAutomaticUse))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_COSTUME_CHANGE_SHORTCUT(out array<byte> stream, _C_EX_COSTUME_CHANGE_SHORTCUT packet)
{
	local int i;

	// End:0x1D
	if(!EncodeInt(stream, packet.vChangeList.Length))
	{
		return false;
	}
	i = 0;
	J0x24:

	// End:0x65 [Loop If]
	if(i < packet.vChangeList.Length)
	{
		// End:0x5B
		if(!Encode_tCostumeShortcutInfoStruct(stream, packet.vChangeList[i]))
		{
			return false;
		}
		++ i;
		// [Loop Continue]
		goto J0x24;
	}
	return true;
}

static function bool Decode_S_EX_COSTUME_USE_ITEM(out _S_EX_COSTUME_USE_ITEM packet)
{
	// End:0x17
	if(!DecodeBool(packet.bIsSuccess))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCostumeId))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_CHOOSE_COSTUME_ITEM(out _S_EX_CHOOSE_COSTUME_ITEM packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	return true;
}

static function bool Decode_tCostumeInfoStruct(out _tCostumeInfoStruct packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCostumeId))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.nLockState))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeChar(packet.nChangedType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SEND_COSTUME_LIST(out _S_EX_SEND_COSTUME_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vCostumeList.Length = nSize;
	i = 0;
	J0x2A:

	// End:0x66 [Loop If]
	if(i < packet.vCostumeList.Length)
	{
		// End:0x5C
		if(!Decode_tCostumeInfoStruct(packet.vCostumeList[i]))
		{
			return false;
		}
		++ i;
		// [Loop Continue]
		goto J0x2A;
	}
	return true;
}

static function bool Decode_S_EX_SEND_COSTUME_LIST_FULL(out _S_EX_SEND_COSTUME_LIST_FULL packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vCostumeList.Length = nSize;
	i = 0;
	J0x2A:

	// End:0x66 [Loop If]
	if(i < packet.vCostumeList.Length)
	{
		// End:0x5C
		if(!Decode_tCostumeInfoStruct(packet.vCostumeList[i]))
		{
			return false;
		}
		++ i;
		// [Loop Continue]
		goto J0x2A;
	}
	// End:0x78
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vShortcutList.Length = nSize;
	i = 0;
	J0x90:

	// End:0xCC [Loop If]
	if(i < packet.vShortcutList.Length)
	{
		// End:0xC2
		if(!Decode_tCostumeShortcutInfoStruct(packet.vShortcutList[i]))
		{
			return false;
		}
		++ i;
		// [Loop Continue]
		goto J0x90;
	}
	// End:0xE3
	if(!DecodeInt(packet.nCostumeCollectionId))
	{
		return false;
	}
	// End:0xFA
	if(!DecodeInt(packet.nCostumeCollectionReuseCooltime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COSTUME_COLLECTION_SKILL_ACTIVE(out _S_EX_COSTUME_COLLECTION_SKILL_ACTIVE packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCostumeCollectionId))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCostumeCollectionReuseCooltime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COSTUME_EVOLUTION(out _S_EX_COSTUME_EVOLUTION packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeBool(packet.bResult))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vTarget.Length = nSize;
	i = 0;
	J0x41:

	// End:0x7D [Loop If]
	if(i < packet.vTarget.Length)
	{
		// End:0x73
		if(!Decode_tCostumeAmount(packet.vTarget[i]))
		{
			return false;
		}
		++ i;
		// [Loop Continue]
		goto J0x41;
	}
	// End:0x8F
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vResult.Length = nSize;
	i = 0;
	J0xA7:

	// End:0xE3 [Loop If]
	if(i < packet.vResult.Length)
	{
		// End:0xD9
		if(!Decode_tCostumeAmount(packet.vResult[i]))
		{
			return false;
		}
		++ i;
		// [Loop Continue]
		goto J0xA7;
	}
	return true;
}

static function bool Decode_S_EX_COSTUME_EXTRACT(out _S_EX_COSTUME_EXTRACT packet)
{
	// End:0x17
	if(!DecodeBool(packet.bResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nExtractCostumeId))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nExtractCostumeAmount))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nResultItemClassId))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt64(packet.nResultAmount))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt64(packet.nTotalAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COSTUME_LOCK(out _S_EX_COSTUME_LOCK packet)
{
	if(!DecodeBool(packet.bResult))
	{
		return false;
	}
	if(!DecodeInt(packet.nCostumeId))
	{
		return false;
	}
	if(!DecodeChar(packet.nLockState))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COSTUME_SHORTCUT_LIST(out _S_EX_COSTUME_SHORTCUT_LIST packet)
{
	local int i, nSize;

	if(!DecodeBool(packet.bResult))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vList.Length = nSize;

	for(i = 0; i < packet.vList.Length; i++)
	{
		if(!Decode_tCostumeShortcutInfoStruct(packet.vList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_MAGICLAMP_EXP_INFO(out _S_EX_MAGICLAMP_EXP_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nIsOpen))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nMaxMagicLampExp))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nMagicLampExp))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nMagicLampCount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MAGICLAMP_GAME_INFO(out array<byte> stream, _C_EX_MAGICLAMP_GAME_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cGameMode))
	{
		return false;
	}
	return true;
}

static function bool Decode_CostItemData(out _CostItemData packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nItemAmountPerGame))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MAGICLAMP_GAME_INFO(out _S_EX_MAGICLAMP_GAME_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nMagicLampGameMaxCCount))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nMagicLampGameCCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nMagicLampCountPerGame))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nMagicLampCount))
	{
		return false;
	}
	// End:0x73
	if(!DecodeChar(packet.cGameMode))
	{
		return false;
	}
	// End:0x85
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.costItemList.Length = nSize;

	for(i = 0; i < packet.costItemList.Length; i++)
	{
		// End:0xCF
		if(!Decode_CostItemData(packet.costItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_MAGICLAMP_GAME_START(out array<byte> stream, _C_EX_MAGICLAMP_GAME_START packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nMagicLampGameCCount))
	{
		return false;
	}
	// End:0x38
	if(!EncodeChar(stream, packet.cGameMode))
	{
		return false;
	}
	return true;
}

static function bool Decode_MagicLampGameResultData(out _MagicLampGameResultData packet)
{
	// End:0x17
	if(!DecodeChar(packet.cGradeNum))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nRewardCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nEXP))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt64(packet.nSP))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MAGICLAMP_GAME_RESULT(out _S_EX_MAGICLAMP_GAME_RESULT packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.magicLampGameResult.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.magicLampGameResult.Length; i++)
	{
		// End:0x5C
		if(!Decode_MagicLampGameResultData(packet.magicLampGameResult[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_ACTIVATE_AUTO_SHORTCUT(out array<byte> stream, _C_EX_ACTIVATE_AUTO_SHORTCUT packet)
{
	// End:0x1C
	if(!EncodeShort(stream, packet.nRoomNumber))
	{
		return false;
	}
	// End:0x38
	if(!EncodeBool(stream, packet.bActivate))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ACTIVATE_AUTO_SHORTCUT(out _S_EX_ACTIVATE_AUTO_SHORTCUT packet)
{
	// End:0x17
	if(!DecodeShort(packet.nRoomNumber))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeBool(packet.bActivate))
	{
		return false;
	}
	return true;
}

static function bool Decode_CursedTreasureBoxInfo(out _CursedTreasureBoxInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPosX))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nPosY))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nPosZ))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ACTIVATED_CURSED_TREASURE_BOX_LOCATION(out _S_EX_ACTIVATED_CURSED_TREASURE_BOX_LOCATION packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.treasureBoxInfoList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.treasureBoxInfoList.Length; i++)
	{
		// End:0x5C
		if(!Decode_CursedTreasureBoxInfo(packet.treasureBoxInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_PAYBACK_LIST(out array<byte> stream, _C_EX_PAYBACK_LIST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cEventIDType))
	{
		return false;
	}
	return true;
}

static function bool Decode_PaybackRewardItem(out _PaybackRewardItem packet)
{
	// End:0x17
	if(!DecodeInt(packet.nClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_PaybackRewardSet(out _PaybackRewardSet packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vItemList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.vItemList.Length; i++)
	{
		// End:0x5C
		if(!Decode_PaybackRewardItem(packet.vItemList[i]))
		{
			return false;
		}
	}
	// End:0x7D
	if(!DecodeChar(packet.cSetIndex))
	{
		return false;
	}
	// End:0x94
	if(!DecodeInt(packet.nRequirement))
	{
		return false;
	}
	// End:0xAB
	if(!DecodeChar(packet.cReceived))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PAYBACK_LIST(out _S_EX_PAYBACK_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vRewardSet.Length = nSize;

	for (i = 0; i < packet.vRewardSet.Length; i++)
	{
		// End:0x5C
		if(!Decode_PaybackRewardSet(packet.vRewardSet[i]))
		{
			return false;
		}
	}
	// End:0x7D
	if(!DecodeChar(packet.cEventIDType))
	{
		return false;
	}
	// End:0x94
	if(!DecodeInt(packet.nEndDatetime))
	{
		return false;
	}
	// End:0xAB
	if(!DecodeInt(packet.nConsumedItemclassID))
	{
		return false;
	}
	// End:0xC2
	if(!DecodeInt(packet.nUserConsumption))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PAYBACK_GIVE_REWARD(out array<byte> stream, _C_EX_PAYBACK_GIVE_REWARD packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cEventIDType))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nSetIndex))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PAYBACK_GIVE_REWARD(out _S_EX_PAYBACK_GIVE_REWARD packet)
{
	// End:0x17
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cEventIDType))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nSetIndex))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PAYBACK_UI_LAUNCHER(out _S_EX_PAYBACK_UI_LAUNCHER packet)
{
	// End:0x17
	if(!DecodeBool(packet.bActivate))
	{
		return false;
	}
	return true;
}

static function bool Encode_AutoPlaySetting(out array<byte> stream, _AutoPlaySetting packet)
{
	// End:0x1C
	if(!EncodeBool(stream, packet.bAutoPlay))
	{
		return false;
	}
	// End:0x38
	if(!EncodeBool(stream, packet.bPickUp))
	{
		return false;
	}
	// End:0x54
	if(!EncodeShort(stream, packet.nNextTargetMode))
	{
		return false;
	}
	// End:0x70
	if(!EncodeBool(stream, packet.bIsNearTarget))
	{
		return false;
	}
	// End:0x8C
	if(!EncodeInt(stream, packet.nUsableHPPotionPercent))
	{
		return false;
	}
	// End:0xA8
	if(!EncodeInt(stream, packet.nUsableHPPetPotionPercent))
	{
		return false;
	}
	// End:0xC4
	if(!EncodeBool(stream, packet.bOnMannerMode))
	{
		return false;
	}
	// End:0xE0
	if(!EncodeChar(stream, packet.cMacroIndex))
	{
		return false;
	}
	return true;
}

static function bool Decode_AutoPlaySetting(out _AutoPlaySetting packet)
{
	// End:0x17
	if(!DecodeBool(packet.bAutoPlay))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeBool(packet.bPickUp))
	{
		return false;
	}
	// End:0x45
	if(!DecodeShort(packet.nNextTargetMode))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeBool(packet.bIsNearTarget))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nUsableHPPotionPercent))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nUsableHPPetPotionPercent))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeBool(packet.bOnMannerMode))
	{
		return false;
	}
	// End:0xB8
	if(!DecodeChar(packet.cMacroIndex))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_AUTOPLAY_SETTING(out array<byte> stream, _C_EX_AUTOPLAY_SETTING packet)
{
	local int i;

	i = stream.Length;
	// End:0x1F
	if(!EncodeShort(stream, 0))
	{
		return false;
	}
	// End:0x3B
	if(!Encode_AutoPlaySetting(stream, packet.setting))
	{
		return false;
	}
	// End:0x5F
	if(!SetShort(stream, i, stream.Length - i))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_AUTOPLAY_SETTING(out _S_EX_AUTOPLAY_SETTING packet)
{
	local int i, nSize;

	i = GetCurDecodePos();
	// End:0x1E
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0x35
	if(!Decode_AutoPlaySetting(packet.setting))
	{
		return false;
	}
	// End:0x4E
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_AUTOPLAY_DO_MACRO(out _S_EX_AUTOPLAY_DO_MACRO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nMacroNumber))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_OLYMPIAD_MATCH_MAKING_RESULT(out _S_EX_OLYMPIAD_MATCH_MAKING_RESULT packet)
{
	// End:0x17
	if(!DecodeBool(packet.bRegistered))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cGameRuleType))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_GACHA_SHOP_GACHA_GROUP(out array<byte> stream, _C_EX_GACHA_SHOP_GACHA_GROUP packet)
{
	// End:0x1C
	if(!EncodeShort(stream, packet.nGachaShopId))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_GACHA_SHOP_GACHA_ITEM(out array<byte> stream, _C_EX_GACHA_SHOP_GACHA_ITEM packet)
{
	// End:0x1C
	if(!EncodeShort(stream, packet.nGachaShopId))
	{
		return false;
	}
	// End:0x38
	if(!EncodeShort(stream, packet.nGachaGroupId))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_GACHA_SHOP_INFO(out _S_EX_GACHA_SHOP_INFO packet)
{
	// End:0x17
	if(!DecodeShort(packet.nGachaShopId))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nRemainTime))
	{
		return false;
	}
	// End:0x45
	if(!DecodeShort(packet.nBeforeGachaShopId))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeShort(packet.nBeforeGachaGroupId))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_GACHA_SHOP_GACHA_GROUP(out _S_EX_GACHA_SHOP_GACHA_GROUP packet)
{
	// End:0x17
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.nGachaShopId))
	{
		return false;
	}
	// End:0x45
	if(!DecodeShort(packet.nGachaGroupId))
	{
		return false;
	}
	return true;
}

static function bool Decode_GachaShopItemData(out _GachaShopItemData packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_GACHA_SHOP_GACHA_ITEM(out _S_EX_GACHA_SHOP_GACHA_ITEM packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.nGachaShopId))
	{
		return false;
	}
	// End:0x45
	if(!DecodeShort(packet.nGachaGroupId))
	{
		return false;
	}
	// End:0x57
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vItemList.Length = nSize;

	for(i = 0; i < packet.vItemList.Length; i++)
	{
		// End:0xA1
		if(!Decode_GachaShopItemData(packet.vItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_TIME_RESTRICT_FIELD_USER_ENTER(out array<byte> stream, _C_EX_TIME_RESTRICT_FIELD_USER_ENTER packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nFieldID))
	{
		return false;
	}
	return true;
}

static function bool Decode_FieldRequiredItem(out _FieldRequiredItem packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_TimeRestrictedFieldInfo(out _TimeRestrictedFieldInfo packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vRequiredItems.Length = nSize;

	for (i = 0; i < packet.vRequiredItems.Length; i++)
	{
		// End:0x5C
		if(!Decode_FieldRequiredItem(packet.vRequiredItems[i]))
		{
			return false;
		}
	}
	// End:0x7D
	if(!DecodeInt(packet.nResetCycle))
	{
		return false;
	}
	// End:0x94
	if(!DecodeInt(packet.nFieldID))
	{
		return false;
	}
	// End:0xAB
	if(!DecodeInt(packet.nMinLevel))
	{
		return false;
	}
	// End:0xC2
	if(!DecodeInt(packet.nMaxLevel))
	{
		return false;
	}
	// End:0xD9
	if(!DecodeInt(packet.nRemainTimeBase))
	{
		return false;
	}
	// End:0xF0
	if(!DecodeInt(packet.nRemainTime))
	{
		return false;
	}
	// End:0x107
	if(!DecodeInt(packet.nRemainTimeMax))
	{
		return false;
	}
	// End:0x11E
	if(!DecodeInt(packet.nRemainRefillTime))
	{
		return false;
	}
	// End:0x135
	if(!DecodeInt(packet.nRefillTimeMax))
	{
		return false;
	}
	// End:0x14C
	if(!DecodeBool(packet.bFieldActivated))
	{
		return false;
	}
	// End:0x163
	if(!DecodeBool(packet.bUserBound))
	{
		return false;
	}
	// End:0x17A
	if(!DecodeBool(packet.bCanReEnter))
	{
		return false;
	}
	// End:0x191
	if(!DecodeBool(packet.bIsInZonePCCafeUserOnly))
	{
		return false;
	}
	// End:0x1A8
	if(!DecodeBool(packet.bIsPCCafeUser))
	{
		return false;
	}
	// End:0x1BF
	if(!DecodeBool(packet.bWorldInZone))
	{
		return false;
	}
	// End:0x1D6
	if(!DecodeBool(packet.bCanUseEntranceTicket))
	{
		return false;
	}
	// End:0x1ED
	if(!DecodeInt(packet.nEntranceCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_TIME_RESTRICT_FIELD_LIST(out _S_EX_TIME_RESTRICT_FIELD_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vFieldInfos.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.vFieldInfos.Length; i++)
	{
		// End:0x5C
		if(!Decode_TimeRestrictedFieldInfo(packet.vFieldInfos[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_TIME_RESTRICT_FIELD_USER_ENTER(out _S_EX_TIME_RESTRICT_FIELD_USER_ENTER packet)
{
	// End:0x17
	if(!DecodeBool(packet.bEnterSuccess))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nFieldID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nEnterTimeStamp))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRemainTime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_TIME_RESTRICT_FIELD_USER_CHARGE_RESULT(out _S_EX_TIME_RESTRICT_FIELD_USER_CHARGE_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.nFieldID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nResultRemainTime))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nResultRefillTime))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nResultChargeTime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_TIME_RESTRICT_FIELD_USER_ALARM(out _S_EX_TIME_RESTRICT_FIELD_USER_ALARM packet)
{
	// End:0x17
	if(!DecodeInt(packet.nFieldID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nRemainTime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_TIME_RESTRICT_FIELD_USER_EXIT(out _S_EX_TIME_RESTRICT_FIELD_USER_EXIT packet)
{
	// End:0x17
	if(!DecodeInt(packet.nFieldID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_TIME_RESTRICT_FIELD_SERVER_GROUP(out _S_EX_TIME_RESTRICT_FIELD_SERVER_GROUP packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vWorldIDList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.vWorldIDList.Length; i++)
	{
		// End:0x5C
		if(!DecodeInt(packet.vWorldIDList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_RANKING_CHAR_INFO(out array<byte> stream, _C_EX_RANKING_CHAR_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RANKING_CHAR_INFO(out _S_EX_RANKING_CHAR_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nServerRank))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nRaceRank))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nServerRank_Snapshot))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRaceRank_Snapshot))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nClassRank))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nClassRank_Snapshot))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_RANKING_CHAR_HISTORY(out array<byte> stream, _C_EX_RANKING_CHAR_HISTORY packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkUserRank(out _PkUserRank packet)
{
	// End:0x17
	if(!DecodeInt(packet.nDatetime))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nEXP))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RANKING_CHAR_HISTORY(out _S_EX_RANKING_CHAR_HISTORY packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vHistory.Length = nSize;

	// End:0x66 [Loop If]
	for (i = 0; i < packet.vHistory.Length; i++)
	{
		// End:0x5C
		if(!Decode_PkUserRank(packet.vHistory[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_RANKING_CHAR_RANKERS(out array<byte> stream, _C_EX_RANKING_CHAR_RANKERS packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cRankingGroup))
	{
		return false;
	}
	// End:0x38
	if(!EncodeChar(stream, packet.cRankingScope))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nRace))
	{
		return false;
	}
	// End:0x70
	if(!EncodeInt(stream, packet.nClass))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkRankerData(out _PkRankerData packet)
{
	// End:0x18
	if(!DecodeWString(packet.sUserName, true))
	{
		return false;
	}
	// End:0x30
	if(!DecodeWString(packet.sPledgeName, true))
	{
		return false;
	}
	// End:0x47
	if(!DecodeInt(packet.nWorldID))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	// End:0x75
	if(!DecodeInt(packet.nClass))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeInt(packet.nRace))
	{
		return false;
	}
	// End:0xA3
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0xBA
	if(!DecodeInt(packet.nServerRank_Snapshot))
	{
		return false;
	}
	// End:0xD1
	if(!DecodeInt(packet.nRaceRank_Snapshot))
	{
		return false;
	}
	// End:0xE8
	if(!DecodeInt(packet.nClassRank_Snapshot))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RANKING_CHAR_RANKERS(out _S_EX_RANKING_CHAR_RANKERS packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cRankingGroup))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cRankingScope))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nRace))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nClass))
	{
		return false;
	}
	// End:0x6E
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vRankers.Length = nSize;

	// End:0xC2 [Loop If]
	for(i = 0; i < packet.vRankers.Length; i++)
	{
		// End:0xB8
		if(!Decode_PkRankerData(packet.vRankers[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_RANKING_CHAR_BUFFZONE_NPC_INFO(out _S_EX_RANKING_CHAR_BUFFZONE_NPC_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRemainedCooltime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION(out _S_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION packet)
{
	// End:0x17
	if(!DecodeBool(packet.bIsInWorld))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPosX))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nPosY))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nPosZ))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MERCENARY_CASTLEWAR_CASTLE_INFO(out array<byte> stream, _C_EX_MERCENARY_CASTLEWAR_CASTLE_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MERCENARY_CASTLEWAR_CASTLE_INFO(out _S_EX_MERCENARY_CASTLEWAR_CASTLE_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCastleOwnerPledgeSID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCastleOwnerPledgeCrestDBID))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeWString(packet.wstrCastleOwnerPledgeName, true))
	{
		return false;
	}
	// End:0x75
	if(!DecodeWString(packet.wstrCastleOwnerPledgeMasterName, true))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeInt(packet.nCastleTaxRate))
	{
		return false;
	}
	// End:0xA3
	if(!DecodeInt64(packet.nCurrentIncome))
	{
		return false;
	}
	// End:0xBA
	if(!DecodeInt64(packet.nTotalIncome))
	{
		return false;
	}
	// End:0xD1
	if(!DecodeInt(packet.nNextSiegeTime))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_INFO(out array<byte> stream, _C_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_INFO(out _S_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCastleOwnerPledgeSID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCastleOwnerPledgeCrestDBID))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeWString(packet.wstrCastleOwnerPledgeName, true))
	{
		return false;
	}
	// End:0x75
	if(!DecodeWString(packet.wstrCastleOwnerPledgeMasterName, true))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeInt(packet.nSiegeState))
	{
		return false;
	}
	// End:0xA3
	if(!DecodeInt(packet.nNumOfAttackerPledge))
	{
		return false;
	}
	// End:0xBA
	if(!DecodeInt(packet.nNumOfDefenderPledge))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_HUD_INFO(out _S_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_HUD_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nSiegeState))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nNowTime))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRemainTime))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST(out array<byte> stream, _C_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_DEFENDER_LIST(out array<byte> stream, _C_EX_MERCENARY_CASTLEWAR_CASTLE_SIEGE_DEFENDER_LIST packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_MERCENARY_MEMBER_LIST(out array<byte> stream, _C_EX_PLEDGE_MERCENARY_MEMBER_LIST packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nPledgeSId))
	{
		return false;
	}
	return true;
}

static function bool Decode_MercenaryMemberInfo(out _MercenaryMemberInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nIsMyInfo))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nIsOnline))
	{
		return false;
	}
	// End:0x46
	if(!DecodeWString(packet.wstrMercenaryName, true))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeInt(packet.nClassType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_MERCENARY_MEMBER_LIST(out _S_EX_PLEDGE_MERCENARY_MEMBER_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPledgeSId))
	{
		return false;
	}
	// End:0x40
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lMercenaryMemberList.Length = nSize;

	// End:0x94 [Loop If]
	for (i = 0; i < packet.lMercenaryMemberList.Length; i++)
	{
		// End:0x8A
		if(!Decode_MercenaryMemberInfo(packet.lMercenaryMemberList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_MERCENARY_RECRUIT_INFO_SET(out array<byte> stream, _C_EX_PLEDGE_MERCENARY_RECRUIT_INFO_SET packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nType))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nIsMercenaryRecruit))
	{
		return false;
	}
	// End:0x70
	if(!EncodeInt64(stream, packet.nMercenaryReward))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_MERCENARY_MEMBER_JOIN(out array<byte> stream, _C_EX_PLEDGE_MERCENARY_MEMBER_JOIN packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nUserSID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nType))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	// End:0x70
	if(!EncodeInt(stream, packet.nMercenaryPledgeSID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_MERCENARY_MEMBER_JOIN(out _S_EX_PLEDGE_MERCENARY_MEMBER_JOIN packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nType))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nUserSID))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nMercenaryPledgeSID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PVPBOOK_LIST(out array<byte> stream, _C_EX_PVPBOOK_LIST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkPVPBookKiller(out _PkPVPBookKiller packet)
{
	// End:0x18
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0x30
	if(!DecodeWString(packet.sPledgeName, true))
	{
		return false;
	}
	// End:0x47
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeInt(packet.nRace))
	{
		return false;
	}
	// End:0x75
	if(!DecodeInt(packet.nClass))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeInt(packet.nKillTime))
	{
		return false;
	}
	// End:0xA3
	if(!DecodeBool(packet.bOnline))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PVPBOOK_LIST(out _S_EX_PVPBOOK_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nShowKillerCount))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nTeleportCount))
	{
		return false;
	}
	// End:0x40
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.killers.Length = nSize;

	// End:0x94 [Loop If]
	for(i = 0; i < packet.killers.Length; i++)
	{
		// End:0x8A
		if(!Decode_PkPVPBookKiller(packet.killers[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_PVPBOOK_NEW_PK(out _S_EX_PVPBOOK_NEW_PK packet)
{
	// End:0x18
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PVPBOOK_KILLER_LOCATION(out array<byte> stream, _C_EX_PVPBOOK_KILLER_LOCATION packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.sName, true))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PVPBOOK_KILLER_LOCATION(out _S_EX_PVPBOOK_KILLER_LOCATION packet)
{
	// End:0x18
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeInt(packet.nX))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt(packet.nY))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeInt(packet.nZ))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PVPBOOK_TELEPORT_TO_KILLER(out array<byte> stream, _C_EX_PVPBOOK_TELEPORT_TO_KILLER packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.sName, true))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RAID_DROP_ITEM_ANNOUNCE(out _S_EX_RAID_DROP_ITEM_ANNOUNCE packet)
{
	local int i, nSize;

	// End:0x18
	if(!DecodeWString(packet.sLastAttackerName, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeInt(packet.nNPCClassID))
	{
		return false;
	}
	// End:0x41
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.dropItemClassIds.Length = nSize;

	// End:0x95 [Loop If]
	for(i = 0; i < packet.dropItemClassIds.Length; i++)
	{
		// End:0x8B
		if(!DecodeInt(packet.dropItemClassIds[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_LETTER_COLLECTOR_UI_LAUNCHER(out _S_EX_LETTER_COLLECTOR_UI_LAUNCHER packet)
{
	// End:0x17
	if(!DecodeBool(packet.bActivate))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nMinLevel))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_LETTER_COLLECTOR_TAKE_REWARD(out array<byte> stream, _C_EX_LETTER_COLLECTOR_TAKE_REWARD packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nSetNo))
	{
		return false;
	}
	return true;
}

static function bool Encode_UserInfo_StatBonus(out array<byte> stream, _UserInfo_StatBonus packet)
{
	// End:0x1C
	if(!EncodeShort(stream, packet.nTotalBonus))
	{
		return false;
	}
	// End:0x38
	if(!EncodeShort(stream, packet.nStrBonus))
	{
		return false;
	}
	// End:0x54
	if(!EncodeShort(stream, packet.nDexBonus))
	{
		return false;
	}
	// End:0x70
	if(!EncodeShort(stream, packet.nConBonus))
	{
		return false;
	}
	// End:0x8C
	if(!EncodeShort(stream, packet.nIntBonus))
	{
		return false;
	}
	// End:0xA8
	if(!EncodeShort(stream, packet.nWitBonus))
	{
		return false;
	}
	// End:0xC4
	if(!EncodeShort(stream, packet.nMenBonus))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_SET_STATUS_BONUS(out array<byte> stream, _C_EX_SET_STATUS_BONUS packet)
{
	local int i;

	i = stream.Length;
	// End:0x1F
	if(!EncodeShort(stream, 0))
	{
		return false;
	}
	// End:0x3B
	if(!Encode_UserInfo_StatBonus(stream, packet.additionalStatBonus))
	{
		return false;
	}
	// End:0x5F
	if(!SetShort(stream, i, stream.Length - i))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_RESET_STATUS_BONUS(out array<byte> stream, _C_EX_RESET_STATUS_BONUS packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_OLYMPIAD_RANKING_INFO(out array<byte> stream, _C_EX_OLYMPIAD_RANKING_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cRankingType))
	{
		return false;
	}
	// End:0x38
	if(!EncodeChar(stream, packet.cRankingScope))
	{
		return false;
	}
	// End:0x54
	if(!EncodeBool(stream, packet.bCurrentSeason))
	{
		return false;
	}
	// End:0x70
	if(!EncodeInt(stream, packet.nClassID))
	{
		return false;
	}
	// End:0x8C
	if(!EncodeInt(stream, packet.nWorldID))
	{
		return false;
	}
	return true;
}

static function bool Decode_OlympiadRecentMatch(out _OlympiadRecentMatch packet)
{
	// End:0x18
	if(!DecodeWString(packet.sCharName, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeInt(packet.nClassID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_OLYMPIAD_MY_RANKING_INFO(out _S_EX_OLYMPIAD_MY_RANKING_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nSeasonYear))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nSeasonMonth))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nSeason))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nWinCount))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nLoseCount))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeInt(packet.nOlympiadPoint))
	{
		return false;
	}
	// End:0xB8
	if(!DecodeInt(packet.nPrevRank))
	{
		return false;
	}
	// End:0xCF
	if(!DecodeInt(packet.nPrevWinCount))
	{
		return false;
	}
	// End:0xE6
	if(!DecodeInt(packet.nPrevLoseCount))
	{
		return false;
	}
	// End:0xFD
	if(!DecodeInt(packet.nPrevOlympiadPoint))
	{
		return false;
	}
	// End:0x114
	if(!DecodeInt(packet.nHeroCount))
	{
		return false;
	}
	// End:0x12B
	if(!DecodeInt(packet.nLegendCount))
	{
		return false;
	}
	// End:0x13D
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.recentMatches.Length = nSize;

	// End:0x191 [Loop If]
	for(i = 0; i < packet.recentMatches.Length; i++)
	{
		// End:0x187
		if(!Decode_OlympiadRecentMatch(packet.recentMatches[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_OlympiadRankInfo(out _OlympiadRankInfo packet)
{
	// End:0x18
	if(!DecodeWString(packet.sCharName, true))
	{
		return false;
	}
	// End:0x30
	if(!DecodeWString(packet.sPledgeName, true))
	{
		return false;
	}
	// End:0x47
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeInt(packet.nPrevRank))
	{
		return false;
	}
	// End:0x75
	if(!DecodeInt(packet.nWorldID))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	// End:0xA3
	if(!DecodeInt(packet.nClassID))
	{
		return false;
	}
	// End:0xBA
	if(!DecodeInt(packet.nPledgeLevel))
	{
		return false;
	}
	// End:0xD1
	if(!DecodeInt(packet.nWinCount))
	{
		return false;
	}
	// End:0xE8
	if(!DecodeInt(packet.nLoseCount))
	{
		return false;
	}
	// End:0xFF
	if(!DecodeInt(packet.nOlympiadPoint))
	{
		return false;
	}
	// End:0x116
	if(!DecodeInt(packet.nHeroCount))
	{
		return false;
	}
	// End:0x12D
	if(!DecodeInt(packet.nLegendCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_OLYMPIAD_RANKING_INFO(out _S_EX_OLYMPIAD_RANKING_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cRankingType))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cRankingScope))
	{
		return false;
	}
	// End:0x45
	if(!DecodeBool(packet.bCurrentSeason))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nClassID))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nWorldID))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nTotalUser))
	{
		return false;
	}
	// End:0x9C
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rankInfoList.Length = nSize;

	// End:0xF0 [Loop If]
	for(i = 0; i < packet.rankInfoList.Length; i++)
	{
		// End:0xE6
		if(!Decode_OlympiadRankInfo(packet.rankInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_OlympiadHeroInfo(out _OlympiadHeroInfo packet)
{
	// End:0x18
	if(!DecodeWString(packet.sCharName, true))
	{
		return false;
	}
	// End:0x30
	if(!DecodeWString(packet.sPledgeName, true))
	{
		return false;
	}
	// End:0x47
	if(!DecodeInt(packet.nWorldID))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeInt(packet.nRace))
	{
		return false;
	}
	// End:0x75
	if(!DecodeInt(packet.nSex))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeInt(packet.nClassID))
	{
		return false;
	}
	// End:0xA3
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	// End:0xBA
	if(!DecodeInt(packet.nCount))
	{
		return false;
	}
	// End:0xD1
	if(!DecodeInt(packet.nWinCount))
	{
		return false;
	}
	// End:0xE8
	if(!DecodeInt(packet.nLoseCount))
	{
		return false;
	}
	// End:0xFF
	if(!DecodeInt(packet.nOlympiadPoint))
	{
		return false;
	}
	// End:0x116
	if(!DecodeInt(packet.nPledgeLevel))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_OLYMPIAD_HERO_AND_LEGEND_INFO(out _S_EX_OLYMPIAD_HERO_AND_LEGEND_INFO packet)
{
	local int i, nSize;

	i = GetCurDecodePos();
	// End:0x1E
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0x35
	if(!Decode_OlympiadHeroInfo(packet.legendInfo))
	{
		return false;
	}
	// End:0x4E
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	// End:0x60
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.heroInfoList.Length = nSize;

	// End:0xB4 [Loop If]
	for(i = 0; i < packet.heroInfoList.Length; i++)
	{
		// End:0xAA
		if(!Decode_OlympiadHeroInfo(packet.heroInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_CASTLEWAR_OBSERVER_START(out array<byte> stream, _C_EX_CASTLEWAR_OBSERVER_START packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_RAID_TELEPORT_INFO(out array<byte> stream, _C_EX_RAID_TELEPORT_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RAID_TELEPORT_INFO(out _S_EX_RAID_TELEPORT_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nUsedFreeCount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_TELEPORT_TO_RAID_POSITION(out array<byte> stream, _C_EX_TELEPORT_TO_RAID_POSITION packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nRaidID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_CRAFT_INFO(out _S_EX_CRAFT_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPoint))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCharge))
	{
		return false;
	}
	// End:0x45
	if(!DecodeBool(packet.bGiveItem))
	{
		return false;
	}
	return true;
}

static function bool Encode_ItemServerInfo(out array<byte> stream, _ItemServerInfo packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemServerId))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt64(stream, packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_CRAFT_EXTRACT(out array<byte> stream, _C_EX_CRAFT_EXTRACT packet)
{
	local int i;

	// End:0x1D
	if(!EncodeInt(stream, packet.Items.Length))
	{
		return false;
	}

	// End:0x65 [Loop If]
	for(i = 0; i < packet.Items.Length; i++)
	{
		// End:0x5B
		if(!Encode_ItemServerInfo(stream, packet.Items[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_CRAFT_EXTRACT(out _S_EX_CRAFT_EXTRACT packet)
{
	// End:0x17
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_CRAFT_RANDOM_LOCK_SLOT(out array<byte> stream, _C_EX_CRAFT_RANDOM_LOCK_SLOT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nSlot))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_CRAFT_RANDOM_LOCK_SLOT(out _S_EX_CRAFT_RANDOM_LOCK_SLOT packet)
{
	// End:0x17
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	return true;
}

static function bool Decode_PKUserCraftSlotInfo(out _PKUserCraftSlotInfo packet)
{
	// End:0x17
	if(!DecodeBool(packet.bLocked))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nLockRemain))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt64(packet.nItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_CRAFT_RANDOM_INFO(out _S_EX_CRAFT_RANDOM_INFO packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.slotInfoList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.slotInfoList.Length; i++)
	{
		// End:0x5C
		if(!Decode_PKUserCraftSlotInfo(packet.slotInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_CRAFT_RANDOM_REFRESH(out _S_EX_CRAFT_RANDOM_REFRESH packet)
{
	// End:0x17
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	return true;
}

static function bool Decode_ItemWithEnchantInfo(out _ItemWithEnchantInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cEnchanted))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_CRAFT_RANDOM_MAKE(out _S_EX_CRAFT_RANDOM_MAKE packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0x35
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0x4C
	if(!Decode_ItemWithEnchantInfo(packet.Result))
	{
		return false;
	}
	// End:0x65
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MULTI_SELL_LIST(out array<byte> stream, _C_EX_MULTI_SELL_LIST packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nGroupID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_SAVE_ITEM_ANNOUNCE_SETTING(out array<byte> stream, _C_EX_SAVE_ITEM_ANNOUNCE_SETTING packet)
{
	// End:0x1C
	if(!EncodeBool(stream, packet.bAnonymity))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ITEM_ANNOUNCE_SETTING(out _S_EX_ITEM_ANNOUNCE_SETTING packet)
{
	// End:0x17
	if(!DecodeBool(packet.bAnonymity))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_OLYMPIAD_MATCH_MAKING(out array<byte> stream, _C_EX_OLYMPIAD_MATCH_MAKING packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cGameRuleType))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_OLYMPIAD_MATCH_MAKING_CANCEL(out array<byte> stream, _C_EX_OLYMPIAD_MATCH_MAKING_CANCEL packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cGameRuleType))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_OLYMPIAD_UI(out array<byte> stream, _C_EX_OLYMPIAD_UI packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cGameRuleType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_USER_BOOST_STAT(out _S_EX_USER_BOOST_STAT packet)
{
	// End:0x17
	if(!DecodeChar(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.Count))
	{
		return false;
	}
	// End:0x45
	if(!DecodeShort(packet.Percent))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ADEN_FORTRESS_SIEGE_HUD_INFO(out _S_EX_ADEN_FORTRESS_SIEGE_HUD_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nFortressID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nSiegeState))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nNowTime))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRemainTime))
	{
		return false;
	}
	return true;
}

static function bool Decode_PLShopItemDataNew(out _PLShopItemDataNew packet)
{
	local int i;

	// End:0x17
	if(!DecodeInt(packet.nSlotNum))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}

	// End:0x68 [Loop If]
	for(i = 0; i < 5; i++)
	{
		// End:0x5E
		if(!DecodeInt(packet.nCostItemId[i]))
		{
			return false;
		}
	}

	// End:0xA2 [Loop If]
	for(i = 0; i < 5; i++)
	{
		// End:0x98
		if(!DecodeInt64(packet.nCostItemAmount[i]))
		{
			return false;
		}
	}

	// End:0xDC [Loop If]
	for(i = 0; i < 5; i++)
	{
		// End:0xD2
		if(!DecodeShort(packet.sCostItemEnchant[i]))
		{
			return false;
		}
	}
	// End:0xF3
	if(!DecodeInt(packet.nRemainItemAmount))
	{
		return false;
	}
	// End:0x10A
	if(!DecodeInt(packet.nRemainSec))
	{
		return false;
	}
	// End:0x121
	if(!DecodeInt(packet.nRemainServerItemAmount))
	{
		return false;
	}
	// End:0x138
	if(!DecodeShort(packet.sCircleNum))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW(out _S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cShopIndex))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cPage))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cMaxPage))
	{
		return false;
	}
	// End:0x57
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vItemList.Length = nSize;

	// End:0xAB [Loop If]
	for(i = 0; i < packet.vItemList.Length; i++)
	{
		// End:0xA1
		if(!Decode_PLShopItemDataNew(packet.vItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_VITAL_EX_INFO(out _S_EX_VITAL_EX_INFO packet)
{
	if(!DecodeInt(packet.nVitalLegacyEndTime))
	{
		return false;
	}
	if(!DecodeInt(packet.nVitalMiracleEndTime))
	{
		return false;
	}
	if(!DecodeInt(packet.nVitalLegacyBonusExp))
	{
		return false;
	}
	if(!DecodeInt(packet.nVitalLegacyBonusAdena))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SHARED_POSITION_SHARING_UI(out _S_EX_SHARED_POSITION_SHARING_UI packet)
{
	// End:0x17
	if(!DecodeInt64(packet.nSharingCostLCoin))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_SHARED_POSITION_TELEPORT_UI(out array<byte> stream, _C_EX_SHARED_POSITION_TELEPORT_UI packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Decode_Position(out _Position packet)
{
	// End:0x17
	if(!DecodeInt(packet.X))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.Y))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.Z))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SHARED_POSITION_TELEPORT_UI(out _S_EX_SHARED_POSITION_TELEPORT_UI packet)
{
	local int i, nSize;

	// End:0x18
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt(packet.nRemainedCount))
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0x64
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0x7B
	if(!Decode_Position(packet.Position))
	{
		return false;
	}
	// End:0x94
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	// End:0xAB
	if(!DecodeInt64(packet.nTeleportCostLCoin))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_SHARED_POSITION_TELEPORT(out array<byte> stream, _C_EX_SHARED_POSITION_TELEPORT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Decode_SlotItemClassID(out _SlotItemClassID packet)
{
	// End:0x17
	if(!DecodeInt(packet.nST_UNDERWEAR))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nST_HEAD))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nST_RHAND))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nST_LHAND))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nST_GLOVES))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nST_CHEST))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeInt(packet.nST_LEGS))
	{
		return false;
	}
	// End:0xB8
	if(!DecodeInt(packet.nST_FEET))
	{
		return false;
	}
	// End:0xCF
	if(!DecodeInt(packet.nST_BACK))
	{
		return false;
	}
	// End:0xE6
	if(!DecodeInt(packet.nST_RLHAND))
	{
		return false;
	}
	// End:0xFD
	if(!DecodeInt(packet.nST_HAIR))
	{
		return false;
	}
	// End:0x114
	if(!DecodeInt(packet.nST_HAIR2))
	{
		return false;
	}
	return true;
}

static function bool Decode_OptionalNoKey(out _OptionalNoKey packet)
{
	// End:0x17
	if(!DecodeInt(packet.nNormalOptionNo_ST_RHAND))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nNormalOptionNo_ST_LHAND))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nNormalOptionNo_ST_RLHAND))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRandomOptionNo_ST_RHAND))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nRandomOptionNo_ST_LHAND))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nRandomOptionNo_ST_RLHAND))
	{
		return false;
	}
	return true;
}

static function bool Decode_SlotItemShapeShiftClassID(out _SlotItemShapeShiftClassID packet)
{
	// End:0x17
	if(!DecodeInt(packet.nST_RHAND))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nST_LHAND))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nST_RLHAND))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nST_GLOVES))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nST_CHEST))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nST_LEGS))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeInt(packet.nST_FEET))
	{
		return false;
	}
	// End:0xB8
	if(!DecodeInt(packet.nST_HAIR))
	{
		return false;
	}
	// End:0xCF
	if(!DecodeInt(packet.nST_HAIR2))
	{
		return false;
	}
	return true;
}

static function bool Decode_CachedParameters(out _CachedParameters packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.hRace))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cSex))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nOriginalClass))
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0x7A
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0x91
	if(!Decode_SlotItemClassID(packet.slotItemClassID))
	{
		return false;
	}
	// End:0xAA
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0xC8
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0xDF
	if(!Decode_OptionalNoKey(packet.optionalNoKey))
	{
		return false;
	}
	// End:0xF8
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	// End:0x10F
	if(!DecodeChar(packet.nMinNewSetItemEchantedEffect))
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0x12D
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0x144
	if(!Decode_SlotItemShapeShiftClassID(packet.slotItemShapeShiftClassID))
	{
		return false;
	}
	// End:0x15D
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	// End:0x174
	if(!DecodeChar(packet.cGuilty))
	{
		return false;
	}
	// End:0x18B
	if(!DecodeInt(packet.nCriminalRate))
	{
		return false;
	}
	// End:0x1A2
	if(!DecodeInt(packet.nMCastingSpeed))
	{
		return false;
	}
	// End:0x1B9
	if(!DecodeInt(packet.nPCastingSpeed))
	{
		return false;
	}

	// End:0x1F3 [Loop If]
	for (i = 0; i < 8; i++)
	{
		// End:0x1E9
		if(!DecodeInt(packet.nOrgSpeed[i]))
		{
			return false;
		}
	}
	// End:0x20A
	if(!DecodeFloat(packet.fMoveSpeedModifier))
	{
		return false;
	}
	// End:0x221
	if(!DecodeFloat(packet.fAttackSpeedModifier))
	{
		return false;
	}
	// End:0x238
	if(!DecodeFloat(packet.fCollisionRadius))
	{
		return false;
	}
	// End:0x24F
	if(!DecodeFloat(packet.fCollisionHeight))
	{
		return false;
	}
	// End:0x266
	if(!DecodeInt(packet.nFace))
	{
		return false;
	}
	// End:0x27D
	if(!DecodeInt(packet.nHairShape))
	{
		return false;
	}
	// End:0x294
	if(!DecodeInt(packet.nHairColor))
	{
		return false;
	}
	// End:0x2AC
	if(!DecodeWString(packet.sNickName, true))
	{
		return false;
	}
	// End:0x2C3
	if(!DecodeInt(packet.nPledgeSId))
	{
		return false;
	}
	// End:0x2DA
	if(!DecodeInt(packet.nPledgeCrestId))
	{
		return false;
	}
	// End:0x2F1
	if(!DecodeInt(packet.nAllianceID))
	{
		return false;
	}
	// End:0x308
	if(!DecodeInt(packet.nAllianceCrestId))
	{
		return false;
	}
	// End:0x31F
	if(!DecodeChar(packet.cStopMode))
	{
		return false;
	}
	// End:0x336
	if(!DecodeChar(packet.cSlow))
	{
		return false;
	}
	// End:0x34D
	if(!DecodeChar(packet.cIsCombatMode))
	{
		return false;
	}
	// End:0x364
	if(!DecodeChar(packet.cYongmaType))
	{
		return false;
	}
	// End:0x37B
	if(!DecodeChar(packet.nPrivateStore))
	{
		return false;
	}
	// End:0x38D
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.cubicClassIds.Length = nSize;

	// End:0x3E1 [Loop If]
	for (i = 0; i < packet.cubicClassIds.Length; i++)
	{
		// End:0x3D7
		if(!DecodeShort(packet.cubicClassIds[i]))
		{
			return false;
		}
	}
	// End:0x3F8
	if(!DecodeChar(packet.cDeosShowPartyWantedMessage))
	{
		return false;
	}
	// End:0x40F
	if(!DecodeChar(packet.cEnvironment))
	{
		return false;
	}
	// End:0x426
	if(!DecodeShort(packet.hBonusCount))
	{
		return false;
	}
	// End:0x43D
	if(!DecodeInt(packet.nYongmaClass))
	{
		return false;
	}
	// End:0x454
	if(!DecodeInt(packet.nNowClass))
	{
		return false;
	}
	// End:0x46B
	if(!DecodeInt(packet.nFootEffect))
	{
		return false;
	}
	// End:0x482
	if(!DecodeChar(packet.cSNEnchant))
	{
		return false;
	}
	// End:0x499
	if(!DecodeChar(packet.cBackEnchant))
	{
		return false;
	}
	// End:0x4B0
	if(!DecodeChar(packet.cEventMatchTeamID))
	{
		return false;
	}
	// End:0x4C7
	if(!DecodeInt(packet.nPledgeEmblemId))
	{
		return false;
	}
	// End:0x4DE
	if(!DecodeChar(packet.cIsNobless))
	{
		return false;
	}
	// End:0x4F5
	if(!DecodeChar(packet.cHeroType))
	{
		return false;
	}
	// End:0x50C
	if(!DecodeChar(packet.cIsFishingState))
	{
		return false;
	}
	// End:0x523
	if(!DecodeInt(packet.nFishingPosX))
	{
		return false;
	}
	// End:0x53A
	if(!DecodeInt(packet.nFishingPosY))
	{
		return false;
	}
	// End:0x551
	if(!DecodeInt(packet.nFishingPosZ))
	{
		return false;
	}
	// End:0x568
	if(!DecodeInt(packet.nNameColor))
	{
		return false;
	}
	// End:0x57F
	if(!DecodeInt(packet.nDirection))
	{
		return false;
	}
	// End:0x596
	if(!DecodeChar(packet.cSocialClass))
	{
		return false;
	}
	// End:0x5AD
	if(!DecodeShort(packet.hPledgeType))
	{
		return false;
	}
	// End:0x5C4
	if(!DecodeInt(packet.nNickNameColor))
	{
		return false;
	}
	// End:0x5DB
	if(!DecodeChar(packet.nCursedWeaponLevel))
	{
		return false;
	}
	// End:0x5F2
	if(!DecodeInt(packet.nPledgeNameValue))
	{
		return false;
	}
	// End:0x609
	if(!DecodeInt(packet.nTransformID))
	{
		return false;
	}
	// End:0x620
	if(!DecodeInt(packet.nAgathionID))
	{
		return false;
	}
	// End:0x637
	if(!DecodeChar(packet.nPvPRestrainStatus))
	{
		return false;
	}
	// End:0x64E
	if(!DecodeInt(packet.nCP))
	{
		return false;
	}
	// End:0x665
	if(!DecodeInt(packet.nHP))
	{
		return false;
	}
	// End:0x67C
	if(!DecodeInt(packet.nBaseHP))
	{
		return false;
	}
	// End:0x693
	if(!DecodeInt(packet.nMP))
	{
		return false;
	}
	// End:0x6AA
	if(!DecodeInt(packet.nBaseMP))
	{
		return false;
	}
	// End:0x6C1
	if(!DecodeChar(packet.cBRLectureMark))
	{
		return false;
	}
	// End:0x6D3
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.abnormalVisualEffect.Length = nSize;

	// End:0x727 [Loop If]
	for(i = 0; i < packet.abnormalVisualEffect.Length; i++)
	{
		// End:0x71D
		if(!DecodeShort(packet.abnormalVisualEffect[i]))
		{
			return false;
		}
	}
	// End:0x73E
	if(!DecodeChar(packet.cPledgeGameUserFlag))
	{
		return false;
	}
	// End:0x755
	if(!DecodeChar(packet.cHairAccFlag))
	{
		return false;
	}
	// End:0x76C
	if(!DecodeChar(packet.cRemainAP))
	{
		return false;
	}
	// End:0x783
	if(!DecodeInt(packet.nCursedWeaponClassId))
	{
		return false;
	}
	// End:0x79A
	if(!DecodeInt(packet.nWaitActionId))
	{
		return false;
	}
	// End:0x7B1
	if(!DecodeInt(packet.nFirstRank))
	{
		return false;
	}
	// End:0x7C8
	if(!DecodeShort(packet.hNotoriety))
	{
		return false;
	}
	// End:0x7DF
	if(!DecodeInt(packet.nMainClass))
	{
		return false;
	}
	// End:0x7F6
	if(!DecodeInt(packet.nCharacterColorIndex))
	{
		return false;
	}
	// End:0x80D
	if(!DecodeInt(packet.nWorldID))
	{
		return false;
	}
	return true;
}

static function bool Decode_RealtimeParameters(out _RealtimeParameters packet)
{
	// End:0x17
	if(!DecodeChar(packet.cCreateOrUpdate))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cShowSpawnEvent))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nInformingPosX))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nInformingPosY))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nInformingPosZ))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nVehicleID))
	{
		return false;
	}
	// End:0xA2
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0xB9
	if(!DecodeChar(packet.cIsDead))
	{
		return false;
	}
	// End:0xD0
	if(!DecodeChar(packet.cOrcRiderShapeLevel))
	{
		return false;
	}
	// End:0xE7
	if(!DecodeInt(packet.nlastDeadStatus))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_CHAR_INFO(out _S_EX_CHAR_INFO packet)
{
	local int i, nSize;

	i = GetCurDecodePos();
	// End:0x1E
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0x35
	if(!Decode_CachedParameters(packet.cachedParameters))
	{
		return false;
	}
	// End:0x4E
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0x6C
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0x83
	if(!Decode_RealtimeParameters(packet.realtimeParameters))
	{
		return false;
	}
	// End:0x9C
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_AUTH_RECONNECT(out array<byte> stream, _C_EX_AUTH_RECONNECT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nAccountID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_AUTH_RECONNECT(out _S_EX_AUTH_RECONNECT packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nAuthReconnectKey))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PET_EQUIP_ITEM(out array<byte> stream, _C_EX_PET_EQUIP_ITEM packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemServerId))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PET_UNEQUIP_ITEM(out array<byte> stream, _C_EX_PET_UNEQUIP_ITEM packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemServerId))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_EVOLVE_PET(out array<byte> stream, _C_EX_EVOLVE_PET packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HOMUNCULUS_READY(out _S_EX_HOMUNCULUS_READY packet)
{
	// End:0x17
	if(!DecodeBool(packet.bReady))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HOMUNCULUS_HPSPVP(out _S_EX_HOMUNCULUS_HPSPVP packet)
{
	// End:0x17
	if(!DecodeInt(packet.nHP))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nSP))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nVP))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_ENCHANT_HOMUNCULUS_SKILL(out array<byte> stream, _C_EX_ENCHANT_HOMUNCULUS_SKILL packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.Type))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nIdx))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nLevel))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RESET_HOMUNCULUS_SKILL_RESULT(out _S_EX_RESET_HOMUNCULUS_SKILL_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nIdx))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ENCHANT_HOMUNCULUS_SKILL_RESULT(out _S_EX_ENCHANT_HOMUNCULUS_SKILL_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nIdx))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.MDice))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.HDice))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeInt(packet.SDice))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HOMUNCULUS_POINT_INFO(out _S_EX_HOMUNCULUS_POINT_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nEnchantPoint))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nNPCKillPoint))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nInsertNPCKillPoint))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nInitNPCKillPoint))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nVPPoint))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nInsertVPPoint))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeInt(packet.nInitVPPoint))
	{
		return false;
	}
	// End:0xB8
	if(!DecodeInt(packet.nActivateSlotIndex))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_HOMUNCULUS_ENCHANT_EXP(out array<byte> stream, _C_EX_HOMUNCULUS_ENCHANT_EXP packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nIdx))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT(out _S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_HOMUNCULUS_GET_ENCHANT_POINT(out array<byte> stream, _C_EX_HOMUNCULUS_GET_ENCHANT_POINT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.Type))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT(out _S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nEnchantType))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_HOMUNCULUS_INIT_POINT(out array<byte> stream, _C_EX_HOMUNCULUS_INIT_POINT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.Type))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HOMUNCULUS_INIT_POINT_RESULT(out _S_EX_HOMUNCULUS_INIT_POINT_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nInitType))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_SHOW_HOMUNCULUS_INFO(out array<byte> stream, _C_EX_SHOW_HOMUNCULUS_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.Type))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SHOW_BIRTH_INFO(out _S_EX_SHOW_BIRTH_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.CurrentHP))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.CurrentSP))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.CurrentVP))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt64(packet.ExpiredTime))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_HOMUNCULUS_CREATE_START(out array<byte> stream, _C_EX_HOMUNCULUS_CREATE_START packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HOMUNCULUS_CREATE_START_RESULT(out _S_EX_HOMUNCULUS_CREATE_START_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_HOMUNCULUS_INSERT(out array<byte> stream, _C_EX_HOMUNCULUS_INSERT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.Type))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HOMUNCULUS_INSERT_RESULT(out _S_EX_HOMUNCULUS_INSERT_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_HOMUNCULUS_SUMMON(out array<byte> stream, _C_EX_HOMUNCULUS_SUMMON packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HOMUNCULUS_SUMMON_RESULT(out _S_EX_HOMUNCULUS_SUMMON_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DELETE_HOMUNCULUS_DATA(out array<byte> stream, _C_EX_DELETE_HOMUNCULUS_DATA packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nIdx))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DELETE_HOMUNCLUS_DATA_RESULT(out _S_EX_DELETE_HOMUNCLUS_DATA_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQUEST_ACTIVATE_HOMUNCULUS(out array<byte> stream, _C_EX_REQUEST_ACTIVATE_HOMUNCULUS packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nIdx))
	{
		return false;
	}
	// End:0x38
	if(!EncodeBool(stream, packet.bActivate))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ACTIVATE_HOMUNCULUS_RESULT(out _S_EX_ACTIVATE_HOMUNCULUS_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeBool(packet.bActivate))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_HOMUNCULUS_ACTIVATE_SLOT(out array<byte> stream, _C_EX_HOMUNCULUS_ACTIVATE_SLOT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.SlotIndex))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HOMUNCULUS_ACTIVATE_SLOT_RESULT(out _S_EX_HOMUNCULUS_ACTIVATE_SLOT_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.Type))
	{
		return false;
	}
	return true;
}

static function bool Decode_HomunculusData(out _HomunculusData packet)
{
	local int i;

	// End:0x17
	if(!DecodeInt(packet.nIdx))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.eType))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeBool(packet.bActivate))
	{
		return false;
	}

	// End:0x96 [Loop If]
	for(i = 0; i < 6; i++)
	{
		// End:0x8C
		if(!DecodeInt(packet.m_nSkillID[i]))
		{
			return false;
		}
	}

	// End:0xD0 [Loop If]
	for(i = 0; i < 6; i++)
	{
		// End:0xC6
		if(!DecodeInt(packet.m_nSkillLevel[i]))
		{
			return false;
		}
	}
	// End:0xE7
	if(!DecodeInt(packet.m_nLevel))
	{
		return false;
	}
	// End:0xFE
	if(!DecodeInt(packet.m_nExp))
	{
		return false;
	}
	// End:0x115
	if(!DecodeInt(packet.m_nHP))
	{
		return false;
	}
	// End:0x12C
	if(!DecodeInt(packet.m_nAttack))
	{
		return false;
	}
	// End:0x143
	if(!DecodeInt(packet.m_nDefence))
	{
		return false;
	}
	// End:0x15A
	if(!DecodeInt(packet.m_nCritical))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SHOW_HOMUNCULUS_LIST(out _S_EX_SHOW_HOMUNCULUS_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vHomunDataInfos.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.vHomunDataInfos.Length; i++)
	{
		// End:0x5C
		if(!Decode_HomunculusData(packet.vHomunDataInfos[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_SHOW_HOMUNCULUS_COUPON_UI(out _S_EX_SHOW_HOMUNCULUS_COUPON_UI packet)
{
	// End:0x17
	if(!DecodeChar(packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_SUMMON_HOMUNCULUS_COUPON(out array<byte> stream, _C_EX_SUMMON_HOMUNCULUS_COUPON packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SUMMON_HOMUNCULUS_COUPON_RESULT(out _S_EX_SUMMON_HOMUNCULUS_COUPON_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nIdx))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_TELEPORT_FAVORITES_LIST(out _S_EX_TELEPORT_FAVORITES_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeBool(packet.bUIOn))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vZoneIDs.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.vZoneIDs.Length; i++)
	{
		// End:0x73
		if(!DecodeInt(packet.vZoneIDs[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_TELEPORT_FAVORITES_UI_TOGGLE(out array<byte> stream, _C_EX_TELEPORT_FAVORITES_UI_TOGGLE packet)
{
	// End:0x1C
	if(!EncodeBool(stream, packet.bOn))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_TELEPORT_FAVORITES_ADD_DEL(out array<byte> stream, _C_EX_TELEPORT_FAVORITES_ADD_DEL packet)
{
	// End:0x1C
	if(!EncodeBool(stream, packet.bAddOrDel))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nZoneID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MABLE_GAME_ROLL_DICE(out array<byte> stream, _C_EX_MABLE_GAME_ROLL_DICE packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDiceType))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MABLE_GAME_POPUP_OK(out array<byte> stream, _C_EX_MABLE_GAME_POPUP_OK packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cCellType))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MABLE_GAME_RESET(out array<byte> stream, _C_EX_MABLE_GAME_RESET packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nResetItemType))
	{
		return false;
	}
	return true;
}

static function bool Decode_MableGameReward(out _MableGameReward packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPlayCount))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MABLE_GAME_SHOW_PLAYER_STATE(out _S_EX_MABLE_GAME_SHOW_PLAYER_STATE packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nMableGamePlayCount))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCurrentCellId))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nRemainNormalDiceUseCount))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nMaxNormalDiceUseCount))
	{
		return false;
	}
	// End:0x73
	if(!DecodeChar(packet.cCurrentState))
	{
		return false;
	}
	// End:0x85
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vFinishRewards.Length = nSize;

	// End:0xD9 [Loop If]
	for(i = 0; i < packet.vFinishRewards.Length; i++)
	{
		// End:0xCF
		if(!Decode_MableGameReward(packet.vFinishRewards[i]))
		{
			return false;
		}
	}
	// End:0xEB
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vResetItems.Length = nSize;

	// End:0x13F [Loop If]
	for(i = 0; i < packet.vResetItems.Length; i++)
	{
		// End:0x135
		if(!Decode_ItemInfo(packet.vResetItems[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_MABLE_GAME_DICE_RESULT(out _S_EX_MABLE_GAME_DICE_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.nDice))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nResultCellId))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cResultCellType))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRemainNormalDiceUseCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MABLE_GAME_MOVE(out _S_EX_MABLE_GAME_MOVE packet)
{
	// End:0x17
	if(!DecodeInt(packet.nMoveDelta))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nResultCellId))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cResultCellType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MABLE_GAME_PRISON(out _S_EX_MABLE_GAME_PRISON packet)
{
	// End:0x17
	if(!DecodeInt(packet.nMinDiceForLeavePrison))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nMaxDiceForLeavePrison))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nRemainCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MABLE_GAME_REWARD_ITEM(out _S_EX_MABLE_GAME_REWARD_ITEM packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRewardItemClassId))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nRewardItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MABLE_GAME_SKILL_INFO(out _S_EX_MABLE_GAME_SKILL_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nSkillID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nLev))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MABLE_GAME_MINIGAME(out _S_EX_MABLE_GAME_MINIGAME packet)
{
	// End:0x17
	if(!DecodeInt(packet.nBossType))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nLuckyNumber))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nMyDice))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nBossDice))
	{
		return false;
	}
	// End:0x73
	if(!DecodeChar(packet.cMiniGameResult))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeBool(packet.bLuckyNumber))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeInt(packet.nRewardItemClassId))
	{
		return false;
	}
	// End:0xB8
	if(!DecodeInt64(packet.nRewardItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MABLE_GAME_UI_LAUNCHER(out _S_EX_MABLE_GAME_UI_LAUNCHER packet)
{
	// End:0x17
	if(!DecodeBool(packet.bActivate))
	{
		return false;
	}
	return true;
}

static function bool Decode_PetSkillInfo(out _PetSkillInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nSkillID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nSkillLv))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nReuseDelayGroup))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeBool(packet.bSkillEnchant))
	{
		return false;
	}
	// End:0x73
	if(!DecodeBool(packet.bSkillLock))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PET_SKILL_LIST(out _S_EX_PET_SKILL_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeBool(packet.acquireSkillsByEnterWorldEvent))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.acquireSkillList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.acquireSkillList.Length; i++)
	{
		// End:0x73
		if(!Decode_PetSkillInfo(packet.acquireSkillList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_OPEN_BLESS_OPTION_SCROLL(out _S_EX_OPEN_BLESS_OPTION_SCROLL packet)
{
	// End:0x17
	if(!DecodeInt(packet.nScrollItemClassID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_BLESS_OPTION_PUT_ITEM(out array<byte> stream, _C_EX_BLESS_OPTION_PUT_ITEM packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nPutItemSId))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_BLESS_OPTION_PUT_ITEM(out _S_EX_BLESS_OPTION_PUT_ITEM packet)
{
	// End:0x17
	if(!DecodeBool(packet.bResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_BLESS_OPTION_ENCHANT(out array<byte> stream, _C_EX_BLESS_OPTION_ENCHANT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nPuItemSId))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_BLESS_OPTION_ENCHANT(out _S_EX_BLESS_OPTION_ENCHANT packet)
{
	// End:0x17
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_FESTIVAL_BM_INFO(out array<byte> stream, _C_EX_FESTIVAL_BM_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cIsOpenWindow))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_FESTIVAL_BM_INFO(out _S_EX_FESTIVAL_BM_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nTicketItemClassId))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nTicketItemAmount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nTicketItemAmountPerGame))
	{
		return false;
	}
	return true;
}

static function bool Decode_tFestivalBmInfo(out _tFestivalBmInfo packet)
{
	// End:0x17
	if(!DecodeChar(packet.cFestivalBmGrade))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nFestivalBmItemClassId))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nFestivalBmItemCount))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nFestivalBmItemMaxCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_FESTIVAL_BM_ALL_ITEM_INFO(out _S_EX_FESTIVAL_BM_ALL_ITEM_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nFestivalBmSeason))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vFestivalBmAllInfoList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.vFestivalBmAllInfoList.Length; i++)
	{
		// End:0x73
		if(!Decode_tFestivalBmInfo(packet.vFestivalBmAllInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_FESTIVAL_BM_TOP_ITEM_INFO(out _S_EX_FESTIVAL_BM_TOP_ITEM_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cIsUseFestivalBm))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nFestivalBmSeason))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nFestivalEndTime))
	{
		return false;
	}
	// End:0x57
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vFestivalBmTopInfoList.Length = nSize;

	// End:0xAB [Loop If]
	for(i = 0; i < packet.vFestivalBmTopInfoList.Length; i++)
	{
		// End:0xA1
		if(!Decode_tFestivalBmInfo(packet.vFestivalBmTopInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_FESTIVAL_BM_GAME(out array<byte> stream, _C_EX_FESTIVAL_BM_GAME packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nTicketCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_FESTIVAL_BM_GAME(out _S_EX_FESTIVAL_BM_GAME packet)
{
	// End:0x17
	if(!DecodeChar(packet.cFestivalBmGameResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nTicketItemClassId))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nTicketItemAmount))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nTicketItemAmountPerGame))
	{
		return false;
	}
	// End:0x73
	if(!DecodeChar(packet.cRewardItemGrade))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nRewardItemClassId))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeInt(packet.nRewardItemCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PVP_RANKING_MY_INFO(out _S_EX_PVP_RANKING_MY_INFO packet)
{
	if (!DecodeBool(packet.cType)) return false;
	
	// End:0x17
	if(!DecodeInt64(packet.nPVPPoint))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nPrevRank))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nKillCount))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nDieCount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PVP_RANKING_MY_INFO(out array<byte> stream, _C_EX_PVP_RANKING_MY_INFO packet)
{
	if (!EncodeBool(stream, packet.cType)) return false;

	return true;
}


static function bool Encode_C_EX_PVP_RANKING_LIST(out array<byte> stream, _C_EX_PVP_RANKING_LIST packet)
{
	if (!EncodeBool(stream, packet.cType)) return false;

	// End:0x1C
	if(!EncodeBool(stream, packet.bCurrentSeason))
	{
		return false;
	}
	// End:0x38
	if(!EncodeChar(stream, packet.cRankingGroup))
	{
		return false;
	}
	// End:0x54
	if(!EncodeChar(stream, packet.cRankingScope))
	{
		return false;
	}
	// End:0x70
	if(!EncodeInt(stream, packet.nRace))
	{
		return false;
	}
	return true;
}

static function bool Decode_PKPenaltyUser(out _PKPenaltyUser packet)
{
	// End:0x17
	if(!DecodeInt(packet.nUserID))
	{
		return false;
	}
	// End:0x30
	if(!DecodeWChar_t(packet.charName, 24))
	{
		return false;
	}
	// End:0x47
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeInt(packet.nClass))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PK_PENALTY_LIST(out _S_EX_PK_PENALTY_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.tSnapshot))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.PKUserList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.PKUserList.Length; i++)
	{
		// End:0x73
		if(!Decode_PKPenaltyUser(packet.PKUserList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_PKPenaltyUserLocation(out _PKPenaltyUserLocation packet)
{
	// End:0x17
	if(!DecodeInt(packet.nUserID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.X))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.Y))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.Z))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PK_PENALTY_LIST_ONLY_LOC(out _S_EX_PK_PENALTY_LIST_ONLY_LOC packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.tSnapshot))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.PKUserList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.PKUserList.Length; i++)
	{
		// End:0x73
		if(!Decode_PKPenaltyUserLocation(packet.PKUserList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_PVPRankingRankInfo(out _PVPRankingRankInfo packet)
{
	// End:0x18
	if(!DecodeWString(packet.sCharName, true))
	{
		return false;
	}
	// End:0x30
	if(!DecodeWString(packet.sPledgeName, true))
	{
		return false;
	}
	// End:0x47
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeInt(packet.nRace))
	{
		return false;
	}
	// End:0x75
	if(!DecodeInt(packet.nClass))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeInt64(packet.nPVPPoint))
	{
		return false;
	}
	// End:0xA3
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0xBA
	if(!DecodeInt(packet.nPrevRank))
	{
		return false;
	}
	// End:0xD1
	if(!DecodeInt(packet.nKillCount))
	{
		return false;
	}
	// End:0xE8
	if(!DecodeInt(packet.nDieCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PVP_RANKING_LIST(out _S_EX_PVP_RANKING_LIST packet)
{
	local int i, nSize;

	if (!DecodeBool(packet.cType)) return false;

	// End:0x17
	if(!DecodeBool(packet.bCurrentSeason))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cRankingGroup))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cRankingScope))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRace))
	{
		return false;
	}
	// End:0x6E
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rankInfoList.Length = nSize;

	// End:0xC2 [Loop If]
	for(i = 0; i < packet.rankInfoList.Length; i++)
	{
		// End:0xB8
		if(!Decode_PVPRankingRankInfo(packet.rankInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_ACQUIRE_PET_SKILL(out array<byte> stream, _C_EX_ACQUIRE_PET_SKILL packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nSkillID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nSkillLv))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_V3_INFO(out _S_EX_PLEDGE_V3_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPledgeExp))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPledgeRank))
	{
		return false;
	}
	// End:0x46
	if(!DecodeWString(packet.sAnnounceContent, true))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeBool(packet.bShowAnnounce))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_ENEMY_INFO_LIST(out array<byte> stream, _C_EX_PLEDGE_ENEMY_INFO_LIST packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nPledgeSId))
	{
		return false;
	}
	return true;
}

static function bool Decode_L2PledgeEnemyInfo(out _L2PledgeEnemyInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nEnemyPledgeWorldID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nEnemyPledgeSID))
	{
		return false;
	}
	// End:0x46
	if(!DecodeWString(packet.sEnemyPledgeName, true))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeWString(packet.sEnemyPledgeMasterName, true))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_ENEMY_INFO_LIST(out _S_EX_PLEDGE_ENEMY_INFO_LIST packet)
{
	local int i, nSize;

	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.L2PledgeEnemyInfoList.Length = nSize;

	for(i = 0; i < packet.L2PledgeEnemyInfoList.Length; i++)
	{
		if(!Decode_L2PledgeEnemyInfo(packet.L2PledgeEnemyInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_ENEMY_REGISTER(out array<byte> stream, _C_EX_PLEDGE_ENEMY_REGISTER packet)
{
	if(!EncodeWString(stream, packet.sEnemyPledgeName, true))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_ENEMY_DELETE(out array<byte> stream, _C_EX_PLEDGE_ENEMY_DELETE packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nEnemyPledgeSID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SHOW_PET_EXTRACT_SYSTEM(out _S_EX_SHOW_PET_EXTRACT_SYSTEM packet)
{
	// End:0x17
	if(!DecodeChar(packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HIDE_PET_EXTRACT_SYSTEM(out _S_EX_HIDE_PET_EXTRACT_SYSTEM packet)
{
	// End:0x17
	if(!DecodeChar(packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_TRY_PET_EXTRACT_SYSTEM(out array<byte> stream, _C_EX_TRY_PET_EXTRACT_SYSTEM packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nPetItemSID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RESULT_PET_EXTRACT_SYSTEM(out _S_EX_RESULT_PET_EXTRACT_SYSTEM packet)
{
	// End:0x17
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_V3_SET_ANNOUNCE(out array<byte> stream, _C_EX_PLEDGE_V3_SET_ANNOUNCE packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.sAnnounceContent, true))
	{
		return false;
	}
	// End:0x39
	if(!EncodeBool(stream, packet.bShowAnnounce))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_V3_INFO(out array<byte> stream, _C_EX_PLEDGE_V3_INFO packet)
{
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_ItemDeletionInfo(out _ItemDeletionInfo packet)
{
	if(!DecodeInt(packet.nItemID))
	{
		return false;
	}
	if(!DecodeInt(packet.nDeletionDate))
	{
		return false;
	}
	return true;
}

static function bool Decode_SkillDeletionInfo(out _SkillDeletionInfo packet)
{
	if(!DecodeInt(packet.nSkillID))
	{
		return false;
	}
	if(!DecodeInt(packet.nDeletionDate))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DBJOB_DELETION_INFO(out _S_EX_DBJOB_DELETION_INFO packet)
{
	local int i, nSize;

	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.itemDeletionList.Length = nSize;

	for(i = 0; i < packet.itemDeletionList.Length; i++)
	{
		if(!Decode_ItemDeletionInfo(packet.itemDeletionList[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.skillDeletionList.Length = nSize;

	for(i = 0; i < packet.skillDeletionList.Length; i++)
	{
		if(!Decode_SkillDeletionInfo(packet.skillDeletionList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_RFRankingInfo(out _RFRankingInfo packet)
{
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	if(!DecodeWChar_t(packet.charName, 24))
	{
		return false;
	}
	if(!DecodeInt(packet.nBuyCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_RFRankingRewardInfo(out _RFRankingRewardInfo packet)
{
	if(!DecodeInt(packet.nStartRank))
	{
		return false;
	}
	if(!DecodeInt(packet.nEndRank))
	{
		return false;
	}
	if(!DecodeInt(packet.nRewardItemClassId))
	{
		return false;
	}
	if(!DecodeInt64(packet.nRewardItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_RFBonusInfo(out _RFBonusInfo packet)
{
	if(!DecodeInt(packet.nPoint))
	{
		return false;
	}
	if(!DecodeInt(packet.nRewardItemClassId))
	{
		return false;
	}
	if(!DecodeInt64(packet.nRewardItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_RFBuyItemInfo(out _RFBuyItemInfo packet)
{
	if(!DecodeInt(packet.nBuyId))
	{
		return false;
	}
	if(!DecodeInt(packet.nType))
	{
		return false;
	}
	if(!DecodeBool(packet.bSale))
	{
		return false;
	}
	if(!DecodeInt(packet.nBuyItemClassId))
	{
		return false;
	}
	if(!DecodeInt64(packet.nBuyItemAmount))
	{
		return false;
	}
	if(!DecodeInt(packet.nCostItemClassID))
	{
		return false;
	}
	if(!DecodeInt64(packet.nCostItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RANKING_FESTIVAL_SIDEBAR_INFO(out _S_EX_RANKING_FESTIVAL_SIDEBAR_INFO packet)
{
	local int i, nSize;

	if(!DecodeBool(packet.bShowEvent))
	{
		return false;
	}
	if(!DecodeBool(packet.bOnEvent))
	{
		return false;
	}
	if(!DecodeInt64(packet.nEndTime))
	{
		return false;
	}
	if(!DecodeBool(packet.bRequestRanking))
	{
		return false;
	}
	if(!DecodeInt(packet.nCostType))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rankingInfos.Length = nSize;

	for(i = 0; i < packet.rankingInfos.Length; i++)
	{
		if(!Decode_RFRankingInfo(packet.rankingInfos[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rankingRewardInfos.Length = nSize;

	for(i = 0; i < packet.rankingRewardInfos.Length; i++)
	{
		if(!Decode_RFRankingRewardInfo(packet.rankingRewardInfos[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.bonusInfos.Length = nSize;

	for(i = 0; i < packet.bonusInfos.Length; i++)
	{
		if(!Decode_RFBonusInfo(packet.bonusInfos[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.buyItemInfos.Length = nSize;

	for(i = 0; i < packet.buyItemInfos.Length; i++)
	{
		if(!Decode_RFBuyItemInfo(packet.buyItemInfos[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_RANKING_FESTIVAL_OPEN(out array<byte> stream, _C_EX_RANKING_FESTIVAL_OPEN packet)
{
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_RANKING_FESTIVAL_BUY(out array<byte> stream, _C_EX_RANKING_FESTIVAL_BUY packet)
{
	if(!EncodeInt(stream, packet.nBuyId))
	{
		return false;
	}
	if(!EncodeInt(stream, packet.nBuyCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RANKING_FESTIVAL_BUY(out _S_EX_RANKING_FESTIVAL_BUY packet)
{
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_RANKING_FESTIVAL_BONUS(out array<byte> stream, _C_EX_RANKING_FESTIVAL_BONUS packet)
{
	local int i;

	if(!EncodeInt(stream, packet.nPoints.Length))
	{
		return false;
	}

	for(i = 0; i < packet.nPoints.Length; i++)
	{
		if(!EncodeInt(stream, packet.nPoints[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_RANKING_FESTIVAL_BONUS(out _S_EX_RANKING_FESTIVAL_BONUS packet)
{
	local int i, nSize;

	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.nPoints.Length = nSize;

	for(i = 0; i < packet.nPoints.Length; i++)
	{
		// End:0x73
		if(!DecodeInt(packet.nPoints[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.bonusInfos.Length = nSize;

	for(i = 0; i < packet.bonusInfos.Length; i++)
	{
		if(!Decode_RFBonusInfo(packet.bonusInfos[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_RANKING_FESTIVAL_RANKING(out array<byte> stream, _C_EX_RANKING_FESTIVAL_RANKING packet)
{
	if(!EncodeInt(stream, packet.nRankingType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RANKING_FESTIVAL_RANKING(out _S_EX_RANKING_FESTIVAL_RANKING packet)
{
	local int i, nSize;

	if(!DecodeInt(packet.nRankingType))
	{
		return false;
	}
	if(!DecodeInt(packet.nMyRanking))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rankingInfos.Length = nSize;

	for(i = 0; i < packet.rankingInfos.Length; i++)
	{
		if(!Decode_RFRankingInfo(packet.rankingInfos[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_RANKING_FESTIVAL_MYINFO(out _S_EX_RANKING_FESTIVAL_MYINFO packet)
{
	if(!DecodeInt(packet.nMyRanking))
	{
		return false;
	}
	if(!DecodeInt(packet.nTotalBuyCount))
	{
		return false;
	}
	if(!DecodeBool(packet.bReceiveReward))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS(out array<byte> stream, _C_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS packet)
{
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS(out _S_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS packet)
{
	local int i, nSize;

	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.receivedPoints.Length = nSize;

	for(i = 0; i < packet.receivedPoints.Length; i++)
	{
		if(!DecodeInt(packet.receivedPoints[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_RANKING_FESTIVAL_REWARD(out array<byte> stream, _C_EX_RANKING_FESTIVAL_REWARD packet)
{
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RANKING_FESTIVAL_REWARD(out _S_EX_RANKING_FESTIVAL_REWARD packet)
{
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REFUND_REQ(out array<byte> stream, _C_EX_REFUND_REQ packet)
{
	local int i;

	if(!EncodeInt(stream, packet.dpEconomyFromClient))
	{
		return false;
	}
	if(!EncodeInt(stream, packet.refunds.Length))
	{
		return false;
	}

	for(i = 0; i < packet.refunds.Length; i++)
	{
		if(!EncodeInt(stream, packet.refunds[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_TIMER_CHECK(out array<byte> stream, _C_EX_TIMER_CHECK packet)
{
	if(!EncodeInt(stream, packet.nType))
	{
		return false;
	}
	if(!EncodeInt(stream, packet.nIndex))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_TIMER_CHECK(out _S_EX_TIMER_CHECK packet)
{
	if(!DecodeInt(packet.nType))
	{
		return false;
	}
	if(!DecodeInt(packet.nIndex))
	{
		return false;
	}
	if(!DecodeBool(packet.bFinished))
	{
		return false;
	}
	if(!DecodeInt(packet.nCurrentTime))
	{
		return false;
	}
	if(!DecodeInt(packet.nEndTime))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_STEADY_BOX_LOAD(out array<byte> stream, _C_EX_STEADY_BOX_LOAD packet)
{
	if(!EncodeBool(stream, packet.bDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_STEADY_OPEN_SLOT(out array<byte> stream, _C_EX_STEADY_OPEN_SLOT packet)
{
	if(!EncodeInt(stream, packet.nSlotID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_STEADY_OPEN_BOX(out array<byte> stream, _C_EX_STEADY_OPEN_BOX packet)
{
	if(!EncodeInt(stream, packet.nSlotID))
	{
		return false;
	}
	if(!EncodeInt64(stream, packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_STEADY_GET_REWARD(out array<byte> stream, _C_EX_STEADY_GET_REWARD packet)
{
	if(!EncodeInt(stream, packet.nSlotID))
	{
		return false;
	}
	return true;
}

static function bool Decode_SteadyBoxPrice(out _SteadyBoxPrice packet)
{
	if(!DecodeInt(packet.nIndex))
	{
		return false;
	}
	if(!DecodeInt(packet.nItemType))
	{
		return false;
	}
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_STEADY_BOX_UI_INIT(out _S_EX_STEADY_BOX_UI_INIT packet)
{
	local int i, nSize;

	if(!DecodeInt(packet.nConstantMaxPoint))
	{
		return false;
	}
	if(!DecodeInt(packet.nEventMaxPoint))
	{
		return false;
	}
	if(!DecodeInt(packet.nEventID))
	{
		return false;
	}
	if(!DecodeInt(packet.nEventStartTime))
	{
		return false;
	}
	if(!DecodeInt(packet.nEventEndTime))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vPriceBoxOpen.Length = nSize;

	for(i = 0; i < packet.vPriceBoxOpen.Length; i++)
	{
		if(!Decode_SteadyBoxPrice(packet.vPriceBoxOpen[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vPriceForTime.Length = nSize;

	for(i = 0; i < packet.vPriceForTime.Length; i++)
	{
		if(!Decode_SteadyBoxPrice(packet.vPriceForTime[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(packet.nBoxOpenEndTime))
	{
		return false;
	}
	return true;
}

static function bool Decode_SlotInfo(out _SlotInfo packet)
{
	if(!DecodeInt(packet.nSlotID))
	{
		return false;
	}
	if(!DecodeInt(packet.nSlotState))
	{
		return false;
	}
	if(!DecodeInt(packet.nBoxType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_STEADY_ALL_BOX_UPDATE(out _S_EX_STEADY_ALL_BOX_UPDATE packet)
{
	local int i, nSize;

	if(!DecodeInt(packet.nConstantCurrentPoint))
	{
		return false;
	}
	if(!DecodeInt(packet.nEventGoalCurrentPoint))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vMySlotList.Length = nSize;

	for(i = 0; i < packet.vMySlotList.Length; i++)
	{
		if(!Decode_SlotInfo(packet.vMySlotList[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(packet.nEndTime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_STEADY_ONE_BOX_UPDATE(out _S_EX_STEADY_ONE_BOX_UPDATE packet)
{
	local int i, nSize;

	if(!DecodeInt(packet.nConstantCurrentPoint))
	{
		return false;
	}
	if(!DecodeInt(packet.nEventGoalCurrentPoint))
	{
		return false;
	}
	i = GetCurDecodePos();

	if(!DecodeShort(nSize))
	{
		return false;
	}
	if(!Decode_SlotInfo(packet.MySlot))
	{
		return false;
	}
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	if(!DecodeInt(packet.nEndTime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_STEADY_BOX_REWARD(out _S_EX_STEADY_BOX_REWARD packet)
{
	if(!DecodeInt(packet.nSlotID))
	{
		return false;
	}
	if(!DecodeInt(packet.nItemType))
	{
		return false;
	}
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	if(!DecodeInt(packet.nEnchant))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PET_RANKING_MY_INFO(out array<byte> stream, _C_EX_PET_RANKING_MY_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCollarID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PET_RANKING_MY_INFO(out _S_EX_PET_RANKING_MY_INFO packet)
{
	// End:0x18
	if(!DecodeWString(packet.sNickName, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeInt(packet.nCollarID))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt(packet.nNPCClassID))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeShort(packet.nIndex))
	{
		return false;
	}
	// End:0x74
	if(!DecodeShort(packet.nLevel))
	{
		return false;
	}
	// End:0x8B
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0xA2
	if(!DecodeInt(packet.nPrevRank))
	{
		return false;
	}
	// End:0xB9
	if(!DecodeInt(packet.nRaceRank))
	{
		return false;
	}
	// End:0xD0
	if(!DecodeInt(packet.nPrevRaceRank))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PET_RANKING_LIST(out array<byte> stream, _C_EX_PET_RANKING_LIST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cRankingGroup))
	{
		return false;
	}
	// End:0x38
	if(!EncodeChar(stream, packet.cRankingScope))
	{
		return false;
	}
	// End:0x54
	if(!EncodeShort(stream, packet.nIndex))
	{
		return false;
	}
	// End:0x70
	if(!EncodeInt(stream, packet.nCollarID))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkPetRankingRankerInfo(out _PkPetRankingRankerInfo packet)
{
	// End:0x18
	if(!DecodeWString(packet.sNickName, true))
	{
		return false;
	}
	// End:0x30
	if(!DecodeWString(packet.sUserName, true))
	{
		return false;
	}
	// End:0x48
	if(!DecodeWString(packet.sPledgeName, true))
	{
		return false;
	}
	// End:0x5F
	if(!DecodeInt(packet.nNPCClassID))
	{
		return false;
	}
	// End:0x76
	if(!DecodeShort(packet.nPetIndex))
	{
		return false;
	}
	// End:0x8D
	if(!DecodeShort(packet.nPetLevel))
	{
		return false;
	}
	// End:0xA4
	if(!DecodeShort(packet.nUserRace))
	{
		return false;
	}
	// End:0xBB
	if(!DecodeShort(packet.nUserLevel))
	{
		return false;
	}
	// End:0xD2
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0xE9
	if(!DecodeInt(packet.nPrevRank))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PET_RANKING_LIST(out _S_EX_PET_RANKING_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cRankingGroup))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cRankingScope))
	{
		return false;
	}
	// End:0x45
	if(!DecodeShort(packet.nIndex))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nCollarID))
	{
		return false;
	}
	// End:0x6E
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rankerInfoList.Length = nSize;

	for(i = 0; i < packet.rankerInfoList.Length; i++)
	{
		// End:0xB8
		if(!Decode_PkPetRankingRankerInfo(packet.rankerInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_CollectionItemInfo(out _CollectionItemInfo packet)
{
	// End:0x17
	if(!DecodeChar(packet.cSlotIndex))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cEnchant))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeBool(packet.bBless))
	{
		return false;
	}
	// End:0x73
	if(!DecodeChar(packet.cBlessCondition))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_CollectionInfo(out _CollectionInfo packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.itemInfoList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.itemInfoList.Length; i++)
	{
		// End:0x5C
		if(!Decode_CollectionItemInfo(packet.itemInfoList[i]))
		{
			return false;
		}
	}
	// End:0x7D
	if(!DecodeShort(packet.nCollectionID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COLLECTION_INFO(out _S_EX_COLLECTION_INFO packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.regInfoList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.regInfoList.Length; i++)
	{
		// End:0x5C
		if(!Decode_CollectionInfo(packet.regInfoList[i]))
		{
			return false;
		}
	}
	// End:0x78
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.favoriteList.Length = nSize;

	for(i = 0; i < packet.favoriteList.Length; i++)
	{
		// End:0xC2
		if(!DecodeShort(packet.favoriteList[i]))
		{
			return false;
		}
	}
	// End:0xDE
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rewardList.Length = nSize;

	for(i = 0; i < packet.rewardList.Length; i++)
	{
		// End:0x128
		if(!DecodeShort(packet.rewardList[i]))
		{
			return false;
		}
	}
	// End:0x149
	if(!DecodeChar(packet.cCategory))
	{
		return false;
	}
	// End:0x160
	if(!DecodeShort(packet.nTotalCollectionCount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_COLLECTION_OPEN_UI(out array<byte> stream, _C_EX_COLLECTION_OPEN_UI packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COLLECTION_OPEN_UI(out _S_EX_COLLECTION_OPEN_UI packet)
{
	// End:0x17
	if(!DecodeChar(packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_COLLECTION_CLOSE_UI(out array<byte> stream, _C_EX_COLLECTION_CLOSE_UI packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COLLECTION_CLOSE_UI(out _S_EX_COLLECTION_CLOSE_UI packet)
{
	// End:0x17
	if(!DecodeChar(packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_COLLECTION_LIST(out array<byte> stream, _C_EX_COLLECTION_LIST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cCategory))
	{
		return false;
	}
	return true;
}

static function bool Decode_CollectionPeriodInfo(out _CollectionPeriodInfo packet)
{
	// End:0x17
	if(!DecodeShort(packet.nCollectionID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nRemainTime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COLLECTION_LIST(out _S_EX_COLLECTION_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cCategory))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.periodInfoList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.periodInfoList.Length; i++)
	{
		// End:0x73
		if(!Decode_CollectionPeriodInfo(packet.periodInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_COLLECTION_UPDATE_FAVORITE(out array<byte> stream, _C_EX_COLLECTION_UPDATE_FAVORITE packet)
{
	// End:0x1C
	if(!EncodeBool(stream, packet.bRegister))
	{
		return false;
	}
	// End:0x38
	if(!EncodeShort(stream, packet.nCollectionID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COLLECTION_UPDATE_FAVORITE(out _S_EX_COLLECTION_UPDATE_FAVORITE packet)
{
	// End:0x17
	if(!DecodeBool(packet.bRegister))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.nCollectionID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_COLLECTION_FAVORITE_LIST(out array<byte> stream, _C_EX_COLLECTION_FAVORITE_LIST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COLLECTION_FAVORITE_LIST(out _S_EX_COLLECTION_FAVORITE_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.periodInfoList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.periodInfoList.Length; i++)
	{
		// End:0x5C
		if(!Decode_CollectionPeriodInfo(packet.periodInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_COLLECTION_SUMMARY(out array<byte> stream, _C_EX_COLLECTION_SUMMARY packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COLLECTION_SUMMARY(out _S_EX_COLLECTION_SUMMARY packet)
{
	local int i, nSize;

	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.periodInfoList.Length = nSize;

	for(i = 0; i < packet.periodInfoList.Length; i++)
	{
		if(!Decode_CollectionPeriodInfo(packet.periodInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_COLLECTION_REGISTER(out array<byte> stream, _C_EX_COLLECTION_REGISTER packet)
{
	// End:0x1C
	if(!EncodeShort(stream, packet.nCollectionID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nSlotNumber))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nItemSid))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COLLECTION_REGISTER(out _S_EX_COLLECTION_REGISTER packet)
{
	local int i, nSize;

	if(!DecodeShort(packet.nCollectionID))
	{
		return false;
	}
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	if(!DecodeBool(packet.bRecursiveReward))
	{
		return false;
	}
	i = GetCurDecodePos();

	if(!DecodeShort(nSize))
	{
		return false;
	}
	if(!Decode_CollectionItemInfo(packet.ItemInfo))
	{
		return false;
	}
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COLLECTION_COMPLETE(out _S_EX_COLLECTION_COMPLETE packet)
{
	if(!DecodeShort(packet.nCollectionID))
	{
		return false;
	}
	if(!DecodeInt(packet.nRemainTime))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_COLLECTION_RECEIVE_REWARD(out array<byte> stream, _C_EX_COLLECTION_RECEIVE_REWARD packet)
{
	if(!EncodeShort(stream, packet.nCollectionID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COLLECTION_RECEIVE_REWARD(out _S_EX_COLLECTION_RECEIVE_REWARD packet)
{
	if(!DecodeShort(packet.nCollectionID))
	{
		return false;
	}
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_COLLECTION_RESET(out _S_EX_COLLECTION_RESET packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeShort(packet.nCollectionID))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.slotList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.slotList.Length; i++)
	{
		// End:0x73
		if(!DecodeInt(packet.slotList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_COLLECTION_ACTIVE_EVENT(out _S_EX_COLLECTION_ACTIVE_EVENT packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.activeEventList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.activeEventList.Length; i++)
	{
		// End:0x5C
		if(!DecodeShort(packet.activeEventList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_COLLECTION_RESET_REWARD(out _S_EX_COLLECTION_RESET_REWARD packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.resetList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.resetList.Length; i++)
	{
		// End:0x5C
		if(!DecodeShort(packet.resetList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_PVPBOOK_SHARE_REVENGE_LIST(out array<byte> stream, _C_EX_PVPBOOK_SHARE_REVENGE_LIST packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nOwnerUserSID))
	{
		return false;
	}
	return true;
}

static function bool Decode_CLNTPVPBookShareRevengeInfo(out _CLNTPVPBookShareRevengeInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nShareType))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nKilledTime))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nShowKillerCount))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nTeleportKillerCount))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nSharedTeleportKillerCount))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nKilledUserDBID))
	{
		return false;
	}
	// End:0xA2
	if(!DecodeWString(packet.sKilledUserName, true))
	{
		return false;
	}
	// End:0xBA
	if(!DecodeWString(packet.sKilledUserPledgeName, true))
	{
		return false;
	}
	// End:0xD1
	if(!DecodeInt(packet.nKilledUserLevel))
	{
		return false;
	}
	// End:0xE8
	if(!DecodeInt(packet.nKilledUserRace))
	{
		return false;
	}
	// End:0xFF
	if(!DecodeInt(packet.nKilledUserClass))
	{
		return false;
	}
	// End:0x116
	if(!DecodeInt(packet.nKillUserDBID))
	{
		return false;
	}
	// End:0x12E
	if(!DecodeWString(packet.sKillUserName, true))
	{
		return false;
	}
	// End:0x146
	if(!DecodeWString(packet.sKillUserPledgeName, true))
	{
		return false;
	}
	// End:0x15D
	if(!DecodeInt(packet.nKillUserLevel))
	{
		return false;
	}
	// End:0x174
	if(!DecodeInt(packet.nKillUserRace))
	{
		return false;
	}
	// End:0x18B
	if(!DecodeInt(packet.nKillUserClass))
	{
		return false;
	}
	// End:0x1A2
	if(!DecodeInt(packet.nKillUserOnline))
	{
		return false;
	}
	// End:0x1B9
	if(!DecodeInt(packet.nKillUserKarma))
	{
		return false;
	}
	// End:0x1D0
	if(!DecodeInt(packet.nSharedTime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PVPBOOK_SHARE_REVENGE_LIST(out _S_EX_PVPBOOK_SHARE_REVENGE_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cCurrentPage))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cMaxPage))
	{
		return false;
	}
	// End:0x40
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.RevengeInfo.Length = nSize;

	// End:0x94 [Loop If]
	for(i = 0; i < packet.RevengeInfo.Length; i++)
	{
		// End:0x8A
		if(!Decode_CLNTPVPBookShareRevengeInfo(packet.RevengeInfo[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_PVPBOOK_SHARE_REVENGE_REQ_SHARE_REVENGEINFO(out array<byte> stream, _C_EX_PVPBOOK_SHARE_REVENGE_REQ_SHARE_REVENGEINFO packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.sKilledUserName, true))
	{
		return false;
	}
	// End:0x3A
	if(!EncodeWString(stream, packet.sKillUserName, true))
	{
		return false;
	}
	// End:0x56
	if(!EncodeInt(stream, packet.nShareType))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION(out array<byte> stream, _C_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.sKilledUserName, true))
	{
		return false;
	}
	// End:0x3A
	if(!EncodeWString(stream, packet.sKillUserName, true))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION(out _S_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION packet)
{
	// End:0x18
	if(!DecodeWString(packet.sKillUserName, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeInt(packet.nX))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt(packet.nY))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeInt(packet.nZ))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PVPBOOK_SHARE_REVENGE_TELEPORT_TO_KILLER(out array<byte> stream, _C_EX_PVPBOOK_SHARE_REVENGE_TELEPORT_TO_KILLER packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.sKilledUserName, true))
	{
		return false;
	}
	// End:0x3A
	if(!EncodeWString(stream, packet.sKillUserName, true))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PVPBOOK_SHARE_REVENGE_SHARED_TELEPORT_TO_KILLER(out array<byte> stream, _C_EX_PVPBOOK_SHARE_REVENGE_SHARED_TELEPORT_TO_KILLER packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.sKilledUserName, true))
	{
		return false;
	}
	// End:0x3A
	if(!EncodeWString(stream, packet.sKillUserName, true))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PVPBOOK_SHARE_REVENGE_NEW_REVENGEINFO(out _S_EX_PVPBOOK_SHARE_REVENGE_NEW_REVENGEINFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nShareType))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeWString(packet.sKilledUserName, true))
	{
		return false;
	}
	// End:0x47
	if(!DecodeWString(packet.sKillUserName, true))
	{
		return false;
	}
	return true;
}

static function bool Decode_pkUserWatcherTarget(out _pkUserWatcherTarget packet)
{
	// End:0x18
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeInt(packet.nWorldID))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeInt(packet.nClass))
	{
		return false;
	}
	// End:0x74
	if(!DecodeBool(packet.bLoggedin))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_USER_WATCHER_TARGET_LIST(out _S_EX_USER_WATCHER_TARGET_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.targetList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.targetList.Length; i++)
	{
		// End:0x5C
		if(!Decode_pkUserWatcherTarget(packet.targetList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_USER_WATCHER_TARGET_STATUS(out _S_EX_USER_WATCHER_TARGET_STATUS packet)
{
	// End:0x18
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeInt(packet.nWorldID))
	{
		return false;
	}
	// End:0x46
	if(!DecodeBool(packet.bLoggedin))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_USER_WATCHER_ADD(out array<byte> stream, _C_EX_USER_WATCHER_ADD packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.sTargetName, true))
	{
		return false;
	}
	// End:0x39
	if(!EncodeInt(stream, packet.nTargetWorldID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_USER_WATCHER_DELETE(out array<byte> stream, _C_EX_USER_WATCHER_DELETE packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.sTargetName, true))
	{
		return false;
	}
	// End:0x39
	if(!EncodeInt(stream, packet.nTargetWorldID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PENALTY_ITEM_LIST(out array<byte> stream, _C_EX_PENALTY_ITEM_LIST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.nReserved))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkPenaltyItem(out _PkPenaltyItem packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nItemDBID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nDropDate))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nRestoreCost))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRestoreLCoin))
	{
		return false;
	}
	// End:0x6E
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.itemAssemble.Length = nSize;

	// End:0xC2 [Loop If]
	for(i = 0; i < packet.itemAssemble.Length; i++)
	{
		// End:0xB8
		if(!DecodeByte(packet.itemAssemble[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_PENALTY_ITEM_LIST(out _S_EX_PENALTY_ITEM_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.Items.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.Items.Length; i++)
	{
		// End:0x5C
		if(!Decode_PkPenaltyItem(packet.Items[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_PENALTY_ITEM_RESTORE(out array<byte> stream, _C_EX_PENALTY_ITEM_RESTORE packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemDBID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeBool(stream, packet.bByAdena))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PENALTY_ITEM_RESTORE(out _S_EX_PENALTY_ITEM_RESTORE packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PENALTY_ITEM_DROP(out _S_EX_PENALTY_ITEM_DROP packet)
{
	// End:0x17
	if(!DecodeInt(packet.X))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.Y))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.Z))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PENALTY_ITEM_INFO(out _S_EX_PENALTY_ITEM_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCount))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nMaxCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MAGIC_SKILL_USE_GROUND(out _S_EX_MAGIC_SKILL_USE_GROUND packet)
{
	// End:0x17
	if(!DecodeInt(packet.nSID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nSkillID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nSkillTargetPosX))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nSkillTargetPosY))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nSkillTargetPosZ))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SUBJUGATION_SIDEBAR(out _S_EX_SUBJUGATION_SIDEBAR packet)
{
	// End:0x17
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPoint))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nGachaPoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkSubjugationInfo(out _PkSubjugationInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPoint))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nGachaPoint))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRemainedPeriodicGachaPoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SUBJUGATION_LIST(out _S_EX_SUBJUGATION_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vInfos.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.vInfos.Length; i++)
	{
		// End:0x5C
		if(!Decode_PkSubjugationInfo(packet.vInfos[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_SUBJUGATION_RANKING(out array<byte> stream, _C_EX_SUBJUGATION_RANKING packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkSubjugationRanker(out _PkSubjugationRanker packet)
{
	// End:0x18
	if(!DecodeWString(packet.sUserName, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeInt(packet.nPoint))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SUBJUGATION_RANKING(out _S_EX_SUBJUGATION_RANKING packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vRankers.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.vRankers.Length; i++)
	{
		// End:0x5C
		if(!Decode_PkSubjugationRanker(packet.vRankers[i]))
		{
			return false;
		}
	}
	// End:0x7D
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x94
	if(!DecodeInt(packet.nPoint))
	{
		return false;
	}
	// End:0xAB
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_SUBJUGATION_GACHA_UI(out array<byte> stream, _C_EX_SUBJUGATION_GACHA_UI packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SUBJUGATION_GACHA_UI(out _S_EX_SUBJUGATION_GACHA_UI packet)
{
	// End:0x17
	if(!DecodeInt(packet.nGachaPoint))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_SUBJUGATION_GACHA(out array<byte> stream, _C_EX_SUBJUGATION_GACHA packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkSubjugationGachaItem(out _PkSubjugationGachaItem packet)
{
	// End:0x17
	if(!DecodeInt(packet.nClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SUBJUGATION_GACHA(out _S_EX_SUBJUGATION_GACHA packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vItems.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.vItems.Length; i++)
	{
		// End:0x5C
		if(!Decode_PkSubjugationGachaItem(packet.vItems[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_PkUserViewInfoParameter(out _PkUserViewInfoParameter packet)
{
	// End:0x17
	if(!DecodeUInt16(packet.Type))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.Value))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_USER_VIEW_INFO_PARAMETER(out _S_EX_USER_VIEW_INFO_PARAMETER packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.Parameters.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.Parameters.Length; i++)
	{
		// End:0x5C
		if(!Decode_PkUserViewInfoParameter(packet.Parameters[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_DONATION_INFO(out array<byte> stream, _C_EX_PLEDGE_DONATION_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_DONATION_INFO(out _S_EX_PLEDGE_DONATION_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRemainCount))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeBool(packet.bNewbie))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_DONATION_REQUEST(out array<byte> stream, _C_EX_PLEDGE_DONATION_REQUEST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDonationType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_DONATION_REQUEST(out _S_EX_PLEDGE_DONATION_REQUEST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cDonationType))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nResultType))
	{
		return false;
	}
	// End:0x45
	if(!DecodeBool(packet.bCritical))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nPledgeCoin))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nPledgeExp))
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0x91
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0xA8
	if(!Decode_ItemInfo(packet.rewardItem))
	{
		return false;
	}
	// End:0xC1
	if((GetCurDecodePos() - i) > nSize)
	{
		return false;
	}
	// End:0xD8
	if(!DecodeInt(packet.nRemainCount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_CONTRIBUTION_LIST(out array<byte> stream, _C_EX_PLEDGE_CONTRIBUTION_LIST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkPledgeContribution(out _PkPledgeContribution packet)
{
	// End:0x18
	if(!DecodeWString(packet.sUserName, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeInt(packet.nCurrentContribution))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt(packet.nTotalContribution))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_CONTRIBUTION_LIST(out _S_EX_PLEDGE_CONTRIBUTION_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.contributionList.Length = nSize;

	for(i = 0; i < packet.contributionList.Length; i++)
	{
		// End:0x5C
		if(!Decode_PkPledgeContribution(packet.contributionList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_RANKING_MY_INFO(out array<byte> stream, _C_EX_PLEDGE_RANKING_MY_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_RANKING_MY_INFO(out _S_EX_PLEDGE_RANKING_MY_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPrevRank))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nPledgeExp))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PLEDGE_RANKING_LIST(out array<byte> stream, _C_EX_PLEDGE_RANKING_LIST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cRankingScope))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkPledgeRanking(out _PkPledgeRanking packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPrevRank))
	{
		return false;
	}
	// End:0x46
	if(!DecodeWString(packet.sPledgeName, true))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeInt(packet.nPledgeLevel))
	{
		return false;
	}
	// End:0x75
	if(!DecodeWString(packet.sPledgeMasterName, true))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeInt(packet.nPledgeMasterLevel))
	{
		return false;
	}
	// End:0xA3
	if(!DecodeInt(packet.nPledgeMemberCount))
	{
		return false;
	}
	// End:0xBA
	if(!DecodeInt(packet.nPledgeExp))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_RANKING_LIST(out _S_EX_PLEDGE_RANKING_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cRankingScope))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rankingList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.rankingList.Length; i++)
	{
		// End:0x73
		if(!Decode_PkPledgeRanking(packet.rankingList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_PLEDGE_COIN_INFO(out _S_EX_PLEDGE_COIN_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPledgeCoin))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_ITEM_RESTORE_LIST(out array<byte> stream, _C_EX_ITEM_RESTORE_LIST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cCategory))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkItemRestoreNode(out _PkItemRestoreNode packet)
{
	// End:0x17
	if(!DecodeInt(packet.nBrokenItemClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nFixedItemClassID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cEnchant))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeChar(packet.cOrder))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ITEM_RESTORE_LIST(out _S_EX_ITEM_RESTORE_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cCategory))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.Items.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.Items.Length; i++)
	{
		// End:0x73
		if(!Decode_PkItemRestoreNode(packet.Items[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_ITEM_RESTORE(out array<byte> stream, _C_EX_ITEM_RESTORE packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nBrokenItemClassID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeChar(stream, packet.cEnchant))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ITEM_RESTORE(out _S_EX_ITEM_RESTORE packet)
{
	// End:0x17
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_INFO(out array<byte> stream, _C_EX_DETHRONE_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_RANKING_INFO(out array<byte> stream, _C_EX_DETHRONE_RANKING_INFO packet)
{
	// End:0x1C
	if(!EncodeBool(stream, packet.bCurrentSeason))
	{
		return false;
	}
	// End:0x38
	if(!EncodeChar(stream, packet.cRankingScope))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_SERVER_INFO(out array<byte> stream, _C_EX_DETHRONE_SERVER_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO(out array<byte> stream, _C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cCategory))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_DAILY_MISSION_INFO(out array<byte> stream, _C_EX_DETHRONE_DAILY_MISSION_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_DAILY_MISSION_GET_REWARD(out array<byte> stream, _C_EX_DETHRONE_DAILY_MISSION_GET_REWARD packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_PREV_SEASON_INFO(out array<byte> stream, _C_EX_DETHRONE_PREV_SEASON_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_GET_REWARD(out array<byte> stream, _C_EX_DETHRONE_GET_REWARD packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_ENTER(out array<byte> stream, _C_EX_DETHRONE_ENTER packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_LEAVE(out array<byte> stream, _C_EX_DETHRONE_LEAVE packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_CHECK_NAME(out array<byte> stream, _C_EX_DETHRONE_CHECK_NAME packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.sName, true))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_CHANGE_NAME(out array<byte> stream, _C_EX_DETHRONE_CHANGE_NAME packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.sName, true))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_CONNECT_CASTLE(out array<byte> stream, _C_EX_DETHRONE_CONNECT_CASTLE packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_DISCONNECT_CASTLE(out array<byte> stream, _C_EX_DETHRONE_DISCONNECT_CASTLE packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_INFO(out _S_EX_DETHRONE_INFO packet)
{
	// End:0x18
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeInt(packet.nAttackPoint))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt(packet.nLife))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x74
	if(!DecodeInt(packet.nTotalRankers))
	{
		return false;
	}
	// End:0x8B
	if(!DecodeInt64(packet.nPersonalDethronePoint))
	{
		return false;
	}
	// End:0xA2
	if(!DecodeInt(packet.nPrevRank))
	{
		return false;
	}
	// End:0xB9
	if(!DecodeInt(packet.nPrevTotalRankers))
	{
		return false;
	}
	// End:0xD0
	if(!DecodeInt64(packet.nPrevDethronePoint))
	{
		return false;
	}
	// End:0xE7
	if(!DecodeInt(packet.nServerRank))
	{
		return false;
	}
	// End:0xFE
	if(!DecodeInt64(packet.nServerDethronePoint))
	{
		return false;
	}
	// End:0x115
	if(!DecodeInt(packet.nConquerorWorldID))
	{
		return false;
	}
	// End:0x12D
	if(!DecodeWString(packet.sConquerorName, true))
	{
		return false;
	}
	// End:0x144
	if(!DecodeInt(packet.nOccupyingServerWorldID))
	{
		return false;
	}
	// End:0x15B
	if(!DecodeInt(packet.nTopRankerWorldID))
	{
		return false;
	}
	// End:0x173
	if(!DecodeWString(packet.sTopRankerName, true))
	{
		return false;
	}
	// End:0x18A
	if(!DecodeInt(packet.nTopServerWorldID))
	{
		return false;
	}
	// End:0x1A1
	if(!DecodeInt64(packet.nTopServerDethronePoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkDethroneRankingInfo(out _PkDethroneRankingInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nWorldID))
	{
		return false;
	}
	// End:0x46
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeInt64(packet.nDethronePoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_RANKING_INFO(out _S_EX_DETHRONE_RANKING_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeBool(packet.bCurrentSeason))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cRankingScope))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nTotalRankers))
	{
		return false;
	}
	// End:0x57
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rankInfoList.Length = nSize;

	// End:0xAB [Loop If]
	for(i = 0; i < packet.rankInfoList.Length; i++)
	{
		// End:0xA1
		if(!Decode_PkDethroneRankingInfo(packet.rankInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_PkDethronePointInfo(out _PkDethronePointInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nWorldID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nPoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkDethroneSoulBeadInfo(out _PkDethroneSoulBeadInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nWorldID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nSoulBead))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_SERVER_INFO(out _S_EX_DETHRONE_SERVER_INFO packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.pointInfoList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.pointInfoList.Length; i++)
	{
		// End:0x5C
		if(!Decode_PkDethronePointInfo(packet.pointInfoList[i]))
		{
			return false;
		}
	}
	// End:0x78
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.soulBeadInfoList.Length = nSize;

	// End:0xCC [Loop If]
	for(i = 0; i < packet.soulBeadInfoList.Length; i++)
	{
		// End:0xC2
		if(!Decode_PkDethroneSoulBeadInfo(packet.soulBeadInfoList[i]))
		{
			return false;
		}
	}
	// End:0xDE
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.connectionList.Length = nSize;

	// End:0x132 [Loop If]
	for(i = 0; i < packet.connectionList.Length; i++)
	{
		// End:0x128
		if(!DecodeInt(packet.connectionList[i]))
		{
			return false;
		}
	}
	// End:0x149
	if(!DecodeBool(packet.bAdenCastleOwner))
	{
		return false;
	}
	// End:0x160
	if(!DecodeInt(packet.nDethroneWorldID))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkDethroneDistrictOccupationInfo(out _PkDethroneDistrictOccupationInfo packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nDistrictID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nOccupyingWorldID))
	{
		return false;
	}
	// End:0x40
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.pointInfoList.Length = nSize;

	// End:0x94 [Loop If]
	for(i = 0; i < packet.pointInfoList.Length; i++)
	{
		// End:0x8A
		if(!Decode_PkDethronePointInfo(packet.pointInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO(out _S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO packet)
{
	local int i, nSize;

	if(!DecodeChar(packet.cCategory))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.occupationInfoList.Length = nSize;

	for(i = 0; i < packet.occupationInfoList.Length; i++)
	{
		if(!Decode_PkDethroneDistrictOccupationInfo(packet.occupationInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_PkDethroneDailyMissionInfo(out _PkDethroneDailyMissionInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeBool(packet.bHasReward))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_DAILY_MISSION_INFO(out _S_EX_DETHRONE_DAILY_MISSION_INFO packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.missionInfoList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.missionInfoList.Length; i++)
	{
		// End:0x5C
		if(!Decode_PkDethroneDailyMissionInfo(packet.missionInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_DAILY_MISSION_GET_REWARD(out _S_EX_DETHRONE_DAILY_MISSION_GET_REWARD packet)
{
	// End:0x17
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nPersonalDethronePoint))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt64(packet.nServerDethronePoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_DAILY_MISSION_COMPLETE(out _S_EX_DETHRONE_DAILY_MISSION_COMPLETE packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCompleteMissionCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkDethronePoint(out _PkDethronePoint packet)
{
	// End:0x17
	if(!DecodeInt(packet.nWorldID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nPoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_PREV_SEASON_INFO(out _S_EX_DETHRONE_PREV_SEASON_INFO packet)
{
	local int i, nSize;

	// End:0x18
	if(!DecodeWString(packet.sConquerorName, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt(packet.nTotalRankers))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeInt(packet.nOccupyingWorldID))
	{
		return false;
	}
	// End:0x6F
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.pointList.Length = nSize;

	// End:0xC3 [Loop If]
	for(i = 0; i < packet.pointList.Length; i++)
	{
		// End:0xB9
		if(!Decode_PkDethronePoint(packet.pointList[i]))
		{
			return false;
		}
	}
	// End:0xDA
	if(!DecodeInt64(packet.nTotalSoulBead))
	{
		return false;
	}
	// End:0xF1
	if(!DecodeInt64(packet.nOccupyingServerReward))
	{
		return false;
	}
	// End:0x103
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.personalRewardList.Length = nSize;

	// End:0x157 [Loop If]
	for(i = 0; i < packet.personalRewardList.Length; i++)
	{
		// End:0x14D
		if(!Decode_ItemInfo(packet.personalRewardList[i]))
		{
			return false;
		}
	}
	// End:0x169
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.serverRewardList.Length = nSize;

	// End:0x1BD [Loop If]
	for(i = 0; i < packet.serverRewardList.Length; i++)
	{
		// End:0x1B3
		if(!Decode_ItemInfo(packet.serverRewardList[i]))
		{
			return false;
		}
	}
	// End:0x1D4
	if(!DecodeBool(packet.bHasReward))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_GET_REWARD(out _S_EX_DETHRONE_GET_REWARD packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_CHECK_NAME(out _S_EX_DETHRONE_CHECK_NAME packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_CHANGE_NAME(out _S_EX_DETHRONE_CHANGE_NAME packet)
{
	// End:0x17
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_CONNECT_CASTLE(out _S_EX_DETHRONE_CONNECT_CASTLE packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_DISCONNECT_CASTLE(out _S_EX_DETHRONE_DISCONNECT_CASTLE packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_SEASON_INFO(out _S_EX_DETHRONE_SEASON_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nSeasonYear))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nSeasonMonth))
	{
		return false;
	}
	// End:0x45
	if(!DecodeBool(packet.bOpen))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PACKETREADCOUNTPERSECOND(out array<byte> stream, _C_EX_PACKETREADCOUNTPERSECOND packet)
{
	if(!EncodeInt(stream, packet.packet_num))
	{
		return false;
	}
	if(!EncodeInt(stream, packet.packet_count))
	{
		return false;
	}
	if(!EncodeInt(stream, packet.packet_num_1))
	{
		return false;
	}
	if(!EncodeInt(stream, packet.packet_count_1))
	{
		return false;
	}
	if(!EncodeInt(stream, packet.packet_num_2))
	{
		return false;
	}
	if(!EncodeInt(stream, packet.packet_count_2))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SERVERLIMIT_ITEM_ANNOUNCE(out _S_EX_SERVERLIMIT_ITEM_ANNOUNCE packet)
{
	// End:0x17
	if(!DecodeChar(packet.cType))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeWString(packet.sUserName, true))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeInt(packet.nGetAmount))
	{
		return false;
	}
	// End:0x74
	if(!DecodeInt(packet.nRemainAmount))
	{
		return false;
	}
	// End:0x8B
	if(!DecodeInt(packet.nMaxAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_CHANGE_NICKNAME_COLOR_ICON(out _S_EX_CHANGE_NICKNAME_COLOR_ICON packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_CHANGE_NICKNAME_COLOR_ICON(out array<byte> stream, _C_EX_CHANGE_NICKNAME_COLOR_ICON packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemClassID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nColorIndex))
	{
		return false;
	}
	// End:0x55
	if(!EncodeWString(stream, packet.sNickName, true))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_MOVE_TO_HOST(out array<byte> stream, _C_EX_WORLDCASTLEWAR_MOVE_TO_HOST packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nUserSID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_RETURN_TO_ORIGIN_PEER(out array<byte> stream, _C_EX_WORLDCASTLEWAR_RETURN_TO_ORIGIN_PEER packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nUserSID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_CASTLE_INFO(out array<byte> stream, _C_EX_WORLDCASTLEWAR_CASTLE_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_CASTLE_INFO(out _S_EX_WORLDCASTLEWAR_CASTLE_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCastleOwnerPledgeSID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCastleOwnerPledgeCrestDBID))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeWString(packet.wstrCastleOwnerPledgeName, true))
	{
		return false;
	}
	// End:0x75
	if(!DecodeWString(packet.wstrCastleOwnerPledgeMasterName, true))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeInt(packet.nNextSiegeTime))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO(out array<byte> stream, _C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO(out _S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCastleOwnerPledgeSID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCastleOwnerPledgeCrestDBID))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeWString(packet.wstrCastleOwnerPledgeName, true))
	{
		return false;
	}
	// End:0x75
	if(!DecodeWString(packet.wstrCastleOwnerPledgeMasterName, true))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeInt(packet.nSiegeState))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_HUD_INFO(out _S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_HUD_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nSiegeState))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nNowTime))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRemainTime))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_JOIN(out array<byte> stream, _C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_JOIN packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nAsAttacker))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nIsRegister))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST(out array<byte> stream, _C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET(out array<byte> stream, _C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nType))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nIsMercenaryRecruit))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST(out array<byte> stream, _C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nPledgeSId))
	{
		return false;
	}
	return true;
}

static function bool Decode_WorldCastleWar_MercenaryMemberInfo(out _WorldCastleWar_MercenaryMemberInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nIsMyInfo))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nIsOnline))
	{
		return false;
	}
	// End:0x46
	if(!DecodeWString(packet.wstrMercenaryName, true))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeInt(packet.nClassType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST(out _S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPledgeSId))
	{
		return false;
	}
	// End:0x40
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstWorldCastleWarMercenaryMemberList.Length = nSize;

	// End:0x94 [Loop If]
	for(i = 0; i < packet.lstWorldCastleWarMercenaryMemberList.Length; i++)
	{
		// End:0x8A
		if(!Decode_WorldCastleWar_MercenaryMemberInfo(packet.lstWorldCastleWarMercenaryMemberList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN(out array<byte> stream, _C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nUserSID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nType))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	// End:0x70
	if(!EncodeInt(stream, packet.nMercenaryPledgeSID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN(out _S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nType))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nUserSID))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nMercenaryPledgeSID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_TELEPORT(out array<byte> stream, _C_EX_WORLDCASTLEWAR_TELEPORT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nTeleportID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_OBSERVER_START(out array<byte> stream, _C_EX_WORLDCASTLEWAR_OBSERVER_START packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Decode_WorldCastleWar_MainBattleOccupyInfo(out _WorldCastleWar_MainBattleOccupyInfo packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nOccupyNPCSID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nOccupyNPCClassID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nOccypyNPCState))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nOccupiedPledgeSID))
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0x7A
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0x91
	if(!Decode_Position(packet.nOccypyNPCLocation))
	{
		return false;
	}
	// End:0xAA
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_OCCUPY_INFO(out _S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_OCCUPY_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstWorldCastleWar_MainBattleOccupyInfoList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.lstWorldCastleWar_MainBattleOccupyInfoList.Length; i++)
	{
		// End:0x73
		if(!Decode_WorldCastleWar_MainBattleOccupyInfo(packet.lstWorldCastleWar_MainBattleOccupyInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_WorldCastleWar_MainBattleHeroWeaponInfo(out _WorldCastleWar_MainBattleHeroWeaponInfo packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nHeroWeaponNPCSID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nHeroWeaponNPCClassID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nHeroWeaponNPCState))
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0x63
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0x7A
	if(!Decode_Position(packet.nHeroWeaponNPCLocation))
	{
		return false;
	}
	// End:0x93
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_INFO(out _S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList.Length; i++)
	{
		// End:0x73
		if(!Decode_WorldCastleWar_MainBattleHeroWeaponInfo(packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_WorldCastleWar_MainBattleHeroWeaponUserInfo(out _WorldCastleWar_MainBattleHeroWeaponUserInfo packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nHeroWeaponUserSID))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeWString(packet.sHeroWeaponUserName, true))
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0x4D
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0x64
	if(!Decode_Position(packet.nHeroWeaponUserLocation))
	{
		return false;
	}
	// End:0x7D
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_USER(out _S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_USER packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList.Length; i++)
	{
		// End:0x73
		if(!Decode_WorldCastleWar_MainBattleHeroWeaponUserInfo(packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_WorldCastleWar_MainBattleSiegeGolemInfo(out _WorldCastleWar_MainBattleSiegeGolemInfo packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nSiegeGolemNPCSID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nSiegeGolemNPCClassID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nSiegeGolemNPCState))
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0x63
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0x7A
	if(!Decode_Position(packet.nSiegeGolemNPCLocation))
	{
		return false;
	}
	// End:0x93
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_SIEGE_GOLEM_INFO(out _S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_SIEGE_GOLEM_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList.Length; i++)
	{
		// End:0x73
		if(!Decode_WorldCastleWar_MainBattleSiegeGolemInfo(packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_WorldCastleWar_MainBattleDoorInfo(out _WorldCastleWar_MainBattleDoorInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nDoorStaticObjectID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nDoorSID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nDoorState))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO(out _S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstWorldCastleWar_MainBattleDoorInfoList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.lstWorldCastleWar_MainBattleDoorInfoList.Length; i++)
	{
		// End:0x73
		if(!Decode_WorldCastleWar_MainBattleDoorInfo(packet.lstWorldCastleWar_MainBattleDoorInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO(out array<byte> stream, _C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO(out _S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstWorldCastleWar_MainBattleOccupyInfoList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.lstWorldCastleWar_MainBattleOccupyInfoList.Length; i++)
	{
		// End:0x73
		if(!Decode_WorldCastleWar_MainBattleOccupyInfo(packet.lstWorldCastleWar_MainBattleOccupyInfoList[i]))
		{
			return false;
		}
	}
	// End:0x8F
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList.Length = nSize;

	// End:0xE3 [Loop If]
	for(i = 0; i < packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList.Length; i++)
	{
		// End:0xD9
		if(!Decode_WorldCastleWar_MainBattleHeroWeaponInfo(packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList[i]))
		{
			return false;
		}
	}
	// End:0xF5
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList.Length = nSize;

	// End:0x149 [Loop If]
	for(i = 0; i < packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList.Length; i++)
	{
		// End:0x13F
		if(!Decode_WorldCastleWar_MainBattleHeroWeaponUserInfo(packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList[i]))
		{
			return false;
		}
	}
	// End:0x15B
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList.Length = nSize;

	// End:0x1AF [Loop If]
	for(i = 0; i < packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList.Length; i++)
	{
		// End:0x1A5
		if(!Decode_WorldCastleWar_MainBattleSiegeGolemInfo(packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList[i]))
		{
			return false;
		}
	}
	// End:0x1C1
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstWorldCastleWar_MainBattleDoorInfoList.Length = nSize;

	// End:0x215 [Loop If]
	for(i = 0; i < packet.lstWorldCastleWar_MainBattleDoorInfoList.Length; i++)
	{
		// End:0x20B
		if(!Decode_WorldCastleWar_MainBattleDoorInfo(packet.lstWorldCastleWar_MainBattleDoorInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO(out _S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nSiegeState))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nNowTime))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRemainTime))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nNextSiegeTime))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PRIVATE_STORE_SEARCH_LIST(out array<byte> stream, _C_EX_PRIVATE_STORE_SEARCH_LIST packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.sSearchWord, true))
	{
		return false;
	}
	// End:0x39
	if(!EncodeChar(stream, packet.cStoreType))
	{
		return false;
	}
	// End:0x55
	if(!EncodeChar(stream, packet.cItemType))
	{
		return false;
	}
	// End:0x71
	if(!EncodeChar(stream, packet.cItemSubtype))
	{
		return false;
	}
	// End:0x8D
	if(!EncodeBool(stream, packet.bSearchCollection))
	{
		return false;
	}
	return true;
}

static function bool Decode_pkPSSearchItem(out _pkPSSearchItem packet)
{
	local int i, nSize;

	if(!DecodeWString(packet.sUserName, true))
	{
		return false;
	}
	if(!DecodeInt(packet.nUserSID))
	{
		return false;
	}
	if(!DecodeChar(packet.cStoreType))
	{
		return false;
	}
	if(!DecodeInt64(packet.nPrice))
	{
		return false;
	}
	if(!DecodeInt(packet.nX))
	{
		return false;
	}
	if(!DecodeInt(packet.nY))
	{
		return false;
	}
	if(!DecodeInt(packet.nZ))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.itemAssemble.Length = nSize;

	for(i = 0; i < packet.itemAssemble.Length; i++)
	{
		if(!DecodeByte(packet.itemAssemble[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_PRIVATE_STORE_SEARCH_ITEM(out _S_EX_PRIVATE_STORE_SEARCH_ITEM packet)
{
	local int i, nSize;

	if(!DecodeChar(packet.cCurrentPage))
	{
		return false;
	}
	if(!DecodeChar(packet.cMaxPage))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.Items.Length = nSize;

	for(i = 0; i < packet.Items.Length; i++)
	{
		if(!Decode_pkPSSearchItem(packet.Items[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_pkPSSearchHistory(out _pkPSSearchHistory packet)
{
	// End:0x17
	if(!DecodeInt(packet.nClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cStoreType))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cEnchant))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt64(packet.nPrice))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PRIVATE_STORE_SEARCH_HISTORY(out _S_EX_PRIVATE_STORE_SEARCH_HISTORY packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cCurrentPage))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cMaxPage))
	{
		return false;
	}
	// End:0x40
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.histories.Length = nSize;

	// End:0x94 [Loop If]
	for(i = 0; i < packet.histories.Length; i++)
	{
		// End:0x8A
		if(!Decode_pkPSSearchHistory(packet.histories[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_pkPSSearchMostItem(out _pkPSSearchMostItem packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nCount))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.itemAssemble.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.itemAssemble.Length; i++)
	{
		// End:0x73
		if(!DecodeByte(packet.itemAssemble[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_pkPSSearchHighestItem(out _pkPSSearchHighestItem packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt64(packet.nPrice))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.itemAssemble.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.itemAssemble.Length; i++)
	{
		// End:0x73
		if(!DecodeByte(packet.itemAssemble[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_PRIVATE_STORE_SEARCH_STATISTICS(out _S_EX_PRIVATE_STORE_SEARCH_STATISTICS packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.mostItems.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.mostItems.Length; i++)
	{
		// End:0x5C
		if(!Decode_pkPSSearchMostItem(packet.mostItems[i]))
		{
			return false;
		}
	}
	// End:0x78
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.highestItems.Length = nSize;

	// End:0xCC [Loop If]
	for(i = 0; i < packet.highestItems.Length; i++)
	{
		// End:0xC2
		if(!Decode_pkPSSearchHighestItem(packet.highestItems[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_PRIVATE_STORE_BUY_SELL(out array<byte> stream, _C_EX_PRIVATE_STORE_BUY_SELL packet)
{
	if(!EncodeInt(stream, packet.nTargetSid))
	{
		return false;
	}
	return true;
}

static function bool Decode_NewHennaInfo(out _NewHennaInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nHennaID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPotenID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cActive))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeShort(packet.nEnchantStep))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nEnchantExp))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeShort(packet.nActiveStep))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeShort(packet.nDailyStep))
	{
		return false;
	}
	// End:0xB8
	if(!DecodeShort(packet.nDailyCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_NEW_HENNA_LIST(out _S_EX_NEW_HENNA_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeShort(packet.nDailyStep))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.nDailyCount))
	{
		return false;
	}
	// End:0x40
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.hennaInfoList.Length = nSize;

	// End:0x94 [Loop If]
	for(i = 0; i < packet.hennaInfoList.Length; i++)
	{
		// End:0x8A
		if(!Decode_NewHennaInfo(packet.hennaInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_NEW_HENNA_EQUIP(out array<byte> stream, _C_EX_NEW_HENNA_EQUIP packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cSlotID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nItemSid))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_NEW_HENNA_EQUIP(out _S_EX_NEW_HENNA_EQUIP packet)
{
	// End:0x17
	if(!DecodeChar(packet.cSlotID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nHennaID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cSuccess))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_NEW_HENNA_UNEQUIP(out array<byte> stream, _C_EX_NEW_HENNA_UNEQUIP packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cSlotID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_NEW_HENNA_UNEQUIP(out _S_EX_NEW_HENNA_UNEQUIP packet)
{
	// End:0x17
	if(!DecodeChar(packet.cSlotID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cSuccess))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_NEW_HENNA_POTEN_SELECT(out array<byte> stream, _C_EX_NEW_HENNA_POTEN_SELECT packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cSlotID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nPotenID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_NEW_HENNA_POTEN_SELECT(out _S_EX_NEW_HENNA_POTEN_SELECT packet)
{
	// End:0x17
	if(!DecodeChar(packet.cSlotID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPotenID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeShort(packet.nActiveStep))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeChar(packet.cSuccess))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_NEW_HENNA_POTEN_ENCHANT(out array<byte> stream, _C_EX_NEW_HENNA_POTEN_ENCHANT packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cSlotID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.costItemID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_NEW_HENNA_POTEN_ENCHANT(out _S_EX_NEW_HENNA_POTEN_ENCHANT packet)
{
	// End:0x17
	if(!DecodeChar(packet.cSlotID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.nEnchantStep))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nEnchantExp))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeShort(packet.nDailyStep))
	{
		return false;
	}
	// End:0x73
	if(!DecodeShort(packet.nDailyCount))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeShort(packet.nActiveStep))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeChar(packet.cSuccess))
	{
		return false;
	}
	// End:0xB8
	if(!DecodeShort(packet.nSlotDailyStep))
	{
		return false;
	}
	// End:0xCF
	if(!DecodeShort(packet.nSlotDailyCount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_NEW_HENNA_COMPOSE(out array<byte> stream, _C_EX_NEW_HENNA_COMPOSE packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nSlotOneIndex))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nSlotOneItemID))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nSlotTwoItemID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_NEW_HENNA_COMPOSE(out _S_EX_NEW_HENNA_COMPOSE packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResultHennaID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nResultItemID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cSuccess))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQUEST_INVITE_PARTY(out array<byte> stream, _C_EX_REQUEST_INVITE_PARTY packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cReqType))
	{
		return false;
	}
	// End:0x38
	if(!EncodeChar(stream, packet.cSayType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_REQUEST_INVITE_PARTY(out _S_EX_REQUEST_INVITE_PARTY packet)
{
	// End:0x18
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeChar(packet.cReqType))
	{
		return false;
	}
	// End:0x46
	if(!DecodeChar(packet.cSayType))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeChar(packet.cCharRankGrade))
	{
		return false;
	}
	// End:0x74
	if(!DecodeChar(packet.cPledgeCastleDBID))
	{
		return false;
	}
	// End:0x8B
	if(!DecodeChar(packet.cEventEmblemID))
	{
		return false;
	}
	// End:0xA2
	if(!DecodeInt(packet.nUserSID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_ITEM_USABLE_LIST(out array<byte> stream, _C_EX_ITEM_USABLE_LIST packet)
{
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_INIT_GLOBAL_EVENT_UI(out _S_EX_INIT_GLOBAL_EVENT_UI packet)
{
	local int i, nSize;

	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vEventList.Length = nSize;

	for(i = 0; i < packet.vEventList.Length; i++)
	{
		if(!DecodeInt(packet.vEventList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_SELECT_GLOBAL_EVENT_UI(out array<byte> stream, _C_EX_SELECT_GLOBAL_EVENT_UI packet)
{
	if(!EncodeInt(stream, packet.nEventIndex))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_L2PASS_INFO(out array<byte> stream, _C_EX_L2PASS_INFO packet)
{
	if(!EncodeChar(stream, packet.cPassType))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_L2PASS_REQUEST_REWARD(out array<byte> stream, _C_EX_L2PASS_REQUEST_REWARD packet)
{
	if(!EncodeChar(stream, packet.cPassType))
	{
		return false;
	}
	if(!EncodeBool(stream, packet.bPremium))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_L2PASS_REQUEST_REWARD_ALL(out array<byte> stream, _C_EX_L2PASS_REQUEST_REWARD_ALL packet)
{
	if(!EncodeChar(stream, packet.cPassType))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_L2PASS_BUY_PREMIUM(out array<byte> stream, _C_EX_L2PASS_BUY_PREMIUM packet)
{
	if(!EncodeChar(stream, packet.cPassType))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_SAYHAS_SUPPORT_TOGGLE(out array<byte> stream, _C_EX_SAYHAS_SUPPORT_TOGGLE packet)
{
	if(!EncodeBool(stream, packet.bIsOn))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkL2PassInfo(out _PkL2PassInfo packet)
{
	if(!DecodeChar(packet.cPassType))
	{
		return false;
	}
	if(!DecodeBool(packet.bIsOn))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_L2PASS_SIMPLE_INFO(out _S_EX_L2PASS_SIMPLE_INFO packet)
{
	local int i, nSize;

	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.passInfos.Length = nSize;

	for(i = 0; i < packet.passInfos.Length; i++)
	{
		if(!Decode_PkL2PassInfo(packet.passInfos[i]))
		{
			return false;
		}
	}
	if(!DecodeBool(packet.bAvailableReward))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.condIndex.Length = nSize;

	for(i = 0; i < packet.condIndex.Length; i++)
	{
		if(!DecodeInt(packet.condIndex[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_L2PASS_INFO(out _S_EX_L2PASS_INFO packet)
{
	if(!DecodeChar(packet.cPassType))
	{
		return false;
	}
	if(!DecodeInt(packet.nLeftTime))
	{
		return false;
	}
	if(!DecodeBool(packet.bIsPremium))
	{
		return false;
	}
	if(!DecodeInt(packet.nCurCount))
	{
		return false;
	}
	if(!DecodeInt(packet.nCurStep))
	{
		return false;
	}
	if(!DecodeInt(packet.nRewardStep))
	{
		return false;
	}
	if(!DecodeInt(packet.nPremiumRewardStep))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SAYHAS_SUPPORT_INFO(out _S_EX_SAYHAS_SUPPORT_INFO packet)
{
	if(!DecodeBool(packet.bIsOn))
	{
		return false;
	}
	if(!DecodeInt(packet.nTimeEarned))
	{
		return false;
	}
	if(!DecodeInt(packet.nTimeUsed))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQ_VIEW_ENCHANT_RESULT(out array<byte> stream, _C_EX_REQ_VIEW_ENCHANT_RESULT packet)
{
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQ_ENCHANT_FAIL_REWARD_INFO(out array<byte> stream, _C_EX_REQ_ENCHANT_FAIL_REWARD_INFO packet)
{
	if(!EncodeInt(stream, packet.nItemServerId))
	{
		return false;
	}
	return true;
}

static function bool Decode_EnchantRewardItem(out _EnchantRewardItem packet)
{
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	if(!DecodeInt(packet.nCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RES_ENCHANT_ITEM_FAIL_REWARD_INFO(out _S_EX_RES_ENCHANT_ITEM_FAIL_REWARD_INFO packet)
{
	local int i, nSize;

	if(!DecodeInt(packet.nItemServerId))
	{
		return false;
	}
	if(!DecodeInt(packet.nEnchantChallengePointGroupId))
	{
		return false;
	}
	if(!DecodeInt(packet.nEnchantChallengePoint))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vRewardItemList.Length = nSize;

	for(i = 0; i < packet.vRewardItemList.Length; i++)
	{
		if(!Decode_EnchantRewardItem(packet.vRewardItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_EnchantProbInfo(out _EnchantProbInfo packet)
{
	if(!DecodeInt(packet.nItemServerId))
	{
		return false;
	}
	if(!DecodeInt(packet.nTotalSuccessProbPermyriad))
	{
		return false;
	}
	if(!DecodeInt(packet.nBaseProbPermyriad))
	{
		return false;
	}
	if(!DecodeInt(packet.nSupportProbPermyriad))
	{
		return false;
	}
	if(!DecodeInt(packet.nItemSkillProbPermyriad))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST(out _S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vProbList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.vProbList.Length; i++)
	{
		// End:0x5C
		if(!Decode_EnchantProbInfo(packet.vProbList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_EnchantChallengePointInfo(out _EnchantChallengePointInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPointGroupId))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nChallengePoint))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nTicketPointOpt1))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nTicketPointOpt2))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nTicketPointOpt3))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nTicketPointOpt4))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeInt(packet.nTicketPointOpt5))
	{
		return false;
	}
	// End:0xB8
	if(!DecodeInt(packet.nTicketPointOpt6))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ENCHANT_CHALLENGE_POINT_INFO(out _S_EX_ENCHANT_CHALLENGE_POINT_INFO packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vCurrentPointInfo.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.vCurrentPointInfo.Length; i++)
	{
		// End:0x5C
		if(!Decode_EnchantChallengePointInfo(packet.vCurrentPointInfo[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_SET_ENCHANT_CHALLENGE_POINT(out array<byte> stream, _C_EX_SET_ENCHANT_CHALLENGE_POINT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nUseType))
	{
		return false;
	}
	// End:0x38
	if(!EncodeBool(stream, packet.bUseTicket))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SET_ENCHANT_CHALLENGE_POINT(out _S_EX_SET_ENCHANT_CHALLENGE_POINT packet)
{
	// End:0x17
	if(!DecodeBool(packet.bResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_RESET_ENCHANT_CHALLENGE_POINT(out array<byte> stream, _C_EX_RESET_ENCHANT_CHALLENGE_POINT packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RESET_ENCHANT_CHALLENGE_POINT(out _S_EX_RESET_ENCHANT_CHALLENGE_POINT packet)
{
	// End:0x17
	if(!DecodeBool(packet.bResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQ_START_MULTI_ENCHANT_SCROLL(out array<byte> stream, _C_EX_REQ_START_MULTI_ENCHANT_SCROLL packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nScrollItemSid))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT(out array<byte> stream, _C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL(out array<byte> stream, _C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQ_CHANGE_MULTI_ENCHANT_SCROLL(out array<byte> stream, _C_EX_REQ_CHANGE_MULTI_ENCHANT_SCROLL packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nScrollItemSid))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RES_SELECT_MULTI_ENCHANT_SCROLL(out _S_EX_RES_SELECT_MULTI_ENCHANT_SCROLL packet)
{
	// End:0x17
	if(!DecodeInt(packet.nScrollItemSid))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST(out array<byte> stream, _C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST packet)
{
	local int i;

	// End:0x1D
	if(!EncodeInt(stream, packet.vEnchantItemList.Length))
	{
		return false;
	}

	// End:0x65 [Loop If]
	for(i = 0; i < packet.vEnchantItemList.Length; i++)
	{
		// End:0x5B
		if(!EncodeInt(stream, packet.vEnchantItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_RES_SET_MULTI_ENCHANT_ITEM_LIST(out _S_EX_RES_SET_MULTI_ENCHANT_ITEM_LIST packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQ_MULTI_ENCHANT_ITEM_LIST(out array<byte> stream, _C_EX_REQ_MULTI_ENCHANT_ITEM_LIST packet)
{
	local int i;

	// End:0x1C
	if(!EncodeBool(stream, packet.bUseLateAnnounce))
	{
		return false;
	}
	// End:0x39
	if(!EncodeInt(stream, packet.vEnchantItemList.Length))
	{
		return false;
	}

	// End:0x81 [Loop If]
	for(i = 0; i < packet.vEnchantItemList.Length; i++)
	{
		// End:0x77
		if(!EncodeInt(stream, packet.vEnchantItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_EnchantSuccessItem(out _EnchantSuccessItem packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemSid))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nFinalEnchanted))
	{
		return false;
	}
	return true;
}

static function bool Decode_EnchantFailItem(out _EnchantFailItem packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemSid))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nEnchanted))
	{
		return false;
	}
	return true;
}

static function bool Decode_EnchantFailRewardItem(out _EnchantFailRewardItem packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nItemCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_EnchantFailChallengePointInfo(out _EnchantFailChallengePointInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nGroupID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nChallengePoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RES_MULTI_ENCHANT_ITEM_LIST(out _S_EX_RES_MULTI_ENCHANT_ITEM_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeBool(packet.bResult))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vSuccessItemList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.vSuccessItemList.Length; i++)
	{
		// End:0x73
		if(!Decode_EnchantSuccessItem(packet.vSuccessItemList[i]))
		{
			return false;
		}
	}
	// End:0x8F
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vFailedItemList.Length = nSize;

	// End:0xE3 [Loop If]
	for(i = 0; i < packet.vFailedItemList.Length; i++)
	{
		// End:0xD9
		if(!Decode_EnchantFailItem(packet.vFailedItemList[i]))
		{
			return false;
		}
	}
	// End:0xF5
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vFailRewardItemList.Length = nSize;

	// End:0x149 [Loop If]
	for(i = 0; i < packet.vFailRewardItemList.Length; i++)
	{
		// End:0x13F
		if(!Decode_EnchantFailRewardItem(packet.vFailRewardItemList[i]))
		{
			return false;
		}
	}
	// End:0x15B
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vFailChallengePointInfoList.Length = nSize;

	// End:0x1AF [Loop If]
	for(i = 0; i < packet.vFailChallengePointInfoList.Length; i++)
	{
		// End:0x1A5
		if(!Decode_EnchantFailChallengePointInfo(packet.vFailChallengePointInfoList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_SUPPORT_PLEDGE_FLAG_SET(out array<byte> stream, _C_EX_WORLDCASTLEWAR_SUPPORT_PLEDGE_FLAG_SET packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nType))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nUseSupporterPledgeFlag))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_SUPPORT_PLEDGE_INFO_SET(out array<byte> stream, _C_EX_WORLDCASTLEWAR_SUPPORT_PLEDGE_INFO_SET packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nType))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nSupportPledgeSID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_ALL_RANKING_INFO(out array<byte> stream, _C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_ALL_RANKING_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Decode_WorldCastleWar_SupportPledge_RankingInfo(out _WorldCastleWar_SupportPledge_RankingInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt64(packet.nSiegePoint))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeInt64(packet.nTotalSiegePoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_HOST_SUPPORT_PLEDGE_RANKING_INFO(out _S_EX_WORLDCASTLEWAR_HOST_SUPPORT_PLEDGE_RANKING_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cPacketIndex))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.nTotalCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x57
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstSupportPledgeRankingInfo.Length = nSize;

	// End:0xAB [Loop If]
	for(i = 0; i < packet.lstSupportPledgeRankingInfo.Length; i++)
	{
		// End:0xA1
		if(!Decode_WorldCastleWar_SupportPledge_RankingInfo(packet.lstSupportPledgeRankingInfo[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_WorldCastleWar_Pledge_RankingInfo(out _WorldCastleWar_Pledge_RankingInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt64(packet.nSiegePoint))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeWString(packet.sSupportPledgeName, true))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_HOST_PLEDGE_RANKING_INFO(out _S_EX_WORLDCASTLEWAR_HOST_PLEDGE_RANKING_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cPacketIndex))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.nTotalCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x57
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstPledgeRankingInfo.Length = nSize;

	// End:0xAB [Loop If]
	for(i = 0; i < packet.lstPledgeRankingInfo.Length; i++)
	{
		// End:0xA1
		if(!Decode_WorldCastleWar_Pledge_RankingInfo(packet.lstPledgeRankingInfo[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_WorldCastleWar_Personal_RankingInfo(out _WorldCastleWar_Personal_RankingInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt64(packet.nSiegePoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_HOST_PERSONAL_RANKING_INFO(out _S_EX_WORLDCASTLEWAR_HOST_PERSONAL_RANKING_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cPacketIndex))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.nTotalCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x57
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstPersonalRankingInfo.Length = nSize;

	// End:0xAB [Loop If]
	for(i = 0; i < packet.lstPersonalRankingInfo.Length; i++)
	{
		// End:0xA1
		if(!Decode_WorldCastleWar_Personal_RankingInfo(packet.lstPersonalRankingInfo[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ALL_RANKING_INFO(out array<byte> stream, _C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ALL_RANKING_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_SUPPORT_PLEDGE_RANKING_INFO(out _S_EX_WORLDCASTLEWAR_SUPPORT_PLEDGE_RANKING_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cPacketIndex))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.nTotalCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x57
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstSupportPledgeRankingInfo.Length = nSize;

	// End:0xAB [Loop If]
	for(i = 0; i < packet.lstSupportPledgeRankingInfo.Length; i++)
	{
		// End:0xA1
		if(!Decode_WorldCastleWar_SupportPledge_RankingInfo(packet.lstSupportPledgeRankingInfo[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_PLEDGE_RANKING_INFO(out _S_EX_WORLDCASTLEWAR_PLEDGE_RANKING_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cPacketIndex))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.nTotalCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nMyPledgeRank))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt64(packet.nMyPledgeSiegePoint))
	{
		return false;
	}
	// End:0x85
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstPledgeRankingInfo.Length = nSize;

	// End:0xD9 [Loop If]
	for(i = 0; i < packet.lstPledgeRankingInfo.Length; i++)
	{
		// End:0xCF
		if(!Decode_WorldCastleWar_Pledge_RankingInfo(packet.lstPledgeRankingInfo[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_PERSONAL_RANKING_INFO(out _S_EX_WORLDCASTLEWAR_PERSONAL_RANKING_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cPacketIndex))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeShort(packet.nTotalCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nMyRank))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt64(packet.nMySiegePoint))
	{
		return false;
	}
	// End:0x85
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstPersonalRankingInfo.Length = nSize;

	// End:0xD9 [Loop If]
	for(i = 0; i < packet.lstPersonalRankingInfo.Length; i++)
	{
		// End:0xCF
		if(!Decode_WorldCastleWar_Personal_RankingInfo(packet.lstPersonalRankingInfo[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_REQ_HOMUNCULUS_PROB_LIST(out array<byte> stream, _C_EX_REQ_HOMUNCULUS_PROB_LIST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.nType))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nSlotItemClassId))
	{
		return false;
	}
	return true;
}

static function bool Decode_HomunculusProbData(out _HomunculusProbData packet)
{
	// End:0x17
	if(!DecodeInt(packet.nIndex))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nProbPerMillion))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HOMUNCULUS_CREATE_PROB_LIST(out _S_EX_HOMUNCULUS_CREATE_PROB_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstHomunculusProbList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.lstHomunculusProbList.Length; i++)
	{
		// End:0x5C
		if(!Decode_HomunculusProbData(packet.lstHomunculusProbList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_HOMUNCULUS_COUPON_PROB_LIST(out _S_EX_HOMUNCULUS_COUPON_PROB_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nSlotItemClassId))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstHomunculusProbList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.lstHomunculusProbList.Length; i++)
	{
		// End:0x73
		if(!Decode_HomunculusProbData(packet.lstHomunculusProbList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO(out array<byte> stream, _C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Decode_WorldCastleWar_RankingInfo(out _WorldCastleWar_RankingInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt64(packet.nSiegePoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO(out _S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstPledgeRankingList.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet.lstPledgeRankingList.Length; i++)
	{
		// End:0x73
		if(!Decode_WorldCastleWar_RankingInfo(packet.lstPledgeRankingList[i]))
		{
			return false;
		}
	}
	// End:0x8F
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstPersonalRankingList.Length = nSize;

	// End:0xE3 [Loop If]
	for(i = 0; i < packet.lstPersonalRankingList.Length; i++)
	{
		// End:0xD9
		if(!Decode_WorldCastleWar_RankingInfo(packet.lstPersonalRankingList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO(out array<byte> stream, _C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nCastleID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO(out _S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nCastleID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nMyPledgeRank))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nMyPledgeSiegePoint))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nMyRank))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt64(packet.nMySiegePoint))
	{
		return false;
	}
	// End:0x85
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstPledgeRankingList.Length = nSize;

	// End:0xD9 [Loop If]
	for(i = 0; i < packet.lstPledgeRankingList.Length; i++)
	{
		// End:0xCF
		if(!Decode_WorldCastleWar_RankingInfo(packet.lstPledgeRankingList[i]))
		{
			return false;
		}
	}
	// End:0xEB
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lstPersonalRankingList.Length = nSize;

	// End:0x13F [Loop If]
	for(i = 0; i < packet.lstPersonalRankingList.Length; i++)
	{
		// End:0x135
		if(!Decode_WorldCastleWar_RankingInfo(packet.lstPersonalRankingList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_PkMissionLevelReward(out _PkMissionLevelReward packet)
{
	// End:0x17
	if(!DecodeInt(packet.nType))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nState))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_MISSION_LEVEL_REWARD_LIST(out _S_EX_MISSION_LEVEL_REWARD_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rewards.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.rewards.Length; i++)
	{
		// End:0x5C
		if(!Decode_PkMissionLevelReward(packet.rewards[i]))
		{
			return false;
		}
	}
	// End:0x7D
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	// End:0x94
	if(!DecodeInt(packet.nPointPercent))
	{
		return false;
	}
	// End:0xAB
	if(!DecodeInt(packet.nSeasonYear))
	{
		return false;
	}
	// End:0xC2
	if(!DecodeInt(packet.nSeasonMonth))
	{
		return false;
	}
	// End:0xD9
	if(!DecodeInt(packet.nTotalRewardsAvailable))
	{
		return false;
	}
	// End:0xF0
	if(!DecodeInt(packet.nExtraRewardsAvailable))
	{
		return false;
	}
	// End:0x107
	if(!DecodeInt(packet.nRemainSeasonTime))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_MISSION_LEVEL_RECEIVE_REWARD(out array<byte> stream, _C_EX_MISSION_LEVEL_RECEIVE_REWARD packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nLevel))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nRewardType))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_BALROGWAR_TELEPORT(out array<byte> stream, _C_EX_BALROGWAR_TELEPORT packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_BALROGWAR_SHOW_UI(out array<byte> stream, _C_EX_BALROGWAR_SHOW_UI packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_BALROGWAR_SHOW_UI(out _S_EX_BALROGWAR_SHOW_UI packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPersonalPoint))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nTotalPoint))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRewardState))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nRewardItemID))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt64(packet.nRewardAmount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_BALROGWAR_SHOW_RANKING(out array<byte> stream, _C_EX_BALROGWAR_SHOW_RANKING packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkBalrogWarRanking(out _PkBalrogWarRanking packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeWString(packet.sName, true))
	{
		return false;
	}
	// End:0x46
	if(!DecodeInt(packet.nPoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_BALROGWAR_SHOW_RANKING(out _S_EX_BALROGWAR_SHOW_RANKING packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rankingList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.rankingList.Length; i++)
	{
		// End:0x5C
		if(!Decode_PkBalrogWarRanking(packet.rankingList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_BALROGWAR_GET_REWARD(out array<byte> stream, _C_EX_BALROGWAR_GET_REWARD packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_BALROGWAR_GET_REWARD(out _S_EX_BALROGWAR_GET_REWARD packet)
{
	// End:0x17
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_BALROGWAR_HUD(out _S_EX_BALROGWAR_HUD packet)
{
	// End:0x17
	if(!DecodeInt(packet.nState))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nProgressStep))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nLeftTime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_BALROGWAR_BOSSINFO(out _S_EX_BALROGWAR_BOSSINFO packet)
{
	local int i;

	// End:0x3A [Loop If]
	for(i = 0; i < 5; i++)
	{
		// End:0x30
		if(!DecodeInt(packet.nMidBossClassID[i]))
		{
			return false;
		}
	}

	// End:0x74 [Loop If]
	for(i = 0; i < 5; i++)
	{
		// End:0x6A
		if(!DecodeInt(packet.nMidBossState[i]))
		{
			return false;
		}
	}
	// End:0x8B
	if(!DecodeInt(packet.nFinalBossClassID))
	{
		return false;
	}
	// End:0xA2
	if(!DecodeInt(packet.nFinalBossState))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkUserRestartLocker(out _PkUserRestartLocker packet)
{
	// End:0x17
	if(!DecodeInt(packet.nRestartPoint))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nClassID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeBool(packet.bLocked))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_USER_RESTART_LOCKER_LIST(out _S_EX_USER_RESTART_LOCKER_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeBool(packet.bExpDown))
	{
		return false;
	}
	// End:0x29
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet._lockers.Length = nSize;

	// End:0x7D [Loop If]
	for(i = 0; i < packet._lockers.Length; i++)
	{
		// End:0x73
		if(!Decode_PkUserRestartLocker(packet._lockers[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_USER_RESTART_LOCKER_UPDATE(out array<byte> stream, _C_EX_USER_RESTART_LOCKER_UPDATE packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nRestartPoint))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nClassID))
	{
		return false;
	}
	// End:0x54
	if(!EncodeBool(stream, packet.bLocked))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_USER_RESTART_LOCKER_UPDATE(out _S_EX_USER_RESTART_LOCKER_UPDATE packet)
{
	// End:0x17
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLD_EXCHANGE_ITEM_LIST(out array<byte> stream, _C_EX_WORLD_EXCHANGE_ITEM_LIST packet)
{
	local int i;

	// End:0x1C
	if(!EncodeShort(stream, packet.nCategory))
	{
		return false;
	}
	// End:0x38
	if(!EncodeChar(stream, packet.cSortType))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nPage))
	{
		return false;
	}
	// End:0x71
	if(!EncodeInt(stream, packet.vItemIDList.Length))
	{
		return false;
	}

	// End:0xB9 [Loop If]
	for(i = 0; i < packet.vItemIDList.Length; i++)
	{
		// End:0xAF
		if(!EncodeInt(stream, packet.vItemIDList[i]))
		{
			return false;
		}
	}
	if (!EncodeInt(stream, packet.cType))
	{
		return false;
	}
	return true;
}

static function bool Decode_WorldExchangeItemData(out _WorldExchangeItemData packet)
{
	local int i;

	// End:0x17
	if(!DecodeInt64(packet.nWEIndex))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nPrice))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nExpiredTime))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	// End:0x8A
	if(!DecodeInt(packet.nEnchant))
	{
		return false;
	}
	// End:0xA1
	if(!DecodeInt(packet.nVariationOpt1))
	{
		return false;
	}
	// End:0xB8
	if(!DecodeInt(packet.nVariationOpt2))
	{
		return false;
	}
	// End:0xCF
	if(!DecodeInt(packet.nIntensiveItemClassID))
	{
		return false;
	}
	// End:0xE6
	if(!DecodeShort(packet.nBaseAttributeAttackType))
	{
		return false;
	}
	// End:0xFD
	if(!DecodeShort(packet.nBaseAttributeAttackValue))
	{
		return false;
	}

	// End:0x137 [Loop If]
	for(i = 0; i < 6; i++)
	{
		// End:0x12D
		if(!DecodeShort(packet.nBaseAttributeDefendValue[i]))
		{
			return false;
		}
	}
	// End:0x14E
	if(!DecodeInt(packet.nShapeShiftingClassId))
	{
		return false;
	}

	// End:0x188 [Loop If]
	for(i = 0; i < 3; i++)
	{
		// End:0x17E
		if(!DecodeInt(packet.nEsoulOption[i]))
		{
			return false;
		}
	}
	// End:0x19F
	if(!DecodeShort(packet.nBlessOption))
	{
		return false;
	}
	if (!DecodeInt(packet.nCurrencyId))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLD_EXCHANGE_ITEM_LIST(out _S_EX_WORLD_EXCHANGE_ITEM_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeShort(packet.nCategory))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cSortType))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nPage))
	{
		return false;
	}
	// End:0x57
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vItemDataList.Length = nSize;

	// End:0xAB [Loop If]
	for(i = 0; i < packet.vItemDataList.Length; i++)
	{
		// End:0xA1
		if(!Decode_WorldExchangeItemData(packet.vItemDataList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_WORLD_EXCHANGE_REGI_ITEM(out array<byte> stream, _C_EX_WORLD_EXCHANGE_REGI_ITEM packet)
{
	// End:0x1C
	if(!EncodeInt64(stream, packet.nPrice))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nItemSid))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt64(stream, packet.nAmount))
	{
		return false;
	}
	if (!EncodeInt(stream, packet.nCurrencyId))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLD_EXCHANGE_REGI_ITEM(out _S_EX_WORLD_EXCHANGE_REGI_ITEM packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cSuccess))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLD_EXCHANGE_BUY_ITEM(out array<byte> stream, _C_EX_WORLD_EXCHANGE_BUY_ITEM packet)
{
	// End:0x1C
	if(!EncodeInt64(stream, packet.nWEIndex))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLD_EXCHANGE_BUY_ITEM(out _S_EX_WORLD_EXCHANGE_BUY_ITEM packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cSuccess))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLD_EXCHANGE_SETTLE_LIST(out array<byte> stream, _C_EX_WORLD_EXCHANGE_SETTLE_LIST packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLD_EXCHANGE_SETTLE_LIST(out _S_EX_WORLD_EXCHANGE_SETTLE_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vRegiItemDataList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.vRegiItemDataList.Length; i++)
	{
		// End:0x5C
		if(!Decode_WorldExchangeItemData(packet.vRegiItemDataList[i]))
		{
			return false;
		}
	}
	// End:0x78
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vRecvItemDataList.Length = nSize;

	// End:0xCC [Loop If]
	for(i = 0; i < packet.vRecvItemDataList.Length; i++)
	{
		// End:0xC2
		if(!Decode_WorldExchangeItemData(packet.vRecvItemDataList[i]))
		{
			return false;
		}
	}
	// End:0xDE
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vTimeOutItemDataList.Length = nSize;

	// End:0x132 [Loop If]
	for(i = 0; i < packet.vTimeOutItemDataList.Length; i++)
	{
		// End:0x128
		if(!Decode_WorldExchangeItemData(packet.vTimeOutItemDataList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT(out array<byte> stream, _C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT packet)
{
	// End:0x1C
	if(!EncodeInt64(stream, packet.nWEIndex))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT(out _S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cSuccess))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM(out _S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_READY_ITEM_AUTO_PEEL(out array<byte> stream, _C_EX_READY_ITEM_AUTO_PEEL packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemSid))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_READY_ITEM_AUTO_PEEL(out _S_EX_READY_ITEM_AUTO_PEEL packet)
{
	// End:0x17
	if(!DecodeBool(packet.bResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nItemSid))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_STOP_ITEM_AUTO_PEEL(out array<byte> stream, _C_EX_STOP_ITEM_AUTO_PEEL packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_STOP_ITEM_AUTO_PEEL(out _S_EX_STOP_ITEM_AUTO_PEEL packet)
{
	// End:0x17
	if(!DecodeBool(packet.bResult))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQUEST_ITEM_AUTO_PEEL(out array<byte> stream, _C_EX_REQUEST_ITEM_AUTO_PEEL packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemSid))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt64(stream, packet.nTotalPeelCount))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt64(stream, packet.nRemainPeelCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_AutoPeelResultItem(out _AutoPeelResultItem packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.AnnounceLevel))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RESULT_ITEM_AUTO_PEEL(out _S_EX_RESULT_ITEM_AUTO_PEEL packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeBool(packet.bResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nTotalPeelCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nRemainPeelCount))
	{
		return false;
	}
	// End:0x57
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vResultItemList.Length = nSize;

	// End:0xAB [Loop If]
	for(i = 0; i < packet.vResultItemList.Length; i++)
	{
		// End:0xA1
		if(!Decode_AutoPeelResultItem(packet.vResultItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_TIME_RESTRICT_FIELD_DIE_LIMT_TIME(out _S_EX_TIME_RESTRICT_FIELD_DIE_LIMT_TIME packet)
{
	// End:0x17
	if(!DecodeInt(packet.nDieLimitTime))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_VARIATION_OPEN_UI(out array<byte> stream, _C_EX_VARIATION_OPEN_UI packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_VARIATION_CLOSE_UI(out array<byte> stream, _C_EX_VARIATION_CLOSE_UI packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_APPLY_VARIATION_OPTION(out array<byte> stream, _C_EX_APPLY_VARIATION_OPTION packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nVariationItemSID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nItemOption1))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nItemOption2))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_APPLY_VARIATION_OPTION(out _S_EX_APPLY_VARIATION_OPTION packet)
{
	// End:0x17
	if(!DecodeBool(packet.bResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nVariationItemSID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nItemOption1))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nItemOption2))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_REQUEST_AUDIO_LOG_SAVE(out array<byte> stream, _C_EX_REQUEST_AUDIO_LOG_SAVE packet)
{
	// End:0x1D
	if(!EncodeWString(stream, packet.sZoneName, true))
	{
		return false;
	}
	// End:0x39
	if(!EncodeBool(stream, packet.bAudioMuteOn))
	{
		return false;
	}
	// End:0x55
	if(!EncodeBool(stream, packet.bAudioFocusOn))
	{
		return false;
	}
	// End:0x71
	if(!EncodeChar(stream, packet.cSoundVolume))
	{
		return false;
	}
	// End:0x8D
	if(!EncodeChar(stream, packet.cMusicVolume))
	{
		return false;
	}
	// End:0xA9
	if(!EncodeChar(stream, packet.cNotifySoundVolume))
	{
		return false;
	}
	// End:0xC5
	if(!EncodeChar(stream, packet.cEffectVolume))
	{
		return false;
	}
	// End:0xE1
	if(!EncodeChar(stream, packet.cAmbientVolume))
	{
		return false;
	}
	// End:0xFD
	if(!EncodeChar(stream, packet.cSystemVoiceVolume))
	{
		return false;
	}
	// End:0x119
	if(!EncodeChar(stream, packet.cNpcVoiceVolume))
	{
		return false;
	}
	// End:0x135
	if(!EncodeBool(stream, packet.bTutorialVoiceBox))
	{
		return false;
	}
	// End:0x151
	if(!EncodeChar(stream, packet.cDeviceVolume))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_REQUEST_AUDIO_LOG_SAVE(out _S_EX_REQUEST_AUDIO_LOG_SAVE packet)
{
	// End:0x17
	if(!DecodeChar(packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WRANKING_FESTIVAL_INFO(out array<byte> stream, _C_EX_WRANKING_FESTIVAL_INFO packet)
{
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_WRFRankingRewardInfo(out _WRFRankingRewardInfo packet)
{
	if(!DecodeInt(packet.nStartRank))
	{
		return false;
	}
	if(!DecodeInt(packet.nEndRank))
	{
		return false;
	}
	if(!DecodeInt(packet.nRewardItemClassId))
	{
		return false;
	}
	if(!DecodeInt64(packet.nRewardItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_WRFBonusInfo(out _WRFBonusInfo packet)
{
	if(!DecodeInt(packet.nPoint))
	{
		return false;
	}
	if(!DecodeInt(packet.nRewardItemClassId))
	{
		return false;
	}
	if(!DecodeInt64(packet.nRewardItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_WRFBuyItemInfo(out _WRFBuyItemInfo packet)
{
	if(!DecodeInt(packet.nBuyId))
	{
		return false;
	}
	if(!DecodeInt(packet.nType))
	{
		return false;
	}
	if(!DecodeBool(packet.bSale))
	{
		return false;
	}
	if(!DecodeInt(packet.nBuyItemClassId))
	{
		return false;
	}
	if(!DecodeInt64(packet.nBuyItemAmount))
	{
		return false;
	}
	if(!DecodeInt(packet.nCostItemClassID))
	{
		return false;
	}
	if(!DecodeInt64(packet.nCostItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_WRFBuffInfo(out _WRFBuffInfo packet)
{
	if(!DecodeInt(packet.nRankId))
	{
		return false;
	}
	if(!DecodeInt(packet.nBuffSkillId))
	{
		return false;
	}
	if(!DecodeInt(packet.nBuffSkillLv))
	{
		return false;
	}
	if(!DecodeInt(packet.nMinBuffLv))
	{
		return false;
	}
	if(!DecodeInt(packet.nMaxBuffLv))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WRANKING_FESTIVAL_INFO(out _S_EX_WRANKING_FESTIVAL_INFO packet)
{
	local int i, nSize;

	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	if(!DecodeInt(packet.nCostType))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rankingRewardInfos.Length = nSize;

	for(i = 0; i < packet.rankingRewardInfos.Length; i++)
	{
		if(!Decode_WRFRankingRewardInfo(packet.rankingRewardInfos[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.bonusInfos.Length = nSize;

	for(i = 0; i < packet.bonusInfos.Length; i++)
	{
		if(!Decode_WRFBonusInfo(packet.bonusInfos[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.buyItemInfos.Length = nSize;

	for(i = 0; i < packet.buyItemInfos.Length; i++)
	{
		if(!Decode_WRFBuyItemInfo(packet.buyItemInfos[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.buffInfos.Length = nSize;

	for(i = 0; i < packet.buffInfos.Length; i++)
	{
		if(!Decode_WRFBuffInfo(packet.buffInfos[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_WRFRankingInfo(out _WRFRankingInfo packet)
{
	if(!DecodeInt(packet.nRank))
	{
		return false;
	}
	if(!DecodeInt(packet.nWorldID))
	{
		return false;
	}
	if(!DecodeWString(packet.charName, true))
	{
		return false;
	}
	if(!DecodeInt(packet.nBuyCount))
	{
		return false;
	}
	if(!DecodeInt(packet.nAnonymity))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WRANKING_FESTIVAL_SIDEBAR_INFO(out _S_EX_WRANKING_FESTIVAL_SIDEBAR_INFO packet)
{
	local int i, nSize;

	if(!DecodeBool(packet.bShowEvent))
	{
		return false;
	}
	if(!DecodeBool(packet.bOnEvent))
	{
		return false;
	}
	if(!DecodeInt64(packet.nEndSeconds))
	{
		return false;
	}
	if(!DecodeInt64(packet.nFinishSeconds))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rankingInfos.Length = nSize;

	for(i = 0; i < packet.rankingInfos.Length; i++)
	{
		if(!Decode_WRFRankingInfo(packet.rankingInfos[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_WRANKING_FESTIVAL_OPEN(out array<byte> stream, _C_EX_WRANKING_FESTIVAL_OPEN packet)
{
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WRANKING_FESTIVAL_BUY(out array<byte> stream, _C_EX_WRANKING_FESTIVAL_BUY packet)
{
	if(!EncodeInt(stream, packet.nBuyId))
	{
		return false;
	}
	if(!EncodeInt(stream, packet.nBuyCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WRANKING_FESTIVAL_BUY(out _S_EX_WRANKING_FESTIVAL_BUY packet)
{
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WRANKING_FESTIVAL_BONUS(out array<byte> stream, _C_EX_WRANKING_FESTIVAL_BONUS packet)
{
	local int i;

	if(!EncodeInt(stream, packet.nPoints.Length))
	{
		return false;
	}

	for(i = 0; i < packet.nPoints.Length; i++)
	{
		if(!EncodeInt(stream, packet.nPoints[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_WRANKING_FESTIVAL_BONUS(out _S_EX_WRANKING_FESTIVAL_BONUS packet)
{
	local int i, nSize;

	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.nPoints.Length = nSize;

	for(i = 0; i < packet.nPoints.Length; i++)
	{
		if(!DecodeInt(packet.nPoints[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_WRANKING_FESTIVAL_RANKING(out array<byte> stream, _C_EX_WRANKING_FESTIVAL_RANKING packet)
{
	if(!EncodeInt(stream, packet.nRankingType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WRANKING_FESTIVAL_RANKING(out _S_EX_WRANKING_FESTIVAL_RANKING packet)
{
	local int i, nSize;

	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	if(!DecodeInt(packet.nRankingType))
	{
		return false;
	}
	if(!DecodeInt(packet.nMyRanking))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rankingInfos.Length = nSize;

	for(i = 0; i < packet.rankingInfos.Length; i++)
	{
		if(!Decode_WRFRankingInfo(packet.rankingInfos[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_WRANKING_FESTIVAL_MYINFO(out _S_EX_WRANKING_FESTIVAL_MYINFO packet)
{
	if(!DecodeInt(packet.nMyRanking))
	{
		return false;
	}
	if(!DecodeInt(packet.nTotalBuyCount))
	{
		return false;
	}
	if(!DecodeBool(packet.bReceiveReward))
	{
		return false;
	}
	if(!DecodeInt(packet.nCostId))
	{
		return false;
	}
	if(!DecodeInt(packet.nCostCount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WRANKING_FESTIVAL_MY_RECEIVED_BONUS(out array<byte> stream, _C_EX_WRANKING_FESTIVAL_MY_RECEIVED_BONUS packet)
{
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WRANKING_FESTIVAL_MY_RECEIVED_BONUS(out _S_EX_WRANKING_FESTIVAL_MY_RECEIVED_BONUS packet)
{
	local int i, nSize;

	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.receivedPoints.Length = nSize;

	for(i = 0; i < packet.receivedPoints.Length; i++)
	{
		if(!DecodeInt(packet.receivedPoints[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_WRANKING_FESTIVAL_REWARD(out array<byte> stream, _C_EX_WRANKING_FESTIVAL_REWARD packet)
{
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WRANKING_FESTIVAL_REWARD(out _S_EX_WRANKING_FESTIVAL_REWARD packet)
{
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	return true;
}

static function bool Decode_ToolTipParamInfo(out _ToolTipParamInfo packet)
{
	local int i, nSize;

	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.nameParams.Length = nSize;

	for(i = 0; i < packet.nameParams.Length; i++)
	{
		if(!DecodeWString(packet.nameParams[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.descParams.Length = nSize;

	for(i = 0; i < packet.descParams.Length; i++)
	{
		if(!DecodeWString(packet.descParams[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_TOOLTIP_PARAM(out _S_EX_TOOLTIP_PARAM packet)
{
	local int i, nSize;

	if(!DecodeInt(packet.nToolTipType))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.ToolTipParamList.Length = nSize;

	for(i = 0; i < packet.ToolTipParamList.Length; i++)
	{
		if(!Decode_ToolTipParamInfo(packet.ToolTipParamList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_SReceivedPost(out _SReceivedPost packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPostID))
	{
		return false;
	}
	// End:0x2F
	if(!DecodeWString(packet.wstrTitle, true))
	{
		return false;
	}
	// End:0x47
	if(!DecodeWString(packet.wstrSenderName, true))
	{
		return false;
	}
	// End:0x5E
	if(!DecodeInt(packet.nSenderType))
	{
		return false;
	}
	// End:0x75
	if(!DecodeInt(packet.nMessageNo))
	{
		return false;
	}
	// End:0x8C
	if(!DecodeInt(packet.nNextJobTime))
	{
		return false;
	}
	// End:0xA3
	if(!DecodeBool(packet.bIsTrade))
	{
		return false;
	}
	// End:0xBA
	if(!DecodeBool(packet.bIsNotOpened))
	{
		return false;
	}
	// End:0xD1
	if(!DecodeBool(packet.bIsReturnable))
	{
		return false;
	}
	// End:0xE8
	if(!DecodeBool(packet.bIsWithItem))
	{
		return false;
	}
	// End:0xFF
	if(!DecodeBool(packet.bIsReturned))
	{
		return false;
	}
	// End:0x116
	if(!DecodeInt(packet.nRecordedId))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_RECEIVED_POST_LIST(out _S_EX_RECEIVED_POST_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cMaxPage))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cCurrentPage))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nNow))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nPostFeeBase))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nPostFeePerItemSlot))
	{
		return false;
	}
	// End:0x85
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.postList.Length = nSize;

	// End:0xD9 [Loop If]
	for(i = 0; i < packet.postList.Length; i++)
	{
		// End:0xCF
		if(!Decode_SReceivedPost(packet.postList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_TIME_RESTRICT_FIELD_ENTER_INFO(out _S_EX_TIME_RESTRICT_FIELD_ENTER_INFO packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vEnterGroupFieldIDList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.vEnterGroupFieldIDList.Length; i++)
	{
		// End:0x5C
		if(!DecodeInt(packet.vEnterGroupFieldIDList[i]))
		{
			return false;
		}
	}
	// End:0x7D
	if(!DecodeBool(packet.bCanUseEntranceTicket))
	{
		return false;
	}
	// End:0x94
	if(!DecodeInt(packet.nEntranceCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLD_EXCHANGE_SETTLE_ALARM(out _S_EX_WORLD_EXCHANGE_SETTLE_ALARM packet)
{
	// End:0x17
	if(!DecodeInt(packet.nCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SHOW_VARIATION_MAKE_WINDOW(out _S_EX_SHOW_VARIATION_MAKE_WINDOW packet)
{
	// End:0x17
	if(!DecodeBool(packet.bIsVariationEventOn))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nGemStoneCountPercent))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nFeeAdenaPercent))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_TRY_TO_MAKE_VARIATION(out array<byte> stream, _C_EX_TRY_TO_MAKE_VARIATION packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemServerId))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nIntensiveItemServerID))
	{
		return false;
	}
	// End:0x54
	if(!EncodeBool(stream, packet.bIsVariationEventOn))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HERO_BOOK_INFO(out _S_EX_HERO_BOOK_INFO packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPoint))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_HERO_BOOK_CHARGE(out array<byte> stream, _C_EX_HERO_BOOK_CHARGE packet)
{
	local int i;

	// End:0x1D
	if(!EncodeInt(stream, packet.Items.Length))
	{
		return false;
	}

	// End:0x65 [Loop If]
	for(i = 0; i < packet.Items.Length; i++)
	{
		// End:0x5B
		if(!Encode_ItemServerInfo(stream, packet.Items[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_HERO_BOOK_CHARGE(out _S_EX_HERO_BOOK_CHARGE packet)
{
	// End:0x17
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HERO_BOOK_ENCHANT(out _S_EX_HERO_BOOK_ENCHANT packet)
{
	// End:0x17
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_TELEPORT_UI(out _S_EX_TELEPORT_UI packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPriceRatio))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_GOODS_GIFT_CHANGED_NOTI(out _S_EX_GOODS_GIFT_CHANGED_NOTI packet)
{
	// End:0x17
	if(!DecodeChar(packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_GOODS_GIFT_LIST_INFO(out array<byte> stream, _C_EX_GOODS_GIFT_LIST_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_SGiftItem(out _SGiftItem packet)
{
	// End:0x17
	if(!DecodeInt(packet.nClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_SGiftInfo(out _SGiftInfo packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nPurchaseId))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nIconId))
	{
		return false;
	}
	// End:0x5D
	if(!DecodeWString(packet.wstrGiftName, true))
	{
		return false;
	}
	// End:0x75
	if(!DecodeWString(packet.wstrSenderName, true))
	{
		return false;
	}
	// End:0x8D
	if(!DecodeWString(packet.wstrGiftDesc, true))
	{
		return false;
	}
	// End:0xA4
	if(!DecodeInt(packet.nRemainTimeSec))
	{
		return false;
	}
	// End:0xB6
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.ItemList.Length = nSize;

	// End:0x10A [Loop If]
	for(i = 0; i < packet.ItemList.Length; i++)
	{
		// End:0x100
		if(!Decode_SGiftItem(packet.ItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_GOODS_GIFT_LIST_INFO(out _S_EX_GOODS_GIFT_LIST_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nTotalPage))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nCurrentPage))
	{
		return false;
	}
	// End:0x57
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.giftList.Length = nSize;

	// End:0xAB [Loop If]
	for(i = 0; i < packet.giftList.Length; i++)
	{
		// End:0xA1
		if(!Decode_SGiftInfo(packet.giftList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_GOODS_GIFT_ACCEPT(out array<byte> stream, _C_EX_GOODS_GIFT_ACCEPT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nPurchaseId))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_GOODS_GIFT_ACCEPT_RESULT(out _S_EX_GOODS_GIFT_ACCEPT_RESULT packet)
{
	// End:0x17
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPurchaseId))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_GOODS_GIFT_REFUSE(out array<byte> stream, _C_EX_GOODS_GIFT_REFUSE packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nPurchaseId))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_GOODS_GIFT_REFUSE_RESULT(out _S_EX_GOODS_GIFT_REFUSE_RESULT packet)
{
	// End:0x17
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPurchaseId))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_NONPVPSERVER_NOTIFY_ACTIVATEFLAG(out _S_EX_NONPVPSERVER_NOTIFY_ACTIVATEFLAG packet)
{
	// End:0x17
	if(!DecodeInt(packet.nPacketType))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nIsActivate))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE(out array<byte> stream, _C_EX_WORLD_EXCHANGE_AVERAGE_PRICE packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLD_EXCHANGE_AVERAGE_PRICE(out _S_EX_WORLD_EXCHANGE_AVERAGE_PRICE packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nAveragePrice))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PRISON_USER_ENTER(out _S_EX_PRISON_USER_ENTER packet)
{
	// End:0x17
	if(!DecodeChar(packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PRISON_USER_EXIT(out _S_EX_PRISON_USER_EXIT packet)
{
	// End:0x17
	if(!DecodeChar(packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PRISON_USER_INFO(out array<byte> stream, _C_EX_PRISON_USER_INFO packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PRISON_USER_INFO(out _S_EX_PRISON_USER_INFO packet)
{
	// End:0x17
	if(!DecodeChar(packet.cPrisonType))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nItemAmount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nRemainTime))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_PRISON_USER_DONATION(out array<byte> stream, _C_EX_PRISON_USER_DONATION packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PRISON_USER_DONATION(out _S_EX_PRISON_USER_DONATION packet)
{
	// End:0x17
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_WORLD_EXCHANGE_TOTAL_LIST(out array<byte> stream, _C_EX_WORLD_EXCHANGE_TOTAL_LIST packet)
{
	local int i;

	// End:0x1D
	if(!EncodeInt(stream, packet.vItemIDList.Length))
	{
		return false;
	}

	// End:0x65 [Loop If]
	for(i = 0; i < packet.vItemIDList.Length; i++)
	{
		// End:0x5B
		if(!EncodeInt(stream, packet.vItemIDList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_WorldExchangeTotalListData(out _WorldExchangeTotalListData packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nMinPricePerPiece))
	{
		return false;
	}
	if (!DecodeInt(packet.nPriceItemId))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nPrice))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_WORLD_EXCHANGE_TOTAL_LIST(out _S_EX_WORLD_EXCHANGE_TOTAL_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.vItemIDList.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.vItemIDList.Length; i++)
	{
		// End:0x5C
		if(!Decode_WorldExchangeTotalListData(packet.vItemIDList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_ITEM_RESTORE_OPEN(out _S_EX_ITEM_RESTORE_OPEN packet)
{
	// End:0x17
	if(!DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_TRADE_LIMIT_INFO(out array<byte> stream, _C_EX_TRADE_LIMIT_INFO packet)
{
	if(!EncodeChar(stream, packet.dummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_FIELD_DIE_LIMT_TIME(out _S_EX_FIELD_DIE_LIMT_TIME packet)
{
	// End:0x17
	if(!DecodeInt(packet.nDieLimitTime))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ELEMENTAL_SPIRIT_ATTACK_TYPE(out _S_EX_ELEMENTAL_SPIRIT_ATTACK_TYPE packet)
{
	// End:0x17
	if(!DecodeChar(packet.cBitset))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_SET_PLEDGE_CREST_PRESET(out array<byte> stream, _C_EX_SET_PLEDGE_CREST_PRESET packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nType))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nPresetCrestDBID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_GET_PLEDGE_CREST_PRESET(out array<byte> stream, _C_EX_GET_PLEDGE_CREST_PRESET packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nPledgeSId))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nPresetCrestDBID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_GET_PLEDGE_CREST_PRESET(out _S_EX_GET_PLEDGE_CREST_PRESET packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nPledgeSId))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nPresetCrestDBID))
	{
		return false;
	}
	return true;
}

static function bool Decode_DualInventoryDBIDData(out _DualInventoryDBIDData packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lSlotDBID.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.lSlotDBID.Length; i++)
	{
		// End:0x5C
		if(!DecodeInt(packet.lSlotDBID[i]))
		{
			return false;
		}
	}
	// End:0x78
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.lHennaPotenID.Length = nSize;

	// End:0xCC [Loop If]
	for(i = 0; i < packet.lHennaPotenID.Length; i++)
	{
		// End:0xC2
		if(!DecodeInt(packet.lHennaPotenID[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_DUAL_INVENTORY_INFO(out _S_EX_DUAL_INVENTORY_INFO packet)
{
	local int i;

	// End:0x17
	if(!DecodeChar(packet.cActiveSlot))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	// End:0x45
	if(!DecodeBool(packet.bStableSwapping))
	{
		return false;
	}

	// End:0x7F [Loop If]
	for(i = 0; i < 2; i++)
	{
		// End:0x75
		if(!Decode_DualInventoryDBIDData(packet.stDBData[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_DUAL_INVENTORY_SWAP(out array<byte> stream, _C_EX_DUAL_INVENTORY_SWAP packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cSwapSlot))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_SP_EXTRACT_INFO(out array<byte> stream, _C_EX_SP_EXTRACT_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SP_EXTRACT_INFO(out _S_EX_SP_EXTRACT_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nItemID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nExtractCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt64(packet.nNeedSP))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRate))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nCriticalRate))
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0x91
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0xA8
	if(!Decode_ItemInfo(packet.failedItem))
	{
		return false;
	}
	// End:0xC1
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0xDF
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0xF6
	if(!Decode_ItemInfo(packet.commissionItem))
	{
		return false;
	}
	// End:0x10F
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0x12D
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0x144
	if(!Decode_ItemInfo(packet.criticalItem))
	{
		return false;
	}
	// End:0x15D
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	// End:0x174
	if(!DecodeInt(packet.nRemainCount))
	{
		return false;
	}
	// End:0x18B
	if(!DecodeInt(packet.nMaxDailyCount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_SP_EXTRACT_ITEM(out array<byte> stream, _C_EX_SP_EXTRACT_ITEM packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nItemID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SP_EXTRACT_ITEM(out _S_EX_SP_EXTRACT_ITEM packet)
{
	// End:0x17
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeBool(packet.bCritical))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nItemID))
	{
		return false;
	}
	return true;
}

static function bool Encode_PkAbilitySkill(out array<byte> stream, _PkAbilitySkill packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nLevel))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkAbilitySkill(out _PkAbilitySkill packet)
{
	// End:0x17
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ACQUIRE_AP_SKILL_LIST(out _S_EX_ACQUIRE_AP_SKILL_LIST packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt64(packet.nResetSP))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nAP))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nAcquiredAbilityCount))
	{
		return false;
	}
	// End:0x6E
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.abilitySkills.Length = nSize;

	// End:0xC2 [Loop If]
	for(i = 0; i < packet.abilitySkills.Length; i++)
	{
		// End:0xB8
		if(!Decode_PkAbilitySkill(packet.abilitySkills[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_PkAbilitySkillsPerType(out array<byte> stream, _PkAbilitySkillsPerType packet)
{
	local int i;

	// End:0x1D
	if(!EncodeInt(stream, packet.abilitySkills.Length))
	{
		return false;
	}

	// End:0x65 [Loop If]
	for(i = 0; i < packet.abilitySkills.Length; i++)
	{
		// End:0x5B
		if(!Encode_PkAbilitySkill(stream, packet.abilitySkills[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_ACQUIRE_POTENTIAL_SKILL(out array<byte> stream, _C_EX_ACQUIRE_POTENTIAL_SKILL packet)
{
	local int i;

	// End:0x1C
	if(!EncodeInt(stream, packet.nAP))
	{
		return false;
	}

	// End:0x5B [Loop If]
	for(i = 0; i < 3; i++)
	{
		// End:0x51
		if(!Encode_PkAbilitySkillsPerType(stream, packet.abilitySkillsPerType[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_QUEST_TELEPORT(out array<byte> stream, _C_EX_QUEST_TELEPORT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_QUEST_ACCEPT(out array<byte> stream, _C_EX_QUEST_ACCEPT packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeBool(stream, packet.bAccept))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_QUEST_CANCEL(out array<byte> stream, _C_EX_QUEST_CANCEL packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_QUEST_COMPLETE(out array<byte> stream, _C_EX_QUEST_COMPLETE packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_QUEST_DIALOG(out _S_EX_QUEST_DIALOG packet)
{
	// End:0x17
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cDialogType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_QUEST_NOTIFICATION(out _S_EX_QUEST_NOTIFICATION packet)
{
	// End:0x17
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cNotifType))
	{
		return false;
	}
	return true;
}

static function bool Decode_PkQuestNotif(out _PkQuestNotif packet)
{
	// End:0x17
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_QUEST_NOTIFICATION_ALL(out _S_EX_QUEST_NOTIFICATION_ALL packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.questNotifs.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.questNotifs.Length; i++)
	{
		// End:0x5C
		if(!Decode_PkQuestNotif(packet.questNotifs[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_PkQuestInfo(out _PkQuestInfo packet)
{
	// End:0x17
	if(!DecodeInt(packet.nID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nCount))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cState))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_QUEST_UI(out _S_EX_QUEST_UI packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.questInfos.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.questInfos.Length; i++)
	{
		// End:0x5C
		if(!Decode_PkQuestInfo(packet.questInfos[i]))
		{
			return false;
		}
	}
	// End:0x7D
	if(!DecodeInt(packet.nProceedingQuestCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_QUEST_ACCEPTABLE_LIST(out _S_EX_QUEST_ACCEPTABLE_LIST packet)
{
	local int i, nSize;

	// End:0x12
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.questIDs.Length = nSize;

	// End:0x66 [Loop If]
	for(i = 0; i < packet.questIDs.Length; i++)
	{
		// End:0x5C
		if(!DecodeInt(packet.questIDs[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_SKILL_ENCHANT_INFO(out array<byte> stream, _C_EX_SKILL_ENCHANT_INFO packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nSkillID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nLevel))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nSubLevel))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_SKILL_ENCHANT_INFO(out _S_EX_SKILL_ENCHANT_INFO packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeInt(packet.nSkillID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nSubLevel))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nEXP))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nMaxExp))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nProbPerHundred))
	{
		return false;
	}
	i = GetCurDecodePos();
	// End:0x91
	if(!DecodeShort(nSize))
	{
		return false;
	}
	// End:0xA8
	if(!Decode_ItemInfo(packet.commissionItem))
	{
		return false;
	}
	// End:0xC1
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_SKILL_ENCHANT_CHARGE(out array<byte> stream, _C_EX_SKILL_ENCHANT_CHARGE packet)
{
	local int i;

	// End:0x1C
	if(!EncodeInt(stream, packet.nSkillID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nLevel))
	{
		return false;
	}
	// End:0x54
	if(!EncodeInt(stream, packet.nSubLevel))
	{
		return false;
	}
	// End:0x71
	if(!EncodeInt(stream, packet.Items.Length))
	{
		return false;
	}

	// End:0xB9 [Loop If]
	for(i = 0; i < packet.Items.Length; i++)
	{
		// End:0xAF
		if(!Encode_ItemServerInfo(stream, packet.Items[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_SKILL_ENCHANT_CHARGE(out _S_EX_SKILL_ENCHANT_CHARGE packet)
{
	// End:0x17
	if(!DecodeInt(packet.nSkillID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cReault))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER(out array<byte> stream, _C_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nEnterFieldID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER(out _S_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nEnteredFieldID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE(out array<byte> stream, _C_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nLeaveFieldID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt(stream, packet.nNextEnterFieldID))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE(out _S_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE packet)
{
	// End:0x17
	if(!DecodeInt(packet.nResult))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nLeaveFieldID))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nNextEnterFieldID))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_SHOP_OPEN_UI(out array<byte> stream, _C_EX_DETHRONE_SHOP_OPEN_UI packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_DETHRONE_SHOP_BUY(out array<byte> stream, _C_EX_DETHRONE_SHOP_BUY packet)
{
	// End:0x1C
	if(!EncodeInt(stream, packet.nID))
	{
		return false;
	}
	// End:0x38
	if(!EncodeInt64(stream, packet.nCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_SHOP_BUY(out _S_EX_DETHRONE_SHOP_BUY packet)
{
	// End:0x17
	if(!DecodeBool(packet.bSuccess))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_DETHRONE_POINT_INFO(out _S_EX_DETHRONE_POINT_INFO packet)
{
	// End:0x17
	if(!DecodeInt64(packet.nPersonalPoint))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ACQUIRE_SKILL_RESULT(out _S_EX_ACQUIRE_SKILL_RESULT packet)
{
	// End:0x17
	if(!DecodeInt(packet.nSkillID))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	// End:0x45
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nSysMsg))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI(out array<byte> stream, _C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Decode_EAOF_Element(out _EAOF_Element packet)
{
	// End:0x17
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nEXP))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nInitCount))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nExpUpCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI(out _S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI packet)
{
	local int i;

	// End:0x17
	if(!DecodeInt(packet.nSetEffectLevel))
	{
		return false;
	}

	// End:0x51 [Loop If]
	for(i = 0; i < 5; i++)
	{
		// End:0x47
		if(!Decode_EAOF_Element(packet.elements[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_ENHANCED_ABILITY_OF_FIRE_INIT(out array<byte> stream, _C_EX_ENHANCED_ABILITY_OF_FIRE_INIT packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_INIT(out _S_EX_ENHANCED_ABILITY_OF_FIRE_INIT packet)
{
	// End:0x17
	if(!DecodeChar(packet.cType))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nInitCount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP(out array<byte> stream, _C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP(out _S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cType))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nEXP))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nExpUpCount))
	{
		return false;
	}
	// End:0x6E
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rewards.Length = nSize;

	// End:0xC2 [Loop If]
	for(i = 0; i < packet.rewards.Length; i++)
	{
		// End:0xB8
		if(!Decode_ItemInfo(packet.rewards[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP(out array<byte> stream, _C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP packet)
{
	// End:0x1C
	if(!EncodeChar(stream, packet.cType))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP(out _S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP packet)
{
	// End:0x17
	if(!DecodeChar(packet.cType))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nLevel))
	{
		return false;
	}
	return true;
}

static function bool Decode_HolyFire(out _HolyFire packet)
{
	local int i, nSize;

	// End:0x17
	if(!DecodeChar(packet.cState))
	{
		return false;
	}
	// End:0x2E
	if(!DecodeInt(packet.nElapsedTime))
	{
		return false;
	}
	// End:0x45
	if(!DecodeInt(packet.nLifespan))
	{
		return false;
	}
	// End:0x5C
	if(!DecodeInt(packet.nRewardPersonalPoint))
	{
		return false;
	}
	// End:0x73
	if(!DecodeInt(packet.nRewardServerPoint))
	{
		return false;
	}
	if(!DecodeInt(packet.nRewardPrimalFirePoint))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.rewards.Length = nSize;

	// End:0xF0 [Loop If]
	for(i = 0; i < packet.rewards.Length; i++)
	{
		// End:0xE6
		if(!Decode_ItemInfo(packet.rewards[i]))
		{
			return false;
		}
	}
	if(!DecodeChar(packet.cRewardState))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_HOLY_FIRE_OPEN_UI(out _S_EX_HOLY_FIRE_OPEN_UI packet)
{
	local int i, nSize;

	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.infos.Length = nSize;

	for(i = 0; i < packet.infos.Length; i++)
	{
		if(!Decode_HolyFire(packet.infos[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_HOLY_FIRE_NOTIFY(out _S_EX_HOLY_FIRE_NOTIFY packet)
{
	if(!DecodeChar(packet.cState))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_PICK_UP_DIST_MODIFY(out _S_EX_PICK_UP_DIST_MODIFY packet)
{
	if(!DecodeChar(packet.IsPet))
	{
		return false;
	}
	if(!DecodeInt(packet.modifiedDistance))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_UNIQUE_GACHA_SIDEBAR_INFO(out _S_EX_UNIQUE_GACHA_SIDEBAR_INFO packet)
{
	if(!DecodeChar(packet.cOnOffFlag))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_UNIQUE_GACHA_OPEN(out array<byte> stream, _C_EX_UNIQUE_GACHA_OPEN packet)
{
	if(!EncodeChar(stream, packet.cFullInfo))
	{
		return false;
	}
	if(!EncodeChar(stream, packet.cOpenMode))
	{
		return false;
	}
	return true;
}

static function bool Decode_SUniqueGachaBaseItemInfo(out _SUniqueGachaBaseItemInfo packet)
{
	if(!DecodeChar(packet.cRankType))
	{
		return false;
	}
	if(!DecodeInt(packet.nItemType))
	{
		return false;
	}
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_SUniqueGachaItemInfo(out _SUniqueGachaItemInfo packet)
{
	local int i, nSize;

	i = GetCurDecodePos();

	if(!DecodeShort(nSize))
	{
		return false;
	}
	if(!Decode_SUniqueGachaBaseItemInfo(packet.sBaseItemInfo))
	{
		return false;
	}
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	if(!DecodeDouble(packet.dProb))
	{
		return false;
	}
	return true;
}

static function bool Decode_SUniqueGachaGameTypeInfo(out _SUniqueGachaGameTypeInfo packet)
{
	if(!DecodeInt(packet.nGameCount))
	{
		return false;
	}
	if(!DecodeInt64(packet.nCostItemAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_UNIQUE_GACHA_OPEN(out _S_EX_UNIQUE_GACHA_OPEN packet)
{
	local int i, nSize;

	if(!DecodeChar(packet.cOpenMode))
	{
		return false;
	}
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	if(!DecodeInt(packet.nMyCostItemAmount))
	{
		return false;
	}
	if(!DecodeInt(packet.nMyConfirmCount))
	{
		return false;
	}
	if(!DecodeInt(packet.nRemainSecTime))
	{
		return false;
	}
	if(!DecodeChar(packet.cFullInfo))
	{
		return false;
	}
	if(!DecodeChar(packet.cShowProb))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.showItems.Length = nSize;

	for(i = 0; i < packet.showItems.Length; i++)
	{
		if(!Decode_SUniqueGachaItemInfo(packet.showItems[i]))
		{
			return false;
		}
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.RewardItems.Length = nSize;

	for(i = 0; i < packet.RewardItems.Length; i++)
	{
		if(!Decode_SUniqueGachaItemInfo(packet.RewardItems[i]))
		{
			return false;
		}
	}
	if(!DecodeChar(packet.cCostType))
	{
		return false;
	}
	if(!DecodeInt(packet.nCostItemType))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.costAmountInfos.Length = nSize;

	for(i = 0; i < packet.costAmountInfos.Length; i++)
	{
		if(!Decode_SUniqueGachaGameTypeInfo(packet.costAmountInfos[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_UNIQUE_GACHA_GAME(out array<byte> stream, _C_EX_UNIQUE_GACHA_GAME packet)
{
	if(!EncodeInt(stream, packet.nGameCount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_UNIQUE_GACHA_GAME(out _S_EX_UNIQUE_GACHA_GAME packet)
{
	local int i, nSize;

	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	if(!DecodeInt(packet.nMyCostItemAmount))
	{
		return false;
	}
	if(!DecodeInt(packet.nMyConfirmCount))
	{
		return false;
	}
	if(!DecodeChar(packet.cRankType))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.ResultItems.Length = nSize;

	for(i = 0; i < packet.ResultItems.Length; i++)
	{
		if(!Decode_SUniqueGachaBaseItemInfo(packet.ResultItems[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST(out array<byte> stream, _C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST packet)
{
	if(!EncodeChar(stream, packet.cInvenType))
	{
		return false;
	}
	return true;
}

static function bool Encode_SUniqueGachaInvenItemInfo(out array<byte> stream, _SUniqueGachaInvenItemInfo packet)
{
	if(!EncodeInt(stream, packet.nItemType))
	{
		return false;
	}
	if(!EncodeInt64(stream, packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_SUniqueGachaInvenItemInfo(out _SUniqueGachaInvenItemInfo packet)
{
	if(!DecodeInt(packet.nItemType))
	{
		return false;
	}
	if(!DecodeInt64(packet.nAmount))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST(out _S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST packet)
{
	local int i, nSize;

	if(!DecodeChar(packet.cPage))
	{
		return false;
	}
	if(!DecodeChar(packet.cMaxPage))
	{
		return false;
	}
	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.myItems.Length = nSize;

	for(i = 0; i < packet.myItems.Length; i++)
	{
		if(!Decode_SUniqueGachaInvenItemInfo(packet.myItems[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_UNIQUE_GACHA_INVEN_GET_ITEM(out array<byte> stream, _C_EX_UNIQUE_GACHA_INVEN_GET_ITEM packet)
{
	local int i;

	if(!EncodeInt(stream, packet.getItems.Length))
	{
		return false;
	}

	for(i = 0; i < packet.getItems.Length; i++)
	{
		if(!Encode_SUniqueGachaInvenItemInfo(stream, packet.getItems[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_UNIQUE_GACHA_INVEN_GET_ITEM(out _S_EX_UNIQUE_GACHA_INVEN_GET_ITEM packet)
{
	if(!DecodeChar(packet.cResult))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_UNIQUE_GACHA_INVEN_ADD_ITEM(out _S_EX_UNIQUE_GACHA_INVEN_ADD_ITEM packet)
{
	local int i, nSize;

	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.addItems.Length = nSize;

	for(i = 0; i < packet.addItems.Length; i++)
	{
		if(!Decode_SUniqueGachaInvenItemInfo(packet.addItems[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_UNIQUE_GACHA_HISTORY(out array<byte> stream, _C_EX_UNIQUE_GACHA_HISTORY packet)
{
	if(!EncodeChar(stream, packet.cInvenType))
	{
		return false;
	}
	return true;
}

static function bool Decode_SUniqueGachaHistoryInfo(out _SUniqueGachaHistoryInfo packet)
{
	local int i, nSize;

	i = GetCurDecodePos();

	if(!DecodeShort(nSize))
	{
		return false;
	}
	if(!Decode_SUniqueGachaBaseItemInfo(packet.itemBaseInfo))
	{
		return false;
	}
	if(GetCurDecodePos() - i > nSize)
	{
		return false;
	}
	if(!DecodeInt(packet.nGetTimeSec))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_UNIQUE_GACHA_HISTORY(out _S_EX_UNIQUE_GACHA_HISTORY packet)
{
	local int i, nSize;

	if(!DecodeInt(nSize))
	{
		return false;
	}
	packet.historyItems.Length = nSize;

	for(i = 0; i < packet.historyItems.Length; i++)
	{
		if(!Decode_SUniqueGachaHistoryInfo(packet.historyItems[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_ITEM_SCORE(out _S_EX_ITEM_SCORE packet)
{
	if(! DecodeInt(packet.nScore))
	{
		return false;
	}
	return true;	
}

defaultproperties
{

}
