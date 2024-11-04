class HomunculusWndEnchantCommunionInfo extends UICommonAPI;

const DIALOG_ID_COMMUNION = 0;

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var TextBoxHandle text0;
var TextBoxHandle text1;
var StatusRoundHandle MainStatus;
var RichListCtrlHandle List_ListCtrl0;
var TextBoxHandle cost00_Txt;
var TextBoxHandle costMine00_Txt;
var TextBoxHandle cost01_Txt;
var TextBoxHandle costMine01_Txt;
var TextBoxHandle cost00_Txt_Dice;
var TextBoxHandle costMine00_Txt_Dice;
var TextBoxHandle cost01_Txt_Dice;
var TextBoxHandle costMine01_Txt_Dice;
var ButtonHandle btnEnchant;
var ButtonHandle btnHelp;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndEnchantCommunionChart homunculusWndEnchantCommunionChartScript;
var HomunculusWndEnchantCommunionDice HomunculusWndEnchantCommunionDiceSctipt;
var HomunculusAPI.HomunEnchantData currHomunEnchantData;
var int currentindex;
var int currentEnchantPoint;
var INT64 mySP;
var int requestedCommunionIdx;

function ClearAll()
{
	text0.SetText("");
	text1.SetText(GetSystemString(13393));
	MainStatus.SetPoint(0,homunculusWndEnchantCommunionChartScript.LevelMax);
	List_ListCtrl0.DeleteAllItem();
	costMine00_Txt.SetText("");
	costMine01_Txt.SetText("");
	btnEnchant.DisableWindow();
	currentindex = -1;
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	util = L2Util(GetScript("L2Util"));
	text0 = GetTextBoxHandle(m_WindowName $ ".text0");
	text1 = GetTextBoxHandle(m_WindowName $ ".text1");
	MainStatus = GetStatusRoundHandle(m_WindowName $ ".MainStatus");
	List_ListCtrl0 = GetRichListCtrlHandle(m_WindowName $ ".List_ListCtrl0");
	List_ListCtrl0.SetSelectable(false);
	List_ListCtrl0.SetUseStripeBackTexture(false);
	List_ListCtrl0.ShowScrollBar(false);
	List_ListCtrl0.SetAppearTooltipAtMouseX(true);
	List_ListCtrl0.SetSelectedSelTooltip(false);
	cost00_Txt = GetTextBoxHandle(m_WindowName $ ".cost00_Txt");
	costMine00_Txt = GetTextBoxHandle(m_WindowName $ ".costMine00_Txt");
	cost01_Txt = GetTextBoxHandle(m_WindowName $ ".cost01_Txt");
	costMine01_Txt = GetTextBoxHandle(m_WindowName $ ".costMine01_Txt");
	cost00_Txt_Dice = GetTextBoxHandle("HomunculusWnd.HomunculusWndEnchantCommunionDice.cost00_Txt");
	costMine00_Txt_Dice = GetTextBoxHandle("HomunculusWnd.HomunculusWndEnchantCommunionDice.costMine00_Txt");
	cost01_Txt_Dice = GetTextBoxHandle("HomunculusWnd.HomunculusWndEnchantCommunionDice.cost01_Txt");
	costMine01_Txt_Dice = GetTextBoxHandle("HomunculusWnd.HomunculusWndEnchantCommunionDice.costMine01_Txt");
	btnEnchant = GetButtonHandle(m_WindowName $ ".btnEnchant");
	btnHelp = GetButtonHandle(m_WindowName $ ".btnHelp");
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndEnchantCommunionChartScript = HomunculusWndEnchantCommunionChart(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionChart"));
	HomunculusWndEnchantCommunionDiceSctipt = HomunculusWndEnchantCommunionDice(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionDice"));
	GetButtonHandle(m_WindowName $ ".EnchantHelp_btn").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13402)));
}

function HandleGameInit()
{
	if(GetGameStateName() != "GAMINGSTATE")
	{
		return;
	}
	currHomunEnchantData = HomunculusWndScript.API_GetHomunEnchantData();
	cost00_Txt.SetText(MakeCostString(string(currHomunEnchantData.CommunionNeedEnchantPoint)));
	cost01_Txt.SetText(MakeCostString(string(currHomunEnchantData.CommunionNeedSpPoint)));
	cost00_Txt_Dice.SetText(MakeCostString(string(currHomunEnchantData.CommunionNeedEnchantPoint)));
	cost01_Txt_Dice.SetText(MakeCostString(string(currHomunEnchantData.CommunionNeedSpPoint)));
}

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_HPSPVP);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_POINT_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_ACTIVATE_HOMUNCULUS_RESULT);
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_UpdateMyHP);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_DialogOK);
}

function OnLoad()
{
	Initialize();
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_POINT_INFO:
			Handle_S_EX_HOMUNCULUS_POINT_INFO();
			break;
		case EV_GamingStateEnter:
			if ( HomunculusWndScript.ChkSerVer() )
			{
				HandleGameInit();
			}
			break;
		case EV_UpdateMyHP:
		case EV_UpdateUserInfo:
			if ( Me.IsShowWindow() )
			{
				SetMyStat();
			}
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_HPSPVP:
			if ( Me.IsShowWindow() )
			{
				Handle_S_EX_HOMUNCULUS_HPSPVP();
			}
			break;
		case EV_DialogOK:
			HandleDialogOK(True);
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_ACTIVATE_HOMUNCULUS_RESULT:
			Handle_S_EX_ACTIVATE_HOMUNCULUS_RESULT();
			break;
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnEnchant":
			HandleBtnEnchant();
			break;
		case "btnClose":
			HomunculusWndScript.SetState(HomunculusWndScript.type_State.Main);
			break;
	}
}

function Show()
{
	ClearAll();
	SetMyStat();
	Me.ShowWindow();
	Me.SetFocus();
}

function Hide()
{
	requestedCommunionIdx = -1;
	Me.HideWindow();
}

function SetChangeHomunculusData()
{
	SetHomunculusCommunion();
	SetTooltip();
}

function SetTooltip()
{
	local CustomTooltip t;
	local HomunculusAPI.HomunculusNpcLevelData npcLevelData;
	local int i;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(200);
	util.ToopTipInsertText(GetSystemString(13391), true, true);
	util.TooltipInsertItemBlank(5);
	util.TooltipInsertItemLine();
	util.ToopTipInsertColorText(GetSkillName(GetCurrHomunculusData().SkillID[0], GetCurrHomunculusData().SkillLevel[0]), true ,true, GetColor(170,153,119,255));

	for ( i = 0;i < HomunculusWndScript.SKILLIDNUM;i++ )
	{
		npcLevelData = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id,i + 1);
		util.ToopTipInsertText(GetSkillName(npcLevelData.OptionSkillId[2],npcLevelData.OptionSkillLevel[2]),True,True);
	}
	btnHelp.SetTooltipCustomType(util.getCustomToolTip());
}

function SetMyStat()
{
	local UserInfo uInfo;

	if (GetPlayerInfo(uInfo))
	{
		mySP = uInfo.nSP;
		SetNeedInfo();
	}
}

function SetNeedInfo()
{
	if(currentEnchantPoint < currHomunEnchantData.CommunionNeedEnchantPoint)
	{
		costMine00_Txt.SetTextColor(getInstanceL2Util().DRed);
		costMine00_Txt_Dice.SetTextColor(getInstanceL2Util().DRed);
	}
	else
	{
		costMine00_Txt.SetTextColor(getInstanceL2Util().BLUE01);
		costMine00_Txt_Dice.SetTextColor(getInstanceL2Util().BLUE01);
	}
	if ( mySP < currHomunEnchantData.CommunionNeedSpPoint )
	{
		costMine01_Txt.SetTextColor(getInstanceL2Util().DRed);
		costMine01_Txt_Dice.SetTextColor(getInstanceL2Util().DRed);
	}
	else
	{
		costMine01_Txt.SetTextColor(getInstanceL2Util().BLUE01);
		costMine01_Txt_Dice.SetTextColor(getInstanceL2Util().BLUE01);
	}
	costMine00_Txt.SetText("(" $ MakeCostString(string(currentEnchantPoint)) $ ")");
	costMine01_Txt.SetText("(" $ MakeCostStringINT64(mySP) $ ")");
	costMine00_Txt_Dice.SetText("(" $ MakeCostString(string(currentEnchantPoint)) $ ")");
	costMine01_Txt_Dice.SetText("(" $ MakeCostStringINT64(mySP) $ ")");
	CheckBtnEnchant();
}

function SetHomunculusCommunion()
{
	local int i;
	local array<string> descs;
	local string Desc;
	local ItemID Id;

	List_ListCtrl0.DeleteAllItem();
	Id.ClassID = GetCurrHomunculusData().SkillID[0];
	Desc = Class'UIDATA_SKILL'.static.GetDescription(Id,GetCurrHomunculusData().SkillLevel[0],0);
	Split(Desc,"^",descs);
	List_ListCtrl0.InsertRecord(makeRecord(descs[0], descs[1], true));
	
	for ( i = 1;i < HomunculusWndScript.SKILLIDNUM;i++ )
	{
		if ( GetCurrHomunculusData().SkillLevel[i] > 0 )
		{
			Id.ClassID = GetCurrHomunculusData().SkillID[i];
			Desc = Class'UIDATA_SKILL'.static.GetDescription(Id,GetCurrHomunculusData().SkillLevel[i],0);
			if ( Desc != "" )
			{
				descs.Length = 0;
				Split(Desc, "^", descs);
				List_ListCtrl0.InsertRecord(makeRecord(descs[0], descs[1], false));
			}
		}
	}
}

function SetEnchantpoint(int point)
{
	currentEnchantPoint = point;
	SetNeedInfo();
}

function SetSelect(int Index)
{
	currentindex = Index;
	text0.SetText(string(Index + 1));
	SetCurrSkillName();
	MainStatus.SetPoint(GetCurrHomunculusData().SkillLevel[Index + 1],homunculusWndEnchantCommunionChartScript.LevelMax);
	CheckBtnEnchant();
}

function CheckBtnEnchant()
{
	btnEnchant.DisableWindow();
	if ( currentindex == -1 )
	{
		return;
	}
	if ( mySP < currHomunEnchantData.CommunionNeedSpPoint )
	{
		return;
	}
	if ( currentEnchantPoint < currHomunEnchantData.CommunionNeedEnchantPoint )
	{
		return;
	}
	if ( GetCurrHomunculusData().SkillLevel[currentindex + 1] >= homunculusWndEnchantCommunionChartScript.LevelMax )
	{
		return;
	}
	btnEnchant.EnableWindow();
}

function Handle_S_EX_HOMUNCULUS_POINT_INFO()
{
	local UIPacket._S_EX_HOMUNCULUS_POINT_INFO packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_HOMUNCULUS_POINT_INFO(packet) )
	{
		return;
	}
	SetEnchantpoint(packet.nEnchantPoint);
}

function Handle_S_EX_HOMUNCULUS_HPSPVP()
{
	local UIPacket._S_EX_HOMUNCULUS_HPSPVP packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_HOMUNCULUS_HPSPVP(packet) )
	{
		return;
	}
	mySP = packet.nSP;
	SetNeedInfo();
}

function Handle_S_EX_ACTIVATE_HOMUNCULUS_RESULT()
{
	local UIPacket._S_EX_ACTIVATE_HOMUNCULUS_RESULT packet;

	if ( !Class'UIPacket'.static.Decode_S_EX_ACTIVATE_HOMUNCULUS_RESULT(packet) )
	{
		return;
	}
	if ( packet.Type != 1 )
	{
		return;
	}
	if ( packet.bActivate == 0 )
	{
		if ( requestedCommunionIdx == GetCurrHomunculusData().idx )
		{
			CheckBtnEnchant();
			if ( btnEnchant.IsEnableWindow() )
			{
				HomunculusWndScript.SetState(HomunculusWndScript.type_State.EnchantCommunion);
			}
			requestedCommunionIdx = -1;
		}
	}
}

function HandleBtnEnchant()
{
	ShowCommunionOffDialog();
}

function HandleDialogOK(bool bOK)
{
	if ( !DialogIsMine() )
	{
		return;
	}
	switch (DialogGetID())
	{
		case DIALOG_ID_COMMUNION:
		if (	!bOK )
		{
			return;
		}
		if ( GetCurrHomunculusData().Activate )
		{
			btnEnchant.DisableWindow();
			requestedCommunionIdx = GetCurrHomunculusData().idx;
			HomunculusWndScript.API_C_EX_REQUEST_ACTIVATE_HOMUNCULUS(requestedCommunionIdx, !GetCurrHomunculusData().Activate);
		} else {
			HomunculusWndScript.SetState(HomunculusWndScript.type_State.EnchantCommunion);
		}
		break;
	}
}

function ShowCommunionOffDialog()
{
	local DialogBox dScript;

	dScript = DialogBox(GetScript("DialogBox"));
	dScript.setId(0);
	dScript.ShowDialog(DialogModalType_Modal,DialogType_OKCancel,GetSystemString(13376),string(self));
}

function RichListCtrlRowData makeRecord(string Name, string numString, bool isBase)
{
	local RichListCtrlRowData Record;
	local Color tmpTextColor;

	Record.cellDataList.Length = 2;
	Record.szReserved = "ÅøÆÁ Á¤º¸µé";
	if ( isBase )
	{
		tmpTextColor = GetColor(170,153,119,255);
	} else {
		tmpTextColor = util.BrightWhite;
	}
	addRichListCtrlString(Record.cellDataList[0].drawitems, Name, tmpTextColor, false);
	addRichListCtrlString(Record.cellDataList[1].drawitems, numString, tmpTextColor, false, 20);
	return Record;
}

function string GetSkillName(int SkillID, int Level)
{
	local array<string> descs;
	local string Desc;
	local ItemID Id;

	Id.ClassID = SkillID;
	Desc = Class'UIDATA_SKILL'.static.GetDescription(Id,Level,0);
	if ( Desc == "" )
	{
		return "";
	}
	Split(Desc,"^",descs);
	return descs[0] @ descs[1];
}

function SetCurrSkillName()
{
	local int SkillLevel;
	local ItemID Id;
	local array<string> descs;
	local string Desc;
	local HomunculusAPI.HomunculusNpcLevelData npcLevelData;

	npcLevelData = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id,currentindex + 1);
	if ( GetCurrHomunculusData().SkillLevel[currentindex + 1] > 0 )
	{
		Id.ClassID = GetCurrHomunculusData().SkillID[currentindex + 1];
		SkillLevel = GetCurrHomunculusData().SkillLevel[currentindex + 1];
		Desc = Class'UIDATA_SKILL'.static.GetDescription(Id,SkillLevel,0);
		Debug("SetCurrSkillName" @ Desc);
		if ( Desc == "" )
		{
			text1.SetText("");
		} else {
			Split(Desc,"^",descs);
			text1.SetText(descs[0] $ ":" $ descs[1]);
		}
	} else {
		Id.ClassID = npcLevelData.OptionSkillId[2];
		SkillLevel = npcLevelData.OptionSkillLevel[2];
		Desc = Class'UIDATA_SKILL'.static.GetDescription(Id,SkillLevel,0);
		if ( Desc == "" )
		{
			text1.SetText("");
		} else {
			Split(Desc,"^",descs);
			text1.SetText(descs[0] $ ":" @ GetSystemString(3809) $ descs[1]);
		}
	}
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData ()
{
	return HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList")).GetCurrHomunculusData();
}

defaultproperties
{
}
