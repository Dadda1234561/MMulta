class HomunculusWnd extends UICommonAPI;

const SKILLIDNUM = 6;
const TIMEID_ENCHANTPOINT = 19;
const TIME_ENCHANTPOINT = 2000;

enum type_State{
	non,				// 0
	birth,				// 1
	Main,				// 2
	Communion,			// 3
	EnchantHomunculus,	// 4
	EnchantPoints,		// 5
	EnchantCommunion	// 6
};

enum TYPE_ANIM 
{
	birth,
	levelup
};

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var TextBoxHandle txt0;
var ButtonHandle btn0;
var HomunculusWndEnchantPoints homunculusWndEnchantPointsScript;
var HomunculusWndBirth homunculusWndBirthScript;
var HomunculusWndGacha homunculusWndGachaScript;
var HomunculusWndMainList homunculusWndMainListScript;
var HomunculusWndMainDetailStats homunculusWndMainDetailStatsScript;
var HomunculusWndMainDetailStatsEnchant homunculusWndMainDetailStatsEnchantScript;
var HomunculusWndMainViewport homunculusWndMainViewportScript;
var HomunculusWndEnchantCommunionChart homunculusWndEnchantCommunionChartScript;
var HomunculusWndEnchantCommunionInfo homunculusWndEnchantCommunionInfoScript;
var HomunculusWndEnchantCommunionDice homunculusWndEnchantCommunionDiceScript;
var TabHandle tab;
var int currentEnchantPoint;
var SideBar SideBarScript;
var bool conditionBirth;
var bool conditionEnchant;
var HomunculusAPI.HomunEnchantData enchantData;
var type_State currState;

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	util = L2Util(GetScript("L2Util"));
	homunculusWndEnchantPointsScript = HomunculusWndEnchantPoints(GetScript(m_WindowName $ ".HomunculusWndEnchantPoints"));
	homunculusWndBirthScript = HomunculusWndBirth(GetScript(m_WindowName $ ".homunculusWndBirth"));
	homunculusWndGachaScript = HomunculusWndGacha(GetScript(m_WindowName $ ".homunculusWndGacha"));
	homunculusWndMainListScript = HomunculusWndMainList(GetScript(m_WindowName $ ".HomunculusWndMainList"));
	homunculusWndMainDetailStatsScript = HomunculusWndMainDetailStats(GetScript(m_WindowName $ ".HomunculusWndMainDetailStats"));
	homunculusWndMainViewportScript = HomunculusWndMainViewport(GetScript(m_WindowName $ ".HomunculusWndMainViewport"));
	homunculusWndMainDetailStatsEnchantScript = HomunculusWndMainDetailStatsEnchant(GetScript(m_WindowName $ ".HomunculusWndMainDetailStatsEnchant"));
	homunculusWndEnchantCommunionChartScript = HomunculusWndEnchantCommunionChart(GetScript(m_WindowName $ ".homunculusWndEnchantCommunionChart"));
	homunculusWndEnchantCommunionInfoScript = HomunculusWndEnchantCommunionInfo(GetScript(m_WindowName $ ".homunculusWndEnchantCommunionInfo"));
	homunculusWndEnchantCommunionDiceScript = HomunculusWndEnchantCommunionDice(GetScript(m_WindowName $ ".homunculusWndEnchantCommunionDice"));
	txt0 = GetTextBoxHandle(m_WindowName $ ".HomunculusWndMainContainer.txt0");
	btn0 = GetButtonHandle(m_WindowName $ ".HomunculusWndMainContainer.btn0");
	tab = GetTabHandle(m_WindowName $ ".tab");
	//SideBarScript = SideBar(GetScript("SideBar"));
	SetPopupScript();
}

function SetPopupScript()
{
	local WindowHandle poopExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle DisableWnd;

	poopExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	popupExpandScript = class'UIControlDialogAssets'.static.InitScript(poopExpandWnd);
	popupExpandScript.SetUseNeedItem(true);
	popupExpandScript.DelegateOnCancel = OnClickPopupCancel;
	popupExpandScript.DelegateOnClickBuy = OnClickPopupBuy;
	DisableWnd = GetWindowHandle(m_WindowName $ ".disable_tex");
	popupExpandScript.SetDisableWindow(DisableWnd);
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop(m_WindowName $ ".disable_tex", false);
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	return UIControlDialogAssets(poopExpandWnd.GetScript());
}

function OnClickPopupBuy()
{
	GetPopupExpandScript().Hide();
}

function OnClickPopupCancel()
{
	local WindowHandle poopExpandWnd;
	local UIControlDialogAssets popupExpandScript;

	poopExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	popupExpandScript = UIControlDialogAssets(poopExpandWnd.GetScript());
	popupExpandScript.Hide();
}

function bool API_IsHomunReady()
{
	return Class'HomunculusAPI'.static.IsHomunReady();
}

function API_C_EX_SHOW_HOMUNCULUS_INFO(int Type)
{
	local array<byte> stream;
	local UIPacket._C_EX_SHOW_HOMUNCULUS_INFO packet;

	packet.Type = Type;
	// End:0x30
	if(! Class'UIPacket'.static.Encode_C_EX_SHOW_HOMUNCULUS_INFO(stream, packet))
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SHOW_HOMUNCULUS_INFO, stream);
}

function API_C_EX_HOMUNCULUS_ACTIVATE_SLOT(int SlotIndex)
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_ACTIVATE_SLOT packet;

	packet.SlotIndex = SlotIndex;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_HOMUNCULUS_ACTIVATE_SLOT(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_HOMUNCULUS_ACTIVATE_SLOT, stream);
}

function API_C_EX_HOMUNCULUS_CREATE_START()
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_CREATE_START packet;

	if ( !Class'UIPacket'.static.Encode_C_EX_HOMUNCULUS_CREATE_START(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_HOMUNCULUS_CREATE_START,stream);
}

function API_C_EX_HOMUNCULUS_INSERT(int Type)
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_INSERT packet;

	packet.Type = Type;
	if ( !Class'UIPacket'.static.Encode_C_EX_HOMUNCULUS_INSERT(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_HOMUNCULUS_INSERT,stream);
}

function API_C_EX_HOMUNCULUS_SUMMON()
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_SUMMON packet;

	if ( !Class'UIPacket'.static.Encode_C_EX_HOMUNCULUS_SUMMON(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_HOMUNCULUS_SUMMON,stream);
}

function HomunculusAPI.HomunCreateData API_GetHomunCreateData()
{
	return Class'HomunculusAPI'.static.GetHomunCreateData();
}

function INT64 API_GetRemainBirthSeconds()
{
	return Class'HomunculusAPI'.static.GetRemainBirthSeconds();
}

function array<HomunculusAPI.HomunculusData> API_GetHomunculusDatas()
{
	return Class'HomunculusAPI'.static.GetHomunculusDatas();
}

function HomunculusAPI.HomunculusNpcLevelData API_GetHomunculusNpcLevelData (int Id, int Level)
{
	return Class'HomunculusAPI'.static.GetHomunculusNpcLevelData(Id,Level);
}

function HomunculusAPI.HomunculusNpcLevelData API_GetMaxHomunculusNpcLevelData (int Id)
{
	return Class'HomunculusAPI'.static.GetMaxHomunculusNpcLevelData(Id);
}

function API_C_EX_DELETE_HOMUNCULUS_DATA(int idx)
{
	local array<byte> stream;
	local UIPacket._C_EX_DELETE_HOMUNCULUS_DATA packet;

	packet.nIdx = idx;
	if ( !Class'UIPacket'.static.Encode_C_EX_DELETE_HOMUNCULUS_DATA(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DELETE_HOMUNCULUS_DATA,stream);
}

function API_C_EX_REQUEST_ACTIVATE_HOMUNCULUS(int idx, bool bActive)
{
	local array<byte> stream;
	local UIPacket._C_EX_REQUEST_ACTIVATE_HOMUNCULUS packet;

	packet.nIdx = idx;
	// End:0x29
	if(bActive)
	{
		packet.bActivate = 1;		
	}
	else
	{
		packet.bActivate = 0;
	}
	if ( !Class'UIPacket'.static.Encode_C_EX_REQUEST_ACTIVATE_HOMUNCULUS(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_REQUEST_ACTIVATE_HOMUNCULUS,stream);
}

function HomunculusAPI.HomunculusNpcData GetHomunculusNpcData (int Id)
{
	return Class'HomunculusAPI'.static.GetHomunculusNpcData(Id);
}

function HomunculusAPI.HomunEnchantData API_GetHomunEnchantData ()
{
	return Class'HomunculusAPI'.static.GetHomunEnchantData();
}

function HomunculusAPI.HomunEnchantResetData API_GetPointResetItem ()
{
	return Class'HomunculusAPI'.static.GetPointResetItem();
}

function HomunculusAPI.HomunEnchantResetData API_GetBonusResetItem ()
{
	return Class'HomunculusAPI'.static.GetBonusResetItem();
}

function API_C_EX_HOMUNCULUS_ENCHANT_EXP(int idx)
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_ENCHANT_EXP packet;

	packet.nIdx = idx;
	if ( !Class'UIPacket'.static.Encode_C_EX_HOMUNCULUS_ENCHANT_EXP(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_HOMUNCULUS_ENCHANT_EXP,stream);
}

function API_C_EX_HOMUNCULUS_GET_ENCHANT_POINT(int Type)
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_GET_ENCHANT_POINT packet;

	packet.Type = Type;
	if ( !Class'UIPacket'.static.Encode_C_EX_HOMUNCULUS_GET_ENCHANT_POINT(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_HOMUNCULUS_GET_ENCHANT_POINT,stream);
}

function API_C_EX_HOMUNCULUS_INIT_POINT(int Type)
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_INIT_POINT packet;

	packet.Type = Type;
	if ( !Class'UIPacket'.static.Encode_C_EX_HOMUNCULUS_INIT_POINT(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_HOMUNCULUS_INIT_POINT, stream);
}

function API_C_EX_ENCHANT_HOMUNCULUS_SKILL(int Type, int idx, int Level)
{
	local array<byte> stream;
	local UIPacket._C_EX_ENCHANT_HOMUNCULUS_SKILL packet;

	packet.Type = Type;
	packet.nIdx = idx;
	packet.nLevel = Level;
	if ( !Class'UIPacket'.static.Encode_C_EX_ENCHANT_HOMUNCULUS_SKILL(stream, packet))
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_ENCHANT_HOMUNCULUS_SKILL,stream);
}

function OnRegisterEvent()
{
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_Restart);
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
}

function OnEvent (int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_GamingStateEnter:
			if ( ChkSerVer() )
			{
				HandleGameInit();
			}
			break;
		case EV_Restart:
			if ( ChkSerVer() )
			{
				SetState(non);
			}
			break;
	}
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "btn0":
			homunculusWndEnchantPointsScript.Toggle();
			if (	!homunculusWndEnchantPointsScript.Me.IsShowWindow() )
			{
				btn0.DisableWindow();
				Me.SetTimer(TIMEID_ENCHANTPOINT,TIME_ENCHANTPOINT);
			}
			break;
		case "btn1":
			SetState(Communion);
			break;
		case "HelpWnd_Btn":
			ExecuteEvent(EV_ShowHelp,"109");
			break;
		default:
			HandleBtnClick(Name);
			break;
	}
}

event OnRClickButton(string Name)
{
	HandleBtnClick(Name);
}

function OnShow()
{
	homunculusWndMainViewportScript._SetSpawnOnShow();
	// End:0x33
	if(! API_IsHomunReady())
	{
		Me.HideWindow();
		AddSystemMessage(213);
		return;
	}
	// End:0x58
	if(IsPlayerOnWorldRaidServer())
	{
		Me.HideWindow();
		AddSystemMessage(4047);
		return;
	}
	switch(currState)
	{
		// End:0x79
		case type_State.birth:
			// End:0x76
			if(homunculusWndBirthScript.isGachaState)
			{
				homunculusWndGachaScript.Show();
			}
			// End:0xA2
			break;
		// End:0x9F
		case type_State.non:
			API_C_EX_SHOW_HOMUNCULUS_INFO(0);
			API_C_EX_SHOW_HOMUNCULUS_INFO(1);
			API_C_EX_SHOW_HOMUNCULUS_INFO(2);
			SetState(birth);
			// End:0xA2
			break;
	}
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), true);
	// End:0xED
	if(conditionEnchant)
	{
		SetState(Main);
		homunculusWndEnchantPointsScript.Show();
	}
	else
	{
		// End:0xFE
		if(conditionBirth)
		{
			SetState(birth);
		}
	}
}

function OnHide()
{
	HidePopup();
	homunculusWndGachaScript.SetOnHide();
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), false);
	// End:0x94
	if(GetWindowHandle("HomunculusWndProbability").IsShowWindow())
	{
		GetWindowHandle("HomunculusWndProbability").HideWindow();
	}
	homunculusWndMainViewportScript._SetDispawnOnHide();
	// End:0xCD
	if(homunculusWndBirthScript.resultWnd.IsShowWindow())
	{
		homunculusWndBirthScript.HandleConfirm();
	}
}

function OnTimer (int tID)
{
	switch (tID)
	{
		case TIMEID_ENCHANTPOINT:
			Me.KillTimer(TIMEID_ENCHANTPOINT);
			btn0.EnableWindow();
			break;
	}
}

function HandleBtnClick (string btnName)
{
	local string strID;

	if ( GetStringIDFromBtnName(btnName,"tab",strID) )
	{
		switch (strID)
		{
			case "0":
				SetState(birth);
				break;
			case "1":
				SetState(Main);
				break;
		}
	}
}

function HidePopup()
{
	local WindowHandle poopExpandWnd;
	local UIControlDialogAssets popupExpandScript;

	poopExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	popupExpandScript = UIControlDialogAssets(poopExpandWnd.GetScript());
	popupExpandScript.Hide();
}

function bool GetIsPopupShow()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	return poopExpandWnd.IsShowWindow();
}

function HandleGameInit()
{
	// End:0x1A
	if(GetGameStateName() != "GAMINGSTATE")
	{
		return;
	}
	enchantData = API_GetHomunEnchantData();
}

function SetEnchantpoint(int point)
{
	currentEnchantPoint = point;
	txt0.SetText(MakeCostString(string(currentEnchantPoint)));
}

function RenewHomunculusData()
{
	homunculusWndMainDetailStatsScript.SetChangeHomunculusData();
	homunculusWndMainDetailStatsEnchantScript.SetChangeHomunculusData();
	homunculusWndMainViewportScript.SetChangeHomunculusData();
	homunculusWndEnchantCommunionChartScript.SetChangeHomunculusData();
	homunculusWndEnchantCommunionInfoScript.SetChangeHomunculusData();
}

function ClearHomunculusData()
{
	homunculusWndMainViewportScript.ClearAll();
	homunculusWndMainDetailStatsScript.ClearAll();
	homunculusWndMainDetailStatsEnchantScript.ClearAll();
	homunculusWndEnchantCommunionChartScript.ClearAll();
	homunculusWndEnchantCommunionInfoScript.ClearAll();
}

function SetState (type_State NewState)
{
	switch (NewState)
	{
		case birth:
			tab.SetTopOrder(0, true);
			homunculusWndEnchantPointsScript.Hide();
			homunculusWndBirthScript.Show();
			homunculusWndMainListScript.Hide();
			homunculusWndMainDetailStatsScript.Hide();
			homunculusWndMainDetailStatsEnchantScript.Hide();
			homunculusWndMainViewportScript.Hide();
			homunculusWndEnchantCommunionChartScript.Hide();
			homunculusWndEnchantCommunionInfoScript.Hide();
			homunculusWndEnchantCommunionDiceScript.Hide();
			break;
		case Main:
			API_C_EX_SHOW_HOMUNCULUS_INFO(2);
			tab.SetTopOrder(1, true);
			homunculusWndEnchantPointsScript.Hide();
			homunculusWndBirthScript.Hide();
			homunculusWndMainListScript.Show();
			homunculusWndMainDetailStatsScript.Show();
			homunculusWndMainDetailStatsEnchantScript.Hide();
			homunculusWndMainViewportScript.Show();
			homunculusWndEnchantCommunionChartScript.Hide();
			homunculusWndEnchantCommunionInfoScript.Hide();
			homunculusWndEnchantCommunionDiceScript.Hide();
			break;
		case EnchantHomunculus:
			homunculusWndEnchantPointsScript.Hide();
			homunculusWndBirthScript.Hide();
			homunculusWndMainListScript.Show();
			homunculusWndMainDetailStatsScript.Hide();
			homunculusWndMainDetailStatsEnchantScript.Show();
			homunculusWndMainViewportScript.Show();
			homunculusWndEnchantCommunionChartScript.Hide();
			homunculusWndEnchantCommunionInfoScript.Hide();
			homunculusWndEnchantCommunionDiceScript.Hide();
			break;
		case Communion:
			if ( currState != EnchantCommunion )
			{
				homunculusWndEnchantPointsScript.Hide();
				homunculusWndBirthScript.Hide();
				homunculusWndMainListScript.Hide();
				homunculusWndMainDetailStatsScript.Hide();
				homunculusWndMainDetailStatsEnchantScript.Hide();
				homunculusWndMainViewportScript.Show();
				homunculusWndEnchantCommunionChartScript.Show();
				homunculusWndEnchantCommunionInfoScript.Show();
				homunculusWndEnchantCommunionDiceScript.Hide();
			}
			else
			{
				homunculusWndEnchantCommunionDiceScript.Hide();
			}
			break;
		case EnchantCommunion:
			if ( currState != Communion )
			{
				homunculusWndEnchantPointsScript.Hide();
				homunculusWndBirthScript.Hide();
				homunculusWndMainListScript.Hide();
				homunculusWndMainDetailStatsScript.Hide();
				homunculusWndMainDetailStatsEnchantScript.Hide();
				homunculusWndMainViewportScript.Show();
				homunculusWndEnchantCommunionChartScript.Show();
				homunculusWndEnchantCommunionInfoScript.Show();
			}
			homunculusWndEnchantCommunionDiceScript.Show();
			break;
	}
	currState = NewState;
}

function SetNotice (int Type)
{
	switch (Type)
	{
		case 0:
			conditionBirth = True;
			break;
		case 1:
			conditionEnchant = True;
			break;
	}
	//ArarmOnOff(conditionBirth || conditionEnchant);
}

function HideNotice (int Type)
{
	switch (Type)
	{
		case 0:
			conditionBirth = false;
			break;
		case 1:
			conditionEnchant = false;
			break;
	}
	//ArarmOnOff(conditionBirth || conditionEnchant);
}

//function ArarmOnOff (bool isOn)
//{
//	local AnimTextureHandle Anim;
//	local EffectViewportWndHandle Viewport;
//	local SideBar SideBarScript;
//
//	SideBarScript = SideBar(GetScript("SideBar"));
//	Viewport = SideBarScript.GetEffectViewportByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_HOMUNCULUSWND, 0);
//	if ( SideBarScript._IsAlarmActived(SideBarScript.SIDEBAR_WINDOWS.TYPE_HOMUNCULUSWND) == isOn)
//	{
//		return;
//	}
//	if ( isOn )
//	{
//		SideBarScript.SetAlarmOnOff(SideBarScript.SIDEBAR_WINDOWS.TYPE_HOMUNCULUSWND, true);
//		SideBarScript.GetEffectAniTextureByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_HOMUNCULUSWND, 0).ShowWindow();
//		SideBarScript.GetEffectViewportByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_HOMUNCULUSWND, 0).ShowWindow();
//		Anim = SideBarScript.GetEffectAniTextureByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_HOMUNCULUSWND, 0);
//		Anim.ShowWindow();
//		Anim.Stop();
//		Anim.SetLoopCount(1);
//		Anim.Play();
//		Viewport.SpawnEffect("LineageEffect2.ui_star_circle");
//		Viewport.ShowWindow();
//	} else {
//		SideBarScript.SetAlarmOnOff(SideBarScript.SIDEBAR_WINDOWS.TYPE_HOMUNCULUSWND, false);
//		SideBarScript.GetEffectAniTextureByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_HOMUNCULUSWND, 0).HideWindow();
//		SideBarScript.GetEffectViewportByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_HOMUNCULUSWND, 0).HideWindow();
//		Viewport.SpawnEffect("");
//		Anim.Stop();
//		Anim.HideWindow();
//	}
//}

function bool GetStringIDFromBtnName (string btnName, string someString, out string strID)
{
	if ( !CheckBtnName(btnName,someString) )
	{
		return False;
	}
	strID = Mid(btnName,Len(someString));
	return True;
}

function bool CheckBtnName (string btnName, string someString)
{
	return Left(btnName,Len(someString)) == someString;
}

function string GetGradeString (int Type)
{
	switch (Type)
	{
		case 0:
			return GetSystemString(441);
			break;
		case 1:
			return GetSystemString(3290);
			break;
		case 2:
			return GetSystemString(13336);
			break;
	}
	return "";
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	// End:0x1A
	if(GetIsPopupShow())
	{
		HidePopup();
	}
	else if ( homunculusWndEnchantPointsScript.Me.IsShowWindow() )
	{
		homunculusWndEnchantPointsScript.Hide();
	}
	else
	{
		switch (currState)
		{
			case EnchantCommunion:
				Debug("OnReceivedCloseUI" @ string(homunculusWndEnchantCommunionDiceScript.completedDiceNum));
				if ( homunculusWndEnchantCommunionDiceScript.completedDiceNum == homunculusWndEnchantCommunionDiceScript.DICEMAX )
				{
					SetState(Communion);
				} else {
					Me.HideWindow();
				}
				break;
			case EnchantHomunculus:
				SetState(Main);
				break;
			case Communion:
				SetState(Main);
				break;
		}
		Me.HideWindow();
	}
}

function bool ChkSerVer()
{
	return getInstanceUIData().getIsLiveServer();
}

defaultproperties
{
}
