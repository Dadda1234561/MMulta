class L2UITimer extends UIScript;

var private array<L2UITimerObject> timerObjects;
var private int lastTimerID;
var private array<int> returnedIndex;

static function L2UITimer Inst()
{
	return L2UITimer(GetScript("L2UITimer"));
}

function L2UITimerObject _AddTimer(optional int Time, optional int maxCount)
{
	local L2UITimerObject timerObject;

	timerObject = _AddNewTimerObject(Time, maxCount, 0, false);
	_Play(timerObject._timerID);
	return timerObject;
}

function L2UITimerObject _AddNewTimerObject(optional int Time, optional int maxCount, optional int Delay, optional bool isKillOnEnd)
{
	local int Len;

	// End:0x16
	if(Time == 0)
	{
		Time = 1000;
	}
	Len = timerObjects.Length;
	timerObjects[Len] = new class'L2UITimerObject';
	timerObjects[Len]._time = Time;
	timerObjects[Len]._timerID = GetEmptyTimerID();
	timerObjects[Len]._isKillOnEnd = isKillOnEnd;
	timerObjects[Len]._delay = Delay;
	// End:0xC6
	if(maxCount == 0)
	{
		timerObjects[Len]._maxCount = 1;		
	}
	else
	{
		timerObjects[Len]._maxCount = maxCount;
	}
	return timerObjects[Len];
}

function bool _Play(int TimerID)
{
	local int Index;
	local L2UITimerObject timerObject;

	// End:0x17
	if(! FindIndex(TimerID, Index))
	{
		return false;
	}
	timerObject = timerObjects[Index];
	m_hOwnerWnd.KillTimer(timerObject._timerID);
	// End:0x87
	if(timerObject._delay == 0)
	{
		m_hOwnerWnd.SetTimer(timerObject._timerID, timerObject._time);		
	}
	else
	{
		m_hOwnerWnd.SetTimer(timerObject._timerID, timerObject._delay);
	}
	return true;
}

function bool _Pause(int TimerID)
{
	local int Index;

	// End:0x17
	if(! FindIndex(TimerID, Index))
	{
		return false;
	}
	m_hOwnerWnd.KillTimer(timerObjects[Index]._timerID);
	return true;
}

function bool _Stop(int TimerID)
{
	local int Index;

	// End:0x17
	if(! FindIndex(TimerID, Index))
	{
		return false;
	}
	m_hOwnerWnd.KillTimer(timerObjects[Index]._timerID);
	timerObjects[Index]._curCount = 0;
	return true;
}

function bool _Kill(int TimerID)
{
	local int Index;

	// End:0x17
	if(! FindIndex(TimerID, Index))
	{
		return false;
	}
	KillWithIndex(Index);
	return true;
}

function _KillAllTimer(optional bool isKillALll)
{
	local int i;

	// End:0x51 [Loop If]
	for(i = 0; i < timerObjects.Length; i++)
	{
		m_hOwnerWnd.KillTimer(timerObjects[i]._timerID);
		timerObjects[i] = none;
	}
	timerObjects.Length = 0;
	returnedIndex.Length = 0;
	lastTimerID = 0;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_Restart);	
}

event OnEvent(int eID, string param)
{
	switch(eID)
	{
		case EV_Restart:
			Clears();
			break;
	}	
}

private function Clears()
{
	local int i, Len;

	Len = timerObjects.Length;
	returnedIndex.Length = 0;

	// End:0xB8 [Loop If]
	for(i = Len; i >= 0; i--)
	{
		m_hOwnerWnd.KillTimer(timerObjects[i]._timerID);
		timerObjects[i]._curCount = 0;
		// End:0xAE
		if(timerObjects[i]._isKillOnEnd)
		{
			ReturnTimerID(timerObjects[i]._timerID);
			timerObjects[i] = none;
			timerObjects.Remove(i, 1);
		}
	}
}

event OnTimer(int TimerID)
{
	local int Index;
	local L2UITimerObject timerObject;

	// End:0x17
	if(! FindIndex(TimerID, Index))
	{
		return;
	}
	timerObject = timerObjects[Index];
	// End:0xBD
	if(timerObject._delay > 0)
	{
		timerObject._delay = 0;
		m_hOwnerWnd.KillTimer(timerObject._timerID);
		m_hOwnerWnd.SetTimer(timerObject._timerID, timerObject._time);
		return;
	}
	// End:0xBB
	if(timerObject._curCount == 0)
	{
		timerObject._DelegateOnStart();
	}
	timerObject._DelegateOnTime(timerObject._curCount);
	timerObject._curCount++;
	// End:0x173
	if(timerObject._curCount == timerObject._maxCount)
	{
		// End:0x156
		if(timerObject._isKillOnEnd)
		{
			KillWithIndex(Index);			
		}
		else
		{
			m_hOwnerWnd.KillTimer(timerObject._timerID);
		}
		timerObject._DelegateOnEnd();
	}
}

private function int GetEmptyTimerID()
{
	local int TimerID;

	// End:0x27
	if(returnedIndex.Length > 0)
	{
		TimerID = returnedIndex[0];
		returnedIndex.Remove(0, 1);
		return TimerID;
	}
	lastTimerID++;
	return lastTimerID - 1;
}

private function ReturnTimerID(int TimerID)
{
	returnedIndex[returnedIndex.Length] = TimerID;
}

private function KillWithIndex(int Index)
{
	m_hOwnerWnd.KillTimer(timerObjects[Index]._timerID);
	ReturnTimerID(timerObjects[Index]._timerID);
	timerObjects.Remove(Index, 1);
}

private function bool FindIndex(int TimerID, out int Index)
{
	local int i;

	// End:0x4C [Loop If]
	for(i = 0; i < timerObjects.Length; i++)
	{
		// End:0x42
		if(timerObjects[i]._timerID == TimerID)
		{
			Index = i;
			return true;
		}
	}
	return false;
}

private function bool FindTimerObject(int TimerID, out L2UITimerObject timerObject)
{
	local int Index;

	// End:0x17
	if(! FindIndex(TimerID, Index))
	{
		return false;
	}
	timerObject = timerObjects[Index];
	return true;
}

defaultproperties
{
}
