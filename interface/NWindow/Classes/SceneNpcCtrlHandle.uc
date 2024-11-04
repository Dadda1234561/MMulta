//================================================================================
// SceneNpcCtrlHandle.
//================================================================================

class SceneNpcCtrlHandle extends WindowHandle
	native;

// Export USceneNpcCtrlHandle::execUpdateNpcData(FFrame&, void* const)
native final function UpdateNpcData(int Index);

// Export USceneNpcCtrlHandle::execSaveNpcData(FFrame&, void* const)
native final function SaveNpcData(int Index);

defaultproperties
{
}
