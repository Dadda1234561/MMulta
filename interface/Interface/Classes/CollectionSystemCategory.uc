class CollectionSystemCategory extends UICommonAPI;

enum CollectionSystemCategoryState
{
	stand,
	Sub
};

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var array<CollectionSystemCategoryComponent> collectionSystemCategoryComponents;
var CollectionSystem collectionSystemScript;
var CollectionSystemCategoryState CurrentState;

function SetState(CollectionSystemCategoryState State)
{
	switch(State)
	{
		// End:0x15
		case CollectionSystemCategoryState.stand:
			SetStateStand();
			// End:0x26
			break;
		// End:0x23
		case CollectionSystemCategoryState.Sub:
			SetStateSub();
			// End:0x26
			break;
	}
	CurrentState = State;
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	util = L2Util(GetScript("L2Util"));
	collectionSystemScript = CollectionSystem(GetScript("collectionSystem"));
	InitCategoryButtons();
	Me.SetAnchor("", "BottomCenter", "BottomCenter", 0, -10);
}

function SetStateStand()
{
	local int i;

	for(i = 0; i < collectionSystemScript.MAX_CATEGORY; i++)
	{
		collectionSystemCategoryComponents[i].SetDeselecte();
	}
}

function SetStateSub()
{
	local int i;

	for(i = 0; i < collectionSystemScript.MAX_CATEGORY; i++)
	{
		collectionSystemCategoryComponents[i].SetDeselecte();
	}
	collectionSystemCategoryComponents[collectionSystemScript.selectedCategory - 1].SetSelecte();
}

function InitCategoryButtons()
{
	InitCategoryButton(0);
	InitCategoryButton(1);
	InitCategoryButton(2);
	InitCategoryButton(3);
	InitCategoryButton(4);
	InitCategoryButton(5);
	InitCategoryButton(6);
	InitCategoryButton(7);
}

function InitCategoryButton(int Num)
{
	local string _windowName, buttonName;

	buttonName = collectionSystemScript.GetStringNameByIndex(Num);
	_windowName = (m_WindowName $ ".CATEGORYBTN_wnd") $ (Int2Str2(Num));
	GetWindowHandle(_windowName).SetScript("CollectionSystemCategoryComponent");
	collectionSystemCategoryComponents[Num] = CollectionSystemCategoryComponent(GetWindowHandle(_windowName).GetScript());
	collectionSystemCategoryComponents[Num].Init(_windowName, buttonName, Num + 1);
}

function OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_Restart);
}

function OnLoad()
{
	Initialize();
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x1E
		case 150:
			// End:0x1B
			if(ChkSerVer())
			{
				HandleGameInit();
			}
			// End:0x21
			break;
	}
}

function OnShow()
{
}

function HandleGameInit()
{
	// End:0x1A
	if(GetGameStateName() != "GAMINGSTATE")
	{
		return;
	}
}

function bool SetCurrentCollectionCount()
{
	local int i;
	local CollectionCount tmpCollectionCount;

	for(i = 1; i <= (collectionSystemScript.MAX_CATEGORY - 2); i++)
	{
		// End:0x43
		if(! collectionSystemScript.API_GetCollectionCount(i, tmpCollectionCount))
		{
			return false;
		}
		collectionSystemCategoryComponents[i - 1].SetPoint(tmpCollectionCount.CollectionCompleteCount, tmpCollectionCount.CollectionTotalCount);
	}
	return true;
}

function HideAllDot()
{
	local int i;

	// End:0x36 [Loop If]
	for(i = 0; i < collectionSystemCategoryComponents.Length; i++)
	{
		collectionSystemCategoryComponents[i].HideDot();
	}
}

function ShowDot(int Category, int Type)
{
	collectionSystemCategoryComponents[Category - 1].ShowDot(Type);
}

function HideDot(int Category)
{
	collectionSystemCategoryComponents[Category - 1].HideDot();
}

function string Int2Str2(int i)
{
	// End:0x19
	if(i < 10)
	{
		return "0" $ string(i);
	}
	return string(i);
}

function bool GetStringIDFromBtnName(string btnName, string someString, out string strID)
{
	// End:0x17
	if(! CheckBtnName(btnName, someString))
	{
		return false;
	}
	strID = Mid(btnName, Len(someString));
	return true;
}

function bool CheckBtnName(string btnName, string someString)
{
	return Left(btnName, Len(someString)) == someString;
}

function bool ChkSerVer()
{
	return getInstanceUIData().getIsLiveServer();
}

defaultproperties
{
}
