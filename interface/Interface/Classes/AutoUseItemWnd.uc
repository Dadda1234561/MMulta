/**
 * 
 *  - �ڵ� �÷��� �ý��� -
 *  
 *   # �Ҹ�ǰ �ڵ� ��� �ý���
 *   # �ڵ� Ÿ��, �ڵ� �ݱ�(���� �ʿ��� �ϵ��� ��� �����)
 *  
 *  �Ҹ�ǰ �ڵ� ���
 *  http://l2-redmine/redmine/issues/7368
 *  
 *  �ڵ� �÷���(�ڵ� Ÿ��)
 *  http://l2-redmine/redmine/issues/7691
 * 
 **/
class AutoUseItemWnd extends UICommonAPI;

// ������ �ڵ� ��� ������ ID�� 144��(12 x 12)���� 155 ���� ���� ��(12��)��ŭ �ο�.
// ���� ID �ο��� uc���� â�� ���� �� �� 1�� ����. UpdateShortcut �Լ��� ȣ��.
// �ڵ� ��ɿ� ��ũ�� ������ AutoplayMacroSlotID == 156

//-----------------------------------------------------
// ����
//-----------------------------------------------------
var WindowHandle Me;
var AutoUseItemWndMin AutoUseItemWndMinScript;

// �ּ�ȭ ����, �ɼ� �����
var int nMinimal;

//-----------------------------------------------------
// �Ҹ�ǰ �ڵ� ��� 
//-----------------------------------------------------
const MAX_ShortcutPerPage     = 12; // ������ �� ���� ���� ��
const AUTO_ITEM_SHORTCUT_PAGE = 12; // �Ҹ�ǰ �ڵ� ��� ���� Page

var AnimTextureHandle ToggleEffect_Anim;
var AutoUseItemInventory AutoUseItemInventoryScript;

// �� ������ Ȱ��ȭ ���� ����
var UIMapInt64Object ActiveSlotArrayMap;
var UIMapInt64Object ItemInfoSlotArrayMap;

var bool bEnabledRange;

var AutoTargetRangeSettingsWnd h_RangeScript;

// �ϳ��� Ȱ��ȭ ����
var bool bActivateAll;

//-----------------------------------------------------
//  �ڵ� Ÿ�� 
//-----------------------------------------------------

// ���� Ȱ��ȭ �ִ�
var AnimTextureHandle AutoTarget_ToggleMacro_Anim;

var ButtonHandle shotD_Target_BTN, Next_Target_BTN;
var ButtonHandle TargetPickupToggle_BTN;
var ButtonHandle ShowZoneRadius;
var ButtonHandle FixedZoneBtn;

var ButtonHandle AutoTargetRadius_BTN;

// Ÿ�� 
var WindowHandle TargetStatusWndScript;
var WindowHandle AutoTargetAllON_Win;
var WindowHandle AutoTargetRadiusSettings_Win;
var ButtonHandle MacroSelectBtn_01;
var ButtonHandle MacroSelectBtn_02;
var AnimTextureHandle AutoTargetAllON_ToggleEffect_Anim;

// ��Ÿ��, ��Ÿ�� �������� üũ �Ҷ� 
var bool autotarget_bShortTarget;

// ����Ÿ�� Ȱ��ȭ, ��Ȱ��ȭ 
var bool autotarget_bUseAutoTarget;

// �ڵ� �ݱ� 
var bool autotarget_bIsTargetRaid;

// fixed zone
var bool autotarget_bIsFixedZone;
 
 // show zone radius
var bool autotarget_bIsShowRadius;


// Ÿ�� ���(�ɼǿ��� ����)
var EAutoNextTargetMode autotarget_nTargetMode;

var YetiQuickSlotWnd YetiQuickSlotwndScript;
var ButtonHandle TargetMannerToggle_BTN;
var int autotarget_nHPPotionPercent;
var bool autotarget_bIsMannerModeOn;
var int nMacroSlotSelect;

var LocalStorageEX localStorage;
var PlayerController P;

static function AutoUseItemWnd Inst()
{
	return AutoUseItemWnd(GetScript("AutoUseItemWnd"));
}

//-----------------------------------------------------
function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_GamingStateEnter);
	// �Ҹ�ǰ �ڵ� ���
	RegisterEvent(EV_ShortcutAutomaticUseActivated);
	RegisterEvent(EV_ShortcutUpdate);
	RegisterEvent(EV_ShortcutClear);

	// ���� �÷���(�ڵ� Ÿ�ٵ�)
	RegisterEvent(	EV_AutoplaySetting);

	RegisterEvent(	EV_NextTargetModeChange);
	RegisterEvent(	EV_OptionHasApplied);

	RegisterEvent(EV_CounterAttack);

	//requestAutoPlay

}

function OnLoad()
{
	Initialize();
}

function Initialize()
{	
	Me = GetWindowHandle("AutoUseItemWnd");
	h_RangeScript = AutoTargetRangeSettingsWnd(GetScript("AutoTargetRangeSettingsWnd"));

	// �Ҹ�ǰ �ڵ� ���
	ToggleEffect_Anim = GetAnimTextureHandle("AutoUseItemWnd.AutoAllON_Win.ToggleEffect_Anim");
	AutoUseItemInventoryScript = AutoUseItemInventory(GetScript("AutoUseItemInventory"));
	AutoUseItemWndMinScript = AutoUseItemWndMin(GetScript("AutoUseItemWndMin"));
	YetiQuickSlotwndScript = YetiQuickSlotWnd(GetScript("YetiQuickSlotwnd"));
	AutoTarget_ToggleMacro_Anim = GetAnimTextureHandle("AutoUseItemWnd.AutoTargetWnd.ToggleMacro_Anim");
	// �ڵ� Ÿ��
	shotD_Target_BTN = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.shotD_Target_BTN");
	Next_Target_BTN = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.Next_Target_BTN");
	MacroSelectBtn_01 = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.MacroSelectBtn_01");
	MacroSelectBtn_02 = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.MacroSelectBtn_02");
	TargetPickupToggle_BTN = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.TargetPickupToggle_BTN");
	FixedZoneBtn = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.FixedZoneBtn");
	ShowZoneRadius = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.ShowZoneRadius");
	TargetMannerToggle_BTN = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.TargetMannerToggle_BTN");
	TargetStatusWndScript = GetWindowHandle("TargetStatusWnd");
	AutoTargetAllON_Win = GetWindowHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllON_Win");
	AutoTargetRadius_BTN = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetRadius_BTN");
	AutoTargetRadiusSettings_Win = GetWindowHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetRadiusSettings_Win");
	AutoTargetAllON_ToggleEffect_Anim = GetAnimTextureHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllON_Win.ToggleEffect_Anim");
	ActiveSlotArrayMap = new class'UIMapInt64Object';
	ItemInfoSlotArrayMap = new class'UIMapInt64Object';	
	localStorage = class'LocalStorageEX'.static.Inst();
	// Local Level Info
	if (localStorage.RenewCurentPlayerController(P)) {
		DBG_SendMessageToChat("Success get!");
	}
}

function OnShow()
{
	// �Ҹ�ǰ �ڵ� ���
	if( getInstanceUIData().getIsClassicServer() )
	{
		Me.HideWindow();
		return;
	}
	
	setPlayActiveAnim();

	// �ڵ� Ÿ��
	AutotargetOnShow();
}

function initAll()
{
	// �Ҹ�ǰ �ڵ� ���
	initSlotArray();
	HandleShortcutPageUpdateAll();
	bActivateAll = False;
	YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
	checkMinimal();	
}

function checkMinimal()
{
	Me.ShowWindow();
	// �ּ�ȭ ���� �ε�
	GetINIBool("AutoUseItemWnd", "l", nMinimal, "windowsInfo.ini");
	// End:0x5E
	if( nMinimal > 0 )
	{
		OnClickButton("WinMin_Button");
	}	
}

function showHideForYeti(bool bShow)
{
	if( bShow )
	{
		if( nMinimal > 0 )
		{
			OnClickButton("WinMin_Button");
		}
		else
		{
			Me.ShowWindow();
		}
	}
	else
	{
		Me.HideWindow();
		GetWindowHandle("AutoUseItemWndMin").HideWindow();
	}
}

/**
 * OnEvent 
 **/
function OnEvent(int Event_ID, string param)
{	
	// local int nSystemMsgIndex;
	if( getInstanceUIData().getIsClassicServer() )
	{
		return;
	}
	switch(Event_ID)
	{
		case EV_GameStart:
			initAll();
			break;
		case EV_GamingStateEnter:
			checkMinimal();
			// End:0x103
			break;
		case EV_Restart:
			 // �ڵ� ������ ��� 
			initSlotArray();
			bActivateAll = False;
			nMinimal = 0;

			 // �ڵ� Ÿ��
			Autotarget_Init();
			break;
		case EV_ShortcutAutomaticUseActivated:
			 //Debug("EV_ShortcutAutomaticUseActivated:" @ param);
			ShortcutAutomaticUseActivatedHandler(param);

			YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
			break;

		case EV_ShortcutUpdate:
			 //Debug("EV_ShortcutUpdate:" @ param);
			  // �ڵ� ������ ���
			HandleShortcutUpdate(param);

			 // �ڵ� Ÿ��
			 //Autotarget_HandleShortcutUpdate(param);
			break;

		case EV_ShortcutClear:
			 //Debug("EV_ShortcutClear:" @ param);
			 // �ڵ� ������ ���
			initAll();

			 // �ڵ� Ÿ��
			Autotarget_Init();  Autotarget_UpdateShortCutElement();
			break; 

		//------------- �ڵ� Ÿ�� ----------------------------------
		case EV_AutoplaySetting :
			Debug("EV_AutoplaySetting"@param);	 
			AutoplaySettingHandler(param);
			break;
	   //  CTRL + T, �ɼǿ��� ���� ��������(Ÿ�� ��� ����)
		case  EV_NextTargetModeChange :  
		case  EV_OptionHasApplied :      NextTargetModeHandler(); break; 
	   // �ݰ� ��ư�̳� �׼��� ����Ǹ�, �ڵ���� ����.
		case  EV_CounterAttack: 
			if( autotarget_bUseAutoTarget )requestAutoPlay(False); 
			break;
	}
}

//  CTRL + T, �ɼǿ��� ���� ��������(Ÿ�� ��� ����)
function NextTargetModeHandler()
{
	local EAutoNextTargetMode nTargetMode;

	nTargetMode = GetNextTargetModeOption();

	// ���� ������ �ٽ� ������ �ʿ䰡 ����.
	if( autotarget_nTargetMode != nTargetMode )
	{
		if( autotarget_bUseAutoTarget )requestAutoPlay(autotarget_bUseAutoTarget);
	}
	Autotarget_NextTargetSetCusomTooltip();
}

// �ڵ� Ÿ�� �̺�Ʈ ó��
function AutoplaySettingHandler(string param)
{
	local int nIsAutoPlayOn, nNextTargetMode , nIsNearTargetMode, nIsPickupOn, nMacroIndex;
	local int nHPPotionPercent;
	local int nIsMannerModeOn;

	ParseInt(param, "IsPickupOn", nIsPickupOn);
	ParseInt(param, "IsAutoPlayOn", nIsAutoPlayOn);
	ParseInt(param, "NextTargetMode", nNextTargetMode);
	ParseInt(param, "IsNearTargetMode", nIsNearTargetMode);
	ParseInt(param, "HPPotionPercent",nHPPotionPercent);
	ParseInt(param, "IsMannerModeOn",nIsMannerModeOn);
	ParseInt(param, "MacroIndex", nMacroIndex);

	// �������� on, off �� ���� �޾Ƽ� ���¸� ��ü ui���� ���� ������ �ʴ´�. 
	autotarget_bUseAutoTarget = numToBool(nIsAutoPlayOn);
	autotarget_bShortTarget = numToBool(nIsNearTargetMode);

	autotarget_bIsTargetRaid = numToBool(nIsPickupOn);
	autotarget_bIsMannerModeOn = numToBool(nIsMannerModeOn);
	autotarget_nHPPotionPercent = nHPPotionPercent;

	// ���� ���� ���¿� ��� ó��
	nMacroSlotSelect = nMacroIndex;
	Autotarget_UpdateAutoTargetState();	
}

function HandleShortcutClear(string param)
{
	local int nShortcutID;
	
	ParseInt(param, "ShortcutID", nShortcutID);

	if( nShortcutID >= (AUTO_ITEM_SHORTCUT_PAGE * MAX_ShortcutPerPage) && nShortcutID <= ((AUTO_ITEM_SHORTCUT_PAGE * MAX_ShortcutPerPage) + MAX_ShortcutPerPage) )
		class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("AutoUseItemWnd.ItemGroup_Wnd"$".AutoUseItem"$(nShortcutID - (AUTO_ITEM_SHORTCUT_PAGE * MAX_ShortcutPerPage) + 1)$"_ShortcutItem");
	else
	{
		// End:0x11C
		if( nShortcutID >= 168 && nShortcutID <= 173 )
		{
			class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear("AutoUseItemWnd.ItemGroup_Wnd"$".AutoUseItem"$string(nShortcutID - 155)$"_ShortcutItem");
		}
	}
}

function HandleShortcutUpdate(string param)
{
	local int nShortcutID, nClassID;
	
	ParseInt(param, "ShortcutID", nShortcutID);
	ParseInt(param, "ClassID", nClassID);

	// 144 ~ 155 �� ���� 
	if( nShortcutID >= (AUTO_ITEM_SHORTCUT_PAGE * MAX_ShortcutPerPage) && nShortcutID <= ((AUTO_ITEM_SHORTCUT_PAGE * MAX_ShortcutPerPage) + MAX_ShortcutPerPage) - 1 || nShortcutID >= 168 && nShortcutID <= 173 )
	{
		// End:0xA5
		if( nClassID <= -1 )
		{
			ItemInfoSlotArrayMap.Add(nShortcutID, 0);			
		}
		else
		{
			ItemInfoSlotArrayMap.Add(nShortcutID, nClassID);
		}
		// End:0x13F
		if( (nShortcutID >= 168) && nShortcutID <= 173 )
		{
			class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoUseItemWnd.ItemGroup_Wnd"$".AutoUseItem"$string(nShortcutID - 155)$"_ShortcutItem", nShortcutID);			
		}
		else
		{
			class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoUseItemWnd.ItemGroup_Wnd"$".AutoUseItem"$(nShortcutID - (AUTO_ITEM_SHORTCUT_PAGE * MAX_ShortcutPerPage) + 1)$"_ShortcutItem", nShortcutID);
		}

		// �߰��� �� ����ؼ� 0�� �Ǹ� ClassID�� 0���� ��� ���� ������ �ڵ� ���� �ȴ�. �̶� ��Ȱ��ȭ �������� �迭 ���� ��ü 
		if( nClassID <= 0 )
		{
			ActiveSlotArrayMap.Add(nShortcutID, 0);
		}

		setCheckActivateAll();
		setPlayActiveAnim();
		YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
	}
	else if(nShortcutID == 156)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoUseItemWnd.AutoTargetWnd.Macro1ShortcutItem", 156);
	}
	else if(nShortcutID == 159)
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoUseItemWnd.AutoTargetWnd.Macro2ShortcutItem", 159);
	}

	if( autotarget_bUseAutoTarget && nShortcutID == 156 || nShortcutID == 159 )
	{
		requestAutoPlay(False);
	}
}	

// �� ������ ���¸� ��Ƽ�� ���¸� �ʱ�ȭ
function initSlotArray()
{
	local int i;

	ActiveSlotArrayMap.RemoveAll();
	ItemInfoSlotArrayMap.RemoveAll();

	for( i = 0; i < 12; i++ )
	{
		ItemInfoSlotArrayMap.Add(144 + i, 0);
	}

	// End:0x92 [Loop If]
	for( i = 0; i < 6; i++ )
	{
		ItemInfoSlotArrayMap.Add(168 + i, 0);
	}	
}

// ������ Ȱ��ȭ ���¸� �������� �޾Ƽ� ��Ȳ�� ���� ó�� 
function ShortcutAutomaticUseActivatedHandler(string param)
{
	local int nShortcutID, nAutomaticUseActivated;

    //"ShortcutID" : int(���� ���� ID)
    //"AutomaticUseActivated" : int(�ڵ� ��� 0:��Ȱ��ȭ / 1:Ȱ��ȭ)
	
	ParseInt(param, "ShortcutID", nShortcutID);
	ParseInt(param, "AutomaticUseActivated", nAutomaticUseActivated);

	// 144 ~ ���� 155 ������ ���
	if( nShortcutID >= (AUTO_ITEM_SHORTCUT_PAGE * MAX_ShortcutPerPage) && nShortcutID <= ((AUTO_ITEM_SHORTCUT_PAGE * MAX_ShortcutPerPage) + MAX_ShortcutPerPage) || nShortcutID >= 168 && nShortcutID <= 173 )
	{ 
		// �迭 ���Կ� Ȱ��ȭ ���θ� �ִ´�. 
		ActiveSlotArrayMap.Add(nShortcutID, nAutomaticUseActivated);

		// ���� ��Ƽ�� üũ
		setCheckActivateAll();		

		// ��Ƽ�� ��� 
		setPlayActiveAnim();
		AutoUseItemWndMinScript.setPlayActiveAnim();

		YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
		//Debug("nShortcutID:" @ nShortcutID);
		//Debug("index" @ nShortcutID -(AUTO_ITEM_SHORTCUT_PAGE * MAX_ShortcutPerPage));
		//Debug("nAutomaticUseActivated" @ nAutomaticUseActivated);
	}
}

function int getEmptySlotNum()
{
	return int(ItemInfoSlotArrayMap.FindKeyByData(0));
}

// ���� ���Կ� Ȱ��ȭ �Ȱ� �ϳ��� �ִٸ� ActiveAll = true;
function setCheckActivateAll()
{
	local int i;
	local array<INT64> arr;

	arr = ActiveSlotArrayMap.ContainAll();

	for( i = 0; i < arr.Length; i++ )
	{
		//debug("ActiveSlotArray[i]" @ ActiveSlotArray[i]);
		if( arr[i] > 0 )
		{
			bActivateAll = True;
			return;
		}
	}

	bActivateAll = False;	
}

// ��ü Ȱ��ȭ ��ư���� Ȱ��ȭ �ִϸ� ����ϰ� ����
function setPlayActiveAnim()
{
	if( !Me.IsShowWindow() )return;

	if( bActivateAll )
	{
		ToggleEffect_Anim.ShowWindow();
		ToggleEffect_Anim.SetLoopCount(99999);
		ToggleEffect_Anim.Stop();
		ToggleEffect_Anim.Play();

		GetWindowHandle("AutoUseItemWnd.AutoAllON_Win").ShowWindow();
		GetWindowHandle("AutoUseItemWnd.AutoAllOFF_Win").HideWindow();
	}
	else
	{
		ToggleEffect_Anim.HideWindow();
		ToggleEffect_Anim.Stop();

		GetWindowHandle("AutoUseItemWnd.AutoAllON_Win").HideWindow();
		GetWindowHandle("AutoUseItemWnd.AutoAllOFF_Win").ShowWindow();
	}
}

function bool getActivateAll()
{
	return bActivateAll;
}

// ���� ��ȣ ��� 
function HandleShortcutPageUpdateAll()
{
	local int i;
	local int nShortcutID;
	
	nShortcutID = (AUTO_ITEM_SHORTCUT_PAGE * MAX_ShortcutPerPage);
	for( i = 1; i <= MAX_ShortcutPerPage;++i )
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoUseItemWnd.ItemGroup_Wnd"$".AutoUseItem"$(i)$"_ShortcutItem", nShortcutID);
		nShortcutID++;
		// Debug("���� ��Ʈ�� ������Ʈ " @ GetWindowHandle("AutoUseItemWnd.ItemGroup_Wnd" $ ".AutoUseItem" $(i )$ "_ShortcutItem").GetWindowName()@ ": " @ nShortcutID);
	}

	nShortcutID = 155;

	// End:0x115 [Loop If]
	for( i = 13; i <= 18; i++ )
	{
		class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoUseItemWnd.ItemGroup_Wnd"$".AutoUseItem"$string(i)$"_ShortcutItem", nShortcutID + i);
	}
}

function OnClickButton(string name)
{
	// Debug("onClickButton:" @name);
	switch(name)
	{
		// ���� �κ��丮
		case "Inventory_Button":
			onInventory_ButtonClick();
			break;
		// �ڵ� ���
		case "AutoAll_BTN":			
			Debug("--- Api call : RequestAutomaticUseItemActivateAll, "@!bActivateAll);
			class'ShortcutWndAPI'.static.RequestAutomaticUseItemActivateAll(!bActivateAll);
			break;
			
		// �ּ�ȭ ��ư
		case "WinMin_Button":
			nMinimal = 1;
			SetInIBool("AutoUseItemWnd", "l", numToBool(nMinimal), "windowsInfo.ini");
			Me.HideWindow();
			h_RangeScript.SaveWindowState(False);
			ShowWindowWithFocus("AutoUseItemWndMin");
			getInstanceL2Util().syncWindowLoc("AutoUseItemWnd", "AutoUseItemWndMin", 115, 98);
			getInstanceL2Util().fixWindowLocOverResolution("AutoUseItemWndMin");
			break;
		//----------------  �ڵ� Ÿ�� ---------------------
		// ��ũ�� â ���� 
		case "MacroWnd_Button":
			ExecuteEvent(EV_MacroShowListWnd);
			break;
		// Ÿ�� ���� 
		case "ShotD_Target_BTN":
			Autotarget_OnSwap_Target_BTNClick();
			// End:0x174
			if( autotarget_bUseAutoTarget )
			{
				requestAutoPlay(autotarget_bUseAutoTarget);
			}
			break;
		// Ÿ�� ��ü
		case "TargetSwap_BTN":
			Autotarget_OnSwap_Target_BTNClick();
			// End:0x1AD
			if( autotarget_bUseAutoTarget )
			{
				requestAutoPlay(autotarget_bUseAutoTarget);
			}
			break;
		// �ݱ�, on off
		case "TargetPickupToggle_BTN":
			Autotarget_TargetPickupToggle_BTNClick();
			if( autotarget_bUseAutoTarget )
			{
				requestAutoPlay(autotarget_bUseAutoTarget);
			}
			break;
		case "FixedZoneBtn":
			Autotarget_FixedZoneBtn_BTNClick();
			break;
		case "ShowZoneRadius":
			Autotarget_ShowZoneRadius_BTNClick();
			break;
		case "TargetMannerToggle_BTN":
			Autotarget_TargetMannerToggle_BTNClick();
			requestAutoPlay(autotarget_bUseAutoTarget);
			break;
		// ��ü �ڵ�Ÿ�� �¿��� ��ư
		case "AutoTargetAll_BTN":
			requestAutoPlay(!autotarget_bUseAutoTarget);
			break;
		case "Next_Target_BTN":
			Autotarget_OnNext_Target_BTNClick();
			// End:0x2BE
			break;
		// End:0x243
		case "MacroSelectBtn_01":
		// End:0x2BB
		case "MacroSelectBtn_02":
			MacroSelectBtn_Click(Name);
			SetMacroSlotSelect();
			// End:0x2B8
			if( Name == "MacroSelectBtn_01" || Name == "MacroSelectBtn_02" )
			{
				Debug("-_-");
				requestAutoPlay(False);
			}
			// End:0x2BE
			break;
		case "AutoTargetRadius_BTN":
			h_RangeScript.ToggleWindowState();
			break;
	}
}

function MacroSelectBtn_Click(string Name)
{
	// End:0xB6
	if( Name == "MacroSelectBtn_01" )
	{
		GetMeWindow("AutoTargetWnd.Macro1ShortcutItem").ShowWindow();
		GetMeWindow("AutoTargetWnd.Macro2ShortcutItem").HideWindow();
		SetINIInt("AutoUseItemWnd", "nMacroSelect", 0, "AutoPlaySettings.ini");
		nMacroSlotSelect = 0;		
	}
	else
	{
		GetMeWindow("AutoTargetWnd.Macro1ShortcutItem").HideWindow();
		GetMeWindow("AutoTargetWnd.Macro2ShortcutItem").ShowWindow();
		SetINIInt("AutoUseItemWnd", "nMacroSelect", 1, "AutoPlaySettings.ini");
		nMacroSlotSelect = 1;
	}

	SaveINI("AutoPlaySettings.ini");
}

function Autotarget_OnNext_Target_BTNClick()
{
	local string strParam;
	local int targetMode;

	strParam = "";
	switch(GetOptionInt("CommunIcation", "NextTargetMode"))
	{
		// End:0x3D
		case 0:
			targetMode = 1;
			// End:0x6E
			break;
		// End:0x4C
		case 1:
			targetMode = 2;
			// End:0x6E
			break;
		// End:0x5C
		case 2:
			targetMode = 3;
			// End:0x6E
			break;
		// End:0x6B
		case 3:
			targetMode = 0;
			// End:0x6E
			break;
	}
	SetOptionInt("Communication", "NextTargetMode", targetMode);
	ParamAdd(strParam, "NextTargetMode", string(targetMode));
	ExecuteEvent(11030, strParam);
	Autotarget_NextTargetSetCusomTooltip();	
}

function Autotarget_NextTargetSetCusomTooltip()
{
	local int N;
	local Color b0, b1, b2, b3;
	local array<DrawItemInfo> drawListArr;
	local string toolString;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;
	b2 = getInstanceL2Util().Gray;
	b3 = getInstanceL2Util().Gray;
	Next_Target_BTN.ClearTooltip();
	Next_Target_BTN.SetTooltipType("text");
	N = GetOptionInt("Communication", "NextTargetMode");
	// End:0xC6
	if( N == 0 )
	{
		b0 = getInstanceL2Util().Yellow;		
	}
	else if(N == 1)
	{
		b1 = getInstanceL2Util().Yellow;			
	}
	else if(N == 2)
	{
		b2 = getInstanceL2Util().Yellow;				
	}
	else if(N == 3)
	{
		b3 = getInstanceL2Util().Yellow;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3862), b0, "", True, True);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3863), b1, "", True, True);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3864), b2, "", True, True);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3865), b3, "", True, True);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	toolString = MenuEntireWnd(GetScript("MenuEntireWnd")).setMainShortcutString(MenuEntireWnd(GetScript("MenuEntireWnd")).getAssignedKeyGroup(), "NextTargetModeChange");
	drawListArr[drawListArr.Length] = addDrawItemText(toolString, getInstanceL2Util().White, "", True, True);
	Next_Target_BTN.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));	
}

// ���� �κ��丮 ����
function onInventory_ButtonClick()
{
	if( GetWindowHandle("AutoUseItemInventory").IsShowWindow() )GetWindowHandle("AutoUseItemInventory").HideWindow();
	else AutoUseItemInventoryScript.showWindowByParentWindow(Me);
}

// ������ ���� �κ��丮 ����
function forceShowInven()
{
	AutoUseItemInventoryScript.showWindowByParentWindow(Me);
}

function OnHide()
{
	if( GetWindowHandle("AutoUseItemInventory").IsShowWindow() )GetWindowHandle("AutoUseItemInventory").HideWindow();
	if( GetWindowHandle("AutoTargetRangeSettingsWnd").IsShowWindow() )GetWindowHandle("AutoTargetRangeSettingsWnd").HideWindow();
}

function RestoreSettings()
{
	local int nLongTarget, nIsTargetRaid, nTargetMode, nMacroSelect;
	local int nIsMannerModeOn, nIsFixedZone, nIsShowRadius;


	if ( !GetINIInt("AutoUseItemWnd", "nMacroSelect", nMacroSelect, "AutoPlaySettings.ini") )
	{
		nMacroSelect = 0;
		nMacroSlotSelect = nMacroSelect;
		SetINIInt("AutoUseItemWnd", "nMacroSelect", nMacroSelect, "AutoPlaySettings.ini");
	}
	if (! GetINIInt("AutoUseItemWnd", "nTargetMode", nTargetMode, "AutoPlaySettings.ini") )
	{
		nTargetMode = 1; // Monsters
		autotarget_nTargetMode = EAutoNextTargetMode(nTargetMode);
		SetINIInt("AutoUseItemWnd", "nTargetMode", nTargetMode, "AutoPlaySettings.ini");
	}
	// End:0x94
	if( !GetINIBool("AutoUseItemWnd", "bLongTarget", nLongTarget, "AutoPlaySettings.ini") )
	{
		nLongTarget = 1;
		autotarget_bShortTarget = nLongTarget == 0;
		SetINIBool("AutoUseItemWnd", "bLongTarget", numToBool(nLongTarget), "AutoPlaySettings.ini");
	}
	// End:0x104
	if( !GetINIBool("AutoUseItemWnd", "bIsTargetRaid", nIsTargetRaid, "AutoPlaySettings.ini") )
	{
		autotarget_bIsTargetRaid = numToBool(nIsTargetRaid);
		SetINIBool("AutoUseItemWnd", "bIsTargetRaid", numToBool(nIsTargetRaid), "AutoPlaySettings.ini");
	}
	// End:0x174
	if( !GetINIBool("AutoUseItemWnd", "bIsMannerMode", nIsMannerModeOn, "AutoPlaySettings.ini") )
	{
		nIsMannerModeOn = 1;
		autotarget_bIsMannerModeOn = numToBool(nIsMannerModeOn);
		SetINIBool("AutoUseItemWnd", "bIsMannerMode", numToBool(nIsMannerModeOn), "AutoPlaySettings.ini");
	}

	if( !GetINIBool("AutoUseItemWnd", "bIsFixedZone", nIsFixedZone, "AutoPlaySettings.ini") )
	{
		autotarget_bIsFixedZone = numToBool(nIsFixedZone);
		SetINIBool("AutoUseItemWnd", "bIsFixedZone", numToBool(nIsFixedZone), "AutoPlaySettings.ini");
	}

	if( !GetINIBool("AutoUseItemWnd", "bIsShowRadius", nIsShowRadius, "AutoPlaySettings.ini") )
	{
		autotarget_bIsShowRadius = numToBool(nIsShowRadius);
		SetINIBool("AutoUseItemWnd", "bIsShowRadius", numToBool(nIsShowRadius), "AutoPlaySettings.ini");
	}

	nMacroSlotSelect = nMacroSelect;
	autotarget_nTargetMode = EAutoNextTargetMode(nTargetMode);
	autotarget_bShortTarget = !numToBool(nLongTarget);
	autotarget_bIsTargetRaid = numToBool(nIsTargetRaid);
	autotarget_bIsMannerModeOn = numToBool(nIsMannerModeOn);
	autotarget_bIsFixedZone = numToBool(nIsFixedZone);
	autotarget_bIsShowRadius = numToBool(nIsShowRadius);

	SaveINI("AutoPlaySettings.ini");
	AutotargetOnShow();
}

//---------------------------------------------------------------------------------------------------------
// �ڵ� Ÿ��
//---------------------------------------------------------------------------------------------------------
function AutotargetOnShow()  
{
	if( getInstanceUIData().getIsClassicServer() )
	{
		Me.HideWindow();
		return;
	}

	Autotarget_UpdateAutoTargetState();
	Autotarget_SetCusomTooltip();

	Autotarget_UpdateShowHideNextTargetButton();
	Autotarget_NextTargetSetCusomTooltip();
	
	// raid
	Autotarget_updatePickupButton();
	Autotarget_PickupSetCusomTooltip();

	Autotarget_updateMannerModeButton();
	Autotarget_MannerModeSetCusomTooltip();

	Autotarget_updateShowZoneRadiusButton();
	Autotarget_ShowZoneRadiusSetCusomTooltip();

	Autotarget_updateFixedZoneButton();
	Autotarget_FixedZoneSetCusomTooltip();

	SetMacroSlotSelect();
}

function SetMacroSlotSelect()
{
	// End:0x15A
	if( nMacroSlotSelect == 0 )
	{
		MacroSelectBtn_01.SetTexture("L2UI_CT1.AutoShotItemWnd.MacroSelectBtn", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_normal", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_over");
		MacroSelectBtn_02.SetTexture("L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_normal", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_normal", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_over");
		MacroSelectBtn_Click("MacroSelectBtn_01");		
	}
	else
	{
		MacroSelectBtn_01.SetTexture("L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_normal", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_normal", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_over");
		MacroSelectBtn_02.SetTexture("L2UI_CT1.AutoShotItemWnd.MacroSelectBtn", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_normal", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_over");
		MacroSelectBtn_Click("MacroSelectBtn_02");
	}	
}

function Autotarget_Init()
{
	autotarget_bUseAutoTarget = False;
}

// ���� ���
function Autotarget_UpdateShortCutElement()
{
	class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoUseItemWnd.AutoTargetWnd.Macro1ShortcutItem", 156);
	class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoUseItemWnd.AutoTargetWnd.Macro2ShortcutItem", 159);
}

//// Ÿ�� ����
function executeTarget()
{
	// �ٰŸ�, ���Ÿ� 
	if( autotarget_bShortTarget )
	{
		ExecuteCommand("/targetnext");
		Debug("/targetnext");
	}
	else 
	{
		ExecuteCommand("/targetnext2");
		Debug("/targetnext2");
	}
}

// ���� ������ �����Ѵ�.
function Autotarget_SetCusomTooltip()
{
	local Color b0, b1;
	local Array<DrawItemInfo> drawListArr;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;

	shotD_Target_BTN.ClearTooltip();
	shotD_Target_BTN.SetTooltipType("text");

	if( autotarget_bShortTarget )
	{
		b0 = getInstanceL2Util().Yellow;		
	}
	else
	{
		b1 = getInstanceL2Util().Yellow;
	}

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3956), b0, "", True, True);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3957), b1, "", True, True);
	shotD_Target_BTN.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

// ���� ������ �����Ѵ�.
function Autotarget_PickupSetCusomTooltip()
{
	local Color b0, b1;
	local Array<DrawItemInfo> drawListArr;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;

	TargetPickupToggle_BTN.ClearTooltip();
	TargetPickupToggle_BTN.SetTooltipType("text");

	if( autotarget_bIsTargetRaid )
	{
		// �ڵ��ݱ� �ѱ�
		b0 = getInstanceL2Util().Yellow;		
	}
	else
	{
		//�ڵ��ݱ� ���� 
		b1 = getInstanceL2Util().Yellow;
	}

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(15019), b0, "", True, True);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(15020), b1, "", True, True);
	
	TargetPickupToggle_BTN.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function Autotarget_FixedZoneSetCusomTooltip()
{
	local Color b0, b1;
	local Array<DrawItemInfo> drawListArr;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;

	FixedZoneBtn.ClearTooltip();
	FixedZoneBtn.SetTooltipType("text");

	if( autotarget_bIsFixedZone )
	{
		// �ڵ��ݱ� �ѱ�
		b0 = getInstanceL2Util().Yellow;		
	}
	else
	{
		//�ڵ��ݱ� ���� 
		b1 = getInstanceL2Util().Yellow;
	}

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(15021), b0, "", True, True);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(15022), b1, "", True, True);
	
	FixedZoneBtn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function Autotarget_ShowZoneRadiusSetCusomTooltip()
{
	local Color b0, b1;
	local Array<DrawItemInfo> drawListArr;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;

	ShowZoneRadius.ClearTooltip();
	ShowZoneRadius.SetTooltipType("text");

	if( autotarget_bIsShowRadius )
	{
		// �ڵ��ݱ� �ѱ�
		b0 = getInstanceL2Util().Yellow;		
	}
	else
	{
		//�ڵ��ݱ� ���� 
		b1 = getInstanceL2Util().Yellow;
	}

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(15023), b0, "", True, True);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(15024), b1, "", True, True);
	
	ShowZoneRadius.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

function Autotarget_MannerModeSetCusomTooltip()
{
	local Color b0;
	local Color b1;
	local array<DrawItemInfo> drawListArr;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;

	TargetMannerToggle_BTN.ClearTooltip();
	TargetMannerToggle_BTN.SetTooltipType("text");

	if( autotarget_bIsMannerModeOn )
		b0 = getInstanceL2Util().Yellow;
	else
		b1 = getInstanceL2Util().Yellow;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13080),b0,"",True,True);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13081),b1,"",True,True);

	TargetMannerToggle_BTN.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
}

// ��Ŭ�� , �ڵ� Ÿ�� on, off 
function OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	//Debug("OnRButtonUp"@a_WindowHandle.GetWindowName());
	
	switch(a_WindowHandle.GetWindowName())
	{
		case "AutoTargetAll_BTN":
			requestAutoPlay(!autotarget_bUseAutoTarget);
			// End:0x63
			break;
		case "AutoAll_BTN":
			OnClickButton(a_WindowHandle.GetWindowName());
			// End:0x63
			break;
	}
}

// �ڵ� Ÿ���� �ΰ�?
function bool getUseAutoTarget()
{
	return autotarget_bUseAutoTarget;
}

// Ÿ�� �ٰŸ�, ���Ÿ� ��ü
function Autotarget_OnSwap_Target_BTNClick()
{
	autotarget_bShortTarget = !autotarget_bShortTarget;

	SetInIBool("AutoUseItemWnd", "bLongTarget", !autotarget_bShortTarget, "AutoPlaySettings.ini");
	if( autotarget_bShortTarget )getInstanceL2Util().showGfxScreenMessage(GetSystemString(3956));
	else getInstanceL2Util().showGfxScreenMessage(GetSystemString(3957));
	Autotarget_updateShowHideNextTargetButton();
	Autotarget_SetCusomTooltip();

	RequestBypassToServer("multimperia?autoplaySettings meleeMode "$autotarget_bShortTarget);

	SaveINI("AutoPlaySettings.ini");
}

function Autotarget_TargetMannerToggle_BTNClick()
{
	autotarget_bIsMannerModeOn = !autotarget_bIsMannerModeOn;
	SetINIBool("AutoUseItemWnd","bIsMannerMode", autotarget_bIsMannerModeOn, "AutoPlaySettings.ini");
	if( autotarget_bIsMannerModeOn )
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(13080));
	else
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(13081));

	Autotarget_updateMannerModeButton();
	Autotarget_MannerModeSetCusomTooltip();

	SaveINI("AutoPlaySettings.ini");
}

// Ÿ�� �ٰŸ�, ���Ÿ� ��ü
function Autotarget_TargetPickupToggle_BTNClick()
{
	autotarget_bIsTargetRaid = !autotarget_bIsTargetRaid;

	SetInIBool("AutoUseItemWnd", "bIsTargetRaid", autotarget_bIsTargetRaid, "AutoPlaySettings.ini");
	if( autotarget_bIsTargetRaid )getInstanceL2Util().showGfxScreenMessage(GetSystemString(15019));
	else getInstanceL2Util().showGfxScreenMessage(GetSystemString(15020));

	Autotarget_updatePickupButton();
	Autotarget_PickupSetCusomTooltip();
	RequestBypassToServer("multimperia?autoplaySettings targetRaid "$autotarget_bIsTargetRaid);
	SaveINI("AutoPlaySettings.ini");
}

function Autotarget_FixedZoneBtn_BTNClick()
{
	autotarget_bIsFixedZone = !autotarget_bIsFixedZone;

	SetInIBool("AutoUseItemWnd", "bIsFixedZone", autotarget_bIsFixedZone, "AutoPlaySettings.ini");

	if( autotarget_bIsFixedZone )getInstanceL2Util().showGfxScreenMessage(GetSystemString(15021));
	else getInstanceL2Util().showGfxScreenMessage(GetSystemString(15022));

	Autotarget_updateFixedZoneButton();
	Autotarget_FixedZoneSetCusomTooltip();
	RequestBypassToServer("multimperia?autoplaySettings fixedZone "$autotarget_bIsFixedZone);
	SaveINI("AutoPlaySettings.ini");
}

function Autotarget_ShowZoneRadius_BTNClick()
{
	autotarget_bIsShowRadius = !autotarget_bIsShowRadius;
	
	SetINIBool("AutoUseItemWnd", "bIsShowRadius", autotarget_bIsShowRadius, "AutoPlaySettings.ini");
	if( autotarget_bIsShowRadius )getInstanceL2Util().showGfxScreenMessage(GetSystemString(15023));
	else getInstanceL2Util().showGfxScreenMessage(GetSystemString(15024));

	Autotarget_updateShowZoneRadiusButton();
	Autotarget_ShowZoneRadiusSetCusomTooltip();

	RequestBypassToServer("multimperia?autoplaySettings showRange "$autotarget_bIsShowRadius);
	SaveINI("AutoPlaySettings.ini");
}

// �ٰŸ�, ���Ÿ� Ÿ�� ��ư �ؽ��� ����
function Autotarget_updateShowHideNextTargetButton()
{
	if( autotarget_bShortTarget )
	{
		shotD_Target_BTN.SetTexture("l2UI_CT1.AutoShotItemWnd.TargetBTN_ShotD_Normal","l2UI_CT1.AutoShotItemWnd.TargetBTN_ShotD_Down" , "l2UI_CT1.AutoShotItemWnd.TargetBTN_ShotD_Over");
	}
	else
	{
		shotD_Target_BTN.SetTexture("l2UI_CT1.AutoShotItemWnd.TargetBTN_LongD_Normal", "l2UI_CT1.AutoShotItemWnd.TargetBTN_LongD_Down", "l2UI_CT1.AutoShotItemWnd.TargetBTN_LongD_Over");
	}
}

// �ڵ� �ݱ� ��ư �ؽ��� ���� 
function Autotarget_updatePickupButton()
{
	if( autotarget_bIsTargetRaid )
	{
		TargetPickupToggle_BTN.SetTexture("iconEx.AutoUseItemWnd.raid_boss_on", "iconEx.AutoUseItemWnd.raid_boss_on" , "iconEx.AutoUseItemWnd.raid_boss_on");
	}
	else
	{
		TargetPickupToggle_BTN.SetTexture("iconEx.AutoUseItemWnd.raid_boss_off", "iconEx.AutoUseItemWnd.raid_boss_off", "iconEx.AutoUseItemWnd.raid_boss_off");
	}
}

function Autotarget_updateFixedZoneButton()
{
	if( autotarget_bIsFixedZone )
	{
		FixedZoneBtn.SetTexture("iconEx.AutoUseItemWnd.move_center_zone_on", "iconEx.AutoUseItemWnd.move_center_zone_on" , "iconEx.AutoUseItemWnd.move_center_zone_on");
	}
	else
	{
		FixedZoneBtn.SetTexture("iconEx.AutoUseItemWnd.move_center_zone_off", "iconEx.AutoUseItemWnd.move_center_zone_off", "iconEx.AutoUseItemWnd.move_center_zone_off");
	}
}

function Autotarget_updateShowZoneRadiusButton()
{
	if( autotarget_bIsShowRadius )
	{
		ShowZoneRadius.SetTexture("iconEx.AutoUseItemWnd.view_zone_on", "iconEx.AutoUseItemWnd.view_zone_on" , "iconEx.AutoUseItemWnd.view_zone_on");
	}
	else
	{
		ShowZoneRadius.SetTexture("iconEx.AutoUseItemWnd.view_zone_off", "iconEx.AutoUseItemWnd.view_zone_off", "iconEx.AutoUseItemWnd.view_zone_off");
	}
}


function Autotarget_updateMannerModeButton()
{
	if( autotarget_bIsMannerModeOn )
	{
		TargetMannerToggle_BTN.SetTexture("L2UI_CT1.AutoShotItemWnd.MannerBTNON_Normal", "L2UI_CT1.AutoShotItemWnd.MannerBTNON_down", "L2UI_CT1.AutoShotItemWnd.MannerBTNON_over");
	}
	else
	{
		TargetMannerToggle_BTN.SetTexture("L2UI_CT1.AutoShotItemWnd.MannerBTNOff_Normal", "L2UI_CT1.AutoShotItemWnd.MannerBTNOff_down", "L2UI_CT1.AutoShotItemWnd.MannerBTNOff_over");
	}
}

// �ڵ� Ÿ�� Ȱ��ȭ ��ư �̹���, ��� ����
function Autotarget_UpdateAutoTargetState()
{
	if( autotarget_bUseAutoTarget )
	{
		AnimTexturePlay(AutoTarget_ToggleMacro_Anim, True);

		AnimTexturePlay(AutoTargetAllON_ToggleEffect_Anim, True);

		GetWindowHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllON_Win").ShowWindow();
		GetWindowHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllOFF_Win").HideWindow();
	}
	else
	{
		AnimTextureStop(AutoTarget_ToggleMacro_Anim, True);
		
		AnimTextureStop(AutoTargetAllON_ToggleEffect_Anim, True);

		GetWindowHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllON_Win").HideWindow();
		GetWindowHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllOFF_Win").ShowWindow();
	}

	// �ּ�ȭ �ִ� 
	AutoUseItemWndMinScript.setPlayAutoTargetActiveAnim();
	YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
}

// �ڵ� Ÿ�� ����
function requestAutoPlay(bool bUseAutoTarget, optional int nHPPotionPercent)
{
	local AutoplaySettingData pAutoplaySettingData;

	// �ɼ��� Ÿ�� Ÿ��
	autotarget_nTargetMode = GetNextTargetModeOption();
	pAutoplaySettingData.IsAutoPlayOn = bUseAutoTarget;
	pAutoplaySettingData.IsPickupOn = autotarget_bIsTargetRaid;
	pAutoplaySettingData.NextTargetMode = autotarget_nTargetMode;
	pAutoplaySettingData.IsNearTargetMode = autotarget_bShortTarget;
	pAutoplaySettingData.IsMannerModeOn = autotarget_bIsMannerModeOn;
	pAutoplaySettingData.MacroIndex = byte(nMacroSlotSelect);
	// End:0x82
	if( nHPPotionPercent > 0 )
	{
		pAutoplaySettingData.HPPotionPercent = nHPPotionPercent;
	}
	else
	{
		pAutoplaySettingData.HPPotionPercent = autotarget_nHPPotionPercent;
	}
	Debug("------------------------------------------------------------------");
	Debug("API -����-- UpdateAutoplaySetting()");
	Debug("bUseAutoTarget               : "@string(bUseAutoTarget));
	Debug("autotarget_bIsPickupOn       : "@string(autotarget_bIsTargetRaid));
	Debug("autotarget_bIsMannerModeOn    : "@string(autotarget_bIsMannerModeOn));
	Debug("autotarget_nTargetMode       : "@string(autotarget_nTargetMode));
	Debug("autotarget_bShortTarget      : "@string(autotarget_bShortTarget));
	Debug("MacroIndex  : "@string(nMacroSlotSelect));
	Debug("autotarget_nHPPotionPercent  : "@string(pAutoplaySettingData.HPPotionPercent));
	UpdateAutoplaySetting(pAutoplaySettingData);
}

function requestAutoPlayForAutoPotion(int nHPPotionPercent)
{
	requestAutoPlay(autotarget_bUseAutoTarget, nHPPotionPercent);
}

function setShortcutTooltip(string tooltipStr)
{
	GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAll_BTN").SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(2165), getInstanceL2Util().White,, True, tooltipStr, getInstanceL2Util().BWhite,, True));
}

defaultproperties
{
}
