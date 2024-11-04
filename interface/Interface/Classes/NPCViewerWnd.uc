class NPCViewerWnd extends UICommonAPI;

enum ESearchMode
{
	Search_NPC_NameID,
	Search_NPC_Class,
	Search_NPC_Mesh
};

enum EShowMode
{
	Show_NPC_NameID,
	Show_NPC_Class,
	Show_NPC_Mesh
};

var string m_WindowName;

var WindowHandle		m_hWnd;

var ComboBoxHandle		m_ComboAnimation;

var ListBoxHandle		m_ListBoxNPC;
var RadioButtonHandle	m_RadioButtonNameID;
var RadioButtonHandle	m_RadioButtonMesh;
var RadioButtonHandle	m_RadioButtonClass;
var ListBoxHandle		m_TextNPCMeshTexture;
var EditBoxHandle		m_EditBoxSearchNPC;
var ButtonHandle		m_ButtonSearchNPC;
var ButtonHandle		m_ButtonDuplicateNPC;

var EditBoxHandle		m_EditBoxSpeed;
var EditBoxHandle		m_EditBoxAnimRate;
var EditBoxHandle		m_EditBoxRadius;
var EditBoxHandle		m_EditBoxHeight;
var EditBoxHandle		m_EditBoxScale;
var EditBoxHandle		m_EditBoxState;
var CheckBoxHandle		m_CheckBoxCollisionAutoCalc;

var ItemWindowHandle	m_ItemWindowNpcItem;
var EditBoxHandle		m_EditBoxSearchItem;
var ButtonHandle		m_ButtonSearchItem;

var float defaultCollisionRadius;
var float defaultCollisionHeight;

var int SelectedID;
var string NpcSearch;

var float GroundSpeed;
var float AnimRate;
var float CollisionRadius;
var float CollisionHeight;
var float DrawScale;
var int PawnState;

var ESearchMode SearchMode;
var array<int> NpcIdList;

/*
함수
function OnLoad()
function OnShow()
function InitializeHandle()
function OnDBClickListBoxItem(String strID, int SelectedIndex)
function OnLButtonClickListBoxItem(String strID, int SelectedIndex)
function OnDBClickItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
function OnRClickItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
function OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
function OnComboBoxItemSelected(String strID, int index)
function OnClickCheckBox( string strID)
function OnClickButton( string strID )

function SetAnimList()
function HandleNPCData()
function HandleNPCSpawn()
function SearchNPC(string strSearch)
function SearchItem(string strSearch)
function ApplyPawnSetting()
function ApplyAutoCalcCollisionScale()
*/

function OnRegisterEvent()
{
	registerEvent(EV_NPCViewerWndReload);
}

function OnLoad()
{
	InitializeHandle();
	m_hWnd.SetWindowTitle("NPC VIEWER");

	SelectedID = 0;
	NpcSearch = "";
	GroundSpeed = 0.f;
	AnimRate = 0.f;
	CollisionRadius = 0.f;
	CollisionHeight = 0.f;
	DrawScale = 0.f;
	PawnState = 0;
}

function OnShow()
{
	SearchNPC("");
	SetAnimList();
	m_hWnd.ShowWindow();
}

function InitializeHandle()
{
	m_hWnd = GetWindowHandle(m_WindowName);
	m_ComboAnimation = GetComboBoxHandle(m_WindowName $ ".Anim_ComboBox");
	m_RadioButtonNameID = GetRadioButtonHandle(m_WindowName $ ".NameID_RadioButton");
	m_RadioButtonMesh = GetRadioButtonHandle(m_WindowName $ ".Mesh_RadioButton");
	m_RadioButtonClass = GetRadioButtonHandle(m_WindowName $ ".Class_RadioButton");
	m_ListBoxNPC = GetListBoxHandle(m_WindowName $ ".Npc_ListBox");
	m_TextNPCMeshTexture = GetListBoxHandle(m_WindowName $ ".Path_ListBox");
	m_EditBoxSearchNPC = GetEditBoxHandle(m_WindowName $ ".NpcSearch_EditBox");
	m_ButtonSearchNPC = GetButtonHandle(m_WindowName $ ".Button_NpcSearch");
	m_ButtonDuplicateNPC = GetButtonHandle(m_WindowName $ ".Button_Duplicate");
	m_EditBoxSpeed = GetEditBoxHandle(m_WindowName $ ".Speed_EditBox");
	m_EditBoxAnimRate = GetEditBoxHandle(m_WindowName $ ".Rate_EditBox");
	m_EditBoxRadius = GetEditBoxHandle(m_WindowName $ ".Radius_EditBox");
	m_EditBoxHeight = GetEditBoxHandle(m_WindowName $ ".Height_EditBox");
	m_EditBoxScale = GetEditBoxHandle(m_WindowName $ ".Scale_EditBox");
	m_EditBoxState = GetEditBoxHandle(m_WindowName $ ".State_EditBox");
	m_CheckBoxCollisionAutoCalc = GetCheckBoxHandle(m_WindowName $ ".CB_AutoCalculate");
	m_ItemWindowNpcItem = GetItemWindowHandle(m_WindowName $ ".IconList_ItemWindow");
	m_EditBoxSearchItem = GetEditBoxHandle(m_WindowName $ ".ItemSearch_EditBox");
	m_ButtonSearchItem = GetButtonHandle(m_WindowName $ ".ItemSearch_Button");
}

function OnEvent( int a_EventID, String Param )
{
	switch( a_EventID )
	{
		case EV_NPCViewerWndReload:
			ReloadNPCViewerWnd();
			break;
	}
}

function OnDBClickListBoxItem(String strID, int SelectedIndex)
{
	switch (strID)
	{
		case "Npc_ListBox":
			SelectedID = m_ListBoxNPC.GetSelectedItemData();
			HandleNPCData();
			HandleNPCSpawn();
			break;
		default:
			break;
	}
}

function OnLButtonClickListBoxItem(String strID, int SelectedIndex)
{
	switch (strID)
	{
		case "Npc_ListBox":
			SelectedID = m_ListBoxNPC.GetSelectedItemData();
			HandleNPCData();
			break;
		default:
			break;
	}
}

function OnDBClickItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
{
	local ItemInfo info;

	if (a_hItemWindow.GetItem(index, info))
	{
		switch (a_hItemWindow.GetWindowName())
		{
			case "IconList_ItemWindow":
				class'UIDATA_PAWNVIEWER'.static.EquipNPCItem(info.Id);
				break;
			default:
				break;
		}
	}
}

function OnRClickItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
{
	local ItemInfo info;

	if (a_hItemWindow.GetItem(index, info))
	{
		switch (a_hItemWindow.GetWindowName())
		{
			case "IconList_ItemWindow":
				class'UIDATA_PAWNVIEWER'.static.EquipNPCItem(info.Id);
				break;
			default:
				break;
		}
	}
}

function OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	if (nKey == IK_Enter)
	{
		switch (a_WindowHandle.GetWindowName())
		{
			case "NpcSearch_EditBox" :
				NpcSearch = m_EditBoxSearchNPC.GetString();
				if (NpcSearch != "")
					SearchNPC(NpcSearch);
				break;
			case "ItemSearch_EditBox":
				NpcSearch = m_EditBoxSearchItem.GetString();
				if (NpcSearch != "")
					SearchItem(NpcSearch);
				break;
			case "Speed_EditBox":
			case "Rate_EditBox":
			case "Radius_EditBox":
			case "Height_EditBox":
			case "State_EditBox": 
				ApplyPawnSetting();
				break;
			case "Scale_EditBox":
				if (m_CheckBoxCollisionAutoCalc.IsChecked())
				{
					ApplyAutoCalcCollisionScale();
				}
				else
				{
					ApplyPawnSetting();
				}
			default:
				break;
		}
	}
}

function OnComboBoxItemSelected(String strID, int index)
{
	local string AnimName;
	local float AnimRate;

	switch (strID)
	{
		case "Anim_ComboBox":
			AnimName = m_ComboAnimation.GetString(index);
			AnimRate = float(m_EditBoxAnimRate.GetString());
			class'UIDATA_PAWNVIEWER'.static.PlayNPCAnim(AnimName, AnimRate);
			break;
	}
}

function OnClickCheckBox( string strID)
{
	switch (strID)
	{
		case "CB_AutoCalculate":
			if (m_CheckBoxCollisionAutoCalc.IsChecked())
			{
				ApplyAutoCalcCollisionScale();
				m_EditBoxRadius.DisableWindow();
				m_EditBoxHeight.DisableWindow();
			}
			else
			{
				m_EditBoxRadius.EnableWindow();
				m_EditBoxHeight.EnableWindow();
			}
			break;
		case "NameID_RadioButton":
			if (m_RadioButtonNameID.IsChecked())
			{
				SearchMode = Search_NPC_NameID;
				TogleNPCList(Show_NPC_NameID);
			}

			break;
		case "Mesh_RadioButton":
			if (m_RadioButtonMesh.IsChecked())
			{
				SearchMode = Search_NPC_Mesh;
				TogleNPCList(Show_NPC_Mesh);
			}

			break;
		case "Class_RadioButton":
			if (m_RadioButtonClass.IsChecked())
			{
				SearchMode = Search_NPC_Class;
				TogleNPCList(Show_NPC_Class);
			}

			break;
		default :
			break;
	}
}

function OnClickButton( string strID )
{
	local string editBoxstring;

	switch( strID )
	{
		case "Button_NpcSearch":
			editBoxstring = m_EditBoxSearchNPC.GetString();
			SearchNPC(editBoxstring);
			break;
		case "Button_Duplicate":
			class'UIDATA_PAWNVIEWER'.static.SpawnActorAtMyLocation(SelectedID);
			break;
		case "ItemSearch_Button":
			editBoxstring = m_EditBoxSearchItem.GetString();
			SearchItem(editBoxstring);
			break;
	}
}

function SetAnimList()
{
	local array<string> AnimList;
	local int index;

	m_ComboAnimation.Clear();
	class'UIDATA_PAWNVIEWER'.static.GetNPCAnimationList(AnimList);
	for (index = 0; index < AnimList.Length; index++)
	{
		m_ComboAnimation.AddString(AnimList[index]);
	}
}

function HandleNPCData()
{
	local string MeshName;
	local array<string> TexList;
	local string ClassName;

	local int index;
	
	local Color MeshColor;
	local Color TextureColor;
	local Color ClassColor;

	MeshColor.R = 255;
	MeshColor.G = 255;
	MeshColor.B = 150;

	TextureColor.R = 255;
	TextureColor.G = 150;
	TextureColor.B = 255;

	ClassColor.R = 150;
	ClassColor.G = 255;
	ClassColor.B = 255;
	
	m_TextNPCMeshTexture.Clear();
	MeshName = class'UIDATA_NPC'.static.GetNPCMesh(SelectedID);
	class'UIDATA_NPC'.static.GetNPCTextureList(SelectedID, TexList);
	ClassName = class'UIDATA_NPC'.static.GetNPCClass(SelectedID);

	m_TextNPCMeshTexture.AddStringWithData("" $ MeshName , MeshColor , 0);

	for (index = 0; index < TexList.Length; index++)
		m_TextNPCMeshTexture.AddStringWithData("" $ TexList[index], TextureColor, 0);

	m_TextNPCMeshTexture.AddStringWithData("" $ ClassName, ClassColor, 0);

}

function HandleNPCSpawn()
{
	SelectedID = m_ListBoxNPC.GetSelectedItemData();
	class'UIDATA_PAWNVIEWER'.static.SpawnNPC(SelectedID, GroundSpeed, AnimRate, CollisionRadius, CollisionHeight, DrawScale, PawnState);

	defaultCollisionRadius = CollisionRadius;
	defaultCollisionHeight = CollisionHeight;

	SetAnimList();

	m_EditBoxSpeed.SetString("" $ GroundSpeed);
	m_EditBoxAnimRate.SetString("" $ AnimRate);
	m_EditBoxRadius.SetString("" $ CollisionRadius);
	m_EditBoxHeight.SetString("" $ CollisionHeight);
	m_EditBoxScale.SetString("" $ DrawScale);
	m_EditBoxState.SetString("" $ PawnState);
}

function TogleNPCList(EShowMode ShowMode)
{
	local int index;
	local string Name;
	local string MeshName;
	local string ClassName;
	local Color c;

	c.R = 255;
	c.G = 255;
	c.B = 255;

	m_ListBoxNPC.Clear();

	for (index = 0; index < NpcIdList.Length; index++)
	{
		switch (ShowMode)
		{
			case Show_NPC_NameID:
				Name = class'UIDATA_NPC'.static.GetNPCName(NpcIdList[index]);
				m_ListBoxNPC.AddStringWithData("[" $ NpcIdList[index] $ "] " $ Name, c, NpcIdList[index]);
				break;
			case Show_NPC_Mesh:
				MeshName = class'UIDATA_NPC'.static.GetNPCMesh(NpcIdList[index]);
				m_ListBoxNPC.AddStringWithData(""  $ MeshName, c, NpcIdList[index]);
				break;
			case Show_NPC_Class:
				ClassName = class'UIDATA_NPC'.static.GetNPCClass(NpcIdList[index]);
				m_ListBoxNPC.AddStringWithData(""  $ ClassName, c, NpcIdList[index]);
				break;
			default:
				break;
		}
	}
}

function SearchNPC(string strSearch)
{
	local int npcClassID;
	local string Name;
	local string MeshName;
	local string ClassName;
	local Color c;
	local bool bFindAllItem;

	c.R = 255;
	c.G = 255;
	c.B = 255;

	m_ListBoxNPC.Clear();
	m_ItemWindowNpcItem.Clear();
	NpcIdList.Length = 0;

	// 검색어가 하나도 없으면 모두 출력하도록 한다.
	for (npcClassID = class'UIDATA_NPC'.static.GetFirstID(); class'UIDATA_NPC'.static.IsValidData(npcClassID); npcClassID = class'UIDATA_NPC'.static.GetNextID())
	{
		bFindAllItem = false;
		if (strSearch == "")
		{
			bFindAllItem = true; 
		}
		
		switch (SearchMode)
		{
			case Search_NPC_NameID:
				Name = class'UIDATA_NPC'.static.GetNPCName(npcClassID);
				if (bFindAllItem == true || npcClassID == int(strSearch) || StringMatching(Name, strSearch, " "))
				{
					m_ListBoxNPC.AddStringWithData("[" $ npcClassID $ "] " $ Name, c, npcClassID);
					NpcIdList.Length = NpcIdList.Length + 1;
					NpcIdList[NpcIdList.Length - 1] = npcClassID;
				}
				break;
			case Search_NPC_Mesh:
				MeshName = class'UIDATA_NPC'.static.GetNPCMesh(npcClassID);
				if (bFindAllItem == true || StringMatching(MeshName, strSearch, " "))
				{
					m_ListBoxNPC.AddStringWithData(""  $ MeshName, c, npcClassID);
					NpcIdList.Length = NpcIdList.Length + 1;
					NpcIdList[NpcIdList.Length - 1] = npcClassID;
				}
				break;
			case Search_NPC_Class:
				ClassName = class'UIDATA_NPC'.static.GetNPCClass(npcClassID);
				if (bFindAllItem == true || StringMatching(ClassName, strSearch, " "))
				{
					m_ListBoxNPC.AddStringWithData("" $ ClassName, c, npcClassID);
					NpcIdList.Length = NpcIdList.Length + 1;
					NpcIdList[NpcIdList.Length - 1] = npcClassID;
				}
				break;
			default:
				break;
		}
	}
}

function SearchItem(string strSearch)
{	
	local ItemID cID;
	local string ItemName;
	local ItemInfo WeaponItemInfo;
	local bool bFindItem;

	m_ItemWindowNpcItem.Clear();

	for (cID = class'UIDATA_ITEM'.static.GetFirstID(); IsValidItemID(cID); cID = class'UIDATA_ITEM'.static.GetNextID())
	{
		if (class'UIDATA_ITEM'.static.GetItemDataType(cID) != EItemType.ITEM_WEAPON)
			continue;

		bFindItem = false;

		if (strSearch == "")
		{
			bFindItem = true;
		}
		else if (cID.ClassID == int(strSearch))
		{
			bFindItem = true;
		}
		else
		{
			ItemName = class'UIDATA_ITEM'.static.GetItemName(cID);
			if (StringMatching(ItemName, strSearch, " "))
			{
				bFindItem = true;
			}
		}

		if (bFindItem == true)
		{
			class'UIDATA_ITEM'.static.GetItemInfo(cID, WeaponItemInfo);
			WeaponItemInfo.ShortcutType = int(EShortCutItemType.SCIT_ITEM);
			m_ItemWindowNpcItem.AddItem(WeaponItemInfo);
		}
	}

}

function ApplyPawnSetting()
{
	GroundSpeed = float(m_EditBoxSpeed.GetString());
	AnimRate = float(m_EditBoxAnimRate.GetString());
	CollisionRadius = float(m_EditBoxRadius.GetString());
	CollisionHeight = float(m_EditBoxHeight.GetString());
	DrawScale = float(m_EditBoxScale.GetString());
	PawnState = int(m_EditBoxState.GetString());
	class'UIDATA_PAWNVIEWER'.static.ApplyPawnSetting(GroundSpeed, AnimRate, CollisionRadius, CollisionHeight, DrawScale, PawnState);
}

function ApplyAutoCalcCollisionScale()
{
	local float scale;

	scale = float(m_EditBoxScale.GetString());

	CollisionRadius = scale * defaultCollisionRadius;
	CollisionHeight = scale * defaultCollisionHeight + 3.f * (scale - 1.f);

	m_EditBoxRadius.SetString("" $ CollisionRadius);
	m_EditBoxHeight.SetString("" $ CollisionHeight);

	class'UIDATA_PAWNVIEWER'.static.ApplyPawnSetting(0.f, 0.f, CollisionRadius, CollisionHeight, scale, 0.f);
}

function ReloadNPCViewerWnd()
{
	// XML로 convert 하기전 NPCViewerWnd가 존재 했을 떄 기존의 기능
	// 1. NPCViewerWnd와 그 ChildWnd들을 제거 한다. 
	// 2. NPCViewerWnd를 다시 생성힌다.
	// 3. NPCViewerWnd의 위치를 원래의 위치로 재조정해준다. 
	// XML로 convert 한 이후로는 하나의 윈도우를 삭제하고 다시 생성해주는 것은
	// 코드를 새로 만들어 주어야 하는 일이므로 Reset과 같은 기능으로 기능을 조금 수정해 주어야 할 것 같다. 
	//
	m_hWnd.SetAnchor("", "TopLeft", "TopLeft", 24, 4);
	m_ItemWindowNpcItem.Clear();
}

defaultproperties
{
     m_WindowName="NPCViewerWnd"
}
