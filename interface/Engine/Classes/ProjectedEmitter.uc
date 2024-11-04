class ProjectedEmitter extends Emitter
	native
	placeable;
	
var  int rtUSize, rtVSize;


var(ProjectedEmitter)	rotator		ProjectorDirection;
var(ProjectedEmitter)	float	    ProjectorClippingDistance;
var(ProjectedEmitter)	float		ProjectorSizeX;
var(ProjectedEmitter)	float		ProjectorSizeY;
var transient			float		ProjectorDrawScale;

var Projector.EProjectorBlending	ProjectorFrameBufferBlendingOp;

var	transient			ParticleProjector			projector;
var	transient			vector	ProjectorHitLocation;
var	transient			float	ProjectorHitRadius;
var	transient			int		ProjectorCurrentLOD;
var const transient		int		RenderTarget;
var transient			ProxyBitmapMaterial renderTargetTexture;


// Decompiled with UE Explorer.
defaultproperties
{
    rtUSize=256
    rtVSize=256
    ProjectorDirection=(Pitch=49152,Yaw=0,Roll=0)
    ProjectorClippingDistance=1000
    ProjectorSizeX=100
    ProjectorSizeY=100
}