//================================================================================
// Emu-Dev.Ru
//================================================================================
class ColorNickNameWnd extends UICommonAPI;

const MAX_NICKNAME_LENGTH = 16;

var WindowHandle Me;
var WindowHandle TextInput;
var ButtonHandle Emoji_Btn;
var ButtonHandle btnOk;
var ButtonHandle btnCancel;
var UIControlTextInput uicontrolTextInputScr;
var WindowHandle EmojiIcon_Wnd;
var ItemWindowHandle EmojiIcon_ItemWnd;
var WindowHandle NickNameConfirm_Wnd;
var ComboBoxHandle ColorCombo;
var string m_WindowName;
var UserInfo myInfo;
var array<Color> ColorTable;
var array<Color> comboColorTable;
var array<int> ColorSystemStringTable;
var int nItemClassID;
var Color selectColor;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_CHANGE_NICKNAME_COLOR_ICON);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
}

function Initialize()
{
	m_WindowName = "ColorNickNameWnd";
	Me = GetWindowHandle("ColorNickNameWnd");
	TextInput = GetWindowHandle("ColorNickNameWnd.TextInput");
	Emoji_Btn = GetButtonHandle("ColorNickNameWnd.Emoji_Btn");
	btnOk = GetButtonHandle("ColorNickNameWnd.BtnOk");
	btnCancel = GetButtonHandle("ColorNickNameWnd.BtnCancel");
	EmojiIcon_Wnd = GetWindowHandle("ColorNickNameWnd.EmojiIcon_Wnd");
	EmojiIcon_ItemWnd = GetItemWindowHandle("ColorNickNameWnd.EmojiIcon_Wnd.EmojiIcon_ItemWnd");
	NickNameConfirm_Wnd = GetWindowHandle("ColorNickNameWnd.NickNameConfirm_Wnd");
	ColorCombo = GetComboBoxHandle("ColorNickNameWnd.ColorCombo");
	EmojiIcon_Wnd.HideWindow();
}

function askDialog(string nickNameStr)
{
	NickNameConfirm_Wnd.ShowWindow();
	NickNameConfirm_Wnd.SetFocus();
	GetTextBoxHandle("ColorNickNameWnd.NickNameConfirm_Wnd.NickNameConfirm_txt").SetFormatString(nickNameStr);
	GetTextBoxHandle("ColorNickNameWnd.NickNameConfirm_Wnd.NickNameConfirm_txt").SetTextColor(selectColor);
}

function Load()
{
	setColorIndex();
	uicontrolTextInputScr = class'UIControlTextInput'.static.InitScript(GetWindowHandle(m_WindowName $ ".TextInput"));
	uicontrolTextInputScr.SetMaxLength(16);
	uicontrolTextInputScr.SetDefaultString(GetSystemString(13810));
	uicontrolTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolTextInputScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	uicontrolTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	uicontrolTextInputScr.SetEdtiable(true);
}

function DelegateESCKey()
{
	Debug("DelegateESCKey");
	OnReceivedCloseUI();
}

function DelegateOnChangeEdited(string Text)
{
	Debug("DelegateOnCompleteEditBox: " @ Text);
}

function DelegateOnCompleteEditBox(string Text)
{
	Debug("DelegateOnCompleteEditBox: " @ Text);
}

function OnShow()
{
	NickNameConfirm_Wnd.HideWindow();
	btnOk.DisableWindow();

	if(getHasIcon())
	{
		Emoji_Btn.EnableWindow();
	}
	else
	{
		Emoji_Btn.DisableWindow();
	}
}

function bool getHasIcon()
{
	local NickNameItemData outItemdata;

	GetNickNameItemData(nItemClassID, outItemdata);

	if(outItemdata.Icon.Length > 0)
	{
		return true;
	}
	return false;
}

function OnHide()
{
	local Color initColor;

	selectColor = initColor;
	EmojiIcon_Wnd.HideWindow();
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Emoji_Btn":
			OnEmoji_BtnClick();
			break;
		case "BtnOk":
			if(NickNameConfirm_Wnd.IsShowWindow())
			{
				OnBtnOkClick();
			}
			else
			{
				askDialog(uicontrolTextInputScr.inputTextBox.GetFormatString());
			}
			break;
		case "BtnCancel":
			OnbtnCancelClick();
			break;
	}
}

function OnEmoji_BtnClick()
{
	local int i;
	local NickNameItemData outItemdata;
	local ItemInfo Info, emptyInfo;

	if(EmojiIcon_Wnd.IsShowWindow())
	{
		EmojiIcon_Wnd.HideWindow();
	}
	else
	{
		GetPlayerInfo(myInfo);
		EmojiIcon_Wnd.ShowWindow();
		EmojiIcon_ItemWnd.Clear();
		GetNickNameItemData(nItemClassID, outItemdata);

		for(i = 0; i < outItemdata.Icon.Length; i++)
		{
			if(myInfo.nLevel >= outItemdata.Icon[i].Min && myInfo.nLevel <= outItemdata.Icon[i].Max)
			{
				Info = emptyInfo;
				Info.ForeTexture = GetNickNameIconImage(outItemdata.Icon[i].Id);
				Info.Reserved = outItemdata.Icon[i].Id;
				EmojiIcon_ItemWnd.AddItem(Info);
			}
		}
	}
}

function OnBtnOkClick()
{
	local int i, selectColorIndex;

	for(i = 0; i < ColorTable.Length; i++)
	{
		if(selectColor == ColorTable[i])
		{
			selectColorIndex = i;
			break;
		}
	}

	API_C_EX_CHANGE_NICKNAME_COLOR_ICON(nItemClassID, selectColorIndex, uicontrolTextInputScr.inputTextBox.GetFormatString());
	Me.HideWindow();
}

function OnbtnCancelClick()
{
	if(NickNameConfirm_Wnd.IsShowWindow())
	{
		NickNameConfirm_Wnd.HideWindow();
	}
	else
	{
		Me.HideWindow();
	}
}

function OnClickItem(string strID, int Index)
{
	local ItemInfo Info;

	if("EmojiIcon_ItemWnd" == strID)
	{
		EmojiIcon_ItemWnd.GetItem(Index, Info);
		Debug("info.Reserved" @ string(Info.Reserved));
		uicontrolTextInputScr.AddEmojiIcon(Info.Reserved);
		uicontrolTextInputScr.inputTextBox.SetFocus();
		EmojiIcon_Wnd.HideWindow();
		Debug("uicontrolTextInputScr.inputTextBox." @ string(uicontrolTextInputScr.inputTextBox.IsEmpty()));
	}
}

function OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(class'UIPacket'.const.S_EX_CHANGE_NICKNAME_COLOR_ICON):
			ParsePacket_S_EX_CHANGE_NICKNAME_COLOR_ICON();
			break;
	}
}

function ParsePacket_S_EX_CHANGE_NICKNAME_COLOR_ICON()
{
	local UIPacket._S_EX_CHANGE_NICKNAME_COLOR_ICON packet;

	if(!class'UIPacket'.static.Decode_S_EX_CHANGE_NICKNAME_COLOR_ICON(packet))
	{
		return;
	}
	Debug(" -->  ParsePacket_S_EX_CHANGE_NICKNAME_COLOR_ICON :  " @ string(packet.nItemClassID));
	nItemClassID = packet.nItemClassID;
	OnOpenWnd();
	Me.ShowWindow();
	Me.SetFocus();
}

function OnOpenWnd()
{
	local NickNameItemData outItemdata;
	local int i;

	GetNickNameItemData(nItemClassID, outItemdata);
	Debug("outItemdata.Color.length" @ string(outItemdata.Color.Length));
	Debug("outItemdata.Icon.length" @ string(outItemdata.Icon.Length));
	GetPlayerInfo(myInfo);
	comboColorTable.Length = 0;
	ColorCombo.Clear();

	for(i = 0; i < outItemdata.Color.Length; i++)
	{
		if(myInfo.nLevel >= outItemdata.Color[i].Min && myInfo.nLevel <= outItemdata.Color[i].Max)
		{
			ColorCombo.AddStringWithColor(GetSystemString(ColorSystemStringTable[outItemdata.Color[i].Id]), ColorTable[outItemdata.Color[i].Id]);
			comboColorTable.Insert(comboColorTable.Length, 1);
			comboColorTable[comboColorTable.Length - 1] = ColorTable[outItemdata.Color[i].Id];
		}
	}
	Debug("ColorTable len: " @ string(ColorTable.Length) @ string(comboColorTable.Length));
	Debug("ColorSystemStringTable.Length" @ string(ColorSystemStringTable.Length));
	GetPlayerInfo(myInfo);
	uicontrolTextInputScr.Clear();
	uicontrolTextInputScr.inputTextBox.SetEnableTextLink(true);
	uicontrolTextInputScr.SetString("", true);
	EmojiIcon_Wnd.HideWindow();
}

function OnComboBoxItemSelected(string ComboboxName, int Index)
{
	Debug("ComboboxName" @ ComboboxName @ string(Index));
	selectColor = comboColorTable[Index];
	uicontrolTextInputScr.inputTextBox.SetFocus();
	btnOk.EnableWindow();
}

function API_C_EX_CHANGE_NICKNAME_COLOR_ICON(int nItemClassID, int nColorIndex, string sNickName)
{
	local array<byte> stream;
	local UIPacket._C_EX_CHANGE_NICKNAME_COLOR_ICON packet;

	packet.nItemClassID = nItemClassID;
	packet.nColorIndex = nColorIndex;
	packet.sNickName = sNickName;

	if(!class'UIPacket'.static.Encode_C_EX_CHANGE_NICKNAME_COLOR_ICON(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_CHANGE_NICKNAME_COLOR_ICON, stream);
	Debug("----> Api Call : C_EX_CHANGE_NICKNAME_COLOR_ICON " @ string(packet.nItemClassID) @ string(packet.nColorIndex) @ packet.sNickName);
}

function setColorIndex()
{
	if(ColorTable.Length > 0)
	{
		return;
	}
	ColorTable.Length = 17;
	ColorTable[0].A = 255;
	ColorTable[0].R = 162;
	ColorTable[0].G = 249;
	ColorTable[0].B = 236;
	ColorTable[1].A = 255;
	ColorTable[1].R = 240;
	ColorTable[1].G = 214;
	ColorTable[1].B = 54;
	ColorTable[2].A = 255;
	ColorTable[2].R = 255;
	ColorTable[2].G = 147;
	ColorTable[2].B = 147;
	ColorTable[3].A = 255;
	ColorTable[3].R = 255;
	ColorTable[3].G = 74;
	ColorTable[3].B = 125;
	ColorTable[4].A = 255;
	ColorTable[4].R = 255;
	ColorTable[4].G = 251;
	ColorTable[4].B = 153;
	ColorTable[5].A = 255;
	ColorTable[5].R = 240;
	ColorTable[5].G = 155;
	ColorTable[5].B = 253;
	ColorTable[6].A = 255;
	ColorTable[6].R = 147;
	ColorTable[6].G = 93;
	ColorTable[6].B = 255;
	ColorTable[7].A = 255;
	ColorTable[7].R = 162;
	ColorTable[7].G = 255;
	ColorTable[7].B = 0;
	ColorTable[8].A = 255;
	ColorTable[8].R = 0;
	ColorTable[8].G = 170;
	ColorTable[8].B = 164;
	ColorTable[9].A = 255;
	ColorTable[9].R = 175;
	ColorTable[9].G = 152;
	ColorTable[9].B = 120;
	ColorTable[10].A = 255;
	ColorTable[10].R = 158;
	ColorTable[10].G = 103;
	ColorTable[10].B = 75;
	ColorTable[11].A = 255;
	ColorTable[11].R = 155;
	ColorTable[11].G = 155;
	ColorTable[11].B = 155;
	ColorTable[12].A = 255;
	ColorTable[12].R = 255;
	ColorTable[12].G = 204;
	ColorTable[12].B = 0;
	ColorTable[13].A = 255;
	ColorTable[13].R = 255;
	ColorTable[13].G = 160;
	ColorTable[13].B = 32;
	ColorTable[14].A = 255;
	ColorTable[14].R = 255;
	ColorTable[14].G = 104;
	ColorTable[14].B = 255;
	ColorTable[15].A = 255;
	ColorTable[15].R = 255;
	ColorTable[15].G = 0;
	ColorTable[15].B = 0;
	ColorTable[16].A = 255;
	ColorTable[16].R = 0;
	ColorTable[16].G = 220;
	ColorTable[16].B = 255;
	ColorSystemStringTable.Length = 0;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 1750;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 1750;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 1751;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 1752;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 1753;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 1754;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 1755;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 1756;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 1757;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 1758;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 1759;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 1760;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 3402;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 3403;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 3404;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 3405;
	ColorSystemStringTable[ColorSystemStringTable.Length] = 13514;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("ColorNickNameWnd").HideWindow();
}

defaultproperties
{
}
