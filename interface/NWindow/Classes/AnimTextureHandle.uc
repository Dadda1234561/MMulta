//================================================================================
// AnimTextureHandle.
//================================================================================

class AnimTextureHandle extends TextureHandle
	native;

// Export UAnimTextureHandle::execSetLoopCount(FFrame&, void* const)
native final function SetLoopCount(int a_LoopCount);

// Export UAnimTextureHandle::execSetTimes(FFrame&, void* const)
native final function SetTimes(float f_Times);

// Export UAnimTextureHandle::execPlay(FFrame&, void* const)
native final function Play();

// Export UAnimTextureHandle::execPause(FFrame&, void* const)
native final function Pause();

// Export UAnimTextureHandle::execStop(FFrame&, void* const)
native final function Stop();

defaultproperties
{
}
