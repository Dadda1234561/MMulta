//------------------------------------------------------------------------------------------------------------------------
//
// 제목       : 올림피아드 결과창
// 특징       : 리스트 컨트롤, 라이브
// 빌드       : 캐릭터 A, B, 필요
	//변경 레벨 99
	//클래스 172
	//ns nobless 1
	//olympiad term 3600 
	//olympiad min_match_count 2 2
	//olympiad term_ex 5 5 3000 3000 3000
	//생성 1031688


//------------------------------------------------------------------------------------------------------------------------
class WorldOlympiadResultWnd extends UICommonAPI;


// 윈도우 공통
var string              m_WindowName;
var WindowHandle        Me;


var TextBoxHandle playerClass1Txt;
var TextBoxHandle playerClass2Txt;
var TextureHandle drawMC;

var TextureHandle player1WinMC;
var TextureHandle player1LoseMC;
var TextureHandle player2WinMC;
var TextureHandle player2LoseMC;

struct MemberDataStruct
{		
	var string PcName ;
	var int TeamColor ;	
	var int ClassName ;
	var int TotalDamage ;
	var int CurrentPoint ;
	var int GetPoint ;	
};

enum winStateType
{
	IAM,
	YOU,
	NOT
};

var winStateType winState;

//winnerName
//teamColor

//winMemberNum
//winPcName
//winTeamColor
//winClasName0
//winTotalDamage0
//winCurrentPoint0
//winGetPoint0
//winServerName0


// 팀 컬러가 1인 쪽이 승리 
// 0 이면, 패배, 
//	set1Win
//set2Win
//set3Win
//winnerItemCount
//	loserItemCount 

struct ResultDataStruct 
{
	// var int winMemberNum;
	// var int loseMemberNum;
	var int set1Win;
	var int set2Win;
	var int set3Win;
	var int winnerItemCount;
	var int loserItemCount;
};

// 창 닫히는 시간 타이머
const TIMER_ID      = 148 ;
const TIMER_DELAY   = 20000 ;

function OnRegisterEvent()
{
	//RegisterGFxEvent(EV_ReceiveOlympiadResult);
	//RegisterGFxEvent(EV_ReceiveOlympiadResultV2);			
	RegisterEvent( EV_ReceiveOlympiadResultV2 );       // 5082
}


function OnLoad()
{
	m_WindowName = getCurrentWindowName(String(self));
	Me = GetWindowHandle ( m_WindowName ) ;

	SetClosingOnESC();
	//listCtrl = GetListCtrlHandle( m_WindowName $ ".OlympiadArenaList_ListCtrl");
	//listCtrl.SetColumnMinimumWidth( true ) ;
}

function OnEvent(int Event_ID, string a_param)
{
	// Debug ("my OnEvent" @  Event_ID  @ a_param ) ;	
	switch (Event_ID)
	{	
		case EV_ReceiveOlympiadResultV2 :       // 5082
			HandleResultLists ( a_param ) ;
			Me.ShowWindow();
		break;		
	}
}

function onSHow()
{
	Me.SetTimer(TIMER_ID,TIMER_DELAY) ;
}

function onHide ()
{
	Me.KillTimer(TIMER_ID);
}

function OnTimer(int TimerID)
{
	switch ( TimerID ) 
	{
		case TIMER_ID: 
			Me.HideWindow();
		break;
	}
}

function OnClickButton( string strID )
{
	Me.HideWindow() ;
}


function HandleResultLists ( String a_param ) 
{
	local MemberDataStruct  winMemberData;		
	local MemberDataStruct  loaeMemberData;		
	local ResultDataStruct  resultData;	

	local string            winnerName;

	local userInfo playerInfo;

	GetPlayerInfo( playerInfo );

	//parseInt ( a_param, "winMemberNum", resultData.winMemberNum );
	//parseInt ( a_param, "loseMemberNum", resultData.loseMemberNum );

	parseString ( a_param, "winnerName", winnerName );

	if ( winnerName == playerInfo.Name ) 
		winState = winStateType.IAM;
	else if ( winnerName == "" ) 
		winState = winStateType.NOT;
	else 
		winState = winStateType.YOU ;

	parseInt ( a_param, "set1Win", resultData.set1Win );
	parseInt ( a_param, "set2Win", resultData.set2Win );
	parseInt ( a_param, "set3Win", resultData.set3Win );

	parseInt ( a_param, "winnerItemCount", resultData.winnerItemCount );
	parseInt ( a_param, "loserItemCount", resultData.loserItemCount );	

	parseString ( a_param, "winPcName0" , winMemberData.PcName );
	parseInt ( a_param, "winTeamColor0" , winMemberData.TeamColor );		
	parseInt ( a_param, "winClassName0" , winMemberData.ClassName );
	parseInt ( a_param, "winTotalDamage0" , winMemberData.TotalDamage );
	parseInt ( a_param, "winCurrentPoint0" , winMemberData.CurrentPoint );
	parseInt ( a_param, "winGetPoint0" , winMemberData.GetPoint );
		
	parseString ( a_param, "losePcName0",  loaeMemberData.PcName );
	parseInt ( a_param, "loseTeamColor0" , loaeMemberData.TeamColor );		
	parseInt ( a_param, "loseClassName0", loaeMemberData.ClassName );
	parseInt ( a_param, "loseTotalDamage0", loaeMemberData.TotalDamage );
	parseInt ( a_param, "loseCurrentPoint0", loaeMemberData.CurrentPoint );
	parseInt ( a_param, "loseGetPoint0", loaeMemberData.GetPoint );		

	HandleResultImages();

	if ( winMemberData.PcName == playerInfo.name ) 
	{
		HandleResultPlayer ( winMemberData, resultData,  1 ) ;
		HandleResultPlayer ( loaeMemberData, resultData,  2 ) ;
		HandleResultRewardPoint ( winMemberData ) ;
		HandleResultRewardItem( resultData.winnerItemCount );
	}
	else 
	{
		HandleResultPlayer ( winMemberData, resultData,  2 ) ;
		HandleResultPlayer ( loaeMemberData, resultData,  1 ) ;
		HandleResultRewardPoint ( loaeMemberData ) ;
		HandleResultRewardItem( resultData.loserItemCount );
	}
}


function HandleResultRewardPoint ( MemberDataStruct  memberData ) 
{
	local WindowHandle arrowDown, arrowUP;
	local TextBoxHandle currentPoint, upPoint ;
	currentPoint = GetTextBoxHandle (   m_WindowName $".rewardPointMC" $ ".currentPointText");
	upPoint = GetTextBoxHandle (   m_WindowName $".rewardPointMC" $ ".upPointText" );

	currentPoint.SetText ( MakeCostString ( String ( memberData.CurrentPoint )) ) ;

	arrowDown = GetWindowHandle (   m_WindowName $".rewardPointMC" $ ".arrowDownMC" ) ;
	arrowUP = GetWindowHandle (   m_WindowName $".rewardPointMC" $ ".arrowUpMC" );
	
	arrowUP.HideWindow();
	arrowDown.HideWindow();

	if ( memberData.GetPoint  > 0 ) 
	{
		arrowUP.ShowWindow();
		upPoint.SetTextColor ( getColor ( 0, 255, 0, 255 ) );
		upPoint.SetText  ( "+" $ MakeCostString ( String ( memberData.GetPoint )) ) ;	
	}
	if ( memberData.GetPoint  < 0 ) 
	{
		arrowDown.ShowWindow();
		upPoint.SetTextColor (getColor ( 204, 0, 0, 255 ));
		upPoint.SetText  ( "-" $ MakeCostString (  String ( memberData.GetPoint * -1  ) )) ;	
	}
}

function HandleResultRewardItem ( int itemCount ) 
{
	local itemInfo          info;
	local ItemWindowHandle  itemHandle;
	// 결전의 증표
	info = GetItemInfoByClassID ( 45584  ) ;//
	itemHandle = GetItemWindowHandle ( m_WindowName $".rewardItemMC" $ ".Reward_Item"  );
	itemHandle.Clear();
	// Debug ( "HandleResultRewardItem" @ info.Name @ itemCount ) ;

	GetTextBoxHandle (   m_WindowName $".rewardItemMC" $ ".Reward_Itemname_Text" ).SetText( info.Name ) ;
	GetTextBoxHandle (   m_WindowName $".rewardItemMC" $ ".Reward_Quantity_Text" ).SetText( "x" $ String ( itemCount )) ;
	// class'UIAPI_ITEMWINDOW'.static.SetItem ( m_WindowName $".rewardItemMC" $ ".Reward_Item", 0, info ) ;

	// class'UIAPI_ITEMWINDOW'.static.SetItem ( m_WindowName $".rewardItemMC" $ ".Reward_Item", 0, GetItemInfoByClassID ( 45584  ) ) ;

	itemHandle.addItem ( info );
}



// win, lose, draw 를 표현
function HandleResultImages () 
{
	local TextureHandle drawMC;
	local TextureHandle player1WinMC;
	local TextureHandle player1LoseMC;
	local TextureHandle player2WinMC;
	local TextureHandle player2LoseMC;

	drawMC =        GetTextureHandle (m_WindowName $ ".drawMC");
	player1WinMC =  GetTextureHandle (m_WindowName $ ".player1WinMC");
	player1LoseMC = GetTextureHandle (m_WindowName $ ".player1LoseMC");
	player2WinMC =  GetTextureHandle (m_WindowName $ ".player2WinMC");
	player2LoseMC = GetTextureHandle (m_WindowName $ ".player2LoseMC");
	drawMC.HideWindow();
	player1WinMC.HideWindow();
	player1LoseMC.HideWindow();
	player2WinMC.HideWindow();
	player2LoseMC.HideWindow();

	switch ( winState ) 
	{
		case IAM :
			player1WinMC.ShowWindow();
			player2LoseMC.ShowWindow();
			break;
		case YOU:
			player2WinMC.ShowWindow();
			player1LoseMC.ShowWindow();
			break;
		case NOT :
			drawMC.ShowWindow();
			break;
	}
}

//function HandleResultPlayer1Score ( MemberDataStruct  memberData, ResultDataStruct resultData )
//{
//	HandleResultPlayer (resultData, resultData,  1 ) ;
//}

//function HandleResultPlayer2Score ( MemberDataStruct resultData, ResultDataStruct resultData )
//{	
//	HandleResultPlayer (resultData, resultData,  2 ) ;
//}

function HandleResultPlayer ( MemberDataStruct  memberData, ResultDataStruct  resultData, int memberNum ) 
{
	local TextBoxHandle txtName;

	txtName = GetTextBoxHandle ( m_WindowName $".playerName"$memberNum$"Txt" );
	txtName.SetText ( memberData.PcName );
	txtName.SetTextColor ( GetOlympiadTeamColor( memberData.TeamColor ) );
	GetTextBoxHandle ( m_WindowName $".playerClass"$memberNum$"Txt" ).SetText ( GetClassType ( memberData.ClassName ) );	
	
	if ( memberData.TeamColor == resultData.set1Win - 1 ) 
	{
		GetTextureHandle ( m_WindowName $".player"$memberNum$"ScoreMC" $ ".win1SymbolMC" ).ShowWindow();
	}else 	 
		GetTextureHandle ( m_WindowName $".player"$memberNum$"ScoreMC" $ ".win1SymbolMC" ).HideWindow();

	if ( memberData.TeamColor == resultData.set2Win - 1 ) 
	{
		GetTextureHandle ( m_WindowName $".player"$memberNum$"ScoreMC" $ ".win2SymbolMC" ).ShowWindow();
	}else 	 
		GetTextureHandle ( m_WindowName $".player"$memberNum$"ScoreMC" $ ".win2SymbolMC" ).HideWindow();

	if ( memberData.TeamColor == resultData.set3Win - 1 ) 
	{
		GetTextureHandle ( m_WindowName $".player"$memberNum$"ScoreMC" $ ".win3SymbolMC" ).ShowWindow();
	}else 	 
		GetTextureHandle ( m_WindowName $".player"$memberNum$"ScoreMC" $ ".win3SymbolMC" ).HideWindow();
	
	GetTextBoxHandle ( m_WindowName $".player"$memberNum$"ScoreMC" $ ".damageText" ).SetText( MakeCostString ( String ( memberData.TotalDamage ))) ;
}
/*
function HandleResultIsVictory (WinnerDataStruct winnerData)
{	
	local HtmlHandle    resultText;
	local String        resultString1;
	local String        resultString2;
	local String        htmlAdd;
	local Rect          rectWnd;

	//if ( winnerData.winnerName  == "" ) return;
	
	resultText = GetHtmlHandle( m_WindowName $ ".resultTxt_textbox" );
	resultString1 = winnerData.winnerName;

	switch ( winnerData.teamColor )
	{
		case 0 :
			resultString1 = htmlAddText ( resultString1, "hs16", "66AAEE" );
			break;
		case 1 :
			resultString1 = htmlAddText ( resultString1, "hs16", "EE7777" );
			break;
	}
	
	resultString2 = getSystemString( 828 );
	resultString2 = htmlAddText ( resultString2, "hs16", "DCDCDC" );
	
	rectWnd = resultText.GetRect();

	// align 들이 TD 자체의 정렬이며, 
	// TD 안의 텍스트 필드의 정렬을 의미 하는 것이 아니므로, 
	// > height를 0으로 맞춘다.
	// > 혹은 TD 내부에 정렬을 설정 한다. 
	htmlAdd = htmlAddTableTD( resultString1 @ resultString2 , "center" , "center", rectWnd.nWidth, 0, "", true);

	htmlSetTableTR( htmlAdd );

	htmlAdd = "<table width=" $ rectWnd.nWidth $ " height=" $ rectWnd.nHeight $ ">" $ htmlAdd $  "</table>";
	
	resultText.LoadHtmlFromString( htmlSetHtmlStart( htmlAdd ) );
}
*/


/**************************************************************************
 * Util
 **************************************************************************/

function Color GetOlympiadTeamColor ( int teamColor ) 
{
	switch ( teamColor ) 
	{
		case 2 :
			return getColor ( 102, 170, 238, 255)  ;
			break;
		case 1 :
			return getColor ( 238, 119, 119, 255)  ;
			break;
	}

	return getColor ( 220, 220, 220, 255)  ;
}


/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( m_WindowName ).HideWindow();
}

defaultproperties
{
}
