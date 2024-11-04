class EnsoulExtractSubWnd extends UICommonAPI;

var WindowHandle Me;

var ItemWindowHandle EnsoulSubWnd_Item1;
var ItemWindowHandle EnsoulSubWnd_Item2;

var TabHandle EnsoulSubWnd_Tab;

var L2Util util;
var InventoryWnd inventoryWndScript;
var EnsoulExtractWnd ensoulExtractWndScript;

function OnRegisterEvent();

function OnLoad()
{
	Initialize();
	EnsoulSubWnd_Tab.SetButtonName(0, GetSystemString(116));
}

function OnShow()
{
	syncInventory();
}

function Initialize()
{
	ensoulExtractWndScript = EnsoulExtractWnd(GetScript("EnsoulExtractWnd"));
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	Me = GetWindowHandle("EnsoulExtractSubWnd");

	EnsoulSubWnd_Tab = GetTabHandle("EnsoulExtractSubWnd.EnsoulSubWnd_Tab");

	EnsoulSubWnd_Item1 = GetItemWindowHandle("EnsoulExtractSubWnd.EnsoulSubWnd_Item1");
	EnsoulSubWnd_Item2 = GetItemWindowHandle("EnsoulExtractSubWnd.EnsoulSubWnd_Item2");
	
	EnsoulSubWnd_Item2.DisableWindow();
	EnsoulSubWnd_Tab.SetDisable(1, true);
}

function setLock(bool bLock)
{
	if (bLock)
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

function OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
}

// 더블 클릭하면, 무기, 집혼석 슬롯은 삭제
function OnDBClickItem(string ControlName, int index)
{
	local ItemInfo info;

	// 무기
	if (ControlName == "EnsoulSubWnd_Item1")
	{	
		if(EnsoulSubWnd_Item1.IsEnableWindow())
		{
			EnsoulSubWnd_Item1.GetItem(index, info);
			ensoulExtractWndScript.InsertWeapon(info);
		}
	}
}

// 무기, 집혼석 관련 아이템 윈도우 업데이트
function syncInventory()
{
	local array<ItemInfo> itemArray;
	local int i;

	if (EnsoulSubWnd_Tab.GetTopIndex() == 0)
	{
		itemArray = inventoryWndScript.getInventoryEnSoulExtractEnableItemArray();

		EnsoulSubWnd_Item1.Clear();
		for (i = 0; i < itemArray.Length;i++)
		{
			// 집혼UI에서 사용 중인 아이템인가?
			if (!ensoulExtractWndScript.externalCheckUsingItem(itemArray[i])
			// 봉인 된 아이템 인가?
			&& !itemArray[i].bSecurityLock ) 
				EnsoulSubWnd_Item1.AddItem(itemArray[i]);
		}
	}
}

defaultproperties
{
}
