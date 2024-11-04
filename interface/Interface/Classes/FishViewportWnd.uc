class FishViewportWnd extends UICommonAPI;


const EFFECT_TIMER_ID=2;
const EFFECT_TIMER_DELAY=1000;
const STATUS_TIMER_ID=3;
const STATUS_TIMER_DELAY=0;

const REELING_TIMER_ID=5;
const PUMPING_TIMER_ID=4;
const PUMPING_TIMER_DELAY=80;

const FAKE_TIMER_ID=7;


var string m_WindowName;

var WindowHandle m_hFishViewportWnd;

var WindowHandle m_hPumpingIcon;
var TextBoxHandle m_hPumpingText;
var WindowHandle m_hReelingIcon;
var TextBoxHandle m_hReelingText;

var WIndowHandle m_hFishHPBarEffect;
var BarHandle m_hFishHPBar;
var BarHandle m_hFishHPBarFake;
var TextBoxHandle m_hTbSec;
var WindowHandle m_hTexClock;

var WindowHandle m_hWndStatus;
var TextBoxHandle m_hTbStatus;
var TextBoxHandle m_hTbDeltaHP;

var WindowHandle m_hFakeIcon;

var int m_OriginalFishHP;
var int m_OriginalFishTime;
var int m_CurrentFishHP;

var int m_PumpintTimerCount;

var int m_FakeTimerCount;

var int m_FishLevel;

var string m_FishState;

//���̴� ���� ������Ʈ ������ ������ ������
//var bool bShow;

function OnRegisterEvent()
{

}

function OnLoad()
{
	/*
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else*/

	InitHandleCOD();

	HideHPBarNEtc();

	m_hFishHPBarEffect.HideWindow();

	m_OriginalFishHP=0;
	m_FishState = "stanby";

	registerState( "FishViewportWnd", "GamingState" );	
}

/* ���̴� ���� ������Ʈ ���� 20130829 LDW
* ���̴� ���� ������Ʈ ������ ������ ������
function onEnterState ( name CurrentStateName  )
{	
	
	if ( CurrentStateName == 'ShaderBuildState' )	
	{
		//���̴� ���忡 ���Ծ��� �� 			
		if ( bShow ) 
		{
			m_hFishViewportWnd.ShowWindow();
			m_hFishViewportWnd.SetFocus();
		}
	}
}
*/
/*
function InitHandle()
{
	m_hPumpingIcon = GetHandle( m_WindowName$".texPumping" );
	m_hPumpingText = TextBoxHandle(GetHandle(m_WindowName$".txtPumping"));
	m_hReelingIcon = GetHandle( m_WindowName$".texReeling" );
	m_hReelingText = TextBoxHandle(GetHandle(m_WindowName$".txtReeling"));

	m_hFishHPBar = BarHandle(GetHandle( m_WindowName $ ".barFishHp" ));
	m_hFishHPBarFake= BarHandle(GetHandle( m_WindowName $ ".barFishHpFake" ));
	m_hFishHPBarEffect = GetHandle( m_WindowName$".wndEffect" );
	m_hFishViewportWnd = GetHandle( m_WindowName );
	m_hTbSec=TextBoxHandle(GetHandle(m_WindowName$".txtVarSec"));
	m_hTexClock=GetHandle(m_WindowName$".texClock");

	m_hWndStatus=GetHandle(m_WindowName$".wndStatus");
	m_hTbStatus=TextBoxHandle(GetHandle(m_WindowName$".wndStatus.txtVarStatus"));
	m_hTbDeltaHP=TextBoxHandle(GetHandle(m_WindowName$".wndStatus.txtVarDeltaHP"));

	m_hFakeIcon
}*/



function InitHandleCOD()
{
	m_hPumpingIcon = GetWindowHandle( m_WindowName$".texPumping" );
	m_hPumpingText = TextBoxHandle(GetWindowHandle(m_WindowName$".txtPumping"));
	m_hReelingIcon = GetWindowHandle( m_WindowName$".texReeling" );
	m_hReelingText = TextBoxHandle(GetWindowHandle(m_WindowName$".txtReeling"));

	m_hFishHPBar = GetBarHandle( m_WindowName $ ".barFishHp" );
	m_hFishHPBarFake= GetBarHandle( m_WindowName $ ".barFishHpFake" );
	m_hFishHPBarEffect = GetWindowHandle( m_WindowName$".wndEffect" );
	m_hFishViewportWnd = GetWindowHandle( m_WindowName );
	m_hTbSec=GetTextBoxHandle(m_WindowName$".txtVarSec");
	m_hTexClock=GetWindowHandle(m_WindowName$".texClock");

	m_hWndStatus=GetWindowHandle(m_WindowName$".wndStatus");
	m_hTbStatus=GetTextBoxHandle(m_WindowName$".wndStatus.txtVarStatus");
	m_hTbDeltaHP=GetTextBoxHandle(m_WindowName$".wndStatus.txtVarDeltaHP");

	m_hFakeIcon = GetWindowHandle( m_WindowName$".texFakeIcon" );
}

function OnEvent( int Event_ID, string param )
{}

function ShowHPBarNEtc(int ShowType, int Guts)
{
	m_hFishHPBar.ShowWindow();
	m_hTexClock.ShowWindow();
	m_hTbSec.ShowWindow();

	if(ShowType == 4) // ���� ����� ���̻� ǥ������ ����
	{
		m_hPumpingIcon.HideWindow();
		m_hPumpingText.HideWindow();
		m_hReelingIcon.HideWindow();
		m_hReelingText.HideWindow();
	}
	else if(m_FishLevel == 0)	// �ʺ� �����϶�
	{
		if(Guts == 0)	// �ټ� ���°� �ƴ� -> ����
		{
			m_hPumpingIcon.ShowWindow();
			m_hPumpingText.ShowWindow();
			m_hReelingIcon.HideWindow();
			m_hReelingText.HideWindow();

			if(m_FishState != "pumping")
			{
				m_hPumpingIcon.SetTimer(PUMPING_TIMER_ID, PUMPING_TIMER_DELAY);
				m_FishState = "pumping";
			}
		}
		else			// �ټ� ���� -> ����
		{
			m_hPumpingIcon.HideWindow();
			m_hPumpingText.HideWindow();
			m_hReelingIcon.ShowWindow();
			m_hReelingText.ShowWindow();
			if(m_FishState != "reeling")
			{
				m_hReelingIcon.SetTimer(REELING_TIMER_ID, PUMPING_TIMER_DELAY);
				m_FishState = "reeling";
			}
		}
	}
}

function HideHPBarNEtc()
{
	m_hFishHPBar.HideWindow();
	m_hFishHPBarFake.HideWindow();
	m_hTexClock.HideWindow();
	m_hTbSec.HideWindow();
	
	m_hPumpingIcon.HideWindow();
	m_hPumpingText.HideWindow();
	m_hReelingIcon.HideWindow();
	m_hReelingText.HideWindow();
}

function HandleInitFishStatus(string param)
{
	ParseInt(param, "OriginalFishHP", m_OriginalFishHP);
	ParseInt(param, "OriginalFishTime", m_OriginalFishTime);
	ParseInt(param, "FishLevel", m_FishLevel);
	m_CurrentFishHP=m_OriginalFishHP;
}

function HandleSetFishStatus(string param)
{
	local int FishHP;
	local int TimeCount;
	local int DeltaHP;
	local int ShowType;
	local int Guts;
	local int Effect;
	local int Penalty;
	local int Fake;

	ParseInt(param, "CurrentFishHP", FishHP);
	ParseInt(param, "TimeCount", TimeCount);
	ParseInt(param, "ShowType", ShowType);
	ParseInt(param, "Effect", Effect);
	ParseInt(param, "Guts", Guts);
	ParseInt(param, "Penalty", Penalty);
	ParseInt(param, "Fake", Fake);

	DeltaHP=FishHP-m_CurrentFishHP;

	// ShowType == 4 �̸� ���ü����̹Ƿ� �����HP�� �ð��� ������Ʈ�� �ʿ䰡 ����.

	if(ShowType!=4)
	{
		m_CurrentFishHP=FishHP;

		m_hFishHPBar.SetValue(m_OriginalFishHP*2, FishHP);
		m_hFishHPBarFake.SetValue(m_OriginalFishHP*2, FishHP);
		m_hTbSec.SetText(string(TimeCount));
	}


	ShowHPBarNEtc(ShowType, Guts);

	// ���� ������ 3�ʰ� ������ HP�ٿ� ����(�ʺ� ������� ���)�� �����ش�.
	if( !m_hFishHPBar.IsShowWindow() &&  (m_OriginalFishTime-TimeCount)>=3 )
	{
		ShowHPBarNEtc(ShowType, Guts);
	}

	if(ShowType==3)		// ��������
	{
		ShowFishString(1261, 0);
	}
	else if(ShowType == 4)	// ���ü���
	{
		ShowFishString(1264, 0);
	}

	if(m_hFishHPBar.IsShowWindow() || m_hFishHPBarFake.IsShowWindow())
	{
		if(Effect != 0)
		{
			ShowEffect();
		}
		if(ShowType == 1)
		{
			if(DeltaHP < 0)	// ���μ���
			{
				if(Penalty > 0)
					ShowFishStringWithPenalty(1672, DeltaHP, Penalty);
				else
					ShowFishString(1256, DeltaHP);
			}
			else				// ���ν���
				ShowFishString(1258, DeltaHP);
		}
		else if(ShowType == 2)
		{
			if(DeltaHP < 0)	// ��������
			{
				if(Penalty > 0)
					ShowFishStringWithPenalty(1671, DeltaHP, Penalty);
				else
					ShowFishString(1257, DeltaHP);
			}
			else				// ��������
				ShowFishString(1259, DeltaHP);
		}

		if(Fake!=0)
		{
			m_hFishHPBarFake.ShowWindow();
			m_hFishHPBar.HideWindow();
			m_hFakeIcon.HideWindow();

			//����� ������ ǥ��
			if ( m_FishLevel == 0 ) 
			{
				m_hFakeIcon.setTimer( FAKE_TIMER_ID, PUMPING_TIMER_DELAY );
				m_hFakeIcon.ShowWindow();
			}
			else
				m_hFakeIcon.HideWindow();
		}
		else
		{
			m_hFishHPBarFake.HideWindow();
			m_hFishHPBar.ShowWindow();
			m_hFakeIcon.HideWindow();
		}
	}
}

function ShowEffect()
{

	m_hFishHPBarEffect.ShowWindow();
	m_hFishHPBarEffect.SetTimer(EFFECT_TIMER_ID,EFFECT_TIMER_DELAY);	
}

function ShowFishString(INT StrID, INT DeltaHP)
{
	local color col;

	if(DeltaHP > 0)
	{
		col.R=255;
		col.G=0;
		col.B=0;
	}
	else
	{
		col.R=220;
		col.G=220;
		col.B=220;
	}

	m_hTbStatus.SetTextColor(col);
	m_hTbDeltaHP.SetTextColor(col);

	m_hTbStatus.SetText(GetSystemString(StrID));
	if(DeltaHP!=0)
		m_hTbDeltaHP.SetText(string(DeltaHP));
	else
		m_hTbDeltaHP.SetText("");


	m_hWndStatus.ShowWindow();
	m_hWndStatus.SetTimer(STATUS_TIMER_ID, STATUS_TIMER_DELAY);
}

function ShowFishStringWithPenalty(INT StrID, INT DeltaHP, INT Penalty)
{
	local color col;

	col.R=255;
	col.G=0;
	col.B=0;

	m_hTbStatus.SetTextColor(col);
	m_hTbDeltaHP.SetTextColor(col);

	m_hTbStatus.SetText(GetSystemMessageWithParamNumber(StrID, Penalty));
	if(DeltaHP!=0)
		m_hTbDeltaHP.SetText(string(DeltaHP));
	else
		m_hTbDeltaHP.SetText("");

	m_hWndStatus.ShowWindow();
	m_hWndStatus.SetTimer(STATUS_TIMER_ID, STATUS_TIMER_DELAY);	
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnRanking":
			break;
	}
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
	case FAKE_TIMER_ID :
		++m_FakeTimerCount;

		if(m_FakeTimerCount % 2 == 0)
		{
			m_hFakeIcon.ShowWindow();			
		}
		else if (m_FakeTimerCount % 2 == 1)
		{			
			m_hFakeIcon.HideWindow();			
		}

		if(m_FakeTimerCount> 2)
		{
			m_hFakeIcon.KillTimer(FAKE_TIMER_ID);			
			m_hFakeIcon.ShowWindow();
			m_FakeTimerCount = 0;
		}
		break;
	break;
	case EFFECT_TIMER_ID :
		m_hFishHPBarEffect.KillTimer(TimerID);
		m_hFishHPBarEffect.HideWindow();
		break;
	case STATUS_TIMER_ID :
		m_hWndStatus.Killtimer(TimerID);
		m_hWndStatus.HideWindow();
		break;
	case PUMPING_TIMER_ID:
		//Debug("���� ������");
		++m_PumpintTimerCount;

		if(m_PumpintTimerCount % 2 == 0)
		{
			m_hPumpingIcon.ShowWindow();
			m_hPumpingText.ShowWindow();
			m_hReelingIcon.HideWindow();
			m_hReelingText.HideWindow();
		}
		else if (m_PumpintTimerCount % 2 == 1)
		{
			m_hPumpingIcon.HideWindow();
			m_hPumpingText.HideWindow();
			m_hReelingIcon.HideWindow();
			m_hReelingText.HideWindow();
		}

		if(m_PumpintTimerCount> 2)
		{
			m_hPumpingIcon.KillTimer(PUMPING_TIMER_ID);
			m_PumpintTimerCount = 0;
			m_hPumpingIcon.ShowWindow();
			m_hPumpingText.ShowWindow();
		}
		break;
	case REELING_TIMER_ID:
		//Debug("���� ������");
		++m_PumpintTimerCount;

		if(m_PumpintTimerCount % 2 == 0)
		{
			m_hReelingIcon.ShowWindow();
			m_hReelingText.ShowWindow();
			m_hPumpingIcon.HideWindow();
			m_hPumpingText.HideWindow();
		}
		else if (m_PumpintTimerCount % 2 == 1)
		{	
			m_hReelingIcon.HideWindow();
			m_hReelingText.HideWindow();
			m_hPumpingIcon.HideWindow();
			m_hPumpingText.HideWindow();
		}

		if(m_PumpintTimerCount> 2)
		{
			m_hReelingIcon.KillTimer(REELING_TIMER_ID);
			m_PumpintTimerCount = 0;
			m_hReelingIcon.ShowWindow();
			m_hReelingText.ShowWindow();
		}
		break;
	}
}

function ClearTimer(int TimerID)
{
	if(TimerID == PUMPING_TIMER_ID)
	{
		m_hPumpingIcon.ShowWindow();
		m_hPumpingText.ShowWindow();
		m_FishState = "pumping";
	}
	if(TimerID == REELING_TIMER_ID)
	{
		m_hReelingIcon.ShowWindow();
		m_hReelingText.ShowWindow();
		m_FishState = "reeling";
	}
}

defaultproperties
{
     m_WindowName="FishViewportWnd"
}
