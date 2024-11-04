class UIToolWnd extends UICommonAPI;

//const DIALOGID_Gohome = 0;

var string m_WindowName;
var WindowHandle Me;
var ButtonHandle transBtn;
var ButtonHandle debugBtn;
var ButtonHandle uiBtn;
var ButtonHandle reloaduiBtn;
var ButtonHandle evemsgBtn;
var ButtonHandle uioffBtn;
var ButtonHandle showWBtn;
var ButtonHandle skillBtn;
var ButtonHandle killBtn;
var ButtonHandle weightBtn;
var ButtonHandle diaBtn;

var EditBoxHandle HEdit0;
var EditBoxHandle HEdit;

var EditBoxHandle NEdit;

var ListCtrlHandle WindowListCtrl;

var array<string> arrWinList;

var UIEasyLoginWnd easyLoginScript;

//var DialogBox	dScript;

//var INT64 tempN;
//var bool tempB;
//var bool tempResultB;
//var String tempOper;
//var EditBoxHandle m_ResultEditBox;

var WindowHandle m_dialogWnd;

function OnLoad()
{
	SetClosingOnESC();

	OnRegisterEvent();
	Me = GetWindowHandle("UIToolWnd");
	transBtn = GetButtonHandle("UIToolWnd.Tab0.transBtn");
	debugBtn = GetButtonHandle("UIToolWnd.Tab0.debugBtn");
	uiBtn = GetButtonHandle("UIToolWnd.Tab0.uiBtn");
	reloaduiBtn = GetButtonHandle("UIToolWnd.Tab0.reloaduiBtn");
	evemsgBtn = GetButtonHandle("UIToolWnd.Tab0.evemsgBtn");
	uioffBtn = GetButtonHandle("UIToolWnd.Tab0.uioffBtn");
	showWBtn = GetButtonHandle("UIToolWnd.Tab0.showWBtn");
	skillBtn = GetButtonHandle("UIToolWnd.Tab0.skillBtn");
	killBtn = GetButtonHandle("UIToolWnd.Tab0.killBtn");
	weightBtn = GetButtonHandle("UIToolWnd.Tab0.weightBtn");
	diaBtn = GetButtonHandle("UIToolWnd.Tab0.diaBtn");
	HEdit0 = GetEditBoxHandle("UIToolWnd.Tab1.HEdit0");
	HEdit = GetEditBoxHandle("UIToolWnd.Tab1.HEdit");
	NEdit = GetEditBoxHandle("UIToolWnd.Tab2.NEdit");
	WindowListCtrl = GetListCtrlHandle("UIToolWnd.Tab2.WindowListCtrl");
	easyLoginScript = UIEasyLoginWnd(GetScript("UIEasyLoginWnd"));
	setWindowTitleByString("UITool");
	setArr();
	SortButtonsTab0();
}

function OnRegisterEvent()
{
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case EV_Test_7:
			dialogShowTest(a_Param);
			break;
	}
}

function dialogShowTest(string param)
{
	local int nSystemString, nSystemMessage, nHtml, nWidth, nHeight;

	local string dialogStr, customIconTexture;

	ParseInt(param, "html", nHtml);
	ParseInt(param, "width", nWidth);
	ParseInt(param, "height", nHeight);

	ParseInt(param, "systemString", nSystemString);
	ParseInt(param, "systemMessage", nSystemMessage);

	ParseString(param, "string", dialogStr);
	ParseString(param, "customIconTexture", customIconTexture);

	//htmlStr = "<br1><font name='hs9' color='FFDF4C'>?ï–ñ–ê–û–ó–ü¬ª–∑¬µ–?</font> <font name=\"hs9\" color='00DF4C'>?ï¬©¬∑–†—î—Å–Ö—î–ñ¬?</font>?ê–? ?ò—ã–ê¬? ?Ññ–Æ?ï–¢“ë–?. ¬∞?é¬∞—à–ó–? ?ë–Ω–ë–?¬∑?í¬∞—? ¬∞?à¬∞–?¬∑?í–ê—ë¬∑–? ¬±–ß¬µ–π?ê–? ?ê—ã—ó–é¬∞–? ¬∞?à–ñ—á—ë¬? ?ë–¶—ï—ä¬∞–? ?ñ–á–ò—?, ¬±–ß¬µ–π?ê–? ¬∞?é¬∞—à–ó–? ?ó¬?¬ª–∑ ?ò–£¬µ¬µ“ë–? ?ê—ã¬µ–π–ê–? ?ë—û¬±–©–ó–ü¬±–? ?ê—å—ó–? ¬±–ß¬µ–π?ê¬? ?ó¬µ—ó—à–ó–? ?ï–ò–Ö–î—ó–? ¬µ–π¬∞–§ ?ó–??ë–?.";

	DialogHide();
	DialogSetID(34567891);

	if(dialogStr == "")
	{
		dialogStr = GetSystemMessage(nSystemMessage);

		if(dialogStr == "")
		{
			dialogStr = GetSystemString(nSystemString);
		}
	}
	if(nWidth == 0)
	{
		nWidth = 319;
	}
	if(nHeight == 0)
	{
		nHeight = 143;
	}

	DialogShow(DialogModalType_Modalless, DialogType_Warning, dialogStr, string(self), nWidth, nHeight, numToBool(nHtml), customIconTexture);
}

function OnHide()
{
	SetINIString("UIToolWnd", "nEdit", NEdit.GetString(), "UIDEV.ini");
}

function OnShow()
{
	local string stringValue;

	stringValue = "";

	// Event Param
	GetINIString("UIToolWnd", "nEdit", stringValue, "UIDEV.ini");
	NEdit.SetString(stringValue);

	if(easyLoginScript.getUseEasyLogin())
	{
		GetButtonHandle("UIToolWnd.Tab0.EasyLogin").SetNameText("EZLogin On");
	}
	else
	{
		GetButtonHandle("UIToolWnd.Tab0.EasyLogin").SetNameText("EZLogin Off");
	}
}

function OnClickButton(string a_ButtonID)
{
	local UIDebugWnd util;
	local bool bFlag;

	util = UIDebugWnd(GetScript("UIDebugWnd"));
	Debug("a_ButtonID" @ a_ButtonID);
	switch(a_ButtonID)
	{
		case "initBtn":
			initButtonClick();
			break;
		case "transBtn":
			if(transBtn.GetButtonName() == "HideOff")
			{
				ExecuteCommand("//hide off");
				transBtn.SetNameText("HideOn");
			}
			else
			{
				ExecuteCommand("//hide on");
				transBtn.SetNameText("HideOff");
			}
			break;
		case "debugBtn":
			ExecuteCommand("///uidebug");
			break;
		case "uiBtn":
			ExecuteCommand("///ui");
			break;
		case "reloaduiBtn":
			ExecuteCommand("///reloadui");
			break;
		case "evemsgBtn":
			if(evemsgBtn.GetButtonName() == "EvMsgON")
			{
				evemsgBtn.SetNameText("EvMsgOFF");
			}
			else
			{
				evemsgBtn.SetNameText("EvMsgON");
			}
			ExecuteCommand("///eventmsg");
			break;
			///gfx
			///delgfxall
			///delgfx "?ñ–î–ê–ü–ê–ú—ë¬?"
		case "showWBtn":
			ExecuteCommand("///show windowname");
			break;
		case "skillBtn":
			ExecuteCommand("//setskill 7029 3");
			break;
		case "killBtn":
			ExecuteCommand("//Ï£ΩÏñ¥");
			break;
		case "weightBtn":
			if(weightBtn.GetButtonName() == "WeightOFF")
			{
				ExecuteCommand("//Î¨¥Í≤å Ïº?");
				weightBtn.SetNameText("WeightON");
			}
			else
			{
				ExecuteCommand("//Î¨¥Í≤å ?Åî");
				weightBtn.SetNameText("WeightOFF");
			}
			break;
		case "gfxBtn":
			ExecuteCommand("///gfx");
			break;
		case "delgfxBtn":
			ExecuteCommand("///delgfxall");
			break;
		case "loadBtn":
			loadButtonClick();
			break;
		case "htmlBtn":
			htmlButtonClick();
			break;
		case "winBtn":
			winButtonClick();
			break;
		case "shoWBBtn":
			ExecuteCommand("///show windowbox");
			break;
		case "allBtn":
			ExecuteCommand("//?ò¨?ä§?Ç¨");
			break;
		case "evnBtn":
			MakeEventBuff2();
			break;
		case "PowerTool":
			LoadWindowClick("UIPowerToolWnd");
			break;
		case "UITrace":
			util.ShowWindow();
			break;
		case "ServerHtml":
			LoadWindowClick("UIServerHtmlToolWnd");
			break;
		case "HtmlTool":
			LoadWindowClick("UIHtmlToolWnd");
			break;
		case "QuestTool":
			LoadWindowClick("UIQuestToolWnd");
			break;
		case "ItemTool":
			LoadWindowClick("UIItemToolWnd");
			break;
		case "GFXTester":
			CallGFxFunction("containerHUD", "showDebugTool", "");
			break;
		case "ShowUI":
			LoadWindowClick("UIOpenToolWnd");
			break;
		case "UIButton":
			toggleWindow("UIButtonTestWnd", true);
			break;
		// ?ó–ì¬∑–é–Ö–ì¬∑–? ?ë—ë¬µ–? ¬µ???Ññ?Ü¬±–?
		// case "GfxDebug":
		// 	ExecuteEvent(EV_Test_8, "");
		// 	break;
		case "EasyLogin":
			bFlag = easyLoginScript.getUseEasyLogin();

			if(bFlag)
			{
				GetButtonHandle("UIToolWnd.Tab0.EasyLogin").SetNameText("EasyLogin Off");
			}
			else
			{
				GetButtonHandle("UIToolWnd.Tab0.EasyLogin").SetNameText("EasyLogin On");
			}
			easyLoginScript.setUseEasyLogin(!bFlag);
			break;
		case "GammaOff":
			SetOptionFloat("Video", "Gamma", 0);
			break;
		case "JobTree":
			ShowWindow("JobTreeWnd");
			break;
		case "mapSearchButton":
			toggleWindow("UISearchMapWnd", true);
			break;
		case "Tween":
			toggleWindow("UITweenTestWnd", true);
			break;
		case "Viewport":
			toggleWindow("EffectTester", true);
			break;
		case "htmlEditorButton":
			Debug("html");
			toggleWindow("UIHtmlTestEditor", true);
			break;
		case "UISoundButton":
			toggleWindow("UISoundWnd", true);
			break;
		case "UIEffectButton":
			toggleWindow("UIEffectViewportTester", true);
			break;
	}
}

function LoadWindowClick(string WindowName)
{
	local WindowHandle NewWindow;

	NewWindow = GetWindowHandle(WindowName);
	NewWindow.ShowWindow();
	NewWindow.SetFocus();
}

function initButtonClick()
{
	ExecuteCommand("//?à¨Î™? ?Åî");
	ExecuteCommand("//Î¨¥Ï†Å on");
	ExecuteCommand("//?Üç?èÑ 5");
	ExecuteCommand("///uidebug");
	ExecuteCommand("///autocom");
}

function loadButtonClick()
{
	local string Str;
	local array<string> arrStr;

	//arrStr[0] = "";
	//arrStr[1] = "";

	Str = HEdit0.GetString();
	Split(Str, ".", arrStr);

	if(arrStr[1] != "")
	{
		//debug("111@@@"$str);
		ExecuteCommand("//loadhtml " $ Str);
	}
	else
	{
		//debug("222@@@"$str);
		ExecuteCommand("//loadhtml " $ Str $ ".htm");
	}
}

function htmlButtonClick()
{
	local ItemDescWnd Script;
	local string Str;
	local array<string> arrStr;

	//arrStr[0] = "";
	//arrStr[1] = "";

	Str = HEdit.GetString();
	Split(Str, ".", arrStr);

	// ShowWindow("ItemDescWnd");

	Script = ItemDescWnd(GetScript("ItemDescWnd"));
	//Script.ShowWindow("ItemDescWnd");

	if(arrStr[1] != "")
	{
		Script.ShowHelp(GetLocalizedL2TextPathNameUC() $ Str);
	}
	else
	{
		Script.ShowHelp(GetLocalizedL2TextPathNameUC() $ Str $ ".htm");
	}
}

function winButtonClick()
{
	local WindowHandle NewWindow;
	local string Str;

	Str = NEdit.GetString();

	if(Str != "")
	{
		NewWindow = GetWindowHandle(NEdit.GetString());
		NewWindow.ShowWindow();
		NewWindow.SetFocus();
	}
}

//¬∑?Ññ?î–™¬µ–µ—ë¬? ?ï¬¨—ë–á–ó–ü—ë–?....
function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;

	switch(ListCtrlID)
	{
		case "WindowListCtrl":
			WindowListCtrl.GetSelectedRec(Record);
			class'UIAPI_EDITBOX'.static.SetString("UIToolWnd.NEdit", Record.LVDataList[0].szData);
			break;
	}
}

//¬∑?Ññ?î–™¬µ–µ—ë¬? ?ë—Ö—î–Ω–ï¬¨—ë–á–ó–ü—ë–?....
function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;
	local WindowHandle NewWindow;

	switch(ListCtrlID)
	{
		case "WindowListCtrl":
			WindowListCtrl.GetSelectedRec(Record);
			NewWindow = GetWindowHandle(Record.LVDataList[0].szData);
			NewWindow.ShowWindow();
			NewWindow.SetFocus();
			break;
	}
}

function MakeWindowList()
{
	local LVDataRecord Record;
	local int i;

	NEdit.ClearAdditionalSearchList(ESearchListType.SLT_ADDITIONAL_LIST);

	for(i = 0; i < arrWinList.Length; i++)
	{
		Record.LVDataList.Length = 1;
		Record.LVDataList[0].szData = arrWinList[i];
		class'UIAPI_LISTCTRL'.static.InsertRecord("UIToolWnd.WindowListCtrl", Record);

		NEdit.AddNameToAdditionalSearchList(Record.LVDataList[0].szData, ESearchListType.SLT_ADDITIONAL_LIST);
	}
}

function MakeEventBuff2()
{
	local string strParam;
	local int i;

	/*
	ParseInt(param, "ServerID", info.ServerID);
	ParseInt(param, "Max", Max);
	
	Debug("<<<<>>>>>>" $ param);


	//debug("//////////////////////////test_abnormal////////////////////////" $ Max);
	for(i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "SkillLevel_" $ i, info.Level);
		ParseInt(param, "RemainTime_" $ i, info.RemainTime);
		ParseString(param, "Name_" $ i, info.Name);
		ParseString(param, "IconName_" $ i, info.IconName);
		ParseString(param, "Description_" $ i, info.Description);
	*/

	ParamAdd(strParam, "ServerID", string(1229005689));
	ParamAdd(strParam, "Max", string(70));

	for(i = 0; i < 36; i++)
	{
		ParamAdd(strParam, "ClassID_" $ i, string(11259));
		ParamAdd(strParam, "SkillLevel_" $ i, string(4));
		ParamAdd(strParam, "RemainTime_" $ i, string(13));
		ParamAdd(strParam, "Name_" $ i, "ÔøΩÔøΩÔøΩÔøΩÔø? ÔøΩÔøΩÔøΩÔøΩ");
		ParamAdd(strParam, "IconName_" $ i, "icon.skill1263");
		ParamAdd(strParam, "Description_" $ i, "ÔøΩ◊ΩÔøΩ∆ÆÔøΩÔøΩÔøΩÔøΩÔøΩÔøΩ ÔøΩÔøΩÔøΩÔøΩ ÔøΩÔøΩÔø? ÔøΩÔøΩÔøΩÔøΩÔøΩÔøΩÔøΩÔøΩÔø?");
	}
	for(i = 36; i < 70; i++)
	{
		ParamAdd(strParam, "ClassID_" $ i, string(1040));
		ParamAdd(strParam, "SkillLevel_" $ i, string(1));
		ParamAdd(strParam, "RemainTime_" $ i, string(942));
		ParamAdd(strParam, "Name_" $ i, "ÔøΩ«µÔøΩ");
		ParamAdd(strParam, "IconName_" $ i, "icon.skill1040");
		ParamAdd(strParam, "Description_" $ i, "ÔøΩ◊ΩÔøΩ∆ÆÔøΩÔøΩÔøΩÔøΩÔøΩÔøΩ ÔøΩÔøΩÔøΩÔøΩ ÔøΩÔøΩÔø? ÔøΩÔøΩÔøΩÔøΩÔøΩÔøΩÔøΩÔøΩÔø?");
	}
	/*
	for(i = 10 ; i < 20 ; i++)
	{
		ParamAdd(strParam, "ClassID_"$i, string(11260));
		ParamAdd(strParam, "SkillLevel_"$i, string(4));
		ParamAdd(strParam, "RemainTime_"$i, string(13));
		ParamAdd(strParam, "Name_"$i, "?ò–∏—ï–∞–ê–? ?ñ¬´–ê–?");
		ParamAdd(strParam, "IconName_"$i, "icon.skill1263");
		ParamAdd(strParam, "Description_"$i, "?ï–ß–Ö—î–ñ¬??ó–ª–ê—ë¬∑–? ?ë¬∂¬±—? ?í–ø“ë–? ¬µ???Ññ?Ü–ó–ë¬§¬ª¬§¬?");
	}
*/
	ExecuteEvent(EV_AbnormalStatusNormalItem, strParam);
}

function SortButtonsTab0()
{
	local array<WindowHandle> ChildList;
	local int i, X, Y;

	GetWindowHandle("UIToolWnd.Tab0").GetChildWindowList(ChildList);

	for(i = 0; i < ChildList.Length; i++)
	{
		ChildList[i].SetWindowSize(93, 30);
		X = int((i % 3))* 94 + 1;
		Y = i / 3 * 32 + 9;
		ChildList[i].SetAnchor("UIToolWnd.Tab0", "TopLeft", "TopLeft", X, Y);
	}
}

function MakeEventBuff()
{
	local string strParam;
	local int i;
	local TargetStatusWnd script;

	script = TargetStatusWnd(GetScript("TargetStatusWnd"));
	script.HandleSkillCancel();

	ParamAdd(strParam, "TargetID", string(100));
	ParamAdd(strParam, "Max", string(40));

	for(i = 0; i < 10; i++)
	{
		ParamAdd(strParam, "Level_" $ i, string(1));
		ParamAdd(strParam, "Sec_" $ i, string(100));
		ParamAdd(strParam, "Count_" $ i, string(1));
		ParamAdd(strParam, "OwnerShip_" $ i, string(1));
	}

	ParamAdd(strParam, "ClassID_0", string(92));
	ParamAdd(strParam, "ClassID_1", string(101));
	ParamAdd(strParam, "ClassID_2", string(102));
	ParamAdd(strParam, "ClassID_3", string(105));
	ParamAdd(strParam, "ClassID_4", string(115));
	ParamAdd(strParam, "ClassID_5", string(129));
	ParamAdd(strParam, "ClassID_6", string(1069));
	ParamAdd(strParam, "ClassID_7", string(1083));
	ParamAdd(strParam, "ClassID_8", string(1160));
	ParamAdd(strParam, "ClassID_9", string(1164));

	for(i = 10; i < 20; i++)
	{
		ParamAdd(strParam, "Level_" $ i, string(1));
		ParamAdd(strParam, "Sec_" $ i, string(100));
		ParamAdd(strParam, "Count_" $ i, string(1));
		ParamAdd(strParam, "OwnerShip_" $ i, string(0));
	}

	ParamAdd(strParam, "ClassID_10", string(92));
	ParamAdd(strParam, "ClassID_11", string(101));
	ParamAdd(strParam, "ClassID_12", string(102));
	ParamAdd(strParam, "ClassID_13", string(105));
	ParamAdd(strParam, "ClassID_14", string(115));
	ParamAdd(strParam, "ClassID_15", string(129));
	ParamAdd(strParam, "ClassID_16", string(1069));
	ParamAdd(strParam, "ClassID_17", string(1083));
	ParamAdd(strParam, "ClassID_18", string(1160));
	ParamAdd(strParam, "ClassID_19", string(1164));

	for(i = 20; i < 30; i++)
	{
		ParamAdd(strParam, "Level_" $ i, string(1));
		ParamAdd(strParam, "Sec_" $ i, string(10));
		ParamAdd(strParam, "Count_" $ i, string(1));
		ParamAdd(strParam, "OwnerShip_" $ i, string(1));
	}

	ParamAdd(strParam, "ClassID_20", string(77));
	ParamAdd(strParam, "ClassID_21", string(78));
	ParamAdd(strParam, "ClassID_22", string(82));
	ParamAdd(strParam, "ClassID_23", string(91));
	ParamAdd(strParam, "ClassID_24", string(99));
	ParamAdd(strParam, "ClassID_25", string(112));
	ParamAdd(strParam, "ClassID_26", string(113));
	ParamAdd(strParam, "ClassID_27", string(118));
	ParamAdd(strParam, "ClassID_28", string(121));
	ParamAdd(strParam, "ClassID_29", string(137));

	for(i = 30; i < 40; i++)
	{
		ParamAdd(strParam, "Level_" $ i, string(1));
		ParamAdd(strParam, "Sec_" $ i, string(10));
		ParamAdd(strParam, "Count_" $ i, string(1));
		ParamAdd(strParam, "OwnerShip_" $ i, string(0));
	}

	ParamAdd(strParam, "ClassID_30", string(77));
	ParamAdd(strParam, "ClassID_31", string(78));
	ParamAdd(strParam, "ClassID_32", string(82));
	ParamAdd(strParam, "ClassID_33", string(91));
	ParamAdd(strParam, "ClassID_34", string(99));
	ParamAdd(strParam, "ClassID_35", string(112));
	ParamAdd(strParam, "ClassID_36", string(113));
	ParamAdd(strParam, "ClassID_37", string(118));
	ParamAdd(strParam, "ClassID_38", string(121));
	ParamAdd(strParam, "ClassID_39", string(137));

	ExecuteEvent(EV_TargetSpelledList, strParam);
}

function setArr()
{
	local int Index;

	// uclist.int	(Interface\CLASSES\ ?ñ—ä“ë—Ö—ó–é—ò¬? ¬ª?ú—ï–ñ—ò¬? ?Ññ–©?Ü–©¬±–≤¬∑–? ?ë¬§—ë¬?);
	Index = 0;

	arrWinList[Index++] = "AbnormalStatusWnd";
	arrWinList[Index++] = "ActionWnd";
	arrWinList[Index++] = "AdenaDistributionResultWnd";
	arrWinList[Index++] = "AdenaDistributionWnd";
	arrWinList[Index++] = "AgeWnd";
	arrWinList[Index++] = "AgitDecoDrawerWnd";
	arrWinList[Index++] = "AgitDecoWnd";
	arrWinList[Index++] = "AITimerWnd";
	arrWinList[Index++] = "AlchemyItemConversionWnd";
	arrWinList[Index++] = "AlchemyMixCubeWnd";
	arrWinList[Index++] = "AlchemyOpener";
	arrWinList[Index++] = "AlchemySkillCollectionWnd";
	arrWinList[Index++] = "AlchemySkillLearnWnd";
	arrWinList[Index++] = "AlchemySkillWnd";
	arrWinList[Index++] = "AlterSkill";
	arrWinList[Index++] = "AlterSkillJump";
	arrWinList[Index++] = "AnniveEvent";
	arrWinList[Index++] = "AnniveEventLauncher";
	arrWinList[Index++] = "AnnounceMessage";
	arrWinList[Index++] = "ArchiveHotLinkWnd";
	arrWinList[Index++] = "ArchiveViewWnd";
	arrWinList[Index++] = "ArenaCharacterInfoWnd";
	arrWinList[Index++] = "ArenaDualManager";
	arrWinList[Index++] = "ArenaMapGuidance";
	arrWinList[Index++] = "ArenaMatchGroupWnd";
	arrWinList[Index++] = "ArenaMatchWnd";
	arrWinList[Index++] = "ArenaPickWnd";
	arrWinList[Index++] = "ArenaRankingWnd";
	arrWinList[Index++] = "ArenaRevivalWnd";
	arrWinList[Index++] = "ArenaScoreBoardHUD";
	arrWinList[Index++] = "ArenaScoreBoardWnd";
	arrWinList[Index++] = "ArenaSkillUpgrade";
	arrWinList[Index++] = "ArenaTutorialWnd";
	arrWinList[Index++] = "ArmorEnchantEffectTestWnd";
	arrWinList[Index++] = "ArmyTrainingCenterBottomWnd";
	arrWinList[Index++] = "ArmyTrainingCenterWnd";
	arrWinList[Index++] = "AttendCheckWnd";
	arrWinList[Index++] = "AttributeEnchantWnd";
	arrWinList[Index++] = "AttributeRemoveWnd";
	arrWinList[Index++] = "AuctionNextWnd";
	arrWinList[Index++] = "AuctionWnd";
	arrWinList[Index++] = "AutoShotItemWnd";
	arrWinList[Index++] = "AwakeViewWnd";
	arrWinList[Index++] = "BeautyShop";
	arrWinList[Index++] = "BenchMarkMenuWnd";
	arrWinList[Index++] = "BirthdayAlarmBtn";
	arrWinList[Index++] = "BirthdayAlarmWnd";
	arrWinList[Index++] = "BlockCounter";
	arrWinList[Index++] = "BlockCurTriggerWnd";
	arrWinList[Index++] = "BlockCurWnd";
	arrWinList[Index++] = "BlockEnterWnd";
	arrWinList[Index++] = "BoardWnd";
	arrWinList[Index++] = "BOTsystemWnd";
	arrWinList[Index++] = "BR_CampaignAlarmWnd";
	arrWinList[Index++] = "BR_CampaignTopContributorListWnd";
	arrWinList[Index++] = "BR_CashShopAPI";
	arrWinList[Index++] = "BR_CashShopBtnWnd";
	arrWinList[Index++] = "BR_CashShopReceiverListAddWnd";
	arrWinList[Index++] = "BR_EventChristmasWnd";
	arrWinList[Index++] = "BR_EventDefaultWnd";
	arrWinList[Index++] = "BR_EventFastivalInkWnd";
	arrWinList[Index++] = "BR_EventFireWnd";
	arrWinList[Index++] = "BR_EventHalloweenTodayWnd";
	arrWinList[Index++] = "BR_EventHalloweenWnd";
	arrWinList[Index++] = "BR_EventHtmlWndA";
	arrWinList[Index++] = "BR_EventHtmlWndB";
	arrWinList[Index++] = "BR_EventHtmlWndC";
	arrWinList[Index++] = "BR_MiniGameRankWnd";
	arrWinList[Index++] = "BR_MyShopWnd";
	arrWinList[Index++] = "BR_NewBuyingWnd";
	arrWinList[Index++] = "BR_NewCashShopReceiverListWnd";
	arrWinList[Index++] = "BR_NewCashShopWnd";
	arrWinList[Index++] = "BR_NewPresentBuyingWnd";
	arrWinList[Index++] = "BR_PathWnd";
	arrWinList[Index++] = "BuilderCmdWnd";
	arrWinList[Index++] = "CalculatorWnd";
	arrWinList[Index++] = "CampaignAlarmWnd";
	arrWinList[Index++] = "CampaignTopContributorListWnd";
	arrWinList[Index++] = "CardDrawEventWnd";
	arrWinList[Index++] = "CardExchange";
	arrWinList[Index++] = "CardExchangeB";
	arrWinList[Index++] = "CardExchangeC";
	arrWinList[Index++] = "CharacterCreateMenuWnd";
	arrWinList[Index++] = "CharacterPasswordHelpHtmlWnd";
	arrWinList[Index++] = "CharacterPasswordWnd";
	arrWinList[Index++] = "ChatAlertMessage";
	arrWinList[Index++] = "ChatWnd";
	arrWinList[Index++] = "ClanDrawerWnd";
	arrWinList[Index++] = "ClanDrawerWndClassic";
	arrWinList[Index++] = "ClanGfxWnd";
	arrWinList[Index++] = "ClanPledgeBonusDrawerWnd";
	arrWinList[Index++] = "ClanRaidsWnd";
	arrWinList[Index++] = "ClanSearch";
	arrWinList[Index++] = "ClanShopEditWnd";
	arrWinList[Index++] = "ClanShopWnd";
	arrWinList[Index++] = "ClanWnd";
	arrWinList[Index++] = "ClanWndClassicNew";
	arrWinList[Index++] = "CleftCounter";
	arrWinList[Index++] = "CleftCurTriggerWnd";
	arrWinList[Index++] = "CleftCurWnd";
	arrWinList[Index++] = "CleftEnterWnd";
	arrWinList[Index++] = "ColorNickNameWnd";
	arrWinList[Index++] = "ConsoleWnd";
	arrWinList[Index++] = "ContainerHUD";
	arrWinList[Index++] = "ContainerWindow";
	arrWinList[Index++] = "ContextMenu";
	arrWinList[Index++] = "CouponEventWnd";
	arrWinList[Index++] = "CostumeWnd";
	arrWinList[Index++] = "Credit";
	arrWinList[Index++] = "CrystallizationWnd";
	arrWinList[Index++] = "DamageText";
	arrWinList[Index++] = "DeliverWnd";
	arrWinList[Index++] = "DepthOfField";
	arrWinList[Index++] = "DetailStatusWnd";
	arrWinList[Index++] = "DetailStatusWndClassic";
	arrWinList[Index++] = "DialogBox";
	arrWinList[Index++] = "DominionWarInfoWnd";
	arrWinList[Index++] = "DuelManager";
	arrWinList[Index++] = "EffectTester";
	arrWinList[Index++] = "ElementalSpiritWnd";
	arrWinList[Index++] = "EnsoulExtractSubWnd";
	arrWinList[Index++] = "EnsoulExtractWnd";
	arrWinList[Index++] = "EnsoulSubWnd";
	arrWinList[Index++] = "EnsoulWnd";
	arrWinList[Index++] = "EnvTestWnd";
	arrWinList[Index++] = "ErtheiaTestWnd";
	arrWinList[Index++] = "EventBalthus";
	arrWinList[Index++] = "EventChristmasWnd";
	arrWinList[Index++] = "EventInfoWnd";
	arrWinList[Index++] = "EventKalie";
	arrWinList[Index++] = "EventMatchGMFenceWnd";
	arrWinList[Index++] = "EventMatchGMMsgWnd";
	arrWinList[Index++] = "EventMatchGMWnd";
	arrWinList[Index++] = "EventMatchObserverWnd";
	arrWinList[Index++] = "EventMatchSpecialMsgWnd";
	arrWinList[Index++] = "ExpBar";
	arrWinList[Index++] = "FactionWnd";
	arrWinList[Index++] = "FileListWnd";
	arrWinList[Index++] = "FileRegisterWnd";
	arrWinList[Index++] = "FileWnd";
	arrWinList[Index++] = "Fishing";
	arrWinList[Index++] = "FishViewportWnd";
	arrWinList[Index++] = "FlightShipCtrlWnd";
	arrWinList[Index++] = "FlightTeleportWnd";
	arrWinList[Index++] = "FlightTransformCtrlWnd";
	arrWinList[Index++] = "GametipWnd";
	//arrWinList[index++] = "GfxDebug";
	arrWinList[Index++] = "GfxDialog";
	arrWinList[Index++] = "GfxScreenMessage";
	arrWinList[Index++] = "GfxScreenMessageBG";
	arrWinList[Index++] = "GlobalEventWnd";
	arrWinList[Index++] = "GMClanWnd";
	arrWinList[Index++] = "GMDetailStatusWnd";
	arrWinList[Index++] = "GMDetailStatusWndClassic";
	arrWinList[Index++] = "GMFindTreeWnd";
	arrWinList[Index++] = "GMInventoryWnd";
	arrWinList[Index++] = "GMMagicSkillWnd";
	arrWinList[Index++] = "GMQuestWnd";
	arrWinList[Index++] = "GMSnoopWnd";
	arrWinList[Index++] = "GMWarehouseWnd";
	arrWinList[Index++] = "GMWnd";
	arrWinList[Index++] = "HairshopWnd";
	arrWinList[Index++] = "HDRRenderTestWnd";
	arrWinList[Index++] = "HelpHtmlWnd";
	arrWinList[Index++] = "HelpWnd";
	arrWinList[Index++] = "HennaInfoPremiumWnd";
	arrWinList[Index++] = "HennaInfoWnd";
	arrWinList[Index++] = "HennaListWnd";
	arrWinList[Index++] = "HeroTowerWnd";
	arrWinList[Index++] = "HeroTowerWndWorld";
	arrWinList[Index++] = "InfoWnd";
	arrWinList[Index++] = "IngameNoticeWnd";
	arrWinList[Index++] = "IngameShopBtnWnd";
	arrWinList[Index++] = "IngameShopWnd";
	arrWinList[Index++] = "IngameWebWnd";
	arrWinList[Index++] = "InstancedZoneHistoryWnd";
	arrWinList[Index++] = "InventoryViewer";
	arrWinList[Index++] = "InventoryWnd";
	arrWinList[Index++] = "InviteClanPopWnd";
	arrWinList[Index++] = "InviteClanPopWndClassic";
	arrWinList[Index++] = "ItemAttributeChangeWnd";
	arrWinList[Index++] = "ItemDescWnd";
	arrWinList[Index++] = "ItemEnchantWnd";
	arrWinList[Index++] = "ItemJewelEnchantSubWnd";
	arrWinList[Index++] = "ItemJewelEnchantWnd";
	arrWinList[Index++] = "ItemLockSubWnd";
	arrWinList[Index++] = "ItemLockWnd";
	arrWinList[Index++] = "ItemLookChangeWnd";
	arrWinList[Index++] = "ItemUpgrade";
	arrWinList[Index++] = "JobTreeWnd";
	arrWinList[Index++] = "KillpointCounterWnd";
	arrWinList[Index++] = "KillpointRankTrigger";
	arrWinList[Index++] = "KillPointRankWnd";
	arrWinList[Index++] = "L2UIGFxScript";
	arrWinList[Index++] = "L2UIGFxScriptNoneContainer";
	arrWinList[Index++] = "L2UIToolTip";
	arrWinList[Index++] = "L2Util";
	arrWinList[Index++] = "LoadingWnd";
	arrWinList[Index++] = "LoadingWnd_cn";
	arrWinList[Index++] = "LoadingWnd_de";
	arrWinList[Index++] = "LoadingWnd_e";
	arrWinList[Index++] = "LoadingWnd_eu";
	arrWinList[Index++] = "LoadingWnd_fr";
	arrWinList[Index++] = "LoadingWnd_id";
	arrWinList[Index++] = "LoadingWnd_j";
	arrWinList[Index++] = "LoadingWnd_k";
	arrWinList[Index++] = "LoadingWnd_ph";
	arrWinList[Index++] = "LoadingWnd_pl";
	arrWinList[Index++] = "LoadingWnd_ru";
	arrWinList[Index++] = "LoadingWnd_th";
	arrWinList[Index++] = "LoadingWnd_tr";
	arrWinList[Index++] = "LoadingWnd_tw";
	arrWinList[Index++] = "LobbyMenuWnd";
	arrWinList[Index++] = "LogIn";
	arrWinList[Index++] = "LogInEula";
	arrWinList[Index++] = "LogInLoading";
	arrWinList[Index++] = "LogInMenu";
	arrWinList[Index++] = "LoginServerSelect";
	arrWinList[Index++] = "LoginSystemMessageWnd";
	arrWinList[Index++] = "LuckyGame";
	arrWinList[Index++] = "MacroEditWnd";
	arrWinList[Index++] = "MacroListWnd";
	arrWinList[Index++] = "MacroPresetWnd";
	arrWinList[Index++] = "MagicSkillDrawerWnd";
	arrWinList[Index++] = "MagicskillGuideWnd";
	arrWinList[Index++] = "MagicSkillWnd";
	arrWinList[Index++] = "MailBtnWnd";
	arrWinList[Index++] = "MainMenu";
	arrWinList[Index++] = "ManorCropInfoChangeWnd";
	arrWinList[Index++] = "ManorCropInfoSettingWnd";
	arrWinList[Index++] = "ManorCropSellChangeWnd";
	arrWinList[Index++] = "ManorCropSellWnd";
	arrWinList[Index++] = "ManorInfoWnd";
	arrWinList[Index++] = "ManorSeedInfoChangeWnd";
	arrWinList[Index++] = "ManorSeedInfoSettingWnd";
	arrWinList[Index++] = "ManorShopWnd";
	arrWinList[Index++] = "Menu";
	arrWinList[Index++] = "MiniGame1Wnd";
	arrWinList[Index++] = "MiniMapGfxWnd";
	arrWinList[Index++] = "MinimapMissionWnd";
	arrWinList[Index++] = "MinimapWnd";
	arrWinList[Index++] = "MonsterArenaResultWnd";
	arrWinList[Index++] = "MonsterBookDetailedInfo";
	arrWinList[Index++] = "MonsterBookWnd";
	arrWinList[Index++] = "MovieCaptureWnd";
	arrWinList[Index++] = "MovieCaptureWnd_Expand";
	arrWinList[Index++] = "MSProfilerWnd";
	arrWinList[Index++] = "MSViewerWnd";
	arrWinList[Index++] = "MultiSellWnd";
	arrWinList[Index++] = "MultiTimer";
	arrWinList[Index++] = "MysteriousMansionControlWnd";
	arrWinList[Index++] = "MysteriousMansionMenuWnd";
	arrWinList[Index++] = "MysteriousMansionResultWnd";
	arrWinList[Index++] = "MysteriousMansionRoomListWnd";
	arrWinList[Index++] = "MysteriousMansionStatusWnd";
	arrWinList[Index++] = "NewPetitionFeedBackResultWnd";
	arrWinList[Index++] = "NewPetitionFeedBackWnd";
	arrWinList[Index++] = "NewPetitionFeedBackWnd_2nd";
	arrWinList[Index++] = "NewPetitionWnd";
	arrWinList[Index++] = "NewUserPetitionDrawerWnd";
	arrWinList[Index++] = "NewUserPetitionWnd";
	arrWinList[Index++] = "NoticeWnd";
	arrWinList[Index++] = "NPCDialogWnd";
	arrWinList[Index++] = "NPCViewerWnd";
	arrWinList[Index++] = "ObserverWnd";
	arrWinList[Index++] = "OlympiadArenaListWnd";
	arrWinList[Index++] = "OlympiadBuff1Wnd";
	arrWinList[Index++] = "OlympiadBuff2Wnd";
	arrWinList[Index++] = "OlympiadBuffWnd";
	arrWinList[Index++] = "OlympiadControlWnd";
	arrWinList[Index++] = "OlympiadGuideWnd";
	arrWinList[Index++] = "OlympiadPlayer1Wnd";
	arrWinList[Index++] = "OlympiadPlayer2Wnd";
	arrWinList[Index++] = "OlympiadPlayerWnd";
	arrWinList[Index++] = "OlympiadResultWnd";
	arrWinList[Index++] = "OlympiadScoreBoardHUD";
	arrWinList[Index++] = "OlympiadTargetWnd";
	arrWinList[Index++] = "OlympiadWnd";
	arrWinList[Index++] = "OptionWnd";
	arrWinList[Index++] = "PacketTest";
	arrWinList[Index++] = "PartyMatchMakeRoomWnd";
	arrWinList[Index++] = "PartyMatchOutWaitListWnd";
	arrWinList[Index++] = "PartyMatchRoomWnd";
	arrWinList[Index++] = "PartyMatchWaitListWnd";
	arrWinList[Index++] = "PartyMatchWnd";
	arrWinList[Index++] = "PartyMatchWndCommon";
	arrWinList[Index++] = "PartyWnd";
	arrWinList[Index++] = "PartyWndArena";
	arrWinList[Index++] = "PartyWndOption";
	arrWinList[Index++] = "PCViewerWnd";
	arrWinList[Index++] = "PersonalConnectionsDrawerWnd";
	arrWinList[Index++] = "PersonalConnectionsWnd";
	arrWinList[Index++] = "PetitionFeedBackWnd";
	arrWinList[Index++] = "PetitionWnd";
	arrWinList[Index++] = "PetStatusWnd";
	arrWinList[Index++] = "PetWnd";
	arrWinList[Index++] = "PlayerAgeWnd";
	arrWinList[Index++] = "PlayerSkillGauge";
	arrWinList[Index++] = "PledgeCreateWnd";
	arrWinList[Index++] = "PostBoxWnd";
	arrWinList[Index++] = "PostDetailWnd_General";
	arrWinList[Index++] = "PostDetailWnd_SafetyTrade";
	arrWinList[Index++] = "PostEffectTestWnd";
	arrWinList[Index++] = "PostReceiverListAddWnd";
	arrWinList[Index++] = "PostReceiverListWnd";
	arrWinList[Index++] = "PostWriteWnd";
	arrWinList[Index++] = "PremiumItemAlarmWnd";
	arrWinList[Index++] = "PremiumItemGetWnd";
	arrWinList[Index++] = "PrivateMarketWnd";
	arrWinList[Index++] = "PrivateShopWnd";
	arrWinList[Index++] = "PrivateShopWndHistory";
	arrWinList[Index++] = "PrivateShopWndReport";
	arrWinList[Index++] = "ProductInventoryDrawerWnd";
	arrWinList[Index++] = "ProductInventoryHelpHtmlWnd";
	arrWinList[Index++] = "ProductInventoryWnd";
	arrWinList[Index++] = "ProgressBox";
	arrWinList[Index++] = "PVBuilderCmdWnd";
	arrWinList[Index++] = "PVPCounter";
	arrWinList[Index++] = "PVPCounterTrigger";
	arrWinList[Index++] = "PVPDetailedWnd";
	arrWinList[Index++] = "PVShortcutWnd";
	arrWinList[Index++] = "QuestAlarmWnd";
	arrWinList[Index++] = "QuestBtnWnd";
	arrWinList[Index++] = "QuestHTMLWnd";
	arrWinList[Index++] = "QuestListWnd";
	arrWinList[Index++] = "QuestTreeDrawerWnd";
	arrWinList[Index++] = "QuestTreeWnd";
	arrWinList[Index++] = "QuestTutorialWnd";
	arrWinList[Index++] = "QuitReportDrawerWnd";
	arrWinList[Index++] = "QuitReportWnd";
	arrWinList[Index++] = "RadarMapWnd";
	arrWinList[Index++] = "RecipeBookWnd";
	arrWinList[Index++] = "RecipeBuyListWnd";
	arrWinList[Index++] = "RecipeBuyManufactureWnd";
	arrWinList[Index++] = "RecipeManufactureWnd";
	arrWinList[Index++] = "RecipeShopWnd";
	arrWinList[Index++] = "RecipeTreeWnd";
	arrWinList[Index++] = "RecommendBonusHelpHtmlWnd";
	arrWinList[Index++] = "RecommendBonusWnd";
	arrWinList[Index++] = "RefineryWnd";
	arrWinList[Index++] = "ReplayListWnd";
	arrWinList[Index++] = "ReplayLogoWnd";
	arrWinList[Index++] = "ReplayLogoWnd_cn";
	arrWinList[Index++] = "ReplayLogoWnd_de";
	arrWinList[Index++] = "ReplayLogoWnd_e";
	arrWinList[Index++] = "ReplayLogoWnd_eu";
	arrWinList[Index++] = "ReplayLogoWnd_fr";
	arrWinList[Index++] = "ReplayLogoWnd_id";
	arrWinList[Index++] = "ReplayLogoWnd_j";
	arrWinList[Index++] = "ReplayLogoWnd_k";
	arrWinList[Index++] = "ReplayLogoWnd_ph";
	arrWinList[Index++] = "ReplayLogoWnd_pl";
	arrWinList[Index++] = "ReplayLogoWnd_ru";
	arrWinList[Index++] = "ReplayLogoWnd_th";
	arrWinList[Index++] = "ReplayLogoWnd_tr";
	arrWinList[Index++] = "ReplayLogoWnd_tw";
	arrWinList[Index++] = "RestartMenuWnd";
	arrWinList[Index++] = "Sample";
	arrWinList[Index++] = "SceneClipView";
	arrWinList[Index++] = "SceneEditorSlideWnd";
	arrWinList[Index++] = "SceneEditorWnd";
	arrWinList[Index++] = "SeedShopWnd";
	arrWinList[Index++] = "SelectDeliverWnd";
	arrWinList[Index++] = "SellingAgencyWnd";
	arrWinList[Index++] = "ShaderBuild";
	arrWinList[Index++] = "SheathingWnd";
	arrWinList[Index++] = "ShopWnd";
	arrWinList[Index++] = "Shortcut";
	arrWinList[Index++] = "ShortcutWnd";
	arrWinList[Index++] = "ShortcutWndArena";
	arrWinList[Index++] = "SiegeInfoWnd";
	arrWinList[Index++] = "SiegeReportWnd";
	arrWinList[Index++] = "SkillLearnWnd";
	arrWinList[Index++] = "SkillTrainClanTreeWnd";
	arrWinList[Index++] = "SkillTrainInfoWnd";
	arrWinList[Index++] = "SkillTrainListWnd";
	arrWinList[Index++] = "SSAOWnd";
	arrWinList[Index++] = "SSQMainBoard";
	arrWinList[Index++] = "StatusWnd";
	arrWinList[Index++] = "SummonedStatusWnd";
	arrWinList[Index++] = "SummonedWnd";
	arrWinList[Index++] = "SummonedWndClassic";
	arrWinList[Index++] = "SystemMsgWnd";
	arrWinList[Index++] = "TargetStatusBuff1Wnd";
	arrWinList[Index++] = "TargetStatusBuff2Wnd";
	arrWinList[Index++] = "TargetStatusWnd";
	arrWinList[Index++] = "TargetStatusWndArena";
	arrWinList[Index++] = "TeleportBookMarkDrawerWnd";
	arrWinList[Index++] = "TeleportBookMarkWnd";
	arrWinList[Index++] = "ToDoListClanWnd";
	arrWinList[Index++] = "ToDoListWnd";
	arrWinList[Index++] = "TokenTradeWnd";
	arrWinList[Index++] = "Tooltip";
	arrWinList[Index++] = "ToolTipWnd";
	arrWinList[Index++] = "TownMapWnd";
	arrWinList[Index++] = "TradeWnd";
	arrWinList[Index++] = "TutorialBtnWnd";
	arrWinList[Index++] = "TutorialViewerWnd";
	arrWinList[Index++] = "UICommandWnd";
	arrWinList[Index++] = "UICommonAPI";
	arrWinList[Index++] = "UIConstants";
	arrWinList[Index++] = "UIData";
	arrWinList[Index++] = "UIDebugWnd";
	arrWinList[Index++] = "UIDevTestWnd";
	arrWinList[Index++] = "UIDevTestWnd_SubFrameWnd";
	arrWinList[Index++] = "UIEasyLoginWnd";
	arrWinList[Index++] = "UIEditor_ControlManager";
	arrWinList[Index++] = "UIEditor_DocumentInfo";
	arrWinList[Index++] = "UIEditor_FileManager";
	arrWinList[Index++] = "UIEditor_PropertyController";
	arrWinList[Index++] = "UIEditor_Worksheet";
	arrWinList[Index++] = "UIHtmlToolWnd";
	arrWinList[Index++] = "UIItemToolWnd";
	arrWinList[Index++] = "UIOpenToolWnd";
	arrWinList[Index++] = "UIPowerToolWnd";
	arrWinList[Index++] = "UIQuestToolWnd";
	arrWinList[Index++] = "UISearchMapWnd";
	arrWinList[Index++] = "UIServerHtmlToolWnd";
	arrWinList[Index++] = "UISysMsgToolWnd";
	arrWinList[Index++] = "UIToolWnd";
	arrWinList[Index++] = "UnionDetailWnd";
	arrWinList[Index++] = "UnionDetailWndClassic";
	arrWinList[Index++] = "UnionMatchDrawerWnd";
	arrWinList[Index++] = "UnionMatchMakeRoomWnd";
	arrWinList[Index++] = "UnionMatchWnd";
	arrWinList[Index++] = "UnionWnd";
	arrWinList[Index++] = "UniversalToolTip";
	arrWinList[Index++] = "UniqueGacha";
	arrWinList[Index++] = "UniqueGachaWarehouseWnd";
	arrWinList[Index++] = "UnrefineryWnd";
	arrWinList[Index++] = "UserAlertMessage";
	arrWinList[Index++] = "UserPetitionWnd";
	arrWinList[Index++] = "ViewPortElementalSpirit";
	arrWinList[Index++] = "ViewPortWndArena";
	arrWinList[Index++] = "ViewPortWndBase";
	arrWinList[Index++] = "ViewPortWndEffect";
	arrWinList[Index++] = "ViewPortWndMonster";
	arrWinList[Index++] = "VipInfoWnd";
	arrWinList[Index++] = "WarehouseWnd";
	arrWinList[Index++] = "WeatherWnd";
	arrWinList[Index++] = "WebBrowserWnd";
	arrWinList[Index++] = "WebPetitionWnd";
	arrWinList[Index++] = "WorldChatBox";
	arrWinList[Index++] = "WorldOlympiadResultWnd";
	arrWinList[Index++] = "XMasSealWnd";
	arrWinList[Index++] = "ZoneQuestAlarmWnd";
	arrWinList[Index++] = "ZoneQuestSituationWnd";
	arrWinList[Index++] = "ZoneTitleWnd";

	MakeWindowList();
}

/**
 * ?ê¬©¬µ¬µ—ó–? ESC ?ï¬∞¬∑–? ?ë–?¬±–≤ ?ì—ñ—ë¬? 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
	m_WindowName="UIToolWnd"
}
