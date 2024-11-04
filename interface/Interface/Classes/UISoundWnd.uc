class UISoundWnd extends UICommonAPI;

var WindowHandle Me;
var ListCtrlHandle itemListCtrl;

function OnRegisterEvent()
{}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle("UISoundWnd");
	itemListCtrl = GetListCtrlHandle("UISoundWnd.itemListCtrl");
}

event OnShow()
{
	itemListCtrl.DeleteAllItem();
	AddList("InterfaceSound.stamp_double");
	AddList("InterfaceSound.stamp_red");
	AddList("InterfaceSound.stamp_yellow");
	AddList("InterfaceSound.inventory_close_01");
	AddList("InterfaceSound.inventory_open_01");
	AddList("InterfaceSound.charstat_close_01");
	AddList("InterfaceSound.charstat_open_01");
	AddList("InterfaceSound.MagicLamp_Start");
	AddList("InterfaceSound.MagicLamp_End");
	AddList("InterfaceSound.map_close_01");
	AddList("InterfaceSound.map_open_01");
	AddList("SkillSound14.d_firework_a");
	AddList("ItemSound.window_close");
	AddList("ItemSound.window_open");
	AddList("ItemSound2.C3_Firework_explosion");
	AddList("ItemSound2.smelting.Smelting_dragin");
	AddList("ItemSound2.smelting.smelting_finalA");
	AddList("ItemSound2.smelting.smelting_finalB");
	AddList("ItemSound2.smelting.smelting_finalC");
	AddList("ItemSound2.smelting.smelting_finalD");
	AddList("Itemsound2.smelting.smelting_dragout");
	AddList("Itemsound2.smelting.smelting_loding");
	AddList("ItemSound3.sys_bonus_login");
	AddList("ItemSound3.sys_bonus_hunt");
	AddList("ItemSound3.enchant_success");
	AddList("ItemSound3.enchant_fail");
	AddList("ItemSound3.enchant_process");
	AddList("ItemSound3.enchant_input");
	AddList("ItemSound3.mini_game.cardgame_succeed");
	AddList("ItemSound3.mini_game.cardgame_fail");
	AddList("ItemSound3.minigame_break_combo");
	AddList("ItemSound3.minigame_break_normal");
	AddList("ItemSound3.minigame_block_down");
	AddList("ItemSound3.minigame_game_over");
	AddList("ItemSound3.minigame_block_change");
	AddList("ItemSound3.minigame_change_impossible");
	AddList("ItemSound3.Sys_Chat_Keyword");
	AddList("InterfaceSound.ui_bookenchant_open");
	AddList("InterfaceSound.ui_bookenchant_progress");
	AddList("InterfaceSound.ui_bookenchant_fail");
	AddList("InterfaceSound.ui_bookenchant_success");
	AddList("InterfaceSound.ui_synthesis_open");
	AddList("InterfaceSound.ui_synthesis_progress");
	AddList("InterfaceSound.ui_synthesis_success");
	AddList("InterfaceSound.ui_synthesis_fail");
	AddList("InterfaceSound.ui_synthesis_in");
	AddList("InterfaceSound.ui_synthesis_out");	
}

function AddList(string soundPath)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 1;
	Record.LVDataList[0].szData = soundPath;
	itemListCtrl.InsertRecord(Record);
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;

	// End:0x6B
	if(itemListCtrl.GetSelectedIndex() > -1)
	{
		itemListCtrl.GetSelectedRec(Record);
		PlaySound(Record.LVDataList[0].szData);
		Debug("사운드 재생:" @ Record.LVDataList[0].szData);
	}
}

function OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	local LVDataRecord Record;

	// End:0x97
	if(class'InputAPI'.static.IsCtrlPressed() && class'InputAPI'.static.GetKeyString(nKey) == "C")
	{
		// End:0x97
		if(itemListCtrl.IsFocused())
		{
			itemListCtrl.GetSelectedRec(Record);
			ClipboardCopy(Record.LVDataList[0].szData);
			AddSystemMessageString("클립 보드 카피:" @ Record.LVDataList[0].szData);
		}
	}
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("UISoundWnd").HideWindow();
}

defaultproperties
{
}
