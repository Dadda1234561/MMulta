//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : InstancedZoneHistoryWnd  - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class InstancedZoneHistoryWnd extends UICommonAPI;

function OnLoad()
{
	SetClosingOnESC();
}

function OnRegisterEvent()
{
	RegisterEvent(EV_InzoneWaitingInfo);
}

function OnEvent(int a_EventID, string a_Param)
{
	local int nShowWindow;

	switch(a_EventID)
	{
		// End:0x87
		case EV_InzoneWaitingInfo:
			ParseInt(a_Param, "ShowWindow", nShowWindow);
			// End:0x61
			if(nShowWindow > 0)
			{
				ShowWindowWithFocus("InstancedZoneHistoryWnd");
				handleInzoneWaitingInfo(a_Param);
			}
			Debug("EV_InzoneWaitingInfo" @ a_Param);
			// End:0x8A
			break;
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x40
		case "refresh_Btn":
			Debug("RequestInzoneWaitingTime");
			RequestInzoneWaitingTime();
			// End:0x43
			break;
	}
}

function handleInzoneWaitingInfo(string param)
{
	local int currentInzoneID, sizeOfBlockedInzone, blockedInzoneID, blockedInzoneLeftSeconds;
	local string currentInzoneName, blockedInzoneName, LeftTime;
	local int i;

	ParseInt(param, "currentInzoneID", currentInzoneID);
	currentInzoneName = GetInZoneNameWithZoneID(currentInzoneID);
	// End:0x57
	if(currentInzoneName == "Invalid inzone ID")
	{
		currentInzoneName = "";
	}
	ParseInt(param, "sizeOfBlockedInzone", sizeOfBlockedInzone);
	// End:0xD4
	if(currentInzoneName == "")
	{
		GetTextBoxHandle("InstancedZoneHistoryWnd.CurrentInzoneTextBox").SetText(GetSystemString(2794));		
	}
	else
	{
		GetTextBoxHandle("InstancedZoneHistoryWnd.CurrentInzoneTextBox").SetText(currentInzoneName);
	}
	GetRichListCtrlHandle("InstancedZoneHistoryWnd.HistoryRichListCtrl").DeleteAllItem();

	// End:0x252 [Loop If]
	for(i = 0; i < sizeOfBlockedInzone; i++)
	{
		blockedInzoneName = "";
		LeftTime = "";
		ParseInt(param, "blockedInzoneID_" $ string(i), blockedInzoneID);
		ParseInt(param, "blockedInzoneLeftSeconds_" $ string(i), blockedInzoneLeftSeconds);
		blockedInzoneName = GetInZoneNameWithZoneID(blockedInzoneID);
		LeftTime = setTimeString(blockedInzoneLeftSeconds);
		GetRichListCtrlHandle("InstancedZoneHistoryWnd.HistoryRichListCtrl").InsertRecord(makeRecord(blockedInzoneName, LeftTime));
	}
}

function RichListCtrlRowData makeRecord(string blockedInzoneName, string LeftTime)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 2;
	addRichListCtrlString(Record.cellDataList[0].drawitems, blockedInzoneName);
	addRichListCtrlString(Record.cellDataList[1].drawitems, LeftTime);
	return Record;
}

function string setTimeString(int tmpTime)
{
	//규칙 1시간 이상은 시간만
	//1시간 이하는 분만
	//1분 이하는 1분 이하
	local string timeStr;
	local int timeHour;
	local int timeMin;
	//local int stringNum
	//Debug("타임을 세팅합니다.");
	//Debug("tmpTime=== " @ tmpTime);
	if ( tmpTime < 60 ) //분 미만으로
	{ 			
		timeStr = MakeFullSystemMsg( GetSystemMessage(3390), string(1)); //1 분
		timeStr = MakeFullSystemMsg( GetSystemMessage(3408), timeStr);   //미만
	} 
	else if ( tmpTime < 3600 ) {//몇 분으로	
		tmpTime = tmpTime/60;
		timeStr = MakeFullSystemMsg( GetSystemMessage(3390), string(tmpTime));			
	} 
	else {//시간
		//tmpTime = tmpTime/3600;
		//timeStr = MakeFullSystemMsg( GetSystemMessage(3406), string(tmpTime));	
		//timeHour = 	tmpTime/3600;	
			

		timeHour = tmpTime/3600;
		timeMin	= (tmpTime - timeHour*3600)/60;
		//Debug("timeHour=== " @ timeHour);
		//Debug("timeMin=== " @ timeMin);
		if(timeMin > 0){
			timeStr = MakeFullSystemMsg( GetSystemMessage(3406), string(timeHour)) @ MakeFullSystemMsg( GetSystemMessage(3390), string(timeMin));
		}else {
			timeStr = MakeFullSystemMsg( GetSystemMessage(3406), string(timeHour));
		}
		
	}
	//Debug("timeStr=== " @ timeStr);
	return timeStr;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
