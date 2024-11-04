//================================================================================
// GFxUIScript.
//================================================================================

class GFxUIScript extends UIScript
	native;

enum EFlashImageLoaderType {
	EImgLoader_None,
	EImgLoader_Pledge,
	EImgLoader_PackageTexture
};

enum EExternalFunctionType {
	EFunc_None,
	EFunc_SysStringTranslator
};

enum EDelegateHandlerType {
	EDHandler_Default,
	EDHandler_OlympiadArenaList,
	EDHandler_UseSkill,
	EDHandler_Container,
	EDHandler_DamageText,
	EDHandler_Statistic,
	EDHandler_NotifyUSMEnd,
	EDHandler_ClanUnionAction,
	EDHandler_EventKalieWnd,
	EDHandler_Option,
	EDHandler_ShortcutAPI,
	EDHandler_InputAPI,
	EDHandler_BeautyshopWnd,
	EDHandler_ChatWnd,
	EDHandler_PledgeRecruit,
	EDHandler_EventChristmasWnd,
	EDHandler_EventCardWnd,
	EDHandler_AdenaDistributionWnd,
	EDHandler_GFxDebug,
	EDHandler_LuckyGameWnd,
	EDHandler_TrainingRoomWnd,
	EDHandler_Event10thAnniversary,
	EDHandler_RadarMap,
	EDHandler_AlchemyAPI,
	EDHandler_FishWnd,
	EDHandler_VipSystem,
	EDHandler_Arena,
	EDHandler_FactionWnd,
	EDHandler_Minimap,
	EDHandler_UpgradeSystemWnd,
	EDHandler_GameData,
	EDHandler_OBS,
	EDHandler_CardUpdownGame,
	EDHandler_PledgeWnd,
	EDHandler_ElementalSpirit,
	EDHandler_Costume,
	EDHandler_ClassChange,
	EDHandler_TeleportList
};

var Object m_pTargetWnd;

// Export UGFxUIScript::execRegisterEvent(FFrame&, void* const)
native function RegisterEvent(int ev);

// Export UGFxUIScript::execRegisterGFxEventForLoaded(FFrame&, void* const)
native function RegisterGFxEventForLoaded(int ev);

// Export UGFxUIScript::execRegisterGFxEvent(FFrame&, void* const)
native function RegisterGFxEvent(int ev);

// Export UGFxUIScript::execRegisterState(FFrame&, void* const)
native function RegisterState(string WindowName, string State);

// Export UGFxUIScript::execShowFlashFromFilePath(FFrame&, void* const)
native final function bool ShowFlashFromFilePath(string filePath, optional bool bDuplicated);

// Export UGFxUIScript::execCreateObject(FFrame&, void* const)
native final function CreateObject(out GFxValue val);

// Export UGFxUIScript::execCreateArray(FFrame&, void* const)
native final function CreateArray(out GFxValue val);

// Export UGFxUIScript::execInvoke(FFrame&, void* const)
native final function bool Invoke(string funcName, out array<GFxValue> args, out GFxValue Result);

// Export UGFxUIScript::execAllocGFxValues(FFrame&, void* const)
native final function AllocGFxValues(out array<GFxValue> args, int Num);

// Export UGFxUIScript::execDeallocGFxValues(FFrame&, void* const)
native final function DeallocGFxValues(out array<GFxValue> args);

// Export UGFxUIScript::execAllocGFxValue(FFrame&, void* const)
native final function AllocGFxValue(out GFxValue val);

// Export UGFxUIScript::execDeallocGFxValue(FFrame&, void* const)
native final function DeallocGFxValue(out GFxValue val);

// Export UGFxUIScript::execRegisterDelegateHandler(FFrame&, void* const)
native final function RegisterDelegateHandler(GFxUIScript.EDelegateHandlerType Type);

// Export UGFxUIScript::execGetVariable(FFrame&, void* const)
native final function bool GetVariable(out GFxValue val, string PathToVar);

// Export UGFxUIScript::execGetFunction(FFrame&, void* const)
native final function GetFunction(out GFxValue val, GFxUIScript.EExternalFunctionType funcType);

// Export UGFxUIScript::execSetMsgPassThrough(FFrame&, void* const)
native function SetMsgPassThrough(bool bPass);

// Export UGFxUIScript::execSetAlwaysFullAlpha(FFrame&, void* const)
native function SetAlwaysFullAlpha(bool bFull);

// Export UGFxUIScript::execSetRenderOnTop(FFrame&, void* const)
native function SetRenderOnTop(bool bSet);

// Export UGFxUIScript::execSetDefaultShow(FFrame&, void* const)
native function SetDefaultShow(bool bSet);

// Export UGFxUIScript::execShowWindow(FFrame&, void* const)
native final function ShowWindow(optional string WindowName);

// Export UGFxUIScript::execHideWindow(FFrame&, void* const)
native final function HideWindow(optional string WindowName);

// Export UGFxUIScript::execIsShowWindow(FFrame&, void* const)
native final function bool IsShowWindow(optional string WindowName);

// Export UGFxUIScript::execSetFocus(FFrame&, void* const)
native final function SetFocus(optional string WindowName);

// Export UGFxUIScript::execBringToFrontOf(FFrame&, void* const)
native final function BringToFrontOf(string TargetName);

// Export UGFxUIScript::execBringToFront(FFrame&, void* const)
native final function BringToFront();

// Export UGFxUIScript::execMakeRenderToTexture(FFrame&, void* const)
native final function MakeRenderToTexture(bool bScreenSizeRenderTarget);

// Export UGFxUIScript::execIgnoreUIEvent(FFrame&, void* const)
native final function IgnoreUIEvent(bool bIgnore);

// Export UGFxUIScript::execSetHavingFocus(FFrame&, void* const)
native final function SetHavingFocus(bool bFocus);

// Export UGFxUIScript::execFlashMoviePlayStart(FFrame&, void* const)
native final function FlashMoviePlayStart(int iReserved);

// Export UGFxUIScript::execFlashMoviePlayEnd(FFrame&, void* const)
native final function FlashMoviePlayEnd(int iReserved);

// Export UGFxUIScript::execSetAnchor(FFrame&, void* const)
native final function SetAnchor(string targetWindowName, UIEventManager.EAnchorPointType targetPointType, UIEventManager.EAnchorPointType anchorPointType, int OffsetX, int OffsetY);

// Export UGFxUIScript::execSetFixedPositionRate(FFrame&, void* const)
native final function SetFixedPositionRate(float fVerticalPositionRate, float fHorizontalPositionRate);

// Export UGFxUIScript::execApplyFixedPositionRate(FFrame&, void* const)
native final function ApplyFixedPositionRate();

// Export UGFxUIScript::execSetSaveWnd(FFrame&, void* const)
native final function SetSaveWnd(bool bSavePosition, bool bSaveSize);

// Export UGFxUIScript::execSetRestartableFlash(FFrame&, void* const)
native final function SetRestartableFlash();

// Export UGFxUIScript::execSetContainer(FFrame&, void* const)
native final function SetContainer(string containerName);

// Export UGFxUIScript::execSetStateChangeNotification(FFrame&, void* const)
native final function SetStateChangeNotification();

// Export UGFxUIScript::execHasTextField(FFrame&, void* const)
native final function HasTextField(bool enableIME);

// Export UGFxUIScript::execSetHasGFxTextField(FFrame&, void* const)
native final function SetHasGFxTextField(bool HasTextField);

// Export UGFxUIScript::execSetNextFocus(FFrame&, void* const)
native final function SetNextFocus();

// Export UGFxUIScript::execSetModal(FFrame&, void* const)
native final function SetModal(bool a_Modal);

// Export UGFxUIScript::execSetAlwaysOnTop(FFrame&, void* const)
native final function SetAlwaysOnTop(bool bAlwaysOnTop);

// Export UGFxUIScript::execSetRotateCursor(FFrame&, void* const)
native final function SetRotateCursor();

// Export UGFxUIScript::execUnsetRotateCursor(FFrame&, void* const)
native final function UnsetRotateCursor();

// Export UGFxUIScript::execIsSavedInfo(FFrame&, void* const)
native final function bool IsSavedInfo();

// Export UGFxUIScript::execSetGFxFromSavedInfo(FFrame&, void* const)
native final function bool SetGFxFromSavedInfo();

// Export UGFxUIScript::execGetAnchorPointFromWindow(FFrame&, void* const)
native final function GetAnchorPointFromWindow(out float X, out float Y, UIEventManager.EAnchorPointType anchorType);

// Export UGFxUIScript::execSetClosingOnESC(FFrame&, void* const)
native function SetClosingOnESC();

// Export UGFxUIScript::execSetHUD(FFrame&, void* const)
native final function SetHUD();

// Export UGFxUIScript::execForceToMoveMousePos(FFrame&, void* const)
native final function ForceToMoveMousePos(float X, float Y);

// Export UGFxUIScript::execSendCommandToServer(FFrame&, void* const)
native final function SendCommandToServer(string Command);

event OnCallUCLogic(int logicID, string param);

event OnFlashLoaded();

event OnFocus(bool bFocused, bool bTransparencyMode);

// Export UGFxUIScript::execSetEulaText(FFrame&, void* const)
native final function SetEulaText(out GFxValue val, string Name);

// Export UGFxUIScript::execGetUserPremiumLevel(FFrame&, void* const)
native final function int GetUserPremiumLevel();

// Export UGFxUIScript::execSetTimer(FFrame&, void* const)
native final function SetTimer(int a_TimerID, int a_DelayMiliseconds);

// Export UGFxUIScript::execKillTimer(FFrame&, void* const)
native final function KillTimer(int a_TimerID);

// Export UGFxUIScript::execSetCanBeShownDuringScene(FFrame&, void* const)
native final function SetCanBeShownDuringScene(bool bCanBeShownDuringScene);

defaultproperties
{
}
