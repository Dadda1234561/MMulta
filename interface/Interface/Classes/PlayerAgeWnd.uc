/**
 *  Ŭ���� ���� ��, �����̿��� ǥ�� ������
 **/

class PlayerAgeWnd extends UIScript;

function OnLoad()
{
	SetClosingOnESC();
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("PlayerAgeWnd").HideWindow();
}

defaultproperties
{
}
