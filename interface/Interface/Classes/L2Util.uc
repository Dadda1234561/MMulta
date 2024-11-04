class L2Util extends UICommonAPI;


var bool bIsUsefulCollectionView;
var bool bCtrlKey;

const DIALOGID_GoWeb = 10;
enum ETreeItemTextType
{
	COLOR_DEFAULT,
	COLOR_GRAY,
	COLOR_GOLD,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_DESC,
	COLOR_BLUE,
	COLOR_BRIGHT_BLUE,
	TOKEN0,
	TOKEN1,
	TOKEN2,
	TOKEN3,
	YELLOW03
};
//************************************************************************************************************************


/**
 *  ToopTip їл ***********************************************************************************************************
 **/
var CustomTooltip tooltipText;
var DrawItemInfo toolTipInfo;

enum ETooltipTextType
{
	COLOR_DEFAULT,
	COLOR_GRAY,
	COLOR_GOLD,
	COLOR_YELLOW,
	COLOR_YELLOW03,
	COLOR_RED,
	COLOR_BLUE,
	COLOR_ARTIFACT
};

enum EGfxScreenMsgType
{
	MSGType_Normal,
	MSGType_AddItemEffect,
	MSGType_Chatting,
	MSGType_Matching
};

enum MapPinType
{
	PIN_YELLOW,
	PIN_BLUE,
	PIN_GREEN
};


enum EItemLockedCheckType
{
	ANY,
	LOCK,
	UNLOCK,
	NOT_LOCK,
	NOT_UNLOCK
};


var Color White;
var Color Yellow;
var Color Blue;
var Color BrightWhite;
var Color Gold;
var Color Gray;
var Color Yellow03;
var Color ColorDesc;
var Color ColorYellow;

var Color ColorGray;
var Color ColorLightBrown;
var Color ColorGold;
var Color ColorMinimapFont;


var Color HotPink;
var Color PowderPink;

var Color Token0;
var Color Token1;
var Color Token2;
var Color Token3;

var Color DarkGray;
var Color BWhite;
var Color DRed;
var Color Red;
var Color Red1;
var Color Red2;
var Color Red3;
var Color VIOLET01;
var Color VIOLET02;
var Color PKNameColor;

// ѕЖАМЕЫ АЪµї »зїл
var Color Green;

var Color BLUE01;
var Color CAPRI;

//************************************************************************************************************************

// ѕЖАМЕЫ °ь°иµИ А©µµїм АМё§ №иї­ ЅєЖ®ёµ 
var array<string> ItemRelationWindowArrayStr;
var string ItemRelationWindowString;
var PrivateShopWnd privateShopWndScript;
var RefineryWnd RefineryWndScript;
var UnrefineryWnd UnrefineryWndScript;
var AttributeRemoveWnd AttributeRemoveWndScript;
var AttributeEnchantWnd AttributeEnchantWndScript;
var CrystallizationWnd CrystallizationWndScript;
var ItemEnchantWnd ItemEnchantWndScript;
var ItemLookChangeWnd ItemLookChangeWndScript; //branch 111109
var MultiSellWnd MultiSellWndScript;
var WarehouseWnd WarehouseWndScript;
var TradeWnd TradeWndScript;
var DeliverWnd DeliverWndScript;
var ItemAttributeChangeWnd ItemAttributeChangeWndScript;

var string Url;
var string Text;
//////

var string m_reservedInt2;

// ЗС№шёё ini ·Оµеё¦ ЗП±в А§ЗШј­..
var bool bCheckUsePledgeV2;

var int nUsePledgeV2Classic, nUsePledgeV2Live;

delegate bool myDelegate(bool bFirst, string str);

static function L2Util Inst()
{
	return L2Util(GetScript("L2Util"));
}

function OnRegisterEvent()
{
	RegisterEvent(EV_UrlLinkClick);   //4960
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
	RegisterEvent(EV_Restart);
}


function OnKeyDown(WindowHandle a_WindowHandle, EInputKey Key)
{
	bCtrlKey = class'InputAPI'.static.IsCtrlPressed();
	AddSystemMessageString("CtrlState: " @ bCtrlKey);
}


/**
 * OnEvent
 **/
function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_UrlLinkClick:
			linkWebPage(param);
			// End:0x5A
			break;
		case EV_DialogOK:
			HandleDialogOK();
			// End:0x5A
			break;
		case EV_DialogCancel:
			break;
		case EV_Restart:
			bCheckUsePledgeV2 = false;
			nUsePledgeV2Classic = 0;
			nUsePledgeV2Live = 0;
			// End:0x5A
			break;
	}
}

function bool isClanV2()
{
	local bool bValue;

	// Е¬·ЎЅД
	// End:0x9E
	if(getInstanceUIData().getIsClassicServer())
	{
		// End:0x88
		if(bCheckUsePledgeV2 == false)
		{
			bCheckUsePledgeV2 = true;
			GetINIBool("Localize", "UsePledgeV2Classic", nUsePledgeV2Classic, "L2.ini");

			Debug("- GetINIBool UsePledgeV2Classic" @ nUsePledgeV2Classic);
		}

		// ЗчёН ё®ґєѕу UI »зїл
		if(nUsePledgeV2Classic > 0)
			bValue = true;
	}
	else
	{
		// ¶уАМєк
		if(bCheckUsePledgeV2 == false)
		{
			bCheckUsePledgeV2 = true;
			GetINIBool("Localize", "UsePledgeV2Live", nUsePledgeV2Live, "L2.ini");

			Debug("- GetINIBool UsePledgeV2Live" @ nUsePledgeV2Live);
		}

		// ЗчёН ё®ґєѕу UI »зїл
		if(nUsePledgeV2Live > 0)
			bValue = true;
	}

	// Debug("Зчv2 " @ bValue);

	return bValue;

}


function HandleDialogOK()
{
	// End:0x0D
	if(! DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case DIALOGID_GoWeb:
			OpenGivenURL(Url);
			// End:0x2B
			break;
	}
}

function linkWebPage(string param)
{
	local ELanguageType Language;	 //branch121212

	// End:0x1C
	if(! ParseString(param, "Url", URL))
	{
		return;
	}
	// End:0x3F
	if(! ParseString(param, "Text", Text))
	{
		Text = "";
	}

	//debug("Url---->" $ Url @ GetSystemString(2265));
	//debug("Text---->" $ Text);
	DialogHide();
	DialogSetID(DIALOGID_GoWeb);
	if(Text != "")
	{
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), Text, ""), string(Self));
	}
	else
	{
		//branch121212
		Language = GetLanguage();
		if(Language != LANG_Korean)
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(6172), "", ""), string(Self));
			return;
		}
		//end of branch
	
		if(Url == GetSystemString(2265))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), GetSystemString(2259), ""), string(Self));
		}
		else if(Url == GetSystemString(2266))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), GetSystemString(2261), ""), string(Self));
		}
		else if(Url == GetSystemString(2267))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), GetSystemString(2263), ""), string(Self));
		}
		else if(Url == GetSystemString(2762))//ЖДїцєП ёµЕ©
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), GetSystemString(2760), ""), string(Self));
		}
		else if(Url == GetSystemString(2775))//ёаЕдёµ(°ЎАМµе)ёµЕ©
		{
			// 2773: ёаЕдёµ °ЎАМµе
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), GetSystemString(2773), ""), string(Self));
		}
		else
		{
			if(Url != "")
			{
				// 901 : Б¤єё
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), GetSystemString(901), ""), string(Self));
			}
		}
	}
}


/**
 * OnLoad
 **/
function OnLoad()
{
	initColor();

	ItemRelationWindowString = "MultiSellWnd,WarehouseWnd,ShopWnd,TradeWnd,DeliverWnd,SellingAgencyWnd,PostBoxWnd,PostWriteWnd,PostDetailWnd_General,AttendCheckWnd," $
								"PostDetailWnd_SafetyTrade,ProductInventoryWnd,PrivateShopWnd,PremiumItemGetWnd,ManorShopWnd,AttributeEnchantWnd,AttributeRemoveWnd," $
								"RefineryWnd,UnrefineryWnd,CrystallizationWnd,InventoryWnd,ItemAttributeChangeWnd,ItemLookChangeWnd,ProgressBox,RecipeShopWnd," $
								"TokenTradeWnd,AdenaDistributionWnd,ItemJewelEnchantWnd,AlchemyMixCubeWnd,AlchemyItemConversionWnd,EnsoulWnd,EnsoulExtractWnd,ItemJewelEnchantWnd," $
								"ItemUpgrade,ItemLockWnd,ElementalSpiritWnd,ArtifactEnchantWnd,ShopDailyLcoinWnd,AutoUseItemInventory,AutoPotionSubWnd," $
								"DetailStatusWndClassic.ConfirmWnd,RandomCraftChargingWnd,RandomCraftWnd,ShopLcoinWnd,ShopLcoinCraftWnd,ItemBlessWnd,PetExtractWnd,SuppressDrawWnd,BlackCouponWnd,ClanShopWndClassic," $
								"HennaEnchantWnd,HennaMenuWnd,HennaDyeEnchantWnd,ItemMultiEnchantWnd,ItemEnchantWnd,WorldExchangeBuyWnd,WorldExchangeRegiWnd,HeroBookCraftChargingWnd,GiftInventoryWnd," $
								"MultiSellItemExchangeWnd";
	// ѕЖАМЕЫ °ь°иµИ А©µµїм АМё§ №иї­
	Split(ItemRelationWindowString, ",", ItemRelationWindowArrayStr);
	if(IsUseRenewalSkillWnd())
	{
		ItemRelationWindowArrayStr[ItemRelationWindowArrayStr.Length] = "SkillEnchantWnd";
	}
	privateShopWndScript = PrivateShopWnd(GetScript("PrivateShopWnd"));
	RefineryWndScript = RefineryWnd(GetScript("RefineryWnd"));
	UnrefineryWndScript = UnrefineryWnd(GetScript("UnrefineryWnd"));
	UnrefineryWndScript = UnrefineryWnd(GetScript("UnrefineryWnd"));
	AttributeRemoveWndScript = AttributeRemoveWnd(GetScript("AttributeRemoveWnd"));
	AttributeEnchantWndScript = AttributeEnchantWnd(GetScript("AttributeEnchantWnd"));
	CrystallizationWndScript = CrystallizationWnd(GetScript("CrystallizationWnd"));
	ItemEnchantWndScript = ItemEnchantWnd(GetScript("ItemEnchantWnd"));
	ItemLookChangeWndScript = ItemLookChangeWnd(GetScript("ItemLookChangeWnd")); //branch 111109
	MultiSellWndScript = MultiSellWnd(GetScript("MultiSellWnd"));
	WarehouseWndScript = WarehouseWnd(GetScript("WarehouseWnd"));
	TradeWndScript = TradeWnd(GetScript("TradeWnd"));
	DeliverWndScript = DeliverWnd(GetScript("DeliverWnd"));
	ItemAttributeChangeWndScript = ItemAttributeChangeWnd(GetScript("ItemAttributeChangeWnd"));
	
	
	//bIsUsefulCollectionView = true;
	bIsUsefulCollectionView = bool(GetOptionInt("Collections", "ViewType"));
	
}

/**
 *  Д®¶у °Єµй јјЖГ 
 **/ 
function initColor()
{
	BrightWhite.R = 230;
	BrightWhite.G = 230;
	BrightWhite.B = 230;
	BrightWhite.A = 255;

	White.R = 200;
	White.G = 200;
	White.B = 200;
	White.A = 255;

	Yellow.R = 235;
	Yellow.G = 205;
	Yellow.B = 0;
	Yellow.A = 255;

	Blue.R = 102;
	Blue.G = 150;
	Blue.B = 253;
	Blue.A = 255;

	Gold.R = 176;
	Gold.G = 153;
	Gold.B  = 121;
	Gold.A = 255;

	Gray.R = 120;
	Gray.G = 120;
	Gray.B = 120;
	Gray.A = 255;

	//branch GD35_0828 2014-1-13 luciper3 - №иїмАЪё¦ ЗҐЅГЗТ¶§ ЗОЕ©·О ЗТ·Б°н ГЯ°ЎЗФ.
	HotPink.R = 195;
	HotPink.G = 46;
	HotPink.B = 97;
	HotPink.A = 255;

	PowderPink.R = 255;
	PowderPink.G = 192;
	PowderPink.B = 203;
	PowderPink.A = 255;
	//end of branch

	Token0.R = 211;
	Token0.G = 192;
	Token0.B = 82;
	Token0.A = 255;
		
	Token1.R = 170;
	Token1.G = 152;
	Token1.B = 120;
	Token1.A = 255;

	Token2.R = 168;
	Token2.G = 103;
	Token2.B = 53;
	Token2.A = 255;

	Token3.R = 175;
	Token3.G = 42;
	Token3.B = 39;
	Token3.A = 255;

	Yellow03.R = 255;
	Yellow03.G = 204;
	Yellow03.B = 0;
	Yellow03.A = 255;

	// --- АМБ¦ єОЕН АМ·±ЅДАё·О Colorё¦ єЩї©ј­.. 
	ColorDesc.R = 175;
	ColorDesc.G = 185;
	ColorDesc.B = 205;
	ColorDesc.A = 255;

	ColorYellow.R = 255;
	ColorYellow.G = 221;
	ColorYellow.B = 102;
	ColorYellow.A = 255;

	ColorGray.R = 182;
	ColorGray.G = 182;
	ColorGray.B = 182;
	ColorGray.A = 255;

	ColorGold.R = 176;
	ColorGold.G = 153;
	ColorGold.B = 121;
	ColorGold.A = 255;

	ColorMinimapFont.R = 181;
	ColorMinimapFont.G = 181;
	ColorMinimapFont.B = 170;
	ColorMinimapFont.A = 255;

	ColorLightBrown.R = 238;
	ColorLightBrown.G = 170;
	ColorLightBrown.B = 34;
	ColorLightBrown.A = 255;

	DarkGray.R = 68;
	DarkGray.G = 68;
	DarkGray.B = 68;
	DarkGray.A = 255;

	BWhite.R = 211;
	BWhite.G = 211;
	BWhite.B = 211;
	BWhite.A = 255;

	DRed.R = 255;
	DRed.G = 102;
	DRed.B = 102;
	DRed.A = 255;

	Red.R = 255;
	Red.G = 50;
	Red.B = 0;
	Red.A = 255;
	
	Red1.R = 255;
	Red1.G = 0;
	Red1.B = 0;
	Red1.A = 255;

	Red2.R = 255;
	Red2.G = 102;
	Red2.B = 102;
	Red2.A = 255;

	Red3.R = 255;
	Red3.G = 153;
	Red3.B = 153;
	Red3.A = 255;

	VIOLET01.R = 238;
	VIOLET01.G = 170;
	VIOLET01.B = 255;
	VIOLET01.A = 255;

	VIOLET02.R = 136;
	VIOLET02.G = 136;
	VIOLET02.B = 255;
	VIOLET02.A = 255;

	PKNameColor.R = 230;
	PKNameColor.G = 100;
	PKNameColor.B = 255;
	PKNameColor.A = 255;


	BLUE01.R = 85;
	BLUE01.G = 153;
	BLUE01.B = 255;
	BLUE01.A = 255;

	Green.R = 119;
	Green.G = 255;
	Green.B = 153;
	Green.A = 255;
	
	CAPRI.R = 0;
	CAPRI.G = 170;
	CAPRI.B = 255;
	CAPRI.A = 255;
}

/*
 * ex)	
 * //Root ілµе »эјє.
 * util.TreeInsertRootNode(TREENAME, ROOTNAME, "", 0, 4);
 * //+№цЖ° АЦґВ »уА§ ілµе »эјє
 * util.TreeInsertExpandBtnNode(TREENAME, "LIST1", ROOTNAME);
 * //А§АЗ ілµеїЎ ±Ыѕѕ ѕЖАМЕЫ ГЯ°Ў
 * util.TreeInsertTextNodeItem(TREENAME, ROOTNAME$"."$"LIST1", GetSystemString(2370), 5, 0, util.ETreeItemTextType.COLOR_DEFAULT, true);
 * 
 * //ѕЖАМЕЫ №и°ж ёёµй±в(АЦґВіС)
 * util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 257, 38, , , , ,14);
 * //ѕЖАМЕЫ №и°ж ёёµй±в(ѕшґВіС)
 * util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 257, 38);
 * ѕЖАМЕЫ ёёµй±в..ѕЖ·Ў.
	//Insert Node Item - ѕЖАМЕЫЅЅ·Ф №и°ж
	util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);
	//Insert Node Item - ѕЖАМЕЫ ѕЖАМДЬ
	util.TreeInsertTextureNodeItem(TREENAME, strRetName, strIconName, 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1);
	//Insert Node Item - ѕЖАМЕЫ АМё§
	util.TreeInsertTextNodeItem(TREENAME, strRetName, strName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true);
	//Insert Node Item - "Lv"
	util.TreeInsertTextNodeItem(TREENAME, strRetName, GetSystemString(88),46, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY, true, true);
	//Insert Node Item - ·№є§ °Є
	util.TreeInsertTextNodeItem(TREENAME, strRetName, string(iLevel), 2, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GOLD);
	//Insert Node Item - MP№°ѕа ѕЖАМДЬ(јТёрїҐЗЗ)
	util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_MP", 15, 15, 5, OFFSET_Y_SECONDLINE + 1);
	//Insert Node Item - "Test °Є"
	util.TreeInsertTextNodeItem(TREENAME, strRetName, "630", 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY);
	//Insert Node Item - ЅГ°Ј ѕЖАМДЬ(ЅГАьЅГ°Ј)
	util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_use", 15, 15, 5, OFFSET_Y_SECONDLINE + 1);
	//Insert Node Item - "Test °Є"
	util.TreeInsertTextNodeItem(TREENAME, strRetName, "2ГК", 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY);
	//Insert Node Item - ЅГ°Ј ѕЖАМДЬ(Аз»зїлЅГ°Ј)
	util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_Reuse", 15, 15, 5, OFFSET_Y_SECONDLINE + 1);
	//Insert Node Item - "Test °Є"
	util.TreeInsertTextNodeItem(TREENAME, strRetName, "2єР", 0, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GRAY);
 */

//** ј±БШ Code ГЯ°Ў Treeїл Node, NodeItemїЎ °ьЗС ДЪµе *******************************************************************************************************************************************************

/**
 *  Ж®ё® ROOT ілµе ГЯ°Ў  
 *  [TreeName:ілµе ГЯ°ЎЗТ Tree іЧАУ:string]   
 *  [NodeName:ілµе іЧАУ:string]    
 *  [ParentName:ГЯ°ЎЗТ ілµеАЗ »уА§ ілµе:string]  
 *  [offSetX:ілµе x А§ДЎ:optional int]   
 *  [offSetY:ілµе y А§ДЎ:optional int]
 */
function TreeInsertRootNode(string treeName, string NodeName, string ParentName, optional int OffsetX, optional int OffsetY)
{
	//Ж®ё® ілµе Б¤єё
	local XMLTreeNodeInfo infNode;

	infNode.strName = NodeName;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	class'UIAPI_TREECTRL'.static.InsertNode(treeName, ParentName, infNode);
}


/**
 * TreeInsertRootNode їН °°АёіЄ, јУµµ °іј±А» А§ЗШ. TreeHandle·О №ЮѕЖ Гіё® ЗХґПґЩ.
 */

function TreeHandleInsertRootNode(TreeHandle m_UITree, string NodeName, string ParentName, optional int offSetX, optional int offSetY)
{
	//Ж®ё® ілµе Б¤єё
	local XMLTreeNodeInfo infNode;
	
	infNode.strName = NodeName;	
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;

	m_UITree.InsertNode(ParentName, infNode);
	//class'UIAPI_TREECTRL'.static.InsertNode(TreeName, ParentName, infNode);
}

/**
 *  Ж®ё® Expand №цЖ° ілµе ГЯ°Ў
 *  [TreeName:ілµе ГЯ°ЎЗТ Tree іЧАУ:string]
 *  [NodeName:ілµе іЧАУ:string]
 *  [ParentName:ГЯ°ЎЗТ ілµеАЗ »уА§ ілµе:string]
 *  [nTexBtnWidth:Expand№цЖ° іРАМ:int]
 *  [nTexBtnHeight:Expand№цЖ° іфАМ:int]
 *  [strTexBtnExpand:Treeї­ёІ№цЖ° ЕШЅєГД:optional string]
 *  [strTexBtnExpand_Over:Treeї­ёІ№цЖ° їА№ц ЕШЅєГД:optional string]
 *  [strTexBtnCollapse:TreeґЭИы№цЖ° ЕШЅєГД:optional string]
 *  [strTexBtnCollapse_Over:Treeї­ёІ№цЖ° їА№ц ЕШЅєГД:optional string]
 *  [offSetX:ілµе x А§ДЎ:optional int]   
 *  [offSetY:ілµе y А§ДЎ:optional int]
 *  [bUseStrTexExpandedLeft : ј±ЕГЗПґВ Зф optional bool ]
 */
function TreeInsertExpandBtnNode(string TreeName, string NodeName, string ParentName, optional int nTexBtnWidth, optional int nTexBtnHeight, 
									optional string strTexBtnExpand, optional string strTexBtnExpand_Over, optional string strTexBtnCollapse, optional string strTexBtnCollapse_Over,
									optional int offSetX, optional int offSetY, optional bool bUseStrTexExpandedLeft)
{
	//Ж®ё® ілµе Б¤єё
	local XMLTreeNodeInfo infNode;

	if(nTexBtnWidth == 0)nTexBtnWidth = 15;
	if(nTexBtnHeight == 0)nTexBtnHeight = 15;
	if(strTexBtnExpand == "")strTexBtnExpand = "L2UI_CH3.QUESTWND.QuestWndPlusBtn";
	if(strTexBtnExpand_Over == "")strTexBtnExpand_Over = "L2UI_CH3.QUESTWND.QuestWndPlusBtn_over";
	if(strTexBtnCollapse == "")strTexBtnCollapse = "L2UI_CH3.QUESTWND.QuestWndMinusBtn";
	if(strTexBtnCollapse_Over == "")strTexBtnCollapse_Over = "L2UI_CH3.QUESTWND.QuestWndMinusBtn_over";

	infNode.strName = NodeName;
	infNode.bShowButton = 1;
	infNode.nTexBtnWidth = nTexBtnWidth;
	infNode.nTexBtnHeight = nTexBtnHeight;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.strTexBtnExpand = strTexBtnExpand;
	infNode.strTexBtnExpand_Over = strTexBtnExpand_Over;
	infNode.strTexBtnCollapse = strTexBtnCollapse;
	infNode.strTexBtnCollapse_Over = strTexBtnCollapse_Over;

	class'UIAPI_TREECTRL'.static.InsertNode(TreeName, ParentName, infNode);
}

/**
 * TreeInsertExpandBtnNode їН °°АёіЄ, јУµµ °іј±А» А§ЗШ TreeHandleё¦ №ЮѕЖ »зїл 
 */
function TreeHandleInsertExpandBtnNode(TreeHandle m_UITree, string NodeName, string ParentName, optional int nTexBtnWidth, optional int nTexBtnHeight, 
									optional string strTexBtnExpand, optional string strTexBtnExpand_Over, optional string strTexBtnCollapse, optional string strTexBtnCollapse_Over,
									optional int offSetX, optional int offSetY, optional bool bUseStrTexExpandedLeft)
{
	//Ж®ё® ілµе Б¤єё
	local XMLTreeNodeInfo infNode;

	if(nTexBtnWidth == 0)nTexBtnWidth = 15;
	if(nTexBtnHeight == 0)nTexBtnHeight = 15;
	if(strTexBtnExpand == "")strTexBtnExpand = "L2UI_CH3.QUESTWND.QuestWndPlusBtn";
	if(strTexBtnExpand_Over == "")strTexBtnExpand_Over = "L2UI_CH3.QUESTWND.QuestWndPlusBtn_over";
	if(strTexBtnCollapse == "")strTexBtnCollapse = "L2UI_CH3.QUESTWND.QuestWndMinusBtn";
	if(strTexBtnCollapse_Over == "")strTexBtnCollapse_Over = "L2UI_CH3.QUESTWND.QuestWndMinusBtn_over";

	infNode.strName = NodeName;
	infNode.bShowButton = 1;
	infNode.nTexBtnWidth = nTexBtnWidth;
	infNode.nTexBtnHeight = nTexBtnHeight;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.strTexBtnExpand = strTexBtnExpand;
	infNode.strTexBtnExpand_Over = strTexBtnExpand_Over;
	infNode.strTexBtnCollapse = strTexBtnCollapse;
	infNode.strTexBtnCollapse_Over = strTexBtnCollapse_Over;

	m_UITree.InsertNode(ParentName, infNode );
}


/**
 *  Ж®ё® ITEM ілµе ГЯ°Ў
 *  [TreeName:ілµе ГЯ°ЎЗТ Tree іЧАУ:string]
 *  [NodeName:ілµе іЧАУ:string]
 *  [ParentName:ГЯ°ЎЗТ ілµеАЗ »уА§ ілµе:string]
 *  [nTexBtnWidth:Expand№цЖ° іРАМ:int]
 *  [nTexBtnHeight:Expand№цЖ° іфАМ:int]
 *  [strTexBtnExpand:Treeї­ёІ№цЖ° ЕШЅєГД:optional string]
 *  [strTexBtnExpand_Over:Treeї­ёІ№цЖ° їА№ц ЕШЅєГД:optional string]
 *  [strTexBtnCollapse:TreeґЭИы№цЖ° ЕШЅєГД:optional string]
 *  [strTexBtnCollapse_Over:Treeї­ёІ№цЖ° їА№ц ЕШЅєГД:optional string]
 *  [offSetX:ілµе x А§ДЎ:optional int]   
 *  [offSetY:ілµе y А§ДЎ:optional int]
 */
function string TreeInsertItemTooltipSimpleNode(string TreeName, string NodeName, string ParentName, 
									int nTexExpandedOffSetX, int nTexExpandedOffSetY, 
									int nTexExpandedHeight, int nTexExpandedRightWidth, 
									int nTexExpandedLeftUWidth, int nTexExpandedLeftUHeight,									
									optional string TooltipSimpleText, optional string strTexExpandedLeft, optional int offSetX, optional int offSetY)
{
	//Ж®ё® ілµе Б¤єё
	local XMLTreeNodeInfo infNode;

	// End:0x22
	if(TooltipSimpleText != "")
	{
		infNode.ToolTip = MakeTooltipSimpleText(TooltipSimpleText);
	}
	// End:0x4E
	if(strTexExpandedLeft == "")
	{
		strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	}

	infNode.strName = NodeName;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.bFollowCursor = true;
	//ExpandµЗѕъА»¶§АЗ BackTextureјіБ¤
	//ЅєЖ®·№ДЎ·О ±Чё®±в ¶§№®їЎ ExpandedWidthґВ ѕшґЩ. іЎїЎј­ -2ёёЕ­ №и°жА» ±Чё°ґЩ.
	infNode.nTexExpandedOffSetX = nTexExpandedOffSetX;
	infNode.nTexExpandedOffSetY = nTexExpandedOffSetY;
	infNode.nTexExpandedHeight = nTexExpandedHeight;
	infNode.nTexExpandedRightWidth = nTexExpandedRightWidth;
	infNode.nTexExpandedLeftUWidth = nTexExpandedLeftUWidth;
	infNode.nTexExpandedLeftUHeight = nTexExpandedLeftUHeight;
	infNode.strTexExpandedLeft = strTexExpandedLeft;

	return class'UIAPI_TREECTRL'.static.InsertNode(TreeName, ParentName, infNode);
}

function string TreeInsertItemTooltipNode(string TreeName, string NodeName, string ParentName, 
									int nTexExpandedOffSetX, int nTexExpandedOffSetY, 
									int nTexExpandedHeight, int nTexExpandedRightWidth, 
									int nTexExpandedLeftUWidth, int nTexExpandedLeftUHeight,									
									CustomTooltip tooltipText, optional string strTexExpandedLeft, optional int offSetX, optional int offSetY)
{
	//Ж®ё® ілµе Б¤єё
	local XMLTreeNodeInfo infNode;

	// End:0x2C
	if(strTexExpandedLeft == "")
	{
		strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	}

	infNode.strName = NodeName;
	infNode.Tooltip = tooltipText;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.bFollowCursor = true;
	//ExpandµЗѕъА»¶§АЗ BackTextureјіБ¤
	//ЅєЖ®·№ДЎ·О ±Чё®±в ¶§№®їЎ ExpandedWidthґВ ѕшґЩ. іЎїЎј­ -2ёёЕ­ №и°жА» ±Чё°ґЩ.
	infNode.nTexExpandedOffSetX = nTexExpandedOffSetX;
	infNode.nTexExpandedOffSetY = nTexExpandedOffSetY;
	infNode.nTexExpandedHeight = nTexExpandedHeight;
	infNode.nTexExpandedRightWidth = nTexExpandedRightWidth;
	infNode.nTexExpandedLeftUWidth = nTexExpandedLeftUWidth;
	infNode.nTexExpandedLeftUHeight = nTexExpandedLeftUHeight;
	infNode.strTexExpandedLeft = strTexExpandedLeft;

	return class'UIAPI_TREECTRL'.static.InsertNode(TreeName, ParentName, infNode);
}

function string TreeInsertItemNode(string treeName, string NodeName, string parentname, optional bool bFollowCursor, optional int OffsetX, optional int OffsetY)
{
	//Ж®ё® ілµе Б¤єё
	local XMLTreeNodeInfo infNode;

	infNode.strName = NodeName;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	infNode.bFollowCursor = bFollowCursor;

	return class'UIAPI_TREECTRL'.static.InsertNode(treeName, parentname, infNode);
}

/**
 *  Ж®ё® ілµеїЎ Text ѕЖАМЕЫ ГЯ°Ў
 *  [TreeName:ілµе ГЯ°ЎЗТ Tree іЧАУ]
 *  [NodeName:ілµе іЧАУ]
 *  [ItemName:TextїЎ ГЯ°ЎµЗ і»їл]
 *  [offSetX:Text x А§ДЎ]   
 *  [offSetY:Text y А§ДЎ]
 *  [E:Text »ц»у ETreeItemTextType °Є]
 *  [oneline:t_bDrawOneLine °Є]
 *  [bLineBreak:bLineBreak °Є]
 */
function TreeInsertTextNodeItem(string treeName, string NodeName, string ItemName, optional int offSetX, optional int offSetY, optional ETreeItemTextType E, 
									optional bool oneline, optional bool bLineBreak, optional int reserved)
{
	//Ж®ё® ілµеѕЖАМЕЫ Б¤єё
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = offSetX;
	infNodeItem.nOffSetY = offSetY;
	
	infNodeItem = setTreeTextColor(E, infNodeItem);

	if(reserved != 0)
	{
		infNodeItem.nReserved = reserved;
	}

	class'UIAPI_TREECTRL'.static.InsertNodeItem(treeName, NodeName, infNodeItem);
}

/**
 *TreeInsertTextNodeItem їН µїАП ЗПБцёё јУµµ °іј±А» А§ЗШ TreeName ґлЅЕ TreeHandleА» №ЮАЅ
 */
function TreeHandleInsertTextNodeItem(TreeHandle m_UITree, string NodeName, string ItemName, optional int offSetX, optional int offSetY, optional ETreeItemTextType E, 
									optional bool oneline, optional bool bLineBreak, optional int reserved)
{
	//Ж®ё® ілµеѕЖАМЕЫ Б¤єё
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = offSetX;
	infNodeItem.nOffSetY = offSetY;
	
	infNodeItem = setTreeTextColor(E, infNodeItem);

	if(reserved != 0)
	{
		infNodeItem.nReserved = reserved;
	}

	m_UITree.InsertNodeItem(NodeName, infNodeItem);	
}

/**
 *  Ж®ё® ілµеїЎ Text ѕЖАМЕЫ ГЯ°Ў
 *  [TreeName:ілµе ГЯ°ЎЗТ Tree іЧАУ]
 *  [NodeName:ілµе іЧАУ]
 *  [ItemName:TextїЎ ГЯ°ЎµЗ і»їл]
 *  [offSetX:Text x А§ДЎ]   
 *  [offSetY:Text y А§ДЎ]
 *  [E:Text »ц»у ETreeItemTextType °Є]
 *  [oneline:t_bDrawOneLine °Є]
 *  [bLineBreak:bLineBreak °Є]
 */
function TreeInsertTextMultiNodeItem(string TreeName, string NodeName, string ItemName, optional int offSetX, optional int offSetY, 
										optional int MaxHeight, optional ETreeItemTextType E, optional bool bLineBreak, optional int reserved, optional int reserved2)
{
	//Ж®ё® ілµеѕЖАМЕЫ Б¤єё
	local XMLTreeNodeItemInfo infNodeItem;

	// End:0x13
	if(MaxHeight == 0)
	{
		MaxHeight = 38;
	}
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.t_bDrawOneLine = false;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = offSetX;
	infNodeItem.nOffSetY = offSetY;
	infNodeItem.t_nMaxHeight = MaxHeight;
	infNodeItem.t_vAlign = TVA_Middle;
	
	infNodeItem = setTreeTextColor(E, infNodeItem);

	if(reserved != 0)
	{
		infNodeItem.nReserved = reserved;
	}
	infNodeItem.nReserved2 = 0;
	// End:0xE4
	if(reserved2 > 0)
	{
		infNodeItem.nReserved2 = reserved2;
	}

	class'UIAPI_TREECTRL'.static.InsertNodeItem(TreeName, NodeName, infNodeItem);
}


/**
 *  Ж®ё® ілµеїЎ Text ѕЖАМЕЫАЗ ±Ыѕѕ »ц»у
 */
function XMLTreeNodeItemInfo setTreeTextColor(ETreeItemTextType E, XMLTreeNodeItemInfo infNodeItem)
{
	switch(E)
	{
		case ETreeItemTextType.COLOR_DEFAULT:
			infNodeItem.t_color.R = 255;
			infNodeItem.t_color.G = 255;
			infNodeItem.t_color.B = 255;
			infNodeItem.t_color.A = 255;
			break;
		
		case ETreeItemTextType.COLOR_GRAY:
			infNodeItem.t_color.R = 163;
			infNodeItem.t_color.G = 163;
			infNodeItem.t_color.B = 163;
			infNodeItem.t_color.A = 255;
			break;

		case ETreeItemTextType.COLOR_GOLD:
			infNodeItem.t_color.R = 176;
			infNodeItem.t_color.G = 155;
			infNodeItem.t_color.B = 121;
			infNodeItem.t_color.A = 255;
			break;
		case ETreeItemTextType.COLOR_RED:
			infNodeItem.t_color.R = 250;
			infNodeItem.t_color.G = 50;
			infNodeItem.t_color.B = 0;
			infNodeItem.t_color.A = 255;
			break;
		case ETreeItemTextType.COLOR_YELLOW:
			infNodeItem.t_color.R = 240;
			infNodeItem.t_color.G = 214;
			infNodeItem.t_color.B = 54;
			infNodeItem.t_color.A = 255;
			break;
		case ETreeItemTextType.COLOR_DESC:
			infNodeItem.t_color.R = 175;
			infNodeItem.t_color.G = 185;
			infNodeItem.t_color.B = 205;
			infNodeItem.t_color.A = 255;
			break;

		case ETreeItemTextType.COLOR_BLUE:
			infNodeItem.t_color.R = 102;
			infNodeItem.t_color.G = 150;
			infNodeItem.t_color.B = 253;
			infNodeItem.t_color.A = 255;
			break;

		case ETreeItemTextType.COLOR_BRIGHT_BLUE:
			infNodeItem.t_color.R = 85;
			infNodeItem.t_color.G = 170;
			infNodeItem.t_color.B = 255;
			infNodeItem.t_color.A = 255;
			break;

		case ETreeItemTextType.TOKEN0:
			infNodeItem.t_color.R = 211;
			infNodeItem.t_color.G = 192;
			infNodeItem.t_color.B = 82;
			infNodeItem.t_color.A = 255;
			break;		
		case ETreeItemTextType.TOKEN1:
			infNodeItem.t_color.R = 170;
			infNodeItem.t_color.G = 152;
			infNodeItem.t_color.B = 120;
			infNodeItem.t_color.A = 255;
			break;		
		case ETreeItemTextType.TOKEN2:
			infNodeItem.t_color.R = 168;
			infNodeItem.t_color.G = 103;
			infNodeItem.t_color.B = 53;
			infNodeItem.t_color.A = 255;
			break;		
		case ETreeItemTextType.TOKEN3:
			infNodeItem.t_color.R = 175;
			infNodeItem.t_color.G = 42;
			infNodeItem.t_color.B = 39;
			infNodeItem.t_color.A = 255;
			break;

		case ETreeItemTextType.YELLOW03:
			infNodeItem.t_color.R = 255;
			infNodeItem.t_color.G = 204;
			infNodeItem.t_color.B = 0;
			infNodeItem.t_color.A = 255;
			break;
	}
	return infNodeItem;
}

/**
 *  Ж®ё® ілµеїЎ Text ѕЖАМЕЫ ГЯ°Ў
 *  [TreeName:ілµе ГЯ°ЎЗТ Tree іЧАУ:string]
 *  [NodeName:ілµе іЧАУ:string]
 *  [TextureName:ЕШЅєГД АМё§:string]
 *  [TextureWidth:ЕШЅєГД іРАМ:int]
 *  [TextureHeight:ЕШЅєГД іфАМ:int]
 *  [offSetX:Text x А§ДЎ]   
 *  [offSetY:Text y А§ДЎ]
 *  [OneLine:t_bDrawOneLine °Є]
 *  [bLineBreak:bLineBreak °Є]
 *  [TextureUHeight:TextureUHeight °Є ??? ]
 */
function TreeInsertTextureNodeItem(string TreeName, string NodeName, string TextureName, int TextureWidth, int TextureHeight, optional int offSetX, optional int offSetY, 
										optional bool oneline, optional bool bLineBreak, optional int TextureUHeight)
{
	//Ж®ё® ілµеѕЖАМЕЫ Б¤єё
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = offSetX;
	infNodeItem.nOffSetY = offSetY;
	infNodeItem.u_nTextureUHeight = TextureUHeight;
	infNodeItem.u_nTextureWidth = TextureWidth;
	infNodeItem.u_nTextureHeight = TextureHeight;
	infNodeItem.u_strTexture = TextureName;

	class'UIAPI_TREECTRL'.static.InsertNodeItem(TreeName, NodeName, infNodeItem);
} 

/**
 * TreeInsertTextureNodeItem їН µїАП ЗПБцёё јУµµ °іј±А» А§ЗШ TreeHandle ё¦ №ЮАЅ 
 */
function TreeHandleInsertTextureNodeItem(TreeHandle m_UITree, string NodeName, string TextureName, int TextureWidth, int TextureHeight, optional int offSetX, optional int offSetY, 
										optional bool oneline, optional bool bLineBreak, optional int TextureUHeight)
{
	//Ж®ё® ілµеѕЖАМЕЫ Б¤єё
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = offSetX;
	infNodeItem.nOffSetY = offSetY;
	infNodeItem.u_nTextureUHeight = TextureUHeight;
	infNodeItem.u_nTextureWidth = TextureWidth;
	infNodeItem.u_nTextureHeight = TextureHeight;
	infNodeItem.u_strTexture = TextureName;

	m_UITree.InsertNodeItem(NodeName, infNodeItem);
} 

/**
 *  Ж®ё® ілµеїЎ Blank ѕЖАМЕЫ ГЯ°Ў Insert Node Item - Blank::·№ЅГЗЗ TreeїЎј­ »зїл.
 *  [TreeName:ілµе ГЯ°ЎЗТ Tree іЧАУ]
 *  [NodeName:ілµе іЧАУ]
 */
function TreeInsertBlankNodeItem(string TreeName, string NodeName)
{
	//Ж®ё® ілµеѕЖАМЕЫ Б¤єё
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.bStopMouseFocus = true;
	infNodeItem.b_nHeight = 4;
	class'UIAPI_TREECTRL'.static.InsertNodeItem(TreeName, NodeName, infNodeItem);
}

function TreeClear(string str)
{
	class'UIAPI_TREECTRL'.static.Clear(str);
}

//** ј±БШ Code ГЯ°Ў Treeїл Node, NodeItemїЎ °ьЗС ДЪµе END****************************************************************************************************************************************************

//** ј±БШ Code ГЯ°Ў ToolTipїЎ °ьЗС ДЪµе *********************************************************************************************************************************************************************

/**
 *  ЕшЖБ °Є јВЖГ
 *  [T:јВЖГ µЙ ЕшЖБ:CustomTooltip]
 */
function setCustomTooltip(CustomTooltip T)
{
	tooltipText = T;
}

function CustomTooltip getCustomToolTip()
{
	return tooltipText;
}

function ToopTipMinWidth(int width)
{
	tooltipText.MinimumWidth = width;
}

function ToopTipInsertText(string Text, optional bool oneline, optional bool bLineBreak, optional ETooltipTextType E, optional int OffsetX, optional int OffsetY)
{
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	GetItemTextSectionInfos(Text, FullText, TextInfos);
	// End:0x24
	if(Len(Text) == 0)
	{
		return;
	}
	StartItem();
	// End:0x51
	if(TextInfos.Length > 0)
	{
		Text = FullText;
		toolTipInfo.t_SectionList = TextInfos;
	}
	toolTipInfo.eType = DIT_TEXT;
	toolTipInfo.t_bDrawOneLine = oneline;
	toolTipInfo.bLineBreak = bLineBreak;
	toolTipInfo.t_strText = Text;
	toolTipInfo.nOffSetX = OffsetX;
	toolTipInfo.nOffSetY = OffsetY;
	toolTipInfo = setToopTipTextColor(E, toolTipInfo);
	EndItem();
}

function ToopTipInsertColorText(string Text, optional bool oneline, optional bool bLineBreak, optional Color c, optional int offSetX, optional int offSetY)
{
	if(Len(Text)== 0)return;

	StartItem();
	toolTipInfo.eType = DIT_TEXT;
	toolTipInfo.t_bDrawOneLine = oneline;
	toolTipInfo.bLineBreak = bLineBreak;
	toolTipInfo.t_strText = Text;
	toolTipInfo.nOffSetX = offSetX;
	toolTipInfo.nOffSetY = offSetY;
	toolTipInfo.t_color = c;
	EndItem();
}

// title : і»їл   µо АЗ ЕшЖБА» ёёµеґВ ЗФјц ГЯ°Ў
function ToopTipInsertTitleContents(string title, string Text, int r, int g, int b, optional bool OneLine, optional bool bLineBreak, optional bool iamFirst, optional int offSetX, optional int offSetY)
{
	// End:0x0F
	if(Len(Text) == 0)
	{
		return;
	}
	
	if(title != "")
	{
		StartItem();
		toolTipInfo.eType = DIT_TEXT;
		toolTipInfo.t_bDrawOneLine = true;
		toolTipInfo.bLineBreak = true;
		toolTipInfo.t_color.R = 163;
		toolTipInfo.t_color.G = 163;
		toolTipInfo.t_color.B = 163;
		toolTipInfo.t_color.A = 255;
		if(!iamFirst)
			toolTipInfo.nOffSetY = 6;
		toolTipInfo.t_strText = title;
		EndItem();
	}

	if(Text != "")
	{
		if(title != "")
		{
			StartItem();
			toolTipInfo.eType = DIT_TEXT;
			toolTipInfo.t_bDrawOneLine = true;
			toolTipInfo.t_color.R = 163;
			toolTipInfo.t_color.G = 163;
			toolTipInfo.t_color.B = 163;
			toolTipInfo.t_color.A = 255;
			if(!iamFirst)
				toolTipInfo.nOffSetY = 6;
			toolTipInfo.t_strText = " : ";
			EndItem();
		}
		StartItem();
		toolTipInfo.eType = DIT_TEXT;
		toolTipInfo.t_bDrawOneLine = true;
		
		if(title == "")
			toolTipInfo.bLineBreak = true;

		toolTipInfo.t_color.R = r;
		toolTipInfo.t_color.G = g;
		toolTipInfo.t_color.B = b;
		toolTipInfo.t_color.A = 255;
		
		toolTipInfo.t_strText = Text;
		if(!iamFirst)
			toolTipInfo.nOffSetY = 6;
		
		EndItem();

	}
}


/**
 *  ЕшЖБїЎ Text ѕЖАМЕЫАЗ ±Ыѕѕ »ц»у
 */
function DrawItemInfo setToopTipTextColor(ETooltipTextType E, DrawItemInfo info)
{
	switch(E)
	{
		case ETooltipTextType.COLOR_DEFAULT:
			info.t_color.R = 255;
			info.t_color.G = 255;
			info.t_color.B = 255;
			info.t_color.A = 255;
			break;
		
		case ETooltipTextType.COLOR_GRAY:
			info.t_color.R = 163;
			info.t_color.G = 163;
			info.t_color.B = 163;
			info.t_color.A = 255;
			break;

		case ETooltipTextType.COLOR_GOLD:
			info.t_color.R = 176;
			info.t_color.G = 155;
			info.t_color.B = 121;
			info.t_color.A = 255;
			break;		

		case ETooltipTextType.COLOR_YELLOW:
			info.t_color.R = 240;
			info.t_color.G = 214;
			info.t_color.B = 54;
			info.t_color.A = 255;
			break;

		case ETooltipTextType.COLOR_YELLOW03:
			info.t_color.R = 255;
			info.t_color.G = 204;
			info.t_color.B = 0;
			info.t_color.A = 255;
			break;
		case ETooltipTextType.COLOR_RED:
			info.t_color.R = 250;
			info.t_color.G = 50;
			info.t_color.B = 0;
			info.t_color.A = 255;
			break;
		case ETooltipTextType.COLOR_BLUE:
			info.t_color.R = 100;
			info.t_color.G = 100;
			info.t_color.B = 250;
			info.t_color.A = 255;
			break;

		case ETooltipTextType.COLOR_ARTIFACT:
			info.t_color.R = 130;
			info.t_color.G = 200;
			info.t_color.B = 240;
			info.t_color.A = 255;
			break;
	}
	return info;
}

function TwoWordCombineColon(string word1, string word2, optional ETooltipTextType E1, optional ETooltipTextType E2, optional bool bLineBreak, optional int offSetX, optional int offSetY)
{
	ToopTipInsertText(word1, false, bLineBreak, E1, offSetX, offSetY);
	ToopTipInsertText(" : ", false, false, ETooltipTextType.COLOR_GRAY, offSetX, offSetY);
	ToopTipInsertText(word2, false, false, E2, offSetX, offSetY);

}

function ToopTipInsertTexture(string Texture, optional bool oneline, optional bool bLineBreak, optional int offSetX, optional int offSetY)
{
	StartItem();
	toolTipInfo.eType = DIT_TEXTURE;
	toolTipInfo.t_bDrawOneLine = oneline;
	toolTipInfo.bLineBreak = bLineBreak;
	toolTipInfo.u_nTextureWidth = 16;
	toolTipInfo.u_nTextureHeight = 16;
	toolTipInfo.nOffSetX = offSetX;
	toolTipInfo.nOffSetY = offSetY;
	toolTipInfo.u_nTextureUWidth = 32;
	toolTipInfo.u_nTextureUHeight = 32;

	toolTipInfo.u_strTexture = Texture;
	EndItem();
}

//єу°ш°ЈАЗ TooltipItemА» ГЯ°ЎЗСґЩ.
function TooltipInsertItemBlank(int Height)
{
	StartItem();
	toolTipInfo.eType = DIT_BLANK;
	toolTipInfo.b_nHeight = Height;
	EndItem();
}

//єу°ш°ЈАЗ TooltipItemА» ГЯ°ЎЗСґЩ.
function TooltipInsertItemLine()
{
	StartItem();
	toolTipInfo.eType = DIT_SPLITLINE;
	toolTipInfo.u_nTextureWidth = TooltipText.MinimumWidth;
	toolTipInfo.u_nTextureHeight = 1;
	toolTipInfo.u_strTexture = "L2ui_ch3.tooltip_line";
	EndItem();
}

function StartItem()
{
	local DrawItemInfo infoClear;
	toolTipInfo = infoClear;
}

function EndItem()
{
	tooltipText.DrawList.Length = tooltipText.DrawList.Length + 1;
	tooltipText.DrawList[tooltipText.DrawList.Length - 1] = toolTipInfo;
}

//**  ј±БШ Code ГЯ°Ў ToolTipїЎ °ьЗС ДЪµе END*****************************************************************************************************************************************************************



/**
 * ЅГ°Ј --> XX : XX Аё·О ёёµл.
 * ЅєДЙАП ЖыїЎј­ »зїлЗП·Б ЗЯАёіЄ Бц±ЭАє ѕИµК..;;
 */
function String TimeNumberToString(int time)
{
	local int Min;
	local int Sec;
	
	local string strTime;
	local string SecString;

	Min = time / 60;
	Sec = time % 60;

	SecString = string(Sec);

	if(Sec < 10)
	{
		SecString = "0" $ string(Sec);
	}

	if(time > 60)
	{
		// End:0x86
		if(time >= 600)
		{
			strTime = string(Min) $ ":" $ SecString;			
		}
		else
		{
			strTime = "0" $ string(Min) $ ":" $ SecString;
		}
	}
	else
	{
		strTime = "00:" $ SecString;
	}

	return strTime;
}

/**
 * ЅГ°Ј --> XXЅГ XXєР Аё·О ёёµл.
 */
function String TimeNumberToHangulHourMin(int time)
{
	local int Hour;
	local int Min;
	local int Sec;	

	local string strMin;

	Min = time / 60;
	Hour = Min / 60;
	Min = Min % 60;
	Sec = time % 60;	

	strMin = string(Min);

	if(Min < 10)
	{
		strMin = "0"$string(Min);
	}

	return MakeFullSystemMsg(GetSystemMessage(3304), string(Hour), strMin);
}


/**
 * Float ЅГ°Ј + ГК ёёµйѕоБЬ.
 */
function string MakeTimeString(float Time1, optional float Time2)
{
	local int i;
	local float Time;
	local string strTime;
	local array<string>	arrSplit;
	
	if(Time2 != 0)
	{
		Time = Time1+ Time2;		
	}
	else
	{
		Time = Time1;
	}

	strTime = string(Time);

	for(i = 0 ; i < Len(strTime); i++)
	{
		if(Right(strTime, 1)== "0")
		{
			strTime = Left(strTime, Len(strTime)- 1);
			
		}
		else if(Right(strTime, 1)== ".")
		{
			break;
		}
	}		
	
	Split(strTime, ".", arrSplit);

	if(Len(arrSplit[1])== 0)
	{
		return arrSplit[0] $ GetSystemString(2001);
	}

	return strTime $ GetSystemString(2001);
}

function string MakeTimeString1(float Time1, optional float Time2)
{
	local int i;
	local float Time;
	local string strTime;
	local array<string> arrSplit;

	if(Time2 != 0)
		Time = Time1 + Time2;
	else
		Time = Time1;

	strTime = string(Time);

	for(i = 0;i < Len(strTime); i++)
	{
		if(Right(strTime,1)== "0")
			strTime = Left(strTime,Len(strTime)- 1);
		else if(Right(strTime,1)== ".")
			break;
	}

	Split(strTime,".",arrSplit);
	if(Len(arrSplit[1])== 0)
		return arrSplit[0];

	return strTime;
}

// јТјцБЎ, µОАЪё®ёё єёАМ±в
function string cutFloat(float probability)
{
	local string probabilityStr;
	local array<string>	arrSplit;

	// јТјцБЎ 99.00 µОАЪё® ёё іЄїАµµ·П..
	Split(string(probability), ".", arrSplit);

	if(probability >= 100)
	{
		probabilityStr = "100%";		
	}
	else
	{
		if(arrSplit.Length == 2)
		{
			if(Len(arrSplit[1])>= 2)
			{
				probabilityStr = arrSplit[0] $ "." $ Mid(arrSplit[1],0,2)$ "%";
			}
			else 
			{
				
				probabilityStr = string(probability)$ "%";
			}
		}
		else
		{
			probabilityStr = string(probability)$ "%";
		}

	}
	return probabilityStr;
}

function string cutFloat2(float Probability)
{
	local string probabilityStr;
	local array<string> arrSplit;

	Split(string(Probability),".",arrSplit);
	if(Probability >= 100)
	{
		probabilityStr = "100%";
	}
	else if(arrSplit.Length == 2)
	{
		if(Len(arrSplit[1])>= 2)
			probabilityStr = arrSplit[0] $ "." $ Mid(arrSplit[1],0,1)$ "%";
		else
			probabilityStr = string(Probability)$ "%";
	}
	else
		probabilityStr = string(Probability)$ "%";

  return probabilityStr;
}

function string cutFloat3(float Probability)
{
	local string probabilityStr;
	local array<string> arrSplit;

	Split(string(Probability), ".", arrSplit);
	// End:0x6F
	if(arrSplit.Length == 2)
	{
		// End:0x5A
		if(Len(arrSplit[1])>= 2)
		{
			probabilityStr =((arrSplit[0] $ ".")$ Mid(arrSplit[1], 0, 2))$ "%";
		}
		// End:0x6C
		else
		{
			probabilityStr = string(Probability)$ "%";
		}
	}
	// End:0x81
	else
	{
		probabilityStr = string(Probability)$ "%";
	}
	return probabilityStr;
}

function string CutFloatIntByString(string Probability)
{
	local int i;
	local array<string> arrSplit;

	// End:0x9A
	if(float(int(Probability)) < float(Probability))
	{
		Split(Probability, ".", arrSplit);

		// End:0x7F [Loop If]
		for(i = Len(arrSplit[1]); i > 0; i--)
		{
			// End:0x75
			if(Mid(arrSplit[1], i - 1, 1) != "0")
			{
				arrSplit[1] = Left(arrSplit[1], i);
			}
		}
		return arrSplit[0] $ "." $ arrSplit[1] $ "%";
	}
	return string(int(Probability)) $ "%";
}

function string CutFloatDecimalPlaces(float Probability, optional int decimalplaces, optional bool noPercentString)
{
	local string probabilityStr;
	local int i, StrLen, cutLine, decimalInt, probabilityInt;

	local float tmpProbability;
	local array<string> ints;
	local string percentStr;

	// End:0x14
	if(noPercentString)
	{
		percentStr = "";		
	}
	else
	{
		percentStr = "%";
	}
	// End:0x30
	if(decimalplaces == 0)
	{
		decimalplaces = 3;
	}
	// End:0x14F
	if(float(int(Probability)) < Probability)
	{
		decimalInt = ExpInt(10, decimalplaces);
		tmpProbability = Probability * float(decimalInt);
		Split(string(tmpProbability), ".", ints);
		probabilityInt = int(ints[0]) - (int(Probability) * decimalInt);
		probabilityStr = string(probabilityInt);
		StrLen = Len(probabilityStr);

		// End:0xA7 [Loop If]
		for(i = 0; i < decimalplaces - StrLen; i++)
		{
			probabilityStr = "0" $ probabilityStr;
		}

		// End:0x113 [Loop If]
		for(i = 0; i < decimalplaces; i++)
		{
			cutLine = decimalplaces - i;
			// End:0x109
			if(Mid(probabilityStr, cutLine - 1, 1) != "0")
			{
				return ((string(int(Probability)) $ ".") $ Left(probabilityStr, cutLine)) $ percentStr;
			}
		}
		return string(int(Probability)) $ "." $ probabilityStr $ percentStr;
	}
	return string(int(Probability)) $ percentStr;
}


function test(int a, int b, optional int x, optional string str)
{
	if(x == 0)
	{
		Debug("영이래!");
	}

	if(str =="")
	{
		Debug("스트링 꽝!");
	}
	
}

function onCallUCFunction(string functionName, string param)
{
	//Debug("onCallUCFunction L2Util" @ functionName @ param);
	switch(functionName)
	{
		case "handleDialogBox":
			handleDialogBox(param);
		break;
		case "BrintToFront" :			
			class'UIAPI_WINDOW'.static.BringToFront(param);
		break;
		case "MoveTo" :
			handleMoveTo(param);
		break;		
	}
}

function handleMoveTo(string param)
{	
	local string windowName ;
	local int x, y, targetOffsetX, targetOffsetY, anchorPoint ;
	local Rect tempRect ;	

	parseString(param, "windowName", windowName);
	if(!class'UIAPI_WINDOW'.static.isShowWindow(windowName))return;	
	
	parseInt(param , "x", x);
	parseInt(param , "y", y);
	parseInt(param , "anchorPoint", anchorPoint);

	tempRect = GetWindowHandle(windowName).GetRect();
	//tempRect.nX;
	//tempRect.nY;
	//tempRect.nWidth;
	//tempRect.nHeight;
	targetOffsetX = 0 ;
	targetOffsetY = 0 ;
	switch(anchorPoint)
	{
		case EAnchorPointType.ANCHORPOINT_None :
			break;
		case EAnchorPointType.ANCHORPOINT_TopLeft:
			break;
		case EAnchorPointType.ANCHORPOINT_TopCenter:
			targetOffsetX = - tempRect.nWidth /2;
			break;
		case EAnchorPointType.ANCHORPOINT_TopRight:
			targetOffsetX = - tempRect.nWidth ;
			break;
		case EAnchorPointType.ANCHORPOINT_CenterLeft:			
			targetOffsetY = - tempRect.nHeight /2 ;
			break;
		case EAnchorPointType.ANCHORPOINT_CenterCenter:
			targetOffsetX = - tempRect.nWidth /2;
			targetOffsetY = - tempRect.nHeight /2 ;
			break;
		case EAnchorPointType.ANCHORPOINT_CenterRight:
			targetOffsetX = - tempRect.nWidth ;
			targetOffsetY = - tempRect.nHeight /2 ;
			break;
		case EAnchorPointType.ANCHORPOINT_BottomLeft:
			targetOffsetY = - tempRect.nHeight;
			break;
		case EAnchorPointType.ANCHORPOINT_BottomCenter:
			targetOffsetX = - tempRect.nWidth / 2;
			targetOffsetY = - tempRect.nHeight;
			break;
		case EAnchorPointType.ANCHORPOINT_BottomRight:
			targetOffsetX = - tempRect.nWidth ;
			targetOffsetY = - tempRect.nHeight;
			break;
	}
	GetWindowHandle(windowName).MoveTo( x + targetOffsetX , y + targetOffsetY);
	//Debug(x + targetOffsetX @  y + targetOffsetY  @ anchorPoint );
}


///////////////////////////////////////////////
// ґЩАМѕу·О±Ч №ЪЅє АЇЖї
///////////////////////////////////////////////

function handleDialogBox(string param)
{
	local string functionName;

	parseString(param, "functionName", functionName);

	//Debug("handleDialogBox" @ functionName @ param);
	switch(functionName)
	{
		case "DialogShow":
			handleDialogShow(param);
		break;
		
		case "DialogSetButtonName":
			handleDialogSetButtonName(param);
		break;
		case "DialogSetButtonWidthSize":
			handleDialogSetButtonWidthSize(param);
		break;
		case "DialogShowWithResize":
			handleDialogShowWithResize(param);
		break;		
		case "DialogHide" :
			DialogHide();
		break;
		case "DialogSetDefaultOK":
			DialogSetDefaultOK();
		break;
		case "DialogSetDefaultCancle":
			DialogSetDefaultCancle();
		break;
		case "DialogSetID":
			handleDialogSetID(param);
		break;
		case "DialogSetEditType":
			handleDialogSetEditType(param);
		break;
		case "DialogSetString":
			handleDialogSetString(param);
		break;
		case "DialogGetReservedInt2":
			handleDialogGetReservedInt2();
		break;
		case "DialogSetParamInt64":
			handleDialogSetParamInt64(param);
		break;
		case "DialogSetReservedInt":
			handleDialogSetReservedInt(param);
			break;
		case "DialogSetReservedInt2":
			handleDialogSetReservedInt2(param);
			break;
		case "DialogSetReservedInt3":
			handleDialogSetReservedInt3(param);
			break;
		case "DialogSetEditBoxMaxLength":
			handleDialogSetEditBoxMaxLength(param);
			break;
		case "DialogSetIconTexture" :
			handleDialogSetIconTexture(param);
			break;
		/*case "DialogSetModal":
			handleDialogModaType(param);
			break;

*/
		case "DialogSetCancelD" :
			handleDialogSetCancelD(param);
			break;
	}
}

function handleDialogSetCancelD(string param)
{
	local int targetCancelDialogID;
	parseInt(param,   "targetCancelDialogID", targetCancelDialogID);
	DialogSetCancelD(targetCancelDialogID);
}

/*
function handleDialogModaType(string param)
{
	local DialogBox script ;
	local int isModal;

	parseInt(param , "isModal", isModal);
	script = DialogBox(GetScript("DialogBox"));
	script.m_dialogHandle.SetModal(bool(isModal));
}*/

function handleDialogSetIconTexture(string param)
{
	local string iconTextureStr;
	parseString(param, "iconTextureStr", iconTextureStr);
	DialogSetIconTexture(iconTextureStr);
}

function handleDialogSetEditBoxMaxLength(string param)
{
	local int maxLength;
	parseInt(param, "maxLength", maxLength);
	DialogSetEditBoxMaxLength(maxLength);
}

//int64ґВ №ЮА» јц АЦґВ api°Ў ѕшѕој­ ЅєЖ®ёµАё·О АьИЇ ИД °ЎБ®°Ё.
function handleDialogGetReservedInt2()
{
	m_reservedInt2 = string(DialogGetReservedInt2());	
}

function handleDialogSetReservedInt3(string param)
{
	local int value;
	parseInt(param, "value", value);
	DialogSetReservedInt3(value);
}

function handleDialogSetReservedInt2(string param)
{
	local INT64 value;
	parseInt64(param, "value", value);
	DialogSetReservedInt2(value);	
}

function handleDialogSetReservedInt(string param)
{
	local int value;
	parseInt(param, "value", value);
	DialogSetReservedInt(value);
}

function handleDialogSetParamInt64(string param)
{
	local INT64 value;
	parseINT64(param, "param", value );
	DialogSetParamInt64(value);
}

function handleDialogSetString(string param)
{
	local string strInput;
	parseString(param, "strInput", strInput );
	DialogSetString(strInput);
}

function handleDialogSetEditType(string param)
{
	local string strType;
	parseString(param, "strType", strType );
	DialogSetEditType(strType);
}

function handleDialogSetID(string param)
{
	local int id;	
	parseInt(param, "id", id );
	DialogSetID(id);
}

function handleDialogSetButtonWidthSize(string param)
{
	local int indexOK;
	local int indexCancel;
	parseInt(param, "indexOK", indexOK );
	parseInt(param, "indexCancel", indexCancel );
	
	DialogSetButtonWidthSize(indexOK, indexCancel);
}


function handleDialogSetButtonName(string param)
{
	local int indexOK;
	local int indexCancel;
	parseInt(param, "indexOK", indexOK );
	parseInt(param, "indexCancel", indexCancel );	
	DialogSetButtonName(indexOK, indexCancel);
}

function handleDialogShowWithResize(string param)
{		
	local int modalType;
	local int dialogType;
	local string strMessage;	
	local int changeWidth;
	local int changeHeight;
	local string strControlName;	

	parseInt(param, "modalType", modalType );
	parseInt(param, "dialogType", dialogType );
	parseString(param, "strMessage", strMessage );	
	parseInt(param, "changeWidth", changeWidth );
	parseInt(param, "changeHeight", changeHeight );
	parseString(param, "strControlName", strControlName );

	DialogShowWithResize(EDialogModalType(modalType), EDialogType(dialogType), strMessage, changeWidth, changeHeight, strControlName);
}

function handleDialogShow(string param)
{		
	local int modalType;
	local int dialogType;
	local string strMessage;
	local string strControlName;
	local int dialogWeight;
	local int dialogHeight;
	local int  UseHtml;
	local string customIconTexture;

	parseInt(param, "modalType", modalType );
	parseInt(param, "dialogType", dialogType );
	parseString(param, "strMessage", strMessage );
	parseString(param, "strControlName", strControlName );
	parseInt(param, "dialogWeight", dialogWeight );
	parseInt(param, "dialogHeight", dialogHeight );
	parseInt(param, "bUseHtml", UseHtml );
	parseString(param, "customIconTexture", customIconTexture );

	DialogShow(EDialogModalType(modalType), EDialogType(dialogType), strMessage, strControlName, dialogWeight, dialogHeight, bool(UseHtml), customIconTexture);
}




////////////////////////////////////////////
// ё®ЅєЖ® ДБЖ®·С АЇЖї
////////////////////////////////////////////

/**
 *  ДБЖ®·С ё®ЅєЖ®їЎј­ АМё§А» ±вБШАё·О °Л»цЗПї© ЗШґз АОµ¦Ѕєё¦ ё®ЕП
 *  Г№№шВ° Змґх°Ў ґлєОєР "АМё§" АМ¶у ёёµз АЇЖї -_-;
 **/ 
function int ctrlListSearchByName(ListCtrlHandle listCtrl, string name)
{
	// parse var
	local LVDataRecord record;
	local int i, nReturn;

	nReturn = -1;

	for(i = 0; i < listCtrl.GetRecordCount(); i++)
	{
		listCtrl.GetRec(i, record);
		if(record.LVDataList[0].szData == name)
		{
			nReturn = i;
			break;
		}
	}
	return nReturn;
}

/**
 *  ЗцАз ¶ЗґВ АМАьїЎ ј±ЕГµЗѕъґш ДЈ±ё ё®ЅєЖ®АЗ °ЄА» ±вБШАё·О Record °ЄА» ё®ЕПЗСґЩ.
 **/
function LVDataRecord getListSelectedRecord(ListCtrlHandle list, int index)
{	
	local LVDataRecord record;

	list.SetSelectedIndex(index, true);
	list.GetRec(index, record);

	return record;
}

/**
 *  int Зь №иї­ јЕЗГ ЗФјц 
 * ex)
  	local Array<int> testArr; 
 	local int i;

	testArr[0] = 0;
	testArr[1] = 1;
	testArr[2] = 2;
	testArr[3] = 3;
	testArr[4] = 4;
	testArr[5] = 5;
	testArr[6] = 6;
	testArr[7] = 7;
	testArr[8] = 8;
	testArr[9] = 9;
	util.arrayShuffleInt(testArr);
	for(i = 0; i < 10; i++)Debug("testArr: " $ testArr[i]);
 **/
function arrayShuffleInt(out array<int> tempArray)
{
	local int i, ran, tempArrayLen;
	local array<int> changeArray;

	changeArray = tempArray;

	tempArrayLen = tempArray.Length;
	tempArray.Remove(0, tempArray.Length);

	for(i = 0; i < tempArrayLen; i++)
	{
		ran = rand(changeArray.Length);
		
		tempArray[i] = changeArray[ran];
		changeArray.Remove(ran, 1);
	}
}

/**
 * SEC ГКё¦ іЦАёёй ЅГ єР , 1ЅГ°Ј №МёёАє %єР 
 * °°Ає ЗьЅДАё·О ЅєЖ®ёµА» ё®ЕПЗСґЩ.
 * 2ЅГ°Ј 50єР ,  1ЅГ°Ј ,  48єР
 * getTimeStringBySec(5000, true); --> "1ЅГ°Ј"
 * getTimeStringBySec(5000, true); --> "1ЅГ°Ј"
 * getTimeStringBySec(100 , true); --> "1ЅГ°Ј №Мёё"
 * getTimeStringBySec(5000, true , true); --> "1ЅГ°Ј 23єР" 
 * getTimeStringBySec(500, true , true); --> " 8єР" 
 * getTimeStringBySec(5000, false, true); --> "83єР"  
 **/
function string getTimeStringBySec(int sec, optional bool hourFlag, optional bool minFlag)
{
	local int timeTemp;
	local string returnStr;

	returnStr = "";
	timeTemp =((sec / 60)/ 60);
	
	if(timeTemp > 0)
	{		
		// ЅГ єР , ЅГ ,  єР  ЕёАФАё·О іЄїАґВ °Н јјЖГ 
		if(hourFlag && minFlag)returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp), string(int((sec / 60)% 60)));		
		else if(hourFlag && minFlag == false)returnStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeTemp));
		else if(hourFlag == false && minFlag)returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp));
	}
	else 
	{
		// ЅГ°Јёё іЄїАґВ °Е¶уёй..
		if(hourFlag && minFlag == false)
		{
			// 1ЅГ°Ј №Мёё 
			if(sec <= 0)
			{
				returnStr = MakeFullSystemMsg(GetSystemMessage(3407), "0");
			}
			else
			{
				returnStr = MakeFullSystemMsg(GetSystemMessage(3407), "1");
			}
		}
		else 
		{
			// ЗС ЅГ°Ј №МёёАМёй..  єРАё·О іЄїВґЩ.
			// єР °и»к 

			timeTemp =(sec / 60);
			// єРАМ 0АМ іЄїВ °жїм 0єёґЩ АЫ
			if(timeTemp <= 0)timeTemp = 1;				
			returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp));
		}
	}

	return returnStr;
	 
}

/**
 * АП/ЅГ°Ј/єР || ЅГ°Ј/єР || //єР || //1єР№Мёё Аё·О ЅГ°Ј №ЩІгБЬ
 **/
function string getTimeStringBySec2(int sec)
{
	local int timeTemp, timeTemp0, timeTemp1;
	local string returnStr;

	returnStr = "";
	timeTemp =((sec / 60)/ 60 / 24);
	timeTemp0 =((sec / 60)/ 60);
	timeTemp1 =((sec / 60));

	if(timeTemp > 0)
	{
		//АП/ЅГ°Ј/єР
		returnStr =  MakeFullSystemMsg(GetSystemMessage(4466), string(timeTemp), string(int((sec / 60)/ 60 % 24)), string(int((sec / 60)% 60)));
	}
	else if(timeTemp0 > 0)
	{
		//ЅГ°Ј/єР
		returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp0), string(int((sec / 60)% 60)));
	}
	else if(timeTemp1 > 0)
	{
		//єР
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));
	}
	else
	{
		//1єР№Мёё
		returnStr = MakeFullSystemMsg(GetSystemMessage(4360), string(1));
	}
	return returnStr;	 
}

/**
 * АП/ЅГ°Ј || ЅГ°Ј/єР || //єР || //1єР№Мёё Аё·О ЅГ°Ј №ЩІгБЬ
 **/
function string getTimeStringBySec3(int sec)
{
	local int timeTemp, timeTemp0, timeTemp1;
	local string returnStr;

	returnStr = "";
	timeTemp =((sec / 60)/ 60 / 24);
	timeTemp0 =((sec / 60)/ 60);
	timeTemp1 =((sec / 60));

	if(timeTemp > 0)
	{
		//АП/ЅГ°Ј/єР
		returnStr =  MakeFullSystemMsg(GetSystemMessage(3503), string(timeTemp), string(int((sec / 60)/ 60 % 24)));
	}
	else if(timeTemp0 > 0)
	{
		//ЅГ°Ј/єР
		returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp0), string(int((sec / 60)% 60)));
	}
	else if(timeTemp1 > 0)
	{
		//єР
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));
	}
	else
	{
		//1єР№Мёё
		returnStr = MakeFullSystemMsg(GetSystemMessage(4360), string(1));
	}
	return returnStr;	 
}

function string GetTimeStringBySec4(int Sec)
{
	local int timeTemp, timeTemp0, timeTemp1, timeTemp2;
	local string returnStr;

	returnStr = "";
	timeTemp = Sec / 60 / 60 / 24;
	timeTemp0 = Sec / 60 / 60;
	timeTemp1 = Sec / 60;
	timeTemp2 = Sec -(timeTemp1 * 60);
	// End:0x83
	if(timeTemp > 0)
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3418), string(timeTemp));		
	}
	else if(timeTemp0 > 0)
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeTemp0));
	}
	else if(timeTemp0 > 0)
	{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeTemp0));			
	}
	else if(timeTemp1 > 0)
	{
		// End:0xE6
		if(timeTemp2 == 0)
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));					
		}
		else
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(13418), string(timeTemp1), string(timeTemp2));
		}				
	}
	else
	{
		returnStr = MakeTimeString(Sec);
	}

	return returnStr;
}

function string GetTimeStringBySec5(float Sec)
{
	local int timeTemp, timeTemp0, timeTemp1, timeTemp2;
	local string returnStr;

	returnStr = "";
	timeTemp = (int(Sec / 60) / 60) / 24;
	timeTemp0 = int(Sec / 60) / 60;
	timeTemp1 = int(Sec / 60);
	timeTemp2 = int(Sec - timeTemp1 * 60);
	// End:0x93
	if(timeTemp > 0)
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3418), string(timeTemp));		
	}
	else if(timeTemp0 > 0)
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeTemp0));			
	}
	else if(timeTemp1 > 0)
	{
		// End:0xF6
		if(timeTemp2 == 0)
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));					
		}
		else
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(13418), string(timeTemp1), string(timeTemp2));
		}				
	}
	else
	{
		returnStr = MakeTimeString(Sec);
	}
	return returnStr;	
}

function string GetTimeStringBySec6(int Sec)
{
	local int timeTemp0, timeTemp1;
	local string returnStr;

	returnStr = "";
	timeTemp0 = (Sec / 60) / 60;
	timeTemp1 = Sec / 60;
	// End:0x9D
	if(timeTemp0 > 0)
	{
		// End:0x6B
		if((float(timeTemp1) % 60) == 0)
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeTemp0));			
		}
		else
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp0), string(int(float(timeTemp1) % float(60))));
		}		
	}
	else if(timeTemp1 > 0)
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));			
	}
	else
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));
	}

	return returnStr;	
}

/**
 *  ЅГЅєЕЫ ЅєЖ®ёµ №шИЈё¦ ЅЗБ¦ ёЕДЄ µЗґВ №®АЪ·О іЦґВґЩ.
 *  
 *  local array<string>	titleNameArray;
 *  arraySystemStringNumToString("144,145", titleNameArray);
 *  --> ["АьГј", "µµїтё»"] №иї­АМ Г¤їц БшґЩ.
 **/
function setSystemStringArrayByNumStr(string systemStringNum, out array<string> targetArray)
{
	local int i;
	local array<string> tempArray;

	Split(systemStringNum, ",", tempArray);
	
	targetArray.Remove(0, targetArray.Length);

	for(i = 0; i < tempArray.Length; i++)
	{
		targetArray[i] = GetSystemString(int(tempArray[i]));
	}
}

function setArrayByNumStr(string systemStringNum, out array<string> targetArray)
{
	local int i;
	local array<string> tempArray;

	Split(systemStringNum, ",", tempArray);
	targetArray.Remove(0, targetArray.Length);

	// End:0x58 [Loop If]
	for(i = 0; i < tempArray.Length; i++)
	{
		targetArray[i] = tempArray[i];
	}
}

/**  №«±Ю, D, C ... µо±ЮАЗ ЅєЖ®ёµА» ё®ЕПЗСґЩ. */
function string getItemGradeSystemString(int nCrystalType)
{
	local string returnStr;

	switch(nCrystalType)
	{
		case 0  : returnStr = GetSystemString(2622); break; // №«±Ю
		case 1  : returnStr = GetSystemString(2613); break; // D
		case 2  : returnStr = GetSystemString(2614); break; // C
		case 3  : returnStr = GetSystemString(2615); break; // B
		case 4  : returnStr = GetSystemString(2616); break; // A
		case 5  : returnStr = GetSystemString(2617); break; // S
		case 6  : returnStr = GetSystemString(2682); break; // s80
		case 7  : returnStr = GetSystemString(2683); break; // s84
		case 8  : returnStr = GetSystemString(2618); break; // R
		case 9  : returnStr = GetSystemString(2619); break; // R95
		case 10 : returnStr = GetSystemString(2620); break; // R99
		case 11 : returnStr = GetSystemString(3919); break; // R110

	    default : returnStr = "";
	}

	return returnStr;
}


/**
 * 
 *  №ЯЕНЅє ±в»зґЬ јєАе ±ё°Ј ГјЕ© ИД ГўА» ґЭґВґЩ. 
 *  °шЕлАыАё·О onShow їЎ іЦѕо БШґЩ.
 *  
 **/
function bool checkIsPrologueGrowType(string WindowName)
{
	// End:0x40
	if(getIsPrologueGrowType())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4533));
		class'UIAPI_WINDOW'.static.HideWindow(getCurrentWindowName(WindowName));
		return true;
	}
	return false;
}

/**
 * 
 *  №ЯЕНЅє ±в»зґЬ јєАе ±ё°Ј ГјЕ© 
 *  ЗцАз Е¬·ЎЅє ID·О ГјЕ© ЗХґПґЩ. 
 *  EV_ChangedSubjob АМєҐЖ® ¶§ №Щ·О ЅЗЗа ЗПёй ёВБц ѕКЅАґПґЩ. ЗШґз param CurrentSubjobClassIDё¦ ЖДЅМ ЗШј­ »зїл ЗШѕЯ ЗХґПґЩ.
 *  ѕЖ·№іЄїЎј­ґВ ЗШґз Е¬·ЎЅє°Ў »зїл µЗБцёё, №ЯЕНЅє ±в»зґЬ ±ёєРАМ ѕшЅАґПґЩ.
 *  ¶уАМєкїЎј­ёё ГјЕ© µЗµµ·П АЫѕчЗЯЅАґПґЩ.
 *  
 **/ 
function bool getIsPrologueGrowType(optional int CurrentSubjobClassID)
{
	local userInfo myUserInfo ;	
	local bool isPrologueGrowType;

	if(CurrentSubjobClassID > 0)	
		isPrologueGrowType = class'UIDATA_USER'.static.IsPrologueGrowType(CurrentSubjobClassID);
	else if(GetPlayerInfo (myUserInfo))
		isPrologueGrowType = class'UIDATA_USER'.static.IsPrologueGrowType(myUserInfo.nSubClass);
	else return false;
	
	return(isPrologueGrowType && getInstanceUIData().getIsLiveServer());
}



/**
 * 
 *  currentWindowName ЗцАз БцБ¤ЗС А©µµїм°Ў ѕЖґС ѕЖАМЕЫ °Е·Ў ±іИЇ °ь°иµИ А©µµїмґВ ёрµО ґЭґВґЩ. 
 *  
 *  exceptionWindowNameWithComma : "RefineryWnd,PrivateShopWnd"  <- АМ·±ЅДАё·О ЅєЖ®ёµА» іЦґВґЩ 
 *  
 *  
 **/
function ItemRelationWindowHide(string currentWindowName, optional string exceptionWindowNameWithComma)
{

	local int i, len;	
	len = ItemRelationWindowArrayStr.Length;
	// Debug("ЗцАз А©µµїм " @ currentWindowName);



	for(i = 0; i < len; i++)
	{
		// Debug(ItemRelationWindowArrayStr[i]);
		// ѕЖАМЕЫ °ь°иµИ ёс·ПАМ ГЯ°Ў µЗёй ГЯ°Ў ЗШѕЯ ЗСґЩ. 
		hideTargetWindow(currentWindowName, ItemRelationWindowArrayStr[i], exceptionWindowNameWithComma);
	}	
}

/**
 *  ЗцАз А©µµїмёё іЄµО°н, іЄёУБц ѕЖАМЕЫ °ь·ГµИ ёрµз А©µµїмё¦ ґЭѕЖ №цё°ґЩ.
 *  
 *  -  БЦАЗ!!! --
 *  ґЭА»¶§ґВ °ў А©µµїм ё¶ґЩ °нАЇ ґЭґВ ЗьЅДАё·О ґЭѕЖ БЦ°Ф ёёµйѕъґЩ.
 *  И¤ЅГ ГЯ°Ў ЗТ¶§ АМ·±ЅДАё·О АПАПАМ ГЈѕЖј­ ЗШґз ґЭ±в ЗФјцё¦ ЅЗЗа ЗШѕЯ ЗПґП БЦАЗ №Щ¶хґЩ.
 *  
 **/
function hideTargetWindow(string currentWindowName, string WindowHandleString, optional string exceptionWindowNameWithComma)
{
	local int i;
	local array<string>	exceptionArray;


	if(exceptionWindowNameWithComma != "")
	{
		Split(exceptionWindowNameWithComma, ",", exceptionArray);

		if(exceptionArray.Length <= 1)
		{
			// , °Ў ѕшґВ °жїм¶уёй..
			exceptionArray[0] = exceptionWindowNameWithComma;
			// Debug("ЗПіЄ "@ exceptionArray[0]);
		}		
	}

	for(i = 0; i< exceptionArray.Length; i++)
	{
		// Debug("WindowHandleString" @ WindowHandleString);
		// Debug("exceptionArray[i]" @ exceptionArray[i]);
		// ї№їЬ А©µµїмїЎ АЦАёёй ґЭБц ѕКґВґЩ.
		if(WindowHandleString == exceptionArray[i])return;
	}

	// ЗцАз А©µµїмїН °°Бц ѕКАє °жїм, °°ґЩёй іЄµРґЩ. 
	if(currentWindowName != WindowHandleString)
	{		
		// ЗШґз А©µµїм°Ў ї­·Б АЦґЩёй!
		//GFx А©µµїм µйАє ѕЖ·Ўј­ Гіё® ЗШѕЯ ЗФ. GetWindowHandle АМ ЗФјц°Ў АЫµї ѕИ µЗ±в ¶§№®
		//AlchemyMixCubeWnd,AlchemyItemConvesionWnd"
		/*
		if(WindowHandleString == "AdenaDistributionWnd")
		{
			if(class'UIAPI_WINDOW'.static.IsShowWindow(WindowHandleString))
			{
				switch(WindowHandleString)
				{
					case "AdenaDistributionWnd"     :
						CallGFxFunction(WindowHandleString, "RequestDivideAdenaCancel", "");
						class'UIAPI_WINDOW'.static.hideWindow(WindowHandleString);
						break;
					Default : class'UIAPI_WINDOW'.static.hideWindow(WindowHandleString);
				}
			}
		}

		else */
		if(class'UIAPI_WINDOW'.static.isShowWindow(WindowHandleString))
		{
			// А©µµїмё¦ ґЭѕЖ №цё°ґЩ. 
			// ґЭА»¶§ °ў А©µµїм ё¶ґЩ ±ЧіЙ hideWindow ЗПёй ѕИµЗґВ °жїм°Ў АЦґЩ.
			// debug("WindowHandleString:---> " @ WindowHandleString);
			switch(WindowHandleString)				
			{
				case "PrivateShopWnd"           : privateShopWndScript.OnClickButton("StopButton"); break;
				case "UnrefineryWnd"            : UnrefineryWndScript.OnClickButton("btnClose");	break;		
				case "AttributeRemoveWnd"       : AttributeRemoveWndScript.OnbtnCancelClick(); break;
				case "AttributeEnchantWnd"      : AttributeEnchantWndScript.OnReceivedCloseUI(); break;
				case "CrystallizationWnd"       : CrystallizationWndScript.cancelCystallizeItem(); break;
				case "ItemLookChangeWnd"        : ItemLookChangeWndScript.OnClickButton("ExitBtn"); break; //branch 111109
				case "MultiSellWnd"             : MultiSellWndScript.OnClickButton("Close_Button"); break;
				case "TradeWnd"                 : TradeWndScript.OnClickButton("CancelButton"); GetWindowHandle(WindowHandleString).HideWindow(); RequestItemList(); break; //AnswerTradeRequest(false);
				case "DeliverWnd"               : DeliverWndScript.OnClickButton("CancelButton"); break;		
				case "ItemAttributeChangeWnd"   : ItemAttributeChangeWndScript.OnClickButton("CancelBtn"); break;
				case "AdenaDistributionWnd"     : CallGFxFunction(WindowHandleString, "RequestDivideAdenaCancel", ""); break;

				default : class'UIAPI_WINDOW'.static.HideWindow(WindowHandleString);
			}			
		}
	}
}

/**
 * ЗцАз ѕЖАМЕЫ °ь°и А©µµїм°Ў ї­·Б АЦґЩёй.. ЗцАз А©µµїмё¦ ї­Бц ѕК°н 
 * ґЩЅГ јы±дґЩ. 
 * ѕЖАМЕЫµйАМ ї­·Б АЦґЩёй..
 * 
 * Б¤ГҐ»у ЗцАз »зїлѕИЗП°Ф µЗѕъАЅ..
 **/
function ItemRelationWindowsShowChecker(string currentWindowName)
{
	privateShopWndScript = PrivateShopWnd(GetScript("PrivateShopWnd"));

	// ЗС°і¶уµµ ї­·Б АЦґЩёй...
	if(isItemRelationWindowsShow(currentWindowName))
	{
		if(GetWindowHandle(currentWindowName).IsShowWindow())
		{
			// ЗШґз А©µµїмё¦ ґЭґВґЩ. 
			hideTargetWindow("", currentWindowName);
			// GetWindowHandle(currentWindowName).HideWindow();
		}
	}
}

/**  ѕЖАМЕЫ °ь·ГµИ А©µµїм°Ў ї­·Б АЦіЄ?(ЗцАз БцБ¤ЗС А©µµїм Б¦їЬ)*/
function bool isItemRelationWindowsShow(string currentWindowName)
{
	local bool checkFlag;	
	local int i, len;

	len       = ItemRelationWindowArrayStr.Length;
	checkFlag = false;
	
	// Debug("ItemRelationWindowArrayStr : "  @ ItemRelationWindowString);
	// Debug("i = " @ len);

	for(i = 0; i < len; i++)
	{
		// Debug("ItemRelationWindowArrayStr[i]" @ ItemRelationWindowArrayStr[i]);
		if(currentWindowName != ItemRelationWindowArrayStr[i])
		{		
			if(GetWindowHandle(ItemRelationWindowArrayStr[i]).IsShowWindow()){ checkFlag = true; break; }
		}
	}

	return checkFlag;
}

/**
 *  "0" Б¦·О »эјє±в 
 *  
 *  ёЕ°ієЇјц 
 *    len    : 5  -> ±ЫАЪјц БцБ¤
 *    num    : 696
 *    ё®ЕП°Є : --> 00696 ЅєЖ®ёµАё·О ё®ЕП
 **/
function string makeZeroString(int strLen, INT64 num)
{
	local int i;
	local string sum;

	sum = string(num);

	for(i = 0; i < strLen; i++)
	{	
		if(len(sum)>= strLen)
		{
			break;
		}
		else
		{
			sum = "0" $ sum;
		}
	}

	// Debug("sum:::" @ sum);
	return sum;
}

/** 
 * 
 * А©µµїм АМё§А» №ЮґВґЩ.
 * 
 * getWindowName(string(Self))
 * 
 **/
function string getSliceWindowName(string targetString)
{
	local array<string>	ArrayStr;

	
	Split(targetString, ".", ArrayStr);

	return ArrayStr[1];
}


//************************************************************************************************************************
// µҐАМЕё °ь·Г : ЗПµе ДЪµщ 
//************************************************************************************************************************
/**
 *  ДіёЇЕН »эјє °ь·Г ЅєЖ®ёµ ёрАЅ
 **/

// Gfx CharacterData.as ДЪµеїЎ Б¤АЗ
//function array<int> getRaceBasicSkillID(int race)
//{
//	local array<int>ArrayRaceBasicSkillID;
//	switch(race){
//	case 0 : //ИЮёХАє ЅєЕіАМ ѕшЅАґПґЩ.
//		break;
//	case 1 :
//		ArrayRaceBasicSkillID[0] = 58; 
//		break;
//	case 2 :
//		ArrayRaceBasicSkillID[0] = 294;		
//		break;
//	case 3 :
//		ArrayRaceBasicSkillID[0] = 134;
//		ArrayRaceBasicSkillID[1] = 295;
//		break;
//	case 4 : 
//		ArrayRaceBasicSkillID[0] = 150;
//		ArrayRaceBasicSkillID[1] = 1321;
//		break;
//	case 5 : 
//		ArrayRaceBasicSkillID[0] = 467;		
//		break;
//	case 6 : 
//		//ѕЖёЈЕЧАМѕоґВ єЈАМБч ЅєЕіАМ ѕшЅАґПґЩ.
//		//ArrayRaceBasicSkillID[0] = 467;		
//		break;
//	}
//	//Debug("Util.ArrayRaceBasicSkillID.length" @ArrayRaceBasicSkillID.length);
//	return ArrayRaceBasicSkillID;
//}

//function array<int> getRaceAwakenSkillID(int race)
//{
//	local array<int>ArrayRaceAwakenSkillID;	
//	//Бчѕч јјєРИ­·О 120829 јцБ¤
//	switch(race){
//	case 0 : //ИЮёХ 2

//		ArrayRaceAwakenSkillID[0] = 1901; //ЅГАЫ №шИЈ
//		ArrayRaceAwakenSkillID[1] = 1902; 
//		//ArrayRaceAwakenSkillID[2] = 1903; 
//		//ArrayRaceAwakenSkillID[3] = 1904; 
//		break;
//	case 1 ://ї¤ЗБ 2
//		//ArrayRaceAwakenSkillID[0] = 1905; 
//		ArrayRaceAwakenSkillID[0] = 1906; 
//		//ArrayRaceAwakenSkillID[2] = 1907; 
//		ArrayRaceAwakenSkillID[1] = 1908; 
//		break;
//	case 2 ://ґЩї¤ 2
//		ArrayRaceAwakenSkillID[0] = 1909; 
//		//ArrayRaceAwakenSkillID[1] = 1910; 
//		ArrayRaceAwakenSkillID[1] = 1911; 
//		//ArrayRaceAwakenSkillID[3] = 1912; 
//		//ArrayRaceAwakenSkillID[4] = 1913; 
//		break;
//	case 3 ://їАЕ© 2
//		//ArrayRaceAwakenSkillID[0] = 1914; 
//		ArrayRaceAwakenSkillID[0] = 1915; 
//		ArrayRaceAwakenSkillID[1] = 1916; 
//		//ArrayRaceAwakenSkillID[3] = 1917; 
//		break;
//	case 4 : //µеїцЗБ 2 
//		ArrayRaceAwakenSkillID[0] = 1919; 
//		//ArrayRaceAwakenSkillID[1] = 1920; 
//		ArrayRaceAwakenSkillID[1] = 1921; 
//		//ArrayRaceAwakenSkillID[3] = 1922; 
//		//2011 05 30 јј°і ЅєЕі ГЯ°Ў ЗШѕЯ ЗСґЩґВ і»їлАё·О ttp°Ў їФАёіЄ і»їл И®АО БЯ
//		//ArrayRaceAwakenSkillID[4] = 19088; 
//		//ArrayRaceAwakenSkillID[5] = 19089; 
//		//ArrayRaceAwakenSkillID[6] = 19090; 
//		break;
//	case 5 ://Д«ё¶ї¤ 3
//		ArrayRaceAwakenSkillID[0] = 1923; 
//		ArrayRaceAwakenSkillID[1] = 1924; 
//		//ArrayRaceAwakenSkillID[2] = 1925; 
//		ArrayRaceAwakenSkillID[2] = 1926; 
//		break;
//	case 6 ://ѕЖёЈЕЧАМѕЖ 4
//		ArrayRaceAwakenSkillID[0] = 30400; 
//		ArrayRaceAwakenSkillID[1] = 30401; 		
//		ArrayRaceAwakenSkillID[2] = 30402; 
//		break;
//	}
//	return ArrayRaceAwakenSkillID;
//}

function int GetInitClassID(int race, int option){
	local array<int> InitClassID ;

	switch(race){
		case 0 :
			InitClassID[0] = 0    ;//ИЮёХ ЖДАМЕН
			InitClassID[1] = 10   ;//ИЮёХ ёЮАМБц
			// End:0x3F
			if(getInstanceUIData().getIsLiveServer())
			{
				InitClassID[2] = 212;				
			}
			else
			{
				InitClassID[2] = 196;
				// End:0x5E
				if(IsAdenServer())
				{
					InitClassID[3] = 221;
				}
			}
			break;
		case 1:
			InitClassID[0] = 18   ;//ї¤єм ЖДАМЕН
			InitClassID[1] = 25   ;//ї¤єм ёЮАМБц
			InitClassID[2] = 200;
			break;
		case 2 :
			InitClassID[0] = 31   ;//ґЩЕ© ЖДАМЕН
			InitClassID[1] = 38   ;//ґЩЕ© ёЮАМБц
			InitClassID[2] = 204;
			// End:0xBF
			if(IsAdenServer())
			{
				InitClassID[3] = 221;
			}
			break;
		case 3 :
			InitClassID[0] = 44   ;//їАЕ© ЖДАМЕН
			InitClassID[1] = 49   ;//їАЕ© ёЮАМБц
			InitClassID[2] = 217;
			break;
		case 4 : 
			InitClassID[0] = 53   ;//µеїцєм ЖДАМЕН
			InitClassID[1] = 53   ;//µеїцєм ЖДАМЕН
			break;
		case 5 :
			if(getInstanceUIData().getIsClassicServer())
			{
				InitClassID[0] = 192  ;//Д«ё¶ї¤ јЦБ® іІ
				InitClassID[1] = 192  ;//Д«ё¶ї¤ јЦБ® ї©	
			}
			else
			{
				InitClassID[0] = 123  ;//Д«ё¶ї¤ јЦБ® іІ
				InitClassID[1] = 124  ;//Д«ё¶ї¤ јЦБ® ї©	
			}
			break;
		case 6 :
			InitClassID[0] = 182  ;//ѕЖёЈЕЧАМѕо ЖДАМЕН ї©
			InitClassID[1] = 183  ;//ѕЖёЈЕЧАМѕо ёЮАМБц ї©
			break;
		// End:0x12C
		case 30:
			InitClassID[0] = 208;
			InitClassID[1] = 208;
		// End:0xFFFF
	}
	
	// End:0x177
	if(InitClassID.Length > Option)
	{
		return InitClassID[Option];
	}
	return -1;	
}


// АМё§їЎ µы¶у №иї­А» Б¤ё® ЗПґВ ЗФјц 
function array<itemInfo> sortByName(array<itemInfo> itemList)
{
	local int len;		
	local ItemInfo temp;
	local int i;
	local int j;
	len = itemList.Length;	
	for(i = 0; i < len; ++i)
	{
		for(j = 0; j < len - i; ++j)
		{
			if(j < len - 1)
			{
				if(GetItemNameWithAdditional(itemList[j])> GetItemNameWithAdditional(itemList[j + 1]))
				{
					temp = itemList[j];
					itemList[j] = itemList[j + 1];
					itemList[j + 1] = temp;
				}
			}
		}
	}
	return itemList;
}

// №«°ФїЎ µы¶у №иї­А» Б¤ё® ЗПґВ ЗФјц 
function array<ItemInfo> sortByWeight(array<itemInfo> itemList)
{
	local int len;
	local ItemInfo temp;
	local int i;
	local int j;
	len = itemList.Length;	
	for(i = 0; i < len; ++i)
	{
		for(j = 0; j < len - i; ++j)
		{
			if(j < len - 1)
			{
				if(itemList[j].Weight < itemList[j + 1].Weight)
				{
					temp = itemList[j];
					itemList[j] = itemList[j + 1];
					itemList[j + 1] = temp;
				}
			}
		}
	}
	return itemList;
}

// int°Є їЎ µы¶у №иї­А» Б¤ё® ЗПґВ ЗФјц ?? »зїлЗПБц ѕКАЅ?
function array<int> sortByInt(array<int> itemList)
{
	local int len;
	local int temp;
	local int i;
	local int j;
	len = itemList.Length;
	for(i = 0; i < len; ++i)
	{
		for(j = 0; j < len - i; ++j)
		{
			if(j < len - 1)
			{
				if(itemList[j] < itemList[j + 1])
				{
					temp = itemList[j];
					itemList[j] = itemList[j + 1];
					itemList[j + 1] = temp;
				}
			}
		}
	}
	return itemList;
}

// АОГѕЖ® јцДЎїЎ і·Ає °Н єОЕН
function array<ItemInfo> sortByEnchanted(array<ItemInfo> itemList)
{
	local int len;
	local ItemInfo temp;
	local int i;
	local int j;

	len = itemList.Length;	

	for(i = 0; i < len; ++i)
		for(j = 0; j < len - i; ++j)
			if(j < len - 1)
				if(itemList[j].enchanted > itemList[j + 1].enchanted)
				{
					temp = itemList[j];
					itemList[j] = itemList[j + 1];
					itemList[j + 1] = temp;
				}
				
	
	return itemList;
}

// defaultPrice їЎ µы¶у №иї­А» Б¤ё® ЗПґВ ЗФјц 
function array<ItemInfo> sortByDP(array<ItemInfo> itemList)
{
	local int len;
	local ItemInfo temp;
	local int i;
	local int j;
	len = itemList.Length;
	for(i = 0; i < len; ++i)
	{
		for(j = 0; j < len - i; ++j)
		{
			if(j < len - 1)
			{
				//Debug("sortByDP" @ itemList[j].Name @ itemList[j].n64DefaultPriceFromScript @ itemList[j + 1].n64DefaultPriceFromScript);				
				if(itemList[j].n64DefaultPriceFromScript < itemList[j + 1].n64DefaultPriceFromScript)
				{
					temp = itemList[j];
					itemList[j] = itemList[j + 1];
					itemList[j + 1] = temp;
				}
			}
		}
	}
	return itemList;
}

delegate int SortByItemNameDelegate(ItemInfo aItemInfo, ItemInfo bItemInfo)
{
	if(GetItemNameWithAdditional(aItemInfo)> GetItemNameWithAdditional(bItemInfo))
		return -1;
	return 0;
}

delegate int SortByCrystalTypeDelegate(ItemInfo aItemInfo, ItemInfo bItemInfo)
{
	if(aItemInfo.CrystalType < bItemInfo.CrystalType)
		return -1;
	return 0;
}

delegate int SortByClassIDDelegate(ItemInfo aItemInfo, ItemInfo bItemInfo)
{
	if(aItemInfo.Id.ClassID < bItemInfo.Id.ClassID)
		return -1;
	return 0;
}

delegate int SortByItemTypeDelegate(ItemInfo aItemInfo, ItemInfo bItemInfo)
{
	if(GetSortOrderEquip(aItemInfo)> GetSortOrderEquip(bItemInfo))
		return -1;
	return 0;
}

delegate int SortBySortOrderDelegate(ItemInfo aItemInfo, ItemInfo bItemInfo)
{
	if(aItemInfo.SortOrder < bItemInfo.SortOrder)
		return -1;
	return 0;
}

function int GetSortOrderEquip(ItemInfo iInfo)
{
	// End:0x18
	if(iInfo.Id.ClassID == 57)
	{
		return 0;
	}
	// End:0x33
	if(iInfo.Id.ClassID == 91663)
	{
		return 1;
	}
	switch(EItemType(iInfo.ItemType))
	{
		// End:0x4C
		case ITEM_WEAPON:
			return 2;
		// End:0x7B
		case ITEM_ETCITEM:
			switch(EEtcItemType(iInfo.EtcItemType))
			{
				// End:0x6A
				case ITEME_ARROW:
					return 3;
					// End:0x78
					break;
				// End:0x75
				case ITEME_BOLT:
					return 4;
					// End:0x78
					break;
				// End:0xFFFF
				default:
					break;
			}
			// End:0x7E
			break;
	}
	switch(iInfo.SlotBitType)
	{
		// End:0x9A
		case 1024:
			return 5;
			// End:0x2BB
			break;
		// End:0xAA
		case 2048:
			return 6;
			// End:0x2BB
			break;
		// End:0xBA
		case 4096:
			return 7;
			// End:0x2BB
			break;
		// End:0xC7
		case 64:
			return 8;
			// End:0x2BB
			break;
		// End:0xD7
		case 512:
			return 9;
			// End:0x2BB
			break;
		// End:0xE7
		case 32768:
			return 10;
			// End:0x2BB
			break;
		// End:0xEE
		case 2:
		// End:0xF5
		case 4:
		// End:0x102
		case 6:
			return 11;
			// End:0x2BB
			break;
		// End:0x109
		case 16:
		// End:0x110
		case 32:
		// End:0x11D
		case 48:
			return 12;
			// End:0x2BB
			break;
		// End:0x12A
		case 8:
			return 13;
			// End:0x2BB
			break;
		// End:0x13A
		case 1048576:
			return 14;
			// End:0x2BB
			break;
		// End:0x14A
		case 4194304:
			return 15;
			// End:0x2BB
			break;
		// End:0x15A
		case 2097152:
			return 16;
			// End:0x2BB
			break;
		// End:0x16C
		case 16 + 32:
			return 17;
			// End:0x2BB
			break;
		// End:0x17C
		case 536870912:
			return 18;
			// End:0x2BB
			break;
		// End:0x18C
		case 1073741824:
			return 19;
			// End:0x2BB
			break;
		// End:0x193
		case 128:
		// End:0x19D
		case 256:
		// End:0x1F3
		case 16384:
			// End:0x1DA
			if(EItemType(iInfo.ItemType) == EItemType.ITEM_ARMOR || iInfo.ItemType == EItemType.ITEM_ACCESSARY)
			{
				return 20;
			}
			// End:0x1F0
			if(IsSigilArmor(iInfo.Id))
			{
				return 21;
			}
			// End:0x2BB
			break;
		// End:0x1FF
		case 1:
			return 22;
			// End:0x2BB
			break;
		// End:0x20F
		case 8192:
			return 23;
			// End:0x2BB
			break;
		// End:0x21F
		case 268435456:
			return 24;
			// End:0x2BB
			break;
		// End:0x229
		case 65536:
		// End:0x233
		case 262144:
		// End:0x243
		case 524288:
			return 25;
			// End:0x2BB
			break;
		// End:0x253
		case 131072:
			return 26;
			// End:0x2BB
			break;
		// End:0x25D
		case 12582912:
		// End:0x267
		case 50331648:
		// End:0x277
		case 201326592:
			return 100;
		// End:0x289
		case 512:
			return 100;
		// End:0xFFFF
		default:
			switch(EEtcItemType(iInfo.EtcItemType))
			{
				// End:0x29F
				case ITEME_ENCHT_ATTR_RUNE:
				// End:0x2AA
				case ITEME_ENCHT_ATTRT_RUNE_SELECT:
					return 27;
				// End:0x2B5
				case ITEME_PET_COLLAR:
					return 28;
			}
	}
	return 100;
}

function array<ItemInfo> pushItemInfo(array<ItemInfo> itemList, ItemInfo info)
{
	itemList.Length = itemList.Length + 1;
	itemList[itemList.Length - 1] = info;
	return itemList;
}

function array<itemInfo> pushItemInfoArray(array<itemInfo> itemList, array<ItemInfo> pushList)
{
	local int i ;
	local int itemListRen;
	itemListRen = itemList.Length;
	itemList.Length = itemListRen + pushList.Length ;
	for(i = 0 ; i < pushList.Length ; i++)
	{
		itemList[ itemListRen + i ] = pushList[i] ;//  = pushItemInfo(itemList, pushList[i]);		
	}
	return itemList;
}

//************************************************************************************************************************************************
// ItemА©µµїм , ѕЖАМЕЫ Б¤·Д ±вґЙ - АОєҐЕдё®їЎј­ »©їНј­ Б» јцБ¤ЗФ
//************************************************************************************************************************************************
function array<itemInfo> SortItemArray(array<ItemInfo> itemList)
{
	local int i ;
	local int itemNum ;
	local ItemInfo item ;
	local EItemType eItemType ;

	local Array<ItemInfo> AssetList ;
	local Array<ItemInfo> WeaponList ;
	local Array<ItemInfo> ArmorList ;
	local Array<ItemInfo> AccesaryList ;
	local Array<ItemInfo> EtcItemList ;

	// etc item ±ёєР
	local Array<ItemInfo> AncientCrystalEnchantAmList;
	local Array<ItemInfo> AncientCrystalEnchantWpList;
	local Array<ItemInfo> CrystalEnchantAmList;
	local Array<ItemInfo> CrystalEnchantWpList;

	local Array<ItemInfo> BlessEnchantAmList;
	local Array<ItemInfo> BlessEnchantWpList;

	local Array<ItemInfo> EnchantAmList;
	local Array<ItemInfo> EnchantWpList;

	local Array<ItemInfo> IncEnchantPropAmList;
	local Array<ItemInfo> IncEnchantPropWpList;

	local Array<ItemInfo> PotionList;
	local Array<ItemInfo> ElixirList;

	local Array<ItemInfo> ArrowList;
	local Array<ItemInfo> BoltList;

	local Array<ItemInfo> RecipeList;

	local Array<ItemInfo> ArtifactList;

	itemNum = itemList.Length;
	
	// 1. ѕЖАМЕЫµйА» Бѕ·щє°·О ±ёєР
	for(i = 0; i < itemNum; ++i)
	{
		item = itemList[i];

		if(!IsValidItemID(item.ID))
		{
			continue;
		}

		eItemType = EItemType(item.ItemType);

		switch(eItemType)
		{
		case ITEM_ASSET:
			AssetList = pushItemInfo(AssetList, item);
			break;

		case ITEM_WEAPON:			
			WeaponList = pushItemInfo(WeaponList, item);			
			break;

		case ITEM_ARMOR:
			ArmorList = pushItemInfo(ArmorList, item);			
			break;

		case ITEM_ACCESSARY:
			if(IsArtifactRuneItem(item))
			{
				ArtifactList = pushItemInfo(ArtifactList, item);
				Debug("item  --> " @item.Name);
			}
			else
			{
				AccesaryList = pushItemInfo(AccesaryList, item);
			}
			break;

		case ITEM_ETCITEM:
			// testInt = item.EtcItemType;
			//debug(int(item.EtcItemType));
			switch(EEtcItemType(item.EtcItemType))
			{
			case ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM:
				AncientCrystalEnchantAmList = pushItemInfo(AncientCrystalEnchantAmList, item);					
				break;
			case ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP:
				AncientCrystalEnchantWpList = pushItemInfo(AncientCrystalEnchantWpList, item);
				break;
			case ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_AM:
				CrystalEnchantAmList = pushItemInfo(CrystalEnchantAmList, item);													
				break;
			case ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_WP:
				CrystalEnchantWpList = pushItemInfo(CrystalEnchantWpList, item);																	
				break;
			case ITEME_BLESS_ENCHT_AM:
				BlessEnchantAmList = pushItemInfo(BlessEnchantAmList, item);																					
				break;
			case ITEME_BLESS_ENCHT_WP:
				BlessEnchantWpList = pushItemInfo(BlessEnchantWpList, item);																									
				break;
			case ITEME_ENCHT_AM:
				EnchantAmList = pushItemInfo(EnchantAmList, item);																									
				break;
			case ITEME_ENCHT_WP:
				EnchantWpList = pushItemInfo(EnchantWpList, item);																													
				break;
			case ITEME_ENCHT_ATTR_INC_PROP_ENCHT_AM:
				IncEnchantPropAmList = pushItemInfo(IncEnchantPropAmList, item);	
				break;
			case ITEME_ENCHT_ATTR_INC_PROP_ENCHT_WP:
				IncEnchantPropWpList = pushItemInfo(IncEnchantPropWpList, item);	
				break;
			case ITEME_POTION:
				PotionList = pushItemInfo(PotionList, item);					
				break;
			case ITEME_ELIXIR:
				ElixirList = pushItemInfo(ElixirList, item);									
				break;
			case ITEME_ARROW:
				ArrowList = pushItemInfo(ArrowList, item);					
				break;
			case ITEME_BOLT:
				BoltList = pushItemInfo(BoltList, item);
				break;
			case ITEME_RECIPE:
				RecipeList = pushItemInfo(RecipeList, item);				
				break;
			default:
				EtcItemList = pushItemInfo(EtcItemList, item);					
				break;
			}
			break;

		default:
			EtcItemList = pushItemInfo(EtcItemList, item);		
			break;
		}
	}

	// 2. ±ёєР µИ ѕЖАМЕЫµйА» °ў ё®ЅєЖ® ґз DP јшАё·О Б¤·Д	
	AssetList = sortByName(AssetList);
	WeaponList = sortByName(WeaponList);
	ArmorList = sortByName(ArmorList);
	AccesaryList = sortByName(AccesaryList);
	AncientCrystalEnchantAmList = sortByName(AncientCrystalEnchantAmList);
	AncientCrystalEnchantWpList = sortByName(AncientCrystalEnchantWpList);
	CrystalEnchantAmList = sortByName(CrystalEnchantAmList);
	CrystalEnchantWpList = sortByName(CrystalEnchantWpList);
	BlessEnchantAmList = sortByName(BlessEnchantAmList);
	BlessEnchantWpList = sortByName(BlessEnchantWpList);
	EnchantAmList = sortByName(EnchantAmList);
	EnchantWpList = sortByName(EnchantWpList);
	IncEnchantPropAmList = sortByName(IncEnchantPropAmList);		
	IncEnchantPropWpList = sortByName(IncEnchantPropWpList);			
	PotionList = sortByName(PotionList);
	ElixirList = sortByName(ElixirList);
	ArrowList = sortByName(ArrowList);
	BoltList = sortByName(BoltList);
	RecipeList = sortByName(RecipeList);	
	EtcItemList = sortByName(EtcItemList);
	
	// ArtifactList = 

	// 3. јшј­ґл·О ґЩЅГ АФ·В 	
	itemList.Remove(0, itemList.Length);
	itemList = pushItemInfoArray(itemList, AssetList);	
	itemList = pushItemInfoArray(itemList, WeaponList);	
	itemList = pushItemInfoArray(itemList, ArmorList);	
	itemList = pushItemInfoArray(itemList, AccesaryList);	
	itemList = pushItemInfoArray(itemList, AncientCrystalEnchantAmList);	
	itemList = pushItemInfoArray(itemList, AncientCrystalEnchantWpList);	
	itemList = pushItemInfoArray(itemList, CrystalEnchantAmList);
	itemList = pushItemInfoArray(itemList, CrystalEnchantWpList);
	itemList = pushItemInfoArray(itemList, BlessEnchantAmList);
	itemList = pushItemInfoArray(itemList, BlessEnchantWpList);
	itemList = pushItemInfoArray(itemList, EnchantAmList);
	itemList = pushItemInfoArray(itemList, EnchantWpList);
	itemList = pushItemInfoArray(itemList, IncEnchantPropAmList);
	itemList = pushItemInfoArray(itemList, IncEnchantPropWpList);
	itemList = pushItemInfoArray(itemList, PotionList);
	itemList = pushItemInfoArray(itemList, ElixirList);
	itemList = pushItemInfoArray(itemList, ArrowList);
	itemList = pushItemInfoArray(itemList, BoltList);
	itemList = pushItemInfoArray(itemList, RecipeList);
	itemList = pushItemInfoArray(itemList, EtcItemList);

	itemList = pushItemInfoArray(itemList, ArtifactList); // ѕЖЖјЖСЖ®ґВ °ЎАе ѕЖ·Ў

	return itemList;
}

//************************************************************************************************************************************************
// ItemА©µµїм , ѕЖАМЕЫ Б¤·Д ±вґЙ - АОєҐЕдё®їЎј­ »©їНј­ Б» јцБ¤ЗФ
//************************************************************************************************************************************************
function SortItemLive(ItemWindowHandle m_topList)
{
	local int i ;
	local int invenLimit;
	local ItemInfo item;
	local EItemType eItemType;
	
	local int nextSlot;

	local Array<ItemInfo> AssetList;
	local Array<ItemInfo> WeaponList;
	local Array<ItemInfo> ArmorList;
	local Array<ItemInfo> AccesaryList;
	local Array<ItemInfo> EtcItemList;

	// etc item ±ёєР
	local Array<ItemInfo> AncientCrystalEnchantAmList;
	local Array<ItemInfo> AncientCrystalEnchantWpList;
	local Array<ItemInfo> CrystalEnchantAmList;
	local Array<ItemInfo> CrystalEnchantWpList;

	local Array<ItemInfo> BlessEnchantAmList;
	local Array<ItemInfo> BlessEnchantWpList;

	local Array<ItemInfo> EnchantAmList;
	local Array<ItemInfo> EnchantWpList;

	local Array<ItemInfo> IncEnchantPropAmList;
	local Array<ItemInfo> IncEnchantPropWpList;

	local Array<ItemInfo> PotionList;
	local Array<ItemInfo> ElixirList;

	local Array<ItemInfo> ArrowList;
	local Array<ItemInfo> BoltList;

	local Array<ItemInfo> RecipeList;

	invenLimit = m_topList.GetItemNum();	
	
	// 1. ѕЖАМЕЫµйА» Бѕ·щє°·О ±ёєР
	for(i = 0; i < invenLimit ; ++i)
	{
		m_topList.GetItem(i, item);

		if(!IsValidItemID(item.ID))
		{
			continue;
		}

		eItemType = EItemType(item.ItemType);

		switch(eItemType)
		{
		case ITEM_ASSET:
			AssetList = pushItemInfo(AssetList, item);
			break;

		case ITEM_WEAPON:			
			WeaponList = pushItemInfo(WeaponList, item);
			break;

		case ITEM_ARMOR:
			ArmorList = pushItemInfo(ArmorList, item);
			break;

		case ITEM_ACCESSARY:
			AccesaryList = pushItemInfo(AccesaryList, item);
			break;

		case ITEM_ETCITEM:
			// testInt = item.EtcItemType;
			//debug(int(item.EtcItemType));
			switch(EEtcItemType(item.EtcItemType))
			{
			case ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM:
				AncientCrystalEnchantAmList = pushItemInfo(AncientCrystalEnchantAmList, item);				
				break;
			case ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP:
				AncientCrystalEnchantWpList = pushItemInfo(AncientCrystalEnchantWpList, item);
				break;
			case ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_AM:
				CrystalEnchantAmList = pushItemInfo(CrystalEnchantAmList, item);													
				break;
			case ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_WP:
				CrystalEnchantWpList = pushItemInfo(CrystalEnchantWpList, item);																	
				break;
			case ITEME_BLESS_ENCHT_AM:
				BlessEnchantAmList = pushItemInfo(BlessEnchantAmList, item);																					
				break;
			case ITEME_BLESS_ENCHT_WP:
				BlessEnchantWpList = pushItemInfo(BlessEnchantWpList, item);																									
				break;
			case ITEME_ENCHT_AM:
				EnchantAmList = pushItemInfo(EnchantAmList, item);																									
				break;
			case ITEME_ENCHT_WP:
				EnchantWpList = pushItemInfo(EnchantWpList, item);																													
				break;
			case ITEME_ENCHT_ATTR_INC_PROP_ENCHT_AM:
				IncEnchantPropAmList = pushItemInfo(IncEnchantPropAmList, item);	
				break;
			case ITEME_ENCHT_ATTR_INC_PROP_ENCHT_WP:
				IncEnchantPropWpList = pushItemInfo(IncEnchantPropWpList, item);	
				break;
			case ITEME_POTION:
				PotionList = pushItemInfo(PotionList, item);					
				break;
			case ITEME_ELIXIR:
				ElixirList = pushItemInfo(ElixirList, item);									
				break;
			case ITEME_ARROW:
				ArrowList = pushItemInfo(ArrowList, item);					
				break;
			case ITEME_BOLT:
				BoltList = pushItemInfo(BoltList, item);
				break;
			case ITEME_RECIPE:
				RecipeList = pushItemInfo(RecipeList, item);				
				break;
			default:
				EtcItemList = pushItemInfo(EtcItemList, item);					
				break;
			}
			break;

		default:
			EtcItemList = pushItemInfo(EtcItemList, item);		
			break;
		}
	}

	// 2. ±ёєР µИ ѕЖАМЕЫµйА» °ў ё®ЅєЖ® ґз №«°ФјшАё·О Б¤·Д	
	AssetList = sortByName(AssetList);	
	WeaponList = sortByName(WeaponList);
	ArmorList = sortByName(ArmorList);	

	AccesaryList = sortByName(AccesaryList);

	AncientCrystalEnchantAmList = sortByName(AncientCrystalEnchantAmList);
	AncientCrystalEnchantWpList = sortByName(AncientCrystalEnchantWpList);
	CrystalEnchantAmList = sortByName(CrystalEnchantAmList);
	CrystalEnchantWpList = sortByName(CrystalEnchantWpList);
	BlessEnchantAmList = sortByName(BlessEnchantAmList);
	BlessEnchantWpList = sortByName(BlessEnchantWpList);
	EnchantAmList = sortByName(EnchantAmList);
	EnchantWpList = sortByName(EnchantWpList);		
	IncEnchantPropAmList = sortByName(IncEnchantPropAmList);		
	IncEnchantPropWpList = sortByName(IncEnchantPropWpList);			
	PotionList = sortByName(PotionList);
	ElixirList = sortByName(ElixirList);
	ArrowList = sortByName(ArrowList);
	BoltList = sortByName(BoltList);
	RecipeList = sortByName(RecipeList);	
	EtcItemList = sortByName(EtcItemList);	
	
	//Debug("SortItem" @ AssetList.Length @ WeaponList.Length );
	// 3. АОєҐїЎ ґЩЅГ »рАФ
	m_topList.Clear();

	ItemboxUpdate(m_topList, invenLimit);
	
	for(i = 0; i < AssetList.Length; ++i)
	{
		m_topList.SetItem(nextSlot + i, AssetList[i]);
	}

	nextSlot = nextSlot + AssetList.Length;

	for(i = 0; i < WeaponList.Length; ++i)
	{
		m_topList.SetItem(nextSlot + i, WeaponList[i]);
	}

	nextSlot = nextSlot + WeaponList.Length;

	for(i = 0; i < ArmorList.Length; ++i)
	{
		m_topList.SetItem(nextSlot + i, ArmorList[i]);
	}
	nextSlot = nextSlot + ArmorList.Length;

	for(i = 0; i < AccesaryList.Length; ++i)
	{
		m_topList.SetItem(nextSlot + i, AccesaryList[i]);
	}
	nextSlot = nextSlot + AccesaryList.Length;

	for(i = 0; i < AncientCrystalEnchantAmList.Length; ++i)
	{
		m_topList.SetItem(nextSlot + i, AncientCrystalEnchantAmList[i]);
	}
	nextSlot = nextSlot + AncientCrystalEnchantAmList.Length;

	for(i = 0; i < AncientCrystalEnchantWpList.Length; ++i)
	{
		m_topList.SetItem(nextSlot + i, AncientCrystalEnchantWpList[i]);
	}
	nextSlot = nextSlot + AncientCrystalEnchantWpList.Length;

	for(i = 0; i < CrystalEnchantAmList.Length; ++i)
	{
		m_topList.SetItem(nextSlot + i, CrystalEnchantAmList[i]);
	}
	nextSlot = nextSlot + CrystalEnchantAmList.Length;

	for(i = 0; i < CrystalEnchantWpList.Length; ++i)
	{
		m_topList.SetItem(nextSlot + i, CrystalEnchantWpList[i]);
	}
	nextSlot = nextSlot + CrystalEnchantWpList.Length;

	for(i = 0; i < BlessEnchantAmList.Length; ++i)
	{
		m_topList.SetItem(nextSlot + i, BlessEnchantAmList[i]);
	}
	nextSlot = nextSlot + BlessEnchantAmList.Length;

	for(i = 0; i < BlessEnchantWpList.Length ; ++i)
	{
		m_topList.SetItem(nextSlot + i, BlessEnchantWpList[i]);
	}
	nextSlot = nextSlot + BlessEnchantWpList.Length;

	for(i = 0; i < EnchantAmList.Length ; ++i)
	{
		m_topList.SetItem(nextSlot + i, EnchantAmList[i]);
	}
	nextSlot = nextSlot + EnchantAmList.Length;

	for(i = 0; i < EnchantWpList.Length ; ++i)
	{
		m_topList.SetItem(nextSlot + i, EnchantWpList[i]);
	}
	nextSlot = nextSlot + EnchantWpList.Length;

	for(i = 0; i < IncEnchantPropAmList.Length ; ++i)
	{
		m_topList.SetItem(nextSlot + i, IncEnchantPropAmList[i]);
	}
	nextSlot = nextSlot + IncEnchantPropAmList.Length;

	for(i = 0; i < IncEnchantPropWpList.Length ; ++i)
	{
		m_topList.SetItem(nextSlot + i, IncEnchantPropWpList[i]);
	}
	nextSlot = nextSlot + IncEnchantPropWpList.Length;

	for(i = 0; i < PotionList.Length ; ++i)
	{
		m_topList.SetItem(nextSlot + i, PotionList[i]);
	}
	nextSlot = nextSlot + PotionList.Length;

	for(i = 0; i < ElixirList.Length ; ++i)
	{
		m_topList.SetItem(nextSlot + i, ElixirList[i]);
	}
	nextSlot = nextSlot + ElixirList.Length;

	for(i = 0; i < ArrowList.Length ; ++i)
	{
		m_topList.SetItem(nextSlot + i, ArrowList[i]);
	}
	nextSlot = nextSlot + ArrowList.Length;

	for(i = 0; i < BoltList.Length ; ++i)
	{
		m_topList.SetItem(nextSlot + i, BoltList[i]);
	}
	nextSlot = nextSlot + BoltList.Length;

	for(i = 0; i < RecipeList.Length ; ++i)
	{
		m_topList.SetItem(nextSlot + i, RecipeList[i]);
	}
	nextSlot = nextSlot + RecipeList.Length;

	for(i = 0; i < EtcItemList.Length ; ++i)
	{
		m_topList.SetItem(nextSlot + i, EtcItemList[i]);
	}

	// m_NormalInvenCount = nextSlot;

	// debug("[Sorting Inven Item]" $ nextSlot $ "items sorted complete!!");
}

function SortItemClassic(ItemWindowHandle m_topList)
{
	local int i;
	local int InvenLimit;
	local ItemInfo item;
	local array<ItemInfo> ItemListAll;

	InvenLimit = m_topList.GetItemNum();
	
	for(i = 0;i < InvenLimit; i++)
	{
		m_topList.GetItem(i,item);
		if(!IsValidItemID(item.Id))
			continue;
		ItemListAll = pushItemInfo(ItemListAll,item);
	}
	// End:0xC5
	if(ItemListAll.Length > 0)
	{
		ItemListAll.Sort(SortByClassIDDelegate);
		ItemListAll = sortByName(ItemListAll);
		ItemListAll.Sort(SortByCrystalTypeDelegate);
		ItemListAll.Sort(SortByItemTypeDelegate);
		ItemListAll.Sort(SortBySortOrderDelegate);
	}

	m_topList.Clear();
	ItemboxUpdate(m_topList,InvenLimit);

	for(i = 0;i < ItemListAll.Length; i++)
	{
		m_topList.SetItem(i, ItemListAll[i]);
	}
}

function SortItem(ItemWindowHandle m_topList)
{
	// End:0x21
	if(getInstanceUIData().getIsClassicServer())
	{
		SortItemClassic(m_topList);		
	}
	else
	{
		SortItemLive(m_topList);
	}
}

function int FindItemByClassIDWithFilter(int ClassID, out array<ItemInfo> itemInfoArray, optional EItemLockedCheckType LockType, optional bool bUseExceptionEnsoul, optional int filterNum)
{
	local int i;
	local int ItemCount;
	local array<ItemInfo> tmpItemArray;
	local array<ItemInfo> invenItemArray;

	Class'UIDATA_INVENTORY'.static.GetItemByScriptFilter(filterNum,invenItemArray);
	ItemCount = 0;

	for(i = 0;i < invenItemArray.Length; i++)
	{
		if(invenItemArray[i].Id.ClassID == ClassID)
		{
			ItemCount++;
			tmpItemArray[tmpItemArray.Length] = invenItemArray[i];
		}
	}

	if(LockType == 0)
		return ItemCount;

	for(i = 0;i < tmpItemArray.Length; i++)
	{
		if(LockType == 1 && tmpItemArray[i].bSecurityLock || LockType == 2 &&	!tmpItemArray[i].bSecurityLock)
		{
			if(bUseExceptionEnsoul)
			{
				if(hasEnsoulOption(tmpItemArray[i]))
					continue;
			}
			itemInfoArray.Length = itemInfoArray.Length + 1;
			itemInfoArray[itemInfoArray.Length - 1] = tmpItemArray[i];
		}
	}
	return itemInfoArray.Length;
}

//************************************************************************************************************************************************
// classID ·О ѕЖАМЕЫА» ГЈАЅ, єААО ЕёАФАё·О ГјЕ© 
// bUseExceptionEnsoul : ·й(БэИҐ)Иї°ъ°Ў АЦґЩёй Б¦їЬГіё®
//************************************************************************************************************************************************
function int FindItemByClassID(int classID, out array<ItemInfo> itemInfoArray, optional EItemLockedCheckType lockType, optional bool bUseExceptionEnsoul)
{
	local int i, itemCount ;
	local array<ItemInfo> tmpItemArray;
	
	itemCount = class'UIDATA_INVENTORY'.static.FindItemByClassID(classID, tmpItemArray);

	if(lockType == EItemLockedCheckType.ANY)return  itemCount;

	for(i = 0  ; i < itemCount ; i ++)
	{			
		// locked ёс·П ёё №ЮАЅ, // unlocked ёс·П ёё №ЮАЅ. // locked ё¦ Б¦їЬ, // unlocked ё¦ Б¦їЬ
		if((lockType == EItemLockedCheckType.LOCK && tmpItemArray[i].bSecurityLock)|| 
			(lockType == EItemLockedCheckType.UNLOCK && !tmpItemArray[i].bSecurityLock))
		{	
			// БэИҐ(·й)АМ АыїлµЗѕо АЦАёёй Б¦їЬ.
			if (bUseExceptionEnsoul)
			{				
				if(hasEnsoulOption(tmpItemArray[i]))
				{
					//Debug("Б¦їЬ:" @ tmpItemArray[i].name);
					continue;
				}
			}

			itemInfoArray.Length = itemInfoArray.Length + 1 ;
			itemInfoArray [itemInfoArray.Length -1 ] = tmpItemArray[i];

		}
	}

	return itemInfoArray.Length ;
}

function ItemboxUpdate(ItemWindowHandle hItemWnd, int iInvenLimit)
{
	local int iCount;
	local int iItemCount;
	local int iAddedCount;
	local int iDeletedCount;
	local ItemInfo kClearItem;
	local ItemInfo kCurItem;
	
	kClearItem.IconName = "L2ui_ct1.emptyBtn";
	ClearItemID(kClearItem.ID);
	iItemCount = hItemWnd.GetItemNum();

	if(iItemCount < iInvenLimit)
	{
		IAddedCount = iInvenLimit - iItemCount;
		for(iCount=0; iCount<iAddedCount; iCount++)
		{
			hItemWnd.AddItem(kClearItem);
		}
	}
	else if(iItemCount > iInvenLimit)
	{
		iDeletedCount = iItemCount - iInvenLimit;
		for(iCount = hItemWnd.GetItemNum()- 1; iCount >= 0; iCount--)
		{
			if(iDeletedCount > 0)
			{
				hItemWnd.GetItem(iCount, kCurItem);
				if(!IsValidItemID(kCurItem.ID))
				{
					hItemWnd.DeleteItem(iCount);
					iDeletedCount--;
				}
				if(iDeletedCount <= 0)
				{
					break;
				}					
			}
		}
	}
}

/** ±вє»АыАё·О ЗШґз ГўАЗ їАёҐВК, АЪё®°Ў ѕшґЩёй їЮВКАё·О іЄїАµµ·П ЗПґВ ЗФјц */
function windowAnchorToSide(WindowHandle mainWindow, WindowHandle subWindow, optional int addX, optional int addY)
{
	local RECT pRect, cRect;
	local int currentWidth; 
	local int currentHeight;
	local int setX, setY;
	
	GetCurrentResolution(currentWidth, currentHeight);
	
	pRect = mainWindow.GetRect();
	cRect = subWindow.GetRect();
	
	// °Ў·О ЗШ»уµµ°Ў ј­єк ГўєёґЩ ДїѕЯёё АЫµї ЅГЕІґЩ.
	if(currentWidth > cRect.nWidth)
	{
		setX = pRect.nx +(pRect.nWidth)+ 5;
		setY = pRect.ny;
		
		// И­ёйїЎ іСѕо °ЎБц ѕКµµ·П єёБ¤ Гіё® 
		if(setX > currentWidth  - cRect.nWidth)
		{
			//	И­ёй БЯѕУїЎ іЄїАµµ·П јјЖГ
			subWindow.SetAnchor(mainWindow.GetWindowName(), "TopLeft", "TopLeft", -(cRect.nWidth + addX), addY);		
		}
		else
		{
			//	И­ёй БЯѕУїЎ іЄїАµµ·П јјЖГ
			subWindow.SetAnchor(mainWindow.GetWindowName(), "TopLeft", "TopLeft",(pRect.nWidth + addX), addY);		
		}
		// if(setY > currentHeight - cRect.nHeight)setY = currentHeight - cRect.nHeight;
		
	}
}

/***
 *  А©µµїм А§ДЎ XY БВЗҐ ЅМЕ© ЗП±в 
 *  syncWindowLoc("Inventory", "aaWnd,bbWnd,ccWnd") --> Inventory А©µµїмАЗ БВЗҐ·О ЗШґз А©µµїмµй АМµї
 **/
function fixWindowLocOverResolution(string currentWindowName, optional int addX, optional int addY)
{
	local RECT pRect;
	local int currentWidth; 
	local int currentHeight;
	local int setX, setY;

	GetCurrentResolution(currentWidth, currentHeight);
	pRect = GetWindowHandle(currentWindowName).GetRect();
	setX = pRect.nX;
	setY = pRect.nY;

	// °Ў·О
	if(currentWidth > pRect.nWidth)
	{
		// И­ёйїЎ іСѕо °ЎБц ѕКµµ·П єёБ¤ Гіё® 
		if(pRect.nx + (pRect.nWidth) > currentWidth)
		{
			setX = currentWidth - pRect.nWidth - addX;
		}
		else if(pRect.nx < 0)
		{
			setX = addX;
		}
	}
 	
	// јј·О
	if(currentHeight > pRect.nHeight)
	{
		
		// И­ёйїЎ іСѕо °ЎБц ѕКµµ·П єёБ¤ Гіё® 
		if(pRect.ny +(pRect.nHeight)> currentHeight)
		{
			setY = currentHeight - pRect.nHeight - addY;
		}
		else if(pRect.ny < 0)
		{
			setY = 0 - addY;
		}
	}

	GetWindowHandle(currentWindowName).MoveTo(setX, setY); 
}


/***
 *  А©µµїм А§ДЎ XY БВЗҐ ЅМЕ© ЗП±в 
 *  syncWindowLoc("Inventory", "aaWnd,bbWnd,ccWnd") --> Inventory А©µµїмАЗ БВЗҐ·О ЗШґз А©µµїмµй АМµї
 **/
function syncWindowLoc(string currentWindowName, string windowNamesStr, optional int addX, optional int addY)
{
	local array<string>	windowNameArray;
	local Rect tempRect;
	local int i;

	Split(windowNamesStr, ",", windowNameArray);

	if(windowNameArray.Length <= 1)
	{
		// , °Ў ѕшґВ °жїм¶уёй..
		windowNameArray[0] = windowNamesStr;
	}		

	tempRect = GetWindowHandle(currentWindowName).GetRect();

	//Debug("currentWindowName" @ currentWindowName);
	//Debug("tempRect" @ tempRect.nX);
	//Debug("tempRect" @ tempRect.nY);

	for(i = 0; i < windowNameArray.Length; i++)
	{
		if (currentWindowName != windowNameArray[i])
			GetWindowHandle(windowNameArray[i]).MoveTo(tempRect.nX + addX, tempRect.nY + addY);
	}
}

/***
 *  А©µµїм А§ДЎ XY БВЗҐ ЅМЕ© ЗП±в 
 *  syncWindowLoc("aaWnd,bbWnd,ccWnd") --> ЗцАз И­ёйїЎ іЄїН АЦґВ°НА» ГЈѕЖј­ ±Ч°Й ±вБШАё·О.. 
 **/
function syncWindowLocAuto(string windowNamesStr)
{
	local array<string>	windowNameArray;
	local Rect tempRect;
	local int i;

	local bool bFindWindow;

	Split(windowNamesStr, ",", windowNameArray);

	// , °Ў ѕшґВ °жїм¶уёй..
	if(windowNameArray.Length <= 1)windowNameArray[0] = windowNamesStr;
	
	// ЗцАз ї­·Б АЦґВ А©µµїмё¦ ГЈ°н
	for(i = 0; i < windowNameArray.Length; i++)
	{
		if (GetWindowHandle(windowNameArray[i]).IsShowWindow())
		{
			tempRect = GetWindowHandle(windowNameArray[i]).GetRect();
			bFindWindow = true;
			break;			
		}
	}

	// ї­·Б АЦґВ °НА» №Я°ЯЗС °жїмёё..
	if(bFindWindow)
	{
		// БВЗҐ АМµї Аыїл
		for(i = 0; i < windowNameArray.Length; i++)GetWindowHandle(windowNameArray[i]).MoveTo(tempRect.nX, tempRect.nY);
	}
}

/***
 *  А©µµїм А§ДЎ XY БВЗҐ ЅМЕ© ЗП±в 
 *  syncWindowLoc("Inventory", "aaWnd,bbWnd,ccWnd") --> Inventory А©µµїмАЗ БВЗҐ·О ЗШґз А©µµїмµй АМµї
 **/
function hideGroupWindow(string currentWindowName, string windowNamesStr)
{
	local array<string>	windowNameArray;
	local int i;

	Split(windowNamesStr, ",", windowNameArray);

	if(windowNameArray.Length <= 1)
	{
		// , °Ў ѕшґВ °жїм¶уёй..
		windowNameArray[0] = windowNamesStr;
	}		

	for(i = 0; i < windowNameArray.Length; i++)
	{
		// Debug("conversationRelationWndNames" @ windowNameArray[i]);
		if (currentWindowName != windowNameArray[i])
			GetWindowHandle(windowNameArray[i]).HideWindow();
	}
}


/***
 *  ·зЖГ ЕёАФїЎ µыёҐ·зЖГ ЅєЖ®ёµ №ЭИЇ 
 **/
function string getLootingString(int ID)
{		
	switch(ID)
	{
		case 0:
			return GetSystemString(487);
			break;
		case 1:
			return GetSystemString(488);
			break;
		case 2:
			return GetSystemString(798);
			break;
		case 3:
			return GetSystemString(799);
			break;
		case 4:
			return GetSystemString(800);
			break;
	}
	
}

//----------------------------------------------------------------------------------------------------------------------------------------
// XML UIДБЖ®·С єёБ¶ АЇЖї 
//----------------------------------------------------------------------------------------------------------------------------------------

/**
 *  ѕЖАМЕЫ А©µµїм ДБЖ®·С °ЈїЎ ѕЖАМЕЫА» АМµї ЅГЕ°ґВ ЗФјц
 *  ѕЖАМЕЫА» itemWnd1 -> itemWnd2 ·О АМµї
 *  
  **/
function ItemWIndow_ItemMoveByIndex(ItemWindowHandle itemWnd1, ItemWindowHandle itemWnd2, int itemWnd1_Index, optional bool useAddStackableItem)
{
	local ItemInfo tempInfo, tmItem;
	local int itemCount, i;
	local bool hasItem;
	
	itemWnd1.GetItem(itemWnd1_Index, tempInfo);

	if(tempInfo.Id.ClassID > 0)
	{
		// јц·®јє ѕЖАМЕЫАМ¶уёй..
		if(IsStackableItem(tempInfo.ConsumeType)&& useAddStackableItem)
		{			
			itemCount = itemWnd2.GetItemNum();
			
			for(i = 0; i < itemCount; i++)
			{
				if(itemWnd2.GetItem(i, tmItem))
				{
					// °°Ає ID°Ў АЦАёёй ЗХГД БШґЩ.
					if(tempInfo.Id.ClassID == tmItem.Id.ClassID)
					{
						tmItem.ItemNum = tempInfo.ItemNum + tmItem.itemNum;
						itemWnd2.SetItem(i, tmItem);
						hasItem = true;
						break;
					}
				}
			}

			// ёёѕа ѕЖАМЕЫАМ БёАз ЗПБц ѕКґВґЩёй ±ЧіЙ іЦґВґЩ.
			if(hasItem == false)itemWnd2.AddItem(tempInfo);
		}
		else
		{
			itemWnd2.AddItem(tempInfo);
		}

		itemWnd1.DeleteItem(itemWnd1_Index);
	}
	else
	{
		Debug("Error: L2Util ItemWIndow_ItemMoveByIndex -> Wrong Index ");
	}
}

/**
 *  ѕЖАМЕЫ А©µµїм ДБЖ®·С °ЈїЎ ѕЖАМЕЫА» АМµї ЅГЕ°ґВ ЗФјц
 *  ѕЖАМЕЫА» itemWnd1 -> itemWnd2 ·О АМµї
 *  
 *  [јц·®јє ѕЖАМЕЫАМ ѕЖґС °жїм »зїл]
 **/

function int ItemWIndow_ItemMoveByItemID(ItemWindowHandle itemWnd1, ItemWindowHandle itemWnd2, ItemID idInfo)
{
	local ItemInfo tempInfo;
	local int index;

	index = ItemWIndow_searchItemByItemID(itemWnd1, idInfo);

	// index ґВ 0єОЕН ЅГАЫ, -1Ає ѕЖАМЕЫ ѕшАЅ.
	if(index > -1)
	{
		itemWnd1.GetItem(index, tempInfo);
		itemWnd2.AddItem(tempInfo);
		itemWnd1.DeleteItem(index);
	}

	return index;
}

/**
 *   ѕЖАМЕЫ А©µµїмїЎј­ ѕЖАМЕЫ indexё¦ °Л»цЗПї© ё®ЕПЗСґЩ.
 *   ѕшАёёй -1А» ё®ЕП
 **/
function int ItemWIndow_searchItemByItemID(ItemWindowHandle itemWnd, ItemID IdInfo)
{
	local int i, returnN;
	local ItemInfo tempInfo;

	// ѕшАёёй -1А» ё®ЕП
	returnN = -1;

	for(i = 0; i < itemWnd.GetItemNum(); i++)
	{
		itemWnd.GetItem(i, tempInfo);

		// °°Ає ID°Ў АЦґЩёй..
		if(IdInfo == tempInfo.Id)
		{
			returnN = i;
			break;
		}
	}		

	return returnN;
}

/**
 *  ЕШЅєЖ® ЗКµеїЎ БцБ¤ЗС »зАМБоё¦ іСѕо°Ўёй .. А» іЎїЎ Вп°н ЕшЖБА» іЦѕоБЦґВ їЄИ°
 *  
 *  ex)
 *  util.textBox_setToolTipWithShortString(EnsoulDefaultWnd_WeaponName_TextBox);
 *  noSimpleTool ЕшЖБ »зїл ї©єО, trueёй »зїлѕИЗФ.
 **/
function textBox_setToolTipWithShortString(TextBoxHandle textBox, string context, optional int wTextField)
{
	local int textWidth, textHeight;
	local int wTextWidth, hTextHeight;

	textBox.GetWindowSize(wTextWidth, hTextHeight);

	GetTextSize(context, "GameDefault", textWidth, textHeight);

	if(textWidth > wTextWidth)
	{
		textBox.SetTooltipType("text");
		textBox.SetTooltipText(context);

		// №«±в АМё§ ЕШЅєЖ® ЗКµе Гв·В
		context = makeShortStringByPixel(context, (wTextWidth - 8) + wTextField, "..");
	}

	textBox.SetText(context);
}

function setWindowMoveToCenter(WindowHandle mainWindow)
{
	local Rect pRect;
	local int CurrentWidth, CurrentHeight, setX, setY;

	GetCurrentResolution(CurrentWidth, CurrentHeight);
	pRect = mainWindow.GetRect();
	CurrentWidth = CurrentWidth / 2;
	CurrentHeight = CurrentHeight / 2;
	setX = CurrentWidth - pRect.nWidth / 2;
	setY = CurrentHeight - pRect.nHeight / 2;
	mainWindow.MoveTo(setX, setY);
}

/** ёЮАО А©µµїмАЗ ј­єк А©µµїм°Ў БЯѕУїЎ А§ДЎ ЗПї© єёАМµµ·П ЗПґВ ЗФјц */
function childWindowMoveToCenter(WindowHandle mainWindow, WindowHandle subWindow)
{
	local RECT pRect, cRect;
	local int currentWidth; 
	local int currentHeight;
	local int setX, setY;
	
	GetCurrentResolution(currentWidth, currentHeight);
			
	pRect = mainWindow.GetRect();
	cRect = subWindow.GetRect();
			
	setX = pRect.nx +(pRect.nWidth  / 2)-(cRect.nWidth  / 2);
	setY = pRect.ny +(pRect.nHeight / 2)-(cRect.nHeight / 2);
		
	// И­ёйїЎ іСѕо °ЎБц ѕКµµ·П єёБ¤ Гіё® 
	if(setX > currentWidth  - cRect.nWidth)setX = currentWidth  - cRect.nWidth;
	else if(setX < 0)setX = 0;
	if(setY > currentHeight - cRect.nHeight)setY = currentHeight - cRect.nHeight;
	
	//	И­ёй БЯѕУїЎ іЄїАµµ·П јјЖГ
	subWindow.ClearAnchor();
	subWindow.Move(0, 0);
	subWindow.MoveTo(setX, setY);
}

/** ±вє»АыАё·О ЗШґз ГўАЗ їАёҐВК, АЪё®°Ў ѕшґЩёй їЮВКАё·О іЄїАµµ·П ЗПґВ ЗФјц */
function windowMoveToSide(WindowHandle mainWindow, WindowHandle subWindow)
{
	local RECT pRect, cRect;
	local int currentWidth; 
	local int currentHeight;
	local int setX, setY;
	
	GetCurrentResolution(currentWidth, currentHeight);
	
	pRect = mainWindow.GetRect();
	cRect = subWindow.GetRect();

	// °Ў·О ЗШ»уµµ°Ў ј­єк ГўєёґЩ ДїѕЯёё АЫµї ЅГЕІґЩ.
	if(currentWidth > cRect.nWidth)
	{
		setX = pRect.nx +(pRect.nWidth)+ 5;
		setY = pRect.ny;
		
		// И­ёйїЎ іСѕо °ЎБц ѕКµµ·П єёБ¤ Гіё® 
		if(setX > currentWidth  - cRect.nWidth)setX = pRect.nx -(cRect.nWidth + 5);
		else if(setX < 0)setX = 0;
		// if(setY > currentHeight - cRect.nHeight)setY = currentHeight - cRect.nHeight;
		
		//	И­ёй БЯѕУїЎ іЄїАµµ·П јјЖГ
		subWindow.ClearAnchor();
		subWindow.Move(0, 0);
		subWindow.MoveTo(setX, setY);			  
	}
}

function int getQuestLevelForID(int QuestID)
{
	local int i;
	local QuestTreeWnd scQuestTree;
	scQuestTree = QuestTreeWnd(GetScript("QuestTreeWnd"));
	// ё¶Бцё· ·№є§А» №ЮѕЖѕЯ ЗП№З·О µЪїЎј­ єОЕН µ№ё°ґЩ.
	for(i = scQuestTree.ArrQuest.Length - 1 ; i >= 0  ; i --)
	{
		if(QuestID == scQuestTree.ArrQuest[i].QuestID)
		{			
			return scQuestTree.ArrQuest[i].Level ;			
		}		
	}
	return 0 ;
}

function string GetCastleIconName(int castleID)
{
	switch(castleID)
	{
		// End:0x37
		case 1:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Gludio";
		// End:0x66
		case 2:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Dion";
		// End:0x96
		case 3:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Giran";
		// End:0xC5
		case 4:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Oren";
		// End:0xF4
		case 5:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Aden";
		// End:0x127
		case 6:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Innadril";
		// End:0x158
		case 7:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Godard";
		// End:0x187
		case 8:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Rune";
		// End:0x1BC
		case 9:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Shuttegart";
	}
	return "";
}

function string GetCastleMinIconName(int castleID)
{
	switch(castleID)
	{
		// End:0x3A
		case 3:
			return "L2UI_CT1.SiegeMercenaryWnd_CastleMark_Giran";
		// End:0x6E
		case 7:
			return "L2UI_CT1.SiegeMercenaryWnd_CastleMark_Godard";
	}
	return "";
}

function string GetClastleButtonIconName(int castleID, optional bool bEntry)
{
	switch(castleID)
	{
		case 1:
			if( !bEntry)
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Gludio";
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Gludio";
		case 2:
			if( !bEntry)
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Dion";
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Dion";
		case 3:
			if( !bEntry)
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Giran";
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Giran";
		case 4:
			if( !bEntry)
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Oren";
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Oren";
		case 5:
			if( !bEntry)
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Aden";
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Aden";
		case 6:
			if( !bEntry)
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Innadril";
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Innadril";
		case 7:
			if( !bEntry)
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Godard";
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Godard";
		case 8:
			if( !bEntry)
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Rune";
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Rune";
		case 9:
			if( !bEntry)
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Shuttegart";
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Shuttegart";
	}
	return "";
}

/*
 *  Gfx ЅєЕ©ё° ёЮЅГБц 
 *
 */
function showGfxScreenMessage(string Msg, optional int Type, optional bool bUseAddsystemMessageString, optional string TextColor)
{
	local string strParam;

	ParamAdd(strParam, "Msg", Msg);
	ParamAdd(strParam, "type", string(Type));
	// End:0x54
	if(TextColor != "")
	{
		ParamAdd(strParam, "textColor", TextColor);
	}
	CallGFxFunction("GfxScreenMessage", "showMessage", strParam);
	// End:0x92
	if(bUseAddsystemMessageString)
	{
		AddSystemMessageString(Msg);
	}
}

function ShowGFxMiniMapSelectedPin(MapPinType Type, Vector XYZ, string tooltip0, optional string tooltip1)
{
	local string param;

	if(XYZ.X == 0 && XYZ.Y == 0 && XYZ.Z == 0)
		return;

	param = "";
	ParamAdd(param,"type",string(Type));
	ParamAdd(param,"X",string(XYZ.X));
	ParamAdd(param,"Y",string(XYZ.Y));
	ParamAdd(param,"Z",string(XYZ.Z));
	ParamAdd(param,"tooltip0",tooltip0);
	ParamAdd(param,"tooltip1",tooltip1);
	CallGFxFunction("MiniMapGFxWnd","ShowGFxMiniMapSelectedPin",param);
}

function HideGFxMiniMapSelectedPin(MapPinType Type)
{
	CallGFxFunction("MiniMapGFxWnd","HideGFxMiniMapSelectedPin",string(Type));
}

function AddGFxMiniMapArea(string WindowName, Vector XYZ, Color rgb, optional int CircleType, optional int Id)
{
	local string param;

	if(XYZ.X == 0 && XYZ.Y == 0 && XYZ.Z == 0)
		return;

	param = "";
	ParamAdd(param, "windowName", WindowName);
	ParamAdd(param, "X", string(XYZ.X));
	ParamAdd(param, "Y", string(XYZ.Y));
	ParamAdd(param, "Z", string(XYZ.Z));
	ParamAdd(param, "CircleType", string(CircleType));
	ParamAdd(param, "id", string(Id));
	ParamAdd(param, "color", string(ColorToInt(rgb)));
	ParamAdd(param, "alpha", string(rgb.A));
	CallGFxFunction("MiniMapGFxWnd", "AddMiniMapArea", param);
}

function DelGFxMiniMapArea(string WindowName, optional int Id)
{
	local string param;

	param = "";
	ParamAdd(param, "windowName", WindowName);
	ParamAdd(param, "id", string(Id));
	CallGFxFunction("MiniMapGFxWnd", "DelMiniMapArea", param);
}

function ShowHighLightMapIcon(Vector XYZ, int OffsetX, int OffsetY, optional bool notToTown)
{
	local string param;

	if(XYZ.X == 0 && XYZ.Y == 0 && XYZ.Z == 0)
		return;

	param = "";
	ParamAdd(param, "x", string(XYZ.X));
	ParamAdd(param, "y", string(XYZ.Y));
	ParamAdd(param, "z", string(XYZ.Z));
	ParamAdd(param, "offsetX", string(OffsetX));
	ParamAdd(param, "offsetY", string(OffsetY));
	ParamAdd(param, "notToTown", string(int(notToTown)));
	CallGFxFunction("MiniMapGFxWnd", "ShowHighLightMapIcon", param);
}

function int ColorToInt(Color rgb)
{
	local int colorInt;

	colorInt = rgb.R;
	colorInt = (colorInt << 8)+ rgb.G;
	return (colorInt << 8)+ rgb.B;
}

function Color IntToColor(int colorValue)
{
	local int R, G, B;

	B = (colorValue >> 16) & 255;
	G = (colorValue >> 8) & 255;
	R = colorValue & 255;
	Debug("r" @ string(R));
	Debug("g" @ string(G));
	Debug("b" @ string(B));
	return GetColor(R, G, B, 255);
}

function INT64 Get9999Percent(INT64 pntCnt, INT64 pntMax)
{
	local INT64 ninenienienie;

	//ninenienienie = pntMax * 0.99989998;
	ninenienienie = pntMax * 0.99990f;
	if(pntCnt > ninenienienie && pntCnt < pntMax)
		return ninenienienie;
	return pntCnt;
}

function string getPlayerType(int playerClassID, int nRace)
{
	local int nOriginalClassID;

	nOriginalClassID = Class'UIDataManager'.static.GetRootClassID(playerClassID);
	if(nRace == 4)
		return "soldier";

	if(nRace == 5)
		return "soldier";
	// End:0x5C
	if(nRace == 30)
	{
		return "fighter";
	}
	if(IsDeathKnightClass(nOriginalClassID))
	{
		return "deathKnight";
	}
	// End:0x99
	if(IsDeathFighterClass(nOriginalClassID))
	{
		return "Live_deathKnight";
	}
	// End:0xB2
	if(IsOrcRiderClass(nOriginalClassID))
	{
		return "vanguard";
	}
	// End:0xCB
	if(IsAssassinClass(nOriginalClassID))
	{
		return "assassin";
	}
	switch(nOriginalClassID)
	{
		case 10:
		case 25:
		case 38:
		case 49:
		case 183:
			return "magician";
	}
	return "soldier";
}

static function string GetFullPath(WindowHandle currentHandle)
{
	local string WindowName;
	local string ParentName;

	if(currentHandle == None)
		return "";

	WindowName = currentHandle.GetWindowName();
	if(WindowName == "Console" || WindowName == "Worksheet")
		return "";

	ParentName = GetFullPath(currentHandle.GetParentWindowHandle());
	if(ParentName == "")
		return WindowName;

	return ParentName $ "." $ WindowName;
}

static function GetSkill2ItemInfo(SkillInfo sInfo, out ItemInfo iInfo)
{
	iInfo.Id.ClassID = sInfo.SkillID;
	iInfo.Level = sInfo.SkillLevel;
	iInfo.SubLevel = sInfo.SkillSubLevel;
	iInfo.Name = sInfo.SkillName;
	// End:0x83
	if(sInfo.EnchantName != "none")
	{
		iInfo.AdditionalName = sInfo.EnchantName;
	}
	iInfo.IconName = sInfo.TexName;
	iInfo.IconPanel = sInfo.IconPanel;
	iInfo.IconPanel2 = sInfo.IconPanel2;
	iInfo.Description = sInfo.SkillDesc;
	iInfo.Grade = byte(sInfo.Grade);
	iInfo.ShortcutType = 2;
	iInfo.ItemType = 1;
}

static function bool GetEllipsisString(out string Str, int textWidth)
{
	local string fixedString;
	local int nWidth, nHeight;
	local L2Util l2utilScr;

	l2utilScr = getInstanceL2Util();
	l2utilScr.GetTextSizeDefault(Str, nWidth, nHeight);
	// End:0x3B
	if(nWidth <= textWidth)
	{
		return false;
	}
	l2utilScr.GetTextSizeDefault("...", nWidth, nHeight);
	fixedString = l2utilScr.DivideStringWithWidth(Str, textWidth - nWidth);
	// End:0xA2
	if(fixedString != Str)
	{
		Str = fixedString $ "...";
		return true;
	}
	return false;
}

static function bool SetEllipsisTextBox(TextBoxHandle tbh, optional int MaxW)
{
	local string Str;
	local Rect rectWnd;

	// End:0x30
	if(MaxW == 0)
	{
		rectWnd = tbh.GetRect();
		MaxW = rectWnd.nWidth;
	}
	Str = tbh.GetText();
	// End:0xBA
	if(class'L2Util'.static.GetEllipsisString(Str, MaxW))
	{
		tbh.SetTooltipType("text");
		tbh.SetTooltipCustomType(getInstanceL2Util().MakeTooltipSimpleText(tbh.GetText()));
		tbh.SetText(Str);
		return true;
	}
	tbh.SetTooltipCustomType(getInstanceL2Util().MakeTooltipSimpleText(""));
	return false;
}

defaultproperties
{
}
