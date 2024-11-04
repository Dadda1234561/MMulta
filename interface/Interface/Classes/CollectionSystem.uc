class CollectionSystem extends UICommonAPI;

const STATESTAND = "stateStand";
const STATESUB = "stateSub";
const collectionstateName = "COLLECTIONSTATE";
const MAX_SLOT = 6;

enum collectionState
{
	non,
	stand,
	Sub,
	subProgress,
	mainProgress,
	detailinfo
};

enum LIST_REQUESTEDMODE
{
	Normal,
	modify
};

var WindowHandle Me;
var(LeeHardcom) string m_WindowName;
var array<WindowHandle> KeyItems;
var array<TextureHandle> MainBG_texs;
var array<TextureHandle> MainBG_texsAni;
var WindowHandle m_CollectionSystemCategory;
var WindowHandle m_CollectionSystemSub;
var WindowHandle m_CollectionSystemSubPopupProgress;
var WindowHandle m_CollectionSystemPopupDetails;
var collectionState CurrentState;
var CollectionSystemCategory collectionSystemCategoryScript;
var CollectionSystemSub collectionSystemSubScript;
var CollectionSystemSubPopupProgress CollectionSystemSubPopupProgressScript;
var CollectionSystemPopupDetails CollectionSystemPopupDetailsScript;
var int stadardClickedCategory;
var array<CollectionSystemStandComponent> collectionSystemStandComponentScripts;
var array<CollectionSystemStandComponent> collectionSystemStandComponentFavoriteScript;
var CollectionSystemProgressComponent ProgressCollectionComplete_wndScript;
var CollectionSystemProgressComponent ProgressItemComplete_wndScript;
var array<CollectionMainData> cMainDatas;
var int selectedCategory;
var ItemInfo toFindItemInfo;
var int MAX_CATEGORY;
var int favoriteCategory;
var LIST_REQUESTEDMODE requestedMode;
var int currentBackgroundLevel;
var int max_Background;
var private bool bRequest_C_EX_COLLECTION_OPEN_UI;

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	m_CollectionSystemCategory = GetWindowHandle(m_WindowName $ ".CollectionSystemCategory");
	m_CollectionSystemSub = GetWindowHandle(m_WindowName $ ".CollectionSystemSub");
	m_CollectionSystemSubPopupProgress = GetWindowHandle(m_WindowName $ ".CollectionSystemSubPopupProgress");
	m_CollectionSystemPopupDetails = GetWindowHandle(m_WindowName $ ".CollectionSystemPopupDetails");
	collectionSystemSubScript = CollectionSystemSub(m_CollectionSystemSub.GetScript());
	collectionSystemCategoryScript = CollectionSystemCategory(m_CollectionSystemCategory.GetScript());
	CollectionSystemPopupDetailsScript = CollectionSystemPopupDetails(m_CollectionSystemPopupDetails.GetScript());
	CollectionSystemSubPopupProgressScript = CollectionSystemSubPopupProgress(m_CollectionSystemSubPopupProgress.GetScript());
	SetMainDatas();
	InitKeyItemWindows();
	InitProgressComponents();
}

function InitKeyItemWindows()
{
	local int i;

	for(i = 0; GetWindowHandle(KeyItemWIndowName(i)).m_pTargetWnd != none; i++)
	{
		KeyItems[i] = GetWindowHandle(KeyItemWIndowName(i));
		KeyItems[i].HideWindow();
		MainBG_texs[i] = GetTextureHandle(m_WindowName $ ".MainBG_tex" $ Int2Str2(i));
		MainBG_texs[i].HideWindow();
		MainBG_texsAni[i] = GetTextureHandle(m_WindowName $ ".MainBG_texAni" $ Int2Str2(i));
		MainBG_texsAni[i].SetAlpha(0);
	}
	KeyItems[0].ShowWindow();
}

function InitProgressComponents()
{
	local string _progressWindowName;

	_progressWindowName = m_WindowName $ ".ProgressGroup_wnd.ProgressCollectionComplete_wnd";
	GetWindowHandle(_progressWindowName).SetScript("CollectionSystemProgressComponent");
	ProgressCollectionComplete_wndScript = CollectionSystemProgressComponent(GetWindowHandle(_progressWindowName).GetScript());
	ProgressCollectionComplete_wndScript.Init(_progressWindowName);
	ProgressCollectionComplete_wndScript.DelegateOnButtonClick = HandleOnClickProgressComponent;
	_progressWindowName = m_WindowName $ ".ProgressGroup_wnd.ProgressItemComplete_wnd";
	GetWindowHandle(_progressWindowName).SetScript("CollectionSystemProgressComponent");
	ProgressItemComplete_wndScript = CollectionSystemProgressComponent(GetWindowHandle(_progressWindowName).GetScript());
	ProgressItemComplete_wndScript.Init(_progressWindowName);
	ProgressItemComplete_wndScript.DelegateOnButtonClick = HandleOnClickProgressComponent;
}

function SetMainDatas()
{
	local int mainID;
	local CollectionMainData cMainData;

	for(mainID = 1; API_GetCollectionMainData(mainID, cMainData); mainID++)
	{
		cMainDatas[cMainDatas.Length] = cMainData;
		if(MAX_CATEGORY < cMainData.Category)
		{
			MAX_CATEGORY = cMainData.Category;
		}
		if(max_Background < cMainData.background_level)
		{
			max_Background = cMainData.background_level;
		}
		InitKeyItemButton(cMainData);
	}
	if(max_Background == 1)
	{
		GetButtonHandle(m_WindowName $ ".nextBtn").HideWindow();
		GetButtonHandle(m_WindowName $ ".prevBtn").HideWindow();
	}
	++ MAX_CATEGORY;
	favoriteCategory = MAX_CATEGORY;
	InitFavoriteButtons();
}

function SetShowKeyItemButtons()
{
	local int i;

	for(i = 0; i < cMainDatas.Length; i++)
	{
		collectionSystemStandComponentScripts[i].SetShow();
	}

	for(i = 0; i < collectionSystemStandComponentFavoriteScript.Length; i++)
	{
		collectionSystemStandComponentFavoriteScript[i].SetShow();
	}
}

function InitKeyItemButton(CollectionMainData mData)
{
	local string _windowName;
	local int Index;

	Index = mData.main_id - 1;
	_windowName = KeyItemWIndowName(mData.background_level - 1) $ ".KeyItemBTN" $ Int2Str2(Index) $ "_wnd";
	GetWindowHandle(_windowName).SetScript("CollectionSystemStandComponent");
	collectionSystemStandComponentScripts[Index] = CollectionSystemStandComponent(GetWindowHandle(_windowName).GetScript());
	collectionSystemStandComponentScripts[Index].Init(_windowName, mData);
}

function InitFavoriteButton(int backgroundLevel)
{
	local string _windowName;
	local CollectionMainData cMainData;

	_windowName = (KeyItemWIndowName(backgroundLevel - 1)) $ ".KeyItemBTNFavorite_wnd";
	GetWindowHandle(_windowName).SetScript("CollectionSystemStandComponent");
	cMainData.background_level = backgroundLevel;
	collectionSystemStandComponentFavoriteScript[backgroundLevel - 1] = CollectionSystemStandComponent(GetWindowHandle(_windowName).GetScript());
	collectionSystemStandComponentFavoriteScript[backgroundLevel - 1].Init(_windowName, cMainData, true);
}

function InitFavoriteButtons()
{
	local int i;

	// End:0x2B [Loop If]
	for(i = 1; i <= max_Background; i++)
	{
		InitFavoriteButton(i);
	}
}

function string API_GetGeneralEffectName(string KeyName)
{
	return GetGeneralEffectName(KeyName);
}

function bool API_GetCollectionOptionName(int Category, out array<string> optionNames)
{
	optionNames.Length = 0;
	return GetCollectionOptionName(Category, optionNames);
}

function bool API_GetCollectionData(int collection_ID, out CollectionData Data)
{
	local CollectionData cdata;

	Data = cdata;
	return GetCollectionData(collection_ID, Data);
}

function bool API_GetCollectionMainData(int main_id, out CollectionMainData Data)
{
	local CollectionMainData mData;

	Data = mData;
	return GetCollectionMainData(main_id, Data);
}

function bool API_GetCollectionIdByItemName(out array<int> collectionid, int Category, bool onlyComplete, bool onlyNotComplete, optional bool favorite, optional string ItemName, optional string optionName, optional bool onlyProgress)
{
	collectionid.Length = 0;
	return GetCollectionIdByItemName(collectionid, Category, onlyComplete, onlyNotComplete, favorite, ItemName, optionName, onlyProgress);
}

function bool API_GetCollectionIdByItemId(out array<int> collectionid, int ItemID)
{
	collectionid.Length = 0;
	return GetCollectionIdByItemId(collectionid, ItemID);
}

function bool API_IsCollectionRegistEnableItem(ItemID sID, optional int collectionid, optional int SlotID)
{
	return IsCollectionRegistEnableItem(sID, collectionid, SlotID);
}

function bool API_IsCollectionRegistEnableItemWithReason(ItemID sID, int collectionid, int SlotID, out CollectionRegistFailReason Reason)
{
	return IsCollectionRegistEnableItemWithReason(sID, collectionid, SlotID, Reason);
}

function bool API_GetCollectionInfo(int collection_ID, out CollectionInfo Info)
{
	return GetCollectionInfo(collection_ID, Info);
}

function bool API_GetCollectionCount(int Category, out CollectionCount Count)
{
	return GetCollectionCount(Category, Count);
}

function bool API_GetCollectionOption(out array<CollectionOption> Option)
{
	Option.Length = 0;
	return GetCollectionOption(Option);
}

function bool API_GetCompletePeriodCollection(out array<int> collectionid)
{
	collectionid.Length = 0;
	return GetCompletePeriodCollection(collectionid);
}

function C_EX_COLLECTION_SUMMARY()
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_SUMMARY packet;

	packet.cDummy = 1;
	if(! class'UIPacket'.static.Encode_C_EX_COLLECTION_SUMMARY(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_COLLECTION_SUMMARY, stream);
}

function API_C_EX_COLLECTION_LIST(int Category, optional LIST_REQUESTEDMODE _requestedMode)
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_LIST packet;

	packet.cCategory = Category;
	if(! class'UIPacket'.static.Encode_C_EX_COLLECTION_LIST(stream, packet))
	{
		return;
	}
	requestedMode = _requestedMode;
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_COLLECTION_LIST, stream);
}

function API_C_EX_COLLECTION_FAVORITE_LIST(optional LIST_REQUESTEDMODE _requestedMode)
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_FAVORITE_LIST packet;

	packet.cDummy = 0;
	// End:0x2C
	if(! class'UIPacket'.static.Encode_C_EX_COLLECTION_FAVORITE_LIST(stream, packet))
	{
		return;
	}
	requestedMode = _requestedMode;
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_COLLECTION_FAVORITE_LIST, stream);
}

function API_C_EX_COLLECTION_OPEN_UI()
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_OPEN_UI packet;


	// End:0x0B
	if(bRequest_C_EX_COLLECTION_OPEN_UI)
	{
		return;
	}
	packet.cDummy = 0;
	// End:0x2C
	if(! class'UIPacket'.static.Encode_C_EX_COLLECTION_OPEN_UI(stream, packet))
	{
		return;
	}
	// End:0x7D
	if(class'ItemAutoPeelWnd'.static.Inst().IsItemPeeling() == true)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13680));
		return;
	}
	bRequest_C_EX_COLLECTION_OPEN_UI = true;
	m_hOwnerWnd.SetTimer(9, 5000);
	SideBar(GetScript("SideBar")).SideBarLockVOption(true);
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_COLLECTION_OPEN_UI, stream);
}

function API_C_EX_COLLECTION_CLOSE_UI()
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_CLOSE_UI packet;

	packet.cDummy = 0;
	// End:0x2C
	if(! class'UIPacket'.static.Encode_C_EX_COLLECTION_CLOSE_UI(stream, packet))
	{
		return;
	}
	SideBar(GetScript("SideBar")).SideBarLockVOption(false);
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_COLLECTION_CLOSE_UI, stream);
}

function API_C_EX_COLLECTION_REGISTER(int nCollectionID, int nSlotNumber, int nItemSid)
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_REGISTER packet;

	packet.nCollectionID = nCollectionID;
	packet.nSlotNumber = nSlotNumber;
	packet.nItemSid = nItemSid;
	// End:0x50
	if(! class'UIPacket'.static.Encode_C_EX_COLLECTION_REGISTER(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_COLLECTION_REGISTER, stream);
}

function API_C_EX_COLLECTION_RECEIVE_REWARD(int nCollectionID)
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_RECEIVE_REWARD packet;

	packet.nCollectionID = nCollectionID;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_COLLECTION_RECEIVE_REWARD(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_COLLECTION_RECEIVE_REWARD, stream);
}

function API_C_EX_COLLECTION_UPDATE_FAVORITE(bool bRegister, int nCollectionID)
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_UPDATE_FAVORITE packet;

	// End:0x19
	if(bRegister)
	{
		packet.bRegister = 1;
	}
	else
	{
		packet.bRegister = 0;
	}
	packet.nCollectionID = nCollectionID;
	// End:0x56
	if(! class'UIPacket'.static.Encode_C_EX_COLLECTION_UPDATE_FAVORITE(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_COLLECTION_UPDATE_FAVORITE, stream);
}

event OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_ShortcutCommand);
	RegisterEvent(EV_CollectionInfoEnd);
	RegisterEvent(EV_CollectionList);
	RegisterEvent(EV_CollectionFavoriteList);
	RegisterEvent(EV_CollectionSummary);
	RegisterEvent(EV_CollectionUpdateFavorite);
	RegisterEvent(EV_CollectionRegister);
	RegisterEvent(EV_CollectionComplete);
	RegisterEvent(EV_CollectionReceiveReward);
	RegisterEvent(EV_CollectionResetReward);
	RegisterEvent(EV_CollectionReset);
	RegisterEvent(EV_CollectionActiveEvent);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_COLLECTION_CLOSE_UI);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_COLLECTION_OPEN_UI);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_COLLECTION_COMPLETE);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_COLLECTION_SUMMARY);
}

event OnLoad()
{
	Initialize();
}

event OnEvent(int Event_ID, string param)
{
	if(L2Util(GetScript("L2Util")).bIsUsefulCollectionView) 
	{
		return;
	}	
	
	switch(Event_ID)
	{
		case EV_GamingStateEnter:
			if(ChkSerVer())
			{
				HandleGameInit();
			}
			break;
		case EV_ShortcutCommand:
			HandleShortcutCommand(param);
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_COLLECTION_SUMMARY:
			CollectionSystemSubPopupProgressScript.SetCollectionOptions();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_COLLECTION_OPEN_UI:
			S_EX_COLLECTION_OPEN_UI();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_COLLECTION_CLOSE_UI:
			S_EX_COLLECTION_CLOSE_UI();
			break;
		case EV_CollectionInfoEnd:
			Handle_EV_CollectionInfoEnd(param);
			break;
		case EV_CollectionList:
			Handle_EV_CollectionList(param);
			break;
		case EV_CollectionFavoriteList:
			Handle_EV_CollectionFavoriteList(param);
			break;
		case EV_CollectionSummary:
			Handle_EV_CollectionSummary(param);
			break;
		case EV_CollectionUpdateFavorite:
			Handle_EV_CollectionUpdateFavorite(param);
			break;
		case EV_CollectionRegister:
			Handle_EV_CollectionRegister(param);
			break;
		case EV_CollectionComplete:
			Handle_EV_CollectionComplete(param);
			break;
		case EV_CollectionReceiveReward:
			Handle_EV_CollectionReceiveReward(param);
			break;
		case EV_CollectionResetReward:
			Handle_EV_CollectionResetReward(param);
			break;
		case EV_CollectionReset:
			Handle_EV_CollectionReset(param);
			break;
		case EV_CollectionActiveEvent:
			Handle_EV_CollectionActiveEvent(param);
			break;
	}
}

event OnHide()
{
	ClearFinding();
}

event OnTick()
{
	C_EX_COLLECTION_SUMMARY();
	Me.DisableTick();
}

event OnTimer(int tID)
{
	bRequest_C_EX_COLLECTION_OPEN_UI = false;
	m_hOwnerWnd.KillTimer(9);	
}

function ClearFinding()
{
	collectionSystemSubScript.EditBoxFind_EditBox.SetString("");
	collectionSystemSubScript.A0_ComboBox.SetSelectedNum(0);
	collectionSystemSubScript.A1_ComboBox.SetSelectedNum(0);
	collectionSystemCategoryScript.HideAllDot();
}

function Handle_EV_CollectionInfoEnd(string param)
{
	Debug("EV_CollectionInfoEnd" @ param);
}

function Handle_EV_CollectionList(string param)
{
	local int Category;

	ParseInt(param, "Category", Category);
	switch(CurrentState)
	{
		case collectionState.Sub:
		case collectionState.subProgress:
		case collectionState.detailinfo:
			if(selectedCategory == Category)
			{
				collectionSystemSubScript.SetCategory(Category);
				// End:0x7A
				if(stadardClickedCategory >= 0)
				{
					collectionSystemSubScript.SetSelectByCollectionID(stadardClickedCategory);
					SetState(detailinfo);
				}
				stadardClickedCategory = -1;
			}
	}
}

function SetCollectionPopupDetail(int tmpCategory)
{
	stadardClickedCategory = tmpCategory;
}

function Handle_EV_CollectionFavoriteList(string param)
{
	switch(CurrentState)
	{
		case collectionState.Sub:
		case collectionState.subProgress:
		case collectionState.detailinfo:
			// End:0x39
			if(selectedCategory == favoriteCategory)
			{
				collectionSystemSubScript.SetCategory(favoriteCategory);
			}
	}
}

function Handle_EV_CollectionSummary(string param)
{
	collectionSystemCategoryScript.SetCurrentCollectionCount();
	collectionSystemSubScript.SetCurrentCollectionCount();
}

function Handle_EV_CollectionUpdateFavorite(string param)
{
	local int collectionid;

	ParseInt(param, "CollectionID", collectionid);
	collectionSystemSubScript.ModifyRecordByCollectionID(collectionid);
}

function Handle_EV_CollectionRegister(string param)
{
	local int Success, collectionid;

	ParseInt(param, "Success", Success);
	// End:0x26
	if(Success != 1)
	{
		return;
	}
	ParseInt(param, "CollectionID", collectionid);
	switch(selectedCategory)
	{
		// End:0x5C
		case favoriteCategory:
			API_C_EX_COLLECTION_FAVORITE_LIST();
			// End:0x6F
			break;
		// End:0xFFFF
		default:
			API_C_EX_COLLECTION_LIST(selectedCategory, modify);
			// End:0x6F
			break;
	}
	CollectionSystemPopupDetailsScript.HandleCollectionRegisted(collectionid);
}

function Handle_EV_CollectionComplete(string param)
{
	local int collectionid, i;

	ParseInt(param, "CollectionID", collectionid);
	collectionSystemSubScript.ModifyRecordByCollectionID(collectionid);
	CollectionSystemPopupDetailsScript.HandleCompleted(collectionid);

	for(i = 0; i < MAX_CATEGORY; i++)
	{
		collectionSystemStandComponentScripts[i].SetComplete();
	}
	Me.EnableTick();
}

function Handle_EV_CollectionReceiveReward(string param)
{
	local int collectionid, Success;

	ParseInt(param, "Success", Success);
	// End:0x26
	if(Success != 1)
	{
		return;
	}
	ParseInt(param, "CollectionID", collectionid);
	collectionSystemSubScript.ModifyRecordByCollectionID(collectionid);
	CollectionSystemPopupDetailsScript.HandleCompleted(collectionid);
}

function Handle_EV_CollectionResetReward(string param)
{
}

function Handle_EV_CollectionReset(string param)
{
	local int collectionid;

	ParseInt(param, "CollectionID", collectionid);
	collectionSystemSubScript.ModifyRecordByCollectionID(collectionid);
	CollectionSystemPopupDetailsScript.HandleCompleted(collectionid);
}

function Handle_EV_CollectionActiveEvent(string param)
{
}

function S_EX_COLLECTION_CLOSE_UI()
{
	local UIPacket._S_EX_COLLECTION_CLOSE_UI packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_COLLECTION_CLOSE_UI(packet))
	{
		return;
	}
	class'UIDATA_API'.static.SetState("GAMINGSTATE");
}

function S_EX_COLLECTION_OPEN_UI()
{
	local UIPacket._S_EX_COLLECTION_OPEN_UI packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_COLLECTION_OPEN_UI(packet))
	{
		return;
	}
	class'UIDATA_API'.static.SetState(collectionstateName);
	bRequest_C_EX_COLLECTION_OPEN_UI = false;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "BtnClose":
			SetState(non);
			break;
		case "prevBtn":
			ShowBackgroundLevel(currentBackgroundLevel - 1);
			break;
		case "nextBtn":
			ShowBackgroundLevel(currentBackgroundLevel + 1);
			break;
	}
}

event OnShow()
{
	collectionSystemCategoryScript.SetCurrentCollectionCount();
	currentBackgroundLevel = max_Background - 1;
	SetState(stand);
	Me.SetFocus();
	CheckToFindListByIteminfo();
	stadardClickedCategory = -1;
	// End:0x66
	if(collectionSystemSubScript.SetCurrentCollectionCount())
	{
		collectionSystemSubScript.SetCollectionCount();
	}
	bRequest_C_EX_COLLECTION_OPEN_UI = false;
}

function SetToFindItemInfo(ItemInfo iInfo)
{
	toFindItemInfo = iInfo;
}

function CheckToFindListByIteminfo()
{
	local ItemInfo iInfo, nullInfo;

	// End:0x14
	if(toFindItemInfo == nullInfo)
	{
		return;
	}
	iInfo = toFindItemInfo;
	ShowCollectionListByItemInfo(iInfo);
	toFindItemInfo = nullInfo;
}

function HandleOnClickProgressComponent()
{
	switch(CurrentState)
	{
		case collectionState.Sub:
			SetState(subProgress);
			// End:0x2A
			break;
		case collectionState.stand:
			SetState(mainProgress);
			// End:0x2A
			break;
	}
}

function SetCurrentCategory(int Category)
{
	selectedCategory = Category;
	switch(selectedCategory)
	{
		// End:0x23
		case favoriteCategory:
			API_C_EX_COLLECTION_FAVORITE_LIST();
			break;
		// End:0xFFFF
		default:
			API_C_EX_COLLECTION_LIST(selectedCategory);
			break;
	}
	collectionSystemSubScript.SetCategory(Category);
	SetState(Sub);
}

function HandleShortcutCommand(string param)
{
	local string Command;

	ParseString(param, "Command", Command);
	switch(Command)
	{
		case "OnESCCollectionState":
			OnReceivedCloseUICommand();
			// End:0x45
			break;
	}
}

function HandleGameInit()
{
	collectionSystemSubScript.InitComboBoxes();
}

function bool _IsCollectionOpen()
{
	// End:0x0B
	if(bRequest_C_EX_COLLECTION_OPEN_UI)
	{
		return true;
	}
	// End:0x1F
	if(m_hOwnerWnd.IsShowWindow())
	{
		return true;
	}
	// End:0x3D
	if(GetGameStateName() == collectionstateName)
	{
		return true;
	}
	return false;	
}

function HideCurrentKeyItems()
{
	KeyItems[currentBackgroundLevel].HideWindow();
}

function bool SetNextBtnState(int backgroundLevel)
{
	return false;
	// End:0x16
	if(backgroundLevel > (max_Background - 1))
	{
		return true;
	}
	// End:0x23
	if(backgroundLevel < 0)
	{
		return true;
	}
	// End:0x52
	if(backgroundLevel == 0)
	{
		GetButtonHandle(m_WindowName $ ".prevBtn").DisableWindow();
	}
	else
	{
		GetButtonHandle(m_WindowName $ ".prevBtn").EnableWindow();
	}
	// End:0xA9
	if(backgroundLevel == (max_Background - 1))
	{
		GetButtonHandle(m_WindowName $ ".nextBtn").DisableWindow();
	}
	else
	{
		GetButtonHandle(m_WindowName $ ".nextBtn").EnableWindow();
	}
	return false;
}

function ShowBackgroundLevel(int backgroundLevel)
{
	local int i;

	if(SetNextBtnState(backgroundLevel))
	{
		return;
	}

	if(backgroundLevel > (max_Background - 1))
	{
		backgroundLevel = 0;
	}
	else if(backgroundLevel < 0)
	{
		backgroundLevel = max_Background - 1;
	}

	// End:0xA5 [Loop If]
	for(i = 0; i < max_Background; i++)
	{
		MainBG_texsAni[i].SetAlpha(0);
		MainBG_texs[i].HideWindow();
		KeyItems[i].HideWindow();
	}
	if(backgroundLevel != currentBackgroundLevel)
	{
		MainBG_texsAni[currentBackgroundLevel].SetAlpha(255);
		MainBG_texsAni[currentBackgroundLevel].SetAlpha(0, 0.50f);
	}
	SetShowKeyItemButtons();
	MainBG_texs[backgroundLevel].ShowWindow();
	KeyItems[backgroundLevel].ShowWindow();
	currentBackgroundLevel = backgroundLevel;
}

function string KeyItemWIndowName(int backgroundLevel)
{
	return m_WindowName $ ".KeyItems" $ Int2Str2(backgroundLevel);
}

function bool IsKeyItem(int collectionid)
{
	local int i;

	for(i = 0; i < cMainDatas.Length; i++)
	{
		// End:0x33
		if(cMainDatas[i].collection_ID == collectionid)
		{
			return true;
		}
	}
	return false;
}

function int GetSubIndexByMainID(int mainID)
{
	local CollectionMainData cMainData;
	local int Category, i, subIndex;

	API_GetCollectionMainData(mainID, cMainData);
	Category = cMainData.Category;

	for(i = 1; API_GetCollectionMainData(i, cMainData); i++)
	{
		// End:0x4F
		if(i == mainID)
		{
			return subIndex;
		}
		// End:0x6A
		if(cMainData.Category == Category)
		{
			++ subIndex;
		}
	}
	return -1;
}

function string GetStringKeyByIndex(int Index, optional int subIndex)
{
	local string indexName;

	switch(Index)
	{
		case 0:
			indexName = "A";
			break;
		case 1:
			indexName = "B";
			break;
		case 2:
			indexName = "C";
			break;
		case 3:
			indexName = "D";
			break;
		case 4:
			indexName = "E";
			break;
		case 5:
			indexName = "F";
			break;
		case 6:
			indexName = "G";
			break;
		case favoriteCategory - 1:
			indexName = "H";
			break;
	}

	if(getInstanceUIData().getIsLiveServer())
	{
		return "live_" $ indexName $ "_" $ Int2Str2(subIndex);
	}
	else
	{
		return "col_" $ indexName $ "_" $ Int2Str2(subIndex);
	}
}

function string GetStringNameByIndex(int Index)
{
	switch(Index)
	{
		// End:0x17
		case 0:
			return GetSystemString(13702);
		// End:0x27
		case 1:
			return GetSystemString(13703);
		// End:0x38
		case 2:
			return GetSystemString(13704);
		// End:0x49
		case 3:
			return GetSystemString(13705);
		// End:0x5A
		case 4:
			return GetSystemString(13706);
		// End:0x6B
		case 5:
			return GetSystemString(13707);
		// End:0x7C
		case 6:
			return GetSystemString(13708);
		// End:0x93
		case favoriteCategory - 1:
			return GetSystemString(13709);
		default:
			return "";
	}
}

function ShowCollectionListByItemInfo(ItemInfo iInfo)
{
	local CollectionData cdata;

	cdata = RegistEnableCategory(iInfo);
	selectedCategory = cdata.main_category;
	collectionSystemSubScript.SetSearchInit();
	collectionSystemSubScript.SetFindKeyWord(toFindItemInfo.Name);
	collectionSystemSubScript.SetCategory(selectedCategory);
	SetState(Sub);
}

function CollectionData RegistEnableCategory(ItemInfo iInfo)
{
	local int i, Len;
	local CollectionData cdata;
	local array<int> collectionIds;

	API_GetCollectionIdByItemId(collectionIds, iInfo.Id.ClassID);
	Len = collectionIds.Length;

	for(i = 0; i < Len; i++)
	{
		API_GetCollectionData(collectionIds[i], cdata);
		if(API_IsCollectionRegistEnableItem(iInfo.Id, cdata.collection_ID, -1))
		{
			return cdata;
		}
	}
	API_GetCollectionData(collectionIds[0], cdata);
	return cdata;
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

function SetState(collectionState State)
{
	GetWindowHandle(m_WindowName $ ".ProgressGroup_wnd").HideWindow();
	switch(State)
	{
		case collectionState.non:
			API_C_EX_COLLECTION_CLOSE_UI();
			break;
		case collectionState.stand:
			ClearFinding();
			GetWindowHandle(m_WindowName $ ".ProgressGroup_wnd").ShowWindow();
			ShowBackgroundLevel(currentBackgroundLevel);
			SetShowKeyItemButtons();
			m_CollectionSystemSub.HideWindow();
			collectionSystemCategoryScript.SetState(collectionSystemCategoryScript.CollectionSystemCategoryState.stand);
			CollectionSystemPopupDetailsScript.Me.HideWindow();
			CollectionSystemSubPopupProgressScript.Me.HideWindow();
			break;
		case collectionState.Sub:
			HideCurrentKeyItems();
			m_CollectionSystemSub.ShowWindow();
			collectionSystemSubScript.InitComboboxA1();
			CollectionSystemPopupDetailsScript.Me.HideWindow();
			CollectionSystemSubPopupProgressScript.Me.HideWindow();
			collectionSystemCategoryScript.SetState(collectionSystemCategoryScript.CollectionSystemCategoryState.Sub);
			break;
		case collectionState.mainProgress:
			GetWindowHandle(m_WindowName $ ".ProgressGroup_wnd").ShowWindow();
			CollectionSystemSubPopupProgressScript.SetCollectionOptions();
			CollectionSystemSubPopupProgressScript.Me.ShowWindow();
			break;
		case collectionState.subProgress:
			CollectionSystemSubPopupProgressScript.SetCollectionOptions();
			CollectionSystemSubPopupProgressScript.Me.ShowWindow();
			break;
		case collectionState.detailinfo:
			CollectionSystemPopupDetailsScript.Me.ShowWindow();
			break;
	}
	CurrentState = State;
}

function PrevState()
{
	switch(CurrentState)
	{
		case collectionState.non:
			return;
		case collectionState.stand:
			SetState(non);
			break;
		case collectionState.Sub:
			SetState(stand);
			break;
		case collectionState.subProgress:
			SetState(Sub);
			break;
		case collectionState.mainProgress:
			SetState(stand);
			break;
		case collectionState.detailinfo:
			CollectionSystemPopupDetailsScript.OnClickESC();
			break;
	}
}

function OnReceivedCloseUICommand()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	PrevState();
}

function bool ChkSerVer()
{
	return getInstanceUIData().getIsLiveServer();
}

defaultproperties
{
}
