//----------------------------------------------------------------------------------------------------------------------------------------------------------
//  ���� : ������ ��Ȳ (Ưȭ����) UI
// 
// 47�� ����
// 10070 SeasonMaxCount=4 nChoiceSeason=0 SeasonWinPledgeName="�Ͼ߿�" SeasonWinPledgeID=1 SeasonWinAllianceID=1 SeasonCount=3 
//----------------------------------------------------------------------------------------------------------------------------------------------------------
class SiegeReportWnd extends UICommonAPI;

const TIME_ID = 2001114;
const TIME_DELAY = 1000;

var WindowHandle Me;
var TextureHandle GroupBoxBg1_Texture;
var TextureHandle GroupBoxBg2_Texture;
var TextBoxHandle SiegeReportDiscription_text;

var WindowHandle MonthRankingNo1Wnd;
var TextBoxHandle MonthRankingNo1Wnd_Title_text;
var TextBoxHandle MonthRankingNo1Wnd_Name_text;
var TextureHandle MonthWnd_PledgeCrest_texture;
var TextureHandle MonthWnd_PledgeAllianceCrest_texture;

// ���� �� ��ŷ ������
var WindowHandle LastMonthRankingNo1Wnd;
var TextBoxHandle LastMonthRankingNo1Wnd_Title_text;
var TextBoxHandle LastMonthRankingNo1Wnd_Name_text;
var TextureHandle LastMonthWnd_PledgeCrest_texture;
var TextureHandle LastMonthWnd_PledgeAllianceCrest_texture;
var TextureHandle LastMonthWnd_Deco_texture;

// ���� ������ 
var WindowHandle EmblemRankingWnd;
var TextureHandle EmblemRankingWnd_texture;

// ��ŷ 
var WindowHandle WeekRankingWnd;

var TextBoxHandle n1WeekRanking_Title_text;
var TextBoxHandle n1WeekRanking_Name_text;
var TextureHandle n1WeekRanking_PledgeCrest_texture;
var TextureHandle n1WeekRanking_PledgeAllianceCrest_texture;
var TextureHandle n1WeekRanking_GroupBox_texture;
var TextureHandle n1WeekRanking_Divider_Texture;
var TextureHandle n1WeekRanking_Block_texture;

var TextBoxHandle n2WeekRanking_Title_text;
var TextBoxHandle n2WeekRanking_Name_text;
var TextureHandle n2WeekRanking_PledgeCrest_texture;
var TextureHandle n2WeekRanking_PledgeAllianceCrest_texture;
var TextureHandle n2WeekRanking_GroupBox_texture;
var TextureHandle n2WeekRanking_Divider_Texture;
var TextureHandle n2WeekRanking_Block_texture;

var TextBoxHandle n3WeekRanking_Title_text;
var TextBoxHandle n3WeekRanking_Name_text;
var TextureHandle n3WeekRanking_PledgeCrest_texture;
var TextureHandle n3WeekRanking_PledgeAllianceCrest_texture;
var TextureHandle n3WeekRanking_GroupBox_texture;
var TextureHandle n3WeekRanking_Divider_Texture;
var TextureHandle n3WeekRanking_Block_texture;

var TextBoxHandle n4WeekRanking_Title_text;
var TextBoxHandle n4WeekRanking_Name_text;
var TextureHandle n4WeekRanking_PledgeCrest_texture;
var TextureHandle n4WeekRanking_PledgeAllianceCrest_texture;
var TextureHandle n4WeekRanking_GroupBox_texture;
var TextureHandle n4WeekRanking_Block_texture;

var TextBoxHandle n5WeekRanking_Title_text;
var TextBoxHandle n5WeekRanking_Name_text;
var TextureHandle n5WeekRanking_PledgeCrest_texture;
var TextureHandle n5WeekRanking_PledgeAllianceCrest_texture;
var TextureHandle n5WeekRanking_GroupBox_texture;
var TextureHandle n5WeekRanking_Block_texture;
var TextureHandle n5WeekRanking_Divider_Texture;

var TextureHandle n5WeekRanking_Flag_texture;

var ButtonHandle CloseButton;
var ButtonHandle GetButton;

var int nSeasonCastleID;  // ��ID
var int nChoiceSeason;    // 0:�̹���, 1: ������

var string refreshCastleWarSeasonResultStr;

//----------------------------------------------------------------------------------------------------------------------------
// OnRegisterEvent, OnLoad
//----------------------------------------------------------------------------------------------------------------------------
function OnRegisterEvent()
{
	RegisterEvent( EV_CastleWarSeasonResult );  // 10071
	RegisterEvent( EV_CastleWarSeasonReward ); // 10070
}

function OnLoad()
{
	Initialize();
}

function OnHide()
{
	Me.KillTimer( TIME_ID );
}

//----------------------------------------------------------------------------------------------------------------------------
// Initialize
//----------------------------------------------------------------------------------------------------------------------------
function Initialize()
{
	Me = GetWindowHandle( "SiegeReportWnd" );

	GroupBoxBg1_Texture = GetTextureHandle( "SiegeReportWnd.GroupBoxBg1_Texture" );
	GroupBoxBg2_Texture = GetTextureHandle( "SiegeReportWnd.GroupBoxBg2_Texture" );

	SiegeReportDiscription_text = GetTextBoxHandle( "SiegeReportWnd.SiegeReportDiscription_text" );

	MonthRankingNo1Wnd = GetWindowHandle( "SiegeReportWnd.MonthRankingNo1Wnd" );
	MonthRankingNo1Wnd_Title_text = GetTextBoxHandle( "SiegeReportWnd.MonthRankingNo1Wnd.MonthRankingNo1Wnd_Title_text" );
	MonthRankingNo1Wnd_Name_text = GetTextBoxHandle( "SiegeReportWnd.MonthRankingNo1Wnd.MonthRankingNo1Wnd_Name_text" );
	MonthWnd_PledgeCrest_texture = GetTextureHandle( "SiegeReportWnd.MonthRankingNo1Wnd.MonthWnd_PledgeCrest_texture" );
	MonthWnd_PledgeAllianceCrest_texture = GetTextureHandle( "SiegeReportWnd.MonthRankingNo1Wnd.MonthWnd_PledgeAllianceCrest_texture" );

	LastMonthRankingNo1Wnd = GetWindowHandle( "SiegeReportWnd.LastMonthRankingNo1Wnd" );
	LastMonthRankingNo1Wnd_Title_text = GetTextBoxHandle( "SiegeReportWnd.LastMonthRankingNo1Wnd.LastMonthRankingNo1Wnd_Title_text" );
	LastMonthRankingNo1Wnd_Name_text = GetTextBoxHandle( "SiegeReportWnd.LastMonthRankingNo1Wnd.LastMonthRankingNo1Wnd_Name_text" );
	LastMonthWnd_PledgeCrest_texture = GetTextureHandle( "SiegeReportWnd.LastMonthRankingNo1Wnd.LastMonthWnd_PledgeCrest_texture" );
	LastMonthWnd_PledgeAllianceCrest_texture = GetTextureHandle( "SiegeReportWnd.LastMonthRankingNo1Wnd.LastMonthWnd_PledgeAllianceCrest_texture" );
	LastMonthWnd_Deco_texture = GetTextureHandle( "SiegeReportWnd.LastMonthRankingNo1Wnd.LastMonthWnd_Deco_texture" );

	EmblemRankingWnd = GetWindowHandle( "SiegeReportWnd.EmblemRankingWnd" );
	EmblemRankingWnd_texture = GetTextureHandle( "SiegeReportWnd.EmblemRankingWnd.EmblemRankingWnd_texture" );
	WeekRankingWnd  = GetWindowHandle( "SiegeReportWnd.WeekRankingWnd" );

	// 1~5���� 
	n1WeekRanking_Title_text = GetTextBoxHandle( "SiegeReportWnd.WeekRankingWnd.n1WeekRanking_Title_text" );
	n1WeekRanking_Name_text = GetTextBoxHandle( "SiegeReportWnd.WeekRankingWnd.n1WeekRanking_Name_text" );
	n1WeekRanking_PledgeCrest_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n1WeekRanking_PledgeCrest_texture" );
	n1WeekRanking_PledgeAllianceCrest_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n1WeekRanking_PledgeAllianceCrest_texture" );
	n1WeekRanking_GroupBox_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n1WeekRanking_GroupBox_texture" );
	n1WeekRanking_Divider_Texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n1WeekRanking_Divider_Texture" );
	n1WeekRanking_Block_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n1WeekRanking_Block_texture" );

	n2WeekRanking_Title_text = GetTextBoxHandle( "SiegeReportWnd.WeekRankingWnd.n2WeekRanking_Title_text" );
	n2WeekRanking_Name_text = GetTextBoxHandle( "SiegeReportWnd.WeekRankingWnd.n2WeekRanking_Name_text" );
	n2WeekRanking_PledgeCrest_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n2WeekRanking_PledgeCrest_texture" );
	n2WeekRanking_PledgeAllianceCrest_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n2WeekRanking_PledgeAllianceCrest_texture" );
	n2WeekRanking_GroupBox_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n2WeekRanking_GroupBox_texture" );
	n2WeekRanking_Divider_Texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n2WeekRanking_Divider_Texture" );
	n2WeekRanking_Block_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n2WeekRanking_Block_texture" );

	n3WeekRanking_Title_text = GetTextBoxHandle( "SiegeReportWnd.WeekRankingWnd.n3WeekRanking_Title_text" );
	n3WeekRanking_Name_text = GetTextBoxHandle( "SiegeReportWnd.WeekRankingWnd.n3WeekRanking_Name_text" );
	n3WeekRanking_PledgeCrest_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n3WeekRanking_PledgeCrest_texture" );
	n3WeekRanking_PledgeAllianceCrest_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n3WeekRanking_PledgeAllianceCrest_texture" );
	n3WeekRanking_GroupBox_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n3WeekRanking_GroupBox_texture" );
	n3WeekRanking_Divider_Texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n3WeekRanking_Divider_Texture" );
	n3WeekRanking_Block_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n3WeekRanking_Block_texture" );

	n4WeekRanking_Title_text = GetTextBoxHandle( "SiegeReportWnd.WeekRankingWnd.n4WeekRanking_Title_text" );
	n4WeekRanking_Name_text = GetTextBoxHandle( "SiegeReportWnd.WeekRankingWnd.n4WeekRanking_Name_text" );
	n4WeekRanking_PledgeCrest_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n4WeekRanking_PledgeCrest_texture" );
	n4WeekRanking_PledgeAllianceCrest_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n4WeekRanking_PledgeAllianceCrest_texture" );
	n4WeekRanking_GroupBox_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n4WeekRanking_GroupBox_texture" );
	n4WeekRanking_Block_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n4WeekRanking_Block_texture" );

	n5WeekRanking_Title_text = GetTextBoxHandle( "SiegeReportWnd.WeekRankingWnd.n5WeekRanking_Title_text" );
	n5WeekRanking_Name_text = GetTextBoxHandle( "SiegeReportWnd.WeekRankingWnd.n5WeekRanking_Name_text" );
	n5WeekRanking_PledgeCrest_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n5WeekRanking_PledgeCrest_texture" );
	n5WeekRanking_PledgeAllianceCrest_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n5WeekRanking_PledgeAllianceCrest_texture" );
	n5WeekRanking_GroupBox_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n5WeekRanking_GroupBox_texture" );
	n5WeekRanking_Block_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n5WeekRanking_Block_texture" );
	n5WeekRanking_Divider_Texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n5WeekRanking_Flag_texture" );
	n5WeekRanking_Flag_texture = GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n5WeekRanking_Flag_texture" );

	// ��ư 
	CloseButton = GetButtonHandle( "SiegeReportWnd.CloseButton" );
	GetButton = GetButtonHandle( "SiegeReportWnd.GetButton" );
}

//----------------------------------------------------------------------------------------------------------------------------
// Event, Click Handler
//----------------------------------------------------------------------------------------------------------------------------
function OnTimer( int TimerID )
{	
	if(TimerID == TIME_ID)
	{
		CastleWarSeasonResultHandler(refreshCastleWarSeasonResultStr, true);
		Me.KillTimer( TIME_ID );
	}
}

function OnEvent(int Event_ID, String param)
{
	if (Event_ID == EV_CastleWarSeasonResult)
	{		
		refreshCastleWarSeasonResultStr = param;
		CastleWarSeasonResultHandler(param);
		Debug("EV_CastleWarSeasonResult:" @ param);
	}
	else if (Event_ID == EV_CastleWarSeasonReward)
	{
		CastleWarSeasonRewardHandler(param);
		Debug("EV_CastleWarSeasonReward:" @ param);
	}
}

// ���� ���� �����ֱ�
function CastleWarSeasonResultHandler(string param, optional bool bIgnoreTexUpdate)
{
	local string seasonWinPledgeName;

	local int seasonCount, n, nWeek, nButtonType, nSeasonWinPledgeID, nSeasonWinAllianceID, nSeasonMaxCount;

	local bool bShowEmble;

	nSeasonCastleID = 0;

	ParseInt(param, "SeasonMaxCount", nSeasonMaxCount);  // 0:�̹���, 1:������ 
	
	// 4, 5�� �����ִ� ��Ȳ�� ���� ������ ������ ����
	if (nSeasonMaxCount <= 4 && nSeasonMaxCount > 0) 
	{
		// 4�ָ� ���̰�..
		Me.SetWindowSize(328, 473 - 69);
		showLastWeekGroup(false);
	}
	else 
	{
		// 5�ָ� ���̰�.. 0�ֳ� �߸��� ���� ���͵� 5�ַ� ���̵��� �Ѵ�(����Ʈ)
		Me.SetWindowSize(328, 477);
		showLastWeekGroup(true);
	}

	//------------------------------------
	// ���� �Ǵ� ������ 1�� ���� �Է�
	//------------------------------------
	ParseInt(param, "ChoiceSeason", nChoiceSeason);  // 0:�̹���, 1:������ 

	ParseString(param, "SeasonWinPledgeName", seasonWinPledgeName);  // ��� ���͸�
	ParseInt(param, "SeasonWinPledgeID"     , nSeasonWinPledgeID);   // ��� ����ID
	ParseInt(param, "SeasonWinAllianceID"   , nSeasonWinAllianceID); // ��� ����ID
	
	setMonthlyWinnerInfo(seasonWinPledgeName, nSeasonWinPledgeID, nSeasonWinAllianceID, bIgnoreTexUpdate);

	//------------------------------------
	// 1~5�� ī��Ʈ
	//------------------------------------
	ParseInt   (param, "SeasonCount"  , seasonCount); // �¸� ���� �� ī��Ʈ(3�̸� 3��ġ �̷���..)

	bShowEmble = true;
	for (n = 1; n <= nSeasonMaxCount; n++)
	{  
		ParseString(param, "WeekWinPledgeName_" $ n, seasonWinPledgeName); // n ���� ��� ���͸�

		ParseInt(param, "WeekNum_" $ n          , nWeek);                  // n ����		
		ParseInt(param, "WeekWinPledgeID_" $ n  , nSeasonWinPledgeID);     // n ���� ��� ����ID
		ParseInt(param, "WeekWinAllianceID_" $ n, nSeasonWinAllianceID);   // n ���� ��� ����ID
		
		setWeekWinnerInfo(n, seasonWinPledgeName, nSeasonWinPledgeID, nSeasonWinAllianceID, (seasonCount < n), bIgnoreTexUpdate);

		if (seasonWinPledgeName != "") bShowEmble = false;
	}

	ParseInt(param, "ButtonType"     , nButtonType);     // 0:�ݱ�, 1:����ޱ�
	ParseInt(param, "SeasonCastleID" , nSeasonCastleID); // ���� �� ��ȣ (���� �ϳ��� �ϳ� �̻��� ���� ���� ������ ������ ���ؼ�..)


	if(nChoiceSeason > 0) 
	{
		// ���� �� ������ ��Ȳ
		setWindowTitleByString(GetSystemString(3408));
	}
	else
	{
		// �̹� �� ������ ��Ȳ
		setWindowTitleByString(GetSystemString(3407));
	}

	// �ݱ�, ����ޱ� ��ư 
	if(nButtonType == 0)
	{
		CloseButton.ShowWindow();
		GetButton.HideWindow();
	}
	else
	{
		CloseButton.HideWindow();
		GetButton.ShowWindow();
	}

	// ���� �����ֱ� ����
	if(bShowEmble) 
	{
		// �̹� �޸� : �������� ����� �����Դϴ�.. �� �̷� ������ �����ش�.
		if (nChoiceSeason == 0)
		{
			SiegeReportDiscription_text.ShowWindow();
			MonthRankingNo1Wnd.HideWindow();
			LastMonthRankingNo1Wnd.HideWindow();
		}
		else 
		{
			SiegeReportDiscription_text.HideWindow();
		}

		EmblemRankingWnd.ShowWindow();
		WeekRankingWnd.HideWindow();
	}
	else 
	{		
		SiegeReportDiscription_text.HideWindow();
		EmblemRankingWnd.HideWindow();
		WeekRankingWnd.ShowWindow();
	}

	Me.ShowWindow();
	Me.SetFocus();

	if (!bIgnoreTexUpdate)
	{
		// 1���Ŀ� ��ü�� ���÷��� �Ͽ�, ����, ���� �������� �ٿ�Ǿ����� ���ŵǵ��� �Ѵ�.
		// 1���Ŀ��� �ȵ�� ���� ��¿ �� ����. ����
		Me.KillTimer( TIME_ID );
		Me.SetTimer(TIME_ID, TIME_DELAY);
	}
}

// ���� �¸� ���� ���� �Է�
// bIgnoreTexUpdate �� true�̸� ����, ���� �ؽ��� ������Ʈ�� ���� �ʴ´�.
function setWeekWinnerInfo(int nWeek, string winnerName, int pledgeCrestId, int allianceCrestId, bool showBlock, optional bool bIgnoreTexUpdate)
{
	local texture texPledge;
	local texture texAlliance;

	local bool bPledge, bAlliance;
	
	if (nWeek <= 0 || nWeek > 5) { Debug("SigeReportWnd : nWeek�� 1~5 ���� �ƴմϴ�." @ nWeek); return; }

	// ������ ���ٸ� ������ �ݴ´�.
	if (showBlock) GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n" $ String(nWeek) $ "WeekRanking_Block_texture" ).ShowWindow();
	else GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n" $ String(nWeek) $ "WeekRanking_Block_texture" ).HideWindow();

	// ���͸� 
	if (winnerName == "") 
	{
		GetTextBoxHandle( "SiegeReportWnd.WeekRankingWnd.n" $ String(nWeek) $ "WeekRanking_Name_text" ).SetText(GetSystemString(3416)); // �¸� ���� ����
		return;
	}
	else
	{
		GetTextBoxHandle( "SiegeReportWnd.WeekRankingWnd.n" $ String(nWeek) $ "WeekRanking_Name_text" ).SetText(winnerName);
	}

	// ���ÿ��� ����, ���� �ؽ��ĸ� ���� �ͼ� ������ �״�� ���, ������ ��û �� ���̴�.
	bPledge   = class'UIDATA_CLAN'.static.GetCrestTexture(pledgeCrestId, texPledge);
	bAlliance = class'UIDATA_CLAN'.static.GetAllianceCrestTexture(pledgeCrestId, texAlliance);

	// ---  ����, ���� �ؽ��İ� �ִٸ� ����, ���ٸ� ������ ��û ---
	// ����
	if(bPledge) GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n" $ String(nWeek) $ "WeekRanking_PledgeCrest_texture" ).SetTextureWithObject(texPledge);
	else 
	{
		if(!bIgnoreTexUpdate) texPledge = GetPledgeCrestTexFromPledgeCrestID(pledgeCrestId);
	}

	// ����
	if(bAlliance) GetTextureHandle( "SiegeReportWnd.WeekRankingWnd.n" $ String(nWeek) $ "WeekRanking_PledgeAllianceCrest_texture" ).SetTextureWithObject(texAlliance);
	else 
	{
		if(!bIgnoreTexUpdate) texAlliance = GetAllianceCrestTexFromAllianceCrestID(allianceCrestId);
	}
}

function showLastWeekGroup(bool bShow)
{
	if (bShow)
	{
		n5WeekRanking_Title_text.ShowWindow();
		n5WeekRanking_Name_text.ShowWindow();
		n5WeekRanking_PledgeCrest_texture.ShowWindow();
		n5WeekRanking_PledgeAllianceCrest_texture.ShowWindow();
		n5WeekRanking_GroupBox_texture.ShowWindow();
		n5WeekRanking_Block_texture.ShowWindow();
		n5WeekRanking_Divider_Texture.ShowWindow();
		n5WeekRanking_Flag_texture.ShowWindow();
	}
	else
	{
		n5WeekRanking_Title_text.HideWindow();
		n5WeekRanking_Name_text.HideWindow();
		n5WeekRanking_PledgeCrest_texture.HideWindow();
		n5WeekRanking_PledgeAllianceCrest_texture.HideWindow();
		n5WeekRanking_GroupBox_texture.HideWindow();
		n5WeekRanking_Block_texture.HideWindow();
		n5WeekRanking_Divider_Texture.HideWindow();
		n5WeekRanking_Flag_texture.HideWindow();
	}
}


// �Ŵ� ����� ���� �Է�
function setMonthlyWinnerInfo(string winnerName, int pledgeCrestId, int allianceCrestId, optional bool bIgnoreTexUpdate)
{
	local texture texPledge;
	local texture texAlliance;

	local bool bPledge, bAlliance;

	// ���ÿ��� ����, ���� �ؽ��ĸ� ���� �ͼ� ������ �״�� ���, ������ ��û �� ���̴�.
	bPledge   = class'UIDATA_CLAN'.static.GetCrestTexture(pledgeCrestId, texPledge);
	bAlliance = class'UIDATA_CLAN'.static.GetAllianceCrestTexture(pledgeCrestId, texAlliance);

	// �̹� ��
	if (nChoiceSeason == 0)
	{
		MonthRankingNo1Wnd.ShowWindow();
		LastMonthRankingNo1Wnd.HideWindow();

		if (winnerName == "")
			MonthRankingNo1Wnd_Name_text.SetText(GetSystemString(3416)); // �¸����� ����
		else
			MonthRankingNo1Wnd_Name_text.SetText(winnerName);

		// ---  ����, ���� �ؽ��İ� �ִٸ� ����, ���ٸ� ������ ��û ---
		// ����
		if(bPledge) MonthWnd_PledgeCrest_texture.SetTextureWithObject(texPledge);
		else 
		{
			if(!bIgnoreTexUpdate) texPledge = GetPledgeCrestTexFromPledgeCrestID(pledgeCrestId);
		}
		// ����
		if(bAlliance) MonthWnd_PledgeAllianceCrest_texture.SetTextureWithObject(texAlliance);
		else
		{
			if(!bIgnoreTexUpdate) texAlliance = GetAllianceCrestTexFromAllianceCrestID(allianceCrestId);
		}
	}
	// ���� �� 
	else
	{
		MonthRankingNo1Wnd.HideWindow();
		LastMonthRankingNo1Wnd.ShowWindow();

		if (winnerName == "")
			LastMonthRankingNo1Wnd_Name_text.SetText(GetSystemString(3416)); // �¸����� ����
		else
			LastMonthRankingNo1Wnd_Name_text.SetText(winnerName);

		// ---  ����, ���� �ؽ��İ� �ִٸ� ����, ���ٸ� ������ ��û ---
		// ����
		if(bPledge) LastMonthWnd_PledgeCrest_texture.SetTextureWithObject(texPledge);
		else 
		{
			if(!bIgnoreTexUpdate) texPledge = GetPledgeCrestTexFromPledgeCrestID(pledgeCrestId);
		}
		// ����
		if(bAlliance) LastMonthWnd_PledgeAllianceCrest_texture.SetTextureWithObject(texAlliance);
		else 
		{
			if(!bIgnoreTexUpdate) texAlliance = GetAllianceCrestTexFromAllianceCrestID(allianceCrestId);
		}
	}
}


// ���� �ޱ� ���  
function CastleWarSeasonRewardHandler(string paramStr)
{
	local int nResult;

	//ParseString
	ParseInt(paramStr, "Result", nResult);

	//Me.HideWindow();

}

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "CloseButton":
			 OnCloseButtonClick();
			 break;

		case "GetButton":
			 OnGetButtonClick();
			 break;
	}
}

function OnCloseButtonClick()
{
	Me.HideWindow();
}

function OnGetButtonClick()
{
	if (nSeasonCastleID > 0) RequestCastleWarSeasonReward(nSeasonCastleID);
	else Debug("nSeasonCastleID ������ 0�� ���ų� �۽��ϴ�.");

	Me.HideWindow();
}


//----------------------------------------------------------------------------------------------------------------------------
// UI Process
//----------------------------------------------------------------------------------------------------------------------------

defaultproperties
{
}
