//================================================================================
// SceneScreenCtrlHandle.
//================================================================================

class SceneScreenCtrlHandle extends WindowHandle
	native;

// Export USceneScreenCtrlHandle::execUpdateScreenData(FFrame&, void* const)
native final function UpdateScreenData(int Index);

// Export USceneScreenCtrlHandle::execSaveScreenData(FFrame&, void* const)
native final function SaveScreenData(int Index);

defaultproperties
{
}
