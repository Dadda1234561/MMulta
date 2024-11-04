//================================================================================
// SliderCtrlHandle.
//================================================================================

class SliderCtrlHandle extends WindowHandle
	native;

// Export USliderCtrlHandle::execGetCurrentTick(FFrame&, void* const)
native final function int GetCurrentTick();

// Export USliderCtrlHandle::execSetCurrentTick(FFrame&, void* const)
native final function SetCurrentTick(int iCurrTick);

// Export USliderCtrlHandle::execGetTotalTickCount(FFrame&, void* const)
native final function int GetTotalTickCount();

// Export USliderCtrlHandle::execSetTotalTickCount(FFrame&, void* const)
native final function SetTotalTickCount(int a_TotalTickCount);

// Export USliderCtrlHandle::execIsMouseScrolling(FFrame&, void* const)
native final function bool IsMouseScrolling();

defaultproperties
{
}
