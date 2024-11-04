//================================================================================
// UIScript.
//================================================================================

class UIScript extends UIEventManager
	native
	dynamicrecompile;

cpptext
{
	#include "UIScript.h"
}

enum EventNotificationCondition {
	NotifyEvent_Always,
	NotifyEvent_Visible
};

enum PawnType {
	PT_NONE,
	PT_NPC,
	PT_PC,
	PT_PET
};

enum EDialogType {
	DialogType_OKCancel, // 0
	DialogType_OK, // 1
	DialogType_OKCancelInput, // 2
	DialogType_OKInput, // 3
	DialogType_Warning, // 4
	DialogType_Notice, // 5
	DialogType_NumberPad, // 6
	DialogType_Progress, // 7
	DialogType_NumberPad2, // 8
	DialogType_NumberPadAdena, // 9
};

enum EDialogModalType {
	DialogModalType_Modal,
	DialogModalType_Modalless // 1
};

enum DialogDefaultAction {
	EDefaultNone,
	EDefaultOK,
	EDefaultCancel
};

enum DialogEnterAction {
	EEnterNone,
	EEnterOK,
	EEnterCancel,
	EEnterDoNothing
};

enum PetitionMethod {
	PetitionMethod_Default,
	PetitionMethod_New,
	PetitionMethod_Web
};

enum ReleaseMode {
	RM_DEV,
	RM_RC,
	RM_TEST,
	RM_LIVE
};

enum ESoundType {
	SOUND_Ambient,
	SOUND_Effect,
	SOUND_Music,
	SOUND_SystemVoice,
	SOUND_NPCVoice,
	SOUND_NotifySound,
	SOUND_MainVolume
};

enum CollectionRegistFailReason {
	CRFR_None,
	CRFR_UnderNeedEnchant,
	CRFR_HaveNotEnoughItem,
	CRFR_OverNeedEnchant
};

var WindowHandle m_hOwnerWnd;
var bool m_bCreated;
var bool m_bCreatedByXmlData;

// Export UUIScript::execIsPKMode(FFrame&, void* const)
native function bool IsPKMode();

// Export UUIScript::execIsFullScreen(FFrame&, void* const)
native function bool IsFullScreen();

// Export UUIScript::execRequestExit(FFrame&, void* const)
native function RequestExit();

// Export UUIScript::execRequestAuthCardKeyLogin(FFrame&, void* const)
native function RequestAuthCardKeyLogin(int uid, string Value);

// Export UUIScript::execRequestSelfTarget(FFrame&, void* const)
native function RequestSelfTarget();

// Export UUIScript::execRequestTargetCancel(FFrame&, void* const)
native function RequestTargetCancel();

// Export UUIScript::execRequestSkillList(FFrame&, void* const)
native function RequestSkillList();

// Export UUIScript::execRequestRaidRecord(FFrame&, void* const)
native function RequestRaidRecord();

// Export UUIScript::execRequestTradeDone(FFrame&, void* const)
native function RequestTradeDone(bool bDone);

// Export UUIScript::execRequestStartTrade(FFrame&, void* const)
native function RequestStartTrade(int targetID);

// Export UUIScript::execRequestAddTradeItem(FFrame&, void* const)
native function RequestAddTradeItem(ItemID sID, INT64 Num);

// Export UUIScript::execAnswerTradeRequest(FFrame&, void* const)
native function AnswerTradeRequest(bool bOK);

// Export UUIScript::execRequestSellItem(FFrame&, void* const)
native function RequestSellItem(string param);

// Export UUIScript::execRequestBuyItem(FFrame&, void* const)
native function RequestBuyItem(string param);

// Export UUIScript::execNotifyFriendRejectState(FFrame&, void* const)
native function NotifyFriendRejectState();

// Export UUIScript::execRequestBuySeed(FFrame&, void* const)
native function RequestBuySeed(string param);

// Export UUIScript::execRequestSetSeed(FFrame&, void* const)
native function RequestSetSeed(string param);

// Export UUIScript::execRequestSetCrop(FFrame&, void* const)
native function RequestSetCrop(string param);

// Export UUIScript::execRequestAttack(FFrame&, void* const)
native function RequestAttack(int ServerID, Vector Loc);

// Export UUIScript::execRequestAction(FFrame&, void* const)
native function RequestAction(int ServerID, Vector Loc);

// Export UUIScript::execRequestAssist(FFrame&, void* const)
native function RequestAssist(int ServerID, Vector Loc);

// Export UUIScript::execRequestTargetUser(FFrame&, void* const)
native function RequestTargetUser(int ServerID);

// Export UUIScript::execRequestReTargetUser(FFrame&, void* const)
native function RequestReTargetUser(int ServerID);

// Export UUIScript::execRequestWarehouseDeposit(FFrame&, void* const)
native function RequestWarehouseDeposit(string param);

// Export UUIScript::execRequestWarehouseWithdraw(FFrame&, void* const)
native function RequestWarehouseWithdraw(string param);

// Export UUIScript::execRequestChangePetName(FFrame&, void* const)
native function RequestChangePetName(string Name);

// Export UUIScript::execRequestPackageSendableItemList(FFrame&, void* const)
native function RequestPackageSendableItemList(int targetID);

// Export UUIScript::execRequestPackageSend(FFrame&, void* const)
native function RequestPackageSend(string param);

// Export UUIScript::execRequestPreviewItem(FFrame&, void* const)
native function RequestPreviewItem(string param);

// Export UUIScript::execRequestBBSBoard(FFrame&, void* const)
native function RequestBBSBoard();

// Export UUIScript::execRequestMultiSellChoose(FFrame&, void* const)
native function RequestMultiSellChoose(string param);

// Export UUIScript::execRequestRestartPoint(FFrame&, void* const)
native function RequestRestartPoint(UIEventManager.RestartPoint eType, int nCostItemClassID, int nCostItemAmount);

// Export UUIScript::execBR_RequestRestartPoint(FFrame&, void* const)
native function BR_RequestRestartPoint(int Type, optional int NpcItem);

// Export UUIScript::execRequestUseItem(FFrame&, void* const)
native function RequestUseItem(ItemID sID);

// Export UUIScript::execRequestDestroyItem(FFrame&, void* const)
native function RequestDestroyItem(ItemID sID, INT64 Num);

// Export UUIScript::execRequestDropItem(FFrame&, void* const)
native function RequestDropItem(ItemID sID, INT64 Num, Vector Location);

// Export UUIScript::execRequestUnequipItem(FFrame&, void* const)
native function RequestUnequipItem(ItemID sID, INT64 SlotBitType);

// Export UUIScript::execRequestCrystallizeItem(FFrame&, void* const)
native function RequestCrystallizeItem(ItemID sID, INT64 Number);

// Export UUIScript::execRequestCrystallizeItemCancel(FFrame&, void* const)
native function RequestCrystallizeItemCancel();

// Export UUIScript::execRequestItemList(FFrame&, void* const)
native function RequestItemList();

// Export UUIScript::execRequestDuelStart(FFrame&, void* const)
native function RequestDuelStart(string sTargetName, int duelType);

// Export UUIScript::execRequestDuelAnswerStart(FFrame&, void* const)
native function RequestDuelAnswerStart(int duelType, int Option, int answer);

// Export UUIScript::execRequestDuelSurrender(FFrame&, void* const)
native function RequestDuelSurrender();

// Export UUIScript::execRequestDispel(FFrame&, void* const)
native function RequestDispel(int ServerID, ItemID sID, int SkillLevel, int SkillSubLevel);

// Export UUIScript::execRequestQuitPrivateShop(FFrame&, void* const)
native function RequestQuitPrivateShop(string Type);

// Export UUIScript::execSendPrivateShopList(FFrame&, void* const)
native function SendPrivateShopList(string Type, string param);

// Export UUIScript::execGetPartyMemberCount(FFrame&, void* const)
native function int GetPartyMemberCount();

// Export UUIScript::execGetPartyMemberLocation(FFrame&, void* const)
native function bool GetPartyMemberLocation(int a_PartyMemberIndex, out Vector a_Location);

// Export UUIScript::execGetPartyMemberLocationWithID(FFrame&, void* const)
native function bool GetPartyMemberLocationWithID(int a_PartyMemberSID, out Vector a_Location);

// Export UUIScript::execRequestClanMemberInfo(FFrame&, void* const)
native function RequestClanMemberInfo(int Type, string Name);

// Export UUIScript::execRequestClanGradeList(FFrame&, void* const)
native function RequestClanGradeList();

// Export UUIScript::execRequestClanChangeGrade(FFrame&, void* const)
native function RequestClanChangeGrade(string sName, int Grade);

// Export UUIScript::execRequestClanAssignPupil(FFrame&, void* const)
native function RequestClanAssignPupil(string sMaster, string sPupil);

// Export UUIScript::execRequestClanDeletePupil(FFrame&, void* const)
native function RequestClanDeletePupil(string sMaster, string sPupil);

// Export UUIScript::execRequestClanLeave(FFrame&, void* const)
native function RequestClanLeave(string ClanName, int clanType);

// Export UUIScript::execRequestClanExpelMember(FFrame&, void* const)
native function RequestClanExpelMember(int clanType, string sName);

// Export UUIScript::execRequestClanAskJoin(FFrame&, void* const)
native function RequestClanAskJoin(int Id, int clanType);

// Export UUIScript::execRequestClanAskJoinByName(FFrame&, void* const)
native function RequestClanAskJoinByName(string sName, int clanType);

// Export UUIScript::execRequestClanDeclareWar(FFrame&, void* const)
native function RequestClanDeclareWar();

// Export UUIScript::execRequestClanDeclareWarWithUserID(FFrame&, void* const)
native function RequestClanDeclareWarWithUserID(int Id);

// Export UUIScript::execRequestClanDeclareWarWithClanName(FFrame&, void* const)
native function RequestClanDeclareWarWithClanName(string sName);

// Export UUIScript::execRequestClanWithdrawWar(FFrame&, void* const)
native function RequestClanWithdrawWar();

// Export UUIScript::execRequestClanWithdrawWarWithClanName(FFrame&, void* const)
native function RequestClanWithdrawWarWithClanName(string sClanName);

// Export UUIScript::execRequestClanReorganizeMember(FFrame&, void* const)
native function RequestClanReorganizeMember(int Type, string memberName, int clanType, string targetMemberName);

// Export UUIScript::execRequestClanRegisterCrestByFilePath(FFrame&, void* const)
native function bool RequestClanRegisterCrestByFilePath(string filePath);

// Export UUIScript::execRequestClanRegisterCrest(FFrame&, void* const)
native function RequestClanRegisterCrest();

// Export UUIScript::execRequestClanUnregisterCrest(FFrame&, void* const)
native function RequestClanUnregisterCrest();

// Export UUIScript::execRequestClanRegisterEmblemByFilePath(FFrame&, void* const)
native function bool RequestClanRegisterEmblemByFilePath(string filePath);

// Export UUIScript::execRequestClanRegisterEmblem(FFrame&, void* const)
native function RequestClanRegisterEmblem();

// Export UUIScript::execRequestClanUnregisterEmblem(FFrame&, void* const)
native function RequestClanUnregisterEmblem();

// Export UUIScript::execRequestAllianceRegisterCrestByFilePath(FFrame&, void* const)
native function bool RequestAllianceRegisterCrestByFilePath(string filePath);

// Export UUIScript::execRequestClanChangeNickName(FFrame&, void* const)
native function RequestClanChangeNickName(string sName, string sNickName);

// Export UUIScript::execRequestClanWarList(FFrame&, void* const)
native function RequestClanWarList(int Page, int State);

// Export UUIScript::execRequestClanAuth(FFrame&, void* const)
native function RequestClanAuth(int gradeID);

// Export UUIScript::execRequestEditClanAuth(FFrame&, void* const)
native function RequestEditClanAuth(int gradeID, array<int> powers);

// Export UUIScript::execRequestClanMemberAuth(FFrame&, void* const)
native function RequestClanMemberAuth(int clanType, string sName);

// Export UUIScript::execRequestPCCafeCouponUse(FFrame&, void* const)
native function RequestPCCafeCouponUse(string a_CouponKey);

// Export UUIScript::execGetCastleName(FFrame&, void* const)
native function string GetCastleName(int castleID);

// Export UUIScript::execGetCastleRegionID(FFrame&, void* const)
native function int GetCastleRegionID(int castleID);

// Export UUIScript::execGetCastleLocationName(FFrame&, void* const)
native function string GetCastleLocationName(int castleID);

// Export UUIScript::execHasClanCrest(FFrame&, void* const)
native function bool HasClanCrest();

// Export UUIScript::execHasClanEmblem(FFrame&, void* const)
native function bool HasClanEmblem();

// Export UUIScript::execRequestInvitePartyByTargetID(FFrame&, void* const)
native function RequestInvitePartyByTargetID(int targetID);

// Export UUIScript::execRequestInviteParty(FFrame&, void* const)
native function RequestInviteParty(string sName);

// Export UUIScript::execRequestInviteMpcc(FFrame&, void* const)
native function RequestInviteMpcc(string Name);

// Export UUIScript::execGetClassType(FFrame&, void* const)
native final function string GetClassType(int ClassID);

// Export UUIScript::execGetClassIndex(FFrame&, void* const)
native final function UIEventManager.EClassIconType GetClassIndex(int ClassID);

// Export UUIScript::execGetClassLevel(FFrame&, void* const)
native function int GetClassLevel(int ClassID);

// Export UUIScript::execGetClassRoleType(FFrame&, void* const)
native function UIEventManager.EClassRoleType GetClassRoleType(int ClassID);

// Export UUIScript::execGetClassRoleName(FFrame&, void* const)
native final function string GetClassRoleName(int ClassID);

// Export UUIScript::execGetClassRoleNameByRole(FFrame&, void* const)
native final function string GetClassRoleNameByRole(int ClassRole);

// Export UUIScript::execGetClassTransferDegree(FFrame&, void* const)
native final function int GetClassTransferDegree(int ClassID);

// Export UUIScript::execGetPlayerRealName(FFrame&, void* const)
native function string GetPlayerRealName();

// Export UUIScript::execGetPlayerInfo(FFrame&, void* const)
native function bool GetPlayerInfo(out UserInfo a_UserInfo);

// Export UUIScript::execGetTargetInfo(FFrame&, void* const)
native function bool GetTargetInfo(out UserInfo a_UserInfo);

// Export UUIScript::execGetUserInfo(FFrame&, void* const)
native function bool GetUserInfo(int UserID, out UserInfo a_UserInfo);

// Export UUIScript::execGetPetInfo(FFrame&, void* const)
native function bool GetPetInfo(out PetInfo a_PetInfo);

// Export UUIScript::execGetSummonInfo(FFrame&, void* const)
native function bool GetSummonInfo(int ServerID, out SummonInfo a_SummonInfo);

// Export UUIScript::execGetSummonPoint(FFrame&, void* const)
native function GetSummonPoint(out int nSummonedPoint, out int nSummonablePoint);

// Export UUIScript::execGetSkillInfo(FFrame&, void* const)
native function bool GetSkillInfo(int a_SkillID, int a_SkillLevel, int a_SkillSubLevel, out SkillInfo a_SkillInfo);

// Export UUIScript::execGetSkillInfo_WRF(FFrame&, void* const)
native function bool GetSkillInfo_WRF(int a_SkillID, int a_SkillLevel, int a_SkillSubLevel, int a_rank, string a_name, out SkillInfo a_SkillInfo);

// Export UUIScript::execGetAccessoryItemID(FFrame&, void* const)
native function bool GetAccessoryItemID(out ItemID a_LEar, out ItemID a_REar, out ItemID a_LFinger, out ItemID a_RFinger);

// Export UUIScript::execGetDecoIndex(FFrame&, void* const)
native function int GetDecoIndex(ItemID DecoID);

// Export UUIScript::execGetJewelIndex(FFrame&, void* const)
native function int GetJewelIndex(ItemID JewelID);

// Export UUIScript::execGetAgathionIndex(FFrame&, void* const)
native function int GetAgathionIndex(ItemID AgathionID);

// Export UUIScript::execGetClassStep(FFrame&, void* const)
native function int GetClassStep(int a_ClassID);

// Export UUIScript::execIsBuilderPC(FFrame&, void* const)
native function bool IsBuilderPC();

// Export UUIScript::execIsPlayerStand(FFrame&, void* const)
native function bool IsPlayerStand();

// Export UUIScript::execGetArtifactIndex(FFrame&, void* const)
native function int GetArtifactIndex(ItemID ArtifactID);

// Export UUIScript::execGetClanName(FFrame&, void* const)
native function string GetClanName(int clanID);

// Export UUIScript::execGetClanNameValue(FFrame&, void* const)
native final function int GetClanNameValue(int iClanID);

// Export UUIScript::execGetAdena(FFrame&, void* const)
native final function INT64 GetAdena();

// Export UUIScript::execGetAdenaStr(FFrame&, void* const)
native final function string GetAdenaStr();

// Export UUIScript::execGetTeleportBookMarkCount(FFrame&, void* const)
native final function int GetTeleportBookMarkCount();

// Export UUIScript::execGetTeleportFlagCount(FFrame&, void* const)
native final function int GetTeleportFlagCount();

// Export UUIScript::execGetPartyMemberInfo(FFrame&, void* const)
native function bool GetPartyMemberInfo(int UserID, out PartyMemberInfo PartyMemberInfo);

// Export UUIScript::execGetPartyMemberPetInfo(FFrame&, void* const)
native function bool GetPartyMemberPetInfo(int UserID, out PartyMemberPetInfo PartyMemberPetInfo);

// Export UUIScript::execGetPartyMemberSummonedInfo(FFrame&, void* const)
native function bool GetPartyMemberSummonedInfo(int UserID, int summonedID, out PartyMemberSummonedInfo PartyMemberSummonedInfo);

// Export UUIScript::execMakeBuffTimeStr(FFrame&, void* const)
native final function string MakeBuffTimeStr(int Time);

// Export UUIScript::execMakeToppingBuffTimeStr(FFrame&, void* const)
native final function string MakeToppingBuffTimeStr(int Time);

// Export UUIScript::execMakeTimeStr(FFrame&, void* const)
native final function string MakeTimeStr(int Time);

// Export UUIScript::execGetTimeString(FFrame&, void* const)
native final function string GetTimeString();

// Export UUIScript::execGetAppSeconds(FFrame&, void* const)
native static function float GetAppSeconds();

// Export UUIScript::execGetAppMilliSeconds(FFrame&, void* const)
native static function INT64 GetAppMilliSeconds();

// Export UUIScript::execGetTimeStruct(FFrame&, void* const)
native final function GetTimeStruct(int IntTime, out L2UITime UITimeStruct);

// Export UUIScript::execGetTimeStructGMT(FFrame&, void* const)
native final function GetTimeStructGMT(int IntTime, out L2UITime UITimeStruct);

// Export UUIScript::execConvertTimetoStr(FFrame&, void* const)
native final function string ConvertTimetoStr(int Time);

// Export UUIScript::execDebug(FFrame&, void* const)
native final function Debug(string strMsg);

// Export UUIScript::execIsKeyDown(FFrame&, void* const)
native final function bool IsKeyDown(EInputKey Key);

// Export UUIScript::execGetSystemString(FFrame&, void* const)
native final function string GetSystemString(int Id);

// Export UUIScript::execGetSystemMessage(FFrame&, void* const)
native final function string GetSystemMessage(int Id);

// Export UUIScript::execGetSystemMsgInfo(FFrame&, void* const)
native final function GetSystemMsgInfo(int Id, out SystemMsgData SysMsgData);

// Export UUIScript::execGetSystemMessageWithParamNumber(FFrame&, void* const)
native final function string GetSystemMessageWithParamNumber(int Id, int param);

// Export UUIScript::execGetNpcString(FFrame&, void* const)
native final function string GetNpcString(int Id);

// Export UUIScript::execGetScript(FFrame&, void* const)
native static function UIScript GetScript(string Window);

// Export UUIScript::execMakeFullSystemMsg(FFrame&, void* const)
native final function string MakeFullSystemMsg(string sMsg, string sArg1, optional string sArg2, optional string sArg3, optional string sArg4, optional string sArg5);

// Export UUIScript::execGetTextSizeDefault(FFrame&, void* const)
native final function GetTextSizeDefault(string strInput, out int nWidth, out int nHeight);

// Export UUIScript::execGetTextSize(FFrame&, void* const)
native final function GetTextSize(string strInput, string sFontName, out int nWidth, out int nHeight);

// Export UUIScript::execDivideStringWithWidth(FFrame&, void* const)
native final function string DivideStringWithWidth(string strInput, int nWidth);

// Export UUIScript::execNextStringWithWidth(FFrame&, void* const)
native final function string NextStringWithWidth(int nWidth);

// Export UUIScript::execMakeFullItemName(FFrame&, void* const)
native final function string MakeFullItemName(int Id);

// Export UUIScript::execGetItemGradeString(FFrame&, void* const)
native final function string GetItemGradeString(int nCrystalType);

// Export UUIScript::execGetItemGradeTextureName(FFrame&, void* const)
native final function string GetItemGradeTextureName(int nCrystalType);

// Export UUIScript::execMakeCostStringINT64(FFrame&, void* const)
native final function string MakeCostStringINT64(INT64 a_Input);

// Export UUIScript::execMakeCostString(FFrame&, void* const)
native final function string MakeCostString(string strInput);

// Export UUIScript::execConvertNumToText(FFrame&, void* const)
native final function string ConvertNumToText(string strInput);

// Export UUIScript::execConvertNumToTextNoAdena(FFrame&, void* const)
native final function string ConvertNumToTextNoAdena(string strInput);

// Export UUIScript::execCeilingNum(FFrame&, void* const)
native final function string CeilingNum(string strInput, int positionalNum);

// Export UUIScript::execConvertTimeToString(FFrame&, void* const)
native final function string ConvertTimeToString(float Time);

// Export UUIScript::execPlayConsoleSound(FFrame&, void* const)
native final function PlayConsoleSound(UIEventManager.EInterfaceSoundType eType);

// Export UUIScript::execGetCurrentIMELang(FFrame&, void* const)
native final function UIEventManager.EIMEType GetCurrentIMELang();

// Export UUIScript::execGetPledgeCrestTexFromPledgeCrestID(FFrame&, void* const)
native final function Texture GetPledgeCrestTexFromPledgeCrestID(int PledgeCrestID);

// Export UUIScript::execGetAllianceCrestTexFromAllianceCrestID(FFrame&, void* const)
native final function Texture GetAllianceCrestTexFromAllianceCrestID(int AllianceCrestID);

// Export UUIScript::execRequestBypassToServer(FFrame&, void* const)
native final function RequestBypassToServer(string strPass);

// Export UUIScript::execGetUserRankString(FFrame&, void* const)
native final function string GetUserRankString(int Rank);

// Export UUIScript::execGetRoutingString(FFrame&, void* const)
native final function string GetRoutingString(int RoutingType);

// Export UUIScript::execGetDebuffType(FFrame&, void* const)
native final function int GetDebuffType(ItemID cID, int SkillLevel, int SkillSubLevel);

// Export UUIScript::execGetIsMagic(FFrame&, void* const)
native final function int GetIsMagic(ItemID cID, int SkillLevel, int SkillSubLevel);

// Export UUIScript::execIsSongDance(FFrame&, void* const)
native final function bool IsSongDance(ItemID cID, int SkillLevel, int SkillSubLevel);

// Export UUIScript::execIsIconHide(FFrame&, void* const)
native final function bool IsIconHide(ItemID cID, int SkillLevel, int SkillSubLevel);

// Export UUIScript::execIsTriggerSkill(FFrame&, void* const)
native final function bool IsTriggerSkill(ItemID cID, int SkillLevel, int SkillSubLevel);

// Export UUIScript::execCheckItemLimit(FFrame&, void* const)
native final function bool CheckItemLimit(ItemID cID, INT64 Count);

// Export UUIScript::execGetClickLocation(FFrame&, void* const)
native function Vector GetClickLocation();

// Export UUIScript::execGetPcCafeItemIconPackageName(FFrame&, void* const)
native function string GetPcCafeItemIconPackageName(optional bool bSmall);

// Export UUIScript::execGetCurrentResolution(FFrame&, void* const)
native final function GetCurrentResolution(out int ScreenWidth, out int ScreenHeight);

// Export UUIScript::execGetMaxLevel(FFrame&, void* const)
native final function int GetMaxLevel();

// Export UUIScript::execSetPrivateShopMessage(FFrame&, void* const)
native function SetPrivateShopMessage(string Type, string Message);

// Export UUIScript::execGetPrivateShopMessage(FFrame&, void* const)
native function string GetPrivateShopMessage(string Type);

// Export UUIScript::execAddSystemMessage(FFrame&, void* const)
native final function AddSystemMessage(int Index);

// Export UUIScript::execAddSystemMessageString(FFrame&, void* const)
native final function AddSystemMessageString(string Msg);

// Export UUIScript::execAddSystemMessageParam(FFrame&, void* const)
native final function AddSystemMessageParam(string strParam);

// Export UUIScript::execEndSystemMessageParam(FFrame&, void* const)
native final function string EndSystemMessageParam(int MsgNum, bool bGetMsg);

// Export UUIScript::execExecRestart(FFrame&, void* const)
native final function ExecRestart();

// Export UUIScript::execExecQuit(FFrame&, void* const)
native final function ExecQuit();

// Export UUIScript::execGetServerAgeLimit(FFrame&, void* const)
native final function UIEventManager.EServerAgeLimit GetServerAgeLimit();

// Export UUIScript::execGetServerNo(FFrame&, void* const)
native final function int GetServerNo();

// Export UUIScript::execCanUseAudio(FFrame&, void* const)
native final function bool CanUseAudio();

// Export UUIScript::execCanUseJoystick(FFrame&, void* const)
native final function bool CanUseJoystick();

// Export UUIScript::execCanUseHDR(FFrame&, void* const)
native final function bool CanUseHDR();

// Export UUIScript::execIsEnableEngSelection(FFrame&, void* const)
native final function bool IsEnableEngSelection();

// Export UUIScript::execIsUseKeyCrypt(FFrame&, void* const)
native final function bool IsUseKeyCrypt();

// Export UUIScript::execIsCheckKeyCrypt(FFrame&, void* const)
native final function bool IsCheckKeyCrypt();

// Export UUIScript::execIsEnableKeyCrypt(FFrame&, void* const)
native final function bool IsEnableKeyCrypt();

// Export UUIScript::execGetLanguage(FFrame&, void* const)
native final function UIEventManager.ELanguageType GetLanguage();

// Export UUIScript::execGetLanguageCustom(FFrame&, void* const)
native final function int GetLanguageCustom();

// Export UUIScript::execGetResolutionList(FFrame&, void* const)
native final function GetResolutionList(out array<ResolutionInfo> a_ResolutionList);

// Export UUIScript::execGetRefreshRateList(FFrame&, void* const)
native final function GetRefreshRateList(out array<int> a_RefreshRateList, optional int a_nWidth, optional int a_nHeight);

// Export UUIScript::execSetResolution(FFrame&, void* const)
native final function SetResolution(int a_nResolutionIndex, int a_nRefreshRateIndex);

// Export UUIScript::execGetMultiSample(FFrame&, void* const)
native final function int GetMultiSample();

// Export UUIScript::execGetResolutionIndex(FFrame&, void* const)
native final function int GetResolutionIndex();

// Export UUIScript::execGetShaderVersion(FFrame&, void* const)
native final function GetShaderVersion(out int a_nPixelShaderVersion, out int a_nVertexShaderVersion);

// Export UUIScript::execSetDefaultPosition(FFrame&, void* const)
native final function SetDefaultPosition();

// Export UUIScript::execSetKeyCrypt(FFrame&, void* const)
native final function SetKeyCrypt(bool a_bOnOff);

// Export UUIScript::execSetTextureDetail(FFrame&, void* const)
native final function SetTextureDetail(int a_nTextureDetail);

// Export UUIScript::execSetModelingDetail(FFrame&, void* const)
native final function SetModelingDetail(int a_nModelingDetail);

// Export UUIScript::execSetMotionDetail(FFrame&, void* const)
native final function SetMotionDetail(int a_nMotionDetail);

// Export UUIScript::execSetEffectDetail(FFrame&, void* const)
native final function SetEffectDetail(int Detail);

// Export UUIScript::execSetShadow(FFrame&, void* const)
native final function SetShadow(bool a_bShadow);

// Export UUIScript::execSetBackgroundEffect(FFrame&, void* const)
native final function SetBackgroundEffect(bool a_bBackgroundEffect);

// Export UUIScript::execSetTerrainClippingRange(FFrame&, void* const)
native final function SetTerrainClippingRange(int a_nTerrainClippingRange);

// Export UUIScript::execSetPawnClippingRange(FFrame&, void* const)
native final function SetPawnClippingRange(int a_nPawnClippingRange);

// Export UUIScript::execSetReflectionEffect(FFrame&, void* const)
native final function SetReflectionEffect(int a_nReflectionEffect);

// Export UUIScript::execSetAntialiasing(FFrame&, void* const)
native final function SetAntialiasing(int a_nAntialiasing);

// Export UUIScript::execSetYebisAntialiasing(FFrame&, void* const)
native final function SetYebisAntialiasing(bool a_bYebisAntialiasing);

// Export UUIScript::execSetHDR(FFrame&, void* const)
native final function SetHDR(int a_nHDR);

// Export UUIScript::execSetWeatherEffect(FFrame&, void* const)
native final function SetWeatherEffect(int a_nWeatherEffect);

// Export UUIScript::execSetL2Shader(FFrame&, void* const)
native final function SetL2Shader(bool a_bShader);

// Export UUIScript::execSetDOF(FFrame&, void* const)
native final function SetDOF(bool a_bDof);

// Export UUIScript::execSetYebisDOF(FFrame&, void* const)
native final function SetYebisDOF(bool a_bYebisDof);

// Export UUIScript::execSetYebisGlow(FFrame&, void* const)
native final function SetYebisGlow(int a_nYebisGlow);

// Export UUIScript::execSetDepthBufferShadow(FFrame&, void* const)
native final function SetDepthBufferShadow(bool a_bShadow);

// Export UUIScript::execSetShaderWaterEffect(FFrame&, void* const)
native final function SetShaderWaterEffect(bool a_bWater);

// Export UUIScript::execSetRenderCharacterCount(FFrame&, void* const)
native final function SetRenderCharacterCount(int a_NewLimitAcotor);

// Export UUIScript::execSetIgnorePartyInviting(FFrame&, void* const)
native final function SetIgnorePartyInviting(bool a_bIgnore);

// Export UUIScript::execSetIgnoreFriendInviting(FFrame&, void* const)
native final function SetIgnoreFriendInviting(bool a_bIgnore);

// Export UUIScript::execSetFixedDefaultCamera(FFrame&, void* const)
native final function SetFixedDefaultCamera(bool a_bFixed);

// Export UUIScript::execSetOutline(FFrame&, void* const)
native final function SetOutline(bool a_bOutline);

// Export UUIScript::execCanUseSystemDPIScaling(FFrame&, void* const)
native final function bool CanUseSystemDPIScaling();

// Export UUIScript::execChangeLanguage(FFrame&, void* const)
native final function ChangeLanguage(int LangType);

// Export UUIScript::execGetLocalizedL2TextPathNameUC(FFrame&, void* const)
native final function string GetLocalizedL2TextPathNameUC();

// Export UUIScript::execExecuteCommand(FFrame&, void* const)
native final function ExecuteCommand(string a_strCmd);

// Export UUIScript::execExecuteCommandFromAction(FFrame&, void* const)
native final function ExecuteCommandFromAction(string strCmd, optional string param);

// Export UUIScript::execDoAction(FFrame&, void* const)
native final function DoAction(ItemID cID);

// Export UUIScript::execUseSkill(FFrame&, void* const)
native final function UseSkill(ItemID cID, int ShortcutType);

// Export UUIScript::execIsStackableItem(FFrame&, void* const)
native final function bool IsStackableItem(int ConsumeType);

// Export UUIScript::execStopMacro(FFrame&, void* const)
native final function StopMacro();

// Export UUIScript::execSetOptionBool(FFrame&, void* const)
native final function SetOptionBool(string a_strSection, string a_strName, bool a_bValue);

// Export UUIScript::execSetOptionInt(FFrame&, void* const)
native final function SetOptionInt(string a_strSection, string a_strName, int a_nValue);

// Export UUIScript::execSetOptionFloat(FFrame&, void* const)
native final function SetOptionFloat(string a_strSection, string a_strName, float a_fValue);

// Export UUIScript::execSetOptionString(FFrame&, void* const)
native final function SetOptionString(string a_strSection, string a_strName, string a_strValue);

// Export UUIScript::execGetOptionBool(FFrame&, void* const)
native final function bool GetOptionBool(string a_strSection, string a_strName);

// Export UUIScript::execGetOptionInt(FFrame&, void* const)
native final function int GetOptionInt(string a_strSection, string a_strName);

// Export UUIScript::execGetOptionFloat(FFrame&, void* const)
native final function float GetOptionFloat(string a_strSection, string a_strName);

// Export UUIScript::execGetOptionString(FFrame&, void* const)
native final function string GetOptionString(string a_strSection, string a_strName);

// Export UUIScript::execSetChatFilterBool(FFrame&, void* const)
native final function SetChatFilterBool(string a_strSection, string a_strName, bool a_bValue);

// Export UUIScript::execGetChatFilterBool(FFrame&, void* const)
native final function bool GetChatFilterBool(string a_strSection, string a_strName);

// Export UUIScript::execApplyOptionToDamageText(FFrame&, void* const)
native final function ApplyOptionToDamageText();

// Export UUIScript::execSendWindowsInfo(FFrame&, void* const)
native final function SendWindowsInfo();

// Export UUIScript::execGetInventoryItemCount(FFrame&, void* const)
native final function INT64 GetInventoryItemCount(ItemID cID);

// Export UUIScript::execGetSlotTypeString(FFrame&, void* const)
native final function string GetSlotTypeString(int ItemType, INT64 SlotBitType, int ArmorType);

// Export UUIScript::execGetWeaponTypeString(FFrame&, void* const)
native final function string GetWeaponTypeString(int WeaponType);

// Export UUIScript::execGetAttackSpeedString(FFrame&, void* const)
native final function string GetAttackSpeedString(int AttackSpeed);

// Export UUIScript::execGetSoulShotPower(FFrame&, void* const)
native final function float GetSoulShotPower(int CrystalType, int Enchanted, int WeaponType, bool magicWeapon);

// Export UUIScript::execGetSpiritShotPower(FFrame&, void* const)
native final function float GetSpiritShotPower(int CrystalType, int Enchanted, int WeaponType, bool magicWeapon);

// Export UUIScript::execIsMagicalArmor(FFrame&, void* const)
native final function bool IsMagicalArmor(ItemID cID);

// Export UUIScript::execIsSigilArmor(FFrame&, void* const)
native final function bool IsSigilArmor(ItemID Id);

// Export UUIScript::execGetLottoString(FFrame&, void* const)
native final function string GetLottoString(int nLookChangeItemID);

// Export UUIScript::execGetRaceTicketString(FFrame&, void* const)
native final function string GetRaceTicketString(int Blessed);

// Export UUIScript::execRequestSaveInventoryOrder(FFrame&, void* const)
native final function RequestSaveInventoryOrder(array<ItemID> a_IDList, array<int> a_OrderList);

// Export UUIScript::execRefreshINI(FFrame&, void* const)
native final function RefreshINI(string a_INIFileName);

// Export UUIScript::execGetINIBool(FFrame&, void* const)
native final function bool GetINIBool(string section, string Key, out int Value, string file);

// Export UUIScript::execGetINIInt(FFrame&, void* const)
native final function bool GetINIInt(string section, string Key, out int Value, string file);

// Export UUIScript::execGetINIFloat(FFrame&, void* const)
native final function bool GetINIFloat(string section, string Key, out float Value, string file);

// Export UUIScript::execGetINIString(FFrame&, void* const)
native final function bool GetINIString(string section, string Key, out string Value, string file);

// Export UUIScript::execSetINIBool(FFrame&, void* const)
native final function SetINIBool(string section, string Key, bool Value, string file);

// Export UUIScript::execSetINIInt(FFrame&, void* const)
native final function SetINIInt(string section, string Key, int Value, string file);

// Export UUIScript::execSetINIFloat(FFrame&, void* const)
native final function SetINIFloat(string section, string Key, float Value, string file);

// Export UUIScript::execSetINIString(FFrame&, void* const)
native final function SetINIString(string section, string Key, string Value, string file);

// Export UUIScript::execRemoveINI(FFrame&, void* const)
native final function RemoveINI(string section, string Key, string file);

// Export UUIScript::execSaveINI(FFrame&, void* const)
native final function SaveINI(string file);

// Export UUIScript::execGetConstantInt(FFrame&, void* const)
native final function bool GetConstantInt(int a_nID, out int a_nValue);

// Export UUIScript::execGetConstantString(FFrame&, void* const)
native final function bool GetConstantString(int a_nID, out string a_strValue);

// Export UUIScript::execGetConstantBool(FFrame&, void* const)
native final function bool GetConstantBool(int a_nID, out int a_bValue);

// Export UUIScript::execGetConstantFloat(FFrame&, void* const)
native final function bool GetConstantFloat(int a_nID, out float a_fValue);

// Export UUIScript::execSetSoundVolume(FFrame&, void* const)
native final function SetSoundVolume(float a_fVolume);

// Export UUIScript::execSetEffectVolume(FFrame&, void* const)
native final function SetEffectVolume(float a_fVolume);

// Export UUIScript::execSetAmbientVolume(FFrame&, void* const)
native final function SetAmbientVolume(float a_fVolume);

// Export UUIScript::execSetMusicVolume(FFrame&, void* const)
native final function SetMusicVolume(float a_fVolume);

// Export UUIScript::execSetNpcVoiceVolume(FFrame&, void* const)
native final function SetNpcVoiceVolume(float a_fVolume);

// Export UUIScript::execSetSystemVoiceVolume(FFrame&, void* const)
native final function SetSystemVoiceVolume(float a_fVolume);

// Export UUIScript::execGetMusicVolume(FFrame&, void* const)
native final function float GetMusicVolume();

// Export UUIScript::execTutorialVoiceOff(FFrame&, void* const)
native final function TutorialVoiceOff();

// Export UUIScript::execTutorialVoiceOn(FFrame&, void* const)
native final function TutorialVoiceOn();

// Export UUIScript::execGetVolumeScale(FFrame&, void* const)
native final function float GetVolumeScale(UIScript.ESoundType a_nType);

// Export UUIScript::execReturnTooltipInfo(FFrame&, void* const)
native final function ReturnTooltipInfo(CustomTooltip Info);

// Export UUIScript::execGetItemKeepSelectInfo(FFrame&, void* const)
native final function bool GetItemKeepSelectInfo(ItemID a_ID, out KeepSelectInfo Info);

// Export UUIScript::execGetItemTextSectionInfos(FFrame&, void* const)
native final function bool GetItemTextSectionInfos(string FormatText, out string FullText, out array<TextSectionInfo> TextInfos);

// Export UUIScript::execReturnShowXMLDetailTooltip(FFrame&, void* const)
native final function ReturnShowXMLDetailTooltip(bool isShow);

// Export UUIScript::execSetItemTextLink(FFrame&, void* const)
native final function SetItemTextLink(ItemID a_ID, string a_ItemName);

// Export UUIScript::execRequestShowVisionMovie(FFrame&, void* const)
native final function RequestShowVisionMovie();

// Export UUIScript::execRequestCallToChangeClass(FFrame&, void* const)
native final function RequestCallToChangeClass();

// Export UUIScript::execRequestChangeToAwakenedClass(FFrame&, void* const)
native final function RequestChangeToAwakenedClass(int bYes);

event OnLoad();

event OnTick();

event OnShow();

event OnHide();

event OnEvent(int a_EventID, string a_Param);

event OnEventWithParamMap(int a_EventID, ParamMap a_ParamMap);

event OnTimer(int TimerID);

event OnMinimize();

event OnEnterState(name a_PreStateName);

event OnExitState(name a_NextStateName);

event OnSendPacketWhenHiding();

event OnDefaultPosition();

event OnDrawerShowFinished();

event OnDrawerHideFinished();

event OnRegisterEvent();

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused);

event OnKeyDown(WindowHandle a_WindowHandle, EInputKey Key);

event OnKeyUp(WindowHandle a_WindowHandle, EInputKey Key);

event OnReceivedCloseUI();

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y);

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y);

event OnLButtonDblClick(WindowHandle a_WindowHandle, int X, int Y);

event OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y);

event OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y);

event OnRButtonDblClick(WindowHandle a_WindowHandle, int X, int Y);

event OnMButtonDown(WindowHandle a_WindowHandle, int X, int Y);

event OnMButtonUp(WindowHandle a_WindowHandle, int X, int Y);

event OnMouseOver(WindowHandle a_WindowHandle);

event OnMouseOut(WindowHandle a_WindowHandle);

event OnMouseMove(WindowHandle a_WindowHandle, int X, int Y);

event OnDropItem(string strID, ItemInfo infItem, int X, int Y);

event OnDragItemStart(string strID, ItemInfo infItem);

event OnDragItemEnd(string strID);

event OnDragItemStartTiny(string strID, ItemInfo infItem);

event OnDropItemSource(string strTarget, ItemInfo infItem);

event OnDropItemWithHandle(WindowHandle hTarget, ItemInfo infItem, int X, int Y);

event OnDropWnd(WindowHandle hTarget, WindowHandle hDropWnd, int X, int Y);

event OnClickButton(string strID);

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle);

event OnRClickButton(string strID);

event OnRClickButtonWithHandle(ButtonHandle a_ButtonHandle);

event OnButtonTimer(bool bExpired);

event OnTabSplit(string sName);

event OnTabMerge(string sName);

event OnCompleteEditBox(string strID);

event OnChangeEditBox(string strID);

event OnChatMarkedEditBox(string strID);

event OnClickListCtrlRecord(string strID);

event OnDBClickListCtrlRecord(string strID);

event OnRClickListCtrlRecord(string strID);

event OnRollOverListCtrlRecord(string strID, int Index);

event OnClickRichListButton(WindowHandle a_WindowHandle, int X, int Y);

event OnClickHeaderCtrl(string strID, int Index);

event OnLButtonClickListBoxItem(string strID, int SelectedIndex);

event OnRButtonClickListBoxItem(string strID, int SelectedIndex);

event OnDBClickListBoxItem(string strID, int SelectedIndex);

event OnClickCheckBox(string strID);

event OnCilckCheckBoxWithHandle(CheckBoxHandle a_CheckBoxHandle);

event OnClickItem(string strID, int Index);

event OnDBClickItem(string strID, int Index);

event OnRClickItem(string strID, int Index);

event OnRDBClickItem(string strID, int Index);

event OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index);

event OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index);

event OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index);

event OnProgressTimeUp(string strID);

event OnComboBoxItemSelected(string strID, int Index);

event OnTextureAnimEnd(AnimTextureHandle a_AnimTextureHandle);

event OnPropertyControllerResize(PropertyControllerHandle a_PropertyHandle, int a_Height);

event OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle);

event OnFlashCtrlMsg(FlashCtrlHandle a_FlashCtrlHandle, string a_Param);

event OnCallUCFunction(string functionName, string param);

event OnScrollMove(string strID, int Position);

// Export UUIScript::execPlaySound(FFrame&, void* const)
native final function PlaySound(string strSoundName);

// Export UUIScript::execPlaySoundUntilEnd(FFrame&, void* const)
native final function PlaySoundUntilEnd(string strSoundName);

// Export UUIScript::execStopSound(FFrame&, void* const)
native final function StopSound(string a_SoundName);

// Export UUIScript::execRequestOpenMinimap(FFrame&, void* const)
native final function RequestOpenMinimap();

event OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick);

// Export UUIScript::execGetCurrentZoneName(FFrame&, void* const)
native final function string GetCurrentZoneName();

// Export UUIScript::execGetCurrentZoneID(FFrame&, void* const)
native final function int GetCurrentZoneID();

// Export UUIScript::execGetInZoneNameWithZoneID(FFrame&, void* const)
native final function string GetInZoneNameWithZoneID(int inzoneID);

// Export UUIScript::execGetZoneNameWithLocation(FFrame&, void* const)
native final function string GetZoneNameWithLocation(Vector Location);

// Export UUIScript::execRequestHennaItemInfo(FFrame&, void* const)
native final function RequestHennaItemInfo(int iHennaID);

// Export UUIScript::execRequestHennaItemList(FFrame&, void* const)
native final function RequestHennaItemList();

// Export UUIScript::execRequestHennaEquip(FFrame&, void* const)
native final function RequestHennaEquip(int iHennaID);

// Export UUIScript::execRequestHennaUnEquipInfo(FFrame&, void* const)
native final function RequestHennaUnEquipInfo(int iHennaID);

// Export UUIScript::execRequestHennaUnEquipList(FFrame&, void* const)
native final function RequestHennaUnEquipList();

// Export UUIScript::execRequestHennaUnEquip(FFrame&, void* const)
native final function RequestHennaUnEquip(int iHennaID);

// Export UUIScript::execGetPlayerPosition(FFrame&, void* const)
native final function Vector GetPlayerPosition();

// Export UUIScript::execGetCharacterSelectionActor(FFrame&, void* const)
native final function Actor GetCharacterSelectionActor(int a_CharIndex);

// Export UUIScript::execGetSystemDir(FFrame&, void* const)
native final function string GetSystemDir();

// Export UUIScript::execGetFileList(FFrame&, void* const)
native final function GetFileList(out array<string> FileList, string strDir, string strExtention);

// Export UUIScript::execGetDirList(FFrame&, void* const)
native final function GetDirList(out array<string> DirList, string strDir);

// Export UUIScript::execBeginReplay(FFrame&, void* const)
native final function BeginReplay(string strFileName, bool bLoadCameraInst, bool bLoadChatData);

// Export UUIScript::execEraseReplayFile(FFrame&, void* const)
native final function EraseReplayFile(string strFileName);

// Export UUIScript::execBeginPlay(FFrame&, void* const)
native final function BeginPlay();

// Export UUIScript::execBeginBenchMark(FFrame&, void* const)
native final function BeginBenchMark();

// Export UUIScript::execRequestAcquireSkillInfo(FFrame&, void* const)
native final function RequestAcquireSkillInfo(int iID, int iLevel, int iSubLevel, int iType);

// Export UUIScript::execRequestAcquireSkill(FFrame&, void* const)
native final function RequestAcquireSkill(int iID, int iLevel, int iSubLevel, int iType);

// Export UUIScript::execRequestAcquireSkillSubClan(FFrame&, void* const)
native final function RequestAcquireSkillSubClan(int iID, int iLevel, int iType, int iSubClan);

// Export UUIScript::execRequestExEnchantSkillInfo(FFrame&, void* const)
native final function RequestExEnchantSkillInfo(int iID, int iLevel, int iSubLevel);

// Export UUIScript::execRequestExEnchantSkillInfoDetail(FFrame&, void* const)
native final function RequestExEnchantSkillInfoDetail(int Type, int iID, int iLevel, int iSubLevel);

// Export UUIScript::execRequestExEnchantSkill(FFrame&, void* const)
native final function RequestExEnchantSkill(int Type, int iID, int iLevel, int iSubLevel);

// Export UUIScript::execRequestObserverModeEnd(FFrame&, void* const)
native final function RequestObserverModeEnd();

// Export UUIScript::execGetHandle(FFrame&, void* const)
native final function WindowHandle GetHandle(string a_ControlID, optional WindowHandle a_ParentWnd, optional int a_CloneID);

// Export UUIScript::execFindHandle(FFrame&, void* const)
native final function WindowHandle FindHandle(string a_ControlID, optional WindowHandle a_ParentWnd, optional int a_CloneID);

// Export UUIScript::execGetAnimTextureHandle(FFrame&, void* const)
native final function AnimTextureHandle GetAnimTextureHandle(string a_ControlID);

// Export UUIScript::execGetBarHandle(FFrame&, void* const)
native final function BarHandle GetBarHandle(string a_ControlID);

// Export UUIScript::execGetButtonHandle(FFrame&, void* const)
native final function ButtonHandle GetButtonHandle(string a_ControlID);

// Export UUIScript::execGetChatWindowHandle(FFrame&, void* const)
native final function ChatWindowHandle GetChatWindowHandle(string a_ControlID);

// Export UUIScript::execGetCheckBoxHandle(FFrame&, void* const)
native final function CheckBoxHandle GetCheckBoxHandle(string a_ControlID);

// Export UUIScript::execGetComboBoxHandle(FFrame&, void* const)
native final function ComboBoxHandle GetComboBoxHandle(string a_ControlID);

// Export UUIScript::execGetDrawPanelHandle(FFrame&, void* const)
native final function DrawPanelHandle GetDrawPanelHandle(string a_ControlID);

// Export UUIScript::execGetEditBoxHandle(FFrame&, void* const)
native final function EditBoxHandle GetEditBoxHandle(string a_ControlID);

// Export UUIScript::execGetMultiEditBoxHandle(FFrame&, void* const)
native final function MultiEditBoxHandle GetMultiEditBoxHandle(string a_ControlID);

// Export UUIScript::execGetHtmlHandle(FFrame&, void* const)
native final function HtmlHandle GetHtmlHandle(string a_ControlID);

// Export UUIScript::execGetItemWindowHandle(FFrame&, void* const)
native final function ItemWindowHandle GetItemWindowHandle(string a_ControlID);

// Export UUIScript::execGetListBoxHandle(FFrame&, void* const)
native final function ListBoxHandle GetListBoxHandle(string a_ControlID);

// Export UUIScript::execGetListCtrlHandle(FFrame&, void* const)
native final function ListCtrlHandle GetListCtrlHandle(string a_ControlID);

// Export UUIScript::execGetRichListCtrlHandle(FFrame&, void* const)
native final function RichListCtrlHandle GetRichListCtrlHandle(string a_ControlID);

// Export UUIScript::execGetMinimapCtrlHandle(FFrame&, void* const)
native final function MinimapCtrlHandle GetMinimapCtrlHandle(string a_ControlID);

// Export UUIScript::execGetNameCtrlHandle(FFrame&, void* const)
native final function NameCtrlHandle GetNameCtrlHandle(string a_ControlID);

// Export UUIScript::execGetProgressCtrlHandle(FFrame&, void* const)
native final function ProgressCtrlHandle GetProgressCtrlHandle(string a_ControlID);

// Export UUIScript::execGetPropertyControllerHandle(FFrame&, void* const)
native final function PropertyControllerHandle GetPropertyControllerHandle(string a_ControlID);

// Export UUIScript::execGetRadarMapCtrlHandle(FFrame&, void* const)
native final function RadarMapCtrlHandle GetRadarMapCtrlHandle(string a_ControlID);

// Export UUIScript::execGetSliderCtrlHandle(FFrame&, void* const)
native final function SliderCtrlHandle GetSliderCtrlHandle(string a_ControlID);

// Export UUIScript::execGetStatusBarHandle(FFrame&, void* const)
native final function StatusBarHandle GetStatusBarHandle(string a_ControlID);

// Export UUIScript::execGetStatusRoundHandle(FFrame&, void* const)
native final function StatusRoundHandle GetStatusRoundHandle(string a_ControlID);

// Export UUIScript::execGetStatusIconHandle(FFrame&, void* const)
native final function StatusIconHandle GetStatusIconHandle(string a_ControlID);

// Export UUIScript::execGetTabHandle(FFrame&, void* const)
native final function TabHandle GetTabHandle(string a_ControlID);

// Export UUIScript::execGetTextBoxHandle(FFrame&, void* const)
native final function TextBoxHandle GetTextBoxHandle(string a_ControlID);

// Export UUIScript::execGetTextListBoxHandle(FFrame&, void* const)
native final function TextListBoxHandle GetTextListBoxHandle(string a_ControlID);

// Export UUIScript::execGetTextureHandle(FFrame&, void* const)
native final function TextureHandle GetTextureHandle(string a_ControlID);

// Export UUIScript::execGetTreeHandle(FFrame&, void* const)
native final function TreeHandle GetTreeHandle(string a_ControlID);

// Export UUIScript::execGetWindowHandle(FFrame&, void* const)
native final function WindowHandle GetWindowHandle(string a_ControlID);

// Export UUIScript::execGetEffectViewportWndHandle(FFrame&, void* const)
native final function EffectViewportWndHandle GetEffectViewportWndHandle(string a_ControlID);

// Export UUIScript::execGetCharacterViewportWindowHandle(FFrame&, void* const)
native final function CharacterViewportWindowHandle GetCharacterViewportWindowHandle(string a_ControlID);

// Export UUIScript::execGetSceneCameraCtrlHandle(FFrame&, void* const)
native final function SceneCameraCtrlHandle GetSceneCameraCtrlHandle(string a_ControlID);

// Export UUIScript::execGetSceneNpcCtrlHandle(FFrame&, void* const)
native final function SceneCameraCtrlHandle GetSceneNpcCtrlHandle(string a_ControlID);

// Export UUIScript::execGetScenePcCtrlHandle(FFrame&, void* const)
native final function SceneCameraCtrlHandle GetScenePcCtrlHandle(string a_ControlID);

// Export UUIScript::execGetSceneScreenCtrlHandle(FFrame&, void* const)
native final function SceneCameraCtrlHandle GetSceneScreenCtrlHandle(string a_ControlID);

// Export UUIScript::execGetSceneMusicCtrlHandle(FFrame&, void* const)
native final function SceneCameraCtrlHandle GetSceneMusicCtrlHandle(string a_ControlID);

// Export UUIScript::execGetWebBrowserHandle(FFrame&, void* const)
native final function WebBrowserHandle GetWebBrowserHandle(string controlID);

// Export UUIScript::execRequestProcureCropList(FFrame&, void* const)
native final function RequestProcureCropList(string param);

// Export UUIScript::execGetManorCount(FFrame&, void* const)
native final function int GetManorCount();

// Export UUIScript::execGetManorIDInManorList(FFrame&, void* const)
native final function int GetManorIDInManorList(int Index);

// Export UUIScript::execGetManorNameInManorList(FFrame&, void* const)
native final function string GetManorNameInManorList(int Index);

// Export UUIScript::execGetQuestLocation(FFrame&, void* const)
native final function bool GetQuestLocation(Vector Location);

// Export UUIScript::execShowMessageInLogin(FFrame&, void* const)
native final function ShowMessageInLogin(string Message);

// Export UUIScript::execInitCreditState(FFrame&, void* const)
native final function InitCreditState();

// Export UUIScript::execGetInterfaceDir(FFrame&, void* const)
native final function string GetInterfaceDir();

// Export UUIScript::execGetXMLControlString(FFrame&, void* const)
native final function string GetXMLControlString(UIEventManager.EXMLControlType Type);

// Export UUIScript::execGetXMLControlIndex(FFrame&, void* const)
native final function UIEventManager.EXMLControlType GetXMLControlIndex(string Type);

// Export UUIScript::execShowVirtualWindowBackground(FFrame&, void* const)
native final function ShowVirtualWindowBackground(bool bShow);

// Export UUIScript::execShowExampleAnimation(FFrame&, void* const)
native final function ShowExampleAnimation(bool bShow);

// Export UUIScript::execGetTrackerAttachedWindowList(FFrame&, void* const)
native final function GetTrackerAttachedWindowList(array<WindowHandle> a_WindowList);

// Export UUIScript::execGetTrackerAttachedWindow(FFrame&, void* const)
native final function WindowHandle GetTrackerAttachedWindow();

// Export UUIScript::execClearTracker(FFrame&, void* const)
native final function ClearTracker();

// Export UUIScript::execDeleteAttachedWindow(FFrame&, void* const)
native final function DeleteAttachedWindow();

// Export UUIScript::execExecuteAlign(FFrame&, void* const)
native final function ExecuteAlign(UIEventManager.ETrackerAlignType Type);

// Export UUIScript::execShowEnableTrackerBox(FFrame&, void* const)
native final function ShowEnableTrackerBox(bool bShow);

// Export UUIScript::execCreateNewCharacter(FFrame&, void* const)
native final function CreateNewCharacter();

// Export UUIScript::execGotoLogin(FFrame&, void* const)
native final function GotoLogin();

// Export UUIScript::execGotoServerList(FFrame&, void* const)
native final function GotoServerList();

// Export UUIScript::execStartGame(FFrame&, void* const)
native final function StartGame(int SelectedCharacter);

// Export UUIScript::execRequestCharacterSelect(FFrame&, void* const)
native final function RequestCharacterSelect(int Index);

// Export UUIScript::execGetSelectedCharacterInfo(FFrame&, void* const)
native function bool GetSelectedCharacterInfo(int Index, out UserInfo a_UserInfo);

// Export UUIScript::execRequestRestoreCharacter(FFrame&, void* const)
native final function RequestRestoreCharacter(int Index);

// Export UUIScript::execRequestDeleteCharacter(FFrame&, void* const)
native final function RequestDeleteCharacter(int Index);

// Export UUIScript::execResetCharacterPosition(FFrame&, void* const)
native final function ResetCharacterPosition();

// Export UUIScript::execIsScheduledToDeleteCharacter(FFrame&, void* const)
native function bool IsScheduledToDeleteCharacter(int Index);

// Export UUIScript::execIsDisciplineCharacter(FFrame&, void* const)
native function bool IsDisciplineCharacter(int Index);

// Export UUIScript::execSetSelectedCharacter(FFrame&, void* const)
native final function SetSelectedCharacter(int Index);

// Export UUIScript::execGetTimeToDeleteCharacter(FFrame&, void* const)
native function int GetTimeToDeleteCharacter(int Index);

// Export UUIScript::execGetTimeToDisciplineCharacter(FFrame&, void* const)
native function int GetTimeToDisciplineCharacter(int Index);

// Export UUIScript::execGetTimeToLastLogoutCharacter(FFrame&, void* const)
native function int GetTimeToLastLogoutCharacter(int Index);

// Export UUIScript::execIsActivateCharacter(FFrame&, void* const)
native function bool IsActivateCharacter(int Index);

// Export UUIScript::execRequestCreateCharacter(FFrame&, void* const)
native final function RequestCreateCharacter(string Name, int Race, int Job, int Sex, int HairType, int HairColor, int FaceType, UIEventManager.E_CHARACTER_COLOR eColor);

// Export UUIScript::execRequestPrevState(FFrame&, void* const)
native final function RequestPrevState();

// Export UUIScript::execSetDefaultCharacter(FFrame&, void* const)
native final function SetDefaultCharacter();

// Export UUIScript::execClearDefaultCharacterInfo(FFrame&, void* const)
native final function ClearDefaultCharacterInfo();

// Export UUIScript::execExecLobbyEvent(FFrame&, void* const)
native final function ExecLobbyEvent(string EventName, optional bool bReverse);

// Export UUIScript::execExecLobbyNextEvent(FFrame&, void* const)
native final function ExecLobbyNextEvent(string CurEventName, string NextEventName, optional bool bReverse);

// Export UUIScript::execGetClassDescription(FFrame&, void* const)
native function string GetClassDescription(int Index);

// Export UUIScript::execGetClassInitialStat(FFrame&, void* const)
native function array<int> GetClassInitialStat(int Index);

// Export UUIScript::execGetClassInitialStatEx(FFrame&, void* const)
native function array<int> GetClassInitialStatEx(int ClassType, int Race, int Sex);

// Export UUIScript::execShowDefaultCharacter(FFrame&, void* const)
native final function ShowDefaultCharacter(int Index, optional bool bRaceChanged);

// Export UUIScript::execSetCharacterStyle(FFrame&, void* const)
native final function SetCharacterStyle(int Index, int HairType, int HairColor, int FaceType);

// Export UUIScript::execSetCharacterColor(FFrame&, void* const)
native final function SetCharacterColor(UIEventManager.E_CHARACTER_COLOR eColor);

// Export UUIScript::execDefaultCharacterMouseTurn(FFrame&, void* const)
native final function DefaultCharacterMouseTurn(int Index, float ratio);

// Export UUIScript::execDefaultCharacterTurn(FFrame&, void* const)
native final function DefaultCharacterTurn(int Index, float ratio);

// Export UUIScript::execDefaultCharacterStop(FFrame&, void* const)
native final function DefaultCharacterStop(int Index);

// Export UUIScript::execCheckNameLength(FFrame&, void* const)
native function bool CheckNameLength(string Name);

// Export UUIScript::execCheckValidName(FFrame&, void* const)
native function bool CheckValidName(string Name);

// Export UUIScript::execCharacterCreateGetClassType(FFrame&, void* const)
native function int CharacterCreateGetClassType(int Race, int Job, int Sex);

// Export UUIScript::execRequestAllCastleInfo(FFrame&, void* const)
native final function RequestAllCastleInfo();

// Export UUIScript::execRequestAllFortressInfo(FFrame&, void* const)
native final function RequestAllFortressInfo();

// Export UUIScript::execRequestAllAgitInfo(FFrame&, void* const)
native final function RequestAllAgitInfo();

// Export UUIScript::execRequestFortressSiegeInfo(FFrame&, void* const)
native final function RequestFortressSiegeInfo();

// Export UUIScript::execRequestFortressMapInfo(FFrame&, void* const)
native final function RequestFortressMapInfo(int FortressID);

// Export UUIScript::execRequestPVPMatchRecord(FFrame&, void* const)
native final function RequestPVPMatchRecord();

// Export UUIScript::execRequestChangeNicknameNColor(FFrame&, void* const)
native final function RequestChangeNicknameNColor(int ColorIndex, string nickname, ItemID Id);

// Export UUIScript::execGetMaxNicknameColorIndexCnt(FFrame&, void* const)
native final function int GetMaxNicknameColorIndexCnt();

// Export UUIScript::execGetNicknameColorWithIndex(FFrame&, void* const)
native final function Color GetNicknameColorWithIndex(int ColorIndex);

// Export UUIScript::execRequestWithDrawPremiumItem(FFrame&, void* const)
native final function RequestWithDrawPremiumItem(int Index, INT64 Amount);

// Export UUIScript::execRequestStartShowCrataeCubeRank(FFrame&, void* const)
native final function RequestStartShowCrataeCubeRank();

// Export UUIScript::execRequestStopShowCrataeCubeRank(FFrame&, void* const)
native final function RequestStopShowCrataeCubeRank();

// Export UUIScript::execRequestJoinDominionWar(FFrame&, void* const)
native final function RequestJoinDominionWar(int DominionID, int Clan, int Join, int JoinID);

// Export UUIScript::execRequestDominionInfo(FFrame&, void* const)
native final function RequestDominionInfo();

// Export UUIScript::execGetDominionFlagIconTex(FFrame&, void* const)
native final function Texture GetDominionFlagIconTex(int DominionID);

// Export UUIScript::execRequestRefundItem(FFrame&, void* const)
native function RequestRefundItem(string param);

// Export UUIScript::execRequestSendPost(FFrame&, void* const)
native final function RequestSendPost(string receivedPerson, int safeMail, string Title, string contents, array<RequestItem> itemIDList, INT64 nAdena);

// Export UUIScript::execRequestRequestReceivedPostList(FFrame&, void* const)
native final function RequestRequestReceivedPostList();

// Export UUIScript::execRequestDeleteReceivedPost(FFrame&, void* const)
native final function RequestDeleteReceivedPost(array<int> deleteMailList);

// Export UUIScript::execRequestRequestReceivedPost(FFrame&, void* const)
native final function RequestRequestReceivedPost(int mailID);

// Export UUIScript::execRequestReceivePost(FFrame&, void* const)
native final function RequestReceivePost(int mailID);

// Export UUIScript::execRequestRejectPost(FFrame&, void* const)
native final function RequestRejectPost(int mailID);

// Export UUIScript::execRequestRequestSentPostList(FFrame&, void* const)
native final function RequestRequestSentPostList();

// Export UUIScript::execRequestDeleteSentPost(FFrame&, void* const)
native final function RequestDeleteSentPost(array<int> deleteMailList);

// Export UUIScript::execRequestRequestSentPost(FFrame&, void* const)
native final function RequestRequestSentPost(int mailID);

// Export UUIScript::execRequestCancelSentPost(FFrame&, void* const)
native final function RequestCancelSentPost(int mailID);

// Export UUIScript::execRequestPostItemList(FFrame&, void* const)
native final function RequestPostItemList();

// Export UUIScript::execRequestShowNewUserPetition(FFrame&, void* const)
native final function RequestShowNewUserPetition();

// Export UUIScript::execRequestShowStepTwo(FFrame&, void* const)
native final function RequestShowStepTwo(int categoryId);

// Export UUIScript::execRequestShowStepThree(FFrame&, void* const)
native final function RequestShowStepThree(int categoryId);

// Export UUIScript::execGetUseNewPetitionBool(FFrame&, void* const)
native final function bool GetUseNewPetitionBool();

// Export UUIScript::execGetPetitionMethod(FFrame&, void* const)
native final function UIScript.PetitionMethod GetPetitionMethod();

// Export UUIScript::execRequestShowPetitionAsMethod(FFrame&, void* const)
native final function RequestShowPetitionAsMethod();

// Export UUIScript::execRequestBuySellUIClose(FFrame&, void* const)
native final function RequestBuySellUIClose();

// Export UUIScript::execGetGameStateName(FFrame&, void* const)
native final function string GetGameStateName();

// Export UUIScript::execRequestBR_EventRankerList(FFrame&, void* const)
native function RequestBR_EventRankerList(int iEventID, int iDay, int iRanking);

// Export UUIScript::execRequestCreateRainEffect(FFrame&, void* const)
native final function RequestCreateRainEffect(int imode, int iEmitterposition);

// Export UUIScript::execRequestDeleteRainEffect(FFrame&, void* const)
native final function RequestDeleteRainEffect();

// Export UUIScript::execRequestSetWeatherEffect(FFrame&, void* const)
native final function RequestSetWeatherEffect(int iType);

// Export UUIScript::execRequestSetRainWeight(FFrame&, void* const)
native final function RequestSetRainWeight(float fmul);

// Export UUIScript::execRequestSetRainEmitterParticleNum(FFrame&, void* const)
native final function RequestSetRainEmitterParticleNum(float fmul);

// Export UUIScript::execRequestSetRainSpeed(FFrame&, void* const)
native final function RequestSetRainSpeed(float fmul);

// Export UUIScript::execRequestSetRainMeshScale(FFrame&, void* const)
native final function RequestSetRainMeshScale(Vector mul);

// Export UUIScript::execRequestCreateSnowEffect(FFrame&, void* const)
native final function RequestCreateSnowEffect(int imode, int iEmitterposition);

// Export UUIScript::execRequestDeleteSnowEffect(FFrame&, void* const)
native final function RequestDeleteSnowEffect();

// Export UUIScript::execRequestSetSnowWeight(FFrame&, void* const)
native final function RequestSetSnowWeight(float fmul);

// Export UUIScript::execRequestSetSnowEmitterParticleNum(FFrame&, void* const)
native final function RequestSetSnowEmitterParticleNum(float fmul);

// Export UUIScript::execRequestSetSnowSpeed(FFrame&, void* const)
native final function RequestSetSnowSpeed(float fmul);

// Export UUIScript::execRequestSetSnowMeshScale(FFrame&, void* const)
native final function RequestSetSnowMeshScale(Vector mul);

// Export UUIScript::execRequestChangeParticleEmitter(FFrame&, void* const)
native final function RequestChangeParticleEmitter(string emitterName);

// Export UUIScript::execRequestChangeDiamondMesh(FFrame&, void* const)
native final function RequestChangeDiamondMesh(string MeshName);

// Export UUIScript::execClearAllPrivateMarketInfo(FFrame&, void* const)
native final function ClearAllPrivateMarketInfo();

// Export UUIScript::execRefreshPrivateMarketInfo(FFrame&, void* const)
native final function RefreshPrivateMarketInfo();

// Export UUIScript::execRequestMoveToMerchant(FFrame&, void* const)
native final function RequestMoveToMerchant(int merchantId);

// Export UUIScript::execGetFilesInfoList(FFrame&, void* const)
native final function array<FileNameInfo> GetFilesInfoList(string filePath, array<string> arrFilExt);

// Export UUIScript::execGetDrivesInfoList(FFrame&, void* const)
native final function array<DriveInfo> GetDrivesInfoList();

// Export UUIScript::execAnswerCoupleAction(FFrame&, void* const)
native final function AnswerCoupleAction(int ActionID, int bOK, int requestUserID);

// Export UUIScript::execGetMydocumentPath(FFrame&, void* const)
native final function string GetMydocumentPath();

// Export UUIScript::execGetDesktopPath(FFrame&, void* const)
native final function string GetDesktopPath();

// Export UUIScript::execGetMyComputerPath(FFrame&, void* const)
native final function string GetMyComputerPath();

// Export UUIScript::execRequestPartyLootingModify(FFrame&, void* const)
native final function RequestPartyLootingModify(int scheme);

// Export UUIScript::execRequestPartyLootingModifyAgreement(FFrame&, void* const)
native final function RequestPartyLootingModifyAgreement(int agree);

// Export UUIScript::execRequestAskMemberShip(FFrame&, void* const)
native final function RequestAskMemberShip();

// Export UUIScript::execRequestAddExpandQuestAlarm(FFrame&, void* const)
native final function RequestAddExpandQuestAlarm(int QuestID);

// Export UUIScript::execGetRadioButtonHandle(FFrame&, void* const)
native final function RadioButtonHandle GetRadioButtonHandle(string a_ControlID);

// Export UUIScript::execOpenGivenURL(FFrame&, void* const)
native final function OpenGivenURL(string URL);

// Export UUIScript::execOpenL2Home(FFrame&, void* const)
native final function OpenL2Home();

// Export UUIScript::execRequestSetYCbCrConversionEffect(FFrame&, void* const)
native final function RequestSetYCbCrConversionEffect(bool Enable);

// Export UUIScript::execRequestSetYCbCrVal(FFrame&, void* const)
native final function RequestSetYCbCrVal(float fixCbCr, int PlayType, float yCOR1, float cbCOR1, float crCOR1, float yCOR2, float cbCOR2, float crCOR2, float YCbCrConsumingTime);

// Export UUIScript::execRequestSetHSVConversionEffect(FFrame&, void* const)
native final function RequestSetHSVConversionEffect(bool Enable);

// Export UUIScript::execRequestSetHSVVal(FFrame&, void* const)
native final function RequestSetHSVVal(float fixHS, int PlayType, float hCOR1, float sCOR1, float vCOR1, float hCOR2, float sCOR2, float vCOR2, float HSVConsumingTime);

// Export UUIScript::execRequestSetRGBConversionEffect(FFrame&, void* const)
native final function RequestSetRGBConversionEffect(bool Enable);

// Export UUIScript::execRequestSetRGBVal(FFrame&, void* const)
native final function RequestSetRGBVal(int PlayType, float rCOR1, float gCOR1, float bCOR1, float rCOR2, float gCOR2, float bCOR2, float RGBConsumingTime);

// Export UUIScript::execRequestSetColorGradingEffect(FFrame&, void* const)
native final function RequestSetColorGradingEffect(bool Enable);

// Export UUIScript::execRequestSetColorGradingVal(FFrame&, void* const)
native final function RequestSetColorGradingVal(int PlayType, string COR1, string COR2, float RGBConsumingTime);

// Export UUIScript::execRequestSetPostEffect(FFrame&, void* const)
native final function RequestSetPostEffect(bool Enable, int PostEffectID);

// Export UUIScript::execRequestPartyMatchWaitList(FFrame&, void* const)
native final function RequestPartyMatchWaitList(int a_Page, int a_MinLevel, int a_MaxLevel, int ClassRole, string Name);

// Export UUIScript::execRequestMenteeWaitingList(FFrame&, void* const)
native final function RequestMenteeWaitingList(int Page, int MinLevel, int MaxLevel);

// Export UUIScript::execSetMotionBlurUse(FFrame&, void* const)
native final function SetMotionBlurUse(bool bIsUse);

// Export UUIScript::execSetMotionBlurAlpha(FFrame&, void* const)
native final function SetMotionBlurAlpha(byte alphavalue);

// Export UUIScript::execToggleReplayRec(FFrame&, void* const)
native final function ToggleReplayRec();

// Export UUIScript::execRequestFinishNPCZoomCamera(FFrame&, void* const)
native final function RequestFinishNPCZoomCamera();

// Export UUIScript::execSetHDRRenderVal(FFrame&, void* const)
native final function SetHDRRenderVal(float FinalCoef, float GrayLum, float ClampMin, float ClampMax);

// Export UUIScript::execSetUseHDRRenderEffect(FFrame&, void* const)
native final function SetUseHDRRenderEffect(bool UseHDREffect);

// Export UUIScript::execRequestNatureRenderTime(FFrame&, void* const)
native final function RequestNatureRenderTime(float Time);

// Export UUIScript::execRequestNatureRenderIntensity(FFrame&, void* const)
native final function RequestNatureRenderIntensity(float Intensity);

// Export UUIScript::execRequestNatureRenderRayleigh(FFrame&, void* const)
native final function RequestNatureRenderRayleigh(float Rayleigh);

// Export UUIScript::execRequestNatureRenderMie(FFrame&, void* const)
native final function RequestNatureRenderMie(float Mie);

// Export UUIScript::execRequestNatureRenderTurbidity(FFrame&, void* const)
native final function RequestNatureRenderTurbidity(float Turbidity);

// Export UUIScript::execRequestNatureRenderDir(FFrame&, void* const)
native final function RequestNatureRenderDir(float Dir);

// Export UUIScript::execRequestNatureRenderBlendingRate(FFrame&, void* const)
native final function RequestNatureRenderBlendingRate(float BlendingRate);

// Export UUIScript::execGetActivityUltimateSkillLevel(FFrame&, void* const)
native final function int GetActivityUltimateSkillLevel();

// Export UUIScript::execGetTexture(FFrame&, void* const)
native final function Texture GetTexture(string Name);

// Export UUIScript::execRequestBR_CashShopNewICon(FFrame&, void* const)
native function RequestBR_CashShopNewICon();

// Export UUIScript::execRequestBR_GamePoint(FFrame&, void* const)
native function RequestBR_GamePoint();

// Export UUIScript::execRequestBR_ProductList(FFrame&, void* const)
native function RequestBR_ProductList(UIEventManager.EBR_CashShopProduct ProductType);

// Export UUIScript::execRequestBR_ProductInfo(FFrame&, void* const)
native function RequestBR_ProductInfo(int iProductID, bool bPresent);

// Export UUIScript::execRequestBR_BuyProduct(FFrame&, void* const)
native function RequestBR_BuyProduct(int iProductID, int iAmount);

// Export UUIScript::execRequestBR_RecentProductList(FFrame&, void* const)
native function RequestBR_RecentProductList();

// Export UUIScript::execRequestBR_AddBasketProductInfo(FFrame&, void* const)
native function RequestBR_AddBasketProductInfo(int iProductID);

// Export UUIScript::execRequestBR_DeleteBasketProductInfo(FFrame&, void* const)
native function RequestBR_DeleteBasketProductInfo(int iProductID);

// Export UUIScript::execRequestBR_PresentBuyProduct(FFrame&, void* const)
native function RequestBR_PresentBuyProduct(int iProductID, int iAmount, string strCharname, string strContent);

// Export UUIScript::execIsBr_CashShopCateory(FFrame&, void* const)
native function bool IsBr_CashShopCateory();

// Export UUIScript::execRequestBr_CashShopCateoryIndex(FFrame&, void* const)
native function bool RequestBr_CashShopCateoryIndex();

// Export UUIScript::execIsBr_CashShopPresent(FFrame&, void* const)
native function bool IsBr_CashShopPresent();

// Export UUIScript::execIsBr_CashShopCoinToMoney(FFrame&, void* const)
native function bool IsBr_CashShopCoinToMoney();

// Export UUIScript::execGetBr_CashShopCoinToMoneyValue(FFrame&, void* const)
native function float GetBr_CashShopCoinToMoneyValue();

// Export UUIScript::execIsBr_CashShopMainDisable(FFrame&, void* const)
native function bool IsBr_CashShopMainDisable();

// Export UUIScript::execRequestBR_MinigameLoadScores(FFrame&, void* const)
native function RequestBR_MinigameLoadScores();

// Export UUIScript::execRequestBR_MinigameInsertScore(FFrame&, void* const)
native function RequestBR_MinigameInsertScore(int iScore);

// Export UUIScript::execShowCashChargeWebSite(FFrame&, void* const)
native function ShowCashChargeWebSite();

// Export UUIScript::execIsUsingPrimeShop(FFrame&, void* const)
native function IsUsingPrimeShop();

// Export UUIScript::execBR_GetShowEventUI(FFrame&, void* const)
native function int BR_GetShowEventUI();

// Export UUIScript::execBR_ConvertTimeToStr(FFrame&, void* const)
native final function string BR_ConvertTimeToStr(int Time, int bOnlyDay);

// Export UUIScript::execBR_GetDayType(FFrame&, void* const)
native final function int BR_GetDayType(int Time, int Type);

// Export UUIScript::execGetFormattedTimeStrMMHH(FFrame&, void* const)
native final function string GetFormattedTimeStrMMHH(int Hour, int Minute);

// Export UUIScript::execRequestGoodsInventoryItemList(FFrame&, void* const)
native final function RequestGoodsInventoryItemList();

// Export UUIScript::execRequestGoodsInventoryItemDesc(FFrame&, void* const)
native final function RequestGoodsInventoryItemDesc(int Index);

// Export UUIScript::execRequestUseGoodsInventoryItem(FFrame&, void* const)
native final function RequestUseGoodsInventoryItem(int Index);

// Export UUIScript::execGetGoodsIconName(FFrame&, void* const)
native final function string GetGoodsIconName(int Index);

// Export UUIScript::execIsUseGoodsInvnentory(FFrame&, void* const)
native final function bool IsUseGoodsInvnentory();

// Export UUIScript::execRequestSecondaryAuthCreate(FFrame&, void* const)
native final function RequestSecondaryAuthCreate(string Password);

// Export UUIScript::execRequestSecondaryAuthVerify(FFrame&, void* const)
native final function RequestSecondaryAuthVerify(string Password);

// Export UUIScript::execRequestSecondaryAuthModify(FFrame&, void* const)
native final function RequestSecondaryAuthModify(string Password, string newPassword);

// Export UUIScript::execIsUseSecondaryAuth(FFrame&, void* const)
native final function bool IsUseSecondaryAuth();

// Export UUIScript::execIsUseEMailAccount(FFrame&, void* const)
native final function bool IsUseEMailAccount();

// Export UUIScript::execRequestCharacterNameCreatable(FFrame&, void* const)
native final function RequestCharacterNameCreatable(string charName);

// Export UUIScript::execRequestCrystallizeEstimate(FFrame&, void* const)
native final function RequestCrystallizeEstimate(ItemID ItemID, INT64 ItemCount);

// Export UUIScript::execGetShortcutString(FFrame&, void* const)
native final function GetShortcutString(int shortcutNum, out ShortcutCommandItem commandItem);

// Export UUIScript::execRequestPledgeWar(FFrame&, void* const)
native final function RequestPledgeWar(string PledgeName);

// Export UUIScript::execRequestSurrenderPledgeWar(FFrame&, void* const)
native final function RequestSurrenderPledgeWar(string sPledgeName);

// Export UUIScript::execIsL2NetLoginState(FFrame&, void* const)
native final function bool IsL2NetLoginState();

// Export UUIScript::execGetDynamicContentInfo(FFrame&, void* const)
native final function bool GetDynamicContentInfo(int Id, int Step, out DynamicContentInfo Info);

// Export UUIScript::execRequestDynamicQuestProgressInfo(FFrame&, void* const)
native final function RequestDynamicQuestProgressInfo(int Id, int Step);

// Export UUIScript::execRequestDynamicQuestScoreInfo(FFrame&, void* const)
native final function RequestDynamicQuestScoreInfo(int Id, int Step);

// Export UUIScript::execRequestDynamicContentHtml(FFrame&, void* const)
native final function RequestDynamicContentHtml(int Id, int Step);

// Export UUIScript::execGetSkillAvailability(FFrame&, void* const)
native final function int GetSkillAvailability(int Id, int Level, int SubLevel);

// Export UUIScript::execGetPawnType(FFrame&, void* const)
native final function UIScript.PawnType GetPawnType(int ServerID);

// Export UUIScript::execGetPawnNameFromServerID(FFrame&, void* const)
native final function string GetPawnNameFromServerID(int ServerID);

// Export UUIScript::execGetPawnLocFromServerID(FFrame&, void* const)
native final function Vector GetPawnLocFromServerID(int ServerID);

// Export UUIScript::execRequestTutorialQuestionMarkPressed(FFrame&, void* const)
native final function RequestTutorialQuestionMarkPressed(int iQuestionID);

// Export UUIScript::execRequestTutorialMarkPressed(FFrame&, void* const)
native final function RequestTutorialMarkPressed(int Type, int Id);

// Export UUIScript::execRequestAutoLogin(FFrame&, void* const)
native final function RequestAutoLogin();

// Export UUIScript::execIsNowMovieCapturing(FFrame&, void* const)
native final function bool IsNowMovieCapturing();

// Export UUIScript::execSetMovieCaptureResolution(FFrame&, void* const)
native final function SetMovieCaptureResolution(int W, int h);

// Export UUIScript::execMovieCaptureToggle(FFrame&, void* const)
native final function MovieCaptureToggle();

// Export UUIScript::execSetMovieCaptureHighQuality(FFrame&, void* const)
native final function SetMovieCaptureHighQuality();

// Export UUIScript::execSetMovieCaptureLowQuality(FFrame&, void* const)
native final function SetMovieCaptureLowQuality();

// Export UUIScript::execOpenMovieCaptureDir(FFrame&, void* const)
native final function OpenMovieCaptureDir();

// Export UUIScript::execGetDisplayHeight(FFrame&, void* const)
native final function int GetDisplayHeight();

// Export UUIScript::execGetDisplayWidth(FFrame&, void* const)
native final function int GetDisplayWidth();

// Export UUIScript::execGetL2Path(FFrame&, void* const)
native final function string GetL2Path();

// Export UUIScript::execGetMaxVitality(FFrame&, void* const)
native final function int GetMaxVitality();

// Export UUIScript::execExpFloat(FFrame&, void* const)
native final function float ExpFloat(float A, int Exp);

// Export UUIScript::execExpInt(FFrame&, void* const)
native final function int ExpInt(int A, int Exp);

// Export UUIScript::execRequestLogin(FFrame&, void* const)
native final function RequestLogin(string s_ID, string s_PassWD, int s_NCOTP);

// Export UUIScript::execRequestLoginServer(FFrame&, void* const)
native final function RequestLoginServer(int ServerID);

// Export UUIScript::execRequestSecurityCardLogin(FFrame&, void* const)
native final function RequestSecurityCardLogin(string SecurityNum);

// Export UUIScript::execRequestGoogleOtpLogin(FFrame&, void* const)
native final function RequestGoogleOtpLogin(string SecurityNum);

// Export UUIScript::execEulaAgree(FFrame&, void* const)
native final function EulaAgree(bool IsAgree);

// Export UUIScript::execRequestSortedServerInfo(FFrame&, void* const)
native final function RequestSortedServerInfo();

// Export UUIScript::execIsUseOTP(FFrame&, void* const)
native final function bool IsUseOTP();

// Export UUIScript::execRefuseLogin(FFrame&, void* const)
native final function RefuseLogin();

// Export UUIScript::execStopLogin(FFrame&, void* const)
native final function StopLogin();

// Export UUIScript::execAutoLogin(FFrame&, void* const)
native final function AutoLogin(int Server, int character);

// Export UUIScript::execSaveLastLoginID(FFrame&, void* const)
native final function SaveLastLoginID(string Id);

// Export UUIScript::execGetLastLoginID(FFrame&, void* const)
native final function string GetLastLoginID();

// Export UUIScript::execFullScreenMovieStart(FFrame&, void* const)
native final function FullScreenMovieStart();

// Export UUIScript::execFullScreenMovieEnd(FFrame&, void* const)
native final function FullScreenMovieEnd();

// Export UUIScript::execRequestFlyMoveStart(FFrame&, void* const)
native final function RequestFlyMoveStart();

// Export UUIScript::execRequestCardKeyLogin(FFrame&, void* const)
native final function RequestCardKeyLogin(string Pass);

// Export UUIScript::execRequestCardKeyLoginCancel(FFrame&, void* const)
native final function RequestCardKeyLoginCancel();

// Export UUIScript::execIsChinaClient(FFrame&, void* const)
native final function bool IsChinaClient();

// Export UUIScript::execIsNewChinaLive(FFrame&, void* const)
native final function bool IsNewChinaLive();

// Export UUIScript::execGetChinaPkString(FFrame&, void* const)
native final function string GetChinaPkString();

// Export UUIScript::execStartCredit(FFrame&, void* const)
native final function StartCredit();

// Export UUIScript::execEndCredit(FFrame&, void* const)
native final function EndCredit();

// Export UUIScript::execSetTestTerrainAmbientColor(FFrame&, void* const)
native final function SetTestTerrainAmbientColor(Color ambient);

// Export UUIScript::execSetTestActorAmbientColor(FFrame&, void* const)
native final function SetTestActorAmbientColor(Color ambient);

// Export UUIScript::execSetTestStaticMeshAmbientColor(FFrame&, void* const)
native final function SetTestStaticMeshAmbientColor(Color ambient);

// Export UUIScript::execSetTestBspAmbientColor(FFrame&, void* const)
native final function SetTestBspAmbientColor(Color ambient);

// Export UUIScript::execSetTestSkyBoxColor(FFrame&, void* const)
native final function SetTestSkyBoxColor(Color Col);

// Export UUIScript::execSetTestSkyBspAmbientColor(FFrame&, void* const)
native final function SetTestSkyBspAmbientColor(Color ambient);

// Export UUIScript::execSetTestHsvActorLightColor(FFrame&, void* const)
native final function SetTestHsvActorLightColor(Color LightColor);

// Export UUIScript::execSetTestHsvStaticMeshLightColor(FFrame&, void* const)
native final function SetTestHsvStaticMeshLightColor(Color LightColor);

// Export UUIScript::execSetTestHsvTerrainLightColor(FFrame&, void* const)
native final function SetTestHsvTerrainLightColor(Color LightColor);

// Export UUIScript::execSetTestGammaSetting(FFrame&, void* const)
native final function SetTestGammaSetting(float Brightness, float Contrast, float Gamma);

// Export UUIScript::execSetEnableTerrainAmbient(FFrame&, void* const)
native final function SetEnableTerrainAmbient(bool bEnable);

// Export UUIScript::execSetEnableActorAmbient(FFrame&, void* const)
native final function SetEnableActorAmbient(bool bEnable);

// Export UUIScript::execSetEnableStaticMeshAmbient(FFrame&, void* const)
native final function SetEnableStaticMeshAmbient(bool bEnable);

// Export UUIScript::execSetEnableBspAmbient(FFrame&, void* const)
native final function SetEnableBspAmbient(bool bEnable);

// Export UUIScript::execSetEnableSkyBoxColor(FFrame&, void* const)
native final function SetEnableSkyBoxColor(bool bEnable);

// Export UUIScript::execSetEnableSkyBspAmbient(FFrame&, void* const)
native final function SetEnableSkyBspAmbient(bool bEnable);

// Export UUIScript::execSetEnableHsvActorLight(FFrame&, void* const)
native final function SetEnableHsvActorLight(bool bEnable);

// Export UUIScript::execSetEnableHsvStaticMeshLight(FFrame&, void* const)
native final function SetEnableHsvStaticMeshLight(bool bEnable);

// Export UUIScript::execSetEnableHsvTerrainLight(FFrame&, void* const)
native final function SetEnableHsvTerrainLight(bool bEnable);

// Export UUIScript::execSetEnableGammaSetting(FFrame&, void* const)
native final function SetEnableGammaSetting(bool bEnable);

// Export UUIScript::execSetEnableWindowDefaultGamma(FFrame&, void* const)
native final function SetEnableWindowDefaultGamma(bool bEnable);

// Export UUIScript::execSetEnableGammaCorrection(FFrame&, void* const)
native final function SetEnableGammaCorrection(bool bEnable);

// Export UUIScript::execSetEnableLightMapIntensity(FFrame&, void* const)
native final function SetEnableLightMapIntensity(bool bEnable);

// Export UUIScript::execSetEnvTime(FFrame&, void* const)
native final function SetEnvTime(float Time);

// Export UUIScript::execSetTestBeastLightMapIntensity(FFrame&, void* const)
native final function SetTestBeastLightMapIntensity(float Intensity1, float Intensity2);

// Export UUIScript::execSetTestGodRayOption(FFrame&, void* const)
native final function SetTestGodRayOption(float GodRaySize, float GodRayBrightness, float GodRayEmit);

// Export UUIScript::execSetEnableGodRay(FFrame&, void* const)
native final function SetEnableGodRay(bool bEnable);

// Export UUIScript::execSelectChangeAttributeItem(FFrame&, void* const)
native final function SelectChangeAttributeItem(int GroupID, int ServerID);

// Export UUIScript::execRequestChangeAttributeItem(FFrame&, void* const)
native final function RequestChangeAttributeItem(int GroupID, int ServerID, int changeAttribute);

// Export UUIScript::execRequestChangeAttributeCancel(FFrame&, void* const)
native final function RequestChangeAttributeCancel();

// Export UUIScript::execSetClosingOnESC(FFrame&, void* const)
native function SetClosingOnESC();

// Export UUIScript::execHasStackableItemInWareHouse(FFrame&, void* const)
native final function bool HasStackableItemInWareHouse(int Type, int ItemID);

// Export UUIScript::execHasStackableItemInInventory(FFrame&, void* const)
native final function bool HasStackableItemInInventory(int Type, int ItemID);

// Export UUIScript::execRequestInzoneWaitingTime(FFrame&, void* const)
native final function RequestInzoneWaitingTime(optional bool bShowWindow);

// Export UUIScript::execIsNative(FFrame&, void* const)
native final function bool IsNative();

// Export UUIScript::execToUpper(FFrame&, void* const)
native final function string ToUpper(string Text);

// Export UUIScript::execToLower(FFrame&, void* const)
native final function string ToLower(string Text);

// Export UUIScript::execRequestJoinCuriousHouse(FFrame&, void* const)
native final function RequestJoinCuriousHouse();

// Export UUIScript::execRequestCancelCuriousHouse(FFrame&, void* const)
native final function RequestCancelCuriousHouse();

// Export UUIScript::execRequestLeaveCuriousHouse(FFrame&, void* const)
native final function RequestLeaveCuriousHouse();

// Export UUIScript::execRequestCuriousHouseHtml(FFrame&, void* const)
native final function RequestCuriousHouseHtml();

// Export UUIScript::execRequestObservingListCuriousHouse(FFrame&, void* const)
native final function RequestObservingListCuriousHouse();

// Export UUIScript::execRequestObservingCuriousHouse(FFrame&, void* const)
native final function RequestObservingCuriousHouse(int HouseID);

// Export UUIScript::execRequestLeaveObservingCuriousHouse(FFrame&, void* const)
native final function RequestLeaveObservingCuriousHouse();

// Export UUIScript::execIsActivedZoneQuestExist(FFrame&, void* const)
native final function bool IsActivedZoneQuestExist();

// Export UUIScript::execIsActivedCampaignExist(FFrame&, void* const)
native final function bool IsActivedCampaignExist();

// Export UUIScript::execAmILeader(FFrame&, void* const)
native final function bool AmILeader();

// Export UUIScript::execSetAlwaysOnBack(FFrame&, void* const)
native final function SetAlwaysOnBack(bool bAlwaysOnBack);

// Export UUIScript::execCallGFxFunction(FFrame&, void* const)
native final function CallGFxFunction(string WindowName, string functionName, string param);

// Export UUIScript::execConvertBRCashShopDayWeek(FFrame&, void* const)
native final function string ConvertBRCashShopDayWeek(int iDayWeek);

// Export UUIScript::execIsActivedBRCampaignExist(FFrame&, void* const)
native final function bool IsActivedBRCampaignExist();

// Export UUIScript::execGetEventContentInfo(FFrame&, void* const)
native final function bool GetEventContentInfo(int Id, int Step, int GoalGroupID, out EventContentInfo Info);

// Export UUIScript::execRequestEventCampaignProgressInfo(FFrame&, void* const)
native final function RequestEventCampaignProgressInfo(int Id, int Step, int GoalGroupID);

// Export UUIScript::execRequestEventCampaignScoreInfo(FFrame&, void* const)
native final function RequestEventCampaignScoreInfo(int Id, int Step, int GoalGroupID);

// Export UUIScript::execRequestEventCampaignHtml(FFrame&, void* const)
native final function RequestEventCampaignHtml(int Id, int Step, int GoalGroupID);

// Export UUIScript::execGetUIUserPremiumLevel(FFrame&, void* const)
native final function int GetUIUserPremiumLevel();

// Export UUIScript::execResponsePetitionAlarm(FFrame&, void* const)
native final function ResponsePetitionAlarm();

// Export UUIScript::execAddTimeData(FFrame&, void* const)
native final function int AddTimeData(string Name);

// Export UUIScript::execMeasureTimeOn(FFrame&, void* const)
native final function MeasureTimeOn(int Id);

// Export UUIScript::execMeasureTimeOff(FFrame&, void* const)
native final function MeasureTimeOff(int Id);

// Export UUIScript::execMeasureTimeStart(FFrame&, void* const)
native final function MeasureTimeStart(int Id);

// Export UUIScript::execMeasureTimeEnd(FFrame&, void* const)
native final function MeasureTimeEnd(int Id);

// Export UUIScript::execIsPlayerOnWorldRaidServer(FFrame&, void* const)
native final function bool IsPlayerOnWorldRaidServer();

// Export UUIScript::execGetReleaseMode(FFrame&, void* const)
native final function UIScript.ReleaseMode GetReleaseMode();

// Export UUIScript::execEnableChatWndResizing(FFrame&, void* const)
native final function EnableChatWndResizing(bool bEnable);

// Export UUIScript::execGetChatColorByType(FFrame&, void* const)
native final function Color GetChatColorByType(int Type);

// Export UUIScript::execGetChatSubColorByType(FFrame&, void* const)
native final function Color GetChatSubColorByType(int Type);

// Export UUIScript::execChatNotificationFilter(FFrame&, void* const)
native final function int ChatNotificationFilter(out string processedMsg, string orignalMsg, string keyword0, string keyword1, string keyword2, string keyword3);

// Export UUIScript::execSetChatMessage(FFrame&, void* const)
native final function SetChatMessage(string a_Message, optional bool IsAppend);

// Export UUIScript::execProcessChatMessage(FFrame&, void* const)
native final function ProcessChatMessage(string chatMessage, optional UIEventManager.SayPacketType SayType, optional bool bStopMacro, optional bool bSharedPosition);

// Export UUIScript::execGetChatPrefix(FFrame&, void* const)
native function string GetChatPrefix(UIEventManager.SayPacketType SayType);

// Export UUIScript::execIsSameChatPrefix(FFrame&, void* const)
native function bool IsSameChatPrefix(UIEventManager.SayPacketType SayType, string InputPrefix);

// Export UUIScript::execProcessPetitionChatMessage(FFrame&, void* const)
native final function ProcessPetitionChatMessage(string a_strChatMsg);

// Export UUIScript::execProcessPartyMatchChatMessage(FFrame&, void* const)
native final function ProcessPartyMatchChatMessage(UIEventManager.SayPacketType SayType, string a_strChatMsg);

// Export UUIScript::execProcessCommandChatMessage(FFrame&, void* const)
native final function ProcessCommandChatMessage(string a_strChatMsg);

// Export UUIScript::execProcessCommandInterPartyChatMessage(FFrame&, void* const)
native final function ProcessCommandInterPartyChatMessage(string a_strChatMsg);

// Export UUIScript::execSwitchSingleMeshMode(FFrame&, void* const)
native final function SwitchSingleMeshMode(bool bUse);

// Export UUIScript::execGetLoginMapType(FFrame&, void* const)
native final function int GetLoginMapType();

// Export UUIScript::execIsActivateUSMBackground(FFrame&, void* const)
native final function bool IsActivateUSMBackground(int a_ServerType);

// Export UUIScript::execRequestAlchemySkillList(FFrame&, void* const)
native final function RequestAlchemySkillList();

// Export UUIScript::execGetAlchemySkillGradeType(FFrame&, void* const)
native final function int GetAlchemySkillGradeType(int SkillID, int SkillLevel);

// Export UUIScript::execGetServerType(FFrame&, void* const)
native final function int GetServerType();

// Export UUIScript::execIsBloodyServer(FFrame&, void* const)
native final function bool IsBloodyServer();

// Export UUIScript::execIsAdenServer(FFrame&, void* const)
native final function bool IsAdenServer();

// Export UUIScript::execRefreshRecipeOfferingRate(FFrame&, void* const)
native final function int RefreshRecipeOfferingRate(INT64 TotalDP, bool bIsShop);

// Export UUIScript::execRequestAttendanceCheck(FFrame&, void* const)
native final function RequestAttendanceCheck();

// Export UUIScript::execRequestAttendanceWndOpen(FFrame&, void* const)
native final function RequestAttendanceWndOpen();

// Export UUIScript::execIsAttendanceSystemEnable(FFrame&, void* const)
native final function bool IsAttendanceSystemEnable();

// Export UUIScript::execGetCaptchaImageTex(FFrame&, void* const)
native final function Texture GetCaptchaImageTex();

// Export UUIScript::execRequestRefreshCaptchaImage(FFrame&, void* const)
native final function RequestRefreshCaptchaImage(INT64 Id);

// Export UUIScript::execRequestCaptchaAnswer(FFrame&, void* const)
native final function RequestCaptchaAnswer(INT64 Id, int AnswerCode);

// Export UUIScript::execIsUsePrivateStore(FFrame&, void* const)
native final function bool IsUsePrivateStore();

// Export UUIScript::execCrossEnterEventRoom(FFrame&, void* const)
native final function CrossEnterEventRoom();

// Export UUIScript::execQTRequestEnterPartyRoom(FFrame&, void* const)
native final function QTRequestEnterPartyRoom();

// Export UUIScript::execQTRequestBindClanRoom(FFrame&, void* const)
native final function QTRequestBindClanRoom();

// Export UUIScript::execQTRequestEnterClanRoom(FFrame&, void* const)
native final function QTRequestEnterClanRoom();

// Export UUIScript::execQTRequestGetCurRoomInfo(FFrame&, void* const)
native final function QTRequestGetCurRoomInfo();

// Export UUIScript::execRequestTodoListRecommand(FFrame&, void* const)
native final function RequestTodoListRecommand(bool allLevel);

// Export UUIScript::execRequestTodoListInzone(FFrame&, void* const)
native final function RequestTodoListInzone(bool allLevel);

// Export UUIScript::execRequestTodoListHTML(FFrame&, void* const)
native final function RequestTodoListHTML(int listType, string typeID);

// Export UUIScript::execRequestOneDayRewardReceive(FFrame&, void* const)
native final function RequestOneDayRewardReceive(int ServerID);

// Export UUIScript::execRequestOneDayRewardItemList(FFrame&, void* const)
native final function RequestOneDayRewardItemList(int rewardID);

// Export UUIScript::execRequestOneDayRewardDesc(FFrame&, void* const)
native final function string RequestOneDayRewardDesc(int rewardID);

// Export UUIScript::execRequestOneDayRewardPeriod(FFrame&, void* const)
native final function string RequestOneDayRewardPeriod(int rewardID);

// Export UUIScript::execRequestTodoListOneDayReward(FFrame&, void* const)
native final function RequestTodoListOneDayReward();

// Export UUIScript::execIsUseToDoList(FFrame&, void* const)
native final function bool IsUseToDoList();

// Export UUIScript::execRequestCastleWarSeasonReward(FFrame&, void* const)
native final function RequestCastleWarSeasonReward(int SeasonCastleID);

// Export UUIScript::execRequestUserFactionInfo(FFrame&, void* const)
native final function RequestUserFactionInfo(UIEventManager.EFactionRequsetType eType, int nUserServerID);

// Export UUIScript::execGetUserFactionInfoList(FFrame&, void* const)
native final function GetUserFactionInfoList(int nUserServerID, out array<L2UserFactionUIInfo> arrFactionInfoList);

// Export UUIScript::execGetFactionData(FFrame&, void* const)
native final function GetFactionData(int nFactionID, out L2FactionUIData FactionData);

// Export UUIScript::execGetMonsterBookIDs(FFrame&, void* const)
native final function GetMonsterBookIDs(out array<int> MonsterBookIDs);

// Export UUIScript::execGetMonsterBookData(FFrame&, void* const)
native final function GetMonsterBookData(int nMonsterBookID, out L2MonsterBookUIData MonsterData);

// Export UUIScript::execClipboardCopy(FFrame&, void* const)
native final function ClipboardCopy(string Str);

// Export UUIScript::execClipboardPaste(FFrame&, void* const)
native final function string ClipboardPaste();

// Export UUIScript::execStringIntoArray(FFrame&, void* const)
native final function StringIntoArray(string Str, string delim, out array<string> tokens);

// Export UUIScript::execStringMatching(FFrame&, void* const)
native final function bool StringMatching(string Str, string pattern, string delim);

// Export UUIScript::execappRound(FFrame&, void* const)
native function int appRound(float Value);

// Export UUIScript::execappFloor(FFrame&, void* const)
native function int appFloor(float Value);

// Export UUIScript::execappCeil(FFrame&, void* const)
native function int appCeil(float Value);

// Export UUIScript::execappFractional(FFrame&, void* const)
native function float appFractional(float Value);

// Export UUIScript::execSoulShotSlotSelected(FFrame&, void* const)
native final function SoulShotSlotSelected(int Type, int iClassID);

// Export UUIScript::execSoulShotSlotClicked(FFrame&, void* const)
native final function SoulShotSlotClicked(int Type, int iClassID);

// Export UUIScript::execGetAutoEquipShotList(FFrame&, void* const)
native final function GetAutoEquipShotList(int Type, out array<ItemInfo> arrShotItemList);

// Export UUIScript::execIsUseAutoEquipSoulShot(FFrame&, void* const)
native final function bool IsUseAutoEquipSoulShot();

// Export UUIScript::execIsUseSteam(FFrame&, void* const)
native final function bool IsUseSteam();

// Export UUIScript::execIsUseTokenLogin(FFrame&, void* const)
native final function bool IsUseTokenLogin();

// Export UUIScript::execCashShopCoinChargeForSteam(FFrame&, void* const)
native final function bool CashShopCoinChargeForSteam();

// Export UUIScript::execPledgeBonusOpen(FFrame&, void* const)
native final function PledgeBonusOpen();

// Export UUIScript::execPledgeBonusReward(FFrame&, void* const)
native final function PledgeBonusReward(int Type_);

// Export UUIScript::execPledgeBonusRewardList(FFrame&, void* const)
native final function PledgeBonusRewardList();

// Export UUIScript::execIsUsePledgeBonus(FFrame&, void* const)
native final function bool IsUsePledgeBonus();

// Export UUIScript::execCancelWaitingQueueTicket(FFrame&, void* const)
native final function CancelWaitingQueueTicket();

// Export UUIScript::execRequestBlockListForAD(FFrame&, void* const)
native final function RequestBlockListForAD(string charName, string ChatMsg);

// Export UUIScript::execGetMinimapRegionIconData(FFrame&, void* const)
native final function bool GetMinimapRegionIconData(int nRegionID, out MinimapRegionIconData IconData);

// Export UUIScript::execGetEventAlarmDataCount(FFrame&, void* const)
native final function int GetEventAlarmDataCount();

// Export UUIScript::execGetEventAlarmDataByIndex(FFrame&, void* const)
native final function GetEventAlarmDataByIndex(int Index, out EventAlarmUIData EventData);

// Export UUIScript::execRequestAccountAttendanceReward(FFrame&, void* const)
native final function RequestAccountAttendanceReward(byte cRewardType);

// Export UUIScript::execRequestAccountAttendanceInfo(FFrame&, void* const)
native final function RequestAccountAttendanceInfo();

// Export UUIScript::execRequestEntireCardRewardList(FFrame&, void* const)
native final function RequestEntireCardRewardList();

// Export UUIScript::execRequestCardReward(FFrame&, void* const)
native final function RequestCardReward(int Id);

// Export UUIScript::execRequestUserBanInfo(FFrame&, void* const)
native final function RequestUserBanInfo(int UserID);

// Export UUIScript::execCardUpdownGamePickNumber(FFrame&, void* const)
native final function CardUpdownGamePickNumber(int nNumber);

// Export UUIScript::execCardUpdownGameRewardRequest(FFrame&, void* const)
native final function CardUpdownGameRewardRequest();

// Export UUIScript::execCardUpdownGameRetry(FFrame&, void* const)
native final function CardUpdownGameRetry();

// Export UUIScript::execCardUpdownGameQuit(FFrame&, void* const)
native final function CardUpdownGameQuit();

// Export UUIScript::execGetAgathionMainSkillList(FFrame&, void* const)
native final function int GetAgathionMainSkillList(int a_iClassID, int a_iEnchanted, out array<SkillInfo> mainSkillList);

// Export UUIScript::execGetAgathionSubSkillList(FFrame&, void* const)
native final function int GetAgathionSubSkillList(int a_iClassID, int a_iEnchanted, out array<SkillInfo> subSkillList);

// Export UUIScript::execRequestSwapAgathionSlotItems(FFrame&, void* const)
native final function RequestSwapAgathionSlotItems(INT64 SrcSlotBitType, ItemID SrcID, INT64 DesSlotBitType, ItemID DesID);

// Export UUIScript::execGetTutorialIndices(FFrame&, void* const)
native final function GetTutorialIndices(out array<TutorialIndex> arrTutorialIndices);

// Export UUIScript::execGetTutorialBody(FFrame&, void* const)
native final function bool GetTutorialBody(int Id, int Level, out TutorialBody outBody);

// Export UUIScript::execGetPledgeMissionData(FFrame&, void* const)
native final function bool GetPledgeMissionData(int nMissionID, out PledgeMissionUIData pledgeMissionData);

// Export UUIScript::execRequestPledgeMissionInfo(FFrame&, void* const)
native final function RequestPledgeMissionInfo();

// Export UUIScript::execRequestPledgeMissionReward(FFrame&, void* const)
native final function RequestPledgeMissionReward(int nMissionID);

// Export UUIScript::execRequestCreatePledge(FFrame&, void* const)
native final function RequestCreatePledge(string Name);

// Export UUIScript::execRequestPledgeItemList(FFrame&, void* const)
native final function RequestPledgeItemList();

// Export UUIScript::execRequestPledgeItemInfo(FFrame&, void* const)
native final function RequestPledgeItemInfo(int nItemClassID);

// Export UUIScript::execRequestPledgeItemActivate(FFrame&, void* const)
native final function RequestPledgeItemActivate(int nItemClassID);

// Export UUIScript::execRequestPledgeItemBuy(FFrame&, void* const)
native final function RequestPledgeItemBuy(int nItemClassID, int nAmount);

// Export UUIScript::execGetPledgeMasteryName(FFrame&, void* const)
native final function string GetPledgeMasteryName(int nPledgeMasteryID);

// Export UUIScript::execRequestElementalSpiritInfo(FFrame&, void* const)
native final function RequestElementalSpiritInfo(int nIsOpen);

// Export UUIScript::execGetElementalSpiritExpData(FFrame&, void* const)
native final function GetElementalSpiritExpData(int nType, int nEvolLevel, int nSpiritLevel, out INT64 ExpValue);

// Export UUIScript::execFlashWindow(FFrame&, void* const)
native final function FlashWindow();

// Export UUIScript::execRequestOlympiadRecord(FFrame&, void* const)
native final function RequestOlympiadRecord();

// Export UUIScript::execShowQuestInfoWindow(FFrame&, void* const)
native final function ShowQuestInfoWindow();

// Export UUIScript::execRequestEnchantArtifact(FFrame&, void* const)
native final function RequestEnchantArtifact(int Artifact, array<int> Materials);

// Export UUIScript::execRequestPurchaseLimitShopItemList(FFrame&, void* const)
native final function RequestPurchaseLimitShopItemList(int nShopIndex);

// Export UUIScript::execRequestPurchaseLimitShopItemBuy(FFrame&, void* const)
native final function RequestPurchaseLimitShopItemBuy(int nShopIndex, int nItemClassID, int nItemAmount);

// Export UUIScript::execGetSubTitle(FFrame&, void* const)
native final function GetSubTitle(int EventID, int GroupID, out string strSubTitle);

// Export UUIScript::execGetRewardCardTexName(FFrame&, void* const)
native final function GetRewardCardTexName(int EventID, int GroupID, int ItemID, out string strTexName);

// Export UUIScript::execIsUseCostume(FFrame&, void* const)
native final function bool IsUseCostume();

// Export UUIScript::execRequestFestivalInfo(FFrame&, void* const)
native final function bool RequestFestivalInfo(bool IsUIOpen);

// Export UUIScript::execRequestFestivalGame(FFrame&, void* const)
native final function bool RequestFestivalGame();

// Export UUIScript::execRequestOpenWndWithoutNPC(FFrame&, void* const)
native final function RequestOpenWndWithoutNPC(UIEventManager.HTML_OPEN_TYPE iType);

// Export UUIScript::execRequestMagicLampGameInfo(FFrame&, void* const)
native final function RequestMagicLampGameInfo(int GameMode);

// Export UUIScript::execRequestMagicLampGameStart(FFrame&, void* const)
native final function RequestMagicLampGameStart(int GameMode, int GameCount);

// Export UUIScript::execRequestPaybackList(FFrame&, void* const)
native final function RequestPaybackList(int nPaybackEventIdType);

// Export UUIScript::execRequestPaybackGiveReward(FFrame&, void* const)
native final function RequestPaybackGiveReward(int nPaybackEventIdType, int nSetIndex);

// Export UUIScript::execSelectCounterAttackTarget(FFrame&, void* const)
native final function SelectCounterAttackTarget();

// Export UUIScript::execResetCounterAttackList(FFrame&, void* const)
native final function ResetCounterAttackList();

// Export UUIScript::execUpdateAutoplaySetting(FFrame&, void* const)
native final function UpdateAutoplaySetting(AutoplaySettingData Settings);

// Export UUIScript::execGetLCoinShopProductData(FFrame&, void* const)
native final function bool GetLCoinShopProductData(int nProductID, out LCoinShopProductUIData productData);

// Export UUIScript::execGetLCoinShopBannerData(FFrame&, void* const)
native final function GetLCoinShopBannerData(out array<LCoinShopBannerUIData> arrBannerData);

// Export UUIScript::execGetPledgeShopProductData(FFrame&, void* const)
native final function bool GetPledgeShopProductData(int nShopIndex, int nProductID, out PledgeShopProductUIData productData);

// Export UUIScript::execGetGachaShopData(FFrame&, void* const)
native final function bool GetGachaShopData(int nShopID, out L2GachaShopUIData shopData);

// Export UUIScript::execGetGachaShopGroupData(FFrame&, void* const)
native final function bool GetGachaShopGroupData(int nShopID, int nGroupID, out L2GachaShopGroupUIData groupData);

// Export UUIScript::execGetGachaShopGroupDataAll(FFrame&, void* const)
native final function bool GetGachaShopGroupDataAll(int nShopID, out array<L2GachaShopGroupUIData> arrGroupData);

// Export UUIScript::execRequestGachaShopInfo(FFrame&, void* const)
native final function RequestGachaShopInfo();

// Export UUIScript::execRequestGachaShopGachaGroup(FFrame&, void* const)
native final function RequestGachaShopGachaGroup(int nShopID);

// Export UUIScript::execRequestGachaShopGachaItem(FFrame&, void* const)
native final function RequestGachaShopGachaItem(int nShopID, int nGroupID);

// Export UUIScript::execRequestTimeRestrictFieldList(FFrame&, void* const)
native final function RequestTimeRestrictFieldList();

// Export UUIScript::execRequestEnterTimeRestrictField(FFrame&, void* const)
native final function RequestEnterTimeRestrictField(int FiedlId);

// Export UUIScript::execGetTimeRestrictFieldInfo(FFrame&, void* const)
native final function bool GetTimeRestrictFieldInfo(int FieldId, out TimeRestrictFieldUIData fieldInfo);

// Export UUIScript::execRequestRankingCharInfo(FFrame&, void* const)
native final function RequestRankingCharInfo();

// Export UUIScript::execRequestRankingCharRankers(FFrame&, void* const)
native final function RequestRankingCharRankers(UIEventManager.RankingGroup eRankingGroup, UIEventManager.RankingScope eRankingScope, int iRace, optional int iClass);

// Export UUIScript::execGetRankingRewardSkillID(FFrame&, void* const)
native final function int GetRankingRewardSkillID(UIEventManager.RankingType eRankingType, UIEventManager.RankingGroup eRankingGroup, int Grade);

// Export UUIScript::execGetRankingGrade(FFrame&, void* const)
native final function int GetRankingGrade(UIEventManager.RankingType eRankingType, UIEventManager.RankingGroup eRankingGroup, int Ranking);

// Export UUIScript::execRequestMyRankingHistory(FFrame&, void* const)
native final function RequestMyRankingHistory();

// Export UUIScript::execIsFinalRelease(FFrame&, void* const)
native function bool IsFinalRelease();

// Export UUIScript::execIsTencentLoginSystem(FFrame&, void* const)
native function bool IsTencentLoginSystem();

// Export UUIScript::execRequestAuthLoginForTCLS(FFrame&, void* const)
native function bool RequestAuthLoginForTCLS();

// Export UUIScript::execGetLetterCollectData(FFrame&, void* const)
native final function int GetLetterCollectData(out array<LetterCollectUIData> arrLetterCollectUIData);

// Export UUIScript::execGetStatBonusNameData(FFrame&, void* const)
native final function int GetStatBonusNameData(out array<StatBonusNameUIData> arrStatBonusNameUIData);

// Export UUIScript::execGetStatBonusResetData(FFrame&, void* const)
native final function int GetStatBonusResetData(int nResetPoint, out array<RequestItem> arrStatBonusResetUIData);

// Export UUIScript::execGetLevelUpItemPhysicalDamageBonus(FFrame&, void* const)
native final function int GetLevelUpItemPhysicalDamageBonus(int ClassID, int PlayerLevel);

// Export UUIScript::execGetLevelUpItemMagicalDamageBonus(FFrame&, void* const)
native final function int GetLevelUpItemMagicalDamageBonus(int ClassID, int PlayerLevel);

// Export UUIScript::execGetLevelUpItemPhysicalDefenseBonus(FFrame&, void* const)
native final function int GetLevelUpItemPhysicalDefenseBonus(int ClassID, int PlayerLevel);

// Export UUIScript::execGetLevelUpItemMagicalDefenseBonus(FFrame&, void* const)
native final function int GetLevelUpItemMagicalDefenseBonus(int ClassID, int PlayerLevel);

// Export UUIScript::execUseContents(FFrame&, void* const)
native final function bool UseContents(string ContentsName);

// Export UUIScript::execRequestMPlayerPush(FFrame&, void* const)
native final function RequestMPlayerPush(int Category, string Msg);

// Export UUIScript::execIsDeathKnightClass(FFrame&, void* const)
native final function bool IsDeathKnightClass(int OriginalClassID);

// Export UUIScript::execIsDeathFighterClass(FFrame&, void* const)
native final function bool IsDeathFighterClass(int OriginalClassID);

// Export UUIScript::execIsOrcRiderClass(FFrame&, void* const)
native final function bool IsOrcRiderClass(int OriginalClassID);

// Export UUIScript::execIsAssassinClass(FFrame&, void* const)
native final function bool IsAssassinClass(int OriginalClassID);

// Export UUIScript::execGetSharedPositionData(FFrame&, void* const)
native final function GetSharedPositionData(out SharedPositionData Data);

// Export UUIScript::execSetMPlayerClientVar(FFrame&, void* const)
native final function SetMPlayerClientVar(string Name, string Var);

// Export UUIScript::execGetMableGameCellData(FFrame&, void* const)
native final function bool GetMableGameCellData(int CellID, out MableGameCellData Data);

// Export UUIScript::execGetMableGameEventData(FFrame&, void* const)
native final function bool GetMableGameEventData(int CellID, UIEventManager.MableGameEventType EventType, out MableGameEventData Data);

// Export UUIScript::execGetMaxElixir(FFrame&, void* const)
native final function int GetMaxElixir();

// Export UUIScript::execGetMagicLampMaxCharge(FFrame&, void* const)
native final function int GetMagicLampMaxCharge(int Level);

// Export UUIScript::execGetPledgeDonationData(FFrame&, void* const)
native final function bool GetPledgeDonationData(int DonationType, out PledgeDonationData Data);

// Export UUIScript::execRequestEnemyPledgeRegister(FFrame&, void* const)
native final function RequestEnemyPledgeRegister();

// Export UUIScript::execConvertWorldStrToID(FFrame&, void* const)
native final function string ConvertWorldStrToID(string worldstr);

// Export UUIScript::execConvertWorldIDToStr(FFrame&, void* const)
native final function string ConvertWorldIDToStr(string worldstr);

// Export UUIScript::execGetPledgeLevelData(FFrame&, void* const)
native final function bool GetPledgeLevelData(int PledgeLevel, out PledgeLevelData Data);

// Export UUIScript::execStartLoginState(FFrame&, void* const)
native final function bool StartLoginState();

// Export UUIScript::execLoginWaitState(FFrame&, void* const)
native final function bool LoginWaitState();

// Export UUIScript::execRequestRankingFestivalBonus(FFrame&, void* const)
native final function bool RequestRankingFestivalBonus(array<int> nPoints);

// Export UUIScript::execGetSteadyBoxString(FFrame&, void* const)
native final function bool GetSteadyBoxString(int nEventID, out string Type, out string Title, out string Desc);

// Export UUIScript::execGetSteadyBoxSlotInfo(FFrame&, void* const)
native final function GetSteadyBoxSlotInfo(int nSlotIndex, out int ItemID, out int Amount);

// Export UUIScript::execGetCollectionData(FFrame&, void* const)
native final function bool GetCollectionData(int collection_ID, out CollectionData Data);

// Export UUIScript::execGetCollectionMainData(FFrame&, void* const)
native final function bool GetCollectionMainData(int main_id, out CollectionMainData Data);

// Export UUIScript::execGetCollectionIdByItemName(FFrame&, void* const)
native final function bool GetCollectionIdByItemName(out array<int> collectionid, int Category, bool onlyComplete, bool onlyNotComplete, optional bool favorite, optional string ItemName, optional string optionName, optional bool onlyProgress);

// Export UUIScript::execGetCollectionIdByItemId(FFrame&, void* const)
native final function bool GetCollectionIdByItemId(out array<int> collectionid, int ItemID);

// Export UUIScript::execIsCollectionRegistEnableItem(FFrame&, void* const)
native final function bool IsCollectionRegistEnableItem(ItemID sID, optional int collectionid, optional int SlotID);

// Export UUIScript::execIsCollectionRegistEnableItemWithReason(FFrame&, void* const)
native final function bool IsCollectionRegistEnableItemWithReason(ItemID sID, int collectionid, int SlotID, out UIScript.CollectionRegistFailReason Reason);

// Export UUIScript::execGetCollectionInfo(FFrame&, void* const)
native final function bool GetCollectionInfo(int collection_ID, out CollectionInfo Info);

// Export UUIScript::execGetCollectionCount(FFrame&, void* const)
native final function bool GetCollectionCount(int Category, out CollectionCount Count);

// Export UUIScript::execGetCollectionOption(FFrame&, void* const)
native final function bool GetCollectionOption(out array<CollectionOption> Option);

// Export UUIScript::execGetCompletePeriodCollection(FFrame&, void* const)
native final function bool GetCompletePeriodCollection(out array<int> collectionid);

// Export UUIScript::execGetCollectionOptionName(FFrame&, void* const)
native final function bool GetCollectionOptionName(int Category, out array<string> optionName);

// Export UUIScript::execGetCharacterAbilityData(FFrame&, void* const)
native final function GetCharacterAbilityData(out array<L2CharacterAbilityUIData> o_arrData);

// Export UUIScript::execGetGeneralEffectName(FFrame&, void* const)
native final function string GetGeneralEffectName(string nameKey);

// Export UUIScript::execGetSubjugationList(FFrame&, void* const)
native static function GetSubjugationList(out array<SubjugationData> o_arrData);

// Export UUIScript::execGetPurchaseLimitCraftData(FFrame&, void* const)
native final function bool GetPurchaseLimitCraftData(int nShopIndex, int nProductID, out PurchaseLimitCraftUIData Data);

// Export UUIScript::execGetDethroneConnectCost(FFrame&, void* const)
native final function GetDethroneConnectCost(out array<RequestItem> o_arrData);

// Export UUIScript::execGetDethroneChangeNameCost(FFrame&, void* const)
native final function GetDethroneChangeNameCost(out array<RequestItem> o_arrData);

// Export UUIScript::execGetDethroneDailyMissionData(FFrame&, void* const)
native final function bool GetDethroneDailyMissionData(int MissionID, out DethroneDailyMissionData o_data);

// Export UUIScript::execGetDethroneCategory(FFrame&, void* const)
native final function int GetDethroneCategory(int DistrictID);

// Export UUIScript::execGetDethroneDistrictName(FFrame&, void* const)
native final function string GetDethroneDistrictName(int DistrictID);

// Export UUIScript::execGetServerMarkName(FFrame&, void* const)
native final function string GetServerMarkName(int WorldID);

// Export UUIScript::execGetNickNameItemData(FFrame&, void* const)
native final function bool GetNickNameItemData(int Id, out NickNameItemData Data);

// Export UUIScript::execGetNickNameIconImage(FFrame&, void* const)
native final function string GetNickNameIconImage(int Id);

// Export UUIScript::execRequestDisassembleItemInfo(FFrame&, void* const)
native final function bool RequestDisassembleItemInfo(array<byte> a_itemAssemble, out ItemInfo o_itemInfo);

// Export UUIScript::execGetWorldCastleWarMapInfo(FFrame&, void* const)
native final function GetWorldCastleWarMapInfo(UIEventManager.EWorldCastleWarMapNPCType a_npcType, out array<WorldCastleWarMapData> o_npcInfo);

// Export UUIScript::execAddPledgeInfo(FFrame&, void* const)
native final function AddPledgeInfo(int PledgeID, int PledgeCrestID);

// Export UUIScript::execIsPlayerOnOlympiad(FFrame&, void* const)
native final function bool IsPlayerOnOlympiad();

// Export UUIScript::execGetL2PassReward(FFrame&, void* const)
native final function GetL2PassReward(int nPassType, int nStartIndex, int nEndIndex, out array<L2PassRewardData> RewwardData);

// Export UUIScript::execGetL2PassRewardTotalList(FFrame&, void* const)
native final function GetL2PassRewardTotalList(int nPassType, bool IsPaid, int CompleteStep, out array<L2PassRewardTotalData> RewwardTotalData);

// Export UUIScript::execGetL2PassHuntingMaxTime(FFrame&, void* const)
native final function int GetL2PassHuntingMaxTime();

// Export UUIScript::execGetL2PassRewardStepMaxCount(FFrame&, void* const)
native final function int GetL2PassRewardStepMaxCount(int nPassType);

// Export UUIScript::execGetL2PassMaxCount(FFrame&, void* const)
native final function int GetL2PassMaxCount(int nPassType);

// Export UUIScript::execGetL2PassLastItem(FFrame&, void* const)
native final function int GetL2PassLastItem(int nPassType, bool IsPaid);

// Export UUIScript::execGetL2PassAdvanceFreeCount(FFrame&, void* const)
native final function int GetL2PassAdvanceFreeCount();

// Export UUIScript::execGetL2PassPremiumPassCost(FFrame&, void* const)
native final function GetL2PassPremiumPassCost(int nPassType, out int nItemID, out int nItemCnt);

// Export UUIScript::execGetL2PassAdvanceInfo(FFrame&, void* const)
native final function GetL2PassAdvanceInfo(array<int> EnableList, out array<L2PassAdvanceData> EnchantData);

// Export UUIScript::execGetEventHtmlString(FFrame&, void* const)
native final function GetEventHtmlString(int Index, out string Title, out string Desc);

// Export UUIScript::execGetMagicLampNormalResultItemList(FFrame&, void* const)
native final function bool GetMagicLampNormalResultItemList(out array<MagicLampResultItemUIData> o_ItemList);

// Export UUIScript::execGetMagicLampAdvancedResultItemList(FFrame&, void* const)
native final function bool GetMagicLampAdvancedResultItemList(out array<MagicLampResultItemUIData> o_ItemList);

// Export UUIScript::execIsInTimeRestrictField(FFrame&, void* const)
native final function bool IsInTimeRestrictField();

// Export UUIScript::execGetBalrogwarData(FFrame&, void* const)
native final function BalrogwarUIData GetBalrogwarData();

// Export UUIScript::execGetMissionLevelData(FFrame&, void* const)
native final function bool GetMissionLevelData(int a_SeasonDate, out MissionLevelUIData o_data);

// Export UUIScript::execGetBRWorldExchange(FFrame&, void* const)
native final function bool GetBRWorldExchange();

// Export UUIScript::execGetWorldExchangeData(FFrame&, void* const)
native final function WorldExchangeUIData GetWorldExchangeData();

// Export UUIScript::execGetServerPrivateStoreSearchItemSubType(FFrame&, void* const)
native final function int GetServerPrivateStoreSearchItemSubType(int a_ItemClassID);

// Export UUIScript::execConvertFloatToString(FFrame&, void* const)
native final function string ConvertFloatToString(float a_Value, int a_DecimalPlace, bool a_Round);

// Export UUIScript::execGetSiegePointAlarms(FFrame&, void* const)
native final function bool GetSiegePointAlarms(out array<int> PreAlarms, out array<int> Alarms);

// Export UUIScript::execGetPrisonData(FFrame&, void* const)
native function bool GetPrisonData(int a_PrisonType, out PrisonUIData o_data);

// Export UUIScript::execGetPrisonDataList(FFrame&, void* const)
native function GetPrisonDataList(out array<PrisonUIData> o_DataArray);

// Export UUIScript::execGetRecoveryCouponData(FFrame&, void* const)
native function GetRecoveryCouponData(int ItemClassID, out RecoveryCouponData Categories);

// Export UUIScript::execOpenWebSite(FFrame&, void* const)
native final function OpenWebSite(string openUrl);

// Export UUIScript::execJapanPolicyCheck(FFrame&, void* const)
native final function string JapanPolicyCheck();

// Export UUIScript::execSetUniqueGachaVideo(FFrame&, void* const)
native final function SetUniqueGachaVideo(bool SetOn);

// Export UUIScript::execGetUniqueGachaVideo(FFrame&, void* const)
native final function bool GetUniqueGachaVideo();

// Export UUIScript::execGetUniqueGachaShowItem(FFrame&, void* const)
native function GetUniqueGachaShowItem(out array<UniqueGachaItemInfo> ShowItemInfo);

// Export UUIScript::execGetUniqueGachaRewardItem(FFrame&, void* const)
native function GetUniqueGachaRewardItem(out array<UniqueGachaItemInfo> RewardItemInfo);

// Export UUIScript::execGetUniqueGachaGameTypeInfo(FFrame&, void* const)
native function GetUniqueGachaGameTypeInfo(out array<UniquegachaGameTypeInfo> GameTypeInfo);

// Export UUIScript::execGetUniqueGachaCostInfo(FFrame&, void* const)
native function GetUniqueGachaCostInfo(out int CostType, out int CostItemType);

// Export UUIScript::execIsPrivateStoreBypass(FFrame&, void* const)
native final function bool IsPrivateStoreBypass();

// Export UUIScript::execGetItemExchangeMultisellData(FFrame&, void* const)
native final function GetItemExchangeMultisellData(int a_ItemClassID, out array<ItemExchangeMultisellUIData> o_arrData);

// Export UUIScript::execGetPledgeCrestPresetData(FFrame&, void* const)
native final function GetPledgeCrestPresetData(out array<PledgeCrestPresetUIData> o_arrData);

// Export UUIScript::execRequestClanRegisterCrestPreset(FFrame&, void* const)
native final function RequestClanRegisterCrestPreset(int presetID);

// Export UUIScript::execRequestClanUnregisterCrestByPledgeID(FFrame&, void* const)
native final function RequestClanUnregisterCrestByPledgeID(int PledgeID);

// Export UUIScript::execGetClientCursorPos(FFrame&, void* const)
native function GetClientCursorPos(out int X, out int Y);

// Export UUIScript::execGetNQuestData(FFrame&, void* const)
native final function bool GetNQuestData(int a_QuestID, out NQuestUIData o_data);

// Export UUIScript::execGetNQuestDialogData(FFrame&, void* const)
native final function bool GetNQuestDialogData(int a_QuestID, out NQuestDialogUIData o_data);

// Export UUIScript::execGetNQuestNpcPortraitData(FFrame&, void* const)
native final function bool GetNQuestNpcPortraitData(int a_NpcID, out NQuestNpcPortraitUIData o_data);

// Export UUIScript::execGetEnchantExpItemListFromInven(FFrame&, void* const)
native final function int GetEnchantExpItemListFromInven(int a_grade, out array<ChargeExpItem> o_Items);

// Export UUIScript::execGetSkillSubLevelList(FFrame&, void* const)
native final function int GetSkillSubLevelList(int a_SkillID, int a_SkillLevel, out array<int> o_SubLevelList);

// Export UUIScript::execGetSkillAcquireList(FFrame&, void* const)
native final function int GetSkillAcquireList(int a_ClassID, int a_SkillID, out array<SkillAcquireData> o_Datas, out array<int> o_BlockSkills);

defaultproperties
{
}
