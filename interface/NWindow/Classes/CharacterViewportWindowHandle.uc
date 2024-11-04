//================================================================================
// CharacterViewportWindowHandle.
//================================================================================

class CharacterViewportWindowHandle extends WindowHandle
	native;

// Export UCharacterViewportWindowHandle::execStartRotation(FFrame&, void* const)
native final function StartRotation(bool bRight);

// Export UCharacterViewportWindowHandle::execEndRotation(FFrame&, void* const)
native final function EndRotation();

// Export UCharacterViewportWindowHandle::execStartZoom(FFrame&, void* const)
native final function StartZoom(bool bOut);

// Export UCharacterViewportWindowHandle::execEndZoom(FFrame&, void* const)
native final function EndZoom();

// Export UCharacterViewportWindowHandle::execSetCharacterScale(FFrame&, void* const)
native final function SetCharacterScale(float fCharacterScale);

// Export UCharacterViewportWindowHandle::execSetCharacterOffsetX(FFrame&, void* const)
native final function SetCharacterOffsetX(int nOffSetX);

// Export UCharacterViewportWindowHandle::execSetCharacterOffsetY(FFrame&, void* const)
native final function SetCharacterOffsetY(int nOffSetY);

// Export UCharacterViewportWindowHandle::execSpawnNPC(FFrame&, void* const)
native final function SpawnNPC();

// Export UCharacterViewportWindowHandle::execSpawnEffect(FFrame&, void* const)
native final function SpawnEffect(string EffectName);

// Export UCharacterViewportWindowHandle::execSetUISound(FFrame&, void* const)
native final function SetUISound(bool IsUISound);

// Export UCharacterViewportWindowHandle::execSetCharacterOffsetZ(FFrame&, void* const)
native final function SetCharacterOffsetZ(int nOffsetZ);

// Export UCharacterViewportWindowHandle::execSetCharacterOffset(FFrame&, void* const)
native final function SetCharacterOffset(Vector vCharacterOffset);

// Export UCharacterViewportWindowHandle::execPlayAnimation(FFrame&, void* const)
native final function PlayAnimation(int Index);

// Export UCharacterViewportWindowHandle::execPlayAttackAnimation(FFrame&, void* const)
native final function PlayAttackAnimation(int Index);

// Export UCharacterViewportWindowHandle::execAutoAttacking(FFrame&, void* const)
native final function AutoAttacking(bool bAttack);

// Export UCharacterViewportWindowHandle::execShowNPC(FFrame&, void* const)
native final function ShowNPC(float Duration);

// Export UCharacterViewportWindowHandle::execHideNPC(FFrame&, void* const)
native final function HideNPC(float Duration);

// Export UCharacterViewportWindowHandle::execSetNPCInfo(FFrame&, void* const)
native final function SetNPCInfo(int Id);

// Export UCharacterViewportWindowHandle::execSetDragRotationRate(FFrame&, void* const)
native final function SetDragRotationRate(int nRotationRate);

// Export UCharacterViewportWindowHandle::execSetCurrentRotation(FFrame&, void* const)
native final function SetCurrentRotation(int nRotation);

// Export UCharacterViewportWindowHandle::execSetCameraDistance(FFrame&, void* const)
native final function SetCameraDistance(int nDist);

// Export UCharacterViewportWindowHandle::execSetSpawnDuration(FFrame&, void* const)
native final function SetSpawnDuration(float fDuration);

// Export UCharacterViewportWindowHandle::execSetNPCViewportData(FFrame&, void* const)
native final function SetNPCViewportData(int Id);

// Export UCharacterViewportWindowHandle::execApplyPreviewCostumeItem(FFrame&, void* const)
native final function ApplyPreviewCostumeItem(int ItemClassID);

// Export UCharacterViewportWindowHandle::execSetBackgroundTex(FFrame&, void* const)
native final function SetBackgroundTex(string BackTexName);

defaultproperties
{
}
