class ClanRaidsWnd extends L2UIGFxScript;

function OnRegisterEvent()
{	
	RegisterGfxEvent(EV_PledgeRaidInfo);
	RegisterGfxEvent(EV_PledgeRaidRank);

	//RegisterEvent(EV_PledgeRaidInfo);
	//RegisterEvent(EV_PledgeRaidRank);
	//RegisterGFxEvent(EV_Test_9);
	//RegisterGFxEvent(EV_Test_1);
	//RegisterEvent(EV_Test_1);
}

function OnLoad()
{
	SetClosingOnESC();
	SetContainerWindow( WINDOWTYPE_DECO_NORMAL, 3646);
	AddState("GAMINGSTATE");
	
	//�����ϸ� ó�� ���� �������� ���� ��
	//SetDefaultShow(true);
	//SetRenderOnTop(true);
	//SetAlwaysOnTop(true);
	//SetHavingFocus( false );
}

//function onEvent ( int ID, string param ) 
//{
//	Debug ( "onEvent" @ ID @ param ) ;
//}

defaultproperties
{
}
