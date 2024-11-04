//================================================================================
// MacroListWnd.
// emu-dev.ru
//================================================================================

class MacroListWnd extends UICommonAPI;

const MACRO_MAX_COUNT = 48;

var string m_WindowName;
var bool m_bShow;
var ItemID m_DeleteItemID;
var int m_Max;
var WindowHandle m_hMacroListWnd; //branch 111109

function OnRegisterEvent()
{
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_MacroShowListWnd);
	RegisterEvent(EV_MacroUpdate);
	RegisterEvent(EV_MacroList);
}

function OnLoad()
{
	SetClosingOnESC();
	m_hMacroListWnd = GetWindowHandle(m_WindowName);
	m_bShow = false;
	ClearItemID(m_DeleteItemID);
}

function OnEnterState(name a_CurrentStateName)
{
	class'MacroAPI'.static.RequestMacroList();
}

function OnShow()
{
	m_bShow = true;
}

function OnHide()
{
	m_bShow = false;
	// 2011-12-05 ���� (�����) "MacroListWnd"�� �������� "MacroEditWnd"�� ���� �������� ��
	class'UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");

	// ��ũ�� â�� ���� �� ���� ����.
	if(GetWindowHandle("MacroPresetWnd").IsShowWindow())
	{
		GetWindowHandle("MacroPresetWnd").HideWindow();
	}
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnHelp":
			OnClickHelp();
			break;
		case "btnAdd":
			OnClickAdd();
			break;
	}
}

function OnEvent(int Event_ID, string param)
{
	if(Event_ID == EV_MacroShowListWnd)
	{
		HandleMacroShowListWnd();
	}
	else if(Event_ID == EV_MacroUpdate)
	{
		HandleMacroUpdate();
	}
	else if(Event_ID == EV_MacroList)
	{
		HandleMacroList(param);
	}
	else if(Event_ID == EV_DialogOK)
	{
		if(DialogIsMine())
		{
			if(IsValidItemID(m_DeleteItemID))
			{
				class'MacroAPI'.static.RequestDeleteMacro(m_DeleteItemID);
				ClearItemID(m_DeleteItemID);

				if(m_Max == 1)	//�ϳ����� ���� ���� ��� 0�� �ǹǷ� �ѹ� �������ش�. 
				{
					HandleMacroList("");// â�� �ѹ� �������ش�. //0�ϰ�쿡�� �������ָ� ��.
				}
			}
		}
	}
}

//��ũ���� Ŭ��
function OnClickItem(string strID, int Index)
{
	local ItemInfo infItem;

	if(strID == "MacroItem" && Index > -1)
	{
		if(class'UIAPI_ITEMWINDOW'.static.GetItem("MacroListWnd.MacroItem", Index, infItem))
		{
			class'MacroAPI'.static.RequestUseMacro(infItem.ID);
		}
	}
}

//����
function OnClickHelp()
{
	local string strParam;

	// Ŭ���İ� ���̺꿡 �ٸ� ���� ���
	if(getInstanceUIData().getIsClassicServer())
	{
		ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "help_general_control_macro.htm");
		ExecuteEvent(EV_ShowHelp, strParam);
	}
	else
	{
		//ParamAdd(strParam, "FilePath", "..\\l2text\\help_general_control_macro.htm");
		ExecuteEvent(EV_ShowHelp, "37");
	}
}

//�߰�
function OnClickAdd()
{
	// 2011-12-05 ���� (�����) "MacroEditWnd"�� ȭ�鿡 ������ �������� ���̰� ��
	if(class'UIAPI_WINDOW'.static.IsShowWindow("MacroEditWnd"))
	{
		class'UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");		
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");
		class'UIAPI_WINDOW'.static.SetFocus("MacroEditWnd");
		ExecuteEvent(EV_MacroShowEditWnd, "");
	}
}

function HandleMacroUpdate()
{
	class'MacroAPI'.static.RequestMacroList();
}

function HandleMacroShowListWnd()
{
	if(m_bShow)
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		m_hMacroListWnd.HideWindow();
	}
	/*else if ( class'UIAPI_WINDOW'.static.IsShowWindow ( "MacroEditWnd") )//��â ���� ��
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		class'UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
	}*/
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		m_hMacroListWnd.ShowWindow();
		m_hMacroListWnd.SetFocus();
		//SetFocus();
		//class'UIAPI_WINDOW'.static.SetFocus("MacroListWnd");
	}
}

function Clear()
{
	class'UIAPI_ITEMWINDOW'.static.Clear("MacroListWnd.MacroItem");
}

function HandleMacroList(string param)
{
	local int Idx;
	local int Max;

	local string strIconName;
	local string strMacroName;
	local string strDescription;
	local string strTexture;
	local string strTmp;

	local ItemInfo infItem;
	//�ʱ�ȭ
	Clear();

	//Debug("HandleMacroList"@ param);

	ParseInt(param, "Max", Max);
	m_Max = Max;	//�۷ι� �ƽ��� ���� -_-;;

	for(Idx=0; Idx < Max; Idx++)
	{
		strIconName = "";
		strMacroName = "";
		strDescription = "";
		strTexture = "";

		ParseItemIDWithIndex(param, infItem.ID, idx);
		ParseString(param, "IconName_" $ Idx, strIconName);
		ParseString(param, "MacroName_" $ Idx, strMacroName);
		ParseString(param, "Description_" $ Idx, strDescription);
		ParseString(param, "TextureName_" $ Idx, strTexture);

		//Debug("-> strTexture" @ strTexture);

		infItem.Name = strMacroName;
		infItem.AdditionalName = strIconName;
		infItem.IconName = strTexture;
		infItem.Description = strDescription;
		infItem.ShortcutType = int(EShortCutItemType.SCIT_MACRO);

		//MacroItem�� �߰�
		class'UIAPI_ITEMWINDOW'.static.AddItem("MacroListWnd.MacroItem", infItem);
	}

	//��ũ�� ����ǥ��
	if(Max < 10)
	{
		strTmp = strTmp $ "0";
	}
	strTmp = strTmp $ Max;
	strTmp = "(" $ strTmp $ "/" $ MACRO_MAX_COUNT $ ")";
	class'UIAPI_TEXTBOX'.static.SetText("MacroListWnd.txtCount", strTmp);
}

//Trash������������ DropITem
function OnDropItem(string strID, ItemInfo infItem, int X, int Y)
{
	switch(strID)
	{
		case "btnTrash":
			DeleteMacro(infItem);
			break;
		case "btnEdit":
			EditMacro(infItem);
			break;
	}
}

//��ũ�� ����
function DeleteMacro(ItemInfo infItem)
{
	local string strMsg;

	//��ũ�ΰ� �ƴϸ� �н�
	if(infItem.ShortcutType != int(EShortCutItemType.SCIT_MACRO))
	{
		return;
	}

	strMsg = MakeFullSystemMsg(GetSystemMessage(828), infItem.Name, "");
	m_DeleteItemID = infItem.ID;
	DialogShow(DialogModalType_Modalless,DialogType_Warning, strMsg, string(self));
}

//��ũ�� ����
function EditMacro(ItemInfo infItem)
{
	local string param;

	Debug("------------------ > ");
	Debug("infItem Name" @ infItem.Name);

	//��ũ�ΰ� �ƴϸ� �н�
	if(infItem.ShortcutType != int(EShortCutItemType.SCIT_MACRO))
	{
		return;
	}

	Debug("------------EShortCutItemType ------ > " @ string(EShortCutItemType.SCIT_MACRO));

	ParamAddItemID(param, infItem.ID);
	ExecuteEvent(EV_MacroShowEditWnd, param);
	class'UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");

	Debug("���� " @ param);
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hMacroListWnd.HideWindow();
}

defaultproperties
{
	m_WindowName="MacroListWnd"
}
