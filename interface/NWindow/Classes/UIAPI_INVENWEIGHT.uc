//================================================================================
// UIAPI_INVENWEIGHT.
//================================================================================

class UIAPI_INVENWEIGHT extends UIAPI_WINDOW
	native;

// Export UUIAPI_INVENWEIGHT::execAddWeight(FFrame&, void* const)
native static function AddWeight(string ControlName, INT64 Weight);

// Export UUIAPI_INVENWEIGHT::execReduceWeight(FFrame&, void* const)
native static function ReduceWeight(string ControlName, INT64 Weight);

// Export UUIAPI_INVENWEIGHT::execZeroWeight(FFrame&, void* const)
native static function ZeroWeight(string ControlName);

defaultproperties
{
}
