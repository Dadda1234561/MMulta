//=============================================================================
// Emitter: An Unreal Mesh Particle Emitter.
//=============================================================================
class MeshEmitter extends ParticleEmitter
	native;


var (Mesh)		staticmesh		StaticMesh;
var (Mesh)		bool			UseMeshBlendMode;
var (Mesh)		bool			RenderTwoSided;
var (Mesh)		bool			UseParticleColor;
var ()			bool			IsEnchantEffect;

var	transient	vector			MeshExtent;


// Decompiled with UE Explorer.
defaultproperties
{
    UseMeshBlendMode=true
    StartSizeRange=(X=(Min=1,Max=1),Y=(Min=1,Max=1),Z=(Min=1,Max=1))
}