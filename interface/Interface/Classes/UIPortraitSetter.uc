class UIPortraitSetter extends UICommonAPI;

var EditBoxHandle NCEditBox0;
var CharacterViewportWindowHandle characterViewport;

event OnLoad()
{
	SetClosingOnESC();
	NCEditBox0 = GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".NCEditBox0");
	characterViewport = GetCharacterViewportWindowHandle("QuestDialogWnd.viewport");	
}

event OnClickButton(string strBtn)
{
	Debug("strBtn :" @ strBtn);
	switch(strBtn)
	{
		// End:0x5A
		case "spawn":
			characterViewport.SetNPCInfo(int(NCEditBox0.GetString()));
			characterViewport.SpawnNPC();
			// End:0x73
			break;
		// End:0x70
		case "ResetBtn":
			Reset();
			// End:0x73
			break;
	}	
}

event OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local float fTick;

	Debug("OnModifyCurrentTickSliderCtrl" @ strID @ string(iCurrentTick));
	switch(strID)
	{
		// End:0xD1
		case "SliderCtrlScale":
			fTick = float(iCurrentTick) / float(100);
			// End:0x7B
			if(fTick == 0)
			{
				fTick = 0.010f;
			}
			SetFValueString(strID, fTick);
			characterViewport.SetCharacterScale(fTick);
			characterViewport.SetNPCInfo(int(NCEditBox0.GetString()));
			characterViewport.SpawnNPC();
			// End:0x235
			break;
		// End:0x115
		case "SliderCtrlCameraDistance":
			characterViewport.SetCameraDistance(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			// End:0x235
			break;
		// End:0x14E
		case "SliderCtrlYaw":
			characterViewport.SetCurrentRotation(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			// End:0x235
			break;
		// End:0x19A
		case "SliderCtrlOffSetX":
			iCurrentTick = iCurrentTick - 50;
			characterViewport.SetCharacterOffsetX(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			// End:0x235
			break;
		// End:0x1E6
		case "SliderCtrlOffSetY":
			iCurrentTick = iCurrentTick - 50;
			characterViewport.SetCharacterOffsetY(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			// End:0x235
			break;
		// End:0x232
		case "SliderCtrlOffSetZ":
			iCurrentTick = iCurrentTick - 50;
			characterViewport.SetCharacterOffsetZ(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			// End:0x235
			break;
	}	
}

event OnCompleteEditBox(string strID)
{
	local SliderCtrlHandle slider;
	local int Value;

	switch(strID)
	{
		// End:0x25
		case "NCEditBox0":
			OnClickButton("spawn");
			return;
		// End:0x3C
		case "txtICurTickOffSetX":
		// End:0x53
		case "txtICurTickOffSetY":
		// End:0xA3
		case "txtICurTickOffSetZ":
			Value = int(GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ strID).GetString()) + 50;
			// End:0x12D
			break;
		// End:0xF5
		case "txtIcurTickScale":
			Value = int(float(GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ strID).GetString()) * float(100));
			// End:0x12D
			break;
		// End:0xFFFF
		default:
			Value = int(GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ strID).GetString());
			// End:0x12D
			break;
	}
	slider = GetSliderCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrl" $ Right(strID, Len(strID) - 11));
	slider.SetCurrentTick(Value);	
}

event OnShow()
{
	// End:0x0D
	if(! IsBuilderPC())
	{
		return;
	}
	// End:0x20
	if(GetReleaseMode() != RM_DEV)
	{
		return;
	}	
}

function _SetCurrentQuestInfo()
{
	local NQuestUIData questUIData;

	// End:0x4C
	if(API_GetNQuestData(QuestDialogWnd(GetScript("QuestDialogWnd"))._currentQuestID, questUIData))
	{
		SetPortrait(questUIData);
		m_hOwnerWnd.ShowWindow();
	}	
}

private function SetPortrait(NQuestUIData questUIData)
{
	local NQuestNpcPortraitUIData questNpcPortraitUIData;
	local int questPortraitID;
	local QuestDialogWnd QuestDialogWndScr;

	QuestDialogWndScr = QuestDialogWnd(GetScript("QuestDialogWnd"));
	switch(QuestDialogWndScr._currentDialogType)
	{
		// End:0x41
		case QuestDialogWndScr.QUESTDialogType.Start:
		// End:0x69
		case QuestDialogWndScr.QUESTDialogType.Accept:
			questPortraitID = questUIData.StartNPC.Id;
			// End:0xA6
			break;
		// End:0x79
		case QuestDialogWndScr.QUESTDialogType.complete:
		// End:0xA1
		case QuestDialogWndScr.QUESTDialogType.End:
			questPortraitID = questUIData.EndNPC.Id;
			// End:0xA6
			break;
	}
	API_GetNQuestNpcPortraitData(questPortraitID, questNpcPortraitUIData);
	Debug("SetPortrait --- " @ string(questPortraitID));
	NCEditBox0.SetString(string(questPortraitID));
	SetFValue("scale", questNpcPortraitUIData.ViewScale);
	SetFValue("Yaw", float(questNpcPortraitUIData.ViewRotationYaw));
	SetFValue("CameraDistance", float(questNpcPortraitUIData.ViewDist));
	SetFValue("OffsetX", float(questNpcPortraitUIData.ViewOffsetX));
	SetFValue("OffsetY", float(questNpcPortraitUIData.ViewOffsetY));
	SetFValue("OffsetZ", float(questNpcPortraitUIData.ViewOffsetZ));
	characterViewport.SetNPCInfo(questPortraitID);
	characterViewport.SpawnNPC();
	SetAllCurTick();	
}

private function bool API_GetNQuestNpcPortraitData(int a_NpcID, out NQuestNpcPortraitUIData o_data)
{
	return GetNQuestNpcPortraitData(1000000 + a_NpcID, o_data);	
}

private function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);	
}

private function Reset()
{
	_SetCurrentQuestInfo();
	SetAllCurTick();	
}

private function SetAllCurTick()
{
	OnCompleteEditBox("txtICurTickScale");
	OnCompleteEditBox("txtICurTickCameraDistance");
	OnCompleteEditBox("txtICurTickYaw");
	OnCompleteEditBox("txtICurTickOffSetX");
	OnCompleteEditBox("txtICurTickOffSetY");
	OnCompleteEditBox("txtICurTickOffSetZ");
	OnCompleteEditBox("txtICurTickOffSetX");
	OnCompleteEditBox("txtICurTickTimer");	
}

private function SetValueString(string strID, int Value)
{
	SetValue(Right(strID, Len(strID) - 10), Value);	
}

private function SetValue(string typeString, int Value)
{
	GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick" $ typeString).SetString(string(Value));	
}

private function SetFValueString(string strID, float Value)
{
	SetFValue(Right(strID, Len(strID) - 10), Value);	
}

private function SetFValue(string typeString, float Value)
{
	GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick" $ typeString).SetString(string(Value));	
}

private function string GetValueString(string strID)
{
	return GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick" $ Right(strID, Len(strID) - 10)).GetString();	
}

private function string GetEditorString(string typeString)
{
	return GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick" $ typeString).GetString();	
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();	
}

defaultproperties
{
}
