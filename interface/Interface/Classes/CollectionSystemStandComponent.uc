class CollectionSystemStandComponent extends UICommonAPI;

const STATE_UP = 'stateUp';
const STATE_OVER = 'stateOver';
const STATE_DOWN = 'stateDown';

var WindowHandle Me;
var string m_WindowName;
var string m_ParentName;
var EffectViewportWndHandle effectViewportWnd;
var EffectViewportWndHandle effectViewportWndOver;
var string EffectName;
var bool bCompleted;
var CollectionSystem collectionSystemScript;
var CollectionSystemSub collectionSystemSubScript;
var ButtonHandle KeyItemBTN;
var CollectionMainData cMainData;
var int CurrentState;

function Initialize()
{
	effectViewportWnd = GetEffectViewportWndHandle(m_WindowName $ ".KeyItem_EffectViewport");
	effectViewportWndOver = GetEffectViewportWndHandle(m_WindowName $ ".KeyItem_EffectViewportOver");
	KeyItemBTN = GetButtonHandle(m_WindowName $ ".KeyItemBTN");
	GotoState('stateUp');
}

function Init(string WindowName, CollectionMainData _mData, optional bool bFavorite)
{
	local int subIndex;

	m_WindowName = WindowName;
	Me = GetWindowHandle(m_WindowName);
	cMainData = _mData;
	collectionSystemScript = CollectionSystem(GetScript("CollectionSystem"));
	// End:0x9E
	if(bFavorite)
	{
		cMainData.Category = collectionSystemScript.favoriteCategory;
		EffectName = collectionSystemScript.GetStringKeyByIndex(cMainData.Category - 1, cMainData.background_level - 1);		
	}
	else
	{
		subIndex = collectionSystemScript.GetSubIndexByMainID(cMainData.main_id);
		EffectName = collectionSystemScript.GetStringKeyByIndex(cMainData.Category - 1, subIndex);
	}
	Initialize();
	SetItemTooltip();
}

function SetItemTooltip()
{
	local ItemInfo iInfo;
	local string keyItemname;

	// End:0x47
	if(cMainData.key_item_id > 0)
	{
		class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(cMainData.key_item_id), iInfo);
		keyItemname = iInfo.Name;		
	}
	else
	{
		keyItemname = collectionSystemScript.GetStringNameByIndex(cMainData.Category - 1);
	}
	KeyItemBTN.SetTooltipCustomType(MakeTooltipSimpleText(keyItemname));
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		// End:0x1F
		case "KeyItemBTN":
			HandleClick();
			// End:0x22
			break;
		// End:0xFFFF
		default:
			break;
	}
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle.GetWindowName())
	{
		// End:0x29
		case "KeyItemBTN":
			HandleBtnDown();
			// End:0x2C
			break;
		// End:0xFFFF
		default:
			break;
	}
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	switch(a_WindowHandle.GetWindowName())
	{
		// End:0x29
		case "KeyItemBTN":
			HandleBtnOut();
			// End:0x2C
			break;
		// End:0xFFFF
		default:
			break;
	}
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	switch(a_WindowHandle.GetWindowName())
	{
		// End:0x29
		case "KeyItemBTN":
			HandleBtnOver();
			// End:0x2C
			break;
		// End:0xFFFF
		default:
			break;
	}
}

function HandleBtnOver()
{
	GotoState('stateOver');
}

function HandleBtnOut()
{
	GotoState('stateUp');
}

function HandleBtnUp()
{
	GotoState('stateOver');
}

function HandleBtnDown()
{
	GotoState('stateDown');
}

function HandleClick()
{
	collectionSystemScript.SetCurrentCategory(cMainData.Category);
}

function popupDetail()
{
	// End:0x29
	if(cMainData.key_item_id > 0)
	{
		collectionSystemScript.SetCollectionPopupDetail(cMainData.collection_ID);
	}
}

function CollectionSystemCategoryComponent GetCollectionSystemCategoryComponentScript()
{
	return collectionSystemScript.collectionSystemCategoryScript.collectionSystemCategoryComponents[cMainData.Category - 1];
}

function SetShow()
{
	SetComplete();
}

function SetComplete()
{
	local CollectionInfo cInfo;
	local CollectionData cdata;
	local array<ItemInfo> iIonfos;

	// End:0x88
	if(cMainData.key_item_id > 0)
	{
		// End:0x35
		if(! collectionSystemScript.API_GetCollectionInfo(cMainData.collection_ID, cInfo))
		{
			return;
		}
		// End:0x5A
		if(! collectionSystemScript.API_GetCollectionData(cMainData.collection_ID, cdata))
		{
			return;
		}
		bCompleted = collectionSystemScript.collectionSystemSubScript.GetItemList(cInfo, cdata, iIonfos);
	}
	// End:0xBD
	if(bCompleted)
	{
		effectViewportWnd.SpawnEffect(GetEffectName(EffectName $ "_fullnormal"));		
	}
	else
	{
		effectViewportWnd.SpawnEffect(GetEffectName(EffectName $ "_normal"));
	}
	effectViewportWndOver.HideWindow();
	switch(CurrentState)
	{
		// End:0x106
		case 0:
			GotoState('stateUp');
			// End:0x126
			break;
		// End:0x114
		case 1:
			GotoState('stateDown');
			// End:0x126
			break;
		// End:0x123
		case 2:
			GotoState('stateOver');
			// End:0x126
			break;
		// End:0xFFFF
		default:
			break;
	}
}

function string GetEffectName(string keyItem)
{
	return "LineageEffect2." $ collectionSystemScript.API_GetGeneralEffectName(keyItem);
}

auto state stateUp
{
	function BeginState()
	{
		// End:0x2E
		if(collectionSystemScript.collectionSystemCategoryScript.collectionSystemCategoryComponents.Length > 0)
		{
			GetCollectionSystemCategoryComponentScript().SetBtnOut();
		}
		effectViewportWndOver.HideWindow();
		CurrentState = 0;
	}

	function EndState()
	{
	}
}

state stateDown
{
	function BeginState()
	{
		// End:0x2E
		if(collectionSystemScript.collectionSystemCategoryScript.collectionSystemCategoryComponents.Length > 0)
		{
			GetCollectionSystemCategoryComponentScript().SetBtnOut();
		}
		effectViewportWndOver.HideWindow();
		CurrentState = 1;
	}

	function EndState()
	{
	}
}

state stateOver
{
	function BeginState()
	{
		// End:0x2E
		if(collectionSystemScript.collectionSystemCategoryScript.collectionSystemCategoryComponents.Length > 0)
		{
			GetCollectionSystemCategoryComponentScript().SetBtnOver();
		}
		effectViewportWndOver.ShowWindow();
		// End:0x6E
		if(! bCompleted)
		{
			effectViewportWndOver.SpawnEffect(GetEffectName(EffectName $ "_over"));			
		}
		else
		{
			effectViewportWndOver.SpawnEffect(GetEffectName(EffectName $ "_fullover"));
		}
		CurrentState = 2;
	}

	function EndState()
	{
		effectViewportWndOver.HideWindow();
	}
}

defaultproperties
{
}
