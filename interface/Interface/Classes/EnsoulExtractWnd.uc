/**-------------------------------------------------------------------------------------------------------------------------------------------------------
 Б¦ёс : ·й ЗШБ¦(БэИҐ ЗШБ¦ ЅГЅєЕЫ)

 ---------------------------------
  ЕЧЅєЖ® №ж№э)
 ---------------------------------
	 №«±в »эјє
	//»эјє 70190

	БЄЅєЕж D±Ч·№АМµе
	//»эјє 2130 5000

	ЕЧЅєЖ®їл ·й »эјє
	//»эјє 29818
	//»эјє 29905
	//»эјє 29944    bm
	//»эјє 29963    ГЯГв єТ°Ў

	NPC »эјє
	//»эјє 1030512


	їАЗВ АМєҐЖ®
	10062* 
 -------------------------------------------------------------------------------------------------------------------------------------------------------**/
class EnsoulExtractWnd extends UICommonAPI;

const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -14;

const treeName = "EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl";
const ITEMNAME_TOTAL_WIDTH = 240;
const ROOTNAME = "root";

var WindowHandle Me;

var WindowHandle DisableWnd;
var TextureHandle EnsoulGroupbox1_Texture;
var TextureHandle EnsoulGroupbox2_Texture;
var TextBoxHandle EnsoulExtractDiscription_TextBox;

var WindowHandle  EnsoulExtractProgressWnd;

var ProgressCtrlHandle EnsoulProgressWnd_ProgressBar;

var TextBoxHandle EnsoulProgressWnd_Title_TextBox;

var WindowHandle  EnsoulExtractDefaultWnd;
var ButtonHandle  EnsoulExtractDefaultWnd_extract1_Button;
var ButtonHandle  EnsoulExtractDefaultWnd_extract2_Button;
var ButtonHandle  EnsoulExtractDefaultWnd_extract3_Button;
//var ButtonHandle  EnsoulExtractInfo_Button;
var ButtonHandle  EnsoulExtract_Btn;

var TextureHandle EnsoulExtractDefaultWnd_Select1_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Select2_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Groupbox1_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Groupbox2_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Step1_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Step2_Texture;
var TextureHandle EnsoulExtractDefaultWnd_BM_Texture;
var TextureHandle EnsoulExtractDefaultWnd_SlotBg1_Texture;
//var TextureHandle EnsoulExtractDefaultWnd_SlotBg1Light_Texture;
var TextureHandle EnsoulExtractDefaultWnd_SlotBg2_Texture;
//var TextureHandle EnsoulExtractDefaultWnd_SlotBg2Light_Texture;
var TextureHandle EnsoulExtractDefaultWnd_SlotBg3_Texture;
//var TextureHandle EnsoulExtractDefaultWnd_SlotBg3Light_Texture;
var TextureHandle EnsoulExtractDefaultWnd_SlotBg4_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Divider1;
var TextureHandle EnsoulExtractDefaultWnd_Divider2;
var TextureHandle EnsoulExtractDefaultWnd_Divider3;
var TextureHandle EnsoulExtractDefaultWnd_Step1block_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Step2block_Texture;
var TextureHandle EnsoulExtractDefaultWnd_BMblock_Texture;

var ItemWindowHandle EnsoulExtractDefaultWnd_Item1_ItemWnd;
var ItemWindowHandle EnsoulExtractDefaultWnd_Item2_ItemWnd;
var ItemWindowHandle EnsoulExtractDefaultWnd_Item3_ItemWnd;
var ItemWindowHandle EnsoulExtractDefaultWnd_ItemBM_ItemWnd;

var TextBoxHandle EnsoulExtractDefaultWnd_TitleWeapon_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_WeaponName_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_TitleSoul_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_SoulName1_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_Soul1_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_SoulName2_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_Soul2_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_SoulName3_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_Soul3_TextBox;

var WindowHandle EnsoulExtractResultWnd;
var ButtonHandle EnsoulExtractInfo_Button;
var ButtonHandle EnsoulOK_Btn;
var ButtonHandle EnsoulCancel_Btn;

var TextureHandle ExtractResultWnd_Groupbox1_Texture;
var TextureHandle ExtractResultWnd_Divider_Texture;
var TextureHandle ExtractResultWnd_ListGroupbox1_Texture;
var TextureHandle ExtractResultWnd_SlotBg1_Texture;

var ItemWindowHandle ExtractResultWnd_ITEM_ItemWnd;

var TextBoxHandle ExtractResultWnd_Title_TextBox;
var TextBoxHandle ExtractResultWnd_Name_TextBox;
var TextBoxHandle ExtractResultWnd_notice_TextBox;
var TextBoxHandle ExtractResultWnd_ChargeTitle_TextBox;

var TreeHandle NeededItem_TreeCtrl;

//var ListCtrlHandle ExtractResultWnd_ListCtrl;

var WindowHandle EnsoulExtractWnd_ResultWnd;

// ј­єкГў А©µµїмАЗ ѕЖАМЕЫ А©µµїм , №«±в БэИҐј®
var ItemWindowHandle EnsoulExtractSubWnd_WeaponItemWindow;
var ItemWindowHandle EnsoulExtractSubWnd_EnsoulItemWindow;

var AnimTextureHandle EnsoulProgress_AnimTex;

var L2Util util;
var EnsoulExtractSubWnd EnsoulExtractSubWndScript;
var InventoryWnd inventoryWndScript;

// №«±вїЎ јТјУµИ ЅЅ·Ф јц·® // АП№Э ЅЅ·Ф, BM ЅЅ·Ф јц
var int normalSlotCount, bmSlotCount;
var int currentSlotIndex, currentSlotType;


// ЗцАз ЅЅ·Ф Б¤єё
var EnsoulOptionUIInfo ensoulOptionInfoSlot1;
var EnsoulOptionUIInfo ensoulOptionInfoSlot2;
var EnsoulOptionUIInfo ensoulOptionInfoSlotBM;

function OnRegisterEvent()
{
	// UI їАЗВ 10062
	RegisterEvent(EV_EnsoulExtractionWndShow);

	// ГЯГв №цЖ° Е¬ёЇИД ј­№цїЎј­ їАґВ ГЯГв јє°шї©єО
	RegisterEvent(EV_EnsoulExtractionResult);
}

function OnShow()
{
	// БцБ¤ЗС А©µµїмё¦ Б¦їЬЗС ґЭ±в ±вґЙ 
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	GetWindowHandle("EnsoulExtractSubWnd").ShowWindow();
	initProcess();
}

function initProcess()
{
	DisableWnd.HideWindow();
	// іл¶х ЖчДїЅМ №ЪЅєЕШЅєГД , ѕЖ·ЎВКАё·О ЖчДїЅє АМµї
	EnsoulExtractDefaultWnd_Select1_Texture.ShowWindow();
	EnsoulExtractDefaultWnd_Select2_Texture.HideWindow();
	// №«±в ЅЅ·Ф
	getItemSlotWindow(0).Clear();
	EnsoulExtractDefaultWnd_WeaponName_TextBox.SetTooltipType("");
	EnsoulExtractDefaultWnd_WeaponName_TextBox.ClearTooltip();
	EnsoulExtractDefaultWnd_WeaponName_TextBox.SetText("");
	// БэИҐЗШБ¦ №цЖ° јы±в±в
	EnsoulExtractDefaultWnd_extract1_Button.HideWindow();
	EnsoulExtractDefaultWnd_extract2_Button.HideWindow();
	EnsoulExtractDefaultWnd_extract3_Button.HideWindow();
	// БэИҐј®(·й)ЅЅ·Ф ГК±вИ­
	clearEnsoulStoneSlot();
	// ЗБ·О±Ч·№ЅГєк№Щ јы±в±в
	EnsoulExtractProgressWnd.HideWindow();
	// ±вє» А©µµїм ГК±вИ­(№«±в µо·ПА» єёАМµµ·П)
	EnsoulExtractDefaultWnd.ShowWindow();
	EnsoulExtractResultWnd.HideWindow();
	EnsoulExtractWnd_ResultWnd.HideWindow();
	// №«±вГў µе·Ў±Ч Аб±Э ЗШБ¦
	EnsoulExtractSubWndScript.setLock(false);
	EnsoulExtractSubWndScript.syncInventory();
	// ёХАъ ·йА» ГЯГвЗТ №«±вё¦ µо·ПЗП°н ГЯГв №цЖ°А» ґ­·ЇБЦјјїд.
	EnsoulExtractDiscription_TextBox.ShowWindow();
	EnsoulExtractDiscription_TextBox.SetText(GetSystemString(3496));
}

function OnHide()
{
	GetWindowHandle("EnsoulExtractSubWnd").HideWindow();
	initProcess();
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	util = L2Util(GetScript("L2Util"));
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	EnsoulExtractSubWndScript = EnsoulExtractSubWnd(GetScript("EnsoulExtractSubWnd"));
	Me = GetWindowHandle("EnsoulExtractWnd");
	EnsoulProgress_AnimTex = GetAnimTextureHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.EnsoulProgress_AnimTex");
	DisableWnd = GetWindowHandle("EnsoulExtractWnd.DisableWnd");
	EnsoulGroupbox1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulGroupbox1_Texture");
	EnsoulGroupbox2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulGroupbox2_Texture");
	EnsoulExtractDiscription_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDiscription_TextBox");
	EnsoulExtractProgressWnd = GetWindowHandle("EnsoulExtractWnd.EnsoulExtractProgressWnd");
	EnsoulProgressWnd_ProgressBar = GetProgressCtrlHandle("EnsoulExtractWnd.EnsoulExtractProgressWnd.EnsoulProgressWnd_ProgressBar");
	EnsoulProgressWnd_Title_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractProgressWnd.EnsoulProgressWnd_Title_TextBox");
	EnsoulExtractDefaultWnd = GetWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd");
	EnsoulExtractDefaultWnd_extract1_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_extract1_Button");
	EnsoulExtractDefaultWnd_extract2_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_extract2_Button");
	EnsoulExtractDefaultWnd_extract3_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_extract3_Button");
	EnsoulExtractInfo_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractInfo_Button");
	EnsoulExtract_Btn = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtract_Btn");
	EnsoulExtractDefaultWnd_Select1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Select1_Texture");
	EnsoulExtractDefaultWnd_Select2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Select2_Texture");
	EnsoulExtractDefaultWnd_Groupbox1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Groupbox1_Texture");
	EnsoulExtractDefaultWnd_Groupbox2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Groupbox2_Texture");
	EnsoulExtractDefaultWnd_Step1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Step1_Texture");
	EnsoulExtractDefaultWnd_Step2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Step2_Texture");
	EnsoulExtractDefaultWnd_BM_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_BM_Texture");
	EnsoulExtractDefaultWnd_SlotBg1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SlotBg1_Texture");
	EnsoulExtractDefaultWnd_SlotBg2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SlotBg2_Texture");
	EnsoulExtractDefaultWnd_SlotBg3_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SlotBg3_Texture");
	EnsoulExtractDefaultWnd_SlotBg4_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SlotBg4_Texture");
	EnsoulExtractDefaultWnd_Divider1 = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Divider1");
	EnsoulExtractDefaultWnd_Divider2 = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Divider2");
	EnsoulExtractDefaultWnd_Divider3 = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Divider3");
	EnsoulExtractDefaultWnd_Step1block_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Step1block_Texture");
	EnsoulExtractDefaultWnd_Step2block_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Step2block_Texture");
	EnsoulExtractDefaultWnd_BMblock_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_BMblock_Texture");
	EnsoulExtractDefaultWnd_Item1_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Item1_ItemWnd");
	EnsoulExtractDefaultWnd_Item2_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Item2_ItemWnd");
	EnsoulExtractDefaultWnd_Item3_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Item3_ItemWnd");
	EnsoulExtractDefaultWnd_ItemBM_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_ItemBM_ItemWnd");
	EnsoulExtractDefaultWnd_TitleWeapon_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_TitleWeapon_TextBox");
	EnsoulExtractDefaultWnd_WeaponName_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_WeaponName_TextBox");
	EnsoulExtractDefaultWnd_TitleSoul_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_TitleSoul_TextBox");
	EnsoulExtractDefaultWnd_SoulName1_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SoulName1_TextBox");
	EnsoulExtractDefaultWnd_Soul1_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Soul1_TextBox");
	EnsoulExtractDefaultWnd_SoulName2_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SoulName2_TextBox");
	EnsoulExtractDefaultWnd_Soul2_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Soul2_TextBox");
	EnsoulExtractDefaultWnd_SoulName3_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SoulName3_TextBox");
	EnsoulExtractDefaultWnd_Soul3_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Soul3_TextBox");
	EnsoulExtractResultWnd = GetWindowHandle("EnsoulExtractWnd.EnsoulExtractResultWnd");
	EnsoulExtractInfo_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.EnsoulExtractInfo_Button");
	EnsoulOK_Btn = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.EnsoulOK_Btn");
	EnsoulCancel_Btn = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.EnsoulCancel_Btn");
	ExtractResultWnd_Groupbox1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_Groupbox1_Texture");
	ExtractResultWnd_Divider_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_Divider_Texture");
	ExtractResultWnd_ListGroupbox1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_ListGroupbox1_Texture");
	ExtractResultWnd_SlotBg1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_SlotBg1_Texture");
	ExtractResultWnd_ITEM_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_ITEM_ItemWnd");
	ExtractResultWnd_Title_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_Title_TextBox");
	ExtractResultWnd_Name_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_Name_TextBox");
	ExtractResultWnd_notice_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_notice_TextBox");
	ExtractResultWnd_ChargeTitle_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_ChargeTitle_TextBox");
	NeededItem_TreeCtrl = GetTreeHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl");
	EnsoulExtractWnd_ResultWnd = GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd");
	// ј­єкГў №«±в, БэИҐј® ѕЖАМЕЫ А©µµїм
	EnsoulExtractSubWnd_WeaponItemWindow = GetItemWindowHandle("EnsoulExtractSubWnd.EnsoulSubWnd_Item1");
	EnsoulExtractSubWnd_EnsoulItemWindow = GetItemWindowHandle("EnsoulExtractSubWnd.EnsoulSubWnd_Item2");
	// °б°ъ Гў, №цЖ°, И®АО №цЖ° ЗПіЄёё єёАМµµ·П..
	GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.OK_Button").HideWindow();
	GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Cancel_Button").HideWindow();
	GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.singleOK_Button").ShowWindow();
}

//-----------------------------------------------------------------------------------------------------------
// OnEvent
//-----------------------------------------------------------------------------------------------------------
function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_EnsoulExtractionWndShow:
			Me.ShowWindow();
			break;

		case EV_EnsoulExtractionResult:
			Debug("EV_EnsoulExtractionResult" @ param);
			showResult(param);
			break;
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// ГЯГв №цЖ°
		case "EnsoulExtractDefaultWnd_extract1_Button":
			showConfirm(1);
			break;
		case "EnsoulExtractDefaultWnd_extract2_Button":
			showConfirm(2);
			break;
		case "EnsoulExtractDefaultWnd_extract3_Button":
			showConfirm(3);
			break;

		case "EnsoulExtractInfo_Button":
			helpButtonClick();
			break;

		case "EnsoulExtract_Btn":
			Me.HideWindow();
			Debug("EnsoulExtract_Btn");
			break;
			// ГЯГв ЅГµµ 
		case "EnsoulOK_Btn":
			OnEnsoulOK_BtnClick();
			break;
			// ДµЅЅ
		case "EnsoulCancel_Btn":
			OnEnsoulCancel_BtnClick();
			break;
			// °б°ъ ИД ok №цЖ° Е¬ёЇ
		case "singleOK_Button" :
			Debug("singleOK_Button");
			initProcess();
			break;
	}
}

// БэИҐ ЗШБ¦ И®АОГў ИЈГв
function showConfirm(int slotIndex)
{
	local ItemInfo ensoulItemInfo, weaponInfo;
	local string ensoulFeeInfoParam;
	local int slotType;

	Debug("slotIndex" @ slotIndex);
	DisableWnd.HideWindow();
	EnsoulExtractDefaultWnd.HideWindow();
	EnsoulExtractWnd_ResultWnd.HideWindow();

	// №«±вГў µе·Ў±Ч Аб±Э
	EnsoulExtractSubWndScript.setLock(true);

	// ГЯГв А©µµїм
	EnsoulExtractResultWnd.ShowWindow();

	// 3497 : А§їН °°АМ ·йА» ГЯГв ЗПЅГ°ЪЅАґП±о?
	EnsoulExtractDiscription_TextBox.SetText(GetSystemString(3497));
	// БэИҐ ЅЅ·Ф 1~3,(1,2,3:bm)
	ensoulItemInfo = getltemInfoBySlotIndex(slotIndex);
	// ЅЅ·ФїЎ Б¤єё Г¤їм±в(БэИҐј®Ає ѕЖАМЕЫ Б¤єё·О °ЎБц°н АЦБц ѕКАЅ)
	if(ensoulItemInfo.IconName != "")
	{
		// БэИҐј® ѕЖАМДЬ ГЯ°Ў
		ExtractResultWnd_ITEM_ItemWnd.Clear();
		ExtractResultWnd_ITEM_ItemWnd.AddItem(ensoulItemInfo);
		
		// БэИҐј® АМё§, јіён ГЯ°Ў(ЕшЖБЖчЗФ)
		setEnsoulSlotText(slotIndex, getEnsoulOptionInfoBySlotIndex(slotIndex), getInstanceUIData().getIsLiveServer(),,"", util.ColorLightBrown, true);
	}
	Debug("getEnsoulOptionInfoBySlotIndex(slotIndex).ExtractionItemID : " @ string(getEnsoulOptionInfoBySlotIndex(slotIndex).ExtractionItemID));
	// №«±в Б¤єё
	weaponInfo = getltemInfoBySlotIndex(0);

	// SlotType јјЖГ
	if(slotIndex == 1 || slotIndex == 2)
		slotType = EIST_NORMAL;
	else 
		slotType = EIST_BM;

	// ЗцАз АЫѕчБЯ АОµ¦ЅєїН ЅЅ·Ф ЕёАФ АъАе.
	currentSlotIndex = slotIndex;
	currentSlotType = slotType;
	class'UIDATA_ENSOUL'.static.GetEnsoulExtractionFeeInfoByItemId(getEnsoulOptionInfoBySlotIndex(SlotIndex).ExtractionItemID, ensoulFeeInfoParam);
	setTreeNeedItemInfo(ensoulFeeInfoParam);
}

// ЗКїд ѕЖАМЕЫ(ГЯГв јцјц·б), Ж®ё®·О ёёµл. 
function setTreeNeedItemInfo(string ensoulFeeInfoParam)
{
	local ItemInfo feeItemInfo;
	local int nFeeItemNum, nFeeItemID, i;
	local Int64 nFeeItemCount;

	local ItemInfo InvenFeeItemInfo;

	ParseInt(ensoulFeeInfoParam, "FeeItemCount", nFeeItemNum);
	util.TreeClear(treeName);
	util.TreeInsertRootNode(treeName, ROOTNAME, "", 0, 4);

	// ГЯГв №цЖ° И°јєИ­
	EnsoulOK_Btn.EnableWindow();
	// ёХАъ ·йА» ГЯГвЗТ №«±вё¦ µо·ПЗП°н ГЯГв №цЖ°А» ґ­·ЇБЦјјїд.
	EnsoulExtractDiscription_TextBox.SetText(GetSystemString(3496));

	for(i = 1; i < nFeeItemNum + 1; i++)
	{
		ParseInt(ensoulFeeInfoParam, "ItemID_" $ i , nFeeItemID);
		ParseInt64(ensoulFeeInfoParam, "ItemCount_" $ i, nFeeItemCount);
		class'UIDATA_ITEM'.static.GetItemInfo(getItemID(nFeeItemID), feeItemInfo);
		//Debug("-> "@);
		addTreeNode("LIST" $ i + 1, feeItemInfo, nFeeItemCount);
	}

	// Debug("ensoulFeeInfoParam----> " @ ensoulFeeInfoParam);

	inventoryWndScript.getInventoryItemInfo(GetItemID(nFeeItemID), InvenFeeItemInfo);
}

// ЗКїд ѕЖАМЕЫАЗ °ў ѕЖАМЕЫА» ГЯ°Ў ЗСґЩ.
function bool addTreeNode(string nodeLine, ItemInfo info, Int64 needItemCount)
{
	local ItemInfo InvenItemInfo;

	local string strRetName, gradeTextureName;
	local int textHeight;

	local string enchantedStr, itemName, additionalName, stackableAddStr;
	local string shortItemName, ensoulOptionAllName;
	local int enchantedStr_width, additionalName_width, stackableAddStr_width, ensoulOptionAllName_width, gradeTextureName_width;

	local Int64 hasNum;
	local bool bHasItem;
	//local int tryExchangeCount;

	local array<ItemInfo> itemInfoArray;
	local int itemCount;

	//tryExchangeCount = int(ItemCount_EditBox.GetString());

	// ±Ч·№АМµе ѕЖАМДЬ
	gradeTextureName = GetItemGradeTextureName(info.CrystalType);

	if(Len(gradeTextureName)> 0)
	{
		gradeTextureName_width = 16;
		// S80 ±Ч·№АМµеАП °жїмїЎ ЗСЗШ ѕЖАМДЬ ЕШЅєГД Е©±вё¦ 2№и·О ґГё°ґЩ. 6, 7
		// R95, R99 ±Ч·№АМµеАП °жїмїЎ ЗСЗШ ѕЖАМДЬ ЕШЅєГД Е©±вё¦ 2№и·О ґГё°ґЩ. 9, 10
		if(Info.CrystalType == CrystalType.CRT_S80 || Info.CrystalType == CrystalType.CRT_S84 || Info.CrystalType == CrystalType.CRT_R95 || Info.CrystalType == CrystalType.CRT_R99 || Info.CrystalType == CrystalType.CRT_R110)
		{
			gradeTextureName_width = 32;
		}
	}

	// јц·®јє ѕЖАМЕЫїЎ єЩґВ x1
	stackableAddStr = "x1";
	GetTextSizeDefault(stackableAddStr, stackableAddStr_width, textHeight);
	// End:0xE0
	if(Info.Enchanted > 0)
	{
		enchantedStr = "+" $ string(Info.Enchanted);
	}
	GetTextSizeDefault(enchantedStr, enchantedStr_width, textHeight);
	ensoulOptionAllName = GetEnsoulOptionNameAll(info);
	GetTextSizeDefault(ensoulOptionAllName, ensoulOptionAllName_width, textHeight);
	// ±в°ЈБ¦, µо ГЯ°Ў АМё§
	additionalName = class'UIDATA_ITEM'.static.GetItemAdditionalName(info.ID);
	GetTextSizeDefault(additionalName, additionalName_width, textHeight);
	itemName = class'UIDATA_ITEM'.static.GetItemName(info.ID);
	if(itemName == "")itemName = info.Name;

	shortItemName = makeShortStringByPixel(itemName, ITEMNAME_TOTAL_WIDTH -(stackableAddStr_width + additionalName_width + gradeTextureName_width + 7), "..");
	
	//Root ілµе »эјє.	
	strRetName = ROOTNAME $ "." $ nodeLine;

	util.TreeInsertItemTooltipSimpleNode(treeName, nodeLine, ROOTNAME, -7, 0, 38, 0, 32, 38, GetItemNameAll(info));

	//ѕЖАМЕЫ №и°ж ёёµй±в(АЦґВіС)
	//util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.etc.textbackline", 257, 38, , , , ,14);
	//ѕЖАМЕЫ №и°ж ёёµй±в(ѕшґВіС)
	util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", 257, 38);

	//Insert Node Item - ѕЖАМЕЫЅЅ·Ф №и°ж
	util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);

	//Insert Node Item - ѕЖАМЕЫ ѕЖАМДЬ, ЖРіО
	util.TreeInsertTextureNodeItem(treeName, strRetName, info.IconName, 32, 32, -34, OFFSET_Y_ICON_TEXTURE - 1);
	util.TreeInsertTextureNodeItem(treeName, strRetName, Info.iconPanel, 32, 32, -32, OFFSET_Y_ICON_TEXTURE - 1);
				
	//Insert Node Item - ѕЖАМЕЫ АМё§
	if(enchantedStr != "")util.TreeInsertTextNodeItem(treeName, strRetName, enchantedStr, 7, 5, util.ETreeItemTextType.COLOR_DEFAULT, true);

	util.TreeInsertTextNodeItem(TREENAME, strRetName, shortItemName, 5, 5, util.ETreeItemTextType.COLOR_DEFAULT, true);
	
	if(ensoulOptionAllName != "")util.TreeInsertTextNodeItem(treeName, strRetName, ensoulOptionAllName, 5, 5, util.ETreeItemTextType.COLOR_YELLOW, true);
	if(additionalName      != "")util.TreeInsertTextNodeItem(treeName, strRetName, additionalName, 5, 5, util.ETreeItemTextType.COLOR_YELLOW, true);	

	// ±Ч·№АМµе ѕЖАМДЬ
	if(gradeTextureName_width > 0)	util.TreeInsertTextureNodeItem(treeName, strRetName, gradeTextureName, gradeTextureName_width, 16, 2, 5);

	util.TreeInsertTextNodeItem(treeName, strRetName, "x " $ MakeCostString(String(needItemCount)), 45, OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_GOLD, false, true);


	itemCount = class'UIDATA_INVENTORY'.static.FindItemByClassID(info.Id.ClassID, itemInfoArray);

	// ѕЖАМЕЫАМ АОєҐїЎ АЦґЩёй..
	if(itemCount > 0)
	{
		InvenItemInfo = itemInfoArray[0];

		// Debug("ѕЖАМЕЫ јц·®" @ inventoryWndScript.getItemCountByClassID(info.ID.ClassID));
		if(!IsStackableItem(InvenItemInfo.ConsumeType))
		{

			hasNum = 1;
		}
		else
		{
			hasNum = InvenItemInfo.ItemNum;
		}
		if(hasNum >= needItemCount)bHasItem = true;
	}
	
	//Debug("bHasItem" @ bHasItem);
	//Debug("hasNum" @ hasNum);
	//Debug("info.ItemNum" @ info.ItemNum);
	//Debug("needItemCount" @ needItemCount);

	if(bHasItem)
	{
		if(hasNum != -1)
			util.TreeInsertTextNodeItem(treeName, strRetName,"(" $ MakeCostString(String(hasNum))$ ")", 4 , OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_BRIGHT_BLUE);
	}
	else
	{
		util.TreeInsertTextNodeItem(treeName, strRetName,"(" $ MakeCostString(String(hasNum))$ ")", 4 , OFFSET_Y_SECONDLINE, util.ETreeItemTextType.COLOR_RED);

		// ГЯГв №цЖ° єсИ°јєИ­
		EnsoulOK_Btn.DisableWindow();

		// ГЯГв јцјц·б°Ў єОБ·ЗХґПґЩ/ 
		EnsoulExtractDiscription_TextBox.SetText(MakeFullSystemMsg(GetSystemMessage(1473), GetSystemString(3494)));
	}

	return bHasItem;
}

function helpButtonClick()
{
	ExecuteEvent(EV_ShowHelp, "40");
}

// ГЯГв ЗП±в №цЖ° 
function OnEnsoulOK_BtnClick()
{
	// ЗБ·О±Ч·№ЅГєк№Щ јы±в±в
	EnsoulExtractProgressWnd.ShowWindow();
	EnsoulProgressWnd_ProgressBar.Reset();
	EnsoulProgressWnd_ProgressBar.SetProgressTime(1500);
	// ЗБ·О±Ч·№Ѕє №Щё¦ јіБ¤ №Ч ГК±вИ­.
	EnsoulProgressWnd_ProgressBar.Start();
	PlaySound("ItemSound3.enchant_process");
	EnsoulExtractDiscription_TextBox.HideWindow();
	Debug("해제 시도 EnsoulOK_Btn");
}

// ґЩАМѕу·О±ЧАЗ ЅГ°ЈАМ ґЩЗЯАЅ
function OnProgressTimeUp(string strID)
{
	Debug("strID" @ strID);

	if(strID == "EnsoulProgressWnd_ProgressBar")
	{
		if(Me.IsShowWindow())
		{
			DisableWnd.ShowWindow();
			Debug("EnsoulProgressWnd_ProgressBar 창 열기");
			EnsoulExtractProgressWnd.HideWindow();
			requestItemEnsoulProcess();
		}
	}
}

// ·й ГЯГв 
function requestItemEnsoulProcess()
{
	local string param;

	param = makeRequestEnsoulExtractionParam();
	class'EnsoulAPI'.static.RequestItemExtraction(param);
	Debug(" 실행 --- class'EnsoulAPI'.static.RequestItemExtraction() --> param: " @ param);
}

// ј­№цїЎ єёіѕ ЗШБ¦ Param ЅєЖ®ёµ »эјє
function string makeRequestEnsoulExtractionParam()
{
	local string param;
	local int targetWeaponServerID, slotIndex;
	
	// №«±вАЗ ј­№ц ѕЖАМµр
	targetWeaponServerID = getltemInfoBySlotIndex(0).Id.ServerID;

	// slotIndexґВ 1,2,3 АМ ѕЖґП°н, normal 1,2 , bm 1 АМ·±ЅД ±ёјєАМґЩ	
	if(EIST_BM == currentSlotType)slotIndex = 1;
	else slotIndex = currentSlotIndex;

	ParamAdd(param, "TargetItemID", string(targetWeaponServerID));
	ParamAdd(param, "SlotType"  , String(currentSlotType));
	ParamAdd(param, "SlotIndex" , String(slotIndex));

	return param;
}

// ДµЅЅ №цЖ° ґ­·Їј­ ГК±в »уЕВ·О µ№ѕЖ°Ё.
function OnEnsoulCancel_BtnClick()
{
	initProcess();
	StopSound("ItemSound3.enchant_process");
}

// БэИҐ °б°ъ єёї©БЦґВ ЖЛѕчГў
function showResult(string param)
{
	local int resultValue, i, n, EnsoulOptionNum, nEOptionID;
	local ItemInfo weaponInfo;

	// №«±в, АОєҐЕдё® Б¤єё °ЎБ®їА±в
	getItemSlotWindow(0).GetItem(0, weaponInfo);

	// °»ЅЕµИ ·й Б¤єё №«±вїЎ АыїлЅГЕ°±в
	for(i=EIST_NORMAL; i<EIST_MAX; i++)
	{
		ParseInt(param, "EnsoulOptionNum_" $ i , EnsoulOptionNum);

		for(n=EISI_START; n<EISI_START + EnsoulOptionNum; n++)
		{
			ParseInt(param, "EnsoulOptionID_" $ i $ "_" $ n, nEOptionID);
			weaponInfo.EnsoulOption[i - EIST_NORMAL].OptionArray[n - EISI_START] = nEOptionID;
		}
	}

	// Е¬ёЇ №жБц
	DisableWnd.SetFocus();
	DisableWnd.ShowWindow();
	DisableWnd.SetFocus();

	// ГЦБѕ °б°ъ
	//EnsoulExtractDefaultWnd.HideWindow();
	//EnsoulExtractResultWnd.ShowWindow();
	EnsoulExtractWnd_ResultWnd.ShowWindow();

	ParseInt(param, "ExtractionResult", resultValue);

	// ParseInt(param, "ExtractionItemID", ExtractionItemID);
	//class'UIDATA_ITEM'.static.GetItemInfo(getItemID(ExtractionItemID), tmInfo);	
	// if(tmInfo.Id.ClassId > 0)inventoryWndScript.getInventoryItemInfo(tmInfo.Id, weaponInfo);

	if(resultValue > 0)
		confirmResultEnsoulOption(true, weaponInfo);	
	else 
		confirmResultEnsoulOption(false, weaponInfo);	
}

//-----------------------------------------------------------------------------------------------------------------------
// ГЦБѕ °б°ъ И®АО Гў -> БэИҐ їП·б. ЅЗЖР Гіё®ё¦ ґгґзЗСґЩ.
//-----------------------------------------------------------------------------------------------------------------------
// БэИҐ °б°ъё¦ И®АО ГўА» ї¬ґЩ.
function confirmResultEnsoulOption(bool bSuccess, ItemInfo info)
{	
	local ItemInfo tempInfo;

	// End:0x30C
	if(bSuccess)
	{
		Debug("애니 돌리기");
		EnsoulExtractWnd_ResultWnd.SetWindowSize(233, 200);
		GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.OK_Button").HideWindow();
		GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Cancel_Button").HideWindow();
		GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.singleOK_Button").ShowWindow();

		// EnsoulProgress_AnimTex.HideWindow();
		// EnsoulProgress_AnimTex.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
		EnsoulProgress_AnimTex.SetLoopCount(1);
		EnsoulProgress_AnimTex.Stop();
		EnsoulProgress_AnimTex.Play();
		PlaySound("ItemSound3.enchant_success");
		EnsoulProgress_AnimTex.ShowWindow();
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").Clear();
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").ClearTooltip();
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").AddItem(info);
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").SetTooltipType("Inventory");
		// ·й ГЯГвїЎ јє°шЗЯЅАґПґЩ.
		GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Discription_TextBox").SetText(GetSystemString(3498));
	}
	else
	{
		PlaySound("ItemSound3.enchant_fail");

		EnsoulExtractWnd_ResultWnd.SetWindowSize(233, 250);
		
		tempInfo.IconName = "L2UI_ct1.Icon.ICON_DF_Exclamation";

		GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.OK_Button").HideWindow();
		GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Cancel_Button").HideWindow();
		GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.singleOK_Button").ShowWindow();

		EnsoulProgress_AnimTex.Stop();
		//EnsoulProgress_AnimTex.Pause();
		EnsoulProgress_AnimTex.HideWindow();

		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").ShowWindow();
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").Clear();
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").AddItem(tempInfo);
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").SetTooltipType("");
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").ClearTooltip();

		// -- ЅГЅєЕЫ їА·щ·О БшЗаЗТ јц ѕшЅАґПґЩ. АбЅГ ИД ґЩЅГ ЅГµµЗШ БЦјјїд.: 
		// -- АПґЬ »зїл ѕИЗФ,  ГЯИД °ў ДЙАМЅє є°·О ї№їЬ Гіё® ЗПґВ °Й ГЯГµ
		// -
		// АОєҐЕдё®АЗ №«°Ф/јц·® Б¦ЗСА» ГК°ъЗПї© ЗШґз АЫѕчА» БшЗаЗТ јц ѕшЅАґПґЩ.
		GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Discription_TextBox").SetText(GetSystemMessage(4334));
	}
}

// ёрјЗАМ іЎіЄёй јы±в±в.
function OnTextureAnimEnd(AnimTextureHandle a_AnimTextureHandle)
{
	switch(a_AnimTextureHandle.GetWindowName())
	{
		case "EnsoulProgress_AnimTex":
			// АОГ¦Ж® °Н°ъ µїАПЗП°Ф..
			a_AnimTextureHandle.HideWindow();
			//a_AnimTextureHandle.Stop();
			break;
	}

	Debug("---------------------OnTextureAnimEnd : " @ a_AnimTextureHandle.GetWindowName());
}


//--------------------------------------------------------------------------------------------------------------------
//  EnsoulExtractDefaultWnd ±вє» »уЕВ А©µµїм, №«±в іЦ±в, БэИҐј® іЦ±в, БэИҐј® ЕШЅєЖ® Г¤їм±в µо 
//--------------------------------------------------------------------------------------------------------------------

// №«±в ѕЖАМЕЫ БЦ°н №Ю±в
function InsertWeapon(ItemInfo info)
{
	local string fullName;

	PlaySound("ItemSound3.enchant_input");

	// End:0x78
	if(getInstanceUIData().getIsClassicServer())
	{
		// End:0x73
		if(Info.ItemType == EItemType.ITEM_WEAPON || Info.ItemType == EItemType.ITEM_ARMOR || Info.ItemType == EItemType.ITEM_ACCESSARY)
		{		
		}
		else
		{
			return;
		}
	}
	else
	{
		// End:0x8D
		if(Info.ItemType == EItemType.ITEM_WEAPON || Info.ItemType == EItemType.ITEM_ARMOR || Info.ItemType == EItemType.ITEM_ACCESSARY)
		{
		}
		else
		{
			return;
		}
	}

	// БэИҐј® ±вґЙ, єн·° №ЪЅє(АМ°НµйАє show°Ў °Ў·ББш »уЕВ)
	EnsoulExtractDefaultWnd_Step1block_Texture.ShowWindow();
	EnsoulExtractDefaultWnd_Step2block_Texture.ShowWindow();
	EnsoulExtractDefaultWnd_BMblock_Texture.ShowWindow();

	EnsoulExtractDefaultWnd_extract1_Button.HideWindow();
	EnsoulExtractDefaultWnd_extract2_Button.HideWindow();
	EnsoulExtractDefaultWnd_extract3_Button.HideWindow();

	// АМ№М ґЩёҐ №«±в°Ў µйѕо АЦґЩёй..
	if(EnsoulExtractDefaultWnd_Item1_ItemWnd.GetItemNum()> 0)
	{
		// єёБ¶ ѕЖАМЕЫ А©µµїм їЎј­ №«±в ѕЖАМЕЫїшµµїм А» -> БэИҐ UI №«±в ЗЧёс ѕЖАМЕЫ А©µµїмїЎ АМµї		
		util.ItemWIndow_ItemMoveByIndex(getItemSlotWindow(0), EnsoulExtractSubWnd_WeaponItemWindow, 0);
		EnsoulExtractDefaultWnd_WeaponName_TextBox.SetTooltipType("");
		EnsoulExtractDefaultWnd_WeaponName_TextBox.ClearTooltip();
	}

	// єёБ¶ АОєҐ(№«±в)-> БэИҐЗТ №«±в АОєҐАё·О 
	util.ItemWIndow_ItemMoveByItemID(EnsoulExtractSubWnd_WeaponItemWindow, getItemSlotWindow(0), info.Id);
	// №«±в АМё§ Гв·В
	if(info.Id.ClassID > 0)
	{
		// іл¶х ЖчДїЅМ №ЪЅєЕШЅєГД , ѕЖ·ЎВКАё·О ЖчДїЅє АМµї
		EnsoulExtractDefaultWnd_Select1_Texture.HideWindow();
		EnsoulExtractDefaultWnd_Select1_Texture.ShowWindow();

		// АП№Э ЅЅ·Ф, BM ЅЅ·Ф јц °»ЅЕ
		normalSlotCount = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(info.Id, EIST_NORMAL);
		bmSlotCount = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(info.Id, EIST_BM);

		// АМ№М №«±вїЎ їЙјЗАМ µЗѕо АЦґВ ЅЅ·Ф ЗҐЅГ јы±и.
		EnsoulExtractDefaultWnd_SlotBg1_Texture.HideWindow();
		EnsoulExtractDefaultWnd_SlotBg2_Texture.HideWindow();
		EnsoulExtractDefaultWnd_SlotBg3_Texture.HideWindow();

		fullName = GetItemNameAll(info);

		// №«±в АМё§ "..",  ЕшЖБ ГЯ°Ў 
		util.textBox_setToolTipWithShortString(EnsoulExtractDefaultWnd_WeaponName_TextBox, fullName);

		// ЅЅ·Ф ґЩ »иБ¦..
		clearEnsoulStoneSlot();

		// №«±вїЎ АыїлµЗѕо АЦґВ БэИҐ Б¤єёё¦ UIїЎј­ ЗҐЅГЗСґЩ.
		applyWeaponEnsoulInfo(info);
	}

	// №«±в ѕЖАМЕЫ А©µµїм 
	setWeaponEnsoulOptionSlot(info);
}

// №«±вАЗ БэИҐ Б¤єёё¦ UIїЎ ЗҐЅГ ЗСґЩ.
function applyWeaponEnsoulInfo(ItemInfo info)
{
	local int n, i , cnt, optionID, rIndex;

	local EnsoulOptionUIInfo optionInfo;
	local ItemInfo esInfo;
	
	Debug("ГК±вИ­ applyWeaponEnsoulInfo");

	// №«±вїЎј­ БэИҐ Б¤єёё¦ ѕтѕо їВґЩ.
	// Normal, BM °ў ЕёАФє°
	for(i=EIST_NORMAL; i<EIST_MAX; i++)
	{
		// °ў ЕёАФАЗ їЙјЗ јц
		cnt = info.EnsoulOption[i - EIST_NORMAL].OptionArray.Length;

		for(n=EISI_START; n<EISI_START + cnt; n++)
		{
			optionID = info.EnsoulOption[i - EIST_NORMAL].OptionArray[n - EISI_START];

			// Debug("№«±в Б¶Иё optionID" @ optionID);

			// БэИҐ їЙјЗїЎ ґлЗС Б¤єёё¦ АРґВґЩ.
			if(optionID > 0)GetEnsoulOptionUIInfo(optionID, optionInfo);
			else continue;
			
			// №«±вїЎ АМ№М АыїлµЗѕо АЦґш їЙјЗА» іЦґВґЩ.
			if(optionID > 0)
			{

				// 1,2,3 ЅЅ·ФАё·О index°ЄА» єЇИЇ
				// bm ЅЅ·ФАє 1°і АМґЩ. №«Б¶°З 3АМґЩ.
				if(i == EIST_BM)rIndex = 3;
				else rIndex = n;
				
				// Debug("№«±вїЎ їЙјЗАМ АЦґЩ :" @ optionInfo.name);						
				// Debug("optionType :" @ optionInfo.optionType);

				esInfo.IconName = optionInfo.IconTex;

				// optionInfo.IconTex = 
				// alreadyHasOptionSlotArray[ alreadyHasOptionSlotArray.Length - 1 ].optionInfo
				// esInfo

				if(i == EIST_NORMAL)
				{
					// Debug("АП№Э");
					// 1№шВ° Д­ єОЕН Г¤їм±в
					if(n == EISI_START)
					{
						// Debug("n°Є "@n);
						Debug("optionInfo.ExtractionItemID :::: " @ optionInfo.ExtractionItemID);

						if(getItemSlotWindow(1).GetItemNum()== 0)
						{
							ensoulOptionInfoSlot1 = optionInfo;
							// Debug("ЅЅ·Ф 1Г¤їм±в");
							getItemSlotWindow(1).AddItem(esInfo);
							setEnsoulSlotText(1, optionInfo,false,,"", util.ColorLightBrown);
							EnsoulExtractDefaultWnd_SlotBg1_Texture.ShowWindow();
							EnsoulExtractDefaultWnd_extract1_Button.ShowWindow();

							if(optionInfo.ExtractionItemID == 0)
							{
								EnsoulExtractDefaultWnd_extract1_Button.SetButtonName(460);
								EnsoulExtractDefaultWnd_extract1_Button.DisableWindow();
							}
							else
							{
								EnsoulExtractDefaultWnd_extract1_Button.SetButtonName(3492);
								EnsoulExtractDefaultWnd_extract1_Button.EnableWindow();
							}
						}
					}
					// 2№шВ° Д­
					else
					{
						// Debug("n°Є "@n);
						if(getItemSlotWindow(2).GetItemNum()== 0)
						{
							ensoulOptionInfoSlot2 = optionInfo;
							// Debug("ЅЅ·Ф 2Г¤їм±в");
							getItemSlotWindow(2).AddItem(esInfo);							
							setEnsoulSlotText(2, optionInfo,false,,"", util.ColorLightBrown);
							EnsoulExtractDefaultWnd_SlotBg2_Texture.ShowWindow();
							EnsoulExtractDefaultWnd_extract2_Button.ShowWindow();

							if(optionInfo.ExtractionItemID == 0)
							{
								EnsoulExtractDefaultWnd_extract2_Button.DisableWindow();
								EnsoulExtractDefaultWnd_extract2_Button.SetButtonName(460);
							}
							else
							{
								EnsoulExtractDefaultWnd_extract2_Button.SetButtonName(3492);
								EnsoulExtractDefaultWnd_extract2_Button.EnableWindow();
							}

						}
					}
				}
				// BM ЅЅ·ФАє ЗС°іАМґЩ.
				else if(i == EIST_BM)
				{		
					ensoulOptionInfoSlotBM = optionInfo;
					/// Debug("bm");
					if(getItemSlotWindow(3).GetItemNum()== 0)
					{		
						getItemSlotWindow(3).AddItem(esInfo);
						setEnsoulSlotText(3, optionInfo,false,,"", util.ColorLightBrown);
						EnsoulExtractDefaultWnd_SlotBg3_Texture.ShowWindow();
						EnsoulExtractDefaultWnd_extract3_Button.ShowWindow();

						if(optionInfo.ExtractionItemID == 0)
						{
							EnsoulExtractDefaultWnd_extract3_Button.SetButtonName(460);
							EnsoulExtractDefaultWnd_extract3_Button.DisableWindow();
						}
						else
						{
							EnsoulExtractDefaultWnd_extract3_Button.SetButtonName(3492);
							EnsoulExtractDefaultWnd_extract3_Button.EnableWindow();
						}
					}
				}
			}
		}		
	}
}


/**
 *  БэИҐј® ЅЅ·ФїЎ ј±ЕГµИ °ЄА» Гв·В, »иБ¦ Гіё®(bConfirmWnd == true¶уёй И®АОГў ЕШЅєЖ® ЗКµе·О ±іГј)
 **/
function setEnsoulSlotText(int slotIndex, EnsoulOptionUIInfo eOptionInfo, bool bUseExtractionName, optional bool bDelete, optional string applyAddString, optional Color applyColor, optional bool bConfirmWnd)
{
	local TextBoxHandle soulNameTextBox, soulDescTextBox;
	local CustomTooltip cTooltip;

	local ItemInfo tmItemInfo;
	
	// getInstanceUIData().getIsLiveServer()
	if(bUseExtractionName)
	{
		if(eOptionInfo.ExtractionItemID > 0)
			class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(eOptionInfo.ExtractionItemID), tmItemInfo);
	}

	if(bConfirmWnd == false)
	{
		if(slotIndex == 1)
		{
			soulNameTextBox = EnsoulExtractDefaultWnd_SoulName1_TextBox;
			soulDescTextBox = EnsoulExtractDefaultWnd_Soul1_TextBox;
		}
		else if(slotIndex == 2)
		{
			soulNameTextBox = EnsoulExtractDefaultWnd_SoulName2_TextBox;
			soulDescTextBox = EnsoulExtractDefaultWnd_Soul2_TextBox;

		}
		else if(slotIndex == 3)
		{ 
			soulNameTextBox = EnsoulExtractDefaultWnd_SoulName3_TextBox;
			soulDescTextBox = EnsoulExtractDefaultWnd_Soul3_TextBox;
		}
	}
	else
	{
			soulNameTextBox = ExtractResultWnd_Name_TextBox;
			soulDescTextBox = ExtractResultWnd_notice_TextBox ;
	}

	if(applyColor.R != 0 && applyColor.G != 0 && applyColor.B != 0)
		soulNameTextBox.SetTextColor(applyColor);

	if(bDelete)
	{
		textBoxClear(soulNameTextBox);
		textBoxClear(soulDescTextBox);
	}
	else
	{
		if(eOptionInfo.OptionStep > 0)
		{
			// ѕЖАМЕЫ АМё§
			if(bUseExtractionName)
			{
				util.textBox_setToolTipWithShortString(soulNameTextBox, applyAddString $ tmItemInfo.Name);
			}
			else
			{
				util.textBox_setToolTipWithShortString(soulNameTextBox, MakeFullSystemMsg(GetSystemMessage(4347), 
																		applyAddString $ eOptionInfo.Name, string(eOptionInfo.OptionStep)));
			}
		}
		else
		{
			if(bUseExtractionName)
			{
				util.textBox_setToolTipWithShortString(soulNameTextBox, applyAddString $ tmItemInfo.Name);
			}
			else
			{
				util.textBox_setToolTipWithShortString(soulNameTextBox, applyAddString $ eOptionInfo.Name);
			}
		}

		// јіён
		util.textBox_setToolTipWithShortString(soulDescTextBox, eOptionInfo.desc);

		// јіён ЕшЖБ Аыїл
		addToolTipDrawList(cTooltip, addDrawItemTexture(eOptionInfo.IconPanelTex, false, false, 2));
		addToolTipDrawList(cTooltip, addDrawItemTexture(eOptionInfo.Icontex, false, false, -16));
		addToolTipDrawList(cTooltip, addDrawItemText(eOptionInfo.Name, util.White, "", false));
		addToolTipDrawList(cTooltip, addDrawItemText(" : ", util.White, "", false));
		addToolTipDrawList(cTooltip, addDrawItemText(eOptionInfo.desc, util.ColorDesc , "", false));
		addToolTipDrawList(cTooltip, addDrawItemBlank(1));

		soulDescTextBox.SetTooltipType("text");
		soulDescTextBox.SetTooltipCustomType(cTooltip);
	}
}

// БэИҐј® ЅЅ·Фµй »иБ¦
function clearEnsoulStoneSlot()
{
	// БэИҐј® ЅЅ·Фµй АП№Э, BM
	getItemSlotWindow(1).Clear();
	getItemSlotWindow(2).Clear();
	getItemSlotWindow(3).Clear();

	textBoxClear(EnsoulExtractDefaultWnd_Soul1_TextBox);
	textBoxClear(EnsoulExtractDefaultWnd_Soul2_TextBox);
	textBoxClear(EnsoulExtractDefaultWnd_Soul3_TextBox);

	textBoxClear(EnsoulExtractDefaultWnd_SoulName1_TextBox);
	textBoxClear(EnsoulExtractDefaultWnd_SoulName2_TextBox);
	textBoxClear(EnsoulExtractDefaultWnd_SoulName3_TextBox);
}

	// ЅЅ·Ф ±вє» А©µµїм ё®ЕП
function EnsoulOptionUIInfo getEnsoulOptionInfoBySlotIndex(int slotIndex)
{
	local EnsoulOptionUIInfo enInfo;

	if(slotIndex == 1)enInfo = ensoulOptionInfoSlot1;
	else if(slotIndex == 2)enInfo = ensoulOptionInfoSlot2;
	else if(slotIndex == 3)enInfo = ensoulOptionInfoSlotBM;
	else Debug("Error(getEnsoulOptionInfoBySlotIndex): Index is " @ slotIndex);

	return enInfo;
}


// ЅЅ·Ф ±вє» А©µµїм ё®ЕП
function ItemWindowHandle getItemSlotWindow(int slotIndex)
{
	local ItemWindowHandle targetItemWndow;

	if(slotIndex == 0)targetItemWndow = EnsoulExtractDefaultWnd_Item1_ItemWnd;
	else if(slotIndex == 1)targetItemWndow = EnsoulExtractDefaultWnd_Item2_ItemWnd;
	else if(slotIndex == 2)targetItemWndow = EnsoulExtractDefaultWnd_Item3_ItemWnd;
	else if(slotIndex == 3)targetItemWndow = EnsoulExtractDefaultWnd_ItemBM_ItemWnd;
	else Debug("Error(getItemSlotWindow): Index is " @ slotIndex);

	return targetItemWndow;
}

// ѕЖАМЕЫ Б¤єёё¦ ё®ЕП(0:№«±в, 1:ЅЅ·Ф, 2:ЅЅ·Ф, 3:bm);
function ItemInfo getltemInfoBySlotIndex(int slotIndex)
{
	local ItemInfo tm;

	//Debug("ItemNum: " @ getItemSlotWindow(slotIndex).GetItemNum());

	getItemSlotWindow(slotIndex).GetItem(0, tm);

	return tm;
}

// ЅЅ·Ф 
function setWeaponEnsoulOptionSlot(ItemInfo tempInfo)
{
	local int n;

	// АП№Э ЅЅ·Ф, BM ЅЅ·Ф јц Б¶Иё
	n = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(tempInfo.Id, EIST_NORMAL);

	// АП№Э ЅЅ·Ф °№јц, 1,2ЅЅ·Ф И°јєИ­ ї©єО
	if(n == 1)
	{
		EnsoulExtractDefaultWnd_Step1block_Texture.HideWindow();				
	}
	else if(n == 2)
	{
		EnsoulExtractDefaultWnd_Step1block_Texture.HideWindow();
		EnsoulExtractDefaultWnd_Step2block_Texture.HideWindow();
	}

	// BMЅЅ·Ф
	n = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(tempInfo.Id, EIST_BM);
	if(n > 0)
	{
		EnsoulExtractDefaultWnd_BMblock_Texture.HideWindow();
	}
}

// ЗцАз ЅЅ·ФїЎ ІЕѕЖј­ »зїл БЯАО ѕЖАМЕЫ °ъ °°Ає°Ф АЦіЄ ГјЕ© , ј­єк АОєҐїЎј­ »зїл
function bool externalCheckUsingItem(ItemInfo info)
{
	local itemInfo innerItemInfo;
	local bool rValue;

	// №«±в ЅЅ·Ф
	if(getItemSlotWindow(0).GetItemNum()> 0)
	{
		getItemSlotWindow(0).GetItem(0, innerItemInfo);
		if(innerItemInfo.Id == Info.Id)rValue = true;
	}

	return rValue;
}

// OnDropItem
function OnDropItem(String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{	
	// Гў їµїЄАЗ »зАМБоwidth, height ё¦ »зїл
	local Rect  rectWnd;

	rectWnd = Me.GetRect();	

	if(a_ItemInfo.DragSrcName == "EnsoulSubWnd_Item1" || a_ItemInfo.DragSrcName == "EnsoulSubWnd_Item2")
	{
		// Debug("Б¤»уАыАО єёБ¶ АОєҐїЎј­ µе·Ў±Ч " @ a_WindowID  @ a_ItemInfo.DragSrcName);
		// °ијУ БшЗа
	}
	else 
	{
		// Debug("єс Б¤»у АОєҐїЎј­ µе·Ў±Ч: µїАЫ №«ЅГ " @ a_WindowID  @ a_ItemInfo.DragSrcName);
		return;
	}
	
	if(X > rectWnd.nX && X <  rectWnd.nX + rectWnd.nWidth && 
		Y > rectWnd.nY && Y <  rectWnd.nY + rectWnd.nHeight)//№ьА§ БцБ¤
	{	
		// Debug("№«±в №«±в А©µµїм  :::" @ a_WindowID);
		// №«±в ГЯ°Ў 
		
		InsertWeapon(a_ItemInfo);
	}
}

//--------------------------------------------------------------------------------------------------------------
//  UTIL
//--------------------------------------------------------------------------------------------------------------
function textBoxClear(TextBoxHandle txtBox)
{
	txtBox.SetText("");
	txtBox.SetTooltipType("");
	txtBox.SetText("");
}

/**
 * А©µµїм ESC Е°·О ґЭ±в Гіё® 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
