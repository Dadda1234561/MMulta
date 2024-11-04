//================================================================================
// SceneCameraCtrlHandle.
//================================================================================

class SceneCameraCtrlHandle extends WindowHandle
	native;

// Export USceneCameraCtrlHandle::execUpdateCameraData(FFrame&, void* const)
native final function UpdateCameraData(int Index);

// Export USceneCameraCtrlHandle::execSaveCameraData(FFrame&, void* const)
native final function SaveCameraData(int Index);

defaultproperties
{
}
