//------------------------------------------------------------------------------------------------------------
// 
//   ���� : ��ũ�� ����, ����, ���̱� ���, ������ ��� �߰� - 2015-11-03
//
//------------------------------------------------------------------------------------------------------------
class MacroPresetWnd extends UICommonAPI;

var int MACROCOMMAND_MAX_COUNT;

var WindowHandle Me;

var ItemWindowHandle MacroItem_ItemWnd;

var HtmlHandle    PresetViewer_Html;

var ButtonHandle  MacroCopy_Btn;
var ButtonHandle  Close_Btn;

var TextureHandle SlotGroupBoxBg_Tex;

var array<int> macroPresetIDArray;

//------------------------------------------------------------------------------------------------------------
// Init  
//------------------------------------------------------------------------------------------------------------
function OnRegisterEvent()
{
	//RegisterEvent(  );
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function OnShow()
{
	Debug("Show updateMacroPreset");
	updateMacroPreset();
}

// â�� �������� ������ ��ũ�� ��ũ��Ʈ �����͸� ������ �����Ѵ�.
function updateMacroPreset()
{
	local int i;
	local MacroPresetInfo mPresetInfo;

	local ItemInfo	infItem;
	
	macroPresetIDArray.Length = 0;
	class'UIDATA_MACRO'.static.GetMacroPresetIDs(macroPresetIDArray);

	Debug("macroPresetIDArray" @ macroPresetIDArray.Length);

	MacroItem_ItemWnd.Clear();

	for(i = 0; i < macroPresetIDArray.Length; i++)
	{
		class'UIDATA_MACRO'.static.GetMacroPresetInfo(macroPresetIDArray[i], mPresetInfo);
		infItem.Name = mPresetInfo.Name;
		infItem.AdditionalName = mPresetInfo.IconName;
		infItem.Id.ClassID = mPresetInfo.Id;

		infItem.Description = mPresetInfo.Description;

		infItem.IconName = mPresetInfo.IconTextureName;
		infItem.ShortcutType = int(EShortCutItemType.SCIT_MACRO);

		// �ӽ÷� html ���� �ֱ�.
		infItem.IconNameEx4 = mPresetInfo.PresetDescription;

		infItem.MacroCommand = macroCommandArrayToString(mPresetInfo);

		MacroItem_ItemWnd.AddItem(infItem);

		// ù��°�� ������ ���õǵ���.. (���ʿ�)
		if(i == 0 && mPresetInfo.PresetDescription != "")
		{
			MacroItem_ItemWnd.SetSelectedNum(0);
			Debug("html open :" @ GetLocalizedL2TextPathNameUC() $ mPresetInfo.PresetDescription);
			PresetViewer_Html.LoadHtml(GetLocalizedL2TextPathNameUC() $ mPresetInfo.PresetDescription);
		}
	}
}

// �ʱ�ȭ
function Initialize()
{
	Me = GetWindowHandle("MacroPresetWnd");

	MacroItem_ItemWnd = GetItemWindowHandle("MacroPresetWnd.MacroItem_ItemWnd");
	PresetViewer_Html = GetHtmlHandle("MacroPresetWnd.PresetViewer_Html");

	Close_Btn     = GetButtonHandle("MacroPresetWnd.Close_Btn");
	MacroCopy_Btn = GetButtonHandle("MacroPresetWnd.MacroCopy_Btn");
}

//------------------------------------------------------------------------------------------------------------
// ��Ʈ�� �ڵ鷯  
//------------------------------------------------------------------------------------------------------------
function OnClickButton(string Name)
{
	switch(Name)
	{
		case "MacroCopy_Btn":
		 	 OnMacroCopy_BtnClick();
			 break;

		case "Close_Btn":
			 OnClose_BtnClick();
			 break;
	}
}

// ������ ��ũ�� ī�� 
function OnMacroCopy_BtnClick(optional int gfxSystemMessageNum)
{
	local int selectedNum;
	local ItemInfo info;

	selectedNum = MacroItem_ItemWnd.GetSelectedNum();

	if (selectedNum > -1)
	{
		MacroItem_ItemWnd.GetItem(selectedNum, info);

		// ������
		if (info.MacroCommand != "")
		{
			if (gfxSystemMessageNum > 0)
			{
				AddSystemMessage(gfxSystemMessageNum);
			}
			else
			{
				// 4399    ��ũ�� ������ Ŭ������� ����Ǿ����ϴ�
				AddSystemMessage(4399);
			}

			ClipboardCopy(info.MacroCommand);
			Debug("Ŭ������ ī��:" @ info.MacroCommand);
		}
		else
		{
			Debug("Ŭ������ ī���Ұ� ����..");
		}
	}
}

// �ݱ�
function OnClose_BtnClick()
{
	Me.HideWindow();
}

// ������ ������ ������ Ŭ��
function OnClickItem( String strID, int index )
{
	local ItemInfo info;

	if(strID == "MacroItem_ItemWnd")
	{
		if(index > -1)
		{
			MacroItem_ItemWnd.SetSelectedNum(index);
			MacroItem_ItemWnd.GetItem(index, info);
			// IconNameEx4�� �ӽ÷� html ��θ� �־� �ξ���.
			if(info.IconNameEx4 != "")
			{
				PresetViewer_Html.LoadHtml(GetLocalizedL2TextPathNameUC() $ Info.IconNameEx4);
			}
		}
	}
}

// ������ ������ ���� Ŭ��
// QA���̶� �̾߱� �ϴٰ� �־� �ָ� ���� ������� �־���. �غ��� �����ϸ� ���� ��.
function OnDBClickItem( String strID, int index )
{
	local ItemInfo info;

	if (strID == "MacroItem_ItemWnd")
	{
		if (GetWindowHandle("MacroEditWnd").IsShowWindow())
		{
			// ��ũ�� ī�� �� ���̱�, 4401 �� ���̱� �ߴٴ� �ý��� �޼���
			OnMacroCopy_BtnClick(4401);

			// Ŭ�� ���� ���̱�
			MacroItem_ItemWnd.GetItem(index, info);

			// MacroEditWnd(GetScript("MacroEditWnd")).removeAllEditBox();

			// ��ũ�� ������, �̸�, ª���̸�, ������ ������ ������ ����.
			MacroEditWnd(GetScript("MacroEditWnd")).setEditMacroInfo(info.Name, info.IconName);

			// ���̱�
			MacroEditWnd(GetScript("MacroEditWnd")).pastByClipboard(false);
			Debug("��ü ������ ���̱� �õ�");
		}
		else
		{
			Debug("������ â�� ���� �־ ���̱� ����.");
		}
	}
}

//------------------------------------------------------------------------------------------------------------
// ��ƿ 
//------------------------------------------------------------------------------------------------------------
// ��ũ�� ����ü�� �޾Ƽ�, �ȿ� ��� �ִ� ��ũ�� �溸�� \n ������ ������ �ϳ��� ���ڿ��� �����.
function string macroCommandArrayToString(out MacroPresetInfo mPresetInfo)
{
	local string commandString;
	local int i;

	for(i = 0; i < MACROCOMMAND_MAX_COUNT; i++)
	{
		if(mPresetInfo.CommandList[i] != "")
		{
			commandString = commandString $ mPresetInfo.CommandList[i] $ Chr(13);
		}
	}

	// ������ \n �ڵ� ����
	if(Len(commandString) > 0)
	{
		commandString = Left(commandString, Len(commandString) - 1);
	}

	return commandString;
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(Self))).HideWindow();
}

defaultproperties
{
}
