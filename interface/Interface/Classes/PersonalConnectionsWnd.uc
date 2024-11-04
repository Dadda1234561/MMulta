////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Program ID : АОёЖ °ьё® ЅГЅєЕЫ , ёаЖј ёаЕд ЅГЅєЕЫ 
//  Memo       : ёаЖјёаЕд АЪ·б: http://lineage2:8080/wiki/moin.cgi/_b8_e0_c5_e4_b8_e0_c6_bc#line28
//
//  °і№ЯАЪ Вь°н: Е¬¶у Б¤µїЗь, ј­№ц : А±°Ўїµ
//  єфµе ён·Й  :  //make_mentee_list ё¦ ДЎёй 200ён ёаЖј ґл±вАЪ ё®ЅєЖ®ё¦ 200°і АУАЗ·О »эјє. ј­№ц°Ў ДС АЦґВ µїѕИ ЗС№шёё АФ·В ЗТ °Н.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class PersonalConnectionsWnd extends UICommonAPI;

const FRIENDLIST_LIMIT = 128;
const BLOCKLIST_LIMIT = 512; //128; И®АеЗФ
const WATCHLIST_LIMIT = 10;
const MENTEE_LIST_LIMIT = 3;
const MENTOR_LIST_LIMIT = 1;

const DIALOG_PersonalConnectionFriendListRemove = 90007;
const DIALOG_PersonalConnectionBlockListRemove = 90008;
const DIALOG_PersonalConnectionMenteeListRemove = 90020;
const DIALOG_PersonalConnectionWatchListRemove = 90030;
const DIALOG_PersonalConnectionConfirmMentee = 90021;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Struct 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// АОёЖ °ьё® АЇАъ Б¤єё
struct relationMemberInfo
{
	var string Name;      // АМё§
	var int UserID;    // АЇАъID 
	var int ClassID;   // Е¬·ЎЅє ID (їЄИ°)
	var int Level;     // ·№є§
	var bool bOnline;   // БўјУ ї©єО
};

struct _pkUserWatcherTarget
{
	var string sName;
	var int nWorldID;
	var int nLevel;
	var int nClass;
	var byte bLoggedin;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  XML UI 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var WindowHandle Me;
var PersonalConnectionsDrawerWnd m_PersonalConnectionsDrawerWnd;

var TabHandle ConnectionsListSelectTab;
var TextureHandle ConnectionsListSelectTabBgLine;

var TextureHandle TexTabBg;

var TextBoxHandle ListTitle;
var TextBoxHandle ListCount;

var ButtonHandle ListPlusBtn;
var ButtonHandle ListMinusBtn;
var ButtonHandle ListBlockBtn;

var TextureHandle ListDeco;

var ListCtrlHandle FriendList;
var ListCtrlHandle BlockList;
var ListCtrlHandle MentoringList;
var ListCtrlHandle WatchList;
var TextureHandle GroupBox1;
var TextureHandle GroupBox2;

var ButtonHandle InvitePartyBtn;
var ButtonHandle SendPostBtn;
var ButtonHandle InviteClanBtn;
var ButtonHandle WhisperBtn;
var ButtonHandle DetailInfoBtn;
var ButtonHandle OneOnOneTalkBtn;

// АМАьїЎ ј±ЕГЗЯґш ДЈ±ё ё®ЅєЖ® АОµ¦Ѕє 
var int selectedFriendListIndex;
var int selectedBlockListIndex;

// Е¬·Ј °ЎАФА» ЅГДСБЩ ±ЗЗС ї©єО (1 АЦґЩ, 0 ѕшґЩ)
var int nClanJoin;
var L2Util util;

//  і»°Ў MentorАП°жїм 1, MenteeАП°жїм 2, ГіАЅ ЅЕГ»ЗШј­ ё®ЅєЖ®їЎ ЗСёнµµ ѕшґВµҐ °ЕєОЗЯА»°жїмїЎґВ 0
var int mentorMenTeeRole;

var TextBoxHandle GuideTitle;
var TextBoxHandle Guide;

var TextureHandle GroupBox_MentoringList1;
var TextureHandle GroupBox_MentoringList2;
var TextureHandle GroupBox_FriendBlockList;

var UserInfo myUserInfo;

//°иѕа ЗШБц іІАє ЅГ°Ј
var TextBoxHandle NameEnterLimit;
var TextBoxHandle NameEnterLimitTime;

var string MentorName;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// °ь·Г єЇјц
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// АОёЖ °ьё® ё®ЅєЖ®
var array<relationMemberInfo> friendListArray; //   ДЈ±ё ёЙ№ц ё®ЅєЖ® №иї­
var array<relationMemberInfo> clanListArray;   //   ЗчёН АЇАъ ё®ЅєЖ® №иї­
var array<relationMemberInfo> blockListArray;  // ВчґЬµИ АЇАъ ё®ЅєЖ® №иї­

// АОЅєЕПЅє Бё АМ·ВАє є°µµ·О µҐАМЕН·О °ьё® ЗПБц ѕК°н
// Ж®ё®ё¦ ±Ч¶§ ±Ч¶§ »эјє »иБ¦ ЗСґЩ.
// ЅЗЅГ°ЈАё·О °ў АЇАъАЗ БўјУ Б¤єё°Ў №Эїµ µЗБц ѕК±в ¶§№®АМґЩ. 


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ГК±вИ­ °ь·Г 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnRegisterEvent()
{
	//RegisterEvent(  );
	RegisterEvent(EV_Restart);

	// ЗцАз і» Е¬·Ј Б¤єё №Ю±в
	RegisterEvent(EV_ClanMyAuth);

	// ВчґЬ ёс·П 
	RegisterEvent(EV_BlockInfoListEmpty);
	RegisterEvent(EV_BlockAdded);
	RegisterEvent(EV_BlockRemoved);
	RegisterEvent(EV_BlockInfoUpdate);
	RegisterEvent(EV_BlockDetailInfoUpdate);

	// ДЈ±ё ёс·П
	RegisterEvent(EV_FriendInfoListEmpty);
	RegisterEvent(EV_FriendAdded);
	RegisterEvent(EV_FriendRemoved);
	RegisterEvent(EV_FriendInfoUpdate);
	RegisterEvent(EV_FriendDetailInfoUpdate);
	RegisterEvent(EV_ShowPersonalConnectionWnd);
	RegisterEvent(EV_NotifyImportedCrestImage);

	////////////////////////////////////////
	// ёаЖј ёаЕд ЅГЅєЕЫ
	////////////////////////////////////////
	// ёаЖј ЅЕГ» ґЩАМѕу·О±Ч ¶зїмґВ АМєҐЖ®
	RegisterEvent(EV_ConfirmMentee);
	// ёаЖј/ёаЕд ё®ЅєЖІА» №Ю±в ЅГАЫ 
	RegisterEvent(EV_MentorMenteeListStart);
	// °ў ёЙ№цє° , ЗПіЄѕї АМєҐЖ® №Ю±в (»з¶ч јц)
	RegisterEvent(EV_MentorMenteeListInfo);

	// ±вЕё..
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);

	RegisterEvent(EV_NeedResetUIData);

	RegisterEvent(EV_GotoWorldRaidServer);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_USER_WATCHER_TARGET_LIST);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_USER_WATCHER_TARGET_STATUS);
}

function OnLoad()
{
	SetClosingOnESC();

	util = L2Util(GetScript("L2Util"));

	// ГК±вИ­ 
	Initialize();
	Load();

	ConnectionsListSelectTab.SetDisable(2, true);

	selectedFriendListIndex = -1;
	selectedBlockListIndex = -1;
	GetPlayerInfo(myUserInfo);
}

function OnShow()
{
	// End:0x3E
	if(class'UIDATA_PLAYER'.static.IsInDethrone())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		Me.HideWindow();
		return;
	}
	MentorName = "";
	class'PersonalConnectionAPI'.static.RequestFriendInfoList(); // ДЈ±ё ё®ЅєЖ® °»ЅЕ 
	class'PersonalConnectionAPI'.static.RequestBlockInfoList(); // ВчґЬ ё®ЅєЖ® °»ЅЕ

	// End:0x3F
	if(getInstanceUIData().getIsClassicServer())
	{
		API_C_EX_USER_WATCHER_TARGET_LIST();
	}

	// End:0xA3
	if(! IsPlayerOnWorldRaidServer())
	{
		// End:0xA3
		if(getInstanceUIData().getIsLiveServer())
		{
			// End:0xA3
			if(! getInstanceUIData().getIsArenaServer())
			{
				class'PersonalConnectionAPI'.static.RequestMentorList();
				Debug("Api Call RequestMentorList");
			}
		}
	}
	GetPlayerInfo(myUserInfo);
	listTextUpdate();
	checkClanButtonState();

	// End:0x106
	// ёаЕдёµ ЕЬАО °жїм ёаЕдёµ °ЎАМµеё¦ єёї©БЬ. 
	if(ConnectionsListSelectTab.GetTopIndex() == 2 && getInstanceUIData().getIsLiveServer())
	{
		GuideTitle.ShowWindow();
		Guide.ShowWindow();
	}
	else
	{
		GuideTitle.HideWindow();
		Guide.HideWindow();
	}
	disableButtonRaidSever();
}

function checkClassicForm()
{
	ConnectionsListSelectTab.InitTabCtrl();
	// End:0x66
	if(getInstanceUIData().getIsClassicServer())
	{
		ConnectionsListSelectTab.SetButtonName(2, GetSystemString(13532));
		ConnectionsListSelectTab.SetDisable(2, false);
		ConnectionsListSelectTabBgLine.SetWindowSize(74, 24);
	}
	else
	{
		ConnectionsListSelectTab.RemoveTabControl(3);
		ConnectionsListSelectTab.SetButtonName(2, GetSystemString(2767));
		ConnectionsListSelectTab.SetDisable(2, false);
		ConnectionsListSelectTabBgLine.SetWindowSize(74, 24);
	}
}

function Initialize()
{
	Me = GetWindowHandle("PersonalConnectionsWnd");

	// ј­¶ш єёБ¶Гў
	m_PersonalConnectionsDrawerWnd = PersonalConnectionsDrawerWnd(GetScript("PersonalConnectionsDrawerWnd"));

	ConnectionsListSelectTab = GetTabHandle("PersonalConnectionsWnd.ConnectionsListSelectTab");
	ConnectionsListSelectTabBgLine = GetTextureHandle("PersonalConnectionsWnd.ConnectionsListSelectTabBgLine");

	TexTabBg = GetTextureHandle("PersonalConnectionsWnd.TexTabBg");
	ListDeco = GetTextureHandle("PersonalConnectionsWnd.ListDeco");

	ListTitle = GetTextBoxHandle("PersonalConnectionsWnd.ListTitle");
	ListCount = GetTextBoxHandle("PersonalConnectionsWnd.ListCount");

	ListPlusBtn = GetButtonHandle("PersonalConnectionsWnd.ListPlusBtn");
	ListMinusBtn = GetButtonHandle("PersonalConnectionsWnd.ListMinusBtn");
	ListBlockBtn = GetButtonHandle("PersonalConnectionsWnd.ListBlockBtn");

	FriendList = GetListCtrlHandle("PersonalConnectionsWnd.FriendList");
	BlockList = GetListCtrlHandle("PersonalConnectionsWnd.BlockList");
	MentoringList = GetListCtrlHandle("PersonalConnectionsWnd.MentoringList");

	WatchList = GetListCtrlHandle("PersonalConnectionsWnd.WatchList");

	GroupBox1 = GetTextureHandle("PersonalConnectionsWnd.GroupBox1");
	GroupBox2 = GetTextureHandle("PersonalConnectionsWnd.GroupBox2");

	InvitePartyBtn = GetButtonHandle("PersonalConnectionsWnd.InvitePartyBtn");
	SendPostBtn = GetButtonHandle("PersonalConnectionsWnd.SendPostBtn");
	InviteClanBtn = GetButtonHandle("PersonalConnectionsWnd.InviteClanBtn");
	WhisperBtn = GetButtonHandle("PersonalConnectionsWnd.WhisperBtn");
	DetailInfoBtn = GetButtonHandle("PersonalConnectionsWnd.DetailInfoBtn");
	OneOnOneTalkBtn = GetButtonHandle("PersonalConnectionsWnd.OneOnOneTalkBtn");

	GuideTitle = GetTextBoxHandle("PersonalConnectionsWnd.GuideTitle");
	Guide = GetTextBoxHandle("PersonalConnectionsWnd.Guide");

	NameEnterLimit = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterLimit");
	NameEnterLimitTime = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterLimitTime");

	GroupBox_MentoringList1 = GetTextureHandle("PersonalConnectionsWnd.GroupBox_MentoringList1");
	GroupBox_MentoringList2 = GetTextureHandle("PersonalConnectionsWnd.GroupBox_MentoringList2");

	GroupBox_FriendBlockList = GetTextureHandle("PersonalConnectionsWnd.GroupBox_FriendBlockList");

	GuideTitle.HideWindow();
	Guide.HideWindow();

	WatchList.HideWindow();

	// °ў ЕЗ »уЕВїЎ µы¶у ЕШЅєГД єЇ°ж 
	setTextureVisible(0);

	// 2384 ВчґЬ ёс·П
	// 2385 ДЈ±ё ёс·П
	
	GuideTitle.SetText(GetSystemString(2773));
	Guide.SetText(GetSystemString(2770));
	
	// 2010.10 CT3їЎј­ »зїл ѕИЗФ. ЗПБцёё ГЯИД MSN°ъ єЩАє ДЈ±ё ґлИ­ єОєРА» »иБ¦ ЗП°н ГЯИД Бцїш ї№Б¤
	// OneOnOneTalkBtn.HideWindow();

	listTextUpdate();	
}

function Load()
{
	// .. empty
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// АМєҐЖ® -> ЗШґз АМєҐЖ® Гіё® ЗЪµй·Ї
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnEvent(int Event_ID, string param)
{
	//Debug("АОёЖ °ьё® " @ Event_ID);
	//Debug("param: " @ param);
	switch(Event_ID)
	{
		// End:0x15
		case EV_Restart:
			restartHandler();
			// End:0x2BA
			break;
		// End:0x2B
		case EV_ClanMyAuth:
			Debug("EV_ClanMyAuth : " @ param);
			HandleClanMyAuth(param);
			// End:0x2BA
			break;
		// ДЈ±ё ёс·П 
		// End:0x3C
		case EV_FriendInfoListEmpty:
			friendInfoListEmptyHandle();
			// End:0x2BA
			break;
		// End:0x56
		case EV_ShowPersonalConnectionWnd:
			Me.ShowWindow();
			// End:0x2BA
			break;
		// End:0x72
		case EV_FriendAdded:
			friendAddedHandle(param);
			listTextUpdate();
			// End:0x2BA
			break;
		// End:0x8E
		case EV_FriendRemoved:
			friendRemovedHandle(param);
			listTextUpdate();
			// End:0x2BA
			break;
		// End:0xAA
		case EV_FriendInfoUpdate:
			friendInfoUpdateHandle(param);
			listTextUpdate();
			// End:0x2BA
			break;
		// End:0xC6
		case EV_FriendDetailInfoUpdate:
			userDetailInfoUpdateHandle(param);
			listTextUpdate();
			// End:0x2BA
			break;
		// End:0xE0
		// ВчґЬ ёс·П
		case EV_BlockInfoListEmpty:
			BlockList.DeleteAllItem();
			// End:0x2BA
			break;
		// End:0xFC
		case EV_BlockAdded:
			blockAddedHandler(param);
			listTextUpdate();
			// End:0x2BA
			break;
		// End:0x118
		case EV_BlockInfoUpdate:
			blockInfoUpdateHandler(param);
			listTextUpdate();
			// End:0x2BA
			break;
		// End:0x134
		case EV_BlockDetailInfoUpdate:
			blockDetailInfoUpdateHandler(param);
			listTextUpdate();
			// End:0x2BA
			break;
		// End:0x150
		case EV_BlockRemoved:
			blockRemovedHandler(param);
			listTextUpdate();
			// End:0x2BA
			break;
		// АОБё ёс·П
		//case EV_InzonePartyHistoryUpdate :
		//	 break;
		// End:0x15B
		case EV_NotifyImportedCrestImage:
			// notifyImportedCrestImageHandler(param);
			// End:0x2BA
			break;
		// End:0x16C
		case EV_DialogOK:
			HandleDialogOK();
			// End:0x2BA
			break;
		// End:0x17D
		case EV_DialogCancel:
			HandleDialogCancel();
			// End:0x2BA
			break;
		// ёаЖј ёаЕд ё®ЅєЖ® №Ю±в ЅГАЫ 
		// End:0x193
		case EV_MentorMenteeListStart:
			mentorMenteeListStartHandler(param);
			// End:0x2BA
			break;
		// End:0x1AF
		// ёаЕд/ёаЖј АЇАъ ГЯ°Ў
		case EV_MentorMenteeListInfo:
			menTorMenTeeAddedHandle(param);
			listTextUpdate();
			// End:0x2BA
			break;
		// End:0x1C5
		// ёЗЖј µйїЎ°Ф ёаЕд°Ў ЅЕГ»А» ЗЯА»¶§ 
		case EV_ConfirmMentee:
			conFirmMenteeDialogHandler(param);
			// End:0x2BA
			break;
		// End:0x214
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_USER_WATCHER_TARGET_LIST:
			Debug("-- S_EX_USER_WATCHER_TARGET_LIST");
			ParsePacket_S_EX_USER_WATCHER_TARGET_LIST();
			listTextUpdate();
			// End:0x2BA
			break;
		// End:0x25F
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_USER_WATCHER_TARGET_STATUS:
			Debug("-- S_EX_USER_WATCHER_TARGET_STATUS");
			ParsePacket_S_EX_USER_WATCHER_TARGET_STATUS();
			// End:0x2BA
			break;
		// End:0x270
		case EV_NeedResetUIData:
			checkClassicForm();
			// End:0x2BA
			break;
		// End:0x2B7
		case EV_GotoWorldRaidServer:
			WatchList.DeleteAllItem();
			BlockList.DeleteAllItem();
			FriendList.DeleteAllItem();
			MentoringList.DeleteAllItem();
			// End:0x2BA
			break;
	}
}

/** ЕЗ »уЕВїЎ µыёҐ ЕШЅєГД єЇ°ж */
function setTextureVisible(int tabIndex)
{
	switch(tabIndex)
	{
		// ДЈ±ё, ВчґЬЕЗ
		// End:0x0B
		case 0:
		// End:0x5D
		case 1:
			GroupBox_MentoringList1.DisableWindow();
			GroupBox_MentoringList2.DisableWindow();
			GroupBox_FriendBlockList.ShowWindow();
			NameEnterLimit.HideWindow();
			NameEnterLimitTime.HideWindow();
			// End:0xB3
			break;
		// ёаЕдЕЗ
		// End:0xB0
		case 2:
			GroupBox_MentoringList1.ShowWindow();
			GroupBox_MentoringList2.ShowWindow();
			GroupBox_FriendBlockList.DisableWindow();
			NameEnterLimit.ShowWindow();
			NameEnterLimitTime.ShowWindow();
			// End:0xB3
			break;
	}
}

/**
 *  ёаЖј, ёаЕд Б¤єё №Ю±в ЅГАЫ ЗЪµй 
 **/ 
function mentorMenteeListStartHandler(string param)
{
	GetPlayerInfo(myUserInfo);

	// ё®ЅєЖ® »иБ¦	
	MentoringList.DeleteAllItem();

	// ёаЕд/ ёаЖј »уЕВ №Ю±в 
	ParseInt(param, "Role", mentorMenTeeRole);

	// Debug("mentorMenTeeRole" @ mentorMenTeeRole);
	// Debug("param" @ param);

	switch(mentorMenTeeRole)
	{
		// End:0xA0
		// ёаЕд, ёаЖј°Ў ѕЖґС °жїмmentorMenTeeRole °ЄАМ 0, ЗПБцёё 
		case 0 : // °ўјє ЗЯ°н, 85·¦ єёґЩ °°°ЕіЄ Е©ґЩёй ёаЕд°Ў µЙ јц АЦґЩ(ёаЕд ЕЗ И°јєИ­)
			if (myUserInfo.nLevel >= 105 && GetClassTransferDegree(myUserInfo.nSubClass) > 3)
			{
				ConnectionsListSelectTab.SetDisable(2, false);
			}
			// ёаЕдёµ ЕЗ єсИ°јєИ­
			else
			{
				ConnectionsListSelectTab.SetDisable(2, true);
				// єсИ°јєИ­ µЗёй , ДЈ±ёЕЗАё·О АМµї 
				ConnectionsListSelectTab.SetTopOrder(0, false);
			}
			// End:0x101
			break;
		// End:0xB9
		case 1: // ёаЕдАО °жїм 
			// ёаЕдёµ ЕЗ єсИ°јєИ­
			ConnectionsListSelectTab.SetDisable(2, false); 
			break;
		case 2: // ёаЖјАО °жїм 
			// ёаЕдёµ ЕЗ єсИ°јєИ­
			ConnectionsListSelectTab.SetDisable(2, false);
			// End:0x101
			break;

		default: // 0, 1, 2 °Ў ѕЖґС °ЄАМ їГјц ѕшґЩ. ѕЖ·Ў ёЮјјБц°Ў Гв·В µЗёй їЎ·Ї »уЕВАУ
			Debug("Error : mentorMenTeeRole :" @ mentorMenTeeRole);
			break;
	}
	listTextUpdate();
}

// ёаЕд, ёаЖј ГЯ°Ў 
function menTorMenTeeAddedHandle(string param)
{
	local LVDataRecord Record;

	setListRecord(Record, param);

	// ДЈ±ё ё®ЅєЖ®їЎ ГЯ°Ў 
	MentoringList.InsertRecord(Record);
}


/**
 * ёаЕд-> ёаЖјїЎ°Ф 
 * ёаЖј јц¶фА» їдГ»ЗЯА»¶§ іЄїАґВ ґЩАМѕу·О±Ч 
 **/
function conFirmMenteeDialogHandler (string param)
{
	askDialog(DIALOG_PersonalConnectionConfirmMentee, param);
}

/** ё®ЅєЕёЖ® ГК±вИ­ */
function restartHandler()
{
	// єёБ¶ГўАМ ї­·Б АЦґЩёй.. ґЭґВґЩ.
	subWindowClose();
	buttonsEnabled(true);
	//ConnectionsListSelectTab.setT
	ConnectionsListSelectTab.SetTopOrder(0, false);
	WatchList.HideWindow();
}

/** БЯ°ЈїЎ µїёН ЗчёН АМ№МБц°Ў ѕчµҐАМЖ® µЗѕъґЩ°н ѕЛёІ АМєҐЖ®°Ў µйѕо їАёй °»ЅЕ (ДЈ±ёВКїЎёё іЄїА±в ¶§№®) */
function notifyImportedCrestImageHandler(string param)
{
	OnClickListCtrlRecord("FriendList");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ДЈ±ё - АМєҐЖ®їЎ µыёҐ Гіё® 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// ДЈ±ё °ь·Г ё®ЅєЖ® ДБЖ®·Сїл, ·№ДЪµе јјЖГ
// ДЈ±ё, ёаЖј ё®ЅєЖ® јјЖГ
function setListRecord(out LVDataRecord Record, string param)
{
	// parse var
	local string Name, memo;
	local int ClassID, Level, Status;
	local Color TextColor;

	Record.LVDataList.Length = 4;

	// parse
	ParseString(param, "Name", Name);
	ParseString(param, "memo", memo);

	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "Status", Status);

	// set 
	TextColor = util.White;
	// End:0xB8
	//branch GD35_0828 2014-1-13 luciper3 - №иїмАЪ їВ¶уАОАє ЗЦЗОЕ©, №иїмАЪ їАЗБ¶уАОАє ї¬ЗОЕ©·О ЗСґЩ.
	if(Status== 1)
		TextColor = util.BrightWhite;
	else if(Status == 2)
		TextColor = util.PowderPink;
	else if(Status == 3)
		TextColor = util.HotPink;
	//end of branch

	// їВ¶уАО АП¶§ »ц №ЩІЮ
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].TextColor = TextColor;
	Record.LVDataList[1].bUseTextColor = true;
	Record.LVDataList[1].TextColor = TextColor;

// 	if( status > 0 )
// 	{ 
// 		// їАЗБ¶уАО АП¶§ »ц №ЩІЮ
// 		record.LVDataList[0].buseTextColor = True;
// 		record.LVDataList[0].TextColor     = util.BrightWhite;
// 		record.LVDataList[1].buseTextColor = True;
// 		record.LVDataList[1].TextColor     = util.BrightWhite;
// 
// 
// 	}
// 	else
// 	{
// 		// їАЗБ¶уАО АП¶§ »ц №ЩІЮ
// 		record.LVDataList[0].buseTextColor = True;
// 		record.LVDataList[0].TextColor     = util.White;
// 		record.LVDataList[1].buseTextColor = True;
// 		record.LVDataList[1].TextColor     = util.White;
// 	}
		
	// ёЮёрїЎ ґлЗС ЕшЖБ Гв·Вїл 

	Record.szReserved = memo;

	//Record.LVDataList[0].buseTextColor = True;
	Record.LVDataList[0].szData = ConvertWorldIDToStr(Name);
	// Record.LVDataList[0].TextColor = util.Gold;
	// Record.LVDataList[1].buseTextColor = True;
	// Record.LVDataList[1].TextColor = util.White;
	Record.LVDataList[0].szReserved = Name;
	Record.LVDataList[1].szData = string(Level);
	Record.LVDataList[2].szData = string(ClassID);		         // ѕµёр ѕшґВ µҐАМЕНБцёё јТЖГА» А§ЗШј­ іЦґВґЩ
	Record.LVDataList[2].szTexture = GetClassRoleIconName(ClassID);
	Record.LVDataList[2].HiddenStringForSorting = String(GetClassRoleType(ClassID));

	Record.LVDataList[2].nTextureWidth = 11;
	Record.LVDataList[2].nTextureHeight = 11;
	
	Record.LVDataList[3].nTextureWidth = 31;
	Record.LVDataList[3].nTextureHeight = 11;
	Record.nReserved1 = 0;	// for additional information

	// ДЈ±ёАЗ БўјУ »уЕВ on, off 
	if(Status > 0)
	{
		Record.LVDataList[3].szData = "1"; // ѕµёр ѕшґВ µҐАМЕНБцёё јТЖГА» А§ЗШј­ іЦґВґЩ
		Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
	}
	else
	{
		Record.LVDataList[3].szData = "0";
		Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
	}
	// FriendList.SetTooltipCustomType(getMemoToolTip(classID, memo));	
}

// ДЈ±ё ГК±вИ­ ЗЪµй
function friendInfoListEmptyHandle ()
{
	// ДЈ±ё ё®ЅєЖ® »иБ¦
	FriendList.DeleteAllItem();
	//Debug("ДЈ±ё ё®ЅєЖ® »иБ¦!");
}

// ДЈ±ё ГЯ°Ў ЗЪµй
function friendAddedHandle(string param)
{
	local LVDataRecord Record;
	
	setListRecord(Record, param);

	// ДЈ±ё ё®ЅєЖ®їЎ ГЯ°Ў 
	FriendList.InsertRecord(Record);
}

// ДЈ±ё »иБ¦ ЗЪµй
function friendRemovedHandle(string param)
{
	local string Name;
	local int i;

	// parse
	ParseString(param, "Name", Name);

	i = util.ctrlListSearchByName(FriendList, ConvertWorldIDToStr(Name));
	// End:0x5E
	if(i != -1)
	{
		FriendList.DeleteRecord(i);
	}

	// ВчґЬ ёс·ПАМ ЗПіЄµµ ѕшґЩёй.. Гў ґЭґВґЩ.
	// End:0x7C
	if(FriendList.GetRecordCount() <= 0)
	{
		subWindowClose();
	}
	else
	{
		// ГЦЗПґЬАЗ ЗЧёсА» »иБ¦ ЗС °жїм №Щ·О А§·О ЖчДїЅєё¦ °ЎБцµµ·П ЗСґЩ.
		// End:0xC1
		if(FriendList.GetSelectedIndex() == FriendList.GetRecordCount())
		{
			FriendList.SetSelectedIndex(FriendList.GetSelectedIndex() - 1, false);
		}
		OnClickListCtrlRecord("FriendList");
	}
}

// ДЈ±ё Б¤єё ѕчµҐАМЖ®
function friendInfoUpdateHandle(string param)
{
	local LVDataRecord Record;
	local LVDataRecord tempRecord;
	local string Name;
	local int i;

	FriendList.ClearTooltip();

	// parse
	ParseString(param, "Name", Name);

	setListRecord(Record, param);

	// End:0xB5 [Loop If]
	for (i = 0; i < FriendList.GetRecordCount(); i++)
	{
		FriendList.GetRec(i, tempRecord);
		// End:0xAB
		if(tempRecord.LVDataList[0].szData == ConvertWorldIDToStr(Name))
		{
			// ДЈ±ё »иБ¦			
			FriendList.ModifyRecord(i, Record);
			// Debug("ДЈ±ё ё®ЅєЖ® јцБ¤ !: " @ name);
			break;
		}
	}
}

// ДЈ±ё АЇАъ »ујј Б¤єё ѕчµҐАМЖ®
function userDetailInfoUpdateHandle(string param)
{
	// parse var
	local string Name, memo;
	local int ClassID, Level, Status;
	local int PledgeId, allianceID;

	local int birthMonth, birthDay;
	local int logoutDiffSeconds;

	// Debug("---------" @ param);
	// parse
	ParseString(param, "Name", Name);
	ParseString(param, "memo", memo);

	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "Status", Status);

	ParseInt(param, "pledgeID", PledgeId);
	ParseInt(param, "allianceID", allianceID);

	ParseInt(param, "birthMonth", birthMonth);
	ParseInt(param, "birthDay", birthDay);

	ParseInt(param, "logoutDiffSeconds", logoutDiffSeconds);

	// єёБ¶Гў ЗШґз АЇАъ »ујј Б¤єё °»ЅЕ 
	m_PersonalConnectionsDrawerWnd.setDetailInfo(ConvertWorldIDToStr(Name), Level, ClassID, PledgeId, allianceID, birthMonth, birthDay, logoutDiffSeconds, memo);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ВчґЬ ёс·П - АМєҐЖ®їЎ µыёҐ Гіё® 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function setBlockRecord(out LVDataRecord Record, string param)
{
	// parse var
	local string Name, memo;
	
	Record.LVDataList.Length = 1;	

	// parse
	ParseString(param, "Name", Name);
	ParseString(param, "memo", memo);

	// set 
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].szData = ConvertWorldIDToStr(Name);
	Record.LVDataList[0].szReserved = Name;
	Record.LVDataList[0].TextColor = util.Gold;
	Record.nReserved1 = 0;	// for additional information
}

function blockInfoListEmptyHandler()
{
	BlockList.DeleteAllItem();
}

function blockAddedHandler(string param)
{
	local LVDataRecord Record;

	setBlockRecord(Record, param);

	// ·№ДЪµе ЗСБЩѕї ГЯ°Ў
	BlockList.InsertRecord(Record);	

	// Debug("ВчґЬ ё®ЅєЖ® ГЯ°Ў !: " @ name);
}

function blockRemovedHandler(string param)
{
	local string Name;
	local int i;

	// parse
	ParseString(param, "Name", Name);

	i = util.ctrlListSearchByName(BlockList, ConvertWorldIDToStr(Name));
	// End:0x5E
	if(i != -1)
	{
		BlockList.DeleteRecord(i);
	}
	
	// ВчґЬ ёс·ПАМ ЗПіЄµµ ѕшґЩёй.. Гў ґЭґВґЩ.
	// End:0x7C
	if(BlockList.GetRecordCount() <= 0)
	{
		subWindowClose();
	}
	else
	{
		// End:0xC1
		// ГЦЗПґЬАЗ ЗЧёсА» »иБ¦ ЗС °жїм №Щ·О А§·О ЖчДїЅєё¦ °ЎБцµµ·П ЗСґЩ.
		if(BlockList.GetSelectedIndex() == BlockList.GetRecordCount())
		{
			BlockList.SetSelectedIndex(BlockList.GetSelectedIndex() - 1, false);
		}

		OnClickListCtrlRecord("BlockList");
	}
}

function blockInfoUpdateHandler(string param)
{
	local LVDataRecord Record;
	local LVDataRecord tempRecord;
	local string Name;
	local int i;

	// BlockList.ClearTooltip();
	// BlockList.SetTooltipCustomType()

	// parse
	ParseString(param, "Name", Name);

	setBlockRecord(Record, param);

	// End:0xA6 [Loop If]
	for (i = 0; i < BlockList.GetRecordCount(); i++)
	{
		BlockList.GetRec(i, tempRecord);
		// End:0x9C
		if(tempRecord.LVDataList[0].szData == ConvertWorldIDToStr(Name))
		{
			BlockList.ModifyRecord(i, Record);
			// Debug("ВчґЬ ё®ЅєЖ® јцБ¤ !: " @ name);			
			break;
		}
	}
}

function blockDetailInfoUpdateHandler(string param)
{
	// parse var
	local string Name, memo;

	// parse
	ParseString(param, "Name", Name);
	ParseString(param, "memo", memo);

	// єёБ¶Гў ЗШґз АЇАъ »ујј Б¤єё °»ЅЕ 
	m_PersonalConnectionsDrawerWnd.setDetailInfo(Name, 0, 0, 0, 0, 0, 0, 0, memo);
	// Debug("blockDetailInfoUpdateHandler єё±в АМєҐЖ® " @ param);
}

/**
 *  ґЩАМѕу·О±Ч ГўА» ЅЗЗа 
 **/ 
function askDialog(int dialogID, optional string mParam)
{
	local int ClassID, Level;
	local LVDataRecord Record;

	// ґЩёҐ ґЩАМѕу·О±Ч ГўАМ ї­·Б АЦАёёй №«Б¶°З ГлјТ
	// End:0x2B
	if(IsShowWindow("DialogBox"))
	{
		class'PersonalConnectionAPI'.static.ConfirmMenteeAdd(MentorName, 0);
		return;
	}
	DialogSetID(dialogID);
	// ёЗЖ®°Ў ґЩё¦±о ЗЯґВµҐ °б±№ °°ѕТґЩ. ;;
	// End:0x6C
	if(DIALOG_PersonalConnectionFriendListRemove == dialogID)
	{
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3307), getUserNameByList()), string(Self) );
	}
	else if(DIALOG_PersonalConnectionBlockListRemove == dialogID)
	{
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg( GetSystemMessage(3708), getUserNameByList()), string(Self) );
	}
	else if(DIALOG_PersonalConnectionMenteeListRemove == dialogID)
	{
		MentoringList.GetSelectedRec(Record);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg( GetSystemMessage(3711), getUserNameByList()), string(Self) );
 
		//																			  GetClassType(int(record.LVDataList[2].szData)), 
		//																			  record.LVDataList[1].szData),
	}
    else if(DIALOG_PersonalConnectionConfirmMentee == dialogID)
    {
		ParseString(mParam, "MentorName", MentorName);
		ParseInt(mParam, "ClassID", ClassID);
		ParseInt(mParam, "Level", Level);
		
		DialogSetCancelD(DIALOG_PersonalConnectionConfirmMentee);
		//10ГК°Ј ї­ёІ.
		DialogSetParamInt64( 10*1000 );	// 10 seconds
		DialogSetDefaultCancle();

		//	$c1 ґФА» ёаЕд·О »пѕЖ, єё»мЗЛА» №ЮАёЅГ°ЪЅАґП±о? (Е¬·ЎЅє: $s2 / ·№є§: $s3)
		DialogShow(DialogModalType_Modalless, DialogType_Progress, MakeFullSystemMsg( GetSystemMessage(3690), 
																					  mentorName,
																					  GetClassType(classID),
																					  string(level)), 
																					  string(Self) );
    }
    else if(DIALOG_PersonalConnectionWatchListRemove == dialogID)
    {
		WatchList.GetSelectedRec(Record);
		DialogShow(DialogModalType_Modalless, DialogType_Progress, MakeFullSystemMsg(GetSystemMessage(13362), getUserNameByList()), string(self));
    }
}

/** ґЩАМѕу·О±Ч ok µЗѕъА»¶§ Гіё® */
function HandleDialogOK()
{
	local int dialogID, mCode, serverNum;
	local string UserName;
	local array<string> arr;

	// End:0x236
	if(DialogIsMine())
	{
		dialogID = DialogGetID();
		// End:0x59
		// АьАпА» ј±Жч И®АО! АьАпА» ЅГАЫЗСґЩ
		if(DIALOG_PersonalConnectionFriendListRemove == dialogID)
		{
			// Debug("ДЈ±ёёс·П »иБ¦ЗТ userName: " @ userName);
			UserName = ConvertWorldStrToID(getUserNameByList());
			// End:0x56
			if(UserName != "")
			{
				class'PersonalConnectionAPI'.static.RequestRemoveFriend(UserName);
			}
		}
		else if(DIALOG_PersonalConnectionBlockListRemove == dialogID)
		{
			UserName = ConvertWorldStrToID(getUserNameByList());
			// Debug("ВчґЬёс·П »иБ¦ЗТ userName: " @ userName);
			// End:0x9A
			if(UserName != "")
			{
				class'PersonalConnectionAPI'.static.RequestRemoveBlock(UserName);
			}
		}
		else if(DIALOG_PersonalConnectionWatchListRemove == dialogID)
		{
			UserName = ConvertWorldStrToID(getUserNameByList());
			Debug("주시 목록 삭제할 userName: " @ UserName);
			Split(UserName, "_", arr);
			Debug("arr.length" @ string(arr.Length));
			Debug("arr[0]:" @ arr[0]);
			// End:0x187
			if(arr.Length > 1)
			{
				Debug("arr[0]:" @ arr[0]);
				Debug("arr[1]:" @ arr[1]);
				UserName = arr[0];
				serverNum = int(arr[1]);
			}
			// End:0x1A3
			if(UserName != "")
			{
				API_C_EX_USER_WATCHER_DELETE(UserName, serverNum);
			}
		}
		else if(DIALOG_PersonalConnectionMenteeListRemove == dialogID)
		{
			UserName = getUserNameByList();
			// End:0x20F
			if(UserName != "" && mentorMenTeeRole != 0)
			{
				// Debug("del -> mentorName" @ mentorName);

				// End:0x1EF
				if(mentorMenTeeRole == 1)
				{
					mCode = 1;								
				}
				else
				{
					mCode = 0;
				}
				class'PersonalConnectionAPI'.static.RequestMentorCancel(mCode, UserName);
			}
		}
		else if(DIALOG_PersonalConnectionConfirmMentee == dialogID)
		{
			// ёаЕд µо·ПА» ёаЖј°Ў OK ЗЯА»¶§..
			// Debug("call --> class'PersonalConnectionAPI'.static.ConfirmMenteeAdd: "  @ mentorName @ " , 1");

			class'PersonalConnectionAPI'.static.ConfirmMenteeAdd(MentorName, 1);
		}
	}
}

/**
 *  HandleDialogCancel
 **/
function HandleDialogCancel()
{
	local int dialogID;

	// End:0x38
	if(DialogIsMine())
	{
		dialogID = DialogGetID();
		// End:0x38
		if(DialogCheckCancelByID(DIALOG_PersonalConnectionConfirmMentee))
		{
			// ёаЕд µо·ПА» ёаЖј°Ў °ЕАэ cancel ЗЯА»¶§..
			// Debug("call --> class'PersonalConnectionAPI'.static.ConfirmMenteeAdd: "  @ mentorName @ " , 0");
			class'PersonalConnectionAPI'.static.ConfirmMenteeAdd(MentorName, 0);
		}
	}
}

/**
 * ё®ЅєЖ® ґхєнЕ¬ёЇ 
 **/
function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local int tabIndex;

	tabIndex = ConnectionsListSelectTab.GetTopIndex();
	// ДЈ±ё ЕЗАМ¶уёй.. 1:1 ґлИ­
	// ВчґЬ ЕЗАМ¶уёй.. »ујј Б¤єё єё±в
	// ёаЕд ЕЗ
	// End:0x29
	if(tabIndex == 0)
	{
		OnOneOnOneTalkBtnClick();      // 1:1 Г¤ЖГ
	}
	else if (tabIndex == 1)
	{
		onDetailInfoBtnClick();   // »ујј Б¤єё єё±в
	}
	else if (tabIndex == 2)
	{
		// End:0x62
		if(getInstanceUIData().getIsLiveServer())
		{
			OnOneOnOneTalkBtnClick(); // 1:1 Г¤ЖГ
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// №цЖ° Е¬ёЇ - °ўБѕ №цЖ° Е¬ёЇ ЗЪµй·Ї
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnClickButton(string Name)
{
	Debug("Name" @ Name);
	switch(Name)
	{
		// End:0x33
		case "ListPlusBtn":
			OnListPlusBtnClick();
			// End:0x36D
			break;
		// End:0x4D
		case "ListMinusBtn":
			OnListMinusBtnClick();
			// End:0x36D
			break;
		// End:0x67
		case "ListBlockBtn":
			OnListBlockBtnClick();
			// End:0x36D
			break;
		// End:0x83
		case "InvitePartyBtn":
			OnInvitePartyBtnClick();
			// End:0x36D
			break;
		// End:0x9C
		case "SendPostBtn":
			OnSendPostBtnClick();
			// End:0x36D
			break;
		// End:0xB7
		case "InviteClanBtn":
			OnInviteClanBtnClick();
			// End:0x36D
			break;
		// End:0xCF
		case "WhisperBtn":
			OnWhisperBtnClick();
			// End:0x36D
			break;
		// End:0xEA
		case "DetailInfoBtn":
			onDetailInfoBtnClick();
			// End:0x36D
			break;
		// End:0x107
		case "OneOnOneTalkBtn":
			OnOneOnOneTalkBtnClick();
			// End:0x36D
			break;
		// End:0x18A
		case "ConnectionsListSelectTab0":
			subWindowClose();
			buttonsEnabled(true);
			listTextUpdate();
			checkClanButtonState();

			// ёаЕд °ЎАМµе ЕШЅєЖ® 
			WatchList.HideWindow();
			GuideTitle.HideWindow();
			Guide.HideWindow();
			ListPlusBtn.ShowWindow();

			setTextureVisible(0);
			disableButtonRaidSever();
			// End:0x36D
			break;
		// End:0x216
		case "ConnectionsListSelectTab1":
			subWindowClose();
			buttonsEnabled(false);
			listTextUpdate();
			DetailInfoBtn.EnableWindow();

			// ёаЕд °ЎАМµе ЕШЅєЖ® 
			WatchList.HideWindow();
			GuideTitle.HideWindow();
			Guide.HideWindow();

			ListPlusBtn.ShowWindow();

			setTextureVisible(1);
			disableButtonRaidSever();
			// End:0x36D
			break;
		// End:0x36A
		case "ConnectionsListSelectTab2":
			// End:0x2AD
			if(getInstanceUIData().getIsClassicServer())
			{
				subWindowClose();
				buttonsEnabled(false);
				listTextUpdate();
				setTextureVisible(1);
				WhisperBtn.EnableWindow();
				SendPostBtn.EnableWindow();
				MentoringList.HideWindow();
				WatchList.ShowWindow();
				Debug("watch");				
			}
			else
			{
				subWindowClose();
				buttonsEnabled(true);
				listTextUpdate();
				checkClanButtonState();
				GuideTitle.ShowWindow();
				Guide.ShowWindow();
				// End:0x30E
				if(mentorMenTeeRole == 0 || mentorMenTeeRole == 1)
				{
					ListPlusBtn.ShowWindow();					
				}
				else
				{
					ListPlusBtn.HideWindow();
				}
				MentoringList.ShowWindow();
				WatchList.HideWindow();
				OneOnOneTalkBtn.EnableWindow();
				DetailInfoBtn.DisableWindow();
				setTextureVisible(2);
			}
			disableButtonRaidSever();
			// End:0x36D
			break;
	}
}

/** ВчґЬ , ДЈ±ё ёс·П ЕШЅєЖ® ѕчµҐАМЖ®  */
function listTextUpdate()
{
	local int tabIndex, mCount;

	tabIndex = ConnectionsListSelectTab.GetTopIndex();
	// End:0x72
	if(tabIndex == 0)
	{
		ListTitle.SetText(GetSystemString(2385));
		ListCount.SetText("(" $ FriendList.GetRecordCount() $ "/" $ FRIENDLIST_LIMIT $ ")");
	}
	else if (tabIndex == 1)
	{
		ListTitle.SetText(GetSystemString(2384));
		ListCount.SetText("(" $ BlockList.GetRecordCount() $ "/" $ BLOCKLIST_LIMIT $ ")");
	}
	else if (tabIndex == 2)
	{
		// End:0x143
		if(getInstanceUIData().getIsClassicServer())
		{
			ListTitle.SetText(GetSystemString(13533));
			ListCount.SetText("(" $ string(WatchList.GetRecordCount()) $ "/" $ string(10) $ ")");
		}
        else
        {
			//  1 ёЗЕдАО °жїм , 0 ёаЕд, ёаЖј°Ў ѕЖґС °жїм 
			//  2 ёЗЖјАО °жїм
			// End:0x180
			if (mentorMenTeeRole == 1 || mentorMenTeeRole == 0) 
			{  
				mCount = MENTEE_LIST_LIMIT;
				// іЄАЗ ёаЖј
				ListTitle.SetText(GetSystemString(2774));
				// Debug("GetSystemString(2774)" @ GetSystemString(2774) );
			}
			else if (mentorMenTeeRole == 2) 
			{
				mCount = MENTOR_LIST_LIMIT;
				// іЄАЗ ёаЕд 
				ListTitle.SetText(GetSystemString(2768));			
				// Debug("GetSystemString(2768)" @ GetSystemString(2768) );
			}

			ListCount.SetText("(" $ MentoringList.GetRecordCount() $ "/" $ mCount $ ")");
        }
	}
}

/**
 *  ЗШґз ё®ЅєЖ®АЗ ё®ЅєЖ® ДБЖ®·САЗ »уЕВїЎ µы¶уј­ №цЖ°µйАЗ »уЕВё¦ Б¦ѕоЗСґЩ.
 **/
function checkEnabledButton(ListCtrlHandle List)
{
	// End:0x1F
	if(List.GetRecordCount() > 0)
	{
		buttonsEnabled(true);
	}
	else
	{
		buttonsEnabled(false);
	}
}

/**
 *  [АМё§ АФ·В] єёБ¶ Гў ї­±в 
 **/
function OnListPlusBtnClick()
{
	// АМё§А» АФ·В ЗТ јц АЦґВ єёБ¶ ј­¶шГўА» ї¬ґЩ.
	sideWindowOpen("AddWnd");
}

/**
 *  [ј±ЕГµИ АЇАъ»иБ¦]
 *  ДЈ±ё, ВчґЬ °шїл 
 **/
function OnListMinusBtnClick()
{
	local int tabIndex;
	local string tempStr;

	tempStr = getUserNameByList();

	if(tempStr != "")
	{
		tabIndex = ConnectionsListSelectTab.GetTopIndex();

		if (tabIndex == 0)
		{
			askDialog(DIALOG_PersonalConnectionFriendListRemove);
		}
		else if (tabIndex == 1)
		{
			askDialog(DIALOG_PersonalConnectionBlockListRemove);
		}
		else if (tabIndex == 2)
		{
			// End:0x9D
			if(getInstanceUIData().getIsClassicServer())
			{
				Debug("주시 삭제");
				askDialog(DIALOG_PersonalConnectionWatchListRemove);
			}
			else
			{
				askDialog(DIALOG_PersonalConnectionMenteeListRemove);
			}
		}
	}
}

/**
 *  [ј±ЕГµИ АЇАъ ВчґЬ]
 **/
function OnListBlockBtnClick()
{

}

/**
 * [ј±ЕГµИ АЇАъїЎ°Ф ЖДЖј ГКґл ЗП±в]
 **/
function OnInvitePartyBtnClick()
{
	local string tempStr;

	tempStr = ConvertWorldStrToID(getUserNameByList());
	// End:0x6C
	if(tempStr != "")
	{
		// End:0x48
		if(getInstanceUIData().getIsArenaServer())
		{
			//	// ±Ч·м ГКґл
			class'ArenaAPI'.static.RequestMatchGroupAsk(tempStr);
		}
		else
		{
			// ЖДЖј ГКґл 
			RequestInviteParty(tempStr);
			Debug("파티 초대 " @ tempStr);
		}
	}
}

/**
 * [ј±ЕГµИ АЇАъїЎ°Ф їмЖн №ЯјЫ]
 **/
function OnSendPostBtnClick()
{
	local PostBoxWnd postBoxWndScript;
	local PostWriteWnd postWriteWndScript;
	local string tempStr;

	tempStr = getUserNameByList();
	// End:0x84
	if(tempStr != "")
	{
		// їмЖн ГўА» ї­°н ЗШґз АМё§А» іЦ°н їмЖнА» ѕІµµ·П ЗСґЩ.
		postBoxWndScript = PostBoxWnd(GetScript("PostBoxWnd"));
		postWriteWndScript = PostWriteWnd(GetScript("PostWriteWnd"));

		postBoxWndScript.OnClickButton("PostSendBtn");
		postWriteWndScript.toWrite(tempStr);
	}
}

/**
 * [ј±ЕГµИ АЇАъїЎ°Ф ЗчёН ГКґл ЗП±в]
 * АЪЅЕАМ ЗчёНїЎ јТјУµЗѕо АЦіЄ µо Б¶°ЗїЎ µы¶у »зїл °ЎґЙ ї©єО °бБ¤
 **/
function OnInviteClanBtnClick()
{
	local UserInfo Info;
	local string tempStr;

	local LVDataRecord Record;

	local int tabIndex;

	tabIndex = ConnectionsListSelectTab.GetTopIndex();
	
	tempStr = getUserNameByList();

	// Debug("tempStr " @ tempStr);
	// End:0x10A
	if(tempStr != "")
	{
		// End:0x10A
		if(GetPlayerInfo(Info))
		{
			// Debug("nClanID " @ info.nClanID);
			// End:0x5D
			if(tabIndex == 0)
			{
				FriendList.GetSelectedRec(Record);				
			}
			else
			{
				// End:0x7D
				if(tabIndex == 2)
				{
					MentoringList.GetSelectedRec(Record);
				}
			}

			// FriendList.GetSelectedRec(record);			
			// "1"АМёй їВ¶уАО "0" АМёй їАЗБ¶уАО
			// End:0xAB
			if(Record.LVDataList[3].szData != "1")
			{
				// ЗцАз їАЗБ¶уАОАМ¶у°н ѕЛё®°н ѕЖ№«°Нµµ ѕИЗФ
				AddSystemMessageString(GetSystemMessage(3473));
			}
			else
			{
				// CLAN_ACADEMY
				//class'UIDATA_USER'.static.GetClanType(info.nClanID, clanType);
				// Е¬·ЈАМ АЦґЩёй.. ±Чё®°н їВ¶уАО АМ¶уёй..
				// End:0x10A
				if(Info.nClanID > 0)
				{
					// Debug("clanType " @ clanType);				
					// ДЈ±ёАьїл ±вґЙАОµн.. ±Ч·Ўј­ ёаЕдїЎј­ »зїлАМ ѕИµЗґх±єїд.
					// serverID = class'PersonalConnectionAPI'.static.GetFriendServerID(tempStr);
					
					// їВ їАЗБґВ ї№їЬ Гіё® ЗПБц ѕКѕТАЅ
					// record.LVDataList[3].szData = "1";	
					// Debug("serverID " @ serverID);
					//RequestClanAskJoin(serverID, clanType);

					// АМё§ Аё·О Е¬ё°А» °ЎАФ ЗПµµ·П ЗПґВ ЗФјц, Е¬¶у: Б¤µїЗц ГЯ°Ў ЗШБЬ
					//-->
					//RequestClanAskJoinByName(tempStr, clanType);
					//RequestClanAskJoinByName(tempStr, CLAN_ACADEMY);
					// End:0xFE
					if(getInstanceUIData().getIsClassicServer())
					{
						ClanWndClassicNew(GetScript("ClanWndClassicNew")).AskJoinByName(tempStr);
					}
					else
					{
						//InviteClanPopWndScript = InviteClanPopWnd( GetScript("InviteClanPopWnd" ) );
						//InviteClanPopWndScript.showByPersonalConnectionsWndUsingUserName(tempStr);
						RequestClanAskJoinByName(tempStr, 0);
					}
				}
			}
		}
	}
	// Е¬·Ј ГКґл	
	// RequestClanAskJoin(record.LVDataList[0].szData);
}

/**
 *  ЗчёН ГКґл 
 **/ 
function askJoin()
{
	local UserInfo User;
	//local Rect rect;
	//local InviteClanPopWnd script;

	// End:0x87
	if(GetTargetInfo(User))
	{
		//debug("AskJoin id " $ user.nID $ " name " $ user.Name );
		// End:0x87
		if(User.nID > 0)
		{
			// End:0x66
			if(getInstanceUIData().getIsClassicServer())
			{
				ClanWndClassicNew(GetScript("ClanWndClassicNew")).AskJoinByName(User.Name);		
			}
			else
			{
				class'UIAPI_WINDOW'.static.ShowWindow("InviteClanPopWnd");
			}
		}
	}
}

/** Е¬·Ј Б¤єё */
function HandleClanMyAuth(String a_Param)
{
	// Е¬·Ј °ЎАФ±ЗАМ АЦіЄ?
	local int nClanMaster;

	ParseInt(a_Param, "Join", nClanJoin);
	ParseInt(a_Param, "ClanMaster", nClanMaster);
	// End:0x54
	if((nClanMaster == 1) || nClanJoin == 1)
	{
		nClanJoin = 1;
	}
	else
	{
		nClanJoin = 0;
	}
	// Debug("АМєҐЖ® іЇ¶уїИ: " @ a_Param);
	// ЗчёНїЎј­ ГКґл ±ЗЗСАМ АЦґЩёй...
	checkClanButtonState();

	/*
	ParseInt( a_Param, "NickName", m_bNickName );
	ParseInt( a_Param, "ClanCrest", m_bCrest );
	ParseInt( a_Param, "War", m_bWar );
	ParseInt( a_Param, "Grade", m_bGrade );
	ParseInt( a_Param, "ManageMaster", m_bManageMaster );
	ParseInt( a_Param, "OustMember", m_bOustMember );
	*/
}

/**
 * [±УјУё» єёі»±в]
 **/
function OnWhisperBtnClick()
{
	local ChatWnd chatWndScript;
	local string tempStr;

	tempStr = getUserNameByList();
	// End:0x50
	if(tempStr != "")
	{
		chatWndScript = ChatWnd(GetScript("ChatWnd"));
		chatWndScript.SetChatEditBox("\"" $ tempStr $ " ");
	//	callGFxFunction("ChatMessage","sendWhisper", tempStr);
	}
}

/**
 *  [»ујј АЇАъ Б¤єё] єёБ¶ Гў ї­±в 
 **/
function onDetailInfoBtnClick()
{
	// End:0x96
	if(getUserNameByList() != "")
	{
		// End:0x7B
		if(m_PersonalConnectionsDrawerWnd.IsShowWindow("PersonalConnectionsDrawerWnd"))
		{
			// End:0x72
			if(! m_PersonalConnectionsDrawerWnd.DetailInfoWnd.IsShowWindow())
			{
				sideWindowOpen("DetailInfoWnd");
			}
			else
			{
				subWindowClose();
			}
		}
		else
		{
			sideWindowOpen("DetailInfoWnd");
		}
		RequestDetailInfo();
	}
}

/**
 *  [1:1 Г¤ЖГ] Е¬¶уАМѕрЖ®їЎј­ Б¦АЫµИ UI ИЈГв
 **/ 
function OnOneOnOneTalkBtnClick()
{
	local LVDataRecord Record;
	local int tabIndex;
	local string UserName;

	UserName = ConvertWorldStrToID(getUserNameByList());
	tabIndex = ConnectionsListSelectTab.GetTopIndex();
	
	// End:0x10F
	if(UserName != "")
	{
		// ДЈ±ё, ёаЕдёµ ЕЗАЗ °жїм 
		// End:0x55
		if(tabIndex == 0)
		{
			FriendList.GetSelectedRec(Record);
		}
		else if(tabIndex == 2)
		{
			// End:0x8B
			if(getInstanceUIData().getIsClassicServer())
			{
				WatchList.GetSelectedRec(Record);
			}
			else
			{
				MentoringList.GetSelectedRec(Record);
			}
		}
		// їВ¶уАО »уЕВ АО °жїмёё °ЎґЙ
		// End:0xF6
		if(Record.LVDataList[3].szData == "1")
		{
			// 1:1 ґлИ­ Г¤ЖГ ±вґЙ ИЈГв 
			Debug("-> RequestFriendChat -:" @ UserName);
			class'PersonalConnectionAPI'.static.RequestFriendChat(UserName);
		}
		else
		{
			// ЗцАз БўјУЗШ АЦБц ѕКґЩ.
			AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(3), UserName));
		}
	}
}

/**
 *  ё®ЅєЖ® Е¬ёЇ (»ујјБ¤єё їдГ»)
 **/
function OnClickListCtrlRecord(string ListCtrlID)
{
	// End:0x89
	if(m_PersonalConnectionsDrawerWnd.IsShowWindow("PersonalConnectionsDrawerWnd"))
	{
		// End:0x89
		if(! IsPlayerOnWorldRaidServer())
		{
			//ёаЖј/ёаЕд ё®ЅєЖ®°Ў ѕЖґП¶уёй..
			// End:0x89
			if(ConnectionsListSelectTab.GetTopIndex() != 2)
			{
				// End:0x83
				if(! m_PersonalConnectionsDrawerWnd.DetailInfoWnd.IsShowWindow())
				{
					sideWindowOpen("DetailInfoWnd");
				}
				RequestDetailInfo();
			}
		}
	}
}

/** ДЈ±ё, ВчґЬ АЇАъАЗ »ујј Б¤єёё¦ їдГ»ЗСґЩ. */
function RequestDetailInfo()
{
	local string tempStr;
	local int tabIndex;

	tempStr = ConvertWorldStrToID(getUserNameByList());
	tabIndex = ConnectionsListSelectTab.GetTopIndex();
	// End:0x69
	if(tempStr != "")
	{
		// ДЈ±ё ёс·П
		// End:0x55
		if(tabIndex == 0)
		{
			class'PersonalConnectionAPI'.static.RequestFriendDetailInfo(tempStr);
		}
		// ВчґЬ ёс·П
		else
		{
			class'PersonalConnectionAPI'.static.RequestBlockDetailInfo(tempStr);
		}
	}
}

/* ЗцАз ј±ЕГµЗѕоБш ё®ЅєЖ®їЎј­ АМё§ ЅєЖ®ёµА» ё®ЕПЗСґЩ. */
function string getUserNameByList()
{
	local LVDataRecord Record;
	local int tabIndex;
	local string returnStr;

	returnStr = "";
	tabIndex = ConnectionsListSelectTab.GetTopIndex();
		
	// - ЗцАз ЕЗАЗ »уЕВ- 
	// [ёс·П]
	// End:0x6F
	if(tabIndex == 0)
	{
		// End:0x6C
		if(FriendList.GetSelectedIndex() != -1)
		{
			FriendList.GetSelectedRec(Record);
			returnStr = Record.LVDataList[0].szData;
		}
	}
	// [ВчґЬ]
	// End:0xC1
	else if (tabIndex == 1)
	{
		if (BlockList.GetSelectedIndex() != -1)
		{
			BlockList.GetSelectedRec(Record);
			returnStr = Record.LVDataList[0].szData;
		}
	}
	// [ёаЖј, ёаЕд]
	else if (tabIndex == 2)
	{
		// End:0x127
		if(getInstanceUIData().getIsClassicServer())
		{
				// End:0x124
				if(WatchList.GetSelectedIndex() != -1)
				{
					WatchList.GetSelectedRec(Record);
					returnStr = Record.LVDataList[0].szData;
				}
		}
		else
		{
				if (MentoringList.GetSelectedIndex() != -1)
				{
					MentoringList.GetSelectedRec(Record);
					returnStr = Record.LVDataList[0].szData;
				}
		}
	}
	// End:0x182
	if(returnStr == "")
	{
		// ЅГЅєЕЫ ёЮјјБц Гв·В
		// ёс·ПА» ј±ЕГЗШ!
		AddSystemMessage(3314);
	}

	return returnStr;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// АЇЖї ЗФјц 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function OnCallUCFunction(string funcName, string param)
{
	// Debug("p funcName:" @ funcName);
	// Debug("param:" @ param);
	// End:0x50
	if(funcName == "checkInviteClanByGfxCallFunction")
	{
		// End:0x43
		if(param == "1")
		{
			nClanJoin = 1;
		}
		else
		{
			nClanJoin = 0;
		}

		checkClanButtonState();
	}
}

/**
 *  ЗчёН јТјУАОБц ГјЕ©ЗШј­ И°јє єсИ°јє ї©єО БцБ¤
 **/
function checkClanButtonState()
{
	local UserInfo UserInfo;

	// End:0x1A
	if(IsPlayerOnWorldRaidServer())
	{
		InviteClanBtn.DisableWindow();
		return;
	}

	// End:0xD3
	if(GetPlayerInfo(UserInfo))
	{
		//ЗчёН №М°ЎАФАЪ
		// End:0x4A
		if(UserInfo.nClanID == 0)
		{
			InviteClanBtn.DisableWindow();
		}
		//ЗчёН °ЎАФАЪ
		else
		{
			// Г№№шВ° ДЈ±ё,ёаЕдёаЖј ЖБїЎј­ёё єёАМµµ·П ЗП°н
			switch(ConnectionsListSelectTab.GetTopIndex())
			{
				// End:0x5F
				case 0:
				// End:0xD0
				case 2:
					// End:0xA1
					if(getInstanceUIData().getIsClassicServer() && ConnectionsListSelectTab.GetTopIndex() == 2)
					{
						InviteClanBtn.DisableWindow();
					}
					else
					{
						// ЗчёНїЎ °ЎАФµИ ЗчїшБЯ ЗчёН ГКґл°Ў °ЎґЙЗС ѕЦµйёё №цЖ° И°јєИ­
						// End:0xBE
						if(nClanJoin == 0)
						{
							InviteClanBtn.DisableWindow();
						}
						else
						{
							InviteClanBtn.EnableWindow();
						}
						// End:0xD3
						break;
					}

					// Debug("nClanJoin " @ nClanJoin);
			}
		}
	}
}

/**
 *  ЗцАз №цЖ° И°јєИ­ єсИ°јєИ­ 
 **/
function buttonsEnabled(bool bFlag)
{
	// End:0x66
	if(bFlag)
	{
		InvitePartyBtn.EnableWindow();
		SendPostBtn.EnableWindow();
		InviteClanBtn.EnableWindow();

		WhisperBtn.EnableWindow();
		DetailInfoBtn.EnableWindow();
		OneOnOneTalkBtn.EnableWindow();
	}
	else
	{
		InvitePartyBtn.DisableWindow();
		SendPostBtn.DisableWindow();
		InviteClanBtn.DisableWindow();
		WhisperBtn.DisableWindow();
		DetailInfoBtn.DisableWindow();
		OneOnOneTalkBtn.DisableWindow();
	}
}

/**
 * БцБ¤ЗС №иї­А» ёрµО »иБ¦ ЗСґЩ.
 * 
 */
function removeAllArrayItems(out array<relationMemberInfo> pArray)
{
	// End:0x19
	if(pArray.Length > 0)
	{
		pArray.Remove(0, pArray.Length);
	}
}

/**
 * БцБ¤ЗС №иї­А» ёрµО »иБ¦ ЗСґЩ.
 * 
 */
function removeArrayItem(out array<relationMemberInfo> pArray, int deleteItemIndex)
{
	// End:0x1C
	if(pArray.Length > deleteItemIndex)
	{
		pArray.Remove(deleteItemIndex, 1);
	}
}

/**
 *  єёБ¶ГўА» ї¬ґЩ.(ї­·Б АЦґЩёй ґЭИч°Ф ЗСґЩ)
 *  
 *  AddWnd        
 *  NameEnterWnd  
 *  ClanListWnd
 *  InzoneTreeWnd
 *  DetailInfoWnd
 *  MenteeSearchWnd (ГЯ°ЎµК)
 **/ 
function sideWindowOpen(string sideWindowName)
{
	local WindowHandle sideWindowHandler;

	sideWindowHandler = GetWindowHandle("PersonalConnectionsDrawerWnd." $ sideWindowName);

	// MenteeSearchWnd
	// End:0xBB
	if(m_PersonalConnectionsDrawerWnd.IsShowWindow("PersonalConnectionsDrawerWnd"))
	{
		// End:0xA4
		if(sideWindowHandler.IsShowWindow())
		{
			m_PersonalConnectionsDrawerWnd.HideWindow("PersonalConnectionsDrawerWnd");
			// Debug("PersonalConnectionsDrawerWnd hide!");
		}
		else
		{
			m_PersonalConnectionsDrawerWnd.showSelectWindow(sideWindowName);
			// Debug("PersonalConnectionsDrawerWnd ї­ѕо¶у!!");
		}
	}
	else
	{
		m_PersonalConnectionsDrawerWnd.ShowWindow("PersonalConnectionsDrawerWnd");
		m_PersonalConnectionsDrawerWnd.showSelectWindow(sideWindowName);
		// Debug("PersonalConnectionsDrawerWnd ґЩ ї­ѕо¶у!!");
	}
}

/**
 *  єёБ¶ Гў ґЭ±в
 **/
function subWindowClose()
{
	// End:0x5D
	if(m_PersonalConnectionsDrawerWnd.IsShowWindow("PersonalConnectionsDrawerWnd"))
	{
		m_PersonalConnectionsDrawerWnd.HideWindow("PersonalConnectionsDrawerWnd");
	}
}


/**
 *  ЕшЖБ , ёЮёр , »зїлѕИЗФ 
 */
function CustomTooltip getMemoToolTip(int Job, string memo)
{
	local CustomTooltip m_Tooltip;

	m_Tooltip.DrawList.Length = 2;
	m_Tooltip.MinimumWidth = 160;

	m_Tooltip.DrawList[0].eType = DIT_TEXT;

	m_Tooltip.DrawList[0].t_strText = GetSystemString(391) $ " : " $ GetClassType(Job);

	m_Tooltip.DrawList[1].eType = DIT_TEXT;
	m_Tooltip.DrawList[1].t_color.R = 175;
	m_Tooltip.DrawList[1].t_color.G = 152;
	m_Tooltip.DrawList[1].t_color.B = 120;
	m_Tooltip.DrawList[1].t_color.A = 255;
	m_Tooltip.DrawList[1].t_strText = memo;
	return m_Tooltip;
}

function ParsePacket_S_EX_USER_WATCHER_TARGET_STATUS()
{
	local UIPacket._S_EX_USER_WATCHER_TARGET_STATUS packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_USER_WATCHER_TARGET_STATUS(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_USER_WATCHER_TARGET_STATUS :  " @ packet.sName @ string(packet.nWorldID) @ string(packet.bLoggedin));
	watchInfoUpdateHandle(packet.sName, packet.nWorldID, bool(packet.bLoggedin));
}

function watchInfoUpdateHandle(string Name, int nWorldID, bool bLoggedin)
{
	local LVDataRecord tempRecord;
	local int i;

	WatchList.ClearTooltip();
	// End:0x37
	if(IsPlayerOnWorldRaidServer())
	{
		Name = ConvertWorldIDToStr((Name $ "_") $ string(nWorldID));
	}

	// End:0x1C2 [Loop If]
	for(i = 0; i < WatchList.GetRecordCount(); i++)
	{
		WatchList.GetRec(i, tempRecord);
		// End:0x1B8
		if(tempRecord.LVDataList[0].szData == Name)
		{
			// End:0x119
			if(bLoggedin)
			{
				tempRecord.LVDataList[0].bUseTextColor = true;
				tempRecord.LVDataList[0].TextColor = util.BrightWhite;
				tempRecord.LVDataList[1].szData = "1";
				tempRecord.LVDataList[1].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";				
			}
			else
			{
				tempRecord.LVDataList[0].bUseTextColor = true;
				tempRecord.LVDataList[0].TextColor = util.White;
				tempRecord.LVDataList[1].szData = "0";
				tempRecord.LVDataList[1].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
			}
			WatchList.ModifyRecord(i, tempRecord);
		}
	}
}

function string splitName(string withServerName)
{
	local array<string> arr;

	Split(withServerName, "_", arr);
	Debug("arr" @ string(arr.Length));
	// End:0x3C
	if(arr.Length > 1)
	{
		return arr[0];
	}
	return withServerName;
}

function disableButtonRaidSever()
{
	// End:0x36
	if(IsPlayerOnWorldRaidServer())
	{
		DetailInfoBtn.DisableWindow();
		SendPostBtn.DisableWindow();
		InviteClanBtn.DisableWindow();
	}
}

function ParsePacket_S_EX_USER_WATCHER_TARGET_LIST()
{
	local UIPacket._S_EX_USER_WATCHER_TARGET_LIST packet;
	local int i;
	local LVDataRecord Record;

	WatchList.DeleteAllItem();
	// End:0x2A
	if(! class'UIPacket'.static.Decode_S_EX_USER_WATCHER_TARGET_LIST(packet))
	{
		return;
	}

	// End:0x18B [Loop If]
	for(i = 0; i < packet.targetList.Length; i++)
	{
		Debug(" -->  Decode_S_EX_USER_WATCHER_TARGET_LIST :  " @ packet.targetList[i].sName @ string(packet.targetList[i].nWorldID) @ string(packet.targetList[i].nLevel) @ string(packet.targetList[i].nClass) @ string(packet.targetList[i].bLoggedin));
		setWatchListRecord(Record, packet.targetList[i].sName, packet.targetList[i].nWorldID, packet.targetList[i].nLevel, packet.targetList[i].nClass, bool(packet.targetList[i].bLoggedin));
		WatchList.InsertRecord(Record);
	}
}

function setWatchListRecord(out LVDataRecord Record, string sName, int nWorldID, int Level, int ClassID, bool bLoggedin)
{
	local string Name;
	local Color TextColor;

	Record.LVDataList.Length = 2;
	// End:0x33
	if(IsPlayerOnWorldRaidServer())
	{
		Name = sName $ "_" $ string(nWorldID);		
	}
	else
	{
		Name = sName;
	}
	Record.nReserved1 = nWorldID;
	Record.LVDataList[0].szData = ConvertWorldIDToStr(Name);
	Record.LVDataList[0].szReserved = Name;
	Record.LVDataList[1].nTextureWidth = 31;
	Record.LVDataList[1].nTextureHeight = 11;
	Record.nReserved1 = 0;
	Debug("bLoggedin" @ string(bLoggedin));
	// End:0x143
	if(bLoggedin)
	{
		TextColor = util.BrightWhite;
		Record.LVDataList[1].szData = "1";
		Record.LVDataList[1].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";		
	}
	else
	{
		TextColor = util.White;
		Record.LVDataList[1].szData = "0";
		Record.LVDataList[1].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
	}
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].TextColor = TextColor;
}

function API_C_EX_USER_WATCHER_DELETE(string sTargetName, int nTargetWorldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_USER_WATCHER_DELETE packet;

	packet.sTargetName = sTargetName;
	packet.nTargetWorldID = nTargetWorldID;
	// End:0x40
	if(! class'UIPacket'.static.Encode_C_EX_USER_WATCHER_DELETE(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_USER_WATCHER_DELETE, stream);
	Debug(("----> Api Call : C_EX_USER_WATCHER_DELETE" @ sTargetName) @ string(nTargetWorldID));
}

function API_C_EX_USER_WATCHER_TARGET_LIST()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_USER_WATCHER_TARGET_LIST, stream);
	Debug("----> Api Call : C_EX_USER_WATCHER_TARGET_LIST");
}

/**
 * А©µµїм ESC Е°·О ґЭ±в Гіё® 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("PersonalConnectionsWnd").HideWindow();
}

defaultproperties
{
}
