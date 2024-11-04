class LocationShareWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle ConfirmWnd;
var WindowHandle ConfirmInnerWnd;
var TextBoxHandle Location_Text;
var TabHandle Tab_Ctrl;
var TextureHandle Language_Texture;
var EditBoxHandle Chat_EditBox;
var ItemWindowHandle CostItem_ItemWindow;
var TextBoxHandle CostItemTitle_Text;
var TextBoxHandle CostItemNumTitle_Text;
var UIControlBasicDialog askDialogScript;
var ChatWnd chatWndScript;
var int zoneID;
var SharedPositionData positionData;
var string ChatMsg;
var INT64 nSharingCostLCoin;

function OnRegisterEvent()
{
	RegisterEvent(EV_SharedPositionAction);
	RegisterEvent(EV_IMEStatusChange);
	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_BeginShowZoneTitleWnd);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_SHARED_POSITION_SHARING_UI);
	RegisterEvent(EV_Restart);
}

function OnLoad()
{
	Initialize();
	Load();
	SetScript_UIControlBaseDialog();
}

function OnShow()
{
	Chat_EditBox.SetString("");
	ChatMsg = "";
	Language_Texture.SetTexture(getIMEStatusTexture());
	updateNeedItem();
	updateZoneName();
	Chat_EditBox.SetFocus();
}

function updateZoneName()
{
	local string zoneName;

	zoneName = GetCurrentZoneName();
	Location_Text.SetText(GetSystemString(13280) $ ": " $ zoneName);
}

function Initialize()
{
	Me = GetWindowHandle("LocationShareWnd");
	ConfirmWnd = GetWindowHandle("LocationShareWnd.ConfirmWnd");
	ConfirmInnerWnd = GetWindowHandle("LocationShareWnd.ConfirmWnd.ConfirmInnerWnd");
	Tab_Ctrl = GetTabHandle("LocationShareWnd.Tab_Ctrl");
	Location_Text = GetTextBoxHandle("LocationShareWnd.Location_Text");
	Language_Texture = GetTextureHandle("LocationShareWnd.InnerWnd.Language_Texture");
	Chat_EditBox = GetEditBoxHandle("LocationShareWnd.InnerWnd.Chat_EditBox");
	CostItem_ItemWindow = GetItemWindowHandle("LocationShareWnd.InnerWnd.CostItem_ItemWindow");
	CostItemTitle_Text = GetTextBoxHandle("LocationShareWnd.InnerWnd.CostItemTitle_Text");
	CostItemNumTitle_Text = GetTextBoxHandle("LocationShareWnd.InnerWnd.CostItemNumTitle_Text");
	chatWndScript = ChatWnd(GetScript("ChatWnd"));
}

function Load()
{
	SetClosingOnESC();
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "WindowHelp_BTN":
			ExecuteEvent(EV_ShowHelp, "52");
			break;
		case "ChatFilter_Btn":
			OnChatFilter_BtnClick();
			break;
		case "LocationShare_Btn":
			OnLocationShare_BtnClick();
			break;
		case "Cancel_Btn":
			Me.HideWindow();
			break;
	}
}

function OnChatFilter_BtnClick()
{
	CallGFxFunction("OptionWnd", "showChattingOption", "");
}

function OnHide()
{
	ConfirmInnerWnd.HideWindow();
	ConfirmWnd.HideWindow();
}

function OnLocationShare_BtnClick()
{
	local string chatTypeString, Msg;

	Msg = Chat_EditBox.GetString();

	if(trim(Msg) == "")
	{
		ChatMsg = GetSystemString(13281);
	}
	else
	{
		ChatMsg = Msg;
		Chat_EditBox.AddNameToAdditionalSearchList(ChatMsg, ESearchListType.SLT_ADDITIONAL_LIST);
	}
	switch(Left(trim(Msg), 1))
	{
		case "+":
		case "#":
		case "@":
		case "$":
		case "`":
		case Chr(37):
		case "!":
		case "\"":
		case "&":
			AddSystemMessage(13185);
			return;
		case "/":
			AddSystemMessage(13187);
			return;
	}
	if(Tab_Ctrl.GetTopIndex() == 0)
	{
		chatTypeString = GetSystemString(3234);
	}
	else
	{
		chatTypeString = chatWndScript.GetSystemStringByChatType(chatWndScript.GetCurrentChatTypeID(Tab_Ctrl.GetTopIndex() - 1));
	}
	GetSharedPositionData(positionData);
	askDialogScript.setInit(MakeFullSystemMsg(GetSystemMessage(13167), chatTypeString, string(nSharingCostLCoin)));
	ConfirmWnd.ShowWindow();
	ConfirmInnerWnd.ShowWindow();
}

function OnEvent(int Event_ID, string param)
{
	local int nUseSharedPos;

	switch(Event_ID)
	{
		case EV_SharedPositionAction:
			nUseSharedPos = 0;

			if(IsAdenServer())
			{
				GetINIBool("Localize", "UseDisableSharedPositionAden", nUseSharedPos, "L2.ini");				
			}
			else
			{
				if(getInstanceUIData().getIsClassicServer())
				{
					GetINIBool("Localize", "UseDisableSharedPositionClassic", nUseSharedPos, "L2.ini");
				}
			}
			if(nUseSharedPos < 1)
			{
				API_C_EX_SHARED_POSITION_SHARING_UI();
				toggleWindow("LocationShareWnd", true, true);
			}
			break;
		case EV_IMEStatusChange:
			Language_Texture.SetTexture(getIMEStatusTexture());
			break;
		case EV_AdenaInvenCount:
			updateNeedItem();
			break;
		case EV_BeginShowZoneTitleWnd:
			updateZoneName();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_SHARED_POSITION_SHARING_UI):
			ParsePacket_S_EX_SHARED_POSITION_SHARING_UI();
			updateNeedItem();
			break;
		case EV_Restart:
			Chat_EditBox.ClearAdditionalSearchList(ESearchListType.SLT_ADDITIONAL_LIST);
			break;
	}
}

function ParsePacket_S_EX_SHARED_POSITION_SHARING_UI()
{
	local UIPacket._S_EX_SHARED_POSITION_SHARING_UI packet;

	if(!class'UIPacket'.static.Decode_S_EX_SHARED_POSITION_SHARING_UI(packet))
	{
		return;
	}
	Debug("ParsePacket_S_EX_SHARED_POSITION_SHARING_UI" @ string(packet.nSharingCostLCoin));
	nSharingCostLCoin = packet.nSharingCostLCoin;
}

function updateNeedItem()
{
	local INT64 myLcoinCount;

	if(!Me.IsShowWindow())
	{
		return;
	}
	GetSharedPositionData(positionData);
	myLcoinCount = getInventoryItemNumByClassID(91663);
	CostItemTitle_Text.SetText(GetItemNameAll(GetItemInfoByClassID(91663)) $ " x" $ MakeCostStringINT64(nSharingCostLCoin));
	CostItemNumTitle_Text.SetText("(" $ MakeCostStringINT64(myLcoinCount) $ ")");

	if(nSharingCostLCoin <= myLcoinCount)
	{
		CostItemNumTitle_Text.SetTextColor(getInstanceL2Util().Blue);
	}
	else
	{
		CostItemNumTitle_Text.SetTextColor(getInstanceL2Util().DRed);
	}
	CostItem_ItemWindow.Clear();
	CostItem_ItemWindow.AddItem(GetItemInfoByClassID(91663));
}

function string getIMEStatusTexture()
{
	local string Texture;
	local EIMEType imeType;

	imeType = GetCurrentIMELang();

	switch(imeType)
	{
		case IME_KOR:
			Texture = "L2UI_CH3.ChatWnd.Chatting_IMEkr";
			break;
		case IME_ENG:
			Texture = "L2UI_CH3.ChatWnd.Chatting_IMEen";
			break;
		case IME_JPN:
			Texture = "L2UI_CH3.ChatWnd.Chatting_IMEjp";
			break;
		case IME_CHN:
			Texture = "L2UI_CH3.ChatWnd.Chatting_IMEjp";
			break;
		case IME_TAIWAN_CHANGJIE:
			Texture = "L2UI.ChatWnd.IME_tw2";
			break;
		case IME_TAIWAN_DAYI:
			Texture = "L2UI.ChatWnd.IME_tw3";
			break;
		case IME_TAIWAN_NEWPHONETIC:
			Texture = "L2UI.ChatWnd.IME_tw1";
			break;
		case IME_CHN_MS:
			Texture = "L2UI.ChatWnd.IME_cn1";
			break;
		case IME_CHN_JB:
			Texture = "L2UI.ChatWnd.IME_cn2";
			break;
		case IME_CHN_ABC:
			Texture = "L2UI.ChatWnd.IME_cn3";
			break;
		case IME_CHN_WUBI:
			Texture = "L2UI.ChatWnd.IME_cn4";
			break;
		case IME_CHN_WUBI2:
			Texture = "L2UI.ChatWnd.IME_cn4";
			break;
		case IME_THAI:
			Texture = "L2UI.ChatWnd.IME_th";
			break;
		case IME_RUSSIA:
			Texture = "BranchSys.symbol.IME_ru";
			break;

		default:
			Texture = "L2UI_CH3.ChatWnd.Chatting_IMEen";
			break;
	}
	return Texture;
}

function OnClickHideDialog(optional int nDialogKey)
{
	ConfirmInnerWnd.SetFocus();
	ConfirmInnerWnd.HideWindow();
	ConfirmWnd.HideWindow();
	ConfirmWnd.SetFocus();
}

function OnClickOkDialog(optional int nDialogKey)
{
	ConfirmInnerWnd.HideWindow();
	ConfirmWnd.HideWindow();

	if(trim(ChatMsg) != "")
	{
		if(Tab_Ctrl.GetTopIndex() == 0)
		{
			Debug("SPT_WORLD");
			ProcessChatMessage(ChatMsg, SayPacketType.SPT_WORLD, false, true);
		}
		else
		{
			ProcessChatMessage(ChatMsg, chatWndScript.GetChatTypeByType(chatWndScript.GetCurrentChatTypeID(Tab_Ctrl.GetTopIndex() - 1)), false, true);
		}
		Me.HideWindow();
	}
}

function SetScript_UIControlBaseDialog()
{
	ConfirmInnerWnd.SetScript("UIControlBasicDialog");
	askDialogScript = UIControlBasicDialog(ConfirmInnerWnd.GetScript());
	askDialogScript.SetWindow("LocationShareWnd.ConfirmWnd.ConfirmInnerWnd");
	askDialogScript.DelegateOnClickCancleButton = OnClickHideDialog;
	askDialogScript.DelegateOnClickOkButton = OnClickOkDialog;
}

function OnKeyDown(WindowHandle a_WindowHandle, EInputKey nKey)
{
	local string mainKey;

	if(Chat_EditBox.IsFocused() && Me.IsShowWindow())
	{
		mainKey = class'InputAPI'.static.GetKeyString(nKey);

		if(mainKey == "ENTER")
		{
			OnLocationShare_BtnClick();
		}
	}
}

function API_C_EX_SHARED_POSITION_SHARING_UI()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SHARED_POSITION_SHARING_UI, stream);
	Debug("----> Api Call : C_EX_SHARED_POSITION_SHARING_UI");
}

function OnReceivedCloseUI()
{
	if(ConfirmWnd.IsShowWindow())
	{
		ConfirmWnd.HideWindow();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
}

defaultproperties
{
}
