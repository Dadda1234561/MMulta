class MovieCaptureWnd_Expand extends UICommonAPI;//ldw 2010.10.

var WindowHandle Me;
var ButtonHandle cBtn;
var WindowHandle m_Wnd;
//var ButtonHandle CloseButton;
var TextBoxHandle timer;
var int secInt; 

const TIMER_ID_COUNTUP=7069;// Ÿ�̸� ���̵� �ε� ���� �� ��� �ϴ� �� �𸣰���. �ϴ� ���°� ��.
const TIMER_DELAY=1000;//1��

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)//���ſ� �ҷ� �����°�?
	{
		//OnRegisterEvent();
	} else {
		timer	= 	TextBoxHandle(GetHandle("MovieCapturewnd_Expand.timer"));//�ð�
	}
	Initialize();
}
function Initialize()
{	
	Me = GetWindowHandle( "MovieCaptureWnd_Expand" );
	m_Wnd = GetWindowHandle( "MovieCaptureWnd" );
	cBtn = GetButtonHandle( "MovieCapturewnd_Expand.cBtn" );
	timer = GetTextBoxHandle("MovieCapturewnd_Expand.timer");	
}
function OnTimer(int TimerID) {
	if(TimerID == TIMER_ID_COUNTUP){
		secInt++;		
	}
	setTimeTxt();
}
function OnClickButton( string Name )
{	
	switch( Name )
	{
	case "cBtn":
		MovieCaptureToggle();
		//Debug("���߱�");
		break;
	/*case "CloseButton":
		MovieCaptureToggle();*/
	}
}
function string itoStr(int tmpNum){
	local string tmpStr;
	if(tmpNum<10){
		tmpStr = ("0"$string(tmpNum));
	} else 
	{		
		tmpStr = string(tmpNum);
	}	
	return tmpStr;
}
function setTimeTxt(){
	timer.SetText( itoStr(((secInt/60)/60)%60)$" : "$itoStr((secInt/60)%60)$" : "$itoStr(secInt%60));	
	///////////////////////////  ����� �� ���߿� ��ġ ��� �� �� /////////////////////////////////
	/*local int tmpHouInt;
	local int tmpMinInt;
	local int tmpSecInt;	
	
	tmpSecInt = secInt%60;
	tmpMinInt = (secInt/60)%60;
	tmpHouInt = ((secInt/60)/60)%60;

	Debug(tmpHouInt$"�� "$tmpMinInt$"�� "$tmpSecInt$"��");*/
	////////////////////////////////////////////////////////////////////////
}
function OnRegisterEvent()
{
	RegisterEvent(EV_MovieCaptureStarted);//ĸ�İ� ���� �Ǿ���
	RegisterEvent(EV_MovieCaptureEnded);//ĸ�İ� ���� �Ǿ���
	RegisterEvent(EV_MovieCaptureFailDiskSpace);//�뷮 �������� ĸ�� ���� ���� Ȥ�� ĸ�� ���� �ߴ�
}

function OnEvent(int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
		case EV_MovieCaptureStarted:
			secInt = 0;
			setTimeTxt();
			Me.SetTimer(TIMER_ID_COUNTUP,TIMER_DELAY);
			//Debug("ĸ�� ���� �̺�Ʈ_expand");
			break;
		case EV_MovieCaptureEnded:
			Me.KillTimer(TIMER_ID_COUNTUP);
			//Debug("ĸ�� �Ϸ� �̺�Ʈ_expand");
			break;
		case EV_MovieCaptureFailDiskSpace:
			Me.KillTimer(TIMER_ID_COUNTUP);
			//Debug("�뷮 ���� �̺�Ʈ_expand");
			break;		
	}
}

defaultproperties
{
}
