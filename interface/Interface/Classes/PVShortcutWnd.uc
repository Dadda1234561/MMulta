class PVShortcutWnd extends UICommonAPI;



/************************************************************************/
/*                    ShortcutWnd For PawnViewer                        */
/************************************************************************/
/*

PV.ini 파일에 아래와 같이 저장을 해둠

드래그 앤 드롭하면 알아서 정보가 들어간다. 
Command를 넣고 싶다면 따로 아래와 같이 PV.ini 파일에 Name 에  Command를 넣어주셔도 됩니다.

[Shortcut11]
ClassID=0
ItemType=0
ShortcutType=4
Level=0
SubLevel=0
Name=///stat fps
IconName=
IconPanel=
Description=///stat fps
AdditionalName=

ItemType과 ShortcutType은 UIEventManager.uc 파일의 EItemType, EShortCutItemType 참고

*/

const SHORTCUT_SLOT_MAX = 12; 

var WindowHandle Me;

var ItemInfo		m_ShortcutItemInfo[SHORTCUT_SLOT_MAX];
var string			INIFilename;

struct ShortcutInfo
{
	var string Command;
	var string Name;
	var string IconTexName;
};

var string m_WindowName;
var string defaultTextureName;
var ShortcutInfo m_ShortcutInfo[12];

function OnRegisterEvent()
{
	RegisterEvent(EV_ShortcutCommandSlot);
	RegisterEvent(EV_ShortcutUpdate);
	RegisterEvent(EV_PawnViewerWndShortcutSave);
}

function onShow()
{
	LoadShortcutData();
}

function OnLoad()
{
	INIFilename = "PV.ini";
	InitializeHandle(); 
}

function InitializeHandle()
{
	Me = GetWindowHandle(m_WindowName);
}

function OnEvent(int a_EventID, String a_Param)
{
	switch (a_EventID)
	{
		case EV_ShortcutCommandSlot:
			ExecuteShortcutCommandBySlot(a_Param);
			break;
		case EV_ShortcutUpdate:
			HandleShortcutUpdate(a_Param);
			break;
		case EV_PawnViewerWndShortcutSave:
			HandleShortcutSave(a_Param);
			break;
		default:
			break;
	}
}

function HandleShortcutUpdate(string param)
{
	local int nShortcutID;
	local int nShortcutNum;
	
	ParseInt(param, "ShortcutID", nShortcutID);
	nShortcutNum = (nShortcutID % SHORTCUT_SLOT_MAX) + 1;
	class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(m_WindowName $ ".Shortcut" $ nShortcutNum, nShortcutID);
}

function HandleShortcutSave(string param)
{
	local int nShortcutID;
	local ItemInfo info;

	ParseInt(param, "ShortcutID", nShortcutID);

	if (class'UIAPI_SHORTCUTITEMWINDOW'.static.GetShortcutItem(info, nShortcutID))
	{
		SetShortcutData(info, nShortcutID);
	}
	else
	{
		RemoveShortcutData(nShortcutID);
	}

	SaveShortcutData();
}

function LoadShortcutData()
{
	local string Category;

	local ItemInfo info;
	
	local int ClassID;
	local int ItemType;
	local int ShortcutType;
	local int Level;
	local int SubLevel;
	local string Name;
	local string IconName;
	local string IconPanel;
	local string Description;
	local string AdditionalName;

	local int ShortcutID;
	local int ShortcutNum;

	for (ShortcutID = 0; ShortcutID < SHORTCUT_SLOT_MAX; ++ShortcutID)
	{
		Category = "Shortcut" $(ShortcutID);

		if (!GetINIInt(Category, "ClassID", ClassID, INIFilename))
		{
			ShortcutNum = (ShortcutID % SHORTCUT_SLOT_MAX) + 1;

			// 비어있는 숏컷이라도 UpdateShortcut 함수를 불러 세팅은 해놓아야 한다. - ShorcutWnd는 그렇게 하고 있음.
			// ShortcutID를 설정하기 위함
			class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(m_WindowName $ ".Shortcut" $ ShortcutNum, ShortcutID);
			continue;
		}

		GetINIInt(Category, "ClassID", ClassID, INIFilename);
		GetINIInt(Category, "ItemType", ItemType, INIFilename);
		GetINIInt(Category, "ShortcutType", ShortcutType, INIFilename);
		GetINIInt(Category, "Level", Level, INIFilename);
		GetINIInt(Category, "SubLevel", SubLevel, INIFilename);
		GetINIString(Category, "Name", Name, INIFilename);
		GetINIString(Category, "IconName", IconName, INIFilename);
		GetINIString(Category, "IconPanel", IconPanel, INIFilename);
		GetINIString(Category, "Description", Description, INIFilename);
		GetINIString(Category, "AdditionalName", AdditionalName, INIFilename);

		info.ID.ClassId = ClassId;
		info.ItemType = ItemType;
		info.ShortcutType = ShortcutType;
		info.Level = Level;
		info.SubLevel = SubLevel;
		info.Name = Name;
		info.IconName = IconName;
		info.IconPanel = IconPanel;
		info.Description = Description;
		info.AdditionalName = AdditionalName;
		info.Reserved = ShortcutID;

		m_ShortcutItemInfo[ShortcutID] = info;

		class'UIAPI_SHORTCUTITEMWINDOW'.static.AddShortcutItem(info, ShortcutID);
		class'UIAPI_SHORTCUTITEMWINDOW'.static.AddShortcutItem(info, ShortcutID);

	}
}

function SetShortcutData(ItemInfo info, int ShortcutID)
{
	local string Category;

	Category = "Shortcut" $(ShortcutID);
	SetINIInt(Category, "ClassID", info.ID.ClassId, INIFilename);
	SetINIInt(Category, "ItemType", info.ItemType, INIFilename);
	SetINIInt(Category, "ShortcutType", info.ShortcutType, INIFilename);
	SetINIInt(Category, "Level", info.Level, INIFilename);
	SetINIInt(Category, "SubLevel", info.SubLevel, INIFilename);
	SetINIString(Category, "Name", info.Name, INIFilename);
	SetINIString(Category, "IconName", info.IconName, INIFilename);
	SetINIString(Category, "IconPanel", info.IconPanel, INIFilename);
	SetINIString(Category, "Description", info.Description, INIFilename);
	SetINIString(Category, "AdditionalName", info.AdditionalName, INIFilename);

	m_ShortcutItemInfo[ShortcutID] = info;
}

function RemoveShortcutData(int ShortcutID)
{
	local string Category;

	Category = "Shortcut" $(ShortcutID);

	RemoveINI(Category, "ClassID", INIFilename);
	RemoveINI(Category, "ItemType", INIFilename);
	RemoveINI(Category, "ShortcutType", INIFilename);
	RemoveINI(Category, "Level", INIFilename);
	RemoveINI(Category, "SubLevel", INIFilename);
	RemoveINI(Category, "Name", INIFilename);
	RemoveINI(Category, "IconName", INIFilename);
	RemoveINI(Category, "IconPanel", INIFilename);
	RemoveINI(Category, "Description", INIFilename);
	RemoveINI(Category, "AdditionalName", INIFilename);

	m_ShortcutItemInfo[ShortcutID].ID.ClassId = 0;
	m_ShortcutItemInfo[ShortcutID].ItemType = 0;
	m_ShortcutItemInfo[ShortcutID].ShortcutType = 0;
	m_ShortcutItemInfo[ShortcutID].Level = 0;
	m_ShortcutItemInfo[ShortcutID].SubLevel = 0;
	m_ShortcutItemInfo[ShortcutID].Name = "";
	m_ShortcutItemInfo[ShortcutID].IconName = "";
	m_ShortcutItemInfo[ShortcutID].IconPanel = "";
	m_ShortcutItemInfo[ShortcutID].Description = "";
	m_ShortcutItemInfo[ShortcutID].AdditionalName = "";
}

function SaveShortcutData()
{
	SaveINI(INIFilename);
}
 
// 기본 동작 구현
// ---------------------------------------------------------
// 컨텐츠 부분

// 클릭을 했을 때
function OnClickButton(string a_strID)
{
	local int ShortcutID;
	local string ButtonName;

	for (ShortcutID = 0; ShortcutID < SHORTCUT_SLOT_MAX; ++ShortcutID)
	{
		ButtonName = "Shortcut" $(ShortcutID + 1);

		if (ButtonName == a_strID)
		{
			UseShortcut(ShortcutID);
		}
	}
}

// Alt + 0~9 키를 눌러 shortcut을 사용하고 싶을 때 
// Shortcut.xml 의 PawnViewerStateDefaultShortcut 부분을 참고
// PawnViewerShortcut 0 ~ PawnViewerShortcut 11 까지가 명령
function ExecuteShortcutCommandBySlot(string param)
{
	local int ShortcutID;

	ParseInt(param, "Slot", ShortcutID);

	if (ShortcutID >= SHORTCUT_SLOT_MAX || ShortcutID < 0)
		return;

	if (Me.isShowwindow())
	{
		UseShortcut(ShortcutID);
	}
}

function UseShortcut(int ShortcutID)
{
	local ItemInfo info;

	info = m_ShortcutItemInfo[ShortcutID];
	
	if (info.ShortcutType == int(EShortCutItemType.SCIT_ITEM))
	{
		if (info.ID.ClassID <= 0)
		{
			return;
		}
		class'UIDATA_PAWNVIEWER'.static.EquipPCItem(info.Id);
	}
	else if (info.ShortcutType == int(EShortCutItemType.SCIT_SKILL))
	{
		if (info.Level <= 0)
		{
			return;
		}
		class'UIDATA_PAWNVIEWER'.static.ExecuteSkill(info.ID.ClassID, info.Level, info.SubLevel);
		// 4번째 optional 파라미터: multi target 을 사용할 것인지 체크
	}
	else if (info.ShortcutType == int(EShortCutItemType.SCIT_MACRO))
	{
		ExecuteCommand(info.Name);
	}
}

defaultproperties
{
     m_WindowName="PVShortcutWnd"
     defaultTextureName="l2ui_ct1.ItemWindow_DF_SlotBox_2x2"
}
