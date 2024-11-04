class InventoryWnd extends UICommonAPI;

var int EQUIPITEM_Max;

const DIALOG_USE_RECIPE				= 1111;				// �����Ǹ� ����� �������� ���� ��
const DIALOG_POPUP					= 2222;				// �����ۻ�� �� ������ �˾��޽����� ��� ��
const DIALOG_DROPITEM				= 3333;				// �������� �ٴڿ� ���� ��(�Ѱ�)
const DIALOG_DROPITEM_ASKCOUNT		= 4444;				// �������� �ٴڿ� ���� ��(������, ������ �����)
const DIALOG_DROPITEM_ALL			= 5555;				// �������� �ٴڿ� ���� ��(MoveAll ������ ��)
const DIALOG_DESTROYITEM			= 6666;				// �������� �����뿡 ���� ��(�Ѱ�)
const DIALOG_DESTROYITEM_ALL		= 7777;				// �������� �����뿡 ���� ��(MoveAll ������ ��)
const DIALOG_DESTROYITEM_ASKCOUNT	= 8888;				// �������� �����뿡 ���� ��(������, ������ �����)
const DIALOG_CRYSTALLIZE			= 9999;				// �������� ����ȭ �Ҷ�
const DIALOG_NOTCRYSTALLIZE		= 9998;				// ����ȭ�� �Ұ����ϴٴ� ���
const DIALOG_DROPITEM_PETASKCOUNT	= 10000;			// ���κ����� �������� ��ӵǾ��� ��

const EQUIPITEM_Underwear = 0;
const EQUIPITEM_Head = 1;
const EQUIPITEM_Hair = 2;
const EQUIPITEM_Hair2 = 3;
const EQUIPITEM_Neck = 4;
const EQUIPITEM_RHand = 5;
const EQUIPITEM_Chest = 6;
const EQUIPITEM_LHand = 7;
const EQUIPITEM_REar = 8;
const EQUIPITEM_LEar = 9;
const EQUIPITEM_Gloves = 10;
const EQUIPITEM_Legs = 11;
const EQUIPITEM_Feet = 12;
const EQUIPITEM_RFinger = 13;
const EQUIPITEM_LFinger = 14;
const EQUIPITEM_LBracelet = 15;
const EQUIPITEM_RBracelet = 16;
const EQUIPITEM_Deco1 = 17;
const EQUIPITEM_Deco2 = 18;
const EQUIPITEM_Deco3 = 19;
const EQUIPITEM_Deco4 = 20;
const EQUIPITEM_Deco5 = 21;
const EQUIPITEM_Deco6 = 22;
const EQUIPITEM_Cloak = 23;
const EQUIPITEM_Waist = 24;

const EQUIPITEM_Brooch = 25;

const EQUIPITEM_Jewel1 = 26;
const EQUIPITEM_Jewel2 = 27;
const EQUIPITEM_Jewel3 = 28;
const EQUIPITEM_Jewel4 = 29;
const EQUIPITEM_Jewel5 = 30;
const EQUIPITEM_Jewel6 = 31;

// �ư��ÿ�
const EQUIPITEM_AGATHION_MAIN = 32;
const EQUIPITEM_AGATHION_SUB1 = 33;
const EQUIPITEM_AGATHION_SUB2 = 34;
const EQUIPITEM_AGATHION_SUB3 = 35;
const EQUIPITEM_AGATHION_SUB4 = 36;

// ��Ƽ��Ʈ 
const EQUIPITEM_ARTIFACT = 37;

const EQUIPITEM_ARTIFACT1_SUB1 = 38;
const EQUIPITEM_ARTIFACT1_SUB2 = 39;
const EQUIPITEM_ARTIFACT1_SUB3 = 40;
const EQUIPITEM_ARTIFACT1_SUB4 = 41;
const EQUIPITEM_ARTIFACT2_SUB1 = 42;
const EQUIPITEM_ARTIFACT2_SUB2 = 43;
const EQUIPITEM_ARTIFACT2_SUB3 = 44;
const EQUIPITEM_ARTIFACT2_SUB4 = 45;
const EQUIPITEM_ARTIFACT3_SUB1 = 46;
const EQUIPITEM_ARTIFACT3_SUB2 = 47;
const EQUIPITEM_ARTIFACT3_SUB3 = 48;
const EQUIPITEM_ARTIFACT3_SUB4 = 49;

const EQUIPITEM_ARTIFACT1_MAIN1 = 50;
const EQUIPITEM_ARTIFACT2_MAIN1 = 51;
const EQUIPITEM_ARTIFACT3_MAIN1 = 52;

const EQUIPITEM_ARTIFACT1_MAIN2 = 53;
const EQUIPITEM_ARTIFACT2_MAIN2 = 54;
const EQUIPITEM_ARTIFACT3_MAIN2 = 55;

const EQUIPITEM_ARTIFACT1_MAIN3 = 56;
const EQUIPITEM_ARTIFACT2_MAIN3 = 57;
const EQUIPITEM_ARTIFACT3_MAIN3 = 58;

const EQUIPITEM_Jewel7 = 59;
const EQUIPITEM_Jewel8 = 60;
const EQUIPITEM_Jewel9 = 61;
const EQUIPITEM_Jewel10 = 62;
const EQUIPITEM_Jewel11 = 63;
const EQUIPITEM_Jewel12 = 64;
// const EQUIPITEM_Deco7= 65;
// const EQUIPITEM_Deco8= 66;
// const EQUIPITEM_Deco9= 67;
// const EQUIPITEM_Deco10= 68;
// const EQUIPITEM_Deco11= 69;
// const EQUIPITEM_Deco12= 70;
// const EQUIPITEM_AGATHION_SUB5= 71;
// const EQUIPITEM_AGATHION_SUB6= 72;
// const EQUIPITEM_AGATHION_SUB7= 73;
// const EQUIPITEM_AGATHION_SUB8= 74;


const EQUIPITEM_Total = 65; //??

const EQUIPITEM_TOTAL_CLASSIC = 37;
const INVENTORY_ITEM_TAB = 0;
const INVENTORY_ITEM_1_TAB = 1;
const INVENTORY_ITEM_2_TAB = 2;
const INVENTORY_ITEM_3_TAB = 3;
const INVENTORY_ITEM_4_TAB = 4;
const QUEST_ITEM_TAB = 5;
const ARTIFACT_ITEM_TAB = 6;
const ICON_WIDTH = 36;
const INVENTORYWND_MIN_WIDTH = 556;
const ITEMWINDOW_MIN_WIDTH = 339;
const TAB_BG_MIN_WIDTH = 350;
const TAB_BG_LING_MIN_WIDTH = 10;
const TAB_LENGTH = 4;
const HENNA_INDEX = 99;
const Henna_CLASSIC_MAX = 4;
const ARTIFACT_TOOLTIPMAX = 405;
const TIMERID_bRequestedEnableList = 99;
const TIMER_bRequestedEnableList = 1000;

/**************************************** �� �������� �ٲٱ� ���� preTabOrder **********************************************/
var bool bInitedCompleted;
var bool bRequestHennaOnShow;
var bool bRequestedEnableList;
var bool bRequestItemList;
var int preTabOrder;

/**************************************** ���� �ڵ� �� **********************************************/
var WindowHandle m_hInventoryWnd;
var	ItemWindowHandle m_invenItem;
var	ItemWindowHandle m_questItem;
var	ItemWindowHandle m_equipItem[65];
var	TextBoxHandle		m_hAdenaTextBox;
var	TabHandle			m_invenTab;
var	ButtonHandle		m_sortBtn;
//var	ButtonHandle 		m_BtnRotateLeft;
//var	ButtonHandle		m_BtnRotateRight;

//var TextureHandle		m_CloakSlot_Disable;
var TextureHandle m_Talisman_Disable[6];

// ���� ��Ȱ��ȭ �ؽ��� ��
var TextureHandle m_Jewel_Disable[12];

var	ItemWindowHandle	m_invenItem_1;
var	ItemWindowHandle	m_invenItem_2;
var	ItemWindowHandle	m_invenItem_3;
var	ItemWindowHandle	m_invenItem_4;

//var	ItemWindowHandle	m_equipItem_Brooch;
//var TextureHandle       m_BroochEquiped;


// ���λ����2��������Ű�¹�ư
//var ButtonHandle m_BtnWindowExpand;

// 6, 12��¥���κ��丮����ؽ���
//var TextureHandle m_InventoryItembg;
//var TextureHandle m_InventoryItembg_expand;

//var TextureHandle m_tabbg;
var TextureHandle m_tabbgLine;

var TextBoxHandle m_itemCount;


// �����κ��丮��
//var int currentInvenCol;

// �κ��丮 ������ �� 
var int pInventoryItemCount;


var	array<ItemID>		m_itemOrder;				// �κ��丮 �������� ������ ���ÿ� �����Ѵ�.
var	Vector				m_clickLocation;			// ������ ����Ҷ� ��� ����� ���� �����ϰ� �ִ´�.

var Array<ItemInfo>		m_EarItemList;
var Array<ItemInfo>		m_FingerItemLIst;
var Array<ItemInfo>		m_DecoItemList;

var int m_NormalInvenCount;	// Added by JoeyPark 2010/09/10 ���� ������ �ִ� �Ϲ����� ����.
var int m_QuestInvenCount;	// Added by JoeyPark 2010/09/10 ���� ������ �ִ� ����Ʈ���� ����.
var int m_ArtifactInvenCount;
var bool m_bCurrentState;
var int m_MaxInvenCount;
var int m_MaxQuestItemInvenCount;
var int m_MaxArtifactInvenCount;
var ButtonHandle CollectionBtn;
var AnimTextureHandle CollectionPointAni;
var ButtonHandle ItemAutoPeelBtn;
//var int m_ExtraInvenCount;
// var int m_MeshType;
//var int m_NpcID;

var ButtonHandle		m_hBtnCrystallize;

var WindowHandle        ColorNickNameWnd;

var int                 m_selectedItemTab;

var ButtonHandle        AdenacalculateButton;

//���� �ռ� ���� ��ư
var ButtonHandle        EnchantJewelButton;
//������ ���� ��ư
//var ButtonHandle        JewelButton;

//���ݼ� â ���� ��ư
var ButtonHandle        AlchemyOpenerBtn;

var bool m_bFirstOpened;

//�Ӹ�����
var ButtonHandle        ViewHairButton;
//���Ǽ���������
var ButtonHandle        ViewAccessoryButton;
//���� ������
var WindowHandle JewelWindow;
var WindowHandle Jewel2Window;
var bool m_bJewelTwo;
// var WindowHandle TalismanWindow;
// var WindowHandle Talisman2Window;
var bool m_bTalismanTwo;
//���ݼ� ������
var WindowHandle		AlchemyOpenerWindow;

var ButtonHandle        AlchemyMixCubeWndBtn;
var ButtonHandle        AlchemyItemConversionWndBtn;
var ButtonHandle        AlchemyItemCreateWndBtn;

//��Ƽ??�� ��� �κ��丮�� ������ �ʵ��� 
var string              cur_state;

var int                 mainClass ;

var bool                bIsPremiumHennaSlot; //branch GD35_0828 2014-2-10 luciper3 - ���Ṯ�� ��뿩��

var QuitReportWnd       QuitReportWndScript;

var string              m_EquipWindowName;
var WindowHandle        m_EquipWindow;

/**************************************** �Ʊ�ÿ� ��Ʈ �ҽ� **********************************************/
// �ư��ÿ� ��ư
var WindowHandle        AgathionWindow;

// �ư��ÿ� ���� �ݱ� ��ư
var ButtonHandle        AgathionBtn;

// �ư��ÿ� ��Ȱ��ȭ �ؽ��� ��(main ����)
var TextureHandle		m_Agathion_Disable[ 5 ];

var L2Util l2utilScript;

// ������ ���� �� clear ���� itemSwaped �� true�� ���� tt 61481
var bool bIsSavedLocalItemIdx ;
var array<int> itemSwapedServerID;
var array<int> itemSwapedServerID_1;
var array<int> itemSwapedServerID_2;
var array<int> itemSwapedServerID_3;
var array<int> itemSwapedServerID_4;
var array<int> itemSwapedServerID_q;
var array<int> itemSwapedServerID_a;
var array<int> itemSwapedIdx;
var array<int> itemSwapedIdx_1;
var array<int> itemSwapedIdx_2;
var array<int> itemSwapedIdx_3;
var array<int> itemSwapedIdx_4;
var array<int> itemSwapedIdx_q;
var array<int> itemSwapedIdx_a;

// ������ ����Ʈ �Ϸᰡ �ι� ��� ����, 
// ù�� °�� �Ϲ� ������
// �ι� °�� ����Ʈ �������� ��� �´�.
var bool bIsQuestItemList;

// 2018 4�� ���� �۾�
/**************************************** ������ new ǥ�� **********************************************/
var array<ItemInfo> newItems;


/**************************************** Ȯ�� ���� ���� ************************************************/
// ���� ID
var int m_SelectedExpandEquipIdx ;
// ������ ���� �ߴ� ID(��Ƽ��Ʈ ���¸� ���� �� �ʿ�)
var int m_SelectedExpandEquipIdxPrev;

// ���� �ؽ���
var TextureHandle m_TalismanAllow;
var ButtonHandle EquipItem_Brooch_Button;
var ButtonHandle EquipItem_RBracelet_Button;
var ButtonHandle EquipItem_LBracelet_Button;
var ButtonHandle EquipItem_Artifact_Button;

/**************************************** ĳ���� ��  **********************************************/
var WindowHandle        m_InventoryWndCharacterView;
var buttonHandle        m_CharacterViewOpen_BTN;
var buttonHandle        m_CharacterViewClose_BTN;

var ItemWindowHandle m_artifactRuneItem;
var WindowHandle ArtifactWindow;
var TextureHandle m_Artifact_Disable[3];
var TextureHandle m_Artifact_Active[3];
var TextureHandle m_Artifact_Stone;
var CharacterViewportWindowHandle m_ObjectViewport;
var int _currentStoneState;
var ButtonHandle EnchantArtifactRuneButton;

/**************************************** ��Ƽ��Ʈ  **********************************************/
// ����Ʈ ���� ����
//var bool bSpawnedStoneEffect ;
// ��� �Ǽ����� ���� ���� ���� ��.
var int bShowhairAccessory ;

var TextureHandle EquipSlotBg_Sigil;
var ItemInfo lasetSelectedItemInfo;
var WindowHandle equipItem_Henna_Window;
var ButtonHandle equipItem_Henna_Button;
var TextureHandle hennas_Disable4;
var ItemWindowHandle hennaItems[4];

var ButtonHandle        MountPreviewBtn;

var UIControlTextInput uicontrolTextInputScr;
var ItemWindowHandle m_InvenSearchItem;
var ButtonHandle m_BtnLock;
var bool bIsLocked;
var string lastFindString;
var array<ItemInfo> m_filteringItem;

/*********************************************************************************************
 * On
 * *******************************************************************************************/
event OnRegisterEvent()
{
	RegisterEvent(EV_InventoryClear); // 2570
	RegisterEvent(EV_InventoryOpenWindow); // 2580
	RegisterEvent(EV_InventoryHideWindow); // 2590
	RegisterEvent(EV_InventoryAddItem); // 2600
	RegisterEvent(EV_InventoryUpdateItem); // 2610
	RegisterEvent(EV_InventoryItemListEnd); // 2620
	RegisterEvent(EV_InventoryAddHennaInfo); // 2630
	RegisterEvent(EV_InventoryToggleWindow);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_UpdateUserEquipSlotInfo);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_SetMaxCount);
	//RegisterEvent(EV_ChangeCharacterPawn);
	RegisterEvent(EV_HairAccessoryPriority);
	RegisterEvent(EV_StateChanged);
	RegisterEvent(EV_AlchemySkillListForXML);
	RegisterEvent(EV_ChangedSubjob);
	RegisterEvent(EV_NotifySubjob);
	RegisterEvent(EV_NeedResetUIData);
	// effect test�� 
	// RegisterEvent(EV_Test_3);
	RegisterEvent(EV_EquipItemTooltipClear);
}

event OnLoad()
{
	l2utilScript = L2Util(GetScript("L2Util"));
	SetClosingOnESC();

	InitHandleCOD();

	// * ���� ��ü �� xml �� �ٽ� �ε� �մϴ�.
	// onLoad �� Ŭ���� ���̺� ������ ���� �������� �ڵ��� ���� ����.
	SetEquipWindowHandle();

	SetHennaWindows();

	//�⺻ ������ �ڵ� ����
	SetHandles();
	InitScrollBar();
	
	m_bCurrentState = false;
	m_selectedItemTab = INVENTORY_ITEM_TAB;
	QuitReportWndScript = QuitReportWnd(GetScript("QuitReportWnd"));
	_currentStoneState = -2;

	InitTabIcon();
	InitHennaGrouBtns();

	bIsLocked = True;
	m_BtnLock = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemFind_Wnd.BtnLock");
	uicontrolTextInputScr = class'UIControlTextInput'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemFind_Wnd.TextInput"));
	uicontrolTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolTextInputScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	uicontrolTextInputScr.SetDefaultString(GetSystemString(13835));
	uicontrolTextInputScr.SetEdtiable(True);
	uicontrolTextInputScr.SetDisable(bIsLocked);

	// Different item handle to display search result
	m_InvenSearchItem = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".InventorySearchItem");
	m_InvenSearchItem.HideWindow(); // default is hidden
}

function DelegateESCKey()
{
	HideWindow("InventoryWnd");
}

function DelegateOnChangeEdited(string Text)
{
	FilterItemList();
}

static function InventoryWnd Inst()
{
	return InventoryWnd(GetScript("InventoryWnd"));
}

function InitHennaGrouBtns()
{
	local UIControlGroupButtonHighlighting scr;

	scr = class'UIControlGroupButtonHighlighting'.static.InitScript(equipItem_Henna_Window);
	scr._SetBtnTexture("L2UI_CT1.InventoryWnd.Talisman_HennaBTN_Normal", "L2UI_CT1.InventoryWnd.Talisman_HennaBTN_Over", "L2UI_CT1.InventoryWnd.Talisman_HennaBTN_Normal");
	scr.DelegateOnButtonClick = HandleDelegateOnClickBUtton;
	scr.DelegateOnLButtonUp = HandleDelegateOnLButtonUp;
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case TIMERID_bRequestedEnableList:
			bRequestedEnableList = false;
			m_hOwnerWnd.KillTimer(TIMERID_bRequestedEnableList);
			break;
	}
}

event OnEvent(int Event_ID, string param)
{
	local ELanguageType Language;

	// Debug("OnEvent " @ Event_ID);
	switch(Event_ID)
	{
		case EV_InventoryAddItem: //2600
			HandleAddItem(param);
			break;
		case EV_InventoryClear: //2570
			HandleClear();
			break;
		case EV_InventoryOpenWindow: //2580
			HandleOpenWindow(param);
			break;
		case EV_InventoryHideWindow: //2590
			HandleHideWindow();
			break;  
		case EV_InventoryUpdateItem:            //2610		
			// �ؿ�, �Ʒ��� ���������� ����������
			if(Language != LANG_Korean)
			{
				showItemUpdateEffect(param);
			}		
			HandleUpdateItem(param);
			break;
		// �Ϲ� ������ ������, �Ϸ� �̺�Ʈ
		// ����Ʈ ������ ������, �Ϸ� �̺�Ʈ
		case EV_InventoryItemListEnd: //2620		
			HandleItemListEnd();
			break;
		case EV_InventoryToggleWindow:          //2631
			HandleToggleWindow();
			break;
		case EV_UpdateUserInfo:                 //180
			HandleUpdateUserInfo();
			break;
		case EV_UpdateUserEquipSlotInfo:        //181
			HandleUpdateUserEquipSlotInfo();
			break;
		case EV_Restart:                        //40  
			HandleRestart();
			//~ SaveInventoryOrder();
			break;
		case EV_SetMaxCount:                    //2070
			HandleSetMaxCount(param);
			break;
		//case EV_ChangeCharacterPawn:          //3810
		//	HandleChangeCharacterPawn(param);
		//	break;
		case EV_HairAccessoryPriority:          //9439
			ReceiveHairAccessoryPriority(param);
			break;
		case EV_StateChanged :	
			cur_state = param;			
			break;				
		case EV_ChangedSubjob:
			handleChangedSubjob(param);
		case EV_NotifySubjob:
			handleNotifySubjob(param);
			break;
		case EV_NeedResetUIData:
			checkClassicForm();
			break;
		case EV_EquipItemTooltipClear:
			clearEquipItemTooltip();
			break;
		default:
			break;
	};
}

function clearEquipItemTooltip()
{
	local int i;

	for(i = 0; i < EQUIPITEM_Max; i++)
		m_equipItem[i].ClearItemTooltip();
}

event OnShow()
{
	if(IsShowWindow("PostWriteWnd"))
	{
		HideWindow("InventoryWnd");
	}
	else
	{
		getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "AttributeEnchantWnd,AttributeRemoveWnd,UnrefineryWnd,CrystallizationWnd,ItemAttributeChangeWnd,ProgressBox,AlchemyMixCubeWnd");
	}

	CheckShowCrystallizeButton();
	SetAdenaText();
	SetItemCount();

	SetAhclemyOpener();
	setBottomButtonPositions();
	ShowHideCharacterViewPortOnShow();
	SwitchEquipBox(m_SelectedExpandEquipIdx);
	handleNewItemOnShow();
	ResetArtifactSkillList();

	CollectionPointAni.Stop();
	CollectionPointAni.Pause();
	CollectionPointAni.HideWindow();

	if(!bInitedCompleted)
	{
		HennaMenuWnd(GetScript("HennaMenuWnd")).API_C_EX_NEW_HENNA_LIST();
		bInitedCompleted = true;
		bRequestItemList = false;		
	}
	else
	{
		if(bRequestHennaOnShow)
		{
			HennaMenuWnd(GetScript("HennaMenuWnd")).API_C_EX_NEW_HENNA_LIST();
			bRequestHennaOnShow = false;
		}
		API_C_EX_ITEM_USABLE_LIST();
	}

	ResetItemFiltering(True);
	UpdateLockBtnTexture();
}

event OnHide()
{
	handleNewItemOnHide();
	m_invenTab.SetButtonBlink(6, false);

	if(m_bCurrentState)
	{
		SaveInventoryOrder();
	}

	if(DialogIsMine())
	{
		DialogHide();
	}

	if(class'UIControlContextMenu'.static.GetInstance().IsMine(string(self)))
	{
		class'UIControlContextMenu'.static.GetInstance().Hide();
	}
}

event OnEnterState(name a_CurrentStateName)
{
	m_bCurrentState = true;
}

event OnExitState(name a_CurrentStateName)
{
	m_bCurrentState = false;
}

// ItemWindow Event
event OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int index)
{
	UseItem(a_hItemWindow, index);
}

event OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int index)
{
	local ItemInfo info;
	a_hItemWindow.GetItem(index, info);

	if(IsKeyDown(IK_Ctrl))
	{
		CheckNOpenItemAutoPeel(Info.Id.ServerID, Info.Id.ClassID, IsKeyDown(IK_Alt));
		return;
	}
	delNewItem(info);
	UseItem(a_hItemWindow, index);
}

event OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	local int i;
	local ItemInfo info;
	local string ItemName;

	// Debug("OnSelectItemWithHandle" @ a_hItemWindow @ a_Index);

	a_hItemWindow.GetSelectedItem(info);

	//TextLink
	if(IsKeyDown(IK_Shift))
	{
		ItemName = GetItemNameAll(Info);
		SetItemTextLink(info.ID, ItemName);
	}
	
	//delNewItemByIndex(a_Index);	
	switch(a_hItemWindow)
	{
		case m_invenItem:
		case m_invenItem_1:
		case m_invenItem_2:
		case m_invenItem_3:
		case m_invenItem_4:
		case m_questItem:
		case m_artifactRuneItem:
			delNewItem(info);
			CheckCollectionEnableItem(Info);
			return;
			break;
		// ��
		case m_equipItem[ EQUIPITEM_RBracelet ] :
			switchEquipBox(EQUIPITEM_RBracelet); break;
		case m_equipItem[ EQUIPITEM_LBracelet ] :
			switchEquipBox(EQUIPITEM_LBracelet); break;
		case m_equipItem[ EQUIPITEM_Brooch ] :
			switchEquipBox(EQUIPITEM_Brooch); break;	
		case m_equipItem[EQUIPITEM_ARTIFACT] :
			SwitchEquipBox(EQUIPITEM_ARTIFACT); break;
		
	}	

	for(i = 0; i < EQUIPITEM_Max; ++i)
	{
		if(a_hItemWindow != m_equipItem[ i ])
			m_equipItem[ i ].ClearSelect();	
	}
}

event OnDropItem(String strTarget, ItemInfo info, int x, int y)
{
	local int toIndex, fromIndex;
	local CrystallizationWnd CrystallizationWndScript;		
	local ItemWindowHandle normalinven;

	// ����ȭ ����
	CrystallizationWndScript = CrystallizationWnd(GetScript("CrystallizationWnd"));
	

	// �κ��丮���� �� ���� �ƴϸ� ó������ �ʴ´�.
	if(! isDragSrcInventory(info.DragSrcName))return ;	
	
	if(strTarget == "InventoryItem" || strTarget == "InventoryItem_1" || strTarget == "InventoryItem_2" || strTarget == "InventoryItem_3" || strTarget == "InventoryItem_4" || strTarget == "ArtifactItem")
	{
		//Debug("OnDropItem" @ strTarget @  info.DragSrcName);
		if(info.DragSrcName == strTarget)			// Change Item position
		{
			normalinven = getItemWindowHandleBystrTarget(strTarget);

			toIndex = normalinven.GetIndexAt(x, y, 1, 1);
			
			// Exchange with another item
			
			if(toIndex >= 0)
			{
				fromIndex = normalinven.FindItem(info.ID);
				if(toIndex != fromIndex)
					normalinven.SwapItems(fromIndex, toIndex);
			}
		}
		else if((-1 != InStr(Info.DragSrcName,"EquipItem"))&&(Left(Info.DragSrcName,12)!= "PetEquipItem"))		// Unequip thie item
		{
			//Debug("drpItem" @ info.Name @ info.DragSrcName @ info.ID.classID @ info.SlotBitType);
			handleRequestUnequipItem(info.DragSrcName, info.ID, info.SlotBitType);			
		}
		else if(Info.DragSrcName == "PetInvenWnd")
		{
			if(IsStackableItem(info.ConsumeType)&& info.ItemNum > 1)			// Multiple item?
			{
				if(info.AllItemCount > 0)					// ���� �ű� ���ΰ�
				{
					if(CheckItemLimit(info.ID, info.AllItemCount))
					{
						class'PetAPI'.static.RequestGetItemFromPet(info.ID, info.AllItemCount, false);
					}
				}
				else
				{
					DialogSetID(DIALOG_DROPITEM_PETASKCOUNT);
					DialogSetReservedItemID(info.ID);	// ServerID
					DialogSetParamInt64(info.ItemNum);
					DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), info.Name), string(Self));
					class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
				}
			}
			else																// Single item?
			{
				//Debug("RequestGetItemFromPet" @ info.Name);
				class'PetAPI'.static.RequestGetItemFromPet(info.ID, 1, false);
			}
		}
	}
	else if(strTarget == "QuestItem")
	{
		if(info.DragSrcName == "QuestItem")			// Change Item position
		{

			toIndex = m_questItem.GetIndexAt(x, y, 1, 1);
			
			if(toIndex >= 0)
			{
				fromIndex = m_questItem.FindItem(info.ID);
				if(toIndex != fromIndex)
					m_questItem.SwapItems(fromIndex, toIndex);
			}
		}
	}
	/* �ư��ÿ� ����� ������ ��ü "EquipItem" ������ üũ �ϵ��� ����. */
	// �ư��ÿ� ���ο��� ����� ��ü
	//else if((-1 != InStr(info.DragSrcName, "AgathionMain"))&&(-1 != InStr(strTarget, "AgathionSub")))
	//{
	//	handleSwapAgathionSubMain(strTarget);	
	//}
	//// �ư��ÿ� ���꿡�� �������� ��ü
	//else if((-1 != InStr(info.DragSrcName, "AgathionSub"))&&(-1 != InStr(strTarget, "AgathionMain")))
	//{		
	//	handleSwapAgathionSubMain(info.DragSrcName);		
	//}
	//~ SaveInventoryOrder();
	else if(-1 != InStr(strTarget, "EquipItem")||  strTarget == "ObjectViewportDispatchMsg")		// Equip the item
	{
		//debug("Inven EquipItem: " $info.DragSrcName $" " $string(info.ItemType));
		if(info.DragSrcName == "PetInvenWnd")				// Pet -> Equip
		{
			class'PetAPI'.static.RequestGetItemFromPet(info.ID, 1, true);
		}
		else if(-1 != InStr(info.DragSrcName, "EquipItem"))	//�ƹ��͵� ���� �ʴ´�. 
		{
		}
		else if(EItemType(info.ItemType)!= ITEM_ETCITEM)
		{	
			RequestUseItem(info.ID);
		}
	}
	else if(strTarget == "TrashButton")					// Destroy item(after confirmation)
	{
		//����� �߰� 2013.2.6 �Ӽ���ȭâ ���������� ������ �ȵ�.
		if(IsShowWindow("AttributeEnchantWnd")== true)
		{
			AddSystemMessage(4148);
			return;
		}

		if(IsStackableItem(info.ConsumeType)&& info.ItemNum > 1)			// Multiple item?
		{
			if(info.AllItemCount > 0)				// ���� ���� ���ΰ�
			{				
				DialogSetID(DIALOG_DESTROYITEM_ALL);
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogSetReservedInt2(info.AllItemCount);
				DialogShow(DialogModalType_Modalless,DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(74), info.Name, ""), string(Self));
				class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			}
			else
			{
				DialogSetID(DIALOG_DESTROYITEM_ASKCOUNT);
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogSetParamInt64(info.ItemNum);
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(73), info.Name), string(Self));
				class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			}
		}
		else																// Single item?
		{
			// �ļ��Ϸ� �Ҷ�, ����ȭ�� ������ ��Ȳ�̸� �׳� ����ȭ
			if(class'UIDATA_PLAYER'.static.HasCrystallizeAbility()&& class'UIDATA_ITEM'.static.IsCrystallizable(info.ID))			
			{
				// DialogSetID(DIALOG_CRYSTALLIZE);
				// DialogSetReservedItemID(info.ID);
				// DialogShow(DialogModalType_Modalless,DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(2232), info.Name), string(Self));
				CrystallizationWndScript.setItemInfo(info);
				RequestCrystallizeEstimate(info.ID, 1);
			}
			else
			{
				DialogSetID(DIALOG_DESTROYITEM);
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(74), info.Name), string(Self));
				class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			}
		}
	}
	else if(strTarget == "CrystallizeButton")
	{
		//����� �߰� 2013.2.6 �Ӽ���ȭâ ���������� ����ȭ �ȵ�.
		if(IsShowWindow("AttributeEnchantWnd")== true)
		{
			AddSystemMessage(4148);
			return;
		}
		if(info.DragSrcName == "InventoryItem" || info.DragSrcName == "InventoryItem_1" || info.DragSrcName == "InventoryItem_2" || info.DragSrcName == "InventoryItem_3" || info.DragSrcName == "InventoryItem_4" ||(-1 != InStr(info.DragSrcName, "EquipItem")))
		{
			if(class'UIDATA_PLAYER'.static.HasCrystallizeAbility()&& class'UIDATA_ITEM'.static.IsCrystallizable(info.ID))			// Show Dialog asking confirmation
			{				
				CrystallizationWndScript.setItemInfo(info);
				RequestCrystallizeEstimate(info.ID, 1);

			}
			else
			{
				// ����ȭ â�� ���� �ִ� ��� �ݱ�
				CrystallizationWndScript.cancelCystallizeItem();
				// ����ȭ �Ұ��� �ϴٴ� �˶� 
				AddSystemMessage(2171);
			}
		}
	}	

	else if(strTarget == "AdenacalculateButton")
	{		
		//����� �������� ���� ��� â ���� �õ�
		
		if(IsAdena(info.ID)&& !class'UIAPI_WINDOW'.static.IsShowWindow("AdenaDistributionWnd"))
		{
			callGfxFunction("AdenaDistributionWnd", "RequestDivideAdenaStart","");
		} else 
		addSystemMessage(4158);

	}	
	
	else if(strTarget == "EnchantJewelButton")
	{
		handleJewelDropedOnButton(info);
	}
	else if(strTarget == "CollectionBtn")
	{
		CheckNOpenCollection(Info);
	}
	else if(strTarget == "ItemAutoPeelBtn")
	{
		CheckNOpenItemAutoPeel(Info.Id.ServerID, Info.Id.ClassID, IsKeyDown(IK_Alt));
	}
}

function CheckNOpenCollection(ItemInfo iInfo)
{
	if(iInfo.Id.ClassID < 1)
	{
		CollectionSystem(GetScript("collectionSystem")).API_C_EX_COLLECTION_OPEN_UI();
		return;
	}
	if(!isCollectionItem(iInfo))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13411));
		return;
	}
	lasetSelectedItemInfo = iInfo;
	OpenCollectionSelectedItem();
}

function OpenCollectionSelectedItem()
{
	local CollectionSystem collectionSystemScript;
	
	collectionSystemScript = CollectionSystem(GetScript("collectionSystem"));
	collectionSystemScript.SetToFindItemInfo(lasetSelectedItemInfo);
	collectionSystemScript.API_C_EX_COLLECTION_OPEN_UI();
}

function CheckNOpenItemAutoPeel(int itemServerID, int ItemClassID, bool isAllItem)
{
	if(ItemClassID > 0)
	{
		if(class'UIDATA_ITEM'.static.IsDefaultActionPeel(ItemClassID) == false)
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(1960));
			return;
		}
	}
	OpenItemAutoPeelWnd(itemServerID, isAllItem);
}

// 2018-07-10 ������ ��æƮ â ��Ŀ��, ���� ���
function OnDragItemStartTiny(String strID, ItemInfo infItem)
{
	// Debug("OnDragItemStartTiny: " @ strID @ infItem.name);

	// ������ �����츦 ��� ��æƮ �����찡 �� �ִٸ�..
	// ��ü, ��� ��
	if(strID == "InventoryItem" || strID == "InventoryItem_1")
	{		
		if(Len(infItem.name)> 0 && GetWindowHandle("ItemEnchantWnd").IsShowWindow())
		{
			GetWindowHandle("ItemEnchantWnd").SetFocus();
		}
		if(Len(infItem.Name)> 0 && GetWindowHandle("ItemLookChangeWnd").IsShowWindow())
		{
			GetWindowHandle("ItemLookChangeWnd").SetFocus();
		}
	}
}

// ���� ������ â���� �������� �ű�� ���� OnDropItem ���� �ذ��ϵ��� �ϰ� ���⼭�� �ٴڿ� ������ ��Ȳ�� ó���Ѵ�.
event OnDropItemSource(string strTarget, ItemInfo info)
{
	if(strTarget != "Console")return; 
	if(!isDragSrcInventory(info.DragSrcName))return;
	
	// ��æƮ â�� ���� �ִٸ�.. ������ �ٴڿ� ����Ʈ���⸦ ���´�.
	if(IsShowWindow("ItemEnchantWnd")== false && IsShowWindow("AttributeEnchantWnd")== false )
	{
		m_clickLocation = GetClickLocation();
		if(IsStackableItem(info.ConsumeType)&& info.ItemNum > 1)		// ������ �ִ� ������
		{
			if(info.AllItemCount > 0)				// ���� ���� ���ΰ�
			{
				DialogHide();
				DialogSetID(DIALOG_DROPITEM_ALL);
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogSetReservedInt2(info.AllItemCount);
				DialogShow(DialogModalType_Modalless,DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(1833), info.Name, ""), string(Self));
				class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			}
			else												// ���ڸ� ��� ���ΰ�
			{
				DialogHide();
				DialogSetID(DIALOG_DROPITEM_ASKCOUNT);
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogSetParamInt64(info.ItemNum);
				DialogShow(DialogModalType_Modalless,DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(71), info.Name, ""), string(Self));
				class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			}
		}
		else
		{
			DialogHide();
			DialogSetID(DIALOG_DROPITEM);
			DialogSetReservedItemID(info.ID);	// ServerID
			DialogShow(DialogModalType_Modalless,DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(400), info.Name, ""), string(Self));
			class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
		}
	}
	// "�Ӽ� ��ȭ �߿��� ���� �� ��...."
	else if(IsShowWindow("AttributeEnchantWnd")== true)
		AddSystemMessage(4147);
	// "��æƮ â�� ���� �ֽ��ϴ�. �������� ���� �� �����ϴ�.";
	else
		AddSystemMessage(3656);
}

function ItemWindowHandle GetInvenItemHandle ()
{
  switch (m_selectedItemTab)
  {
    case INVENTORY_ITEM_TAB:
    	return m_invenItem;
    case INVENTORY_ITEM_1_TAB:
    	return m_invenItem_1;
    case INVENTORY_ITEM_2_TAB:
    	return m_invenItem_2;
    case INVENTORY_ITEM_3_TAB:
    	return m_invenItem_3;
    case INVENTORY_ITEM_4_TAB:
    	return m_invenItem_4;
    case QUEST_ITEM_TAB:
   		return m_questItem;
    case ARTIFACT_ITEM_TAB:
    	return m_artifactRuneItem;
    default:
		return m_invenItem;
  }
}

function UpdateLockBtnTexture()
{
  uicontrolTextInputScr.Clear();

  // If is locked
  if ( uicontrolTextInputScr._bDisable )
  {
	m_BtnLock.SetTexture("L2UI_CH3.ShortcutWnd.joypad_lock", "L2UI_CH3.ShortcutWnd.joypad_lock_down", "L2UI_CH3.ShortcutWnd.joypad_lock_over");
  } 
  else
  {
	m_BtnLock.SetTexture("L2UI_CH3.ShortcutWnd.joypad_unlock", "L2UI_CH3.ShortcutWnd.joypad_unlock_down", "L2UI_CH3.ShortcutWnd.joypad_unlock_over");
  }
}


function ResetItemFiltering (optional bool isShow)
{
  // Hide search item window if it is shown
  if ( m_InvenSearchItem.IsShowWindow() )
  {
    m_InvenSearchItem.HideWindow();
    m_InvenSearchItem.Clear();
    if ( isShow )
    {
	  // Show current inventory item window
      GetInvenItemHandle().ShowWindow();
    }
  }

  // Clear search string
  uicontrolTextInputScr.Clear();
}

function FilterItemList()
{
	local int i, itemId;
	local ItemInfo itemInfo;
	local string query;
	local ItemWindowHandle curHandle;

  	curHandle = GetInvenItemHandle();
	query = uicontrolTextInputScr.GetString();
	if (query == "")
	{
		if ( m_InvenSearchItem.IsShowWindow() )
		{
			m_InvenSearchItem.HideWindow();
			m_InvenSearchItem.Clear();
			curHandle.ShowWindow();
		}	
	}
	else
	{
		curHandle.HideWindow();
		m_InvenSearchItem.Clear();
		m_InvenSearchItem.ShowWindow();
		for (i = 0; i < curHandle.GetItemNum(); i++)
		{
			curHandle.GetItem(i, itemInfo);
			if ( (itemInfo.Id.ServerID != -1) && (FindMatchString(GetItemNameAll(itemInfo), query) != -1) )
			{
				m_InvenSearchItem.AddItem(itemInfo);
			}
		}
	}
}

function int FindMatchString (string targetString, string toFindString)
{
  local string delim;

  if ( toFindString == "" ) {
    return 1;
  }

  delim = " ";
  if ( StringMatching(targetString,toFindString,delim) ) {
    return 1;
  } 
  else {
    return -1;
  }

  return 1;
}

private function SwitchPage()
{
	
}

event OnClickButton(string strID)
{
	Debug("OnClickButton" @ strID);
	switch(strID)
	{
		case "SortButton":
			switch(m_selectedItemTab)
			{
				case INVENTORY_ITEM_TAB:
					l2utilScript.SortItem(m_invenItem);	//�κ��丮 ����
					SaveInventoryOrder();
					break;
				case INVENTORY_ITEM_1_TAB:
					l2utilScript.SortItem(m_invenItem_1);
					break;
				case INVENTORY_ITEM_2_TAB:
					l2utilScript.SortItem(m_invenItem_2);
					break;
				case INVENTORY_ITEM_3_TAB:
					l2utilScript.SortItem(m_invenItem_3);
					break;
				case INVENTORY_ITEM_4_TAB:
					l2utilScript.SortItem(m_invenItem_4);
					break;
				case QUEST_ITEM_TAB:
					SortQuestItem();
					break;
				case ARTIFACT_ITEM_TAB:
					SortAttifactItem();
					SaveInventoryOrder();
					break;
				default:
					l2utilScript.SortItem(m_invenItem);	//�κ��丮 ����
					SaveInventoryOrder();
					break;
			}
			break;
		case "InventoryTab0":	//�κ��丮 ������ �� Ŭ��			
			m_selectedItemTab = INVENTORY_ITEM_TAB;
			m_invenItem.SetScrollPosition(0);
			SetIconOnSelectTabOrder();
			SetItemCount();
			break;
		case "InventoryTab1":	//�κ��丮 ������ �� Ŭ��			
			m_selectedItemTab = INVENTORY_ITEM_1_TAB;
			m_invenItem_1.SetScrollPosition(0);
			SetIconOnSelectTabOrder();
			SetItemCount();
			break;
		case "InventoryTab2":	//�κ��丮 ������ �� Ŭ��			
			m_selectedItemTab = INVENTORY_ITEM_2_TAB;
			m_invenItem_2.SetScrollPosition(0);
			SetIconOnSelectTabOrder();
			SetItemCount();
			break;
		case "InventoryTab3":	//�κ��丮 ������ �� Ŭ��			
			m_selectedItemTab = INVENTORY_ITEM_3_TAB;
			m_invenItem_3.SetScrollPosition(0);
			SetIconOnSelectTabOrder();
			SetItemCount();
			break;
		case "InventoryTab4":	//�κ��丮 ������ �� Ŭ��			
			m_selectedItemTab = INVENTORY_ITEM_4_TAB;
			m_invenItem_4.SetScrollPosition(0);
			SetIconOnSelectTabOrder();
			SetItemCount();
			break;
		case "InventoryTab5":	//����Ʈ ������ �� Ŭ��			
			m_selectedItemTab = QUEST_ITEM_TAB;
			m_questItem.SetScrollPosition(0);
			SetIconOnSelectTabOrder();
			SetItemCount();
			break;
		case "InventoryTab6":
            m_selectedItemTab = ARTIFACT_ITEM_TAB;
            m_artifactRuneItem.SetScrollPosition(0);
            SetIconOnSelectTabOrder();
            SetItemCount();
            m_invenTab.SetButtonBlink(ARTIFACT_ITEM_TAB, false);
			break;
		//case "BtnWindowExpand" :  // �κ��丮����Ȯ���ư
		//	extendInventory(currentInvenCol == 9);
		//	break;			
		case "AdenacalculateButton"://�Ƶ��� �й�� ���� ��û
			if(! class'UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWndReport"))
			{
				CallGFxFunction("AdenaDistributionWnd", "RequestDivideAdenaStart", "");
			}
			else
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5104));
			}
			break;
		case "HairAccButton":
		case "HairButton":
			ChangeViewAccessoryFunc();
			break;
		case "EnchantJewelButton":
			handleEnchantJewelButton();
			break;
		case "AlchemyOpenerBtn":
		case "AlchemyCloseButton":
			toggleAlchemyOpener();
			break;
		case "AlchemyItemCreateWndBtn":
			//toggleShowAlchemyWindow("alchemyItemCreate");
			break;
		case "AlchemyItemConversionWndBtn":
			toggleShowAlchemyWindow("AlchemyItemConversionWnd");
			AlchemyOpenerWindow.HideWindow();
			break;
		case "AlchemyMixCubeWndBtn":
			toggleShowAlchemyWindow("AlchemyMixCubeWnd");
			AlchemyOpenerWindow.HideWindow();
			break;
		case "CharacterViewOpen_BTN":
			toogleCharacterViewPort(true);
			InventoryWndCharacterView(GetScript("InventoryWndCharacterView")).CharacterClickec();
            break;
		case "CharacterViewClose_BTN":
			toogleCharacterViewPort(false);
			break;
		case "EquipItem_RBracelet_Button":
			switchEquipBox(EQUIPITEM_RBracelet);
			break;
		case "EquipItem_LBracelet_Button":
			switchEquipBox(EQUIPITEM_LBracelet);
			break;
		case "EquipItem_Brooch_Button":
			switchEquipBox(EQUIPITEM_Brooch);
			break;
		case "EquipItem_Artifact_Button":
            SwitchEquipBox(EQUIPITEM_ARTIFACT);
            break;
        case "EnchantArtifactRuneButton":
            toggleWindow("ArtifactEnchantWnd", true, true);
            break;
        case "CloseButtonArtifactWindow":
            SwitchEquipBox(m_SelectedExpandEquipIdxPrev);
            break;
		case "EquipItem_Henna_Button":
			SwitchEquipBox(99);
			break;
        case "OpenButtonArtifactEffect":
            if(m_InventoryWndCharacterView.IsShowWindow())
            {
                toogleCharacterViewPort(false);                
            }
            else
            {
                InventoryWndCharacterView(GetScript("InventoryWndCharacterView")).ArtifactClicked();
            }
            break;
		case "CollectionBtn":
			CheckNOpenCollection(lasetSelectedItemInfo);
			break;
		case "ItemAutoPeelBtn":
			CheckNOpenItemAutoPeel(0, 0, false);
			break;
		case "DethroneEnchantBtn":
            if(GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow())
            {
                GetWindowHandle("DethroneFireEnchantWnd").HideWindow();                
            }
            else
            {
                DethroneFireEnchantWnd(GetScript("DethroneFireEnchantWnd")).API_C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI();
            }
		case "BtnLock":
			ToggleSearchFieldDisabledState();
            break;
		case "NextPageBtn":
			m_bJewelTwo = True;
			JewelWindow.HideWindow();
			Jewel2Window.ShowWindow();
			break;
		case "PrevPageBtn":
			m_bJewelTwo = False;
			Jewel2Window.HideWindow();
			JewelWindow.ShowWindow();
			break;
	}
}

private function ToggleSearchFieldDisabledState()
{
	bIsLocked = !bIsLocked;
	uicontrolTextInputScr.SetDisable(bIsLocked);
	SetINIBool("InventoryWnd", "IsLockInventoryFindWnd", bIsLocked, "Option.ini");
	UpdateLockBtnTexture();
}

/********************************************************************************************
 * �ʱ�ȭ �� �⺻ handle ����
 * ******************************************************************************************/
function InitHandleCOD()
{
	m_hInventoryWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath);

	m_invenItem = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem");
	m_invenItem_1 = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem_1");
	m_invenItem_2 = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem_2");
	m_invenItem_3 = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem_3");
	m_invenItem_4 = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem_4");
	m_questItem = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestItem");
    m_artifactRuneItem = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ArtifactItem");

	m_invenItem.SetIconDrawType(EItemWindowIconDrawType.ITEMWND_IconDraw_ShowNewlyAcquired);
	m_invenItem_1.SetIconDrawType(EItemWindowIconDrawType.ITEMWND_IconDraw_ShowNewlyAcquired);
	m_invenItem_2.SetIconDrawType(EItemWindowIconDrawType.ITEMWND_IconDraw_ShowNewlyAcquired);
	m_invenItem_3.SetIconDrawType(EItemWindowIconDrawType.ITEMWND_IconDraw_ShowNewlyAcquired);
	m_invenItem_4.SetIconDrawType(EItemWindowIconDrawType.ITEMWND_IconDraw_ShowNewlyAcquired);
	m_questItem.SetIconDrawType(EItemWindowIconDrawType.ITEMWND_IconDraw_ShowNewlyAcquired);
	m_artifactRuneItem.SetIconDrawType(EItemWindowIconDrawType.ITEMWND_IconDraw_ShowNewlyAcquired);
	
	m_hAdenaTextBox = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenaText");
	m_invenTab = GetTabHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryTab");
	m_sortBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SortButton");
	AlchemyOpenerWindow = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AlchemyOpener_Window");
	AlchemyMixCubeWndBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AlchemyOpener_Window.AlchemyMixCubeWndBtn");
	AlchemyItemConversionWndBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AlchemyOpener_Window.AlchemyItemConversionWndBtn");
	AlchemyItemCreateWndBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AlchemyOpener_Window.AlchemyItemCreateWndBtn");

	m_hBtnCrystallize = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CrystallizeButton");
	CollectionBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CollectionBtn");
	CollectionPointAni = GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CollectionPointAni");
	ItemAutoPeelBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemAutoPeelBtn");
	EnchantJewelButton = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantJewelButton");
	AdenacalculateButton = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenacalculateButton");
	ColorNickNameWnd = GetWindowHandle("ColorNickNameWnd");
	AlchemyOpenerBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AlchemyOpenerBtn");

	m_tabbgLine = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabbgLine");
	m_itemCount = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemCount");
	m_CharacterViewOpen_BTN = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CharacterViewOpen_BTN");
	m_CharacterViewClose_BTN = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CharacterViewClose_BTN");
	m_InventoryWndCharacterView = GetWindowHandle("InventoryWndCharacterView");
	ItemAutoPeelBtn.SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(14039), GetSystemString(14062)));
}

/*
 * Ŭ���� ���̺꿡 �´� ��� �ڵ� ���� 
 */
function SetEquipWindowHandle()
{
	local int i;
	local string equipWindow, hyphen, tooltipText;
	local CustomTooltip T;

	// �ؿ� Ŭ���� �������� �ռ� UI ������� ���� 
	// ��� �� ��ư ������ "�Ƶ��� �й�", "�ռ�" �� �׽� ���� �ǰ�, ����(����� ���� ����)�� ���� "����ȭ" ����
	m_EquipWindowName = "Equip_live";
	EQUIPITEM_Max = 65;
	equipWindow = m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ m_EquipWindowName;
	m_EquipWindow = GetWindowHandle(equipWindow);
	// �ռ� ���� ��ư, ������
	JewelWindow = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ m_EquipWindowName $ ".EquipItem_Jewel_Window");
	Jewel2Window = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ m_EquipWindowName $ ".EquipItem_Jewel2_Window");
	// TalismanWindow = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ m_EquipWindowName $ ".EquipItem_Talisman_Window");
	// Talisman2Window = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ m_EquipWindowName $ ".EquipItem_Talisman2_Window");

	m_equipItem[EQUIPITEM_Brooch] = GetItemWindowHandle(equipWindow $ ".EquipItem_Brooch");
	
	for(i = 0; i < 6; i++)
	{
		m_equipItem[26 + i] = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ m_EquipWindowName $ ".EquipItem_Jewel_Window.EquipItem_Jewel"$ string(i + 1));
		m_equipItem[59 + i] = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ m_EquipWindowName $ ".EquipItem_Jewel2_Window.EquipItem_Jewel"$ string(i + 1));
		m_Jewel_Disable[i] = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ m_EquipWindowName $ ".EquipItem_Jewel_Window.Jewel" $ string(i + 1) $"_Disable");
		m_Jewel_Disable[6 + i] = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ m_EquipWindowName $ ".EquipItem_Jewel2_Window.Jewel" $ string(i + 1) $"_Disable");
		
		m_equipItem[EQUIPITEM_Deco1 + i] = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ m_EquipWindowName $ ".EquipItem_Talisman_Window.EquipItem_Talisman" $ string(i + 1));
		// m_equipItem[EQUIPITEM_Deco7 + i] = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ m_EquipWindowName $ ".EquipItem_Talisman2_Window.EquipItem_Talisman" $ string(i + 1));
	}

//	m_equipItem_Brooch.SetTooltipText( GetSystemString(3186));
//	m_equipItem[ EQUIPITEM_Brooch ].SetTooltipText( GetSystemString(3186));
//	EquipItem_Brooch_Button.SetTooltipText( GetSystemString(3186));

	/******************************************** �ư��ÿ� ������ ���� *********************************************/
	AgathionWindow = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipItem_Agathion_Window");

	// �ư��ÿ� ���� �ݱ� ��ư
	AgathionBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AgathionButton");

	// �ư��ÿ� ��Ȱ��ȭ �ؽ��� ��(main ����)
	m_Agathion_Disable[0] = GetTextureHandle(equipWindow $ ".EquipItem_Agathion_Window.AgathionMain_Disable");
	m_Agathion_Disable[1] = GetTextureHandle(equipWindow $ ".EquipItem_Agathion_Window.Agathion1_Disable");
	m_Agathion_Disable[2] = GetTextureHandle(equipWindow $ ".EquipItem_Agathion_Window.Agathion2_Disable");
	m_Agathion_Disable[3] = GetTextureHandle(equipWindow $ ".EquipItem_Agathion_Window.Agathion3_Disable");
	m_Agathion_Disable[4] = GetTextureHandle(equipWindow $ ".EquipItem_Agathion_Window.Agathion4_Disable");

	// �ư��ÿ� ������ ������ ��
	m_equipItem[EQUIPITEM_AGATHION_MAIN] = GetItemWindowHandle(equipWindow $ ".EquipItem_Agathion_Window.EquipItem_AgathionMain");
	m_equipItem[EQUIPITEM_AGATHION_SUB1] = GetItemWindowHandle(equipWindow $ ".EquipItem_Agathion_Window.EquipItem_AgathionSub1");
	m_equipItem[EQUIPITEM_AGATHION_SUB2] = GetItemWindowHandle(equipWindow $ ".EquipItem_Agathion_Window.EquipItem_AgathionSub2");
	m_equipItem[EQUIPITEM_AGATHION_SUB3] = GetItemWindowHandle(equipWindow $ ".EquipItem_Agathion_Window.EquipItem_AgathionSub3");
	m_equipItem[EQUIPITEM_AGATHION_SUB4] = GetItemWindowHandle(equipWindow $ ".EquipItem_Agathion_Window.EquipItem_AgathionSub4");
	hyphen = getHyphenByLanguage();

	T = getAgathionTooltip(GetSystemString(2341) @ GetSystemString(3638), hyphen $ GetSystemString(3643));
	m_Agathion_Disable[0].SetTooltipCustomType(getAgathionTooltip(GetSystemString(2738) @ GetSystemString(3638), hyphen $ GetSystemString(3642)));
	m_Agathion_Disable[1].SetTooltipCustomType(T);
	m_Agathion_Disable[2].SetTooltipCustomType(T);
	m_Agathion_Disable[3].SetTooltipCustomType(T);
	m_Agathion_Disable[4].SetTooltipCustomType(T);

	tooltipText = GetSystemString(2341) @ GetSystemString(3638) $ "\\n" $ hyphen $ GetSystemString(3643);
	m_equipItem[EQUIPITEM_AGATHION_MAIN].SetTooltipText(GetSystemString(2738) @ GetSystemString(3638) $ "\\n" $ hyphen $ GetSystemString(3642));
	m_equipItem[EQUIPITEM_AGATHION_SUB1].SetTooltipText(tooltipText);
	m_equipItem[EQUIPITEM_AGATHION_SUB2].SetTooltipText(tooltipText);
	m_equipItem[EQUIPITEM_AGATHION_SUB3].SetTooltipText(tooltipText);
	m_equipItem[EQUIPITEM_AGATHION_SUB4].SetTooltipText(tooltipText);

	ArtifactWindow = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipItem_Artifact_Window");
	m_Artifact_Disable[0] = GetTextureHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_WindowSub1_Disable");
    m_Artifact_Disable[1] = GetTextureHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_WindowSub2_Disable");
    m_Artifact_Disable[2] = GetTextureHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_WindowSub3_Disable");
    m_Artifact_Active[0] = GetTextureHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_WindowSub1_Active");
    m_Artifact_Active[1] = GetTextureHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_WindowSub2_Active");
    m_Artifact_Active[2] = GetTextureHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_WindowSub3_Active");
    m_Artifact_Stone = GetTextureHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_Stone_Texture");
    m_equipItem[EQUIPITEM_ARTIFACT1_MAIN1] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_B01");
    m_equipItem[EQUIPITEM_ARTIFACT1_MAIN2] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_C01");
    m_equipItem[EQUIPITEM_ARTIFACT1_MAIN3] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_D01");
    m_equipItem[EQUIPITEM_ARTIFACT1_SUB1] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A01");
    m_equipItem[EQUIPITEM_ARTIFACT1_SUB2] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A02");
    m_equipItem[EQUIPITEM_ARTIFACT1_SUB3] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A03");
    m_equipItem[EQUIPITEM_ARTIFACT1_SUB4] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A04");
    m_equipItem[EQUIPITEM_ARTIFACT2_MAIN1] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_B02");
    m_equipItem[EQUIPITEM_ARTIFACT2_MAIN2] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_C02");
    m_equipItem[EQUIPITEM_ARTIFACT2_MAIN3] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_D02");
    m_equipItem[EQUIPITEM_ARTIFACT2_SUB1] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A05");
    m_equipItem[EQUIPITEM_ARTIFACT2_SUB2] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A06");
    m_equipItem[EQUIPITEM_ARTIFACT2_SUB3] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A07");
    m_equipItem[EQUIPITEM_ARTIFACT2_SUB4] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A08");
    m_equipItem[EQUIPITEM_ARTIFACT3_MAIN1] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_B03");
    m_equipItem[EQUIPITEM_ARTIFACT3_MAIN2] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_C03");
    m_equipItem[EQUIPITEM_ARTIFACT3_MAIN3] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_D03");
    m_equipItem[EQUIPITEM_ARTIFACT3_SUB1] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A09");
    m_equipItem[EQUIPITEM_ARTIFACT3_SUB2] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A10");
    m_equipItem[EQUIPITEM_ARTIFACT3_SUB3] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A11");
    m_equipItem[EQUIPITEM_ARTIFACT3_SUB4] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A12");
    HandleShowHideArtifactPanelTextureBySetNum(0, false);
    HandleShowHideArtifactPanelTextureBySetNum(1, false);
    HandleShowHideArtifactPanelTextureBySetNum(2, false);
    t = getAgathionTooltip(GetSystemString(3877), hyphen $ GetSystemString(3092));
    m_Artifact_Disable[0].SetTooltipCustomType(t);
    m_Artifact_Disable[1].SetTooltipCustomType(t);
    m_Artifact_Disable[2].SetTooltipCustomType(t);
    m_equipItem[EQUIPITEM_ARTIFACT1_MAIN1].SetTooltipText(GetSystemString(3891) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT1_MAIN2].SetTooltipText(GetSystemString(3892) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT1_MAIN3].SetTooltipText(GetSystemString(3893) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT1_SUB1].SetTooltipText(GetSystemString(3894) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT1_SUB2].SetTooltipText(GetSystemString(3894) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT1_SUB3].SetTooltipText(GetSystemString(3894) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT1_SUB4].SetTooltipText(GetSystemString(3894) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT2_MAIN1].SetTooltipText(GetSystemString(3891) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT2_MAIN2].SetTooltipText(GetSystemString(3892) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT2_MAIN3].SetTooltipText(GetSystemString(3893) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT2_SUB1].SetTooltipText(GetSystemString(3894) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT2_SUB2].SetTooltipText(GetSystemString(3894) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT2_SUB3].SetTooltipText(GetSystemString(3894) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT2_SUB4].SetTooltipText(GetSystemString(3894) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT3_MAIN1].SetTooltipText(GetSystemString(3891) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT3_MAIN2].SetTooltipText(GetSystemString(3892) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT3_MAIN3].SetTooltipText(GetSystemString(3893) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT3_SUB1].SetTooltipText(GetSystemString(3894) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT3_SUB2].SetTooltipText(GetSystemString(3894) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT3_SUB3].SetTooltipText(GetSystemString(3894) @ GetSystemString(3877));
    m_equipItem[EQUIPITEM_ARTIFACT3_SUB4].SetTooltipText(GetSystemString(3894) @ GetSystemString(3877));
    m_Artifact_Active[0].HideWindow();
    m_Artifact_Active[1].HideWindow();
    m_Artifact_Active[2].HideWindow();
}

// ���� �� �⺻ �ڵ� ���� 
function SetHandles()
{
	local int i;
	local string equipWindow;
	equipWindow = m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ m_EquipWindowName;

	//Ŭ���� �������� ������ ������
	/*
	 *���ġ
	 *����
	 *��Ʈ < 151015 ���� �߰� ��
	 *���� < 151015 ���� �߰� ��
	 *Ż������ < ���� �߰� ��
	 *	
	*/

	//----------------------------------- ����� --------------------------------------------------//

	ViewHairButton = GetButtonHandle(equipWindow $ ".HairButton");
	ViewAccessoryButton = GetButtonHandle(equipWindow $ ".HairAccButton");

	m_equipItem[EQUIPITEM_Head] = GetItemWindowHandle(equipWindow $ ".EquipItem_Head");
	m_equipItem[EQUIPITEM_Hair] = GetItemWindowHandle(equipWindow $ ".EquipItem_Hair");
	m_equipItem[EQUIPITEM_Hair2] = GetItemWindowHandle(equipWindow $ ".EquipItem_Hair2");
	m_equipItem[EQUIPITEM_Neck] = GetItemWindowHandle(equipWindow $ ".EquipItem_Neck");
	m_equipItem[EQUIPITEM_RHand] = GetItemWindowHandle(equipWindow $ ".EquipItem_RHand");
	m_equipItem[EQUIPITEM_Chest] = GetItemWindowHandle(equipWindow $ ".EquipItem_Chest");
	m_equipItem[EQUIPITEM_LHand] = GetItemWindowHandle(equipWindow $ ".EquipItem_LHand");
	m_equipItem[EQUIPITEM_REar] = GetItemWindowHandle(equipWindow $ ".EquipItem_REar");
	m_equipItem[EQUIPITEM_LEar] = GetItemWindowHandle(equipWindow $ ".EquipItem_LEar");
	m_equipItem[EQUIPITEM_Gloves] = GetItemWindowHandle(equipWindow $ ".EquipItem_Gloves");
	m_equipItem[EQUIPITEM_Legs] = GetItemWindowHandle(equipWindow $ ".EquipItem_Legs");
	m_equipItem[EQUIPITEM_Feet] = GetItemWindowHandle(equipWindow $ ".EquipItem_Feet");
	m_equipItem[EQUIPITEM_RFinger] = GetItemWindowHandle(equipWindow $ ".EquipItem_RFinger");
	m_equipItem[EQUIPITEM_LFinger] = GetItemWindowHandle(equipWindow $ ".EquipItem_LFinger");
	m_equipItem[EQUIPITEM_LBracelet] = GetItemWindowHandle(equipWindow $ ".EquipItem_LBracelet");
	m_equipItem[EQUIPITEM_Cloak] = GetItemWindowHandle(equipWindow $ ".EquipItem_Cloak");
	m_equipItem[EQUIPITEM_Waist] = GetItemWindowHandle(equipWindow $ ".EquipItem_Waist");
	m_equipItem[EQUIPITEM_Deco1] = GetItemWindowHandle(equipWindow $ ".EquipItem_Talisman1");
	m_equipItem[EQUIPITEM_Deco2] = GetItemWindowHandle(equipWindow $ ".EquipItem_Talisman2");
	m_equipItem[EQUIPITEM_Deco3] = GetItemWindowHandle(equipWindow $ ".EquipItem_Talisman3");
	m_equipItem[EQUIPITEM_Deco4] = GetItemWindowHandle(equipWindow $ ".EquipItem_Talisman4");
	m_equipItem[EQUIPITEM_Deco5] = GetItemWindowHandle(equipWindow $ ".EquipItem_Talisman5");
	m_equipItem[EQUIPITEM_Deco6] = GetItemWindowHandle(equipWindow $ ".EquipItem_Talisman6");
	m_Talisman_Disable[0] = GetTextureHandle(equipWindow $ ".Talisman1_Disable");
	m_Talisman_Disable[1] = GetTextureHandle(equipWindow $ ".Talisman2_Disable");
	m_Talisman_Disable[2] = GetTextureHandle(equipWindow $ ".Talisman3_Disable");
	m_Talisman_Disable[3] = GetTextureHandle(equipWindow $ ".Talisman4_Disable");
	m_Talisman_Disable[4] = GetTextureHandle(equipWindow $ ".Talisman5_Disable");
	m_Talisman_Disable[5] = GetTextureHandle(equipWindow $ ".Talisman6_Disable");

	// for(i = 0; i < 6; i++)
	// {
	// 	m_equipItem[EQUIPITEM_Deco1 + i] = GetItemWindowHandle(equipWindow $ ".EquipItem_Talisman_Window.EquipItem_Talisman" $ string(i + 1));
	// 	m_Talisman_Disable[i] = GetTextureHandle(equipWindow $ ".EquipItem_Talisman_Window.Talisman" $ string(i + 1) $"_Disable");
	// }
	
	m_equipItem[EQUIPITEM_RBracelet] = GetItemWindowHandle(equipWindow $ ".EquipItem_RBracelet");
	//classic���� �Ҵ�Ʈ�� ��� ��. ��Ʈ������ �����Ƿ� �̸��� �ΰ� �� ��� �� �򰥸� �� ����
	m_equipItem[EQUIPITEM_Underwear] = GetItemWindowHandle(equipWindow $ ".EquipItem_Underwear");
	m_equipItem[EQUIPITEM_LHand].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	m_equipItem[EQUIPITEM_Head].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	m_equipItem[EQUIPITEM_Gloves].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	m_equipItem[EQUIPITEM_Legs].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	m_equipItem[EQUIPITEM_Feet].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	m_equipItem[EQUIPITEM_Hair2].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	EquipItem_Brooch_Button = GetButtonHandle(equipWindow $ ".EquipItem_Brooch_Button");
	EquipItem_RBracelet_Button = GetButtonHandle(equipWindow $ ".EquipItem_RBracelet_Button");
	EquipItem_LBracelet_Button = GetButtonHandle(equipWindow $ ".EquipItem_LBracelet_Button");
	setCustomTooltip();
	//----------------------------------- ������ --------------------------------------------------//
    m_equipItem[EQUIPITEM_ARTIFACT] = GetItemWindowHandle(equipWindow $ ".EquipItem_Artifact");
    EquipItem_Artifact_Button = GetButtonHandle(equipWindow $ ".EquipItem_Artifact_Button");
	m_equipItem[EQUIPITEM_Deco1].SetTooltipText(GetSystemString(1638));
	m_equipItem[EQUIPITEM_Deco2].SetTooltipText(GetSystemString(1638));
	m_equipItem[EQUIPITEM_Deco3].SetTooltipText(GetSystemString(1638));
	m_equipItem[EQUIPITEM_Deco4].SetTooltipText(GetSystemString(1638));
	m_equipItem[EQUIPITEM_Deco5].SetTooltipText(GetSystemString(1638));
	m_equipItem[EQUIPITEM_Deco6].SetTooltipText(GetSystemString(1638));
	m_equipItem[1].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(230), GetSystemString(13122)));
    m_equipItem[2].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1024), GetSystemString(13125)));
    m_equipItem[3].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1024), GetSystemString(13126)));
    m_equipItem[4].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(238), GetSystemString(13127)));
    m_equipItem[5].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(2520), GetSystemString(13121)));
    m_equipItem[6].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(38), GetSystemString(13122)));
    EquipSlotBg_Sigil = GetTextureHandle(m_EquipWindowName $ ".EquipSlotBg_Sigil");
    SetSigilShieldTextureChange(true);
    m_equipItem[9].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(237), GetSystemString(13127)));
    m_equipItem[8].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(237), GetSystemString(13127)));
    m_equipItem[10].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(37), GetSystemString(13122)));
    m_equipItem[11].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(39), GetSystemString(13122)));
    m_equipItem[12].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(40), GetSystemString(13122)));
    m_equipItem[13].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(239), GetSystemString(13127)));
    m_equipItem[14].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(239), GetSystemString(13127)));
    m_equipItem[15].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1637), GetSystemString(13133)));
    EquipItem_LBracelet_Button.SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1637), GetSystemString(13133)));
    // m_equipItem[16].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1636), GetSystemString(13131)));
	EquipItem_RBracelet_Button.SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1636), GetSystemString(13131)));
    EquipItem_RBracelet_Button.SetTooltipText(GetSystemString(1636));
    m_equipItem[23].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(234), GetSystemString(13124)));
    m_equipItem[24].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(2538), GetSystemString(13123)));

	for (i = 0; i < 12; i++)
	{
		m_Jewel_Disable[i].SetTooltipText(GetSystemString(3187));
	}

	for (i = 0; i < 6; i++)
	{
		m_equipItem[EQUIPITEM_Jewel1 + i].SetTooltipText(GetSystemString(3187));
		m_equipItem[EQUIPITEM_Jewel7 + i].SetTooltipText(GetSystemString(3187));
	}

    m_equipItem[17].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
    m_equipItem[18].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
    m_equipItem[19].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
    m_equipItem[20].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
    m_equipItem[21].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
    m_equipItem[22].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
    m_Talisman_Disable[0].SetTooltipText(GetSystemString(1638));
    m_Talisman_Disable[1].SetTooltipText(GetSystemString(1638));
    m_Talisman_Disable[2].SetTooltipText(GetSystemString(1638));
    m_Talisman_Disable[3].SetTooltipText(GetSystemString(1638));
    m_Talisman_Disable[4].SetTooltipText(GetSystemString(1638));
    m_Talisman_Disable[5].SetTooltipText(GetSystemString(1638));
    m_Talisman_Disable[0].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
    m_Talisman_Disable[1].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
    m_Talisman_Disable[2].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
    m_Talisman_Disable[3].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
    m_Talisman_Disable[4].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
    m_Talisman_Disable[5].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
    m_equipItem[26].SetTooltipText(GetSystemString(3187));
    m_equipItem[27].SetTooltipText(GetSystemString(3187));
    m_equipItem[28].SetTooltipText(GetSystemString(3187));
    m_equipItem[29].SetTooltipText(GetSystemString(3187));
    m_equipItem[30].SetTooltipText(GetSystemString(3187));
    m_equipItem[31].SetTooltipText(GetSystemString(3187));
    m_Jewel_Disable[0].SetTooltipText(GetSystemString(3187));
    m_Jewel_Disable[1].SetTooltipText(GetSystemString(3187));
    m_Jewel_Disable[2].SetTooltipText(GetSystemString(3187));
    m_Jewel_Disable[3].SetTooltipText(GetSystemString(3187));
    m_Jewel_Disable[4].SetTooltipText(GetSystemString(3187));
    m_Jewel_Disable[5].SetTooltipText(GetSystemString(3187));
    m_equipItem[26].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
    m_equipItem[27].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
    m_equipItem[28].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
    m_equipItem[29].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
    m_equipItem[30].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
    m_equipItem[31].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
    m_Jewel_Disable[0].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
    m_Jewel_Disable[1].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
    m_Jewel_Disable[2].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
    m_Jewel_Disable[3].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
    m_Jewel_Disable[4].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
    m_Jewel_Disable[5].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
    m_equipItem[0].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(28), GetSystemString(13128)));
    m_equipItem[25].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3186), GetSystemString(13129)));
    EquipItem_Brooch_Button.SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3186), GetSystemString(13129)));
    EquipItem_Artifact_Button.SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3895), GetSystemString(13136)));
    m_TalismanAllow = GetTextureHandle(equipWindow $ ".TalismanAllow");
}

function SetSigilShieldTextureChange(bool B)
{
	if(B)
	{
		EquipSlotBg_Sigil.SetTexture("L2UI_ct1.InventoryWnd.Inventory_Slot32_SigilShield");
		m_equipItem[EQUIPITEM_LHand].SetTooltipText(GetSystemString(13205));
	}
	else
	{
		EquipSlotBg_Sigil.SetTexture("L2UI_ct1.InventoryWnd.Inventory_Slot32_Sigil");
		m_equipItem[EQUIPITEM_LHand].SetTooltipText(GetSystemString(1987));
	}
}

function CustomTooltip getEquipCustomTooltip(string Title, string Desc)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(Title,getInstanceL2Util().BrightWhite,"",true,true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(Desc, getInstanceL2Util().ColorDesc,"",true,false);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 205;
	setCustomToolTipMinimumWidth(mCustomTooltip);

	return mCustomTooltip;
}

function SetHennaWindows()
{
	local int i;
	local string equipWindow;

	equipWindow = m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ m_EquipWindowName;
	equipItem_Henna_Button = GetButtonHandle(equipWindow $ ".equipItem_Henna_Button");
	equipItem_Henna_Button.SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(13904), GetSystemString(13918) $ "\\n" $ GetSystemString(13919)));
	equipItem_Henna_Window = GetWindowHandle(equipWindow $ ".equipItem_Henna_Window");
	hennas_Disable4 = GetTextureHandle(equipWindow $ ".EquipItem_Henna_Window.henna4_Disable");
	for(i = 0; i < 4; i++)
	{
		hennaItems[i] = GetItemWindowHandle(equipWindow $ ".EquipItem_Henna_Window.hennaItem" $ string(i + 1));
	}
}

function string getHyphenByLanguage()
{	
	// �ؿ� ��Ʈ�� ��� ���� �ڵ尡 �ٸ� �� �ֽ��ϴ�.
	if(GetLanguage()== LANG_Korean)return "��"; 
	return "-";
}

function HandleDelegateOnClickBUtton(string btn)
{
	switch(btn)
	{
		case "GroupBaseBtn":
			toggleWindow("HennaMenuWnd", true);
			break;
	}
}

function HandleDelegateOnLButtonUp(WindowHandle wnd, int X, int Y)
{
	switch(wnd)
	{
		case hennaItems[0]:
		case hennaItems[1]:
		case hennaItems[2]:
		case hennaItems[3]:
			HandleChangeHennaDye(int(Right(wnd.GetWindowName(), 1)) - 1);
			break;
	}
}

/********************************************************************************************
 * ����ŸƮ ó�� 
 * ******************************************************************************************/
function HandleRestart()
{
	bRequestHennaOnShow = false;
	 _currentStoneState = -1;
	m_bCurrentState = false;
	bInitedCompleted = false;
	bRequestedEnableList = false;
	m_hOwnerWnd.HideWindow();
	m_hInventoryWnd.HideWindow();
	return;
}

/********************************************************************************************
 * ���̾�α� ó�� 
 * ******************************************************************************************/
function HandleDialogOK()
{
	local int id;
	local INT64 reserved2;
	local ItemID sID;
	local INT64 number;
	
	if(DialogIsMine())
	{
		id = DialogGetID();
		reserved2 = DialogGetReservedInt2();
		number = INT64(DialogGetString());
		sID = DialogGetReservedItemID();	// ItemID
		
		if(id == DIALOG_USE_RECIPE || id == DIALOG_POPUP)
		{
			RequestUseItem(sID);
		}
		else if(id == DIALOG_DROPITEM)
		{
			RequestDropItem(sID, 1, m_clickLocation);
		}
		else if(id == DIALOG_DROPITEM_ASKCOUNT)
		{
			if(number == 0)
				number = 1;					// �ƹ� ���ڵ� �Է����� ������ 1�� ������� ó��
			RequestDropItem(sID, number, m_clickLocation);
		}
		else if(id == DIALOG_DROPITEM_ALL)
		{
			RequestDropItem(sID, reserved2, m_clickLocation);
		}
		else if(id == DIALOG_DESTROYITEM)
		{
			RequestDestroyItem(sID, 1);
			PlayConsoleSound(IFST_TRASH_BASKET);
		}
		else if(id == DIALOG_DESTROYITEM_ASKCOUNT)
		{
			RequestDestroyItem(sID, number);
			PlayConsoleSound(IFST_TRASH_BASKET);
		}
		else if(id == DIALOG_DESTROYITEM_ALL)
		{
			RequestDestroyItem(sID, reserved2);
			PlayConsoleSound(IFST_TRASH_BASKET);
		}
		else if(id == DIALOG_CRYSTALLIZE)
		{
			RequestCrystallizeItem(sID,1);
			PlayConsoleSound(IFST_TRASH_BASKET);
		}
		else if(id == DIALOG_DROPITEM_PETASKCOUNT)
		{
			class'PetAPI'.static.RequestGetItemFromPet(sID, number, false);
		}
	}
}

function int _GetSwapSelectButtonIndex() {
	return 1;
}

function SortArtifactSlot()
{
    local array<ItemInfo> artifactItems;
    local ItemInfo iInfo;
    local int i;


    for(i = 38; i <= 58; i++)
    {
        if(m_equipItem[i].GetItem(i, iInfo))
        {
            m_equipItem[i].Clear();
            artifactItems[artifactItems.Length] = iInfo;
        }
    }
	

    for(i = 0; i < artifactItems.Length; i++)
    {
        HandleArtifactEquip(artifactItems[i]);
    }
}

	
function int GetArtifactEmptySlotIdxBySlotBit(ItemInfo a_Info) 
{
	local int Index;
    Index = -1;

	//	//Debug("IsArtifactRuneItem1:" @info.slotBitType == 18014398509481984);
	//	//Debug("IsArtifactRuneItem2:" @info.slotBitType == 144115188075855872);
	//	//Debug("IsArtifactRuneItem3:" @info.slotBitType == 1152921504606846976);
	//	//Debug("IsArtifactRuneItem4:" @info.slotBitType == 4398046511104);
	
	// switch(a_Info.SlotBitType) 
	// {
	// 	case INT64("4398046511104"): 
	// 		Index = GetArtifactIndex(a_Info.Id);
	// 	break;
	// }

	switch ( a_info.slotBitType ) 
	{  
		
		// ��Ƽ��Ʈ �Ϲݷ� GetArtifactSlotIndex 0 ~ 11
		case INT64("4398046511104") :
			return EQUIPITEM_ARTIFACT1_SUB1 + GetArtifactIndex( a_info.ID ) ;
			//for ( i = EQUIPITEM_ARTIFACT1_SUB1 ; i <= EQUIPITEM_ARTIFACT1_SUB4 ; i ++ ) if ( m_equipItem[ i ].GetItemNum( ) == 0 ) return i;
			//for ( i = EQUIPITEM_ARTIFACT2_SUB1 ; i <= EQUIPITEM_ARTIFACT2_SUB4 ; i ++ ) if ( m_equipItem[ i ].GetItemNum( ) == 0 ) return i;
			//for ( i = EQUIPITEM_ARTIFACT3_SUB1 ; i <= EQUIPITEM_ARTIFACT3_SUB4 ; i ++ ) if ( m_equipItem[ i ].GetItemNum( ) == 0 ) return i;
		break;
		// ��Ƽ��Ʈ Ư���� 1 GetArtifactSlotIndex 12 ~ 14
		case INT64("18014398509481984") :			
			return EQUIPITEM_ARTIFACT1_SUB1 + GetArtifactIndex( a_info.ID ) ;
			//if ( m_equipItem[ EQUIPITEM_ARTIFACT1_MAIN1 ].GetItemNum( ) == 0 ) return EQUIPITEM_ARTIFACT1_MAIN1;
			//if ( m_equipItem[ EQUIPITEM_ARTIFACT2_MAIN1 ].GetItemNum( ) == 0 ) return EQUIPITEM_ARTIFACT2_MAIN1;
			//if ( m_equipItem[ EQUIPITEM_ARTIFACT3_MAIN1 ].GetItemNum( ) == 0 ) return EQUIPITEM_ARTIFACT3_MAIN1;
		// ��Ƽ��Ʈ Ư���� 2 GetArtifactSlotIndex 15 ~ 17
		case INT64("144115188075855870") : 
			return EQUIPITEM_ARTIFACT1_SUB1 + GetArtifactIndex( a_info.ID ) ;
			//if ( m_equipItem[ EQUIPITEM_ARTIFACT1_MAIN2 ].GetItemNum( ) == 0 ) return EQUIPITEM_ARTIFACT1_MAIN2;
			//if ( m_equipItem[ EQUIPITEM_ARTIFACT2_MAIN2 ].GetItemNum( ) == 0 ) return EQUIPITEM_ARTIFACT2_MAIN2;
			//if ( m_equipItem[ EQUIPITEM_ARTIFACT3_MAIN2 ].GetItemNum( ) == 0 ) return EQUIPITEM_ARTIFACT3_MAIN2;
		// ��Ƽ��Ʈ Ư���� 3 GetArtifactSlotIndex 18 ~ 20
		case INT64("1152921504606847000") : 
			return EQUIPITEM_ARTIFACT1_SUB1 + GetArtifactIndex( a_info.ID ) ;
			//if ( m_equipItem[ EQUIPITEM_ARTIFACT1_MAIN3 ].GetItemNum( ) == 0 ) return EQUIPITEM_ARTIFACT1_MAIN3;
			//if ( m_equipItem[ EQUIPITEM_ARTIFACT2_MAIN3 ].GetItemNum( ) == 0 ) return EQUIPITEM_ARTIFACT2_MAIN3;
			//if ( m_equipItem[ EQUIPITEM_ARTIFACT3_MAIN3 ].GetItemNum( ) == 0 ) return EQUIPITEM_ARTIFACT3_MAIN3;
	}
	// if(Index == -1){
	// 	index = a_info.BodyPart;

	// 	if(index < 38 || index > 58){
	// 		AddSystemMessageString("Incorrect BodyPart");
	// 		AddSystemMessageString(string(index));
	// 		return Index;
	// 	}
	// }


	return Index;
}


/********************************************************************************************
 * ������ ��� ��
 * ******************************************************************************************/
// �Ǽ��縮 
function ChangeViewAccessoryFunc()
{
	local ItemInfo infItem;
	infItem.ID.ClassID = 17192;
	UseSkill(infItem.ID, int(EShortCutItemType.SCIT_SKILL));
}

// �Ϲ� ������
function UseItem(ItemWindowHandle a_hItemWindow, int index)
{
	local ItemInfo	info;

	if(a_hItemWindow.GetItem(index, info))
	{
		if(info.bDisabled == 0)		// lpislhy
		{
			if(info.bRecipe)					// ������(������)�� ����� ������ �����
			{
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogSetID(DIALOG_USE_RECIPE);
				DialogShow(DialogModalType_Modalless,DialogType_Warning, GetSystemMessage(798), string(Self));
				class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			}
			else if(Info.bSimpleExchangeItem)
			{
				class'MultiSellItemExchangeWnd'.static.Inst().OpenWindow(Info.Id.ClassID);					
			}
			else if(info.PopMsgNum > 0)			// �˾� �޽����� �����ش�.
			{
				DialogSetID(DIALOG_POPUP);
				DialogSetReservedItemID(info.ID);	// ServerID
				DialogShow(DialogModalType_Modalless,DialogType_Warning, GetSystemMessage(info.PopMsgNum), string(Self));
				class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			}
			else
			{
				RequestUseItem(info.ID);
			}
		}
		else
		{
			if(class'UIDATA_ITEM'.static.IsDefaultActionPeel(Info.Id.ClassID) && class'ItemAutoPeelWnd'.static.Inst().IsItemReady())
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13680));
			}
		}
	}
	
	//RequestItemList(); //kostil
}

// ���� ������ ���
function handleJewelDropedOnButton(ItemInfo info)
{
	class'ItemJewelEnchantWnd'.static.Inst()._HandleDropedItem(info);
}


/********************************************************************************************
 * ������ ������Ʈ 
 * ******************************************************************************************/
// ?? ������ ��� ���� ��??
function UpdateItemUsability()
{
	m_invenItem.SetItemUsability();
	m_invenItem_1.SetItemUsability();
	m_invenItem_2.SetItemUsability();
	m_invenItem_3.SetItemUsability();
	m_invenItem_4.SetItemUsability();
	m_questItem.SetItemUsability();
	m_artifactRuneItem.SetItemUsability();
	FilterItemList();
}

function API_C_EX_ITEM_USABLE_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_ITEM_USABLE_LIST packet;

	if(bRequestedEnableList)
	{
		return;
	}
	m_hOwnerWnd.KillTimer(TIMERID_bRequestedEnableList);
	m_hOwnerWnd.SetTimer(TIMERID_bRequestedEnableList, TIMER_bRequestedEnableList);

	if(! class'UIPacket'.static.Encode_C_EX_ITEM_USABLE_LIST(stream, packet))
	{
		return;
	}
	packet.cDummy = 0;
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_ITEM_USABLE_LIST, stream);
	bRequestedEnableList = true;
}

// ������ ������Ʈ
function HandleUpdateItemWithInfo(ItemInfo info, string Type)
{
	local ItemInfo beforeItem;
	local int index;
	local ItemWindowHandle detailItemWindowHandle;
		
	setShowItemCount(info);
	

	if(type == "add")
	{
		if(IsEquipItem(info))
		{
			QuitReportWndScript.externalAddItem(info);
			EquipItemUpdate(info, true);
		}
		else if(IsQuestItem(info))
		{			
			QuestInvenAddItem(info);
			handleNewItem(info);
		}
		else
		{			
			QuitReportWndScript.externalAddItem(info);
			NormalInvenAddItem(info);
			handleNewItem(info);
		}
	}
	else if(type == "update")
	{
		if(IsEquipItem(info))
		{
			//Debug("handleUpdateItem IsEquipItem" @ IsArtifactRuneItem(info)@ "/" @ info.name ); 
			if(EquipItemFind(info.ID))		// match found
			{
				//debug("������ ? " $ param);
				EquipItemUpdate(info, true);				
				if(IsArtifactRuneItem(Info))
				{
					ResetArtifactSkillList();
				}                   
			}
			else 			// not found in equipItemList. In this case, move the item from InvenItemList to EquipItemList
			{
				if(IsArtifactRuneItem(Info))
				{
					ArtifactRuneDelete(Info);
					EquipItemUpdate(Info, true);
					ResetArtifactSkillList();                        
				}
				else
				{
					InvenDelete(info);				
					EquipItemUpdate(info, true);
				}

			}
		}
		else if(IsQuestItem(info))
		{
			index = m_questItem.FindItem(info.ID);	// ServerID
			if(index != -1)
			{	
				m_questItem.GetItem(index , beforeItem);

				m_questItem.SetItem(index, info);

				// ������ �þ ��츸 new ǥ�ø� ����.				
				if(beforeItem.itemNum < info.itemNum)handleNewItem(info);
			}
			else		// In this case, Equipped item is being unequipped.
			{
				EquipItemDelete(info.ID);
				QuestInvenAddItem(info);
				handleNewItem(info);
			}			
		}
		else if(IsArtifactRuneItem(Info))
		{
			Index = m_artifactRuneItem.FindItem(Info.Id);
			// End:0x2BC
			if(Index != -1)
			{
				m_artifactRuneItem.GetItem(Index, beforeItem);
				QuitReportWndScript.externalAddItem(Info);
				m_artifactRuneItem.SetItem(Index, Info);                            
			}
			else
			{
				EquipItemDelete(Info.Id);
				ArtifactInvenAddItem(Info);
				ResetArtifactSkillList();
			}  
		}                    
		else
		{
			index = m_invenItem.FindItem(info.ID);	// ServerID

			if(index != -1)
			{
				m_invenItem.GetItem(index , beforeItem);

				if(beforeItem.ItemNum != Info.ItemNum)
				{
					QuitReportWndScript.externalAddItem(Info);
				}

				m_invenItem.SetItem(index, info);
				detailItemWindowHandle = getItemWindowHandleByItemType(info);				
				detailItemWindowHandle.SetItem(detailItemWindowHandle.FindItem(info.ID), info);
				
				
				if(beforeItem.itemNum < info.itemNum)
				{
//					Debug("itemUpdate" @ info.Name @  beforeItem.itemNum @ info.itemNum);
					handleNewItem(info);
				}
				
			}
			else		// In this case, Equipped item is being unequipped.
			{
				EquipItemDelete(info.ID);				
				NormalInvenAddItem(info);
			}
		}
	}
	else if(type == "delete")
	{
		if(IsEquipItem(info))
		{
			EquipItemDelete(info.ID);
		}
		else if(IsQuestItem(info))
		{
			QuestInvenDelete(info);
		}
		else 
		{
			if(IsArtifactRuneItem(Info))
			{
				ArtifactRuneDelete(Info);                            
			}
			else
			{
				InvenDelete(Info);
			}
		}
	}

	UpdateItemUsability();

	SetAdenaText();
	SetItemCount();
}

function ResetArtifactSkillList()
{
    InventoryWndCharacterView(GetScript("InventoryWndCharacterView")).ResetArtifactSkillList();
}


function HandleUpdateItem(string param)
{
	local ItemInfo Info;
	local string Type;

	ParseString(param, "type", Type);
	ParamToItemInfo(param, Info);
	HandleUpdateItemWithInfo(Info, Type);
}

// ������ �Ϸᰡ �ι� ��� ��.
// �Ϲ� ������ �Ϸ�
// ����Ʈ �Ϸ�
function HandleItemListEnd()
{
	// ó�� �Ϸ� �� ����Ʈ ����Ʈ�� ó��
	if(!bIsQuestItemList)
	{
		bIsQuestItemList = true;
		return;
	}
	SetAdenaText();
	SetItemCount();
	UpdateItemUsability();

	if(bIsSavedLocalItemIdx)
	{
		SaveInventoryOrder();
	}
	if(m_hInventoryWnd.IsShowWindow())
	{
		ResetArtifactSkillList();
	}
	if(bRequestItemList)
	{
		bRequestItemList = false;
		ShowWindowWithFocus("InventoryWnd");
		PlayConsoleSound(IFST_INVENWND_OPEN);
	}
}

/********************************************************************************************
 * item add 
 * ******************************************************************************************/
function HandleAddItem(string param)
{
	local ItemInfo info;

	ParamToItemInfo(param, info);
	setShowItemCount(info);

	if(IsEquipItem(info))		
		EquipItemUpdate(info);
	else if(IsQuestItem(info))
		QuestInvenAddItem(info);
	else if (IsArtifactRuneItem(info))
		ArtifactInvenAddItem(info);
	else 
		NormalInvenAddItem(info);
}

function ArtifactInvenAddItem(ItemInfo NewItem)
{
    local int idx, CurLimit, FindIdx;
    local ItemInfo CurItem;

    FindIdx = -1;
    CurLimit = m_artifactRuneItem.GetItemNum();
    if(bIsSavedLocalItemIdx)
    {
        NewItem.ORDER = getLocalItemOrder(NewItem.Id.ServerID, itemSwapedServerID_a, itemSwapedIdx_a, NewItem.ORDER);
    }
    if(m_artifactRuneItem.GetItem(NewItem.ORDER, CurItem))
    {
        if(!IsValidItemID(CurItem.Id))
        {
            FindIdx = NewItem.ORDER;
        }
    }
    if(FindIdx < 0)
    {
        for(idx = 0; idx < CurLimit; idx++)
        {
            if(m_artifactRuneItem.GetItem(idx, CurItem))
            {
                if(!IsValidItemID(CurItem.Id))
                {
                    FindIdx = idx;
                    break;
                }
            }
        }
    }

    if(FindIdx > -1)
    {
        m_artifactRuneItem.SetItem(FindIdx, NewItem);        
    }
    else
    {
        m_artifactRuneItem.AddItem(NewItem);
    }
	m_ArtifactInvenCount++;
}

function NormalInvenAddItem(ItemInfo newItem)
{	
	local int idx;
	local int CurLimit;
	local int FindIdx;
	
	local ItemInfo curItem;

	local ItemWindowHandle detailItemWindow ;
	
	//local int FindIdxDetail;		
	//Debug("NormalInvenAddItem " @ newItem.Name @ "/" @  newItem.SlotBitType);
	// �Ʒ��� ��ȭ ���� �������̶�� ��ġ�� ���� setItem ���� �ʴ´�.
	//if(handleArenaEnchantOnlyEnchanted(newItem))return ;

	FindIdx = -1;	

	CurLimit = m_invenItem.GetItemNum();
	//Debug("NormalInvenAddItem" @  newItem.ID.classID @ newItem.ID.serverID);

//	Debug("NormalInvenAddItem" @  newItem.name @ newItem.Order @ getLocalItemOrder(newItem.ID.serverID, itemSwapedServerID, itemSwapedIdx, newItem.Order)@ bIsSavedLocalItemIdx);

	if(bIsSavedLocalItemIdx)	
		newItem.Order = getLocalItemOrder(newItem.ID.serverID, itemSwapedServerID, itemSwapedIdx, newItem.Order);

	//�ش� �ڸ��� �������� ���� ���
	if( m_invenItem.GetItem(newItem.Order, curItem))
		if(!IsValidItemID(curItem.ID))	
			FindIdx = newItem.Order;	
	
	//�������� ���� ���
	if(FindIdx < 0)
		for(idx=0; idx<CurLimit; idx++)
			//�� idx�� ã�ƶ�
			if(m_invenItem.GetItem(idx, curItem))
				if(!IsValidItemID(curItem.ID))
				{	
					FindIdx = idx;
					break;
				}			

	if(FindIdx > -1)
		m_invenItem.SetItem(FindIdx, newItem);				
	else
		m_invenItem.AddItem(newItem);
	
	m_NormalInvenCount++;
	
	//���� �ǿ� ���̱�	
	detailItemWindow = getItemWindowHandleByItemType(newItem);

	if(bIsSavedLocalItemIdx)
		FindIdx = getLocalItemOrderByItemWindow(detailItemWindow, newItem.ID.serverID, -1);
	else 
	{
		FindIdx = -1;	
		//Debug("addNormalItem 0" @ newItem.Name @ FindIdx);

		for(idx=0; idx<CurLimit; idx++)
			if(detailItemWindow.GetItem(idx, curItem))
				if(!IsValidItemID(curItem.ID))
				{				
					FindIdx = idx;
					break;
				}
	}

	//Debug("addNormalItem 1" @ newItem.Name @ FindIdx);
	if(FindIdx > -1)	
		detailItemWindow.SetItem(FindIdx, newItem);		
	else
		detailItemWindow.AddItem(newItem);	
}


function QuestInvenAddItem(ItemInfo newItem)
{
	local int idx;
	local int CurLimit;
	local int FindIdx;
	
	local ItemInfo curItem;	

	FindIdx = -1;
	
	if(bIsSavedLocalItemIdx)FindIdx = getLocalItemOrderByItemWindow(m_questItem, newItem.ID.serverID, -1);	
	else if(m_questItem.GetItem(newItem.Order, curItem))
		if(!IsValidItemID(curItem.ID))FindIdx = newItem.Order ;	

	if(FindIdx < 0)
	{
		CurLimit = m_questItem.GetItemNum();
		for(idx=0; idx<CurLimit; idx++)
		{
			if(m_questItem.GetItem(idx, curItem))
			{
				if(!IsValidItemID(curItem.ID))
				{
					FindIdx = idx;
					break;
				}
			}
		}
	}
	
	if(FindIdx > -1)
		m_questItem.SetItem(FindIdx, newItem);
	else
		m_questItem.AddItem(newItem);

	m_QuestInvenCount++;
}


function HandleArtifactEquip(ItemInfo a_Info)
{
	local int artifactEquipIdx ;

	artifactEquipIdx = GetArtifactEmptySlotIdxBySlotBit( a_info ) ;	
	//Debug ( "handleArtifactEquip" @ "handleShowHideArtifactPanelTexture" @  artifactEquipIdx ) ;
//	handleShowHideArtifactPanelTexture(artifactEquipIdx, true ) ;
	//Debug ( "handleArtifactEquip" @a_info.Name @ "/" @  artifactEquipIdx ) ;
	if (artifactEquipIdx != -1)
	{
		m_equipItem[ artifactEquipIdx ].Clear();
		m_equipItem[ artifactEquipIdx ].AddItem( a_info );
		m_equipItem[ artifactEquipIdx ].EnableWindow();
	}

}

/********************************************************************************************
 * ��� ����
 * ******************************************************************************************/

// �ư��ÿ� ��� ����
function handleAgathionEquip(ItemInfo a_Info)
{
	local int agathionIndex;

	agathionIndex = GetAgathionIndex(a_Info.Id);
	if(agathionIndex != -1)
	{
		m_equipItem[EQUIPITEM_AGATHION_MAIN + agathionIndex].Clear();
		m_equipItem[EQUIPITEM_AGATHION_MAIN + agathionIndex].AddItem(a_Info);
		m_equipItem[EQUIPITEM_AGATHION_MAIN + agathionIndex].EnableWindow();
	}	
}

// �Ͱ��� ������Ʈ 
function EarItemUpdate()
{
	local int i;
	local int LEarIndex, REarIndex;

	LEarIndex = -1;
	REarIndex = -1;

	for(i = 0; i < m_EarItemList.Length; ++i)
	{
		switch(IsLOrREar(m_EarItemList[i].ID))
		{
			case -1:
				LEarIndex = i;
				break;
			case 0:
				m_EarItemList.Remove(i, 1);
				i--;
				break;
			case 1:
				REarIndex = i;
				break;
		}
	}

	if(-1 != LEarIndex)
	{
		//~ debug("���� �Ͱ���");
		m_equipItem[EQUIPITEM_LEar].Clear();
		m_equipItem[EQUIPITEM_LEar].AddItem(m_EarItemList[LEarIndex]);
	}

	if(-1 != REarIndex)
	{
		//~ debug("������ �Ͱ���");
		m_equipItem[EQUIPITEM_REar].Clear();
		m_equipItem[EQUIPITEM_REar].AddItem(m_EarItemList[REarIndex]);
	}
}

// ���� ������Ʈ
function FingerItemUpdate()
{
	local int i;
	local int LFingerIndex, RFingerIndex;

	LFingerIndex = -1;
	RFingerIndex = -1;

	for(i = 0; i < m_FingerItemList.Length; ++i)
	{
		switch(IsLOrRFinger(m_FingerItemList[i].ID))
		{
		case -1:
			LFingerIndex = i;
			break;
		case 0:
			m_FingerItemList.Remove(i, 1);
			i--;
			break;
		case 1:
			RFingerIndex = i;
			break;
		}
	}

	if(-1 != LFingerIndex)
	{
		m_equipItem[ EQUIPITEM_LFinger ].Clear();
		m_equipItem[ EQUIPITEM_LFinger ].AddItem(m_FingerItemList[ LFingerIndex ]);
	}

	if(-1 != RFingerIndex)
	{
		m_equipItem[ EQUIPITEM_RFinger ].Clear();
		m_equipItem[ EQUIPITEM_RFinger ].AddItem(m_FingerItemList[ RFingerIndex ]);
	}
}

function FindFreeArtifactSlotAndEquip(ItemInfo a_info){

	local int i, index;
	local ItemWindowHandle hItemWnd;

	index = a_info.BodyPart;

	if(index < 38 || index > 58){
		return;
	}

	hItemWnd = m_equipItem[index];

	SortArtifactSlot();

	if(None != hItemWnd)
	{
		hItemWnd.Clear();
		hItemWnd.AddItem(a_Info);
	}
}

// ��� ������Ʈ
function EquipItemUpdate( ItemInfo a_info, optional bool bSwitchExpandEquipBox )
{
	local ItemWindowHandle hItemWnd;
	local ItemInfo TheItemInfo;
	local bool ClearLHand;
	local ItemInfo RHand;
	local ItemInfo LHand;
	local ItemInfo Legs;
	local ItemInfo Gloves;
	local ItemInfo Feet;
	local ItemInfo Hair2;
	local int i;
	//~ local int j;
	local int decoIndex;

	local int jewelIndex;	
	
	//Debug ( "EquipItemUpdate"@ a_Info.Name @ "/" @ a_Info.SlotBitType) ;

	switch( a_Info.SlotBitType )
	{
	case 1:		// SBT_UNDERWEAR
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;
		hItemWnd = m_equipItem[ EQUIPITEM_Underwear ];
		break;
	case 2:		// SBT_REAR
	case 4:		// SBT_LEAR
	case 6:		// SBT_RLEAR
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;
		for( i = 0; i < m_EarItemList.Length; ++i )
		{
			if( IsSameServerID(m_EarItemList[ i ].ID, a_Info.ID) )
			{
				m_EarItemList[ i ] = a_Info;
				break;
			}
		}

		// �� ã���� ���� �߰�
		if( i == m_EarItemList.Length )
		{
			m_EarItemList.Length = m_EarItemList.Length + 1;
			m_EarItemList[m_EarItemList.Length-1] = a_Info;
		}

		hItemWnd = None;
		EarItemUpdate();
		break;
	case 8:		// SBT_NECK
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;
		hItemWnd = m_equipItem[ EQUIPITEM_Neck ];
		break;
	case 16:	// SBT_RFINGER
	case 32:	// SBT_LFINGER
	case 48:	// SBT_RLFINGER

		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		for( i = 0; i < m_FingerItemList.Length; ++i )
		{
			if( IsSameServerID(m_FingerItemList[ i ].ID, a_Info.ID) )
			{
				m_FingerItemList[ i ] = a_Info;
				break;
			}
		}

		// �� ã���� ���� �߰�
		if( i == m_FingerItemList.Length )
		{
			m_FingerItemList.Length = m_FingerItemList.Length + 1;
			m_FingerItemList[m_FingerItemList.Length-1] = a_Info;
		}

		hItemWnd = None;
		FingerItemUpdate();
		break;
	case 64:	// SBT_HEAD		
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		hItemWnd = m_equipItem[ EQUIPITEM_Head ];
		hItemWnd.EnableWindow();	
		break;
	case 128:	// SBT_RHAND
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;
			
		hItemWnd = m_equipItem[ EQUIPITEM_RHand ];
		break;
	case 256:	// SBT_LHAND
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		hItemWnd = m_equipItem[ EQUIPITEM_LHand ];
		hItemWnd.EnableWindow();
		break;
	case 512:	// SBT_GLOVES
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		hItemWnd = m_equipItem[ EQUIPITEM_Gloves ];
		hItemWnd.EnableWindow();		
		break;
	case 1024:	// SBT_CHEST
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		hItemWnd = m_equipItem[ EQUIPITEM_Chest ];			
		break;
	case 2048:	// SBT_LEGS
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		hItemWnd = m_equipItem[ EQUIPITEM_Legs ];
		hItemWnd.EnableWindow();
		break;
	case 4096:	// SBT_FEET
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		hItemWnd = m_equipItem[ EQUIPITEM_Feet ];
		hItemWnd.EnableWindow();
		break;
	case 8192:	// SBT_BACK
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		hItemWnd = m_equipItem[ EQUIPITEM_Cloak ];		
		hItemWnd.EnableWindow();
		break;	
	case 16384:	// SBT_RLHAND
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		hItemWnd = m_equipItem[ EQUIPITEM_RHand ];
		ClearLHand = true;	
		// RHand�� Bow�� ���Դµ�, LHand�� ȭ���� �ִ� ��� ȭ���� �״�� �����ش� - NeverDie
		if( IsBowOrFishingRod( a_Info ) )		
			if( m_equipItem[ EQUIPITEM_LHand ].GetItem( 0, TheItemInfo ) )			
				if( IsArrow( TheItemInfo ) )
					ClearLHand = false;			
				
		// ������� ���������� ���� ���� ������� ��Ʈ�� �����ش�. 
		if( IsBowOrFishingRod( a_Info ) )
			if( m_equipItem[ EQUIPITEM_LHand ].GetItem( 0, TheItemInfo ) )
				if( IsArrow( TheItemInfo ) )
					ClearLHand = false;		
		
		//LRHAND ��쿡�� ex1 , ex2 �� �ִ°� �ְ� ���°� �־ ���� ó���� �ʿ��մϴ�. ;; -innowind
		if( ClearLHand )	
		{
			if(Len(a_Info.IconNameEx1) !=0)
			{
				RHand = a_info;
				LHand = a_info;				
				RHand.IconIndex = 1;
				LHand.IconIndex = 2;
				//RHand.IconName = a_Info.IconNameEx1;
				//LHand.IconName = a_Info.IconNameEx2;
				m_equipItem[ EQUIPITEM_RHand ].Clear();
				m_equipItem[ EQUIPITEM_RHand ].AddItem( RHand );
				//m_equipItem[ EQUIPITEM_RHand ].DisableWindow();
				m_equipItem[ EQUIPITEM_LHand ].Clear();
				m_equipItem[ EQUIPITEM_LHand ].AddItem( LHand );
				m_equipItem[ EQUIPITEM_LHand ].DisableWindow();
				hItemWnd = None;	// ������ �̹����� ������ �ʵ��� �⺻ ������ �����ش�.
			}
			// Ȱ�̳� â���� �������̹����� �Ȱ��� ���.
			else	
			{
				m_equipItem[ EQUIPITEM_LHand ].Clear();
				m_equipItem[ EQUIPITEM_LHand ].AddItem( a_Info );
				m_equipItem[ EQUIPITEM_LHand ].DisableWindow();				
			}
			
		}
		break;
	case 32768:	// SBT_ONEPIECE
		// ����

		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		hItemWnd = m_equipItem[ EQUIPITEM_Chest ];
		a_Info.IconIndex = 1; // ���� ������
		// ����
		Legs = a_Info;
		
		Legs.IconIndex = 2; // ���� �������� �׷��ش�. 
		m_equipItem[ EQUIPITEM_Legs ].Clear();
		m_equipItem[ EQUIPITEM_Legs ].AddItem( Legs );
		m_equipItem[ EQUIPITEM_Legs ].DisableWindow();
		break;
	case 65536:	// SBT_HAIR
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		hItemWnd = m_equipItem[ EQUIPITEM_Hair ];
		break;
	case 131072:	// SBT_ALLDRESS
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		hItemWnd = m_equipItem[ EQUIPITEM_Chest ];
		Hair2 = a_info;	//������ head�� �����־�� ������ �޸� ������������ hair2�� �ֽ��ϴ�. - innowind
		Gloves = a_info;
		Legs = a_info;
		Feet = a_info;
		Hair2.IconName = a_Info.IconNameEx1;
		Gloves.IconName = a_Info.IconNameEx2;
		Legs.IconName = a_Info.IconNameEx3;
		Feet.IconName = a_Info.IconNameEx4;
		m_equipItem[ EQUIPITEM_Head ].Clear();
		m_equipItem[ EQUIPITEM_Head ].AddItem( Hair2 );
		m_equipItem[ EQUIPITEM_Head ].DisableWindow();
		m_equipItem[ EQUIPITEM_Gloves ].Clear();
		m_equipItem[ EQUIPITEM_Gloves ].AddItem( Gloves );
		m_equipItem[ EQUIPITEM_Gloves ].DisableWindow();
		m_equipItem[ EQUIPITEM_Legs ].Clear();
		m_equipItem[ EQUIPITEM_Legs ].AddItem( Legs );
		m_equipItem[ EQUIPITEM_Legs ].DisableWindow();
		m_equipItem[ EQUIPITEM_Feet ].Clear();
		m_equipItem[ EQUIPITEM_Feet ].AddItem( Feet );
		m_equipItem[ EQUIPITEM_Feet ].DisableWindow();
		break;
	case 262144:	// SBT_HAIR2
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		hItemWnd = m_equipItem[ EQUIPITEM_Hair2 ];
		hItemWnd.EnableWindow();
		break;
	case 524288:	// SBT_HAIRALL
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;

		hItemWnd = m_equipItem[ EQUIPITEM_Hair ];		
		m_equipItem[ EQUIPITEM_Hair2 ].Clear();
		m_equipItem[ EQUIPITEM_Hair2 ].AddItem( a_info );
		m_equipItem[ EQUIPITEM_Hair2 ].DisableWindow();
		break;
	case 1048576: //SBT_RBracelet
		handleChkSwitchEquipBox ( EQUIPITEM_RBracelet, a_info, bSwitchExpandEquipBox ) ;
		hItemWnd = m_equipItem[ EQUIPITEM_RBracelet ];
		m_equipItem[ EQUIPITEM_RBracelet ].Clear();
		m_equipItem[ EQUIPITEM_RBracelet ].AddItem( a_info );
		m_equipItem[ EQUIPITEM_RBracelet ].EnableWindow();
		break;	
	// Ż������ ��
	case 4194304:	//SBT_Deco1;
	// �Ʒ��� ��ȥ�� 
	case 12582912 :
	case 50331648 :
	case 201326592:
		handleChkSwitchEquipBox ( EQUIPITEM_RBracelet, a_info, bSwitchExpandEquipBox ) ;
		decoIndex = GetDecoIndex(a_info.Id);
		if (decoIndex != -1)
		{
			m_equipItem[ EQUIPITEM_Deco1 + decoIndex ].Clear();
			m_equipItem[ EQUIPITEM_Deco1 + decoIndex ].AddItem( a_info );
			m_equipItem[ EQUIPITEM_Deco1 + decoIndex ].EnableWindow();
		}	

		break;
	case 268435456:
		handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;
		hItemWnd = m_equipItem[ EQUIPITEM_Waist ];
		break;
	case 536870912: //Brooch �������� ���

//		m_equipItem_Brooch.Clear();
		//m_equipItem_Brooch.AddItem( a_info );
		//m_equipItem_Brooch.EnableWindow();
//		m_BroochEquiped.ShowWindow();
		handleChkSwitchEquipBox ( EQUIPITEM_Brooch, a_info, bSwitchExpandEquipBox ) ;
		hItemWnd = m_equipItem[ EQUIPITEM_Brooch ];
		m_equipItem[ EQUIPITEM_Brooch ].Clear();
		m_equipItem[ EQUIPITEM_Brooch ].AddItem( a_info );
		m_equipItem[ EQUIPITEM_Brooch ].EnableWindow();
		
		
		break;

	case 1073741824:	//Brooch_Jewel1;	
		handleChkSwitchEquipBox ( EQUIPITEM_Brooch, a_info,  bSwitchExpandEquipBox) ;
		UpdateJewelSlot(a_info);
		break;
	// 16�� 12�� �ư��ÿ� ������� ����
	/* case  2097152: 	 //SBT_LBracelet
		hItemWnd = m_equipItem[ EQUIPITEM_LBracelet ];
		m_equipItem[ EQUIPITEM_LBracelet ].Clear();
		m_equipItem[ EQUIPITEM_LBracelet ].AddItem( a_info );
		m_equipItem[ EQUIPITEM_LBracelet ].EnableWindow();		
		// Updates Talisman Item slot activation when the Bracelet slot has not equipped. 
		//~ if (!m_equipItem[ EQUIPITEM_Deco1 ].IsEnableWindow())
		//~ {
		//~ UpdateTalismanSlotActivation();
		//~ }
	break;*/
	case 2097152:	//�ư��ÿ� ;	
		//~ debug ("������ ��ȣ" @ a_info.ItemType );
		handleChkSwitchEquipBox ( EQUIPITEM_LBracelet, a_info, bSwitchExpandEquipBox ) ;		
		hItemWnd = m_equipItem[ EQUIPITEM_LBracelet ];
		m_equipItem[ EQUIPITEM_LBracelet ].Clear();
		m_equipItem[ EQUIPITEM_LBracelet ].AddItem( a_info );
		m_equipItem[ EQUIPITEM_LBracelet ].EnableWindow();		
		break;
	//�ư��ÿ� ���� ����
	case INT64("206158430208") : 
		handleChkSwitchEquipBox ( EQUIPITEM_LBracelet, a_info, bSwitchExpandEquipBox ) ;		
		handleAgathionEquip( a_info ) ;	
		break;
	// ��Ƽ��Ʈ �� 
	case INT64("2199023255552") :
	case 2199023255552:
		handleChkSwitchEquipBox ( EQUIPITEM_ARTIFACT, a_info, bSwitchExpandEquipBox ) ;
		// ���� ���� �� ���¿���, å�� �ٲٴ� ��찡 �����Ƿ�, 		
		m_equipItem[ EQUIPITEM_ARTIFACT ].Clear();
		m_equipItem[ EQUIPITEM_ARTIFACT ].AddItem( a_info );
		m_equipItem[ EQUIPITEM_ARTIFACT ].EnableWindow();
		hItemWnd = m_equipItem[ EQUIPITEM_ARTIFACT ];
		hItemWnd.Clear();
		hItemWnd.AddItem(a_Info);
		ResetArtifactSkillList();
		break;
	default :
		if ( IsArtifactRuneItem( a_info ) )
		{
			handleChkSwitchEquipBox ( EQUIPITEM_ARTIFACT, a_info, bSwitchExpandEquipBox ) ;
			//Debug ( "handleChkSwitchEquipBox" @ GetArtifactIndex( a_info.ID ) @ a_info.name  );
			handleArtifactEquip( a_info );
		}
		else 
			handleChkSwitchEquipBox ( -1, a_info, bSwitchExpandEquipBox ) ;
		break;
	}

	if( None != hItemWnd )
	{
		hItemWnd.Clear();	
		hItemWnd.AddItem( a_Info );		
	}
}

// ������ ������Ʈ  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function HandleUpdateUserEquipSlotInfo()
{
	EarItemUpdate();
	FingerItemUpdate();

	UpdateTalismanSlotActivation();
	UpdateJewelSlotActivation();//bm
	UpdateAgathionSlotActivation();
}

/********************************************************************************************
 * ��� ����
 * ******************************************************************************************/
//��� ���� �� Ż������, ���� ���� ó��
function handleRequestUnequipItem(String DragSrcName, itemID infoID, int64 slotbitType)
{	
    local string tmpSlotbitType;

	//Debug("getEquipItemSlotBit" @ DragSrcName);
	if(-1 != InStr(DragSrcName, "Talisman"))
	{	
		switch(Right(DragSrcName, 1))
		{
			case "1":
				tmpSlotbitType = string(SBT_DECO1);
				break;
			case "2":
				tmpSlotbitType = string(SBT_DECO2);
				break;
			case "3":
				tmpSlotbitType = string(SBT_DECO3);
				break;
			case "4":
				tmpSlotbitType = string(SBT_DECO4);
				break;
			case "5":
				tmpSlotbitType = string(SBT_DECO5);
				break;
			case "6":
				tmpSlotbitType = string(SBT_DECO6);
				break;
		}
	}
	else if(-1 != InStr(DragSrcName, "Jewel"))
	{
		switch(Right(DragSrcName, 1))
		{
			case "1":
				tmpSlotbitType = string(SBT_JEWEL1);
				break;
			case "2":
				tmpSlotbitType = string(SBT_JEWEL2);
				break;
			case "3":
				tmpSlotbitType = string(SBT_JEWEL3);
				break;
			case "4":
				tmpSlotbitType = string(SBT_JEWEL4);
				break;
			case "5":
				tmpSlotbitType = string(SBT_JEWEL5);
				break;
			case "6":
				tmpSlotbitType = string(SBT_JEWEL6);
				break;
			default:
		}
	}
	else if(-1 != InStr(DragSrcName, "Agathion"))
		tmpSlotbitType =  getAgathionSlotBitTypeString(Right(DragSrcName, 1));
	else if(-1 != InStr(DragSrcName, "Artifact"))
		tmpSlotbitType = getArtifactSlotBitTypeString(Right(DragSrcName, 3));

	//Debug("SotBitType "  @ tmpSlotbitType @ right(DragSrcName, 3) );

	if(tmpSlotbitType == "")RequestUnequipItem(infoID, slotbitType);
	else RequestUnequipItem(infoID, int64(tmpSlotbitType));
}

// ���� ���� 
function EquipItemDelete(ItemID sID)
{
	local int i;
	local int Index;
	local ItemInfo TheItemInfo;
	//TooltipItem.name = "HIHI";
	//TooltipItem.IconName = "L2ui_ct1.emptyBtn";
	//ClearItemID(TooltipItem.ID);

	//GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipItem_tooltip").ShowWindow(); 
	//GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipItem_tooltip").EnableWindow(); 
	//GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipItem_tooltip").SetTextureCtrlType(ETextureCtrlType.TCT_Control);
	//GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipItem_tooltip").SetTooltipCustomType(MakeTooltipSimpleText("asdfassdf"));

	for(i = 0; i < EQUIPITEM_Max; ++i)
	{
		Index = m_equipItem[ i ].FindItem(sID);	// ServerID
		if(-1 != Index)
		{
			m_equipItem[ i ].Clear();

			//ttp 63832�� �߰� ������ �����ֱ� ���� enable ��Ŵ
			m_equipItem[ i ].EnableWindow();

			//m_equipItem[ i ].HideWindow();
			//m_equipItem[ i ].AddItem(TooltipItem);
			//m_equipItem[ i ].DisableWindow();			

			// ȭ���� ������ ���, ���ڸ��� Ȱ ����� ǥ�õǾ���Ѵ�.
			if(i == EQUIPITEM_LHand)
			{
				if(m_equipItem[ EQUIPITEM_RHand ].GetItem(0, TheItemInfo))
				{
					if(TheItemInfo.SlotBitType != 16384)
						continue;
				}
			}
			else if(i == EQUIPITEM_RHand)
				SetSigilShieldTextureChange(true);

			//���� �� ��� �ִ� ���ġ ���� ����
			// �׸��� �� ���������� ä�� OnSelectItemWithHandle �̺�Ʈ�� �߻� ��Ų��.
			
			switch(i)
			{
				// ���� ������ ��
				case EQUIPITEM_Brooch :
				case EQUIPITEM_LBracelet :
				case EQUIPITEM_RBracelet :
					setExpandEquipItemButton(i);
					switchEquipBox(i);
				break;
				// ���� ������ ��
				case EQUIPITEM_Deco1:
				case EQUIPITEM_Deco2:
				case EQUIPITEM_Deco3:
				case EQUIPITEM_Deco4:
				case EQUIPITEM_Deco5:
				case EQUIPITEM_Deco6:
					switchEquipBox(EQUIPITEM_RBracelet);
					break;
				// case EQUIPITEM_Deco7:
				// case EQUIPITEM_Deco8:
				// case EQUIPITEM_Deco9:
				// case EQUIPITEM_Deco10:
				// case EQUIPITEM_Deco11:
				// case EQUIPITEM_Deco12:
				// 	switchEquipBox(EQUIPITEM_RBracelet);
				// break;
				case EQUIPITEM_Jewel1:
				case EQUIPITEM_Jewel2:
				case EQUIPITEM_Jewel3:
				case EQUIPITEM_Jewel4:
				case EQUIPITEM_Jewel5:
				case EQUIPITEM_Jewel6:
				case EQUIPITEM_Jewel7:
				case EQUIPITEM_Jewel8:
				case EQUIPITEM_Jewel9:
				case EQUIPITEM_Jewel10:
				case EQUIPITEM_Jewel11:
				case EQUIPITEM_Jewel12:
					switchEquipBox(EQUIPITEM_Brooch);
				break;
				case EQUIPITEM_AGATHION_MAIN :
				case EQUIPITEM_AGATHION_SUB1 :
				case EQUIPITEM_AGATHION_SUB2 :
				case EQUIPITEM_AGATHION_SUB3 :
				case EQUIPITEM_AGATHION_SUB4 :
					switchEquipBox(EQUIPITEM_LBracelet);
				break;
				case EQUIPITEM_ARTIFACT:
				case EQUIPITEM_ARTIFACT1_SUB1:
				case EQUIPITEM_ARTIFACT1_SUB2:
				case EQUIPITEM_ARTIFACT1_SUB3:
				case EQUIPITEM_ARTIFACT1_SUB4:
				case EQUIPITEM_ARTIFACT2_SUB1:
				case EQUIPITEM_ARTIFACT2_SUB2:
				case EQUIPITEM_ARTIFACT2_SUB3:
				case EQUIPITEM_ARTIFACT2_SUB4:
				case EQUIPITEM_ARTIFACT3_SUB1:
				case EQUIPITEM_ARTIFACT3_SUB2:
				case EQUIPITEM_ARTIFACT3_SUB3:
				case EQUIPITEM_ARTIFACT3_SUB4:
				case EQUIPITEM_ARTIFACT1_MAIN1:
				case EQUIPITEM_ARTIFACT1_MAIN2:
				case EQUIPITEM_ARTIFACT1_MAIN3:
				case EQUIPITEM_ARTIFACT2_MAIN1:
				case EQUIPITEM_ARTIFACT2_MAIN2:
				case EQUIPITEM_ARTIFACT2_MAIN3:
				case EQUIPITEM_ARTIFACT3_MAIN1:
				case EQUIPITEM_ARTIFACT3_MAIN2:
				case EQUIPITEM_ARTIFACT3_MAIN3:
					ResetArtifactSkillList();
					SwitchEquipBox(EQUIPITEM_ARTIFACT);
				break;
			}
		}
	}
}

// ������ ���� �Ǿ�� �� �����۵��� �� ���� ä���
// �� �������� ������ Ŭ�� �Ǿ� ���� �ʴ´�.
// ->>>> ���� �̽��� ��ư���� ���� 
// ��� ���� �� Show ó�� �ش�. 
function setExpandEquipItemButton(int i)
{
	
	switch(i)
	{
		case EQUIPITEM_RBracelet:
			EquipItem_RBracelet_Button.ShowWindow();
		break;
		case EQUIPITEM_LBracelet:
			EquipItem_LBracelet_Button.ShowWindow();
			break;
		case EQUIPITEM_Brooch:
			EquipItem_Brooch_Button.ShowWindow();
			break;
		case EQUIPITEM_ARTIFACT :
			// End:0x75
			EquipItem_Artifact_Button.ShowWindow();
			break;
	}
}

function ArtifactRuneDelete(ItemInfo item)
{
    local int FindIdx;
    local ItemInfo ClearItem;

    ClearItemID(ClearItem.Id);
    ClearItem.IconName = "L2ui_ct1.emptyBtn";
    FindIdx = m_artifactRuneItem.FindItem(item.Id);
    // End:0x7C
    if(FindIdx != -1)
    {
        m_artifactRuneItem.SetItem(FindIdx, ClearItem);
        m_ArtifactInvenCount--;
    }
}


/********************************************************************************************
 * ������ ����
 * ******************************************************************************************/
function InvenDelete(ItemInfo item)
{
	local int FindIdx;
	local int DetailFindIdx;
	local ItemInfo ClearItem;

	local itemWindowHandle detailItemWindow;

	detailItemWindow = getItemWindowHandleByItemType(item);
	ClearItemID(ClearItem.ID);

	//������ Ȱ��ȭ �κ� �ؽ��� ó��
	ClearItem.IconName = "L2ui_ct1.emptyBtn";
	FindIdx = m_invenItem.FindItem(item.ID);
	DetailFindIdx = detailItemWindow.FindItem(item.ID);

	//Debug("InvenDelete" @ FindIdx @  DetailFindIdx);
	if(FindIdx != -1)
	{
		m_invenItem.SetItem(FindIdx, ClearItem);
		detailItemWindow.SetItem(DetailFindIdx, ClearItem);
		m_NormalInvenCount--;
	}
}

function QuestInvenDelete(ItemInfo item)
{
	local int FindIdx;
	local ItemInfo ClearItem;

	FindIdx = m_questItem.FindItem(item.ID);
	if(FindIdx != -1)
	{
		//����� �ٽ� �� ���� ���������� ä���ش�.
		m_questItem.DeleteItem(FindIdx);
		m_QuestInvenCount--;

		ClearItemID(ClearItem.ID);
		ClearItem.IconName = "L2ui_ct1.emptyBtn";
		m_questItem.AddItem(ClearItem);		
	}
}

/********************************************************************************************
 * ������ ������  Ŭ����
 * ******************************************************************************************/
function HandleClear()
{
	// tt 61481 ���� ���� �������� ���� ���� ��ġ ���� ���� �մϴ�.
	if(m_hOwnerWnd.IsShowWindow())saveLocalItemOrder();	

	InvenClear();
	invenItem_1Clear();
	invenItem_2Clear();
	invenItem_3Clear();
	invenItem_4Clear();	
	QuestInvenClear();
	artifactItemClear();
	EquipItemClear();

	m_EarItemList.Length = 0;
	m_FingerItemLIst.Length = 0;
	m_DecoItemList.Length = 0;

	InvenLimitUpdate();

	bIsQuestItemList = false;
}

// ��� ������ Ŭ���� 
function EquipItemClear()
{
	local int i;

	for(i = 0; i < EQUIPITEM_Max; ++i)
		m_equipItem[i].Clear();

	setExpandEquipItemButton(EQUIPITEM_Brooch);
	setExpandEquipItemButton(EQUIPITEM_LBracelet);
	setExpandEquipItemButton(EQUIPITEM_RBracelet);
	setExpandEquipItemButton(EQUIPITEM_ARTIFACT);
}

// �Ϲ� �κ� Ŭ����
function InvenClear()
{	
	m_invenItem.Clear();	
	m_NormalInvenCount = 0;
}

function QuestInvenClear()
{	
	m_questItem.Clear();
	m_QuestInvenCount = 0;
}

function invenItem_1Clear()
{
	m_invenItem_1.Clear();
}

function invenItem_2Clear()
{
	m_invenItem_2.Clear();
}

function invenItem_3Clear()
{
	m_invenItem_3.Clear();
}

function invenItem_4Clear()
{
	m_invenItem_4.Clear();
}

function artifactItemClear()
{
    m_artifactRuneItem.Clear();
    m_ArtifactInvenCount = 0;
    return;
}

/********************************************************************************************
 * ������ ��ġ ����
 * ******************************************************************************************/
// �������� ������ local�� ���� �� ��.
// �������� �ű� ���, ������ Ŭ���� ���� ���� ��.
function saveLocalItemOrder()
{
	local int  i;
	
	bIsSavedLocalItemIdx = true;
	// Debug("saveLocalItemOrder" @ itemSwapedServerID.length);
	for(i = 0 ; i < m_invenItem.GetItemNum(); i ++)
	{
		saveServerID(m_invenItem, i, itemSwapedServerID, itemSwapedIdx);
		saveServerID(m_invenItem_1, i, itemSwapedServerID_1, itemSwapedIdx_1);
		saveServerID(m_invenItem_2, i, itemSwapedServerID_2, itemSwapedIdx_2);
		saveServerID(m_invenItem_3, i, itemSwapedServerID_3, itemSwapedIdx_3);
		saveServerID(m_invenItem_4, i, itemSwapedServerID_4, itemSwapedIdx_4);
	}

	for(i = 0; i < m_questItem.GetItemNum(); i++)
		saveServerID(m_questItem, i, itemSwapedServerID_q, itemSwapedIdx_q);

	
	for(i = 0; i < m_artifactRuneItem.GetItemNum(); i++)
		saveServerID(m_artifactRuneItem, i, itemSwapedServerID_a, itemSwapedIdx_a);
}

function saveServerID(ItemWindowHandle targetWindow, int idx,  out array<int> serverIDList, out array<int> SwapedIdx)
{
	local iteminfo invenInfo;

	targetWindow.GetItem(idx , invenInfo);

	if(invenInfo.ID.serverID != -1)
	{
		invenInfo.Order = idx;
		idx = serverIDList.length;
		serverIDList.length = serverIDList.length  + 1;
		serverIDList[ idx ] = invenInfo.ID.serverID;
		SwapedIdx[ idx ] = invenInfo.Order;
		//Debug( "saveServerID" @ invenInfo.Name @  invenInfo.Order @ targetWindow.GetWindowName());
	}
}

// ������ order�� ã��
function int getLocalItemOrder(int serverID, array<int> serverIDList, array<int> SwapedIdx, int defaultOrder )
{
	local int i ;
	for(i = 0 ; i < serverIDList.Length ; i ++)
	{
		if(serverIDList[ i ] == serverID)
			return SwapedIdx[ i ];
	}

	return defaultOrder;
}

function int getLocalItemOrderByItemWindow(itemWindowHandle targetWindow, int serverID, int defaultOrder)
{
	switch(targetWindow)
	{				
		case m_invenItem_1:
			return getLocalItemOrder(serverID, itemSwapedServerID_1, itemSwapedIdx_1, defaultOrder);		
		case m_invenItem_2:
			return getLocalItemOrder(serverID, itemSwapedServerID_2, itemSwapedIdx_2, defaultOrder);		
		case m_invenItem_3:
			return getLocalItemOrder(serverID, itemSwapedServerID_3, itemSwapedIdx_3, defaultOrder);		
		case m_invenItem_4:
			return getLocalItemOrder(serverID, itemSwapedServerID_4, itemSwapedIdx_4, defaultOrder);		
		case m_questItem:
			return getLocalItemOrder(serverID, itemSwapedServerID_q, itemSwapedIdx_q, defaultOrder);
	}
	return defaultOrder;
}

// ������ ��ġ�� ������ ���� ��.
function SaveInventoryOrder()
{
	local int idx;
	local int InvenLimit;

	local ItemInfo item;
	local array<ItemID> IDList;
	local array<int> OrderList;
	
	// �Ϲ� ������ ��ġ ����
	InvenLimit = m_invenItem.GetItemNum();
	
	for( idx=0; idx<InvenLimit; idx++ )
	{
		if( m_invenItem.GetItem( idx, item ) )
			if( IsValidItemID( item.ID ) )
			{
				IDList.Insert(IDList.Length, 1);
				IDList[IDList.Length-1] = item.ID;
				
				OrderList.Insert(OrderList.Length, 1);
				OrderList[OrderList.Length-1] = item.Order;

			//	Debug ("�⺻ order" @ item.Order @  class'UIDATA_ITEM'.static.GetItemName(item.ID )  );
			}
	}

	//if( IDList.Length > 0 )
	//	RequestSaveInventoryOrder( IDList, OrderList );
	
	// ��Ƽ��Ʈ ������ ��ġ ����
	InvenLimit = m_artifactRuneItem.GetItemNum();
	
	for( idx=0; idx<InvenLimit; idx++ )
	{
		if( m_artifactRuneItem.GetItem( idx, item ) )
			if( IsValidItemID( item.ID ) )
			{
				IDList.Insert(IDList.Length, 1);
				IDList[IDList.Length-1] = item.ID;
				
				OrderList.Insert(OrderList.Length, 1);
				OrderList[OrderList.Length-1] = item.Order;
				//Debug ("��Ƽ��Ʈ order" @ item.Order @  class'UIDATA_ITEM'.static.GetItemName(item.ID )  );
			}
	}
	
	if( IDList.Length > 0 )
	{
	//	Debug ( "RequestSaveInventoryOrder" ) ;
		RequestSaveInventoryOrder( IDList, OrderList );
	}

	// ���� 6, 12�� ���ο� �κ��丮 ������ ���� ���� ��Ų��.
	//SetOptionInt( "Game", "ItemInventoryCol",  currentInvenCol);

	// �κ��丮 ���� �� false ó�� �Ѵ�.	
	bIsSavedLocalItemIdx = false;
	itemSwapedIdx.Length = 0 ;
	itemSwapedIdx_1.Length = 0 ;
	itemSwapedIdx_2.Length = 0 ;
	itemSwapedIdx_3.Length = 0 ;
	itemSwapedIdx_4.Length = 0 ;
	itemSwapedIdx_q.Length = 0 ;
	itemSwapedIdx_a.Length = 0 ;
	itemSwapedServerID.Length = 0 ;
	itemSwapedServerID_1.Length = 0 ;
	itemSwapedServerID_2.Length = 0 ;
	itemSwapedServerID_3.Length = 0 ;
	itemSwapedServerID_4.Length = 0 ;
	itemSwapedServerID_q.Length = 0 ;
	itemSwapedServerID_a.Length = 0 ;
}


///********************************************************************************************
// * �Ǻ� �Լ� ��
// * ******************************************************************************************/
//// ��Ƽ��Ʈ �ΰ�? ��Ƽ��Ʈ ������ Ư�� ������ ���� 
// function bool IsArtifactRuneItem(ItemInfo info)
// {
// 	//Debug("IsArtifactRuneItem0:" @ String(info.slotBitType)@ "/" @ String(info.slotBitType)== "18014398509481984" @ "/" @  info.slotBitType == 18014398509481984);
// 	//Debug("IsArtifactRuneItem1:" @info.slotBitType == 18014398509481984);
// 	//Debug("IsArtifactRuneItem2:" @info.slotBitType == 144115188075855872);
// 	//Debug("IsArtifactRuneItem3:" @info.slotBitType == 1152921504606846976);
// 	//Debug("IsArtifactRuneItem4:" @info.slotBitType == 4398046511104);
	
// 	switch(info.slotBitType)
// 	{   // ��Ƽ��Ʈ Ư���� 1
// 		case ARTIFACTTYE_TYPE1 :
// 		// ��Ƽ��Ʈ Ư���� 2
// 		case ARTIFACTTYE_TYPE2 :
// 		// ��Ƽ��Ʈ Ư���� 3
// 		case ARTIFACTTYE_TYPE3 :
// 		// ��Ƽ��Ʈ �Ϲݷ�
// 		case ARTIFACTTYE_NORMAL :
// 			return true;
// 		break;
// 	}
// 	//Debug("IsArtifactItem" @ EItemtype(info.ItemType)) ;
// 	return false;
// }


// ��� �ΰ�
function bool IsEquipItem(out ItemInfo info)
{
	return info.bEquipped;
}

// ����Ʈ ������ �ΰ�?
function bool IsQuestItem(out ItemInfo info)
{
	return EItemType(info.ItemType) == ITEM_QUESTITEM;
}

// �Ͱ��� �ΰ�?
function int IsLOrREar(ItemID sID)
{
	local ItemID LEar;
	local ItemID REar;
	local ItemID LFinger;
	local ItemID RFinger;

	GetAccessoryItemID(LEar, REar, LFinger, RFinger);

	if(IsSameServerID(sID, LEar))
		return -1;
	else if(IsSameServerID(sID, REar))
		return 1;
	else
		return 0;
}

// ���� �ΰ�?
function int IsLOrRFinger(ItemID sID)
{
	local ItemID LEar;
	local ItemID REar;
	local ItemID LFinger;
	local ItemID RFinger;

	GetAccessoryItemID(LEar, REar, LFinger, RFinger);

	if(IsSameServerID(sID, LFinger))
		return -1;
	else if(IsSameServerID(sID, RFinger))
		return 1;
	else
		return 0;
}

//���� �� �ΰ�?
function bool IsBowOrFishingRod(ItemInfo a_Info)
{
	//~ debug("������� ��ȣ?"@  a_Info.WeaponType);
	// Ȱ, ����?? ũ�ν�����, ��� ũ�ν�����
	switch(AttackType(a_Info.WeaponType))
	{
		case AT_BOW:
		case AT_FISHINGROD:
		case AT_CROSSBOW:
		case AT_TWOHANDCROSSBOW:
		return true;
	}

	return false;
}

// ȭ�� �ΰ�?
function bool IsArrow(ItemInfo a_Info)
{
	return a_Info.bArrow;
}

// �巡�� �ҽ��� �κ��丮 �ΰ�?
function bool isDragSrcInventory ( string DragSrcName )
{
	switch ( DragSrcName ) 
	{
		case "InventoryItem"   : 
		case "QuestItem"   : 
		case "PetInvenWnd"   : 
		case "InventoryItem_1"   : 
		case "InventoryItem_2"   : 
		case "InventoryItem_3"   : 
		case "InventoryItem_4"   : 
		case "ArtifactItem"     :
			return true;
	}
	
	if ( -1 != InStr( DragSrcName, "EquipItem" ) ) return true ;

	return false;	
}

/*
* ��� �ϴ� ���� ����
// ��� ������ �ΰ�???? 
function INT64 IsDecoItem(ItemInfo a_Info)	// INT -> INT64, Jewel �߰� - by y2jinc(2013. 9. 2)
{
	return a_Info.SlotBitType;
}

//����â��, ����â��, ȭ��â��, ��ȯâ, ��������, �Ǹ�â, �����Ǹ�, ���α���, �ǸŴ��� â�� ������ ��� �����ϴ� ��ƾ
//�ٸ������ ���λ��� â���� ���� �����Ҷ��� �������� --;; - innowind
function bool IsShowInventoryWndUpt()
{
	local WindowHandle m_warehouseWnd;
	local WindowHandle m_privateShopWnd;
	local WindowHandle m_tradeWnd;
	local WindowHandle m_shopWnd;
	local WindowHandle m_multiSellWnd;
	local WindowHandle m_deliverWnd;
	local PrivateShopWnd m_scriptPrivateShopWnd;
	local WindowHandle m_PostBoxWnd, m_PostWriteWnd, m_PostDetailWnd_General, m_PostDetailWnd_SafetyTrade; 

	local WindowHandle m_sellingAgencyWnd;

	m_warehouseWnd = GetWindowHandle("WarehouseWnd");					//����â��, ����â��, ȭ��â��
	m_privateShopWnd = GetWindowHandle("PrivateShopWnd");					//�����Ǹ�, ���α���
	m_tradeWnd = GetWindowHandle("TradeWnd");							//��ȯ
	m_shopWnd = GetWindowHandle("ShopWnd");							//��������, �Ǹ�
	m_multiSellWnd = GetWindowHandle("MultiSellWnd");						//��������, �Ǹ�
	m_deliverWnd = GetWindowHandle("DeliverWnd");							//ȭ������
	m_scriptPrivateShopWnd = PrivateShopWnd(GetScript("PrivateShopWnd"));

	m_PostBoxWnd = GetWindowHandle("PostBoxWnd");
	m_PostWriteWnd = GetWindowHandle("PostWriteWnd");
	m_PostDetailWnd_General = GetWindowHandle("PostDetailWnd_General");
	m_PostDetailWnd_SafetyTrade = GetWindowHandle("PostDetailWnd_SafetyTrade");

	m_sellingAgencyWnd = GetWindowHandle("SellingAgencyWnd"); // �ǸŴ���

	if(m_warehouseWnd.IsShowWindow())
		return false;

	if(m_warehouseWnd.IsShowWindow())
		return false;

	if(m_tradeWnd.IsShowWindow())
		return false;

	if(m_shopWnd.IsShowWindow())
		return false;

	if(m_multiSellWnd.IsShowWindow())
		return false;

	if(m_deliverWnd.IsShowWindow())
		return false;

	if(m_privateShopWnd.IsShowWindow()&& m_scriptPrivateShopWnd.m_type == PT_Sell)
		return false;

	if(m_PostBoxWnd.IsShowWindow()|| m_PostWriteWnd.IsShowWindow()|| m_PostDetailWnd_General.IsShowWindow()|| m_PostDetailWnd_SafetyTrade.IsShowWindow())
		return false;

	if(m_sellingAgencyWnd.IsShowWindow())
		return false;

	return true;
}
*/

/********************************************************************************************
 * data
 * ******************************************************************************************/
// ��ü�� ���ϴ� ��� ������ ����
function int EquipNormalItemGetItemNum()
{
	local int i;
	local int ItemNum;

	// ��Ƽ��Ʈ ������ ���� ����
	for( i = 0; i <= EQUIPITEM_ARTIFACT; ++i )
	{
		if (m_equipItem[ i ].m_pTargetWnd != None)
		{
			if(m_equipItem[ i ].IsEnableWindow())
			{
				ItemNum = ItemNum + m_equipItem[ i ].GetItemNum();
			}
		}
	}

	for ( i = EQUIPITEM_Jewel7; i < EQUIPITEM_Jewel12; i++)
	{
		if (m_equipItem[ i ].m_pTargetWnd != None)
		{
			if(m_equipItem[ i ].IsEnableWindow())
			{
				ItemNum = ItemNum + m_equipItem[ i ].GetItemNum();
			}
		}
	}

	return ItemNum;
}

// ��Ƽ��Ʈ �鿡 ���ϴ� ��� ������ ����
function int EquipArtifactItemGetitemNum() 
{
	local int i;
	local int ItemNum;

	for( i = EQUIPITEM_ARTIFACT1_SUB1; i < EQUIPITEM_Max; ++i )
	{
		if ( (i >= EQUIPITEM_Jewel7) && (i <= EQUIPITEM_Jewel12) ) 
		{
			 continue;
		}
		if( m_equipItem[ i ].IsEnableWindow() ) 
		{
			ItemNum = ItemNum + m_equipItem[ i ].GetItemNum();
		}
	}

	return ItemNum;
}

// ���� ���̵� ���� ������ �����츦 ã��
function bool EquipItemFind(ItemID sID)
{
	local int i;
	local int Index;
	local ItemInfo iInfo;

	for(i = 0; i < EQUIPITEM_Max; ++i)
	{
		if(m_equipItem[i].GetItemNum() > 0)
		{
			m_equipItem[i].GetItem(0, iInfo);
		}
		Index = m_equipItem[i].FindItem(sID);	// ServerID
		if(-1 != Index)
			return true;
	}

	return false;
}

// �ܺο��� �κ��丮 ī��Ʈ�� �޾� ���� ���
function int getCurrentInventoryItemCount()
{
	return pInventoryItemCount;
}

//�ܺο��� �κ��丮 ������ ������ �� �̸��� �������� ���
// ���� PetInvenWnd ������ ��� �ƴ�.
function bool getInventoryItemWndName(string str)
{
	local int i;
	for(i = 0; i <= TAB_LENGTH; ++i)
	{
		if(i == 0)
		{
			if(("InventoryItem") == str)
			{
				return true;
			}
		}
		else if(("InventoryItem_" $ i) == str)
		{
			return true;
		}
	}
	return  ( "ArtifactItem" == str ) ;
}

// �ܺο���, �������� �κ��丮�� ������ ������, ������ ������ ��� �´�.(2014.03.18, �������濡�� ����Ϸ��� ����� ����)
// onlyUseClassID = true�� ������ serverID �� ������� �ʰ� ���� classID�� �������� ã�´�.(������ �����۸� ����ؾ� �Ѵ�)
function bool getInventoryItemInfo(ItemID id, out ItemInfo InvenItemInfo, optional bool onlyUseClassID)
{
	local bool bHasItem;
	local int i, index;
	local ItemInfo tempOutItemInfo, tmpItemInfo;

	bHasItem = false;

	// ������ �������� findItem ���� ���� ���̵� �����ؼ� ã���� �ȵǰ�, classID ������ �˻��ؾ� �Ѵ�.
	if(onlyUseClassID)	index = m_invenItem.FindItemByClassID(id);
	else index = m_invenItem.FindItem(id);
	
	if(index > -1){ m_invenItem.GetItem(index, InvenItemInfo); bHasItem = true; }

	// ����Ʈ ������ 
	index = m_questItem.FindItem(id);
	if(index > -1){ m_questItem.GetItem(index, InvenItemInfo); bHasItem = true; }

	// ��� ���� 
	for(i = 0; i < EQUIPITEM_Max; i++)
	{
		// index = m_equipItem[i].FindItem(id);
		if(onlyUseClassID)	index = m_equipItem[i].FindItemByClassID(id);
		else index = m_equipItem[i].FindItem(id);

		if(index > -1)
		{
			m_equipItem[i].GetItem(index, tempOutItemInfo);

			switch(i)
			{
				// ���� �� �� �� ������ ���� ����
				case EQUIPITEM_LHand :
					m_equipItem[EQUIPITEM_RHand].GetItem(0,tmpItemInfo);
				break;
				// ��� �Ǽ����� 1�� ���� ������ ���� ����
				case EQUIPITEM_Hair2:
					m_equipItem[EQUIPITEM_Hair].GetItem(0,tmpItemInfo);
				break;
			}

			// 2015-06-03 ���� ��ġ�� ���� �̰� �߸� �Ǿ� �ִµ� �ؼ� ����.
			if(tempOutItemInfo.ID.serverID == tmpItemInfo.ID.serverID)continue;
			// ������..
			//if(InvenItemInfo.ID.serverID == tmpItemInfo.ID.serverID)continue;

			InvenItemInfo = tempOutItemInfo;
			bHasItem = true;
			break;
		}
	}

	return bHasItem;
}

// �ش� �κ��丮�� �������� � �ֳ�?
function INT64 getItemCountByClassID(int classID)
{
	local int i, itemNum;
	local INT64 totalCount;
	local ItemInfo tempOutItemInfo, tmpItemInfo, info;
	local ItemID ID;

	ID.ClassID = classID;

	class'UIDATA_ITEM'.static.GetItemInfo( ID, info );

	// ������ �������ΰ�?
	if(IsStackableItem( info.ConsumeType ))
	{
		if(getInventoryItemInfo(ID, tempOutItemInfo, true))
		{
			return tempOutItemInfo.ItemNum;
		}
	}
	else
	{
		// �κ��丮 Total
		totalCount = getItemWindowCountByClassID(classID, m_invenItem);
		
		// ����Ʈ ������ 
		totalCount = totalCount + getItemWindowCountByClassID(classID, m_questItem);

		// ��Ƽ��Ʈ ������
		totalCount = totalCount + getItemWindowCountByClassID(classID, m_artifactRuneItem);
		
		// ��� ���� 
		for (i = 0; i < EQUIPITEM_Max; i++)
		{
			itemNum = m_equipItem[i].GetItemNum();
			
			if ( itemNum == 0 ) continue;

			m_equipItem[i].GetItem(0, tempOutItemInfo);

			switch ( i ) 
			{
				// ���� �� �� �� ������ ���� ����
				case EQUIPITEM_LHand :
					m_equipItem[EQUIPITEM_RHand].GetItem(0,tmpItemInfo);
				break;
				// ��� �Ǽ����� 1�� ���� ������ ���� ����
				case EQUIPITEM_Hair2:
					m_equipItem[EQUIPITEM_Hair].GetItem(0,tmpItemInfo);		
				break;
			}

			if ( tempOutItemInfo.ID.serverID != tmpItemInfo.ID.serverID ) 
			{
				totalCount = totalCount + getItemWindowCountByClassID(classID, m_equipItem[i]);
			}
		}
	}

	return totalCount;
}
// ������ �����쿡�� �ش� ClassID �������� ������ ��´�.
function INT64 getItemWindowCountByClassID(int ClassID, ItemWindowHandle targetItemWindow)
{
	local int i, cnt, index, totalItemNum;
	local ItemInfo tmInfo, tempOutItemInfo;
	
	local ItemInfo info;
	local ItemID ID;

	ID.ClassID = ClassID;

	class'UIDATA_ITEM'.static.GetItemInfo(ID, info);

	// ������ �������ΰ�?
	if(IsStackableItem(info.ConsumeType))
	{
		index = m_invenItem.FindItemByClassID(ID);

		if(getInventoryItemInfo(ID, tempOutItemInfo, true))
		{
			return tempOutItemInfo.ItemNum;
		}
	}

	totalItemNum = targetItemWindow.GetItemNum();
	for(i = 0; i < totalItemNum; i++)
	{
		targetItemWindow.GetItem(i, tmInfo);

		if(tmInfo.Id.ClassID == ClassID)
		{
			cnt++;
		}
	}
	return cnt;
}

// ���Ⱦ������������Ѹ����������迭�θ��Ϲ޴´�.
// bExceptionEquipItem = true ��������������ʴ´�.
function array<ItemInfo> getInventoryAllItemArray(optional bool bExceptionEquipItem)
{
        local int index;

        local array<ItemInfo> itemArray, totalItemArray, artifactItemArray;

        class'UIDATA_INVENTORY'.static.GetAllInvenItem(totalItemArray);
        class'UIDATA_INVENTORY'.static.GetAllArtifactItem(artifactItemArray);

        for (index = 0; index < totalItemArray.Length; index++)
        {
               if (totalItemArray[index].Id.ClassID <= 0) continue;
               itemArray[ itemArray.Length] = totalItemArray[index];
        }

        for (index = 0; index < artifactItemArray.Length; index++)
        {
               if (artifactItemArray[index].Id.ClassID <= 0) continue;
               itemArray[itemArray.Length] = artifactItemArray[index];
        }
        
        if (bExceptionEquipItem == false)
        {
               // ��񽽷�
               itemArray = L2Util(GetScript("L2Util")).pushItemInfoArray (itemArray, getInventoryEquipItemArray()); 
        }

        return itemArray;
}

// ���â�� �ִ� �����۵鸸 ����
function array<ItemInfo> getInventoryEquipItemArray()
{
	local int i, j ;//, itemNum ;

	local bool isSameItem;

	local array<ItemInfo> itemArray;

	local ItemInfo InvenItemInfo ;//, tmpItemInfo;
	
	// ��ũ ���� ���� ������(���� ���� �� �ٸ� �����۵� �������� �ν�)������ ���� ���� �Է� 
	m_equipItem[EQUIPITEM_Chest].GetItem(0, InvenItemInfo );
	if(IsValidItemID(InvenItemInfo.ID))
	{
		itemArray.Length = 1;
		itemArray[ 0 ] = InvenItemInfo;
	}

	// ��� ���� 
	for(i = 0; i < EQUIPITEM_Max; i++)
	{
		ClearItemID(InvenItemInfo.ID);

		m_equipItem[i].GetItem(0, InvenItemInfo);

		if(!IsValidItemID(InvenItemInfo.id))CONTINUE ;

		// TT 69146 : �Է� �� ������ �� ���� ���� �ִ� �� �˻�.
		// �Ǽ�����, ��հ�, ���ҵ�, ������, ���ǽ� ���
		isSameItem = false;

		for(j = 0 ; j < itemArray.Length ; j ++)
		{
			if(IsSameServerID(itemArray[j].ID, InvenItemInfo.ID))
			{
				isSameItem = true;
				continue;
			}
		}

		if(!isSameItem)
		{
			itemArray.Length = itemArray.Length + 1;
			itemArray[ itemArray.Length - 1 ] = InvenItemInfo;
		}
	}

	return itemArray;
}

function GetEquippedWeaponItem(out ItemInfo EquippedItem)
{
	local int i;
	local ItemInfo CheckItem;
	local array<ItemInfo> equipItemList;
	
	equipItemList = getInventoryEquipItemArray();
	for (i = 0; i < equipItemList.Length; i++)
	{
		CheckItem = equipItemList[i];
		// check if item is equipped and is rl_hand or r_hand slot bit type	
		if (CheckItem.bEquipped && (CheckItem.SlotBitType == SBT_RLHAND || CheckItem.SlotBitType == SBT_RHAND)) {
			EquippedItem = CheckItem;
			break;
		}
	}
}

function array<ItemInfo> GetArtifactEquipedList ( int ArtifactPageNum)
{
	local array<ItemInfo> artifactItemInfos;	
	
	switch ( ArtifactPageNum ) 
	{
		case 0 : 
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT1_MAIN1, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT1_MAIN2, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT1_MAIN3, artifactItemInfos ) ;

			GetEquipedListByIdx( EQUIPITEM_ARTIFACT1_SUB1, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT1_SUB2, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT1_SUB3, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT1_SUB4, artifactItemInfos ) ;
			break;
		case 1 :
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT2_MAIN1, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT2_MAIN2, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT2_MAIN3, artifactItemInfos ) ;

			GetEquipedListByIdx( EQUIPITEM_ARTIFACT2_SUB1, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT2_SUB2, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT2_SUB3, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT2_SUB4, artifactItemInfos ) ;
			break;
		case 2 :
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT3_MAIN1, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT3_MAIN2, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT3_MAIN3, artifactItemInfos ) ;

			GetEquipedListByIdx( EQUIPITEM_ARTIFACT3_SUB1, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT3_SUB2, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT3_SUB3, artifactItemInfos ) ;
			GetEquipedListByIdx( EQUIPITEM_ARTIFACT3_SUB4, artifactItemInfos ) ;
			break;
	}
	return artifactItemInfos ;
}

// ���ǵ� INDEX ������ ��� ������ ����.
function GetEquipedListByIdx(int idx,  out Array<ItemInfo> infos)
{	
	local itemInfo info;

	//Debug("GetEquipedListByIdx" @ m_equipItem[idx].GetItemNum());

	if(m_equipItem[idx].GetItemNum()> 0)
	{
		m_equipItem[idx].GetItem(0 , info);
		infos.Length = infos.Length + 1 ;
		infos[infos.Length -1 ] = info;	
	}
}

// �Ϲ� �κ� �ִ� ��
function int GetMyInventoryLimit()
{
	return m_MaxInvenCount;
}

// ����Ʈ �κ� �ִ� ��
function int GetQuestItemInventoryLimit()
{
	return m_MaxQuestItemInvenCount;
}


function int GetArtifactItemInventoryLimit()
{
    return m_MaxArtifactInvenCount;
}

	
/********************************************************************************************
 * ��ȥ ������ ����Ʈ �ޱ�
 * ******************************************************************************************/
// ��ȥ(��)���� ���� ������ ���� �ޱ�
function array<ItemInfo> getInventoryEnSoulExtractEnableItemArray()
{
	local int i, ItemNum, Index;
	local array<ItemInfo> itemArray;
	local ItemInfo InvenItemInfo;

	ItemNum = m_invenItem.GetItemNum();

	for(Index = 0; Index < ItemNum; Index++)
	{
		m_invenItem.GetItem(Index, InvenItemInfo);

		// ��ȥ�� ���⸸ ����
		if(InvenItemInfo.Id.ClassID <= 0)
		{
			continue;
		}

		if(InvenItemInfo.itemType == EItemType.ITEM_WEAPON || InvenItemInfo.itemType == EItemType.ITEM_ARMOR || InvenItemInfo.itemType == EItemType.ITEM_ACCESSARY)
		{
		}
		else
		{
			continue;
		}

		if(InvenItemInfo.bSecurityLock)
		{
			continue;
		}

		// ��ȥ ������ ������ ��ȥ�Ǿ� �ִ� ���� ��󳻱�
		if(hasEnsoulOption(InvenItemInfo))
		{
			itemArray.Length = itemArray.Length + 1;
			itemArray[itemArray.Length - 1] = InvenItemInfo;
		}
	}

	// ��� ���� 
	for(i = 0; i < EQUIPITEM_Max; i++)
	{
		ItemNum = m_equipItem[i].GetItemNum();
		for(Index = 0; Index < ItemNum; Index++)
		{
			m_equipItem[i].GetItem(Index, InvenItemInfo);
			if(EQUIPITEM_LHand == i)
			{
				continue;
			}
			// ��ȥ�� ���⸸ ����
			if(InvenItemInfo.Id.ClassID <= 0)
			{
				continue;
			}
			if(InvenItemInfo.itemType == EItemType.ITEM_WEAPON || InvenItemInfo.itemType == EItemType.ITEM_ARMOR || InvenItemInfo.itemType == EItemType.ITEM_ACCESSARY)
			{
			}
			else
			{
				continue;
			}

			// ��ȥ ������ ������ ��ȥ�Ǿ� �ִ� ���� ��󳻱�
			if(hasEnsoulOption(InvenItemInfo))
			{
				itemArray.Length = itemArray.Length + 1;
				itemArray[itemArray.Length - 1] = InvenItemInfo;
			}
		}
	}

	return itemArray;
}


// ��ȥ ���� ������ ���� �ޱ�
function array<ItemInfo> getInventoryEnSoulEnableItemArray()
{
	local int i, ItemNum, Index;
	local array<ItemInfo> itemArray;
	local ItemInfo InvenItemInfo;
	local int enSoulNormalCount, enSoulBmCount;

	ItemNum = m_invenItem.GetItemNum();

	for(Index = 0; Index < ItemNum; Index++)
	{
		m_invenItem.GetItem(Index, InvenItemInfo);

		// ��ȥ�� ���⸸ ����
		if(InvenItemInfo.Id.ClassID <= 0)
		{
			continue;
		}

		if(InvenItemInfo.itemType == EItemType.ITEM_WEAPON || InvenItemInfo.itemType == EItemType.ITEM_ARMOR || InvenItemInfo.itemType == EItemType.ITEM_ACCESSARY)
		{
		}
		else
		{
			continue;
		}

		if(InvenItemInfo.bSecurityLock)
		{
			continue;
		}

		// ��ȥ ������ �ִ� ������ ��� ����
		enSoulNormalCount = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(InvenItemInfo.Id, EIST_NORMAL); // �Ϲ� ��ȥ ���� ��
		enSoulBmCount = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(InvenItemInfo.Id, EIST_BM); // ���� ��ȥ ���� ��
		// ���߿� �ϳ��� 1�� �̻��̸� ��ȥ ������ �ִ� ������)
		if(enSoulNormalCount > 0 || enSoulBmCount > 0)
		{
			itemArray.Length = itemArray.Length + 1;
			itemArray[itemArray.Length - 1] = InvenItemInfo;
		}
	}

	// ��� ���� 
	for(i = 0; i < EQUIPITEM_Max; i++)
	{
		ItemNum = m_equipItem[i].GetItemNum();
		for(Index = 0; Index < ItemNum; Index++)
		{
			m_equipItem[i].GetItem(Index, InvenItemInfo);
			// ������ ��� ����, ��� �ҵ� �� ������ ���� ó��
			if(EQUIPITEM_LHand == i)
			{
				continue;
			}

			// ��ȥ�� ���⸸ ����
			if(InvenItemInfo.Id.ClassID <= 0)
			{
				continue;
			}

			if(InvenItemInfo.itemType == EItemType.ITEM_WEAPON || InvenItemInfo.itemType == EItemType.ITEM_ARMOR || InvenItemInfo.itemType == EItemType.ITEM_ACCESSARY)
			{
			}
			else
			{
				continue;
			}

			if(InvenItemInfo.bSecurityLock)
			{
				continue;
			}

			// ��ȥ ������ �ִ� ������ ��� ����
			enSoulNormalCount = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(InvenItemInfo.Id, EIST_NORMAL); // �Ϲ� ��ȥ ���� ��
			enSoulBmCount = class'UIDATA_ENSOUL'.static.GetEnsoulSlotCount(InvenItemInfo.Id, EIST_BM); // ���� ��ȥ ���� ��

			// ���߿� �ϳ��� 1�� �̻��̸� ��ȥ ������ �ִ� ������)
			if(enSoulNormalCount > 0 || enSoulBmCount > 0)
			{
				itemArray.Length = itemArray.Length + 1;
				itemArray[itemArray.Length - 1] = InvenItemInfo;
			}
		}
	}

	return itemArray;
}

// ��ȥ�� ������ ���� �ޱ�
function array<ItemInfo> getInventoryEnSoulStoneArray()
{
	local int i, itemNum, index;

	local array<ItemInfo> itemArray;

	local ItemInfo InvenItemInfo;
	// local string tmpInfoStr;
	
	// local int enSoulNormalCount, enSoulBmCount;

	itemNum = m_invenItem.GetItemNum();

	// �κ��丮���� ã��
	for(index = 0; index < itemNum; index++)
	{
		m_invenItem.GetItem(index, InvenItemInfo);

		if(InvenItemInfo.EtcItemType == int(EEtcItemType.ITEME_ENSOUL_STONE))
		{
			itemArray.Length = itemArray.Length + 1;
			itemArray[ itemArray.Length - 1 ] = InvenItemInfo;
		}
	}

	// ��� ���Կ��� ã��
	for(i = 0; i < EQUIPITEM_Max; i++)
	{
		itemNum = m_equipItem[i].GetItemNum();
		for(index = 0; index < itemNum; index++)
		{
			m_equipItem[i].GetItem(index, InvenItemInfo);
			
			// Ÿ���� ���ٸ�..
			if(InvenItemInfo.EtcItemType == int(EEtcItemType.ITEME_ENSOUL_STONE))
			{
				itemArray.Length = itemArray.Length + 1;
				itemArray[ itemArray.Length - 1 ] = InvenItemInfo;
			}
		}
	}

	return itemArray;
}

function SortAttifactItem () 
{
	local int i ;
	local int invenLimit;
	local ItemInfo item;	
	local int numArtifact;
	local Array<ItemInfo> ArtifactList, ArtifactListNormal, ArtifactListType1, ArtifactListType2, ArtifactListType3;

	invenLimit = m_artifactRuneItem.GetItemNum();

	// 1. �����۵��� list�� ����
	for (i = 0; i < invenLimit; i++ )
	{
		m_artifactRuneItem.GetItem(i, item);

		if(!IsValidItemID(item.ID)) continue;

		ArtifactList[numArtifact] = item;
		numArtifact++;
	}
	
	m_artifactRuneItem.Clear();

	// ��æƮ ��ġ�� ���߰� 
	ArtifactList = getInstanceL2Util().sortByEnchanted( ArtifactList ) ;
	
	// �̸����� ���߰� 
	ArtifactList = getInstanceL2Util().sortByName( ArtifactList ) ;
	
	for  ( i = 0 ;i < numArtifact ; i++ ) 
	{
		switch ( ArtifactList[i].slotBitType ) 
		{	
			case INT64("18014398509481984"):
				ArtifactListType1.Length = ArtifactListType1.Length + 1 ;
				ArtifactListType1[ArtifactListType1.Length - 1 ] = ArtifactList[i];				
			break;
			case INT64("144115188075855870"):
				ArtifactListType2.Length = ArtifactListType2.Length + 1 ;
				ArtifactListType2[ArtifactListType2.Length - 1 ] = ArtifactList[i];				
			break;
			case INT64("1152921504606847000"):
				ArtifactListType3.Length = ArtifactListType3.Length + 1 ;
				ArtifactListType3[ArtifactListType3.Length - 1 ] = ArtifactList[i];				
			break;
			case INT64("4398046511104") :
				ArtifactListNormal.Length = ArtifactListNormal.Length + 1 ;
				ArtifactListNormal[ArtifactListNormal.Length - 1 ] = ArtifactList[i];				
			break;
		}
	}

	// disable ���� ��ġ ���� ���� �ѹ� ������ ��.
	ItemboxUpdate(m_artifactRuneItem, GetArtifactItemInventoryLimit() );

	numArtifact = 0 ;
	for  ( i = 0 ; i < ArtifactListType1.Length ; i ++ ) 
		m_artifactRuneItem.SetItem( i, ArtifactListType1[i]);

	numArtifact += i ; 	
	for  ( i = 0 ; i < ArtifactListType2.Length ; i ++ ) 
		m_artifactRuneItem.SetItem( numArtifact + i , ArtifactListType2[i]);

	numArtifact += i ; 	
	for  ( i = 0 ; i < ArtifactListType3.Length ; i ++ ) 
		m_artifactRuneItem.SetItem( numArtifact + i, ArtifactListType3[i]);

	numArtifact += i ; 	
	for  ( i = 0 ; i < ArtifactListNormal.Length ; i ++ ) 
		m_artifactRuneItem.SetItem( numArtifact + i, ArtifactListNormal[i]);
}

//#ifdef CT26P3
/********************************************************************************************
 * ����
 * ******************************************************************************************/
function SortQuestItem()
{
	local int i, j;
	local int invenLimit;
	local ItemInfo item;	
	local itemInfo temp;
	local int numQuest;
	local Array<ItemInfo> QuestList;

	invenLimit = m_questItem.GetItemNum();

	// 1. �����۵��� 
	for(i = 0; i < invenLimit; i++)
	{
		m_questItem.GetItem(i, item);

		if(!IsValidItemID(item.ID))
		{
			continue;
		}

		QuestList[numQuest] = item;
		numQuest = numQuest + 1;
	}

	m_questItem.Clear();
	
	ItemboxUpdate(m_questItem, GetQuestItemInventoryLimit());

	for (i = 0 ;i < numQuest ; i++)
	{
		for(j = i ;j < numQuest ; ++j)
		{
			if(QuestList[i].ID.serverID  < QuestList[j].ID.serverID)
			{
				temp = QuestList[i];
				QuestList[i] = QuestList[j];
				QuestList[j] = temp;
			}
		}
	}
	
	for(i = 0; i < numQuest; ++i)
		m_questItem.SetItem(i, QuestList[i]);
}

function UpdateArtifactSlotActivation() 
{
	local userinfo currentUserInfo ;
	local int i ;
	
	GetPlayerInfo ( currentUserInfo ) ;

	for ( i = 0 ; i < currentUserInfo.nArtifactGroupNum ; i ++  ) 
		m_Artifact_Disable[i].HideWindow();

	for ( i = i ; i < 3 ; i ++ ) 
		m_Artifact_Disable[i].ShowWindow();
}



/********************************************************************************************
 * ���� â, ���� Ȱ�� ��Ȱ�� ó��
 * ******************************************************************************************/
// Ż������ ���� ó�� 
function UpdateTalismanSlotActivation()
{
	local int i, Count;
	local UserInfo User;

	if(GetPlayerInfo(User))
	{
		Count = Max(0, User.nTalismanNum);
		for (i = 0; i < Count; i++)
		{
			m_Talisman_Disable[i].HideWindow();
      		m_equipItem[EQUIPITEM_Deco1 + i].EnableWindow();
		}
		for (i = Count; i < 6; i++)
		{
			m_Talisman_Disable[i].ShowWindow();
			m_equipItem[EQUIPITEM_Deco1 + i].DisableWindow();
		}
	}

}

// �ư��ÿ� ���� ó�� 
function UpdateAgathionSlotActivation()
{
	local int Count;
	local int i;
	local UserInfo User;
	
	if(GetPlayerInfo(User))
	{
		// ���� ����� ���� �ϴٸ�,
		if(User.nAgathionMainNum > 0)
		{
			m_Agathion_Disable[0].HideWindow();
			m_equipItem[EQUIPITEM_AGATHION_MAIN].EnableWindow();
		}
		// ���� ���� �ʴٸ� 
		else
		{
			m_Agathion_Disable[0].ShowWindow();
			m_equipItem[EQUIPITEM_AGATHION_MAIN].DisableWindow();
		}
		Count = Max(0, User.nAgathionSubNum);

		for(i = 1; i < Count + 1; i++)
		{
			m_Agathion_Disable[i].HideWindow();
			m_equipItem[EQUIPITEM_AGATHION_MAIN + i].EnableWindow();
		}
		for(i = Count + 1; i < 5; i++)
		{
			m_Agathion_Disable[i].ShowWindow();
			m_equipItem[ EQUIPITEM_AGATHION_MAIN + i].DisableWindow();
		}
	}
}

// ���� ������ ���� ó�� 
function UpdateJewelSlotActivation()
{
	local int Count;
	local int i;
	local UserInfo User;

	if(GetPlayerInfo(User))
	{
		//����
		Count = Max(0, User.nJewelNum);

		for(i = 0; i<Count; i++)
		{
			m_Jewel_Disable[i].HideWindow();
			if (i > 5) {
				m_equipItem[EQUIPITEM_Jewel7 + i - 6].EnableWindow();
			} else {
				m_equipItem[EQUIPITEM_Jewel1 + i].EnableWindow();
			}
		}

		for(i = Count; i < 12 ; i++)
		{
			m_Jewel_Disable[i].ShowWindow();
			if (i > 5) {
				m_equipItem[EQUIPITEM_Jewel7 + i - 6].DisableWindow();
			} else {
				m_equipItem[EQUIPITEM_Jewel1 + i].DisableWindow();
			}
		}
	}
} 

/********************************************************************************************
 * ��� �� ������ ����
 * ******************************************************************************************/
// ���� ������ ���� ������ ���� //////////////////////////////////////////////////////////////
function HandleUpdateUserInfo()
{
	// Debug("HandleUpdateUserInfo"); 
	if(m_hOwnerWnd.IsShowWindow())
	{
		SetAhclemyOpener();
		InvenLimitUpdate();
		CheckShowCrystallizeButton();
	}
}

function handleChangedSubjob(string param)
{
	parseint(param, "SubjobClassID_0", mainClass);
	//Debug("handleChangedSubjob" @ mainClass);
	SetAhclemyOpener();
}

function handleNotifySubjob(string param)
{
	parseint(param, "SubjobClassID_0", mainClass);
	SetAhclemyOpener();
}

// ������ ����ȭ ��ư  
function CheckShowCrystallizeButton()
{
	if(class'UIDATA_PLAYER'.static.HasCrystallizeAbility())
	{
		m_hBtnCrystallize.ShowWindow();
	}
	else
	{
		m_hBtnCrystallize.HideWindow();
	}
}

// �̺�Ʈ�� �޾�, ��� �Ǽ��� ���� ���� ������ ó��
function ReceiveHairAccessoryPriority(string param)
{
	ParseInt(param, "priority", bShowhairAccessory);
	SetHandleHairAccessory();
}

function SetHandleHairAccessory()
{
	ViewHairButton.HideWindow();
	ViewAccessoryButton.HideWindow();

	if(bShowhairAccessory == 0)
		ViewHairButton.ShowWindow();		
	else if(bShowhairAccessory == 1)
		ViewAccessoryButton.ShowWindow();
}

// �Ƹ����̾� ���ݼ� Ȱ��ȭ.
function SetAhclemyOpener()
{
	local userinfo info;

	if(!GetPlayerInfo(info))return ;
	
	// �Ƹ����̾� �����̰�, �Ʒ��� ������ �ƴ� ���

	//Debug("SetAhclemyOpener" @ GetClassTransferDegree(info.nSubClass)@  mainClass == info.nSubClass);
	if(info.Race == 6)
	{
		AlchemyOpenerBtn.ShowWindow();
		if(GetClassTransferDegree(info.nSubClass)> 1 && mainClass == info.nSubClass)
		{
			toggleAlchemyOpenerTooltip(true);
			AlchemyOpenerBtn.EnableWindow();
			AlchemyOpenerBtn.ShowWindow();
			AlchemyOpenerBtn.SetTexture("L2ui_ct1.InventoryWnd.Alchemyopener", "L2ui_ct1.InventoryWnd.InventoryWnd.Alchemyopener", "L2ui_ct1.InventoryWnd.Alchemyopener_drag");				
		}
		else 
		{
			toggleAlchemyOpenerTooltip(false);
			AlchemyOpenerBtn.disableWindow();
			AlchemyOpenerBtn.HideWindow();
			AlchemyOpenerBtn.SetTexture("L2ui_ct1.InventoryWnd.Alchemyopener_disable", "L2ui_ct1.InventoryWnd.InventoryWnd.Alchemyopener_disable", "L2ui_ct1.InventoryWnd.Alchemyopener_disable");							
			AlchemyOpenerWindow.HideWindow();
		}
	}
	else 
	{
		AlchemyOpenerBtn.hideWindow();
	}
}
// ��ũ�ѹ� ����
function InitScrollBar()
{
	m_invenItem.SetScrollBarPosition(0, 17, 0);
	m_invenItem_1.SetScrollBarPosition(0, 17, 0);
	m_invenItem_2.SetScrollBarPosition(0, 17, 0);
	m_invenItem_3.SetScrollBarPosition(0, 17, 0);
	m_invenItem_4.SetScrollBarPosition(0, 17, 0);
	m_questItem.SetScrollBarPosition(0, 17, 0);
    m_artifactRuneItem.SetScrollBarPosition(0, 17, 0);
}

// ��ư ������ ���� ��ư ��ġ�� ���� �� 
function setBottomButtonPostion(out int num, ButtonHandle tmpBottomButton)
{
	local int startX, btnW;	

	//Debug("setBottomButtonPostion" @  tmpBottomButton);


	startX = 232; btnW = 39;
	tmpBottomButton.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", StartX + (Num * btnW), 453);
	++num ;
}


/**
 *  �κ��丮��Ȯ��, ����Ѵ�.
 **/
//function extendInventory(bool flag)
//{
//	local ItemWindowHandle tmpItemWindowHandle;	
//	local int toExpandWidth ;	

//	if(flag)
//	{
//		currentInvenCol = 12;
//		toExpandWidth = 108 ;
		
//		// �κ��丮�ؽ��ı�ü(6, 12 ����)		
//		m_InventoryItembg_expand.ShowWindow();
		
//		// Ȯ�� ��� ��ư �ؽ��� ��ü
//		m_BtnWindowExpand.SetTexture("L2UI_CT1.frames_df_Btn_Minimize",
//									 "L2UI_ct1.frames_df_btn_Minimize_down",
//									 "L2UI_ct1.frames_df_btn_Minimize_over");	
			
//	}
//	else
//	{
//		//�ӽ÷� �� ĭ�� �÷� ��
//		currentInvenCol = 9;
//		toExpandWidth = 0 ;
//		//�� col �� ũ��� 36 �̴�. col�� �ϳ� �þ �� ����. 36 �� ���� ��		
		
//		// �κ��丮�ؽ��ı�ü(6, 12 ����)		
//		m_InventoryItembg_expand.HideWindow();

//		// Ȯ�� ��� ��ư �ؽ��� ��ü
//		m_BtnWindowExpand.SetTexture("L2UI_ct1.frames_df_btn_Expand",
//									 "L2UI_ct1.frames_df_btn_Expand_down",
//									 "L2UI_ct1.frames_df_btn_Expand_over");
//	}	
	
//	//itemWindowWidth = ITEMWINDOW_MIN_WIDTH + toExpandWidth;	

//	m_hInventoryWnd.SetWindowSize(INVENTORYWND_MIN_WIDTH + toExpandWidth, 394);

//	m_invenItem.SetWindowSize(ITEMWINDOW_MIN_WIDTH + toExpandWidth, 288);

//	m_invenItem_1.SetWindowSize(ITEMWINDOW_MIN_WIDTH + toExpandWidth , 288);
//	m_invenItem_2.SetWindowSize(ITEMWINDOW_MIN_WIDTH + toExpandWidth , 288);
//	m_invenItem_3.SetWindowSize(ITEMWINDOW_MIN_WIDTH + toExpandWidth , 288);
//	m_invenItem_4.SetWindowSize(ITEMWINDOW_MIN_WIDTH + toExpandWidth , 288);
//	m_questItem.SetWindowSize(ITEMWINDOW_MIN_WIDTH + toExpandWidth , 288);	
//	m_tabbg.SetWindowSize(TAB_BG_MIN_WIDTH + toExpandWidth , 321);
//	m_tabbgLine.SetWindowSize(TAB_BG_LING_MIN_WIDTH + toExpandWidth , 23);
	
//	m_invenItem.SetCol(currentInvenCol);
//	m_invenItem_1.SetCol(currentInvenCol);
//	m_invenItem_2.SetCol(currentInvenCol);
//	m_invenItem_3.SetCol(currentInvenCol);
//	m_invenItem_4.SetCol(currentInvenCol);
//	m_questItem.SetCol(currentInvenCol);

//	// ��ũ�ѹ� ������, ��Ŀ�� ����

//	if(m_selectedItemTab == INVENTORY_ITEM_TAB)
//	{
//		tmpItemWindowHandle = m_invenItem;	
//	}
//	if(m_selectedItemTab == INVENTORY_ITEM_1_TAB)
//	{
//		tmpItemWindowHandle = m_invenItem_1;
//	}
//	if(m_selectedItemTab == INVENTORY_ITEM_2_TAB)
//	{
//		tmpItemWindowHandle = m_invenItem_2;		
//	}
//	if(m_selectedItemTab == INVENTORY_ITEM_3_TAB)
//	{
//		tmpItemWindowHandle = m_invenItem_3;
//	}
//	if(m_selectedItemTab == INVENTORY_ITEM_4_TAB)
//	{
//		tmpItemWindowHandle = m_invenItem_4;
//	}
//	else if(m_selectedItemTab == QUEST_ITEM_TAB)
//	{
//		tmpItemWindowHandle = m_questItem;
//	}

//	tmpItemWindowHandle.SetScrollPosition(0);
//	tmpItemWindowHandle.ResizeScrollBar();
//	tmpItemWindowHandle.SetFocus();
//}

// Ŭ���� ���̺�, �Ʒ��� ���� ����
function checkClassicForm()
{
    m_EquipWindow.HideWindow();
    SetEquipWindowHandle();
    SetHennaWindows();
    SetHandles();
    m_EquipWindow.ShowWindow();
    setBottomButtonPositions();
	SwitchEquipBox(EQUIPITEM_Brooch);
}

function InitTabIcon()
{
	m_invenTab.SetButtonOffsetTex(1, "L2UI_CT1.InventoryWnd.Inventory_Tab_Equip", 14, 8);
	m_invenTab.SetButtonOffsetTex(2, "L2UI_CT1.InventoryWnd.Inventory_Tab_Consume", 14, 7);
	m_invenTab.SetButtonOffsetTex(3, "L2UI_CT1.InventoryWnd.Inventory_Tab_Material", 14, 8);
	m_invenTab.SetButtonOffsetTex(4, "L2UI_CT1.InventoryWnd.Inventory_Tab_Etc", 15, 8);
	m_invenTab.SetButtonOffsetTex(5, "L2UI_CT1.InventoryWnd.Inventory_Tab_Quest", 13, 7);
    m_invenTab.SetButtonOffsetTex(6, "L2UI_CT1.InventoryWnd.Inventory_Tab_Artifact", 11, 8);
}

function SetIconOnSelectTabOrder()
{
	switch(preTabOrder)
	{
		case 1 : 
			m_invenTab.SetButtonOffsetTex(1 , "L2UI_CT1.InventoryWnd.Inventory_Tab_Equip" , 14, 8);
			break;
		case 2 : 
			m_invenTab.SetButtonOffsetTex(2 , "L2UI_CT1.InventoryWnd.Inventory_Tab_Consume" , 14, 7);
			break;
		case 3 :
			m_invenTab.SetButtonOffsetTex(3 , "L2UI_CT1.InventoryWnd.Inventory_Tab_Material" , 14, 8);
			break;
		case 4 :
			m_invenTab.SetButtonOffsetTex(4 , "L2UI_CT1.InventoryWnd.Inventory_Tab_Etc" , 15, 8);
			break;
		case 5 :
			m_invenTab.SetButtonOffsetTex(5 , "L2UI_CT1.InventoryWnd.Inventory_Tab_Quest", 13, 7);
			break;
		case 6 :
			m_invenTab.SetButtonOffsetTex(6, "L2UI_CT1.InventoryWnd.Inventory_Tab_Artifact", 11, 8);
			break;
	}

	preTabOrder = m_invenTab.GetTopIndex();

	switch(preTabOrder)
	{
		case 1 : 
			m_invenTab.SetButtonOffsetTex(1 , "L2UI_CT1.InventoryWnd.Inventory_Tab_Equip_Select" , 14, 8);
			break;
		case 2 : 
			m_invenTab.SetButtonOffsetTex(2 , "L2UI_CT1.InventoryWnd.Inventory_Tab_Consume_Select" , 14, 7);
			break;
		case 3 :
			m_invenTab.SetButtonOffsetTex(3 , "L2UI_CT1.InventoryWnd.Inventory_Tab_Material_Select" , 14, 8);
			break;
		case 4 :
			m_invenTab.SetButtonOffsetTex(4 , "L2UI_CT1.InventoryWnd.Inventory_Tab_Etc_Select" , 15, 8);
			break;
		case 5 :
			m_invenTab.SetButtonOffsetTex(5 , "L2UI_CT1.InventoryWnd.Inventory_Tab_Quest_Select" , 13, 7);
			break;
		case 6 :
			m_invenTab.SetButtonOffsetTex(6, "L2UI_CT1.InventoryWnd.Inventory_Tab_Artifact_Select", 11, 8);
			break;
	}

	ResetItemFiltering();
}

 // �ϴ� ��ư ���� ��ü �Լ�
 function setBottomButtonPositions()
{	
	local int i;

	setBottomButtonPostion(i, ItemAutoPeelBtn);
	setBottomButtonPostion(i, EnchantJewelButton);
	setBottomButtonPostion(i, EnchantArtifactRuneButton);
	// setBottomButtonPostion(i, AlchemyOpenerBtn);
	if(Class'UIDATA_PLAYER'.static.HasCrystallizeAbility())
	{
		setBottomButtonPostion(i, m_hBtnCrystallize);
		m_hBtnCrystallize.ShowWindow();
	}
	EnchantArtifactRuneButton.ShowWindow();
	EnchantJewelButton.ShowWindow();
	CollectionBtn.HideWindow();
	CollectionPointAni.HideWindow();
	AdenacalculateButton.HideWindow();
	ItemAutoPeelBtn.ShowWindow();
}


/********************************************************************************************
 * �κ� ���� ǥ�� 
 * ******************************************************************************************/
// �Ƶ���
function SetAdenaText()
{
	local string adenaString;

	adenaString = MakeCostString(string(GetAdena()));
	m_hAdenaTextBox.SetText(adenaString);
	m_hAdenaTextBox.SetTooltipString(ConvertNumToText(string(GetAdena())));
}
// ������ ����
function SetItemCount()
{
	local int limit;
	local int count;
	local Color countColor;
	
	if(m_selectedItemTab == QUEST_ITEM_TAB)
	{
		countColor.R = 176;
		countColor.G = 155;
		countColor.B = 121;
		countColor.A = 255;
		count = m_QuestInvenCount;
		limit = GetQuestItemInventoryLimit();
	}
	else if (m_selectedItemTab == ARTIFACT_ITEM_TAB)
	{
		countColor.R = 130;
		countColor.G = 200;
		countColor.B = 240;
		countColor.A = byte(255);
		Count = m_ArtifactInvenCount + (EquipArtifactItemGetitemNum());
		limit = GetArtifactItemInventoryLimit();            
	}
	else
	{
		countColor.R = 176;
		countColor.G = 155;
		countColor.B = 121;
		countColor.A = 255;
		count = m_NormalInvenCount + EquipNormalItemGetItemNum();
		limit = GetMyInventoryLimit();
	}

	m_itemCount.SetTextColor(countColor);
	m_itemCount.SetText("(" $ count $ "/" $ limit $ ")");

	// �ܺ� ������
	pInventoryItemCount = limit - count;
}

// �κ��丮 ��� �Ұ� ĭ ǥ�� 
function InvenLimitUpdate()
{
	// Changed by JoeyPark 2010/09/09

	ItemboxUpdate(m_invenItem, GetMyInventoryLimit());
	ItemboxUpdate(m_invenItem_1, GetMyInventoryLimit());
	ItemboxUpdate(m_invenItem_2, GetMyInventoryLimit());
	ItemboxUpdate(m_invenItem_3, GetMyInventoryLimit());
	ItemboxUpdate(m_invenItem_4, GetMyInventoryLimit());
	ItemboxUpdate(m_questItem, GetQuestItemInventoryLimit());
    ItemboxUpdate(m_artifactRuneItem, GetArtifactItemInventoryLimit());
	// End changing
}

// �ִ밪 �̻� ���� ǥ�� 1
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

// �ִ밪 ��ġ ����
function HandleSetMaxCount(string param)
{
	local int ExtraBeltCount;
	//local Userinfo info;
	
	//Debug("HandleSetMaxCount" @ param);
	ParseInt(param, "Inventory", m_MaxInvenCount);
	ParseInt(param, "questItem", m_MaxQuestItemInvenCount);
	ParseInt(param, "extrabelt", ExtraBeltCount);
    ParseInt(param, "artifactInventory", m_MaxArtifactInvenCount);
	m_invenItem.SetExpandItemNum(0, ExtraBeltCount);
	InvenLimitUpdate();
	SetItemCount();
}

function SetArtifactActiveSet ( int setNum, bool isActive ) 
{
	if ( isActive ) m_Artifact_Active[setNum].ShowWindow();
	else m_Artifact_Active[setNum].HideWindow();
	handleShowHideArtifactPanelTextureBySetNum ( setNum, isActive ) ;
}

// ��Ƽ��Ʈ ���� ������Ʈ ����
function SetArtifactActiveStone ( int currentStoneState )
{		
	m_Artifact_Stone.SetTexture ( "L2UI_CT1.InventoryWnd.Inventory_DF_ArtifactBook_Stone_" $ currentStoneState ) ;
	m_Artifact_Stone.SetTooltipCustomType( GetArtifactStoneTooltip( currentStoneState ) ) ;	
	//Debug ( "SetArtifactActiveStone" @ currentState ); 	

	//Debug ( "SetArtifactActiveStone"  @ currentStoneState ) ;
}

function SetArtifactEffectByStoneState ( int currentStoneState ) 
{	
	if ( _currentStoneState == currentStoneState ) return;

	//Debug ( "SetArtifactEffectByStoneState"  @ currentStoneState ) ;
	switch ( currentStoneState ) 
	{
		case -1 : SetArtifactBookEffect ( "", 0, 0 , 0); break;
		case 0 : SetArtifactBookEffect ( "LineageEffect_br.br_e_lamp_deco_d", 240, 0 , 0); break;
		case 1 : SetArtifactBookEffect ( "LineageEffect_br.br_e_lamp_deco_d", 192, 0 , 0); break;
		case 2 : SetArtifactBookEffect ( "LineageEffect_br.br_e_lamp_deco_d", 146, 0 , 0); break;
		case 3 : SetArtifactBookEffect ( "LineageEffect_br.br_e_lamp_deco_d", 100, 0 , 0); break;
		Default : SetArtifactBookEffect ( "", 0, 0 , 0); break;
	}	

	_currentStoneState = currentStoneState;
}

function handleShowHideArtifactPanelTextureBySetNum ( int setNum, bool isActive ) 
{
	switch ( setNum ) 
	{
		case 0 : 
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT1_MAIN1, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT1_MAIN2, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT1_MAIN3, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT1_SUB1, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT1_SUB2, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT1_SUB3, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT1_SUB4, isActive) ;
		break;			
		case 1 : 
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT2_MAIN1, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT2_MAIN2, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT2_MAIN3, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT2_SUB1, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT2_SUB2, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT2_SUB3, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT2_SUB4, isActive) ;
		break;
		case 2 : 
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT3_MAIN1, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT3_MAIN2, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT3_MAIN3, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT3_SUB1, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT3_SUB2, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT3_SUB3, isActive) ;
			handleShowHideArtifactPanelTexture(EQUIPITEM_ARTIFACT3_SUB4, isActive) ;
		break;
	}
}

private function HandleShowHideArtifactPanelTexture(int idx, bool isShow)
{
    // End:0x0E
    if(m_EquipWindowName == "")
    {
        return;
    }
    // End:0x80
    if(isShow)
    {
        GetTextureHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipItem_Artifact_Window.") $ m_equipItem[idx].GetWindowName()) $ "_Panel_Texture").ShowWindow();        
    }
    else
    {
        GetTextureHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipItem_Artifact_Window.") $ m_equipItem[idx].GetWindowName()) $ "_Panel_Texture").HideWindow();
    }
    return;
}

private function string GetArtifactStonePassive(int State)
{
    local SkillInfo SkillInfo;

    switch(State)
    {
        // End:0x28
        case 0:
            GetSkillInfo(35227, 1, 0, SkillInfo);
            return SkillInfo.SkillDesc;
        // End:0x49
        case 1:
            GetSkillInfo(35228, 1, 0, SkillInfo);
            return SkillInfo.SkillDesc;
        // End:0x6B
        case 2:
            GetSkillInfo(35229, 1, 0, SkillInfo);
            return SkillInfo.SkillDesc;
        // End:0xFFFF
        default:
            return "";
            break;
    }
}

private function SetArtifactBookEffect(string EffectName, optional int dist, optional int OffsetX, optional int OffsetY)
{
    m_ObjectViewport.SetCameraDistance(dist);
    m_ObjectViewport.SetCharacterOffsetX(OffsetX);
    m_ObjectViewport.SetCharacterOffsetY(OffsetY);
    m_ObjectViewport.ShowWindow();
    m_ObjectViewport.SetSpawnDuration(0.2);
    m_ObjectViewport.SetNPCInfo(19671);
    m_ObjectViewport.SetUISound(true);
    m_ObjectViewport.SpawnNPC();
    m_ObjectViewport.SpawnEffect(EffectName);
    return;
}


/********************************************************************************************
 * �� ������ show<>hide �ڵ�
 * ******************************************************************************************/
function HandleToggleWindow()
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.HideWindow();
		PlayConsoleSound(IFST_INVENWND_CLOSE);
	}
	else
	{
		if(bInitedCompleted)
		{
			if(RefineryWnd(GetScript("RefineryWnd")).isPossableInventoryShow() == false)
			{
				RefineryWnd(GetScript("RefineryWnd")).OnClickButton("exitbutton");
				RefineryWnd(GetScript("RefineryWnd")).setHideAndInventoryShow(true);
			}
			else
			{
				ShowWindowWithFocus("InventoryWnd");
				PlayConsoleSound(IFST_INVENWND_OPEN);
			}
		}
		else
		{
			bRequestItemList = true;
			RequestItemList();
		}
	}
}

function HandleOpenWindow(string param)
{
	local int Open;

	//��Ƽ??������Ʈ�� ��� ����;
	//Debug("HandleOpenWindow"  @ cur_state );
	if(cur_state == "BEAUTYSHOPSTATE")
	{
		return;
	}

	ParseInt(param, "Open", Open);

	if(Open == 0)
	{
		return;
	}
	
	OpenWindow();
}

function OpenWindow()
{
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
}

function HandleHideWindow()
{
	//branch 110804
	DialogHide();
	HideWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	//end of branch
}

function handleEnchantJewelButton()
{
	class'ItemJewelEnchantWnd'.static.Inst().ToggleShowWindow();
}

function toggleShowAlchemyWindow(string winName)
{
	if(class'UIAPI_WINDOW'.static.IsShowWindow(winName))
	{
		class'UIAPI_WINDOW'.static.HideWindow(winName);
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow(winName);
	}
}

function toggleAlchemyOpener()
{
	if(AlchemyOpenerWindow.IsShowWindow())
	{
		AlchemyOpenerWindow.HideWindow();
	}
	else
	{
		AlchemyOpenerWindow.ShowWindow();
	}
}

// �� ��Ʈ ���� �ݴ� �Լ�
function toogleCharacterViewPort(bool bShow)
{
	if(bShow)
	{	
		// "e" ���� 0 �� ��� â�� ����.
		SetINIInt(m_hOwnerWnd.m_WindowNameWithFullPath, "e",  0, "WindowsInfo.ini");
		m_InventoryWndCharacterView.ShowWindow();
		m_CharacterViewOpen_BTN.HideWindow();
		m_CharacterViewClose_BTN.ShowWindow();
	}
	else 
	{	
		SetINIInt(m_hOwnerWnd.m_WindowNameWithFullPath, "e",  1, "WindowsInfo.ini");
		m_InventoryWndCharacterView.HideWindow();
		m_CharacterViewOpen_BTN.ShowWindow();
		m_CharacterViewClose_BTN.HideWindow();
	}
}

// �� ��Ʈ�� ���� �� e ���� ���� ���� ������ ���� ������.
function ShowHideCharacterViewPortOnShow()
{
	local int e;
	GetINIInt(m_hOwnerWnd.m_WindowNameWithFullPath, "e",  e, "WindowsInfo.ini");
	toogleCharacterViewPort(e == 0);
}

/********************************************************************************************
 * Ȯ�� ���� ���� 
 * ******************************************************************************************/
// ���� �� 
// onShow �� �ٽ� �ε� �ϴ� �������� �ƴ� ���� ���� �ϴ� �����۵��� üũ �ϱ� ���� �Լ� 
function handleChkSwitchEquipBox  ( int idx , ItemInfo newInfo, optional bool bSwitchExpandEquipBox ) 
{
	switch ( idx ) 
	{
		case EQUIPITEM_RBracelet:
			EquipItem_RBracelet_Button.HideWindow();
		break;
		case EQUIPITEM_LBracelet:
			EquipItem_LBracelet_Button.HideWindow();
			break;
		case EQUIPITEM_Brooch:
			EquipItem_Brooch_Button.HideWindow();
			break;
		case EQUIPITEM_ARTIFACT :
			Equipitem_Artifact_Button.HideWindow();
			break;
		// �Ϲ� ������ ���� �� 
		case -1 : 
			// ���� ���°� ��Ƽ��Ʈ ���, 
			if ( m_SelectedExpandEquipIdx == EQUIPITEM_ARTIFACT )
				// ���� ���°� ��Ƽ��Ʈ�� �ƴ϶��, 
				if ( m_SelectedExpandEquipIdxPrev != EQUIPITEM_ARTIFACT )
					// ���� ���·� �ٲ��.
					idx = m_SelectedExpandEquipIdxPrev ;
					// handleChkSwitchEquipBox( m_SelectedExpandEquipIdxPrev, newInfo, bSwitchExpandEquipBox ) ; 
			break;
	}
	
	// ������ ����Ʈ�� request �� ��� �κ��� ���Ⱑ ��û �� �� �̹Ƿ�, switch ���� �ʴ´�. 
	// ������ ���� �ÿ��� �ٲ�� ó��
	// if ( bIsRequestItemList ) return;

	// 2600 �̺�Ʈ�� ��� ���� ��� switch ���� �ʴ´�. 
	if ( bSwitchExpandEquipBox ) switchEquipBox ( idx );
}

// ���� ��� �ڽ� ����ġ �ϱ� 
function SwitchEquipBox(int idx)
{
	// End:0x11
	if(idx == -1)
	{
		return;
	}
	
	JewelWindow.HideWindow();
	Jewel2Window.HideWindow();
	AgathionWindow.HideWindow();
	ArtifactWindow.HideWindow();

	equipItem_Henna_Window.HideWindow();
	SetHandleHairAccessory();
	switch(idx)
	{
		case EQUIPITEM_RBracelet:
			m_TalismanAllow.SetAnchor((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_equipItem[idx].GetWindowName(), "TopLeft", "TopLeft", -6, -12);
		break;
		case EQUIPITEM_LBracelet:
			AgathionWindow.ShowWindow();
            m_TalismanAllow.SetAnchor((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_equipItem[idx].GetWindowName(), "TopLeft", "TopLeft", -6, -12);
			break;
		case EQUIPITEM_Brooch:
			if ( m_bJewelTwo ) {
				Jewel2Window.ShowWindow();
			} else {
				JewelWindow.ShowWindow();
			}
			// JewelWindow.ShowWindow(); // ?
			m_TalismanAllow.SetAnchor((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_equipItem[idx].GetWindowName(), "TopLeft", "TopLeft", -6, -12);
			break;
		case EQUIPITEM_ARTIFACT : 
			UpdateArtifactSlotActivation();
			ArtifactWindow.ShowWindow();
			ViewAccessoryButton.HideWindow();
			ViewHairButton.HideWindow();		
			//InventoryWndCharacterView(getScript("InventoryWndCharacterView" ) ).ArtifactClicked();
			break;
		case HENNA_INDEX:
			equipItem_Henna_Window.ShowWindow();
			m_TalismanAllow.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath $ ".equipItem_Henna_Button", "TopLeft", "TopLeft", -4, -10);
			break;
	}
	// Debug("SwitchEquipBox" @  m_SelectedExpandEquipIdxPrev @ m_SelectedExpandEquipIdx);
	// ���� �� Ŭ�� �ϴ� ��� ���� ó��
	if(m_SelectedExpandEquipIdx != idx)
		m_SelectedExpandEquipIdxPrev = m_SelectedExpandEquipIdx;
	m_SelectedExpandEquipIdx = idx;
}

/*********************************************************************************************
 * new Item ǥ�� ����
 * *******************************************************************************************/
// new Item �� Ȯ���� list�� ����� ����.

// â�� ���� �ִٸ� �ٷ� new ó��
function handleNewItem(itemInfo addedItemInfo )
{
	local int index;

	if(addedItemInfo.ID.classID == 57)return;

	if(m_hOwnerWnd.IsShowWindow())
	{
		setNewItem(addedItemInfo);
		//return;
	}
	// ���� ������ �� ���� �񱳸� �ؼ� list �� �־�� ��. �پ�� ���� list ���� ����
	index = findNewItem(addedItemInfo.ID);

	// ����Ʈ�� ������ ����Ʈ�� �־��.
	if(index == -1)
	{
		// ������ �þ ��츦 üũ �ؾ� ��.
		index = newItems.Length;
		newItems.Length = newItems.Length + 1;
		newItems[ index ] = addedItemInfo;
//		Debug("handleNewItem ����Ʈ ����" @ index @  addedItemInfo.name);
	}

	// ���� ������, ������ �� �� �þ ���� ������ new ǥ�� 
	else if(newItems[index].ItemNum < addedItemInfo.ItemNum) 
	{
		newItems[index] = addedItemInfo;
//		Debug("handleNewItem ����Ʈ ���� " @ index @  addedItemInfo.name);
	}
}

function setNewItem( ItemInfo newItem )
{
	local int index;	

	local ItemWindowHandle tmpInven, detailItemWindow;

	if ( IsQuestItem ( newItem ) )
	{
		tmpInven = m_questItem;
		index = tmpInven.FindItem( newItem.ID ) ;
	}
	else if ( IsArtifactRuneItem ( newItem ) ) 
	{
		if ( !m_artifactRuneItem.IsShowWindow() ) 
			m_invenTab.SetButtonBlink( 6 , true);
		tmpInven = m_artifactRuneItem;
		index = m_artifactRuneItem.FindItem( newItem.ID ) ;
	}
	else 
	{
		tmpInven = m_invenItem; 

		detailItemWindow = getItemWindowHandleByItemType ( newItem );
		index = detailItemWindow.FindItem ( newItem.ID ) ;		

		if ( index != -1 ) detailItemWindow.SetNewlyAcquired( index, true ) ;
		index = tmpInven.FindItem( newItem.ID ) ;
	}

	//Debug ( "setNewItem" @ newItem.name @ index ) ;
	
	if ( index != -1 ) tmpInven.SetNewlyAcquired( index, true ) ;	
}

function handleNewItemOnShow()
{
	local int i;

	for(i = 0; i < newItems.Length; i ++)
	{
		setNewItem(newItems[i]);
	}
	//newItems.Length = 0;
}

function handleNewItemOnHide()
{
	local int i;

	for(i = 0; i < newItems.Length; i++)
	{
		delNewItem(newItems[i]);
	}
	newItems.Length = 0;
}

function delNewItem(ItemInfo delItem)
{
	local int index;
	local ItemWindowHandle tmpInven, detailItemWindow;

	if(IsQuestItem(delItem))
	{
		tmpInven = m_questItem;
		index = tmpInven.FindItem(delItem.ID);
	}
	else if (IsArtifactRuneItem(delItem))
	{
		tmpInven = m_artifactRuneItem;
		index = m_artifactRuneItem.FindItem(delItem.Id);            
	}
	else 
	{
		tmpInven = m_invenItem;

		detailItemWindow = getItemWindowHandleByItemType(delItem);
		index = detailItemWindow.FindItem(delItem.ID);

		if(index != -1)detailItemWindow.SetNewlyAcquired(index, false);
		index = tmpInven.FindItem(delItem.ID);
	}

	if(index != -1)tmpInven.SetNewlyAcquired(index, false);
}

function int findNewItem(itemID ID)
{
	local int i;
	for(i = 0; i < newItems.Length; i++)
		if(newItems[i].ID == ID)return i ;

	return -1;
}


/********************************************************************************************
 * Gfx ��ũ�� �޽����� ȹ�� �� ������ ������ ǥ��
 * ******************************************************************************************/
/* 
 * 1. �������� ���� �Ǵ� ���
 * 2. �������� �κ��丮���� ������ ��� ����
 */
function showItemUpdateEffect(string param) 
{
	local int index, i;
	local ItemInfo info, newItem, tmpItem;
	local ItemWindowHandle targetItemWnd;
	local string type, strParam;

	ParseString(param, "type", type);
	ParamToItemInfo(param, newItem);	

	//Debug("showItemUpdateEffect" @ param);
	// ������ ��� ����, ���� �ݺ� �� ����Ʈ�� ������ �ʵ��� ó��
	for(i = 0 ; i < EQUIPITEM_Max ; i ++)
	{
		m_equipItem[i].GetItem(0, tmpItem); 
		if(IsSameServerID(tmpItem.ID, newItem.ID))return;
	}	

	if(type =="delete")return;

	if(IsEquipItem(newItem))
		return;
	else if(IsQuestItem(newItem))
		targetItemWnd = m_questItem;
	else
		targetItemWnd = m_invenItem;

	index = targetItemWnd.FindItem(newItem.ID);
	targetItemWnd.GetItem(index, info);

	// Debug("showItemUpdateEffect" @ info.itemNum @  newItem.itemNum);
	if(info.itemNum < newItem.itemNum)
	{
		strParam = "iconName=" $ newItem.iconName;
		strParam = strParam @ "itemNum="$string(newItem.itemNum - info.itemNum);
		//ParamAdd(strParam, "iconName", newItem.iconName);
		//ParamAdd(strParam, "itemNum", string(newItem.itemNum - info.itemNum));
		getInstanceL2Util().showGfxScreenMessage(strParam , getInstanceL2Util().EGfxScreenMsgType.MSGType_AddItemEffect);
	}
}

function CheckCollectionEnableItem(ItemInfo iInfo)
{
	// local CollectionSystem collectionSystemScript;

	// collectionSystemScript = CollectionSystem(GetScript("collectionSystem"));
	// lasetSelectedItemInfo = iInfo;

	// if(collectionSystemScript.API_IsCollectionRegistEnableItem(lasetSelectedItemInfo.Id, -1, -1))
	// {
	// 	CollectionPointAni.Stop();
	// 	CollectionPointAni.Pause();
	// 	CollectionPointAni.SetLoopCount(9999999);
	// 	CollectionPointAni.ShowWindow();
	// 	CollectionPointAni.Play();
	// }
	// else
	// {
	// 	CollectionPointAni.Stop();
	// 	CollectionPointAni.Pause();
	// 	CollectionPointAni.HideWindow();
	// }
}

function OpenItemAutoPeelWnd(int itemServerID, bool isAllItem)
{
	m_hOwnerWnd.HideWindow();
	ItemAutoPeelWnd(GetScript("ItemAutoPeelWnd")).RegisterItem(itemServerID, isAllItem);
}

function CustomTooltip GetArtifactStoneTooltip(int currentStoneState)
{
    local CustomTooltip t;
    local L2Util util;
    local string lv, Title, passiveDesc, lvString;
    local int i;
    local Color c0, c1;
    local int nWidth, nHeight, nWidthMax;

    util = L2Util(GetScript("L2Util"));
    util.setCustomTooltip(t);
    lv = GetSystemString(2980);
    // End:0x6D
    if(currentStoneState > 0)
    {
        Title = (lv @ string(currentStoneState)) @ GetSystemString(3882);        
    }
    else
    {
        Title = GetSystemString(3883);
    }
    c0.R = 221;
    c0.G = 221;
    c0.B = 221;
    c0.A = byte(255);
    util.ToopTipInsertColorText(Title, true, false, c0);
    util.TooltipInsertItemBlank(2);
    util.TooltipInsertItemLine();
    c0.R = byte(255);
    c0.G = 180;
    c0.B = 0;
    c0.A = byte(255);
    c1.R = 200;
    c1.G = 200;
    c1.B = 200;
    c1.A = byte(255);


    for(i = 0; i < currentStoneState; i++)
    {
        lvString = (lv @ string(i + 1)) @ ": ";
        passiveDesc = GetArtifactStonePassive(i);
        util.TooltipInsertItemBlank(4);
        util.ToopTipInsertColorText(lvString, true, true, c0);
        util.ToopTipInsertColorText(passiveDesc, false, false, c1);
        GetTextSizeDefault(lvString $ passiveDesc, nWidth, nHeight);
        if(nWidthMax < nWidth)
        {
            nWidthMax = nWidth;
        }
    }
    c0.R = 100;
    c0.G = 70;
    c0.B = 0;
    c0.A = byte(255);
    c1.R = 68;
    c1.G = 68;
    c1.B = 68;
    c1.A = byte(255);

    for(i = i; i < 3; i++)
    {
        lvString = (lv @ string(i + 1)) @ ": ";
        passiveDesc = GetArtifactStonePassive(i);
        util.TooltipInsertItemBlank(4);
        util.ToopTipInsertColorText(lvString, true, true, c0);
        util.ToopTipInsertColorText(passiveDesc, false, false, c1);
        GetTextSizeDefault(lvString $ passiveDesc, nWidth, nHeight);
      
        if(nWidthMax < nWidth)
        {
            nWidthMax = nWidth;
        }
    }

    if(nWidthMax > 405)
    {
        nWidthMax = 405;
    }
    util.ToopTipMinWidth(nWidthMax);
    return util.getCustomToolTip();
}


function CustomTooltip getAgathionTooltip( string title, string desc)
{
	local CustomTooltip T;
	local L2Util util;
	util = L2Util(GetScript("L2Util"));//bluesun Ŀ���͸����� ����
	util.setCustomTooltip(T);//bluesun Ŀ���͸����� ����
	util.ToopTipInsertText(title , true, false, util.ETooltipTextType.COLOR_GRAY);
	util.ToopTipInsertText(desc , true, true, util.ETooltipTextType.COLOR_GRAY);
	return util.getCustomToolTip();
}

function setCustomTooltip()
{
	local L2Util util;
	local CustomTooltip T;
	//local string tmpTooltipString;

	//T.MinimumWidth = 125;
	util = L2Util(GetScript("L2Util"));//bluesun Ŀ���͸����� ����
	util.setCustomTooltip(T);//bluesun Ŀ���͸����� ����

	util.ToopTipMinWidth(150);
	util.ToopTipInsertText(GetSystemString(3265), true, false);
	util.TooltipInsertItemBlank(4);

	util.ToopTipInsertText(GetSystemString(3270), false, true,util.ETooltipTextType.COLOR_GRAY);
	AlchemyMixCubeWndBtn.SetTooltipCustomType(util.getCustomToolTip());
	
	util.setCustomTooltip(T);//bluesun Ŀ���͸����� ����
	util.ToopTipMinWidth(150);
	util.ToopTipInsertText(GetSystemString(3266), true, false);
	util.TooltipInsertItemBlank(4);
	util.ToopTipInsertText(GetSystemString(3271), false, true,util.ETooltipTextType.COLOR_GRAY);
	AlchemyItemConversionWndBtn.SetTooltipCustomType(util.getCustomToolTip());

	AlchemyItemCreateWndBtn.DisableWindow();
	util.setCustomTooltip(T);//bluesun Ŀ���͸����� ����
	util.ToopTipInsertText(GetSystemString(3312), true, false);
	util.TooltipInsertItemBlank(4);
	util.ToopTipInsertText(GetSystemString(3272), false, true,util.ETooltipTextType.COLOR_GRAY);
	AlchemyItemCreateWndBtn.SetTooltipCustomType(util.getCustomToolTip());
}

function toggleAlchemyOpenerTooltip(bool isOn)
{
	local L2Util util;
	local CustomTooltip T;

	util = L2Util(GetScript("L2Util"));//bluesun Ŀ���͸����� ����
	util.setCustomTooltip(T);//bluesun Ŀ���͸����� ����

	util.ToopTipInsertText(GetSystemString(3257), true, false);

	if(!isOn)
	{
		util.ToopTipMinWidth(150);
		util.TooltipInsertItemBlank(4);
		util.ToopTipInsertText(GetSystemMessage(4263), false, true,util.ETooltipTextType.COLOR_GRAY);
	}
	AlchemyOpenerBtn.SetTooltipCustomType(util.getCustomToolTip());
}


/********************************************************************************************
 * etc, util
 * ******************************************************************************************/
 
function bool IsSigil(ItemInfo a_Info)
{
	if(a_Info.ArmorType == 4)
	{
		return true;
	}
	return false;
}

// int 64 �̻��� ���� uc �� ��� int ������ �ν� �ȴ�. string ���� �޾Ƽ� ���÷� ����ȯ ����� ��.
function INT64 GetAgathionSlotBitType(String keyword)
{
	switch(keyword)
	{
		// �ư��ÿ� ����
		case "n":
			return 16;
		case "1":
			return 32;
		case "2":
			return 64;
		case "3":
			return 128;
		case "4":
			return 256;
	}
	return 0;
}

function bool IsSlotEmpty (int idx)
{
  return m_equipItem[idx].GetItemNum() == 0;
}

function string getArtifactSlotBitTypeString ( String keyword ) 
{
	switch ( keyword ) 
	{
		case "A01" : return  "4398046511104" ;
		case "A02" : return  "8796093022208" ;
		case "A03" : return  "17592186044416" ;
		case "A04" : return  "35184372088832" ;
		case "A05" : return  "70368744177664" ;
		case "A06" : return  "140737488355328" ;
		case "A07" : return  "281474976710656" ;
		case "A08" : return  "562949953421312" ;
		case "A09" : return  "1125899906842624" ;
		case "A10" : return  "2251799813685248" ;
		case "A11" : return  "4503599627370496" ;
		case "A12" : return  "9007199254740992" ;
		case "B01" : return  "18014398509481984" ;
		case "B02" : return  "36028797018963968" ;
		case "B03" : return  "72057594037927936" ;
		case "C01" : return  "144115188075855872" ;
		case "C02" : return  "288230376151711744" ;
		case "C03" : return  "576460752303423488" ;
		case "D01" : return  "1152921504606846976" ;
		case "D02" : return  "2305843009213693952" ;
		case "D03" : return  "4611686018427387904" ;
	}
	return "";
}

function String getAgathionSlotBitTypeString(String keyword)
{
	switch(keyword)
	{
		// �ư��ÿ� ����
		case "n":
			return "68719476736";
			break;
		case "1":
			return "137438953472";
			break;
		case "2":
			return "274877906944";
			break;
		case "3":
			return "549755813888";
			break;
		case "4":
			return "1099511627776";
			break;
	}
	return "";
}

//Ÿ�� �̸��� ���� ������ �ڵ� �ޱ�
function ItemWindowHandle getItemWindowHandleBystrTarget(string strTarget)
{
	switch(strTarget)
	{
		case "InventoryItem":
			return m_invenItem;
		case "InventoryItem_1":
			return m_invenItem_1;
		case "InventoryItem_2":
			return m_invenItem_2;
		case "InventoryItem_3":
			return m_invenItem_3;
		case "InventoryItem_4":
			return m_invenItem_4;
		case "ArtifactItem":
            return m_artifactRuneItem;
	}
}

//������ Ÿ�Կ� ���� ������ �ޱ�
function ItemWindowHandle getItemWindowHandleByItemType(ItemInfo item)
{
	if(!IsValidItemID(item.Id))
	{
		return m_invenItem_4;
	}

	switch(class'UIDATA_ITEM'.static.GetInventoryType(item.Id.ClassID))
	{
		case EIIT_EQUIPMENT:
			return m_invenItem_1;
		case EIIT_CONSUMABLE:
			return m_invenItem_2;
		case EIIT_MATERIAL:
			return m_invenItem_3;
		case EIIT_ETC:
		case EIIT_NONE:
			return m_invenItem_4;
		case EIIT_QUEST:
			return m_questItem;
	}
	return NONE;
}

function _ResetbRequestHennaOnShow()
{
	bRequestHennaOnShow = true;	
}
function string GetHennaPotenString(int potenID, int activeStep)
{
	local DyePotentialUIData dyePotentialData;
	local SkillInfo SkillInfo;

	class'UIDATA_HENNA'.static.GetDyePotentialData(potenID, dyePotentialData);
	GetSkillInfo(dyePotentialData.SkillID, activeStep, 0, SkillInfo);
	return (dyePotentialData.EffectName @ SkillInfo.SkillDesc) @ GetSystemString(3351);	
}

private function HandleChangeHennaDye(int hennaItemIndex)
{
	local int X, Y;

	GetClientCursorPos(X, Y);
	class'HennaEnchantWnd'.static.Inst()._ShowContextMenu(hennaItemIndex, X, Y);
	class'UIControlContextMenu'.static.GetInstance().Owner = string(self);
}


function _Handle_S_EX_NEW_HENNA_POTEN_SELECT(UIPacket._S_EX_NEW_HENNA_POTEN_SELECT packet)
{
	local int Index;
	local ItemInfo iInfo;

	if(packet.cSuccess > 0)
	{
		Index = packet.cSlotID - 1;
		hennaItems[Index].GetItem(0, iInfo);
		iInfo.Description = _GetEffectString(Index);
		hennaItems[Index].SetItem(0, iInfo);
	}
}

function _Handle_S_EX_NEW_HENNA_LIST(UIPacket._S_EX_NEW_HENNA_LIST henna_list_packet)
{
	local int i, HennaID, hennaLevel;
	local ItemInfo iInfo;

	for(i = 0; i < 4; i++)
	{
		hennaItems[i].Clear();
	}

	if(0 == henna_list_packet.hennaInfoList[3].cActive)
	{
		hennas_Disable4.ShowWindow();
	}
	else
	{
		hennas_Disable4.HideWindow();
	}

	for(i = 0; i < henna_list_packet.hennaInfoList.Length; i++)
	{
		HennaID = henna_list_packet.hennaInfoList[i].nHennaID;

		if(! class'UIDATA_HENNA'.static.GetItemCheck(HennaID))
		{

			continue;
		}
		class'UIDATA_HENNA'.static.GetHennaDyeItemLevel(HennaID, hennaLevel);
		iInfo.Name = class'UIDATA_HENNA'.static.GetItemNameS(HennaID) @ class'UIDATA_HENNA'.static.GetDescriptionS(HennaID);
		iInfo.AdditionalName = MakeFullSystemMsg(GetSystemMessage(5203), string(hennaLevel));
		iInfo.Description = _GetEffectString(i);
		iInfo.IconName = class'UIDATA_HENNA'.static.GetIconTexS(HennaID);
		hennaItems[i].AddItem(iInfo);
	}
}

function string _GetEffectString(int Index)
{
	local array<string> effectNames;
	local int selectedNum;

	class'HennaEnchantWnd'.static.Inst()._GetEffectStrings(Index, effectNames, selectedNum);

	if(selectedNum > -1)
	{
		return effectNames[selectedNum];
	}
	return "";	
}

private function HideWindowsAtSwap()
{
	GetWindowHandle("ItemJewelEnchantwnd").HideWindow();
	GetWindowHandle("ItemMultiEnchantwnd").HideWindow();
	GetWindowHandle("ItemEnchantWnd").HideWindow();
	class'UIAPI_WINDOW'.static.HideWindow("ItemUpgrade");
}


/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).HideWindow();
}

function bool UpdateSlot (out ItemInfo a_Info, int i)
{
  if ( m_equipItem[i].GetItemNum() <= 0 )
  {
    m_equipItem[i].Clear();
    m_equipItem[i].AddItem(a_Info);
    m_equipItem[i].EnableWindow();
    return True;
  }
  return False;
}

function UpdateJewelSlot(out ItemInfo a_Info)
{
	local int i;

	if ( (a_Info.ORDER >= 27) && (a_Info.ORDER <= 32) && UpdateSlot(a_Info, 26 + a_Info.ORDER - 27) )
	{
		return;
	}
	if ( (a_Info.ORDER >= 66) && (a_Info.ORDER <= 71) && UpdateSlot(a_Info, 59 + a_Info.ORDER - 66) )
	{
		return;
	}

	for (i = 0; i < 6; i++)
	{
		if (UpdateSlot(a_Info, EQUIPITEM_Jewel1 + i))
		{
			return;
		}
	}
	
	for (i = 0; i < 6; i++)
	{
		if (UpdateSlot(a_Info, EQUIPITEM_Jewel7 + i))
		{
			return;
		}
	}
}

function UpdateDecoSlot(ItemID Id, out ItemInfo a_Info)
{
	local int i;
	for (i = 0; i < 6; i++)
	{
		if (UpdateSlot(a_Info, EQUIPITEM_Deco1 + i))
		{
			return;
		}
	}
	
	// for (i = 0; i < 6; i++)
	// {
	// 	if(m_equipItem[EQUIPITEM_Deco7 + i].GetItemNum() <= 0)
	// 	{
	// 		m_equipItem[EQUIPITEM_Deco7 + i].Clear();
	// 		m_equipItem[EQUIPITEM_Deco7 + i].AddItem(a_Info);
	// 		m_equipItem[EQUIPITEM_Deco7 + i].EnableWindow();
	// 		return;
	// 	}
	// }
}

defaultproperties
{
}
