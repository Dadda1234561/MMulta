class HeroBookWnd extends UICommonAPI;

const TIME_BAR_ID = 1010105;

var WindowHandle Me;
var WindowHandle Confirm_Wnd;
var WindowHandle DisableWnd;
var AnimTextureHandle ProbabilityRound_Trailer;
var StatusRoundHandle Probability_StatusRound;
var ItemWindowHandle ReceiveSkill_Item;
var ItemWindowHandle prvReceivedSkill_Item;
var ItemWindowHandle NextReceiveSkill_Item;
var TextBoxHandle CurrentLevel_text;
var TextBoxHandle ProbabilityTitle_text;
var EffectViewportWndHandle EffectViewport00;
var EffectViewportWndHandle EffectViewport01;
var TextBoxHandle addRewardLevel_text;
var ItemWindowHandle addRewardicon00_Item;
var ItemWindowHandle addRewardicon01_Item;
var ButtonHandle GameStartorCancle_Btn;
var int nRoundProgress;
var int nResultLevel;
var float successPercent;
var int nCurrentPoint;
var int nCurrentLevel;
var int nLastRewardLevel;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HERO_BOOK_ENCHANT);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HERO_BOOK_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HERO_BOOK_UI);	
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();	
}

function Initialize()
{
	Me = GetWindowHandle("HeroBookWnd");
	Confirm_Wnd = GetWindowHandle("HeroBookWnd.Confirm_Wnd");
	DisableWnd = GetWindowHandle("HeroBookWnd.DisableWnd");
	ProbabilityRound_Trailer = GetAnimTextureHandle("HeroBookWnd.ProbabilityRound_Trailer");
	Probability_StatusRound = GetStatusRoundHandle("HeroBookWnd.Probability_StatusRound");
	ReceiveSkill_Item = GetItemWindowHandle("HeroBookWnd.ReceiveSkill_Item");
	prvReceivedSkill_Item = GetItemWindowHandle("HeroBookWnd.PrvReceivedSkill_wnd.Skill_Item");
	NextReceiveSkill_Item = GetItemWindowHandle("HeroBookWnd.NextReceivedSkill_wnd.Skill_Item");
	CurrentLevel_text = GetTextBoxHandle("HeroBookWnd.CurrentLevel_text");
	ProbabilityTitle_text = GetTextBoxHandle("HeroBookWnd.ProbabilityTitle_text");
	EffectViewport00 = GetEffectViewportWndHandle("HeroBookWnd.EffectViewport00");
	EffectViewport01 = GetEffectViewportWndHandle("HeroBookWnd.EffectViewport01");
	addRewardLevel_text = GetTextBoxHandle("HeroBookWnd.addRewardLevel_text");
	addRewardicon00_Item = GetItemWindowHandle("HeroBookWnd.AddRewardIcon00_Item");
	addRewardicon01_Item = GetItemWindowHandle("HeroBookWnd.AddRewardIcon01_Item");
	GameStartorCancle_Btn = GetButtonHandle("HeroBookWnd.GameStartorCancle_Btn");	
}

function Load();

function OnShow()
{
	// End:0x25
	if(IsPlayerOnWorldRaidServer())
	{
		AddSystemMessage(4047);
		Me.HideWindow();
		return;
	}
	PlaySound("InterfaceSound.ui_bookenchant_open");
	GotoState('StateMain');
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), true);	
}

function OnHide()
{
	EffectViewport00.SpawnEffect("");
	EffectViewport01.SpawnEffect("");
	setStartButton(false);
	// End:0x7C
	if(GetWindowHandle("HeroBookProbabilityWnd").IsShowWindow())
	{
		GetWindowHandle("HeroBookProbabilityWnd").HideWindow();
	}
	// End:0xB9
	if(GetWindowHandle("Confirm_Wnd").IsShowWindow())
	{
		GetWindowHandle("Confirm_Wnd").HideWindow();
	}
	GotoState('StateHide');
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), false);
	StopSound("InterfaceSound.ui_bookenchant_open");	
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x20
		case "Confirm_Btn":
			OnConfirm_BtnClick();
			// End:0xB8
			break;
		// End:0x38
		case "Cancle_Btn":
			OnCancle_BtnClick();
			// End:0xB8
			break;
		// End:0x54
		case "WindowHelp_BTN":
			OnWindowHelp_BTNClick();
			// End:0xB8
			break;
		// End:0x75
		case "ProbabilityPlus_Btn":
			OnProbabilityPlus_BtnClick();
			// End:0xB8
			break;
		// End:0x98
		case "GameStartorCancle_Btn":
			OnGameStartorCancle_BtnClick();
			// End:0xB8
			break;
		// End:0xB5
		case "AllListView_Btn":
			OnAllListView_BtnClick();
			// End:0xB8
			break;
	}	
}

function OnConfirm_BtnClick()
{
	setStartButton(true);
	GotoState('StateProgress');	
}

function OnCancle_BtnClick()
{
	Confirm_Wnd.HideWindow();
	DisableWnd.HideWindow();	
}

function OnWindowHelp_BTNClick()
{
	//class'HelpWnd'.static.ShowHelp(64);	
}

function OnProbabilityPlus_BtnClick()
{
	toggleWindow("HeroBookCraftChargingWnd", true, true);	
}

function OnAllListView_BtnClick()
{
	toggleWindow("HeroBookProbabilityWnd");	
}

function OnGameStartorCancle_BtnClick()
{
	local array<ItemInfo> allItem, EquipItem;
	local int nLimit;

	// End:0x37
	if(GameStartorCancle_Btn.GetButtonValue() == 1)
	{
		EffectViewport01.SpawnEffect("");
		setStartButton(false);
		GotoState('StateMain');		
	}
	else if(GameStartorCancle_Btn.GetButtonValue() == 0)
	{
		class'UIDATA_INVENTORY'.static.GetAllInvenItem(allItem);
		class'UIDATA_INVENTORY'.static.GetAllEquipItem(EquipItem);
		Debug("allItem" @ string(allItem.Length));
		Debug("equipItem" @ string(EquipItem.Length));
		Debug("90% 구하기 " @ string((InventoryWnd(GetScript("InventoryWnd")).GetMyInventoryLimit() * 90) / 100));
		nLimit = (InventoryWnd(GetScript("InventoryWnd")).GetMyInventoryLimit() * 90) / 100;
		// End:0x16E
		if((GetCanInventoryWeight()) && (allItem.Length + EquipItem.Length) < nLimit)
		{
			DisableWnd.ShowWindow();
			Confirm_Wnd.ShowWindow();
			Confirm_Wnd.SetFocus();				
		}
		else
		{
			AddSystemMessage(13719);
		}			
	}
	else
	{
		GotoState('StateMain');
	}
}

function bool GetCanInventoryWeight()
{
	local UserInfo uInfo;
	local float Per;

	// End:0x3B
	if(GetPlayerInfo(uInfo))
	{
		Per = float(uInfo.nCarringWeight) / float(uInfo.nCarryWeight);
		return Per <= 0.80f;
	}
	return false;	
}

function HeroBookData getLastRewardLevelData(int nLevel, out int lastLevel)
{
	local HeroBookData levelData, emptyLevelData;
	local array<HeroBookListData> listDatas;
	local int i;

	class'HeroBookAPI'.static.GetAllHeroBookListData(listDatas);
	
	// End:0xB8 [Loop If]
	for(i = nLevel - 1; i < listDatas.Length; i++)
	{
		class'HeroBookAPI'.static.GetHeroBookData(i + 1, levelData);
		// End:0xAE
		if(listDatas[i].SuccessSkillID > 0 || listDatas[i].SuccessItemID > 0)
		{
			lastLevel = i + 1;
			Debug("--> lastLevel" @ string(lastLevel));
			return levelData;
		}
	}
	return emptyLevelData;	
}

function loadHerobookData(optional bool bResultWindowItem)
{
	local HeroBookData levelData, currentLevelData;
	local bool bIconEnable;

	// End:0x11D
	if(bResultWindowItem)
	{
		class'HeroBookAPI'.static.GetHeroBookData(nResultLevel + 1, levelData);
		GetMeTextBox("ResultGroup01_wnd.ResultLevel_text").SetText(GetSystemString(7121) $ " : " $ string(nCurrentLevel));
		GetMeTextBox("ResultGroup01_wnd.ResultSkillName_tex").SetText(GetSkillInfoByValue(levelData.BookSkillID, levelData.BookSkillLevel, 0).SkillName);
		setRewardItem(levelData.SuccessItemID, levelData.SuccessItemCount, true);
		setRewardSkill(levelData.SuccessSkillID, levelData.SuccessSkillLevel, true);
		class'HeroBookAPI'.static.GetHeroBookData(nCurrentLevel, levelData);		
	}
	else
	{
		levelData = getLastRewardLevelData(nCurrentLevel + 1, nLastRewardLevel);
		// End:0x150
		if((nLastRewardLevel - 1) == nCurrentLevel)
		{
			bIconEnable = true;
		}
		setRewardItem(levelData.SuccessItemID, levelData.SuccessItemCount, bIconEnable);
		setRewardSkill(levelData.SuccessSkillID, levelData.SuccessSkillLevel, bIconEnable);
		// End:0x1AF
		if(nLastRewardLevel == 0)
		{
			addRewardLevel_text.SetText("");			
		}
		else if(levelData.SuccessItemID <= 0 && levelData.SuccessSkillID <= 0)
		{
			addRewardLevel_text.SetText("");				
		}
		else
		{
			addRewardLevel_text.SetText(MakeFullSystemMsg(GetSystemMessage(13718), string(nLastRewardLevel)));
		}
	}
	class'HeroBookAPI'.static.GetHeroBookData(nCurrentLevel, currentLevelData);
	setReceiveItem(currentLevelData.BookSkillID, currentLevelData.BookSkillLevel, currentLevelData.PrevSkillID, currentLevelData.PrevSkillLevel, currentLevelData.NextSkillID, currentLevelData.NextSkillLevel);	
}

function setMainUI()
{
	local HeroBookData levelData;
	local SkillInfo pSkillInfo;

	class'HeroBookAPI'.static.GetHeroBookData(nCurrentLevel, levelData);
	successPercent = (float(nCurrentPoint) / float(levelData.MaxPoint)) * 100;
	if(successPercent >= 10)
	{
		GetMeTextBox("MainGroup01_wnd.Probability_text").SetTextColor(GTColor().Yellow2);		
	}
	else
	{
		GetMeTextBox("MainGroup01_wnd.Probability_text").SetTextColor(GTColor().BrightGray);
	}
	GetMeTextBox("MainGroup01_wnd.Probability_text").SetText(cutZeroDecimalStr(ConvertFloatToString(successPercent, 2, false)) $ "%");
	Probability_StatusRound.SetPoint(int(successPercent), 100);
	// End:0x202
	if(int(successPercent) == 0)
	{
		AnimTextureStop(ProbabilityRound_Trailer, true);		
	}
	else
	{
		AnimTexturePlay(ProbabilityRound_Trailer, true);
		circleMove(int(successPercent), 100);
	}
	pSkillInfo = GetSkillInfoByValue(levelData.BookSkillID, levelData.BookSkillLevel, 0);
	GetMeItemWindow("Confirm_Wnd.ConfirmReceiveSkill_Item").Clear();
	GetMeItemWindow("Confirm_Wnd.ConfirmReceiveSkill_Item").AddItem(getSkillToItemInfo(pSkillInfo));
	GetMeTextBox("Confirm_Wnd.ReceivedSkillLv_Text").SetText(GetSystemString(88) $ string(levelData.BookSkillLevel));
	GetMeTextBox("Confirm_Wnd.ReceivedSkillName_Text").SetText(pSkillInfo.SkillName);
	GetMeTextBox("Confirm_Wnd.Probability_Text").SetText(cutZeroDecimalStr(ConvertFloatToString(successPercent, 2, false)) $ "%");
	// End:0x3E4
	if(successPercent >= 10 && levelData.NextSkillID > 0)
	{
		GameStartorCancle_Btn.EnableWindow();
		GameStartorCancle_Btn.ClearTooltip();
		GetMeWindow("MainGroup01_wnd").ShowWindow();		
	}
	else
	{
		GameStartorCancle_Btn.DisableWindow();
		// End:0x473
		if(levelData.NextSkillID <= 0)
		{
			GameStartorCancle_Btn.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(13908), GTColor().Yellow,, 250));
			GetMeWindow("MainGroup01_wnd").HideWindow();
			addRewardLevel_text.SetText(GetSystemString(898));			
		}
		else
		{
			GameStartorCancle_Btn.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14166), GTColor().White,, 250));
			GetMeWindow("MainGroup01_wnd").ShowWindow();
		}
	}	
}

function setRewardItem(int ItemClassID, int ItemNum, bool bIconEnable)
{
	local ItemInfo Info;

	addRewardicon00_Item.Clear();
	Debug("setRewardItem: " @ string(ItemClassID));
	// End:0x106
	if(ItemClassID > 0)
	{
		Info = GetItemInfoByClassID(ItemClassID);
		Info.ItemNum = ItemNum;
		addRewardicon00_Item.AddItem(Info);
		addRewardicon00_Item.ShowWindow();
		GetMeTexture("addRewardIconBg00_Tex").ShowWindow();
		// End:0xDB
		if(bIconEnable)
		{
			GetMeTexture("AddRewardDisable00_tex").HideWindow();			
		}
		else
		{
			GetMeTexture("AddRewardDisable00_tex").ShowWindow();
		}		
	}
	else
	{
		addRewardicon00_Item.HideWindow();
		GetMeTexture("AddRewardDisable00_tex").HideWindow();
		Debug("setRewardItem hide");
	}	
}

function setRewardSkill(int SkillID, int SkillLevel, bool bIconEnable)
{
	addRewardicon01_Item.Clear();
	Debug("setRewardSkill: " @ string(SkillLevel));
	// End:0xF6
	if(SkillID > 0)
	{
		addRewardicon01_Item.AddItem(getSkillToItemInfo(GetSkillInfoByValue(SkillID, SkillLevel, 0)));
		addRewardicon01_Item.ShowWindow();
		GetMeTexture("addRewardIconBg01_Tex").ShowWindow();
		// End:0xCB
		if(bIconEnable)
		{
			GetMeTexture("AddRewardDisable01_tex").HideWindow();			
		}
		else
		{
			GetMeTexture("AddRewardDisable01_tex").ShowWindow();
		}		
	}
	else
	{
		addRewardicon01_Item.HideWindow();
		GetMeTexture("AddRewardDisable01_tex").HideWindow();
		Debug("setRewardSkill hide");
	}	
}

function setReceiveItem(int nBookSkillID, int nBookSkillLevel, int nPrevSkillID, int nPrevSkillLevel, int nNextSkillID, int nNextSkillLevel)
{
	ReceiveSkill_Item.Clear();
	// End:0x40
	if(nBookSkillID > 0)
	{
		ReceiveSkill_Item.AddItem(getSkillToItemInfo(GetSkillInfoByValue(nBookSkillID, nBookSkillLevel, 0)));
	}
	prvReceivedSkill_Item.Clear();
	// End:0xB5
	if(nPrevSkillID > 0)
	{
		prvReceivedSkill_Item.AddItem(getSkillToItemInfo(GetSkillInfoByValue(nPrevSkillID, nPrevSkillLevel, 0)));
		GetMeTexture("PrvReceivedSkill_wnd.Disable_tex").ShowWindow();		
	}
	else
	{
		prvReceivedSkill_Item.EnableWindow();
		GetMeTexture("PrvReceivedSkill_wnd.Disable_tex").HideWindow();
	}
	NextReceiveSkill_Item.Clear();
	// End:0x136
	if(nNextSkillID > 0)
	{
		NextReceiveSkill_Item.AddItem(getSkillToItemInfo(GetSkillInfoByValue(nNextSkillID, nNextSkillLevel, 0)));
	}	
}

function setStartButton(bool bRun, optional bool noSoundStop)
{
	// End:0x120
	if(bRun)
	{
		OnCancle_BtnClick();
		Me.KillTimer(TIME_BAR_ID);
		Me.SetTimer(TIME_BAR_ID, 10);
		Probability_StatusRound.SetPoint(0, 100);
		circleMove(0, 100);
		nRoundProgress = 0;
		EffectViewport01.SpawnEffect("LineageEffect2.ui_herobook_progress");
		EffectViewport01.SetScale(2.070f);
		EffectViewport01.SetOffset(setVector(0, 0, 0));
		PlaySound("InterfaceSound.ui_bookenchant_progress");
		HeroBookCraftChargingWnd(GetScript("HeroBookCraftChargingWnd")).setProgress(true);		
	}
	else
	{
		Me.KillTimer(TIME_BAR_ID);
		Probability_StatusRound.SetPoint(0, 36);
		EffectViewport00.SpawnEffect("LineageEffect2.ui_herobook_standby");
		HeroBookCraftChargingWnd(GetScript("HeroBookCraftChargingWnd")).setProgress(false);
		// End:0x1E7
		if(noSoundStop == false)
		{
			StopSound("InterfaceSound.ui_bookenchant_progress");
		}
	}	
}

function OnTimer(int TimerID)
{
	// End:0x6F
	if(TimerID == TIME_BAR_ID)
	{
		nRoundProgress++;
		Probability_StatusRound.SetPoint(nRoundProgress, 100);
		circleMove(nRoundProgress, 100);
		// End:0x6F
		if(nRoundProgress >= 100)
		{
			Me.KillTimer(TIME_BAR_ID);
			AnimTextureStop(ProbabilityRound_Trailer, true);
			API_C_EX_HERO_BOOK_ENCHANT();
		}
	}	
}

function circleMove(int tickNum, int Cycle)
{
	local float X, Y, Angle, Radius;

	Radius = 82.0f;
	Angle = (360.0f / float(Cycle)) * float(tickNum);
	X = Radius * Sin((3.140f * Angle) / float(180));
	Y = - Radius * Cos((3.140f * Angle) / float(180));
	X = (((Radius + X) + float(Probability_StatusRound.GetRect().nX)) - float(ProbabilityRound_Trailer.GetRect().nWidth / 2)) + 36;
	Y = (((Radius + Y) + float(Probability_StatusRound.GetRect().nY)) - float(ProbabilityRound_Trailer.GetRect().nHeight / 2)) + 36;
	ProbabilityRound_Trailer.MoveTo(int(X), int(Y));	
}

function OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		// End:0x28
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HERO_BOOK_ENCHANT:
			ParsePacket_S_EX_HERO_BOOK_ENCHANT();
			// End:0x6D
			break;
		// End:0x49
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HERO_BOOK_INFO:
			ParsePacket_S_EX_HERO_BOOK_INFO();
			// End:0x6D
			break;
		// End:0x6A
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HERO_BOOK_UI:
			ParsePacket_S_EX_HERO_BOOK_UI();
			// End:0x6D
			break;
	}	
}

function ParsePacket_S_EX_HERO_BOOK_UI()
{
	Me.ShowWindow();
	Me.SetFocus();	
}

function API_C_EX_HERO_BOOK_ENCHANT()
{
	local array<byte> stream;

	nResultLevel = nCurrentLevel;
	Debug("API_C_EX_HERO_BOOK_ENCHANT");
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_HERO_BOOK_ENCHANT, stream);	
}

function ParsePacket_S_EX_HERO_BOOK_INFO()
{
	local UIPacket._S_EX_HERO_BOOK_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_HERO_BOOK_INFO(packet))
	{
		return;
	}
	nCurrentPoint = packet.nPoint;
	nCurrentLevel = packet.nLevel;
	CurrentLevel_text.SetText(string(nCurrentLevel));
	if(GetStateName() == 'StateMain')
	{
		setMainUI();
	}	
}

function ParsePacket_S_EX_HERO_BOOK_ENCHANT()
{
	local UIPacket._S_EX_HERO_BOOK_ENCHANT packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_HERO_BOOK_ENCHANT(packet))
	{
		return;
	}
	Debug("결과 " @ string(packet.cResult));
	GotoState('StateResult');
	// End:0x163
	if(packet.cResult == 0)
	{
		GetMeTextBox("ResultGroup00_wnd.CurrentLevelTitle_text").SetText(GetSystemString(13820));
		EffectViewport01.SpawnEffect("LineageEffect2.ui_Enchant_success");
		EffectViewport01.SetScale(2.010f);
		EffectViewport01.SetCameraDistance(210.0f);
		EffectViewport01.SetCameraPitch(-800);
		EffectViewport01.SetCameraYaw(34000);
		EffectViewport01.SetOffset(setVector(0, 0, 0));
		PlaySound("InterfaceSound.ui_bookenchant_success");
		loadHerobookData(true);		
	}
	else if(packet.cResult == 1)
	{
		GetMeTextBox("ResultGroup00_wnd.CurrentLevelTitle_text").SetText(GetSystemString(13821));
		EffectViewport01.SpawnEffect("LineageEffect2.ui_Enchant_fail");
		EffectViewport01.SetScale(2.010f);
		EffectViewport01.SetCameraDistance(210.0f);
		EffectViewport01.SetCameraPitch(-800);
		EffectViewport01.SetCameraYaw(34000);
		EffectViewport01.SetOffset(setVector(0, 0, 0));
		PlaySound("InterfaceSound.ui_bookenchant_fail");
		loadHerobookData(true);
		addRewardicon00_Item.Clear();
		addRewardicon01_Item.Clear();
		GetMeTexture("addRewardIconBg00_Tex").HideWindow();
		GetMeTexture("addRewardIconBg01_Tex").HideWindow();			
	}
	else
	{
		AddSystemMessage(4334);
		Me.HideWindow();
		return;
	}

	setStartButton(false, true);	
}

function OnReceivedCloseUI()
{
	// End:0x1B
	if(Confirm_Wnd.IsShowWindow())
	{
		OnCancle_BtnClick();		
	}
	else
	{
		closeUI();
	}	
}

state StateHide
{
	function BeginState();

}

state StateMain
{
	function BeginState()
	{
		local HeroBookData levelData;

		class'HeroBookAPI'.static.GetHeroBookData(nCurrentLevel, levelData);
		Debug("--> StateMain");
		setStartButton(false);
		DisableWnd.HideWindow();
		GetMeWindow("MainGroup00_wnd").ShowWindow();
		GetMeWindow("MainGroup01_wnd").ShowWindow();
		GetMeWindow("ResultGroup00_wnd").HideWindow();
		GetMeWindow("ResultGroup01_wnd").HideWindow();
		GameStartorCancle_Btn.SetButtonName(5005);
		GameStartorCancle_Btn.SetButtonValue(0);
		GetMeWindow("NextReceivedSkill_wnd").ShowWindow();
		GetMeWindow("PrvReceivedSkill_wnd").ShowWindow();
		loadHerobookData(false);
		setMainUI();		
	}
}

state StateProgress
{
	function BeginState()
	{
		Debug("StateProgress");
		GetMeWindow("MainGroup00_wnd").HideWindow();
		GetMeWindow("MainGroup01_wnd").HideWindow();
		GetMeWindow("ResultGroup00_wnd").HideWindow();
		GetMeWindow("ResultGroup01_wnd").HideWindow();
		GetMeWindow("NextReceivedSkill_wnd").HideWindow();
		GetMeWindow("PrvReceivedSkill_wnd").HideWindow();
		GameStartorCancle_Btn.SetButtonName(2420);
		GameStartorCancle_Btn.SetButtonValue(1);		
	}
}

state StateResult
{
	function BeginState()
	{
		Debug("StateResult");
		GetMeWindow("MainGroup00_wnd").HideWindow();
		GetMeWindow("MainGroup01_wnd").HideWindow();
		GetMeWindow("ResultGroup00_wnd").ShowWindow();
		GetMeWindow("ResultGroup01_wnd").ShowWindow();
		GetMeWindow("NextReceivedSkill_wnd").HideWindow();
		GetMeWindow("PrvReceivedSkill_wnd").HideWindow();
		GameStartorCancle_Btn.SetButtonName(5158);
		GameStartorCancle_Btn.SetButtonValue(2);
		addRewardLevel_text.SetText(GetSystemString(3853));		
	}
}

defaultproperties
{
}
