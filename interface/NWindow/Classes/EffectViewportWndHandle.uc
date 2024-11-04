//================================================================================
// EffectViewportWndHandle.
//================================================================================

class EffectViewportWndHandle extends WindowHandle
	native;

// Export UEffectViewportWndHandle::execSetScale(FFrame&, void* const)
native function SetScale(float fScale);

// Export UEffectViewportWndHandle::execSetOffset(FFrame&, void* const)
native function SetOffset(Vector VOffset);

// Export UEffectViewportWndHandle::execSetCameraDistance(FFrame&, void* const)
native function SetCameraDistance(float fDist);

// Export UEffectViewportWndHandle::execSetCameraPitch(FFrame&, void* const)
native function SetCameraPitch(int nPitch);

// Export UEffectViewportWndHandle::execSetCameraYaw(FFrame&, void* const)
native function SetCameraYaw(int nYaw);

// Export UEffectViewportWndHandle::execSpawnEffect(FFrame&, void* const)
native function SpawnEffect(string EffectName);

defaultproperties
{
}
