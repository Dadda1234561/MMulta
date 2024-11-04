class PrivateShopFindWnd extends UICommonAPI;

const COLLECTION_ITEM_TYPE = 10000;

enum StoreType 
{
	Sell,
	Buy,
	Wholesale,
	AllStoreType
};

enum ItemType 
{
	Equipment,
	Artifact,
	Enchant,
	Consumable,
	EtcType
};

var WindowHandle Me;
var WindowHandle Main_ItemFind_Wnd;
var WindowHandle ItemFind_Wnd;
var ButtonHandle BtnFind;
var WindowHandle TextInput;
var CheckBoxHandle AllItem_CheckBox;
var CheckBoxHandle SaleItem_CheckBox;
var CheckBoxHandle BuyItem_CheckBox;
var string m_WindowName;
var WindowHandle m_PrivateShopFind_Main;
var WindowHandle m_PrivateShopFind_Sub;
var PrivateShopFind_Main PrivateShopFind_MainScript;
var PrivateShopFind_Sub PrivateShopFind_SubScript;
var UIControlGroupButtonAssets TopGroupButtonAsset;
var UIControlTextInput uicontrolTextInputScr;
var UIControlDialogAssets uicontrolDialogAssetScr;
var WindowHandle DisableWnd;
var int currentTeleportID;
var string clickedCheckBoxString;
var bool bFirstSetting;

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_Restart);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	Main_ItemFind_Wnd = GetWindowHandle(m_WindowName $ ".Main_ItemFind_Wnd");
	ItemFind_Wnd = GetWindowHandle(m_WindowName $ ".ItemFind_Wnd");
	BtnFind = GetButtonHandle(m_WindowName $ ".ItemFind_Wnd.BtnFind");
	TextInput = GetWindowHandle(m_WindowName $ ".ItemFind_Wnd.TextInput");
	AllItem_CheckBox = GetCheckBoxHandle(m_WindowName $ ".ItemFind_Wnd.AllItem_CheckBox");
	SaleItem_CheckBox = GetCheckBoxHandle(m_WindowName $ ".ItemFind_Wnd.SaleItem_CheckBox");
	BuyItem_CheckBox = GetCheckBoxHandle(m_WindowName $ ".ItemFind_Wnd.BuyItem_CheckBox");
	m_PrivateShopFind_Main = GetWindowHandle(m_WindowName $ ".PrivateShopFind_Main");
	m_PrivateShopFind_Sub = GetWindowHandle(m_WindowName $ ".PrivateShopFind_Sub");
	PrivateShopFind_MainScript = PrivateShopFind_Main(m_PrivateShopFind_Main.GetScript());
	PrivateShopFind_SubScript = PrivateShopFind_Sub(m_PrivateShopFind_Sub.GetScript());
	m_PrivateShopFind_Main.ShowWindow();
	m_PrivateShopFind_Sub.HideWindow();
	initGroupButton();
	initUIControlTextInput();
	SetPopupScript();
	bFirstSetting = false;
	clickedCheckBoxString = "";
	OnClickCheckBox("AllItem_CheckBox");
}

function OnShow()
{
	// End:0x35
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		Me.HideWindow();
		return;
	}
	setCategoryButton();
	uicontrolTextInputScr.SetDisable(true);
	Me.SetFocus();
	setInputCheckEnable();
	// End:0x84
	if(m_PrivateShopFind_Main.IsShowWindow())
	{
		PrivateShopFind_MainScript.OnShow();		
	}
	else if(m_PrivateShopFind_Sub.IsShowWindow())
	{
		PrivateShopFind_SubScript.OnShow();
	}
	// End:0xE6
	if(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset").IsShowWindow())
	{
		GetPopupExpandScript().Hide();
	}
}

function initGroupButton()
{
	TopGroupButtonAsset = class'UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle(m_WindowName $ ".UIControlGroupButtonAsset1"));
	TopGroupButtonAsset._SetStartInfo("L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Unselected_Over", true);
	TopGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButton;
	TopGroupButtonAsset._setDelayTime(1500);
	TopGroupButtonAsset.DelegateOnDelayTime = DelegateOnDelayTime;
}

function DelegateOnDelayTime(bool bOnTime)
{
	// End:0x60
	if(bOnTime)
	{
		BtnFind.DisableWindow();
		PrivateShopFind_SubScript.ReFresh_btn.DisableWindow();
		AllItem_CheckBox.DisableWindow();
		SaleItem_CheckBox.DisableWindow();
		BuyItem_CheckBox.DisableWindow();		
	}
	else
	{
		BtnFind.EnableWindow();
		PrivateShopFind_SubScript.ReFresh_btn.EnableWindow();
		AllItem_CheckBox.EnableWindow();
		SaleItem_CheckBox.EnableWindow();
		BuyItem_CheckBox.EnableWindow();
	}
}

function setCategoryButton()
{
	// End:0x0B
	if(bFirstSetting)
	{
		return;
	}
	bFirstSetting = true;
	// End:0x3E1
	if(getInstanceUIData().getIsClassicServer())
	{
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, "");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(116));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(2, GetSystemString(2066));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(3, GetSystemString(13891));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(4, GetSystemString(13476));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(0, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(1, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(2, 2);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(3, 4);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(4, COLLECTION_ITEM_TYPE);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(5);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setAutoWidth(987, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setTextureLoc(0, GetTextureHandle(m_WindowName $ ".Tab_HomeIcon"), 0, 13, "center");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Left_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Left_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Left_Unselected_Over");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(4, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected_Over");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0);		
	}
	else
	{
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, "");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(116));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(2, GetSystemString(3877));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(3, GetSystemString(1532));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(4, GetSystemString(3935));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(5, GetSystemString(49));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(6, GetSystemString(13476));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(0, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(1, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(2, 1);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(3, 2);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(4, 3);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(5, 4);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(6, COLLECTION_ITEM_TYPE);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(7);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setAutoWidth(987, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setTextureLoc(0, GetTextureHandle(m_WindowName $ ".Tab_HomeIcon"), 0, 13, "center");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Left_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Left_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Left_Unselected_Over");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(6, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected_Over");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0);
	}
}

function DelegateOnClickButton(string parentWndName, string strName, int Index)
{
	// End:0x4A
	if(Index == 0)
	{
		m_PrivateShopFind_Main.ShowWindow();
		m_PrivateShopFind_Sub.HideWindow();
		Main_ItemFind_Wnd.ShowWindow();
		ItemFind_Wnd.HideWindow();		
	}
	else
	{
		m_PrivateShopFind_Main.HideWindow();
		m_PrivateShopFind_Sub.ShowWindow();
		Main_ItemFind_Wnd.HideWindow();
		ItemFind_Wnd.ShowWindow();
		PrivateShopFind_SubScript.setGroupButtonCategory(Index - 1);
	}
	setInputCheckEnable();
}

function setInputCheckEnable()
{
	// End:0x61
	if(m_PrivateShopFind_Main.IsShowWindow())
	{
		uicontrolTextInputScr.SetDisable(true);
		BtnFind.DisableWindow();
		AllItem_CheckBox.DisableWindow();
		SaleItem_CheckBox.DisableWindow();
		BuyItem_CheckBox.DisableWindow();		
	}
	else
	{
		uicontrolTextInputScr.SetDisable(false);
		BtnFind.EnableWindow();
		AllItem_CheckBox.EnableWindow();
		SaleItem_CheckBox.EnableWindow();
		BuyItem_CheckBox.EnableWindow();
	}
}

function initUIControlTextInput()
{
	uicontrolTextInputScr = class'UIControlTextInput'.static.InitScript(GetWindowHandle(m_WindowName $ ".ItemFind_Wnd.TextInput"));
	uicontrolTextInputScr.SetMaxLength(16);
	uicontrolTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolTextInputScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	uicontrolTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	uicontrolTextInputScr.SetEdtiable(true);
	uicontrolTextInputScr.SetDisable(false);
	uicontrolTextInputScr.SetDefaultString(GetSystemString(13835));
}

function DelegateESCKey()
{
	Debug("DelegateESCKey");
}

function DelegateOnChangeEdited(string Text)
{}

function DelegateOnCompleteEditBox(string Text)
{
	// End:0x32
	if(Text != "" && TopGroupButtonAsset.bOnDelayTime == false)
	{
		PrivateShopFind_SubScript.Refresh();
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x1C
		case "BtnFind":
			OnBtnFindClick();
			// End:0x1F
			break;
	}
}

function OnBtnFindClick()
{
	PrivateShopFind_SubScript.Refresh();
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		// End:0x4F
		case "AllItem_CheckBox":
			AllItem_CheckBox.SetCheck(true);
			SaleItem_CheckBox.SetCheck(false);
			BuyItem_CheckBox.SetCheck(false);
			// End:0xE3
			break;
		// End:0x98
		case "SaleItem_CheckBox":
			AllItem_CheckBox.SetCheck(false);
			SaleItem_CheckBox.SetCheck(true);
			BuyItem_CheckBox.SetCheck(false);
			// End:0xE3
			break;
		// End:0xE0
		case "BuyItem_CheckBox":
			AllItem_CheckBox.SetCheck(false);
			SaleItem_CheckBox.SetCheck(false);
			BuyItem_CheckBox.SetCheck(true);
			// End:0xE3
			break;
	}
	// End:0xF4
	if(clickedCheckBoxString == strID)
	{
		return;
	}
	clickedCheckBoxString = strID;
	// End:0x126
	if(GetWindowHandle(m_WindowName).IsShowWindow())
	{
		PrivateShopFind_SubScript.Refresh();
	}
}

function int getStoreTypeByCheckBox()
{
	// End:0x1A
	if(SaleItem_CheckBox.IsChecked())
	{
		return 0;		
	}
	else if(BuyItem_CheckBox.IsChecked())
	{
		return 1;
	}
	return 3;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x22
		case EV_GameStart:
			bFirstSetting = false;
			clickedCheckBoxString = "";
			// End:0x3D
			break;
		// End:0x3A
		case EV_Restart:
			bFirstSetting = false;
			clickedCheckBoxString = "";
			// End:0x3D
			break;
	}
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	return UIControlDialogAssets(poopExpandWnd.GetScript());
}

function SetPopupScript()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = class'UIControlDialogAssets'.static.InitScript(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset"));
	DisableWnd = GetWindowHandle(m_WindowName $ ".disable_tex");
	popupExpandScript.SetDisableWindow(DisableWnd);
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop(m_WindowName $ ".disable_tex", false);
}

function ShowPopupTeleport(int nTeleportID)
{
	local UIControlDialogAssets popupExpandScript;
	local TeleportListAPI.TeleportListData listData;

	currentTeleportID = nTeleportID;
	popupExpandScript = GetPopupExpandScript();
	listData = getInstanceUIData().GetTeleportListDataByID(currentTeleportID);
	// End:0x88
	if(GetCurrentZoneName() == listData.Name)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13577));
		GetWindowHandle(m_WindowName).HideWindow();
		PrivateShopFind_SubScript.setUserTargetCommand();
		return;
	}
	popupExpandScript.SetDialogDesc(GetSystemMessage(5239) $ "\\n\\n" $ "(" $ listData.Name $ ")");
	popupExpandScript.SetUseNeedItem(true);
	popupExpandScript.StartNeedItemList(1);
	popupExpandScript.AddNeedItemClassID(57, getInstanceUIData().GetTeleportPriceByID(currentTeleportID));
	popupExpandScript.SetItemNum(1);
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = onClickTeleport;
	popupExpandScript.DelegateOnCancel = onClickCancelDialog;
}

function onClickCancelDialog()
{
	GetPopupExpandScript().Hide();
}

function onClickTeleport()
{
	class'TeleportListAPI'.static.RequestTeleport(currentTeleportID);
	GetPopupExpandScript().Hide();
	GetWindowHandle(m_WindowName).HideWindow();
	PrivateShopFind_SubScript.setUserTargetCommand();
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	// End:0x4C
	if(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset").IsShowWindow())
	{
		GetPopupExpandScript().Hide();		
	}
	else
	{
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
}

defaultproperties
{
}
