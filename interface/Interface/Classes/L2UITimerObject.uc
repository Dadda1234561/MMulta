class L2UITimerObject extends UIEventManager;

var int _time;
var int _timerID;
var int _curCount;
var int _maxCount;
var int _delay;
var bool _isKillOnEnd;

delegate _DelegateOnStart()
{}

delegate _DelegateOnTime(int Count)
{}

delegate _DelegateOnEnd()
{}

function float _Position()
{
	return float(_curCount) / float(_maxCount);
}

function _Play(optional int Delay)
{
	// End:0x16
	if(Delay != 0)
	{
		_delay = Delay;
	}
	class'L2UITimer'.static.Inst()._Play(_timerID);
}

function _Pause()
{
	class'L2UITimer'.static.Inst()._Pause(_timerID);
}

function _Stop()
{
	class'L2UITimer'.static.Inst()._Stop(_timerID);
}

function _Kill()
{
	class'L2UITimer'.static.Inst()._Kill(_timerID);
}

function _Reset()
{
	class'L2UITimer'.static.Inst()._Stop(_timerID);
	class'L2UITimer'.static.Inst()._Play(_timerID);
}

defaultproperties
{
}
