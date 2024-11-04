class MovieCaptureWnd extends UICommonAPI;//ldw ������ ĸ�� ��

/*
 *2010.10�� ����
 *���� ���� MovieCaptureWnd.xml
 *���� ���� MovieCapture_Expand.uc, MovieCaptureWnd_Expand.xml
 *������Ʈ ����
	aBtn : ĸ�� ���� ��ư
	bBtn : ���� ���� ��ư
	cBtn : ĸ�� ���� ��ư
	ComboBox1 : �ػ� �޺� �ڽ� �⺻ ���� 640*480
*/


var WindowHandle Me;
var WindowHandle m_hExpandWnd;
var ComboBoxHandle ComboBox1;
//var ComboBoxHandle ComboBox2;//ǰ���� ����� ���� ������ Ǯ�� �� ��.
//var TextBoxHandle NCTextBox1;
//var TextBoxHandle NCTextBox2;
var ButtonHandle aBtn;
var ButtonHandle bBtn;
var ButtonHandle CloseButton;
var TextureHandle backgroundtex1;
var TextBoxHandle NCTextBox;


const DIALOGID_OpenFolder = 7063;//���̾� �α� ���� ����
const DIALOGID_Diskisfull = 7064;//���̾� �α� �� �� ��ũ 


var Array<int>  ResolutionW; //ĸ�� W ����[640, 480]
var Array<int>  ResolutionH; //ĸ�� H ����[480, 320] 480*320���� �ٲ� 2011-03-10
//var Array<string>  Quality; //ĸ�� Q ����[High, Low]

//var bool IsCapturingFlag;//ĸ�� �ǰ� �ִ°�? IsNowMovieCapturing()�� ��ü �� ��.

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)//���ſ� �ҷ� �����°�?
	{
		OnRegisterEvent();
	}
	Initialize();
	Load();
}

function OnRegisterEvent()
{
	RegisterEvent(EV_MovieCaptureStarted);//ĸ�İ� ���� �Ǿ���
	RegisterEvent(EV_MovieCaptureEnded);//ĸ�İ� ���� �Ǿ���
	RegisterEvent(EV_MovieCaptureFailDiskSpace);//�뷮 �������� ĸ�� ���� ���� Ȥ�� ĸ�� ���� �ߴ�
	RegisterEvent(EV_DialogOK);//DialogOK �̺�Ʈ
	RegisterEvent(EV_DialogCancel);//DiaglogCancel �̺�Ʈ
	RegisterEvent(EV_Restart);//Restart �̺�Ʈ
}



function Initialize()
{
	Me = GetWindowHandle("MovieCaptureWnd");
	m_hExpandWnd = GetWindowHandle("MovieCaptureWnd_Expand");
	ComboBox1 = GetComboBoxHandle("MovieCaptureWnd.ComboBox1");
	//ComboBox2 = GetComboBoxHandle("MovieCaptureWnd.ComboBox2");
	//NCTextBox1 = GetTextBoxHandle("MovieCaptureWnd.NCTextBox1");
	//NCTextBox2 = GetTextBoxHandle("MovieCaptureWnd.NCTextBox2");
	CloseButton = GetButtonHandle("MovieCaptureWnd.CloseButton");
	aBtn = GetButtonHandle("MovieCaptureWnd.aBtn");
	bBtn = GetButtonHandle("MovieCaptureWnd.bBtn");
	//cBtn = GetButtonHandle("MovieCaptureWnd_Expand.cBtn");
	backgroundtex1 = GetTextureHandle("MovieCaptureWnd.backgroundtex1");
	NCTextBox = GetTextBoxHandle("MovieCaptureWnd.NCTextBox");
}

function Load()
{	
	//IsCapturingFlag = false;	
	local string Resolution1;
	local string Resolution2;

	ResolutionW[0] = GetDisplayWidth();
	ResolutionH[0] = GetDisplayHeight();
	ResolutionW[1] = ResolutionW[0] / 2;
	ResolutionH[1] = ResolutionH[0] / 2;
	ResolutionW[2] = 640;
	ResolutionH[2] = 480;
	ResolutionW[3] = 480;
	ResolutionH[3] = 320;
	SetMovieCaptureHighQuality();//�V���ϰ� default = "High"���� ����.
	SetMovieCaptureResolution(640, 480);//�V���ϰ� default = "640*480" ���� ����.	
	class'UIAPI_COMBOBOX'.static.AddString("MovieCaptureWnd.ComboBox1", GetSystemString(2452));//���� �ػ�
	class'UIAPI_COMBOBOX'.static.AddString("MovieCaptureWnd.ComboBox1", GetSystemString(2453));//���� �ػ� 
	Resolution1 = String(ResolutionW[2]) $ "X" $ string(ResolutionH[2]);
	Resolution2 = String(ResolutionW[3]) $ "X" $ string(ResolutionH[3]);
	class'UIAPI_COMBOBOX'.static.AddString("MovieCaptureWnd.ComboBox1",Resolution1);//640X480
	class'UIAPI_COMBOBOX'.static.AddString("MovieCaptureWnd.ComboBox1",Resolution2);//480X320 
	
	//class'UIAPI_COMBOBOX'.static.AddString("comboBox1",GetSystemString(2454));//640X480
	//class'UIAPI_COMBOBOX'.static.AddString("comboBox1",GetSystemString(2455));//320X240
	class'UIAPI_COMBOBOX'.static.SetSelectedNum("MovieCaptureWnd.ComboBox1", 2);//�ػ� ���� d=640*480	
}

function OnClickButton(string Name)
{
	switch(Name)
	{
	case "aBtn":
		if(!IsNowMovieCapturing()){//��ȭ ���� ���� ���			
			MovieCaptureToggle();
		}
		break;
	case "bBtn":	//���� ����
		//Debug("���� ���� ����");
		OpenTheFolder();
		break;
	case "CloseButton":
		Me.HideWindow();
	}
}

function HandleDialogOK()
{
	local int dialogID;
	if(DialogIsMine())
	{
		dialogID = DialogGetID();
		switch(dialogID){
		case DIALOGID_OpenFolder:
			OpenMovieCaptureDir();
			break;
		case DIALOGID_Diskisfull:			
			break;
		}
	}
}

function OpenTheFolder()
{
	DialogSetID(DIALOGID_OpenFolder);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(3312), string(Self));//�޽����޾Ƽ� ó�� �� ��
}

function DiskFullMessage()
{
	local string msg;
	msg = MakeFullSystemMsg(GetSystemMessage(3310), GetL2Path()$"/screenshot");
	DialogSetID(DIALOGID_Diskisfull);	
	//DialogShow(DialogModalType_Modalless, DialogType_OK, GetSystemMessage(3310), string(Self));//�޽����޾Ƽ� ó�� �� ��
	DialogShow(DialogModalType_Modalless, DialogType_OK, msg, string(Self));//�޽����޾Ƽ� ó�� �� ��
}


function OnComboBoxItemSelected(string sName, int index)
{
	//Debug("index="$index);
	switch(sName){
		case "ComboBox1": //�ػ�
			//Debug("�ػ� ����"$(index)$" "$ResolutionW[index]$", "$ResolutionH[index]);
			SetMovieCaptureResolution(ResolutionW[index], ResolutionH[index]);//�ػ󵵸� �߰� �ϰų� ���� �ؾ� �Ѵٸ� onLoad���� ���� �� ��
			break;
		/*case "ComboBox2": //ǰ  ��
			Debug("ǰ�� ����"$(index));
			SetQuality(index);
			break;*/
	}
}
/*
function SetQuality(int index){
	switch(index){
		case 0 :
			SetMovieCaptureHighQuality();//�� ����Ƽ
			break;
		case 1:
			SetMovieCaptureLowQuality();//�� ����Ƽ
			break;
	}
}*/


function OnEvent(int a_EventID, String a_Param)
{		
	switch(a_EventID)
	{
		case EV_MovieCaptureStarted:
			//IsCapturingFlag = true;
			CaptureOnOff();
			AddSystemMessage(3309);//������ ��ȭ�� �����մϴ�. Alt+H�� UI�� ����� �� �ֽ��ϴ�.		
			//Debug("ĸ�� ���� �̺�Ʈ");
			break;
		case EV_MovieCaptureFailDiskSpace:			
			//IsCapturingFlag = false;
			CaptureOnOff();
			DiskFullMessage();			
			AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(3310), GetL2Path()$"/screenshot"));//�ϵ��ũ�� �뷮�� �����Ͽ� ��ȭ�� �����մϴ�. ���ݱ��� ��ȭ �� ������ $s1�� ��ο� �ڵ� ���� �˴ϴ�.		
			//Debug("�뷮 ���� �̺�Ʈ");
			break;
		case EV_MovieCaptureEnded:
			//IsCapturingFlag = false;
			CaptureOnOff();				
			AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(3311), GetL2Path()$"/screenshot"));
			//Debug("ĸ�� �Ϸ� �̺�Ʈ");
			break;		
		case EV_DialogOK:
			//Debug("DialogType_OK Event");
			HandleDialogOK();
			break;
		case EV_Restart: 
			HandleRestart();
			break;
	}
}

function HandleRestart(){
	//if(IsCapturingFlag){
	if(	IsNowMovieCapturing()){
		MovieCaptureToggle();
	}
	//Debug("Restart");
}

function CaptureOnOff(){//������ ��ȯ ��� ����ġ ���� �پ� �ٴ�.	
	if(	IsNowMovieCapturing()){
		Me.HideWindow();
		m_hExpandWnd.showWindow();		
		//Debug("IsNowMovieCapturing");
		class'UIAPI_WINDOW'.static.SetAnchor("MovieCaptureWnd", "MovieCaptureWnd_Expand", "TopLeft", "TopLeft", 0, 0);//�⺻ �������� �Ǿ� ������ �̻��ϰ� �� �Ӽ��� ������ Ȯ�� â�� �巡�װ� �ȵ�.
		m_hExpandWnd.SetFocus();
	} else {		
		m_hExpandWnd.HideWindow();
		Me.showWindow();
		class'UIAPI_WINDOW'.static.SetAnchor("MovieCaptureWnd_Expand", "MovieCaptureWnd", "TopLeft", "TopLeft", 0, 0);
		Me.SetFocus();
	}
}

defaultproperties
{
}
