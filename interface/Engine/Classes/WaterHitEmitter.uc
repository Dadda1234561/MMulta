class WaterHitEmitter extends Emitter
	dynamicrecompile
	native;

// spawning rate
event float GetSpawnRate(float PawnVelocity)
{
	return 1.0;
}
