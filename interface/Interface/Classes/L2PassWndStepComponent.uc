class L2PassWndStepComponent extends UICommonAPI;

var L2PassData.EL2PassStepState _stepState;
var L2PassData.EL2PassType _passType;
var bool _isPremiumStep;
var bool _isPremiumActivated;
var int _index;
var L2PassData _l2PassData;
var WindowHandle Me;
var ButtonHandle rewardBtn;
var TextureHandle premiumStateTexture;
var TextureHandle stateBgTexture;
var TextureHandle rewardStateBgTexture;
var AnimTextureHandle rewardReadyAnimTexture;
var ItemWindowHandle rewardItemSlot;
var TextBoxHandle rewardCntText;

delegate DelegateOnStepClicked(L2PassWndStepComponent Owner)
{
}

function Init(WindowHandle Owner)
{
	local string ownerFullPath;

	ownerFullPath = Owner.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	_l2PassData = new class'L2PassData';
	rewardBtn = GetButtonHandle(ownerFullPath $ ".RewardBase_Btn");
	premiumStateTexture = GetTextureHandle(ownerFullPath $ ".P_ActiveBG_texture");
	stateBgTexture = GetTextureHandle(ownerFullPath $ ".CountStateBGSet_texture");
	rewardStateBgTexture = GetTextureHandle(ownerFullPath $ ".RewardStateIcon_texture");
	rewardReadyAnimTexture = GetAnimTextureHandle(ownerFullPath $ ".RewardCountStateBG_animTex");
	rewardItemSlot = GetItemWindowHandle(ownerFullPath $ ".Reward_ItemWnd");
	rewardCntText = GetTextBoxHandle(ownerFullPath $ ".RewardItemNem_Text");
}

event OnClickButtonWithHandle(ButtonHandle Button)
{
	DelegateOnStepClicked(self);
}

function _SetStepInfo(L2PassData.L2PassStepInfo Info)
{
	local ItemInfo rewardIteminfo;

	_passType = Info.PassType;
	_isPremiumStep = Info.isPremiumStep;
	_isPremiumActivated = Info.isPremiumActivated;
	_stepState = Info.stepState;
	_index = Info.Index;
	rewardIteminfo = GetItemInfoByClassID(Info.RewardItemID);
	rewardItemSlot.Clear();
	rewardItemSlot.AddItem(rewardIteminfo);
	rewardCntText.SetText("x" $ string(Info.rewardItemCnt));
	SetBgTexture(Info.stepState, Info.isPremiumStep, Info.isPremiumActivated);
	// End:0xEE
	if(Info.rewardItemCnt == 0)
	{
		_SetDisable(true);		
	}
	else
	{
		_SetDisable(false);
	}
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
	rewardReadyAnimTexture.Stop();
}

function string SetBgTexture(L2PassData.EL2PassStepState stepState, bool isPremiumStep, bool isPremiumActivated)
{
	local string texturePath;

	texturePath = class'L2PassData'.const.L2PASS_TEXTURE_PATH;
	// End:0x50
	if((isPremiumStep == true) && isPremiumActivated)
	{
		premiumStateTexture.ShowWindow();		
	}
	else
	{
		premiumStateTexture.HideWindow();
	}
	rewardBtn.SetEnable(false);
	switch(stepState)
	{
		// End:0x176
		case _l2PassData.EL2PassStepState.NotInProgress:
			rewardReadyAnimTexture.HideWindow();
			// End:0xD3
			if(isPremiumStep == false)
			{
				stateBgTexture.SetTexture(texturePath $ "Free_Basic");
				rewardStateBgTexture.HideWindow();				
			}
			else
			{
				// End:0x13C
				if(isPremiumActivated == false)
				{
					stateBgTexture.SetTexture(texturePath $ "Prem_LockBasic");
					rewardStateBgTexture.SetTexture(texturePath $ "Prem_LockIcon");
					rewardStateBgTexture.ShowWindow();					
				}
				else
				{
					stateBgTexture.SetTexture(texturePath $ "Prem_ActiveBaisc");
					rewardStateBgTexture.HideWindow();
				}
			}
			// End:0x68F
			break;
		// End:0x28E
		case _l2PassData.EL2PassStepState.InProgress:
			rewardReadyAnimTexture.HideWindow();
			// End:0x1DB
			if(isPremiumStep == false)
			{
				stateBgTexture.SetTexture(texturePath $ "Free_GaugeProgress");
				rewardStateBgTexture.HideWindow();				
			}
			else
			{
				// End:0x24C
				if(isPremiumActivated == false)
				{
					stateBgTexture.SetTexture(texturePath $ "Prem_LockGaugeProgress");
					rewardStateBgTexture.SetTexture(texturePath $ "Prem_LockIcon");
					rewardStateBgTexture.ShowWindow();					
				}
				else
				{
					stateBgTexture.SetTexture(texturePath $ "Prem_ActiveGaugeProgress");
					rewardStateBgTexture.HideWindow();
				}
			}
			// End:0x68F
			break;
		// End:0x3A6
		case _l2PassData.EL2PassStepState.CompleteNotRewardStep:
			rewardReadyAnimTexture.HideWindow();
			// End:0x2F3
			if(isPremiumStep == false)
			{
				stateBgTexture.SetTexture(texturePath $ "Free_GaugeComplete");
				rewardStateBgTexture.HideWindow();				
			}
			else
			{
				// End:0x364
				if(isPremiumActivated == false)
				{
					stateBgTexture.SetTexture(texturePath $ "Prem_LockGaugeProgress");
					rewardStateBgTexture.SetTexture(texturePath $ "Prem_LockIcon");
					rewardStateBgTexture.ShowWindow();					
				}
				else
				{
					stateBgTexture.SetTexture(texturePath $ "Prem_ActiveGaugeComplete");
					rewardStateBgTexture.HideWindow();
				}
			}
			// End:0x68F
			break;
		// End:0x582
		case _l2PassData.EL2PassStepState.CompleteRewardReady:
			// End:0x43A
			if(isPremiumStep == false)
			{
				stateBgTexture.SetTexture(texturePath $ "Free_GaugeComplete");
				rewardReadyAnimTexture.SetTexture(texturePath $ "Free_GaugeComplete_Ani");
				rewardStateBgTexture.HideWindow();
				rewardBtn.SetEnable(true);				
			}
			else
			{
				rewardReadyAnimTexture.SetTexture(texturePath $ "Prem_ActiveGaugeComplete_Ani");
				// End:0x4EF
				if(isPremiumActivated == false)
				{
					stateBgTexture.SetTexture(texturePath $ "Prem_LockGaugeProgress");
					rewardStateBgTexture.SetTexture(texturePath $ "Prem_LockIcon");
					rewardStateBgTexture.ShowWindow();
					rewardBtn.SetEnable(false);					
				}
				else
				{
					stateBgTexture.SetTexture(texturePath $ "Prem_ActiveGaugeComplete");
					rewardStateBgTexture.HideWindow();
					rewardBtn.SetEnable(true);
				}
			}
			rewardReadyAnimTexture.ShowWindow();
			rewardReadyAnimTexture.Stop();
			rewardReadyAnimTexture.SetLoopCount(9999);
			rewardReadyAnimTexture.Play();
			// End:0x68F
			break;
		// End:0x68C
		case _l2PassData.EL2PassStepState.CompleteRewarded:
			rewardReadyAnimTexture.HideWindow();
			// End:0x611
			if(isPremiumStep == false)
			{
				stateBgTexture.SetTexture(texturePath $ "Free_RewardComplet");
				rewardStateBgTexture.SetTexture(texturePath $ "RewardCompleteICON");
				rewardStateBgTexture.ShowWindow();				
			}
			else
			{
				// End:0x620
				if(isPremiumActivated == false)
				{					
				}
				else
				{
					stateBgTexture.SetTexture(texturePath $ "Prem_ActiveRewardComplet");
					rewardStateBgTexture.SetTexture(texturePath $ "RewardCompleteICON");
					rewardStateBgTexture.ShowWindow();
				}
			}
			// End:0x68F
			break;
	}
}
