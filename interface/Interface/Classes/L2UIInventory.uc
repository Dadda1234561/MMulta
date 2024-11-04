class L2UIInventory extends UIScript;

var array<L2UIInventoryObject> inventoryObjects;
var array<L2UIInventoryObjectSimple> inventoryObjectsSimple;
var L2UIInventoryObjectFindByCompare L2UIInventoryFindByCompare;

static function L2UIInventory Inst()
{
	return L2UIInventory(GetScript("L2UIInventory"));
}

function OnLoad()
{
	L2UIInventoryFindByCompare = new Class'L2UIInventoryObjectFindByCompare';
}

function OnRegisterEvent()
{
	RegisterEvent(EV_InventoryUpdateItem);
	RegisterEvent(EV_AdenaInvenCount);
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_InventoryUpdateItem:
			HandleUpdateItem(param);
			break;
		case EV_AdenaInvenCount:
			HandleAdenaInevenCount(param);
			break;
	}
}

function HandleAdenaInevenCount(string param)
{
	local array<ItemInfo> iInfos;
	local int i;

	for (i = 0;i < inventoryObjectsSimple.Length;i++)
	{
		iInfos.Length = 0;
		FindItem(inventoryObjectsSimple[i].iID, iInfos);
		if (inventoryObjectsSimple[i].iID.ClassID > 0)
		{
			inventoryObjectsSimple[i].DelegateOnUpdateItem(iInfos, inventoryObjectsSimple[i].Index);
		}
	}
}

function L2UIInventoryObjectSimple NewObjectSimple(int ClassID, optional int ServerID, optional int Index)
{
	local int Len;

	Len = inventoryObjectsSimple.Length;
	inventoryObjectsSimple[Len] = new Class'L2UIInventoryObjectSimple';
	inventoryObjectsSimple[Len].iID.ClassID = ClassID;
	inventoryObjectsSimple[Len].iID.ServerID = ServerID;
	inventoryObjectsSimple[Len].Index = Index;
	return inventoryObjectsSimple[Len];
}

function RemObjectSimpleByObject(L2UIInventoryObjectSimple iObject)
{
	local int i;

	for (i = 0; i < inventoryObjectsSimple.Length; i++)
	{
		if (iObject == inventoryObjectsSimple[i])
		{
			inventoryObjectsSimple.Remove(i, 1);
			return;
		}
	}
}

function RemObjectSimple(int ClassID, optional int ServerID)
{
	local int i;

	for (i = 0;i < inventoryObjectsSimple.Length;i++)
	{
		if ((inventoryObjectsSimple[i].iID.ClassID == ClassID) && (inventoryObjectsSimple[i].iID.ServerID == ServerID))
		{
			inventoryObjectsSimple.Remove(i, 1);
			return;
		}
	}
}

function HandleUpdateItem(string param)
{
	local int i;
	local ItemInfo iInfo;
	local string Type;

	ParseString(param, "type", Type);
	ParamToItemInfo(param, iInfo);
	
	for (i = 0;i < inventoryObjects.Length;i++)
	{
		if (!inventoryObjects[i].DelegateOnCompare(iInfo, inventoryObjects[i].Index))
		{
			continue;
		}
		switch(Type)
		{
			case "add":
				inventoryObjects[i].DelegateOnAddItem(iInfo, inventoryObjects[i].Index);
				break;
			case "update":
				inventoryObjects[i].DelegateOnUpdateItem(iInfo, inventoryObjects[i].Index);
				break;
			case "delete":
				inventoryObjects[i].DelegateOnDeletedItem(iInfo, inventoryObjects[i].Index);
				break;
		}
	}
}

function L2UIInventoryObject NewObject()
{
	inventoryObjects[inventoryObjects.Length] = new class'L2UIInventoryObject';
	return inventoryObjects[inventoryObjects.Length - 1];
}

function bool FindItem(ItemID Id, out array<ItemInfo> iInfos)
{
	local ItemInfo iInfo;

	if (Id.ServerID > 0)
	{
		Class 'UIDATA_INVENTORY'.static.FindItem(Id.ServerID, iInfo);
		iInfos[0] = iInfo;
	}
	else
	{
		Class 'UIDATA_INVENTORY'.static.FindItemByClassID(Id.ClassID, iInfos);
	}
	return iInfos.Length > 0;
}

defaultproperties
{
}
