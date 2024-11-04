//================================================================================
// MenuEntireWnd.
//================================================================================

class MenuEntireWnd extends UICommonAPI;

const TIMER_ID = 123401;
const TIMER_DELAY = 300;
const CATEGORY_LINE_0 = 0;
const CATEGORY_LINE_1 = 1;
const CATEGORY_LINE_2 = 2;
const CATEGORY_LINE_3 = 3;
const CATEGORY_LINE_4 = 4;
const BG_TYPE1_TEXTURE = "L2UI_NewTex.MenuWnd.MainMenu_MainButton.MenuWnd.MainMenu_iconBg02";
const BG_TYPE2_TEXTURE = "L2UI_NewTex.MenuWnd.MainMenu_MainButton.MenuWnd.MainMenu_iconBg01";
const MAX_CATEGORY = 5;
const MAX_CATEGORYBUTTONNUM = 18;
const ADD_HEIGHT_ADEN = 140;
const ADD_HEIGHT_TALKINGISLAND = 140;
const MAX_FIXMENU_NUM = 10;
const ADD_HEIGHT_LIVE = 140;
const CATEGORYBG_ADD_HEIGHT = 4;
const MENU_Ability = "Ability";
const MENU_Attend = "Attend";
const MENU_OlympiadRandomChallengeWnd = "OlympiadRandomChallengeWnd";
const MENU_Productinven = "Productinven";
const MENU_ShopLcoinCraft = "ShopLcoinCraft";
const MENU_NShop = "NShop";
const MENU_OlympiadWnd = "OlympiadWnd";
const MENU_RevengeWnd = "RevengeWnd";
const MENU_IngameWebWnd = "IngameWebWnd";
const MENU_BBS = "BBS";
const MENU_ShopSell = "ShopSell";
const MENU_ShopBuy = "ShopBuy";
const MENU_ShopSellAll = "ShopSellAll";
const MENU_ShopSearch = "ShopSearch";
const MENU_ShopFind = "ShopFind";
const MENU_Post = "Post";
const MENU_ShopLcoinCraftWnd = "ShopLcoinCraftWnd";
const MENU_PartyMatchWnd = "PartyMatchWnd";
const MENU_PersonalConnectionsWnd = "PersonalConnectionsWnd";
const MENU_InstancedZone = "InstancedZone";
const MENU_Petition = "Petition";
const MENU_ShortcutAssign = "ShortcutAssign";
const MENU_MacroWnd = "MacroWnd";
const MENU_SiegeCastleInfoWnd = "SiegeCastleInfoWnd";
const MENU_ClanSearch = "ClanSearch";
const MENU_FactionWnd = "FactionWnd";
const MENU_HennaEngraveWndLive = "HennaEngraveWndLive";
const MENU_PlayerAgeWnd = "PlayerAgeWnd";
const MENU_Qna = "Qna";
const MENU_OptionWnd = "OptionWnd";
const MENU_Rec = "Rec";
const MENU_TimeZoneWnd = "TimeZoneWnd";
const MENU_VitamainService = "VitamainService";
const MENU_YetiWnd = "YetiWnd";
const MENU_DetailStatusWnd = "DetailStatusWnd";
const MENU_InventoryWnd = "InventoryWnd";
const MENU_ActionWnd = "ActionWnd";
const MENU_MagicSkillWnd = "MagicSkillWnd";
const MENU_QuestTreeWnd = "QuestTreeWnd";
const MENU_ClanWnd = "ClanWnd";
const MENU_LShop = "LShop";
const MENU_PcRoom = "PcRoom";
const MENU_Shortcut = "Shortcut";
const MENU_PathToAwakening = "PathToAwakening";
//const MENU_HomunculusWnd = "HomunculusWnd";
const MENU_Einhasad = "Einhasad";
const MENU_RestoreLostPropertyWnd = "RestoreLostPropertyWnd";
const MENU_CollectionSystem = "CollectionSystem";
const MENU_WorldSiegeRankingWnd = "WorldSiegeRankingWnd";
const MENU_DethroneWnd = "DethroneWnd";
const MENU_HennaMenuWnd = "HennaMenuWnd";
const MENU_HeroBookWnd = "HeroBookWnd";
const MENU_AdenaDistributionWnd = "AdenaDistributionWnd";
const MENU_TeleportWnd = "TeleportWnd";
const MENU_TodoListWnd = "TodoListWnd";
const MENU_WorldExchangeBuyWnd = "WorldExchangeBuyWnd";
const MENU_ElementalSpiritWnd = "ElementalSpiritWnd";
const MENU_MiniMapGfxWnd = "MinimapWnd";
const MENU_CostumePreviewWnd = "CostumePreviewWnd";
const BG_TYPE1 = 0;
const BG_TYPE2 = 1;

enum GameRuleType
{
	GRT_TEAM,
	GRT_CLASSLESS,
	GRT_CLASS,
	GRT_MAX
};

struct MenuButtonSlotStructCategory
{
	var int categoryIndex;
	var array<MenuButtonSlotStruct> MenuButtonSlotStructArray;
};

var WindowHandle Me;
var TextureHandle menuBgTexture;
var int lastButtonCount;
var Rect firstRect;
var bool bIsWorkingTimer;
var int nSystemMenuWndFocus;
var bool bEditMode;
var int nSquenceAdd;
var array<MenuButtonSlotStructCategory> menuSlotArray;
var array<MenuButtonSlotStruct> fixedMenuSlotStructArray;

function OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_ShowWindow);
	RegisterEvent(EV_Restart);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle("MenuEntireWnd");
	menuBgTexture = GetTextureHandle("MenuEntireWnd.menuBgTexture");
	firstRect = Me.GetRect();
}

function OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	if (nSystemMenuWndFocus == 1)
	{
		if ((bIsWorkingTimer == false) && Me.IsShowWindow() && !bFocused)
		{
			if(bEditMode == false)
			{
				Me.HideWindow();
			}
		}
	}
	nSystemMenuWndFocus = 0;
}

function initAllMenu()
{
	menuSlotArray.Remove(0, menuSlotArray.Length);
	addCatogory(CATEGORY_LINE_0);
	addCatogory(CATEGORY_LINE_1);
	addCatogory(CATEGORY_LINE_2);
	addCatogory(CATEGORY_LINE_3);
	addCatogory(CATEGORY_LINE_4);
}

function OnShow()
{
	bIsWorkingTimer = true;
	Me.KillTimer(TIMER_ID);
	Me.SetTimer(TIMER_ID, TIMER_DELAY);
}

function OnHide()
{
	bIsWorkingTimer = true;
	Me.KillTimer(TIMER_ID);
	Me.SetTimer(TIMER_ID, TIMER_DELAY);
	// End:0x59
	if(bEditMode)
	{
		bEditMode = false;
		setEditMode(false);
		loadOptionIni();
		refreshMenu();
	}
	nSystemMenuWndFocus = 1;
}

function OnTimer(int TimerID)
{
	if (TimerID == TIMER_ID)
	{
		KillIsWorkingTimerTimer();
		nSystemMenuWndFocus = 1;
	}
}

function OnEvent(int Event_ID, string param)
{
	local string nameStr;
	local string SystemMenuWndFocus;

	if (Event_ID == EV_GamingStateEnter)
	{
		KillIsWorkingTimerTimer();
		initAllMenu();
		configurationMenuData();
		configurationFixedMenuData();
		bEditMode = false;
		setEditMode(false);
		loadOptionIni();
		refreshMenu();
	}
	else if (Event_ID == EV_ShowWindow)
	{
		ParseString(param, "Name", nameStr);
		if (nameStr == "SystemMenuWnd")
		{
			ParseString(param, "SystemMenuWndFocus", SystemMenuWndFocus);
			nSystemMenuWndFocus = int(SystemMenuWndFocus);
			if (Me.IsShowWindow())
			{
				Me.HideWindow();
			}
			else if (!bIsWorkingTimer)
			{
				ShowWindowWithFocus(getCurrentWindowName(string(self)));
			}
		}
	}
	else if (Event_ID == EV_Restart)
	{
		KillIsWorkingTimerTimer();
	}
}

function configurationFixedMenuData()
{
	local ELanguageType Language;
	local bool isClassic, isKorean, isAden, isLive;

	isLive = getInstanceUIData().getIsLiveServer();
	isClassic = getInstanceUIData().getIsClassicServer();
	isAden = IsAdenServer();
	Language = GetLanguage();
	isKorean = Language == ELanguageType.LANG_Korean/*0*/;
	fixedMenuSlotStructArray.Remove(0, fixedMenuSlotStructArray.Length);
	// End:0x197
	if(isAden)
	{
		setListFixed(314, MENU_ClanWnd, "");
		setListFixed(389, MENU_PartyMatchWnd, "");
		setListFixed(470, MENU_Petition, "", ! isKorean);
		setListFixed(13515, MENU_RestoreLostPropertyWnd, "");
		setListFixed(2668, MENU_InstancedZone, "");
		setListFixed(3529, MENU_SiegeCastleInfoWnd, "");
		setListFixed(3327, MENU_PlayerAgeWnd, "", ! isKorean);
		setListFixed(2448, MENU_Rec, "");
		setListFixed(14168, MENU_PersonalConnectionsWnd, MENU_PersonalConnectionsWnd);		
	}
	else if(isClassic && ! isAden)
	{
		setListFixed(314, MENU_ClanWnd, "");
		setListFixed(389, MENU_PartyMatchWnd, "");
		setListFixed(13515, MENU_RestoreLostPropertyWnd, "");
		setListFixed(470, MENU_Petition, "", ! isKorean);
		setListFixed(2668, MENU_InstancedZone, "");
		setListFixed(3529, MENU_SiegeCastleInfoWnd, "");
		setListFixed(3327, MENU_PlayerAgeWnd, "", ! isKorean);
		setListFixed(2448, MENU_Rec, "");
		setListFixed(14168, MENU_PersonalConnectionsWnd, MENU_PersonalConnectionsWnd);			
	}
	else
	{
		setListFixed(3471, MENU_IngameWebWnd, "", ! isKorean);
		setListFixed(387, MENU_BBS, "BoardWnd", ! isKorean);
		setListFixed(470, MENU_Petition, "", ! isKorean);
		setListFixed(3136, MENU_Qna, "", ! isKorean);
		setListFixed(2448, MENU_Rec, "");
		setListFixed(3327, MENU_PlayerAgeWnd, "", ! isKorean);
	}
}


function configurationMenuData()
{
	local ELanguageType Language;
	local bool isClassic, isKorean, isAden, isLive;

	isLive = getInstanceUIData().getIsLiveServer();
	isClassic = getInstanceUIData().getIsClassicServer();
	isAden = IsAdenServer();
	Language = GetLanguage();
	isKorean = Language == LANG_Korean;
	GetMeButton("OptionBtn").SetTooltipCustomType(MakeTooltipSimpleColorText(setMainShortcutString(getAssignedKeyGroup(), MENU_OptionWnd), getInstanceL2Util().White));

	// End:0xC6E
	if(isKorean)
	{
		// End:0x455
		if(isAden)
		{
			setList(CATEGORY_LINE_0, 14063, MENU_WorldExchangeBuyWnd, "", ! class'WorldExchangeBuyWnd'.static.Inst().ChkUseableServerID(), GetColor(255, 211, 102, 255));
			setList(CATEGORY_LINE_0, 13025, MENU_TimeZoneWnd, "");
			setList(CATEGORY_LINE_0, 1, MENU_InventoryWnd, MENU_InventoryWnd);
			setList(CATEGORY_LINE_0, 3651, MENU_DetailStatusWnd, MENU_DetailStatusWnd);
			setList(CATEGORY_LINE_0, 447, MENU_MiniMapGfxWnd, MENU_MiniMapGfxWnd);
			setList(CATEGORY_LINE_1, 13832, MENU_ShopFind, "",, GetColor(255, 211, 102, 255));
			setList(CATEGORY_LINE_1, 7464, MENU_Attend, "", ! getUseVipAttendance());
			setList(CATEGORY_LINE_1, 119, MENU_MagicSkillWnd, MENU_MagicSkillWnd);
			setList(CATEGORY_LINE_1, 3506, MENU_TodoListWnd, "");
			setList(CATEGORY_LINE_1, 13476, MENU_CollectionSystem, "");
			setList(CATEGORY_LINE_2, 3634, MENU_NShop, MENU_IngameWebWnd, ! isKorean, GetColor(255, 211, 102, 255));
			setList(CATEGORY_LINE_2, 687, MENU_TeleportWnd, "");
			setList(CATEGORY_LINE_2, 127, MENU_ActionWnd, MENU_ActionWnd);
			setList(CATEGORY_LINE_2, 13904, MENU_HennaMenuWnd, "");
			setList(CATEGORY_LINE_2, 3776, MENU_ElementalSpiritWnd, "");
			setList(CATEGORY_LINE_3, 2469, MENU_Productinven, "", ! GetINIBool2Bool("PrimeShop", "UseGoodsInventory"), GetColor(255, 211, 102, 255));
			setList(CATEGORY_LINE_3, 13249, MENU_YetiWnd, MENU_YetiWnd, ! isKorean);
			setList(CATEGORY_LINE_3, 711, MENU_MacroWnd, MENU_MacroWnd);
			setList(CATEGORY_LINE_3, 13082, MENU_RevengeWnd, "");
			setList(CATEGORY_LINE_3, 2074, MENU_Post, "PostWnd");
			setList(CATEGORY_LINE_4, 3932, MENU_LShop, "", ! isKorean, GetColor(255, 211, 102, 255));
			setList(CATEGORY_LINE_4, 118, MENU_QuestTreeWnd, MENU_QuestTreeWnd);
			setList(CATEGORY_LINE_4, 387, MENU_BBS, "BoardWnd", ! isKorean);
			setList(CATEGORY_LINE_4, 13799, MENU_WorldSiegeRankingWnd, "", ! isKorean);
			setList(CATEGORY_LINE_4, 146, MENU_OptionWnd, MENU_OptionWnd);			
		}
		else if(isClassic && ! isAden)
		{
			setList(CATEGORY_LINE_0, 687, MENU_TeleportWnd, "");
			setList(CATEGORY_LINE_0, 13025, MENU_TimeZoneWnd, "");
			setList(CATEGORY_LINE_0, 13476, MENU_CollectionSystem, "");
			setList(CATEGORY_LINE_0, 1, MENU_InventoryWnd, MENU_InventoryWnd);
			setList(CATEGORY_LINE_0, 3651, MENU_DetailStatusWnd, MENU_DetailStatusWnd);
			setList(CATEGORY_LINE_1, 447, MENU_MiniMapGfxWnd, MENU_MiniMapGfxWnd);
			setList(CATEGORY_LINE_1, 7464, MENU_Attend, "", ! getUseVipAttendance());
			setList(CATEGORY_LINE_1, 119, MENU_MagicSkillWnd, MENU_MagicSkillWnd);
			setList(CATEGORY_LINE_1, 3506, MENU_TodoListWnd, "");
			setList(CATEGORY_LINE_1, 2074, MENU_Post, "PostWnd");
			setList(CATEGORY_LINE_2, 13832, MENU_ShopFind, "",, GetColor(255, 211, 102, 255));
			setList(CATEGORY_LINE_2, 127, MENU_ActionWnd, MENU_ActionWnd);
			setList(CATEGORY_LINE_2, 13904, MENU_HennaMenuWnd, "");
			setList(CATEGORY_LINE_2, 3776, MENU_ElementalSpiritWnd, "");
			setList(CATEGORY_LINE_2, 118, MENU_QuestTreeWnd, MENU_QuestTreeWnd);
			setList(CATEGORY_LINE_3, 387, MENU_BBS, "BoardWnd", ! isKorean);
			setList(CATEGORY_LINE_3, 13249, MENU_YetiWnd, MENU_YetiWnd, ! isKorean);
			setList(CATEGORY_LINE_3, 711, MENU_MacroWnd, MENU_MacroWnd);
			setList(CATEGORY_LINE_3, 13082, MENU_RevengeWnd, "");
			setList(CATEGORY_LINE_4, 3932, MENU_LShop, "", ! isKorean, GetColor(255, 211, 102, 255));
			setList(CATEGORY_LINE_4, 3634, MENU_NShop, MENU_IngameWebWnd, ! isKorean, GetColor(255, 211, 102, 255));
			setList(CATEGORY_LINE_4, 2469, MENU_Productinven, "", ! GetINIBool2Bool("PrimeShop", "UseGoodsInventory"), GetColor(255, 211, 102, 255));
			setList(CATEGORY_LINE_4, 146, MENU_OptionWnd, MENU_OptionWnd);				
		}
		else
		{
			setList(CATEGORY_LINE_0, 3634, MENU_NShop, MENU_IngameWebWnd, ! isKorean, GetColor(255, 211, 102, 255), 1);
			setList(CATEGORY_LINE_0, 2469, MENU_Productinven, "", ! GetINIBool2Bool("PrimeShop", "UseGoodsInventory"), GetColor(255, 211, 102, 255), 1);
			setList(CATEGORY_LINE_0, 13535, MENU_Einhasad, "", false, GetColor(255, 211, 102, 255), 1);
			setList(CATEGORY_LINE_0, 1277, MENU_PcRoom, "", ! GetINIBool2Bool("Localize", "UsePCBangPoint"), GetColor(255, 211, 102, 255), 1);
			setList(CATEGORY_LINE_0, 13832, MENU_ShopFind, "",, GetColor(255, 211, 102, 255), 1);
			setList(CATEGORY_LINE_0, 3137, MENU_AdenaDistributionWnd, "", false, GetColor(255, 211, 102, 255), 1);
			setList(CATEGORY_LINE_1, 687, MENU_TeleportWnd, "");
			setList(CATEGORY_LINE_1, 3651, MENU_DetailStatusWnd, MENU_DetailStatusWnd);
			setList(CATEGORY_LINE_1, 1, MENU_InventoryWnd, MENU_InventoryWnd);
			setList(CATEGORY_LINE_1, 127, MENU_ActionWnd, MENU_ActionWnd);
			setList(CATEGORY_LINE_1, 119, MENU_MagicSkillWnd, MENU_MagicSkillWnd);
			setList(CATEGORY_LINE_1, 118, MENU_QuestTreeWnd, MENU_QuestTreeWnd);
			setList(CATEGORY_LINE_2, 314, MENU_ClanWnd, MENU_ClanWnd);
			setList(CATEGORY_LINE_2, 447, MENU_MiniMapGfxWnd, MENU_MiniMapGfxWnd);
			setList(CATEGORY_LINE_2, 7464, MENU_Attend, "", ! getUseVipAttendance());
			setList(CATEGORY_LINE_2, 3966, MENU_HennaEngraveWndLive, "");
			setList(CATEGORY_LINE_2, 2383, MENU_PersonalConnectionsWnd, MENU_PersonalConnectionsWnd);
			setList(CATEGORY_LINE_2, 2074, MENU_Post, "PostWnd");
			setList(CATEGORY_LINE_3, 645, MENU_ShopLcoinCraftWnd, MENU_ShopLcoinCraftWnd);
			setList(CATEGORY_LINE_3, 2796, MENU_InstancedZone, MENU_InstancedZone);
			setList(CATEGORY_LINE_3, 389, MENU_PartyMatchWnd, MENU_PartyMatchWnd);
			setList(CATEGORY_LINE_3, 13476, MENU_CollectionSystem, "");
			setList(CATEGORY_LINE_3, 14157, MENU_HeroBookWnd, "");
			setList(CATEGORY_LINE_3, 13025, MENU_TimeZoneWnd, "");
			setList(CATEGORY_LINE_4, 3845, MENU_OlympiadWnd, "");
			//setList(CATEGORY_LINE_4, 13343, MENU_HomunculusWnd, "");
			setList(CATEGORY_LINE_4, 13733, MENU_DethroneWnd, "");
			setList(CATEGORY_LINE_4, 711, MENU_MacroWnd, MENU_MacroWnd);
			setList(CATEGORY_LINE_4, 13249, MENU_YetiWnd, MENU_YetiWnd, ! isKorean);
			setList(CATEGORY_LINE_4, 146, MENU_OptionWnd, MENU_OptionWnd);
		}
	}
	else
	{
		// End:0xFCD
		if(isAden)
		{
			setList(CATEGORY_LINE_0, 14063, MENU_WorldExchangeBuyWnd, "", ! class'WorldExchangeBuyWnd'.static.Inst().ChkUseableServerID());
			setList(CATEGORY_LINE_0, 13025, MENU_TimeZoneWnd, "");
			setList(CATEGORY_LINE_0, 1, MENU_InventoryWnd, MENU_InventoryWnd);
			setList(CATEGORY_LINE_0, 3651, MENU_DetailStatusWnd, MENU_DetailStatusWnd);
			setList(CATEGORY_LINE_0, 447, MENU_MiniMapGfxWnd, MENU_MiniMapGfxWnd);
			setList(CATEGORY_LINE_1, 687, MENU_TeleportWnd, "");
			setList(CATEGORY_LINE_1, 7464, MENU_Attend, "", ! getUseVipAttendance());
			setList(CATEGORY_LINE_1, 119, MENU_MagicSkillWnd, MENU_MagicSkillWnd);
			setList(CATEGORY_LINE_1, 3506, MENU_TodoListWnd, "");
			setList(CATEGORY_LINE_1, 13476, MENU_CollectionSystem, "");
			setList(CATEGORY_LINE_2, 3634, MENU_NShop, MENU_IngameWebWnd, ! isKorean, GetColor(255, 211, 102, 255));
			setList(CATEGORY_LINE_2, 13832, MENU_ShopFind);
			setList(CATEGORY_LINE_2, 127, MENU_ActionWnd, MENU_ActionWnd);
			setList(CATEGORY_LINE_2, 13904, MENU_HennaMenuWnd, "");
			setList(CATEGORY_LINE_2, 3776, MENU_ElementalSpiritWnd, "");
			setList(CATEGORY_LINE_3, 387, MENU_BBS, "BoardWnd", ! isKorean);
			setList(CATEGORY_LINE_3, 13249, MENU_YetiWnd, MENU_YetiWnd, ! isKorean);
			setList(CATEGORY_LINE_3, 711, MENU_MacroWnd, MENU_MacroWnd);
			setList(CATEGORY_LINE_3, 13082, MENU_RevengeWnd, "");
			setList(CATEGORY_LINE_3, 2074, MENU_Post, "PostWnd");
			setList(CATEGORY_LINE_4, 2469, MENU_Productinven, "", ! GetINIBool2Bool("PrimeShop", "UseGoodsInventory"), GetColor(255, 211, 102, 255));
			setList(CATEGORY_LINE_4, 118, MENU_QuestTreeWnd, MENU_QuestTreeWnd);
			setList(CATEGORY_LINE_4, 146, MENU_OptionWnd, MENU_OptionWnd);			
		}
		else if(isClassic && ! isAden)
		{
			setList(CATEGORY_LINE_0, 687, MENU_TeleportWnd, "");
			setList(CATEGORY_LINE_0, 13025, MENU_TimeZoneWnd, "");
			setList(CATEGORY_LINE_0, 13476, MENU_CollectionSystem, "");
			setList(CATEGORY_LINE_0, 1, MENU_InventoryWnd, MENU_InventoryWnd);
			setList(CATEGORY_LINE_0, 3651, MENU_DetailStatusWnd, MENU_DetailStatusWnd);
			setList(CATEGORY_LINE_1, 447, MENU_MiniMapGfxWnd, MENU_MiniMapGfxWnd);
			setList(CATEGORY_LINE_1, 7464, MENU_Attend, "", ! getUseVipAttendance());
			setList(CATEGORY_LINE_1, 119, MENU_MagicSkillWnd, MENU_MagicSkillWnd);
			setList(CATEGORY_LINE_1, 3506, MENU_TodoListWnd, "");
			setList(CATEGORY_LINE_1, 2074, MENU_Post, "PostWnd");
			setList(CATEGORY_LINE_2, 13832, MENU_ShopFind);
			setList(CATEGORY_LINE_2, 127, MENU_ActionWnd, MENU_ActionWnd);
			setList(CATEGORY_LINE_2, 13904, MENU_HennaMenuWnd, "");
			setList(CATEGORY_LINE_2, 3776, MENU_ElementalSpiritWnd, "");
			setList(CATEGORY_LINE_3, 387, MENU_BBS, "BoardWnd", ! isKorean);
			setList(CATEGORY_LINE_3, 13249, MENU_YetiWnd, MENU_YetiWnd, ! isKorean);
			setList(CATEGORY_LINE_3, 711, MENU_MacroWnd, MENU_MacroWnd);
			setList(CATEGORY_LINE_3, 13082, MENU_RevengeWnd, "");
			setList(CATEGORY_LINE_4, 3634, MENU_NShop, MENU_IngameWebWnd, ! isKorean, GetColor(255, 211, 102, 255));
			setList(CATEGORY_LINE_4, 2469, MENU_Productinven, "", ! GetINIBool2Bool("PrimeShop", "UseGoodsInventory"), GetColor(255, 211, 102, 255));
			setList(CATEGORY_LINE_4, 118, MENU_QuestTreeWnd, MENU_QuestTreeWnd);
			setList(CATEGORY_LINE_4, 146, MENU_OptionWnd, MENU_OptionWnd);				
		}
		else
		{
			setList(CATEGORY_LINE_0, 3634, MENU_NShop, MENU_IngameWebWnd, ! isKorean, GetColor(255, 211, 102, 255), 1);
			setList(CATEGORY_LINE_0, 2469, MENU_Productinven, "", ! GetINIBool2Bool("PrimeShop", "UseGoodsInventory"), GetColor(255, 211, 102, 255), 1);
			setList(CATEGORY_LINE_0, 13535, MENU_Einhasad, "", false, GetColor(255, 211, 102, 255), 1);
			setList(CATEGORY_LINE_0, 1277, MENU_PcRoom, "", ! GetINIBool2Bool("Localize", "UsePCBangPoint"), GetColor(255, 211, 102, 255), 1);
			setList(CATEGORY_LINE_0, 13832, MENU_ShopFind, "",, GetColor(255, 211, 102, 255), 1);
			setList(CATEGORY_LINE_0, 14063, MENU_WorldExchangeBuyWnd, "", ! class'WorldExchangeBuyWnd'.static.Inst().ChkUseableServerID());
			setList(CATEGORY_LINE_1, 687, MENU_TeleportWnd, "");
			setList(CATEGORY_LINE_1, 3651, MENU_DetailStatusWnd, MENU_DetailStatusWnd);
			setList(CATEGORY_LINE_1, 1, MENU_InventoryWnd, MENU_InventoryWnd);
			setList(CATEGORY_LINE_1, 127, MENU_ActionWnd, MENU_ActionWnd);
			setList(CATEGORY_LINE_1, 119, MENU_MagicSkillWnd, MENU_MagicSkillWnd);
			setList(CATEGORY_LINE_1, 118, MENU_QuestTreeWnd, MENU_QuestTreeWnd);
			setList(CATEGORY_LINE_2, 314, MENU_ClanWnd, MENU_ClanWnd);
			setList(CATEGORY_LINE_2, 447, MENU_MiniMapGfxWnd, MENU_MiniMapGfxWnd);
			setList(CATEGORY_LINE_2, 7464, MENU_Attend, "", ! getUseVipAttendance());
			setList(CATEGORY_LINE_2, 13904, MENU_HennaMenuWnd, "");
			setList(CATEGORY_LINE_2, 2383, MENU_PersonalConnectionsWnd, MENU_PersonalConnectionsWnd);
			setList(CATEGORY_LINE_2, 2074, MENU_Post, "PostWnd");
			setList(CATEGORY_LINE_2, 5867, MENU_CostumePreviewWnd, MENU_CostumePreviewWnd);
			setList(CATEGORY_LINE_3, 645, MENU_ShopLcoinCraftWnd, MENU_ShopLcoinCraftWnd);
			setList(CATEGORY_LINE_3, 2796, MENU_InstancedZone, MENU_InstancedZone);
			setList(CATEGORY_LINE_3, 389, MENU_PartyMatchWnd, MENU_PartyMatchWnd);
			setList(CATEGORY_LINE_3, 13476, MENU_CollectionSystem, "");
			setList(CATEGORY_LINE_3, 14157, MENU_HeroBookWnd, "");
			setList(CATEGORY_LINE_3, 13025, MENU_TimeZoneWnd, "");
			setList(CATEGORY_LINE_4, 3845, MENU_OlympiadWnd, "");
			//setList(CATEGORY_LINE_4, 13343, MENU_HomunculusWnd, "");
			setList(CATEGORY_LINE_4, 3506, MENU_TodoListWnd, "");
			setList(CATEGORY_LINE_4, 711, MENU_MacroWnd, MENU_MacroWnd);
			setList(CATEGORY_LINE_4, 13249, MENU_YetiWnd, MENU_YetiWnd, ! isKorean);
			setList(CATEGORY_LINE_4, 146, MENU_OptionWnd, MENU_OptionWnd);
		}
	}	
}

function onMenuClick(string MenuName)
{
	switch(MenuName)
	{
		// End:0x1B
		case MENU_Attend:
			// End:0x56
			if(class'UIAPI_WINDOW'.static.IsShowWindow("AttendCheckWnd"))
			{
				class'UIAPI_WINDOW'.static.HideWindow("AttendCheckWnd");			
			}
			else
			{
				RequestAttendanceWndOpen();
			}
			// End:0x3A5
			break;
		// End:0x2E
		case MENU_NShop:
			clickNShopMenu();
			// End:0x3A5
			break;
		// End:0x47
		case MENU_OlympiadWnd:
			OlympiadWndMenu();
			// End:0x3A5
			break;
		// End:0x6F
		case MENU_OlympiadRandomChallengeWnd:
			// End:0x106
			if(class'UIAPI_WINDOW'.static.IsShowWindow(MENU_OlympiadRandomChallengeWnd))
			{
				class'UIAPI_WINDOW'.static.HideWindow(MENU_OlympiadRandomChallengeWnd);				
			}
			else
			{
				OlympiadRandomChallengeMenu();
			}
			break;
		// End:0x84
		case MENU_Ability:
			showHideAbilityWnd();
			// End:0x3A5
			break;
		case MENU_RevengeWnd:
			showHideRevengeWnd();
			// End:0x3A5
			break;
		// End:0xD6
		case MENU_IngameWebWnd:
			ShowHideIngameWebMain();
			// End:0x3A5
			break;
		// End:0xE7
		case MENU_BBS:
			ShowHideIngameWebBBS();
			// End:0x3A5
			break;
		// End:0xFD
		case MENU_MacroWnd:
			ShowHideMacroWnd();
			// End:0x3A5
			break;
		// End:0x110
		case MENU_LShop:
			HandleToggleShowShopDailyWnd();
			// End:0x3A5
			break;
		// End:0x12F
		case MENU_VitamainService:
			// End:0x1EE
			if(class'UIAPI_WINDOW'.static.IsShowWindow("PremiumManagerWnd"))
			{
				class'UIAPI_WINDOW'.static.HideWindow("PremiumManagerWnd");				
			}
			else
			{
				RequestOpenWndWithoutNPC(OPEN_PREMIUM_MANAGER);
			}
			// End:0x3A5
			break;
		// End:0x143
		case MENU_PcRoom:
			HandleToggleShowPCCafeCommuniWnd();
			// End:0x3A5
			break;
		// End:0x17D
		case MENU_YetiWnd:
			YetiPCModeChangeWnd(GetScript("YetiPCModeChangeWnd")).setYetiMode(true);
			// End:0x3A5
			break;
		// End:0x18E
		case MENU_Qna:
			handleShowQABoardWnd();
			// End:0x3A5
			break;
		// End:0x1E4
		case MENU_FactionWnd:
			// End:0x1CD
			if(class'UIDATA_PLAYER'.static.IsInDethrone())
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));				
			}
			else
			{
				toggleWindow(MENU_FactionWnd, true, true);
			}
			// End:0x3A5
			break;
		// End:0x20A
		case MENU_ClanSearch:
			toggleWindow(MENU_ClanSearch, true, true);
			// End:0x3A5
			break;
		// End:0x220
		case MENU_Einhasad:
			HandleToggleShowShopDailyWnd();
			// End:0x3A5
			break;
		// End:0x25E
		case MENU_RestoreLostPropertyWnd:
			toggleWindow(MENU_RestoreLostPropertyWnd, true, true);
			// End:0x3A5
			break;
		// End:0x27C
		case MENU_CollectionSystem:
			OpenCollectionSelectedItem();
			break;
		// End:0x2AD
		case MENU_ShopLcoinCraft:
			toggleWindow(MENU_ShopLcoinCraftWnd, true, true);
			// End:0x3A5
			break;
		// End:0x2D9
		case MENU_ShopFind:
			toggleWindow("PrivateShopFindWnd", true, true);
			// End:0x3A5
			break;
		// End:0x397
		case MENU_HennaMenuWnd:
			// End:0x32C
			if(GetWindowHandle(MENU_HennaMenuWnd).IsShowWindow())
			{
				GetWindowHandle(MENU_HennaMenuWnd).HideWindow();				
			}
			else if(GetWindowHandle("HennaEnchantWnd").IsShowWindow())
			{
				GetWindowHandle("HennaEnchantWnd").HideWindow();					
			}
			else
			{
				toggleWindow(MENU_HennaMenuWnd, true, true);
			}
			// End:0x3A5
			break;
		case MENU_TimeZoneWnd:
			// End:0x492
			if(getInstanceUIData().getIsClassicServer())
			{
				toggleWindow(MENU_TimeZoneWnd, true, true);				
			}
			else if(IsPlayerOnWorldRaidServer())				
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));					
			}
			else
			{
				toggleWindow(MENU_TimeZoneWnd, true, true);
			}
			break;
		case MENU_AdenaDistributionWnd:
			// End:0x44E
			if(! class'UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWndReport"))
			{
				CallGFxFunction(MENU_AdenaDistributionWnd, "RequestDivideAdenaStart", "");				
			}
			else
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5104));
			}
			break;
		case MENU_WorldExchangeBuyWnd:
			if(GetWindowHandle("WorldExchangeBuyWnd").IsShowWindow())
			{
				class'WorldExchangeBuyWnd'.static.Inst()._Hide();				
			}
			else if(GetWindowHandle("WorldExchangeRegiWnd").IsShowWindow())
			{
				class'WorldExchangeRegiWnd'.static.Inst()._Hide();					
			}
			else
			{
				class'WorldExchangeBuyWnd'.static.Inst()._Show();
			}
			break;
		// End:0x630
		case MENU_ElementalSpiritWnd:
			// End:0x603
			if(class'UIAPI_WINDOW'.static.IsShowWindow("elementalSpiritWnd"))
			{
				class'UIAPI_WINDOW'.static.HideWindow("elementalSpiritWnd");				
			}
			else
			{
				ElementalSpiritWnd(GetScript(MENU_ElementalSpiritWnd))._API_RequestElementalSpiritInfo(true);
			}
			// End:0x6BB
			break;
		// End:0x6AD
		case MENU_MagicSkillWnd:
			// End:0x69F
			if(IsUseRenewalSkillWnd())
			{
				// End:0x683
				if(class'UIAPI_WINDOW'.static.IsShowWindow("SkillWnd"))
				{
					class'UIAPI_WINDOW'.static.HideWindow("SkillWnd");					
				}
				else
				{
					class'UIAPI_WINDOW'.static.ShowWindow("SkillWnd");
				}				
			}
			else
			{
				showByShortcutFunction(MenuName);
			}
			// End:0x6BB
			break;
		case MENU_CostumePreviewWnd:
			// End:0x781
            if(Class'UIAPI_WINDOW'.static.IsShowWindow("CostumePreviewWnd"))
            {
                Class'UIAPI_WINDOW'.static.HideWindow("CostumePreviewWnd");                
            }
            else
            {
                Class'UIAPI_WINDOW'.static.ShowWindow("CostumePreviewWnd");
            }
            // End:0x7AD
            break;
		default:
			showByShortcutFunction(MenuName);
			break;
	}
}

function OpenCollectionSelectedItem()
{
	local CollectionSystem collectionSystemScript;

	collectionSystemScript = CollectionSystem(GetScript(MENU_CollectionSystem));
	collectionSystemScript.API_C_EX_COLLECTION_OPEN_UI();
}

function handleShowQABoardWnd()
{
	local string strParam;

	ParamAdd(strParam, "Index", "8");
	ExecuteEvent(EV_ShowBBS, strParam);
}

function HandleToggleShowShopDailyWnd()
{
	// End:0x37
	if(IsAdenServer() || getInstanceUIData().getIsClassicServer())
	{
		toggleWindow("ShopLcoinWnd", true, true);		
	}
	else
	{
		toggleWindow("ShopLcoinWnd", true, true);
	}
}

function string getMenuIconTexture(string MenuName)
{
	local string Tex;

	switch(MenuName)
	{
		// End:0x47
		case MENU_Ability:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Ability";
			// End:0xE54
			break;
		// End:0x8B
		case MENU_Attend:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_AttendCheack";
			// End:0xE54
			break;
		// End:0xE6
		case MENU_OlympiadRandomChallengeWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_RandomChallenge";
			// End:0xE54
			break;
		// End:0x12B
		case MENU_Productinven:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Product";
			// End:0xE54
			break;
		// End:0x179
		case MENU_ShopLcoinCraft:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShopLcoinCraft";
			// End:0xE54
			break;
		// End:0x1B5
		case MENU_NShop:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Nshop";
			// End:0xE54
			break;
		// End:0x1FA
		case MENU_OlympiadWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Olympiad";
			// End:0xE54
			break;
		// End:0x23D
		case MENU_RevengeWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Revenge";
			// End:0xE54
			break;
		// End:0x287
		case MENU_IngameWebWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Lineage2Home";
			// End:0xE54
			break;
		// End:0x2BF
		case MENU_BBS:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Bbs";
			// End:0xE54
			break;
		// End:0x301
		case MENU_ShopSell:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShopSell";
			// End:0xE54
			break;
		// End:0x341
		case MENU_ShopBuy:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShopBuy";
			// End:0xE54
			break;
		// End:0x389
		case MENU_ShopSellAll:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShopSellAll";
			// End:0xE54
			break;
		// End:0x3CF
		case MENU_ShopSearch:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShopSearch";
			// End:0xE54
			break;
		// End:0x418
		case MENU_ShopFind:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_PrivateShopFind";
			// End:0xE54
			break;
		// End:0x44D
		case MENU_Ability:
			Tex = "L2UI_NewTex.MenuWnd.icon_Nshop";
			// End:0xE54
			break;
		// End:0x487
		case MENU_Post:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Post";
			// End:0xE54
			break;
		// End:0x4D8
		case MENU_ShopLcoinCraftWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShopLcoinCraft";
			// End:0xE54
			break;
		// End:0x521
		case MENU_PartyMatchWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_PartyMatch";
			// End:0xE54
			break;
		// End:0x57B
		case MENU_PersonalConnectionsWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_PersonalConnection";
			// End:0xE54
			break;
		// End:0x5C7
		case MENU_InstancedZone:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_InstancedZone";
			// End:0xE54
			break;
		// End:0x609
		case MENU_Petition:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Petition";
			// End:0xE54
			break;
		// End:0x657
		case MENU_ShortcutAssign:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShortcutAssign";
			// End:0xE54
			break;
		// End:0x696
		case MENU_MacroWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Macro";
			// End:0xE54
			break;
		// End:0x6E4
		case MENU_SiegeCastleInfoWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_CastleInfo";
			// End:0xE54
			break;
		// End:0x72A
		case MENU_ClanSearch:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ClanSearch";
			// End:0xE54
			break;
		// End:0x771
		case MENU_FactionWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_FactionMark";
			// End:0xE54
			break;
		// End:0x7C2
		case MENU_HennaEngraveWndLive:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_HennaEngrave";
			// End:0xE54
			break;
		// End:0x809
		case MENU_PlayerAgeWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Playerage";
			// End:0xE54
			break;
		// End:0x841
		case MENU_Qna:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_QnA";
			// End:0xE54
			break;
		// End:0x882
		case MENU_OptionWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Option";
			// End:0xE54
			break;
		// End:0x8BF
		case MENU_Rec:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_MovieRec";
			// End:0xE54
			break;
		// End:0x904
		case MENU_TimeZoneWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_TimeZone";
			// End:0xE54
			break;
		// End:0x954
		case MENU_VitamainService:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_VitamainService";
			// End:0xE54
			break;
		// End:0x991
		case MENU_YetiWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Yeti";
			// End:0xE54
			break;
		// End:0x9DB
		case MENU_DetailStatusWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Character";
			// End:0xE54
			break;
		// End:0xA22
		case MENU_InventoryWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Inventory";
			// End:0xE54
			break;
		// End:0xA63
		case MENU_ActionWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Action";
			// End:0xE54
			break;
		// End:0xAA7
		case MENU_MagicSkillWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Skill";
			// End:0xE54
			break;
		// End:0xAEA
		case MENU_QuestTreeWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Quest";
			// End:0xE54
			break;
		// End:0xB27
		case MENU_ClanWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Clan";
			// End:0xE54
			break;
		// End:0xB66
		case MENU_LShop:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_LconShop";
			// End:0xE54
			break;
		// End:0xBA9
		case MENU_PcRoom:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_PcRoomEvent";
			// End:0xE54
			break;
		// End:0xBF1
		case MENU_Shortcut:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShortcutAssign";
			// End:0xE54
			break;
		// End:0xC41
		case MENU_PathToAwakening:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_PathToAwakening";
			// End:0xE54
			break;
		// End:0xC8A
		//case MENU_HomunculusWnd:
			///Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Homunculus";
			// End:0xE54
			//break;
		// End:0xCCC
		case MENU_Einhasad:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Einhasad";
			// End:0xE54
			break;
		// End:0xD26
		case MENU_RestoreLostPropertyWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_icon_RestoreLostPropert";
			// End:0xE54в
			break;
		// End:0xD72
		case MENU_CollectionSystem:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Collection";
			// End:0xE54
			break;
		// End:0xDC2
		case MENU_WorldSiegeRankingWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_WorldSiege";
			// End:0xE54
			break;
		// End:0xE07
		case MENU_DethroneWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Dethrone";
			// End:0xE54
			break;
		// End:0xE51
		case MENU_HennaMenuWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_dyepotential";
			// End:0xE54
			break;
		// End:0xE96
		case MENU_HeroBookWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Herobook";
			// End:0xEED
			break;
		// End:0xEEA
		case MENU_AdenaDistributionWnd:
			// End:0xEFD
			if(getInstanceUIData().getIsLiveServer())
			{
				Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_AdenaCalculate";				
			}
			else
			{
				Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_AdenaCalculate_Live";
			}
			break;
		case MENU_TeleportWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_TeleportMap";
			break;
		case MENU_TodoListWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ToDoListWnd";
			break;
		case MENU_WorldExchangeBuyWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_WorldExchangeWnd";
			break;
		case MENU_ElementalSpiritWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ElementalSpiritWnd";
			break;
		case MENU_MiniMapGfxWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Map";
			break;
		case MENU_CostumePreviewWnd:
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Costume";
			break;
	}
	return Tex;
}

function int getMenuIndex(string MenuName)
{
	local int Index;

	switch(MenuName)
	{
		// End:0x1D
		case MENU_Ability:
			Index = 1;
			// End:0x65E
			break;
		// End:0x33
		case MENU_Attend:
			Index = 2;
			// End:0x65E
			break;
		// End:0x5D
		case MENU_OlympiadRandomChallengeWnd:
			Index = 3;
			// End:0x65E
			break;
		// End:0x79
		case MENU_Productinven:
			Index = 4;
			// End:0x65E
			break;
		// End:0x97
		case MENU_ShopLcoinCraft:
			Index = 5;
			// End:0x65E
			break;
		// End:0xAC
		case MENU_NShop:
			Index = 6;
			// End:0x65E
			break;
		// End:0xC7
		case MENU_OlympiadWnd:
			Index = 7;
			// End:0x65E
			break;
		// End:0xE1
		case MENU_RevengeWnd:
			Index = 8;
			// End:0x65E
			break;
		// End:0xFD
		case MENU_IngameWebWnd:
			Index = 9;
			// End:0x65E
			break;
		// End:0x110
		case MENU_BBS:
			Index = 10;
			// End:0x65E
			break;
		// End:0x128
		case MENU_ShopSell:
			Index = 11;
			// End:0x65E
			break;
		// End:0x13F
		case MENU_ShopBuy:
			Index = 12;
			// End:0x65E
			break;
		// End:0x15A
		case MENU_ShopSellAll:
			Index = 13;
			// End:0x65E
			break;
		// End:0x174
		case MENU_ShopSearch:
			Index = 14;
			// End:0x65E
			break;
		// End:0x18C
		case MENU_ShopFind:
			Index = 15;
			// End:0x65E
			break;
		// End:0x1A3
		case MENU_Ability:
			Index = 16;
			// End:0x65E
			break;
		// End:0x1B7
		case MENU_Post:
			Index = 17;
			// End:0x65E
			break;
		// End:0x1D8
		case MENU_ShopLcoinCraftWnd:
			Index = 18;
			// End:0x65E
			break;
		// End:0x1F5
		case MENU_PartyMatchWnd:
			Index = 19;
			// End:0x65E
			break;
		// End:0x21B
		case MENU_PersonalConnectionsWnd:
			Index = 20;
			// End:0x65E
			break;
		// End:0x238
		case MENU_InstancedZone:
			Index = 21;
			// End:0x65E
			break;
		// End:0x250
		case MENU_Petition:
			Index = 22;
			// End:0x65E
			break;
		// End:0x26E
		case MENU_ShortcutAssign:
			Index = 23;
			// End:0x65E
			break;
		// End:0x286
		case MENU_MacroWnd:
			Index = 24;
			// End:0x65E
			break;
		// End:0x2A8
		case MENU_SiegeCastleInfoWnd:
			Index = 25;
			// End:0x65E
			break;
		// End:0x2C2
		case MENU_ClanSearch:
			Index = 26;
			// End:0x65E
			break;
		// End:0x2DC
		case MENU_FactionWnd:
			Index = 27;
			// End:0x65E
			break;
		// End:0x2FF
		case MENU_HennaEngraveWndLive:
			Index = 28;
			// End:0x65E
			break;
		// End:0x31B
		case MENU_PlayerAgeWnd:
			Index = 29;
			// End:0x65E
			break;
		// End:0x32E
		case MENU_Qna:
			Index = 30;
			// End:0x65E
			break;
		// End:0x347
		case MENU_OptionWnd:
			Index = 31;
			// End:0x65E
			break;
		// End:0x35A
		case MENU_Rec:
			Index = 32;
			// End:0x65E
			break;
		// End:0x375
		case MENU_TimeZoneWnd:
			Index = 33;
			// End:0x65E
			break;
		// End:0x394
		case MENU_VitamainService:
			Index = 34;
			// End:0x65E
			break;
		// End:0x3AB
		case MENU_YetiWnd:
			Index = 35;
			// End:0x65E
			break;
		// End:0x3CA
		case MENU_DetailStatusWnd:
			Index = 36;
			// End:0x65E
			break;
		// End:0x3E6
		case MENU_InventoryWnd:
			Index = 37;
			// End:0x65E
			break;
		// End:0x3FF
		case MENU_ActionWnd:
			Index = 38;
			// End:0x65E
			break;
		// End:0x41C
		case MENU_MagicSkillWnd:
			Index = 39;
			// End:0x65E
			break;
		// End:0x438
		case MENU_QuestTreeWnd:
			Index = 40;
			// End:0x65E
			break;
		// End:0x44F
		case MENU_ClanWnd:
			Index = 41;
			// End:0x65E
			break;
		// End:0x464
		case MENU_LShop:
			Index = 42;
			// End:0x65E
			break;
		// End:0x47A
		case MENU_PcRoom:
			Index = 43;
			// End:0x65E
			break;
		// End:0x492
		case MENU_Shortcut:
			Index = 44;
			// End:0x65E
			break;
		// End:0x4B1
		case MENU_PathToAwakening:
			Index = 45;
			// End:0x65E
			break;
		// End:0x4CE
		//case MENU_HomunculusWnd:
			//Index = 46;
			// End:0x65E
			//break;
		// End:0x4E6
		case MENU_Einhasad:
			Index = 47;
			// End:0x65E
			break;
		// End:0x50C
		case MENU_RestoreLostPropertyWnd:
			Index = 48;
			// End:0x65E
			break;
		// End:0x52C
		case MENU_CollectionSystem:
			Index = 49;
			// End:0x65E
			break;
		// End:0x550
		case MENU_WorldSiegeRankingWnd:
			Index = 50;
			// End:0x65E
			break;
		// End:0x56B
		case MENU_DethroneWnd:
			Index = 51;
			// End:0x65E
			break;
		// End:0x587
		case MENU_HennaMenuWnd:
			Index = 52;
			// End:0x65E
			break;
		// End:0x5A2
		case MENU_HeroBookWnd:
			Index = 53;
			// End:0x65E
			break;
		// End:0x5C6
		case MENU_AdenaDistributionWnd:
			Index = 54;
			// End:0x65E
			break;
		// End:0x5E1
		case MENU_TeleportWnd:
			Index = 55;
			// End:0x65E
			break;
		// End:0x5FC
		case MENU_TodoListWnd:
			Index = 56;
			// End:0x65E
			break;
		// End:0x61F
		case MENU_WorldExchangeBuyWnd:
			Index = 57;
			// End:0x65E
			break;
		// End:0x641
		case MENU_ElementalSpiritWnd:
			Index = 58;
			// End:0x65E
			break;
		// End:0x65B
		case MENU_MiniMapGfxWnd:
			Index = 59;
			// End:0x65E
			break;
		case MENU_CostumePreviewWnd:
			Index = 60;
			// End:0x65E
			break;
	}
	return Index;	
}

function string getMenuString(int menuNameIndex)
{
	local string MenuName;

	switch(menuNameIndex)
	{
		// End:0x1D
		case 1:
			MenuName = MENU_Ability;
			// End:0x65E
			break;
		// End:0x33
		case 2:
			MenuName = MENU_Attend;
			// End:0x65E
			break;
		// End:0x5D
		case 3:
			MenuName = MENU_OlympiadRandomChallengeWnd;
			// End:0x65E
			break;
		// End:0x79
		case 4:
			MenuName = MENU_Productinven;
			// End:0x65E
			break;
		// End:0x97
		case 5:
			MenuName = MENU_ShopLcoinCraft;
			// End:0x65E
			break;
		// End:0xAC
		case 6:
			MenuName = MENU_NShop;
			// End:0x65E
			break;
		// End:0xC7
		case 7:
			MenuName = MENU_OlympiadWnd;
			// End:0x65E
			break;
		// End:0xE1
		case 8:
			MenuName = MENU_RevengeWnd;
			// End:0x65E
			break;
		// End:0xFD
		case 9:
			MenuName = MENU_IngameWebWnd;
			// End:0x65E
			break;
		// End:0x110
		case 10:
			MenuName = MENU_BBS;
			// End:0x65E
			break;
		// End:0x128
		case 11:
			MenuName = MENU_ShopSell;
			// End:0x65E
			break;
		// End:0x13F
		case 12:
			MenuName = MENU_ShopBuy;
			// End:0x65E
			break;
		// End:0x15A
		case 13:
			MenuName = MENU_ShopSellAll;
			// End:0x65E
			break;
		// End:0x174
		case 14:
			MenuName = MENU_ShopSearch;
			// End:0x65E
			break;
		// End:0x18C
		case 15:
			MenuName = MENU_ShopFind;
			// End:0x65E
			break;
		// End:0x1A3
		case 16:
			MenuName = MENU_Ability;
			// End:0x65E
			break;
		// End:0x1B7
		case 17:
			MenuName = MENU_Post;
			// End:0x65E
			break;
		// End:0x1D8
		case 18:
			MenuName = MENU_ShopLcoinCraftWnd;
			// End:0x65E
			break;
		// End:0x1F5
		case 19:
			MenuName = MENU_PartyMatchWnd;
			// End:0x65E
			break;
		// End:0x21B
		case 20:
			MenuName = MENU_PersonalConnectionsWnd;
			// End:0x65E
			break;
		// End:0x238
		case 21:
			MenuName = MENU_InstancedZone;
			// End:0x65E
			break;
		// End:0x250
		case 22:
			MenuName = MENU_Petition;
			// End:0x65E
			break;
		// End:0x26E
		case 23:
			MenuName = MENU_ShortcutAssign;
			// End:0x65E
			break;
		// End:0x286
		case 24:
			MenuName = MENU_MacroWnd;
			// End:0x65E
			break;
		// End:0x2A8
		case 25:
			MenuName = MENU_SiegeCastleInfoWnd;
			// End:0x65E
			break;
		// End:0x2C2
		case 26:
			MenuName = MENU_ClanSearch;
			// End:0x65E
			break;
		// End:0x2DC
		case 27:
			MenuName = MENU_FactionWnd;
			// End:0x65E
			break;
		// End:0x2FF
		case 28:
			MenuName = MENU_HennaEngraveWndLive;
			// End:0x65E
			break;
		// End:0x31B
		case 29:
			MenuName = MENU_PlayerAgeWnd;
			// End:0x65E
			break;
		// End:0x32E
		case 30:
			MenuName = MENU_Qna;
			// End:0x65E
			break;
		// End:0x347
		case 31:
			MenuName = MENU_OptionWnd;
			// End:0x65E
			break;
		// End:0x35A
		case 32:
			MenuName = MENU_Rec;
			// End:0x65E
			break;
		// End:0x375
		case 33:
			MenuName = MENU_TimeZoneWnd;
			// End:0x65E
			break;
		// End:0x394
		case 34:
			MenuName = MENU_VitamainService;
			// End:0x65E
			break;
		// End:0x3AB
		case 35:
			MenuName = MENU_YetiWnd;
			// End:0x65E
			break;
		// End:0x3CA
		case 36:
			MenuName = MENU_DetailStatusWnd;
			// End:0x65E
			break;
		case 37:
			MenuName = MENU_InventoryWnd;
			break;
		case 38:
			MenuName = MENU_ActionWnd;
			break;
		case 39:
			MenuName = MENU_MagicSkillWnd;
			break;
		case 40:
			MenuName = MENU_QuestTreeWnd;
			break;
		// End:0x44F
		case 41:
			MenuName = MENU_ClanWnd;
			break;
		// End:0x464
		case 42:
			MenuName = MENU_LShop;
			// End:0x65E
			break;
		// End:0x47A
		case 43:
			MenuName = MENU_PcRoom;
			// End:0x65E
			break;
		// End:0x492
		case 44:
			MenuName = MENU_Shortcut;
			// End:0x65E
			break;
		// End:0x4B1
		case 45:
			MenuName = MENU_PathToAwakening;
			// End:0x65E
			break;
		// End:0x4CE
		//case 46:
			//MenuName = MENU_HomunculusWnd;
			// End:0x65E
			//break;
		// End:0x4E6
		case 47:
			MenuName = MENU_Einhasad;
			// End:0x65E
			break;
		// End:0x50C
		case 48:
			MenuName = MENU_RestoreLostPropertyWnd;
			// End:0x65E
			break;
		// End:0x52C
		case 49:
			MenuName = MENU_CollectionSystem;
			// End:0x65E
			break;
		// End:0x550
		case 50:
			MenuName = MENU_WorldSiegeRankingWnd;
			// End:0x65E
			break;
		// End:0x56B
		case 51:
			MenuName = MENU_DethroneWnd;
			// End:0x65E
			break;
		// End:0x587
		case 52:
			MenuName = MENU_HennaMenuWnd;
			// End:0x65E
			break;
		// End:0x5A2
		case 53:
			MenuName = MENU_HeroBookWnd;
			// End:0x65E
			break;
		// End:0x5C6
		case 54:
			MenuName = MENU_AdenaDistributionWnd;
			break;
		case 55:
			MenuName = MENU_TeleportWnd;
			// End:0x65E
			break;
		// End:0x5FC
		case 56:
			MenuName = MENU_TodoListWnd;
			break;
		case 57:
			MenuName = MENU_WorldExchangeBuyWnd;
			break;
		case 58:
			MenuName = MENU_ElementalSpiritWnd;
			break;
		case 59:
			MenuName = MENU_MiniMapGfxWnd;
			// End:0x65E
			break;
		case 60:
			MenuName = MENU_CostumePreviewWnd;
			break;
	}
	return MenuName;	
}

event OnCilckCheckBoxWithHandle(CheckBoxHandle a_CheckBoxHandle)
{
	local array<MenuButtonSlotStruct> arrayCheckedMenu;
	local int CategoryIndex, buttonIndex;

	CategoryIndex = int(Right(a_CheckBoxHandle.GetParentWindowHandle().GetParentWindowName(), 1));
	buttonIndex = int(Right(a_CheckBoxHandle.GetParentWindowName(), 2));
	// End:0xCF
	if(GetCheckBoxHandle("MenuEntireWnd.MenuCategory" $ string(CategoryIndex) $ ".MenuButtonSlot" $ fillZero(buttonIndex) $ ".checkBox").IsChecked())
	{
		menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].nSequence = nSquenceAdd;
		nSquenceAdd++;		
	}
	else
	{
		menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].nSequence = 0;
	}
	arrayCheckedMenu = getCheckboxChecked();
	// End:0x129
	if(arrayCheckedMenu.Length > 9)
	{
		lockCheckboxChecked();
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13806));		
	}
	else
	{
		unlockCheckboxChecked();
	}
	Menu(GetScript("Menu")).setBTN();	
}

function lockCheckboxChecked()
{
	local int CategoryIndex, buttonIndex;

	// End:0x187 [Loop If]
	for(CategoryIndex = 0; CategoryIndex < menuSlotArray.Length; CategoryIndex++)
	{
		// End:0x17D [Loop If]
		for(buttonIndex = 0; buttonIndex < MAX_CATEGORYBUTTONNUM; buttonIndex++)
		{
			// End:0x173
			if(buttonIndex < menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length)
			{
				// End:0x111
				if(! GetCheckBoxHandle("MenuEntireWnd.MenuCategory" $ string(CategoryIndex) $ ".MenuButtonSlot" $ fillZero(buttonIndex) $ ".checkBox").IsChecked())
				{
					GetCheckBoxHandle("MenuEntireWnd.MenuCategory" $ string(CategoryIndex) $ ".MenuButtonSlot" $ fillZero(buttonIndex) $ ".checkBox").DisableWindow();
					// [Explicit Continue]
					continue;
				}
				GetCheckBoxHandle("MenuEntireWnd.MenuCategory" $ string(CategoryIndex) $ ".MenuButtonSlot" $ fillZero(buttonIndex) $ ".checkBox").EnableWindow();
			}
		}
	}	
}

function unlockCheckboxChecked()
{
	local int CategoryIndex, buttonIndex;

	// End:0xBB [Loop If]
	for(CategoryIndex = 0; CategoryIndex < menuSlotArray.Length; CategoryIndex++)
	{
		// End:0xB1 [Loop If]
		for(buttonIndex = 0; buttonIndex < MAX_CATEGORYBUTTONNUM; buttonIndex++)
		{
			// End:0xA7
			if(buttonIndex < menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length)
			{
				GetCheckBoxHandle("MenuEntireWnd.MenuCategory" $ string(CategoryIndex) $ ".MenuButtonSlot" $ fillZero(buttonIndex) $ ".checkBox").EnableWindow();
			}
		}
	}	
}

function array<MenuButtonSlotStruct> getCheckboxChecked()
{
	local int CategoryIndex, buttonIndex;
	local array<MenuButtonSlotStruct> MainMenuButtonSlotStructArray;

	// End:0xE1 [Loop If]
	for(CategoryIndex = 0; CategoryIndex < menuSlotArray.Length; CategoryIndex++)
	{
		
		// End:0xD7 [Loop If]
		for(buttonIndex = 0; buttonIndex < MAX_CATEGORYBUTTONNUM; buttonIndex++)
		{
			// End:0xCD
			if(buttonIndex < menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length)
			{
				// End:0xCD
				if(GetCheckBoxHandle("MenuEntireWnd.MenuCategory" $ string(CategoryIndex) $ ".MenuButtonSlot" $ fillZero(buttonIndex) $ ".checkBox").IsChecked())
				{
					MainMenuButtonSlotStructArray[MainMenuButtonSlotStructArray.Length] = menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex];
				}
			}
		}
	}
	MainMenuButtonSlotStructArray.Sort(SortDelegate);
	return MainMenuButtonSlotStructArray;	
}

function loadOptionIni()
{
	local int CategoryIndex, buttonIndex, i;
	local array<string> ArrayStr;
	local string rStr, isMenuSetting;

	GetINIString("MenuEntireWnd", "e", isMenuSetting, "WindowsInfo.ini");
	// End:0x41
	if(int(isMenuSetting) == 0)
	{
		setDefaultOptionIni();
	}
	GetINIString("MenuEntireWnd", "a", rStr, "WindowsInfo.ini");
	nSquenceAdd = 0;
	// End:0x233
	if(rStr != "")
	{
		Split(rStr, ",", ArrayStr);

		// End:0x233 [Loop If]
		for(CategoryIndex = 0; CategoryIndex < menuSlotArray.Length; CategoryIndex++)
		{
			// End:0x229 [Loop If]
			for(buttonIndex = 0; buttonIndex < MAX_CATEGORYBUTTONNUM; buttonIndex++)
			{
				// End:0x21F
				if(buttonIndex < menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length)
				{
					GetCheckBoxHandle("MenuEntireWnd.MenuCategory" $ string(CategoryIndex) $ ".MenuButtonSlot" $ fillZero(buttonIndex) $ ".checkBox").SetCheck(false);

					// End:0x21F [Loop If]
					for(i = 0; i < ArrayStr.Length; i++)
					{
						// End:0x215
						if(getMenuString(int(ArrayStr[i])) == menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].MenuName)
						{
							menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].nSequence = i;
							++ nSquenceAdd;
							GetCheckBoxHandle("MenuEntireWnd.MenuCategory" $ string(CategoryIndex) $ ".MenuButtonSlot" $ fillZero(buttonIndex) $ ".checkBox").SetCheck(true);
							// [Explicit Break]
							break;
						}
					}
				}
			}
		}
	}
	// End:0x2D8
	if(ArrayStr.Length != nSquenceAdd)
	{
		Debug("----- 전체 메뉴와 메인 메뉴 수량이 달라짐, 다시 저장 하기 ------");
		Debug("menuSlotArray.Length :" @ string(ArrayStr.Length));
		Debug("nSquenceAdd: " @ string(nSquenceAdd));
		saveOptionIni(true);
	}	
}

function setDefaultOptionIni()
{
	local string saveString;
	local ELanguageType Language;
	local bool isKorean;

	Language = GetLanguage();
	isKorean = Language == ELanguageType.LANG_Korean;
	// End:0x2BD
	if(isKorean)
	{
		// End:0x1DA
		if(getInstanceUIData().getIsClassicServer())
		{
			// End:0x111
			if(IsAdenServer())
			{
				saveString = string(getMenuIndex(MENU_TeleportWnd)) $ "," $ string(getMenuIndex(MENU_MiniMapGfxWnd)) $ "," $ string(getMenuIndex(MENU_DetailStatusWnd)) $ "," $ string(getMenuIndex(MENU_InventoryWnd)) $ "," $ string(getMenuIndex(MENU_TimeZoneWnd)) $ "," $ string(getMenuIndex(MENU_WorldExchangeBuyWnd)) $ "," $ string(getMenuIndex(MENU_LShop));				
			}
			else
			{
				saveString = string(getMenuIndex(MENU_TeleportWnd)) $ "," $ string(getMenuIndex(MENU_CollectionSystem)) $ "," $ string(getMenuIndex(MENU_MiniMapGfxWnd)) $ "," $ string(getMenuIndex(MENU_DetailStatusWnd)) $ "," $ string(getMenuIndex(MENU_InventoryWnd)) $ "," $ string(getMenuIndex(MENU_TimeZoneWnd)) $ "," $ string(getMenuIndex(MENU_LShop));
			}			
		}
		else
		{
			saveString = string(getMenuIndex(MENU_TeleportWnd)) $ "," $ string(getMenuIndex(MENU_DetailStatusWnd)) $ "," $ string(getMenuIndex(MENU_InventoryWnd)) $ "," $ string(getMenuIndex(MENU_ActionWnd)) $ "," $ string(getMenuIndex(MENU_MagicSkillWnd)) $ "," $ string(getMenuIndex(MENU_QuestTreeWnd)) $ "," $ string(getMenuIndex(MENU_ClanWnd)) $ "," $ string(getMenuIndex(MENU_MiniMapGfxWnd));
		}		
	}
	else
	{
		// End:0x442
		if(getInstanceUIData().getIsClassicServer())
		{
			// End:0x38F
			if(IsAdenServer())
			{
				saveString = string(getMenuIndex(MENU_TeleportWnd)) $ "," $ string(getMenuIndex(MENU_MiniMapGfxWnd)) $ "," $ string(getMenuIndex(MENU_DetailStatusWnd)) $ "," $ string(getMenuIndex(MENU_InventoryWnd)) $ "," $ string(getMenuIndex(MENU_TimeZoneWnd)) $ "," $ string(getMenuIndex(MENU_WorldExchangeBuyWnd));				
			}
			else
			{
				saveString = string(getMenuIndex(MENU_TeleportWnd)) $ "," $ string(getMenuIndex(MENU_CollectionSystem)) $ "," $ string(getMenuIndex(MENU_MiniMapGfxWnd)) $ "," $ string(getMenuIndex(MENU_DetailStatusWnd)) $ "," $ string(getMenuIndex(MENU_InventoryWnd)) $ "," $ string(getMenuIndex(MENU_TimeZoneWnd));
			}			
		}
		else
		{
			saveString = string(getMenuIndex(MENU_TeleportWnd)) $ "," $ string(getMenuIndex(MENU_DetailStatusWnd)) $ "," $ string(getMenuIndex(MENU_InventoryWnd)) $ "," $ string(getMenuIndex(MENU_ActionWnd)) $ "," $ string(getMenuIndex(MENU_MagicSkillWnd)) $ "," $ string(getMenuIndex(MENU_QuestTreeWnd)) $ "," $ string(getMenuIndex(MENU_ClanWnd)) $ "," $ string(getMenuIndex(MENU_MiniMapGfxWnd));
		}
	}
	SetINIString("MenuEntireWnd", "a", saveString, "WindowsInfo.ini");
	SetINIString("MenuEntireWnd", "b", "1", "WindowsInfo.ini");	
}

function saveOptionIni(optional bool bDoNotNeverUse)
{
	local int i;
	local array<MenuButtonSlotStruct> menuArr;
	local string rStr;

	menuArr = getCheckboxChecked();

	for(i = 0; i < menuArr.Length; i++)
	{
		// End:0x4F
		if(i == 0)
		{
			rStr = string(getMenuIndex(menuArr[i].MenuName));
			// [Explicit Continue]
			continue;
		}
		rStr = rStr $ "," $ string(getMenuIndex(menuArr[i].MenuName));
	}
	Debug("저장된 save str:" @ rStr);
	SetINIString("MenuEntireWnd", "a", rStr, "WindowsInfo.ini");
	// End:0x108
	if(bDoNotNeverUse == false)
	{
		SetINIString("MenuEntireWnd", "e", "1", "WindowsInfo.ini");
	}	
}

delegate int SortDelegate(MenuButtonSlotStruct A, MenuButtonSlotStruct B)
{
	// End:0x1F
	if(A.nSequence > B.nSequence)
	{
		return -1;
	}
	return 0;	
}

function MenuButtonSlotStruct getSlotStructByMenuName(string MenuName)
{
	local int CategoryIndex, buttonIndex;
	local MenuButtonSlotStruct emptyStruct;

	for(CategoryIndex = 0; CategoryIndex < menuSlotArray.Length; CategoryIndex++)
	{
		for(buttonIndex = 0; buttonIndex < MAX_CATEGORYBUTTONNUM; buttonIndex++)
		{
			// End:0x81
			if(buttonIndex < menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length)
			{
				// End:0x81
				if(menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].MenuName == MenuName)
				{
					return menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex];
				}
			}
		}
	}
	return emptyStruct;	
}

function OnLButtonDown(WindowHandle btnHandle, int X, int Y)
{
	local int CategoryIndex, buttonIndex;

	// End:0x84
	if(Left(btnHandle.GetWindowName(), 7) == "MenuBtn")
	{
		CategoryIndex = int(Right(btnHandle.GetParentWindowHandle().GetParentWindowName(), 1));
		buttonIndex = int(Right(btnHandle.GetParentWindowName(), 2));
		onMenuClick(menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].MenuName);		
	}
	else if(btnHandle.GetWindowName() == "FixedMenuBtn" && bEditMode == false)
	{
		buttonIndex = int(Right(btnHandle.GetParentWindowName(), 2));
		Debug("btnHandle.GetParentWindowName()" @ btnHandle.GetParentWindowName());
		Debug("buttonIndex" @ string(buttonIndex));
		onMenuClick(fixedMenuSlotStructArray[buttonIndex].MenuName);			
	}
	else
	{
		switch(btnHandle.GetWindowName())
		{
			case "RestartBtn":
				showHideRestart();
				break;
			case "ExitBtn":
				showHideExit();
				break;
			case "HelpBtn":
				ShowHelp();
				break;
			case "EditBtn":
			case "ApplyMenuEditBtn":
				bEditMode = ! bEditMode;
				// End:0x1FD
				if(bEditMode)
				{
					nSystemMenuWndFocus = 0;
					refreshMenu();
					setEditMode(true);
					Me.ShowWindow();
					Me.SetFocus();						
				}
				else
				{
					nSystemMenuWndFocus = 0;
					getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13803));
					saveOptionIni();
					refreshMenu();
					setEditMode(false);
					Me.KillTimer(TIMER_ID);
					Me.SetTimer(TIMER_ID, TIMER_DELAY);
				}
				break;
				case "DefaultMenuBtn":
					MenueClose();
					nSystemMenuWndFocus = 1;
					bEditMode = false;
					setEditMode(false);
					setDefaultOptionIni();
					loadOptionIni();
					Menu(GetScript("Menu")).ShowHideMenus(true);
					refreshMenu();
					getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13805));
					break;
				case "CancelMenuEditBtn":
					bEditMode = false;
					nSystemMenuWndFocus = 0;
					getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13804));
					loadOptionIni();
					refreshMenu();
					setEditMode(false);
					Me.KillTimer(TIMER_ID);
					Me.SetTimer(TIMER_ID, TIMER_DELAY);
					break;
				case "OptionBtn":
					onMenuClick(MENU_OptionWnd);
					break;
		}
	}
}

function setEditMode(bool bLock)
{
	local int i;

	// End:0x148
	if(bLock)
	{
		GetMeButton("RestartBtn").HideWindow();
		GetMeButton("ExitBtn").HideWindow();
		GetMeButton("OptionBtn").HideWindow();
		GetMeButton("EditBtn").HideWindow();
		GetMeButton("DefaultMenuBtn").ShowWindow();
		GetMeButton("CancelMenuEditBtn").ShowWindow();
		GetMeButton("ApplyMenuEditBtn").ShowWindow();

		// End:0x145 [Loop If]
		for(i = 0; i < MAX_FIXMENU_NUM; i++)
		{
			GetWindowHandle("MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(i) $ ".FixedMenuBtn").DisableWindow();
		}		
	}
	else
	{
		GetMeButton("EditBtn").ShowWindow();
		GetMeButton("RestartBtn").ShowWindow();
		GetMeButton("ExitBtn").ShowWindow();
		GetMeButton("ExitBtn").ShowWindow();
		GetMeButton("OptionBtn").ShowWindow();
		GetMeButton("DefaultMenuBtn").HideWindow();
		GetMeButton("CancelMenuEditBtn").HideWindow();
		GetMeButton("ApplyMenuEditBtn").HideWindow();

		// End:0x29D [Loop If]
		for(i = 0; i < MAX_FIXMENU_NUM; i++)
		{
			GetWindowHandle("MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(i) $ ".FixedMenuBtn").EnableWindow();
		}
	}	
}

function ShowHelp()
{
	Shortcut(GetScript(MENU_Shortcut)).HandleShowHelpHtmlWnd();
}

function MenueClose()
{
	Me.HideWindow();
}

function showHideRestart()
{
	if (GetLanguage() == ELanguageType.LANG_Chinese && ! getInstanceUIData().getIsClassicServer() && IsNewChinaLive())
	{
		ExecuteEvent(20071);
	}
	else
	{
		ExecuteEvent(EV_OpenDialogRestart);
	}
}

function showHideExit()
{
	if (GetLanguage() == ELanguageType.LANG_Chinese && ! getInstanceUIData().getIsClassicServer() && IsNewChinaLive())
	{
		Debug("EV_LogoutConfirmExitShow");
		ExecuteEvent(20070);
	}
	else
	{
		ExecuteEvent(EV_OpenDialogQuit);
	}
}

function setList(int categoryIndex, int stringNum, string MenuName, optional string tooltipKey, optional bool bDoNotUse, optional Color TextColor, optional int bgType)
{
	// End:0x0B
	if(bDoNotUse)
	{
		return;
	}
	if(TextColor.R == 0 && TextColor.G == 0 && TextColor.B == 0)
	{
		TextColor = GetColor(170, 170, 170, 255);
	}
	addMenu(categoryIndex, GetSystemString(stringNum), MenuName, tooltipKey, "", TextColor, bgType);
}

function addCatogory(int categoryIndex)
{
	menuSlotArray.Insert(menuSlotArray.Length, 1);
	menuSlotArray[menuSlotArray.Length - 1].categoryIndex = categoryIndex;
	menuSlotArray[menuSlotArray.Length - 1].MenuButtonSlotStructArray.Remove(0, menuSlotArray[menuSlotArray.Length - 1].MenuButtonSlotStructArray.Length);
}

function addMenu(int CategoryIndex, string buttonText, string MenuName, string tooltipKey, optional string SpecialParam, optional Color TextColor, optional int bgType)
{
	local int buttonIndex;

	buttonIndex = menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Insert(buttonIndex, 1);
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].CategoryIndex = CategoryIndex;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].buttonIndex = buttonIndex;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].MenuName = MenuName;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].nBGTextureIndex = bgType;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].buttonTextColor = TextColor;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].buttonText = buttonText;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].tooltipKey = tooltipKey;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].SpecialParam = SpecialParam;	
}

function setListFixed(int stringNum, string MenuName, optional string tooltipKey, optional bool bDoNotUse, optional Color TextColor)
{
	// End:0x0B
	if(bDoNotUse)
	{
		return;
	}
	// End:0x59
	if(TextColor.R == 0 && TextColor.G == 0 && TextColor.B == 0)
	{
		TextColor = GetColor(170, 170, 170, 255);
	}
	addFixedMenu(GetSystemString(stringNum), MenuName, tooltipKey, "", TextColor);	
}

function addFixedMenu(string buttonText, string MenuName, string tooltipKey, optional string SpecialParam, optional Color TextColor)
{
	fixedMenuSlotStructArray.Length = fixedMenuSlotStructArray.Length + 1;
	fixedMenuSlotStructArray[fixedMenuSlotStructArray.Length - 1].MenuName = MenuName;
	fixedMenuSlotStructArray[fixedMenuSlotStructArray.Length - 1].buttonTextColor = TextColor;
	fixedMenuSlotStructArray[fixedMenuSlotStructArray.Length - 1].buttonText = buttonText;
	fixedMenuSlotStructArray[fixedMenuSlotStructArray.Length - 1].tooltipKey = tooltipKey;
	fixedMenuSlotStructArray[fixedMenuSlotStructArray.Length - 1].SpecialParam = SpecialParam;	
}

function string getTooltipShortcutAutoPlay()
{
	return setMainShortcutString(getAssignedKeyGroup(), "AutoPlay");
}

function setFixedMenuWindow(int buttonIndex, MenuButtonSlotStruct slotStruct)
{
	local string controlPath, ToolTipString;

	controlPath = "MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(buttonIndex);
	GetTextBoxHandle(controlPath $ ".MenuNameTextBox").SetText(slotStruct.buttonText);
	textBoxShortStringWithTooltip(GetTextBoxHandle(controlPath $ ".MenuNameTextBox"), false, -6);
	GetTextBoxHandle(controlPath $ ".MenuNameTextBox").SetTextColor(slotStruct.buttonTextColor);
	ToolTipString = setMainShortcutString(getAssignedKeyGroup(), slotStruct.tooltipKey);
	GetButtonHandle(controlPath $ ".FixedMenuBtn").ClearTooltip();
	if (ToolTipString != "")
	{
		GetButtonHandle(controlPath $ ".FixedMenuBtn").SetTooltipCustomType(MakeTooltipSimpleColorText(ToolTipString, getInstanceL2Util().White));
	}
	GetTextureHandle(controlPath $ ".MenuIcon").SetTexture(getMenuIconTexture(slotStruct.MenuName));
}

function setMenuWindow(int CategoryIndex, int buttonIndex, MenuButtonSlotStruct slotStruct)
{
	local string controlPath, ToolTipString;

	controlPath = "MenuEntireWnd.MenuCategory" $ string(CategoryIndex) $ ".MenuButtonSlot" $ fillZero(buttonIndex);
	GetTextBoxHandle(controlPath $ ".MenuNameTextBox").SetFontIDByName("hs10");
	GetTextBoxHandle(controlPath $ ".MenuNameTextBox").SetText(slotStruct.buttonText);
	textBoxShortStringWithTooltip(GetTextBoxHandle(controlPath $ ".MenuNameTextBox"), false, -6);
	GetTextBoxHandle(controlPath $ ".MenuNameTextBox").SetTextColor(slotStruct.buttonTextColor);
	if(slotStruct.nBGTextureIndex == BG_TYPE2)
	{
		GetTextureHandle(controlPath $ ".MenuBgTexture").SetTexture(BG_TYPE2_TEXTURE);		
	}
	else
	{
		GetTextureHandle(controlPath $ ".MenuBgTexture").SetTexture(BG_TYPE1_TEXTURE);
	}
	ToolTipString = setMainShortcutString(getAssignedKeyGroup(), slotStruct.tooltipKey);
	GetButtonHandle(controlPath $ ".MenuBtn").ClearTooltip();
	// End:0x276
	if(ToolTipString != "")
	{
		GetButtonHandle(controlPath $ ".MenuBtn").SetTooltipCustomType(MakeTooltipSimpleColorText(ToolTipString, getInstanceL2Util().White));
	}
	// End:0x2C5
	if(bEditMode)
	{
		GetCheckBoxHandle(controlPath $ ".checkBox").ShowWindow();
		GetButtonHandle(controlPath $ ".MenuBtn").HideWindow();		
	}
	else
	{
		GetButtonHandle(controlPath $ ".MenuBtn").ShowWindow();
		GetCheckBoxHandle(controlPath $ ".checkBox").HideWindow();
		GetTextureHandle(controlPath $ ".MenuIcon").SetTexture(getMenuIconTexture(slotStruct.MenuName));
	}	
}

function refreshMenu()
{
	local int categoryIndex, buttonIndex, i;

	for (categoryIndex = 0; categoryIndex < menuSlotArray.Length; categoryIndex++)
	{
		if(lastButtonCount < menuSlotArray[categoryIndex].MenuButtonSlotStructArray.Length)
		{
			lastButtonCount = menuSlotArray[categoryIndex].MenuButtonSlotStructArray.Length;
		}

		for (buttonIndex = 0; buttonIndex < MAX_CATEGORYBUTTONNUM; buttonIndex++)
		{
			if (buttonIndex < menuSlotArray[categoryIndex].MenuButtonSlotStructArray.Length)
			{
				GetWindowHandle("MenuEntireWnd.MenuCategory" $ string(categoryIndex) $ ".MenuButtonSlot" $ fillZero(buttonIndex)).ShowWindow();
  				setMenuWindow(categoryIndex, buttonIndex, menuSlotArray[categoryIndex].MenuButtonSlotStructArray[buttonIndex]);
			}
			else
			{
				GetWindowHandle("MenuEntireWnd.MenuCategory" $ string(categoryIndex) $ ".MenuButtonSlot" $ fillZero(buttonIndex)).HideWindow();
			}
		}
	}

	// End:0x1BB [Loop If]
	for(i = 0; i < MAX_FIXMENU_NUM; i++)
	{
		GetWindowHandle("MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(i)).HideWindow();
	}
	
	// End:0x232 [Loop If]
	for(i = 0; i < fixedMenuSlotStructArray.Length; i++)
	{
		GetWindowHandle("MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(i)).ShowWindow();
		setFixedMenuWindow(i, fixedMenuSlotStructArray[i]);
	}
	
	resizeMenuWnd();
	// End:0x1D3
	if(getInstanceUIData().getIsLiveServer())
	{
		AutoUseItemWnd(GetScript("AutoUseItemWnd")).setShortcutTooltip(getTooltipShortcutAutoPlay());
		AutoUseItemWndMin(GetScript("AutoUseItemWndMin")).setShortcutTooltip(getTooltipShortcutAutoPlay());
	}
	else
	{
		AutomaticPlay(GetScript("AutomaticPlay")).setShortcutTooltip(getTooltipShortcutAutoPlay());
	}
	Menu(GetScript("Menu")).setBTN();
}

function resizeMenuWnd()
{
	local Rect R, C, B;
	local int i;

	C = GetWindowHandle("MenuEntireWnd.MenuCategory0").GetRect();
	R = GetWindowHandle("MenuEntireWnd.MenuCategory0.MenuButtonSlot" $ fillZero(lastButtonCount)).GetRect();
	B = menuBgTexture.GetRect();
	Debug("lastButtonCount" @ string(lastButtonCount));

	for (i = 0; i < MAX_CATEGORY; i++)
	{
		GetWindowHandle("MenuEntireWnd.MenuCategory" $ string(i)).SetWindowSize(C.nWidth, R.nY - C.nY);
	}
	Me.SetWindowSize(firstRect.nWidth, (R.nY - C.nY) + (getAddHeight()));
	menuBgTexture.SetWindowSize(B.nWidth, (R.nY - C.nY) + CATEGORYBG_ADD_HEIGHT);
}

function int getAddHeight()
{
	// End:0x25
	if(getInstanceUIData().getIsClassicServer())
	{
		// End:0x22
		if(IsAdenServer())
		{
			return ADD_HEIGHT_ADEN;			
		}
		else
		{
			return ADD_HEIGHT_TALKINGISLAND;
		}
	}
	return ADD_HEIGHT_LIVE;	
}

function showByShortcutFunction(string MenuName)
{
	local string param;

	ParamAdd(param, "Name", MenuName);
	ExecuteEvent(EV_ShowWindow, param);
}

function HandleToggleShowPCCafeCommuniWnd()
{
	if (getInstanceL2Util().getIsPrologueGrowType())
	{
		AddSystemMessage(4533);
	}
	else if(class'UIAPI_WINDOW'.static.IsShowWindow("NPCDialogWnd"))
	{
		class'UIAPI_WINDOW'.static.HideWindow("NPCDialogWnd");			
	}
	else
	{
		RequestOpenWndWithoutNPC(OPEN_PCCAFE_HTML);
	}
}

function ShowHideMacroWnd()
{
	ExecuteEvent(EV_MacroShowListWnd);
}

function ShowHideIngameWebBBS()
{
	local string param;

	ParamAdd(param, "Category", "bbs");
	ExecuteEvent(EV_InGameWebWnd_Info, param);
}

function ShowHideIngameWebMain()
{
	local string param;

	ParamAdd(param, "Category", "main");
	ExecuteEvent(EV_InGameWebWnd_Info, param);
}

function showHideRevengeWnd()
{
	if (Class 'UIAPI_WINDOW'.static.IsShowWindow(MENU_RevengeWnd))
	{
		Class 'UIAPI_WINDOW'.static.HideWindow(MENU_RevengeWnd);
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow(MENU_RevengeWnd);
	}
}

function clickNShopMenu()
{
	NoticeWnd(GetScript("NoticeWnd")).showHideL2InGameWeb(MENU_NShop, "");
}

function showHideAbilityWnd()
{
	if (GetGameStateName() == "ARENABATTLESTATE")
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5575));
		return;
	}
	if (Class 'UIAPI_WINDOW'.static.IsShowWindow("AbilityWnd"))
	{
		Class 'UIAPI_WINDOW'.static.HideWindow("AbilityWnd");
	}
	else
	{
		CallGFxFunction("AbilityWnd", "setShow", "");
	}
}

function OlympiadWndMenu()
{
	if (Class 'UIAPI_WINDOW'.static.IsShowWindow(MENU_OlympiadWnd))
	{
		Class 'UIAPI_WINDOW'.static.HideWindow(MENU_OlympiadWnd);
	}
	else
	{
		RequestOlympiadRecord();
	}
}

function OlympiadRandomChallengeMenu()
{
	local array<byte> stream;
	local UIPacket._C_EX_OLYMPIAD_UI packet;

	packet.cGameRuleType = GameRuleType.GRT_TEAM;
	if (!Class 'UIPacket'.static.Encode_C_EX_OLYMPIAD_UI(stream, packet))
	{
		return;
	}
	Class 'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_OLYMPIAD_UI, stream);
}

function int b2i(bool Value)
{
	// End:0x0E
	if(Value)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

function bool i2b(int Value)
{
	// End:0x10
	if(Value == 0)
	{
		return false;
	}
	else
	{
		return true;
	}
}

function bool GetINIBool2Bool(string Category, string ItemName)
{
	local int bValue;

	// End:0x24
	if(! GetINIBool(Category, ItemName, bValue, "L2.ini"))
	{
		return false;
	}
	return i2b(bValue);
}

function bool getUseVipAttendance()
{
	local string UseVIPAttendanceItemName;

	// End:0x63
	if(getInstanceUIData().getIsClassicServer())
	{
		// End:0x3E
		if(IsAdenServer())
		{
			UseVIPAttendanceItemName = "UseAttendanceSystemAden";			
		}
		else
		{
			UseVIPAttendanceItemName = "UseAttendanceSystemClassic";
		}		
	}
	else
	{
		UseVIPAttendanceItemName = "UseAttendanceSystemLive";
	}
	return GetINIBool2Bool("Localize", UseVIPAttendanceItemName);	
}

function KillIsWorkingTimerTimer()
{
	bIsWorkingTimer = false;
	Me.KillTimer(TIMER_ID);
}

function string fillZero(int Num)
{
	if (Num <= 9)
	{
		return "0" $ string(Num);
	}
	return string(Num);
}

function string getAssignedKeyGroup()
{
	if (GetChatFilterBool("global", "EnterChatting"))
	{
		return "TempStateShortcut";
	}
	return "GamingStateShortcut";
}

function string setMainShortcutString(string GroupName, string commandName, optional bool B)
{
	local ShortcutCommandItem commandItem;
	local OptionWnd optionWndScript;
	local string strShort;

	// End:0x0F
	if(commandName == "")
	{
		return "";
	}
	optionWndScript = OptionWnd(GetScript(MENU_OptionWnd));
	// End:0x82
	if(commandName == "AutoPlay" || commandName == "NextTargetModeChange")
	{
		class'ShortcutAPI'.static.GetAssignedKeyFromCommand(GroupName, commandName, commandItem);		
	}
	else
	{
		class'ShortcutAPI'.static.GetAssignedKeyFromCommand(GroupName, "ShowWindow Name=" $ commandName, commandItem);
	}
	// End:0x215
	if(commandItem.subkey1 == "" && commandItem.subkey2 == "" && commandItem.Key == "")
	{
		// End:0x152
		if(commandName == "AutoPlay" || commandName == "NextTargetModeChange")
		{
			class'ShortcutAPI'.static.GetAssignedKeyFromCommand("GamingStateShortcut", commandName, commandItem);			
		}
		else
		{
			class'ShortcutAPI'.static.GetAssignedKeyFromCommand("GamingStateShortcut", "ShowWindow Name=" $ commandName, commandItem);
		}
		// End:0x1D6
		if(commandItem.subkey1 == "" && commandItem.subkey2 == "" && commandItem.Key == "")
		{
			strShort = "";			
		}
		else
		{
			// End:0x1EF
			if(B)
			{
				strShort = strShort $ "n";
			}
			strShort = strShort $ "<" $ GetSystemString(1523) $ ": ";
		}		
	}
	else
	{
		// End:0x22E
		if(B)
		{
			strShort = strShort $ "n";
		}
		strShort = strShort $ "<" $ GetSystemString(1523) $ ": ";
	}
	// End:0x28D
	if(commandItem.subkey1 != "")
	{
		strShort = strShort $ optionWndScript.GetUserReadableKeyName(commandItem.subkey1) $ "+";
	}
	// End:0x2C9
	if(commandItem.subkey2 != "")
	{
		strShort = strShort $ optionWndScript.GetUserReadableKeyName(commandItem.subkey2) $ "+";
	}
	// End:0x34B
	if(commandItem.Key != "")
	{
		// End:0x320
		if(commandName == MENU_InventoryWnd)
		{
			strShort = strShort $ optionWndScript.GetUserReadableKeyName(commandItem.Key) $ ",";			
		}
		else
		{
			strShort = strShort $ optionWndScript.GetUserReadableKeyName(commandItem.Key) $ ">";
		}
	}
	// End:0x458
	if(commandName == MENU_InventoryWnd)
	{
		class'ShortcutAPI'.static.GetAssignedKeyFromCommand("GamingStateShortcut", "TabShowInventoryWindow", commandItem);
		// End:0x3E0
		if(commandItem.subkey1 != "")
		{
			strShort = strShort $ optionWndScript.GetUserReadableKeyName(commandItem.subkey1) $ "+";
		}
		// End:0x41C
		if(commandItem.subkey2 != "")
		{
			strShort = strShort $ optionWndScript.GetUserReadableKeyName(commandItem.subkey2) $ "+";
		}
		// End:0x458
		if(commandItem.Key != "")
		{
			strShort = strShort $ optionWndScript.GetUserReadableKeyName(commandItem.Key) $ ">";
		}
	}
	return strShort;	
}

private function ShowDialogAskInit()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13828), string(self));
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
	class'DialogBox'.static.Inst().DelegateOnHide = HandleDialogOnHide;	
}

private function HandleDialogOK()
{
	Debug("ok");
	nSystemMenuWndFocus = 1;
	bEditMode = false;
	setEditMode(false);
	setDefaultOptionIni();
	loadOptionIni();
	Menu(GetScript("Menu")).ShowHideMenus(true);
	refreshMenu();
	getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13805));	
}

private function HandleDialogOnHide()
{
	Debug("cancel");	
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
