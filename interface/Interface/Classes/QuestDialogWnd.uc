class QuestDialogWnd extends UICommonAPI;

const DISTTICK = 50;
const TALK_DISTANCE = 250;
const TEXTTICK = 50;
const TEXTNUM = 2;
const MONSTERID_DEACTIVE = 19652;
const QUEST_CATEGORY_MAIN = 10001;
const QUEST_CATEGORY_SUB = 20001;
const QUEST_CATEGORY_SPECIAL = 30001;
const DIALOG_HELP_KEY = "\\#$help_index=";
const DIALOG_CLASSCHANGE_KEY = "\\#$class_change";

enum QUESTDialogType 
{
	non,
	Start,
	Accept,
	complete,
	End,
	AGAIN
};

struct questData
{
	var int QuestID;
	var int dialogType;
	var Vector npcLoc;
};

var private TextBoxHandle textBox;
var private TextBoxHandle textBox2;
var private TextListBoxHandle textBoxList;
var private CharacterViewportWindowHandle Viewport;
var private ButtonHandle confirmBtn;
var private ButtonHandle helpBtn;
var private ButtonHandle CancelBtn;
var int _currentQuestID;
var int _currentDialogType;
var private int lastAcceptedQuestID;
var private string dialog;
var private int currentHelpIndex;
var private int clickedX;
var private int clickedY;
var private L2UITimerObject tObjectTalk;
var private L2UITimerObject tObjectDist;
var array<questData> qDatas;

static function QuestDialogWnd Inst()
{
	return QuestDialogWnd(GetScript("QuestDialogWnd"));	
}

event OnRegisterEvent()
{
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_QUEST_DIALOG));	
}

event OnLoad()
{
	textBox = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".textBox");
	textBox2 = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".textBox2");
	textBoxList = GetTextListBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".textBoxList");
	textBoxList.SetScrollBarPosition(0, -12, 15);
	Viewport = GetCharacterViewportWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".viewport");
	Viewport.SetUISound(false);
	Viewport.SetSpawnDuration(0.10f);
	confirmBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".confirmBtn");
	helpBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".helpBtn");
	CancelBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".cancelBtn");
	tObjectTalk = class'L2UITimer'.static.Inst()._AddNewTimerObject(TEXTTICK, -1);
	tObjectTalk._DelegateOnStart = HandleTimerOnStart;
	tObjectTalk._DelegateOnTime = HandleTimerOnTime;
	tObjectDist = class'L2UITimer'.static.Inst()._AddNewTimerObject(DISTTICK, -1);
	tObjectDist._DelegateOnTime = HandleOnTimeUpdateLocChk;
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".portraitSetterBtn").HideWindow();
	// End:0x25C
	if(IsBuilderPC() && GetReleaseMode() == RM_DEV)
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".portraitSetterBtn").ShowWindow();
	}	
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x15
		case EV_Restart:
			HandleRestart();
			// End:0x38
			break;
		// End:0x35
		case EV_PacketID(class'UIPacket'.const.S_EX_QUEST_DIALOG):
			RT_S_EX_QUEST_DIALOG();
			// End:0x38
			break;
	}	
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	GetClientCursorPos(clickedX, clickedY);
	// End:0x1E
	if(dialog == "")
	{
		return;
	}
	tObjectTalk._Stop();
	textBoxList.Clear();
	textBoxList.AddString(dialog, GetColor(199, 199, 199, 255));
	dialog = "";	
}

event OnClickButton(string strID)
{
	// End:0x0B
	if(CheckDrag())
	{
		return;
	}
	switch(strID)
	{
		// End:0x27
		case "helpBtn":
			ShowCurrentHelp();
			// End:0xBB
			break;
		// End:0x3F
		case "confirmBtn":
			HandleConfirmBtn();
			// End:0xBB
			break;
		// End:0x56
		case "cancelBtn":
			HandleCancelBtn();
			// End:0xBB
			break;
		// End:0xB8
		case "portraitSetterBtn":
			GetWindowHandle("UIPortraitSetter").ShowWindow();
			UIPortraitSetter(GetScript("UIPortraitSetter"))._SetCurrentQuestInfo();
			// End:0xBB
			break;
	}
}

private function HandleRestart()
{
	Clear();
	_currentQuestID = -1;
	_currentDialogType = -1;	
}

private function Clear()
{
	qDatas.Length = 0;	
}

private function HandleCancelBtn()
{
	switch(qDatas[0].dialogType)
	{
		// End:0x15
		case 2:
		// End:0x8F
		case 1:
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13821), string(self), 294);
			class'DialogBox'.static.Inst().AnchorToOwner(0, 0);
			class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
			class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogCancel;
			return;
	}
	_NextShowQuest();
}

private function HandleDialogCancel()
{
	switch(_currentDialogType)
	{
		// End:0x18
		case 2:
			RQ_C_EX_QUEST_ACCEPT(false);
			// End:0x1B
			break;
	}
	_NextShowQuest();	
}

private function ShowCurrentHelp()
{
	// End:0x1F
	if(currentHelpIndex > 0)
	{
		//class'HelpWnd'.static.ShowHelp(currentHelpIndex);
	}	
}

private function HandleConfirmBtn()
{
	switch(_currentDialogType)
	{
		// End:0x17
		case 1:
			ShowTeleport();
			// End:0x70
			break;
		// End:0x3A
		case 2:
			class'QuestConfirmWnd'.static.Inst()._ShowQuestConfirm();
			// End:0x70
			break;
		// End:0x4A
		case 3:
			ShowTeleport();
			// End:0x70
			break;
		// End:0x6D
		case 4:
			class'QuestConfirmWnd'.static.Inst()._ShowQuestEnd();
			// End:0x70
			break;
	}	
}

private function ShowTeleport()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(13853), string(self), 294);
	class'DialogBox'.static.Inst().AnchorToOwner(0, 0);
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;	
}

private function HandleDialogOK()
{
	RQ_C_EX_QUEST_TELEPORT();
	_NextShowQuest();	
}

event OnHide()
{
	CheckAcceptOnHide();
	tObjectTalk._Stop();
	tObjectDist._Stop();
	textBoxList.Clear();
	dialog = "";
	class'QuestConfirmWnd'.static.Inst().m_hOwnerWnd.HideWindow();
	// End:0x7F
	if(DialogIsMine())
	{
		class'DialogBox'.static.Inst().HideDialog();
	}	
}

private function CheckAcceptOnHide()
{
	// End:0x10
	if(_currentDialogType != 2)
	{
		return;
	}
	// End:0x1D
	if(! IsMainCurrent())
	{
		return;
	}
	// End:0x2E
	if(lastAcceptedQuestID == _currentQuestID)
	{
		return;
	}
	// End:0x5A
	if(CollectionSystem(GetScript("CollectionSystem"))._IsCollectionOpen())
	{
		return;
	}
	RQ_C_EX_QUEST_ACCEPT(true);	
}

event OnEnterState(name a_CurrentStateName)
{
	// End:0x25
	if(qDatas.Length > 0)
	{
		ShowQuest(_currentQuestID == qDatas[0].QuestID);
	}
}

private function SetPortrait(NQuestUIData questUIData)
{
	local NQuestNpcPortraitUIData questNpcPortraitUIData;
	local int questPortraitID;

	switch(_currentDialogType)
	{
		// End:0x0E
		case 1:
		// End:0x15
		case 2:
		// End:0x34
		case 5:
			questPortraitID = questUIData.StartNPC.Id;
			// End:0x5D
			break;
		// End:0x3B
		case 3:
		// End:0x5A
		case 4:
			questPortraitID = questUIData.EndNPC.Id;
			// End:0x5D
			break;
	}
	// End:0x90
	if(questPortraitID < 1)
	{
		textBox2.SetText(GetSystemString(118));
		Viewport.HideWindow();
		return;
	}
	Viewport.ShowWindow();
	API_GetNQuestNpcPortraitData(questPortraitID, questNpcPortraitUIData);
	textBox2.SetText(API_GetNPCName(questPortraitID));
	Viewport.SetNPCInfo(questPortraitID);
	Viewport.SetCameraDistance(questNpcPortraitUIData.ViewDist);
	Viewport.SetCharacterOffsetX(questNpcPortraitUIData.ViewOffsetX);
	Viewport.SetCharacterOffsetY(questNpcPortraitUIData.ViewOffsetY);
	Viewport.SetCharacterOffsetZ(questNpcPortraitUIData.ViewOffsetZ);
	Viewport.SetCurrentRotation(questNpcPortraitUIData.ViewRotationYaw);
	Viewport.SetCharacterScale(questNpcPortraitUIData.ViewScale);
	Viewport.SpawnNPC();	
}

private function ShowQuest(optional bool isfullDialog)
{
	local NQuestUIData questUIData;
	local NQuestDialogUIData questDialogUIData;
	local UserInfo uInfo;

	// End:0x1E
	if(GetGameStateName() == "COLLECTIONSTATE")
	{
		return;
	}
	tObjectDist._Pause();
	lastAcceptedQuestID = -1;
	_currentQuestID = qDatas[0].QuestID;
	_currentDialogType = qDatas[0].dialogType;
	SetCurrentNPcLoc();
	API_GetNQuestData(_currentQuestID, questUIData);
	// End:0x8A
	if(! GetPlayerInfo(uInfo))
	{
		_NextShowQuest();
		return;
	}
	switch(_currentDialogType)
	{
		// End:0x98
		case 1:
		// End:0x105
		case 2:
			// End:0xD2
			if((questUIData.LevelMin > 0) && questUIData.LevelMin > uInfo.nLevel)
			{
				_NextShowQuest();
				return;
			}
			// End:0x105
			if((questUIData.LevelMax > 0) && questUIData.LevelMax < uInfo.nLevel)
			{
				_NextShowQuest();
				return;
			}
	}

	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	textBox.SetText(questUIData.Name);
	SetPortrait(questUIData);
	API_GetNQuestDialogData(_currentQuestID, questDialogUIData);
	SetDialog(questDialogUIData, isfullDialog);
	SetConfirmBtn(questUIData);
	SetDistanceCheck(isfullDialog);
}

private function SetConfirmBtn(NQuestUIData questUIData)
{
	CancelBtn.EnableWindow();
	switch(_currentDialogType)
	{
		// End:0x6F
		case 1:
			confirmBtn.ShowWindow();
			confirmBtn.SetButtonName(900);
			CancelBtn.SetButtonName(14180);
			// End:0x6C
			if(IsMainCurrent())
			{
				CancelBtn.DisableWindow();
			}
			// End:0x17A
			break;
		// End:0xC8
		case 2:
			confirmBtn.ShowWindow();
			confirmBtn.SetButtonName(7422);
			CancelBtn.SetButtonName(14180);
			// End:0xC5
			if(IsMainCurrent())
			{
				CancelBtn.DisableWindow();
			}
			// End:0x17A
			break;
		// End:0x109
		case 3:
			confirmBtn.ShowWindow();
			confirmBtn.SetButtonName(900);
			CancelBtn.SetButtonName(14180);
			// End:0x17A
			break;
		// End:0x14A
		case 4:
			confirmBtn.ShowWindow();
			confirmBtn.SetButtonName(898);
			CancelBtn.SetButtonName(646);
			// End:0x17A
			break;
		// End:0x177
		case 5:
			confirmBtn.HideWindow();
			CancelBtn.SetButtonName(646);
			// End:0x17A
			break;
	}
	// End:0x197
	if(currentHelpIndex > 0)
	{
		helpBtn.ShowWindow();		
	}
	else
	{
		helpBtn.HideWindow();
	}	
}

private function SetDialog(NQuestDialogUIData questDialogUIData, optional bool isfullDialog)
{
	local int firstIndex;
	local string tmpDialog;

	tObjectTalk._Pause();
	tmpDialog = GetCurrentDialog(questDialogUIData);
	firstIndex = InStr(tmpDialog, DIALOG_CLASSCHANGE_KEY);
	// End:0x7C
	if(firstIndex > -1)
	{
		class'UIAPI_WINDOW'.static.ShowWindow("JobChangeWnd");
		tmpDialog = Left(tmpDialog, firstIndex);
	}
	firstIndex = InStr(tmpDialog, DIALOG_HELP_KEY);
	// End:0xEE
	if(firstIndex > -1)
	{
		dialog = Left(tmpDialog, firstIndex);
		currentHelpIndex = int(Right(tmpDialog, (Len(tmpDialog) - firstIndex) - Len(DIALOG_HELP_KEY)));		
	}
	else
	{
		dialog = tmpDialog;
		currentHelpIndex = -1;
	}
	// End:0x132
	if(isfullDialog)
	{
		textBoxList.AddString(dialog, GetColor(199, 199, 199, 255));		
	}
	else
	{
		tObjectTalk._Play();
	}
}

private function string GetCurrentDialog(NQuestDialogUIData questDialogUIData)
{
	switch(_currentDialogType)
	{
		// End:0x19
		case 1:
			return questDialogUIData.StartDialog;
		// End:0x2B
		case 2:
			return questDialogUIData.AcceptDialog;
		// End:0x3D
		case 3:
			return questDialogUIData.CompleteDialog;
		// End:0x4F
		case 4:
			return questDialogUIData.EndDialog;
		// End:0x61
		case 5:
			return questDialogUIData.AcceptDialog;
	}
	return "";
}

private function SetDistanceCheck(optional bool isfullDialog)
{
	switch(_currentDialogType)
	{
		// End:0x0E
		case 1:
		// End:0x15
		case 3:
		// End:0x1E
		case 5:
			return;
	}
	// End:0x2F
	if((GetCurrentNPCTeleportID()) < 0)
	{
		return;
	}
	tObjectDist._Play();
	// End:0x49
	if(isfullDialog)
	{
		return;
	}
	// End:0x6A
	if(class'UIDATA_TARGET'.static.GetTargetClassID() == GetCurrentNPCData().Id)
	{
		return;
	}
	ExecuteCommand("/target" @ (API_GetNPCName(GetCurrentNPCData().Id)));
}

private function SetCurrentNPcLoc()
{
	switch(_currentDialogType)
	{
		// End:0x0E
		case 1:
		// End:0x30
		case 2:
			qDatas[0].npcLoc = GetCurrentNPCData().Location;
			// End:0x5C
			break;
		// End:0x37
		case 3:
		// End:0x59
		case 4:
			qDatas[0].npcLoc = GetCurrentNPCData().Location;
			// End:0x5C
			break;
	}
}

function _NextShowQuest()
{
	m_hOwnerWnd.HideWindow();
	DelQuest(0);
	// End:0x24
	if(qDatas.Length == 0)
	{
		return;
	}
	ShowQuest();	
}

function _ConfirmQuest()
{
	switch(_currentDialogType)
	{
		// End:0x18
		case 2:
			RQ_C_EX_QUEST_ACCEPT(true);
			// End:0x2B
			break;
		// End:0x28
		case 4:
			RQ_C_EX_QUEST_COMPLETE();
			// End:0x2B
			break;
	}
	_NextShowQuest();	
}

function _SohwDialogAgain(int QuestID)
{
	local questData qData;

	qData.QuestID = QuestID;
	qData.dialogType = 5;
	switch(qDatas.Length)
	{
		// End:0x44
		case 0:
			// End:0x41
			if(AddQuestData(qData))
			{
				ShowQuest();
				return;
			}
			// End:0x7C
			break;
		// End:0x76
		case 1:
			// End:0x73
			if(qDatas[0].dialogType == 5)
			{
				// End:0x73
				if(AddQuestData(qData))
				{
					_NextShowQuest();
					return;
				}
			}
			// End:0x7C
			break;
	}
	getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13822));	
}

private function HandleTimerOnStart()
{
	textBoxList.Clear();	
}

private function HandleTimerOnTime(int t)
{
	local int addStringLen;

	textBoxList.Clear();
	addStringLen = (t + 1) * 2;
	// End:0x60
	if(addStringLen < Len(dialog))
	{
		textBoxList.AddString(Left(dialog, addStringLen), GetColor(199, 199, 199, 255));
		return;		
	}
	else
	{
		tObjectTalk._Stop();
		textBoxList.AddString(dialog, GetColor(199, 199, 199, 255));
		dialog = "";
	}
}

function _ShowStartDialog(int QuestID)
{
	local questData qData;
	local NQuestUIData o_data;

	// End:0x29
	if(qDatas.Length > 0)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13822));
		return;
	}
	qData.QuestID = QuestID;
	// End:0x50
	if(! API_GetNQuestData(QuestID, o_data))
	{
		return;
	}
	// End:0x70
	if(CheckDistanceToStart(QuestID))
	{
		qData.dialogType = 1;		
	}
	else
	{
		qData.dialogType = 2;
	}
	// End:0x9F
	if(AddQuestData(qData))
	{
		// End:0x9F
		if(qDatas.Length == 1)
		{
			ShowQuest();
		}
	}
}

function _ShowCompleteDialog(int QuestID)
{
	local questData qData;
	local NQuestUIData o_data;

	// End:0x29
	if(qDatas.Length > 0)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13822));
		return;
	}
	qData.QuestID = QuestID;
	// End:0x50
	if(! API_GetNQuestData(QuestID, o_data))
	{
		return;
	}
	// End:0x70
	if(CheckDistanceToComplete(QuestID))
	{
		qData.dialogType = 3;		
	}
	else
	{
		qData.dialogType = 4;
	}
	// End:0x9F
	if(AddQuestData(qData))
	{
		// End:0x9F
		if(qDatas.Length == 1)
		{
			ShowQuest();
		}
	}	
}

private function bool CheckDistanceToStart(int qID)
{
	local UserInfo uInfo;
	local NQuestUIData questUIData;
	local int dist;

	API_GetNQuestData(qID, questUIData);
	// End:0x27
	if(questUIData.StartNPC.TeleportID < 1)
	{
		return false;
	}
	GetPlayerInfo(uInfo);
	dist = Distance(uInfo.Loc, questUIData.StartNPC.Location);
	Debug(("CheckDistanceToStart" @ string(Distance(uInfo.Loc, questUIData.StartNPC.Location))) @ string(250));
	// End:0xA9
	if(dist < 0)
	{
		return true;
	}
	return dist > 250;	
}

private function bool CheckDistanceToComplete(int qID)
{
	local UserInfo uInfo;
	local NQuestUIData questUIData;
	local int dist;

	API_GetNQuestData(qID, questUIData);
	// End:0x27
	if(questUIData.EndNPC.TeleportID < 1)
	{
		return false;
	}
	GetPlayerInfo(uInfo);
	dist = Distance(uInfo.Loc, questUIData.EndNPC.Location);
	Debug("CheckDistanceToComplete" @ string(Distance(uInfo.Loc, questUIData.EndNPC.Location)) @ string(250));
	// End:0xAC
	if(dist < 0)
	{
		return true;
	}
	return dist > 250;	
}

private function HandleNewQuestData(int QuestID, int dialogType)
{
	local questData qData;

	qData.QuestID = QuestID;
	qData.dialogType = dialogType;
	// End:0x40
	if(AddQuestData(qData))
	{
		// End:0x40
		if(qDatas.Length == 1)
		{
			ShowQuest();
		}
	}
}

function bool _IsDialogAgain()
{
	return qDatas[0].dialogType == 5;	
}

private function int GetQuestIndex(questData qData)
{
	local int i;

	// End:0x67 [Loop If]
	for(i = 0; i < qDatas.Length; i++)
	{
		// End:0x5D
		if((qDatas[i].QuestID == qData.QuestID) && qDatas[i].dialogType == qData.dialogType)
		{
			return i;
		}
	}
	return -1;	
}

private function bool AddQuestData(questData qData)
{
	local int Index;

	Index = GetQuestIndex(qData);
	// End:0x22
	if(Index != -1)
	{
		return false;
	}
	qDatas[qDatas.Length] = qData;
	return true;	
}

private function DelQuestData(questData qData)
{
	local int Index;

	Index = GetQuestIndex(qData);
	// End:0x2B
	if(Index != -1)
	{
		DelQuest(Index);
	}
}

private function DelQuest(int Index)
{
	_currentQuestID = -1;
	_currentDialogType = -1;
	dialog = "";
	// End:0x30
	if(qDatas.Length <= Index)
	{
		return;
	}
	qDatas.Remove(Index, 1);	
}

private function bool CurrentDataDistChk()
{
	local UserInfo uInfo;
	local int dist;

	switch(_currentDialogType)
	{
		// End:0x0E
		case 1:
		// End:0x15
		case 3:
		// End:0x1E
		case 5:
			return true;
		// End:0x25
		case 2:
		// End:0x2F
		case 4:
			// End:0x32
			break;
	}
	GetPlayerInfo(uInfo);
	dist = Distance(uInfo.Loc, qDatas[0].npcLoc);
	// End:0x6C
	if(dist < 0)
	{
		return false;
	}
	return dist < 250;	
}

private function HandleOnTimeUpdateLocChk(int t)
{
	// End:0x0B
	if(CurrentDataDistChk())
	{
		return;
	}
	_NextShowQuest();	
}

private function bool IsMainCurrent()
{
	return qDatas[0].QuestID < QUEST_CATEGORY_SUB;	
}

private function int Distance(Vector locA, Vector locB)
{
	local int gabX, gabY, gabZ;

	gabX = int(locA.X - locB.X);
	gabY = int(locA.Y - locB.Y);
	gabZ = int(locA.Z - locB.Z);
	return int(Sqrt(float(((gabX * gabX) + (gabY * gabY)) + (gabZ * gabZ))));	
}

function int _GetCurrentTeleportID()
{
	local NQuestUIData questUIData;

	API_GetNQuestData(_currentQuestID, questUIData);
	return questUIData.TeleportID;	
}

private function int GetCurrentNPCTeleportID()
{
	return GetCurrentNPCData().TeleportID;	
}

private function NQuestNPCData GetCurrentNPCData()
{
	local NQuestUIData questUIData;

	API_GetNQuestData(_currentQuestID, questUIData);
	switch(_currentDialogType)
	{
		// End:0x1E
		case 1:
		// End:0x25
		case 2:
		// End:0x37
		case 5:
			return questUIData.StartNPC;
		// End:0x3E
		case 3:
		// End:0x50
		case 4:
			return questUIData.EndNPC;
	}
}

private function bool CheckDrag()
{
	local int X, Y, gabX, gabY;

	GetClientCursorPos(X, Y);
	gabX = X - clickedX;
	gabY = Y - clickedY;
	return Sqrt(float((gabX * gabX) + (gabY * gabY))) > 1;	
}

private function RT_S_EX_QUEST_DIALOG()
{
	local UIPacket._S_EX_QUEST_DIALOG packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_QUEST_DIALOG(packet))
	{
		return;
	}
	HandleNewQuestData(packet.nID, packet.cDialogType);	
}

private function RQ_C_EX_QUEST_TELEPORT()
{
	local array<byte> stream;
	local UIPacket._C_EX_QUEST_TELEPORT packet;

	packet.nID = _currentQuestID;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_QUEST_TELEPORT(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_QUEST_TELEPORT, stream);	
}

private function RQ_C_EX_QUEST_ACCEPT(optional bool bAccept)
{
	local array<byte> stream;
	local UIPacket._C_EX_QUEST_ACCEPT packet;

	lastAcceptedQuestID = _currentQuestID;
	packet.nID = _currentQuestID;
	// End:0x34
	if(bAccept)
	{
		packet.bAccept = 1;		
	}
	else
	{
		packet.bAccept = 0;
	}
	// End:0x61
	if(! class'UIPacket'.static.Encode_C_EX_QUEST_ACCEPT(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_QUEST_ACCEPT, stream);	
}

private function RQ_C_EX_QUEST_COMPLETE()
{
	local array<byte> stream;
	local UIPacket._C_EX_QUEST_COMPLETE packet;

	packet.nID = _currentQuestID;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_QUEST_COMPLETE(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_QUEST_COMPLETE, stream);	
}

private function string API_GetNPCName(int NpcID)
{
	// End:0x13
	if(NpcID == -1)
	{
		return "?";
	}
	return class'UIDATA_NPC'.static.GetNPCName(NpcID);	
}

private function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);	
}

private function bool API_GetNQuestDialogData(int a_QuestID, out NQuestDialogUIData o_data)
{
	return GetNQuestDialogData(a_QuestID, o_data);	
}

private function bool API_GetNQuestNpcPortraitData(int a_NpcID, out NQuestNpcPortraitUIData o_data)
{
	return GetNQuestNpcPortraitData(1000000 + a_NpcID, o_data);	
}

defaultproperties
{
}
