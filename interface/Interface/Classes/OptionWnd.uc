class OptionWnd extends L2UIGFxScript;
// �� �ɼ� 


//option
const PARTY_MODIFY_REQUEST = 9;
//const OPTION_CHANGE = 1 ;

//key Dialog
const DIALOGID_proc1 = 10;
const DIALOGID_proc2 = 11;
const DIALOGID_proc3 = 12;
const DIALOGID_proc4 = 13;

const ID_CALL_DIALOG = 10;
const ID_EXEC_FUNCTION = 11;
const ID_OPENWINDOW = 12;

//shaderBuild���� �� ���� ��
var bool m_bL2Shader;
var bool m_AntiAliasing;
var bool m_bDOF ;
//var bool m_bDepthBufferShadow;

var int g_CurrentMaxWidth;
var int g_CurrentMaxHeight;
var int nPixelShaderVersion;
var int nVertexShaderVersion;

var bool isGAMINGSTATE;

var DialogBox	dScript;

var bool bPartyMember;
var bool bPartyMaster;

var	FlightShipCtrlWnd			scriptShip;
var	FlightTransformCtrlWnd		scriptTrans;

var array<string> m_datasheetKeyReplace;
var array<string> m_datasheetKeyReplaced;

var bool isOpenShortCut;

var WindowHandle	m_hPartyMatchWnd;
var WindowHandle	m_hUnionMatchWnd;

// �Ʒ������� ������ enterchatting ���� ��ȯ�Ѵ�. �� �� �ӽ÷� ���� ��带 ���� ��.
var bool preEnterChattingOption;

delegate DelegateOnChangeShortcut();

function OnRegisterEvent()
{
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);

	//RegisterGFxEvent(EV_ResolutionChanged);//�޺��ڽ� �ݱ����� �߰�

	RegisterEvent(EV_StateChanged);
	//RegisterGFxEvent(EV_StateChanged);
	RegisterEvent(EV_AskPartyLootingModify);
	RegisterEvent(EV_PartyLootingHasModified);
	RegisterEvent(EV_PartyHasDismissed);//��Ƽ�� ��ü�Ǿ���
	RegisterEvent(EV_OustPartyMember); //��Ƽ���� �߹������
	RegisterEvent(EV_BecamePartyMember); //��Ƽ�� ����� ��
	RegisterEvent(EV_BecamePartyMaster); //��Ƽ���̵�
	RegisterEvent(EV_HandOverPartyMaster); //��Ƽ���� �絵��
	RegisterEvent(EV_RecvPartyMaster); //��Ƽ���� �絵����
// 	RegisterEvent(EV_PartyMatchRoomStart); //��Ƽ�����̵�

 	RegisterEvent(EV_PartyMatchRoomClose); //��Ƽ�����
	RegisterEvent(EV_Restart);

	RegisterEvent(EV_WithdrawParty); //��Ƽ���� Ż����
	RegisterEvent(EV_PartyMemberChanged);
	RegisterEvent(EV_ShortcutDataReceived);
	//RegisterGFxEvent(EV_ShowAllStateInfoChanged); //�׼ſ��� ���� ���� ���� ���⸦ ���� ų ��� > ���� ������ ����� 
	RegisterGFxEvent(EV_SetShowAllStateInfo); //�׼ſ��� ���� ���� ���� ���⸦ ���� ų ���
	RegisterGFxEvent(EV_OptionWndShow);
	RegisterGFxEvent(EV_MinFrameRateChanged);
	RegisterGFxEvent(EV_SetFullScreenCheck);

	//////////// ���� ���� �̺�Ʈ ��
	RegisterGFxEvent(EV_ShortcutInit);
	RegisterGFxEvent(EV_ShortcutDataReceived);

	//RegisterGFxEvent(EV_ReceiveWindowsInfo);

	RegisterGFxEvent(EV_ReceiveChatFilter);

	RegisterGFxEvent(EV_CuriousHouseEnter); //9320
	RegisterGFxEvent(EV_CuriousHouseLeave); //9330
	RegisterGFxEvent(EV_NextTargetModeChange); 

	//SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, FLASH_XPOS, FLASH_YPOS);
	
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_ITEM_ANNOUNCE_SETTING));
	RegisterGFxEvent(EV_DisplayChanged);
}
//=================================================================================
// Function : LoadAudioOption()
//
// Description :
//	* Reads option.ini file, and apply audio options.
//	* There is no need to apply options here for the options that share key between
//	  script and native code.(e.g. Video.Gamma)
//	* On the other hand, options that do not share key between script and native code
//	  MUST be applied here.(e.g. Video.L2Shader)
//	* This function MUST be called when loading the game. Otherwise, some of the
//	  options in option.ini will not be applied to the game.
//
// Revision History
//	* 2007/11/16 NeverDie: Created
//---------------------------------------------------------------------------------
function LoadAudioOption()
{
	local bool bMute;		// Audio mute
	local bool bBackgroundBute;

	// If device does not support audio, it's ok to simply ignore audio options
	if(CanUseAudio())
	{
		// We only need to apply "Mute" option, because keys for volumes are shared between script and native code.
		bMute = GetOptionBool("Audio", "AudioMuteOn");
		SetOptionBool("Audio", "AudioMuteOn", bMute);
		bBackgroundBute = GetOptionBool("Audio","AudioFocusOn");
		SetOptionBool("Audio","AudioFocusOn",bBackgroundBute);
	}
}

//=================================================================================
// Function : LoadVideoOption()
//
// Description :
//	* Reads option.ini file, and apply video options.
//	* There is no need to apply options here for the options that share key between
//	  script and native code.(e.g. Video.Gamma)
//	* On the other hand, options that do not share key between script and native code
//	  MUST be applied here.(e.g. Video.L2Shader)
//	* This function MUST be called when loading the game. Otherwise, some of the
//	  options in option.ini will not be applied to the game.
//
// Revision History
//	* 2007/11/16 NeverDie: Created
//---------------------------------------------------------------------------------
function LoadVideoOption()
{
	local bool bKeepMinFrameRate; // Min frame rate
	local int TerrainClippingRange;

	bKeepMinFrameRate = GetOptionBool("Video", "IsKeepMinFrameRate");
	TerrainClippingRange = GetOptionInt("Video", "TerrainClippingRange");
	// End:0x9E
	if(TerrainClippingRange <= 0)
	{
		SetOptionInt("Video", "TerrainClippingRange", 1);
		// End:0x94
		if(bKeepMinFrameRate)
		{
			SetTerrainClippingRange(3);			
		}
		else
		{
			SetTerrainClippingRange(1);
		}		
	}
	else
	{
		// End:0xD7
		if(TerrainClippingRange >= 4)
		{
			SetOptionInt("Video", "TerrainClippingRange", 3);
			SetTerrainClippingRange(3);
		}
	}
	// Shader option should be set only when "KeepMinFrameRate" option is off
	m_bL2Shader = GetOptionBool("Video", "L2Shader");
	m_AntiAliasing = GetOptionBool("Video", "YebisAntiAliasing");
	m_bDOF = GetOptionBool("Video", "YebisDOF");
	// End:0x19A
	if(! bKeepMinFrameRate)
	{
		// If current driver doesn't support Shader 3.0, there is no need to set Shader 3.0 options
		if(nPixelShaderVersion >= 30 && nVertexShaderVersion >= 30)
		{
			// Apply Shader 3.0 config			
			SetYebisAntialiasing(m_AntiAliasing);
			SetYebisDOF(m_bDOF);
			SetL2Shader(m_bL2Shader);

			// DOF, WaterEffect, Shadow depend on L2Shader option. Set them only when bL2Shader is on.
			//if(m_bL2Shader)
			//{
				// Apply Shader 3.0 Depth of Field				
				//SetDOF(m_bDOF);

				// Apply Shader 3.0 Self shadow				
				// SetDepthBufferShadow(m_bDepthBufferShadow);
			//}
		}
	}
}

function LoadControlOption()
{
	local int iChecked;

	if(GetINIBool("Control", "RightClickBox", iChecked, "Option.ini"))
	{
		SetFixedDefaultCamera(iChecked == 1);		
	}
	else
	{
		SetOptionBool("Control", "RightClickBox", true);
		SetFixedDefaultCamera(true);
	}
	if(! GetINIBool("Control", "IsWheelreversed", iChecked, "Option.ini"))
	{
		SetOptionBool("Control", "IsWheelreversed", true);
	}	
}

function LoadChattingOption()
{
	local int iChecked;

	// End:0x77
	if(! GetINIBool("Global", "EnterChatting", iChecked, "ChatFilter.ini"))
	{
		class'ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
		SetChatFilterBool("Global", "EnterChatting", true);
	}	
}

//=================================================================================
// Function : LoadGameOption()
//
// Description :
//	* Reads option.ini file, and apply game options.
//	* There is no need to apply options here for the options that share key between
//	  script and native code.(e.g. Video.Gamma)
//	* On the other hand, options that do not share key between script and native code
//	  MUST be applied here.(e.g. Video.L2Shader)
//	* This function MUST be called when loading the game. Otherwise, some of the
//	  options in option.ini will not be applied to the game.
//
// Revision History
//	* 2007/11/16 NeverDie: Created
//---------------------------------------------------------------------------------
function LoadGameOption()
{
	// Currently there is no options to load for the game tab.

	local int iChecked;

	/*
	 * ù ��ġ�� default �� ó�� 
	 */
	// �� Ÿ��Ʋ,
	if(!GetINIBool("ScreenInfo", "ShowZoneTitle", iChecked, "Option.ini")) 
		SetOptionBool("ScreenInfo", "ShowZoneTitle", true);
	// �ε� �� ������ ���� ����
	if(!GetINIBool("ScreenInfo", "ShowGameTipMsg", iChecked, "Option.ini")) 
		SetOptionBool("ScreenInfo", "ShowGameTipMsg", true);
}

function OnLoad()
{
	SetSaveWnd(true,false);
	//SetClosingOnESC();
	SetContainerWindow(WINDOWTYPE_DECO_NORMAL, 205);
	AddState("GAMINGSTATE");
	AddState("LOGINSTATE");
	AddState("PAWNVIEWERSTATE");
	AddState("ARENAGAMINGSTATE");
	AddState("ARENABATTLESTATE");
	SetOptionBool("ScreenInfo", "HideDropItem", false);
	GetShaderVersion(nPixelShaderVersion, nVertexShaderVersion);
	LoadVideoOption();
	LoadAudioOption();
	LoadControlOption();
	LoadGameOption();
	LoadChattingOption();
	DataSheetAssignKeyReplacement();

	scriptShip = FlightShipCtrlWnd(GetScript("FlightShipCtrlWnd"));
	scriptTrans = FlightTransformCtrlWnd(GetScript("FlightTransformCtrlWnd"));

	m_hPartyMatchWnd = GetWindowHandle("PartyMatchWnd");
	m_hUnionMatchWnd = GetWindowHandle("UnionMatchWnd");
	SetReflectionEffect(0);
	if(nVertexShaderVersion >= 20)
	{
		SetOptionBool("Video", "GPUAnimation", true);
	}
	setChattingOption();
//	Debug("** option onLoad");
}


/* Referenced by: OnLoad()
 * Description: 
 * 	Datasheet contains key name data to replace system key name to user readable names.
 */
function DataSheetAssignKeyReplacement()
{
	m_datasheetKeyReplace[1] = "LEFTMOUSE";
	m_datasheetKeyReplace[2] = "RIGHTMOUSE";
	m_datasheetKeyReplace[3] = "BACKSPACE";
	m_datasheetKeyReplace[4] = "ENTER";
	m_datasheetKeyReplace[5] = "SHIFT";
	m_datasheetKeyReplace[6] = "CTRL";
	m_datasheetKeyReplace[7] = "ALT";
	m_datasheetKeyReplace[8] = "PAUSE";
	m_datasheetKeyReplace[9] = "CAPSLOCK";
	m_datasheetKeyReplace[10] = "ESCAPE";
	m_datasheetKeyReplace[11] = "SPACE";
	m_datasheetKeyReplace[12] = "PAGEUP";
	m_datasheetKeyReplace[13] = "PAGEDOWN";
	m_datasheetKeyReplace[14] = "END";
	m_datasheetKeyReplace[15] = "HOME";
	m_datasheetKeyReplace[16] = "LEFT";
	m_datasheetKeyReplace[17] = "UP";
	m_datasheetKeyReplace[18] = "RIGHT";
	m_datasheetKeyReplace[19] = "DOWN";
	m_datasheetKeyReplace[20] = "SELECT";
	m_datasheetKeyReplace[21] = "PRINT";
	m_datasheetKeyReplace[22] = "PRINTSCRN";
	m_datasheetKeyReplace[23] = "INSERT";
	m_datasheetKeyReplace[24] = "DELETE";
	m_datasheetKeyReplace[25] = "HELP";
	m_datasheetKeyReplace[26] = "NUMPAD0";
	m_datasheetKeyReplace[27] = "NUMPAD1";
	m_datasheetKeyReplace[28] = "NUMPAD2";
	m_datasheetKeyReplace[29] = "NUMPAD3";
	m_datasheetKeyReplace[30] = "NUMPAD4";
	m_datasheetKeyReplace[31] = "NUMPAD5";
	m_datasheetKeyReplace[32] = "NUMPAD6";
	m_datasheetKeyReplace[33] = "NUMPAD7";
	m_datasheetKeyReplace[34] = "NUMPAD8";
	m_datasheetKeyReplace[35] = "NUMPAD9";
	m_datasheetKeyReplace[36] = "GREYSTAR";
	m_datasheetKeyReplace[37] = "GREYPLUS";
	m_datasheetKeyReplace[38] = "SEPARATOR";
	m_datasheetKeyReplace[39] = "GREYMINUS";
	m_datasheetKeyReplace[40] = "NUMPADPERIOD";
	m_datasheetKeyReplace[41] = "GREYSLASH";
	m_datasheetKeyReplace[42] = "NUMLOCK";
	m_datasheetKeyReplace[43] = "SCROLLLOCK";
	m_datasheetKeyReplace[44] = "UNICODE";
	m_datasheetKeyReplace[45] = "SEMICOLON";
	m_datasheetKeyReplace[46] = "EQUALS";
	m_datasheetKeyReplace[47] = "COMMA";
	m_datasheetKeyReplace[48] = "MINUS";
	m_datasheetKeyReplace[49] = "SLASH";
	m_datasheetKeyReplace[50] = "TILDE";
	m_datasheetKeyReplace[51] = "LEFTBRACKET";
	m_datasheetKeyReplace[52] = "BACKSLASH";
	m_datasheetKeyReplace[53] = "RIGHTBRACKET";
	m_datasheetKeyReplace[54] = "SINGLEQUOTE";
	m_datasheetKeyReplace[55] = "PERIOD";
	m_datasheetKeyReplace[56] = "MIDDLEMOUSE";
	m_datasheetKeyReplace[57] = "MOUSEWHEELDOWN";
	m_datasheetKeyReplace[58] = "MOUSEWHEELUP";
	m_datasheetKeyReplace[59] = "UNKNOWN16";
	m_datasheetKeyReplace[60] = "UNKNOWN17";
	m_datasheetKeyReplace[61] = "BACKSLASH";
	m_datasheetKeyReplace[62] = "UNKNOWN19";
	m_datasheetKeyReplace[63] = "UNKNOWN5C";
	m_datasheetKeyReplace[64] = "UNKNOWN5D";
	m_datasheetKeyReplace[65] = "UNKNOWN0C";
	m_datasheetKeyReplaced[1] = GetSystemString(1670);
	m_datasheetKeyReplaced[2] = GetSystemString(1671);
	m_datasheetKeyReplaced[3] = GetSystemString(1517);
	m_datasheetKeyReplaced[4] = "Enter";
	m_datasheetKeyReplaced[5] = "Shift";
	m_datasheetKeyReplaced[6] = "Ctrl";
	m_datasheetKeyReplaced[7] = "Alt";
	m_datasheetKeyReplaced[8] = "Pause";
	m_datasheetKeyReplaced[9] = "CapsLock";
	m_datasheetKeyReplaced[10] = "ESC";
	m_datasheetKeyReplaced[11] = GetSystemString(1672);
	m_datasheetKeyReplaced[12] = "PageUp";
	m_datasheetKeyReplaced[13] = "PageDown";
	m_datasheetKeyReplaced[14] = "End";
	m_datasheetKeyReplaced[15] = "Home";
	m_datasheetKeyReplaced[16] = "Left";
	m_datasheetKeyReplaced[17] = "Up";
	m_datasheetKeyReplaced[18] = "Right";
	m_datasheetKeyReplaced[19] = "Down";
	m_datasheetKeyReplaced[20] = "Select";
	m_datasheetKeyReplaced[21] = "Print";
	m_datasheetKeyReplaced[22] = "PrintScrn";
	m_datasheetKeyReplaced[23] = "Insert";
	m_datasheetKeyReplaced[24] = "Delete";
	m_datasheetKeyReplaced[25] = "Help";
	m_datasheetKeyReplaced[26] = GetSystemString(1657);
	m_datasheetKeyReplaced[27] = GetSystemString(1658);
	m_datasheetKeyReplaced[28] = GetSystemString(1659);
	m_datasheetKeyReplaced[29] = GetSystemString(1660);
	m_datasheetKeyReplaced[30] = GetSystemString(1661);
	m_datasheetKeyReplaced[31] = GetSystemString(1662);
	m_datasheetKeyReplaced[32] = GetSystemString(1663);
	m_datasheetKeyReplaced[33] = GetSystemString(1664);
	m_datasheetKeyReplaced[34] = GetSystemString(1665);
	m_datasheetKeyReplaced[35] = GetSystemString(1666);
	m_datasheetKeyReplaced[36] = "*";
	m_datasheetKeyReplaced[37] = "+";
	m_datasheetKeyReplaced[38] = "Separator";
	m_datasheetKeyReplaced[39] = "-";
	m_datasheetKeyReplaced[40] = ".";
	m_datasheetKeyReplaced[41] = "/";
	m_datasheetKeyReplaced[42] = "NumLock";
	m_datasheetKeyReplaced[43] = "ScrollLock";
	m_datasheetKeyReplaced[44] = "Unicode";
	m_datasheetKeyReplaced[45] = ";";
	m_datasheetKeyReplaced[46] = "=";
	m_datasheetKeyReplaced[47] = ",";
	m_datasheetKeyReplaced[48] = "-";
	m_datasheetKeyReplaced[49] = "/";
	m_datasheetKeyReplaced[50] = "`";
	m_datasheetKeyReplaced[51] = "[";
	m_datasheetKeyReplaced[52] = "";
	m_datasheetKeyReplaced[53] = "]";
	m_datasheetKeyReplaced[54] = "'";
	m_datasheetKeyReplaced[55] = ".";
	m_datasheetKeyReplaced[56] = GetSystemString(1669);
	m_datasheetKeyReplaced[57] = GetSystemString(1667);
	m_datasheetKeyReplaced[58] = GetSystemString(1668);
	m_datasheetKeyReplaced[59] = "-";
	m_datasheetKeyReplaced[60] = "=";
	m_datasheetKeyReplaced[61] = GetSystemString(1676);
	m_datasheetKeyReplaced[62] = GetSystemString(1673);
	m_datasheetKeyReplaced[63] = GetSystemString(1674);
	m_datasheetKeyReplaced[64] = GetSystemString(1675);
	m_datasheetKeyReplaced[65] = GetSystemString(1677);
}

/* Referenced by: HandleUpdateGeneralKeyListControl()
 * Description: Returns user readable key name with system key names.
 */
function String GetUserReadableKeyName(String input)
{
	local int i;
	local String output;
	for(i= 0 ; i < m_datasheetKeyReplace.Length ; ++i)
	{
		if(m_datasheetKeyReplace[i] == input)
			output = m_datasheetKeyReplaced[i];
	}
	if(output == "")
		output = input;
	return output;
}


function PartyLootingChanged(int selectedNum)
{
	if(bPartyMaster ||(IsRoomMaster()&& !bPartyMember))//��Ƽ�����ε� ��Ƽ���� �絵�ϴ� ��찡 �־
	{

		//���� ���ð� ������ �Ǽ����ϸ� ����.
		//����� ������ ���� �����̶� ��ġ�ϴ� ������ ��Ƽ�� �ʴ��Ҷ� ����� ������ ����ϰ�, 
		//������ ����ǵ� ������ �����ϱ� �����̴�.
		if(GetOptionInt("Communication", "PartyLooting")== selectedNum)return ;
		setEnableLootingBox(false);
		RequestPartyLootingModify(selectedNum); // ���ú����� ��û�Ѵ�.
	}
}

// ����ä������ �������ش�. 
/* Referenced by: OnClickCheckBox()
 * Description:
 * 	* Reads OptionBool "EnterChatting" and gets the chatting mode setting data.
 * 	* Clear current state key settings first.
 *	* Activate apparant key setting groups.
 *	* Check or CheckBox "Chk_EnterChatting".
 */
Function HandleSwitchEnterchatting()
{
	
	//local	MainMenu	scriptMain;
	local   bool         enableEnterChatting ;
	local   FlightTransformCtrlWnd  scriptFlgithForm;
	local   FlightShipCtrlWnd       scriptFlightShip;

	//���� ���� ���� ���¶�� ���� �Ѵ�.
	scriptFlgithForm = FlightTransformCtrlWnd(GetScript("FlightTransformCtrlWnd"));
	if(scriptFlgithForm.isNowActiveFlightTransShortcut)return;

	//���� ���� ž�� ���¶�� �����Ѵ�.
	scriptFlightShip = FlightShipCtrlWnd(GetScript("FlightShipCtrlWnd"));
	if(scriptFlightShip.isNowActiveFlightShipShortcut)return;
	
	//scriptMain = MainMenu(GetScript("MainMenu"));	
	//bEnterChat = GetOptionBool("CommunIcation", "EnterChatting");
	//~ ResetActivateKeyGroup();

	// defaultstate�� �ڵ� �ε� �ƾ�����, �Ʒ����� ���� �������� �ε� ��.
	//class'ShortcutAPI'.static.ActivateGroup("GamingStateShortcut");	
	
	
	class'ShortcutAPI'.static.ActivateGroup("GamingStateDefaultShortcut");	
	class'ShortcutAPI'.static.ActivateGroup("CameraControl");
	class'ShortcutAPI'.static.ActivateGroup("GamingStateGMShortcut");

	// �Ʒ��� ���������� ArenaGamingEnterChattingShortcut�� ���� �մϴ�. 
	if(getInstanceUIData().getIsArenaServer())
	{
		handleArenaShortCut();
		//class'ShortcutAPI'.static.ActivateGroup("ArenaGamingEnterChattingShortcut");
		preEnterChattingOption = GetChatFilterBool("Global", "EnterChatting");
		SetChatFilterBool("Global", "EnterChatting", true);
		enableEnterChatting = true;
		CallGFxFunction(getCurrentWindowName(String(self)), "onSwitchDisableEnterChatting", String(true));		
		// �ɼ� â����, disable, �� üũ ǥ�� �ʿ�
	}
	else if(GetChatFilterBool("Global", "EnterChatting"))
	{	
		class'ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
		SetChatFilterBool("Global", "EnterChatting", true);
		enableEnterChatting = true;
	}
	else
	{
		class'ShortcutAPI'.static.DeactivateGroup("TempStateShortcut");
		SetChatFilterBool("Global", "EnterChatting", false);
		enableEnterChatting = false;
	}
	CallGFxFunction(getCurrentWindowName(String(self)), "onSwitchEnterChatting", String(enableEnterChatting));
}

//function saveArenaShortcutList()
//{
//	local   ShortcutCommandItem     shortcutItem;

//	//	/************************************************************************* 
//	//	 * ����Ű ���� 
//	//	 **************************************************************************/
//		shortcutItem.sCommand = "getNextTarget";
//		shortcutItem.key = "TAB";
//		shortcutItem.subkey1 = "";
//		shortcutItem.subkey2 =  "";
//		shortcutItem.sState = "";
//		shortcutItem.sAction =  "Press";
//		//class'ShortcutAPI'.static.AssignCommand("ArenaGamingShortcut", shortcutItem);
//		class'ShortcutAPI'.static.AssignCommand("ArenaGamingEnterChattingShortcut", shortcutItem);

//		shortcutItem.sCommand = "getPrevTarget";
//		shortcutItem.key = "TAB";
//		shortcutItem.subkey1 = "Shift";
//		shortcutItem.subkey2 =  "";
//		shortcutItem.sState = "";
//		shortcutItem.sAction =  "Press";
//		//class'ShortcutAPI'.static.AssignCommand("ArenaGamingShortcut", shortcutItem);
//		class'ShortcutAPI'.static.AssignCommand("ArenaGamingEnterChattingShortcut", shortcutItem);

//		//shortcutItem.sCommand = "useRunSkill";
//		//shortcutItem.key = "F";
//		//shortcutItem.subkey1 = "Ctrl";
//		//shortcutItem.subkey2 =  "";
//		//shortcutItem.sState = "";
//		//shortcutItem.sAction =  "Press";
//		//class'ShortcutAPI'.static.AssignCommand("ArenaGamingShortcut", shortcutItem);

//		shortcutItem.sCommand = "useRunSkill";
//		shortcutItem.key = "F";
//		shortcutItem.subkey1 = "";
//		shortcutItem.subkey2 =  "";
//		shortcutItem.sState = "";
//		shortcutItem.sAction =  "Press";
//		class'ShortcutAPI'.static.AssignCommand("ArenaGamingEnterChattingShortcut", shortcutItem);

//		//shortcutItem.sCommand = "useBaseRecallSkill";
//		//shortcutItem.key = "B";
//		//shortcutItem.subkey1 = "Ctrl";qqqq
//		//shortcutItem.subkey2 =  "";
//		//shortcutItem.sState = "";
//		//shortcutItem.sAction =  "Press";
//		//class'ShortcutAPI'.static.AssignCommand("ArenaGamingShortcut", shortcutItem);

//		shortcutItem.sCommand = "useBaseRecallSkill";
//		shortcutItem.key = "B";
//		shortcutItem.subkey1 = "";
//		shortcutItem.subkey2 =  "";
//		shortcutItem.sState = "";
//		shortcutItem.sAction =  "Press";
//		class'ShortcutAPI'.static.AssignCommand("ArenaGamingEnterChattingShortcut", shortcutItem);

//		shortcutItem.sCommand = "ArenaSelectTarget";
//		shortcutItem.key = "SPACE";
//		shortcutItem.subkey1 = "";
//		shortcutItem.subkey2 =  "";
//		shortcutItem.sState = "";
//		shortcutItem.sAction =  "Press";
//		class'ShortcutAPI'.static.AssignCommand("ArenaGamingEnterChattingShortcut", shortcutItem);

//		class'ShortcutAPI'.static.Save();
//}

function ToggleOpenMeWnd(bool isShortCut)
{
	isOpenShortCut = isShortCut;

	if(IsShowWindow())
	{
		HideWindow();
	}
	else
	{
		ShowWindow();
	}
	
}

/* 
 * ���̾�α� �˽� ���� 
 */
function ShortCutReset()
{
	ActiveFlightShort(); //��������� ���Ʊ׷��� ��Ƽ������
	HandleSwitchEnterchatting();
	handleArenaShortCut();
	//���θ޴� ����Ű ����
	//sc = MainMenu(GetScript("MainMenu"));
	//sc.updateTooltip();	
}

event OnCallUCFunction(String funcName, String param)
{
	//Debug("onCallUCFunction" @ funcName @ param);
	switch(funcName)
	{
		case "ShortCutReset":
			ShortCutReset();
			MenuEntireWnd(GetScript("MenuEntireWnd")).refreshMenu();
			DelegateOnChangeShortcut();
			break;
		case "HandleSwitchEnterchatting":	//���� ä�� ����			
			HandleSwitchEnterchatting();
			MenuEntireWnd(GetScript("MenuEntireWnd")).refreshMenu();
			break;
		case "PartyLootingChanged":
			PartyLootingChanged(int(param));
			break;
		case "OnChangeShortCutKeyByOptionGfx":
			MenuEntireWnd(GetScript("MenuEntireWnd")).refreshMenu();
			DelegateOnChangeShortcut();
			break;
		//�Ǿ��� ����Ʈ â ���� Ű��
		case "SetPcRoomBoxData":
			SetPcRoomBoxData(bool(param));
			break;
		//���� â �������� 
		case "StateBoxShow":
			StateBoxShow(bool(param));
			break;
		case "handleShaderOptionChange":
			HandleShaderOptionChange();
			break;
		case "setChattingOption":
			setChattingOption();
			break;
		case "bAnonymity":
			API_C_EX_SAVE_ITEM_ANNOUNCE_SETTING(bool(param));
			break;
		case "showSoundContextMenu":
			HandleSelectAlarmType(param);
			break;
		case "ChatFontSizeSaved":
			HandleChatFontSizeSaved(param);
			break;
	}
}

/*
 * ��Ȯ�� ����� �� �� ������ 
 * shortcut ���� ��� ���̹Ƿ�, ���� ��
 */
function SetDefaultPositionByClick()
{
	GetCurrentResolution(g_CurrentMaxWidth, g_CurrentMaxHeight);
	SetDefaultPosition();
}

function _InitAudioOption()
{
	CallGFxFunction(getCurrentWindowName(string(self)), "InitAudioOption", "");	
}

function InitControlOption()
{
	CallGFxFunction(getCurrentWindowName(String(self)), "InitControlOption", "");
//	dispatchEventToFlash_Int(100 , 0);
}

function InitScreenInfoOption()
{
	CallGFxFunction(getCurrentWindowName(String(self)), "InitScreenInfoOption", "");
	//dispatchEventToFlash_Int(101 , 0);
} 

function StateBoxShow(bool bChecked)
{
	local TargetStatusWnd util;
	util = TargetStatusWnd(GetScript("TargetStatusWnd"));
	util.StateBoxShow(bChecked);
}

Function SetPcRoomBoxData(bool bOption)
{}


// ���� ���� Ȱ��ȭ 
function ActiveFlightShort()
{
	//local	MainMenu	                scriptMain;	
	
	//scriptMain = MainMenu(GetScript("MainMenu"));

	if(scriptShip.Me.IsShowWindow())	// ������ ���� �����϶�	// ������ ���� �׷��� ��Ƽ�� ���ش�. 
	{
		//scriptShip.preEnterChattingOption = GetOptionBool("Game", "EnterChatting");		//���� ����ä�� �ɼ��� �����صд�. 				
		SetChatFilterBool("Global", "EnterChatting", true);
		//SetOptionBool("CommunIcation", "EnterChatting", true);	//���� ���� ä��
		//dispatchEventToFlash_Int(200, 1); //���� ä�� üũ 		
		CallGFxFunction(getCurrentWindowName(String(self)), "onSwitchEnterChatting", String(true));
		//dispatchEventToFlash_Int(200, 2); //�𽺿��̺� 
		CallGFxFunction(getCurrentWindowName(String(self)), "onSwitchDisableEnterChatting", String(true));			
		class'ShortcutAPI'.static.ActivateGroup("FlightStateShortcut");		//���� �׷� ����	
		//scriptMain.changeEnterChat("FlightStateShortcut");
		scriptShip.updateLockButton();	// ��� ���¸� ������Ʈ �Ѵ�. 			
			
		//scriptShip.ChatEditBox.ReleaseFocus();
	}
	else if(scriptTrans.Me.IsShowWindow())
	{
		//scriptTrans.preEnterChattingOption = GetOptionBool("Game", "EnterChatting");		//���� ����ä�� �ɼ��� �����صд�. 		
		SetChatFilterBool("Global", "EnterChatting", true);		
		//SetOptionBool("CommunIcation", "EnterChatting", true);	//���� ���� ä��
		//dispatchEventToFlash_Int(200, 1); //���� ä�� üũ 
		CallGFxFunction(getCurrentWindowName(String(self)), "onSwitchEnterChatting", String(true));
		//dispatchEventToFlash_Int(200, 2); //���� ä�� �𽺿��̺�
		CallGFxFunction(getCurrentWindowName(String(self)), "onSwitchDisableEnterChatting", String(true));
		
		
		scriptTrans.updateLockButton();	// ��� ���¸� ������Ʈ �Ѵ�. 
		class'ShortcutAPI'.static.ActivateGroup("FlightTransformShortcut");	//���� �׷� ����
//		scriptMain.changeEnterChat("FlightTransformShortcut");
	}
}

/*
 * ���� ���̴� ���� ������Ʈ�� �ΰ�
 * �� ��Ʈ��Ʈ �� �ɼ� ���� �ϰ� ���� �߾���
 * �׷��� �ϱ� ���� shader ��� ���� �� �ɼ� ���� �� ���� ��Ƽ� ó�� ��.
 */
function HandleShaderOptionChange()
{
	//local RadarMapWnd sc;
	//sc = RadarMapWnd(GetScript("RadarMapWnd"));
	
	//sc.setButtonInfo();

	//�߰� �κ�
	m_bL2Shader = GetOptionBool("Video", "L2Shader");
	m_AntiAliasing = GetOptionBool("Video", "YebisAntialiasing");
	m_bDOF = GetOptionBool("Video", "YebisDOF");

	//���̴� ���� ������Ʈ ���� �ɼ� ����	
	SetYebisDOF(m_bDOF);
	SetYebisAntialiasing(m_AntiAliasing);
	SetL2Shader(m_bL2Shader);
	if(!m_bL2Shader)
		SetReflectionEffect(0);
	//SetUIState("ShaderBuildState");
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case EV_DialogOK:
			HandleDialogResult(true);
			break;
		case EV_DialogCancel:
			HandleDialogResult(false);
			break;
		case EV_StateChanged :
			UIActivationUponStateChanges(a_Param);// �α��ν� ���� �Ҵ��� �����ϵ��� Ȱ��ȭ���ش�. 		
			
		break;
		/////��Ƽ���ð��� �̺�Ʈ//////////////////jdh84
		case EV_AskPartyLootingModify: //��Ƽ���ú��� ��û ����
			OnAskPartyLootingModify(a_Param);
			break;
		
		case EV_PartyLootingHasModified: //��Ƽ���ú��� ��� �˷���
			OnPartyLootingHasModified(a_Param);
			break;

		case EV_WithdrawParty: //Ż���ϰų�
		case EV_OustPartyMember: //�߹���ϰų�
		case EV_PartyHasDismissed: //��Ƽ�� �ػ�ɶ�
			bPartyMember = false;
			bPartyMaster = false;
			OnPartyHasDismissed();
//			Debug("��Ƽ�� Ż��, �߹�, �ػ� ������ ����� ");
			break;
		case EV_BecamePartyMember://��Ƽ�� �������
			bPartyMember = true;
			bPartyMaster = false;
			OnBecamePartyMember(a_Param);
//			Debug("��Ƽ ����� ����");
			break;
		case EV_BecamePartymaster://��Ƽ���̵�		
			bPartyMember = false;
			bPartyMaster = true;
			OnBecamePartyMaster(a_Param);
//			Debug("��Ƽ ��!�� ����");
			break;
		case EV_HandOverPartyMaster: //��Ƽ���� �絵��
			bPartyMember = true;
			bPartyMaster = false;
			OnHandOverPartyMaster();
			
			//����� �߰� - 2013-03-29 < ���ո�Ī, ��Ƽ��Ī�̺�Ʈ�� �ش� â���� ���� �ʾƼ� �̰����� ���� >
			//��Ƽ��Ī������, ���ո�Ī������ â ����			
			if(m_hPartyMatchWnd.IsShowWindow()==true)
			{
				m_hPartyMatchWnd.HideWindow();
			}
			if(m_hUnionMatchWnd.IsShowWindow()==true)
			{
				m_hUnionMatchWnd.HideWindow();
			}
			//Debug("��Ƽ���� �絵! ��");
			break;
		case EV_RecvPartyMaster: //��Ƽ���� �絵����
			bPartyMember = false;
			bPartyMaster = true;
			OnRecvPartyMaster();
			//Debug("��Ƽ���� �絵! ����!");
			break;
		case EV_Restart: //����ŸƮ
			bPartyMember = false;
			bPartyMaster = false;
			OnRestart();
			break;
	// 	case EV_PartyMatchRoomStart:
	// 		bPartyRoomMaster = true;
	// 		break;
 		case EV_PartyMatchRoomClose:
			OnPartyMatchRoomClose();
 			break;
		case EV_ShortcutDataReceived :
			handleArenaShortCut();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_ITEM_ANNOUNCE_SETTING):
			ParsePacket_S_EX_ITEM_ANNOUNCE_SETTING();
			break;
	}
}

function ParsePacket_S_EX_ITEM_ANNOUNCE_SETTING()
{
	local UIPacket._S_EX_ITEM_ANNOUNCE_SETTING packet;

	if(!Class'UIPacket'.static.Decode_S_EX_ITEM_ANNOUNCE_SETTING(packet))
		return;
	SetOptionBool("Communication","bAnonymity",packet.bAnonymity == 1);
}

/*
 * 1. stateChange �� 
 * 2. HandleSwitchEnterchatting ���� ����Ű Active �ϰ�
 * 3. requestList ������ ����Ű ����Ʈ�� ��û
 * 4. ����Ű ����Ʈ�� ������ �Ʒ����� �� ��� saveArenaShortcutList �� ����Ű ����
 * 5. active ���ش�.
 * 
 * 6. ������ ������ �ѹ��� ���� ��� EV_ShortcutDataReceived �� ������ �ʴ´�. �� ���� ������ �� ��� ��.
 * 7. ShortCutReset �ÿ��� .���� �Ѵ�.
 */
function handleArenaShortCut()
{
	local string stateName;
	stateName = GetGameStateName();
	
	if(stateName =="ARENAGAMINGSTATE" || stateName =="ARENABATTLESTATE" || stateName =="ARENAPICKSTATE" || stateName == "ARENAOBSERVERSTATE")
	{
		//saveArenaShortcutList();
		class'ShortcutAPI'.static.ActivateGroup("ArenaGamingShortcut");
		class'ShortcutAPI'.static.ActivateGroup("ArenaGamingEnterChattingShortcut");
	}
}


///////////////���ݺ��� ��Ƽ���ú��� ���� �ڵ尡 ���ϴ�//////////////////////////////////////////////////////////////////////////////////////////
//
//		��Ƽ������ �ɼ�â���� �����ϴ� ����� ���⿡�� �־���
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// ���̾�α� ���
function HandleDialogResult(bool bOk)
{	
	//local MainMenu sc;	
	local DialogBox dialogBoxScript;

	dialogBoxScript = DialogBox(GetScript("DialogBox"));

	// Debug("HandleDialogResult-" @ string(Self));

//	if(class'UICommonAPI'.static.DialogIsOwnedBy(string(Self))|| class'UICommonAPI'.static.DialogIsBeforeOwnedBy(string(Self)))
	if(class'UICommonAPI'.static.DialogIsOwnedBy(string(Self)))
	{
		//Debug("dialogBoxScript.isProgressBarWorking()" @ dialogBoxScript.isProgressBarWorking());
		//Debug("dialogBoxScript.getTryCancelDialogID()" @ dialogBoxScript.getTryCancelDialogID());
		//Debug("dialogBoxScript.DialogGetID()" @ dialogBoxScript.DialogGetID());
		
		//Debug( "HandleDialogResult" @ dialogBoxScript.checkCancelDialogID(PARTY_MODIFY_REQUEST) @ dialogBoxScript.DialogGetID());

		if(dialogBoxScript.DialogGetID()== PARTY_MODIFY_REQUEST)SetRequestPartyLootingModifyAgreement(bOk);
		
		//// ĵ���϶� 
		//if(bOk == false)
		//{
		//	if(dialogBoxScript.checkCancelDialogID(PARTY_MODIFY_REQUEST))
		//	{
				
		//		SetRequestPartyLootingModifyAgreement(bOk);
		//	}
		//}
		//else
		//{
		//	// ok�ϋ�
		//	if(dialogBoxScript.DialogGetID()== PARTY_MODIFY_REQUEST)
		//	{
		//		SetRequestPartyLootingModifyAgreement(bOk);
		//	}	
		//}
	}
}

function setEnableLootingBox(bool bEnable)
{
	/*
	local int enableNum;
	if(bEnable)enableNum = 1 ;
	else enableNum = 0;
*/

	CallGFxFunction(getCurrentWindowName(String(self)), "setEnableLootingBox", String(bEnable));
	//dispatchEventToFlash_Int(80, enableNum);
}

function setLootingBoxSelection(int SelectNum)
{
	CallGFxFunction(getCurrentWindowName(String(self)), "setLootingBoxSelection", string(SelectNum));
	//dispatchEventToFlash_Int(81, SelectNum);
}

function saveLootingBoxSelection()
{
	CallGFxFunction(getCurrentWindowName(String(self)), "saveLootingBoxSelection", "");
	//dispatchEventToFlash_Int(82, 0);
}

function SetRequestPartyLootingModifyAgreement(bool bOK)//��Ƽ���ú��� ����â 
{
	if(bOK)RequestPartyLootingModifyAgreement(1); // ���� 
	else 
	{
		//��ư ������ Ȯ��, ��� �� ���� �� ��ҿ��� �� �ִ� �� �𸣰���.
		dScript.SetButtonName(1337, 1342);		
		RequestPartyLootingModifyAgreement(0); //������ Ȥ�� Ÿ�Ӿƿ�
	}
}

function OnPartyMatchRoomClose()
{	
	if(!bPartyMember && !bPartyMaster)
		setLootingBoxSelection(GetOptionInt("Communication", "PartyLooting"));
}

function OnPartyHasDismissed()
{
	setLootingBoxSelection(GetOptionInt("Communication", "PartyLooting"));
	setEnableLootingBox(true);
	
	//��Ƽ�� ����,Ż��,�߹�Ǹ� �ڽ��� ������ ���ù������ ���ư���. 
	//��Ƽ�嵵 ��������(���ú���� ��Ƽ���� ����ȴ�)
}


function OnBecamePartyMember(string a_Param)//��Ƽ���� ��
{
	local int Lootingtype;
	ParseInt(a_Param, "Lootingtype", Lootingtype);
	setLootingBoxSelection(Lootingtype); //����Ÿ���� ��Ƽ����󰣴�. ������ ���� �ʴ´�
	setEnableLootingBox(false);
}

function OnBecamePartyMaster(string a_Param)//��Ƽ���̵�
{
	local int Lootingtype;
	ParseInt(a_Param, "Lootingtype", Lootingtype);
	setLootingBoxSelection(Lootingtype);
	setEnableLootingBox(true);
}

function OnHandOverPartyMaster()//��Ƽ���� �絵��
{
	setEnableLootingBox(false);
}

function OnRecvPartyMaster() //��Ƽ���� �絵����
{

	saveLootingBoxSelection();//������ �Ǹ� �������� �����Ѵ�. ���������
	setEnableLootingBox(true);
}

event OnRestart()
{
	//dispatchEventToFlash_Int(1);
	//������ �ʱ�ȭ ��.
	setLootingBoxSelection(GetOptionInt("Communication", "PartyLooting"));
	setEnableLootingBox(true);
	// Ư�� ���ǿ��� preEnterChattingOption �� setChattingBool ó�� �ؾ� ��.
//	Debug("OnRestart" @  String(preEnterChattingOption));
	if(getInstanceUIData().getIsArenaServer())
	{
//		Debug("�Ʒ��� �����ΰ�??" @ getInstanceUIData().getIsArenaServer());
		 SetChatFilterBool("Global", "EnterChatting" , preEnterChattingOption);		
	}
	
}

function bool IsRoomMaster()
{
	local PartyWnd Script;
	Script = PartyWnd(GetScript("PartyWnd"));
	return Script.m_AmIRoomMaster;
}
function OnPartyLootingHasModified(String a_Param)//��Ƽ������ ����Ǿ�����
{
	local int IsSuccess;
	local int LootingScheme;
	local string Schemestr;
	local string	strParam;
	local PartyWnd script;
	//////////for ScreenMsg///////////
	local SystemMsgData SystemMsgCurrent;
	///////////////////////////////////////

	//���� �޺��ڽ� ������ ����
	/////////////////////////

	local TextBoxHandle t_handle;


	local L2Util util ;
	util = L2Util(GetScript("L2Util"));	

	script  = PartyWnd(GetScript("PartyWnd"));

	ParseInt(a_Param, "IsSuccess", IsSuccess);
	ParseInt(a_Param, "LootingScheme", LootingScheme);


	//Debug("OnPartyLootingHasModified" @ IsSuccess);
	//�̰��� ��ũ���޽��� �ڵ� �߰�. �ɼ�â ��Ƽ���ù�� �޺��ڽ��� �ٷ�����

	if(IsSuccess != 0)//�����̱⸸ �ϸ� partyMatchRoom �� ���ù���� ������ �ٲ���Ѵ�. //��Ƽâ�� ��������������
	{		
		script.SetMasterTooltip(LootingScheme);
		Schemestr = util.getLootingString(LootingScheme);
		t_handle = GetTextBoxHandle("PartyMatchRoomWnd.LootingMethod");
		t_handle.SetText(Schemestr);
	}
	
		
	if(bPartyMaster || IsRoomMaster())//�ڽ��� ��Ƽ�� Ȥ�� ��Ƽ�����̶��
	{
		AddSystemMessage(3136);
		if(IsSuccess != 0)//���� ���� 
		{
			SetOptionInt("Communication", "PartyLooting", LootingScheme); //���常 �� ������� ���ü����� �����Ѵ�.(�ڱⰡ ������ �Ŵϱ�)
			//do not change. Preserve combobox's current Item.
		}
		else //������� �޺��ڽ� ������ ����
		{
			setLootingBoxSelection(GetOptionInt("Communication", "PartyLooting"));
		}
		setEnableLootingBox(true); //���ùڽ� Ȱ��ȭ
	}
		

	if(IsSuccess == 0)//fail
	{
		//debug("��������");
	}
	else if(IsSuccess == 1)//success ��Ƽ���� ���, �޺��ڽ��� �ٲ��ְ� ������ �����ʴ´�
	{
		Schemestr = util.getLootingString(LootingScheme);
		GetSystemMsgInfo(3138, SystemMsgCurrent);
		
		ParamAdd(strParam, "MsgType", String(1));
		ParamAdd(strParam, "WindowType", String(SystemMsgCurrent.WindowType));
		ParamAdd(strParam, "FontType", String(SystemMsgCurrent.FontType));
		ParamAdd(strParam, "BackgroundType", String(SystemMsgCurrent.BackgroundType));
		ParamAdd(strParam, "LifeTime", String(SystemMsgCurrent.LifeTime * 1000));
		ParamAdd(strParam, "AnimationType", String(SystemMsgCurrent.AnimationType));
		ParamAdd(strParam, "Msg", MakeFullSystemMsg(SystemMsgCurrent.OnScrMsg,Schemestr));
		ParamAdd(strParam, "MsgColorR", String(SystemMsgCurrent.FontColor.R));
		ParamAdd(strParam, "MsgColorG", String(SystemMsgCurrent.FontColor.G));
		ParamAdd(strParam, "MsgColorB", String(SystemMsgCurrent.FontColor.B));
		ExecuteEvent(EV_ShowScreenMessage, strParam);
		
		PlaySound(SystemMsgCurrent.Sound);
		setLootingBoxSelection(LootingScheme); //������ ���� �ʴ´�.
		
	}
	else if(IsSuccess == 2)//success �׳� ��ȿ� �ִ� ����� ���. �޺��ڽ��� �ٲ��ְ� ������ �����ʴ´�
	{
		Schemestr = util.getLootingString(LootingScheme);
		GetSystemMsgInfo(3138, SystemMsgCurrent);

		ParamAdd(strParam, "MsgType", String(1));
		ParamAdd(strParam, "WindowType", String(SystemMsgCurrent.WindowType));
		ParamAdd(strParam, "FontType", String(SystemMsgCurrent.FontType));
		ParamAdd(strParam, "BackgroundType", String(SystemMsgCurrent.BackgroundType));
		ParamAdd(strParam, "LifeTime", String(SystemMsgCurrent.LifeTime * 1000));
		ParamAdd(strParam, "AnimationType", String(SystemMsgCurrent.AnimationType));
		ParamAdd(strParam, "Msg", MakeFullSystemMsg(SystemMsgCurrent.OnScrMsg,Schemestr));
		ParamAdd(strParam, "MsgColorR", String(SystemMsgCurrent.FontColor.R));
		ParamAdd(strParam, "MsgColorG", String(SystemMsgCurrent.FontColor.G));
		ParamAdd(strParam, "MsgColorB", String(SystemMsgCurrent.FontColor.B));
		ExecuteEvent(EV_ShowScreenMessage, strParam);
		
		PlaySound(SystemMsgCurrent.Sound);
		setLootingBoxSelection(LootingScheme); //������ ���� �ʴ´�.
	}
	
}

/*
 * ��Ƽ ���� ����
 */
function OnAskPartyLootingModify(String a_Param)
{
	//Using for Party Looting Scheme Modification//
	local string LeaderName;
	local int LootingScheme;
	/////////////////////////////////////////////////
	local string Schemestr;

	local L2Util util ;
	util = L2Util(GetScript("L2Util"));	


	// ��Ƽ ������ ���� ����, ���̾�α� â�� ���� ������ ������ ��ҷ� ���� 
	
	if(class'UIAPI_WINDOW'.static.IsShowWindow("DialogBox"))
	{		
		SetRequestPartyLootingModifyAgreement(false);
		return;
	}


	// ���̾� �α� �ڽ����� ��, �ƴϿ� �� �������� �Ѵ�.
	dScript.SetButtonName(184, 185);
	
	class'UICommonAPI'.static.DialogSetID(PARTY_MODIFY_REQUEST);	
	class'UICommonAPI'.static.DialogSetParamInt64(10*1000);			// 5 seconds
	class'UICommonAPI'.static.DialogSetDefaultCancle(); // ���͸� ġ�ų� Ÿ�Ӿƿ��߻��� cancle�� �Ǵ�
	ParseString(a_Param, "LeaderName", LeaderName);
	ParseInt(a_Param, "LootingScheme", LootingScheme);	
	Schemestr = util.getLootingString(LootingScheme);

	//Modal ���� Modalless �� �ٲ� TTP 60257
	class'UICommonAPI'.static.DialogShow(DialogModalType_Modalless, DialogType_Progress, MakeFullSystemMsg(GetSystemMessage(3134),Schemestr), string(Self));
}

/*  Referenced by: OnEvent()> EV_StateChanged
 *  Description:
 *	������Ʈ ���� ����Ű ��ư�� Ȱ��ȭ���� ��Ȱ��ȭ ���� �����Ѵ�.
 */
function UIActivationUponStateChanges(string a_Param)
{
//	Debug("UIActivationUponStateChanges" @ a_Param);
	if(a_Param == "GAMINGSTATE" ||  a_Param == "ARENAGAMINGSTATE" ||  a_Param == "ARENABATTLESTATE" || a_Param == "ARENAPICKSTATE")
	{
		//������ ���� ����Ű ����� ������Ʈ 
		HandleSwitchEnterchatting();
		//Debug("requestLit");
		class'ShortcutAPI'.static.RequestList();
		//ShortcutBtn.HideWindow();
		isGAMINGSTATE = true;
	}
	else 
	{
		isGAMINGSTATE = false;
		//ShortcutBtn.ShowWindow();
	}
	SetAlwaysOnTop(!isGAMINGSTATE);
	//call_isGAMINGSTATE();
	InitControlOption();
}

//function setChatOption()
//{
//	local ChatWnd	script;
//	local int i, tempVar;
//	local bool bChecked;
	
//	script = ChatWnd(GetScript("ChatWnd"));
//	//�޺��ڽ� �ε����� ����
//	//chatType = script.m_chatType.ID; // ������ ID
	
//	//script.m_filterInfo[chatType].bSystem = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxSystem"));
//	//script.m_filterInfo[chatType].bUseitem = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxItem"));
//	//script.m_filterInfo[chatType].bDamage = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxDamage"));
//	//script.m_filterInfo[chatType].bChat = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxChat"));
//	//script.m_filterInfo[chatType].bNormal = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxNormal"));
//	//script.m_filterInfo[chatType].bParty = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxParty"));
//	//script.m_filterInfo[chatType].bShout = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxShout"));
//	//script.m_filterInfo[chatType].bTrade = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxTrade"));
//	//script.m_filterInfo[chatType].bClan = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxPledge"));
//	//script.m_filterInfo[chatType].bWhisper = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxWhisper"));
//	//script.m_filterInfo[chatType].bAlly = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxAlly"));
//	//script.m_filterInfo[chatType].bHero = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxHero"));
//	//script.m_filterInfo[chatType].bUnion = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxUnion"));
//	////script.m_filterInfo[chatType].bBattle = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxBattle"));
//	//script.m_filterInfo[chatType].bNoNpcMessage = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxNPC"));
//	////���� ä�� �߰�
//	//script.m_filterInfo[chatType].bWorldChat = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxWorldChat"));
	
//	// script.m_NoNpcMessage = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxNPC"));	// NPC ��� ���͸� - 2010.9.8 winkey

//	//script.m_NoUnionCommanderMessage = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.CheckBoxCommand"));
//	//script.m_KeywordFilterSound = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.KeywordSoundBox"));
//	//script.m_KeywordFilterActivate = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.KeywordFilterBox"));
//	//script.m_UseAlpha = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.UseChatAlpha"));
//	//script.m_ChatResizeOnOff = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.ChattingFilterGroup.ChatWndLock"));	
	
//	//script.m_bWorldChatSpeaker = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.ChattingFilterGroup.CheckBoxUseWorldChatSpeaker"));

//	//���� ä�� ����Ŀ
//	//bChecked = CheckBoxUseWorldChatSpeaker.IsChecked();
//	//SetINIBool("global","UseWorldChatSpeaker", bChecked, "chatfilter.ini");
	

//	//ä�ñ�ȣ ǥ��
//	bChecked = UseChatSymbolBox.IsChecked();	
//	//SetOptionBool("Communication", "OldChatting", bChecked);
//	SetChatFilterBool("Global", "OldChatting", bChecked);

//	//ä��â ����ȭ <�ű� ���>	
//	bChecked = UseChatAlphaBox.IsChecked();
//	SetINIBool("global","ChatWndTransparent", bChecked, "chatfilter.ini");

//	//ä��â ������ ���� <�ű� ���>	
//	bChecked = ChatResizeBox.IsChecked();
//	SetINIBool("global","ChatResizing", bChecked, "chatfilter.ini");

//	// �ý��۸޽�������â ��뿩�� - SystemMsgBox	
//	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.ChattingFilterGroup.UseSystemMsgBox");
//	SetINIBool("global","SystemMsgWnd", bChecked, "chatfilter.ini");

//	// �ý��۸޽�������â �ý��۸޽���
//	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.ChattingFilterGroup.OnlySystemMsgChannelBox");
//	SetINIBool("global","UseSystemMsg", bChecked, "chatfilter.ini");
	
//	// �ý��۸޽�������â ������
//	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.ChattingFilterGroup.OnlySystemMsgDamageBox");
//	SetINIBool("global","SystemMsgWndDamage", bChecked, "chatfilter.ini");
	
//	// �ý��۸޽�������â �Ҹ𼺾����ۻ��
//	bChecked = class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.ChattingFilterGroup.OnlySystemMsgItemBox");
//	SetINIBool("global","SystemMsgWndExpendableItem", bChecked, "chatfilter.ini");
	
//	GetINIBool("global", "SystemMsgWnd", tempVar, "chatfilter.ini");
//	if(bool(tempVar))
//	{
//		 class'UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");
//	} 
//	else 
//	{
//		class'UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
//	}
	
//	for(i = 0; i < script.m_sectionName.Length; i++)
//	{
//		GetINIBool(script.m_sectionName[i],"system", script.m_filterInfo[i].bSystem, "chatfilter.ini");
//		GetINIBool(script.m_sectionName[i],"damage", script.m_filterInfo[i].bDamage, "chatfilter.ini");
//		GetINIBool(script.m_sectionName[i],"useitems", script.m_filterInfo[i].bUseItem, "chatfilter.ini");
//		GetINIBool(script.m_sectionName[i],"chat", script.m_filterInfo[i].bChat, "chatfilter.ini");
//		GetINIBool(script.m_sectionName[i],"normal", script.m_filterInfo[i].bNormal, "chatfilter.ini");
//		GetINIBool(script.m_sectionName[i],"party", script.m_filterInfo[i].bParty, "chatfilter.ini");
//		GetINIBool(script.m_sectionName[i],"shout", script.m_filterInfo[i].bShout, "chatfilter.ini");
//		GetINIBool(script.m_sectionName[i],"market", script.m_filterInfo[i].bTrade, "chatfilter.ini");
//		GetINIBool(script.m_sectionName[i],"pledge", script.m_filterInfo[i].bClan, "chatfilter.ini");
//		GetINIBool(script.m_sectionName[i],"tell", script.m_filterInfo[i].bWhisper, "chatfilter.ini");
//		GetINIBool(script.m_sectionName[i],"ally", script.m_filterInfo[i].bAlly, "chatfilter.ini");	
//		GetINIBool(script.m_sectionName[i],"hero", script.m_filterInfo[i].bHero, "chatfilter.ini");
//		GetINIBool(script.m_sectionName[i],"union", script.m_filterInfo[i].bUnion, "chatfilter.ini");
//		//SetINIBool(script.m_sectionName[i],"battle", bool(script.m_filterInfo[i].bBattle), "chatfilter.ini");
//		GetINIBool(script.m_sectionName[i],"nonpcmessage", script.m_filterInfo[i].bNoNpcMessage, "chatfilter.ini");
//		//���� ä�� �߰�
//		GetINIBool(script.m_sectionName[i],"worldChat", script.m_filterInfo[i].bWorldChat, "chatfilter.ini");
//	}
//	//���� ä�� ����Ŀ
//	GetINIBool("global", "UseWorldChatSpeaker", script.m_bWorldChatSpeaker, "chatfilter.ini");
//	//script.GetAllcurrentAssignedChatTypeID();
	
//	//Global Setting
//	// SetINIBool("global","npc", bool(script.m_NoNpcMessage), "chatfilter.ini");						// NPC ��� ���͸� - 2010.9.8 winkey
//	GetINIBool("global","command", script.m_NoUnionCommanderMessage, "chatfilter.ini");
//	GetINIBool("global","keywordsound", script.m_KeywordFilterSound, "chatfilter.ini");
//	GetINIBool("global","keywordactivate", script.m_KeywordFilterActivate, "chatfilter.ini");
//	//������ ��뿩��
//	GetINIBool("global","UseAlpha", script.m_UseAlpha, "chatfilter.ini");
	
//	//������ ���� ��뿩��
//	GetINIBool("global","ChatResizing", script.m_ChatResizeOnOff, "chatfilter.ini");

//	if(bool(script.m_ChatResizeOnOff))	
//		EnableChatWndResizing(false);	
//	else	
//		EnableChatWndResizing(true);

//	GetINIString("global", "Keyword0", script.m_Keyword0, "chatfilter.ini");
//	GetINIString("global", "Keyword1", script.m_Keyword1, "chatfilter.ini");
//	GetINIString("global", "Keyword2", script.m_Keyword2, "chatfilter.ini");
//	GetINIString("global", "Keyword3", script.m_Keyword3, "chatfilter.ini");	




	
//	script.m_KeywordFilterSound = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.KeywordSoundBox"));
//	script.m_KeywordFilterActivate = int(class'UIAPI_CHECKBOX'.static.IsChecked("ChatFilterWnd.KeywordFilterBox"));
//}

// ����� ä�� �ɼ� ����
function setChattingOption()
{	
	local ChatWnd	script;
	local int tempVal, i, resultNum;	

	script = ChatWnd(GetScript("ChatWnd"));
	
	for(i = 0; i < script.m_sectionName.Length; i++)
	{
		GetINIBool(script.m_sectionName[i],"dice",tempVal,"chatfilter.ini");
		script.m_filterInfo[i].bDice = tempVal;
		//getini �� ���� �����;ߵ�
		GetINIBool(script.m_sectionName[i],"getitems",tempVal,"chatfilter.ini");
		script.m_filterInfo[i].bGetitems = tempVal;

		GetINIBool(script.m_sectionName[i], "system", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bSystem = tempVal;

		GetINIBool(script.m_sectionName[i], "useitems", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bUseitem = tempVal;

		GetINIBool(script.m_sectionName[i], "damage", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bDamage = tempVal;

		GetINIBool(script.m_sectionName[i], "chat", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bChat = tempVal;

		GetINIBool(script.m_sectionName[i], "normal", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bNormal = tempVal;

		GetINIBool(script.m_sectionName[i], "party", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bParty = tempVal;

		GetINIBool(script.m_sectionName[i], "shout", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bShout = tempVal;

		GetINIBool(script.m_sectionName[i], "market", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bTrade = tempVal;

		GetINIBool(script.m_sectionName[i], "pledge", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bClan = tempVal;

		GetINIBool(script.m_sectionName[i], "tell", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bWhisper = tempVal;

		GetINIBool(script.m_sectionName[i], "ally", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bAlly = tempVal;

		GetINIBool(script.m_sectionName[i], "hero", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bHero = tempVal;

		GetINIBool(script.m_sectionName[i], "union", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bUnion = tempVal;

		GetINIBool(script.m_sectionName[i], "nonpcmessage", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bNoNpcMessage = tempVal;

		GetINIBool(script.m_sectionName[i], "worldChat", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bWorldChat = tempVal;
		GetINIBool(script.m_sectionName[i], "worldUnion", tempVal, "chatfilter.ini");
		script.m_filterInfo[i].bWorldUnion = tempVal;
	}

	script.m_UseChatSymbol = int(GetChatFilterBool("Global", "OldChatting"));//int(GetOptionBool("CommunIcation", "OldChatting"));
	
	//GetINIBool("global", "command", resultNum, "chatfilter.ini");
	//script.m_NoUnionCommanderMessage = resultNum;
	
	GetINIBool("global", "keywordsound", resultNum, "chatfilter.ini");
	script.m_KeywordFilterSound = resultNum;
	
	GetINIBool("global", "keywordactivate", resultNum, "chatfilter.ini");
	script.m_KeywordFilterActivate = resultNum;

	GetINIBool("global", "ChatResizing", resultNum, "chatfilter.ini");	
	script.m_ChatResizeOnOff = resultNum;
	
	
	GetINIBool("global", "SystemMsgWnd", resultNum, "chatfilter.ini");
	script.m_bUseSystemMsgWnd = resultNum;
	
	GetINIBool("global", "UseSystemMsg", resultNum, "chatfilter.ini");
	script.m_bSystemMsgWnd = resultNum;
	
	// ������ - DamageBox
	GetINIBool("global", "SystemMsgWndDamage", resultNum, "chatfilter.ini");
	script.m_bDamageOption = resultNum;
	// �Ҹ𼺾����ۻ�� - ItemBox
	GetINIBool("global", "SystemMsgWndExpendableItem", resultNum, "chatfilter.ini");
	script.m_bUseSystemItem = resultNum;

	// ���� ä�� ����Ŀ
	GetINIBool("global", "UseWorldChatSpeaker", resultNum, "chatfilter.ini");
	script.m_bWorldChatSpeaker = resultNum;

	// �ý��� �޼��� ���� â ǥ��
	GetINIBool("global", "OnlyUseSystemMsgWnd", resultNum, "chatfilter.ini");
	script.m_bOnlyUseSystemMsgWnd = resultNum;
	
	GetINIString("global", "Keyword0", script.m_Keyword0, "chatfilter.ini");
	GetINIString("global", "Keyword1", script.m_Keyword1, "chatfilter.ini");
	GetINIString("global", "Keyword2", script.m_Keyword2, "chatfilter.ini");
	GetINIString("global", "Keyword3", script.m_Keyword3, "chatfilter.ini");	 

	//if(getInstanceUIData().getIsLiveServer())
	//{
		if(bool(script.m_bUseSystemMsgWnd))
			Class'UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");
		else
			Class'UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
	//}
	//else 
	//	class'UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");

	
	if(bool(script.m_ChatResizeOnOff))	
		EnableChatWndResizing(false);	
	else	
		EnableChatWndResizing(true);

	script._SetAllcurrentAssignedChatTypeID();
}

function API_C_EX_SAVE_ITEM_ANNOUNCE_SETTING(bool bAnonymity)
{
	local array<byte> stream;
	local UIPacket._C_EX_SAVE_ITEM_ANNOUNCE_SETTING packet;

	packet.bAnonymity = byte(bAnonymity);
	if(! class'UIPacket'.static.Encode_C_EX_SAVE_ITEM_ANNOUNCE_SETTING(stream,packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_SAVE_ITEM_ANNOUNCE_SETTING,stream);
}

private function HandleSelectAlarmType(string param)
{
	local UIControlContextMenu ContextMenu;
	local int X, Y, keyWordIndex, kewordAlarmType;
	local string buttonName;

	ParseInt(param, "x", X);
	ParseInt(param, "y", Y);
	ParseString(param, "buttonName", buttonName);
	ContextMenu = class'UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	keyWordIndex = int(Right(buttonName, 1));
	kewordAlarmType = _GetKewordAlarmType(keyWordIndex);
	NewArarmMenu(GetSystemString(14248), keyWordIndex, 0, kewordAlarmType);
	NewArarmMenu(GetSystemString(14249), keyWordIndex, 1, kewordAlarmType);
	NewArarmMenu(GetSystemString(14250), keyWordIndex, 2, kewordAlarmType);
	NewArarmMenu(GetSystemString(14250), keyWordIndex, 3, kewordAlarmType);
	ContextMenu.Show(X, Y, string(self));	
}

private function NewArarmMenu(string Title, int btnIndex, int soundType, int currentAlarmType)
{
	local UIControlContextMenu ContextMenu;

	ContextMenu = class'UIControlContextMenu'.static.GetInstance();
	// End:0x5A
	if(soundType == currentAlarmType)
	{
		ContextMenu.MenuNew(Title, (btnIndex * 10) + soundType, getInstanceL2Util().Yellow);		
	}
	else
	{
		ContextMenu.MenuNew(Title, (btnIndex * 10) + soundType, getInstanceL2Util().Gray);
	}	
}

private function HandleOnClickContextMenu(int Index)
{
	local int keyWordIndex, soundType;

	keyWordIndex = Index / 10;
	soundType = int(float(Index) % float(10));
	SetINIInt("global", "KeywordAlarmType" $ string(keyWordIndex), soundType, "chatfilter.ini");	
}

private function HandleChatFontSizeSaved(string param)
{
	Debug("HandleChatFontSizeSaved" @ param);
	class'ChatWnd'.static.Inst()._SetChangeFont(int(param));	
}

function int _GetKewordAlarmType(int keyWordIndex)
{
	local int Type;

	// End:0x47
	if(GetINIInt("global", "KeywordAlarmType" $ string(keyWordIndex), Type, "chatfilter.ini"))
	{
		return Type;
	}
	return 0;	
}

defaultproperties
{
}
