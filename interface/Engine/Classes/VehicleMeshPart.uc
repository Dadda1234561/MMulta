class VehicleMeshPart extends Pawn
	native
	abstract
	dynamicrecompile
	placeable;
	
//Sound
var Sound SpawnSound;
var Sound BasicSound;
var Sound MoveUpSound;
var Sound MoveDownSound;
var Sound TurnSound;
var array<Sound> RandomSounds;

event OnDriverIn( int a_DriverID );
event OnDriverOut();
event OnStart();
event OnStop();
event OnBoost();
event OnMoveUp()
{
	PlaySound( MoveUpSound, SLOT_None );
}
event OnMoveDown()
{
	PlaySound( MoveDownSound, SLOT_None );
}
event OnTurning()
{
	PlaySound( TurnSound, SLOT_None );
}

simulated function PostSetPawnResource()
{
	LoopAnim('wait');
	PlaySound( SpawnSound, SLOT_None );
	PlayLoopSound( BasicSound, SLOT_None, , , , , , 3.f );
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetActorViewType( EAVT_Spawning );
	SetAlphaTexModifier( 1 );
}

function Destroyed()
{
	StopSound( BasicSound );
	Super.Destroyed();
}

// Decompiled with UE Explorer.
defaultproperties
{
    bHardAttach=true
    TransientSoundVolume=1
    TransientSoundRadius=50
    CollisionRadius=10
    CollisionHeight=10
    bCollideActors=false
    bCollideWorld=false
    bBlockActors=false
    bBlockPlayers=false
}