/**
 * ���� ���� (Ŭ����)
 * 
 * http://l2-redmine/redmine/issues/7194
 *   
 *   ���� ���ɾ� 
 *   //magiclamp on
 *   //magiclamp count 100
 *   //sw name=MagicLampWnd
 **/ 
class MagicLampWnd extends UICommonAPI;

const TIMER_ID = 11231;
const TIMER_DELAY = 2000;
const TRY_MAX = 1000;

const HighGradeItemClassID = 91641;

var int nLampCount;

enum GameMode 
{
	NormalMode,
	AdvancedMode
};

var WindowHandle Me;
var TextureHandle CostBg_Tex;
var TextureHandle GameStartCancleBg_Tex;
var WindowHandle MagicLampResultWnd;
var TextureHandle MagicLampResultBg_Tex;
var TextureHandle MagicLampResultBgPattern_Tex;

var ButtonHandle Ok_Btn;

var TextBoxHandle MagicLampResultTitle_Txt;
//var TextureHandle WndDisable_Tex;
var TextureHandle MagicLamp_Tex;
var TextureHandle VoucherIcon_Tex;
var TextureHandle VoucherIconBg_Tex;
var TextureHandle NumofPlayTxtBg_Tex;

var ButtonHandle NumofPlayUp_Btn;
var ButtonHandle NumofPlayDown_Btn;
var ButtonHandle NumofPlayMax_Btn;
var ButtonHandle GameStartorCancle_Btn;

var TextBoxHandle VoucherName_Txt;
var TextBoxHandle VoucherNum_Txt;
var TextBoxHandle VoucherMyNum_Txt;
var TextBoxHandle NumofPlayTitle_Txt;
//var TextBoxHandle NumofPlay_Txt;

var EditBoxHandle NumofPlay_EditBox;

var EffectViewportWndHandle EffectViewport01;
var EffectViewportWndHandle EffectViewport02;

// ��Ȱ�� ������
var WindowHandle DisableWnd;
var TextBoxHandle AdenaName_Txt;
var TextBoxHandle AdenaMyNum_Txt;
var TextureHandle AdenaIcon_Tex;
var TextBoxHandle AllExpNum_Txt;
var TextBoxHandle AllSpNum_Txt;
var CheckBoxHandle Advanced_CheckBox;
var WindowHandle MagicLampProbability_Wnd;
var int needPerGameForAdvanced;
var int TryMaxCount;

var int nGameCount;
var int nCountPerGame;
var int nCount;
var int nSize;

var int nGameMode;
//var int nCurrentBetCount;
var bool bIsGameStartClick;
var INT64 nHighgradeAmount;

event OnRegisterEvent()
{
	RegisterEvent(EV_MagicLamp_ExpInfo);
	RegisterEvent(EV_MagicLamp_GameInfo); // 11081
	RegisterEvent(EV_MagicLamp_GameResult); // 11082
	RegisterEvent(EV_RESTART);
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle("MagicLampWnd");

	DisableWnd = GetWindowHandle("MagicLampWnd.DisableWnd");
	CostBg_Tex = GetTextureHandle("MagicLampWnd.CostBg_Tex");
	GameStartCancleBg_Tex = GetTextureHandle("MagicLampWnd.GameStartCancleBg_Tex");

	EffectViewport01 = GetEffectViewportWndHandle("MagicLampWnd.EffectViewport01");
	//EffectViewport02 = GetEffectViewportWndHandle("MagicLampWnd.MagicLampResultWnd.EffectViewport02");
	EffectViewport02 = GetEffectViewportWndHandle("MagicLampWnd.EffectViewport02");
	//EffectViewport03 = GetEffectViewportWndHandle("MagicLampWnd.EffectViewport03");


	MagicLampResultWnd = GetWindowHandle("MagicLampWnd.MagicLampResultWnd");
	MagicLampResultBg_Tex = GetTextureHandle("MagicLampWnd.MagicLampResultWnd.MagicLampResultBg_Tex");
	MagicLampResultBgPattern_Tex = GetTextureHandle("MagicLampWnd.MagicLampResultWnd.MagicLampResultBgPattern_Tex");

	//Card1stBack_Tex = GetTextureHandle("MagicLampWnd.MagicLampResultWnd.Card1stBack_Tex");
	Ok_Btn = GetButtonHandle("MagicLampWnd.MagicLampResultWnd.OK_Btn");
	MagicLampResultTitle_Txt = GetTextBoxHandle("MagicLampWnd.MagicLampResultWnd.MagicLampResultTitle_Txt");

	//WndDisable_Tex = GetTextureHandle("MagicLampWnd.WndDisable_Tex");

	NumofPlayUp_Btn = GetButtonHandle("MagicLampWnd.NumofPlayUp_Btn");
	NumofPlayDown_Btn = GetButtonHandle("MagicLampWnd.NumofPlayDown_Btn");
	NumofPlayMax_Btn = GetButtonHandle("MagicLampWnd.NumofPlayMax_Btn");
	GameStartorCancle_Btn = GetButtonHandle("MagicLampWnd.GameStartorCancle_Btn");

	VoucherName_Txt = GetTextBoxHandle("MagicLampWnd.VoucherName_Txt");
	VoucherMyNum_Txt = GetTextBoxHandle("MagicLampWnd.VoucherMyNum_Txt");

	AdenaName_Txt = GetTextBoxHandle("MagicLampWnd.AdenaName_Txt");
	AdenaMyNum_Txt = GetTextBoxHandle("MagicLampWnd.AdenaMyNum_Txt");
	AdenaIcon_Tex = GetTextureHandle("MagicLampWnd.AdenaIcon_Tex");

	NumofPlayTitle_Txt = GetTextBoxHandle("MagicLampWnd.NumofPlayTitle_Txt");
	//NumofPlay_Txt = GetTextBoxHandle("MagicLampWnd.NumofPlay_Txt");
	NumofPlay_EditBox = GetEditBoxHandle("MagicLampWnd.NumofPlay_EditBox");

	Advanced_CheckBox = GetCheckBoxHandle("MagicLampWnd.Advanced_CheckBox");
	MagicLamp_Tex = GetTextureHandle("MagicLampWnd.MagicLamp_Tex");

	AllExpNum_Txt = GetTextBoxHandle("MagicLampWnd.MagicLampResultWnd.AllExpNum_Txt");
	AllSpNum_Txt = GetTextBoxHandle("MagicLampWnd.MagicLampResultWnd.AllSpNum_Txt");
	MagicLampProbability_Wnd = GetWindowHandle("MagicLampWnd.MagicLampProbability_Wnd");
	bIsGameStartClick = false;
	Advanced_CheckBox.SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(13241), getInstanceL2Util().Yellow, "", false,,,,,,,,, 220));
	SetItemCountEditBox(1);
}

function Init()
{
	MagicLampResultWnd.HideWindow();
}

event OnShow()
{
	if(isAdvancedLampPossible())
	{
		Advanced_CheckBox.EnableWindow();
	}
	else
	{
		Advanced_CheckBox.DisableWindow();
	}
	SetItemCountEditBox(1);
	bIsGameStartClick = false;
	GameStartorCancle_Btn.SetButtonName(160); // ���ӽ���
	DisableCurrentWindow(false);
	MagicLampResultWnd.HideWindow();
	MagicLampProbability_Wnd.HideWindow();
	RequestMagicLampGameInfo(GetGameModeType());
	EffectViewport01.SpawnEffect("LineageEffect2.ui_soul_crystal");
}

event OnHide()
{
	Me.KillTimer(TIMER_ID);
	EffectViewport01.SpawnEffect("");
	EffectViewport02.SpawnEffect("");
	GameStartorCancle_Btn.SetButtonName(160); // ���ӽ���
}

function updateProbabilityList()
{
	local array<MagicLampResultItemUIData> oItemList;
	local int i;
	local bool bAdvanced;
	local string probabilityStr;

	// End:0x61
	if(GetTabHandle("MagicLampWnd.MagicLampProbability_Wnd.MagicLampProbability_Tab").GetTopIndex() == 0)
	{
		bAdvanced = false;		
	}
	else
	{
		bAdvanced = true;
	}
	Debug("bAdvanced" @ string(bAdvanced));
	// End:0x9B
	if(bAdvanced)
	{
		GetMagicLampAdvancedResultItemList(oItemList);		
	}
	else
	{
		GetMagicLampNormalResultItemList(oItemList);
	}

	// End:0x2FA [Loop If]
	for(i = 0; i < oItemList.Length; i++)
	{
		GetItemWindowHandle("MagicLampWnd.MagicLampProbability_Wnd.CardWnd" $ string(i + 1) $ ".ItemWnd").Clear();
		GetItemWindowHandle("MagicLampWnd.MagicLampProbability_Wnd.CardWnd" $ string(i + 1) $ ".ItemWnd").AddItem(GetItemInfoByClassID(oItemList[i].ItemClassID));
		GetTextBoxHandle("MagicLampWnd.MagicLampProbability_Wnd.CardWnd" $ string(i + 1) $ ".ExpNum_Txt").SetText(MakeCostString(string(oItemList[i].Exp)));
		GetTextBoxHandle("MagicLampWnd.MagicLampProbability_Wnd.CardWnd" $ string(i + 1) $ ".SpNum_Txt").SetText(MakeCostString(string(oItemList[i].Sp)));
		probabilityStr = getInstanceL2Util().CutFloatDecimalPlaces(oItemList[i].Probability, 2);
		GetTextBoxHandle("MagicLampWnd.MagicLampProbability_Wnd.CardWnd" $ string(i + 1) $ ".Probability_Txt").SetText(probabilityStr);
	}
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		//case EV_MagicLamp_ExpInfo:
			 //Debug("EV_MagicLamp_ExpInfo : " @ param);
		 //	break;

		case EV_MagicLamp_GameInfo :
			//Me.ShowWindow();
			Debug("EV_MagicLamp_GameInfo : " @ param);
			magicLampGameInfoHandler(param);
			break;

		case EV_MagicLamp_GameResult :
			Debug("EV_MagicLamp_GameResult : " @ param);
			magicLampGameResultHandler(param);
			break;		

	  	case EV_RESTART: 
			bIsGameStartClick = false;
			Advanced_CheckBox.SetCheck(false);
			break;
	}
}

function magicLampGameResultHandler(string param)
{
	local int i;
	local int resultCardCount;
	local int nGradeNum;
	local int nRewardCount;
	local bool bGet1st;
	local INT64 nEXP;
	local INT64 nSP;
	local INT64 nExpTotal;
	local INT64 nSPTotal;

	DisableCurrentWindow(true);
	GameStartorCancle_Btn.SetButtonName(160);
	MagicLampResultWnd.ShowWindow();
	MagicLampResultWnd.SetFocus();
	MagicLampProbability_Wnd.HideWindow();
	ParseInt(param, "Size", resultCardCount);

	for (i = 1;i <= 4;i++)
	{
		GetItemWindowHandle("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(i) $ ".ItemWnd").Clear();
		GetItemWindowHandle("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(i) $ ".ItemWnd").AddItem(getCustomRewardItemInfo(i));
		setCardInfo(i, 0, 0, 0);
	}

	for (i = 1;i <= resultCardCount;i++)
	{
		ParseInt(param, "GradeNum_" $ string(i), nGradeNum);
		ParseInt(param, "RewardCount_" $ string(i), nRewardCount);
		ParseINT64(param, "EXP_" $ string(i), nEXP);
		ParseINT64(param, "SP_" $ string(i), nSP);
		nExpTotal = nExpTotal + nEXP * nRewardCount;
		nSPTotal = nSPTotal + nSP * nRewardCount;
		setCardInfo(nGradeNum, nRewardCount, nEXP, nSP);
		if(nGradeNum == 1 && nRewardCount > 0)
		{
			bGet1st = true;
		}
	}
	// End:0x26C
	if(bGet1st)
	{
		playResultEffectViewPort("LineageEffect.d_firework_a");
	}
	else
	{
		playResultEffectViewPort("LineageEffect2.ui_upgrade_succ");
	}
	PlaySound("InterfaceSound.MagicLamp_End");
	AllExpNum_Txt.SetText(MakeCostStringINT64(nExpTotal));
	AllSpNum_Txt.SetText(MakeCostStringINT64(nSPTotal));
}

function setCardInfo (int nGradeNum, int nRewardCount, INT64 nEXP, INT64 nSP)
{
	GetTextBoxHandle("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(nGradeNum) $ ".ExpNum_Txt").SetText(MakeCostStringINT64(nEXP));
	GetTextBoxHandle("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(nGradeNum) $ ".SpNum_Txt").SetText(MakeCostStringINT64(nSP));
	GetTextBoxHandle("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(nGradeNum) $ ".ItemNum_Txt").SetText(" x" $ string(nRewardCount));
	// End:0x172
	if(nRewardCount > 0)
	{
		GetItemWindowHandle("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(nGradeNum) $ ".ItemWnd").EnableWindow();
	}
	else
	{
		GetItemWindowHandle("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(nGradeNum) $ ".ItemWnd").DisableWindow();
	}
}

function ItemInfo getCustomRewardItemInfo(int nGradeNum)
{
	local string Icon;
	local string panel;
	local ItemInfo Info;

	if(nGameMode == 0)
	{
		switch (nGradeNum)
		{
			case 1:
				Icon = "icon.r99_soul_stone_i00";
				panel = "icon.panel_star_r3";
				break;
			case 2:
				Icon = "icon.r99_soul_stone_i05";
				panel = "icon.panel_star_r2";
				break;
			case 3:
				Icon = "icon.r99_soul_stone_i02";
				panel = "icon.panel_star_r1";
				break;
			case 4:
				Icon = "icon.r99_soul_stone_i04";
				panel = "icon.panel_2";
				break;
		}
	}
	else
	{
		switch (nGradeNum)
		{
			case 1:
				Icon = "icon.ensoul_big_pp";
				panel = "icon.panel_star_r3";
				break;
			case 2:
				Icon = "icon.ensoul_big_pm";
				panel = "icon.panel_star_r2";
				break;
			case 3:
				Icon = "icon.ensoul_big_m";
				panel = "icon.panel_star_r1";
				break;
			case 4:
				Icon = "icon.ensoul_big_ep";
				panel = "icon.panel_2";
				break;
		}
	}
	Info.IconName = Icon;
	Info.IconPanel = panel;
	return Info;
}

function magicLampGameInfoHandler(string param)
{
	local int nSize, i, nItemClassID;

	Debug("- magicLampGameInfoHandler:" @ param);
	ParseInt(param, "MaxCount", TryMaxCount);	
	ParseInt(param, "GameCount", nGameCount);
	ParseInt(param, "CountPerGame", nCountPerGame);
	ParseInt(param, "Count", nCount);
	ParseInt(param, "GameMode", nGameMode);
	if(nGameMode == GameMode.AdvancedMode)
	{
		ParseInt(param, "Size", nSize);
		for (i = 1; i <= nSize; i++)
		{
			ParseInt(param, "ItemClassID_" $ string(i), nItemClassID);
			ParseInt(param, "AmountPerGame_" $ string(i), needPerGameForAdvanced);
			ParseINT64(param, "Amount_" $ string(i), nHighgradeAmount);
			// [Explicit Break]
			break;
		}
		AdenaName_Txt.SetTextColor(getInstanceL2Util().White);
		AdenaIcon_Tex.SetAlpha(255);
		AdenaIcon_Tex.SetTexture(class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(nItemClassID)));
		AdenaMyNum_Txt.ShowWindow();
		AdenaName_Txt.ShowWindow();
		AdenaName_Txt.SetText(class'UIDATA_ITEM'.static.GetItemName(GetItemID(91641)) $ " x" $ string(needPerGameForAdvanced));
		AdenaMyNum_Txt.SetText("(" $ MakeCostString(string(nHighgradeAmount)) $ ")");
	}
	else
	{
		needPerGameForAdvanced = 0;
		nItemClassID = 91641;
		AdenaName_Txt.SetText(class'UIDATA_ITEM'.static.GetItemName(GetItemID(nItemClassID)));
		AdenaName_Txt.SetTextColor(getInstanceL2Util().Gray);
		AdenaIcon_Tex.SetAlpha(140);
		AdenaIcon_Tex.SetTexture(class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(nItemClassID)));
		AdenaMyNum_Txt.HideWindow();
	}

	if(nGameCount > 0)
	{
		SetItemCountEditBox(nGameCount);
	}
	else
	{
		SetItemCountEditBox(1);
	}
	VoucherName_Txt.SetText(GetSystemString(3937) $ " x" $ string(nCountPerGame));
	nLampCount = nCount;
	if(MagicLampResultWnd.IsShowWindow() == false)
	{
		DisableCurrentWindow(false);
	}
	SetControlerBtns();
}

event OnClickButton(string Name)
{
	Debug("Name" @ Name);
	switch(Name)
	{
		// End:0x3F
		case "WindowHelp_BTN":
			ExecuteEvent(EV_ShowHelp, "20");
			break;
		// End:0x53
		case "OK_Btn":
			// ���â
			OnOK_BtnClick();
			break;
		// End:0x70
		case "NumofPlayUp_Btn":
			OnNumofPlayUp_BtnClick();
			// End:0x1C8
			break;
		// End:0x8F
		case "NumofPlayDown_Btn":
			OnNumofPlayDown_BtnClick();
			// End:0x1C8
			break;
		// End:0xAD
		case "NumofPlayMax_Btn":
			OnNumofPlayMax_BtnClick();
			// End:0x1C8
			break;
		// End:0xD0
		case "GameStartorCancle_Btn":
			OnGameStartorCancle_BtnClick();
			// End:0x1C8
			break;
		// End:0x159
		case "ProbabilityView_Btn":
			toggleWindow("MagicLampWnd.MagicLampProbability_Wnd", true);
			// End:0x156
			if(GetWindowHandle("MagicLampWnd.MagicLampProbability_Wnd").IsShowWindow())
			{
				updateProbabilityList();
			}
			// End:0x1C8
			break;
		// End:0x177
		case "POK_Btn":
			MagicLampProbability_Wnd.HideWindow();
			// End:0x1C8
			break;
		// End:0x19E
		case "MagicLampProbability_Tab0":
			updateProbabilityList();
			// End:0x1C8
			break;
		// End:0x1C5
		case "MagicLampProbability_Tab1":
			updateProbabilityList();
			// End:0x1C8
			break;
	}
}

function OnOK_BtnClick()
{
	bIsGameStartClick = false;
	MagicLampResultWnd.HideWindow();
	DisableCurrentWindow(false);
	SetControlerBtns();
}

function OnNumofPlayUp_BtnClick()
{
	SetItemCountEditBox (int (NumofPlay_EditBox.GetString())  + 1) ;
}

function OnNumofPlayDown_BtnClick()
{
	SetItemCountEditBox (int (NumofPlay_EditBox.GetString()) - 1) ;
}

function OnNumofPlayMax_BtnClick()
{
	SetItemCountEditBox(nLampCount);
}

function OnGameStartorCancle_BtnClick()
{
	Me.KillTimer(TIMER_ID);

	if(bIsGameStartClick == false)
	{
		GameStartorCancle_Btn.SetButtonName(141); // ���		
		Me.SetTimer(TIMER_ID, TIMER_DELAY);
		bIsGameStartClick = true;
		
		// ������ ����Ʈ 
		EffectViewport01.SpawnEffect("LineageEffect.d_chainheal_ta");
		PlaySound("InterfaceSound.MagicLamp_Start");
	}
	else
	{
		Me.KillTimer(TIMER_ID);
		GameStartorCancle_Btn.SetButtonName(160); // ���ӽ���
		bIsGameStartClick = false;
		EffectViewport01.SpawnEffect("LineageEffect2.ui_soul_crystal") ;
	}
	MagicLampProbability_Wnd.HideWindow();
}

function OnTimer(int TimerID)
{
	local int nBet;

	if(TimerID == TIMER_ID)
	{
		Me.KillTimer(TIMER_ID);
		EffectViewport01.SpawnEffect("LineageEffect2.ui_soul_crystal");
		nBet = int(NumofPlay_EditBox.GetString());

		if(nBet > 0)
		{
			RequestMagicLampGameStart(GetGameModeType(),nBet);
		}
	}
}

// ������ ī��Ʈ
function int DelegateGetCountCanBuy ()
{
	local INT64 Num;

	if(Advanced_CheckBox.IsChecked())
	{
		if((nCount >= TryMaxCount * nCountPerGame) && getInventoryItemNumByClassID(91641) >= TryMaxCount * needPerGameForAdvanced)
		{
			return TryMaxCount;
		}
		Num = Min_Int64(getMaximumBuyCount(nCount,nCountPerGame),getMaximumBuyCount(getInventoryItemNumByClassID(91641),needPerGameForAdvanced));
	}
	else
	{
		if(nCount >= TryMaxCount * nCountPerGame)
		{
			return TryMaxCount;
		}
		Num = getMaximumBuyCount(nCount,nCountPerGame);
	}
	return int(Num);
}

function INT64 Min_Int64 (INT64 A, INT64 B)
{
	if(A > B)
		return B;
	return A;
}

function INT64 getMaximumBuyCount (INT64 hasCount, INT64 needCount)
{
	return hasCount / needCount;
}

// ����Ʈ �ڽ� ��ġ ���� �� 
function DelegateOnItemCountEdited(int num)
{
	VoucherNum_Txt.SetText(string(num));
}

// ������ �ڽ� ���� ���� �� �����ؾ� �� ��ġ ��.
function SetItemCountEditBox (int num) 
{
	num = Min (DelegateGetCountCanBuy(), num) ;

	// �ٸ� ���� �ؽ�Ʈ �Է��� ���� ������ ���� �ݺ� �ȴ�.
	if(num != int (NumofPlay_EditBox.GetString())) 
		NumofPlay_EditBox.SetString(String(num));

	DelegateOnItemCountEdited (num) ;

	SetControlerBtns();
	//SetBuyBtnTooltip();
}

function int canIBuy (int tryNum)
{
	if(nCount >= tryNum * nCountPerGame && getInventoryItemNumByClassID(91641) >= tryNum * needPerGameForAdvanced)
		return tryNum;

	if(nCount <= 0 || getInventoryItemNumByClassID(91641) <= 0)
		return 1;

	return tryNum;
}

// ���� ��Ȳ ���� �Ͽ�, ��ư ��Ʈ�ѷ��� ���� ��.
function bool SetControlerBtns()
{
	local int count, canBuyCount ;

	count = int (NumofPlay_EditBox.GetString()) ;
	
	
	canBuyCount = DelegateGetCountCanBuy();
	if(canBuyCount > 0)
	{
		GameStartorCancle_Btn.EnableWindow();
		NumofPlayMax_Btn.EnableWindow();
	}
	else
	{
		GameStartorCancle_Btn.DisableWindow();
		NumofPlayMax_Btn.DisableWindow();
	}

	if(GetGameModeType() == 0)
	{
		if(nCount == 0)
		{
			VoucherMyNum_Txt.SetTextColor(getInstanceL2Util().DRed);
		}
		else
		{
			VoucherMyNum_Txt.SetTextColor(getInstanceL2Util().Blue);
		}
	}
	else
	{
		if(nCount >= nCountPerGame)
		{
			VoucherMyNum_Txt.SetTextColor(getInstanceL2Util().Blue);
		}
		else
		{
			VoucherMyNum_Txt.SetTextColor(getInstanceL2Util().DRed);
		}
		if(getInventoryItemNumByClassID(91641) >= needPerGameForAdvanced)
		{
			AdenaMyNum_Txt.SetTextColor(getInstanceL2Util().Blue);
		}
		else
		{
			AdenaMyNum_Txt.SetTextColor(getInstanceL2Util().DRed);
		}
	}

	if(canBuyCount > 0) 
	{
		// ������ ���� �� �� ���� ���.
		if(canBuyCount == 1)
		{
			NumofPlayDown_Btn.DisableWindow();
			NumofPlay_EditBox.DisableWindow();
		}
		else
		{
			NumofPlayDown_Btn.EnableWindow();
			NumofPlay_EditBox.EnableWindow();
		}
		
		// ���̻� �ø� �� ���� ���
		if(canBuyCount == count)
			NumofPlayUp_Btn.DisableWindow();
		else 
			NumofPlayUp_Btn.EnableWindow();

		// ���� ���� 1�� ���(���� �� ����.)
		if(count <= 1)
		{
			//if(count == 0) 
			//	Reset_Btn.EnableWindow();	
			//else 
			//	Reset_Btn.DisableWindow();	

			NumofPlayDown_Btn.DisableWindow();
		}
		else
		{
			//Reset_Btn.EnableWindow();	
			NumofPlayDown_Btn.EnableWindow();
		}
	}
	else
	{
		NumofPlayUp_Btn.DisableWindow();
		NumofPlayDown_Btn.DisableWindow();
		NumofPlayDown_Btn.DisableWindow();
		NumofPlay_EditBox.DisableWindow();
		NumofPlayMax_Btn.DisableWindow();
		//Reset_Btn.DisableWindow();	
		//GameStartorCancle_Btn.DisableWindow();
		return false;
	}
}

function playResultEffectViewPort(string effectPath)
{
	local Vector offset;

	if(effectPath == "LineageEffect2.ui_upgrade_succ")
	{
		offset.X = 10.0;
		offset.Y = -5.0;
		EffectViewport02.SetScale(6.0);
		EffectViewport02.SetCameraDistance(1300.0);
		EffectViewport02.SetOffset(offset);
	}
	else if(effectPath == "LineageEffect.d_firework_a")
	{
		offset.X = 10.0;
		offset.Y = -5.0;
		EffectViewport02.SetScale(6.0);
		EffectViewport02.SetCameraDistance(1300.0);
		EffectViewport02.SetOffset(offset);
	}
	EffectViewport02.SetFocus();
	EffectViewport02.SpawnEffect(effectPath);
}

function OnClickCheckBox(string strID)
{
	switch (strID)
	{
		case "Advanced_CheckBox":
			if(Advanced_CheckBox.IsChecked())
			{
				MagicLamp_Tex.SetTexture("L2UI_CT1.MagicLampWnd.MagicLamp_Bg_Advanced");
			}
			else
			{
				MagicLamp_Tex.SetTexture("L2UI_CT1.MagicLampWnd.MagicLamp_Bg");
			}
			Debug("api-> RequestMagicLampGameInfo" @string(GetGameModeType()) @string(0));
			SetItemCountEditBox(1);
			RequestMagicLampGameInfo(GetGameModeType());
			// End:0xEF
			break;
	}
}

function OnChangeEditBox(String strID)
{
	switch(strID)
	{
		// End:0x3D
		case "NumofPlay_EditBox":
	
			CheckZero();
			SetItemCountEditBox(int(NumofPlay_EditBox.GetString()));
			break;
	}
}

function int GetGameModeType()
{
	// End:0x17
	if(Advanced_CheckBox.IsChecked())
	{
		return 1;
	}
	return 0;
}

function setCheckBoxState()
{
    if(isAdvancedLampPossible())
    {
        Advanced_CheckBox.EnableWindow();
    }
    else
    {
        Advanced_CheckBox.DisableWindow();
        Advanced_CheckBox.SetCheck(false);
    }
}

function bool isAdvancedLampPossible()
{
    local UserInfo Info;

    GetPlayerInfo(Info);
    if((GetClassTransferDegree(Info.nSubClass) > 2) && (Info.nLevel >= 76))
    {
        return true;
    }
    return false;
}

// �Է� �� 0�� �ߺ� ���� �ʵ��� üũ
function CheckZero()
{
	local string EditBoxString;

	EditBoxString = NumofPlay_EditBox.GetString();
	// �� ���ڸ��� 0���� ���� �ϴ� ��� 0�� ���� �Ѵ�. 		
	if(Left(EditBoxString, 1) == "0" && Len(EditBoxString) > 1)
	{
		NumofPlay_EditBox.SetString(Right(EditBoxString, Len(EditBoxString) - 1));
	}
}

function DisableCurrentWindow(bool bFlag)
{
    if(bFlag)
    {
        DisableWnd.ShowWindow();
        DisableWnd.SetFocus();
    }
    else
    {
        DisableWnd.HideWindow();
    }
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(Self))).HideWindow();
}

defaultproperties
{
}
