//================================================================================
// ScenePcCtrlHandle.
//================================================================================

class ScenePcCtrlHandle extends WindowHandle
	native;

// Export UScenePcCtrlHandle::execUpdatePcData(FFrame&, void* const)
native final function UpdatePcData(int Index);

// Export UScenePcCtrlHandle::execSavePcData(FFrame&, void* const)
native final function SavePcData(int Index);

defaultproperties
{
}
