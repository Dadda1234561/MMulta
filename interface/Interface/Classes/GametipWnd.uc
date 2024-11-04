class GametipWnd extends UIScript;

var Array<GameTipData> TipData;
var int CountRecord;
var Userinfo userinfofortip;

var string CurrentTip;
var string CurrentTipImgTexture;

var int numb;

function OnRegisterEvent()
{
	RegisterEvent(EV_NeedResetUIData);
	RegisterEvent(EV_LanguageChanged);
}

function OnLoad()
{
	LoadGameTipData();
}

function OnEventWithStr(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{		
		case EV_LanguageChanged:
			LoadGameTipData();
		break;
	}
}

function onEvent ( int a_EventID, String a_Param ) 
{
	switch( a_EventID )
	{		
		case EV_NeedResetUIData:
			LoadGameTipData();
		break;
	}
}

function LoadGameTipData()
{
	local int i;

	local bool gamedataloaded; //TipData1 �� �ޱ� ����.

	local GameTipData TipData1;

	CountRecord = class'UIDATA_GAMETIP'.static.GetDataCount();
	for (i=0; i<CountRecord; ++i)
	{
		gamedataloaded = class'UIDATA_GAMETIP'.static.GetDataByIndex(i, TipData1);
		TipData[ i ] = TipData1;		
		// Debug("TipData[ i ]" @ TipData[ i ]);
	}
}

function OnShow()
{
	local int RandomVal;
	local int PrioritySelect;
	local int UserLevelData;
	local bool userinfoloaded;
	local Array<GameTipData> SelectedCondition;	
	local int i;
	local int j;
	local int UserLevel;
	local int UserArrange;
	local int NumberSelect;

	local GameTipData tempTipData;

	local LoadingWnd loadingWndScript;

	j = 0;
	
	userinfoloaded = GetPlayerInfo(userinfofortip);
	if (userinfoloaded == false)
	{
		//debug("�������� �ε� ����");
	}
	else 
	{
		//debug("�������� �ε� ����:" @ userinfofortip.nLevel);
	}
	UserLevelData = userinfofortip.nLevel;
	if (UserLevelData >= 1 && UserLevelData <= 20)
	{
		UserLevel = 1;
	}
	else if (UserLevelData >= 21 && UserLevelData <= 40)
	{
		UserLevel = 20;
	}	
	else if (UserLevelData >= 41 && UserLevelData <= 60)
	{
		UserLevel = 40;
	}
	else if (UserLevelData >= 61 && UserLevelData <= 74)
	{
		UserLevel = 60;
	}
	else if (UserLevelData >= 75 && UserLevelData <= 84)
	{
		UserLevel = 80;
	}
	else
	{
		UserLevel = 90;
	}
	
	if (UserLevelData <= 40 && UserLevelData > 0 )
	{
		UserArrange = 101;
	}
	else if(UserLevelData < 85 && UserLevelData >= 41 )
	{
		UserArrange = 102;
	}
	else
	{
		UserArrange = 103;
	}
	
	RandomVal = Rand(99) + 1;
	if (RandomVal >=1 && RandomVal <= 70 )
	{
		PrioritySelect = 1;
	}
	else 	if (RandomVal >=71 && RandomVal <= 85)
	{
		PrioritySelect = 2;
	}
	else 	if (RandomVal >=86 && RandomVal <= 95)
	{
		PrioritySelect = 3;
	}
	else 	if (RandomVal >=96 && RandomVal <= 100)
	{
		PrioritySelect = 4;
	}
	
	//debug("priority:" @ PrioritySelect);

	for (i=0; i<TipData.length; ++i)
	{
		if (TipData[ i ].TipMsg != "") 
		{
			if (TipData[ i ].Priority == PrioritySelect && TipData[ i ].Validity == true )
			{
				if ( TipData[ i ].TargetLevel == UserLevel || TipData[ i ].TargetLevel == 0 || TipData[ i ].TargetLevel  == UserArrange)
				{
					//SelectedCondition[ j ].ID = TipData[ i ].ID;
					//SelectedCondition[ j ].Priority = TipData[ i ].Priority;
					//SelectedCondition[ j ].TargetLevel = TipData[ i ].TargetLevel;
					//SelectedCondition[ j ].Validity = TipData[ i ].Validity;
					
					SelectedCondition[ j ] = tempTipData;
					SelectedCondition[ j ].TipMsg = TipData[ i ].TipMsg;					
					SelectedCondition[ j ].TipImg = TipData[ i ].TipImg;

					// Debug("TipData[ i ].TipMsg" @ TipData[ i ].TipMsg);
					// Debug("TipData[ i ].TipImg" @ TipData[ i ].TipImg);
					++j;
				}
			}
		}
	}
	
	//debug("�����:" @ SelectedCondition.length @ "��"); 

	NumberSelect = Rand(SelectedCondition.length);
	
	// Debug("----------::: currentTipImgTexture" @ currentTipImgTexture);
	//debug("��÷��ȣ:" @ NumberSelect);
	
	if (SelectedCondition.length == 0)
	{
		CurrentTip = "";
		CurrentTipImgTexture = "";
	}
	else
	{
		//Debug("���:"@ SelectedCondition[NumberSelect]);
		CurrentTip = SelectedCondition[ NumberSelect ].TipMsg;
		CurrentTipImgTexture = SelectedCondition[ NumberSelect ].TipImg;

		// �������� ��� �ؽ��İ� �����Ǿ� ������ ���� �ؽ��� ���� 
		loadingWndScript = LoadingWnd( GetScript("LoadingWnd") );
		loadingWndScript.setBackgroundTextureStr(CurrentTipImgTexture);

		// Debug("CurrentTipImgTexture" @ CurrentTipImgTexture);
	}

	if (GetOptionBool("ScreenInfo","ShowGameTipMsg") == True)
	{
		class'UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText1", "");
		//~ class'UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText1-1", GetSystemString(1455));
		//~ class'UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText1-2", GetSystemString(1455));
		class'UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText", "");
		//class'UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText-1", CurrentTip );
		//class'UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText-2", CurrentTip );
	}
	else
	{
		class'UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText1", "" );
		//class'UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText1-1", "");
		//class'UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText1-2", "");
		class'UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText", "" );
		//class'UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText-1", "" );
		//class'UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText-2", "" );
	}

	 //numb = numb+1;
}

defaultproperties
{
}
