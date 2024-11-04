//================================================================================
// FestivalRankingBonusWnd.
// emu-dev.ru
//================================================================================
class FestivalRankingBonusWnd extends UICommonAPI
	dependson(FestivalRankingWnd);

enum REWARD_STATE
{
	non,
	Reward,
	Completed
};

var WindowHandle Me;
var string m_WindowName;
var RichListCtrlHandle ListCtrl;
var FestivalRankingWnd festivalRankingWndScript;
var INT64 myAmount;
var array<UIPacket._RFBonusInfo> _bonusInfos;
var array<int> _receivedPoints;
var ButtonHandle TakeAll_Btn;
var int MyIndex;
var int completedRewardNum;

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	TakeAll_Btn = GetButtonHandle(m_WindowName $ ".TakeAll_Btn");
	TakeAll_Btn.DisableWindow();
	festivalRankingWndScript = FestivalRankingWnd(GetScript("festivalRankingWnd"));
	ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".Bonus_ListCtrl");
	ListCtrl.SetSelectable(false);
	ListCtrl.SetAppearTooltipAtMouseX(true);
	ListCtrl.SetSelectedSelTooltip(false);
	ListCtrl.SetTooltipType("SellItemList");
}

event OnShow()
{
	GetRichListCtrlHandle(m_WindowName $ ".Bonus_ListCtrl").SetStartRow(MyIndex);
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

event OnClickButton(string Name)
{
	local array<int> Points;

	if(Left(Name, 7) == "btnInfo")
	{
		Points[Points.Length] = int(Right(Name, Len(Name) - 7));
		festivalRankingWndScript.API_RequestRankingFestivalBonus(Points);		
	}
	else
	{
		if(Name == "TakeAll_Btn")
		{
			HandleReceiveAll();
		}
	}
}

event OnHide()
{
	TakeAll_Btn.DisableWindow();
}

function HandleReceiveAll()
{
	local int i;
	local array<int> Points;

	for(i = 0; i < completedRewardNum; i++)
	{
		if((GetReceivedIndexByPoint(_bonusInfos[i].nPoint)) == -1)
		{
			Points[Points.Length] = _bonusInfos[i].nPoint;
		}
	}
	festivalRankingWndScript.C_EX_RANKING_FESTIVAL_BONUS(Points);
}

function Show()
{
	Me.ShowWindow();
	Me.SetFocus();
}

function SetMyAmount(INT64 Amount)
{
	myAmount = Amount;
	SetBonusList(_bonusInfos);
}

function AddBonusReceived(array<int> addedPoints)
{
	local int i;

	for(i = 0; i < addedPoints.Length; i++)
	{
		_receivedPoints[_receivedPoints.Length] = addedPoints[i];
	}
	SetBonusReceived(_receivedPoints);
}

function SetBonusReceived(array<int> receivedPoints)
{
	local int i, Index;
	local ItemInfo iInfo;

	_receivedPoints = receivedPoints;

	for(i = 0; i < _receivedPoints.Length; i++)
	{
		Index = GetIndexByPoint(_receivedPoints[i]);

		if(Index == -1)
		{
			continue;
		}
		iInfo = GetItemInfoByClassID(_bonusInfos[Index].nRewardItemClassId);
		iInfo.ItemNum = _bonusInfos[Index].nRewardItemAmount;
		ListCtrl.ModifyRecord(Index, MakeRecordBonus(_bonusInfos[Index].nPoint, iInfo, REWARD_STATE.Completed));
	}
	CheckCanReard();
}

function int GetReceivedIndexByPoint(int point)
{
	local int i;

	for(i = 0; i < _receivedPoints.Length; i++)
	{
		if(_receivedPoints[i] == point)
		{
			return i;
		}
	}
	return -1;
}

function SetBonusList(array<UIPacket._RFBonusInfo> bonusInfos)
{
	local int i;
	local ItemInfo iInfo;
	local REWARD_STATE RewardState;

	ListCtrl.DeleteAllItem();
	_bonusInfos = bonusInfos;
	completedRewardNum = _bonusInfos.Length;
	MyIndex = -1;

	for(i = 0; i < _bonusInfos.Length; i++)
	{
		iInfo = GetItemInfoByClassID(bonusInfos[i].nRewardItemClassId);
		iInfo.ItemNum = bonusInfos[i].nRewardItemAmount;

		if(myAmount < int64(bonusInfos[i].nPoint))
		{
			-- completedRewardNum;
			RewardState = non;			
		}
		else if(GetReceivedIndexByPoint(bonusInfos[i].nPoint) == -1)
		{
			RewardState = reward;

			if(MyIndex == -1)
			{
				MyIndex = i;
			}
		}
		else
		{
			RewardState = Completed;
		}
		ListCtrl.InsertRecord(MakeRecordBonus(bonusInfos[i].nPoint, iInfo, RewardState));
	}
	CheckCanReard();
	ListCtrl.SetStartRow(MyIndex);
}

function CheckCanReard()
{
	if(completedRewardNum <= _receivedPoints.Length)
	{
		festivalRankingWndScript.SetGiftBox(false);
		TakeAll_Btn.DisableWindow();		
	}
	else
	{
		festivalRankingWndScript.SetGiftBox(true);
		TakeAll_Btn.EnableWindow();
	}
}

function RichListCtrlRowData MakeRecordBonus(int ItemNum, ItemInfo iInfo, REWARD_STATE Type)
{
	local RichListCtrlRowData Record;
	local Color nameTextColor, numTextColor, btnTextColor;
	local int nWidth, nHeight;
	local string btnString, param;

	Record.cellDataList.Length = 3;
	ItemInfoToParam(iInfo, param);
	Record.szReserved = param;
	switch(Type)
	{
		case REWARD_STATE.non:
			numTextColor = GetColor(255, 221, 102, 255);
			break;
		case REWARD_STATE.reward:
			numTextColor = GetColor(255, 255, 255, 255);
			break;
		case REWARD_STATE.Completed:
			numTextColor = GetColor(153, 153, 153, 255);
			break;
	}
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, GetTextureByType(Type), 64, 64, 0, 1, 64, 64);
	GetTextSizeDefault(string(ItemNum), nWidth, nHeight);
	addRichListCtrlString(Record.cellDataList[0].drawitems, string(ItemNum), numTextColor, false, -64 + nWidth / 2, (64 - nHeight) / 2);
	addRichListCtrlTexture(Record.cellDataList[1].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_DF_Slotbox_2x2", 36, 36, 0, 1);
	addRichListCtrlTexture(Record.cellDataList[1].drawitems, iInfo.IconName, 36, 36, -36, 0);
	switch(Type)
	{
		case REWARD_STATE.non:
			nameTextColor = GetColor(153, 153, 153, 255);
			numTextColor = GetColor(153, 153, 153, 255);
			addRichListCtrlButton(Record.cellDataList[2].drawitems, "NotEnough_btnInfo" $ string(ItemNum), 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DF_Button_Disable", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DF_Button_Disable", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DF_Button_Disable", 90, 30);
			btnString = GetSystemString(1737);
			btnTextColor = GetColor(153, 153, 153, 255);
			break;
		case REWARD_STATE.reward:
			nameTextColor = GetColor(255, 255, 255, 255);
			numTextColor = GetColor(255, 221, 102, 255);
			addRichListCtrlTexture(Record.cellDataList[1].drawitems, "L2UI_ct1.FestivalWnd.FestivalWnd_ItemSlot", 36, 36, -38, -2);
			addRichListCtrlButton(Record.cellDataList[2].drawitems, "btnInfo" $ string(ItemNum), 0, 0, "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_DF_Button", "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_DF_Button_Down", "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_DF_Button_Over", 90, 30);
			btnString = GetSystemString(1737);
			btnTextColor = GetColor(230, 220, 190, 255);
			break;
		case REWARD_STATE.Completed:
			addRichListCtrlTexture(Record.cellDataList[1].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_IconDisable", 36, 36, -36, 0);
			nameTextColor = GetColor(153, 153, 153, 255);
			numTextColor = GetColor(153, 153, 153, 255);
			addRichListCtrlTexture(Record.cellDataList[1].drawitems, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_CheckAni0015", 25, 21, -36, 0);
			addRichListCtrlButton(Record.cellDataList[2].drawitems, "completed_btnInfo" $ string(ItemNum), 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DF_Button_Disable", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DF_Button_Disable", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DF_Button_Disable", 90, 30);
			btnString = GetSystemString(898);
			btnTextColor = GetColor(153, 153, 153, 255);
			break;
	}
	addRichListCtrlString(Record.cellDataList[1].drawitems, iInfo.Name, nameTextColor, true, 40, -31);
	addRichListCtrlString(Record.cellDataList[1].drawitems, "x" $ MakeCostString(string(iInfo.ItemNum)), numTextColor, true, 40, 0);
	GetTextSizeDefault(btnString, nWidth, nHeight);
	addRichListCtrlString(Record.cellDataList[2].drawitems, btnString, btnTextColor, false, -90 + nWidth / 2, (30 - nHeight) / 2);
	return Record;
}

function string GetTextureByType(REWARD_STATE Type)
{
	switch(Type)
	{
		case REWARD_STATE.non:
			return "L2UI_EPIC.RankingFestivalWnd.RewardYellowBg";
			break;
		case REWARD_STATE.reward:
			return "L2UI_EPIC.RankingFestivalWnd.RewardBlueBg";
			break;
		case REWARD_STATE.Completed:
			return "L2UI_EPIC.RankingFestivalWnd.RewardGrayBg";
			break;
	}
}

function int GetIndexByPoint(int point)
{
	local int i;

	for(i = 0; i < _bonusInfos.Length; i++)
	{
		if(_bonusInfos[i].nPoint == point)
		{
			return i;
		}
	}
	return -1;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
}