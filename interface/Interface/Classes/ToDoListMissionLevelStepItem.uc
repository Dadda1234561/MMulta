class ToDoListMissionLevelStepItem extends UICommonAPI
	dependson(ToDoListTabMissionLevel);

const MISSION_TEXTURE_PATH = "L2UI_NewTex.MissionWnd.";

enum EMissionLevelStepState 
{
	EmptyReward,
	NotInProgress,
	InProgress,
	CompleteNotRewardStep,
	CompleteRewardReady,
	CompleteRewarded
};

var WindowHandle Me;
var ToDoListTabMissionLevel parentWnd;
var ButtonHandle baseRewardBtn;
var ButtonHandle keyRewardBtn;
var TextureHandle baseRewardBgTex;
var TextureHandle baseRewardStateBgTex;
var TextureHandle keyRewardBgTex;
var TextureHandle baseRewardCompleteTex;
var TextureHandle keyRewardCompleteTex;
var AnimTextureHandle baseRewardReadyAnimTex;
var AnimTextureHandle keyRewardReadyAnimTex;
var ItemWindowHandle baseRewardItemSlot;
var ItemWindowHandle keyRewardItemSlot;
var TextBoxHandle levelTextBox;
var TextBoxHandle baseRewardCntTextBox;
var TextBoxHandle keyRewardCntTextBox;
var WindowHandle keyRewardWnd;
var ToDoListTabMissionLevel.MissionLevelStepInfo _info;
var EMissionLevelStepState baseRewardStepState;
var EMissionLevelStepState keyRewardStepState;

delegate DelegateOnBaseRewardClicked(ToDoListMissionLevelStepItem Owner)
{}

delegate DelegateOnKeyRewardClicked(ToDoListMissionLevelStepItem Owner)
{}

function Init(WindowHandle Owner, ToDoListTabMissionLevel Parent)
{
	local string ownerFullPath;

	ownerFullPath = Owner.m_WindowNameWithFullPath;
	parentWnd = Parent;
	Me = GetWindowHandle(ownerFullPath);
	levelTextBox = GetTextBoxHandle(ownerFullPath $ ".LVNum");
	baseRewardBtn = GetButtonHandle(ownerFullPath $ ".RewardBase_Btn");
	baseRewardBgTex = GetTextureHandle(ownerFullPath $ ".CountStateBGSet_texture");
	baseRewardCompleteTex = GetTextureHandle(ownerFullPath $ ".RewardStateIcon_texture");
	baseRewardReadyAnimTex = GetAnimTextureHandle(ownerFullPath $ ".RewardCountStateBG_animTex");
	baseRewardItemSlot = GetItemWindowHandle(ownerFullPath $ ".Reward_ItemWnd");
	baseRewardCntTextBox = GetTextBoxHandle(ownerFullPath $ ".RewardItemNem_Text");
	keyRewardWnd = GetWindowHandle(ownerFullPath $ ".SpecialReward_wnd");
	keyRewardBtn = GetButtonHandle(ownerFullPath $ ".Special_RewardBase_Btn");
	keyRewardBgTex = GetTextureHandle(ownerFullPath $ ".Special_CountStateBGSet_texture");
	keyRewardCompleteTex = GetTextureHandle(ownerFullPath $ ".Special_RewardStateIcon_texture");
	keyRewardReadyAnimTex = GetAnimTextureHandle(ownerFullPath $ ".Special_CountStateBG_animTex");
	keyRewardItemSlot = GetItemWindowHandle(ownerFullPath $ ".Special_Reward_ItemWnd");
	keyRewardCntTextBox = GetTextBoxHandle(ownerFullPath $ ".Special_RewardItemNem_Text");
}

event OnClickButton(string StringID)
{
	// End:0x28
	if(StringID == "RewardBase_Btn")
	{
		DelegateOnBaseRewardClicked(self);		
	}
	else if(StringID == "Special_RewardBase_Btn")
	{
		DelegateOnKeyRewardClicked(self);
	}
}

event OnClickItem(string StringID, int Index)
{
	// End:0x3A
	if(StringID == "Reward_ItemWnd")
	{
		// End:0x37
		if(baseRewardBtn.IsEnableWindow())
		{
			DelegateOnBaseRewardClicked(self);
		}		
	}
	else if(StringID == "Special_Reward_ItemWnd")
	{
		// End:0x79
		if(keyRewardBtn.IsEnableWindow())
		{
			DelegateOnKeyRewardClicked(self);
		}
	}
}

function _SetStepInfo(ToDoListTabMissionLevel.MissionLevelStepInfo Info, int CurrentLevel, int availableBaseRewardLevel, int availableKeyRewardLevel)
{
	local ItemInfo baseItemInfo, keyItemInfo;

	_info = Info;
	// End:0x29
	if(Info.baseRewardItem.ItemClassID == 0)
	{
		_SetDisable(true);
		return;
	}
	baseItemInfo = GetItemInfoByClassID(Info.baseRewardItem.ItemClassID);
	baseRewardItemSlot.Clear();
	baseRewardItemSlot.AddItem(baseItemInfo);
	baseRewardCntTextBox.SetText("x" $ string(Info.baseRewardItem.Amount));
	// End:0xC2
	if(Info.Level == (CurrentLevel + 1))
	{
		levelTextBox.SetTextColor(GetColor(0, 255, 255, 255));		
	}
	else
	{
		levelTextBox.SetTextColor(GetColor(255, 221, 102, 255));
	}
	levelTextBox.SetText(string(Info.Level));
	// End:0x121
	if(Info.keyRewardItem.ItemClassID == 0)
	{
		keyRewardWnd.HideWindow();		
	}
	else
	{
		keyItemInfo = GetItemInfoByClassID(Info.keyRewardItem.ItemClassID);
		keyRewardItemSlot.Clear();
		keyRewardItemSlot.AddItem(keyItemInfo);
		keyRewardCntTextBox.SetText("x" $ string(Info.keyRewardItem.Amount));
		SetKeyRewardTexture(GetStepState(Info.Level, Info.keyRewardState, CurrentLevel, availableKeyRewardLevel));
		keyRewardWnd.ShowWindow();
	}
	SetBaseRewardTexture(GetStepState(Info.Level, Info.baseRewardState, CurrentLevel, availableBaseRewardLevel));
	_SetDisable(false);
}

function _SetDisable(bool IsDisable)
{
	// End:0x1E
	if(IsDisable == true)
	{
		Me.HideWindow();		
	}
	else
	{
		Me.ShowWindow();
	}
}

function _StopAllAnimations()
{
	baseRewardReadyAnimTex.Stop();
	keyRewardReadyAnimTex.Stop();
}

function SetBaseRewardTexture(EMissionLevelStepState stepState)
{
	baseRewardBtn.SetEnable(false);
	switch(stepState)
	{
		// End:0x73
		case EMissionLevelStepState.NotInProgress/*1*/:
			baseRewardCompleteTex.HideWindow();
			baseRewardReadyAnimTex.HideWindow();
			baseRewardBgTex.SetTexture(MISSION_TEXTURE_PATH $ "Free_Basic");
			// End:0x28E
			break;
		// End:0xD7
		case EMissionLevelStepState.InProgress/*2*/:
			baseRewardCompleteTex.HideWindow();
			baseRewardReadyAnimTex.HideWindow();
			baseRewardBgTex.SetTexture(MISSION_TEXTURE_PATH $ "Free_GaugeProgress");
			// End:0x28E
			break;
		// End:0x13B
		case EMissionLevelStepState.CompleteNotRewardStep/*3*/:
			baseRewardCompleteTex.HideWindow();
			baseRewardReadyAnimTex.HideWindow();
			baseRewardBgTex.SetTexture(MISSION_TEXTURE_PATH $ "Free_GaugeComplete");
			// End:0x28E
			break;
		// End:0x227
		case EMissionLevelStepState.CompleteRewardReady/*4*/:
			baseRewardCompleteTex.HideWindow();
			baseRewardBgTex.SetTexture(MISSION_TEXTURE_PATH $ "Free_GaugeComplete");
			baseRewardReadyAnimTex.SetTexture(MISSION_TEXTURE_PATH $ "Free_GaugeComplete_Ani0000");
			baseRewardBtn.SetEnable(true);
			baseRewardReadyAnimTex.ShowWindow();
			baseRewardReadyAnimTex.Stop();
			baseRewardReadyAnimTex.SetLoopCount(9999);
			baseRewardReadyAnimTex.Play();
			// End:0x28E
			break;
		// End:0x28B
		case EMissionLevelStepState.CompleteRewarded/*5*/:
			baseRewardCompleteTex.ShowWindow();
			baseRewardReadyAnimTex.HideWindow();
			baseRewardBgTex.SetTexture(MISSION_TEXTURE_PATH $ "Free_RewardComplet");
			// End:0x28E
			break;
	}
}

function SetKeyRewardTexture(EMissionLevelStepState stepState)
{
	keyRewardBtn.SetEnable(false);
	switch(stepState)
	{
		// End:0x76
		case EMissionLevelStepState.NotInProgress/*1*/:
			keyRewardCompleteTex.HideWindow();
			keyRewardReadyAnimTex.HideWindow();
			keyRewardBgTex.SetTexture(MISSION_TEXTURE_PATH $ "Special_Basic");
			// End:0x29F
			break;
		// End:0xDD
		case EMissionLevelStepState.InProgress/*2*/:
			keyRewardCompleteTex.HideWindow();
			keyRewardReadyAnimTex.HideWindow();
			keyRewardBgTex.SetTexture(MISSION_TEXTURE_PATH $ "Special_GaugeProgress");
			// End:0x29F
			break;
		// End:0x144
		case EMissionLevelStepState.CompleteNotRewardStep/*3*/:
			keyRewardCompleteTex.HideWindow();
			keyRewardReadyAnimTex.HideWindow();
			keyRewardBgTex.SetTexture(MISSION_TEXTURE_PATH $ "Special_GaugeComplete");
			// End:0x29F
			break;
		// End:0x235
		case EMissionLevelStepState.CompleteRewardReady/*4*/:
			keyRewardCompleteTex.HideWindow();
			keyRewardBgTex.SetTexture(MISSION_TEXTURE_PATH $ "Special_GaugeComplete");
			keyRewardReadyAnimTex.SetTexture("L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_ItemSlot3_Ani01");
			keyRewardBtn.SetEnable(true);
			keyRewardReadyAnimTex.ShowWindow();
			keyRewardReadyAnimTex.Stop();
			keyRewardReadyAnimTex.SetLoopCount(9999);
			keyRewardReadyAnimTex.Play();
			// End:0x29F
			break;
		// End:0x29C
		case EMissionLevelStepState.CompleteRewarded/*5*/:
			keyRewardCompleteTex.ShowWindow();
			keyRewardReadyAnimTex.HideWindow();
			keyRewardBgTex.SetTexture(MISSION_TEXTURE_PATH $ "Special_RewardComplet");
			// End:0x29F
			break;
	}
}

function EMissionLevelStepState GetStepState(int Level, ToDoListTabMissionLevel.EMissionLevelRewardState RewardState, int CurrentLevel, int availableLevel)
{
	local int nextLevel;

	nextLevel = CurrentLevel + 1;
	// End:0x23
	if(nextLevel == Level)
	{
		return EMissionLevelStepState.InProgress/*2*/;		
	}
	else if(nextLevel < Level)
	{
		return EMissionLevelStepState.NotInProgress/*1*/;			
	}
	else if(nextLevel > Level)
	{
		// End:0x66
		if(RewardState == parentWnd.EMissionLevelRewardState.AlreadyReceived)
		{
			return EMissionLevelStepState.CompleteRewarded/*5*/;					
		}
		else
		{
			// End:0x96
			if(RewardState == parentWnd.EMissionLevelRewardState.Available && availableLevel == Level)
			{
				return EMissionLevelStepState.CompleteRewardReady/*4*/;						
			}
			else
			{
				return EMissionLevelStepState.CompleteNotRewardStep/*3*/;
			}
		}
	}
}

defaultproperties
{
}
