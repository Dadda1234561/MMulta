class L2PassWndProgressComponent extends UICommonAPI;

var L2PassData _l2PassData;
var WindowHandle Me;
var TextureHandle gaugeBgTexture;
var StatusBarHandle pregressBar;

function Init(WindowHandle Owner)
{
	local string ownerFullPath;

	ownerFullPath = Owner.m_WindowNameWithFullPath;
	_l2PassData = new class'L2PassData';
	Me = GetWindowHandle(ownerFullPath);
	gaugeBgTexture = GetTextureHandle(ownerFullPath $ ".GaugeStateBGSet_Texture");
	pregressBar = GetStatusBarHandle(ownerFullPath $ ".Pass_StatusBar");
}

function _SetProgressInfo(L2PassData.L2PassStepInfo Info)
{
	// End:0x1C
	if(Info.rewardItemCnt == 0)
	{
		_SetDisable(true);
		return;		
	}
	else
	{
		_SetDisable(false);
	}
	// End:0x7E
	if(Info.stepState == _l2PassData.EL2PassStepState.InProgress)
	{
		pregressBar.SetPointExpPercentRate(float(Info.missionCnt) / float(Info.missionMaxCnt));
		ShowProgressDeco(Info.PassType, true);		
	}
	else if(Info.stepState == _l2PassData.EL2PassStepState.NotInProgress)
	{
		pregressBar.SetPointExpPercentRate(0.0f);
		ShowProgressDeco(Info.PassType, false);	
	}
	else
	{
		pregressBar.SetPointExpPercentRate(1.0f);
		ShowProgressDeco(Info.PassType, true);
	}
	pregressBar.SetTooltipCustomType(MakeTooltipSimpleText(string(Info.missionCnt) @ "/" @ string(Info.missionMaxCnt)));
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

function ShowProgressDeco(L2PassData.EL2PassType PassType, bool isShow)
{
	local string texturePath;

	texturePath = class'L2PassData'.const.L2PASS_TEXTURE_PATH;
	// End:0x42
	if(PassType != _l2PassData.EL2PassType.Hunt)
	{
		return;
	}
	// End:0x79
	if(isShow == true)
	{
		gaugeBgTexture.SetTexture(texturePath $ "Gauge_ProgressBG");		
	}
	else
	{
		gaugeBgTexture.SetTexture(texturePath $ "Gauge_BasicBG");
	}
}
