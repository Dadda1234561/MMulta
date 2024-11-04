//================================================================================
// L2UIInventoryObjectSimple.
//================================================================================

class L2UIInventoryObjectSimple extends UIEventManager;

var ItemID iID;
var int Index;

delegate DelegateOnUpdateItem (optional array<ItemInfo> iInfo, optional int Index);

function setId(optional ItemID Id)
{
	iID = Id;
}

defaultproperties
{
}
