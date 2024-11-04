class UICustomPacket extends UIPacket
	dynamicrecompile
	Export;
	
var FileLog TempLog;	
var LocalStorageEX localStorage;
var PlayerController P;

const C_EX_C_REQ_ITEMS_TO_ENCHANT = 0;
const C_EX_C_REQ_COLLECTION_FEE_LIST = 1;
const C_EX_C_REQ_COLLECTION_BUY = 2;
const C_EX_C_REQ_COSTUME_LIST = 3;
const C_EX_C_REQ_COSTUME_ACTION = 4;
const C_EX_C_RECEIVE_ALL_ONE_DAY_REWARDS = 5;
const C_EX_C_ITEM_ENCHANT_LIMIT = 6;
const C_EX_C_REQ_ITEMS_TO_COMMISSION = 7;
const C_EX_C_REQ_CC_RESET = 8;
const C_EX_C_REQ_AUTO_RANDOM_CRAFT_INFO = 9;
const C_EX_C_TARGET_ACTION = 10;

const S_EX_C_MONSTER_DROP_LIST = 0;
const S_EX_C_ITEMS_TO_ENCHANT_LIST = 1;
const S_EX_C_ITEMS_TO_ENCHANT_LIST_MULTI = 2;
const S_EX_C_COLLECTION_FEE_LIST = 3;
const S_EX_C_COSTUME_LIST = 4;
const S_EX_C_COSTUME_ACTIVATE = 5;
const S_EX_C_COSTUME_ACTION_RESULT = 6;
const S_EX_C_COLLECTION_PURCHASE_LIST = 7;
const S_EX_C_PREDEFINED_CHANCES_ITEM_JEWEL = 8;
const S_EX_C_PREDEFINED_CHANCES_ITEM_ENCHANT = 9;
const S_EX_C_ITEM_ENCHANT_LIMIT = 10;
const S_EX_C_ITEM_JEWEL_ENCHANT_LIMIT = 11;
const S_EX_C_CUSTOM_COMBINATION_CHANCE = 12;
const S_EX_C_ITEMS_TO_COMMISSION_LIST = 13;
const S_EX_C_TARGET_STATUS = 14;
const S_EX_C_AUTO_RANDOM_CRAFT_INFO = 15;

struct _DropItem
{
	var int cType;
	var int nItemClassID;
	var int cEnchant;
	var INT64 nMinAmount;
	var INT64 nMaxAmount;
	var string wstrChance;
};

struct _S_EX_MONSTER_DROP_LIST
{
	var int nNpcId;
	var int cLevel;
	var INT64 nExpReward;
	var INT64 nSpReward;
	var int nMaxHp;
	var int nCurHp;
	var int nMaxMp;
	var int nCurMp;
	var int nPAtk;
	var int nMAtk;
	var int nPDef;
	var int nMDef;
	var array<_DropItem> vDropItemList;
};

struct _Costume
{
	var int nId;
	var int cGrade;
	var int nSkillId;
	var int nSkillLevel;
	var int nSkillSubLevel;
	var int nViewItemId;
	var byte bPurchased;
	var byte bAvailable;
	var int cFlags;
	var array<_ItemInfo> vFeeItems;
};

struct _ItemEmchantLimit
{
	var int nItemID;
	var int cItemEnchantLevel;
};

struct _S_EX_C_COSTUME_LIST
{
	var int cCurrentPage;
	var int cMaxPage;
	var int nActiveCostumeId;
	var array<_Costume> vCostumeList;
};

struct _S_EX_C_COSTUME_ACTIVATE
{
	var byte bActive;
};

struct _S_EX_C_COSTUME_ACTION_RESULT
{
	var int nCostumeId;
	var int cAction;
	var int cResult;
};

struct _S_EX_C_COLLECTION_FEE_LIST
{
	var int nCollectionId;
	var array<_ItemInfo> vFeeItemList;
};

struct _S_EX_C_ITEMS_TO_ENCHANT_LIST
{
	var array<int> vItemList;
};

struct _S_EX_C_ITEMS_TO_ENCHANT_LIST_MULTI
{
	var array<int> vItemList;
};

struct _S_EX_C_ITEMS_TO_COMMISSION_LIST
{
	var array<int> vItemList;
};

struct _S_EX_C_COLLECTION_PURCHASE_LIST
{
	var array<int> vPurchaseList;
};

struct _S_EX_C_PREDEFINED_CHANCES_ITEM_JEWEL
{
    var int nCurrent;
    var int nMax;
};

struct _S_EX_C_PREDEFINED_CHANCES_ITEM_ENCHANT
{
    var int nCurrent;
    var int nMax;
};

struct _S_EX_C_ITEM_ENCHANT_LIMIT
{
    var array<_ItemEmchantLimit> nItemEmchantLimit;
};

struct _S_EX_C_ITEM_JEWEL_ENCHANT_LIMIT
{
    var array<int> nItemJewelEmchantLimit;
};

struct _S_EX_C_CUSTOM_COMBINATION_CHANCE
{
    var int nChance;
};

struct _S_EX_C_TARGET_STATUS
{
    var int nTargetId;
	var int nFlags;
    var int nTargetCP;
};

struct _S_EX_C_AUTO_RANDOM_CRAFT_INFO
{
	var int cCurrentPage;
	var int cMaxPage;
	var int nActiveCostumeId;
	var array<int> vChargeItems;
	var array<int> vCraftItems;
};

struct _C_EX_C_REQ_ITEMS_TO_ENCHANT
{
	var byte bMulti;
};

struct _C_EX_C_REQ_COLLECTION_FEE_LIST
{
	var int nCollectionId;
};

struct _C_EX_C_REQ_COLLECTION_BUY
{
	var int nCollectionId;
	var int nItemId;
	var INT64 nItemCount;
};

struct _C_EX_C_REQ_COSTUME_LIST
{
	var int cDummy;
};

struct _C_EX_C_REQ_COSTUME_ACTION
{
	var int nCostumeId;
	var byte cAction;
	var int nItemId;
	var INT64 nItemCount;
};

struct _C_EX_C_RECEIVE_ALL_ONE_DAY_REWARDS
{
	var int cDummy;
};

struct _C_EX_C_ITEM_ENCHANT_LIMIT
{
	var int nScrollId;
};

struct _C_EX_C_REQ_ITEMS_TO_COMMISSION
{
	var int cDummy;
};

struct _C_EX_C_REQ_CC_RESET
{
	var int cDummy;
};

struct _C_EX_C_REQ_AUTO_RANDOM_CRAFT_INFO
{
	var int cDummy;
};

struct _C_EX_C_TARGET_ACTION
{
	var int nObjectId;
	var int cAction;
};

static function bool Decode_S_C_EX_MONSTER_DROP_LIST(out _S_EX_MONSTER_DROP_LIST packet)
{
	local int i, nSize;
	
	if(! DecodeInt(packet.nNpcId))
	{
		return false;
	}
	if(! DecodeChar(packet.cLevel))
	{
		return false;
	}
	if(! DecodeInt64(packet.nExpReward))
	{
		return false;
	}
	if(! DecodeInt64(packet.nSpReward))
	{
		return false;
	}
	if(! DecodeInt(packet.nMaxHp))
	{
		return false;
	}
	if(! DecodeInt(packet.nCurHp))
	{
		return false;
	}
	if(! DecodeInt(packet.nMaxMp))
	{
		return false;
	}
	if(! DecodeInt(packet.nCurMp))
	{
		return false;
	}
	if(! DecodeInt(packet.nPAtk))
	{
		return false;
	}
	if(! DecodeInt(packet.nMAtk))
	{
		return false;
	}
	if(! DecodeInt(packet.nPDef))
	{
		return false;
	}
	if(! DecodeInt(packet.nMDef))
	{
		return false;
	}
	if(! DecodeInt(nSize))
	{
		return false;
	}
	packet.vDropItemList.Length = nSize;
	
	for(i = 0; i < packet.vDropItemList.Length; i++)
	{
		if(! Decode_DropItem(packet.vDropItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_DropItem(out _DropItem packet)
{
	if(! DecodeChar(packet.cType))
	{
		return false;
	}
	if(! DecodeInt(packet.nItemClassID))
	{
		return false;
	}
	if(! DecodeChar(packet.cEnchant))
	{
		return false;
	}
	if(! DecodeInt64(packet.nMinAmount))
	{
		return false;
	}
	if(! DecodeInt64(packet.nMaxAmount))
	{
		return false;
	}
	if(! DecodeWString(packet.wstrChance, true))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_C_ITEMS_TO_ENCHANT_LIST(out _S_EX_C_ITEMS_TO_ENCHANT_LIST packet)
{
	local int i, nSize;
	
	if(! DecodeInt(nSize))
	{
		return false;
	}
	packet.vItemList.Length = nSize;
	
	for(i = 0; i < packet.vItemList.Length; i++)
	{
		if(! DecodeInt(packet.vItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_C_ITEMS_TO_ENCHANT_LIST_MULTI(out _S_EX_C_ITEMS_TO_ENCHANT_LIST_MULTI packet)
{
	local int i, nSize;
	
	if(! DecodeInt(nSize))
	{
		return false;
	}
	packet.vItemList.Length = nSize;
	
	for(i = 0; i < packet.vItemList.Length; i++)
	{
		if(! DecodeInt(packet.vItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_C_ITEMS_TO_COMMISSION_LIST(out _S_EX_C_ITEMS_TO_COMMISSION_LIST packet)
{
	local int i, nSize;
	
	if(! DecodeInt(nSize))
	{
		return false;
	}
	packet.vItemList.Length = nSize;
	
	for(i = 0; i < packet.vItemList.Length; i++)
	{
		if(! DecodeInt(packet.vItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_C_PREDEFINED_CHANCES_ITEM_JEWEL(out _S_EX_C_PREDEFINED_CHANCES_ITEM_JEWEL packet)
{
	if(! DecodeInt(packet.nCurrent))
	{
		return false;
	}
	if(! DecodeInt(packet.nMax))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_C_PREDEFINED_CHANCES_ITEM_ENCHANT(out _S_EX_C_PREDEFINED_CHANCES_ITEM_ENCHANT packet)
{
	if(! DecodeInt(packet.nCurrent))
	{
		return false;
	}
	if(! DecodeInt(packet.nMax))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_C_ITEM_ENCHANT_LIMIT(out _S_EX_C_ITEM_ENCHANT_LIMIT packet)
{
	local int nItemCount, i;

	if(!DecodeInt(nItemCount))
	{
		return false;
	}
	packet.nItemEmchantLimit.Length = nItemCount;

	for(i = 0; i < nItemCount; i++)
	{
		if(!DecodeInt(packet.nItemEmchantLimit[i].nItemID))
		{
			return false;
		}
		if(!DecodeChar(packet.nItemEmchantLimit[i].cItemEnchantLevel))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_C_ITEM_JEWEL_ENCHANT_LIMIT(out _S_EX_C_ITEM_JEWEL_ENCHANT_LIMIT packet)
{
	local int nItemCount, i;

	if(!DecodeInt(nItemCount))
	{
		return false;
	}
	packet.nItemJewelEmchantLimit.Length = nItemCount;

	for(i = 0; i < nItemCount; i++)
	{
		if(!DecodeInt(packet.nItemJewelEmchantLimit[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_C_CUSTOM_COMBINATION_CHANCE(out _S_EX_C_CUSTOM_COMBINATION_CHANCE packet)
{
	if(!DecodeInt(packet.nChance))
	{
		return false;
	}
	return true;
}

static function RequestUICustomPacket (int a_UIProtocol, optional array<byte> a_stream)
{
	local int i;
	local array<byte> stream;
	
	if(! EncodeChar(stream, a_UIProtocol))
	{
		return;
	}
	
	for ( i = 0; i < a_stream.Length; i++ ) 
	{
		stream.Insert( stream.Length, 1 );
		stream[stream.Length - 1] = a_stream[i];
	}
	
	RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_SERVER_INFO, stream);
}

static function bool Encode_C_EX_C_REQ_ITEMS_TO_ENCHANT(out array<byte> stream, _C_EX_C_REQ_ITEMS_TO_ENCHANT packet)
{
	if(! EncodeBool(stream, packet.bMulti))
	{
		return false;
	}
	return true;	
}

static function bool Encode_C_EX_C_REQ_COLLECTION_FEE_LIST(out array<byte> stream, _C_EX_C_REQ_COLLECTION_FEE_LIST packet)
{
	if(! EncodeShort(stream, packet.nCollectionId))
	{
		return false;
	}
	return true;	
}

static function bool Encode_C_EX_C_REQ_COLLECTION_BUY(out array<byte> stream, _C_EX_C_REQ_COLLECTION_BUY packet)
{
	if(! EncodeShort(stream, packet.nCollectionId))
	{
		return false;
	}
	if(! EncodeInt(stream, packet.nItemId))
	{
		return false;
	}
	if(! EncodeInt64(stream, packet.nItemCount))
	{
		return false;
	}
	return true;	
}

static function bool Decode_S_EX_C_COLLECTION_FEE_LIST(out _S_EX_C_COLLECTION_FEE_LIST packet)
{
	local int i, nSize;
	
	if(! DecodeShort(packet.nCollectionId))
	{
		return false;
	}
	if(! DecodeInt(nSize))
	{
		return false;
	}
	packet.vFeeItemList.Length = nSize;
	
	for(i = 0; i < packet.vFeeItemList.Length; i++)
	{
		if(! Decode_ItemInfo(packet.vFeeItemList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_C_COSTUME_LIST(out _S_EX_C_COSTUME_LIST packet)
{
	local int i, nSize;
	
	if(! DecodeChar(packet.cCurrentPage))
	{
		return false;
	}
	if(! DecodeChar(packet.cMaxPage))
	{
		return false;
	}
	if(! DecodeInt(packet.nActiveCostumeId))
	{
		return false;
	}
	if(! DecodeChar(nSize))
	{
		return false;
	}
	packet.vCostumeList.Length = nSize;
	
	for(i = 0; i < packet.vCostumeList.Length; i++)
	{
		if(! Decode_Costume(packet.vCostumeList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_C_COSTUME_ACTIVATE(out _S_EX_C_COSTUME_ACTIVATE packet)
{
	if(! DecodeBool(packet.bActive))
	{
		return false;
	}
	return true;
}

static function bool Decode_S_EX_C_COSTUME_ACTION_RESULT(out _S_EX_C_COSTUME_ACTION_RESULT packet)
{
	if(! DecodeInt(packet.nCostumeId))
	{
		return false;
	}
	if(! DecodeChar(packet.cAction))
	{
		return false;
	}
	if(! DecodeChar(packet.cResult))
	{
		return false;
	}
	return true;
}

static function bool Decode_Costume(out _Costume packet)
{
	local int i, nSize;
	
	if(! DecodeInt(packet.nId))
	{
		return false;
	}
	if(! DecodeChar(packet.cGrade))
	{
		return false;
	}
	if(! DecodeInt(packet.nSkillId))
	{
		return false;
	}
	if(! DecodeShort(packet.nSkillLevel))
	{
		return false;
	}
	if(! DecodeShort(packet.nSkillSubLevel))
	{
		return false;
	}
	if(! DecodeInt(packet.nViewItemId))
	{
		return false;
	}
	if(! DecodeBool(packet.bPurchased))
	{
		return false;
	}
	if(! DecodeBool(packet.bAvailable))
	{
		return false;
	}
	if(! DecodeChar(packet.cFlags))
	{
		return false;
	}
	if(packet.bPurchased == 0)
	{
		if(! DecodeChar(nSize))
		{
			return false;
		}
		
		packet.vFeeItems.Length = nSize;

		for (i = 0; i < packet.vFeeItems.Length; i++)
		{
			if(! Decode_ItemInfo(packet.vFeeItems[i]))
			{
				return false;
			}
		}
	}
	return true;
}

static function bool Decode_S_EX_C_COLLECTION_PURCHASE_LIST(out _S_EX_C_COLLECTION_PURCHASE_LIST packet)
{
	local int i, nSize;
	
	if(! DecodeInt(nSize))
	{
		return false;
	}
	packet.vPurchaseList.Length = nSize;
	
	for(i = 0; i < packet.vPurchaseList.Length; i++)
	{
		if(! DecodeInt(packet.vPurchaseList[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Decode_S_EX_C_AUTO_RANDOM_CRAFT_INFO(out _S_EX_C_AUTO_RANDOM_CRAFT_INFO packet)
{
	local int i, nSize;
	
	if(! DecodeChar(packet.cCurrentPage))
	{
		return false;
	}
	if(! DecodeChar(packet.cMaxPage))
	{
		return false;
	}
	if(packet.cCurrentPage == 1)
	{
		if(! DecodeInt(nSize))
		{
			return false;
		}
		packet.vChargeItems.Length = nSize;
		
		for(i = 0; i < packet.vChargeItems.Length; i++)
		{
			if(! DecodeInt(packet.vChargeItems[i]))
			{
				return false;
			}
		}
	}
	if(! DecodeInt(nSize))
	{
		return false;
	}
	packet.vCraftItems.Length = nSize;
	
	for(i = 0; i < packet.vCraftItems.Length; i++)
	{
		if(! DecodeInt(packet.vCraftItems[i]))
		{
			return false;
		}
	}
	return true;
}

static function bool Encode_C_EX_C_REQ_COSTUME_LIST(out array<byte> stream, _C_EX_C_REQ_COSTUME_LIST packet)
{
	if(! EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_C_REQ_ITEMS_TO_COMMISSION(out array<byte> stream, _C_EX_C_REQ_ITEMS_TO_COMMISSION packet)
{
	if(! EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_C_REQ_COSTUME_ACTION(out array<byte> stream, _C_EX_C_REQ_COSTUME_ACTION packet)
{
	if(! EncodeInt(stream, packet.nCostumeId))
	{
		return false;
	}
	if(! EncodeChar(stream, packet.cAction))
	{
		return false;
	}
	if(! EncodeInt(stream, packet.nItemId))
	{
		return false;
	}
	if(! EncodeInt64(stream, packet.nItemCount))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_C_RECEIVE_ALL_ONE_DAY_REWARDS(out array<byte> stream, _C_EX_C_RECEIVE_ALL_ONE_DAY_REWARDS packet)
{
	if(! EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_C_ITEM_ENCHANT_LIMIT(out array<byte> stream, _C_EX_C_ITEM_ENCHANT_LIMIT packet)
{
	if(! EncodeInt(stream, packet.nScrollId))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_C_REQ_CC_RESET(out array<byte> stream, _C_EX_C_REQ_CC_RESET packet)
{
	if(! EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_C_REQ_AUTO_RANDOM_CRAFT_INFO(out array<byte> stream, _C_EX_C_REQ_AUTO_RANDOM_CRAFT_INFO packet)
{
	if(! EncodeChar(stream, packet.cDummy))
	{
		return false;
	}
	return true;
}

static function bool Encode_C_EX_C_TARGET_ACTION(out array<byte> stream, _C_EX_C_TARGET_ACTION packet)
{
	if(! EncodeInt(stream, packet.nObjectId))
	{
		return false;
	}
	if(! EncodeChar(stream, packet.cAction))
	{
		return false;
	}
	return true;
}