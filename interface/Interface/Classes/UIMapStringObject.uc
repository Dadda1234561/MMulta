class UIMapStringObject extends Object;

struct mapKeyStruct
{
	var string Key;
	var string Data;
};

var array<mapKeyStruct> dataArray;

function Add(string Key, string dataString)
{
	local int i;

	for(i = 0; i < dataArray.Length; i++)
	{
		if(dataArray[i].Key == Key)
		{
			dataArray[i].Data = dataString;
			return;
		}
	}
	dataArray.Length = dataArray.Length + 1;
	dataArray[dataArray.Length - 1].Key = Key;
	dataArray[dataArray.Length - 1].Data = dataString;
}

function bool HasKey(string Key)
{
	local int i;

	for(i = 0; i < dataArray.Length; i++)
	{
		// End:0x33
		if(dataArray[i].Key == Key)
		{
			return true;
		}
	}
	return false;
}

function string Find(string Key)
{
	local int i;

	for(i = 0; i < dataArray.Length; i++)
	{
		// End:0x42
		if(dataArray[i].Key == Key)
		{
			return dataArray[i].Data;
		}
	}
	return "";
}

function string FindKeyByData(string Data)
{
	local int i;

	// End:0x4C [Loop If]
	for(i = 0; i < dataArray.Length; i++)
	{
		// End:0x42
		if(dataArray[i].Data == Data)
		{
			return dataArray[i].Key;
		}
	}
	return "";	
}

function RemoveAll()
{
	dataArray.Remove(0, dataArray.Length);
}

function Remove(string Key)
{
	local int i;

	for(i = 0; i < dataArray.Length; i++)
	{
		if(dataArray[i].Key == Key)
		{
			dataArray.Remove(i, 1);
			break;
		}
	}
}

function array<string> ContainAll()
{
	local int i;
	local array<string> arr;

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

	for(i = 0; i < dataArray.Length; i++)
	{
		// End:0x51
		if(rStr == "")
		{
			rStr = dataArray[i].Data;
			continue;
		}
		rStr = rStr $ DividerString $ dataArray[i].Data;
	}
	return rStr;
}

defaultproperties
{
}
