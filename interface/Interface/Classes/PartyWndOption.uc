/******************************************************************************
//                                                ��Ƽâ  �ɼ� ���� UI ��ũ��Ʈ                                                                    //
******************************************************************************/
class PartyWndOption extends UIScript;
	
//const MAX_PartyMemberCount = 9;		//�� ��Ƽâ�� ���� �ִ� �ִ� ��Ƽ���� ��.

// �������� ����
var bool	m_OptionShow;	// ���� �ɼ�â�� �������� �ִ��� üũ�ϴ� �Լ�.
					// true�̸� ����. false  �̸� ������ ����.
var int	m_arrPetIDOpen[MAX_PartyMemberCount];	// �ε����� �ش��ϴ� ��Ƽ���� ���� â�� �����ִ��� Ȯ��. 1�̸� ����, 2�̸� ����. -1�̸� ����

// �̺�Ʈ �ڵ� ����
var WindowHandle	m_PartyOption;
var WindowHandle 	m_PartyWndBig;

var CheckBoxHandle	m_CheckHideAllPet;
var CheckBoxHandle  m_showSmallPartyWndChek;
var ComboBoxHandle  PartyColorTypeComboBox;
function OnRegisterEvent()
{
	RegisterEvent( EV_AutoplaySetting );	
}

function OnEvent(int Event_ID, string param)
{	
	// Debug  ( "Event_ID" @ Event_ID);
	switch(Event_ID)
	{
		case EV_AutoplaySetting  :
			RequestBypassToServer("show_party_color" @ GetOptionInt("PartyColor", "ColorType"));	
		break;
	}
}

// ������ ������ �ε�Ǵ� �Լ�
function OnLoad()
{
	m_OptionShow = false;	// ����Ʈ�� false 
	m_PartyOption = GetWindowHandle("PartyWndOption");
	m_PartyWndBig = GetWindowHandle("PartyWnd");
	m_CheckHideAllPet = GetCheckBoxHandle("PartyWndOption.removeAllPet");
	m_showSmallPartyWndChek = GetCheckBoxHandle("PartyWndOption.ShowSmallPartyWndCheck");
	m_showSmallPartyWndChek.HideWindow();
	//init parry color
	PartyColorTypeComboBox = GetComboBoxHandle("PartyWndOption.PartyColorTypeComboBox");
	
	
	PartyColorTypeComboBox.AddString("Off");
	PartyColorTypeComboBox.AddString("Pink");
	PartyColorTypeComboBox.AddString("Orange");
	PartyColorTypeComboBox.AddString("Green");
	PartyColorTypeComboBox.AddString("Yellow");
	PartyColorTypeComboBox.AddString("White");
	PartyColorTypeComboBox.AddString("Blue (default)");
	PartyColorTypeComboBox.AddString("Red (default)");	
	
	
	
	
	
	
	PartyColorTypeComboBox.SetSelectedNum(GetOptionInt("PartyColor", "ColorType"));

}
 
 //bypass
function OnComboBoxItemSelected(String a_ControlID, INT a_SelectedIndex)
{
	if(a_ControlID == "PartyColorTypeComboBox")
	{
		RequestBypassToServer("show_party_color" @ a_SelectedIndex);	
		
		SetOptionInt("PartyColor", "ColorType", a_SelectedIndex );
	}
}     
// �����찡 ������������ ȣ��Ǵ� �Լ�
function OnShow()
{
	local int tmpInt;

	GetINIInt("PartyWnd", "e", tmpInt, "Windowsinfo.ini");
	m_showSmallPartyWndChek.SetCheck(bool(tmpInt));
	class'UIAPI_WINDOW'.static.SetFocus("PartyWndOption");
	m_OptionShow = true;
	GetINIInt("PartyWnd", "p", tmpInt, "Windowsinfo.ini");
	m_CheckHideAllPet.SetCheck(bool(tmpInt));
}

// üũ�ڽ��� Ŭ���Ͽ��� ��� �̺�Ʈ
function OnClickCheckBox( string CheckBoxID)
{
	switch( CheckBoxID )
	{
		case "ShowSmallPartyWndCheck":
			 break;

		case "removeAllPet":
			 // ��� 
			 // Debug("Ŭ��!" @ m_CheckHideAllPet.IsChecked());
			 break;
	}
}

// Ȯ��� ��Ƽâ�� ��ҵ� ��Ƽâ�� ��ȯ
function SwapBigandSmall()
{
	local int i;
	//~ local int open, hide;
	
	local  PartyWnd script1;			// Ȯ��� ��Ƽâ�� Ŭ����
	local PartyWndClassic scriptClassic;

	scriptClassic = PartyWndClassic(GetScript("PartyWndClassic"));
	script1 = PartyWnd( GetScript("PartyWnd") );
	
	for(i=0; i <MAX_PartyMemberCount ; i++)
	{
		if( m_CheckHideAllPet.IsChecked()) 	
		{
			if(m_arrPetIDOpen[i] > 0)	m_arrPetIDOpen[i] = 2;		//���� ������ ��� �ݾ��ش�. 
		}
		else 
		{
			if(m_arrPetIDOpen[i] > 0)	m_arrPetIDOpen[i] = 1;		//���� ������ ��� �����ش�. 			
		}
		
		script1.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
		scriptClassic.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
		// ���� ��ũ��Ʈ���� ��� ����.		
	}
	// �� ��ũ��Ʈ�� ResizeWnd()�� �ɼ��� Ȱ��ȭ�� ���� �ڽ��� �����츦 HIDE���� Ȱ��ȭ���� �����Ѵ�. 
	script1.ResizeWnd(true);
	scriptClassic.ResizeWnd(true);
}

//function setCheckAllPetClose(bool flag)
//{
//	local bool bBeforeCheck;

//	bBeforeCheck = m_CheckHideAllPet.IsChecked();

//	if (bBeforeCheck != flag)
//	{
//		m_CheckHideAllPet.SetCheck(flag);
//		SetINIInt ( "PartyWnd", "p", int ( m_CheckHideAllPet.IsChecked() ) , "Windowsinfo.ini");
//	}
//}

// ��ư�� ������ ��� ����
function OnClickButton( string strID )
{
	//local PartyWnd script1;
	//local PartyWndCompact script2;
	//script1 = PartyWnd( GetScript("PartyWnd") );
	//script2 = PartyWndCompact( GetScript("PartyWndCompact") );
	
	switch( strID )
	{
		case "okbtn":	// OK ��ư�� ������
			//switch (class'UIAPI_CHECKBOX'.static.IsChecked("ShowSmallPartyWndCheck"))
			SetINIInt( "PartyWnd", "e", int( m_showSmallPartyWndChek.IsChecked()), "Windowsinfo.ini" );
			SetINIInt ( "PartyWnd", "p", int ( m_CheckHideAllPet.IsChecked() ) , "Windowsinfo.ini");
			/*
			switch (m_showSmallPartyWndChek.IsChecked() )
			{ 
			case true:
				//SetOptionBool("Game", ... ) �� ������ Option ->�����׸񿡼� ����Ҽ� �ִ� bool ������ ����� �� �ִ�.	
				//������ ��ϵ��� ���� ������ ����ϸ� �ڵ����� Ŭ���̾�Ʈ���� �˾Ƽ� ������.
				// ���� ���� ������ ���� Documentation �� �ʿ�!
				// GetOptionBool�� ���.
				
				
				break;
			case false:
				SetOptionBool( "PartyWnd", "SmallPartyWnd", false);
				break;
			}
*/
			SwapBigandSmall();		// ��Ȳ�� ���� ��Ƽâ�� ũ�⸦ �������ش�.
			m_PartyOption.HideWindow();	// ������ �����츦 �����
			//script1.m_OptionShow = false;
			//script2.m_OptionShow = false;
			m_OptionShow = false;
			break;
	}
}

// PartyWnd�� PartyWndCompact ���� ȣ���ϴ� �Լ�.
function ShowPartyWndOption()
{
	// ���������� ����
	if (m_OptionShow == false)
	{ 
		m_PartyOption.ShowWindow();
		m_OptionShow = true;
	}
	else	// ���������� �ݴ´�. 
	{
		m_PartyOption.HideWindow();
		m_OptionShow = false;
	}
}

defaultproperties
{
}
