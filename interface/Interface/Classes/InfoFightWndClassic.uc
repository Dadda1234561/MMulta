class InfoFightWndClassic extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var RichListCtrlHandle Category_ListCtrl;
var RichListCtrlHandle FightInfo_ListCtrl;
var TextBoxHandle InfoFightIMGTitle_txt;
var array<L2CharacterAbilityUIData> AbilityData;
var array<string> Category;
var array<int> CategoryNum;
var array<int> CategoryValue;
var array<UIPacket._PkUserViewInfoParameter> Parameters;
var bool initBool;
var int SelectStartNum;
var int SelectEndNum;

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_USER_VIEW_INFO_PARAMETER);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Me.EnableWindow();
}

function Initialize()
{
	Me = GetWindowHandle("InfoFightWndClassic");
	Category_ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".Category_ListCtrl");
	FightInfo_ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".FightInfo_ListCtrl");
	InfoFightIMGTitle_txt = GetTextBoxHandle(m_WindowName $ ".InfoFightIMGTitle_txt");
	Category_ListCtrl.SetUseStripeBackTexture(false);
	FightInfo_ListCtrl.SetSelectable(false);
	FightInfo_ListCtrl.SetSelectedSelTooltip(false);
	FightInfo_ListCtrl.SetAppearTooltipAtMouseX(true);
	initBool = false;
}

function InsertCategory(string Value)
{
	local int i;

	// End:0x52 [Loop If]
	for(i = 0; i < Category.Length; i++)
	{
		// End:0x48
		if(Category[i] == Value)
		{
			CategoryNum[i] = CategoryNum[i] + 1;
			return;
		}
	}
	Category.Insert(Category.Length, 1);
	Category[Category.Length - 1] = Value;
	CategoryNum.Insert(CategoryNum.Length, 1);
	CategoryNum[CategoryNum.Length - 1] = 1;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x55
		case 40:
			initBool = false;
			FightInfo_ListCtrl.DeleteAllItem();
			Category_ListCtrl.DeleteAllItem();
			Parameters.Length = 0;
			Category.Length = 0;
			CategoryNum.Length = 0;
			CategoryValue.Length = 0;
			// End:0x8B
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_USER_VIEW_INFO_PARAMETER:
			// End:0x7F
			if(initBool == false)
			{
				InitData();
			}
			S_EX_USER_VIEW_INFO_PARAMETER();
			break;
	}
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "Category_ListCtrl":
			FightInfo_ListCtrl.DeleteAllItem();
			FightInfoAdd();
			break;	
	}
}

function S_EX_USER_VIEW_INFO_PARAMETER()
{
	local int i;
	local RichListCtrlRowData RowData;
	local UIPacket._S_EX_USER_VIEW_INFO_PARAMETER packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_USER_VIEW_INFO_PARAMETER(packet))
	{
		return;
	}

	for(i = 0; i < packet.Parameters.Length; i++)
	{
		Parameters[packet.Parameters[i].Type] = packet.Parameters[i];
		// End:0xF4
		if((packet.Parameters[i].Type >= SelectStartNum) && packet.Parameters[i].Type <= SelectEndNum)
		{
			RowData = MakeFightInfoRecord(packet.Parameters[i].Type);
			FightInfo_ListCtrl.ModifyRecord(packet.Parameters[i].Type - SelectStartNum, RowData);
		}
	}
	// End:0x13F
	if(initBool == false)
	{
		initBool = true;
		Category_ListCtrl.SetSelectedIndex(0, true);
		InfoFightIMGTitle_txt.SetText(Category[0]);
		FightInfoAdd();
	}
}

function FightInfoAdd()
{
	local int i, Index;
	local RichListCtrlRowData RowData;

	Index = Category_ListCtrl.GetSelectedIndex();
	Category_ListCtrl.GetRec(Index, RowData);
	InfoFightIMGTitle_txt.SetText(Category[Index]);
	CalculationCount(Index);

	for(i = SelectStartNum; i <= SelectEndNum; i++)
	{
		FightInfo_ListCtrl.InsertRecord(MakeFightInfoRecord(i));
	}
}

function RichListCtrlRowData MakeCategoryRecord(int i, string Value)
{
	local RichListCtrlRowData Record;

	Record.nReserved1 = i;
	Record.cellDataList.Length = 1;
	Record.cellDataList[0].szData = Value;
	addRichListCtrlString(Record.cellDataList[0].drawitems, Record.cellDataList[0].szData, getInstanceL2Util().White, false, 5);
	return Record;
}

function RichListCtrlRowData MakeFightInfoRecord(int i)
{
	local RichListCtrlRowData Record;
	local string Detail;

	Record.nReserved1 = i;
	Record.cellDataList.Length = 2;
	Detail = AbilityData[i].Detail;
	Record.cellDataList[0].szData = Detail;
	AddEllipsisString(Record.cellDataList[0].drawitems, Detail, 303, getInstanceL2Util().White, false, true, 3);
	Record.szReserved = AbilityData[i].TooltipDesc;
	// End:0x16A
	if(AbilityData[i].IsPercent)
	{
		if(Parameters[i].Value == 0)
		{
			Record.cellDataList[1].szData = string(Parameters[i].Value) $ "%";			
		}
		else
		{
			if(Parameters[i].Value == -1)
			{
				Record.cellDataList[1].szData = GetSystemString(13663);				
			}
			else
			{
				Record.cellDataList[1].szData = getInstanceL2Util().cutFloat3(float(Parameters[i].Value) / 100.0f);
			}
		}		
	}
	else
	{
		Record.cellDataList[1].szData = string(Parameters[i].Value);
	}
	addRichListCtrlString(Record.cellDataList[1].drawitems, Record.cellDataList[1].szData, GTColor().Frangipani, false);
	return Record;
}

function int FindValue(int Num)
{
	local int i;

	for(i = 0; i < Parameters.Length; i++)
	{
		if(Parameters[i].Type == Num)
		{
			return Parameters[i].Value;
		}
	}
	return 0;
}

function CalculationCount(int Select)
{
	local int i, startNum;

	startNum = 0;

	// End:0x42 [Loop If]
	for(i = 0; i <= (Select - 1); i++)
	{
		startNum = startNum + CategoryNum[i];
	}
	SelectStartNum = startNum;
	SelectEndNum = (SelectStartNum + CategoryNum[Select]) - 1;
}

event OnShow()
{
	local WindowHandle parentWnd;

	parentWnd = GetWindowHandle("DetailStatusWndClassic");
	getInstanceL2Util().windowMoveToSide(parentWnd, Me);
}

function InitData()
{
	local int i, j;

	GetCharacterAbilityData(AbilityData);
	Parameters.Length = AbilityData.Length;

	// End:0x4F [Loop If]
	for(i = 0; i < AbilityData.Length; i++)
	{
		InsertCategory(AbilityData[i].Category);
	}

	for(j = 0; j < Category.Length; j++)
	{
		Category_ListCtrl.InsertRecord(MakeCategoryRecord(j, Category[j]));
	}
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_WindowName="InfoFightWndClassic"
}
