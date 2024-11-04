class HomunculusWndProbability extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle CloseButton;
var TextBoxHandle Title_TextBox;
var RichListCtrlHandle List_ListCtrl;
var ButtonHandle Close_Btn;

event OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_CREATE_PROB_LIST);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_COUPON_PROB_LIST);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle("HomunculusWndProbability");
	Title_TextBox = GetTextBoxHandle("HomunculusWndProbability.Title_TextBox");
	List_ListCtrl = GetRichListCtrlHandle("HomunculusWndProbability.List_ListCtrl");
	Close_Btn = GetButtonHandle("HomunculusWndProbability.Close_BTN");
	CloseButton = GetButtonHandle("HomunculusWndProbability.CloseButton");
}

function OnShow()
{}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x20
		case "CloseButton":
			OnCloseButtonClick();
			// End:0x3A
			break;
		// End:0x37
		case "Close_BTN":
			OnClose_BtnClick();
			// End:0x3A
			break;
	}
}

function OnCloseButtonClick()
{
	Me.HideWindow();
}

function OnClose_BtnClick()
{
	Me.HideWindow();
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		// End:0x28
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_CREATE_PROB_LIST:
			Handle_S_EX_HOMUNCULUS_CREATE_PROB_LIST();
			// End:0x4C
			break;
		// End:0x49
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_COUPON_PROB_LIST:
			Handle_S_EX_HOMUNCULUS_COUPON_PROB_LIST();
			// End:0x4C
			break;
	}
}

function Handle_S_EX_HOMUNCULUS_CREATE_PROB_LIST()
{
	local UIPacket._S_EX_HOMUNCULUS_CREATE_PROB_LIST packet;
	local HomunculusAPI.HomunculusNpcData npcData;
	local string NpcName, probabilityStr;
	local int i;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_HOMUNCULUS_CREATE_PROB_LIST(packet))
	{
		return;
	}
	Debug("Handle_S_EX_HOMUNCULUS_CREATE_PROB_LIST" @ string(packet.lstHomunculusProbList.Length));
	List_ListCtrl.DeleteAllItem();

	// End:0x14A [Loop If]
	for(i = 0; i < packet.lstHomunculusProbList.Length; i++)
	{
		npcData = class'HomunculusAPI'.static.GetHomunculusNpcData(packet.lstHomunculusProbList[i].nIndex);
		NpcName = class'UIDATA_NPC'.static.GetNPCName(npcData.NpcID);
		probabilityStr = getInstanceL2Util().CutFloatDecimalPlaces(float(packet.lstHomunculusProbList[i].nProbPerMillion) / float(1000000), 5, true);
		probabilityStr = getInstanceL2Util().CutFloatIntByString(probabilityStr);
		List_ListCtrl.InsertRecord(makeRecord(NpcName, probabilityStr));
	}
	Title_TextBox.SetText((GetSystemString(13555) $ "-") $ GetSystemString(13960));
	Me.ShowWindow();
	Me.SetFocus();
}

function Handle_S_EX_HOMUNCULUS_COUPON_PROB_LIST()
{
	local UIPacket._S_EX_HOMUNCULUS_COUPON_PROB_LIST packet;
	local HomunculusAPI.HomunculusNpcData npcData;
	local string NpcName, ItemName, probabilityStr;
	local int i;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_HOMUNCULUS_COUPON_PROB_LIST(packet))
	{
		return;
	}
	Debug("Handle_S_EX_HOMUNCULUS_COUPON_PROB_LIST" @ string(packet.lstHomunculusProbList.Length));
	Debug("nSlotItemClassID" @ string(packet.nSlotItemClassId));
	List_ListCtrl.DeleteAllItem();

	// End:0x170 [Loop If]
	for(i = 0; i < packet.lstHomunculusProbList.Length; i++)
	{
		npcData = class'HomunculusAPI'.static.GetHomunculusNpcData(packet.lstHomunculusProbList[i].nIndex);
		NpcName = class'UIDATA_NPC'.static.GetNPCName(npcData.NpcID);
		probabilityStr = getInstanceL2Util().CutFloatDecimalPlaces(float(packet.lstHomunculusProbList[i].nProbPerMillion) / float(1000000), 5, true);
		probabilityStr = getInstanceL2Util().CutFloatIntByString(probabilityStr);
		List_ListCtrl.InsertRecord(makeRecord(NpcName, probabilityStr));
	}
	ItemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(packet.nSlotItemClassId));
	Title_TextBox.SetText((ItemName $ "-") $ GetSystemString(13960));
	Me.ShowWindow();
	Me.SetFocus();
}

function RichListCtrlRowData makeRecord(string Name, string perStr)
{
	local RichListCtrlRowData RowData;

	RowData.cellDataList.Length = 2;
	addRichListCtrlString(RowData.cellDataList[0].drawitems, Name, GTColor().White, false, 0, 0);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, perStr, GTColor().White, false, 20, 0);
	return RowData;
}

function API_C_EX_REQ_HOMUNCULUS_PROB_LIST(int nType, optional int nSlotItemClassId)
{
	local array<byte> stream;
	local UIPacket._C_EX_REQ_HOMUNCULUS_PROB_LIST packet;

	packet.nType = nType;
	packet.nSlotItemClassId = nSlotItemClassId;
	Debug(("API_C_EX_REQ_HOMUNCULUS_PROB_LIST" @ string(nType)) @ string(nSlotItemClassId));
	// End:0x7B
	if(! class'UIPacket'.static.Encode_C_EX_REQ_HOMUNCULUS_PROB_LIST(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_REQ_HOMUNCULUS_PROB_LIST, stream);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
