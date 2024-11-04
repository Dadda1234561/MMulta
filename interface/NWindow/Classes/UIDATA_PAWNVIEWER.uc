//================================================================================
// UIDATA_PAWNVIEWER.
//================================================================================

class UIDATA_PAWNVIEWER extends UIDataManager
	native;

// Export UUIDATA_PAWNVIEWER::execGetClassNameList(FFrame&, void* const)
native static function GetClassNameList(out array<string> ClassNameList, out int SelectedIndex);

// Export UUIDATA_PAWNVIEWER::execSpawnCharacter(FFrame&, void* const)
native static function SpawnCharacter(string FullClassName);

// Export UUIDATA_PAWNVIEWER::execDuplicateCharacter(FFrame&, void* const)
native static function DuplicateCharacter();

// Export UUIDATA_PAWNVIEWER::execChangeMyPC(FFrame&, void* const)
native static function ChangeMyPC();

// Export UUIDATA_PAWNVIEWER::execGetExceptionalFaceList(FFrame&, void* const)
native static function GetExceptionalFaceList(out array<int> FaceList);

// Export UUIDATA_PAWNVIEWER::execGetExceptionallHairList(FFrame&, void* const)
native static function GetExceptionallHairList(out array<int> HairList);

// Export UUIDATA_PAWNVIEWER::execGetExceptionalHairColorList(FFrame&, void* const)
native static function GetExceptionalHairColorList(out array<int> HairColorList);

// Export UUIDATA_PAWNVIEWER::execApplyFace(FFrame&, void* const)
native static function ApplyFace(int FaceIndex);

// Export UUIDATA_PAWNVIEWER::execApplyHair(FFrame&, void* const)
native static function ApplyHair(int HairIndex);

// Export UUIDATA_PAWNVIEWER::execApplyHairColor(FFrame&, void* const)
native static function ApplyHairColor(int HairColorIndex);

// Export UUIDATA_PAWNVIEWER::execGetFaceInfo(FFrame&, void* const)
native static function GetFaceInfo(out string MeshName, out string TexName);

// Export UUIDATA_PAWNVIEWER::execGetAHairInfo(FFrame&, void* const)
native static function GetAHairInfo(out string MeshName, out string TexName);

// Export UUIDATA_PAWNVIEWER::execGetBHairInfo(FFrame&, void* const)
native static function GetBHairInfo(out string MeshName, out string TexName, out string SubExTexName);

// Export UUIDATA_PAWNVIEWER::execAdjustHairAccOffset(FFrame&, void* const)
native static function AdjustHairAccOffset(float OffsetX, float OffsetY, float OffsetZ, float Pitch, float Yaw, float Roll);

// Export UUIDATA_PAWNVIEWER::execGetHairAccOffset(FFrame&, void* const)
native static function GetHairAccOffset(out float OffsetX, out float OffsetY, out float OffsetZ, out float Pitch, out float Yaw, out float Roll);

// Export UUIDATA_PAWNVIEWER::execEquipPCItem(FFrame&, void* const)
native static function EquipPCItem(ItemID Id);

// Export UUIDATA_PAWNVIEWER::execApplyItemRefinery(FFrame&, void* const)
native static function ApplyItemRefinery(int ItemClassID, int RefineyOption1, int RefineryOption2);

// Export UUIDATA_PAWNVIEWER::execApplyItemEnchanted(FFrame&, void* const)
native static function ApplyItemEnchanted(int ItemClassID, int EnchantedValue);

// Export UUIDATA_PAWNVIEWER::execGetPCAnimationList(FFrame&, void* const)
native static function GetPCAnimationList(out array<string> AnimList);

// Export UUIDATA_PAWNVIEWER::execPlayPCAnim(FFrame&, void* const)
native static function PlayPCAnim(string AnimName, float AnimSpeed);

// Export UUIDATA_PAWNVIEWER::execPlayPCComboAnim(FFrame&, void* const)
native static function PlayPCComboAnim(string Anim1, string Anim2, string Anim3, float HitTime, float LoopIdx);

// Export UUIDATA_PAWNVIEWER::execGetAnimFrame(FFrame&, void* const)
native static function GetAnimFrame(int Index, out float frame, out float Duration, out float Dues);

// Export UUIDATA_PAWNVIEWER::execGetSimulMeshName(FFrame&, void* const)
native static function string GetSimulMeshName();

// Export UUIDATA_PAWNVIEWER::execGetVertexNumber(FFrame&, void* const)
native static function int GetVertexNumber();

// Export UUIDATA_PAWNVIEWER::execAddAnchorVertex(FFrame&, void* const)
native static function AddAnchorVertex();

// Export UUIDATA_PAWNVIEWER::execRemoveAnchorVertex(FFrame&, void* const)
native static function RemoveAnchorVertex();

// Export UUIDATA_PAWNVIEWER::execGetCollisionNumber(FFrame&, void* const)
native static function int GetCollisionNumber();

// Export UUIDATA_PAWNVIEWER::execGetCollisionType(FFrame&, void* const)
native static function GetCollisionType(out array<string> ColTypes);

// Export UUIDATA_PAWNVIEWER::execGetCollisionInfo(FFrame&, void* const)
native static function GetCollisionInfo(int ColIdx, out string ColType, out int BoneA, out int BoneB, out float Radius, out byte SphereA, out byte SphereB);

// Export UUIDATA_PAWNVIEWER::execAddCollision(FFrame&, void* const)
native static function AddCollision(string ColType, int BoneA, int BoneB, float Radius, bool SphereA, bool SphereB);

// Export UUIDATA_PAWNVIEWER::execRemoveCollision(FFrame&, void* const)
native static function RemoveCollision(int ColIdx);

// Export UUIDATA_PAWNVIEWER::execUpdateCollision(FFrame&, void* const)
native static function UpdateCollision(int ColIdx, string ColType, int BoneA, int BoneB, float Radius, bool SphereA, bool SphereB);

// Export UUIDATA_PAWNVIEWER::execGetSimulAnimName(FFrame&, void* const)
native static function string GetSimulAnimName();

// Export UUIDATA_PAWNVIEWER::execGetAnimForceNumber(FFrame&, void* const)
native static function int GetAnimForceNumber();

// Export UUIDATA_PAWNVIEWER::execGetAnimForceInfo(FFrame&, void* const)
native static function GetAnimForceInfo(int AnimIdx, out float Weight, out float frame, out float Stiff, out byte TerrainCol, out byte UseForce, out Vector Force);

// Export UUIDATA_PAWNVIEWER::execAddAnimForce(FFrame&, void* const)
native static function AddAnimForce(float Weight, float frame, float Stiff, bool TerrainCollision, bool UserForce, Vector Force);

// Export UUIDATA_PAWNVIEWER::execRemoveAnimForce(FFrame&, void* const)
native static function RemoveAnimForce(int AnimIdx);

// Export UUIDATA_PAWNVIEWER::execUpdateAnimForce(FFrame&, void* const)
native static function UpdateAnimForce(int AnimIdx, float Weight, float frame, float Stiff, bool TerrainCollision, bool UserForce, Vector Force);

// Export UUIDATA_PAWNVIEWER::execGetChestMesh(FFrame&, void* const)
native static function string GetChestMesh();

// Export UUIDATA_PAWNVIEWER::execGetMantleOffset(FFrame&, void* const)
native static function Vector GetMantleOffset();

// Export UUIDATA_PAWNVIEWER::execSetMantleOffset(FFrame&, void* const)
native static function SetMantleOffset(Vector offset);

// Export UUIDATA_PAWNVIEWER::execLoadSimulMesh(FFrame&, void* const)
native static function LoadSimulMesh();

// Export UUIDATA_PAWNVIEWER::execResetSimulMesh(FFrame&, void* const)
native static function ResetSimulMesh();

// Export UUIDATA_PAWNVIEWER::execSaveSimulMesh(FFrame&, void* const)
native static function SaveSimulMesh();

// Export UUIDATA_PAWNVIEWER::execSetPawnNum(FFrame&, void* const)
native static function SetPawnNum(int SimulPawnNum);

// Export UUIDATA_PAWNVIEWER::execSetSkillUseRatio(FFrame&, void* const)
native static function SetSkillUseRatio(float SkillUseRatio);

// Export UUIDATA_PAWNVIEWER::execSetSkillCancelRatio(FFrame&, void* const)
native static function SetSkillCancelRatio(float SkillCancelRatio);

// Export UUIDATA_PAWNVIEWER::execSetSkillDeleteRatio(FFrame&, void* const)
native static function SetSkillDeleteRatio(float PawnDelRatio);

// Export UUIDATA_PAWNVIEWER::execSetArrowRatio(FFrame&, void* const)
native static function SetArrowRatio(float ArrowRatio);

// Export UUIDATA_PAWNVIEWER::execStartSimulPawn(FFrame&, void* const)
native static function StartSimulPawn();

// Export UUIDATA_PAWNVIEWER::execExecuteSkill(FFrame&, void* const)
native static function ExecuteSkill(int SkillID, int SkillLevel, int SkillSubLevel, optional bool multiTarget);

// Export UUIDATA_PAWNVIEWER::execAddSkillByName(FFrame&, void* const)
native static function AddSkillByName(string Name);

// Export UUIDATA_PAWNVIEWER::execAddSkillByID(FFrame&, void* const)
native static function AddSkillByID(int Id);

// Export UUIDATA_PAWNVIEWER::execAddSkillByVisualEffect(FFrame&, void* const)
native static function AddSkillByVisualEffect(string visualEffect);

// Export UUIDATA_PAWNVIEWER::execAddSkillByType(FFrame&, void* const)
native static function AddSkillByType(int Type);

// Export UUIDATA_PAWNVIEWER::execSpawnDummyPawn(FFrame&, void* const)
native static function SpawnDummyPawn(int Num);

// Export UUIDATA_PAWNVIEWER::execClearDummyPawn(FFrame&, void* const)
native static function ClearDummyPawn();

// Export UUIDATA_PAWNVIEWER::execSetSimpleEmitter(FFrame&, void* const)
native static function SetSimpleEmitter(bool Use);

// Export UUIDATA_PAWNVIEWER::execSetGroundSkillCursor(FFrame&, void* const)
native static function SetGroundSkillCursor(bool Use);

// Export UUIDATA_PAWNVIEWER::execExecuteEmitterProfiling(FFrame&, void* const)
native static function ExecuteEmitterProfiling();

// Export UUIDATA_PAWNVIEWER::execStopEmitterProfiling(FFrame&, void* const)
native static function StopEmitterProfiling();

// Export UUIDATA_PAWNVIEWER::execUpdateEmitterProfiling(FFrame&, void* const)
native static function UpdateEmitterProfiling();

// Export UUIDATA_PAWNVIEWER::execIsProfilingEmitter(FFrame&, void* const)
native static function bool IsProfilingEmitter();

// Export UUIDATA_PAWNVIEWER::execGetSkillLevelListByID(FFrame&, void* const)
native static function GetSkillLevelListByID(int SkillID, array<int> skillLevelList, array<int> skillSubLevelList);

// Export UUIDATA_PAWNVIEWER::execApplyLeftAttachBoneName(FFrame&, void* const)
native static function ApplyLeftAttachBoneName(string bonename);

// Export UUIDATA_PAWNVIEWER::execApplyLeftRotation(FFrame&, void* const)
native static function ApplyLeftRotation(int Pitch, int Yaw, int Roll);

// Export UUIDATA_PAWNVIEWER::execApplyLeftOffset(FFrame&, void* const)
native static function ApplyLeftOffset(float X, float Y, float Z);

// Export UUIDATA_PAWNVIEWER::execApplyLeftSheathingHide(FFrame&, void* const)
native static function ApplyLeftSheathingHide(bool bHide);

// Export UUIDATA_PAWNVIEWER::execApplyRightAttachBoneName(FFrame&, void* const)
native static function ApplyRightAttachBoneName(string bonename);

// Export UUIDATA_PAWNVIEWER::execApplyRightRotation(FFrame&, void* const)
native static function ApplyRightRotation(int Pitch, int Yaw, int Roll);

// Export UUIDATA_PAWNVIEWER::execApplyRightOffset(FFrame&, void* const)
native static function ApplyRightOffset(float X, float Y, float Z);

// Export UUIDATA_PAWNVIEWER::execApplyRightSheathingHide(FFrame&, void* const)
native static function ApplyRightSheathingHide(bool bHide);

// Export UUIDATA_PAWNVIEWER::execSpawnNPC(FFrame&, void* const)
native static function SpawnNPC(int NpcClassID, out float GoundSpeed, out float AnimRate, out float CollisionRadius, out float CollisionHeight, out float DrawScale, out int PawnState);

// Export UUIDATA_PAWNVIEWER::execApplyPawnSetting(FFrame&, void* const)
native static function ApplyPawnSetting(float GroundSpeed, float AnimRate, float CollisionRadius, float CollisionHeight, float DrawScale, int PawnState);

// Export UUIDATA_PAWNVIEWER::execSpawnActorAtMyLocation(FFrame&, void* const)
native static function SpawnActorAtMyLocation(int NpcClassID);

// Export UUIDATA_PAWNVIEWER::execGetNPCAnimationList(FFrame&, void* const)
native static function GetNPCAnimationList(out array<string> AnimList);

// Export UUIDATA_PAWNVIEWER::execPlayNPCAnim(FFrame&, void* const)
native static function PlayNPCAnim(string sAnimName, float AnimRate);

// Export UUIDATA_PAWNVIEWER::execEquipNPCItem(FFrame&, void* const)
native static function EquipNPCItem(ItemID Id);

// Export UUIDATA_PAWNVIEWER::execGetBoneNameList(FFrame&, void* const)
native static function GetBoneNameList(out array<string> BoneNameList);

// Export UUIDATA_PAWNVIEWER::execShowSelectedBone(FFrame&, void* const)
native static function ShowSelectedBone(string SelectedBoneName);

defaultproperties
{
}
