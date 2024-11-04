class UITreeTest extends UICommonAPI;

var string ROOTNAME;
var string nodePath;
var WindowHandle Me;
var EditBoxHandle texture1EditBox;
var UITreeUtil treeInstance1;
var UITreeUtil treeInstance2;
var UITreeUtil treeInstance3;
var UITreeUtil treeInstance4;

function OnRegisterEvent()
{}

function OnLoad()
{
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle("UITreeTest");
	texture1EditBox = GetEditBoxHandle("UITreeTest.texture1EditBox");
	ROOTNAME = "root";
	treeInstance1 = new class'UITreeUtil';
	treeInstance2 = new class'UITreeUtil';
	treeInstance3 = new class'UITreeUtil';
	treeInstance4 = new class'UITreeUtil';
}

function OnShow()
{
	test1();
	test2();
	test3();
	test4();
}

function test1()
{
	local int i;

	treeInstance1._InitTree(GetTreeHandle("UITreeTest.NTreeCtrl"));
	treeInstance1._makeNodeRoot(ROOTNAME);

	// End:0x22B [Loop If]
	for(i = 1; i < 10; i++)
	{
		nodePath = treeInstance1._makeExpandBtnNode(ROOTNAME, "list" $ string(i));
		treeInstance1._makeTextItem(nodePath, "리스트" $ string(i), 7, 0, GTColor().White);
		nodePath = treeInstance1._makeSelectNode((ROOTNAME $ ".list") $ string(i), "list" $ string(i) $ "_1", 0, 0, 18);
		treeInstance1._makeTextureItem(nodePath, "L2UI_CH3.BloodHoodWnd.BloodHood_Logon", 31, 11, 10, 3);
		treeInstance1._makeTextItem(nodePath, "test1", 7, 0, GTColor().Green, false, false);
		nodePath = treeInstance1._makeSelectNode((ROOTNAME $ ".list") $ string(i), "list" $ string(i) $ "_2", 0, 0, 18);
		treeInstance1._makeTextureItem(nodePath, "L2UI_CH3.BloodHoodWnd.BloodHood_Logon", 31, 11, 10, 3);
		treeInstance1._makeTextItem(nodePath, "test2", 7, 0, GTColor().Green, false, false);
	}
}

function test2()
{
	local int i;

	treeInstance2._InitTree(GetTreeHandle("UITreeTest.NTreeCtrl1"));
	treeInstance2._makeNodeRoot(ROOTNAME);

	// End:0x185 [Loop If]
	for(i = 1; i < 20; i++)
	{
		nodePath = treeInstance2._makeEmptyNode(ROOTNAME, "list" $ string(i),,,, MakeTooltipSimpleText("냠냠 짭짭"));
		treeInstance2._makeTextureItem(nodePath, class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(1070 + i)), 32, 32, 10, 3);
		treeInstance2._makeTextItem(nodePath, class'UIDATA_ITEM'.static.GetItemName(GetItemID(1070 + i)), 7, 0, GTColor().Yellow);
		treeInstance2._makeTextItem(nodePath, class'UIDATA_ITEM'.static.GetItemDescription(GetItemID(1070 + i)), 7, 0, GTColor().White, false, true);
		treeInstance2._makeTextureItem(nodePath, "", 0, 10, 0, 0, false, true);
	}
}

function test3()
{
	treeInstance3._InitTree(GetTreeHandle("UITreeTest.NTreeCtrl2"));
	treeInstance3._makeNodeRoot(ROOTNAME);
	nodePath = treeInstance3._makeEmptyNode(ROOTNAME, "list1");
	treeInstance3._makeTextItem(nodePath, "장비1", 7, 0, GTColor().White);
	treeInstance3._makeTextItem(nodePath, "(+200)",, 0, GTColor().Yellow);
	treeInstance3._makeTextItem(nodePath, "장비2", 7, 0, GTColor().White, false, true);
	treeInstance3._makeTextItem(nodePath, "(+300)",, 0, GTColor().Yellow);
	treeInstance3._makeTextureItem(nodePath, "L2UI_CT1.RankingWnd.RankingWnd_ArrowUp", 8, 8, 0, 0);	
}

function test4()
{
	local int i;

	treeInstance4._InitTree(GetTreeHandle("UITreeTest.NTreeCtrl3"));
	treeInstance4._makeNodeRoot(ROOTNAME);

	// End:0x10E [Loop If]
	for(i = 1; i < 10; i++)
	{
		nodePath = treeInstance4._makeSelectNode(ROOTNAME, "r" $ string(i), 0, 0, 18);
		treeInstance4._makeTextureItem(nodePath, "L2UI_CT1.ProductInventory.ProductInventory_GiftIcon", 16, 16, 10, 3);
		treeInstance4._makeTextItem(nodePath, "메뉴" $ string(i), 7, 0, GTColor().White);
	}
}

function OnClickButton(string Name)
{
	Debug("Name" @ Name);
	// End:0x128
	if(Name == "root.list1")
	{
		// End:0xBA
		if(treeInstance3.getMapStringReserved(Name) == "on")
		{
			treeInstance3._SetNodeItemTexture(ROOTNAME $ ".list1", 111, "L2UI_CT1.RankingWnd.RankingWnd_ArrowDown", 8, 8);
			treeInstance3.setMapStringReserved(ROOTNAME $ ".list1", "off");			
		}
		else
		{
			treeInstance3._SetNodeItemTexture(ROOTNAME $ ".list1", 111, "L2UI_CT1.RankingWnd.RankingWnd_ArrowUp", 8, 8);
			treeInstance3.setMapStringReserved(ROOTNAME $ ".list1", "on");
		}
	}
	switch(Right(Name, 2))
	{
		// End:0x13A
		case "r1":
		// End:0x170
		case "r2":
			treeInstance1._ClickSelectNode(Name);
			Debug("tree Name" @ Name);
			// End:0x173
			break;
		// End:0xFFFF
		default:
			break;
	}
	switch(Name)
	{
		// End:0x193
		case "test1Button":
			Ontest1ButtonClick();
			// End:0x200
			break;
		// End:0x1AC
		case "test0Button":
			Ontest0ButtonClick();
			// End:0x200
			break;
		// End:0x1C5
		case "test2Button":
			Ontest2ButtonClick();
			// End:0x200
			break;
		// End:0x1DF
		case "ButtonUpdate":
			OnButtonUpdate();
			// End:0x200
			break;
		// End:0x1FD
		case "ButtonResetParam":
			OnButtonResetParamClick();
			// End:0x200
			break;
		// End:0xFFFF
		default:
			break;
	}
}

function Ontest1ButtonClick()
{}

function Ontest0ButtonClick()
{}

function OnButtonUpdate()
{}

function OnButtonResetParamClick()
{
	texture1EditBox.SetString("");
}

function Ontest2ButtonClick()
{}

defaultproperties
{
}
