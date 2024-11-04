//------------------------------------------------------------------------------------------------------------------------
//
// ����         : AlterSkill  ( �ߵ� ��ų ) - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class Fishing extends L2UIGFxScript;

event OnRegisterEvent()
{	
	RegisterGFxEvent(EV_AutoFishAvailable);
	RegisterGFxEvent(EV_AutoFishStart);
	RegisterGFxEvent(EV_AutoFishEnd);
}

event OnLoad()
{
	SetContainerHUD( WINDOWTYPE_NONE, 0);
	AddState("GAMINGSTATE");

	//�����ϸ� ó�� ���� �������� ���� ��
	//SetDefaultShow(true);

	SetHavingFocus( false );
	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0,0);//116, -3);
}

event OnCallUCLogic(int logicID, string param)
{
	switch(logicID)
	{
		// End:0x1A
		case 1:
			SetNextFocus();
			HideWindow();
			// End:0x1D
			break;
	}
}

defaultproperties
{
}
