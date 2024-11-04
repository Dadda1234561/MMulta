//================================================================================
// AbnormalStatusWnd.
//================================================================================

class AbnormalStatusWnd extends UICommonAPI;

const NSTATUSICON_FRAMESIZE = 12;
var WindowHandle Me;
var StatusIconHandle StatusIcon;
var int NSTATUSICON_MAXCOL;
var int m_EtcStatusRow;
var int m_ShortStatusRow;
var bool m_bOnCurState;

function ClearNormals()
{
	ClearStatus(false, false);
}

function ClearStatus(bool bEtcItem, bool bShortItem)
{
	local int i, j, rowcount, RowCountTmp, ColCount;

	local StatusIconInfo Info;

	// End:0x25
	if((bEtcItem == true) && bShortItem == false)
	{
		m_EtcStatusRow = -1;
	}
	// End:0x4A
	if((bEtcItem == false) && bShortItem == true)
	{
		m_ShortStatusRow = -1;
	}

	rowcount = StatusIcon.GetRowCount();

	for(i = 0;i < rowcount;i++)
	{
		ColCount = StatusIcon.GetColCount(i);
		for(j = 0; j < ColCount; j++)
		{
			StatusIcon.GetItem(i, j, Info);
			// End:0x15D
			if(IsValidItemID(Info.Id))
			{
				// End:0x15D
				if(Info.bEtcItem == bEtcItem && Info.bShortItem == bShortItem)
				{
					StatusIcon.DelItem(i, j);
					j--;
					ColCount--;
					RowCountTmp = StatusIcon.GetRowCount();
					// End:0x15D
					if(RowCountTmp != rowcount)
					{
						i--;
						rowcount--;
					}
				}
			}
		}
	}
}

function ClearAll()
{
	ClearNormals();
	ClearStatus(true, false);
	ClearStatus(false, true);
}

function OnRegisterEvent()
{
	RegisterEvent(EV_AbnormalStatusNormalItem);
	RegisterEvent(EV_AbnormalStatusEtcItem);
	RegisterEvent(EV_AbnormalStatusShortItem);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_ShowReplayQuitDialogBox);
	RegisterEvent(EV_LanguageChanged);
	RegisterEvent(EV_StateChanged);
	RegisterEvent(EV_NeedResetUIData);
}

function OnLoad()
{
	NSTATUSICON_MAXCOL = 12;
	m_EtcStatusRow = -1;
	m_ShortStatusRow = -1;
	m_bOnCurState = false;
	InitHandle();
}

function InitHandle()
{
	Me = GetWindowHandle("AbnormalStatusWnd");
	StatusIcon = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon");
}

function OnDefaultPosition()
{
	Me.EnableTick();
}

function OnTick()
{
	local string StatusWndName;

	if(getInstanceUIData().getIsLiveServer())
	{
		StatusWndName = "StatusWnd";
		Me.SetAnchor(StatusWndName, "TopRight", "TopLeft", 6, 0);
	}
	else
	{
		StatusWndName = "StatusWndClassic";
		Me.SetAnchor(StatusWndName, "BottomLeft", "TopLeft", 0, 26);
	}
	Me.ClearAnchor();
	Me.DisableTick();
}

function OnEnterState(name a_CurrentStateName)
{
	m_bOnCurState = true;
	UpdateWindowSize();
}

function OnExitState(name a_CurrentStateName)
{
	m_bOnCurState = false;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_NeedResetUIData:
			if(getInstanceUIData().getIsLiveServer())
			{
				NSTATUSICON_MAXCOL = 12;
			}
			else
			{
				NSTATUSICON_MAXCOL = 24;
			}
			// End:0xDE
			break;
		case EV_AbnormalStatusNormalItem:
			HandleAddNormalStatus(param);
			// End:0xDE
			break;
		case EV_AbnormalStatusEtcItem:
			HandleAddEtcStatus(param);
			// End:0xDE
			break;
		case EV_AbnormalStatusShortItem:
			HandleAddShortStatus(param);
			// End:0xDE
			break;
		case EV_Restart:
			ClearAll();
			// End:0xDE
			break;
		case EV_ShowReplayQuitDialogBox:
			Me.HideWindow();
			// End:0xDE
			break;
		case EV_LanguageChanged:
			HandleLanguageChanged();
			// End:0xDE
			break;
		case EV_StateChanged:
			if(param == "GAMINGSTATE")
			{
				UpdateWindowSize();
			}
			break;
	}
}

function OnShow()
{
	local int rowcount;

	rowcount = StatusIcon.GetRowCount();
	// End:0x2F
	if(rowcount < 1)
	{
		Me.HideWindow();
	}
}

function OnClickItem(string strID, int Index)
{
	local int Row, Col;
	local StatusIconInfo Info;
	local SkillInfo SkillInfo;

	Col = Index / 10;
	Row = Index - (Col * 10);
	StatusIcon.GetItem(Row, Col, Info);
	// End:0x78
	if(! GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, SkillInfo))
	{
		return;
	}
	// End:0xF3
	if(InStr(strID, "StatusIcon") > -1)
	{
		// End:0xE8
		if((SkillInfo.Debuff == 0) && SkillInfo.OperateType == 1)
		{
			RequestDispel(Info.ServerID, Info.Id, Info.Level, Info.SubLevel);
		}
		else
		{
			AddSystemMessage(2318);
		}
	}
}

function HandleAddNormalStatus(string param)
{
	local int i, Max;
	local StatusIconInfo Info;
	local SkillInfo _skillInfo;
	local array<StatusIconInfo> arrSongDance, arrDebuff, arrItembuff, arrTriggerSkill, arrBuff, arrExtendBuff;

	local bool isDebuff;

	ClearNormals();
	Info.Size = 24;
	Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	Info.bShow = true;
	Info.bEtcItem = false;
	Info.bShortItem = false;
	ParseInt(param, "ServerID", Info.ServerID);
	ParseInt(param, "Max", Max);

	for(i = 0;i < Max;i++)
	{
		ParseItemIDWithIndex(param, Info.Id, i);
		ParseString(param, "IconPanel_" $ string(i), Info.IconPanel);
		ParseInt(param, "SkillLevel_" $ string(i), Info.Level);
		ParseInt(param, "SkillSubLevel_" $ string(i), Info.SubLevel);
		ParseInt(param, "RemainTime_" $ string(i), Info.RemainTime);
		ParseString(param, "Name_" $ string(i), Info.Name);
		ParseString(param, "IconName_" $ string(i), Info.IconName);
		ParseString(param, "Description_" $ string(i), Info.Description);
		ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
		// End:0x24F
		if(! GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, _skillInfo))
		{
			continue;
		}
		// End:0x279
		if(IsIconHide(Info.Id, Info.Level, Info.SubLevel))
		{
			continue;
		}
		// End:0x291
		if(! IsValidItemID(Info.Id))
		{
			continue;
		}
		isDebuff = GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0;
		// End:0x305
		if(isDebuff && getInstanceUIData().getIsClassicServer())
		{
			arrDebuff.Length = arrDebuff.Length + 1;
			arrDebuff[arrDebuff.Length - 1] = Info;
			// [Explicit Continue]
			continue;
		}
		
		switch(_skillInfo.IsMagic)
		{
			case 3:
				arrSongDance.Length = arrSongDance.Length + 1;
				arrSongDance[arrSongDance.Length - 1] = Info;
				break;
			case 4:
				arrItembuff.Length = arrItembuff.Length + 1;
				arrItembuff[arrItembuff.Length - 1] = Info;
				break;
			case 5:
				arrTriggerSkill.Length = arrTriggerSkill.Length + 1;
				arrTriggerSkill[arrTriggerSkill.Length - 1] = Info;
				break;
			case 0:
			case 1:
				// End:0x3D1
				if(isDebuff)
				{
					arrDebuff.Length = arrDebuff.Length + 1;
					arrDebuff[arrDebuff.Length - 1] = Info;					
				}
				else
				{
					// End:0x40C
					if(getInstanceUIData().getIsLiveServer())
					{
						arrBuff.Length = arrBuff.Length + 1;
						arrBuff[arrBuff.Length - 1] = Info;						
					}
					else
					{
						// End:0x457
						if(_skillInfo.OperateType == 1 || _skillInfo.OperateType == 3 || _skillInfo.OperateType == 6)
						{
							arrExtendBuff[arrExtendBuff.Length] = Info;							
						}
						else
						{
							arrBuff.Length = arrBuff.Length + 1;
							arrBuff[arrBuff.Length - 1] = Info;
						}
					}
				}
				break;
			default:
				if(isDebuff)
				{
					arrDebuff.Length = arrDebuff.Length + 1;
					arrDebuff[arrDebuff.Length - 1] = Info;					
				}
				else
				{
					arrBuff.Length = arrBuff.Length + 1;
					arrBuff[arrBuff.Length - 1] = Info;
				}
				// End:0x3F4
				break;
		}
	}
	AbnormalStatusExtendWnd(GetScript("AbnormalStatusExtendWnd")).AddBuff(arrExtendBuff);
	InsertBuffList(arrBuff);
	// End:0x440
	if(getInstanceUIData().getIsClassicServer())
	{
		InsertBuffList(arrItembuff);
		InsertBuffList(arrSongDance);
		InsertBuffList(arrTriggerSkill);
	}
	else
	{
		InsertBuffList(arrSongDance);
		InsertBuffList(arrItembuff);
		InsertBuffList(arrTriggerSkill);
	}
	InsertBuffList(arrDebuff);
	// End:0x490
	if(m_EtcStatusRow > -1)
	{
		m_EtcStatusRow = StatusIcon.GetRowCount();
	}
	// End:0x4B4
	if(m_ShortStatusRow > -1)
	{
		m_ShortStatusRow = StatusIcon.GetRowCount();
	}
	UpdateWindowSize();
}

function bool InsertBuffList(array<StatusIconInfo> statusIconInfs)
{
	local int i, RowCount;

	// End:0x38
	if(m_EtcStatusRow == -1 && m_ShortStatusRow == -1)
	{
		RowCount = StatusIcon.GetRowCount();
	}
	else
	{
		RowCount = StatusIcon.GetRowCount() - 1;
	}
	
	for(i = 0; i < statusIconInfs.Length; i++)
	{
		if(i % NSTATUSICON_MAXCOL == 0)
		{
			RowCount++;
			StatusIcon.InsertRow(RowCount - 1);
		}
		StatusIcon.AddCol(RowCount - 1, statusIconInfs[i]);
	}
	return statusIconInfs.Length > 0;
}

function HandleAddEtcStatus(string param)
{
	local int i, Max;
	local StatusIconInfo Info;

	ClearStatus(true, false);
	Info.Size = 24;
	Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	Info.bShow = true;
	Info.bEtcItem = true;
	Info.bShortItem = false;
	ParseInt(param, "Max", Max);
	
	for(i = 0;i < Max;i++)
	{
		ParseItemIDWithIndex(param, Info.Id, i);
		ParseInt(param, "SkillLevel_" $ string(i), Info.Level);
		ParseInt(param, "RemainTime_" $ string(i), Info.RemainTime);
		ParseString(param, "Name_" $ string(i), Info.Name);
		ParseString(param, "IconName_" $ string(i), Info.IconName);
		ParseString(param, "Description_" $ string(i), Info.Description);
		ParseString(param, "IconPanel_" $ string(i), Info.IconPanel);
		// End:0x214
		if(IsValidItemID(Info.Id))
		{
			// End:0x1FB
			if((m_EtcStatusRow == -1) && m_ShortStatusRow == -1)
			{
				m_EtcStatusRow = StatusIcon.GetRowCount();
				StatusIcon.AddRow();
			}
			StatusIcon.AddCol(m_EtcStatusRow, Info);
		}
	}
	UpdateWindowSize();
}

function HandleAddShortStatus(string param)
{
	local int i, Max, CurCol;
	local StatusIconInfo Info;

	ClearStatus(false, true);
	Info.Size = 24;
	Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	Info.bShow = true;
	Info.bEtcItem = false;
	Info.bShortItem = true;
	CurCol = -1;
	ParseInt(param, "Max", Max);
	
	for(i = 0;i < Max;i++)
	{
		ParseItemIDWithIndex(param, Info.Id, i);
		ParseInt(param, "SkillLevel_" $ string(i), Info.Level);
		ParseInt(param, "SkillSubLevel_" $ string(i), Info.SubLevel);
		ParseInt(param, "RemainTime_" $ string(i), Info.RemainTime);
		ParseString(param, "Name_" $ string(i), Info.Name);
		ParseString(param, "IconName_" $ string(i), Info.IconName);
		ParseString(param, "Description_" $ string(i), Info.Description);
		ParseString(param, "IconPanel_" $ string(i), Info.IconPanel);
		// End:0x259
		if(IsValidItemID(Info.Id))
		{
			// End:0x234
			if((m_EtcStatusRow == -1) && m_ShortStatusRow == -1)
			{
				m_ShortStatusRow = StatusIcon.GetRowCount();
				StatusIcon.AddRow();
			}
			CurCol++;
			StatusIcon.InsertCol(m_ShortStatusRow, CurCol, Info);
		}
	}
	UpdateWindowSize();
}

function UpdateWindowSize()
{
	local int RowCount;
	local Rect rectWnd;

	RowCount = StatusIcon.GetRowCount();
	// End:0xC4
	if(RowCount > 0)
	{
		// End:0x5B
		if(m_bOnCurState && GetGameStateName() != "TRAININGROOMSTATE")
		{
			Me.ShowWindow();
		}
		else
		{
			Me.HideWindow();
		}
		rectWnd = StatusIcon.GetRect();
		// End:0xD7
		if(getInstanceUIData().getIsLiveServer())
		{
			Me.SetWindowSize(rectWnd.nWidth + NSTATUSICON_FRAMESIZE, rectWnd.nHeight);
			Me.SetFrameSize(NSTATUSICON_FRAMESIZE, rectWnd.nHeight);			
		}
		else
		{
			Me.SetWindowSize(rectWnd.nWidth, rectWnd.nHeight);
		}
	}
	else
	{
		Me.HideWindow();
	}
}

function HandleLanguageChanged()
{
	local int i, j, RowCount, ColCount;
	local StatusIconInfo Info;

	RowCount = StatusIcon.GetRowCount();
	
	for(i = 0;i < RowCount;i++)
	{
		ColCount = StatusIcon.GetColCount(i);
		
		for(j = 0;j < ColCount;j++)
		{
			StatusIcon.GetItem(i, j, Info);
			// End:0x11A
			if(IsValidItemID(Info.Id))
			{
				Info.Name = class 'UIDATA_SKILL'.static.GetName(Info.Id, Info.Level, Info.SubLevel);
				Info.Description = class 'UIDATA_SKILL'.static.GetDescription(Info.Id, Info.Level, Info.SubLevel);
				StatusIcon.SetItem(i, j, Info);
			}
		}
	}
}

defaultproperties
{
}
