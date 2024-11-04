//================================================================================
// FestivalSubWnd.
// emu-dev.ru
//================================================================================
class FestivalSubWnd extends UICommonAPI
	dependson(FestivalWnd);

const TIMER_ID = 1010122;

var WindowHandle Me;
//var WindowHandle FestivalInnerWnd;
var ButtonHandle HelpButton;

var ItemWindowHandle GoldItemWindow;
var TextBoxHandle GoldText;
var TextBoxHandle GoldNumberText;

var TextureHandle FestivalProgressIcon;
var TextBoxHandle TimeNumberText;
var ButtonHandle ParticipationBtn;

var AnimTextureHandle BlinkAni;

var FestivalWnd FestivalWndScript;

var int nIsUseFestival;    //  0 �佺Ƽ�� ����, 1 �佺Ƽ�� ������, 2 �佺Ƽ�� �̺�Ʈ�� ���� �������� �̺�Ʈ ��ǰ�� ��� ����.
var int FestivalID;        // �̺�Ʈ ���̵�
//var int FestivalStartTime; // �̹�ȸ�� ���۱��� ���� �ð� (second)
var int FestivalEndTime;   // �̹�ȸ�� ������� ���� �ð� (second)

var int remainSecond;

// �����̴� �ִ� ��� �߳�
var bool isFirstNoticeAnim;

function OnRegisterEvent()
{
}

function OnLoad()
{
	Initialize();
	Load();
}

function NoticeAniPlay()
{
	isFirstNoticeAnim = true;
	BlinkAni.Stop();
	BlinkAni.ShowWindow();
	BlinkAni.SetLoopCount(7);
	BlinkAni.Play();
}

function OnHide()
{
	BlinkAni.Stop();
	BlinkAni.HideWindow();
	isFirstNoticeAnim = false;
}

function Initialize()
{
	FestivalWndScript = FestivalWnd(GetScript("FestivalWnd"));

	Me = GetWindowHandle("FestivalSubWnd");

	//FestivalInnerWnd = GetWindowHandle( "FestivalSubWnd.FestivalInnerWnd" );

	HelpButton = GetButtonHandle("FestivalSubWnd.FestivalInnerWnd.HelpButton");
	GoldText = GetTextBoxHandle("FestivalSubWnd.FestivalInnerWnd.GoldText");
	GoldNumberText = GetTextBoxHandle("FestivalSubWnd.FestivalInnerWnd.GoldNumberText");
	FestivalProgressIcon = GetTextureHandle("FestivalSubWnd.FestivalInnerWnd.FestivalProgressIcon");
	TimeNumberText = GetTextBoxHandle("FestivalSubWnd.FestivalInnerWnd.TimeNumberText");
	ParticipationBtn = GetButtonHandle("FestivalSubWnd.FestivalInnerWnd.ParticipationBtn");
	GoldItemWindow = GetItemWindowHandle("FestivalSubWnd.FestivalInnerWnd.GoldItemWindow");
	BlinkAni = GetAnimTextureHandle("FestivalSubWnd.BlinkAni");
}

function Load()
{
}

function OnEvent(int Event_ID, string param)
{
	if(Event_ID == EV_RESTART)
	{
		Me.KillTimer(TIMER_ID);

		GoldItemWindow.DisableWindow();
		isFirstNoticeAnim = false;
	}
	else if(Event_ID == EV_FestivalTopItemInfo)
	{
		Debug("-----  EV_FestivalTopItemInfo" @ param);
		SetFestivalTopItemInfo(param);
		updateUI();
	}
}

function int getFestivalEndTime()
{
	return FestivalEndTime;
}

function updateUI()
{
	// ������ ���� ���ΰ�?
	if(nIsUseFestival == 1)
	{
		TimeNumberText.SetText(GetSecToTimeStr(FestivalEndTime));
		TimeNumberText.SetTooltipText(GetSystemString(5202));// ���� �����ð�

		//remainSecond = FestivalEndTime;

		FestivalProgressIcon.SetTexture("L2UI_CT1.FestivalWnd_GreenDot");
		FestivalProgressIcon.SetTooltipText(GetSystemString(5200)); // ������

		ParticipationBtn.EnableWindow();

		Me.ShowWindow();
	}
	// ���� ���� ������..�Ѿ�� ���� ���� �ð������ִ� ���� (��� �ߴ� ����)
	else if(nIsUseFestival == 2)
	{
		TimeNumberText.SetText(GetSecToTimeStr(FestivalEndTime));
		TimeNumberText.SetTooltipText(GetSystemString(5203)); // ����ȸ������
		//remainSecond = FestivalStartTime;

		// ���� �Ұ�
		FestivalProgressIcon.SetTexture("L2UI_CT1.FestivalWnd_GrayDot");
		FestivalProgressIcon.SetTooltipText(GetSystemString(5201)); // ������

		ParticipationBtn.EnableWindow();

		GoldItemWindow.DisableWindow();

		Me.ShowWindow();
	}
	// �̺�Ʈ ���� ����
	else
	{
		// ��� UI ����
		Me.KillTimer(TIMER_ID);
		Me.HideWindow();
		GetWindowHandle("FestivalWnd").HideWindow();
	}
}

function SetFestivalTopItemInfo(string param)
{
	local int ListCount, newFestivalID, Grade, ItemID, RemainItemNum, MAXITEMNUM, i;

	local ItemInfo Info;

	ParseInt(param, "IsUseFestival", nIsUseFestival);
	ParseInt(param, "ListCount", ListCount);
	ParseInt(param, "FestivalID", newFestivalID);
	ParseInt(param, "FestivalEndTime", FestivalEndTime);

	//Parseint(Param, "TicketItemID", TicketItemID);
	//Parseint(Param, "TicketItemNum", TicketItemNum);

	i = 0;
	ParseInt(param, "Grade" $ i, Grade);   // 1�� ���� ���
	ParseInt(param, "itemID" $ i, ItemID);
	ParseInt(param, "MaxItemNum" $ i, MAXITEMNUM);
	ParseInt(param, "RemainItemNum" $ i, RemainItemNum);

	Info = GetItemInfoByClassID(ItemID);

	GoldText.SetText(makeShortStringByPixel(Info.Name, 157, ".."));
	GoldNumberText.SetText(RemainItemNum $ "/" $ MAXITEMNUM);

	GoldItemWindow.Clear();
	GoldItemWindow.AddItem(Info);

	if(RemainItemNum > 0)
	{
		GoldItemWindow.EnableWindow();
	}
	else
	{
		GoldItemWindow.DisableWindow();
	}

	Me.KillTimer(TIMER_ID);
	Me.SetTimer(TIMER_ID, 1000);

	// ���� �϶�� ������ �ִ� ǥ��
	if(nIsUseFestival == 1 && isFirstNoticeAnim)
	{
		NoticeAniPlay();
	}
}

function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID)
	{
		FestivalEndTime = FestivalEndTime - 1;

		if(FestivalEndTime <= 0)
		{
			FestivalEndTime = 0;
			Me.KillTimer(TIMER_ID);
			ParticipationBtn.DisableWindow();
		}
		else
		{
			ParticipationBtn.EnableWindow();
		}

		TimeNumberText.SetText(GetSecToTimeStr(FestivalEndTime));
		FestivalWndScript.UpdateTime();
	}
}

function string GetSecToTimeStr(int Sec)
{
	local string returnStr;
	local int m_timeHour, m_timeMin;

	m_timeHour = (Sec / 60 / 60);		// ��
	m_timeMin = (Sec / 60) % 60;		// ��
	// m_timeSec = remainSec % 60;	// ��

	// debug(" m_timeHour : " $ m_timeHour $ "m_timeMin : "  $ m_timeMin$ "m_timeSec : "  $ m_timeSec);	
	returnStr = "";

	// �ø� �׷��ش�.
	if(m_timeHour > 0)
	{
		if(m_timeHour < 10)
		{
			returnStr = returnStr $ "0" $ string(m_timeHour);
		}
		else
		{
			returnStr = returnStr $ string(m_timeHour);
		}		
	}
	else
	{
		returnStr = returnStr $ "00";
	}

	// ��
	if(m_timeMin > 0)
	{
		if(m_timeMin < 10)
		{
			returnStr = returnStr $ ":0" $ string(m_timeMin);
		}
		else
		{
			returnStr = returnStr $ ":" $ string(m_timeMin);
		}		
	}
	else
	{
		returnStr = returnStr $ ":00";
	}
	return returnStr;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "HelpButton":
			OnHelpButtonClick();
			break;
		case "ParticipationBtn":
			OnParticipationBtnClick();
			break;
	}
}

// ���� ����
function OnHelpButtonClick()
{
	local string strParam;
	local HelpHtmlWnd script;

	script = HelpHtmlWnd(GetScript("HelpHtmlWnd"));
	ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "festival_help001.htm");
	script.HandleShowHelp(strParam);
}

function OnParticipationBtnClick()
{
	if(GetWindowHandle("FestivalWnd").IsShowWindow() == false)
	{
		RequestFestivalInfo(true);
	}
	toggleWindow("FestivalWnd", true, true);
}

defaultproperties
{
}
