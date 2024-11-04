class UIMapInt64Object extends Object;

struct mapKeyStruct
{
	var INT64 Key;
	var INT64 Data;
};

var array<mapKeyStruct> dataArray;

function Add(INT64 Key, INT64 DataValue)
{
	local int i;

	for(i = 0; i < dataArray.Length; i++)
	{
		// End:0x4A
		if(dataArray[i].Key == Key)
		{
			dataArray[i].Data = DataValue;
			return;
		}
	}
	dataArray.Length = dataArray.Length + 1;
	dataArray[dataArray.Length - 1].Key = Key;
	dataArray[dataArray.Length - 1].Data = DataValue;
}

function AddIncrease(INT64 Key, INT64 DataValue)
{
	local int i;

	for(i = 0; i < dataArray.Length; i++)
	{
		// End:0x5D
		if(dataArray[i].Key == Key)
		{
			dataArray[i].Data = dataArray[i].Data + DataValue;
			return;
		}
	}
	dataArray.Length = dataArray.Length + 1;
	dataArray[dataArray.Length - 1].Key = Key;
	dataArray[dataArray.Length - 1].Data = DataValue;
}

function bool HasKey(INT64 Key)
{
	local int i;

	// End:0x3E [Loop If]
	for(i = 0; i < dataArray.Length; i++)
	{
		// End:0x34
		if(dataArray[i].Key == Key)
		{
			return true;
		}
	}
	return false;
}

function INT64 Find(INT64 Key)
{
	local int i;

	// End:0x4D [Loop If]
	for(i = 0; i < dataArray.Length; i++)
	{
		// End:0x43
		if(dataArray[i].Key == Key)
		{
			return dataArray[i].Data;
		}
	}
	return -1;
}

function INT64 FindKeyByData(INT64 Data)
{
	local int i;

	// End:0x4D [Loop If]
	for(i = 0; i < dataArray.Length; i++)
	{
		// End:0x43
		if(dataArray[i].Data == Data)
		{
			return dataArray[i].Key;
		}
	}
	return -1;	
}

function RemoveAll()
{
	dataArray.Remove(0, dataArray.Length);
}

function Remove(INT64 Key)
{
	local int i;

	for(i = 0; i < dataArray.Length; i++)
	{
		// End:0x41
		if(dataArray[i].Key == Key)
		{
			dataArray.Remove(i, 1);
			// [Explicit Break]
			break;
		}
	}
}

function array<INT64> ContainAll()
{
	local int i;
	local array<INT64> arr;

	// End:0x51 [Loop If]
	for(i = 0; i < dataArray.Length; i++)
	{
		arr.Length = arr.Length + 1;
		arr[arr.Length - 1] = dataArray[i].Data;
	}
	return arr;
}

function int Size()
{
	return dataArray.Length;
}

function string ToString(optional string DividerString)
{
	local int i;
	local string rStr;

	// End:0x15
	if(DividerString == "")
	{
		DividerString = ",";
	}

	// End:0x83 [Loop If]
	for(i = 0; i < dataArray.Length; i++)
	{
		if(rStr == "")
		{
			rStr = string(dataArray[i].Data);
			continue;
		}
		rStr = rStr $ DividerString $ string(dataArray[i].Data);
	}
	return rStr;
}

defaultproperties
{
}
