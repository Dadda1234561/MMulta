class BalrogWnd extends UICommonAPI;

const TIME_REMAIN_SEC_ID = 11010102;

enum BALROGWAR_State 
{
	BWS_NONE,
	BWS_PREPARE,
	BWS_PROGRESS,
	BWS_REWARD,
	BWS_END
};

enum BALROGWAR_ProgressStep 
{
	BWPS_NONE,
	BWPS_START,
	BWPS_MIDBOSS1,
	BWPS_MIDBOSS2,
	BWPS_FINALBOSS,
	BWPS_FINALBOSS_SPECIAL
};

enum RewardState 
{
	RS_NONE,
	RS_HAS_REWARD,
	RS_REWARD_RECEIVED
};

enum BossState 
{
	BWBS_NONE,
	BWBS_SPAWN,
	BWBS_SUCCESS,
	BWBS_FAIL
};

var WindowHandle Me;
var EffectViewportWndHandle Reward_EffectViewport;
var CharacterViewportWindowHandle ObjectViewport;
var WindowHandle StepMonsterInfo_wnd02;
var WindowHandle StepMonsterInfo_wnd01;
var WindowHandle StepMonsterInfo_wnd00;
var ButtonHandle Tel_Btn;
var ButtonHandle ReFresh_btn;
var WindowHandle StepCheck_wnd00;
var WindowHandle StepCheck_wnd01;
var WindowHandle StepCheck_wnd02;
var WindowHandle StepCheck_wnd03;
var TextBoxHandle TimeTilte_txt;
var TextBoxHandle Time_txt;
var TextBoxHandle BalrogStepTitle_txt;
var TextBoxHandle BalrogStep_txt;
var ButtonHandle BalrogStepHelp_Btn;
var StatusBarHandle StepMonsterGauge_bar;
var WindowHandle MyInfoWnd;
var ButtonHandle HelpTooltip_Btn;
var TextBoxHandle MyRankingTitle_txt;
var TextBoxHandle MyRanking_txt;
var TextBoxHandle MyScoreTitle_txt;
var TextBoxHandle MyScore_txt;
var TextBoxHandle RewardTitle_txt;
var TextureHandle RewardQuestionBG_tex;
var ItemWindowHandle Reward_itemWnd;
var ButtonHandle Reward_Btn;
var ButtonHandle Ranking_Btn;
var TextBoxHandle EventScoreTitle_txt;
var TextBoxHandle EventScore_txt;
var TextureHandle StepScoreGroupBG_Tex;
var string m_WindowName;
var int currentTeleportID;
var int RemainSec;
var bool bFirstSetting;
var BalrogwarUIData balrogwarData;
var bool bSpecialMode;
var UserInfo myInfo;
var int progressBarMax;
var int nHud_State;
var int nHud_nProgressStep;
var int npcIdFinalBoss;
var L2UITimerObject timerObject;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_BALROGWAR_SHOW_UI);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_BALROGWAR_GET_REWARD);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_BALROGWAR_HUD);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_BALROGWAR_BOSSINFO);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_GameStart);
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle("BalrogWnd");
	Reward_EffectViewport = GetEffectViewportWndHandle("BalrogWnd.Reward_EffectViewport");
	ObjectViewport = GetCharacterViewportWindowHandle("BalrogWnd.StepMonsterInfo_wnd02.ObjectViewport");
	StepMonsterInfo_wnd00 = GetWindowHandle("BalrogWnd.StepMonsterInfo_wnd00");
	StepMonsterInfo_wnd01 = GetWindowHandle("BalrogWnd.StepMonsterInfo_wnd01");
	StepMonsterInfo_wnd02 = GetWindowHandle("BalrogWnd.StepMonsterInfo_wnd02");
	Tel_Btn = GetButtonHandle("BalrogWnd.Tel_Btn");
	ReFresh_btn = GetButtonHandle("BalrogWnd.ReFresh_Btn");
	StepCheck_wnd00 = GetWindowHandle("BalrogWnd.StepCheck_wnd00");
	StepCheck_wnd01 = GetWindowHandle("BalrogWnd.StepCheck_wnd01");
	StepCheck_wnd02 = GetWindowHandle("BalrogWnd.StepCheck_wnd02");
	StepCheck_wnd03 = GetWindowHandle("BalrogWnd.StepCheck_wnd03");
	TimeTilte_txt = GetTextBoxHandle("BalrogWnd.TimeTilte_txt");
	Time_txt = GetTextBoxHandle("BalrogWnd.Time_txt");
	BalrogStepTitle_txt = GetTextBoxHandle("BalrogWnd.BalrogStepTitle_txt");
	BalrogStep_txt = GetTextBoxHandle("BalrogWnd.BalrogStep_txt");
	BalrogStepHelp_Btn = GetButtonHandle("BalrogWnd.BalrogStepHelp_Btn");
	StepMonsterGauge_bar = GetStatusBarHandle("BalrogWnd.StepMonsterGauge_bar");
	MyInfoWnd = GetWindowHandle("BalrogWnd.MyInfoWnd");
	HelpTooltip_Btn = GetButtonHandle("BalrogWnd.MyInfoWnd.HelpTooltip_Btn");
	MyRankingTitle_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.MyRankingTitle_txt");
	MyRanking_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.MyRanking_txt");
	MyScoreTitle_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.MyScoreTitle_txt");
	MyScore_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.MyScore_txt");
	RewardTitle_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.RewardTitle_txt");
	RewardQuestionBG_tex = GetTextureHandle("BalrogWnd.MyInfoWnd.RewardQuestionBG_tex");
	Reward_itemWnd = GetItemWindowHandle("BalrogWnd.MyInfoWnd.Reward_itemWnd");
	Reward_Btn = GetButtonHandle("BalrogWnd.MyInfoWnd.Reward_Btn");
	Ranking_Btn = GetButtonHandle("BalrogWnd.MyInfoWnd.Ranking_Btn");
	EventScoreTitle_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.EventScoreTitle_txt");
	EventScore_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.EventScore_txt");
	StepScoreGroupBG_Tex = GetTextureHandle("BalrogWnd.StepScoreGroupBG_Tex");
}

function Load()
{
	SetClosingOnESC();
	GetWindowHandle(m_WindowName $ ".disable_tex").HideWindow();
	SetPopupScript();
	timerObject = class'L2UITimer'.static.Inst()._AddNewTimerObject();
	timerObject._time = 2000;
	timerObject._DelegateOnEnd = API_C_EX_BALROGWAR_SHOW_UI;
}

function loadScript()
{
	// End:0x18
	if(bFirstSetting == false)
	{
		balrogwarData = GetBalrogwarData();
	}
	bFirstSetting = true;
	HelpTooltip_Btn.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(13644), string(balrogwarData.Level), string(balrogwarData.MinPlayerPt)), 240));
}

function OnShow()
{
	API_C_EX_BALROGWAR_SHOW_UI();
	Me.SetFocus();
}

function setBarOnOff(int i, bool bOn, optional bool bRed)
{
	// End:0x126
	if(bOn)
	{
		// End:0x7D
		if(bRed)
		{
			GetTextureHandle("BalrogWnd.StepCheck_wnd0" $ string(i) $ ".StepON_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogStepOn_Red");			
		}
		else
		{
			GetTextureHandle("BalrogWnd.StepCheck_wnd0" $ string(i) $ ".StepON_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogStepOn");
		}
		GetTextureHandle("BalrogWnd.StepCheck_wnd0" $ string(i) $ ".StepON_tex").ShowWindow();		
	}
	else
	{
		GetTextureHandle("BalrogWnd.StepCheck_wnd0" $ string(i) $ ".StepON_tex").HideWindow();
	}
}

function setMYInfo(int nRank, int nScore, INT64 nEventScore)
{
	MyScore_txt.SetText(MakeCostString(string(nScore)));
	EventScore_txt.SetText(MakeCostString(string(nEventScore)));
	// End:0x6B
	if(nRank == 0)
	{
		MyRanking_txt.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));		
	}
	else
	{
		MyRanking_txt.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nRank)));
	}
}

function setMonsterInfoStep(int nStep)
{
	switch(nStep)
	{
		// End:0x3B
		case 0:
			StepMonsterInfo_wnd00.ShowWindow();
			StepMonsterInfo_wnd01.HideWindow();
			StepMonsterInfo_wnd02.HideWindow();
			// End:0xE1
			break;
		// End:0x6F
		case 1:
			StepMonsterInfo_wnd00.HideWindow();
			StepMonsterInfo_wnd01.ShowWindow();
			StepMonsterInfo_wnd02.HideWindow();
			// End:0xE1
			break;
		// End:0xDE
		case 2:
			StepMonsterInfo_wnd00.HideWindow();
			StepMonsterInfo_wnd01.HideWindow();
			StepMonsterInfo_wnd02.ShowWindow();
			Debug("3d뷰" @ string(npcIdFinalBoss));
			playNpcViewport(ObjectViewport, npcIdFinalBoss, 1100, 28000, 170, 10, 30.0f, "");
			// End:0xE1
			break;
	}
}

function setProgressStep(int nStep, optional bool bRed)
{
	switch(nStep)
	{
		// End:0x64
		case 0:
			setBarOnOff(0, false);
			setBarOnOff(1, false);
			setBarOnOff(2, false);
			setBarOnOff(3, false);
			BalrogStepTitle_txt.SetText(GetSystemString(13992));
			BalrogStep_txt.SetText(GetSystemString(13998));
			// End:0x246
			break;
		// End:0xC1
		case 1:
			setBarOnOff(0, true);
			setBarOnOff(1, false);
			setBarOnOff(2, false);
			setBarOnOff(3, false);
			BalrogStepTitle_txt.SetText(GetSystemString(13993));
			BalrogStep_txt.SetText(GetSystemString(13999));
			// End:0x246
			break;
		// End:0x11F
		case 2:
			setBarOnOff(0, true);
			setBarOnOff(1, true);
			setBarOnOff(2, false);
			setBarOnOff(3, false);
			BalrogStepTitle_txt.SetText(GetSystemString(13994));
			BalrogStep_txt.SetText(GetSystemString(13999));
			// End:0x246
			break;
		// End:0x17D
		case 3:
			setBarOnOff(0, true);
			setBarOnOff(1, true);
			setBarOnOff(2, true);
			setBarOnOff(3, false);
			BalrogStepTitle_txt.SetText(GetSystemString(13995));
			BalrogStep_txt.SetText(GetSystemString(13999));
			// End:0x246
			break;
		// End:0x243
		case 4:
			setBarOnOff(0, true, bRed);
			setBarOnOff(1, true, bRed);
			setBarOnOff(2, true, bRed);
			setBarOnOff(3, true, bRed);
			// End:0x204
			if(bRed)
			{
				bSpecialMode = true;
				BalrogStepTitle_txt.SetText(GetSystemString(13997));
				BalrogStep_txt.SetText(GetSystemString(14002));				
			}
			else
			{
				bSpecialMode = false;
				BalrogStepTitle_txt.SetText(GetSystemString(13996));
				BalrogStep_txt.SetText(GetSystemString(14001));
			}
			// End:0x246
			break;
	}
}

function setMonsterKill(int nMonsterIndex, bool bLock, optional bool bKillComplete)
{
	local TextureHandle Monster_tex, Complete_tex, LockBG_tex;

	Complete_tex = GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(nMonsterIndex) $ ".Complete_tex");
	Monster_tex = GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(nMonsterIndex) $ ".Monster_tex");
	LockBG_tex = GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(nMonsterIndex) $ ".LockBG_tex");
	// End:0x11A
	if(bLock)
	{
		Monster_tex.HideWindow();
		LockBG_tex.ShowWindow();		
	}
	else
	{
		Monster_tex.ShowWindow();
		LockBG_tex.HideWindow();
	}
	// End:0x153
	if(bKillComplete)
	{
		Complete_tex.ShowWindow();		
	}
	else
	{
		Complete_tex.HideWindow();
	}
}

function OnHide()
{
	ObjectViewport.HideNPC(0.0f);
	ObjectViewport.SetUISound(false);
	// End:0x6B
	if(GetWindowHandle("BalrogRankingWnd").IsShowWindow())
	{
		GetWindowHandle("BalrogRankingWnd").HideWindow();
	}
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_BALROGWAR_SHOW_UI):
			ParsePacket_S_EX_BALROGWAR_SHOW_UI();
			// End:0xD2
			break;
		// End:0x47
		case EV_PacketID(class'UIPacket'.const.S_EX_BALROGWAR_GET_REWARD):
			ParsePacket_S_EX_BALROGWAR_GET_REWARD();
			// End:0xD2
			break;
		// End:0x7F
		case EV_PacketID(class'UIPacket'.const.S_EX_BALROGWAR_HUD):
			ParsePacket_S_EX_BALROGWAR_HUD();
			// End:0x7C
			if(Me.IsShowWindow())
			{
				API_C_EX_BALROGWAR_SHOW_UI();
			}
			// End:0xD2
			break;
		// End:0x9F
		case EV_PacketID(class'UIPacket'.const.S_EX_BALROGWAR_BOSSINFO):
			ParsePacket_S_EX_BALROGWAR_BOSSINFO();
			// End:0xD2
			break;
		// End:0xBE
		case EV_Restart:
			bFirstSetting = false;
			timerObject._Stop();
			// End:0xD2
			break;
		// End:0xCF
		case EV_GameStart:
			loadScript();
			// End:0xD2
			break;
		// End:0xFFFF
		default:
			break;
	}
}

function ParsePacket_S_EX_BALROGWAR_SHOW_UI()
{
	local UIPacket._S_EX_BALROGWAR_SHOW_UI packet;
	local ItemInfo rewardInfo;
	local StatusBaseHandle Handle;

	Handle = StepMonsterGauge_bar.GetSelfScript();
	// End:0x30
	if(! class'UIPacket'.static.Decode_S_EX_BALROGWAR_SHOW_UI(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_BALROGWAR_SHOW_UI :  " @ string(packet.nRank) @ string(packet.nPersonalPoint) @ string(packet.nTotalPoint) @ string(packet.nRewardState) @ string(packet.nRewardItemID) @ string(packet.nRewardAmount));
	Debug("packet.nRank" @ string(packet.nRank));
	Debug("packet.nPersonalPoint" @ string(packet.nPersonalPoint));
	Debug("packet.nTotalPoint" @ string(packet.nTotalPoint));
	Debug("packet.nRewardState" @ string(packet.nRewardState));
	Debug("packet.nRewardItemID" @ string(packet.nRewardItemID));
	Debug("packet.nRewardAmount" @ string(packet.nRewardAmount));
	setMYInfo(packet.nRank, packet.nPersonalPoint, packet.nTotalPoint);
	Reward_itemWnd.Clear();
	// End:0x227
	if(packet.nRewardItemID > 0)
	{
		rewardInfo = GetItemInfoByClassID(packet.nRewardItemID);
		rewardInfo.ItemNum = packet.nRewardAmount;
		Reward_itemWnd.AddItem(rewardInfo);
	}
	// End:0x28C
	if(packet.nRewardState > 0)
	{
		// End:0x26B
		if(packet.nRewardState == 2)
		{
			Reward_itemWnd.DisableWindow();
			Reward_Btn.DisableWindow();			
		}
		else
		{
			Reward_itemWnd.EnableWindow();
			Reward_Btn.EnableWindow();
		}		
	}
	else
	{
		Reward_Btn.DisableWindow();
	}
	// End:0x336
	if(packet.nTotalPoint > progressBarMax)
	{
		StepMonsterGauge_bar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeLeft, GTColor().Red);
		StepMonsterGauge_bar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeCenter, GTColor().Red);
		StepMonsterGauge_bar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeRight, GTColor().Red);		
	}
	else
	{
		StepMonsterGauge_bar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeLeft, GTColor().Yellow);
		StepMonsterGauge_bar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeCenter, GTColor().Yellow);
		StepMonsterGauge_bar.SetGaugeColor(Handle.StatusBarSplitType.SBST_ForeRight, GTColor().Yellow);
	}
	StepMonsterGauge_bar.SetPoint(packet.nTotalPoint, progressBarMax);
	Debug("packet.nTotalPoint" @ string(packet.nTotalPoint));
	Debug("progressBarMax" @ string(progressBarMax));
}

function ParsePacket_S_EX_BALROGWAR_GET_REWARD()
{
	local UIPacket._S_EX_BALROGWAR_GET_REWARD packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_BALROGWAR_GET_REWARD(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_BALROGWAR_GET_REWARD :  " @ string(packet.bSuccess));
	// End:0xD3
	if(packet.bSuccess > 0)
	{
		playResultEffectViewPort("LineageEffect2.ui_upgrade_succ");
		PlaySound("ItemSound3.enchant_success");
		Reward_Btn.DisableWindow();
		Reward_itemWnd.DisableWindow();
	}
}

function ParsePacket_S_EX_BALROGWAR_HUD()
{
	local UIPacket._S_EX_BALROGWAR_HUD packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_BALROGWAR_HUD(packet))
	{
		return;
	}
	nHud_nProgressStep = packet.nProgressStep;
	nHud_State = packet.nState;
	RemainSec = packet.nLeftTime;
	Me.KillTimer(TIME_REMAIN_SEC_ID);
	Me.SetTimer(TIME_REMAIN_SEC_ID, 1000);
	switch(packet.nProgressStep)
	{
		// End:0x1D5
		case 0:
			progressBarMax = 0;
			setMonsterInfoStep(0);
			GetTextBoxHandle("BalrogWnd.StepMonsterInfo_wnd00.Descrip_txt").SetText(GetSystemString(14008));
			setProgressStep(0);
			BalrogStepHelp_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14030), 100));
			// End:0x352
			break;
		// End:0x26A
		case 1:
			progressBarMax = balrogwarData.EventBeginPt;
			initHideBossInfo();
			setMonsterInfoStep(0);
			setProgressStep(1);
			GetTextBoxHandle("BalrogWnd.StepMonsterInfo_wnd00.Descrip_txt").SetText(GetSystemString(14008));
			BalrogStepHelp_Btn.SetTooltipCustomType(getCustomToolTipBossKill(13999, 14009));
			// End:0x352
			break;
		// End:0x293
		case 2:
			progressBarMax = balrogwarData.normal_1st_midboss_pt;
			setMonsterInfoStep(1);
			setProgressStep(2);
			// End:0x352
			break;
		// End:0x2BC
		case 3:
			progressBarMax = balrogwarData.normal_2nd_midboss_pt;
			setMonsterInfoStep(1);
			setProgressStep(3);
			// End:0x352
			break;
		// End:0x305
		case 4:
			progressBarMax = balrogwarData.normal_final_boss_pt;
			setMonsterInfoStep(2);
			setProgressStep(4);
			BalrogStepHelp_Btn.SetTooltipCustomType(getCustomToolTipBossKill(14001, 14010));
			// End:0x352
			break;
		// End:0x34F
		case 5:
			progressBarMax = balrogwarData.specail_final_boss_pt;
			setMonsterInfoStep(2);
			setProgressStep(4, true);
			BalrogStepHelp_Btn.SetTooltipCustomType(getCustomToolTipBossKill(14002, 14034));
			// End:0x352
			break;
		// End:0xFFFF
		default:
			break;
	}
	// End:0x41C
	if(packet.nState == 3)
	{
		// End:0x3A5
		if(bSpecialMode)
		{
			BalrogStepTitle_txt.SetText(GetSystemString(14032));
			BalrogStep_txt.SetText(GetSystemString(14003));			
		}
		else
		{
			BalrogStepTitle_txt.SetText(GetSystemString(14032));
			BalrogStep_txt.SetText(GetSystemString(14003));
		}
		BalrogStepHelp_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14003), 120));
		// End:0x41C
		if(Me.IsShowWindow())
		{
			timerObject._Reset();
		}
	}
	// End:0x452
	if(packet.nState == 4)
	{
		Me.HideWindow();
		Me.KillTimer(TIME_REMAIN_SEC_ID);
	}
}

function initHideBossInfo()
{
	local int i;

	// End:0xC6 [Loop If]
	for(i = 0; i < 5; i++)
	{
		GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i) $ ".Monster_tex").HideWindow();
		GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i) $ ".Complete_tex").HideWindow();
	}
}

function ParsePacket_S_EX_BALROGWAR_BOSSINFO()
{
	local int i;
	local UIPacket._S_EX_BALROGWAR_BOSSINFO packet;
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local bool bUseTooltip;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_BALROGWAR_BOSSINFO(packet))
	{
		return;
	}
	npcIdFinalBoss = packet.nFinalBossClassID - 1000000;
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14000), getInstanceL2Util().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);

	// End:0x26D [Loop If]
	for(i = 0; i < 5; i++)
	{
		// End:0x1E8
		if(packet.nMidBossClassID[i] > 0)
		{
			GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i) $ ".Monster_tex").SetTexture(getMonsterTexture(packet.nMidBossClassID[i]));
			// [Explicit Continue]
			continue;
		}
		GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i) $ ".Monster_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogMonsterSlot");
	}

	// End:0x6DF [Loop If]
	for(i = 0; i < 5; i++)
	{
		// End:0x320
		if(packet.nMidBossState[i] == 0)
		{
			GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i) $ ".Monster_tex").HideWindow();			
		}
		else
		{
			// End:0x401
			if(packet.nMidBossState[i] == 1)
			{
				GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i) $ ".Monster_tex").ShowWindow();
				drawListArr[drawListArr.Length] = addDrawItemText("- " $ class'UIDATA_NPC'.static.GetNPCName(packet.nMidBossClassID[i] - 1000000), getInstanceL2Util().ColorDesc, "", true, true);
				bUseTooltip = true;
				BalrogStep_txt.SetText(GetSystemString(14000));
			}
		}
		// End:0x4EB
		if(packet.nMidBossState[i] == 2)
		{
			GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i) $ ".Complete_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogComplete");
			GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i) $ ".Complete_tex").ShowWindow();
			// [Explicit Continue]
			continue;
		}
		// End:0x680
		if(packet.nMidBossState[i] == 3)
		{
			// End:0x628
			if(GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i) $ ".Monster_tex").IsShowWindow())
			{
				GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i) $ ".Complete_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogFail");
				GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i) $ ".Complete_tex").ShowWindow();				
			}
			else
			{
				GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i) $ ".Complete_tex").HideWindow();
			}
			// [Explicit Continue]
			continue;
		}
		GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i) $ ".Complete_tex").HideWindow();
	}
	// End:0x745
	if(bUseTooltip)
	{
		mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
		mCustomTooltip.MinimumWidth = 130;
		setCustomToolTipMinimumWidth(mCustomTooltip);
		BalrogStepHelp_Btn.SetTooltipCustomType(mCustomTooltip);		
	}
	else
	{
		// End:0x6D5
		if(packet.nFinalBossClassID == 0)
		{
			// End:0x64F
			if(nHud_State == 3 || nHud_State == 4)
			{				
			}
			else if(nHud_State == 1)
			{
				BalrogStepHelp_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13998), 100));
				BalrogStep_txt.SetText(GetSystemString(13998));					
			}
			else
			{
				BalrogStepHelp_Btn.SetTooltipCustomType(getCustomToolTipBossKill(13999, 14009));
				BalrogStep_txt.SetText(GetSystemString(13999));
			}
		}
	}
	// End:0x875
	if(nHud_nProgressStep == 4 || nHud_nProgressStep == 5)
	{
		Debug("3d뷰 갱신 " @ string(npcIdFinalBoss));
		playNpcViewport(ObjectViewport, npcIdFinalBoss, 1100, 28000, 170, 10, 30.0f, "");
	}
	// End:0x8E2
	if(packet.nFinalBossState == 1 || packet.nFinalBossState == 0)
	{
		GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd02.BossComplete_tex").HideWindow();		
	}
	else
	{
		// End:0x9BD
		if(packet.nFinalBossState == 2)
		{
			GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd02.BossComplete_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogCompleteLarge");
			GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd02.BossComplete_tex").ShowWindow();
			// End:0x9BA
			if(Me.IsShowWindow())
			{
				API_C_EX_BALROGWAR_SHOW_UI();
			}			
		}
		else
		{
			// End:0xA91
			if(packet.nFinalBossState == 3)
			{
				GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd02.BossComplete_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogFailLarge");
				GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd02.BossComplete_tex").ShowWindow();
				// End:0xA91
				if(Me.IsShowWindow())
				{
					API_C_EX_BALROGWAR_SHOW_UI();
				}
			}
		}
	}
}

function string getMonsterTexture(int NpcID)
{
	return "L2UI_EPIC.BalrogWnd.BalrogMonsterID_" $ string(NpcID - 1000000);
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x1C
		case "Tel_Btn":
			OnTel_BtnClick();
			// End:0xCA
			break;
		// End:0x35
		case "ReFresh_Btn":
			OnReFresh_btnClick();
			// End:0xCA
			break;
		// End:0x55
		case "BalrogStepHelp_Btn":
			OnBalrogStepHelp_BtnClick();
			// End:0xCA
			break;
		// End:0x72
		case "HelpTooltip_Btn":
			OnHelpTooltip_BtnClick();
			// End:0xCA
			break;
		// End:0x8A
		case "Reward_Btn":
			OnReward_BtnClick();
			// End:0xCA
			break;
		// End:0xA3
		case "Ranking_Btn":
			OnRanking_BtnClick();
			// End:0xCA
			break;
		// End:0xC7
		case "FrameHelp_BTN":
			ExecuteEvent(1210, "54");
			// End:0xCA
			break;
	}
}

function OnTel_BtnClick()
{
	GetPlayerInfo(myInfo);
	// End:0x2D
	if(balrogwarData.Level <= myInfo.nLevel)
	{
		ShowPopup();		
	}
	else
	{
		AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(13643), string(balrogwarData.Level)));
	}
}

function OnReFresh_btnClick()
{
	API_C_EX_BALROGWAR_SHOW_UI();
}

function OnBalrogStepHelp_BtnClick()
{}

function OnHelpTooltip_BtnClick()
{}

function OnReward_BtnClick()
{
	API_C_EX_BALROGWAR_GET_REWARD();
}

function OnRanking_BtnClick()
{
	toggleWindow("BalrogRankingWnd", true);
	getInstanceL2Util().windowMoveToSide(Me, GetWindowHandle("BalrogRankingWnd"));
}

function CustomTooltip getCustomToolTipBossKill(int nTitleStringNum, int nContextStringNum)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(nTitleStringNum), getInstanceL2Util().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(nContextStringNum), getInstanceL2Util().ColorDesc, "", true, false);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 250;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function OnTimer(int TimerID)
{
	// End:0x52
	if(TimerID == TIME_REMAIN_SEC_ID)
	{
		RemainSec--;
		// End:0x38
		if(RemainSec < 0)
		{
			Me.KillTimer(TIME_REMAIN_SEC_ID);			
		}
		else
		{
			Time_txt.SetText(GetTimeStringMS(RemainSec));
		}
	}
}

function playResultEffectViewPort(string effectPath)
{
	local Vector offset;

	// End:0x89
	if(effectPath == "LineageEffect2.ui_upgrade_succ")
	{
		offset.X = 10.0f;
		offset.Y = -5.0f;
		Reward_EffectViewport.SetScale(6.0f);
		Reward_EffectViewport.SetCameraDistance(1300.0f);
		Reward_EffectViewport.SetOffset(offset);		
	}
	else
	{
		// End:0x10B
		if(effectPath == "LineageEffect.d_firework_a")
		{
			offset.X = 10.0f;
			offset.Y = -5.0f;
			Reward_EffectViewport.SetScale(6.0f);
			Reward_EffectViewport.SetCameraDistance(1300.0f);
			Reward_EffectViewport.SetOffset(offset);
		}
	}
	Reward_EffectViewport.SetFocus();
	Reward_EffectViewport.SpawnEffect(effectPath);
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	return UIControlDialogAssets(poopExpandWnd.GetScript());
}

function SetPopupScript()
{
	local WindowHandle poopExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle DisableWnd;

	poopExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	popupExpandScript = class'UIControlDialogAssets'.static.InitScript(poopExpandWnd);
	DisableWnd = GetWindowHandle(m_WindowName $ ".disable_tex");
	popupExpandScript.SetDisableWindow(DisableWnd);
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop(m_WindowName $ ".disable_tex", false);
}

function ShowPopup()
{
	local UIControlDialogAssets popupExpandScript;
	local TeleportListAPI.TeleportListData listData;

	popupExpandScript = GetPopupExpandScript();
	currentTeleportID = 472;
	listData = getInstanceUIData().GetTeleportListDataByID(currentTeleportID);
	popupExpandScript.SetDialogDesc(GetSystemMessage(5239) $ "\\n\\n" $ "(" $ listData.Name $ ")");
	popupExpandScript.SetUseNeedItem(true);
	popupExpandScript.StartNeedItemList(1);
	popupExpandScript.AddNeedItemClassID(57, 50000);
	popupExpandScript.SetItemNum(1);
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = onClickTeleport;
	popupExpandScript.DelegateOnCancel = onClickCancelDialog;
}

function onClickCancelDialog()
{
	GetPopupExpandScript().Hide();
}

function onClickTeleport()
{
	API_C_EX_BALROGWAR_TELEPORT();
	GetPopupExpandScript().Hide();
	GetWindowHandle(m_WindowName).HideWindow();
}

function playNpcViewport(CharacterViewportWindowHandle ObjectViewport, int NpcID, int Distance, optional int Rotation, optional int nX, optional int nY, optional float Duration, optional string SpawnEffect)
{
	ObjectViewport.SetCameraDistance(Distance);
	ObjectViewport.SetCharacterOffsetX(nX);
	ObjectViewport.SetCharacterOffsetY(nY);
	ObjectViewport.SetCurrentRotation(Rotation);
	ObjectViewport.ShowWindow();
	ObjectViewport.SetSpawnDuration(Duration);
	ObjectViewport.SetNPCInfo(NpcID);
	ObjectViewport.SetUISound(true);
	ObjectViewport.SetSpawnDuration(0.10f);
	ObjectViewport.SpawnNPC();
	ObjectViewport.SpawnEffect(SpawnEffect);
}

function API_C_EX_BALROGWAR_TELEPORT()
{
	local array<byte> stream;
	local UIPacket._C_EX_BALROGWAR_TELEPORT packet;

	// End:0x20
	if(! class'UIPacket'.static.Encode_C_EX_BALROGWAR_TELEPORT(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_BALROGWAR_TELEPORT, stream);
	Debug("--> C_EX_BALROGWAR_TELEPORT ");
}

function API_C_EX_BALROGWAR_GET_REWARD()
{
	local array<byte> stream;
	local UIPacket._C_EX_BALROGWAR_GET_REWARD packet;

	// End:0x20
	if(! class'UIPacket'.static.Encode_C_EX_BALROGWAR_GET_REWARD(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_BALROGWAR_GET_REWARD, stream);
	Debug("--> C_EX_BALROGWAR_GET_REWARD  ");
}

function API_C_EX_BALROGWAR_SHOW_UI()
{
	local array<byte> stream;
	local UIPacket._C_EX_BALROGWAR_SHOW_UI packet;

	// End:0x20
	if(! class'UIPacket'.static.Encode_C_EX_BALROGWAR_SHOW_UI(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_BALROGWAR_SHOW_UI, stream);
	Debug("--> C_EX_BALROGWAR_SHOW_UI  ");
}

function string GetTimeStringMS(int Second)
{
	local int Min, Sec;

	Min = Second / 60;
	Sec = int(float(Second) % float(60));
	return MakeFullSystemMsg(GetSystemMessage(13418), Int2Str(Min), Int2Str(Sec));
}

function string Int2Str(int Num)
{
	// End:0x19
	if(Num < 10)
	{
		return "0" $ string(Num);
	}
	return string(Num);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	// End:0x4C
	if(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset").IsShowWindow())
	{
		GetPopupExpandScript().Hide();		
	}
	else
	{
		GetWindowHandle(m_WindowName).HideWindow();
	}
}

defaultproperties
{
     m_WindowName="BalrogWnd"
}
