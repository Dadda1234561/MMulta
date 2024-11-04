//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : SceneClipView (비디오, 무비클립 재생기)- SCALEFORM UI
//                스케일폼 4.x 버전으로 컨버팅, sceneClipViewFullScreen와 통합
//
//                이전 버전에서 쓰던 sceneClipViewFullScreen 은 삭제됨
//------------------------------------------------------------------------------------------------------------------------
class SceneClipView extends L2UIGFxScript;

// 자막 폰트 사이즈
const CAPTION_FONTSIZE = 10;
// 자막 기본 Y값에서 ADD(각국 언어별 문제 대처용)
const CAPTION_ADDPOSY = -5;

const TYPE_SERVER_FIRST = 0;
const TYPE_SERVER_CLASSIC = 1;
const TYPE_SERVER_LIVE = 2;
const TYPE_SERVER_ARENA = 3;
const TYPE_SERVER_BLOOD = 4;
const TYPE_SERVER_ADEN = 5;
const MOVIEID_GACHA_URSR = 100002;
const MOVIEID_GACHA_R = 100003;
const MOVIEID_GACHA_GET_UR = 100004;

var int MovieID;
var int currentScreenWidth;
var int currentScreenHeight;
var int audioVolume;
var bool bIsBuilderPC;

function OnRegisterEvent()
{
	//----------------
	// Flash Event
	//----------------
	RegisterGFxEvent(EV_ShowSceneClipView);
	RegisterGFxEvent(EV_ShowFullSceneClipView);
	RegisterGFxEvent(EV_DeleteSceneClipView);
	RegisterGFxEvent(EV_DeleteFullSceneClipView);
	RegisterGFxEvent(EV_OptionHasApplied);
	RegisterGFxEventForLoaded(EV_ResolutionChanged);
	RegisterEvent(EV_StateChanged);

	//----------------
	// UC Event
	//----------------
	// 옵션 갱신 될때
	RegisterEvent(EV_Test_8);
	//registerEvent(EV_DeleteFullSceneClipView);
	// UC 에서 처리 스크립트
	// UsmMovieData-k 스크립트를 읽어서 EV_ShowSceneClipView, EV_ShowFullSceneClipView 이벤트 발생 시킴
	RegisterEvent(EV_ShowUsm);
}

function OnLoad()
{
	// RegisterDelegateHandler(EDHandler_NotifyUSMEnd);
	RegisterState("SceneClipView", "GamingState");
	SetHavingFocus(false);
}

function setSceneClipMode(bool bFullScreen)
{
	// End:0x1A
	if(bFullScreen)
	{
		SetAlwaysOnTop(true);
		SetRenderOnTop(true);
	}
	else
	{
		SetAlwaysOnTop(false);
		SetRenderOnTop(false);
	}
}

function OnFlashLoaded()
{
	SetAnchor("", EAnchorPointType.ANCHORPOINT_TopLeft, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0);
}

function OnShow()
{}

function OnHide()
{
}

function loginBGMovie()
{
	local string param, usmPath;
	local int currentScreenWidth, currentScreenHeight, nLoginMapType;

	nLoginMapType = GetLoginMapType();
	// End:0x1F
	if(IsActivateUSMBackground(nLoginMapType) == false)
	{
		return;
	}
	setSceneClipMode(false);
	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	ParamAdd(param, "PosX", "0");
	ParamAdd(param, "PosY", "0");
	ParamAdd(param, "SkinType", "2");
	ParamAdd(param, "SkipButtonType", "0");
	ParamAdd(param, "Width", string(currentScreenWidth));
	ParamAdd(param, "Height", string(currentScreenHeight));
	switch(nLoginMapType)
	{
		case 0:
		case 2:
		case 4:
			usmPath = "login.usm";
			break;
		case 1:
		case 5:
			usmPath = "login_classic.usm";
			break;
		default:
			usmPath = "login.usm";
			break;
	}
	ParamAdd(param, "FileName", usmPath);
	ParamAdd(param, "MovieID", "0");
	ParamAdd(param, "targetAnchorPointType", "centerCenter");
	ParamAdd(param, "clipAnchorPointType", "centerCenter");
	ExecuteEvent(EV_ShowSceneClipView, param);
	SetAlwaysOnBack(true);
	ContainerHUD(GetScript("ContainerHUD")).SetAlwaysOnBack(true);
}

function ciMovie()
{
	local string param;
	local int currentScreenWidth, currentScreenHeight;

	setSceneClipMode(false);
	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	ParamAdd(param, "PosX", "0");
	ParamAdd(param, "PosY", "0");
	ParamAdd(param, "SkinType", "0");
	ParamAdd(param, "SkipButtonType", "0");
	ParamAdd(param, "Width", string(currentScreenWidth));
	ParamAdd(param, "Height", string(currentScreenHeight));

	if(IsTencentLoginSystem())
	{
		ParamAdd(param, "FileName", "intro_cn.usm");		
	}
	else
	{
		ParamAdd(param, "FileName", "intro.usm");
	}
	ParamAdd(param, "MovieID", "0");
	ParamAdd(param, "targetAnchorPointType", "centerCenter");
	ParamAdd(param, "clipAnchorPointType", "centerCenter");
	ExecuteEvent(EV_ShowSceneClipView, param);
	SetAlwaysOnBack(true);
	ContainerHUD(GetScript("ContainerHUD")).SetAlwaysOnBack(true);
}

/**
 *   OnCallUCLogic(플래시 -> UC 콜)
 *   byGFXCall
 **/
function OnCallUCFunction(string logicID, string statusStr)
{
	local int MovieID;

	MovieID = int(logicID);

	// Debug("실행     :" @ movieID);
	// Debug("statusStr:" @ statusStr);

	if(statusStr == "start")
	{
		//Debug("???? ???? - MovieID:" @ string(MovieID));

		if(MovieID > 100000)
		{
			setSceneClipMode(true);
		}
		else
		{
			setSceneClipMode(false);
		}
	}
	else if(statusStr == "finish")
	{
		Debug("영상 끝 - MovieID:" @ string(MovieID));

		if(MovieID > 100000)
		{
			if(100002 == MovieID)
			{
				UniqueGacha(GetScript("UniqueGacha")).setShowStep(UniqueGacha(GetScript("UniqueGacha")).GACHA_GAME_FORM);
			}
			else if(100003 == MovieID)
			{
				UniqueGacha(GetScript("UniqueGacha")).setShowStep(UniqueGacha(GetScript("UniqueGacha")).GACHA_GAME_FORM);
			}
			else if(100004 == MovieID)
			{
				UniqueGacha(GetScript("UniqueGacha")).setShowStep(UniqueGacha(GetScript("UniqueGacha")).GACHA_GETUR_RESULT_FORM);
			}
		}
		else
		{
			FlashMoviePlayEnd(MovieID);
		}
		HideWindow();

		if(GetGameStateName() == "INTROSTATE")
		{
			if(IsTencentLoginSystem())
			{
				LoginWaitState();
			}
			else
			{
				StartLoginState();
			}
		}
	}
	else if(statusStr == "fullScreenStart")
	{
		setSceneClipMode(true);
		//Debug("풀 스크린 영상 시작 - fullScreenStart MovieID:" @ string(movieID));
		FullScreenMovieStart();
	}
	else if(statusStr == "fullScreenFinish")
	{
		//Debug("풀 스크린 영상 끝");
		FullScreenMovieEnd();
		onMovieEnd();
		HideWindow();
	}

	// 별도 실행 기능, 이제 사용 안함.
	if(logicID == "IsBuilderPC")
	{
		bIsBuilderPC = IsBuilderPC();
		//Debug("Refresh IsBuilderPC" @ bIsBuilderPC);
	}
	// 사운드 값 갱신
	else if(logicID == "soundUpdate")
	{
		audioVolume = getAudioVolume();
	}
}

/**
 *  이벤트 번호 
 *  1 : 비디오 재생
 *  2 : 비디오 삭제
 *  
 *  5620
 *  posX=0 posY=0 FileName=gd10_prologue.usm Width=400 Height=300 SkinType=0 SkipButtonType=1 TargetAnchorPointType=TopLeft clipAnchorPointType=TopLeft
 *  posX=0 posY=0 FileName=gd10_prologue.usm Width=400 Height=300 SkinType=0 SkipButtonType=1 TargetAnchorPointType=CenterCenter clipAnchorPointType=CenterCenter
 **/
function OnEvent(int Event_ID, string param)
{
	local int movieID;

	// 이벤트 번호 5622
	if(Event_ID == EV_ShowUsm)
	{
		ParseInt(param, "MovieID", movieID);

		// bIsBuilderPC = IsBuilderPC();

		// Debug("bIsBuilderPC--EV_ShowUsm" @ bIsBuilderPC);
		
		// FlashMoviePlayStart 함수를 실행 하면 --> Ev_ShowSceneClipView 이벤트로 usmMovieData.txt 의 스크립트 정보를 기초로
		// 해당 데이타를 받을 수 있다.
		if(movieID >= 0)
		{
			ShowWindow();
			//Debug("Call FlashMoviePlayStart -> " @ movieID);
			FlashMoviePlayStart(movieID);
		}
		else
		{
			Debug("Error: Wrong MovieID ");
		}

		audioVolume = getAudioVolume();
	}
	else
	{
		if(Event_ID == EV_StateChanged)
		{
			Debug("EV_StateChanged" @ param);

			if(param == "INTROSTATE")
			{
				ciMovie();
			}
			else
			{
				useBackgroundUsm(param);
			}
		}
		else if(Event_ID == EV_Test_8)
		{
			customPlayUsm(0, 0, 400, 300, 1, 4, "awake7.usm", 100001, "UIPowerToolWnd");
		}
	}

	//else if(Event_ID == EV_DeleteFullSceneClipView)
	//{
	//	FullScreenMovieEnd();
	//	onMovieEnd();
	//}
}

function customPlayUsm(int posX, int posY, int nWidth, int nHeight, int skinType, int skipButtonType, string usmPath, int nMovieID, optional string anchorWindow)
{
	local string param;
	local Rect Rect;

	ParamAdd(param, "SkinType", string(skinType));
	ParamAdd(param, "SkipButtonType", string(skipButtonType));
	ParamAdd(param, "FileName", usmPath);
	ParamAdd(param, "MovieID", string(nMovieID));
	ParamAdd(param, "targetAnchorPointType", "topleft");
	ParamAdd(param, "clipAnchorPointType", "topleft");
	ParamAdd(param, "Width", string(nWidth));
	ParamAdd(param, "Height", string(nHeight));

	if(anchorWindow != "")
	{
		Rect = GetWindowHandle(anchorWindow).GetRect();
		ParamAdd(param, "PosX", string(Rect.nX + posX));
		ParamAdd(param, "PosY", string(Rect.nY + posY));		
	} else {
		ParamAdd(param, "PosX", string(posX));
		ParamAdd(param, "PosY", string(posY));
	}
	SetHavingFocus(true);
	SetAlwaysOnBack(false);
	setSceneClipMode(true);
	ExecuteEvent(EV_ShowSceneClipView, param);
	Debug("EV_ShowSceneClipView" @ param);
}

function useBackgroundUsm(string param)
{
	//Debug("param" @ param);
	if((param == "SERVERLISTSTATE")||(param == "EULAMSGSTATE")||(param == "LOGINSTATE")||(param == "LOGINWAITSTATE"))
	{
		SceneClipView(GetScript("SceneClipView")).loginBGMovie();
		//Debug("loginBGMovie" @ param);
	}
	else if((param == "CHARACTERSELECTSTATE")||(param == "EDITORSTATE"))
	{
		ExecuteEvent(EV_DeleteSceneClipView, "");
	}
}

function onMovieEnd()
{
	//듀얼 과금제 과련 무비 완료를 GFX 확인 
	local GfxDialog GfxDialogScript;

	GfxDialogScript = GfxDialog(GetScript("GfxDialog"));
	GfxDialogScript.onMovieEnd();
}

/**
 *  배경 사운드 볼륨 얻기
 **/
function int getAudioVolume()
{
	//local int   iMusicVolume;
	local float fMusicVolume;
	local float fSoundVolume;

	local float fEffectVolume;
	local float fAmbientVolume;
	local float fSystemVoiceVolume;
	local float fNpcVoiceVolume;

	local float fMaxVolume;

	if(GetOptionBool("Audio", "AudioMuteOn"))return 0;	

	fMusicVolume = GetOptionFloat("Audio", "MusicVolume");
	fEffectVolume = GetOptionFloat("Audio", "EffectVolume");
	fAmbientVolume = GetOptionFloat("Audio", "AmbientVolume");
	fSystemVoiceVolume = GetOptionFloat("Audio", "SystemVoiceVolume");
	fNpcVoiceVolume = GetOptionFloat("Audio", "NpcVoiceVolume");
	fSoundVolume = GetOptionFloat("Audio", "SoundVolume");

	fMaxVolume = fMax(fMusicVolume, fEffectVolume);
	fMaxVolume = fMax(fMaxVolume, fAmbientVolume);
	fMaxVolume = fMax(fMaxVolume, fSystemVoiceVolume);
	fMaxVolume = fMax(fMaxVolume, fNpcVoiceVolume);

	return fMaxVolume * fSoundVolume * 100;
}

defaultproperties
{
}
