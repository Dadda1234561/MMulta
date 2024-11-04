//-----------------------------------------------------------------------------------------------------------
//  ЅЕ±Ф БэИҐ ЅЅ·Ф UI , 2015-03-11
//
// ґгґз UI±вИ№: Б¶Исїµ, ґгґзАЪ ЅГЅєЕЫ ±вИ№ ГЦАЇё® 
//-----------------------------------------------------------------------------------------------------------
class EnsoulWnd extends UICommonAPI;

const STATE_INSERT_WEAPON = "STATE_INSERT_WEAPON";
const STATE_INSERT_ENSOULSTONE = "STATE_INSERT_ENSOULSTONE";
const STATE_SELECT_ENSOUL = "STATE_SELECT_ENSOUL";
const STATE_CONFIRM_ENSOUL = "STATE_CONFIRM_ENSOUL";
const STATE_ASK_OVERWRITE = "STATE_ASK_OVERWRITE";
const STATE_RESULT = "STATE_RESULT";
const TEXTBOX_DOT_GAP = 12;

// БэИҐА» ЗП±в А§ЗС ГЦБѕ Б¤єё

// 0~1 Normal, 2№шАє BM №иї­
struct ItemEnsoulRequest
{
	var int selectedOptionID;
	var int selectedOptionType;
	var int ensoulStoneServerID;
	var int clientSlotIndex;  // АП№Э 1,2 , BMАє 1
	var int clientSlotType;
};

// UI БэИҐј® ЅЅ·Ф
struct EnsoulStoneSlot
{
	var ItemInfo Info;
	// ј±ЕГµИ їЙјЗ Б¤єё
	var EnsoulOptionUIInfo eOptionUIInfo;
	var int SlotIndex;
	var int slotType;
};

struct EnsoulFee
{
	var int ClassID;
	var INT64 Fee;
};

var WindowHandle Me;
var TextureHandle EnsoulGroupbox1_Texture;
var TextureHandle EnsoulGroupbox2_Texture;
var ButtonHandle EnsoulInfo_Button;
var ButtonHandle EnsoulOK_Button;
var ButtonHandle EnsoulCancelBtn;
var TextBoxHandle EnsoulDiscription_TextBox;
var WindowHandle EnsoulProgressWnd;
var TextBoxHandle EnsoulProgressWnd_Title_TextBox;
var ProgressCtrlHandle EnsoulProgressWnd_ProgressBar;
var WindowHandle EnsoulDefaultWnd;
var TextureHandle EnsoulDefaultWnd_SlotBg1Light_Texture;
var TextureHandle EnsoulDefaultWnd_SlotBg2Light_Texture;
var TextureHandle EnsoulDefaultWnd_SlotBg3Light_Texture;
var TextureHandle EnsoulDefaultWnd_Select1_Texture;
var TextureHandle EnsoulDefaultWnd_Select2_Texture;
var TextureHandle EnsoulDefaultWnd_Groupbox1_Texture;
var TextureHandle EnsoulDefaultWnd_Groupbox2_Texture;
var TextureHandle EnsoulDefaultWnd_Step1_Texture;
var TextureHandle EnsoulDefaultWnd_Step2_Texture;
var TextureHandle EnsoulDefaultWnd_BM_Texture;
var TextureHandle EnsoulDefaultWnd_SlotBg1_Texture;
var TextureHandle EnsoulDefaultWnd_SlotBg2_Texture;
var TextureHandle EnsoulDefaultWnd_SlotBg3_Texture;
var TextureHandle EnsoulDefaultWnd_SlotBg4_Texture;
var TextureHandle EnsoulDefaultWnd_Divider1;
var TextureHandle EnsoulDefaultWnd_Divider2;
var TextureHandle EnsoulDefaultWnd_Divider3;
var TextureHandle EnsoulDefaultWnd_Step1block_Texture;
var TextureHandle EnsoulDefaultWnd_Step2block_Texture;
var TextureHandle EnsoulDefaultWnd_BMblock_Texture;
var ItemWindowHandle EnsoulDefaultWnd_Item1_ItemWnd;
var ItemWindowHandle EnsoulDefaultWnd_Item2_ItemWnd;
var ItemWindowHandle EnsoulDefaultWnd_Item3_ItemWnd;
var ItemWindowHandle EnsoulDefaultWnd_ItemBM_ItemWnd;
var TextBoxHandle EnsoulDefaultWnd_TitleWeapon_TextBox;
var TextBoxHandle EnsoulDefaultWnd_WeaponName_TextBox;
var TextBoxHandle EnsoulDefaultWnd_TitleSoul_TextBox;
var TextBoxHandle EnsoulDefaultWnd_SoulName1_TextBox;
var TextBoxHandle EnsoulDefaultWnd_Soul1_TextBox;
var TextBoxHandle EnsoulDefaultWnd_SoulName2_TextBox;
var TextBoxHandle EnsoulDefaultWnd_Soul2_TextBox;
var TextBoxHandle EnsoulDefaultWnd_SoulName3_TextBox;
var TextBoxHandle EnsoulDefaultWnd_Soul3_TextBox;
var WindowHandle EnsoulOptionWnd;
var TextureHandle EnsoulOptionWnd_Groupbox1_Texture;
var TextureHandle EnsoulOptionWnd_Groupbox2_Texture;
var TextureHandle EnsoulOptionWnd_Groupbox3_Texture;
var TextureHandle EnsoulOptionWnd_SlotBg1_Texture;
var TextureHandle EnsoulOptionWnd_SlotBg2_Texture;
var ItemWindowHandle EnsoulOptionWnd_ITEM1_ItemWnd;
var ItemWindowHandle EnsoulOptionWnd_ITEM2_ItemWnd;
var TextBoxHandle EnsoulOptionWnd_TitleWeapon_TextBox;
var TextBoxHandle EnsoulOptionWnd_WeaponName_TextBox;
var TextBoxHandle EnsoulOptionWnd_TitleSoul_TextBox;
var TextBoxHandle EnsoulOptionWnd_SoulName_TextBox;
var TextBoxHandle EnsoulOptionWnd_Soul_TextBox;
var TextBoxHandle EnsoulOptionWnd_Souloption_TextBox;
var TextureHandle EnsoulOptionWnd_ListGroupbox1_Texture;
var TextureHandle EnsoulOptionWnd_Divider_Texture;
var ListCtrlHandle EnsoulOptionWnd_ListCtrl;
var TextBoxHandle EnsoulOptionWnd_ChargeTitle_TextBox;
var TextBoxHandle EnsoulOptionWnd_Charge1_TextBox;
var TextBoxHandle EnsoulOptionWnd_Charge2_TextBox;
var TextBoxHandle EnsoulOptionWnd_Charge3_TextBox;
var WindowHandle EnsouEffectWnd;
var TextBoxHandle EnsouEffectWnd_TitleBefore_TextBox;
var TextBoxHandle EnsouEffectWnd_TitleAfter_TextBox;
var TextBoxHandle EnsouEffectWnd_TitleCharge_TextBox;
var TextureHandle EnsouEffectWnd_ChargeGroupbox_Texture;
var TextureHandle EnsouEffectWnd_ListGroupbox1_Texture;
var ListCtrlHandle EnsouEffectWnd_Before_ListCtrl;
var TextureHandle EnsouEffectWnd_ListGroupbox2_Texture;
var ListCtrlHandle EnsouEffectWnd_After_ListCtrl;
var AnimTextureHandle EnsoulProgress_AnimTex;
var WindowHandle DisableWnd;
var WindowHandle EnsoulWnd_ResultWnd;
var L2Util util;
var InventoryWnd inventoryWndScript;
var EnsoulSubWnd EnsoulSubWndScript;

// ј­єкГў А©µµїмАЗ ѕЖАМЕЫ А©µµїм , №«±в БэИҐј®
var ItemWindowHandle EnsoulSubWnd_WeaponItemWindow;
var ItemWindowHandle EnsoulSubWnd_EnsoulItemWindow;
var UIControlNeedItemList needItemScript;
// БэИҐГўАЗ »уЕВ ґЬ°и 
var string currentEnsoulState;

// 1,2,3 -1,  ѕо¶І ЅЅ·ФА» їАЗВ ЗШј­ БэИ© їЙјЗ Иї°ъё¦ ј±ЕГЗП°Ф ГўА»  ї­ѕъіЄё¦ ±вѕп
var int currentOpenEnsoulStoneSlot;

// UIїЎј­ їЙјЗА» ј±ЕГЗС °ў јіБ¤А» АъАеЗСґЩ. ГЦБѕ °б°ъїЎ єёі»БЩ °ЄАМ µИґЩ. 
var array<ItemEnsoulRequest> itemEnsoulRequestInfo;

// №«±вїЎ АМ№М АыїлµИ їЙјЗ Б¤єёё¦ АъАеЗШ іхґВґЩ.
var array<EnsoulStoneSlot> alreadyHasOptionSlotArray;

// ЗцАз ј±ЕГµЗѕоБш ЅЅ·ФАЗ Б¤єёё¦ АъАеЗСґЩ.
var array<EnsoulOptionUIInfo> selectedOptionSlotArray;

// їЙјЗ ј±ЕГГўїЎј­ ГЦБѕ ј±ЕГЗС їЙјЗ Б¤єё
var EnsoulOptionUIInfo selectedEnsoulOptionUIInfo;

// °ў ЅЅ·Ф ё¶ґЩ 1~3№ш БЄЅєЕж јц·®А» ±вѕп ЅГЕІґЩ.
var array<EnsoulFee> slotJamStoneFee;
var int overwriteSlotIndex;
var ItemInfo overwriteItemInfo;
var int normalSlotCount;
var int bmSlotCount;

//-----------------------------------------------------------------------------------------------------------
// OnRegisterEvent, OnShow, Hide, OnLoad єОєР
//-----------------------------------------------------------------------------------------------------------
function OnRegisterEvent()
{
	// БэИҐ Гў ї­±в
	RegisterEvent(EV_EnsoulWndShow);
	// БэИҐ °б°ъ : param "Result" = 0(ЅЗЖР)or 1(јє°ш)
	RegisterEvent(EV_EnsoulResult);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
	RegisterEvent(EV_Restart);
}

function OnShow()
{
	// БцБ¤ЗС А©µµїмё¦ Б¦їЬЗС ґЭ±в ±вґЙ 
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	setWindowStateSetting(STATE_INSERT_WEAPON);
	GetWindowHandle("EnsoulSubWnd").ShowWindow();
}

function OnHide()
{
	GetWindowHandle("EnsoulSubWnd").HideWindow();
}

function OnLoad()
{
	SetClosingOnESC();

	Initialize();
}

//-----------------------------------------------------------------------------------------------------------
// Initialize
//-----------------------------------------------------------------------------------------------------------
function Initialize()
{
	util = L2Util(GetScript("L2Util"));
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	EnsoulSubWndScript = EnsoulSubWnd(GetScript("EnsoulSubWnd"));
	Me = GetWindowHandle("EnsoulWnd");
	EnsoulProgress_AnimTex = GetAnimTextureHandle("EnsoulWnd.EnsoulWnd_ResultWnd.EnsoulProgress_AnimTex");
	EnsoulGroupbox1_Texture = GetTextureHandle("EnsoulWnd.EnsoulGroupbox1_Texture");
	EnsoulGroupbox2_Texture = GetTextureHandle("EnsoulWnd.EnsoulGroupbox2_Texture");
	EnsoulInfo_Button = GetButtonHandle("EnsoulWnd.EnsoulInfo_Button");
	EnsoulOK_Button = GetButtonHandle("EnsoulWnd.EnsoulOK_Button");
	EnsoulCancelBtn = GetButtonHandle("EnsoulWnd.EnsoulCancelBtn");
	EnsoulDiscription_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDiscription_TextBox");
	EnsoulProgressWnd = GetWindowHandle("EnsoulWnd.EnsoulProgressWnd");
	EnsoulProgressWnd_Title_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulProgressWnd.EnsoulProgressWnd_Title_TextBox");
	EnsoulProgressWnd_ProgressBar = GetProgressCtrlHandle("EnsoulWnd.EnsoulProgressWnd.EnsoulProgressWnd_ProgressBar");
	EnsoulDefaultWnd = GetWindowHandle("EnsoulWnd.EnsoulDefaultWnd");
	EnsoulDefaultWnd_SlotBg1Light_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg1Light_Texture");
	EnsoulDefaultWnd_SlotBg2Light_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg2Light_Texture");
	EnsoulDefaultWnd_SlotBg3Light_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg3Light_Texture");
	EnsoulDefaultWnd_Select1_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Select1_Texture");
	EnsoulDefaultWnd_Select2_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Select2_Texture");
	EnsoulDefaultWnd_Groupbox1_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Groupbox1_Texture");
	EnsoulDefaultWnd_Groupbox2_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Groupbox2_Texture");
	EnsoulDefaultWnd_Step1_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Step1_Texture");
	EnsoulDefaultWnd_Step2_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Step2_Texture");
	EnsoulDefaultWnd_BM_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_BM_Texture");
	EnsoulDefaultWnd_SlotBg1_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg1_Texture");
	EnsoulDefaultWnd_SlotBg2_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg2_Texture");
	EnsoulDefaultWnd_SlotBg3_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg3_Texture");
	EnsoulDefaultWnd_SlotBg4_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg4_Texture");
	EnsoulDefaultWnd_Divider1 = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Divider1");
	EnsoulDefaultWnd_Divider2 = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Divider2");
	EnsoulDefaultWnd_Divider3 = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Divider3");
	EnsoulDefaultWnd_Step1block_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Step1block_Texture");
	EnsoulDefaultWnd_Step2block_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Step2block_Texture");
	EnsoulDefaultWnd_BMblock_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_BMblock_Texture");
	EnsoulDefaultWnd_Item1_ItemWnd = GetItemWindowHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Item1_ItemWnd");
	EnsoulDefaultWnd_Item2_ItemWnd = GetItemWindowHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Item2_ItemWnd");
	EnsoulDefaultWnd_Item3_ItemWnd = GetItemWindowHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Item3_ItemWnd");
	EnsoulDefaultWnd_ItemBM_ItemWnd = GetItemWindowHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_ItemBM_ItemWnd");
	EnsoulDefaultWnd_TitleWeapon_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_TitleWeapon_TextBox");
	EnsoulDefaultWnd_WeaponName_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_WeaponName_TextBox");
	EnsoulDefaultWnd_TitleSoul_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_TitleSoul_TextBox");
	EnsoulDefaultWnd_SoulName1_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SoulName1_TextBox");
	EnsoulDefaultWnd_Soul1_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Soul1_TextBox");
	EnsoulDefaultWnd_SoulName2_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SoulName2_TextBox");
	EnsoulDefaultWnd_Soul2_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Soul2_TextBox");
	EnsoulDefaultWnd_SoulName3_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SoulName3_TextBox");
	EnsoulDefaultWnd_Soul3_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Soul3_TextBox");
	EnsoulOptionWnd = GetWindowHandle("EnsoulWnd.EnsoulOptionWnd");
	EnsoulOptionWnd_Groupbox1_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Groupbox1_Texture");
	EnsoulOptionWnd_Groupbox2_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Groupbox2_Texture");
	EnsoulOptionWnd_Groupbox3_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Groupbox3_Texture");
	EnsoulOptionWnd_SlotBg1_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_SlotBg1_Texture");
	EnsoulOptionWnd_SlotBg2_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_SlotBg2_Texture");
	EnsoulOptionWnd_ITEM1_ItemWnd = GetItemWindowHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_ITEM1_ItemWnd");
	EnsoulOptionWnd_ITEM2_ItemWnd = GetItemWindowHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_ITEM2_ItemWnd");
	EnsoulOptionWnd_TitleWeapon_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_TitleWeapon_TextBox");
	EnsoulOptionWnd_WeaponName_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_WeaponName_TextBox");
	EnsoulOptionWnd_TitleSoul_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_TitleSoul_TextBox");
	EnsoulOptionWnd_SoulName_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_SoulName_TextBox");
	EnsoulOptionWnd_Soul_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Soul_TextBox");
	EnsoulOptionWnd_Souloption_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Souloption_TextBox");
	EnsoulOptionWnd_ListGroupbox1_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_ListGroupbox1_Texture");
	EnsoulOptionWnd_Divider_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Divider_Texture");
	EnsoulOptionWnd_ListCtrl = GetListCtrlHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_ListCtrl");
	EnsoulOptionWnd_ChargeTitle_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_ChargeTitle_TextBox");
	EnsoulOptionWnd_Charge1_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Charge1_TextBox");
	EnsoulOptionWnd_Charge2_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Charge2_TextBox");
	EnsoulOptionWnd_Charge3_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Charge3_TextBox");
	// ГЦБѕ И®АО А©µµїм
	EnsouEffectWnd = GetWindowHandle("EnsoulWnd.EnsouEffectWnd");
	EnsouEffectWnd_TitleBefore_TextBox = GetTextBoxHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_TitleBefore_TextBox");
	EnsouEffectWnd_TitleAfter_TextBox = GetTextBoxHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_TitleAfter_TextBox");
	EnsouEffectWnd_TitleCharge_TextBox = GetTextBoxHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_TitleCharge_TextBox");
	EnsouEffectWnd_ChargeGroupbox_Texture = GetTextureHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_ChargeGroupbox_Texture");
	EnsouEffectWnd_ListGroupbox1_Texture = GetTextureHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_ListGroupbox1_Texture");
	EnsouEffectWnd_ListGroupbox2_Texture = GetTextureHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_ListGroupbox2_Texture");
	EnsoulProgress_AnimTex.Stop();
	EnsoulProgress_AnimTex.HideWindow();
	EnsouEffectWnd_Before_ListCtrl = GetListCtrlHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_Before_ListCtrl");
	EnsouEffectWnd_After_ListCtrl = GetListCtrlHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_After_ListCtrl");
	DisableWnd = GetWindowHandle("EnsoulWnd.DisableWnd");
	EnsoulWnd_ResultWnd = GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd");

	// ј­єкГў №«±в, БэИҐј® ѕЖАМЕЫ А©µµїм
	EnsoulSubWnd_WeaponItemWindow = GetItemWindowHandle("EnsoulSubWnd.EnsoulSubWnd_Item1");
	EnsoulSubWnd_EnsoulItemWindow = GetItemWindowHandle("EnsoulSubWnd.EnsoulSubWnd_Item2");

	//  їЙјЗ ј±ЕГ ё®ЅєЖ® ЕшЖБ, ј±ЕГ ѕИЗШµµ іЄїАµµ·П
	EnsoulOptionWnd_ListCtrl.SetSelectedSelTooltip(false);
	EnsoulOptionWnd_ListCtrl.SetAppearTooltipAtMouseX(true);
	EnsouEffectWnd_After_ListCtrl.SetSelectedSelTooltip(false);
	EnsouEffectWnd_After_ListCtrl.SetAppearTooltipAtMouseX(true);
	EnsouEffectWnd_Before_ListCtrl.SetSelectedSelTooltip(false);
	EnsouEffectWnd_Before_ListCtrl.SetAppearTooltipAtMouseX(true);
	InitNeedItem();
}

function InitNeedItem()
{
	needItemScript = new class'UIControlNeedItemList';
	needItemScript.SetRichListControler(GetRichListCtrlHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_Charge_RichList"));
}

//-----------------------------------------------------------------------------------------------------------
// ±вє» ДБЖ®·С ВьБ¶ ЗФјцµй , ЅЅ·Ф °ь·Г Б¤єёµо А§БЦ
//-----------------------------------------------------------------------------------------------------------

// ЅЅ·Ф ±вє» А©µµїм ё®ЕП
function ItemWindowHandle getItemSlotWindow(int SlotIndex)
{
	local ItemWindowHandle targetItemWndow;

	// End:0x19
	if(SlotIndex == 0)
	{
		targetItemWndow = EnsoulDefaultWnd_Item1_ItemWnd;
	}
	else if(SlotIndex == 1)
	{
		targetItemWndow = EnsoulDefaultWnd_Item2_ItemWnd;
	}
	else if(SlotIndex == 2)
	{
		targetItemWndow = EnsoulDefaultWnd_Item3_ItemWnd;
	}
	else if(SlotIndex == 3)
	{
		targetItemWndow = EnsoulDefaultWnd_ItemBM_ItemWnd;
	}
	else
	{
		Debug("Error(getItemSlotWindow): Index is " @ SlotIndex);
	}

	return targetItemWndow;
}

// ЅЅ·Ф ±вє» А©µµїм ё®ЕП
function bool hasItemInSlot(int SlotIndex)
{
	local ItemInfo Info;
	local bool flag;

	Info = getItemSlotInfo(SlotIndex);
	// End:0x56
	if(getItemSlotWindow(SlotIndex).GetItemNum() > 0)
	{
		// ЗШїЬїЎј­ ЗШБ¦°Ў µйѕо °Ўј­ ГЯ°Ў(2016-01-14)
		Info = getItemSlotInfo(SlotIndex);
		// ЗШґз ЅЅ·ФїЎґВ ѕЖАМЕЫ Б¤єё°Ў µйѕо АЦБц ѕК°н ЕШЅєГД Б¤єёёё µйѕо АЦѕој­ АМ°Й·О ±ёєРЗСґЩ.
		// End:0x56
		if(Info.IconName != "")
		{
			flag = true;
		}
	}
	return flag;
}

// ЅЅ·Ф ѕЖАМЕЫ Б¤єё ё®ЕП 
function ItemInfo getItemSlotInfo(int SlotIndex)
{
	local ItemWindowHandle targetItemWndow;
	local ItemInfo Info;

	// End:0x19
	if(SlotIndex == 0)
	{
		targetItemWndow = EnsoulDefaultWnd_Item1_ItemWnd;
	}
	else if(SlotIndex == 1)targetItemWndow = EnsoulDefaultWnd_Item2_ItemWnd;
	else if(SlotIndex == 2)targetItemWndow = EnsoulDefaultWnd_Item3_ItemWnd;
	else if(SlotIndex == 3)targetItemWndow = EnsoulDefaultWnd_ItemBM_ItemWnd;
	else Debug("Error(getItemSlotWindow): Index is " @ SlotIndex);

	targetItemWndow.GetItem(0, Info);

	return Info;
}

// ±вє» А©µµїм ГК±вИ­
function InitWindows()
{
	// ј±ЕГ№ЪЅє
	EnsoulDefaultWnd_Select1_Texture.HideWindow();
	EnsoulDefaultWnd_Select2_Texture.HideWindow();

	// БэИҐј® ±вґЙ, єн·° №ЪЅє(АМ°НµйАє show°Ў °Ў·ББш »уЕВ)
	EnsoulDefaultWnd_Step1block_Texture.ShowWindow();
	EnsoulDefaultWnd_Step2block_Texture.ShowWindow();
	EnsoulDefaultWnd_BMblock_Texture.ShowWindow();

	// ±вє» А©µµїм
	EnsoulDefaultWnd.HideWindow();
	
	// їЙјЗ ј±ЕГ А©µµїм 
	EnsoulOptionWnd.HideWindow();

	// ГЦБѕ ГјЕ© А©µµїм , БшЗаЗТ±оїд? №ЇґВ А©µµїм
	EnsouEffectWnd.HideWindow();

	// ok ґ©ёЈёй єёї©Бц°Ф ЗПґВ ЗБ·О±Ч·№ЅГєк№Щ
	EnsoulProgressWnd.HideWindow();

	// ГЦБѕ °б°ъ °в №°ѕоєё±в А©µµїм·О »зїл.
	EnsoulWnd_ResultWnd.HideWindow();

	// Е¬ёЇ №жБц
	DisableWnd.HideWindow();

	EnsoulSubWndScript.setLock(false);

	//  OK №цЖ°
	EnsoulOK_Button.HideWindow();

	// №цЖ°ён єЇ°ж	
	EnsoulCancelBtn.SetButtonName(3387);  // БэИҐ ЅГАЫ
}

function setWeaponEnsoulOptionSlot(ItemInfo tempInfo)
{
	local int n;

	// АП№Э ЅЅ·Ф, BM ЅЅ·Ф јц Б¶Иё
	n = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(tempInfo.Id, EIST_NORMAL);

	// АП№Э ЅЅ·Ф °№јц, 1,2ЅЅ·Ф И°јєИ­ ї©єО
	if(n == 1)
	{
		EnsoulDefaultWnd_Step1block_Texture.HideWindow();
	}
	else if(n == 2)
	{
		EnsoulDefaultWnd_Step1block_Texture.HideWindow();
		EnsoulDefaultWnd_Step2block_Texture.HideWindow();
	}

	// BMЅЅ·Ф
	n = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(tempInfo.Id, EIST_BM);
	if(n > 0)
	{
		EnsoulDefaultWnd_BMblock_Texture.HideWindow();
	}
}

// №«±вїЎ ї­·Б АЦґВ ЅЅ·Ф ГјЕ©
function bool isOpendEnsoulSlot(int SlotIndex)
{
	local bool RValue;

	switch(SlotIndex)
	{
		// End:0x26
		case 1:
			RValue = ! EnsoulDefaultWnd_Step1block_Texture.IsShowWindow();
			// End:0x9C
			break;
		// End:0x46
		case 2:
			RValue = ! EnsoulDefaultWnd_Step2block_Texture.IsShowWindow();
			// End:0x9C
			break;
		// End:0x66
		case 3:
			RValue = ! EnsoulDefaultWnd_BMblock_Texture.IsShowWindow();
			// End:0x9C
			break;
		// End:0xFFFF
		default:
			Debug("Error isUseEnsoulSlot-> 잘못된 값을 넣었어!");
			break;
	}

	return RValue;
}

/**
 *   А©µµїм »уЕВ °Є  
 *   setWindowStateSetting("InsertWeapon");
 *   setWindowStateSetting("selectEnsoulState");
 *   setWindowStateSetting("checkEnsoulState");
 *   setWindowStateSetting("resultEnsoulState");
 *   
 **/
function setWindowStateSetting(string wndStateString)
{
	currentEnsoulState = wndStateString;

	if(wndStateString == STATE_INSERT_WEAPON)
	{
		//RequestItemList();
		InitWindows();

		// °ў ЅЅ·Ф ГК±вИ­
		clearWeponSlot();
		clearEnsoulStoneSlot();
		clearEnsoulOptionWnd();

		// ЅЅ·Ф јјЖГ ГК±вИ­
		itemEnsoulRequestInfo.Length = 0;
		itemEnsoulRequestInfo.Length = 3;

		// Debug("ГК±вИ­2 STATE_INSERT_WEAPON");

		// №«±в ј±ЕГ№ЪЅє
		EnsoulDefaultWnd_Select1_Texture.ShowWindow();

		// ±вє» А©µµїм
		EnsoulDefaultWnd.ShowWindow();

		// ј­єк АОєҐЕдё® №«±в ЕЗАё·О °­Б¦ АМµї
		// °­Б¦ ѕЖ·Ў tabindex°Ў ЅЗЗаµЗёй ГЦЅЕ Б¤єё·О ј­єк АОєҐЕдё® °»ЅЕ
		EnsoulSubWndScript.setTabIndex(0);
	
		// №«±в ЅЅ·ФїЎ БэИҐЗТ №«±вё¦ µе·УЗШ БЦјјїд.
		EnsoulDiscription_TextBox.SetText(GetSystemMessage(4327));

		// End:0xB6
		if(isChangedWeaponEnsoulOption())
		{
			EnsoulCancelBtn.EnableWindow();
		}
		else
		{
			EnsoulCancelBtn.DisableWindow();
		}

		// №«±вїЎ АыїлµЗѕо АЦґВ БэИҐ Б¤єёё¦ UIїЎј­ ЗҐЅГЗСґЩ.
		//applyWeaponEnsoulInfo(info);
	}
	else if(wndStateString == STATE_INSERT_ENSOULSTONE)
	{
		InitWindows();

		clearEnsoulOptionWnd();

		// їЙјЗ ј±ЕГ №ЪЅє
		EnsoulDefaultWnd_Select2_Texture.ShowWindow();

		// ±вє» А©µµїм
		EnsoulDefaultWnd.ShowWindow();

		if(isChangedWeaponEnsoulOption())EnsoulCancelBtn.EnableWindow();
		else EnsoulCancelBtn.DisableWindow();

		// №«±в ѕЖАМЕЫ А©µµїм 
		if(getItemSlotWindow(0).GetItemNum()> 0)
		{
			setWeaponEnsoulOptionSlot(getItemSlotInfo(0));

			//// АП№Э ЅЅ·Ф, BM ЅЅ·Ф јц Б¶Иё
			//n = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(tempInfo.Id, EIST_NORMAL);

			//// АП№Э ЅЅ·Ф °№јц, 1,2ЅЅ·Ф И°јєИ­ ї©єО
			//if(n == 1)
			//{
			//	EnsoulDefaultWnd_Step1block_Texture.HideWindow();
			//}
			//else if(n == 2)
			//{
			//	EnsoulDefaultWnd_Step1block_Texture.HideWindow();
			//	EnsoulDefaultWnd_Step2block_Texture.HideWindow();
			//}

			//// BMЅЅ·Ф
			//n = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(tempInfo.Id, EIST_BM);
			//if(n > 0)EnsoulDefaultWnd_BMblock_Texture.HideWindow();

			//Debug("bm slot count " @ n);

			// ј­єк АОєҐЕдё® БэИҐј® ЕЗАё·О °­Б¦ АМµї
			EnsoulSubWndScript.setTabIndex(1);
		}

		// БэИҐј® ЅЅ·ФїЎ БэИҐј®А» µе·УЗШ БЦјјїд.
		EnsoulDiscription_TextBox.SetText(GetSystemMessage(4328));
	}
	else if(wndStateString == STATE_SELECT_ENSOUL)
	{
		InitWindows();

		EnsoulSubWndScript.setLock(true);
		// їЙјЗ ј±ЕГ №ЪЅє
		//EnsoulDefaultWnd_Select2_Texture.ShowWindow();
		// їЙјЗ ј±ЕГ А©µµїм 
		EnsoulOptionWnd.ShowWindow();

		//»зїлЗТ БэИҐ Иї°ъё¦ ј±ЕГЗШ БЦјјїд.
		EnsoulDiscription_TextBox.SetText(GetSystemMessage(4330));

		// №цЖ°ён єЇ°ж
		EnsoulOK_Button.EnableWindow();
		EnsoulOK_Button.ShowWindow();	
		EnsoulOK_Button.SetButtonName(2234); // µо·П 

		EnsoulCancelBtn.EnableWindow();
		EnsoulCancelBtn.ShowWindow();
		EnsoulCancelBtn.SetButtonName(141); // ГлјТ
	}
	else if(wndStateString == STATE_CONFIRM_ENSOUL)
	{
		InitWindows();

		EnsoulSubWndScript.setLock(true);
		// ГЦБѕ ГјЕ© А©µµїм , БшЗаЗТ±оїд? №ЇґВ А©µµїм
		EnsouEffectWnd.ShowWindow();

		EnsoulProgressWnd.HideWindow();
		EnsoulProgressWnd_ProgressBar.HideWindow();

		askEnsoulLastProcess(true);
		
		EnsoulOK_Button.EnableWindow();
		EnsoulOK_Button.ShowWindow();	
		EnsoulOK_Button.SetButtonName(1337); // И®АО 

		EnsoulCancelBtn.ShowWindow();
		EnsoulCancelBtn.SetButtonName(141); // ГлјТ	
	}
 	else if(wndStateString == STATE_RESULT)
	{
		InitWindows();

		EnsoulSubWndScript.setLock(true);

		// ГЦБѕ ГјЕ© А©µµїм , БшЗаЗТ±оїд? №ЇґВ А©µµїм
		EnsouEffectWnd.ShowWindow();

		// ok ґ©ёЈёй єёї©Бц°Ф ЗПґВ ЗБ·О±Ч·№ЅГєк№Щ
		EnsoulProgressWnd.ShowWindow();

		// ГЦБѕ °б°ъ
		EnsoulWnd_ResultWnd.ShowWindow();

		// Е¬ёЇ №жБц
		DisableWnd.ShowWindow();
	}
}

//-----------------------------------------------------------------------------------------------------------
// OnEvent
//-----------------------------------------------------------------------------------------------------------
function OnEvent(int Event_ID, string param)
{
	//debug("Inven Event ID :" $string(Event_ID)$" "$param);
	//debug("Inven Event ID :" $string(Event_ID));

	switch(Event_ID)
	{
		case EV_EnsoulWndShow:
			Me.ShowWindow();
			break;
		case EV_EnsoulResult:
			showResult(param);
			break;
		case EV_DialogOK:
			break;
		case EV_DialogCancel:
			break;
		case EV_Restart:
			break;
	}
}

//-----------------------------------------------------------------------------------------------------------
// OnClickButton
//-----------------------------------------------------------------------------------------------------------
function OnClickButton(string Name)
{
	local LVDataRecord Record;
	local ItemInfo Info;
	local EnsoulStoneUIInfo refEnsoulStoneUIInfo;

	switch(Name)
	{
		//----------------------------------------------------
		// End:0x263
		case "EnsoulOK_Button":

			// Debug("getCurrentEnsoulState()" @ getCurrentEnsoulState());
			if(getCurrentEnsoulState()== STATE_SELECT_ENSOUL)
			{
				// End:0x138
				if(EnsoulOptionWnd_ListCtrl.GetSelectedIndex() > -1)
				{
					EnsoulOptionWnd_ListCtrl.GetSelectedRec(Record);
					// End:0x135
					if(Record.LVDataList[0].nReserved2 > 0)
					{
						GetEnsoulOptionUIInfo(Record.LVDataList[0].nReserved2, selectedEnsoulOptionUIInfo);
						// End:0x135
						if(EnsoulOptionWnd_ITEM2_ItemWnd.GetItemNum() > 0)
						{
							EnsoulOptionWnd_ITEM2_ItemWnd.GetItem(0, Info);

							// ёЮАОГўїЎ їЙјЗАМ ј±ЕГµИ БэИҐј®А» АыїлЅГЕІґЩ.
							// End:0xF4
							if(overwriteSlotIndex > 0)
							{
								applySelectdEnsoulOption(overwriteSlotIndex, Info, Record.LVDataList[0].nReserved2);
							}
							else
							{
								applySelectdEnsoulOption(currentOpenEnsoulStoneSlot, info, record.LVDataList[0].nReserved2);
							}

							// БэИҐј® іЦ±в °ЎґЙ »уЕВ·О єЇ°ж 
							setWindowStateSetting(STATE_INSERT_ENSOULSTONE);
						}
					}
				 }
				 else 
				 {
					// »зїлЗТ БэИҐ Иї°ъё¦ ј±ЕГЗШ БЦјјїд
					//EnsoulDiscription_TextBox.SetTextColor(getColor(255,0,0));
					EnsoulDiscription_TextBox.SetText(GetSystemMessage(4345));

					// Г¤ЖГГўїЎµµ Гв·ВЗСґЩ.
					AddSystemMessage(4345);
				 }
			 }
			 // 
			 else if(getCurrentEnsoulState()== STATE_INSERT_ENSOULSTONE)
			 {				
				setWindowStateSetting(STATE_CONFIRM_ENSOUL);

				// ї©±в °нГДѕЯ ЗСґЩ. ±ЧіЙ іСѕо °Ўёй ѕИµЗ°н... ЅЅ·Ф, АзБэИҐ ЅЅ·ФА» ГјЕ© ЗПї©
				// јцБ¤µИ ¶ЗґВ »х·О µйѕо°Ј ЅЅ·ФАМ АЦА» °жїмёё Гіё® ЗШѕЯ ЗСґЩ.
			 }
			 // ГЦБѕ И®АОГўїЎј­ OK №цЖ°
			 else if(getCurrentEnsoulState()== STATE_CONFIRM_ENSOUL)
			{
				EnsoulOK_Button.DisableWindow();
				EnsoulProgressWnd.ShowWindow();
				EnsoulProgressWnd_ProgressBar.ShowWindow();
				EnsoulProgressWnd_ProgressBar.Reset();
				EnsoulProgressWnd_ProgressBar.SetProgressTime(1500);
				
				// ЗБ·О±Ч·№Ѕє №Щё¦ јіБ¤ №Ч ГК±вИ­.
				EnsoulProgressWnd_ProgressBar.Start();

				EnsoulDiscription_TextBox.SetText(GetSystemMessage(4336));

				PlaySound("ItemSound3.enchant_process");
				//setWindowStateSetting(STATE_CONFIRM_ENSOUL);
				//class'EnsoulAPI'.static.RequestItemEnsoul("");
			}

			break;

		case "EnsoulCancelBtn":
			// ГЦБѕ И®АО ґЬ°и¶уёй..
			// End:0x2E5
			if(currentEnsoulState == STATE_SELECT_ENSOUL)
			{
				slotJamStoneFee[currentOpenEnsoulStoneSlot - 1].ClassID = 0;
				slotJamStoneFee[currentOpenEnsoulStoneSlot - 1].Fee = 0;
				setWindowStateSetting(STATE_INSERT_ENSOULSTONE);
			}
			 else if(currentEnsoulState == STATE_CONFIRM_ENSOUL)
			 {
				 // ГЦБѕ И®АОГўїЎј­ ДµЅЅ №цЖ°
				 if(EnsoulProgressWnd_ProgressBar.IsShowWindow())
				 {
					StopSound("ItemSound3.enchant_process");					
					EnsoulDiscription_TextBox.SetText(GetSystemMessage(4335));
					EnsoulProgressWnd_ProgressBar.Stop();
					EnsoulProgressWnd_ProgressBar.Reset();
					EnsoulProgressWnd_ProgressBar.HideWindow();
					EnsoulOK_Button.EnableWindow();
				 }
				 else
				 {
					 setWindowStateSetting(STATE_INSERT_ENSOULSTONE);					 
				 }
			 }
			 // БэИҐ ЅГАЫ 
			 else if(currentEnsoulState == STATE_INSERT_ENSOULSTONE ||  currentEnsoulState == STATE_INSERT_WEAPON)
			 {
				if(isChangedWeaponEnsoulOption())setWindowStateSetting(STATE_CONFIRM_ENSOUL);
			 }
			 break;


	    // µµїтё»
		case "EnsoulInfo_Button":
			// Debug("EnsoulInfo_Button µµїтё» ");
			OnHelpBtnClick();
			break;
		//--------------------------------------------------
		// БэИҐ їЙјЗ µ¤ѕо ѕІ±в јц¶ф
		// End:0x4E7
		case "OK_Button":
			setWindowStateSetting(STATE_SELECT_ENSOUL);
			GetEnsoulStoneUIInfo(getItemSlotInfo(0), overwriteItemInfo.Id, refEnsoulStoneUIInfo);
			Debug("overwriteSlotIndex" @ overwriteSlotIndex);

			 // АзБэИҐ БЯАМёй »©БШґЩ, µО№шВ° param Ає trueґВ ёЮјјБ¦ё¦ Гв·В ѕИЗФ ї№їЬ Гіё®
			 // ёёѕа Аыїл БЯАМ¶уёй »©БЦБц ѕКґВґЩ.
			// End:0x4C0
			if(overwriteSlotIndex > 0)
			{
				removeEnsoulStone(overwriteSlotIndex, true);
			}

			 // №«±в, БэИҐј®,  Б¤єё·О БэИҐ їЙјЗ ј±ЕГГў ї­±в
			applySelectOptionInEnsoulStone(overwriteSlotIndex, getItemSlotInfo(0), overwriteItemInfo, refEnsoulStoneUIInfo, true);

			 // АзБэИҐ ЗТІЁіД°н №°ѕо єёґВ Гў, јы±в±в
			askOverwriteEnsoulOption(false);

			break;

		// БэИҐ їЙјЗ µ¤ѕо ѕІ±в ГлјТ
		case "Cancel_Button":			 
			askOverwriteEnsoulOption(false);
			// End:0x538
			break;

		// °б°ъГў И®АО
		case "singleOK_Button":
			setWindowStateSetting(STATE_INSERT_WEAPON);
			// End:0x538
			break;

		 //--------------------------------------------------
	}
}

// µµїтё» ї­±в 
function OnHelpBtnClick()
{
	ExecuteEvent(EV_ShowHelp, "40");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  ё®ЅєЖ® Е¬ёЇ(БэИҐ Иї°ъ)- їЙјЗ ј±ЕГ 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;

	local int nSelect;

	// Debug("ListCtrlID" @ ListCtrlID);

	nSelect = EnsoulOptionWnd_ListCtrl.GetSelectedIndex();

	// Debug("nSelect : " @ nSelect);

	// End:0x34
	if(nSelect >= 0)
	{
		EnsoulOptionWnd_ListCtrl.GetSelectedRec(Record);
	}
}

//-----------------------------------------------------------------------------------------------------------
// OnDropItemSourc, OnDropItem, OnDBClickItem Гіё® 
//-----------------------------------------------------------------------------------------------------------

// ѕЖАМДЬА» №ЫАё·О »©іѕ¶§..
function OnDropItemSource(string strTarget, ItemInfo Info)
{
	//if(bEnchantbool || bEnchantedbool)return;//АОГ¦ БЯАМ°ЕіЄ АОГ¦ їП·б ЅГ 

	// Debug("OnDropItemSource" @ strTarget  @ info.DragSrcName);
	// End:0xD7
	if(strTarget == "Console")
	{
		switch(Info.DragSrcName)
		{
			// №«±в 
			case "EnsoulDefaultWnd_Item1_ItemWnd":
				removeWeaponItem();
				// End:0xD7
				break;
			// БэИҐј® ЅЅ·Ф 1, 2, BM
			case "EnsoulDefaultWnd_Item2_ItemWnd":
				removeEnsoulStone(1);
				// End:0xD7
				break;
			// End:0xA6
			case "EnsoulDefaultWnd_Item3_ItemWnd":
				removeEnsoulStone(2);
				// End:0xD7
				break;
			// End:0xD4
			case "EnsoulDefaultWnd_Item3_ItemWnd":
				removeEnsoulStone(3);
				// End:0xD7
				break;
		}
	}
}

// OnDropItem
function OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	local Rect rectWnd, DragDropItemRect1, DragDropItemRect2, DragDropItemRect3, DragDropItemRectBM, DragDropItemRectAll,
		OptionSelectEnsoulStoneRect;

	rectWnd = Me.GetRect();
	// №«±в їµїЄ
	DragDropItemRect1 = EnsoulOptionWnd_Groupbox1_Texture.GetRect();

	// БэИҐј® , 1,2,BMЅЅ·Ф їµїЄ
	DragDropItemRect2 = EnsoulDefaultWnd_Step1block_Texture.GetRect();
	DragDropItemRect3 = EnsoulDefaultWnd_Step2block_Texture.GetRect();
	DragDropItemRectBM = EnsoulDefaultWnd_BMblock_Texture.GetRect();

	// 2,3, BM їµїЄ(±Ч·м)
	DragDropItemRectAll = EnsoulDefaultWnd_Groupbox2_Texture.GetRect();

	// БэИҐ їЙјЗ ј±ЕГГў
	// БэИҐ їЙјЗ ј±ЕГГўїЎј­, БэИҐј® іЦґВ °ш°Ј
	OptionSelectEnsoulStoneRect = EnsoulOptionWnd_Groupbox2_Texture.GetRect(); // АьГј ±Ч·м їµїЄ

	// End:0xDE
	if(a_itemInfo.DragSrcName == "EnsoulSubWnd_Item1" || a_itemInfo.DragSrcName == "EnsoulSubWnd_Item2")
	{
		// Debug("Б¤»уАыАО єёБ¶ АОєҐїЎј­ µе·Ў±Ч " @ a_WindowID  @ a_ItemInfo.DragSrcName);
		// °ијУ БшЗа
	}
	else
	{
		// Debug("єс Б¤»у АОєҐїЎј­ µе·Ў±Ч: µїАЫ №«ЅГ " @ a_WindowID  @ a_ItemInfo.DragSrcName);
		return;
	}
	
	if(currentEnsoulState == STATE_INSERT_WEAPON || currentEnsoulState == STATE_INSERT_ENSOULSTONE)
	{
		if(X > DragDropItemRect1.nX && X <  DragDropItemRect1.nX + DragDropItemRect1.nWidth && 
			Y > DragDropItemRect1.nY && Y <  DragDropItemRect1.nY + DragDropItemRect1.nHeight)//№ьА§ БцБ¤
		{	
			// Debug("№«±в №«±в А©µµїм  :::" @ a_WindowID);
			// №«±в ГЯ°Ў 
			
			InsertWeapon(a_itemInfo);
		}		
		// їЙјЗ Гў їµїЄ
		else if(X > DragDropItemRect2.nX && X <  DragDropItemRect2.nX + DragDropItemRect2.nWidth && 
			Y > DragDropItemRect2.nY && Y <  DragDropItemRect2.nY + DragDropItemRect2.nHeight)//№ьА§ БцБ¤
		{
			// Debug("БэИҐј® БэИҐј® 1 :::" @ a_WindowID);
			InsertEnsoulStone(1, a_itemInfo);
		}
		else if(X > DragDropItemRect3.nX && X <  DragDropItemRect3.nX + DragDropItemRect3.nWidth && 
				 Y > DragDropItemRect3.nY && Y <  DragDropItemRect3.nY + DragDropItemRect3.nHeight)//№ьА§ БцБ¤
		{
			// Debug("БэИҐј® БэИҐј® 2  :::" @ a_WindowID);
			InsertEnsoulStone(2, a_itemInfo);
		}

		else if(X > DragDropItemRectBM.nX && X <  DragDropItemRectBM.nX + DragDropItemRectBM.nWidth && 
				Y > DragDropItemRectBM.nY && Y <  DragDropItemRectBM.nY + DragDropItemRectBM.nHeight)//№ьА§ БцБ¤
		{
			// Debug("БэИҐј® БэИҐј® BM :::" @ a_WindowID);
			InsertEnsoulStone(3, a_itemInfo);
		}

		else if(X > DragDropItemRectAll.nX && X <  DragDropItemRectAll.nX + DragDropItemRectAll.nWidth && 
				Y > DragDropItemRectAll.nY && Y <  DragDropItemRectAll.nY + DragDropItemRectAll.nHeight)//№ьА§ БцБ¤
		{
			InsertEnsoulStone(-1, a_itemInfo);
			
			// Debug("** БэИҐј® ±Ч·м їµїЄ :::" @ a_WindowID);
		}	
	}
	else if(currentEnsoulState == STATE_SELECT_ENSOUL)
	{
		if(X > OptionSelectEnsoulStoneRect.nX && X <  OptionSelectEnsoulStoneRect.nX + OptionSelectEnsoulStoneRect.nWidth && 
		   Y > OptionSelectEnsoulStoneRect.nY && Y <  OptionSelectEnsoulStoneRect.nY + OptionSelectEnsoulStoneRect.nHeight)//№ьА§ БцБ¤
		{
			// Debug("їмёЈВчВч " @ currentOpenEnsoulStoneSlot);
			InsertEnsoulStone(currentOpenEnsoulStoneSlot, a_itemInfo);
		}
	}

	// ButtonStateCheck();
}

// ґхєн Е¬ёЇЗПёй, №«±в, БэИҐј® ЅЅ·ФАє »иБ¦
function OnDBClickItem(string ControlName, int Index)
{
	//if(bEnchantbool)return;
	// Debug(ControlName @ String(index));	

	// №«±в 
	if(ControlName == "EnsoulDefaultWnd_Item1_ItemWnd")
	{
		removeWeaponItem();
	}	
	// БэИҐј® ЅЅ·Ф 1, 2, BM
	else if(ControlName == "EnsoulDefaultWnd_Item2_ItemWnd")
	{		
		removeEnsoulStone(1);
	}	
	else if(ControlName == "EnsoulDefaultWnd_Item3_ItemWnd")
	{		
		removeEnsoulStone(2);
	}	
	else if(ControlName == "EnsoulDefaultWnd_ItemBM_ItemWnd")
	{		
		removeEnsoulStone(3);
	}	


	// БэИҐ їЙјЗ ј±ЕГГў, №«±вё¦ ґхєн Е¬ёЇ-> №«±в »иБ¦
	else if(ControlName == "EnsoulOptionWnd_ITEM1_ItemWnd")
	{		
		// removeWeaponItem();
		// Debug("їЙјЗ ј±ЕГ №«±в - ґхєнЕ¬ёЇ-> ѕЖ№«°Нµµ ѕИЗФ");
	}
	// БэИҐ їЙјЗ ј±ЕГГў, БэИҐј® ґхєн Е¬ёЇ-> ѕЖ№« АЫµї ѕИЗФ
	else if(ControlName == "EnsoulOptionWnd_ITEM2_ItemWnd")
	{		
		// Debug("їЙјЗ ј±ЕГ БэИҐј® - ґхєнЕ¬ёЇ-> ѕЖ№«°Нµµ ѕИЗФ");
	}
}

function OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
}

//--------------------------------------------------------------------------------------------------------------------
//  EnsoulDefaultWnd ±вє» »уЕВ А©µµїм, №«±в іЦ±в, БэИҐј® іЦ±в, БэИҐј® ЕШЅєЖ® Г¤їм±в µо 
//--------------------------------------------------------------------------------------------------------------------

// №«±в ѕЖАМЕЫ БЦ°н №Ю±в
function InsertWeapon(ItemInfo Info)
{
	local string FullName;

	PlaySound("ItemSound3.enchant_input");
	setWindowStateSetting(STATE_INSERT_WEAPON);

	// End:0x93
	if(getInstanceUIData().getIsClassicServer())
	{
		// End:0x8E
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
		if(Info.ItemType == EItemType.ITEM_WEAPON || Info.ItemType == EItemType.ITEM_ARMOR || Info.ItemType == EItemType.ITEM_ACCESSARY)
		{

		}
		else
		{
			return;
		}
	}

	// АМ№М ґЩёҐ №«±в°Ў µйѕо АЦґЩёй..
	if(EnsoulDefaultWnd_Item1_ItemWnd.GetItemNum() > 0)
	{
		// єёБ¶ ѕЖАМЕЫ А©µµїм їЎј­ №«±в ѕЖАМЕЫїшµµїм А» -> БэИҐ UI №«±в ЗЧёс ѕЖАМЕЫ А©µµїмїЎ АМµї		
		util.ItemWIndow_ItemMoveByIndex(getItemSlotWindow(0), EnsoulSubWnd_WeaponItemWindow, 0);
		
		EnsoulDefaultWnd_WeaponName_TextBox.SetTooltipType("");
		EnsoulDefaultWnd_WeaponName_TextBox.ClearTooltip();
	}

	// єёБ¶ АОєҐ(№«±в)-> БэИҐЗТ №«±в АОєҐАё·О 
	util.ItemWIndow_ItemMoveByItemID(EnsoulSubWnd_WeaponItemWindow, getItemSlotWindow(0), Info.Id);

	// №«±в АМё§ Гв·В
	if(Info.Id.ClassID > 0)
	{
		// АП№Э ЅЅ·Ф, BM ЅЅ·Ф јц °»ЅЕ
		normalSlotCount = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(Info.Id, EIST_NORMAL);
		bmSlotCount = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(Info.Id, EIST_BM);
		Debug("normalSlotCount : " @ string(normalSlotCount));
		Debug("bmSlotCount : " @ string(bmSlotCount));
		// АМ№М №«±вїЎ їЙјЗАМ µЗѕо АЦґВ ЅЅ·Ф ЗҐЅГ јы±и.
		EnsoulDefaultWnd_SlotBg1Light_Texture.HideWindow();
		EnsoulDefaultWnd_SlotBg2Light_Texture.HideWindow();
		EnsoulDefaultWnd_SlotBg3Light_Texture.HideWindow();
		FullName = GetItemNameAll(Info);
		// №«±в АМё§ "..",  ЕшЖБ ГЯ°Ў 
		util.textBox_setToolTipWithShortString(EnsoulDefaultWnd_WeaponName_TextBox, FullName);
		clearEnsoulStoneSlot();
		// БэИҐј® іЦґВ »уЕВ·О єЇ°ж
		setWindowStateSetting(STATE_INSERT_ENSOULSTONE);

		//// №«±вїЎ АыїлµЗѕо АЦґВ БэИҐ Б¤єёё¦ UIїЎј­ ЗҐЅГЗСґЩ.
		applyWeaponEnsoulInfo(Info);
	}
}

// БэИҐј® іЦ±в
function InsertEnsoulStone(int SlotIndex, ItemInfo eInfo)
{
	// local int i;

	local EnsoulStoneUIInfo refEnsoulStoneUIInfo;
	// local ItemWindowHandle targetItemWndow;
	local ItemInfo weaponInfo, nullInfo;

	PlaySound("ItemSound3.enchant_input");
	// End:0x7D
	if(getItemSlotInfo(0).Id.ClassID <= 0)
	{
		Debug("error : InsertEnsoulStone(..) --> 무기를 넣으세요");
		AddSystemMessage(4326);
		return;
	}

	// БэИҐј® ЕёАФАМ ѕЖґП¶уёй Гіё® ѕИЗФ.
	// End:0xD8
	if(eInfo.EtcItemType != int(EEtcItemType.ITEME_ENSOUL_STONE))
	{
		Debug("error : InsertEnsoulStone(..) --> 집혼석이 아닙니다");
		AddSystemMessage(4329);
		return;
	}

	// јц·®јє АМёй №«Б¶°З 1°іё¦ іЦАє °НАё·О Гіё®ЗСґЩ.
	if(IsStackableItem(eInfo.ConsumeType))
	{
		eInfo.ItemNum = 1;
	}

	GetEnsoulStoneUIInfo(getItemSlotInfo(0), eInfo.Id, refEnsoulStoneUIInfo);
	Debug("넣은 아이템의 슬롯 타입 refEnsoulStoneUIInfo.SlotType" @ string(refEnsoulStoneUIInfo.slotType));
	// End:0x17E
	if(refEnsoulStoneUIInfo.OptionId_Array.Length == 0)
	{
		AddSystemMessage(13683);
		return;
	}
	// БэИҐј® Б¤єё ѕт±в
	// End:0x355
	if(refEnsoulStoneUIInfo.slotType == EIST_NORMAL)
	{
		// АП№Э ЅЅ·ФАМ 2°і АП¶§, 1°і АП¶§ґВ BMЅЅ·Ф°ъ µїАПЗП°Ф їтБчї©ѕЯ ЗСґЩ.
		// End:0x241
		if(normalSlotCount >= 2)
		{
			// 1№ш, 2№ш, normal ЅЅ·ФАМ єсѕъґЩёй 1№ш ЅЅ·ФїЎ іЦ±в.
			// End:0x1A1
			if(! hasItemInSlot(1) && ! hasItemInSlot(2))
			{
				SlotIndex = 1;
			}
			else if(SlotIndex == 3 || SlotIndex == -1)
			{
				// 1№ш ЅЅ·ФАМ єсѕо АЦ°н, 2№шАМ µйѕо АЦґЩёй 1№шїЎ іЦ±в
				if(!hasItemInSlot(1)&& hasItemInSlot(2))SlotIndex = 1;
				// 1№ш ЅЅ·ФАМ µйѕо АЦ°н, 2№шАМ єсѕо АЦґЩёй 
				else if(hasItemInSlot(1)&& !hasItemInSlot(2))slotIndex = 2;
				else 
				{
					// АЯёшµИ ЕёАФАЗ ЅЅ·ФїЎ БэИҐј® µо·ПА» ЅГµµЗТ ¶§
					if(SlotIndex == 3 && refEnsoulStoneUIInfo.slotType == EIST_NORMAL)
					{
						// АЯёшµИ БэИҐј®АФґПґЩ.
						AddSystemMessage(4349);
					}
					else
					{
						// µо·П °ЎґЙЗС ЅЅ·ФА» ёрµО »зїлЗЯЅАґПґЩ. ґЬ, АзБэИҐАО °жїмїЎґВ АзБэИҐЗТ ЅЅ·ФїЎ БэИҐј®А» БчБў ІшѕоґЩ іЦА» јц АЦЅАґПґЩ.
						AddSystemMessage(4350);
					}

					// Debug("БЯБц.."@ slotIndex);
					return;  // ЅЅ·ФАМ 1,2№ш Вч АЦАёёй ѕЖ№«°Нµµ ѕИЗСґЩ.
				}
			}
		}
		// АП№Э ЅЅ·ФАМ ѕшґЩёй..
		else if(normalSlotCount <= 0)
		{
			// АЯёшµИ БэИҐј®АФґПґЩ.
			AddSystemMessage(4349);

			return;  // ЅЅ·ФАМ ѕшАёґП ѕЖ№«°Нµµ ѕИЗФ.
		}
		// 1°і АП¶§ 
		else
		{
			// АЯёшµИ ЕёАФАЗ ЅЅ·ФїЎ БэИҐј® µо·ПА» ЅГµµЗТ ¶§
			if(SlotIndex == 3 && refEnsoulStoneUIInfo.SlotType == EIST_NORMAL)
			{
				// АЯёшµИ БэИҐј®АФґПґЩ.
				AddSystemMessage(4349);
				return;
			}

			// АЦґш ѕшґш №«Б¶°З 1№ш ЅЅ·ФїЎ...
			SlotIndex = 1;
		}

		// №«±вАЗ ЗШґз ЅЅ·ФїЎ їш·Ў БэИҐµИ їЙјЗ °ЄАМ АЦѕъґЩёй..
		// End:0x2CE
		if(checkAlreadyEOptionedSlot(SlotIndex))
		{
			overwriteSlotIndex = SlotIndex;
			overwriteItemInfo = eInfo;
			currentOpenEnsoulStoneSlot = SlotIndex;
			askOverwriteEnsoulOption(true, eInfo);
			return;
		}
		else
		{
			overwriteSlotIndex = 0;
			overwriteItemInfo = nullInfo;
		}

		// ЅЅ·ФАМ 1,2№ш АП¶§ёё іЦґВґЩ.
		if(SlotIndex == 1 || SlotIndex == 2)
		{
			// 1,2№ш АП№Э ЅЅ·ФАМ єсѕо АЦґЩёй..
			setWindowStateSetting(STATE_SELECT_ENSOUL);

			// №«±в ѕЖАМЕЫ Б¤єё 
			weaponInfo = getItemSlotInfo(0);

			// ±вБё ЅЅ·ФА» №«Б¶°З єсїм°н(№«±вїЎ Аыїл µИ °Еёй єсїмБц ёшЗФ)//2016-01-26 ЗШїЬїЎј­ јцБ¤ЗПёйј­ ГЯ°Ў(71824 ttp°ь·Г)
			removeEnsoulStone(SlotIndex, true);

			currentOpenEnsoulStoneSlot = SlotIndex;
			
			// №«±в, БэИҐј®,  Б¤єё·О БэИҐ їЙјЗ ј±ЕГГў ї­±в
			applySelectOptionInEnsoulStone(currentOpenEnsoulStoneSlot, weaponInfo, eInfo, refEnsoulStoneUIInfo);
		}
	}
	else if(refEnsoulStoneUIInfo.SlotType == EIST_BM)
	{

		if(bmSlotCount <= 0)
		{
			// АЯёшµИ БэИҐј®АФґПґЩ.
			AddSystemMessage(4349);
			return;  // ЅЅ·ФАМ ѕшАёґП ѕЖ№«°Нµµ ѕИЗФ.
		}
		else
		{
			// bmАє ЗПіЄАМ±в ¶§№®їЎ №«Б¶°З 3№ш ЅЅ·Ф
			SlotIndex = 3;

			// №«±вАЗ ЗШґз ЅЅ·ФїЎ їш·Ў БэИҐµИ їЙјЗ °ЄАМ АЦѕъґЩёй..
			if(checkAlreadyEOptionedSlot(SlotIndex))
			{
				overwriteSlotIndex = SlotIndex;
				overwriteItemInfo = eInfo;

				askOverwriteEnsoulOption(true, eInfo);
				// Debug("µ¤ѕоѕІ±в №°ѕоєё±в!");
				return;
			}
			else
			{
				overwriteSlotIndex = 0;
				overwriteItemInfo = nullInfo;
			}
			
			currentOpenEnsoulStoneSlot = SlotIndex;
			setWindowStateSetting(STATE_SELECT_ENSOUL);

			// №«±в ѕЖАМЕЫ Б¤єё 
			weaponInfo = getItemSlotInfo(0);

			currentOpenEnsoulStoneSlot = SlotIndex;

			// №«±в, БэИҐј®,  Б¤єё·О БэИҐ їЙјЗ ј±ЕГГў ї­±в

			applySelectOptionInEnsoulStone(currentOpenEnsoulStoneSlot, weaponInfo, eInfo, refEnsoulStoneUIInfo);

			// Debug("BM Apply!!");
		}
	}
}

/**
 *  БэИҐј® ЅЅ·ФїЎ ј±ЕГµИ °ЄА» Гв·В, »иБ¦ Гіё®
 **/
function setEnsoulSlotText(int SlotIndex, EnsoulOptionUIInfo eOptionInfo, optional bool bDelete, optional string applyAddString, optional Color applyColor)
{
	local TextBoxHandle soulNameTextBox, soulDescTextBox;
	local CustomTooltip cTooltip;

	// End:0x24
	if(SlotIndex == 1)
	{
		soulNameTextBox = EnsoulDefaultWnd_SoulName1_TextBox;
		soulDescTextBox = EnsoulDefaultWnd_Soul1_TextBox;
	}
	else if(SlotIndex == 2)
	{
		soulNameTextBox = EnsoulDefaultWnd_SoulName2_TextBox;
		soulDescTextBox = EnsoulDefaultWnd_Soul2_TextBox;

	}
	else if(SlotIndex == 3)
	{ 
		soulNameTextBox = EnsoulDefaultWnd_SoulName3_TextBox;
		soulDescTextBox = EnsoulDefaultWnd_Soul3_TextBox;
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
		// End:0x130
		if(eOptionInfo.OptionStep > 0)
		{
			// ѕЖАМЕЫ АМё§
			util.textBox_setToolTipWithShortString(soulNameTextBox, MakeFullSystemMsg(GetSystemMessage(4347), applyAddString $ eOptionInfo.Name, string(eOptionInfo.OptionStep)));
		}
		else
		{
			util.textBox_setToolTipWithShortString(soulNameTextBox, applyAddString $ eOptionInfo.Name);
		}

		// јіён
		util.textBox_setToolTipWithShortString(soulDescTextBox, eOptionInfo.Desc);

		// јіён ЕшЖБ Аыїл
		addToolTipDrawList(cTooltip, addDrawItemTexture(eOptionInfo.IconPanelTex, false, false, 2));
		addToolTipDrawList(cTooltip, addDrawItemTexture(eOptionInfo.Icontex, false, false, -16));
		addToolTipDrawList(cTooltip, addDrawItemText(eOptionInfo.Name, util.White, "", false));
		addToolTipDrawList(cTooltip, addDrawItemText(" : ", util.White, "", false));
		addToolTipDrawList(cTooltip, addDrawItemText(eOptionInfo.Desc, util.ColorDesc, "", false));
		addToolTipDrawList(cTooltip, addDrawItemBlank(1));
		soulDescTextBox.SetTooltipType("text");
		soulDescTextBox.SetTooltipCustomType(cTooltip);
	}
}

// №«±в ЅЅ·ФА» єсїм°н, ѕЖАМЕЫАМ АЦґЩёй ј­єк ѕЖАМЕЫ №«±вГўїЎ ґЩЅГ іЦѕоБШґЩ.
function removeEnsoulStone(int SlotIndex, optional bool noSystemMessage)
{
	local ItemWindowHandle targetItemWnd;
	local TextBoxHandle soulNameTextBox, soulDescTextBox;
	local EnsoulOptionUIInfo eOptionInfo;
	local ItemInfo tmInfo;
	local ItemEnsoulRequest nullItemEnsoulRequestInfo; // ГК±вИ­їл

	// 1№ш ЅЅ·ФАМ єьБъ¶§ 2№ш ЅЅ·ФАМ µйѕо АЦґЩёй 1№ш ЅЅ·ФАё·О АМµї ЗТБц..
	local bool needSwapSlot;

	// АМ№М АыїлµИ Иї°ъё¦ »©·Б°н ЗПёй ѕИµЗµµ·П..
	// End:0x6D
	if(getItemSlotWindow(SlotIndex).GetItemNum() > 0)
	{
		tmInfo = getItemSlotInfo(SlotIndex);
		// End:0x6D
		if(tmInfo.Id.ClassID <= 0 && tmInfo.Name == "")
		{
			// БэИҐ Иї°ъ°Ў АыїлµИ ѕЖАМЕЫА» »©·Б°н ЗТ¶§..
			// End:0x6B
			if(noSystemMessage == false)
			{
				AddSystemMessage(4348);
			}
			return;
		}
	}

	// ГлјТ ЗПёй БЄЅєЕж јц·®µµ ЗШґз ЅЅ·ФїЎј­ »иБ¦ ЗСґЩ.
	slotJamStoneFee[SlotIndex - 1].ClassID = 0;
	slotJamStoneFee[SlotIndex - 1].Fee = 0;
	// End:0xEF
	if(SlotIndex == 1)
	{
		targetItemWnd = EnsoulDefaultWnd_Item2_ItemWnd;
		soulNameTextBox = EnsoulDefaultWnd_SoulName1_TextBox;
		soulDescTextBox = EnsoulDefaultWnd_Soul1_TextBox;
		itemEnsoulRequestInfo[0] = nullItemEnsoulRequestInfo;

		// 1№ш ЅЅ·ФА» –E¶§, 2№ш ЅЅ·ФАМ Вч АЦґЩёй , 2№ш ЅЅ·ФА» 1№шАё·О АМµї ЅГЕІґЩ.
		// End:0xEC
		if(itemEnsoulRequestInfo[1].selectedOptionID > 0)
		{
			needSwapSlot = true;
		}
	}
	else if(SlotIndex == 2)
	{
		targetItemWnd = EnsoulDefaultWnd_Item3_ItemWnd;
		soulNameTextBox = EnsoulDefaultWnd_SoulName2_TextBox;
		soulDescTextBox = EnsoulDefaultWnd_Soul2_TextBox;
		itemEnsoulRequestInfo[1] = nullItemEnsoulRequestInfo;
	}
	else if(SlotIndex == 3)
	{ 
		targetItemWnd = EnsoulDefaultWnd_ItemBM_ItemWnd;
		soulNameTextBox = EnsoulDefaultWnd_SoulName3_TextBox;
		soulDescTextBox = EnsoulDefaultWnd_Soul3_TextBox;

		itemEnsoulRequestInfo[2] = nullItemEnsoulRequestInfo;
	}

	// End:0x1B8
	if(SlotIndex > 0)
	{
		if(targetItemWnd.GetItemNum()> 0)
		{
			// БцБ¤ЗС ѕЖАМЕЫА» їЬєО АОєҐЕдё®їЎ ґЩЅГ µ№·ББЬ.
			util.ItemWIndow_ItemMoveByIndex(targetItemWnd, EnsoulSubWnd_EnsoulItemWindow, 0, true);
			
			// ЗШґз ЅЅ·Ф ЕШЅєЖ® №ЪЅє ГК±вИ­
			textBoxClear(soulNameTextBox);
			textBoxClear(soulDescTextBox);
		}	
	}

	// End:0x1D3
	if(isChangedWeaponEnsoulOption())
	{
		EnsoulCancelBtn.EnableWindow();		
	}
	else
	{
		EnsoulCancelBtn.DisableWindow();
	}

	// ЅЅ·ФА» °­Б¦·О »©БЦёй ёёѕаїЎ їш·Ў °ЄАМ АЦѕъґЩёй ґЩЅГ є№їшЗШБаѕЯ ЗСґЩ. 
	// End:0x1FF
	if(checkAlreadyEOptionedSlot(SlotIndex))
	{
		applyWeaponEnsoulInfo(getItemSlotInfo(0));

		// Debug("ЅЅ·Ф є№їш ДЪµе ");
		return;
	}

	// 1№ш ЅЅ·ФАМ єьБц°н, 2№ш ЅЅ·ФА» 1№шАё·О і»ё®±в 
	// End:0x29F
	if(needSwapSlot)
	{
		swapItemWithSubInven(getItemSlotWindow(2), getItemSlotWindow(1), getItemSlotInfo(2));
		
		util.ItemWIndow_ItemMoveByIndex(getItemSlotWindow(2), getItemSlotWindow(1), 0);
		
		// 1№ш ЅЅ·ФїЎ Б¤єёµй °»ЅЕЗП°н ЕШЅєЖ® ЗКµеµµ °»ЅЕ 
		itemEnsoulRequestInfo[0] = itemEnsoulRequestInfo[1];
		itemEnsoulRequestInfo[1] = nullItemEnsoulRequestInfo;
		itemEnsoulRequestInfo[0].clientSlotIndex = 1; // ЅЅ·Ф АОµ¦Ѕєµµ 1·О єЇ°ж.

		GetEnsoulOptionUIInfo(itemEnsoulRequestInfo[0].selectedOptionID, eOptionInfo);
		
		// 1№ш ЅЅ·ФїЎ Б¤єё °»ЅЕ, 2№ш ЅЅ·Ф ЕШЅєЖ®µй »иБ¦
		setEnsoulSlotText(1, eOptionInfo);
		setEnsoulSlotText(2, eOptionInfo, true);
	}
}

//// №иї­їЎ ЖЇБ¤ ЅЅ·ФАМ АЦґЩёй »иБ¦ ЗПґВ ЗФјц
//function removeItemEnsoulRequestInfo()
//{

//}

// №«±в ЅЅ·ФА» єсїм°н, ѕЖАМЕЫАМ АЦґЩёй ј­єк ѕЖАМЕЫ №«±вГўїЎ ґЩЅГ іЦѕоБШґЩ.
function removeWeaponItem()
{
	// End:0x4E
	if(getItemSlotWindow(0).GetItemNum() > 0)
	{
		// №«±в ЅЅ·Ф ѕЖАМЕЫА» їЬєО АОєҐЕдё®їЎ ґЩЅГ µ№·ББЬ.
		util.ItemWIndow_ItemMoveByIndex(getItemSlotWindow(0), EnsoulSubWnd_WeaponItemWindow, 0);

		// ґЩЅГ №«±в ГЯ°Ў »уЕВ·О
		setWindowStateSetting(STATE_INSERT_WEAPON);
	}
}

// №«±в ЅЅ·Ф »иБ¦
function clearWeponSlot()
{
	getItemSlotWindow(0).Clear();

	// №«±в АМё§ ЕШЅєЖ® №ЪЅє ГК±вИ­
	textBoxClear(EnsoulDefaultWnd_WeaponName_TextBox);
}

// БэИҐј® ЅЅ·Фµй »иБ¦
function clearEnsoulStoneSlot()
{
	// БэИҐј® ЅЅ·Фµй АП№Э, BM
	getItemSlotWindow(1).Clear();
	getItemSlotWindow(2).Clear();
	getItemSlotWindow(3).Clear();

	textBoxClear(EnsoulDefaultWnd_Soul1_TextBox);
	textBoxClear(EnsoulDefaultWnd_Soul2_TextBox);
	textBoxClear(EnsoulDefaultWnd_Soul3_TextBox);

	textBoxClear(EnsoulDefaultWnd_SoulName1_TextBox);
	textBoxClear(EnsoulDefaultWnd_SoulName2_TextBox);
	textBoxClear(EnsoulDefaultWnd_SoulName3_TextBox);
}

// БцБ¤ЗС АОєҐ°ъ ѕЖАМЕЫ ±іГј
function swapItemWithSubInven(ItemWindowHandle targetItemWnd, ItemWindowHandle subInvenItemWnd, ItemInfo Info)
{
	// АМ№М ґЩёҐ №«±в°Ў µйѕо АЦґЩёй..
	// End:0x2F
	if(targetItemWnd.GetItemNum() > 0)
	{
		// єёБ¶ ѕЖАМЕЫ А©µµїм їЎј­ №«±в ѕЖАМЕЫїшµµїм А» -> БэИҐ АОєҐ єёБ¶ ѕЖАМЕЫ А©µµїмїЎ АМµї		
		util.ItemWIndow_ItemMoveByIndex(targetItemWnd, subInvenItemWnd, 0);
	}

	targetItemWnd.Clear();

	// єёБ¶ АОєҐ(БэИҐ)-> БэИҐЗТ їЙјЗАМ ј±ЕГµИ АОєҐАё·О Аыїл
	util.ItemWIndow_ItemMoveByItemID(subInvenItemWnd, targetItemWnd, Info.Id);
}

// ј±ЕГµИ БэИҐ їЙјЗ, Аыїл
function applySelectdEnsoulOption(int SlotIndex, ItemInfo eStoneitemInfo, int selectedOptionID)
{
	local ItemWindowHandle targetItemWndow;
	local EnsoulOptionUIInfo eOptionInfo;
	local ItemEnsoulRequest tempItemEnsoulRequest;

	targetItemWndow = getItemSlotWindow(SlotIndex);
	
	targetItemWndow.Clear();
	targetItemWndow.AddItem(eStoneitemInfo);

	// єёБ¶ АОєҐїЎј­ Её°Щ АОєҐАё·О БэИҐј®А» іЦґВґЩ.
	//swapItemWithSubInven(EnsoulSubWnd_EnsoulItemWindow, targetItemWndow, eStoneitemInfo);

	GetEnsoulOptionUIInfo(selectedOptionID, eOptionInfo);

	// µ¤ѕоѕґ °жїм,(АзБэИҐ)АМ·± ЗҐЅГё¦ ЗШБШґЩ.
	// End:0x8B
	if(SlotIndex == overwriteSlotIndex)
	{
		setEnsoulSlotText(SlotIndex, eOptionInfo,, "(" $ GetSystemString(3395) $ ") ", util.ColorYellow);
	}
	else
	{
		setEnsoulSlotText(SlotIndex, eOptionInfo,,, util.ColorYellow);
	}

	// ЅЅ·ФїЎ ЗцАз АыїлµИ Б¤єёё¦ АъАеЗШіхґВґЩ.
	selectedOptionSlotArray[SlotIndex - 1] = eOptionInfo;
	tempItemEnsoulRequest.ensoulStoneServerID = eStoneitemInfo.Id.ServerID;
	tempItemEnsoulRequest.selectedOptionID = selectedOptionID;

	tempItemEnsoulRequest.selectedOptionType = eOptionInfo.OptionType;
	tempItemEnsoulRequest.clientSlotIndex = getSlotIndexForClient(SlotIndex);
	tempItemEnsoulRequest.clientSlotType = getSlotTypeForClient(SlotIndex);

	itemEnsoulRequestInfo[SlotIndex - 1] = tempItemEnsoulRequest;

	// Debug("==>itemEnsoulRequestInfo[slotIndex - 1].ensoulStoneServerID"  @ itemEnsoulRequestInfo[slotIndex - 1].ensoulStoneServerID);
}

// №«±вАЗ БэИҐ Б¤єёё¦ UIїЎ ЗҐЅГ ЗСґЩ.
function applyWeaponEnsoulInfo(ItemInfo Info)
{
	local int N, i, Cnt, optionId, rIndex;

	local EnsoulOptionUIInfo optionInfo;
	local ItemInfo esInfo;

	alreadyHasOptionSlotArray.Length = 0;

	// ј±ЕГµИ їЙјЗ °Є ГК±вИ­
	selectedOptionSlotArray.Length = 0;
	selectedOptionSlotArray.Length = 3;

	// °ў ЅЅ·Фё¶ґЩ ЗКїд АлЅєЕж јц·®
	slotJamStoneFee.Length = 0;
	slotJamStoneFee.Length = 3;
	slotJamStoneFee[0].ClassID = 0;
	slotJamStoneFee[0].Fee = 0;
	slotJamStoneFee[1].ClassID = 0;
	slotJamStoneFee[1].Fee = 0;
	slotJamStoneFee[2].ClassID = 0;
	slotJamStoneFee[2].Fee = 0;

	// Normal, BM °ў ЕёАФє°
	for(i=EIST_NORMAL; i < EIST_MAX; i++)
	{
		// °ў ЕёАФАЗ їЙјЗ јц
		cnt = Info.EnsoulOption[i - EIST_NORMAL].OptionArray.Length;

		for(N = EISI_START; N < EISI_START + Cnt; N++)
		{
			optionId = Info.EnsoulOption[i - EIST_NORMAL].OptionArray[n - EISI_START];
			Debug("무기 조회 optionID" @ string(optionId));

			// БэИҐ їЙјЗїЎ ґлЗС Б¤єёё¦ АРґВґЩ.
			// End:0x139
			if(optionId > 0)
			{
				GetEnsoulOptionUIInfo(optionId, optionInfo);				
			}
			else
			{
				// [Explicit Continue]
				continue;
			}

			// №«±вїЎ АМ№М АыїлµЗѕо АЦґш їЙјЗА» іЦґВґЩ.
			// End:0x36B
			if(optionId > 0)
			{
				alreadyHasOptionSlotArray.Length = alreadyHasOptionSlotArray.Length + 1;
				alreadyHasOptionSlotArray[alreadyHasOptionSlotArray.Length - 1].Info = Info; // №«±в Б¤єё
				alreadyHasOptionSlotArray[alreadyHasOptionSlotArray.Length - 1].eOptionUIInfo = optionInfo;
				
				alreadyHasOptionSlotArray[alreadyHasOptionSlotArray.Length - 1].slotType = i;

				// 1,2,3 ЅЅ·ФАё·О index°ЄА» єЇИЇ
				// bm ЅЅ·ФАє 1°і АМґЩ. №«Б¶°З 3АМґЩ.
				// End:0x1BC
				if(i == EIST_BM)
				{
					rIndex = 3;
				}
				else
				{
					rIndex = N;
				}

				alreadyHasOptionSlotArray[alreadyHasOptionSlotArray.Length - 1].SlotIndex = rIndex;
				esInfo.IconName = optionInfo.Icontex;
				// End:0x2EF
				if(i == EIST_NORMAL)
				{
					// 1№шВ° Д­ єОЕН Г¤їм±в
					// End:0x27C
					if(N == EISI_START)
					{
						// End:0x279
						if(getItemSlotWindow(1).GetItemNum() == 0)
						{
							// Debug("ЅЅ·Ф 1Г¤їм±в");
							getItemSlotWindow(1).AddItem(esInfo);
							setEnsoulSlotText(1, optionInfo,,"(" $ GetSystemString(3351)$ ")", util.ColorLightBrown);
							EnsoulDefaultWnd_SlotBg1Light_Texture.ShowWindow();
						}
					}
					// 2№шВ° Д­
					else
					{
						// Debug("n°Є "@n);
						if(getItemSlotWindow(2).GetItemNum()== 0)
						{
							// Debug("ЅЅ·Ф 2Г¤їм±в");
							getItemSlotWindow(2).AddItem(esInfo);
							setEnsoulSlotText(2, optionInfo,,"(" $ GetSystemString(3351)$ ")", util.ColorLightBrown);
							EnsoulDefaultWnd_SlotBg2Light_Texture.ShowWindow();
						}
					}
				}
				// BM ЅЅ·ФАє ЗС°іАМґЩ.
				else if(i == EIST_BM)
				{
					/// Debug("bm");
					if(getItemSlotWindow(3).GetItemNum()== 0)
					{
						getItemSlotWindow(3).AddItem(esInfo);
						setEnsoulSlotText(3, optionInfo,,"(" $ GetSystemString(3351)$ ")", util.ColorLightBrown);
						//EnsoulDefaultWnd_SoulName3_TextBox.SetText(optionInfo.name);
						//EnsoulDefaultWnd_Soul3_TextBox.SetText(optionInfo.desc);
						EnsoulDefaultWnd_SlotBg3Light_Texture.ShowWindow();
					}
				}
			}
		}		
	}
}

// Е¬¶уВКїЎ ґЩЅГ єёі»БЦѕоѕЯ ЗПґВ ЅЅ·Ф АОµ¦Ѕє
// slotNumberґВ 
function int getSlotIndexForClient(int SlotIndex)
{
	local int RValue;

	// End:0x27
	if(SlotIndex == 1 || SlotIndex == 2)
	{
		RValue = SlotIndex;	
	}
	else if(SlotIndex == 3)RValue = 1;              // BM
	else Debug("Error : getSlotIndexForClient ->" @ SlotIndex);
	return RValue;
}

// Е¬¶уВКїЎ ґЩЅГ єёі»БЦѕоѕЯ ЗПґВ ЅЅ·Ф АОµ¦Ѕє
// slotNumberґВ 
function int getSlotTypeForClient(int SlotIndex)
{
	local int RValue;

	if(slotIndex == 1 || SlotIndex == 2)RValue = EIST_NORMAL;
	else if(SlotIndex == 3)RValue = EIST_BM;
	else Debug("Error : getSlotTypeForClient ->" @ SlotIndex);
	return RValue;
}

// БэИҐј®АЗ їЙјЗА» ј±ЕГЗП°Ф ЗПµµ·П БэИҐј®АЗ Б¤єёё¦ јјЖГЗСґЩ
function applySelectOptionInEnsoulStone(int SlotIndex, ItemInfo weaponInfo, ItemInfo eInfo, EnsoulStoneUIInfo esInfo, optional bool isOverwriteOption)
{
	local EnsoulOptionUIInfo optionInfo;
	local EnsoulFeeUIInfo ensoulFeeInfo;

	local int i;

	local LVDataRecord Record;
	local ItemInfo jamStoneInfo, InvenJamStoneInfo;

	// ґЩёҐ ЅЅ·ФїЎј­ »зїлЗС АлЅєЕж ГСЗХ.
	local INT64 decUseJamStone;

	local string jamStoneValueComma;
	local UIMapInt64Object ensoulFeeMap;

	ensoulFeeMap = new class'UIMapInt64Object';
	ensoulFeeMap.RemoveAll();
	EnsoulOptionWnd_ListCtrl.DeleteAllItem();
	EnsoulOptionWnd_ListCtrl.ShowWindow();
	// №«±в, БэИҐј® АМё§
	util.textBox_setToolTipWithShortString(EnsoulOptionWnd_WeaponName_TextBox, weaponInfo.Name);
	util.textBox_setToolTipWithShortString(EnsoulOptionWnd_SoulName_TextBox, eInfo.Name);

	// їЙјЗ ЖЛѕчГўїЎ №«±в ѕЖАМЕЫ
	EnsoulOptionWnd_ITEM1_ItemWnd.Clear();
	EnsoulOptionWnd_ITEM1_ItemWnd.AddItem(weaponInfo);

	// їЙјЗ ЖЛѕчГўїЎ БэИҐј® ЅЅ·Ф
	EnsoulOptionWnd_ITEM2_ItemWnd.Clear();
	EnsoulOptionWnd_ITEM2_ItemWnd.AddItem(eInfo);
	Debug("esinfo.OptionId_Array.Length" @ esInfo.OptionId_Array.Length);

	// End:0x471 [Loop If]
	for(i = 0; i < esInfo.OptionId_Array.Length; i++)
	{
		GetEnsoulOptionUIInfo(esInfo.OptionId_Array[i], optionInfo);
		// АзБэИҐ µЗґВ °жїм: 
		// 1.їЙјЗ ЕёАФАё·О ј±ЕГЗТ БэИҐ ёс·ПА» Б¦ЗС ЗПБц ѕК°н, °°Ає їЙјЗ ѕЖАМµр°Ў ѕшАёёй »зїлА» ЗСґЩ.(БэИҐ ґЬ°иё¦ їГё®ґВ ЅДАё·О »зїл)

		// -_-.. ЗПґЩ єёґП.. µ¤ѕоѕІ±в¶ы іЄґ­ ЗКїд°Ў ѕш°Ф µИµн..-_-.. И¤ЅГ №ц±Ч АЦА»±оєБ АПґЬ іЄµРґЩ. іЄБЯїЎ №ц±Ч ѕшАёёй µСАМ ЗХДЎёй µЗ°ЪґЩ.
		if(isOverwriteOption == true && 
		   	hasSelectedEnsoulOptionTypeOtherSlot(optionInfo.OptionType, SlotIndex)== false &&
			hasSelectedEnsoulOptionIdOtherSlot(optionInfo.OptionID)== false &&
		 	hasWeaponOptionTypeOtherSlot(optionInfo.OptionType, SlotIndex)== false &&
			hasWeaponOptionIdOtherSlot(optionInfo.OptionID)== false)
		{
			Record.LVDataList.Length = 1;
			Record.LVDataList[0].bUseTextColor = true;
			Record.LVDataList[0].TextColor = util.ColorDesc;
			// End:0x237
			if(optionInfo.OptionStep > 0)
			{
				Record.LVDataList[0].szData = makeShortStringByPixel(MakeFullSystemMsg(GetSystemMessage(4347), optionInfo.Name, string(optionInfo.OptionStep)), 230, "..");
			}
			else
			{
				Record.LVDataList[0].szData = makeShortStringByPixel(optionInfo.Name, 230, "..");
			}
			Record.LVDataList[0].nReserved1 = optionInfo.OptionType;    // БэИҐ ЕёАФ : АП№Э, BM
			Record.LVDataList[0].nReserved2 = esInfo.OptionId_Array[i]; // БэИҐ їЙјЗ ID

			Debug("리스트에 넣는다. .Name" @ optionInfo.Name);
			EnsoulOptionWnd_ListCtrl.InsertRecord(Record);
 		}

		// ґЩёҐ ЅЅ·ФїЎ БэИҐµИ БэИҐ ЕёАФА» ј±ЕГ ёшЗСґЩ.
		// ґЩёҐ ЅЅ·ФїЎј­ ј±ЕГЗС їЙјЗ ЕёАФАє БЯє№Аё·О ј±ЕГ ёшЗПµµ·П ёс·ПїЎј­ »«ґЩ.
		else if(isOverwriteOption == false && 
			   	 hasSelectedEnsoulOptionTypeOtherSlot(optionInfo.OptionType, SlotIndex)== false && 
				 hasSelectedEnsoulOptionIdOtherSlot(optionInfo.OptionID)== false &&
		 		 hasWeaponOptionTypeOtherSlot(optionInfo.OptionType, SlotIndex)== false &&
				 hasWeaponOptionIdOtherSlot(optionInfo.OptionID)== false)

		{
			Record.LVDataList.Length = 1;
			Record.LVDataList[0].bUseTextColor = true;
			Record.LVDataList[0].TextColor = util.ColorDesc;
			// End:0x3ED
			if(optionInfo.OptionStep > 0)
			{
				Record.LVDataList[0].szData = makeShortStringByPixel(MakeFullSystemMsg(GetSystemMessage(4347), optionInfo.Name, string(optionInfo.OptionStep)), 230, "..");
			}
			else
			{
				Record.LVDataList[0].szData = makeShortStringByPixel(optionInfo.Name, 230, "..");
			}
			Record.LVDataList[0].nReserved1 = optionInfo.OptionType;    // БэИҐ ЕёАФ : АП№Э, BM
			Record.LVDataList[0].nReserved2 = esInfo.OptionId_Array[i]; // БэИҐ їЙјЗ ID

			EnsoulOptionWnd_ListCtrl.InsertRecord(Record);
		}
	}
	GetEnsoulFeeUIInfo(weaponInfo, eInfo, checkAlreadyEOptionedSlot(SlotIndex), esInfo.slotType, getSlotIndexForClient(SlotIndex), ensoulFeeInfo);
	inventoryWndScript.getInventoryItemInfo(GetItemID(ensoulFeeInfo.nID), InvenJamStoneInfo);

	// БЄЅєЕж ѕЖАМЕЫ Б¤єё ѕт±в
	class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(ensoulFeeInfo.nID), jamStoneInfo);

	// ЗШґз °Ў°Э ±вѕп ЗП±в
	slotJamStoneFee[SlotIndex - 1].ClassID = ensoulFeeInfo.nID;
	slotJamStoneFee[SlotIndex - 1].Fee = ensoulFeeInfo.ItemCount;

	// 1,2,3№ш ЅЅ·ФїЎј­ »зїлЗС АлЅєЕж ЗХДЎ±в
	for(i = 0; i < 3; i++)
	{
		if(SlotIndex !=(i + 1))
		{
			if(ensoulFeeInfo.nID == slotJamStoneFee[i].ClassID)
			{
				decUseJamStone = decUseJamStone + slotJamStoneFee[i].Fee;
			}
		}
	}

	util.textBox_setToolTipWithShortString(EnsoulOptionWnd_Charge1_TextBox, jamStoneInfo.Name);

	EnsoulOptionWnd_Charge2_TextBox.SetText("x" @ string(ensoulFeeInfo.ItemCount));

	EnsoulCancelBtn.EnableWindow();
	// End:0x634
	if(ensoulFeeInfo.ItemCount <= (InvenJamStoneInfo.ItemNum - decUseJamStone))
	{
		EnsoulOptionWnd_Charge3_TextBox.SetTextColor(GetColor(85, 170, 255, 255));
		EnsoulOK_Button.EnableWindow();
	}
	else
	{
		EnsoulOptionWnd_Charge3_TextBox.SetTextColor(GetColor(255, 0, 0, 255));
		EnsoulDiscription_TextBox.SetText(MakeFullSystemMsg(GetSystemMessage(1473), jamStoneInfo.Name));
		EnsoulOK_Button.DisableWindow();
	}

	EnsoulOptionWnd_Charge3_TextBox.SetText("(" $ maxCountLimitString(InvenJamStoneInfo.ItemNum - decUseJamStone, 9999, "9999+")$ ")");
	// End:0x72A
	if(InvenJamStoneInfo.ItemNum > 9999)
	{
		jamStoneValueComma = MakeCostString(string(InvenJamStoneInfo.ItemNum - decUseJamStone));
		EnsoulOptionWnd_Charge3_TextBox.SetTooltipType("text");
		EnsoulOptionWnd_Charge3_TextBox.SetTooltipText(jamStoneValueComma);
	}
	else
	{
		EnsoulOptionWnd_Charge3_TextBox.SetTooltipType("");
		EnsoulOptionWnd_Charge3_TextBox.SetTooltipText("");
	}

	//decUseJamStone = decUseJamStone + ensoulFeeInfo.ItemCount;
}

// ґюѕо ѕІ±в №°ѕо єё±в И®АОГў јјЖГ
function askOverwriteEnsoulOption(bool bShow, optional ItemInfo Info)
{
	local ItemInfo tempInfo;

	if(bShow)
	{
		DisableWnd.ShowWindow();
		DisableWnd.SetFocus();

		tempInfo.IconName = "L2UI_ct1.Icon.ICON_DF_Exclamation";

		//setWindowStateSetting(STATE_ASK_OVERWRITE);
		
		EnsoulWnd_ResultWnd.ShowWindow();
		//233, 171
		EnsoulWnd_ResultWnd.SetWindowSize(233, 250);

		GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.OK_Button").ShowWindow();
		GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Cancel_Button").ShowWindow();
		GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.singleOK_Button").HideWindow();

		//EnsoulProgress_AnimTex.Pause();
		EnsoulProgress_AnimTex.Stop();		
		EnsoulProgress_AnimTex.HideWindow();
		
		GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").Clear();
		GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").AddItem(tempInfo);
		GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").SetTooltipType("");
		GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").ClearTooltip();

		// АзБэИҐ ЅГ ±вБёАЗ БэИҐ Иї°ъґВ ґх АМ»у АыїлµЗБц ѕКЅАґПґЩ.\n°ијУ БшЗаЗПЅГ°ЪЅАґП±о?
		GetTextBoxHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Discription_TextBox").SetText(GetSystemMessage(4332));
	}
	else
	{
		DisableWnd.HideWindow();
		EnsoulWnd_ResultWnd.HideWindow();
	}
}

//-----------------------------------------------------------------------------------------------------------------------
// ГЦБѕ °б°ъ И®АО Гў -> БэИҐ їП·б. ЅЗЖР Гіё®ё¦ ґгґзЗСґЩ.
//-----------------------------------------------------------------------------------------------------------------------
// БэИҐ °б°ъё¦ И®АО ГўА» ї¬ґЩ.
function confirmResultEnsoulOption(bool bSuccess, ItemInfo Info)
{	
	local ItemInfo tempInfo;
	
	setWindowStateSetting(STATE_RESULT);

	//EnsoulWnd_ResultWnd.ShowWindow();
	//EnsoulWnd_ResultWnd.SetFocus();
	// End:0x29D
	if(bSuccess)
	{
		
		EnsoulWnd_ResultWnd.SetWindowSize(233, 200);

		GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.OK_Button").HideWindow();
		GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Cancel_Button").HideWindow();
		GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.singleOK_Button").ShowWindow();

		// EnsoulProgress_AnimTex.HideWindow();
		// EnsoulProgress_AnimTex.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
		EnsoulProgress_AnimTex.SetLoopCount(1);
		EnsoulProgress_AnimTex.Stop();
		EnsoulProgress_AnimTex.Play();
		PlaySound("ItemSound3.enchant_success");
		EnsoulProgress_AnimTex.ShowWindow();
						
		GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").Clear();
		GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").ClearTooltip();
		GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").AddItem(Info);
		GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").SetTooltipType("Inventory");
		
		// ѕЖАМЕЫ БэИҐїЎ јє°шЗЯЅАґПґЩ.  @ info.name
		GetTextBoxHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Discription_TextBox").SetText(GetSystemMessage(4333));
	}
	else
	{
		PlaySound("ItemSound3.enchant_fail");
		EnsoulWnd_ResultWnd.SetWindowSize(233, 250);
		
		tempInfo.IconName = "L2UI_ct1.Icon.ICON_DF_Exclamation";

		GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.OK_Button").HideWindow();
		GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Cancel_Button").HideWindow();
		GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.singleOK_Button").ShowWindow();

		EnsoulProgress_AnimTex.Stop();
		//EnsoulProgress_AnimTex.Pause();
		EnsoulProgress_AnimTex.HideWindow();

		GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").ShowWindow();
		GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").Clear();
		GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").AddItem(tempInfo);
		GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").SetTooltipType("");
		GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").ClearTooltip();

		// ЅГЅєЕЫ їА·щ·О БшЗаЗТ јц ѕшЅАґПґЩ. АбЅГ ИД ґЩЅГ ЅГµµЗШ БЦјјїд.
		GetTextBoxHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Discription_TextBox").SetText(GetSystemMessage(4334));
	}
}

//-----------------------------------------------------------------------------------------------------------------------
// ГЦБѕ И®АО ё®ЖчЖ® -> БшЗа ї©єОё¦ №°ѕо єёґВ А©µµїм
//-----------------------------------------------------------------------------------------------------------------------
function askEnsoulLastProcess(bool bShow)
{
	local ItemInfo tempInfo, InvenJamStoneInfo, jamStoneInfo;
	local int i, N;
	local EnsoulFeeUIInfo ensoulFeeInfo;
	local EnsoulOptionUIInfo eOptionInfo;
	local UIMapInt64Object ensoulFeeMap;

	ensoulFeeMap = new class'UIMapInt64Object';
	ensoulFeeMap.RemoveAll();
	// End:0x560
	if(bShow)
	{
		EnsouEffectWnd_Before_ListCtrl.DeleteAllItem();
		EnsouEffectWnd_After_ListCtrl.DeleteAllItem();

		// ЗцАз Иї°ъ ё®ЅєЖ® - Г¤їм±в
		for(i = 0; i < alreadyHasOptionSlotArray.Length; i++)
		{
			// єЇ°жµИ їЙјЗёё іЦ±в
			if(isChangedOptionSlot(alreadyHasOptionSlotArray[i].SlotIndex))
			{
				addListESOption(EnsouEffectWnd_Before_ListCtrl, alreadyHasOptionSlotArray[i].eOptionUIInfo, util.ColorLightBrown);
			}

			addListESOption(EnsouEffectWnd_Before_ListCtrl, alreadyHasOptionSlotArray[i].eOptionUIInfo, util.ColorGray);
		}

		// БэИҐ ИД Иї°ъ ё®ЅєЖ® - Г¤їм±в
		for(N = 0; N < 3; N++)
		{
			// АМ№М АыїлµИ ЅЅ·ФАО°Ў?
			if(checkAlreadyEOptionedSlot(N + 1))
			{
				// End:0x13E
				if(isChangedOptionSlot(N + 1))
				{
					eOptionInfo = getChangedOptionUIInfo(N + 1);
					addListESOption(EnsouEffectWnd_After_ListCtrl, eOptionInfo, util.ColorYellow);					
				}
				// їш·Ў АЦґш °Е¶уёй..
				else
				{
					eOptionInfo = getAlreadyHasOptionUIInfo(N + 1);
					// Debug("їш·Ў АЦґш°ЕіД. : " @ eOptionInfo.name);
					if(eOptionInfo.OptionID > 0)
					{
						// Debug("їш·Ў АЦґш°ЕґП Иё»цГіё®·О іЦАЪ: " @ eOptionInfo.name);
						addListESOption(EnsouEffectWnd_After_ListCtrl, eOptionInfo, util.ColorGray);
					}
					else
					{
						eOptionInfo = getAlreadyHasOptionUIInfo(N + 1);
						addListESOption(EnsouEffectWnd_After_ListCtrl, eOptionInfo, util.ColorGray);
					}
				}				
			}
			// »х·О µйѕо°Ј їЙјЗ ѕЖАМµр
			else
			{
				eOptionInfo = getChangedOptionUIInfo(N + 1);
				// Debug("»х·О ЅГµµ : " @ eOptionInfo.name);
				if(eOptionInfo.OptionID > 0)
				{
					addListESOption(EnsouEffectWnd_After_ListCtrl, eOptionInfo, util.ColorYellow);
				}
			}
		}

		// µҐАМЕё°Ў ѕшАёёй "БэИҐ Иї°ъ ѕшАЅ" ЅєЖ®ёµ Впѕо іхАЅ.
		// End:0x235
		if(EnsouEffectWnd_Before_ListCtrl.GetRecordCount() <= 0)
		{
			addListString(EnsouEffectWnd_Before_ListCtrl, "  " $ GetSystemString(3393));
		}

		// ЗКїд БЄЅєЕж ГЦБѕ °б°ъ »кГв
		for(i = 1; i < 4; i++)
		{
			tempInfo = getItemSlotInfo(i);
			// End:0x367
			if(tempInfo.Id.ClassID > 0)
			{
				GetEnsoulFeeUIInfo(getItemSlotInfo(0), tempInfo, checkAlreadyEOptionedSlot(i), getSlotTypeForClient(i), getSlotIndexForClient(i), ensoulFeeInfo);
				inventoryWndScript.getInventoryItemInfo(GetItemID(ensoulFeeInfo.nID), InvenJamStoneInfo);

				// БЄЅєЕж ѕЖАМЕЫ Б¤єё ѕт±в
				class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(ensoulFeeInfo.nID), jamStoneInfo);
				
				ensoulFeeMap.AddIncrease(int64(ensoulFeeInfo.nID), ensoulFeeInfo.ItemCount);
				Debug("ensoulFeeInfo.nID" @ string(ensoulFeeInfo.nID));
				Debug("ensoulFeeInfo.ItemCount" @ string(ensoulFeeInfo.ItemCount));
			}
		}

		needItemScript.SetFormType(needItemScript.FORM_TYPE.normalSideSmall);
		needItemScript.StartNeedItemList(2);

		// End:0x48E [Loop If]
		for(i = 0; i < ensoulFeeMap.Size(); i++)
		{
			needItemScript.AddNeedItemClassID(int(ensoulFeeMap.dataArray[i].Key), ensoulFeeMap.dataArray[i].Data);
			Debug("ensoulFeeMap.dataArray[i].key" @ string(ensoulFeeMap.dataArray[i].Key));
			Debug("ensoulFeeMap.dataArray[i].data" @ string(ensoulFeeMap.dataArray[i].Data));
		}

		needItemScript.SetBuyNum(1);
		Debug("needItemScript.GetCanBuy()" @ string(needItemScript.GetCanBuy()));
		Debug("toString" @ ensoulFeeMap.ToString());
		// End:0x534
		if(needItemScript.GetCanBuy())
		{
			EnsoulDiscription_TextBox.SetText(GetSystemMessage(4335));
			EnsoulOK_Button.EnableWindow();
		}
		else
		{
			EnsoulDiscription_TextBox.SetText(GetSystemMessage(13094));
			EnsoulOK_Button.DisableWindow();
		}
	}
	else
	{
		setWindowStateSetting(STATE_INSERT_ENSOULSTONE);
	}
}

function addListESOption(ListCtrlHandle List, EnsoulOptionUIInfo optionInfo, Color applyColor)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 1;
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].TextColor = applyColor;
	// End:0x96
	if(optionInfo.OptionStep > 0)
	{
		Record.LVDataList[0].szData = "  " $ makeShortStringByPixel(MakeFullSystemMsg(GetSystemMessage(4347), optionInfo.Name, string(optionInfo.OptionStep)), 230, "..");
	}
	else
	{
		Record.LVDataList[0].szData = "  " $makeShortStringByPixel(optionInfo.Name, 230, "..");
	}

	Record.LVDataList[0].nReserved1 = optionInfo.OptionType; // БэИҐ ЕёАФ : АП№Э, BM
	Record.LVDataList[0].nReserved2 = optionInfo.OptionID;   // БэИҐ їЙјЗ ID
	List.InsertRecord(Record);

	// Debug("И®АО--------> optionInfo.Name" @ list.GetWindowName()@ ":"@ optionInfo.Name);
}

function addListString(ListCtrlHandle List, string Str)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 1;
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].TextColor = util.ColorDesc;
	Record.LVDataList[0].szData = Str;
	Record.LVDataList[0].nReserved1 = 0;
	Record.LVDataList[0].nReserved2 = 0;
	List.InsertRecord(Record);
}


//-----------------------------------------------------------------------------------------------------------------------
// ±вЕё  
//-----------------------------------------------------------------------------------------------------------------------

// ґЩАМѕу·О±ЧАЗ ЅГ°ЈАМ ґЩЗЯАЅ
function OnProgressTimeUp(string strID)
{
	// End:0x3E
	if(strID == "EnsoulProgressWnd_ProgressBar")
	{
		EnsoulProgressWnd_ProgressBar.HideWindow();
		requestItemEnsoulProcess();
		// setWindowStateSetting(STATE_RESULT);
	}
}

//  ј­№цїЎ БэИҐ їдГ» єёі»±в
//  БэИҐ ЅГµµ їдГ» API(EnsoulAPI.uc)
//- RequestItemEnsoul(string strParam)
//- param ±ёБ¶
//"TargetItemID" : ґл»у ѕЖАМЕЫ ј­№ц ID
//"NumOfChangedSlot" : №ЩІп ЅЅ·Ф јц
//           "SlotType_%d" : ЅЅ·Ф ЕёАФ(ENSOUL_TYPE_NORMAL / ENSOUL_TYPE_BM)
//           "SlotIndex_%d" : ЕёАФє° ЅЅ·Ф АОµ¦Ѕє №шИЈ(Г№ №шВ° ЅЅ·Ф 1, µО №шВ° ЅЅ·Ф 2)
//           "InputItemID_%d" : БэИҐј® ѕЖАМЕЫ ј­№ц ID
//           "OptionID_%d" : ј±ЕГЗС їЙјЗ ID

function requestItemEnsoulProcess()
{
	local string param;

	param = makeRequestEnsoulParam();

	class'EnsoulAPI'.static.RequestItemEnsoul(param);
	Debug(" 실행 --- class'EnsoulAPI'.static.RequestItemEnsoul() --> param: " @ param);
}

//  ГЯ°Ў µЗ°ЕіЄ єЇЗС їЙјЗАМ АЦіЄ?
function bool isChangedWeaponEnsoulOption()
{
	local string param;
	local int NumOfChangedSlot;

	param = makeRequestEnsoulParam();
	ParseInt(param, "NumOfChangedSlot", NumOfChangedSlot);
	return NumOfChangedSlot > 0;
}

// param 
function string makeRequestEnsoulParam()
{
	local string param;
	local int i, chanagedCount;
	local int targetWeaponServerID;

	chanagedCount = 0;

	// №«±вАЗ ј­№ц ѕЖАМµр
	targetWeaponServerID = getItemSlotInfo(0).Id.ServerID;
	ParamAdd(param, "TargetItemID", string(targetWeaponServerID));

	for(i = 0; i < itemEnsoulRequestInfo.Length;i++)
	{
		if(itemEnsoulRequestInfo[i].ensoulStoneServerID > 0)
		{	
			ParamAdd(param, "SlotType_"    $ chanagedCount, string(itemEnsoulRequestInfo[i].clientSlotType));
			ParamAdd(param, "SlotIndex_"   $ chanagedCount, string(itemEnsoulRequestInfo[i].clientSlotIndex));
			ParamAdd(param, "InputItemID_" $ chanagedCount, string(itemEnsoulRequestInfo[i].ensoulStoneServerID));
			ParamAdd(param, "OptionID_"    $ chanagedCount, string(itemEnsoulRequestInfo[i].selectedOptionID));
			chanagedCount++;
		}
	}

	ParamAdd(param, "NumOfChangedSlot", string(chanagedCount));

	return param;
}

// БэИҐ °б°ъ єёї©БЦґВ ЖЛѕчГў
function showResult(string param)
{
	local int resultValue;
	local ItemInfo weaponInfo;

	local int EnsoulOptionNum;
	local int n,i, nEOptionID;
		
	weaponInfo = getItemSlotInfo(0);

	Debug("이벤트 결과, RequestItemEnsoul 결과 : param" @ param);

	ParseInt(param, "Result", resultValue);

	for(i=EIST_NORMAL; i<EIST_MAX; i++)
	{
		ParseInt(param, "EnsoulOptionNum_" $ i , EnsoulOptionNum);

		for(n=EISI_START; n<EISI_START + EnsoulOptionNum; n++)
		{
			ParseInt(param, "EnsoulOptionID_" $ i $ "_" $ n, nEOptionID);
			weaponInfo.EnsoulOption[i - EIST_NORMAL].OptionArray[n - EISI_START] = nEOptionID;
		}
	}

	if(resultValue > 0)
	{
		confirmResultEnsoulOption(true, weaponInfo);
	}
	else
	{
		confirmResultEnsoulOption(false, getItemSlotInfo(0));
	}

}


// ёрјЗАМ іЎіЄёй јы±в±в.
function OnTextureAnimEnd(AnimTextureHandle a_AnimTextureHandle)
{
	switch(a_AnimTextureHandle.GetWindowName())
	{
		case "EnsoulProgress_AnimTex" :  			 
			// АОГ¦Ж® °Н°ъ µїАПЗП°Ф.. 			 
			 a_AnimTextureHandle.HideWindow();
			 //a_AnimTextureHandle.Stop();
			 break;
	}

	Debug("---------------------OnTextureAnimEnd : " @ a_AnimTextureHandle.GetWindowName());
}

// ЗцАз ЅЅ·ФїЎ ІЕѕЖј­ »зїл БЯАО ѕЖАМЕЫ °ъ °°Ає°Ф АЦіЄ ГјЕ© , ј­єк АОєҐїЎј­ »зїл
function bool externalCheckUsingItem(ItemInfo info, optional out int nStackableNum)
{
	local itemInfo innerItemInfo;
	local bool rValue;

	// №«±в ЅЅ·Ф
	if(getItemSlotWindow(0).GetItemNum()> 0)
	{
		getItemSlotWindow(0).GetItem(0, innerItemInfo);
		if(innerItemInfo.Id == Info.Id)rValue = true;
	}

	// АП№Э БэИҐј® ЅЅ·Ф
	if(getItemSlotWindow(1).GetItemNum()> 0)
	{
		getItemSlotWindow(1).GetItem(0, innerItemInfo);
		if(innerItemInfo.Id == Info.Id)
		{
			rValue = true;
			nStackableNum++;
		}
	}
	if(getItemSlotWindow(2).GetItemNum()> 0)
	{
		getItemSlotWindow(2).GetItem(0, innerItemInfo);
		if(innerItemInfo.Id == Info.Id)
		{
			rValue = true;
			nStackableNum++;
		}
	}

	// BM
	if(getItemSlotWindow(3).GetItemNum()> 0)
	{
		getItemSlotWindow(3).GetItem(0, innerItemInfo);
		if(innerItemInfo.Id == Info.Id)
		{
			rValue = true;
			nStackableNum++;
		}
	}

	return rValue;
}

//--------------------------------------------------------------------------------------------------------------
//  Б¶°З ГјЕ©іЄ »уЕВ ГјЕ© ЗФјц
//--------------------------------------------------------------------------------------------------------------

// ЗШґз їЙјЗ°ЄАМ, ґЩёҐ ЅЅ·ФїЎј­ ј±ЕГЗС їЙјЗType АЦіЄ?
function bool hasSelectedEnsoulOptionTypeOtherSlot(int nSelectedOptionType, optional int exceptionSlotIndex)
{
	local int n;
	local bool rValue;

	local int clientSlotIndex, exceptionSlotType;

	// itemEnsoulRequestInfo №иї­АЗ slotIndexґВ 1,2,3 АМ ѕЖґП°н, normal 1,2 , bm 1 АМ·±ЅД ±ёјєАМґЩ	
	if(exceptionSlotIndex >= 3)
	{
		exceptionSlotType = EIST_BM;
		clientSlotIndex = 1;
	}
	else
	{
		if(exceptionSlotIndex > 0)
		{
			exceptionSlotType = EIST_NORMAL;
			clientSlotIndex = exceptionSlotIndex;
		}
	}

	//Debug("ї№їЬ exceptionSlotIndex " @ exceptionSlotIndex);
	//Debug("ї№їЬ exceptionSlotType " @ exceptionSlotType);
	//Debug("ї№їЬ clientSlotIndex " @ clientSlotIndex);
	//Debug("itemEnsoulRequestInfo.Length" @ itemEnsoulRequestInfo.Length);
	
	for(n = 0; n < itemEnsoulRequestInfo.Length; n++)
	{
		//Debug("====== hasSelectedEnsoulOptionTypeOtherSlot  ======");
		//Debug("itemEnsoulRequestInfo[n].clientSlotType " @ itemEnsoulRequestInfo[n].clientSlotType);
		//Debug("itemEnsoulRequestInfo[n].clientSlotIndex " @ itemEnsoulRequestInfo[n].clientSlotIndex);
		//Debug("itemEnsoulRequestInfo[n].selectedOptionType " @ itemEnsoulRequestInfo[n].selectedOptionType);

		//Debug("exceptionSlotType" @ exceptionSlotType);
		//Debug("clientSlotIndex" @ clientSlotIndex);

		//Debug("nSelectedOptionType " @ nSelectedOptionType);

		if(itemEnsoulRequestInfo[n].clientSlotIndex != clientSlotIndex || itemEnsoulRequestInfo[n].clientSlotType != exceptionSlotType)
		{
			if(itemEnsoulRequestInfo[n].selectedOptionType == nSelectedOptionType)
			{
				rValue = true;
				// Debug("---> °°Ає їЙјЗ ЕёАФАМ АЦґЩ      : " @ nSelectedOptionType);	
				// Debug("---> °°Ає їЙјЗ selectedOptionID : " @ itemEnsoulRequestInfo[n].selectedOptionID);	
				break;
			}
		}
	}
	Debug("hasSelectedEnsoulOptionTypeOtherSlot :" @ string(RValue));
	return rValue;
}

// ЗШґз їЙјЗ°ЄАМ, ґЩёҐ ЅЅ·ФїЎј­ ј±ЕГЗС їЙјЗID АЦіЄ?
function bool hasSelectedEnsoulOptionIdOtherSlot(int nSelectedOptionID, optional int exceptionSlotIndex)
{
	local int n;
	local bool rValue;

	local int clientSlotIndex, exceptionSlotType;

	// itemEnsoulRequestInfo №иї­АЗ slotIndexґВ 1,2,3 АМ ѕЖґП°н, normal 1,2 , bm 1 АМ·±ЅД ±ёјєАМґЩ	
	if(exceptionSlotIndex >= 3)
	{
		exceptionSlotType = EIST_BM;
		clientSlotIndex = 1;
	}
	else
	{
		if(exceptionSlotIndex > 0)
		{
			exceptionSlotType = EIST_NORMAL;
			clientSlotIndex = exceptionSlotIndex;
		}
	}

	for(n = 0; n < itemEnsoulRequestInfo.Length; n++)
	{
		if(itemEnsoulRequestInfo[n].clientSlotIndex != clientSlotIndex || itemEnsoulRequestInfo[n].clientSlotType != exceptionSlotType)
		{
			if(itemEnsoulRequestInfo[n].selectedOptionID == nSelectedOptionID)
			{
				rValue = true;
				Debug("---> °°Ає їЙјЗ selectedOptionID : " @ itemEnsoulRequestInfo[n].selectedOptionID);	
				break;
			}
		}
	}
	Debug("hasSelectedEnsoulOptionIdOtherSlot:" @ string(RValue));
	return rValue;
}

// АМ№М №«±вїЎ їЙјЗµИ ЅЅ·ФїЎ ЗШґз їЙјЗАМ АЦґВБц ї©єОё¦ ё®ЕПЗСґЩ.
function bool hasWeaponOptionTypeOtherSlot(int nSelectedOptionType, optional int exceptionSlotIndex)
{
	local int n;
	local bool rValue;

	for(n = 0; n < alreadyHasOptionSlotArray.Length; n++)
	{
		if(alreadyHasOptionSlotArray[n].slotIndex != exceptionSlotIndex || exceptionSlotIndex == 0)
		{
			// єу ЅЅ·Ф »уЕВАМ¶уёй..(БэИҐµИ °НА» ЗҐЗцЗП±в А§ЗШ, Item І®µҐ±в°Ў µйѕо°Ј °жїмґЩ)
			//if(getItemSlotInfo(alreadyHasOptionSlotArray[n].slotIndex).Id.ClassID <= 0)
			//{
				// №«±вїЎ АМ№М АыїлµИ °ЄА» ГЈѕЖј­ єс±іЗСґЩ.
				if(alreadyHasOptionSlotArray[n].eOptionUIInfo.OptionType == nSelectedOptionType)
				{
					// Debug("== alreadyHasOptionSlotArray АЦґЩ АЦѕо" @ alreadyHasOptionSlotArray[n].eOptionUIInfo.name);
					// Debug("== alreadyHasOptionSlotArray АЦґЩ АЦѕо" @ nSelectedOptionType);
					rValue = true;
				}	
			//}
		}
	}
	Debug("hasWeaponOptionTypeOtherSlot:" @ string(RValue));
	return rValue;
}

// №«±вїЎ БэИҐµИ ЗШґз їЙјЗID°Ў АЦіЄ?
function bool hasWeaponOptionIdOtherSlot(int applyEOptionID, optional int exceptionSlotIndex)
{
	local int n;
	local bool rValue;

	for(n = 0; n < alreadyHasOptionSlotArray.Length; n++)
	{
		if(alreadyHasOptionSlotArray[n].slotIndex != exceptionSlotIndex || exceptionSlotIndex == 0)
		{
			// єу ЅЅ·Ф »уЕВАМ¶уёй..(БэИҐµИ °НА» ЗҐЗцЗП±в А§ЗШ, Item І®µҐ±в°Ў µйѕо°Ј °жїмґЩ)
			//if(getItemSlotInfo(alreadyHasOptionSlotArray[n].slotIndex).Id.ClassID <= 0)
			//{
				// №«±вїЎ АМ№М АыїлµИ °ЄА» ГЈѕЖј­ єс±іЗСґЩ.
				if(alreadyHasOptionSlotArray[n].eOptionUIInfo.OptionID == applyEOptionID)
				{
					rValue = true;
				}	
			//}
		}
	}
	Debug("hasWeaponOptionIdOtherSlot:" @ string(RValue));
	return rValue;
}

// №«±вїЎ БэИҐµИ ЗШґз їЙјЗID°Ў АЦіЄ?, ёо№ш? ЅЅ·ФїЎ..
function bool hasWeaponOptionIDInTargetSlot(int slotindex, int applyEOptionID)
{
	local int n;
	local bool rValue;

	for(n = 0; n < alreadyHasOptionSlotArray.Length; n++)
	{
		if(alreadyHasOptionSlotArray[n].slotIndex == slotindex)
		{
			// №«±вїЎ АМ№М АыїлµИ °ЄА» ГЈѕЖј­ єс±іЗСґЩ.
			if(alreadyHasOptionSlotArray[n].eOptionUIInfo.OptionID == applyEOptionID)
			{
				rValue = true;
			}	
		}
	}

	return rValue;
}

// БцБ¤ЗС їЙјЗ ЅЅ·ФАМ єЇ°ж µЗѕъіЄ?
function bool isChangedOptionSlot(int slotIndex)
{
	local int i, clientSlotIndex, slotType;

	// itemEnsoulRequestInfo №иї­АЗ slotIndexґВ 1,2,3 АМ ѕЖґП°н, normal 1,2 , bm 1 АМ·±ЅД ±ёјєАМґЩ	
	if(slotIndex >= 3)
	{
		slotType = EIST_BM;
		clientSlotIndex = 1;
	}
	else
	{
		slotType = EIST_NORMAL;
		clientSlotIndex = slotIndex;
	}
	
	for(i = 0; i < itemEnsoulRequestInfo.Length;i++)
	{
		if(itemEnsoulRequestInfo[i].clientSlotIndex == clientSlotIndex && itemEnsoulRequestInfo[i].clientSlotType == slotType)
		{
			// End:0x95
			if(itemEnsoulRequestInfo[i].ensoulStoneServerID > 0)
			{
				return true;
			}
		}
	}

	return false;
}

// єЇ°жµИ ЅЅ·ФАЗ їЙјЗ Б¤єёё¦ ё®ЕПЗСґЩ. 
function EnsoulOptionUIInfo getChangedOptionUIInfo(int slotIndex)
{
	local int i, clientSlotIndex, slotType;
	local EnsoulOptionUIInfo rEnsoulStoneUIInfo;

	// itemEnsoulRequestInfo №иї­АЗ slotIndexґВ 1,2,3 АМ ѕЖґП°н, normal 1,2 , bm 1 АМ·±ЅД ±ёјєАМґЩ	
	if(slotIndex >= 3)
	{
		slotType = EIST_BM;
		clientSlotIndex = 1;
	}
	else
	{
		slotType = EIST_NORMAL;
		clientSlotIndex = slotIndex;
	}
	
	for(i = 0; i < itemEnsoulRequestInfo.Length; i++)
	{
		if(itemEnsoulRequestInfo[i].clientSlotIndex == clientSlotIndex && itemEnsoulRequestInfo[i].clientSlotType == slotType)
		{
			// End:0xB4
			if(itemEnsoulRequestInfo[i].ensoulStoneServerID > 0)
			{
				GetEnsoulOptionUIInfo(itemEnsoulRequestInfo[i].selectedOptionID, rEnsoulStoneUIInfo);

				return rEnsoulStoneUIInfo;
			}
		}
	}

	return rEnsoulStoneUIInfo;
}

// їш·Ў АЦґш їЙјЗАЗ Б¤єёё¦ ё®ЕПЗСґЩ. 
function EnsoulOptionUIInfo getAlreadyHasOptionUIInfo(int slotIndex)
{
	local int i;
	local EnsoulOptionUIInfo rEnsoulStoneUIInfo;
	
	for(i = 0; i < alreadyHasOptionSlotArray.Length;i++)
	{
		if(alreadyHasOptionSlotArray[i].slotIndex == slotIndex)
		{
			return alreadyHasOptionSlotArray[i].eOptionUIInfo;
		}
	}

	return rEnsoulStoneUIInfo;
}


// АМ№М їЙјЗµИ ЅЅ·ФАО°Ў?
function bool checkAlreadyEOptionedSlot(int slotIndex)
{
	local int n;
	local bool rValue;

	// End:0x0D
	if(slotIndex <= 0)
	{
		return false;
	}

	for(n = 0; n < alreadyHasOptionSlotArray.Length; n++)
	{
		//alreadyHasOptionSlotArray[n];
		// Debug("їЙјЗµИ ЅЅ·Ф °Л»з..ЅЅ·Ф №шИЈ °Л»зБЯ.. " @ alreadyHasOptionSlotArray[n].slotIndex);
		// Debug("їЙјЗµИ slotIndex " @ slotIndex);
		if(alreadyHasOptionSlotArray[n].SlotIndex == slotIndex)
		{
			// Debug("їЙјЗµИ °ЕґЩ..АОµ¦Ѕє ё®ЕП " @ alreadyHasOptionSlotArray[n].slotIndex);
			rValue = true;
		}
		//// 3№ш ЅЅ·Ф єОЕН bm
		//if(2 < slotIndex && alreadyHasOptionSlotArray[n].clientSlotType == EIST_BM)
		//{
		//	rValue = true;
		//}
	}

	// Debug("checkAlreadyEOptionedSlot їЙјЗ ЅЅ·Ф" @ rValue);
	return rValue;
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

// БэИҐ їЙјЗ ј±ЕГГў - ГК±вИ­
function clearEnsoulOptionWnd()
{
	EnsoulOptionWnd_ITEM1_ItemWnd.Clear();
	EnsoulOptionWnd_ITEM2_ItemWnd.Clear();
	// ЕШЅєЖ® ЗКµе °ь·Г µоА» ґх Гіё® ЗПґВ°Ф ББАЅ..
}

// ЗцАз БшЗа БЯАО »уЕВё¦ ё®ЕПЗСґЩ.
function string getCurrentEnsoulState()
{
	return currentEnsoulState;
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
