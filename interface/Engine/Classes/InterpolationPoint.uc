//=============================================================================
// InterpolationPoint.
// Used as destinations to move the camera to in Matinee scenes.
//=============================================================================
class InterpolationPoint extends Keypoint
	native;

#exec Texture Import File=Textures\InterpolationPoint.pcx Name=S_Interp Mips=Off MASKED=1


// Decompiled with UE Explorer.
defaultproperties
{
    Texture=Texture'S_Interp'
    DrawScale=0.35
    bDirectional=true
}