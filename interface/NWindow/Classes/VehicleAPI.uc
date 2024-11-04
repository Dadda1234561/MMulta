//================================================================================
// VehicleAPI.
//================================================================================

class VehicleAPI extends UIEventManager
	native;

// Export UVehicleAPI::execGetVehicle(FFrame&, void* const)
native static function Vehicle GetVehicle(int a_VehicleID);

// Export UVehicleAPI::execRequestExAirShipTeleport(FFrame&, void* const)
native static function RequestExAirShipTeleport(int a_SpotID);

// Export UVehicleAPI::execAirShipMoveUp(FFrame&, void* const)
native static function AirShipMoveUp();

// Export UVehicleAPI::execAirShipMoveDown(FFrame&, void* const)
native static function AirShipMoveDown();

defaultproperties
{
}
