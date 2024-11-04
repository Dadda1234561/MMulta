class L2UITweenObject extends UIEventManager;

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
var L2UITween.easeType ease;
var bool Paused;

delegate _DelegateOnStart();

delegate _DelegateOnUpdate(float Position);

delegate _DelegateOnEnd();

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
	class'L2UITween'.static.Inst().StopTween(Owner, Id);	
}

function _Reset()
{
	Paused = false;
	Position = 0.0f;	
}

defaultproperties
{
}
