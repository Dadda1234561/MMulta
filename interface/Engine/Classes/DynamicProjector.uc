class DynamicProjector extends Projector;

function Tick(float DeltaTime)
{
	DetachProjector();
	AttachProjector();
}


// Decompiled with UE Explorer.
defaultproperties
{
    bDynamicAttach=true
    bStatic=false
}