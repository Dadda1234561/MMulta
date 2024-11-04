//================================================================================
// RadarMapCtrlHandle.
//================================================================================

class RadarMapCtrlHandle extends WindowHandle
	native;

// Export URadarMapCtrlHandle::execAddObject(FFrame&, void* const)
native final function AddObject(int Id, string Type, string Name, int locX, int locY, int locZ);

// Export URadarMapCtrlHandle::execDeleteObject(FFrame&, void* const)
native final function DeleteObject(int ObjectID);

// Export URadarMapCtrlHandle::execUpdateObject(FFrame&, void* const)
native final function UpdateObject(int Id, int worldX, int worldY, int worldZ);

// Export URadarMapCtrlHandle::execRequestObjectAround(FFrame&, void* const)
native final function RequestObjectAround(int ObjectType, int DistanceLimitXY, int DistanceLimitZ);

// Export URadarMapCtrlHandle::execSetMagnification(FFrame&, void* const)
native final function SetMagnification(float newMag);

// Export URadarMapCtrlHandle::execSetEnableRotation(FFrame&, void* const)
native final function SetEnableRotation(bool bEnable);

// Export URadarMapCtrlHandle::execSetMapInvisible(FFrame&, void* const)
native final function SetMapInvisible(bool bInvisible);

// Export URadarMapCtrlHandle::execSwitchSingleMeshMode(FFrame&, void* const)
native final function SwitchSingleMeshMode(bool bUse);

defaultproperties
{
}
