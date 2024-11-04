/**
 *    스크린 메세지
 *    1~ 9 번까지 스크린 메세지 윈도우 
 *    
 *    ## 영지, 마을을에 진입 했을때 나오는 현재 위치 표시는  ZoneTitleWnd 이다 ##
 **/ 
class OnScreenMessage1Wnd extends UIScript;

const SCREENMESSAGEWND_MAX = 11;
var string currentwnd1;

var int globalDuration;
var int droprate;

enum Mstate
{
	FADE_IN,
	FADE_MIDDLE,
	FADE_OUT,
	FADE_NONE
};

var WindowHandle OnScreenMessage2Wnd;

// 윈도우 OnScreenMessageWnd 1 ~ 10
// 10은 EffectViewer

var WindowHandle handlearr[SCREENMESSAGEWND_MAX]; //1 ~ 10 까지 0은 쓰지말자 
var Mstate states[SCREENMESSAGEWND_MAX];

var int AlphaValues[SCREENMESSAGEWND_MAX];  //알파값을 저장할곳
var int DropValues[SCREENMESSAGEWND_MAX];   //증감치
var int LifeTimes[SCREENMESSAGEWND_MAX];

function resetByIdx(int idx)
{
	m_hOwnerWnd.KillTimer(idx);
	AlphaValues[idx] = 0;
	DropValues[idx] = 0;
	LifeTimes[idx] = 0;
	states[idx] = Mstate.FADE_NONE;	
}

function initAll()
{	
	local int idx;
	for(idx = 1; idx < SCREENMESSAGEWND_MAX; idx++)
	{
		handlearr[idx] = GetWindowHandle("OnScreenMessage" $ idx $ "Wnd");
		AlphaValues[idx] = 0;
		DropValues[idx] = 0;
		LifeTimes[idx] = 0;
		states[idx] = Mstate.FADE_NONE;
		m_hOwnerWnd.KillTimer(idx);

		handlearr[idx].SetCanBeShownDuringScene(true);
	}
}

function OnRegisterEvent()
{
	RegisterEvent(EV_ShowScreenMessage);
	RegisterEvent(EV_ShowScreenNPCZoomMessage);
	RegisterEvent(EV_SystemMessage);

	// 각성 점프이동 방향 텍스트 뷰
	RegisterEvent(EV_FlyMoveText);
	registerEvent(EV_GamingStateExit);
}

function OnLoad()
{
	initAll();
	currentwnd1 = "";
	OnScreenMessage2Wnd = GetWindowHandle("OnScreenMessage2Wnd");
	//ShowMsg(2, "Hello World!", 3000, 11, 0, 1, 255, 255, 255);
	//ShowMsg(8, "Hello World! Hello World! Hello World!#Hello World!", 3000, 11, 0, 0);	
}

// 모션 애니용 타이머 
function OnTimer(int TimerID)
{
	local int idx;

	idx = TimerID;
	// End:0xBD
	if(states[idx] == Mstate.FADE_IN)
	{
		AlphaValues[idx] += DropValues[idx];
		if(AlphaValues[idx] >= 255)
		{
			AlphaValues[idx] = 255;
			states[idx] = Mstate.FADE_MIDDLE;
			m_hOwnerWnd.KillTimer(idx);
			m_hOwnerWnd.SetTimer(idx, LifeTimes[idx]);
		}

		handlearr[idx].SetAlpha(AlphaValues[idx]);
	}
	else if(states[idx] == Mstate.FADE_MIDDLE)
	{
		states[idx] = Mstate.FADE_OUT;
		m_hOwnerWnd.KillTimer(idx);
		m_hOwnerWnd.SetTimer(idx, 30);
	}
	else if(states[idx] == Mstate.FADE_OUT)
	{
		AlphaValues[idx] -= DropValues[idx];
		if(AlphaValues[idx] <= 0)
		{
			AlphaValues[idx] = 0;
			states[idx] = Mstate.FADE_NONE;
			m_hOwnerWnd.KillTimer(idx);

			handlearr[idx].HideWindow();
			if(idx == 10)
			{
				GetEffectViewportWndHandle("OnScreenMessage" $ string(idx) $ "Wnd" $ ".EffectViewport01").HideWindow();
				GetEffectViewportWndHandle("OnScreenMessage" $ string(idx) $ "Wnd" $ ".EffectViewport01").SpawnEffect("");
			}
		}	

		handlearr[idx].SetAlpha(AlphaValues[idx]);

	}
	else if(states[idx] == Mstate.FADE_NONE)
	{
		//do nothing
	}
}

function ResetAllMessage()
{
	local int i;
	local Color DefaultColor;
	local string wndname;

	DefaultColor.R = 255;
	DefaultColor.G = 255;
	DefaultColor.B = 255;
	
	currentwnd1 = "";

	OnScreenMessage2Wnd.HideWindow();

	// Set DefaultColor for all the Screen Messages
	// 뒤에 9, 10번은 텍스트 박스 없음
	for (i = 1; i < SCREENMESSAGEWND_MAX ; ++i )
	{
		if (i == 9) continue;  // 9번은 초기화 안함. 그냥 텍스트 박스가 몇개 없고 칼라를 안바꿔서 그런듯.

		wndname = "OnScreenMessage" $ i $ "Wnd";

		// 현재 보여지고 메세지는 칼라를 초기화 하지 않는다.
		if(GetWindowHandle(wndname).IsShowWindow()) continue;

		class'UIAPI_TEXTBOX'.static.SetTextColor( wndname $ ".TextBox" $ i , DefaultColor);
		class'UIAPI_TEXTBOX'.static.SetTextColor( wndname $ ".TextBox" $ i $ "-1" , DefaultColor);

		class'UIAPI_TEXTBOX'.static.SetTextColor( wndname $ ".TextBox" $ i $ "-2" , DefaultColor); //TMP

		class'UIAPI_TEXTBOX'.static.SetTextColor( wndname $ ".TextBoxsm" $ i  , DefaultColor);
		class'UIAPI_TEXTBOX'.static.SetTextColor( wndname $ ".TextBoxsm" $ i $ "-1" , DefaultColor);

		class'UIAPI_TEXTBOX'.static.SetTextColor( wndname $ ".TextBoxsm" $ i $ "-2" , DefaultColor); //TMP
	}

	//장식 이미지 현재 위치 리셋
	//if (linedivided == true)
		//class'UIAPI_WINDOW'.static.Move("OnScreenMessage2Wnd.texturetype2", 0, -30, 0);
}

// 메세지 출력 
function ShowMsg(int WndNum, string TextValue, int Duration, int Animation, int fonttype, int backgroundtype, int ColorR, int ColorG, int ColorB, optional bool bUseNpcZoom, optional int msgno)
{
	local string WndName;
	local string TextBoxName;
	local string TextBoxName2;
	local string TextBoxName3;

	local string TextValue1;
	local string TextValue2;

	local string TextValue3;

	local string CurText;

	local string 	SmallBoxName1;
	local string 	SmallBoxName2;
	local string 	SmallBoxName3;
	
	local color FontColor;

	local int i;
	local int j;
	local int LengthTotal;
	local int TotalLength;

	local SystemMsgData msgInfo;

	//local vector offset;

	FontColor.R = ColorR;
	FontColor.G = ColorG;
	FontColor.B = ColorB;
	
	TextValue1 = "";
	TextValue2 = "";
	TextValue3 = "";
	j = 1;
	TotalLength =  Len(TextValue);
	
	// #이면 줄바꿈, 3줄까지 지원
	// 테스트 해보니 잘됨. 허나 사용 한곳은 없음.
	for (i=1; i <= TotalLength; ++i)
	{
		LengthTotal = Len(TextValue) - 1 ;
		CurText = Left(TextValue, 1) ;
		TextValue = Right(TextValue, LengthTotal) ;

		if(CurText =="`")
		{
			CurText = "" ;
		}		
		else if(CurText =="#")
		{
			CurText = "" ;
			j ++ ;
			//linedivided = true;
		}
		else 
		{		
			if (j == 1)
			{
				TextValue1 = TextValue1 $ CurText;
			}
			else if ( j == 2 ) 
			{
				TextValue2 = TextValue2 $ CurText;
			}
			else 
			{
				TextValue3 = TextValue3 $ CurText;
			}
		}
	}

	// 사용할 스크린 윈도우 지정
	WndName = "OnScreenMessage" $ WndNum $ "Wnd";
	
	// 상단 중앙
	if (WndNum == 2)
	{
		// 가운데 꼬챙이 있는 문양 출력, 2018-11에는 1번만 사용 중.
		if (backgroundtype == 1)
		{
			class'UIAPI_WINDOW'.static.ShowWindow(WndName$".texturetype1");
		}
		else 
		{
			class'UIAPI_WINDOW'.static.HideWindow(WndName$".texturetype1");
		}
	}
	// 이펙트를 포함한 WndNum=2 번 위치에 표시할 특수 스크린 메세지 (최상단에 나온다)
	else if (WndNum == 10)
	{
		if ( backgroundtype != 1 )
			Class'UIAPI_WINDOW'.static.HideWindow(WndName $ ".texturetype1");

		if ( backgroundtype != 2 )
			Class'UIAPI_WINDOW'.static.HideWindow(WndName $ ".texturetype2");

		if ( backgroundtype != 3 )
			Class'UIAPI_WINDOW'.static.HideWindow(WndName $ ".texturetype3");

		switch (backgroundtype)
		{
			case 1:
				Class'UIAPI_WINDOW'.static.ShowWindow(WndName $ ".texturetype1");
				break;
			case 2:
				Class'UIAPI_WINDOW'.static.ShowWindow(WndName $ ".texturetype2");
				break;
			case 3:
				Class'UIAPI_WINDOW'.static.ShowWindow(WndName $ ".texturetype3");
				break;
		}

		GetSystemMsgInfo( msgno, msgInfo);	
		// Debug("스트링 param " @ msgno@msgInfo.OnScrParam);

		// 일단은 OnScreenMessageWnd10 에만 _EffectViewPort가 있음.
		// _EffectViewPort은 스크린 최상단 위치로 이동도 포함
		if (msgInfo.OnScrParam != "") setParamEffectViewPlay(WndName, msgInfo.OnScrParam);
		else GetEffectViewportWndHandle(WndName $ ".EffectViewport01").HideWindow();
	}

	TextBoxName = WndName $ ".TextBox" $ WndNum;
	TextBoxName2 = WndName $ ".TextBox" $ WndNum $ "-1";
	TextBoxName3 = WndName $ ".TextBox" $ WndNum $ "-2";

	SmallBoxName1 = WndName $".TextBoxsm" $ WndNum;
	SmallBoxName2 = WndName $".TextBoxsm" $ WndNum $ "-1";
	SmallBoxName3 = WndName $".TextBoxsm" $ WndNum $ "-2";
	
	currentwnd1 = WndName;

	class'UIAPI_TEXTBOX'.static.SetTextColor( TextBoxName  , FontColor);
	class'UIAPI_TEXTBOX'.static.SetTextColor( TextBoxName2 , FontColor);
	class'UIAPI_TEXTBOX'.static.SetTextColor( TextBoxName3 , FontColor);

	class'UIAPI_TEXTBOX'.static.SetTextColor( SmallBoxName1 , FontColor);
	class'UIAPI_TEXTBOX'.static.SetTextColor( SmallBoxName2 , FontColor);
	class'UIAPI_TEXTBOX'.static.SetTextColor( SmallBoxName3 , FontColor);

	if (fonttype == 0)
	{
		class'UIAPI_WINDOW'.static.ShowWindow(currentwnd1);

		class'UIAPI_TEXTBOX'.static.SetText(TextBoxName , TextValue1);
		class'UIAPI_TEXTBOX'.static.SetText(TextBoxName2, TextValue2);
		class'UIAPI_TEXTBOX'.static.SetText(TextBoxName3, TextValue3);

		class'UIAPI_TEXTBOX'.static.SetText(SmallBoxName1,"");
		class'UIAPI_TEXTBOX'.static.SetText(SmallBoxName2,"");
	}
	else if (fonttype == 1)
	{
		class'UIAPI_WINDOW'.static.ShowWindow(currentwnd1);

		class'UIAPI_TEXTBOX'.static.SetText(TextBoxName,"");
		class'UIAPI_TEXTBOX'.static.SetText(TextBoxName2,"");
		class'UIAPI_TEXTBOX'.static.SetText(TextBoxName3,"");

		class'UIAPI_TEXTBOX'.static.SetText(SmallBoxName1,TextValue1);
		class'UIAPI_TEXTBOX'.static.SetText(SmallBoxName2,TextValue2);
		class'UIAPI_TEXTBOX'.static.SetText(SmallBoxName3,TextValue3);
	}	
	
	// droprate 의 값이 255 면 빠르게 팍 하면서 나오고,
	// 15,25 같이 값이 낮으면 천천히 페이드인 아웃 된는 식으로 스크린메세지가 나온다. 
	switch (Animation)
	{
		case 0:
			droprate = 255;
		break;
		case 1:
			droprate = 25;
		break;
		case 11:
			droprate = 15;
		break;
		case 12:
			droprate = 25;
		break;
		case 13:
			droprate = 35;
		break;
	}
	
	resetByIdx(WndNum);
	
	DropValues[WndNum] = droprate;
	states[WndNum] = Mstate.FADE_IN;

	if ( !bUseNpcZoom )
	{
		LifeTimes[WndNum] = Duration;
		m_hOwnerWnd.SetTimer(WndNum, 30);
	}
}

function setParamEffectViewPlay(string WndName, string a_Param)
{
	
	local float nScale, fCameraDistance;
	local int x, y;
	local string effect;

	local Vector offset;
	local int nPitch, nYaw;

	ParseFloat(a_Param, "scale", nScale);
	ParseFloat(a_Param, "distance", fCameraDistance);

	ParseInt(a_Param, "x", x);
	ParseInt(a_Param, "y", y);
	ParseInt(a_Param, "pitch", nPitch);
	ParseInt(a_Param, "yaw", nYaw);

	ParseString(a_Param, "effect", effect);
	offset.x = x;
	offset.y = y;
	Debug("setParamEffectViewPlay:" @ effect);
	Debug(a_Param);
	GetEffectViewportWndHandle(WndName $ ".EffectViewport01").ShowWindow();
	GetEffectViewportWndHandle(WndName $ ".EffectViewport01").SpawnEffect("");
	GetEffectViewportWndHandle(WndName $ ".EffectViewport01").SetScale(nScale);
	GetEffectViewportWndHandle(wndname $ ".EffectViewport01").SetCameraPitch(nPitch);
	GetEffectViewportWndHandle(wndname $ ".EffectViewport01").SetCameraYaw(nYaw);
	GetEffectViewportWndHandle(WndName $ ".EffectViewport01").SetCameraDistance(fCameraDistance);
	GetEffectViewportWndHandle(WndName $ ".EffectViewport01").SetOffset(offset);
	GetEffectViewportWndHandle(WndName $ ".EffectViewport01").SpawnEffect(effect);
}

function OnEvent( int a_EventID, String a_Param )
{
	local int msgtype;
	local int msgno;
	local int windowtype;	
	local int fontsize;
	local int fonttype;
	local int msgcolor;
	local int msgcolorR;
	local int msgcolorG;
	local int msgcolorB;
	local int shadowtype;
	local int backgroundtype;
	local int lifetime;
	local int animationtype;
	local int SystemMsgIndex;
	local string msgtext;
	local string ParamString1;
	local string ParamString2;

	//local string scrnMsgParam;

	// Debug("onScreenMessage" @ a_EventID @ a_Param);

	// event show screen message
	if( a_EventID == EV_ShowScreenMessage )
	{
		ParseInt( a_Param, "MsgType", msgtype );
		ParseInt( a_Param, "MsgNo", msgno );
		ParseInt( a_Param, "WindowType", windowtype );
		ParseInt( a_Param, "FontSize", fontsize );
		ParseInt( a_Param, "FontType", fonttype );
		
		ParseInt( a_Param, "MsgColor", msgcolor );
		if (!ParseInt( a_Param, "MsgColorR", msgcolorR ))
			msgcolorR = 255;
		if (!ParseInt( a_Param, "MsgColorG", msgcolorG ))
			msgcolorG = 255;
		if (!ParseInt( a_Param, "MsgColorB", msgcolorB ))
			msgcolorB = 255;
		ParseInt( a_Param, "ShadowType", shadowtype );
		ParseInt( a_Param, "BackgroundType", backgroundtype );
		ParseInt( a_Param, "LifeTime", lifetime );
		ParseInt( a_Param, "AnimationType", animationtype );
		ParseString( a_Param, "Msg", msgtext );


		ResetAllMessage();
		if ( msgtype == 0 )
			msgtext =  GetSystemMessage(msgno);

		if (windowtype <= 0 || windowtype > 10) 
		{
			Debug("!!!!!!!!!!!!!!!!!!!! EV_ShowScreenMessage! windowtype 오류 : " @  WindowType);
			Debug("WindowType 은 1~10 값이 와야 합니다.");
			return;
		}

		ShowMsg(windowtype, msgtext, lifetime, animationtype, fonttype, backgroundtype, msgcolorR, msgcolorG, msgcolorB, false, msgno);
	}	
	// event show screen NPC zoom message
	else if(a_EventID == EV_ShowScreenNPCZoomMessage)
	{
		ParseInt( a_Param, "MsgType", msgtype );
		ParseInt( a_Param, "MsgNo", msgno );
		ParseInt( a_Param, "WindowType", windowtype );
		ParseInt( a_Param, "FontSize", fontsize );
		ParseInt( a_Param, "FontType", fonttype );
		
		if( ParseInt( a_Param, "MsgColor", msgcolor ) )
		{
			// if msgcolor is black then convert white
			if( msgcolor == 0 )
			{
				msgcolor = 0xFFFFFF;			
			}		
		
			msgcolorR = (msgcolor&0xFF0000)>>16;
			msgcolorG = (msgcolor&0xFF00)>>8;
			msgcolorB = (msgcolor&0xFF);
		}
		else
		{
			if (!ParseInt( a_Param, "MsgColorR", msgcolorR ))
				msgcolorR = 255;
			if (!ParseInt( a_Param, "MsgColorG", msgcolorG ))
				msgcolorG = 255;
			if (!ParseInt( a_Param, "MsgColorB", msgcolorB ))
				msgcolorB = 255;
		}
		
		ParseInt( a_Param, "ShadowType", shadowtype );
		ParseInt( a_Param, "BackgroundType", backgroundtype );
		ParseInt( a_Param, "LifeTime", lifetime );
		ParseInt( a_Param, "AnimationType", animationtype );
		ParseString( a_Param, "Msg", msgtext );		
		
		ResetAllMessage();
		
		switch( msgtype )
		{
			case 0:
				//
				msgtext =  GetSystemMessage(msgno);
				break;
				
			case 1:
				// do nothing.
				break;
				
			case 2:
				// if msgtype is 2 then, it's mean that continue word. 
				msgtext = msgtext $ "...";
				break;
				
			default:
				break;
		}
		
		ShowMsg(windowtype, msgtext, lifetime, animationtype, fonttype, backgroundtype, msgcolorR, msgcolorG, msgcolorB, true, msgno);
	}	
	else if( a_EventID == EV_SystemMessage ) //시스템 메시지 오류 //각성 메시지 등
	{
		ParseInt ( a_Param, "Index", SystemMsgIndex );
		ParseString ( a_Param, "Param1", ParamString1 );
		ParseString ( a_Param, "Param2", ParamString2 );

		ValidateSystemMsg( SystemMsgIndex, ParamString1, ParamString2 );
	}
	else if ( a_EventID == EV_GamingStateExit )
	{
		Clear();
	}
	// 각성 점프 이동 
	else if (a_EventID == EV_FlyMoveText) // 각성 후 점프 
	{
		ParseString ( a_Param, "string", ParamString1 );
		
		class'UIAPI_TEXTBOX'.static.SetText( "OnScreenMessage2Wnd.TextBox2", "");
		class'UIAPI_TEXTBOX'.static.SetText( "OnScreenMessage2Wnd.TextBox2-1", ParamString1);

		if (ParamString1 == "")
		{
			OnScreenMessage2Wnd.HideWindow();	
		}
		else
		{
			OnScreenMessage2Wnd.SetAlpha(255);
			OnScreenMessage2Wnd.ShowWindow();
		}
	}
}

// clear this Script
function Clear()		
{
	initAll();
	currentwnd1 = "";
}

function ValidateSystemMsg(int Index, string StringTxt1, string StringTxt2)
{
	local SystemMsgData SystemMsgCurrent;

	local int windowtype;	
	local int fonttype;
	local int backgroundtype;
	local int lifetime;
	local int animationtype;
	local string msgtext;
	local Color TextColor;
	
	GetSystemMsgInfo( Index, SystemMsgCurrent);	
	
	if ( SystemMsgCurrent.WindowType != 0 )
	{
		windowtype = SystemMsgCurrent.WindowType; 
		msgtext = SystemMsgCurrent.OnScrMsg;
		msgtext = MakeFullSystemMsg( msgtext, StringTxt1, StringTxt2 );
		lifetime = (SystemMsgCurrent.LifeTime * 1000);
		animationtype = SystemMsgCurrent.AnimationType;
		fonttype = SystemMsgCurrent.FontType;
		backgroundtype = SystemMsgCurrent.backgroundtype;
		TextColor = SystemMsgCurrent.FontColor;

		//Debug("OnScrParam" @  SystemMsgCurrent.OnScrParam);

		if (TextColor.R == 0 && TextColor.G == 0 && TextColor.B == 0 )
		{
			TextColor.R = 255;
			TextColor.G = 255; 
			TextColor.B = 255; 
		}
		else if (TextColor.R == 176 && TextColor.G == 155 && TextColor.B == 121 )
		{
			TextColor.R = 255;
			TextColor.G = 255; 
			TextColor.B = 255; 
		}
		
		ShowMsg(windowtype, msgtext, lifetime, animationtype, fonttype, backgroundtype, TextColor.R, TextColor.G, TextColor.B, false, Index);
	}
}

defaultproperties
{
}
