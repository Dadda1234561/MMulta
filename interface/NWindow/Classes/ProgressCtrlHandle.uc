//================================================================================
// ProgressCtrlHandle.
//================================================================================

class ProgressCtrlHandle extends WindowHandle
	native;

// Export UProgressCtrlHandle::execSetProgressTime(FFrame&, void* const)
native final function SetProgressTime(int Millitime);

// Export UProgressCtrlHandle::execSetPos(FFrame&, void* const)
native final function SetPos(int Millitime);

// Export UProgressCtrlHandle::execReset(FFrame&, void* const)
native final function Reset();

// Export UProgressCtrlHandle::execStop(FFrame&, void* const)
native final function Stop();

// Export UProgressCtrlHandle::execResume(FFrame&, void* const)
native final function Resume();

// Export UProgressCtrlHandle::execStart(FFrame&, void* const)
native final function Start();

// Export UProgressCtrlHandle::execSetBackTex(FFrame&, void* const)
native final function SetBackTex(string Left, string Mid, string Right);

// Export UProgressCtrlHandle::execSetBarTex(FFrame&, void* const)
native final function SetBarTex(string Left, string Mid, string Right);

defaultproperties
{
}
