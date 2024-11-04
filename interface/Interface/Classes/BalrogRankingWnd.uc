class BalrogRankingWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle ServerRichListFrame;
var RichListCtrlHandle Ranking_RichList;
var ButtonHandle ReFresh_btn;
var TextureHandle RankingBg2;
var UserInfo myInfo;
var string m_WindowName;
var bool bIAmRanker;
var int myRankingInList;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_BALROGWAR_SHOW_RANKING);
	RegisterEvent(EV_Restart);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle("BalrogRankingWnd");
	ServerRichListFrame = GetTextureHandle("BalrogRankingWnd.ServerRichListFrame");
	Ranking_RichList = GetRichListCtrlHandle("BalrogRankingWnd.Ranking_RichList");
	ReFresh_btn = GetButtonHandle("BalrogRankingWnd.ReFresh_btn");
	RankingBg2 = GetTextureHandle("BalrogRankingWnd.RankingBg2");
}

function Load()
{
}

function OnShow()
{
	GetPlayerInfo(myInfo);
	API_C_EX_BALROGWAR_SHOW_RANKING();
}

function OnHide()
{
	Ranking_RichList.DeleteAllItem();
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x20
		case "ReFresh_btn":
			OnReFresh_btnClick();
			// End:0x23
			break;
	}
}

function OnReFresh_btnClick()
{
	API_C_EX_BALROGWAR_SHOW_RANKING();
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_BALROGWAR_SHOW_RANKING):
			ParsePacket_S_EX_BALROGWAR_SHOW_RANKING();
			// End:0x2A
			break;
	}
}

function ParsePacket_S_EX_BALROGWAR_SHOW_RANKING()
{
	local UIPacket._S_EX_BALROGWAR_SHOW_RANKING packet;
	local int i, nStartRow;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_BALROGWAR_SHOW_RANKING(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_BALROGWAR_SHOW_RANKING :  " @ string(packet.rankingList.Length));
	bIAmRanker = false;
	myRankingInList = 0;
	Ranking_RichList.DeleteAllItem();
	// End:0x179
	if(packet.rankingList.Length > 0)
	{
		GetWindowHandle("BalrogRankingWnd.Disable_Wnd").HideWindow();

		// End:0x126 [Loop If]
		for(i = 0; i < packet.rankingList.Length; i++)
		{
			addRanking(packet.rankingList[i].nRank, packet.rankingList[i].sName, packet.rankingList[i].nPoint);
		}
		// End:0x176
		if(bIAmRanker)
		{
			nStartRow = myRankingInList - 3;
			// End:0x176
			if(nStartRow > 0)
			{
				// End:0x176
				if(Ranking_RichList.GetRecordCount() > nStartRow)
				{
					Ranking_RichList.SetStartRow(nStartRow);
				}
			}
		}		
	}
	else
	{
		GetWindowHandle("BalrogRankingWnd.Disable_Wnd").ShowWindow();
	}
}

function addRanking(int nRank, string sName, int nPoint)
{
	local RichListCtrlRowData RowData;
	local string texStr;

	RowData.cellDataList.Length = 3;
	// End:0xF8
	if(nRank <= 3 && nRank > 0)
	{
		// End:0x5F
		if(nRank == 1)
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_1st";			
		}
		else if(nRank == 2)
		{

			texStr = "L2UI_ct1.RankingWnd.RankingWnd_2nd";				
		}
		else if(nRank == 3)
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_3rd";
		}

		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, texStr, 38, 33, -35, 5);		
	}
	else
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, string(nRank), getInstanceL2Util().White, false, -25, 12);
	}
	addRichListCtrlString(RowData.cellDataList[1].drawitems, sName, GTColor().White, false, 4, -4);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, MakeCostString(string(nPoint)), GTColor().White, false, 0, 0);
	// End:0x1FF
	if(myInfo.Name == sName)
	{
		RowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";
		bIAmRanker = true;
		myRankingInList = Ranking_RichList.GetRecordCount();		
	}
	else
	{
		RowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
	}
	RowData.OverlayTexU = 734;
	RowData.OverlayTexV = 45;
	Ranking_RichList.InsertRecord(RowData);
}

function API_C_EX_BALROGWAR_SHOW_RANKING()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_BALROGWAR_SHOW_RANKING, stream);
	Debug("--> C_EX_BALROGWAR_SHOW_RANKING");
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_WindowName="BalrogRankingWnd"
}
