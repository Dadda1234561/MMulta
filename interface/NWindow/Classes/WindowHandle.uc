//================================================================================
// WindowHandle.
//================================================================================

class WindowHandle extends UIEventManager
	native;

cpptext
{
	#include "WindowHandle.h"
}

var Object m_pTargetWnd;
var string m_WindowNameWithFullPath;

// Export UWindowHandle::execSetWindowTitle(FFrame&, void* const)
native final function SetWindowTitle(string a_Title);

// Export UWindowHandle::execSetTitlePosOffset(FFrame&, void* const)
native final function SetTitlePosOffset(int OffsetX, int OffsetY);

// Export UWindowHandle::execShowWindow(FFrame&, void* const)
native final function ShowWindow();

// Export UWindowHandle::execHideWindow(FFrame&, void* const)
native final function HideWindow();

// Export UWindowHandle::execIsShowWindow(FFrame&, void* const)
native final function bool IsShowWindow();

// Export UWindowHandle::execIsMinimizedWindow(FFrame&, void* const)
native final function bool IsMinimizedWindow();

// Export UWindowHandle::execGetWindowName(FFrame&, void* const)
native final function string GetWindowName();

// Export UWindowHandle::execGetParentWindowName(FFrame&, void* const)
native final function string GetParentWindowName();

// Export UWindowHandle::execChangeParentWindow(FFrame&, void* const)
native final function bool ChangeParentWindow(WindowHandle a_hNewParentWnd);

// Export UWindowHandle::execGetParentWindowHandle(FFrame&, void* const)
native final function WindowHandle GetParentWindowHandle();

// Export UWindowHandle::execGetChildWindowList(FFrame&, void* const)
native final function GetChildWindowList(array<WindowHandle> a_ChildList);

// Export UWindowHandle::execIsChildOf(FFrame&, void* const)
native final function bool IsChildOf(WindowHandle a_hParentWnd);

// Export UWindowHandle::execGetTopFrameWnd(FFrame&, void* const)
native final function WindowHandle GetTopFrameWnd();

// Export UWindowHandle::execGetAlpha(FFrame&, void* const)
native final function int GetAlpha();

// Export UWindowHandle::execSetAlpha(FFrame&, void* const)
native final function SetAlpha(int a_Alpha, optional float a_Seconds);

// Export UWindowHandle::execGetScript(FFrame&, void* const)
native final function UIScript GetScript();

// Export UWindowHandle::execGetScriptName(FFrame&, void* const)
native final function string GetScriptName();

// Export UWindowHandle::execIsVirtual(FFrame&, void* const)
native final function bool IsVirtual();

// Export UWindowHandle::execIsAlwaysOnTop(FFrame&, void* const)
native final function bool IsAlwaysOnTop();

// Export UWindowHandle::execIsAlwaysOnBack(FFrame&, void* const)
native final function bool IsAlwaysOnBack();

// Export UWindowHandle::execSetFontColor(FFrame&, void* const)
native final function SetFontColor(Color a_FontColor);

// Export UWindowHandle::execSetAlwaysFullAlpha(FFrame&, void* const)
native final function SetAlwaysFullAlpha(bool a_AlwaysFullAlpha);

// Export UWindowHandle::execSetModal(FFrame&, void* const)
native final function SetModal(bool a_Modal);

// Export UWindowHandle::execGetRect(FFrame&, void* const)
native final function Rect GetRect();

// Export UWindowHandle::execAddWindowSize(FFrame&, void* const)
native final function AddWindowSize(int a_DeltaWidth, int a_DeltaHeight);

// Export UWindowHandle::execSetWindowSize(FFrame&, void* const)
native final function SetWindowSize(int a_Width, int a_Height);

// Export UWindowHandle::execGetWindowSize(FFrame&, void* const)
native final function GetWindowSize(out int a_Width, out int a_Height);

// Export UWindowHandle::execSetWindowSizeRel(FFrame&, void* const)
native final function SetWindowSizeRel(float fWidthRate, float fHeightRate, int nOffsetWidth, int nOffsetHeight);

// Export UWindowHandle::execGetWindowSizeRel(FFrame&, void* const)
native final function GetWindowSizeRel(out float fWidthRate, out float fHeightRate, out int nOffsetWidth, out int nOffsetHeight);

// Export UWindowHandle::execSetWindowSizeRel43(FFrame&, void* const)
native final function SetWindowSizeRel43(float fWidthRate, float fHeightRate, int nOffsetWidth, int nOffsetHeight);

// Export UWindowHandle::execIsRelativeSize(FFrame&, void* const)
native final function bool IsRelativeSize();

// Export UWindowHandle::execMove(FFrame&, void* const)
native final function Move(int a_nDeltaX, int a_nDeltaY, optional float a_Seconds);

// Export UWindowHandle::execMoveTo(FFrame&, void* const)
native final function MoveTo(int a_nX, int a_nY);

// Export UWindowHandle::execMoveEx(FFrame&, void* const)
native final function MoveEx(int a_nX, int a_nY);

// Export UWindowHandle::execMoveC(FFrame&, void* const)
native final function MoveC(int a_nX, int a_nY);

// Export UWindowHandle::execMoveExWithTime(FFrame&, void* const)
native final function MoveExWithTime(int a_nX, int a_nY, float a_Seconds);

// Export UWindowHandle::execMoveShake(FFrame&, void* const)
native final function MoveShake(int a_nRange, int a_nSet, optional float a_Seconds);

// Export UWindowHandle::execEnableTick(FFrame&, void* const)
native final function EnableTick();

// Export UWindowHandle::execDisableTick(FFrame&, void* const)
native final function DisableTick();

// Export UWindowHandle::execSetAnchor(FFrame&, void* const)
native final function SetAnchor(string AnchorWindowName, string RelativePoint, string AnchorPoint, int OffsetX, int OffsetY);

// Export UWindowHandle::execClearAnchor(FFrame&, void* const)
native final function ClearAnchor();

// Export UWindowHandle::execIsAnchored(FFrame&, void* const)
native final function bool IsAnchored();

// Export UWindowHandle::execIsDraggable(FFrame&, void* const)
native final function bool IsDraggable();

// Export UWindowHandle::execSetDraggable(FFrame&, void* const)
native final function SetDraggable(bool a_Draggable);

// Export UWindowHandle::execSetStuckable(FFrame&, void* const)
native final function SetStuckable(bool a_Stuckable);

// Export UWindowHandle::execIsVirtualDrag(FFrame&, void* const)
native final function bool IsVirtualDrag();

// Export UWindowHandle::execSetVirtualDrag(FFrame&, void* const)
native final function SetVirtualDrag(bool a_bFlag);

// Export UWindowHandle::execSetDragOverTexture(FFrame&, void* const)
native final function SetDragOverTexture(string a_TextureName);

// Export UWindowHandle::execEnableWindow(FFrame&, void* const)
native final function EnableWindow();

// Export UWindowHandle::execDisableWindow(FFrame&, void* const)
native final function DisableWindow();

// Export UWindowHandle::execIsEnableWindow(FFrame&, void* const)
native final function bool IsEnableWindow();

// Export UWindowHandle::execSetFocus(FFrame&, void* const)
native final function SetFocus();

// Export UWindowHandle::execIsFocused(FFrame&, void* const)
native final function bool IsFocused();

// Export UWindowHandle::execReleaseFocus(FFrame&, void* const)
native final function ReleaseFocus();

// Export UWindowHandle::execBringToFrontOf(FFrame&, void* const)
native final function BringToFrontOf(string TargetName);

// Export UWindowHandle::execBringToFront(FFrame&, void* const)
native final function BringToFront();

// Export UWindowHandle::execSetTimer(FFrame&, void* const)
native final function SetTimer(int a_TimerID, int a_DelayMiliseconds);

// Export UWindowHandle::execKillTimer(FFrame&, void* const)
native final function KillTimer(int a_TimerID);

// Export UWindowHandle::execNotifyAlarm(FFrame&, void* const)
native final function NotifyAlarm();

// Export UWindowHandle::execSetTooltipText(FFrame&, void* const)
native final function SetTooltipText(string Text);

// Export UWindowHandle::execGetTooltipText(FFrame&, void* const)
native final function string GetTooltipText();

// Export UWindowHandle::execSetTooltipType(FFrame&, void* const)
native final function SetTooltipType(string TooltipType);

// Export UWindowHandle::execSetTooltipCustomType(FFrame&, void* const)
native final function SetTooltipCustomType(CustomTooltip Info);

// Export UWindowHandle::execGetTooltipCustomType(FFrame&, void* const)
native final function GetTooltipCustomType(out CustomTooltip Info);

// Export UWindowHandle::execClearTooltip(FFrame&, void* const)
native final function ClearTooltip();

// Export UWindowHandle::execClearAllChildShortcutItemTooltip(FFrame&, void* const)
native final function ClearAllChildShortcutItemTooltip();

// Export UWindowHandle::execSetFrameSize(FFrame&, void* const)
native final function SetFrameSize(int nWidth, int nHeight);

// Export UWindowHandle::execSetResizeFrameSize(FFrame&, void* const)
native final function SetResizeFrameSize(int nWidth, int nHeight);

// Export UWindowHandle::execSetScrollBarPosition(FFrame&, void* const)
native function SetScrollBarPosition(int X, int Y, int HeightOffset);

// Export UWindowHandle::execSetScrollPosition(FFrame&, void* const)
native final function SetScrollPosition(int pos);

// Export UWindowHandle::execGetScrollPosition(FFrame&, void* const)
native final function int GetScrollPosition();

// Export UWindowHandle::execSetScrollHeight(FFrame&, void* const)
native final function SetScrollHeight(int Height);

// Export UWindowHandle::execGetScrollHeight(FFrame&, void* const)
native final function int GetScrollHeight();

// Export UWindowHandle::execSetScrollUnit(FFrame&, void* const)
native final function SetScrollUnit(int Unit, bool Clear);

// Export UWindowHandle::execSetSettledWnd(FFrame&, void* const)
native final function SetSettledWnd(bool bFlag);

// Export UWindowHandle::execRotate(FFrame&, void* const)
native final function Rotate(optional bool bWithCapture, optional int RotationTime, optional Vector Direction, optional int BeginAlpha, optional int EndAlpha, optional bool bCW, optional float RotationConstant);

// Export UWindowHandle::execClearRotation(FFrame&, void* const)
native final function ClearRotation();

// Export UWindowHandle::execIsFront(FFrame&, void* const)
native final function IsFront();

// Export UWindowHandle::execInitRotation(FFrame&, void* const)
native final function InitRotation();

// Export UWindowHandle::execSetEditable(FFrame&, void* const)
native final function SetEditable(bool bEnable);

// Export UWindowHandle::execAddChildWnd(FFrame&, void* const)
native final function WindowHandle AddChildWnd(UIEventManager.EXMLControlType ChildType);

// Export UWindowHandle::execGetClassName(FFrame&, void* const)
native final function string GetClassName();

// Export UWindowHandle::execDeleteChildWnd(FFrame&, void* const)
native final function DeleteChildWnd(string ChildName);

// Export UWindowHandle::execSetBackTexture(FFrame&, void* const)
native final function SetBackTexture(string TextureName);

// Export UWindowHandle::execSetScript(FFrame&, void* const)
native final function SetScript(string ScriptName);

// Export UWindowHandle::execIsControlContainer(FFrame&, void* const)
native final function bool IsControlContainer();

// Export UWindowHandle::execGetControlType(FFrame&, void* const)
native final function UIEventManager.EXMLControlType GetControlType();

// Export UWindowHandle::execLoadXMLWindow(FFrame&, void* const)
native final function WindowHandle LoadXMLWindow(string FilePathName);

// Export UWindowHandle::execSaveXMLWindow(FFrame&, void* const)
native final function bool SaveXMLWindow(string FilePathName);

// Export UWindowHandle::execGetXMLDocumentInfo(FFrame&, void* const)
native final function GetXMLDocumentInfo(out string Comment, out string NameSpace, out string XSI, out string SchemaLocation);

// Export UWindowHandle::execSetXMLDocumentInfo(FFrame&, void* const)
native final function SetXMLDocumentInfo(string Comment, string NameSpace, string XSI, string SchemaLocation);

// Export UWindowHandle::execConvertToEditable(FFrame&, void* const)
native final function ConvertToEditable();

// Export UWindowHandle::execMakeBaseUC(FFrame&, void* const)
native final function bool MakeBaseUC(string UCName, string FilePathName);

// Export UWindowHandle::execChangeControlOrder(FFrame&, void* const)
native final function ChangeControlOrder(UIEventManager.EControlOrderWay WayType);

// Export UWindowHandle::execEnterState(FFrame&, void* const)
native final function EnterState();

// Export UWindowHandle::execExitState(FFrame&, void* const)
native final function ExitState();

// Export UWindowHandle::execIsCurrentState(FFrame&, void* const)
native final function bool IsCurrentState();

// Export UWindowHandle::execSetShowAndHideAnimType(FFrame&, void* const)
native final function SetShowAndHideAnimType(bool bShow, int Direction, float Time);

// Export UWindowHandle::execSetTooltipCalculateSize(FFrame&, void* const)
native final function SetTooltipCalculateSize(int MinimumWidth);

// Export UWindowHandle::execInsertTooltipDrawItem(FFrame&, void* const)
native final function InsertTooltipDrawItem(DrawItemInfo infDrawItem);

// Export UWindowHandle::execGetChildWindow(FFrame&, void* const)
native final function WindowHandle GetChildWindow(string ChildName);

// Export UWindowHandle::execEnableDynamicAlpha(FFrame&, void* const)
native final function EnableDynamicAlpha(bool bEnable);

// Export UWindowHandle::execSetResizeFrameOffset(FFrame&, void* const)
native final function SetResizeFrameOffset(int StartWidth, int StartHeight);

// Export UWindowHandle::execSetCanBeShownDuringScene(FFrame&, void* const)
native final function SetCanBeShownDuringScene(bool bCanBeShownDuringScene);

// Export UWindowHandle::execSetUnConditionalShow(FFrame&, void* const)
native final function SetUnConditionalShow(bool bValue);

// Export UWindowHandle::execSetUpScalableUIDefaultSetting(FFrame&, void* const)
native final function SetUpScalableUIDefaultSetting();

// Export UWindowHandle::execScalingToDefaultSizeType(FFrame&, void* const)
native final function ScalingToDefaultSizeType();

// Export UWindowHandle::execScalingToCurrentSizeType(FFrame&, void* const)
native final function ScalingToCurrentSizeType();

// Export UWindowHandle::execGetCurrentScalableSizeRate(FFrame&, void* const)
native final function GetCurrentScalableSizeRate(out float WidthRate, out float HeightRate);

// Export UWindowHandle::execGetResizeFrame(FFrame&, void* const)
native final function WindowHandle GetResizeFrame();

defaultproperties
{
}
