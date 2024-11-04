class MarbleGameWnd extends UICommonAPI;

const MAX_PLATE = 40;
const DICE_TIMER_ID = 11233;
const DICE_MOVE_TIMER_ID = 11240;
const DiCE_TIMER_DELAY = 5000;
const BOSS_START_TIMER_ID = 11250;
const BOSS_END_TIMER_ID = 11252;
const PLAYER_WIDTH = 18;
const PLAYER_HEIGHT = 56;


enum PlayerState {
	PS_READY,
	PS_WAIT_REWARD,
	PS_WAIT_MOVE_EVENT,
	PS_IN_PRISON,
	PS_GOAL,
	PS_WAIT_RESET,
	PS_DONE
};

enum MiniGameResultType {
	MGRT_LOSE,
	MGRT_WIN,
	MGRT_DRAW
};

enum MiniGameBossType {
	MGBT_NONE,
	MGBT_ANTARAS,
	MGBT_BAIUM,
	MGBT_ZAKEN,
	MGBT_QUEENANT,
	MGBT_ORFEN,
	MGBT_CORE,
	MGBT_VALAKAS
};

enum CellType {
	CT_NONE,
	CT_EVENT,
	CT_BUFF,
	CT_REWARD,
	CT_MINI_GAME,
	CT_PRISON
};

enum DiceType {
	DT_NORMAL,
	DT_SPECIAL,
	DT_MAX
};

var WindowHandle Me;
var TextureHandle heroPlayerTexture;
var WindowHandle DisableWnd;
var WindowHandle PlateDialogWnd;
var TextBoxHandle PlateDialogWnd_Title_Txt;
var TextureHandle PlateDialogWnd_ResultBg_Tex;
var ItemWindowHandle PlateOption_ItemWindow;
var TextBoxHandle PlateOption_Txt;
var TextBoxHandle PlateDesc_Txt;
var WindowHandle BossDialogWnd;
var CharacterViewportWindowHandle BossObjectViewport;
var AnimTextureHandle BossVsAnimTexture;
var TextureHandle BossVsTexture;
var EffectViewportWndHandle EffectViewportBossDice;
var EffectViewportWndHandle EffectViewportUserDice;
var WindowHandle BossResultWnd;
var ItemWindowHandle BossSlotitem;
var TextBoxHandle BossSlotitemNameText;
var TextBoxHandle BossLuckyNumberText;
var EffectViewportWndHandle effectViewportBossReward;
var TextureHandle BossResultHeaderBgTexture;
var TextureHandle BossOkHighlightTexture;
var ButtonHandle FightBossButton;
var TextBoxHandle bossHeaderText;
var TextBoxHandle bossFlagText;
var TextBoxHandle UserFlagText;
var TextBoxHandle bossOkText;
var WindowHandle DesertIslandDialogWnd;
var TextureHandle DesertIslandStartTexture;
var TextBoxHandle DesertIslandRemainTimeTxt;
var TextBoxHandle DesertIslandDesc_Txt;
var WindowHandle DiceDialogWnd;
var EffectViewportWndHandle DiceEffectViewport;
var WindowHandle RewardRichListWnd;
var RichListCtrlHandle RewardRichList;
var ButtonHandle DiceBtn01;
var ButtonHandle DiceBtn02;
var ButtonHandle DiceHelpBtn01;
var ButtonHandle DiceHelpBtn02;
var TextBoxHandle DiceBtn01Name_Txt;
var TextBoxHandle DiceBtn02Name_Txt;
var TextBoxHandle DiceBtn01ItemWndName_Txt;
var TextBoxHandle DiceBtn02ItemWndName_Txt;
var TextBoxHandle CompleteDesc_Txt;
var WindowHandle CompleteWnd;
var EffectViewportWndHandle CompleteViewport;
var TextBoxHandle CompleteTitle_Txt;
var TextBoxHandle CompleteItemName_Txt;
var ItemWindowHandle Complete_Itemwindow;
var WindowHandle ResetWnd;
var TextBoxHandle ResetTitle_Txt;
var TextBoxHandle ResetItemName_Txt;
var ItemWindowHandle Reset_Itemwindow;
var WindowHandle FianlCompleteWnd;
var string m_WindowName;
var L2UITween l2uiTweenScript;
var int toPlayerToMoveNum;
var int currentPlayerToMoveNum;
var Rect meRect;
var bool bPrisonMode;
var int desertIslandRemainTime;
var L2Util util;
var bool bFirstRun;
var bool bRecover;
var int nMaxNormalDiceUseCount;
var int nRemainNormalDiceUseCount;
var int currentCellType;
var int currentMableGamePlayCount;
var int maxMableGamePlayCount;
var int currentRewardClassID;
var INT64 currentRewardItemNum;
var int currentCellId;
var int beforeCellId;
var int currentRewardBuffID;
var int currentRewardBuffLevel;
var int currentDiceType;
var int CurrentState;
var int currentCompleteItemID;
var INT64 currentCompleteItemNum;
var int currentResetItemID;
var INT64 currentResetItemNum;
var int currentDiceResult;
var bool bEnableDice;
var UIPacket._S_EX_MABLE_GAME_MINIGAME currentEx_BossMiniGame;
var UIPacket._S_EX_MABLE_GAME_PRISON currentEx_Prison;
var UIPacket._S_EX_MABLE_GAME_MOVE currentEx_Move;
var int BossPlayerDice;
var int BossEnemyDice;
var int BossLuckyNumber;
var array<MableGameCellRewardItem> MableGameCellRewardItemArray;
var array<MableGameCellData> MableGameCellDataArray;

function OnRegisterEvent()
{
	RegisterEvent(EV_Test_5);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_SHOW_PLAYER_STATE);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_DICE_RESULT);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_MOVE);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_PRISON);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_REWARD_ITEM);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_SKILL_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_MINIGAME);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_PLAY_UNABLE);
	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_Restart);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	l2uiTweenScript = L2UITween(GetScript("l2UITween"));
	util = L2Util(GetScript("L2Util"));
	Me = GetWindowHandle(m_WindowName);
	heroPlayerTexture = GetTextureHandle(m_WindowName $ ".heroPlayerTexture");
	DiceDialogWnd = GetWindowHandle(m_WindowName $ ".DiceDialogWnd");
	DiceEffectViewport = GetEffectViewportWndHandle(m_WindowName $ ".DiceDialogWnd.DiceEffectViewport");
	PlateDialogWnd = GetWindowHandle(m_WindowName $ ".PlateDialogWnd");
	PlateDialogWnd_Title_Txt = GetTextBoxHandle(m_WindowName $ ".PlateDialogWnd.Title_Txt");
	PlateDialogWnd_ResultBg_Tex = GetTextureHandle(m_WindowName $ ".PlateDialogWnd.ResultBg_Tex");
	PlateOption_ItemWindow = GetItemWindowHandle(m_WindowName $ ".PlateDialogWnd.PlateOption_ItemWindow");
	PlateOption_Txt = GetTextBoxHandle(m_WindowName $ ".PlateDialogWnd.PlateOption_Txt");
	PlateDesc_Txt = GetTextBoxHandle(m_WindowName $ ".PlateDialogWnd.PlateDesc_Txt");
	DisableWnd = GetWindowHandle(m_WindowName $ ".DisableWnd");
	BossDialogWnd = GetWindowHandle(m_WindowName $ ".BossDialogWnd");
	BossObjectViewport = GetCharacterViewportWindowHandle(m_WindowName $ ".BossDialogWnd.BossObjectViewport");
	BossVsAnimTexture = GetAnimTextureHandle(m_WindowName $ ".BossDialogWnd.BossVsAnimTexture");
	BossVsTexture = GetTextureHandle(m_WindowName $ ".BossDialogWnd.BossVsTexture");
	BossResultWnd = GetWindowHandle(m_WindowName $ ".BossDialogWnd.BossResultWnd");
	BossSlotitemNameText = GetTextBoxHandle(m_WindowName $ ".BossDialogWnd.BossResultWnd.ResultPopupWnd.BossSlotitemNameText");
	BossLuckyNumberText = GetTextBoxHandle(m_WindowName $ ".BossDialogWnd.BossResultWnd.ResultPopupWnd.BossLuckyNumberText");
	effectViewportBossReward = GetEffectViewportWndHandle(m_WindowName $ ".BossDialogWnd.BossResultWnd.ResultPopupWnd.EffectViewportReward");
	BossSlotitem = GetItemWindowHandle(m_WindowName $ ".BossDialogWnd.BossResultWnd.ResultPopupWnd.BossSlotitem");
	BossResultHeaderBgTexture = GetTextureHandle(m_WindowName $ ".BossDialogWnd.BossResultWnd.ResultPopupWnd.BossResultHeaderBgTexture");
	bossHeaderText = GetTextBoxHandle(m_WindowName $ ".BossDialogWnd.HeaderText");
	bossFlagText = GetTextBoxHandle(m_WindowName $ ".BossDialogWnd.bossFlagText");
	UserFlagText = GetTextBoxHandle(m_WindowName $ ".BossDialogWnd.UserFlagText");
	bossOkText = GetTextBoxHandle(m_WindowName $ ".BossDialogWnd.OkText");
	FightBossButton = GetButtonHandle(m_WindowName $ ".BossDialogWnd.FightBossButton");
	BossOkHighlightTexture = GetTextureHandle(m_WindowName $ ".BossDialogWnd.OkHighlightTexture");
	EffectViewportBossDice = GetEffectViewportWndHandle(m_WindowName $ ".BossDialogWnd.EffectViewportBossDice");
	EffectViewportUserDice = GetEffectViewportWndHandle(m_WindowName $ ".BossDialogWnd.EffectViewportUserDice");
	DesertIslandDialogWnd = GetWindowHandle(m_WindowName $ ".DesertIslandDialogWnd");
	DesertIslandStartTexture = GetTextureHandle(m_WindowName $ ".DesertIslandDialogWnd.DesertIslandStartTexture");
	DesertIslandRemainTimeTxt = GetTextBoxHandle(m_WindowName $ ".DesertIslandDialogWnd.DesertIslandRemainTimeTxt");
	DesertIslandDesc_Txt = GetTextBoxHandle(m_WindowName $ ".DesertIslandDialogWnd.DesertIslandDesc_Txt");
	RewardRichListWnd = GetWindowHandle(m_WindowName $ ".RewardRichListWnd");
	RewardRichList = GetRichListCtrlHandle(m_WindowName $ ".RewardRichListWnd.RewardRichList");
	DiceBtn01 = GetButtonHandle(m_WindowName $ ".DiceBtn01");
	DiceBtn02 = GetButtonHandle(m_WindowName $ ".DiceBtn02");
	DiceHelpBtn01 = GetButtonHandle(m_WindowName $ ".DiceHelpBtn01");
	DiceHelpBtn02 = GetButtonHandle(m_WindowName $ ".DiceHelpBtn02");
	DiceBtn01Name_Txt = GetTextBoxHandle(m_WindowName $ ".DiceBtn01Name_Txt");
	DiceBtn02Name_Txt = GetTextBoxHandle(m_WindowName $ ".DiceBtn02Name_Txt");
	DiceBtn01ItemWndName_Txt = GetTextBoxHandle(m_WindowName $ ".DiceBtn01ItemWndName_Txt");
	DiceBtn02ItemWndName_Txt = GetTextBoxHandle(m_WindowName $ ".DiceBtn02ItemWndName_Txt");
	CompleteDesc_Txt = GetTextBoxHandle(m_WindowName $ ".CompleteDesc_Txt");
	CompleteWnd = GetWindowHandle(m_WindowName $ ".CompleteWnd");
	CompleteViewport = GetEffectViewportWndHandle(m_WindowName $ ".CompleteWnd.CompleteViewport");
	CompleteTitle_Txt = GetTextBoxHandle(m_WindowName $ ".CompleteWnd.CompleteTitle_Txt");
	CompleteItemName_Txt = GetTextBoxHandle(m_WindowName $ ".CompleteWnd.CompleteItemName_Txt");
	Complete_Itemwindow = GetItemWindowHandle(m_WindowName $ ".CompleteWnd.Complete_Itemwindow");
	ResetWnd = GetWindowHandle(m_WindowName $ ".ResetWnd");
	ResetTitle_Txt = GetTextBoxHandle(m_WindowName $ ".ResetWnd.ResetTitle_Txt");
	ResetItemName_Txt = GetTextBoxHandle(m_WindowName $ ".ResetWnd.ResetItemName_Txt");
	Reset_Itemwindow = GetItemWindowHandle(m_WindowName $ ".ResetWnd.Reset_Itemwindow");
	FianlCompleteWnd = GetWindowHandle(m_WindowName $ ".FianlCompleteWnd");
	bossHeaderText.SetText("");
	bossFlagText.SetText("");
	RewardRichList.SetSelectedSelTooltip(false);
	RewardRichList.SetAppearTooltipAtMouseX(true);
	SetCusomTooltipAtHelpBtn();
	BossVsTexture.HideWindow();
}

function OnShow()
{
	PlaySound("ItemSound3.minigame_start");
	clearCurrentStateVar();
	initControl();
	Me.SetFocus();
}

function OnHide()
{
	API_C_EX_MABLE_GAME_CLOSE();
	clearCurrentStateVar();
	initControl();
}

function initControl()
{
	ResetWnd.HideWindow();
	CompleteWnd.HideWindow();
	DiceDialogWnd.HideWindow();
	PlateDialogWnd.HideWindow();
	FianlCompleteWnd.HideWindow();
	BossDialogWnd.HideWindow();
	DesertIslandDialogWnd.HideWindow();
	Me.KillTimer(DICE_TIMER_ID);
	Me.KillTimer(DICE_MOVE_TIMER_ID);
	Me.KillTimer(BOSS_START_TIMER_ID);
	Me.KillTimer(BOSS_END_TIMER_ID);
	SetDisable(false);
	setRewardViewButton(false);
	BossObjectViewport.HideNPC(0.0);
	BossObjectViewport.SetUISound(false);
}

function clearCurrentStateVar()
{
	currentRewardBuffID = 0;
	currentRewardBuffLevel = 0;
	currentRewardClassID = 0;
	currentRewardItemNum = 0;
	bPrisonMode = false;
	toPlayerToMoveNum = 0;
	beforeCellId = 1;
	currentCellType = 0;
}

function OnEvent(int Event_ID, string param)
{
	if(Event_ID == EV_Restart)
	{
		bFirstRun = false;
	}
	else if(Event_ID == EV_AdenaInvenCount)
	{
		if(Me.IsShowWindow())
		{
			updateDiceState();
		}
	}
	else if(Event_ID == EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_SHOW_PLAYER_STATE)
	{
		initControl();
		ParsePacket_S_EX_MABLE_GAME_SHOW_PLAYER_STATE();
	}
	else if(Event_ID == EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_DICE_RESULT)
	{
		ParsePacket_S_EX_MABLE_GAME_DICE_RESULT();
	}
	else if(Event_ID == EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_MOVE)
	{
		ParsePacket_S_EX_MABLE_GAME_MOVE();
	}
	else if(Event_ID == EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_PRISON)
	{
		ParsePacket_S_EX_MABLE_GAME_PRISON();
	}
	else if(Event_ID == EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_REWARD_ITEM)
	{
		ParsePacket_S_EX_MABLE_GAME_REWARD_ITEM();
	}
	else if(Event_ID == EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_SKILL_INFO)
	{
		ParsePacket_S_EX_MABLE_GAME_SKILL_INFO();
	}
	else if(Event_ID == EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_MINIGAME)
	{
		ParsePacket_S_EX_MABLE_GAME_MINIGAME();
	}
	else if(Event_ID == EV_ProtocolBegin + class'UIPacket'.const.S_EX_MABLE_GAME_PLAY_UNABLE)
	{
		ParsePacket_S_EX_MABLE_GAME_PLAY_UNABLE();
	}
}

function ParsePacket_S_EX_MABLE_GAME_REWARD_ITEM()
{
	local UIPacket._S_EX_MABLE_GAME_REWARD_ITEM packet;
	local MableGameEventData tMableGameEventData;

	if(!Class'UIPacket'.static.Decode_S_EX_MABLE_GAME_REWARD_ITEM(packet))
	{
		return;
	}
	Debug(" -->  S_EX_MABLE_GAME_REWARD_ITEM :  " @ string(packet.nRewardItemClassId) @ string(packet.nRewardItemAmount));
	currentCellType = 3;
	currentRewardClassID = packet.nRewardItemClassId;
	currentRewardItemNum = packet.nRewardItemAmount;
	GetMableGameEventData(currentCellId, MableGameEventType.MGET_REWARD, tMableGameEventData);
	Debug(" tMableGameEventData.EventDesc  " @ tMableGameEventData.EventDesc);
	Debug(" tMableGameEventData.EventGroupDesc  " @ tMableGameEventData.EventGroupDesc);

	if(currentCellId > 39)
	{
		if(CurrentState == 4)
		{
			enableDiceBtn(false);
			showDialogCompleteReward(currentRewardClassID, currentRewardItemNum);
		}
	}
	else
	{
		if((toPlayerToMoveNum == 0) && bRecover)
		{
			enableDiceBtn(false);
			showPlateDialog();
		}
	}
}

function ParsePacket_S_EX_MABLE_GAME_SKILL_INFO()
{
	local UIPacket._S_EX_MABLE_GAME_SKILL_INFO packet;

	if(! class'UIPacket'.static.Decode_S_EX_MABLE_GAME_SKILL_INFO(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_MABLE_GAME_SKILL_INFO :  " @ string(packet.nSkillID)@ string(packet.nLev));
	currentCellType = 2;
	currentRewardBuffID = packet.nSkillID;
	currentRewardBuffLevel = packet.nLev;
}

function ParsePacket_S_EX_MABLE_GAME_PRISON()
{
	local UIPacket._S_EX_MABLE_GAME_PRISON packet;

	if(!Class'UIPacket'.static.Decode_S_EX_MABLE_GAME_PRISON(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_MABLE_GAME_PRISON :  " @ string(packet.nMinDiceForLeavePrison) @ string(packet.nMaxDiceForLeavePrison) @ string(packet.nRemainCount));
	currentEx_Prison = packet;
	desertIslandRemainTime = packet.nRemainCount;
	DesertIslandRemainTimeTxt.SetText(GetSystemString(3624) $ ": " $ string(currentEx_Prison.nRemainCount));
	DesertIslandDesc_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13208), string(packet.nMinDiceForLeavePrison)));
	if((toPlayerToMoveNum == 0) && bRecover)
	{
		OpenCard_DesertIslandMode();
	}
}

function ParsePacket_S_EX_MABLE_GAME_MINIGAME()
{
	local UIPacket._S_EX_MABLE_GAME_MINIGAME packet;

	if(! class'UIPacket'.static.Decode_S_EX_MABLE_GAME_MINIGAME(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_MABLE_GAME_MINIGAME :  " @ string(packet.nBossType) @ string(packet.nLuckyNumber) @ string(packet.nMyDice) @ string(packet.nBossDice) @ string(packet.cMiniGameResult) @ string(packet.bLuckyNumber) @ string(packet.nRewardItemClassId) @ string(packet.nRewardItemAmount));
	currentEx_BossMiniGame = packet;
	currentCellType = 4;
	currentRewardClassID = packet.nRewardItemClassId;
	currentRewardItemNum = packet.nRewardItemAmount;
	// End:0x120
	if((packet.nMyDice == 0) && packet.nBossDice == 0)
	{
		enableDiceBtn(false);
		startBossResult();
	}
}

function ParsePacket_S_EX_MABLE_GAME_PLAY_UNABLE()
{
	Me.HideWindow();
	Debug("--> ParsePacket_S_EX_MABLE_GAME_PLAY_UNABLE");
}

function ParsePacket_S_EX_MABLE_GAME_SHOW_PLAYER_STATE()
{
	local UIPacket._S_EX_MABLE_GAME_SHOW_PLAYER_STATE packet;
	local int i;
	local int currentindex;

	if(bFirstRun == false)
	{
		makeGameStage();
	}
	if(!Class'UIPacket'.static.Decode_S_EX_MABLE_GAME_SHOW_PLAYER_STATE(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_MABLE_GAME_SHOW_PLAYER_STATE :  " @ string(packet.nMableGamePlayCount) @ string(packet.nCurrentCellId) @ string(packet.nRemainNormalDiceUseCount)@ string(packet.nMaxNormalDiceUseCount)@ string(packet.cCurrentState));
	bRecover = true;
	clearRichList();
	
	for(i = 0; i < packet.vFinishRewards.Length; i++)
	{
		AddItemAtRichList(packet.vFinishRewards[i].nPlayCount, packet.vFinishRewards[i].nItemClassID, packet.vFinishRewards[i].nItemAmount, packet.nMableGamePlayCount == packet.vFinishRewards[i].nPlayCount);
		if(packet.nMableGamePlayCount == packet.vFinishRewards[i].nPlayCount)
		{
			currentindex = i;
		}
	}
	maxMableGamePlayCount = packet.vFinishRewards.Length;
	RewardRichList.SetSelectedIndex(currentindex, true);
	
	for(i = 0; i < packet.vResetItems.Length; i++)
	{
		currentResetItemID = packet.vResetItems[i].nItemClassID;
		currentResetItemNum = packet.vResetItems[i].nAmount;
	}
	currentMableGamePlayCount = packet.nMableGamePlayCount;
	currentCellId = packet.nCurrentCellId;
	nMaxNormalDiceUseCount = packet.nMaxNormalDiceUseCount;
	nRemainNormalDiceUseCount = packet.nRemainNormalDiceUseCount;
	CurrentState = packet.cCurrentState;
	Me.ShowWindow();
	CompleteDesc_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13196), string(packet.nMableGamePlayCount)));
	updateDiceState();
	currentPlayerToMoveNum = packet.nCurrentCellId;
	movePlate(currentPlayerToMoveNum);
	enableDiceBtn(true);
	switch(packet.cCurrentState)
	{
		case 0:
			break;
		case 1:
			break;
		case 2:
			break;
		case 3:
			break;
		case 4:
			break;
		case 5:
			enableDiceBtn(false);
			showDialogReset(currentResetItemID, currentResetItemNum);
			break;
		case 6:
			enableDiceBtn(false);
			SetDisable(true);
			FianlCompleteWnd.ShowWindow();
			FianlCompleteWnd.SetFocus();
			break;
	}
}

function updateDiceState()
{
	local INT64 adDiceItemNum;
	local INT64 norDiceItemNum;
	local int normalDiceClassID;
	local int specialDiceClassID;

	if(getInstanceUIData().getIsClassicServer())
	{
		normalDiceClassID = 93885;
		specialDiceClassID = 93886;
	}
	else
	{
		normalDiceClassID = 81461;
		specialDiceClassID = 81462;
	}
	norDiceItemNum = setDiceButtonInfo(true, normalDiceClassID);
	if((nRemainNormalDiceUseCount > 0) && norDiceItemNum > 0 && bEnableDice)
	{
		DiceBtn02.EnableWindow();
		DiceBtn02Name_Txt.SetTextColor(getInstanceL2Util().White);
	}
	else
	{
		DiceBtn02.DisableWindow();
		DiceBtn02Name_Txt.SetTextColor(getInstanceL2Util().Gray);
	}
	DiceBtn02Name_Txt.SetText(GetSystemString(13313)$ "(" $ string(nRemainNormalDiceUseCount)$ "/" $ string(nMaxNormalDiceUseCount)$ ")");
	adDiceItemNum = setDiceButtonInfo(false, specialDiceClassID);
	if(adDiceItemNum > 0 && bEnableDice)
	{
		DiceBtn01.EnableWindow();
		DiceBtn01Name_Txt.SetTextColor(getInstanceL2Util().White);
	}
	else
	{
		DiceBtn01.DisableWindow();
		DiceBtn01Name_Txt.SetTextColor(getInstanceL2Util().Gray);
	}
}

function ParsePacket_S_EX_MABLE_GAME_DICE_RESULT()
{
	local UIPacket._S_EX_MABLE_GAME_DICE_RESULT packet;

	if(!Class'UIPacket'.static.Decode_S_EX_MABLE_GAME_DICE_RESULT(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_MABLE_GAME_DICE_RESULT :  " @ string(packet.nDice) @ string(packet.nResultCellId) @ string(packet.cResultCellType) @ string(packet.nRemainNormalDiceUseCount));
	Debug("before currentCellId" @ string(currentCellId));
	toPlayerToMoveNum = packet.nResultCellId - currentCellId;
	currentDiceResult = packet.nDice;
	beforeCellId = currentCellId;
	currentCellId = packet.nResultCellId;
	currentCellType = packet.cResultCellType;
	nRemainNormalDiceUseCount = packet.nRemainNormalDiceUseCount;
	Debug("toPlayerToMoveNum" @ string(toPlayerToMoveNum));
	Debug("주사위 돌리기 effect Show");
	DiceDialogWnd.ShowWindow();
	DiceDialogWnd.SetFocus();
	DiceEffectViewport.ShowWindow();
	DiceEffectViewport.SetFocus();
	DiceEffectViewport.SetCameraPitch(-10000);
	DiceEffectViewport.SetCameraYaw(Rand(5000) - 2500);
	if(currentDiceType == 0)
	{
		DiceEffectViewport.SpawnEffect("LineageEffect2.white_black_" $ string(packet.nDice) $ "_dice");
	}
	else
	{
		DiceEffectViewport.SpawnEffect("LineageEffect2.yellow_black_" $ string(packet.nDice) $ "_dice");
	}
	enableDiceBtn(false);
	FightBossButton.DisableWindow();
	FightBossButton.HideWindow();
	BossOkHighlightTexture.HideWindow();
	bossOkText.HideWindow();
	Me.KillTimer(DICE_TIMER_ID);
	Me.SetTimer(DICE_TIMER_ID, DiCE_TIMER_DELAY);
}

function ParsePacket_S_EX_MABLE_GAME_MOVE()
{
	local UIPacket._S_EX_MABLE_GAME_MOVE packet;

	if(!Class'UIPacket'.static.Decode_S_EX_MABLE_GAME_MOVE(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_MABLE_GAME_MOVE  :  " @ string(packet.nMoveDelta)@ string(packet.nResultCellId)@ string(packet.cResultCellType));
	beforeCellId = currentCellId;
	currentCellId = packet.nResultCellId;
	currentCellType = 1;
	currentEx_Move = packet;
}

function INT64 setDiceButtonInfo(bool bNormal, int ItemClassID)
{
	local array<ItemInfo> itemInfoArray;
	local INT64 ItemNum;

	class'UIDATA_INVENTORY'.static.FindItemByClassID(ItemClassID, itemInfoArray);
	if(itemInfoArray.Length > 0)
	{
		ItemNum = itemInfoArray[0].ItemNum;
	}
	else
	{
		ItemNum = 0;
	}

	if(bNormal)
	{
		DiceBtn02ItemWndName_Txt.SetText(GetItemNameAll(GetItemInfoByClassID(ItemClassID)) $ " x " $ string(ItemNum));		
	}
	else
	{
		DiceBtn01ItemWndName_Txt.SetText(GetItemNameAll(GetItemInfoByClassID(ItemClassID)) $ " x " $ string(ItemNum));
	}
	return ItemNum;
}

function SetCusomTooltipAtHelpBtn()
{
	local array<DrawItemInfo> drawListArr1;
	local array<DrawItemInfo> drawListArr2;

	drawListArr1[drawListArr1.Length] = addDrawItemText(GetSystemString(13314), getInstanceL2Util().White, "");
	drawListArr2[drawListArr2.Length] = addDrawItemText(GetSystemString(13315), getInstanceL2Util().White, "");
	DiceHelpBtn01.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr1, 180));
	DiceHelpBtn02.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr2, 180));
}

function string getPlateIndex(int Index)
{
	switch(Index)
	{
		case 1:
			return "L2UI_CT1.EmptyBtn";
		case 2:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_Yellow01_";
		case 3:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_Violet_";
		case 4:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_Red_";
		case 5:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_Green_";
		case 6:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_White_";
		case 7:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_Yellow02_";
		case 8:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_Red2_";
		case 9:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_VioletDebuff_";
	}
	return "";
}

function enableDiceBtn(bool flag)
{
	bEnableDice = flag;
	if(flag)
	{
		Debug("=------------ enableDiceBtn 켜라!");
		DiceBtn01.EnableWindow();
		DiceBtn02.EnableWindow();
		updateDiceState();
	}
	else
	{
		Debug("=------------ enableDiceBtn 끄기 !");
		DiceBtn01.DisableWindow();
		DiceBtn02.DisableWindow();
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "DiceBtn01":
			enableDiceBtn(false);
			API_C_EX_MABLE_GAME_ROLL_DICE(1);
			break;
		case "DiceBtn02":
			enableDiceBtn(false);
			API_C_EX_MABLE_GAME_ROLL_DICE(0);
			break;
		case "Complete_Btn":
			API_C_EX_MABLE_GAME_POPUP_OK(3);
			CompleteWnd.HideWindow();
			SetDisable(false);
			Debug("-------------------");
			Debug("currentMableGamePlayCount" @ string(currentMableGamePlayCount));
			Debug("maxMableGamePlayCount" @ string(maxMableGamePlayCount));
			if(currentMableGamePlayCount >= maxMableGamePlayCount)
			{
				enableDiceBtn(false);
				SetDisable(true);
				FianlCompleteWnd.ShowWindow();
				FianlCompleteWnd.SetFocus();
			}
			else
			{
				showDialogReset(currentResetItemID, currentResetItemNum);
			}
			break;
		case "Reset_Btn":
			API_C_EX_MABLE_GAME_RESET(1);
			SetDisable(false);
			ResetWnd.HideWindow();
			break;
		case "ResetClose_Btn":
			SetDisable(false);
			ResetWnd.HideWindow();
			Me.HideWindow();
			break;
		case "PlateOK_Btn":
			SetDisable(false);
			PlateDialogWnd.HideWindow();
			if(currentCellType == 3)
			{
				API_C_EX_MABLE_GAME_POPUP_OK(currentCellType);
				clearCurrentStateVar();
				enableDiceBtn(true);
				return;
			}
			else if(currentCellType == 1)
			{
				Debug("currentEx_Move.cResultCellType" @ string(currentEx_Move.cResultCellType));
				if(currentEx_Move.nMoveDelta == 0)
				{
					currentPlayerToMoveNum = currentEx_Move.nResultCellId;
					Debug("currentCellId" @ string(currentCellId));
					Debug("currentPlayerToMoveNum" @ string(currentPlayerToMoveNum));
					teleportMovePlate(beforeCellId);
					updateDiceState();
				}
				else
				{
					toPlayerToMoveNum = currentEx_Move.nMoveDelta;
					startMovePlate(currentPlayerToMoveNum);
				}
				API_C_EX_MABLE_GAME_POPUP_OK(currentCellType);
				currentCellType = currentEx_Move.cResultCellType;
				return;
			}
			else if(currentCellType == 4)
			{
				OpenCard_BossMode(true);
			}
			else if(currentCellType == 5)
			{
				enableDiceBtn(true);
				OpenCard_DesertIslandMode();
			}
			else
			{
				enableDiceBtn(true);
			}
			break;
		case "FightBossButton":
			PlaySound("InterfaceSound.Event.AdenDice_Throw");
			BossPlayerDice = currentEx_BossMiniGame.nMyDice;
			BossEnemyDice = currentEx_BossMiniGame.nBossDice;
			Debug("currentEx_BossMiniGame.nMyDice " @ string(currentEx_BossMiniGame.nMyDice));
			Debug("currentEx_BossMiniGame.nBossDice " @ string(currentEx_BossMiniGame.nBossDice));
			FightBossButton.DisableWindow();
			FightBossButton.HideWindow();
			BossOkHighlightTexture.HideWindow();
			bossOkText.HideWindow();
			EffectViewportUserDice.SetCameraPitch(-10000);
			EffectViewportUserDice.SetCameraYaw(Rand(5000) - 2500);
			EffectViewportUserDice.SpawnEffect("LineageEffect2.white_black_" $ string(BossPlayerDice) $ "_dice");
			EffectViewportBossDice.SetCameraPitch(-10000);
			EffectViewportBossDice.SetCameraYaw(Rand(5000) - 2500);
			EffectViewportBossDice.SpawnEffect("LineageEffect2.white_red_" $ string(BossEnemyDice) $ "_dice");
			Me.KillTimer(BOSS_START_TIMER_ID);
			Me.SetTimer(BOSS_START_TIMER_ID, DiCE_TIMER_DELAY);
			BossObjectViewport.PlayAttackAnimation(1);
			break;
		case "BossRewardButton":
			Debug("보스 보상");
			Me.KillTimer(BOSS_END_TIMER_ID);
			SetDisable(false);
			BossDialogWnd.HideWindow();
			BossResultWnd.HideWindow();
			enableDiceBtn(true);
			FightBossButton.ShowWindow();
			FightBossButton.EnableWindow();
			BossOkHighlightTexture.ShowWindow();
			bossOkText.ShowWindow();
			BossObjectViewport.HideNPC(0.0);
			BossObjectViewport.SetUISound(false);
			API_C_EX_MABLE_GAME_POPUP_OK(currentCellType);
			break;
		case "ItemListWnd_Btn":
			if(RewardRichListWnd.IsShowWindow())
			{
				setRewardViewButton(false);				
			}
			else
			{
				setRewardViewButton(true);
			}
			break;
		case "FianlComplete_Btn":
			Me.HideWindow();
			break;
	}
}

function setRewardViewButton(bool bFlag)
{
	if(bFlag)
	{
		RewardRichListWnd.ShowWindow();
		RewardRichListWnd.SetFocus();
		RewardRichList.SetFocus();
		GetButtonHandle("MarbleGameWnd.ItemListWnd_Btn").SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_DownBtn_Normal", "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_DownBtn_Down", "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_DownBtn_Over");
	}
	else
	{
		RewardRichListWnd.HideWindow();
		GetButtonHandle("MarbleGameWnd.ItemListWnd_Btn").SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_UpBtn_Normal", "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_UpBtn_Down", "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_UpBtn_Over");
	}
}

function clearRichList()
{
	RewardRichList.DeleteAllItem();
}

function AddItemAtRichList(int nPlayCount, int nItemID, INT64 ItemNum, optional bool bSelect)
{
	local RichListCtrlRowData RowData;
	local string param;
	local ItemInfo Info;

	RowData.cellDataList.Length = 2;
	Info = GetItemInfoByClassID(nItemID);
	Info.ItemNum = ItemNum;
	ItemInfoToParam(Info, param);
	RowData.szReserved = param;
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 0);
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(nItemID)), 32, 32, -34, 2);
	if(bSelect)
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, MakeFullSystemMsg(GetSystemMessage(13195), string(nPlayCount)), util.Yellow, false, 4, 8);		
	}
	else
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, MakeFullSystemMsg(GetSystemMessage(13195), string(nPlayCount)), util.White, false, 4, 8);
	}
	RewardRichList.InsertRecord(RowData);
}

function OpenCard_DesertIslandMode()
{
	PlaySound("ItemSound3.minigame_over");
	bPrisonMode = true;
	SetDisable(true);
	DesertIslandDialogWnd.ShowWindow();
}

function OpenCard_BossMode(bool bVsAnimUse)
{
	local string NpcName;
	local UserInfo myUserInfo;

	if(bVsAnimUse)
	{
		BossVsTexture.HideWindow();
		BossVsAnimTexture.Stop();
		BossVsAnimTexture.ShowWindow();
		BossVsAnimTexture.Play();
		PlaySound("InterfaceSound.Event.AdenDice_BossSpawn");
	}
	if(currentEx_BossMiniGame.nLuckyNumber > 0)
	{
		BossLuckyNumberText.SetText(GetSystemString(13309) $ ": " $ string(currentEx_BossMiniGame.nLuckyNumber));
	}
	else
	{
		BossLuckyNumberText.SetText("");
	}
	SetDisable(true);
	GetPlayerInfo(myUserInfo);
	UserFlagText.SetText(myUserInfo.Name);
	BossDialogWnd.ShowWindow();
	BossDialogWnd.SetFocus();
	FightBossButton.ShowWindow();
	FightBossButton.EnableWindow();
	BossOkHighlightTexture.ShowWindow();
	bossOkText.ShowWindow();
	switch(currentEx_BossMiniGame.nBossType)
	{
		case 1:
			playNpcViewport(BossObjectViewport, 19781, 4500, 28000, 150, 10, 0.0, "");
			NpcName = class'UIDATA_NPC'.static.GetNPCName(19781);
			break;
		case 2:
			playNpcViewport(BossObjectViewport,19782,2300,33000,0,0,0.0,"");
			NpcName = class'UIDATA_NPC'.static.GetNPCName(19782);
			break;
		case 3:
			playNpcViewport(BossObjectViewport, 19783, 400, 33000, 0, -4, 0, "");
			NpcName = class'UIDATA_NPC'.static.GetNPCName(19783);
			break;
		case 4:
			playNpcViewport(BossObjectViewport, 19784, 800, 30000, 30, 0, 0, "");
			NpcName = class'UIDATA_NPC'.static.GetNPCName(19784);
			break;
		case 5:
			playNpcViewport(BossObjectViewport,19785,750,34000,0,0,0.0,"");
			NpcName = class'UIDATA_NPC'.static.GetNPCName(19785);
			break;
		default:
			playNpcViewport(BossObjectViewport,19786,6000,33000,0,380,0.0,"");
			NpcName = class'UIDATA_NPC'.static.GetNPCName(19786);
			break;
	}
	bossHeaderText.SetText(GetSystemMessage(3441));
	bossFlagText.SetText(NpcName);
}

function MakeShakeObject()
{
	l2uiTweenScript.StartShake(m_WindowName $ ".heroPlayerTexture", 6, 500, l2uiTweenScript.directionType.small, 0);
}

function movePlate(int fromPlateNum)
{
	local string prevWnd;
	local string serverStr;
	local int nX;
	local int nY;

	if(getInstanceUIData().getIsClassicServer())
	{
		serverStr = "GameBoardStageClassic";		
	}
	else
	{
		serverStr = "GameBoardStageLive";
	}
	prevWnd = m_WindowName $ "." $ serverStr $ ".BoardPlate" $ getInstanceL2Util().makeZeroString(2, fromPlateNum);
	meRect = Me.GetRect();
	nX = GetWindowHandle(prevWnd).GetRect().nX + PLAYER_WIDTH - meRect.nX;
	nY = GetWindowHandle(prevWnd).GetRect().nY - PLAYER_HEIGHT - meRect.nY;
	heroPlayerTexture.MoveC(nX, nY);
	Debug("순간 이동 :" @ string(fromPlateNum));
}

function startMovePlate(int fromPlateNum)
{
	local string prevWnd;
	local string currWnd;
	local string serverStr;
	local int nX;
	local int nY;
	local int toNx;
	local int toNy;
	local int toPlateNum;

	if(toPlayerToMoveNum > 0)
	{
		toPlateNum = fromPlateNum + 1;
	}
	else
	{
		toPlateNum = fromPlateNum - 1;
	}
	if(getInstanceUIData().getIsClassicServer())
	{
		serverStr = "GameBoardStageClassic";
	}
	else
	{
		serverStr = "GameBoardStageLive";
	}
	prevWnd = m_WindowName $ "." $ serverStr $ ".BoardPlate" $ getInstanceL2Util().makeZeroString(2, fromPlateNum);
	currWnd = m_WindowName $ "." $ serverStr $ ".BoardPlate" $ getInstanceL2Util().makeZeroString(2, toPlateNum);
	meRect = Me.GetRect();
	nX = (GetWindowHandle(prevWnd).GetRect().nX + PLAYER_WIDTH) - meRect.nX;
	nY = (GetWindowHandle(prevWnd).GetRect().nY - PLAYER_HEIGHT) - meRect.nY;
	heroPlayerTexture.MoveC(nX, nY);
	toNx = (GetWindowHandle(currWnd).GetRect().nX + PLAYER_WIDTH) - (nX + meRect.nX);
	toNy = (GetWindowHandle(currWnd).GetRect().nY - PLAYER_HEIGHT) - (nY + meRect.nY);
	TweenLazyStart(m_WindowName $ ".heroPlayerTexture", m_WindowName, 1, l2uiTweenScript.easeType.OUT_STRONG, 300.0, 255.0, toNx, toNy, 0.0, 0.0);
	PlaySound("ItemSound2.smelting.Smelting_dragin");
}

function teleportMovePlate(int fromPlateNum)
{
	local string prevWnd;
	local string currWnd;
	local string serverStr;
	local int nX;
	local int nY;
	local int toNx;
	local int toNy;

	PlaySound("ItemSound3.minigame_block_change");
	if(getInstanceUIData().getIsClassicServer())
	{
		serverStr = "GameBoardStageClassic";
	}
	else
	{
		serverStr = "GameBoardStageLive";
	}
	prevWnd = m_WindowName $ "." $ serverStr $ ".BoardPlate" $ getInstanceL2Util().makeZeroString(2, fromPlateNum);
	currWnd = m_WindowName $ "." $ serverStr $ ".BoardPlate" $ getInstanceL2Util().makeZeroString(2, currentPlayerToMoveNum);
	meRect = Me.GetRect();
	nX = (GetWindowHandle(prevWnd).GetRect().nX + PLAYER_WIDTH) - meRect.nX;
	nY = (GetWindowHandle(prevWnd).GetRect().nY - PLAYER_HEIGHT) - meRect.nY;
	heroPlayerTexture.MoveC(nX, nY);
	toNx = (GetWindowHandle(currWnd).GetRect().nX + PLAYER_WIDTH) - (nX + meRect.nX);
	toNy = (GetWindowHandle(currWnd).GetRect().nY - PLAYER_HEIGHT) - (nY + meRect.nY);
	TweenLazyStart(m_WindowName $ ".heroPlayerTexture", m_WindowName, 2, l2uiTweenScript.easeType.OUT_STRONG, 2000.0, 255.0, toNx, toNy, 0.0, 0.0);
}

function startBossResult()
{
	OpenCard_BossMode(false);
	BossResultWnd.ShowWindow();
	BossSlotitem.Clear();
	BossSlotitem.AddItem(GetItemInfoByClassID(currentEx_BossMiniGame.nRewardItemClassId));
	BossSlotitemNameText.SetText(GetItemInfoByClassID(currentEx_BossMiniGame.nRewardItemClassId).Name $ " x" $ string(currentEx_BossMiniGame.nRewardItemAmount));
	Debug("-- 보스전 결과창 -- nRewardItemClassId : " @ string(currentEx_BossMiniGame.nRewardItemClassId));
	// End:0x17C
	if(currentEx_BossMiniGame.cMiniGameResult == 1)
	{
		BossResultHeaderBgTexture.SetTexture("L2UI_EPIC.MarbleGameWnd_BossWnd_Win");
		effectViewportBossReward.ShowWindow();
		effectViewportBossReward.SetFocus();
		effectViewportBossReward.SpawnEffect("LineageEffect2.ui_upgrade_succ");
		PlaySound("ItemSound3.mini_game.cardgame_succeed");		
	}
	else if(currentEx_BossMiniGame.cMiniGameResult == 0)
	{
			BossResultHeaderBgTexture.SetTexture("L2UI_EPIC.MarbleGameWnd_BossWnd_Lose");
			effectViewportBossReward.ShowWindow();
			effectViewportBossReward.SetFocus();
			effectViewportBossReward.SpawnEffect("LineageEffect2.ui_upgrade_fail");
			PlaySound("ItemSound3.mini_game.cardgame_fail");			
	}
	else
	{
		BossResultHeaderBgTexture.SetTexture("L2UI_EPIC.MarbleGameWnd_BossWnd_Draw");
		effectViewportBossReward.ShowWindow();
		effectViewportBossReward.SetFocus();
		effectViewportBossReward.SpawnEffect("LineageEffect2.y_kn_summon_cubic_fire_body");
		PlaySound("SkillSound14.d_firework_a");
	}
}

function initPlateDialog()
{
	PlateOption_Txt.SetText("");
	PlateDesc_Txt.SetText("");
}

function showPlateDialog()
{
	local ItemInfo Info;
	local SkillInfo SkillInfo;
	local MableGameEventData tMableGameEventData;

	initPlateDialog();
	if(DesertIslandDialogWnd.IsShowWindow())
	{
		return;
	}
	if(currentCellType != 0)
	{
		SetDisable(true);
		PlateDialogWnd.ShowWindow();
		PlateOption_ItemWindow.HideWindow();
	}
	switch(currentCellType)
	{
		case 1:
			PlaySound("ItemSound3.arena_skill_powerup");
			PlateDialogWnd_ResultBg_Tex.SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_PlateDialogBg_Yellow");
			if(currentEx_Move.nMoveDelta == 0)
			{
				GetMableGameEventData(currentPlayerToMoveNum, MableGameEventType.MGET_WARP, tMableGameEventData);
			}
			else
			{
				if(currentEx_Move.nMoveDelta > 0)
				{
					GetMableGameEventData(currentPlayerToMoveNum, MableGameEventType.MGET_NEXT, tMableGameEventData);
				}
				else
				{
					GetMableGameEventData(currentPlayerToMoveNum, MableGameEventType.MGET_BACK, tMableGameEventData);
				}
			}
			toPlayerToMoveNum = currentEx_Move.nMoveDelta;
			PlateDialogWnd_Title_Txt.SetText(tMableGameEventData.EventGroupDesc);
			PlateDesc_Txt.SetText(tMableGameEventData.EventDesc);
			Debug("currentPlayerToMoveNum" @ string(currentPlayerToMoveNum));
			Debug("currentEx_Move.nMoveDelta" @ string(currentEx_Move.nMoveDelta));
			Debug("tMableGameEventData.EventDesc" @ tMableGameEventData.EventDesc);
			Debug("tMableGameEventData.EventGroupDesc" @ tMableGameEventData.EventGroupDesc);
			break;
		case 2:
			PlateDialogWnd_ResultBg_Tex.SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_PlateDialogBg_Blue");
			if(MableGameCellDataArray[currentCellId - 1].CellColor == 9)
			{
				PlateDialogWnd_Title_Txt.SetText(GetSystemString(13399));
				AddSystemMessage(13273);
				PlaySound("Itemsound2.smelting.smelting_dragout");
			}
			else
			{
				PlaySound("InterfaceSound.Event.AdenDice_Buff");
				PlateDialogWnd_Title_Txt.SetText(GetSystemString(13318));
			}
			Debug("currentRewardBuffID" @ string(currentRewardBuffID));
			Debug("currentRewardBuffLevel" @ string(currentRewardBuffLevel));
			if(! GetSkillInfo(currentRewardBuffID, currentRewardBuffLevel, 0, SkillInfo))
			{
				Debug("ERROR - no skill info!!");
				return;
			}
			else
			{
				Info.Level = SkillInfo.SkillLevel;
				Info.SubLevel = SkillInfo.SkillSubLevel;
				Info.Name = SkillInfo.SkillName;
				Info.IconName = SkillInfo.TexName;
				Info.IconPanel = SkillInfo.IconPanel;
				Info.Description = SkillInfo.SkillDesc;
				Info.ShortcutType = 2;
			}
			PlateOption_ItemWindow.ShowWindow();
			PlateOption_ItemWindow.Clear();
			PlateOption_ItemWindow.AddItem(Info);
			PlateOption_ItemWindow.SetTooltipType("Skill");
			PlateOption_Txt.SetText(SkillInfo.SkillName $ " lv" $ string(currentRewardBuffLevel));
			break;
		case 3:
			PlaySound("ItemSound2.smelting.smelting_finalD");
			if(currentCellId > 39)
			{
				showDialogCompleteReward(currentRewardClassID, currentRewardItemNum);
			}
			else
			{
				PlateDialogWnd_Title_Txt.SetText(GetSystemString(3004));
				PlateDialogWnd_ResultBg_Tex.SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_PlateDialogBg_Blue");
				PlateOption_ItemWindow.ShowWindow();
				Info = GetItemInfoByClassID(currentRewardClassID);
				Info.ItemNum = currentRewardItemNum;
				PlateOption_ItemWindow.Clear();
				PlateOption_ItemWindow.AddItem(Info);
				PlateOption_ItemWindow.SetTooltipType("Inventory");
				PlateOption_Txt.SetText(Info.Name $ " x" $ string(Info.ItemNum));
			}
			break;
		case 4:
			PlateDialogWnd_Title_Txt.SetText(GetSystemString(13319));
			PlateDialogWnd_ResultBg_Tex.SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_PlateDialogBg_Red");
			PlaySound("InterfaceSound.Event.AdenDice_BossPopup");
			break;
		case 5:
			PlaySound("InterfaceSound.charstat_open_01");
			PlateDialogWnd_Title_Txt.SetText(GetSystemString(13320));
			PlateDialogWnd_ResultBg_Tex.SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_PlateDialogBg_Green");
			break;
		default:
			enableDiceBtn(true);
			break;
	}
}

function showDialogCompleteReward(int ItemClassID, INT64 ItemNum)
{
	local ItemInfo Info;

	CompleteWnd = GetWindowHandle(m_WindowName $ ".CompleteWnd");
	CompleteViewport = GetEffectViewportWndHandle(m_WindowName $ ".CompleteWnd.CompleteViewport");
	enableDiceBtn(false);
	SetDisable(true);
	CompleteWnd.ShowWindow();
	Info = GetItemInfoByClassID(ItemClassID);
	Info.ItemNum = ItemNum;
	Complete_Itemwindow.Clear();
	Complete_Itemwindow.AddItem(Info);
	CompleteItemName_Txt.SetText(Info.Name $ " x" $ string(Info.ItemNum));
	CompleteTitle_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13197), string(currentMableGamePlayCount)));
	CompleteViewport.ShowWindow();
	CompleteViewport.SpawnEffect("LineageEffect2.ui_upgrade_succ");
	PlaySound("ItemSound3.enchant_success");	
}

function showDialogReset(int ItemClassID, INT64 ItemNum)
{
	local ItemInfo Info;

	enableDiceBtn(false);
	SetDisable(true);
	ResetWnd.ShowWindow();
	Info = GetItemInfoByClassID(ItemClassID);
	Info.ItemNum = ItemNum;
	Reset_Itemwindow.Clear();
	Reset_Itemwindow.AddItem(Info);
	ResetItemName_Txt.SetText(GetItemNameAll(GetItemInfoByClassID(ItemClassID)) $ " x " $ string(ItemNum));	
}

function setStagePlagteCustomTooltip(int plateNum)
{
	local string CellName;

	CellName = MableGameCellDataArray[plateNum - 1].CellName;
	GetButtonHandle(getPathPlate(plateNum) $ ".boardBtn").SetTooltipCustomType(getPlateToolTip(CellName, MableGameCellDataArray[plateNum - 1].RewardItems));
}

function CustomTooltip getPlateToolTip(string Title, array<MableGameCellRewardItem> RewardItems)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local int i;
	local string TextureName, ItemName;

	drawListArr[drawListArr.Length] = addDrawItemText(Title, getInstanceL2Util().BrightWhite, "", true, true);

	if(RewardItems.Length > 0)
	{
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2984), getInstanceL2Util().Yellow, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		
		for(i = 0; i < RewardItems.Length; i++)
		{
			TextureName = Class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(RewardItems[i].ItemClassID));
			drawListArr[drawListArr.Length] = addDrawItemTextureCustom(TextureName, true, true, 0, 0, 32, 32);
			ItemName = Class'UIDATA_ITEM'.static.GetItemName(GetItemID(RewardItems[i].ItemClassID));
			drawListArr[drawListArr.Length] = addDrawItemText(ItemName, getInstanceL2Util().BWhite, "", false, true, 4, 0);
			if(RewardItems[i].ItemCount <= 0)
			{
				RewardItems[i].ItemCount = 1;
			}
			drawListArr[drawListArr.Length] = addDrawItemText("x" $ string(RewardItems[i].ItemCount), getInstanceL2Util().BWhite, "", true, true, 36, -16);
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		}
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 30;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function string getPathPlate(int plateNum)
{
	local string Path;

	Path = m_WindowName $ ".";
	if(getInstanceUIData().getIsClassicServer())
	{
		Path = Path $ "GameBoardStageClassic.BoardPlate";
	}
	else
	{
		Path = Path $ "GameBoardStageLive.BoardPlate";
	}
	Path = Path $ getInstanceL2Util().makeZeroString(2, plateNum);
	return Path;
}

function makeGameStage()
{
	local int i;
	local string btnStr;
	local MableGameCellData tMableGameCellData;

	bFirstRun = true;
	if(getInstanceUIData().getIsClassicServer())
	{
		GetWindowHandle(m_WindowName $ "." $ "GameBoardStageClassic").ShowWindow();
		GetWindowHandle(m_WindowName $ "." $ "GameBoardStageLive").HideWindow();
	}
	else
	{
		GetWindowHandle(m_WindowName $ "." $ "GameBoardStageClassic").HideWindow();
		GetWindowHandle(m_WindowName $ "." $ "GameBoardStageLive").ShowWindow();
	}
	MableGameCellDataArray.Remove(0, MableGameCellDataArray.Length);
	MableGameCellRewardItemArray.Remove(0, MableGameCellRewardItemArray.Length);
	
	for(i = 1; i < 41; i++)
	{
		GetMableGameCellData(i, tMableGameCellData);
		MableGameCellDataArray.Insert(MableGameCellDataArray.Length, 1);
		MableGameCellDataArray[MableGameCellDataArray.Length - 1] = tMableGameCellData;
		Debug("셀 CellColor    :" @ string(i) @ string(MableGameCellDataArray[MableGameCellDataArray.Length - 1].CellColor));
	}
	
	for(i = 1; i <= MableGameCellDataArray.Length; i++)
	{
		btnStr = getPlateIndex(MableGameCellDataArray[i - 1].CellColor);
		if(MableGameCellDataArray[i - 1].CellColor == 8)
		{
			GetButtonHandle(getPathPlate(i) $ ".boardAnim").ShowWindow();
		}
		else
		{
			GetButtonHandle(getPathPlate(i) $ ".boardAnim").HideWindow();
		}
		if(btnStr == "L2UI_CT1.EmptyBtn")
		{
			GetButtonHandle(getPathPlate(i) $ ".boardBtn").SetTexture(btnStr, btnStr, btnStr);
		}
		else
		{
			GetButtonHandle(getPathPlate(i) $ ".boardBtn").SetTexture(btnStr $ "Normal", btnStr $ "Over", btnStr $ "Over");
		}
		setStagePlagteCustomTooltip(i);
	}
}

function API_C_EX_MABLE_GAME_OPEN()
{
	local array<byte> stream;

	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_MABLE_GAME_OPEN, stream);
}

function API_C_EX_MABLE_GAME_ROLL_DICE(int cDiceType)
{
	local array<byte> stream;
	local UIPacket._C_EX_MABLE_GAME_ROLL_DICE packet;

	packet.cDiceType = cDiceType;
	if(! class'UIPacket'.static.Encode_C_EX_MABLE_GAME_ROLL_DICE(stream, packet))
	{
		return;
	}
	bRecover = false;
	currentDiceType = cDiceType;
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_MABLE_GAME_ROLL_DICE, stream);
	PlaySound("InterfaceSound.Event.AdenDice_Throw");
	Debug("--> API_C_EX_MABLE_GAME_ROLL_DICE:" @ string(cDiceType));
}

function API_C_EX_MABLE_GAME_POPUP_OK(int cCellType)
{
	local array<byte> stream;
	local UIPacket._C_EX_MABLE_GAME_POPUP_OK packet;

	packet.cCellType = cCellType;
	if(! class'UIPacket'.static.Encode_C_EX_MABLE_GAME_POPUP_OK(stream,packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_MABLE_GAME_POPUP_OK, stream);
	Debug("--> API_C_EX_MABLE_GAME_POPUP_OK" @ string(cCellType));
}

function API_C_EX_MABLE_GAME_RESET(int nResetItemType)
{
	local array<byte> stream;
	local UIPacket._C_EX_MABLE_GAME_RESET packet;

	packet.nResetItemType = nResetItemType;
	if(! class'UIPacket'.static.Encode_C_EX_MABLE_GAME_RESET(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_MABLE_GAME_RESET, stream);
	Debug("--> API_C_EX_MABLE_GAME_RESET:" @ string(nResetItemType));
}

function API_C_EX_MABLE_GAME_CLOSE()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_MABLE_GAME_CLOSE, stream);
	Debug("--> API_C_EX_MABLE_GAME_CLOSE");
}

function OnCallUCFunction(string functionName, string param)
{
	Debug("OnCallUCFunction CompleteTween" @ param);
	switch(functionName)
	{
		case l2uiTweenScript.TWEENEND:
			if(int(param) == 1)
			{
				if(toPlayerToMoveNum > 0)
				{
					toPlayerToMoveNum--;
					currentPlayerToMoveNum++;
					if(currentPlayerToMoveNum >= MAX_PLATE)
					{
						showDialogCompleteReward(currentRewardClassID, currentRewardItemNum);
						return;
					}
					if(toPlayerToMoveNum > 0)
					{
						startMovePlate(currentPlayerToMoveNum);
					}
					else
					{
						showPlateDialog();
					}
					Debug("전진" @ string(toPlayerToMoveNum));
					Debug("currentPlayerToMoveNum" @ string(currentPlayerToMoveNum));
				}
				else if(toPlayerToMoveNum < 0)
				{
					Debug("후진" @ string(toPlayerToMoveNum));
					toPlayerToMoveNum++;
					currentPlayerToMoveNum--;
					if(currentPlayerToMoveNum <= 1)
					{
						return;
					}
					if(toPlayerToMoveNum < 0)
					{
						startMovePlate(currentPlayerToMoveNum);
					}
					else
					{
						showPlateDialog();
					}
				}
			}
			else if(int(param)== 2)
			{
				showPlateDialog();
			}
			break;
	}
}

function OnTimer(int TimerID)
{
	if(TimerID == DICE_TIMER_ID)
	{
		Me.KillTimer(DICE_TIMER_ID);
		DiceEffectViewport.SpawnEffect("");
		Debug("감옥 체크 is currentState" @ string(CurrentState == 5));
		Debug("currentState" @ string(CurrentState));
		Debug("bPrisonMode" @ string(bPrisonMode));
		if(bPrisonMode)
		{
			if(currentDiceResult >= currentEx_Prison.nMinDiceForLeavePrison)
			{
				PlaySound("ItemSound3.enchant_success");
				bPrisonMode = false;
				desertIslandRemainTime = 0;
				toPlayerToMoveNum = 1;
				SetDisable(false);
				DesertIslandDialogWnd.HideWindow();
				Me.SetTimer(DICE_MOVE_TIMER_ID, 1000);
				Debug("- 무인도 탈출 초기화- 높은 주사위로 탈출");
			}
			else
			{
				Debug("bPrisonMode" @ string(bPrisonMode));
				Debug("desertIslandRemainTime" @ string(desertIslandRemainTime));
				Debug("toPlayerToMoveNum" @ string(toPlayerToMoveNum));
				if(toPlayerToMoveNum > 0)
				{
					toPlayerToMoveNum = 1;
					bPrisonMode = false;
					desertIslandRemainTime = 0;
					SetDisable(false);
					DesertIslandDialogWnd.HideWindow();
					Me.SetTimer(DICE_MOVE_TIMER_ID, 1000);
					Debug("- 무인도 탈출 3회 이상 돌려서 그냥 탈출");
				}
				else
				{
					enableDiceBtn(true);
				}
			}
		}
		else
		{
			Me.SetTimer(DICE_MOVE_TIMER_ID, 1000);
		}
	}
	else if(TimerID == DICE_MOVE_TIMER_ID)
	{
		Debug("currentPlayerToMoveNum" @ string(currentPlayerToMoveNum));
		startMovePlate(currentPlayerToMoveNum);
		DiceDialogWnd.HideWindow();
		Me.KillTimer(DICE_MOVE_TIMER_ID);
	}
	else if(TimerID == BOSS_START_TIMER_ID)
	{
		Me.KillTimer(BOSS_START_TIMER_ID);
		EffectViewportUserDice.SpawnEffect("");
		EffectViewportBossDice.SpawnEffect("");
		startBossResult();
	}
	else if(TimerID == BOSS_END_TIMER_ID)
	{
		Me.KillTimer(BOSS_END_TIMER_ID);
		SetDisable(false);
		BossDialogWnd.HideWindow();
	}
}

function OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
	switch(a_WindowHandle)
	{
		case BossVsAnimTexture:
			BossVsAnimTexture.Stop();
			BossVsAnimTexture.HideWindow();
			BossVsTexture.ShowWindow();
			break;
	}
}

function SetDisable(bool bFlag)
{
	if(bFlag)
	{
		DisableWnd.SetFocus();
		DisableWnd.ShowWindow();
	}
	else
	{
		DisableWnd.HideWindow();
	}
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
	ObjectViewport.SetSpawnDuration(0.1);
	ObjectViewport.SpawnNPC();
	ObjectViewport.SpawnEffect(SpawnEffect);
}

function Rect TweenLazyStart(string TargetName, string Owner, int Id, L2UITween.easeType ease, float Duration, float Alpha, float MoveX, float MoveY, optional float SizeX, optional float SizeY, optional float Delay)
{
	local L2UITween.TweenObject tweenObj;
	local Rect mRect;

	tweenObj.Position = 0.0;
	tweenObj.Delay = Delay;
	GetWindowHandle(TargetName).GetRect();
	tweenObj.Target = GetWindowHandle(TargetName);
	tweenObj.Owner = Owner;
	tweenObj.Id = Id;
	tweenObj.ease = ease;
	tweenObj.Duration = Duration;
	tweenObj.Alpha = Alpha;
	tweenObj.MoveX = MoveX;
	tweenObj.MoveY = MoveY;
	tweenObj.SizeX = SizeX;
	tweenObj.SizeY = SizeY;
	l2uiTweenScript.AddTweenObject(tweenObj);
	return mRect;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_WindowName="MarbleGameWnd"
}
