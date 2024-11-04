class PVBuilderCmdWnd extends UICommonAPI;

//const DIALOGID_Gohome = 0;

var string m_WindowName;
var WindowHandle Me;

var ButtonHandle collision_button;
var ButtonHandle nameTag_button;
//var ButtonHandle stat_button;
var ButtonHandle rmode_button;
var ButtonHandle option_button;

// CheckBox For Show BoneName
var CheckBoxHandle m_CheckBoxBoneName;
// ComboBox For BoneName
var ComboBoxHandle m_ComboBoneName;

var ComboBoxHandle Reload_ComboBox;
var ButtonHandle Reload_button;

var ButtonHandle AVE_addButton;
var ButtonHandle AVE_delButton;
var ButtonHandle AVE_clearButton;
var ButtonHandle Effect_button;
var ButtonHandle Ride_button;
var ButtonHandle SetSpeed_button;
var ButtonHandle Teleport_button;

var ButtonHandle playermove_button;
var ButtonHandle ghost_button;
var ButtonHandle clone_button;
var ButtonHandle pv_button;
var ButtonHandle nv_button;
var ButtonHandle sv_button;
var ButtonHandle sc_button;
var ButtonHandle search_button;
var ButtonHandle minimap_button;
var ButtonHandle yb_button;
var ButtonHandle ui_button;
var ComboBoxHandle Location_ComboBox;
var EditBoxHandle AveId_EditBox;
var EditBoxHandle Effect_EditBox;
var EditBoxHandle RideId_EditBox;
var EditBoxHandle OffsetX_EditBox;
var EditBoxHandle OffsetY_EditBox;
var EditBoxHandle OffsetZ_EditBox;
var EditBoxHandle Pitch_EditBox;
var EditBoxHandle Yaw_EditBox;
var EditBoxHandle Roll_EditBox;

var EditBoxHandle Speed_EditBox;
var EditBoxHandle TelX_EditBox;
var EditBoxHandle TelY_EditBox;
var EditBoxHandle TelZ_EditBox;
var EditBoxHandle Player_EditBox;
var SliderCtrlHandle sliderShowRange;
var TextBoxHandle txtShowRange;
var SliderCtrlHandle sliderSetTime;
var TextBoxHandle txtSetTime;
var CheckBoxHandle checkBoxRange;
var CheckBoxHandle checkBoxSetTime;

function OnLoad()
{
	local string pawnViewerMode;

	SetClosingOnESC();
	Me = GetWindowHandle( "PVBuilderCmdWnd" );
	// End:0x80
	if(GetINIString("URL", "L2PawnViewerMode", pawnViewerMode, "l2.ini"))
	{
		Me.SetWindowTitle("BuilderCommand" @ "(" $ pawnViewerMode $ ")");
	}
	collision_button = GetButtonHandle( m_WindowName$".collision_button" );
	nameTag_button = GetButtonHandle( m_WindowName$".nameTag_button" );
	rmode_button = GetButtonHandle( m_WindowName$".Group1.rmode_button" );

	m_CheckBoxBoneName = GetCheckBoxHandle(m_WindowName$".BoneName_CheckBox");
	m_ComboBoneName = GetComboBoxHandle(m_WindowName$".BoneName_ComboBox");

	Reload_ComboBox = GetComboBoxHandle( m_WindowName$".Reload_ComboBox" );
	Reload_ComboBox.AddString("AVE");
	Reload_ComboBox.AddString("AdditionalEffect");
	Reload_ComboBox.AddString("ArmorGrp");
	Reload_ComboBox.AddString("WeaponGrp");
	Reload_ComboBox.AddString("SkillGrp");
	Reload_ComboBox.AddString("NpcGrp");
	Reload_ComboBox.AddString("HairExGrp");
	Reload_ComboBox.AddString("FaceExGrp");
	Reload_ComboBox.AddString("CharGrp");
	Reload_ComboBox.AddString("----------------");
	Reload_ComboBox.AddString("Effect");
	Reload_ComboBox.AddString("SkillEffect");
	Reload_ComboBox.AddString("LineageNpc");
	Reload_ComboBox.AddString("LineageMonster");
	Reload_ComboBox.AddString("LineageWarrior");

	AVE_addButton = GetButtonHandle( m_WindowName$".AVE_addButton" );
	AVE_delButton = GetButtonHandle( m_WindowName$".AVE_delButton" );
	AVE_clearButton = GetButtonHandle( m_WindowName$".AVE_delButton" );
	Effect_button = GetButtonHandle( m_WindowName$".Effect_button" );
	Ride_button = GetButtonHandle( m_WindowName$".Ride_button" );
	SetSpeed_button = GetButtonHandle( m_WindowName$".SetSpeed_button" );
	Teleport_button = GetButtonHandle( m_WindowName$".Teleport_button" );

	playermove_button = GetButtonHandle( m_WindowName$".playermove_button" );
	ghost_button = GetButtonHandle( m_WindowName$".ghost_button" );
	clone_button = GetButtonHandle( m_WindowName$".clone_button" );
	option_button = GetButtonHandle( m_WindowName$".option_button" );

	Location_ComboBox = GetComboBoxHandle( m_WindowName$".Location_ComboBox" );
	Location_ComboBox.SYS_AddString(1048);
	Location_ComboBox.SYS_AddString(1049);
	Location_ComboBox.AddString("EmptySite");
	Location_ComboBox.AddString("KrumaTower");
	AveId_EditBox = GetEditBoxHandle( m_WindowName$".AveId_EditBox" );
	AveId_EditBox.SetString("17");
	Effect_EditBox = GetEditBoxHandle( m_WindowName$".Effect_EditBox" );
	Effect_EditBox.SetString("z_ice_screen_f");
	RideId_EditBox = GetEditBoxHandle( m_WindowName$".RideId_EditBox" );
	RideId_EditBox.SetString("13330");

	OffsetX_EditBox = GetEditBoxHandle( m_WindowName$".OffsetX_EditBox" );
	OffsetY_EditBox = GetEditBoxHandle( m_WindowName$".OffsetY_EditBox" );
	OffsetZ_EditBox = GetEditBoxHandle( m_WindowName$".OffsetZ_EditBox" );
	Pitch_EditBox = GetEditBoxHandle( m_WindowName$".Pitch_EditBox" );
	Yaw_EditBox = GetEditBoxHandle( m_WindowName$".Yaw_EditBox" );
	Roll_EditBox = GetEditBoxHandle( m_WindowName$".Roll_EditBox" );
	OffsetX_EditBox.SetString("0");
	OffsetY_EditBox.SetString("0");
	OffsetZ_EditBox.SetString("0");
	Pitch_EditBox.SetString("0");
	Yaw_EditBox.SetString("0");
	Roll_EditBox.SetString("0");

	Speed_EditBox = GetEditBoxHandle( m_WindowName$".Speed_EditBox" );
	Speed_EditBox.SetString("10");
	TelX_EditBox = GetEditBoxHandle( m_WindowName$".TelX_EditBox" );
	TelY_EditBox = GetEditBoxHandle( m_WindowName$".TelY_EditBox" );
	TelZ_EditBox = GetEditBoxHandle( m_WindowName$".TelZ_EditBox" );
	TelX_EditBox.SetString("-114357");
	TelY_EditBox.SetString("252750");
	TelZ_EditBox.SetString("-1545");
	Player_EditBox = GetEditBoxHandle( m_WindowName$".Player_EditBox" );
	Player_EditBox.SetString("1");
	sliderSetTime = GetSliderCtrlHandle( m_WindowName$".sliderSetTime" );
	txtSetTime  =  GetTextBoxHandle ( m_WindowName$".txtSetTime" );
	checkBoxSetTime = GetCheckBoxHandle( m_WindowName$".checkBoxSetTime" );
	sliderShowRange = GetSliderCtrlHandle(m_WindowName $ ".sliderShowRange");
	txtShowRange = GetTextBoxHandle(m_WindowName $ ".txtShowRange");
	checkBoxRange = GetCheckBoxHandle(m_WindowName $ ".checkBoxRange");
	pv_button = GetButtonHandle( m_WindowName$".pv_button" );
	nv_button = GetButtonHandle( m_WindowName$".nv_button" );
	sv_button = GetButtonHandle( m_WindowName$".sv_button" );
	sc_button = GetButtonHandle( m_WindowName$".sc_button" );
	search_button = GetButtonHandle( m_WindowName$".search_button" );
	minimap_button = GetButtonHandle( m_WindowName$".minimap_button" );
	ExecuteCommand("///settime time=12");
	yb_button = GetButtonHandle(m_WindowName $ ".yb_button");
	ui_button = GetButtonHandle(m_WindowName $ ".ui_button");
}

function OnClickReloadButton()
{
	local int selected;
	selected = Reload_ComboBox.GetSelectedNum();
	switch(selected)
	{
		//client script
		case 0:
		//AbnormalDefaultEffect
		//AbnormalEdgeEffectData
		//EventLookChange
			ExecuteCommand("///ave_reload");
			break;
		case 1:
			ExecuteCommand("///additionaleffect_reload");
			break;
		case 2:
			ExecuteCommand("///armorgrp_reload");
			break;
		case 3:
			ExecuteCommand("///weapongrp_reload");
			break;
		case 4:
			ExecuteCommand("///skillgrp_reload");
			break;
		case 5:
			ExecuteCommand("///npcgrp_reload");
			break;
		case 6:
			ExecuteCommand("///hairexgrp_reload");
			break;
		case 7:
			ExecuteCommand("///faceexgrp_reload");
			break;
		case 8:
			ExecuteCommand("///chargrp_reload");
			break;
		case 9:
			break;
		//uc
		case 10:
			ExecuteCommand("///reloade");
			break;
		case 11:
			ExecuteCommand("///reloadse");
			break;
		case 12:
			ExecuteCommand("///reloadnpc");
			break;
		case 13:
			ExecuteCommand("///reloadmonster");
			break;
		case 14:
			ExecuteCommand("///reloadwarrior");
			break;
	}
}

function OnClickRefreshButton()
{
	local string offsetx;
	local string offsety;
	local string offsetz;
	local string pitch;
	local string yaw;
	local string roll;
	local string ride_id;
	ride_id = RideId_EditBox.GetString();
	offsetx = OffsetX_EditBox.GetString();
	offsety = OffsetY_EditBox.GetString();
	offsetz = OffsetZ_EditBox.GetString();
	pitch = Pitch_EditBox.GetString();
	yaw = Yaw_EditBox.GetString();
	roll = Roll_EditBox.GetString();
	ExecuteCommand("///ride id="$ride_id @ "x="$offsetx @ "y=" $offsety @ "z="$offsetz @ "pitch="$pitch @ "yaw="$yaw @ "roll="$roll);
}

function OnClickButton( String a_ButtonID )
{
	switch( a_ButtonID )
	{
		case "Reload_button":
			OnClickReloadButton();
			break;

		case "Refresh_button":
			OnClickRefreshButton();
			break;

		case "collision_button":
			ExecuteCommand("///show radii");
			break;

		case "nameTag_button":
			ExecuteCommand("///show name");
			break;

		case "rmode_button":
			if( rmode_button.GetButtonName() == "Wireframe" )
			{
				ExecuteCommand("///rmode 1");
				rmode_button.SetNameText( "Lighting" );
			}
			else
			{
				ExecuteCommand("///rmode 5");
				rmode_button.SetNameText( "Wireframe" );
			}
			break;

		case "option_button":
			ExecuteCommand("///ow");
			break;

		//etc
		case "AVE_addButton":
			ExecuteCommand("///aa type=" @ AveId_EditBox.GetString());
			break;

		case "AVE_delButton":
			ExecuteCommand("///da type=" @ AveId_EditBox.GetString());
			break;

		case "AVE_clearButton":
			ExecuteCommand("///aa type=none");
			break;

		case "Effect_button":
			ExecuteCommand("///se name=" $ Effect_EditBox.GetString());
			break;

		case "Ride_button":
			if( Ride_button.GetButtonName() == "Ride" )
			{
				ExecuteCommand("///ride id=" @ RideId_EditBox.GetString());
				Ride_button.SetNameText( "Unride" );
				break;
			}
			else
			{
				ExecuteCommand( "///unride" );
				Ride_button.SetNameText( "Ride" );
				break;
			}

		case "ghost_button":
			if( ghost_button.GetButtonName() == "Ghost" )
			{
				ExecuteCommand("///ghost");
				ghost_button.SetNameText( "Walk" );
				break;
			}
			else
			{
				ExecuteCommand( "///walk" );
				ghost_button.SetNameText( "Ghost" );
				break;
			}

		case "search_button":
			ExecuteCommand("///searchobject");
			break;

		case "minimap_button":
			// ExecuteCommand("///sw name=minimapwnd");
			ExecuteEvent(1780,"");
			break;

		case "clone_button":
			ExecuteCommand("///spawnpc copy num=1");
			break;

		case "pv_button":
			ExecuteCommand("///sw name=PCViewerWnd");
			break;

		case "nv_button":
			ExecuteCommand("///nv");
			break;

		case "sv_button":
			ExecuteCommand("///sv");
			break;

		case "sc_button":
			ExecuteCommand("///sce");
			break;

		case "SetSpeed_button":
			ExecuteCommand("///gmspeed" @ Speed_EditBox.GetString());
			break;

		case "Teleport_button":
			ExecuteCommand("///teleport x=" @ TelX_EditBox.GetString() @"y=" @ TelY_EditBox.GetString() @"z=" @ TelZ_EditBox.GetString());
			break;
		case "playermove_button":
			ExecuteCommand("///playermove index=" @ Player_EditBox.GetString());
			break;
		// End:0x555
		case "yb_button":
			ExecuteCommand("///sw name=YebisCmdWnd");
			// End:0x558
			break;
		case "ui_button":
			ExecuteCommand("///ui");
			// End:0x576
			break;
	}
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local float ftime;
	local int Range;

	switch(strID)
	{
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
	case "sliderSetTime":
		if (checkBoxSetTime.IsChecked())
		{
			ftime = float(sliderSetTime.GetCurrentTick()) / 10.f;
			SetEnvTime(ftime);
			txtSetTime.SetText(string(ftime));
		}
		break;
	}
}
function OnComboBoxItemSelected(string StrID, int index)
{
	switch(StrID)
	{
		case "Location_ComboBox":
			switch(index)
			{
				case 0:
					TelX_EditBox.SetString("-114357");
					TelY_EditBox.SetString("252750");
					TelZ_EditBox.SetString("-1545");
					break;
				case 1:
					TelX_EditBox.SetString("-14403");
					TelY_EditBox.SetString("123296");
					TelZ_EditBox.SetString("-3122");
					break;
				case 2:
					TelX_EditBox.SetString("-20358");
					TelY_EditBox.SetString("-157358");
					TelZ_EditBox.SetString("-3727");
					// End:0x155
					break;
				// End:0x152
				case 3:
					TelX_EditBox.SetString("4546");
					TelY_EditBox.SetString("127575");
					TelZ_EditBox.SetString("-3679");
					// End:0x155
					break;
			}
			break;
		case "BoneName_ComboBox":
			if (index == 0)
			{
				if (m_CheckBoxBoneName.IsChecked())
				{
					ExecuteCommand("///rend reset");
					ExecuteCommand("///rend bone");
					ExecuteCommand("///rend bonename");
				}
			}
			else
			{
				class'UIDATA_PAWNVIEWER'.static.ShowSelectedBone(m_ComboBoneName.GetString(index));
			}
			break;
		default:
			break;
	}
}

function OnClickCheckBox( string strID)
{
	switch (strID)
	{
		case "BoneName_CheckBox":
			if (m_CheckBoxBoneName.IsChecked())
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
		break;
		case "checkBoxRange":
			// End:0xCC
			if(checkBoxRange.IsChecked())
			{
				ExecuteCommand("///show_range" @ txtShowRange.GetText());				
			}
			else
			{
				ExecuteCommand("///show_range none");
			}
			// End:0xEC
			break;
	}
}

function SetBoneList()
{
	local array<string> BoneNameList;
	local int index;

	m_ComboBoneName.Clear();
	m_ComboBoneName.AddString("Show All Bones");
	if(m_CheckBoxBoneName.IsChecked())
	{
		class'UIDATA_PAWNVIEWER'.static.GetBoneNameList(BoneNameList);
		for (index = 0; index < BoneNameList.Length; index++)
		{
			m_ComboBoneName.AddString(BoneNameList[index]);
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
     m_WindowName="PVBuilderCmdWnd"
}
