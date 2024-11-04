class L2UITween extends UICommonAPI;

const Pi = 3.141592653589793;
const TWEENEND = "tweenEnd";
const SHAKEEND = "shakeEnd";

enum easeType {
	IN_STRONG,		// 0
	OUT_STRONG,		// 1
	INOUT_STRONG,	// 2
	IN_BOUNCE,		// 3
	OUT_BOUNCE,		// 4
	INOUT_BOUNCE,	// 5
	IN_ELASTIC,		// 6
	OUT_ELASTIC,	// 7
	INOUT_ELASTIC,	// 8
	EASENONE		// 9
};

enum directionType {
	big,
	small
};

struct TweenObject
{
	var WindowHandle Target;
	var string Owner;
	var int Id;
	var float Position;
	var float Duration;
	var float Delay;
	var int sizeXStart;
	var int sizeYStart;
	var float MoveX;
	var float MoveY;
	var float Alpha;
	var float SizeX;
	var float SizeY;
	var int alphaStart;
	var int posX;
	var int posY;
	var easeType ease;
	var bool tweenStarted;
};

struct ShakeObject
{
	var WindowHandle Target;
	var string Owner;
	var int Id;
	var float Position;
	var float Duration;
	var float Delay;
	var float shakeSize;
	var int posX;
	var int posY;
	var bool shakeStarted;
	var directionType Direction;
};

var WindowHandle Me;
var private float lastAppSeconds;
var private INT64 lastAppMilliSeconds;
var private array<L2UITweenObject> tweenObjects;
var private array<L2UITweenTwinkleObject> twinkleObjects;
var array<ShakeObject> shakeObjects;
var bool isTickOn;

static function L2UITween Inst()
{
	return L2UITween(GetScript("L2UITween"));	
}

event OnLoad()
{
	Me = GetWindowHandle("L2UITween");
}

event OnTick()
{
	local float DeltaTime;

	DeltaTime = float(GetDeltaMilliTime()) / float(1000);
	SetLastAppMilliSeconds();
	// End:0x34
	if(twinkleObjects.Length > 0)
	{
		UpdatePositionTwinkle(DeltaTime);
	}
	if(tweenObjects.Length > 0)
	{
		UpdatePosition(DeltaTime);
	}
	if(shakeObjects.Length > 0)
	{
		UpdatePositionShake(DeltaTime);
	}
	CheckTickEnable();
}

private function SetLastAppMilliSeconds()
{
	lastAppMilliSeconds = GetAppMilliSeconds();	
}

private function INT64 GetDeltaMilliTime()
{
	return (GetAppMilliSeconds()) - lastAppMilliSeconds;	
}

private function TickOn()
{
	// End:0x0B
	if(isTickOn)
	{
		return;
	}
	isTickOn = true;
	Me.EnableTick();
	SetLastAppMilliSeconds();
}

private function TickOff()
{
	// End:0x0D
	if(! isTickOn)
	{
		return;
	}
	isTickOn = false;
	Me.DisableTick();
}

private function CheckTickEnable()
{
	// End:0x0E
	if(tweenObjects.Length > 0)
	{
		return;
	}
	// End:0x1C
	if(shakeObjects.Length > 0)
	{
		return;
	}
	// End:0x2A
	if(twinkleObjects.Length > 0)
	{
		return;
	}
	TickOff();
}

function Add(string TargetName, string Owner, int Id, int ease, float Duration, float Alpha, float MoveX, float MoveY, float SizeX, float SizeY, optional float Delay)
{
	local TweenObject tweenObj;

	tweenObj.Position = 0.0;
	tweenObj.Delay = Delay;
	tweenObj.Target = GetWindowHandle(TargetName);
	tweenObj.Owner = Owner;
	tweenObj.Id = Id;
	tweenObj.ease = easeType(ease);
	tweenObj.Duration = Duration;
	tweenObj.Alpha = Alpha;
	tweenObj.MoveX = MoveX;
	tweenObj.MoveY = MoveY;
	tweenObj.SizeX = SizeX;
	tweenObj.SizeY = SizeY;
	AddTweenObject(tweenObj);
}

function AddTweenObject(TweenObject tweenObj)
{
	local L2UITweenObject l2uiTweenObj;

	l2uiTweenObj = new class'L2UITweenObject';
	tweenObj.Position = 0.0f;
	l2uiTweenObj.Position = tweenObj.Position;
	l2uiTweenObj.Delay = tweenObj.Delay;
	l2uiTweenObj.Target = tweenObj.Target;
	l2uiTweenObj.Owner = tweenObj.Owner;
	l2uiTweenObj.Id = tweenObj.Id;
	l2uiTweenObj.ease = tweenObj.ease;
	l2uiTweenObj.Duration = tweenObj.Duration;
	l2uiTweenObj.Alpha = tweenObj.Alpha;
	l2uiTweenObj.MoveX = tweenObj.MoveX;
	l2uiTweenObj.MoveY = tweenObj.MoveY;
	l2uiTweenObj.SizeX = tweenObj.SizeX;
	l2uiTweenObj.SizeY = tweenObj.SizeY;
	SetStartValue(l2uiTweenObj);
	TickOn();
	tweenObjects[tweenObjects.Length] = l2uiTweenObj;	
}

function StopTween(string Owner, int Id)
{
	local int Index;

	Index = GetTweenObjectIndex(Owner, Id);
	// End:0x31
	if(Index != -1)
	{
		tweenObjects.Remove(Index, 1);
	}
}

function _Pause(string Owner, int Id)
{
	local int Index;

	Index = GetTweenObjectIndex(Owner, Id);
	// End:0x3A
	if(Index != -1)
	{
		tweenObjects[Index]._Pause();
	}	
}

function _Play(string Owner, int Id)
{
	local int Index;

	Index = GetTweenObjectIndex(Owner, Id);
	// End:0x3A
	if(Index != -1)
	{
		tweenObjects[Index]._Play();
	}	
}

private function SetStartValue(out L2UITweenObject tweenObjectData)
{
	local Rect rectWnd, rectWndParent;

	rectWnd = tweenObjectData.Target.GetRect();
	rectWndParent = tweenObjectData.Target.GetParentWindowHandle().GetRect();
	tweenObjectData.alphaStart = tweenObjectData.Target.GetAlpha();
	tweenObjectData.posX = rectWnd.nX - rectWndParent.nX;
	tweenObjectData.posY = rectWnd.nY - rectWndParent.nY;
	tweenObjectData.sizeXStart = rectWnd.nWidth;
	tweenObjectData.sizeYStart = rectWnd.nHeight;
	tweenObjectData._DelegateOnStart();
}

private function UpdatePosition(float Value)
{
	local float ratio, ratioEase;
	local int i;
	local array<int> completeds;
	local array<L2UITweenObject> completedargetObject;

	
	for(i = 0;i < tweenObjects.Length; i++)
	{
		// End:0x32
		if(tweenObjects[i].Paused)
		{
			// [Explicit Continue]
			continue;
		}
		tweenObjects[i].Position += Value;
		// End:0x86
		if(tweenObjects[i].Position <= tweenObjects[i].Delay / 1000)
		{
			// [Explicit Continue]
			continue;
		}
		tweenObjects[i]._DelegateOnUpdate(tweenObjects[i].Position);
		ratio = (tweenObjects[i].Position - tweenObjects[i].Delay / 1000) / (tweenObjects[i].Duration / 1000);
		// End:0x195
		if(ratio >= 1)
		{
			ratio = 1.0;
			tweenObjects[i].Position = (tweenObjects[i].Duration + tweenObjects[i].Delay) / 1000;
			completedargetObject[completedargetObject.Length] = tweenObjects[i];
			completeds[completeds.Length] = i;
		}
		ratioEase = GetRationEase(ratio, tweenObjects[i].ease);
		// End:0x1E0
		if(tweenObjects[i].Target.m_pTargetWnd == none)
		{
			// [Explicit Continue]
			continue;
		}
		if(tweenObjects[i].Alpha != 0)
		{
			tweenObjects[i].Target.SetAlpha(int(tweenObjects[i].alphaStart + tweenObjects[i].Alpha * ratioEase));
		}
		if(tweenObjects[i].SizeX != 0 || tweenObjects[i].SizeY != 0)
		{
			tweenObjects[i].Target.SetWindowSize(int(tweenObjects[i].sizeXStart + tweenObjects[i].SizeX * ratioEase),int(tweenObjects[i].sizeYStart + tweenObjects[i].SizeY * ratioEase));
		}
		if(tweenObjects[i].MoveX != 0 || tweenObjects[i].MoveY != 0)
		{
			tweenObjects[i].Target.MoveC(int(tweenObjects[i].posX + tweenObjects[i].MoveX * ratioEase),int(tweenObjects[i].posY + tweenObjects[i].MoveY * ratioEase));
		}
	}
	
	for(i = completeds.Length - 1; i >= 0; i--)
	{
		tweenObjects[completeds[i]]._DelegateOnEnd();
		tweenObjects.Remove(completeds[i], 1);
	}
	
	for(i = 0; i < completeds.Length; i++)
	{
		CompleteTween(completedargetObject[i]);
	}
}

private function CompleteTween(L2UITweenObject tweenObjectData)
{
	local WindowHandle Target;

	Target = tweenObjectData.Target;
	Target.SetAlpha(int(tweenObjectData.alphaStart + tweenObjectData.Alpha));
	Target.SetWindowSize(int(tweenObjectData.sizeXStart + tweenObjectData.SizeX), int(tweenObjectData.sizeYStart + tweenObjectData.SizeY));
	Target.MoveC(int(tweenObjectData.posX + tweenObjectData.MoveX),int(tweenObjectData.posY + tweenObjectData.MoveY));
	GetScript(tweenObjectData.Owner).OnCallUCFunction(TWEENEND, string(tweenObjectData.Id));
}

function StartShake(string TargetName, int nShakeSize, int nTime, directionType Dir, optional int Delay, optional int Id)
{
	local ShakeObject shakeObjectData;

	shakeObjectData.Owner = TargetName;
	shakeObjectData.Target = GetWindowHandle(TargetName);
	shakeObjectData.Duration = nTime;
	shakeObjectData.shakeSize = nShakeSize;
	shakeObjectData.Direction = Dir;
	shakeObjectData.Delay = Delay;
	shakeObjectData.Id = Id;
	StartShakeObject(shakeObjectData);
}

function StartShakeObject(ShakeObject shakeObjectData)
{
	shakeObjects[shakeObjects.Length] = shakeObjectData;
	TickOn();
}

private function SetStartValueShake(out ShakeObject shakeObjectData)
{
	local Rect rectWnd, rectWndParent;

	rectWnd = shakeObjectData.Target.GetRect();
	rectWndParent = shakeObjectData.Target.GetParentWindowHandle().GetRect();
	shakeObjectData.posX = rectWnd.nX - rectWndParent.nX;
	shakeObjectData.posY = rectWnd.nY - rectWndParent.nY;
	shakeObjectData.shakeStarted = true;
}

private function UpdatePositionShake(float DeltaTime)
{
	local int i;
	local array<int> Completed;
	local float ratio;
	local bool complete;

	
	for(i = 0;i < shakeObjects.Length;i++)
	{
		shakeObjects[i].Position += DeltaTime;
		if(shakeObjects[i].Position <= shakeObjects[i].Delay / 1000)
		{
			continue;
		}
		else if(!shakeObjects[i].shakeStarted)
		{
			SetStartValueShake(shakeObjects[i]);
		}
		ratio = (shakeObjects[i].Position - (shakeObjects[i].Delay / 1000)) / (shakeObjects[i].Duration / 1000);
		complete = ratio >= 1;
		Shake(shakeObjects[i], ratio);
		if(complete)
		{
			Completed[Completed.Length] = i;
			CompleteShake(i);
		}
	}
	
	for(i = Completed.Length - 1; i >= 0; i--)
	{
		shakeObjects.Remove(Completed[i], 1);
	}
}

function Shake(ShakeObject shakeObjectData, float ratio)
{
	local float X, Y, Value;

	switch(shakeObjectData.Direction)
	{
		case big:
			Value = shakeObjectData.shakeSize * ratio;
			break;
		case small:
			Value = shakeObjectData.shakeSize * 1 - ratio;
			break;
	}
	if(Rand(2)== 0)
	{
		X = shakeObjectData.posX - appRound(Rand(Value));
	}
	else
	{
		X = shakeObjectData.posX + appRound(Rand(Value));
	}
	if(Rand(2)== 0)
	{
		Y = shakeObjectData.posY - appRound(Rand(Value));
	}
	else
	{
		Y = shakeObjectData.posY + appRound(Rand(int(Value)));
	}
	shakeObjectData.Target.MoveC(X, Y);
}

function StopShake(string Owner, int Id)
{
	local int Index;

	Index = GetShakeObjectIndex(Owner, Id);
	// End:0x31
	if(Index != -1)
	{
		shakeObjects.Remove(Index, 1);
	}
}

function int GetShakeObjectIndex(string Owner, int Id)
{
	local int i;

	
	for(i = 0; i < shakeObjects.Length;i++)
	{
		if(shakeObjects[i].Owner == Owner && shakeObjects[i].Id == Id)
		{
			return i;
		}
	}
	return -1;
}

private function CompleteShake(int Index)
{
	local WindowHandle Target;
	local ShakeObject shakeObjectData;

	shakeObjectData = shakeObjects[Index];
	Target = shakeObjectData.Target;
	Target.MoveC(shakeObjectData.posX, shakeObjectData.posY);
	GetScript(shakeObjectData.Owner).OnCallUCFunction(SHAKEEND, string(shakeObjectData.Id));
}

function L2UITweenTwinkleObject _AddTweenTwinlkle(WindowHandle targetObject, optional float twinkleNum, optional float startRatio, optional float Duration, optional int minAlpha, optional int maxAlpha, optional float gab, optional float Delay)
{
	local L2UITweenTwinkleObject twinkleObj;
	local int Index;

	// End:0x16
	if(targetObject.m_pTargetWnd == none)
	{
		return none;
	}
	// End:0x2E
	if(Duration == 0)
	{
		Duration = 1000.0f;
	}
	twinkleObj = new class'L2UITweenTwinkleObject';
	twinkleObj.Owner = targetObject.GetTopFrameWnd().GetWindowName();
	twinkleObj.Target = targetObject;
	twinkleObj.Duration = Duration;
	twinkleObj.twinkleNum = twinkleNum;
	twinkleObj._SetRatio(startRatio);
	twinkleObj.minAlpha = minAlpha;
	twinkleObj.gab = gab;
	twinkleObj.Delay = Delay;
	// End:0x110
	if(maxAlpha == 0)
	{
		twinkleObj.maxAlpha = 255;		
	}
	else
	{
		twinkleObj.maxAlpha = maxAlpha;
	}
	Index = GetTwinkleObjectIndex(targetObject);
	// End:0x154
	if(Index >= 0)
	{
		twinkleObjects[Index] = twinkleObj;		
	}
	else
	{
		twinkleObjects[twinkleObjects.Length] = twinkleObj;
		TickOn();
	}
	return twinkleObj;	
}

private function UpdatePositionTwinkle(float Value)
{
	local int i, Index;
	local float ratio;
	local array<int> completeds;

	// End:0x392 [Loop If]
	for(i = 0; i < twinkleObjects.Length; i++)
	{
		// End:0x32
		if(twinkleObjects[i].Paused)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x62
		if(! twinkleObjects[i].Target.GetTopFrameWnd().IsShowWindow())
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x154
		if(twinkleObjects[i].Delay > 0)
		{
			// End:0xBD
			if(twinkleObjects[i].Delay > Value)
			{
				twinkleObjects[i].Delay -= Value;
				// [Explicit Continue]
				continue;				
			}
			else
			{
				// End:0xF2
				if(twinkleObjects[i].Position == 0)
				{
					twinkleObjects[i]._DelegateOnStart();
				}
				twinkleObjects[i].Position += twinkleObjects[i].Delay;
				twinkleObjects[i].Delay = 0.0f;
			}
			ratio = twinkleObjects[i]._Ratio();			
		}
		else
		{
			// End:0x189
			if(twinkleObjects[i].Position == 0)
			{
				twinkleObjects[i]._DelegateOnStart();
			}
			twinkleObjects[i].Position += Value;
			ratio = twinkleObjects[i]._Ratio();
			// End:0x221
			if(int(ratio - ((Value * 1000) / twinkleObjects[i].Duration)) < int(ratio))
			{
				twinkleObjects[i].Delay = twinkleObjects[i].gab;
			}
		}
		twinkleObjects[i]._DelegateOnUpdate(twinkleObjects[i].Position);
		// End:0x298
		if(twinkleObjects[i].twinkleNum == -1)
		{
			// End:0x295
			if(ratio >= 1)
			{
				twinkleObjects[i].Position = 0.0f;
			}			
		}
		else
		{
			// End:0x2E2
			if(ratio >= twinkleObjects[i].twinkleNum)
			{
				completeds[completeds.Length] = i;
				ratio = twinkleObjects[i].twinkleNum;
			}
		}
		// End:0x388
		if(twinkleObjects[i].Target.m_pTargetWnd != none)
		{
			twinkleObjects[i].Target.SetAlpha(int(((Cos((ratio * 2) * 3.1415930f) + 1) / 2) * float(twinkleObjects[i].maxAlpha - twinkleObjects[i].minAlpha)) + twinkleObjects[i].minAlpha);
		}
	}

	// End:0x3EC [Loop If]
	for(i = completeds.Length - 1; i >= 0; i--)
	{
		Index = completeds[i];
		twinkleObjects[Index]._DelegateOnEnd();
		twinkleObjects.Remove(Index, 1);
	}	
}

function _KillTwinkleWithWnd(WindowHandle targetWnd)
{
	local int Index;

	Index = GetTwinkleObjectIndex(targetWnd);
	// End:0x22
	if(Index == -1)
	{
		return;
	}
	twinkleObjects.Remove(Index, 1);	
}

private function int GetTwinkleObjectIndex(WindowHandle wndHandle)
{
	local int i;

	// End:0x45 [Loop If]
	for(i = 0; i < twinkleObjects.Length; i++)
	{
		// End:0x3B
		if(twinkleObjects[i].Target == wndHandle)
		{
			return i;
		}
	}
	return -1;	
}

private function int GetTweenObjectIndex(string Owner, int Id)
{
	local int i;

	
	for(i = 0; i < tweenObjects.Length; i++)
	{
		if(tweenObjects[i].Owner == Owner && tweenObjects[i].Id == Id)
		{
			return i;
		}
	}
	return -1;
}

function int GetAbs(int Num)
{
	// End:0x13
	if(Num < 0)
	{
		return - Num;
	}
	return Num;
}

function float GetRationEase(float ratio, easeType Type)
{
	switch(Type)
	{
		// End:0x2A
		case IN_STRONG:
			return easeInStrong(ratio, 0.0, 1.0, 1.0);
			// End:0x132
			break;
		// End:0x4D
		case OUT_STRONG:
			return easeOutStrong(ratio, 0.0, 1.0, 1.0);
			// End:0x132
			break;
		// End:0x70
		case INOUT_STRONG:
			return easeInOutStrong(ratio, 0.0, 1.0, 1.0);
			// End:0x132
			break;
		// End:0x93
		case IN_BOUNCE:
			return easeInBounce(ratio, 0.0, 1.0, 1.0);
			// End:0x132
			break;
		// End:0xB6
		case OUT_BOUNCE:
			return easeOutBounce(ratio, 0.0, 1.0, 1.0);
			// End:0x132
			break;
		// End:0xD9
		case INOUT_BOUNCE:
			return easeInOutBounce(ratio, 0.0, 1.0, 1.0);
			// End:0x132
			break;
		// End:0xFC
		case IN_ELASTIC:
			return easeInElastic(ratio, 0.0, 1.0, 1.0);
			// End:0x132
			break;
		// End:0x11F
		case OUT_ELASTIC:
			return easeOutElastic(ratio, 0.0, 1.0, 1.0);
			// End:0x132
			break;
		// End:0x127
		case INOUT_ELASTIC:
			// End:0x132
			break;
		// End:0x12F
		case EASENONE:
			// End:0x132
			break;
		// End:0xFFFF
		default:
			break;
	}
	return ratio;
}

function float easeInElastic(float t, float B, float C, float D, optional float A, optional float P)
{
	local float S;
	local float PI2;

	PI2 = 2.0 * Pi;
	if(t == 0)
	{
		return B;
	}
	if((t /= D)== 1)
	{
		return B + C;
	}
	if(P != 0)
	{
		P = D * 0.30;
	}
	if(A != 0 || A < GetAbs(int(C)))
	{
		A = C;
		S = P / 4;
	} else {
		S = P / PI2 * Asin(C / A);
	}
	return -A * ExpFloat(10.0 *(t -= 1),2)* Sin((t * D - S)* PI2 / P)+ B;
}

function float easeOutElastic(float t, float B, float C, float D, optional float A, optional float P)
{
	local float S;
	local float PI2;

	PI2 = 2.0 * Pi;
	if(t == 0)
	{
		return B;
	}
	if((t /= D) == 1)
	{
		return B + C;
	}
	if(P != 0)
	{
		P = D * 0.30;
	}
	if(A != 0 || A < GetAbs(int(C)))
	{
		A = C;
		S = P / 4;
	} else {
		S = (P / PI2) * Asin(C / A);
	}
	return A * ExpFloat(2.0, -10 * t)* Sin((t * D - S)* PI2 / P)+ C + B;
}

function float easeOutBounce(float t, float B, float C, float D)
{
	if((t /= D)< 1 / 2.75)
	{
		return (C * (7.5625 * t) * t) + B;
	}
	else if(t < 2 / 2.75)
	{
		return (C *(7.5625 *(t -= 1.5 / 2.75)* t + 0.75)) + B;
	}
	else if(t < 2.5 / 2.75)
	{
		return (C *(7.5625 *(t -= 2.25 / 2.75)* t + 0.9375)) + B;
	}
	else
	{
		return (C *(7.5625 *(t -= 2.625 / 2.75)* t + 0.984375)) + B;
	}
}

function float easeInBounce(float t, float B, float C, float D)
{
	return C - easeOutBounce(D - t, 0.0, C, D)+ B;
}

function float easeInOutBounce(float t, float B, float C, float D)
{
	if(t < D / 2)
	{
		return (easeInBounce(t * 2, 0.0, C, D)* 0.5) + B;
	}
	else
	{
		return easeOutBounce((t * 2) - D, 0.0, C, D)* 0.5 + (C * 0.5) + B;
	}
}

function float easeInOutStrong(float t, float B, float C, float D)
{
	if((t /= D / 2)< 1)
	{
		return C / 2 * t * t * t * t * t + B;
	}
	return C / 2 *((t -= 2)* t * t * t * t + 2)+ B;
}

function float easeOutStrong(float t, float B, float C, float D)
{
	t = t - 1;
	return ExpFloat(t, 5) + 1;
}

function float easeInStrong(float t, float B, float C, float D)
{
	return ExpFloat(t, 5);
}

defaultproperties
{
}
