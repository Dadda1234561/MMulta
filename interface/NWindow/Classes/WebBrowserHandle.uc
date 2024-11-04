//================================================================================
// WebBrowserHandle.
//================================================================================

class WebBrowserHandle extends WindowHandle
	native;

// Export UWebBrowserHandle::execWithWebSession(FFrame&, void* const)
native final function WithWebSession();

// Export UWebBrowserHandle::execWithoutWebSession(FFrame&, void* const)
native final function WithoutWebSession();

// Export UWebBrowserHandle::execBeginParam(FFrame&, void* const)
native final function BeginParam(string charset);

// Export UWebBrowserHandle::execPushParam(FFrame&, void* const)
native final function PushParam(string Key, string Value);

// Export UWebBrowserHandle::execNavigateAsPost(FFrame&, void* const)
native final function NavigateAsPost(string URL);

// Export UWebBrowserHandle::execNavigateAsGet(FFrame&, void* const)
native final function NavigateAsGet(string URL);

// Export UWebBrowserHandle::execNavigateAsGetJson(FFrame&, void* const)
native final function NavigateAsGetJson(string URL);

// Export UWebBrowserHandle::execGoToHistoryOffset(FFrame&, void* const)
native final function GoToHistoryOffset(int offset);

// Export UWebBrowserHandle::execExecuteJavaScriptWithStringResult(FFrame&, void* const)
native final function bool ExecuteJavaScriptWithStringResult(string Command, out string Value);

// Export UWebBrowserHandle::execExecuteJavaScriptWithIntegerResult(FFrame&, void* const)
native final function bool ExecuteJavaScriptWithIntegerResult(string Command, out int Value);

// Export UWebBrowserHandle::execExecuteJavaScriptWithFloatResult(FFrame&, void* const)
native final function bool ExecuteJavaScriptWithFloatResult(string Command, out float Value);

// Export UWebBrowserHandle::execGetURLEncodedAsUTF8(FFrame&, void* const)
native final function string GetURLEncodedAsUTF8(string URL);

// Export UWebBrowserHandle::execGetUrl(FFrame&, void* const)
native final function string GetUrl();

// Export UWebBrowserHandle::execExecuteJavaScript(FFrame&, void* const)
native final function bool ExecuteJavaScript(string Command);

// Export UWebBrowserHandle::execGetCookie(FFrame&, void* const)
native final function string GetCookie(string URL, string Key);

// Export UWebBrowserHandle::execSetCookie(FFrame&, void* const)
native final function bool SetCookie(string URL, string Key, string Value);

// Export UWebBrowserHandle::execNavigate(FFrame&, void* const)
native final function Navigate(WebRequestInfo requestInfo);

// Export UWebBrowserHandle::execCanGoBackPage(FFrame&, void* const)
native final function bool CanGoBackPage();

// Export UWebBrowserHandle::execGoBackPage(FFrame&, void* const)
native final function GoBackPage();

// Export UWebBrowserHandle::execCanGoForwardPage(FFrame&, void* const)
native final function bool CanGoForwardPage();

// Export UWebBrowserHandle::execGoForwardPage(FFrame&, void* const)
native final function GoForwardPage();

// Export UWebBrowserHandle::execReloadCurPage(FFrame&, void* const)
native final function ReloadCurPage();

defaultproperties
{
}
