//================================================================================
// GraphicAPI.
//================================================================================

class GraphicAPI extends Object
	native
	export;

// Export UGraphicAPI::execDoFSetFocusActor(FFrame&, void* const)
native static function DoFSetFocusActor(Actor a_FocusActor);

// Export UGraphicAPI::execDoFSetFocusPlayer(FFrame&, void* const)
native static function DoFSetFocusPlayer();

// Export UGraphicAPI::execDoFSetFocusLocation(FFrame&, void* const)
native static function DoFSetFocusLocation(Vector a_FocusLocation);

// Export UGraphicAPI::execDoFSetFocusDistance(FFrame&, void* const)
native static function DoFSetFocusDistance(float a_FocusDistance);

// Export UGraphicAPI::execDoFSetStartDistance(FFrame&, void* const)
native static function DoFSetStartDistance(float a_StartDistance);

// Export UGraphicAPI::execDoFSetEndDistance(FFrame&, void* const)
native static function DoFSetEndDistance(float a_EndDistance);

// Export UGraphicAPI::execDoFPause(FFrame&, void* const)
native static function DoFPause();

// Export UGraphicAPI::execDoFResume(FFrame&, void* const)
native static function DoFResume();

defaultproperties
{
}
