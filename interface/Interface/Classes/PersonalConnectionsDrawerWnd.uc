class PersonalConnectionsDrawerWnd extends UICommonAPI;

const MAX_MEMO_LENGTH = 50;

var WindowHandle Me;
var WindowHandle AddWnd;

var TextBoxHandle AddWndTitle;
var TabHandle AddWndTab;
var TextureHandle AddListTabBgLine;
var TextureHandle AddListTabBg;

var WindowHandle NameEnterWnd;
var TextBoxHandle NameEnter_Description;
var TextBoxHandle NameEnterTitle;
var EditBoxHandle NameEnterEditbox;
var TextureHandle DecoGroupBox;

var WindowHandle ClanListWnd;
var TextBoxHandle ClanList_Description;
var TextureHandle ClanListDeco;
var ListCtrlHandle ClanList;
var TextureHandle ClanListGroupBox;

var WindowHandle InzoneTreeWnd;
var TextBoxHandle InzoneTree_Description;
var TreeHandle InzoneTree;
var TextureHandle InzoneClanListGroupBox;
var ButtonHandle AddListBtn;
var ButtonHandle CloseBtn;
var TextureHandle DescriptionGroupBox;

var WindowHandle DetailInfoWnd;
var WindowHandle MenteeSearchWnd;

var MultiEditBoxHandle MemoContents;
var ButtonHandle MemoEnterBtn;
var TextureHandle texPledgeCrest;
var TextureHandle texPledgeAllianceCrest;

// ёаЖј °Л»ц А©µµїм ёЙ№ц
var ButtonHandle AddMenteeBtn;
var ButtonHandle WhisperMenteeBtn;
var ButtonHandle CloseMenteeBtn;
var ButtonHandle RefreshMenteeBtn;
var ButtonHandle BackwardBtn;
var ButtonHandle ForwardBtn;
var TextBoxHandle MenteeCount;
var ComboBoxHandle LevelComboBox;
var ListCtrlHandle MenteeList;
var PersonalConnectionsWnd personalConnectionsWndScript;
// ЗцАз ёаЖј ЖдАМБц Д«їоЖ®
var int menTeeListCurrentPageCount;
var int menTeeListTotalPage;

var L2Util util;

var string beforeSelectedTreePath;
var string inzoneSelectedParam;
var string selectTreeNodeStr;

// ёаЖј °иѕа ЗШБц іІАє ЅГ°Ј
var TextBoxHandle NameEnterLimit;
var TextBoxHandle NameEnterLimitTime;

function OnRegisterEvent()
{
	RegisterEvent(EV_Restart);

	// ЗчёН ёс·П
	registerEvent(EV_ClanDeleteAllMember);
	registerEvent(EV_ClanAddMember);
	registerEvent(EV_ClanMemberInfoUpdate);
	registerEvent(EV_ClanDeleteMember);

	registerEvent(EV_ClanInfo);
	registerEvent(EV_ClanInfoUpdate);
	registerEvent(EV_ClanAddMemberMultiple);

	// їмЖнїЎј­ ѕІґш ЗчёН ёс·П ё®ЅєЖ®
	registerEvent(EV_ReceivePledgeMemberList);


	// АОБё ЖДЖј ИчЅєЕдё®
	//registerEvent(EV_InzonePartyHistoryUpdate);

	// ёаЖј ґл±вАЪ ё®ЅєЖ® №Ю±в 
	registerEvent(EV_MenteeWaitingListStart);
	registerEvent(EV_MenteeWaitingList);
	registerEvent(EV_MenteeWaitingListEnd);

	// ёаЖј °иѕа ЗШБц іІАє ЅГ°Ј
	registerEvent(EV_MentorMenteeListStart);
}

function OnLoad()
{
	SetClosingOnESC();
	// Debug("АОёЖ °ьё® єёБ¶Гў onLoad");
	Initialize();
	Load();

	util = L2Util(GetScript("L2Util"));

	// ·№є§ №ьА§ ГЯ°Ў
	// 1~40, 41 ~ 60, 
	LevelComboBox.AddString(GetSystemString(2780));
	LevelComboBox.AddString(GetSystemString(2781));
	LevelComboBox.AddString(GetSystemString(2782));
	LevelComboBox.AddString(GetSystemString(2783));

	menTeeListTotalPage = 1;
	menTeeListCurrentPageCount = 1;
}

function mentorMenteeListStartHandle(string param)
{
	local int DisableTimeInSec;
	//local int Role;
	//local string NameEnterLimitTimeStr;
	//parseInt(param, "Role", Role);
	ParseInt(param, "DisableTimeInSec", DisableTimeInSec);
	// End:0x52
	if(DisableTimeInSec == 0)
	{
		NameEnterLimit.SetText("");
		NameEnterLimitTime.SetText("");
	}
	else
	{
		//NameEnterLimitTimeStr = GetSystemMessage(3902) $ "\\n" $ makeNameEnterLimitTime(DisableTimeInSec) ;
		NameEnterLimit.SetText(GetSystemMessage(3902));
		//NameEnterLimit.SetText("ёУ¶уёУ¶у!!!!");
		NameEnterLimitTime.SetText(makeNameEnterLimitTime(DisableTimeInSec));
	}
	//Debug("mentorMenteeListStartHandle" @ NameEnterLimitTimeStr);
}

function string makeNameEnterLimitTime(int DisableTimeInSec)
{
	local string tmpStr;
	local int CurDay;
	local int Totday;
	local int Curhou;
	local int Tothou;
	local int Curmin;
	local int Totmin;
	local int Totsec;

	Totsec = DisableTimeInSec;
	// End:0x50
	if(Totsec < 60)
	{
		tmpStr = MakeFullSystemMsg(GetSystemMessage(3390), "1"); //1єР
		tmpStr = MakeFullSystemMsg(GetSystemMessage(3408), tmpStr);
	}
	else
	{
		Totmin = Totsec / 60;
		Curmin = Totmin % 60;
		Tothou = Totmin / 60;
		Curhou = Tothou % 24;
		Totday = Tothou / 24;
		CurDay = Totday % 24;

		//Debug("test" @ Tothou @ Curhou);

		if (Tothou >= 24) tmpStr = MakeFullSystemMsg(GetSystemMessage(3418), String(CurDay)) ; //АП
		if (Tothou > 0  && Curhou != 0)  tmpStr = tmpStr @ MakeFullSystemMsg(GetSystemMessage(3406), String(Curhou)) ; //ЅГ°Ј
		if (Curmin != 0) tmpStr = tmpStr @ MakeFullSystemMsg(GetSystemMessage(3390), String(Curmin)) ; //єР
	}

	tmpStr = GetSystemString(1108) @ tmpStr; //іІАє ЅГ°Ј

	return tmpStr;
}

function OnShow()
{
	// End:0x37
	if((personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex() == 2) && getInstanceUIData().getIsClassicServer())
	{		
	}
	else
	{
		// End:0xAF
		if(getInstanceL2Util().isClanV2())
		{
			class'PostWndAPI'.static.RequestPledgeMemberList();
			GetButtonHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanListReset_Btn").ShowWindow();
		}
		else
		{
			// End:0x11C
			if(! IsPlayerOnWorldRaidServer())
			{
				// ±вБё, ЗчёН ё®ЅєЖ® Б¤єё
				class'UIDATA_CLAN'.static.RequestClanInfo();
				GetButtonHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanListReset_Btn").HideWindow();
			}
		}
	}

	// АОБё Б¤єё їдГ»	
	// ѕЖ·№іЄїЎј­ґВ »зїл ѕИЗФ.
	//if (! getInstanceUIData().getIsArenaServer()) 
	//	class'PersonalConnectionAPI'.static.RequestInzonePartyInfoHistory();

	texPledgeCrest.HideWindow();
	texPledgeAllianceCrest.HideWindow();
	// End:0x17B
	if(getInstanceUIData().getIsClassicServer())
	{
		// End:0x16A
		if(IsPlayerOnWorldRaidServer())
		{
			AddWndTab.SetDisable(1, true);			
		}
		else
		{
			AddWndTab.SetDisable(1, false);
		}
	}
}

function Initialize()
{
	Me = GetWindowHandle("PersonalConnectionsDrawerWnd");

	NameEnterLimit = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterLimit");
	NameEnterLimitTime = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterLimitTime");

	AddWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.AddWnd");
	AddWndTitle = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.AddWndTitle");
	AddWndTab = GetTabHandle("PersonalConnectionsDrawerWnd.AddWnd.AddWndTab");

	AddListTabBgLine = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.AddListTabBgLine");
	AddListTabBg = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.AddListTabBg");

	NameEnterWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd");
	NameEnter_Description = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd.NameEnter_Description");
	NameEnterTitle = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd.NameEnterTitle");
	NameEnterEditbox = GetEditBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd.NameEnterEditbox");
	DecoGroupBox = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd.DecoGroupBox");

	ClanListWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd");
	ClanList_Description = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanList_Description");
	ClanListDeco = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanListDeco");
	ClanList = GetListCtrlHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanList");
	ClanListGroupBox = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanListGroupBox");

	InzoneClanListGroupBox = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd.ClanListGroupBox");
	InzoneTreeWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd");
	InzoneTree_Description = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd.InzoneTree_Description");
	InzoneTree = GetTreeHandle("PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd.InzoneTree");
	
	AddListBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.AddWnd.AddListBtn");
	CloseBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.AddWnd.CloseBtn");
	DescriptionGroupBox = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.DescriptionGroupBox");

	DetailInfoWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd");

	// ёаЕд ґл±вАЪ °Л»ц ±вґЙ ГЯ°Ў 
	MenteeSearchWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd");

	MemoContents = GetMultiEditBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.MemoContents");
	MemoEnterBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.MemoEnterBtn");
	// End:0x807
	if(getInstanceUIData().getIsClassicServer())
	{
		texPledgeCrest = GetTextureHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.texPledgeCrestClassic");		
	}
	else
	{
		texPledgeCrest = GetTextureHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.texPledgeCrest");
	}
	texPledgeAllianceCrest = GetTextureHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.texPledgeAllianceCrest");

	AddMenteeBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.AddMenteeBtn");
	WhisperMenteeBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.WhisperMenteeBtn");
	CloseMenteeBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.CloseMenteeBtn");
	RefreshMenteeBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.RefreshMenteeBtn");

	BackwardBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.BackwardBtn");
	ForwardBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.ForwardBtn");

	MenteeCount = GetTextBoxHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.MenteeCount");

	LevelComboBox = GetComboBoxHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.LevelComboBox");
	MenteeList = GetListCtrlHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.MenteeList");

	// єОёр А©µµїм script
	personalConnectionsWndScript = PersonalConnectionsWnd(GetScript("PersonalConnectionsWnd"));

	// 50АЪ Б¦ЗС 
	MemoContents.SetMaxSizeOfText(50);

	GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BlockInfoText").HideWindow();
	beforeSelectedTreePath = "";
	// End:0xB9F
	if(getInstanceUIData().getIsArenaServer())
	{
		AddWndTab.InitTabCtrl();
		AddWndTab.RemoveTabControl(2);
		AddWndTab.RemoveTabControl(1);
		AddListTabBgLine.SetWindowSize(182, 24);
	}
}

function Load()
{

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// №цЖ° Е¬ёЇ АМєҐЖ® 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnClickButton(string Name)
{
	local LVDataRecord Record;
	local string tempStr;

	switch(Name)
	{
		// ЗчёН v2 їЎј­ »зїл.
		// End:0x2F
		case "ClanListReset_Btn":
			class'PostWndAPI'.static.RequestPledgeMemberList();
			// End:0x2CA
			break;
		// End:0x47
		case "AddListBtn":
			OnAddListBtnClick();
			// End:0x2CA
			break;
		// End:0x5A
		case "CloseMenteeBtn":
		// End:0x70
		case "CloseBtn":
			OnCloseBtnClick();
			// End:0x2CA
			break;
		// End:0x8A
		case "MemoEnterBtn":
			memoEnterBtnHandler();
			// End:0x2CA
			break;
		// End:0x99
		case "AddWndTab0":
		// End:0xA8
		case "AddWndTab1":
		// End:0x192
		case "AddWndTab2":
			// АОБё Б¤єё їдГ»
			// class'PersonalConnectionAPI'.static.RequestInzonePartyInfoHistory();
			// ёаЕдёµ »уЕВ 
			// End:0x171
			if(personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex() == 2)
			{
				// ёаЕдёµЕЗїЎј­ , ёаЖј °Л»цА» Е¬ёЇЗС °жїм 
				// End:0x141
				if(AddWndTab.GetTopIndex() == 2)
				{
					InzoneTreeWnd.HideWindow();
					MenteeSearchWnd.ShowWindow();

					AddListBtn.HideWindow();
					CloseBtn.HideWindow();

					// ёаЖј ё®ЅєЖ®їдГ»					
					callMenTeeList(LevelComboBox.GetSelectedNum(), 1);
				}
				else
				{
					MenteeSearchWnd.HideWindow();
					AddListBtn.ShowWindow();
					CloseBtn.ShowWindow();
				}
			}
			else
			{
				AddListBtn.ShowWindow();
				CloseBtn.ShowWindow();
			}
			// End:0x2CA
			break;
		// End:0x1C0
		case "RefreshMenteeBtn":
			callMenTeeList(LevelComboBox.GetSelectedNum(), 1);
			// End:0x2CA
			break;
		// End:0x1F0
		case "BackwardBtn":
			callMenTeeList(LevelComboBox.GetSelectedNum(), menTeeListCurrentPageCount - 1);
			// End:0x2CA
			break;
		// End:0x21F
		case "ForwardBtn":
			callMenTeeList(LevelComboBox.GetSelectedNum(), menTeeListCurrentPageCount + 1);
			// End:0x2CA
			break;
		// End:0x249
		case "WhisperMenteeBtn":
			OnDBClickListCtrlRecord("MenteeList");
			// End:0x2CA
			break;
		// End:0x2C7
		case "AddMenteeBtn":
			// ёаЕд ґл±вАЪ БЯїЎ ёаЕд ГКґл
			MenteeList.GetSelectedRec(Record);
			// End:0x296
			if(Record.LVDataList.Length > 0)
			{
				tempStr = Record.LVDataList[0].szData;
			}
			// End:0x2B9
			if(tempStr != "")
			{
				// debug("RequestMenteeAdd" @ tempStr); 
				class'PersonalConnectionAPI'.static.RequestMenteeAdd(tempStr);
			}
			else
			{
				AddSystemMessage(3314); // ёс·ПА» ј±ЕГЗП¶уґВ ёЮјјБц Гв·В 
			}
			// End:0x2CA
			break;
	}

	// АОБё Ж®ё® 
	// End:0x387
	if(Left(Name, 4) == "root")
	{
		// "root.list1.member1" АМёй 13АЪ°Ў іСАёґП±о  [ЅЙї¬АЗ №М±Г] - єЇЅЕёЗ
		// µО№шВ° ґЬ°иАЗ ілµеё¦ Е¬ёЇ ЗС °НїЎ ґлЗШј­ёё Б¶°З ГјЕ© 
		// End:0x362
		if(13 < Len(Name))
		{
			// End:0x32A
			if(beforeSelectedTreePath != Name)
			{
				// End:0x30A
				if(beforeSelectedTreePath == "")
				{
				}
				else
				{
					InzoneTree.SetExpandedNode(beforeSelectedTreePath, false);
					selectTreeNodeStr = "";
				}
			}
			else
			{
				InzoneTree.SetExpandedNode(beforeSelectedTreePath, true);

				// Debug("inzoneSelectedParam" @ inzoneSelectedParam);
								
				// debug("selectTreeNodeStr" @ selectTreeNodeStr);

			}
			ParseString(inzoneSelectedParam, Name, selectTreeNodeStr);
			beforeSelectedTreePath = Name;
		}
		else
		{
			InzoneTree.SetExpandedNode(beforeSelectedTreePath, false);
			beforeSelectedTreePath = "";
			selectTreeNodeStr = "";
		}
	}

	// Debug("string : " @ name);
}

function treeSelectHandler()
{
//	InzoneTree.SetExpandedNode(beforeTreeName, false);	
}

/**
 *  ёЮёр АФ·В 
 **/
function memoEnterBtnHandler()
{
	local string UserName;
	local int parentTabIndex;

	UserName = GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetNameText").GetText();
	// Debug(" №®АЪ јц " @ MemoContents.GetTotalSizeOfText());

	// Debug("ёЮёр АФ·В АЇАъ :" @ userName);
	// Debug("MemoContents.GetString() :" @ MemoContents.GetString());
	// End:0xFA
	if(MemoContents.GetString() != "")
	{
		// ±ЫАЪјц Б¦ЗС 
		// End:0xFA
		if(MemoContents.GetTotalSizeOfText() <= 50)
		{
			parentTabIndex = personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex();
			// End:0xCC
			if(parentTabIndex == 0)
			{
				class'PersonalConnectionAPI'.static.RequestUpdateFriendMemo(UserName, MemoContents.GetString());
				// Debug("RequestUpdateFriendMemo");
			}
			else
			{
				class'PersonalConnectionAPI'.static.RequestUpdateBlockMemo(UserName, MemoContents.GetString());
				// Debug("RequestUpdateBlockMemo");
			}

			// ёЮёр АФ·ВАМ їП·бµЗѕъЅАґПґЩ. ёЮјјБц Гв·В 
			AddSystemMessage(3332);
		}
	}
}

/**
 * ДЮєё №ЪЅє ј±ЕГ 
 * 
 * ёаЖј °Л»ц Lv №ьА§ БцБ¤ 
 **/
function OnComboBoxItemSelected(string strID, int IndexID)
{
	switch(strID)
	{
		// End:0x28
		case "LevelComboBox":
			callMenTeeList(IndexID, 1);
			// End:0x2B
			break;
	}
}

/***
 * ёаЖј ё®ЅєЖ®ё¦ їдГ»ЗСґЩ
 **/
function callMenTeeList(int comboLevelIndex, int nChangePage)
{
	// Debug("comboLevelIndex->" @ comboLevelIndex);
	// Debug("menTeeListCurrentPageCount->" @ menTeeListCurrentPageCount);

	// End:0x1A
	if(nChangePage > menTeeListTotalPage)
	{
		nChangePage = menTeeListTotalPage;
	}
	// End:0x30
	if(nChangePage < 1)
	{
		nChangePage = menTeeListTotalPage;
	}

	// Debug("nChangePage->" @ nChangePage);

	switch(comboLevelIndex)
	{
		// End:0x4C
		case 0:
			RequestMenteeWaitingList(nChangePage, 1, 105);
			// End:0x92
			break;
		// End:0x61
		case 1:
			RequestMenteeWaitingList(nChangePage, 1, 40);
			// End:0x92
			break;
		// End:0x78
		case 2:
			RequestMenteeWaitingList(nChangePage, 41, 84);
			// End:0x92
			break;
		// End:0x8F
		case 3:
			RequestMenteeWaitingList(nChangePage, 85, 104);
			// End:0x92
			break;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ё®ЅєЖ® Е¬ёЇ АМєҐЖ®
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  ё®ЅєЖ® їдјТё¦ Е¬ёЇ ЗЯґЩёй..
 **/ 
function OnClickListCtrlRecord(string ListCtrlID)
{
	// local LVDataRecord record;
	// End:0x14
	if(ListCtrlID == "ClanList")
	{
		// empty
	}
}

/**
 * ё®ЅєЖ® ґхєнЕ¬ёЇ 
 **/
function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local int tabIndex;
	local string tempStr;

	local ChatWnd chatWndScript;
	local LVDataRecord Record;

	// Debug("ґхєн Е¬ёЇ -> " @ ListCtrlID);

	tabIndex = AddWndTab.GetTopIndex();
	// End:0x9A
	if(ListCtrlID == "MenteeList")
	{
		MenteeList.GetSelectedRec(Record);
		tempStr = Record.LVDataList[0].szData;
		// End:0x9A
		if(tempStr != "")
		{
			chatWndScript = ChatWnd(GetScript("ChatWnd"));
			chatWndScript.SetChatEditBox("\"" $ tempStr $ " ");
			//callGFxFunction("ChatMessage","sendWhisper", tempStr);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// АМєҐЖ® -> ЗШґз АМєҐЖ® Гіё® ЗЪµй·Ї
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnEvent(int Event_ID, string param)
{
	// Debug("АОёЖ °ьё® єёБ¶Гў " @ Event_ID);
	// Debug("param: " @ param);

	switch(Event_ID)
	{
		// End:0x15
		case EV_Restart:
			restartHandler();
			// End:0x13D
			break;
		// End:0x2B
		case EV_ReceivePledgeMemberList:
			HandleReceivePledgeMemberList(param);
			// End:0x13D
			break;
		// End:0x33
		case EV_ClanInfo:
		// End:0x59
		case EV_ClanDeleteAllMember:
			// End:0x56
			if(! getInstanceL2Util().isClanV2())
			{
				clanMemberInfoListEmptyHandle();
			}
			// End:0x13D
			break;
		// End:0x61
		case EV_ClanAddMember:
		// End:0x8C
		case EV_ClanAddMemberMultiple:
			// End:0x89
			if(! getInstanceL2Util().isClanV2())
			{
				clanMemberAddedHandle(param);
			}
			// End:0x13D
			break;
		// End:0xB7
		case EV_ClanMemberInfoUpdate:
			// End:0xB4
			if(! getInstanceL2Util().isClanV2())
			{
				clanMemberInfoUpdateHandle(param);
			}
			// End:0x13D
			break;
		// End:0xE2
		case EV_ClanDeleteMember:
			// End:0xDF
			if(! getInstanceL2Util().isClanV2())
			{
				clanMemberRemovedHandle(param);
			}
			// End:0x13D
			break;
		//case EV_InzonePartyHistoryUpdate:
		//	 InzonePartyHistoryUpdateHandler(param);
		//	 break;
		// ёаЖј ґл±вАЪ ё®ЅєЖ® №Ю±в 
		// End:0xF8
		case EV_MenteeWaitingListStart:
			menteeWaitingListStartHandle(param);
			// End:0x13D
			break;
		// End:0x10E
		case EV_MenteeWaitingList:
			menteeWaitingListHandle(param);
			// End:0x13D
			break;
		// End:0x124
		case EV_MenteeWaitingListEnd:
			menteeWaitingListEndHandle(param);
			// End:0x13D
			break;
		// End:0x13A
		case EV_MentorMenteeListStart:
			mentorMenteeListStartHandle(param);
			// End:0x13D
			break;
	}
}

/**
 * ёаЖј ґл±вАЪ ё®ЅєЖ® №Ю±в - start
 **/
function menteeWaitingListStartHandle(string param)
{
	local int currentPageCount;
	local int TotalPage;

	ParseInt(param, "CurPage", currentPageCount);
	ParseInt(param, "TotalPage", TotalPage);
	// End:0x4F
	if (currentPageCount <= 0 || TotalPage <= 0)
	{
		// empty
	}
	else
	{
		menTeeListCurrentPageCount = currentPageCount;
		menTeeListTotalPage = TotalPage;

		// Б¤»уАы, АЫµї АМ¶у°нёй.. ё®ЅєЖ®ё¦ Бцїм°н, ГК±вИ­
		MenteeList.DeleteAllItem();

		// ЖдАМБц Гв·В
		MenteeCount.SetText(menTeeListCurrentPageCount $ "/" $ menTeeListTotalPage);

		// End:0xB9
		if(menTeeListTotalPage <= menTeeListCurrentPageCount)
		{
			ForwardBtn.DisableWindow();
		}
		else
		{
			ForwardBtn.EnableWindow();
		}

		// End:0xE5
		if(menTeeListCurrentPageCount <= 1)
		{
			BackwardBtn.DisableWindow();			
		}
		else
		{
			BackwardBtn.EnableWindow();
		}
	}
}

/**
 * ёаЖј ґл±вАЪ ё®ЅєЖ® №Ю±в - get Info
 **/
function menteeWaitingListHandle(string param)
{
	//MenteeList.add
	local LVDataRecord Record;

	setMenteeMemberRecord(Record, param);

	// ·№ДЪµе ЗСБЩѕї ГЯ°Ў
	MenteeList.InsertRecord(Record);
}

/**
 * ёаЖј ґл±вАЪ ё®ЅєЖ® №Ю±в - End
 **/
function menteeWaitingListEndHandle(string param)
{

}

/***
 * ёаЖјё®ЅєЖ® ·№ДЪµе »эјє 
 **/
function setMenteeMemberRecord(out LVDataRecord Record, string param)
{
	// parse var
	local string Name, levelString;
	local int ClassID, Level, Status;

	Record.LVDataList.Length = 4;

	// parse
	ParseString(param, "Name", Name);
	//ParseString(param, "memo", memo);

	ParseInt(param, "Class", ClassID);
	ParseInt(param, "Level", Level);
	// ЖЇАМЗП°Ф ID°Ў 0АМ ѕЖґПёй БўјУ »уЕВ·О ЖДѕЗЗСґЩ. 	
	// ParseInt(param, "ID"  , status);

	// debug("status" @ status);
	// End:0x75
	if(Status < 1)
	{
		ParseInt(param, "Status", Status);
	}
	// debug("status:" @ status);

	// Б¤И®ЗС ·№є§·О єёї© БЦБц ѕК°н, №ьА§·О єёї©БШґЩ. 
	// End:0xA2
	if(Level >= 1 && Level <= 40)
	{
		// 1~40
		levelString = GetSystemString(2789);
	}
	else if (level >= 41  && level <= 84)
	{
		// 41~84
		levelString = GetSystemString(2790);
	}
	else if (level >= 85  && level <= 104)
	{
		// 85~104
		levelString = GetSystemString(2791);
	}

	// ёаЖј ґл±вАЪ ё®ЅєЖ®ґВ №«Б¶°З їВ¶уАОАО »з¶чёё іСѕо їВґЩ.
	// №«Б¶°З їВ¶уАО »уЕВАО ЕШЅєЖ® Д®¶у 
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].TextColor = util.BrightWhite;
	Record.LVDataList[1].bUseTextColor = true;
	Record.LVDataList[1].TextColor = util.BrightWhite;

	Record.LVDataList[0].szData = Name;

	Record.LVDataList[1].szData = levelString;
	Record.LVDataList[1].textAlignment = TA_CENTER;

	Record.LVDataList[2].szData = string(ClassID);
	Record.LVDataList[2].szTexture = GetClassRoleIconName(ClassID);
	Record.LVDataList[2].HiddenStringForSorting = String(GetClassRoleType(ClassID));

	Record.LVDataList[2].nTextureWidth = 11;
	Record.LVDataList[2].nTextureHeight = 11;

	Record.nReserved1 = 0;	// for additional information
}

/** ё®ЅєЕёЖ® ГК±вИ­ */
function restartHandler()
{
	OnShow();
	clanMemberInfoListEmptyHandle();
}


/**
 *  ДЈ±ё ёс·П ГЯ°Ў 
 **/
function OnAddListBtnClick()
{
	local int tabIndex;
	local string tempStr;
	local int serverNum;
	local string UserName;
	local array<string> arr;

	tabIndex = AddWndTab.GetTopIndex();

	// - ЗцАз ЕЗАЗ »уЕВ- 
	// [АМё§ ГЯ°Ў]
	// End:0x25F
	if(tabIndex == 0)
	{
		// End:0x251
		if(NameEnterEditbox.GetString() != "")
		{
			switch(personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex())
			{
				// End:0x7B
				case 0:
					class'PersonalConnectionAPI'.static.RequestAddFriend(ConvertWorldStrToID(NameEnterEditbox.GetString()));
					// End:0x23D
					break;
				// End:0xD7
				case 1:
					class'PersonalConnectionAPI'.static.RequestAddBlock(ConvertWorldStrToID(NameEnterEditbox.GetString()));
					Debug("on RequestAddBlock" @ ConvertWorldStrToID(NameEnterEditbox.GetString()));
					// End:0x23D
					break;
				// End:0x23A
				case 2:
					// End:0x219
					if(getInstanceUIData().getIsClassicServer())
					{
						Debug("- 주시 등록" @ NameEnterEditbox.GetString());
						// End:0x1B9
						if(IsPlayerOnWorldRaidServer())
						{
							Debug("ConvertWorldStrToID(NameEnterEditbox.GetString()" @ ConvertWorldStrToID(NameEnterEditbox.GetString()));
							Split(ConvertWorldStrToID(NameEnterEditbox.GetString()), "_", arr);
							// End:0x1B6
							if(arr.Length > 1)
							{
								UserName = arr[0];
								serverNum = int(arr[1]);
							}							
						}
						else
						{
							UserName = NameEnterEditbox.GetString();
							serverNum = 0;
						}
						Debug("userName" @ UserName);
						Debug("serverNum" @ string(serverNum));
						API_C_EX_USER_WATCHER_ADD(UserName, serverNum);						
					}
					else
					{
						class'PersonalConnectionAPI'.static.RequestMenteeAdd(NameEnterEditbox.GetString());
					}
					// End:0x23D
					break;
			}
			NameEnterEditbox.SetString("");
		}
		else
		{
			AddSystemMessage(3718);
			// Debug("АМё§ іЦґВµҐ °ш№йАМ АЦґЩ. ");
		}
	}
	// [ЗчёН ёс·П]
	else if (tabIndex == 1)
	{
		tempStr = ConvertWorldStrToID(getUserNameByList());
		// End:0x3F7
		if(tempStr != "")
		{
			switch (personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex())
			{
				// End:0x2BD
				case 0:
					class'PersonalConnectionAPI'.static.RequestAddFriend(tempStr);
					// End:0x3F4
					break;
				// End:0x2FB
				case 1:
					class'PersonalConnectionAPI'.static.RequestAddBlock(tempStr);
					Debug("c_on RequestAddBlock" @ tempStr);
					// End:0x3F4
					break;
				// End:0x3F1
				case 2:
					// End:0x3DA
					if(getInstanceUIData().getIsClassicServer())
					{
						Debug("혈맹에 있는 주시 등록" @ tempStr);
						// End:0x384
						if(IsPlayerOnWorldRaidServer())
						{
							Split(ConvertWorldStrToID(tempStr), "_", arr);
							// End:0x381
							if(arr.Length > 1)
							{
								UserName = arr[0];
								serverNum = int(arr[1]);
							}
						}
						else
						{
							UserName = tempStr;
							serverNum = 0;
						}
						Debug("userName" @ UserName);
						Debug("serverNum" @ string(serverNum));
						API_C_EX_USER_WATCHER_ADD(UserName, serverNum);
					}
					else
					{
						class'PersonalConnectionAPI'.static.RequestMenteeAdd(tempStr);
					}
					// End:0x3F4
			}
		}
		else
		{
			// ёс·ПА» ј±ЕГЗП¶уґВ ёЮјјБц Гв·В 
			AddSystemMessage(3314);	
		}
	}
	// [АОБё АМ·В]
	else if (tabIndex == 2)
	{		
		// debug("--selectTreeNodeStr" @ selectTreeNodeStr);
		// End:0x48F
		if (selectTreeNodeStr != "")
		{
			switch (personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex())
			{
				case 0:
					class'PersonalConnectionAPI'.static.RequestAddFriend(selectTreeNodeStr);
					// End:0x48C
					break;
				// End:0x46D
				case 1:
					class'PersonalConnectionAPI'.static.RequestAddBlock(selectTreeNodeStr);
					// End:0x48C
					break;
				// End:0x489
				case 2:
					class'PersonalConnectionAPI'.static.RequestMenteeAdd(selectTreeNodeStr);
					// End:0x48C
					break;
			}
		}
		else
		{
			// ёс·ПА» ј±ЕГЗП¶уґВ ёЮјјБц Гв·В 
			AddSystemMessage(3314);	
		}
		// Debug("АОБё ёс·П ГЯ°Ў: ");
	}
}

/***
 *  ґЭ±в №цЖ° Е¬ёЇ 
 **/
function OnCloseBtnClick()
{
	Me.HideWindow();
}

//ЗчёН ё®ЅєЖ® №ЮѕТА»¶§ Гіё®
function HandleReceivePledgeMemberList(string param)
{
	local int Num;
	local int i;
	local string strName;
	local int ClanClass;
	local int ClanLevel;
	local int logon;
	local LVDataRecord Record;
	local array<String> AddName;

	// End:0x17
	if(! getInstanceL2Util().isClanV2())
	{
		return;
	}
	ParseInt(param, "Num", Num);

	ClanList.DeleteAllItem();

	// End:0x3A5 [Loop If]
	for(i = 0; i < Num ; i++)
	{
		ParseString(Param, "Name"$i, strName);
		ParseInt(Param, "FriendClass"$i, ClanClass);
		ParseInt(Param, "FriendLevel"$i, ClanLevel);
		ParseInt(Param, "FriendLogon"$i, logon);

		//debug("ДЈ±ё Name--->> " $ strName);
		//debug("ДЈ±ё ClanClass--->> " $ string(ClanClass));
		//debug("ДЈ±ё ClanLevel--->> " $ string(ClanLevel));
		
		AddName[i] = strName;

		Record.LVDataList.Length = 4;
		// End:0x177
		if(logon > 0)
		{
			// їАЗБ¶уАО АП¶§ »ц №ЩІЮ
			Record.LVDataList[0].bUseTextColor = true;
			Record.LVDataList[0].TextColor = util.BrightWhite;
			Record.LVDataList[1].bUseTextColor = true;
			Record.LVDataList[1].TextColor = util.BrightWhite;
		}
		else
		{
			// їАЗБ¶уАО АП¶§ »ц №ЩІЮ
			Record.LVDataList[0].bUseTextColor = true;
			Record.LVDataList[0].TextColor = util.White;
			Record.LVDataList[1].bUseTextColor = true;
			Record.LVDataList[1].TextColor = util.White;
		}

		Record.LVDataList[0].szData = ConvertWorldIDToStr(strName);
		Record.LVDataList[0].szReserved = strName;
		Record.LVDataList[1].szData = string(ClanLevel);
		Record.LVDataList[2].szTexture = GetClassRoleIconName(ClanClass);
		Record.LVDataList[2].nTextureWidth = 11;
		Record.LVDataList[2].nTextureHeight = 11;
		Record.LVDataList[2].szData = String(ClanClass);
		Record.LVDataList[2].HiddenStringForSorting = String(GetClassRoleType(ClanClass));

		Record.LVDataList[3].nTextureWidth = 31;
		Record.LVDataList[3].nTextureHeight = 11;

		// ЗчёН ёЙ№ц БўјУ »уЕВ on, off 
		// End:0x336
		if(logon > 0)
		{
			Record.LVDataList[3].szData = "1";			// ѕµёр ѕшґВ µҐАМЕНБцёё јТЖГА» А§ЗШј­ іЦґВґЩ
			Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
		}
		else
		{
			Record.LVDataList[3].szData = "0";
			Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
		}

		ClanList.InsertRecord(Record);
	}
}

// ЗчёН ёЙ№ц °ь·Г ё®ЅєЖ® ДБЖ®·Сїл, ·№ДЪµе јј?
function setClanMemberRecord(out LVDataRecord Record, string param)
{
	// parse var
	local string Name;
	local int ClassID, Level, Status;

	Record.LVDataList.Length = 4;

	// parse
	ParseString(param, "Name", Name);
	//ParseString(param, "memo", memo);

	ParseInt(param, "Class", ClassID);
	ParseInt(param, "Level", Level);
	// ЖЇАМЗП°Ф ID°Ў 0АМ ѕЖґПёй БўјУ »уЕВ·О ЖДѕЗЗСґЩ. 	
	ParseInt(param, "ID", Status);

	// debug("status" @ status);
	// End:0x89
	if(Status < 1)
	{
		ParseInt(param, "Status", Status);
	}
	// debug("status:" @ Status);

	// set 
	// End:0xFF
	if(Status > 0)
	{
		// їАЗБ¶уАО АП¶§ »ц №ЩІЮ
		Record.LVDataList[0].bUseTextColor = true;
		Record.LVDataList[0].TextColor = util.BrightWhite;
		Record.LVDataList[1].bUseTextColor = true;
		Record.LVDataList[1].TextColor = util.BrightWhite;
	}
	else
	{
		// їАЗБ¶уАО АП¶§ »ц №ЩІЮ
		Record.LVDataList[0].bUseTextColor = true;
		Record.LVDataList[0].TextColor = util.White;
		Record.LVDataList[1].bUseTextColor = true;
		Record.LVDataList[1].TextColor = util.White;
	}

	Record.LVDataList[0].szData = ConvertWorldIDToStr(Name);
	Record.LVDataList[0].szReserved = Name;

	Record.LVDataList[1].szData = string(Level);
	Record.LVDataList[2].szData = string(ClassID);		// ѕµёр ѕшґВ µҐАМЕНБцёё јТЖГА» А§ЗШј­ іЦґВґЩ
	Record.LVDataList[2].szTexture = GetClassRoleIconName(ClassID);
	Record.LVDataList[2].HiddenStringForSorting = String(GetClassRoleType(ClassID));

	Record.LVDataList[2].nTextureWidth = 11;
	Record.LVDataList[2].nTextureHeight = 11;

	Record.LVDataList[3].nTextureWidth = 31;
	Record.LVDataList[3].nTextureHeight = 11;
	Record.nReserved1 = 0;	// for additional information

	// ЗчёН ёЙ№ц БўјУ »уЕВ on, off 
	// End:0x2CC
	if(Status > 0)
	{
		Record.LVDataList[3].szData = "1";			// ѕµёр ѕшґВ µҐАМЕНБцёё јТЖГА» А§ЗШј­ іЦґВґЩ
		Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
	}
	else
	{
		Record.LVDataList[3].szData = "0";
		Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
	}
}

// ЗчёН ёЙ№ц ГЯ°Ў ЗЪµй
function clanMemberAddedV2Handle(string param)
{
	local LVDataRecord Record;

	setClanMemberRecord(Record, param);

	// ·№ДЪµе ЗСБЩѕї ГЯ°Ў
	ClanList.InsertRecord(Record);
	// Debug("ЗчёН ёЙ№ц ё®ЅєЖ® ГЯ°Ў !: ");
}

// ЗчёН ёЙ№ц ГЯ°Ў ЗЪµй
function clanMemberInfoListEmptyHandle()
{
	// ЗчёН ёЙ№ц ё®ЅєЖ® »иБ¦
	ClanList.DeleteAllItem();
	//Debug("ЗчёН ёЙ№ц ё®ЅєЖ® »иБ¦!");
}

// ЗчёН ёЙ№ц ГЯ°Ў ЗЪµй
function clanMemberAddedHandle(string param)
{
	local LVDataRecord Record;

	setClanMemberRecord(Record, param);

	// ·№ДЪµе ЗСБЩѕї ГЯ°Ў
	ClanList.InsertRecord(Record);
	// Debug("ЗчёН ёЙ№ц ё®ЅєЖ® ГЯ°Ў !: ");
}

// ЗчёН ёЙ№ц »иБ¦ ЗЪµй
function clanMemberRemovedHandle(string param)
{
	local string Name;
	local int i;

	// parse
	ParseString(param, "Name", Name);

	i = util.ctrlListSearchByName(ClanList, ConvertWorldIDToStr(Name));
	// End:0x5E
	if(i != -1)
	{
		ClanList.DeleteRecord(i);
	}
}

// ЗчёН ёЙ№ц Б¤єё ѕчµҐАМЖ®
function clanMemberInfoUpdateHandle(string param)
{
	local LVDataRecord Record;
	local LVDataRecord tempRecord;
	local string Name;
	local int i;

	// parse
	ParseString(param, "Name", Name);

	setClanMemberRecord(Record, param);

	// End:0xA6 [Loop If]
	for (i = 0; i < ClanList.GetRecordCount(); i++)
	{
		ClanList.GetRec(i, tempRecord);
		// End:0x9C
		if(tempRecord.LVDataList[0].szData == ConvertWorldIDToStr(Name))
		{
			// ЗчёН ёЙ№ц »иБ¦
			ClanList.ModifyRecord(i, Record);
			// Debug("ЗчёН ёЙ№ц ё®ЅєЖ® јцБ¤ !: " @ Name);
			break;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  АОБё ёЙ№ц - АМєҐЖ®їЎ µыёҐ Гіё® 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 0№ш єОЕН ...  №шИЈ·О ±ёјє
//
// ЖДЖјїЎј­ АОБё ИчЅєЕдё® ЗЪµй 
function InzonePartyHistoryUpdateHandler(string param)
{
	local string strRetName;
	local string treeName, ROOTNAME;

	local int NumberOfInzoneParty, NumberOfPartyMember,  InzoneTypeID, InzoneUseTimeYear, InzoneUseTimeMonth, InzoneUseTimeDay;
	local int InzoneClassID, InzoneStatus;

	local int inzoneCount, PartyMemberCount;

	local string inzoneName, inzoneMemberName, listName, inzoneDate;

	// Debug("--- АОБё ---" @ param);

	treeName = "PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd.InzoneTree";
	ROOTNAME = "root";

	// End:0x71
	if(selectTreeNodeStr != "")
	{
		InzoneTree.SetExpandedNode(selectTreeNodeStr, false);
	}
	// End:0x92
	if(beforeSelectedTreePath != "")
	{
		InzoneTree.SetExpandedNode(beforeSelectedTreePath, false);
	}
	InzoneTree.Clear();
	listName = "";
	inzoneName = "";
	inzoneDate = "";
	inzoneMemberName = "";	
	inzoneSelectedParam = "";	
	// beforeSelectedTreePath = "";
	// selectTreeNodeStr = "";

	// parse
	ParseInt(param, "NumberOfInzoneParty", NumberOfInzoneParty);
	
	// root ёёµл
	util.TreeInsertRootNode(treeName,  ROOTNAME, "", 0, 4);

	// АОБё Б¤єё, ёЙ№ц ё®ЅєЖ® Б¤єё ѕт±в
	// End:0x5C2 [Loop If]
	for (inzoneCount = 0; inzoneCount < NumberOfInzoneParty; inzoneCount++)
	{
		ParseInt(param, "NumberOfPartyMember" $ inzoneCount, NumberOfPartyMember);

		ParseInt(param, "InzoneUseTimeYear" $ inzoneCount, InzoneUseTimeYear);
		ParseInt(param, "InzoneUseTimeMonth" $ inzoneCount, InzoneUseTimeMonth);
		ParseInt(param, "InzoneUseTimeDay" $ inzoneCount, InzoneUseTimeDay);

		ParseInt(param, "InzoneTypeID" $ inzoneCount, InzoneTypeID);

		// Debug("::" @ NumberOfInzoneParty);
		// Debug("::" @ NumberOfPartyMember);
		// Debug("::" @ InzoneUseTime);
		// Debug("::" @ InzoneTypeID);
		// Debug("inzoneCount:" @ inzoneCount);
		
		// 1ён АМ»у АМ¶уёй + ілµе »эјє
		// End:0x2EA
		if(NumberOfInzoneParty > 0)
		{
			listName = "list" $ string(inzoneCount);
			// debug("1.listName : " @ listName);
			inzoneName = GetInZoneNameWithZoneID(InzoneTypeID);
			inzoneDate ="(" $ MakeFullSystemMsg(GetSystemMessage(2203), string(InzoneUseTimeMonth), string(InzoneUseTimeDay)) $ ")";
			// 2201
			//inzoneName = inzoneName + 
			util.TreeInsertExpandBtnNode(treeName, listName, ROOTNAME);

			listName = ROOTNAME $ "." $ listName;
			// debug("2.listName : " @ listName);
			// ЅЙї¬АЗ №М±Г °°Ає..  ±Ыѕѕ 
			util.TreeInsertTextNodeItem(treeName, listName, inzoneName, 5, 0, util.ETreeItemTextType.COLOR_DEFAULT, true);
			util.TreeInsertTextNodeItem(treeName, listName, inzoneDate, 5, 0, util.ETreeItemTextType.COLOR_GOLD, true);

			// Debug(":inzoneName:" @ inzoneName);

		}

		// Debug("NumberOfPartyMember: " @ NumberOfPartyMember);

		// °ў АОБёА» ЗФІІЗС ёЙ№ц ё®ЅєЖ®
		// End:0x5B8 [Loop If]
		for(PartyMemberCount = 0; partyMemberCount < NumberOfPartyMember; PartyMemberCount++)
		{
			ParseString(param, "Inzone" $ inzoneCount $ "_Name" $ PartyMemberCount, inzoneMemberName);
			ParseInt(param, "Inzone" $ inzoneCount $ "_ClassID" $ PartyMemberCount, InzoneClassID);
			ParseInt(param, "Inzone" $ inzoneCount $ "_Status"  $ PartyMemberCount, InzoneStatus);

			// Debug("inzoneMemberName:" @ inzoneMemberName);
			// Debug("InzoneClassID:" @ InzoneClassID);
			// Debug("InzoneStatus:" @ InzoneStatus);

			util.setCustomTooltip(getJobToolTip(InzoneClassID));
			//util.ToopTipMinWidth(200);

			// ілµе »эјє 
			strRetName = util.TreeInsertItemTooltipNode(treeName, "member" $ PartyMemberCount, listName, -7, 0, 20, 0, 32, 20, util.getCustomToolTip());

			inzoneSelectedParam = inzoneSelectedParam $ " " $ strRetName $ "=" $ inzoneMemberName;
			// ёЙ№ц, №и°ж, ЕШЅєГД , (БшЗС°Е , И¦В¦)
			// End:0x481
			if((PartyMemberCount % 2) == 0)
			{
				util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.etc.textbackline", 257, 18, 16, 0,,, 14);
			}
			else
			{
				util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", 257, 18, 16, 0,,, 14);
			}

			// Бчѕч (Е¬·ЎЅє)
			util.TreeInsertTextureNodeItem(treeName, strRetName, GetClassRoleIconName(InzoneClassID), 11, 11, -108, 3);
			// End:0x540
			if(InzoneStatus > 0)
			{
				// БўјУ »уЕВ on
				util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.BloodHoodWnd.BloodHood_Logon", 31, 11, 25, 3);
			}
			else
			{
				// БўјУ »уЕВ off 
				util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff", 31, 11, 25, 3);
			}

			// ДіёЇЕН АМё§ 
			util.TreeInsertTextNodeItem(treeName, strRetName, inzoneMemberName, -211, 2);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  АОёЖ °ь·Г °шїл ЗФјц 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* ЗцАз ј±ЕГµЗѕоБш ё®ЅєЖ®їЎј­ АМё§ ЅєЖ®ёµА» ё®ЕПЗСґЩ. */
function string getUserNameByList()
{
	local LVDataRecord Record;

	local int tabIndex;
	local int SelectedIndex;
	local string returnStr;

	returnStr = "";
	tabIndex = AddWndTab.GetTopIndex();

	// - ЗцАз ЕЗАЗ »уЕВ- 
	// [ЗчёН ёс·П]
	// End:0x7A
	if(tabIndex == 1)
	{
		// ёс·ПАМ ЗПіЄ¶уµµ ј±ЕГµЗѕъґЩёй..
		SelectedIndex = ClanList.GetSelectedIndex();
		// End:0x77
		if(SelectedIndex != -1)
		{
			ClanList.GetSelectedRec(Record);
			returnStr = Record.LVDataList[0].szData;
		}
	}
	// [АОБё АМ·В]
	else if (tabIndex == 2)
	{	
		// Debug("АОБё..");
	}
    else 
    {
		// ЅГЅєЕЫ ёЮјјБц Гв·В
		// ёс·ПА» ј±ЕГЗШ!
		AddSystemMessage(3314);	
    }

	return returnStr;
}

/**
 *  ЗПіЄАЗ А©µµїмё¦ ї­ѕо БШґЩ.
 **/
function showSelectWindow(string WindowName)
{
	// ёрµО јы±в°н..
	AddWnd.HideWindow();
	NameEnterWnd.HideWindow();
	ClanListWnd.HideWindow();
	InzoneTreeWnd.HideWindow();
	DetailInfoWnd.HideWindow();
	MenteeSearchWnd.HideWindow();

	AddListBtn.ShowWindow();
	CloseBtn.ShowWindow();

	// Debug("Гў ї­±в ----> " @ windowName);
	switch(WindowName)
	{
		// End:0xBC
		case "AddWnd":
			AddWnd.ShowWindow();
			AddWndTab.SetTopOrder(0, false);
			NameEnterEditbox.SetFocus();
			// End:0x171
			break;
		// End:0xDF
		case "NameEnterWnd":
			NameEnterWnd.ShowWindow();
			// End:0x171
			break;
		// End:0x112
		case "ClanListWnd":
			ClanListWnd.ShowWindow();
			AddWndTab.SetTopOrder(1, false);
			// End:0x171
			break;
		// End:0x136
		case "DetailInfoWnd":
			DetailInfoWnd.ShowWindow();
			// End:0x171
			break;
		// End:0x16E
		case "MenteeSearchWnd":
			MenteeSearchWnd.ShowWindow();
			AddWndTab.SetTopOrder(2, false);
			// End:0x171
			break;
	}

	// ЕЗ АМё§ єЇ°ж
	switch(personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex())
	{
		// End:0x18F
		case 0:
		// End:0x1F1
		case 1:
			// End:0x1DC
			if(getInstanceUIData().getIsClassicServer())
			{
				AddWndTab.InitTabCtrl();
				AddWndTab.RemoveTabControl(2);
				AddListTabBgLine.SetWindowSize(100, 24);
			}
			else
			{
				AddWndTab.SetDisable(2, true);
			}
			// End:0x2A5
			break;
		// End:0x2A2
		case 2:
			Debug("주시 옵션 처리" @ string(personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex()));
			// End:0x271
			if(getInstanceUIData().getIsClassicServer())
			{
				AddWndTab.InitTabCtrl();
				AddWndTab.RemoveTabControl(2);
				AddListTabBgLine.SetWindowSize(100, 24);				
			}
			else
			{
				AddWndTab.SetButtonName(2, GetSystemString(2784));
				AddWndTab.SetDisable(2, false);
			}
			// End:0x2A5
			break;
	}
}

/**
 *  »ујј Б¤єё јјЖГ 
 **/
function setDetailInfo(string Name, int Level, int ClassID, int PledgeCrestID, int AllianceCrestID, int birthMonth, int birthDay, int logoutDiffSeconds, string memo)
{
	// ЗчёН , µїёН ЕШЅєГД
	local Texture texPledge, texAlliance;

	local string PledgeName, allianceName;

	// Е¬·ЎЅє ЕёАФ 
	local string classTypeStr;

	local bool bPledge, bAlliance;
	local Rect rectWnd;

	rectWnd = DetailInfoWnd.GetRect();

	// АМё§ 
	GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetNameText").SetText(Name);

	// єн·° АЇАъ Б¤єё єё±вАО °жїм 
	// End:0x48F
	if((Level + ClassID + PledgeCrestID + AllianceCrestID + birthMonth + birthDay + logoutDiffSeconds) == 0)
	{
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BlockInfoText").ShowWindow();

		// Set textbox 
		// GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetNameText").SetText("");
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetStatusText").SetText(GetSystemString(2394));
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Level").SetText("");

		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.job").SetText("");
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").SetText("");
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").SetText("");

		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BirthDay").SetText("");
		
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnect").SetText("");

		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.LevelTitle").HideWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.JobTitle").HideWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.ClanTitle").HideWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.UnionTitle").HideWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BirthDayTitle").HideWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnectTitle").HideWindow();
	}
	else
	{
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BlockInfoText").HideWindow();

		// Debug("pledgeCrestId : " @ pledgeCrestId);
		// Debug("allianceCrestId : " @ allianceCrestId);
		// ЗчёН, µїёН АМё§ 
		PledgeName = class'UIDATA_CLAN'.static.GetName(PledgeCrestID);
		allianceName = class'UIDATA_CLAN'.static.GetAllianceName(PledgeCrestID);

		// Debug("pledgeName :" @ pledgeName);
		// Debug("allianceName :" @ allianceName);
		
		// ЕШЅєГД
		texPledge = GetPledgeCrestTexFromPledgeCrestID(PledgeCrestID);
		texAlliance = GetAllianceCrestTexFromAllianceCrestID(AllianceCrestID);

		// Е¬·ЎЅє ЕёАФ 
		classTypeStr = GetClassType(ClassID);

		// ЗчёН µїёН, АМ№МБц ѕтѕоїА±в 
		bPledge = class'UIDATA_CLAN'.static.GetCrestTexture(PledgeCrestID, texPledge);
		bAlliance = class'UIDATA_CLAN'.static.GetAllianceCrestTexture(PledgeCrestID, texAlliance);
		Debug("인맥 혈맹 마크 로드 확인 중 ------------ " @ texPledgeCrest.GetWindowName() @ string(bPledge) @ string(PledgeCrestID));
		texPledgeCrest.SetTextureWithObject(texPledge);
		texPledgeAllianceCrest.SetTextureWithObject(texAlliance);

		texPledgeCrest.HideWindow();
		texPledgeAllianceCrest.HideWindow();

		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").ClearAnchor();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").ClearAnchor();
		// ЗчёН, µїёН ЕШЅєГД 
		// End:0x6C5
		if(bPledge)
		{
			texPledgeCrest.ShowWindow();
			// End:0x72D
			if(getInstanceUIData().getIsClassicServer())
			{
				GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").MoveTo(rectWnd.nX + 126, (rectWnd.nY + 156) + 4);
			}
			else
			{
				GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").MoveTo(rectWnd.nX + 118, (rectWnd.nY + 156) + 4);
			}
		}
		else
		{
			texPledgeCrest.HideWindow();
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").MoveTo(rectWnd.nX + 98, (rectWnd.nY + 156) + 4);
		}

		// End:0x7B2
		if(bAlliance)
		{
			texPledgeAllianceCrest.ShowWindow();
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").MoveTo(rectWnd.nX + 110, (rectWnd.nY + 178) + 4);			
		}
		else
		{
			texPledgeAllianceCrest.HideWindow();
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").MoveTo(rectWnd.nX + 98, (rectWnd.nY + 178) + 4);
		}
		
		// Set textbox 		
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Level").SetText(string(Level));

		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.job").SetText(classTypeStr);
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").SetText(PledgeName);
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").SetText(allianceName);

		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BirthDay").SetText(MakeFullSystemMsg(GetSystemMessage(2203), string(birthMonth), string(birthDay)));

		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.LevelTitle").ShowWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.JobTitle").ShowWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.ClanTitle").ShowWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.UnionTitle").ShowWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BirthDayTitle").ShowWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnectTitle").ShowWindow();
		
		// Debug("logoutDiffSeconds :" @ logoutDiffSeconds);
		// End:0xC11
		if(logoutDiffSeconds <= -1)
		{
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetStatusText").SetText(GetSystemString(347));
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnect").SetText(GetSystemString(2401));
		}
		else
		{
			// ЗцАз БўјУБЯ
			// ЗШґз АЇАъ°Ў БўјУБЯАО °жїм..
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetStatusText").SetText(GetSystemString(348));
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnect").SetText(getConnectInfoTimeMessage(logoutDiffSeconds / 60));
		}
	}

	/*
		native static function string GetName(int ID);
		native static function string GetAllianceName(int ID);
		native static function bool GetCrestTexture(int ID, out texture texCrest);
		native static function bool GetEmblemTexture(int ID, out texture emblemTexture);
		native static function bool GetAllianceCrestTexture(int ID, out texture texCrest);
		native static function bool	GetNameValue(int ID, out int namevalue);
		native static function RequestClanInfo();		// АьГј ЗчёН Б¤єёё¦ ГК±вИ­ ЗП°н »х·О Е¬¶уАМѕрЖ®їЎј­ Б¤єёё¦ єёі» БШґЩ.
		native static function RequestClanSkillList();
		native static function RequestSubClanSkillList(int subClanIndex);
		native static function int GetSkillLevel(int skillID);
		native static function int GetSubClanSkillLevel(int skillID, int subClanIndex);
	 */
	
	// Debug("ј­№цїЎј­їВ memo MemoContents.SetString(memo) -> " @ memo);
	
	// ёЮёр
	MemoContents.SetString(memo);
}

/**  БўјУ Б¤єё ЅєЖ®ёµ ё®ЕП , єРА» АФ·В -> ЗцАз БўјУБЯ.. ~ЅГ°Ј,  єРАь ЅГ°Ј Аь АП Аь °іїщ Аь ів АМ»у.. АМ·±ЅДАё·О ЗҐЗц */
function string getConnectInfoTimeMessage(int Minute)
{
	local string returnStr;
	local int Value;

	returnStr = "";

	// 3294	$s1єР Аь
	// End:0x35
	if(Minute < 60)
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3294), string(Minute));
	}
	// 3295	$s1ЅГ°Ј Аь
	else if (Minute < (60 * 24))
	{
		Value = Minute / 60;
		returnStr = MakeFullSystemMsg(GetSystemMessage(3295),string(Value));
	}

	// 3296	$s1АП Аь
	else if (Minute < (60 * 24 * 30))
	{
		Value = Minute / 60 / 24;
		returnStr = MakeFullSystemMsg(GetSystemMessage(3296), string(value));
	}
	// 3297	$s1°іїщ Аь
	else if (Minute < (60 * 24 * 365))
	{
		Value = Minute / 60 / 24 / 30;
		returnStr = MakeFullSystemMsg(GetSystemMessage(3297), string(value));
	}
	// 3298	$s1ів АМ»у
	else if (Minute > (60 * 24 * 365))
	{
		Value = Minute / 60 / 24 / 30;
		returnStr = MakeFullSystemMsg(GetSystemMessage(3297), string(value));
	}

	return returnStr;
}

/**
 *  ЕшЖБ ,Бчѕч Б¤єё
 */
function CustomTooltip getJobToolTip(int Job)
{
	local CustomTooltip m_Tooltip;

	m_Tooltip.DrawList.Length = 1;
	m_Tooltip.DrawList[0].eType = DIT_TEXT;
	m_Tooltip.DrawList[0].t_strText = GetSystemString(391) $ " : " $ GetClassType(Job);

	return m_Tooltip;
}

function API_C_EX_USER_WATCHER_ADD(string sTargetName, int nTargetWorldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_USER_WATCHER_ADD packet;

	packet.sTargetName = sTargetName;
	packet.nTargetWorldID = nTargetWorldID;
	// End:0x40
	if(! class'UIPacket'.static.Encode_C_EX_USER_WATCHER_ADD(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_USER_WATCHER_ADD, stream);
	Debug(("----> Api Call : C_EX_USER_WATCHER_ADD" @ sTargetName) @ string(nTargetWorldID));
}

/**
 * А©µµїм ESC Е°·О ґЭ±в Гіё® 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("PersonalConnectionsDrawerWnd").HideWindow();
}

defaultproperties
{
}
