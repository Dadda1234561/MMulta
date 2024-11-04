class HennaMenuWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle HennaInfoOpen01_BTN;
var ButtonHandle HennaInfoOpen02_BTN;
var ButtonHandle HennaInfoOpen03_BTN;
var ButtonHandle HennaInfoOpen04_BTN;
var string m_WindowName;
var UIPacket._S_EX_NEW_HENNA_LIST henna_list_packet;
var int selectIndexSlot;

function OnRegisterEvent()
{
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_StateChanged);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_LIST);
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	HennaInfoOpen01_BTN = GetButtonHandle(m_WindowName $ ".HennaInfoOpen01_BTN");
	HennaInfoOpen02_BTN = GetButtonHandle(m_WindowName $ ".HennaInfoOpen02_BTN");
	HennaInfoOpen03_BTN = GetButtonHandle(m_WindowName $ ".HennaInfoOpen03_BTN");
	HennaInfoOpen04_BTN = GetButtonHandle(m_WindowName $ ".HennaInfoOpen04_BTN");
	initUI();
	HennaInfoOpen01_BTN.SetTooltipType("text");
	HennaInfoOpen02_BTN.SetTooltipType("text");
	HennaInfoOpen03_BTN.SetTooltipType("text");
	HennaInfoOpen04_BTN.SetTooltipType("text");
}

function initUI()
{
	local int i;

	// End:0x246 [Loop If]
	for(i = 1; i <= 4; i++)
	{
		GetTextureHandle(m_WindowName $ ".HennaSlot0" $ string(i) $ "_wnd.HannaMark_tex").HideWindow();
		GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i) $ "_wnd.HennaTitle_txt").SetText("");
		GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i) $ "_wnd.HennaLV_txt").SetText("");
		GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i) $ "_wnd.HennaStat_txt").SetText("");
		GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i) $ "_wnd.HennaPotential_txt").SetText("");
		GetTextureHandle(m_WindowName $ ".HennaSlot0" $ string(i) $ "_wnd.HannaMark_tex").HideWindow();
		GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i) $ "_wnd.EmptyMark_txt").SetText("");
		GetWindowHandle(m_WindowName $ ".HennaSlot0" $ string(i) $ "_wnd.EmptyMarkShowWnd").HideWindow();
		GetButtonHandle(m_WindowName $ ".HennaSlot0" $ string(i) $ "_wnd.HennaEnchant_Btn").SetTooltipType("text");
		GetButtonHandle(m_WindowName $ ".HennaSlot0" $ string(i) $ "_wnd.HennaEnchant_Btn").SetTooltipCustomType(MakeTooltipSimpleColorText(MakeFullSystemMsg(GetSystemMessage(13751), string(i)), GTColor().BrightWhite, "hs13"));
	}
}

function OnShow()
{
	// End:0x45
	if(GetWindowHandle("HennaEnchantWnd").IsShowWindow())
	{
		GetWindowHandle("HennaEnchantWnd").HideWindow();
	}
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	API_C_EX_NEW_HENNA_LIST();
}

function OnHide()
{}

function OnClickButton(string Name)
{
	Debug("Name" @ Name);
	// End:0x3F
	if(Name == "HennaClose_BTN")
	{
		Me.HideWindow();		
	}
	else
	{
		// End:0x66
		if(Name == "HennaSynthetic_BTN")
		{
			ShowMennaMenuWnd();			
		}
		else
		{
			// End:0x91
			if(Name == "HelpWnd_Btn")
			{
				//class'HelpWnd'.static.ShowHelp(69);				
			}
			else
			{
				OnClickEnchant(Name);
			}
		}
	}
}

function ShowMennaMenuWnd()
{
	local Rect rectWnd;

	rectWnd = GetWindowHandle("HennaDyeEnchantWnd").GetRect();
	getInstanceL2Util().syncWindowLoc(m_hOwnerWnd.m_WindowNameWithFullPath, "HennaDyeEnchantWnd", (m_hOwnerWnd.GetRect().nWidth - rectWnd.nWidth) / 2, (m_hOwnerWnd.GetRect().nHeight - rectWnd.nHeight) / 2);
	ShowWindowWithFocus("HennaDyeEnchantWnd");
	Me.HideWindow();
}

function OnClickEnchant(string Name)
{
	local int Index;

	// End:0x5E
	if(Left(Name, 14) == "HennaInfoOpen0")
	{
		Index = int(Mid(Name, 14, 1));
		Debug("OnClickEnchant:" @ string(Index));
		requestEquipUnEquip(Index - 1);
	}
}

function requestEquipUnEquip(int i)
{
	selectIndexSlot = i;
	// End:0x44
	if(henna_list_packet.hennaInfoList[i].cActive <= 0)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13455));		
	}
	else
	{
		// End:0xBD
		if(henna_list_packet.hennaInfoList[i].nHennaID > 0)
		{
			RequestHennaUnEquipInfo(henna_list_packet.hennaInfoList[i].nHennaID);
			Debug("Api --> RequestHennaUnEquipInfo" @ string(henna_list_packet.hennaInfoList[i].nHennaID));			
		}
		else
		{
			RequestHennaItemList();
			Debug("Api --> RequestHennaItemList");
		}
		Me.HideWindow();
	}
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	local int Index;

	// End:0x137
	if(a_WindowHandle.GetWindowName() == "HennaEnchant_Btn")
	{
		// End:0x137
		if(Left(a_WindowHandle.GetParentWindowName(), 10) == "HennaSlot0")
		{
			Index = int(Mid(a_WindowHandle.GetParentWindowName(), 10, 1));
			// End:0x10F
			if(henna_list_packet.hennaInfoList[Index - 1].cActive > 0)
			{
				getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "HennaEnchantWnd");
				Me.HideWindow();
				toggleWindow("HennaEnchantWnd", true);
				HennaEnchantWnd(GetScript("HennaEnchantWnd")).groupButtons._setTopOrder(Index - 1);				
			}
			else
			{
				AddSystemMessage(13594);
			}
		}
	}
}

function OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		// End:0x28
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_NEW_HENNA_LIST:
			ParsePacket_S_EX_NEW_HENNA_LIST();
			// End:0x6A
			break;
		// End:0x36
		case EV_Restart:
			initUI();
			// End:0x6A
			break;
		// End:0x67
		case EV_StateChanged:
			// End:0x64
			if(param != "GAMINGSTATE")
			{
				m_hOwnerWnd.HideWindow();
			}
			// End:0x6A
			break;
	}
}

function ParsePacket_S_EX_NEW_HENNA_LIST()
{
	local DyePotentialUIData dyePotentialData;
	local int i, dyeItemClassID, dyeItemlevel;
	local ItemInfo dyeItemInfo;
	local string dyeItemName, cutStr, ItemNameS;
	local SkillInfo SkillInfo;
	local string emblemTex;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_NEW_HENNA_LIST(henna_list_packet))
	{
		return;
	}
	// End:0x31
	if(! Me.IsShowWindow())
	{
		return;
	}
	Debug(" -->  Decode_S_EX_NEW_HENNA_LIST :  " @ string(henna_list_packet.hennaInfoList.Length));
	Debug("packet.nDailyStep " @ string(henna_list_packet.nDailyStep));
	Debug("packet.nDailyCount " @ string(henna_list_packet.nDailyCount));

	// End:0xEDE [Loop If]
	for(i = 0; i < henna_list_packet.hennaInfoList.Length; i++)
	{
		Debug(("--------------------------------" @ string(i)) @ "--------------------------------------");
		Debug("packet.nHennaID " @ string(henna_list_packet.hennaInfoList[i].nHennaID));
		Debug("packet.nPotenID " @ string(henna_list_packet.hennaInfoList[i].nPotenID));
		Debug("packet.cActive " @ string(henna_list_packet.hennaInfoList[i].cActive));
		Debug("packet.nEnchantStep " @ string(henna_list_packet.hennaInfoList[i].nEnchantStep));
		Debug("packet.nEnchantExp " @ string(henna_list_packet.hennaInfoList[i].nEnchantExp));
		Debug("packet.nActiveStep " @ string(henna_list_packet.hennaInfoList[i].nActiveStep));
		Debug("packet.nDailyStep " @ string(henna_list_packet.hennaInfoList[i].nDailyStep));
		Debug("packet.nDailyCount " @ string(henna_list_packet.hennaInfoList[i].nDailyCount));
		setCircleBarRefresh(i, GetStatusRoundHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.LV_StatusRound"), GetStatusRoundHandle(((m_WindowName $ ".HennaSlot0") $ string(i + 1)) $ "_wnd.Enchant_StatusRound"), GetStatusRoundHandle(((m_WindowName $ ".HennaSlot0") $ string(i + 1)) $ "_wnd.EnchantApply_StatusRound"));
		// End:0xBAE
		if(henna_list_packet.hennaInfoList[i].cActive > 0)
		{
			GetWindowHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.EmptyMarkShowWnd").HideWindow();
			// End:0x937
			if(henna_list_packet.hennaInfoList[i].nHennaID > 0)
			{
				emblemTex = class'UIDATA_HENNA'.static.GetHennaEmblemTex(henna_list_packet.hennaInfoList[i].nHennaID);
				GetTextureHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HannaMark_tex").ShowWindow();
				GetTextureHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HannaMark_tex").SetTexture(emblemTex);
				class'UIDATA_HENNA'.static.GetHennaDyeItemClassID(henna_list_packet.hennaInfoList[i].nHennaID, dyeItemClassID);
				dyeItemInfo = GetItemInfoByClassID(dyeItemClassID);
				class'UIDATA_HENNA'.static.GetHennaDyeItemLevel(henna_list_packet.hennaInfoList[i].nHennaID, dyeItemlevel);
				ItemNameS = class'UIDATA_HENNA'.static.GetItemNameS(henna_list_packet.hennaInfoList[i].nHennaID);
				Debug("---> dyeItemName: " @ ItemNameS);
				dyeItemName = Left(ItemNameS, InStr(ItemNameS, "<"));
				cutStr = Mid(ItemNameS, InStr(ItemNameS, "<"), Len(ItemNameS));
				GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaTitle_txt").SetText(dyeItemName);
				GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaLV_txt").SetText(MakeFullSystemMsg(GetSystemMessage(5203), string(dyeItemlevel)));
				GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaStat_txt").SetText(cutStr);
				textBoxShortStringWithTooltip(GetTextBoxHandle(((m_WindowName $ ".HennaSlot0") $ string(i + 1)) $ "_wnd.HennaStat_txt"), true);
				GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.EmptyMark_txt").SetText("");
				// End:0x86A
				if(henna_list_packet.hennaInfoList[i].nPotenID > 0)
				{
					class'UIDATA_HENNA'.static.GetDyePotentialData(henna_list_packet.hennaInfoList[i].nPotenID, dyePotentialData);
					GetSkillInfo(dyePotentialData.SkillID, henna_list_packet.hennaInfoList[i].nActiveStep, 0, SkillInfo);
					// End:0x7D0
					if(henna_list_packet.hennaInfoList[i].nActiveStep > 0)
					{
						GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaPotential_txt").SetText(((dyePotentialData.EffectName @ SkillInfo.SkillDesc) $ "\\n") $ GetSystemString(3351));						
					}
					else
					{
						GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaPotential_txt").SetText(dyePotentialData.EffectName @ "+0");
					}
					GetButtonHandle(m_WindowName $ ".HennaInfoOpen0" $ string(i + 1) $ "_BTN").ClearTooltip();					
				}
				else
				{
					GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaPotential_txt").SetText("");
				}
				GetButtonHandle(m_WindowName $ ".HennaInfoOpen0" $ string(i + 1) $ "_BTN").SetButtonName(3969);
				GetButtonHandle(m_WindowName $ ".HennaInfoOpen0" $ string(i + 1) $ "_BTN").EnableWindow();				
			}
			else
			{
				GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaTitle_txt").SetText("");
				GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaLV_txt").SetText("");
				GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaStat_txt").SetText("");
				GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaPotential_txt").SetText("");
				GetTextureHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HannaMark_tex").HideWindow();
				GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.EmptyMark_txt").SetText(GetSystemString(2496));
				GetButtonHandle(m_WindowName $ ".HennaInfoOpen0" $ string(i + 1) $ "_BTN").SetButtonName(3968);
				GetButtonHandle(m_WindowName $ ".HennaInfoOpen0" $ string(i + 1) $ "_BTN").EnableWindow();
			}
			GetButtonHandle(((m_WindowName $ ".HennaInfoOpen0") $ string(i + 1)) $ "_BTN").ClearTooltip();
			// [Explicit Continue]
			continue;
		}
		GetTextureHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HannaMark_tex").HideWindow();
		GetWindowHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.EmptyMarkShowWnd").ShowWindow();
		GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.EmptyMark_txt").SetText(GetSystemString(13195));
		GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaTitle_txt").SetText("");
		GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaStat_txt").SetText("");
		GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaStat_txt").ClearTooltip();
		GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaLV_txt").SetText("");
		GetTextBoxHandle(m_WindowName $ ".HennaSlot0" $ string(i + 1) $ "_wnd.HennaPotential_txt").SetText("");
		GetButtonHandle(m_WindowName $ ".HennaInfoOpen0" $ string(i + 1) $ "_BTN").ClearTooltip();
		GetButtonHandle(m_WindowName $ ".HennaInfoOpen0" $ string(i + 1) $ "_BTN").SetButtonName(3587);
		GetSkillInfo(45269, 1, 0, SkillInfo);
		GetButtonHandle(m_WindowName $ ".HennaInfoOpen0" $ string(i + 1) $ "_BTN").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13923)));
	}
}

function setCircleBarRefresh(int i, StatusRoundHandle LV_StatusRound, StatusRoundHandle Enchant_StatusRound, StatusRoundHandle EnchantApply_StatusRound)
{
	local int dyeItemlevel, slotExp, currentSlotExp;

	class'UIDATA_HENNA'.static.GetHennaDyeItemLevel(henna_list_packet.hennaInfoList[i].nHennaID, dyeItemlevel);
	slotExp = getDyePotentialAccrueExp(dyeItemlevel);
	currentSlotExp = getDyePotentialAccrueExp(henna_list_packet.hennaInfoList[i].nEnchantStep - 1) + henna_list_packet.hennaInfoList[i].nEnchantExp;
	LV_StatusRound.SetPoint(slotExp, getDyePotentialTotalExp());
	// End:0xC3
	if(currentSlotExp > slotExp)
	{
		EnchantApply_StatusRound.SetPoint(slotExp, getDyePotentialTotalExp());		
	}
	else
	{
		EnchantApply_StatusRound.SetPoint(currentSlotExp, getDyePotentialTotalExp());
	}
	Enchant_StatusRound.SetPoint(currentSlotExp, getDyePotentialTotalExp());
}

function int getDyePotentialAccrueExp(int nPotentialExpStep)
{
	local array<DyePotentialExpUIData> dyePotentialExpArray;
	local int i, sumExp;

	class'UIDATA_HENNA'.static.GetDyePotentialExpDataList(dyePotentialExpArray);

	// End:0x6C [Loop If]
	for(i = 0; i < dyePotentialExpArray.Length; i++)
	{
		// End:0x62
		if(dyePotentialExpArray[i].DyePotentialLevel <= nPotentialExpStep)
		{
			sumExp = dyePotentialExpArray[i].Exp + sumExp;
		}
	}
	return sumExp;
}

function DyePotentialExpUIData getDyePotentialExp(int nPotentialExpStep)
{
	local array<DyePotentialExpUIData> dyePotentialExpArray;
	local int i;

	class'UIDATA_HENNA'.static.GetDyePotentialExpDataList(dyePotentialExpArray);

	// End:0x5B [Loop If]
	for(i = 0; i < dyePotentialExpArray.Length; i++)
	{
		// End:0x51
		if(dyePotentialExpArray[i].DyePotentialLevel == nPotentialExpStep)
		{
			return dyePotentialExpArray[i];
		}
	}
	return dyePotentialExpArray[nPotentialExpStep];
}

function int getDyePotentialTotalExp()
{
	local array<DyePotentialExpUIData> dyePotentialExpArray;
	local int totalExp, i;

	class'UIDATA_HENNA'.static.GetDyePotentialExpDataList(dyePotentialExpArray);

	// End:0x52 [Loop If]
	for(i = 0; i < dyePotentialExpArray.Length; i++)
	{
		totalExp = totalExp + dyePotentialExpArray[i].Exp;
	}
	return totalExp;
}

function int getDyePotentialLastLevel()
{
	local array<DyePotentialExpUIData> dyePotentialExpArray;

	class'UIDATA_HENNA'.static.GetDyePotentialExpDataList(dyePotentialExpArray);
	return dyePotentialExpArray[dyePotentialExpArray.Length - 1].DyePotentialLevel;
}

function int getSelectIndexSlot()
{
	return selectIndexSlot + 1;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	local int Index;

	// End:0x72
	if(a_WindowHandle.GetWindowName() == "HennaEnchant_Btn")
	{
		// End:0x72
		if(Left(a_WindowHandle.GetParentWindowName(), 10) == "HennaSlot0")
		{
			Index = int(Mid(a_WindowHandle.GetParentWindowName(), 10, 1));
			playButtonEffect(Index, false);
		}
	}
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	local int Index;

	// End:0x72
	if(a_WindowHandle.GetWindowName() == "HennaEnchant_Btn")
	{
		// End:0x72
		if(Left(a_WindowHandle.GetParentWindowName(), 10) == "HennaSlot0")
		{
			Index = int(Mid(a_WindowHandle.GetParentWindowName(), 10, 1));
			playButtonEffect(Index, true);
		}
	}
}

function playButtonEffect(int Index, bool bOnEffect)
{
	// End:0x81
	if(bOnEffect)
	{
		GetEffectViewportWndHandle(m_WindowName $ ".HennaSlot0" $ string(Index) $ "_wnd.HennaEnchant_EffectViewportOver").SpawnEffect("LineageEffect2.ui_yellow_smoke");		
	}
	else
	{
		GetEffectViewportWndHandle(m_WindowName $ ".HennaSlot0" $ string(Index) $ "_wnd.HennaEnchant_EffectViewportOver").SpawnEffect("");
	}
}

function API_C_EX_NEW_HENNA_LIST()
{
	local array<byte> stream;

	Debug("API Call -------------- _C_EX_NEW_HENNA_LIST ---------------");
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_NEW_HENNA_LIST, stream);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
