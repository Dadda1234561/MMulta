class MacroEditWnd extends UICommonAPI;

const MACRO_MAX_COUNT = 48;
const DEFAULT_MACROICON_ID = 105; // 2015-11-04 ���� ��ũ�� ������ ��ȣ
const MACRO_ICONANME = "L2UI.MacroWnd.MACRO_ICON";

var string m_WindowName;
var int MACROCOMMAND_MAX_COUNT;
var bool m_bShow;
var int		m_CurIconNum;
var int     m_CurSkillID;
var ItemID	m_CurMacroItemID;
var string  m_CurFocusedBoxName;
var int     m_CurFocusedBoxIndex;

//var WindowHandle	m_MacroEditWnd;
var WindowHandle    MacroEditWnd_Input;
var WindowHandle    MacroEditWnd_IconList;
var WindowHandle    MacroListWnd;
var WindowHandle    Me;


var ButtonHandle m_EditUpButton;
var ButtonHandle m_EditDownButton;

var MultiEditBoxHandle MacroDesc_MultiEdit;

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	
	RegisterEvent( EV_MacroShowEditWnd );
	RegisterEvent( EV_MacroDeleted );

	RegisterEvent( EV_Restart );

	RegisterEvent( EV_Paste );
}

function OnLoad()
{
	SetClosingOnESC();
	//if(CREATE_ON_DEMAND==0)
	
	OnRegisterEvent();
	settingMacroCommandCount();
	Me = GetWindowHandle("MacroEditWnd");
	//m_MacroEditWnd= GetWindowHandle("MacroEditWnd.areaEdit");
	MacroEditWnd_Input = GetWindowHandle("MacroEditWnd.MacroEditWnd_Input");
	MacroEditWnd_IconList = GetWindowHandle("MacroEditWnd.MacroEditWnd_IconList");
	MacroListWnd = GetWindowHandle("MacroListWnd");

	m_EditUpButton = GetButtonHandle("MacroEditWnd.BtnEditUp");
	m_EditDownButton = GetButtonHandle("MacroEditWnd.BtnEditDown");

	MacroDesc_MultiEdit = GetMultiEditBoxHandle("MacroEditWnd.MacroDesc_MultiEdit");

	m_bShow = false;
	m_CurIconNum = 1;
	ClearItemID(m_CurMacroItemID);
	
	InitTabOrder();

	// �⺻ ������ �ʱ�ȭ
	class'UIAPI_TEXTURECTRL'.static.SetTexture( "MacroEditWnd.texMacro", MACRO_ICONANME $ DEFAULT_MACROICON_ID );

	//�ʱ�ȭ
	Clear();

	//HandleMacroList();	
}

function settingMacroCommandCount()
{
	local int i;

	i = 0;

	// End:0x5C [Loop If]
	while(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".MacroEditWnd_Input.txtEdit" $ string(i)).m_pTargetWnd != none)
	{
		i++;
	}
	MACROCOMMAND_MAX_COUNT = i;
	ToolTip(GetScript("Tooltip")).MACROCOMMAND_MAX_COUNT = MACROCOMMAND_MAX_COUNT;
	MacroPresetWnd(GetScript("MacroPresetWnd")).MACROCOMMAND_MAX_COUNT = MACROCOMMAND_MAX_COUNT;	
}

function OnShow()
{
	HandleMacroList();

	if (MacroEditWnd_IconList.IsShowWindow())
	{
		swapWindow();
	}
	m_bShow = true;
	Debug("MACROCOMMAND_MAX_COUNT" @ string(MACROCOMMAND_MAX_COUNT));	
}

function OnHide()
{
	m_bShow = false;	
}

// ���� �������� �ִ��� üũ
function bool hasIconInArray(string targetIconName)
{
	local int idx, itemLen;
	local bool flag;
	local ItemInfo ItemInfo;
	
	itemLen = GetItemWindowHandle("MacroEditWnd.MacroEditWnd_IconList.MacroItem").GetItemNum();

	for(idx = 0; idx < itemLen; idx++)
	{
		GetItemWindowHandle("MacroEditWnd.MacroEditWnd_IconList.MacroItem").GetItem(idx, ItemInfo);

		if(targetIconName == ItemInfo.IconName)
		{
			flag = true;
			break;
		}
	}

	return flag;
}

function HandleMacroList( )
{
	local int Idx;
	local ItemInfo	infItem, nullItemInfo;
	local array<ItemId> mySkillIDArray;
	local string iconStr;
	local SkillInfo tempSkillInfo;

	//class'UIAPI_TEXTURECTRL'.static.SetTexture( "MacroEditWnd.texMacro", MACRO_ICONANME $ DEFAULT_MACROICON_ID );

	//// �⺻ ? ������ 
	////class'UIAPI_TEXTURECTRL'.static.SetTexture( "MacroEditWnd.texMacro", "L2UI_CT1.Icon.Icon_MacroDF" );

	////�ʱ�ȭ
	//Clear();

	GetItemWindowHandle("MacroEditWnd.MacroItem").Clear();

	// ���� ��ũ�� ? ������ �߰�
	infItem.IconName = MACRO_ICONANME $ DEFAULT_MACROICON_ID;
	infItem.ShortcutType = int(EShortCutItemType.SCIT_MACRO);
	class'UIAPI_ITEMWINDOW'.static.AddItem("MacroEditWnd.MacroEditWnd_IconList.MacroItem", infItem);

	// ��ũ�� ������ �߰�
	for (Idx=0; Idx < 7; Idx++)
	{	
		infItem.IconName = MACRO_ICONANME $ (Idx + 1);
		infItem.ShortcutType = int(EShortCutItemType.SCIT_MACRO);
		
		//MacroItem�� �߰�
		class'UIAPI_ITEMWINDOW'.static.AddItem("MacroEditWnd.MacroEditWnd_IconList.MacroItem", infItem);
	}	
		
	// �� ��ų ������ �߰�
	class'UIDATA_SKILL'.static.GetCurrentSkillList(mySkillIDArray);

	for(idx = 0; Idx < mySkillIDArray.Length; idx++)
	{
		// ��ų ������ �а�
		if(GetSkillInfo(mySkillIDArray[idx].ClassID, 1, 0, tempSkillInfo))
		{
			infItem = nullItemInfo;
			// ��Ƽ�� ��ų �̰�, ���� ��ų�� �ƴ� ��� �߰�
			if(isActiveSkill(tempSkillInfo.IconType)  && tempSkillInfo.MagicType != EMixMagicType.MIXMAGICTYPE_ALTERSKILL)
			{
//				Debug("mySkillIDArray:" @ mySkillIDArray[idx].ClassID);
				iconStr = class'UIDATA_SKILL'.static.GetIconName(mySkillIDArray[idx], 1, 0);

				//Debug("----------------------------------------------------------------");
				//Debug("Skill Icon:" @ tempSkillInfo.SkillName);
				//Debug("Skill Icon:" @ iconStr);
				//Debug("Skill IconType:" @ tempSkillInfo.IconType);
				//Debug("Skill OperateType:" @ tempSkillInfo.OperateType);

				if (iconStr != "")
				{
					// ���� �������� ���ٸ� �ִ´�.
					if (!hasIconInArray(iconStr))
					{
						infItem.Name = tempSkillInfo.SkillName;
						infItem.IconName = iconStr;
						infItem.ShortcutType = int(EShortCutItemType.SCIT_MACRO);

						// �ӽ÷� ��ų ID�� ��� ��Ų��.
						infItem.Level = mySkillIDArray[idx].ClassID;
						class'UIAPI_ITEMWINDOW'.static.AddItem("MacroEditWnd.MacroEditWnd_IconList.MacroItem", infItem);
					}
				}
			}
		}
	}

	// �׼� ������ �߰� 7~ 64 ������ �׼� ������
	for (Idx = 7; Idx < 64; Idx++)
	{	
		infItem = nullItemInfo;
		infItem.IconName = MACRO_ICONANME $ (Idx + 1);
		infItem.ShortcutType = int(EShortCutItemType.SCIT_MACRO);
		
		//MacroItem�� �߰�
		class'UIAPI_ITEMWINDOW'.static.AddItem("MacroEditWnd.MacroEditWnd_IconList.MacroItem", infItem);
	}	

	// ������ ������ ��ũ���� �ٷ� �� �� �ְ�..
	//GetItemWindowHandle("MacroEditWnd.MacroItem").SetFocus();
	// MacroEditWnd_IconList.SetFocus();
}

function OnClickButton( string strID )
{	
	// Debug("strID" @ strID);

	switch( strID )
	{
		//case "btnInfo":		
		//	OnClickInfo();
		//	break;
		case "btnHelp":
			OnClickHelp();
			break;
		case "btnCancel":
			OnClickCancel();
			break;
	/*	case "btnLeft":
			OnClickLeft();
			break;
		case "btnRight":
			OnClickRight();
			break;*/
		case "btnSave":
			OnClickSave();
			break;
		//case "texMacro":		
		case "btnIconChange":
			onClickIconChange();
			break;

		//�߰����  ����, ����, ����
		case "BtnEditUp":
			LineSwap("up");
			break;
		case "BtnEditDown":
			LineSwap("down");
			break;
		case "BtnEditdel":
			CurClearLine();
			break;
		case "BtnEditAdd":
			CurInsertLine();
			break;

		case "Preset_Btn":
			toggleWindow("MacroPresetWnd", true);
			break;

		case "MacroCopy_Btn" :
			macroTotalCopy();
			break;

		case "MacroPaste_Btn" :
			macroTotalPaste();
			break;

		case "BtnEditAlldel" :
			clearAllMacrocommandEditbox();
			break;
	}
}

// ��ũ�� ��ü ī��
function macroTotalCopy()
{
	local int idx;
	local string commandString;

	// �� 0~11 ������ �ڽ� ��Ʈ���� ���� ������ �����ؼ� �ϳ��� ��Ʈ������ �����.
	for(idx = 0; idx < MACROCOMMAND_MAX_COUNT; idx++)
	{
		if (GetEditBoxHandle("MacroEditWnd.txtEdit" $ idx).GetString() != "")
		{
			commandString = commandString $ GetEditBoxHandle("MacroEditWnd.txtEdit" $ idx).GetString() $ Chr(13);
		}
	}

	// ������ \n �ڵ� ����
	if (Len(commandString) > 0)
	{
		commandString = Left(commandString, Len(commandString) - 1);
	}

	Debug("Ŭ�� ���忡 ī�� �Ǿ����ϴ�.:" @ commandString);
	// 4399    ��ũ�� ������ Ŭ������� ����Ǿ����ϴ�
	AddSystemMessage(4399);

	ClipboardCopy(commandString);
}
	
// ��ũ�� ��ü ī��
function macroTotalPaste()
{
	pastByClipboard(true);
}

function onClickIconChange()
{
	swapWindow();
}

function swapWindow()
{
	local ButtonHandle btnIconChange ;

	btnIconChange = GetButtonHandle("MacroEditWnd.btnIconChange");

	if (MacroEditWnd_Input.IsShowWindow()) 
	{   
		btnIconChange.SetButtonName( 2817 );//��ũ�� ����
		MacroEditWnd_Input.HideWindow();
		MacroEditWnd_IconList.ShowWindow();

		// ������ ������ ��ũ���� �ٷ� �� �� �ְ�..
		MacroEditWnd_IconList.SetFocus();
	
	}
	else 
	{
		btnIconChange.SetButtonName( 2815 );//������ ����
		MacroEditWnd_Input.ShowWindow();
		MacroEditWnd_IconList.HideWindow();
	}
}

function OnClickItem( string strID, int index )
{
	local int strLen;
	local ItemInfo 	infItem;
	
	if (strID == "MacroItem" && index>-1)
	{		
		if (class'UIAPI_ITEMWINDOW'.static.GetItem("MacroEditWnd.MacroItem", index, infItem))
		{	
			class'UIAPI_TEXTURECTRL'.static.SetTexture( "MacroEditWnd.texMacro", infItem.IconName);

			// infItem.Level �� �ӽ÷� ��ų ���̵� �־�� ����. 0�� �ƴϸ� ��ų ���̵�, ��ų�������� ����Ѵ�.
			if (infItem.Level > 0)
			{
				m_CurSkillID = infItem.Level;
			}
			else
			{
				m_CurSkillID = 0;
				strLen = Len(infItem.IconName) - Len( MACRO_ICONANME ) ;
				m_CurIconNum = int(Right(infItem.IconName, strLen));
			}

			Debug("��ų Name" @ infItem.Name);
			Debug("��ų ID" @ infItem.Level);
			Debug("m_CurIconNum : " @ m_CurIconNum);


			///m_CurIconNum = index + 1;
			//class'UIAPI_TEXTURECTRL'.static.SetTexture( "MacroEditWnd.texMacro", MACRO_ICONANME $ ( m_CurIconNum ) );						

			swapWindow();
		}
	}
}

function OnEvent(int Event_ID, String param)
{
	if (Event_ID == EV_MacroShowEditWnd)
	{
		HandleMacroShowEditWnd(param);
	}
	else if (Event_ID == EV_MacroDeleted)
	{
		HandleMacroDeleted(param);		
	}
	else if (Event_ID == EV_DialogOK)
	{
		if (DialogIsMine())
		{
			ProcessInsertLine();
		}
	}
	else if (Event_ID == EV_DialogCancel)
	{	
	}
	else if (Event_ID == EV_Paste)
	{	
		if (Me.IsShowWindow())
		{
			pastByClipboard(true);
		}
	}
	else if (Event_ID == EV_Restart)
	{
		Clear();
	}
}

// �ܺο��� ��ũ�� ������ ���� �ҋ� ���, �����¿���..
function setEditMacroInfo(string macroName, string IconTextureName)
{
	local int strLen;

	// �������̸�
	GetEditBoxHandle("MacroEditWnd.txtName").SetString(macroName);

	//ª�� �̸�
	GetTextBoxHandle("MacroEditWnd.txtMacroName").SetText(Left(macroName, 4));
 
	// �����¿����� ��ų ������ ��� ���Ѵ�. 
	m_CurSkillID = 0;

	strLen = Len(IconTextureName) - Len( MACRO_ICONANME ) ;
	m_CurIconNum = int(Right(IconTextureName, strLen));

	// ������ ���� 
	class'UIAPI_TEXTURECTRL'.static.SetTexture( "MacroEditWnd.texMacro", MACRO_ICONANME $ m_CurIconNum );
}

function pastByClipboard(bool bLastEditBoxFocus)
{
	local string clipboardstr;
	local int idx;

	clipboardstr = clipboardpaste();

	// debug("m_curfocusedboxname"@ m_curfocusedboxname);
	// debug(":gettextboxhandle(m_curfocusedboxname).isfocused()" @ GetEditBoxHandle(m_curfocusedboxname).isfocused());
	// Debug("clipboardstr" @ clipboardstr);
	if(len(clipboardstr) > 0)
	{
		if(GetEditBoxHandle(m_curfocusedboxname).IsFocused())
		{   
			idx = GetCurTextBoxIndex(m_CurFocusedBoxName);
			pasteMacroEdit(idx, clipboardstr, bLastEditBoxFocus);
			Debug("���� ��ġ ����" @ idx);
		}
		else
		{
			// ��Ŀ���� ���ٸ� ��ü ù��° �� ���� ���̱�
			pasteMacroEdit(0, clipboardstr, bLastEditBoxFocus);
			Debug("ù�� ����");
		}
	}
}

// ������ �ڽ� 0~11 ����, ���̱� bLastEditBoxFocus�� ��Ƽ���� ���̱� �϶� �������� ��Ŀ�� �ֱ�
// onelineOverwrite ���� ���̱⸦ �Ҷ��� �����
function pasteMacroEdit(int nEditLine, string commandStr, optional bool bLastEditBoxFocus, optional bool onelineOverwrite)
{
	local array<string> commandArray;
	local int idx;
	local string pasteString;

	//Split(commandStr, "\n", commandArray);

	// Debug("commandStr : " @ commandStr);
	Split(commandStr, Chr(13), commandArray);

	Debug("Length : " @ commandArray.Length);
	
	// \n ���� ���� �ֳ�? ������ ��Ƽ����..
	if(InStr( commandStr ,Chr(13) ) != -1)
	{
		for (idx = 0; idx < commandArray.Length; idx++)
		{
			if (nEditLine + idx < MACROCOMMAND_MAX_COUNT)
			{
				pasteString = deleteEnter(commandArray[idx]);

				class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtEdit" $ (nEditLine + idx), pasteString);

				Debug("������  �ֱ�" @ nEditLine + idx @ ": " @ commandArray[idx]);
				Debug("������  pasteString:" @ nEditLine + idx @ ": " @ pasteString);

				if (bLastEditBoxFocus)
				{
					// ���̱� ������ ���� ĭ�� ��Ŀ�� �ֱ�
					if (nEditLine + idx < MACROCOMMAND_MAX_COUNT - 1)
						GetEditBoxHandle("MacroEditWnd.txtEdit" $ (nEditLine + idx + 1)).SetFocus();
				}
			}
		}
	}
	// ���� �ֱ�
	else
	{
		// ��ų�̳� �׼ǵ��� �巡�� �Ͽ� ���� ���
		if (onelineOverwrite)
		{
			GetEditBoxHandle("MacroEditWnd.txtEdit" $ (nEditLine)).SetString(commandStr);
		}
		else
		{
			Debug("���� �ֱ�" @ commandStr);
			GetEditBoxHandle("MacroEditWnd.txtEdit" $ (nEditLine)).DeleteClipBoard();
			GetEditBoxHandle("MacroEditWnd.txtEdit" $ (nEditLine)).AddString(commandStr);
		}

	}
}

function InitTabOrder()
{
	local int idx;
	
	class'UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd", "MacroEditWnd.txtName", "MacroEditWnd.MacroDesc_MultiEdit");
	class'UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtName", "MacroEditWnd.MacroDesc_MultiEdit", "MacroEditWnd");
	class'UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.MacroDesc_MultiEdit", "MacroEditWnd.txtEdit0", "MacroEditWnd.txtName");

	for (idx=0; idx < MACROCOMMAND_MAX_COUNT; idx++)
	{
		if (idx==0)
			class'UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtEdit0", "MacroEditWnd.txtEdit1", "MacroEditWnd.MacroDesc_MultiEdit");
		else if (idx == MACROCOMMAND_MAX_COUNT - 1)
			class'UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtEdit11", "MacroEditWnd.txtName", "MacroEditWnd.txtEdit10");
		else
			class'UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtEdit" $ idx, "MacroEditWnd.txtEdit" $ idx+1, "MacroEditWnd.txtEdit" $ idx-1);
	}
}

//////////////////////////////////////////////////////////////////////////////////
//���� ��ư
function OnClickHelp()
{
	local string strParam;
	ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "help_general_control_macro.htm");
	ExecuteEvent(EV_ShowHelp, strParam);
}

//////////////////////////////////////////////////////////////////////////////////
//��� ��ư
function OnClickCancel()
{
	class'UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
}


//////////////////////////////////////////////////////////////////////////////////
//���� ��ư
function OnClickSave()
{
	SaveMacro();
}

//////////////////////////////////////////////////////////////////////////////////
// Drag & Drop
function OnDropItem( String strID, ItemInfo infItem, int x, int y )
{
	local int nEditLine;
	//local array<String> commandArray;

	if (Len(strID)<1)
		return;
		
	if (Left(strID, 7) != "txtEdit")
		return;
		
	class'UIAPI_EDITBOX'.static.SetHighLight( "MacroEditWnd." $ strID, FALSE);

	nEditLine = int(Mid(strID, Len("txtEdit"), Len(strID)));

	// �ٿ� �ֱ�
	pasteMacroEdit(nEditLine, infItem.MacroCommand, false, true);
}

function OnDragItemStart( String strID, ItemInfo infItem )
{
	if (Len(strID)<1)
		return;
		
	if (Left(strID, 7) != "txtEdit")
		return;
		
	class'UIAPI_EDITBOX'.static.SetHighLight( "MacroEditWnd." $ strID, TRUE);
}

function OnDragItemEnd( String strID )
{
	if (Len(strID)<1)
		return;
		
	if (Left(strID, 7) != "txtEdit")
		return;
		
	class'UIAPI_EDITBOX'.static.SetHighLight( "MacroEditWnd." $ strID, FALSE);
}

//////////////////////////////////////////////////////////////////////////////////
// Macro Icon

function OnChangeEditBox( String strID )
{
	switch( strID )
	{
		case "txtName" :
			 UpdateIconName();
 			 break;
	}
}

function UpdateIcon()
{
	local string iconStr;

	// ��ų�������� ��� �ߴٸ�..
	if (m_CurSkillID > 0)
	{
		iconStr = class'UIDATA_SKILL'.static.GetIconName(GetItemID(m_CurSkillID), 1, 0);
		class'UIAPI_TEXTURECTRL'.static.SetTexture( "MacroEditWnd.texMacro", iconStr);
	}
	// ���� Macro Icon
	else
	{
		class'UIAPI_TEXTURECTRL'.static.SetTexture( "MacroEditWnd.texMacro", MACRO_ICONANME $ m_CurIconNum);
	}
}

function UpdateIconName()
{
	local string strShortName;
	
	strShortName = Left(class'UIAPI_EDITBOX'.static.GetString( "MacroEditWnd.txtName"), 4 );

	//Debug("strShortName : " @ strShortName);
	class'UIAPI_TEXTBOX'.static.SetText( "MacroEditWnd.txtMacroName", strShortName);
}

//////////////////////////////////////////////////////////////////////////////////
// Clear
function Clear()
{
	//m_CurIconNum = 1
	m_CurSkillID = 0;
	m_CurIconNum = DEFAULT_MACROICON_ID;
	
	class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtName", "");
	//class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtShortName", "");
	MacroDesc_MultiEdit.SetString("");

	clearAllMacrocommandEditbox();
	UpdateIcon();
	UpdateIconName();
//	m_MacroEditWnd.SetScrollPosition(0); // ��ũ�ѹ� �ʱ�ȭ
}

// ��ũ�� �ڽ��� �����Ѵ�.
function clearAllMacrocommandEditbox()
{
	local int idx;

	for (idx=0; idx<MACROCOMMAND_MAX_COUNT; idx++)
	{
		class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtEdit" $ idx, "");
	}
}

//���� �������� �ִ� ��ũ�ΰ� �����Ǿ��ٸ� Hide��Ų��.
function HandleMacroDeleted(string param)
{
	local ItemID cID;
	ParseItemID(param, cID);
	
	if(m_bShow)
	{
		Clear();
		ClearItemID(m_CurMacroItemID);
	}
}

function HandleMacroShowEditWnd(string param)
{
	local int MacroCount;
	local color TextColor;
	
	Clear();
	ClearItemID(m_CurMacroItemID);
	
	Debug("param" @ param);

	//�������
	if (ParseItemID(param, m_CurMacroItemID))
	{
		SetMacroID(m_CurMacroItemID);
		if (!m_bShow)
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			class'UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");			
		}

		// ���� �������� ������ ù��° �ٿ� ��Ŀ�� �ߴٰ�, ���� ������ �ٽ���Ŀ��
		// �̷��� �ϴ� ������ ���̱� ��ư�� �������� â�� ������ ù��° �����͹ڽ��� ��Ŀ���� �� �ֵ��� �ϱ� ���ؼ�
		GetEditBoxHandle("MacroEditWnd.txtEdit0").SetFocus();
		class'UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtName");
	}
	//�߰����
	else
	{
		if (m_bShow)
		{
			//PlayConsoleSound(IFST_WINDOW_CLOSE);
			//class'UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
		}
		else
		{
			//Check Macro Count
			MacroCount = class'UIDATA_MACRO'.static.GetMacroCount();
			if (MacroCount>=MACRO_MAX_COUNT)
			{
				TextColor.R = 176;
				TextColor.G = 155;
				TextColor.B = 121;
				TextColor.A = 255;
				DialogShow(DialogModalType_Modalless,DialogType_Notice, GetSystemMessage(797), string(Self));
				DialogSetID(0);	
				//AddSystemMessage(GetSystemMessage(797), TextColor);
				return;
			}
			
			PlayConsoleSound(IFST_WINDOW_OPEN);
			class'UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");
			
			// ���� �������� ������ ù��° �ٿ� ��Ŀ�� �ߴٰ�, ���� ������ �ٽ���Ŀ��
			// �̷��� �ϴ� ������ ���̱� ��ư�� �������� â�� ������ ù��° �����͹ڽ��� ��Ŀ���� �� �ֵ��� �ϱ� ���ؼ�
			GetEditBoxHandle("MacroEditWnd.txtEdit0").SetFocus();			
			class'UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtName");
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////
// �ش� MacroID�� ȭ�� ǥ��
function SetMacroID(ItemID cID)
{
	local int idx;
	local MacroInfo info;
	local int strLen;
	
	if (!IsValidItemID(cID))
		return;
		
	if (class'UIDATA_MACRO'.static.GetMacroInfo(cID, info))
	{
		//�̸�
		class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtName", info.Name);
		//�����̸�
		//class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtShortName", info.IconName);
		//������
		
		if (info.IconSkillId > 0)
		{
			m_CurSkillID = info.IconSkillId;
			m_CurIconNum = DEFAULT_MACROICON_ID;
		}
		else
		{
			strLen = Len(info.IconTextureName) - Len( MACRO_ICONANME ) ;			
			m_CurIconNum = int(Right(info.IconTextureName, strLen));
		}

		//Debug("strLen" @ strLen @ m_CurIconNum @ info.IconTextureName @ info.IconTextureName) ; 
		if (m_CurIconNum<1)
			m_CurIconNum = DEFAULT_MACROICON_ID;
		UpdateIcon();

		//����
		MacroDesc_MultiEdit.SetString(info.Description);

		//Ŀ�ǵ�12��
		for (idx=0; idx<MACROCOMMAND_MAX_COUNT; idx++)
		{
			class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtEdit" $ idx, info.CommandList[idx]);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////
// ��ũ�� ����
function SaveMacro()
{
	local int idx, saveIdx;
	
	local string		Name;
	//local string		IconName;
	local string		Description;
	local string		Command;
	local array<string> CommandList;
	
	Name = class'UIAPI_EDITBOX'.static.GetString( "MacroEditWnd.txtName");
	//IconName = class'UIAPI_EDITBOX'.static.GetString( "MacroEditWnd.txtShortName");
	Description = MacroDesc_MultiEdit.GetString();

	for (idx=0; idx<MACROCOMMAND_MAX_COUNT; idx++)
	{
		Command = class'UIAPI_EDITBOX'.static.GetString( "MacroEditWnd.txtEdit" $ idx);
		if(Command != "")
		{
			CommandList.Insert(CommandList.Length, 1);
			CommandList[CommandList.Length-1] = Command;
		}
	}
	
	//������ ĭ�� ä����
	for (saveIdx = CommandList.Length; saveIdx<MACROCOMMAND_MAX_COUNT; saveIdx++)
	{
		CommandList.Insert(CommandList.Length, 1);
		CommandList[CommandList.Length-1] = "";
	}
		
	//if (class'MacroAPI'.static.RequestMakeMacro(m_CurMacroItemID, Name, GetTextureHandle("MacroEditWnd.texMacro").GetTextureName(), m_CurIconNum-1, 0, Description, CommandList))

	Debug("------> Call RequestMakeMacro,  m_CurIconNum: " @ m_CurIconNum - 1);

	if (class'MacroAPI'.static.RequestMakeMacro(m_CurMacroItemID, Name, Left(Name, 4), m_CurIconNum - 1, m_CurSkillID, Description, CommandList))
	//if (class'MacroAPI'.static.RequestMakeMacro(m_CurMacroItemID, Name, IconName, m_CurIconNum-1, Description, CommandList))
	{
		//MacroListWnd.ShowWindow();
		//class'UIAPI_WINDOW'.static.SetAnchor( "MacroListWnd", "MacroEditWnd", "TopLeft", "TopLeft", 0, 0 );
		class'UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
	}	
}

/*
 *��ũ�� �߰���� ����
 *�ؽ�Ʈ�� ��, �Ʒ��� �̵����� ������ �� �ִ� ���
 *���� ����, ���� ���
 *���� �� ��ĭ �˾Ƽ� ���� �� �������ִ� ���
 */

//���� ������ ��ĭ���� ����� �ؿ������� ��ܿø�.
function CurClearLine()
{
	local int idx, i;
	local string nextString;
	local string curString;
	local array<string> list;

	idx = GetCurTextBoxIndex(m_CurFocusedBoxName);
	list.Remove(0, list.Length);

	//������ ��ĭ���� �����.
	class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtEdit" $ (idx), "");

	for (i = idx + 1; i < MACROCOMMAND_MAX_COUNT; i++)
	{
		curString = class'UIAPI_EDITBOX'.static.GetString( "MacroEditWnd.txtEdit" $ i);
		class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtEdit" $ (i), "");
		list.Insert(list.Length, 1);
		list[list.Length-1] = curString;
	}

	for (i = idx; i < list.Length+idx; i++)
	{	
		nextString = list[i-idx];		
		class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtEdit" $ (i), nextString);
	}

	class'UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtEdit" $ idx);
}


// ��ũ�� 0~11 ������ �ڽ��� ��� �����.
function removeAllEditBox()
{
	local int i;

	for (i = 0; i < MACROCOMMAND_MAX_COUNT; i++)
	{
		class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtEdit" $ i, "");
	}
}

//��������� ��ĭ���� ����� ��ĭ�� ������ ����
function CurInsertLine()
{
	m_CurFocusedBoxIndex = GetCurTextBoxIndex(m_CurFocusedBoxName);
	//������ ������ ��ĭ�� �ƴϸ� ��� ���� ��������
	if(class'UIAPI_EDITBOX'.static.GetString( "MacroEditWnd.txtEdit" $ MACROCOMMAND_MAX_COUNT-1) != "")
	{
		DialogShow(DialogModalType_Modal,DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(4208), string(MACROCOMMAND_MAX_COUNT)), string(Self));
		DialogSetID(0);
		return;
	}
	ProcessInsertLine();
}

function ProcessInsertLine()
{
	local int idx, i, id;
	local string nextString;
	local string curString;

	local array<string> list;
	
	idx = m_CurFocusedBoxIndex;

	//���õ� ĭ�� �ε������� ������ �迭�� �����Ѵ�.
	for (i = idx; i < MACROCOMMAND_MAX_COUNT; i++)
	{
		curString = class'UIAPI_EDITBOX'.static.GetString( "MacroEditWnd.txtEdit" $ i);
		list.Insert(list.Length, 1);
		list[list.Length-1] = curString;
	}

	for (i = idx; i < MACROCOMMAND_MAX_COUNT; i++)
	{
		id = i - idx;
		if(id >= 0)
		{
			nextString = list[id];
			
			if((i+1) < MACROCOMMAND_MAX_COUNT)
			{
				class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtEdit" $ (i+1), nextString);
			}
		}
	}

	//������ ��ĭ���� �����.
	class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtEdit" $ (idx), "");
	class'UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtEdit" $ idx);
}

function LineSwap(string strType)
{	
	local int idx;

	idx = GetCurTextBoxIndex(m_CurFocusedBoxName);

	if(strType == "up")
	{
		// ���� ������ �ε����� �ִ� ���� �������� �۰� -1���� Ŭ ���� �������� ���� ��
		if(idx > 0)
		{
			SwapString(idx, idx-1);
		}
	}
	else if(strType == "down")
	{
		if(idx < MACROCOMMAND_MAX_COUNT-1)
		{
			SwapString(idx, idx+1);
		}
	}
}

//����Ʈ�ڽ��� first �ε����� last �ε��� �۾��� �ٲ��ش�aasd
function SwapString(int firstID, int lastID)
{
	local string lastString;
	local string curString;

	curString = class'UIAPI_EDITBOX'.static.GetString( "MacroEditWnd.txtEdit" $ firstID);
	lastString = class'UIAPI_EDITBOX'.static.GetString( "MacroEditWnd.txtEdit" $ lastID);

	class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtEdit" $ firstID, lastString);
	class'UIAPI_EDITBOX'.static.SetString( "MacroEditWnd.txtEdit" $ lastID, curString);

	//������ �ε����� ��Ŀ�� �ش�.
	class'UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtEdit" $ lastID);
}


/*
 * ��Ŀ���� �ؽ�Ʈ�ڽ��� �ε����� �����Ѵ�
 * txtEdit0~11
 */
function int GetCurTextBoxIndex(string boxName)
{
	local string str;
	local int idx;
	if(Left(boxName, 7) == "txtEdit")
	{
		str = Right(boxName, 2);
		
		//0~9 ����
		if( Left(str, 1) == "t")
		{
			idx = int(Right(boxName, 1));
		}
		//10~12 ����
		else
		{
			idx = int(Right(str, 2));
		}
	}
	return idx;
}

// ��Ŀ��
function OnSetFocus(WindowHandle handle, bool bFocused)
{
	local int idx;
	//���� �ؽ�Ʈ�ڽ��� �̸��� ����
	if(String(handle.name) == "EditBoxHandle")
	{
		m_CurFocusedBoxName = handle.GetWindowName();

		idx = GetCurTextBoxIndex(m_CurFocusedBoxName);

		m_EditUpButton.EnableWindow();
		m_EditDownButton.EnableWindow();

		m_EditUpButton.SetTexture("L2UI_CT1.Button.BtnEditUp", "" , "");
		m_EditDownButton.SetTexture("L2UI_CT1.Button.BtnEditDown", "" , "");

		if(idx == 0)
		{
			m_EditUpButton.DisableWindow();
			m_EditUpButton.SetTexture("L2UI_CT1.Button.BtnEditUp_disable", "" , "");
		}
		else if(idx == (MACROCOMMAND_MAX_COUNT - 1))
		{
			m_EditDownButton.DisableWindow();
			m_EditDownButton.SetTexture("L2UI_CT1.Button.BtnEditDown_disable", "" , "");
		}
	}
}

// ���� ����Ű�� ��ũ�� ����, ������ �ڽ� ��Ŀ�� �̵�
function onKeyUp( WindowHandle a_WindowHandle, EInputKey Key )
{
	local int nEditLine;

	// Ű���� �Է� ó�� 

	if (Key == IK_Up || Key == IK_Down)
	{
		nEditLine = int(Mid(m_CurFocusedBoxName, Len("txtEdit"), Len(m_CurFocusedBoxName)));

		// txtEdit0~11 �� ��Ŀ���� �ȵǾ� ������ ���� Ű���� �Ⱦ�.
		if (!GetEditBoxHandle("MacroEditWnd.txtEdit" $ nEditLine).IsFocused())
		{
			nEditLine = -1;
//			Debug("��Ŀ�� �ȵǾ� ����.");
			return;
		}
	}

	switch(Key)
	{
		case IK_Up:
		    if(nEditLine > 0) 
			{
				nEditLine--;
				GetEditBoxHandle("MacroEditWnd.txtEdit" $ nEditLine).SetFocus();
			}
			break;

		case IK_Down :
			if(nEditLine < MACROCOMMAND_MAX_COUNT - 1)
			{
				nEditLine++;
				GetEditBoxHandle("MacroEditWnd.txtEdit" $ nEditLine).SetFocus();
			}
			break;
	}
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

defaultproperties
{
     m_WindowName="MacroEditWnd"
}
