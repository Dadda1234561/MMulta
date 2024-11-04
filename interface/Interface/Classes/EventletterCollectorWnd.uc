//================================================================================
// EventletterCollectorWnd.
//================================================================================

class EventletterCollectorWnd extends UICommonAPI;

const SET_MAX = 5;

var string m_WindowName;
var WindowHandle Me;
var int currentSetMax;
var array<LetterCollectUIData> arrLetterCollectUIData;
var array<INT64> minNums;
var int MinLevel;

function OnRegisterEvent()
{
	RegisterEvent(EV_InventoryUpdateItem);
	RegisterEvent(EV_GotoWorldRaidServer);
	RegisterEvent(EV_UpdateUserInfo);
}

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle(m_WindowName);
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_InventoryUpdateItem:
			HandleUpdateItem(param);
			break;
		case EV_GotoWorldRaidServer:
			Me.HideWindow();
			if(class'UIAPI_WINDOW'.static.IsShowWindow("EventletterCollectorLauncher"))
			{
				class'UIAPI_WINDOW'.static.HideWindow("EventletterCollectorLauncher");
			}
			break;
		case EV_UpdateUserInfo:
			HandleUserInfo();
			break;
		default:
	}
}

function OnShow()
{
	if(! getInstanceUIData().getIsClassicServer())
	{
		GetWindowHandle(m_WindowName $ ".WindowHelp_BTN").HideWindow();
	}
	Debug("EventletterCollectorWnd OnShow");
	API_GetLetterCollectData(arrLetterCollectUIData);
	SetWindow();
	Settems();
	Me.SetFocus();
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local int Index;

	switch(a_ButtonHandle.GetWindowName())
	{
		case "LetterWndGet_Btn":
			Index = int(Right(a_ButtonHandle.GetParentWindowName(), 1)) - 1;
			Debug("OnClickButtonWithHandle" @a_ButtonHandle.GetParentWindowName() @string(Index) @string(arrLetterCollectUIData[Index].Id));
			API_C_EX_LETTER_COLLECTOR_TAKE_REWARD(arrLetterCollectUIData[Index].Id);
			break;
		case "WindowHelp_BTN":
			HandleBtnClickHelp();
			break;
		default:
	}
}

function Settems()
{
	local int i;
	local int j;
	local int ClassID;
	local ItemInfo Info;
	local ItemWindowHandle ItemWnd;
	local LetterCollectUIData letterCollectData;
	local array<int> classIDs;
	local InventoryWnd invenScript;

	invenScript = InventoryWnd(GetScript("InventoryWnd"));

	for (j = 1; j <= currentSetMax; j++)
	{
		letterCollectData = arrLetterCollectUIData[j - 1];
		ItemWnd = GetItemWindowByID(j);
		ItemWnd.Clear();

		for (i = 0; i < letterCollectData.LetterItemIDs.Length; i++)
		{
			ClassID = letterCollectData.LetterItemIDs[i];
			checkArray(classIDs, ClassID);
			GetItemInfo(ClassID, Info);
			ItemWnd.AddItem(Info);
		}
	}

	for (i = 0; i < classIDs.Length; i++)
	{
		HandleUpdateItemCounts(classIDs[i], invenScript.getItemCountByClassID(classIDs[i]));
	}
	GetMinNums();
	CheckCanRewardBtns();
}

function checkArray(out array<int> classIDs, int ClassID)
{
	local int i;

	for(i=0; i < classIDs.Length; i++)
	{
		if(classIDs[i] == ClassID)
		{
			return;
		}
	}
	classIDs.Length = classIDs.Length + 1;
	classIDs[classIDs.Length - 1] = ClassID;
}

function bool GetItemInfo(int ClassID, out ItemInfo Info)
{
	local ItemInfo nullInfo;

	Info = GetItemInfoByClassID(ClassID);

	if(Info == nullInfo)
	{
		return false;
	}
	Info.bShowCount = true;
	return true;
}

function SetItemNum(INT64 ItemNum, INT64 displayNum, out ItemInfo Info)
{
	Info.ItemNum = displayNum;

	if(ItemNum < 1)
	{
		Info.bDisabled = 1;
	}
	else
	{
		Info.bDisabled = 0;
	}
}

function HandleUpdateItem(string param)
{
	local int ClassID;
	local INT64 ItemNum;
	local string Type;

	if(! Me.IsShowWindow())
	{
		return;
	}
	ParseInt(param, "ClassID", ClassID);
	ParseString(param, "type", Type);

	if(Type == "delete")
	{
		ItemNum = 0;
	}
	else
	{
		ParseINT64(param, "ItemNum", ItemNum);
	}
	HandleUpdateItemCounts(ClassID, ItemNum);
	GetMinNums();
	CheckCanRewardBtns();
}

function HandleUpdateItemCounts(int ClassID, INT64 totalNum)
{
	local int i;
	local int j;
	local INT64 tmpNum;
	local ItemWindowHandle ItemWnd;
	local ItemInfo Info;
	local LetterCollectUIData letterCollectData;

	for(j=1; j <= currentSetMax; j++)
	{
		ItemWnd = GetItemWindowByID(j);
		tmpNum = totalNum;
		letterCollectData = arrLetterCollectUIData[j - 1];

		for (i=0; i < letterCollectData.LetterItemIDs.Length; i++)
		{
			if(letterCollectData.LetterItemIDs[i] == ClassID)
			{
				ItemWnd.GetItem(i, Info);
				SetItemNum(tmpNum, totalNum, Info);
				tmpNum = tmpNum - 1;

				if(tmpNum < 0)
				{
					tmpNum = 0;
				}
				ItemWnd.SetItem(i, Info);
			}
		}
	}
}

function GetMinNums()
{
	local int i;
	local int j;
	local ItemWindowHandle ItemWnd;
	local ItemInfo Info;

	minNums.Length = currentSetMax;

	for (j=1; j <= currentSetMax; j++)
	{
		ItemWnd = GetItemWindowByID(j);
		minNums[j - 1] = -1;

		for(i=0; i < ItemWnd.GetItemNum(); i++)
		{
			ItemWnd.GetItem(i, Info);

			if(Info.bDisabled == 1)
			{
				minNums[j - 1] = 0;
			}
			if (Info.ItemNum < minNums[j - 1] || minNums[j - 1] == -1)
			{
				minNums[j - 1] = Info.ItemNum;
			}
		}
	}
}

function HandleUserInfo()
{
	if(getInstanceUIData().isLevelUP() || getInstanceUIData().IsLevelDown())
	{
		CheckCanRewardBtns();
	}
}

function CheckCanRewardBtns()
{
	local int i;
	local CustomTooltip t;
	local L2Util util;
	local ButtonHandle tmpBtn;
	local UserInfo uInfo;
	local bool canLevel;
	local string levelMessage;

	util = L2Util(GetScript("L2Util"));

	if(GetPlayerInfo(uInfo))
	{
		canLevel = uInfo.nLevel >= MinLevel;
	}

	for (i=1; i <= currentSetMax; i++)
	{
		util.setCustomTooltip(t);
		util.ToopTipMinWidth(10);
		tmpBtn = GetButtonByID(i);

		if(CanReward(i) && canLevel)
		{
			tmpBtn.EnableWindow();
			util.ToopTipInsertText(GetSystemString(2984) $ " x" $ minNums[i - 1], true, true, util.ETooltipTextType.COLOR_DEFAULT);
		}
		else
		{
			tmpBtn.DisableWindow();

			if(!canLevel)
			{
				levelMessage = MakeFullSystemMsg(GetSystemMessage(13070), string(MinLevel) $ GetSystemString(537));
				util.ToopTipInsertText(levelMessage, true, true, util.ETooltipTextType.COLOR_GRAY);
			}
		}
		tmpBtn.SetTooltipCustomType(util.getCustomToolTip());
	}
}

function HandleBtnClickHelp()
{
	local string strParam;

	if(getInstanceUIData().getIsClassicServer())
	{
		if(IsAdenServer())
		{
			ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "ev_eventcollector_aden001.htm");
		}
		else
		{
			ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "ev_eventcollector001.htm");
		}
		ExecuteEvent(EV_ShowHelp, strParam);
	}
	else
	{
		ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "ev_eventcollector001.htm");
		ExecuteEvent(EV_ShowHelp, strParam);
	}
}

function API_GetLetterCollectData(out array<LetterCollectUIData> arrLetterCollectUIData)
{
	GetLetterCollectData(arrLetterCollectUIData);
	Debug("API_GetLetterCollectData" @ string(arrLetterCollectUIData.Length));
	currentSetMax = arrLetterCollectUIData.Length;
}

function API_C_EX_LETTER_COLLECTOR_TAKE_REWARD(int setNo)
{
	local array<byte> stream;
	local UIPacket._C_EX_LETTER_COLLECTOR_TAKE_REWARD packet;

	packet.nSetNo = setNo;

	if(!class'UIPacket'.static.Encode_C_EX_LETTER_COLLECTOR_TAKE_REWARD(stream, packet))
	{
		return;
	}
	Class 'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_LETTER_COLLECTOR_TAKE_REWARD, stream);
}

function ItemWindowHandle GetItemWindowByID(int windowIndex)
{
	return GetItemWindowHandle(m_WindowName $ ".LetterWnd_0" $ string(windowIndex) $ ".LetterWndItemWindow");
}

function ButtonHandle GetButtonByID(int windowIndex)
{
	return GetButtonHandle(m_WindowName $ ".LetterWnd_0" $ string(windowIndex) $ ".LetterWndGet_Btn");
}

function bool CanReward(int windowIndex)
{
	return minNums[windowIndex - 1] > 0;
}

function SetWindow()
{
	local int i;
	local Rect winRect;

	winRect = Me.GetRect();

	for(i = 1; i <= currentSetMax; i++)
	{
		GetWindowHandle(m_WindowName $ ".LetterWnd_0" $ string(i)).ShowWindow();
	}

	for(i = currentSetMax + 1; i <= SET_MAX; i++)
	{
		GetWindowHandle(m_WindowName $ ".LetterWnd_0" $ string(i)).HideWindow();
	}
	Me.SetWindowSize(winRect.nWidth, 639 - 100 * (SET_MAX - currentSetMax));
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
	m_WindowName="EventletterCollectorWnd"
}
