class L2UIInventoryObjectFindByCompare extends UIEventManager;

delegate bool DelegateCompare (optional ItemInfo iInfos);

function array<ItemInfo> GetAllItemByCompare ()
{
	local int i;
	local array<ItemInfo> iInfos;
	local array<ItemInfo> newiInfos;

	Class'UIDATA_INVENTORY'.static.GetAllItem(iInfos);
	
	for (i = 0; i < iInfos.Length; i++ )
	{
		if ( DelegateCompare(iInfos[i]) )
		{
			newiInfos[newiInfos.Length] = iInfos[i];
		}
	}
	return newiInfos;
}

defaultproperties
{
}
