class PartyMatchMakeRoomWnd extends UICommonAPI;

enum InviteStateType
{
	// »х·Оїо №жА» ёёµл
	MAKEROOM,
	// ЖДЖјёЕДЄ ґл°ЎБц ёс·П PartyMatchOutWaitListWnd їЎј­ ЖДЕё№жГКґл Е¬ёЇ ЅГ
	INVITE_MAKEROOM, 
	// №ж јјЖГ єЇ°ж
	SETTINGCHANGE
};

var InviteStateType InviteState;
var int RoomNumber;
var string InvitedName;
var EditBoxHandle MinLevelEditBox;
var EditBoxHandle MaxLevelEditBox;

function OnLoad()
{
	MinLevelEditBox = GetEditBoxHandle("PartyMatchMakeRoomWnd.MinLevelEditBox");
	MaxLevelEditBox = GetEditBoxHandle("PartyMatchMakeRoomWnd.MaxLevelEditBox");
}

function OnShow()
{
	switch(InviteState)
	{
		// »х·Оїо ЖДЖј№жА» »эјєЗХґПґЩ.
		case MAKEROOM:
			class'UIAPI_TEXTBOX'.static.SetText("PartyMatchMakeRoomWnd.TitletoDo", GetSystemString(1457));
			break;
		// »х·Оїо ЖДЖј№жА» »эјєЗП°н »уґл№жА» ГКГ»ЗХґПґЩ.
		case INVITE_MAKEROOM:
			class'UIAPI_TEXTBOX'.static.SetText("PartyMatchMakeRoomWnd.TitletoDo", GetSystemString(1458));
			break;
		// №ж јіБ¤А» єЇ°ж ЗХґПґЩ.
		case SETTINGCHANGE:
			class'UIAPI_TEXTBOX'.static.SetText("PartyMatchMakeRoomWnd.TitletoDo", GetSystemString(1460));
			// End:0xD3
			break;
	}
}

function OnClickButton(string a_strButtonName)
{
	switch(a_strButtonName)
	{
		// End:0x1D
		case "OKButton":
			OnOKButtonClick();
			// End:0x3A
			break;
		// End:0x37
		case "CancelButton":
			OnCancelButtonClick();
			break;
	}
}

function OnOKButtonClick()
{
	local int MaxPartyMemberCount;
	local int MinLevel;
	local int MaxLevel;
	local String RoomTitle;		
	
	// ЗҐ±в : Е¬·ЎЅДАє ГЦґл ·№є§, ¶уАМєкґВ ГЦґл ·№є§ АМ»уАє 199·О ЗҐ±в ЗФ.
	if(getInstanceUIData().getIsClassicServer())
	{
		MaxLevel = getInstanceUIData().MAXLV;
	} else 
	{
		MaxLevel = getInstanceUIData().MAXLV2DISPLAY;
	}

	MinLevel = Clamp(int(class'UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MinLevelEditBox")), 1, MaxLevel);
	MaxLevel = Clamp(int(class'UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MaxLevelEditBox")), 1, MaxLevel);
	class'UIAPI_EDITBOX'.static.SetString("PartyMatchMakeRoomWnd.MinLevelEditBox", String(MinLevel));
	class'UIAPI_EDITBOX'.static.SetString("PartyMatchMakeRoomWnd.MaxLevelEditBox", String(MaxLevel));
	// °іјі : ГЦґл ·№є§ АМ»уАО °жїм ГЦґл ·№є§·О №жА» °іјі
	MaxLevel = getInstanceUIData().MAXLV;
	RoomTitle = class'UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.TitleEditBox");
	MaxPartyMemberCount = class'UIAPI_COMBOBOX'.static.GetSelectedNum("PartyMatchMakeRoomWnd.MaxPartyMemberCountComboBox")+ 2;
	MinLevel = Clamp(int(class'UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MinLevelEditBox")), 1, MaxLevel);
	MaxLevel = Clamp(int(class'UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MaxLevelEditBox")), 1, MaxLevel);

	class'PartyMatchAPI'.static.RequestManagePartyRoom(RoomNumber, MaxPartyMemberCount, MinLevel, MaxLevel, RoomTitle);

	class'UIAPI_WINDOW'.static.HideWindow("PartyMatchMakeRoomWnd");
	if(InviteState == INVITE_MAKEROOM)
	{
		Debug("방 만든 뒤 초대하기 INVITE_MAKEROOM");
		class'PartyMatchAPI'.static.RequestAskJoinPartyRoom(InvitedName);
		InviteState = MAKEROOM;
	} 
}

function OnCancelButtonClick()
{
	class'UIAPI_WINDOW'.static.HideWindow("PartyMatchMakeRoomWnd");
	if(InviteState == INVITE_MAKEROOM)
	{
		InviteState = MAKEROOM;
	}

}

function SetRoomNumber(int a_RoomNumber)
{
	RoomNumber = a_RoomNumber;
}

function SetTitle(String a_Title)
{
	class'UIAPI_EDITBOX'.static.SetString("PartyMatchMakeRoomWnd.TitleEditBox", a_Title);
}

function SetMinLevel(int a_MinLevel)
{
	//debug("PartyMatchMakeRoomWnd.SetMinLevel " $ a_MinLevel);
	MinLevelEditBox.SetString(string(a_MinLevel));
	//class'UIAPI_EDITBOX'.static.SetString("PartyMatchMakeRoomWnd.MinLevelEditBox", string(a_MinLevel));
}

function SetMaxLevel(int a_MaxLevel)
{
	MaxLevelEditBox.SetString(string(a_MaxLevel));
	//class'UIAPI_EDITBOX'.static.SetString("PartyMatchMakeRoomWnd.MaxLevelEditBox", string(a_MaxLevel));
}

function SetMaxPartyMemberCount(int a_MaxPartyMemberCount)
{
	class'UIAPI_COMBOBOX'.static.SetSelectedNum("PartyMatchMakeRoomWnd.MaxPartyMemberCountComboBox", a_MaxPartyMemberCount - 2);
}

defaultproperties
{
}
