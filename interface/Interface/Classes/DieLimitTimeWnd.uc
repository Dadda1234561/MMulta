class DieLimitTimeWnd extends UICommonAPI;

var WindowHandle Me;
var string m_WindowName;
var L2UITimerObject uiTimer;
var int TimerNum;
var TextBoxHandle DieLimitTime_txt;

event OnRegisterEvent()
{
	RegisterEvent(EV_RestartMenuHide);
	RegisterEvent(EV_TimeRestrictFieldExit);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_TIME_RESTRICT_FIELD_DIE_LIMT_TIME);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_FIELD_DIE_LIMT_TIME);
}

event OnLoad()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	DieLimitTime_txt = GetTextBoxHandle(m_WindowName $ ".DieLimitTime_txt");
	uiTimer = class'L2UITimer'.static.Inst()._AddNewTimerObject();
	uiTimer._DelegateOnTime = HandleOnTime;
	uiTimer._DelegateOnEnd = HandleOnTimeEnd;
}

event OnEvent(int Event_ID, string param)
{
	// End:0x28
	if(Event_ID == EV_ProtocolBegin + class'UIPacket'.const.S_EX_TIME_RESTRICT_FIELD_DIE_LIMT_TIME)
	{
		Handle_S_EX_TIME_RESTRICT_FIELD_DIE_LIMT_TIME();		
	}
	// End:0x4D
	if(Event_ID == EV_ProtocolBegin + class'UIPacket'.const.S_EX_FIELD_DIE_LIMT_TIME)
	{
		Handle_S_EX_FIELD_DIE_LIMT_TIME();		
	}
	else if(Event_ID == EV_RestartMenuHide || Event_ID == EV_TimeRestrictFieldExit)
	{
		Me.HideWindow();
		uiTimer._Stop();
	}
}

function Handle_S_EX_FIELD_DIE_LIMT_TIME()
{
	local UIPacket._S_EX_FIELD_DIE_LIMT_TIME packet;
	local int times;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_FIELD_DIE_LIMT_TIME(packet))
	{
		return;
	}
	Debug("_S_EX_FIELD_DIE_LIMT_TIME, nDieLimitTime : " @ string(packet.nDieLimitTime));
	times = packet.nDieLimitTime;
	TimerNum = times;
	DieLimitTime_txt.SetText(getInstanceL2Util().TimeNumberToString(TimerNum));
	Me.ShowWindow();
	uiTimer._maxCount = times;
	uiTimer._Play();	
}

function Handle_S_EX_TIME_RESTRICT_FIELD_DIE_LIMT_TIME()
{
	local UIPacket._S_EX_TIME_RESTRICT_FIELD_DIE_LIMT_TIME packet;
	local int times;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_TIME_RESTRICT_FIELD_DIE_LIMT_TIME(packet))
	{
		return;
	}
	times = packet.nDieLimitTime;
	TimerNum = times;
	DieLimitTime_txt.SetText(getInstanceL2Util().TimeNumberToString(TimerNum));
	Me.ShowWindow();
	uiTimer._maxCount = times;
	uiTimer._Play();
}

function HandleOnTime(int t)
{
	TimerNum = TimerNum - 1;
	DieLimitTime_txt.SetText(getInstanceL2Util().TimeNumberToString(TimerNum));
}

function HandleOnTimeEnd()
{
	Me.HideWindow();
	uiTimer._Stop();
}

function ShowHide(string Name)
{
	// End:0x2E
	if(class'UIAPI_WINDOW'.static.IsShowWindow(Name))
	{
		class'UIAPI_WINDOW'.static.HideWindow(Name);		
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow(Name);
		class'UIAPI_WINDOW'.static.SetFocus(Name);
	}
}

event OnHide()
{
	GetWindowHandle("RestartMenuWndOption").HideWindow();
}

defaultproperties
{
     m_WindowName="DieLimitTimeWnd"
}
