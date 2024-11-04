class DethroneCharacterCreatewnd extends UICommonAPI;

const TIMER_ID_ANIMATION = 19;
const TIMER_DELAY = 2000;
const TIMER_ID_CLICK = 2;
const TIMER_DELAY_CLICK = 150;
const PAWN_SCALE = 0.86f;
const LEVEL_LIMIt = 110;

enum STATECREATE 
{
	initName,
	roomEnter,
	reName
};

var string m_WindowName;
var WindowHandle Me;
var UIControlTextInput uicontrolTextInputScr;
var UIControlDialogAssets uicontrolDialogAssetScr;
var TextBoxHandle NameEditDscrp_tex;
var TextBoxHandle DethroneDscrp_tex;
var ButtonHandle Name_Btn;
var ButtonHandle Help_btn;
var ButtonHandle MainEnter_Button;
var ButtonHandle Cancel_Btn;
var CharacterViewportWindowHandle m_ObjectViewport;
var string _name;
var int m_MeshType;
var bool isDown;
var bool isAniPlaing;
var int bOpen;
var DethroneCharacterCreatewnd.STATECREATE CurrentState;

function SetBOpen(int _bOpen)
{
	bOpen = _bOpen;
	// End:0x21
	if(CurrentState == STATECREATE.roomEnter)
	{
		CheckRoomEnter();
	}
}

function CheckRoomEnter()
{
	// End:0x1D
	if(bOpen == 1)
	{
		MainEnter_Button.EnableWindow();		
	}
	else
	{
		MainEnter_Button.DisableWindow();
	}
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	NameEditDscrp_tex = GetTextBoxHandle(m_WindowName $ ".NameEditDscrp_tex");
	DethroneDscrp_tex = GetTextBoxHandle(m_WindowName $ ".DethroneDscrp_tex");
	Name_Btn = GetButtonHandle(m_WindowName $ ".Name_Btn");
	Help_btn = GetButtonHandle(m_WindowName $ ".Help_btn");
	Cancel_Btn = GetButtonHandle(m_WindowName $ ".Cancel_Btn");
	MainEnter_Button = GetButtonHandle(m_WindowName $ ".MainEnter_Button");
	uicontrolTextInputScr = class'UIControlTextInput'.static.InitScript(GetWindowHandle(m_WindowName $ ".TextInput"));
	uicontrolTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolTextInputScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	uicontrolTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	m_ObjectViewport = GetCharacterViewportWindowHandle(m_WindowName $ ".CharacterView_wnd.ObjectViewport");
	SetAssets();
}

function SetAssets()
{
	uicontrolDialogAssetScr = class'UIControlDialogAssets'.static.InitScript(GetWindowHandle(m_WindowName $ ".AssetGroup.UIControlDialogAsset"));
	uicontrolDialogAssetScr.SetDisableWindow(GetWindowHandle(m_WindowName $ ".AssetGroup.DisableDialog_tex"));
	uicontrolDialogAssetScr.DelegateOnClickBuy = OnClickPopupBuy;
	uicontrolDialogAssetScr.DelegateOnCancel = OnClickPopupCancel;
}

function DelegateESCKey()
{}

function DelegateOnChangeEdited(string Text)
{
	// End:0x24
	if(uicontrolTextInputScr.IsEmpty())
	{
		Name_Btn.DisableWindow();		
	}
	else
	{
		Name_Btn.EnableWindow();
	}
}

function DelegateOnCompleteEditBox(string Text)
{
	// End:0x23
	if(Text != "" && Text != _name)
	{
		HandleClickNameBtn();
	}
}

function API_C_EX_DETHRONE_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_INFO packet;

	packet.cDummy = 0;
	// End:0x2C
	if(! class'UIPacket'.static.Encode_C_EX_DETHRONE_INFO(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_INFO, stream);
}

function API_C_EX_DETHRONE_ENTER()
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_ENTER packet;

	// End:0x0E
	if(_name == "")
	{
		return;
	}
	packet.cDummy = 0;
	// End:0x3A
	if(! class'UIPacket'.static.Encode_C_EX_DETHRONE_ENTER(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_ENTER, stream);
}

function API_C_EX_DETHRONE_LEAVE()
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_LEAVE packet;

	packet.cDummy = 0;
	// End:0x2C
	if(! class'UIPacket'.static.Encode_C_EX_DETHRONE_LEAVE(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_LEAVE, stream);
}

function API_C_EX_DETHRONE_CHECK_NAME(string _name)
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_CHECK_NAME packet;

	packet.sName = _name;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_DETHRONE_CHECK_NAME(stream, packet))
	{
		return;
	}
	Debug("API_C_EX_DETHRONE_CHECK_NAME");
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_CHECK_NAME, stream);
}

function API_C_EX_DETHRONE_CHANGE_NAME()
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_CHANGE_NAME packet;

	packet.sName = uicontrolTextInputScr.GetString();
	// End:0x3A
	if(! class'UIPacket'.static.Encode_C_EX_DETHRONE_CHANGE_NAME(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_CHANGE_NAME, stream);
}

function API_GetDethroneChangeNameCost(out array<RequestItem> o_arrData)
{
	GetDethroneChangeNameCost(o_arrData);
}

function Handle_S_EX_DETHRONE_INFO()
{
	local UIPacket._S_EX_DETHRONE_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_INFO(packet))
	{
		return;
	}
	_name = packet.sName;
	HandleGameStart();
}

function Handle_S_EX_DETHRONE_CHECK_NAME()
{
	local UIPacket._S_EX_DETHRONE_CHECK_NAME packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_CHECK_NAME(packet))
	{
		return;
	}
	Debug("Handle_S_EX_DETHRONE_CHECK_NAME" @ string(packet.nResult));
	HandlecharacterNameCreatable(packet.nResult);
	HandleCharacterNameCreate(packet.nResult);
}

function Handle_S_EX_DETHRONE_CHANGE_NAME()
{
	local UIPacket._S_EX_DETHRONE_CHANGE_NAME packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_CHANGE_NAME(packet))
	{
		return;
	}
	// End:0x4B
	if(packet.bSuccess == 1)
	{
		_name = packet.sName;
		SetState(roomEnter);
		PlayRandAttackAnimation();
	}
}

function SetState(STATECREATE State)
{
	uicontrolDialogAssetScr.Hide();
	switch(State)
	{
		// End:0xC3
		case initName:
			NameEditDscrp_tex.SetText(GetSystemMessage(80));
			uicontrolTextInputScr.SetEdtiable(true);
			uicontrolTextInputScr.SetMaxLength(16);
			HandleLevelCheck();
			Cancel_Btn.HideWindow();
			uicontrolTextInputScr.Clear();
			MainEnter_Button.DisableWindow();
			Name_Btn.DisableWindow();
			Name_Btn.SetButtonName(140);
			DethroneDscrp_tex.SetText(GetSystemString(13772));
			// End:0x27F
			break;
		// End:0x194
		case roomEnter:
			NameEditDscrp_tex.SetText(GetSystemString(13778));
			uicontrolTextInputScr.SetMaxLength(100);
			uicontrolTextInputScr.SetString(GetfullName());
			uicontrolTextInputScr.SetEdtiable(false);
			Cancel_Btn.HideWindow();
			CheckRoomEnter();
			Name_Btn.EnableWindow();
			Name_Btn.SetButtonName(13776);
			DethroneDscrp_tex.SetAlpha(100);
			DethroneDscrp_tex.SetAlpha(255, 1.0f);
			DethroneDscrp_tex.SetText(GetSystemString(13775));
			// End:0x27F
			break;
		// End:0x27C
		case reName:
			NameEditDscrp_tex.SetText(GetSystemMessage(80));
			uicontrolTextInputScr.SetMaxLength(16);
			uicontrolTextInputScr.SetString(_name);
			uicontrolTextInputScr.SetEdtiable(true);
			HandleLevelCheck();
			uicontrolTextInputScr.AllSelect();
			Cancel_Btn.ShowWindow();
			MainEnter_Button.DisableWindow();
			Name_Btn.EnableWindow();
			Name_Btn.SetButtonName(140);
			DethroneDscrp_tex.SetAlpha(100);
			DethroneDscrp_tex.SetAlpha(255, 1.0f);
			DethroneDscrp_tex.SetText(GetSystemString(13772));
			// End:0x27F
			break;
	}
	CurrentState = State;
}

function string GetfullName()
{
	local UserInfo myInfo;

	// End:0x3B
	if(GetPlayerInfo(myInfo))
	{
		return _name $ "_" $ getInstanceUIData().Int2Str(getServerExtIdByWorldID(myInfo.nWorldID));
	}
	return _name;
}

event OnLoad()
{
	Initialize();
	SetClosingOnESC();
}

event OnRegisterEvent()
{
	RegisterEvent(EV_ChangeCharacterPawn);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_CHANGE_NAME);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_CHECK_NAME);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_INFO);
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x1D
		case EV_ChangeCharacterPawn:
			HandleChangeCharacterPawn(param);
			// End:0xB0
			break;
		// End:0x2B
		case EV_UpdateUserInfo:
			HandleUpdateUserInfo();
			// End:0xB0
			break;
		// End:0x3C
		case EV_GameStart:
			HandleGameStart();
			// End:0xB0
			break;
		// End:0x4A
		case EV_Restart:
			HandleRestart();
			// End:0xB0
			break;
		// End:0x6B
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_CHANGE_NAME:
			Handle_S_EX_DETHRONE_CHANGE_NAME();
			// End:0xB0
			break;
		// End:0x8C
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_CHECK_NAME:
			Handle_S_EX_DETHRONE_CHECK_NAME();
			// End:0xB0
			break;
		// End:0xAD
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_INFO:
			Handle_S_EX_DETHRONE_INFO();
			// End:0xB0
			break;
	}
}

event OnShow()
{
	// End:0x24
	if(getInstanceUIData().getIsClassicServer())
	{
		Me.HideWindow();
		return;
	}
	TextOnShow();
}

event OnHide()
{
	uicontrolDialogAssetScr.Hide();
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "DethroneWnd");
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	// End:0x2A
	if(a_WindowHandle == m_ObjectViewport)
	{
		Me.SetTimer(2, 150);
		isDown = true;
	}
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	// End:0x8A
	if((! isAniPlaing && isDown) && a_WindowHandle == m_ObjectViewport)
	{
		isAniPlaing = true;
		// End:0x5D
		if(m_MeshType == 18 || m_MeshType == 19)
		{
			m_ObjectViewport.PlayAnimation(3);			
		}
		else
		{
			PlayRandAttackAnimation();
		}
		Me.KillTimer(19);
		Me.SetTimer(19, 2000);
	}
	Me.KillTimer(2);
	isDown = false;
}

event OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	// End:0x5C
	if(! isAniPlaing && isDown && a_WindowHandle == m_ObjectViewport)
	{
		isAniPlaing = true;
		PlayRandAnimation();
		Me.KillTimer(19);
		Me.SetTimer(19, 2000);
	}
	Me.KillTimer(2);
	isDown = false;
}

event OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	// End:0x2A
	if(a_WindowHandle == m_ObjectViewport)
	{
		Me.SetTimer(2, 150);
		isDown = true;
	}
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		// End:0x28
		case 19:
			Me.KillTimer(19);
			isAniPlaing = false;
			// End:0x4C
			break;
		// End:0x49
		case 2:
			Me.KillTimer(2);
			isDown = false;
			// End:0x4C
			break;
	}
}

event OnClickButton(string BTNID)
{
	switch(BTNID)
	{
		// End:0x1F
		case "Cancel_Btn":
			HandleClickCancelBtn();
			// End:0x6C
			break;
		// End:0x3D
		case "MainEnter_Button":
			HandleClickMainEnter();
			// End:0x6C
			break;
		// End:0x53
		case "Name_Btn":
			HandleClickNameBtn();
			// End:0x6C
			break;
		// End:0x69
		case "Back_Btn":
			HandleClickBackBtn();
			// End:0x6C
			break;
	}
}

function HandleClickBackBtn()
{
	Me.HideWindow();
	GetWindowHandle("DethroneWnd").ShowWindow();
}

function HandleClickNameBtn()
{
	switch(CurrentState)
	{
		// End:0x0C
		case initName:
		// End:0x45
		case reName:
			// End:0x2D
			if(! NameConfirm())
			{
				uicontrolTextInputScr.AllSelect();
				return;
			}
			API_C_EX_DETHRONE_CHECK_NAME(uicontrolTextInputScr.GetString());
			// End:0x58
			break;
		// End:0x55
		case roomEnter:
			SetState(reName);
			// End:0x58
			break;
	}
}

function HandleClickMainEnter()
{
	API_C_EX_DETHRONE_ENTER();
	m_hOwnerWnd.HideWindow();
}

function HandleClickCancelBtn()
{
	SetState(roomEnter);
}

function HandleRestart()
{
	_name = "";
}

function HandleGameStart()
{
	// End:0x17
	if(_name == "")
	{
		SetState(initName);		
	}
	else
	{
		SetState(roomEnter);
	}
}

function HandleUpdateUserInfo()
{
	// End:0x1A
	if(! HandleLevelCheck())
	{
		Me.HideWindow();
	}
}

function bool HandleLevelCheck()
{
	local UserInfo uInfo;

	// End:0x78
	if(GetPlayerInfo(uInfo))
	{
		// End:0x56
		if(uInfo.nLevel < 110)
		{
			uicontrolTextInputScr.SetDisable(true);
			NameEditDscrp_tex.SetText(MakeFullSystemMsg(GetSystemMessage(4547), string(110)));			
		}
		else
		{
			uicontrolTextInputScr.SetDisable(false);
		}
		return ! uicontrolTextInputScr._bDisable;
	}
	return false;
}

function HandlecharacterNameCreatable(int nResult)
{
	local int createMessage;

	switch(nResult)
	{
		// End:0x16
		case 1:
			createMessage = 80;
			// End:0x60
			break;
		// End:0x29
		case -1:
			createMessage = 79;
			// End:0x60
			break;
		// End:0x3C
		case -2:
			createMessage = 204;
			// End:0x60
			break;
		// End:0x4F
		case -3:
			createMessage = 80;
			// End:0x60
			break;
		// End:0x53
		case 0:
		// End:0xFFFF
		default:
			createMessage = 0;
			// End:0x60
			break;
			break;
	}
	NameEditDscrp_tex.SetText(GetSystemMessage(createMessage));
}

function HandleCharacterNameCreate(int nResult)
{
	local array<RequestItem> o_arrData;
	local int i;

	// End:0x1C
	if(nResult != 1)
	{
		uicontrolTextInputScr.AllSelect();
		return;
	}
	uicontrolDialogAssetScr.SetUseBuyItem(false);
	uicontrolDialogAssetScr.SetUseNumberInput(false);
	switch(CurrentState)
	{
		// End:0xE1
		case initName:
			uicontrolDialogAssetScr.SetUseNeedItem(false);
			uicontrolDialogAssetScr.SetDialogDesc("<br><font color=\"E6DCBE\" name=gameDefault11>" $ uicontrolTextInputScr.GetString() $ "</font><br>" $ GetSystemString(13774), 0, 0, true);
			// End:0x1EA
			break;
		// End:0x1E7
		case reName:
			API_GetDethroneChangeNameCost(o_arrData);
			uicontrolDialogAssetScr.SetDialogDesc("<br><font color=\"E6DCBE\" name=gameDefault11>" $ uicontrolTextInputScr.GetString() $ "</font><br>" $ GetSystemString(13782), 0, 0, true);
			uicontrolDialogAssetScr.SetUseNeedItem(true);
			uicontrolDialogAssetScr.StartNeedItemList(o_arrData.Length);

			// End:0x1D4 [Loop If]
			for(i = 0; i < o_arrData.Length; i++)
			{
				uicontrolDialogAssetScr.AddNeedItemClassID(o_arrData[i].Id, o_arrData[i].Amount);
			}
			uicontrolDialogAssetScr.SetItemNum(1);
			// End:0x1EA
			break;
	}
	uicontrolTextInputScr.SetDisable(true);
	uicontrolDialogAssetScr.Show();
}

function OnClickPopupBuy()
{
	uicontrolDialogAssetScr.Hide();
	switch(CurrentState)
	{
		// End:0x1B
		case initName:
		// End:0x29
		case reName:
			API_C_EX_DETHRONE_CHANGE_NAME();
			// End:0x2C
			break;
	}
}

function OnClickPopupCancel()
{
	switch(CurrentState)
	{
		// End:0x0C
		case initName:
		// End:0x33
		case reName:
			uicontrolTextInputScr.SetDisable(false);
			uicontrolTextInputScr.Focus();
			// End:0x36
			break;
	}
	uicontrolDialogAssetScr.Hide();
}

function PlayRandAttackAnimation()
{
	local int aniType;

	aniType = Rand(3) + 1;
	m_ObjectViewport.PlayAttackAnimation(aniType);
}

function PlayRandAnimation()
{
	local int aniType;

	aniType = Rand(13) + 1;
	m_ObjectViewport.PlayAnimation(aniType);
}

function HandleChangeCharacterPawn(string param)
{
	ParseInt(param, "MeshType", m_MeshType);
	switch(m_MeshType)
	{
		// End:0x6B
		case 0:
			m_ObjectViewport.SetCharacterScale(0.980f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-2);
			// End:0x59C
			break;
		// End:0xB5
		case 1:
			m_ObjectViewport.SetCharacterScale(0.9570f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			// End:0x59C
			break;
		// End:0x100
		case 8:
			m_ObjectViewport.SetCharacterScale(1.0f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-16);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			// End:0x59C
			break;
		// End:0x14B
		case 9:
			m_ObjectViewport.SetCharacterScale(1.010f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-14);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			// End:0x59C
			break;
		// End:0x196
		case 6:
			m_ObjectViewport.SetCharacterScale(0.970f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-2);
			// End:0x59C
			break;
		// End:0x1E1
		case 7:
			m_ObjectViewport.SetCharacterScale(0.980f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-18);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			// End:0x59C
			break;
		// End:0x229
		case 2:
			m_ObjectViewport.SetCharacterScale(0.990f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(3);
			m_ObjectViewport.SetCharacterOffsetY(-2);
			// End:0x59C
			break;
		// End:0x274
		case 3:
			m_ObjectViewport.SetCharacterScale(0.980f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-14);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			// End:0x59C
			break;
		// End:0x2BC
		case 10:
			m_ObjectViewport.SetCharacterScale(0.950f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(5);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			// End:0x59C
			break;
		// End:0x307
		case 11:
			m_ObjectViewport.SetCharacterScale(0.880f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-26);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			// End:0x59C
			break;
		// End:0x34F
		case 12:
			m_ObjectViewport.SetCharacterScale(0.950f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(3);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			// End:0x59C
			break;
		// End:0x39A
		case 13:
			m_ObjectViewport.SetCharacterScale(0.90f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-26);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			// End:0x59C
			break;
		// End:0x3DE
		case 4:
			m_ObjectViewport.SetCharacterScale(1.050f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(3);
			m_ObjectViewport.SetCharacterOffsetY(0);
			// End:0x59C
			break;
		// End:0x429
		case 5:
			m_ObjectViewport.SetCharacterScale(1.050f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-10);
			m_ObjectViewport.SetCharacterOffsetY(-2);
			// End:0x59C
			break;
		// End:0x474
		case 14:
			m_ObjectViewport.SetCharacterScale(0.960f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-5);
			m_ObjectViewport.SetCharacterOffsetY(-2);
			// End:0x59C
			break;
		// End:0x4B8
		case 15:
			m_ObjectViewport.SetCharacterScale(0.970f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(4);
			m_ObjectViewport.SetCharacterOffsetY(0);
			// End:0x59C
			break;
		// End:0x503
		case 17:
			m_ObjectViewport.SetCharacterScale(1.050f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			// End:0x59C
			break;
		// End:0x54E
		case 18:
			m_ObjectViewport.SetCharacterScale(1.050f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			// End:0x59C
			break;
		// End:0x599
		case 19:
			m_ObjectViewport.SetCharacterScale(1.050f * 0.860f);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			// End:0x59C
			break;
	}
}

function bool NameConfirm()
{
	local string NewName;

	NewName = uicontrolTextInputScr.GetString();
	// End:0x51
	if(Len(NewName) == 0 || ! CheckNameLength(NewName))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(80));
		return false;		
	}
	else if(! CheckValidName(NewName))
	{
		NameEditDscrp_tex.SetText(GetSystemMessage(204));
		return false;			
	}
	else if(uicontrolTextInputScr.GetString() == _name)
	{
		NameEditDscrp_tex.SetText(GetSystemMessage(3221));
		return false;
	}
	return true;
}

function OnReceivedCloseUI()
{
	// End:0x2C
	if(uicontrolDialogAssetScr.Me.IsShowWindow())
	{
		OnClickPopupCancel();
		PlayConsoleSound(IFST_WINDOW_CLOSE);		
	}
	else
	{
		switch(CurrentState)
		{
			// End:0x43
			case reName:
				SetState(roomEnter);
				// End:0x57
				break;
			// End:0xFFFF
			default:
				PlayConsoleSound(IFST_WINDOW_CLOSE);
				HandleClickBackBtn();
				// End:0x57
				break;
		}
	}
}

function TextOnShow()
{
	HandleUpdateUserInfo();
	API_C_EX_DETHRONE_INFO();
}

defaultproperties
{
}
