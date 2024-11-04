class BR_CampaignTopContributorListWnd extends UICommonAPI;

var WindowHandle Me;

var TextBoxHandle CampaignTitle;

var ListCtrlHandle CampaignTopContributorList;

function OnRegisterEvent()
{
	RegisterEvent( EV_BR_Event_CampaignResult );
}

function OnLoad()
{
	OnRegisterEvent();
	Me = GetWindowHandle("BR_CampaignTopContributorListWnd");

	CampaignTitle = GetTextBoxHandle("BR_CampaignTopContributorListWnd.CampaignTitle");

	CampaignTopContributorList = GetListCtrlHandle("BR_CampaignTopContributorListWnd.CampaignTopContributorList");
}

function OnEvent( int Event_ID, string param )
{
	switch( Event_ID )
	{		
		//������Ʈ ���� ��
		case EV_BR_Event_CampaignResult :
			//Debug("EV_CampaignResult");
			CampaignResult( param );
			break;
	}
}

function CampaignResult( string param )
{
	//5301
	//ID=1 STEP=1 ListCnt=7 Name_0=aa Name_1=aa1 Name_2=aa2 Name_3=aa3 Name_4=aa4 Name_5=aa5 Name_6=aa6
	local LVDataRecord Record;

	local int i;
	local int ID;
	local int STEP;
	local int GoalGroupID;
	local int ListCnt;
	local string Name;

	local EventContentInfo info;

	local Color c;

	c.R = 222;
	c.G = 196;
	c.B = 126;

	CampaignTopContributorList.DeleteAllItem();

	Record.LVDataList.length = 1;

	ParseInt(param, "ID", ID);
	ParseInt(param, "STEP", STEP);
	ParseInt(param, "GOALGROUPID", GoalGroupID);
	ParseInt(param, "ListCnt", ListCnt);

	GetEventContentInfo( ID, STEP, GoalGroupID, info );
/*
	Debug( "ID-->" $ string( ID ) );
	Debug( "STEP-->" $ string( STEP ) );
	Debug( "ListCnt-->" $ string( ListCnt ) );
*/	
	CampaignTitle.SetText( info.Title );
	CampaignTitle.SetTextColor( c );

	//<TextColor R="222" G="196" B="126"/>

	for( i = 0 ; i < ListCnt ; i++ )
	{
		ParseString(param, "Name_"$i , Name);		

		Record.LVDataList[0].szData = Name;

		CampaignTopContributorList.InsertRecord( Record );
	}
	Me.ShowWindow();
}

// ��ưŬ�� �̺�Ʈ
function OnClickButton( string strID )
{
	//Debug("strID>>>" $ strID );

	if( strID == "btnExit" )
	{
		Me.HideWindow();
	}
}

defaultproperties
{
}
