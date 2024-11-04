//================================================================================
// FlashCtrlHandle.
//================================================================================

class FlashCtrlHandle extends WindowHandle
	native;

// Export UFlashCtrlHandle::execPlay(FFrame&, void* const)
native final function Play();

// Export UFlashCtrlHandle::execPause(FFrame&, void* const)
native final function Pause();

// Export UFlashCtrlHandle::execStop(FFrame&, void* const)
native final function Stop();

// Export UFlashCtrlHandle::execGetTotalFrameCnt(FFrame&, void* const)
native final function int GetTotalFrameCnt();

// Export UFlashCtrlHandle::execGetCurrentFrame(FFrame&, void* const)
native final function int GetCurrentFrame();

// Export UFlashCtrlHandle::execGotoFrame(FFrame&, void* const)
native final function GotoFrame(int a_FrameNumber);

// Export UFlashCtrlHandle::execSetFlashFile(FFrame&, void* const)
native final function bool SetFlashFile(string a_FlashFile);

// Export UFlashCtrlHandle::execInvoke(FFrame&, void* const)
native final function bool Invoke(string a_Command, ParamMap a_Param);

defaultproperties
{
}
