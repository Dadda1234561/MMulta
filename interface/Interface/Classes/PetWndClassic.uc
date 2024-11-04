//================================================================================
// PetWndClassic.
//================================================================================

class PetWndClassic extends UICommonAPI;

var WindowHandle Me;
var WindowHandle PetClassicInfoWnd;
var TextBoxHandle txtName_Title;
var TextBoxHandle txtLvName;
var TextBoxHandle txtrandomStatName;
var TextBoxHandle txtrandomName;
var TextBoxHandle txtNamerandom_Title;
var TextBoxHandle txtFatigue;
var TextBoxHandle txtPetExp;
var TextBoxHandle txtPetMP;
var TextBoxHandle txtPetHP;
var ButtonHandle Evolve_BTN;
var StatusBarHandle texPetHP;
var StatusBarHandle texPetMP;
var StatusBarHandle texPetExp;
var StatusBarHandle texPetFatigue;
var TextureHandle texFatigueIcon;
var WindowHandle PetWnd_Status;
var TextureHandle BackTex1;
var TextureHandle BackTex2;
var TextureHandle DividerLine;
var TextureHandle DividerLine2;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtMagicHit;
var TextBoxHandle txtMagicAvoid;
var TextBoxHandle txtMagicCritical;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtSoulShotCosume;
var TextBoxHandle txtSpiritShotConsume;
var ItemWindowHandle PetActionWnd;
var WindowHandle PetWnd_Inventory;
var ItemWindowHandle PetEquipItem_Head;
var ItemWindowHandle PetEquipItem_Chest;
var ItemWindowHandle PetEquipItem_Legs;
var ItemWindowHandle PetEquipItem_RHand;
var ItemWindowHandle PetEquipItem_Gloves;
var ItemWindowHandle PetEquipItem_Feet;
var ItemWindowHandle PetEquipItem_LFinger;
var ItemWindowHandle PetEquipItem_RFinger;
var ItemWindowHandle PetEquipItem_LEar;
var ItemWindowHandle PetEquipItem_REar;
var ItemWindowHandle PetEquipItem_Neck;
var ItemWindowHandle PetEquipItem_Underwear;
var TabHandle TabCtrl;
var string m_WindowName;
var int m_PetID;
var bool m_bShowNameBtn;
var string m_LastInputPetName;
var int EvolutionizedAction;
var int nEvolvePetID;
var int nPetLevel;
var int nEvolutionStep;
var InventoryWnd inventoryWndScript;
var WindowHandle PetAction_Window;
var WindowHandle PetActive_Window;
var WindowHandle PetPassive_Window;
const PET_EVOLUTIONIZED_ID= 1210114602;
const NPET_BARHEIGHT= 12;
const NPET_LARGEBARSIZE= 206;
const NPET_SMALLBARSIZE= 85;
const DIALOG_EVOLVE= 1113;
const PET_EQUIPPEDTEXTURE_NAME= "l2ui_ch3.PetWnd.petitem_click";

function OnRegisterEvent ()
{
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(250);
	RegisterEvent(1010);
	RegisterEvent(1020);
	RegisterEvent(1030);
	RegisterEvent(1130);
	RegisterEvent(1311);
	RegisterEvent(1320);
	RegisterEvent(1330);
	RegisterEvent(11480);
	RegisterEvent(1060);
	RegisterEvent(1070);
	RegisterEvent(1080);
	RegisterEvent(1900);
	RegisterEvent(190);
	RegisterEvent(210);
	RegisterEvent(11481);
	RegisterEvent(9750);
}

function OnLoad ()
{
	SetClosingOnESC();
	Initialize();
	m_bShowNameBtn = True;
	EvolutionizedAction = 0;
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
}

function Initialize ()
{
	Me = GetWindowHandle("PetWndClassic");
	PetClassicInfoWnd = GetWindowHandle("PetWndClassic.PetClassicInfoWnd");
	txtName_Title = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtName_Title");
	txtLvName = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtLvName");
	txtrandomStatName = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtRandomStatName");
	txtrandomName = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtRandomName");
	txtNamerandom_Title = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtNamerandom_Title");
	txtrandomName = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtrandomName");
	txtrandomStatName = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtrandomStatName");
	txtFatigue = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtFatigue");
	txtPetExp = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtPetExp");
	txtPetMP = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtPetMP");
	txtPetHP = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtPetHP");
	Evolve_BTN = GetButtonHandle("PetWndClassic.PetClassicInfoWnd.Evolve_BTN");
	texPetHP = GetStatusBarHandle("PetWndClassic.PetClassicInfoWnd.texPetHP");
	texPetMP = GetStatusBarHandle("PetWndClassic.PetClassicInfoWnd.texPetMP");
	texPetExp = GetStatusBarHandle("PetWndClassic.PetClassicInfoWnd.texPetExp");
	texPetFatigue = GetStatusBarHandle("PetWndClassic.PetClassicInfoWnd.texPetFatigue");
	texFatigueIcon = GetTextureHandle("PetWndClassic.PetClassicInfoWnd.texFatigueIcon");
	PetWnd_Status = GetWindowHandle("PetWndClassic.PetWnd_Status");
	txtPhysicalAttack = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtPhysicalAttack");
	txtPhysicalDefense = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtPhysicalDefense");
	txtHitRate = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtHitRate");
	txtPhysicalAvoid = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtPhysicalAvoid");
	txtCriticalRate = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtCriticalRate");
	txtPhysicalAttackSpeed = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtPhysicalAttackSpeed");
	txtMovingSpeed = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtMovingSpeed");
	txtMagicalAttack = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtMagicalAttack");
	txtMagicDefense = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtMagicDefense");
	txtMagicHit = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtMagicHit");
	txtMagicAvoid = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtMagicAvoid");
	txtMagicCritical = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtMagicCritical");
	txtMagicCastingSpeed = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtMagicCastingSpeed");
	txtSoulShotCosume = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtSoulShotCosume");
	txtSpiritShotConsume = GetTextBoxHandle("PetWndClassic.PetWnd_Status.txtSpiritShotConsume");
	PetAction_Window = GetWindowHandle("PetWndClassic.PetWnd_Action.PetWnd_Action");
	PetActive_Window = GetWindowHandle("PetWndClassic.PetWnd_Action.PetActive_Window");
	PetPassive_Window = GetWindowHandle("PetWndClassic.PetWnd_Action.PetPassive_Window");
	PetActionWnd = GetItemWindowHandle("PetWndClassic.PetAction_Window.PetWnd_Action.PetActionWnd");
	PetWnd_Inventory = GetWindowHandle("PetWndClassic.PetWnd_Inventory");
	PetEquipItem_Head = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Head");
	PetEquipItem_Chest = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Chest");
	PetEquipItem_Legs = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Legs");
	PetEquipItem_RHand = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_RHand");
	PetEquipItem_Gloves = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Gloves");
	PetEquipItem_Feet = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Feet");
	PetEquipItem_LFinger = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_LFinger");
	PetEquipItem_RFinger = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_RFinger");
	PetEquipItem_LEar = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_LEar");
	PetEquipItem_REar = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_REar");
	PetEquipItem_Neck = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Neck");
	PetEquipItem_Underwear = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Underwear");
	TabCtrl = GetTabHandle("PetWndClassic.TabCtrl");
	PetEquipItem_Head.SetTooltipText(GetSystemString(230));
	PetEquipItem_Chest.SetTooltipText(GetSystemString(38));
	PetEquipItem_Legs.SetTooltipText(GetSystemString(39));
	PetEquipItem_RHand.SetTooltipText(GetSystemString(2520));
	PetEquipItem_Gloves.SetTooltipText(GetSystemString(37));
	PetEquipItem_Feet.SetTooltipText(GetSystemString(40));
	PetEquipItem_LFinger.SetTooltipText(GetSystemString(239));
	PetEquipItem_RFinger.SetTooltipText(GetSystemString(239));
	PetEquipItem_LEar.SetTooltipText(GetSystemString(237));
	PetEquipItem_REar.SetTooltipText(GetSystemString(237));
	PetEquipItem_Neck.SetTooltipText(GetSystemString(238));
	PetEquipItem_Underwear.SetTooltipText(GetSystemString(3362));
	PetActionWnd.SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	texPetExp.SetDecimalPlace(4);
	GetAnimTextureHandle("PetWndClassic.PetClassicInfoWnd.SkillLearn_BTN_AnimTex").HideWindow();
	// End:0xE4E
	if(IsAdenServer())
	{
		GetMeTextBox("PetWnd_Status.txtHeadSoulShot").SetText(GetSystemString(14271));
		GetMeTextBox("PetWnd_Status.txtHeadSoulShotCosume1").SetText(GetSystemString(14272));
		GetMeTextBox("PetWnd_Status.txtHeadSoulShotCosume2").SetText(GetSystemString(14273));		
	}
	else
	{
		GetMeTextBox("PetWnd_Status.txtHeadSoulShot").SetText(GetSystemString(13394));
		GetMeTextBox("PetWnd_Status.txtHeadSoulShotCosume1").SetText(GetSystemString(13395));
		GetMeTextBox("PetWnd_Status.txtHeadSoulShotCosume2").SetText(GetSystemString(13396));
	}
}

function OnShow ()
{
	Class'PetAPI'.static.RequestPetInventoryItemList();
	Class'ActionAPI'.static.RequestPetActionList();
	Class'UIAPI_WINDOW'.static.HideWindow("RefineryWnd");
	Class'UIAPI_WINDOW'.static.HideWindow("PetSkillLearnWnd");
}

function OnDropItemSource (string strTarget, ItemInfo Info)
{
	if ( strTarget != "Console" )
	{
		return;
	}
	API_C_EX_PET_UNEQUIP_ITEM(Info.Id.ServerID);
}

function OnDropItem (string strTarget, ItemInfo Info, int X, int Y)
{
	local InventoryWnd script;

	script = InventoryWnd(GetScript("InventoryWnd"));
	if ( ((strTarget == "PetWnd_Inventory") || (strTarget == "PetEquipItem_Head") || (strTarget == "PetEquipItem_Chest") || (strTarget == "PetEquipItem_Legs") || (strTarget == "PetEquipItem_RHand") || (strTarget == "PetEquipItem_Gloves") || (strTarget == "PetEquipItem_Feet") || (strTarget == "PetEquipItem_LFinger") || (strTarget == "PetEquipItem_RFinger") || (strTarget == "PetEquipItem_LEar") || (strTarget == "PetEquipItem_REar") || (strTarget == "PetEquipItem_Neck") || (strTarget == "PetEquipItem_Pet") || (strTarget == "PetEquipItem_Underwear")) && (script.getInventoryItemWndName(Info.DragSrcName) == True) )
	{
		API_C_EX_PET_EQUIP_ITEM(Info.Id.ServerID);
	}
}

function HandleLanguageChanged ()
{
	Class'ActionAPI'.static.RequestPetActionList();
}

function OnHide ()
{
	if ( DialogIsMine() )
	{
		DialogHide();
	}
}

function OnEvent (int Event_ID, string param)
{
	if ( !IsAdenServer() )
	{
		return;
	}
	if ( Event_ID == 250 )
	{
		HandlePetInfoUpdate();
	} else if ( Event_ID == 190 )
	{
		UpdatePetHP(param);
	} else if ( Event_ID == 210 )
	{
		UpdatePetMP(param);
	} else if ( Event_ID == 1130 )
	{
		HandlePetStatusClose();
	} else if ( Event_ID == 1010 )
	{
		HandlePetInfoUpdate();
		HandlePetShow();
	} else if ( Event_ID == 1710 )
	{
		HandleDialogOK();
	} else if ( Event_ID == 1320 )
	{
		HandleActionPetListStart();
	} else if ( Event_ID == 1330 )
	{
		HandleActionPetList(param);
	} else if ( Event_ID == 11480 )
	{
		clearSkillPassiveWnd();
		HandlePetSkillList(param);
	} else if ( Event_ID == 1060 )
	{
		HandlePetInventoryItemStart();
	} else if ( Event_ID == 1070 )
	{
		HandlePetInventoryItemList(param);
	} else if ( Event_ID == 1080 )
	{
		HandlePetInventoryItemUpdate(param);
	} else if ( Event_ID == 1900 )
	{
		HandleLanguageChanged();
	} else if ( Event_ID == 1311 )
	{
		Class'ActionAPI'.static.RequestPetActionList();
	} else if ( Event_ID == 11481 )
	{
		AnimTexturePlay(GetAnimTextureHandle("PetWndClassic.PetClassicInfoWnd.SkillLearn_BTN_AnimTex"),True,9999999);
	} else if ( Event_ID == 9750 )
	{
		GetAnimTextureHandle("PetWndClassic.PetClassicInfoWnd.SkillLearn_BTN_AnimTex").HideWindow();
	}
}

function OnMouseOver (WindowHandle W)
{
	if ( W.GetWindowName() == "SkillLearn_BTN" )
	{
		GetAnimTextureHandle("PetWndClassic.PetClassicInfoWnd.SkillLearn_BTN_AnimTex").HideWindow();
	}
}

function HandleDialogOK ()
{
	local int Id;

	if ( DialogIsMine() )
	{
		Id = DialogGetID();
		if ( Id == DIALOG_EVOLVE )
		{
			if ( hasEnoughItem(DialogGetReservedInt(),DialogGetReservedInt2()) )
			{
				API_C_EX_EVOLVE_PET();
			} else {
				AddSystemMessage(13094);
			}
		}
	}
}

function OnClickButton (string strID)
{
	switch (strID)
	{
		case "Evolve_BTN":
		OnEvolve_BTNClick();
		break;
		case "SkillLearn_BTN":
		toggleWindow("PetSkillLearnWnd");
		break;
		case "WindowHelp_BTN":
		ExecuteEvent(EV_ShowHelp,"53");
		break;
	}
}

function OnEvolve_BTNClick ()
{
	tryEvolveDialog();
}

function tryEvolveDialog ()
{
	local array<EvolveCondition> EvolveConditionArr;
	local array<RequestItem> RequestItemArr;
	local int i;
	local string ItemName;
	local string itemNumStr;

	Class'PetAPI'.static.GetPetEvolveCondition(nEvolvePetID,nEvolutionStep + 1,EvolveConditionArr,RequestItemArr);
	
	for ( i = 0;i < RequestItemArr.Length;i++ )
	{
		Debug("id " @ string(RequestItemArr[i].Id));
		Debug("amount" @ string(RequestItemArr[i].Amount));
		ItemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(RequestItemArr[i].Id));
		itemNumStr = MakeCostStringINT64(RequestItemArr[i].Amount);
		DialogSetString(ItemName);
		DialogSetReservedInt(RequestItemArr[i].Id);
		DialogSetReservedInt2(RequestItemArr[i].Amount);
	}
	DialogSetID(1113);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(13253), (ItemName $ " x") $ itemNumStr), string(self));
}

function OnClickItem (string strID, int Index)
{
	local ItemInfo infItem;

	if ( (strID == "PetActionWnd") && (Index > -1) )
	{
		PetActionWnd.GetItem(Index,infItem);
		DoAction(infItem.Id);
	} else {
		if ( ((strID == "PetActiveActionWnd_1") || (strID == "PetActiveActionWnd_2") || (strID == "PetActiveActionWnd_3") || (strID == "PetActiveActionWnd_4") || strID == ("PetActiveActionWnd_5") || (strID == "PetActiveActionWnd_5") || (strID == "PetActiveActionWnd_6") || (strID == "PetActiveActionWnd_7") || (strID == "PetActiveActionWnd_8") || (strID == "PetActiveActionWnd_9")) && (Index > -1) )
		{
			if ( getPetActiveActionWnd(int(Right(strID,1))).GetItem(Index,infItem) )
			{
				if ( infItem.bDisabled <= 0 )
				{
					UseSkill(infItem.Id,infItem.ShortcutType);
					Debug("-- UseSkill " @ string(infItem.Id.ClassID));
				}
			}
		}
	}
}

function clearSkillPassiveWnd ()
{
	local int i;

	
	for ( i = 1; i <= 6; i++ )
	{
		getPetPassiveWnd(i).Clear();
	}

	// End:0x64 [Loop If]
	for(i = 1; i <= 9; i++)
	{
		getPetActiveActionWnd(i).Clear();
	}
}

function ItemWindowHandle getPetActiveActionWnd (int Index)
{
	switch (Index)
	{
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		// End:0x24
		case 6:
		// End:0x29
		case 7:
		// End:0x2E
		case 8:
		// End:0x85
		case 9:
			return GetItemWindowHandle("PetWndClassic.PetWnd_Action.PetAction_Window.PetActiveActionWnd_" $ string(Index));
	}
	return None;
}

function addActiveSkill (ItemInfo Info)
{
	local int i;

	for (i = 1; i <= 9;i++ )
	{
		if ( getPetActiveActionWnd(i).GetItemNum() <= 0 )
		{
			getPetActiveActionWnd(i).Clear();
			getPetActiveActionWnd(i).AddItem(Info);
			break;
		}
	}
}

function ItemWindowHandle getPetPassiveWnd (int Index)
{
	switch (Index)
	{
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		// End:0x78
		case 6:
			return GetItemWindowHandle("PetWndClassic.PetWnd_Action.PetPassive_Window.PetPassiveActionWnd_" $ string(Index));
	}
	return None;
}

function addPassiveSkill (ItemInfo Info)
{
	local int i;

	
	for ( i = 1;i <= 6;i++ )
	{
		if(getPetPassiveWnd(i).GetItemNum() <= 0)
		{
			getPetPassiveWnd(i).Clear();
			getPetPassiveWnd(i).AddItem(Info);
			Debug("info.IconPanel" @ Info.IconPanel);
			Debug("info.IconPanel2" @ Info.IconPanel2);
			break;
		}
	}
}

function OnDBClickItem (string strID, int Index)
{
	local ItemInfo infItem;

	if ( (Left(strID,12) == "PetEquipItem") && (Index > -1) )
	{
		GetItemWindowHandle("PetWndClassic.PetWnd_Inventory." $ strID).GetItem(Index,infItem);
		API_C_EX_PET_UNEQUIP_ITEM(infItem.Id.ServerID);
	}
}

function OnRClickItem (string strID, int Index)
{
	OnDBClickItem(strID,Index);
}

function Clear ()
{
	txtLvName.SetText("");
	texPetHP.SetPoint(0,0);
	texPetMP.SetPoint(0,0);
	texPetExp.SetPointPercent(0,0,0);
	texPetFatigue.SetTooltipCustomType(MakeTooltipSimpleText("[0]/[0]"));
	texPetFatigue.SetPointPercent(0,0,0);
}

function ClearActionWnd ()
{
	PetActionWnd.Clear();
}

function HandlePetStatusClose ()
{
	Me.HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

function UpdatePetMP (string param)
{
	local int ServerID;
	local int currentMP;
	local int MP;
	local int maxMP;
	local PetInfo Info;

	ParseInt(param,"ServerID",ServerID);
	ParseInt(param,"CurrentMP",currentMP);
	if ( GetPetInfo(Info) )
	{
		if ( ServerID == Info.nServerID )
		{
			MP = currentMP;
			maxMP = Info.nMaxMP;
			texPetMP.SetPoint(MP,maxMP);
		}
	}
}

function UpdatePetHP (string param)
{
	local int ServerID;
	local int CurrentHP;
	local int Hp;
	local int MaxHP;
	local PetInfo Info;

	ParseInt(param,"ServerID",ServerID);
	ParseInt(param,"CurrentHP",CurrentHP);
	if ( GetPetInfo(Info) )
	{
		if ( ServerID == Info.nServerID )
		{
			Hp = CurrentHP;
			MaxHP = Info.nMaxHP;
			texPetHP.SetPoint(Hp,MaxHP);
		}
	}
}

function HandlePetInfoUpdate ()
{
	local string Name;
	local int Hp;
	local int MaxHP;
	local int MP;
	local int maxMP;
	local int Fatigue;
	local int MaxFatigue;
	local int Level;
	local int PhysicalAttack;
	local int PhysicalDefense;
	local int HitRate;
	local int CriticalRate;
	local int PhysicalAttackSpeed;
	local int MagicalAttack;
	local int MagicDefense;
	local int PhysicalAvoid;
	local int MovingSpeed;
	local int MagicCastingSpeed;
	local int SoulShotCosume;
	local int SpiritShotConsume;
	local int nEvolutionID;
	local int MagicalHitRate;
	local int MagicalAvoid;
	local int MagicalCritical;
	local INT64 nCurExp;
	local INT64 nMinExp;
	local INT64 nMaxExp;
	local PetInfo Info;
	local PetNameInfo NameInfo;
	local PetLookInfo LookInfo;

	if ( !Me.IsShowWindow() )
	{
		return;
	}
	if ( GetPetInfo(Info) )
	{
		if ( Info.PetOrSummoned != 2 )
		{
			return;
		}
		m_PetID = Info.nServerID;
		Level = Info.nLevel;
		Hp = Info.nCurHP;
		MaxHP = Info.nMaxHP;
		MP = Info.nCurMP;
		maxMP = Info.nMaxMP;
		Fatigue = Info.nFatigue;
		MaxFatigue = Info.nMaxFatigue;
		nCurExp = Info.nCurExp;
		nMinExp = Info.nMinExp;
		nMaxExp = Info.nMaxExp;
		nEvolutionID = Info.nEvolutionID;
		PhysicalAttack = Info.nPhysicalAttack;
		PhysicalDefense = Info.nPhysicalDefense;
		HitRate = Info.nHitRate;
		CriticalRate = Info.nCriticalRate;
		if(IsUseSkillCastingSpeedStat())
		{
			PhysicalAttackSpeed = Info.nPhysicalSkillCastingSpeed;			
		}
		else
		{
			PhysicalAttackSpeed = Info.nPhysicalAttackSpeed;
		}
		MagicalAttack = Info.nMagicalAttack;
		MagicDefense = Info.nMagicDefense;
		PhysicalAvoid = Info.nPhysicalAvoid;
		MovingSpeed = Info.nMovingSpeed;
		MagicCastingSpeed = Info.nMagicCastingSpeed;
		SoulShotCosume = Info.nSoulShotCosume;
		SpiritShotConsume = Info.nSpiritShotConsume;
		MagicalHitRate = Info.nMagicalHitRate;
		MagicalAvoid = Info.nMagicalAvoid;
		MagicalCritical = Info.nMagicalCritical;
		nEvolutionStep = Info.nEvolutionStep;
		nEvolvePetID = Info.nPetID;
		nPetLevel = Info.nLevel;
	}
	setEvolveStar(nEvolutionStep);
	Class'PetAPI'.static.GetPetEvolveLookInfo(Info.nEvolutionLook,LookInfo);
	if ( nEvolutionStep > 0 )
	{
		Class'PetAPI'.static.GetPetEvolveNameInfo(Info.nEvolutionNameID,NameInfo);
		Name = NameInfo.Name;
		Class'PetAPI'.static.GetPetEvolveNameInfo(Info.nEvolutionNamePrefixID,NameInfo);
		txtrandomName.SetText(NameInfo.Name @ Name);
		txtrandomName.SetTooltipText(NameInfo.Desc);
	} else {
		txtrandomName.SetText(GetSystemString(971));
		txtrandomName.SetTooltipText("");
	}
	Class'PetAPI'.static.GetPetEvolveLookInfo(Info.nEvolutionLook,LookInfo);
	txtrandomStatName.SetText(LookInfo.Name);
	txtrandomStatName.SetTooltipText(LookInfo.Desc);
	txtLvName.SetText(string(Level));
	txtPhysicalAttack.SetText(string(PhysicalAttack));
	txtPhysicalDefense.SetText(string(PhysicalDefense));
	txtHitRate.SetText(string(HitRate));
	txtCriticalRate.SetText(string(CriticalRate));
	txtPhysicalAttackSpeed.SetText(string(PhysicalAttackSpeed));
	txtMagicalAttack.SetText(string(MagicalAttack));
	txtMagicDefense.SetText(string(MagicDefense));
	txtPhysicalAvoid.SetText(string(PhysicalAvoid));
	txtMovingSpeed.SetText(string(MovingSpeed));
	txtMagicCastingSpeed.SetText(string(MagicCastingSpeed));
	txtSoulShotCosume.SetText(string(SoulShotCosume));
	txtSpiritShotConsume.SetText(string(SpiritShotConsume));
	txtMagicHit.SetText(string(MagicalHitRate));
	txtMagicAvoid.SetText(string(MagicalAvoid));
	txtMagicCritical.SetText(string(MagicalCritical));
	texPetHP.SetPoint(Hp,MaxHP);
	texPetMP.SetPoint(MP,maxMP);
	texPetExp.SetPointPercent(nCurExp,nMinExp,nMaxExp);
	texPetFatigue.SetTooltipText("[" $ string(Fatigue) $ "]/[" $ string(MaxFatigue) $ "]");
	texPetFatigue.SetPointPercent(Fatigue,0,MaxFatigue);
	EvolutionizedAction = nEvolutionID;
}

function HandlePetShow ()
{
	Clear();
	PlayConsoleSound(IFST_WINDOW_OPEN);
	Me.ShowWindow();
	Me.SetFocus();
	HandlePetInfoUpdate();
}

function HandleActionPetListStart ()
{
	HandlePetInfoUpdate();
	ClearActionWnd();
}

function HandlePetSkillList (string param)
{
	local int i;
	local int Count;
	local int ClassID;
	local int Level;
	local int ReuseDelayShareGroupID;
	local SkillInfo SkillInfo;
	local ItemInfo infItem;

	ParseInt(param,"Count",Count);
	Debug("HandlePetSkillList" @ param);

	for (i = 0; i < Count; i++ )
	{
		ParseInt(param,"ClassID_" $ string(i),ClassID);
		ParseInt(param,"Level_" $ string(i),Level);
		ParseInt(param,"ReuseDelayShareGroupID_" $ string(i),ReuseDelayShareGroupID);
		GetSkillInfo(ClassID,Level,0,SkillInfo);
		infItem.Id = GetItemID(ClassID);
		infItem.Level = SkillInfo.SkillLevel;
		infItem.SubLevel = 0;
		infItem.Name = SkillInfo.SkillName;
		infItem.IconName = SkillInfo.TexName;
		infItem.IconPanel = SkillInfo.IconPanel;
		infItem.Description = SkillInfo.SkillDesc;
		infItem.ShortcutType = 2;
		infItem.ReuseDelayShareGroupID = ReuseDelayShareGroupID;
		if ( SkillInfo.IconType == 8 )
		{
			infItem.ShortcutType = 7;
		}
		if ( SkillInfo.OperateType == 2 )
		{
			addPassiveSkill(infItem);
		} else {
			addActiveSkill(infItem);
		}
	}
}

function HandleActionPetList (string param)
{
	local int tmp;
	local string strActionName;
	local string strIconName;
	local string strDescription;
	local string strCommand;
	local int intClassID;
	local int nUsePetSkill;
	local ItemInfo infItem;

	ParseItemID(param,infItem.Id);
	ParseInt(param,"Type",tmp);
	ParseString(param,"Name",strActionName);
	ParseString(param,"IconName",strIconName);
	ParseString(param,"Description",strDescription);
	ParseString(param,"Command",strCommand);
	ParseInt(param,"ClassID",intClassID);
	ParseInt(param,"UsePetSkill",nUsePetSkill);
	infItem.Name = strActionName;
	infItem.IconName = strIconName;
	infItem.Description = strDescription;
	infItem.ShortcutType = 3;
	infItem.MacroCommand = strCommand;
	if ( nUsePetSkill == 0 )
	{
		PetActionWnd.AddItem(infItem);
	}
}

function HandlePetInventoryItemStart ()
{
	clearAllIEquip();
}

function HandlePetInventoryItemList (string param)
{
	local ItemInfo infItem;

	ParamToItemInfo(param,infItem);
	if ( !infItem.bEquipped )
	{
		return;
	}
	if ( infItem.bEquipped )
	{
		infItem.ForeTexture = PET_EQUIPPEDTEXTURE_NAME;
	}
	PetEquipItemUpdate(infItem);
}

function HandlePetInventoryItemUpdate (string param)
{
	local ItemInfo infItem;
	local int tmp;
	local EInventoryUpdateType WorkType;

	ParamToItemInfo(param,infItem);
	ParseInt(param,"WorkType",tmp);
	WorkType = EInventoryUpdateType(tmp);
	if ( !IsValidItemID(infItem.Id) )
	{
		return;
	}
	if ( infItem.bEquipped )
	{
		infItem.ForeTexture = PET_EQUIPPEDTEXTURE_NAME;
	}
	switch (WorkType)
	{
		case IVUT_ADD:
		case IVUT_UPDATE:
		PetEquipItemUpdate(infItem);
		break;
		case IVUT_DELETE:
		PetEquipItemUpdate(infItem,True);
		break;
	}
}

function int getLeftRightSlotBitType (int slotBitTypeLeft, int slotBitTypeRight, ItemInfo a_Info)
{
	local int itemNumL;
	local int itemNumR;
	local ItemInfo infoL;
	local ItemInfo InfoR;

	itemNumL = getSlotItemWindowBySlotBit(slotBitTypeLeft).GetItemNum();
	itemNumR = getSlotItemWindowBySlotBit(slotBitTypeRight).GetItemNum();
	if ( itemNumL + itemNumR > 0 )
	{
		if ( itemNumL > 0 )
		{
			getSlotItemWindowBySlotBit(slotBitTypeLeft).GetItem(0,infoL);
		}
		if ( itemNumR > 0 )
		{
			getSlotItemWindowBySlotBit(slotBitTypeRight).GetItem(0,InfoR);
		}
		if ( IsSameServerID(infoL.Id,a_Info.Id) )
		{
			return slotBitTypeLeft;
		} else {
			if ( IsSameServerID(InfoR.Id,a_Info.Id) )
			{
				return slotBitTypeRight;
			}
		}
	}
	if ( itemNumL <= 0 )
	{
		return slotBitTypeLeft;
	} else {
		if ( itemNumR <= 0 )
		{
			return slotBitTypeRight;
		}
	}
	return -1;
}

function PetEquipItemUpdate (ItemInfo a_Info, optional bool bDelete)
{
	local ItemWindowHandle hItemWnd;
	local int nTargetSlotBitType;
	local bool bEarSwap;
	local bool bFingerSwap;
	local ItemInfo tempInfo;

	Debug("a_Info.SlotBitType " @ string(a_Info.SlotBitType));
	switch (a_Info.SlotBitType)
	{
		case 32768:
		if ( bDelete )
		{
			PetEquipItem_Chest.Clear();
			PetEquipItem_Legs.Clear();
			PetEquipItem_Legs.EnableWindow();
		} else {
			PetEquipItem_Chest.Clear();
			PetEquipItem_Legs.Clear();
			a_Info.IconIndex = 1;
			PetEquipItem_Chest.AddItem(a_Info);
			a_Info.IconIndex = 2;
			PetEquipItem_Legs.AddItem(a_Info);
			PetEquipItem_Legs.DisableWindow();
		}
		break;
		case 2:
		case 4:
		case 6:
		nTargetSlotBitType = getLeftRightSlotBitType(4,2,a_Info);
		if ( nTargetSlotBitType == -1 )
		{
			hItemWnd = None;
		} else {
			hItemWnd = getSlotItemWindowBySlotBit(nTargetSlotBitType);
		}
		if ( (nTargetSlotBitType == 4) && bDelete )
		{
			bEarSwap = True;
		}
		break;
		case 16:
		case 32:
		case 48:
		nTargetSlotBitType = getLeftRightSlotBitType(32,16,a_Info);
		if ( nTargetSlotBitType == -1 )
		{
			hItemWnd = None;
		} else {
			hItemWnd = getSlotItemWindowBySlotBit(nTargetSlotBitType);
		}
		if ( (nTargetSlotBitType == 32) && bDelete )
		{
			bFingerSwap = True;
		}
		break;
		default:
			hItemWnd = getSlotItemWindowBySlotBit(a_Info.SlotBitType);
			break;
	}
	if ( (None != hItemWnd) && a_Info.SlotBitType != 32768 )
	{
		hItemWnd.Clear();
		if (	!bDelete )
		{
			hItemWnd.AddItem(a_Info);
		}
		if ( bEarSwap )
		{
			getSlotItemWindowBySlotBit(6).GetItem(0,tempInfo);
			getSlotItemWindowBySlotBit(6).Clear();
			if ( tempInfo.Id.ClassID > 0 )
			{
				hItemWnd.Clear();
				hItemWnd.AddItem(tempInfo);
			}
		} else {
			if ( bFingerSwap )
			{
				getSlotItemWindowBySlotBit(16).GetItem(0,tempInfo);
				getSlotItemWindowBySlotBit(16).Clear();
				if ( tempInfo.Id.ClassID > 0 )
				{
					hItemWnd.Clear();
					hItemWnd.AddItem(tempInfo);
				}
			}
		}
	}
	// End:0x34C
	if(PetEquipItem_Chest.GetItemNum() == 0)
	{
		PetEquipItem_Legs.EnableWindow();		
	}
	else
	{
		// End:0x38A
		if(PetEquipItem_Chest.GetItem(0, tempInfo))
		{
			// End:0x38A
			if(tempInfo.SlotBitType != 32768)
			{
				PetEquipItem_Legs.EnableWindow();
			}
		}
	}
}

function ItemWindowHandle getSlotItemWindowBySlotBit(INT64 slotbit)
{
	switch (slotbit)
	{
		case 1:
			return PetEquipItem_Underwear;
		case 16384:
		case 128:
		return PetEquipItem_RHand;
		case 32768:
		case 1024:
		return PetEquipItem_Chest;
		case 8:
		return PetEquipItem_Neck;
		case 2048:
		return PetEquipItem_Legs;
		case 512:
		return PetEquipItem_Gloves;
		case 4096:
		return PetEquipItem_Feet;
		case 64:
		return PetEquipItem_Head;
		case 32:
		return PetEquipItem_LFinger;
		case 16:
		return PetEquipItem_RFinger;
		case 4:
		return PetEquipItem_LEar;
		case 2:
		return PetEquipItem_REar;
	}
	return PetEquipItem_REar;
}

function ItemWindowHandle getSlotItemWindowByItemWindowName (string slotName)
{
	return getSlotItemWindowBySlotType(getSlotTypeBySlotItemWindowName(slotName));
}

function API_C_EX_PET_EQUIP_ITEM (int nItemServerId)
{
	local array<byte> stream;
	local UIPacket._C_EX_PET_EQUIP_ITEM packet;

	packet.nItemServerId = nItemServerId;
	if (	!Class'UIPacket'.static.Encode_C_EX_PET_EQUIP_ITEM(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PET_EQUIP_ITEM,stream);
	Debug("----> Api Call : C_EX_PET_EQUIP_ITEM" @ string(nItemServerId));
}

function API_C_EX_PET_UNEQUIP_ITEM (int nItemServerId)
{
	local array<byte> stream;
	local UIPacket._C_EX_PET_UNEQUIP_ITEM packet;

	if ( nItemServerId <= 0 )
	{
		Debug(" Api Call Error : C_EX_PET_UNEQUIP_ITEM, ServerID is wrong" @ string(nItemServerId));
		return;
	}
	packet.nItemServerId = nItemServerId;
	if (	!Class'UIPacket'.static.Encode_C_EX_PET_UNEQUIP_ITEM(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PET_UNEQUIP_ITEM,stream);
	Debug("----> Api Call : C_EX_PET_UNEQUIP_ITEM" @ string(nItemServerId));
}

function API_C_EX_EVOLVE_PET (optional int cDummy)
{
	local array<byte> stream;
	local UIPacket._C_EX_EVOLVE_PET packet;

	packet.cDummy = cDummy;
	if (	!Class'UIPacket'.static.Encode_C_EX_EVOLVE_PET(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_EVOLVE_PET,stream);
	Debug("----> Api Call : C_EX_EVOLVE_PET" @ string(cDummy));
}

function clearAllIEquip ()
{
	local int i;

	for ( i = 0; i < 12; i++ )
	{
		getSlotItemWindowBySlotType(i).Clear();
	}
}

function setEvolveStar (int nEvolStep)
{
	local array<EvolveCondition> EvolveConditionArr;
	local array<RequestItem> RequestItemArr;
	local int i;
	local bool bEvolveCondition;

	GetTextureHandle("PetWndClassic.PetClassicInfoWnd.EvolveStar00_Tex").HideWindow();
	GetTextureHandle("PetWndClassic.PetClassicInfoWnd.EvolveStar01_Tex").HideWindow();
	GetTextureHandle("PetWndClassic.PetClassicInfoWnd.EvolveStar02_Tex").HideWindow();
	switch (nEvolStep)
	{
		case 2:
		GetTextureHandle("PetWndClassic.PetClassicInfoWnd.EvolveStar02_Tex").ShowWindow();
		case 1:
		GetTextureHandle("PetWndClassic.PetClassicInfoWnd.EvolveStar01_Tex").ShowWindow();
		case 0:
		GetTextureHandle("PetWndClassic.PetClassicInfoWnd.EvolveStar00_Tex").ShowWindow();
		default:
	}
	Class'PetAPI'.static.GetPetEvolveCondition(nEvolvePetID,nEvolStep + 1,EvolveConditionArr,RequestItemArr);
	
	for ( i = 0;i < EvolveConditionArr.Length;i++ )
	{
		if ( EvolveConditionArr[i].ConditionType == 1 )
		{
			if ( EvolveConditionArr[i].Value <= nPetLevel )
			{
				bEvolveCondition = True;
			}
		}
	}
	if ( bEvolveCondition )
	{
		Evolve_BTN.EnableWindow();
	} else {
		Evolve_BTN.DisableWindow();
	}
}

function setRandomPetName (string nameStr, string statName)
{
	txtrandomName.SetText(nameStr);
	txtrandomStatName.SetText(statName);
}

function ItemWindowHandle getSlotItemWindowBySlotType (int hSlotType)
{
	switch (hSlotType)
	{
		case 0:
			return PetEquipItem_RHand;
		case 1:
			return PetEquipItem_Chest;
		case 2:
			return PetEquipItem_Neck;
		case 3:
			return PetEquipItem_Legs;
		case 4:
			return PetEquipItem_Gloves;
		case 5:
			return PetEquipItem_Feet;
		case 6:
			return PetEquipItem_Head;
		case 7:
			return PetEquipItem_LFinger;
		case 8:
			return PetEquipItem_RFinger;
		case 9:
			return PetEquipItem_LEar;
		case 10:
			return PetEquipItem_REar;
		case 11:
			return PetEquipItem_Underwear;
	}
	return PetEquipItem_REar;
}

function int getSlotTypeBySlotItemWindowName (string itemWndStr)
{
	switch (itemWndStr)
	{
		case "PetEquipItem_RHand":
			return 0;
		case "PetEquipItem_Chest":
			return 1;
		case "PetEquipItem_Neck":
			return 2;
		case "PetEquipItem_Legs":
			return 3;
		case "PetEquipItem_Gloves":
			return 4;
		case "PetEquipItem_Feet":
			return 5;
		case "PetEquipItem_Head":
			return 6;
		case "PetEquipItem_LFinger":
			return 7;
		case "PetEquipItem_RFinger":
			return 8;
		case "PetEquipItem_LEar":
			return 9;
		case "PetEquipItem_REar":
			return 10;
		case "PetEquipItem_Underwear":
			return 11;
	}
	return -1;
}

function OnReceivedCloseUI ()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if ( GetWindowHandle("PetSkillLearnWnd").IsShowWindow() )
	{
		GetWindowHandle("PetSkillLearnWnd").HideWindow();
	} else {
		GetWindowHandle(m_WindowName).HideWindow();
	}
}

defaultproperties
{
     m_WindowName="PetWndClassic"
}
