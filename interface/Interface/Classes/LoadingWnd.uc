class LoadingWnd extends UICommonAPI;

var TextureHandle blackbillboard;
var TextureHandle loadingtexture;
var TextureHandle CopyRight_Tex;
var TextureHandle ageLimit_Tex;
var TextureHandle ageLimitDscrp_Tex;
var string copyRight_TexStr;
var string ageLimit_TexStr;
var string ageLimitDscrp_TexStr;

var string defaultBackgroundTextureStr;
var string defaultBackgroundTextureStr_Classic;
var string defaultBackgroundTextureStr_Arena;

function OnRegisterEvent()
{
	RegisterEvent(EV_ServerAgeLimitChange);
	RegisterEvent(EV_ResolutionChanged);
	RegisterEvent(EV_NeedResetUIData);
}

function OnLoad()
{
	blackbillboard = GetTextureHandle("LoadingWnd.BlackBackTex");
	loadingtexture = GetTextureHandle("LoadingWnd.BackTex");
	CopyRight_Tex = GetTextureHandle("LoadingWnd.CopyRight_Tex");
	ageLimit_Tex = GetTextureHandle("LoadingWnd.ageLimit_Tex");
	ageLimitDscrp_Tex = GetTextureHandle("LoadingWnd.ageLimitDscrp_Tex");
	CopyRight_Tex.SetTexture(copyRight_TexStr);
	ageLimit_Tex.SetTexture(ageLimit_TexStr);
	ageLimitDscrp_Tex.SetTexture(ageLimitDscrp_TexStr);
	CopyRight_Tex.HideWindow();
	ageLimit_Tex.HideWindow();
	ageLimitDscrp_Tex.HideWindow();
	CheckResolution();
}

function OnEvent(int a_EventID, string a_Param)
{
	local int ServerAgeLimitInt;
	local EServerAgeLimit ServerAgeLimit;
	local int aniType;

	aniType = Rand(2) + 1;

	if(a_EventID == EV_ServerAgeLimitChange)
	{
		if(ParseInt(a_Param, "ServerAgeLimit", ServerAgeLimitInt))
		{
			ServerAgeLimit = EServerAgeLimit(ServerAgeLimitInt);
			switch(ServerAgeLimit)
			{
				case SERVER_AGE_LIMIT_18:
					CopyRight_Tex.ShowWindow();
					ageLimit_Tex.ShowWindow();
					ageLimitDscrp_Tex.ShowWindow();
					break;
				case SERVER_AGE_LIMIT_Free:
					//debug( "LoadingTextureFree=" $ LoadingTextureFree );
				default:
					CopyRight_Tex.ShowWindow();
					ageLimit_Tex.HideWindow();
					ageLimitDscrp_Tex.ShowWindow();
					break;
			}
		}
	}
	else if(a_EventID == EV_ResolutionChanged)
	{
		CheckResolution();
	}
	else if(a_EventID == EV_NeedResetUIData)
	{
		if(getInstanceUIData().getIsClassicServer())
		{
			loadingtexture.SetTexture(defaultBackgroundTextureStr_Classic $ string(aniType));
		}
		else if(getInstanceUIData().getIsArenaServer())
		{
			loadingtexture.SetTexture(defaultBackgroundTextureStr_Arena);
		}
		else
		{
			loadingtexture.SetTexture(defaultBackgroundTextureStr $ string(aniType));
		}
	}
}

/** 외부에서(gameTipWnd) 배경 텍스쳐를 변경 할때 사용 */
function setBackgroundTextureStr(string changeTextureStr)
{
	local int aniType;

	aniType = Rand(2) + 1;

	if(getInstanceUIData().getIsClassicServer())
	{
		loadingtexture.SetTexture(defaultBackgroundTextureStr_Classic $ string(aniType));
	}
	else if(getInstanceUIData().getIsArenaServer())
	{
		loadingtexture.SetTexture(defaultBackgroundTextureStr_Arena);
	}
	else
	{
		loadingtexture.SetTexture(defaultBackgroundTextureStr $ string(aniType));
	}
	Debug((defaultBackgroundTextureStr $ string(aniType)) $ "!!!");
	Debug((defaultBackgroundTextureStr_Classic $ string(aniType)) $ "!!!");
}

/** 해상도에 따른 사이즈 변경 */
function CheckResolution()
{
	local int CurrentMaxWidth, CurrentMaxHeight;

	GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
	blackbillboard.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	SetTextureSize(CurrentMaxWidth, CurrentMaxHeight);
}

function SetTextureSize(int vWidth, int vHeight)
{
	local float screenAspectRatio, videoAspectRatio, xPer, yPer;
	local int CurrentMaxWidth, CurrentMaxHeight, originalVideoWidth, originalVideoHeight;

	originalVideoWidth = 1920;
	originalVideoHeight = 1080;
	GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
	loadingtexture.SetAnchor("LoadingWnd", "CenterCenter", "CenterCenter", 0, 0);
	screenAspectRatio = float(CurrentMaxWidth) / float(CurrentMaxHeight);
	videoAspectRatio = float(originalVideoWidth) / float(originalVideoHeight);
	xPer = (float(CurrentMaxWidth) / float(originalVideoWidth)) * float(100);
	yPer = (float(CurrentMaxHeight) / float(originalVideoHeight)) * float(100);

	if(GetAbs(videoAspectRatio - screenAspectRatio) > 0)
	{
		if(xPer > yPer)
		{
			vWidth = CurrentMaxWidth;
			vHeight = int(float(vWidth) / videoAspectRatio);			
		}
		else
		{
			vHeight = CurrentMaxHeight;
			vWidth = int(float(vHeight) * videoAspectRatio);
		}		
	}
	else
	{
		vWidth = CurrentMaxWidth;
		vHeight = CurrentMaxHeight;
	}
	loadingtexture.SetWindowSize(vWidth, vHeight);
}

function float GetAbs(float Num)
{
	if(Num < 0)
	{
		return - Num;
	}
	return Num;
}

defaultproperties
{
	copyRight_TexStr="L2Font.Skins.loading_CopyRight"
	ageLimit_TexStr="L2Font.Skins.ageLimit"
	ageLimitDscrp_TexStr="L2Font.Skins.ageLimitDscrp"
	defaultBackgroundTextureStr="L2Font.Loading_Default_0000_00"
	defaultBackgroundTextureStr_Classic="L2Font.Loading_Default_0000_C00"
	defaultBackgroundTextureStr_Arena="L2Font.Loading_Default_0000_A001"
}
