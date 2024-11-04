class PCViewerWnd extends UICommonAPI;

var string m_WindowName;


var WindowHandle		m_hWnd;

var ComboBoxHandle		m_ComboCharType;	// 종족

var ButtonHandle		m_ButtonSummon;
var ButtonHandle		m_ButtonCharChange;

var TabHandle			m_TabCategory;

// ---------------- Item Tab ----------------
var ComboBoxHandle		m_ComboFace;
var ComboBoxHandle		m_ComboHair;
var ComboBoxHandle		m_ComboColor;

var ListBoxHandle		m_ListBoxBeautyInfo;

var EditBoxHandle		m_EditBoxHairAccOffsetX;
var EditBoxHandle		m_EditBoxHairAccOffsetY;
var EditBoxHandle		m_EditBoxHairAccOffsetZ;
var EditBoxHandle		m_EditBoxHairAccPitch;
var EditBoxHandle		m_EditBoxHairAccYaw;
var EditBoxHandle		m_EditBoxHairAccRoll;

var ButtonHandle		m_ButtonApply;

var ItemWindowHandle	m_ItemWindowPCItem;
var EditBoxHandle		m_EditBoxSearchItem;
var ButtonHandle		m_ButtonSearchItem;

var CheckBoxHandle		m_CheckBoxRefinery;
var EditBoxHandle		m_EditBoxRefineryValue1;
var EditBoxHandle		m_EditBoxRefineryValue2;

var CheckBoxHandle		m_CheckBoxEnchant;
var EditBoxHandle		m_EditBoxEnchantValue;

var ListBoxHandle		m_ListBoxItemPath;

// ---------------- Animation Tab ----------------

var EditBoxHandle		m_EditBoxSearchAnim;
var ButtonHandle		m_ButtonSearchAnim;
var ListBoxHandle		m_ListBoxAnim;
var EditBoxHandle		m_EditBoxAnimSpeed;
var TextBoxHandle		m_TextBoxFrame;

var EditBoxHandle		m_EditBoxAnim1;			// 나중에 하도록! 콤보 리스트를 띄워주도록 할 것인데 지금 유아이로는 할 수가 없기 때문에 콤보 리스트를 어떻게 띄울 것인지.
var EditBoxHandle		m_EditBoxAnim2;
var EditBoxHandle		m_EditBoxAnim3;

var ButtonHandle		m_ButtonUseAnim1;
var ButtonHandle		m_ButtonUseAnim2;
var ButtonHandle		m_ButtonUseAnim3;

var ButtonHandle		m_ButtonDeleteAnim1;
var ButtonHandle		m_ButtonDeleteAnim2;
var ButtonHandle		m_ButtonDeleteAnim3;

var EditBoxHandle		m_EditBoxHitTime;
var EditBoxHandle		m_EditBoxLoopIdx;

var ButtonHandle		m_ButtonAnimPlay;

// Global Variable 
var string FaceMeshName;
var string FaceTexName;
var string AHairMeshName;
var string AHairTexName;
var string BHairMeshName;
var string BHairTexName;
var string BHairExSubTexName;

// ---------------- Simulation Tab ----------------
// Simulation Mesh
var TextBoxHandle		m_TextBoxSimulationMeshName;
var ComboBoxHandle		m_ComboBoxSimulAnchorVertex;
var ButtonHandle		m_ButtonAddSimulAnchor;
var ButtonHandle		m_ButtonRemoveSimulAnchor;

var ComboBoxHandle		m_ComboBoxSimulCollision;
var ComboBoxHandle		m_ComboBoxSimulColType;

var EditBoxHandle		m_EditBoxSimulBoneA;
var EditBoxHandle		m_EditBoxSimulBoneB;
var EditBoxHandle		m_EditBoxSimulRadius;

var CheckBoxHandle		m_CheckBoxSimulSphereA;
var CheckBoxHandle		m_CheckBoxSimulSphereB;

var ButtonHandle		m_ButtonSimulColAdd;	
var ButtonHandle		m_ButtonSimulColRemove;
var ButtonHandle		m_ButtonSimulColUpdate;

// Animation Sequence
var TextBoxHandle		m_TextBoxSimulAnimSequence;

var ComboBoxHandle		m_ComboBoxSimulForceIdx;
var EditBoxHandle		m_EditBoxSimulWeight;			
var EditBoxHandle		m_EditBoxSimulForceFrame;
var EditBoxHandle		m_EditBoxSimulForceStiff;

var CheckBoxHandle		m_CheckBoxTerrainCollision;
var CheckBoxHandle		m_CheckBoxUseForce;

var EditBoxHandle		m_EditBoxSimulForceX;
var EditBoxHandle		m_EditBoxSimulForceY;
var EditBoxHandle		m_EditBoxSimulForceZ;

var ButtonHandle		m_ButtonSimulAnimAdd;
var ButtonHandle		m_ButtonSimulAnimRemove;
var ButtonHandle		m_ButtonSimulAnimUpdate;

// Chest Mesh
var ListBoxHandle		m_ListBoxSimulWhat;		// ?? 이건 뭐지이잉?

var TextBoxHandle		m_TextBoxSimulMantleOffset;

var EditBoxHandle		m_EditBoxSimulMantleOffsetX;
var ButtonHandle		m_ButtonSimulMantleOffsetXUp;
var ButtonHandle		m_ButtonSimulMantleOffsetXDown;

var EditBoxHandle		m_EditBoxSimulMantleOffsetY;
var ButtonHandle		m_ButtonSimulMantleOffsetYUp;
var ButtonHandle		m_ButtonSimulMantleOffsetYDown;

var EditBoxHandle		m_EditBoxSimulMantleOffsetZ;
var ButtonHandle		m_ButtonSimulMantleOffsetZUp;
var ButtonHandle		m_ButtonSimulMantleOffsetZDown;

var ButtonHandle		m_ButtonSimulMantleOffsetLoad;
var ButtonHandle		m_ButtonSimulMantleOffsetReset;
var ButtonHandle		m_ButtonSimulMantleOffsetSave;

// Global Variable
var int iSimulVertexNum;
var int iSimulColNum;
var array<string> SimulColTypeList;
var string sSimulColType;
var int iSimulBoneA;
var int iSimulBoneB;
var float fSimulRadius;
var byte bSimulSphereA;
var byte bSimulSphereB;

var int iSimulAnimNum;
var float iSimulWeight;
var float fSimulFrame;
var float fSimulStiff;
var byte bSimulTerrainCol;
var byte bSimulUserForce;
var vector vSimulForce;

var string sChestMeshName;
var vector vMantleOffset;


// ---------------- Test Tab ----------------
var EditBoxHandle m_EditBoxPCNumber;
var EditBoxHandle m_EditBoxSkillUse;
var EditBoxHandle m_EditBoxSkillStop;
var EditBoxHandle m_EditBoxPCRemove;
var EditBoxHandle m_EditBoxBowSkill;

var ButtonHandle m_ButtonTestStart;

// L2User.h의 RaceType
const RaceType_HUMAN = 0;	// RT_HUMAN
const RaceType_ELF = 1;		// RT_ELF
const RaceType_DARKELF = 2;	// RT_DARKELF
const RaceType_ORC = 3;		// RT_ORC
const RaceType_DWARF = 4;	// RT_DWARF
const RaceType_KAMAEL = 5;	// RT_KAMAEL
const RaceType_ERTHEIA = 6;	// RT_ERTHEIA

// L2User.h의 Sex
const Sex_Male = 0;	
const Sex_Female = 1;	

enum BEAUTY_TYPE
{
	BEAUTY_FACE,
	BEAUTY_HAIR,
	BEAUTY_HAIRCOLOR
};

function OnRegisterEvent()
{
	registerEvent(EV_PCViewerWndReload);
}

function OnLoad()
{
	InitializeHandle();
	m_hWnd.SetWindowTitle("PC VIEWER");
}

function OnShow()
{
	Initialize();
	m_hWnd.ShowWindow();
}

function InitializeHandle()
{

	m_hWnd = GetWindowHandle(m_WindowName);

	m_ComboCharType = GetComboBoxHandle(m_WindowName$".Char_ComboBox");

	m_ButtonSummon = GetButtonHandle(m_WindowName$".Spawn_Button");
	m_ButtonCharChange = GetButtonHandle(m_WindowName$".Change_Button");

	m_TabCategory = GetTabHandle(m_WindowName$".FunctionSelect_Tab");

	// Item Tab
	m_ComboFace = GetComboBoxHandle(m_WindowName$".Face_ComboBox");
	m_ComboHair = GetComboBoxHandle(m_WindowName$".Hair_ComboBox");
	m_ComboColor = GetComboBoxHandle(m_WindowName$".Color_ComboBox");

	m_ListBoxBeautyInfo = GetListBoxHandle(m_WindowName$".FaceHair_ListBox");

	m_EditBoxHairAccOffsetX = GetEditBoxHandle(m_WindowName$".OffsetX_EditBox");
	m_EditBoxHairAccOffsetY = GetEditBoxHandle(m_WindowName$".OffsetY_EditBox");
	m_EditBoxHairAccOffsetZ = GetEditBoxHandle(m_WindowName$".OffsetZ_EditBox");
	m_EditBoxHairAccPitch = GetEditBoxHandle(m_WindowName$".Pitch_EditBox");
	m_EditBoxHairAccYaw = GetEditBoxHandle(m_WindowName$".Yaw_EditBox");
	m_EditBoxHairAccRoll = GetEditBoxHandle(m_WindowName$".Roll_EditBox");

	m_ButtonApply = GetButtonHandle(m_WindowName$".OffsetApply_Button");

	m_ItemWindowPCItem = GetItemWindowHandle(m_WindowName$".IconList_ItemWindow");

	m_EditBoxSearchItem = GetEditBoxHandle(m_WindowName$".ItemSearch_EditBox");
	m_ButtonSearchItem = GetButtonHandle(m_WindowName$".ItemSearch_Button");

	m_CheckBoxRefinery = GetCheckBoxHandle(m_WindowName$".Variation_CheckBox");
	m_EditBoxRefineryValue1 = GetEditBoxHandle(m_WindowName$".optionA_EditBox");
	m_EditBoxRefineryValue2 = GetEditBoxHandle(m_WindowName$".optionB_EditBox");

	m_CheckBoxEnchant = GetCheckBoxHandle(m_WindowName$".Enchant_CheckBox");
	m_EditBoxEnchantValue = GetEditBoxHandle(m_WindowName$".enchant_EditBox");

	m_ListBoxItemPath = GetListBoxHandle(m_WindowName$".ItemPath_ListBox");

	// Animation Tab 
	m_EditBoxSearchAnim = GetEditBoxHandle(m_WindowName$".SeqSearch_EditBox");
	m_ButtonSearchAnim = GetButtonHandle(m_WindowName$".AnimSearch_Button");
	m_ListBoxAnim = GetListBoxHandle(m_WindowName$".Seq_ListBox");
	m_EditBoxAnimSpeed = GetEditBoxHandle(m_WindowName$".Speed_EditBox");
	m_TextBoxFrame = GetTextBoxHandle(m_WindowName$".Frame_TextBox");

	m_EditBoxAnim1 = GetEditBoxHandle (m_WindowName$".Ani1_EditBox");
	m_EditBoxAnim2 = GetEditBoxHandle(m_WindowName$".Ani2_EditBox");
	m_EditBoxAnim3 = GetEditBoxHandle(m_WindowName$".Ani3_EditBox");

	m_ButtonUseAnim1 = GetButtonHandle(m_WindowName$".Ani1Use_Button");
	m_ButtonUseAnim2 = GetButtonHandle(m_WindowName$".Ani2Use_Button");
	m_ButtonUseAnim3 = GetButtonHandle(m_WindowName$".Ani3Use_Button");

	m_ButtonDeleteAnim1 = GetButtonHandle(m_WindowName$".Ani1Del_Button");
	m_ButtonDeleteAnim2 = GetButtonHandle(m_WindowName$".Ani2Del_Button");
	m_ButtonDeleteAnim3 = GetButtonHandle(m_WindowName$".Ani3Del_Button");

	m_EditBoxHitTime = GetEditBoxHandle(m_WindowName$".HitTime_EditBox");
	m_EditBoxLoopIdx = GetEditBoxHandle(m_WindowName$".LoopIdx_EditBox");

	m_ButtonAnimPlay = GetButtonHandle(m_WindowName$".ComboPlay_Button");

	// Simulation Tab 
	//		Simulation Mesh
	m_TextBoxSimulationMeshName = GetTextBoxHandle(m_WindowName$".SimMsg_TextBox");

	m_ComboBoxSimulAnchorVertex = GetComboBoxHandle(m_WindowName$".VertexNum_ComboBox");
	m_ButtonAddSimulAnchor = GetButtonHandle(m_WindowName$".VtxAdd_Button");
	m_ButtonRemoveSimulAnchor = GetButtonHandle(m_WindowName$".VtxRemove_Button");

	m_ComboBoxSimulCollision = GetComboBoxHandle(m_WindowName$".CollisionNum_ComboBox");
	m_ComboBoxSimulColType = GetComboBoxHandle(m_WindowName$".CollisionType_ComboBox");
	m_EditBoxSimulBoneA = GetEditBoxHandle(m_WindowName$".BoneA_EditBox");
	m_EditBoxSimulBoneB = GetEditBoxHandle(m_WindowName$".BoneB_EditBox");
	m_EditBoxSimulRadius = GetEditBoxHandle(m_WindowName$".Radius_EditBox");

	m_CheckBoxSimulSphereA = GetCheckBoxHandle(m_WindowName$".SphereA_CheckBox");
	m_CheckBoxSimulSphereB = GetCheckBoxHandle(m_WindowName$".SphereB_CheckBox");

	m_ButtonSimulColAdd = GetButtonHandle(m_WindowName$".ColAdd_Button");
	m_ButtonSimulColRemove = GetButtonHandle(m_WindowName$".ColRemove_Button");
	m_ButtonSimulColUpdate = GetButtonHandle(m_WindowName$".ColUpdate_Button");

	//		Animation Sequence
	m_TextBoxSimulAnimSequence = GetTextBoxHandle(m_WindowName$".AnimMsg_TextBox");

	m_ComboBoxSimulForceIdx = GetComboBoxHandle(m_WindowName$".ForceIdx_ComboBox");
	m_EditBoxSimulWeight = GetEditBoxHandle(m_WindowName$".Weight_EditBox");
	m_EditBoxSimulForceFrame = GetEditBoxHandle(m_WindowName$".ForceFrame_EditBox");
	m_EditBoxSimulForceStiff = GetEditBoxHandle(m_WindowName$".Stiff_EditBox");

	m_CheckBoxTerrainCollision = GetCheckBoxHandle(m_WindowName$".Terrain_CheckBox");
	m_CheckBoxUseForce = GetCheckBoxHandle(m_WindowName$".UseForce_CheckBox");

	m_EditBoxSimulForceX = GetEditBoxHandle(m_WindowName$".ForceX_EditBox");
	m_EditBoxSimulForceY = GetEditBoxHandle(m_WindowName$".ForceY_EditBox");
	m_EditBoxSimulForceZ = GetEditBoxHandle(m_WindowName$".ForceZ_EditBox");

	m_ButtonSimulAnimAdd = GetButtonHandle(m_WindowName$".ForceAdd_Button");
	m_ButtonSimulAnimRemove = GetButtonHandle(m_WindowName$".ForceRem_Button");
	m_ButtonSimulAnimUpdate = GetButtonHandle(m_WindowName$".ForceUpdate_Button");

	//m_ListBoxSimulWhat = GetListBoxHandle(m_WindowName$".");

	//		Mantle Offset
	m_TextBoxSimulMantleOffset = GetTextBoxHandle(m_WindowName$".ChestMesh_TextBox");

	m_EditBoxSimulMantleOffsetX = GetEditBoxHandle(m_WindowName$".MantleOffsetX_EditBox");
	m_ButtonSimulMantleOffsetXUp = GetButtonHandle(m_WindowName$".PlusX_Button");
	m_ButtonSimulMantleOffsetXDown = GetButtonHandle(m_WindowName$".MinusX_Button");

	m_EditBoxSimulMantleOffsetY = GetEditBoxHandle(m_WindowName$".MantleOffsetY_EditBox");
	m_ButtonSimulMantleOffsetYUp = GetButtonHandle(m_WindowName$".PlusY_Button");
	m_ButtonSimulMantleOffsetYDown = GetButtonHandle(m_WindowName$".MinusY_Button");

	m_EditBoxSimulMantleOffsetZ = GetEditBoxHandle(m_WindowName$".MantleOffsetZ_EditBox");
	m_ButtonSimulMantleOffsetZUp = GetButtonHandle(m_WindowName$".PlusZ_Button");
	m_ButtonSimulMantleOffsetZDown = GetButtonHandle(m_WindowName$".MinusZ_Button");

	m_ButtonSimulMantleOffsetLoad = GetButtonHandle(m_WindowName$".SimLoad_Button");
	m_ButtonSimulMantleOffsetReset = GetButtonHandle(m_WindowName$".SimReset_Button");
	m_ButtonSimulMantleOffsetSave = GetButtonHandle(m_WindowName$".SimSave_Button");

	// Test Tab
	m_EditBoxPCNumber = GetEditBoxHandle(m_WindowName$".PCNumber_EditBox");
	m_EditBoxSkillUse = GetEditBoxHandle(m_WindowName$".SkillUse_EditBox");
	m_EditBoxSkillStop = GetEditBoxHandle(m_WindowName$".SkillStop_EditBox");
	m_EditBoxPCRemove = GetEditBoxHandle(m_WindowName$".PCRemove_EditBox");
	m_EditBoxBowSkill = GetEditBoxHandle(m_WindowName$".BowSkill_EditBox");

	m_ButtonTestStart = GetButtonHandle(m_WindowName$".TestStart_Button");

}

function OnEvent(int a_EventID, String Param)
{
	switch (a_EventID)
	{
		case EV_PCViewerWndReload:
			ReloadPCViewerWnd();
			break;
	}
}

function Initialize()
{
	SetClassComboBox();
	
	// Item Tab
	SetHairAccOffset();

	// Animation Tab 
	m_EditBoxAnimSpeed.SetString("1.0");
	m_EditBoxHitTime.SetString("1.8");
	m_EditBoxLoopIdx.SetString("-1");
	SearchAnimation("");
	// Simulation Tab 

	// Test Tab

}

function OnDBClickListBoxItem(String strID, int SelectedIndex)
{
	local string SelectedStr;
	local float AnimSpeed;

	switch (strID)
	{
		// Item Tab
		// Animation Tab 
		case "Seq_ListBox":
			//m_ListBoxAnim  = m_ListBoxAnim.GetSelectedItemData();
			SelectedStr = m_ListBoxAnim.GetSelectedString();
			AnimSpeed = float(m_EditBoxAnimSpeed.GetString());
			class'UIDATA_PAWNVIEWER'.static.PlayPCAnim(SelectedStr, AnimSpeed);

			break;

		default:
			break;
	}

}

function OnLButtonClickListBoxItem(String strID, int SelectedIndex)
{

}

function OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int index)
{

	local ItemInfo info;

	if (a_hItemWindow.GetItem(index, info))
	{
		switch (a_hItemWindow.GetWindowName())
		{
			// Item Tab
			case "IconList_ItemWindow":
				EquipPCItem(info);
				break;

			default:
				break;
		}
	}
	
}

function OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int index)
{
	
	local ItemInfo info;

	if (a_hItemWindow.GetItem(index, info))
	{
		switch (a_hItemWindow.GetWindowName())
		{
			// Item Tab 
			case "IconList_ItemWindow":
				EquipPCItem(info);
				break;
			
			default:
				break;
		}
	}
	
}

function OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	local string EditBoxStr;

	switch (nKey)
	{
		case IK_Enter:
			// Item Tab 
			if (m_EditBoxSearchItem.IsFocused())
			{
				EditBoxStr = m_EditBoxSearchItem.GetString();
				SearchItem(EditBoxStr);
			}
			// Simulation Tab 
			else if (m_EditBoxSimulMantleOffsetX.IsFocused())
			{
				vMantleOffset.X = float(m_EditBoxSimulMantleOffsetX.GetString());
				class'UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			}
			else if (m_EditBoxSimulMantleOffsetY.IsFocused())
			{
				vMantleOffset.Y = float(m_EditBoxSimulMantleOffsetY.GetString());
				class'UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			}
			else if (m_EditBoxSimulMantleOffsetZ.IsFocused())
			{
				vMantleOffset.Z = float(m_EditBoxSimulMantleOffsetZ.GetString());
				class'UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			}
			else if (m_EditBoxSearchAnim.IsFocused())
			{
				EditBoxStr = m_EditBoxSearchAnim.GetString();
				SearchAnimation(EditBoxStr);
			}
			break;
			
		default:
			break;
	}	
}

function OnComboBoxItemSelected(String strID, int index)
{
	local string CharStr;
	local int SelectedValue;

	switch (strID)
	{
		case "Char_ComboBox":
			CharStr = m_ComboCharType.GetString(index);
			class'UIDATA_PAWNVIEWER'.static.SpawnCharacter("LineageWarrior." $ CharStr);
			SetBeautyComboBox(BEAUTY_FACE);
			SetBeautyComboBox(BEAUTY_HAIR);
			SetBeautyComboBox(BEAUTY_HAIRCOLOR);
			SearchAnimation("");

			break;

		// Item Tab 
		case "Face_ComboBox":
			SelectedValue = int(m_ComboFace.GetString(index));
			ApplyBeauty(BEAUTY_FACE, SelectedValue);

			break;

		case "Hair_ComboBox":
			SelectedValue = int(m_ComboHair.GetString(index));
			ApplyBeauty(BEAUTY_HAIR, SelectedValue);
			SetBeautyComboBox(BEAUTY_HAIRCOLOR);

			break;

		case "Color_ComboBox":
			SelectedValue = int(m_ComboColor.GetString(index));
			ApplyBeauty(BEAUTY_HAIRCOLOR, SelectedValue);

			break;

		// Simulation Tab 
		case "CollisionNum_ComboBox":
			SelectedValue = int(m_ComboBoxSimulCollision.GetString(index));
			SetSimulationCollisionUI(SelectedValue);
			break;

		case "ForceIdx_ComboBox":
			class'UIDATA_PAWNVIEWER'.static.GetAnimForceInfo(m_ComboBoxSimulForceIdx.GetSelectedNum(), iSimulWeight, fSimulFrame, fSimulStiff, bSimulTerrainCol, bSimulUserForce, vSimulForce);

			m_EditBoxSimulWeight.SetString("" $ iSimulWeight);
			m_EditBoxSimulForceFrame.SetString("" $ fSimulFrame);
			m_EditBoxSimulForceStiff.SetString("" $ fSimulStiff);
			m_CheckBoxTerrainCollision.SetCheck(bool(bSimulTerrainCol));
			m_CheckBoxUseForce.SetCheck(bool(bSimulUserForce));
			m_EditBoxSimulForceX.SetString("" $ vSimulForce.X);
			m_EditBoxSimulForceY.SetString("" $ vSimulForce.Y);
			m_EditBoxSimulForceZ.SetString("" $ vSimulForce.Z);

			/* Animation 적용이 되어야 한다.*/
			
		default:
			break;
	}
}

function OnClickCheckBox(string strID)
{
}

function OnClickButton(string strID)
{
	local string EditBoxStr;
	local int SelectedIndex;
	local float OffsetX;
	local float OffsetY;
	local float OffsetZ;
	local float Pitch;
	local float Yaw;
	local float Roll;

	local float Frame;
	local float Duration;
	local float Dues;

	local int index;
	local Color TextLoadColor;

	TextLoadColor.R = 255;
	TextLoadColor.G = 255;
	TextLoadColor.B = 150;

	switch (strID)
	{
		case "Spawn_Button":
			class'UIDATA_PAWNVIEWER'.static.DuplicateCharacter();
			break;
		case "Change_Button":
			class'UIDATA_PAWNVIEWER'.static.ChangeMyPC();
			break;

		// ---------------- Item Tab ----------------
		case "ItemSearch_Button":
			EditBoxStr = m_EditBoxSearchItem.GetString();
			SearchItem(EditBoxStr);
			break;

		case "OffsetApply_Button":
			OffsetX = float(m_EditBoxHairAccOffsetX.GetString());
			OffsetY = float(m_EditBoxHairAccOffsetY.GetString());
			OffsetZ = float(m_EditBoxHairAccOffsetZ.GetString());
			Pitch = float(m_EditBoxHairAccPitch.GetString());
			Yaw = float(m_EditBoxHairAccYaw.GetString());
			Roll = float(m_EditBoxHairAccRoll.GetString());
			class'UIDATA_PAWNVIEWER'.static.AdjustHairAccOffset(OffsetX, OffsetY, OffsetZ, Pitch, Yaw, Roll);
			break;	

		// ---------------- Animation Tab ----------------
		case "AnimSearch_Button":
			EditBoxStr = m_EditBoxSearchAnim.GetString();
			SearchAnimation(EditBoxStr);
			break;

		case "Ani1Use_Button":
			m_EditBoxAnim1.SetString(m_ListBoxAnim.GetSelectedString());
			break;

		case "Ani2Use_Button":
			m_EditBoxAnim2.SetString(m_ListBoxAnim.GetSelectedString());
			break;

		case "Ani3Use_Button":
			m_EditBoxAnim3.SetString(m_ListBoxAnim.GetSelectedString());
			break;

		case "Ani1Del_Button":
			m_EditBoxAnim1.SetString("");
			break;

		case "Ani2Del_Button":
			m_EditBoxAnim2.SetString("");
			break;
			
		case "Ani3Del_Button":
			m_EditBoxAnim3.SetString("");
			break;
			
		case "ComboPlay_Button":
			class'UIDATA_PAWNVIEWER'.static.PlayPCComboAnim(m_EditBoxAnim1.GetString(), m_EditBoxAnim2.GetString(), m_EditBoxAnim3.GetString(), float(m_EditBoxHitTime.GetString()), float(m_EditBoxLoopIdx.GetString()));
			class'UIDATA_PAWNVIEWER'.static.GetAnimFrame(0, Frame, Duration, Dues);
			class'UIDATA_PAWNVIEWER'.static.GetAnimFrame(1, Frame, Duration, Dues);
			class'UIDATA_PAWNVIEWER'.static.GetAnimFrame(2, Frame, Duration, Dues);
			m_TextBoxFrame.SetText("Frame: " $ Frame $ "/10.0");
			// Animation 재생하도록하는 API 불러오기, 파라미터 : m_EditBoxHitTime.GetString(), m_EditBoxLoopIdx.GetString() 
			break;

		// ---------------- Simulation Tab ----------------
		case "VtxAdd_Button":
			SelectedIndex = m_ComboBoxSimulAnchorVertex.GetSelectedNum();
			class'UIDATA_PAWNVIEWER'.static.AddAnchorVertex();
			iSimulVertexNum = class'UIDATA_PAWNVIEWER'.static.GetVertexNumber();
			m_ComboBoxSimulAnchorVertex.Clear();
			for (index = 0; index < iSimulVertexNum; ++index)
			{
				m_ComboBoxSimulAnchorVertex.AddString("" $ index);
			}
			m_ComboBoxSimulAnchorVertex.SetSelectedNum(SelectedIndex);
			break;

		case "VtxRemove_Button":
			SelectedIndex = m_ComboBoxSimulAnchorVertex.GetSelectedNum();
			class'UIDATA_PAWNVIEWER'.static.RemoveAnchorVertex();
			iSimulVertexNum = class'UIDATA_PAWNVIEWER'.static.GetVertexNumber();
			m_ComboBoxSimulAnchorVertex.Clear();
			for (index = 0; index < iSimulVertexNum; ++index)
			{
				m_ComboBoxSimulAnchorVertex.AddString("" $ index);
			}
			m_ComboBoxSimulAnchorVertex.SetSelectedNum(SelectedIndex);
			break;

		case "ColAdd_Button":		
			index = m_ComboBoxSimulColType.GetSelectedNum();
			class'UIDATA_PAWNVIEWER'.static.AddCollision(m_ComboBoxSimulColType.GetString(index), float(m_EditBoxSimulBoneA.GetString()), float(m_EditBoxSimulBoneB.GetString()), float(m_EditBoxSimulRadius.GetString()), m_CheckBoxSimulSphereA.IsChecked(), m_CheckBoxSimulSphereB.IsChecked());
			SetSimulationCollisionTypeUI(index);
			break;

		case "ColRemove_Button":
			class'UIDATA_PAWNVIEWER'.static.RemoveCollision(m_ComboBoxSimulCollision.GetSelectedNum());
			SetSimulationCollisionTypeUI(0);
			break;

		case "ColUpdate_Button":
			index = m_ComboBoxSimulColType.GetSelectedNum();
			class'UIDATA_PAWNVIEWER'.static.UpdateCollision(m_ComboBoxSimulCollision.GetSelectedNum(), m_ComboBoxSimulColType.GetString(index), float(m_EditBoxSimulBoneA.GetString()), float(m_EditBoxSimulBoneB.GetString()), float(m_EditBoxSimulRadius.GetString()), m_CheckBoxSimulSphereA.IsChecked(), m_CheckBoxSimulSphereB.IsChecked());
			break;

		case "ForceAdd_Button":
			vSimulForce.X = float(m_EditBoxSimulForceX.GetString());
			vSimulForce.Y = float(m_EditBoxSimulForceY.GetString());
			vSimulForce.Z = float(m_EditBoxSimulForceZ.GetString());
			class'UIDATA_PAWNVIEWER'.static.AddAnimForce(float(m_EditBoxSimulWeight.GetString()), float(m_EditBoxSimulForceFrame.GetString()), float(m_EditBoxSimulForceStiff.GetString()), m_CheckBoxTerrainCollision.IsChecked(), m_CheckBoxUseForce.IsChecked(), vSimulForce);
			SetAnimSimulationUI(TextLoadColor);
			break;

		case "ForceRem_Button":
			class'UIDATA_PAWNVIEWER'.static.RemoveAnimForce(m_ComboBoxSimulForceIdx.GetSelectedNum());
			SetAnimSimulationUI(TextLoadColor);
			break;

		case "ForceUpdate_Button":
			vSimulForce.X = float(m_EditBoxSimulForceX.GetString());
			vSimulForce.Y = float(m_EditBoxSimulForceY.GetString());
			vSimulForce.Z = float(m_EditBoxSimulForceZ.GetString());
			class'UIDATA_PAWNVIEWER'.static.UpdateAnimForce(m_ComboBoxSimulForceIdx.GetSelectedNum(), float(m_EditBoxSimulWeight.GetString()), float(m_EditBoxSimulForceFrame.GetString()), float(m_EditBoxSimulForceStiff.GetString()), m_CheckBoxTerrainCollision.IsChecked(), m_CheckBoxUseForce.IsChecked(), vSimulForce);
			break;

		case "PlusX_Button":
			vMantleOffset.X = vMantleOffset.X + 1;
			m_EditBoxSimulMantleOffsetX.SetString("" $ vMantleOffset.X);
			class'UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			break;

		case "MinusX_Button":
			vMantleOffset.X = vMantleOffset.X - 1;
			m_EditBoxSimulMantleOffsetX.SetString("" $ vMantleOffset.X);
			class'UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			break;

		case "PlusY_Button":
			vMantleOffset.Y = vMantleOffset.Y + 1;
			m_EditBoxSimulMantleOffsetY.SetString("" $ vMantleOffset.Y);
			class'UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			break;

		case "MinusY_Button":
			vMantleOffset.Y = vMantleOffset.Y - 1;
			m_EditBoxSimulMantleOffsetY.SetString("" $ vMantleOffset.Y);
			class'UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			break;

		case "PlusZ_Button":
			vMantleOffset.Z = vMantleOffset.Z + 1;
			m_EditBoxSimulMantleOffsetZ.SetString("" $ vMantleOffset.Z);
			class'UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			break;

		case "MinusZ_Button":
			vMantleOffset.Z = vMantleOffset.Z - 1;
			m_EditBoxSimulMantleOffsetZ.SetString("" $ vMantleOffset.Z);
			class'UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			break;

		case "SimLoad_Button":
			LoadSimulationMesh();
			break;

		case "SimReset_Button":
			class'UIDATA_PAWNVIEWER'.static.ResetSimulMesh();	
			LoadSimulationMesh();
			break;

		case "SimSave_Button":
			class'UIDATA_PAWNVIEWER'.static.SaveSimulMesh();
			break;

		// ---------------- Test Tab ----------------
		case "TestStart_Button":

			class'UIDATA_PAWNVIEWER'.static.SetPawnNum(int(m_EditBoxPCNumber.GetString()));
			class'UIDATA_PAWNVIEWER'.static.SetSkillUseRatio(float(m_EditBoxSkillUse.GetString()));
			class'UIDATA_PAWNVIEWER'.static.SetSkillCancelRatio(float(m_EditBoxSkillStop.GetString()));
			class'UIDATA_PAWNVIEWER'.static.SetSkillDeleteRatio(float(m_EditBoxPCRemove.GetString()));
			class'UIDATA_PAWNVIEWER'.static.SetArrowRatio(float(m_EditBoxBowSkill.GetString()));
			class'UIDATA_PAWNVIEWER'.static.StartSimulPawn();
		
			break;

		default:
			break;
	}

}

function SetClassComboBox()
{
	local array<string> CharTypeArray;
	local int CharTypeIndex;
	local array<string> ClassNames;
	local int SelectedIndex;

	m_ComboCharType.Clear();

	class'UIDATA_PAWNVIEWER'.static.GetClassNameList(CharTypeArray, SelectedIndex);

	for (CharTypeIndex = 0; CharTypeIndex < CharTypeArray.Length; ++CharTypeIndex)
	{
		ClassNames.Length = 0;
		Split(CharTypeArray[CharTypeIndex], ".", ClassNames);
		m_ComboCharType.AddString(ClassNames[1]);
	}
	// FString
	m_ComboCharType.SetSelectedNum(SelectedIndex);

	SetBeautyComboBox(BEAUTY_FACE);
	SetBeautyComboBox(BEAUTY_HAIR);
	SetBeautyComboBox(BEAUTY_HAIRCOLOR);
}

// Item Tab Function
function SetHairAccOffset()
{
	local float OffsetX;
	local float OffsetY;
	local float OffsetZ;
	local float Pitch;
	local float Yaw;
	local float Roll;

	class'UIDATA_PAWNVIEWER'.static.GetHairAccOffset(OffsetX, OffsetY, OffsetZ, Pitch, Yaw, Roll);
	m_EditBoxHairAccOffsetX.SetString(string(OffsetX));
	m_EditBoxHairAccOffsetY.SetString(string(OffsetY));
	m_EditBoxHairAccOffsetZ.SetString(string(OffsetZ));
	m_EditBoxHairAccPitch.SetString(string(Pitch));
	m_EditBoxHairAccYaw.SetString(string(Yaw));
	m_EditBoxHairAccRoll.SetString(string(Roll));
}

// Item Tab Function
function SetBeautyComboBox(BEAUTY_TYPE type)
{
	local int index;
	local array<int> ComboBoxDataList;
	local int defaultFaceNum;	// ..\Interface\CLASSES\CharacterCreateMenuWnd.uc 참고
	local int defaultHairNum;	// ..\Interface\CLASSES\CharacterCreateMenuWnd.uc 참고
	local int defaultHairColorNum;	// ..\Interface\CLASSES\CharacterCreateMenuWnd.uc 참고
	local userInfo user;

	switch (type)
	{
		case BEAUTY_FACE:

			m_ComboFace.Clear();
			// default Face 기본 3개 
			defaultFaceNum = 3;
			for (index = 0; index < defaultFaceNum; ++index)
			{
				m_ComboFace.AddString(string(index));
			}

			class'UIDATA_PAWNVIEWER'.static.GetExceptionalFaceList(ComboBoxDataList);

			for (index = 0; index < ComboBoxDataList.Length; ++index)
			{
				m_ComboFace.AddString(string(ComboBoxDataList[index]));
			}
			m_ComboFace.SetSelectedNum(0);
			ApplyBeauty(type, int(m_ComboFace.GetString(0)));
			
			break;
		
		case BEAUTY_HAIR:

			GetPlayerInfo(user);

			m_ComboHair.Clear();

			// default Hair 남자 기본 5개 여자 기본 7개
			if (user.nSex == Sex_Male)
			{
				defaultHairNum = 5;
			}
			else
			{
				defaultHairNum = 7;
			}

			for (index = 0; index < defaultHairNum; ++index)
			{
				m_ComboHair.AddString(string(index));
			}

			class'UIDATA_PAWNVIEWER'.static.GetExceptionallHairList(ComboBoxDataList);

			for (index = 0; index < ComboBoxDataList.Length; ++index)
			{
				m_ComboHair.AddString(string(ComboBoxDataList[index]));
			}
			m_ComboHair.SetSelectedNum(0);

			ApplyBeauty(type, int(m_ComboHair.GetString(0)));
			break;
		
		case BEAUTY_HAIRCOLOR:

			m_ComboColor.Clear();

			class'UIDATA_PAWNVIEWER'.static.GetExceptionalHairColorList(ComboBoxDataList);

			for (index = 0; index < ComboBoxDataList.Length; ++index)
			{
				m_ComboColor.AddString(string(ComboBoxDataList[index]));
			}
			m_ComboColor.SetSelectedNum(0);

			if (ComboBoxDataList.Length == 0)
			{
				GetPlayerInfo(user);

				// 아르테이아와 카마엘만 3개 일반적으로는 4개
				if (user.race == RaceType_ERTHEIA || user.race == RaceType_KAMAEL)
				{
					defaultHairColorNum = 3;
				}
				else
				{
					defaultHairColorNum = 4;
				}

				for (index = 0; index < defaultHairColorNum; ++index)
				{
					m_ComboColor.AddString(string(index));
				}
			}
			
			ApplyBeauty(type, int(m_ComboHair.GetString(0)));
			break;

		default:
			return;
	}
	
}

// Item Tab Function
function ApplyBeauty(BEAUTY_TYPE type, int Value)
{
	switch (type)
	{
		case BEAUTY_FACE:
			class'UIDATA_PAWNVIEWER'.static.ApplyFace(Value);
			break;
		case BEAUTY_HAIR:
			class'UIDATA_PAWNVIEWER'.static.ApplyHair(Value);
			break;
		case BEAUTY_HAIRCOLOR:
			class'UIDATA_PAWNVIEWER'.static.ApplyHairColor(Value);
			break;
		default:
			return;
	}
	SetBeautyMeshAndTexInfo();
}

// Item Tab Function
function EquipPCItem(ItemInfo info)
{
	local Color c;
	local array<string> MeshNameList;
	local array<string> TexNameList;
	local array<string> ExMeshNameList;
	local array<string> ExTexNameList;
	local int index;
	local int MeshType;

	class'UIDATA_PAWNVIEWER'.static.EquipPCItem(info.Id);

	SetHairAccOffset();
	
	if (m_CheckBoxRefinery.IsChecked())
	{
		class'UIDATA_PAWNVIEWER'.static.ApplyItemRefinery(info.Id.ClassID, int(m_EditBoxRefineryValue1.GetString()), int(m_EditBoxRefineryValue2.GetString()));
	}
	
	if (m_CheckBoxEnchant.IsChecked())
	{
		class'UIDATA_PAWNVIEWER'.static.ApplyItemEnchanted(info.Id.ClassID, int(m_EditBoxEnchantValue.GetString()));
	}

	m_ListBoxItemPath.Clear();

	MeshType = class'UIDATA_PLAYER'.static.GetMeshType();

	c.R = 255;
	c.G = 255;
	c.B = 150;

	class'UIDATA_ITEM'.static.GetTextureName(info.Id, MeshType, TexNameList);
	for (index = 0; index < TexNameList.Length; ++index)
	{
		m_ListBoxItemPath.AddStringWithData(TexNameList[index], c, 0);
	}

	c.R = 255;
	c.G = 255;
	c.B = 200;

	class'UIDATA_ITEM'.static.GetExTextureName(info.Id, MeshType, ExTexNameList);
	for (index = 0; index < ExTexNameList.Length; ++index)
	{
		m_ListBoxItemPath.AddStringWithData(ExTexNameList[index] $ "(Extra)", c, 0);
	}

	c.R = 255;
	c.G = 150;
	c.B = 255;

	class'UIDATA_ITEM'.static.GetMeshName(info.Id, MeshType, MeshNameList);
	for (index = 0; index < MeshNameList.Length; ++index)
	{
		m_ListBoxItemPath.AddStringWithData(MeshNameList[index], c, 0);
	}

	c.R = 255;
	c.G = 200;
	c.B = 255;

	class'UIDATA_ITEM'.static.GetExMeshName(info.Id, MeshType, ExMeshNameList);
	for (index = 0; index < ExMeshNameList.Length; ++index)
	{
		m_ListBoxItemPath.AddStringWithData(ExMeshNameList[index] $ "(Extra)", c, 0);
	}

}

// Item Tab Function
function SetBeautyMeshAndTexInfo()
{
	local Color c;
	
	m_ListBoxBeautyInfo.Clear();
	FaceMeshName = "";
	FaceTexName = "";
	AHairMeshName = "";
	AHairTexName = "";
	BHairMeshName = "";
	BHairTexName = "";
	BHairExSubTexName = "";

	class'UIDATA_PAWNVIEWER'.static.GetFaceInfo(FaceMeshName, FaceTexName);
	class'UIDATA_PAWNVIEWER'.static.GetAHairInfo(AHairMeshName, AHairTexName);
	class'UIDATA_PAWNVIEWER'.static.GetBHairInfo(BHairMeshName, BHairTexName, BHairExSubTexName);

	c.R = 255;
	c.G = 255;
	c.B = 150;
	m_ListBoxBeautyInfo.AddStringWithData(FaceMeshName, c, 0);
	m_ListBoxBeautyInfo.AddStringWithData(FaceTexName, c, 0);

	c.R = 255;
	c.G = 150;
	c.B = 255;
	m_ListBoxBeautyInfo.AddStringWithData(AHairMeshName, c, 0);
	m_ListBoxBeautyInfo.AddStringWithData(AHairTexName, c, 0);

	c.R = 150;
	c.G = 255;
	c.B = 255;
	m_ListBoxBeautyInfo.AddStringWithData(BHairMeshName, c, 0);
	m_ListBoxBeautyInfo.AddStringWithData(BHairTexName, c, 0);
	m_ListBoxBeautyInfo.AddStringWithData(BHairExSubTexName, c, 0);

}

// Item Tab Function
function SearchItem(string strSearch)
{
	local ItemID cID;
	local string ItemName;
	local ItemInfo ItemInfo;
	local bool bFindItem;

	m_ItemWindowPCItem.Clear();

	for (cID = class'UIDATA_ITEM'.static.GetFirstID(); IsValidItemID(cID); cID = class'UIDATA_ITEM'.static.GetNextID())
	{
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
			class'UIDATA_ITEM'.static.GetItemInfo(cID, ItemInfo);
			ItemInfo.ShortcutType = int(EShortCutItemType.SCIT_ITEM);
			m_ItemWindowPCItem.AddItem(ItemInfo);
		}
	}
}

// Animation Tab Function 
function SearchAnimation(string str)
{
	local array<string> AnimList;
	local int index;

	m_ListBoxAnim.Clear();
	class'UIDATA_PAWNVIEWER'.static.GetPCAnimationList(AnimList);
	// sorting Alphabet
	AnimList.Sort(SortByNameDelegate);

	for (index = 0; index < AnimList.Length; ++index)
	{
		if (str == "")
		{
			m_ListBoxAnim.AddString(AnimList[index]);
		}
		else if (StringMatching(AnimList[index], str, " "))
		{
			m_ListBoxAnim.AddString(AnimList[index]);
		}
	}

}

delegate int SortByNameDelegate(string name0, string name1)
{
	// End:0x21
	if(ToUpper(name0) > ToUpper(name1))
	{
		return -1;
	}
	return 0;	
}

// Simulation Tab Function 
function LoadSimulationMesh()
{
	local Color TextLoadColor;

	TextLoadColor.R = 255;
	TextLoadColor.G = 255;
	TextLoadColor.B = 150;

	class'UIDATA_PAWNVIEWER'.static.LoadSimulMesh();

	SetSimulationMeshUI(TextLoadColor);
	SetSimulationCollisionTypeUI(0);
	SetSimulationCollisionUI(0);
	SetAnimSimulationUI(TextLoadColor);
	SetMantleOffsetUI(TextLoadColor);

}

function SetSimulationMeshUI(Color TextLoadColor)
{
	local int index;
	local string SimulMeshName;

	SimulMeshName = class'UIDATA_PAWNVIEWER'.static.GetSimulMeshName();
	m_TextBoxSimulationMeshName.SetText(SimulMeshName);
	m_TextBoxSimulationMeshName.SetTextColor(TextLoadColor);

	iSimulVertexNum = class'UIDATA_PAWNVIEWER'.static.GetVertexNumber();
	m_ComboBoxSimulAnchorVertex.Clear();
	for (index = 0; index < iSimulVertexNum; ++index)
	{
		m_ComboBoxSimulAnchorVertex.AddString("" $ index);
	}
	m_ComboBoxSimulAnchorVertex.SetSelectedNum(0);

}

function SetSimulationCollisionTypeUI(int CollisionTypeIndex)
{
	local int index;

	SimulColTypeList.Length = 0;
	iSimulColNum = class'UIDATA_PAWNVIEWER'.static.GetCollisionNumber();
	class'UIDATA_PAWNVIEWER'.static.GetCollisionType(SimulColTypeList);
	m_ComboBoxSimulCollision.Clear();
	for (index = 0; index < iSimulColNum; ++index)
	{
		m_ComboBoxSimulCollision.AddString("" $ index);
	}
	m_ComboBoxSimulCollision.SetSelectedNum(CollisionTypeIndex);
}

function SetSimulationCollisionUI(int CollisionIndex)
{
	local int index;
	local int ColTypeIndex;

	ColTypeIndex = 0;
	class'UIDATA_PAWNVIEWER'.static.GetCollisionInfo(CollisionIndex, sSimulColType, iSimulBoneA, iSimulBoneB, fSimulRadius, bSimulSphereA, bSimulSphereB);
	
	m_ComboBoxSimulColType.Clear();
	for (index = 0; index < SimulColTypeList.Length; ++index)
	{
		if (sSimulColType == SimulColTypeList[index])
			ColTypeIndex = index;
		m_ComboBoxSimulColType.AddString("" $ SimulColTypeList[index]);
	}
	m_ComboBoxSimulColType.SetSelectedNum(ColTypeIndex);

	m_EditBoxSimulBoneA.SetString("" $ iSimulBoneA);
	m_EditBoxSimulBoneB.SetString("" $ iSimulBoneB);
	m_EditBoxSimulRadius.SetString("" $ fSimulRadius);
	m_CheckBoxSimulSphereA.SetCheck(bool(bSimulSphereA));
	m_CheckBoxSimulSphereB.SetCheck(bool(bSimulSphereB));
}

function SetAnimSimulationUI(Color TextLoadColor)
{
	local int index;
	local string SimulAnimName;

	iSimulAnimNum = class'UIDATA_PAWNVIEWER'.static.GetAnimForceNumber();
	
	//iSimulWeight = 0.3f;
	//fSimulFrame = -1.f;
	//fSimulStiff = 0.85f;
	//bSimulTerrainCol = 1;
	//bSimulUserForce = 1;
	//vSimulForce.X = 0;
	//vSimulForce.Y = -10.f;
	//vSimulForce.Z = -50.f;

	m_TextBoxSimulAnimSequence.SetText(SimulAnimName);
	m_TextBoxSimulAnimSequence.SetTextColor(TextLoadColor);

	m_ComboBoxSimulForceIdx.Clear();
	for (index = 0; index < iSimulAnimNum; ++index)
	{
		m_ComboBoxSimulForceIdx.AddString("" $ index);
	}
	m_ComboBoxSimulForceIdx.SetSelectedNum(0);

	class'UIDATA_PAWNVIEWER'.static.GetAnimForceInfo(0, iSimulWeight, fSimulFrame, fSimulStiff, bSimulTerrainCol, bSimulUserForce, vSimulForce);

	m_EditBoxSimulWeight.SetString("" $ iSimulWeight);
	m_EditBoxSimulForceFrame.SetString("" $ fSimulFrame);
	m_EditBoxSimulForceStiff.SetString("" $ fSimulStiff);
	m_CheckBoxTerrainCollision.SetCheck(bool(bSimulTerrainCol));
	m_CheckBoxUseForce.SetCheck(bool(bSimulUserForce));
	m_EditBoxSimulForceX.SetString("" $ vSimulForce.X);
	m_EditBoxSimulForceY.SetString("" $ vSimulForce.Y);
	m_EditBoxSimulForceZ.SetString("" $ vSimulForce.Z);

}

function SetMantleOffsetUI(Color TextLoadColor)
{
	sChestMeshName = class'UIDATA_PAWNVIEWER'.static.GetChestMesh();
	vMantleOffset = class'UIDATA_PAWNVIEWER'.static.GetMantleOffset();
	
	m_TextBoxSimulMantleOffset.SetText(sChestMeshName);
	m_TextBoxSimulMantleOffset.SetTextColor(TextLoadColor);
	m_EditBoxSimulMantleOffsetX.SetString("" $ vMantleOffset.X);
	m_EditBoxSimulMantleOffsetY.SetString("" $ vMantleOffset.Y);
	m_EditBoxSimulMantleOffsetZ.SetString("" $ vMantleOffset.Z);
}

function ReloadPCViewerWnd()
{
	// XML로 convert 하기전 PCViewerWnd가 존재 했을 떄 기존의 기능
	// 1. PCViewerWnd와 그 ChildWnd들을 제거 한다. 
	// 2. PCViewerWnd를 다시 생성힌다.
	// 3. PCViewerWnd의 위치를 원래의 위치로 재조정해준다. 
	// XML로 convert 한 이후로는 하나의 윈도우를 삭제하고 다시 생성해주는 것은
	// 코드를 새로 만들어 주어야 하는 일이므로 Reset과 같은 기능으로 기능을 조금 수정해 주어야 할 것 같다. 
	//

	m_hWnd.SetAnchor("", "TopLeft", "TopLeft", 24, 4);
	m_ItemWindowPCItem.Clear();
}

defaultproperties
{
     m_WindowName="PCViewerWnd"
}
