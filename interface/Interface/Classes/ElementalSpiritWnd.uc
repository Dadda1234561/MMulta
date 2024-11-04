/*------------------------------------------------------------------------------------------------------------------------

 ����     : ���� UI - SCALEFORM UI

 event ID : 
 npc 

 - ���� ���ɾ� - 

// ���� �ο�
//elemental_system_insert

// �� ���ɵ� ����ġ �ø���
//elemental_system_exp fire 1000000000
//elemental_system_exp water 1000000
//elemental_system_exp wind 1000000
//elemental_system_exp earth 1000000

//elemental_system_delete_elemental
  ���� ��� ���� ���� �� �ʱ�ȭ(�Ӽ� �ο����� ���� ���·� ���ư�)

//elemental_system_level [elemental_type] [grade] [level]
  ������ Ư�� ���޿� Ư�� ������ ����(ex)//elemental_system_level fire 2 8)
  type�� fire / water / wind / earth 4���� �Դϴ�.


- ���� npc: ������ 
�������� ȣ�� �ؼ� ���� ������ �ο� �޾Ƶ� �ȴ�.

- ���� ���߸� ��ġ
http://lineage2:8080/wiki/ElementalSystem#A.2Bvky03A_.2BuoW4OcW0-

------------------------------------------------------------------------------------------------------------------------*/
class ElementalSpiritWnd extends L2UIGFxScriptNoneContainer;

const SPIRIT_TYPE_FIRE = 0;
const SPIRIT_TYPE_WATER = 1;
const SPIRIT_TYPE_WIND = 2;
const SPIRIT_TYPE_EARTH = 3;
const SPIRITTYPECOUNTMAX = 4;

struct ElementalInfo
{
	var int SpiritType;
	var int NpcID;
	var int SpiritClassID;
	var int EvolLevel;
	var INT64 Exp;
	var INT64 NextExp;
	var int CurrLevel;
	var int RemainPoint;
};

var bool bUseSpirit;
var private array<ElementalInfo> elementalInfos;
            
event OnRegisterEvent()
{
	// ��� ���ɿ� ���� ���� 10860
	RegisterGFxEvent(EV_ElementalSpiritInfo); 

	// ���� ��ư Ŭ�� �� ��â 10870
	RegisterGFxEvent(EV_ElementalSpiritExtractInfo);

	// ���� �Ϸ� �� 10871
	RegisterGFxEvent(EV_ElementalSpiritExtract);

	// ��ȭ ��ư Ŭ�� �� ��ȭ���� ��â 10880
	RegisterGFxEvent(EV_ElementalSpiritEvolutionInfo);

	// ���� ��ȭ ���� ��ư Ŭ�� �� ���� 10890
	RegisterGFxEvent(EV_ElementalSpiritEvolution);

	// ������ Ư���� �����ϰų� �ʱ�ȭ�ؼ� �ɷ�ġ�� ���ŵ� �� 10900
	RegisterGFxEvent(EV_ElementalSpiritSetTalent);

	// ���� ��ư ������ ���� �̺�Ʈ 10910
	RegisterGFxEvent(EV_ElementalSpiritAbsorbInfo); 

	// ���� ������ ���� ������ �� �����κ��� ���� ���� �̺�Ʈ 10920
	RegisterGFxEvent(EV_ElementalSpiritAbsorb);

	// ����ġ�� ���� �Ǿ����� 
	RegisterGFxEvent(EV_ElementalSpiritGetExp);
	RegisterEvent(EV_ElementalSpiritSimpleInfo);
	RegisterEvent(EV_ElementalSpiritGetExp);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_ELEMENTAL_SPIRIT_ATTACK_TYPE);
}

event OnLoad()
{
	SetSaveWnd(true, false);

	SetClosingOnESC();
	AddState("GAMINGSTATE");

	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0,0);

	//SetContainerWindow(WINDOWTYPE_NONE, 0);		
	//SetContainerWindow(WINDOWTYPE_DECO_NORMAL, 7285);

	//SetClosingOnESC();

	//registerState("ElementalSpiritWnd", "GamingState");

	//SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0,0);
	///SetHavingFocus(false);
	elementalInfos.Length = SPIRITTYPECOUNTMAX;
	GetTextureSideElementalHandle(SPIRIT_TYPE_FIRE).HideWindow();
	GetTextureSideElementalHandle(SPIRIT_TYPE_WATER).HideWindow();
	GetTextureSideElementalHandle(SPIRIT_TYPE_WIND).HideWindow();
	GetTextureSideElementalHandle(SPIRIT_TYPE_EARTH).HideWindow();
}

event OnFlashLoaded()
{
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_ElementalSpirit);
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Container);
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Default);
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_GameData);
}

event OnShow()
{
	if(class'UIAPI_WINDOW'.static.IsShowWindow("CardDrawEventWnd"))
		class'UIAPI_WINDOW'.static.HideWindow("CardDrawEventWnd");

	if(class'UIAPI_WINDOW'.static.IsShowWindow("ItemUpgrade"))
		class'UIAPI_WINDOW'.static.HideWindow("ItemUpgrade");

	super.OnShow();

	L2Util(GetScript("L2Util")).ItemRelationWindowHide(getCurrentWindowName(string(self)));
	class'SideBar'.static.Inst().ToggleByWindowName(getCurrentWindowName(string(self)), true);
}

event OnHide()
{
	class'SideBar'.static.Inst().ToggleByWindowName(getCurrentWindowName(string(self)), false);
	super.OnHide();	
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		// End:0x48
		case EV_Restart:
			bUseSpirit = false;
			class'SideBar'.static.Inst().SetWindowShowHideByIndex(class'SideBar'.static.Inst().SIDEBAR_WINDOWS.TYPE_ELEMENT, false);
			// End:0xB1
			break;
		// End:0x5E
		case EV_ElementalSpiritSimpleInfo:
			HandleEV_ElementalSpiritSimpleInfo(a_Param);
			// End:0xB1
			break;
		// End:0x74
		case EV_ElementalSpiritGetExp:
			HandleEV_ElementalSpiritGetExp(a_Param);
			// End:0xB1
			break;
		// End:0x95
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_ELEMENTAL_SPIRIT_ATTACK_TYPE:
			RT_S_EX_ELEMENTAL_SPIRIT_ATTACK_TYPE();
			// End:0xB1
			break;
		// End:0xAE
		case EV_GameStart:
			bUseSpirit = false;
			ResetElementalSpirits();
			// End:0xB1
			break;
	}	
}

function _API_RequestElementalSpiritInfo(bool bIsOpen)
{
	local int nIsOpen;

	Debug("bUseSpirit" @ string(bUseSpirit));
	// End:0x35
	if(bUseSpirit == false)
	{
		AddSystemMessage(13827);
		return;
	}
	// End:0x45
	if(bIsOpen)
	{
		nIsOpen = 1;
	}
	RequestElementalSpiritInfo(nIsOpen);	
}

private function HandleEV_ElementalSpiritSimpleInfo(string a_Param)
{
	local int Result, Len, i, NpcID, SpiritClassID, SpiritType,
		spiritIndex;

	Debug("HandleSpriteInfo" @ a_Param);
	// End:0x49
	if((ParseInt(a_Param, "Result", Result)) && Result == 0)
	{
		return;
	}
	ParseInt(a_Param, "SpiritCount", Len);
	class'SideBar'.static.Inst().SetAlarmOnOff(class'SideBar'.static.Inst().SIDEBAR_WINDOWS.TYPE_ELEMENT, false);

	// End:0x28C [Loop If]
	for(i = 0; i < Len; i++)
	{
		// End:0xD6
		if(! ParseInt(a_Param, "NpcID_" $ string(i), NpcID))
		{
			// [Explicit Continue]
			continue;
		}
		bUseSpirit = true;
		ParseInt(a_Param, "SpiritClassID_" $ string(i), SpiritClassID);
		// End:0x122
		if((NpcID == 0) && SpiritClassID == 0)
		{
			// [Explicit Continue]
			continue;
		}
		ParseInt(a_Param, "SpiritType_" $ string(i), SpiritType);
		spiritIndex = SpiritType - 1;
		elementalInfos[spiritIndex].SpiritType = SpiritType;
		elementalInfos[spiritIndex].NpcID = NpcID;
		elementalInfos[spiritIndex].SpiritClassID = SpiritClassID;
		ParseInt(a_Param, "EvolLevel_" $ string(i), elementalInfos[spiritIndex].EvolLevel);
		ParseINT64(a_Param, "Exp_" $ string(i), elementalInfos[spiritIndex].Exp);
		ParseINT64(a_Param, "NextExp_" $ string(i), elementalInfos[spiritIndex].NextExp);
		ParseInt(a_Param, "CurrLevel_" $ string(i), elementalInfos[spiritIndex].CurrLevel);
		ParseInt(a_Param, "RemainPoint_" $ string(i), elementalInfos[spiritIndex].RemainPoint);
	}
	SetElementalExps();
	// End:0x2AC
	if(GetGameStateName() != "GAMINGSTATE")
	{
		return;
	}
	// End:0x318
	if(! bUseSpirit)
	{
		DetailStatusWndClassic(GetScript("DetailStatusWndClassic"))._LockElement();
		class'SideBar'.static.Inst().SetWindowShowHideByIndex(class'SideBar'.static.Inst().SIDEBAR_WINDOWS.TYPE_ELEMENT, false);		
	}
	else
	{
		DetailStatusWndClassic(GetScript("DetailStatusWndClassic"))._UnLockElement();
		class'SideBar'.static.Inst().SetWindowShowHideByIndex(class'SideBar'.static.Inst().SIDEBAR_WINDOWS.TYPE_ELEMENT, getInstanceUIData().getIsClassicServer());
	}

	// End:0x3F0 [Loop If]
	for(i = 0; i < elementalInfos.Length; i++)
	{
		// End:0x3E6
		if(elementalInfos[i].RemainPoint > 0)
		{
			class'SideBar'.static.Inst().SetAlarmOnOff(class'SideBar'.static.Inst().SIDEBAR_WINDOWS.TYPE_ELEMENT, true);
			// [Explicit Break]
			break;
		}
	}	
}

private function HandleEV_ElementalSpiritGetExp(string a_Param)
{
	local int Type;

	ParseInt(a_Param, "Type", Type);
	ParseINT64(a_Param, "Exp", elementalInfos[Type - 1].Exp);
	SetElementalExps();	
}

private function SetElementalExps()
{
	local INT64 ExpValue;
	local float per;
	local string nickname;
	local int CurrLevel, i;
	local DrawItemInfo Info, infoTexture;
	local CustomTooltip ToolTip;
	local bool isRemain;

	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;

	// End:0x326 [Loop If]
	for(i = 0; i < elementalInfos.Length; i++)
	{
		isRemain = elementalInfos[i].RemainPoint > 0;
		// End:0x8B
		if(isRemain)
		{
			infoTexture.u_strTexture = "L2UI_NewTex.SideBar.ElementalPoint_Plus";			
		}
		else
		{
			infoTexture.u_strTexture = "L2UI_NewTex.SideBar.ElementalPoint_Unable";
		}
		infoTexture.eType = DIT_TEXTURE;
		infoTexture.t_bDrawOneLine = true;
		infoTexture.u_nTextureWidth = 8;
		infoTexture.u_nTextureHeight = 8;
		infoTexture.nOffSetX = 0;
		infoTexture.nOffSetY = 3;
		infoTexture.u_nTextureUWidth = 8;
		infoTexture.u_nTextureUHeight = 8;
		infoTexture.bLineBreak = true;
		infoTexture.eAlignType = DIAT_LEFT;
		ToolTip.DrawList[ToolTip.DrawList.Length] = infoTexture;
		CurrLevel = elementalInfos[i].CurrLevel;
		nickname = class'UIDATA_NPC'.static.GetNPCNickName(elementalInfos[i].NpcID);
		Info.t_strText = GetSystemString(88) $ "." $ string(CurrLevel) @ nickname;
		Info.t_color = class'L2Util'.static.Inst().BrightWhite;
		Info.eAlignType = DIAT_LEFT;
		Info.nOffSetX = 5;
		Info.bLineBreak = false;
		ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
		GetElementalSpiritExpData(elementalInfos[i].SpiritType, elementalInfos[i].EvolLevel, elementalInfos[i].CurrLevel - 1, ExpValue);
		per = float(elementalInfos[i].Exp - ExpValue) / float(elementalInfos[i].NextExp - ExpValue);
		Info.t_strText = " " $ string(per * 100) $ "%";
		Info.t_color = class'L2Util'.static.Inst().Yellow;
		Info.bLineBreak = false;
		Info.eAlignType = DIAT_RIGHT;
		ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
	}
	class'SideBar'.static.Inst().GetWindowByIndex(class'SideBar'.static.Inst().SIDEBAR_WINDOWS.TYPE_ELEMENT).SetTooltipCustomType(ToolTip);	
}

private function RT_S_EX_ELEMENTAL_SPIRIT_ATTACK_TYPE()
{
	local UIPacket._S_EX_ELEMENTAL_SPIRIT_ATTACK_TYPE packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_ELEMENTAL_SPIRIT_ATTACK_TYPE(packet))
	{
		return;
	}
	CheckElementalActive(packet.cBitset);	
}

private function ResetElementalSpirits()
{
	local DetailStatusWndClassic script;

	script = DetailStatusWndClassic(GetScript("DetailStatusWndClassic"));
	script._ElementalDeActive(SPIRIT_TYPE_FIRE);
	script._ElementalDeActive(SPIRIT_TYPE_WATER);
	script._ElementalDeActive(SPIRIT_TYPE_WIND);
	script._ElementalDeActive(SPIRIT_TYPE_EARTH);	
}

private function CheckElementalActive(int bitSet)
{
	local int i, multiple;
	local DetailStatusWndClassic script;

	script = DetailStatusWndClassic(GetScript("DetailStatusWndClassic"));

	// End:0xC0 [Loop If]
	for(i = 0; i < 4; i++)
	{
		multiple = ExpInt(2, i);
		// End:0x8D
		if((bitSet & multiple) > 0)
		{
			GetTextureSideElementalHandle(i).ShowWindow();
			script._ElementalActive(i);
			// [Explicit Continue]
			continue;
		}
		GetTextureSideElementalHandle(i).HideWindow();
		script._ElementalDeActive(i);
	}	
}

private function TextureHandle GetTextureSideElementalHandle(int Index)
{
	switch(Index)
	{
		// End:0x3D
		case SPIRIT_TYPE_FIRE:
			return GetTextureHandle("SideBar.BtnElementalSpiritWnd.Icon_FireOn");
		// End:0x74
		case SPIRIT_TYPE_WATER:
			return GetTextureHandle("SideBar.BtnElementalSpiritWnd.Icon_WaterOn");
		// End:0xAB
		case SPIRIT_TYPE_WIND:
			return GetTextureHandle("SideBar.BtnElementalSpiritWnd.Icon_WindOn");
		// End:0xE3
		case SPIRIT_TYPE_EARTH:
			return GetTextureHandle("SideBar.BtnElementalSpiritWnd.Icon_EarthOn");
	}
	return GetTextureHandle("SideBar.BtnElementalSpiritWnd.Icon_EarthOn");
}

defaultproperties
{
}
