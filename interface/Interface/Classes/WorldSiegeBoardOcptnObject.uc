class WorldSiegeBoardOcptnObject extends UIScript;

const STATE_DESPAWN = 'stateDespawn';
const STATE_NotOccupied = 'stateNotOccupied';
const STATE_ATTACKED = 'stateAttacked';
const STATE_OCCUPIED = 'stateOccupied';
const STATE_OCCUPIEDDESPAWN = 'stateOccupiedDespawn';
const TIMER_ID_DESPAWN = 0;
const TIMER_TIME_DESPAWN = 180000;

var int sID;
var int ClassID;
var WorldSiegeBoardWnd worldSiegeBoardWndScr;
var TextureHandle Icon_ocptnFlag;
var TextureHandle PledgeCrest_tex;
var AnimTextureHandle Glow_ani;
var int PledgeID;
var Vector Loc;
var int Index;
var int Tier;
var bool IsMouseOver;

static function WorldSiegeBoardOcptnObject InitScript(WindowHandle wnd, int idx)
{
	local WorldSiegeBoardOcptnObject script;

	wnd.SetScript("WorldSiegeBoardOcptnObject");
	script = WorldSiegeBoardOcptnObject(wnd.GetScript());
	script.Index = idx;
	script.InitWnd(wnd);
	return script;
}

function InitWnd(WindowHandle Window)
{
	m_hOwnerWnd = Window;
	worldSiegeBoardWndScr = WorldSiegeBoardWnd(GetScript("WorldSiegeBoardWnd"));
	Icon_ocptnFlag = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Icon_ocptnFlag");
	PledgeCrest_tex = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".PledgeCrest_tex");
	Glow_ani = GetAnimTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Glow_ani");
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	IsMouseOver = true;
	SetTexture();
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	IsMouseOver = false;
	SetTexture();
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		// End:0x25
		case TIMER_ID_DESPAWN:
			m_hOwnerWnd.KillTimer(TIMER_ID_DESPAWN);
			GotoState(STATE_DESPAWN);
			// End:0x28
			break;
	}
}

function SetTier(int ClassID)
{
	local int i;
	local array<WorldCastleWarMapData> o_npcInfo;

	API_GetWorldCastleWarMapInfo(o_npcInfo);

	// End:0x69 [Loop If]
	for(i = 0; i < o_npcInfo.Length; i++)
	{
		// End:0x5F
		if(o_npcInfo[i].ClassID == ClassID - 1000000)
		{
			Tier = o_npcInfo[i].Tier;
			SetTexture();
		}
	}
}

function SendOccupyInfoRadar(UIPacket._WorldCastleWar_MainBattleOccupyInfo occupyInfo)
{
	local string param;

	param = "";
	ParamAdd(param, "index", string(Index));
	ParamAdd(param, "tier", string(Tier));
	ParamAdd(param, "sID", string(sID));
	ParamAdd(param, "state", string(occupyInfo.nOccypyNPCState));
	ParamAdd(param, "x", string(occupyInfo.nOccypyNPCLocation.X));
	ParamAdd(param, "y", string(occupyInfo.nOccypyNPCLocation.Y));
	ParamAdd(param, "z", string(occupyInfo.nOccypyNPCLocation.Z));
	ParamAdd(param, "pledgeID", string(PledgeID));
	ParamAdd(param, "pledgeName", class'UIDATA_CLAN'.static.GetName(PledgeID));
	ParamAdd(param, "pledgeTextureName", PledgeCrest_tex.GetTextureName());
	CallGFxFunction("RadarMapWnd", "WorldSiege_occupyInfo", param);
}

function SendHideOccupyInfoRadar()
{
	local string param;

	param = "";
	ParamAdd(param, "index", string(Index));
	ParamAdd(param, "tier", string(Tier));
	ParamAdd(param, "sID", string(sID));
	ParamAdd(param, "state", string(0));
	ParamAdd(param, "x", string(0));
	ParamAdd(param, "y", string(0));
	ParamAdd(param, "z", string(0));
	ParamAdd(param, "pledgeID", string(0));
	ParamAdd(param, "pledgeName", "");
	ParamAdd(param, "pledgeTextureName", "");
	CallGFxFunction("RadarMapWnd", "WorldSiege_occupyInfo", param);
}

function _SetMainBattleOccupyInfo(UIPacket._WorldCastleWar_MainBattleOccupyInfo occupyInfo)
{
	sID = occupyInfo.nOccupyNPCSID;
	// End:0x44
	if(ClassID != occupyInfo.nOccupyNPCClassID)
	{
		SetTier(occupyInfo.nOccupyNPCClassID);
		ClassID = occupyInfo.nOccupyNPCClassID;
	}
	switch(occupyInfo.nOccypyNPCState)
	{
		// End:0x75
		case 0:
			// End:0x6B
			if(GetStateName() == STATE_OCCUPIED)
			{
				GotoState(STATE_OCCUPIEDDESPAWN);				
			}
			else
			{
				GotoState(STATE_DESPAWN);
			}
			// End:0xD3
			break;
		// End:0x83
		case 1:
			GotoState(STATE_NotOccupied);
			// End:0xD3
			break;
		// End:0x92
		case 2:
			GotoState(STATE_ATTACKED);
			// End:0xD3
			break;
		// End:0xB1
		case 3:
			PledgeID = occupyInfo.nOccupiedPledgeSID;
			GotoState(STATE_OCCUPIED);
			// End:0xD3
			break;
		// End:0xD0
		case 4:
			PledgeID = occupyInfo.nOccupiedPledgeSID;
			GotoState(STATE_OCCUPIEDDESPAWN);
			// End:0xD3
			break;
		// End:0xFFFF
		default:
			break;
	}
	Loc = class'WorldSiegeBoardWnd'.static.Inst().PositionToVector(occupyInfo.nOccypyNPCLocation);
	SendOccupyInfoRadar(occupyInfo);
}

function SetPledgeID()
{
	local Texture PledgeCrestTexture;

	// End:0x3F
	if(class'UIDATA_CLAN'.static.GetCrestTexture(PledgeID, PledgeCrestTexture))
	{
		PledgeCrest_tex.ShowWindow();
		PledgeCrest_tex.SetTextureWithObject(PledgeCrestTexture);
	}
	SetCrestTooltipInfo(PledgeID);
}

function SetTexture()
{
	// End:0x76
	if(IsMouseOver)
	{
		Icon_ocptnFlag.SetTexture("L2UI_EPIC.WorldSiegeWnd.WorldSiegeWnd_Occupation" $ class'UICommonAPI'.static.getInstanceUIData().Int2Str(Tier) $ "_Over");		
	}
	else
	{
		Icon_ocptnFlag.SetTexture("L2UI_EPIC.WorldSiegeWnd.WorldSiegeWnd_Occupation" $ class'UICommonAPI'.static.getInstanceUIData().Int2Str(Tier) $ "_Normal");
	}
}

function API_GetWorldCastleWarMapInfo(out array<WorldCastleWarMapData> o_npcInfo)
{
	GetWorldCastleWarMapInfo(WCWMNT_Occupy, o_npcInfo);
}

function Color GetStateColor()
{
	switch(GetStateName())
	{
		// End:0x26
		case STATE_NotOccupied:
			return class'L2Util'.static.Inst().White;
		// End:0x47
		case STATE_ATTACKED:
			return class'L2Util'.static.Inst().Red;
		// End:0x68
		case STATE_OCCUPIED:
			return class'L2Util'.static.Inst().BWhite;
		// End:0x89
		case STATE_OCCUPIEDDESPAWN:
			return class'L2Util'.static.Inst().BWhite;
		// End:0xFFFF
		default:
			return class'L2Util'.static.Inst().White;
	}
}

function string GetStateString()
{
	switch(GetStateName())
	{
		// End:0x10
		case 'stateDespawn':
			return "";
		// End:0x24
		case STATE_NotOccupied:
			return GetSystemString(13803);
		// End:0x38
		case STATE_ATTACKED:
			return GetSystemString(13804);
		// End:0x4C
		case STATE_OCCUPIED:
			return GetSystemString(13805);
		// End:0x60
		case STATE_OCCUPIEDDESPAWN:
			return GetSystemString(13805);
		// End:0xFFFF
		default:
			return string(GetStateName());
	}
}

function SetCrestTooltipInfo(int PledgeID)
{
	local string PledgeName;
	local Texture PledgeCrestTexture;
	local CustomTooltip mCustomTooltip;
	local DrawItemInfo dTextureInfo;
	local int Index;
	local bool bCrestTexture;

	bCrestTexture = class'UIDATA_CLAN'.static.GetCrestTexture(PledgeID, PledgeCrestTexture);
	// End:0x3A
	if(bCrestTexture)
	{
		mCustomTooltip.DrawList.Length = 3;		
	}
	else
	{
		mCustomTooltip.DrawList.Length = 2;
	}
	mCustomTooltip.MinimumWidth = 200;
	mCustomTooltip.DrawList[0] = GetStateDrawItemInfo();
	Index = 1;
	// End:0x114
	if(bCrestTexture)
	{
		dTextureInfo.eType = DIT_TEXTURE;
		dTextureInfo.t_bDrawOneLine = true;
		dTextureInfo.bLineBreak = true;
		dTextureInfo.u_nTextureWidth = 16;
		dTextureInfo.u_nTextureHeight = 12;
		dTextureInfo.u_nTextureUWidth = 16;
		dTextureInfo.u_nTextureUHeight = 12;
		dTextureInfo.u_nTextureV = 4;
		dTextureInfo.u_strTexture = PledgeCrest_tex.GetTextureName();
		mCustomTooltip.DrawList[1] = dTextureInfo;
		Index = 2;
	}
	PledgeName = class'UIDATA_CLAN'.static.GetName(PledgeID);
	mCustomTooltip.DrawList[Index].bLineBreak = ! bCrestTexture;
	mCustomTooltip.DrawList[Index].nOffSetX = 2;
	mCustomTooltip.DrawList[Index].eType = DIT_TEXT;
	mCustomTooltip.DrawList[Index].t_bDrawOneLine = true;
	mCustomTooltip.DrawList[Index].t_color = class'L2Util'.static.Inst().Gold;
	mCustomTooltip.DrawList[Index].t_strText = PledgeName;
	Icon_ocptnFlag.SetTooltipCustomType(mCustomTooltip);
}

function DrawItemInfo GetStateDrawItemInfo()
{
	local DrawItemInfo dInfo;

	dInfo.eType = DIT_TEXT;
	dInfo.t_bDrawOneLine = true;
	dInfo.t_color = GetStateColor();
	dInfo.t_strText = GetStateString();
	return dInfo;
}

function SetTooltip()
{
	local CustomTooltip mCustomTooltip;

	mCustomTooltip.DrawList[0] = GetStateDrawItemInfo();
	Icon_ocptnFlag.SetTooltipCustomType(mCustomTooltip);
}

auto state stateDespawn
{
	function BeginState()
	{
		m_hOwnerWnd.SetAlpha(0, 0.50f);
		PledgeCrest_tex.HideWindow();
		Glow_ani.HideWindow();
	}

	function EndState()
	{
		m_hOwnerWnd.ShowWindow();
		m_hOwnerWnd.SetAlpha(255, 0.50f);
	}

}

state stateNotOccupied
{
	function BeginState()
	{
		SetTooltip();
	}

	function EndState()
	{
	}

}

state stateAttacked
{
	function BeginState()
	{
		SetTooltip();
		Glow_ani.ShowWindow();
		Glow_ani.Stop();
		Glow_ani.SetLoopCount(99999);
		Glow_ani.Play();
	}

	function EndState()
	{
		Glow_ani.HideWindow();
	}

}

state stateOccupied
{
	function BeginState()
	{
		SetPledgeID();
		Debug("stateOccupied BeginState" @ string(GetStateName()));
		m_hOwnerWnd.SetAlpha(150, 1.0f);
	}

	function EndState()
	{
		PledgeCrest_tex.HideWindow();
		Icon_ocptnFlag.SetAlpha(255, 1.0f);
	}

}

state stateOccupiedDespawn
{
	function BeginState()
	{
		Debug("stateOccupiedDespawn BeginState" @ string(GetStateName()));
		SetPledgeID();
		m_hOwnerWnd.SetTimer(0, 9999999);
		Icon_ocptnFlag.SetColorModify(class'L2Util'.static.Inst().Gray);
	}

	function EndState()
	{
		PledgeCrest_tex.HideWindow();
		m_hOwnerWnd.KillTimer(0);
		Icon_ocptnFlag.SetColorModify(class'L2Util'.static.Inst().BrightWhite);
	}
}

defaultproperties
{
}
