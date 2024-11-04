class HeroTowerWndWorld extends HeroTowerWnd;

function OnRegisterEvent()
{
	RegisterEvent(EV_HeroShowList);	
}

function OnEvent(int Event_ID, string param)
{
	Debug("OnEvent1" @ string(Event_ID) @ param);

	if (Event_ID == EV_HeroShowList)
	{
		Clear();
		
		//Show
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName);
		class'UIAPI_WINDOW'.static.SetFocus(m_WindowName);
		HandleHeroShowList(param);
	}
}

//리스트항목을 더블클릭하면 영웅행적 표시
function OnDBClickListCtrlRecord(string strID)
{
	switch(strID)
	{
		case "lstHero":
			HandleShowHistory();
			break;
	}	
}

function OnClickButton(string strID)
{
	switch( strID )
	{	
		case "btnHistory":
			HandleShowHistory();
			break;
	}
}

//초기화
function Clear()
{
	class'UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName$".lstHero");
}

//영웅 리스트를 추가
function HandleHeroShowList(string param)
{
	local int		i;
	local int		nMax;
	
	local string	strName;
	local int		ClassID;
	local string	strPledgeName;
	//local int		PledgeCrestId;
	//local int		AllianceCrestId;
	local int		WinCount;

	local int       Legend;
	
	//local texture	texPledge;
	//local texture	texAlliance;
	
	local LVDataRecord	record;
	local LVDataRecord	recordClear;

	local string ServerName;
	
	ParseInt( param, "Max", nMax );
	
	for (i=0; i<nMax; i++)
	{
		strName = "";
		ClassID = 0;
		strPledgeName = "";
		//PledgeCrestId = 0;
		//AllianceCrestId = 0;
		WinCount = 0;

		parseString( param, "ServerName_" $ i, ServerName );
		ParseString(param, "Name_" $ i, strName);
		ParseInt(param, "ClassId_" $ i, ClassID);
		ParseString(param, "PledgeName_" $ i, strPledgeName);
		//ParseInt(param, "PledgeCrestId_" $ i, PledgeCrestId);
		
		//ParseInt(param, "AllianceCrestId_" $ i, AllianceCrestId);

		ParseInt(param, "WinCount_" $ i, WinCount);

		ParseInt(param, "Legend_" $ i, Legend);
		
		//texPledge = GetPledgeCrestTexFromPledgeCrestID(PledgeCrestId);
		//texAlliance = GetAllianceCrestTexFromAllianceCrestID(AllianceCrestId);
		
		//레코드 초기화
		record = recordClear;
		record.LVDataList.Length = 5;

		//서버명
		record.LVDataList[0].szData = ServerName;
		
		//이름
		if( Legend == 1 )
		{
			record.LVDataList[1].hasIcon = true;
			record.LVDataList[1].nTextureWidth=16;
			record.LVDataList[1].nTextureHeight=16;
			record.LVDataList[1].nTextureU=16;
			record.LVDataList[1].nTextureV=16;
			record.LVDataList[1].szTexture = "L2UI_CT1.PlayerStatusWnd.myinfo_Legendicon";
			//record.LVDataList[1].IconPosX = 46;	
			record.LVDataList[1].FirstLineOffsetX=3;
			//record.LVDataList[1].TextColor = R;
			record.LVDataList[1].szData = strName;
		}
		record.LVDataList[1].szData = strName;

		//직업
		record.LVDataList[2].szData = GetClassType(ClassID);

		//혈맹
		record.LVDataList[3].szData = strPledgeName;

		//혈맹의 문장 텍스쳐 표시
		//if (AllianceCrestId>0)
		//{
		//	if (PledgeCrestId>0)
		//	{
		//		record.LVDataList[3].arrTexture.Length = 2;
				
		//		record.LVDataList[3].arrTexture[0].objTex = texAlliance;
		//		record.LVDataList[3].arrTexture[0].X = 10;
		//		record.LVDataList[3].arrTexture[0].Y = 0;
		//		record.LVDataList[3].arrTexture[0].Width = 8;
		//		record.LVDataList[3].arrTexture[0].Height = 12;
		//		record.LVDataList[3].arrTexture[0].U = 0;
		//		record.LVDataList[3].arrTexture[0].V = 4;
				
		//		record.LVDataList[3].arrTexture[1].objTex = texPledge;
		//		record.LVDataList[3].arrTexture[1].X = 18;
		//		record.LVDataList[3].arrTexture[1].Y = 0;
		//		record.LVDataList[3].arrTexture[1].Width = 16;
		//		record.LVDataList[3].arrTexture[1].Height = 12;
		//		record.LVDataList[3].arrTexture[1].U = 0;
		//		record.LVDataList[3].arrTexture[1].V = 4;
		//	}
		//	else
		//	{
		//		record.LVDataList[3].arrTexture.Length = 1;
				
		//		record.LVDataList[3].arrTexture[0].objTex = texPledge;
		//		record.LVDataList[3].arrTexture[0].X = 10;
		//		record.LVDataList[3].arrTexture[0].Y = 0;
		//		record.LVDataList[3].arrTexture[0].Width = 8;
		//		record.LVDataList[3].arrTexture[0].Height = 12;
		//		record.LVDataList[3].arrTexture[0].U = 0;
		//		record.LVDataList[3].arrTexture[0].V = 4;
		//	}
		//}
		//else
		//{
		//	if (PledgeCrestId>0)
		//	{
		//		record.LVDataList[3].arrTexture.Length = 1;
				
		//		record.LVDataList[3].arrTexture[0].objTex = texPledge;
		//		record.LVDataList[3].arrTexture[0].X = 10;
		//		record.LVDataList[3].arrTexture[0].Y = 0;
		//		record.LVDataList[3].arrTexture[0].Width = 16;
		//		record.LVDataList[3].arrTexture[0].Height = 12;
		//		record.LVDataList[3].arrTexture[0].U = 0;
		//		record.LVDataList[3].arrTexture[0].V = 4;
		//	}
		//}
		
		//횟수
		record.LVDataList[4].szData = string(WinCount);
		
		record.nReserved1 = ClassID;
		
		class'UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName$".lstHero", record );	
	}
}

defaultproperties
{
	m_WindowName="HeroTowerWndWorld"
}
