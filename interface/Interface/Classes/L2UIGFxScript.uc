class L2UIGFxScript extends GFxUIScript;

/*
 * ������Ÿ�� ������
 */ 
const WINDOWTYPE_NONE = "none";
const WINDOWTYPE_DECO_NORMAL = "SkinnedWindow";
const WINDOWTYPE_SUB_WINDOW_TL = "SubWindow_TL";
const WINDOWTYPE_SIMPLE_DRAG = "SimpleDragWindow";
const WINDOWTYPE_NOBG = "SimpleNoBg";
const WINDOWTYPE_NOBG_NODRAG = "SimpleNoBgNoDrag";


var string _windowType;
var string _windowState;
var int _windowTitleID;
var int _stateCount;
var bool _isNotUseESC;
//var bool _CanFocusContainer;
var string containerName;

var WindowHandle m_Container;

function SetContainerHUD(string wndType, int wndTitleID)
{
	containerName = "ContainerHUD";	
	SetMyContainer(wndType, wndTitleID);
	_isNotUseESC = true;
	//_CanFocusContainer = false;
}

function SetContainerWindow(string wndType, int wndTitleID)
{
	containerName = "ContainerWindow" ;	
	SetMyContainer ( wndType, wndTitleID );
	_isNotUseESC = false;
	//_CanFocusContainer = true;
//	SetHavingFocus( false );
}
function SetMyContainer(string wndType, int wndTitleID)
{
	m_Container = GetWindowHandle(containerName);
	SetContainer(containerName);
	_windowType = wndType;
	_windowTitleID = wndTitleID;
	_stateCount = 0 ;
}



/* ������ �����̳��� ������
 * ���� â�� ��Ŀ�� �ص� �����̳� ������ ���� ���� �ʴ´�.
 * ������ ���� �Ϸ��� �����̳ʸ� focus �ؾ���
 * �׷��ٰ� �����̳ʸ� focus �ϰ� �Ǹ� �� â�� ���� ������ �ν� ���� �ʴ´�.
 * �� ���� ������ ������, �����̳ʸ� ��Ŀ�� �ؾ� �Ѵ�.
 * �׷��� �� ��� focus�� �Ҿ� ������ ��찡 ���� ������.
 */
function OnFocus(bool bFlag, bool bTransparency)
{
	//CallGFxFunction ( containerName, "onFocus", string ( bFlag ) ) ;

/*
    local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args,2) ;	
	args[0].setbool(bflag) ;
	args[1].setbool(bTransparency);
	AllocGFxValue(invokeResult);	
		
	Invoke("onFocusContainer", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);	
*/

	//Debug ( "OnFocus1" @  bFlag @ containerName @ getCurrentWindowName(string (self)) ) ;

	

 // 2014.10.17 ��Ŀ���� �����̳ʷ� �ϵ��� ����
 
	//�����̳��� â�� ��Ŀ�� �� ���� �����̳� ��ü�� ��Ŀ���� �ű�.
	//Debug ( "OnFocus1" @  bFlag @ _CanFocusContainer @containerName @ getCurrentWindowName(string (self)) ) ;
	if ( bFlag ) 
	{
		// �����̳ʰ� �ִٸ�, ��Ŀ���� �����̳ʷ� �� �� 
		if ( containerName != "" ) class'UIAPI_WINDOW'.static.SetFocus(containerName);
		//Debug ( "OnFocus2" @  bFlag @ containerName @ getCurrentWindowName(string (self)) ) ;
	}

}


function AddState(string str)
{
	registerState( getCurrentWindowName (string(Self)), str );
	//Debug ( "AddState" @  getCurrentWindowName (string(Self)) );
	ParamAdd(_windowState, "State"$_stateCount, str);
	_stateCount++;
}

function NotUseESC()
{
	_isNotUseESC = false;
}

////////////////////////////////////////////////////////////////////////////////static 

static function L2Util getInstanceL2Util()
{
	local L2Util script;

	script = L2Util(GetScript("L2Util"));
	return script;
}

static function UIData getInstanceUIData()
{
	return UIData(GetScript("UIData"));
}

/** 
 * 
 * ������ �̸��� �޴´�.
 * 
 * getCurrentWindowName (string(Self)) 
 * 
 **/
static function string getCurrentWindowName (string targetString)
{
	local array<string>	ArrayStr;

	Split(targetString, ".", ArrayStr);

	return ArrayStr[1];
}

static function int Split( string strInput, string delim, out array<string> arrToken )
{
	local int arrSize;
	
	while ( InStr(strInput, delim)>0 )
	{
		arrToken.Insert(arrToken.Length, 1);
		arrToken[arrToken.Length - 1] = Left(strInput, InStr(strInput, delim));
		strInput = Mid(strInput, InStr(strInput, delim) + 1);
		arrSize = arrSize + 1;
	}
	arrToken.Insert(arrToken.Length, 1);
	arrToken[arrToken.Length-1] = strInput; // UnknownFunction147
	arrSize = arrSize + 1; // UnknownFunction146
	
	return arrSize;
}

function int EV_PacketID(int nServerPacketID)
{
	return EV_ProtocolBegin + nServerPacketID;
}

function HandleCustomUIEvent(string param)
{
	local int nTmp;
	local SayPacketType type;
	local string text;
	local string message;
	local string name;
	local int i;
	
	ParseInt(param, "Type", nTmp);

	type = SayPacketType(nTmp);

	if (type == SPT_MSN_CHAT)
	{
		ParseString(param, "Msg", text);
		message = Mid(text, InStr(text, ": ") + 2);
		name = Mid(text, 0, InStr(text, ": "));
		if (name == "UI_EVENT")
		{
			OnEvent(EV_CustomUIEvent, message);
		}
	}
}


defaultproperties
{
}
