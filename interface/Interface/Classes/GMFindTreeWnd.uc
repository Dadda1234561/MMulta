class GMFindTreeWnd extends UICommonAPI;

var WindowHandle Me;
//var array<String> m_ComboList;
var string m_WindowName;
//var bool bSummon;
var bool bShow;	// GMâ���� ��ư�� �ѹ� �� ������ ������� �ϱ� ���� ����
var Color Gold;

var ListCtrlHandle m_hFindTreeList;

//var EditBoxHandle	m_hEdSummonCnt;

var EditBoxHandle m_hEditBox;

var ComboBoxHandle m_hComboBox;

var ButtonHandle m_hBtnSummon;

var CheckBoxHandle m_checkbox64size;
var CheckBoxHandle m_unLimitCheckBox;

const ASK_SUMMON_NUMBER = 10000;

enum EListType
{
	LISTTYPE_ITEM,
	LISTTYPE_NPC,
	LISTTYPE_QUEST,
	LISTTYPE_SKILL,
	LISTTYPE_CLASS,
	LISTTYPE_SYSTEMSTRING,
	LISTTYPE_SYSTEMMESSAGE
};

var EListType curListType;

var WindowHandle m_GMFindTreeWndItem;

/*
enum ESummontype
{
	SUMMONTYPE_None,
	SUMMONTYPE_SKill,
	SUMMONTYPE_Quest,
	SUMMONTYPE_SYSTEMSTRING,
	SUMMONTYPE_SYSTEMMESSAGE,
};
*/

//var ESummontype SummonType;

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
}

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("GMFindTreeWnd");
	m_hFindTreeList = GetListCtrlHandle(m_WindowName $ ".ListFindWnd");
//	m_hEdSummonCnt = GetEditBoxHandle(m_WindowName$".edSummonCnt");
	m_checkbox64size = GetCheckBoxHandle(m_WindowName $ ".ChkBox64");
	m_unLimitCheckBox = GetCheckBoxHandle(m_WindowName $ ".unLimitCheckBox");
	m_hEditBox = GetEditBoxHandle(m_WindowName$".EditBox");

	m_hComboBox = GetComboBoxHandle(m_WindowName$".ComboBox");

	m_hBtnSummon = GetButtonHandle(m_WindowName$".btnSummon");

	// ���ؿ��� ���� api , ������ Ŭ�� �� ������ �ص� ���̵���
	m_hFindTreeList.SetSelectedSelTooltip(false);
	m_hFindTreeList.SetAppearTooltipAtMouseX(true);

	//bSummon = false;
	//SummonType = SUMMONTYPE_None;
	bShow = false;

	Gold.R = 176;
	Gold.G = 153;
	Gold.B = 121;

	FillOutComboBoxHandle();

	m_GMFindTreeWndItem = GetWindowHandle("GMFindTreeWndItem");
	GetTextureHandle("GMFindTreeWnd.Texture64").SetTextureSize(64, 64);
	GetTextureHandle("GMFindTreeWnd.Texture48").SetTextureSize(64, 64);
	GetTextureHandle("GMFindTreeWnd.Texture32").SetTextureSize(64, 64);
	GetTextureHandle("GMFindTreeWnd.Texture24").SetTextureSize(64, 64);
	GetTextureHandle("GMFindTreeWnd.Texture16").SetTextureSize(64, 64);
}

function FillOutComboBoxHandle()
{
	m_hComboBox.Clear();
	m_hComboBox.AddStringWithReserved(GetSystemString(691), EListType.LISTTYPE_ITEM);
	m_hComboBox.AddStringWithReserved(GetSystemString(690), EListType.LISTTYPE_NPC);
	m_hComboBox.AddStringWithReserved(GetSystemString(699), EListType.LISTTYPE_QUEST);
	m_hComboBox.AddStringWithReserved(GetSystemString(692), EListType.LISTTYPE_SKILL);
	m_hComboBox.AddStringWithReserved(GetSystemString(2290), EListType.LISTTYPE_CLASS);
	m_hComboBox.AddStringWithReserved("SystemString", EListType.LISTTYPE_SYSTEMSTRING);
	m_hComboBox.AddStringWithReserved("SystemMessage", EListType.LISTTYPE_SYSTEMMESSAGE);
}

function OnShow()
{
	if(m_checkbox64size.IsChecked())
	{
		Me.SetWindowSize(369, 628);
	} else {
		Me.SetWindowSize(369, 558);
	}
}

function OnHide()
{
	m_GMFindTreeWndItem.HideWindow();
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
	local string EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	//Debug( "OnComboBoxItemSelected" @ EListType ( IndexID ) );
	switch(strID)
	{
		case "ComboBox":
			ShowList(EditBoxString, EListType(IndexID));
			break;
	}
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case EV_DialogOK:
			HandleDialogOK();
			break;
		case EV_DialogCancel:
			break;
	}
}

function ShowList(string a_Param, EListType listType)
{
	Me.HideWindow();

	curListType = listType;
	m_hEditBox.SetString(a_Param);

	m_hComboBox.SetSelectedNum(curListType);

	m_hBtnSummon.DisableWindow();

	switch(curListType)
	{
		case LISTTYPE_ITEM:
			FindAllItem(a_Param);

			if(!m_GMFindTreeWndItem.IsShowWindow())
			{
				m_GMFindTreeWndItem.ShowWindow();
			}

			//SummonType = SUMMONTYPE_None;
			//bSummon = true;
			//m_hBtnSummon.EnableWindow();
			break;
		case LISTTYPE_QUEST:
			FindAllQuest(a_Param);
			m_GMFindTreeWndItem.HideWindow();
			//SummonType = SUMMONTYPE_Quest;
			//bSummon = true;
			//m_hBtnSummon.DisableWindow();
			break;
		case LISTTYPE_NPC:
			FindAllNPC(a_Param);
			m_GMFindTreeWndItem.HideWindow();
			//SummonType = SUMMONTYPE_None;
			//bSummon = true;
			//m_hBtnSummon.EnableWindow();
			break;
		case LISTTYPE_SKILL:
			FindAllSkill(a_Param);
			m_GMFindTreeWndItem.HideWindow();
			//SummonType = SUMMONTYPE_Skill;
			//bSummon = true;
			//m_hBtnSummon.DisableWindow();
			break;
		case LISTTYPE_CLASS:
			FindAllCLASS(a_Param);
			m_GMFindTreeWndItem.HideWindow();
			break;
		case LISTTYPE_SYSTEMSTRING:
			FindAllSystemString(a_Param);
			m_GMFindTreeWndItem.HideWindow();
			//SummonType = SUMMONTYPE_SYSTEMSTRING;
			//bSummon = false;
			//m_hBtnSummon.DisableWindow();
			break;
		case LISTTYPE_SYSTEMMESSAGE:
			FindAllSystemMessage(a_Param);
			m_GMFindTreeWndItem.HideWindow();
			//SummonType = SUMMONTYPE_SYSTEMMESSAGE;
			//bSummon = false;
//			m_hBtnSummon.DisableWindow();
			break;
	}

	Me.ShowWindow();
	Me.SetFocus();
}

function FindAllCLASS(string a_Param)
{
	local int classIndex;
	local string fullNameString;

	ClearList();

	for(classIndex = 0; classIndex < 500; classIndex++)
	{
		fullNameString = GetSystemString(class'UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(classIndex));

		if(fullNameString != "")
		{
			if(InsertRecordFindTreeList(fullNameString, a_Param, classIndex, GetClassRoleIconName(classIndex)) == 1000)
			{
				AddSystemMessage(3489);
				return;
			}
		}
	}
}

function FindAllSystemString(string a_Param)
{
	local int i;
	local string fullNameString;

	ClearList();

	for(i = 0; i < 20000; i++)
	{
		fullNameString = GetSystemString(i);

		if(fullNameString != "")
		{
			if(InsertRecordFindTreeList(fullNameString, a_Param, i, "") == 1000)
			{
				AddSystemMessage(3489);
				return;
			}
		}
	}
}

function FindAllSystemMessage(string a_Param)
{
	local int i;
	local string fullNameString;

	ClearList();

	for(i = 0; i < 20000; i++)
	{
		fullNameString = GetSystemMessage(i);

		if(fullNameString != "")
		{
			//Debug( "FindAllSystemMessage" @ fullNameString );
			if(InsertRecordFindTreeList(fullNameString, a_Param, i, "") == 1000)
			{
				AddSystemMessage(3489);
				return;
			}
		}
	}
}

function FindAllQuest(string a_Param)
{
	local int Id;
	local string fullNameString, IconName;
	local int QuestType;

	ClearList();

	for(Id = class'UIDATA_QUEST'.static.GetFirstID(); -1 != Id; Id = class'UIDATA_QUEST'.static.GetNextID())
	{
		fullNameString = class'UIDATA_QUEST'.static.GetQuestName(Id);
		QuestType = class'UIDATA_QUEST'.static.GetQuestType(Id, 1);

		switch(QuestType)
		{
			case 0:
			case 2:
				IconName = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_1";
				break;
			case 1:
			case 3:
				IconName = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_2";
				break;
			case 4:
				//Debug("���� ��Ƽ");
			case 5:
				IconName = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_3";
				//Debug("���� �ַ�");
				break;
		}
		if(InsertRecordFindTreeList(fullNameString, a_Param, Id, IconName) == 1000)
		{
			AddSystemMessage(3489);
			return;
		}
	}
}

function FindAllSkill(string a_Param)
{
	local ItemID cID;
	local string fullNameString, IconName;

	ClearList();
	m_hFindTreeList.SetTooltipType("Skill");

	for(cID = class'UIDATA_SKILL'.static.GetFirstID(); IsValidItemID(cID); cID = class'UIDATA_SKILL'.static.GetNextID())
	{
		// !���� �ִ��� Ȯ��
		fullNameString = class'UIDATA_SKILL'.static.GetName(cID, 1, 0);
		IconName = class'UIDATA_SKILL'.static.GetIconName(cID, 1, 0);
		IconName = Caps(IconName);

		if(m_unLimitCheckBox.IsChecked())
		{
			InsertRecordFindTreeList(fullNameString, a_Param, cID.ClassID, IconName);			
		}
		else
		{
			if(InsertRecordFindTreeList(fullNameString, a_Param, cID.ClassID, IconName) == 1000)
			{
				AddSystemMessage(3489);
				return;
			}
		}
	}
}

function FindAllNPC(string a_Param)
{
	local int Id;
	local string fullNameString;

	ClearList();

	for(Id = class'UIDATA_NPC'.static.GetFirstID(); -1 != Id; Id = class'UIDATA_NPC'.static.GetNextID())
	{
		fullNameString = class'UIDATA_NPC'.static.GetNPCName(Id);

		if(InsertRecordFindTreeList(fullNameString, a_Param, Id + 1000000, "") == 1000)
		{
			AddSystemMessage(3489);
			return;
		}
	}
}

function FindAllItem(string a_Param)
{
	local ItemID cID;
	local string fullNameString, AdditionalName;
	local int itemNameClass;
	local string IconName;

	ClearList();
	m_hFindTreeList.SetTooltipType("SellItemList");

	for(cID = class'UIDATA_ITEM'.static.GetFirstID(); IsValidItemID(cID); cID = class'UIDATA_ITEM'.static.GetNextID())
	{
		fullNameString = class'UIDATA_ITEM'.static.GetItemName(cID);
		itemNameClass = class'UIDATA_ITEM'.static.GetItemNameClass(cID);
		AdditionalName = class'UIDATA_ITEM'.static.GetItemAdditionalName(cID);
		IconName = class'UIDATA_ITEM'.static.GetItemTextureName(cID);
		IconName = Caps(IconName);

		if(itemNameClass == 0)
		{
			fullNameString = MakeFullSystemMsg(GetSystemMessage(2332), fullNameString);
		}
		else if(itemNameClass == 2)
		{
			fullNameString = MakeFullSystemMsg(GetSystemMessage(2331), fullNameString);
		}
		if(Len(AdditionalName) > 0)
		{
			fullNameString = fullNameString $ "(" $ AdditionalName $ ")";
		}

		if(m_unLimitCheckBox.IsChecked())
		{
			InsertRecordFindTreeList(fullNameString, a_Param, cID.ClassID, IconName);			
		}
		else if(InsertRecordFindTreeList(fullNameString, a_Param, cID.ClassID, IconName) == 1000)
		{
			AddSystemMessage(3489);
			return;
		}
	}
}

//��ų�� ���� �ٿ� ��ȯ �ϵ��� �۾�
function int makeSkillLevel(int Id)
{
	local LVDataRecord preRecord;
	local int recordCount;

	preRecord.LVDataList.Length = 2;

	recordCount = m_hFindTreeList.GetRecordCount();

	//�Է��� �Ѱ��� ���� ù �Է� �̶��
	if(recordCount == 0) return 1;

	m_hFindTreeList.GetRec(recordCount - 1, preRecord);

	//���� ID �� ������ ���� ���� ���� ������ ����
	if(preRecord.LVDataList[1].szData == string(Id))
	{
		return preRecord.LVDataList[1].nReserved1 + 1;
	}
	// �ٸ��� ���ο� ��ų�̹Ƿ� 1����	

	return 1;
}

function LVDataRecord InsertIconData(LVDataRecord record, string IconName)
{
	local int nTextureWH, nTextureUV;

	record.LVDataList[0].hasIcon = true;

	switch(curListType)
	{
		case LISTTYPE_ITEM:
			nTextureWH = 32;

			if(m_checkbox64size.IsChecked())
			{
				nTextureUV = 64;
			} else {
				nTextureUV = 32;
			}
			break;
		case LISTTYPE_SKILL:
			nTextureWH = 32;
			if(m_checkbox64size.IsChecked())
			{
				nTextureUV = 64;
			} else {
				nTextureUV = 32;
			}
			break;
		case LISTTYPE_CLASS:
			nTextureWH = 32;
			nTextureUV = 16;
			break;
		case LISTTYPE_QUEST:
			nTextureWH = 32;
			nTextureUV = 16;
			break;
		default:
			nTextureWH = 32;
			nTextureUV = 16;
			break;
	}

	record.LVDataList[0].nTextureWidth = nTextureWH;
	record.LVDataList[0].nTextureHeight = nTextureWH;
	record.LVDataList[0].nTextureU = nTextureUV;
	record.LVDataList[0].nTextureV = nTextureUV;
	record.LVDataList[0].szTexture = IconName;
	record.LVDataList[0].IconPosX = 2;
	record.LVDataList[0].FirstLineOffsetX = 2;

	return record;
}

function int InsertRecordFindTreeList(string fullNameString, string a_Param, int Id, string IconName)
{
	local string modifiedString, itemParam;
	local LVDataRecord record;

	record.LVDataList.Length = 2;

	modifiedString = Substitute(fullNameString, " ", "", false);

	if(findMatchString(modifiedString, a_Param) != -1 || a_Param == "" || a_Param == string(Id))
	{
		record.LVDataList[0].bUseTextColor = true;
		record.LVDataList[0].TextColor = Gold;

		if(curListType == LISTTYPE_ITEM)
		{
			// �ش� ������ ���� ����Ʈ�� �����������ü� �ֵ��� ���  <- �߱��ʿ��� ���� api
			class'UIDATA_ITEM'.static.GetItemInfoString(Id, itemParam);
			record.szReserved = itemParam;
			record.nReserved1 = Int64(Id);
		}
		else if(curListType == LISTTYPE_SKILL)
		{
			record.LVDataList[1].nReserved1 = makeSkillLevel(Id);
			fullNameString = fullNameString @ "Lv" $ record.LVDataList[1].nReserved1;

			record.nReserved1 = Id;
			record.nReserved2 = record.LVDataList[1].nReserved1;
		}

		if(IconName != "") record = InsertIconData(record, IconName);

		record.LVDataList[0].szData = fullNameString;

		record.LVDataList[1].szData = string(Id);
		record.LVDataList[1].TextColor = Gold;

		m_hFindTreeList.InsertRecord(record);

		return m_hFindTreeList.GetRecordCount();
	}
}

function int findMatchString(string modifiedString, string a_Param)
{
	//local array <string> modifiedParamArr;
	//local int i ;
	local string delim;
	//local int _inStr;

	//branch GD35_0828 2013-11-13 luciper3 - �̱����� ������ɾ� ��ҹ� ���о��� ��밡���ϵ��� �����ش޶����.
	//local bool bIsUsa;
	//local string strTemp1;
	//local string strTemp2;
	//end of branch

	delim = " ";

	if(StringMatching(modifiedString, a_Param, delim))
		return 1;
	else
		return -1;

	/* StringMatching���� ��ü
	//Split( a_Param, " ", modifiedParamArr);	 <- �̰� delim �� �ΰ��� ���� ���� �۵� ���� ���� !!! ���̰� �ִ� ���� ���Ƽ� �ڵ� ��ü�� �鿩 �� ldw
	_inStr = InStr(a_Param, delim);
	while ( _inStr > -1  )
	{
		modifiedParamArr.Insert(modifiedParamArr.Length, 1);
		modifiedParamArr[modifiedParamArr.Length-1] = Left(a_Param, _inStr );
		a_Param = Mid(a_Param, _inStr + 1);
		_inStr = InStr(a_Param, delim);
	}

	modifiedParamArr.Insert(modifiedParamArr.Length, 1);
	modifiedParamArr[modifiedParamArr.Length-1] = a_Param;

	bIsUsa = GetLanguageCustom() == 1; //branch GD35_0828 2013-11-14 luciper3 - Ŀ���� �� �Լ��� �ֱ��ѵ�.. �װž��� ũ������ ����Ÿ�Թ����ε��ؼ� int�����ϴ°ɷ� �ٲ�.
	for ( i = 0 ; i < modifiedParamArr.Length ; i++ )
	{	
		//branch GD35_0828 2013-11-13 luciper3 - �̱����� ������ɾ� ��ҹ� ���о��� ��밡���ϵ��� �����ش޶����.
		if( bIsUsa )
		{
			strTemp1 = Caps(modifiedString);
			strTemp2 = Caps(modifiedParamArr[i]);
			if ( InStr( strTemp1, strTemp2 ) == -1 && modifiedParamArr[i] != " " ) 
				return -1;
		}
		else if ( InStr( modifiedString, modifiedParamArr[i] ) == -1 && modifiedParamArr[i] != " " )
		{
			return -1;
		}
		//end of branch
	}
	*/

	return 1;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	Summon(1);
}

function Summon(INT64 Cnt)
{
	local LVDataRecord record;

	record.LVDataList.Length = 2;

	//if ( !bSummon )  return;

	if(GetSelectedListCtrlItem(record))
	{
		if(record.LVDataList[1].szData != "")
		{
			switch(curListType)
			{
				case LISTTYPE_ITEM:
				case LISTTYPE_NPC:
					ProcessChatMessage("//summon" @ record.LVDataList[1].szData @ Cnt);
					break;
				case LISTTYPE_SKILL:
					ProcessChatMessage("//setskill" @ record.LVDataList[1].szData @ record.LVDataList[1].nReserved1 @ 0);
					break;
				case LISTTYPE_CLASS:
					ProcessChatMessage("//setclass" @ record.LVDataList[1].szData);
					break;
				case LISTTYPE_QUEST:
					ProcessChatMessage("//setquest" @ record.LVDataList[1].szData @ 0);
					break;
				case LISTTYPE_SYSTEMSTRING:
					ClipboardCopy(record.LVDataList[0].szData);
					ProcessChatMessage("///ss" @ record.LVDataList[1].szData);
					break;
				case LISTTYPE_SYSTEMMESSAGE:
					ClipboardCopy(record.LVDataList[0].szData);
					ProcessChatMessage("///sm" @ record.LVDataList[1].szData);
					break;
			}
		}
	}
}

function OnClickListCtrlRecord(string strID)
{
	local LVDataRecord Record;

	m_hBtnSummon.EnableWindow();

	if(curListType == EListType.LISTTYPE_ITEM)
	{
		if(GetSelectedListCtrlItem(Record))
		{
			GMFindTreeWndItem(GetScript("GMFindTreeWndItem")).SetItemID(int(Record.LVDataList[1].szData));
		}
	}
	if((curListType == EListType.LISTTYPE_ITEM) || (curListType == EListType.LISTTYPE_SKILL))
	{
		if(GetSelectedListCtrlItem(Record))
		{
			GetTextureHandle("GMFindTreeWnd.Texture64").SetTexture(Record.LVDataList[0].szTexture);
			GetTextureHandle("GMFindTreeWnd.Texture48").SetTexture(Record.LVDataList[0].szTexture);
			GetTextureHandle("GMFindTreeWnd.Texture32").SetTexture(Record.LVDataList[0].szTexture);
			GetTextureHandle("GMFindTreeWnd.Texture24").SetTexture(Record.LVDataList[0].szTexture);
			GetTextureHandle("GMFindTreeWnd.Texture16").SetTexture(Record.LVDataList[0].szTexture);
			Debug(Record.LVDataList[0].szTexture);
		}
	}
}

function OnClickCheckBox(string Id)
{
	if(Id == "ChkBox64")
	{
		if(m_checkbox64size.IsChecked())
		{
			Me.SetWindowSize(369, 628);
		} else {
			Me.SetWindowSize(369, 558);
		}
	}
}

function OnClickButton(string strID)
{
	//local string summonCnt;

	switch(strID)
	{
		case "btnSummon":
			switch(curListType)
			{
				case LISTTYPE_ITEM:
					openDialogNumpad(1);
					break;
				case LISTTYPE_QUEST:
					Summon(1);
					break;
				case LISTTYPE_NPC:
					openDialogNumpad(1);
					break;
				case LISTTYPE_SKILL:
					Summon(1);
					break;
				case LISTTYPE_SYSTEMSTRING:
					Summon(1);
					break;
				case LISTTYPE_SYSTEMMESSAGE:
					Summon(1);
					break;
			}
			//summonCnt=m_hEdSummonCnt.GetString();
			//Summon(int(summonCnt));
			break;
		case "btnFind":
			handleFind();
			break;
	}
}

function handleFind()
{
	local string EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	ShowList(EditBoxString, curListType);
}

function bool GetSelectedListCtrlItem(out LVDataRecord record)
{
	local int index;

	index = m_hFindTreeList.GetSelectedIndex();

	if(index >= 0)
	{
		m_hFindTreeList.GetRec(index, record);
		return true;
	}
	return false;
}

// List related operations
function ClearList()
{
	m_hFindTreeList.DeleteAllItem();
	m_hFindTreeList.ClearTooltip();
	m_hFindTreeList.SetTooltipType("");
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

/** Desc : ���̾�α� �����츦 ���� OK ��ư ���� ��� */
function HandleDialogOK()
{
	//local ItemInfo scInfo;
	local INT64 inputNum;
	local int id;

	if(!class'UICommonAPI'.static.DialogIsOwnedBy(string(self)))	return;

	id = class'UICommonAPI'.static.DialogGetID();

	if(id == ASK_SUMMON_NUMBER)
	{
		inputNum = INT64(class'UICommonAPI'.static.DialogGetString());
		//summonCnt=m_hEdSummonCnt.GetString();
		Summon(inputNum);
	}
}

function openDialogNumpad(INT64 Num)
{
	// Ask price
	class'UICommonAPI'.static.DialogSetID(ASK_SUMMON_NUMBER);
	//DialogSetReservedItemID( info.ID );				// ServerID
	//DialogSetReservedInt3( int(bAllItem) );		// ��ü�̵��̸� ���� ���� �ܰ踦 �����Ѵ�
	class'UICommonAPI'.static.DialogSetEditType("number");
	class'UICommonAPI'.static.DialogSetParamInt64(Num);
	class'UICommonAPI'.static.DialogSetDefaultOK();
	class'UICommonAPI'.static.DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemString(1543) @ GetSystemString(192), string(self));
}

/** OnKeyUp */
function OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	// Ű���� �������� üũ
	if(m_hEditBox.IsFocused())
	{
		// txtPath
		if(nKey == IK_Enter)
		{
			// Ű���� �Է��� �ƹ��͵� �Է� ���� �ʾ����� ��ü �˻��� ������� �ʴ´�.
			// �Ǽ��� �ڲ� ������ ��찡 �־..
			if(trim(m_hEditBox.GetString()) != "") handleFind();
		}
	}
}

defaultproperties
{
	m_WindowName="GMFindTreeWnd"
}
