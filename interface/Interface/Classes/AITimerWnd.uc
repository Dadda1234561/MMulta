class AITimerWnd extends UIScript;


/**
 * GFX�� �ٲ�鼭 ������ ����
 * 2010.10.22 ������ 
 */

//~ const MAX_GAME_TIME_MIN = 20;
const TIMER_ID_COUNTDOWN=2025;
const TIMER_ID_COUNTUP=2026;// Ÿ�̸ӾƵ� ���� ����� ���� �ʳ� ???
const TIMER_DELAY=1000;

var WindowHandle Me, MEBtn;
var TextBoxHandle txtAITimerObject, MinTxt, SecTxt, DividerTxt;
var int UserID, EventID, ASK, Reply, Min, Sec, CurMin, CurSec, TargetMin, TargetSec;
var int TempMin, TempSec;
var string param1, param2, param3, param4, param5, param6;
var string MinStr, SecStr;
var bool m_InGameBool;

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		Me 	= 		GetHandle("AITimerWnd");
		MinTxt	= 	TextBoxHandle(GetHandle("AITimerWnd.MinTxt"));
		SecTxt	=	TextBoxHandle(GetHandle("AITimerWnd.SecTxt"));
		DividerTxt 	= 	TextBoxHandle(GetHandle("AITimerWnd.DividerTxt"));
		txtAITimerObject = TextBoxHandle(GetHandle("AITimerWnd.txtAITimerObject"));
	}
	else
	{
		Me 	= 		GetWindowHandle("AITimerWnd");
		MinTxt	= 	GetTextBoxHandle("AITimerWnd.MinTxt");
		SecTxt	=	GetTextBoxHandle("AITimerWnd.SecTxt");
		DividerTxt 	= 	GetTextBoxHandle("AITimerWnd.DividerTxt");
		txtAITimerObject = GetTextBoxHandle("AITimerWnd.txtAITimerObject");
	}
}

function OnRegisterEvent()
{
	RegisterEvent(EV_AITimer);
}


function OnEvent(int Event_ID, string param)
{
	//~ local int StatusInt;
	switch(Event_ID)
	{
		case EV_AITimer:
		//debug ("AITimerEvent" @ Param);
		HandleAIController(Param);
		break;
		

		
	}
}

//ī��Ʈ�� �� �ҷ����� ������ ���� �׿��� �Ѵ�.

function HandleAIController(string Param)
{
	local string Param1, Param2, Param3, Param4;
	local int EventID;
	
	//Debug("How Param composed of :" @ Param);
	ParseString(Param, "Param1", Param1);	//ī��Ʈ�ٿ����� ������	
	ParseString(Param, "Param2", Param2); //ī��Ʈ �����ϴ� ��?
	ParseString(Param, "Param3", Param3); //ī��Ʈ �����ϴ� ��
	ParseString(Param, "Param4", Param4); //�����ִ� ��Ʈ��
	ParseString(Param, "Param5", Param5); //ī��Ʈ ����Ǵ� ��?
	ParseString(Param, "Param6", Param6); //ī��Ʈ ����Ǵ� ��
	Parseint(Param, "EventID", EventID) ;   //�̺�Ʈ ���̵� - �� �̺�Ʈ���̵�� ����/����/�Ͻ�����/�Ͻ����� �� �ٽ� �������� �Ǵ�

	Min = 0;
	Sec = 0;
	CurMin = 0;
	CurSec = 0;
	TargetMin = 0;
	TargetSec = 0;
	
	if (EventID== 0)
	{
		switch (Param1)
		{
			case "0":
				//Debug("Startcountdown" @ Param);
				Me.KillTimer( TIMER_ID_COUNTDown );
				StartCountDown(int(Param2), int(Param3), Param4, int(Param5), int(Param6));
			break;
			case "1":
				Me.KillTimer( TIMER_ID_COUNTUP );
				StartCountUp(int(Param2), int(Param3), Param4 , int(Param5), int(Param6));
			break;
		}
	}
	else if (EventID == 1) // ����
	{
		switch (Param1)
		{
			case "0":
				MinTxt.HideWindow();
				SecTxt.HideWindow();
				DividerTxt.HideWindow();
				txtAITimerObject.HideWindow();
				Me.KillTimer( TIMER_ID_COUNTDown );
			break;
			case "1":

				MinTxt.HideWindow();
				SecTxt.HideWindow();
				DividerTxt.HideWindow();
				txtAITimerObject.HideWindow();
				Me.KillTimer( TIMER_ID_COUNTUP );
			break;
		}
		
		//LaunchTimer(Param1, Param4);
		
	
	}
	/*
	else if (EventID == 2) // �Ͻ� ����
	{

		TempMin = Min ;
		TempSec = Sec ;
		Me.KillTimer( TIMER_ID_COUNTDOWN );
				
				
	}
	
	else if (EventID == 3) // �Ͻ� ���� �� �ٽ� ����
	{
		switch (Param1)
		{
			case "0":				
				Min = TempMin ;
				Sec = TempSec + 1 ;
				//Me.KillTimer( TIMER_ID_COUNTDOWN );
				TimerReset( Min,  Sec);
				//txtAITimerObject.SetText(strDisplayTxt);
				Me.ShowWindow();
				Me.SetTimer(TIMER_ID_COUNTDOWN,TIMER_DELAY);
				
			break;
			case "1":
				
				CurMin = TempMin ;
				CurSec = TempSec - 1;
				//Me.KillTimer( TIMER_ID_COUNTUP );
				TimerReset(CurMin, CurSec);
				//txtAITimerObject.SetText(strDisplayTxt);
				Me.ShowWindow();
				Me.SetTimer(TIMER_ID_COUNTUP,TIMER_DELAY);


				
			break;
		}
		//ResumeTimer();
	}
	*/
}

/*function LaunchTimer(string TimerID,string strDisplayTxt)      //�ð� �ʱ�ȭ �ϰ� �����ִ� ��
{
	if (TimerID == "0")
	{
	    	TimerReset( MIn,  Sec);
		txtAITimerObject.SetText(strDisplayTxt);
	}
	
	else if (TimerID == "1")
	{
		TimerReset(0, 0);
		txtAITimerObject.SetText(strDisplayTxt);
		
	}
	
	
}*/

/*function PauseTimer(int Min, int Sec) 
{
	if (EventID == 2)
	{
		Min = Min;
		Sec = Sec;
		Me.KillTimer( TIMER_ID_COUNTUP );
		Me.KillTimer( TIMER_ID_COUNTDOWN );
	}
}*/

function OnTimer(int TimerID) 
{
	//Debug("Min" @min @ "Sec" @ Sec);
	if(TimerID == TIMER_ID_COUNTDOWN)
	{
		//Debug("TimerCOUNTDOWN");
		if (Min == TargetMin && Sec < 10)
		{
			MinTxt.HideWindow();
			SecTxt.HideWindow();
			DividerTxt.HideWindow();
			txtAITimerObject.HideWindow();
			Me.KillTimer( TIMER_ID_COUNTDOWN );
		}
		else
		{
			txtAITimerObject.ShowWindow();
			MinTxt.ShowWindow();
			SecTxt.ShowWindow();
			DividerTxt.ShowWindow();
			UpdateTimerCountDown();
		}
	}
	
	else if (TimerID == TIMER_ID_COUNTUP)
	{
		//Debug("TimerCOUNTUP");
		if(TargetSec < 11)
			{	
			 Debug("TargetMin"@TargetMin@"Min"@ Min @ "Sec"@ Sec);
			if (Min == TargetMin -1 && ((TargetSec+60)-Sec) < 10)
			
				{
					MinTxt.HideWindow();
					SecTxt.HideWindow();
					DividerTxt.HideWindow();
					txtAITimerObject.HideWindow();
					Me.KillTimer( TIMER_ID_COUNTUP );
				}
			else
				{
					txtAITimerObject.ShowWindow();
					MinTxt.ShowWindow();
					SecTxt.ShowWindow();
					DividerTxt.ShowWindow();
					UpdateTimerCountUp();
				}
		}
		
		
		else
		{
			if (Min == TargetMin && (TargetSec-Sec) < 10)
			{
				MinTxt.HideWindow();
				SecTxt.HideWindow();
				DividerTxt.HideWindow();
				txtAITimerObject.HideWindow();
				Me.KillTimer( TIMER_ID_COUNTUP );
			}
			else
			{
				txtAITimerObject.ShowWindow();
				MinTxt.ShowWindow();
				SecTxt.ShowWindow();
				DividerTxt.ShowWindow();
				UpdateTimerCountUp();
			}
		}
		

	}
}

function UpdateTimerCountDown()   //�ð��� ī��Ʈ �ٿ� ������Ʈ �����ش�
{
	MinStr = String(Min);
	SecStr = String(Sec);
		
	if (Min < 10)
		MinStr = "0" $ MinStr;
	
	if (Sec < 10)
		SecStr = "0" $ SecStr;
	
	MinTxt.SetText(MinStr);
	SecTxt.SetText(SecStr);
	
	if (Sec == 0)
	{
		Sec = 59;
		Min = Min -1;
	} 
	else 
	{
		Sec = Sec -1;
	}
}

function UpdateTimerCountUp()   //�ð��� ī���� �� ������Ʈ �����ش�
{
	MinStr = String(Min);
	SecStr = String(Sec);
		
	if (Min < 10)
		MinStr = "0" $ MinStr;
	
	if (Sec < 10)
		SecStr = "0" $ SecStr;
	
	MinTxt.SetText(MinStr);
	SecTxt.SetText(SecStr);
	
	if (Sec == 59)
	{
		Sec = 0;
		Min = Min +1;
	} 
	else 
	{
		Sec = Sec +1;
	}
}

function TimerReset(int CurMin, int CurSec)
{
	//~ Min = MAX_GAME_TIME_MIN;
	//Sec = 0;
	Min = CurMin;
	Sec = CurSec;
	
	MinStr = String(Min);
	SecStr = String(Sec);
	
	if (Min < 10)
		MinStr = "0" $ MinStr;
	
	if (Sec < 10)
		SecStr = "0" $ SecStr;
	MinTxt.SetText(MinStr);
	SecTxt.SetText(SecStr);
	m_InGameBool = true;
}


function StartCountDown(int CurMin, int CurSec, string strDisplayTxt , int TMin , int TSec)
{	
    CurMin = CurMin ;
	CurSec = CurSec ;
	TargetMin = TMin;
	TargetSec = TSec;
	
	TimerReset( CurMin,  CurSec);

	txtAITimerObject.SetText(strDisplayTxt);

	Me.ShowWindow();
	//debug("Startcountdown"@ TIMER_ID_COUNTDOWN);
	Me.SetTimer(TIMER_ID_COUNTDOWN,TIMER_DELAY);
}


function StartCountUp(int CurMin, int CurSec, string strDisplayTxt , int TMin , int TSec)
{
    CurMin = CurMin ;
	CurSec = CurSec ;
	TargetMin = TMin;
	TargetSec = TSec;
	
	Debug("TargetMin"@TargetMin);
	TimerReset(CurMin, CurSec);
	txtAITimerObject.SetText(strDisplayTxt);
	Me.ShowWindow();
	Me.SetTimer(TIMER_ID_COUNTUP,TIMER_DELAY);
}

function OnHide()
{
	Me.KillTimer( TIMER_ID_COUNTUP );
	Me.KillTimer( TIMER_ID_COUNTDOWN );
}

defaultproperties
{
}