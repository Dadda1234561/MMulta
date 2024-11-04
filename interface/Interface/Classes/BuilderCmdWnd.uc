class BuilderCmdWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;

var ButtonHandle collision_button;
var ButtonHandle npcinfo_button;
var ButtonHandle stat_button;
var ButtonHandle rmode_button;
var ButtonHandle init_button;
var CheckBoxHandle m_CheckBoxBoneName;
var ComboBoxHandle m_ComboBoneName;
var ComboBoxHandle Reload_ComboBox;
var ButtonHandle Reload_button;

var ButtonHandle AVE_addButton;
var ButtonHandle AVE_delButton;
var ButtonHandle AVE_clearButton;
var ButtonHandle NpcSummon_Button;
var ButtonHandle UseSkill_button;
var ButtonHandle DefaultNpc_button;
var ButtonHandle ComeOn_button;
var ButtonHandle KillNpc_button;
var ButtonHandle SetParam_button;

var ButtonHandle SetSpeed_button;
var ButtonHandle SetRace_button;
var ButtonHandle Clone_button;
var ButtonHandle JobTree_button;
var ButtonHandle Search_button;

var ButtonHandle distance_button;
var ButtonHandle skillMaster_button;
var ButtonHandle itemMaster_button;
var ButtonHandle dex_1_button;
var ButtonHandle dex_2_button;
var ButtonHandle dex_3_button;
var ButtonHandle resetSkill_button;
var ButtonHandle allSkill_button;
var ButtonHandle yebis_button;
var EditBoxHandle AveId_EditBox;
var EditBoxHandle NpcId_EditBox;
var EditBoxHandle SkillId_EditBox;
var EditBoxHandle Param_EditBox;

var EditBoxHandle Speed_EditBox;
var SliderCtrlHandle sliderShowRange;
var TextBoxHandle txtShowRange;
var SliderCtrlHandle sliderSetTime;
var TextBoxHandle txtSetTime;
var CheckBoxHandle checkBoxRange;
var CheckBoxHandle checkBoxSetTime;

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("BuilderCmdWnd");
	// End:0x57
	if(getInstanceUIData().getIsLiveServer())
	{
		setWindowTitleByString("BuilderCommand" @ "(Live)");		
	}
	else
	{
		// End:0x8D
		if(getInstanceUIData().IsAdenServer())
		{
			setWindowTitleByString("BuilderCommand" @ "(Aden)");			
		}
		else
		{
			setWindowTitleByString("BuilderCommand" @ "(Classic)");
		}
	}
	collision_button = GetButtonHandle(m_WindowName $ ".collision_button");
	npcinfo_button = GetButtonHandle(m_WindowName $ ".npcinfo_button");
	stat_button = GetButtonHandle(m_WindowName $ ".stat_button");
	rmode_button = GetButtonHandle(m_WindowName $ ".rmode_button");
	init_button = GetButtonHandle(m_WindowName $ ".init_button");
	distance_button = GetButtonHandle(m_WindowName $ ".distance_button");
	m_CheckBoxBoneName = GetCheckBoxHandle(m_WindowName $ ".BoneName_CheckBox");
	m_ComboBoneName = GetComboBoxHandle(m_WindowName $ ".BoneName_ComboBox");
	Reload_ComboBox = GetComboBoxHandle(m_WindowName $ ".Reload_ComboBox");
	Reload_ComboBox.AddString("AVE");
	Reload_ComboBox.AddString("AdditionalEffect");
	Reload_ComboBox.AddString("ArmorGrp");
	Reload_ComboBox.AddString("WeaponGrp");
	Reload_ComboBox.AddString("EtcItemGrp");
	Reload_ComboBox.AddString("SkillGrp");
	Reload_ComboBox.AddString("NpcGrp");
	Reload_ComboBox.AddString("HairExGrp");
	Reload_ComboBox.AddString("FaceExGrp");
	Reload_ComboBox.AddString("----------------");
	Reload_ComboBox.AddString("Effect");
	Reload_ComboBox.AddString("SkillEffect");
	Reload_ComboBox.AddString("LineageNpc");
	Reload_ComboBox.AddString("LineageMonster");
	Reload_ComboBox.AddString("LineageWarrior");
	Reload_ComboBox.AddString("----------------");
	Reload_ComboBox.AddString("Skill_Data");
	Reload_ComboBox.AddString("Item_Data");
	Reload_ComboBox.AddString("Npc_Data");
	AVE_addButton = GetButtonHandle(m_WindowName $ ".AVE_addButton");
	AVE_delButton = GetButtonHandle(m_WindowName $ ".AVE_delButton");
	AVE_clearButton = GetButtonHandle(m_WindowName $ ".AVE_delButton");
	AveId_EditBox = GetEditBoxHandle(m_WindowName $ ".AveId_EditBox");
	AveId_EditBox.SetString("17");
	NpcSummon_Button = GetButtonHandle(m_WindowName $ ".NpcSummon_Button");
	NpcId_EditBox = GetEditBoxHandle(m_WindowName $ ".NpcId_EditBox");
	// End:0x50D
	if(getInstanceUIData().getIsLiveServer())
	{
		NpcId_EditBox.SetString("18912");		
	}
	else if(getInstanceUIData().IsAdenServer())		
	{
		NpcId_EditBox.SetString("18002");			
	}
	else
	{
		NpcId_EditBox.SetString("18002");
	}
	UseSkill_button = GetButtonHandle(m_WindowName $ ".UseSkill_button");
	SkillId_EditBox = GetEditBoxHandle(m_WindowName $ ".SkillId_EditBox");
	SkillId_EditBox.SetString("129 1 0");
	DefaultNpc_button = GetButtonHandle(m_WindowName $ ".DefaultNpc_button");
	ComeOn_button = GetButtonHandle(m_WindowName $ ".ComeOn_button");
	KillNpc_button = GetButtonHandle(m_WindowName $ ".KillNpc_button");
	SetParam_button = GetButtonHandle(m_WindowName $ ".SetParam_button");
	SetSpeed_button = GetButtonHandle(m_WindowName $ ".SetSpeed_button");
	Search_button = GetButtonHandle(m_WindowName $ ".search_button");
	Param_EditBox = GetEditBoxHandle(m_WindowName $ ".Param_EditBox");
	Param_EditBox.SetString("lv 85");
	Speed_EditBox = GetEditBoxHandle(m_WindowName $ ".Speed_EditBox");
	Speed_EditBox.SetString("2");
	Clone_button = GetButtonHandle(m_WindowName $ ".Clone_button");
	JobTree_button = GetButtonHandle(m_WindowName $ ".JobTree_button");
	sliderShowRange = GetSliderCtrlHandle(m_WindowName $ ".sliderShowRange");
	txtShowRange = GetTextBoxHandle(m_WindowName $ ".txtShowRange");
	checkBoxRange = GetCheckBoxHandle(m_WindowName $ ".checkBoxRange");
	sliderSetTime = GetSliderCtrlHandle(m_WindowName $ ".sliderSetTime");
	txtSetTime = GetTextBoxHandle(m_WindowName $ ".txtSetTime");
	checkBoxSetTime = GetCheckBoxHandle(m_WindowName $ ".checkBoxSetTime");
	skillMaster_button = GetButtonHandle(m_WindowName $ ".skillMaster_button");
	itemMaster_button = GetButtonHandle(m_WindowName $ ".itemMaster_button");
	dex_1_button = GetButtonHandle(m_WindowName $ ".dex_1_button");
	dex_2_button = GetButtonHandle(m_WindowName $ ".dex_2_button");
	dex_3_button = GetButtonHandle(m_WindowName $ ".dex_3_button");
}

function OnClickReloadButton()
{
	local int Selected;
	Selected = Reload_ComboBox.GetSelectedNum();
	switch(Selected)
	{
		// End:0x38
		case 0:
		//AbnormalDefaultEffect
		//AbnormalEdgeEffectData
		//EventLookChange
			ExecuteCommand("///ave_reload");
			// End:0x25C
			break;
		// End:0x61
		case 1:
			ExecuteCommand("///additionaleffect_reload");
			// End:0x25C
			break;
		// End:0x83
		case 2:
			ExecuteCommand("///armorgrp_reload");
			// End:0x25C
			break;
		// End:0xA6
		case 3:
			ExecuteCommand("///weapongrp_reload");
			// End:0x25C
			break;
		// End:0xCA
		case 4:
			ExecuteCommand("///etcitemgrp_reload");
			// End:0x25C
			break;
		// End:0xEC
		case 5:
			ExecuteCommand("///skillgrp_reload");
			// End:0x25C
			break;
		// End:0x10C
		case 6:
			ExecuteCommand("///npcgrp_reload");
			// End:0x25C
			break;
		// End:0x12F
		case 7:
			ExecuteCommand("///hairexgrp_reload");
			// End:0x25C
			break;
		// End:0x152
		case 8:
			ExecuteCommand("///faceexgrp_reload");
			// End:0x25C
			break;
		// End:0x15A
		case 9:
			// End:0x25C
			break;
		// End:0x174
		case 10:
			ExecuteCommand("///reloade");
			// End:0x25C
			break;
		// End:0x18F
		case 11:
			ExecuteCommand("///reloadse");
			// End:0x25C
			break;
		// End:0x1AB
		case 12:
			ExecuteCommand("///reloadnpc");
			// End:0x25C
			break;
		// End:0x1CB
		case 13:
			ExecuteCommand("///reloadmonster");
			// End:0x25C
			break;
		// End:0x1EB
		case 14:
			ExecuteCommand("///reloadwarrior");
			// End:0x25C
			break;
		// End:0x1F3
		case 15:
			// End:0x25C
			break;
		// End:0x216
		case 16:
			ExecuteCommand("//reload_skill_data");
			// End:0x25C
			break;
		// End:0x238
		case 17:
			ExecuteCommand("//reload_item_data");
			// End:0x25C
			break;
		// End:0x259
		case 18:
			ExecuteCommand("//reload_npc_data");
			// End:0x25C
			break;
	}
}

function OnClickButton(string a_ButtonID)
{
	switch(a_ButtonID)
	{
		// End:0x22
		case "Reload_button":
			OnClickReloadButton();
			// End:0x6E4
			break;
		// End:0x4F
		case "collision_button":
			ExecuteCommand("///show radii");
			// End:0x6E4
			break;
		// End:0x76
		case "npcinfo_button":
			ExecuteCommand("//debug .");
			// End:0x6E4
			break;
		// End:0xA0
		case "nameTag_button":
			ExecuteCommand("///show name");
			// End:0x6E4
			break;
		// End:0xC5
		case "stat_button":
			ExecuteCommand("///stat l2");
			// End:0x6E4
			break;
		// End:0x152
		case "rmode_button":
			// End:0x123
			if(rmode_button.GetButtonName() == "Wireframe")
			{
				ExecuteCommand("///rmode 1");
				rmode_button.SetNameText("Lighting");
			}
			else
			{
				ExecuteCommand("///rmode 5");
				rmode_button.SetNameText("Wireframe");
			}
			// End:0x6E4
			break;
		// End:0x19D
		case "init_button":
			ExecuteCommand("//hide off");
			ExecuteCommand("//undying on");
			ExecuteCommand("///autocom");
			// End:0x6E4
			break;
		// End:0x1D6
		case "AVE_addButton":
			ExecuteCommand("///aa type=" @ AveId_EditBox.GetString());
			// End:0x6E4
			break;
		// End:0x20F
		case "AVE_delButton":
			ExecuteCommand("///da type=" @ AveId_EditBox.GetString());
			// End:0x6E4
			break;
		// End:0x23D
		case "AVE_clearButton":
			ExecuteCommand("///aa type=none");
			// End:0x6E4
			break;
		// End:0x279
		case "NpcSummon_Button":
			ExecuteCommand("//summon 10" $ NpcId_EditBox.GetString());
			// End:0x6E4
			break;
		// End:0x2B8
		case "UseSkill_Button":
			ExecuteCommand("//npc_use_skill" @ SkillId_EditBox.GetString());
			// End:0x6E4
			break;
		// End:0x2EC
		case "DefaultNpc_button":
			ExecuteCommand("//setai default_npc");
			// End:0x6E4
			break;
		// End:0x317
		case "ComeOn_Button":
			ExecuteCommand("//come_to_me 1");
			// End:0x6E4
			break;
		// End:0x33E
		case "KillNpc_Button":
			ExecuteCommand("//killnpc");
			// End:0x6E4
			break;
		// End:0x379
		case "SetParam_button":
			ExecuteCommand("//setparam " @ Param_EditBox.GetString());
			// End:0x6E4
			break;
		// End:0x3A9
		case "dex_1_button":
			ExecuteCommand("//setparam_me dex 50");
			// End:0x6E4
			break;
		// End:0x3DA
		case "dex_2_button":
			ExecuteCommand("//setparam_me dex 100");
			// End:0x6E4
			break;
		// End:0x40B
		case "dex_3_button":
			ExecuteCommand("//setparam_me dex 200");
			// End:0x6E4
			break;
		// End:0x444
		case "SetSpeed_button":
			ExecuteCommand("//gmspeed" @ Speed_EditBox.GetString());
			// End:0x6E4
			break;
		// End:0x475
		case "Clone_button":
			ExecuteCommand("///spawnpc copy num=1");
			// End:0x6E4
			break;
		// End:0x4B2
		case "JobTree_button":
			ExecuteCommand("/target %self");
			ShowWindow("JobTreeWnd");
			// End:0x6E4
			break;
		// End:0x4DE
		case "Search_button":
			ExecuteCommand("///searchobject");
			// End:0x6E4
			break;
		// End:0x507
		case "Distance_button":
			ExecuteCommand("//distance");
			// End:0x6E4
			break;
		// End:0x54A
		case "resetSkill_button":
			ExecuteCommand("/target %self");
			ExecuteCommand("//reset_skill");
			// End:0x6E4
			break;
		// End:0x57B
		case "allSkill_button":
			ExecuteCommand("//set_skill_all_me");
			// End:0x6E4
			break;
		// End:0x631
		case "skillMaster_button":
			// End:0x5F5
			if(skillMaster_button.GetButtonName() == "SkillMaster On")
			{
				ExecuteCommand("//skill_master on");
				skillMaster_button.SetNameText("SkillMaster Off");
				// End:0x6E4
				break;				
			}
			else
			{
				ExecuteCommand("//skill_master off");
				skillMaster_button.SetNameText("SkillMaster On");
				// End:0x6E4
				break;
			}
		// End:0x6E1
		case "itemMaster_button":
			// End:0x6A7
			if(itemMaster_button.GetButtonName() == "ItemMaster On")
			{
				ExecuteCommand("//item_master on");
				itemMaster_button.SetNameText("ItemMaster Off");
				// End:0x6E4
				break;				
			}
			else
			{
				ExecuteCommand("//item_master off");
				itemMaster_button.SetNameText("ItemMaster On");
				// End:0x6E4
				break;
			}
		// End:0x713
		case "yebis_button":
			ExecuteCommand("///sw name=YebisCmdWnd");
			// End:0x716
			break;
	}
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local float ftime;
	local int Range;

	switch(strID)
	{
		// End:0x81
		case "sliderShowRange":
			Range = (sliderShowRange.GetCurrentTick() * 10) + 10;
			txtShowRange.SetText(string(Range));
			// End:0x7E
			if(checkBoxRange.IsChecked())
			{
				ExecuteCommand("///show_range" @ string(Range));
			}
			// End:0xEA
			break;
		// End:0xE7
		case "sliderSetTime":
			// End:0xE4
			if(checkBoxSetTime.IsChecked())
			{
				ftime = float(sliderSetTime.GetCurrentTick()) / 10.f;
				SetEnvTime(ftime);
				txtSetTime.SetText(string(ftime));
			}
			break;
	}
}
function OnComboBoxItemSelected(string strID, int IndexID)
{
	switch(strID)
	{
		// End:0xA4
		case "BoneName_ComboBox":
			// End:0x7E
			if(IndexID == 0)
			{
				// End:0x7B
				if(m_CheckBoxBoneName.IsChecked())
				{
					ExecuteCommand("///rend reset");
					ExecuteCommand("///rend bone");
					ExecuteCommand("///rend bonename");
				}
			}
			else
			{
				class'UIDATA_PAWNVIEWER'.static.ShowSelectedBone(m_ComboBoneName.GetString(IndexID));
			}
			// End:0xAA
			break;
	}
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "BoneName_CheckBox":
			if(m_CheckBoxBoneName.IsChecked())
			{
				ExecuteCommand("///rend bone");
				ExecuteCommand("///rend bonename");
			}
			else
			{
				ExecuteCommand("///rend reset");
			}
			SetBoneList();
			break;
		case "checkBoxRange":
			// End:0xC9
			if(checkBoxRange.IsChecked())
			{
				ExecuteCommand("///show_range" @ txtShowRange.GetText());				
			}
			else
			{
				ExecuteCommand("///show_range none");
			}
			// End:0xE9
			break;
	}
}

function SetBoneList()
{
	local array<string> BoneNameList;
	local int Index;

	m_ComboBoneName.Clear();
	m_ComboBoneName.AddString("Show All Bones");
	if(m_CheckBoxBoneName.IsChecked())
	{
		class'UIDATA_PAWNVIEWER'.static.GetBoneNameList(BoneNameList);
		for(Index = 0; index < BoneNameList.Length; Index++)
		{
			m_ComboBoneName.AddString(BoneNameList[Index]);
		}
	}
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_WindowName="BuilderCmdWnd"
}
