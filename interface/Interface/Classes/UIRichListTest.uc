class UIRichListTest extends UICommonAPI;

var WindowHandle Me;
var ComboBoxHandle typeComboBox;
var RichListCtrlHandle testRichListCtrl;
var ButtonHandle test1Button;
var ButtonHandle test2Button;
var bool toggleB;

function OnRegisterEvent();

function OnLoad()
{
	Initialize();
	Load();	
}

function Initialize()
{
	Me = GetWindowHandle("UIRichListTest");
	typeComboBox = GetComboBoxHandle("UIRichListTest.typeComboBox");
	testRichListCtrl = GetRichListCtrlHandle("UIRichListTest.testRichListCtrl");
	test1Button = GetButtonHandle("UIRichListTest.test1Button");
	test2Button = GetButtonHandle("UIRichListTest.test2Button");	
}

function Load()
{
	typeComboBox.AddStringWithReserved("6", 6);
	typeComboBox.AddStringWithReserved("5", 5);
	typeComboBox.AddStringWithReserved("4", 4);
	typeComboBox.AddStringWithReserved("3", 3);
	typeComboBox.AddStringWithReserved("2", 2);
	typeComboBox.AddStringWithReserved("1", 1);	
}

function OnShow()
{
	testRichListCtrl.DeleteAllItem();
	InsertList("오징어");
	InsertList("문어");
	InsertList("고등어");
	InsertList("오징어");
	InsertList("문어");
	InsertList("고등어");
	InsertList("오징어");
	InsertList("문어");
	InsertList("고등어");
	InsertList("오징어");
	InsertList("문어");
	InsertList("고등어");
	InsertList("오징어");
	InsertList("문어");
	InsertList("고등어");
	InsertList("오징어");
	InsertList("문어");
	InsertList("고등어");
	InsertList("오징어");
	InsertList("5문어");
	InsertList("고등어");
	InsertList("오징어");
	InsertList("문어");
	InsertList("고등어");
	InsertList("오징어");
	InsertList("5문어");
	InsertList("고등어");
	InsertList("오징어");
	InsertList("문어");
	InsertList("고등어");
	InsertList("5오징어");
	InsertList("문어");
	InsertList("고등어");
	InsertList("오징어");
	InsertList("문어");
	InsertList("고등어");
	InsertList("오징어");
	InsertList("문어");
	InsertList("고등어");
	InsertList("오징어");
	InsertList("문어");
	InsertList("고등어");
	InsertList("4오징어");
	InsertList("3문어");
	InsertList("2고등어");	
}

function InsertList(string Title)
{
	local RichListCtrlRowData RowData;

	RowData.cellDataList.Length = 2;
	addRichListCtrlButton(RowData.cellDataList[0].drawitems, "rewardBtn", 4, 12, "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", 16, 16, 16, 16);
	RowData.cellDataList[0].drawitems[RowData.cellDataList[0].drawitems.Length - 1].TooltipDesc = GetSystemString(7529);
	RowData.nReserved1 = 0;
	addRichListCtrlString(RowData.cellDataList[0].drawitems, Title, GTColor().White, false, 5, 2);
	testRichListCtrl.InsertRecord(RowData);	
}

function onRewardBtnClick()
{
	local RichListCtrlRowData RowData;

	Debug("rewardBtn --> " @ string(testRichListCtrl.GetSelectedIndex()));
	testRichListCtrl.GetRec(testRichListCtrl.GetSelectedIndex(), RowData);
	Debug("RowData.nReserved1" @ string(RowData.nReserved1));
	// End:0x124
	if(RowData.nReserved1 == 0)
	{
		modifyRichListCtrlButton(RowData.cellDataList[0].drawitems, 0, "rewardBtn", 4, 12, "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox_checked", 16, 16, 16, 16);
		RowData.nReserved1 = 1;		
	}
	else
	{
		modifyRichListCtrlButton(RowData.cellDataList[0].drawitems, 0, "rewardBtn", 4, 12, "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", 16, 16, 16, 16);
		RowData.nReserved1 = 0;
	}
	testRichListCtrl.ModifyRecord(testRichListCtrl.GetSelectedIndex(), RowData);
	checkBoxSelectCheck();	
}

function OnClickCheckBox(string strID)
{
	local int i;
	local RichListCtrlRowData RowData;

	toggleB = ! toggleB;

	// End:0x1B0 [Loop If]
	for(i = 0; i < testRichListCtrl.GetRecordCount(); i++)
	{
		testRichListCtrl.GetRec(i, RowData);
		// End:0x10B
		if(GetMeCheckBox("allSelectCheckBox").IsChecked())
		{
			modifyRichListCtrlButton(RowData.cellDataList[0].drawitems, 0, "rewardBtn", 4, 12, "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox_checked", 16, 16, 16, 16);
			RowData.nReserved1 = 1;			
		}
		else
		{
			modifyRichListCtrlButton(RowData.cellDataList[0].drawitems, 0, "rewardBtn", 4, 12, "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", 16, 16, 16, 16);
			RowData.nReserved1 = 0;
		}
		testRichListCtrl.ModifyRecord(i, RowData);
	}	
}

function checkBoxSelectCheck()
{
	local int i;
	local RichListCtrlRowData RowData;

	// End:0x7D [Loop If]
	for(i = 0; i < testRichListCtrl.GetRecordCount(); i++)
	{
		testRichListCtrl.GetRec(i, RowData);
		// End:0x73
		if(RowData.nReserved1 == 0)
		{
			GetMeCheckBox("allSelectCheckBox").SetCheck(false);
			// [Explicit Break]
			break;
		}
	}	
}

function OnClickCheckBoxPage()
{
	local int i;
	local RichListCtrlRowData RowData;
	local int pageNum, Start, End;

	pageNum = typeComboBox.GetReserved(typeComboBox.GetSelectedNum());
	toggleB = ! toggleB;
	Start = (pageNum - 1) * 8;
	End = pageNum * 8;
	// End:0x82
	if(End > testRichListCtrl.GetRecordCount())
	{
		End = testRichListCtrl.GetRecordCount();
	}

	// End:0x21D [Loop If]
	for(i = Start; i < End; i++)
	{
		testRichListCtrl.GetRec(i, RowData);
		// End:0x178
		if(GetMeCheckBox("allSelectCheckBox").IsChecked())
		{
			modifyRichListCtrlButton(RowData.cellDataList[0].drawitems, 0, "rewardBtn", 4, 12, "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox_checked", 16, 16, 16, 16);
			RowData.nReserved1 = 1;			
		}
		else
		{
			modifyRichListCtrlButton(RowData.cellDataList[0].drawitems, 0, "rewardBtn", 4, 12, "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", 16, 16, 16, 16);
			RowData.nReserved1 = 0;
		}
		testRichListCtrl.ModifyRecord(i, RowData);
	}	
}

function OnClickButton(string Name)
{
	Debug("Name" @ Name);
	switch(Name)
	{
		// End:0x33
		case "test1Button":
			Ontest1ButtonClick();
			// End:0x66
			break;
		// End:0x4C
		case "test2Button":
			Ontest2ButtonClick();
			// End:0x66
			break;
		// End:0x63
		case "rewardBtn":
			onRewardBtnClick();
			// End:0x66
			break;
		// End:0xFFFF
		default:
			break;
	}	
}

function Ontest1ButtonClick()
{
	local int i, sum;
	local RichListCtrlRowData RowData;

	// End:0x5D [Loop If]
	for(i = 0; i < testRichListCtrl.GetRecordCount(); i++)
	{
		testRichListCtrl.GetRec(i, RowData);
		// End:0x53
		if(RowData.nReserved1 > 0)
		{
			++ sum;
		}
	}
	Debug("checkbox Sum" $ string(sum));	
}

function Ontest2ButtonClick()
{
	Debug(".typeComboBox.GetReserved:" @ string(typeComboBox.GetReserved(typeComboBox.GetSelectedNum())));	
}

defaultproperties
{
}
