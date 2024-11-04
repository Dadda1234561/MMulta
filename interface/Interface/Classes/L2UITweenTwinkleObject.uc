class L2UITweenTwinkleObject extends UIEventManager;

var WindowHandle Target;
var string Owner;
var float Position;
var float Duration;
var float Delay;
var float twinkleNum;
var bool Paused;
var int minAlpha;
var int maxAlpha;
var float gab;

delegate _DelegateOnStart();

delegate _DelegateOnUpdate(float Position);

delegate _DelegateOnEnd();

function float _Ratio()
{
	return Position / (Duration / 1000);	
}

function _SetRatio(float ratio)
{
	Position = ratio * (Duration / 1000);	
}

function float _Position()
{
	return Position;	
}

function _Play(optional int _delay)
{
	// End:0x18
	if(_delay != 0)
	{
		Delay = float(_delay);
	}
	Paused = false;	
}

function _Pause()
{
	Paused = true;	
}

function _Stop()
{
	Paused = true;
	Position = 0.0f;	
}

function _Kill()
{
	class'L2UITween'.static.Inst()._KillTwinkleWithWnd(Target);	
}

function _Reset()
{
	Paused = false;
	Position = 0.0f;	
}

defaultproperties
{
}
