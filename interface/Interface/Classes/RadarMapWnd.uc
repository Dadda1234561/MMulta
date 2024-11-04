class RadarMapWnd extends L2UIGFxScript;

function OnRegisterEvent()
{	
	RegisterGFxEvent( EV_Restart );
	RegisterGFxEvent( EV_SetRadarZoneCode);
	RegisterGFxEvent( EV_BeginShowZoneTitleWnd );		//�������� �ٲ� ��, ���̴��� �������� ������ �����ؾ��Ѵ�. 
	RegisterEvent( EV_BeginShowZoneTitleWnd );
	RegisterGFxEvent( EV_ShowMinimap );	
	//RegisterGFxEvent( EV_NotifyObject);	
	
	RegisterGFxEvent( EV_GamingStateEnter );
	RegisterGFxEvent( EV_GamingStateExit );
	
	//RegisterGFxEvent( EV_TargetUpdate );				//Ÿ�� ������Ʈ �� ��� Ÿ���� ǥ�����ش�.
	//6130
	RegisterGFxEvent( EV_UpdateTargetSelectedRadarMap );				//Ÿ�� ������Ʈ �� ��� Ÿ���� ǥ�����ش�.
	RegisterGFxEvent( EV_TargetHideWindow );			//Ÿ���� ���̵� �ɰ�� Ÿ�� ����
	
	//RegisterGFxEvent( EV_FinishRotate);	//ȸ�� ����� ������ �̺�Ʈ
	
	//RegisterGFxEvent( EV_AirShipState );	// ������ ������Ʈ�� ������ ���
	//RegisterGFxEvent( EV_AirShipUpdate );	// ������ ���� ������Ʈ �̺�Ʈ
	//RegisterGFxEvent( EV_AirShipAltitude);	// ������ ���� ����Ǿ��� ���

	//RegisterGFxEvent( EV_NotifyTutorialQuest ); //ldw Ʃ�丮�� ����Ʈ ���� �̺�Ʈ
	//RegisterGFxEvent( EV_ClearTutorialQuest ); //ldw Ʃ�丮�� ���� �̺�Ʈ


	RegisterGFxEvent( EV_PartyAddParty);       //��Ƽ ����
	RegisterGFxEvent( EV_PartyDeleteParty);    //��Ƽ ����
	RegisterGFxEvent( EV_PartyDeleteAllParty); //��� ��Ƽ ����
	RegisterGFxEvent( EV_PartyDeleteAllParty); //��� ��Ƽ ����
	RegisterGFxEvent( EV_PartyUpdateParty);    //��Ƽ ���� ����
	

	RegisterGFxEvent( EV_UpdateQuestMarkRadarMap ); //����Ʈ ��ũ ���� 

	//RegisterGFxEvent( EV_NotifyPartyMemberPosition);


	//�ڵ��� ���üĿ
	//RegisterGFxEvent( EV_BlockStateTeam );
	//RegisterGFxEvent( EV_BlockStatePlayer );
	//Ŭ����Ʈ ��Ȳ��
	//RegisterGFxEvent( EV_CleftStateTeam );
	//RegisterGFxEvent( EV_CleftStatePlayer );
	//���� �ݷμ��� ��Ȳ��
	//RegisterGFxEvent( EV_CrataeCubeRecordBegin );
	//RegisterGFxEvent( EV_CrataeCubeRecordMyItem );
	//RegisterGFxEvent( EV_CrataeCubeRecordRetire );
	//PVP �� �̺�Ʈ
	//RegisterGFxEvent( EV_PVPMatchRecord );

	//RegisterGFxEvent( EV_CuriousHouseWaitState);
	// �ǹ��� ���� state 0:�Ⱓ �ƴ�, 1:�����û, 2:������

	//������ ���� �޽� ������ �� �� �߻�
	//RegisterGFxEvent( EV_EnterSingleMeshZone ); //9540

	//������ ���� �޽� �������� ���� �� �߻�
	//RegisterGFxEvent( EV_ExitSingleMeshZone ); //9541		

	//�̴ϸ� �� �ٲ� ��
	RegisterGFxEvent( EV_MinimapChangeZone ); //1840		

	//���� �ð� ����
	//RegisterGFxEvent( EV_MinimapUpdateGameTime ); //1890

	//����Ʈ�� �ٽ� ���� ��
	//RegisterGFxEvent( EV_QuestListStart ); //700;

	RegisterGFxEvent( EV_Restart ); //����Ʈ ��ũ ���� 

	// ���̴� �� �� �̺�Ʈ
	RegisterGFxEvent( EV_ArenaCustomNotification ); 

	// ���̴� �� �Ʒ��� �� �˻�.
	RegisterGFxEvent( EV_ArenaShowEnemyParty ); 
	

}

/*
 *Ʃ�丮�� ����Ʈ �̴ϸʿ� �ش� ��ġ ǥ��
function onTutorialQuest8888Handle(){//ldw
	local vector vTutorialPos;//ldw
	local MinimapWnd MinimapWndScript;//ldw
	local MinimapWnd_Expand MinimapWnd_ExpandScript;//ldw

	//Debug("TutorialQuest8888 is pushed");			
			vTutorialPos.x=TUTORIALQUEST[3];
			vTutorialPos.y=TUTORIALQUEST[4];
			vTutorialPos.z=TUTORIALQUEST[5];
			if(IsShowWindow("MinimapWnd_Expand"))
			{				
				//Debug("expand");
				ShowWindowWithFocus("MinimapWnd_Expand");
				MinimapWnd_ExpandScript = MinimapWnd_Expand( GetScript("MinimapWnd_Expand") );
				MinimapWnd_ExpandScript.SetLocContinent(vTutorialPos);
				class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd_Expand.Minimap",vTutorialPos,true);
			}else if (IsShowWindow("MinimapWnd"))
			{  				
				MinimapWndScript = MinimapWnd( GetScript("MinimapWnd") );
				MinimapWndScript.SetLocContinent(vTutorialPos);				
				class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",vTutorialPos,true);				
				MinimapWnd.setFocus();				
				

			} else {				
				ShowWindowWithFocus("MinimapWnd");
				MinimapWndScript = MinimapWnd( GetScript("MinimapWnd") );
				MinimapWndScript.SetLocContinent(vTutorialPos);
				class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap",vTutorialPos,true); //ldw Ʃ�丮��
			}
}
*/

event OnLoad()
{
	SetSaveWnd(True,True);

	SetContainerHUD( WINDOWTYPE_NONE, 0);
	AddState("GAMINGSTATE");

	//�Լ� ���� �� onStateOut, onStateIn �Լ��� invoke �� ���� 
	//SetStateChangeNotification();

	//�����ϸ� ó�� ���� �������� ���� ��
	SetDefaultShow(true);

	//SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0 , 0);		
}

event onCallUCFunction ( string functionName, string param )
{
	switch ( functionName )
	{
		case "TeleportBookmarkBtn":
			
			if( class'UIAPI_WINDOW'.static.IsShowWindow("TeleportBookMarkWnd") )
			{
				class'UIAPI_WINDOW'.static.HideWindow( "TeleportBookMarkWnd" );
			}
			else
			{
				DoAction(class'UICommonAPI'.static.GetItemID(64));
			}
		break;
		case "onClickArrowIcon":
			onClickArrowIcon();
			break;
	}
}

event OnEvent(int eID, string param)
{
	switch(eID)
	{
		case EV_BeginShowZoneTitleWnd:
			HandleEV_BeginShowZoneTitleWnd();
			// End:0x1B
			break;
	}	
}

private function HandleEV_BeginShowZoneTitleWnd()
{
	class'MinimizeManager'.static.Inst()._SetToolTIp("RadarMapWnd", API_GetCurrentZoneName());	
}

function onClickArrowIcon()
{
	local Vector QuestLocation;

	if ( GetQuestLocation(QuestLocation) )
	{
		ChaseMiniPosition(QuestLocation);
		if ( !Class'UIAPI_WINDOW'.static.IsShowWindow("MiniMapGfxWnd") )
			Class'UIAPI_WINDOW'.static.ShowWindow("MiniMapGfxWnd");
	}
}

function ChaseMiniPosition (Vector Loc, optional MinimapRegionIconData IconData)
{
	local int OffsetX;
	local int OffsetY;

	OffsetX = IconData.nWidth / 2 + IconData.nIconOffsetX;
	OffsetY = IconData.nHeight / 2 + IconData.nIconOffsetY;
	getInstanceL2Util().ShowHighLightMapIcon(Loc,OffsetX,OffsetY);
}

private function string API_GetCurrentZoneName()
{
	return GetCurrentZoneName();	
}

defaultproperties
{
}
