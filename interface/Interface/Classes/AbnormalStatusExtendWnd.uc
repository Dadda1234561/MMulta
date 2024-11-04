class AbnormalStatusExtendWnd extends UICommonAPI;

var WindowHandle Me;
var StatusIconHandle StatusIcon;
var TextBoxHandle Count_txt;
var ButtonHandle DragBtn;
var int NSTATUSICON_MAXCOL;
var int m_EtcStatusRow;
var int m_ShortStatusRow;
var string m_WindowName;
var int bClose;
var bool m_bOnCurState;
var Rect rectWndLDowned;

function OnRegisterEvent()
{
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_StateChanged);	
}

function OnEvent(int Event_ID, string param)
{
	// End:0x15
	if(getInstanceUIData().getIsLiveServer())
	{
		return;
	}
	switch(Event_ID)
	{
		case EV_Restart:
			StatusIcon.Clear();
			break;
		// End:0x27
		case EV_GameStart:
			// End:0x2A
			break;
		case EV_StateChanged:
			HnadleStateChanged();
			// End:0x52
			break;
	}	
}

function OnShow()
{
	// End:0x24
	if(getInstanceUIData().getIsLiveServer())
	{
		Me.HideWindow();
		return;
	}
	closeStatus(bClose);	
}

function OnLoad()
{
	InitHandle();
	// End:0x36
	if(! GetINIInt(m_WindowName, "e", bClose, "WindowsInfo.ini"))
	{
		bClose = 0;
	}	
}

function InitHandle()
{
	NSTATUSICON_MAXCOL = 24;
	Me = GetWindowHandle("AbnormalStatusExtendWnd");
	StatusIcon = GetStatusIconHandle("AbnormalStatusExtendWnd.StatusIcon");
	Count_txt = GetTextBoxHandle("AbnormalStatusExtendWnd.Count_txt");
	DragBtn = GetButtonHandle("AbnormalStatusExtendWnd.DragBtn");
	Count_txt.SetText("0");	
}

function OnClickButton(string Name)
{
	// End:0x0B
	if(CheckDrag())
	{
		return;
	}
	switch(Name)
	{
		// End:0xA2
		case "DragBtn":
			// End:0x69
			if(StatusIcon.IsShowWindow())
			{
				bClose = 1;
				SetINIInt(m_WindowName, "e", bClose, "WindowsInfo.ini");
				closeStatus(bClose);				
			}
			else
			{
				bClose = 0;
				SetINIInt(m_WindowName, "e", bClose, "WindowsInfo.ini");
				closeStatus(bClose);
			}
			// End:0xA5
			break;
	}	
}

function closeStatus(int i)
{
	// End:0x9D
	if(i == 0)
	{
		StatusIcon.ShowWindow();
		DragBtn.SetTexture("L2UI_NewTex.BuffWnd.BuffExpand_Normal", "L2UI_NewTex.BuffWnd.BuffExpand_Over", "L2UI_NewTex.BuffWnd.BuffExpand_Down");		
	}
	else
	{
		StatusIcon.HideWindow();
		DragBtn.SetTexture("L2UI_NewTex.BuffWnd.BuffMin_Normal", "L2UI_NewTex.BuffWnd.BuffMin_Over", "L2UI_NewTex.BuffWnd.BuffMin_Down");
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

function bool CheckDrag()
{
	local Rect rectWnd;

	rectWnd = Me.GetRect();
	return GetAbs(rectWndLDowned.nX - rectWnd.nX) > 5 || GetAbs(rectWndLDowned.nY - rectWnd.nY) > 5;	
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	rectWndLDowned = Me.GetRect();	
}

function AddBuff(array<StatusIconInfo> arr)
{
	InsertBuffList(arr);
	UpdateWindowSize();	
}

function bool InsertBuffList(array<StatusIconInfo> statusIconInfs)
{
	local int i, Count, rowcount;

	StatusIcon.Clear();
	StatusIcon.AddRow();
	StatusIcon.SetIconSize(26);
	Count = statusIconInfs.Length;
	// End:0x58
	if(Count > 0)
	{
		if(GetGameStateName() == "GAMINGSTATE")
		{
			Me.ShowWindow();
		}
	}
	else
	{
		Me.HideWindow();
	}
	rowcount = 0;
	Count_txt.SetText(string(Count));

	// End:0xC0 [Loop If]
	for(i = 0; i < statusIconInfs.Length; i++)
	{
		StatusIcon.AddCol(0, statusIconInfs[i]);
	}
	return statusIconInfs.Length > 0;	
}

function UpdateWindowSize()
{
	local Rect rectWnd, rectBtn;

	rectWnd = StatusIcon.GetRect();
	rectBtn = DragBtn.GetRect();
	Me.SetWindowSize(rectWnd.nWidth + 45, rectBtn.nHeight);	
}

private function HnadleStateChanged()
{
	// End:0x1A
	if(GetGameStateName() != "GAMINGSTATE")
	{
		return;
	}
	// End:0x3F
	if(StatusIcon.GetColCount(0) > 0)
	{
		Me.ShowWindow();
	}	
}

function int GetAbs(int Num)
{
	// End:0x13
	if(Num < 0)
	{
		return - Num;
	}
	return Num;	
}

defaultproperties
{
     m_WindowName="AbnormalStatusExtendWnd"
}
