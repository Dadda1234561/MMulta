class L2UIInventoryObject extends UIEventManager;

var int Index;

delegate DelegateOnAddItem (optional ItemInfo iInfo, optional int Index);

delegate DelegateOnUpdateItem (optional ItemInfo iInfo, optional int Index);

delegate DelegateOnDeletedItem (optional ItemInfo iInfo, optional int Index);

delegate bool DelegateOnCompare (optional ItemInfo iInfo, optional int Index);

defaultproperties
{
}
