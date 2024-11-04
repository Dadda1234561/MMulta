class Tooltip extends UICommonAPI;

const TOOLTIP_MINIMUM_WIDTH = 154;
const TOOLTIP_MINIMUM_SETITEM_WIDTH = 200;

const TOOLTIP_SETITEM_MAX = 3;
const BIGSIZE_ICON_ADD = 16;
const TOOLTIP_LINE_HGAP = 6;

const ATTRIBUTE_FIRE = 0;
const ATTRIBUTE_WATER = 1;
const ATTRIBUTE_WIND = 2;
const ATTRIBUTE_EARTH = 3;
const ATTRIBUTE_HOLY = 4;
const ATTRIBUTE_UNHOLY = 5;

var int MACROCOMMAND_MAX_COUNT;
var CustomTooltip m_Tooltip;
var DrawItemInfo m_Info;

var array<int> AttackAttLevel;
var array<int> AttackAttCurrValue;
var array<int> AttackAttMaxValue;
var array<int> DefAttLevel;
var array<int> DefAttCurrValue;
var array<int> DefAttMaxValue;

var int NowAttrLv;
var int NowMaxValue;
var int NowValue;

var bool BoolSelect;

//?Ññ–∂?ï–æ¬±—? ?Ññ–ß ?ë–ë–ï–? 6¬∞?? ?ò–£—ò—î—ó–? ?ë–ª–ó–? ?ï—à–ñ–? ¬∞?é¬∑–û—ò¬? ?ó–°¬∞—ñ¬∑–? ?ë—ë¬µ–π¬±–? ?ê¬ß–ó–? ?î–á—ò—?
var bool bLine;

var TextBoxHandle ItemCountText;

function OnRegisterEvent()
{
	RegisterEvent(EV_RequestTooltipInfo);
}

function OnLoad()
{
	// ?ò—Ñ–î–? ?ï—à–ñ–? ?î–°¬±–?/?Ü—Ñ¬±–? ¬±–≤?î¬ª¬∞–Ñ–ê¬? ?î–°¬±–≤¬∑–?(TTP#41925) 2010.8.23 - winkey
	BoolSelect = true;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x1D
		case EV_RequestTooltipInfo:
			//debug("?ï—à–ñ–ë–ê–ú—î“ê–ñ¬? ?ñ–°—ï–æ—ó–ê—ñ–?");
			HandleRequestTooltipInfo(param);
			// End:0x20
			break;
	}
}

function setBoolSelect(bool B)
{
	BoolSelect = B;
}

function HandleRequestTooltipInfo(string param)
{
	local string TooltipType;
	local int SourceType;
	local ETooltipSourceType eSourceType;

	ClearTooltip();
	// End:0x2A
	if(! ParseString(param, "TooltipType", TooltipType))
	{
		return;
	}
	// End:0x4D
	if(! ParseInt(param, "SourceType", SourceType))
	{
		return;
	}
	eSourceType = ETooltipSourceType(SourceType);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////// Normal Tooltip /////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	//debug("Tooltip?ï—ë–ê–?:"$TooltipType);
	// End:0x7E
	if(TooltipType == "Text")
	{
		ReturnTooltip_NTT_TEXT(param, eSourceType, false);
	}
	else if(TooltipType == "Description")
	{
		ReturnTooltip_NTT_TEXT(param, eSourceType, true);
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////// ItemWnd Tooltip ////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	else if(TooltipType == "Action")
	{
		ReturnTooltip_NTT_ACTION(param, eSourceType);
	}
	else if(TooltipType == "Macro")
	{
		ReturnTooltip_NTT_MACRO(param, eSourceType);
	}
	else if(TooltipType == "Skill")
	{
		ReturnTooltip_NTT_SKILL(param, eSourceType);
	}
	else if(TooltipType == "NormalItem")
	{
		ReturnTooltip_NTT_NORMALITEM(param, eSourceType);
	}
	else if(TooltipType == "PremiumNormalItem") //branch121212
	{
		ReturnTooltip_NTT_PREMIUMNORMALITEM(param, eSourceType);
	}
	else if(TooltipType == "Shortcut")
	{
		ReturnTooltip_NTT_SHORTCUT(param, eSourceType);
	}
	else if(TooltipType == "AbnormalStatus")
	{
		ReturnTooltip_NTT_ABNORMALSTATUS(param, eSourceType);
	}
	else if(TooltipType == "RecipeManufacture")
	{
		ReturnTooltip_NTT_RECIPE_MANUFACTURE(param, eSourceType);
	}
	else if(TooltipType == "Recipe")
	{
		ReturnTooltip_NTT_RECIPE(param, eSourceType, false);
	}
	else if(TooltipType == "RecipePrice")
	{
		ReturnTooltip_NTT_RECIPE(param, eSourceType, true);
	}
	else if(TooltipType == "Inventory"
			|| TooltipType == "InventoryPrice1"
			|| TooltipType == "InventoryPrice2"
			|| TooltipType == "InventoryPrice1HideEnchant"
			|| TooltipType == "InventoryPrice1HideEnchantStackable"
			|| TooltipType == "InventoryPrice2PrivateShop"
			|| TooltipType == "InventoryWithIcon"
			|| TooltipType == "InventoryPawnViewer" // PawnViewer?ó–? ?ì–?¬∞?? - lancelot 2007. 10. 16.
			|| TooltipType == "HtmlViewer" // Html ?ï—à–ñ–ë—ó–? ?ì–?¬∞?? - y2jinc 2011. 11. 16.
			|| TooltipType == "InventoryPet"// ?ñ–? ?ó–? ?ï—à–ñ–? ?ì–?¬∞?? (?ò–£—ò—? ¬∞?Ñ–ê–? ?î—ë–ê–ú–ë—? ?ï–ö¬µ¬µ¬∑–? ?ì—ñ—ë¬?)			
			|| TooltipType == "EnsoulSlot" // ?Ö–ï¬±–? ?ë—ç–ò“? ?Ö–Ö¬∑–?. ?ï—à–ñ–ë–ê¬? ?Ññ¬´?Ö–? ?ó–ü“ë–? ?ò–£—ò—î–ê¬? ?ì–?¬∞?é–ó–ü¬±–? ?ê¬ß–ó–®—ò¬?.. - ?ë¬∂–ò—Å—ó¬? ¬∂¬ß?Ññ¬Æ

			)
	{
		ReturnTooltip_NTT_ITEM(param, TooltipType, eSourceType);
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////// ListCtrl Tooltip ///////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	//?ò¬±–ë–? ?ò—Ü–ë¬?(2010.02.22 ~ 03.08) ?ó–ü¬∑–?
	else if(TooltipType == "RoomList")
	{
		ReturnTooltip_NTT_ROOMLIST(param, eSourceType);
	}
	else if(TooltipType == "UserList")
	{
		ReturnTooltip_NTT_USERLIST(param, eSourceType);
	}
	else if(TooltipType == "PartyMatch")
	{
		ReturnTooltip_NTT_PARTYMATCH(param, eSourceType);
	}
	else if(TooltipType == "UnionList")
	{
		ReturnTooltip_NTT_UNIONLIST(param, eSourceType);
	}
	else if(TooltipType == "QuestInfo")
	{
		ReturnTooltip_NTT_QUESTINFO(param, eSourceType);
	}
	else if(TooltipType == "QuestList")
	{
		ReturnTooltip_NTT_QUESTLIST(param, eSourceType);
	}
	else if(TooltipType == "QuestRecommandMapList")
	{
		if(IsAdenServer())
		{
			ReturnTooltip_NTT_QUESTRECOMMAND_MAPLISTClassic(param, eSourceType);																						
		}
		else
		{
			ReturnTooltip_NTT_QUESTRECOMMAND_MAPLIST(param, eSourceType);
		}
	}
	else if(TooltipType == "RaidList")
	{
		ReturnTooltip_NTT_RAIDLIST(param, eSourceType);
	}
	else if(TooltipType == "ClanInfo")
	{
		ReturnTooltip_NTT_CLANINFO(param, eSourceType);
	}
	else if(TooltipType == "FriendInfo")
	{
		// ?ê–û—ë–ñ¬∞—å—ë¬? ?ó–é—ò¬? friendList  BlockList 
		ReturnTooltip_NTT_FRIENDINFO(param, eSourceType);
	}
	// 10.09.20 ?ó—á—ë–ù–ê—? ?ë¬??Ö—î–ñ¬? ?ï—à–ñ–? ?ì–?¬∞?? by Dongland		
	else if(TooltipType == "ClanWarInfo")
	{
		ReturnTooltip_NTT_CLANWARINFO(param, eSourceType);
	}
	else if(TooltipType == "EllipsedList")
	{
		ReturnTooltip_NTT_EllipsedList(param, eSourceType);
	}
	else if(TooltipType == "SellItemList")
	{
		// ?ñ–ó—ë–? ?ë–ª–ó–? 
		ReturnTooltip_NTT_SellItemList(param, eSourceType);
	}
	else if(TooltipType == "UIControlNeedItemList")
	{
		ReturnTooltip_NTT_UIControlNeedItemList(param, eSourceType);
	}
	else if(TooltipType == "EnsoulOptionType")
	{
		// ?ë—ç–ò“? ?ó–ô—ò–? - 2015-03-02 ?ì–?¬∞??
		ReturnTooltip_NTT_EnsoulOptionList(param, eSourceType);
	}
	else if(TooltipType == "AgitDecoListType")
	{
		// ?ï–ñ–ë—Ü–ñ¬? ¬µ?ê–î–? ?ë¬??Ö—î–ñ¬? (2015-08-04 ?ì–?¬∞??)
		ReturnTooltip_NTT_AgitDecoList(param, eSourceType);
	}
	//?ò¬±–ë–? ?ò—Ü–ë¬?(10.03.30) ?ó–ü¬∑–?
	//?ó–º–ñ–Ω–ó–§—ó–? ?ï—à–ñ–? ?ì–?¬∞??.
	else if(TooltipType == "PostInfo")
	{
		ReturnTooltip_NTT_POSTINFO(param, eSourceType);
	}
	/////////////////////////////////////////////////////
	// MANOR
	else if(TooltipType == "ManorSeedInfo"
			|| TooltipType == "ManorCropInfo"
			|| TooltipType == "ManorSeedSetting"
			|| TooltipType == "ManorCropSetting"
			|| TooltipType == "ManorDefaultInfo"
			|| TooltipType == "ManorCropSell")
	{
		ReturnTooltip_NTT_MANOR(param, TooltipType, eSourceType);
	}
	// [?î—â–Ö—î–ñ¬? ?ï–ñ–ê–ú–ï–? ?ï—à–ñ–? ?ì–?¬∞??]
	else if(TooltipType == "QuestItem")
	{
		ReturnTooltip_NTT_QUESTREWARDS(param, eSourceType);
	}
	else if(TooltipType == "GFxCardItem")
	{
		ReturnTooltip_NTT_GFXCARD(param, eSourceType);
	}
	//?ì¬§–ñ–? ¬ª–∑¬±–≤?Ññ–∂?ë—? ?ï—à–ñ–? ?ì–?¬∞??
	else if(TooltipType == "UserFakeInfo")
	{
		ReturnTooltip_NTT_CHAT_USERFAKEINFO(param, eSourceType);
	}
	else if(TooltipType == "LookChangeItem")
	{
		ReturnTooltip_NTT_LOOCKCHANGEITEM(param);
	}
	else if(TooltipType == "InventoryStackableUnitPrice")
	{
		//¬∞?ñ–ê–? ¬ª?É–ë–? ?ï—à–ñ–ë¬∞—? ¬∞¬∞¬∞–§ ?î—ë–ê–ú¬µ¬µ¬∑–? eSourceType?ê¬? ?ï–ñ–ê–ú–ï–? ?ï—ë–ê–§–ê—ë¬∑–? ?Ññ–©?Ü–? ?î—ë—ñ¬ª–ë–? ¬∞??.
		ReturnTooltip_NTT_ITEM(param, TooltipType, NTST_ITEM);
	}
	// ?ó—â¬µ–µ—ë–? ?ï—à–ñ–?
	else if(TooltipType == "RegionInfo")
	{
		ReturnTooltip_NTT_MAP_REGIONINFO(param, eSourceType);
	}
	else if(TooltipType == "GfxCustomTooltip")
	{
		//Gfx?ó–é—ò¬? ?î—ë—ñ¬ª“ë–? ?î—ó–Ö—î–ï–? ?ï—à–ñ–? 
		ReturnTooltip_NTT_GFxTooltip(param);
	}
	else if(TooltipType == "privateShopHistory")
	{
		ReturnTooltip_NTT_PrivateShopHistory(param);
	}
	else if(TooltipType == "DevToolDebug")
	{
		ReturnTooltip_DevToolDebug(param);
	}
	else if(TooltipType == "CursedWeapon")
	{
		Debug("CursedWeapon :" @ param);
		ReturnTooltip_CursedWeapon(param);
	}
	else if(TooltipType == "PrivateShopFind")
	{
		ReturnTooltip_PrivateShopFind(param, eSourceType);
	}
	else if(TooltipType == "WorldExchangeBuyWnd")
	{
		ReturnTooltip_WorldExchangeHistory(param, eSourceType);
	}
	else if(TooltipType == "RankingReward")
	{
		ReturnTooltip_RankingReward_Character(param, eSourceType);
	}
	else if(TooltipType == "SuppressRichList")
	{
		ReturnTooltip_SuppressRichList(param, eSourceType);
	}
	else if(TooltipType == "RankingPet")
	{
		ReturnTooltip_RankingPet(param, eSourceType);
	}
	else if(TooltipType == "RankingPvp")
	{
		ReturnTooltip_RankingPvp(param, eSourceType);
	}
	else if(TooltipType == "RankingCombatPower")
	{
		ReturnToolTip_RankingCombatPower(param, eSourceType);
	}
	else if(TooltipType == "RankingOlympiad")
	{
		ReturnTooltip_RankingOlympiad(param, eSourceType);
	}
	else if(TooltipType == "SimpleRichListTooltip")
	{
		ReturnTooltip_SimpleRichListTooltip(param, eSourceType);
	}
	else if(TooltipType == "DethroneMissionTooltip")
	{
		ReturnTooltip_DethroneMissionTooltip(param, eSourceType);
	}
	else if(TooltipType == "Revenge")
	{
		ReturnTooltip_Revenge(param, eSourceType);
	}
	else if(TooltipType == "RevengeHelp")
	{
		ReturnTooltip_RevengeHelp(param, eSourceType);
	}
	else if(TooltipType == "ShopLcoinCraftTooltip")
	{
		ReturnTooltip_ShopLcoinCraftTooltip(param, eSourceType);
	}
	else if(TooltipType == "CollectionSystemListTooltip")
	{
		ReturnTooltip_CollectionSystemListTooltip(param, eSourceType);
	}
	else if(TooltipType == "CollectionSystemOptionListTooltip")
	{
		ReturnTooltip_CollectionSystemOptionListTooltip(param, eSourceType);
	}
	else if(TooltipType == "L2PassAdvanceListTooltip")
	{
		ReturnTooltip_L2PassAdvanceListTooltip(param, eSourceType);
	}
	else if(TooltipType == "FightInfo")
	{
		ReturnTooltip_FightInfo(param, eSourceType);
	}
	else if(TooltipType == "TeleportWndListTooltip")
	{
		ReturnTooltip_TeleportWndListTooltip(param, eSourceType);
	}
	else if(TooltipType == "SkillLearnCostListTooltip")
	{
		ReturnTooltip_SkillLearnCostListTooltip(param, eSourceType);
	}
}

function ReturnTooltip_L2PassAdvanceListTooltip(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local bool isTitleRecord;
	local int ItemID;
	local ItemInfo advanceItemInfo;
	local string itemParam, textParam;

	ParamToRecord(param, Record);
	// End:0x2B
	if(Record.nReserved1 == 0)
	{
		isTitleRecord = true;
	}
	// End:0x63
	if(isTitleRecord == true)
	{
		ParamAdd(textParam, "text", Record.szReserved);
		ReturnTooltip_NTT_TEXT(textParam, NTST_TEXT, false);		
	}
	else
	{
		ItemID = int(Record.nReserved2);
		advanceItemInfo = GetItemInfoByClassID(ItemID);
		ItemInfoToParam(advanceItemInfo, itemParam);
		ReturnTooltip_NTT_ITEM(itemParam, "inventory", NTST_LIST);
	}
	ReturnTooltipInfo(m_Tooltip);
}

function ReturnTooltip_FightInfo(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = 220;
	// End:0x6C
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		// End:0x6C
		if(Record.szReserved != "")
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.szReserved, getInstanceL2Util().White, "", true, true));
		}
	}
	ReturnTooltipInfo(m_Tooltip);
}

function ReturnTooltip_TeleportWndListTooltip(string param, ETooltipSourceType eSourceType)
{
	local int isFavorites;

	// End:0x98
	if(eSourceType == NTST_LIST_DRAWITEM/*3*/)
	{
		ParseInt(param, "ReservedID", isFavorites);
		// End:0x69
		if(isFavorites == 0)
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13306), getInstanceL2Util().Blue, "", true, true));			
		}
		else
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13307), getInstanceL2Util().Red, "", true, true));
		}
	}
	ReturnTooltipInfo(m_Tooltip);	
}

function ReturnTooltip_SkillLearnCostListTooltip(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local int ConsumePriorityItemID, ConsumeItemID, SystemMsgID;
	local ItemInfo tmpItemInfo;

	ParamToRecord(param, Record);
	ParseInt(param, "nReserved1", ConsumePriorityItemID);
	ParseInt(param, "nReserved2", ConsumeItemID);
	ParseInt(param, "nReserved3", SystemMsgID);
	// End:0x220
	if(ConsumePriorityItemID > 0)
	{
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_NewTex.SkillWnd.Icon_Substitution", false, false, 0, 0, 16, 16, 20, 20));
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14395) $ ":", getInstanceL2Util().White, "", false, true));
		class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(ConsumePriorityItemID), tmpItemInfo);
		addToolTipDrawList(m_Tooltip, addDrawItemText(tmpItemInfo.Name, getInstanceL2Util().Gold, "", true, true));
		// End:0x16C
		if(Len(tmpItemInfo.AdditionalName) > 0)
		{
			AddTooltipColorText(tmpItemInfo.AdditionalName, GetColor(255, 217, 105, 255), false, true, true, "", 4);
		}
		AddTooltipColorText("(" $ GetSystemString(14401) $ ")", GetColor(255, 101, 101, 255), false, true, true, "", 4);
		class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(ConsumeItemID), tmpItemInfo);
		addToolTipDrawList(m_Tooltip, addDrawItemText(tmpItemInfo.Name, getInstanceL2Util().Gold, "", true, true));
		// End:0x220
		if(Len(tmpItemInfo.AdditionalName) > 0)
		{
			AddTooltipColorText(tmpItemInfo.AdditionalName, GetColor(255, 217, 105, 255), false, true, true, "", 4);
		}
	}
	// End:0x327
	if(ConsumeItemID > 0)
	{
		// End:0x23C
		if(ConsumePriorityItemID > 0)
		{
			AddCrossLine();
		}
		// End:0x2B6
		if(SystemMsgID > 0)
		{
			addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_NewTex.SkillWnd.Icon_Help", false, false, 0, 0, 16, 16, 20, 20));
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemMessage(SystemMsgID), getInstanceL2Util().White, "", false, true));			
		}
		else
		{
			addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_NewTex.SkillWnd.Icon_Magnifier", false, false, 0, 0, 16, 16, 20, 20));
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14394), getInstanceL2Util().White, "", false, true));
		}
	}
	ReturnTooltipInfo(m_Tooltip);	
}

function ReturnTooltip_CollectionSystemOptionListTooltip(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local int Period, collectionid;
	local CollectionInfo cInfo;
	local string remainTimeString;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
	// End:0x152
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		Period = int(Record.nReserved2);
		// End:0x4C
		if(Period == 0)
		{
			return;
		}
		collectionid = int(Record.nReserved1);
		// End:0x96
		if(! CollectionSystem(GetScript("CollectionSystem")).API_GetCollectionInfo(collectionid, cInfo))
		{
			return;
		}
		addTooltipTexture("L2UI_ct1.DailyMissionWnd.DailyMissionWnd_IconTime", 11, 11, 11, 11, true, false);
		remainTimeString = CollectionSystemPopupDetails(GetScript("CollectionSystem.CollectionSystemPopupDetails")).GetRemainTimeString(Period, cInfo.RemainTime);
		AddTooltipColorText(remainTimeString, getInstanceL2Util().Yellow, false, true, false);		
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

function ReturnTooltip_CollectionSystemListTooltip(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local CollectionData cdata;
	local CollectionInfo cInfo;
	local int collectionid;
	local string remainTimeString;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
	// End:0x272
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		collectionid = int(Record.nReserved1);
		// End:0x56
		if(! GetCollectionData(collectionid, cdata))
		{
			return;
		}
		AddTooltipText(cdata.collection_name, true, true);
		// End:0xDD
		if(cdata.endDateTime != "")
		{
			AddTooltipColorText(CollectionSystemPopupDetails(GetScript("CollectionSystem.CollectionSystemPopupDetails")).GetEndDateTime(cdata.endDateTime), GetColor(255, 221, 102, 255), true, true);
		}
		AddTooltipColorText(CollectionSystemSub(GetScript("CollectionSystem.CollectionSystemSub")).GetOptionByOptionID(cdata.option_id), getInstanceL2Util().ColorGold, true, true);
		// End:0x26F
		if(cdata.Period > 0)
		{
			addTooltipTexture("L2UI_ct1.DailyMissionWnd.DailyMissionWnd_IconTime", 11, 11, 11, 11, true, true);
			// End:0x1C4
			if(! CollectionSystem(GetScript("CollectionSystem")).API_GetCollectionInfo(collectionid, cInfo))
			{
				return;
			}
			remainTimeString = CollectionSystemPopupDetails(GetScript("CollectionSystem.CollectionSystemPopupDetails")).GetRemainTimeString(cdata.Period, cInfo.RemainTime);
			// End:0x252
			if(cInfo.RemainTime > 0)
			{
				AddTooltipColorText(remainTimeString, getInstanceL2Util().Yellow, false, true, false);				
			}
			else
			{
				AddTooltipColorText(remainTimeString, getInstanceL2Util().Gray, false, true, false);
			}
		}		
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

function ReturnTooltip_ShopLcoinCraftTooltip(string param, ETooltipSourceType eSourceType)
{
	local int ItemCount, countCost, i;
	local INT64 ItemAmount, CostItemAmount;
	local ItemID tmpItemID;
	local int itemEnchant, costItemEnchant;
	local ItemInfo peeItemInfo, tmpItemInfo;
	local string autoUsePanel;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
	// End:0x20
	if(eSourceType == NTST_LIST_DRAWITEM)
	{		
	}
	else if(eSourceType == NTST_LIST)
	{
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13278), getInstanceL2Util().Yellow, "", true, true));
		AddTooltipItemBlank(4);
		ParseInt(param, "itemCount", ItemCount);

		// End:0x1D2 [Loop If]
		for(i = 0; i < ItemCount; i++)
		{
			ParseInt(param, "itemCount" $ string(i), ItemCount);
			ParseInt(param, "buyItem" $ string(i), tmpItemID.ClassID);
			ParseInt(param, "buyItemEnchant" $ string(i), itemEnchant);
			class'UIDATA_ITEM'.static.GetItemInfo(tmpItemID, tmpItemInfo);
			tmpItemInfo.Enchanted = itemEnchant;
			addItemIcon(tmpItemInfo, "");
			AddItemEnchantedImg(itemEnchant);
			AddTooltipColorText(tmpItemInfo.Name, getInstanceL2Util().Gold, true, true, true, "", 36, -31);
			// End:0x1B4
			if(Len(tmpItemInfo.AdditionalName) > 0)
			{
				AddTooltipColorText(tmpItemInfo.AdditionalName, GetColor(255, 217, 105, 255), false, true, true, "", 6, -31);
			}
			ParseINT64(param, "buyItemCount" $ i, ItemAmount);
			addToolTipDrawList(m_Tooltip, addDrawItemText("x" $ MakeCostStringINT64(ItemAmount), getInstanceL2Util().BWhite, "", true, true, 36, -16));
			AddTooltipItemBlank(4);
		}
		AddCrossLine();
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13184), getInstanceL2Util().Yellow, "", true, true));
		AddTooltipItemBlank(4);
		ParseInt(param, "countCost", countCost);

		// End:0x3E6 [Loop If]
		for(i = 0; i < countCost; i++)
		{
			ParseInt(param, "costItemID" $ string(i), tmpItemID.ClassID);
			// End:0x38F
			if(MSIT_VITAL_POINT == tmpItemID.ClassID)
			{
				addTexture("Icon.etc_sayha_point_01", 32, 32, 32, 32, 0, 0);
				AddTooltipColorText(GetSystemString(2492), getInstanceL2Util().BrightWhite, true, true, true, "", 36, -31);
				ParseINT64(param, "costItemAmout" $ string(i), CostItemAmount);
				addToolTipDrawList(m_Tooltip, addDrawItemText("x" $ MakeCostStringINT64(CostItemAmount), getInstanceL2Util().White, "", true, true, 36, -16));					
			}
            else
            {
				class'UIDATA_ITEM'.static.GetItemInfo(tmpItemID, peeItemInfo);
				ParseInt(param, "costItemEnchant" $ string(i), costItemEnchant);
				peeItemInfo.Enchanted = costItemEnchant;
				switch(class'UIDATA_ITEM'.static.GetAutomaticUseItemType(tmpItemID.ClassID))
				{
					// End:0x2FF
					case AUIT_ITEM:
						autoUsePanel = "Icon.autoskill_panel_01";
						// End:0x302
						break;
				}
				addItemIcon(peeItemInfo, peeItemInfo.ForeTexture, autoUsePanel);
				AddItemEnchantedImg(costItemEnchant);
				AddTooltipColorText(peeItemInfo.Name, getInstanceL2Util().BrightWhite, true, true, true, "", 36, -31);
				// End:0x4B3
				if(Len(peeItemInfo.AdditionalName) > 0)
				{
					AddTooltipColorText(peeItemInfo.AdditionalName, GetColor(255, 217, 105, 255), false, true, true, "", 6, -31);
				}
				ParseINT64(param, "costItemAmout" $ i, CostItemAmount);
				addToolTipDrawList(m_Tooltip, addDrawItemText("x" $ MakeCostStringINT64(CostItemAmount), getInstanceL2Util().White, "", true, true, 36, -16));
            }
            AddTooltipItemBlank(4);
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

function ReturnTooltip_Revenge(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
	// End:0x164
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[2].szData $ " ", GetColor(187, 170, 136, 255), "", false, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().BWhite, "", false, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(" (" $ Record.LVDataList[1].szData $ ")", getInstanceL2Util().ColorLightBrown, "", false, true));
		// End:0x128
		if(Record.LVDataList[5].szData == "2")
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(347), getInstanceL2Util().Yellow, "", true, true));
		}
		else
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(348), getInstanceL2Util().Gray, "", true, true));
		}
		ReturnTooltipInfo(m_Tooltip);
		return;
	}
}

function ReturnTooltip_RevengeHelp(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
	// End:0x2FF
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13505) $ " ", GetColor(187, 170, 136, 255), "", false, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(88) $ string(Record.LVDataList[1].nReserved1) $ " ", GetColor(187, 170, 136, 255), "", true, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().BWhite, "", false, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[1].szData, getInstanceL2Util().ColorLightBrown, "", true, true));
		// End:0x173
		if(Record.LVDataList[5].szData != "")
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[5].szData $ " " $ GetSystemString(314), getInstanceL2Util().BWhite, "", true, true));			
		}
		else
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(431) $ " ", GetColor(187, 170, 136, 255), "", true, true));
		}
		AddCrossLine();
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13506) $ " ", GetColor(187, 170, 136, 255), "", false, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(88) $ string(Record.LVDataList[2].nReserved1) $ " ", GetColor(187, 170, 136, 255), "", true, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[4].szData, getInstanceL2Util().BWhite, "", false, true));
		// End:0x2BF
		if(Record.LVDataList[6].szData != "")
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[6].szData $ " " $ GetSystemString(314), getInstanceL2Util().BWhite, "", true, true));			
		}
		else
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(431) $ " ", GetColor(187, 170, 136, 255), "", true, true));
		}
		ReturnTooltipInfo(m_Tooltip);
		return;
	}
}

function ReturnTooltip_SimpleRichListTooltip(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local string TooltipDesc;

	m_Tooltip.MinimumWidth = 50;
	// End:0x72
	if(eSourceType == NTST_LIST_DRAWITEM)
	{
		ParseString(param, "TooltipDesc", TooltipDesc);
		// End:0x6F
		if(TooltipDesc != "")
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(TooltipDesc, getInstanceL2Util().White, "", true, true));
		}
	}
	else if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		// End:0xD1
		if(Record.szReserved != "")
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.szReserved, getInstanceL2Util().White, "", true, true));
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

function ReturnTooltip_DethroneMissionTooltip(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local string TooltipDesc;
	local DethroneDailyMissionData missionData;

	if(eSourceType == ETooltipSourceType.NTST_LIST_DRAWITEM/*3*/)
	{
		m_Tooltip.MinimumWidth = 50;
		ParseString(param, "TooltipDesc", TooltipDesc);
		if(TooltipDesc != "")
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(TooltipDesc, getInstanceL2Util().White, "", true, true));
		}		
	}
	else if(eSourceType == ETooltipSourceType.NTST_LIST/*2*/)
	{
		m_Tooltip.MinimumWidth = 260;
		ParamToRecord(param, Record);
		GetDethroneDailyMissionData(int(Record.nReserved1), missionData);
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14314), GTColor().White, "", true, true));
		AddCrossLine();
		addToolTipDrawList(m_Tooltip, addDrawItemText(missionData.ProgressDetailDesc, GTColor().ColorDesc, "", true, false));			
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);	
}

function ReturnTooltip_RankingPvp(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
	// End:0x1EE
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[1].szData, getInstanceL2Util().Yellow, "", false, false));
		addToolTipDrawList(m_Tooltip, addDrawItemText(" " $ Record.LVDataList[0].szData, getInstanceL2Util().BWhite, "", false, true));
		AddCrossLine();
		AddTooltipItemOption(164, Record.LVDataList[4].szData, true, true, false);
		AddTooltipItemOption(2290, Record.LVDataList[2].szData, true, true, false);
		AddTooltipItemOption(439, Record.LVDataList[3].szData, true, true, false);
		AddTooltipItemBlank(4);
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(2240) $ " : ", GTColor().Blue, "", true, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(MakeCostStringINT64(Record.nReserved1) $ "  ", GTColor().Sandrift, "", false, false));
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13412) $ " : ", GTColor().Red, "", false, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(MakeCostStringINT64(Record.nReserved2), GTColor().Sandrift, "", false, false));
		ReturnTooltipInfo(m_Tooltip);
		return;
	}
}

function ReturnTooltip_RankingCombatPower(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
	// End:0x1EE
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[1].szData, getInstanceL2Util().Yellow, "", false, false));
		addToolTipDrawList(m_Tooltip, addDrawItemText(" " $ Record.LVDataList[0].szData, getInstanceL2Util().BWhite, "", false, true));
		AddCrossLine();
		AddTooltipItemOption(164, Record.LVDataList[4].szData, true, true, false);
		AddTooltipItemOption(2290, Record.LVDataList[2].szData, true, true, false);
		AddTooltipItemOption(439, Record.LVDataList[3].szData, true, true, false);
		ReturnTooltipInfo(m_Tooltip);
		return;
	}
}

function ReturnTooltip_RankingOlympiad(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local string firstSpace, tm;
	local int i;
	local array<string> ArrayStr;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
	// End:0x20
	if(eSourceType == NTST_LIST_DRAWITEM)
	{
	}
	else if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		// End:0x12E
		if(Record.nReserved1 == 1001)
		{
			// End:0x12B
			if(Record.szReserved != "")
			{
				firstSpace = " ";
				Split(Record.szReserved, ", ", ArrayStr);
				addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13153), getInstanceL2Util().Yellow, "", true, true));
				AddCrossLine();

				// End:0x11E [Loop If]
				for (i = 0; i < ArrayStr.Length; i++)
				{
					addToolTipDrawList(m_Tooltip, addDrawItemText(firstSpace $ ArrayStr[i], getInstanceL2Util().White, "", true, false));
					firstSpace = "";
				}
				m_Tooltip.MinimumWidth = 200;
			}
		}
		else if(Record.nReserved1 == 1000)
		{
			// End:0x1C9
			if(Record.szReserved != "")
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13163), getInstanceL2Util().Yellow, "", true, true));
				AddCrossLine();
				addToolTipDrawList(m_Tooltip, addDrawItemText(Record.szReserved, getInstanceL2Util().White, "", true, true));
				m_Tooltip.MinimumWidth = 200;
			}
			else
			{
				return;
			}
		}
		else if(Record.nReserved1 == 1002)
		{
			ParamToRecord(param, Record);
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().Yellow, "", false, true));
			AddCrossLine();
			AddTooltipItemOption(2694, Record.LVDataList[2].szData, true, true, false);
			AddTooltipItemOption(2290, Record.LVDataList[1].szData, true, true, false);
			// End:0x29C
			if(Record.LVDataList[3].szData == "")
			{
				tm = GetSystemString(431);
			}
			else
			{
				tm = Record.LVDataList[3].szData;
			}
			AddTooltipItemOption(439, tm, true, true, false);
		}
		else if(Record.nReserved1 == 1003)
		{
			ParamToRecord(param, Record);
			addToolTipDrawList(m_Tooltip, addDrawItemText("Lv." $ string(Record.nReserved2), getInstanceL2Util().Yellow, "", false, false));
			addToolTipDrawList(m_Tooltip, addDrawItemText(" " $ Record.LVDataList[2].szData, getInstanceL2Util().BWhite, "", false, true));
			AddCrossLine();
			AddTooltipItemOption(2290, Record.szReserved, true, true, false);
			// End:0x3AE
			if(Record.LVDataList[3].szData == "")
			{
				tm = GetSystemString(431);
			}
			else
			{
				tm = Record.LVDataList[3].szData;
			}
			AddTooltipItemOption(439, tm, true, true, false);
			ReturnTooltipInfo(m_Tooltip);
		}
	}
	else
	{
		return;
	}
	
	ReturnTooltipInfo(m_Tooltip);
}

function ReturnTooltip_RankingPet(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
	// End:0xCF
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[1].szData, getInstanceL2Util().Yellow, "", false, false));
		addToolTipDrawList(m_Tooltip, addDrawItemText(" " $ Record.LVDataList[0].szData, getInstanceL2Util().BWhite, "", false, true));
		AddCrossLine();
		AddTooltipItemOption(13331, Record.LVDataList[2].szData, true, true, false);
		ReturnTooltipInfo(m_Tooltip);
		return;
	}
}

function string getStringShopType(int nShopType)
{
	// End:0x1B
	if(nShopType == 2)
	{
		return GetSystemString(13851);		
	}
	else if(nShopType == 1)
	{
		return GetSystemString(13850);
	}
	return GetSystemString(1157);
}

function ReturnTooltip_WorldExchangeHistory(string param, ETooltipSourceType eSourceType)
{
	local RichListCtrlRowData RowData;
	local int reservedID;
	local WorldExchangeRegiWndItemHistoryTabWnd src;
	local string strAdenaComma;
	local Color lcoinColor;
	local string TooltipDesc;

	// End:0x1FF
	if(eSourceType == NTST_LIST_DRAWITEM)
	{
		ParseString(param, "TooltipDesc", TooltipDesc);
		// End:0x76
		if(TooltipDesc == "btnTooltipAdena")
		{
			// End:0x92
			if(class'WorldExchangeBuyWnd'.static.Inst()._IsNewServer())
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14424), getInstanceL2Util().White));				
			}
			else
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14192), getInstanceL2Util().White));
			}
		}
		else
		{
			src = class'WorldExchangeRegiWnd'.static.Inst().historyScr;
			ParseInt(param, "ReservedID", reservedID);
			// End:0xD7
			if(src.GetRichListCtrlRowData(reservedID, RowData) == -1)
			{
				return;
			}
			m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
			switch(int(RowData.nReserved3))
			{
				// End:0xCE
				case src.listType.Received:
					addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14091), getInstanceL2Util().Red, "", true, true));
					AddCrossLine();
					strAdenaComma = MakeCostString(string(RowData.nReserved2));
					lcoinColor = GetNumericColor(strAdenaComma);
					addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14106) $ ": ", getInstanceL2Util().BWhite, "gameDefault11", true, true));
					addToolTipDrawList(m_Tooltip, addDrawItemText(strAdenaComma, lcoinColor, "gameDefault11", false, true));
					// End:0x2F9
					break;
				// End:0x110
				case src.listType.TimeOut:
					addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14090), getInstanceL2Util().Red, "", true, true));
					// End:0x155
					break;
				// End:0x152
				case src.listType.Normal:
					addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14073), getInstanceL2Util().Gray, "", true, true));
					AddCrossLine();
					strAdenaComma = MakeCostString(string(RowData.nReserved2));
					lcoinColor = GetNumericColor(strAdenaComma);
					addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14107) $ ": ", getInstanceL2Util().BWhite, "gameDefault11", true, true));
					addToolTipDrawList(m_Tooltip, addDrawItemText(strAdenaComma, lcoinColor, "gameDefault11", false, true));
					// End:0x2F9
					break;
			}
		}
		ReturnTooltipInfo(m_Tooltip);
	}
}

function ReturnTooltip_PrivateShopFind(string param, ETooltipSourceType eSourceType)
{
	local string TooltipDesc, shopTypeString;
	local Color tColor;
	local int Count, nShopType, nEnchant, i;
	local INT64 adenaNum;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
	// End:0x2BD
	if(eSourceType == NTST_LIST_DRAWITEM)
	{
		ParseString(param, "TooltipDesc", TooltipDesc);
		// End:0x85
		if(TooltipDesc == "")
		{
			m_Tooltip.MinimumWidth = 10;
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(687), getInstanceL2Util().Yellow, "", true, true));			
		}
		else
		{
			ParseInt(param, "count", Count);
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13849), getInstanceL2Util().White, "", true, true));
			AddCrossLine();
			// End:0x10E
			if(Count <= 0)
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13885), getInstanceL2Util().White, "", true, true));				
			}
			else
			{
				// End:0x2B2 [Loop If]
				for(i = 1; i <= Count; i++)
				{
					ParseINT64(param, "adenaString" $ string(i), adenaNum);
					ParseInt(param, "shopType" $ string(i), nShopType);
					ParseInt(param, "enchant" $ string(i), nEnchant);
					// End:0x1B1
					if(nShopType == 1)
					{
						tColor = GetColor(255, 102, 102, 255);						
					}
					else if(nShopType == 2)
					{
						tColor = GetColor(136, 136, 255, 255);							
					}
					else
					{
						tColor = GetColor(85, 153, 255, 255);
					}
					shopTypeString = getStringShopType(nShopType);
					addToolTipDrawList(m_Tooltip, addDrawItemText(shopTypeString $ " ", tColor, "", true, true));
					addToolTipDrawList(m_Tooltip, addDrawItemText(ConvertNumToText(string(adenaNum)) $ " ", GTColor().White, "", false, true));
					// End:0x2A1
					if(nEnchant > 0)
					{
						addToolTipDrawList(m_Tooltip, addDrawItemText("(+" $ string(nEnchant) $ GetSystemString(2066) $ ")", GTColor().Yellow, "", false, true));
					}
					AddTooltipItemBlank(1);
				}
			}
		}
		ReturnTooltipInfo(m_Tooltip);
	}
}

function ReturnTooltip_RankingReward_Character(string param, ETooltipSourceType eSourceType)
{
	local SkillInfo Info;
	local LVDataRecord Record;
	local string TooltipDesc;
	local int Id;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
	// End:0x199
	if(eSourceType == NTST_LIST_DRAWITEM)
	{
		// End:0x189
		if(ParseInt(param, "ReservedID", Id))
		{
			m_Tooltip.MinimumWidth = 260;
			ParseString(param, "TooltipDesc", TooltipDesc);
			GetSkillInfo(Id, 1, 0, Info);
			// End:0x124
			if(TooltipDesc == "on")
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(Info.SkillName, getInstanceL2Util().Yellow, "", true, true));
				AddCrossLine();
				addToolTipDrawList(m_Tooltip, addDrawItemText(Info.SkillDesc, getInstanceL2Util().ColorLightBrown, "", true, false));
			}
			else
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(Info.SkillName, getInstanceL2Util().Gray, "", true, true));
				AddCrossLine();
				addToolTipDrawList(m_Tooltip, addDrawItemText(Info.SkillDesc, getInstanceL2Util().Gray, "", true, false));
			}
		}
		else
		{
			return;
		}
		ReturnTooltipInfo(m_Tooltip);
	}
	else if(eSourceType == NTST_LIST)
    {
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[1].szData, getInstanceL2Util().Yellow, "", false, false));
		addToolTipDrawList(m_Tooltip, addDrawItemText(" " $ Record.LVDataList[0].szData, getInstanceL2Util().BWhite, "", false, true));
		AddCrossLine();
		AddTooltipItemOption(164, Record.LVDataList[4].szData, true, true, false);
		AddTooltipItemOption(2290, Record.LVDataList[2].szData, true, true, false);
		AddTooltipItemOption(439, Record.LVDataList[3].szData, true, true, false);
		ReturnTooltipInfo(m_Tooltip);
		return;
    }
}

function ReturnTooltip_SuppressRichList(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local string TooltipDesc;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
	// End:0x8F
	if(eSourceType == NTST_LIST_DRAWITEM)
	{
		m_Tooltip.MinimumWidth = 50;
		ParseString(param, "TooltipDesc", TooltipDesc);
		// End:0x7F
		if(TooltipDesc != "")
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(TooltipDesc, getInstanceL2Util().BWhite, "", true, true));			
		}
		else
		{
			return;
		}
		ReturnTooltipInfo(m_Tooltip);		
	}
	else if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.szReserved, getInstanceL2Util().BWhite, "", true, true));
		ReturnTooltipInfo(m_Tooltip);
	}
}

/////////////////////////////////////////////////////////////////////////////////
// ?ó—â¬µ–µ—ë–? ?ë—Ü¬µ¬? ?ï—à–ñ–?
function ReturnTooltip_CursedWeapon(string param)
{
	local string t_param, strAdenaComma;
	local Color AdenaColor;
	local array<string> arrSplit;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;

	ParseString(param, "Text", t_param);

	Split(t_param, "|", arrSplit);
	// End:0x44
	if(arrSplit.Length <= 0)
	{
		return;
	}
	// End:0x2C6
	if(arrSplit[0] == "sword")
	{
		// End:0x132
		if(arrSplit.Length <= 4)
		{
			AddTooltipColorText(arrSplit[1], getInstanceL2Util().Red, false, false, true);
			AddCrossLine();
			strAdenaComma = MakeCostString(arrSplit[2]);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(3950, strAdenaComma $ " " $ GetSystemString(469), true, true, false,,,,, AdenaColor);
			strAdenaComma = MakeCostString(arrSplit[3]);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(3951, strAdenaComma $ " " $ GetSystemString(469), true, true, false,,,,, AdenaColor);
		}
		else
		{
			// ?ë¬∂¬∞–? ?ó—á¬∞–? ¬µ?ó–Ö–ì—ó–? ?ñ–Ñ—ó–ì¬∂¬?..
			AddTooltipColorText(arrSplit[1], getInstanceL2Util().Red, false, false, true);
			strAdenaComma = MakeCostString(arrSplit[2]);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(3950, strAdenaComma $ " " $ GetSystemString(469), true, true, false,,,,, AdenaColor);
			strAdenaComma = MakeCostString(arrSplit[3]);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(3951, strAdenaComma $ " " $ GetSystemString(469), true, true, false,,,,, AdenaColor);
			AddCrossLine();
			AddTooltipColorText(arrSplit[4], getInstanceL2Util().Red, false, false, true);
			strAdenaComma = MakeCostString(arrSplit[5]);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(3950, strAdenaComma $ " " $ GetSystemString(469), true, true, false,,,,, AdenaColor);
			strAdenaComma = MakeCostString(arrSplit[6]);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(3951, strAdenaComma $ " " $ GetSystemString(469), true, true, false,,,,, AdenaColor);
		}
	}
	// ?î—ë‚Ññ¬∞¬ª?É–ê–?
	// treasureBox
	else
	{
		// ?î—ë‚Ññ¬∞¬ª?É–ê–™“ë–? ?ê–ú—ë¬ß—ë—?..
		m_Tooltip.MinimumWidth = 60;
		AddTooltipColorText(arrSplit[1], getInstanceL2Util().DRed, false, true, true);
	}

	// Debug("- Text-->: " @ t_param);
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// Gfx?ó–é—ò¬? ?î—ë—ñ¬ª“ë–? ?î—ó–Ö—î–ï–? ?ï—à–ñ–? 
function ReturnTooltip_NTT_GFxTooltip(string param)
{
	local string Text;
	local int Count, i, R, G, B, A,
		MinWidth, W, h, uw, uh,
		OffsetX, OffsetY, lineBreak, oneline, DrawItemType;

	ParseInt(param, "count", Count);
	ParseInt(param, "min", MinWidth);
	m_Tooltip.MinimumWidth = MinWidth;

	//Debug (param);
	// End:0x377 [Loop If]
	for(i = 0; i < Count; i ++)
	{
		ParseInt(param, "t_" $ i, DrawItemType);
		switch(EDrawItemType(DrawItemType))
		{
			// End:0xAC
			case EDrawItemType.DIT_BLANK:
				ParseString(param, "txt_" $ i, Text);
				AddTooltipItemBlank(int(Text));
				// End:0x36D
				break;
			// End:0x206
			case EDrawItemType.DIT_TEXT:
				ParseString(param, "txt_" $ i, Text);
				ParseInt(param, "R_" $ i, R);
				ParseInt(param, "G_" $ i, G);
				ParseInt(param, "B_" $ i, B);
				ParseInt(param, "A_" $ i, A);
				ParseInt(param, "oX_" $ i, OffsetX);
				ParseInt(param, "oY_" $ i, OffsetY);
				ParseInt(param, "lb_" $ i, lineBreak);
				ParseInt(param, "ol_" $ i, oneline);
				AddTooltipColorText(Text, GetColor(R, G, B, A), bool(lineBreak), bool(oneline), i == 0, "", OffsetX, OffsetY);
				// End:0x36D
				break;
			// End:0x354
			case EDrawItemType.DIT_TEXTURE:
				ParseString(param, "textu_" $ i, Text);
				ParseInt(param, "w_" $ i, W);
				ParseInt(param, "h_" $ i, h);
				ParseInt(param, "uw_" $ i, uw);
				ParseInt(param, "uh_" $ i, uh);
				ParseInt(param, "oX_" $ i, OffsetX);
				ParseInt(param, "oY_" $ i, OffsetY);
				ParseInt(param, "lb_" $ i, lineBreak);
				ParseInt(param, "ol_" $ i, oneline);
				addTooltipTexture(Text, W, h, uw, uh, bool(lineBreak), bool(oneline), OffsetX, OffsetY);
				// End:0x36D
				break;
			// End:0x362
			case EDrawItemType.DIT_SPLITLINE:
				AddCrossLine();
				// End:0x36D
				break;
			// End:0x36A
			case EDrawItemType.DIT_TEXTLINK:
				// End:0x36D
				break;
		}
	}
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// ?ó—â¬µ–µ—ë–? ?ë—Ü¬µ¬? ?ï—à–ñ–?
function ReturnTooltip_NTT_MAP_REGIONINFO(string param, ETooltipSourceType eSourceType)
{
	local L2FactionUIData FactionData;
	local int nType, nHuntingZoneType;
	local HuntingZoneUIData huntingZoneData;
	local string tmpStr, textStr, seedMessage, addStr, CastleName, OwnerClanName,
		OwnerClanNameToolTip, NextSiegeTime, SiegeState, castleType, TaxRate,
		DateTotal, agitName, OwnerClanMasterName, LocationName, ToolTipString,
		tooltipString2;

	local int Index, nActive, i, nFactionID, nFactionLevel, nCastleID;

	local RaidUIData pRaidUIData;

	// End:0xFBA
	if(eSourceType == NTST_TEXT)
	{
		ParseInt(param, "Type", nType);
		//ParseInt(param, "HuntingZoneIndex", nHuntingZoneIndex);
		ParseInt(param, "Index", Index);
		ParseInt(param, "Active", nActive);
		ParseString(param, "Text", textStr);
		m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
		Debug("--> Îß? ?à¥?åÅ " @ param);
		// End:0x3DA
		if(nType == EMinimapRegionType.MRT_Castle)
		{
			ParseString(param, "CastleName", CastleName);
			ParseInt(param, "CastleID", nCastleID);
			ParseString(param, "OwnerClanNameToolTip", OwnerClanNameToolTip);
			ParseString(param, "OwnerClanName", OwnerClanName);
			ParseString(param, "NextSiegeTime", NextSiegeTime);
			ParseString(param, "SiegeState", SiegeState);
			ParseString(param, "CastleType", castleType);
			ParseString(param, "TaxRate", TaxRate);
			AddTooltipColorText(CastleName, getInstanceL2Util().White, false, false, true);
			// End:0x2D9
			if(IsBloodyServer())
			{
				Debug("nCastleID" @ nCastleID);
				
				// ?î–Ω¬∑–á¬µ—? ?ò¬??Ññ?Ü—ó‚Ññ?ó–??ì—ñ—ë¬?, 
				// 2018-10-02, ?ë¬∂‚Ññ?ú¬∞–? ?ó–¥–ì¬? ?ï–ñ¬µ¬ß—ò—î—ë—? ¬∞?à—ò—? ?ë¬§—î—? ?ñ–Ñ—ó–ê¬µ¬µ¬∑–?
				// ?ò¬§–Ö–? ?ë–©—ë“? ?ó–¥–ì¬ª–ê–? ?ó–? ?ò—Ü¬µ¬? ?ê–¶–ê—ë“ë–? ?î‚Ññ¬ª–∑ ?ó–®—ò¬? ?î–©—ó¬? ?ñ—Ö—ï–¢–ê–?.
				// End:0x2D6
				if(nCastleID == 5)  // ?ï–ñ¬µ¬ß—ò—î—ë—? ?ñ–Ñ—ó–ê¬µ¬µ¬∑–?.
				{
					// End:0x20C
					if(castleType != "")
					{
						AddTooltipColorText(" (" $ castleType $ ")", getInstanceL2Util().ColorLightBrown, false, false, true);
					}
					AddCrossLine();
					AddTooltipColorText(GetSystemString(1607) $ " : " $ OwnerClanName, getInstanceL2Util().ColorYellow, true, true, false);  // ?ò–¢–ê–? ?ó—á—ë–?
					AddTooltipColorText(GetSystemString(1612) $ " : " $ SiegeState, getInstanceL2Util().ColorYellow, true, true, false);     // ?ó—Ü–ò–?: ?ê—å–ê–ø–ë–?, ?ñ—Ç–ò¬?
					AddTooltipColorText(GetSystemString(1608) $ " : " $ TaxRate, getInstanceL2Util().ColorYellow, true, true, false);        // ?ò—ò¬±–?
					AddTooltipColorText(GetSystemString(1609) $ " : " $ NextSiegeTime, getInstanceL2Util().ColorYellow, true, true, false);  // ?ë–©–ê–? ¬∞?à—ò—î–ê–?
				}
			}
			else
			{
				// End:0x30D
				if(castleType != "")
				{
					AddTooltipColorText(" (" $ castleType $ ")", getInstanceL2Util().ColorLightBrown, false, false, true); // ?î—?, ?ï–æ¬µ–?
				}
				AddCrossLine();
				AddTooltipColorText(GetSystemString(1607) $ " : " $ OwnerClanName, getInstanceL2Util().ColorYellow, true, true, false);  // ?ò–¢–ê–? ?ó—á—ë–?
				AddTooltipColorText(GetSystemString(1612) $ " : " $ SiegeState, getInstanceL2Util().ColorYellow, true, true, false);     // ?ó—Ü–ò–?: ?ê—å–ê–ø–ë–?, ?ñ—Ç–ò¬?
				AddTooltipColorText(GetSystemString(1608) $ " : " $ TaxRate, getInstanceL2Util().ColorYellow, true, true, false);        // ?ò—ò¬±–?
				AddTooltipColorText(GetSystemString(1609) $ " : " $ NextSiegeTime, getInstanceL2Util().ColorYellow, true, true, false);  // ?ë–©–ê–? ¬∞?à—ò—î–ê–?
			}
		}
		// ?ó–¥¬ª—?
		else if(nType == EMinimapRegionType.MRT_Fortress)
		{
			ParseString(param, "CastleName", CastleName); // ?ò—?(?ó–¥¬ª—?) ?ê–ú—ë¬? 
			ParseString(param, "OwnerClanName", OwnerClanName); // ?ò–¢–ê–? ?ó—á—ë–ù—ë–?
			ParseString(param, "SiegeState", SiegeState); // ?ñ—Ç–ò¬?¬ª?É–ï–?, ?ê—å–ê–? ?ë–?
			ParseString(param, "DateTotal", DateTotal); // ?ë–é¬∑–? ?Ö–ì¬∞–?
			ParseString(param, "LocationName", LocationName); // ?ò–¢—ò–£—ó¬µ–ë—?
			AddTooltipColorText(CastleName $ " | " $ MakeFullSystemMsg(GetSystemMessage(4436), LocationName), getInstanceL2Util().White, true, true, true); // ?ò—î–ê–ú—ë¬?
			// End:0x565
			if(IsBloodyServer() == false)
			{
				AddCrossLine();
				AddTooltipColorText(GetSystemString(1607) $ " : " $ OwnerClanName, getInstanceL2Util().ColorYellow, true, true, false); // ?ò–¢–ê–? ?ó—á—ë–?
				AddTooltipColorText(GetSystemString(1612) $ " : " $ SiegeState, getInstanceL2Util().ColorYellow, true, true, false);    // ?ó—Ü–ò–?: ?ê—å–ê–ø–ë–?, ?ñ—Ç–ò¬?
				// End:0x565
				if(DateTotal != "")
				{
					AddTooltipColorText(GetSystemString(1615) $ " : " $ DateTotal, getInstanceL2Util().ColorYellow, true, true, false); // ?ë–é¬∑–? ?Ö–ì¬∞–?
				}
			}
		}
		// ?ï–ñ–ë—Ü–ñ¬?
		else if(nType == EMinimapRegionType.MRT_Agit)
		{
			ParseString(param, "AgitName", agitName); // ?ï–ñ–ë—Ü–ñ¬? ?ê–ú—ë¬? 
			ParseString(param, "OwnerClanName", OwnerClanName); // ?ò–¢–ê–? ?ó—á—ë–ù—ë–?
			ParseString(param, "OwnerClanMasterName", OwnerClanMasterName); // ?ò–¢–ê–á–ë–?
			ParseString(param, "NextSiegeTime", NextSiegeTime); // ?ë–©–ê–? ?ï–ñ–ë—Ü–ñ¬? ?ê—?
			ParseString(param, "LocationName", LocationName); // ?ò–¢—ò–£—ó¬µ–ë—?
			// End:0x659
			if(LocationName != "")
			{
				AddTooltipColorText(agitName $ " | " $ MakeFullSystemMsg(GetSystemMessage(4436), LocationName), getInstanceL2Util().White, true, true, true); // ?ò—î–ê–ú—ë¬?
			}
			// End:0x730
			if(IsBloodyServer() == false)
			{
				AddCrossLine();

				// ?ë–é¬∑–? ?ó—á—ë–?			
				// End:0x685
				if(OwnerClanName == "")
				{
					OwnerClanName = GetSystemString(27);
				}
				AddTooltipColorText(GetSystemString(1607) $ " : " $ OwnerClanName, getInstanceL2Util().ColorYellow, true, true, false); 
				// ?ó—á—ë–ù–ë–? 342
				// End:0x6F3
				if(OwnerClanMasterName != "")
				{
					AddTooltipColorText(GetSystemString(342) $ " : " $ OwnerClanMasterName, getInstanceL2Util().ColorYellow, true, true, false); 
				}
				// End:0x730
				if(NextSiegeTime != "")
				{
					// ?ë–©–ê–? ?ï–ñ–ë—Ü–ñ¬??ê—? ?ë¬§—î—?
					AddTooltipColorText(GetSystemString(3545)$ " : " $ NextSiegeTime, getInstanceL2Util().ColorYellow, true, true, false); 
				}
			}
		}
		// ¬ª–∑?ñ–ô–ï–? 
		else if(nType == EMinimapRegionType.MRT_HuntingZone_Base || nType == EMinimapRegionType.MRT_HuntingZone_Mission)
		{
			ParseString(param, "SeedMessage", seedMessage);
			// ¬ª–∑?ñ–ô–ï–? ?ë¬§—î—ë—ë¬? ¬∞?é–ë¬??ó–í“ë–?.
			class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(Index, huntingZoneData);
			tmpStr = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(huntingZoneData.nSearchZoneID);

			AddTooltipColorText(huntingZoneData.strName $ " | " $ tmpStr, getInstanceL2Util().White, true, true, true);
			// End:0x8C2
			if(IsBloodyServer() == false)
			{
				AddCrossLine();
				// ?ë—à—ë–∫–ê–? ?ï—ï—ï–? ¬ª?É–ï–?
				// End:0x80F
				if(seedMessage != "")
				{
					AddTooltipColorText(seedMessage, GetColor(255, 204, 0, 255), true, true, false);
				}
				// End:0x87A
				if(huntingZoneData.nMinLevel != 0 && huntingZoneData.nMaxLevel != 0)
				{
					AddTooltipColorText(GetSystemString(922) $ " : "$ huntingZoneData.nMinLevel $ "~" $ huntingZoneData.nMaxLevel, GetColor(255, 204, 0, 255), true, true, false);
				}
				nHuntingZoneType = huntingZoneData.nType;
				tmpStr = getHuntingZoneTypeString(nHuntingZoneType);
				// End:0x8C2
				if(tmpStr != "")
				{
					AddTooltipColorText(tmpStr, GetColor(255, 204, 0, 255), true, true, false);
				}
			}
		}
		else if(nType == EMinimapRegionType.MRT_Faction)
		{
			ParseInt(param, "nFactionID", nFactionID);
			ParseInt(param, "nFactionLevel", nFactionLevel);
			GetFactionData(nFactionID, FactionData);
			AddTooltipColorText(FactionData.strFactionName, getInstanceL2Util().White, true, true, true);
			// End:0xACD
			if(IsBloodyServer() == false)
			{
				AddCrossLine();
				AddTooltipColorText(GetSystemString(3521) $ " : " $ string(nFactionLevel) $ GetSystemString(1328), GetColor(255, 204, 0, 255), true, true, false);
				// End:0xACD
				if(FactionData.arrFactionAreaName.Length > 0)
				{
					AddTooltipColorText(GetSystemString(3449) $ " : ", GetColor(255, 204, 0, 255), true, true, false);

					// End:0xACD [Loop If]
					for (i = 0; i < FactionData.arrFactionAreaName.Length; i++)
					{
						AddTooltipColorText(FactionData.arrFactionAreaName[i], GetColor(255, 204, 0, 255), false, true, false);
						// End:0xAC3
						if(i < (FactionData.arrFactionAreaName.Length - 1))
						{
							AddTooltipColorText(", ", GetColor(255, 204, 0, 255), false, true, false);
						}
					}
				}
			}
		}
		else if(nType == EMinimapRegionType.MRT_Raid)
		{
			pRaidUIData = getRaidDataByIndex(Index);
			AddTooltipColorText(pRaidUIData.raidMonsterName $ " | " $ pRaidUIData.RaidMonsterZoneName, getInstanceL2Util().White, true, true, true);
			AddCrossLine();

			// xx ¬∑?Ññ?î¬? ¬∑?Ññ?ê–ú¬µ–? ?ë—É–Ö—î–ï–? 
			AddTooltipColorText(MakeFullSystemMsg(GetSystemMessage(4425), string(pRaidUIData.nRaidMonsterLevel) $ GetSystemString(537)), GetColor(255, 204, 0, 255), true, true, false);
			// End:0xC11
			if(nActive > 0)
			{
				tmpStr = GetSystemString(3525);
			}
			else
			{
				tmpStr = GetSystemString(3526);
			}
			AddTooltipColorText(GetSystemString(3524) $ " : " $ tmpStr, GetColor(255, 204, 0, 255), true, true, false);
		}
		else if(nType == EMinimapRegionType.MRT_InstantZone)
		{
			ParseInt(param, "Active", nActive);
			class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(Index, huntingZoneData);
			tmpStr = class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(huntingZoneData.nSearchZoneID);
			AddTooltipColorText(huntingZoneData.strName $ " | " $ tmpStr, getInstanceL2Util().White, true, true, true);
			// End:0xEF6
			if(IsBloodyServer() == false)
			{
				AddCrossLine();
				nHuntingZoneType = huntingZoneData.nType;
				tmpStr = getHuntingZoneTypeString(nHuntingZoneType);
				// End:0xD3C
				if(tmpStr != "")
				{
					AddTooltipColorText(tmpStr, GetColor(255, 204, 0, 255), true, true, false);
				}
				// End:0xDA7
				if(huntingZoneData.nMinLevel != 0 && huntingZoneData.nMaxLevel != 0)
				{
					AddTooltipColorText(GetSystemString(922) $ " : "$ huntingZoneData.nMinLevel $ "~" $ huntingZoneData.nMaxLevel, GetColor(255, 204, 0, 255), true, true, false);
				}
				AddTooltipColorText(GetSystemString(3522) $ " : " $ class'UIDATA_HUNTINGZONE'.static.GetHuntingDescription(Index), GetColor(255, 204, 0, 255), true, true, false);
				// End:0xEB6
				if(huntingZoneData.arrQuestIDs.Length > 0)
				{
					AddTooltipColorText(GetSystemString(3523) $ " : ", GetColor(255, 204, 0, 255), true, true, false);

					// End:0xEB6 [Loop If]
					for (i = 0; i < huntingZoneData.arrQuestIDs.Length; i++)
					{
						addStr = class'UIDATA_QUEST'.static.GetQuestName(huntingZoneData.arrQuestIDs[i]);
						AddTooltipColorText(addStr, GetColor(255, 204, 0, 255), false, true, false);
						// End:0xEAC
						if(i < huntingZoneData.arrQuestIDs.Length - 1)
						{
							AddTooltipColorText(", ", GetColor(255, 204, 0, 255), false, true, false);
						}
					}
				}
				// End:0xEF6
				if(nActive <= 0)
				{
					// ?ó—Ü–ê–? ?ó—Ü–ò–? : ?ê–ú—ó–? ?î–¢¬∞–? 
					AddTooltipColorText(GetSystemString(3524) $ " : " $ GetSystemString(5099), GetColor(255, 204, 0, 255), true, true, false);
				}
			}
		}
		else if(nType == EMinimapRegionType.MRT_Etc || nType == EMinimapRegionType.MRT_Quest) 
		{
			m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH / 4;
			ParseString(param, "tooltipString", ToolTipString);
			ParseString(param, "tooltipString2", tooltipString2);
			// End:0xF90
			if(ToolTipString != "")
			{
				AddTooltipColorText(ToolTipString, getInstanceL2Util().White, false, true, false);
			}
			// End:0xFB7
			if(tooltipString2 != "")
			{
				AddTooltipColorText(tooltipString2, GetColor(255, 204, 0, 255), true, true, false);
			}
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// TEXT
function ReturnTooltip_NTT_TEXT(string param, ETooltipSourceType eSourceType, bool bDesc)
{
	local string strText;
	local int Id;
	local array<TextSectionInfo> TextInfos;
	local string FullText, strDesc;

	// End:0x1AC
	if(eSourceType == NTST_TEXT)
	{
		// End:0xFB
		if(ParseString(param, "Text", strText))
		{
			// End:0xF8
			if(Len(strText) > 0)
			{
				// End:0xC2
				if(bDesc)
				{
					m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_color.R = 178;
					m_Info.t_color.G = 190;
					m_Info.t_color.B = 207;
					m_Info.t_color.A = 255;
					m_Info.t_strText = strText;
					EndItem();
				}
				else
				{
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_color.R = 200;
					m_Info.t_color.G = 200;
					m_Info.t_color.B = 200;
					m_Info.t_color.A = 255;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = strText;
					EndItem();
				}
			}
		}
		else if(ParseInt(param, "ID", Id))
		{
			// End:0x1A9
			if(Id > 0)
			{
				StartItem();
				GetItemTextSectionInfos(GetSystemString(Id), FullText, TextInfos);
				// End:0x168
				if(TextInfos.Length > 0)
				{
					strDesc = FullText;
					m_Info.t_SectionList = TextInfos;
				}
				else
				{
					strDesc = GetSystemString(Id);
				}
				m_Info.eType = DIT_TEXT;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_color.R = 200;
				m_Info.t_color.G = 200;
				m_Info.t_color.B = 200;
				m_Info.t_color.A = 255;
				m_Info.t_strText = strDesc;
				EndItem();
			}
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

function bool addItemIcon(ItemInfo item, string ForeTexture, optional string ForeTexture1, optional bool bBigSizeIcon)
{
	local int nAddBigsize;

	// End:0x13
	if(item.IconName == "")
	{
		return false;
	}
	// End:0x24
	if(bBigSizeIcon)
	{
		nAddBigsize = 16;
	}
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = 34 + nAddBigsize;
	m_Info.u_nTextureHeight = 34 + nAddBigsize;
	m_Info.u_nTextureUWidth = 34 + nAddBigsize;
	m_Info.u_nTextureUHeight = 34 + nAddBigsize;
	m_Info.u_strTexture = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
	EndItem();
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = 32 + nAddBigsize;
	m_Info.u_nTextureHeight = 32 + nAddBigsize;
	m_Info.u_nTextureUWidth = 32 + nAddBigsize;
	m_Info.u_nTextureUHeight = 32 + nAddBigsize;
	m_Info.nOffSetX = -33 + nAddBigsize;
	m_Info.nOffSetY = 1;
	m_Info.u_strTexture = item.IconName;
	EndItem();
	// End:0x1B0
	if(item.IsBlessedItem)
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.u_nTextureWidth = 32 + nAddBigsize;
		m_Info.u_nTextureHeight = 32 + nAddBigsize;
		m_Info.u_nTextureUWidth = 32 + nAddBigsize;
		m_Info.u_nTextureUHeight = 32 + nAddBigsize;
		m_Info.nOffSetX = -32 + nAddBigsize;
		m_Info.nOffSetY = 1;
		m_Info.u_strTexture = "Icon.icon_panel.bless_panel";
		EndItem();
	}
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = 32 + nAddBigsize;
	m_Info.u_nTextureHeight = 32 + nAddBigsize;
	m_Info.u_nTextureUWidth = 32 + nAddBigsize;
	m_Info.u_nTextureUHeight = 32 + nAddBigsize;
	m_Info.nOffSetX = -32 + nAddBigsize;
	m_Info.nOffSetY = 1;
	m_Info.u_strTexture = item.IconPanel;
	EndItem();
	// End:0x2B3
	if(ForeTexture1 != "")
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.u_nTextureWidth = 32 + nAddBigsize;
		m_Info.u_nTextureHeight = 32 + nAddBigsize;
		m_Info.u_nTextureUWidth = 32 + nAddBigsize;
		m_Info.u_nTextureUHeight = 32 + nAddBigsize;
		m_Info.nOffSetX = -32 + nAddBigsize;
		m_Info.nOffSetY = 1;
		m_Info.u_strTexture = ForeTexture1;
		EndItem();
	}
	// End:0x338
	if(ForeTexture != "")
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.u_nTextureWidth = 32 + nAddBigsize;
		m_Info.u_nTextureHeight = 32 + nAddBigsize;
		m_Info.u_nTextureUWidth = 32 + nAddBigsize;
		m_Info.u_nTextureUHeight = 32 + nAddBigsize;
		m_Info.nOffSetX = -32 + nAddBigsize;
		m_Info.nOffSetY = 1;
		m_Info.u_strTexture = ForeTexture;
		EndItem();
	}
	// End:0x3DA
	if(item.bSecurityLock)
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.u_nTextureWidth = 32 + nAddBigsize;
		m_Info.u_nTextureHeight = 32 + nAddBigsize;
		m_Info.u_nTextureUWidth = 32 + nAddBigsize;
		m_Info.u_nTextureUHeight = 32 + nAddBigsize;
		m_Info.nOffSetX = -32 + nAddBigsize;
		m_Info.nOffSetY = 1;
		m_Info.u_strTexture = "Icon.Icon_panel.ItemLock_Panel";
		EndItem();
	}
	return true;
}

function addItemIconSmallType(ItemInfo item, string ForeTexture)
{
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = 16;
	m_Info.u_nTextureHeight = 16;
	m_Info.u_nTextureUWidth = 32;
	m_Info.u_nTextureUHeight = 32;
	m_Info.nOffSetX = 4;
	m_Info.nOffSetY = 2;
	m_Info.u_strTexture = item.IconName;
	EndItem();
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = 16;
	m_Info.u_nTextureHeight = 16;
	m_Info.u_nTextureUWidth = 32;
	m_Info.u_nTextureUHeight = 32;
	m_Info.nOffSetX = -16;
	m_Info.nOffSetY = 2;
	m_Info.u_strTexture = item.IconPanel;
	EndItem();
	// End:0x181
	if(ForeTexture != "")
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.u_nTextureWidth = 14;
		m_Info.u_nTextureHeight = 14;
		m_Info.u_nTextureUWidth = 32;
		m_Info.u_nTextureUHeight = 32;
		m_Info.nOffSetX = -20;
		m_Info.nOffSetY = 2;
		m_Info.u_strTexture = ForeTexture;
		EndItem();
	}
}

function addTexture(string IconName, int u_nTextureWidth, int u_nTextureHeight, int u_nTextureUWidth, int u_nTextureUHeight, optional int nOffSetX, optional int nOffSetY)
{
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = u_nTextureWidth;
	m_Info.u_nTextureHeight = u_nTextureHeight;
	m_Info.u_nTextureUWidth = u_nTextureUWidth;
	m_Info.u_nTextureUHeight = u_nTextureUHeight;
	m_Info.nOffSetX = nOffSetX;
	m_Info.nOffSetY = nOffSetY;
	m_Info.u_strTexture = IconName;
	EndItem();
}

function AddTooltipItemLevelUpBonus(ItemInfo item, string TooltipType)
{
	local EItemType EItemType;
	local UserInfo myInfo;
	local int nPhysicalBonus, nMagicaBonus;
	local PetInfo pInfo;
	local int nLevel;

	// End:0x36
	if(TooltipType == "InventoryPet")
	{
		GetPetInfo(pInfo);
		nLevel = pInfo.nLevel;		
	}
	else
	{
		GetPlayerInfo(myInfo);
		nLevel = myInfo.nLevel;
	}
	nPhysicalBonus = GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, nLevel);
	nMagicaBonus = GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, nLevel);
	// End:0x19B
	if(nPhysicalBonus > 0 || nMagicaBonus > 0)
	{
		AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_LV_small", GetSystemString(13167));
		AddTooltipColorText(GetSystemString(13169), GetColor(176, 155, 121, 255), true, true);
		// End:0x19B
		if(item.bEquipped)
		{
			EItemType = EItemType(item.ItemType);
			// End:0x19B
			if(EItemType == ITEM_WEAPON)
			{
				AddTooltipItemOption(94, string(nPhysicalBonus), true, true, false,,,, getInstanceL2Util().CAPRI, getInstanceL2Util().CAPRI);
				AddTooltipItemOption(98, string(nMagicaBonus), true, true, false,,,, getInstanceL2Util().CAPRI, getInstanceL2Util().CAPRI);
			}
		}
	}
}

// ?ì—? / ?ï–∑—ò–?, ¬∞¬©?ó–? ¬∞¬∞?ê—? ?ê–µ—î—? ?ï–ñ–ê–ú–ï–´–ê–? ?ï—ë–ê–§–ê¬? ?ë¬??ï–ü–ó–°“ë–?.
function string getSlotTypeWithItemTypeString(ItemInfo item)
{
	local string SlotString, strTmp;
	local EItemType EItemType;

	// End:0x23
	if(EEtcItemType(item.EtcItemType) == EEtcItemType.ITEME_TRADE_TICKET)
	{
		return GetSystemString(14288);
	}
	// End:0x2D
	if(getInstanceUIData().getIsClassicServer())
	{
		// End:0x2D
		if(EItemType(item.ItemType) == ITEM_ASSET)
		{
			return "";
		}
	}
	EItemType = EItemType(item.ItemType);
	SlotString = GetSlotTypeString(item.ItemType, item.SlotBitType, item.ArmorType);
	// End:0xB5
	if(eItemType == ITEM_WEAPON)
	{
		strTmp = GetWeaponTypeString(item.WeaponType);
		// End:0xB5
		if(Len(strTmp) > 0)
		{
			SlotString = strTmp $ " / " $ SlotString;
		}
	}
	return SlotString;
}

/////////////////////////////////////////////////////////////////////////////////
// INVENTORY Etc
function ReturnTooltip_NTT_ITEM(string param, string TooltipType, ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local EItemType EItemType;
	local EEtcItemType EEtcItemType;
	local int nTmp;
	local string strAdena, strAdenaComma;
	local Color AdenaColor;
	local EnchantValidateUIData enchantData;
	local bool bMagicWeapon;
	local float fSoulShotPower, fSpiritShotPower;
	local int nEnchantedPhysicalDamageBonus, nEnchantedMagicalDamageBonus, nEnchantedMagicalDefenseBonus, nEnchantedPhysicalDefenseBonus, nEnchantedShieldDefenseBonus;

	local string ForeTexture, ItemSlotWithItemTypeStr;
	local int IsCompareItem, IsComparingEquip, nEnchantValueTextGap, bMainIconGap;
	local UserInfo myInfo;
	local int nPhysicalBonus, nMagicaBonus;
	local string autoUsePanel;
	local PetNameInfo PetNameInfo;
	local string petNameStr;
	local PetInfo PetInfo;
	local int nUseSimpleTooltip, nIsSelectMode;
	local bool bBigSizeIcon, isForeTexture;
	local int isDualEquip, isEmptyItem, isEqualItem;

	// End:0x4042
	if(eSourceType == NTST_ITEM || eSourceType == NTST_LIST)
	{
		ParamToItemInfo(param, item);
		ParseInt(param, "IsCompareItem", IsCompareItem);
		ParseInt(param, "IsComparingEquip", IsComparingEquip);
		ParseInt(param, "UseSimpleTooltip", nUseSimpleTooltip);
		ParseInt(param, "IsSelectMode", nIsSelectMode);
		// End:0xE0
		if(TooltipType == "EnsoulSlot")
		{
			// End:0xE0
			if(item.Id.ClassID <= 0)
			{
				return;
			}
		}
		class'UIDATA_ITEM'.static.GetEnchantValidateValue(item.Id.ClassID, item.Enchanted, enchantData);
		EItemType = EItemType(item.ItemType);
		EEtcItemType = EEtcItemType(item.EtcItemType);
		nEnchantedShieldDefenseBonus = int(enchantData.EnchantValue[12]);
		nEnchantedPhysicalDefenseBonus = int(enchantData.EnchantValue[0]);
		nEnchantedMagicalDefenseBonus = int(enchantData.EnchantValue[1]);
		nEnchantedPhysicalDamageBonus = int(enchantData.EnchantValue[2]);
		nEnchantedMagicalDamageBonus = int(enchantData.EnchantValue[3]);
		ParseString(param, "ForeTexture", ForeTexture);
		isForeTexture = ForeTexture == "L2UI_CT1.Icon.WearPanel";
		if(item.tooltipBGDecoTexture != "")
		{
			addOverlayTexture(item.tooltipBGDecoTexture, 256, 378, 256, 378, 3, 3);
		}
		ParseInt(param, "isDualEquip", isDualEquip);
		if(isDualEquip == 1)
		{
			if((InventoryWnd(GetScript("InventoryWnd"))._GetSwapSelectButtonIndex() ^ 1) == 0)
			{
				AddTooltipColorText("[" $ GetSystemString(14277) $ "]", GetColor(255, 204, 0, 255), true, true, true);				
			}
			else
			{
				AddTooltipColorText("[" $ GetSystemString(14278) $ "]", GetColor(255, 204, 0, 255), true, true, true);
			}
			AddTooltipItemBlank(0);
			AddCrossLine();			
		}
		else
		{
			if(IsCompareItem == 1 || isForeTexture)
			{
				if(IsComparingEquip == 1 || isForeTexture)
				{
					AddTooltipColorText("[" $ GetSystemString(3556) $ "]", GetColor(255, 204, 0, 255), true, true, true);					
				}
				else
				{
					AddTooltipColorText("[" $ GetSystemString(3555) $ "]", GetColor(182, 182, 182, 255), true, true, true);
				}
				AddTooltipItemBlank(0);
				AddCrossLine();
			}
		}
		ParseInt(param, "isEmptyItem", isEmptyItem);
		if(isEmptyItem == 1)
		{
			AddTooltipItemBlank(10);
			AddTooltipColorText(GetSystemString(14279), getInstanceL2Util().Gray, true, true, true);
			m_Tooltip.DrawList[m_Tooltip.DrawList.Length - 1].eAlignType = DIAT_CENTER;
			AddTooltipItemBlank(10);
			ReturnTooltipInfo(m_Tooltip);
			return;
		}
		ParseInt(param, "isEqualItem", isEqualItem);
		if(isEqualItem == 1)
		{
			AddTooltipItemBlank(10);
			AddTooltipColorText(GetSystemString(14280), getInstanceL2Util().White, true, true, true);
			m_Tooltip.DrawList[m_Tooltip.DrawList.Length - 1].eAlignType = DIAT_CENTER;
			AddTooltipItemBlank(10);
			ReturnTooltipInfo(m_Tooltip);
			return;
		}
		switch(class'UIDATA_ITEM'.static.GetAutomaticUseItemType(item.Id.ClassID))
		{
			case AUIT_ITEM:
				autoUsePanel = "Icon.autoskill_panel_01";
				break;
		}
		if(IsAdenServer())
		{
			switch(item.Id.ClassID)
			{
				case 93864:
				case 96927:
				case 96928:
				case 96929:
				case 96930:
				case 96931:
				case 96932:
				case 96933:
				case 96935:
				case 96938:
				case 96939:
				case 96940:
				case 97088:
				case 97089:
				case 98203:
					bBigSizeIcon = true;
					break;
			}
		}
		//else
		//{
			if(addItemIcon(item, ForeTexture, autoUsePanel, bBigSizeIcon))
			{
				bMainIconGap = 3;
			}
			
			AddPrimeItemSymbol(item, true);
			if(TooltipType != "InventoryPrice1HideEnchant" && TooltipType != "InventoryPrice1HideEnchantStackable")
			{
				AddTooltipItemEnchant(item, true, "gameDefault10", 6, 1);
				nEnchantValueTextGap = 3;
			}
			AddTooltipItemName(item, "gameDefault10", bMainIconGap + nEnchantValueTextGap, 1);
			if(TooltipType != "InventoryPrice1HideEnchantStackable")
			{
				if(TooltipType != "QuestReward")
				{
					if(item.ItemNum > 0)
					{
						AddTooltipItemCount(item, 0, 1);
					}
				}
			}
			AddTooltipItemGrade(item, 0, 1);
			ItemSlotWithItemTypeStr = getSlotTypeWithItemTypeString(item);

			if(ItemSlotWithItemTypeStr != "")
			{
				AddTooltipItemBlank(1);
				if(bBigSizeIcon)
				{
					AddTooltipColorText(ItemSlotWithItemTypeStr, GetColor(176, 155, 121, 255), false, true, false, "", 38 + 16, - 19 + 16);					
				}
				else
				{
					AddTooltipColorText(ItemSlotWithItemTypeStr, GetColor(176, 155, 121, 255), false, true, false, "", 38, -19);
				}
			}
			
			if(EEtcItemType == ITEME_PET_COLLAR)
			{
				if(getInstanceUIData().getIsClassicServer())
				{					
				}
				else
				{
					AddItemEnchantedImg(item.Enchanted);
				}				
			}
			else
			{
				AddItemEnchantedImg(item.Enchanted);
			}
			
			if(isSImpleTooltipNoSelect(nUseSimpleTooltip, nIsSelectMode))
			{
				if(isAttribute(item) || isLevelUpBonus(item, TooltipType) || isEnsoulOption(item) || isBlessed(item) || isCollectionItem(item) || isHeroBookItem(item))
				{
					AddTooltipItemBlank(0);
					addTooltipTextureSplitLineType("L2UI_NewTex.Tooltip.TooltipLine_BasicIconBG", 1, 35, 0, 0, 0, 0);
					if(isLevelUpBonus(item, TooltipType))
					{
						addTooltipTexture("L2UI_NewTex.Tooltip.TooltipICON_LV", 26, 26, 0, 0, true, false, 2, 5);
					}
					if(isBlessed(item))
					{
						addTooltipTexture("L2UI_NewTex.Tooltip.TooltipICON_bless", 26, 26, 0, 0, true, false, 2, 5);
					}
					if(isEnsoulOption(item))
					{
						AddSimpleIcon_EnsoulOption(item);
					}
					if(isAttribute(item))
					{
						addTooltipTexture("L2UI_NewTex.Tooltip.TooltipICON_AttackAttributeValue", 26, 26, 0, 0, true, false, 2, 5);
					}
					if(isCollectionItem(item))
					{
						addTooltipTexture("L2UI_NewTex.ToolTip.TooltipICON_Collection", 26, 26, 0, 0, true, false, 2, 5);
					}
					if(isHeroBookItem(item))
					{
						addTooltipTexture("L2UI_NewTex.ToolTip.TooltipIcon_Herobook", 26, 26, 0, 0, true, false, 2, 5);
					}
					AddTooltipItemBlank(0);
				}
				else
				{
					AddCrossLineThick();
				}
			}
			else
			{
				AddCrossLineThick();
			}

			//?ï–ñ–ê–ú–ï–´–ê–? ?ï–ñ¬µ“ê—ñ–Ñ—ë–?, ?ê–†—ï–æ–ë–¶¬±–? ?Ö—î–ñ¬??ë¬? (4?ë—? 4000?ï–ñ¬µ“ê—ñ–? ¬∞¬∞?ê–? ?ê–†—ï–æ–ë–¶“ë–? ?Ññ¬Æ?ê–™—ó¬?¬∑??)
			if(IsAdena(item.Id) && item.ItemNum > 0)
			{
				AddTooltipText("(" $ ConvertNumToText(string(item.ItemNum)) $ ")", true, true);
			}

			// ¬∞?ñ–ê–û¬ª—É–ë–? ¬µ–æ?ó–é—ò¬? ¬∞?ñ—î¬? ?ï–ñ–ê–ú–ï–´–ê–? ¬∞?é¬∞–?¬∞?? ?ì–? ¬∞?é¬∞–??ê¬? ?î—ë—ó¬©–ë–©¬∂¬? ¬ª–∑?ó–?
			if(TooltipType == "InventoryStackableUnitPrice" && ! item.bEquipped)
			{
				strAdena = string(item.Price);
				strAdenaComma = MakeCostString(strAdena);
				AdenaColor = GetNumericColor(strAdenaComma);
				// ?ò—Ü¬∑¬??ò—? ?ï–ñ–ê–ú–ï–´–ê–ú¬∞–?, ?ï–ñ–ê–ú–ï–´–ê–? 1?î—ë“ë–? ?ï¬©“ë–©—ë–? ¬∞?ñ“ë–? ¬∞?é¬∞–??ê—ë¬∑–? ?ó“ê–Ö–?
				if(IsStackableItem(item.ConsumeType) && item.ItemNum > 1)
				{
					//1¬∞?ñ“ë–? x ?ï–ñ¬µ“ê—ñ–? : xxx,xxx,xxx
					// AddTooltipItemOption2(2511, 468, true, true, false);
					AddTooltipItemBlank(TOOLTIP_LINE_HGAP);
					AddTooltipColorText(GetSystemString(2511) $ " : ", GetColor(255, 180, 0, 255), true, true, false);
					AddTooltipColorText(strAdenaComma $ " " $ GetSystemString(469), AdenaColor, false, true,, "", 0, 0);
				}
				else
				{
					//¬∞?é¬∞–? : xxx,xxx,xxx
					AddTooltipItemOption(322, strAdenaComma $ " " $ GetSystemString(469), true, true, false,,,,, AdenaColor);
				}
				// ?ì–? ?ñ–ó—ë–ï¬∞–é¬∞–? 
				if(IsStackableItem(item.ConsumeType) && item.ItemNum > 1)
				{
					strAdena = string(item.Price * item.ItemNum);
					strAdenaComma = MakeCostString(strAdena);
					AdenaColor = GetNumericColor(strAdenaComma);
					AddTooltipItemOption(2595, strAdenaComma $ " " $ GetSystemString(469), true, true, false,,,,, AdenaColor);
				}
				//SimpleTooltip?ê¬? ¬∞?é¬∞–?¬±–æ?ë—? ?î—ë—ó¬©–ë–®“ë–?.
				//m_Tooltip.SimpleLineCount++
				//?ê–†—ï–æ–ë–¶¬±–? ?Ö—î–ñ¬??ë¬?
				if(item.Price > 0)
				{
					AddTooltipItemOption(0, "(" $ ConvertNumToText(strAdena) $ ")", false, true, false);
					SetTooltipItemColor(AdenaColor.R, AdenaColor.G, AdenaColor.B, 0);
				}
			}

			//InventoryPrice1 ?ï—ë–ê–?
			if(TooltipType == "InventoryPrice1" || TooltipType == "InventoryPrice1HideEnchant" || TooltipType == "InventoryPrice1HideEnchantStackable" && !item.bEquipped)
			{
				strAdena = string(item.Price);
				strAdenaComma = MakeCostString(strAdena);
				AdenaColor = GetNumericColor(strAdenaComma);

				//¬∞?é¬∞–? : xxx,xxx,xxx
				AddTooltipItemOption(322, strAdenaComma $ " " $ GetSystemString(469), true, true, false);

				//?ê–†—ï–æ–ë–¶¬±–? ?Ö—î–ñ¬??ë¬?
				if(item.Price > 0)
				{
					AddTooltipItemOption(0, "(" $ ConvertNumToText(strAdena) $ ")", false, true, false);
					SetTooltipItemColor(AdenaColor.R, AdenaColor.G, AdenaColor.B, 0);
				}
			}

			//InventoryPrice2 ?ï—ë–ê–?, ¬∞?ñ–ê–û¬ª—É–ë–? ¬±?ë—ë–ï¬µ–?
			if(TooltipType == "InventoryPrice2" || TooltipType == "InventoryPrice2PrivateShop")
			{
				strAdena = string(item.Price);
				strAdenaComma = MakeCostString(strAdena);
				AdenaColor = GetNumericColor(strAdenaComma);

				//¬∞?é¬∞–? : 1¬∞?ñ“ë–?
				AddTooltipItemOption2(322, 468, true, true, false);
				SetTooltipItemColor(AdenaColor.R, AdenaColor.G, AdenaColor.B, 0);
				//"?ï–ñ¬µ“ê—ñ–?"
				//"xxx,xxx,xxx "
				AddTooltipColorText(" " $ strAdenaComma $ " " $ GetSystemString(469), AdenaColor, false, true,,,, TOOLTIP_LINE_HGAP);
				if(item.Price > 0)
				{
					AddTooltipColorText("(", AdenaColor, true, true);
					AddTooltipColorText(GetSystemString(468), AdenaColor, false, true);
					AddTooltipColorText(" " $ ConvertNumToText(strAdena) $ ")", AdenaColor, false, true);
				}
			}

			if(TooltipType == "InventoryPrice2PrivateShop")
			{
				if(IsStackableItem(item.ConsumeType) && item.Reserved64 > 0)
				{
					//"¬±?ë—ë–ï¬∞—ñ—ò—? : xx"
					AddTooltipItemOption(808, string(item.Reserved64), true, true, false);
				}
			}
			switch(EItemType)
			{
				case ITEM_WEAPON:
					if(TooltipType == "InventoryPet")
					{
						GetPetInfo(PetInfo);
					}
					GetPlayerInfo(myInfo);
					if(item.bEquipped)
					{
						if(TooltipType == "InventoryPet")
						{
							nPhysicalBonus = GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, PetInfo.nLevel);
							nMagicaBonus = GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, PetInfo.nLevel);
						}
						else
						{
							nPhysicalBonus = GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, myInfo.nLevel);
							nMagicaBonus = GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, myInfo.nLevel);
						}
					}
					if(enchantData.PropertyValue[2] != 0)
					{
						if(item.bEquipped)
						{
							if(TooltipType == "InventoryPet")
							{
								AddTooltipItemOption(94, cutZeroDecimalFloat(item.pAttack + enchantData.EnchantValue[2] + float(GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, PetInfo.nLevel)) + enchantData.PropertyValue[2]), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							}
							else
							{
								AddTooltipItemOption(94, cutZeroDecimalFloat(item.pAttack + enchantData.EnchantValue[2] + float(GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, myInfo.nLevel)) + enchantData.PropertyValue[2] + float(myInfo.nAddPAttack)), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							}
						}
						else
						{
							AddTooltipItemOption(94, string(int(item.pAttack) + nEnchantedPhysicalDamageBonus), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						if(TooltipType == "InventoryPet")
						{
							AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 7, nPhysicalBonus);						
						}
						else
						{
							AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 7, nPhysicalBonus, myInfo.nAddPAttack);
						}
					}
					else if(item.pAttack != 0)
					{
						if(item.bEquipped)
						{
							if(TooltipType == "InventoryPet")
							{
								AddTooltipItemOption(94, cutZeroDecimalFloat(item.pAttack + enchantData.EnchantValue[2] + float(GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, PetInfo.nLevel))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							}
							else
							{
								AddTooltipItemOption(94, cutZeroDecimalFloat(item.pAttack + enchantData.EnchantValue[2] + float(GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, myInfo.nLevel)) + float(myInfo.nAddPAttack)), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							}
						}
						else
						{
							AddTooltipItemOption(94, string(int(item.pAttack) + nEnchantedPhysicalDamageBonus), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						if(TooltipType == "InventoryPet")
						{
							AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 7, nPhysicalBonus);
						}
						else
						{
							AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 7, nPhysicalBonus, myInfo.nAddPAttack);
						}
					}

					if(enchantData.PropertyValue[3] != 0)
					{
						if(item.bEquipped)
						{
							if(TooltipType == "InventoryPet")
							{
								AddTooltipItemOption(98, cutZeroDecimalFloat(item.mAttack + enchantData.EnchantValue[3] + float(GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, PetInfo.nLevel)) + enchantData.PropertyValue[3]), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							}
							else
							{
								AddTooltipItemOption(98, cutZeroDecimalFloat(item.mAttack + enchantData.EnchantValue[3] + float(GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, myInfo.nLevel)) + enchantData.PropertyValue[3] + float(myInfo.nAddMAttack)), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							}
						}
						else
						{
							AddTooltipItemOption(98, string(int(item.mAttack + enchantData.PropertyValue[3] + float(nEnchantedMagicalDamageBonus))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						if(TooltipType == "InventoryPet")
						{
							AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 7, nMagicaBonus);
						}
						else
						{
							AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 7, nMagicaBonus, myInfo.nAddMAttack);
						}
					}
					else if(item.mAttack != 0)
					{
						if(item.bEquipped)
						{
							if(TooltipType == "InventoryPet")
							{
								AddTooltipItemOption(98, cutZeroDecimalFloat(item.mAttack + enchantData.EnchantValue[3] + float(GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, PetInfo.nLevel))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
								AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 7, nMagicaBonus);
							}
							else
							{
								AddTooltipItemOption(98, cutZeroDecimalFloat(item.mAttack + enchantData.EnchantValue[3] + float(GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, myInfo.nLevel)) + float(myInfo.nAddMAttack)), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
								AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 7, nMagicaBonus, myInfo.nAddMAttack);
							}
						}
						else
						{
							if(TooltipType == "InventoryPet")
							{
								AddTooltipItemOption(98, string(int(item.mAttack + enchantData.PropertyValue[3] + float(nEnchantedMagicalDamageBonus))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
								AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 7, nMagicaBonus);
							}
							else
							{
								AddTooltipItemOption(98, string(int(item.mAttack + enchantData.PropertyValue[3] + float(nEnchantedMagicalDamageBonus))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
								AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 7, nMagicaBonus, myInfo.nAddMAttack);
							}
						}
					}
					AddTooltipItemOption(111, GetAttackSpeedString(int(item.pAttackSpeed)), true, true, false);
					if(item.pDefense > 0)
					{
						AddTooltipItemOption(54, string(item.pDefense), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
					}
					if(item.mDefense > 0)
					{
						AddTooltipItemOption(99, string(item.mDefense), true, true, false);
					}
					if(item.pHitRate + enchantData.PropertyValue[7] != 0)
					{
						AddTooltipItemOption(96, string(item.pHitRate + enchantData.PropertyValue[7]), true, true, false);
					}
					if(item.pCriRate + enchantData.PropertyValue[9] > 0)
					{
						AddTooltipItemOption(113, string(item.pCriRate + enchantData.PropertyValue[9]), true, true, false);
					}
					if(item.MoveSpeed + enchantData.PropertyValue[11] != 0)
					{
						AddTooltipItemOption(432, string(item.MoveSpeed + enchantData.PropertyValue[11]), true, true, false);
					}
					if(item.ShieldDefense > 0)
					{
						AddTooltipItemOption(95, string(item.ShieldDefense), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
					}
					if(item.ShieldDefenseRate > 0)
					{
						AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
					}
					if(item.pAvoid + enchantData.PropertyValue[14] > 0)
					{
						AddTooltipItemOption(2361, string(item.pAvoid + enchantData.PropertyValue[14]), true, true, false);
					}
					if(item.mAvoid + enchantData.PropertyValue[15] > 0)
					{
						AddTooltipItemOption(2364, string(item.mAvoid + enchantData.PropertyValue[15]), true, true, false);
					}
					if(item.mAttackSpeed + enchantData.PropertyValue[5] > 0)
					{
						AddTooltipItemOption(112, string(item.mAttackSpeed + enchantData.PropertyValue[5]), true, true, false);
					}
					bMagicWeapon = class'UIDATA_ITEM'.static.IsMagicWeapon(item.Id);
					if(item.SoulshotCount > 0)
					{
						AddTooltipItemOption(404, "X" $ string(item.SoulshotCount), true, true, false);
					}
					if(item.SpiritshotCount > 0)
					{
						AddTooltipItemOption(496, "X" $ string(item.SpiritshotCount), true, true, false);
					}
					if(item.SoulshotCount > 0 || item.SpiritshotCount > 0)
					{
						fSoulShotPower = GetSoulShotPower(item.CrystalType, item.Enchanted, item.WeaponType, bMagicWeapon);
						fSpiritShotPower = GetSpiritShotPower(item.CrystalType, item.Enchanted, item.WeaponType, bMagicWeapon);
						if(fSoulShotPower == fSpiritShotPower)
						{
							if(fSoulShotPower > 0)
							{
								AddTooltipItemBlank(6);
								AddTooltipColorText(GetSystemMessage(4297) $ " : ", GetColor(163, 163, 163, 255), true, true);
								AddTooltipColorText("+" $ string(fSoulShotPower) $ "%", GetColor(238, 170, 34, 255), false, true);
							}
						}
						else
						{
							AddTooltipItemBlank(6);
							AddTooltipColorText(GetSystemMessage(4297) $ " : ", GetColor(163, 163, 163, 255), true, true);
							AddTooltipColorText("+" $ string(fSoulShotPower) $ "%" $ ", " $ string(fSpiritShotPower) $ "%", GetColor(238, 170, 34, 255), false, true);
						}
					}
					if(item.Weight == 0)
					{
						AddTooltipItemOption(52, " 0 ", true, true, false);
					}
					else
					{
						AddTooltipItemOption(52, string(item.Weight), true, true, false);
					}
					if(item.MpConsume != 0)
					{
						AddTooltipItemOption(320, string(item.MpConsume), true, true, false);
					}
					break;
				case ITEM_ARMOR:
					if(item.SlotBitType == 256 && item.ArmorType == 4)
					{
						if(item.pDefense != 0)
						{
							AddTooltipItemOption(95, cutZeroDecimalFloat(item.pDefense + enchantData.EnchantValue[0]), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 7);
						}
						if(enchantData.PropertyValue[14] != 0)
						{
							AddTooltipItemOption(2361, string(item.pAvoid + enchantData.PropertyValue[14]), true, true, false);
						}
						else if(item.pAvoid != 0)
						{
							AddTooltipItemOption(2361, string(item.pAvoid), true, true, false);
						}
						if(item.pAttack + enchantData.PropertyValue[2] > 0)
						{
							AddTooltipItemOption(94, string(item.pAttack + enchantData.PropertyValue[2]), true, true, false);
						}
						if(item.mAttack + enchantData.PropertyValue[3] > 0)
						{
							AddTooltipItemOption(98, string(item.mAttack + enchantData.PropertyValue[3]), true, true, false);
						}
						if(item.mAttackSpeed + enchantData.PropertyValue[5] > 0)
						{
							AddTooltipItemOption(112, string(item.mAttackSpeed + enchantData.PropertyValue[5]), true, true, false);
						}
						if(item.pHitRate + enchantData.PropertyValue[7] > 0)
						{
							AddTooltipItemOption(2360, string(item.pHitRate + enchantData.PropertyValue[7]), true, true, false);
						}
						if(item.mHitRate + enchantData.PropertyValue[8] > 0)
						{
							AddTooltipItemOption(2363, string(item.mHitRate + enchantData.PropertyValue[8]), true, true, false);
						}
						if(item.pCriRate + enchantData.PropertyValue[9] > 0)
						{
							AddTooltipItemOption(2362, string(item.pCriRate + enchantData.PropertyValue[9]), true, true, false);
						}
						if(item.mCriRate + enchantData.PropertyValue[10] > 0)
						{
							AddTooltipItemOption(2365, string(item.mCriRate + enchantData.PropertyValue[10]), true, true, false);
						}
						if(item.MoveSpeed + enchantData.PropertyValue[11] != 0)
						{
							AddTooltipItemOption(432, string(item.MoveSpeed + enchantData.PropertyValue[11]), true, true, false);
						}
						if(item.ShieldDefense > 0)
						{
							AddTooltipItemOption(95, string(item.ShieldDefense), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						if(item.ShieldDefenseRate > 0)
						{
							AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
						}
						if(item.pAvoid + enchantData.PropertyValue[14] > 0)
						{
							AddTooltipItemOption(2361, string(item.pAvoid + enchantData.PropertyValue[14]), true, true, false);
						}
						if(item.mAvoid + enchantData.PropertyValue[15] > 0)
						{
							AddTooltipItemOption(2364, string(item.mAvoid + enchantData.PropertyValue[15]), true, true, false);
						}
						if(item.mDefense > 0)
						{
							AddTooltipItemOption(99, string(int(item.mDefense)), true, true, false);
						}
						if(item.Weight != 0)
						{
							AddTooltipItemOption(52, string(item.Weight), true, true, false);
						}
					}
					else
					{
						if(item.SlotBitType == 256 || item.SlotBitType == 128)
						{
							if(item.ShieldDefense != 0)
							{
								AddTooltipItemOption(13206, cutZeroDecimalFloat(item.ShieldDefense + enchantData.EnchantValue[12]), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
								AddTooltipItemBonus(int(item.ShieldDefense), nEnchantedShieldDefenseBonus, 0, 7);
							}
							if(enchantData.PropertyValue[14] != 0)
							{
								AddTooltipItemOption(2361, string(item.pAvoid + enchantData.PropertyValue[14]), true, true, false);
							}
							else if(item.pAvoid != 0)
							{
								AddTooltipItemOption(2361, string(item.pAvoid), true, true, false);
							}
							if(item.pDefense > 0)
							{
								AddTooltipItemOption(54, string(item.pDefense), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							}
							if(item.mDefense > 0)
							{
								AddTooltipItemOption(99, string(int(item.mDefense)), true, true, false);
							}
							if(item.pAttack + enchantData.PropertyValue[2] > 0)
							{
								AddTooltipItemOption(94, string(item.pAttack + enchantData.PropertyValue[2]), true, true, false);
							}
							if(item.mAttack + enchantData.PropertyValue[3] > 0)
							{
								AddTooltipItemOption(98, string(item.mAttack + enchantData.PropertyValue[3]), true, true, false);
							}
							if(item.mAttackSpeed + enchantData.PropertyValue[5] > 0)
							{
								AddTooltipItemOption(112, string(item.mAttackSpeed + enchantData.PropertyValue[5]), true, true, false);
							}
							if(item.pHitRate + enchantData.PropertyValue[7] > 0)
							{
								AddTooltipItemOption(2360, string(item.pHitRate + enchantData.PropertyValue[7]), true, true, false);
							}
							if(item.mHitRate + enchantData.PropertyValue[8] > 0)
							{
								AddTooltipItemOption(2363, string(item.mHitRate + enchantData.PropertyValue[8]), true, true, false);
							}
							if(item.pCriRate + enchantData.PropertyValue[9] > 0)
							{
								AddTooltipItemOption(2362, string(item.pCriRate + enchantData.PropertyValue[9]), true, true, false);
							}
							if(item.mCriRate + enchantData.PropertyValue[10] > 0)
							{
								AddTooltipItemOption(2365, string(item.mCriRate + enchantData.PropertyValue[10]), true, true, false);
							}
							if(item.MoveSpeed + enchantData.PropertyValue[11] != 0)
							{
								AddTooltipItemOption(432, string(item.MoveSpeed + enchantData.PropertyValue[11]), true, true, false);
							}
							if(item.ShieldDefenseRate > 0)
							{
								AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
							}
							if(item.pAvoid + enchantData.PropertyValue[14] > 0)
							{
								AddTooltipItemOption(2361, string(item.pAvoid + enchantData.PropertyValue[14]), true, true, false);
							}
							if(item.mAvoid + enchantData.PropertyValue[15] > 0)
							{
								AddTooltipItemOption(2364, string(item.mAvoid + enchantData.PropertyValue[15]), true, true, false);
							}
							if(item.Weight != 0)
							{
								AddTooltipItemOption(52, string(item.Weight), true, true, false);
							}
						}
						else
						{
							if(IsMagicalArmor(item.Id))
							{
								if(item.MpBonus > 0)
								{
									AddTooltipItemOption(388, string(item.MpBonus), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
								}
								if(item.SlotBitType == 65536 || item.SlotBitType == 524288 || item.SlotBitType == 262144)
								{
									if(item.pDefense + enchantData.EnchantValue[0] != 0)
									{
										AddTooltipItemOption(95, cutZeroDecimalFloat(item.pDefense + enchantData.EnchantValue[0]), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
										AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 7);
									}
								}
								else
								{
									if(item.pDefense != 0)
									{
										AddTooltipItemOption(95, cutZeroDecimalFloat(item.pDefense + enchantData.EnchantValue[0]), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
										AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 7);
									}
									if(item.mDefense > 0)
									{
										AddTooltipItemOption(99, string(int(item.mDefense)), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
									}
									if(item.pAttack + enchantData.PropertyValue[2] > 0)
									{
										AddTooltipItemOption(94, string(item.pAttack + enchantData.PropertyValue[2]), true, true, false);
									}
									if(item.mAttack + enchantData.PropertyValue[3] > 0)
									{
										AddTooltipItemOption(98, string(item.mAttack + enchantData.PropertyValue[3]), true, true, false);
									}
									if(item.mAttackSpeed + enchantData.PropertyValue[5] > 0)
									{
										AddTooltipItemOption(112, string(item.mAttackSpeed + enchantData.PropertyValue[5]), true, true, false);
									}
									if(item.pHitRate + enchantData.PropertyValue[7] > 0)
									{
										AddTooltipItemOption(2360, string(item.pHitRate + enchantData.PropertyValue[7]), true, true, false);
									}
									if(item.mHitRate + enchantData.PropertyValue[8] > 0)
									{
										AddTooltipItemOption(2363, string(item.mHitRate + enchantData.PropertyValue[8]), true, true, false);
									}
									if(item.pCriRate + enchantData.PropertyValue[9] > 0)
									{
										AddTooltipItemOption(2362, string(item.pCriRate + enchantData.PropertyValue[9]), true, true, false);
									}
									if(item.mCriRate + enchantData.PropertyValue[10] > 0)
									{
										AddTooltipItemOption(2365, string(item.mCriRate + enchantData.PropertyValue[10]), true, true, false);
									}
									if(item.MoveSpeed + enchantData.PropertyValue[11] != 0)
									{
										AddTooltipItemOption(432, string(item.MoveSpeed + enchantData.PropertyValue[11]), true, true, false);
									}
									if(item.ShieldDefenseRate > 0)
									{
										AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
									}
									if(item.pAvoid + enchantData.PropertyValue[14] > 0)
									{
										AddTooltipItemOption(2361, string(item.pAvoid + enchantData.PropertyValue[14]), true, true, false);
									}
									if(item.mAvoid + enchantData.PropertyValue[15] > 0)
									{
										AddTooltipItemOption(2364, string(item.mAvoid + enchantData.PropertyValue[15]), true, true, false);
									}
									if(item.ShieldDefense > 0)
									{
										AddTooltipItemOption(95, string(item.ShieldDefense), true, true, false);
									}
									if(item.ShieldDefenseRate > 0)
									{
										AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
									}
								}
								if(item.Weight != 0)
								{
									AddTooltipItemOption(52, string(item.Weight), true, true, false);
								}
							}
							else
							{
								if(item.SlotBitType == 65536 || item.SlotBitType == 524288 || item.SlotBitType == 262144)
								{
									if(item.pDefense + enchantData.EnchantValue[0] != 0)
									{
										AddTooltipItemOption(95, cutZeroDecimalFloat(item.pDefense + enchantData.EnchantValue[0]), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
										AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 7);
									}
								}
								else
								{
									if(item.pDefense != 0)
									{
										AddTooltipItemOption(95, cutZeroDecimalFloat(item.pDefense + enchantData.EnchantValue[0]), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
										AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 7);
									}
									if(item.mDefense > 0)
									{
										AddTooltipItemOption(99, string(int(item.mDefense)), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
									}
									if(item.pAttack + enchantData.PropertyValue[2] > 0)
									{
										AddTooltipItemOption(94, string(item.pAttack + enchantData.PropertyValue[2]), true, true, false);
									}
									if(item.mAttack + enchantData.PropertyValue[3] > 0)
									{
										AddTooltipItemOption(98, string(item.mAttack + enchantData.PropertyValue[3]), true, true, false);
									}
									if(item.mAttackSpeed + enchantData.PropertyValue[5] > 0)
									{
										AddTooltipItemOption(112, string(item.mAttackSpeed + enchantData.PropertyValue[5]), true, true, false);
									}
									if(item.pHitRate + enchantData.PropertyValue[7] > 0)
									{
										AddTooltipItemOption(2360, string(item.pHitRate + enchantData.PropertyValue[7]), true, true, false);
									}
									if(item.mHitRate + enchantData.PropertyValue[8] > 0)
									{
										AddTooltipItemOption(2363, string(item.mHitRate + enchantData.PropertyValue[8]), true, true, false);
									}
									if(item.pCriRate + enchantData.PropertyValue[9] > 0)
									{
										AddTooltipItemOption(2362, string(item.pCriRate + enchantData.PropertyValue[9]), true, true, false);
									}
									if(item.mCriRate + enchantData.PropertyValue[10] > 0)
									{
										AddTooltipItemOption(2365, string(item.mCriRate + enchantData.PropertyValue[10]), true, true, false);
									}
									if(item.MoveSpeed + enchantData.PropertyValue[11] != 0)
									{
										AddTooltipItemOption(432, string(item.MoveSpeed + enchantData.PropertyValue[11]), true, true, false);
									}
									if(item.ShieldDefenseRate > 0)
									{
										AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
									}
									if(item.pAvoid + enchantData.PropertyValue[14] > 0)
									{
										AddTooltipItemOption(2361, string(item.pAvoid + enchantData.PropertyValue[14]), true, true, false);
									}
									if(item.mAvoid + enchantData.PropertyValue[15] > 0)
									{
										AddTooltipItemOption(2364, string(item.mAvoid + enchantData.PropertyValue[15]), true, true, false);
									}
									if(item.ShieldDefense > 0)
									{
										AddTooltipItemOption(95, string(item.ShieldDefense), true, true, false);
									}
									if(item.ShieldDefenseRate > 0)
									{
										AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
									}
								}
								if(item.Weight != 0)
								{
									AddTooltipItemOption(52, string(item.Weight), true, true, false);
								}
							}
						}
					}
					break;
				case ITEM_ACCESSARY:
					if(item.SlotBitType == int64("206158430208"))
					{
						AddAgathionSkillTooltip(item);
					}
					if(getInstanceUIData().getIsClassicServer())
					{
						if(item.SlotBitType != 536870912 && item.SlotBitType != 1073741824 && item.SlotBitType != 1048576 && item.SlotBitType != 2097152 && ! IsArtifactRuneItem(item))
						{
							Debug("Item.mDefense" @ string(item.mDefense));
							Debug("enchantData.EnchantValue[ValidateEnum.MDEFEND]" @ string(enchantData.EnchantValue[1]));
							if(item.mDefense + enchantData.EnchantValue[1] > 0)
							{
								AddTooltipItemOption(99, cutZeroDecimalFloat(item.mDefense + enchantData.EnchantValue[1]), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							}
							AddTooltipItemBonus(int(item.mDefense), nEnchantedMagicalDefenseBonus, 0, 7);
						}
					}
					else
					{
						if(item.SlotBitType != 1073741824 && item.SlotBitType != 4194304 && item.SlotBitType != 1048576 && item.SlotBitType != 2097152 && ! IsArtifactRuneItem(item))
						{
							if(item.mDefense + enchantData.EnchantValue[1] > 0)
							{
								AddTooltipItemOption(99, cutZeroDecimalFloat(item.mDefense + enchantData.EnchantValue[1]), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							}
							AddTooltipItemBonus(int(item.mDefense), nEnchantedMagicalDefenseBonus, 0, 7);
						}
					}
					if(item.Weight == 0)
					{
						AddTooltipItemOption(52, " 0 ", true, true, false);
					}
					else
					{
						AddTooltipItemOption(52, string(item.Weight), true, true, false);
					}
					break;
				case ITEM_QUESTITEM:
					break;
				case ITEM_ETCITEM:
					if(EEtcItemType == ITEME_CARD_EVENT)
					{
						CardEventImgTooltip(item, "inventory");
					}
					else if(EEtcItemType == ITEME_PET_COLLAR)
					{
						if(getInstanceUIData().getIsLiveServer())
						{
							if(item.Damaged == 0)
							{
								nTmp = 971;
							}
							else
							{
								nTmp = 970;
							}
							AddTooltipItemOption2(969, nTmp, true, true, false);
							AddTooltipItemOption(88, string(item.Enchanted), true, true, false);
						}
						else
						{
							if(item.PetEvolveStep <= 0)
							{
								AddTooltipItemOption2(969, 971, true, true, false);
							}
							else
							{
								class'PetAPI'.static.GetPetEvolveNameInfo(item.PetNameID, PetNameInfo);
								petNameStr = PetNameInfo.Name;
								class'PetAPI'.static.GetPetEvolveNameInfo(item.PetNamePrefixID, PetNameInfo);
								petNameStr = PetNameInfo.Name @ petNameStr;
								AddTooltipItemOption(969, petNameStr, true, true, false);
							}
							AddTooltipItemOption(88, string(item.Enchanted), true, true, false);
							if(item.PetEvolveStep == 0)
							{
								AddTooltipItemOption(3792, GetSystemString(13334), true, true, false);
							}
							else
							{
								AddTooltipItemOption(3792, MakeFullSystemMsg(GetSystemMessage(13198), string(item.PetEvolveStep)), true, true, false);
							}
						}
					}
					else if(EEtcItemType == ITEME_TICKET_OF_LORD)
					{
						AddTooltipItemOption(972, string(item.Enchanted), true, true, false);
					}
					else if(EEtcItemType == ITEME_LOTTO)
					{
						AddTooltipItemOption(670, string(item.Blessed), true, true, false);
						AddTooltipItemOption(671, GetLottoString(item.LookChangeItemID), true, true, false);
					}
					else if(EEtcItemType == ITEME_RACE_TICKET)
					{
						AddTooltipItemOption(670, string(item.Enchanted), true, true, false);
						AddTooltipItemOption(671, GetRaceTicketString(item.Blessed), true, true, false);
						AddTooltipItemOption(744, string(item.Damaged * 100), true, true, false);
					}
					else if(item.MaxUseCount > 0)
					{
						AddCrossLine();
						AddTooltipItemBlank(0);
						if(IsAdenServer())
						{
							if(item.MaxReuseDelay != 0)
							{
								addTexture("l2ui_ct1.SkillWnd_DF_ListIcon_use", 12, 11, 12, 11, 3, 7);
								AddTooltipColorText(GetSystemString(2378) $ " : ", GetColor(163, 163, 163, 255), false, true, false, "", 0, 6);
								StartItem();
								m_Info.eType = DIT_TEXT;
								m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
								m_Info.bLineBreak = false;
								m_Info.t_bDrawOneLine = true;
								m_Info.t_color = GetColor(176, 155, 121, 255);
								if(item.MaxReuseDelay < 0)
								{
									m_Info.t_strText = GetSystemString(3804);
								}
								else if(item.RemainReuseDelay == 0)
								{
									m_Info.t_strText = GetSystemString(3537);
								}
								else
								{
									m_Info.t_strText = MakeTimeStr(int(item.RemainReuseDelay));
									ParamAdd(m_Info.Condition, "Type", "ReuseDelay");
								}
								EndItem();
							}
							AddTooltipItemBlank(0);
							addTexture("L2UI_EPIC.ToolTip.use_count_caution", 12, 11, 12, 11, 3, 7);
							AddTooltipColorText(GetSystemString(3802) $ " : ", GetColor(163, 163, 163, 255), false, true, false, "", 0, 6);
							AddTooltipColorText(string(item.MaxUseCount - item.CurUseCount) $ "/" $ string(item.MaxUseCount), GetColor(176, 155, 121, 255), false, true, false, "", 0, 6);
							AddTooltipColorText("  (" $ GetSystemString(3803) $ ")", GetColor(238, 170, 34, 255), true, true);
							AddCrossLine();
							AddTooltipItemBlank(0);
						}
						else
						{
							AddTooltipText("<" $ GetSystemString(3801) $ ">", true, true);
							AddTooltipItemBlank(0);
							addTexture("l2ui_ct1.SkillWnd_DF_ListIcon_use", 12, 11, 12, 11, 3, 7);
							AddTooltipColorText(GetSystemString(2378) $ " : ", GetColor(163, 163, 163, 255), false, true, false, "", 0, 6);
							StartItem();
							m_Info.eType = DIT_TEXT;
							m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
							m_Info.bLineBreak = false;
							m_Info.t_bDrawOneLine = true;
							m_Info.t_color = GetColor(176, 155, 121, 255);
							if(item.MaxReuseDelay < 0)
							{
								m_Info.t_strText = GetSystemString(3804);
							}
							else if(item.RemainReuseDelay == 0)
							{
								m_Info.t_strText = GetSystemString(3537);													
							}
							else
							{
								m_Info.t_strText = MakeTimeStr(int(item.RemainReuseDelay));
								ParamAdd(m_Info.Condition, "Type", "ReuseDelay");
							}
							EndItem();
							AddTooltipItemBlank(0);
							addTexture("l2ui_ct1.Icon.Tooltip_CubeIcon", 12, 11, 12, 11, 3, 7);
							AddTooltipColorText(GetSystemString(3802) $ " : ", GetColor(163, 163, 163, 255), false, true, false, "", 0, 6);
							AddTooltipColorText(string(item.MaxUseCount - item.CurUseCount) $ "/" $ string(item.MaxUseCount), GetColor(176, 155, 121, 255), false, true, false, "", 0, 6);
							AddTooltipColorText("  (" $ GetSystemString(3803) $ ")", GetColor(238, 170, 34, 255), true, true);
							AddCrossLine();
							AddTooltipItemBlank(0);
						}
					}

					if(EEtcItemType != ITEME_CARD_EVENT)
					{
						if(item.Weight == 0)
						{
							AddTooltipItemOption(52, " 0 ", true, true, false);						
						}
						else
						{
							AddTooltipItemOption(52, string(item.Weight), true, true, false);
						}
					}
					break;
			}
			
			// End:0x3C65
			if(isSImpleTooltipNoSelect(nUseSimpleTooltip, nIsSelectMode))
			{
				AddItemDesc(item);
				AddTooltipCreateInfos(item.IsCreateItem);
				AddTooltipItemCurrentPeriod(item);
				AddAutomaticUseItem(item);
				AddTooltipItemDurability(item);
				AddTooltipItemQuestList(item);
				AddTooltipItemWeaponLookChange(item);
				AddTooltipRefinery(item);
				AddSimpleSetitem(item);
			}
			else
			{
				AddItemDesc(item);
				AddTooltipCreateInfos(item.IsCreateItem);
				AddTooltipItemCurrentPeriod(item);
				AddAutomaticUseItem(item);
				AddTooltipItemDurability(item);
				AddTooltipItemQuestList(item);
				AddTooltipBR_MaxEnergy(item);
				AddTooltipRefinery(item);
				AddSetitemTooltip(item);
				AddTooltipItemLevelUpBonus(item, TooltipType);
				AddEnchantEffectDescTooltip(item);
				AddTooltipEventSeventhdayOfSeventhMonth(item);
				AddEnsoulOption(item);
				if(TooltipType != "InventoryPet")
				{
					AddTooltipItemAttributeGage(item);
				}
				AddBlessed(item);
				AddCollectionItem(item);
				AddHeroBookItem(item);
				AddSecurityLock(item);
				AddTooltipItemWeaponLookChange(item);
				if(TooltipType == "InventoryPawnViewer")
				{
					AddTooltipText("ID : " $ string(item.Id.ClassID), true, true);
				}
			}
		//}
	}
	else
	{
		return;
	}
	
	if(! IsAdena(item.Id))
	{
		addForbidItemDesc(item);
		AddDeleteDBData(item);
		if(item.tooltipBGDecoTexture != "")
		{
			m_Tooltip.MinimumWidth = 300;
		}
		else
		{
			switch(EItemType)
			{
				case ITEM_WEAPON:
				case ITEM_ARMOR:
				case ITEM_ACCESSARY:
					m_Tooltip.MinimumWidth = 230;
					break;
				default:
					if(item.CurrentPeriod > 0)
					{
						setMakeTimeStrMaxWidth();
					}
					else if(item.nDBDeleteDate > 0)
					{
						m_Tooltip.MinimumWidth = 230;
					}
					else
					{
						m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
					}
					break;
			}
		}
	}
	if(IsBuilderPC())
	{
		AddCrossLine();
		AddTooltipColorText("Client ID:" @ item.ID.ClassID, getColor(255,215,0,255), true, false);
		AddTooltipColorText("Icon:" @ item.IconName, getColor(255,215,0,255), true, false);
	}	
	ReturnTooltipInfo(m_Tooltip);
}
 
//----------------------------------------------------------------------------------------------------------------------------------------------------
// ?î–ë–ï–©–ì—á—ó–? ?ó¬?¬∞?? ¬µ?? ?ó–§—ò—Ü¬µ–? ?ë—??ê–?
//----------------------------------------------------------------------------------------------------------------------------------------------------
function GetItemDescriptionAdditionData(ItemID itemclassid, int enchantNum, out string forbidItemDesc, out string enableItemDesc)
{
	local ItemInfo ItemData;
	local string EtcStr;
	local string EmptyStr;
	local bool bIsChange;
	local KeepSelectInfo keepInfo;
	local EKeepType keepSelectNum;

	EtcStr = "/";
	EmptyStr = " ";
	bIsChange = false;

	class'UIDATA_ITEM'.static.GetItemInfo(itemclassid, ItemData);

	if(GetLanguage() == LANG_Russia || GetLanguage() == LANG_English || GetLanguage() == LANG_Euro) // ?ë—? ?ì–?¬∞?? ?ó–? ?ñ–Ñ¬∂—É–ê–¶–ê—ë—ë–? ?ó¬©¬±–≤—ó–é“ë–©¬∞–?.....
		bIsChange = true;

	//if(!getInstanceUIData().getIsLiveServer())
		//ItemData.bIsAuctionAble = true; // ?ñ–ó—ë–ï“ë–ª–ó–∞–ê–? ?ï—à“ë–? ?ò¬??Ññ?Ü“ë–? true ?ì—ñ—ë¬??ó–ü—ó¬? ?ñ–ª–ì–≤–Ö–ì–ï¬∞–ë—Ü—ï–ö“ë–í“ë–?.

	if(bIsChange && ItemData.bIsNpcTradeAble && ItemData.bIsAuctionAble && ItemData.bIsPrivateType &&
		ItemData.bIsDesturctAble && ItemData.bIsDropAble && ItemData.bIsTradeAble)
	{
		bIsChange = false;
	}

	if(bIsChange)
	{
		forbidItemDesc = forbidItemDesc $ GetSystemString(3342); //?ê–ú—ó–? ?î–¢¬∞–?.
		forbidItemDesc = forbidItemDesc $ EmptyStr;
	}

	if(ItemData.bIsTradeAble == false)
	{
		//branch EP1.0 2014-7-29 luciper3 - ¬∑?á–Ö–ì—ï–? ?ó–¥–ì¬ª–ê—ë¬∑–? ?î–á¬∞–?
		if(GetLanguage() == LANG_Russia || GetLanguage() == LANG_Euro)
			forbidItemDesc = forbidItemDesc $ GetSystemString(3336); //¬±?ñ–ò–?
		else
			forbidItemDesc = forbidItemDesc $ GetSystemString(445); //¬±?ñ–ò–?
		//end of branch

		forbidItemDesc = forbidItemDesc $ EtcStr;
	}

	if(ItemData.bIsDropAble == false)
	{
		forbidItemDesc = forbidItemDesc $ GetSystemString(3337); //¬µ–µ¬∑–£
		forbidItemDesc = forbidItemDesc $ EtcStr;
	}

	if(ItemData.bIsDesturctAble == false)
	{
		forbidItemDesc = forbidItemDesc $ GetSystemString(3338); //?ñ–î—ò–?
		forbidItemDesc = forbidItemDesc $ EtcStr;
	}

	if(ItemData.bIsPrivateType == false)
	{
		forbidItemDesc = forbidItemDesc $ GetSystemString(3339); //¬∞?ñ–ê–û¬ª—É–ë–?
		forbidItemDesc = forbidItemDesc $ EtcStr;
	}

	if(ItemData.bIsAuctionAble == false)
	{
		// End:0x2B4
		if(getInstanceUIData().getIsLiveServer())
		{
			forbidItemDesc = forbidItemDesc $ GetSystemString(3340);
			forbidItemDesc = forbidItemDesc $ EtcStr;			
		}
		else if(IsAdenServer())
		{
			forbidItemDesc = forbidItemDesc $ GetSystemString(14063);
			forbidItemDesc = forbidItemDesc $ EtcStr;
		}
	}

	if(ItemData.bIsNpcTradeAble == false)
	{
		forbidItemDesc = forbidItemDesc $ GetSystemString(3341); //¬ª?É–ë–? ?ñ–ó—ë–?
		forbidItemDesc = forbidItemDesc $ EtcStr;
	}
	// End:0x35A
	if(Len(forbidItemDesc) > 0)
	{
		// End:0x319
		if(bIsChange)
		{
			forbidItemDesc = Left(forbidItemDesc, Len(forbidItemDesc) - 1);
			forbidItemDesc = forbidItemDesc $ ".";
		}
		else
		{
			forbidItemDesc = Left(forbidItemDesc, Len(forbidItemDesc) - 1);
			forbidItemDesc = forbidItemDesc $ EmptyStr;
			forbidItemDesc = forbidItemDesc $ GetSystemString(3342); //?ê–ú—ó–? ?î–¢¬∞–?
		}
	}

	if(GetItemKeepSelectInfo(ItemClassID, keepInfo))
	{
		if(keepInfo.KeepSelectType == EKST_ENCHANT)
		{
			if(enchantNum < keepInfo.KeepEnchantCondition)
				keepSelectNum = keepInfo.KeepOption1;
			else
				keepSelectNum = keepInfo.KeepOption2;
		}
		else
			keepSelectNum = EKeepType(itemData.nKeepType);

		switch(keepSelectNum)
		{
			case EKT_INDIVIDUAL:
				enableItemDesc = enableItemDesc $ GetSystemString(3321);
				break; //¬∞?ñ–ê–? ?ì—û¬∞–? ?ê–ú—ó–? ¬∞?é“ë–?
			case EKT_PLEDGE:
				enableItemDesc = enableItemDesc $ GetSystemString(3322);
				break; //?ó—á—ë–? ?ì—û¬∞–? ?ê–ú—ó–? ¬∞?é“ë–?
			case EKT_INDIVIDUAL_PLEDGE:
				enableItemDesc = enableItemDesc $ GetSystemString(3323);
				break; //¬∞?ñ–ê–?,?ó—á—ë–? ?ì—û¬∞–? ?ê–ú—ó–? ¬∞?é“ë–?
			case EKT_CASTLE:
				enableItemDesc = enableItemDesc $ GetSystemString(3324);
				break; //?ò—? ?ì—û¬∞–? ?ê–ú—ó–? ¬∞?é“ë–?
			case EKT_INDIVIDUAL_CASTLE:
				enableItemDesc = enableItemDesc $ GetSystemString(3325);
				break; //¬∞?ñ–ê–?,?ò—? ?ì—û¬∞–? ?ê–ú—ó–? ¬∞?é“ë–?
			case EKT_PLEDGE_CASTLE:
				enableItemDesc = enableItemDesc $ GetSystemString(3326);
				break; //?ó—á—ë–?,?ò—? ?ì—û¬∞–? ?ê–ú—ó–? ¬∞?é“ë–?
			case EKT_ACCOUNTSHARE:
				enableItemDesc = enableItemDesc $ GetSystemString(3328);
				break; //¬∞–∏?ë¬? ¬∞?à–ê–? ?ï–ñ–ê–ú–ï–?
			case EKT_INDIVIDUAL_ACCOUNTSHARE:
				enableItemDesc = enableItemDesc $ GetSystemString(3329);
				break; //¬∞?ñ–ê–? ?ì—û¬∞–? ?ê–ú—ó–? ¬∞?é“ë–?, ¬∞–∏?ë¬? ¬∞?à–ê–? ?ï–ñ–ê–ú–ï–?
			case EKT_PLEDGE_ACCOUNTSHARE:
				enableItemDesc = enableItemDesc $ GetSystemString(3330);
				break; //?ó—á—ë–? ?ì—û¬∞–? ?ê–ú—ó–? ¬∞?é“ë–?, ¬∞–∏?ë¬? ¬∞?à–ê–? ?ï–ñ–ê–ú–ï–?
			case EKT_INDIVIDUAL_PLEDGE_ACCOUNTSHARE:
				enableItemDesc = enableItemDesc $ GetSystemString(3331);
				break; //¬∞?ñ–ê–?,?ó—á—ë–? ?ì—û¬∞–? ?ê–ú—ó–? ¬∞?é“ë–?, ¬∞–∏?ë¬? ¬∞?à–ê–? ?ï–ñ–ê–ú–ï–?
			case EKT_CASTLE_ACCOUNTSHARE:
				enableItemDesc = enableItemDesc $ GetSystemString(3332);
				break; //?ò—? ?ì—û¬∞–? ?ê–ú—ó–? ¬∞?é“ë–?, ¬∞–∏?ë¬? ¬∞?à–ê–? ?ï–ñ–ê–ú–ï–?
			case EKT_INDIVIDUAL_CASTLE_ACCOUNTSHARE:
				enableItemDesc = enableItemDesc $ GetSystemString(3333);
				break; //¬∞?ñ–ê–?,?ò—? ?ì—û¬∞–? ?ê–ú—ó–? ¬∞?é“ë–?, ¬∞–∏?ë¬? ¬∞?à–ê–? ?ï–ñ–ê–ú–ï–?
			case EKT_PLEDGE_CASTLE_ACCOUNTSHARE:
				enableItemDesc = enableItemDesc $ GetSystemString(3334);
				break; //?ó—á—ë–?,?ò—? ?ì—û¬∞–? ?ê–ú—ó–? ¬∞?é“ë–?, ¬∞–∏?ë¬? ¬∞?à–ê–? ?ï–ñ–ê–ú–ï–?
			case EKT_ALL_ACCOUNTSHARE:
				enableItemDesc = enableItemDesc $ GetSystemString(3335);
				break; //?ë—?¬µ–∑ ?ì—û¬∞–? ?ê–ú—ó–? ¬∞?é“ë–?, ¬∞–∏?ë¬? ¬∞?à–ê–? ?ï–ñ–ê–ú–ï–?
		}
	}
	else
	{
	}
}

// ?ï–ñ–ê–ú–ï–? ¬±–≠?ë—? ¬ª–∑?ó–?, ¬∞?é“ë–? ¬ª–∑?ó–?, ?ó“ê¬±–? 
// EP1.0 [0319] ?ì–?¬∞??
function bool addForbidItemDesc(ItemInfo Info)
{
	local string forbidItemDesc, enableItemDesc;
	local bool flag;

	flag = false;
	GetItemDescriptionAdditionData(Info.Id, Info.Enchanted, forbidItemDesc, enableItemDesc);
	if(getInstanceUIData().getIsClassicServer())
	{
		switch(Info.SlotBitType)
		{
			// End:0x55
			case 536870912:
			// End:0x5F
			case 268435456:
			// End:0x69
			case 1048576:
			// End:0x9D
			case 2097152:
				AddCrossLine();
				AddTooltipColorText(GetSystemString(14286), GetColor(158, 127, 87, 255), true, false);
				// End:0xA0
				break;
		}
	}
	//else
	//{
		if(forbidItemDesc != "" || enableItemDesc != "")
		{
			// End:0x15C
			if((m_Tooltip.DrawList[m_Tooltip.DrawList.Length - 2].u_strTexture == "L2UI_NewTex.Tooltip.TooltipLine_BasicShotBG") || m_Tooltip.DrawList[m_Tooltip.DrawList.Length - 2].u_strTexture == "L2UI_NewTex.Tooltip.TooltipLine_Unable")
			{				
			}
			else
			{
				AddTooltipItemBlank(6);
				addTooltipTextureSplitLineType("L2UI_NewTex.Tooltip.TooltipLine_Unable", 1, 5, 8, 5, 0, 0);
			}
			if(enableItemDesc != "")
			{
				AddTooltipColorText(enableItemDesc, GetColor(158, 127, 87, 255), true, false);
			}
			if(forbidItemDesc != "")
			{
				AddTooltipColorText(forbidItemDesc, GetColor(152, 83, 45, 200), true, false);
			}
			flag = true;
		}
		return flag;
	//}
}

function CardEventImgTooltip(ItemInfo item, optional string Sender)
{
	StartItem();
	m_Tooltip.SimpleLineCount = 1;
	EndItem();

	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = 242;
	m_Info.u_nTextureHeight = 344;
	m_Info.u_strTexture = item.tooltipTexutre;
	EndItem();
	
	/*______10?ë–¶—ñ–? ?ê–ú—î“ê–ñ¬? ?î¬´¬µ–?__________
	 * | 38915 | 38916 | 38917 | 38918 |
	 * ---------------------------------
	 * | 38919 | 38920 | 38921 | 38922 |
	 * ---------------------------------
	 * 
	 * * ?ï–ñ—ë–à–ï–ß–ê–ú—ï–? ?ë¬∂¬∞—?
	 * _________________________________
	 * | 38907 | 38908 | 38909 | 38910 |
	 * ---------------------------------
	 * | 38911 | 38912 | 38913 | 38914 |
	 */
	// *?ë—Ö—î–Ω–ï¬¨—ë–á–ó–ü—ë–? ¬ª?É—ò—? ?ñ–¥–ê–ú–ë—Ü¬∞–? ¬∂–±?ë–©“ë–? ?ò—ñ—ë–Ω–ê¬? ?ñ–¶—ï–æ–ë–¶¬±–? ?ê¬ß–ó–? ?ó‚Ññ?ó–??ì—ñ—ë¬?
	// End:0x145
	if(Sender == "inventory")
	{
		// End:0x145
		if(item.Id.ClassID >= 38907 && item.Id.ClassID <= 38922)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.t_bDrawOneLine = true;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 255;
			m_Info.t_color.G = 255;
			m_Info.t_color.B = 255;
			m_Info.t_color.A = 255;
			m_Info.t_strText = GetSystemString(3218);
			EndItem();
		}
	}

	ReturnTooltipInfo(m_Tooltip);
}

//?î¬´¬µ–µ–ê–ú—î“ê–ñ¬? gfx?ó–? ?ï—à–ñ–? ?ó“ê–Ö–?  ?ë¬§—ó–º¬±–? ?ì–?¬∞?? 2013.01.29
function ReturnTooltip_NTT_GFXCARD(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo item;

	if(eSourceType == NTST_ITEM)
	{
		ParamToItemInfo(param, item);
		AddTooltipItemName(item);
		CardEventImgTooltip(item);
	}
}

//¬ª–∑¬±–≤?Ññ–∂?ë—? ?ê–á–ê—? ?ï—à–ñ–? ?ë¬§—î—?
function ReturnTooltip_NTT_CHAT_USERFAKEINFO(string param, ETooltipSourceType eSourceType)
{
	// End:0x1B
	if(eSourceType == NTST_TEXT)
	{
		// End:0x2F
		if(! class'UIDATA_PLAYER'.static.IsInDethrone())
		{
			ChatUserFakeInfoTooltip(param);
		}
	}
}

function ChatUserFakeInfoTooltip(string param)
{
	local string charName;
	local int isFriend, isGM, isPledge, isAlliance, isMentoring;

	ParseString(param, "CharName", charName);
	ParseInt(param, "IsFriend", isFriend);
	ParseInt(param, "IsPledge", isPledge);
	ParseInt(param, "IsMentoring", isMentoring);
	ParseInt(param, "IsAlliance", isAlliance);
	ParseInt(param, "IsGM", isGM);
	// End:0xCA
	if(isFriend != 0)
	{
		AddTooltipItemColorOption(2273, GetSystemString(3175), 77, 255, 99, true, true, true);
	}
	else
	{
		AddTooltipItemColorOption(2273, GetSystemString(3176), 255, 66, 66, true, true, true);
	}
	// End:0x116
	if(isPledge != 0)
	{
		AddTooltipItemColorOption(314, GetSystemString(3179), 77, 255, 99, true, true, false);
	}
	else
	{
		AddTooltipItemColorOption(314, GetSystemString(3180), 255, 66, 66, true, true, false);
	}
	//?ë–∞–ï–?, ?ï¬?¬∑?é–Ö–? ?ò¬??Ññ?Ü—ó–é—ò¬??ë–? ?ñ–ª–ì–? ¬µ?ó—ë–? ?ï–ò¬µ–?.
	// End:0x179
	if(isMentoring != 0 && ! getInstanceUIData().getIsClassicServer())
	{
		AddTooltipItemColorOption(2767, GetSystemString(3177), 77, 255, 99, true, true, false);
	}
	else if(!getInstanceUIData().getIsClassicServer()) 
	{
		AddTooltipItemColorOption(2767, GetSystemString(3178), 255, 66, 66, true, true, false);
	}
	// End:0x1DA
	if(isAlliance != 0)
	{
		AddTooltipItemColorOption(490, GetSystemString(3181), 77, 255, 99, true, true, false);
	}
	else
	{
		AddTooltipItemColorOption(490, GetSystemString(3182), 255, 66, 66, true, true, false);
	}
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// Macro , 2015-10-26, ?ë–ï–ï¬©¬∑–? ¬∞?ñ–ñ–?, ?ë–ï–ï¬©¬∑–? ?î—ó—ë–∞¬µ–? ?ë—?¬µ?? ?ï—à–ñ–ë—ó–? ?î—ë–ê–ú¬µ¬µ¬∑–? ?ì–?¬∞??
function ReturnTooltip_NTT_MACRO(string param, ETooltipSourceType eSourceType, optional bool bUseUserMacro)
{
	local ItemInfo item;
	local MacroInfo MacroInfo;
	local int idx;
	local array<string> commandArray;
	local bool bCustomMacro;

	// End:0x1FC
	if(eSourceType == NTST_ITEM)
	{
		// Debug("param"  @ param);
		ParamToItemInfo(param, item);
		bCustomMacro = class'UIDATA_MACRO'.static.GetMacroInfo(item.Id, MacroInfo);
		// End:0x81
		if(MacroInfo.IconSkillId > 0)
		{
			item.IconName = class'UIDATA_SKILL'.static.GetIconName(GetItemID(MacroInfo.IconSkillId), 1, 0);
		}

		//Item.IconName = macroInfo.IconName;

		// ?ï–ñ–ê–ú–ï–? ?ï–ñ–ê–ú–î–??ê¬? ?í–ø“ë–í“ë–?.
		addItemIcon(item, "");

		m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
		// ?ê–ú—ë¬?
		AddTooltipText(item.Name, false, true, true, "gameDefault10", 5, 1);
		//?ò—ñ—ë–?
		// ?ï–ñ–ê–ú–ï–? ?ò—ñ—ë–? 
		// End:0xF3
		if(Len(item.Description) > 0)
		{
			AddTooltipColorText(item.Description, GetColor(178, 190, 207, 255), true, false);
		}

		// ?ó–ë—ë¬??ò–?
		// End:0x181
		if(item.MacroCommand != "" && ! bUseUserMacro)
		{
			StringIntoArray(item.MacroCommand, Chr(13), commandArray);

			// End:0x17E [Loop If]
			for (idx = 0; idx < commandArray.Length; idx++)
			{
				// End:0x174
				if(commandArray[idx] != "")
				{
					AddTooltipColorText(commandArray[idx], GetColor(176, 155, 121, 255), true, true);
				}
			}
		}
		// ?ê–á–ê—ä¬∞–? ?ë¬§–ê–ó–ó–? ?ë–ï–ï¬©¬∑–?
		else
		{
			// End:0x1F9
			if(bCustomMacro)
			{
				// End:0x1F9 [Loop If]
				for (idx = 0; idx < MACROCOMMAND_MAX_COUNT; idx++)
				{
					// End:0x1EF
					if(trim(MacroInfo.CommandList[idx]) != "")
					{
						// ?ñ–ö‚Ññ¬´ ¬±–∂?ï–? ?ë—Ü—ë–? .. ?ì—ñ—ë¬? (?ê–á–ê—ä¬∞–? ?ë¬§–ê–ó–ó–? ?ë–ï–ï¬©¬∑–? ?Ö—î–ñ¬??ë¬µ—ë—? ?ê—ã—ó–?)
						AddTooltipColorText(makeShortStringByPixel(MacroInfo.CommandList[idx], 300, ".."), GetColor(176, 155, 121, 255), true, true);
					}
				}
			}
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}


/////////////////////////////////////////////////////////////////////////////////
// ACTION
function ReturnTooltip_NTT_ACTION(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo item;

	// End:0x24E
	if(eSourceType == NTST_ITEM)
	{
		ParamToItemInfo(param, item);
		// End:0x77
		if(class'ActionAPI'.static.GetActionAutomaticUseType(item.Id.ClassID) > 0)
		{
			addItemIcon(item, "icon.icon_panel.autoaction_panel_01");
		}
		else
		{
			addItemIcon(item, "");
		}

		//?ï–ß—ò–? ?ê–ú—ë¬?
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_strFontName = "gameDefault10";
		m_Info.nOffSetX = 5;
		m_Info.nOffSetY = 0;
		m_Info.t_color.R = 230;
		m_Info.t_color.G = 230;
		m_Info.t_color.B = 230;
		m_Info.t_color.A = 250;
		m_Info.t_strText = item.Name;
		EndItem();
		AddTooltipItemBlank(TOOLTIP_LINE_HGAP);
		// End:0x1B9
		if(Len(item.Description) > 0)
		{
			m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			m_Info.t_bDrawOneLine = false;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = item.Description;
			EndItem();
		}
		// End:0x24B
		if(class'ActionAPI'.static.GetActionAutomaticUseType(item.Id.ClassID) > 0)
		{
			AddTooltipItemBlank(1);
			addTexture("L2UI_ct1.AutoShotItemWnd.AutoAllArrow_On", 24, 24, 32, 32, -2, 0);
			AddTooltipColorText(GetSystemString(3962), getInstanceL2Util().Green, false, false, false, "", 2, 6);
		}		
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// SKILL
function ReturnTooltip_NTT_SKILL(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local EItemParamType EItemParamType;
	local int nTmp, SkillLevel, consumeItemCount, consumeClassID;
	local SkillInfo SkillInfo;
	local string tempStr;
	local int nSkillID, nSkillLevel, nSkillSubLevel;
	local bool bUseCross1;

	// End:0xD0F
	if(eSourceType == NTST_ITEM || eSourceType == NTST_LIST)
	{
		// End:0x107
		if(eSourceType == NTST_LIST)
		{
			ParseInt(param, "nReserved1", nSkillID);
			ParseInt(param, "nReserved2", nSkillLevel);
			ParseInt(param, "nReserved3", nSkillSubLevel);
			GetSkillInfo(nSkillID, nSkillLevel, nSkillSubLevel, SkillInfo);
			item.Id.ClassID = SkillInfo.SkillID;
			item.Name = SkillInfo.SkillName;
			item.Description = SkillInfo.SkillDesc;
			item.Level = nSkillLevel;
			item.SubLevel = nSkillSubLevel;			
		}
		else
		{
			ParseItemID(param, item.Id);
			ParseString(param, "Name", item.Name);
			ParseString(param, "AdditionalName", item.AdditionalName);
			ParseString(param, "Description", item.Description);
			ParseInt(param, "Level", item.Level);
			ParseInt(param, "SubLevel", item.SubLevel);
			GetSkillInfo(item.Id.ClassID, item.Level, item.SubLevel, SkillInfo);
		}
		// End:0x1FE
		if(item.Id.ClassID == 0)
		{
			return;
		}
		item.IconName = SkillInfo.TexName;
		item.IconPanel = SkillInfo.IconPanel;
		EItemParamType = EItemParamType(item.ItemType);
		SkillLevel = item.Level;
		// End:0x259
		if(getInstanceUIData().getIsClassicServer())
		{
			m_Tooltip.MinimumWidth = 270;			
		}
		else
		{
			m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
		}
		switch(class'UIDATA_SKILL'.static.GetAutomaticUseSkillType(item.Id))
		{
			// End:0x286
			case AUST_BUFF_SKILL:
			// End:0x2B2
			case AUST_SEQUENTIAL_SKILL:
				addItemIcon(item, "Icon.autoskill_panel_01");
				// End:0x2DE
				break;
			// End:0xFFFF
			default:
				addItemIcon(item, "");
				break;
		}
		// End:0x3AE
		if(IsUseRenewalSkillWnd())
		{
			// End:0x373
			if(item.SubLevel > 0)
			{
				AddTooltipColorText("+" $ string(int(float(item.SubLevel) % 1000)), GetColor(202, 117, 255, 255), false, true, false, "gameDefault10", 5);
				AddTooltipColorText(item.Name $ " ", getInstanceL2Util().BrightWhite, false, true, false, "gameDefault10", 3);				
			}
			else
			{
				AddTooltipColorText(item.Name $ " ", getInstanceL2Util().BrightWhite, false, true, false, "gameDefault10", 5);
			}			
		}
		else
		{
			AddTooltipColorText(item.Name $ " ", getInstanceL2Util().BrightWhite, false, true, false, "gameDefault10", 5);
		}
		// End:0x46C
		if(getInstanceUIData().getIsLiveServer())
		{
			// End:0x380
			if(! SkillInfo.LevelHide)
			{
				AddTooltipColorText(GetSystemString(88), GetColor(163, 163, 163, 255), false, true, false, "chatFontSize11");
				AddTooltipColorText(" " $ string(SkillLevel), GetColor(176, 155, 121, 255), false, true, false, "chatFontSize11");
			}			
		}
		else
		{
			// End:0x3F5
			if(! SkillInfo.LevelHide)
			{
				AddTooltipColorText(GetSystemString(88), GetColor(238, 170, 34, 255), false, true, false, "chatFontSize11");
				AddTooltipColorText(" " $ string(SkillLevel), GetColor(238, 170, 34, 255), false, true, false, "chatFontSize11");
			}
		}
		// End:0x43A
		if(Len(item.AdditionalName) > 0)
		{
			AddTooltipColorText(item.AdditionalName, GetColor(255, 217, 105, 255), false, true, false, "chatFontSize11", 5);
		}
		AddTooltipItemBlank(1);
		AddTooltipColorText(getSkillTypeString(SkillInfo.IconType), GetColor(176, 155, 121, 255), true, true, false, "", 38, -17);
		// End:0x63A
		if(getInstanceUIData().getIsLiveServer())
		{
			nTmp = class'UIDATA_SKILL'.static.GetHpConsume(item.Id, item.Level, item.SubLevel);
			// End:0x4D7
			if(nTmp > 0)
			{
				AddTooltipItemOption(1195, string(nTmp), true, true, false);
			}
			nTmp = class'UIDATA_SKILL'.static.GetMpConsume(item.Id, item.Level, item.SubLevel);
			// End:0x55A
			if(nTmp > 0)
			{
				AddTooltipItemOption(320, string(nTmp), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
			}
			nTmp = class'UIDATA_SKILL'.static.GetCastRange(item.Id, item.Level, item.SubLevel);
			// End:0x5AD
			if(nTmp >= 0)
			{
				AddTooltipItemOption(321, string(nTmp), true, true, false);
			}
			// End:0x5FD
			if(SkillInfo.HitTime + SkillInfo.CoolTime > 0)
			{
				AddTooltipItemOption(2377, getInstanceL2Util().MakeTimeString(SkillInfo.HitTime, SkillInfo.CoolTime), true, true, false);
			}
			// End:0x637
			if(SkillInfo.ReuseDelay > 0)
			{
				AddTooltipItemOption(2378, getInstanceL2Util().MakeTimeString(SkillInfo.ReuseDelay), true, true, false);
			}			
		}
		else
		{
			nTmp = class'UIDATA_SKILL'.static.GetHpConsume(item.Id, item.Level, item.SubLevel);
			// End:0x6B7
			if(nTmp > 0)
			{
				AddTooltipItemOption(1195, string(nTmp), true, true, false, "", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
				bUseCross1 = true;
			}
			nTmp = class'UIDATA_SKILL'.static.GetMpConsume(item.Id, item.Level, item.SubLevel);
			// End:0x734
			if(nTmp > 0)
			{
				AddTooltipItemOption(320, string(nTmp), true, true, false, "", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
				bUseCross1 = true;
			}
			// End:0x788
			if(SkillInfo.DpConsume > 0)
			{
				AddTooltipItemOption(13578, string(SkillInfo.DpConsume), true, true, false, "", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
				bUseCross1 = true;
			}
			// End:0x7ED
			if(SkillInfo.EnergyConsume > 0)
			{
				AddTooltipItemOption(13579, MakeFullSystemMsg(GetSystemMessage(13396), string(SkillInfo.EnergyConsume)), true, true, false, "", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
				bUseCross1 = true;
			}
			class'UIDATA_SKILL'.static.GetMSCondItem(SkillInfo.SkillID, SkillInfo.SkillLevel, SkillInfo.SkillSubLevel, consumeClassID, consumeItemCount);
			// End:0x8A0
			if(consumeClassID > 0)
			{
				AddTooltipItemOption(13580, MakeFullSystemMsg(GetSystemMessage(1983), (class'UIDATA_ITEM'.static.GetItemName(GetItemID(consumeClassID)) $ " ") $ string(consumeItemCount)), true, true, false, "", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
				bUseCross1 = true;
			}
			// End:0x8AF
			if(bUseCross1)
			{
				AddCrossLine();
			}
			bUseCross1 = false;
			nTmp = class'UIDATA_SKILL'.static.GetCastRange(item.Id, item.Level, item.SubLevel);
			// End:0x912
			if(nTmp >= 0 && nTmp < 1300)
			{
				AddTooltipItemOption(321, string(nTmp), true, true, false);
				bUseCross1 = true;
			}
			// End:0x96C
			if(SkillInfo.HitTime + SkillInfo.CoolTime > 0)
			{
				AddTooltipItemOption(2377, getInstanceL2Util().MakeTimeString(SkillInfo.HitTime + SkillInfo.CoolTime), true, true, false);
				bUseCross1 = true;
			}
			// End:0x9B0
			if(SkillInfo.ReuseDelay > 0)
			{
				AddTooltipItemOption(2378, getInstanceL2Util().GetTimeStringBySec5(SkillInfo.ReuseDelay), true, true, false);
				bUseCross1 = true;
			}
			tempStr = getSkillTraitString(SkillInfo.TraitType);
			// End:0xA16
			if(tempStr != "")
			{
				bUseCross1 = true;
				// End:0xA03
				if(getInstanceUIData().getIsClassicServer())
				{
					AddTooltipItemOption(13636, tempStr, true, true, false);					
				}
				else
				{
					AddTooltipItemOption(13637, tempStr, true, true, false);
				}
			}
			// End:0xA56
			if(SkillInfo.AbnormalTime > 0)
			{
				bUseCross1 = true;
				AddTooltipItemOption(13582, getInstanceL2Util().GetTimeStringBySec5(SkillInfo.AbnormalTime), true, true, false);
			}
			tempStr = getSkillTargetTypeString(SkillInfo.TargetType);
			// End:0xA93
			if(tempStr != "")
			{
				bUseCross1 = true;
				AddTooltipItemOption(13584, tempStr, true, true, false);
			}
			tempStr = getSkillAffectTypeString(SkillInfo.AffectScope);
			// End:0xAD0
			if(tempStr != "")
			{
				bUseCross1 = true;
				AddTooltipItemOption(13585, tempStr, true, true, false);
			}
			tempStr = getSkillEquipNameStr(SkillInfo.SkillID, SkillInfo.SkillLevel, SkillInfo.SkillSubLevel);
			// End:0xB5D
			if(tempStr != "")
			{
				bUseCross1 = true;
				AddTooltipColorText(GetSystemString(13586) $ " : ", GetColor(163, 163, 163, 255), true, true, false, "", 0, 4);
				AddTooltipColorText(tempStr, GetColor(176, 155, 121, 255), false, false, false, "", 0, 4);
			}
		}
		// End:0xBA6
		if(Len(item.Description) > 0)
		{
			// End:0xB7E
			if(bUseCross1)
			{
				AddCrossLine();
			}
			AddTooltipItemBlank(TOOLTIP_LINE_HGAP);
			AddTooltipColorText(item.Description, GetColor(178, 190, 207, 255), true, false);
		}
		// End:0xC2E
		if(Len(item.AdditionalName) > 0)
		{
			AddCrossLine();
			AddTooltipItemBlank(TOOLTIP_LINE_HGAP);
			AddTooltipColorText(GetSystemString(3350) $ " : ", GetColor(163, 163, 163, 255), true, false);
			AddTooltipColorText(item.AdditionalName, GetColor(255, 217, 105, 255), false, true);
			AddTooltipColorText(SkillInfo.EnchantDesc, GetColor(178, 190, 207, 255), true, false);
		}
		switch(class'UIDATA_SKILL'.static.GetAutomaticUseSkillType(item.Id))
		{
			// End:0xC4E
			case AUST_BUFF_SKILL:
			// End:0xCC4
			case AUST_SEQUENTIAL_SKILL:
				AddTooltipItemBlank(1);
				addTexture("L2UI_ct1.AutoShotItemWnd.AutoAllArrow_On", 24, 24, 32, 32, -2, 0);
				AddTooltipColorText(GetSystemString(3962), getInstanceL2Util().Green, false, false, false, "", 2, 6);
				// End:0xCC7
				break;
		}
		AddDeleteDBDataByInt64(SkillInfo.DBDeleteDate);
	}
	else
	{
		return;
	}
	if(IsBuilderPC())
	{
		AddCrossLine();
		AddTooltipColorText("Client ID:" @ item.ID.ClassID, getColor(255,215,0,255), true, false);
		AddTooltipColorText("Icon:" @ item.IconName, getColor(255,215,0,255), true, false);
	}		
	
	ReturnTooltipInfo(m_Tooltip);
}

function AddDeleteDBDataByInt64(INT64 DBDeleteDate)
{
	local string dbDeleteDateStr;

	dbDeleteDateStr = class'UIDATA_ITEM'.static.GetDBDeleteDateString(DBDeleteDate);
	// End:0x1F2
	if(dbDeleteDateStr != "")
	{
		AddTooltipItemBlank(TOOLTIP_LINE_HGAP);
		addTooltipTextureSplitLineType("L2UI_NewTex.Tooltip.TooltipLine_Unable", 1, 5, 8, 5, 0, 0);
		AddTooltipItemBlank(TOOLTIP_LINE_HGAP);
		AddTooltipColorText("<" $ GetSystemString(13406) $ ">", getInstanceL2Util().Red, true, false, false, "", 0, 0);
		addTooltipTexture("L2UI_ct1.DailyMissionWnd.DailyMissionWnd_IconTime", 16, 16, 0, 0, true, true, 0, 1);
		AddTooltipColorText(dbDeleteDateStr, getInstanceL2Util().White, false, true, false, "", 0, 0);
		AddTooltipColorText(" (", getInstanceL2Util().PowderPink, false, true, false, "", 0, 0);
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.bLineBreak = false;
		m_Info.t_bDrawOneLine = true;
		m_Info.nOffSetY = 0;
		m_Info.t_color = getInstanceL2Util().PowderPink;
		m_Info.t_strText = dbDeleteDateStr;
		ParamAdd(m_Info.Condition, "Type", "DBDeleteRemainTime");
		ParamAdd(m_Info.Condition, "Value", string(DBDeleteDate));
		EndItem();
		AddTooltipColorText(")", getInstanceL2Util().PowderPink, false, true, false, "", 0, 0);
	}
}

/////////////////////////////////////////////////////////////////////////////////
// ABNORMALSTATUS
/////////////////////////////////////////////////////////////////////////////////
function ReturnTooltip_NTT_ABNORMALSTATUS(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local int ShowLevel;
	local EItemParamType EItemParamType;
	local SkillInfo SkillInfo;
	local bool IsToppingSkill;
	local array<TextSectionInfo> TextInfos;
	local string FullText, strDesc;

	// End:0x8B8
	if(eSourceType == NTST_ITEM)
	{
		ParseItemID(param, item.Id);
		ParseString(param, "Name", item.Name);
		ParseString(param, "AdditionalName", item.AdditionalName);
		ParseString(param, "Description", item.Description);
		ParseInt(param, "Level", item.Level);
		ParseInt(param, "SubLevel", item.SubLevel);
		ParseInt(param, "Reserved", item.Reserved);
		IsToppingSkill = class'UIDATA_SKILL'.static.IsToppingSkill(item.Id, item.Level, item.SubLevel);
		GetSkillInfo(item.Id.ClassID, item.Level, item.SubLevel, SkillInfo);
		EItemParamType = EItemParamType(item.ItemType);
		// End:0x178
		if(getInstanceUIData().getIsLiveServer())
		{
			m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;			
		}
		else
		{
			m_Tooltip.MinimumWidth = 270;
		}
		item.IconName = SkillInfo.TexName;
		item.IconPanel = SkillInfo.IconPanel;
		EItemParamType = EItemParamType(item.ItemType);
		addItemIcon(item, "");
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.nOffSetX = 5;
		m_Info.t_strText = item.Name;
		m_Info.t_strFontName = "gameDefault10";
		EndItem();
		ShowLevel = item.Level;
		// End:0x3AD
		if(getInstanceUIData().getIsLiveServer())
		{
			// End:0x3AA
			if(! IsToppingSkill)
			{
				// End:0x3AA
				if(! SkillInfo.LevelHide)
				{
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = " ";
					EndItem();
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_color.R = 163;
					m_Info.t_color.G = 163;
					m_Info.t_color.B = 163;
					m_Info.t_color.A = 255;
					m_Info.t_ID = 88;
					EndItem();
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_color.R = 176;
					m_Info.t_color.G = 155;
					m_Info.t_color.B = 121;
					m_Info.t_color.A = 255;
					m_Info.t_strText = " " $ ShowLevel;
					EndItem();
				}
			}
		}
		else if(! IsToppingSkill)
		{
			// End:0x3F9
			if(! SkillInfo.LevelHide)
			{
				AddTooltipColorText(" " $ GetSystemString(88) $ " " $ string(ShowLevel), GetColor(238, 170, 34, 255), false, true);
			}
		}
		// End:0x49F
		if(Len(item.AdditionalName) > 0)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetX = 5;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 255;
			m_Info.t_color.G = 217;
			m_Info.t_color.B = 105;
			m_Info.t_color.A = 255;
			m_Info.t_strText = item.AdditionalName;
			EndItem();
		}
		// End:0x71F
		if(item.Reserved >= 0)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 37;
			m_Info.nOffSetY = -15;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_ID = 1199;
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetY = -15;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_strText = " : ";
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetY = -15;
			m_Info.t_color.R = 255;
			m_Info.t_color.G = 221;
			m_Info.t_color.B = 102;
			m_Info.t_color.A = 255;
			// End:0x6DC
			if(IsToppingSkill)
			{
				m_Info.t_strText = MakeToppingBuffTimeStr(item.Reserved);
				ParamAdd(m_Info.Condition, "Type", "ToppingRemainTime");
			}
			else
			{
				m_Info.t_strText = MakeBuffTimeStr(item.Reserved);
				ParamAdd(m_Info.Condition, "Type", "RemainTime");
			}
			EndItem();
		}
		// End:0x812
		if(Len(item.Description) > 0)
		{
			GetItemTextSectionInfos(item.Description, FullText, TextInfos);
			StartItem();
			// End:0x77B
			if(TextInfos.Length > 0)
			{
				strDesc = FullText;
				m_Info.t_SectionList = TextInfos;				
			}
			else
			{
				strDesc = item.Description;
			}
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = strDesc;
			EndItem();
		}
		// End:0x892
		if(Len(item.AdditionalName) > 0)
		{
			AddCrossLine();
			AddTooltipColorText(GetSystemString(3350) $ " : ", GetColor(163, 163, 163, 255), true, false);
			AddTooltipColorText(item.AdditionalName, GetColor(255, 217, 105, 255), false, true);
			AddTooltipColorText(SkillInfo.EnchantDesc, GetColor(178, 190, 207, 255), true, false);
		}
		// End:0x8B5
		if(getInstanceUIData().getIsClassicServer())
		{
			AddDeleteDBDataByInt64(SkillInfo.DBDeleteDate);
		}
	}
	else
	{
		return;
	}
	
	if(IsBuilderPC())
	{
		AddCrossLine();
		AddTooltipColorText("Client ID:" @ item.ID.ClassID, getColor(255,215,0,255), true, false);
		AddTooltipColorText("Icon:" @ item.IconName, getColor(255,215,0,255), true, false);
	}		
	
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// LOOCKCHANGEITEM ?ó–??ó—? ?î–á¬∞–∂—ó–? ?ï—à–ñ–? 
function ReturnTooltip_NTT_LOOCKCHANGEITEM(string param)
{
	local string Name;

	ParseString(param, "Name", Name);
	StartItem();
	m_Info.eType = DIT_TEXT;
	m_Info.t_strText = Name;
	EndItem();
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// NORMALITEM
function ReturnTooltip_NTT_NORMALITEM(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local array<TextSectionInfo> TextInfos;
	local string FullText, strDesc;

	// End:0x15E
	if(eSourceType == NTST_ITEM)
	{
		ParseString(param, "Name", item.Name);
		ParseString(param, "Description", item.Description);
		ParseString(param, "AdditionalName", item.AdditionalName);
		ParseInt(param, "CrystalType", item.CrystalType);
		AddTooltipItemName(item);
		AddTooltipItemGrade(item);
		// End:0x15B
		if(Len(item.Description) > 0)
		{
			m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
			GetItemTextSectionInfos(item.Description, FullText, TextInfos);
			StartItem();
			// End:0x113
			if(TextInfos.Length > 0)
			{
				strDesc = FullText;
				m_Info.t_SectionList = TextInfos;				
			}
			else
			{
				strDesc = item.Description;
			}
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = strDesc;
			EndItem();
		}		
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

//branch121212
/////////////////////////////////////////////////////////////////////////////////
// NORMALITEM
function ReturnTooltip_NTT_PREMIUMNORMALITEM(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo item;

	// End:0x377
	if(eSourceType == NTST_ITEM)
	{
		ParseString(param, "Name", item.Name);
		ParseString(param, "Description", item.Description);
		ParseString(param, "AdditionalName", item.AdditionalName);
		ParseInt(param, "CrystalType", item.CrystalType);
		ParseInt(param, "CurrentPeriod", item.CurrentPeriod);
		AddTooltipItemName(item);
		AddTooltipItemGrade(item);
		// End:0x17F
		if(Len(item.Description) > 0)
		{
			m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = item.Description;
			EndItem();
		}
		// End:0x374
		if(item.CurrentPeriod > 0)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_ID = 1199;
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_strText = " : ";
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = "" $ MakeTimeStr(item.CurrentPeriod);
			ParamAdd(m_Info.Condition, "Type", "PeriodTime");
			EndItem();
		}		
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}


//end of branch

/////////////////////////////////////////////////////////////////////////////////
// RECIPE
function ReturnTooltip_NTT_RECIPE(string param, ETooltipSourceType eSourceType, bool bShowPrice)
{
	local ItemInfo item;
	local string strAdena, strAdenaComma;
	local Color AdenaColor;

	// End:0x2D7
	if(eSourceType == NTST_ITEM)
	{
		ParseString(param, "Name", item.Name);
		ParseString(param, "Description", item.Description);
		ParseString(param, "AdditionalName", item.AdditionalName);
		ParseInt(param, "CrystalType", item.CrystalType);
		ParseInt(param, "Weight", item.Weight);
		ParseINT64(param, "Price", item.Price);
		AddTooltipItemName(item);
		AddTooltipItemGrade(item);
		// End:0x20C
		if(bShowPrice)
		{
			strAdena = string(item.Price);
			strAdenaComma = MakeCostString(strAdena);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(641, strAdenaComma $ " ", true, true, false);
			SetTooltipItemColor(AdenaColor.R, AdenaColor.G, AdenaColor.B, 0);
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color = AdenaColor;
			m_Info.t_ID = 469;
			EndItem();
			// End:0x20C
			if(strAdena != "")
			{
				AddTooltipItemOption(0, "(" $ ConvertNumToText(strAdena) $ ")", false, true, false);
				SetTooltipItemColor(AdenaColor.R, AdenaColor.G, AdenaColor.B, 0);
			}
		}
		AddTooltipItemOption(52, string(item.Weight), true, true, false);
		// End:0x2D4
		if(Len(item.Description) > 0)
		{
			m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = item.Description;
			EndItem();
		}		
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// SHORTCUT
function ReturnTooltip_NTT_SHORTCUT(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local EItemParamType EItemParamType;
	local EShortCutItemType eShortCutType;
	local string ItemName;
	local ShortcutCommandItem commandItem;
	local int ShortcutID;
	local string strShort;
	local OptionWnd script;
	local int nIsBlessed;

	script = OptionWnd(GetScript("OptionWnd"));
	strShort = "<" $ GetSystemString(1523) $ ": ";
	// End:0xA9E
	if(eSourceType == NTST_ITEM)
	{
		ParseInt(param, "IsBlessedItem", nIsBlessed);
		item.IsBlessedItem = numToBool(nIsBlessed);
		// End:0x4E6
		if(BoolSelect)
		{
			ParseInt(param, "ShortcutType", item.ShortcutType);
			ParseString(param, "Name", item.Name);
			ParseInt(param, "RefineryOp1", item.RefineryOp1);
			ParseInt(param, "RefineryOp2", item.RefineryOp2);
			eShortCutType = EShortCutItemType(item.ShortcutType);
			ItemName = item.Name;
			switch(eShortCutType)
			{
				// End:0x155
				case SCIT_ITEM:
					ReturnTooltip_NTT_ITEM(param, "inventory", eSourceType);
					// End:0x1F9
					break;
				// End:0x15A
				case SCIT_SKILL:
				// End:0x172
				case SCIT_ATTRIBUTE:
					ReturnTooltip_NTT_SKILL(param, eSourceType);
					// End:0x1F9
					break;
				// End:0x18A
				case SCIT_ACTION:
					ReturnTooltip_NTT_ACTION(param, eSourceType);
					// End:0x1F9
					break;
				// End:0x1A3
				case SCIT_MACRO:
					ReturnTooltip_NTT_MACRO(param, eSourceType, true);
					// End:0x1F9
					break;
				// End:0x1A8
				case SCIT_RECIPE:
				// End:0x1F3
				case SCIT_BOOKMARK:
					m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = ItemName;
					EndItem();
					// End:0x1F9
					break;
			}
			ParseInt(param, "ShortcutID", ShortcutID);
			// End:0x280
			if(getInstanceUIData().getIsArenaServer())
			{
				class'ShortcutAPI'.static.GetAssignedKeyFromCommand("ArenaGamingEnterChattingShortcut", "UseShortcutItem Num=" $ string(ShortcutID), commandItem);				
			}
			else
			{
				// End:0x2E9
				if(GetChatFilterBool("Global", "EnterChatting"))
				{
					class'ShortcutAPI'.static.GetAssignedKeyFromCommand("TempStateShortcut", "UseShortcutItem Num=" $ string(ShortcutID), commandItem);					
				}
				else
				{
					class'ShortcutAPI'.static.GetAssignedKeyFromCommand("GamingStateShortcut", "UseShortcutItem Num=" $ string(ShortcutID), commandItem);
				}
			}
			// End:0x36D
			if(commandItem.subkey1 != "")
			{
				strShort = strShort $ script.GetUserReadableKeyName(commandItem.subkey1) $ "+";
			}
			// End:0x3A9
			if(commandItem.subkey2 != "")
			{
				strShort = strShort $ script.GetUserReadableKeyName(commandItem.subkey2) $ "+";
			}
			// End:0x3E5
			if(commandItem.Key != "")
			{
				strShort = strShort $ script.GetUserReadableKeyName(commandItem.Key) $ ">";
			}
			// End:0x436
			if(commandItem.subkey1 == "" && commandItem.subkey2 == "" && commandItem.Key == "")
			{
				strShort = strShort $ GetSystemString(27) $ ">";
			}
			AddTooltipItemBlank(TOOLTIP_LINE_HGAP);
			StartItem();
			m_Info.eType = DIT_SPLITLINE;
			m_Info.u_nTextureWidth = TOOLTIP_MINIMUM_WIDTH;
			m_Info.u_nTextureHeight = 1;
			m_Info.u_strTexture = "L2ui_ch3.tooltip_line";
			EndItem();
			// End:0x52B
			if(ItemName != "")
			{
				AddTooltipItemBlank(5);
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.t_color.R = 230;
				m_Info.t_color.G = 230;
				m_Info.t_color.B = 230;
				m_Info.t_color.A = 255;
				m_Info.t_strText = strShort;
				EndItem();
				AddTooltipItemBlank(1);
				ReturnTooltipInfo(m_Tooltip);
			}
			return;
		}
		else
		{
			ParseItemID(param, item.Id);
			ParseString(param, "Name", item.Name);
			ParseString(param, "AdditionalName", item.AdditionalName);
			ParseInt(param, "Level", item.Level);
			ParseInt(param, "SubLevel", item.SubLevel);
			ParseInt(param, "Reserved", item.Reserved);
			ParseInt(param, "Enchanted", item.Enchanted);
			ParseInt(param, "ItemType", item.ItemType);
			ParseInt(param, "ShortcutType", item.ShortcutType);
			ParseInt(param, "CrystalType", item.CrystalType);
			ParseInt(param, "ConsumeType", item.ConsumeType);
			ParseInt(param, "RefineryOp1", item.RefineryOp1);
			ParseInt(param, "RefineryOp2", item.RefineryOp2);
			ParseINT64(param, "ItemNum", item.ItemNum);
			ParseInt(param, "MpConsume", item.MpConsume);
			//branch
			ParseInt(param, "IsBRPremium", item.IsBRPremium);
			//end of branch

			eShortCutType = EShortCutItemType(item.ShortcutType);
			EItemParamType = EItemParamType(item.ItemType);

			ItemName = item.Name;
			switch(eShortCutType)
			{
				// End:0x759
				case SCIT_ITEM:
					AddPrimeItemSymbol(item);
					AddTooltipItemEnchant(item);
					AddTooltipItemName(item);
					AddTooltipItemGrade(item);
					AddTooltipItemCount(item);
					// End:0xA9B
					break;
				// End:0x75E
				case SCIT_SKILL:
				// End:0xA4B
				case SCIT_ATTRIBUTE:
					//?ï–ñ–ê–ú–ï–? ?ê–ú—ë¬?
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = ItemName;
					EndItem();

					//ex) " Lv "
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = " ";
					EndItem();

					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_color.R = 163;
					m_Info.t_color.G = 163;
					m_Info.t_color.B = 163;
					m_Info.t_color.A = 255;
					m_Info.t_ID = 88;
					EndItem();
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_color.R = 176;
					m_Info.t_color.G = 155;
					m_Info.t_color.B = 121;
					m_Info.t_color.A = 255;
					m_Info.t_strText = " " $ item.Level;
					EndItem();
					// End:0x97C
					if(Len(item.AdditionalName) > 0)
					{
						StartItem();
						m_Info.eType = DIT_TEXT;
						m_Info.nOffSetX = 5;
						m_Info.t_bDrawOneLine = true;
						m_Info.t_color.R = 255;
						m_Info.t_color.G = 217;
						m_Info.t_color.B = 105;
						m_Info.t_color.A = 255;
						m_Info.t_strText = item.AdditionalName;
						EndItem();
					}
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.nOffSetX = -4;
					m_Info.bLineBreak = true;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = " (";
					EndItem();
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_ID = 91;
					EndItem();
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = ":" $ item.MpConsume $ ")";
					EndItem();
					// End:0xA9B
					break;
				// End:0xA50
				case SCIT_ACTION:
				// End:0xA55
				case SCIT_MACRO:
				// End:0xA5A
				case SCIT_RECIPE:
				// End:0xA98
				case SCIT_BOOKMARK:
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = ItemName;
					EndItem();
					// End:0xA9B
					break;
			}
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// RECIPE_MANUFACTURE
function ReturnTooltip_NTT_RECIPE_MANUFACTURE(string param, ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local array<TextSectionInfo> TextInfos;
	local string FullText, strDesc;

	// End:0x220
	if(eSourceType == NTST_ITEM)
	{
		ParseString(param, "Name", item.Name);
		ParseString(param, "Description", item.Description);
		ParseString(param, "AdditionalName", item.AdditionalName);
		ParseINT64(param, "Reserved64", item.Reserved64);
		ParseInt(param, "CrystalType", item.CrystalType);
		ParseINT64(param, "ItemNum", item.ItemNum);
		m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;
		AddTooltipItemName(item);
		AddTooltipItemGrade(item);
		AddTooltipItemOption(736, string(item.Reserved64), true, true, false);
		AddTooltipItemOption(737, string(item.ItemNum), true, true, false);
		// End:0x21D
		if(Len(item.Description) > 0)
		{
			GetItemTextSectionInfos(item.Description, FullText, TextInfos);
			StartItem();
			// End:0x186
			if(TextInfos.Length > 0)
			{
				strDesc = FullText;
				m_Info.t_SectionList = TextInfos;				
			}
			else
			{
				strDesc = item.Description;
			}
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = strDesc;
			EndItem();
		}
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// FRIENDINFO
function ReturnTooltip_NTT_FRIENDINFO(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	// End:0x74
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		//ex) "?ë—á—ï—? : ?ó¬§—î–º—ë–??ê–ú–ë—?"
		AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[2].szData)), true, true, true);
		// ?ë–??ë—? ?ì–≤¬∑–? 
		//ex) "?ë–??ë—? : ?ñ–ö“ë–? ?ñ–Ñ¬ª–? ?ñ—??ê–ú—ï–?! " 
		// End:0x71
		if(Record.szReserved != "")
		{
			AddTooltipItemOption(403, Record.szReserved, true, true, true);
		}
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// PLEDGEINFO
function ReturnTooltip_NTT_CLANINFO(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	// End:0x4B
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[2].szData)), true, true, true);
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

function ReturnTooltip_NTT_AgitDecoList(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local int nUse, totalCnt, i, nItemID, Period;

	local string toolTipParam, Desc;
	local INT64 nitemCount;

	// End:0x3A0
	if(eSourceType == NTST_LIST)
	{
		m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH + 30;
		ParamToRecord(param, Record);
		// End:0x8D
		if(Record.LVDataList[0].szData == GetSystemString(869))
		{
			// ¬ª–∑?ó–? ?ï–ò–ó–ü“ë–? ?ò—ñ—ë–Ω–ê¬? ?ñ–¶“ë–í“ë–?.
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(3440), getInstanceL2Util().White, "", false));
			ReturnTooltipInfo(m_Tooltip);
			return;
		}

		toolTipParam = param;
		ParseInt(toolTipParam, "totalCnt", totalCnt);
		ParseInt(toolTipParam, "period", Period);
		ParseString(toolTipParam, "desc", Desc);
		nUse = Record.LVDataList[0].nReserved2;
		// End:0x13A
		if(nUse > 0)
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().BrightWhite, "", false, true));
		}
		else
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().White, "", false, true));
		}

		AddCrossLine();
		//desc

		// ¬±–≤?ë–?
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(3430), getInstanceL2Util().Yellow, "", true));

		// ?ò—ñ—ë–? desc 
		addToolTipDrawList(m_Tooltip, addDrawItemText(Desc, getInstanceL2Util().ColorDesc, "", true));
		AddTooltipItemBlank(10);

		// ?Ññ–∏?î–? ?î—Å—ó–?
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(3442), getInstanceL2Util().ColorYellow, "", true, true));

		// End:0x2EA [Loop If]
		for (i = 0; i < totalCnt; i++)
		{
			ParseInt(toolTipParam, "item_" $ string(i), nItemID);
			ParseINT64(toolTipParam, "count_" $ string(i), nitemCount);
			addToolTipDrawList(m_Tooltip, addDrawItemBlank(5));
			addToolTipDrawList(m_Tooltip, addDrawItemText(class'UIDATA_ITEM'.static.GetItemName(GetItemID(nItemID)), getInstanceL2Util().White, "", true, true));
			addToolTipDrawList(m_Tooltip, addDrawItemText("x" @ MakeCostString(string(nitemCount)), getInstanceL2Util().White, "", true, true));
		}
		// End:0x321
		if(totalCnt <= 0)
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(27), getInstanceL2Util().White, "", true, true));
		}
		addToolTipDrawList(m_Tooltip, addDrawItemBlank(10));
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(3431), getInstanceL2Util().ColorYellow, "", true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(MakeFullSystemMsg(GetSystemMessage(3418), string(Period)), getInstanceL2Util().White, "", true));
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// ?ë—ç–ò“? ?ó–ô—ò–? - ?ë¬??Ö—î–ñ¬? - ?ó–ô—ò–? ?ï—ë–ê–? nReserved1 ?ó–? ?ê—ä–ê–µ¬µ–ò¬∞–? ?ê–ú—ó–ª–ó–®—ò¬? ?ë¬??Ö—î–ñ¬??ê–? ?ï—à–ñ–ë–ê¬? ?î—ë—ó¬©–ë–?.
function ReturnTooltip_NTT_EnsoulOptionList(string param, ETooltipSourceType eSourceType)
{
	local EnsoulOptionUIInfo optionInfo;
	local LVDataRecord Record;
	local int optionId;

	// End:0x1ED
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		optionId = Record.LVDataList[0].nReserved2;
		// End:0x1B1
		if(optionId > 0)
		{
			GetEnsoulOptionUIInfo(optionId, optionInfo);
			addToolTipDrawList(m_Tooltip, addDrawItemTexture(optionInfo.IconPanelTex, false, false, 2));
			addToolTipDrawList(m_Tooltip, addDrawItemTexture(optionInfo.Icontex, false, false, -16));
			addToolTipDrawList(m_Tooltip, addDrawItemText("", getInstanceL2Util().White, "", false,, 4, 2));
			// End:0x11A
			if(optionInfo.OptionStep > 0)
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(MakeFullSystemMsg(GetSystemMessage(4347), optionInfo.Name, string(optionInfo.OptionStep)), getInstanceL2Util().White, "", false));
			}
			else
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(optionInfo.Name, getInstanceL2Util().White, "", false));
			}
			addToolTipDrawList(m_Tooltip, addDrawItemText(" : ", getInstanceL2Util().White, "", false));
			addToolTipDrawList(m_Tooltip, addDrawItemText(optionInfo.Desc, getInstanceL2Util().ColorDesc, "", false));
			addToolTipDrawList(m_Tooltip, addDrawItemBlank(1));
		}
		else
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().White, "", false,, 4, 2));
		}
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// ?ñ–ó—ë–? ?ë–ª–ó–? - ?ë¬??Ö—î–ñ¬? ?ï–ñ–ê–ú–ï–? ?ï—à–ñ–? 
function ReturnTooltip_NTT_SellItemList(string param, ETooltipSourceType eSourceType)
{
	// End:0x2E
	if(eSourceType == NTST_LIST)
	{
		// ?ñ–ó—ë–? ?ë¬??Ö—î–ñ¬??ó–é—ò¬? ?ê–û—î“ê–ï–¥—ë¬? ?ó—å–ï–í–ê–? ?ï—à–ñ–ë–ê¬? ?î—ë—ó¬©–ë–®“ë–?	
		ReturnTooltip_NTT_ITEM(param, "SellItemList", NTST_ITEM);		
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

function ReturnTooltip_NTT_UIControlNeedItemList(string param, ETooltipSourceType eSourceType)
{
	// End:0x13
	if(eSourceType == NTST_LIST)
	{		
	}
	else if(eSourceType == NTST_LIST_DRAWITEM)
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// PLEDGEINFO
function ReturnTooltip_NTT_CLANWARINFO(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	
	local int Width1;
	local int Width2;
	local int Height;
	local int toolTipLineCount;

	toolTipLineCount = 0;
	// End:0x329
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		GetTextSizeDefault(getWarSituationString(Record.LVDataList[2].nReserved1), Width1, Height);
		GetTextSizeDefault(GetSystemString(2968) $ Record.LVDataList[4].nReserved1, Width2, Height);
		// End:0x9A
		if(Width2 > Width1)
		{
			Width1 = Width2;
		}
		// End:0xAE
		if(TOOLTIP_MINIMUM_WIDTH > Width1)
		{
			Width1 = TOOLTIP_MINIMUM_WIDTH;
		}
		m_Tooltip.MinimumWidth = Width1;
		// ?ê—å–ê–? ?ë¬∂¬∞–ó–ê–? ?ê–¶–ê¬ª¬∂¬ß—ë—?
		// End:0x1A7
		if(Record.LVDataList[5].nReserved1 > 0)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.bLineBreak = true;
			//?ñ–Ü–ê—? ?Ö–ì¬∞–?
			m_Info.t_strText = GetSystemString(1108) $ ":" $ getSecToDateStr(Record.LVDataList[6].nReserved1, false);
			EndItem();
			toolTipLineCount++;
		
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.bLineBreak = true;
			//?ê—å–ê–? ?ë¬∂¬∞–?
			m_Info.t_strText = GetSystemString(2986) $ ":" $ Record.LVDataList[5].nReserved1 $ GetSystemString(1013);
			EndItem();
			toolTipLineCount++;
		}
		else
		{
			// 0,1,2,3,4 
			// ?ê—å–ê–? ¬ª?É–ò–? , ?ë–ï—ó–? ?ó–º—ò—?, ?ó¬??ò—? ¬∞¬∞?ê—?.. ¬∞?Ñ–ê–? ?ï—à“ë–©—ë–? ?ï—à–ñ–? ?ó“ê–ó—? ?ï–ò–ó–?
			// End:0x25A
			if(Record.LVDataList[2].nReserved1 < 5)
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.bLineBreak = true;
				m_Info.t_color.R = 220;
				m_Info.t_color.G = 220;
				m_Info.t_color.B = 220;
				m_Info.t_color.A = 255;
				m_Info.t_strText = getWarSituationString(Record.LVDataList[2].nReserved1);
				EndItem();
				toolTipLineCount++;
			}
			// End:0x319
			if(Record.LVDataList[3].nReserved1 > MSIT_RAID_POINT)
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.bLineBreak = true;
				m_Info.t_color.R = 175;
				m_Info.t_color.G = 152;
				m_Info.t_color.B = 120;
				m_Info.t_color.A = 255;
				//?ì–¶¬±–©–ë–é—ò—Ü—î–á¬µ—?:?ë–é—ò—?
				m_Info.t_strText = GetSystemString(2968) $ Record.LVDataList[4].nReserved1;
				EndItem();
				toolTipLineCount++;
			}
		}
		// ?ï—à–ñ–ë–ê¬? ?ë—ë¬µ–π–ë—? ?ï–ö—ï–¢“ë–©—ë–?.. ?ñ–Ñ—ó–ê–ë—? ?ï–ö“ë–í“ë–?
		// End:0x326
		if(toolTipLineCount == 0)
		{
			return;
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

function ReturnTooltip_NTT_EllipsedList(string param, ETooltipSourceType eSourceType)
{
	local string TooltipDesc;
	local int textW, textH;
	local LVDataRecord Record;
	local array<string> strings;
	local int i;

	if(eSourceType == NTST_LIST_DRAWITEM)
	{
		ParseString(param, "TooltipDesc", TooltipDesc);
		if(ParseString(param, "TooltipDesc", TooltipDesc))
		{
			GetTextSizeDefault(TooltipDesc, textW, textH);
			m_Tooltip.MinimumWidth = textW;
			addToolTipDrawList(m_Tooltip, addDrawItemText(TooltipDesc, getInstanceL2Util().White));
			ReturnTooltipInfo(m_Tooltip);
		}
	}
	else if(eSourceType == ETooltipSourceType.NTST_LIST/*2*/)
	{
		ParamToRecord(param, Record);
		// End:0xD8
		if(Record.szReserved == "")
		{
			return;
		}
		m_Tooltip.MinimumWidth = 261;
		SplitByKeyStrings("<br>", Record.szReserved, strings);

		for(i = 0; i < strings.Length; i++)
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(strings[i], getInstanceL2Util().White));
			if(i != (strings.Length - 1))
			{
				AddTooltipItemBlank(10);
			}
		}
		ReturnTooltipInfo(m_Tooltip);
	}
	return;
}

private function SplitByKeyStrings(string keyString, string wordString, out array<string> strings)
{
	local int startIndex;

	startIndex = InStr(wordString, keyString);
	// End:0x41
	if(startIndex == -1)
	{
		// End:0x3F
		if(wordString != "")
		{
			strings[strings.Length] = wordString;
		}
		return;
	}
	strings[strings.Length] = Left(wordString, startIndex);
	Debug("GetStrings" @ Right(wordString, (Len(wordString) - startIndex) - Len(keyString)) @ string((Len(wordString) - startIndex) - Len(keyString)));
	SplitByKeyStrings(keyString, Right(wordString, (Len(wordString) - startIndex) - Len(keyString)), strings);	
}

//?ò¬±–ë–? ?ò—Ü–ë¬?(2010.03.30) ?ó–ü¬∑–?
function ReturnTooltip_NTT_POSTINFO(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	// End:0x4A
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);

		//ex) "?ë—á—ï—? : ?ó¬§—î–º—ë–??ê–ú–ë—?"
		AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[1].szData)), true, true, true);
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

//?ò¬±–ë–? ?ò—Ü–ë¬?(2010.02.22 ~ 03.08) ?ó–ü¬∑–?
/////////////////////////////////////////////////////////////////////////////////
// ROOMLIST
function ReturnTooltip_NTT_ROOMLIST(string param, ETooltipSourceType eSourceType)
{
	local int i;
	local LVDataRecord Record;
	local int Len;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH + 30;
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		Len = int(Record.LVDataList[5].szData);

		// End:0x17B [Loop If]
		for(i = 0 ; i < Len ; i++)
		{
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.u_nTextureWidth = 11;
			m_Info.u_nTextureHeight = 11;
			m_Info.u_strTexture = GetClassRoleIconName(Record.LVDataList[7 + i].nReserved1);
			EndItem();

			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.t_bDrawOneLine = false;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_strText = " " $ Record.LVDataList[7 + i].szData;
			EndItem();
			// End:0x171
			if(i != Len - 1)
			{
				AddTooltipItemBlank(2);
			}
		}
	}
	else
	{
		return;
	}

	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// DevToolDebug
function ReturnTooltip_DevToolDebug(string param)
{
	local LVDataRecord Record;
	local Color applyColor;
	local int tWidth, tHeight;

	return;
	ParamToRecord(param, Record);
	// End:0x2C
	if(Record.LVDataList[1].szData == "")
	{
		return;
	}
	// End:0x6A
	if(Len(Record.szReserved) > 0)
	{
		applyColor = GetColor(212, 111, 111, 255);
		AddTooltipColorText(Record.szReserved, applyColor, true, false, true);
	}
	applyColor = GetColor(222, 222, 111, 255);
	AddTooltipColorText(Record.LVDataList[1].szReserved, applyColor, true, false, true);
	GetTextSizeDefault(Record.LVDataList[1].szReserved, tWidth, tHeight);
	// End:0xDD
	if(800 < tWidth)
	{
		m_Tooltip.MinimumWidth = 800;
	}
	
	ReturnTooltipInfo(m_Tooltip);
}


/////////////////////////////////////////////////////////////////////////////////
// PrivateShopHistory
function ReturnTooltip_NTT_PrivateShopHistory(string param)
{
	local LVDataRecord Record;

	ParamToRecord(param, Record);
	
	// End:0x23
	if(Record.szReserved == "")
	{
		return;
	}
	StartItem();
	m_Info.eType = DIT_TEXT;
	m_Info.t_color.R = int(Record.nReserved1);
	m_Info.t_color.G = int(Record.nReserved2);
	m_Info.t_color.B = int(Record.nReserved3);
	m_Info.t_color.A = 255;
	m_Info.t_strText = Record.szReserved;
	EndItem();
	
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// USERLIST
function ReturnTooltip_NTT_USERLIST(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH + 70;
	// End:0x191
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[1].szData)), true, true, true);
		AddTooltipItemBlank(0);
		//ex)¬±?ù—ò–? ?ë—Ü—ó–? : 
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_strText = GetSystemString(2276) $ " : ";
		EndItem();
		
		//?ò—ñ—ë–?
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		// End:0x16B
		if(Record.LVDataList[4].szData == "")
		{
			m_Info.t_strText = GetSystemString(27);
		}
		else
		{
			m_Info.t_strText = Record.LVDataList[4].szData;
		}
		EndItem();
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// PARTYMATCH
function ReturnTooltip_NTT_PARTYMATCH(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH + 70;

	// End:0x191
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);

		//ex) "?ë—á—ï—? : ?ó¬§—î–º—ë–??ê–ú–ë—?"
		AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[1].szData)), true, true, true);
		AddTooltipItemBlank(0);
		//ex)¬±?ù—ò–? ?ë—Ü—ó–? : 
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_strText = GetSystemString(2276) $ " : ";
		EndItem();
		
		//?ò—ñ—ë–?
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		if(Record.LVDataList[3].szData == "")
		{
			m_Info.t_strText = GetSystemString(27);
		}
		else
		{
			m_Info.t_strText = Record.LVDataList[3].szData;
		}
		EndItem();
	}
	else
	{
		return;
	}

	ReturnTooltipInfo(m_Tooltip);
}

//?ò¬±–ë–? ?ì–?¬∞?? UNION ?ó‚Ññ?ê—? ?ë—á—ï—á—ë—? ?ñ–Ñ—ó–ê“ë–? ¬∞–∂?ó–?.
/////////////////////////////////////////////////////////////////////////////////
// UINONLIST
function ReturnTooltip_NTT_UNIONLIST(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[1].szData)), true, true, true);
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}


/////////////////////////////////////////////////////////////////////////////////
// QUESTLIST
function ReturnTooltip_NTT_QUESTLIST(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local NQuestUIData o_data;
	local int nType, nTmp;

	// End:0x9A
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		AddTooltipItemOption(1200, Record.LVDataList[0].szData, true, true, true);
		if(getInstanceUIData().getIsClassicServer())
		{
			// End:0x87
			if(IsAdenServer())
			{
				API_GetNQuestData(int(Record.nReserved1), o_data);
				nType = o_data.Type;				
			}
			else
			{
				nType = int(Record.nReserved2);
			}
			switch(nType)
			{
				case 1:
					nTmp = 862;
					// End:0xF7
					break;
				// End:0xCA
				case 2:
					nTmp = 2788;
					// End:0xF7
					break;
				case 3:
					nTmp = 14389;
					// End:0xF7
					break;
				case 4:
					nTmp = 861;
					// End:0xF7
					break;
			}			
		}
		else
		{
			switch(Record.LVDataList[3].nReserved1)
			{
				case 0:
				case 2:
					nTmp = 861;
					// End:0x13F
					break;
				case 1:
				case 3:
					nTmp = 862;
					break;
			}
		}	

		AddTooltipItemOption2(1202, nTmp, true, true, false);
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// RAIDLIST
function ReturnTooltip_NTT_RAIDLIST(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	// End:0xC9
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		// End:0x34
		if(Len(Record.szReserved) < 1)
		{
			return;
		}
		m_Tooltip.MinimumWidth = TOOLTIP_MINIMUM_WIDTH;

		//¬∑?Ññ?ê–ú¬µ–? ?ò—ñ—ë–?
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = false;
		m_Info.t_color.R = 178;
		m_Info.t_color.G = 190;
		m_Info.t_color.B = 207;
		m_Info.t_color.A = 255;
		m_Info.t_strText = Record.szReserved;
		EndItem();
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

/////////////////////////////////////////////////////////////////////////////////
// QUESTINFO
function ReturnTooltip_NTT_QUESTINFO(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	local int nTmp;
	local int Width1;
	local int Width2;
	local int Height;

	// End:0x224
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		AddTooltipItemOption(1200, Record.LVDataList[0].szData, true, true, true);
		AddTooltipItemOption(1201, Record.LVDataList[1].szData, true, true, false);
		GetTextSizeDefault(GetSystemString(1200) $ " : " $ Record.LVDataList[0].szData, Width1, Height);
		GetTextSizeDefault(GetSystemString(1201) $ " : " $ Record.LVDataList[1].szData, Width2, Height);
		// End:0xE2
		if(Width2 > Width1)
		{
			Width1 = Width2;
		}
		// End:0xF6
		if(TOOLTIP_MINIMUM_WIDTH > Width1)
		{
			Width1 = TOOLTIP_MINIMUM_WIDTH;
		}
		m_Tooltip.MinimumWidth = Width1 + 30;
		
		//?ì–??ì¬µ¬∑‚Ññ?î¬?
		AddTooltipItemOption(922, Record.LVDataList[2].szData, true, true, false);
		
		//?Ññ–≠?î‚Ññ?ò—?
		switch(Record.LVDataList[3].nReserved1)
		{
			// End:0x142
			case 0:
			// End:0x155
			case 2:
				nTmp = 861;
				// End:0x16F
				break;
			// End:0x159
			case 1:
			// End:0x16C
			case 3:
				nTmp = 862;
				// End:0x16F
				break;
		}
		AddTooltipItemOption2(1202, nTmp, true, true, false);
		
		//?î—â–Ö—î–ñ¬??ò—ñ—ë–?
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
		m_Info.t_bDrawOneLine = false;
		m_Info.bLineBreak = true;
		m_Info.t_color.R = 178;
		m_Info.t_color.G = 190;
		m_Info.t_color.B = 207;
		m_Info.t_color.A = 255;
		m_Info.t_strText = Record.szReserved;
		EndItem();
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
}



/////////////////////////////////////////////////////////////////////////////////
// QUESTINFO
function ReturnTooltip_NTT_QUESTRECOMMAND_MAPLIST(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	
	local array<int> rewardIDList;
	local array<INT64> rewardNumList;

	local int NpcID;
	local int questID;

	local string requirementStr, NpcName, itemText;
	local ItemInfo tmpInfo;

	local int i, nWidth, nHeight;

	local string levelText, QuestTypeText, QuestName;

	// End:0x4E4
	if(eSourceType == NTST_LIST)
	{
		m_Tooltip.MinimumWidth = 330;
		ParamToRecord(param, Record);
		questID = int(Record.nReserved1);
		ParseString(param, "QuestName", QuestName);
		ParseString(param, "QuestTypeText", QuestTypeText);
		ParseString(param, "LevelText", levelText);
		AddTooltipColorText("[" $ levelText $ "]" @ QuestName, getInstanceL2Util().BrightWhite, true, true, true);
		AddCrossLine();
		NpcID = class'UIDATA_QUEST'.static.GetStartNPCID(questID, 1);
		NpcName = class'UIDATA_NPC'.static.GetNPCName(NpcID);
		// End:0x11A
		if(NpcName == "")
		{
			NpcName = GetSystemString(27);
		}
		AddTooltipItemOption(1203, NpcName, true, true, false,,,,, GetColor(170, 153, 119, 255));
		AddTooltipItemOption(1202, QuestTypeText, true, true, false,,,,, GetColor(170, 153, 119, 255));
		requirementStr = class'UIDATA_QUEST'.static.GetRequirement(questID, 1);
		GetTextSizeDefault(requirementStr, nWidth, nHeight);

		// ?ñ–ö‚Ññ¬´ ¬±–∂?ë–?, ?ó—à¬∂—É–ê–û–ê¬? ?ó–ü–ë—? ?ï–ö–ê–?.
		// End:0x1F1
		if(nWidth > 400)
		{
			AddTooltipColorText(GetSystemString(1201) @ ": ", GetColor(163, 163, 163, 255), true, true, false);
			AddTooltipItemBlank(0);
			AddTooltipColorText(requirementStr, GetColor(170, 153, 119, 255), false, false, false);
		}
		else
		{
			AddTooltipItemOption(1201, requirementStr, true, true, false,,,,, GetColor(170, 153, 119, 255));
		}

		// ?î—â–Ö—î–ñ¬? ?ò—ñ—ë–?, ¬ª–∑?ó–? ?ï–ò–ó–°“ë–? ?ó–®—ò¬? ?ë–¶—ò¬? ?ì—ñ—ë¬?
		AddTooltipItemBlank(10);
		AddTooltipColorText(class'UIDATA_QUEST'.static.GetIntro(questID, 1), GetColor(178, 190, 207, 255), true, false, false);
		AddTooltipItemBlank(0);
		AddCrossLine();
		AddTooltipColorText(GetSystemString(2006), GetColor(211, 211, 211, 255), true, true, true);
		AddTooltipItemBlank(3);

		class'UIDATA_QUEST'.static.GetQuestReward(questID, 1, rewardIDList, rewardNumList);

		// End:0x4E1 [Loop If]
		for(i = 0; i < rewardIDList.Length; i++)
		{
			AddTooltipItemBlank(0);
			class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(rewardIDList[i]), tmpInfo);

			addItemIcon(tmpInfo, tmpInfo.IconPanel);

			//?ï–ñ–ê–ú–ï–? ¬∞?ñ—ò—?
			// End:0x320
			if(rewardNumList[i] == 0)
			{
				itemText = GetSystemString(584); // ?Ññ?ú–ë¬?
			}
			else
			{
				// ?ï–ñ¬∑–é—ó–? ?ó–®“ë–∑–ó–ü“ë–? ¬∞–∂?ó–? ?ë–? "¬∞??" ?ó“ê–Ö–ì¬∞–? ?ï–ò¬µ–ó—ï–æ—ï–? ?ó–°“ë–?.
				if(rewardIDList[i] == 57 ||      // ?ï–ñ¬µ“ê—ñ–? 
				    rewardIDList[i] == 15623 ||   // ¬∞–∂?ó–∏–î–?  
					rewardIDList[i] == 15624 ||   // ?Ö—î–ï—? ?ñ—á–ê–û–ñ¬?
					rewardIDList[i] == 15625 ||   // ?Ññ¬∞?ê–Ö–ó“?        
					rewardIDList[i] == 15626 ||   // ?ò¬∞¬∑–? ?ñ—á–ê–û–ñ¬?
					rewardIDList[i] == 15627 ||   // ?ó—á—ë–? ?ñ—á–ê–û–ñ¬?
					rewardIDList[i] == 15628 ||   // ¬µ¬µ?Ññ–™ ?î—ë¬ª—?
					rewardIDList[i] == 15629 ||   // ¬∑?à“ë—? ?î—ë¬ª—?
					rewardIDList[i] == 15630 ||   // ?ë¬§¬ª–∫–ó—? ?î—ë¬ª—?
					rewardIDList[i] == 15631 ||   // ?ì–?¬∞?? ?î—ë¬ª—?
					rewardIDList[i] == 15632 ||   // ?ò¬??î–? ?ï¬?¬∑?é–Ö—? ¬±?ó–ó–? ?ò‚Ññ¬µ–∂
					rewardIDList[i] == 15633 ||   // PK ?î¬´—ó–æ–ñ¬? ?ó–ü¬∂—?
					rewardIDList[i] == 47130      // ?ó–º–ò–à¬µ¬? ?ñ—á–ê–û–ñ¬?
					)
				{
					itemText = MakeCostString(string(rewardNumList[i]));
				}
				else
				{
					// $1¬∞??
					itemText = MakeFullSystemMsg(GetSystemMessage(1983), MakeCostString(string(rewardNumList[i])));
				}
			}
			AddTooltipColorText(tmpInfo.Name, getInstanceL2Util().BrightWhite, false, true, false,, 3, 4);
			AddTooltipColorText(itemText, GetColor(170, 153, 119, 255), true, true, false,, 36, -16);
		}
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

function ReturnTooltip_NTT_QUESTRECOMMAND_MAPLISTClassic(string param, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local int QuestID, nWidth, nHeight;
	local string requirementStr, NpcName, QuestTypeText, questName;
	local NQuestUIData questUIData;
	local NQuestDialogUIData questDialogUIData;

	// End:0x33E
	if(eSourceType == ETooltipSourceType.NTST_LIST/*2*/)
	{
		m_Tooltip.MinimumWidth = 330;
		ParamToRecord(param, Record);
		QuestID = int(Record.nReserved1);
		API_GetNQuestData(QuestID, questUIData);
		questName = questUIData.Name;
		AddTooltipColorText(questName, getInstanceL2Util().BrightWhite, true, true, true);
		AddCrossLine();
		NpcName = class'UIDATA_NPC'.static.GetNPCName(questUIData.StartNPC.Id);
		// End:0xC3
		if(NpcName == "")
		{
			NpcName = GetSystemString(27);
		}
		AddTooltipItemOption(1203, NpcName, true, true, false,,,,, GetColor(170, 153, 119, 255));
		// End:0x10B
		if(QuestID < 20001)
		{
			QuestTypeText = GetSystemString(2738);			
		}
		else if(QuestID < 30001)
		{
			QuestTypeText = GetSystemString(2341);				
		}
		else
		{
			QuestTypeText = GetSystemString(1796);
		}
		switch(questUIData.Type)
		{
			// End:0x16B
			case NQT_ONETIME:
				QuestTypeText = QuestTypeText @ GetSystemString(862);
				// End:0x1CE
				break;
			// End:0x18B
			case NQT_DAILY:
				QuestTypeText = QuestTypeText @ GetSystemString(2788);
				// End:0x1CE
				break;
			// End:0x1AB
			case NQT_WEEKLY:
				QuestTypeText = QuestTypeText @ GetSystemString(14389);
				// End:0x1CE
				break;
			// End:0x1CB
			case NQT_REPEAT:
				QuestTypeText = QuestTypeText @ GetSystemString(861);
				// End:0x1CE
				break;
		}
		AddTooltipItemOption(1202, QuestTypeText, true, true, false,,,,, GetColor(170, 153, 119, 255));
		API_GetNQuestDialogData(QuestID, questDialogUIData);
		// End:0x248
		if(questUIData.Goal.Num > 1)
		{
			requirementStr = questUIData.Goal.Name @ "x" $ string(questUIData.Goal.Num);			
		}
		else
		{
			requirementStr = questUIData.Goal.Name;
		}
		GetTextSizeDefault(requirementStr, nWidth, nHeight);
		// End:0x2CF
		if(nWidth > 400)
		{
			AddTooltipColorText(GetSystemString(1201) @ ": ", GetColor(163, 163, 163, 255), true, true, false);
			AddTooltipItemBlank(0);
			AddTooltipColorText(requirementStr, GetColor(170, 153, 119, 255), false, false, false);			
		}
		else
		{
			AddTooltipItemOption(1201, requirementStr, true, true, false,,,,, GetColor(170, 153, 119, 255));
		}
		AddTooltipItemBlank(0);
		AddCrossLine();
		AddTooltipColorText(GetSystemString(2006), GetColor(211, 211, 211, 255), true, true, true);
		AddTooltipItemBlank(3);
		SetQuestRewardItem(questUIData.Reward);		
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);	
}

private function SetQuestRewardItem(NQuestRewardData rewardDatas)
{
	local int i;
	local array<NQuestRewardItemData> Items;
	local NQuestRewardItemData rewardItemData;

	// End:0x47
	if(rewardDatas.Level > 0)
	{
		rewardItemData.ItemClassID = 95641;
		rewardItemData.Amount = rewardDatas.Level;
		Items[Items.Length] = rewardItemData;
	}
	// End:0x8E
	if(rewardDatas.Exp > 0)
	{
		rewardItemData.ItemClassID = 15623;
		rewardItemData.Amount = rewardDatas.Exp;
		Items[Items.Length] = rewardItemData;
	}
	// End:0xD5
	if(rewardDatas.Sp > 0)
	{
		rewardItemData.ItemClassID = 15624;
		rewardItemData.Amount = rewardDatas.Sp;
		Items[Items.Length] = rewardItemData;
	}

	// End:0x118 [Loop If]
	for(i = 0; i < rewardDatas.Items.Length; i++)
	{
		Items[Items.Length] = rewardDatas.Items[i];
	}
	InsertQuestRewardItems(Items);	
}

private function InsertQuestRewardItems(array<NQuestRewardItemData> Items)
{
	local int i;
	local ItemInfo tmpInfo;
	local string itemText;

	// End:0x293 [Loop If]
	for(i = 0; i < Items.Length; i++)
	{
		AddTooltipItemBlank(0);
		class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(Items[i].ItemClassID), tmpInfo);
		addItemIcon(tmpInfo, tmpInfo.IconPanel);
		// End:0x87
		if(Items[i].Amount == 0)
		{
			itemText = GetSystemString(584);			
		}
		else
		{
			// End:0x20F
			if(Items[i].ItemClassID == 57 || Items[i].ItemClassID == 15623 || Items[i].ItemClassID == 15624 || Items[i].ItemClassID == 15625 || Items[i].ItemClassID == 15626 || Items[i].ItemClassID == 15627 || Items[i].ItemClassID == 15628 || Items[i].ItemClassID == 15629 || Items[i].ItemClassID == 15630 || Items[i].ItemClassID == 15631 || Items[i].ItemClassID == 15632 || Items[i].ItemClassID == 15633 || Items[i].ItemClassID == 47130)
			{
				itemText = MakeCostString(string(Items[i].Amount));				
			}
			else
			{
				itemText = MakeFullSystemMsg(GetSystemMessage(1983), MakeCostString(string(Items[i].Amount)));
			}
		}
		AddTooltipColorText(tmpInfo.Name, getInstanceL2Util().BrightWhite, false, true, false,, 3, 4);
		AddTooltipColorText(itemText, GetColor(170, 153, 119, 255), true, true, false,, 36, -16);
	}	
}

/////////////////////////////////////////////////////////////////////////////////
// MANOR
function ReturnTooltip_NTT_MANOR(string param, string TooltipType, ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	local int idx1;
	local int idx2;
	local int idx3;

	// End:0x1E4
	if(eSourceType == NTST_LIST)
	{
		ParamToRecord(param, Record);
		// End:0x54
		if(TooltipType == "ManorSeedInfo")
		{
			idx1 = 4;
			idx2 = 5;
			idx3 = 6;
		}
		else if(TooltipType == "ManorCropInfo")
		{
			idx1 = 5;
			idx2 = 6;
			idx3 = 7;
		}
		else if(TooltipType == "ManorSeedSetting")
		{
			idx1 = 7;
			idx2 = 8;
			idx3 = 9;
		}
		else if(TooltipType == "ManorCropSetting")
		{
			idx1 = 9;
			idx2 = 10;
			idx3 = 11;
		}
		else if(TooltipType == "ManorDefaultInfo")
		{
			idx1 = 1;
			idx2 = 4;
			idx3 = 5;
		}
		else if(TooltipType == "ManorCropSell")
		{
			idx1 = 7;
			idx2 = 8;
			idx3 = 9;
		}
		// ?ï—ï—ï–? or ?ê–´‚Ññ¬∞ ?ê–ú—ë¬?
		AddTooltipItemOption(0, Record.LVDataList[0].szData, false, true, true);
		AddTooltipItemOption(537, Record.LVDataList[idx1].szData, true, true, false);
		AddTooltipItemOption(1134, Record.LVDataList[idx2].szData, true, true, false);
		AddTooltipItemOption(1135, Record.LVDataList[idx3].szData, true, true, false);
	}
	else
	{
		return;
	}
		
	ReturnTooltipInfo(m_Tooltip);
}

// [?î—â–Ö—î–ñ¬? ?ï–ñ–ê–ú–ï–? ?ï—à–ñ–? ?ì–?¬∞??]
function ReturnTooltip_NTT_QUESTREWARDS(string param, ETooltipSourceType eSourceType)
{
	// [?î—â–Ö—î–ñ¬? ?ï–ñ–ê–ú–ï–? ?ï—à–ñ–? ?ì–?¬∞??] ?ê–? ?î–û—î–†—ó–? ?î—â–Ö—î–ñ¬? ?ï–ñ–ê–ú–ï–? ?ï—à–ñ–ë—ó–? ¬∞?ô—ë–í“ë–? ?î–™¬µ–µ¬∞–? ¬µ–π?ï–æ¬∞–é—ë–? ¬µ?? ¬∞?? ¬∞¬∞?Ö–ê“ë–ü“ë–?.
	// 2009.10.14
	// ReturnTooltip_NTT_ITEM(param, "Inventoty", eSourceType);
	ReturnTooltip_NTT_ITEM(param, "QuestReward", eSourceType);
}

//?ï–ñ–ê–ú–ï–´–ê–? ¬ª?Ü¬ª—É–ê¬? ?ë–©–Ö–? ?ò—ñ–ë¬§–ó–®–ë–®“ë–?.
function SetTooltipItemColor(int R, int G, int B, int offset)
{
	local int idx;

	idx = (m_Tooltip.DrawList.Length - 1) - offset;
	m_Tooltip.DrawList[idx].t_color.R = R;
	m_Tooltip.DrawList[idx].t_color.G = G;
	m_Tooltip.DrawList[idx].t_color.B = B;
	m_Tooltip.DrawList[idx].t_color.A = 255;
}

//?ê–û–ì—ï–ñ¬?(?ò¬±–ë–? ¬ª?Ü¬ª—? ?î–á¬∞–?)
function int AddTooltipItemEnchant(ItemInfo item, optional bool bFirstLineWidthCount, optional string FontName, optional int OffsetX, optional int OffsetY)
{
	local int nSumWidth, sizeWidth, sizeHeight;
	local EItemParamType EItemParamType;

	EItemParamType = EItemParamType(item.ItemType);
	// End:0x132
	if(item.Enchanted>0 && IsEnchantableItem(EItemParamType))
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 170;
		m_Info.t_color.G = 110;
		m_Info.t_color.B = 230;
		m_Info.t_color.A = 255;
		m_Info.t_strText = "+" $ item.Enchanted;//$ " ";
		m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
		m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
		m_Info.t_strFontName = FontName;
		EndItem();
		GetTextSizeDefault(m_Info.t_strText, sizeWidth, sizeHeight);
		nSumWidth = nSumWidth + sizeWidth;
	}
	return nSumWidth;
}

// "0" ~ "9"  "plus"
function AddItemEnchantedImg(int nEnchanted)
{
	local string s1, S2, ss;

	// End:0x4F
	if(nEnchanted > 0)
	{
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_CT1.ENCHANTNUMBER_SMALL_plus", false, true, 0, -9, 6, 8, 6, 8));
	}
	// End:0x115
	if(nEnchanted > 9)
	{
		ss = string(nEnchanted);
		s1 = Left(ss, 1);
		S2 = Right(ss, 1);
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ s1, true, false, 0, -9, 6, 8, 6, 8));
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ S2, true, false, 0, -9, 6, 8, 6, 8));
	}
	else if(nEnchanted > 0 && nEnchanted < 10)
	{
			addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ string(nEnchanted), true, false, 0, -9, 6, 8, 6, 8));
	}
}

function AddItemEnsoulStepNumImg(int nStep)
{
	local string s1, S2, ss;

	// End:0xCC
	if(nStep > 9)
	{
		ss = string(nStep);
		s1 = Left(ss, 1);
		S2 = Right(ss, 1);
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_NewTex.ToolTip.TooltipNUMBER" $ s1, true, false, -12, 22, 6, 8, 6, 8));
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_NewTex.ToolTip.TooltipNUMBER" $ S2, true, false, 0, 22, 6, 8, 6, 8));		
	}
	else
	{
		// End:0x133
		if(nStep > 0 && nStep < 10)
		{
			addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_NewTex.ToolTip.TooltipNUMBER" $ string(nStep), true, false, -6, 22, 6, 8, 6, 8));
		}
	}
}

//?ï–ñ–ê–ú–ï–? ?ê–ú—ë¬? + AdditionalName
function AddTooltipItemName(ItemInfo item, optional string FontName, optional int OffsetX, optional int OffsetY)
{
	local string ItemName;
	local Color applyColor;
	local int nAddTooltipItemName;

	// End:0x6F
	if(isBlessed(item))
	{
		// End:0x32
		if(OffsetX == 0)
		{
			ItemName = GetSystemString(13403) $ " ";			
		}
		else
		{
			ItemName = GetSystemString(13403);
		}
		AddTooltipColorText(ItemName, getInstanceL2Util().Blue, false, true, false, FontName, OffsetX, OffsetY);
	}
	// End:0xB8
	if(getInstanceUIData().getIsLiveServer())
	{
		ItemName = class'UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);		
	}
	else
	{
		ItemName = item.Name;
	}
	StartItem();
	m_Info.eType = DIT_TEXT;
	m_Info.t_bDrawOneLine = true;
	nAddTooltipItemName = class'UIDATA_ITEM'.static.GetItemNameClass(item.Id);
	switch(nAddTooltipItemName)
	{
		// End:0x129
		case 0:
			applyColor = GetColor(137, 137, 137, 255);
			// End:0x1B6
			break;
		// End:0x144
		case 1:
			applyColor = GetColor(230, 230, 230, 255);
			// End:0x1B6
			break;
		// End:0x160
		case 2:
			applyColor = GetColor(255, 251, 4, 255);
			// End:0x1B6
			break;
		// End:0x17C
		case 3:
			applyColor = GetColor(240, 68, 68, 255);
			// End:0x1B6
			break;
		// End:0x198
		case 4:
			applyColor = GetColor(33, 164, 255, 255);
			// End:0x1B6
			break;
		// End:0x1B3
		case 5:
			applyColor = GetColor(255, 0, 255, 255);
			// End:0x1B6
			break;
	}
	m_Info.t_color = applyColor;
	m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
	m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
	m_Info.t_strText = ItemName;
	m_Info.t_strFontName = FontName;
	EndItem();

	// Additional Name
	// End:0x30A
	if(Len(item.AdditionalName) > 0)
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 255;
		m_Info.t_color.G = 217;
		m_Info.t_color.B = 105;
		m_Info.t_color.A = 255;
		m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
		m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
		m_Info.t_strFontName = FontName;
		m_Info.t_strText = " " $ item.AdditionalName;
		EndItem();
	}
}

//Grade Mark
function AddTooltipItemGrade(ItemInfo item, optional int OffsetX, optional int OffsetY)
{
	local string TextureName;

	TextureName = GetItemGradeTextureName(item.CrystalType);
	// End:0x15B
	if(Len(TextureName) > 0)
	{
		StartItem();

		m_Info.eType = DIT_TEXTURE;
		m_Info.u_strTexture = TextureName;
		m_Info.nOffSetX = (m_Info.nOffSetX + OffsetX) + 8;
		m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
		m_Info.u_nTextureHeight = 16;
		m_Info.u_nTextureUHeight = 16;
		// End:0x13B
		if(item.CrystalType == CrystalType.CRT_S80 || item.CrystalType == CrystalType.CRT_S84 || item.CrystalType == CrystalType.CRT_R95 || item.CrystalType == CrystalType.CRT_R99 || item.CrystalType == CrystalType.CRT_R110)
		{
			m_Info.u_nTextureWidth = 32;
			m_Info.u_nTextureUWidth = 32;
		}
		else
		{
			m_Info.u_nTextureWidth = 16;
			m_Info.u_nTextureUWidth = 16;
		}
		EndItem();
	}
}

//Stackable Count
function AddTooltipItemCount(ItemInfo item, optional int OffsetX, optional int OffsetY)
{
	// End:0xE3
	if(IsStackableItem(item.ConsumeType))
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_strText = " (" $ MakeCostString(String(item.ItemNum)) $ ")";
		m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
		m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		EndItem();
	}
}

//?ë¬¶¬∑–? ¬ª?Ü¬ª—?
function GetRefineryColor(int Quality, out int R, out int G, out int B)
{
	switch(Quality)
	{
		// End:0x26
		case 1:
			R = 187;
			G = 181;
			B = 138;
			// End:0xA4
			break;
		// End:0x46
		case 2:
			R = 132;
			G = 174;
			B = 216;
			// End:0xA4
			break;
		// End:0x66
		case 3:
			R = 193;
			G = 112;
			B = 202;
			// End:0xA4
			break;
		// End:0x86
		case 4:
			R = 225;
			G = 109;
			B = 109;
			// End:0xA4
			break;
		// End:0xFFFF
		default:
			R = 187;
			G = 181;
			B = 138;
			// End:0xA4
			break;
	}
}

function AddTooltipItemAttributeGage(ItemInfo item)
{
	local int i;
	local array<string> TextureName, tooltipStr;

	// End:0x39 [Loop If]
	for(i = 0; i < 6; i++)
	{
		TextureName[i] = "";
		tooltipStr[i] = "";
	}
	NowAttrLv = 0;
	NowMaxValue = 0;
	NowValue = 0;
	// End:0x4CB
	if(item.AttackAttributeValue > 0)
	{
		AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_AttackAttributeValue_small", GetSystemString(1596));
		SetAttackAttribute(item.AttackAttributeValue, ATTRIBUTE_FIRE);
		SetAttackAttribute(item.AttackAttributeValue, ATTRIBUTE_WATER);
		SetAttackAttribute(item.AttackAttributeValue, ATTRIBUTE_WIND);
		SetAttackAttribute(item.AttackAttributeValue, ATTRIBUTE_EARTH);
		SetAttackAttribute(item.AttackAttributeValue, ATTRIBUTE_HOLY);
		SetAttackAttribute(item.AttackAttributeValue, ATTRIBUTE_UNHOLY); //¬∑?Ññ?î¬ß¬∞—? ?ó—Ü–ë¬¶¬∞–Ñ¬µ–æ–ê¬? ¬±?ë–ó–°“ë–?.		

		switch(item.AttackAttributeType)
		{
			case ATTRIBUTE_FIRE:
				TextureName[ATTRIBUTE_FIRE] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_FIRE";
				tooltipStr[ATTRIBUTE_FIRE] =GetSystemString(1622) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_FIRE]) $ " ("$ GetSystemString(1622) $ " " $ GetSystemString(55) $ " " $ String(item.AttackAttributeValue) $")";
				break;
			case ATTRIBUTE_WATER:
				TextureName[ATTRIBUTE_WATER] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WATER";
				tooltipStr[ATTRIBUTE_WATER] =GetSystemString(1623) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_WATER]) $ " ("$ GetSystemString(1623) $ " " $ GetSystemString(55) $ " " $String(item.AttackAttributeValue) $ ")";
				break;
			case ATTRIBUTE_WIND:
				TextureName[ATTRIBUTE_WIND] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WIND";
				tooltipStr[ATTRIBUTE_WIND] =GetSystemString(1624) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_WIND]) $ " ("$ GetSystemString(1624) $ " " $ GetSystemString(55) $ " " $String(item.AttackAttributeValue) $ ")";
				break;
			case ATTRIBUTE_EARTH:
				TextureName[ATTRIBUTE_EARTH] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_EARTH";
				tooltipStr[ATTRIBUTE_EARTH] =GetSystemString(1625) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_EARTH]) $ " ("$ GetSystemString(1625) $ " " $ GetSystemString(55) $ " " $ String(item.AttackAttributeValue) $")";
				break;
			case ATTRIBUTE_HOLY:
				TextureName[ATTRIBUTE_HOLY] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DIVINE";
				tooltipStr[ATTRIBUTE_HOLY] =GetSystemString(1626) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_HOLY]) $ " ("$ GetSystemString(1626) $ " " $ GetSystemString(55) $ " " $String(item.AttackAttributeValue) $ ")";
				break;
			case ATTRIBUTE_UNHOLY:
				TextureName[ATTRIBUTE_UNHOLY] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DARK";
				tooltipStr[ATTRIBUTE_UNHOLY] =GetSystemString(1627) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_UNHOLY]) $ " ("$ GetSystemString(1627) $ " " $ GetSystemString(55) $ " " $String(item.AttackAttributeValue) $ ")";
				break;
		}
	}
	else	// ?Ññ–∂?ï–? ?ï–ñ–ê–ú–ï–? ?ò–£—ò—?
	{
		SetDefAttribute(item.DefenseAttributeValueFire,ATTRIBUTE_FIRE);
		SetDefAttribute(item.DefenseAttributeValueWater,ATTRIBUTE_WATER);
		SetDefAttribute(item.DefenseAttributeValueWind,ATTRIBUTE_WIND);
		SetDefAttribute(item.DefenseAttributeValueEarth,ATTRIBUTE_EARTH);
		SetDefAttribute(item.DefenseAttributeValueHoly,ATTRIBUTE_HOLY);
		SetDefAttribute(item.DefenseAttributeValueUnholy,ATTRIBUTE_UNHOLY); //¬∑?Ññ?î¬ß¬∞—? ?ó—Ü–ë¬¶¬∞–Ñ¬µ–æ–ê¬? ¬±?ë–ó–°“ë–?.
		// End:0x5D6
		if(item.DefenseAttributeValueFire != 0) //?ñ–î–ê–ú—ï–? ?ò–£—ò—? ?ï—à–ñ–? ¬±–ß?ë¬?¬±–≤
		{
			TextureName[ATTRIBUTE_FIRE] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_FIRE";
			tooltipStr[ATTRIBUTE_FIRE] =GetSystemString(1623) $ " Lv " $ String(DefAttLevel[ATTRIBUTE_FIRE]) $ " ("$ GetSystemString(1622) $ " " $ GetSystemString(54) $ " " $ String(item.DefenseAttributeValueFire) $")";
		}
		if(item.DefenseAttributeValueWater != 0) //?Ññ¬∞ ?ò–£—ò—? ?ï—à–ñ–? ¬±–ß?ë¬?¬±–≤
		{
			TextureName[ATTRIBUTE_WATER] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WATER";
			tooltipStr[ATTRIBUTE_WATER] =GetSystemString(1622) $ " Lv " $ String(DefAttLevel[ATTRIBUTE_WATER]) $ " ("$ GetSystemString(1623) $ " " $ GetSystemString(54) $ " " $String(item.DefenseAttributeValueWater) $ ")";
		}
		if(item.DefenseAttributeValueWind != 0) //?Ññ–©¬∂?? ?ò–£—ò—? ?ï—à–ñ–? ¬±–ß?ë¬?¬±–≤
		{
			TextureName[ATTRIBUTE_WIND] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WIND";
			tooltipStr[ATTRIBUTE_WIND] =GetSystemString(1625) $ " Lv " $ String(DefAttLevel[ATTRIBUTE_WIND]) $ " ("$ GetSystemString(1624) $ " " $ GetSystemString(54) $ " " $String(item.DefenseAttributeValueWind) $")";
		}
		if(item.DefenseAttributeValueEarth != 0) //¬∂?? ?ò–£—ò—? ?ï—à–ñ–? ¬±–ß?ë¬?¬±–≤
		{
			TextureName[ATTRIBUTE_EARTH] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_EARTH";
			tooltipStr[ATTRIBUTE_EARTH] =GetSystemString(1624) $ " Lv " $ String(DefAttLevel[ATTRIBUTE_EARTH]) $ " ("$ GetSystemString(1625) $ " " $ GetSystemString(54) $ " " $String(item.DefenseAttributeValueEarth) $ ")";
		}
		if(item.DefenseAttributeValueHoly != 0) //?Ö–ï—ò—? ?ò–£—ò—? ?ï—à–ñ–? ¬±–ß?ë¬?¬±–≤
		{
			TextureName[ATTRIBUTE_HOLY] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DIVINE";
			tooltipStr[ATTRIBUTE_HOLY] =GetSystemString(1627) $ " Lv " $ String(DefAttLevel[ATTRIBUTE_HOLY]) $ " ("$ GetSystemString(1626) $ " " $ GetSystemString(54) $ " " $ String(item.DefenseAttributeValueHoly) $")";
		}
		if(item.DefenseAttributeValueUnholy != 0) //?ï–ü–ò–? ?ò–£—ò—? ?ï—à–ñ–? ¬±–ß?ë¬?¬±–≤
		{
			TextureName[ATTRIBUTE_UNHOLY] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DARK";
			tooltipStr[ATTRIBUTE_UNHOLY] =GetSystemString(1626) $ " Lv " $ String(DefAttLevel[ATTRIBUTE_UNHOLY]) $ " ("$ GetSystemString(1627) $ " " $ GetSystemString(54) $ " " $String(item.DefenseAttributeValueUnholy) $ ")";
		}
	}
	// End:0xAE0
	if(item.AttackAttributeValue > 0)//¬∞?à¬∞–??ò–£—ò—î–ê–ü¬∞–∂—ó–?
	{
		// End:0xADD [Loop If]
		for(i = 0; i < 6; i++)
		{
			// End:0x943
			if(tooltipStr[i] == "")
			{
				// [Explicit Continue]
				continue;
			}
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_strText = tooltipStr[i];
			EndItem();
			
			// ?ò–£—ò—? ?ï–ñ–ê–ú–î–? 
			//addTooltipTexture(GetAttributeIcon(i),16,16, 13,13, true, false, 2,2);

			//?ï–®–Ö—î–ì–? ¬µ?û–ê–µ–ê¬? ¬∞–≥?ì–? ¬±–ß¬∑?ë—ï–? ?ó–°“ë–?. 
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 0;
			m_Info.nOffSetY = 2;
			m_Info.u_nTextureWidth = 140;
			m_Info.u_nTextureHeight = 7;
			m_Info.u_strTexture = TextureName[i] $ "_BG";
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 0;
			m_Info.nOffSetY = -7;
			m_Info.u_nTextureWidth = (AttackAttCurrValue[i] * 140) / AttackAttMaxValue[i];
			// End:0xAAA
			if(m_Info.u_nTextureWidth > 140)
			{
				m_Info.u_nTextureWidth = 140;
			}
			m_Info.u_nTextureHeight = 7;
			m_Info.u_strTexture = TextureName[i];
			EndItem();
		}
	}
	else
	{
		// End:0xB97
		if(item.DefenseAttributeValueFire > 0 || item.DefenseAttributeValueWater > 0 || item.DefenseAttributeValueWind > 0 || item.DefenseAttributeValueEarth > 0 || item.DefenseAttributeValueHoly > 0 || item.DefenseAttributeValueUnholy > 0)
		{
			AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_AttackAttributeValue_small", GetSystemString(1596));
		}

		// End:0xD59 [Loop If]
		for(i = 0; i < 6; i++)
		{
			// End:0xBBF
			if(tooltipStr[i] == "")
			{
				// [Explicit Continue]
				continue;
			}
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_strText = tooltipStr[i];
			EndItem();
			
			//?ï–®–Ö—î–ì–? ¬µ?û–ê–µ–ê¬? ¬∞–≥?ì–? ¬±–ß¬∑?ë—ï–? ?ó–°“ë–?. 
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 0;
			m_Info.nOffSetY = 2;
			m_Info.u_nTextureWidth = 140;
			m_Info.u_nTextureHeight = 7;
			m_Info.u_strTexture = TextureName[i] $ "_BG";
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 0;
			m_Info.nOffSetY = -7;
			m_Info.u_nTextureWidth = (DefAttCurrValue[i] * 140) / DefAttMaxValue[i];
			// End:0xD26
			if(m_Info.u_nTextureWidth > 140)
			{
				m_Info.u_nTextureWidth = 140;
			}
			m_Info.u_nTextureHeight = 7;
			m_Info.u_strTexture = TextureName[i];
			EndItem();
		}
	}
}

// ¬±–≤¬∞?à–ë¬? ?ï–ñ–ê–ú–ï–?, ¬±–≤¬∞?à–ë¬? ¬∞?é¬∞—? 
function AddTooltipItemCurrentPeriod(ItemInfo item)
{
	// ¬±–≤¬∞?à–ë¬? ?ï–ñ–ê–ú–ï–?
	// End:0x1A9
	if(item.CurrentPeriod > 0)
	{
		//?î—É¬∞—à¬∞–?
		AddCrossLine();
		AddTooltipItemBlank(0);

		//<¬±–≤¬∞?à–ë¬? ¬∞?é¬∞—?>
		//branch120516
		if(item.LookChangeItemID > 0 && item.Id.ClassID != 4442) //branch GD35_0828 2013-12-18 luciper3 - ?î‚Ññ¬±?ó–ê–? ?ï–ñ“ë–°¬∞–∂—ó–?..
		{
			// ¬±–≤¬∞?à–ë¬? ¬∞?é¬∞—?
			AddTooltipItemOption(5144, "", true, false, false);
		}
		else
		{
			// <¬±–≤¬∞?à–ë¬? ?ï–ñ–ê–ú–ï–?>
			AddTooltipItemOption(1739, "", true, false, false);
		}
		SetTooltipItemColor(230, 230, 230, 0);
		//end of branch
		
		AddTooltipItemBlank(0);
		addTexture("l2ui_ct1.SkillWnd_DF_ListIcon_use", 12, 11, 12, 11, 3, 7);
		// ?ñ–Ü–ê—? ?Ö–ì¬∞–? 
		AddTooltipColorText(GetSystemString(1199) $ " : ", GetColor(163, 163, 163, 255), false, true, false, "", 0, TOOLTIP_LINE_HGAP);
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
		m_Info.bLineBreak = false;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 178;
		m_Info.t_color.G = 190;
		m_Info.t_color.B = 207;
		m_Info.t_color.A = 255;
		m_Info.t_strText = MakeTimeStr(item.CurrentPeriod);
		ParamAdd(m_Info.Condition, "Type", "PeriodTime");
		EndItem();
	}
}

// ¬±–≤¬∞?à–ë¬? ?ï–ñ–ê–ú–ï–? ?ñ–Ü–ê—? ¬±–≤¬∞?? : 22?ê–? 22?Ö–ì¬∞–? 22?î–? ¬±–≤?ë–®–ê—ë¬∑–? ?ï—à–ñ–? ¬ª–∑?ê–ú–ë–æ—ë¬? ?ò—ñ–ë¬?
function setMakeTimeStrMaxWidth()
{
	local string timeStr;
	local int Width, Height;

	timeStr = GetSystemString(1199) $ " : " $ MakeTimeStr(1981320);
	GetTextSizeDefault(timeStr, Width, Height);
	// End:0x5E
	if(m_Tooltip.MinimumWidth < Width)
	{
		m_Tooltip.MinimumWidth = Width;
	}
}

//branch 110824
function AddTooltipItemWeaponLookChange(ItemInfo item)
{
	local ItemInfo tmpInfo;

	// End:0x145
	if(item.LookChangeItemID > 0 && item.Id.ClassID != 4442) //branch GD35_0828 2013-12-18 luciper3 - ?î‚Ññ¬±?ó–ê–? ?ï–ñ“ë–°¬∞–∂—ó–?..
	{
		AddCrossLine();

		if(item.BodyPart == 25 || item.BodyPart == 26 || item.BodyPart == 10) //?ó–º—ï–æ—ï–ó—ò—ò—ò¬??ë¬?
		{
			AddTooltipItemOption(5115, "", true, false, false,,,, GetColor(230, 230, 230, 255));
		}
		else if(EItemType(Item.ItemType) == ITEM_ARMOR)
		{
			AddTooltipItemOption(5101, "", true, false, false,,,,getColor(230, 230, 230, 255));
		}		
		else
		{
			AddTooltipItemOption(5082, "", true, false, false,,,,getColor(230, 230, 230, 255));
		}
		AddTooltipItemBlank(0);
		class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(item.LookChangeItemID), tmpInfo);
		addItemIconSmallType(tmpInfo, "");
		AddTooltipColorText(item.LookChangeItemName, GetColor(0, 255, 0, 255), false, true, false, "", 3, 3);
	}
}
//end of branch

//?î—â–Ö—î–ñ¬? ?ï–ñ–ê–ú–ï–´–ê–? ?î—â–Ö—î–ñ¬? ?ê–ú—ë¬? ?ó“ê–Ö–?
function AddTooltipItemQuestList(ItemInfo item)
{
	local int i, Count, QuestType;
	local string questTypeStr;

	// End:0x220 [Loop If]
	for(i = 0; i < MAX_RELATED_QUEST; i++)
	{
		// End:0x216
		if(item.RelatedQuestID[i] > 0)
		{
			questTypeStr = "";
			//?î—â–Ö—î–ñ¬? ?ï—ë–ê–? (?ò–¶¬∑–?, ?ñ–î–ñ—?, ?ê–ü–ê–?, ?Ññ–≠?î‚Ññ ¬±?ë—î–?)
			switch(class'UIDATA_QUEST'.static.GetQuestIscategory(item.RelatedQuestID[i], 1))
			{
				// End:0x6B
				case 0:
					questTypeStr = GetSystemString(862);
					// End:0x125
					break;
				// End:0xD7
				case 1:
					QuestType = class'UIDATA_QUEST'.static.GetQuestType(item.RelatedQuestID[i], 1);
					// End:0xC3
					if(QuestType == 4 || QuestType == 5)
					{
						questTypeStr = GetSystemString(2788); //?ê–ü–ê–? ?î—â–Ö—î–ñ¬? 
					}
					else
					{
						questTypeStr = GetSystemString(861);
					}
					// End:0x125
					break;
				// End:0xF0
				case 2:
					questTypeStr = GetSystemString(1998);
					// End:0x125
					break;
				// End:0x109
				case 3:
					questTypeStr = GetSystemString(1999);
					// End:0x125
					break;
				// End:0x122
				case 4:
					questTypeStr = GetSystemString(2000);
					// End:0x125
					break;
			}
			// End:0x146
			if(questTypeStr != "")
			{
				questTypeStr = "[" $ questTypeStr $ "]";
			}
			// End:0x216
			if(class'UIDATA_QUEST'.static.GetQuestName(item.RelatedQuestID[i]) != "")
			{
				// End:0x1CD
				if(Count == 0)
				{
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
					m_Info.bLineBreak = true;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = GetSystemString(1721);
					EndItem();
				}
				Count++;
				AddTooltipColorText(questTypeStr @ class'UIDATA_QUEST'.static.GetQuestName(item.RelatedQuestID[i]), GetColor(163, 163, 163, 255), true, true, false, "",0, TOOLTIP_LINE_HGAP);
			}
		}
	}
}

// ?ò–£—ò—î–ê–? ¬∑?Ññ?î¬ß¬∞–Ñ–ê¬? ?ê—å—ó–Ñ—î–á—ò—Ü—ó–? ?ê—ä–ê–?	//?ê–™¬∑–±¬∞–? ?ë‚Ññ?ï–ñ—ò¬? ?ê—å—ó–Ñ—î–á—ò—Ü—ó–? ?ë—ç—ï–æ—ñ–¶“ë–í“ë–?. 

function SetAttackAttribute(int Attvalue, int type)
{
	if(AttValue >= 375)	// 9¬∑??	375 ~ 450
	{
		AttackAttLevel[type] = 9;
		AttackAttMaxValue[type] = 75;
		AttackAttCurrValue[type] = AttValue - 375;
	}
	else if(AttValue >= 325)	// 8¬∑??	325 ~ 375
	{
		AttackAttLevel[type] = 8;
		AttackAttMaxValue[type] = 50;
		AttackAttCurrValue[type] = AttValue - 325;
	}
	else if(AttValue >= 300)	// 7¬∑??	300 ~ 325
	{
		AttackAttLevel[type] = 7;
		AttackAttMaxValue[type] = 25;
		AttackAttCurrValue[type] = AttValue - 300;
	}
	else if(AttValue >= 225)	// 6¬∑??	225 ~ 300
	{
		AttackAttLevel[type] = 6;
		AttackAttMaxValue[type] = 75;
		AttackAttCurrValue[type] = AttValue - 225;
	}
	else if(AttValue >= 175)	// 5¬∑??	175 ~ 225
	{
		AttackAttLevel[type] = 5;
		AttackAttMaxValue[type] = 50;
		AttackAttCurrValue[type] = AttValue - 175;
	}
	else if(AttValue >= 150)	// 4¬∑??	150 ~ 175
	{
		AttackAttLevel[type] = 4;
		AttackAttMaxValue[type] = 25;
		AttackAttCurrValue[type] = AttValue - 150;
	}
	else if(AttValue >= 75)	// 3¬∑??	75 ~ 150
	{
		AttackAttLevel[type] = 3;
		AttackAttMaxValue[type] = 75;
		AttackAttCurrValue[type] = AttValue - 75;
	}
	else if(AttValue >= 25)	// 2¬∑??	25~ 75
	{
		AttackAttLevel[type] = 2;
		AttackAttMaxValue[type] = 50;
		AttackAttCurrValue[type] = AttValue - 25;
	}
	else	// else 0~ 25
	{
		AttackAttLevel[type] = 1;
		AttackAttMaxValue[type] = 25;
		AttackAttCurrValue[type] = AttValue;
	}	
}
// ?ò–£—ò—î–ê–? ¬∑?Ññ?î¬ß¬∞–Ñ–ê¬? ?ê—å—ó–Ñ—î–á—ò—Ü—ó–? ?ê—ä–ê–?	//?ê–™¬∑–±¬∞–? ?ë‚Ññ?ï–ñ—ò¬? ?ê—å—ó–Ñ—î–á—ò—Ü—ó–? ?ë—ç—ï–æ—ñ–¶“ë–í“ë–?. 


function SetDefAttribute(int Defvalue, int type)
{
	if(DefValue >= 150)	// 9¬∑??		150~180
	{
		DefAttLevel[type] = 9;
		DefAttMaxValue[type] = 30;
		DefAttCurrValue[type] = DefValue - 150;
	}
	else if(DefValue >= 132)	// 8¬∑??	132 ~ 150
	{
		DefAttLevel[type] = 8;
		DefAttMaxValue[type] = 18;
		DefAttCurrValue[type] = DefValue - 132;
	}
	else if(DefValue >= 120)	// 7¬∑??	120 ~ 132
	{
		DefAttLevel[type] = 7;
		DefAttMaxValue[type] = 12;
		DefAttCurrValue[type] = DefValue - 120;
	}
	else if(DefValue >= 90)	// 6¬∑??	90 ~ 120
	{
		DefAttLevel[type] = 6;
		DefAttMaxValue[type] = 30;
		DefAttCurrValue[type] = DefValue - 90;
	}
	else if(DefValue >= 72)	// 5¬∑??	72 ~ 90
	{
		DefAttLevel[type] = 5;
		DefAttMaxValue[type] = 18;
		DefAttCurrValue[type] = DefValue - 72;
	}
	else if(DefValue >= 60)	// 4¬∑??	60 ~ 72
	{
		DefAttLevel[type] = 4;
		DefAttMaxValue[type] = 12;
		DefAttCurrValue[type] = DefValue - 60;
	}
	else if(DefValue >= 30)	// 3¬∑??	30 ~ 60
	{
		DefAttLevel[type] = 3;
		DefAttMaxValue[type] = 30;
		DefAttCurrValue[type] = DefValue - 30;
	}
	else if(DefValue >= 12)	// 2¬∑??	// 12 ~ 30
	{
		DefAttLevel[type] = 2;
		DefAttMaxValue[type] = 18;
		DefAttCurrValue[type] = DefValue - 12;
	}
	else	// else				// 0~ 12
	{
		DefAttLevel[type] = 1;
		DefAttMaxValue[type] = 12;
		DefAttCurrValue[type] = DefValue;
	}	
}

// BR ?ó–é—ñ–ö–ë—? ?ë¬§—î—?
function AddTooltipBR_MaxEnergy(ItemInfo item)
{
	//?ó–é—ñ–ö–ë—? ?ë¬§—î—?
	// End:0x170
	if(item.BR_MaxEnergy > 0)
	{
		//?î—É¬∞—à¬∞–?
		AddTooltipItemBlank(TOOLTIP_LINE_HGAP);
		//<?ó–é—ñ–ö–ë—? ?ë¬§—î—?>
		AddTooltipItemOption(5065, "", true, false, false);
		SetTooltipItemColor(230, 230, 230, 0);
		AddTooltipColorText(GetSystemString(5066), GetColor(163, 163, 163, 255), true, true);
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.bLineBreak = true;
		// End:0xED
		if(item.BR_CurrentEnergy==0 || (item.BR_MaxEnergy / item.BR_CurrentEnergy > 10))
		{
			m_Info.t_color.R = 255;
			m_Info.t_color.G = 0;
			m_Info.t_color.B = 0;
		}
		else
		{
			m_Info.t_color.R = 176;
			m_Info.t_color.G = 155;
			m_Info.t_color.B = 121;
		}
		m_Info.t_color.A = 255;
		m_Info.t_strText = " ";
		ParamAdd(m_Info.Condition, "Type", "CurrentEnergy");
		EndItem();
	}
}

// ?ë¬¶¬∑–? ?ò—ó¬∞—? 
function AddTooltipRefinery(ItemInfo item)
{
	local string strDesc1, strDesc2, strDesc3;
	local int ColorR, ColorG, ColorB, Quality;

	//?ë¬¶¬∑–ì–ò—ó¬∞—?
	if(item.RefineryOp1 != 0 || item.RefineryOp2 != 0)
	{
		AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_Refinery_small", GetSystemString(1490));
		SetTooltipItemColor(230, 230, 230, 0);

		//?î–ì¬∑–á¬∞–? ?ì–ª¬µ–?
		if(item.RefineryOp2 != 0)
		{
			Quality = class'UIDATA_REFINERYOPTION'.static.GetQuality(item.RefineryOp2);
			GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		}
		// End:0x1E5
		if(item.RefineryOp1 != 0)
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			// End:0x1E5
			if(class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp1, strDesc1, strDesc2, strDesc3))
			{
				// End:0x181
				if(Len(strDesc1) > 0)
				{
					AddTooltipColorText(strDesc1, GTColor().White, true, false, false);
				}
				// End:0x1B3
				if(Len(strDesc2) > 0)
				{
					AddTooltipColorText(strDesc2, GTColor().White, true, false, false);
				}
				// End:0x1E5
				if(Len(strDesc3) > 0)
				{
					AddTooltipColorText(strDesc3, GTColor().White, true, false, false);
				}
			}
		}

		// End:0x31E
		if(item.RefineryOp2 != 0)
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			// End:0x31E
			if(class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp2, strDesc1, strDesc2, strDesc3))
			{
				// End:0x2BA
				if(Len(strDesc1) > 0)
				{
					AddTooltipColorText(strDesc1, GTColor().White, true, false, false);
				}
				// End:0x2EC
				if(Len(strDesc2) > 0)
				{
					AddTooltipColorText(strDesc2, GTColor().White, true, false, false);
				}
				// End:0x31E
				if(Len(strDesc3) > 0)
				{
					AddTooltipColorText(strDesc3, GTColor().White, true, false, false);
				}
			}
		}

		//"¬∂?É–ê–ú—î–∫—ó–é—ò¬??ë–? ¬±?ñ–ò–?/¬µ–µ¬∑–£ ?î–¢¬∞–?"
		//"?ë–ë–ï–¥“ë–? ¬µ–µ¬∂?? ¬∞?é“ë–? ?ó¬©—î–? ?ñ–ó—î¬? ?ó–®—ï–? ?ó–?.
		// End:0x372
		if(!getInstanceUIData().getIsClassicServer())
		{
			AddTooltipItemOption(1491, "", true, false, false);
			SetTooltipItemColor(200, 200, 200, 255);
		}

		//?î—É¬∞—à¬∞–?
		AddTooltipItemBlank(2);
	}
}

function AddItemDesc(ItemInfo item, optional bool bDoNotUseLine)
{
	// End:0x53
	if(Len(item.Description) > 0)
	{
		// End:0x25
		if(bDoNotUseLine)
		{
			AddTooltipItemBlank(0);			
		}
		else
		{
			AddCrossLine();
			AddTooltipItemBlank(TOOLTIP_LINE_HGAP);
		}
		AddTooltipColorText(item.Description, GetColor(178, 190, 207, 255), true, false);
	}
}

function AddSecurityLock(ItemInfo item)
{
	// End:0x60
	if(item.bSecurityLock)
	{
		AddCrossLine();
		AddTooltipColorText("<" $ GetSystemString(3805) $ ">", GetColor(230, 230, 230, 255), false, false);
		AddTooltipColorText(GetSystemString(3806), GetColor(178, 190, 207, 255), true, false);
	}
}

function AddDeleteDBData(ItemInfo item)
{
	local string dbDeleteDateStr, dbDeleteRemainTimeStr;

	dbDeleteDateStr = class'UIDATA_ITEM'.static.GetDBDeleteDateString(item.nDBDeleteDate);
	dbDeleteRemainTimeStr = class'UIDATA_ITEM'.static.GetDBDeleteRemainTimeString(item.nDBDeleteDate);
	// End:0x1E2
	if(dbDeleteDateStr != "")
	{
		AddCrossLine();
		AddTooltipItemBlank(TOOLTIP_LINE_HGAP);
		AddTooltipColorText("<" $ GetSystemString(13406) $ ">", getInstanceL2Util().Red, true, false, false, "", 0, 0);
		addTooltipTexture("L2UI_ct1.DailyMissionWnd.DailyMissionWnd_IconTime", 16, 16, 0, 0, true, true, 0, 1);
		AddTooltipColorText(dbDeleteDateStr, getInstanceL2Util().White, false, true, false, "", 0, 0);
		AddTooltipColorText(" (", getInstanceL2Util().PowderPink, false, true, false, "", 0, 0);
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.bLineBreak = false;
		m_Info.t_bDrawOneLine = true;
		m_Info.nOffSetY = 0;
		m_Info.t_color = getInstanceL2Util().PowderPink;
		m_Info.t_strText = dbDeleteDateStr;
		ParamAdd(m_Info.Condition, "Type", "DBDeleteRemainTime");
		ParamAdd(m_Info.Condition, "Value", string(item.nDBDeleteDate));
		EndItem();
		AddTooltipColorText(")", getInstanceL2Util().PowderPink, false, true, false, "", 0, 0);
	}
}

function AddAutomaticUseItem(ItemInfo item)
{
	// End:0x7E
	if(item.bSimpleExchangeItem == true)
	{
		AddTooltipItemBlank(0);
		addTexture("L2UI_NewTex.ToolTip.TooltipIcon_Swipe", 24, 24, 32, 32, -2, 0);
		AddTooltipColorText(GetSystemString(14289), getInstanceL2Util().Green, false, false, false, "", 2, 6);
		return;
	}
	// End:0xA6
	if(class'UIDATA_ITEM'.static.IsDefaultActionPeel(item.Id.ClassID))
	{
		AddTooltipItemBlank(0);
		addTexture("L2UI_ct1.AutoShotItemWnd.AutoAllArrow_On", 24, 24, 32, 32, -2, 0);
		AddTooltipColorText(GetSystemString(14087), getInstanceL2Util().Green, false, false, false, "", 2, 6);
		return;
	}
	switch(class'UIDATA_ITEM'.static.GetAutomaticUseItemType(item.Id.ClassID))
	{
		// End:0x13C
		case AUIT_ITEM:
			AddTooltipItemBlank(0);
			addTexture("L2UI_ct1.AutoShotItemWnd.AutoAllArrow_On", 24, 24, 32, 32, -2, 0);
			AddTooltipColorText(GetSystemString(3962), getInstanceL2Util().Green, false, false, false, "", 2, 6);
			// End:0x217
			break;
		// End:0x1A8
		case AUIT_HP_POTION:
			AddTooltipItemBlank(0);
			addTexture("L2UI_CT1.AutoPotionTooltipICON", 24, 24, 32, 32, -2, 0);
			AddTooltipColorText(GetSystemString(13007), getInstanceL2Util().DRed, false, false, false, "", 2, 6);
			// End:0x217
			break;
		// End:0x214
		case AUIT_HP_PET_POTION:
			AddTooltipItemBlank(0);
			addTexture("L2UI_CT1.AutoPotionTooltipICON", 24, 24, 32, 32, -2, 0);
			AddTooltipColorText(GetSystemString(13382), getInstanceL2Util().DRed, false, false, false, "", 2, 6);
			// End:0x217
			break;
	}
}

function AddEnsoulOption(ItemInfo weaponInfo)
{
	local EnsoulOptionUIInfo optionInfo;
	local int i, N, Cnt, optionId;
	local bool bUseTitle;
	local int nNormalCount, nBMCount;

	// End:0x177
	if(getInstanceUIData().getIsClassicServer())
	{
		// End:0x53
		if(weaponInfo.ItemType == EItemType.ITEM_WEAPON || weaponInfo.ItemType == EItemType.ITEM_ARMOR || weaponInfo.ItemType == EItemType.ITEM_ACCESSARY)
		{			
		}
		else
		{
			return;
		}

		// End:0x98 [Loop If]
		for(i = 1; i < EIST_MAX; i++)
		{
			Cnt = Cnt + weaponInfo.EnsoulOption[i - 1].OptionArray.Length;
		}
		nNormalCount = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(weaponInfo.Id, 1);
		nBMCount = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(weaponInfo.Id, 2);
		// End:0x174
		if(Cnt == 0 && nNormalCount + nBMCount > 0)
		{
			AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_EnSoul_small", GetSystemString(13725), true);
			AddEnsoulOptionSlotIcon(weaponInfo);
			AddTooltipItemBlank(2);
			AddTooltipColorText(GetSystemString(3393), GTColor().Gray, true, false, false, "", 0, 0);
			return;
		}		
	}
	else
	{
		// End:0x18C
		if(weaponInfo.ItemType == EItemType.ITEM_WEAPON || weaponInfo.ItemType == EItemType.ITEM_ARMOR || weaponInfo.ItemType == EItemType.ITEM_ACCESSARY)
		{
		}
		else
		{
			return;
		}
	}

	bUseTitle = true;

	// ?ë—ç–ò“? ?Ö–ì–Ö—î–ï–? ¬∞?ñ–ñ–? (2015-02-09 ?ì–?¬∞??)
	// End:0x422 [Loop If]
	for(i = EIST_NORMAL; i < EIST_MAX; i++)
	{
		Cnt = weaponInfo.EnsoulOption[i - EIST_NORMAL].OptionArray.Length;

		// End:0x418 [Loop If]
		for(N = EISI_START; N < EISI_START + Cnt; N++)
		{
			optionId = weaponInfo.EnsoulOption[i - EIST_NORMAL].OptionArray[N - EISI_START];
			// End:0x40E
			if(optionId > 0)
			{
				// End:0x2EA
				if(bUseTitle)
				{
					// End:0x296
					if(getInstanceUIData().getIsClassicServer())
					{
						AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_EnSoul_small", GetSystemString(13725), true);
						bUseTitle = false;
						AddEnsoulOptionSlotIcon(weaponInfo);
						addToolTipDrawList(m_Tooltip, addDrawItemBlank(3));						
					}
					else
					{
						AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_EnSoul_small", GetSystemString(3394));
						SetTooltipItemColor(230, 230, 230, 0);
						bUseTitle = false;
					}
				}
				GetEnsoulOptionUIInfo(optionId, optionInfo);
				addToolTipDrawList(m_Tooltip, addDrawItemTexture(optionInfo.Icontex, false, false, 2, 0));
				addToolTipDrawList(m_Tooltip, addDrawItemText("", getInstanceL2Util().White, "", false,, 4, 4));
				// End:0x3A1
				if(optionInfo.OptionStep > 0)
				{
					addToolTipDrawList(m_Tooltip, addDrawItemText(MakeFullSystemMsg(GetSystemMessage(4347), optionInfo.Name, string(optionInfo.OptionStep)), getInstanceL2Util().ColorYellow, "", false));
				}
				else
				{
					addToolTipDrawList(m_Tooltip, addDrawItemText(optionInfo.Name, getInstanceL2Util().ColorYellow, "", false));
				}

				addToolTipDrawList(m_Tooltip, addDrawItemText(optionInfo.Desc, getInstanceL2Util().ColorGray, "", true));
				addToolTipDrawList(m_Tooltip, addDrawItemBlank(3));
			}
		}
	}
}

function AddEnsoulOptionSlotIcon(ItemInfo weaponInfo)
{
	local EnsoulOptionUIInfo optionInfo;
	local int i, N, M, Cnt, optionId, nNormalCount,
		nBMCount, nFirstX;

	nFirstX = 4;
	nNormalCount = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(weaponInfo.Id, 1);
	nBMCount = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(weaponInfo.Id, 2);

	// End:0x4BD [Loop If]
	for(i = 1; i < TOOLTIP_SETITEM_MAX; i++)
	{
		Cnt = weaponInfo.EnsoulOption[i - 1].OptionArray.Length;
		// End:0x125
		if(i == 1)
		{
			// End:0x117 [Loop If]
			for(M = 0; M < (nNormalCount - Cnt); M++)
			{
				weaponInfo.EnsoulOption[i - 1].OptionArray.Insert(weaponInfo.EnsoulOption[i - 1].OptionArray.Length, 1);
				weaponInfo.EnsoulOption[i - 1].OptionArray[weaponInfo.EnsoulOption[i - 1].OptionArray.Length - 1] = 0;
			}
			Cnt = nNormalCount;			
		}
		else
		{
			// End:0x1CD
			if(i == 2)
			{
				// End:0x1C2 [Loop If]
				for(M = 0; M < (nBMCount - Cnt); M++)
				{
					weaponInfo.EnsoulOption[i - 1].OptionArray.Insert(weaponInfo.EnsoulOption[i - 1].OptionArray.Length, 1);
					weaponInfo.EnsoulOption[i - 1].OptionArray[weaponInfo.EnsoulOption[i - 1].OptionArray.Length - 1] = 0;
				}
				Cnt = nBMCount;
			}
		}

		// End:0x4B3 [Loop If]
		for(N = 1; N < (1 + Cnt); N++)
		{
			optionId = weaponInfo.EnsoulOption[i - 1].OptionArray[N - 1];
			// End:0x37E
			if(optionId > 0)
			{
				GetEnsoulOptionUIInfo(optionId, optionInfo);
				// End:0x2D0
				if(i == 1)
				{
					addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotBG", 18, 18, 18, 18, false, false, nFirstX, 2);
					addTooltipTexture(optionInfo.Icontex, 14, 14, 14, 14, false, false, -14, 4);
					addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotTop", 18, 18, 18, 18, false, false, -16, 2);					
				}
				else
				{
					// End:0x37B
					if(i == 2)
					{
						addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotBG", 18, 18, 18, 18, false, false, nFirstX, 2);
						addTooltipTexture(optionInfo.Icontex, 14, 14, 14, 14, false, false, -14, 4);
						addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotTop_Rare", 18, 18, 18, 18, false, false, -16, 2);
					}
				}				
			}
			else
			{
				// End:0x409
				if(i == 1)
				{
					addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotBG", 18, 18, 18, 18, false, false, nFirstX + 2, 2);
					addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotTop", 18, 18, 18, 18, false, false, -18, 2);					
				}
				else
				{
					// End:0x497
					if(i == 2)
					{
						addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotBG", 18, 18, 18, 18, false, false, nFirstX + 2, 2);
						addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotTop_Rare", 18, 18, 18, 18, false, false, -18, 2);
					}
				}
			}
			// End:0x4A9
			if(nFirstX > 0)
			{
				nFirstX = 0;
			}
		}
	}
}

// <?ê–û–ì¬¶–ñ¬??ò—ó¬∞—?> ,(<?ê–û–ì¬¶–ñ¬? ?ò—ó¬∞—?> ?Ññ–ß ?ò—ñ—ë–?),  (?î“ê—ó—â–î“ê—ò¬?, ?Ññ–∂?ï–æ¬±—? ¬∞?û–ê–û¬µ–?) 
function AddTooltipEventSeventhdayOfSeventhMonth(ItemInfo item)
{
}

// ?ï—Ö—ó¬µ—î“ë¬±–?, ?ñ¬ª¬±—ë¬µ¬?
function AddTooltipItemDurability(ItemInfo item)
{
	local Color tempColor;

	// ?ï—Ö—ó¬µ—î“ë¬±–? ?ó“ê–Ö–?, ?ñ¬ª¬±—ë¬µ¬? ?ï–ñ–ê–ú–ï–?, ?ó–§—ò—Ü¬∑–? ¬ª¬©?ë–? ¬µ??
	// End:0xDE
	if(item.CurrentDurability >= 0 && item.Durability > 0)
	{
		//?î—É¬∞—à¬∞–?
		AddTooltipItemBlank(TOOLTIP_LINE_HGAP);

		//<?ï—Ö—ó¬? ?î“ë¬±–? ?ë¬§—î—?>
		AddTooltipItemOption(1492, "", true, false, false);
		SetTooltipItemColor(230, 230, 230, 0);

		// ?ê–??ë—ë—ë¬∂¬∑–?/?ì–°—ë¬∂¬∑–?:
		AddTooltipColorText(GetSystemString(1493), GetColor(163, 163, 163, 255), true, true);
		// End:0x91
		if(item.CurrentDurability + 1 <= 5)
		{
			tempColor = GetColor(255, 0, 0, 255);
		}
		else
		{
			tempColor = GetColor(176, 155, 121, 255);
		}
		// ?ê–??ë—ë—ë¬∂¬∑–?/?ì–°—ë¬∂¬∑–?   <- ?ò—Ü–î–?
		AddTooltipColorText(" " $ item.CurrentDurability $ "/" $ item.Durability, tempColor, false, true);
		AddTooltipItemBlank(TOOLTIP_LINE_HGAP);
	}
}

//branch, p?ë¬∂–ï¬? 13 x 13 ?Ö–ô—î—?, ?ó–®—ó–? ?í–? ?î—ñ–Ö¬? ?ï–ñ–ê–ú–ï–´—ó–? ?î–©“ë–? ¬µ–Ω.
function int AddPrimeItemSymbol(ItemInfo item, optional bool bFirstLineWidthCount)
{
	local int nSumWidth;
	local string TextureName;

	// End:0x17
	if(item.IsBRPremium != 2)
	{
		return nSumWidth;
	}
	TextureName = GetPrimeItemSymbolName();
	// End:0xC9
	if(Len(TextureName) > 0)
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.nOffSetX = 4;
		m_Info.nOffSetY = 1;
		m_Info.u_nTextureWidth = 14;
		m_Info.u_nTextureHeight = 14;
		m_Info.u_nTextureUWidth = 14;
		m_Info.u_nTextureUHeight = 14;
		m_Info.u_strTexture = TextureName;
		EndItem();
		nSumWidth = (nSumWidth + m_Info.u_nTextureUWidth) + m_Info.nOffSetX;
	}
	return nSumWidth;
}
//end of branch

function AddEnchantEffectDescTooltip(ItemInfo item)
{
	local int i;
	local array<string> descriptions;
	local int nFontLevel;

	// End:0xB5
	if(class'UIDATA_ITEM'.static.GetEnchantedItemSkillDesc(item.Id.ClassID, item.Enchanted, descriptions, nFontLevel))
	{
		AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_Enchant_small", GetSystemString(2214));

		// End:0xB3 [Loop If]
		for (i = 0; i < descriptions.Length; i++)
		{
			AddTooltipColorText(descriptions[i], GetColorEnchentEffectDescFontLevel(nFontLevel), true, false, false);
		}
	}
}

function Color GetColorEnchentEffectDescFontLevel(int nFontLevel)
{
	switch(nFontLevel)
	{
		// End:0x1A
		case 1:
			return GetColor(255, 229, 127, 255);
		// End:0x2E
		case 2:
			return GetColor(103, 120, 255, 255);
		// End:0x42
		case 3:
			return GetColor(203, 119, 251, 255);
		// End:0x55
		case 4:
			return GetColor(220, 0, 254, 255);
		// End:0xFFFF
		default:
			return GetColor(255, 0, 0, 255);
	}
}

//?ò—ò–ñ¬? ?ï–ñ–ê–ú–ï–?.
function AddSetitemTooltip(ItemInfo item)
{
	local int i;
	local int j;
	local string strTmp;
	local ItemID tmpItemID;
	local int setId;
	//?ì–? ?ò—ò–ñ¬? ?ï–ñ–ê–ú–ï–? ¬∞?ñ—ò—?
	local int totalNum;

	local bool IsSigil;
	local ItemInfo tmpInfo;
	local bool bSetDrawTitle;

	//?ï–ñ–ê–ú–ï–´–ê–û–ë—? ?ò¬??ê–?.
	// End:0x8FF
	if(IsValidItemID(item.Id))
	{
		//SetItemLineInsert(Item.ID, 0);
		//AddTooltipItemBlank(4);
		//AddCrossLine();

		//TOOLTIP_SETITEM_MAX ?ì–? 3?ë—ï¬∑—â–ê–? setitem?ê–? ?ë—ë–ê–? ?ó–?.
		//0 -> 5?ò—ò–ñ¬?¬∑?? ?ë—ë¬µ–π—ï–æ–ë—? ?ï–ñ–ê–ú–ï–? (?ó–ø—ë–?, ¬∞?û‚Ññ–≠, ?ò–¥¬∞¬?, ¬∞?ó–ñ–Ü¬∑—?, ?î–û–ì—?)
		//1 -> ?Ö–á¬µ–?, ?Ö–ì¬±–∂–ê–? ?ì–?¬∞?é¬µ–? ?ò—ò–ñ¬?
		//2 -> ?? ?ê–¶“ë–í–ë—? ?ë—??ë¬?. ?ñ–Ñ–ë–??ê¬? ?ê¬ß–ó–? ?ë—ë¬µ–π—ï–æ–ë—à¬µ–?.
		// End:0x3D2 [Loop If]
		for (i = 0; i < TOOLTIP_SETITEM_MAX; i++)
		{
			//?ò—ò–ñ¬??ï–ñ–ê–ú–ï–? ?ë¬??Ö—î–ñ¬?
			//GetSetItemNum ¬∞?? ?ò–í–ñ¬? ?ï–ñ–ê–ú–ï–´–ê–? ¬∞?ñ—ò—?.

			// End:0x3C8 [Loop If]
			for(setId = 0; setId < class'UIDATA_ITEM'.static.GetSetItemNum(item.Id, i); setId++) //0,1,2?Ññ?? ?ò—ò–ñ¬??ï–ñ–ê–ú–ï–´–ò—ó¬∞—? ?ó–? ?ë–ª–ó–®—ò¬? ¬∞?û¬∞—? ?ë–æ¬∞–é–ë—Ü–ê–? ?ò—ò–ñ¬?¬∞?? ?ó–ü—î—Å¬µ–ó—ï–??ó–ü—ñ–?..
			{
				tmpItemID.ClassID = class'UIDATA_ITEM'.static.GetSetItemFirstID(item.Id, i, setId);
				//?ò—ò–ñ¬??ï–ñ–ê–ú–ï–´–ê–? ?ë—ï¬∑—? ?ì–?¬∞?? ?Ññ–ß ?ê–´—ó–ª–ó–? ?ò—ò–ñ¬? ?ï–ñ–ê–ú–ï–? ?ï¬?¬∂?É–ê–ú—ï—??ñ¬??ó–é—ò¬? ?ò¬??ê–?.
				// End:0x3BE
				if(tmpItemID.ClassID > 0)
				{
					// End:0x12B
					if(bSetDrawTitle == false)
					{
						// End:0xE7
						if(IsAdenServer())
						{
							AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_Set_small", GetSystemString(3881));							
						}
						else
						{
							AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_Set_small", GetSystemString(2347));
						}
						bSetDrawTitle = true;
					}
					strTmp = class'UIDATA_ITEM'.static.GetItemName(tmpItemID);
					class'UIDATA_ITEM'.static.GetItemInfo(tmpItemID, tmpInfo);
					addItemIconSmallType(tmpInfo, "");

					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.nOffSetY = 0;
					m_Info.bLineBreak = false;
					m_Info.t_bDrawOneLine = false;
					SetTooltipTextColor(100, 100, 65, 255);

					//0 -> 5?ò—ò–ñ¬?¬∑?? ?ë—ë¬µ–π—ï–æ–ë—? ?ï–ñ–ê–ú–ï–? (?ó–ø—ë–?, ¬∞?û‚Ññ–≠, ?ò–¥¬∞¬?, ¬∞?ó–ñ–Ü¬∑—?, ?î–û–ì—?)
					// End:0x2AF
					if(i == 0)
					{
						m_Info.t_strText = " " $ strTmp;
						ParamAdd(m_Info.Condition, "SetItemNum", string(i));
						ParamAdd(m_Info.Condition, "Type", "Equip");
						ParamAddItemID(m_Info.Condition, item.Id);
						ParamAdd(m_Info.Condition, "CurTypeID", string(setId));		//?î—Å¬±—ñ–ó–? ?ï–ñ–ê–ú–ï–´–ê–? Type ?ó‚Ññ(0?Ññ??:?ò–¥¬∞¬? 1?Ññ??:¬∞?û‚Ññ–≠ 2?Ññ??:?ó–ø—ë–? 3?Ññ??:?ñ–? 4?Ññ?? ?ë–©—ë¬? ..ItemName.txt?ó–? ¬µ–π?ï–æ–ê–¶“ë–í—ò—à—ò¬?
						ParamAdd(m_Info.Condition, "NormalColor", "100,100,65");
						ParamAdd(m_Info.Condition, "EnableColor", "255,250,160");
						totalNum = setId;
					}
					//1 -> ?Ö–á¬µ–?, ?Ö–ì¬±–∂–ê–? ?ì–?¬∞?é¬µ–? ?ò—ò–ñ¬?
					else if(i == 1)
					{
						m_Info.t_strText = "- (+) " $ strTmp;
						ParamAdd(m_Info.Condition, "SetItemNum", string(i));
						ParamAdd(m_Info.Condition, "Type", "Equip");
						ParamAddItemID(m_Info.Condition, item.Id);
						ParamAdd(m_Info.Condition, "CurTypeID", string(setId));		//?î—Å¬±—ñ–ó–? ?ï–ñ–ê–ú–ï–´–ê–? Type ?ó‚Ññ(0?Ññ??:?ò–¥¬∞¬? 1?Ññ??:¬∞?û‚Ññ–≠ 2?Ññ??:?ó–ø—ë–? 3?Ññ??:?ñ–? 4?Ññ?? ?ë–©—ë¬? ..ItemName.txt?ó–? ¬µ–π?ï–æ–ê–¶“ë–í—ò—à—ò¬?
						ParamAdd(m_Info.Condition, "NormalColor", "100,70,0");
						ParamAdd(m_Info.Condition, "EnableColor", "255,180,0");
						IsSigil = IsSigilArmor(tmpItemID);
					}
					EndItem();
					AddTooltipItemBlank(1);
				}
			}
		}

		// End:0x74E [Loop If]
		for (i = 0; i < TOOLTIP_SETITEM_MAX ; i++)
		{
			//?ò–í–ñ¬??ò—ó¬∞—?
			// End:0x744 [Loop If]
			for(j = 0; j < class'UIDATA_ITEM'.static.GetSetItemPeaceEffectNum(item.Id, i); j++)
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
				m_Info.bLineBreak = true;
				m_Info.t_bDrawOneLine = true;
				SetTooltipTextColor(100, 70, 0, 255);
				//0 -> 5?ò—ò–ñ¬?¬∑?? ?ë—ë¬µ–π—ï–æ–ë—? ?ï–ñ–ê–ú–ï–? (?ó–ø—ë–?, ¬∞?û‚Ññ–≠, ?ò–¥¬∞¬?, ¬∞?ó–ñ–Ü¬∑—?, ?î–û–ì—?)
				// End:0x493
				if(i == 0)
				{
					m_Info.t_strText = string(j + 2) $ GetSystemString(2345) $ " : ";
				}
				else if(i == 1)
				{
					//branch 110824
					// End:0x4E7
					if(IsSigil == true)
					{
						m_Info.t_strText = string(totalNum + 1) $ GetSystemString(2345)$ "+" $ GetSystemString(1987) $ ": ";
					}
					else
					{
						m_Info.t_strText = string(totalNum + 1) $ GetSystemString(2345)$ "+" $ GetSystemString(2346) $ ": ";
					}
					//end of branch
				}
				ParamAdd(m_Info.Condition, "Type", "SetEffect");
				ParamAddItemID(m_Info.Condition, item.Id);
				ParamAdd(m_Info.Condition, "EffectID", string(i));
				ParamAdd(m_Info.Condition, "SetEffectIndex", string(j));
				ParamAdd(m_Info.Condition, "NormalColor", "100,70,0");
				ParamAdd(m_Info.Condition, "EnableColor", "255,180,0");
				EndItem();
				strTmp = class'UIDATA_ITEM'.static.GetSetItemPeaceEffectDescription(item.Id, i, j);
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
				SetTooltipTextColor(68, 68, 68, 255);
				m_Info.t_strText = strTmp;
				ParamAdd(m_Info.Condition, "Type", "SetEffect");
				ParamAddItemID(m_Info.Condition, item.Id);
				ParamAdd(m_Info.Condition, "EffectID", string(i));
				ParamAdd(m_Info.Condition, "SetEffectIndex", string(j));
				ParamAdd(m_Info.Condition, "NormalColor", "68,68,68");
				ParamAdd(m_Info.Condition, "EnableColor", "200,200,200");
				EndItem();
			}
		}

		for(j = 0; j < class'UIDATA_ITEM'.static.GetItemSetEnchantEffectNum(item.Id) ; j++)
		{
			//?ê–û–ì—ï–ñ¬? ?ò–í–ñ¬??ò—ó¬∞—?
			strTmp = class'UIDATA_ITEM'.static.GetSetItemEnchantEffectDescription(item.Id, j);
			// End:0x8F5
			if(Len(strTmp) > 0)
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
				m_Info.bLineBreak = true;
				m_Info.t_color.R = 110;
				m_Info.t_color.G = 140;
				m_Info.t_color.B = 170;
				m_Info.t_color.A = 255;
				m_Info.t_strText = strTmp;
				ParamAdd(m_Info.Condition, "Type", "EnchantEffect");
				ParamAddItemID(m_Info.Condition, item.Id);
				ParamAdd(m_Info.Condition, "NormalColor", "74,92,104");
				ParamAdd(m_Info.Condition, "EnableColor", "110,140,170");
				ParamAdd(m_Info.Condition, "SetEnchantEffectIndex", string(j));  //?ì–?¬∞?é¬µ–? 2013.01.23 ?ë¬§—ó–º¬±–?
				EndItem();
			}
		}
	}
}

/**
 * ?ê—å–ê–? ¬ª?É–ï–í—ó–? ¬µ?ã—ë“? ?Ö—î–ñ¬??ë¬? ?ë¬??ï–? 
 * 0, 1, 2, 3, 4  (?ë–ï—ó–º—ó¬??ò—?, ?ó¬??ò—?, ?ë–ª–ê–?, ?ó–º—ò—?, ?ë–ï—ó–º¬∞¬??ò—?)
 **/
function string getWarSituationString(int warSituation)
{
	local string returnStr;

	switch(warSituation)
	{
		// End:0x26
		case 0:
			returnStr = returnStr $ GetSystemString(2355);
			// End:0xA8
			break;
		// End:0x45
		case 1:
			returnStr = returnStr $ GetSystemString(2354);
			// End:0xA8
			break;
		// End:0x65
		case 2:
			returnStr = returnStr $ GetSystemString(2353);
			// End:0xA8
			break;
		// End:0x85
		case 3:
			returnStr = returnStr $ GetSystemString(2352);
			// End:0xA8
			break;
		// End:0xA5
		case 4:
			returnStr = returnStr $ GetSystemString(2351);
			// End:0xA8
			break;
	}

	return returnStr;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------
//  ?ï—à–ñ–? ?ë¬∂¬∞–? ¬∞?õ¬ª–? ?ó–§—ò—Ü¬µ–? ?ë—??ê–? 
//----------------------------------------------------------------------------------------------------------------------------------------------------
function bool IsEnchantableItem(EItemParamType Type)
{
	return (Type == ITEMP_WEAPON || Type == ITEMP_ARMOR || Type == ITEMP_ACCESSARY || Type == ITEMP_SHIELD);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------
//  ?ï—à–ñ–? ¬ª?ç—ò—?, ¬±–≤?î¬? ?ó–§—ò—? (¬∞?é–ê–? ¬±–≤?î¬ª–ê–? ¬µ?ó“ë–? ¬∞?ù¬µ–π—ë—? ?ñ–¶–ê¬? ¬∞??)
//----------------------------------------------------------------------------------------------------------------------------------------------------
function ClearTooltip()
{
	m_Tooltip.SimpleLineCount = 0;
	m_Tooltip.MinimumWidth = 0;
	m_Tooltip.DrawList.Remove(0, m_Tooltip.DrawList.Length);
}

function StartItem()
{
	local DrawItemInfo infoClear;
	m_Info = infoClear;
}

function EndItem()
{
	m_Tooltip.DrawList.Length = m_Tooltip.DrawList.Length + 1;
	m_Tooltip.DrawList[m_Tooltip.DrawList.Length - 1] = m_Info;
}

//?ï—à–ñ–? Text ¬ª?Ü¬ª—? ?î–á¬∞–?.
function SetTooltipTextColor(int R, int G, int B, int A)
{
	m_Info.t_color.R = R;
	m_Info.t_color.G = G;
	m_Info.t_color.B = B;
	m_Info.t_color.A = A;
}

//?ï—à–ñ–? Text 
function SetTooltipText(string strDesc, bool bLineBreak, bool t_bDrawOneLine, optional bool isFirstLine)
{
	m_Info.eType = DIT_TEXT;
	// End:0x25
	if(! isFirstLine)
	{
		m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
	}
	m_Info.t_strText = strDesc;
	m_Info.bLineBreak = bLineBreak;
	m_Info.t_bDrawOneLine = t_bDrawOneLine;
}

// ?ë–? ¬±–ß?ë¬?¬±–≤, ?ì–¶—ò–? ¬ª–∑?ê–ú–ë–æ—ë¬? ?ë—Ü–ë¬? ¬∞?é“ë–ô–ó–ü¬µ¬µ¬∑–? ?ò—Ü–ë¬? (2016-04)
function AddCrossLine()
{
	// End:0xB2
	if(m_Tooltip.DrawList.Length > 1)
	{
		// End:0x64
		if(m_Tooltip.DrawList[m_Tooltip.DrawList.Length - 2].u_strTexture == "L2UI_NewTex.Tooltip.TooltipLine_BasicShotBG")
		{
			return;
		}
		// End:0xB2
		if(m_Tooltip.DrawList[m_Tooltip.DrawList.Length - 2].u_strTexture == "L2UI_NewTex.Tooltip.TooltipLine_Unable")
		{
			return;
		}
	}
	AddTooltipItemBlank(4);

	StartItem();
	m_Info.eType = DIT_SPLITLINE;
	m_Info.u_nTextureUWidth = TOOLTIP_MINIMUM_WIDTH;
	m_Info.u_nTextureHeight = 1;
	m_Info.u_strTexture = "L2ui_ch3.tooltip_line";
	EndItem();
	AddTooltipItemBlank(4);
}

function AddCrossLineThick()
{
	AddTooltipItemBlank(0);
	StartItem();
	m_Info.eType = DIT_SPLITLINE;
	m_Info.u_nTextureUWidth = TOOLTIP_MINIMUM_WIDTH;
	m_Info.u_nTextureHeight = 7;
	m_Info.u_strTexture = "L2UI_NewTex.Tooltip.TooltipLine_BasicShotBG";
	EndItem();
	AddTooltipItemBlank(0);
}

// ¬±–≤?î¬ª–ê—ã–ê–? ?ï–®–Ö—î–ñ¬??ë¬? ?ñ–¶–Ö–ê“ë–ü“ë–?. 
function AddTooltipText(string strDesc, bool bLineBreak, bool t_bDrawOneLine, optional bool isFirstLine, optional string FontName, optional int OffsetX, optional int OffsetY)
{
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	StartItem();
	GetItemTextSectionInfos(strDesc, FullText, TextInfos);
	// End:0x42
	if(TextInfos.Length > 0)
	{
		strDesc = FullText;
		m_Info.t_SectionList = TextInfos;
	}
	m_Info.eType = DIT_TEXT;
	// End:0x67
	if(! isFirstLine)
	{
		m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
	}

	m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
	m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
	m_Info.t_strFontName = FontName;
	m_Info.t_strText = strDesc;
	m_Info.bLineBreak = bLineBreak;
	m_Info.t_bDrawOneLine = t_bDrawOneLine;
	EndItem();
}

// ¬±–≤?î¬ª–ê—ã–ê–? ?î¬?¬∂?? ?ï–®–Ö—î–ñ¬??ë¬? ?ñ–¶–Ö–ê“ë–ü“ë–?.
function AddTooltipColorText(string strDesc, Color TextColor, bool bLineBreak, bool t_bDrawOneLine, optional bool isFirstLine, optional string FontName, optional int OffsetX, optional int OffsetY)
{
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	StartItem();
	GetItemTextSectionInfos(strDesc, FullText, TextInfos);
	// End:0x42
	if(TextInfos.Length > 0)
	{
		strDesc = FullText;
		m_Info.t_SectionList = TextInfos;
	}
	m_Info.eType = DIT_TEXT;
	// End:0x67
	if(! isFirstLine)
	{
		m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
	}
	m_Info.bLineBreak = bLineBreak;
	m_Info.t_bDrawOneLine = t_bDrawOneLine;
	m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
	m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
	m_Info.t_strFontName = FontName;
	m_Info.t_color = TextColor;
	m_Info.t_strText = strDesc;
	m_Info.nOffSetX = OffsetX;
	m_Info.nOffSetY = OffsetY;
	EndItem();
}

// ?ï–ñ¬∞–é–Ö–ì—ó–? ?Ö—î–ï—? ?ï—à–ñ–?
function AddAgathionSkillTooltip(ItemInfo Info)
{
	local array<SkillInfo> mainSkillList, subSkillList;
	local int i;
	local Color titleColor, DescColor;

	GetAgathionMainSkillList(Info.Id.ClassID, Info.Enchanted, mainSkillList);
	//Debug ("?ï–ñ¬∞–é–Ö–ì—ó–? ?ï–ñ–ê–ú–ï–? ?ë–??ê–? " @  mainSkillList.Length) ;//getAgathionIndex (info.ID) @ info.Enchanted);

	GetAgathionSubSkillList(Info.Id.ClassID, Info.Enchanted, subSkillList);
	//Debug ("?ï–ñ¬∞–é–Ö–ì—ó–? ?ï–ñ–ê–ú–ï–? ?ò¬??î–? " @ subSkillList.Length) ;

	// ?ó–®“ë–? ?ï–ñ–ê–ú–ï–´–ê–? ?ë–??ê–? ?ê–? ¬∞–∂?ó–? ?ë–??ê–û¬∞—? ?ò¬??î–? ?ë—?¬µ?? ?ò¬∞—ò—î–ò¬? ?î–ì¬∑–?
	// End:0x1C7
	if(mainSkillList.Length > 0)
	{
		// End:0xDB
		if(GetAgathionIndex(Info.Id) == 0)
		{
			titleColor.R = 255;
			titleColor.G = 153;
			titleColor.B = 153;
			titleColor.A = 255;
			DescColor.R = 182;
			DescColor.G = 182;
			DescColor.B = 182;
			DescColor.A = 255;
		}
		else
		{
			titleColor.R = 100;
			titleColor.G = 70;
			titleColor.B = 70;
			titleColor.A = 255;
			DescColor.R = 68;
			DescColor.G = 68;
			DescColor.B = 68;
			DescColor.A = 255;
		}
		AddTooltipItemBlank(4);
		AddTooltipColorText(GetSystemString(3640), titleColor, true, false);
		AddTooltipItemBlank(2);

		// End:0x1C7 [Loop If]
		for (i = 0; i < mainSkillList.Length; i++)
		{
			AddTooltipColorText(" - ", DescColor, true, false);
			AddTooltipColorText(mainSkillList[i].SkillDesc, DescColor, false, false);
			AddTooltipItemBlank(2);
		}
	}
	// End:0x35E
	if(subSkillList.Length > 0)
	{
		// End:0x272
		if(GetAgathionIndex(Info.Id) > 0 || GetAgathionIndex(Info.Id) == 0)
		{
			titleColor.R = 255;
			titleColor.G = 153;
			titleColor.B = 153;
			titleColor.A = 255;
			DescColor.R = 182;
			DescColor.G = 182;
			DescColor.B = 182;
			DescColor.A = 255;
		}
		else
		{
			titleColor.R = 100;
			titleColor.G = 70;
			titleColor.B = 70;
			titleColor.A = 255;
			DescColor.R = 68;
			DescColor.G = 68;
			DescColor.B = 68;
			DescColor.A = 255;
		}
		AddTooltipItemBlank(4);
		AddTooltipColorText(GetSystemString(3641), titleColor, true, false);
		AddTooltipItemBlank(2);
		// End:0x35E [Loop If]
		for (i = 0 ; i < subSkillList.Length ; i++) 
		{
			AddTooltipColorText(" - ", DescColor, true, false);
			AddTooltipColorText(subSkillList[i].SkillDesc, DescColor, false, false);
			AddTooltipItemBlank(2);
		}
	}
}


//?î—É¬∞—à¬∞–? (?ñ—Ñ–ê–?) ?ë¬? ¬ª?ç—ò—? ?ó–°“ë–?.
function AddTooltipItemBlank(int Height)
{
	StartItem();
	m_Info.eType = DIT_BLANK;
	m_Info.b_nHeight = Height;
	EndItem();
}

// ¬±–≤?î¬? ?ï–®–Ö—î–ñ¬? ?ì–?¬∞?? 
function AddTooltipSimpleText(string strText, optional int OffsetX, optional int OffsetY)
{
	StartItem();
	m_Info.eType = DIT_TEXT;
	m_Info.t_bDrawOneLine = true;
	m_Info.t_strText = strText;
	m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
	m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
	EndItem();
}

//"XXX : YYYY" ?ó—å–ï–í–ê–? TooltipItem?ê¬? ?ñ–Ω–ó–ü¬∞–? ?ì–?¬∞?é–ó–? ?ë–®“ë–?
function AddTooltipItemOption(int TitleID, string content, bool bTitle, bool bContent, bool isFirstLine, optional string FontName, optional int OffsetX, optional int OffsetY, optional Color titleTextColor, optional Color contentTextColor)
{
	// End:0x157
	if(bTitle)
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		// End:0x34
		if(! isFirstLine)
		{
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;// ?ï—à–ñ–? ?ì‚Ññ?Ññ?à–í¬? ¬∂?É–ê–û–ê–? ?ï–ñ“ë–ü¬∂—É—ë–?, ?ò—ò¬∑–? ¬∞?à¬∞–??ê¬? 6?ó–ò—ò—? ?ë–®“ë–?.(¬±–≤?î¬ª–ê—ã–ê—ë¬∑–? ?ê–ü–ë¬§–ó–ü¬∞–? ?ï–Ü“ë–? GAP)
		}
		m_Info.bLineBreak = true;
		m_Info.t_bDrawOneLine = true;
		// End:0xE9
		if(titleTextColor.R == 0 && titleTextColor.G == 0 && titleTextColor.B == 0 && titleTextColor.A == 0)
		{
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
		}
		else
		{
			m_Info.t_color = titleTextColor;
		}
		m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
		m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
		m_Info.t_strFontName = FontName;
		m_Info.t_ID = TitleID;
		EndItem();
	}
	// End:0x410
	if(content != "0")
	{
		// End:0x410
		if(bContent)
		{
			// End:0x2B7
			if(bTitle)
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				// End:0x1A1
				if(! isFirstLine)
				{
					m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
				}
				m_Info.t_bDrawOneLine = true;
				// End:0x249
				if(titleTextColor.R == 0 && titleTextColor.G == 0 && titleTextColor.B == 0 && titleTextColor.A == 0)
				{
					m_Info.t_color.R = 163;
					m_Info.t_color.G = 163;
					m_Info.t_color.B = 163;
					m_Info.t_color.A = 255;
				}
				else
				{
					m_Info.t_color = titleTextColor;
				}
				m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
				m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
				m_Info.t_strFontName = FontName;
				m_Info.t_strText = " : ";
				EndItem();
			}
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			// End:0x2E2
			if(! isFirstLine)
			{
				m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			}
			// End:0x2FA
			if(! bTitle)
			{
				m_Info.bLineBreak = true;
			}
			m_Info.t_bDrawOneLine = true;
			// End:0x3A2
			if(contentTextColor.R == 0 && contentTextColor.G == 0 && contentTextColor.B == 0 && contentTextColor.A == 0)
			{
				m_Info.t_color.R = 176;
				m_Info.t_color.G = 155;
				m_Info.t_color.B = 121;
				m_Info.t_color.A = 255;
			}
			else
			{
				m_Info.t_color = contentTextColor;
			}

			m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
			m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
			m_Info.t_strFontName = FontName;
			m_Info.t_strText = content;
			EndItem();
		}
	}
}

//"XXX : YYYY" ?ó—å–ï–í–ê–? TooltipItem?ê¬? ?ñ–Ω–ó–ü¬∞–? ?ì–?¬∞?é–ó–? ?ë–®“ë–?
function AddTooltipItemOptionString(string TitleContent, string content, bool bTitle, bool bContent, bool isFirstLine, Color titleColor, Color ContentColor)
{
	// End:0xCC
	if(bTitle)
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		// End:0x34
		if(! isFirstLine)
		{
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
		}
		m_Info.bLineBreak = true;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = titleColor.R;
		m_Info.t_color.G = titleColor.G;
		m_Info.t_color.B = titleColor.B;
		m_Info.t_color.A = titleColor.A;
		m_Info.t_strText = TitleContent;
		EndItem();
	}
	// End:0x26F
	if(content != "0")
	{
		// End:0x26F
		if(bContent)
		{
			// End:0x1A1
			if(bTitle)
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				// End:0x116
				if(! isFirstLine)
				{
					m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
				}
				m_Info.t_bDrawOneLine = true;
				m_Info.t_color.R = ContentColor.R;
				m_Info.t_color.G = ContentColor.G;
				m_Info.t_color.B = ContentColor.B;
				m_Info.t_color.A = ContentColor.A;
				m_Info.t_strText = " : ";
				EndItem();
			}
			StartItem();
			m_Info.eType = DIT_TEXT;
			// End:0x1CC
			if(! isFirstLine)
			{
				m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			}
			// End:0x1E4
			if(! bTitle)
			{
				m_Info.bLineBreak = true;
			}
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = ContentColor.R;
			m_Info.t_color.G = ContentColor.G;
			m_Info.t_color.B = ContentColor.B;
			m_Info.t_color.A = ContentColor.A;
			m_Info.t_strText = content;
			EndItem();
		}
	}
}

//"XXX : YYYY" ?ó—å–ï–í–ê–? TooltipItem?ê¬? ?ñ–Ω–ó–ü¬∞–? ?ì–?¬∞?é–ó–? ?ë–®“ë–?.
//SYSSTRING : SYSSTRING
function AddTooltipItemOption2(int TitleID, int contentID, bool bTitle, bool bContent, bool isFirstLine)
{
	// End:0xAE
	if(bTitle)
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		// End:0x34
		if(! isFirstLine)
		{
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
		}
		m_Info.bLineBreak = true;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_ID = TitleID;
		EndItem();
	}
	// End:0x208
	if(bContent)
	{
		// End:0x158
		if(bTitle)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			// End:0xEB
			if(! isFirstLine)
			{
				m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			}
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_strText = " : ";
			EndItem();
		}
		
		StartItem();
		m_Info.eType = DIT_TEXT;
		// End:0x183
		if(! isFirstLine)
		{
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
		}
		// End:0x19B
		if(! bTitle)
		{
			m_Info.bLineBreak = true;
		}
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		m_Info.t_ID = contentID;
		EndItem();
	}
}

//"XXX : YYYY" ?ó—å–ï–í–ê–? TooltipItem?ê¬? ?ñ–Ω–ó–ü¬∞–? ?ì–?¬∞?é–ó–? ?ë–®“ë–?. ¬ª?Ü¬±—? ?ë¬∂–ë¬? ¬∞?é“ë–?(?ï—ë–ê–ú–ñ–Ü¬∞—? ?î–ë–ï–©–ì—? ¬ª?Ü¬±—Ç–ê–? ?ë–©—ë“? ¬∞–∂?ó–º—ó–? ¬ª–∑?ó–?. ¬±–£?ò–£—ë¬ª—ó–? ?ï–Ü¬∞–Ω–ê–¶–ê–?)
function AddTooltipItemColorOption(int TitleID, string content, int R, int G, int B, bool bTitle, bool bContent, bool isFirstLine)
{
	// End:0xAE
	if(bTitle)
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		// End:0x34
		if(! isFirstLine)
		{
			m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
		}
		m_Info.bLineBreak = true;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_ID = TitleID;
		EndItem();
	}
	// End:0x233
	if(content != "0")
	{
		// End:0x233
		if(bContent)
		{
			// End:0x174
			if(bTitle)
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				// End:0xF8
				if(! isFirstLine)
				{
					m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
				}
				m_Info.t_bDrawOneLine = true;
				m_Info.t_color.R = R;
				m_Info.t_color.G = G;
				m_Info.t_color.B = B;
				m_Info.t_color.A = 255;
				m_Info.t_strText = " : ";
				EndItem();
			}
			
			StartItem();
			m_Info.eType = DIT_TEXT;
			// End:0x19F
			if(! isFirstLine)
			{
				m_Info.nOffSetY = TOOLTIP_LINE_HGAP;
			}
			// End:0x1B7
			if(! bTitle)
			{
				m_Info.bLineBreak = true;
			}
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = R;
			m_Info.t_color.G = G;
			m_Info.t_color.B = B;
			m_Info.t_color.A = 255;
			m_Info.t_strText = content;
			EndItem();
		}
	}
}

// nBasic ¬±–≤?î¬ª¬∞–?, ?ê–û–ì¬¶–ñ¬? ?î—ë—ñ–ö–Ö—? ¬∞?? nBonus   (100+50)  <- ?ê–ú¬∑¬±–Ö–? ?ó“ê–ó—? (?î¬?¬∂?? ?ë–©—ë–à¬∞–?)
function AddTooltipItemBonus(int nBasic, int nBonus, optional int OffsetX, optional int OffsetY, optional int nBonus2, optional int nAddAttack)
{
	// End:0x113
	if(nBonus > 0)
	{
		AddTooltipColorText(" (" $ string(nBasic) $ " ", GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
		AddTooltipColorText("+" $ string(nBonus), GetColor(238, 170, 34, 255), false, true, false, "", OffsetX, OffsetY);
		// End:0xAB
		if(nBonus2 > 0)
		{
			AddTooltipColorText(" +" $ string(nBonus2), getInstanceL2Util().CAPRI, false, true, false, "", OffsetX, OffsetY);
		}
		// End:0xEA
		if(nAddAttack > 0)
		{
			AddTooltipColorText(" +" $ string(nAddAttack) $ "", GetColor(119, 255, 153, 255), false, true, false, "", OffsetX, OffsetY);
		}

		AddTooltipColorText(")", GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
	}
	else if(nBonus2 > 0)
	{
		AddTooltipColorText(" (" $ string(nBasic) $ "", GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
		// End:0x18D
		if(nBonus2 > 0)
		{
			AddTooltipColorText(" +" $ string(nBonus2), getInstanceL2Util().CAPRI, false, true, false, "", OffsetX, OffsetY);
		}
		// End:0x1CD
		if(nAddAttack > 0)
		{
			AddTooltipColorText(" +" $ string(nAddAttack) $ "", GetColor(119, 255, 153, 255), false, true, false, "", OffsetX, OffsetY);
		}
		AddTooltipColorText(")",GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
	}
	else if(nAddAttack > 0)
	{
		AddTooltipColorText(" (" $ string(nBasic) $ "", GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
		AddTooltipColorText(" +" $ string(nAddAttack) $ "", GetColor(119, 255, 153, 255), false, true, false, "", OffsetX, OffsetY);
		AddTooltipColorText(")", GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
	}
}

function addTooltipTextureSplitLineType(string Texture, int Width, int Height, int uWidth, int uHeight, optional int OffsetX, optional int OffsetY)
{
	StartItem();
	m_Info.eType = DIT_SPLITLINE;
	m_Info.t_bDrawOneLine = true;
	m_Info.bLineBreak = false;
	m_Info.u_nTextureWidth = Width;
	m_Info.u_nTextureHeight = Height;
	m_Info.nOffSetX = OffsetX;
	m_Info.nOffSetY = OffsetY;
	m_Info.u_nTextureUWidth = uWidth;
	m_Info.u_nTextureUHeight = uHeight;
	m_Info.u_strTexture = Texture;
	EndItem();
}

function addTooltipTexture(string Texture, int Width, int Height, int uWidth, int uHeight, optional bool oneline, optional bool bLineBreak, optional int OffsetX, optional int OffsetY)
{
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.t_bDrawOneLine = oneline;
	m_Info.bLineBreak = bLineBreak;
	m_Info.u_nTextureWidth = Width;
	m_Info.u_nTextureHeight = Height;
	m_Info.nOffSetX = OffsetX;
	m_Info.nOffSetY = OffsetY;
	m_Info.u_nTextureUWidth = uWidth;
	m_Info.u_nTextureUHeight = uHeight;
	m_Info.u_strTexture = Texture;
	EndItem();
}

function addOverlayTexture(string IconName, int u_nTextureWidth, int u_nTextureHeight, int u_nTextureUWidth, int u_nTextureUHeight, optional int nOffSetX, optional int nOffSetY)
{
	StartItem();
	m_Info.eType = DIT_OVERLAY_TEXTURE;
	m_Info.eAlignType = DIAT_RIGHT_BOTTOM;
	m_Info.u_nTextureWidth = u_nTextureWidth;
	m_Info.u_nTextureHeight = u_nTextureHeight;
	m_Info.u_nTextureUWidth = u_nTextureUWidth;
	m_Info.u_nTextureUHeight = u_nTextureUHeight;
	m_Info.nOffSetX = nOffSetX;
	m_Info.nOffSetY = nOffSetY;
	m_Info.u_strTexture = IconName;
	EndItem();
}

// ?ò–£—ò—?, ?Ññ¬∞, ?î–?, ?Ññ–©¬∂??,¬µ–æ¬µ–æ ?ò–£—ò—? ?ï–ñ–ê–ú–î–?
function string GetAttributeIcon(int nAttributeType)
{
	local string rStr;

	switch(nAttributeType)
	{
		// End:0x41
		case ATTRIBUTE_FIRE:
			rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_fire";
			// End:0x16E
			break;
		// End:0x7C
		case ATTRIBUTE_WATER:
			rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_water";
			// End:0x16E
			break;
		// End:0xB7
		case ATTRIBUTE_WIND:
			rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_wind";
			// End:0x16E
			break;
		// End:0xF3
		case ATTRIBUTE_EARTH:
			rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_earth";
			// End:0x16E
			break;
		// End:0x130
		case ATTRIBUTE_HOLY:
			rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_Sacred";
			// End:0x16E
			break;
		// End:0x16B
		case ATTRIBUTE_UNHOLY:
			rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_dark";
			// End:0x16E
			break;
	}

	return rStr;
}

function AddTooltipCreateInfos(bool bIsCreateItem)
{
	// End:0x40
	if(bIsCreateItem)
	{
		AddCrossLine();
		AddTooltipItemBlank(4);
		AddTooltipColorText(GetSystemString(13961), GTColor().Yellow03, false, false);
		AddTooltipItemBlank(1);
	}
}

function AddTitleIconWithHeadLine(string Icontex, string titleStr, optional bool bDoNotAddBlank)
{
	AddTooltipItemBlank(4);
	addTooltipTextureSplitLineType("L2UI_NewTex.Tooltip.TooltipLine_DetailTitleBG", 1, 25, 0, 0, 0, 0);
	// End:0x66
	if(Icontex != "")
	{
		addTooltipTexture(Icontex, 18, 18, 0, 0, false, false, 1, 2);
	}
	AddTooltipColorText(titleStr, getInstanceL2Util().Gold, false, true, false, "", 4, 4);
	// End:0x9D
	if(bDoNotAddBlank == false)
	{
		AddTooltipItemBlank(4);
	}
}

function bool isSImpleTooltipNoSelect(int nUseSimpleTooltip, int nIsSelectMode)
{
	// End:0x1A
	if(nUseSimpleTooltip > 0 && nIsSelectMode == 0)
	{
		return true;
	}
	return false;
}

function bool isEnchanted(out ItemInfo item)
{
	// End:0x19
	if(EEtcItemType(item.EtcItemType) == ITEME_PET_COLLAR)
	{
		return false;
	}
	// End:0x2B
	if(item.Enchanted > 0)
	{
		return true;
	}
	return false;
}

function bool isRefinery(out ItemInfo item)
{
	// End:0x24
	if(item.RefineryOp1 != 0 || item.RefineryOp2 != 0)
	{
		return true;
	}
	return false;
}

function bool isHeroBookItem(out ItemInfo item)
{
	// End:0x12
	if(item.HeroBookPoint > 0)
	{
		return true;
	}
	return false;
}

function bool isAttribute(out ItemInfo item)
{
	// End:0x12
	if(item.AttackAttributeValue > 0)
	{
		return true;
	}
	// End:0x24
	if(item.DefenseAttributeValueFire > 0)
	{
		return true;
	}
	// End:0x36
	if(item.DefenseAttributeValueWater > 0)
	{
		return true;
	}
	// End:0x48
	if(item.DefenseAttributeValueWind > 0)
	{
		return true;
	}
	// End:0x5A
	if(item.DefenseAttributeValueEarth > 0)
	{
		return true;
	}
	// End:0x6C
	if(item.DefenseAttributeValueHoly > 0)
	{
		return true;
	}
	// End:0x7E
	if(item.DefenseAttributeValueUnholy > 0)
	{
		return true;
	}
	return false;
}

function bool isLevelUpBonus(out ItemInfo item, string TooltipType)
{
	local UserInfo myInfo;
	local PetInfo pInfo;
	local int nLevel;

	// End:0x36
	if(TooltipType == "InventoryPet")
	{
		GetPetInfo(pInfo);
		nLevel = pInfo.nLevel;		
	}
	else
	{
		GetPlayerInfo(myInfo);
		nLevel = myInfo.nLevel;
	}
	// End:0x73
	if(GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, nLevel) > 0)
	{
		return true;
	}
	// End:0x95
	if(GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, nLevel) > 0)
	{
		return true;
	}
	return false;
}

function bool isEnsoulOption(ItemInfo weaponInfo)
{
	local int i, N, Cnt, optionId;

	// End:0x58
	if(getInstanceUIData().getIsClassicServer())
	{
		// End:0x53
		if(weaponInfo.ItemType == EItemType.ITEM_WEAPON || weaponInfo.ItemType == EItemType.ITEM_ARMOR || weaponInfo.ItemType == EItemType.ITEM_ACCESSARY)
		{			
		}
		else
		{
			return false;
		}		
	}
	else
	{
		// End:0x6D
		if(weaponInfo.ItemType == EItemType.ITEM_WEAPON || weaponInfo.ItemType == EItemType.ITEM_ARMOR || weaponInfo.ItemType == EItemType.ITEM_ACCESSARY)
		{
		}
		else
		{
			return false;
		}
	}

	// End:0x100 [Loop If]
	for(i = 1; i < TOOLTIP_SETITEM_MAX; i++)
	{
		Cnt = weaponInfo.EnsoulOption[i - 1].OptionArray.Length;

		// End:0xF6 [Loop If]
		for(N = 1; N < (1 + Cnt); N++)
		{
			optionId = weaponInfo.EnsoulOption[i - 1].OptionArray[N - 1];
			// End:0xEC
			if(optionId > 0)
			{
				return true;
			}
		}
	}
	return false;
}

function bool isBlessed(ItemInfo item)
{
	// End:0x10
	if(item.IsBlessedItem)
	{
		return true;
	}
	return false;
}

function AddCollectionItem(ItemInfo item)
{
	// End:0xBD
	if(isCollectionItem(item))
	{
		AddTitleIconWithHeadLine("L2UI_NewTex.ToolTip.TooltipICON_Collection_small", GetSystemString(13490));
		AddTooltipColorText(GetSystemString(13697), GTColor().Gray, true, false, false, "", 0, 0);
		// End:0xBD
		if(isEnsoulOption(item) || isRefinery(item))
		{
			AddTooltipColorText(GetSystemString(13712), GTColor().Gray, true, false, false, "", 0, 0);
		}
	}
}

function AddHeroBookItem(ItemInfo item)
{
	// End:0x76
	if(isHeroBookItem(item))
	{
		AddTitleIconWithHeadLine("L2UI_NewTex.ToolTip.TooltipIcon_Herobook_small", GetSystemString(14157));
		AddTooltipColorText(GetSystemString(14161), GTColor().Gray, true, false, false, "", 0, 0);
	}	
}

function AddBlessed(ItemInfo item)
{
	local array<BlessOptionData> optionList;
	local int i;
	local Color applyColor;

	// End:0x184
	if(item.IsBlessedItem)
	{
		class'UIDATA_ITEM'.static.GetBlessOptionData(item.Id.ClassID, optionList);
		// End:0x184
		if(optionList.Length > 0)
		{
			AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_bless_small", GetSystemString(13405));

			// End:0x184 [Loop If]
			for(i = 0; i < optionList.Length; i++)
			{
				// End:0xED
				if(optionList[i].OptionType == 0)
				{
					applyColor = getInstanceL2Util().BrightWhite;
					AddTooltipColorText(optionList[i].OptionDesc, applyColor, true, false, false, "", 0, 0);
					AddTooltipItemBlank(4);
					// [Explicit Continue]
					continue;
				}
				// End:0x124
				if(item.Enchanted >= optionList[i].EnchantedValue)
				{
					applyColor = getInstanceL2Util().ColorYellow;					
				}
				else
				{
					applyColor = getInstanceL2Util().Gray;
				}
				AddTooltipColorText(" +" $ string(optionList[i].EnchantedValue) $ " " $ optionList[i].OptionDesc, applyColor, true, false, false, "", 0, 0);
			}
		}
	}
}

function AddSimpleIcon_EnsoulOption(ItemInfo weaponInfo)
{
	local EnsoulOptionUIInfo optionInfo;
	local int i, N, Cnt, optionId, ensoulSlotCount;

	// End:0x58
	if(getInstanceUIData().getIsClassicServer())
	{
		// End:0x53
		if(weaponInfo.ItemType == EItemType.ITEM_WEAPON || weaponInfo.ItemType == EItemType.ITEM_ARMOR || weaponInfo.ItemType == EItemType.ITEM_ACCESSARY)
		{			
		}
		else
		{
			return;
		}		
	}
	else
	{
		// End:0x6D
		if(weaponInfo.ItemType == EItemType.ITEM_WEAPON || weaponInfo.ItemType == EItemType.ITEM_ARMOR || weaponInfo.ItemType == EItemType.ITEM_ACCESSARY)
		{
			
		}
		else
		{
			return;
		}
	}

	// End:0x169 [Loop If]
	for(i = 1; i < TOOLTIP_SETITEM_MAX; i++)
	{
		Cnt = weaponInfo.EnsoulOption[i - 1].OptionArray.Length;

		// End:0x15F [Loop If]
		for(N = 1; N < (1 + Cnt); N++)
		{
			optionId = weaponInfo.EnsoulOption[i - 1].OptionArray[N - 1];
			// End:0x155
			if(optionId > 0)
			{
				ensoulSlotCount++;
				GetEnsoulOptionUIInfo(optionId, optionInfo);
				addTooltipTexture("L2UI_NewTex.Tooltip.TooltipICON_EnSoul0" $ string(ensoulSlotCount), 26, 26, 0, 0, true, false, 2, 5);
				AddItemEnsoulStepNumImg(optionInfo.OptionStep);
			}
		}
	}
}

function AddSimpleSetitem(ItemInfo item)
{
	local int i;
	local string strTmp;
	local ItemID tmpItemID;
	local int setId, totalNum;
	local bool IsSigil;
	local ItemInfo tmpInfo;
	local bool bSetDrawTitle;

	// End:0x3D2
	if(IsValidItemID(item.Id))
	{
		// End:0x3D2 [Loop If]
		for(i = 0; i < TOOLTIP_SETITEM_MAX; i++)
		{
			// End:0x3C8 [Loop If]
			for(setId = 0; setId < class'UIDATA_ITEM'.static.GetSetItemNum(item.Id, i); setId++)
			{
				tmpItemID.ClassID = class'UIDATA_ITEM'.static.GetSetItemFirstID(item.Id, i, setId);
				// End:0x3BE
				if(tmpItemID.ClassID > 0)
				{
					// End:0x12B
					if(bSetDrawTitle == false)
					{
						// End:0xE7
						if(IsAdenServer())
						{
							AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_Set_small", GetSystemString(3881));							
						}
						else
						{
							AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_Set_small", GetSystemString(2347));
						}
						bSetDrawTitle = true;
					}
					strTmp = class'UIDATA_ITEM'.static.GetItemName(tmpItemID);
					class'UIDATA_ITEM'.static.GetItemInfo(tmpItemID, tmpInfo);
					addItemIconSmallType(tmpInfo, "");
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.nOffSetY = 0;
					m_Info.bLineBreak = false;
					m_Info.t_bDrawOneLine = false;
					SetTooltipTextColor(100, 100, 65, 255);
					// End:0x2AF
					if(i == 0)
					{
						m_Info.t_strText = " " $ strTmp;
						ParamAdd(m_Info.Condition, "SetItemNum", string(i));
						ParamAdd(m_Info.Condition, "Type", "Equip");
						ParamAddItemID(m_Info.Condition, item.Id);
						ParamAdd(m_Info.Condition, "CurTypeID", string(setId));
						ParamAdd(m_Info.Condition, "NormalColor", "100,100,65");
						ParamAdd(m_Info.Condition, "EnableColor", "255,250,160");
						totalNum = setId;						
					}
					else if(i == 1)
					{
						m_Info.t_strText = "- (+) " $ strTmp;
						ParamAdd(m_Info.Condition, "SetItemNum", string(i));
						ParamAdd(m_Info.Condition, "Type", "Equip");
						ParamAddItemID(m_Info.Condition, item.Id);
						ParamAdd(m_Info.Condition, "CurTypeID", string(setId));
						ParamAdd(m_Info.Condition, "NormalColor", "100,70,0");
						ParamAdd(m_Info.Condition, "EnableColor", "255,180,0");
						IsSigil = IsSigilArmor(tmpItemID);
					}
					EndItem();
					AddTooltipItemBlank(1);
				}
			}
		}
	}
}

private function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);	
}

private function bool API_GetNQuestDialogData(int a_QuestID, out NQuestDialogUIData o_data)
{
	return GetNQuestDialogData(a_QuestID, o_data);	
}

defaultproperties
{
}
