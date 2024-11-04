//================================================================================
// UIAPI_WINDOW.
//================================================================================

class UIAPI_WINDOW extends UIEventManager
	native;

// Export UUIAPI_WINDOW::execIsShowWindow(FFrame&, void* const)
native static function bool IsShowWindow(string ControlName);

// Export UUIAPI_WINDOW::execIsMinimizedWindow(FFrame&, void* const)
native static function bool IsMinimizedWindow(string ControlName);

// Export UUIAPI_WINDOW::execShowWindow(FFrame&, void* const)
native static function ShowWindow(string ControlName);

// Export UUIAPI_WINDOW::execHideWindow(FFrame&, void* const)
native static function HideWindow(string ControlName);

// Export UUIAPI_WINDOW::execClear(FFrame&, void* const)
native static function Clear(string ControlName);

// Export UUIAPI_WINDOW::execGetRect(FFrame&, void* const)
native static function Rect GetRect(string ControlName);

// Export UUIAPI_WINDOW::execSetUITimer(FFrame&, void* const)
native static function SetUITimer(string ControlName, int TimerID, int Delayms);

// Export UUIAPI_WINDOW::execKillUITimer(FFrame&, void* const)
native static function KillUITimer(string ControlName, int TimerID);

// Export UUIAPI_WINDOW::execSetWindowTitle(FFrame&, void* const)
native static function SetWindowTitle(string ControlName, int Index);

// Export UUIAPI_WINDOW::execSetWindowTitleByText(FFrame&, void* const)
native static function SetWindowTitleByText(string ControlName, string strText);

// Export UUIAPI_WINDOW::execEnableWindow(FFrame&, void* const)
native static function EnableWindow(string ControlName);

// Export UUIAPI_WINDOW::execDisableWindow(FFrame&, void* const)
native static function DisableWindow(string ControlName);

// Export UUIAPI_WINDOW::execIsEnableWindow(FFrame&, void* const)
native static function bool IsEnableWindow(string ControlName);

// Export UUIAPI_WINDOW::execSetAlwaysOnTop(FFrame&, void* const)
native static function SetAlwaysOnTop(string ControlName, bool a_bAlwaysOnTop);

// Export UUIAPI_WINDOW::execSetAlpha(FFrame&, void* const)
native static function SetAlpha(string ControlName, int a_nAlpha, optional float a_Seconds);

// Export UUIAPI_WINDOW::execMove(FFrame&, void* const)
native static function Move(string ControlName, int a_nDeltaX, int a_nDeltaY, optional float a_Seconds);

// Export UUIAPI_WINDOW::execMoveTo(FFrame&, void* const)
native static function MoveTo(string ControlName, int a_nX, int a_nY);

// Export UUIAPI_WINDOW::execMoveEx(FFrame&, void* const)
native static function MoveEx(string ControlName, int a_nX, int a_nY);

// Export UUIAPI_WINDOW::execMoveShake(FFrame&, void* const)
native static function MoveShake(string ContorlName, int a_nRange, int a_nSet, optional float a_Seconds);

// Export UUIAPI_WINDOW::execIconize(FFrame&, void* const)
native static function Iconize(string ControlName, string Texture, int ToolTip);

// Export UUIAPI_WINDOW::execNotifyAlarm(FFrame&, void* const)
native static function NotifyAlarm(string ControlName);

// Export UUIAPI_WINDOW::execSetFocus(FFrame&, void* const)
native static function SetFocus(string ControlName);

// Export UUIAPI_WINDOW::execIsFocused(FFrame&, void* const)
native static function bool IsFocused(string ControlName);

// Export UUIAPI_WINDOW::execBringToFrontOf(FFrame&, void* const)
native static function BringToFrontOf(string ControlName, string TargetName);

// Export UUIAPI_WINDOW::execBringToFront(FFrame&, void* const)
native static function BringToFront(string ControlName);

// Export UUIAPI_WINDOW::execSetWindowSize(FFrame&, void* const)
native static function SetWindowSize(string ControlName, int nWidth, int nHeight);

// Export UUIAPI_WINDOW::execSetWindowSizeRel(FFrame&, void* const)
native static function SetWindowSizeRel(string ControlName, float fWidthRate, float fHeightRate, int nOffsetWidth, int nOffsetHeight);

// Export UUIAPI_WINDOW::execSetWindowSizeRel43(FFrame&, void* const)
native static function SetWindowSizeRel43(string ControlName, float fWidthRate, float fHeightRate, int nOffsetWidth, int nOffsetHeight);

// Export UUIAPI_WINDOW::execSetFrameSize(FFrame&, void* const)
native static function SetFrameSize(string ControlName, int nWidth, int nHeight);

// Export UUIAPI_WINDOW::execSetResizeFrameSize(FFrame&, void* const)
native static function SetResizeFrameSize(string ControlName, int nWidth, int nHeight);

// Export UUIAPI_WINDOW::execSetTabOrder(FFrame&, void* const)
native static function SetTabOrder(string ControlName, string NextName, string PreName);

// Export UUIAPI_WINDOW::execSetTooltipType(FFrame&, void* const)
native static function SetTooltipType(string ControlName, string TooltipType);

// Export UUIAPI_WINDOW::execSetTooltipText(FFrame&, void* const)
native static function SetTooltipText(string ControlName, string Text);

// Export UUIAPI_WINDOW::execGetTooltipText(FFrame&, void* const)
native static function string GetTooltipText(string ControlName);

// Export UUIAPI_WINDOW::execSetAnchor(FFrame&, void* const)
native static function SetAnchor(string ControlName, string AnchorWindowName, string RelativePoint, string AnchorPoint, int OffsetX, int OffsetY);

// Export UUIAPI_WINDOW::execClearAnchor(FFrame&, void* const)
native static function ClearAnchor(string ControlName);

// Export UUIAPI_WINDOW::execGetSelectedRadioButtonName(FFrame&, void* const)
native static function string GetSelectedRadioButtonName(string a_ControlID, int a_RadioGroupID);

defaultproperties
{
}
