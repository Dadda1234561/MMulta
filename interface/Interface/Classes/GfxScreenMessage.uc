//------------------------------------------------------------------------------------------------------------------------
//
// 제목        : gfxDialog  ( 스케일 폼용 다이얼로그 (커스텀 등) ) - SCALEFORM UI - 
//
// linkage 다이얼로그 목록 :
// 4차 전직 - 각성 게시 다이얼로그 : Gfx 스크린 메시지   
//------------------------------------------------------------------------------------------------------------------------

//----- 아이템 인챈트 테스트 -----
//  11040 파워툴 
//  UserName=aa EnchantCount=7 ItemClassID=35241 ItemName=고등어 AdditionalItemName=멍멍이개밥
//  빌드 명령어
//  ///itemannounce 35201
class GfxScreenMessage extends L2UIGFxScript;

event OnRegisterEvent()
{
	RegisterGFxEvent(EV_GFxScrMessage);
	RegisterGFxEvent(EV_GFX_ItemAnnounce);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_RAID_DROP_ITEM_ANNOUNCE);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_SERVERLIMIT_ITEM_ANNOUNCE);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_COLLECTION_RESET);
	RegisterEvent(EV_CollectionReset);
	RegisterGFxEvent(EV_Restart);
	RegisterEvent(EV_Test_4);
}

event OnLoad()
{
	RegisterState(getCurrentWindowName(string(self)), "GAMINGSTATE");
	RegisterState(getCurrentWindowName(string(self)), "COLLECTIONSTATE");
	RegisterState(getCurrentWindowName(string(self)), "ARENAPICKSTATE");
	RegisterState(getCurrentWindowName(string(self)), "ARENAGAMINGSTATE");
	RegisterState(getCurrentWindowName(string(self)), "ARENABATTLESTATE");
	RegisterState(getCurrentWindowName(string(self)), "OLYMPIADOBSERVERSTATE");
	SetDefaultShow(true);
	SetHavingFocus(false);
}

event OnFlashLoaded()
{
	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0 , 0);	

	//항상 상위에 그리도록 함.
	SetRenderOnTop(true);
	SetAlwaysFullAlpha(true);
	IgnoreUIEvent(true);
}

event OnEvent(int Id, string param)
{
	switch(Id)
	{
		// End:0x28
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_RAID_DROP_ITEM_ANNOUNCE:
			HandleRaidDropItem();
			// End:0x4C
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_SERVERLIMIT_ITEM_ANNOUNCE:
			HandleShopCraftLimitServerAnnounce();
			// End:0x4C
			break;
		case EV_CollectionReset:
			Handle_CollectionReset(param);
			// End:0x72
			break;
		// End:0x6F
		case EV_Test_4:
			Handle_CollectionResetTest(param);
	}
}

event OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		// End:0x32
		case "ShowFixedRearItemMessage":
			OnShowFixedRearItemMessage(param);
			break;
		case "ShowSpecialCraftMessage":
			ShowSpecialCraftMessage(param);
			break;
	}
}

function OnShowFixedRearItemMessage(string param)
{
	local string UserName, fromItemName, msgStr;
	local int systemMsgId, ItemClassID;

	ParseString(param, "UserName", UserName);
	ParseString(param, "FromItemName", fromItemName);
	ParseInt(param, "ItemClassId", ItemClassID);
	// End:0x89
	if(UserName != "")
	{
		systemMsgId = 13662;		
	}
	else
	{
		UserName = GetSystemString(13198);
		systemMsgId = 13664;
	}
	msgStr = MakeFullSystemMsg(GetSystemMessage(SystemMsgID), UserName, fromItemName);
	class'OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText(1.0f, 1999.0f, "LineageEffect2.ui_screen_message_flow", 0, 0, 0, -10, 0, 3000, 500, msgStr, L2Util(GetScript("L2Util")).White, GetItemInfoByClassID(ItemClassID),, true);
}

function ShowSpecialCraftMessage(string param)
{
	local string UserName, msgStr;
	local int SystemMsgID, ItemClassID;

	ParseString(param, "UserName", UserName);
	ParseInt(param, "ItemClassId", ItemClassID);
	// End:0x51
	if(UserName != "")
	{
		SystemMsgID = 13176;		
	}
	else
	{
		UserName = GetSystemString(13198);
		SystemMsgID = 13178;
	}
	msgStr = MakeFullSystemMsg(GetSystemMessage(SystemMsgID), UserName);
	class'OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText(1.0f, 1999.0f, "LineageEffect2.ui_screen_message_flow", 0, 0, 0, -10, 0, 3000, 500, msgStr, L2Util(GetScript("L2Util")).White, GetItemInfoByClassID(ItemClassID),, true);	
}

function HandleShopCraftLimitServerAnnounce()
{
	local string param;
	local UIPacket._S_EX_SERVERLIMIT_ITEM_ANNOUNCE packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_SERVERLIMIT_ITEM_ANNOUNCE(packet))
	{
		return;
	}
	param = "";
	ParamAdd(param, "Type", "6");
	ParamAdd(param, "UserName", packet.sUserName);
	ParamAdd(param, "ItemClassID", string(packet.nItemClassID));
	ParamAdd(param, "GetAmount", string(packet.nGetAmount));
	ParamAdd(param, "RemainAmount", string(packet.nRemainAmount));
	ParamAdd(param, "MaxAmount", string(packet.nMaxAmount));
	CallGFxFunction("GfxScreenMessage", "S_EX_SERVERLIMIT_ITEM_ANNOUNCE", param);
	AddSystemSERVERLIMITMessage(packet.sUserName, packet.nItemClassID, packet.nGetAmount, string(packet.nRemainAmount) $ "/" $ string(packet.nMaxAmount));
}

function AddSystemSERVERLIMITMessage(string sUserName, int ItemClassID, int getAmount, string amountString)
{
	local int msgInt;
	local string UserName, ItemName;

	// End:0x25
	if(sUserName != "")
	{
		msgInt = 13440;
		UserName = sUserName;		
	}
	else
	{
		msgInt = 13442;
		UserName = GetSystemString(13198);
	}
	ItemName = class'UIDATA_ITEM'.static.GetItemName(class'UICommonAPI'.static.GetItemID(ItemClassID));
	AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(msgInt), UserName, (ItemName $ " x") $ string(getAmount), amountString));
}

function HandleRaidDropItem()
{
	local UIPacket._S_EX_RAID_DROP_ITEM_ANNOUNCE packet;
	local string nickname, Name, Message, param;
	local int i;
	local string nameTotal;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_RAID_DROP_ITEM_ANNOUNCE(packet))
	{
		return;
	}

	// End:0x2E
	if(packet.dropItemClassIds.Length == 0)
	{
		return;
	}
	nickname = class'UIDATA_NPC'.static.GetNPCNickName(packet.nNPCClassID - 1000000);
	Name = class'UIDATA_NPC'.static.GetNPCName(packet.nNPCClassID - 1000000);
	// End:0x94
	if(nickname == "")
	{
		nameTotal = Name;
	}
	else
	{
		nameTotal = nickname @ "-" @ Name;
	}
	AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(13072), ConvertWorldIDToStr(packet.sLastAttackerName), nameTotal, GetDropItemNames(packet.dropItemClassIds)));
	Name = getInstanceL2Util().gfxHtmlAddText(Name, "#FFFFFF", "20");
	Message = MakeFullSystemMsg(GetSystemMessage(13073), ConvertWorldIDToStr(packet.sLastAttackerName), Name);
	Message = getInstanceL2Util().gfxHtmlAddText(Message, "#A09682", "20");
	param = "";
	ParamAdd(param, "Msg", Message);
	ParamAdd(param, "itemCount", string(packet.dropItemClassIds.Length));

	// End:0x1F8 [Loop If]
	for (i = 0; i < packet.dropItemClassIds.Length;i++ )
	{
		ParamAdd(param, "classID" $ string(i), string(packet.dropItemClassIds[i]));
	}

	ParamAdd(param, "type", "6");
	CallGFxFunction("GfxScreenMessage", "showMessage", param);
}

function Handle_CollectionResetTest(string param)
{
	local int Id;

	ParseInt(param, "id", Id);
	DisplayCollectionReset(Id);	
}

function DisplayCollectionReset(int collectionid)
{
	local CollectionData cData;
	local CollectionSystem collectionSystemScr;
	local string effectDesc;

	collectionSystemScr = CollectionSystem(GetScript("CollectionSystem"));
	// End:0x43
	if(! collectionSystemScr.API_GetCollectionData(collectionid, cData))
	{
		return;
	}
	effectDesc = CollectionSystemSub(GetScript("CollectionSystem.CollectionSystemSub")).GetOptionByOptionID(cData.option_id);
	// End:0x9C
	if(effectDesc == "")
	{
		return;
	}
	AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(13416), cData.collection_name, effectDesc));
	getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13691), cData.collection_name, effectDesc));	
}

function Handle_CollectionReset(string param)
{
	local int nCollectionID;

	ParseInt(param, "CollectionID", nCollectionID);
	DisplayCollectionReset(nCollectionID);	
}

function string GetDropItemNames(array<int> dropItemClassIds)
{
	local int i;
	local string ItemName, itenNameStrings;
	local ItemID Id;

	itenNameStrings = "";

	for (i = 0; i < dropItemClassIds.Length; i++)
	{
		Id.ClassID = dropItemClassIds[i];
		ItemName = class'UIDATA_ITEM'.static.GetItemName(Id);
		// End:0x6C
		if(itenNameStrings != "")
		{
			itenNameStrings = itenNameStrings $ ", ";
		}
		itenNameStrings = itenNameStrings $ ItemName;
	}
	return itenNameStrings;
}

static function ItemInfo GetItemInfoByClassID(int Id)
{
	local ItemID cID;
	local ItemInfo Info;

	cID.ClassID = Id;
	class'UIDATA_ITEM'.static.GetItemInfo(cID, Info);
	return Info;
}

function showGfxScreenMessage(string Type, string Msg, string IconName, optional string TextColor)
{
	local string strParam;

	strParam = "";
	ParamAdd(strParam, "type", Type);
	ParamAdd(strParam, "Msg", Msg);
	ParamAdd(strParam, "iconName", IconName);
	// End:0x74
	if(TextColor != "")
	{
		ParamAdd(strParam, "textColor", TextColor);
	}
	CallGFxFunction("GfxScreenMessage", "showMessage", strParam);
}

/*
 *  Gfx 스크린 메시지 
 *
 */
function showTestGfxScreenMessage(string Label, optional string labelIndex, optional string motionType, optional string Delay, optional string locY) 
{
	local string strParam;

	strParam = "";
	ParamAdd(strParam, "Msg", "1");
	ParamAdd(strParam, "type", string(getInstanceL2Util().EGfxScreenMsgType.MSGType_Matching));
	ParamAdd(strParam, "label", Label);
	ParamAdd(strParam, "labelIndex", labelIndex);
	ParamAdd(strParam, "motionType", motionType);
	ParamAdd(strParam, "delay", Delay);
	ParamAdd(strParam, "locY", locY);
	CallGFxFunction("GfxScreenMessage", "showMessage", strParam);
}

defaultproperties
{
}
