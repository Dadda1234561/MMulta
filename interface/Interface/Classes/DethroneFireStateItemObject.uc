class DethroneFireStateItemObject extends UICommonAPI;

enum cState 
{
	READY,
	Spawn,
	Success,
	DESPAWN
};

var UIPacket._HolyFire _info;
var bool _openedWnd;
var WindowHandle Me;
var UIControlNeedItemList needItemListScript;
var TextBoxHandle stateTextBox;
var TextBoxHandle descTextBox;
var TextBoxHandle timeTextBox;
var TextBoxHandle emptyRewardTextBox;
var EffectViewportWndHandle effectViewport;
var StatusRoundHandle timeStatusRound;
var TextureHandle fireBackTex;
var TextureHandle titleBackTex;
var TextureHandle rewardNoneTex;
var TextureHandle successBorderTex;

function Init(WindowHandle ownerWnd)
{
	local string ownerFullPath;

	Me = ownerWnd;
	ownerFullPath = ownerWnd.m_WindowNameWithFullPath;
	needItemListScript = new class'UIControlNeedItemList';
	needItemListScript.SetRichListControler(GetRichListCtrlHandle(ownerFullPath $ ".Reward_RichList"));
	needItemListScript.SetHideMyNum(true);
	timeTextBox = GetTextBoxHandle(ownerFullPath $ ".Time_Txt");
	stateTextBox = GetTextBoxHandle(ownerFullPath $ ".Title_Txt");
	descTextBox = GetTextBoxHandle(ownerFullPath $ ".Desc_Txt");
	effectViewport = GetEffectViewportWndHandle(ownerFullPath $ ".ObjectViewport");
	timeStatusRound = GetStatusRoundHandle(ownerFullPath $ ".TimeStatusRound");
	fireBackTex = GetTextureHandle(ownerFullPath $ ".FireReadyBg_Tex");
	titleBackTex = GetTextureHandle(ownerFullPath $ ".FireSpawnTitleBg_Tex");
	rewardNoneTex = GetTextureHandle(ownerFullPath $ ".RewardDisableBg_Tex");
	successBorderTex = GetTextureHandle(ownerFullPath $ ".FireSuccessBox_Tex");
	emptyRewardTextBox = GetTextBoxHandle(ownerFullPath $ ".EmptyReward_Txt");
	_openedWnd = false;
}

function ResetInfo()
{
	local UIPacket._HolyFire defaultInfo;

	_info = defaultInfo;
	effectViewport.SpawnEffect("");
	needItemListScript.CleariObjects();
	_openedWnd = false;	
}

function SetInfo(UIPacket._HolyFire fireStateInfo, int uiElapsedTimeCount)
{
	local bool needStateUpdate, needRewardItemUpdate;
	local int i, ElapsedTime, rewardLength;
	local float timePer;
	local StatusBaseHandle statusScript;

	rewardLength = fireStateInfo.rewards.Length;
	if(_openedWnd == false || _info.rewards.Length != rewardLength)
	{
		needRewardItemUpdate = true;
	}
	if(_openedWnd == false || _info.cState != fireStateInfo.cState)
	{
		needRewardItemUpdate = true;
		needStateUpdate = true;
	}
	if(_openedWnd == false)
	{
		_openedWnd = true;
	}
	_info = fireStateInfo;
	if(fireStateInfo.cState == 1)
	{
		ElapsedTime = fireStateInfo.nElapsedTime + uiElapsedTimeCount;
		if(ElapsedTime > fireStateInfo.nLifespan)
		{
			ElapsedTime = fireStateInfo.nLifespan;
		}		
	}
	else
	{
		ElapsedTime = fireStateInfo.nElapsedTime;
	}
	timePer = (float(ElapsedTime) / float(fireStateInfo.nLifespan)) * float(100);
	if(fireStateInfo.cState == 1 || fireStateInfo.cState == 2)
	{
		statusScript = timeStatusRound.GetSelfScript();
		timeStatusRound.SetPoint(ElapsedTime, fireStateInfo.nLifespan);
		// End:0x1AE
		if(int(timePer) >= 100)
		{
			timeStatusRound.SetGaugeColor(statusScript.StatusBarSplitType.SBST_BackCenter, GetColor(255, 47, 65, 255));			
		}
		else
		{
			timeStatusRound.SetGaugeColor(statusScript.StatusBarSplitType.SBST_BackCenter, GetColor(250, 168, 87, 255));
		}
		timeStatusRound.ShowWindow();
		timeTextBox.SetText(string(timePer) $ "%");
		timeTextBox.ShowWindow();		
	}
	else
	{
		timeStatusRound.HideWindow();
		timeTextBox.HideWindow();
	}
	if(needStateUpdate)
	{
		effectViewport.SpawnEffect(GetStateEffectPath(fireStateInfo.cState));
		stateTextBox.SetText(GetStateTitle(fireStateInfo.cState));
		descTextBox.SetText(GetStateDesc(fireStateInfo.cState));
		titleBackTex.SetTexture(GetTitleBackTextureName(fireStateInfo.cState));
		fireBackTex.SetTexture(GetFireBackTextureName(fireStateInfo.cState));
		// End:0x2FB
		if(fireStateInfo.cState == 2)
		{
			successBorderTex.ShowWindow();			
		}
		else
		{
			successBorderTex.HideWindow();
		}
	}
	if(needRewardItemUpdate)
	{
		needItemListScript.StartNeedItemList(2);
		emptyRewardTextBox.HideWindow();
		if(rewardLength > 0)
		{
			for(i = 0; i < rewardLength; i++)
			{
				needItemListScript.AddNeedItemClassID(fireStateInfo.rewards[i].nItemClassID, fireStateInfo.rewards[i].nAmount);
			}
			needItemListScript.SetBuyNum(1);
			rewardNoneTex.HideWindow();			
		}
		else
		{
			// End:0x43D
			if(fireStateInfo.cState == 2 || fireStateInfo.cState == 3)
			{
				// End:0x414
				if(fireStateInfo.cRewardState == -2)
				{
					emptyRewardTextBox.SetText(GetSystemString(14428));					
				}
				else
				{
					emptyRewardTextBox.SetText(GetSystemString(14429));
				}
				emptyRewardTextBox.ShowWindow();
			}
			rewardNoneTex.ShowWindow();
		}
	}	
}

function string GetStateEffectPath(int nState)
{
	local string effectPath;

	switch(nState)
	{
		// End:0x19
		case 0:
			effectPath = "";
			// End:0xBA
			break;
		// End:0x4D
		case 1:
			effectPath = "LineageEffect2.ui_dethrone_fire_on";
			// End:0xBA
			break;
		// End:0x82
		case 2:
			effectPath = "LineageEffect2.ui_dethrone_fire_big";
			// End:0xBA
			break;
		// End:0xB7
		case 3:
			effectPath = "LineageEffect2.ui_dethrone_fire_off";
			// End:0xBA
			break;
		// End:0xFFFF
		default:
			break;
	}
	return effectPath;	
}

function string GetTitleBackTextureName(int nState)
{
	local string effectPath;

	switch(nState)
	{
		case 0:
			effectPath = "L2UI_EPIC.DethroneWnd.FireReadyTitleBg";
			break;
		case 1:
			effectPath = "L2UI_EPIC.DethroneWnd.FireSpawnTitleBg";
			break;
		case 2:
			effectPath = "L2UI_EPIC.DethroneWnd.FireSuccessTitleBg";
			break;
		case 3:
			effectPath = "L2UI_EPIC.DethroneWnd.FireDespawnTitleBg";
			break;
	}
	return effectPath;	
}

function string GetFireBackTextureName(int nState)
{
	local string effectPath;

	switch(nState)
	{
		case 0:
			effectPath = "L2UI_EPIC.DethroneWnd.FireReadyBg";
			break;
		case 1:
			effectPath = "L2UI_EPIC.DethroneWnd.FireSpawnBg";
			break;
		case 2:
			effectPath = "L2UI_EPIC.DethroneWnd.FireSuccessBg";
			break;
		case 3:
			effectPath = "L2UI_EPIC.DethroneWnd.FireDespawnBg";
			break;
	}
	return effectPath;	
}

function string GetStateTitle(int nState)
{
	local int strID;

	switch(nState)
	{
		// End:0x1C
		case 0:
			strID = 14344;
			// End:0x5E
			break;
		// End:0x31
		case 1:
			strID = 14345;
			// End:0x5E
			break;
		// End:0x46
		case 2:
			strID = 14346;
			// End:0x5E
			break;
		// End:0x5B
		case 3:
			strID = 14347;
			// End:0x5E
			break;
		// End:0xFFFF
		default:
			break;
	}
	return GetSystemString(strID);	
}

function string getStateDesc(int nState)
{
	local int strID;

	switch(nState)
	{
		// End:0x1C
		case 0:
			strID = 14348;
			// End:0x5E
			break;
		// End:0x31
		case 1:
			strID = 14349;
			// End:0x5E
			break;
		// End:0x46
		case 2:
			strID = 14350;
			// End:0x5E
			break;
		// End:0x5B
		case 3:
			strID = 14351;
			// End:0x5E
			break;
		// End:0xFFFF
		default:
			break;
	}
	return GetSystemString(strID);	
}

defaultproperties
{
}
