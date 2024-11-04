//================================================================================
// UIControlNeedItemList.
// emu-dev.ru
//================================================================================

class UIControlNeedItemList extends UICommonAPI
	dependson(L2UIInventoryObjectSimple)
	dependson(L2UITimer)
	dependson(L2UITimerObject);

const needItemIndex = 4;
const CURRENTITEMINDEX = 5;
const ANIMATIONTIMELIMIT_DEFULT = 10;
const AMIMATIONTIME_RATE_DEFAULT = 0.05f;
const AMIMATIONTIME_COOLTIME = 20;

enum FORM_TYPE
{
	Normal,
	nameSide,
	normalSideSmall
};

struct AniData
{
	var int Index;
	var int currentNum;
	var int targetNum;
	var int tickNum;
	var int Time;
};

var RichListCtrlHandle NeedItemRichListCtrl;
var array<L2UIInventoryObjectSimple> iObjects;
var private L2UITimerObject timerObj;
var array<int> indexes;
var INT64 _buyNum;
var array<INT64> _needAmounts;
var array<INT64> _currAmounts;
var array<int> _needItemClassIds;
var private array<INT64> _currAmountsAnimation;
var private bool bUseAnimation;
var private float animationTImeLimit;
var private float animationremainTime;
var private float animationRate;
var private INT64 lastAppMilliSeconds;
var FORM_TYPE _form;
var int _showRowNum;
var bool _bHideMyNum;
var int _columnCount;
var int _totalIndex;

static function UIControlNeedItemList InitScript(WindowHandle wnd, optional int ListNum, optional int columCount, optional bool isHideMyNum, optional UIControlNeedItemList.FORM_TYPE newformType)
{
	local UIControlNeedItemList scr;

	wnd.SetScript("UIControlNeedItemList");
	scr = UIControlNeedItemList(wnd.GetScript());
	scr.InitWnd(wnd, ListNum, columCount, isHideMyNum, newformType);
	return scr;
}

function InitWnd(WindowHandle wnd, optional int ListNum, optional int columCount, optional bool isHideMyNum, optional FORM_TYPE newformType)
{
	local RichListCtrlHandle richList;

	m_hOwnerWnd = wnd;
	richList = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItemRichListCtrl");
	SetRichListControler(richList);

	if(ListNum > 0)
	{
		StartNeedItemList(ListNum);
	}

	if(columCount > 0)
	{
		SetColumnCount(columCount);
	}
	SetHideMyNum(isHideMyNum);
	SetFormType(newformType);
}

delegate DelegateOnUpdateItem()
{}

delegate DelegateOnClickButton(string btnName);

function SetRichListControler(RichListCtrlHandle richList)
{
	_columnCount = 1;
	NeedItemRichListCtrl = richList;
	NeedItemRichListCtrl.SetUseStripeBackTexture(false);
	NeedItemRichListCtrl.SetSelectedSelTooltip(false);
	NeedItemRichListCtrl.SetAppearTooltipAtMouseX(true);
	NeedItemRichListCtrl.SetSelectable(false);
	NeedItemRichListCtrl.SetTooltipType("SellItemList");
	NeedItemRichListCtrl.SetUseHorizontalScrollBar(false);
}

function refresh()
{
	local int i;

	for (i = 0; i <= _totalIndex; i++)
	{
		if(_currAmounts.Length <= i)
		{
			break;
		}
		ModifyCurrentAmount(i, _currAmounts[i]);
	}
	DelegateOnUpdateItem();
}

function SetBuyNum(INT64 Num)
{
	_buyNum = Num;
	refresh();
}

function bool GetCanBuy()
{
	return _buyNum <= GetMaxNumCanBuy();
}

function INT64 GetMaxNumCanBuy()
{
	local int i, Len;
	local INT64 maxCount, currentMaxCount;

	Len = _needAmounts.Length;

	if(Len == 0)
	{
		return 0;
	}
	maxCount = GetMaxNumByIndex(0);

	for(i = 1; i < Len; i++)
	{
		if(maxCount == 0)
		{
			return 0;
		}
		currentMaxCount = GetMaxNumByIndex(i);

		if(currentMaxCount < maxCount)
		{
			maxCount = currentMaxCount;
		}
	}
	return maxCount;
}

function INT64 GetMaxNumByIndex(int Index)
{
	if(_needAmounts[Index] == 0)
	{
		return 999999;
	}
	return _currAmounts[Index] / _needAmounts[Index];
}

function int GetRowNum()
{
	return _showRowNum;
}

function bool GetItemClassID(int Index, out int ClassID)
{
	if(iObjects.Length > Index)
	{
		ClassID = iObjects[Index].iID.ClassID;
		return true;
	}
	return false;
}

function bool GetItemNeedAmount(int Index, out INT64 Amount)
{
	if(iObjects.Length > Index)
	{
		Amount = _needAmounts[Index];
		return true;
	}
	return false;
}

function _SetAnimationRate(optional float Rate)
{
	if(Rate == 0)
	{
		animationRate = AMIMATIONTIME_RATE_DEFAULT;
	}
	else
	{
		animationRate = Rate;
	}
}

function _SetUseAnimation(bool bUse, optional float TimeLimit, optional float Rate)
{
	if(bUseAnimation == bUse)
	{
		return;
	}
	bUseAnimation = bUse;

	if(bUseAnimation)
	{
		if(TimeLimit == 0)
		{
			animationTImeLimit = ANIMATIONTIMELIMIT_DEFULT;
		}
		else
		{
			animationTImeLimit = TimeLimit;
		}
		_SetAnimationRate(Rate);
		timerObj = class'L2UITimer'.static.Inst()._AddNewTimerObject(AMIMATIONTIME_COOLTIME, -1);
		timerObj._DelegateOnStart = AnimationOnTImeStart;
		timerObj._DelegateOnTime = AnimationOnTime;
		timerObj._DelegateOnEnd = AnimationOnTImeEnd;
	}
	else
	{
		timerObj._Kill();
	}
}

private function AnimationOnTImeStart()
{
	if(!m_hOwnerWnd.GetTopFrameWnd().IsShowWindow())
	{
		timerObj._Stop();
		AnimationOnTImeEnd();
		return;
	}
	animationremainTime = animationTImeLimit;
	SetLastAppMilliSeconds();
}

private function AnimationOnTime(int Count)
{
	local int i, Len;
	local INT64 gab;

	animationremainTime -= (float(GetDeltaMilliTime()) / 1000);

	if(animationremainTime <= 0)
	{
		timerObj._Stop();
		AnimationOnTImeEnd();
		return;
	}
	SetLastAppMilliSeconds();

	for(i = 0; i < _currAmountsAnimation.Length; i++)
	{
		gab = _currAmounts[i] - _currAmountsAnimation[i];

		if(gab * animationRate < 1 && gab * animationRate > -1)
		{
			_currAmountsAnimation[i] = _currAmountsAnimation[i] + gab;
			Len++;
			continue;
		}
		_currAmountsAnimation[i] = _currAmountsAnimation[i] + (gab * animationRate);
	}
	if(Len == _currAmountsAnimation.Length)
	{
		timerObj._Stop();
		AnimationOnTImeEnd();
		return;
	}
	refresh();
}

private function AnimationOnTImeEnd()
{
	local int i;

	for(i = 0; i < _currAmountsAnimation.Length; i++)
	{
		_currAmountsAnimation[i] = _currAmounts[i];
	}
	refresh();
}

private function SetLastAppMilliSeconds()
{
	lastAppMilliSeconds = GetAppMilliSeconds();
}

private function INT64 GetDeltaMilliTime()
{
	return GetAppMilliSeconds() - lastAppMilliSeconds;
}

function StartNeedItemList(int showRowNum)
{
	_showRowNum = showRowNum;
	CleariObjects();

	if(bUseAnimation)
	{
		timerObj._Stop();
	}
}

function CleariObjects()
{
	local int i;

	_totalIndex = -1;
	_needAmounts.Length = 0;
	_currAmounts.Length = 0;
	_needItemClassIds.Length = 0;
	_currAmountsAnimation.Length = 0;
	NeedItemRichListCtrl.DeleteAllItem();

    for(i = 0; i < iObjects.Length; i++)
	{
		RemObjectSimpleByObject(iObjects[i]);
	}
	iObjects.Length = 0;
}

function int AddNeedPoint(string Name, string TextureName, INT64 needAmount, INT64 currentAmount)
{
	InsertRecordNCheckScrollBar(MakePointRecord(Name, TextureName, needAmount, currentAmount));
	return _totalIndex;
}

function AddNeedItemClassID(int nClassID, INT64 needAmount)
{
	local int Len;
	local INT64 currAmount;

	currAmount = getItemCountByClassID(nClassID);

	InsertRecordNCheckScrollBar(MakeRowDataByClassID(nClassID, needAmount, currAmount));
	Len = iObjects.Length;
	iObjects[Len] = AddItemListenerSimple(nClassID, 0, _totalIndex);
	iObjects[Len].DelegateOnUpdateItem = HandleItemSimpleUpdateListner;
}

function int AddNeeItemInfo(ItemInfo iInfo, INT64 needAmount, INT64 currAmount)
{
	InsertRecordNCheckScrollBar(MakeRowDataNeedItemInfo(iInfo, needAmount, currAmount));
	return _totalIndex;
}

function ModifyNeeItemInfo(ItemInfo iInfo, INT64 needAmount, INT64 currAmount)
{
	local int i;

	for(i = 0; i <= _totalIndex; i++)
	{
		if(_currAmounts.Length > i && _needItemClassIds.Length > i && _needItemClassIds[i] == iInfo.Id.ClassID)
		{
			if(_currAmounts[i] != currAmount)
			{
				ModifyCurrentAmount(i, currAmount);
			}
		}
	}
}

function SetColumnCount(int columnCount)
{
	_columnCount = columnCount;
}

function SetHideMyNum(bool bHide)
{
	_bHideMyNum = bHide;
	refresh();
}

function SetFormType(FORM_TYPE newformType)
{
	_form = newformType;
}

function bool MakeNeedItemDrawItem(ItemInfo iInfo, INT64 Amount, INT64 inventoryItemCount, out array<RichListCtrlDrawItem> drawitems)
{
	local INT64 totalNeednum;
	local bool bEnoughItems;
	local Color itemNumColor;

	if(_form == normalSideSmall)
	{
		addRichListCtrlTexture(drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 24, 24, 0, 3);
		AddRichListCtrlItem(drawitems, iInfo, AMIMATIONTIME_COOLTIME, AMIMATIONTIME_COOLTIME, -22, 1);
		addRichListCtrlString(drawitems, GetItemNameAll(iInfo, true), getInstanceL2Util().BrightWhite, false, 5, 3);
		addRichListCtrlString(drawitems, iInfo.AdditionalName, getInstanceL2Util().Yellow03, false, 5, 0);
	}
	else
	{
		addRichListCtrlTexture(drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
		AddRichListCtrlItem(drawitems, iInfo, 32, 32, -34, 1);
		addRichListCtrlString(drawitems, GetItemNameAll(iInfo, true), getInstanceL2Util().BrightWhite, false, 5, 0);
		addRichListCtrlString(drawitems, iInfo.AdditionalName, getInstanceL2Util().Yellow03, false, 5, 0);
	}

	if(_form == nameSide)
	{
		addRichListCtrlString(drawitems, "x" $ MakeCostStringINT64(Amount * _buyNum), getInstanceL2Util().White, false, 5);
	}
	else if(_form == normalSideSmall)
	{
		addRichListCtrlString(drawitems, "x" $ MakeCostStringINT64(Amount * _buyNum), getInstanceL2Util().White, false, 5, 0);
	}
	else
	{
		addRichListCtrlString(drawitems, "x" $ MakeCostStringINT64(Amount * _buyNum), getInstanceL2Util().White, true, 40, 5);
	}
	totalNeednum = Amount * _buyNum;
	bEnoughItems = inventoryItemCount >= totalNeednum;

	if(!_bHideMyNum)
	{
		if(bEnoughItems)
		{
			itemNumColor = GetColor(0, 176, 255, 255);
		}
		else
		{
			itemNumColor = GetColor(255, 0, 0, 255);
		}

		if(_form != FORM_TYPE.nameSide)
		{
			addRichListCtrlString(drawitems, " (" $ MakeCostStringINT64(inventoryItemCount) $ ")", itemNumColor, false);
		}
		else
		{
			addRichListCtrlString(drawitems, " (" $ MakeCostStringINT64(inventoryItemCount) $ ")", itemNumColor, true, 36, 5);
		}
	}
	return true;
}

function ModifyCurrentAmount(int Index, INT64 currentAmount)
{
	local RichListCtrlRowData RowData;
	local INT64 totalNeednum;
	local bool bEnoughItems;
	local array<RichListCtrlDrawItem> drawitems;
	local RichListCtrlDrawItem drawItemNeedItem, drawItemCurrentItem;
	local Color itemNumColor;
	local int Row, Col;

	GetRowNCol(Index, Row, Col);

	if(NeedItemRichListCtrl.GetRecordCount() <= Row)
	{
		return;
	}
	NeedItemRichListCtrl.GetRec(Row, RowData);

	if(RowData.cellDataList.Length <= Col)
	{
		return;
	}
	drawitems = RowData.cellDataList[Col].drawitems;
	drawItemNeedItem = drawitems[needItemIndex];
	_currAmounts[Index] = currentAmount;

	if(!bUseAnimation)
	{
		_currAmountsAnimation[Index] = currentAmount;
	}
	totalNeednum = _needAmounts[Index] * _buyNum;
	bEnoughItems = _currAmounts[Index] >= totalNeednum;
	drawItemNeedItem.strInfo.strData = "x" $ MakeCostStringINT64(totalNeednum);
	RowData.cellDataList[Col].drawitems[needItemIndex] = drawItemNeedItem;

	if(!_bHideMyNum)
	{
		if(bEnoughItems)
		{
			itemNumColor = GetColor(0, 176, 255, 255);
		}
		else
		{
			itemNumColor = GetColor(255, 0, 0, 255);
		}
		drawItemCurrentItem = drawitems[CURRENTITEMINDEX];
		drawItemCurrentItem.strInfo.strData = " (" $ MakeCostStringINT64(_currAmountsAnimation[Index]) $ ")";
		drawItemCurrentItem.strInfo.strColor = itemNumColor;
		RowData.cellDataList[Col].drawitems[CURRENTITEMINDEX] = drawItemCurrentItem;
	}
	NeedItemRichListCtrl.ModifyRecord(Row, RowData);
}

function RichListCtrlRowData MakeRowDataByClassID(int ClassID, INT64 needAmount, INT64 currAmount)
{
	local ItemInfo Info;

	Info = GetItemInfoByClassID(ClassID);
	return MakeRowDataNeedItemInfo(Info, needAmount, currAmount);
}

function RichListCtrlRowData MakePointRecord(string Name, string TextureName, INT64 needAmount, INT64 currentAmount)
{
	local ItemInfo iInfo;

	iInfo = GetItemInfoByClassID(57);
	iInfo.IconName = TextureName;
	iInfo.Name = Name;
	return MakeRowDataNeedItemInfo(iInfo, needAmount, currentAmount);
}

function RichListCtrlRowData MakeRowDataNeedItemInfo(ItemInfo iInfo, INT64 needAmount, INT64 currAmount)
{
	local RichListCtrlRowData RowData;
	local string toolTipParam;
	local array<RichListCtrlDrawItem> drawitems;
	local int Row, Col;

	_totalIndex++;
	RowData.cellDataList.Length = _columnCount;
	ItemInfoToParam(iInfo, toolTipParam);
	RowData.szReserved = toolTipParam;

	if(_columnCount > 1)
	{
		GetRowNCol(_totalIndex, Row, Col);

		if(Col > 0)
		{
			NeedItemRichListCtrl.GetRec(Row, RowData);
		}
	}
	MakeNeedItemDrawItem(iInfo, needAmount, currAmount, drawitems);
	RowData.cellDataList[Col].drawitems = drawitems;
	_needAmounts[_totalIndex] = needAmount;
	_currAmounts[_totalIndex] = currAmount;
	_currAmountsAnimation[_totalIndex] = currAmount;
	_needItemClassIds[_totalIndex] = iInfo.Id.ClassID;
	return RowData;
}

function HandleItemSimpleUpdateListner(array<ItemInfo> iInfos, int Index)
{
	local INT64 ItemCount;
	local int i;

	if(iInfos.Length == 0)
	{
		ItemCount = 0;
	}
	else
	{
		if(IsStackableItem(iInfos[0].ConsumeType))
		{
			ItemCount = iInfos[0].ItemNum;
		}
		else
		{
			ItemCount = iInfos.Length;

			for(i = 0; i < iInfos.Length; i++)
			{
				if(iInfos[i].bEquipped)
				{
					ItemCount = ItemCount - 1;
				}
			}
		}
	}
	ModifyCurrentAmount(Index, ItemCount);

	if(bUseAnimation)
	{
		timerObj._Reset();
	}
	DelegateOnUpdateItem();
}

function InsertRecordNCheckScrollBar(RichListCtrlRowData RowData)
{
	local int Row, Col;

	GetRowNCol(_totalIndex, Row, Col);

	if(Col == 0)
	{
		NeedItemRichListCtrl.InsertRecord(RowData);
	}
	else
	{
		NeedItemRichListCtrl.ModifyRecord(Row, RowData);
	}
	CheckShowScrollBar();
}

function CheckShowScrollBar()
{
	local bool isShowScroll;

	isShowScroll = (NeedItemRichListCtrl.GetRecordCount() > _showRowNum) && _showRowNum > 0;
	NeedItemRichListCtrl.ShowScrollBar(isShowScroll);
}

function INT64 getItemCountByClassID(int ClassID)
{
	local array<ItemInfo> iInfos;
	local INT64 ItemCount;
	local int i;

	class'UIDATA_INVENTORY'.static.FindItemByClassID(ClassID, iInfos);

	if(iInfos.Length == 0)
	{
		ItemCount = 0;
	}
	else
	{
		if(IsStackableItem(iInfos[0].ConsumeType))
		{
			ItemCount = iInfos[0].ItemNum;
		}
		else
		{
			ItemCount = iInfos.Length;

			for(i = 0; i < iInfos.Length; i++)
			{
				if(iInfos[i].bEquipped)
				{
					ItemCount = ItemCount - 1;
				}
			}
		}
	}
	return ItemCount;
}

function int GetIndex(int Row, int Col)
{
	return (Row * _columnCount) + Col;
}

function GetRowNCol(int Index, out int Row, out int Col)
{
	Row = Index / _columnCount;
	Col = Index % _columnCount;
}

event OnClickButton(string btnName)
{
	DelegateOnClickButton(btnName);
}

defaultproperties
{
}
