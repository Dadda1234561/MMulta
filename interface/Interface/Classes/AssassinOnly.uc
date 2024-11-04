class AssassinOnly extends UICommonAPI;

const skillBuffClassID = 87366;

var WindowHandle Me;
var TextBoxHandle AssassinPoint_txt;
var TextureHandle AssassinMain_tex;
var AnimTextureHandle AssassinPoint_ani;
var AnimTextureHandle AssassinMain_ani;
var AnimTextureHandle AssassinGauge_Trailer;
var int Count;
var int beforeCount;
var int MyMaxAP;
var int MYCurrentAP;
var int RemainTime;
var L2UITimerObject timeObject;
var SkillInfo skillBuffInfo;
var ProgressCtrlHandle AssassinGauge_progressbar;
var int posX;
var int posY;
var int startPosX;
var float timeSec;

function OnRegisterEvent()
{
	RegisterEvent(EV_UpdateMyAP);
	RegisterEvent(EV_UpdateMyMaxAP);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_AbnormalStatusNormalItem);
	RegisterEvent(EV_StateChanged);
}

function OnLoad()
{
	Initialize();
	Load();	
}

function Initialize()
{
	Me = GetWindowHandle("AssassinOnly");
	AssassinPoint_txt = GetTextBoxHandle("AssassinOnly.AssassinPoint_txt");
	AssassinMain_tex = GetTextureHandle("AssassinOnly.AssassinMain_tex");
	AssassinPoint_ani = GetAnimTextureHandle("AssassinOnly.AssassinPoint_ani");
	AssassinMain_ani = GetAnimTextureHandle("AssassinOnly.AssassinMain_ani");
	AssassinGauge_Trailer = GetAnimTextureHandle("AssassinOnly.AssassinGauge_Trailer");
	AssassinGauge_progressbar = GetProgressCtrlHandle("AssassinOnly.AssassinGauge_progressbar");
	AssassinPoint_txt.SetText("-");
	GetSkillInfo(skillBuffClassID, 1, 0, skillBuffInfo);
	AssassinGauge_Trailer.HideWindow();
	AssassinGauge_progressbar.SetPos(0);	
}

function OnShow()
{
}

function Load();

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		// End:0x3A
		case EV_UpdateMyMaxAP:
			ParseInt(a_Param, "MyMaxAP", MyMaxAP);
			if(GetGameStateName() == "GAMINGSTATE")
			{
				// End:0x5C
				if(timeSec <= 0)
				{
					AssassinGauge_Trailer.HideWindow();
				}
				Me.ShowWindow();
			}
			// End:0x1BF
			break;
		// End:0x158
		case EV_UpdateMyAP:
			ParseInt(a_Param, "MYCurrentAP", MYCurrentAP);
			beforeCount = Count;
			Count = MYCurrentAP / 10000;
			AssassinPoint_txt.SetText("x" $ string(Count));
			// End:0xFA
			if(Count > 0)
			{
				AssassinMain_tex.SetTexture("L2UI_NewTex.AssassinOnly.AssassinOnly_Active");
				// End:0xF7
				if(beforeCount == 0)
				{
					AnimTexturePlay(AssassinMain_ani, true, 1);
				}				
			}
			else
			{
				AssassinMain_tex.SetTexture("L2UI_NewTex.AssassinOnly.AssassinOnly_Disabled");
			}
			// End:0x155
			if(beforeCount != Count)
			{
				AnimTexturePlay(AssassinPoint_ani, true, 1);
			}
			// End:0x1BF
			break;
		// End:0x180
		case EV_AbnormalStatusNormalItem:
			// End:0x17D
			if(Me.IsShowWindow())
			{
				ParseAbnormalStatusNormalItem(a_Param);
			}
			// End:0x1BF
			break;
		// End:0x1BC
		case EV_Restart:
			MyMaxAP = 0;
			Me.HideWindow();
			AssassinGauge_progressbar.SetPos(0);
			AssassinGauge_Trailer.HideWindow();
			timeKill();
			// End:0x1BF
			break;
		case EV_StateChanged:
			HnadleStateChanged();
			// End:0x204
			break;
	}	
}

function ParseAbnormalStatusNormalItem(string a_Param)
{
	local int i, Max, ClassID;
	local bool bHasSkill;

	ParseInt(a_Param, "Max", Max);
	// End:0x47
	if(Max == 0)
	{
		AssassinGauge_progressbar.SetPos(0);
		AssassinGauge_Trailer.HideWindow();
		timeKill();
		return;
	}

	// End:0x219 [Loop If]
	for(i = 0; i < Max; i++)
	{
		ParseInt(a_Param, "ClassID_" $ string(i), ClassID);
		// End:0x20F
		if(ClassID == skillBuffClassID)
		{
			ParseInt(a_Param, "RemainTime_" $ string(i), RemainTime);
			timeObject._Kill();
			timeObject = class'L2UITimer'.static.Inst()._AddTimer(100, RemainTime * 10);
			timeObject._DelegateOnTime = OnTime;
			timeObject._DelegateOnEnd = OnEndTime;
			AssassinGauge_progressbar.SetProgressTime(skillBuffInfo.AbnormalTime * 1000);
			AssassinGauge_progressbar.SetPos(RemainTime * 1000);
			AssassinGauge_progressbar.Start();
			posX = Me.GetRect().nX + 52;
			posY = Me.GetRect().nY + 40;
			startPosX = int(float(52) + (float(134 * float(RemainTime * 10)) / float(skillBuffInfo.AbnormalTime * 10)));
			timeSec = float(RemainTime);
			AnimTexturePlay(AssassinGauge_Trailer, true, 9999);
			AssassinGauge_Trailer.MoveTo(posX, posY);
			bHasSkill = true;
			// [Explicit Break]
			break;
		}
	}
	// End:0x25E
	if((bHasSkill == false) && AssassinGauge_Trailer.IsShowWindow())
	{
		AssassinGauge_progressbar.SetPos(0);
		AssassinGauge_Trailer.HideWindow();
		timeKill();
	}	
}

function OnTime(int Count)
{
	posX = Me.GetRect().nX + startPosX;
	AssassinGauge_Trailer.MoveTo(int(float(posX) - (134.0f * (((float(RemainTime) - timeSec) * 10) / float(skillBuffInfo.AbnormalTime * 10)))), AssassinGauge_Trailer.GetRect().nY);
	timeSec = timeSec - 0.10f;	
}

function OnEndTime()
{
	AssassinGauge_progressbar.SetPos(0);
	AssassinGauge_Trailer.HideWindow();
	timeKill();	
}

function timeKill()
{
	timeObject._Kill();	
}

private function HnadleStateChanged()
{
	// End:0x1A
	if(GetGameStateName() != "GAMINGSTATE")
	{
		return;
	}
	// End:0x53
	if(MyMaxAP > 0)
	{
		AssassinGauge_progressbar.SetPos(int(timeSec * 1000));
		Me.ShowWindow();
	}	
}

defaultproperties
{
}
