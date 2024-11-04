//================================================================================
// SceneMusicCtrlHandle.
//================================================================================

class SceneMusicCtrlHandle extends WindowHandle
	native;

// Export USceneMusicCtrlHandle::execUpdateMusicData(FFrame&, void* const)
native final function UpdateMusicData(int Index);

// Export USceneMusicCtrlHandle::execSaveMusicData(FFrame&, void* const)
native final function SaveMusicData(int Index);

defaultproperties
{
}
