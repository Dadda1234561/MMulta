//================================================================================
// HtmlHandle.
//================================================================================

class HtmlHandle extends WindowHandle
	native;

// Export UHtmlHandle::execLoadHtml(FFrame&, void* const)
native final function LoadHtml(string Filename);

// Export UHtmlHandle::execLoadHtmlFromString(FFrame&, void* const)
native final function LoadHtmlFromString(string HtmlString);

// Export UHtmlHandle::execClear(FFrame&, void* const)
native final function Clear();

// Export UHtmlHandle::execGetFrameMaxHeight(FFrame&, void* const)
native final function int GetFrameMaxHeight();

// Export UHtmlHandle::execControllerExecution(FFrame&, void* const)
native final function UIEventManager.EControlReturnType ControllerExecution(string strBypass);

// Export UHtmlHandle::execSetHtmlBuffData(FFrame&, void* const)
native final function SetHtmlBuffData(string strData);

// Export UHtmlHandle::execSetPageLock(FFrame&, void* const)
native final function SetPageLock(bool bLock);

// Export UHtmlHandle::execIsPageLock(FFrame&, void* const)
native final function bool IsPageLock();

defaultproperties
{
}
