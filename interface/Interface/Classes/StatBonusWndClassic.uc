//================================================================================
// StatBonusWndClassic.
//================================================================================

class StatBonusWndClassic extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var RichListCtrlHandle ListCtrl;

function OnLoad()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	SetClosingOnESC();
	ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".StatBonus_ListCtrl");
	ListCtrl.SetUseHorizontalScrollBar(True);
	ListCtrl.SetColumnMinimumWidth(True);
	ListCtrl.SetUseStripeBackTexture(False);
	ListCtrl.SetSelectable(false);
}

function OnClickButton(string strID)
{
	switch (strID)
	{
		case "Close_Button":
			Me.HideWindow();
			break;
	}
}

function OnShow()
{
	ResetData();
}

function ResetData()
{
	if (!Me.IsShowWindow())
	{
		return;
	}
	ListCtrl.DeleteAllItem();
	MakeRowDatas(API_GetStatBonusNameData());
}

function MakeRowDatas(array<StatBonusNameUIData> Data)
{
	local int i;
	local int myGrade;
	local UserInfo uInfo;
	local int beforeType;

	if (!GetPlayerInfo(uInfo))
	{
		return;
	}
	beforeType = -1;

	for (i = 0; i < Data.Length; i++)
	{
		if (beforeType != Data[i].Type)
		{
			beforeType = Data[i].Type;
			ListCtrl.InsertRecord(MakeRowDataHeader(beforeType));
			myGrade = GetStatusBasicByIndex(beforeType, uInfo) + GetStatusPlused(beforeType);
		}
		ListCtrl.InsertRecord(MakeRowData(Data[i].Type, Data[i].Desc, Data[i].Grade, myGrade));
	}
}

function ModifyRowData(int Index, int myGrade)
{
	local RichListCtrlRowData rowData;

	ListCtrl.GetRec(Index, rowData);
	ListCtrl.ModifyRecord(
		Index, MakeRowData(rowData.cellDataList[0].nReserved2, rowData.cellDataList[0].szData,
				   rowData.cellDataList[0].nReserved1, myGrade));
}

function HandleOnChangedStatusType(int Type)
{
	local int i;
	local int myGrade;
	local array<int> indexs;
	local UserInfo uInfo;

	if (!GetPlayerInfo(uInfo))
	{
		return;
	}
	myGrade = GetStatusBasicByIndex(Type, uInfo) + GetStatusPlused(Type);
	indexs = FindIndexsByType(Type);

	for (i = 0; i < indexs.Length; i++)
	{
		ModifyRowData(indexs[i], myGrade);
	}
}

function array<int> FindIndexsByType(int Type)
{
	local int i;
	local array<int> indexs;
	local RichListCtrlRowData rowData;


	for (i = 0; i < ListCtrl.GetRecordCount(); i++)
	{
		ListCtrl.GetRec(i, rowData);
		if (rowData.cellDataList[0].szData != "")
		{
			if (rowData.cellDataList[0].nReserved2 == Type)
			{
				indexs.Length = indexs.Length + 1;
				indexs[indexs.Length - 1] = i;
			}
		}
	}
	return indexs;
}

function RichListCtrlRowData MakeRowData(int Type, string Desc, int Grade, int myGrade)
{
	local RichListCtrlRowData rowData;
	local Color TextColor;

	rowData.cellDataList.Length = 1;
	if (myGrade < Grade)
	{
		TextColor = GetColor(153, 153, 153, 255);
	}
	else
	{
		TextColor = GetColor(255, 255, 0, 255);
	}
	rowData.cellDataList[0].szData = Desc;
	rowData.cellDataList[0].nReserved1 = Grade;
	rowData.cellDataList[0].nReserved2 = Type;
	addRichListCtrlString(rowData.cellDataList[0].drawitems, Desc, TextColor, False, 5);
	return rowData;
}

function RichListCtrlRowData MakeRowDataHeader(int Type)
{
	local string headName;
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 1;
	switch (Type)
	{
		case 0:
			headName = GetSystemString(104);
			break;
		case 1:
			headName = GetSystemString(107);
			break;
		case 2:
			headName = GetSystemString(105);
			break;
		case 3:
			headName = GetSystemString(108);
			break;
		case 4:
			headName = GetSystemString(106);
			break;
		case 5:
			headName = GetSystemString(109);
			break;
		default:
	}
	rowData.sOverlayTex = "L2UI_CT1.PlayerStatusWnd.StatsBonus_ListHeader";
	rowData.OverlayTexU = 327;
	rowData.OverlayTexV = 22;
	addRichListCtrlString(rowData.cellDataList[0].drawitems, headName, GetColor(228, 218, 197, 255), False, 22);
	return rowData;
}

function array<StatBonusNameUIData> API_GetStatBonusNameData()
{
	local array<StatBonusNameUIData> arrStatBonusNameUIData;

	GetStatBonusNameData(arrStatBonusNameUIData);
	return arrStatBonusNameUIData;
}

function int GetBonusByType(int Type, UserInfo uInfo)
{
	switch (Type)
	{
		case 0:
			return uInfo.nStrBonus;
			break;
		case 1:
			return uInfo.nIntBonus;
			break;
		case 2:
			return uInfo.nDexBonus;
			break;
		case 3:
			return uInfo.nWitBonus;
			break;
		case 4:
			return uInfo.nConBonus;
			break;
		case 5:
			return uInfo.nMenBonus;
			break;
		default:
	}
	return -1;
}

function int GetStatusBasicByIndex(int Type, UserInfo uInfo)
{
	switch (Type)
	{
		case 0:
			return uInfo.nStr;
			break;
		case 1:
			return uInfo.nInt;
			break;
		case 2:
			return uInfo.nDex;
			break;
		case 3:
			return uInfo.nWit;
			break;
		case 4:
			return uInfo.nCon;
			break;
		case 5:
			return uInfo.nMen;
			break;
		default:
	}
	return -1;
}

function int GetStatusPlused(int Type)
{
	return DetailStatusWndClassic(GetScript("DetailStatusWndClassic")).statusPlused[Type];
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
}
