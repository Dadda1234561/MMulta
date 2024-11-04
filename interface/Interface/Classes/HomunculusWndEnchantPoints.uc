class HomunculusWndEnchantPoints extends UICommonAPI;

const TIME_REFRESH= 100;
const TIMEID_DELAY= 1;

enum TYPE_POINT {
	killnpc,
	vp,
	vpinsert
};

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var ItemWindowHandle costIcon00_ItemWindow;
var TextBoxHandle costItemName00;
var TextBoxHandle cost00_Txt;
var StatusBarHandle statusBar0;
var StatusBarHandle statusBar1;
var ButtonHandle btn00;
var ButtonHandle btn01;
var ButtonHandle btn10;
var ButtonHandle btn11;
var ButtonHandle btnplus1;
var int NPCKillPoint;
var int InsertNPCKillPoint;
var int InitNPCKillPoint;
var int VPPoint;
var int InsertVPPoint;
var int InitVPPoint;
var int nActivateSlotIndex;
var int MaxVitality;
var HomunculusWnd HomunculusWndScript;
var HomunculusAPI.HomunEnchantData HomunEnchantData;
var HomunculusWndMainDetailStatsEnchant homunculusWndMainDetailStatsEnchantScript;
var HomunculusWndMainList homunculusWndMainListScript;

function Initialize ()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	util = L2Util(GetScript("L2Util"));
	costIcon00_ItemWindow = GetItemWindowHandle(m_WindowName $ ".costIcon00_ItemWindow");
	costItemName00 = GetTextBoxHandle(m_WindowName $ ".costItemName00");
	cost00_Txt = GetTextBoxHandle(m_WindowName $ ".cost00_Txt");
	btn00 = GetButtonHandle(m_WindowName $ ".btn00");
	btn01 = GetButtonHandle(m_WindowName $ ".btn01");
	btn10 = GetButtonHandle(m_WindowName $ ".btn10");
	btn11 = GetButtonHandle(m_WindowName $ ".btn11");
	btnplus1 = GetButtonHandle(m_WindowName $ ".btnplus1");
	statusBar0 = GetStatusBarHandle(m_WindowName $ ".statusBar0");
	statusBar1 = GetStatusBarHandle(m_WindowName $ ".statusBar1");
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndMainDetailStatsEnchantScript = HomunculusWndMainDetailStatsEnchant(GetScript("HomunculusWnd.HomunculusWndMainDetailStatsEnchant"));
	homunculusWndMainListScript = HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList"));
	MaxVitality = GetMaxVitality();
}

function HandleGameInit()
{
	// End:0x1A
	if(GetGameStateName() != "GAMINGSTATE")
	{
		return;
	}
	HomunEnchantData = HomunculusWndScript.API_GetHomunEnchantData();
}

function OnRegisterEvent ()
{
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_InventoryUpdateItem);
	RegisterEvent(EV_UpdateMyHP);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_POINT_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_INIT_POINT_RESULT);
}

function OnLoad ()
{
	Initialize();
}

function OnEvent (int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_GamingStateEnter:
			if ( HomunculusWndScript.ChkSerVer() )
			{
				HandleGameInit();
			}
			break;
		case EV_InventoryUpdateItem:
			if ( Me.IsShowWindow() )
			{
				SetNeedItemInfo();
			}
			break;
		case EV_UpdateMyHP:
		case EV_UpdateUserInfo:
			if ( Me.IsShowWindow() )
			{
				HandleVPInsertBtnPlus1();
			}
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_POINT_INFO:
			Handle_S_EX_HOMUNCULUS_POINT_INFO();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT:
			Handle_S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_INIT_POINT_RESULT:
			Handle_S_EX_HOMUNCULUS_INIT_POINT_RESULT();
			break;
	}
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "btn00":
			HomunculusWndScript.API_C_EX_HOMUNCULUS_GET_ENCHANT_POINT(0);
			HandleBtnsDisable();
			break;
		case "btn01":
			HomunculusWndScript.API_C_EX_HOMUNCULUS_INIT_POINT(0);
			HandleBtnsDisable();
			break;
		case "btn10":
			HomunculusWndScript.API_C_EX_HOMUNCULUS_GET_ENCHANT_POINT(1);
			HandleBtnsDisable();
			break;
		case "btn11":
			HomunculusWndScript.API_C_EX_HOMUNCULUS_INIT_POINT(1);
			HandleBtnsDisable();
			break;
		case "btnplus1":
			HomunculusWndScript.API_C_EX_HOMUNCULUS_GET_ENCHANT_POINT(2);
			HandleBtnsDisable();
			break;
		case "btnClose":
			Me.HideWindow();
			break;
	}
}

function OnTimer (int TimerID)
{
	switch (TimerID)
	{
		case TIMEID_DELAY:
			Me.KillTimer(TIMEID_DELAY);
			HandleCanBtns();
			break;
	}
}

function Toggle ()
{
	// End:0x1B
	if(Me.IsShowWindow())
	{
		Hide();		
	}
	else
	{
		Show();
	}
}

function Show ()
{
	API_C_EX_SHOW_HOMUNCULUS_INFO();
	SetPoints();
	SetTooltip();
	SetNeedItemInfo();
	Me.ShowWindow();
	Me.SetFocus();
}

function Hide ()
{
	Me.HideWindow();
}

function ArarmOnOff ()
{
	if ( ((HomunEnchantData.PointMax != InsertNPCKillPoint) || (HomunEnchantData.PointResetMax != InitNPCKillPoint)) && (NPCKillPoint >= HomunEnchantData.PointNeedExp) && (HomunEnchantData.PointNeedExp != 0) )
	{
		HomunculusWndScript.SetNotice(1);
	} else {
		HomunculusWndScript.HideNotice(1);
	}
}

function HandleBtnsDisable ()
{
	btn00.DisableWindow();
	btn01.DisableWindow();
	btn10.DisableWindow();
	btn11.DisableWindow();
	btnplus1.DisableWindow();
	Me.SetTimer(TIMEID_DELAY,TIME_REFRESH);
}

function HandleCanBtns()
{
	// End:0x1B
	if(CanInsertKillPoint())
	{
		btn00.EnableWindow();		
	}
	else
	{
		btn00.DisableWindow();
	}
	// End:0x45
	if(CanInitKillPoint())
	{
		btn01.EnableWindow();		
	}
	else
	{
		btn01.DisableWindow();
	}
	// End:0x6F
	if(CanInsertVPPoint())
	{
		btn10.EnableWindow();		
	}
	else
	{
		btn10.DisableWindow();
	}
	// End:0x99
	if(CanInitVPPoint())
	{
		btn11.EnableWindow();		
	}
	else
	{
		btn11.DisableWindow();
	}
	HandleVPInsertBtnPlus1();
}

function SetPoints()
{
	btn00.SetNameText(GetSystemString(13353) $ "\n" $ string(HomunEnchantData.PointMax - InsertNPCKillPoint) $ "/" $ string(HomunEnchantData.PointMax));
	btn01.SetNameText(GetSystemString(479) $ "\n" $ string(HomunEnchantData.PointResetMax - InitNPCKillPoint) $ "/" $ string(HomunEnchantData.PointResetMax));
	btn10.SetNameText(GetSystemString(13353) $ "\n" $ string(HomunEnchantData.BonusMax - InsertVPPoint) $ "/" $ string(HomunEnchantData.BonusMax));
	btn11.SetNameText(GetSystemString(479) $ "\n" $ string(HomunEnchantData.BonusResetMax - InitVPPoint) $ "/" $ string(HomunEnchantData.BonusResetMax));
	HandleCanBtns();
	statusBar0.SetPoint(NPCKillPoint,HomunEnchantData.PointNeedExp);
	statusBar1.SetPoint(VPPoint,HomunEnchantData.BonusNeedVp);
}

function SetNeedItemInfo ()
{
	local ItemInfo iInfo;
	local HomunculusAPI.HomunEnchantResetData HomunEnchantResetData;
	local INT64 ItemNum;

	HomunEnchantResetData = HomunculusWndScript.API_GetPointResetItem();
	iInfo = GetItemInfoByClassID(HomunEnchantResetData.ItemID);
	costIcon00_ItemWindow.AddItem(iInfo);
	costItemName00.SetText(GetItemNameAll(iInfo));
	ItemNum = GetInventoryItemCount(iInfo.Id);
	cost00_Txt.SetText((GetSystemString(13392) $ ":") $ MakeCostString(string(ItemNum)));
}

function SetTooltip ()
{
	local HomunculusAPI.HomunEnchantResetData HomunEnchantResetData;
	local CustomTooltip t;
	local CustomTooltip T2;
	local ItemInfo iInfo;
	local string Msg;
	local string needNumString;
	local string ItemName;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(300);
	HomunEnchantResetData = HomunculusWndScript.API_GetPointResetItem();
	iInfo = GetItemInfoByClassID(HomunEnchantResetData.ItemID);
	ItemName = GetItemNameAll(iInfo);
	needNumString = MakeCostString(string(HomunEnchantResetData.NeededNum));
	Msg = MakeFullSystemMsg(GetSystemMessage(13214),ItemName,needNumString);
	util.ToopTipInsertText(Msg);
	btn01.SetTooltipCustomType(util.getCustomToolTip());
	util.setCustomTooltip(T2);
	util.ToopTipMinWidth(300);
	HomunEnchantResetData = HomunculusWndScript.API_GetBonusResetItem();
	iInfo = GetItemInfoByClassID(HomunEnchantResetData.ItemID);
	ItemName = GetItemNameAll(iInfo);
	needNumString = MakeCostString(string(HomunEnchantResetData.NeededNum));
	Msg = MakeFullSystemMsg(GetSystemMessage(13214),ItemName,needNumString);
	util.ToopTipInsertText(Msg);
	btn11.SetTooltipCustomType(util.getCustomToolTip());
	btnplus1.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13354)));
}

function Handle_S_EX_HOMUNCULUS_POINT_INFO ()
{
	local UIPacket._S_EX_HOMUNCULUS_POINT_INFO packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_HOMUNCULUS_POINT_INFO(packet) )
	{
		return;
	}
	HomunculusWndScript.SetEnchantpoint(packet.nEnchantPoint);
	homunculusWndMainDetailStatsEnchantScript.SetBtnEnable0();
	NPCKillPoint = packet.nNPCKillPoint;
	InsertNPCKillPoint = packet.nInsertNPCKillPoint;
	InitNPCKillPoint = packet.nInitNPCKillPoint;
	VPPoint = packet.nVPPoint;
	InsertVPPoint = packet.nInsertVPPoint;
	InitVPPoint = packet.nInitVPPoint;
	nActivateSlotIndex = packet.nActivateSlotIndex;
	homunculusWndMainListScript.SetActiveSlotIndex(nActivateSlotIndex);
	SetPoints();
	ArarmOnOff();
}

function Handle_S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT ()
{
	local UIPacket._S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT(packet) )
	{
		return;
	}
	Debug("Handle_S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT" @ string(packet.nID) @ string(packet.nEnchantType));
	AddSystemMessage(packet.nID);
	if ( packet.Type == 0 )
	{
		return;
	}
	switch (packet.nEnchantType)
	{
		case 0:
			break;
		case 1:
			break;
		case 2:
			break;
	}
}

function Handle_S_EX_HOMUNCULUS_INIT_POINT_RESULT ()
{
	local UIPacket._S_EX_HOMUNCULUS_INIT_POINT_RESULT packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_HOMUNCULUS_INIT_POINT_RESULT(packet) )
	{
		return;
	}
	AddSystemMessage(packet.nID);
	if ( packet.Type == 0 )
	{
		return;
	}
	switch (packet.nInitType)
	{
		case 0:
			break;
		case 1:
			break;
	}
}

function HandleVPInsertBtnPlus1 ()
{
	// End:0x1B
	if(CanInsertVPPlus())
	{
		btnplus1.EnableWindow();		
	}
	else
	{
		btnplus1.DisableWindow();
	}
}

function bool CanInitKillPoint ()
{
	return (InitNPCKillPoint < HomunEnchantData.PointResetMax) && (InsertNPCKillPoint >= HomunEnchantData.PointMax);
}

function bool CanInsertKillPoint ()
{
	return (NPCKillPoint >= HomunEnchantData.PointNeedExp) && (InsertNPCKillPoint < HomunEnchantData.PointMax);
}

function bool CanInitVPPoint ()
{
	return (InitVPPoint < HomunEnchantData.BonusResetMax) && (InsertVPPoint >= HomunEnchantData.BonusMax);
}

function bool CanInsertVPPoint ()
{
	return (VPPoint >= HomunEnchantData.BonusNeedVp) && (InsertVPPoint < HomunEnchantData.BonusMax);
}

function bool CanInsertVPPlus ()
{
	local UserInfo uInfo;

	if ( GetPlayerInfo(uInfo) )
	{
		return (uInfo.nVitality >= MaxVitality / 4) && (VPPoint < HomunEnchantData.BonusNeedVp);
	}
	return False;
}

function API_C_EX_SHOW_HOMUNCULUS_INFO ()
{
	HomunculusWndScript.API_C_EX_SHOW_HOMUNCULUS_INFO(2);
}

defaultproperties
{
}
