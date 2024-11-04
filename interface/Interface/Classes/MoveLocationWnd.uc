//================================================================================
// MoveLocationWnd.
//================================================================================

class MoveLocationWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle Exclamation_Texture;
var TextBoxHandle Description_Text;
var TextureHandle GroupBox_Texture;
var TextureHandle GroupBox2_Texture;
var TextureHandle Divider_Texture;
var TextBoxHandle Count_Text;
var TextBoxHandle Location_Text;
var ButtonHandle Find_Btn;
var ItemWindowHandle CostItem_ItemWindow;
var TextureHandle CostItemSlotBg_Texture;
var TextBoxHandle CostItemTitle_Text;
var TextBoxHandle CostItemNumTitle_Text;
var ButtonHandle Teleport_Btn;
var ButtonHandle Cancel_Btn;
var SharedPositionData positionData;
var Vector XYZ;
var int SharedPositionID;

function OnRegisterEvent()
{
	RegisterEvent(EV_TextLinkLButtonClick);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_SHARED_POSITION_TELEPORT_UI);
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle("MoveLocationWnd");
	Exclamation_Texture = GetTextureHandle("MoveLocationWnd.Exclamation_Texture");
	Description_Text = GetTextBoxHandle("MoveLocationWnd.Description_Text");
	GroupBox_Texture = GetTextureHandle("MoveLocationWnd.GroupBox_Texture");
	GroupBox2_Texture = GetTextureHandle("MoveLocationWnd.GroupBox2_Texture");
	Divider_Texture = GetTextureHandle("MoveLocationWnd.Divider_Texture");
	Count_Text = GetTextBoxHandle("MoveLocationWnd.Count_Text");
	Location_Text = GetTextBoxHandle("MoveLocationWnd.Location_Text");
	Find_Btn = GetButtonHandle("MoveLocationWnd.Find_Btn");
	CostItem_ItemWindow = GetItemWindowHandle("MoveLocationWnd.CostItem_ItemWindow");
	CostItemSlotBg_Texture = GetTextureHandle("MoveLocationWnd.CostItemSlotBg_Texture");
	CostItemTitle_Text = GetTextBoxHandle("MoveLocationWnd.CostItemTitle_Text");
	CostItemNumTitle_Text = GetTextBoxHandle("MoveLocationWnd.CostItemNumTitle_Text");
	Teleport_Btn = GetButtonHandle("MoveLocationWnd.Teleport_Btn");
	Cancel_Btn = GetButtonHandle("MoveLocationWnd.Cancel_Btn");
}

function Load()
{
	SetClosingOnESC();
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_TextLinkLButtonClick:
			Debug("EV_TextLinkLButtonClick" @ param);
			ProcessTextLinkLButtonClick(param);
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_SHARED_POSITION_TELEPORT_UI):
			ParsePacket_S_EX_SHARED_POSITION_TELEPORT_UI();
			break;
	}
}

function ProcessTextLinkLButtonClick(string param)
{
	ParseInt(param, "SharedPositionID", SharedPositionID);
	if(SharedPositionID > 0)
	{
		API_C_EX_SHARED_POSITION_TELEPORT_UI(SharedPositionID);
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Find_Btn":
			OnFind_BtnClick();
			break;
		case "Teleport_Btn":
			API_C_EX_SHARED_POSITION_TELEPORT(SharedPositionID);
			Me.HideWindow();
			break;
		case "Cancel_Btn":
			Me.HideWindow();
			break;
	}
}

function OnFind_BtnClick()
{
	getInstanceL2Util().ShowGFxMiniMapSelectedPin(getInstanceL2Util().MapPinType.PIN_GREEN, XYZ, GetSystemString(13280), GetZoneNameWithLocation(XYZ));
}

function API_C_EX_SHARED_POSITION_TELEPORT_UI(int nID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SHARED_POSITION_TELEPORT_UI packet;

	packet.nID = nID;

	if(!class'UIPacket'.static.Encode_C_EX_SHARED_POSITION_TELEPORT_UI(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SHARED_POSITION_TELEPORT_UI, stream);
}

function API_C_EX_SHARED_POSITION_TELEPORT(int nID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SHARED_POSITION_TELEPORT_UI packet;

	packet.nID = nID;

	if(!class'UIPacket'.static.Encode_C_EX_SHARED_POSITION_TELEPORT_UI(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SHARED_POSITION_TELEPORT, stream);
}

function ParsePacket_S_EX_SHARED_POSITION_TELEPORT_UI()
{
	local UIPacket._S_EX_SHARED_POSITION_TELEPORT_UI packet;
	local string Msg;

	if(!class'UIPacket'.static.Decode_S_EX_SHARED_POSITION_TELEPORT_UI(packet))
	{
		return;
	}
	Teleport_Btn.DisableWindow();
	updateNeedItem(packet.nTeleportCostLCoin);
	Debug("-packet.sName" @ packet.sName);
	Debug("-packet.sName" @ string(packet.nID));
	Debug("-packet.sName" @ string(packet.nRemainedCount));
	Debug("x " @ string(packet.Position.X));
	Debug("Y " @ string(packet.Position.Y));
	Debug("Z " @ string(packet.Position.Z));
	XYZ.X = float(packet.Position.X);
	XYZ.Y = float(packet.Position.Y);
	XYZ.Z = float(packet.Position.Z);
	Me.ShowWindow();
	Me.SetFocus();
	Msg = MakeFullSystemMsg(GetSystemMessage(13168), packet.sName);
	Description_Text.SetText(Msg);

	if(getInstanceUIData().getIsClassicServer())
	{
		Count_Text.SetText(GetSystemString(13283) $ ": " $ string(packet.nRemainedCount) $ "/" $ "20");
	}
	else
	{
		Count_Text.SetText(GetSystemString(13283) $ ": " $ string(packet.nRemainedCount) $ "/" $ "5");
	}
	Location_Text.SetText(GetSystemString(13281) $ ": " $ GetZoneNameWithLocation(XYZ));
}

function updateNeedItem(INT64 nTeleportCostLCoin)
{
	local INT64 myLcoinCount;

	myLcoinCount = getInventoryItemNumByClassID(91663);
	CostItemTitle_Text.SetText(GetItemNameAll(GetItemInfoByClassID(91663)) $ " x" $ MakeCostStringINT64(nTeleportCostLCoin));
	CostItemNumTitle_Text.SetText("(" $ MakeCostStringINT64(myLcoinCount) $ ")");
	Debug("nTeleportCostLCoin" @ string(nTeleportCostLCoin));

	if(nTeleportCostLCoin <= myLcoinCount)
	{
		CostItemNumTitle_Text.SetTextColor(getInstanceL2Util().Blue);
		Teleport_Btn.EnableWindow();
	}
	else
	{
		CostItemNumTitle_Text.SetTextColor(getInstanceL2Util().DRed);
		Teleport_Btn.DisableWindow();
	}
	CostItem_ItemWindow.Clear();
	CostItem_ItemWindow.AddItem(GetItemInfoByClassID(91663));
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
