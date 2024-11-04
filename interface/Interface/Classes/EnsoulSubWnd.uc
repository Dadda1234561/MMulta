//------------------------------------------------------------------------------------------------------------------------
// ��ȥ UI ���� �κ��丮
//------------------------------------------------------------------------------------------------------------------------
class EnsoulSubWnd extends UICommonAPI;

const STATE_INSERT_WEAPON = "STATE_INSERT_WEAPON";
const STATE_INSERT_ENSOULSTONE = "STATE_INSERT_ENSOULSTONE";
const STATE_SELECT_ENSOUL = "STATE_SELECT_ENSOUL";
const STATE_CONFIRM_ENSOUL = "STATE_CONFIRM_ENSOUL";
const STATE_ASK_OVERWRITE = "STATE_ASK_OVERWRITE";
const STATE_RESULT = "STATE_RESULT";

var WindowHandle Me;
var TextureHandle SlotBg1_Texture;
var ItemWindowHandle EnsoulSubWnd_Item1;
var ItemWindowHandle EnsoulSubWnd_Item2;
var TabHandle EnsoulSubWnd_Tab;
var TextureHandle tabbgLine;
var TextureHandle tabBg;
var L2Util util;
var InventoryWnd inventoryWndScript;
var EnsoulWnd ensoulWndScript;

function OnRegisterEvent();

function OnShow()
{
	syncInventory();
}

// ����, ��ȥ�� ���� ������ ������ ������Ʈ
function syncInventory()
{
	local array<ItemInfo> itemArray;
	local int i, nStackableNum;

	if (EnsoulSubWnd_Tab.GetTopIndex() == 0)
	{
		itemArray = inventoryWndScript.getInventoryEnSoulEnableItemArray();
		EnsoulSubWnd_Item1.Clear();
		for (i = 0; i < itemArray.Length;i++)
		{
			// ��ȥUI���� ��� ���� �������ΰ�?
			if (!ensoulWndScript.externalCheckUsingItem(itemArray[i]))
				EnsoulSubWnd_Item1.AddItem(itemArray[i]);
		}
	}
	else if (EnsoulSubWnd_Tab.GetTopIndex() == 1)
	{
		itemArray = inventoryWndScript.getInventoryEnSoulStoneArray();
		EnsoulSubWnd_Item2.Clear();
		for (i = 0; i < itemArray.Length;i++)
		{
			nStackableNum = 0;
			// 2016_0801 ����, [������] ������ ���� ��� �߰�			
			// ������ �������� ���� �Ǿ� �ֳ�?
			if(IsStackableItem(itemArray[i].ConsumeType))
			{				
				if (ensoulWndScript.externalCheckUsingItem(itemArray[i], nStackableNum))
				{
					// ������ 1�� ������ ��ŭ ���ش�.
					itemArray[i].ItemNum = itemArray[i].ItemNum - nStackableNum;
				}
				
				if (itemArray[i].ItemNum > 0) EnsoulSubWnd_Item2.AddItem(itemArray[i]);
				else EnsoulSubWnd_Item2.DeleteItem(i);
			}
			else
			{
				// ��ȥUI���� ��� ���� �������ΰ�?
				if (!ensoulWndScript.externalCheckUsingItem(itemArray[i]))
					EnsoulSubWnd_Item2.AddItem(itemArray[i]);
			}
		}
	}
}

function setLock(bool bLock)
{
	// End:0x2A
	if(bLock)
	{
		EnsoulSubWnd_Item1.DisableWindow();
		EnsoulSubWnd_Item2.DisableWindow();
	}
	else
	{
		EnsoulSubWnd_Item1.EnableWindow();
		EnsoulSubWnd_Item2.EnableWindow();
	}	
}

function OnLoad()
{
	Initialize();
	EnsoulSubWnd_Tab.SetButtonName(0, GetSystemString(116));
}

function OnClickButton(string Name)
{
	OnShow();
	switch(Name)
	{
		// End:0x26
		case "EnsoulInfo_Button":
			// End:0x29
			break;
	}
}

// ���� Ŭ���ϸ�, ����, ��ȥ�� ������ ����
function OnDBClickItem( string ControlName, int index )
{
	local itemInfo info;

	// Ŭ�� ����
	if (ControlName == "EnsoulSubWnd_Item1" && EnsoulSubWnd_Item1.IsEnableWindow() == false) return;
	if (ControlName == "EnsoulSubWnd_Item2" && EnsoulSubWnd_Item2.IsEnableWindow() == false) return;

	// ����
	if(ensoulWndScript.getCurrentEnsoulState() == STATE_INSERT_WEAPON || 
	   ensoulWndScript.getCurrentEnsoulState() == STATE_INSERT_ENSOULSTONE || 
	   ensoulWndScript.getCurrentEnsoulState() == STATE_SELECT_ENSOUL)
	{
		if ( ControlName == "EnsoulSubWnd_Item1")
		{	
			EnsoulSubWnd_Item1.GetItem(index, info);
			ensoulWndScript.InsertWeapon(info);
		}	
		// ��ȥ��
		else if ( ControlName == "EnsoulSubWnd_Item2")
		{	
			EnsoulSubWnd_Item2.GetItem(index, info);
			ensoulWndScript.InsertEnsoulStone(-1, info);
		}
	}
}

function OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);	
}

function Initialize()
{
	Me = GetWindowHandle("EnsoulSubWnd");
	SlotBg1_Texture = GetTextureHandle("EnsoulSubWnd.SlotBg1_Texture");
	EnsoulSubWnd_Item1 = GetItemWindowHandle("EnsoulSubWnd.EnsoulSubWnd_Item1");
	EnsoulSubWnd_Item2 = GetItemWindowHandle("EnsoulSubWnd.EnsoulSubWnd_Item2");
	EnsoulSubWnd_Tab = GetTabHandle("EnsoulSubWnd.EnsoulSubWnd_Tab");
	tabbgLine = GetTextureHandle("EnsoulSubWnd.tabbgLine");
	tabBg = GetTextureHandle("EnsoulSubWnd.tabbg");
	util = L2Util(GetScript("L2Util"));
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	ensoulWndScript = EnsoulWnd(GetScript("EnsoulWnd"));
}

// ������ �� �̵�
function setTabIndex(int nIndex)
{
	EnsoulSubWnd_Tab.SetTopOrder(nIndex, false);
	syncInventory();
}

defaultproperties
{
}
